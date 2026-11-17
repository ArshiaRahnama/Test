--[[ Boss UI (Sunset-style NUI) | esx_society/client/boss_ui.lua
    Same permissions and the same server calls as the classic boss menu (client/main.lua), just a nicer face:
      tabs shown : Home (money, deposit/withdraw, branch change) | Members | Ranks (+ permissions) | Salary
      not yet    : locker / vehicle / division / log / outfit tabs (kept hidden: their canXxx flag is false)
    Entry point: OpenBossMenu() in main.lua calls OpenJobBossMenu(); it returns false when the classic menu should be used
    (hold LEFT SHIFT while opening = classic menu, which also has LogPanel, Society Pay, Paintball access, ...).
    Colour: /chatsetting -> Menus -> Boss Action.
]]

local currentSociety, currentOptions = nil, nil
local uiOpen = false
local menuColors = {
    primary   = GetResourceKvpString('unique_boss_primary')   or '#b91c1c',
    secondary = GetResourceKvpString('unique_boss_secondary') or '#ef4444',
}

local function nui(payload)
    payload._bossUI = true                       -- html/index.html routes this ONLY to the boss iframe
    SendNUIMessage(payload)
end

local function hideUI()
    uiOpen = false
    SetNuiFocus(false, false)
    nui({ type = 'hide' })
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

-- promise wrapper: value1, value2... = sc('callback', args...)
local function sc(name, ...)
    local p, args = promise.new(), { ... }
    ESX.TriggerServerCallback(name, function(...) p:resolve({ ... }) end, table.unpack(args))
    return table.unpack(Citizen.Await(p))
end

local function gradeLabel(job, g)
    return (g.label and g.label ~= '' and g.label) or job.label
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

    return {
        ok = true,
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
        canSalary = options.job ~= false and canView,
        miliOptions = miliOptions,
        -- next stages (tabs stay hidden until their server side is wired):
        canInventory = false, canArmory = false, canVehicle = false,
        canDivision = false, canLog = false, canOutfit = false, canDispatch = false,
    }
end

-- returns true when the UI took over (false = caller should show the classic menu)
function OpenJobBossMenu(soc, _, options)
    if uiOpen or not soc or not ESX or not ESX.PlayerData or not ESX.PlayerData.job then return false end
    options = type(options) == 'table' and options or {}
    if options.wash == true then return false end                       -- wash-money options live in the classic menu
    local job = ESX.PlayerData.job
    if job.name:find('^off') then return false end                      -- off-duty: classic menu already says no
    if soc ~= job.name and job.name ~= 'government' then return false end

    currentSociety, currentOptions = soc, options
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
            if IsDisabledControlJustPressed(0, 200) or IsDisabledControlJustPressed(0, 322) then hideUI() end
        end
    end)
    return true
end

-- ------------------------------------------------------------------------ NUI callbacks ---
RegisterNUICallback('bossClose', function(_, cb) hideUI(); cb('ok') end)

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
        local list = {}
        for _, v in ipairs(employees or {}) do
            local canManage = v.job.grade < myGrade and v.identifier ~= myId
            list[#list + 1] = {
                name = v.name, identifier = v.identifier,
                job = v.job.name, grade = v.job.grade, gradeName = v.job.grade_name,
                gradeLabel = (v.job.grade_label and v.job.grade_label ~= '' and v.job.grade_label) or v.job.label,
                profileUrl = v.photo,
                canPromote = canManage, canFire = canManage,
                canSwap = false,                     -- branch swap isn't supported by this server's setJob
            }
        end
        cb(list)
    end, soc)
end)

RegisterNUICallback('hire', function(_, cb)
    cb('ok')
    hideUI()
    if type(OpenRecruitMenu) == 'function' then OpenRecruitMenu(currentSociety)    -- the classic recruit list (nearby, jobless)
    else ESX.ShowNotification('~r~Estekhdam dar dastres nist') end
end)

RegisterNUICallback('fire', function(data, cb)
    ESX.TriggerServerCallback('esx_society:setJob', function() cb('ok') end, data.identifier, 'nojob', 0, 'fire')
end)

RegisterNUICallback('promote', function(data, cb)
    ESX.TriggerServerCallback('esx_society:setJob', function() cb('ok') end,
        data.identifier, currentSociety, tonumber(data.grade), 'promote')    -- same args as the classic menu
end)

RegisterNUICallback('swap', function(_, cb) cb('ok') end)
RegisterNUICallback('getSwapGrades', function(_, cb)
    ESX.ShowNotification('~y~Swap dar in server faal nist')
    cb({})
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
            for _, d in ipairs(rows or {}) do divs[#divs + 1] = { name = d.name or d.division or d.label } end
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

AddEventHandler('onResourceStop', function(res)
    if res == GetCurrentResourceName() and uiOpen then SetNuiFocus(false, false) end
end)
