-- Pub by FleeX Team , https://discord.gg/87rGBxgCsa

ESX                           = {}
ESX.PlayerData                = {}
ESX.PlayerLoaded              = false
ESX.CurrentRequestId          = 0
ESX.ServerCallbacks           = {}
-- ESX.TimeoutCallbacks          = {}

ESX.UI                        = {}
ESX.UI.HUD                    = {}
ESX.UI.HUD.RegisteredElements = {}
ESX.UI.Menu                   = {}
ESX.UI.Menu.RegisteredTypes   = {}
ESX.UI.Menu.Opened            = {}

ESX.Game                      = {}
ESX.Game.Utils                = {}

ESX.Scaleform                 = {}
ESX.Scaleform.Utils           = {}

ESX.Streaming                 = {}
ESX.CheckPoints = {}

ESX.TimeoutCount = -1
ESX.CancelledTimeouts = {}
ESX.Timeouts = {}
ESX.timeOutAddTime = {}
ESX.ClientCallbacks = {}

ESX.resourceBlips = {}
ESX.serverNum = GetConvarInt('serverNum', 1)
ESX.items, ESX.failedItems = {}, {}
ESX.itemLoaded = false
ESX.SetTimeout = function(msec, cb)
    local id = ESX.TimeoutCount + 1
	local validId = math.random(1, 1000000000)
	ESX.Timeouts[id] = {
		cb = cb,
		validId = validId
	}
    Citizen.SetTimeout(msec, function()
        if ESX.CancelledTimeouts[id] or ESX.Timeouts[id].validId ~= validId then
            ESX.CancelledTimeouts[id] = nil
        else
			if ESX.timeOutAddTime[id] then
				Citizen.SetTimeout(ESX.timeOutAddTime[id], function()
					if ESX.CancelledTimeouts[id] or ESX.Timeouts[id].validId ~= validId then
						ESX.CancelledTimeouts[id] = nil
					else
						cb()
						ESX.ClearTimeoutFromMemory(id)
					end
				end)
			else
				cb()
				ESX.ClearTimeoutFromMemory(id)
			end
        end
    end)
    ESX.TimeoutCount = id
    return id
end

ESX.ClearTimeout = function(id)
	ESX.CancelledTimeouts[id] = true
end

function ESX.updateTimeOut(id, time)
	ESX.timeOutAddTime[id] = time
end

function ESX.ClearTimeoutFromMemory(id)
	ESX.Timeouts[id] = nil
end

function ESX.SetTimeoutTime(id, newTime)
	if ESX.Timeouts[id] then
		local validId = math.random(1, 1000000000)
		ESX.Timeouts[id].validId = validId
		Citizen.SetTimeout(newTime, function()
			if ESX.CancelledTimeouts[id] or ESX.Timeouts[id].validId ~= validId then
				ESX.CancelledTimeouts[id] = nil
			else
				ESX.Timeouts[id].cb()
				ESX.ClearTimeoutFromMemory(id)
			end
		end)
	end
end


ESX.showHud = true
-- ESX.SetTimeout = function(msec, cb)
-- 	table.insert(ESX.TimeoutCallbacks, {
-- 		time = GetGameTimer() + msec,
-- 		cb   = cb
-- 	})
-- 	return #ESX.TimeoutCallbacks
-- end

-- ESX.ClearTimeout = function(i)
-- 	ESX.TimeoutCallbacks[i] = nil
-- end

ESX.IsPlayerLoaded = function()
	return ESX.PlayerLoaded
end

ESX.GetPlayerData = function()
	return ESX.PlayerData
end

ESX.SetPlayerData = function(key, val)
	ESX.PlayerData[key] = val
end

ESX.ShowNotification = function(msg)
	SetNotificationTextEntry('STRING')
	AddTextComponentSubstringWebsite(msg)
	DrawNotification(false, true)
end

ESX.ShowMissionText = function(tx)
    ClearPrints()
    SetTextEntry_2("STRING")
    AddTextComponentString(tx)
    DrawSubtitleTimed(8000, 1)
end

ESX.ShowAdvancedNotification = function(title, subject, msg, icon, iconType)
	SetNotificationTextEntry('STRING')
	AddTextComponentSubstringWebsite(msg)
	SetNotificationMessage(icon, icon, false, iconType, title, subject)
	DrawNotification(false, false)
end

ESX.ShowHelpNotification = function(msg)
	if not IsHelpMessageOnScreen() then
		BeginTextCommandDisplayHelp('STRING')
		AddTextComponentSubstringWebsite(msg)
		EndTextCommandDisplayHelp(0, false, true, -1)
	end
end

ESX.TriggerServerCallback = function(name, cb, ...)
	ESX.ServerCallbacks[ESX.CurrentRequestId] = cb

	TriggerServerEvent('triggerServerCB:'.. name, ESX.CurrentRequestId, ...)

	if ESX.CurrentRequestId < 65535 then
		ESX.CurrentRequestId = ESX.CurrentRequestId + 1
	else
		ESX.CurrentRequestId = 0
	end
end

ESX.UI.HUD.SetDisplay = function(opacity)
	SendNUIMessage({
		action  = 'setHUDDisplay',
		opacity = opacity
	})
end

ESX.UI.HUD.RegisterElement = function(name, index, priority, html, data)
	local found = false

	for i=1, #ESX.UI.HUD.RegisteredElements, 1 do
		if ESX.UI.HUD.RegisteredElements[i] == name then
			found = true
			break
		end
	end

	if found then
		return
	end

	table.insert(ESX.UI.HUD.RegisteredElements, name)

	SendNUIMessage({
		action    = 'insertHUDElement',
		name      = name,
		index     = index,
		priority  = priority,
		html      = html,
		data      = data
	})

	ESX.UI.HUD.UpdateElement(name, data)
end

ESX.UI.HUD.RemoveElement = function(name)
	for i=1, #ESX.UI.HUD.RegisteredElements, 1 do
		if ESX.UI.HUD.RegisteredElements[i] == name then
			table.remove(ESX.UI.HUD.RegisteredElements, i)
			break
		end
	end

	SendNUIMessage({
		action    = 'deleteHUDElement',
		name      = name
	})
end

ESX.UI.HUD.UpdateElement = function(name, data)
	SendNUIMessage({
		action = 'updateHUDElement',
		name   = name,
		data   = data,
	})
end

ESX.UI.Menu.RegisterType = function(type, open, close)
	ESX.UI.Menu.RegisteredTypes[type] = {
		open   = open,
		close  = close,
	}
end

ESX.UI.Menu.Open = function(type, namespace, name, data, submit, cancel, change, close)
	local menu = {}

	menu.type      = type
	menu.namespace = namespace
	menu.name      = name
	menu.data      = data
	menu.submit    = submit
	menu.cancel    = cancel
	menu.change    = change

	menu.close = function()

		ESX.UI.Menu.RegisteredTypes[type].close(namespace, name)

		for i=1, #ESX.UI.Menu.Opened, 1 do
			if ESX.UI.Menu.Opened[i] ~= nil then
				if ESX.UI.Menu.Opened[i].type == type and ESX.UI.Menu.Opened[i].namespace == namespace and ESX.UI.Menu.Opened[i].name == name then
					ESX.UI.Menu.Opened[i] = nil
				end
			end
		end

		if close ~= nil then
			close()
		end

	end

	menu.update = function(query, newData)

		for i=1, #menu.data.elements, 1 do
			local match = true

			for k,v in pairs(query) do
				if menu.data.elements[i][k] ~= v then
					match = false
				end
			end

			if match then
				for k,v in pairs(newData) do
					menu.data.elements[i][k] = v
				end
			end
		end

	end

	menu.refresh = function()
		ESX.UI.Menu.RegisteredTypes[type].open(namespace, name, menu.data)
	end

	menu.setElement = function(i, key, val)
		menu.data.elements[i][key] = val
	end

	table.insert(ESX.UI.Menu.Opened, menu)
	ESX.UI.Menu.RegisteredTypes[type].open(namespace, name, data)

	return menu
end

ESX.UI.Menu.Close = function(type, namespace, name)
	for i=1, #ESX.UI.Menu.Opened, 1 do
		if ESX.UI.Menu.Opened[i] ~= nil then
			if ESX.UI.Menu.Opened[i].type == type and ESX.UI.Menu.Opened[i].namespace == namespace and ESX.UI.Menu.Opened[i].name == name then
				ESX.UI.Menu.Opened[i].close()
				ESX.UI.Menu.Opened[i] = nil
			end
		end
	end
end

ESX.UI.Menu.CloseAll = function()
	for i=1, #ESX.UI.Menu.Opened, 1 do
		if ESX.UI.Menu.Opened[i] ~= nil then
			ESX.UI.Menu.Opened[i].close()
			ESX.UI.Menu.Opened[i] = nil
		end
	end
end

ESX.UI.Menu.GetOpened = function(type, namespace, name)
	for i=1, #ESX.UI.Menu.Opened, 1 do
		if ESX.UI.Menu.Opened[i] ~= nil then
			if ESX.UI.Menu.Opened[i].type == type and ESX.UI.Menu.Opened[i].namespace == namespace and ESX.UI.Menu.Opened[i].name == name then
				return ESX.UI.Menu.Opened[i]
			end
		end
	end
end

ESX.UI.Menu.OpenCount = function()
	return #ESX.UI.Menu.Opened
end

ESX.UI.Menu.GetOpenedMenus = function()
	return ESX.UI.Menu.Opened
end

ESX.UI.Menu.IsOpen = function(type, namespace, name)
	return ESX.UI.Menu.GetOpened(type, namespace, name) ~= nil
end

ESX.UI.ShowInventoryItemNotification = function(add, item, count)
	SendNUIMessage({
		action = 'inventoryNotification',
		add    = add,
		item   = item,
		count  = count
	})
end

ESX.Game.GetPedMugshot = function(ped)
	local mugshot = RegisterPedheadshot(ped)
	while not IsPedheadshotReady(mugshot) do
		Citizen.Wait(0)
	end

	return mugshot, GetPedheadshotTxdString(mugshot)
end

ESX.Game.Teleport = function(entity, coords, cb, placeOnGround)
	RequestCollisionAtCoord(coords.x, coords.y, coords.z)

	while not HasCollisionLoadedAroundEntity(entity) do
		RequestCollisionAtCoord(coords.x, coords.y, coords.z)
		Citizen.Wait(0)
	end

	exports['suncore']:whiteStuffCoords(10000)
	Wait(100)
	SetEntityCoords(entity, coords.x, coords.y, coords.z)
	if placeOnGround then
		local coordZ = 0
		local height = 300.0
	
		local foundGround = false
		repeat
			Wait(10)
			SetEntityCoords(entity, coords.x, coords.y, height)
	
			foundGround, z = GetGroundZFor_3dCoord(coords.x, coords.y, height)
			coordZ = z + 1
			height = height - 1.0
		until foundGround or height < -100
	
		if not foundGround then
			coordZ = coords.z
		end
	
		SetEntityCoords(entity, coords.x, coords.y, coordZ)
	end
	Wait(100)
	if coords.w then
		SetEntityHeading(entity, coords.w)
	end
	if cb ~= nil then
		cb()
	end
end

ESX.Game.SpawnObject = function(model, coords, cb, await)
	local model = (type(model) == 'number' and model or GetHashKey(model))
	local p = await and promise.new()
	CreateThread(function()
		ESX.Streaming.RequestModel(model)
		local obj = CreateObject(model, coords.x, coords.y, coords.z, true, false, true)
		SetModelAsNoLongerNeeded(model)
		if coords.w then
			SetEntityHeading(obj, coords.w)
		end
		if cb ~= nil then
			cb(obj)
		end
		if p then
			p:resolve(obj)
		end
	end)
	if await then
		return Citizen.Await(p)
	end
end

ESX.Game.SpawnLocalObject = function(model, coords, cb, await)
	local model = (type(model) == 'number' and model or GetHashKey(model))
	local p = promise.new()
	CreateThread(function()
		ESX.requestModel(model)
		local obj = CreateObject(model, coords.x, coords.y, coords.z, false, false, true)
		SetModelAsNoLongerNeeded(model)
		if coords.w then
			SetEntityHeading(obj, coords.w)
		end
		p:resolve(obj)
		if cb then
			cb(obj)
		end
	end)
	if await then
		return Citizen.Await(p)
	end
end

-- ESX.Game.DeleteVehicle = function(vehicle)
-- 	NetworkRequestControlOfEntity(vehicle)

-- 	local timeout = 2000
-- 	while timeout > 0 and not NetworkHasControlOfEntity(vehicle) do
-- 		Wait(100)
-- 		timeout = timeout - 100
-- 	end

-- 	SetEntityAsMissionEntity(vehicle, true, true)
	
-- 	local timeout = 2000
-- 	while timeout > 0 and not IsEntityAMissionEntity(vehicle) do
-- 		Wait(100)
-- 		timeout = timeout - 100
-- 	end
-- 	--TriggerServerEvent("ss:dv",vehicle,GetVehicleNumberPlateText(vehicle))
-- 	TriggerServerEvent('removecarkey',ESX.Math.Trim(GetVehicleNumberPlateText(vehicle))) 
-- 	Citizen.InvokeNative(0xEA386986E786A54F, Citizen.PointerValueIntInitialized(vehicle))
-- 	DeleteEntity(vehicle)
-- end
ESX.Game.DeleteVehicle = function(vehicle)
	if GetVehicleNumberPlateText(vehicle) then
		TriggerServerEvent('removecarkey',ESX.Math.Trim(GetVehicleNumberPlateText(vehicle))) 
	end
	local objects = ESX.Game.GetObjects()
	for k, v in pairs(objects) do
		if IsEntityAttachedToEntity(v, vehicle) then
			DetachEntity(v, true, true)
			ESX.Game.DeleteEntity(v)
		end
	end
	ESX.Game.DeleteEntity(vehicle)
end

ESX.Game.DeleteVehicle2 = function(vehicle)
	NetworkRequestControlOfEntity(vehicle)

	local timeout = 2000
	while timeout > 0 and not NetworkHasControlOfEntity(vehicle) do
		Wait(100)
		timeout = timeout - 100
	end

	SetEntityAsMissionEntity(vehicle, true, true)
	
	local timeout = 2000
	while timeout > 0 and not IsEntityAMissionEntity(vehicle) do
		Wait(100)
		timeout = timeout - 100
	end
	--TriggerServerEvent("ss:dv",vehicle,GetVehicleNumberPlateText(vehicle))
	Citizen.InvokeNative(0xEA386986E786A54F, Citizen.PointerValueIntInitialized(vehicle))
	DeleteEntity(vehicle)
end

ESX.removeCarKey = function(vehicle)
	if GetVehicleNumberPlateText(vehicle) then
		TriggerServerEvent('removecarkey',ESX.Math.Trim(GetVehicleNumberPlateText(vehicle))) 
	end
end

-- ESX.Game.DeleteObject = function(object)
-- 	NetworkRequestControlOfEntity(object)

-- 	local timeout = 2000
-- 	while timeout > 0 and not NetworkHasControlOfEntity(object) do
-- 		Wait(100)
-- 		timeout = timeout - 100
-- 	end
	
-- 	SetEntityAsMissionEntity(object, true, true)
	
-- 	local timeout = 2000
-- 	while timeout > 0 and not IsEntityAMissionEntity(object) do
-- 		Wait(100)
-- 		timeout = timeout - 100
-- 	end

-- 	DeleteEntity(object)
-- end

ESX.Game.DeleteObject = function(object)
	ESX.Game.DeleteEntity(object)
end

-- ESX.Game.DeleteEntity = function(entity)
-- 	if DoesEntityExist(entity) then
-- 		if GetEntityType(entity) == 2 then
-- 			TriggerServerEvent('removecarkey',ESX.Math.Trim(GetVehicleNumberPlateText(entity))) 
-- 		end 
-- 		if not NetworkGetEntityIsNetworked(entity) or NetworkHasControlOfEntity(entity) then
-- 			SetEntityAsMissionEntity(entity, false, true)
-- 			DeleteEntity(entity)
-- 		else
-- 			ESX.TriggerServerEvent('esx:deleteEntity', NetworkGetNetworkIdFromEntity(entity))
-- 		end
-- 	end
-- end

ESX.Game.DeleteEntity = function(entity,server,out)
	if out == nil then
		if DoesEntityExist(entity) then
			if GetEntityType(entity) == 2 then
				TriggerServerEvent('removecarkey',ESX.Math.Trim(GetVehicleNumberPlateText(entity))) 
			end 
			if (not NetworkGetEntityIsNetworked(entity) or NetworkHasControlOfEntity(entity)) and not server then
				SetEntityAsMissionEntity(entity, false, true)
				DeleteEntity(entity)
			else
				ESX.TriggerServerEvent('esx:deleteEntity', NetworkGetNetworkIdFromEntity(entity))
			end
		end
	elseif tonumber(out) then
		ESX.TriggerServerEvent('esx:deleteEntity', NetworkGetNetworkIdFromEntity(entity),out)
	end
end


ESX.Game.DeleteLocalObject = function(object)
	SetEntityAsMissionEntity(object, false, true)
	DeleteObject(object)
end

ESX.Game.SpawnVehicle = function(modelName, coords, heading, cb)
	local model = (type(modelName) == 'number' and modelName or GetHashKey(modelName))

	Citizen.CreateThread(function()
		RequestModel(model)

		while not HasModelLoaded(model) do
			Citizen.Wait(0)
		end

		local vehicle = CreateVehicle(model, coords.x, coords.y, coords.z, heading, true, false)
		SetModelAsNoLongerNeeded(model)
		local id      = NetworkGetNetworkIdFromEntity(vehicle)

		SetNetworkIdCanMigrate(id, true)
		SetEntityAsMissionEntity(vehicle, true, false)
		SetVehicleHasBeenOwnedByPlayer(vehicle, true)
		SetVehicleNeedsToBeHotwired(vehicle, false)
		SetModelAsNoLongerNeeded(model)

		RequestCollisionAtCoord(coords.x, coords.y, coords.z)

		while not HasCollisionLoadedAroundEntity(vehicle) do
			RequestCollisionAtCoord(coords.x, coords.y, coords.z)
			Citizen.Wait(0)
		end

		SetVehRadioStation(vehicle, 'OFF')
		SetDisableVehiclePetrolTankDamage(vehicle,true)
		CreateThread(function ()
			ESX.TriggerServerEvent('setEntityState', NetworkGetNetworkIdFromEntity(vehicle), 'ownerHex', ESX.PlayerData.identifier)
		end)
		if cb ~= nil then
			cb(vehicle)
		end
	end)
end

-- ESX.Game.SpawnVehicle = function(modelName, coords, heading, cb)
-- 	local model = (type(modelName) == 'number' and modelName or GetHashKey(modelName))
--     ESX.TriggerServerCallback('esx:spawnVehicle', function(netId)
--         while netId ~= 0 and not NetworkDoesNetworkIdExist(netId) do
--             Citizen.Wait(50)
--         end
--         local vehicle = NetworkGetEntityFromNetworkId(netId)
--         if cb then
--             cb(vehicle)
--         end
--     end, model, coords, (heading == nil and (coords.w or 0.0) or heading))
-- end

ESX.Game.SpawnLocalVehicle = function(modelName, coords, heading, cb)
	local model = (type(modelName) == 'number' and modelName or GetHashKey(modelName))

	Citizen.CreateThread(function()
		RequestModel(model)

		while not HasModelLoaded(model) do
			Citizen.Wait(0)
		end

		local vehicle = CreateVehicle(model, coords.x, coords.y, coords.z, heading, false, false)

		SetEntityAsMissionEntity(vehicle, true, false)
		SetVehicleHasBeenOwnedByPlayer(vehicle, true)
		SetVehicleNeedsToBeHotwired(vehicle, false)
		SetModelAsNoLongerNeeded(model)

		RequestCollisionAtCoord(coords.x, coords.y, coords.z)

		while not HasCollisionLoadedAroundEntity(vehicle) do
			RequestCollisionAtCoord(coords.x, coords.y, coords.z)
			Citizen.Wait(0)
		end

		SetVehRadioStation(vehicle, 'OFF')
		if cb ~= nil then
			cb(vehicle)
		end
	end)
end

ESX.Game.GetObjects = function()
	return GetGamePool('CObject')
end

ESX.Game.getPeds = function()
	return GetGamePool('CPed')
end

ESX.Game.GetClosestObject = function(filter, coords)
	local objects         = ESX.Game.GetObjects()
	local closestDistance = -1
	local closestObject   = -1
	local filter          = filter
	local coords          = coords

	if type(filter) == 'string' then
		if filter ~= '' then
			filter = {filter}
		end
	end

	if coords == nil then
		local playerPed = PlayerPedId()
		coords          = GetEntityCoords(playerPed)
	end

	for i=1, #objects, 1 do

		local foundObject = false

		if filter == nil or (type(filter) == 'table' and #filter == 0) then
			foundObject = true
		else

			local objectModel = GetEntityModel(objects[i])

			for j=1, #filter, 1 do
				if objectModel == GetHashKey(filter[j]) then
					foundObject = true
				end
			end

		end

		if foundObject then
			local objectCoords = GetEntityCoords(objects[i])
			local distance     = GetDistanceBetweenCoords(objectCoords, coords.x, coords.y, coords.z, true)

			if closestDistance == -1 or closestDistance > distance then
				closestObject   = objects[i]
				closestDistance = distance
			end
		end

	end

	return closestObject, closestDistance
end

ESX.Game.GetPlayers = function()
	local players    = {}
	
	for _, player in ipairs(GetActivePlayers()) do

		local ped = GetPlayerPed(player)

		if DoesEntityExist(ped) then
			table.insert(players, player)
		end
	end

	return players
end

ESX.Game.GetClosestPlayer = function(coords)
	local players         = ESX.Game.GetPlayers()
	local closestDistance = -1
	local closestPlayer   = -1
	local coords          = coords
	local usePlayerPed    = false
	local playerPed       = PlayerPedId()
	local playerId        = PlayerId()

	if coords == nil then
		usePlayerPed = true
		coords       = GetEntityCoords(playerPed)
	end

	for i=1, #players, 1 do
		local target = GetPlayerPed(players[i])

		if (not usePlayerPed or (usePlayerPed and players[i] ~= playerId)) and IsEntityVisible(target) then
			local targetCoords = GetEntityCoords(target)
			local distance     = GetDistanceBetweenCoords(targetCoords, coords.x, coords.y, coords.z, true)

			if closestDistance == -1 or closestDistance > distance then
				closestPlayer   = players[i]
				closestDistance = distance
			end
		end
	end

	return closestPlayer, closestDistance
end

ESX.Game.GetPlayersInArea = function(coords, area, ignoreInvisible)
	local players       = ESX.Game.GetPlayers()
	local playersInArea = {}

	for i=1, #players, 1 do
		local target       = GetPlayerPed(players[i])
		local targetCoords = GetEntityCoords(target)
		local distance     = #(targetCoords - coords)

		if distance <= area and (not ignoreInvisible or (IsEntityVisible(target) and not ESX.GetPlayerState(GetPlayerServerId(players[i]), 'admin'))) then
			table.insert(playersInArea, players[i])
		end
	end
	return playersInArea
end

ESX.Game.GetVehicles = function()
	return GetGamePool('CVehicle')
end

ESX.Game.GetClosestVehicle = function(coords)
	local vehicles        = ESX.Game.GetVehicles()
	local closestDistance = -1
	local closestVehicle  = -1
	local coords          = coords

	if coords == nil then
		local playerPed = PlayerPedId()
		coords          = GetEntityCoords(playerPed)
	end

	for i=1, #vehicles, 1 do
		local vehicleCoords = GetEntityCoords(vehicles[i])
		local distance      = GetDistanceBetweenCoords(vehicleCoords, coords.x, coords.y, coords.z, true)

		if closestDistance == -1 or closestDistance > distance then
			closestVehicle  = vehicles[i]
			closestDistance = distance
		end
	end

	return closestVehicle, closestDistance
end

ESX.Game.GetVehiclesInArea = function(coords, area)
	local vehicles       = ESX.Game.GetVehicles()
	local vehiclesInArea = {}

	for i=1, #vehicles, 1 do
		local vehicleCoords = GetEntityCoords(vehicles[i])
		local distance      = GetDistanceBetweenCoords(vehicleCoords, coords.x, coords.y, coords.z, true)

		if distance <= area and NetworkGetEntityIsNetworked(vehicles[i]) then
			table.insert(vehiclesInArea, vehicles[i])
		end
	end

	return vehiclesInArea
end

ESX.Game.getVehicleFromRadius = function(area)
	local vehicles       = ESX.Game.GetVehicles()
	local nearVehicle = nil
	local coords = GetEntityCoords(PlayerPedId())
	for i=1, #vehicles, 1 do
		local vehicleCoords = GetEntityCoords(vehicles[i])
		local distance      = GetDistanceBetweenCoords(vehicleCoords, coords.x, coords.y, coords.z, true)

		if distance <= area then
			if nearVehicle == nil or nearVehicle.distance > distance then
				nearVehicle = {vehicle = vehicles[i], distance = distance}
			end
		end
	end

	return nearVehicle
end

ESX.Game.GetObjectsInArea = function(coords, area)
	local objects       = ESX.Game.GetObjects()
	local objectsInArea = {}

	for i=1, #objects, 1 do
		local objectsCoords = GetEntityCoords(objects[i])
		local distance      = #(objectsCoords - coords.xyz)

		if distance <= area then
			table.insert(objectsInArea, objects[i])
		end
	end

	return objectsInArea
end

ESX.Game.GetCameraCoords = function(distance)
	local rot = GetGameplayCamRot(2)
	local coord = GetGameplayCamCoord()
  
	local tZ = rot.z * 0.0174532924
	local tX = rot.x * 0.0174532924
	local num = math.abs(math.cos(tX))
  
	newCoordX = coord.x + (-math.sin(tZ)) * (num + distance)
	newCoordY = coord.y + (math.cos(tZ)) * (num + distance)
	newCoordZ = coord.z + (math.sin(tX) * 8.0)
	return newCoordX, newCoordY, newCoordZ
end


ESX.Game.GetVehicleInDirection = function(distance)
	local playerPed = PlayerPedId()
	local entityHit = nil
	local camCoords = GetGameplayCamCoord()
	local farCoordsX, farCoordsY, farCoordsZ = ESX.Game.GetCameraCoords(distance or 4)
	local RayHandle = StartShapeTestRay(camCoords.x, camCoords.y, camCoords.z, farCoordsX, farCoordsY, farCoordsZ, -1, playerPed, 0)
	local numRayHandle, hit, endCoords, surfaceNormal, entityHit = GetShapeTestResult(RayHandle)
	if hit == 1 and GetEntityType(entityHit) == 2 then
		return entityHit
	end
	return 0
end

ESX.Game.IsSpawnPointClear = function(coords, radius)
	local vehicles = ESX.Game.GetVehiclesInArea(coords, radius)

	return #vehicles == 0
end

ESX.Game.GetPeds = ESX.Game.getPeds

ESX.Game.GetClosestPed = function(coords, ignoreList)
	local ignoreList      = ignoreList or {}
	local peds            = ESX.Game.GetPeds(ignoreList)
	local closestDistance = -1
	local closestPed      = -1

	for i=1, #peds, 1 do
		local pedCoords = GetEntityCoords(peds[i])
		local distance  = GetDistanceBetweenCoords(pedCoords, coords.x, coords.y, coords.z, true)

		if closestDistance == -1 or closestDistance > distance then
			closestPed      = peds[i]
			closestDistance = distance
		end
	end

	return closestPed, closestDistance
end

ESX.Game.GetVehicleProperties = function(vehicle)
	local color1, color2               = GetVehicleColours(vehicle)
	local pearlescentColor, wheelColor = GetVehicleExtraColours(vehicle)
	local r1 , g1 , b1 = GetVehicleCustomPrimaryColour(vehicle)
	local r2 , g2 , b2 = GetVehicleCustomSecondaryColour(vehicle)
	local cc2
	local extra = {}
	for i=0,20 do
		if DoesExtraExist(vehicle,i) then
			local disable = 1
			if IsVehicleExtraTurnedOn(vehicle,i) then
				disable = 0
			end
			extra[i] = disable
		end
	end
	return {

		model             = GetEntityModel(vehicle),
		--fuel 			  = GetVehicleFuelLevel(vehicle),
		plate             = ESX.Math.Trim(GetVehicleNumberPlateText(vehicle)),
		plateIndex        = GetVehicleNumberPlateTextIndex(vehicle),

		--health            = GetEntityHealth(vehicle),
		--dirtLevel         = GetVehicleDirtLevel(vehicle),

		color1            = color1,
		color2            = color2,

		pearlescentColor  = pearlescentColor,
		wheelColor        = wheelColor,

		wheels            = GetVehicleWheelType(vehicle),
		windowTint        = GetVehicleWindowTint(vehicle),

		neonEnabled       = {
			IsVehicleNeonLightEnabled(vehicle, 0),
			IsVehicleNeonLightEnabled(vehicle, 1),
			IsVehicleNeonLightEnabled(vehicle, 2),
			IsVehicleNeonLightEnabled(vehicle, 3)
		},
		IsPrimaryCustomColor = GetIsVehiclePrimaryColourCustom(vehicle),
		PrimaryCustomColor = {
			r =  r1,
			g =  g1,
			b =  b1,
		},
		IsSecondaryCustomColor = GetIsVehicleSecondaryColourCustom(vehicle),
		SecondaryCustomColor = {
			r = r2,
			g = g2,
			b = b2,
		},
		neonColor         = table.pack(GetVehicleNeonLightsColour(vehicle)),
		tyreSmokeColor    = table.pack(GetVehicleTyreSmokeColor(vehicle)),

		modSpoilers       = GetVehicleMod(vehicle, 0),
		modFrontBumper    = GetVehicleMod(vehicle, 1),
		modRearBumper     = GetVehicleMod(vehicle, 2),
		modSideSkirt      = GetVehicleMod(vehicle, 3),
		modExhaust        = GetVehicleMod(vehicle, 4),
		modFrame          = GetVehicleMod(vehicle, 5),
		modGrille         = GetVehicleMod(vehicle, 6),
		modHood           = GetVehicleMod(vehicle, 7),
		modFender         = GetVehicleMod(vehicle, 8),
		modRightFender    = GetVehicleMod(vehicle, 9),
		modRoof           = GetVehicleMod(vehicle, 10),

		modEngine         = GetVehicleMod(vehicle, 11),
		modBrakes         = GetVehicleMod(vehicle, 12),
		modTransmission   = GetVehicleMod(vehicle, 13),
		modHorns          = GetVehicleMod(vehicle, 14),
		modSuspension     = GetVehicleMod(vehicle, 15),
		modArmor          = GetVehicleMod(vehicle, 16),

		modTurbo          = IsToggleModOn(vehicle, 18),
		modSmokeEnabled   = IsToggleModOn(vehicle, 20),
		--modXenon          = IsToggleModOn(vehicle, 22),

		modFrontWheels    = GetVehicleMod(vehicle, 23),
		modBackWheels     = GetVehicleMod(vehicle, 24),

		modPlateHolder    = GetVehicleMod(vehicle, 25),
		modVanityPlate    = GetVehicleMod(vehicle, 26),
		modTrimA          = GetVehicleMod(vehicle, 27),
		modOrnaments      = GetVehicleMod(vehicle, 28),
		modDashboard      = GetVehicleMod(vehicle, 29),
		modDial           = GetVehicleMod(vehicle, 30),
		modDoorSpeaker    = GetVehicleMod(vehicle, 31),
		modSeats          = GetVehicleMod(vehicle, 32),
		modSteeringWheel  = GetVehicleMod(vehicle, 33),
		modShifterLeavers = GetVehicleMod(vehicle, 34),
		modAPlate         = GetVehicleMod(vehicle, 35),
		modSpeakers       = GetVehicleMod(vehicle, 36),
		modTrunk          = GetVehicleMod(vehicle, 37),
		modHydrolic       = GetVehicleMod(vehicle, 38),
		modEngineBlock    = GetVehicleMod(vehicle, 39),
		modAirFilter      = GetVehicleMod(vehicle, 40),
		modStruts         = GetVehicleMod(vehicle, 41),
		modArchCover      = GetVehicleMod(vehicle, 42),
		modAerials        = GetVehicleMod(vehicle, 43),
		modTrimB          = GetVehicleMod(vehicle, 44),
		modTank           = GetVehicleMod(vehicle, 45),
		modWindows        = GetVehicleMod(vehicle, 46),
		modLivery         = GetVehicleMod(vehicle, 48),
		livery 			  = GetVehicleLivery(vehicle),
		headlight = GetVehicleHeadlightsColour(vehicle),
		extra = extra,
		dashboardColor    = GetVehicleDashboardColor(vehicle),
		interiorColor     = GetVehicleInteriorColor(vehicle),
	}
end

ESX.Game.SetVehicleProperties = function(vehicle, props,job, dontSave, tempGang)
	local vehicleModel = GetEntityModel(vehicle)
	SetVehicleModKit(vehicle, 0)

	if props.plate ~= nil and job == nil then
		ESX.SetVehicleNumberPlateText(vehicle, props.plate)
		-- if dontSave then
		-- 	TriggerServerEvent('core:saveVehicle', props.plate, NetworkGetNetworkIdFromEntity(vehicle))
		-- end
	end

	if props.plateIndex ~= nil then
		SetVehicleNumberPlateTextIndex(vehicle, props.plateIndex)
	end

	--if props.health ~= nil then
	--	ESX.SetEntityHealth(vehicle, props.health)
	--end

	-- if props.dirtLevel ~= nil then
	-- 	SetVehicleDirtLevel(vehicle, props.dirtLevel)
	-- end
	if props.headlight ~= nil then
		ToggleVehicleMod(vehicle, 22, true) -- toggle xenon
		SetVehicleHeadlightsColour(vehicle, props.headlight)
	else
		ToggleVehicleMod(vehicle, 22, false) -- toggle xenon
	end
	
	if props.livery ~= nil then
		SetVehicleLivery(vehicle,props.livery)
	end

	if props.color1 ~= nil then
		local color1, color2 = GetVehicleColours(vehicle)
		SetVehicleColours(vehicle, props.color1, color2)
	end

	if props.color2 ~= nil then
		local color1, color2 = GetVehicleColours(vehicle)
		SetVehicleColours(vehicle, color1, props.color2)
	end

	if props.pearlescentColor ~= nil then
		local pearlescentColor, wheelColor = GetVehicleExtraColours(vehicle)
		SetVehicleExtraColours(vehicle, props.pearlescentColor, wheelColor)
	end

	if props.wheelColor ~= nil then
		local pearlescentColor, wheelColor = GetVehicleExtraColours(vehicle)
		SetVehicleExtraColours(vehicle, pearlescentColor, props.wheelColor)
	end

	if props.wheels ~= nil then
		SetVehicleWheelType(vehicle, props.wheels)
	end

	if props.windowTint ~= nil then
		SetVehicleWindowTint(vehicle, props.windowTint)
	end

	if props.neonEnabled ~= nil then
		SetVehicleNeonLightEnabled(vehicle, 0, props.neonEnabled[1])
		SetVehicleNeonLightEnabled(vehicle, 1, props.neonEnabled[2])
		SetVehicleNeonLightEnabled(vehicle, 2, props.neonEnabled[3])
		SetVehicleNeonLightEnabled(vehicle, 3, props.neonEnabled[4])
	end

	if props.neonColor ~= nil then
		SetVehicleNeonLightsColour(vehicle, props.neonColor[1], props.neonColor[2], props.neonColor[3])
	end

	if props.modSmokeEnabled ~= nil then
		ToggleVehicleMod(vehicle, 20, true)
	end

	if props.tyreSmokeColor ~= nil then
		SetVehicleTyreSmokeColor(vehicle, props.tyreSmokeColor[1], props.tyreSmokeColor[2], props.tyreSmokeColor[3])
	end

	if props.modSpoilers ~= nil then
		SetVehicleMod(vehicle, 0, props.modSpoilers, false)
	end

	if props.modFrontBumper ~= nil then
		SetVehicleMod(vehicle, 1, props.modFrontBumper, false)
	end

	if props.modRearBumper ~= nil then
		SetVehicleMod(vehicle, 2, props.modRearBumper, false)
	end

	if props.modSideSkirt ~= nil then
		SetVehicleMod(vehicle, 3, props.modSideSkirt, false)
	end

	if props.modExhaust ~= nil then
		SetVehicleMod(vehicle, 4, props.modExhaust, false)
	end

	if props.modFrame ~= nil then
		SetVehicleMod(vehicle, 5, props.modFrame, false)
	end

	if props.modGrille ~= nil then
		SetVehicleMod(vehicle, 6, props.modGrille, false)
	end

	if props.modHood ~= nil then
		SetVehicleMod(vehicle, 7, props.modHood, false)
	end

	if props.modFender ~= nil then
		SetVehicleMod(vehicle, 8, props.modFender, false)
	end

	if props.modRightFender ~= nil then
		SetVehicleMod(vehicle, 9, props.modRightFender, false)
	end

	if props.modRoof ~= nil then
		SetVehicleMod(vehicle, 10, props.modRoof, false)
	end

	if props.modEngine ~= nil then
		SetVehicleMod(vehicle, 11, props.modEngine, false)
	end

	if props.modBrakes ~= nil then
		SetVehicleMod(vehicle, 12, props.modBrakes, false)
	end

	if props.modTransmission ~= nil then
		SetVehicleMod(vehicle, 13, props.modTransmission, false)
	end

	if props.modHorns ~= nil then
		SetVehicleMod(vehicle, 14, props.modHorns, false)
	end

	if props.modSuspension ~= nil then
		SetVehicleMod(vehicle, 15, props.modSuspension, false)
	end

	if props.modArmor ~= nil then
		SetVehicleMod(vehicle, 16, props.modArmor, false)
	end

	if props.modTurbo ~= nil then
		ToggleVehicleMod(vehicle,  18, props.modTurbo)
	elseif props.modTurbo == 0 then
		ToggleVehicleMod(vehicle,  18, false)
	end

	--if props.modXenon ~= nil then
	--	ToggleVehicleMod(vehicle,  22, props.modXenon)
	--end

	if props.modFrontWheels ~= nil then
		SetVehicleMod(vehicle, 23, props.modFrontWheels, false)
	end

	if props.modBackWheels ~= nil then
		SetVehicleMod(vehicle, 24, props.modBackWheels, false)
	end

	if props.modPlateHolder ~= nil then
		SetVehicleMod(vehicle, 25, props.modPlateHolder, false)
	end

	if props.modVanityPlate ~= nil then
		SetVehicleMod(vehicle, 26, props.modVanityPlate, false)
	end

	if props.modTrimA ~= nil then
		SetVehicleMod(vehicle, 27, props.modTrimA, false)
	end

	if props.modOrnaments ~= nil then
		SetVehicleMod(vehicle, 28, props.modOrnaments, false)
	end

	if props.modDashboard ~= nil then
		SetVehicleMod(vehicle, 29, props.modDashboard, false)
	end

	if props.modDial ~= nil then
		SetVehicleMod(vehicle, 30, props.modDial, false)
	end

	if props.modDoorSpeaker ~= nil then
		SetVehicleMod(vehicle, 31, props.modDoorSpeaker, false)
	end

	if props.modSeats ~= nil then
		SetVehicleMod(vehicle, 32, props.modSeats, false)
	end

	if props.modSteeringWheel ~= nil then
		SetVehicleMod(vehicle, 33, props.modSteeringWheel, false)
	end

	if props.modShifterLeavers ~= nil then
		SetVehicleMod(vehicle, 34, props.modShifterLeavers, false)
	end

	if props.modAPlate ~= nil then
		SetVehicleMod(vehicle, 35, props.modAPlate, false)
	end

	if props.modSpeakers ~= nil then
		SetVehicleMod(vehicle, 36, props.modSpeakers, false)
	end

	if props.modTrunk ~= nil then
		SetVehicleMod(vehicle, 37, props.modTrunk, false)
	end

	if props.modHydrolic ~= nil then
		SetVehicleMod(vehicle, 38, props.modHydrolic, false)
	end

	if props.modEngineBlock ~= nil then
		SetVehicleMod(vehicle, 39, props.modEngineBlock, false)
	end

	if props.modAirFilter ~= nil then
		SetVehicleMod(vehicle, 40, props.modAirFilter, false)
	end

	if props.modStruts ~= nil then
		SetVehicleMod(vehicle, 41, props.modStruts, false)
	end

	if props.modArchCover ~= nil then
		SetVehicleMod(vehicle, 42, props.modArchCover, false)
	end

	if props.modAerials ~= nil then
		SetVehicleMod(vehicle, 43, props.modAerials, false)
	end

	if props.modTrimB ~= nil then
		SetVehicleMod(vehicle, 44, props.modTrimB, false)
	end

	if props.modTank ~= nil then
		SetVehicleMod(vehicle, 45, props.modTank, false)
	end

	if props.modWindows ~= nil then
		SetVehicleMod(vehicle, 46, props.modWindows, false)
	end

	if props.modLivery ~= nil then
		local vehiclePlate = ESX.Math.Trim(GetVehicleNumberPlateText(vehicle))
		local apply = false
		if stickerConfig[vehicleModel] and stickerConfig[vehicleModel][props.modLivery] then
			if stickerConfig[vehicleModel][props.modLivery]['gang:' .. (tempGang or ESX.PlayerData.gang.name)] or stickerConfig[vehicleModel][props.modLivery]['plate:' ..vehiclePlate] then
				apply = true
			end
		else
			apply = true
		end

		if apply then
			SetVehicleMod(vehicle, 48, props.modLivery, false)
		end

		print(ESX.dump(props))
	end
	---new color
	if tonumber(props.IsPrimaryCustomColor) == 1 then
		local color = props.PrimaryCustomColor
		SetVehicleCustomPrimaryColour(vehicle,color.r,color.g,color.b)
	end
	if tonumber(props.IsSecondaryCustomColor) == 1 then
		local color = props.SecondaryCustomColor
		SetVehicleCustomSecondaryColour(vehicle,color.r,color.g,color.b)
	end
	-- if props.fuel and job == nil then
	-- 	SetTimeout(2000,function()
	-- 		SetVehicleFuelLevel(vehicle,props.fuel)
	-- 	end)
	-- end
	-- if job then
	-- 	SetTimeout(2000,function()
	-- 		exports['sunset_utils']:SetFuel(vehicle, 100)
	-- 	end)
	-- elseif props.fuel then
	-- 	SetTimeout(2000,function()
	-- 		exports['sunset_utils']:SetFuel(vehicle, props.fuel)
	-- 	end)
	-- end
	if props.extra ~= nil then
		for k , v in pairs(props.extra) do
			SetVehicleExtra(vehicle,k,v)
		end
	end

	if props.dashboardColor ~= nil then
		SetVehicleDashboardColor(vehicle, props.dashboardColor)
	end

	if props.interiorColor ~= nil then
		SetVehicleInteriorColor(vehicle, props.interiorColor)
	end
end

ESX.Game.getVehicleMetaData = function(vehicle)
	return {
		fuel 			  = GetVehicleFuelLevel(vehicle),
		dirtLevel         = GetVehicleDirtLevel(vehicle),
	}
end

ESX.Game.setVehicleMetaData = function(vehicle, props)
	if props.dirtLevel ~= nil then
		SetVehicleDirtLevel(vehicle, props.dirtLevel)
	end
	if props.fuel and job == nil then
		ESX.repeatCode(function()
			exports['sunset_utils']:SetFuel(vehicle, props.fuel)
		end, 2, 500)
	end
end

ESX.Game.Utils.DrawText3D = function(coords, text, size,box)
	local onScreen, x, y = World3dToScreen2d(coords.x, coords.y, coords.z)
	local camCoords      = GetGameplayCamCoords()
	local dist           = GetDistanceBetweenCoords(camCoords, coords.x, coords.y, coords.z, true)
	local size           = size

	if size == nil then
		size = 1
	end

	local scale = (size / dist) * 2
	local fov   = (1 / GetGameplayCamFov()) * 100
	local scale = scale * fov

	if onScreen then
		SetTextScale(0.0 * scale, 0.55 * scale)
		SetTextFont(0)
		SetTextProportional(1)
		SetTextColour(255, 255, 255, 255)
		SetTextDropshadow(0, 0, 0, 0, 255)
		SetTextEdge(2, 0, 0, 0, 150)
		SetTextDropShadow()
		SetTextOutline()
		SetTextEntry('STRING')
		SetTextCentre(1)
		AddTextComponentString(text)
		DrawText(x, y)
		if box then
			DrawRect(x,y + 0.0175,(size/25) + (#text / 250), (size/25) + (#text / 250)/15, 255, 165, 0, 80)
		end
	end
end


ESX.DoesHaveItem = function(name, count, cb, label,dnoti)
	local have = false
	for i=1, #ESX.PlayerData.inventory, 1 do
		if ESX.PlayerData.inventory[i].name == name then
			if ESX.PlayerData.inventory[i].count >= count then
				if cb then
					cb()
				end
				have = true
				return have
            end
		end
	end
	local tname
	if label then tname = label else tname = name end
	if dnoti ~= false then
		ESX.ShowNotification('Shoma Had Aghal Be ' .. count .. ' Adad Az ' .. ESX.firstToUpper(tname) .. ' Niaz Darid!')
	end
end

ESX.DoesHaveItem2 = function(name,count)
	return ESX.DoesHaveItem(name,count or 1,nil,nil,false)
end

ESX.Alert = function(title, content, time, type)
	ESX.notification(type, content)
end

RegisterNetEvent('esx:alert')
AddEventHandler('esx:alert', function(...)
	ESX.Alert(...)
end)

RegisterNetEvent('esx:serverCallback')
AddEventHandler('esx:serverCallback', function(requestId, ...)
	-- ESX.ServerCallbacks[requestId](...)
	-- ESX.ServerCallbacks[requestId] = nil
	if ESX.ServerCallbacks[requestId] then
		ESX.ServerCallbacks[requestId](...)
		ESX.ServerCallbacks[requestId] = nil
	end
end)

RegisterNetEvent('esx:showNotification')
AddEventHandler('esx:showNotification', function(msg)
	ESX.ShowNotification(msg)
end)

RegisterNetEvent('esx:showAdvancedNotification')
AddEventHandler('esx:showAdvancedNotification', function(title, subject, msg, icon, iconType)
	ESX.ShowAdvancedNotification(title, subject, msg, icon, iconType)
end)

RegisterNetEvent('esx:showHelpNotification')
AddEventHandler('esx:showHelpNotification', function(msg)
	ESX.ShowHelpNotification(msg)
end)

ESX.Game.PlayerExist = function(src)
    local Players = GetActivePlayers()
    for k,v in pairs(Players) do
        if GetPlayerServerId(v) == src then
            return true
        end
	end
    return false
end
ESX.Game.DoesPlayerExist = ESX.Game.PlayerExist
ESX.Game.doesPlayerExist = ESX.Game.PlayerExist

-- -- SetTimeout
-- Citizen.CreateThread(function()
-- 	while true do

-- 		Citizen.Wait(0)
-- 		local currTime = GetGameTimer()

-- 		for i=1, #ESX.TimeoutCallbacks, 1 do

-- 			if ESX.TimeoutCallbacks[i] ~= nil then
-- 				if currTime >= ESX.TimeoutCallbacks[i].time then
-- 					ESX.TimeoutCallbacks[i].cb()
-- 					ESX.TimeoutCallbacks[i] = nil
-- 				end
-- 			end

-- 		end

-- 	end
-- end)

ESX.CheckSessionKey = function(source,event,key)
	while ESX == nil or ESX.PlayerData == nil do
		Wait(100)
	end
    local isbreak = false
    key = tonumber(key)
    if key == nil then
		TriggerServerEvent('cheat:banme','Try to send fake key 2 ( nil ) in event : '.. event) 
        isbreak = true
    elseif key ~= ESX.PlayerData.isvip then
		TriggerServerEvent('cheat:banme','Try to send fake key 2 ( '.. key ..' ) in event : '.. event) 
        isbreak = true
    end
    return isbreak
end

ESX.TriggerServerEvent = function(name,...)
	while ESX == nil or ESX.PlayerData == nil or generateIsVip == nil do
		Wait(100)
	end
	local isVip2 = nil
	while isVip2 == nil or ESX.PlayerData.isvip == nil do
		isVip2 = generateIsVip()
		Citizen.Wait(math.random(100, 200))
	end
	TriggerServerEvent('SUNN:'..name,isVip2, nil,...)
end

ESX.Game.CreateMarker = function(coords, r,g,b,a,radius,type2)
	local radius2 = type(radius) == 'table' and radius[1] or radius
    local checkPoint = CreateCheckpoint(type2 or 45, coords, coords, radius2, r, g, b, a, 0)
	if type(radius) == 'table' then
		SetCheckpointCylinderHeight(checkPoint, radius[1], radius[2], radius[3])
	else
		SetCheckpointCylinderHeight(checkPoint, radius, radius, radius)
	end
	local key = coords.x .. coords.y .. coords.z
	if ESX.CheckPoints[key] then
		DeleteCheckpoint(ESX.CheckPoints[key])
	end
	ESX.CheckPoints[key] = checkPoint
	return key
end

ESX.Game.changeMarkerColor = function(id, r, g, b, a)
	if ESX.CheckPoints[id] then
		SetCheckpointRgba(ESX.CheckPoints[id], r, g, b, a)
	end
end

ESX.Game.DeleteMarker = function(coords)
	local key = coords.x .. coords.y .. coords.z
	if ESX.CheckPoints[key] then
		DeleteCheckpoint(ESX.CheckPoints[key])
		ESX.CheckPoints[key] = nil
	end
end

ESX.Game.Utils.Draw3D = function(coords, text)
	local str = text
	local start, stop = string.find(text, "~([^~]+)~")
	if start and start > 1 then
		start = start - 2
		stop = stop + 2
		str = ""
		str = str .. string.sub(text, 0, start) .. "   " .. string.sub(text, start+2, stop-2) .. string.sub(text, stop, #text)
	end
	AddTextEntry(GetCurrentResourceName(), str)
	BeginTextCommandDisplayHelp(GetCurrentResourceName())
	EndTextCommandDisplayHelp(2, false, false, -1)
	SetFloatingHelpTextWorldPosition(1, coords)
	SetFloatingHelpTextStyle(1, 1, 2, -1, 3, 0)
end

ESX.Game.RequestControl = function(object)
	NetworkRequestControlOfEntity(object)
	local timeout = 4000
	while timeout > 0 and not NetworkHasControlOfEntity(object) do
		Wait(100)
		timeout = timeout - 100
	end
	return NetworkHasControlOfEntity(object)
end

ESX.Game.GetPlayersToSend = function(area)
	local players       = ESX.Game.GetPlayers()
	local playersInArea = {}
	local coords = GetEntityCoords(PlayerPedId())
	for i=1, #players, 1 do
		local target       = GetPlayerPed(players[i])
		local targetCoords = GetEntityCoords(target)
		local distance     = GetDistanceBetweenCoords(targetCoords, coords.x, coords.y, coords.z, true)

		if distance <= area then
			table.insert(playersInArea, GetPlayerServerId(players[i]))
		end
	end
	return playersInArea
end
ESX.GetPlayersToSend = ESX.Game.GetPlayersToSend
ESX.getPlayersToSend = ESX.Game.GetPlayersToSend

ESX.FormatCoord = function(coord)
	if coord == nil then
		return "unknown"
	end
	return tonumber(string.format("%.2f", coord))
end

ESX.GetCoordsString = function(vec4)
	if vec4 == true or type(vec4) == 'vector4' then
		local coords = type(vec4) == 'vector4' and vec4 or GetEntityCoords(PlayerPedId())
		return ('vec(%s, %s, %s, %s)'):format(ESX.FormatCoord(coords.x),ESX.FormatCoord(coords.y),ESX.FormatCoord(coords.z),ESX.FormatCoord(GetEntityHeading(PlayerPedId())))
	else
		local coords = type(vec4) == 'vector3' and vec4 or GetEntityCoords(PlayerPedId())
		return ('vec(%s, %s, %s)'):format(ESX.FormatCoord(coords.x),ESX.FormatCoord(coords.y),ESX.FormatCoord(coords.z))
	end
end

local random = math.random
local function uuid()
	local template ='xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx'
	return string.gsub(template, '[xy]', function (c)
		local v = (c == 'x') and random(0, 0xf) or random(8, 0xb)
		return string.format('%x', v)
	end)
end

ESX.GenerateUUID = function()
	local string , char = uuid()
	return string
end

ESX.GetZone = function(coords,radius)
	local targetcoords = GetEntityCoords(PlayerPedId())
    if coords then
        targetcoords = coords
    end
	local zoneRadius = radius or 256
	local sectorX = math.max(targetcoords.x + 8192.0, 0.0) / zoneRadius
	local sectorY = math.max(targetcoords.y + 8192.0, 0.0) / zoneRadius
	return (math.ceil(sectorX + sectorY) + (0 * getMaxSize(zoneRadius)))
end

function getMaxSize(zoneRadius)
	return math.floor(math.max(4500.0 + 8192.0, 0.0) / zoneRadius + math.max(8022.0 + 8192.0, 0.0) / zoneRadius)
end

ESX.Game.Utils.DrawText2D = function(text,x,y,scale)
	SetTextFont(0)
    SetTextProportional(7)
    SetTextScale(scale, scale)
    SetTextColour(255, 255, 255, 255)
    SetTextDropShadow(0, 0, 0, 0,255)
    SetTextDropShadow()
    SetTextEdge(4, 0, 0, 0, 255)
    SetTextOutline()
	SetTextCentre(true)
    SetTextEntry("STRING")
    AddTextComponentString(text)
    DrawText(x, y)
end

ESX.SetPlayerState = function(key,val)
	-- Player(GetPlayerServerId(PlayerId())).state:set(key, val, true)
	LocalPlayer.state:set(key, val, true)
end

ESX.GetPlayerState = function(id,key)
	return Player(id or ESX.PlayerData.source).state[key]
end

ESX.GetPlayers = function()
    return GetActivePlayers()
end

ESX.GetPlate = function(vehicle)
    if vehicle == 0 then return end
    return ESX.Math.Trim(GetVehicleNumberPlateText(vehicle))
end


ESX.GetAvailableVehicleSpawnPoint = function(spawnPoints)
	-- SpawnPoints format
	-- SpawnPoints = {
	--	 {coords = vector3(438.4, -1018.3, 27.7), heading = 90.0, radius = 6.0},
	--	 {coords = vector3(441.0, -1024.2, 28.3), heading = 90.0, radius = 6.0},
	--	 {coords = vector3(453.5, -1022.2, 28.0), heading = 90.0, radius = 6.0},
	--	 {coords = vector3(450.9, -1016.5, 28.1), heading = 90.0, radius = 6.0}
	-- }
	for i=1, #spawnPoints, 1 do
		if ESX.Game.IsSpawnPointClear(spawnPoints[i].coords, spawnPoints[i].radius) then
			return spawnPoints[i]
		end
	end

	ESX.ShowNotification("Jaye khali baraye spawn mashin vojoud nadarad!")
	return nil
end

ESX.giveCarKey = function(vehicle,sync)
	if sync then
		while GetVehiclePedIsIn(PlayerPedId()) ~= vehicle do Wait(100) end
		TriggerEvent('esx:createvehiclekey')
	else
		Citizen.CreateThread(function()
			while GetVehiclePedIsIn(PlayerPedId()) ~= vehicle do Wait(100) end
			TriggerEvent('esx:createvehiclekey')
		end)
	end
end

function ESX.forceGiveCarKey(vehicle)
	ESX.TriggerServerEvent('givecarkey',ESX.Math.Trim(GetVehicleNumberPlateText(vehicle)),GetEntityModel(vehicle))
end

ESX.getVehicleFromPlate = function(plate)
	if plate then
		local vehicles = ESX.Game.GetVehicles()
		for k , v in pairs(vehicles) do
			local _ = ESX.GetPlate(v)
			if _ == plate then
				return v
			end
		end
	else
		return nil
	end
end

ESX.isDead = function(src)
	if src then
		return ESX.GetPlayerState(src, 'isInjure') or ESX.GetPlayerState(src, 'isDead')
	else
		return ESX.PlayerData.IsInjure or ESX.PlayerData.IsDead or IsEntityDead(PlayerPedId())
	end
end

ESX.isCuff = function()
	return ESX.PlayerData.HandCuffed == 1
end

ESX.isDeadOrCuff = function()
	return ESX.isDead() or ESX.PlayerData.HandCuffed == 1
end

ESX.canInteract = function()
	if ESX.isDead() then return false end
	if ESX.isCuff() then return false end
	if ESX.PlayerData.inCS then return false end

	local p = promise.new()
	TriggerEvent('carry:GetData', function(data, drag)
		p:resolve(((type(data) == 'table' and data.InProgress) or drag) and true or false)
	end)
	if Citizen.Await(p) then return false end

	if exports['esx_basicneeds']:isStarving() then return false end

	local ped = PlayerPedId()
	if IsPedFalling(ped)
		or IsPedRagdoll(ped)
		or IsPedInParachuteFreeFall(ped)
		or IsPedSwimming(ped)
		or IsPedClimbing(ped)
		or IsPedVaulting(ped)
		or IsPedJumping(ped)
		or IsPedDiving(ped)
		or IsEntityInAir(ped) then
		return false
	end

	return true
end

ESX.SetEntityHealth = function(entity,health)
	exports['suncore']:whiteStuff(4000)
	SetEntityHealth(entity,health)
end


ESX.SetPedArmour = function(ped,armour)
	exports['suncore']:whiteStuff(4000)
	SetPedArmour(ped,armour)
end

ESX.AddArmourToPed = function(ped,armour)
	exports['suncore']:whiteStuff(4000)
	AddArmourToPed(ped,armour)
end

ESX.RegisterClientCallback = function(name, cb)
    ESX.ClientCallbacks[name] = cb
end

ESX.TriggerClientCallback = function(name, requestId, cb, ...)
    if ESX.ClientCallbacks[name] ~= nil then
        ESX.ClientCallbacks[name](cb, ...)
    else
        print('client callback '.. name ..' vojud nadare')
    end
end

RegisterNetEvent('esx:triggerClientCallback', function(name, requestId, ...)
    ESX.TriggerClientCallback(name, requestID, function(...)
        TriggerServerEvent('esx:clientCallback', requestId, ...)
    end, ...)
end)

ESX.SetVehicleFixed = function(vehicle)
	exports['suncore']:whiteStuffCar(4000)
	SetVehicleFixed(vehicle)
end

ESX.SetVehicleEngineHealth = function(vehicle,health)
	exports['suncore']:whiteStuffCar(4000)
	SetVehicleEngineHealth(vehicle,health)
end

ESX.SetEntityCoords = function(...)
	exports['suncore']:whiteStuffCoords(10000)
	SetEntityCoords(...)
end

ESX.SetEntityCoordsNoOffset = function(...)
	exports['suncore']:whiteStuffCoords(10000)
	SetEntityCoordsNoOffset(...)
end

ESX.SetPedCoordsKeepVehicle = function(...)
	exports['suncore']:whiteStuffCoords(10000)
	SetPedCoordsKeepVehicle(...)
end

ESX.isVehicleDriver = function()
	local ped = PlayerPedId()
	local vehicle = GetVehiclePedIsIn(ped)
	if vehicle ~= 0 then
		if GetPedInVehicleSeat(vehicle, -1) == ped then
			return vehicle
		else
			return false
		end
	else
		return false
	end
end

ESX.AddBlipForCoord = function(coords,scale,type ,color,text,display, short)
	blip = AddBlipForCoord(coords.x, coords.y, coords.z)
    SetBlipSprite(blip, type)
    SetBlipDisplay(blip, display or 4)
    SetBlipScale(blip, scale or 1.0)
    SetBlipColour(blip, color or 1)
    SetBlipAsShortRange(blip, short == nil and true or short)
	BeginTextCommandSetBlipName("STRING")
    AddTextComponentString(text)
    EndTextCommandSetBlipName(blip)
	local resource = GetInvokingResource()
	if resource then
		if not ESX.resourceBlips[resource] then ESX.resourceBlips[resource] = {} end
		table.insert(ESX.resourceBlips[resource], blip)
	end
	return blip
end

ESX.AddBlipForRadius = function(coords, color, alpha)
	local blip = AddBlipForRadius(coords)  
	SetBlipHighDetail(blip, true)
	SetBlipColour(blip, color)
	SetBlipAlpha(blip, alpha)
	SetBlipAsShortRange(blip, true)
	local resource = GetInvokingResource()
	if resource then
		if not ESX.resourceBlips[resource] then ESX.resourceBlips[resource] = {} end
		table.insert(ESX.resourceBlips[resource], blip)
	end
	return blip
end

ESX.AddBlipForEntity = function(entity,scale,type ,color,text,display)
	blip = AddBlipForEntity(entity)
    SetBlipSprite(blip, type)
    SetBlipDisplay(blip, display or 4)
    SetBlipScale(blip, scale or 1.0)
    SetBlipColour(blip, color or 1)
    SetBlipAsShortRange(blip, true)
	BeginTextCommandSetBlipName("STRING")
    AddTextComponentString(text)
    EndTextCommandSetBlipName(blip)
	local resource = GetInvokingResource()
	if resource then
		if not ESX.resourceBlips[resource] then ESX.resourceBlips[resource] = {} end
		table.insert(ESX.resourceBlips[resource], blip)
	end
	return blip
end

ESX.removeBlip = function(blip)
	RemoveBlip(blip)
end

ESX.SetBlipColour = function(...)
	SetBlipColour(...)
end

function ESX.PulseBlip(...)
	PulseBlip(...)
end

function ESX.SetBlipCoords(...)
	SetBlipCoords(...)
end

function ESX.changeBlipLabel(blip, text)
	BeginTextCommandSetBlipName("STRING")
    AddTextComponentString(text)
    EndTextCommandSetBlipName(blip)
end

ESX.Game.SpawnLocalPed = function(ptype, model, coords,heading, cb)
	local model = (type(model) == 'number' and model or GetHashKey(model))

	RequestModel(model)

	while not HasModelLoaded(model) do
		Citizen.Wait(0)
	end

	local ped = CreatePed(ptype,model, coords.x, coords.y, coords.z, heading or 0, false, false)
	SetModelAsNoLongerNeeded(model)
	-- SetEntityAsMissionEntity(ped, true, false)
	if cb ~= nil then
		cb(ped)
	end
	return ped
end

ESX.Game.SpawnLocalPedAsync = function(ptype, model, coords,heading, cb)
	CreateThread(function()
		local model = (type(model) == 'number' and model or GetHashKey(model))
		RequestModel(model)

		while not HasModelLoaded(model) do
			Citizen.Wait(0)
		end

		local ped = CreatePed(ptype,model, coords.x, coords.y, coords.z, heading or 0, false, false)
		SetModelAsNoLongerNeeded(model)
		-- SetEntityAsMissionEntity(ped, true, false)
		if cb ~= nil then
			cb(ped)
		end
	end)
end

ESX.Game.spawnPed = function(pedModel, pedCoords, pedType)
	local model = (type(pedModel) == 'number' and pedModel or GetHashKey(pedModel))

	RequestModel(pedModel)

	while not HasModelLoaded(pedModel) do
		Citizen.Wait(0)
	end
    local vector = type(pedCoords) == "vector4" and pedCoords or type(pedCoords) == "vector3" and vector4(pedCoords, 0.0)
    pedType = pedType ~= nil and pedType or 4
	local ped = CreatePed(pedType, pedModel, vector.xyzw, true)
	SetModelAsNoLongerNeeded(pedModel)
    return ped
end
ESX.Game.SpawnPed = ESX.Game.spawnPed

ESX.inRealWorld = function()
	return InRealWorld
end

ESX.isVehicleLocked = function(vehicle)
	return GetVehicleDoorLockStatus(vehicle) ~= 1
end

ESX.registerExitPoint = function(radius,cb)
	Citizen.CreateThread(function()
		local coords = GetEntityCoords(PlayerPedId())
		while true do
			Wait(100)
			if ESX.GetDistance(coords,GetEntityCoords(PlayerPedId())) > radius then
				if cb then
					cb()
				else
					ESX.UI.Menu.CloseAll()
					lib.hideMenu()
				end
				break
			end
		end
	end)
end

function ESX.chatMessage(message, category)
	TriggerEvent('chatMessage', "[SYSTEM]", {255, 0, 0}, " " .. (message or ''), category)
end

function ESX.getItems()
	if ESX.itemLoaded then
		return ESX.items
	end
end

local getItemsTask, getItemsList = nil, {}
-- function ESX.getItem(name)
-- 	if name then
-- 		if not ESX.items[name] then
-- 			if not getItemsTask then
-- 				getItemsTask = true
-- 				SetTimeout(2500, function()
-- 					ESX.TriggerServerCallback('core:getItemsListed', function(data)
-- 						for k, v in pairs(data) do
-- 							if getItemsList[k] then
-- 								getItemsList[k].p:resolve(v)
-- 								getItemsList[k] = nil
-- 							end
-- 						end
-- 					end, getItemsList)
-- 					getItemsTask = nil
-- 				end)
-- 			end
-- 			local p = promise.new()
-- 			getItemsList[name] = p
-- 			ESX.items[name] = Citizen.Await(p)
-- 		end
-- 		if ESX.items[name] and not ESX.items[name].name then
-- 			ESX.items[name].name = name
-- 		end
-- 		return ESX.items[name]
-- 	end
-- end

function ESX.getItem(name)
	if name then
		if not ESX.items[name] and not ESX.failedItems[name] then
			local p = promise.new()
			ESX.TriggerServerCallback('core:getItem', function(data)
				if not data then
					ESX.failedItems[name] = true
				end
				p:resolve(data)
			end, name)
			ESX.items[name] = Citizen.Await(p)
		end
		if ESX.items[name] and not ESX.items[name].name then
			ESX.items[name].name = name
		end
		return ESX.items[name]
	end
end

function ESX.fetchListedItems(list)
	local getItemsList = {}
	local p = promise.new()
	for k, v in pairs(list) do
		if v and v.name and not ESX.items[v.name] and v.name ~= 'locked' and not v.ammo and not ESX.failedItems[v.name] then
			getItemsList[v.name] = true
		end
	end
	if ESX.tableLength(getItemsList) > 0 then
		ESX.TriggerServerCallback('core:getItemsListed', function(data)
			for name, v in pairs(data) do
				ESX.items[name] = v
				if ESX.items[name] and not ESX.items[name].name then
					ESX.items[name].name = name
				end
			end
			p:resolve()
		end, getItemsList)
	else
		p:resolve()
	end
	Citizen.Await(p)
end

function ESX.doesHaveJobPerm(key)
	return exports['sun-society']:doesHavePerm(key)
end

local gangPermCache = {}
function ESX.doesHaveGangPerm(key)
	if gangPermCache[key] then return gangPermCache[key] end
	local p = promise.new()
	ESX.TriggerServerCallback('gang:doesHavePerm',function(cb)
		gangPermCache[key] = cb
		p:resolve(cb)
	end, key)
	return Citizen.Await(p)
end

RegisterNetEvent('gang:clearPermCache', function()
	gangPermCache = {}
end)

function ESX.setHudState(state)
	if ESX.hudState ~= state then
		TriggerEvent('core:updateHud', state)
	end
	ESX.hudState = state
end

function ESX.getCoords()
	return GetEntityCoords(PlayerPedId())
end

function ESX.playMiniGame(second, count)
	local p = promise.new()
	exports['ps-ui']:VarHack(function(success)
		p:resolve(success)
	end, count, second)
	return Citizen.Await(p)
end

function ESX.doesVehicleHaveDriver(vehicle)
	return not IsVehicleSeatFree(vehicle, -1)
end

ESX.src = GetPlayerServerId(PlayerId())

function ESX.selectPlayerMenu(cb, range, show, showSelf)
    local drawPlayer = {}
    local coords = ESX.getCoords()
    local players = ESX.Game.GetPlayersInArea(coords, range or 4)
    local elements = {}
	local p = promise.new()
    for k, v in pairs(players) do
        local ped = GetPlayerPed(v)
        local distance = ESX.Math.Round(ESX.GetDistance(coords, GetEntityCoords(ped)), 1)
        local src = GetPlayerServerId(v)
        if (v == PlayerId() and not showSelf) or not HasEntityClearLosToEntity(PlayerPedId(), ped, 17) or not IsEntityVisible(ped) then
            players[k] = nil
        else
			if not show or show(src) then
				table.insert(elements, {
					label = distance .. 'm',
					distance = distance,
					id = v,
					ped = ped,
					src = src
				})
			end
        end
    end
    table.sort(elements, function(a, b)
        return a.distance < b.distance
    end)
    ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'search', 
	{
		title    = 'Kodam fard ro entekhab mikonid?',
		align    = 'top-left',
		elements = elements,
	},
	function(data, menu)
		menu.close()
		cb(data.current.src)
	end,
    function(data, menu)
        menu.close()
        drawPlayer = {}
    end,
    function(data, menu)
        drawPlayer = {}
        Wait(20)
        drawPlayer[data.current.ped] = true
        Citizen.CreateThread(function()
            while drawPlayer[data.current.ped] and ESX.UI.Menu.IsOpen('default', GetCurrentResourceName(), 'search') and ESX.GetDistance(GetEntityCoords(PlayerPedId()), GetEntityCoords(data.current.ped)) <= 5 do
                Wait(0)
                local coords = GetOffsetFromEntityInWorldCoords(data.current.ped, 0.0, 0.0, 0.0)
                local distance = ESX.Math.Round(ESX.GetDistance(coords, GetEntityCoords(PlayerPedId())), 1)
                DrawMarker(1, coords.x, coords.y, coords.z - 1.0, 0, 0, 0, 0, 0, 0, 0.8, 0.8, 1.5, 255, 0, 0, 50, 0, 0, 0, 0)
                ESX.Game.Utils.DrawText3D(coords, distance .. 'm', 1)
            end
            drawPlayer[data.current.ped] = nil
            if ESX.GetDistance(GetEntityCoords(PlayerPedId()), GetEntityCoords(data.current.ped)) > 5 then
                ESX.selectPlayerMenu(cb, range)
            end
        end)
    end)
    Wait(200)
    if elements[1] then
        local current = elements[1]
        drawPlayer[current.ped] = true
        Citizen.CreateThread(function()
            while drawPlayer[current.ped] and ESX.UI.Menu.IsOpen('default', GetCurrentResourceName(), 'search') and ESX.GetDistance(GetEntityCoords(PlayerPedId()), GetEntityCoords(current.ped)) <= 5 do
                Wait(0)
                local coords = GetOffsetFromEntityInWorldCoords(current.ped, 0.0, 0.0, 0.0)
                local distance = ESX.Math.Round(ESX.GetDistance(coords, GetEntityCoords(PlayerPedId())), 1)
                DrawMarker(1, coords.x, coords.y, coords.z - 1.0, 0, 0, 0, 0, 0, 0, 0.8, 0.8, 1.5, 255, 0, 0, 50, 0, 0, 0, 0)
                ESX.Game.Utils.DrawText3D(coords, distance .. 'm', 1)
            end
            drawPlayer[current.ped] = nil
            if ESX.GetDistance(GetEntityCoords(PlayerPedId()), GetEntityCoords(current.ped)) > 5 then
                ESX.selectPlayerMenu(cb, range)
            end
        end)
    end
end

function ESX.selectVehicleMenu(cb, range, show)
    local drawVehicle = {}
    local coords = ESX.getCoords()
    local vehicles = ESX.Game.GetVehiclesInArea(coords, range or 4)
    local elements = {}
	local p = promise.new()
    for k, v in pairs(vehicles) do
        local distance = ESX.Math.Round(ESX.GetDistance(coords, GetEntityCoords(v)), 1)
        local src = GetPlayerServerId(v)
        if not HasEntityClearLosToEntity(PlayerPedId(), v, 17) or not IsEntityVisible(v) then
            vehicles[k] = nil
        else
			if not show or show(src) then
				table.insert(elements, {
					label = ('%s | %sm'):format(ESX.GetPlate(v), distance),
					distance = distance,
					vehicle = v,
				})
			end
        end
    end
    table.sort(elements, function(a, b)
        return a.distance < b.distance
    end)
    ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'search',
	{
		title    = 'Kodam mashin ro entekhab mikonid?',
		align    = 'top-left',
		elements = elements,
	},
	function(data, menu)
		menu.close()
		cb(data.current.vehicle)
	end,
    function(data, menu)
        menu.close()
        drawVehicle = {}
    end,
    function(data, menu)
        drawVehicle = {}
        Wait(20)
        drawVehicle[data.current.vehicle] = true
        Citizen.CreateThread(function()
            while drawVehicle[data.current.vehicle] and ESX.UI.Menu.IsOpen('default', GetCurrentResourceName(), 'search') and ESX.GetDistance(GetEntityCoords(PlayerPedId()), GetEntityCoords(data.current.vehicle)) <= 5 do
                Wait(0)
                local coords = GetEntityCoords(data.current.vehicle)
                local distance = ESX.Math.Round(ESX.GetDistance(coords, GetEntityCoords(PlayerPedId())), 1)
                SetEntityDrawOutline(data.current.vehicle, true)
                ESX.Game.Utils.DrawText3D(coords + vec(0, 0, 1), distance .. 'm', 1)
            end
            drawVehicle[data.current.vehicle] = nil
			SetEntityDrawOutline(data.current.vehicle, false)
            if ESX.GetDistance(GetEntityCoords(PlayerPedId()), GetEntityCoords(data.current.vehicle)) > 5 then
                ESX.selectVehicleMenu(cb, range, show)
            end
        end)
    end)
    Wait(200)
    if elements[1] then
        local current = elements[1]
        drawVehicle[current.vehicle] = true
        Citizen.CreateThread(function()
            while drawVehicle[current.vehicle] and ESX.UI.Menu.IsOpen('default', GetCurrentResourceName(), 'search') and ESX.GetDistance(GetEntityCoords(PlayerPedId()), GetEntityCoords(current.vehicle)) <= 5 do
                Wait(0)
                local coords = GetEntityCoords(current.vehicle)
                local distance = ESX.Math.Round(ESX.GetDistance(coords, GetEntityCoords(PlayerPedId())), 1)
                SetEntityDrawOutline(current.vehicle, true)
                ESX.Game.Utils.DrawText3D(coords + vec(0, 0, 1), distance .. 'm', 1)
            end
            drawVehicle[current.vehicle] = nil
			SetEntityDrawOutline(current.vehicle, false)
            if ESX.GetDistance(GetEntityCoords(PlayerPedId()), GetEntityCoords(current.vehicle)) > 5 then
                ESX.selectVehicleMenu(cb, range, show)
            end
        end)
    end
end

function ESX.setVehicleFuel(vehicle, fuel)
	exports['sunset_utils']:SetFuel(vehicle, fuel)
end

function ESX.fadeScreen(duration, cb)
	DoScreenFadeOut(1000)
	Wait(1000)
	if cb then cb() end
	Wait(duration)
	Wait(1000)
	DoScreenFadeIn(1000)
end

function ESX.generateRandomCoords(coords)
	if type(coords) == 'number' then
		local _coords = GetEntityCoords(PlayerPedId())
		coords = vec(_coords.x, _coords.y, _coords.z, coords)
	end
	local pos = coords.xyz
    local radius = coords.w
    pos = vector3(pos.x + math.random(-radius,radius),pos.y + math.random(-radius,radius),pos.z)
    return pos
end

function ESX.revive()
	TriggerEvent('medic:revive')
end

ESX.doesNetIdExist = function(entity)
	local timeout = 4000
	while timeout > 0 and not NetworkDoesEntityExistWithNetworkId(entity) do
		Wait(100)
		timeout = timeout - 100
	end
	return NetworkDoesEntityExistWithNetworkId(entity)
end

function ESX.GetEntityByNetID(netid, timeout)
	local start_time = GetGameTimer()
	timeout = timeout or 3000

	local entity = NetworkGetEntityFromNetworkId(netid)
	while not DoesEntityExist(entity) and (GetGameTimer() - start_time < timeout) do
		entity = NetworkGetEntityFromNetworkId(netid)
		Wait(100)
	end
end

function ESX.DoesNetIDExist(netid, timeout)
	local start_time = GetGameTimer()
	timeout = timeout or 2500
	while not NetworkDoesNetworkIdExist(netid) and (GetGameTimer() - start_time < timeout) do Wait(100) end
	return NetworkDoesNetworkIdExist(netid)
end

function ESX.entityFaceEntity(entity1, entity2)
    local p1 = GetEntityCoords(entity1, true)
    local p2 = GetEntityCoords(entity2, true)

    local dx = p2.x - p1.x
    local dy = p2.y - p1.y

    local heading = GetHeadingFromVector_2d(dx, dy)
    SetEntityHeading( entity1, heading )
end

function ESX.registerCommand(command, cb, helper)
	RegisterCommand(command, cb)
	if helper then
		TriggerEvent('chat:addSuggestion', ('/%s'):format(command), helper.help, helper.args)
	end
end
ESX.RegisterCommand = ESX.registerCommand

ESX.getPlayerPed = function(player)
	local timeout = 4000
	while timeout > 0 and GetPlayerPed(player) == 0 do
		Wait(100)
		timeout = timeout - 100
	end
	return GetPlayerPed(player)
end

function ESX.disableKey(key, state)
	exports['essentialmode']:disablecontrol(key, state)
end


function ESX.getItemCount(name)
	local count = 0
	for k, v in pairs(ESX.PlayerData.inventory) do
		if v.name == name then
			count = v.count
		end
	end
	return count
end

function ESX.closeAll()
	ESX.UI.Menu.CloseAll()
	lib.closeAlertDialog()
	lib.hideContext()
	lib.closeInputDialog()
	lib.hideMenu()
	lib.hideTextUI()
end

function ESX.alarm(Reason, eeP)
    Reason = Reason .. ' | ' .. ESX.GetCoordsString(false)
    TriggerServerEvent('sc:adminalarm', Reason, eeP)
end

function ESX.commandGroupCheck(groups)
	local identifier = ESX.PlayerData.identifier
    if groups then
        if type(groups) == 'string' then
            if ESX.commandsGroupCategory[groups] then
                groups = ESX.commandsGroupCategory[groups]
            else
                return
            end
        end
        for k, v in pairs(groups) do
            if ESX.commandsGroup[v] and ESX.commandsGroup[v][identifier] then
                return true
            end
        end
        return ESX.commandsGroup.FULL_PERM[identifier]
    end
end

function ESX.disableFiring()
	DisablePlayerFiring(PlayerPedId(), true)
	DisableControlAction(0,24,true) -- disable attack
	DisableControlAction(0,47,true) -- disable weapon
	DisableControlAction(0,58,true) -- disable weapon
	DisableControlAction(0,263,true) -- disable melee
	DisableControlAction(0,264,true) -- disable melee
	DisableControlAction(0,257,true) -- disable melee
	DisableControlAction(0,140,true) -- disable melee
	DisableControlAction(0,141,true) -- disable melee
	DisableControlAction(0,142,true) -- disable melee
	DisableControlAction(0,143,true) -- disable melee
	DisableControlAction(0, 45, true)
	DisableControlAction(0, 69, true) -- Melee Attack 1
	DisableControlAction(0, 70, true)
	DisableControlAction(0, 92, true)
end

local antiSpam = {}
function ESX.checkCooldown(key, time)
	if antiSpam[key] then
		return false
	else
		antiSpam[key] = true
		SetTimeout(time, function()
			antiSpam[key] = nil
		end)
		return true
	end
end

function ESX.generatePlate()
	::start::
	local plate = ESX.GetRandomString(8):upper()
	local p = promise.new()
	ESX.TriggerServerCallback('vehicle:isPlateTaken', function (isPlateTaken)
		p:resolve(isPlateTaken)
	end, plate)
	local taken = Citizen.Await(p)
	if taken then
		goto start
	else
		return plate
	end
end

function ESX.getWeaponHash(...)
	return exports['sunset_utils']:getWeaponHash(...)
end

function ESX.getRealWeaponHash(...)
	return exports['sunset_utils']:getRealWeaponHash(...)
end

function ESX.getRealWeaponName(...)
	return exports['sunset_utils']:getRealWeaponName(...)
end

function ESX.notification(...)
	TriggerEvent('core:oxNotif', ...)
end

function ESX.SetVehicleNumberPlateText(vehicle, plate)
	if NetworkGetEntityIsNetworked(vehicle) then
		TriggerServerEvent('core:saveVehicle', plate, NetworkGetNetworkIdFromEntity(vehicle))
	end
	SetVehicleNumberPlateText(vehicle, plate)
end


local activeCountdowns = 0

function ESX.startCountdown(seconds, label, callback, checkShow, scale)
    Citizen.CreateThread(function()
        local index = activeCountdowns
        activeCountdowns = activeCountdowns + 1

        local endTime = GetGameTimer() + (seconds * 1000)
        local baseY = label and 0.75 or 0.70
        local offset = index * 0.05

        while GetGameTimer() < endTime and (not checkShow or checkShow()) do
            local remainingTime = math.ceil((endTime - GetGameTimer()) / 1000)
            local y = baseY + offset
            if label then
                ESX.Game.Utils.DrawText2D(('%ss(%s)'):format(remainingTime, label), 0.5, y, scale or 0.6)
            else
                ESX.Game.Utils.DrawText2D(remainingTime .. 's', 0.5, y, 1.0)
            end
            Wait(0)
        end

        activeCountdowns = activeCountdowns - 1

        if callback and (not checkShow or checkShow()) then
            callback()
        end
    end)
end


function ESX.showTextUI(message)
	lib.showTextUI(message, {
		position = 'left-center',
		style = {
			borderRadius = 5,
			backgroundColor ='#7F00FF',
			color = 'white',
		}
	})
end


function ESX.hideTextUI()
	lib.hideTextUI()
end

function ESX.getIdentifier()
	return ESX.identifier
end

function ESX.deleteNearAttachedObject()
    local objects = ESX.Game.GetObjects()
	local coords = ESX.getCoords()
	for k, object in pairs(objects) do
		local distance = #(coords - GetEntityCoords(object))
		if distance < 1 then
			if IsEntityAttachedToAnyPed(object) and IsEntityAttachedToEntity(object, PlayerPedId()) and not Entity(object).state.antiDelete then
				ESX.Game.DeleteObject(object)
			end
		end
	end
end

local emoteMenuState = 0
function ESX.emoteMenu(state)
	if state then
		emoteMenuState = emoteMenuState - 1
	else
		emoteMenuState = emoteMenuState + 1
	end
end

function ESX.isEmoteMenuActive()
	return emoteMenuState <= 0
end

function ESX.getRandomCoordInRadius(v)
    local angle = math.random() * 2 * math.pi
    local radius = v.w * math.sqrt(math.random())
    local x = v.x + radius * math.cos(angle)
    local y = v.y + radius * math.sin(angle)
    return vec(x, y, v.z)
end

function ESX.progressCircle(duration, canCancel, disableMove, anim)
	if canCancel == nil then canCancel = false end
	if disableMove == nil then disableMove = false end
	return lib.progressCircle({
		duration = duration,
		position = 'bottom',
		useWhileDead = false,
		canCancel = canCancel,
		allowFalling = true,
		allowRagdoll = true,
		disable = {
			car = disableMove,
			move = disableMove,
			combat = disableMove,
		},
		anim = anim
	})
end

function ESX.GetPedSeatIndex(ped)
    if not DoesEntityExist(ped) or not IsPedInAnyVehicle(ped, false) then
        return nil
    end

    local vehicle = GetVehiclePedIsIn(ped, false)

    for seat = -1, GetVehicleMaxNumberOfPassengers(vehicle) do
        if GetPedInVehicleSeat(vehicle, seat) == ped then
            return seat
        end
    end

    return nil
end

function ESX.doesExportExist(resource, exportName)
    local success, result = pcall(function()
        return exports[resource][exportName] ~= nil
    end)
    return success and result
end

function ESX.isPrime()
	while not ESX.doesExportExist('sun-prime', 'isPrimeActive') do Wait(100) end
	return exports['sun-prime']:isPrimeActive()
end

function ESX.getPrimePoint()
	while not ESX.doesExportExist('sun-prime', 'getPrimePoint') do Wait(100) end
	return exports['sun-prime']:getPrimePoint()
end

function ESX.isBusy()
	return exports['sun-jobs']:isBusyMedic()
end

function ESX.playScrambler(type)
	local p = promise.new()
	exports['ps-ui']:Scrambler(function(success)
		p:resolve(success)
	end, type, 60, 0)
	return Citizen.Await(p)
end

function ESX.PlayEmote(...)
	exports['sun-animmenu']:PlayEmote(...)
end