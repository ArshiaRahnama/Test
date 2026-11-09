-- Pub by FleeX Team , https://discord.gg/87rGBxgCsa

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
local LastLoadout   = {}
local Pickups       = {}
local nearPickups = {}
local isDead        = false
local states = {}
local weaponSlot2 = {}
InRealWorld = true
local savecoords = true
local givedWeapon = {}
local lastHP, lastVest = 0, 0
local currentWeapon, currentWeaponHash = nil, nil
states.frozen = false
states.frozenPos = nil
local lastAmmo = {}
local ammoUpdated
local timeCycles = {}

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)

		if NetworkIsSessionStarted() then
			TriggerServerEvent('JoinCheck')
			SetThisScriptCanRemoveBlipsCreatedByAnyScript(true)
			return
		end
	end
end)

function DBSave()
	ESX.TriggerServerEvent('sun:saveme')
	Citizen.SetTimeout(5 * 1000 * 60, DBSave)
end

Citizen.SetTimeout(5 * 1000 * 60, DBSave)

function TimeCheck()
	ESX.TriggerServerEvent('core:timeCheck')
	Citizen.SetTimeout(15 * 1000 * 60, TimeCheck)
end

Citizen.SetTimeout(15 * 1000 * 60, TimeCheck)

local loaded = false
local oldPos

AddEventHandler('esx:updatecoords',function(state)
	savecoords = state
end)

RegisterNetEvent('esx:changeworld')
AddEventHandler('esx:changeworld',function(world, dontClear)
	ESX.deleteNearAttachedObject()
	ESX.PlayerData.World = world
	if world == 0 then
		InRealWorld = true
		Wait(5000)
		if not dontClear then
			TriggerEvent('esx:restoreLoadout')
			if lastHP ~= 0 and lastHP < GetEntityHealth(PlayerPedId()) then
				ESX.SetEntityHealth(PlayerPedId(), lastHP)
			end

			if lastVest ~= 0 and lastVest < GetPedArmour(PlayerPedId()) then
				SetPedArmour(PlayerPedId(), lastVest)
			end
		end
		Wait(1000)
		LoadoutLoaded = true
	else
		if not dontClear then
			lastHP = GetEntityHealth(PlayerPedId())
			lastVest = GetPedArmour(PlayerPedId())
		end
		InRealWorld = false
		LoadoutLoaded = false
		CreateThread(function ()
			while not InRealWorld do
				Wait(5000)
				if not InRealWorld then
					TriggerServerEvent('core:securiyWorldCheck', ESX.PlayerData.World)
				end
				Wait(60000)
			end
		end)
	end
end)

RegisterNetEvent('esx:stateweaponcheck')
AddEventHandler('esx:stateweaponcheck',function(state)
	InRealWorld = state
end)

ESX.RegisterClientCallback('core:getCachedWorld', function(cb)
	cb(ESX.PlayerData.World)
end)

-- Citizen.CreateThread(function()
--     local ts = GetGameTimer()
--     while true do
--         if GetGameTimer() - ts > 1500 then
-- 			TriggerEvent("esx:connectionlost")
-- 			TriggerServerEvent("esx:connectionlost")
--         end
--         ts = GetGameTimer()
-- 		Wait(1000)
--     end
-- end)

AddEventHandler("esx:connectionlost",function()
	savecoords = false
	ESX.SetEntityCoords(PlayerPedId(),oldPos)
	savecoords = true
end)

Citizen.CreateThread(function()
	NetworkSetFriendlyFireOption(true)
end)

local myDecorators = {}

local enableNative = {}

local firstSpawn = true
AddEventHandler("playerSpawned", function()
	while not ESX.PlayerLoaded do
		Citizen.Wait(1)
	end

	local playerPed = PlayerPedId()

	if firstSpawn then
		ESX.SetEntityCoords(playerPed, ESX.PlayerData.lastPosition.x, ESX.PlayerData.lastPosition.y, ESX.PlayerData.lastPosition.z - 1)
		TriggerEvent('es_admin:freezePlayer', true)
		SetTimeout(10000,function()
			TriggerEvent('es_admin:freezePlayer', false)
		end)
		TriggerEvent('char:teleported')
	end
	firstSpawn = false
	isDead = false
end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
	ESX.PlayerData   = xPlayer
	ESX.PlayerData.World = 0
	ESX.permission_level = xPlayer.permission_level
	ESX.identifier = ESX.PlayerData.identifier
	ESX.PlayerData.name2 = ESX.PlayerData.name:gsub('_', ' ')
	-- Citizen.SetTimeout(15 * 1000 * 60,DBSave)
	ClearPlayerWantedLevel(PlayerId())
	SetMaxWantedLevel(0)
	ESX.TriggerServerCallback('core:GetItems',function(items)
		ESX.items = items
		ESX.itemLoaded = true
	end)
	ESX.PlayerLoaded = true
end)

RegisterNetEvent('esx:newPofak', function(pofak)
	ESX.PlayerData.pofakNamaki = pofak
end)

RegisterNetEvent('esx:loadphone', function(number)
	while not ESX.PlayerLoaded do Wait(100) end
	ESX.PlayerData.phoneNumber = number
end)


AddEventHandler("loading:Loaded", function()
	Citizen.CreateThread(function()
		while not ESX.PlayerLoaded do
			Citizen.Wait(1000)
		end
		TriggerEvent("esx:restoreLoadout")
	end)
end)

RegisterNetEvent("esx:bringrange")
AddEventHandler("esx:bringrange",function(traget,range)
	Wait(math.random(1000,5000))
	if not ESX.Game.PlayerExist(traget) then return end
	if traget == nil or range == nil then return end
	local coords1 = GetEntityCoords(GetPlayerPed(-1))
	local coords2 = GetEntityCoords(GetPlayerPed(GetPlayerFromServerId(traget)))
	if GetDistanceBetweenCoords(coords1.x,coords1.y,coords1.z,coords2.x,coords2.y,coords2.z) < tonumber(range) then
		ESX.SetEntityCoords(GetPlayerPed(-1),coords2)
		TriggerEvent("chatMessage", "SYSTEM", {255, 0, 0}, "Shoma bring shodid", 'plarms')
	end
end)

RegisterNetEvent('es_admin:vehRepair')
AddEventHandler('es_admin:vehRepair', function(veh)
	local vehicle = tonumber(veh)
	if DoesEntityExist(vehicle) then
		ESX.SetVehicleFixed(vehicle)
		SetVehicleDirtLevel(vehicle, 0.0)
	end
	Citizen.CreateThread(function()
		Citizen.Wait(1000)
		ESX.setVehicleFuel(vehicle, 100.0)
	end)
end)

RegisterNetEvent("SetCoord")
AddEventHandler("SetCoord", function(x, y, z)
	ESX.SetEntityCoords(GetPlayerPed(-1),x, y, z)
end)

RegisterNetEvent('addCarPlayer', function(newOwner, plate, temp)
	local ped = GetPlayerPed(-1)
	local vehicle  = GetVehiclePedIsIn(ped, false)
	local vehtype = "car"
	if IsPedInAnyBoat(ped) or ESX.submarines[GetEntityModel(vehicle)] then
		vehtype = "boat"
	elseif IsPedInAnyPlane(ped) then
		vehtype = "aircraft"
	elseif IsPedInAnyHeli(ped) then
		vehtype = "heli"
	end
	local newPlate
	if plate then
		newPlate = plate
	else
		newPlate = ESX.generatePlate()
	end
	local vehicleProps = ESX.Game.GetVehicleProperties(vehicle)
	vehicleProps.plate = newPlate
	ESX.SetVehicleNumberPlateText(vehicle, newPlate)
	ESX.TriggerServerEvent('vehicle:AdminsetVehicleOwnedPlayerId', newOwner, vehicleProps, vehtype, temp)
end)

RegisterNetEvent('addGangCar')
AddEventHandler('addGangCar', function(newOwner, plate)
	local ped = GetPlayerPed(-1)
	local vehicle  = GetVehiclePedIsIn(PlayerPedId(-1), false)
	local newPlate
	if plate then
		newPlate = plate
	else
		newPlate = ESX.generatePlate()
	end
	local vehicleProps = ESX.Game.GetVehicleProperties(vehicle)
	vehicleProps.plate = newPlate
	ESX.SetVehicleNumberPlateText(vehicle, newPlate)
	local vehtype = "car"
	if IsPedInAnyBoat(ped) or ESX.submarines[GetEntityModel(vehicle)] then
		vehtype = "boat"
	elseif IsPedInAnyPlane(ped) then
		vehtype = "aircraft"
	elseif IsPedInAnyHeli(ped) then
		vehtype = "heli"
	end
	ESX.TriggerServerEvent('vehicle:setVehicleGangss', vehicleProps, newOwner,vehtype)
end)

RegisterNetEvent('es_admin:heal')
AddEventHandler('es_admin:heal', function()
	ESX.SetEntityHealth(PlayerPedId(), 200)
end)

RegisterNetEvent('es_admin:kill')
AddEventHandler('es_admin:kill', function()
	ESX.SetEntityHealth(PlayerPedId(), 0)
end)

RegisterNetEvent('es_admin:setdmg')
AddEventHandler('es_admin:setdmg', function(dmg)
	ESX.SetEntityHealth(PlayerPedId(), dmg)
end)

RegisterNetEvent('es_admin:slap')
AddEventHandler('es_admin:slap', function()
	local ped = PlayerPedId()

	ApplyForceToEntity(ped, 1, 9500.0, 3.0, 7100.0, 1.0, 0.0, 0.0, 1, false, true, false, false)
end)

RegisterNetEvent('es_admin:teleportUser')
AddEventHandler('es_admin:teleportUser', function(coords)
	local ped = GetPlayerPed(-1)
	if IsPedInAnyVehicle(ped) then
		local vehicle = GetVehiclePedIsIn(ped)

		if GetPedInVehicleSeat(vehicle, -1) == ped then
			ped = GetVehiclePedIsIn(ped)
		end

	end

	ESX.Game.Teleport(ped, coords)
end)

RegisterNetEvent('es_admin:teleportUserwithoutcar')
AddEventHandler('es_admin:teleportUserwithoutcar', function(coords)
	local ped = GetPlayerPed(-1)
	ESX.Game.Teleport(ped, coords)
end)

RegisterNetEvent('es_admin:freezePlayer')
AddEventHandler("es_admin:freezePlayer", function(state)
	local player = PlayerId()

	local ped = PlayerPedId()

	states.frozen = state
	states.frozenPos = GetEntityCoords(ped, false)

	if not state then
		if not IsEntityVisible(ped) then
			exports.suncore:SetPlayerVisible(true)
		end

		if not IsPedInAnyVehicle(ped) then
			SetEntityCollision(ped, true)
		end

		FreezeEntityPosition(ped, false)
	--	SetPlayerInvincible(player, false)
	else
		SetEntityCollision(ped, false)
		FreezeEntityPosition(ped, true)
	--	SetPlayerInvincible(player, true)

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
	noclipThread()
	if(noclip)then
		msg = "enabled"
	end

	TriggerEvent("chatMessage", "SYSTEM", {255, 0, 0}, "Noclip has been ^2^*" .. msg, 'alarms')
end)

RegisterNetEvent('moneyUpdate')
AddEventHandler('moneyUpdate', function(m)
	ESX.PlayerData.money = m
end)

RegisterNetEvent('bankUpdate')
AddEventHandler('bankUpdate', function(m)
	ESX.PlayerData.bank = m
end)

RegisterNetEvent('tcUpdate', function(_tc)
	ESX.PlayerData.tc = _tc
end)

AddEventHandler('esx:onPlayerDeath', function()
	isDead = true
end)


RegisterNetEvent('esx:updateLoadout')
AddEventHandler('esx:updateLoadout', function(loadout)
	ESX.PlayerData.loadout = loadout
end)

RegisterNetEvent('esx:updateInventory')
AddEventHandler('esx:updateInventory', function(inv)
	ESX.PlayerData.inventory = inv
end)

AddEventHandler('esx:restoreLoadout', function()
	LoadoutLoaded = true
	-- exports['sunset_utils']:waitForScriptLoad('stuff', 'inventory-client')
	weaponSlot, weaponSlot2 = exports['sun-inventory-hud']:getWeaponSlot()
	local playerPed = PlayerPedId()
	local ammoTypes = {}
	RemoveAllPedWeapons(playerPed, true)
	for k,v in ipairs(ESX.PlayerData.loadout) do
		if weaponSlot2[v.metadata.serial] then
			givedWeapon[v.metadata.serial] = true
			local weaponName = v.name
			local weaponHash = ESX.getWeaponHash(weaponName)
			local weaponName2 = ESX.GetWeaponFromHash(weaponHash).name
			GiveWeaponToPed(playerPed, weaponHash, 0, false, false)
			SetPedWeaponTintIndex(playerPed, weaponHash, v.tintIndex)

			local ammoType = GetPedAmmoTypeFromWeapon(playerPed, weaponHash)

			for k2,v2 in ipairs(v.components) do
				local componentHash = ESX.GetWeaponComponent(weaponName2, v2).hash
				GiveWeaponComponentToPed(playerPed, weaponHash, componentHash)
			end

			if not ammoTypes[ammoType] then
				if v.ammo == -1 then v.ammo = 0 end
				AddAmmoToPed(playerPed, weaponHash, v.ammo)
				ammoTypes[ammoType] = true
			end
			TriggerEvent('weapon:applyWeapon', weaponName)
		end
	end
end)

AddEventHandler('core:reloadWeaponComponent', function(name)
	weaponSlot, weaponSlot2 = exports['sun-inventory-hud']:getWeaponSlot()
	local playerPed = PlayerPedId()
	for k,v in ipairs(ESX.PlayerData.loadout) do
		if v.name == name and weaponSlot2[v.metadata.serial] then
			givedWeapon[v.metadata.serial] = true
			local weaponName = v.name
			local weaponHash = ESX.getWeaponHash(weaponName)
			local weaponName2 = ESX.GetWeaponFromHash(weaponHash).name
			SetPedWeaponTintIndex(playerPed, weaponHash, v.tintIndex)

			for k2,v2 in ipairs(v.components) do
				local componentHash = ESX.GetWeaponComponent(weaponName2, v2).hash
				GiveWeaponComponentToPed(playerPed, weaponHash, componentHash)
			end
		end
	end
end)

RegisterNetEvent('core:client:giveWeapon', function(serial)
	weaponSlot, weaponSlot2 = exports['sun-inventory-hud']:getWeaponSlot()
	local playerPed = PlayerPedId()
	local ammoTypes = {}
	for k,v in ipairs(ESX.PlayerData.loadout) do
		if v.metadata.serial == serial and not givedWeapon[v.metadata.serial] then
			givedWeapon[v.metadata.serial] = true
			local weaponName = v.name
			local weaponHash = ESX.getWeaponHash(weaponName)
			GiveWeaponToPed(playerPed, weaponHash, 0, false, false)
			SetPedWeaponTintIndex(playerPed, weaponHash, v.tintIndex)

			local ammoType = GetPedAmmoTypeFromWeapon(playerPed, weaponHash)

			for k2,v2 in ipairs(v.components) do
				local componentHash = ESX.GetWeaponComponent(weaponName, v2).hash
				GiveWeaponComponentToPed(playerPed, weaponHash, componentHash)
			end

			-- if not ammoTypes[ammoType] then
			-- 	if v.ammo == -1 then v.ammo = 0 end
			-- 	AddAmmoToPed(playerPed, weaponHash, v.ammo)
			-- 	ammoTypes[ammoType] = true
			-- end
			-- SetPedAmmo(PlayerPedId(), weaponHash, v.ammo)
			TriggerEvent('weapon:applyWeapon', weaponName)
			break
		end
	end
end)

RegisterNetEvent('core:client:removeWeapon', function(serial, name)
	weaponSlot, weaponSlot2 = exports['sun-inventory-hud']:getWeaponSlot()
	lastAmmo[name] = nil
	if givedWeapon[serial] then
		local ped = PlayerPedId()
		givedWeapon[serial] = nil
		local weaponHash = ESX.getWeaponHash(name)
		RemoveWeaponFromPed(ped, weaponHash)
		-- SetPedAmmo(ped, weaponHash, 0)
	end
end)
RegisterNetEvent('core:removeWeapon', function(name, serial)
	if givedWeapon[serial] then
		local ped = PlayerPedId()
		givedWeapon[serial] = nil
		local weaponHash = ESX.getWeaponHash(name)
		RemoveWeaponFromPed(ped, weaponHash)
		-- SetPedAmmo(ped, weaponHash, 0)
	end
end)

RegisterNetEvent('esx:addInventoryItem')
AddEventHandler('esx:addInventoryItem', function(item, count)
	if item then
		ESX.UI.ShowInventoryItemNotification(true, item, count)
	end
end)

RegisterNetEvent('esx:removeInventoryItemss')
AddEventHandler('esx:removeInventoryItemss', function(item, count)
	if item then
		ESX.UI.ShowInventoryItemNotification(false, item, count)
	end
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
	ESX.PlayerData.job = job
end)

RegisterNetEvent('esx:setGang')
AddEventHandler('esx:setGang', function(gang)
	ESX.PlayerData.gang = gang
	TriggerEvent('gang:clearPermCache')
end)


RegisterNetEvent('esx:addWeapon')
AddEventHandler('esx:addWeapon', function(weaponName, ammo)
	local playerPed = PlayerPedId()
	local weaponHash = ESX.getWeaponHash(weaponName)

	GiveWeaponToPed(playerPed, weaponHash, ammo, false, false)
end)

RegisterNetEvent('core:addWeaponComponent', function(weaponName, serial, weaponComponent)
	local playerPed = PlayerPedId()
	local weaponHash = ESX.getWeaponHash(weaponName)
	local componentHash = ESX.GetWeaponComponent(weaponName, weaponComponent).hash
	weaponSlot, weaponSlot2 = exports['sun-inventory-hud']:getWeaponSlot()
	if weaponSlot2[serial] then
		GiveWeaponComponentToPed(playerPed, weaponHash, componentHash)
	end
	for k, v in pairs(ESX.PlayerData.loadout) do
		if v.metadata.serial == serial then
			table.insert(v.components, weaponComponent)
			break
		end
	end
end)

RegisterNetEvent('esx:setWeaponAmmo')
AddEventHandler('esx:setWeaponAmmo', function(weaponName, serial, weaponAmmo)
	local playerPed = PlayerPedId()
	local weaponHash = ESX.getWeaponHash(weaponName)
	for k, v in pairs(ESX.PlayerData.loadout) do
		if v.metadata.serial == serial then
			v.ammo = weaponAmmo
		end
	end
	if weaponSlot2[serial] then
		SetPedAmmo(playerPed, weaponHash, weaponAmmo)
	end
end)

RegisterNetEvent('core:setWeaponTint', function(weaponName, serial, weaponTintIndex)
	local playerPed = PlayerPedId()
	local weaponHash = ESX.getWeaponHash(weaponName)
	weaponSlot, weaponSlot2 = exports['sun-inventory-hud']:getWeaponSlot()
	if weaponSlot2[serial] then
		SetPedWeaponTintIndex(playerPed, weaponHash, weaponTintIndex)
	end
	for k, v in pairs(ESX.PlayerData.loadout) do
		if v.metadata.serial == serial then
			v.tintIndex = weaponTintIndex
			break
		end
	end
end)

RegisterNetEvent('esx:removeWeapon')
AddEventHandler('esx:removeWeapon', function(weaponName)
	local playerPed = PlayerPedId()
	local weaponHash = ESX.getWeaponHash(weaponName)

	RemoveWeaponFromPed(playerPed, weaponHash)
	-- SetPedAmmo(playerPed, weaponHash, 0) -- remove leftover ammo
end)

RegisterNetEvent('core:removeWeaponComponent', function(weaponName, serial, weaponComponent)
	local playerPed = PlayerPedId()
	local weaponHash = ESX.getWeaponHash(weaponName)
	local componentHash = ESX.GetWeaponComponent(weaponName, weaponComponent).hash
	weaponSlot, weaponSlot2 = exports['sun-inventory-hud']:getWeaponSlot()
	if weaponSlot2[serial] then
		RemoveWeaponComponentFromPed(playerPed, weaponHash, componentHash)
	end
	for k, v in pairs(ESX.PlayerData.loadout) do
		if v.metadata.serial == serial then
			for k2, v2 in pairs(v.components) do
				if v2 == weaponComponent then
					table.remove(v.components, k2)
					break
				end
			end
			break
		end
	end
end)

RegisterNetEvent('esx:teleport')
AddEventHandler('esx:teleport', function(pos)
	exports.suncore:Whitelist(true)
	Wait(100)
	pos.x = pos.x + 0.0
	pos.y = pos.y + 0.0
	pos.z = pos.z + 0.0

	RequestCollisionAtCoord(pos.x, pos.y, pos.z)

	while not HasCollisionLoadedAroundEntity(PlayerPedId()) do
		RequestCollisionAtCoord(pos.x, pos.y, pos.z)
		Citizen.Wait(1)
	end

	ESX.SetEntityCoords(PlayerPedId(), pos.x, pos.y, pos.z)
	if pos.w then SetEntityHeading(PlayerPedId(), pos.w) end

	Citizen.CreateThread(function()
		Citizen.Wait(2000)
		exports.suncore:Whitelist(false)
	end)
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
	if ESX.GetPlayerData().permission_level > 0 then
		local playerPed = PlayerPedId()
		local coords    = GetEntityCoords(playerPed)

		ESX.Game.SpawnVehicle(model, coords, GetEntityHeading(playerPed), function(vehicle)
			TaskWarpPedIntoVehicle(playerPed,  vehicle, -1)
			ESX.TriggerServerEvent('givecarkey',ESX.Math.Trim(GetVehicleNumberPlateText(vehicle)),GetEntityModel(vehicle))
			Citizen.CreateThread(function()
					Citizen.Wait(1000)
					ESX.setVehicleFuel(GetVehiclePedIsIn(GetPlayerPed(-1)), 100.0)
			end)
		end)
	else
		TriggerServerEvent('cheat:banme','Try To Spawn Vehicle With ESX Event')
	end
end)

local spawnVeh2List = {}
local spawnVeh2Count = 0

RegisterNetEvent('esx:spawnVehicle2')
AddEventHandler('esx:spawnVehicle2', function(model)
	if spawnVeh2Count > 5 then
		spawnVeh2Count = spawnVeh2Count - 1
		for k, v in ipairs(spawnVeh2List) do
			ESX.Game.DeleteVehicle(v)
			table.remove(spawnVeh2List, k)
			break
		end
	end
	local playerPed = PlayerPedId()
	local coords    = GetEntityCoords(playerPed)
	ESX.Game.SpawnVehicle(model, coords, GetEntityHeading(playerPed), function(vehicle)
		TaskWarpPedIntoVehicle(playerPed,  vehicle, -1)
		spawnVeh2Count = spawnVeh2Count + 1
		table.insert(spawnVeh2List, vehicle)
		ESX.TriggerServerEvent('givecarkey',ESX.Math.Trim(GetVehicleNumberPlateText(vehicle)),GetEntityModel(vehicle))
		Citizen.CreateThread(function()
			Citizen.Wait(1000)
			ESX.setVehicleFuel(GetVehiclePedIsIn(GetPlayerPed(-1)), 100.0)
		end)
	end)
end)

RegisterNetEvent('esx:createvehiclekey')
AddEventHandler('esx:createvehiclekey', function()
	local ped = PlayerPedId()
	local vehicle = GetVehiclePedIsIn(ped, false)
	if GetPedInVehicleSeat(vehicle, -1) == ped then
		ESX.TriggerServerEvent('givecarkey',ESX.Math.Trim(GetVehicleNumberPlateText(vehicle)),GetEntityModel(vehicle))
	else
		local thread  = true
		Citizen.SetTimeout(5000,function()
			thread = false
		end)
		while thread do
			Wait(1)
			local ped = PlayerPedId()
			local vehicle = GetVehiclePedIsIn(ped, false)
			if GetPedInVehicleSeat(vehicle, -1) == ped then
				ESX.TriggerServerEvent('givecarkey',ESX.Math.Trim(GetVehicleNumberPlateText(vehicle)),GetEntityModel(vehicle))
				thread = false
			end
		end
	end
end)

RegisterNetEvent('esx:spawnObject')
AddEventHandler('esx:spawnObject', function(model, cb)
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
		if cb then cb(obj) end
	end)
end)

RegisterNetEvent('esx:pickup')
AddEventHandler('esx:pickup', function(id, label, model, player,crds,forw,world,item,count,type)
	local ped = GetPlayerPed(GetPlayerFromServerId(player))
	local coords  = vector3(crds.x,crds.y,crds.z)
	local forward = forw
	local x, y, z = table.unpack(coords + forward * 0.5)
	if world == ESX.PlayerData.World then
		ESX.Game.SpawnLocalObject(model, {
			x = x,
			y = y,
			z = z
		}, function(obj)
			SetEntityHeading(obj, GetEntityHeading(PlayerPedId()))
			PlaceObjectOnGroundProperly(obj)
			SetEntityAsMissionEntity(obj, true, false)
			-- FreezeEntityPosition(obj,true)
			Pickups[id] = {
				id = id,
				obj = obj,
				label = label,
				type = type,
				world = world,
				model = model,
				inRange = false,
				item = item,
				count = count,
				coords = {
					x = x,
					y = y,
					z = z
				}
			}
		end)
	else
		Pickups[id] = {
			id = id,
			obj = 0,
			label = label,
			world = world,
			type = type,
			inRange = false,
			item = item,
			count = count,
			coords = {
				x = x,
				y = y,
				z = z
			}
		}
	end
end)

RegisterNetEvent('esx:pickupUpdate')
AddEventHandler('esx:pickupUpdate', function(id, label,count)
	if Pickups[id] then
		Pickups[id].label = label
		Pickups[id].count = count
		Pickups[id].inRange = false
	end
end)

RegisterNetEvent('esx:removePickup')
AddEventHandler('esx:removePickup', function(id)
	if Pickups[id] then
		ESX.Game.DeleteObject(Pickups[id].obj)
		Pickups[id] = nil
		nearPickups[id] = nil
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
	local vehicle   = ESX.Game.GetVehicleInDirection(Config.TargetDistance)

	if IsPedInAnyVehicle(playerPed, true) then
		vehicle = GetVehiclePedIsIn(playerPed, false)
	end

	if DoesEntityExist(vehicle) then
		ESX.Game.DeleteVehicle(vehicle)
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
		ESX.SetVehicleFixed(Vehicle)
		SetVehicleDirtLevel(Vehicle, 0.0)
	else
		TriggerServerEvent('es_admin:vehRepair', Vehicle)
	end
end)


local canRemoveParachute = false
local antiCheatTokhm = {
	[`gadget_parachute`] = true,
	[`WEAPON_UNARMED`] = true
}

local usedClip = 0

RegisterNetEvent('core:clipUsed', function(count)
	if count > 0 then
		usedClip += count
	end
end)

local disabledWeaponThread = {}

local weaponWarn = {}

Citizen.CreateThread(function()
	local snow =`weapon_snowball`
	local parachute = `gadget_parachute`
	local unarmed = `WEAPON_UNARMED`
	Wait(10000)
	while true do
		Citizen.Wait(5000)
		local playerPed  = PlayerPedId()
		local selectedWeapon = GetSelectedPedWeapon(playerPed)
        if (LoadoutLoaded and InRealWorld) or exports['sun-robbery']:doesInRob() then
			weaponSlot, weaponSlot2 = exports['sun-inventory-hud']:getWeaponSlot()
			local ts = exports['sunset_utils']:GetServerOSTime()
			if ts then
				for i,v in ipairs(Config.Weapons) do
					if not v.skin then
						local weaponName = v.name
						local weaponHash = ESX.getWeaponHash(weaponName)
						local ammoCount = GetAmmoInPedWeapon(playerPed, weaponHash)
						local weaponUpper = string.upper(weaponName)
						local are = weaponUpper == "WEAPON_MOLOTOV" or weaponUpper == "WEAPON_BZGAS" or weaponUpper == "WEAPON_SMOKEGRENADE" or weaponUpper == 'WEAPON_FLARE'
						if weaponHash ~= snow then
							if (HasPedGotWeapon(playerPed, weaponHash, false) or are) then
								if not checkWeapon(weaponName) and not antiCheatTokhm[weaponHash] and HasPedGotWeapon(playerPed, weaponHash, false) then
									RemoveWeaponFromPed(playerPed, weaponHash)
									TriggerServerEvent("sc:adminalarm","Try To Add Weapon With Cheat Or Glitch : "..weaponName)
								else
									local k, weaponData = getWeapon(weaponName)
									if weaponData and weaponData.metadata and weaponData.metadata.serial and currentWeapon == weaponName then
										local serial = weaponData.metadata.serial
										if weaponData.metadata.expireTS and weaponData.metadata.expireTS < ts then
											TriggerServerEvent('core:removeTempWeapon', serial)
										end
										if weaponData.metadata.shots and Config.weapons2[weaponData.name].maxShots then
											local health = ESX.Math.Round(not Config.weapons2[weaponData.name].maxShots and 100 or 100 - (weaponData.metadata.shots or 0) * 100 / Config.weapons2[weaponData.name].maxShots, 1)
											if health < 11 and health > 1 and not weaponWarn[serial] then
												weaponWarn[serial] = true
												ESX.chatMessage('Aslahe shoma bezoodi kharab mishavad', 'plarms')
											end
										end

										if weaponData.metadata.shots and Config.weapons2[weaponData.name].maxShots and weaponData.metadata.shots >= Config.weapons2[weaponData.name].maxShots then
											if not disabledWeaponThread[serial] then
												disabledWeaponThread[serial] = true
												ESX.chatMessage('In aslahe niaz bar ta\'amir darad', 'plarms')
												CreateThread(function()
													local hash = Config.weapons2[weaponData.name].hash
													while disabledWeaponThread[serial] and weaponSlot2[serial] do
														if currentWeaponHash == hash then
															ESX.disableFiring()
														end
														Wait(0)
													end
													disabledWeaponThread[serial] = nil
												end)
											end
										elseif disabledWeaponThread[serial] then
											disabledWeaponThread[serial] = nil
										end
										if weaponData.metadata.expireTS and selectedWeapon == weaponHash and not exports['sun-jobs']:notBlackListCoords() then
											ESX.chatMessage('Nemitavanid az aslahe movaghat dar amaken robbery estefade konid', 'plarms')
											SetCurrentPedWeapon(playerPed, unarmed, true)
										end
										if ammoUpdated == weaponName and not (lastAmmo[weaponName] and ammoCount == lastAmmo[weaponName]) then
											local shotsCount = (lastAmmo[weaponName] or 0) - (ammoCount - usedClip)
											if shotsCount < 0 then
												shotsCount = 0
											else
												usedClip = 0
											end
											if updateAmmo(weaponName, serial, ammoCount, shotsCount) then
												lastAmmo[weaponName] = ammoCount
												TriggerServerEvent('core:updateWeaponAmmo', weaponName, serial, ammoCount, shotsCount)
											end
										end
									end
								end
								if weaponHash == parachute and not canRemoveParachute then
									canRemoveParachute = true
								end
							elseif weaponHash == parachute and canRemoveParachute then
								local k, weaponData = getWeapon(weaponName)
								if weaponData then
									ESX.TriggerServerEvent('core:removeWeapon', weaponData.metadata.serial)
									canRemoveParachute = false
								end
							end
						end
					else
						local weaponName = ESX.getRealWeaponName(v.name)
						if weaponName then
							local weaponHash = ESX.getRealWeaponHash(weaponName)
							local weaponUpper = string.upper(weaponName)
							local are = weaponUpper == "WEAPON_MOLOTOV" or weaponUpper == "WEAPON_BZGAS" or weaponUpper == "WEAPON_SMOKEGRENADE" or weaponUpper == 'WEAPON_FLARE'
							if weaponHash ~= snow then
								if (HasPedGotWeapon(playerPed, weaponHash, false) or are) then
									if not checkWeapon(weaponName) and not antiCheatTokhm[weaponHash] and HasPedGotWeapon(playerPed, weaponHash, false) then
										RemoveWeaponFromPed(playerPed, weaponHash)
										TriggerServerEvent("sc:adminalarm","Try To Add Weapon With Cheat Or Glitch : "..weaponName)
									end
								end
							end
						end
					end
				end
			end
        end
	end
end)

exports('forceUpdateAmmo', function(weaponName)
	local k, weaponData = getWeapon(weaponName)
	if weaponData and weaponData.metadata and weaponData.metadata.serial then
		local serial = weaponData.metadata.serial
		local ammoCount = GetAmmoInPedWeapon(PlayerPedId(), joaat(weaponName))
		local shotsCount = (lastAmmo[weaponName] or 0) - (ammoCount - usedClip)
		if shotsCount < 0 then
			shotsCount = 0
		else
			usedClip = 0
		end
		if updateAmmo(weaponName, serial, ammoCount, shotsCount) then
			lastAmmo[weaponName] = ammoCount
			TriggerServerEvent('core:updateWeaponAmmo', weaponName, serial, ammoCount, shotsCount)
		end
	end
end)

function checkWeapon(name)
    for k,v in ipairs(ESX.PlayerData.loadout) do
        if v.name:lower() == name:lower() then
            return true
        end
    end
    return false
end

function getWeapon(name)
	for k,v in ipairs(ESX.PlayerData.loadout) do
		if v.name:lower() == name:lower() and weaponSlot2[v.metadata.serial] then
			return k, v
		end
	end
	return
end

function updateAmmo(weaponName, serial, ammoCount, shotsCount)
	local k, v = getWeapon(weaponName)
	if v then
		if v.metadata.serial == serial then
			ESX.PlayerData.loadout[k].metadata.shots = (ESX.PlayerData.loadout[k].metadata.shots or 0) + shotsCount
			if ammoCount < v.ammo then
				ESX.PlayerData.loadout[k].ammo = ammoCount
			elseif ammoCount > v.ammo and ammoCount >= 250 then
				-- TriggerServerEvent('sc:adminalarm',('Ammo cheat %s - %s - %s - %s'):format(weaponName, v.metadata.serial,v.ammo, ammoCount))
				ESX.PlayerData.loadout[k].ammo = ammoCount
				return false
			end
		end
	end
	return true
end


-- Pickups
Citizen.CreateThread(function()
	while true do

		Citizen.Wait(2000)

		local playerPed = PlayerPedId()
		local coords    = GetEntityCoords(playerPed)

		if next(Pickups) == nil then
			Citizen.Wait(500)
		end
		local find = false
		for k,v in pairs(Pickups) do

			local distance = GetDistanceBetweenCoords(coords, v.coords.x, v.coords.y, v.coords.z, true)

			if distance <= 30.0 and v.world == ESX.PlayerData.World then
				-- ESX.Game.Utils.DrawText3D({
				-- 	x = v.coords.x,
				-- 	y = v.coords.y,
				-- 	z = v.coords.z + 0.25
				-- }, v.label)
				if not nearPickups[k] then
					nearPickups[k] = v
				end
				find = true
				if not DoesEntityExist(v.obj) then
					ESX.Game.SpawnLocalObject(v.model, {
						x = v.coords.x,
						y = v.coords.y,
						z = v.coords.z
					}, function(obj)
						SetEntityHeading(obj, GetEntityHeading(PlayerPedId()))
						PlaceObjectOnGroundProperly(obj)
						SetEntityAsMissionEntity(obj, true, false)
						Pickups[k].obj = obj
					end)
					Wait(1000)
				end
			else
				if DoesEntityExist(v.obj) then
					ESX.Game.DeleteObject(v.obj)
				end
				nearPickups[k] = false
			end
			-- (closestDistance == -1 or closestDistance > 3) and
			-- if distance <= 2.0 and not v.inRange and not IsPedSittingInAnyVehicle(playerPed) and v.world == ESX.PlayerData.World then
			-- 	ESX.Game.Utils.DrawText3D({
			-- 		x = v.coords.x,
			-- 		y = v.coords.y,
			-- 		z = v.coords.z + 0.5
			-- 	}, 'Baraye Bardashtan [~y~E~w~] Ra bezanid')
			-- end

		end
		if not find then
			Citizen.Wait(1000)
		end
	end
end)

Citizen.CreateThread(function()
	while true do

		Citizen.Wait(0)

		local playerPed = PlayerPedId()
		local coords    = GetEntityCoords(playerPed)

		-- if next(nearPickups) == nil then
		-- 	Citizen.Wait(500)
		-- end
		local find = false
		for k,v in pairs(nearPickups) do
			find = true
			if v then
				local distance = GetDistanceBetweenCoords(coords, v.coords.x, v.coords.y, v.coords.z, true)

				if distance <= 30.0 and v.world == ESX.PlayerData.World then
					ESX.Game.Utils.DrawText3D({
						x = v.coords.x,
						y = v.coords.y,
						z = v.coords.z + 0.25
					}, v.label)
				end
				-- (closestDistance == -1 or closestDistance > 3) and
				if distance <= 2.0 and not v.inRange and not IsPedSittingInAnyVehicle(playerPed) and v.world == ESX.PlayerData.World then
					ESX.Game.Utils.DrawText3D({
						x = v.coords.x,
						y = v.coords.y,
						z = v.coords.z + 0.5
					}, 'Baraye Bardashtan [~y~E~w~] Ra bezanid')
				end
			end
		end
		if not find then
			Citizen.Wait(2000)
		end
	end
end)

local pickCD = false
AddEventHandler('KeyDown:e',function(key)
	--if key == 'e' then
		-- if pickCD then return end
		if pickCD or IsPedInAnyVehicle(PlayerPedId(),true) then return end
		local playerPed = PlayerPedId()
		local coords    = GetEntityCoords(playerPed)
		local elements = {}
		for k,v in pairs(Pickups) do
			local distance = GetDistanceBetweenCoords(coords, v.coords.x, v.coords.y, v.coords.z, true)
			if distance <= 2.0 and v.world == ESX.PlayerData.World then
				local label = ''
				if v.type == 'item_weapon' then
					label = v.label
				elseif v.type == 'item_money' then
					label = 'Money (' .. v.count .. 'x)'
				else
					label = v.item.label .. ' (' .. v.count .. 'x)'
				end
				table.insert(elements,{id = v.id,label = label,count = v.count,weapon = v.type == 'item_weapon' or v.type == 'item_money'})
			end
		end
		local length = ESX.TableLength(elements)
		if length > 0 and (not ESX.GetPlayerData().IsDead and not ESX.GetPlayerData().IsInjure) then
			local coords = GetEntityCoords(PlayerPedId())
			Citizen.CreateThread(function()
				while true do
					if ESX.GetDistance(coords,GetEntityCoords(PlayerPedId())) > 5 then
						ESX.UI.Menu.CloseAll()
						break
					end
					Citizen.Wait(1000)
				end
			end)
			if length == 1 then
				local data = elements[1]
				local id = data.id
				if data.weapon then
					pickCD = true
					Citizen.SetTimeout(3000,function()
						pickCD = false
					end)
					PlaySoundFrontend(-1, 'PICK_UP', 'HUD_FRONTEND_DEFAULT_SOUNDSET', false)
					local dictname = "weapons@first_person@aim_rng@generic@projectile@thermal_charge@"
					RequestAnimDict(dictname)
						if not HasAnimDictLoaded(dictname) then
							RequestAnimDict(dictname)
							while not HasAnimDictLoaded(dictname) do
								Citizen.Wait(1)
							end
						end
					TaskPlayAnim(GetPlayerPed(-1), 'weapons@first_person@aim_rng@generic@projectile@thermal_charge@', 'plant_floor', 8.0, -8,3750, 2, 0, 0, 0, 0)
					Citizen.Wait(850)
					Citizen.Wait(1000)
					ClearPedTasks(GetPlayerPed(-1))
					Wait(math.random(0,500))
					ESX.TriggerServerEvent('esx:onPickup', id)
				else
					if data.count == 1 then
						pickCD = true
						Citizen.SetTimeout(3000,function()
							pickCD = false
						end)
						PlaySoundFrontend(-1, 'PICK_UP', 'HUD_FRONTEND_DEFAULT_SOUNDSET', false)
						local dictname = "weapons@first_person@aim_rng@generic@projectile@thermal_charge@"
						RequestAnimDict(dictname)
						if not HasAnimDictLoaded(dictname) then
							RequestAnimDict(dictname)
							while not HasAnimDictLoaded(dictname) do
								Citizen.Wait(1)
							end
						end
						TaskPlayAnim(GetPlayerPed(-1), 'weapons@first_person@aim_rng@generic@projectile@thermal_charge@', 'plant_floor', 8.0, -8,3750, 2, 0, 0, 0, 0)
						Citizen.Wait(850)
						Citizen.Wait(1000)
						ClearPedTasks(GetPlayerPed(-1))
						Wait(math.random(0,500))
						ESX.TriggerServerEvent('esx:onPickup', id, 1)
					else
						elements = {}
						table.insert(elements, {
							label = 'Enter count',
							id = id,
							type = 'slider',
							value = data.count,
							min = 1,
							max = data.count
						})
						ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'pick', {
							title    = 'Pick UP Count',
							align    = 'top-left',
							elements = elements
						}, function(data, menu)
							menu.close()
							pickCD = true
							Citizen.SetTimeout(3000,function()
								pickCD = false
							end)
							PlaySoundFrontend(-1, 'PICK_UP', 'HUD_FRONTEND_DEFAULT_SOUNDSET', false)
							local dictname = "weapons@first_person@aim_rng@generic@projectile@thermal_charge@"
							RequestAnimDict(dictname)
								if not HasAnimDictLoaded(dictname) then
									RequestAnimDict(dictname)
									while not HasAnimDictLoaded(dictname) do
										Citizen.Wait(1)
									end
								end
							TaskPlayAnim(GetPlayerPed(-1), 'weapons@first_person@aim_rng@generic@projectile@thermal_charge@', 'plant_floor', 8.0, -8,3750, 2, 0, 0, 0, 0)
							Citizen.Wait(850)
							Citizen.Wait(1000)
							ClearPedTasks(GetPlayerPed(-1))
							Wait(math.random(0,500))
							local count = data.current.value
							ESX.TriggerServerEvent('esx:onPickup', id, count)
						end, function(data, menu)
							menu.close()
							menuOpen = false
						end)
					end
				end
			else
				ESX.UI.Menu.Open("default", GetCurrentResourceName(), "Pick", {
					title = 'Pick UP',
					align = "bottom-left",
					elements = elements
				}, function(data, menu)
					menu.close()
					local id = data.current.id
					if data.current.weapon then
						pickCD = true
						Citizen.SetTimeout(3000,function()
							pickCD = false
						end)
						PlaySoundFrontend(-1, 'PICK_UP', 'HUD_FRONTEND_DEFAULT_SOUNDSET', false)
						local dictname = "weapons@first_person@aim_rng@generic@projectile@thermal_charge@"
						RequestAnimDict(dictname)
							if not HasAnimDictLoaded(dictname) then
								RequestAnimDict(dictname)
								while not HasAnimDictLoaded(dictname) do
									Citizen.Wait(1)
								end
							end
						TaskPlayAnim(GetPlayerPed(-1), 'weapons@first_person@aim_rng@generic@projectile@thermal_charge@', 'plant_floor', 8.0, -8,3750, 2, 0, 0, 0, 0)
						Citizen.Wait(850)
						Citizen.Wait(1000)
						ClearPedTasks(GetPlayerPed(-1))
						Wait(math.random(0,500))
						ESX.TriggerServerEvent('esx:onPickup', id)
					else
						pickCD = true
						Citizen.SetTimeout(3000,function()
							pickCD = false
						end)
						elements = {}
						table.insert(elements, {
							label = 'Enter count',
							id = id,
							type = 'slider',
							value = data.current.count,
							min = 1,
							max = data.current.count
						})
						ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'pick', {
							title    = 'Pick UP Count',
							align    = 'top-left',
							elements = elements
						}, function(data, menu)
							menu.close()
							pickCD = true
							Citizen.SetTimeout(3000,function()
								pickCD = false
							end)
							PlaySoundFrontend(-1, 'PICK_UP', 'HUD_FRONTEND_DEFAULT_SOUNDSET', false)
							local dictname = "weapons@first_person@aim_rng@generic@projectile@thermal_charge@"
							RequestAnimDict(dictname)
								if not HasAnimDictLoaded(dictname) then
									RequestAnimDict(dictname)
									while not HasAnimDictLoaded(dictname) do
										Citizen.Wait(1)
									end
								end
							TaskPlayAnim(GetPlayerPed(-1), 'weapons@first_person@aim_rng@generic@projectile@thermal_charge@', 'plant_floor', 8.0, -8,3750, 2, 0, 0, 0, 0)
							Citizen.Wait(850)
							Citizen.Wait(1000)
							ClearPedTasks(GetPlayerPed(-1))
							Wait(math.random(0,500))
							local count = data.current.value
							ESX.TriggerServerEvent('esx:onPickup', id, count)
						end, function(data, menu)
							menu.close()
							menuOpen = false
						end)
					end
				end, function(data, menu)
					menu.close()
				end)
			end
		end
	--end
end)



Citizen.CreateThread(function()
	local show = false
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
		Citizen.Wait(1000)
	end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        -- Not sure which one is needed so you can choose/test which of these is the one you need.
        HideHudComponentThisFrame(3) -- SP Cash display
        HideHudComponentThisFrame(4)  -- MP Cash display
        HideHudComponentThisFrame(13) -- Cash changes
        HideHudComponentThisFrame( 7 ) -- Area Name
		HideHudComponentThisFrame( 9 ) -- Street Name
		if(states.frozen)then
			ClearPedTasksImmediately(PlayerPedId())
			ESX.SetEntityCoords(PlayerPedId(), states.frozenPos)
		end
    end
end)

local heading = 0

function noclipThread()
	Citizen.CreateThread(function()
		while noclip do
			Citizen.Wait(0)
			ESX.SetEntityCoordsNoOffset(PlayerPedId(), noclip_pos.x, noclip_pos.y, noclip_pos.z, 0, 0, 0)

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
		end
	end)
end


RegisterNetEvent('heisenberg:search')
AddEventHandler('heisenberg:search', function(gun, to, serial, admin)
	ESX.TriggerServerEvent('core:searchstep2', to, gun, serial, admin)
end)

local playersdc = {}
RegisterNetEvent("playerdrop")
AddEventHandler("playerdrop",function(source,name,reason,coords)
	local coords = vector3(coords.x,coords.y,coords.z)
	if GetDistanceBetweenCoords(GetEntityCoords(GetPlayerPed(-1)), coords, true) < 50.000 then
		TriggerEvent('chatMessage', "Player disconnect" , {255, 0, 0},name .."(".. source ..") left dad | reason : " .. reason, 'plarms')
	end
end)

AddStateBagChangeHandler('msg', nil, function(bagName, k, v)
    local entity = GetEntityFromStateBagName(bagName)
    if entity ~= 0 and v then
		if #(GetEntityCoords(PlayerPedId()) - GetEntityCoords(entity)) < 50 then
			ESX.chatMessage(v)
		end
	end
end)

RegisterNetEvent('esx:clearped')
AddEventHandler('esx:clearped',function()
	local ped = PlayerPedId()
	-- ESX.SetPedArmour(ped,0)
	RemoveAllPedWeapons(ped,true)
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(5000)
        if LoadoutLoaded then
			for k,v in ipairs(ESX.PlayerData.loadout) do
				Citizen.Wait(10)
				if (v.metadata and v.metadata.serial and v.metadata.serial:find('PV')) and InRealWorld then
					TriggerServerEvent("sc:adminalarm","PVP gun in real world " .. v.name)
					TriggerServerEvent('removePVPGun')
					ESX.TriggerServerEvent('ss_cs:csMe',300,'Bug abuse #3')
				end
			end
        end
	end
end)

AddEventHandler('onResourceStop', function(resource)
	if ESX.resourceBlips[resource] then
		for k,v in pairs(ESX.resourceBlips[resource]) do
			RemoveBlip(v)
		end
		ESX.resourceBlips[resource] = nil
	end
end)

RegisterNetEvent('core:removeAllWeapon',function()
	RemoveAllPedWeapons(PlayerPedId(),true)
end)

RegisterNetEvent('core:systemMessageAtRange', function(coords, color, name, message)
	if ESX.GetDistance(GetEntityCoords(PlayerPedId()), coords.xyz) <= coords.w then
		TriggerEvent('chat:addMessage', {
			template = '<div style="padding: 0.5vw; margin: 0.5vw; background-color: rgba('.. color.x ..', '.. color.y ..', '.. color.z ..', '.. color.w ..'); border-radius: 3px;"><i class="far fa-newspaper"></i> '.. name ..':<br>  {1}</div>',
			args = {name, message}
		})
	end
end)

RegisterNetEvent('core:executeCommand', function(command)
	ExecuteCommand(command)
end)

RegisterNetEvent('core:loadSuggestion', function(suggestions, permission_level, commandsGroup)
	while not ESX.PlayerLoaded do
		Wait(100)
	end
	for k,v in pairs(suggestions) do
		local groupCheck = false
		if type(v.permission_level) == 'table' and v.permission_level.groups then
			for k, v in pairs(v.permission_level.groups) do
				if commandsGroup[v] and commandsGroup[v][ESX.PlayerData.identifier] or commandsGroup.FULL_PERM[ESX.PlayerData.identifier] then
					groupCheck = true
					break
				end
			end
		end
		if not v.permission_level or (type(v.permission_level) == 'number' and (permission_level >= v.permission_level) or type(v.permission_level) == 'table' and v.permission_level.perm and v.permission_level.perm <= permission_level or groupCheck) then
			TriggerEvent('chat:addSuggestion', '/' .. k, v.help, v.params)
		end
	end
end)

AddEventHandler('addWeaponTokhm', function(hash, state)
	antiCheatTokhm[hash] = state
end)

ESX.RegisterClientCallback('core:getNearestPlayer', function(cb, range)
	cb(ESX.Game.GetPlayersToSend(range))
end)

AddEventHandler('onSelectWeapon', function(armed, model)
	currentWeaponHash = model
	if armed and weaponSlot and (not (ESX.PlayerData.World >= 300 and ESX.PlayerData.World <= 400)) then
		for k, v in pairs(weaponSlot) do
			if ESX.getWeaponHash(v.name) == model then
				currentWeapon = v.name
				for k2, v2 in pairs(ESX.PlayerData.loadout) do
					if v2.metadata.serial == v.serial then
						SetPedAmmo(PlayerPedId(), model, v2.ammo)
						ammoUpdated = v.name
					end
				end
				break
			end
		end
	end
end)

RegisterNetEvent('core:setWayPoint', function(x, y)
	SetNewWaypoint(x + .0, y + .0)
end)

RegisterNetEvent('core:clearKvpCache', function()
	-- Wait(10000)
	-- SetResourceKvp('deadData', nil)
end)

function applyTimeCycle()
	local newTimeCycle = {}
	for k, v in pairs(timeCycles) do
		if not newTimeCycle.priority or v.priority > newTimeCycle.priority then
			newTimeCycle = v
		end
	end
	if newTimeCycle.name then
		SetTimecycleModifier(newTimeCycle.name)
		SetTimecycleModifierStrength(newTimeCycle.strength)
	else
		ClearTimecycleModifier()
	end
end

RegisterNetEvent('core:applyScreenEffect', function(name, strength, priority, add, time)
	if not timeCycles[name] and strength and priority and strength > 0 then
		timeCycles[name] = {
			name = name,
			strength = strength,
			priority = priority
		}
		if tonumber(time) then
			SetTimeout(time, function()
				timeCycles[name] = nil
				applyTimeCycle()
			end)
		end
	else
		if add then
			timeCycles[name].strength += strength
		end
		if not strength or strength <= 0 then
			timeCycles[name] = nil
		end
	end
	applyTimeCycle()
end)

RegisterNetEvent('core:oxNotif', function(type, title, description)
	lib.notify({
		title = title,
		description = description,
		type = type,
		position = 'center-right',
		duration = 8000,
	})
end)