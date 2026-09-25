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

Citizen.CreateThread(function()
	while true do
		local sleep = 1500
			local playercoord = GetEntityCoords(PlayerPedId())
			for k,v in pairs(Config.vehicleshop) do
			local shopCoord = vector3(v.coord.x,v.coord.y,v.coord.z)
			local dst = #(playercoord - shopCoord)
			local mk = v.marker
			local drawRadius = mk and mk.radius or 5.0
			local interactRadius = mk and mk.interactRadius or 3.0

			if dst < drawRadius then
				sleep = 1

				-- Fun 3D marker: a spinning marker with a pulse effect (grows/shrinks)
				if mk then
					local pulse = (math.sin(GetGameTimer() / 250.0) + 1.0) / 2.0 -- 0..1
					local baseSize = mk.size or vector3(1.4, 1.4, 1.0)
					local pulseSize = vector3(
						baseSize.x + (pulse * 0.25),
						baseSize.y + (pulse * 0.25),
						baseSize.z
					)
					local rotation = (GetGameTimer() / 10) % 360.0
					DrawMarker(
						mk.type or 27,
						shopCoord.x, shopCoord.y, shopCoord.z + (mk.offsetZ or -0.98),
						0.0, 0.0, 0.0,
						0.0, 0.0, rotation,
						pulseSize.x, pulseSize.y, pulseSize.z,
						mk.color.r, mk.color.g, mk.color.b, mk.color.a,
						false, true, 2, true, nil, nil, false
					)
				end

				if dst < interactRadius then
					if Config.drawtextorfloating then
					DrawText3D(v.coord.x, v.coord.y, v.coord.z, v.lang.openmenu)
					else
					ShowFloatingHelpNotification(Config.lang.openmenu, v.coord,dst)
					end
					if IsControlJustReleased(0,38) then
						IsInShopMenu = true
						SetNuiFocus(true,true)
						currentShopId = k
						sellectcar = Config.vehicleshop[k]
						SendNUIMessage({
							action = "openmenu",
							shopname = sellectcar.galeryname,
							dec = sellectcar.dec
						})
						initGarage(k)
						vehiclelist()
						cattegorylist()
					end
				end
			end
		end
		Citizen.Wait(sleep)
	end
end)

function ShowFloatingHelpNotification(msg, coords,r)
    AddTextEntry('FloatingHelpNotification'..'_'..r, msg)
    SetFloatingHelpTextWorldPosition(1, coords.x,coords.y,coords.z)
    SetFloatingHelpTextStyle(1, 1, 2, -1, 3, 0)
    BeginTextCommandDisplayHelp('FloatingHelpNotification'..'_'..r)
    EndTextCommandDisplayHelp(2, false, false, -1)
end

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
		buy = getvehicle(vehicle)
		SetEntityCoords(PlayerPedId(), sellectcar.coord)
		IsInShopMenu = false
		DisplayRadar(1)
		SetNuiFocus(false, false)
		SetEntityCoords(vehicle, sellectcar.buyspawn)
		DeleteEntity(vehicle)
		SetEntityVisible(PlayerPedId(), 1)
		SetNuiFocus(0, 0)
		if DoesCamExist(cam) then
			DestroyCam(cam, true)
			RenderScriptCams(false, true, 1)
			cam = nil
		end
		DeleteEntity(vehicle)
		model = model
		vehicle = CreateVehicle(model, sellectcar.buyspawn, true, true)
		SetPedIntoVehicle(PlayerPedId(), vehicle, -1)
		local timeout = 0
		SetEntityAsMissionEntity(vehicle, true, false)
		SetVehicleHasBeenOwnedByPlayer(vehicle, true)
		SetVehicleNeedsToBeHotwired(vehicle, false)
		SetVehRadioStation(vehicle, 'OFF')
		plate= GetVehicleNumberPlateText(vehicle)
		-- Key handoff happens server-side now (shared/server.lua), right after
		-- the DB insert succeeds, using the real plate the server just saved.
		buy = getvehicle(vehicle)
		-- Note: price is no longer sent from here; the server looks up the real price via model + shopId
		TriggerServerEvent("Unique_vehicleshop:buyvehicle", buy, model, currentShopId)
		RequestCollisionAtCoord(sellectcar.buyspawn.x, sellectcar.buyspawn.y, sellectcar.buyspawn.z)
	end)

	RegisterNetEvent("Unique_vehicleshop:deletevehicle")
	AddEventHandler("Unique_vehicleshop:deletevehicle", function ()
		DeleteEntity(vehicle)
		SetEntityCoords(PlayerPedId(), sellectcar.coord)
	end)