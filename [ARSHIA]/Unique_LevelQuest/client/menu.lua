local ESX = nil
Citizen.CreateThread(function()
    while ESX == nil do
        TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
        Wait(1)
    end
end)

function UiShow()
    SendNUIMessage({ type = "openMenu" })
end

function UpdateProfile()
    ESX.TriggerServerCallback('HUD_Menu:GetAcc', function(data)
        if not data then return end

        ESX.TriggerServerCallback('HUD_Menu:GetCC', function(Coin)
            local myId = GetPlayerServerId(PlayerId())
            local jobsection = 'No Job'
            local gangsection = 'No Gang'
            if data.job and data.job.name ~= 'nojob' then
                jobsection = data.job.label .. " | " .. data.job.grade_label .. " (" .. data.job.grade .. ")"
                if data.divisionLabel then
                    jobsection = jobsection .. " — " .. data.divisionLabel
                end
            end
            if data.gang and data.gang.name ~= 'nogang' then
                gangsection = data.gang.name .. " | " .. data.gang.grade_label .. " (" .. data.gang.grade .. ")"
            end

            SendNUIMessage({
                type       = "updateProfile",
                name       = string.gsub(data.name, "_", " ") .. " (" .. myId .. ")",
                job        = jobsection,
                jobName    = data.job and data.job.name,
                gang       = gangsection,
                level      = data.rank,
                xpCurrent  = data.xp,
                xpNeeded   = config.Levels[data.rank] or 0,
                xpPercent  = config.Levels[data.rank] and (data.xp / config.Levels[data.rank]) * 100 or 0,
                cash       = data.money,
                bank       = data.bank,
                coin       = Coin .. " Coin",
                avatarUrl  = data.avatarUrl,
                gangLogoUrl= data.gangLogoUrl,
                iban       = data.iban,
                accountNum = data.accountNum,
                memberSince= data.memberSince,
                hours      = data.hours,
                coinRaw    = Coin,
                paycheckSeconds = PaycheckSynced
                    and math.max(0, math.floor(((Config.PaycheckIntervalMinutes * 60000) - (GetGameTimer() - LastPaycheckTime)) / 1000))
                    or nil,
                -- FIX: essentialmode's server/paycheck.lua only fires
                -- 'esx:givesalary' when the job's CURRENT GRADE has
                -- grade_salary > 0 (see the `if jsalary > 0 then` gate
                -- wrapping the whole TriggerClientEvent call). A job
                -- assigned but with a 0-salary grade — a common setup
                -- for jobs paid entirely some other way (quest/coin
                -- rewards, business income, etc.) — will NEVER receive
                -- that event, no matter how long you wait. The old
                -- check here only looked at job.name ~= 'nojob', so
                -- those players saw "Syncing..." forever instead of
                -- an explanation — indistinguishable from "about to
                -- get a real countdown any second now". Now also
                -- requires grade_salary > 0 before promising a
                -- countdown is coming.
                hasJob = data.job and data.job.name ~= 'nojob' and (data.job.grade_salary or 0) > 0,
            })
        end)
    end)

    UpdateQuests()
end

-- Extracted out of UpdateProfile (used to be inlined here) so it can
-- also be called on its own after QuestSystem:AcceptQuest /
-- QuestSystem:CancelQuest, instead of re-fetching the whole profile
-- (GetAcc + GetCC) just to refresh the quest list.
function UpdateQuests()
    ESX.TriggerServerCallback('HUD_Menu:GetQuests', function(quests)
        if not quests then return end

        local jobname = quests["Job"]
        local pool = jobname and Config.JobQuests[jobname] or Config.DefaultQuest

        local myquests = {}
        if pool then
            for id, questDef in ipairs(pool) do
                local idStr = tostring(id)
                local accepted = quests[idStr] ~= nil
                local current = accepted and (tonumber(quests[idStr]) or 0) or 0
                table.insert(myquests, {
                    id = idStr,
                    title = questDef.name,
                    description = questDef.description,
                    progress = accepted and (current / questDef.requiredTrigger) * 100 or 0,
                    current = current,
                    required = questDef.requiredTrigger,
                    xp = questDef.XP,
                    coin = questDef.coin,
                    icon = "fa-shield-halved",
                    accepted = accepted,
                    completed = accepted and current >= questDef.requiredTrigger,
                })
            end
        end

        SendNUIMessage({ type = "loadQuests", quests = myquests, maxActive = Config.QuestsPerDay or 6 })
    end)
end

RegisterNUICallback('acceptQuest', function(data, cb)
    TriggerServerEvent('QuestSystem:AcceptQuest', data.id)
    cb('ok')
end)

RegisterNUICallback('cancelQuest', function(data, cb)
    TriggerServerEvent('QuestSystem:CancelQuest', data.id)
    cb('ok')
end)

RegisterNetEvent('QuestSystem:RefreshQuests')
AddEventHandler('QuestSystem:RefreshQuests', function()
    UpdateQuests()
end)

-- DUTY tab data — separate from UpdateProfile since it's a distinct
-- server callback (server/duty.lua) reading esx_duty's duty_logs
-- table, not this resource's own tables.
function UpdateDuty()
    ESX.TriggerServerCallback('HUD_Menu:GetDuty', function(duty)
        if not duty then return end
        SendNUIMessage({ type = "loadDuty", duty = duty })
    end)
end

RegisterNUICallback('checkDutyDate', function(data, cb)
    ESX.TriggerServerCallback('HUD_Menu:GetDutyByDate', function(result)
        SendNUIMessage({ type = "dutyDateResult", result = result })
    end, data.startDate, data.endDate)
    cb('ok')
end)

RegisterNUICallback('searchDutyRoster', function(data, cb)
    ESX.TriggerServerCallback('HUD_Menu:SearchDutyRoster', function(result)
        SendNUIMessage({ type = "dutySearchResult", result = result })
    end, data.search)
    cb('ok')
end)

-- RECORD tab data — read-only, see server/record.lua.
function UpdateRecord()
    ESX.TriggerServerCallback('HUD_Menu:GetRecord', function(record)
        if not record then return end
        SendNUIMessage({ type = "loadRecord", record = record })
    end)
end

-- CAPTURE tab data — proxies Unique_Capture's own dashboard callback,
-- see server/capture.lua.
function UpdateCapture()
    ESX.TriggerServerCallback('HUD_Menu:GetCapture', function(dashboard)
        SendNUIMessage({ type = "loadCapture", dashboard = dashboard })
    end)
end

local menuIsOpen = false

RegisterCommand('menu', function()
    SetNuiFocus(true, true)
    menuIsOpen = true
    UpdateProfile()
    UpdateSkills()
    UpdateCollections()
    UpdateLeaderboard()
    UpdateDuty()
    UpdateRecord()
    UpdateCapture()
    UiShow()

    -- esx_dpemote is a real resource on this server. Wrapped in pcall so
    -- if it's ever missing/renamed, the menu still opens fine either way.
    pcall(function()
        exports['esx_dpemote']:PlayEmote('think3')
    end)
end, false)

-- Live refresh while the menu stays open — level/XP, quest progress,
-- skill hours, and the leaderboard can all change while you're looking
-- at them (someone else finishing a quest, your own onduty tick firing
-- in the background, etc.). Collections is deliberately left out here:
-- vehicle/house ownership rarely changes mid-session, and re-fetching
-- would mean repeatedly re-requesting every vehicle image for no
-- reason. Duty IS refreshed — esx_duty's own background thread adds
-- to it every 5 minutes while you're on duty, so a stale "Today: 0m"
-- would sit there the whole time the menu stays open otherwise.
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(30000)
        if menuIsOpen then
            UpdateProfile()
            UpdateSkills()
            UpdateLeaderboard()
            UpdateDuty()
            UpdateRecord()
            UpdateCapture()
        end
    end
end)

AddEventHandler('onKeyDown', function(key)
    if key == "i" then
        ExecuteCommand('menu')
    end
end)

RegisterNUICallback('menuClosed', function(_, cb)
    SetNuiFocus(false, false)
    menuIsOpen = false

    local ped = PlayerPedId()
    ClearPedTasks(ped)
    ClearPedTasksImmediately(ped)

    cb('ok')
end)
