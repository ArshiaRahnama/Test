local Keys = {
	["ESC"] = 322, ["F1"] = 288, ["F2"] = 289, ["F3"] = 170, ["F5"] = 166, ["F6"] = 167, ["F7"] = 168, ["F8"] = 169, ["F9"] = 56, ["F10"] = 57,
	["~"] = 243, ["1"] = 157, ["2"] = 158, ["3"] = 160, ["4"] = 164, ["5"] = 165, ["6"] = 159, ["7"] = 161, ["8"] = 162, ["9"] = 163, ["-"] = 84, ["="] = 83, ["BACKSPACE"] = 177,
	["TAB"] = 37, ["Q"] = 44, ["W"] = 32, ["E"] = 38, ["R"] = 45, ["T"] = 245, ["Y"] = 246, ["U"] = 303, ["P"] = 199, ["["] = 39, ["]"] = 40, ["ENTER"] = 18,
	["CAPS"] = 137, ["A"] = 34, ["S"] = 8, ["D"] = 9, ["F"] = 23, ["G"] = 47, ["H"] = 74, ["K"] = 311, ["L"] = 182,
	["LEFTSHIFT"] = 21, ["Z"] = 20, ["X"] = 73, ["C"] = 26, ["V"] = 0, ["B"] = 29, ["N"] = 249, ["M"] = 244, [","] = 82, ["."] = 81,
	["LEFTCTRL"] = 36, ["LEFTALT"] = 19, ["SPACE"] = 22, ["RIGHTCTRL"] = 70,
	["HOME"] = 213, ["PAGEUP"] = 10, ["PAGEDOWN"] = 11, ["DELETE"] = 178,
	["LEFT"] = 174, ["RIGHT"] = 175, ["TOP"] = 27, ["DOWN"] = 173,
	["NENTER"] = 201, ["N4"] = 108, ["N5"] = 60, ["N6"] = 107, ["N+"] = 96, ["N-"] = 97, ["N7"] = 117, ["N8"] = 61, ["N9"] = 118
}
local LoadoutLoaded = false
local IsPaused      = false
local PlayerSpawned = false
local LastLoadout   = {}
local Pickups       = {}
local isDead        = false
local UpdatePos		= true
local adminTalk 	= false

local states = {}
states.frozen = false
states.frozenPos = nil

AddEventHandler('ToggleUpdatePos', function(toggles)
    UpdatePos = toggles
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(1)

		if NetworkIsSessionStarted() then
			TriggerServerEvent('fristJoinCheck')
			return
		end
	end
end)

local loaded = false
local oldPos

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(1000)
		local pos = GetEntityCoords(PlayerPedId())
		local heading = GetEntityHeading(PlayerPedId())
		if(oldPos ~= pos) and UpdatePos == true then
			TriggerServerEvent('updatePositions', pos.x, pos.y, pos.z, heading)
			oldPos = pos
		end
	end
end)

Citizen.CreateThread(function()
	while true do


		Citizen.Wait(5000)

		for i = 0,255 do
			if NetworkIsPlayerActive(i) then
				SetCanAttackFriendly(GetPlayerPed(i), true, true)
				NetworkSetFriendlyFireOption(true)
			end
		end
	end
end)

function SetVehicleMaxMods(vehicle, turbo)

	local props = {}

		if turbo then

			props = {
				modEngine       =   3,
				modBrakes       =   2,
				windowTint      =   1,
				modArmor        =   4,
				modTransmission =   2,
				modSuspension   =   -1,
				modTurbo        =   true,
			}

		else

			props = {
				modEngine       =   3,
				modBrakes       =   2,
				windowTint      =   1,
				modArmor        =   4,
				modTransmission =   2,
				modSuspension   =   -1,
				modTurbo        =   false,
			}

		end
		ESX.Game.SetVehicleProperties(vehicle, props)

end

local myDecorators = {}

RegisterNetEvent("es:setPlayerDecorator")
AddEventHandler("es:setPlayerDecorator", function(key, value, doNow)
	myDecorators[key] = value
	DecorRegister(key, 3)

	if(doNow)then
		DecorSetInt(PlayerPedId(), key, value)
	end
end)

local enableNative = {}

local firstSpawn = true
AddEventHandler("playerSpawned", function()
	for k,v in pairs(myDecorators)do
		DecorSetInt(PlayerPedId(), k, v)
	end

	if enableNative[1] then
		N_0xc2d15bef167e27bc()
		SetPlayerCashChange(1, 0)
		Citizen.InvokeNative(0x170F541E1CADD1DE, true)
		SetPlayerCashChange(-1, 0)
	end

	if enableNative[2] then
		SetMultiplayerBankCash()
		Citizen.InvokeNative(0x170F541E1CADD1DE, true)
		SetPlayerCashChange(0, 1)
		SetPlayerCashChange(0, -1)
	end

	while not ESX.PlayerLoaded do
		Citizen.Wait(1)
	end

	local playerPed = PlayerPedId()

	if firstSpawn then
		SetEntityCoords(playerPed, ESX.PlayerData.lastPosition.x, ESX.PlayerData.lastPosition.y, ESX.PlayerData.lastPosition.z - 1)
		TriggerEvent('es_admin:freezePlayer', true)
	end
	firstSpawn = false
	PlayerSpawned = true
	isDead = false

	TriggerServerEvent('playerSpawn')

end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
	ESX.PlayerLoaded = true
	ESX.PlayerData   = xPlayer
	if xPlayer.group == 'vip' then
		Citizen.CreateThread(function()
			while true do
				Citizen.Wait(1)
				local IsPlayerInVehicle = IsPedInAnyVehicle(PlayerPedId(), true)
				if IsControlJustReleased(0, Keys['M']) and not IsPlayerInVehicle then
					OpenPlayerMenu()
				end
			end
		end)
	end

end)

RegisterNetEvent('es_admin:vehRepair')
AddEventHandler('es_admin:vehRepair', function(veh)
	local vehicle = tonumber(veh)
	if DoesEntityExist(vehicle) then
		SetVehicleFixed(vehicle)
		SetVehicleFuelLevel(vehicle, 20.5)
		SetVehicleDirtLevel(vehicle, 0.0)
	end
end)

RegisterNetEvent('addDonationCar')
AddEventHandler('addDonationCar', function(newOwner, plate, admin)
	local vehicle  = GetVehiclePedIsIn(PlayerPedId(-1), false)
	local VehName = GetDisplayNameFromVehicleModel(GetEntityModel(vehicle))
	local AdminName = GetPlayerName(GetPlayerFromServerId(tonumber(admin)))
	local PlayerName = GetPlayerName(GetPlayerFromServerId(tonumber(newOwner)))
	local oldPlate = ESX.Math.Trim(GetVehicleNumberPlateText(vehicle))
	local newPlate
	if plate then
		newPlate = plate
	else
		newPlate = exports.esx_vehicleshop:GeneratePlate()
	end
	local vehicleProps = ESX.Game.GetVehicleProperties(vehicle)
	vehicleProps.plate = newPlate
	SetVehicleNumberPlateText(vehicle, newPlate)
	TriggerServerEvent('esx_vehicleshop:setVehicleOwnedscaryPlayerId', newOwner, vehicleProps)

	if newPlate == plate then
		TriggerServerEvent('DiscordBot:ToDiscord', 'addcar', "AddCar By Admin", "```css\nAdd Car By Admin For User\n[ Admin : " .. AdminName .. " | Player : " .. PlayerName .. "("..newOwner..") | Vehicle Name : "..VehName.." | Plate : "..newPlate.." ] \n```",'user', source, true, false)
	else
		TriggerServerEvent('DiscordBot:ToDiscord', 'addcar', "AddCar By Admin", "```css\nAdd Car By Admin For User\n[ Admin : " .. AdminName .. " | Player : " .. PlayerName .. "("..newOwner..") | Vehicle Name : "..VehName.." | Plate : Random ] \n```",'user', source, true, false)
	end

	TriggerServerEvent('esx:CreateItem', "CarKey|"..newPlate, VehName.." | "..newPlate, 1, 0, 0);
	TriggerServerEvent("CarLock:ToggleKey", true, newPlate, vehicle)
	TriggerServerEvent("CarLock:ToggleKey", false, oldPlate, vehicle)
end)

RegisterNetEvent('ChangeCarPlate')
AddEventHandler('ChangeCarPlate', function(newPlate)
	local entity   = ESX.Game.GetVehicleInDirection(Config.TargetDistance)
	if entity == 0 then
		entity = GetVehiclePedIsIn(PlayerPedId(-1), false)
	end
	if entity == 0 then
		return
	end
	local vehicleProps = ESX.Game.GetVehicleProperties(entity)
	local oldPlate = vehicleProps.plate
	vehicleProps.plate = newPlate
	SetVehicleNumberPlateText(entity, newPlate)
	local namevehicle = GetMakeNameFromVehicleModel(GetEntityModel(entity))
	TriggerServerEvent('esx_vehicleshop:ChangeVehiclePlate', vehicleProps, oldPlate)
	TriggerServerEvent('esx:CreateItem', "CarKey|"..newPlate, namevehicle.." | "..newPlate, 1, 0, 0);
	TriggerServerEvent("CarLock:ToggleKey", true, newPlate, vehicle)
	TriggerServerEvent("CarLock:ToggleKey", false, oldPlate, vehicle)
end)

RegisterNetEvent('RemoveCar')
AddEventHandler('RemoveCar', function()
	local entity   = ESX.Game.GetVehicleInDirection(Config.TargetDistance)
	if entity == 0 then
		entity = GetVehiclePedIsIn(PlayerPedId(-1), false)
	end
	if entity == 0 then
		return
	end
	local oldPlate = ESX.Math.Trim(GetVehicleNumberPlateText(entity))

	TriggerServerEvent('esx_vehicleshop:DeleteVehicle', oldPlate)
	TriggerServerEvent("CarLock:ToggleKey", false, oldPlate, vehicle)
end)

RegisterNetEvent('addGangCar')
AddEventHandler('addGangCar', function(newOwner, plate, admin)
	local vehicle  = GetVehiclePedIsIn(PlayerPedId(-1), false)
	local VehName = GetDisplayNameFromVehicleModel(GetEntityModel(vehicle))
	local AdminName = GetPlayerName(GetPlayerFromServerId(tonumber(admin)))
	local oldPlate = ESX.Math.Trim(GetVehicleNumberPlateText(vehicle))
	local newPlate
	if plate then
		newPlate = plate
	else
		newPlate = exports.esx_vehicleshop:GeneratePlate()
	end
	local vehicleProps = ESX.Game.GetVehicleProperties(vehicle)
	vehicleProps.plate = newPlate
	SetVehicleNumberPlateText(vehicle, newPlate)
	TriggerServerEvent('esx_vehicleshop:setVehicleGang', newOwner, vehicleProps )
	if newPlate == plate then
		TriggerServerEvent('DiscordBot:ToDiscord', 'addcar', "AddCar By Admin", "```css\nAdd Car By Admin For Gang\n[ Admin : " .. AdminName .. " | Gang : "..newOwner.." | Vehicle Name : "..VehName.." | Plate : "..newPlate.." ]\n```",'user', source, true, false)
	else
		TriggerServerEvent('DiscordBot:ToDiscord', 'addcar', "AddCar By Admin", "```css\nAdd Car By Admin For Gang\n[ Admin : " .. AdminName .. " | Gang : "..newOwner.." | Vehicle Name : "..VehName.." | Plate : Random ]\n```",'user', source, true, false)
	end
	TriggerServerEvent('esx:CreateItem', "CarKey|"..newPlate, VehName.." | "..newPlate, 1, 0, 0);
	TriggerServerEvent("CarLock:ToggleKey", true, newPlate, vehicle)
	TriggerServerEvent("CarLock:ToggleKey", false, oldPlate, vehicle)
end)

RegisterNetEvent('es_admin:heal')
AddEventHandler('es_admin:heal', function()
	SetEntityHealth(PlayerPedId(), 200)
end)

RegisterNetEvent('es_admin:kill')
AddEventHandler('es_admin:kill', function()
	SetEntityHealth(PlayerPedId(), 0)
end)

RegisterNetEvent('es_admin:slap')
AddEventHandler('es_admin:slap', function()
	local ped = PlayerPedId()

	ApplyForceToEntity(ped, 0, 10.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1, false, true, false, false)
end)

RegisterNetEvent('es_admin:freezePlayer')
AddEventHandler("es_admin:freezePlayer", function(state)
	local player = PlayerId()

	local ped = PlayerPedId()

	states.frozen = state
	states.frozenPos = GetEntityCoords(ped, false)

	if not state then
		if not IsEntityVisible(ped) then
			SetEntityVisible(ped, true)
		end

		if not IsPedInAnyVehicle(ped) then
			SetEntityCollision(ped, true)
		end

		FreezeEntityPosition(ped, false)
		SetPlayerInvincible(player, false)
	else
		SetEntityCollision(ped, false)
		FreezeEntityPosition(ped, true)
		SetPlayerInvincible(player, true)

		if not IsPedFatallyInjured(ped) then
			ClearPedTasksImmediately(ped)
		end
	end
end)

local noclip = false
RegisterNetEvent("es_admin:noclip")
AddEventHandler("es_admin:noclip", function(t)
	local msg = "disabled"
	if(noclip == false)then
		noclip_pos = GetEntityCoords(PlayerPedId(), false)
	end

	noclip = not noclip

	if(noclip)then
		msg = "enabled"
	end

	TriggerEvent("chatMessage", "SYSTEM", {255, 0, 0}, "Noclip has been ^2^*" .. msg)
end)

RegisterNetEvent('moneyUpdate')
AddEventHandler('moneyUpdate', function(m)
	ESX.PlayerData.money = m
end)

RegisterNetEvent('bankUpdate')
AddEventHandler('bankUpdate', function(m)
	ESX.PlayerData.bank = m
end)

RegisterNetEvent('es:addedBank')
AddEventHandler('es:addedBank', function(m)
	Citizen.InvokeNative(0x170F541E1CADD1DE, true)
	SetPlayerCashChange(0, math.floor(m))
end)

RegisterNetEvent('es:removedBank')
AddEventHandler('es:removedBank', function(m)
	Citizen.InvokeNative(0x170F541E1CADD1DE, true)
	SetPlayerCashChange(0, -math.floor(m))
end)

AddEventHandler('esx:onPlayerDeath', function()
	isDead = true
end)

AddEventHandler('skinchanger:loadDefaultModel', function()
	LoadoutLoaded = false
end)

AddEventHandler('skinchanger:modelLoaded', function()
	while not ESX.PlayerLoaded do
		Citizen.Wait(1)
	end

	TriggerEvent('esx:restoreLoadout')
end)

AddEventHandler('esx:restoreLoadout', function(loadoutx)
	LoadoutLoaded = true
	local playerPed = PlayerPedId()
	local ammoTypes = {}
	if loadoutx ~= nil then loadout = loadoutx else loadout = ESX.PlayerData.loadout end
	RemoveAllPedWeapons(playerPed, true)

	for i=1, #loadout, 1 do
		local weaponName = loadout[i].name
		local weaponHash = GetHashKey(weaponName)

		GiveWeaponToPed(playerPed, weaponHash, 0, false, false)
		local ammoType = GetPedAmmoTypeFromWeapon(playerPed, weaponHash)

		for j=1, #loadout[i].components, 1 do
			local weaponComponent = loadout[i].components[j]
			local componentHash = ESX.GetWeaponComponent(weaponName, weaponComponent).hash
			GiveWeaponComponentToPed(playerPed, weaponHash, componentHash)
		end

		if not ammoTypes[ammoType] then
			AddAmmoToPed(playerPed, weaponHash, loadout[i].ammo)
			ammoTypes[ammoType] = true
		end
	end

	LoadoutLoaded = true
end)

RegisterNetEvent('esx:addInventoryItem')
AddEventHandler('esx:addInventoryItem', function(item, count)
	local found = false
	for i=1, #ESX.PlayerData.inventory, 1 do
		if ESX.PlayerData.inventory[i].name == item.name then
			ESX.PlayerData.inventory[i] = item
			found = true
			break
		end
	end

	if not found then
		table.insert(ESX.PlayerData.inventory, item)
	end

	ESX.UI.ShowInventoryItemNotification(true, item, count)

	if ESX.UI.Menu.IsOpen('default', 'essentialmode', 'inventory') then
		ESX.ShowInventory()
	end
end)

RegisterNetEvent('esx:removeInventoryItem')
AddEventHandler('esx:removeInventoryItem', function(item, count)
	for i=1, #ESX.PlayerData.inventory, 1 do
		if ESX.PlayerData.inventory[i].name == item.name then
			if item.count ~= nil and item.count > 0 then
				ESX.PlayerData.inventory[i] = item
			else
				table.remove(ESX.PlayerData.inventory, i)
			end
			break
		end
	end

	ESX.UI.ShowInventoryItemNotification(false, item, count)

	if ESX.UI.Menu.IsOpen('default', 'essentialmode', 'inventory') then
		ESX.ShowInventory()
	end
end)

-- Safe replacement for the old esx:addInventoryItem/removeInventoryItem
-- notification (that one crashed because ox_inventory only sends the item
-- NAME, not a full item table like essentialmode's own inventory used to).
-- This just shows the popup directly with pre-built, safe data — no touching
-- ESX.PlayerData.inventory at all, since ox_inventory owns that now.
RegisterNetEvent('ox_inventory:showItemNotification')
AddEventHandler('ox_inventory:showItemNotification', function(added, item, count)
	ESX.UI.ShowInventoryItemNotification(added, item, count)
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
	ESX.PlayerData.job = job
end)

RegisterNetEvent('esx:SetStarterPack')
AddEventHandler('esx:SetStarterPack', function(starter)
	ESX.PlayerData.StarterPack = starter
end)

RegisterNetEvent('esx:addWeapon')
AddEventHandler('esx:addWeapon', function(weaponName, ammo)
	local playerPed  = PlayerPedId()
	local weaponHash = GetHashKey(weaponName)

	GiveWeaponToPed(playerPed, weaponHash, ammo, false, false)

end)

RegisterNetEvent('esx:addWeaponComponent')
AddEventHandler('esx:addWeaponComponent', function(weaponName, weaponComponent)
	local playerPed  = PlayerPedId()
	local weaponHash = GetHashKey(weaponName)
	local componentHash = ESX.GetWeaponComponent(weaponName, weaponComponent).hash

	GiveWeaponComponentToPed(playerPed, weaponHash, componentHash)
end)

RegisterNetEvent('esx:removeWeapon')
AddEventHandler('esx:removeWeapon', function(weaponName, ammo)
	local playerPed  = PlayerPedId()
	local weaponHash = GetHashKey(weaponName)

	if ammo then
		local pedAmmo = GetAmmoInPedWeapon(playerPed, weaponHash)
		local finalAmmo = math.floor(pedAmmo - ammo)
		SetPedAmmo(playerPed, weaponHash, finalAmmo)
	else
		SetPedAmmo(playerPed, weaponHash, 0)
	end

	RemoveWeaponFromPed(playerPed, weaponHash)
end)

RegisterNetEvent('esx:removeWeaponComponent')
AddEventHandler('esx:removeWeaponComponent', function(weaponName, weaponComponent)
	local playerPed  = PlayerPedId()
	local weaponHash = GetHashKey(weaponName)
	local componentHash = ESX.GetWeaponComponent(weaponName, weaponComponent).hash

	RemoveWeaponComponentFromPed(playerPed, weaponHash, componentHash)
end)

RegisterNetEvent('esx:teleport')
AddEventHandler('esx:teleport', function(pos)
	pos.x = pos.x + 0.0
	pos.y = pos.y + 0.0
	pos.z = pos.z + 0.0

	RequestCollisionAtCoord(pos.x, pos.y, pos.z)

	while not HasCollisionLoadedAroundEntity(PlayerPedId()) do
		RequestCollisionAtCoord(pos.x, pos.y, pos.z)
		Citizen.Wait(1)
	end

	SetEntityCoords(PlayerPedId(), pos.x, pos.y, pos.z)
end)

RegisterNetEvent('esx:loadIPL')
AddEventHandler('esx:loadIPL', function(name)
	Citizen.CreateThread(function()
		LoadMpDlcMaps()
		EnableMpDlcMaps(true)
		RequestIpl(name)
	end)
end)

RegisterNetEvent('esx:unloadIPL')
AddEventHandler('esx:unloadIPL', function(name)
	Citizen.CreateThread(function()
		RemoveIpl(name)
	end)
end)

RegisterNetEvent('esx:playAnim')
AddEventHandler('esx:playAnim', function(dict, anim)
	Citizen.CreateThread(function()
		local playerPed = PlayerPedId()
		RequestAnimDict(dict)

		while not HasAnimDictLoaded(dict) do
			Citizen.Wait(1)
		end

		TaskPlayAnim(playerPed, dict, anim, 1.0, -1.0, 20000, 0, 1, true, true, true)
	end)
end)

RegisterNetEvent('esx:playEmote')
AddEventHandler('esx:playEmote', function(emote)
	Citizen.CreateThread(function()

		local playerPed = PlayerPedId()

		TaskStartScenarioInPlace(playerPed, emote, 0, false);
		Citizen.Wait(20000)
		ClearPedTasks(playerPed)

	end)
end)

RegisterNetEvent('esx:spawnVehicle')
AddEventHandler('esx:spawnVehicle', function(model)
	local playerPed = PlayerPedId()
	local coords    = GetEntityCoords(playerPed)

	ESX.Game.SpawnVehicle(model, coords, 90.0, function(vehicle)
		TaskWarpPedIntoVehicle(playerPed,  vehicle, -1)
		SetVehicleFuelLevel(vehicle, 100.0)
	end)
end)

RegisterNetEvent('esx:spawnObject')
AddEventHandler('esx:spawnObject', function(model)
	local playerPed = PlayerPedId()
	local coords    = GetEntityCoords(playerPed)
	local forward   = GetEntityForwardVector(playerPed)
	local x, y, z   = table.unpack(coords + forward * 1.0)

	ESX.Game.SpawnObject(model, {
		x = x,
		y = y,
		z = z
	}, function(obj)
		SetEntityHeading(obj, GetEntityHeading(playerPed))
		PlaceObjectOnGroundProperly(obj)
	end)
end)

RegisterNetEvent('esx:pickup')
AddEventHandler('esx:pickup', function(id, label, model, components, player)
	local ped     = GetPlayerPed(GetPlayerFromServerId(player))
	local coords  = GetEntityCoords(ped)
	local forward = GetEntityForwardVector(ped)
	local x, y, z = table.unpack(coords + forward * 0.5)
	ESX.Game.SpawnLocalObject(model, {
		x = x,
		y = y,
		z = z
	}, function(obj)
		SetEntityHeading(obj, GetEntityHeading(ped))
		PlaceObjectOnGroundProperly(obj)
		SetEntityAsMissionEntity(obj, true, false)

		Pickups[id] = {
			id = id,
			obj = obj,
			label = label,
			components = components,
			inRange = false,
			coords = {
				x = x,
				y = y,
				z = z
			}
		}
	end)
end)

RegisterNetEvent('esx:pickupcrafting')
AddEventHandler('esx:pickupcrafting', function(id, label, model, components, x, y, z)

	ESX.Game.SpawnLocalObject(model, {
		x = x,
		y = y,
		z = z
	}, function(obj)
		SetEntityHeading(obj, GetEntityHeading(ped))
		PlaceObjectOnGroundProperly(obj)
		SetEntityAsMissionEntity(obj, true, false)

		Pickups[id] = {
			id = id,
			obj = obj,
			label = label,
			components = components,
			inRange = false,
			coords = {
				x = x,
				y = y,
				z = z
			}
		}
	end)
end)

RegisterNetEvent('esx:pickupUpdate')
AddEventHandler('esx:pickupUpdate', function(id, label)
	if Pickups[id] then
		Pickups[id].label 	= label
		Pickups[id].inRange = false
	end
end)

RegisterNetEvent('esx:removePickup')
AddEventHandler('esx:removePickup', function(id)
	if Pickups[id] then
		ESX.Game.DeleteObject(Pickups[id].obj)
		Pickups[id] = nil
	end
end)

RegisterNetEvent('esx:spawnPed')
AddEventHandler('esx:spawnPed', function(model)
	model           = (tonumber(model) ~= nil and tonumber(model) or GetHashKey(model))
	local playerPed = PlayerPedId()
	local coords    = GetEntityCoords(playerPed)
	local forward   = GetEntityForwardVector(playerPed)
	local x, y, z   = table.unpack(coords + forward * 1.0)

	Citizen.CreateThread(function()
		RequestModel(model)

		while not HasModelLoaded(model) do
			Citizen.Wait(1)
		end

		CreatePed(5, model, x, y, z, 0.0, true, false)
	end)
end)

RegisterNetEvent('esx:deleteVehicle')
AddEventHandler('esx:deleteVehicle', function()
    local playerPed = PlayerPedId()
	local entity   = ESX.Game.GetVehicleInDirection(Config.TargetDistance)
	if entity == 0 then
		entity = GetVehiclePedIsIn(PlayerPedId(-1), false)
	end
	if entity == 0 then
		return
	end
    local carModel = GetEntityModel(entity)
    local carName = GetDisplayNameFromVehicleModel(carModel)
	local carPlate = GetVehicleNumberPlateText(entity)
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


    if IsVehicleSeatFree(entity, -1) or GetPedInVehicleSeat(entity, -1) == PlayerPedId() then
        if DoesEntityExist(entity) then
            TriggerEvent('chat:addMessage', {
                color = { 255, 0, 0},
                multiline = true,
                args = {"[SYSTEM]", "^2 " .. carName .. "^0 ba movafaghiat hazf shod!"}
            })
        end

        Citizen.InvokeNative( 0xEA386986E786A54F, Citizen.PointerValueIntInitialized( entity ) )
        TriggerServerEvent("CarLock:ToggleKey", false, carPlate, entity)
		TriggerServerEvent('unregisterSpawnedVehicle', carPlate)
        if (DoesEntityExist(entity)) then
            ESX.Game.DeleteVehicle(entity)
        end
    else
        TriggerEvent('chat:addMessage', {
            color = { 255, 0, 0},
            multiline = true,
            args = {"[SYSTEM]", "^2 " .. carName .. "^0 dar hale hazer yek ranande dare"}
        })
    end

end)

RegisterNetEvent('es_admin:repair')
AddEventHandler('es_admin:repair', function()
	local PlayerPed = PlayerPedId()
	local Vehicle   = ESX.Game.GetVehicleInDirection(Config.TargetDistance)

	if IsPedInAnyVehicle(PlayerPed, true) then
		Vehicle = GetVehiclePedIsIn(PlayerPed, false)
	end
	local Driver = GetPedInVehicleSeat(Vehicle, -1)

	if PlayerPed == Driver then
		SetVehicleFixed(Vehicle)
		SetVehicleFuelLevel(vehicle, 20.5)
		SetVehicleDirtLevel(Vehicle, 0.0)
	else
		TriggerServerEvent('es_admin:vehRepair', Vehicle)
	end
end)

RegisterNetEvent('es:bringAll')
AddEventHandler('es:bringAll', function(target)
	SetEntityCoords(PlayerPedId(), GetEntityCoords(GetPlayerPed(GetPlayerFromServerId(target))))
end)

RegisterNetEvent('es:adminTalk')
AddEventHandler('es:adminTalk', function(voice)
	adminTalk = not adminTalk

	if not adminTalk then
		NetworkSetTalkerProximity(5.0)
	end
	Citizen.CreateThread(function()
		while adminTalk do
			NetworkSetTalkerProximity(voice + 0.0)
			Citizen.Wait(10)
			local player = PlayerId()
			DisableControlAction(0, 249, true)

			if NetworkIsPlayerTalking(player) then
				SetPlayerTalkingOverride(player, false)
			end
		end
	end)
end)

RegisterNetEvent('adminExeption')
AddEventHandler('adminExeption', function()
	adminTalk = false
end)

RegisterNetEvent('es:search')
AddEventHandler('es:search', function()
	Citizen.CreateThread(function()
		while true do
			Citizen.Wait(100)
			local IsPlayerInVehicle = IsPedInAnyVehicle(PlayerPedId(), true)
			if IsControlJustReleased(0, Keys['M']) and not IsPlayerInVehicle then
				OpenPlayerMenu()
			end
		end
	end)
end)

function OpenPlayerMenu()
	ESX.UI.Menu.CloseAll()

	local elements = {
		{label = "دست بند زدن",          value = 'handcuff'},
		{label = "باز کردن دست بند",     value = 'uncuff'},
		{label = "جا به جا کردن فرد",    value = 'drag'},
		{label = "انتقال به داخل ماشین", value = 'put_in_vehicle'},
		{label = "بیرون آوردن از ماشین", value = 'out_the_vehicle'},
		{label = "جست و جوی فرد",         value = 'search'}
	}
	ESX.UI.Menu.Open(
	'default', GetCurrentResourceName(), 'citizen_interaction',
	{
	  title    = "VIP Menu",
	  align    = 'top-left',
	  elements = elements
	},
	function(data2, menu2)

	  local player, distance = ESX.Game.GetClosestPlayer()

	  if distance ~= -1 and distance <= 3.0 then

		if data2.current.value == 'handcuff' then
			local target, distance = ESX.Game.GetClosestPlayer()
			playerheading = GetEntityHeading(PlayerPedId())
			playerlocation = GetEntityForwardVector(PlayerPedId())
			playerCoords = GetEntityCoords(PlayerPedId())
			local target_id = GetPlayerServerId(target)
			if distance <= 2.0 then
				ESX.TriggerServerCallback('esx_policejob:IsHandCuffed', function(status)
					if not status then
						TriggerServerEvent('esx_policejob:requestarrest', target_id, playerheading, playerCoords, playerlocation)
					end
				end, target_id)
			else
				ESX.ShowNotification('Not Close Enough To Cuff.')
			end
		elseif data2.current.value == 'uncuff' then
			local target, distance = ESX.Game.GetClosestPlayer()
			playerheading = GetEntityHeading(PlayerPedId())
			playerlocation = GetEntityForwardVector(PlayerPedId())
			playerCoords = GetEntityCoords(PlayerPedId())
			local target_id = GetPlayerServerId(target)
			if distance <= 2.0 then
				ESX.TriggerServerCallback('esx_policejob:IsHandCuffed', function(status)
					if status and status ~= 'police' then
						TriggerServerEvent('esx_policejob:requestrelease', target_id, playerheading, playerCoords, playerlocation)
					end
				end, target_id)
			else
				ESX.ShowNotification('Not Close Enough To UnCuff.')
			end
		elseif data2.current.value == 'drag' then
		  	TriggerServerEvent('esx_policejob:drag', GetPlayerServerId(player))
		elseif data2.current.value == 'put_in_vehicle' then
		  	TriggerServerEvent('esx_policejob:putInVehicle', GetPlayerServerId(player))
		elseif data2.current.value == 'out_the_vehicle' then
		  	TriggerServerEvent('esx_policejob:OutVehicle', GetPlayerServerId(player))
		elseif data2.current.value == "search" then
		  	OpenBodySearchMenu(player)
		end

	  else
		ESX.ShowNotification("Hich kas Nazdike Shoma nist!")
	  end

	end,
	function(data2, menu2)
	  menu2.close()
	end)
end

function OpenBodySearchMenu(player)

	ESX.TriggerServerCallback('esx:getOtherPlayerDataCard', function(data)

	  local elements = {}

	  table.insert(elements, {label = '--- Money ---', value = nil})

	  table.insert(elements, {label = "$" .. ESX.Math.GroupDigits(data.money), value = nil})

	  table.insert(elements, {label = '--- Armes ---', value = nil})

	  for i=1, #data.weapons, 1 do
		table.insert(elements, {
		  label          = _U('confiscate') .. ESX.GetWeaponLabel(data.weapons[i].name),
		  value          = data.weapons[i].name,
		  itemType       = 'item_weapon',
		  amount         = data.ammo,
		})
	  end

	  table.insert(elements, {label = _U('inventory_label'), value = nil})

	  for i=1, #data.inventory, 1 do
		if data.inventory[i].count > 0 then
		  table.insert(elements, {
			label          = _U('confiscate_inv') .. data.inventory[i].count .. ' ' .. data.inventory[i].label,
			value          = data.inventory[i].name,
			itemType       = 'item_standard',
			amount         = data.inventory[i].count,
		  })
		end
	  end


	  ESX.UI.Menu.Open(
		'default', GetCurrentResourceName(), 'body_search',
		{
		  title    = "Search Menu",
		  align    = 'top-left',
		  elements = elements,
		},
		function(data, menu)

		  local itemType = data.current.itemType
		  local itemName = data.current.value
		  local amount   = data.current.amount

		  if data.current.value ~= nil then
			local coords = GetEntityCoords(PlayerPedId())
			local target = GetEntityCoords(GetPlayerPed(player))
			local distance = #(target - coords)
			if distance <= 3.0 then
			  Wait(math.random(0, 500))
			  TriggerServerEvent('esx:confiscatePlayerItem', GetPlayerServerId(player), itemType, itemName, amount)
			  OpenBodySearchMenu(player)
			else
			  menu.close()
			end
		  end

		end,
		function(data, menu)
		  menu.close()
		end)
	end, GetPlayerServerId(player))
end

local LoadOut = true

AddEventHandler('ToggleUpdateLoadOut', function(toggle)
    LoadOut = toggle
end)

Citizen.CreateThread(function()
    while true do

        Citizen.Wait(2000)
        if LoadOut then
        local playerPed      = PlayerPedId()
        local loadout        = {}
        local loadoutChanged = false

        for i=1, #Config.Weapons, 1 do

            local weaponName = Config.Weapons[i].name
            local weaponHash = GetHashKey(weaponName)
            local weaponComponents = {}

            if HasPedGotWeapon(playerPed, weaponHash, false) and weaponName ~= 'WEAPON_UNARMED' then
                local ammo = GetAmmoInPedWeapon(playerPed, weaponHash)
                local components = Config.Weapons[i].components

                for j=1, #components, 1 do
                    if HasPedGotWeaponComponent(playerPed, weaponHash, components[j].hash) then
                        table.insert(weaponComponents, components[j].name)
                    end
                end

                if LastLoadout[weaponName] == nil or LastLoadout[weaponName] ~= ammo then
                    loadoutChanged = true
                end

                LastLoadout[weaponName] = ammo

                table.insert(loadout, {
                    name = weaponName,
                    ammo = ammo,
                    label = Config.Weapons[i].label,
                    components = weaponComponents
                })
            else
                if LastLoadout[weaponName] ~= nil then
                    loadoutChanged = true
                end

                LastLoadout[weaponName] = nil
            end

        end

        if loadoutChanged and LoadoutLoaded then
            -- defensive: guarantee every field is a safe, consistent type
            -- before this goes over the network (a NaN/nil/wrong-typed
            -- ammo or component value is the classic cause of FiveM's
            -- "event was not safe for net" warning)
            for _, w in ipairs(loadout) do
                w.ammo = tonumber(w.ammo) or 0
                w.name = tostring(w.name)
                w.label = tostring(w.label or w.name)
                if type(w.components) == 'table' then
                    local cleaned = {}
                    for _, c in ipairs(w.components) do
                        if type(c) == 'string' then table.insert(cleaned, c) end
                    end
                    w.components = cleaned
                else
                    w.components = {}
                end
            end
            ESX.PlayerData.loadout = loadout
            TriggerServerEvent('updateLoadout', loadout)
        end
    end
    end
end)

RegisterNetEvent('es:spawnMaxVehicle')
AddEventHandler('es:spawnMaxVehicle', function(model, turbo)
	local playerPed = PlayerPedId()
	local coords    = GetEntityCoords(playerPed)

	ESX.Game.SpawnVehicle(model, coords, 90.0, function(vehicle)
		TaskWarpPedIntoVehicle(playerPed,  vehicle, -1)
		SetVehicleMaxMods(vehicle, turbo)
	end)
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(2000)
		local playerId = PlayerId()
		SetPlayerHealthRechargeMultiplier(playerId , 0.0)
		SetMaxWantedLevel(0)
	end
end)

Citizen.CreateThread(function()
	while true do

		Citizen.Wait(1)

		local playerPed = PlayerPedId()
		local coords    = GetEntityCoords(playerPed)


		if next(Pickups) == nil then
			Citizen.Wait(500)
		end

		for k,v in pairs(Pickups) do
			local targetx = vector3(v.coords.x, v.coords.y, v.coords.z)
			local distance = #(coords - targetx)



			if distance <= 5.0 then
				ESX.Game.Utils.DrawText3D({
					x = v.coords.x,
					y = v.coords.y,
					z = v.coords.z + 0.25
				}, v.label)
			end

			if distance <= 1.0 and not v.inRange and not IsPedSittingInAnyVehicle(playerPed) then
				ESX.Game.Utils.DrawText3D({
					x = v.coords.x,
					y = v.coords.y,
					z = v.coords.z + 0.5
				}, 'Baraye Bardashtan [~y~E~w~] Ra bezanid')
				if IsControlJustPressed(0, 38) then
					PlaySoundFrontend(-1, 'PICK_UP', 'HUD_FRONTEND_DEFAULT_SOUNDSET', false)
					local dictname = "weapons@first_person@aim_rng@generic@projectile@thermal_charge@"
					RequestAnimDict(dictname)
						if not HasAnimDictLoaded(dictname) then
							RequestAnimDict(dictname)
							while not HasAnimDictLoaded(dictname) do
								Citizen.Wait(1)
							end
						end
					TaskPlayAnim(PlayerPedId(), 'weapons@first_person@aim_rng@generic@projectile@thermal_charge@', 'plant_floor', 8.0, -8,3750, 2, 0, 0, 0, 0)
					Citizen.Wait(850)
					v.inRange = true
					Citizen.Wait(1000)
					ClearPedTasks(PlayerPedId())
					Wait(math.random(0,500))
					TriggerServerEvent('esx:onPickup', v.id)
				end
			end

		end

	end
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(2000)

		local playerPed = PlayerPedId()
		if IsEntityDead(playerPed) and PlayerSpawned then
			PlayerSpawned = false
		end
	end
end)

Citizen.CreateThread(function()
	local show   = false
	while true do
	  local entity = ESX.Game.GetVehicleInDirection(Config.TargetDistance)
	  if entity > 0 then
		if not show then
		  show = true
		  SendNUIMessage({
			action	= 'show',
			show    = true
		  })
		end
	  else
		if show then
		  show = false
		  SendNUIMessage({
			action	= 'show',
			show    = false
		  })
		end
	  end
	  Citizen.Wait(2000)
	end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)

        HideHudComponentThisFrame(3)
        HideHudComponentThisFrame(4)
        HideHudComponentThisFrame(13)
        HideHudComponentThisFrame( 7 )
		HideHudComponentThisFrame( 9 )
		if(states.frozen)then
			ClearPedTasksImmediately(PlayerPedId())
			SetEntityCoords(PlayerPedId(), states.frozenPos)
		end
    end
end)

local heading = 0

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(1)

		if(noclip)then
			SetEntityCoordsNoOffset(PlayerPedId(), noclip_pos.x, noclip_pos.y, noclip_pos.z, 0, 0, 0)

			if(IsControlPressed(1, 34))then
				heading = heading + 1.5
				if(heading > 360)then
					heading = 0
				end

				SetEntityHeading(PlayerPedId(), heading)
			end

			if(IsControlPressed(1, 9))then
				heading = heading - 1.5
				if(heading < 0)then
					heading = 360
				end

				SetEntityHeading(PlayerPedId(), heading)
			end

			if(IsControlPressed(1, 8))then
				noclip_pos = GetOffsetFromEntityInWorldCoords(PlayerPedId(), 0.0, 1.0, 0.0)
			end

			if(IsControlPressed(1, 32))then
				noclip_pos = GetOffsetFromEntityInWorldCoords(PlayerPedId(), 0.0, -1.0, 0.0)
			end

			if(IsControlPressed(1, 27))then
				noclip_pos = GetOffsetFromEntityInWorldCoords(PlayerPedId(), 0.0, 0.0, 1.0)
			end

			if(IsControlPressed(1, 173))then
				noclip_pos = GetOffsetFromEntityInWorldCoords(PlayerPedId(), 0.0, 0.0, -1.0)
			end
		else
			Citizen.Wait(200)
		end
	end
end)

