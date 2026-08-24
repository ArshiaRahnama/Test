--[[
	Client side for Turf Wars Inc. Just the HQ (boss action = rent menu,
	cloakroom, vehicle spawn) - the actual paintball match UI/flow is 100%
	handled by the existing [ARSHIA]/paintball resource.
]]

local TurfBlip
CreateThread(function()
	TurfBlip = AddBlipForCoord(TurfCo.HQ.x, TurfCo.HQ.y, TurfCo.HQ.z)
	SetBlipSprite(TurfBlip, TurfCo.Blip.Sprite)
	SetBlipColour(TurfBlip, TurfCo.Blip.Color)
	SetBlipScale(TurfBlip, TurfCo.Blip.Scale)
	SetBlipAsShortRange(TurfBlip, true)
	BeginTextCommandSetBlipName("STRING")
	AddTextComponentString(GetDisplayLabel(TurfCo.Job, TurfCo.Label))
	EndTextCommandSetBlipName(TurfBlip)
end)

RegisterNetEvent('uniquecafejobs:corp:holdingRenamed')
AddEventHandler('uniquecafejobs:corp:holdingRenamed', function(job, newName)
	CustomNames[job] = newName
	if job == TurfCo.Job and TurfBlip then
		BeginTextCommandSetBlipName("STRING")
		AddTextComponentString(newName)
		EndTextCommandSetBlipName(TurfBlip)
	end
end)

CreateThread(function()
	exports.ox_target:addBoxZone({
		coords = vec3(TurfCo.BossAction.Pos.x, TurfCo.BossAction.Pos.y, TurfCo.BossAction.Pos.z),
		size = vec3(1.5, 1.5, 1.5),
		rotation = 45,
		debug = false,
		options = {
			{
				name = 'turfco_boss',
				icon = TurfCo.BossAction.Icon,
				label = TurfCo.BossAction.Name,
				canInteract = function()
					return PlayerData and PlayerData.job and PlayerData.job.name == TurfCo.Job
				end,
				onSelect = function()
					ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'turfco_boss_root', {
						title    = GetDisplayLabel(TurfCo.Job, TurfCo.Label),
						align    = 'top-left',
						elements = {
							{ label = 'Rent Paintball Map', value = 'rent' },
							{ label = 'Rename Holding', value = 'rename' },
						},
					}, function(data, menu)
						menu.close()
						if data.current.value == 'rent' then
							TriggerServerEvent('uniquecafejobs:turfco:requestRentMenu')
						elseif data.current.value == 'rename' then
							local input = lib.inputDialog('Rename Holding', {
								{ type = 'input', label = 'New name (3-30 chars)', required = true },
							})
							if input and input[1] then
								TriggerServerEvent('uniquecafejobs:corp:renameHolding', input[1])
							end
						end
					end, function(data, menu)
						menu.close()
					end)
				end,
			},
		},
	})

	exports.ox_target:addBoxZone({
		coords = vec3(TurfCo.CloackRoom.Pos.x, TurfCo.CloackRoom.Pos.y, TurfCo.CloackRoom.Pos.z),
		size = vec3(1.5, 1.5, 1.5),
		rotation = 45,
		debug = false,
		options = {
			{
				name = 'turfco_cloakroom',
				icon = TurfCo.CloackRoom.Icon,
				label = TurfCo.CloackRoom.Name,
				canInteract = function()
					return PlayerData and PlayerData.job and PlayerData.job.name == TurfCo.Job
				end,
				onSelect = function()
					OpenCloakroomMenu()
				end,
			},
		},
	})
end)

RegisterNetEvent('uniquecafejobs:turfco:showRentMenu')
AddEventHandler('uniquecafejobs:turfco:showRentMenu', function(rows)
	local elements = {}
	for _, row in ipairs(rows) do
		local label = row.rentedBy
			and ('%s - rented by %s (%d min left)'):format(row.map, row.rentedBy, row.minutesLeft)
			or (row.map .. ' - available')
		table.insert(elements, { label = label, value = row.map, available = row.rentedBy == nil })
	end

	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'turfco_rent_menu', {
		title    = 'Rent Paintball Map',
		align    = 'top-left',
		elements = elements,
	}, function(data, menu)
		if data.current.available then
			local input = lib.inputDialog('Rent ' .. data.current.value, {
				{ type = 'input',  label = 'Gang name', required = true },
				{ type = 'number', label = ('Minutes (max %d, $%d/min)'):format(TurfCo.MaxRentMinutes, TurfCo.RentCostPerMinute), default = 30, min = 1, max = TurfCo.MaxRentMinutes },
			})
			if input and input[1] and input[2] then
				TriggerServerEvent('uniquecafejobs:turfco:rentMap', data.current.value, input[1], input[2])
			end
		end
		menu.close()
	end, function(data, menu)
		menu.close()
	end)
end)

-- ── Vehicle spawn/delete (same pattern as everything else in this resource) ──
CreateThread(function()
	while true do
		Citizen.Wait(0)
		if PlayerData and PlayerData.job and PlayerData.job.name == TurfCo.Job then
			local playerCoords = GetEntityCoords(PlayerPedId())
			local spawnMarker = vector3(TurfCo.SpawnMarker.x, TurfCo.SpawnMarker.y, TurfCo.SpawnMarker.z)
			local deleteMarker = vector3(TurfCo.DeleteMarker.x, TurfCo.DeleteMarker.y, TurfCo.DeleteMarker.z)

			if #(playerCoords - spawnMarker) < 10.0 then
				DrawMarker(36, spawnMarker.x, spawnMarker.y, spawnMarker.z - 1.0, 0, 0, 0, 0, 0, 0, 1.5, 1.5, 1.0, 0, 255, 0, 100, false, true, 2, false, nil, nil, false)
				if #(playerCoords - spawnMarker) < 2.0 then
					ESX.ShowHelpNotification("برای دریافت خودرو ~INPUT_CONTEXT~ را فشار دهید")
					if IsControlJustPressed(0, 38) then
						TriggerServerEvent('uniquecafejobs:turfco:spawnVehicle', TurfCo.SpawnVehicle)
					end
				end
			end

			if #(playerCoords - deleteMarker) < 10.0 then
				DrawMarker(24, deleteMarker.x, deleteMarker.y, deleteMarker.z - 1.0, 0, 0, 0, 0, 0, 0, 1.5, 1.5, 1.0, 255, 0, 0, 100, false, true, 2, false, nil, nil, false)
				if #(playerCoords - deleteMarker) < 2.0 then
					ESX.ShowHelpNotification("برای حذف خودرو ~INPUT_CONTEXT~ را فشار دهید")
					if IsControlJustPressed(0, 38) then
						local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
						if vehicle and vehicle ~= 0 then
							ESX.Game.DeleteVehicle(vehicle)
						end
					end
				end
			end
		else
			Citizen.Wait(1000)
		end
	end
end)

RegisterNetEvent("spawnCarClientTurfco")
AddEventHandler("spawnCarClientTurfco", function(vehicleName)
	local spawnPoint = vector4(TurfCo.SpawnPoint.x, TurfCo.SpawnPoint.y, TurfCo.SpawnPoint.z, TurfCo.SpawnPoint.w)
	ESX.Game.SpawnVehicle(vehicleName, spawnPoint, spawnPoint.w, function(vehicle)
		TaskWarpPedIntoVehicle(PlayerPedId(), vehicle, -1)
		SetEntityAsNoLongerNeeded(vehicle)
	end)
end)
