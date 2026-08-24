local HasAlreadyEnteredMarker = false
local LastZone                = nil

CurrentAction     = nil
CurrentActionMsg  = ''
CurrentActionData = {}

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)

		if CurrentAction then
			ESX.ShowHelpNotification(CurrentActionMsg)

			if IsControlJustReleased(0, 38) then
				if CurrentAction == 'boat_shop' then
					if not Config.LicenseEnable then
						OpenBoatShop(Config.Zones.BoatShops[CurrentActionData.zoneNum])
					else

						ESX.TriggerServerCallback('esx_license:checkLicense', function(hasBoatLicense)
							if hasBoatLicense then
								OpenBoatShop(Config.Zones.BoatShops[CurrentActionData.zoneNum])
							else
								OpenLicenceMenu(Config.Zones.BoatShops[CurrentActionData.zoneNum])
							end
						end, GetPlayerServerId(PlayerId()), 'boat')
					end
				elseif CurrentAction == 'garage_out' then
					OpenBoatGarage(Config.Zones.Garages[CurrentActionData.zoneNum])
				elseif CurrentAction == 'garage_in' then
					StoreBoatInGarage(CurrentActionData.vehicle, Config.Zones.Garages[CurrentActionData.zoneNum].StoreTP)
				end

				CurrentAction = nil
			end
		else
			Citizen.Wait(500)
		end
	end
end)

AddEventHandler('esx_boat:hasEnteredMarker', function(zone, zoneNum)
	if zone == 'boat_shop' then
		CurrentAction     = 'boat_shop'
		CurrentActionMsg  = _U('boat_shop_open')
		CurrentActionData = { zoneNum = zoneNum }
	elseif zone == 'garage_out' then
		CurrentAction     = 'garage_out'
		CurrentActionMsg  = _U('garage_open')
		CurrentActionData = { zoneNum = zoneNum }
	elseif zone == 'garage_in' then
		local playerPed = PlayerPedId()
		local coords    = GetEntityCoords(playerPed)

		if IsPedInAnyVehicle(playerPed, false) then
			local vehicle = GetVehiclePedIsIn(playerPed, false)

			if DoesEntityExist(vehicle) and GetPedInVehicleSeat(vehicle, -1) == playerPed then
				CurrentAction     = 'garage_in'
				CurrentActionMsg  = _U('garage_store')
				CurrentActionData = { vehicle = vehicle, zoneNum = zoneNum }
			end
		end
	end
end)

AddEventHandler('esx_boat:hasExitedMarker', function()
	if not isInShopMenu then
		ESX.UI.Menu.CloseAll()
	end

	CurrentAction = nil
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)

		local playerPed = PlayerPedId()
		local coords = GetEntityCoords(playerPed)
		local isInMarker, hasExited, letSleep = false, false, true
		local currentZone, currentZoneNum

		for i=1, #Config.Zones.BoatShops, 1 do
			local distance = GetDistanceBetweenCoords(coords, Config.Zones.BoatShops[i].Outside, true)

			if distance < Config.DrawDistance then
				DrawMarker(35, Config.Zones.BoatShops[i].Outside, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.4,0.4,0.4, 0, 0, 100, 100, true, true, 2, false, nil, nil, false)
				letSleep = false
			end

			if distance < Config.Marker.x then
				isInMarker     = true
				currentZone    = 'boat_shop'
				currentZoneNum = i
			end
		end

		for i=1, #Config.Zones.Garages, 1 do
			local distance = GetDistanceBetweenCoords(coords, Config.Zones.Garages[i].GaragePos, true)

			if distance < Config.DrawDistance then
				DrawMarker(35, Config.Zones.Garages[i].GaragePos, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.4,0.4,0.4, 0, 255, 0, 100, true, true, 2, false, nil, nil, false)
				letSleep = false
			end

			if distance < Config.Marker.x then
				isInMarker     = true
				currentZone    = 'garage_out'
				currentZoneNum = i
			end

			distance = GetDistanceBetweenCoords(coords, Config.Zones.Garages[i].StorePos, true)

			if distance < Config.DrawDistance then
				DrawMarker(24, Config.Zones.Garages[i].StorePos, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.0, 1.0, 1.0, Config.StoreMarker.r, Config.StoreMarker.g, Config.StoreMarker.b, 100, true, true, 2, false, nil, nil, false)
				letSleep = false
			end

			if distance < Config.StoreMarker.x then
				isInMarker     = true
				currentZone    = 'garage_in'
				currentZoneNum = i
			end
		end

		if isInMarker and not HasAlreadyEnteredMarker or (isInMarker and (LastZone ~= currentZone or LastZoneNum ~= currentZoneNum)) then
			if
				(LastZone ~= nil and LastZoneNum ~= nil) and
				(LastZone ~= currentZone or LastZoneNum ~= currentZoneNum)
			then
				TriggerEvent('esx_boat:hasExitedMarker', LastZone)
				hasExited = true
			end

			HasAlreadyEnteredMarker = true
			LastZone = currentZone
			LastZoneNum = currentZoneNum

			TriggerEvent('esx_boat:hasEnteredMarker', currentZone, currentZoneNum)
		end

		if not hasExited and not isInMarker and HasAlreadyEnteredMarker then
			HasAlreadyEnteredMarker = false
			TriggerEvent('esx_boat:hasExitedMarker')
		end

		if letSleep then
			Citizen.Wait(500)
		end
	end
end)

