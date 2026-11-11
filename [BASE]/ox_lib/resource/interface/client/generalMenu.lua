-- General menu (منو جنرال) - ported from Sunset sunset_utils/modules/radial.
-- Built into ox_lib: opens with the End key through the radial menu (rebind it in FiveM key settings).
--
-- Items fire the same events Sunset used. Events whose resource is not on this
-- server yet (sun-phone, sun-jobs serial, pma-voice radio, sunset_housing) simply
-- do nothing until that resource is started - no errors.

local ESX

local function getPlayerData()
    if not ESX and GetResourceState('essentialmode') == 'started' then
        local ok, obj = pcall(function() return exports['essentialmode']:getSharedObject() end)

        if ok and type(obj) == 'table' then ESX = obj end
    end

    if ESX and ESX.GetPlayerData then
        local ok, data = pcall(ESX.GetPlayerData)

        if ok and type(data) == 'table' then return data end
    end

    return {}
end

local function copied(value)
    lib.setClipboard(tostring(value))
    lib.notify({ description = 'کپی شد!', type = 'success' })
end

local function failed(text)
    lib.notify({ description = text, type = 'error' })
end

AddEventHandler('copynearplate', function()
    local vehicle = lib.getClosestVehicle(GetEntityCoords(cache.ped), 10.0, true)

    if vehicle and vehicle ~= 0 then
        copied(GetVehicleNumberPlateText(vehicle))
    else
        failed('ماشینی در کنار شما نیست!')
    end
end)

AddEventHandler('copyhex', function()
    local identifier = getPlayerData().identifier

    if identifier then
        copied(identifier)
    else
        failed('شناسه‌ی شما پیدا نشد!')
    end
end)

AddEventHandler('togglehouseblip', function()
    ExecuteCommand('showhouse')
end)

CreateThread(function()
    lib.registerRadial({
        id = 'fast_menu',
        items = {
            {
                label = 'کپی شماره تلفن',
                icon = 'phone-volume',
                onSelect = function()
                    TriggerEvent('sunset_phone:CopyNumber')
                end
            },
            {
                label = 'کپی پلاک ماشین',
                icon = 'car',
                onSelect = function()
                    TriggerEvent('copynearplate')
                end
            },
            {
                label = 'کپی استیم هگز',
                icon = 'hashtag',
                onSelect = function()
                    TriggerEvent('copyhex')
                end
            },
            {
                label = 'نمایش خانه های قابل خرید',
                icon = 'house',
                onSelect = function()
                    TriggerEvent('togglehouseblip')
                end
            },
            {
                label = 'کپی سریال اسلحه',
                icon = 'barcode',
                onSelect = function()
                    TriggerEvent('CopyCurrentWeaponSerial')
                end
            },
        }
    })

    lib.registerRadial({
        id = 'gps_menu',
        items = {
            {
                label = 'ارسال هشدار',
                icon = 'bell',
                onSelect = function()
                    TriggerEvent('radio:sendAlert')
                end
            },
            {
                label = 'GPS نمایش',
                icon = 'earth-americas',
                onSelect = function()
                    TriggerEvent('radio:gs')
                end
            },
        }
    })

    lib.addRadialItem({
        id = 'fast',
        icon = 'bolt',
        label = 'دسترسی سریع',
        menu = 'fast_menu'
    })

    lib.addRadialItem({
        id = 'gps',
        icon = 'location-dot',
        label = 'جی پی اس',
        menu = 'gps_menu'
    })
end)
