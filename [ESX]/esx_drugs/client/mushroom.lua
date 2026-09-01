local spawnedMushroom = 1
local MushroomPlants = {}
local isPickingUp, isProcessing = false, false

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(1000)
		local coords = GetEntityCoords(PlayerPedId())

		if GetDistanceBetweenCoords(coords, Config.FieldZones.MushroomField.coords, true) < 40 then

			SpawnMushroomPlants()
			Citizen.Wait(1000)
		else
			Citizen.Wait(1000)
		end
	end
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		local playerPed = PlayerPedId()
		local coords = GetEntityCoords(playerPed)
		local nearbyObject, nearbyID

		for i=1, #MushroomPlants, 1 do
			if GetDistanceBetweenCoords(coords, GetEntityCoords(MushroomPlants[i]), false) < 1 then
				nearbyObject, nearbyID = MushroomPlants[i], i
			end
		end

		if nearbyObject and IsPedOnFoot(playerPed) and not IsPedUsingAnyScenario(playerPed) then

			if not isPickingUp then
				ESX.ShowHelpNotification(_U('mushroom_pickupprompt'))
			end

			if not isPickingUp and IsControlJustReleased(0, 38) then

				ESX.TriggerServerCallback('esx_jk_drugs:canPickUp', function(canPickUp)

					if canPickUp then

						isPickingUp = true
						TaskStartScenarioInPlace(playerPed, 'world_human_gardener_plant', 0, false)
						TriggerEvent("mythic_progbar:client:progress", {
							name = "harvest_Mushroom",
							duration = 3500,
							label = "Bardasht Gharch",
							useWhileDead = false,
							canCancel = true,
							controlDisables = {
								disableMovement = true,
								disableCarMovement = true,
								disableMouse = false,
								disableCombat = true,
							},
						}, function(status)
							if not status then

							table.remove(MushroomPlants, nearbyID)
							spawnedMushroom = spawnedMushroom - 1

							ClearPedTasks(playerPed)
							ESX.Game.DeleteObject(nearbyObject)

							TriggerServerEvent('esx_jk_drugs:pickedUpmushroom', GetForensicSnapshot())
							isPickingUp = false

							elseif status then

								ClearPedTasksImmediately(playerPed)
								isPickingUp = false

							end
						end)


					else
						ESX.ShowNotification(_U('mushroom_inventoryfull'))
					end
				end, 'mushroom')
				isPickingUp = false
			end
		else
			Citizen.Wait(500)
		end

	end

end)

AddEventHandler('onResourceStop', function(resource)
	if resource == GetCurrentResourceName() then
		for k, v in pairs(MushroomPlants) do
			ESX.Game.DeleteObject(v)
		end
	end
end)

function SpawnMushroomPlants()
	while spawnedMushroom < 10 do
		Citizen.Wait(0)
		local MushroomCoords = GenerateMushroomCoords()

		ESX.Game.SpawnLocalObject('prop_weed_02', MushroomCoords, function(obj)
			PlaceObjectOnGroundProperly(obj)
			FreezeEntityPosition(obj, true)

			table.insert(MushroomPlants, obj)
			spawnedMushroom = spawnedMushroom + 1
		end)
	end
end

function ValidateMushroomCoord(plantCoord)
	if spawnedMushroom > 0 then
		local validate = true

		for k, v in pairs(MushroomPlants) do
			if GetDistanceBetweenCoords(plantCoord, GetEntityCoords(v), true) < 5 then
				validate = false
			end
		end

		if GetDistanceBetweenCoords(plantCoord, Config.FieldZones.MushroomField.coords, false) > 50 then
			validate = false
		end

		return validate
	else
		return true
	end
end

function GenerateMushroomCoords()
	while true do
		Citizen.Wait(1)

		local MushroomCoordX, MushroomCoordY

		math.randomseed(GetGameTimer())
		local modX = math.random(-90, 90)

		Citizen.Wait(100)

		math.randomseed(GetGameTimer())
		local modY = math.random(-90, 90)

		MushroomCoordX = Config.FieldZones.MushroomField.coords.x + modX
		MushroomCoordY = Config.FieldZones.MushroomField.coords.y + modY

		local coordZ = GetCoordZ(MushroomCoordX, MushroomCoordY)
		local coord = vector3(MushroomCoordX, MushroomCoordY, coordZ)

		if ValidateMushroomCoord(coord) then
			return coord
		end
	end
end

function GetCoordZ(x, y)
	local groundCheckHeights = { 70.0, 71.0, 72.0, 73.0, 74.0, 75.0, 76.0, 77.0, 78.0, 79.0, 80.0, 81.0, 82.0, 83.0, 84.0, 85.0, 86.0, 87.0, 88.0, 89.0, 90.0, 91.0, 92.0, 93.0, 94.0, 95.0, 96.0, 97.0, 98.0, 99.0, 100.0, 101.0, 102.0, 103.0, 104.0, 105.0, 106.0, 107.0, 108.0, 109.0, 110.0 }

	for i, height in ipairs(groundCheckHeights) do
		local foundGround, z = GetGroundZFor_3dCoord(x, y, height)

		if foundGround then
			return z
		end
	end
	return 95.0
end