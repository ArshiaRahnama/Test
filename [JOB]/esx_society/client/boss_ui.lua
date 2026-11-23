--[[ Boss UI (Sunset-style NUI) | esx_society/client/boss_ui.lua
    Same permissions and the same server calls as the classic boss menu (client/main.lua), just a nicer face:
      tabs       : Home (money, deposit/withdraw, branch change) | Members (+ swap) | Ranks (+ permissions) | Salary
                   Locker access (weapons + items, per rank and per division) | Vehicles | Divisions | Outfits
      Logs       : launcher for the LogPanel resource (boss only)
      Home extras: dispatch priority (taxi/mechanic/ambulance), Society Pay, Paintball access, BossExtras[] entries
    So the classic menu (Left Shift) is no longer needed for anything except `options.wash`.
    Entry point: OpenBossMenu() in main.lua calls OpenJobBossMenu(). This UI + client/boss_ui_more.lua replace the whole
    classic menu (Config.BossUI = false brings the old one back).
    Colour: /chatsetting -> Menus -> Boss Action.
]]

local currentSociety, currentOptions, currentClose = nil, nil, nil
local uiOpen = false
local menuColors = {
    primary   = GetResourceKvpString('unique_boss_primary')   or '#b91c1c',
    secondary = GetResourceKvpString('unique_boss_secondary') or '#ef4444',
}

local function nui(payload)
    payload._bossUI = true                       -- html/index.html routes this ONLY to the boss iframe
    SendNUIMessage(payload)
end

-- runClose = true when the player simply closes the menu: the job script's `close` closure must run
-- (classic menu does this), otherwise the E key stays dead until the player leaves and re-enters the marker.
local function hideUI(runClose)
    uiOpen = false
    SetNuiFocus(false, false)
    nui({ type = 'hide' })
    if runClose then
        if type(currentClose) == 'function' then
            local ok, err = pcall(currentClose)
            if not ok then print(('^1[esx_society]^0 boss UI close callback error: %s'):format(tostring(err))) end
        end
        currentClose = nil
    end
end

AddEventHandler('unique_menu:settings', function(s)
    if type(s) == 'table' and type(s.boss) == 'table' then
        menuColors = {
            primary   = s.boss.colorPrimary or s.boss.color or menuColors.primary,
            secondary = s.boss.color or menuColors.secondary,
        }
        SetResourceKvp('unique_boss_primary', menuColors.primary)
        SetResourceKvp('unique_boss_secondary', menuColors.secondary)
        if uiOpen then nui({ type = 'colors', colors = menuColors }) end
    end
end)

-- extras registry: boss_ui_more.lua (or any other script) can add buttons to the Home tab's extras card.
--   BossUI.addExtra({ key, label = string | function(ctx), show = function(ctx) -> bool, run = function(ctx), reopen = bool })
BossUI = { extras = {} }
local lastCtx = nil
function BossUI.addExtra(def) BossUI.extras[#BossUI.extras + 1] = def end

-- promise wrapper: value1, value2... = sc('callback', args...)
local function sc(name, ...)
    local p, args = promise.new(), { ... }
    ESX.TriggerServerCallback(name, function(...) p:resolve({ ... }) end, table.unpack(args))
    return table.unpack(Citizen.Await(p))
end

BossUI.sc = sc

local function gradeLabel(job, g)
    return (g.label and g.label ~= '' and g.label) or job.label
end

-- run `fn(society)` outside the NUI (ox_lib menus/dialogs), then bring the Boss UI back
function BossUI.flow(fn)
    local soc, close, opts = currentSociety, currentClose, currentOptions
    hideUI()                                   -- keeps the job script's close() for when the UI finally closes
    CreateThread(function()
        local ok, err = pcall(fn, soc)
        if not ok then print(('^1[esx_society]^0 boss UI flow error: %s'):format(tostring(err))) end
        Wait(150)
        OpenJobBossMenu(soc, close, opts)
    end)
end

local function IsDispatchJob(soc)
    for _, j in ipairs(Config.DispatchQueueJobs or {}) do
        if j == soc then return true end
    end
    return false
end

-- -------------------------------------------------------------- data for the 'show' message ---
local function buildData(soc, options)
    local pd = ESX.PlayerData
    local job = pd.job
    local isBoss = job.grade_name == 'boss' or job.name == 'government'
    local law = job.name == 'police' or job.name == 'sheriff' or job.name == 'mt'
    -- same thresholds as the classic menu (grade >= 10, law jobs >= 16, or the real boss)
    local canView = ((job.grade >= 10 or job.name == 'government') or isBoss)
        and (not law or (job.grade >= 16 or job.name == 'government') or isBoss)

    local jobInfo = sc('esx_society:getJob', soc)
    if not jobInfo then return { ok = false } end

    local money = canView and sc('esx_society:getSocietyMoney', soc) or 0
    local employees = (canView and options.employees ~= false) and sc('esx_society:getEmployees', soc) or {}
    local stats = sc('esx_society:bossStats', soc) or {}

    local miliOptions = {}
    if (job.grade >= 10 or job.name == 'government') and type(GetBranchSiblings) == 'function' then
        local siblings = GetBranchSiblings(job.name)
        for _, j in ipairs(siblings or {}) do
            miliOptions[#miliOptions + 1] = {
                type = j,
                label = (Config.JobDisplayLabels and Config.JobDisplayLabels[j]) or j,
            }
        end
    end

    local grades = {}
    for _, g in ipairs(jobInfo.grades or {}) do grades[#grades + 1] = g end

    local result = {
        ok = true,
        society = soc,
        jobLabel = jobInfo.label or soc,
        job = soc,
        grades = grades,
        money = tonumber(money) or 0,
        memberCount = #employees,
        onlineCount = stats.online or 0,
        canDeposit = options.deposit ~= false,
        canWithdraw = options.withdraw ~= false and canView and (tonumber(pd.perm) or 0) >= 15,
        canManageMember = options.employees ~= false and canView,
        canManageGrade = options.job ~= false and canView,
        canSalary = options.job ~= false and canView and (tonumber(pd.perm) or 0) >= 9,
        miliOptions = miliOptions,
        -- boss-only tabs: the server re-checks isPlayerBoss on every setter, so non-bosses never see them
        canInventory = options.job ~= false and canView and isBoss,
        canArmory    = options.job ~= false and canView and isBoss and job.name ~= 'uwucafe' and not (BossUI.noWeapon and BossUI.noWeapon[job.name]),
        canVehicle   = options.job ~= false and canView and isBoss and job.name ~= 'uwucafe',
        canDivision  = options.job ~= false and canView and isBoss,
        canOutfit    = options.job ~= false and canView and isBoss,
        canLog = isBoss,                       -- launcher for the LogPanel resource
        canDispatch = isBoss and soc == job.name and IsDispatchJob(soc),
        dispatchStatus = false,                -- filled below (true = priority by distance, false = queue order)
        extras = {},                           -- filled below
    }

    if result.canDispatch then
        result.dispatchStatus = sc('esx_society:getDispatchMode', soc) == true
    end

    -- extra entries the classic menu had (same conditions, same actions - see bossExtra callback)
    local isRealBoss = job.grade_name == 'boss' or job.name == 'government'
    if isRealBoss then
        local okGov, isGov = pcall(function() return exports['esx_uniquejobs']:IsGovernmentJob(job.name) end)
        if okGov and isGov == true then
            result.extras[#result.extras + 1] = { key = 'paintball', label = 'دسترسی پینت‌بال (حداقل رنک)' }
        end
        if Pay and Pay.findOrg and Pay.findOrg(job.name) then
            local label = 'واریزهای دریافتی'
            local okCount, today = pcall(lib.callback.await, 'esx_society:pay:todayCount', false)
            if okCount and tonumber(today) and tonumber(today) > 0 then label = label .. ' (' .. tostring(today) .. ' امروز)' end
            result.extras[#result.extras + 1] = { key = 'pay', label = label }
        end
    end
    for _, ex in ipairs((BossExtras and BossExtras[soc]) or {}) do
        result.extras[#result.extras + 1] = { key = '__extra_' .. ex.id, label = ex.label }
    end

    lastCtx = { society = soc, job = job, isBoss = isBoss, isRealBoss = isRealBoss, canView = canView, options = options }
    for _, def in ipairs(BossUI.extras) do
        local ok, show = pcall(def.show or function() return true end, lastCtx)
        if ok and show then
            local label = def.label
            if type(label) == 'function' then
                local okL, text = pcall(label, lastCtx)
                label = okL and text or def.key
            end
            result.extras[#result.extras + 1] = { key = def.key, label = label }
        end
    end
    return result
end

-- returns true when the UI took over (false = caller should show the classic menu)
function OpenJobBossMenu(soc, close, options)
    if uiOpen then return true end                                         -- already open: never fall back to the classic menu
    if not soc or not ESX or not ESX.PlayerData or not ESX.PlayerData.job then return false end
    options = type(options) == 'table' and options or {}
    local job = ESX.PlayerData.job
    if job.name:find('^off') then ESX.ShowNotification('~r~Shoma Off-Duty hastid') return true end
    if soc ~= job.name and job.name ~= 'government' then ESX.ShowNotification('~r~Shoma dastresi nadarid') return true end

    currentSociety, currentOptions, currentClose = soc, options, close
    CreateThread(function()
        local data = buildData(soc, options)
        if not data.ok then
            return ESX.ShowNotification('~r~Boss menu: etelaate job paida nashod')
        end
        data.type, data.colors = 'show', menuColors
        uiOpen = true
        SetNuiFocus(true, true)
        nui(data)

        -- Esc: read from the native controls (keyboard events don't reliably cross the iframe boundary)
        while uiOpen do
            Wait(0)
            DisableControlAction(0, 200, true)
            DisableControlAction(0, 322, true)
            if IsDisabledControlJustPressed(0, 200) or IsDisabledControlJustPressed(0, 322) then hideUI(true) end
        end
    end)
    return true
end

-- ------------------------------------------------------------------------ NUI callbacks ---
RegisterNUICallback('bossClose', function(_, cb) hideUI(true); cb('ok') end)

RegisterNUICallback('refresh', function(_, cb)
    CreateThread(function()
        local d = buildData(currentSociety, currentOptions or {})
        cb(d)
    end)
end)

RegisterNUICallback('deposit', function(data, cb)
    local amount = math.floor(tonumber(data.amount) or 0)
    if amount > 0 then TriggerServerEvent('esx_society:depositMoney', currentSociety, amount) end
    cb('ok')
end)

RegisterNUICallback('withdraw', function(data, cb)
    local amount = math.floor(tonumber(data.amount) or 0)
    if amount > 0 then
        if Config.Withdraw == true then
            TriggerServerEvent('esx_society:withdrawMoney', currentSociety, amount)
        else
            ESX.ShowNotification(Config.WithdrawMsg or '~r~Bardasht ghabel anjam nist')
        end
    end
    cb('ok')
end)

RegisterNUICallback('toggleMili', function(data, cb)
    cb('ok')
    hideUI()
    if data and data.type then TriggerServerEvent('esx_society:changeBranchJob', data.type) end
end)

-- ---- members ---
RegisterNUICallback('getMembers', function(data, cb)
    local soc = data.off and ('off' .. currentSociety) or currentSociety
    ESX.TriggerServerCallback('esx_society:getEmployees', function(employees)
        local myGrade, myId = ESX.PlayerData.job.grade, ESX.PlayerData.identifier
        local siblings = (type(GetBranchSiblings) == 'function') and GetBranchSiblings(currentSociety) or nil
        if siblings and #siblings == 0 then siblings = nil end
        local list = {}
        for _, v in ipairs(employees or {}) do
            local canManage = v.job.grade < myGrade and v.identifier ~= myId
            list[#list + 1] = {
                name = v.name, identifier = v.identifier,
                job = v.job.name, grade = v.job.grade, gradeName = v.job.grade_name,
                gradeLabel = (v.job.grade_label and v.job.grade_label ~= '' and v.job.grade_label) or v.job.label,
                profileUrl = v.photo,
                canPromote = canManage, canFire = canManage,
                canSwap = canManage and siblings ~= nil,
            }
        end
        cb(list)
    end, soc)
end)

RegisterNUICallback('hire', function(_, cb)
    cb('ok')
    BossUI.flow(function(soc) BossUI.hireFlow(soc) end)
end)

RegisterNUICallback('fire', function(data, cb)
    ESX.TriggerServerCallback('esx_society:setJob', function() cb('ok') end, data.identifier, 'nojob', 0, 'fire')
end)

RegisterNUICallback('promote', function(data, cb)
    ESX.TriggerServerCallback('esx_society:setJob', function() cb('ok') end,
        data.identifier, currentSociety, tonumber(data.grade), 'promote')    -- same args as the classic menu
end)

-- swap = move a member to a sibling job of the same branch (server: esx_society:swapEmployeeJob, always grade 0)
RegisterNUICallback('getSwapGrades', function(data, cb)
    ESX.TriggerServerCallback('esx_society:getJob', function(job)
        local g0 = job and job.grades and job.grades[1]
        local label = (g0 and g0.label and g0.label ~= '' and g0.label) or (job and job.label) or tostring(data.job)
        cb({ { grade = 0, label = label } })            -- the server places swapped members at the lowest rank
    end, data.job)
end)

RegisterNUICallback('swap', function(data, cb)
    ESX.TriggerServerCallback('esx_society:swapEmployeeJob', function(ok)
        ESX.ShowNotification(ok and '~g~Fard ba movafaghiat jabeja shod.' or '~r~Swap anjam nashod.')
        cb('ok')
    end, data.identifier, currentSociety, data.toJob)
end)

-- ---- salary ---
RegisterNUICallback('getSalaries', function(_, cb)
    ESX.TriggerServerCallback('esx_society:getJob', function(job)
        local list = {}
        for _, g in ipairs(job.grades or {}) do
            list[#list + 1] = { grade = g.grade, label = gradeLabel(job, g), salary = g.salary }
        end
        cb(list)
    end, currentSociety)
end)

RegisterNUICallback('setSalary', function(data, cb)
    ESX.TriggerServerCallback('esx_society:setJobSalary', function() cb('ok') end,
        currentSociety, data.grade, tonumber(data.salary))
end)

-- ---- ranks ---
RegisterNUICallback('getRanks', function(_, cb)
    ESX.TriggerServerCallback('esx_society:getJob', function(job)
        local grades = {}
        for _, g in ipairs(job.grades or {}) do
            grades[#grades + 1] = { grade = g.grade, name = g.name, label = gradeLabel(job, g), isBoss = g.name == 'boss' }
        end
        ESX.TriggerServerCallback('esx_society:getdivision', function(rows)
            local divs = {}
            for _, d in ipairs(rows or {}) do divs[#divs + 1] = { name = d.name, label = d.label, icon = d.icon } end
            cb({ grades = grades, divisions = divs, maxGrade = #grades })
        end, currentSociety)
    end, currentSociety)
end)

RegisterNUICallback('getRankPermissions', function(data, cb)
    local gradeId = data.grade
    if type(gradeId) == 'string' then                         -- division rows: next stage
        return cb({ grade = gradeId, permissions = {} })
    end
    ESX.TriggerServerCallback('esx_society:getJob', function(job)
        local row
        for _, g in ipairs(job.grades or {}) do
            if g.grade == gradeId then row = g break end
        end
        row = row or {}
        local permsTable = row.permsTable or {}
        local list = {
            { key = '__boss', label = 'باس (Boss)', state = row.name == 'boss', kind = 'boss' },
            { key = 'employeeManagement', label = 'مدیریت اعضا',
              state = row.perm_employee_management == 1 or row.perm_employee_management == true, kind = 'employee' },
        }
        if currentSociety == 'mechanic' or row.perm_vehicle_custom ~= nil then
            list[#list + 1] = { key = 'vehicleCustom', label = 'کاستوم خودرو',
                state = row.perm_vehicle_custom == 1 or row.perm_vehicle_custom == true, kind = 'custom' }
        end
        local keys = Config.PermissionGroups and Config.PermissionGroups[currentSociety]
        local function add(key)
            if key == 'employeeManagement' or key == 'vehicleCustom' then return end
            local label = Config.PermissionKeys and Config.PermissionKeys[key]
            if label then list[#list + 1] = { key = key, label = label, state = permsTable[key] and true or false, kind = 'var' } end
        end
        if keys then
            for _, key in ipairs(keys) do add(key) end
        elseif Config.PermissionKeys then
            local ks = {}
            for key in pairs(Config.PermissionKeys) do ks[#ks + 1] = key end
            table.sort(ks)
            for _, key in ipairs(ks) do add(key) end
        end
        cb({ grade = gradeId, permissions = list })
    end, currentSociety)
end)

RegisterNUICallback('setRankPerm', function(data, cb)
    local state = data.state and true or false
    if data.kind == 'boss' then
        TriggerServerEvent('esx_society:toggleBoss', tonumber(data.grade), state)
    elseif data.kind == 'employee' then
        TriggerServerEvent('esx_society:toggleEmployeeManagementPerm', tonumber(data.grade), state)
    elseif data.kind == 'custom' then
        TriggerServerEvent('esx_society:toggleVehicleCustomPerm', tonumber(data.grade), state)
    else
        TriggerServerEvent('esx_society:togglePermKey', tonumber(data.grade), data.key, state)
    end
    cb('ok')
end)

RegisterNUICallback('addGrade', function(_, cb)
    ESX.TriggerServerCallback('esx_society:newGrade', function() cb('ok') end, currentSociety)
end)
RegisterNUICallback('deleteGrade', function(data, cb)
    TriggerServerEvent('esx_society:deleteGrade', tonumber(data.grade)); cb('ok')
end)
RegisterNUICallback('upgradeGrade', function(data, cb)
    TriggerServerEvent('esx_society:upgradeGrade', tonumber(data.grade)); cb('ok')
end)
RegisterNUICallback('downgradeGrade', function(data, cb)
    TriggerServerEvent('esx_society:downgradeGrade', tonumber(data.grade)); cb('ok')
end)
RegisterNUICallback('renameGrade', function(data, cb)
    ESX.TriggerServerCallback('esx_society:renameGrade', function() cb('ok') end, tonumber(data.grade), tostring(data.name))
end)

-- ======================================================================= stage 2 ===
-- The server's setters take the CLIENT's full row table and only flip the row named `choice`, so every
-- change below keeps `rows` in sync (a stale row would overwrite an earlier change of the same batch).

local function lower(v) return string.lower(tostring(v or '')) end
local function asList(v) return type(v) == 'table' and v or {} end   -- callbacks may answer false

-- ---- locker access (weapons + items), per rank (data.division == false) and per division ----
local function loadItemRows(target, division)
    local authorized = asList(sc('esx_society:getJobItems', currentSociety))
    local states = division and sc('esx_society:getDivisionItems', target, currentSociety)
        or sc('esx_society:getItems', target, currentSociety)
    local byName = {}
    for _, st in ipairs(asList(states)) do byName[lower(st.name)] = (st.status == true) end
    local rows = {}
    for _, it in ipairs(authorized) do
        rows[#rows + 1] = { label = it.label, name = it.name, Itemlabel = it.label, value = byName[lower(it.name)] or false }
    end
    return rows
end

local function loadWeaponRows(target, division)
    local pool = sc('esx_society:getArmoryWeaponPool', currentSociety)
    local list = (pool and pool.list and #pool.list > 0) and pool.list or (Config.Armory and Config.Armory[currentSociety]) or {}
    local states = division and sc('esx_society:getWeaponsdivisions', target, currentSociety)
        or sc('esx_society:getWeapons', target, currentSociety)
    local byModel = {}
    for _, st in ipairs(asList(states)) do byModel[lower(st.model)] = (st.status == true) end
    local rows = {}
    for _, model in ipairs(list) do
        rows[#rows + 1] = { label = GetModelLabel(model), model = model, value = byModel[lower(model)] or false }
    end
    return rows
end

RegisterNUICallback('getLockerPermissions', function(data, cb)
    CreateThread(function()
        local target, division = data.rankId, data.division and true or false
        local list = {}
        for _, w in ipairs(loadWeaponRows(target, division)) do
            list[#list + 1] = { label = w.label, key = w.model, state = w.value, weapon = true, clothe = false }
        end
        for _, it in ipairs(loadItemRows(target, division)) do
            list[#list + 1] = { label = it.label, key = it.name, state = it.value, weapon = false, clothe = false }
        end
        cb({ permissions = list })
    end)
end)

RegisterNUICallback('setLockerPermissions', function(data, cb)
    CreateThread(function()
        local target, division = data.rankId, data.division and true or false
        local weapons, items = loadWeaponRows(target, division), loadItemRows(target, division)
        local wIdx, iIdx = {}, {}
        for _, w in ipairs(weapons) do wIdx[lower(w.model)] = w end
        for _, it in ipairs(items) do iIdx[lower(it.name)] = it end

        for _, p in ipairs(data.permissions or {}) do
            local want = p.state and true or false
            if p.weapon then
                local row = wIdx[lower(p.key)]
                if row and row.value ~= want then
                    if division then sc('esx_society:setDivisionWeapPerm', currentSociety, target, weapons, want, row.model)
                    else sc('esx_society:setSocietyWeapPerm', currentSociety, target, weapons, want, row.model) end
                    row.value = want
                end
            else
                local row = iIdx[lower(p.key)]
                if row and row.value ~= want then
                    if division then sc('esx_society:setDivisionItemPerm', currentSociety, target, items, want, row.name, row.Itemlabel)
                    else sc('esx_society:setSocietyItemPerm', currentSociety, target, items, want, row.name, row.Itemlabel) end
                    row.value = want
                end
            end
        end
        cb('ok')
    end)
end)

-- ---- vehicles (per rank) ----
local function loadVehicleRows(grade)
    local garage = asList(GetMergedGarage(currentSociety))
    local states = sc('esx_society:getVehicles', grade, currentSociety)
    local byModel = {}
    for _, st in ipairs(asList(states)) do byModel[lower(st.model)] = (st.status == true) end
    local rows = {}
    for _, v in ipairs(garage) do
        rows[#rows + 1] = { label = v.label, model = v.name, labelVeh = v.label, value = byModel[lower(v.name)] or false }
    end
    return rows
end

RegisterNUICallback('getVehiclePerms', function(data, cb)
    CreateThread(function()
        local list = {}
        for _, r in ipairs(loadVehicleRows(data.grade)) do list[#list + 1] = { label = r.labelVeh, state = r.value } end
        cb({ grade = data.grade, vehicles = list })
    end)
end)

RegisterNUICallback('setVehiclePerm', function(data, cb)
    CreateThread(function()
        local rows = loadVehicleRows(data.grade)
        for _, r in ipairs(rows) do
            if r.labelVeh == data.label then
                sc('esx_society:setSocietyVehPerm', currentSociety, data.grade, rows, data.state and true or false, r.model, r.labelVeh)
                break
            end
        end
        cb('ok')
    end)
end)

-- ---- divisions ----
RegisterNUICallback('getDivisions', function(_, cb)
    ESX.TriggerServerCallback('esx_society:getdivision', function(rows)
        local list = {}
        for _, d in ipairs(asList(rows)) do
            list[#list + 1] = { name = d.name, label = (d.label and d.label ~= '') and d.label or d.name, icon = d.icon }
        end
        cb(list)
    end, currentSociety)
end)

RegisterNUICallback('addDivision', function(data, cb)
    local label = tostring(data.name or ''):gsub('^%s+', ''):gsub('%s+$', '')
    local slug = string.lower(label):gsub('%s+', '_'):gsub('[^%w_]', '')
    if slug == '' then
        ESX.ShowNotification('~r~Esme division bayad ba horoofe englisi bashad')
        return cb('ok')
    end
    label = label:sub(1, 1):upper() .. label:sub(2)
    ESX.TriggerServerCallback('esx_society:CreateDivision', function() cb('ok') end, slug, label)
end)

RegisterNUICallback('delDivision', function(data, cb)
    ESX.TriggerServerCallback('esx_society:getdivision', function(rows)
        local label = tostring(data.name)
        for _, d in ipairs(asList(rows)) do
            if d.name == data.name then label = d.label or d.name break end
        end
        ESX.TriggerServerCallback('esx_society:RemoveDivision', function() cb('ok') end, tostring(data.name), label)
    end, currentSociety)
end)

RegisterNUICallback('setDivisionIcon', function(data, cb)
    ESX.TriggerServerCallback('esx_society:getdivision', function(rows)
        local id
        for _, d in ipairs(asList(rows)) do
            if d.name == data.name then id = d.id break end
        end
        local icon = tostring(data.icon or ''):gsub('^%s+', ''):gsub('%s+$', '')
        if not id then ESX.ShowNotification('~r~Division peyda nashod') return cb('ok') end
        if icon ~= '' and not icon:match('^https?://[%w%.%-_/%?=&%%:~#@!%+,;]+$') then
            ESX.ShowNotification('~r~Link-e icon namoatabar (faghat http/https)')
            return cb('ok')
        end
        ESX.TriggerServerCallback('esx_society:ChangeDivision', function() cb('ok') end, currentSociety, id, icon, 'icon')
    end, currentSociety)
end)

-- ---- dispatch priority (queue order <-> nearest worker) ----
RegisterNUICallback('toggleDispatch', function(_, cb)
    ESX.TriggerServerCallback('esx_society:toggleDispatchMode', function(distance)
        if distance ~= nil then
            ESX.ShowNotification(distance and '~g~Olaviat-e dispatch: ~s~bar asase fasele' or '~g~Olaviat-e dispatch: ~s~bar asase tartib-e saf')
        end
        cb('ok')
    end, currentSociety)
end)

-- ---- LogPanel (Logs tab) + the other classic extras on the Home tab ----
RegisterNUICallback('openLogPanel', function(_, cb)
    cb('ok')
    hideUI()
    TriggerEvent('LogPanel:OpenBossPanel')
end)

RegisterNUICallback('bossExtra', function(data, cb)
    cb('ok')
    local key, society = tostring(data.key or ''), currentSociety
    hideUI()
    if key == 'pay' then
        if type(OpenPayBossPanel) == 'function' then OpenPayBossPanel() end
    elseif key == 'paintball' then
        ESX.TriggerServerCallback('esx_paintball:GetJobAccessGrade', function(currentGrade)
            local input = lib.inputDialog(('Hadaghal Grade Baraye Dastresi Paintball (Fe\'li: %s)'):format(tostring(currentGrade or 0)),
                { { type = 'number', label = 'Grade', default = tonumber(currentGrade) or 0, min = 0, required = true } })
            local grade = input and tonumber(input[1])
            if grade == nil or grade < 0 or grade ~= math.floor(grade) then
                if input then ESX.ShowNotification('Grade Namoatabar') end
            else
                TriggerServerEvent('esx_paintball:setJobAccessGrade', society, grade)
            end
        end, ESX.PlayerData.job.name)
    elseif key:sub(1, 8) ~= '__extra_' and (function()
            for _, def in ipairs(BossUI.extras) do
                if def.key == key then
                    CreateThread(function()
                        if def.reopen then
                            BossUI.flow(function() def.run(lastCtx) end)
                        else
                            pcall(def.run, lastCtx)
                        end
                    end)
                    return true
                end
            end
        end)() then
        -- handled by a registered extra (boss_ui_more.lua)
    elseif key:sub(1, 8) == '__extra_' then
        local id = key:sub(9)
        for _, ex in ipairs((BossExtras and BossExtras[society]) or {}) do
            if ex.id == id then TriggerEvent(ex.event, society) end
        end
    end
end)

-- ---- outfits: the classic uniform manager (male / female) ----
RegisterNUICallback('manageOutfit', function(_, cb)
    cb('ok')
    BossUI.flow(function(soc) BossUI.outfitFlow(soc) end)
end)

AddEventHandler('onResourceStop', function(res)
    if res == GetCurrentResourceName() and uiOpen then SetNuiFocus(false, false) end
end)
