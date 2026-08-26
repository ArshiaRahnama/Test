-- ============================================================
-- Unique_Hud / client / scoreboard.lua
-- ============================================================

local scoreboardOpen = false

local function RefreshScoreboard()
    while ESX == nil do Wait(0) end
    ESX.TriggerServerCallback('Unique_Hud:scoreboard:getCounts', function(data)
        SendNUIMessage({
            id = 'scoreboard',
            event = 'update',
            data = data,
        })
    end)
end

local function OpenScoreboard()
    if scoreboardOpen then return end
    scoreboardOpen = true
    SetNuiFocus(true, true)
    SendNUIMessage({ id = 'scoreboard', event = 'toggle', open = true })
    RefreshScoreboard()

    Citizen.CreateThread(function()
        while scoreboardOpen do
            Citizen.Wait(3000)
            RefreshScoreboard()
        end
    end)
end

local function CloseScoreboard()
    if not scoreboardOpen then return end
    scoreboardOpen = false
    SetNuiFocus(false, false)
    SendNUIMessage({ id = 'scoreboard', event = 'toggle', open = false })
end

-- کلید F10 (هم باز، هم بسته می‌کنه)
RegisterCommand('+opensbUniqueHud', function()
    if scoreboardOpen then
        CloseScoreboard()
    else
        OpenScoreboard()
    end
end, false)
RegisterCommand('-opensbUniqueHud', function() end, false)
RegisterKeyMapping('+opensbUniqueHud', 'باز/بسته کردن اسکوربورد', 'keyboard', 'F10')

-- بستن با Esc - کاملاً سمت Lua با نیتیو خودِ بازی (نیازی به ارتباط با JS نیست،
-- پس دیگه به مشکل GetParentResourceName داخل iframe تودرتو برنمی‌خوریم).
Citizen.CreateThread(function()
    while true do
        if scoreboardOpen then
            Citizen.Wait(0)
            if IsControlJustPressed(0, 322) then -- INPUT_FRONTEND_PAUSE (Esc)
                CloseScoreboard()
            end
        else
            Citizen.Wait(250)
        end
    end
end)

-- دکمه‌ی رفرش دستی تو خودِ پنل
RegisterNUICallback('refreshScoreboardUniqueHud', function(data, cb)
    RefreshScoreboard()
    cb('ok')
end)

AddEventHandler('onResourceStop', function(resourceName)
    if resourceName == GetCurrentResourceName() then
        CloseScoreboard()
    end
end)
