-- ============================================================
-- ریسورس "hud1" — کاملاً مستقل، هیچ وابستگی‌ای به Unique_Hud نداره
-- ============================================================
-- خودش ui_page/index.html خودشو داره (تو ui/) و فقط ۵ تا چیز نشون میده:
-- هیل، آرمور، آب (thirst)، غذا (hunger)، میکروفون.
--
-- ✅ اسم ریسورس از "1" به "hud1" تغییر کرد چون همون علت اصلی نمایش داده نشدن
-- UI بود - اسم خالص عددی باعث میشد ui_page درست ساخته نشه.

local pauseMenu = false

-- GTA native GetVehicleEngineHealth رنج تقریبی ۰ تا ۱۰۰۰ داره؛ تقسیم بر ۱۰
-- می‌کنیم تا بشه درصد ۰ تا ۱۰۰. فقط وقتی خودت رانندگی می‌کنی (نه سرنشین) نشون
-- داده میشه.
local vehicleShown = false

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

        local inVeh = IsPedInAnyVehicle(ped, false)
        local vehicle = inVeh and GetVehiclePedIsIn(ped, false) or false
        if vehicle and GetPedInVehicleSeat(vehicle, -1) ~= ped then
            vehicle = false -- فقط راننده، نه سرنشین
        end

        if vehicle then
            sendData.engine = GetVehicleEngineHealth(vehicle) / 10
            if not vehicleShown then
                vehicleShown = true
                SendNUIMessage({ id = 'hud', event = 'toggleDisplay3', key = '#engine', state = true })
            end
        elseif vehicleShown then
            vehicleShown = false
            SendNUIMessage({ id = 'hud', event = 'toggleDisplay3', key = '#engine', state = false })
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
