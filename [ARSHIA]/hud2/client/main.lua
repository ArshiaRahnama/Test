-- ============================================================
-- ریسورس "hud1" — کاملاً مستقل، هیچ وابستگی‌ای به Unique_Hud نداره
-- ============================================================
-- خودش ui_page/index.html خودشو داره (تو ui/) و نشون میده:
-- هیل، آرمور، آب (thirst)، غذا (hunger)، میکروفون - همیشه.
-- استامینا و اکسیژن - اختیاری: فقط وقتی می‌دویی/شنا می‌کنی موقتاً ظاهر
-- میشن (دقیقاً منطق قبلی IsPedSprinting/IsPedSwimming) و بعد چند ثانیه
-- بی‌حرکتی خودکار محو میشن.
--
-- ✅ اسم ریسورس از "1" به "hud1" تغییر کرد چون همون علت اصلی نمایش داده نشدن
-- UI بود - اسم خالص عددی باعث میشد ui_page درست ساخته نشه.

local pauseMenu = false

-- استامینا/اکسیژن: چند میلی‌ثانیه بعد از قطع دویدن/شنا، خودکار مخفی بشن
local HIDE_DELAY_MS = 3000
local staminaShown, staminaHideAt = false, 0
local oxygenShown, oxygenHideAt = false, 0

CreateThread(function()
    local player = PlayerId()
    local unarmed = `WEAPON_UNARMED`
    while true do
        Wait(250)
        local ped = PlayerPedId()
        if IsPauseMenuActive() then
            if not pauseMenu and GetSelectedPedWeapon(ped) == unarmed and not LocalPlayer.state.vanish then
                pauseMenu = true
            end
        elseif pauseMenu then
            pauseMenu = false
            ClearPedTasks(ped)
            ClearPedTasksImmediately(ped)
        end

        local sendData = {
            id = 'hud',
            event = 'setData',
            -- GetEntityHealth پد بین ۱۰۰ (مرگ) تا ۲۰۰ (کامل) برمی‌گرده، برای همین
            -- ۱۰۰ ازش کم میشه تا دایره‌ی هیل درصد ۰ تا ۱۰۰ درست رو نشون بده.
            -- GetPedArmour از قبل خودش ۰ تا ۱۰۰ هست، نیازی به تغییر نداره.
            health = GetEntityHealth(ped) - 100,
            armor = GetPedArmour(ped),
            talking = MumbleIsPlayerTalking(player),
        }

        -- استامینا: دقیقاً همون منطق قبلی (IsPedSprinting)
        if IsPedSprinting(ped) then
            sendData.stamina = GetPlayerStamina(player)
            if not staminaShown then
                staminaShown = true
                SendNUIMessage({ id = 'hud', event = 'toggleDisplay3', key = '#stamina', state = true })
            end
            staminaHideAt = GetGameTimer() + HIDE_DELAY_MS
        elseif staminaShown and GetGameTimer() >= staminaHideAt then
            staminaShown = false
            SendNUIMessage({ id = 'hud', event = 'toggleDisplay3', key = '#stamina', state = false })
        end

        -- اکسیژن: دقیقاً همون منطق قبلی (IsPedSwimming)
        if IsPedSwimming(ped) then
            local oxygen = GetPlayerUnderwaterTimeRemaining(player) * 10
            sendData.oxygen = oxygen > 0 and oxygen or 0
            if not oxygenShown then
                oxygenShown = true
                SendNUIMessage({ id = 'hud', event = 'toggleDisplay3', key = '#oxygen', state = true })
            end
            oxygenHideAt = GetGameTimer() + HIDE_DELAY_MS
        elseif oxygenShown and GetGameTimer() >= oxygenHideAt then
            oxygenShown = false
            SendNUIMessage({ id = 'hud', event = 'toggleDisplay3', key = '#oxygen', state = false })
        end

        SendNUIMessage(sendData)
    end
end)

local function handleStatusUpdate(data)
    local sendData = {
        id = 'hud',
        event = 'setData',
    }
    for k, v in pairs(data) do
        if v.name == 'thirst' then
            -- ✅ فیکس شد: قبلاً وقتی درصد آب از ۸۰٪ بیشتر می‌شد (یعنی تازه آب
            -- خورده بودی) دایره‌ش مخفی می‌شد -> همون "سریع برداشته میشه"ای که
            -- گفتی. الان همیشه نمایش داده میشه، فقط عددش آپدیت میشه.
            sendData.thirst = v.val / 10000
        elseif v.name == 'hunger' then
            sendData.hunger = v.val / 10000
        end
    end
    SendNUIMessage(sendData)
end

-- ایونت واقعی esx_status: "esx_customui:updateStatus" (هر ۱ ثانیه، محلی، نه شبکه‌ای)
AddEventHandler('esx_customui:updateStatus', handleStatusUpdate)

AddEventHandler('pma-voice:setTalkingMode', function(mode)
    local percent = 25
    if mode == 2 then
        percent = 50
    elseif mode == 3 then
        percent = 100
    end
    SendNUIMessage({
        id = 'hud',
        event = 'setData',
        microphone = percent,
    })
end)
