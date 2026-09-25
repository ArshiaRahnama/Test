------------------------------------------------------------------------------------
-- Vehicle rental - migrated in full from the standalone Unique_Rent resource
-- (that resource has been deleted; everything it did now lives here).
--
-- Renamed every global function/table from the original (get_vehicle_info,
-- rent_vehicle, return_vehicle, set_blip, show_timer, finish, delete_vehicle,
-- open_ui, confirm_rent, Options) to a Rent_-prefixed version, since this file
-- now shares one global Lua scope with the rest of Unique_vehicleshop and
-- "finish" / "Options" etc. were too generic to safely coexist with it.
--
-- ESX is NOT re-fetched here - shared/client.lua (loaded earlier) already
-- does `ESX = nil` + the esx:getSharedObject wait-loop for the whole resource,
-- so this file just uses that same global. (The original also waited on
-- ESX.PlayerData/PlayerData; nothing in the rental logic actually reads
-- those, so that dead wait was dropped rather than carried over.)
--
-- Needs ox_lib's `lib` global (markers, points, context menus, alert dialogs,
-- text UI) - '@ox_lib/init.lua' is loaded before this file in fxmanifest.lua.
------------------------------------------------------------------------------------

Rent_Options = {
	vehicle = {hash = 0},
	last_location = '',
	have_rented = false,
	processing_rent = false,
	blips = {}
}

-- Looks up a rental vehicle's config entry (label/type/etc.) by its model name.
function Rent_GetVehicleInfo(model)
	for k, v in pairs(Config.RentVehicles) do
		if v.model == model then
			return v
		end
	end
	return nil
end

function Rent_RentVehicle(model, durationId, location)
	-- BUGFIX carried over from the original: nothing stops this from being
	-- called again while a previous call is still mid-flight (waiting on the
	-- server check / model load / spawn). Since the confirm dialog closes as
	-- soon as the request is sent -- well before the vehicle actually spawns
	-- -- there was a real window where a second confirm click could trigger a
	-- second rent + a second charge for what the player would see as one.
	if Rent_Options.processing_rent or Rent_Options.have_rented then
		return
	end

	local locationCfg = Config.RentLocations[location]
	if not locationCfg then
		return
	end

	local spawn_coords = locationCfg.spawn_coords
	local vehicleInfo = Rent_GetVehicleInfo(model)
	local durationInfo = Config.RentDurations[tonumber(durationId)]

	Rent_Options.processing_rent = true

	-- SECURITY: only `model` and `durationId` are sent to the server. The
	-- price itself is always recomputed server-side from those two, never
	-- trusted from the client (see rent_server.lua).
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
					Rent_Options.vehicle.hash = vehicle
					Rent_Options.have_rented = true
					-- Only release the lock once have_rented is actually true,
					-- in the same step -- so there's no in-between tick where
					-- both flags are false while the vehicle is still
					-- mid-spawn (SpawnVehicle's own callback is async).
					Rent_Options.processing_rent = false
					Rent_SetBlip(false)
				end)
				TriggerServerEvent('unique_rent:pay', model, durationId)
				if Config.RentOptions['time'] and durationInfo then
					Rent_ShowTimer(vehicleInfo, durationInfo)
				end
			else
				lib.notify({ title = 'Unique Rent', description = Config.RentOptions['spawnpoint_blocked'], type = 'error' })
				Rent_Options.processing_rent = false
			end
		else
			Rent_Options.processing_rent = false
		end
	end, model, durationId)
end

function Rent_ReturnVehicle()
	if IsPedSittingInVehicle(GetPlayerPed(-1), Rent_Options.vehicle.hash) then
		Rent_DeleteVehicle(Rent_Options.vehicle.hash)

		Rent_Options.vehicle.hash = nil
		Rent_Options.have_rented = false

		Rent_SetBlip(true)
		SendNUIMessage({action = "hide_timer"})
		lib.notify({ title = 'Unique Rent', description = Config.RentOptions['return_success'], type = 'success' })
	else
		lib.notify({ title = 'Unique Rent', description = Config.RentOptions['return_error'], type = 'error' })
	end
end

function Rent_SetBlip(remove)
	if remove then
		-- BUGFIX carried over: RemoveBlip(nil) throws and aborts whatever
		-- called Rent_SetBlip(true) partway through. That matters for
		-- unique_rent:forceReset (used by /rentreset): an admin can run it on
		-- a player who never actually rented anything (no blip was ever
		-- created), and the error used to silently swallow the "hide_timer"
		-- NUI message and the notification that were supposed to run right
		-- after it.
		if Rent_Options.blips['return'] then
			RemoveBlip(Rent_Options.blips['return'])
			Rent_Options.blips['return'] = nil
		end
	else
		for k, v in pairs(Config.RentLocations) do
			if k == Rent_Options.last_location then
				Rent_Options.blips['return'] = AddBlipForCoord(v.return_coords.x, v.return_coords.y, v.return_coords.z)

				SetBlipSprite (Rent_Options.blips['return'], v.blips.return_spot.sprite)
				SetBlipDisplay(Rent_Options.blips['return'], 4)
				SetBlipScale  (Rent_Options.blips['return'], v.blips.return_spot.scale)
				SetBlipAsShortRange(Rent_Options.blips['return'], true)
				SetBlipColour(Rent_Options.blips['return'], v.blips.return_spot.color)

				BeginTextCommandSetBlipName("STRING")
				AddTextComponentSubstringPlayerName(v.blips.return_spot.name)
				EndTextCommandSetBlipName(Rent_Options.blips['return'])
			end
		end
	end
end

function Rent_ShowTimer(vehicleInfo, durationInfo)
	local seconds = durationInfo and durationInfo.seconds or 3600
	SendNUIMessage({action = "show_timer", content = { time = seconds, vehicle = vehicleInfo, duration = durationInfo }})
end

function Rent_Finish()
	lib.notify({ title = 'Unique Rent', description = Config.RentOptions['time_finished'], type = 'info' })

	if Rent_Options.vehicle.hash and DoesEntityExist(Rent_Options.vehicle.hash) then
		Rent_DeleteVehicle(Rent_Options.vehicle.hash)
	end

	Rent_Options.vehicle.hash = nil
	Rent_Options.have_rented = false
	Rent_SetBlip(true)
end

function Rent_DeleteVehicle(vehicle)
	ESX.Game.DeleteVehicle(vehicle)
end

-- Builds and shows the ox_lib context menu for a rental location: one entry
-- per vehicle, each opening a duration submenu, each duration opening an
-- ox_lib confirm dialog before anything is charged.
function Rent_OpenUI(location)
	if Rent_Options.have_rented or Rent_Options.processing_rent then
		lib.notify({ title = 'Unique Rent', description = Config.RentOptions['cant_rent'], type = 'error' })
		return
	end

	local locationCfg = Config.RentLocations[location]
	if not locationCfg then
		return
	end

	local resource = GetCurrentResourceName()
	local vehicleOptions = {}

	-- ipairs (not pairs) so vehicle cards / duration tiers render in the
	-- order they're defined in Config.RentVehicles instead of an unspecified
	-- table-iteration order.
	for _, vehicle in ipairs(Config.RentVehicles) do
		local durationOptions = {}

		for durationId, duration in ipairs(Config.RentDurations) do
			local price = math.floor((vehicle.price * duration.multiplier) + 0.5)

			durationOptions[#durationOptions + 1] = {
				title = duration.label,
				description = ('Total price: $%s'):format(price),
				icon = 'clock',
				onSelect = function()
					Rent_ConfirmRent(vehicle, durationId, duration, price, location)
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
			-- Rental preview images live in html/rent/ in this merged resource
			-- (they used to be html/assets/ back when this was its own
			-- Unique_Rent resource).
			image = ('nui://%s/html/rent/%s.png'):format(resource, vehicle.image_name),
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
-- duration and total price are shown before any money is deducted -- no more
-- accidental one-click charges. Cancelling reopens the vehicle list so the
-- player lands back where they were instead of at the desert.
function Rent_ConfirmRent(vehicle, durationId, duration, price, location)
	local alert = lib.alertDialog({
		header = vehicle.label,
		content = ('Duration: **%s**\nTotal price: **$%s**\n\nThe amount is deducted immediately on confirmation.'):format(duration.label, price),
		centered = true,
		cancel = true,
		labels = { confirm = 'Confirm & Pay', cancel = 'Cancel' }
	})

	if alert == 'confirm' then
		Rent_RentVehicle(vehicle.model, durationId, location)
	else
		Rent_OpenUI(location)
	end
end

-- Prebuilt ox_lib markers per rental location (nicer built-in shapes than a
-- plain DrawMarker cylinder -- see Config.RentLocations[x].markers). One rent
-- marker + one return marker per configured location.
local rentMarker, returnMarker = {}, {}

for locId, loc in pairs(Config.RentLocations) do
	rentMarker[locId] = lib.marker.new({
		type = loc.markers.spawn.oxType,
		coords = loc.coords,
		width = loc.markers.spawn.size.x,
		height = loc.markers.spawn.size.z,
		color = loc.markers.spawn.color,
		bobUpAndDown = true,
		faceCamera = true,
		rotate = true,
	})

	returnMarker[locId] = lib.marker.new({
		type = loc.markers.return_spot.oxType,
		coords = loc.return_coords,
		width = loc.markers.return_spot.size.x,
		height = loc.markers.return_spot.size.z,
		color = loc.markers.return_spot.color,
		bobUpAndDown = true,
		faceCamera = true,
		rotate = true,
	})

	-- Rent zone: draws the marker + "[E] Rent a Vehicle" prompt while nearby,
	-- opens the ox_lib menu on E. Gated on `processing_rent` too -- the menu
	-- closes as soon as a rent is confirmed, but the actual server check /
	-- spawn is still in flight for a moment after that. Without this, the
	-- prompt could reappear and let a second Rent_RentVehicle() start during
	-- that window.
	lib.points.new({
		coords = loc.coords,
		distance = 15,
		locationId = locId,
		nearby = function(self)
			rentMarker[locId]:draw()

			if self.currentDistance > 1.2 then
				if self.promptShown then
					lib.hideTextUI()
					self.promptShown = nil
				end
				return
			end

			if Rent_Options.have_rented or Rent_Options.processing_rent then
				lib.showTextUI(Config.RentOptions['cant_rent'], { icon = 'ban', position = 'left-center' })
				self.promptShown = true
				return
			end

			lib.showTextUI(loc.markers.spawn.text, { icon = loc.markers.spawn.icon, position = 'left-center' })
			self.promptShown = true

			if IsControlJustReleased(0, loc.markers.spawn.key) then
				Rent_Options.last_location = locId
				Rent_OpenUI(locId)
			end
		end,
		onExit = function(self)
			if self.promptShown then
				lib.hideTextUI()
				self.promptShown = nil
			end
		end
	})

	-- Return zone: only draws/prompts once the player actually has a rented
	-- vehicle.
	lib.points.new({
		coords = loc.return_coords,
		distance = 15,
		locationId = locId,
		nearby = function(self)
			if not Rent_Options.have_rented then return end

			returnMarker[locId]:draw()

			if self.currentDistance > 3 then
				if self.promptShown then
					lib.hideTextUI()
					self.promptShown = nil
				end
				return
			end

			lib.showTextUI(loc.markers.return_spot.text, { icon = loc.markers.return_spot.icon, position = 'left-center' })
			self.promptShown = true

			if IsControlJustReleased(0, loc.markers.return_spot.key) then
				Rent_ReturnVehicle()
			end
		end,
		onExit = function(self)
			if self.promptShown then
				lib.hideTextUI()
				self.promptShown = nil
			end
		end
	})
end

-- Server-triggered reset (see /rentreset) for when a rented vehicle is lost
-- some other way and the normal Rent_ReturnVehicle() flow can't run.
RegisterNetEvent('unique_rent:forceReset')
AddEventHandler('unique_rent:forceReset', function()
	if Rent_Options.vehicle.hash and DoesEntityExist(Rent_Options.vehicle.hash) then
		Rent_DeleteVehicle(Rent_Options.vehicle.hash)
	end
	Rent_Options.vehicle.hash = nil
	Rent_Options.have_rented = false
	Rent_SetBlip(true)
	SendNUIMessage({action = "hide_timer"})
	lib.notify({ title = 'Unique Rent', description = Config.RentOptions['return_success'], type = 'success' })
end)

-- Server-driven ox_lib notifications (see rent_server.lua), so payment
-- results use the same styled toast as everything else instead of the plain
-- native ESX notification.
RegisterNetEvent('unique_rent:notify')
AddEventHandler('unique_rent:notify', function(data)
	lib.notify(data)
end)

-- The countdown ring's own NUI (html/ui.html) posts here when it hits 0.
RegisterNUICallback("finish", function(data, cb)
	Rent_Finish()
	cb(1)
end)

for k, v in pairs(Config.RentLocations) do
	local rent = AddBlipForCoord(v.coords.x, v.coords.y, v.coords.z)
	SetBlipSprite (rent, v.blips.spawn.sprite)
	SetBlipDisplay(rent, 4)
	SetBlipScale(rent, 0.7)
	SetBlipAsShortRange(rent, true)
	SetBlipColour(rent, v.blips.spawn.color)
	BeginTextCommandSetBlipName("STRING")
	AddTextComponentSubstringPlayerName(v.blips.spawn.name)
	EndTextCommandSetBlipName(rent)
end
