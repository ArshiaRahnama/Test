local ESX = exports['essentialmode']:getSharedObject()

local PlayerData = {}
local loadingPassed = false
local isDead = false
local isInInventory = false
local Pickups = {}
local selectedPickUP
local Weapons = {}
local LoadoutLoaded = false
local currentSide

local CustomVehicles = {
    [`vip`] = {maxWeight = 300, slot = 200},
}

local TrunksLimit = {
    [0] = {maxWeight = 80, slot = 24}, --compacts
    [1] = {maxWeight = 100, slot = 24}, --sedans
    [2] = {maxWeight = 120, slot = 35}, --SUV's
    [3] = {maxWeight = 85, slot = 24}, --coupes
    [4] = {maxWeight = 100, slot = 24}, --muscle
    [5] = {maxWeight = 100, slot = 30}, --sport classic
    [6] = {maxWeight = 80, slot = 24}, --sport
    [7] = {maxWeight = 50, slot = 20}, --super
    [9] = {maxWeight = 130, slot = 40}, --offroad
    [10] = {maxWeight = 150, slot = 40}, --industrial
    [11] = {maxWeight = 100, slot = 35}, --Utility
    [12] = {maxWeight = 135, slot = 40}, --Vans
    [14] = {maxWeight = 120, slot = 30}, --Boats
    [15] = {maxWeight = 120, slot = 30}, --Helicopters
    [16] = {maxWeight = 200, slot = 50}, --Planes
    [17] = {maxWeight = 110, slot = 30}, --Service
    [18] = {maxWeight = 110, slot = 30}, --Emergency
    [19] = {maxWeight = 120, slot = 30}, --Military
    [20] = {maxWeight = 150, slot = 40}, --Commercial
    [21] = {maxWeight = 25, slot = 5} --Trains
}

-----------------------------------------
exports('frisk', function(id)
    TriggerServerEvent('IRV-inventory:openSide', 'frisk', id)
end)

exports('job', function(JobName, maxWeight, slot)
	if PlayerData.job.name == JobName then
    	TriggerServerEvent('IRV-inventory:openSide', 'stash', JobName, maxWeight, slot, 0, 'Job '..JobName)
	end
end)

exports('gang', function(GangName, maxWeight, slot)
	if PlayerData.gang.name == GangName then
    	TriggerServerEvent('IRV-inventory:openSide', 'stash', GangName, maxWeight, slot, 0, 'Gang '..GangName)
	end
end)

exports('stash', function(name, maxWeight, slot, label)
	TriggerServerEvent('IRV-inventory:openSide', 'stash', name, maxWeight, slot, 0, label)
end)

exports('sendTypeTrunk', function(vehicle)
	return TrunksLimit
end)

exports('HasItem', function(item, amount)
    local count = 0
    for i=1, 24, 1 do
        local slot = PlayerData.inventory[i]
        if slot then
            if slot.name == item then
                count = count + slot.count
            end
        end
    end
    if amount >= count then
        return true
    else
        return false
    end
end)
-----------------------------------------

AddEventHandler('esx:onPlayerDeath', function()
	isDead = true
	if isInInventory then
		closeInventory()
		SendNUIMessage({action = "close"})
	end
end)

AddEventHandler('playerSpawned', function()
	isDead = false
end)

AddEventHandler('loading:Loaded', function()
    Citizen.SetTimeout(1500, function()
        loadingPassed = true
    end)
end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xp)
    PlayerData = xp
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
	PlayerData.job = job
end)

RegisterNetEvent('esx:setGang')
AddEventHandler('esx:setGang', function(gang)
	PlayerData.gang = gang
end)

RegisterNetEvent('esx:updateInventory', function(data)
    PlayerData.inventory = data
end)

AddEventHandler("skinchanger:modelLoaded", function()
	LoadoutLoaded = false
	Citizen.CreateThread(function()
		while not loadingPassed do
			Citizen.Wait(1000)
		end

		TriggerServerEvent("IRV-inventory:restoreLoadout")
		TriggerServerEvent("IRV-inventory:restoreEquiped")
	end)
end)

AddEventHandler('skinchanger:loadDefaultModel', function()
	LoadoutLoaded = false
end)

RegisterNetEvent('IRV-inventory:restoreLoadout', function(inventory)
	for index=1, 24, 1 do
		local info = inventory[index]
		if info then
			local iteminfo = ESX.Items[info.name]
			if iteminfo.type == 'item_weapon' then
				if info.equiped then
					TriggerEvent('IRV-inventory:addWeapon', info)
				end
			end
		end
	end
	LoadoutLoaded = true
end)

RegisterCommand('unloadammo', function(source, args)
	local ped = PlayerPedId()
	local args1 = args[1]
	if not IsPedArmed(ped, 7) then return ESX.ShowNotification("Lotfan Gun Morde Nazar Ra select konid.") end
	if not args1 then return TriggerEvent("chatMessage", "[INFO]", {3, 190, 1},"^0Shoma dar ^3Argemant Aval^0 chizi Vared nakardid!") end  
	if not args1 then return TriggerEvent("chatMessage", "[SYSTEM]", {3, 190, 1},"^0Shoma dar in ^3ghesmat faghat^0 mitavanid ^2adad^0 vared konid.") end 
	if tonumber(args[1]) == 0 then return ESX.ShowNotification("Meghdar kheshab Invalid ast.") end
	local weaponHash = GetSelectedPedWeapon(ped)
	local weaponData = Weapons[weaponHash]
	local ammoNum = args1 and tonumber(args1)
	if weaponData and ammoNum then
		TriggerEvent("mythic_progbar:client:progress", {
			name = "unloading_ammo",
			duration = 1000,
			label = "Dar hale kharej kardan tir ha",
			useWhileDead = false,
			canCancel = false,
			controlDisables = {
			disableMovement = false,
			disableCarMovement = false,
			disableMouse = false,
			disableCombat = false,
		}
		})
		TriggerServerEvent('IRV-inventory:unloadAmmo', weaponData, ammoNum)
	end
end)

local busyanimation = false
local actionAnimations = {
	pickup = function()
		local ped = PlayerPedId()

		local dictname = "pickup_object"
		RequestAnimDict(dictname)
		if not HasAnimDictLoaded(dictname) then
			RequestAnimDict(dictname)
			while not HasAnimDictLoaded(dictname) do
				Citizen.Wait(1)
			end
		end

		busyanimation = true
		TaskPlayAnim(ped, dictname, 'pickup_low', 8.0, -8.0, -1, 1, 0, false, false, false)
		Citizen.Wait(2000)
		ClearPedTasks(ped)
		busyanimation = false
		return true
	end,
	open = function()
		local ped = PlayerPedId()
		local dictname = "mp_weapons_deal_sting"
		RequestAnimDict(dictname)
		if not HasAnimDictLoaded(dictname) then
			RequestAnimDict(dictname)
			while not HasAnimDictLoaded(dictname) do
				Citizen.Wait(1)
			end
		end
		busyanimation = true
		TaskPlayAnim(ped, dictname, "crackhead_bag_loop", 8.0, -8, -1, 1)
		local p = promise.new()
		TriggerEvent("mythic_progbar:client:progress", {
			name = "open_inventory",
			duration = 3000,
			label = "Dar hale baz kardan",
			useWhileDead = false,
			canCancel = true,
			controlDisables = {
				disableMovement = true,
				disableCarMovement = true,
				disableMouse = false,
				disableCombat = true,
			}
		}, function(status)
			if not status then
				busyanimation = false
				p:resolve(true)
			elseif status then
				busyanimation = false
				ClearPedTasks(ped)
				p:resolve(false)
			end
		end)
		return Citizen.Await(p)
	end
}

AddEventHandler("onKeyDown", function(key)
    if key == 'f2' and not isDead and (not isInInventory and loadingPassed) then
		local vehicle = ESX.Game.GetClosestVehicle()
		if vehicle ~= 0 and vehicle ~= nil then
			local ped = PlayerPedId()
			local distance = 1.5
			local coord = GetEntityCoords(ped, 1)
			local trunk = GetWorldPositionOfEntityBone(vehicle, GetEntityBoneIndexByName(vehicle, "boot"))
			local trunkExist = not ( (trunk == vector3(0, 0, 0)) or IsVehicleDoorDamaged(vehicle, 5) )
			if GetVehiclePedIsIn(ped, false) == vehicle then openInventory() return end
			if GetVehicleClass(vehicle) == 8 or GetVehicleClass(vehicle) == 13 then openInventory() return end
			if not trunkExist then trunk = GetEntityCoords(vehicle) distance = 3.5 end
			if #(coord - trunk) > distance then openInventory() return end
			if GetVehicleDoorLockStatus(vehicle) ~= 1 then openInventory() return ESX.ShowNotification("Dar sandogh vasile naghliye ghofl ast", 'error') end
			local ratio = GetVehicleDoorAngleRatio(vehicle, 5)
			if trunkExist and ratio <= 0 then openInventory() return ESX.ShowNotification("Sandogh vasile naghliye baste ast!", 'error') end
			TriggerEvent("mythic_progbar:client:progress", {
				name = "open_trunk",
				duration = 1000,
				label = "Dar hale baz kardan sandogh",
				useWhileDead = false,
				canCancel = true,
				controlDisables = {
					disableMovement = true,
					disableCarMovement = true,
					disableMouse = false,
					disableCombat = true,
				}
			}, function(status)
				if not status then
					exports['dpemotes']:EmoteCommandStart("mechanic")
					local VehMeta = TrunksLimit[GetVehicleClass(vehicle)]
					if CustomVehicles[GetEntityModel(vehicle)] then
						VehMeta = CustomVehicles[GetEntityModel(vehicle)]
					end
					TriggerServerEvent('IRV-inventory:openSide', 'trunk', VehToNet(vehicle), VehMeta.maxWeight, VehMeta.slot)
				else
					ClearPedTasks(ped)
				end
			end)
		else
			openInventory()
		end
	elseif key == "up" and not busyanimation and not isDead then
        if not selectedPickUP then return end

		local pickup = Pickups[selectedPickUP]
		if not pickup then return end

		if not pickup.inRange then return end

		local current = findPickupSelectedIndex(pickup)
		if current - 1 > 0 then
			pickup.actions[current].selected = false
			pickup.actions[current - 1].selected = true
		end
	elseif key == "down" and not busyanimation and not isDead then
		if not selectedPickUP then return end

		local pickup = Pickups[selectedPickUP]
		if not pickup then return end

		if not pickup.inRange then return end

		local current = findPickupSelectedIndex(pickup)
		if current + 1 <= #pickup.actions then
			pickup.actions[current].selected = false
			pickup.actions[current + 1].selected = true
		end
	elseif key == "e" and not busyanimation and not isDead then
		if not selectedPickUP then return end

		local pickup = Pickups[selectedPickUP]
		if not pickup then return end

		if not pickup.inRange then return end

		local current = findPickupSelectedIndex(pickup)
		local action = pickup.actions[current]
		local handle = actionAnimations[action.name]
		if handle then
			local actionDone = handle(pickup)
			if actionDone then
				Wait(math.random(0,500))
				TriggerServerEvent(action.event, pickup.id)
			end
		end
    end
end)

function getInventory()
	local p = promise.new()
	ESX.TriggerServerCallback("IRV-inventory:getInventory", function(data)
		p:resolve(data)
	end)
	return Citizen.Await(p)
end

function mergeData(data)
	local loadout = {
		items = {},
		label = data.label,
		type = data.type,
		name = data.name,
		money = data.money,
		weight = data.weight,
		maxWeight = data.maxWeight,
		slot = data.slot,
		reduction = data.reduction or 0,
		job = data.job,
		initial = data.initial,
		action = data.action,
		handle = data.handle,
		destroyStash = false
	}

	if loadout.type == 'player' then
		loadout.label = exports['esx_idoverhead']:getAlias({id = loadout.name, distance = false, mask = true})
	end

	for index = 1, data.slot, 1 do
		local info = data.inventory[index]
		if info then
			local iteminfo = ESX.Items[info.name]
			if iteminfo then
				if iteminfo.type == 'item_weapon' then
					table.insert(loadout.items,
					{
						label = iteminfo.label,
						count = info.info.ammo or 0,
						equiped = info.equiped or false,
						weight = info.weight or iteminfo.weight,
						components = info.info.components,
						tint = (info.info.tint and Config.tintsIndex[info.info.tint]) or nil,
						extras = info.info.extras,
						ammo = iteminfo.ammo,
						index = index,
						eligableIndex = iteminfo.eligableIndex or 0,
						type = iteminfo.type,
						name = iteminfo.name,
						usable = iteminfo.usable,
						canstack = not iteminfo.unique
					})
				else
					local item = {}
					item.name = info.name
					item.count = info.count
					item.index = index
					item.weight = info.weight or iteminfo.weight
					item.equiped = info.equiped
					item.eligableIndex = iteminfo.eligableIndex or 0
					item.label = info.name == "mask" and ("%s (%s-%s)"):format(iteminfo.label, (info.info.gender == 1 and 'F') or 'M', (info.info.model and info.info.model) or 0) or iteminfo.label
					item.canstack = not iteminfo.unique
					item.usable = iteminfo.usable
					item.type = iteminfo.type
					table.insert(loadout.items, item)
				end
			end
		end
	end

	return loadout
end

function openInventory(sideInventory)
	if loadingPassed then
		isInInventory = true
		local data = getInventory()
		local loadout = mergeData(data)
		local sideData = sideInventory and mergeData(sideInventory)
		currentSide = sideData and sideInventory

		TriggerScreenblurFadeIn(0)
		SendNUIMessage({
			action = "open",
			type = sideData and "side" or "normal",
			side = sideData and {loadout = sideData, label = sideData.label, type = sideData.type},
			loadout = loadout
		})
		SetNuiFocus(true, true)

		if currentSide then
			handleDistance()
		end
	end
end

function hide(status)
    loadingPassed = status
end
exports("hide", hide)

RegisterNetEvent("IRV-inventory:openInventory", openInventory)

function refreshInventory(data, side)
	if side then
		if currentSide.name ~= side.name then
			return
		end
	end
	local data = data or getInventory()
	local loadout = mergeData(data)
	local sideLoadout = side and mergeData(side)

	SendNUIMessage({
		action = "updateInventory",
		side =  (sideLoadout and {loadout = sideLoadout, label = sideLoadout.label}),
		loadout = loadout
    })
end

RegisterNetEvent("IRV-inventory:refreshInventory", refreshInventory)

function closeInventory()
	isInInventory = false
	TriggerScreenblurFadeOut(0)
	SetNuiFocus(false, false)
	if currentSide then
		ClearPedTasks(PlayerPedId())
		currentSide = nil
	end
end

RegisterNUICallback("close", function()
	if isInInventory then
		closeInventory()
	end
end)

RegisterNetEvent('IRV-inventory:closeInventory', function(id)
	if id then
		if currentSide and currentSide.name == id then
			closeInventory()
			SendNUIMessage({action = "close"})
		end
	else
		closeInventory()
		SendNUIMessage({action = "close"})
	end
end)

function handleDistance()
	if not currentSide or not currentSide.handle then return end
	local handle = nil
	if type(currentSide.handle) == "vector3" then
		handle = currentSide.handle
	else
		if currentSide.type == "trunk" then
			local thisHandle = NetworkDoesNetworkIdExist(currentSide.handle) and NetworkGetEntityFromNetworkId(currentSide.handle)
			if not thisHandle then return end
			handle = DoesEntityExist(thisHandle) and thisHandle
			if not handle then return end
		elseif currentSide.type == "player" then
			local thisHandle = GetPlayerFromServerId(currentSide.handle)
			handle = GetPlayerPed(thisHandle)
			if not handle then return end
		end
	end
	Citizen.CreateThread(function()
	    local ped = PlayerPedId()
		local distance = (currentSide.type == "trunk" and 5) or 1.5
		while currentSide and handle do
			local coords = GetEntityCoords(ped)
			local tcoords = (type(handle) == "vector3" and handle) or GetEntityCoords(handle)
			if #(coords - tcoords) > distance then
				handle = nil
				closeInventory()
				SendNUIMessage({action = "close"})
				break
			end
			Citizen.Wait(500)
		end
	end)
end

RegisterNUICallback("destroyStash", function(data)
	TriggerServerEvent("IRV-inventory:stashDestroyItem", data.type, data.index)
end)

RegisterNUICallback("give", function(data)
	closeInventory()
	SendNUIMessage({action = "close"})
	TriggerServerEvent("IRV-inventory:giveItem", data)
end)

RegisterNetEvent("IRV-inventory:giveAnimation", function()
    if not IsPedInAnyVehicle(PlayerPedId(), false) then
        RequestAnimDict('anim@heists@keycard@')
		while not HasAnimDictLoaded("anim@heists@keycard@") do
			Wait(7)
		end
        ClearPedSecondaryTask(PlayerPedId())
        TaskPlayAnim( PlayerPedId(), "anim@heists@keycard@", "exit", 8.0, 1.0, -1, 16, 0, 0, 0, 0 )
        Citizen.Wait(850)
        ClearPedTasks(PlayerPedId())
    end
end)

RegisterNUICallback("equip", function(data)
	TriggerServerEvent("IRV-inventory:equipWeapon", data.weaponIndex, data.equipIndex)
end)

RegisterNetEvent('IRV-inventory:addWeapon', function(info)
	local playerPed  = PlayerPedId()
	local weaponHash = GetHashKey(string.upper(info.name))
	Weapons[weaponHash] = {index = info.slot, name = info.name, ammo = info.info.ammo}
	GiveWeaponToPed(playerPed, weaponHash, info.info.ammo, false, false)
	if info.info.tint then SetPedWeaponTintIndex(playerPed, weaponHash, info.info.tint) end
	if info.info.components and #info.info.components > 0 then
		for _, component in ipairs(info.info.components) do
			local componentData = ESX.GetWeaponComponent(string.upper(info.name), component)
			if componentData then
				GiveWeaponComponentToPed(playerPed, weaponHash, componentData.hash)
			end
		end
	end
end)

RegisterNUICallback("unequip", function(weaponIndex)
	TriggerServerEvent("IRV-inventory:unEquipWeapon", weaponIndex)
end)

RegisterNetEvent('IRV-inventory:removeWeapon', function(info)
	local playerPed  = PlayerPedId()
	local weaponHash = GetHashKey(string.upper(info.name))
	Weapons[weaponHash] = nil
	SetPedAmmo(playerPed, weaponHash, 0)
	RemoveWeaponFromPed(playerPed, weaponHash)
end)

RegisterNUICallback("useWeaponAmmo", function(data)
	TriggerServerEvent('IRV-inventory:useAmmo', data.weaponIndex, data.itemIndex)
end)

RegisterNetEvent('IRV-inventory:useAmmo', function(weapon, count)
	local Weapon = GetHashKey(string.upper(weapon))
 	local WeaponBullets = GetAmmoInPedWeapon(GetPlayerPed(-1), Weapon)
	local NewAmmo = WeaponBullets + count
	SetAmmoInClip(GetPlayerPed(-1), Weapon, 0)
	SetPedAmmo(GetPlayerPed(-1), Weapon, NewAmmo)
end)

RegisterNetEvent('IRV-inventory:setAmmo', function(weapon, count)
	local Weapon = GetHashKey(string.upper(weapon))
	local NewAmmo = count
	SetAmmoInClip(GetPlayerPed(-1), Weapon, 0)
	SetPedAmmo(GetPlayerPed(-1), Weapon, NewAmmo)
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(1500)
		local playerPed = PlayerPedId()
		local changeBuffer = {}
		if LoadoutLoaded then
			for weaponHash, data in pairs(Weapons) do
				local ammo = GetAmmoInPedWeapon(playerPed, weaponHash)
				if ammo ~= data.ammo then
					Weapons[weaponHash].ammo = ammo
					changeBuffer[#changeBuffer + 1] = {index = data.index, ammo = ammo}
				end
			end
			if #changeBuffer > 0 then
				TriggerServerEvent('IRV-inventory:updateLoadout', changeBuffer)
			end
		else
			Citizen.Wait(1000)
		end
	end
end)

RegisterNUICallback("attachment", function(data)
	TriggerServerEvent("IRV-inventory:toggleComponent", data.weaponIndex, data.component)
end)

RegisterNetEvent('IRV-inventory:addWeaponComponent', function(weaponName, weaponComponent)
    local playerPed  = PlayerPedId()
    local weaponHash = GetHashKey(weaponName)
    local WeaponComponent = ESX.GetWeaponComponent(weaponName, weaponComponent)
    if WeaponComponent then
        local componentHash = WeaponComponent.hash
        GiveWeaponComponentToPed(playerPed, weaponHash, componentHash)
    end
end)

RegisterNetEvent('IRV-inventory:removeWeaponComponent', function(weaponName, weaponComponent)
    local playerPed  = PlayerPedId()
    local weaponHash = GetHashKey(weaponName)
    local WeaponComponent = ESX.GetWeaponComponent(weaponName, weaponComponent)
    if WeaponComponent then
        local componentHash = WeaponComponent.hash
        RemoveWeaponComponentFromPed(playerPed, weaponHash, componentHash)
    end
end)

RegisterNUICallback("equipTint", function(data)
	TriggerServerEvent("IRV-inventory:equipTint", data.weaponIndex, data.tint)
end)

RegisterNUICallback("unequipTint", function(weaponIndex)
	TriggerServerEvent("IRV-inventory:unEquipTint", weaponIndex)
end)

RegisterNetEvent('IRV-inventory:setWeaponTint', function(weaponName, tint)
	local playerPed  = PlayerPedId()
	local weaponHash = GetHashKey(weaponName)
	SetPedWeaponTintIndex(playerPed, weaponHash, tint)
end)

RegisterNUICallback("use", function(data, cb)
	closeInventory()
	SendNUIMessage({action = "close"})
    TriggerServerEvent("esx:useItem", data.index)
    cb(true)
end)

RegisterNUICallback("sideInventoryAction", function(data)
	TriggerServerEvent(currentSide.action, currentSide.name, data)
end)

RegisterNUICallback("triggerAction", function(data)
	if data.type == "item_weapon" then
		TriggerServerEvent("IRV-inventory:weaponAction", data.itemIndex, data.key, data.data)
	else
		TriggerServerEvent("IRV-inventory:itemAction", data.itemIndex, data.key, data.data)
	end
end)

RegisterNUICallback("getActions", function(data, cb)
	if data.type == "item_weapon" then
		cb({})
	else
		cb({})
	end
end)

RegisterNUICallback("GetNearPlayers", function(_, cb)
	local players = ESX.Game.GetPlayersInArea(GetEntityCoords(PlayerPedId()), 3.0)
	local data = {}

	for i=1, #players, 1 do
		if players[i] ~= PlayerId() then
			local ped = GetPlayerPed(players[i])
			if IsEntityVisible(ped) then
				local id = GetPlayerServerId(players[i])
				table.insert(data, {
					label = exports['esx_idoverhead']:getAlias({id = id, distance = false, mask = true}),
					id = id
				})
			end
		end
	end

	if #data < 1 then ESX.ShowNotification("Hich playeri nazdik shoma nist!", "error") end
	cb(data)
end)

RegisterNUICallback("drop",function(data, cb)
    local ped = PlayerPedId()
    if IsPedSittingInAnyVehicle(ped) then return end
    if not data.type then return end

    if data.type == "item_weapon" then
        if not data.index then return end
        data.count = 1
    elseif data.type == "item_standard" then
        if not data.index or not data.count then return end
        data.count = tonumber(math.floor(data.count))
    end

    local playerCoords = GetEntityCoords(ped)
    local forward, obj = GetEntityForwardVector(ped)
    data.coords = (playerCoords + forward * 1.0)

    closeInventory()
    SendNUIMessage({action = "close"})

    TriggerServerEvent("IRV-inventory:dropItem", data)

    cb(true)
end)

function findPickupSelectedIndex(pickup)
	for index, action in ipairs(pickup.actions) do
		if action.selected then
			return index
		end
	end

	return 1
end

function CreatePickupSyntax(pickup)
	local string = pickup.label..'\n\n'
	local selectedstring = " ~g~[E]~w~\n"

	if pickup.inRange then
		for index, action in ipairs(pickup.actions) do
			string = string .. ("%s%s"):format(action.label, action.selected and selectedstring or '\n')
		end
	end

	return string
end

function createPickup(id, label, canPickup, object, coord, heading)
	local x, y, z = table.unpack(coord)
	ESX.Game.SpawnLocalObject(object, {
		x = x,
		y = y,
		z = z
	}, function(obj)
		SetEntityHeading(obj, heading)
		PlaceObjectOnGroundProperly(obj)
		SetEntityAsMissionEntity(obj, true, false)
		FreezeEntityPosition(obj, true)
		local actions = {
			{label = "Pickup", name = "pickup", event = "IRV-inventory:onPickup", selected = true}
		}
		if canPickup then
			table.insert(actions, {label = "Open", name = "open", event = "IRV-inventory:openBag", selected = false})
		end
		Pickups[id] = {
			id = id,
			obj = obj,
			label = label,
			heading = heading,
			actions = actions,
			inRange = false,
			coords = {
				x = x,
				y = y,
				z = z
			}
		}
	end)
end

RegisterNetEvent('IRV-inventory:pickup', function(id, label, canPickup, object, coord, heading)
	createPickup(id, label, canPickup, object, coord, heading)
end)

RegisterNetEvent('IRV-inventory:loadPickups', function(passedPickups)
	for id, pickup in pairs(passedPickups) do
		createPickup(id, pickup.label, pickup.canPickup, pickup.object, pickup.coords, pickup.heading)
	end
end)

RegisterNetEvent('IRV-inventory:removePickup', function(id)
	if Pickups[id] then
		ESX.Game.DeleteObject(Pickups[id].obj)
		Pickups[id] = nil
	end
end)

RegisterNetEvent('IRV-inventory:pickupAnim', function()
    actionAnimations.pickup()
end)

RegisterNetEvent('IRV-inventory:openBag', function(info)
    if info then
        TriggerServerEvent('IRV-inventory:openSide', 'stash', info.info.bagid, nil, nil, 20, 'Bag')
    else
        ClearPedTasks(PlayerPedId())
    end
end)

RegisterNetEvent('IRV-inventory:removeAllWeapon', function()
    local playerPed  = PlayerPedId()
    Weapons = {}
    RemoveAllPedWeapons(playerPed, true)
end)

RegisterNetEvent('IRV-inventory:ToggleMask', function(state, item)
    local Ped = PlayerPedId()
    Citizen.CreateThread(function()
        if state then
            local sex = 0
            if GetEntityModel(PlayerPedId()) == GetHashKey("mp_f_freemode_01") then
                sex = 1
            end
            if item.info.gender ~= sex then
                TriggerServerEvent('IRV-inventory:NoMask', item.slot)
                ESX.ShowNotification('in Mask Baraye Gender Shoma Nist', 'error')
                return
            end
            MaskAnim(Ped)
            SetPedComponentVariation(Ped, 1, item.info.model, item.info.texture, 0)
        else
            MaskAnim(Ped)
            SetPedComponentVariation(Ped, 1, -1, -1, -1)
        end
    end)
end)

function MaskAnim(Ped)
    while not HasAnimDictLoaded("mp_masks@standard_car@ds@") do
        RequestAnimDict("mp_masks@standard_car@ds@")
        Wait(100)
    end
    TaskPlayAnim(Ped, "mp_masks@standard_car@ds@", "put_on_mask", 3.0, 3.0, 800, 51, 0, false, false, false)
end

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(5)
		local playerPed = PlayerPedId()
		local coords, letSleep = GetEntityCoords(playerPed), true
		for k, pickup in pairs(Pickups) do
			local distance = GetDistanceBetweenCoords(coords, pickup.coords.x, pickup.coords.y, pickup.coords.z, true)
			pickup.inRange = distance < 1 or false
			if distance <= 5.0 then
				local pickupString = CreatePickupSyntax(pickup)
				ESX.Game.Utils.DrawText3D({
					x = pickup.coords.x,
					y = pickup.coords.y,
					z = pickup.coords.z + 0.25
				}, pickupString)
				letSleep = false
			end
			if pickup.inRange and IsPedOnFoot(playerPed) then
				letSleep = false
				selectedPickUP = k
			end
		end
		if letSleep then
			Citizen.Wait(500)
		end
	end
end)