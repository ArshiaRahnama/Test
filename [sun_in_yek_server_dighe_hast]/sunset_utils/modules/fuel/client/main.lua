-- Pub by FleeX Team , https://discord.gg/87rGBxgCsa

local function GetFuel(vehicle)
	return Entity(vehicle).state.fuel or GetVehicleFuelLevel(vehicle)
end
exports('GetFuel', GetFuel)

local function SetFuel(vehicle, fuel)
	if not DoesEntityExist(vehicle) or not tonumber(fuel) or fuel > 100.0 or fuel < 0.0 then
		return
	end
	local netId = NetworkGetNetworkIdFromEntity(vehicle)
    SetVehicleFuelLevel(vehicle, fuel + 0.0)
    Entity(vehicle).state.fuel = fuel + 0.0
	ESX.TriggerServerEvent('LegacyFuel:setFuel', netId, fuel)
end
exports('SetFuel', SetFuel)

local function CreateFuelBlip(coords)
	local blip = AddBlipForCoord(coords)
	SetBlipSprite(blip, 361)
	SetBlipScale(blip, 0.7)
	SetBlipColour(blip, 1)
	SetBlipDisplay(blip, 4)
	SetBlipAsShortRange(blip, true)
	BeginTextCommandSetBlipName("STRING")
	AddTextComponentString("Pomp benzin")
	EndTextCommandSetBlipName(blip)
	return blip
end

-- local function FindNearestFuelPump()
-- 	local playerCoords = GetEntityCoords(PlayerPedId())
-- 	local pumpObject = 0
-- 	local pumpDistance = -1
-- 	for _, object in pairs(ESX.Game.GetObjects()) do
-- 		local model = GetEntityModel(object)
-- 		if ArrayHasValue(fuelConfig.PumpModels, model) then
-- 			local dstcheck = #(playerCoords - GetEntityCoords(object))
-- 			if pumpDistance == -1 or dstcheck < pumpDistance then
-- 				pumpDistance = dstcheck
-- 				pumpObject = object
-- 			end
-- 		end
-- 	end
-- 	return pumpObject, pumpDistance
-- end

local function FuelRound(num, numDecimalPlaces)
    local mult = 10^(numDecimalPlaces or 0)
    return math.floor(num * mult + 0.5) / mult
end

local function DrawText3Ds(x, y, z, text)
	local onScreen,_x,_y=World3dToScreen2d(x,y,z)
	if onScreen then
		SetTextScale(0.35, 0.35)
		SetTextFont(4)
		SetTextProportional(1)
		SetTextColour(255, 255, 255, 215)
		SetTextEntry("STRING")
		SetTextCentre(1)
		AddTextComponentString(text)
		DrawText(_x,_y)
	end
end
-----

local IsFueling = false
local CurrentFuel = 0.0
local CurrentCost = 0.0
local CurrentCash = 0

local LastSyncValue = 0.0

RegisterNetEvent('LegacyFuel:setFuelClient')
AddEventHandler('LegacyFuel:setFuelClient', function(netId, fuel)
	if not tonumber(fuel) or not tonumber(netId) or fuel > 100.0 or fuel < 0.0 then
		return
	end
	local vehicle = NetworkGetEntityFromNetworkId(netId)
	if DoesEntityExist(vehicle) then
		SetVehicleFuelLevel(vehicle, fuel + 0.0)
	end
end)

function SyncFuelToAll(vehicle, percent)
    local fuel = GetFuel(vehicle)
    if LastSyncValue - fuel > percent then
        SetFuel(vehicle, fuel)
        LastSyncValue = fuel
    end
    if fuel > LastSyncValue then
        LastSyncValue = fuel
    end
end

Citizen.CreateThread(function()
	for _, gasStationCoords in pairs(fuelConfig.GasStations) do
		CreateFuelBlip(gasStationCoords)
	end
	local models = {}
	for k, v in pairs(fuelConfig.PumpModels) do
		models[v] = 5
	end
	exports['ox_target']:addModel2(fuelConfig.PumpModels, {
		{
			label = "🛢️خرید دبه بنزین",
			onSelect = function(entity)
				ESX.TriggerServerEvent('LegacyFuel:pay', fuelConfig.JerryCanCost,true)
			end,
		},
    })
	while true do
        if IsPedInAnyVehicle(SUN.ped) then
            local vehicle = GetVehiclePedIsIn(SUN.ped)
            if GetPedInVehicleSeat(vehicle, -1) == SUN.ped then
                SyncFuelToAll(vehicle, fuelConfig.SyncPercent)
            end
        end
		Citizen.Wait(10000)
	end
end)

function SyncFuel(vehicle, fuel)
	if DoesEntityExist(vehicle) and IsEntityAMissionEntity(vehicle) then
		ESX.TriggerServerEvent('LegacyFuel:syncFuel',NetworkGetNetworkIdFromEntity(vehicle),fuel or GetFuel(vehicle),ESX.Game.GetPlayersToSend(300))
	end
end

-- Remove fuel based on RPM, find nearest pump object
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(2000)
		local playerPed = SUN.ped
		if IsPedInAnyVehicle(playerPed) then
			local vehicle = GetVehiclePedIsIn(playerPed)
			if not ArrayHasValue(fuelConfig.Blacklist, GetEntityModel(vehicle)) and GetPedInVehicleSeat(vehicle, -1) == playerPed and IsVehicleEngineOn(vehicle) then
				local fuelToRemove = (fuelConfig.FuelUsage[FuelRound(GetVehicleCurrentRpm(vehicle), 1)] or 0.0) * (fuelConfig.Classes[GetVehicleClass(vehicle)] or 1.0) / 10.0
                -- Update locally in real time
                local fuel = GetFuel(vehicle)
				local fuel2 = ESX.Math.Round(GetVehicleFuelLevel(vehicle))
				if ESX.Math.Round(fuel2) - fuel > 10 and fuel2 > 95 then
					-- TriggerServerEvent('sc:adminalarm',('Fuel Cheat %s - %s'):format(ESX.Math.Round(fuel), fuel2))
				end
				fuel = fuel  - fuelToRemove
                Entity(vehicle).state.fuel = fuel + 0.0
                SetVehicleFuelLevel(vehicle, fuel + 0.0)
			end
		end
		-- local pumpObject, pumpDistance = FindNearestFuelPump()
		-- if pumpObject ~= 0 and pumpDistance < 2.0 then
		-- 	NearestPump = pumpObject
		-- else
		-- 	NearestPump = nil
		-- end
		-- NearestVehicle = GetClosestVehicle2(GetEntityCoords(playerPed), 8.0)
	end
end)

function FuelUpTick(pumpObject, vehicle)
	Citizen.CreateThread(function()
		local playerPed = PlayerPedId()
		CurrentFuel = GetFuel(vehicle)
		CurrentCost = 0.0

		while IsFueling do
			Citizen.Wait(500)

			local oldFuel = CurrentFuel

			local fuelToAdd = 2
			local tickCost  = math.ceil(fuelConfig.RefillCost*fuelToAdd/100)

			if not pumpObject then
				-- Jerrican
				if GetAmmoInPedWeapon(playerPed, `WEAPON_PETROLCAN`) - fuelToAdd * 100 >= 0 then
					CurrentFuel = oldFuel + fuelToAdd
					SetPedAmmo(playerPed, `WEAPON_PETROLCAN`, math.floor(GetAmmoInPedWeapon(playerPed, `WEAPON_PETROLCAN`) - fuelToAdd * 100))
				else
					IsFueling = false
				end
			else
				CurrentFuel = oldFuel + fuelToAdd
			end

			-- Tank is full, stop fueling
			if CurrentFuel > 100.0 then
				CurrentFuel = 100.0
				IsFueling = false
			end

			-- -- No more money, stop fueling
			CurrentCost = CurrentCost + tickCost
			print(CurrentCash, CurrentCost)
			if pumpObject and CurrentCash < CurrentCost + tickCost then
				IsFueling = false
			end
		end
		exports['essentialmode']:forceUpdateAmmo('WEAPON_PETROLCAN')

		-- Stopped fueling, pay or update jerrycan ammos
		if pumpObject then
			ESX.TriggerServerEvent('LegacyFuel:pay',CurrentCost,false)
			SetFuel(vehicle, CurrentFuel)
			SyncFuel(vehicle, CurrentFuel)
		else
			SetFuel(vehicle, CurrentFuel)
			SyncFuel(vehicle, CurrentFuel)
		end
	end)
end

function RefuelVehicleFromPump(pumpObject, vehicle)
	IsFueling = true
	Citizen.CreateThread(function()
		local playerPed = PlayerPedId()
		local animDict = 'timetable@gardener@filling_can'
		local anim = 'gar_ig_5_filling_can'
		ESX.Streaming.RequestAnimDict(animDict)
		CurrentCash = ESX.GetPlayerData().bank > ESX.GetPlayerData().money and ESX.GetPlayerData().bank or ESX.GetPlayerData().money
		-- Make ped to face vehicle
		SetCurrentPedWeapon(playerPed, `WEAPON_UNARMED`, true)
		TaskTurnPedToFaceEntity(playerPed, vehicle, 1000)
		Citizen.Wait(1000)
		-- Start refuel thread
		FuelUpTick(pumpObject, vehicle)
		while IsFueling do
			-- Disable controls when fueling
			for _, controlIndex in pairs(fuelConfig.DisableKeys) do
				DisableControlAction(0, controlIndex)
			end

			-- Disaply fueling progress
			local vehicleCoords = GetEntityCoords(vehicle)
			if pumpObject then
				-- local pumpCoords  = GetEntityCoords(pumpObject)
				DrawText3Ds(vehicleCoords.x, vehicleCoords.y, vehicleCoords.z + 1.7, 'Dokme ~g~E ~w~Baraye Etmam Benzin Zadan\nHazine: ~g~' .. FuelRound(CurrentCost, 1) .. '$')
				DrawText3Ds(vehicleCoords.x, vehicleCoords.y, vehicleCoords.z + 0.5, FuelRound(CurrentFuel, 1) .. "%")
			else
				DrawText3Ds(vehicleCoords.x, vehicleCoords.y, vehicleCoords.z + 0.5, 'Dokme ~g~E ~w~Baraye Etmam Benzin Zadan\nJerrican: ~g~'.. FuelRound(GetAmmoInPedWeapon(playerPed, `WEAPON_PETROLCAN`) / fuelConfig.DefaultPetrolCanAmmo * 100, 1) .. '~s~ | Vehicle: ~g~' .. FuelRound(CurrentFuel, 1) .. '~s~')
			end

			-- Play fueling animation
			if not IsEntityPlayingAnim(playerPed, animDict, anim, 3) then
				TaskPlayAnim(playerPed, animDict, anim, 2.0, 8.0, -1, 50, 0, 0, 0, 0)
			end

			-- Allow cancelling fuel
			if IsControlJustPressed(0, 38) or (pumpObject and #(GetEntityCoords(vehicle) - SUN.PlayerCoords) > 10) then
				IsFueling = false
			end

			Citizen.Wait(0)
		end
		ClearPedTasks(playerPed)
		RemoveAnimDict(animDict)
	end)
end
exports('RefuelVehicleFromPump', RefuelVehicleFromPump)

function DoesNearPump()
	local playerCoords = GetEntityCoords(PlayerPedId())
	for _, object in pairs(ESX.Game.GetObjects()) do
		local model = GetEntityModel(object)
		if ESX.TableContainsValue(fuelConfig.PumpModels, model) then
			local distance = #(playerCoords - GetEntityCoords(object))
			if distance < 10 then
				return true
			end
		end
	end
end
exports('DoesNearPump', DoesNearPump)
exports('BuyJerryCan', function()
	ESX.TriggerServerEvent('LegacyFuel:pay', fuelConfig.JerryCanCost,true)
end)