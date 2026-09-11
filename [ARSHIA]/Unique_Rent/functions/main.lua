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
	-- server check / model load / spawn). Since the confirm dialog closes
	-- as soon as the request is sent -- well before the vehicle actually
	-- spawns -- there was a real window where a second confirm click could
	-- trigger a second rent + a second charge for what the player would
	-- see as one rental.
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
				lib.notify({ title = 'Unique Rent', description = Config.Options['spawnpoint_blocked'], type = 'error' })
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
		lib.notify({ title = 'Unique Rent', description = Config.Options['return_success'], type = 'success' })
	else
		lib.notify({ title = 'Unique Rent', description = Config.Options['return_error'], type = 'error' })
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
end

function finish()
    lib.notify({ title = 'Unique Rent', description = Config.Options['time_finished'], type = 'info' })

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

-- Builds and shows the ox_lib context menu for a rental location: one
-- entry per vehicle, each opening a duration submenu, each duration
-- opening an ox_lib confirm dialog before anything is charged.
function open_ui(location)
	if Options.have_rented or Options.processing_rent then
		lib.notify({ title = 'Unique Rent', description = Config.Options['cant_rent'], type = 'error' })
		return
	end

	local locationCfg = Config.Locations[location]
	if not locationCfg then
		return
	end

	local resource = GetCurrentResourceName()
	local vehicleOptions = {}

	-- ipairs (not pairs) so vehicle cards / duration tiers render in the
	-- order they're defined in config.lua instead of an unspecified
	-- table-iteration order.
	for _, vehicle in ipairs(Config.Vehicles) do
		local durationOptions = {}

		for durationId, duration in ipairs(Config.Durations) do
			local price = math.floor((vehicle.price * duration.multiplier) + 0.5)

			durationOptions[#durationOptions + 1] = {
				title = duration.label,
				description = ('Total price: $%s'):format(price),
				icon = 'clock',
				onSelect = function()
					confirm_rent(vehicle, durationId, duration, price, location)
				end
			}
		end

		lib.registerContext({
			id = ('unique_rent_duration_%s'):format(vehicle.model),
			title = vehicle.label,
			menu = 'unique_rent_' .. location,
			options = durationOptions
		})

		vehicleOptions[#vehicleOptions + 1] = {
			title = vehicle.label,
			description = vehicle.description,
			icon = vehicle.icon or 'car',
			image = ('nui://%s/html/assets/%s.png'):format(resource, vehicle.image_name),
			metadata = {
				['Base price'] = ('$%s'):format(vehicle.price),
				['Type'] = vehicle.type,
			},
			menu = ('unique_rent_duration_%s'):format(vehicle.model),
			arrow = true,
		}
	end

	lib.registerContext({
		id = 'unique_rent_' .. location,
		title = 'Rent a Vehicle',
		options = vehicleOptions
	})

	lib.showContext('unique_rent_' .. location)
end

-- Confirmation step: image (via the ox_lib menu it came from), chosen
-- duration and total price are shown before any money is deducted -- no
-- more accidental one-click charges. Cancelling reopens the vehicle list
-- so the player lands back where they were instead of at the desert.
function confirm_rent(vehicle, durationId, duration, price, location)
	local alert = lib.alertDialog({
		header = vehicle.label,
		content = ('Duration: **%s**\nTotal price: **$%s**\n\nThe amount is deducted immediately on confirmation.'):format(duration.label, price),
		centered = true,
		cancel = true,
		labels = { confirm = 'Confirm & Pay', cancel = 'Cancel' }
	})

	if alert == 'confirm' then
		rent_vehicle(vehicle.model, durationId, location)
	else
		open_ui(location)
	end
end
