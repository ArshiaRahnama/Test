-- ============================================================
-- GPS Tracker (client)
-- Two roles in one file, both running for every player:
--  1. Anyone near a tracked vehicle reports its position (the
--     agent who placed the tracker might be nowhere nearby).
--  2. The tracking agent draws/updates a live blip as position
--     reports come in.
-- ============================================================

ESX = nil
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

local trackedPlates = {}
local trackerBlips = {} -- trackerBlips[plate] = blip handle

RegisterNetEvent('esx_uniquejobs:trackedPlatesUpdated')
AddEventHandler('esx_uniquejobs:trackedPlatesUpdated', function(plates)
	trackedPlates = {}
	for _, plate in ipairs(plates) do
		trackedPlates[plate] = true
	end

	for plate, blip in pairs(trackerBlips) do
		if not trackedPlates[plate] then
			RemoveBlip(blip)
			trackerBlips[plate] = nil
		end
	end
end)

Citizen.CreateThread(function()
	while ESX == nil do
		Citizen.Wait(0)
	end

	TriggerServerEvent('esx_uniquejobs:requestTrackedPlates')

	while true do
		Citizen.Wait(3000)

		if next(trackedPlates) then
			for _, vehicle in pairs(GetGamePool('CVehicle')) do
				local plate = string.gsub(GetVehicleNumberPlateText(vehicle), "%s+", "")
				if trackedPlates[plate] then
					local coords = GetEntityCoords(vehicle)
					TriggerServerEvent('esx_uniquejobs:trackerPing', plate, coords.x, coords.y, coords.z)
				end
			end
		end
	end
end)

RegisterNetEvent('esx_uniquejobs:trackerUpdate')
AddEventHandler('esx_uniquejobs:trackerUpdate', function(plate, x, y, z)
	local blip = trackerBlips[plate]

	if not blip or not DoesBlipExist(blip) then
		blip = AddBlipForCoord(x, y, z)
		SetBlipSprite(blip, 225)
		SetBlipColour(blip, 1)
		SetBlipScale(blip, 0.9)
		SetBlipAsShortRange(blip, false)
		BeginTextCommandSetBlipName("STRING")
		AddTextComponentString("Tracker: " .. plate)
		EndTextCommandSetBlipName(blip)
		trackerBlips[plate] = blip
	else
		SetBlipCoords(blip, x, y, z)
	end
end)

function PlaceTrackerOnClosestVehicle_agent()
	local playerCoords = GetEntityCoords(PlayerPedId())

	local closestVehicle, closestDistance = nil, 5.0
	for _, vehicle in pairs(GetGamePool('CVehicle')) do
		local distance = #(playerCoords - GetEntityCoords(vehicle))
		if distance < closestDistance then
			closestVehicle = vehicle
			closestDistance = distance
		end
	end

	if not closestVehicle then
		ESX.ShowNotification("~r~Hich Mashini Nazdik Nist!")
		return
	end

	local plate = string.gsub(GetVehicleNumberPlateText(closestVehicle), "%s+", "")
	TriggerServerEvent('esx_uniquejobs:placeTracker', plate)
end
