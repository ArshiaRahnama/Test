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

-- کلید F10 (اسم دستور عمداً جدیده تا بایند قدیمی F9 که سمت کلاینت ذخیره شده
-- بود دور زده بشه).
RegisterCommand('+scoreboardUniqueHudV2', function()
    if scoreboardOpen then
        CloseScoreboard()
    else
        OpenScoreboard()
    end
end, false)
RegisterCommand('-scoreboardUniqueHudV2', function() end, false)
RegisterKeyMapping('+scoreboardUniqueHudV2', 'باز/بسته کردن اسکوربورد', 'keyboard', 'F10')

-- ✅ فیکس شد: وقتی SetNuiFocus(true,true) فعاله، کیبورد کامل قبضه‌ی مرورگر
-- NUI میشه و کلیدهای RegisterKeyMapping (مثل همین F10) دیگه به بازی نمی‌رسن
-- - دقیقاً چرا نمی‌تونستی با همون کلید ببندیش. برای همین یه دکمه‌ی ✕ داخل
-- خودِ پنل اضافه شد که این NUI callback رو صدا می‌زنه و همیشه کار می‌کنه،
-- صرف‌نظر از قبضه بودن کیبورد یا نه.
RegisterNUICallback('closeScoreboardUniqueHud', function(data, cb)
    CloseScoreboard()
    cb('ok')
end)

-- Esc هم امتحان می‌کنیم (ممکنه بسته به تنظیمات بازی کار کنه)، ولی دکمه‌ی ✕
-- تضمینیه.
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
