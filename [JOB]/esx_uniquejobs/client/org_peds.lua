-- Pads (ped models).
--   OpenPadPickMenu(): the pads you may wear now (+ Reset). Used by /pad and the cloakrooms.
--   OpenPadAdminMenu(): manage pads. Government: add, remove for everybody, restore,
--                       on/off, rank. An organisation's boss: rank of its own pads only.

local function setPed(model)
    local hash = GetHashKey(model)
    RequestModel(hash)
    local tries = 0
    while not HasModelLoaded(hash) and tries < 100 do Wait(50) tries = tries + 1 end
    if not HasModelLoaded(hash) then return ESX.ShowNotification('Model load nashod.') end
    SetPlayerModel(PlayerId(), hash)
    SetPedDefaultComponentVariation(PlayerPedId())
    SetModelAsNoLongerNeeded(hash)
end

-- back to the player's own character (the same skin the citizen wear uses)
function ResetPadModel()
    ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin)
        if skin then TriggerEvent('skinchanger:loadSkin', skin) end
    end)
end

function OpenPadPickMenu()
    ESX.TriggerServerCallback('OrgPeds:Mine', function(list)
        local elements = {}
        for _, ped in ipairs(list) do table.insert(elements, { label = ped, value = ped }) end
        table.insert(elements, { label = 'Reset pad (lebas shakhsi)', value = '__reset' })
        if #list == 0 then
            ESX.ShowNotification('Pad-i baraye shoma faal nist.')
        end
        ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'org_pad_pick', {
            title = 'Pad', align = 'top-left', elements = elements,
        }, function(data, menu)
            menu.close()
            if data.current.value == '__reset' then return ResetPadModel() end
            setPed(data.current.value)
        end, function(_, menu) menu.close() end)
    end)
end

-- the pad list of one organisation, with what the caller may do to each pad
local function openPadListFor(job, isGov, chosen)
    ESX.TriggerServerCallback('OrgPeds:List', function(peds)
        local els = {}
        if isGov then
            table.insert(els, { label = '+ Ezafe kardan pad (esm model)', value = '__add' })
        end
        for _, p in ipairs(peds) do
            local onOff = isGov and (p.enabled and 'ON' or 'OFF') or ''
            table.insert(els, { label = ('%s | %s | rank>=%d'):format(p.ped, onOff, p.min_grade), value = p.ped, info = p })
        end
        local function show(list)
            ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'org_pad_list', {
                title = chosen .. ' pads', align = 'top-left', elements = list,
            }, function(d2, m2)
                local v = d2.current.value
                if v == '__add' then
                    m2.close()
                    return ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'org_pad_add', { title = 'Esm model pad (mesl: s_m_m_ciasec_01)' }, function(d5, m5)
                        m5.close()
                        TriggerServerEvent('org_peds:add', chosen, d5.value)
                    end, function(_, m5) m5.close() end)
                end
                if type(v) == 'string' and v:sub(1, 9) == '__restore' then
                    m2.close()
                    return TriggerServerEvent('org_peds:restore', chosen, v:sub(11))
                end
                local info = d2.current.info
                m2.close()
                local acts = {}
                if isGov then
                    table.insert(acts, { label = info.enabled and 'Khamoosh kon' or 'Roshan kon', value = 'toggle' })
                    table.insert(acts, { label = 'Hazf baraye hame', value = 'remove' })
                end
                table.insert(acts, { label = 'Taghir rank (adad)', value = 'rank' })
                ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'org_pad_act', {
                    title = info.ped, align = 'top-left', elements = acts,
                }, function(d3, m3)
                    m3.close()
                    local a = d3.current.value
                    if a == 'remove' then
                        TriggerServerEvent('org_peds:remove', chosen, info.ped)
                    elseif a == 'toggle' then
                        TriggerServerEvent('org_peds:set', chosen, info.ped, not info.enabled, nil)
                    else
                        ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'org_pad_rank', { title = 'Minimum rank (0-10)' }, function(d4, m4)
                            m4.close()
                            TriggerServerEvent('org_peds:set', chosen, info.ped, nil, tonumber(d4.value) or 0)
                        end, function(_, m4) m4.close() end)
                    end
                end, function(_, m3) m3.close() end)
            end, function(_, m2) m2.close() end)
        end
        if isGov then
            ESX.TriggerServerCallback('OrgPeds:Hidden', function(hidden)
                for _, h in ipairs(hidden) do
                    table.insert(els, { label = ('[HAZF SHODE] %s - bargardan'):format(h), value = '__restore:' .. h })
                end
                show(els)
            end, chosen)
        else
            if #els == 0 then return ESX.ShowNotification('Pad-i baraye in ergan tarif nashode.') end
            show(els)
        end
    end, chosen)
end

function OpenPadAdminMenu()
    local jd = UJLiveJobData()
    local job = jd and jd.name
    local isGov = (job == 'government')
    local jobs = {}
    if isGov then
        for _, d in ipairs(Departments or {}) do
            if d.id ~= 'gov' then for _, j in ipairs(d.jobs) do table.insert(jobs, j) end end
        end
        table.insert(jobs, 'government')
    elseif job then
        table.insert(jobs, job)
    end
    if #jobs == 0 then return end

    local elements = {}
    for _, j in ipairs(jobs) do table.insert(elements, { label = j, value = j }) end
    ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'org_pad_job', {
        title = 'Pad - ergan', align = 'top-left', elements = elements,
    }, function(d, m)
        m.close()
        openPadListFor(job, isGov, d.current.value)
    end, function(_, m) m.close() end)
end

-- The cloakroom's Pad entry: everybody can wear; the boss of an organisation (and
-- Government) also gets the rank access of its pads.
local function canManagePads()
    local pd = UJLiveJobData()
    if not pd then return false end
    if pd.name == 'government' then return true end
    return pd.grade_name == 'boss'
end

function OpenPadHub()
    local elements = {
        { label = 'Pad ha (pushidan)', value = 'wear' },
    }
    if canManagePads() then
        table.insert(elements, { label = 'Modiriyat pad (dastresi rank)', value = 'admin' })
    end
    ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'org_pad_hub', {
        title = 'Pad', align = 'top-left', elements = elements,
    }, function(data, menu)
        menu.close()
        if data.current.value == 'wear' then return OpenPadHub() end
        OpenPadAdminMenu()
    end, function(_, menu) menu.close() end)
end

-- Each organisation's boss action menu gets a "Pad - dastresi rank" entry.
local PadJobs = { 'cid', 'cia', 'marshal', 'fbi', 'judge', 'doa', 'police', 'sheriff', 'mt',
                  'taxi', 'mechanic', 'ambulance', 'weazel' }

RegisterNetEvent('org_peds:bossPads')
AddEventHandler('org_peds:bossPads', function()
UJLog('CLIENT', ('org_peds:bossPads '):format())
    OpenPadAdminMenu()
end)

CreateThread(function()
    Wait(3000)
    for _, job in ipairs(PadJobs) do
        TriggerEvent('esx_society:registerBossExtra', job, 'pads', 'Pad - dastresi rank', 'org_peds:bossPads')
    end
end)
