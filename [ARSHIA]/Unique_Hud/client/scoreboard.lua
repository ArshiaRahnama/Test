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

-- ✅ فیکس شد: کلید قبلی (+opensbUniqueHud) رو یه بار قبلاً روی F9 دیفالت کرده
-- بودیم؛ FiveM بایند هر دستور رو سمت کلاینت ذخیره می‌کنه، پس فقط عوض کردن
-- کد کافی نبود - همون بایند قدیمی (F9) می‌موند. با یه اسم دستور کاملاً جدید
-- (+scoreboardUniqueHudV2)، بازی مجبوره یه بایند تازه با پیش‌فرض واقعی (F10)
-- بسازه.
RegisterCommand('+scoreboardUniqueHudV2', function()
    if scoreboardOpen then
        CloseScoreboard()
    else
        OpenScoreboard()
    end
end, false)
RegisterCommand('-scoreboardUniqueHudV2', function() end, false)
RegisterKeyMapping('+scoreboardUniqueHudV2', 'باز/بسته کردن اسکوربورد', 'keyboard', 'F10')

-- ✅ اضافه شد: NUI callback برای دکمه‌ی ✕ داخل پنل - چون وقتی SetNuiFocus(true,true)
-- فعاله، کیبورد قبضه‌ی مرورگر NUI میشه و کلید F10 دیگه به بازی نمی‌رسه. این
-- دکمه صرف‌نظر از اون مشکل همیشه کار می‌کنه.
RegisterNUICallback('closeScoreboardUniqueHud', function(data, cb)
    CloseScoreboard()
    cb('ok')
end)

-- بستن با Esc - کاملاً سمت Lua با نیتیو خودِ بازی.
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

AddEventHandler('onResourceStop', function(resourceName)
    if resourceName == GetCurrentResourceName() then
        CloseScoreboard()
    end
end)
