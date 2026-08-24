-- ============================================================
-- Unique_Hud / client / scoreboard.lua
-- ============================================================

local scoreboardOpen = false
local refreshThread = nil

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
    SendNUIMessage({ id = 'scoreboard', event = 'toggle', open = true })
    RefreshScoreboard()

    refreshThread = Citizen.CreateThread(function()
        while scoreboardOpen do
            Citizen.Wait(3000)
            RefreshScoreboard()
        end
    end)
end

local function CloseScoreboard()
    if not scoreboardOpen then return end
    scoreboardOpen = false
    SendNUIMessage({ id = 'scoreboard', event = 'toggle', open = false })
end

-- کلید پیش‌فرض F9 (کلیدهای اسکوربورد معمول باز/بسته). اگه خواستید کلید دیگه‌ای
-- باشه، همین اسم "F9" رو با یه کلید دیگه (لیست کامل کلیدها تو مستندات FiveM
-- تحت "RegisterKeyMapping" هست) عوض کنید.
RegisterCommand('+opensbUniqueHud', function()
    if scoreboardOpen then
        CloseScoreboard()
    else
        OpenScoreboard()
    end
end, false)
RegisterCommand('-opensbUniqueHud', function() end, false)
RegisterKeyMapping('+opensbUniqueHud', 'باز/بسته کردن اسکوربورد', 'keyboard', 'F9')

AddEventHandler('onResourceStop', function(resourceName)
    if resourceName == GetCurrentResourceName() then
        CloseScoreboard()
    end
end)
