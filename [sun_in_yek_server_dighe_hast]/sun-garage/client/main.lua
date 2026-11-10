-- Pub by FleeX Team , https://discord.gg/87rGBxgCsa

ESX = exports['essentialmode']:getObject()
local doesBan = false
local currentZone
local vehiclesDB, loaded, vehicleDBCount = {}, false, 0
local camera = nil
local currentMenuType
local previewVehicle
local currentVehicle, currentVehicleType = 0, nil
local otherZoneData = {}
local spawnCB = nil
local inMenu = false
local whiteListWorld = {
    [0] = true,
    [97] = true,
}

local function isPlayerBusy()
    local ped = PlayerPedId()
    if IsPedRagdoll(ped) or IsEntityAttached(ped) then
        ESX.notification('error', 'Dar in halat nemitavanid az parking estefade konid')
        return true
    end
    local handle, nearPed = FindFirstPed()
    local found = true
    while found do
        if nearPed ~= ped and IsEntityAttachedToEntity(nearPed, ped) then
            EndFindPed(handle)
            ESX.notification('error', 'Dar in halat nemitavanid az parking estefade konid')
            return true
        end
        found, nearPed = FindNextPed(handle)
    end
    EndFindPed(handle)
    return false
end

local function clearPlayerState()
    local ped = PlayerPedId()
    ClearPedTasksImmediately(ped)
    DetachEntity(ped, true, false)
end
Citizen.CreateThread(function()
	while ESX == nil or ESX.GetPlayerData().job == nil do
		Wait(5000)
	end
	ESX.PlayerData = ESX.GetPlayerData()
	Wait(6000)
	ESX.TriggerServerCallback('garage:checkBan',function(state, _vehicles)
		doesBan = state
        -- vehiclesDB = _vehicles
        -- vehicleDBCount = ESX.tableLength(_vehicles)
        -- loaded = true
	end)
    TriggerServerEvent('garage:getVehiclesInfo')
    while not lib do Wait(100) end
    lib.registerMenu({
        id = 'garageBack',
        title = 'Enteghal Mashin',
        options = {}
    }, function(selected, scrollIndex, args)
        TriggerServerEvent('garage:changeGarage', args.plate, currentZone.index, args.value)
    end)
    lib.registerMenu({
        id = 'garageImpound2',
        title = 'Impound',
        options = {}
    }, function(selected, scrollIndex, args)
        if args.fine > 0 then
            local alert = lib.alertDialog({
                header = 'Pardakht jarime',
                content = ('Shoma aval bayad jarime mashin ra jahat khorouj az impound pardakht konid \n Mablagh jarime $%s'):format(ESX.Math.GroupDigits(args.fine)),
                centered = true,
                cancel = true
            })
            if alert == 'confirm' then
                ESX.TriggerServerEvent('garage:payFine', args.plate)
            end
        else
            local cost = args.type == 'car' and Config.CarPoundPrice or (args.type == 'heli' or args.type == 'aircraft') and Config.AircraftPoundPrice or args.type == 'boat' and Config.BoatPoundPrice
            ESX.TriggerServerCallback('garage:checkRepairCost', function(hasEnoughMoney)
                if hasEnoughMoney then
                    args.cost = cost
                    TriggerServerEvent('garage:StartFindingVehicle', args)
                else
                    ESX.ShowNotification('Poul kafi nadarid')
                end
            end, cost, true)
        end
    end)
    for k, v in pairs(Config.zones) do
        for k2, v2 in pairs(v.coords) do
            if v2.blip then
                ESX.AddBlipForCoord(v2.blip.xyz, 0.5, v.type == 'car' and 357 or v.type == 'heli' and 64 or v.type == 'boat' and 410, 81, ('Garage %s'):format(v.label2))
            end
        end
    end
    for k,v in pairs(Config.pounds) do
        exports['sunset_utils']:createLocalPed(4, Config.pedModel[math.random(1, #Config.pedModel)], v - vec(0, 0, 1, 0), function(ped)
            SetEntityAsMissionEntity(ped)
            SetBlockingOfNonTemporaryEvents(ped, true)
            FreezeEntityPosition(ped, true)
            SetEntityInvincible(ped, true)
            local options = {}
            table.insert(options, {
                label = '🚗ترخیص وسیله نقیله ',
                onSelect = function()
                    if ESX.GetPlayerData().World == 0 then
                        openImpoundMenu()
                        ESX.registerExitPoint(5)
                    end
                end,
            })
            exports['ox_target']:addLocalEntity({ped}, options)
        end, function(ped)
            exports['ox_target']:removeLocalEntity(ped)
        end)
    end
end)

RegisterNetEvent('garage:getVehiclesInfo:cb', function(_vehicles)
    vehiclesDB = _vehicles
    vehicleDBCount = ESX.tableLength(_vehicles)
    loaded = true
end)

RegisterNetEvent('esx:setGang', function(gang)
    ESX.PlayerData.gang = gang
end)

CreateThread(function()
    for k, v in pairs(Config.zones) do
        for k2, v2 in pairs(v.coords) do
            lib.zones.sphere({
                coords = v2.garagePoint.xyz,
                radius = v2.garagePoint.w,
                onEnter = function ()
                    currentZone = {k = k, type = v.type, index = k2}
                    lib.showTextUI(v.label, {
                        position = 'left-center',
                        icon = v.icon,
                        style = {
                            borderRadius = 5,
                            backgroundColor ='#FFA500',
                            color = 'black',
                        }
                    })
                end,
                onExit = function ()
                    currentZone = nil
                    lib.hideTextUI()
                    SendNuiMessage(json.encode({action = 'Close'}))
                end
            })
        end
    end
end)

AddEventHandler('KeyDown:e', function()
    if currentZone and whiteListWorld[ESX.GetPlayerData().World] then
        if currentZone.k:find('spawn') then
            if ESX.isVehicleDriver() then
                local vehicle = ESX.isVehicleDriver()
                local ped = PlayerPedId()
                local vehicleType = 'car'
                if IsPedInAnyBoat(ped) or ESX.submarines[GetEntityModel(vehicle)] then
                    vehicleType = 'boat'
                elseif IsPedInAnyPlane(ped) then
                    vehicleType = 'aircraft'
                elseif IsPedInAnyHeli(ped) then
                    vehicleType = 'heli'
                end
                local canPark = false
                if currentZone.type == vehicleType or (currentZone.type == 'heli' and vehicleType == 'aircraft') then
                    local alert = lib.alertDialog({
                        header = 'Park',
                        content = 'Aya mayel be park mashin hastid?',
                        centered = true,
                        cancel = true
                    })
                    if alert == 'confirm' then
                        local plate = ESX.GetPlate(vehicle)
                        payFixVehicle(vehicle)
                        parkVehicle(vehicle)
                        ESX.TriggerServerCallback('garage:vehiclePutGangCheck', function(state)
                            if state == 2 then
                                local alert = lib.alertDialog({
                                    header = 'Park mashin shakhsi',
                                    content = 'Aya mayel be dar avordan mashin khod az gang hastid?',
                                    centered = true,
                                    cancel = true
                                })
                                if alert == 'confirm' then
                                    ESX.TriggerServerEvent('garage:setGangVehicle', plate, false)
                                end
                            elseif state == 1 and ESX.PlayerData.gang.name ~= 'nogang' and ESX.doesHaveGangPerm('putVehicle') and (vehicleType == 'heli' or vehicleType == 'aircraft' or vehicleType == 'boat') then
                                ESX.TriggerServerCallback('garage:vehiclePutGangCheck', function(state)
                                    if state == 1 then
                                        local alert = lib.alertDialog({
                                            header = 'Park mashin shakhsi',
                                            content = 'Aya mayel be park movaghat mashin khod dar gang hastid?',
                                            centered = true,
                                            cancel = true
                                        })
                                        if alert == 'confirm' then
                                            ESX.TriggerServerEvent('garage:setGangVehicle', plate, true)
                                        end
                                    end
                                end, plate)
                            end
                        end, plate)
                    end
                else
                    ESX.Alert('', 'In vasile naghlie ghabeliat park dar inja ra nadarad!', 7000, 'error')
                end
            else
                if isPlayerBusy() then return end
                if doesBan then return ESX.Alert('','Shoma be dalile '.. doesBan .. ' dastresi estefade az parking ra nadarid!', 10000, 'error') end
                if exports['sunset_utils']:isTradeBan() then
                    return ESX.chatMessage('Shoma trade ban hastid', 'plarms')
                end
                openSpawnMenu('self', currentZone)
            end
        end
    end
end)

function parkVehicle(vehicle)
    local plate = ESX.GetPlate(vehicle)
    ESX.TriggerServerEvent('setEntityState', NetworkGetNetworkIdFromEntity(vehicle), 'piadeShid', true)
    Wait(2000)
    local metadata = ESX.Game.getVehicleMetaData(vehicle)
    local damages = getVehicleDamages(vehicle)
    TriggerServerEvent('gangs:spawnlog2', plate, nil, not Entity(vehicle).state.choped, GetVehicleEngineHealth(vehicle))
    ESX.Game.DeleteVehicle(vehicle)
    TriggerServerEvent('garage:setVehicleState', plate, true, json.encode(damages))
    TriggerServerEvent('garage:setvehiclelocation', plate, currentZone.index)
    ESX.TriggerServerEvent('parking:setVehicleMetaData2', plate, metadata)
    TriggerServerEvent('removecarkey', plate)
end

function GetVehicleGroundCorners(vehicle)
    if not DoesEntityExist(vehicle) then return {} end

    local minDim, maxDim = GetModelDimensions(GetEntityModel(vehicle))

    local offsets = {
        vector3(minDim.x, minDim.y, 0.0),
        vector3(maxDim.x, minDim.y, 0.0),
        vector3(maxDim.x, maxDim.y, 0.0),
        vector3(minDim.x, maxDim.y, 0.0),
    }

    local corners = {}

    for _, offset in ipairs(offsets) do
        local world = GetOffsetFromEntityInWorldCoords(vehicle, offset.x, offset.y, offset.z)

        local found, groundZ = GetGroundZFor_3dCoord(world.x, world.y, world.z, 0)
        if found then
            world = vector3(world.x, world.y, groundZ)
        end

        table.insert(corners, world)
    end

    return corners
end

local blockedModels = {
    [`stockade`] = true,
}

function parkVehicleMeter(key, vehicle, dontShowFixVehicle)
    if exports['sunset_utils']:canAccessToVehicle(vehicle) and DoesEntityExist(vehicle) and NetworkGetEntityIsNetworked(vehicle) then
        ESX.TriggerServerCallback('ParkMeter:CheckUsed',function(used)
            if used then
                if not dontShowFixVehicle then
                    ESX.Alert('Error','Shoma yek mashin dar in garage gozashtid!',5000,'error')
                end
            else
                if not dontShowFixVehicle then
                    payFixVehicle(vehicle)
                end
                local metaData = ESX.Game.getVehicleMetaData(vehicle)
                local model = GetEntityModel(vehicle)
                if blockedModels[model] then
                    ESX.notification('error', 'شما نمی‌توانید این وسیله نقلیه را در پارک متر پارک کنید!')
                    return
                end
                local plate = ESX.GetPlate(vehicle)
                local damages = getVehicleDamages(vehicle)
                local prop = ESX.Game.GetVehicleProperties(vehicle)
                local doesHaveKey = ESX.DoesHaveItem2('key_'..ESX.Math.Trim(plate:upper()))
                local job = exports['esx_vehiclecontrol']:getVehicleJob(vehicle)
                local coords = GetEntityCoords(vehicle)
                local heading = GetEntityHeading(vehicle)
                ESX.Game.DeleteVehicle(vehicle)
                ESX.Game.SpawnLocalVehicle(prop.model, Config.ParkMeter[key].coords, Config.ParkMeter[key].coords.w, function(vehicle)
                    while not DoesEntityExist(vehicle) do Wait(0) end
                    ESX.Game.SetVehicleProperties(vehicle, prop)
                    SetEntityAlpha(vehicle, 204, true)
                    FreezeEntityPosition(vehicle, true)
                    parkMeterPreviewVehicles[plate] = vehicle
                    -- exports['ox_target']:addLocalEntity2({vehicle})
                    parkMeterPreviewThread()
                    CreateThread(function()
                        local id = exports['ox_target']:addPolyZone({
                            points = GetVehicleGroundCorners(vehicle),
                            thickness = 8,
                            name = vehicle,
                            options = {
                                {
                                    label = "🚙باز کردن صندوق عقب",
                                    onSelect = function(entity)
                                        exports['sun-inventory-hud']:openTrunk(vehicle)
                                    end,
                                },{
                                    label = '👜بار زدن شیء',
                                    canInteract = function(data)
                                        return exports['sunset_utils']:houseRobGetCurrentCarry()
                                    end,
                                    onSelect = function(data)
                                        exports['sunset_utils']:putCarriedHouseObject(vehicle)
                                    end,
                                }
                            }
                        })
                        while DoesEntityExist(vehicle) do
                            Wait(1000)
                        end
                        exports['ox_target']:removeZone(id)
                    end)
                end)
                TriggerServerEvent('garage:setVehicleState', plate, false,json.encode(damages))
                ESX.TriggerServerEvent('parking:setVehicleMetaData2', plate, metaData)
                ESX.TriggerServerEvent('ParkMeter:Set',key,plate,prop,json.encode(damages),metaData,doesHaveKey,job)
                ESX.Alert('Success','Mashin ba movafaghiat park shod',5000,'success')
                if Config.ParkMeter[key].zoneId then
                    ESX.changePointColor(Config.ParkMeter[key].zoneId, {R = 255,G = 165,B = 0,A = 255})
                end
            end
        end, key)
    end
end

function parkMeterPreviewThread()
    if not bParkMeterPreviewThread then
        bParkMeterPreviewThread = true
        CreateThread(function()
            while ESX.tableLength(parkMeterPreviewVehicles) > 0 do
                Wait(10)
                for k, v in pairs(parkMeterPreviewVehicles) do
                    -- SetVehicleDoorsLocked(v, 2)
                    -- local heading = GetEntityHeading(v)
                    -- SetEntityHeading(v, heading + 0.2)
                    SetEntityCollision(v, false, true)
                    -- for k2, v2 in pairs(ESX.Game.GetVehicles()) do
                    --     if not ESX.TableContainsValue(parkMeterPreviewVehicles, v2) then
                    --         SetEntityNoCollisionEntity(v2, v, true)
                    --         SetEntityNoCollisionEntity(v, v2, true)
                    --     end
                    -- end
                    -- SetEntityNoCollisionEntity(v, PlayerPedId(), true)
                    -- SetEntityNoCollisionEntity(PlayerPedId(), v, true)
                end
            end
            bParkMeterPreviewThread = false
        end)
    end
end

function openSpawnMenu(type, zoneData, ownedVehicles, _spawnCB)
    if isPlayerBusy() then return end
    while not loaded do Wait(100) end
    local vehicleList = {}
    local inGarage, ownedVehicleCount, ownedVehicleCountUniq, uniqList = 0, 0, 0, {}
    local p = promise.new()
    currentMenuType = type
    spawnCB = _spawnCB
    local ts = exports['sunset_utils']:GetServerOSTime()
    if type == 'self' then
        ESX.TriggerServerCallback('garage:getOwnedVehicles', function(ownedVehicles, permissionList)
            if #ownedVehicles == 0 then
                ESX.ShowNotification("~r~Shoma mashini nadarid!")
            else
                ownedVehicleCount = #ownedVehicles
                for k, v in pairs(ownedVehicles) do
                    local label = ESX.GetVehicleLabelFromHash(v.vehicle.model)
                    local expired, expireLable = false, ''
                    if v.expire and v.expire > 0 then
                        if v.expire > ts then
                            expireLable = ESX.displayTime(v.expire - ts)
                        else
                            expired = true
                            expireLable = 'Expired'
                            v.expired = true
                        end
                    end
                    v.VehModel = ('%s - %s'):format(label, v.vehicle.plate)
                    v.VehText = ESX.GetVehicleLabelFromHash(v.vehicle.model) .. '('.. (v.location?.location == 0 and 'House' or v.location?.location or '') ..') ' .. expireLable
                    v.image = vehiclesDB[v.vehicle.model]?.imgurl and json.decode(vehiclesDB[v.vehicle.model]?.imgurl)[1]
                    v.image2 = vehiclesDB[v.vehicle.model]?.imgurl180px
                    if not uniqList[v.vehicle.model] then
                        uniqList[v.vehicle.model] = true
                        ownedVehicleCountUniq += 1
                    end
                    v.state = 0
                    if not v.location or v.location.location == zoneData.index and not (v.gang2 and v.gang2 ~= '') then
                        v.state = 1
                        inGarage += 1
                    end
                    if v.gang2 and v.gang2 ~= '' and v.type == 'car' then
                        v.state = 0
                        v.VehText = ESX.GetVehicleLabelFromHash(v.vehicle.model) .. '(Gang)'
                    end
                    if v.owner == ESX.PlayerData.identifier or permissionList[v.vehicle.plate] then
                        table.insert(vehicleList, v)
                    end
                end
            end
            p:resolve()
        end, zoneData.type)
    else
        otherZoneData = zoneData
        if #ownedVehicles == 0 then
            ESX.ShowNotification("~r~Shoma mashini nadarid!")
        else
            ownedVehicleCount = #ownedVehicles
            for k, v in pairs(ownedVehicles) do
                local label = ESX.GetVehicleLabelFromHash(v.vehicle.model)
                local expired, expireLable = false, ''
                if v.expire and v.expire > 0 then
                    if v.expire > ts then
                        expireLable = ESX.displayTime(v.expire - ts)
                    else
                        expired = true
                        expireLable = 'Expired'
                        v.expired = true
                    end
                end
                v.VehModel = ('%s - %s'):format(label, v.vehicle.plate) .. ' ' .. expireLable
                v.VehText = ESX.GetVehicleLabelFromHash(v.vehicle.model) .. '('.. (v.location?.location == 0 and 'House' or v.location?.location or '') ..')'
                v.image = vehiclesDB[v.vehicle.model]?.imgurl and json.decode(vehiclesDB[v.vehicle.model]?.imgurl)[1]
                v.image2 = vehiclesDB[v.vehicle.model]?.imgurl180px
                if not uniqList[v.vehicle.model] then
                    uniqList[v.vehicle.model] = true
                    ownedVehicleCountUniq += 1
                end
                -- v.state = 0
                -- if not v.location then
                    v.state = 1
                    inGarage += 1
                -- end
                table.insert(vehicleList, v)
            end
        end
        p:resolve()
    end
    Citizen.Await(p)
    SetNuiFocus(true, true)
    inMenu = true
    SendNuiMessage(json.encode({action = 'setOpen', data = {setVeh = vehicleList,setName = ESX.GetPlayerData().name2, inGarage = inGarage, Price = 0, allVehicleCount = vehicleDBCount, ownedVehicleCount = ownedVehicleCount, ownedVehicleCountUniq = ownedVehicleCountUniq}}))
end
exports('openSpawnMenu', openSpawnMenu)

RegisterNUICallback('Close', function()
    SetNuiFocus(false, false)
    inMenu = nil
    if previewVehicle then
        DeleteEntity(previewVehicle)
    end
    stopCamera()
end)

function getAvailableSpawnPoint(type, index)
    if index then
        local locations = Config.zones[type].coords[index].spawnPoints
        for k, v in pairs(locations) do
            if ESX.Game.IsSpawnPointClear(v.coords, 2.0) then
                return v
            end
        end
    else
        for k, v in pairs(type) do
            if ESX.Game.IsSpawnPointClear(v, 2.0) then
                return {coords = v}
            end
        end
    end
end

RegisterNUICallback('VehicleInfo', function(data, cb)
    local spawnPoint
    if currentMenuType == 'self' then
        spawnPoint = getAvailableSpawnPoint(currentZone.k, currentZone.index)
    elseif currentMenuType == 'other' then
        spawnPoint = getAvailableSpawnPoint(otherZoneData)
    end
    if spawnPoint then
        ESX.Game.SpawnLocalVehicle(data.data.vehicle.model, spawnPoint.coords.xyz, spawnPoint.coords.w, function(vehicle)
            previewVehicle = vehicle
            SetVehicleEngineOn(vehicle, true, true, false)
            if data.data.damage then
                ESX.repeatCode(function()
                    setVehicleDamages(vehicle, data.data.damage)
                end, 2, 1000)
            end
            FreezeEntityPosition(vehicle, true)
            ESX.Game.SetVehicleProperties(vehicle, data.data.vehicle)
            cb({
                Fuel = ESX.Math.Round(data.data.metaData and data.data.metaData.fuel or 100),
                Speed = GetVehicleEstimatedMaxSpeed(vehicle) * 3.6,
                Traction = GetVehicleMaxTraction(vehicle),
                Acceleration = GetVehicleAcceleration(vehicle)
            })
            ESX.TriggerServerCallback('chopshop:server:isChopped',function(choped)
                Citizen.CreateThread(function()
                    while DoesEntityExist(vehicle) and inMenu do
                        Wait(0)
                        local vehpos = GetOffsetFromEntityInWorldCoords(vehicle, 0.0, 0.0, 2.0)
                        ESX.Game.Utils.DrawText3D(vector3(vehpos.x, vehpos.y, vehpos.z - 0.5),'Benzin : '.. ESX.Math.Round(data.data.metaData and data.data.metaData.fuel or 100).. '%',1)
                        ESX.Game.Utils.DrawText3D(vector3(vehpos.x, vehpos.y, vehpos.z - 0.75),'Engine : '.. tostring(choped == true and 'Kheir' or 'Bale'),1)
                        ESX.Game.Utils.DrawText3D(vector3(vehpos.x, vehpos.y, vehpos.z - 1),'Salamate motor : ' .. ESX.Math.Round(GetVehicleEngineHealth(vehicle) / 10) .. '%',1)
                    end
                    stopCamera()
                    DeleteEntity(vehicle)
                end)
            end, data.data.vehicle.plate)
            if not camera then
                createCamera()
            end
            SetCamActive(camera, true)
            local camCoords = GetOffsetFromEntityInWorldCoords(vehicle, 2.0, 5.0, 2.0)
            local pointCoords = GetOffsetFromEntityInWorldCoords(vehicle, 2.0, 0.0, 0.0)
            PointCamAtCoord(camera, pointCoords.x, pointCoords.y, pointCoords.z)
            SetCamCoord(camera, camCoords.x, camCoords.y, camCoords.z)
        end)
    end
end)

function createCamera()
    camera = CreateCam("DEFAULT_SCRIPTED_CAMERA", false)
    SetCamActive(camera, true)
    RenderScriptCams(true, true, 1000, true, false)
end

function stopCamera()
	if camera then
		ClearFocus()
		RenderScriptCams(false, false, 0, true, false)
		DestroyCam(camera, false)
		camera = nil
	end
end

function setVehicleDamages(car, damages)
	damages = json.decode(damages)
    
	for i = 0, GetVehicleNumberOfWheels(car) do
        if damages['burst_tires'] then
            if damages['burst_tires'][i] then
                SetVehicleTyreBurst(car, damages['burst_tires'][i], true, 1000.0)
            end
        end
	end

	for i = 0, 7 do
        if damages['damaged_windows'] then
            if damages['damaged_windows'][i] then
                SmashVehicleWindow(car, damages['damaged_windows'][i])
            end
        end
	end

	for i = 0, GetNumberOfVehicleDoors(car) do 
        if damages['broken_doors'] then
			if damages['broken_doors'][i] then
                SetVehicleDoorBroken(car, damages['broken_doors'][i], true)
            end
        end
	end

    if damages['body_health'] then
        SetVehicleBodyHealth(car, damages['body_health'])
    end
    if damages['engine_health'] then
        ESX.SetVehicleEngineHealth(car, damages['engine_health'])
    end
end
function getVehicleDamages(vehicle)
	local damages 	   = {['damaged_windows'] = {}, ['burst_tires'] = {}, ['broken_doors'] = {}, ['body_health'] = GetVehicleBodyHealth(vehicle), ['engine_health'] = GetVehicleEngineHealth(vehicle)}

	for i = 0, GetVehicleNumberOfWheels(vehicle) do
		if IsVehicleTyreBurst(vehicle, i, false) then table.insert(damages['burst_tires'], i) end
	end
	for i = 0, 7 do
		if not IsVehicleWindowIntact(vehicle, i) then table.insert(damages['damaged_windows'], i) end
	end
	for i = 0, GetNumberOfVehicleDoors(vehicle) do
		if IsVehicleDoorDamaged(vehicle, i) then table.insert(damages['broken_doors'], i) end
	end
	return damages
end
exports('getVehicleDamages', getVehicleDamages)
RegisterNUICallback('BackPage', function()
    DeleteEntity(previewVehicle)
end)

RegisterNUICallback("rotateright", function(data)
    SetEntityHeading(previewVehicle, GetEntityHeading(previewVehicle) - 2)
end)

RegisterNUICallback("rotateleft", function()
    SetEntityHeading(previewVehicle, GetEntityHeading(previewVehicle) + 2)
end)

RegisterNUICallback('SpawnVehicle', function(data)
    closeMenu()
    if previewVehicle then
        DeleteEntity(previewVehicle)
    end
    stopCamera()
    local data = data.Table
    local spawnPoint
    if currentMenuType == 'self' then
        spawnPoint = getAvailableSpawnPoint(currentZone.k, currentZone.index)
    elseif currentMenuType == 'other' then
        spawnPoint = getAvailableSpawnPoint(otherZoneData)
    end
    if data.banned then
        return ESX.chatMessage(('In mashin be dalile %s toghif shode ast!'):format(data.banned), 'plarms')
    end
    if data.expired then
        return ESX.chatMessage('In mashin expire shode', 'plarms')
    end
    if data.metaData and data.metaData.prime then
        if not ESX.isPrime() then
            return ESX.chatMessage('Baraye estefade az in mashin bayad ^3prime^0 bashid', 'plarms')
        end
    end
    if data.stored then
        if spawnPoint then
---@diagnostic disable-next-line: redundant-parameter
            Wait(math.random(100, 1500))
            local plate = data.vehicle.plate
            ESX.TriggerServerCallback('gangprop:carAvalible', function(avalibele)
                if avalibele then
                    if isPlayerBusy() then ESX.ShowNotification('~r~Dar in halat nemitavanid mashin bekeshid!') return end
                    Wait(1000)
                    if isPlayerBusy() then ESX.ShowNotification('~r~Dar in halat nemitavanid mashin bekeshid!') return end
                    TriggerServerEvent('garage:setVehicleState', data.vehicle.plate, false)
                    ESX.Game.SpawnVehicle(data.vehicle.model, spawnPoint.coords.xyz, spawnPoint.coords.w, function(vehicle)
                        ESX.Game.SetVehicleProperties(vehicle, data.vehicle)
                        if data.damage then
                            setVehicleDamages(vehicle, data.damage)
                        end
                        if data.metaData then
                            ESX.Game.setVehicleMetaData(vehicle, data.metaData)
                        end
                        SetVehRadioStation(vehicle, "OFF")
                        -- TaskEnterVehicle(PlayerPedId(), vehicle, 10000, -1, 2.0, 1)
                        if #(GetEntityCoords(PlayerPedId()) - GetEntityCoords(vehicle)) > 120.0 then
                            ESX.Game.DeleteVehicle(vehicle)
                            TriggerServerEvent('garage:setVehicleState', data.vehicle.plate, true)
                            ESX.notification('warning', 'Fasele shoma az mashin ziad ast, lotfan nazdik bashid')
                            return
                        end
                        clearPlayerState()
                        TaskWarpPedIntoVehicle(PlayerPedId(), vehicle, -1)
                        while GetVehiclePedIsIn(PlayerPedId()) ~= vehicle do Wait(0) end
                        TriggerEvent('esx:createvehiclekey')

                        ESX.TriggerServerCallback('chopshop:server:isChopped',function(choped)
                            if choped then
                                ESX.TriggerServerCallback('chopshop:server:getEngineLevel',function(engine)
                                    if engine ~= 0 then
                                        ESX.ShowNotification('Motor mashin shoma sadame dide,shoma be yek Engine X'..engine..' niaz darid')
                                    else
                                        ESX.ShowNotification('Motor mashin shoma sadame dide')
                                    end
                                    ESX.TriggerServerEvent('setEntityState', NetworkGetNetworkIdFromEntity(vehicle), 'choped', true)
                                end, GetEntityModel(vehicle))
                            end
                            if currentMenuType == 'other' and spawnCB then
                                spawnCB(vehicle, not choped, GetVehicleEngineHealth(vehicle))
                            end
                        end, plate)
                        Wait(2000)
                        for k, v in pairs(ESX.Game.GetVehicles()) do
                            local target = GetVehicleNumberPlateText(v)
                            if string.upper(ESX.Math.Trim(target)) == string.upper(ESX.Math.Trim(plate)) and v ~= vehicle then
                                ESX.Game.DeleteVehicle(vehicle)
                            end
                        end
                    end)
                end
            end, plate)
        end
    else
        ESX.Alert('', 'In mashin dar impound ast', 7000, 'error')
    end
end)

function closeMenu()
    SendNuiMessage(json.encode({action = 'Close'}))
end

lib.onCache('vehicle', function(value)
    currentVehicle = value
    if currentVehicle then
        local ped = PlayerPedId()
        currentVehicleType = 'car'
        if IsPedInAnyBoat(ped) or ESX.submarines[GetEntityModel(currentVehicle)] then
            currentVehicleType = 'boat'
        elseif IsPedInAnyPlane(ped) then
            currentVehicleType = 'aircraft'
        elseif IsPedInAnyHeli(ped) then
            currentVehicleType = 'heli'
        end
    end
end)

AddStateBagChangeHandler('piadeShid', nil, function(bagName)
    local vehicle = GetEntityFromStateBagName(bagName)
    if vehicle == currentVehicle then
        TaskLeaveVehicle(PlayerPedId(), currentVehicle, 1)
    end
end)

AddEventHandler('exitVehicle', function(vehicle, isDriver)
    if isDriver then
        if currentZone and (currentZone.type == currentVehicleType or (currentVehicleType.type == 'heli' and currentVehicleType == 'aircraft')) then
            CreateThread(function()
                local active = true
                local timer = 20
                CreateThread(function()
                    while active do
                        Wait(1000)
                        timer -= 1
                        if timer <= 0 then
                            active = false
                            parkVehicle(vehicle)
                        end
                    end
                end)
                while DoesEntityExist(vehicle) and not GetIsVehicleEngineRunning(vehicle) and active do
                    ESX.Game.Utils.DrawText3D(GetEntityCoords(vehicle) + vec(0, 0, 1), timer, 3)
                    Wait(0)
                end
                active = false
            end)
        else
            if ESX.GetPlayerData().World == 0 then
                local nearMeter = nil
                local coords = GetEntityCoords(PlayerPedId())
                for k, v in pairs(Config.ParkMeter) do
                    if type(v) == 'table' and v.range then
                        if #(coords - v.coords.xyz) < v.range and (not nearMeter or nearMeter.distance > #(coords - v.coords.xyz)) then
                            nearMeter = {k = k, distance = #(coords - v.coords.xyz)}
                        end
                    end
                end
                if nearMeter then
                    ESX.TriggerServerCallback('ParkMeter:CheckUsed',function(used)
                        if not used then
                            CreateThread(function()
                                local active = true
                                local timer = 15
                                CreateThread(function()
                                    while active do
                                        Wait(1000)
                                        if #(GetEntityCoords(PlayerPedId()) - GetEntityCoords(vehicle)) > 5.0 then
                                            timer -= 1
                                            if timer <= 0 then
                                                active = false
                                                parkVehicleMeter(nearMeter.k, vehicle, true)
                                            end
                                        end
                                    end
                                end)
                                while DoesEntityExist(vehicle) and not GetIsVehicleEngineRunning(vehicle) and active do
                                    ESX.Game.Utils.DrawText3D(GetEntityCoords(vehicle) + vec(0, 0, 1), timer, 3)
                                    Wait(0)
                                end
                                active = false
                            end)
                        end
                    end, nearMeter.k)
                end
            end
        end
    end
end)

RegisterNuiCallback('backVehicle', function(data)
    local data = data.data
    if not data.gang or data.gang == '' then
        closeMenu()
        lib.closeAlertDialog()
        lib.hideMenu()
        local alert = lib.alertDialog({
            header = 'Enteghal Mashin',
            content = 'Aya mayel be esnteghal mashin in be in garage hastid?',
            centered = true,
            cancel = true
        })
        if alert == 'confirm' then
            data.vehicle = json.decode(data.vehicle)
            local options = {
                {label = '20K(5 Minutes)', args = {value = 5, plate = data.vehicle.plate}},
                {label = '10K(10 Minutes)', args = {value = 10, plate = data.vehicle.plate}},
                {label = '5K(15 Minutes)', args = {value = 20, plate = data.vehicle.plate}},
            }
            if exports['sun-jobs']:getVehicleInsuranceData(data.vehicle.plate) then
                table.insert(options, {label = '10K(0 Minutes)', args = {value = 100, plate = data.vehicle.plate}})
            end
            lib.setMenuOptions('garageBack', options)
            lib.showMenu('garageBack')
        end
    end
end)

function payFixVehicle(vehicle)
    local engineHealth = GetVehicleEngineHealth(vehicle)
    local p = promise.new()
    ESX.TriggerServerCallback('scoreboard:getjob', function(count)
        if count > (ESX.serverNum <= 2 and ESX.serverNum or 0) then
            p:resolve(true)
        else
            if engineHealth < 990 then
                local cost = math.floor((1000 - engineHealth)/1000*Config.CarPoundPrice*Config.DamageMult)
                local alert = lib.alertDialog({
                    header = 'Repair',
                    content = ('Mayel be repair mashin ba mablagh $%s hastid?'):format(cost),
                    centered = true,
                    cancel = true
                })
                if alert == 'confirm' then
                    ESX.TriggerServerCallback('garage:checkRepairCost', function(hasEnoughMoney)
                        if hasEnoughMoney then
                            TriggerServerEvent('garage:pay', cost)
                            ESX.SetVehicleFixed(vehicle)
                            Wait(500)
                        else
                            ESX.ShowNotification('Poul kafi nadarid')
                        end
                        p:resolve(true)
                    end, tonumber(cost))
                else
                    p:resolve(true)
                end
            else
                p:resolve(true)
            end
        end
    end, 'mechanic')
    return Citizen.Await(p)
end

local ParkMeterBlips = {}
local Spam = false
parkMeterPreviewVehicles = {}
bParkMeterPreviewThread = false
Citizen.CreateThread(function()
	while ESX == nil do Wait(1) end
	for k , v in pairs(Config.ParkMeter) do
		v.zoneId = ESX.RegisterPoint(v.coords.xyz,3,{
			Color = {R = 3,G = 119,B = 252,A = 255},
			DrawDistance = 10,
			Radius = 1.5,
			Type = 9,
			world = 0,
		},{
			Notification = nil,
			DrawText = 'Dokme ~INPUT_CONTEXT~ jahat estefade az park',
			DrawTextRadius = 4,
			DrawTextCoords = v.coords.xyz,
			Key = 'e',
			CB = function(zoneId)
				key = k
				if ESX.GetPlayerData().World ~= 0 or ESX.isDead() then return end
				local vehicle = GetVehiclePedIsIn(PlayerPedId())
                if GetEntitySpeed(vehicle) * 3.6 > 10 then
                    return ESX.notification('warning', 'برای پارک ابتدا ماشین را متوقف کنید')
                end
				if vehicle ~= 0 then
					local seat = GetPedInVehicleSeat(vehicle,-1)
					if seat == PlayerPedId() then
						if not ESX.checkCooldown('parkMeter', 6000) then return ESX.Alert('Error','Spam nakonid', 5000,'error') end
                        if exports['sunset_utils']:canAccessToVehicle(vehicle) or exports['esx_vehiclecontrol']:HaveAccess(vehicle) then
                            if ESX.progressCircle(3000, false, true) then
                                parkVehicleMeter(key, vehicle)
                            end
                        else
                            ESX.Alert('Error','Shoma nemitavanid in mashin ra park konid!',5000,'error')
                        end
					else
						ESX.Alert('Error','Shoma ranande mashin nistid!',5000,'error')
					end
				else
					if not ESX.checkCooldown('parkMeter', 6000) then return ESX.Alert('Error','Spam nakonid', 5000,'error') end
					if isPlayerBusy() then return end
					ESX.TriggerServerCallback('ParkMeter:CheckUsed',function(used,identifier)
						if used then
                            if ESX.progressCircle(math.random(1000, 4000), false, true) then
                                if not ESX.checkCooldown('parkMeter2', 6000) then return ESX.Alert('Error','Spam nakonid', 5000,'error') end
                                local spawnCoord = nil
                                if v.outputCoords and #v.outputCoords > 0 then
                                    local shuffled = {}
                                    for _, c in ipairs(v.outputCoords) do
                                        shuffled[#shuffled + 1] = c
                                    end
                                    for i = #shuffled, 2, -1 do
                                        local j = math.random(1, i)
                                        shuffled[i], shuffled[j] = shuffled[j], shuffled[i]
                                    end
                                    for _, c in ipairs(shuffled) do
                                        if ESX.Game.IsSpawnPointClear(c.xyz, 2) then
                                            spawnCoord = c
                                            break
                                        end
                                    end
                                else
                                    if ESX.Game.IsSpawnPointClear(v.coords.xyz, 2) then
                                        spawnCoord = v.coords
                                    end
                                end
                                if spawnCoord then
                                    if isPlayerBusy() then ESX.ShowNotification('~r~Dar in halat nemitavanid mashin bekeshid!') return end
                                    Wait(1000)
                                    if isPlayerBusy() then ESX.ShowNotification('~r~Dar in halat nemitavanid mashin bekeshid!') return end
                                    ESX.TriggerServerEvent('ParkMeter:Set',key,used.plate,nil)
                                    if zoneId then
                                        ESX.changePointColor(zoneId, {R = 3,G = 119,B = 252,A = 255})
                                    end
                                    if parkMeterPreviewVehicles[used.prop.plate] then
                                        ESX.Game.DeleteVehicle(parkMeterPreviewVehicles[used.prop.plate])
                                        parkMeterPreviewVehicles[used.prop.plate] = nil
                                    end
                                    Wait(300)
                                    ESX.Game.SpawnVehicle(used.prop.model, spawnCoord.xyz, spawnCoord.w, function(callback_vehicle)
                                        ESX.Game.SetVehicleProperties(callback_vehicle, used.prop)
                                        SetVehRadioStation(callback_vehicle, "OFF")
                                        if #(GetEntityCoords(PlayerPedId()) - GetEntityCoords(callback_vehicle)) > 120.0 then
                                            ESX.Game.DeleteVehicle(callback_vehicle)
                                            ESX.notification('warning', 'Fasele shoma az mashin ziad ast, lotfan nazdik bashid')
                                            return
                                        end
                                        clearPlayerState()
                                        TaskWarpPedIntoVehicle(GetPlayerPed(-1), callback_vehicle, -1)
                                        --if identifier then
                                        while GetVehiclePedIsIn(PlayerPedId()) ~= callback_vehicle do Wait(0) end
                                        if used.doesHaveKey then
                                            TriggerEvent('esx:createvehiclekey')
                                        else
                                            exports["esx_vehiclecontrol"]:SetDecor(callback_vehicle,used.job,true)
                                        end
                                        --end
                                        setVehicleDamages(callback_vehicle,used.damages)
                                        ESX.Game.setVehicleMetaData(callback_vehicle,used.metaData)
                                        local plate = used.prop.plate
                                        ESX.TriggerServerCallback('chopshop:server:isChopped',function(choped)
                                            if choped then
                                                ESX.TriggerServerCallback('chopshop:server:getEngineLevel',function(engine)
                                                    if engine ~= 0 then
                                                        ESX.ShowNotification('Motor mashin shoma sadame dide,shoma be yek Engine X'..engine..' niaz darid')
                                                    else
                                                        ESX.ShowNotification('Motor mashin shoma sadame dide')
                                                    end
                                                    ESX.TriggerServerEvent('setEntityState', NetworkGetNetworkIdFromEntity(callback_vehicle), 'choped', true)
                                                end,GetEntityModel(callback_vehicle))
                                            end
                                        end,plate)
                                    end)
                                else
                                    ESX.Alert('Error','In makan jahat spawn mashin por ast!',5000,'error')
                                end
                            end
						else
							ESX.Alert('Error','Shoma mashini dar in garage nazashtid!',5000,'error')
						end
					end,key)
					--ESX.Alert('Error','Shoma savar mashin nistid!',5000,'error')
				end
			end,
		},{
			In = nil,
			Out = ESX.UI.Menu.CloseAll
		})
	end
	--while true do
		local coords = GetEntityCoords(PlayerPedId())
		for k, v in pairs(Config.ParkMeter) do
			--local distance = ESX.GetDistance(coords,v.xyz)
			--if distance <= 300 then
				--if not ParkMeterBlips[k] then
					local blip = AddBlipForCoord(v.coords.x, v.coords.y, v.coords.z)
					SetBlipSprite(blip, 267)
					SetBlipDisplay(blip, 5)
					SetBlipScale(blip, 0.3)
					SetBlipColour(blip, 74)
					SetBlipAsShortRange(blip, true)
					BeginTextCommandSetBlipName("STRING")
					AddTextComponentString('Park meter')
					EndTextCommandSetBlipName(blip)
					ParkMeterBlips[k] = blip
				--end
			--elseif ParkMeterBlips[k] then
			--	RemoveBlip(ParkMeterBlips[k])
			--	ParkMeterBlips[k] = nil
			--end
			Citizen.Wait(10)
		end
	--	Citizen.Wait(5000)
	--end
end)

RegisterNetEvent('garage:DeleteAllVehicle', function()
	local vehicles = ESX.Game.GetVehicles()
	for _,entity in ipairs(vehicles) do

		if IsAnyPedInVehicle(entity) then
			return
		end

		NetworkRequestControlOfEntity(entity)
		
		local timeout = 2000
		while timeout > 0 and not NetworkHasControlOfEntity(entity) do
			Wait(100)
			timeout = timeout - 100
		end

		SetEntityAsMissionEntity(entity, true, true)
		
		local timeout = 2000
		while timeout > 0 and not IsEntityAMissionEntity(entity) do
			Wait(100)
			timeout = timeout - 100
		end

		Citizen.InvokeNative( 0xEA386986E786A54F, Citizen.PointerValueIntInitialized( entity ) )
		
		if (DoesEntityExist(entity)) then 
			DeleteEntity(entity)
		end
		
	end

end)

RegisterNetEvent('garage:DeleteAllVehiclerange', function(range)
    local vehicles = ESX.Game.GetVehicles()
    for _,entity in ipairs(vehicles) do
        local coords1 = GetEntityCoords(GetPlayerPed(-1))
        local coords2 = GetEntityCoords(entity)
        if GetDistanceBetweenCoords(coords1.x,coords1.y,coords1.z,coords2.x,coords2.y,coords2.z) < tonumber(range) then
            if IsAnyPedInVehicle(entity) then
                return
            end
            NetworkRequestControlOfEntity(entity)
            local timeout = 2000
            while timeout > 0 and not NetworkHasControlOfEntity(entity) do
                Wait(100)
                timeout = timeout - 100
            end
            SetEntityAsMissionEntity(entity, true, true)
            local timeout = 2000
            while timeout > 0 and not IsEntityAMissionEntity(entity) do
                Wait(100)
                timeout = timeout - 100
            end
            Citizen.InvokeNative( 0xEA386986E786A54F, Citizen.PointerValueIntInitialized( entity ) )
            if (DoesEntityExist(entity)) then
                ESX.Game.DeleteVehicle(entity)
            end
        end
    end
end)
function IsAnyPedInVehicle(veh)
	return (GetVehicleNumberOfPassengers(veh)+(IsVehicleSeatFree(veh,-1) and 0 or 1))>0
end

AddEventHandler('garage:GetVehicleDamages', function(cb, vehicle)
	cb(getVehicleDamages(vehicle))
end)

RegisterNetEvent('garage:FindVehicle', function(plate)
	local vehicles = ESX.Game.GetVehicles()
	local entity
	for _,v in ipairs(vehicles) do
		if plate == ESX.Math.Trim(GetVehicleNumberPlateText(v)) then
			entity = v
		end
	end
	if entity then
		carModel = GetEntityModel(entity)
		carName = GetDisplayNameFromVehicleModel(carModel)
		NetworkRequestControlOfEntity(entity)
		local coords = GetEntityCoords(entity)
		local timeout = 2000
		while timeout > 0 and not NetworkHasControlOfEntity(entity) do
			Wait(100)
			timeout = timeout - 100
		end

		SetEntityAsMissionEntity(entity, true, true)
		
		local timeout = 2000
		while timeout > 0 and not IsEntityAMissionEntity(entity) do
			Wait(100)
			timeout = timeout - 100
		end

		if IsVehicleSeatFree(entity, -1) then
			if DoesEntityExist(entity) then
				--TriggerEvent('chat:addMessage', {
				--	color = { 255, 0, 0},
				--	multiline = true,
				--	args = {"[SYSTEM]", "^2 " .. carName .. "^0 ba movafaghiat hazf shod!"}
				--})
			end
			
			Citizen.InvokeNative( 0xEA386986E786A54F, Citizen.PointerValueIntInitialized( entity ) )
			local lastdistance = 100000
			local location = 0
			if (DoesEntityExist(entity)) then 
				DeleteEntity(entity)
			end
			for k , v in pairs(Config.CarGarages) do
				if v.GaragePoint then
					local distance = GetDistanceBetweenCoords(v.GaragePoint.x,v.GaragePoint.y,v.GaragePoint.z,coords.x,coords.y,coords.z)
					if distance < lastdistance then
						lastdistance = distance
						location = k
					end
				end
			end
			TriggerServerEvent('garage:ResponseFindVehicle', true, plate,location)
		else
			TriggerServerEvent('garage:ResponseFindVehicle', false, plate)
		end
	end
end)

function openImpoundMenu()
    ESX.TriggerServerCallback('esx_billing:getBills', function(bills)
        if #bills > 0 then
            ESX.ShowNotification('Shoma baraye estefade az imound bayad tamam ghabz haye khod ra pardakht konid')
        else
            lib.registerMenu({
                id = 'garageImpound',
                title = 'Impound',
                options = {
                    {label = ('Mashin($%s)'):format(Config.CarPoundPrice), args = 'car'},
                    {label = ('Helicopter($%s)'):format(Config.AircraftPoundPrice), args = 'heli'},
                    {label = ('Havapeyma($%s)'):format(Config.AircraftPoundPrice), args = 'aircraft'},
                    {label = ('Ghayegh($%s)'):format(Config.BoatPoundPrice), args = 'boat'},
                }
            }, function(selected, scrollIndex, args)
                ESX.TriggerServerCallback('garage:getOutVehicles', function(ownedCars)
                    local options = {}
                    if #ownedCars > 0 then
                        for k, v in pairs(ownedCars) do
                            table.insert(options, {label = ('%s - %s(Fine $%s)'):format(ESX.GetVehicleLabelFromHash(v.model), v.plate, ESX.Math.GroupDigits(v.fine)), args = {type = args, plate = v.plate, fine = v.fine}})
                        end
                        lib.setMenuOptions('garageImpound2', options)
                        lib.showMenu('garageImpound2')
                    else
                        ESX.chatMessage('Vasile naghliee dar impound nadarid!', 'plarms')
                    end
                end, args)
            end)
            lib.showMenu('garageImpound')
        end
    end)
end

exports('getVehicleDB', function()
    return vehiclesDB
end)

exports('getSpecificVehicle', function(model)
    for k, v in pairs(vehiclesDB) do
        if k == model then
            return v
        end
    end
end)

RegisterNetEvent('garage:deletePreviewVehicle', function(plate)
    if parkMeterPreviewVehicles[plate] then
        ESX.Game.DeleteVehicle(parkMeterPreviewVehicles[plate])
        parkMeterPreviewVehicles[plate] = nil
    end
end)

RegisterCommand('dashboard', function()
    local ped = PlayerPedId()
    local vehicle = GetVehiclePedIsIn(ped, false)
    if vehicle == 0 or GetPedInVehicleSeat(vehicle, -1) ~= ped then
        ESX.notification('error', 'سوار هیچ ماشینی نیستید')
        return
    end
    local plate = ESX.GetPlate(vehicle)
    ESX.TriggerServerCallback('garage:getOwnedVehiclesJustSelf', function(vehicles)
        local found = false
        for _, v in pairs(vehicles) do
            if v.plate:upper() == plate:upper() then
                found = true
                break
            end
        end
        if not found then
            ESX.notification('error', 'شما صاحب این ماشین نیستید')
            return
        end
        ESX.TriggerServerCallback('parking:getVehicleMetaData', function(meta)
            meta = meta or {}
            local newState = not meta.dashboardLock
            ESX.TriggerServerEvent('parking:setVehicleMetaData2', plate, {dashboardLock = newState})
            if newState then
                ESX.notification('success', 'داشبورد قفل شد')
            else
                ESX.notification('success', 'داشبورد باز شد')
            end
        end, plate)
    end, 'car')
end, false)