-- Looks up a vehicle's config entry (label/type/etc.) by its model name,
-- used to show the vehicle's name on the rental timer panel.
function get_vehicle_info(model)
	for k, v in pairs(Config.Vehicles) do
		if v.model == model then
			return v
		end
	end
	return nil
end

function rent_vehicle(model, durationId, location)
	-- BUGFIX: previously nothing stopped rent_vehicle() from being called
	-- again while a previous call was still mid-flight (waiting on the
	-- server check / model load / spawn). Since the UI closes as soon as
	-- the request is sent -- well before the vehicle actually spawns --
	-- there was a real window where a second confirm click (or a fast
	-- double relog into the E-key prompt) could trigger a second rent +
	-- a second charge for what the player would see as one rental.
	if Options.processing_rent or Options.have_rented then
		return
	end

	local locationCfg = Config.Locations[location]
	if not locationCfg then
		return
	end

	local spawn_coords = locationCfg.spawn_coords
	local vehicleInfo = get_vehicle_info(model)
	local durationInfo = Config.Durations[tonumber(durationId)]

	Options.processing_rent = true

	-- SECURITY: only `model` and `durationId` are sent to the server.
	-- The price itself is always recomputed server-side from those
	-- two, never trusted from the client (see server/main.lua).
	ESX.TriggerServerCallback('unique_rent:check', function(can)
		if can then
			RequestModel(model)
			while not HasModelLoaded(model) do
				Citizen.Wait(10)
			end
			if ESX.Game.IsSpawnPointClear(spawn_coords, 5) then
				ESX.Game.SpawnVehicle(model, spawn_coords, spawn_coords.h, function(vehicle)
					SetEntityAsMissionEntity(vehicle, true, true)
					TaskWarpPedIntoVehicle(GetPlayerPed(-1), vehicle, -1)
					Options.vehicle.hash = vehicle
					Options.have_rented = true
					-- Only release the lock once have_rented is actually
					-- true, in the same step -- so there's no in-between
					-- tick where both flags are false while the vehicle is
					-- still mid-spawn (SpawnVehicle's own callback is async).
					Options.processing_rent = false
					set_blip(false)
				end)
				TriggerServerEvent('unique_rent:pay', model, durationId)
				if Config.Options['time'] and durationInfo then
					show_timer(vehicleInfo, durationInfo)
				end
			else
				Notification(Config.Options['spawnpoint_blocked'])
				Options.processing_rent = false
			end
		else
			Options.processing_rent = false
		end
	end, model, durationId)
end

function return_vehicle()
	if IsPedSittingInVehicle(GetPlayerPed(-1), Options.vehicle.hash) then
		delete_vehicle(Options.vehicle.hash)

		Options.vehicle.hash = nil
		Options.have_rented = false

		set_blip(true)
		SendNUIMessage({action = "hide_timer"})
		Notification(Config.Options['return_success'])
	else
		Notification(Config.Options['return_error'])
	end
end

function set_blip(remove)
	if remove then
		-- BUGFIX: RemoveBlip(nil) throws a runtime error and aborts whatever
		-- called set_blip(true) partway through. That mattered for
		-- unique_rent:forceReset (used by /rentreset): an admin can run it
		-- on a player who never actually rented anything (no blip was ever
		-- created), and the error used to silently swallow the "hide_timer"
		-- NUI message and the notification that were supposed to run right
		-- after it.
		if Options.blips['return'] then
			RemoveBlip(Options.blips['return'])
			Options.blips['return'] = nil
		end
	else
		for k, v in pairs(Config.Locations) do
			if k == Options.last_location then
				Options.blips['return'] = AddBlipForCoord(v.return_coords.x, v.return_coords.y, v.return_coords.z)

				SetBlipSprite (Options.blips['return'], v.blips.return_spot.sprite)
				SetBlipDisplay(Options.blips['return'], 4)
				SetBlipScale  (Options.blips['return'], v.blips.return_spot.scale)
				SetBlipAsShortRange(Options.blips['return'], true)
				SetBlipColour(Options.blips['return'], v.blips.return_spot.color)

				BeginTextCommandSetBlipName("STRING")
				AddTextComponentSubstringPlayerName(v.blips.return_spot.name)
				EndTextCommandSetBlipName(Options.blips['return'])
			end
		end
	end
end

function show_timer(vehicleInfo, durationInfo)
	local seconds = durationInfo and durationInfo.seconds or 3600
	SendNUIMessage({action = "show_timer", content = { time = seconds, vehicle = vehicleInfo, duration = durationInfo }})
	SetNuiFocus(false, false)
end

function finish()
    Notification(Config.Options['time_finished'])

    if Options.vehicle.hash and DoesEntityExist(Options.vehicle.hash) then
        delete_vehicle(Options.vehicle.hash)
    end

    Options.vehicle.hash = nil
    Options.have_rented = false
    set_blip(true)
end

function delete_vehicle(vehicle)
	ESX.Game.DeleteVehicle(vehicle)
end

function Notification(text)
	SetNotificationTextEntry("STRING")
	AddTextComponentString(text)
	DrawNotification(false, false)
end

function open_ui(location)
	local vehicles = {}

	-- ipairs (not pairs), same reasoning as Config.Durations below: this
	-- guarantees the vehicle cards render in the order they're defined in
	-- config.lua instead of an unspecified table-iteration order.
	for k,v in ipairs(Config.Vehicles) do
		table.insert(vehicles, {location = location, id= k,  model = v.model, label = v.label, description = v.description, price = v.price, type = v.type, image = v.image_name})
	end

	-- ipairs (not pairs) so the tiers arrive in the order they're defined
	-- in Config.Durations -- that order is what the UI displays left-to-right.
	local durations = {}
	for k,v in ipairs(Config.Durations) do
		table.insert(durations, {id = k, label = v.label, seconds = v.seconds, multiplier = v.multiplier})
	end

	TriggerScreenblurFadeIn(1)
	SendNUIMessage({action = 'open', content = { vehicles = vehicles, durations = durations }})
	SetNuiFocus(true, true)

	InMenu = true
end

function close_ui()
  TriggerScreenblurFadeOut(1000)
	SendNUIMessage({action = "close"})
	SetNuiFocus(false, false)

	InMenu = false
end

function DrawText3D(x, y, z, text)
	local px, py, pz = table.unpack(GetEntityCoords(PlayerPedId()))

	local distance = GetDistanceBetweenCoords(x, y, z, px, py, pz, false)

	if distance <= 6 then
		SetTextScale(0.35, 0.35)
		SetTextFont(4)
		SetTextProportional(1)
		SetTextColour(255, 255, 255, 215)
		SetTextEntry("STRING")
		SetTextCentre(true)
		AddTextComponentString(text)
		SetDrawOrigin(x,y,z, 0)
		DrawText(0.0, 0.0)
		local factor = (string.len(text)) / 370
		DrawRect(0.0, 0.0+0.0125, 0.017+ factor, 0.03, 0, 0, 0, 75)
		ClearDrawOrigin()
	end
end

