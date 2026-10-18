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

	-- Not job-gated on purpose: same "Return to Holding Job" pad as
	-- corp_client.lua's 3 HQs, see there for why.
	CreateOXTargetNotJob(TurfCo.HQ, 'Return to Holding Job', 'uniquecafejobs:corp:requestBackToHolding', 'fa-solid fa-rotate-left', nil)
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

-- Gang 2 boss menu: opened with E at TurfCo.BossAction (SimpleMarkers in corp_client.lua)
local function openTurfcoBoss()
					local elements = {
						{ label = 'Rent Paintball Map', value = 'rent' },
						{ label = 'Portfolio Dashboard', value = 'dashboard' },
						{ label = 'Go Work at a Business', value = 'gowork' },
						{ label = 'Manage Portfolio (Rank Up) (Director+)', value = 'portfolio' },
						{ label = 'Manage Business Staff (Director+)', value = 'staff' },
						{ label = 'Open/Close Businesses (Director+)', value = 'toggle' },
						{ label = 'Rename Holding', value = 'rename' },
					}
					if PlayerData.job.grade_name == 'boss' then
						table.insert(elements, { label = 'Set Work Uniform', value = 'set_uniform' })
						table.insert(elements, { label = 'Manage Vehicles', value = 'manage_vehicles' })
						table.insert(elements, { label = 'Transfer Ownership (Owner Only)', value = 'transfer' })
					end

					ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'turfco_boss_root', {
						title    = GetDisplayLabel(TurfCo.Job, TurfCo.Label),
						align    = 'top-left',
						elements = elements,
					}, function(data, menu)
						menu.close()
						if data.current.value == 'rent' then
							TriggerServerEvent('uniquecafejobs:turfco:requestRentMenu')
						elseif data.current.value == 'dashboard' then
							TriggerServerEvent('uniquecafejobs:corp:requestPortfolio')
						elseif data.current.value == 'gowork' then
							TriggerServerEvent('uniquecafejobs:corp:requestOwnedBusinessList')
						elseif data.current.value == 'portfolio' then
							TriggerServerEvent('uniquecafejobs:corp:requestManagePortfolio')
						elseif data.current.value == 'staff' then
							TriggerServerEvent('uniquecafejobs:corp:requestManageStaffList')
						elseif data.current.value == 'toggle' then
							TriggerServerEvent('uniquecafejobs:corp:requestToggleList')
						elseif data.current.value == 'rename' then
							local input = lib.inputDialog('Rename Holding', {
								{ type = 'input', label = 'New name (3-30 chars)', required = true },
							})
							if input and input[1] then
								TriggerServerEvent('uniquecafejobs:corp:renameHolding', input[1])
							end
						elseif data.current.value == 'set_uniform' then
							OpenSetCafeUniformMenu()
						elseif data.current.value == 'manage_vehicles' then
							OpenManageJobVehicleGradesMenu(TurfCo.Job)
						elseif data.current.value == 'transfer' then
							local input = lib.inputDialog('Transfer Ownership', {
								{ type = 'number', label = 'New owner: player server ID', required = true },
							})
							if input and input[1] then
								TriggerServerEvent('uniquecafejobs:corp:transferOwnership', TurfCo.Job, input[1])
							end
						end
					end, function(data, menu)
						menu.close()
					end)
end

RegisterNetEvent('uniquecafejobs:turfco:openBoss')
AddEventHandler('uniquecafejobs:turfco:openBoss', openTurfcoBoss)

CreateThread(function()
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

-- Billing (Gang 2 staff): bills a nearby customer for a 30-day rental.
RegisterNetEvent('uniquecafejobs:turfco:showRentMenu')
AddEventHandler('uniquecafejobs:turfco:showRentMenu', function(rows)
	local elements = {}
	for _, row in ipairs(rows) do
		local label = row.rentedBy
			and ('%s - rented by %s (%d days left)'):format(row.map, row.rentedBy, row.daysLeft)
			or (row.map .. ' - free')
		table.insert(elements, { label = label, value = row.map, available = row.rentedBy == nil })
	end
	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'turfco_rent_menu', {
		title = ('Bill Paintball Rental ($%d / %d days)'):format(TurfCo.RentPrice, TurfCo.RentDays),
		align = 'top-left',
		elements = elements,
	}, function(data, menu)
		if data.current.available then
			local input = lib.inputDialog('Bill ' .. data.current.value, {
				{ type = 'input',  label = 'Gang name', required = true },
				{ type = 'number', label = 'Customer server ID (must be within 10m)', required = true },
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

-- Map E-points: anyone can walk up to a paintball map and press E.
local function openMapMenu(map)
	TriggerServerEvent('uniquecafejobs:turfco:requestMapInfo', map)
end

RegisterNetEvent('uniquecafejobs:turfco:mapInfo')
AddEventHandler('uniquecafejobs:turfco:mapInfo', function(map, rentedBy, daysLeft)
	local myGang = PlayerData and PlayerData.gang and PlayerData.gang.name
	local mine = rentedBy and myGang and (myGang:lower():gsub('%s+', '')) == rentedBy

	local elements = {}
	if rentedBy then
		table.insert(elements, MenuInfo(('Rented by %s - %d days left'):format(rentedBy, daysLeft)))
		if mine then
			table.insert(elements, { label = '» Your gang can host paintball here', value = 'noop' })
		else
			table.insert(elements, MenuInfo('Reserved for another gang'))
		end
	else
		table.insert(elements, MenuInfo('Free to play'))
	end

	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'turfco_map_menu', {
		title = 'Paintball - ' .. map,
		align = 'top-left',
		elements = elements,
	}, function(data, menu)
		menu.close()
	end, function(data, menu)
		menu.close()
	end)
end)

CreateThread(function()
	while true do
		Citizen.Wait(0)
		local ped = PlayerPedId()
		local pos = GetEntityCoords(ped)
		local nearAny = false
		for _, map in ipairs(TurfCo.Maps) do
			local p = TurfCo.MapPoints[map]
			if p then
				local d = #(pos - vector3(p.x, p.y, p.z))
				if d < 40.0 then
					nearAny = true
					DrawMarker(1, p.x, p.y, p.z - 1.0, 0, 0, 0, 0, 0, 0, 2.0, 2.0, 0.6, 0, 180, 255, 120, false, true, 2, false, nil, nil, false)
					if d < 2.0 then
						ESX.ShowHelpNotification(('Paintball %s: ~INPUT_CONTEXT~'):format(map))
						if IsControlJustPressed(0, 38) then openMapMenu(map) end
					end
				end
			end
		end
		if not nearAny then Citizen.Wait(500) end
	end
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
					ESX.ShowHelpNotification("Baraye daryafte mashin ~INPUT_CONTEXT~ ro feshar bedid")
					if IsControlJustPressed(0, 38) then
						TriggerServerEvent('uniquecafejobs:turfco:spawnVehicle', TurfCo.SpawnVehicle)
					end
				end
			end

			if #(playerCoords - deleteMarker) < 10.0 then
				DrawMarker(24, deleteMarker.x, deleteMarker.y, deleteMarker.z - 1.0, 0, 0, 0, 0, 0, 0, 1.5, 1.5, 1.0, 255, 0, 0, 100, false, true, 2, false, nil, nil, false)
				if #(playerCoords - deleteMarker) < 2.0 then
					ESX.ShowHelpNotification("Baraye hazfe mashin ~INPUT_CONTEXT~ ro feshar bedid")
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
