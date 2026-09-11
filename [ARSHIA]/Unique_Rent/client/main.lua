ESX = nil
Citizen.CreateThread(function()
    Wait(100)
	while ESX == nil do TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end) Citizen.Wait(0) end
    while ESX.GetPlayerData().job == nil do Wait(0) end
    ESX.PlayerData = ESX.GetPlayerData()
    PlayerData = ESX.GetPlayerData()
end)

Options = {
    vehicle = {hash = 0},
    last_location = '',
    have_rented = false,
    processing_rent = false,
    blips = {}
}

-- Prebuilt ox_lib markers per location (nicer built-in shapes than a plain
-- DrawMarker cylinder -- see Config.Locations[x].markers in config.lua for
-- the type/color/size of each one). One rent marker + one return marker
-- per configured location.
local rentMarker, returnMarker = {}, {}

for locId, loc in pairs(Config.Locations) do
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

    -- Rent zone: draws the marker + "[E] Rent a Vehicle" prompt while
    -- nearby, opens the ox_lib menu on E. Gated on `processing_rent` too --
    -- the menu closes as soon as a rent is confirmed, but the actual
    -- server check / spawn is still in flight for a moment after that.
    -- Without this, the prompt could reappear and let a second
    -- rent_vehicle() start during that window.
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

            if Options.have_rented or Options.processing_rent then
                lib.showTextUI(Config.Options['cant_rent'], { icon = 'ban', position = 'left-center' })
                self.promptShown = true
                return
            end

            lib.showTextUI(loc.markers.spawn.text, { icon = loc.markers.spawn.icon, position = 'left-center' })
            self.promptShown = true

            if IsControlJustReleased(0, loc.markers.spawn.key) then
                Options.last_location = locId
                open_ui(locId)
            end
        end,
        onExit = function(self)
            if self.promptShown then
                lib.hideTextUI()
                self.promptShown = nil
            end
        end
    })

    -- Return zone: only draws/prompts once the player actually has a
    -- rented vehicle.
    lib.points.new({
        coords = loc.return_coords,
        distance = 15,
        locationId = locId,
        nearby = function(self)
            if not Options.have_rented then return end

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
                return_vehicle()
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

-- Server-triggered reset (see /rentreset) for when a rented vehicle is
-- lost some other way and the normal return_vehicle() flow can't run.
RegisterNetEvent('unique_rent:forceReset')
AddEventHandler('unique_rent:forceReset', function()
    if Options.vehicle.hash and DoesEntityExist(Options.vehicle.hash) then
        delete_vehicle(Options.vehicle.hash)
    end
    Options.vehicle.hash = nil
    Options.have_rented = false
    set_blip(true)
    SendNUIMessage({action = "hide_timer"})
    lib.notify({ title = 'Unique Rent', description = Config.Options['return_success'], type = 'success' })
end)

-- Server-driven ox_lib notifications (see server/main.lua), so payment
-- results use the same styled toast as everything else instead of the
-- plain native ESX notification.
RegisterNetEvent('unique_rent:notify')
AddEventHandler('unique_rent:notify', function(data)
    lib.notify(data)
end)

for k, v in pairs(Config.Locations) do
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
