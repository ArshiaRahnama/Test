-- Pub by FleeX Team , https://discord.gg/87rGBxgCsa

local insuranceData = {}
CreateThread(function()
    repeat Wait(50) until ESX and playerLoaded
    while not lib do Wait(100) end
    lib.registerMenu({
        id = 'vehicleInsurance',
        title = 'Bimeh Mashin',
        onSideScroll = function(selected, scrollIndex, args)
                insuranceData.type = scrollIndex
        end,
        options = {}
    }, function(selected, scrollIndex, args)
        if args == 'pay' then
            ESX.TriggerServerEvent('vehicle-insurance:pay', insuranceData)
        end
    end)
end)
RegisterNetEvent('insurance:openMenu', function(sender)
    local vehicle = ESX.isVehicleDriver()
    if vehicle then
        insuranceData = {type = 1, plate = ESX.GetPlate(vehicle)}
        local options, values = {}, {}
        table.insert(options, {label = 'Plan ha', icon = 'hand-point-down', close = false})
        for k, v in pairs(Shared.carbimeh.config.plans) do
            table.insert(options, {label = ('#%s Repair : %s | Impound : %s | Day : %s | Price : $%s'):format(k, v.fixCount or 0, v.impoundCount or 0, v.dayExpiration, ESX.Math.GroupDigits(v.price)), close = false})
            table.insert(values, ('#%s'):format(k))
        end
        table.insert(options, {label = 'Noe Plan', values = values, close = false})
        table.insert(options, {label = ('Plate : %s'):format(ESX.GetPlate(vehicle)), close = false})
        table.insert(options, {label = 'Pardakht', args = 'pay'})
        lib.setMenuOptions('vehicleInsurance', options)
        lib.showMenu('vehicleInsurance')
    else
        ESX.chatMessage('Jahat bime kardan bayad savar mashin bashid', 'plarms')
    end
end)

local cd = false
RegisterCommand('bimeh', function(src, args)
    local vehicle = ESX.isVehicleDriver()
    if vehicle then
        if exports['sunset_utils']:canAccessToVehicle(vehicle) then
           exports['sun-jobs']:checkVehicleInsurance(vehicle)
        else
            ESX.chatMessage('Shoma dastresi be bime nameh in mashin nadarid', 'plarms')
        end
    end
end, false)

exports('checkVehicleInsurance', function(vehicle)
    if cd then return end
    cd = true
    SetTimeout(10000, function()
        cd = false
    end)
    ESX.TriggerServerCallback('parking:getVehicleMetaData', function(metadata)
        if metadata and metadata.insurance then
            ESX.chatMessage(('Tedad repair : %s, Impound : %s, Expire : %s Ruz'):format(metadata.insurance.fixCount, metadata.insurance.impoundCount, ESX.Math.Round((metadata.insurance.endTime - exports['sunset_utils']:GetServerOSTime()) / 86400)), 'plarms')
        else
            ESX.chatMessage('In mashin bime nadarad', 'plarms')
        end
        local thread = true
        SetTimeout(20000, function()
            thread = false
        end)
        ESX.TriggerServerCallback('chopshop:server:isChopped',function(choped)
            CreateThread(function()
                while thread do
                    Wait(0)
                    local vehpos = GetOffsetFromEntityInWorldCoords(vehicle, 0.0, 0.0, 2.0)
                    ESX.Game.Utils.DrawText3D(vector3(vehpos.x, vehpos.y, vehpos.z - 0.0),'Vaziat Bime : '.. (metadata and metadata.insurance and 'Bale' or 'Kheir'),1)
                    ESX.Game.Utils.DrawText3D(vector3(vehpos.x, vehpos.y, vehpos.z - 0.25),'Mashmul Bime : '.. (GetVehicleEngineHealth(vehicle) < 600 and 'Bale' or 'Kheir'),1)
                    ESX.Game.Utils.DrawText3D(vector3(vehpos.x, vehpos.y, vehpos.z - 0.5),'Salamate Badane : '.. ESX.Math.Round((GetVehicleBodyHealth(vehicle) / 10)).. '%',1)
                    ESX.Game.Utils.DrawText3D(vector3(vehpos.x, vehpos.y, vehpos.z - 0.75),'Salamate motor : ' .. ESX.Math.Round(GetVehicleEngineHealth(vehicle) / 10) .. '%',1)
                    ESX.Game.Utils.DrawText3D(vector3(vehpos.x, vehpos.y, vehpos.z - 1.0),'Engine : '.. tostring(choped == true and 'Kheir' or 'Bale'),1)
                end
            end)
        end, ESX.GetPlate(vehicle))
    end, ESX.GetPlate(vehicle))
end)

exports('getVehicleInsuranceData', function(vehicle)
    local p = promise.new()
    ESX.TriggerServerCallback('parking:getVehicleMetaData', function(metadata)
        p:resolve(metadata and metadata.insurance)
    end, DoesEntityExist(vehicle) and ESX.GetPlate(vehicle) or vehicle)
    return Citizen.Await(p)
end)

RegisterNetEvent('insurance:useInsuranceStuff', function(vehicle)
    SetVehicleDirtLevel(vehicle, 0.0)
    exports['sunset_utils']:SetFuel(vehicle, 100.0)
end)