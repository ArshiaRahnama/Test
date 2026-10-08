--[[ ===========================================================================
    esx_uniquejobs | client/job_fleet_helper.lua

    ---------------------------------------------------------------------------
    چرا این فایل لازم بود (درخواست شده: «همون منو که برای گنگ گرفتم رو برای
    گاراژ جاب‌ها هم بیار»)
    ---------------------------------------------------------------------------
    هر کدوم از ۱۳ فایل جاب (police/fbi/sheriff/...) بعد از انتخاب مدل از لیست
    مجاز، به‌جای دیالوگ پلاک دستی + اسپان مستقیم (که هیچ‌وقت persist نمی‌شد و
    رفت‌وآمدش کاملاً جدا از گاراژ واقعی بود)، الان این تابع رو صدا می‌زنن:

        OpenJobFleetGarage(model)

    این تابع:
    ۱. سرور (`esx_society:takeJobVehicle`) رو صدا می‌زنه - اونجا چک می‌شه که
       این مدل واقعاً برای رتبه‌ی فعلی بازیکن مجازه (`esx_society`'s Vehicle
       Access، همون چیزی که از boss action ست می‌شه)، پلاک از روی callsign
       یونیت بازیکن ساخته میشه، و (اگه از قبل ثبت نشده بود) به‌عنوان یه
       ماشین واقعی تو owned_vehicles ثبت می‌شه.
    ۲. بعد از تأیید سرور، دقیقاً همون منوی Unique_Garage که گاراژ گنگ استفاده
       می‌کنه رو باز می‌کنه (`Unique_Garage:OpenJobFleetGarage`) - یعنی همون
       پیش‌نمایش سه‌بعدی و ظاهر، به‌جای لیست ساده‌ی قدیمی.
=========================================================================== ]]

-- FIX (console: 'event esx_society:jobVehicleReady/Failed was not safe for net'): events sent by the SERVER with TriggerClientEvent must be registered with RegisterNetEvent on the client, otherwise they are dropped - that is why the fleet always timed out with 'Could not reach the vehicle fleet'.
RegisterNetEvent('esx_society:jobVehicleReady')
RegisterNetEvent('esx_society:jobVehicleFailed')

function OpenJobFleetGarage(model)
    local job = ESX.PlayerData.job and ESX.PlayerData.job.name
    if not job or job == 'nojob' then return end

    local playerCoords = GetEntityCoords(PlayerPedId())
    local heading = GetEntityHeading(PlayerPedId())

    -- FIX (reported: generic "Could not reach the vehicle fleet - try
    -- again" showing up alongside - or instead of noticing - a specific
    -- denial like "not authorized" or "create a unit first"): this used
    -- to only listen for success and otherwise always waited out the full
    -- 5-second timeout before showing a generic message, even when
    -- esx_society had already told the player exactly why it failed,
    -- immediately. Now also listens for 'esx_society:jobVehicleFailed'
    -- (fired on every denial path in esx_society/server/main.lua) and
    -- stops waiting the instant EITHER signal arrives - the generic
    -- message only shows for a genuine timeout where neither fired at all.
    local done, failed = false, false
    local readyHandler = AddEventHandler('esx_society:jobVehicleReady', function(readyJob)
        if readyJob == job then
            done = true
        end
    end)
    local failHandler = AddEventHandler('esx_society:jobVehicleFailed', function()
        failed = true
    end)

    TriggerServerEvent('esx_society:takeJobVehicle', model)

    Citizen.CreateThread(function()
        local timeout = GetGameTimer() + 5000
        while not done and not failed and GetGameTimer() < timeout do
            Citizen.Wait(0)
        end
        RemoveEventHandler(readyHandler)
        RemoveEventHandler(failHandler)

        if done then
            TriggerEvent('Unique_Garage:OpenJobFleetGarage', job, {
                x = playerCoords.x, y = playerCoords.y, z = playerCoords.z, h = heading
            }, 'car')
        elseif not failed then
            -- Neither signal arrived at all within the timeout - a genuine
            -- unexpected failure (esx_society not running, dropped event,
            -- etc.), not a normal denial esx_society already explained.
            ESX.ShowNotification('Could not reach the vehicle fleet - try again')
        end
        -- if `failed` is true, esx_society already showed the specific
        -- reason - nothing more to show here.
    end)
end
