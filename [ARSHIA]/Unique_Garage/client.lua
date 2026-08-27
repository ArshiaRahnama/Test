ESX, LastCamera, currentVeh = nil, nil, nil
PlayerData = nil
local inGarage = 0
HZ = Citizen

function SafeNotify(msg)
    local ok = pcall(function() ESX.ShowNotification(msg) end)
    if not ok then
        SetNotificationTextEntry("STRING")
        AddTextComponentString(msg)
        DrawNotification(false, false)
    end
end

-- FIX: the server used to fire 'esx_Notification:SendNotification', an event
-- this resource never registered a handler for, so "You Don't Have Money"
-- and similar server-side messages were silently swallowed on the client.
-- This gives the server a reliable way to talk to SafeNotify.
RegisterNetEvent('Unique_Garage:Notify', function(msg)
    SafeNotify(msg)
end)

function ToStoredNum(v)
    if type(v) == 'boolean' then
        return v and 1 or 0
    end
    return tonumber(v) or 0
end

if Customize.ESX == 'ESX' then
    HZ.CreateThread(function() while not ESX do TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end) PlayerData = ESX.GetPlayerData() HZ.Wait(10) end end)


    RegisterNUICallback('SpawnVehicle', function(data)
        -- FIX: this used to json.decode(data.Table.vehicle) straight into the
        -- spawn call with no validation. If `vehicle` was nil/malformed
        -- (bad DB row, empty selection, stale NUI state) json.decode either
        -- errored (killing the whole callback silently client-side, no
        -- console line) or returned a table with no `.model`, so
        -- HZSpawnVehicle got called with a nil model and bailed out with
        -- nothing on screen. Now we validate first and always tell the
        -- player + print to console instead of doing nothing.
        if not data or not data.Table or not data.Table.vehicle then
            SafeNotify('~r~Khataye Spawn: Etelaate Mashin Peyda Nashod. (console ra check konid)')
            print('^1[Unique_Garage] SpawnVehicle: data.Table.vehicle is missing - NUI sent: ' .. tostring(json.encode(data)) .. '^0')
            return
        end

        local ok, vehData = pcall(json.decode, data.Table.vehicle)
        if not ok or type(vehData) ~= 'table' or not vehData.model then
            SafeNotify('~r~Khataye Spawn: Etelaate Mashin Kharab Ast. (console ra check konid)')
            print('^1[Unique_Garage] SpawnVehicle: failed to decode vehicle JSON for plate ' .. tostring(data.Table.plate) .. ' -> ' .. tostring(data.Table.vehicle) .. '^0')
            return
        end

        -- FIX (per request): spawning a vehicle you already own from the
        -- garage should be free -- it was charging Customize.GaragesPrice
        -- via the 'isPrice' server callback on every spawn. That check now
        -- only runs for job/impound garages where a price is actually
        -- configured (Customize.JobGaragesPrice / ImpoundGaragesPrice);
        -- normal garage spawns skip straight to spawning, no charge.
        if (tonumber(data.Price) or 0) > 0 then
            ESX.TriggerServerCallback('isPrice', function(istrue)
                if istrue then
                    HZSpawnVehicle(vehData.model, function(Veh)
                        SetNetworkIdAlwaysExistsForPlayer(NetworkGetNetworkIdFromEntity(Veh), PlayerPedId(), true)
                        ESX.Game.SetVehicleProperties(Veh, vehData)
                        SetVehicleNumberPlateText(Veh, data.Table.plate)
                        SetEntityHeading(Veh, LastSpawnPos.w)
                        Customize.SetVehFuel(Veh, data.Table.fuel)
                        SetVehicleEngineHealth(Veh, (tonumber(data.Table.engine) or 1000.0) + 0.0)
                        SetVehicleBodyHealth(Veh, (tonumber(data.Table.body) or 1000.0) + 0.0)
                        SetEntityAsMissionEntity(Veh, true, true)
                        TaskWarpPedIntoVehicle(PlayerPedId(), Veh, -1)
                        SetVehicleEngineOn(Veh, true, true)
                        AttachOwnCarBlip(Veh)
                        SendReactMessage('Close')
                        TriggerServerEvent('SetVehState0', 0, data.Table.plate)
						Wait(100)
						TriggerServerEvent("CarLock:ToggleKey", true, data.Table.plate)
                    end, LastSpawnPos, true)
                end
            end, data.Price)
        else
            HZSpawnVehicle(vehData.model, function(Veh)
                SetNetworkIdAlwaysExistsForPlayer(NetworkGetNetworkIdFromEntity(Veh), PlayerPedId(), true)
                ESX.Game.SetVehicleProperties(Veh, vehData)
                SetVehicleNumberPlateText(Veh, data.Table.plate)
                SetEntityHeading(Veh, LastSpawnPos.w)
                Customize.SetVehFuel(Veh, data.Table.fuel)
                SetVehicleEngineHealth(Veh, (tonumber(data.Table.engine) or 1000.0) + 0.0)
                SetVehicleBodyHealth(Veh, (tonumber(data.Table.body) or 1000.0) + 0.0)
                SetEntityAsMissionEntity(Veh, true, true)
                TaskWarpPedIntoVehicle(PlayerPedId(), Veh, -1)
                SetVehicleEngineOn(Veh, true, true)
                AttachOwnCarBlip(Veh)
                SendReactMessage('Close')
                TriggerServerEvent('SetVehState0', 0, data.Table.plate)
				Wait(100)
				TriggerServerEvent("CarLock:ToggleKey", true, data.Table.plate)
            end, LastSpawnPos, true)
        end
    end)

    RegisterNUICallback('VehicleInfo', function(data, cb)
        local model = json.decode(data.data.vehicle).model
        RequestModel(model)
        while not HasModelLoaded(model) do Wait(7) end
        currentVeh = CreateVehicle(model, LastCamera.vehSpawn.x, LastCamera.vehSpawn.y, LastCamera.vehSpawn.z, LastCamera.vehSpawn.w, false, true)
        SetVehicleEngineOn(currentVeh, true, true, false)
        ESX.Game.SetVehicleProperties(currentVeh, json.decode(data.data.vehicle))
        Customize.SetVehFuel(currentVeh, (tonumber(data.data.fuel) or 100.0) + 0.0)
        SetVehicleEngineHealth(currentVeh, (tonumber(data.data.engine) or 1000.0) + 0.0)
        SetVehicleBodyHealth(currentVeh, (tonumber(data.data.body) or 1000.0) + 0.0)
        cb({
            Fuel = math.floor(Customize.GetVehFuel(currentVeh) + 0.5),
            Speed = GetVehicleEstimatedMaxSpeed(currentVeh),
            Traction = GetVehicleMaxTraction(currentVeh),
            Acceleration = GetVehicleAcceleration(currentVeh)
        })
    end)

elseif Customize.ESX == 'QBCore' then
    if Customize.ESX == "OLDQBCore" then while ESX == nil do TriggerEvent('QBCore:GetObject', function(obj) ESX = obj end) HZ.Wait(4) end else ESX = exports['qb-core']:GetCoreObject() end

    RegisterNUICallback('SpawnVehicle', function(data)
        -- FIX (per request): same free-spawn logic as the ESX branch above --
        -- only charge when a price is actually configured (job/impound
        -- garages), otherwise spawn directly with no charge.
        if (tonumber(data.Price) or 0) > 0 then
            ESX.Functions.TriggerCallback('isPrice', function(istrue)
                if istrue then
                    HZSpawnVehicle(data.Table.vehicle, function(Veh)
                        SetNetworkIdAlwaysExistsForPlayer(NetworkGetNetworkIdFromEntity(Veh), PlayerPedId(), true)
                        SetVehicleProperties(json.decode(data.Table.mods), Veh)
                        SetVehicleNumberPlateText(Veh, data.Table.plate)
                        SetEntityHeading(Veh, LastSpawnPos.w)
                        Customize.SetVehFuel(Veh, data.Table.fuel)
                        SetEntityAsMissionEntity(Veh, true, true)
                        TaskWarpPedIntoVehicle(PlayerPedId(), Veh, -1)
                        SetVehicleEngineOn(Veh, true, true)
                        AttachOwnCarBlip(Veh)
                        SendReactMessage('Close')
                        TriggerServerEvent('SetVehState0', 0, data.Table.plate)
                    end, LastSpawnPos, true)
                end
            end, data.Price)
        else
            HZSpawnVehicle(data.Table.vehicle, function(Veh)
                SetNetworkIdAlwaysExistsForPlayer(NetworkGetNetworkIdFromEntity(Veh), PlayerPedId(), true)
                SetVehicleProperties(json.decode(data.Table.mods), Veh)
                SetVehicleNumberPlateText(Veh, data.Table.plate)
                SetEntityHeading(Veh, LastSpawnPos.w)
                Customize.SetVehFuel(Veh, data.Table.fuel)
                SetEntityAsMissionEntity(Veh, true, true)
                TaskWarpPedIntoVehicle(PlayerPedId(), Veh, -1)
                SetVehicleEngineOn(Veh, true, true)
                AttachOwnCarBlip(Veh)
                SendReactMessage('Close')
                TriggerServerEvent('SetVehState0', 0, data.Table.plate)
            end, LastSpawnPos, true)
        end
    end)

    RegisterNUICallback('VehicleInfo', function(data, cb)
        local model = GetHashKey(data.data.vehicle)
        RequestModel(model)
        while not HasModelLoaded(model) do Wait(7) end
        currentVeh = CreateVehicle(model, LastCamera.vehSpawn.x, LastCamera.vehSpawn.y, LastCamera.vehSpawn.z, LastCamera.vehSpawn.w, false, true)
        SetVehicleEngineOn(currentVeh, true, true, false)
        SetVehicleProperties(json.decode(data.data.mods), currentVeh)
        cb({
            Fuel = Customize.GetVehFuel(currentVeh),
            Speed = GetVehicleEstimatedMaxSpeed(currentVeh),
            Traction = GetVehicleMaxTraction(currentVeh),
            Acceleration = GetVehicleAcceleration(currentVeh)
        })
    end)
end

RegisterNetEvent('ImpoundVehicle', function(vehicles)
	local vehicle
	if vehicles then
		vehicle = vehicles
	else
		vehicle = GetClosestVehicle()
	end
    local bodyDamage = math.ceil(GetVehicleBodyHealth(vehicle))
    local engineDamage = math.ceil(GetVehicleEngineHealth(vehicle))
    local totalFuel = Customize.GetVehFuel(vehicle)
    if vehicle ~= 0 and vehicle then
        local ped = PlayerPedId()
        local pos = GetEntityCoords(ped)
        local vehpos = GetEntityCoords(vehicle)


		if (not IsPedAPlayer(GetPedInVehicleSeat(vehicle, -1))) then
            local plate = GetPlate(vehicle)
            TriggerServerEvent("SetVehImpound", plate, bodyDamage, engineDamage, totalFuel)
            HZDeleteVehicle(vehicle)
        end
    end
end)

RegisterNetEvent('Unique_Garage:DeleteAllVehicle')
AddEventHandler('Unique_Garage:DeleteAllVehicle', function()
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
		TriggerEvent("ImpoundVehicle", entity)
		if (DoesEntityExist(entity)) then
			DeleteEntity(entity)
		end
	end
end)

function IsAnyPedInVehicle(veh)
	return (GetVehicleNumberOfPassengers(veh)+(IsVehicleSeatFree(veh,-1) and 0 or 1))>0
end

RegisterNetEvent("Unique_Garage:DeleteAllVehicle")
AddEventHandler("Unique_Garage:DeleteAllVehicle", function()
    for vehicle in EnumerateVehicles() do
        if (not IsPedAPlayer(GetPedInVehicleSeat(vehicle, -1))) then
            SetVehicleHasBeenOwnedByPlayer(vehicle, false)
            SetEntityAsMissionEntity(vehicle, false, false)
			TriggerEvent("ImpoundVehicle", vehicle)
            ESX.Game.DeleteVehicle(vehicle)
            DeleteVehicle(vehicle)
            if (DoesEntityExist(vehicle)) then
                DeleteVehicle(vehicle)
            end
        end
    end
end)

local entityEnumerator = {
    __gc = function(enum)
    if enum.destructor and enum.handle then
      enum.destructor(enum.handle)
    end
    enum.destructor = nil
    enum.handle = nil
  end
}

local function EnumerateEntities(initFunc, moveFunc, disposeFunc)
	return coroutine.wrap(function()
		local iter, id = initFunc()
		if not id or id == 0 then
		  disposeFunc(iter)
		  return
		end

		local enum = {handle = iter, destructor = disposeFunc}
		setmetatable(enum, entityEnumerator)

		local next = true
		repeat
		  coroutine.yield(id)
		  next, id = moveFunc(iter)
		until not next

		enum.destructor, enum.handle = nil, nil
		disposeFunc(iter)
	end)
end

function EnumerateObjects()
	return EnumerateEntities(FindFirstObject, FindNextObject, EndFindObject)
end

function EnumeratePeds()
	return EnumerateEntities(FindFirstPed, FindNextPed, EndFindPed)
end

function EnumerateVehicles()
	return EnumerateEntities(FindFirstVehicle, FindNextVehicle, EndFindVehicle)
end

function EnumeratePickups()
	return EnumerateEntities(FindFirstPickup, FindNextPickup, EndFindPickup)
end

RegisterNetEvent('esx_SetJobPlayers')
AddEventHandler('esx_SetJobPlayers', function(job)
	PlayerData.job = job
end)

HZ.CreateThread(function()
    HZ.Wait(2000)

    if Customize.ESX == 'ESX' then PlayerData = ESX.GetPlayerData() end
    while ESX ~= nil do
        local Callback = nil
        if Customize.ESX == 'ESX' then Callback = ESX.TriggerServerCallback else Callback = ESX.Functions.TriggerCallback end
        local Sleep = 2000
        local PlayerPed = PlayerPedId()
        local PlayerCoord = GetEntityCoords(PlayerPed)
        local InVeh = GetVehiclePedIsIn(PlayerPed)
        for index_, esc in pairs(Customize.Garages) do
            local NPCDistance = #(PlayerCoord - esc.Npc.Pos)
            local VehPutDistance = #(PlayerCoord - esc.VehPutPos)
            if NPCDistance <= 5.0 then
                Sleep = 5
                Draw3DText(esc.Npc.Pos.x, esc.Npc.Pos.y, esc.Npc.Pos.z + 0.98,"GARAGE")
            end
            if VehPutDistance <= 12.0 then
                Sleep = 5
                DrawMarker(2, esc.VehPutPos.x, esc.VehPutPos.y, esc.VehPutPos.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.3, 0.2, 0.15, 255, 255, 255, 100, false, false, false, true, false, false, false)
                if VehPutDistance <= 4.0 and IsPedInAnyVehicle(PlayerPed, false) and GetPedInVehicleSeat(InVeh, -1) == PlayerPed then
                    ShowHelpNotification("~INPUT_CONTEXT~ Baraye Park Kardan Mashin")
                end
                if VehPutDistance <= 4.0 and IsControlJustReleased(0, 38) and IsPedInAnyVehicle(PlayerPed,false)  then
                    if GetVehicleNumberOfPassengers(InVeh) == 0 then
                        local Plate = GetPlate(InVeh)
                        Callback('IsVehOwned', function(owned)
                            if owned then
                                local bodyDamage = math.ceil(GetVehicleBodyHealth(InVeh))
                                local engineDamage = math.ceil(GetVehicleEngineHealth(InVeh))
                                local totalFuel = Customize.GetVehFuel(InVeh)
								vehicleProps = ESX.Game.GetVehicleProperties(InVeh)
                                TriggerServerEvent('SetVehState', 1, Plate, {
                                    fuel = totalFuel,
                                    engine = engineDamage,
                                    body = bodyDamage,
									props = vehicleProps
                                }, '')
                                Wait(200)
                                for i = -1, 5, 1 do
                                    local seat = GetPedInVehicleSeat(InVeh, i)
                                    if seat then
                                        TaskLeaveVehicle(seat, InVeh, 0)
                                    end
                                end
                                SetVehicleDoorsLocked(InVeh)
                                Wait(1500)
                                HZDeleteVehicle(InVeh)
                            end
                        end, Plate, '')
                    end
                end
            end
        end

        for index, esc in pairs(Customize.JobGarages) do
            if PlayerData ~= nil then

                if PlayerData.job.name == esc.PlayerJob then
                    local NPCDistance = #(PlayerCoord - esc.Npc.Pos)
                    local VehPutDistance = #(PlayerCoord - esc.VehPutPos)
                    if NPCDistance <= 5.0 then
                        Sleep = 5
                        Draw3DText(esc.Npc.Pos.x, esc.Npc.Pos.y, esc.Npc.Pos.z + 0.98,"[E] JOB GARAGE")
                    end
                    if VehPutDistance <= 12.0 then
                        Sleep = 5
                        DrawMarker(2, esc.VehPutPos.x, esc.VehPutPos.y, esc.VehPutPos.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.3, 0.2, 0.15, 255, 255, 255, 100, false, false, false, true, false, false, false)
                        if VehPutDistance <= 4.0 and IsPedInAnyVehicle(PlayerPed, false) and GetPedInVehicleSeat(InVeh, -1) == PlayerPed then
                            ShowHelpNotification("~INPUT_CONTEXT~ Baraye Park Kardan Mashin")
                        end
                        if VehPutDistance <= 4.0 and IsControlJustReleased(0, 38) then
                            Draw3DText(esc.Npc.Pos.x, esc.Npc.Pos.y, esc.Npc.Pos.z + 0.98,"[E] In Garage")
                            if GetVehicleNumberOfPassengers(InVeh) == 0 then
                                local Plate = GetPlate(InVeh)
                                local model = GetEntityModel(InVeh)
                                local displaytext = GetDisplayNameFromVehicleModel(model)
                                local name = GetLabelText(displaytext)
                                for index, veh in pairs(esc.Vehicles) do
                                    if string.gsub(displaytext, "%s+", ""):lower() == veh then
                                        Callback('IsVehOwned', function(owned)
                                            if owned then
                                                local bodyDamage = math.ceil(GetVehicleBodyHealth(InVeh))
                                                local engineDamage = math.ceil(GetVehicleEngineHealth(InVeh))
                                                local totalFuel = Customize.GetVehFuel(InVeh)
												vehicleProps = ESX.Game.GetVehicleProperties(InVeh)
                                                TriggerServerEvent('SetVehState', 1, Plate, {
                                                    fuel = totalFuel,
                                                    engine = engineDamage,
                                                    body = bodyDamage,
													props = vehicleProps
                                                }, 'Job', esc.PlayerJob)
                                                HZ.Wait(200)
                                                for i = -1, 5, 1 do
                                                    local seat = GetPedInVehicleSeat(InVeh, i)
                                                    if seat then TaskLeaveVehicle(seat, InVeh, 0) end
                                                end
                                                SetVehicleDoorsLocked(InVeh)
                                                HZ.Wait(1500)
                                                HZDeleteVehicle(InVeh)
                                            end
                                        end, Plate, 'Job', esc.PlayerJob)
                                    end
                                end
                            end

                        end
                    end
                end
            end
        end
        for index, esc in pairs(Customize.ImpoundGarages) do
            local NPCDistance = #(PlayerCoord - esc.Npc.Pos)
            if NPCDistance <= 5.0 then
                Sleep = 5
                Draw3DText(esc.Npc.Pos.x, esc.Npc.Pos.y, esc.Npc.Pos.z + 0.98,"IMPOUND")
            end
        end
        HZ.Wait(Sleep)
    end
end)

RegisterNetEvent("OpenGarage", function() OpenMenuG("garage") end)
RegisterNetEvent("OpenJob", function() OpenMenuG("job") end)
RegisterNetEvent("OpenImpound", function() OpenMenuG() end)

OpenMenuG = function(type)
	local PlayerPed = PlayerPedId()
	local PlayerCoord = GetEntityCoords(PlayerPed)
	local InVeh = GetVehiclePedIsIn(PlayerPed)
	local Callback = ESX.TriggerServerCallback
	if type == "garage" then
		for index_, esc in pairs(Customize.Garages) do
			local NPCDistance = #(PlayerCoord - esc.Npc.Pos)
			local VehPutDistance = #(PlayerCoord - esc.VehPutPos)
			if NPCDistance <= 5.0 then
				Callback('GetVehicles', function(data)
					if data ~= nil then
						inGarage = 0
						local newData = {}
						for index, vh in pairs(data) do
							veh = nil

							veh = json.decode(vh.vehicle).model
							vh.stored = ToStoredNum(vh.stored)
							vh.engine = tonumber(vh.engine) or 1000
							vh.fuel = tonumber(vh.fuel) or 100
							vh.body = tonumber(vh.body) or 1000
							local vehClass = GetVehicleClassFromName(veh)
							if vh.stored ~= 2 then
								local displaytext = string.gsub(GetDisplayNameFromVehicleModel(veh), "%s+", ""):lower();
								vh["VehModel"] = displaytext
								vh["VehText"] = GetLabelText(displaytext)

								if esc.Type == 'car' then
									if vehClass ~= 14 and vehClass ~= 15 and vehClass ~= 16 then
										NewTable(newData, vh)
									end
								end
								if esc.Type == 'air' then
									if vehClass == 15 or vehClass == 16 then
										NewTable(newData, vh)
									end
								end
								if esc.Type == 'sea' then
									if vehClass == 14 then
										NewTable(newData, vh)
									end
								end
							end
						end
						LastCamera = esc.Camera
						LastSpawnPos = esc.VehSpawnPos
						Camera()

						SendReactMessage('setOpen', { setVeh = newData, setName = esc.UIName, inGarage = inGarage, Price = Customize.GaragesPrice })
						SetNuiFocus(true, true)
					else
						SafeNotify("Shoma Hich Mashini Nadarid!")
					end
				end, "")
			end
		end
	elseif type == "job" then
		for index, esc in pairs(Customize.JobGarages) do
			if PlayerData ~= nil then
				if PlayerData.job.name == esc.PlayerJob then
					local NPCDistance = #(PlayerCoord - esc.Npc.Pos)
					local VehPutDistance = #(PlayerCoord - esc.VehPutPos)
					if NPCDistance <= 5.0 then
						Callback('GetVehicles', function(data)
							if data ~= nil then
								inGarage = 0
								local newData = {}
								for index , vh in pairs(data) do
									veh = nil
									veh = json.decode(vh.vehicle).model
									vh.stored = ToStoredNum(vh.stored)
									vh.engine = tonumber(vh.engine) or 1000
									vh.fuel = tonumber(vh.fuel) or 100
									vh.body = tonumber(vh.body) or 1000
									local displaytext = string.gsub(GetDisplayNameFromVehicleModel(veh), "%s+", ""):lower();
									vh["VehModel"] = displaytext
									vh["VehText"] = GetLabelText(displaytext)
									if esc.Type == 'car' then
										if vehClass ~= 14 and vehClass ~= 15 and vehClass ~= 16 then
											NewTable(newData, vh)
										end
									end
									if esc.Type == 'air' then
										if vehClass == 15 or vehClass == 16 then
											NewTable(newData, vh)
										end
									end
									if esc.Type == 'sea' then
										if vehClass == 14 then
											NewTable(newData, vh)
										end
									end
								end
								LastCamera = esc.Camera
								LastSpawnPos = esc.VehSpawnPos
								Camera()
								SendReactMessage('setOpen', { setVeh = data, setName = esc.UIName, inGarage = inGarage, Price = Customize.JobGaragesPrice })
								SetNuiFocus(true, true)
							else
								SafeNotify("Shoma Hich Mashini Nadarid!")
							end
						end, "Job", esc.PlayerJob)
					end
				end
			end
		end
	else
		for index, esc in pairs(Customize.ImpoundGarages) do
			local NPCDistance = #(PlayerCoord - esc.Npc.Pos)
			if NPCDistance <= 5.0 then
				Callback('GetVehicles', function(data)
					if data ~= nil then
						inGarage = 0
						local newData = {}
						for index, vh in pairs(data) do
							veh = nil
							veh = json.decode(vh.vehicle).model
							vh.stored = ToStoredNum(vh.stored)
							vh.engine = tonumber(vh.engine) or 1000
							vh.fuel = tonumber(vh.fuel) or 100
							vh.body = tonumber(vh.body) or 1000
							local vehClass = GetVehicleClassFromName(veh)
							if vh.stored == 2 then
								local displaytext = string.gsub(GetDisplayNameFromVehicleModel(veh), "%s+", ""):lower();
								vh["VehModel"] = displaytext
								vh["VehText"] = GetLabelText(displaytext)
								if esc.Type == 'car' then
									if vehClass ~= 14 and vehClass ~= 15 and vehClass ~= 16 then
										NewTable(newData, vh)
									end
								end
								if esc.Type == 'air' then
									if vehClass == 15 or vehClass == 16 then
										NewTable(newData, vh)
									end
								end
								if esc.Type == 'sea' then
									if vehClass == 14 then
										NewTable(newData, vh)
									end
								end
							end
						end
						LastCamera = esc.Camera
						LastSpawnPos = esc.VehSpawnPos
						Camera()
						SendReactMessage('setOpen', { setVeh = newData, setName = esc.UIName, inGarage = inGarage, Price = Customize.ImpoundGaragesPrice })
						SetNuiFocus(true, true)
					else
						SafeNotify("Shoma Hich Mashini Dar Impound Nadarid!")
					end
				end, "Impound")
			end
		end
	end
end

HZ.CreateThread(function()
    for index, esc in pairs(Customize.Garages) do NPCLoad(esc) MapBlip(esc) end
    for index, esc in pairs(Customize.JobGarages) do NPCLoad(esc) MapBlip(esc) end
    for index, esc in pairs(Customize.ImpoundGarages) do NPCLoad(esc) MapBlip(esc) end
end)

local GarageZoneRadius = 5.0

HZ.CreateThread(function()
    for index, esc in pairs(Customize.Garages) do
        exports.ox_target:addSphereZone({
            coords = esc.Npc.Pos,
            radius = GarageZoneRadius,
            debug = false,
            drawSprite = true,
            options = {
                {
                    name = 'unique_garage_open_' .. tostring(index),
                    icon = 'fa-solid fa-square-parking fa-beat',
                    label = esc.UIName or 'Garage',
                    onSelect = function()
                        OpenMenuG("garage")
                    end,
                }
            }
        })
    end

    for index, esc in pairs(Customize.JobGarages) do
        exports.ox_target:addSphereZone({
            coords = esc.Npc.Pos,
            radius = GarageZoneRadius,
            debug = false,
            drawSprite = true,
            options = {
                {
                    name = 'unique_garage_job_open_' .. tostring(index),
                    icon = 'fa-solid fa-square-parking fa-beat',
                    label = (esc.UIName or 'Job Garage'),



                    canInteract = function()
                        return PlayerData ~= nil and PlayerData.job ~= nil and PlayerData.job.name == esc.PlayerJob
                    end,
                    onSelect = function()
                        OpenMenuG("job")
                    end,
                }
            }
        })
    end

    for index, esc in pairs(Customize.ImpoundGarages) do
        exports.ox_target:addSphereZone({
            coords = esc.Npc.Pos,
            radius = GarageZoneRadius,
            debug = false,
            drawSprite = true,
            options = {
                {
                    name = 'unique_garage_impound_open_' .. tostring(index),
                    icon = 'fa-solid fa-square-parking fa-beat',
                    label = esc.UIName or 'Impound',
                    onSelect = function()
                        OpenMenuG()
                    end,
                }
            }
        })
    end
end)

function NPCLoad(esc)
    RequestModel(esc.Npc.Hash)
    while not HasModelLoaded(esc.Npc.Hash) do Wait(1) end
    local NpcPed =  CreatePed(4, esc.Npc.Hash, esc.Npc.Pos.x, esc.Npc.Pos.y, esc.Npc.Pos.z-1, 3374176, false, true)
    SetEntityHeading(NpcPed, esc.Npc.Heading)
    FreezeEntityPosition(NpcPed, true)
    SetEntityInvincible(NpcPed, true)
    SetBlockingOfNonTemporaryEvents(NpcPed, true)
end

function MapBlip(esc)
    local blip = AddBlipForCoord(esc.Blips.Position)
    SetBlipSprite(blip, esc.Blips.Sprite)
    SetBlipDisplay(blip, esc.Blips.Display)
    SetBlipScale(blip, 0.7)
    SetBlipColour(blip, esc.Blips.Color)
    SetBlipAsShortRange(blip, true)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString(esc.Blips.Label)
    EndTextCommandSetBlipName(blip)
end

function ShowHelpNotification(text)
    BeginTextCommandDisplayHelp("STRING")
    AddTextComponentSubstringPlayerName(text)
    EndTextCommandDisplayHelp(0, false, false, -1)
end

function Draw3DText(x, y, z, text)
	local onScreen, _x, _y = World3dToScreen2d(x, y, z)
    local px,py,pz=table.unpack(GetGameplayCamCoords())
	if onScreen then
		SetTextScale(0.35, 0.35)
		SetTextFont(4)
		SetTextProportional(1)
		SetTextColour(255, 255, 255, 215)
		SetTextDropShadow(0, 0, 0, 55)
		SetTextEdge(0, 0, 0, 150)
		SetTextDropShadow()
		SetTextOutline()
		SetTextEntry("STRING")
		SetTextCentre(1)
		AddTextComponentString(text)
		DrawText(_x,_y)
	end
end

RegisterNUICallback('BackPage', function()
    HZDeleteVehicle(currentVeh)
end)

RegisterNUICallback('Close', function()
    if currentVeh ~= nil then HZDeleteVehicle(currentVeh) end
    SetNuiFocus(false, false)
    DestroyAllCams(true)
    RenderScriptCams(false, true, 1700, true, false, false)
    SetFocusEntity(GetPlayerPed(PlayerId()))
    LastCamera = nil
    currentVeh = nil
end)

function NewTable(newData, vh)
    table.insert(newData, vh)
    if vh.stored == 1 then
        inGarage = inGarage + 1
    end
end

function Camera()
    local cam = CreateCameraWithParams('DEFAULT_SCRIPTED_CAMERA', LastCamera.location.posX, LastCamera.location.posY, LastCamera.location.posZ, LastCamera.location.rotX, LastCamera.location.rotY, LastCamera.location.rotZ, LastCamera.location.fov, false, 2)
    SetCamActive(cam, true)
    RenderScriptCams(true, true, 2000, true, false, false)
    SetFocusPosAndVel(LastCamera.location.posX, LastCamera.location.posY, LastCamera.location.posZ, 0.0, 0.0, 0.0)
end

RegisterNUICallback("rotateright", function(data)
    SetEntityHeading(currentVeh, GetEntityHeading(currentVeh) - 2)
end)

RegisterNUICallback("rotateleft", function()
    SetEntityHeading(currentVeh, GetEntityHeading(currentVeh) + 2)
end)

function SendReactMessage(action, data) SendNUIMessage({ action = action, data = data }) end

function SetVehicleProperties(mds,vh)
    if mds ~= nil then
        local colorPrimary, colorSecondary = GetVehicleColours(vh)
        local pearlescentColor, wheelColor = GetVehicleExtraColours(vh)
        SetVehicleModKit(vh, 0)
        if mds.plate then SetVehicleNumberPlateText(vh, mds.plate) end
        if mds.plateIndex then SetVehicleNumberPlateTextIndex(vh, mds.plateIndex) end
        if mds.color1 then if type(mds.color1) == "number" then SetVehicleColours(vh, mds.color1, colorSecondary) else SetVehicleCustomPrimaryColour(vh, mds.color1[1], mds.color1[2], mds.color1[3]) end end
        if mds.color2 then if type(mds.color2) == "number" then SetVehicleColours(vh, mds.color1 or colorPrimary, mds.color2) else SetVehicleCustomSecondaryColour(vh, mds.color2[1], mds.color2[2], mds.color2[3]) end end
        if mds.pearlescentColor then SetVehicleExtraColours(vh, mds.pearlescentColor, wheelColor) end
        if mds.interiorColor then SetVehicleInteriorColor(vh, mds.interiorColor) end
        if mds.dashboardColor then SetVehicleDashboardColour(vh, mds.dashboardColor) end
        if mds.wheelColor then SetVehicleExtraColours(vh, mds.pearlescentColor or pearlescentColor, mds.wheelColor) end
        if mds.wheels then SetVehicleWheelType(vh, mds.wheels) end
        if mds.windowTint then SetVehicleWindowTint(vh, mds.windowTint) end
        if mds.neonEnabled then SetVehicleNeonLightEnabled(vh, 0, mds.neonEnabled[1]) SetVehicleNeonLightEnabled(vh, 1, mds.neonEnabled[2]) SetVehicleNeonLightEnabled(vh, 2, mds.neonEnabled[3]) SetVehicleNeonLightEnabled(vh, 3, mds.neonEnabled[4]) end
        if mds.extras then for id, enabled in pairs(mds.extras) do if enabled then SetVehicleExtra(vh, tonumber(id), 0) else SetVehicleExtra(vh, tonumber(id), 1) end end end
        if mds.neonColor then SetVehicleNeonLightsColour(vh, mds.neonColor[1], mds.neonColor[2], mds.neonColor[3]) end
        if mds.modSmokeEnabled then ToggleVehicleMod(vh, 20, true) end
        if mds.tyreSmokeColor then SetVehicleTyreSmokeColor(vh, mds.tyreSmokeColor[1], mds.tyreSmokeColor[2], mds.tyreSmokeColor[3]) end
        if mds.modSpoilers then SetVehicleMod(vh, 0, mds.modSpoilers, false) end
        if mds.modFrontBumper then SetVehicleMod(vh, 1, mds.modFrontBumper, false) end
        if mds.modRearBumper then SetVehicleMod(vh, 2, mds.modRearBumper, false) end
        if mds.modSideSkirt then SetVehicleMod(vh, 3, mds.modSideSkirt, false) end
        if mds.modExhaust then SetVehicleMod(vh, 4, mds.modExhaust, false) end
        if mds.modFrame then SetVehicleMod(vh, 5, mds.modFrame, false) end
        if mds.modGrille then SetVehicleMod(vh, 6, mds.modGrille, false) end
        if mds.modHood then SetVehicleMod(vh, 7, mds.modHood, false) end
        if mds.modFender then SetVehicleMod(vh, 8, mds.modFender, false) end
        if mds.modRightFender then SetVehicleMod(vh, 9, mds.modRightFender, false) end
        if mds.modRoof then SetVehicleMod(vh, 10, mds.modRoof, false) end
        if mds.modEngine then SetVehicleMod(vh, 11, mds.modEngine, false) end
        if mds.modBrakes then SetVehicleMod(vh, 12, mds.modBrakes, false) end
        if mds.modTransmission then SetVehicleMod(vh, 13, mds.modTransmission, false) end
        if mds.modHorns then SetVehicleMod(vh, 14, mds.modHorns, false) end
        if mds.modSuspension then SetVehicleMod(vh, 15, mds.modSuspension, false) end
        if mds.modArmor then SetVehicleMod(vh, 16, mds.modArmor, false) end
        if mds.modTurbo then ToggleVehicleMod(vh, 18, mds.modTurbo) end
        if mds.modXenon then ToggleVehicleMod(vh, 22, mds.modXenon) end
        if mds.xenonColor then SetVehicleXenonLightsColor(vh, mds.xenonColor) end
        if mds.modFrontWheels then SetVehicleMod(vh, 23, mds.modFrontWheels, false) end
        if mds.modBackWheels then SetVehicleMod(vh, 24, mds.modBackWheels, false) end
        if mds.modCustomTiresF then SetVehicleMod(vh, 23, mds.modFrontWheels, mds.modCustomTiresF) end
        if mds.modCustomTiresR then SetVehicleMod(vh, 24, mds.modBackWheels, mds.modCustomTiresR) end
        if mds.modPlateHolder then SetVehicleMod(vh, 25, mds.modPlateHolder, false) end
        if mds.modVanityPlate then SetVehicleMod(vh, 26, mds.modVanityPlate, false) end
        if mds.modTrimA then SetVehicleMod(vh, 27, mds.modTrimA, false) end
        if mds.modOrnaments then SetVehicleMod(vh, 28, mds.modOrnaments, false) end
        if mds.modDashboard then SetVehicleMod(vh, 29, mds.modDashboard, false) end
        if mds.modDial then SetVehicleMod(vh, 30, mds.modDial, false) end
        if mds.modDoorSpeaker then  SetVehicleMod(vh, 31, mds.modDoorSpeaker, false) end
        if mds.modSeats then  SetVehicleMod(vh, 32, mds.modSeats, false) end
        if mds.modSteeringWheel then  SetVehicleMod(vh, 33, mds.modSteeringWheel, false) end
        if mds.modShifterLeavers then  SetVehicleMod(vh, 34, mds.modShifterLeavers, false) end
        if mds.modAPlate then SetVehicleMod(vh, 35, mds.modAPlate, false) end
        if mds.modSpeakers then SetVehicleMod(vh, 36, mds.modSpeakers, false) end
        if mds.modTrunk then SetVehicleMod(vh, 37, mds.modTrunk, false) end
        if mds.modHydrolic then SetVehicleMod(vh, 38, mds.modHydrolic, false) end
        if mds.modEngineBlock then SetVehicleMod(vh, 39, mds.modEngineBlock, false) end
        if mds.modAirFilter then SetVehicleMod(vh, 40, mds.modAirFilter, false) end
        if mds.modStruts then SetVehicleMod(vh, 41, mds.modStruts, false) end
        if mds.modArchCover then SetVehicleMod(vh, 42, mds.modArchCover, false) end
        if mds.modAerials then SetVehicleMod(vh, 43, mds.modAerials, false) end
        if mds.modTrimB then SetVehicleMod(vh, 44, mds.modTrimB, false) end
        if mds.modTank then SetVehicleMod(vh, 45, mds.modTank, false) end
        if mds.modWindows then SetVehicleMod(vh, 46, mds.modWindows, false) end
        if mds.modLivery then SetVehicleMod(vh, 48, mds.modLivery, false) SetVehicleLivery(vh, mds.modLivery) end
    end
end

function GetPlate(vehicle)
    if vehicle == 0 then return end
    return Trim(GetVehicleNumberPlateText(vehicle))
end

function Trim(value)
	if not value then return nil end
    return (string.gsub(value, '^%s*(.-)%s*$', '%1'))
end

local ownCarBlips = {}

function AttachOwnCarBlip(vehicle)
    if not vehicle or vehicle == 0 then return end
    if ownCarBlips[vehicle] and DoesBlipExist(ownCarBlips[vehicle]) then return end

    local blip = AddBlipForEntity(vehicle)
    SetBlipSprite(blip, 225)
    SetBlipColour(blip, 3)
    SetBlipScale(blip, 0.7)
    SetBlipCategory(blip, 7)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString("Mashine Man")
    EndTextCommandSetBlipName(blip)

    ownCarBlips[vehicle] = blip
end

function RemoveOwnCarBlip(vehicle)
    local blip = ownCarBlips[vehicle]
    if blip and DoesBlipExist(blip) then
        RemoveBlip(blip)
    end
    ownCarBlips[vehicle] = nil
end

function HZDeleteVehicle(vehicle)
	TriggerServerEvent("CarLock:ToggleKey", false, GetPlate(vehicle))
    RemoveOwnCarBlip(vehicle)
    SetEntityAsMissionEntity(vehicle, true, true)
    DeleteVehicle(vehicle)
end

function HZSpawnVehicle(model, cb, coords, isnetworked, teleportInto)
    local ped = PlayerPedId()
    model = type(model) == 'string' and GetHashKey(model) or model
    -- FIX: this used to `return` here with zero feedback whenever the model
    -- wasn't a valid/streamed vehicle model, so the SPAWN button looked like
    -- it did nothing (menu stayed open, no vehicle, no error). Now it
    -- notifies the player and logs the exact model hash to console.
    if not model or not IsModelInCdimage(model) or not IsModelAVehicle(model) then
        SafeNotify('~r~In Mashin Dar Bazi Mojood Nist! (Model: ' .. tostring(model) .. ')')
        print('^1[Unique_Garage] HZSpawnVehicle: model ' .. tostring(model) .. ' is not a valid/streamed vehicle model.^0')
        return
    end
    if coords then
        coords = type(coords) == 'table' and vec3(coords.x, coords.y, coords.z) or coords
    else
        coords = GetEntityCoords(ped)
    end
    isnetworked = isnetworked or true
    ELoadModel(model)
    local veh = CreateVehicle(model, coords.x, coords.y, coords.z, coords.w, isnetworked, false)
    local netid = NetworkGetNetworkIdFromEntity(veh)
    SetVehicleHasBeenOwnedByPlayer(veh, true)
    SetNetworkIdCanMigrate(netid, true)
    SetVehicleNeedsToBeHotwired(veh, false)
    SetVehRadioStation(veh, 'OFF')
    SetVehicleFuelLevel(veh, 100.0)
    SetModelAsNoLongerNeeded(model)

    if teleportInto then TaskWarpPedIntoVehicle(PlayerPedId(), veh, -1)  end
    if cb then cb(veh) end
end

function ELoadModel(model)
    if HasModelLoaded(model) then return end
	RequestModel(model)
	while not HasModelLoaded(model) do
		Wait(0)
	end
end

function GetClosestVehicle()
    local vehicles = GetGamePool('CVehicle')
    local closestDistance = -1
    local closestVehicle = -1
    for i = 1, #vehicles, 1 do
        local vehicleCoords = GetEntityCoords(vehicles[i])
        local distance = #(vehicleCoords - GetEntityCoords(PlayerPedId()))

        if closestDistance == -1 or closestDistance > distance then
            closestVehicle = vehicles[i]
            closestDistance = distance
        end
    end
    return closestVehicle, closestDistance
end