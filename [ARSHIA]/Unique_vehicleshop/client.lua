sellectcar = nil
currentShopId = nil
IsInShopMenu = false
vehicle = nil
model = nil
price = nil

-- One combined map blip for the whole complex (car/boat/heli/plane shops sit
-- right next to each other, so instead of 4 stacked icons we drop a single
-- blip in the middle of them all - see Config.MainBlip)
Citizen.CreateThread(function()
	local sumX, sumY, sumZ, count = 0.0, 0.0, 0.0, 0
	for k,v in pairs(Config.vehicleshop) do
		sumX = sumX + v.coord.x
		sumY = sumY + v.coord.y
		sumZ = sumZ + v.coord.z
		count = count + 1
	end

	if count > 0 and Config.MainBlip then
		local centerX, centerY, centerZ = sumX / count, sumY / count, sumZ / count
		local blip = AddBlipForCoord(centerX, centerY, centerZ)
		SetBlipSprite(blip, Config.MainBlip.sprite or 225)
		SetBlipDisplay(blip, 4)
		SetBlipScale(blip, Config.MainBlip.scale or 1.0)
		SetBlipColour(blip, Config.MainBlip.color or 5)
		SetBlipAsShortRange(blip, true)
		BeginTextCommandSetBlipName("STRING")
		AddTextComponentString(Config.MainBlip.label or "Unique Vehicleshop")
		EndTextCommandSetBlipName(blip)
	end
end)

-- Shared "open this shop's menu" logic, called from whichever shop the player
-- picks from the salesman ped's ox_target menu below.
function OpenVehicleShop(shopId)
	local shop = Config.vehicleshop[shopId]
	if not shop then return end

	IsInShopMenu = true
	SetNuiFocus(true,true)
	currentShopId = shopId
	sellectcar = shop
	SendNUIMessage({
		action = "openmenu",
		shopname = sellectcar.galeryname,
		dec = sellectcar.dec,
	})
	initGarage(shopId)
	vehiclelist()
	cattegorylist()
end

-- Salesman NPC: ONE professional-looking, idle-animated ped for the whole
-- dealership (see Config.Shopkeeper), targetable with ox_target. Interacting
-- with him shows one option per shop (car/boat/heli/plane) - ox_target shows
-- a picker automatically whenever more than one option is registered on the
-- same entity - and picking one opens that shop's menu. Replaces the old
-- one-ped-per-shop setup: 4 peds standing on top of each other in a small
-- room (plus the leftover walk-in+[E] prompt from before that) looked messy;
-- one ped with a clean "which section?" choice doesn't.
local shopIcons = {
	car = "fa-solid fa-car",
	boat = "fa-solid fa-ship",
	helicopter = "fa-solid fa-helicopter",
	airplane = "fa-solid fa-plane",
}

ShopkeeperPed = nil

Citizen.CreateThread(function()
	local pedData = Config.Shopkeeper
	if not pedData then return end

	if GetResourceState('ox_target') ~= 'started' then
		print('^1[Unique_vehicleshop]^7 ox_target is not running - the salesman NPC was not spawned. No other way to open the shops is set up, so fix this before going live.')
		return
	end

	local hash = GetHashKey(pedData.model)
	RequestModel(hash)
	local timeout = 0
	while not HasModelLoaded(hash) and timeout < 500 do
		Citizen.Wait(10)
		timeout = timeout + 1
	end
	if not HasModelLoaded(hash) then return end

	local c = pedData.coord
	local npc = CreatePed(4, hash, c.x, c.y, c.z, c.w or 0.0, false, true)

	SetEntityInvincible(npc, true)
	SetPedCanRagdoll(npc, false)
	SetPedDiesWhenInjured(npc, false)
	SetPedSuffersCriticalHits(npc, false)
	SetBlockingOfNonTemporaryEvents(npc, true)
	SetPedFleeAttributes(npc, 0, false)
	SetPedCanBeTargetted(npc, false) -- no getting shot at by griefers
	FreezeEntityPosition(npc, true)
	SetEntityAsMissionEntity(npc, true, true)

	if pedData.scenario then
		TaskStartScenarioInPlace(npc, pedData.scenario, 0, true)
	end

	SetModelAsNoLongerNeeded(hash)
	ShopkeeperPed = npc

	-- ipairs (not pairs), so the picker always lists the shops in
	-- Config.vehicleshop's own [1],[2],[3],[4] order instead of an
	-- unspecified table-iteration order that could shuffle between servers.
	local options = {}
	for k, v in ipairs(Config.vehicleshop) do
		options[#options + 1] = {
			name = 'Unique_vehicleshop_' .. tostring(k),
			icon = shopIcons[v.type] or 'fa-solid fa-car',
			label = v.galeryname,
			distance = 2.5,
			onSelect = function()
				OpenVehicleShop(k)
			end,
		}
	end

	exports.ox_target:addLocalEntity(npc, options)
end)

AddEventHandler('onResourceStop', function(resource)
	if resource ~= GetCurrentResourceName() then return end
	if ShopkeeperPed and DoesEntityExist(ShopkeeperPed) then
		DeleteEntity(ShopkeeperPed)
	end
end)

cam = nil
function initGarage(x)
   SetEntityVisible(PlayerPedId(), 0)
   SetFollowVehicleCamViewMode(2)
   SetNuiFocus(1, 1)
   DisplayRadar(0)
   SendNUIMessage({
	actrion = "update-deta-veh",
   })

   -- Preview the shop's first vehicle (car/boat/heli) instead of hardcoding "blista"
   local firstCategory = (sellectcar.categories or {})[1]
   local firstVehicle = firstCategory and Config.Vehicles[firstCategory] and Config.Vehicles[firstCategory][1]

   if firstVehicle then
	   price = firstVehicle.price
	   model = firstVehicle.name
	   showCar(firstVehicle.name)
   else
	   price = 20000
	   model = "blista"
	   showCar("blista")
   end
end

RegisterNUICallback("close", function(data, cb)
	SetEntityCoords(PlayerPedId(), sellectcar.coord)
	IsInShopMenu = false
	DisplayRadar(1)
    SetNuiFocus(0, 0)
    if DoesCamExist(cam) then
        DestroyCam(cam, true)
        RenderScriptCams(false, true, 1)
        cam = nil
    end
    SetEntityVisible(PlayerPedId(), 1)
end)

function vehiclelist()
	for _,catName in ipairs(sellectcar.categories or {}) do
		local va = Config.Vehicles[catName]
		if va then
			for i,v in pairs(va) do
				SendNUIMessage({
					action = "loadvehicle",
					type = catName,
					label = v.label,
					carimg = catName..".png",
					price = v.price,
					currency = v.currency or "cash",
					name = v.name,
					speed = math.ceil(GetVehicleModelEstimatedMaxSpeed(v.name)*4.605936),
				})
			end
		end
	end
end

function cattegorylist()
	for _,catName in ipairs(sellectcar.categories or {}) do
		SendNUIMessage({
			action = "cattegory",
			label = catName,
		})
	end
end

RegisterNUICallback("catlist", function (data)
	local allowed = false
	for _,catName in ipairs(sellectcar.categories or {}) do
		if catName == data.id then allowed = true break end
	end
	if not allowed or not Config.Vehicles[data.id] then return end

	for i,v in pairs(Config.Vehicles[data.id]) do
		SendNUIMessage({
			action = "loadvehicle",
			type = data.id,
			label = v.label, 
			carimg = data.id..".png",
			price = v.price,
			currency = v.currency or "cash",
			name = v.name,
			speed = math.ceil(GetVehicleModelEstimatedMaxSpeed(v.name)*4.605936),
		})
	end
end)

RegisterNUICallback("getcar", function (data)
	model = data.id
	showCar(model)
	for k,va in pairs(Config.Vehicles) do 
		for i,v in pairs(Config.Vehicles[k]) do
			if v.name == model then
				price = v.price
				SendNUIMessage({
					action = "updatela",
					label = v.label, 
					price = v.price,
					currency = v.currency or "cash",
				})	
			end
		end
	end
end)

function showCar(modelName)
	DeleteEntity(vehicle)
    local model = (type(modelName) == 'number' and modelName or GetHashKey(modelName))
	Citizen.CreateThread(function()
		local modelHash = model
        modelHash = (type(modelHash) == 'number' and modelHash or GetHashKey(modelHash))
        if not HasModelLoaded(modelHash) and IsModelInCdimage(modelHash) then
            RequestModel(modelHash)
            while not HasModelLoaded(modelHash) do
                Citizen.Wait(1)
            end
        end
		RequestModel(0xDA2C984E)
		while not HasModelLoaded(0xDA2C984E) do
			Wait(0)
		end
		local ped = PlayerPedId()
		model = model
		vehicle = CreateVehicle(model, sellectcar.vehspawn, false, false)
		SetPedIntoVehicle(PlayerPedId(), vehicle, -1)
		local timeout = 0
		SetEntityAsMissionEntity(vehicle, true, false)
		SetVehicleHasBeenOwnedByPlayer(vehicle, true)
		SetVehicleNeedsToBeHotwired(vehicle, false)
		SetVehRadioStation(vehicle, 'OFF')
		RequestCollisionAtCoord(sellectcar.vehspawn.x, sellectcar.vehspawn.y, sellectcar.vehspawn.z)
		detailed(modelName)
		while not HasCollisionLoadedAroundEntity(vehicle) and timeout < 2000 do
			Citizen.Wait(0)
			timeout = timeout + 1
		end
	end)
end


RegisterNUICallback('rightClick', function(data, cb)
	SetNuiFocus(false, false)
	while true do
		Citizen.Wait(1)
		if IsDisabledControlJustPressed(0, 91) or not IsInShopMenu then
			break
		end
	end
	SetNuiFocus(true, true)
	cb("")
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)

		if IsInShopMenu then
			DisableAllControlActions(0)
			EnableControlAction(0, 1, true)
			EnableControlAction(0, 2, true)
			EnableControlAction(0, 4, true)
			EnableControlAction(0, 6, true)
		else
			Citizen.Wait(500)
		end
	end
end)

function detailed(veh)
	local pmult, tmult, handling, brake = 1000,800,GetPerformanceStats(veh).handling,GetPerformanceStats(veh).brakes
	topspeed = math.ceil(GetVehicleModelEstimatedMaxSpeed(veh)*4.605936)
	power = math.ceil(GetVehicleModelAcceleration(veh)*pmult)
	torque = math.ceil(GetVehicleModelAcceleration(veh)*tmult)
	brakes = GetVehicleModelMaxBraking(veh) * 80
	SendNUIMessage({
		action = "update",
		topspeed = topspeed,
		power = power,
		torque = torque,
		brakes = brakes
	})
end

function GetPerformanceStats(vehicle)
    local data = {}
    data.brakes = GetVehicleModelMaxBraking(vehicle)
    local handling1 = GetVehicleModelMaxBraking(vehicle)
    local handling2 = GetVehicleModelMaxBrakingMaxMods(vehicle)
    local handling3 = GetVehicleModelMaxTraction(vehicle)
    data.handling = (handling1+handling2) * handling3
    return data
end

function toboolean(str, str2)
    local bool = false
    if all_trim(str) == all_trim(str2) then
        bool = true
    end
    return bool
end

function all_trim(s)
	str = s:gsub("%s+", "")
    str = string.gsub(s, "%s+", "")
   return str
end

	RegisterNUICallback("setcolour", function(data)
		if DoesEntityExist(vehicle) then
			rgb = data.rgb
			SetVehicleCustomPrimaryColour(vehicle, tonumber(data.rgb.r), tonumber(data.rgb.g), tonumber(data.rgb.b))
		end
	end)

	RegisterNUICallback("testdv", function(data, cb)
		SetEntityCoords(PlayerPedId(), sellectcar.coord)
		IsInShopMenu = false
		DisplayRadar(1)
		SetNuiFocus(0, 0)
		if DoesCamExist(cam) then
			DestroyCam(cam, true)
			RenderScriptCams(false, true, 1)
			cam = nil
		end
		SetEntityVisible(PlayerPedId(), 1)
		startTestDrive()
	end)

	
	isTestDriving = false
	function startTestDrive(dealer_object)
		if isTestDriving then
			return
		end
		if vehicle and DoesEntityExist(vehicle) then
			FreezeEntityPosition(vehicle,false)
			SetVehicleUndriveable(vehicle,false)
			SetPedIntoVehicle(PlayerPedId(), vehicle, -1)
			-- This server's key/lock system (Unique_Garage's carlock_cl.lua)
			-- halts and hotwire-locks any vehicle the player doesn't hold a
			-- 'vehicle_keys' inventory item for - which a test-drive vehicle
			-- never gets, since it isn't actually bought. CarLock already has
			-- a built-in "temporary key" event for exactly this situation
			-- (it's plate-based and purely client-side, no inventory item
			-- involved), so fire it now that the player is actually seated.
			TriggerEvent('CarLock:enableVehicleTemporarily')
			SetPedCoordsKeepVehicle(PlayerPedId(), Config.TestDrive.coords)
			SendNUIMessage({ action = "startTest" })
		end

		local finished = nil
		CreateThread(function()
			local start = GetGameTimer()/1000
			while GetGameTimer()/1000 - start < Config.TestDrive.seconds and DoesEntityExist(vehicle) and not IsEntityDead(PlayerPedId()) do
				if #(GetEntityCoords(PlayerPedId()) - Config.TestDrive.coords) > Config.TestDrive.range then
					SetPedCoordsKeepVehicle(PlayerPedId(), Config.TestDrive.coords)
				end
				if GetVehiclePedIsIn(PlayerPedId(), false) == 0 and DoesEntityExist(vehicle) then
					SetPedIntoVehicle(PlayerPedId(), vehicle, -1)
				end
				Wait(1000)
			end
			SetPedCoordsKeepVehicle(PlayerPedId(), sellectcar.vehspawn)
			FreezeEntityPosition(vehicle, true)
			SetVehicleUndriveable(vehicle, true)
			ClearPedTasksImmediately(PlayerPedId())
			SetEntityCoords(PlayerPedId(), sellectcar.coord)
			finished = true
			DeleteEntity(vehicle)
		end)
		while finished == nil or not finished do
			Wait(0)
		end
	end
	
	RegisterNUICallback("buy", function ()
		-- Every purchase now goes straight into a garage instead of being
		-- physically spawned at the shop - see shared/server.lua. This callback
		-- just captures the preview vehicle's customization, cleans up the
		-- showroom, and asks (if the player's actually in a gang) whether it
		-- should go to their personal garage or their gang's.
		local buyProps = getvehicle(vehicle)
		IsInShopMenu = false
		DisplayRadar(1)
		SetNuiFocus(false, false)
		SetEntityVisible(PlayerPedId(), 1)
		if DoesCamExist(cam) then
			DestroyCam(cam, true)
			RenderScriptCams(false, true, 1)
			cam = nil
		end
		DeleteEntity(vehicle)
		SetEntityCoords(PlayerPedId(), sellectcar.coord)

		-- Ask the server for the player's REAL gang (never trust a client-side
		-- gang value even if one were available - see the note in
		-- Unique_ALLGangs/client/boss_esx_menu.lua about ESX.PlayerData.gang
		-- not being reliable on this server's bridge; this asks essentialmode's
		-- own xPlayer.gang directly instead, server-side, where it's trustworthy).
		ESX.TriggerServerCallback('Unique_vehicleshop:getGangName', function(gangName)
			local toGang = false
			if gangName then
				local choice = lib.alertDialog({
					header = 'Where should this vehicle go?',
					content = ('Send it to your personal garage, or to your gang\'s (**%s**) garage?'):format(gangName),
					centered = true,
					cancel = true,
					labels = { confirm = 'My Garage', cancel = gangName .. ' Garage' },
				})
				toGang = (choice == 'cancel')
			end
			TriggerServerEvent("Unique_vehicleshop:buyvehicle", buyProps, model, currentShopId, toGang)
		end)
	end)

	RegisterNetEvent("Unique_vehicleshop:deletevehicle")
	AddEventHandler("Unique_vehicleshop:deletevehicle", function ()
		DeleteEntity(vehicle)
		SetEntityCoords(PlayerPedId(), sellectcar.coord)
	end)