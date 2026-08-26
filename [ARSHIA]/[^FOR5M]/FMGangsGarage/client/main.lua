frameworkObject = nil

local fullname,photo,car,opened,jobgarage,verify = nil, nil, nil, nil, false, false
local vehicleprice = {}
local PlayerJob = {}
local sellcar = GarageData.Sell
local transferCar = GarageData.Transfer
local repair = GarageData.Repair
local MileageFormat = GarageData.MileageFormat
local yourVehicle2
local yourVehicle
local spawnedvehicle = {}
local dist2,dist3 = nil,nil

Citizen.CreateThread(function()
    frameworkObject = GetFrameworkObject() 
end)

local SpawnLocalVehicle = nil
local VehType = nil

CreateCam = function(valid,playerVeh)
	if valid then
		SetNuiFocus(true, true)
        local customVehicle = playerVeh
        SetVehicleOnGroundProperly(customVehicle)
        local vehPos = GetEntityCoords(customVehicle)
        local camPos = GetOffsetFromEntityInWorldCoords(customVehicle, -2.0, 5.0, 3.0)
        local headingToObject = GetHeadingFromVector_2d(vehPos.x - camPos.x, vehPos.y - camPos.y)
        SetVehicleEngineOn(customVehicle,true, true)
        local cam = CreateCamWithParams('DEFAULT_SCRIPTED_CAMERA', camPos.x, camPos.y, camPos.z - 2, -15.0, 0.0, headingToObject + 10, GetGameplayCamFov(), false, 2)
        SetCamActive(cam, true)
        DisplayHud(false)
        RenderScriptCams(true, true, 1000, true, true)
	else
		SetNuiFocus(false, false)
		RenderScriptCams(false, true , 1000 , false , false)
		DestroyAllCams(true)
		ClearFocus()
		DisplayHud(true)
		DisplayRadar(true)
	end
end

RegisterNetEvent(GarageData.QBCoreplayerLoaded, function()
    PlayerJob = frameworkObject.Functions.GetPlayerData()
    TriggerServerEvent("For5mG-garage:server:getName")
end)

RegisterNetEvent(GarageData.QBCoreOnJobUpdate,function(JobInfo)
	PlayerJob = frameworkObject.Functions.GetPlayerData()
end)

RegisterNetEvent(GarageData.playerLoaded)
AddEventHandler(GarageData.playerLoaded, function(xPlayer)
    PlayerJob = xPlayer
    TriggerServerEvent("For5mG-garage:server:getName")
end)

RegisterNetEvent(GarageData.setJob,function(job)
	PlayerJob = job
end)

Citizen.CreateThread(function()
    if GarageData.Framework == "esx" then
        Citizen.Wait(2500)
        frameworkObject = GetFrameworkObject() 
        frameworkObject.TriggerServerCallback('For5mG-garage:vehicleprice', function(data)
            for k,v in pairs(data) do        
                vehicleprice[v.hash] = { price = v.price}              
            end  
        end)
    else
        for k,v in pairs(frameworkObject.Shared.Vehicles) do
            vehicleprice[v.model] = { price = v.price, brand = v.brand, name = v.name  }
        end
    end
end)

RegisterNetEvent('For5mG-garage:client:open')
AddEventHandler('For5mG-garage:client:open', function(gang,coord, VehType)
    TriggerServerEvent("For5mG-garage:server:getName")
        if GarageData.Framework == "esx" then
            frameworkObject.TriggerServerCallback('For5mG-garage:getvehicles2', function(data)
                for r, v in pairs(data) do 
                    Citizen.Wait(150)
                    frameworkObject.TriggerServerCallback('For5mGangs-garage:changedCars', function(veri2)      
                        local carhash = v.vehicle["model"]
                        local carname = GetDisplayNameFromVehicleModel(carhash)           
                        local vehicleName = GetLabelText(carname)     
                        local vhclass = 1
                        local carmaxspeed   = GarageData.GetVehicleEstimatedMaxSpeed(carhash)
                        local logo = GetLabelText(Citizen.InvokeNative(0xF7AF4F159FF99F97, carhash, Citizen.ResultAsString()))
                        local fuel = v.vehicle["fuelLevel"]
                        local weight = GarageData.Weight[vhclass]
                        local ac = GetVehicleModelAcceleration(carhash)
                        local text = GarageData.Text[vhclass]
                        local stored = v.stored
                        if GarageData.Out then
                            if veri2 then
                                stored = -1
                            end
                        end
                        if vehicleprice[carhash] ~= nil then 
                            local price = vehicleprice[carhash]
                            vhprice = price.price / 2 
                        else
                            vhprice = GarageData.Defaultprice
                        end    
                        SpawnLocalVehicle = coord
                            OpenGarage(fullname,photo,v.vehicle["plate"],carmaxspeed,coord,stored,vhclass,vehicleName,false,vhprice,v.favorite,sellcar,transferCar,fuel,job,logo,weight,ac,text,MileageFormat,repair)
                       
                    end,v.vehicle["plate"])
                end
            end, gang, VehType)
        end
        
end)

function round(num, numDecimalPlaces)
    local mult = 100^(numDecimalPlaces or 0)
    return math.floor(num * mult + 0.5) / mult
end

function OpenGarage(fullname,photo,plate2,carmaxspeed,garage2,stored2,vhclass,vehicleName,job2,vhprice,favorite2,sellcar2,transferCar2,fuel2,garage3,logo2,weight2,acce2,text2,mileageFormat2,repair2)
    frameworkObject.TriggerServerCallback('FMGangs:GetMyGangLogo', function(Logo , myavatar )     
        SendNUIMessage({
            action  = true,
            name    = fullname,
            avatar  = myavatar,
            plate   = plate2,
            max     = carmaxspeed,
            garage  = garage2,
            stored  = stored2,
            vhclass = vhclass,
            carname = vehicleName,
            ganglogo = Logo , 
            job = job2,
            vehprice = vhprice,
            favorite = favorite2,
            sellcar = sellcar2,
            transferCar = transferCar2,
            fuel = fuel2,
            jobgarage = garage3,
            logo = logo2,
            weight = weight2,
            acce = acce2,
            text = text2,
            mileageFormat = mileageFormat2,
            repair = repair2
        })
        SetNuiFocus(true, true)
    end)
end

RegisterNetEvent('For5M:OpenGarage')
AddEventHandler('For5M:OpenGarage', function(gang, spawncoord, types)
    
    local PlayerPed = PlayerPedId()
    local PCoord = GetEntityCoords(PlayerPed)
    local GetPlayerCar = GetVehiclePedIsIn(PlayerPed)
    VehType = types
    frameworkObject.TriggerServerCallback('For5mG-garage:getvehicles', function(data)
        if data then
            TriggerEvent("For5mG-garage:client:open", gang, spawncoord, types)
            opened = true
        else
            frameworkObject.ShowNotification('This Garage Does Not Have a ' .. types )
        end
    end, gang, types)
end)
    
local repaired = false

RegisterNUICallback("repairvehicle", function()
    if GarageData.Framework == 'esx' then
        frameworkObject.TriggerServerCallback('For5mGangs-garage:checkMoneyCars', function(hasEnoughMoney)
            if hasEnoughMoney and not repaired then
                SetVehicleEngineHealth(car, 1000)
                SetVehicleFixed(car)
                SetVehicleDirtLevel(car, 0)
                SetVehiclePetrolTankHealth(car, 1000.0)
                TriggerServerEvent('For5mGangs-garage:pay', 'repair')
                repaired = true
            else
                GarageData.Notification(GarageData.Notifications["nomoneyreapir"]["message"],GarageData.Notifications["nomoneyreapir"]["type"])
            end
        end, 'repair')
    else
        frameworkObject.Functions.TriggerCallback('For5mGangs-garage:checkMoneyCars', function(hasEnoughMoney)
            if hasEnoughMoney and not repaired then
                SetVehicleEngineHealth(car, 1000)
                SetVehicleFixed(car)
                SetVehicleDirtLevel(car, 0)
                SetVehiclePetrolTankHealth(car, 1000.0)
                TriggerServerEvent('For5mGangs-garage:pay', 'repair')
                repaired = true
            else
                GarageData.Notification(GarageData.Notifications["nomoneyreapir"]["message"],GarageData.Notifications["nomoneyreapir"]["type"])
            end
        end, 'repair')
    end
end)

RegisterNUICallback("transfervehicle", function(data)
    opened = false
    local id = tonumber(data.id)
    local plate = data.plate 
    TriggerServerEvent("For5mG-garage:transfervehicle", id, plate)
end)

RegisterNUICallback("sellvehicle", function(data)
    opened = false
    local plate = data.plate 
    local price = data.price
    TriggerServerEvent("For5mG-garage:sell", plate, price)
end)


RegisterNUICallback("addfavorite", function(data)
    TriggerServerEvent('For5mG-garage:favorite',data.plate,data.bool)
end)

-- Vehicle Spawn
local currentlivery = nil

RegisterNUICallback("mods", function(data)
    local PlayerPed = PlayerPedId()
    local GetPlayerCar =  GetVehiclePedIsIn(PlayerPed)
    if data.mod == 'extras' then
        if IsVehicleExtraTurnedOn(GetPlayerCar, tonumber(data.count)) then
            SetVehicleExtra(GetPlayerCar, tonumber(data.count) , 1)
        else
            SetVehicleExtra(GetPlayerCar, tonumber(data.count) , 0)
        end
    elseif data.mod == 'livery' then
        SetVehicleLivery(GetPlayerCar, data.count)

        currentlivery = data.count
    end
end)

local veh_extras = {['vehicleExtras'] = {}}
local livery = 0
RegisterNUICallback("apply", function(data)
    local PlayerPed = PlayerPedId()
    local GetPlayerCar = GetVehiclePedIsIn(PlayerPed)
    if IsVehicleExtraTurnedOn(GetPlayerCar, tonumber(data.count)) then
        SetVehicleExtra(GetPlayerCar, tonumber(data.count) , 1)
    else
        SetVehicleExtra(GetPlayerCar, tonumber(data.count) , 0)
    end
	for extraID = 0, 20 do
        veh_extras.vehicleExtras[extraID] = (IsVehicleExtraTurnedOn(GetPlayerCar, extraID) == 1)
    end
    livery = GetVehicleLivery(GetPlayerCar)
end)

RegisterNUICallback("spawnvehicle", function(data)
    if GarageData.Framework == "esx" then
        
            frameworkObject.TriggerServerCallback('For5mG-garage:props', function(cars2)
                local props = json.decode(cars2[1].vehicle)
                frameworkObject.Game.SpawnVehicle(props.model, vector3(SpawnLocalVehicle.x, SpawnLocalVehicle.y, SpawnLocalVehicle.z), SpawnLocalVehicle.h, function(yourVehicle2)
                    SetVehicleNumberPlateText(yourVehicle2, props.plate)
                    car2 = yourVehicle2
                    GarageData.SetVehicleFuel(yourVehicle2,props.fuelLevel)
                    frameworkObject.Game.SetVehicleProperties(yourVehicle2,props)
                    TaskWarpPedIntoVehicle(PlayerPedId(), yourVehicle2, -1)
                    VehicleKeys(props.plate,data.plate)
                    SetEntityAsMissionEntity(yourVehicle2, true, true)
                    TriggerServerEvent("garage:addKeys", GetVehicleNumberPlateText(yourVehicle2))
                    TriggerServerEvent('For5M:SendLog', GetPlayerServerId(PlayerId()) , 'Garage' , 'Spawn Vehicle | '..props.model    )
                    CreateCam(false)
                    if repaired then
                        SetVehicleEngineHealth(yourVehicle2, 1000)
                        SetVehicleFixed(yourVehicle2)
                        SetVehicleDirtLevel(yourVehicle2, 0)
                        SetVehiclePetrolTankHealth(yourVehicle2, 1000.0)
                        repaired = false
                    end
                end)
                TriggerServerEvent('For5mG-garage:stored', data.plate , 0)
                opened = false
            end, data.plate)
    end
end)

RegisterNUICallback("spawnvehiclevale", function(data)
    if GarageData.Framework == "esx" then
        frameworkObject.TriggerServerCallback('For5mGangs-garage:checkMoneyCars', function(hasEnoughMoney)
            if hasEnoughMoney then
                frameworkObject.TriggerServerCallback('For5mG-garage:props', function(cars2)
                    local props = json.decode(cars2[1].vehicle)
                    frameworkObject.Game.SpawnVehicle(props.model, GarageData.Garages[data.garage]["car"].spawncar, GarageData.Garages[data.garage]["car"].spawncar.w, function(yourVehicle2)
                        car2 = yourVehicle2
                        SetVehicleNumberPlateText(yourVehicle2, props.plate)
                        GarageData.SetVehicleFuel(yourVehicle2,tonumber(data.fuel))
                        SetEntityAsMissionEntity(yourVehicle2, true, true)
                        VehicleKeys(props.plate,data.plate)
                        frameworkObject.Game.SetVehicleProperties(yourVehicle2,props)
                        TaskWarpPedIntoVehicle(PlayerPedId(),yourVehicle2,-1)
                        if repaired then
                            SetVehicleEngineHealth(yourVehicle2, 1000)
                            SetVehicleFixed(yourVehicle2)
                            SetVehicleDirtLevel(yourVehicle2, 0)
                            SetVehiclePetrolTankHealth(yourVehicle2, 1000.0)
                            repaired = false
                        end
                    end)
        
                    TriggerServerEvent('For5mG-garage:stored', data.plate , 0)
                    TriggerServerEvent('For5mGangs-garage:pay', 'vale')
                    opened = false
                end, data.plate)
            else
                GarageData.Notification(GarageData.Notifications["nomoneyvale"]["message"],GarageData.Notifications["nomoneyvale"]["type"])
            end
        end ,'vale')

    end
end)

RegisterNUICallback("spawnlocalvehicle", function(data,cb)
    if GarageData.Framework == "esx" then
        
            frameworkObject.TriggerServerCallback('For5mG-garage:props', function(cars)
                local props = json.decode(cars[1].vehicle)
                frameworkObject.Game.SpawnLocalVehicle(props.model, vector3(SpawnLocalVehicle.x, SpawnLocalVehicle.y, SpawnLocalVehicle.z), SpawnLocalVehicle.h, function(yourVehicle)
                    frameworkObject.Game.SetVehicleProperties(yourVehicle, props)
                    SetVehicleNumberPlateText(yourVehicle, props.plate)
                    CreateCam(true, yourVehicle)
                    car = yourVehicle
                    VehicleKeys(data.plate,props.plate)
                    cb(true)
                    FreezeEntityPosition(yourVehicle, true)
                    SetEntityCollision(yourVehicle,false)
             
                end)
            end, data.plate)
            repaired = false
            if DoesEntityExist(car) then
                DeleteEntity(car)
            end   
    end
end)
RegisterNetEvent("For5mG-garage:client:getNameAvatar")
AddEventHandler("For5mG-garage:client:getNameAvatar", function(name,avatar)
    fullname = name
    photo   = avatar
end)
RegisterNUICallback("rotateright", function()
    SetEntityHeading(car, GetEntityHeading(car) - 3.0)
end)

RegisterNUICallback("rotateleft", function()
    SetEntityHeading(car, GetEntityHeading(car) + 3.0)
end)
RegisterNUICallback("close", function(data)
  
    opened = false
    jobgarage = false
    SetNuiFocus(false, false)
    DestroyCam(cam)
	RenderScriptCams(0, 1, 750, 1, 0)
    if DoesEntityExist(car) then
        DeleteEntity(car)
    end
end)

