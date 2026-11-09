-- Pub by FleeX Team , https://discord.gg/87rGBxgCsa

CreateThread(function()
    waitForLoad(5000)
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

AddEventHandler('copynearplate',function()
    local veh , distance = ESX.Game.GetClosestVehicle()
    if veh ~= -1 and distance <= 10 then
        exports['esx_carjob']:SetClipboard(GetVehicleNumberPlateText(veh))
        ESX.Alert('OK','Copy shod!',5000,'success')
    else
        ESX.Alert('Ow','Mashini dar kenar shoma nist!',5000,'error')
    end
end)

AddEventHandler('copyhex',function()
    exports['esx_carjob']:SetClipboard(ESX.GetPlayerData().identifier)
    ESX.Alert('OK','Copy shod!',5000,'success')
end)

AddEventHandler('togglehouseblip',function()
    ExecuteCommand('showhouse')
end)