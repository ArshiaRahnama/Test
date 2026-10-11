local function FDbg(...) end -- fleet debug output disabled (swap body for print(...) to re-enable)
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

function OpenJobFleetGarage(model, vehType)
    vehType = vehType or 'car'
    local job = ESX.PlayerData.job and ESX.PlayerData.job.name
    if not job or job == 'nojob' then return end

    local playerCoords = GetEntityCoords(PlayerPedId())
    local heading = GetEntityHeading(PlayerPedId())

    -- Organ services (taxi/mechanic/ambulance/weazel) enter their own plate;
    -- military/law jobs get the plate from their unit callsign (server side).
    local customPlate = nil
    local dept = GetDepartmentForJob and GetDepartmentForJob(job)
    local isMilitary = dept and (dept.id == 'doj' or dept.id == 'le')
    if not isMilitary then
        local input = lib.inputDialog('Enter Vehicle Plate', {'Plate (6 characters)'}, {max = 6})
        if not input or not input[1] or input[1] == '' then return end
        customPlate = input[1]
    end

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

    FDbg(('[LOCKDBG][fleet] takeJobVehicle model=%s vehType=%s plate=%s military=%s'):format(tostring(model), tostring(vehType), tostring(customPlate), tostring(isMilitary)))
    TriggerServerEvent('esx_society:takeJobVehicle', model, vehType, customPlate)

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
            }, vehType)
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


-- E at the vehicle marker: if the job has fleet vehicles for this rank, open
-- the Unique_Garage menu directly; otherwise fall back to the legacy list menu.
RegisterNetEvent('esx_society:jobFleetStatusResult')
function OpenJobFleetOrLegacy(legacyFn, vehType)
    vehType = vehType or 'car'
    local job = ESX.PlayerData.job and ESX.PlayerData.job.name
    if not job or job == 'nojob' then if legacyFn then legacyFn() end return end
    local answered, has = false, false
    local h = AddEventHandler('esx_society:jobFleetStatusResult', function(v) answered = true has = v FDbg(('[LOCKDBG][fleet] status reply job=%s vehType=%s -> %s'):format(tostring(job), tostring(vehType), tostring(v))) end)
    TriggerServerEvent('esx_society:requestJobFleetStatus', vehType)
    local p = GetEntityCoords(PlayerPedId())
    local hd = GetEntityHeading(PlayerPedId())
    Citizen.CreateThread(function()
        local t = GetGameTimer() + 3000
        while not answered and GetGameTimer() < t do Citizen.Wait(0) end
        RemoveEventHandler(h)
        if not answered then FDbg(('[LOCKDBG][fleet] NO status reply within 3s (job=%s vehType=%s) -> legacy menu'):format(tostring(job), tostring(vehType))) end
        if answered and has == 'nounit' then
            return -- server already told the player to join a unit
        elseif answered and has == true then
            TriggerEvent('Unique_Garage:OpenJobFleetGarage', job, { x = p.x, y = p.y, z = p.z, h = hd }, vehType)
        elseif legacyFn then
            legacyFn()
        end
    end)
end
