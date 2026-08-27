-- ============================================================
-- ریسورس "1" — کاملاً مستقل، هیچ وابستگی‌ای به Unique_Hud نداره
-- ============================================================
-- این ریسورس خودش ui_page/index.html خودشو داره (تو ui/) که فقط ۵ تا چیز
-- توشه: هیل، آرمور، آب (thirst)، غذا (hunger)، میکروفون. کاملاً جدا از
-- Unique_Hud اجرا میشه و هیچ export/dependency ای بین‌شون نیست.

local waterHide, foodHide = false, false
local pauseMenu = false

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

        -- GetEntityHealth پد بین ۱۰۰ (مرگ) تا ۲۰۰ (کامل) برمی‌گرده، برای همین
        -- ۱۰۰ ازش کم میشه تا دایره‌ی هیل درصد ۰ تا ۱۰۰ درست رو نشون بده.
        -- GetPedArmour از قبل خودش ۰ تا ۱۰۰ هست، نیازی به تغییر نداره.
        -- چون این ریسورس خودش ui_page داره، SendNUIMessage همینجا درست کار می‌کنه.
        SendNUIMessage({
            id = 'hud',
            event = 'setData',
            health = GetEntityHealth(ped) - 100,
            armor = GetPedArmour(ped),
            talking = MumbleIsPlayerTalking(player),
        })
    end
end)

local function handleStatusUpdate(data)
    local sendData = {
        id = 'hud',
        event = 'setData',
    }
    for k, v in pairs(data) do
        if v.name == 'thirst' then
            local val = v.val / 10000
            sendData.thirst = val
            if val > 80 then
                if not waterHide then
                    waterHide = true
                    SendNUIMessage({
                        id = 'hud',
                        event = 'toggleDisplay3',
                        key = '#thirst',
                        state = false,
                    })
                end
            elseif waterHide then
                waterHide = false
                SendNUIMessage({
                    id = 'hud',
                    event = 'toggleDisplay3',
                    key = '#thirst',
                    state = true,
                })
            end
        elseif v.name == 'hunger' then
            local val = v.val / 10000
            sendData.hunger = val
            if val > 80 then
                if not foodHide then
                    foodHide = true
                    SendNUIMessage({
                        id = 'hud',
                        event = 'toggleDisplay3',
                        key = '#hunger',
                        state = false,
                    })
                end
            elseif foodHide then
                foodHide = false
                SendNUIMessage({
                    id = 'hud',
                    event = 'toggleDisplay3',
                    key = '#hunger',
                    state = true,
                })
            end
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
