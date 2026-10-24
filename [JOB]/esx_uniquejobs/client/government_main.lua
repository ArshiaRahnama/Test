-- make sure ESX is ready in this file (the other job files set it too, but not always first)
if ESX == nil then
    CreateThread(function()
        while ESX == nil do
            TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
            Wait(100)
        end
    end)
end

-- ON/OFF for blips: every organisation blip is tracked by its job. When the
-- organisation is OFF its blips are hidden (for everybody); when ON they show.
OrgBlips = OrgBlips or {}

function TrackOrgBlip(job, blip)
    if not blip then return end
    OrgBlips[job] = OrgBlips[job] or {}
    table.insert(OrgBlips[job], blip)
    if OrgState[job] == false then SetBlipDisplay(blip, 0) end
end

CreateThread(function()
    while true do
        Wait(2000)
        for job, list in pairs(OrgBlips) do
            local display = (OrgState[job] == false) and 0 or 2
            for i = #list, 1, -1 do
                local b = list[i]
                if DoesBlipExist(b) then
                    SetBlipDisplay(b, display)
                else
                    table.remove(list, i)
                end
            end
        end
    end
end)

-- Government can do everything every job can do: this is THE job check used by the
-- organisation menus (the job-name checks in the job files all go through it).
OrgState = OrgState or {}

-- ROOT CAUSE of the F6 / spawn-blip bugs: cid, mt, police and sheriff each declare their
-- own `local PlayerData`, so the global PlayerData seen here was a different, stale table.
-- The job is therefore always read live from ESX (the framework's own copy).
function UJLiveJobData()
    local d = ESX and ESX.GetPlayerData and ESX.GetPlayerData() or nil
    if d and d.job then return d.job end
    return PlayerData and PlayerData.job or nil
end

function IsJobOrGov(job)
    local jd = UJLiveJobData()
    local j = jd and jd.name
    if j == 'government' then return true end
    if j == job and OrgState[job] == false then return false end
    return j == job
end

RegisterNetEvent('org_state:sync')
AddEventHandler('org_state:sync', function(state) OrgState = state or {} end)

RegisterNetEvent('org_state:changed')
AddEventHandler('org_state:changed', function(job, enabled) OrgState[job] = enabled end)

CreateThread(function()
    Wait(2000)
    TriggerServerEvent('org_state:request')
end)

local function openGovSetJob()
    ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'gov_setjob_id', { title = 'ID player' }, function(d1, m1)
        m1.close()
        local target = tonumber(d1.value)
        if not target then return ESX.ShowNotification('ID na-motabar.') end
        ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'gov_setjob_job', { title = 'Job (mesl: cid, police, taxi, government)' }, function(d2, m2)
            m2.close()
            ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'gov_setjob_grade', { title = 'Grade (adad)' }, function(d3, m3)
                m3.close()
                TriggerServerEvent('gov_admin:setJob', target, d2.value, tonumber(d3.value) or 0)
            end, function(_, m3) m3.close() end)
        end, function(_, m2) m2.close() end)
    end, function(_, m1) m1.close() end)
end

local openGovRequests

local function openGovBoss()
    ESX.TriggerServerCallback('GovAdmin:OnlineCounts', function(counts)
        local lines = {}
        for _, d in ipairs(Departments or {}) do
            if d.id ~= 'gov' then
                local total = 0
                for _, j in ipairs(d.jobs) do total = total + (counts[j] or 0) end
                table.insert(lines, { label = ('%s: %d online'):format(d.label, total), value = 'noop', disabled = true })
            end
        end
        local elements = {
            { label = '--- Vaziyat ergan-ha ---', value = 'noop', disabled = true },
        }
        for _, l in ipairs(lines) do table.insert(elements, l) end
        table.insert(elements, { label = '--- Modiriyat ---', value = 'noop', disabled = true })
        table.insert(elements, { label = 'ON / OFF ergan-ha', value = '__org_switch' })
        table.insert(elements, { label = 'Taghir job player', value = '__gov_setjob' })
        table.insert(elements, { label = 'Taghir esm rank', value = '__gov_rank' })
        table.insert(elements, { label = 'Darkhast-ha (hame ergan-ha)', value = '__gov_requests' })
        table.insert(elements, { label = 'Pad va rank (hame ergan-ha)', value = '__gov_pads' })
        table.insert(elements, { label = 'Payam be hame ergan-ha', value = '__gov_broadcast' })
        table.insert(elements, { label = '--- Chat ---', value = 'noop', disabled = true })
        table.insert(elements, { label = '/fdoj /flaw /fservices: payam be ergan', value = 'noop', disabled = true })
        table.insert(elements, { label = '/f: payam be ergan-e khod', value = 'noop', disabled = true })
        table.insert(elements, { label = '/dep: payam dapartman', value = 'noop', disabled = true })
        table.insert(elements, { label = '/mp: payam shik', value = 'noop', disabled = true })

        ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'government_boss', {
            title = 'Government Boss Action', align = 'top-left', elements = elements,
        }, function(data, menu)
            local v = data.current.value
            if v == '__org_switch' then menu.close() return openOrgSwitches() end
            if v == '__gov_setjob' then menu.close() return openGovSetJob() end
            if v == '__gov_rank' then menu.close() return openGovRename() end
            if v == '__gov_requests' then menu.close() return openGovRequests() end
            if v == '__gov_pads' then menu.close() return OpenPadAdminMenu() end
            if v == '__gov_broadcast' then
                menu.close()
                ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'gov_broadcast_text', { title = 'Matn payam' }, function(d, m)
                    m.close()
                    TriggerServerEvent('gov_admin:broadcast', d.value)
                end, function(_, m) m.close() end)
            end
        end, function(_, menu) menu.close() end)
    end)
end

function openGovRequests()
    ESX.TriggerServerCallback('GovRequests:List', function(list)
        local elements = {}
        if #list == 0 then
            table.insert(elements, { label = 'Darkhast-i nist', value = 'none', disabled = true })
        end
        for _, r in ipairs(list) do
            table.insert(elements, { label = ('[%s] %s - %s'):format(string.upper(r.org), r.name, r.reason), value = r.id, req = r })
        end
        ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'gov_requests', {
            title = 'Darkhast-ha', align = 'top-left', elements = elements,
        }, function(data, menu)
            if not data.current.req then return end
            local c = data.current.req.coord
            SetNewWaypoint(c.x, c.y)
            ESX.ShowNotification(('Waypoint bara %s gozashte shod.'):format(data.current.req.name))
        end, function(_, menu) menu.close() end)
    end)
end

local function openGovRename()
    ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'gov_rank_job', { title = 'Job (mesl: cid)' }, function(d1, m1)
        m1.close()
        ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'gov_rank_grade', { title = 'Grade (adad)' }, function(d2, m2)
            m2.close()
            ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'gov_rank_label', { title = 'Esm jadid rank' }, function(d3, m3)
                m3.close()
                TriggerServerEvent('gov_admin:renameGrade', d1.value, tonumber(d2.value) or 0, d3.value)
            end, function(_, m3) m3.close() end)
        end, function(_, m2) m2.close() end)
    end, function(_, m1) m1.close() end)
end

local function openOrgSwitches()
    local elements = {}
    local lastDept
    for _, d in ipairs(Departments or {}) do
        if d.id ~= 'gov' then
            table.insert(elements, { label = '--- ' .. d.label .. ' ---', value = 'noop', disabled = true })
            for _, j in ipairs(d.jobs) do
                local on = OrgState[j] ~= false
                table.insert(elements, { label = ('%s: %s'):format(j, on and 'ROSHAN (klik = khamoosh)' or 'KHAMOOSH (klik = roshan)'), value = j, on = on })
            end
        end
    end
    ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'government_org_switch', {
        title = 'ON / OFF Ergan-ha', align = 'top-left', elements = elements,
    }, function(data, menu)
        if data.current.value == 'noop' then return end
        TriggerServerEvent('org_state:toggle', data.current.value, not data.current.on)
        menu.close()
    end, function(_, menu) menu.close() end)
end


-- Government (department "gov"): one F6 that opens every organisation's F6 menu.
-- The per-job menus are global functions in their own client files; this file only
-- lists them and calls the one that was picked. Government sees all departments.

local GovMenus = {
    { dept = 'Department Of Justice', label = 'CID',          fn = 'OpenMTActionsMenu_cid' },
    { dept = 'Department Of Justice', label = 'CIA',          fn = 'OpenciaActionsMenu_cia' },
    { dept = 'Department Of Justice', label = 'Marshal',      fn = 'OpenMarshalActionsMenu_marshal' },
    { dept = 'Department Of Justice', label = 'FBI',          fn = 'OpenfbiActionsMenu_fbi' },
    { dept = 'Department Of Justice', label = 'Judge',        fn = 'OpenjudgeActionsMenu_judge' },
    { dept = 'Department Of Justice', label = 'DOA',          fn = 'OpendoaActionsMenu_doa' },
    { dept = 'Law Enforcement',       label = 'Police',       fn = 'OpenPoliceActionsMenu_police' },
    { dept = 'Law Enforcement',       label = 'Sheriff',      fn = 'OpensheriffActionsMenu_sheriff' },
    { dept = 'Law Enforcement',       label = 'MT',           fn = 'OpenMTActionsMenu_mt' },
    { dept = 'Organ Services',        label = 'Taxi', fn = 'OpenMobileTaxiActionsMenu_taxi' },
    { dept = 'Organ Services',        label = 'Mechanic',     fn = 'OpenMobileMechanicActionsMenu_mechanic' },
    { dept = 'Organ Services',        label = 'Medic',        fn = 'OpenMobileAmbulanceActionsMenu_ambulance' },
    { dept = 'Government',            label = 'Government Boss Action', fn = '__gov_boss' },
}

-- ── Backspace behaviour for the Government F6 ───────────────────────────────
-- Inside the Government chain: Backspace on a deeper menu goes back ONE page;
-- Backspace on the first page closes the chain. Outside the chain nothing changes.
GovChainActive = false
GovStack = {}
local govOrigOpen = nil

local function installGovStack()
    if govOrigOpen or not ESX or not ESX.UI or not ESX.UI.Menu then return end
    govOrigOpen = ESX.UI.Menu.Open
    ESX.UI.Menu.Open = function(ns, res, name, data, submit, cancel)
        local live = ESX and ESX.GetPlayerData and ESX.GetPlayerData() or nil
        if not GovChainActive or not live or not live.job or live.job.name ~= 'government' then
            return govOrigOpen(ns, res, name, data, submit, cancel)
        end
        table.insert(GovStack, { ns = ns, res = res, name = name, data = data, submit = submit, cancel = cancel })
        local wrapped = function(d, m)
            table.remove(GovStack)                 -- this page is left
            local prev = table.remove(GovStack)    -- the page before it
            if prev then
                UJLog('GOV_BACK', 'back to ' .. tostring(prev.name))
                return ESX.UI.Menu.Open(prev.ns, prev.res, prev.name, prev.data, prev.submit, prev.cancel)
            end
            GovChainActive = false
            GovStack = {}
            UJLog('GOV_BACK', 'chain closed')
            if cancel then cancel(d, m) elseif m and m.close then m.close() end
        end
        return govOrigOpen(ns, res, name, data, submit, wrapped)
    end
end

CreateThread(function()
    while ESX == nil do Wait(200) end
    installGovStack()
end)

AddEventHandler('esx:setJob', function(job)
    -- do NOT touch PlayerData here: each job file compares it with the new job in its own
    -- esx:setJob handler, and a changed copy would stop that job's threads (F6, spawn blips).
    GovChainActive = false
    GovStack = {}
    UJLog('JOB', 'job changed -> ' .. tostring(job and job.name))
end)

local function openGovMenu()
    local elements = {}
    local lastDept
    for _, m in ipairs(GovMenus) do
        if m.dept ~= lastDept then
            table.insert(elements, { label = '--- ' .. m.dept .. ' ---', value = 'noop', disabled = true })
            lastDept = m.dept
        end
        table.insert(elements, { label = m.label, value = m.fn })
    end
    GovChainActive = true
    GovStack = {}
    ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'government_f6', {
        title = 'Government', align = 'top-left', elements = elements,
    }, function(data, menu)
        if data.current.value == 'noop' then return end
        local fn = _G[data.current.value]
        UJLog('GOV_MENU', 'selected=' .. tostring(data.current.value))
        if data.current.value == '__org_switch' then fn = nil end
        if data.current.value == '__org_switch' then
            menu.close()
            return openOrgSwitches()
        end
        if data.current.value == '__gov_setjob' then
            menu.close()
            return openGovSetJob()
        end
        if data.current.value == '__gov_rank' then
            menu.close()
            return openGovRename()
        end
        if data.current.value == '__gov_requests' then
            menu.close()
            return openGovRequests()
        end
        if data.current.value == '__gov_boss' then
            menu.close()
            return openGovBoss()
        end
        if type(fn) ~= 'function' then
            return ESX.ShowNotification('In menu baraye in ergan peyda nashod.')
        end
        menu.close()
        local ok, err = pcall(fn)
        if not ok then ESX.ShowNotification('Khata dar menu: ' .. tostring(err)) end
    end, function(_, menu) menu.close() end)
end

CreateThread(function()
    while true do
        Wait(0)
        local pdata = ESX and ESX.GetPlayerData and ESX.GetPlayerData() or nil
        local job = pdata and pdata.job and pdata.job.name
        if job == 'government' and IsControlJustReleased(0, 167) and ESX then
            UJLog('GOV_F6', 'F6 pressed, job=' .. tostring(job))
            local open = ESX.UI.Menu.IsOpen and ESX.UI.Menu.IsOpen('default', GetCurrentResourceName(), 'government_f6')
            UJLog('GOV_F6', 'government_f6 already open=' .. tostring(open))
            if not open then
                local ok, err = pcall(openGovMenu)
                if not ok then print('[government F6] ' .. tostring(err)) end
            end
        end
    end
end)

-- /menufix: if a menu got stuck (F6 does nothing, no error), this closes every menu
-- and clears the Government Backspace chain.
RegisterCommand('menufix', function()
    if ESX and ESX.UI and ESX.UI.Menu and ESX.UI.Menu.CloseAll then
        ESX.UI.Menu.CloseAll()
    end
    GovChainActive = false
    GovStack = {}
    UJLog('MENUFIX', 'all menus closed, chain reset')
    if ESX and ESX.ShowNotification then ESX.ShowNotification('Menu ha reset shodand.') end
end, false)
