local ESX = nil
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)




Citizen.CreateThread(function()
	while true do
		Citizen.Wait(2000)
		for plate, taxi in pairs(currentTaxiDrivers) do
			if not DoesEntityExist(taxi.vehId) then
				removeTaxiFromPlate(plate)
			end
			if DoesEntityExist(taxi.vehId) and not taxi.pause and taxi.rate ~= nil then
				TriggerClientEvent('zz_taximeter:calculeDistance', taxi.driveId, taxi.oldPosition, GetEntityCoords(taxi.vehId), plate, taxi)
			end
		end
	end
end)


function forcePause(veh, activePause)
	setPause(veh, activePause)
	sendToChargedPlayers(veh, function(ply)
		TriggerClientEvent('zz_taximeter:pauseTaximeter', ply, not activePause)
	end)
end

function countPassengers(veh)
	local count = 0
	for _, seat in ipairs({0, 1, 2, 3, 4, 5, 6}) do
		if GetPedInVehicleSeat(veh, seat) ~= 0 then
			count = count + 1
		end
	end
	return count
end

RegisterNetEvent('zz_taximeter:distanceCalculated',function(diference, totalDistance, plate, taxi)
	local veh = GetVehiclePedIsIn(GetPlayerPed(source), false)
	local plate = getPlate(taxi.vehId)
	setOldPositionFromPlate(plate, GetEntityCoords(taxi.vehId))
	setDistanceFromPlate(plate, totalDistance)
	
	local isStopped = true

	if diference > 5 then
		isStopped = false
	end
	
	--calculeTotalDistance(taxi)
	local rate = Config.Rates[taxi.rate]

	if isStopped then
		local totalSec = taxi.secPause + 2
		setSecPauseFromPlate(plate, totalSec)
		setPricePauseFromPlate(plate, totalSec * rate.onStop)
	else
		local metters = 1000.00
		if Config.distanceMeasurement == "MI" then
			metters = 1609.34
		end

		setPriceFromPlate(plate, ( totalDistance / metters ) * rate.inMotion)
	end

	local taxiNew = getTaxiFromPlate(plate)

	local totalPrice = rate.base + taxiNew.pricePause + taxiNew.price

	sendToChargedPlayers(veh, function(ply)
		TriggerClientEvent('zz_taximeter:updateMoney', ply, totalPrice)
	end)
end)

-- Started only from the F6 > Taxi > Taximeter menu (esx_uniquejobs), after the driver
-- explicitly picks which passenger to charge. No commands, no keybinds, no on-screen buttons.
RegisterNetEvent('zz_taximeter:startForPlayer', function(vehNetId, targetId)
	local _src = source
	local veh = NetworkGetEntityFromNetworkId(vehNetId)

	if not IsInAuthorizedVehicle(veh) then return end

	local xPlayer = ESX.GetPlayerFromId(_src)
	if not xPlayer or xPlayer.job.name ~= "taxi" then return end

	-- the caller must actually be the driver of this vehicle
	if GetPedInVehicleSeat(veh, -1) ~= GetPlayerPed(_src) then return end

	targetId = tonumber(targetId)
	local targetPed = targetId and GetPlayerPed(targetId) or 0
	if not targetPed or targetPed == 0 then
		TriggerClientEvent('esx:showNotification', _src, "In Fard Online Nist")
		return
	end

	-- confirm the target is actually a passenger in this exact vehicle
	local isInVeh = false
	for seat = 0, 6 do
		if GetPedInVehicleSeat(veh, seat) == targetPed then
			isInVeh = true
			break
		end
	end
	if not isInVeh then
		TriggerClientEvent('esx:showNotification', _src, "In Fard Dakhele Taxi Nist")
		return
	end

	if not isAlreadyTaxi(veh) then
		addTaxi(veh, _src)
	end

	setTarget(veh, targetId)

	local passengers = countPassengers(veh)
	local rateSel = math.min(math.max(passengers, 1), 6)
	local taxi = getTaxi(veh)

	setRate(veh, rateSel)
	setPause(veh, false)

	local totalPrice = taxi.price + taxi.pricePause
	if taxi.price == 0 then
		totalPrice = totalPrice + Config.Rates[rateSel].base
	end

	sendToChargedPlayers(veh, function(ply)
		TriggerClientEvent('zz_taximeter:selRateTaximeter', ply, rateSel)
		TriggerClientEvent('zz_taximeter:updateMoney', ply, totalPrice)
		TriggerClientEvent('zz_taximeter:pauseTaximeter', ply, false)
		TriggerClientEvent('zz_taximeter:showTaximeter', ply)
	end)
end)

-- Also from the F6 menu: manually end the current fare early
RegisterNetEvent('zz_taximeter:stopFromMenu', function(vehNetId)
	local _src = source
	local veh = NetworkGetEntityFromNetworkId(vehNetId)

	if not IsInAuthorizedVehicle(veh) then return end
	if GetPedInVehicleSeat(veh, -1) ~= GetPlayerPed(_src) then return end
	if not isAlreadyTaxi(veh) then return end

	local taxi = getTaxi(veh)
	local driveId = taxi.driveId

	forcePause(veh, true)
	sendToChargedPlayers(veh, function(ply)
		TriggerClientEvent('zz_taximeter:resetTaximeter', ply)
		TriggerClientEvent('zz_taximeter:hideTaximeter', ply)
	end)
	resetTaxi(veh, driveId)
end)


RegisterNetEvent('baseevents:enteringVehicle', function(vehClient, seat, vehLabel, vehNetId) 
	local veh = NetworkGetEntityFromNetworkId(vehNetId)
	if not IsInAuthorizedVehicle(veh) then return end
	debugDump("Enter in vehicle")

	if seat ~= -1 then return end

	-- driver getting/back in: just resync their display if a fare is already running
	setDrive(veh, source)
	if not isAlreadyTaxi(veh) then return end

	local taxi = getTaxi(veh)
	local totalPrice = taxi.price + taxi.pricePause
	if taxi.rate ~= nil then
		TriggerClientEvent('zz_taximeter:selRateTaximeter', source, taxi.rate)
		totalPrice = totalPrice + Config.Rates[taxi.rate].base
		TriggerClientEvent('zz_taximeter:updateMoney', source, totalPrice)
	end
	if taxi.pause then
		TriggerClientEvent('zz_taximeter:pauseTaximeter', source, false)
	end
	TriggerClientEvent('zz_taximeter:showTaximeter', source)
end)

RegisterNetEvent('baseevents:leftVehicle', function(vehClient, seat, vehLabel, vehNetId) 
	TriggerClientEvent('zz_taximeter:hideTaximeter', source)
	TriggerClientEvent('zz_taximeter:resetTaximeter', source)
	local veh = NetworkGetEntityFromNetworkId(vehNetId)
	if not IsInAuthorizedVehicle(veh) then return end
	debugDump("Exit in vehicle")

	if not isAlreadyTaxi(veh) then return end
	local taxi = getTaxi(veh)

	if seat == -1 and taxi.rate ~= nil then
		forcePause(veh, true)
	end

	if seat ~= -1 then
		-- the charged passenger (or everyone) got out: if the taxi is now empty, end the ride
		local driveId = taxi.driveId
		Citizen.SetTimeout(300, function()
			if not DoesEntityExist(veh) or not isAlreadyTaxi(veh) then return end
			if countPassengers(veh) == 0 then
				forcePause(veh, true)
				Citizen.SetTimeout(8000, function()
					if DoesEntityExist(veh) and isAlreadyTaxi(veh) and countPassengers(veh) == 0 then
						sendToChargedPlayers(veh, function(ply)
							TriggerClientEvent('zz_taximeter:pauseTaximeter', ply, true)
							TriggerClientEvent('zz_taximeter:resetTaximeter', ply)
							TriggerClientEvent('zz_taximeter:hideTaximeter', ply)
						end)
						resetTaxi(veh, driveId)
					end
				end)
			end
		end)
	end
end)


AddEventHandler('esx:playerDropped', function(playerId, reason)
	local playerPed = GetPlayerPed(playerId)
	local veh = GetVehiclePedIsIn(playerPed, true)
	if not IsInAuthorizedVehicle(veh) then return end
	for k, seat in pairs({-1, 0, 1, 2, 3, 4, 5, 6}) do
			local tryPlayer = GetLastPedInVehicleSeat(veh, seat)
			if tryPlayer ~= 0 and tryPlayer == playerPed and seat == -1 then
				forcePause(veh, true)
			end
	end 
end)
