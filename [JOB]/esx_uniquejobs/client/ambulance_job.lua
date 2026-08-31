
Keys = {
	["ESC"] = 322, ["F1"] = 288, ["F2"] = 289, ["F3"] = 170, ["F5"] = 166, ["F6"] = 167, ["F7"] = 168, ["F8"] = 169, ["F9"] = 56, ["F10"] = 57,
	["~"] = 243, ["1"] = 157, ["2"] = 158, ["3"] = 160, ["4"] = 164, ["5"] = 165, ["6"] = 159, ["7"] = 161, ["8"] = 162, ["9"] = 163, ["-"] = 84, ["="] = 83, ["BACKSPACE"] = 177,
	["TAB"] = 37, ["Q"] = 44, ["W"] = 32, ["E"] = 38, ["R"] = 45, ["T"] = 245, ["Y"] = 246, ["U"] = 303, ["P"] = 199, ["["] = 39, ["]"] = 40, ["ENTER"] = 18,
	["CAPS"] = 137, ["A"] = 34, ["S"] = 8, ["D"] = 9, ["F"] = 23, ["G"] = 47, ["H"] = 74, ["K"] = 311, ["L"] = 182,
	["LEFTSHIFT"] = 21, ["Z"] = 20, ["X"] = 73, ["C"] = 26, ["V"] = 0, ["B"] = 29, ["N"] = 249, ["M"] = 244, [","] = 82, ["."] = 81,
	["LEFTCTRL"] = 36, ["LEFTALT"] = 19, ["SPACE"] = 22, ["RIGHTCTRL"] = 70,
	["HOME"] = 213, ["PAGEUP"] = 10, ["PAGEDOWN"] = 11, ["DELETE"] = 178,
	["LEFT"] = 174, ["RIGHT"] = 175, ["TOP"] = 27, ["DOWN"] = 173,
	["NENTER"] = 201, ["N4"] = 108, ["N5"] = 60, ["N6"] = 107, ["N+"] = 96, ["N-"] = 97, ["N7"] = 117, ["N8"] = 61, ["N9"] = 118
}

local CurrentAction, CurrentActionMsg, CurrentActionData = nil, '', {}

local HasAlreadyEnteredMarker, LastHospital, LastPart, LastPartNum

local IsBusy, Ended = false, false

local spawnedVehicles, isInShopMenu = {}, false
local DragStatus = {}
local PlayerData              = {}
local Brancard = {}
local DragBrancard = false
  Citizen.CreateThread(function()
	  while ESX == nil do
		  TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		  Citizen.Wait(1)
	  end

	  while ESX.GetPlayerData().job == nil do
		  Citizen.Wait(10)
	  end

	  PlayerData = ESX.GetPlayerData()
  end)

-- Vehicles added live via esx_society's /addcarjob command (job = ambulance) get merged
-- into the static AuthorizedVehicles catalog, and their livery (captured at add-time)
-- is always re-applied on spawn so it never changes.
local CustomVehicleLiveries  = {}
local InjectedVehicleEntries = {}
local InjectedHeliEntries    = {}

local function removeInjected_ambulance(list, injected)
	for _, entry in ipairs(injected) do
		for i = #list, 1, -1 do
			if list[i] == entry then
				table.remove(list, i)
			end
		end
	end
end

Citizen.CreateThread(function()
	while ESX == nil do Citizen.Wait(10) end

	local function mergeCustomVehicles()
		ESX.TriggerServerCallback('esx_society:getCustomVehicles', function(list)
			removeInjected_ambulance(Config_ambulance.AuthorizedVehicles.Shared, InjectedVehicleEntries)
			removeInjected_ambulance(Config_ambulance.AuthorizedVehicles.Sharedheli, InjectedHeliEntries)
			InjectedVehicleEntries = {}
			InjectedHeliEntries    = {}
			CustomVehicleLiveries  = {}

			local custom = list and list['ambulance']
			if not custom then return end

			for _, v in ipairs(custom) do
				local entry = {label = v.label, model = v.model}

				if v.is_heli == 1 then
					table.insert(Config_ambulance.AuthorizedVehicles.Sharedheli, entry)
					table.insert(InjectedHeliEntries, entry)
				else
					table.insert(Config_ambulance.AuthorizedVehicles.Shared, entry)
					table.insert(InjectedVehicleEntries, entry)
				end

				CustomVehicleLiveries[v.model] = tonumber(v.livery) or 0
			end
		end)
	end

	mergeCustomVehicles()

	RegisterNetEvent('society:customVehiclesUpdated')
	AddEventHandler('society:customVehiclesUpdated', mergeCustomVehicles)
end)

-- /dlist (from esx_society) — only react if we're currently on the ambulance job.
-- Ambulance has no separate on/off duty toggle, so /dduty does nothing here.
RegisterNetEvent('esx_society:requestListRequested')
AddEventHandler('esx_society:requestListRequested', function()
	if ESX.PlayerData.job and ESX.PlayerData.job.name == 'ambulance' then
		OpenReqsList_ambulance()
	end
end)

-- This was referenced (as OpenReqsList()) but never implemented — built here
-- to match the same request/accept/decline/finish flow as taxi and mechanic.
function OpenReqsList_ambulance()
	ESX.TriggerServerCallback('esx_ambulancejob:getReqs', function(reqs)
		if not reqs then return end

		local elements = {}
		for i=1, #reqs, 1 do
			table.insert(elements, {
				label  = "Request Id : "..reqs[i].reqid.." | Accept : "..reqs[i].status.." | Distance : ".. ESX.Math.Round(GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()), reqs[i].coord)),
				icname = reqs[i].name,
				reqid  = reqs[i].reqid,
				text   = reqs[i].reason,
				status = reqs[i].status,
				phone  = reqs[i].phone,
				id     = reqs[i].id,
				coord  = reqs[i].coord,
				accept = reqs[i].accept,
			})
		end

		ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'ambulance_reqs_list', {
			title    = "Requests",
			align    = 'bottom-right',
			elements = elements
		}, function(data, menu)

			local elements = {}
			ESX.TriggerServerCallback('esx_ambulancejob:acceptername', function(acceptername, accepterID)
			ESX.TriggerServerCallback('esx_ambulancejob:icname', function(name)

				table.insert(elements, {label = "RequestId : "..data.current.reqid, value = "nil"})
				table.insert(elements, {label = "Accept status : "..data.current.status, value = "nil"})

				if data.current.accept == "open" then
					table.insert(elements, {label = "Accept", value = "yes"})
					table.insert(elements, {label = "Request by : "..data.current.icname.." ("..data.current.id..")", value = "nil"})
				else
					table.insert(elements, {label = "Accepted by : "..acceptername.." ("..accepterID..")", value = "nil"})
					table.insert(elements, {label = "Request by : "..data.current.icname.." ("..data.current.id..")", value = "nil"})
				end

				if acceptername == name then
					table.insert(elements, {label = "Decline", value = "decline"})
				end

				table.insert(elements, {label = "Pin location", value = "loc"})
				table.insert(elements, {label = "Call", value = "call"})

				ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'ambulance_req', {
					title    = "Request",
					align    = 'bottom-right',
					elements = elements
				}, function(data2, menu2)
					menu2.close()

					if data2.current.value == 'yes' then
						TriggerServerEvent('esx_ambulancejob:areqs', data.current.reqid)
						menu.close()
					elseif data2.current.value == 'call' then
						TriggerEvent('Unique_Phone:Cleant:CallNumberr', data.current.id)
					elseif data2.current.value == 'loc' then
						SetNewWaypoint(data.current.coord.x, data.current.coord.y)
					elseif data2.current.value == 'decline' then
						TriggerServerEvent('esx_ambulancejob:decline', data.current.reqid)
						menu.close()
					end
				end, function(data2, menu2)
					menu2.close()
				end)

			end)
			end, data.current.reqid)

		end, function(data, menu)
			menu.close()
		end)
	end)
end

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
  PlayerData.job = job
end)

function SetVehicleMaxMods_ambulance(vehicle)
	local props = {
		modEngine       = 5,
		modBrakes		= 5,
		windowTint		= 2,
		modArmor		= 5,
		modTransmission = 2,
		modSuspension   = 4,
		plateIndex      = 1,
		modTurbo        = true,
	}

	ESX.Game.SetVehicleProperties(vehicle, props)
	SetVehicleDirtLevel(vehicle, 0.0)
end

function SetVehicleMaxMods2_ambulance(vehicle)
	local props = {
		modEngine       = 5,
		modBrakes		= 5,
		windowTint		= 1,
		modArmor		= 5,
		modTransmission = 2,
		modSuspension   = 4,
		color1          = 0,
		color2          = 0,
		modTurbo        = true,
	}


	ESX.Game.SetVehicleProperties(vehicle, props)
	SetVehicleDirtLevel(vehicle, 0.0)
end



function OpenArmoryMenu_ambulance(station)

	local elements = {
		{label = _U('remove_object'),  value = 'get_stock'},
		{label = _U('deposit_object'), value = 'put_stock'}
	}

	if PlayerData.job.name == "ambulance" and PlayerData.job.grade >= 10 then
		table.insert(elements, {label = _U('buy_items'), value = 'buy_items'})

	end

	ESX.UI.Menu.CloseAll()

	ESX.UI.Menu.Open(
		'default', GetCurrentResourceName(), 'armory',
		{
		title    = _U('armory'),
		align    = 'bottom-right',
		elements = elements,
		},
		function(data, menu)

		if data.current.value == 'put_stock' then
			OpenPutStocksMenu_ambulance()
		end

		if data.current.value == 'get_stock' then
			OpenGetStocksMenu_ambulance()
		end

		if data.current.value == 'buy_items' then
			OpenBuyItemsMenu_ambulance(station)
		end

		end, function(data, menu)

		menu.close()

		CurrentAction     = 'menu_armory'
		CurrentActionMsg  = _U('open_armory')
		CurrentActionData = {station = station}
		end
	)
end



function OpenBuyItemsMenu_ambulance(station)

	ESX.TriggerServerCallback('esx_ambulancejob:getStockItems', function(weapons)

		local elements = {}

		for i=1, #Config_ambulance.Hospitals[station].AuthorizedItems, 1 do

			local weapon = Config_ambulance.Hospitals[station].AuthorizedItems[i]
			local count  = 0

			for i=1, #weapons, 1 do
				if weapons[i].name == weapon.name then
				count = weapons[i].count
				break
				end
			end

			table.insert(elements, {label = 'x' .. count .. ' ' .. weapon.label .. ' $' .. weapon.price, value = weapon.name, price = weapon.price})

		end

		ESX.UI.Menu.Open(
		'default', GetCurrentResourceName(), 'armory_buy_weapons',
		{
			title    = _U('buy_item_menu'),
			align    = 'left',
			elements = elements,
		},
		function(data, menu)
			local tedad = lib.inputDialog('Enter Buy Weapon', {'Tedad Weapon (1 , 99)'}, {max = 2})
			if not tedad then return end
			cuntt = json.encode(tedad)
			ESX.TriggerServerCallback('esx_ambulancejob:buy', function(hasEnoughMoney)

				if hasEnoughMoney then
    ESX.TriggerServerCallback('esx_ambulancejob:buyArmoryItem', function()
    OpenBuyItemsMenu_ambulance(station)


    local steamHex = ESX.GetPlayerData().identifier

    TriggerServerEvent('logmdBuyItem', ESX.GetPlayerData().name, GetPlayerServerId(PlayerId()), steamHex, data.current.label, math.floor(tonumber(tedad[1])), data.current.price * math.floor(tonumber(tedad[1])))
    end, data.current.value, false, math.floor(tonumber(tedad[1])))



				end

			end, data.current.price *  math.floor(tonumber(tedad[1])))

		end,
		function(data, menu)
			menu.close()

		end
		)

	end)
end

function GetDivisionName_ambulance(getdivision, job)
    for _, division in ipairs(getdivision) do
        if division.status and division.job == job then
            return division.name
        end
    end
    return nil
end

function OpenGetStocksMenu_ambulance()
    local grade = PlayerData.job.grade
    local job = PlayerData.job.name

    ESX.TriggerServerCallback("esx_ambulancejob:getStockItems", function(items)
        ESX.TriggerServerCallback('esx_society:GetDivisionsPlayer', function(getdivision)
            local dvisionName = GetDivisionName_ambulance(getdivision, job)

            ESX.TriggerServerCallback('esx_society:getDivisionItems', function(authorizedItems)

                if type(authorizedItems) ~= "table" then
                    authorizedItems = {}
                end

                ESX.TriggerServerCallback('esx_society:getItems', function(jobGradeItems)
                    local elements = {}

                    for _, item in ipairs(items) do
                        for _, sharedItem in ipairs(jobGradeItems) do
                            if sharedItem.name == item.name and sharedItem.status == true then
                                table.insert(elements, {label = "x" .. item.count .. " " .. item.label, value = item.name})
                                break
                            end
                        end
                    end

                    for _, item in ipairs(items) do
                        for _, divisionItem in ipairs(authorizedItems) do
                            if divisionItem.name == item.name and divisionItem.status == true then

                                local alreadyAdded = false
                                for _, element in ipairs(elements) do
                                    if element.value == item.name then
                                        alreadyAdded = true
                                        break
                                    end
                                end

                                if not alreadyAdded then
                                    table.insert(elements, {label = "x" .. item.count .. " " .. item.label, value = item.name})
                                end
                                break
                            end
                        end
                    end

                    if #elements == 0 then
                        table.insert(elements, {label = "Not Items", value = nil})
                    end

                    ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'stocks_menu', {
                        title = 'Bar Dasht Item',
                        align = 'left',
                        elements = elements
                    }, function(data, menu)
                        if data.current.value == nil then
                            return
                        end

                        local itemName = data.current.value

                        ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'stocks_menu_get_item_count', {
                            title = _U('quantity')
                        }, function(data2, menu2)
                            local count = tonumber(data2.value)

                            if count == nil then
                                ESX.ShowNotification(_U('quantity_invalid'))
                            else
                                menu2.close()
                                menu.close()

								TriggerServerEvent('esx_ambulancejob:getStockItem', itemName, count)

								local steamHex = ESX.GetPlayerData().identifier


								TriggerServerEvent('logmdGetItem', ESX.GetPlayerData().name, GetPlayerServerId(PlayerId()), steamHex, data.current.label, count)



                                Citizen.Wait(300)
                                OpenGetStocksMenu_ambulance()
                            end
                        end, function(data2, menu2)
                            menu2.close()
                        end)
                    end, function(data, menu)
                        menu.close()

                    end)
                end, grade, job)
            end, dvisionName, job)
        end, PlayerData.identifier)
    end)
end



function OpenPutStocksMenu_ambulance()

	ESX.TriggerServerCallback('esx_ambulancejob:getPlayerInventory', function(inventory)

	  local elements = {}

	  for i=1, #inventory.items, 1 do

		local item = inventory.items[i]

		if item.count > 0 then
		  table.insert(elements, {label = item.label .. ' x' .. item.count, type = 'item_standard', value = item.name})
		end

	  end

	  ESX.UI.Menu.Open(
		'default', GetCurrentResourceName(), 'stocks_menu',
		{
		  title    = "Gozashtan Item",
		  align    = 'bottom-right',
		  elements = elements
		},
		function(data, menu)

		  local itemName = data.current.value

		  ESX.UI.Menu.Open(
			'dialog', GetCurrentResourceName(), 'stocks_menu_put_item_count',
			{
			  title = _U('quantity')
			},
			function(data2, menu2)

			  local count = tonumber(data2.value)

			  if count == nil then
				ESX.ShowNotification(_U('quantity_invalid'))
			  else
				menu2.close()
				menu.close()
				TriggerServerEvent('esx_ambulancejob:putStockItems', itemName, count)

				local steamHex = ESX.GetPlayerData().identifier


				TriggerServerEvent('logmdPutItem', ESX.GetPlayerData().name, GetPlayerServerId(PlayerId()), steamHex, data.current.label, count)



				Citizen.Wait(300)
				OpenPutStocksMenu_ambulance()
			  end

			end,
			function(data2, menu2)
			  menu2.close()
			end
		  )

		end,
		function(data, menu)
		  menu.close()
		end
	  )

	end)

end

function PlayerRiveiveMenu_ambulance()
	ESX.UI.Menu.CloseAll()
	dataplayer = {}
	local elements = {}
	local nearbyPlayers = getNearbyPlayers_ambulance(2)
	local elements = {}
	table.insert(elements, {label = "ID"  , value = " " })
	local playerId22 = GetPlayerServerId(PlayerId())
	local names = nil

	for _, player in ipairs(nearbyPlayers) do
		local playerPed = GetPlayerPed(GetPlayerFromServerId(player.id))
		local health = GetEntityHealth(playerPed)
		if player.id ~= playerId22 and health ~= 0 then
			ESX.TriggerServerCallback("esx:checkInjure", function(IsDead)
				if IsDead then
					table.insert(elements, { label = "Player ID : " .. " [" .. player.id .. "]", value = player.id })
				end
			end, player.id)
		end
	end

	Citizen.Wait(500)

	ESX.UI.Menu.Open(
		'default', GetCurrentResourceName(), 'rivive_player',
		{
			title = "Rivive Player ID",
			align = 'center-left',
			elements = elements
		}, function(data, menu)

			if data.current.value ~= " " then

				local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()

				if closestPlayer == -1 or closestDistance > 2.0 then
					ESX.ShowNotification("No players nearby!")
				else

					local playerid = data.current.value

					IsBusy = true
						ESX.TriggerServerCallback('esx_ambulancejob:getItemAmount', function(quantity)
							if quantity > 0 then

								local closestPlayerPed = GetPlayerPed(playerid)
								ESX.TriggerServerCallback("esx:checkInjure", function(IsDead)

									if IsDead ~= false and IsDead ~= 'done' then
										ESX.UI.Menu.CloseAll()
										local camanimDict = "mini@cpr@char_a@cpr_def"
										local camanimDict1 = "mini@cpr@char_a@cpr_str"
										local playerPed = GetPlayerPed(-1)
										TriggerServerEvent('esx_ambulancejob:synServerTestcDeadrpBodyx', PedToNet(GetPlayerPed(-1)), playerid)
										Ended = false
										Citizen.CreateThread(function()
											while not Ended do
												Wait(1)
												DisableControlAction(0, Keys['F1'],true)

												DisableControlAction(0, Keys['F3'],true)
												DisableControlAction(0, Keys['F5'],true)
												DisableControlAction(0, Keys['R'], true)
												DisableControlAction(0, Keys['W'],true)
												DisableControlAction(0, Keys['S'],true)
												DisableControlAction(0, Keys['A'],true)
												DisableControlAction(0, Keys['D'], true)
												DisableControlAction(0, Keys['X'], true)
												DisableControlAction(0, Keys['SPACE'], true)
												DisableControlAction(0, Keys['K'], true)

												DisableControlAction(0, 24, true)
												DisableControlAction(0, 257, true)
												DisableControlAction(0, 25, true)
												DisableControlAction(0, 47, true)
												DisableControlAction(0, 264, true)
												DisableControlAction(0, 257, true)
												DisableControlAction(0, 140, true)
												DisableControlAction(0, 141, true)
												DisableControlAction(0, 142, true)
												DisableControlAction(0, 143, true)
												DisableControlAction(0, 263, true)
												DisableControlAction(0, 27, true)
												DisableControlAction(0, 23, true)
												DisableControlAction(0, 182, true)
											end
										end)
										ESX.Streaming.RequestAnimDict(camanimDict1)
										ESX.Streaming.RequestAnimDict(camanimDict, function()
											Citizen.Wait(500)
											TaskPlayAnim(playerPed, camanimDict, "cpr_intro", 8.0, 8.0, -1, 0, 0, false, false, false)
											Citizen.Wait(15800)
											TaskPlayAnim(playerPed, camanimDict1, "cpr_pumpchest", 8.0, 8.0, -1, 1, 0, false, false, false)
											Citizen.Wait(5000)
											TaskPlayAnim(playerPed, camanimDict1, "cpr_success", 8.0, 8.0, -1, 0, 0, false, false, false)
											Citizen.Wait(28600)
											Ended = true
										end)

										ESX.ShowNotification(_U('revive_inprogress'))
										TriggerServerEvent('esx_ambulancejob:removeItem', 'medikit')
										TriggerServerEvent('esx_ambulancejob:revivex', playerid)

										if Config_ambulance.reviveReward > 0 then
											ESX.ShowNotification(_U('revive_complete_award', GetPlayerName(closestPlayer), Config_ambulance.reviveReward))
										else
											ESX.ShowNotification(_U('revive_complete', GetPlayerName(closestPlayer)))
										end
									else
										ESX.ShowNotification(_U('player_not_unconscious'))
									end
								end, playerid)
							else
								ESX.ShowNotification(_U('not_enough_medikit'))
							end
							IsBusy = false
						end, 'medikit')

					stopActiveMarker_ambulance()

					ESX.UI.Menu.CloseAll()


				end


		end

		end, function(data, menu)
			menu.close()


		end, function(data, menu)
			local tttrp = true
			stopActiveMarker_ambulance()
			Wait(5)

			local targetPlayer = GetPlayerPed(GetPlayerFromServerId(data.current.value))
			activeMarkerThread = true

			local playerId22 = GetPlayerServerId(PlayerId())

			while activeMarkerThread and tttrp do
				if DoesEntityExist(targetPlayer) then
					local coords = GetEntityCoords(targetPlayer)
					if data.current.value ~= " " then


						DrawMarker(23, coords.x, coords.y, coords.z-1, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.7, 0.7, 0.7, 0, 255, 0, 100, false, true, 2, nil, nil, false)

						if IsControlJustPressed(0, 177) or IsControlJustPressed(0, 322) then
							tttrp = false
						end
					else

					end
				else
					stopActiveMarker_ambulance()
				end
				Wait(0)
			end

		end,function()
			OpenMobileAmbulanceActionsMenu_ambulance()
		end
	)
end

function PlayerSmalHealMenu_ambulance()
	ESX.UI.Menu.CloseAll()
	dataplayer = {}
	local elements = {}
	local nearbyPlayers = getNearbyPlayers_ambulance(2)
	local elements = {}
	table.insert(elements, {label = "ID"  , value = " " })
	local playerId22 = GetPlayerServerId(PlayerId())
	local names = nil

	for _, player in ipairs(nearbyPlayers) do
		local playerPed = GetPlayerPed(GetPlayerFromServerId(player.id))
		local health = GetEntityHealth(playerPed)
		if player.id ~= playerId22 and health ~= 0 then
			ESX.TriggerServerCallback("esx:checkInjure", function(IsDead)
				if not IsDead then
					table.insert(elements, { label = "Player ID : " .. " [" .. player.id .. "]", value = player.id })
				end
			end, player.id)
		end
	end

	Citizen.Wait(500)

	ESX.UI.Menu.Open(
		'default', GetCurrentResourceName(), 'rivive_player',
		{
			title = "Rivive Player ID",
			align = 'center-left',
			elements = elements
		}, function(data, menu)

			if data.current.value ~= " " then

				local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()

				if closestPlayer == -1 or closestDistance > 2.0 then
					ESX.ShowNotification("No players nearby!")
				else

					local playerid = data.current.value

					ESX.TriggerServerCallback('esx_ambulancejob:getItemAmount', function(quantity)
						if quantity > 0 then
							local closestPlayerPed = GetPlayerPed(GetPlayerFromServerId(playerid))
							local health = GetEntityHealth(closestPlayerPed)

							if health > 0 then
								local playerPed = PlayerPedId()

								IsBusy = true
								ESX.ShowNotification(_U('heal_inprogress'))
								TaskStartScenarioInPlace(playerPed, 'CODE_HUMAN_MEDIC_TEND_TO_DEAD', 0, true)
								Citizen.Wait(10000)
								ClearPedTasks(playerPed)

								TriggerServerEvent('esx_ambulancejob:removeItem', 'medikit')
								TriggerServerEvent('esx_ambulancejob:heal', GetPlayerServerId(closestPlayer), 'big')
								ESX.ShowNotification(_U('heal_complete', GetPlayerName(closestPlayer)))
								IsBusy = false
							else
								ESX.ShowNotification(_U('player_not_conscious'))
							end
						else
							ESX.ShowNotification(_U('not_enough_medikit'))
						end
					end, 'medikit')

					stopActiveMarker_ambulance()

					ESX.UI.Menu.CloseAll()


				end


		end

		end, function(data, menu)
			menu.close()


		end, function(data, menu)
			local tttrp = true
			stopActiveMarker_ambulance()
			Wait(5)

			local targetPlayer = GetPlayerPed(GetPlayerFromServerId(data.current.value))
			activeMarkerThread = true

			local playerId22 = GetPlayerServerId(PlayerId())

			while activeMarkerThread and tttrp do
				if DoesEntityExist(targetPlayer) then
					local coords = GetEntityCoords(targetPlayer)
					if data.current.value ~= " " then


						DrawMarker(23, coords.x, coords.y, coords.z-1, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.7, 0.7, 0.7, 0, 255, 0, 100, false, true, 2, nil, nil, false)

						if IsControlJustPressed(0, 177) or IsControlJustPressed(0, 322) then
							tttrp = false
						end
					else

					end
				else
					stopActiveMarker_ambulance()
				end
				Wait(0)
			end

		end,function()
			OpenMobileAmbulanceActionsMenu_ambulance()
		end
	)
end

function PlayerBigHealMenu_ambulance()
	ESX.UI.Menu.CloseAll()
	dataplayer = {}
	local elements = {}
	local nearbyPlayers = getNearbyPlayers_ambulance(2)
	local elements = {}
	table.insert(elements, {label = "ID"  , value = " " })
	local playerId22 = GetPlayerServerId(PlayerId())
	local names = nil

	for _, player in ipairs(nearbyPlayers) do
		local playerPed = GetPlayerPed(GetPlayerFromServerId(player.id))
		local health = GetEntityHealth(playerPed)
		if player.id ~= playerId22 and health ~= 0 then
			ESX.TriggerServerCallback("esx:checkInjure", function(IsDead)
				if not IsDead then
					table.insert(elements, { label = "Player ID : " .. " [" .. player.id .. "]", value = player.id })
				end
			end, player.id)
		end
	end

	Citizen.Wait(500)

	ESX.UI.Menu.Open(
		'default', GetCurrentResourceName(), 'rivive_player',
		{
			title = "Rivive Player ID",
			align = 'center-left',
			elements = elements
		}, function(data, menu)

			if data.current.value ~= " " then

				local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()

				if closestPlayer == -1 or closestDistance > 2.0 then
					ESX.ShowNotification("No players nearby!")
				else

					local playerid = data.current.value

					ESX.TriggerServerCallback('esx_ambulancejob:getItemAmount', function(quantity)
						if quantity > 0 then
							local closestPlayerPed = GetPlayerPed(GetPlayerFromServerId(playerid))
							local health = GetEntityHealth(closestPlayerPed)
							if health > 0 then
								local playerPed = PlayerPedId()
								IsBusy = true
								ESX.ShowNotification(_U('heal_inprogress'))
								TaskStartScenarioInPlace(playerPed, 'CODE_HUMAN_MEDIC_TEND_TO_DEAD', 0, true)
								Citizen.Wait(10000)
								ClearPedTasks(playerPed)
								TriggerServerEvent('esx_ambulancejob:removeItem', 'bandage')
								TriggerServerEvent('esx_ambulancejob:heal', GetPlayerServerId(closestPlayer), 'small')
								ESX.ShowNotification(_U('heal_complete', GetPlayerName(closestPlayer)))
								IsBusy = false
							else
								ESX.ShowNotification(_U('player_not_conscious'))
							end
						else
							ESX.ShowNotification(_U('not_enough_bandage'))
						end
					end, 'bandage')

					stopActiveMarker_ambulance()

					ESX.UI.Menu.CloseAll()


				end


		end

		end, function(data, menu)
			menu.close()


		end, function(data, menu)
			local tttrp = true
			stopActiveMarker_ambulance()
			Wait(5)

			local targetPlayer = GetPlayerPed(GetPlayerFromServerId(data.current.value))
			activeMarkerThread = true

			local playerId22 = GetPlayerServerId(PlayerId())

			while activeMarkerThread and tttrp do
				if DoesEntityExist(targetPlayer) then
					local coords = GetEntityCoords(targetPlayer)
					if data.current.value ~= " " then


						DrawMarker(23, coords.x, coords.y, coords.z-1, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.7, 0.7, 0.7, 0, 255, 0, 100, false, true, 2, nil, nil, false)

						if IsControlJustPressed(0, 177) or IsControlJustPressed(0, 322) then
							tttrp = false
						end
					else

					end
				else
					stopActiveMarker_ambulance()
				end
				Wait(0)
			end

		end,function()
			OpenMobileAmbulanceActionsMenu_ambulance()
		end
	)
end

function PlayerBlingMenu_ambulance()
	ESX.UI.Menu.CloseAll()
	dataplayer = {}
	local elements = {}
	local nearbyPlayers = getNearbyPlayers_ambulance(3)
	local elements = {}
	table.insert(elements, {label = "ID"  , value = " " })
	local playerId22 = GetPlayerServerId(PlayerId())
	local names = nil

	for _, player in ipairs(nearbyPlayers) do
		local playerPed = GetPlayerPed(GetPlayerFromServerId(player.id))
		local health = GetEntityHealth(playerPed)
		if player.id ~= playerId22 and health ~= 0 then

            table.insert(elements, { label = "Player ID : " .. " [" .. player.id .. "]", value = player.id })

		end
	end

	Citizen.Wait(500)

	ESX.UI.Menu.Open(
		'default', GetCurrentResourceName(), 'bling_player',
		{
			title = "Bling Player ID",
			align = 'center-left',
			elements = elements
		}, function(data, menu)

			if data.current.value ~= " " then

				local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()

				if closestPlayer == -1 or closestDistance > 2.0 then
					ESX.ShowNotification("No players nearby!")
				else

					local playerid = data.current.value

                    ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'billing', {
                        title = 'Qeymat'
                    }, function(data2, menu2)
                        local amount = tonumber(data2.value)
                        if amount == nil then

                        else
                            menu2.close()
                            if closestPlayer == -1 or closestDistance > 2.0 then
                                ESX.ShowNotification("No players nearby!")
                            else
                                TriggerServerEvent("esx_ambulancejob:blingrequest", playerid, GetPlayerServerId(PlayerId()), amount)

                            end
                        end
                    end, function(data2, menu2)
                        menu2.close()
                    end)

					stopActiveMarker_ambulance()




				end


		end



		end, function(data, menu)
			menu.close()


		end, function(data, menu)
			local tttrp = true
			stopActiveMarker_ambulance()
			Wait(5)

			local targetPlayer = GetPlayerPed(GetPlayerFromServerId(data.current.value))
			activeMarkerThread = true

			local playerId22 = GetPlayerServerId(PlayerId())

			while activeMarkerThread and tttrp do
				if DoesEntityExist(targetPlayer) then
					local coords = GetEntityCoords(targetPlayer)
					if data.current.value ~= " " then


						DrawMarker(23, coords.x, coords.y, coords.z-1, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.7, 0.7, 0.7, 0, 255, 0, 100, false, true, 2, nil, nil, false)

						if IsControlJustPressed(0, 177) or IsControlJustPressed(0, 322) then
							tttrp = false
						end
					else

					end
				else
					stopActiveMarker_ambulance()
				end
				Wait(0)
			end

		end,function()

		end
	)
end

RegisterNetEvent('esx_ambulancejob:OpenMenuDialog')
AddEventHandler('esx_ambulancejob:OpenMenuDialog', function(player, target, amount)

    ESX.UI.Menu.CloseAll()
        ESX.UI.Menu.Open('question', GetCurrentResourceName(), 'Aks_For_bling_md',
        {
            title 	 = 'Qgabz Medic',
            align    = 'center',
            question = "Aya Shoma Qhabz ("..amount.."$) Ra Ghabol Darid ?",
            elements = {
                {label = 'Bale', value = 'yes'},
                {label = 'Kheir', value = 'no'},
            },
        },
        function(data, menu)
            if data.current.value == 'yes' then
                TriggerServerEvent('esx_billing:send2Bill2', target, player, 'society_ambulance', 'Ambulance', amount)
                TriggerServerEvent("esx_ambulancejob:ChatMessage",target, player, true)

                ESX.UI.Menu.CloseAll()
            elseif data.current.value == 'no' then

                TriggerServerEvent("esx_ambulancejob:ChatMessage",target, player, false)
                menu.close()

            end
        end
    )
end)

function getNearbyPlayers_ambulance(radius)
    local players = {}
    local playerPed = PlayerPedId()
    local playerCoords = GetEntityCoords(playerPed)

    for _, playerId in ipairs(GetActivePlayers()) do
        local targetPed = GetPlayerPed(playerId)
        local targetCoords = GetEntityCoords(targetPed)
        local distance = #(playerCoords - targetCoords)

        if distance <= radius then
            table.insert(players, {
                id = GetPlayerServerId(playerId),
                name = GetPlayerName(playerId)
            })
        end
    end

    return players
end

local activeMarkerTarget = nil
function stopActiveMarker_ambulance()
    if activeMarkerThread then
        activeMarkerThread = nil
    end
end

local prop = nil
function OpenMobileAmbulanceActionsMenu_ambulance()
	ESX.TriggerServerCallback('esx_ambulancejob:list', function(tedad)
		ESX.UI.Menu.CloseAll()
		ESX.TriggerServerCallback('esx_society:divisionsPlayer', function(check)

			local elements = {}

			local isdivision = false
			local playerjob =  ESX.GetPlayerData().job.name
			for k, v in pairs(check) do
				if v.job == playerjob then
					if #check >= 1 then

						isdivision = true
						break
					end
				end
			end

			elements = {
				{label = 'Request List ('..tedad..')',   value = 'requests'},
				{label = "Citizen Interaction's", value = 'citizen_interactions'},
				{label = "Brancard Option's", value = 'brancardOP'},

				{label = "Put In Vehicle", value = 'put_in_vehicle'},
				{label = "Out Of The Vehicle", value = 'put_out_vehicle'},
			}

			if isdivision then
				table.insert(elements, {label = "Extera Division", value = 'extera_division'})
			end

			ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'citizen_interaction', {
				title    = _U('ems_menu_title'),
				align    = 'top-left',
				elements = elements
			}, function(data, menu)
				if IsBusy then return end
				local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
				if data.current.value == 'requests' then
					OpenReqsList_ambulance()
				elseif data.current.value == 'citizen_interactions' then
					local elements = {
						{label = 'Jerahat',   value = 'jrh'},
						{label = _U('ems_menu_revive'), value = 'revive'},
						{label = _U('ems_menu_small'), value = 'big'},
						{label = _U('ems_menu_big'), value = 'small'},
						{label = 'Billing', value = 'billing'},
					}
					ESX.UI.Menu.Open("default", GetCurrentResourceName(),"citizen_interactions", {
						title = "Citizen Interaction's",
						align = "top-left",
						elements = elements
					}, function(data3, menu3)
						local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
						if data3.current.value == 'revive' then
							if closestPlayer == -1 or closestDistance > 2.0 then
								ESX.ShowNotification(_U('no_players'))
							else

								PlayerRiveiveMenu_ambulance()

							end

						elseif data3.current.value == 'jrh' then

							ExecuteCommand("jerahat")

						elseif data3.current.value == 'small' then
							if closestPlayer == -1 or closestDistance > 2.0 then
								ESX.ShowNotification(_U('no_players'))
							else
								PlayerBigHealMenu_ambulance()
							end
						elseif data3.current.value == 'big' then
							if closestPlayer == -1 or closestDistance > 2.0 then
								ESX.ShowNotification(_U('no_players'))
							else
								PlayerSmalHealMenu_ambulance()
							end
						elseif data3.current.value == 'billing' then
							PlayerBlingMenu_ambulance()
						end
					end, function(data3, menu3)
						menu3.close()
					end)
				elseif data.current.value == 'brancardOP' then
						local elements = {
							{label = "Brancard", value = 'brancard'},
							{label = "Drop Brancard", value = 'dropbrancard'},
							{label = "Drag Brancard", value = 'dragbrancard'},
							{label = "Delete Brancard", value = 'unbrancard'},
							{label = "Put In Brancard", value = 'put_in_brancard'},
							{label = "Take Out Brancard", value = 'take_out_brancard'},
						}
						ESX.UI.Menu.Open("default", GetCurrentResourceName(),"brancardOP", {
							title = "Brancard Option's",
							align = "top-left",
							elements = elements
						}, function(data2, menu2)
							local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
							if data2.current.value == 'dragbrancard' then
								if prop == nil then return ESX.ShowNotification("~r~Shoma Berancard Nadarid!") end
								if DragBrancard == true then return ESX.ShowNotification("~r~Berancard Ra Gereftid!") end
								ClearPedTasks(PlayerPedId())
								local x,y,z = table.unpack(GetEntityCoords(PlayerPedId()))
								local xo,yo,zo = table.unpack(GetEntityCoords(prop))
								local distance = #(vector3(x,y,z) - vector3(xo,yo,zo))
								if distance >= 1.5 then return ESX.ShowNotification("~r~Shoma Nazdit Berancard Nistid!") end
								AttachEntityToEntity(prop, PlayerPedId(), GetPedBoneIndex(PlayerPedId(), 24817), -0.5, 1.5, 0.0, -170.0, -90.0, 0.0, true, true, true, true, 1, true)
								loadAnimDict_ambulance("anim@heists@box_carry@")
								TaskPlayAnim(GetPlayerPed(-1), "anim@heists@box_carry@", "idle", 2.0, 2.0, -1, 51, 0, false, false, false)
								DragBrancard = true
								DisableActions()
							elseif data2.current.value == 'dropbrancard' then
								if prop == nil then return ESX.ShowNotification("~r~Shoma Berancard Nadarid!") end
								DetachEntity(prop, false, false)
								PlaceObjectOnGroundProperly(prop)
								ClearPedTasks(PlayerPedId())
								FreezeEntityPosition(prop, true)
								DragBrancard = false
								DisableActions()
							elseif data2.current.value == 'unbrancard' then
								if prop == nil then return ESX.ShowNotification("~r~Shoma Berancard Nadarid!") end
								DetachEntity(prop, false, false)
								DeleteEntity(prop)
								ClearPedTasks(PlayerPedId())
								prop = nil
								DragBrancard = false
								DisableActions()
							elseif data2.current.value == 'brancard' then
								if prop ~= nil then return ESX.ShowNotification("~r~Shoma Yek Berancard Darid!") end
								ClearPedTasks(PlayerPedId())
								local x,y,z = table.unpack(GetEntityCoords(PlayerPedId()))
								prop = CreateObjectNoOffset(GetHashKey('prop_ld_binbag_01'), x, y, z+0.2, true, true, false)
								AttachEntityToEntity(prop, PlayerPedId(), GetPedBoneIndex(PlayerPedId(), 24817), -0.5, 1.5, 0.0, -170.0, -90.0, 0.0, true, true, true, true, 1, true)
								loadAnimDict_ambulance("anim@heists@box_carry@")
								TaskPlayAnim(GetPlayerPed(-1), "anim@heists@box_carry@", "idle", 2.0, 2.0, -1, 51, 0, false, false, false)
								DragBrancard = true
								DisableActions()
							elseif data2.current.value == 'put_in_brancard' then
								local x,y,z = table.unpack(GetEntityCoords(PlayerPedId()))
								local xo,yo,zo = table.unpack(GetEntityCoords(prop))
								local distance = #(vector3(x,y,z) - vector3(xo,yo,zo))
								if prop == nil then return ESX.ShowNotification("~r~Shoma Berancard Nadarid!") end
								if distance >= 2.0 then return ESX.ShowNotification("~r~Shoma Nazdit Berancard Nistid!") end
								if closestPlayer == -1 or closestDistance > 1.5 then return ESX.ShowNotification("Hich Kas Nazdit Shoma Nist!") end
								TriggerServerEvent('esx_ambulancejob:brancard', GetPlayerServerId(closestPlayer))
							elseif data2.current.value == 'take_out_brancard' then
								local x,y,z = table.unpack(GetEntityCoords(PlayerPedId()))
								local xo,yo,zo = table.unpack(GetEntityCoords(prop))
								local distance = #(vector3(x,y,z) - vector3(xo,yo,zo))
								if prop == nil then return ESX.ShowNotification("~r~Shoma Berancard Nadarid!") end
								if distance >= 2.0 then return ESX.ShowNotification("~r~Shoma Nazdit Berancard Nistid!") end
								if closestPlayer == -1 or closestDistance > 1.5 then return ESX.ShowNotification("Hich Kas Nazdit Shoma Nist!") end
								TriggerServerEvent('esx_ambulancejob:OutBrancard', GetPlayerServerId(closestPlayer))
							end
						end, function(data2, menu2)
							menu2.close()
						end)
				elseif data.current.value == 'drag' then
					if closestPlayer == -1 or closestDistance > 1.0 then
						ESX.ShowNotification(_U('no_players'))
					else
						ExecuteCommand('carry')

					end
				elseif data.current.value == 'put_in_vehicle' then
					if closestPlayer == -1 or closestDistance > 1.0 then
						ESX.ShowNotification(_U('no_players'))
					else
						local targetSrc = GetPlayerServerId(closestPlayer)
						TriggerServerEvent('carry:respone',false)
						TriggerServerEvent('citizen:stopcarry', targetSrc)
						TriggerEvent('carry:cascel', false)

						ClearPedSecondaryTask(PlayerPedId())

						DetachEntity(PlayerPedId(), true, false)

						TriggerServerEvent('esx_ambulancejob:putInVehicle', GetPlayerServerId(closestPlayer))



					end
				elseif data.current.value == 'put_out_vehicle' then
					if closestPlayer == -1 or closestDistance > 3.0 then
						ESX.ShowNotification(_U('no_players'))
					else
						TriggerServerEvent('esx_ambulancejob:OutVehicle', GetPlayerServerId(closestPlayer))
					end
				elseif data.current.value == 'extera_division' then

					OpendivisionsMenu_ambulance()

				end
			end, function(data, menu)
				menu.close()
			end)
		end)
	end)
end

DisableActions = function()
	Citizen.CreateThread(function()
		while DragBrancard do
			Wait(1)
			DisableControlAction(0, Keys['F1'],true)
			DisableControlAction(0, Keys['U'],true)
			DisableControlAction(0, Keys['Y'],true)
			DisableControlAction(0, Keys['N7'],true)
			DisableControlAction(0, Keys['N8'],true)
			DisableControlAction(0, Keys['N9'],true)
			DisableControlAction(0, Keys['N4'],true)
			DisableControlAction(0, Keys['N5'],true)
			DisableControlAction(0, Keys['N6'],true)
			DisableControlAction(0, Keys['F3'],true)
			DisableControlAction(0, Keys['Q'],true)

			DisableControlAction(0, Keys['R'], true)
			DisableControlAction(0, Keys['SPACE'], true)
			DisableControlAction(0, Keys['LEFTSHIFT'], true)
			DisableControlAction(0, Keys['LEFTCTRL'], true)
			DisableControlAction(0, Keys['TAB'], true)
			DisableControlAction(0, Keys['K'], true)
			DisableControlAction(0, Keys['X'], true)
			DisableControlAction(0, Keys['M'], true)
			DisableControlAction(0, Keys['E'], true)
			DisableControlAction(0, 24, true)
			DisableControlAction(0, 210, true)
			DisableControlAction(0, 257, true)
			DisableControlAction(0, 25, true)
			DisableControlAction(0, 264, true)
			DisableControlAction(0, 140, true)
			DisableControlAction(0, 141, true)
			DisableControlAction(0, 142, true)
			DisableControlAction(0, 143, true)
			DisableControlAction(0, 263, true)
			DisableControlAction(0, 44, true)
			loadAnimDict_ambulance("anim@heists@box_carry@")
			if not IsEntityPlayingAnim(GetPlayerPed(-1), "anim@heists@box_carry@", "idle", 51) and DragBrancard then
				TaskPlayAnim(GetPlayerPed(-1), "anim@heists@box_carry@", "idle", 2.0, 2.0, -1, 51, 0, false, false, false)
			end
			if GetCurrentPedWeapon(PlayerPedId()) ~= GetHashKey("WEAPON_UNARMED") then
				SetCurrentPedWeapon(PlayerPedId(), GetHashKey("WEAPON_UNARMED"), true)
			end
		end
	end)
end

AddEventHandler('onResourceStop', function(resourceName)
	if (GetCurrentResourceName() == resourceName) then
		DetachEntity(prop, false, false)
		DeleteEntity(prop)
		ClearPedTasks(PlayerPedId())
		prop = nil
		ESX.UI.Menu.CloseAll()
	end
end)

function loadAnimDict_ambulance(dict)
    while (not HasAnimDictLoaded(dict)) do
        RequestAnimDict(dict)
        Wait(1)
    end
end

function FastTravel_ambulance(coords, heading)

	local playerPed = PlayerPedId()

	DoScreenFadeOut(800)

	while not IsScreenFadedOut() do

		Citizen.Wait(500)

	end

	ESX.Game.Teleport(playerPed, coords, function()

		DoScreenFadeIn(800)

		if heading then

			SetEntityHeading(playerPed, heading)

		end

	end)

end

Citizen.CreateThread(function()

	while true do

		Citizen.Wait(1)

		if PlayerData.job ~= nil and PlayerData.job.name == 'ambulance' then

		local playerCoords = GetEntityCoords(PlayerPedId())

		local letSleep, isInMarker, hasExited = true, false, false

		local currentHospital, currentPart, currentPartNum

		for hospitalNum,hospital in pairs(Config_ambulance.Hospitals) do



			for k,v in ipairs(hospital.AmbulanceLebas) do

				local distance = GetDistanceBetweenCoords(playerCoords, v, true)

				if distance < Config_ambulance.DrawDistance then

					DrawMarker(Config_ambulance.MarkerClock, v, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, Config_ambulance.Marker.x, Config_ambulance.Marker.y, Config_ambulance.Marker.z, Config_ambulance.Marker.r, Config_ambulance.Marker.g, Config_ambulance.Marker.b, Config_ambulance.Marker.a, false, false, 2, Config_ambulance.Marker.rotate, nil, nil, false)

					letSleep = false

				end

				if distance < Config_ambulance.Marker.x then

					isInMarker, currentHospital, currentPart, currentPartNum = true, hospitalNum, 'AmbulanceLebas', k

				end

			end

			for k,v in ipairs(hospital.AmbulanceBossAction) do

				local distance = GetDistanceBetweenCoords(playerCoords, v, true)

				if distance < Config_ambulance.DrawDistance then

					DrawMarker(Config_ambulance.MarkerBoss, v, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, Config_ambulance.Marker.x, Config_ambulance.Marker.y, Config_ambulance.Marker.z, Config_ambulance.Marker.r, Config_ambulance.Marker.g, Config_ambulance.Marker.b, Config_ambulance.Marker.a, false, false, 2, Config_ambulance.Marker.rotate, nil, nil, false)

					letSleep = false

				end

				if distance < Config_ambulance.Marker.x then

					isInMarker, currentHospital, currentPart, currentPartNum = true, hospitalNum, 'AmbulanceBossAction', k

				end

			end

			for k,v in ipairs(hospital.Armory) do

				local distance = GetDistanceBetweenCoords(playerCoords, v, true)

				if distance < Config_ambulance.DrawDistance then

					DrawMarker(Config_ambulance.Marker.type, v, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, Config_ambulance.Marker.x, Config_ambulance.Marker.y, Config_ambulance.Marker.z, Config_ambulance.Marker.r, Config_ambulance.Marker.g, Config_ambulance.Marker.b, Config_ambulance.Marker.a, false, false, 2, Config_ambulance.Marker.rotate, nil, nil, false)

					letSleep = false

				end

				if distance < Config_ambulance.Marker.x then

					isInMarker, currentHospital, currentPart, currentPartNum = true, hospitalNum, 'Armory', k

				end

			end



			for k,v in ipairs(hospital.Pharmacies) do

				local distance = GetDistanceBetweenCoords(playerCoords, v, true)

				if distance < Config_ambulance.DrawDistance then

					DrawMarker(Config_ambulance.Marker.type, v, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, Config_ambulance.Marker.x, Config_ambulance.Marker.y, Config_ambulance.Marker.z, Config_ambulance.Marker.r, Config_ambulance.Marker.g, Config_ambulance.Marker.b, Config_ambulance.Marker.a, false, false, 2, Config_ambulance.Marker.rotate, nil, nil, false)

					letSleep = false

				end

				if distance < Config_ambulance.Marker.x then

					isInMarker, currentHospital, currentPart, currentPartNum = true, hospitalNum, 'Pharmacy', k

				end

			end



			for k,v in ipairs(hospital.Vehicles) do

				local distance = GetDistanceBetweenCoords(playerCoords, v.Spawner, true)

				if distance < Config_ambulance.DrawDistance then

					DrawMarker(v.Marker.type, v.Spawner, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, v.Marker.x, v.Marker.y, v.Marker.z, v.Marker.r, v.Marker.g, v.Marker.b, v.Marker.a, false, false, 2, v.Marker.rotate, nil, nil, false)

					letSleep = false

				end

				if distance < v.Marker.x then

					isInMarker, currentHospital, currentPart, currentPartNum = true, hospitalNum, 'Vehicles', k

				end

			end



			for k,v in ipairs(hospital.VehiclesDeleter) do

				local distance = GetDistanceBetweenCoords(playerCoords, v.Deleter, true)

				if distance < Config_ambulance.DrawDistance then

					DrawMarker(v.Marker.type, v.Deleter, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, v.Marker.x, v.Marker.y, v.Marker.z, v.Marker.r, v.Marker.g, v.Marker.b, v.Marker.a, false, false, 2, v.Marker.rotate, nil, nil, false)

					letSleep = false

				end

				if distance < v.Marker.x then

					isInMarker, currentHospital, currentPart, currentPartNum = true, hospitalNum, 'VehiclesDeleter', k

				end

			end



			for k,v in ipairs(hospital.Helicopters) do

				local distance = GetDistanceBetweenCoords(playerCoords, v.Spawner, true)

				if distance < Config_ambulance.DrawDistance then

					DrawMarker(v.Marker.type, v.Spawner, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, v.Marker.x, v.Marker.y, v.Marker.z, v.Marker.r, v.Marker.g, v.Marker.b, v.Marker.a, false, false, 2, v.Marker.rotate, nil, nil, false)

					letSleep = false

				end

				if distance < v.Marker.x then

					isInMarker, currentHospital, currentPart, currentPartNum = true, hospitalNum, 'Helicopters', k

				end

			end




			for k,v in ipairs(hospital.FastTravels) do

				local distance = GetDistanceBetweenCoords(playerCoords, v.From, true)

				if distance < Config_ambulance.DrawDistance then

					DrawMarker(v.Marker.type, v.From, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, v.Marker.x, v.Marker.y, v.Marker.z, v.Marker.r, v.Marker.g, v.Marker.b, v.Marker.a, false, false, 2, v.Marker.rotate, nil, nil, false)

					letSleep = false

				end

				if distance < v.Marker.x then

					FastTravel_ambulance(v.To.coords, v.To.heading)

				end

			end



			for k,v in ipairs(hospital.FastTravelsPrompt) do

				local distance = GetDistanceBetweenCoords(playerCoords, v.From, true)

				if distance < Config_ambulance.DrawDistance then

					DrawMarker(v.Marker.type, v.From, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, v.Marker.x, v.Marker.y, v.Marker.z, v.Marker.r, v.Marker.g, v.Marker.b, v.Marker.a, false, false, 2, v.Marker.rotate, nil, nil, false)

					letSleep = false

				end

				if distance < v.Marker.x then

					isInMarker, currentHospital, currentPart, currentPartNum = true, hospitalNum, 'FastTravelsPrompt', k

				end

			end

		end



		if isInMarker and not HasAlreadyEnteredMarker or (isInMarker and (LastHospital ~= currentHospital or LastPart ~= currentPart or LastPartNum ~= currentPartNum)) then

			if

				(LastHospital ~= nil and LastPart ~= nil and LastPartNum ~= nil) and

				(LastHospital ~= currentHospital or LastPart ~= currentPart or LastPartNum ~= currentPartNum)

			then

				TriggerEvent('esx_ambulancejob:hasExitedMarker', LastHospital, LastPart, LastPartNum)

				hasExited = true

			end

			HasAlreadyEnteredMarker, LastHospital, LastPart, LastPartNum = true, currentHospital, currentPart, currentPartNum

			TriggerEvent('esx_ambulancejob:hasEnteredMarker', currentHospital, currentPart, currentPartNum)

		end

		if not hasExited and not isInMarker and HasAlreadyEnteredMarker then

			HasAlreadyEnteredMarker = false

			TriggerEvent('esx_ambulancejob:hasExitedMarker', LastHospital, LastPart, LastPartNum)

		end

		if letSleep then

			Citizen.Wait(500)

		end

	end
	end

end)

RegisterNetEvent('esx_ambulancejob:finishCPRx')
AddEventHandler('esx_ambulancejob:finishCPRx', function(ped)
	local NersPed 	= NetToPed(ped)
	local PlayerPed = GetPlayerPed(-1)
	local coords    = GetEntityCoords(PlayerPed)
	local head 		= GetEntityHeading(PlayerPed)

	local camanimDict = "mini@cpr@char_b@cpr_def"
	local camanimDict1 = "mini@cpr@char_b@cpr_str"
	local loadedanim = false

	beingrevived = true
	ESX.Streaming.RequestAnimDict(camanimDict1)
	ESX.Streaming.RequestAnimDict(camanimDict, function()
		loadedanim = true
	end)

	while not loadedanim do
		Citizen.Wait(1)
	end

	ClearPedTasksImmediately(PlayerPed)
	AttachEntityToEntity(PlayerPed, NersPed, 28422, -0.1, 1.15, 0.0, 0.0, 0.0, 75.0, false, false, false, true, 2, true)

	TaskPlayAnim(PlayerPed, camanimDict, "cpr_intro", 8.0, 8.0, -1, 0, 0, false, false, false)
	Citizen.Wait(800)
	DetachEntity(PlayerPed, true, false)
	Citizen.Wait(15000)
	TaskPlayAnim(PlayerPed, camanimDict1, "cpr_pumpchest", 8.0, 8.0, -1, 1, 0, false, false, false)
	Citizen.Wait(5000)
	TaskPlayAnim(PlayerPed, camanimDict1, "cpr_success", 8.0, 8.0, -1, 0, 0, false, false, false)
	Citizen.Wait(28600)
	ClearPedTasksImmediately(NersPed)
	ClearPedTasksImmediately(PlayerPed)
end)

AddEventHandler('esx_ambulancejob:hasEnteredMarker', function(hospital, part, partNum)

	if ESX.PlayerData.job and ESX.PlayerData.job.name == 'ambulance' then

		if part == 'AmbulanceLebas' then

			CurrentAction = part

			CurrentActionMsg = _U('actions_prompt')

			CurrentActionData = {}

		elseif part == 'AmbulanceBossAction' then

			CurrentAction = part

			CurrentActionMsg = _U('open_boss')

			CurrentActionData = {}
		elseif part == 'Pharmacy' then

			CurrentAction = part

			CurrentActionMsg = _U('open_pharmacy')

			CurrentActionData = {}

		elseif part == 'Armory' then

			CurrentAction = 'menu_armory'

			CurrentActionMsg = _U('open_armory')

			CurrentActionData = {hospital = hospital}

		elseif part == 'Vehicles' then

			CurrentAction = part

			CurrentActionMsg = _U('garage_prompt')

			CurrentActionData = {hospital = hospital, partNum = partNum}

		elseif part == 'VehiclesDeleter' then

			if IsPedInAnyVehicle(GetPlayerPed(-1),  false) then

				local vehicle = GetVehiclePedIsIn(GetPlayerPed(-1), false)

				if DoesEntityExist(vehicle) then
				  CurrentAction     = 'VehiclesDeleter'
				  CurrentActionMsg  = '~INPUT_CONTEXT~ Baraye Park Kardan'
				  CurrentActionData = {vehicle = vehicle}
				end

			end

		elseif part == 'Helicopters' then

			CurrentAction = part

			CurrentActionMsg = _U('helicopter_prompt')

			CurrentActionData = {hospital = hospital, partNum = partNum}

		elseif part == 'FastTravelsPrompt' then

			local travelItem = Config_ambulance.Hospitals[hospital][part][partNum]

			CurrentAction = part

			CurrentActionMsg = travelItem.Prompt

			CurrentActionData = {to = travelItem.To.coords, heading = travelItem.To.heading}

		end

	end

end)

AddEventHandler('esx_ambulancejob:hasExitedMarker', function(hospital, part, partNum)

	if not isInShopMenu then

		ESX.UI.Menu.CloseAll()

	end

	CurrentAction = nil

end)

Citizen.CreateThread(function()

	while true do

		Citizen.Wait(1)

		if CurrentAction then

			ESX.ShowHelpNotification(CurrentActionMsg)

			if IsControlJustReleased(0, Keys['E']) then

				if CurrentAction == 'AmbulanceLebas' then

					OpenCloakroomMenu_ambulance()

				elseif CurrentAction == 'AmbulanceBossAction' then

					TriggerEvent('esx_society:openBosscarysMenu', 'ambulance', function()

					end, {wash = false})

				elseif CurrentAction == 'Pharmacy' then

					OpenPharmacyMenu_ambulance()
				elseif CurrentAction == 'menu_armory' then

					OpenArmoryMenu_ambulance(CurrentActionData.hospital)

				elseif CurrentAction == 'Vehicles' then

					OpenVehicleSpawnerMenu_ambulance(CurrentActionData.hospital, CurrentActionData.partNum)


				elseif CurrentAction == 'VehiclesDeleter' then



					local vehicleModel = GetEntityModel(CurrentActionData.vehicle)
					local vehicleLabel = GetLabelText(GetDisplayNameFromVehicleModel(vehicleModel))
					local plate = GetVehicleNumberPlateText(CurrentActionData.vehicle)
					local playerIdentifier = ESX.GetPlayerData().identifier
					local playerPed = PlayerPedId()
                    local xPlayer = ESX.GetPlayerData()
					ESX.Game.DeleteVehicle(CurrentActionData.vehicle)

				TriggerServerEvent('logmdVehicleSpawn', xPlayer.name, GetPlayerServerId(PlayerId()), playerIdentifier, vehicleLabel, plate, false)


				elseif CurrentAction == 'Helicopters' then

					OpenheliSpawnerMenu_ambulance(CurrentActionData.hospital, CurrentActionData.partNum)

				elseif CurrentAction == 'FastTravelsPrompt' then

					FastTravel_ambulance(CurrentActionData.to, CurrentActionData.heading)

				end

				CurrentAction = nil

			end

		elseif ESX.PlayerData.job ~= nil and ESX.PlayerData.job.name == 'ambulance' and not IsDead and not isDead then

			if IsControlJustReleased(0, Keys['F6']) then
				OpenMobileAmbulanceActionsMenu_ambulance()
			end

		else

			Citizen.Wait(500)

		end

	end

end)

RegisterNetEvent('esx_ambulancejob:putInVehicle')
AddEventHandler('esx_ambulancejob:putInVehicle', function()
	local playerPed = PlayerPedId()
	local coords    = GetEntityCoords(playerPed)

	if IsAnyVehicleNearPoint(coords, 5.0) then
		local vehicle = GetClosestVehicle(coords, 5.0, 0, 71)
		if DoesEntityExist(vehicle) then
			local maxSeats, freeSeat = GetVehicleMaxNumberOfPassengers(vehicle)
			for i=maxSeats - 1, 0, -1 do
				if IsVehicleSeatFree(vehicle, i) then
					freeSeat = i
					break
				end
			end
			if freeSeat then
				TaskWarpPedIntoVehicle(playerPed, vehicle, freeSeat)

				TriggerEvent("Unique_Scripts_HuD:changeStatus", true)


			end
		end
	end

end)

RegisterNetEvent('esx_ambulancejob:OutVehicle')
AddEventHandler('esx_ambulancejob:OutVehicle', function()
	local playerPed = PlayerPedId()
	if not IsPedSittingInAnyVehicle(playerPed) then
		return
	end
	if ESX.GetPlayerData().IsDead then
		local vehicle = GetVehiclePedIsIn(playerPed, false)
		TaskLeaveVehicle(playerPed, vehicle, 16)
	end
end)

local isDead = false
AddEventHandler('esx:onPlayerDeath', function(data)
	isDead = true
end)

AddEventHandler('playerSpawned', function()
	isDead = false
	DragStatus.IsDragged = false
	Brancard.IsInBed = false
end)

RegisterNetEvent('esx_ambulancejob:drag')
AddEventHandler('esx_ambulancejob:drag', function(id)
    if not isDead then return end
    DragStatus.IsDragged = not DragStatus.IsDragged
    DragStatus.MD     = tonumber(id)
end)

Citizen.CreateThread(function()
	local playerPed
	local targetPed
	while true do
		Citizen.Wait(1)
		if isDead then
			playerPed = PlayerPedId()
			TriggerEvent("citizen:getCarry", function(carry)
				if DragStatus.IsDragged then
					targetPed = GetPlayerPed(GetPlayerFromServerId(DragStatus.MD))
					if not IsPedSittingInAnyVehicle(targetPed) then
						AttachEntityToEntity(playerPed, targetPed, 11816, 0.54, 0.54, 0.0, 0.0, 0.0, 0.0, false, false, false, false, 2, true)
					else
						DragStatus.IsDragged = false
						DetachEntity(playerPed, true, false)
					end
				elseif not carry then
					DetachEntity(playerPed, true, false)
				end
			end)
		else
			Citizen.Wait(500)
		end
	end
end)

RegisterNetEvent('esx_ambulancejob:brancard')
AddEventHandler('esx_ambulancejob:brancard', function(playerID)
	if not isDead then return end
	local prop, distance = ESX.Game.GetClosestObject('prop_ld_binbag_01', GetEntityCoords(PlayerPedId()))
	if distance <= 1.5 and distance ~= -1 then
		Brancard.IsInBed = not Brancard.IsInBed
		Brancard.Target  = tonumber(playerID)
		Brancard.Prop    = prop
	else
		TriggerServerEvent("esx_ambulancejob:PlShowazaNotification", tonumber(playerID), "~r~Nazdik Shoma Brancard Nist!")
	end
end)

Citizen.CreateThread(function()
	local playerPed
	while true do
		Citizen.Wait(4)
		playerPed = PlayerPedId()
		if isDead then
			if Brancard.IsInBed then
				if not IsPedSittingInAnyVehicle(playerPed) then
					AttachEntityToEntity(playerPed, Brancard.Prop, 24817, 0.0, 0.2, 1.0, -180.0, -180.0, 0.0, true, true, true, true, GetEntityRotation(Brancard.Prop, 2), false)
					loadAnimDict_ambulance("anim@gangops@morgue@table@")
					TaskPlayAnim(playerPed, "anim@gangops@morgue@table@", "body_search", 8.0, 1.0, -1, 1, 0, false, false, false)
				else
					Brancard.IsInBed = false
					DetachEntity(playerPed, true, false)
					ClearPedTasks(playerPed)
				end
			end
		else
			Citizen.Wait(500)
		end
	end
end)

RegisterNetEvent('esx_ambulancejob:OutBrancard')
AddEventHandler('esx_ambulancejob:OutBrancard', function()
	local playerPed = PlayerPedId()
	Brancard.IsInBed = false
	DetachEntity(playerPed, true, false)
	ClearPedTasks(playerPed)
end)

AddEventHandler("esx_ambulancejob:SendCLData", function(cb)
	cb({InBed = Brancard.IsInBed, IsDragged = DragStatus.IsDragged})
end)

function OpenCloakroomMenu_ambulance()
	ESX.TriggerServerCallback('esx_society:divisionsPlayer', function(check)
		elements = {}

		elements = {

			{label = _U('ems_clothes_ems'), value = 'ambulance_wear'},

			{label = _U('ems_clothes_civil'), value = 'citizen_wear'},



		}

		for k, v in pairs(check) do

            if v.status == true then
                table.insert(elements, {
                    label = 'Lebas Division',
					diviname = v.name,
					value = 'division_lebas',

                })
            end

        end

		ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'cloakroom', {

			title    = _U('cloakroom'),

			align    = 'bottom-right',

			elements = elements

		}, function(data, menu)

			if data.current.value == 'citizen_wear' then
					local grade = PlayerData.job.grade_name
					local name = PlayerData.job.name

				ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin)

					TriggerEvent('skinchanger:loadSkin', skin)
				end)

			elseif data.current.value == 'ambulance_wear' then
				local job =  PlayerData.job.name
				local gradenum =  PlayerData.job.grade
				ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin)
					ESX.TriggerServerCallback('esx_society:getUniforms', function(SkinMale, SkinFemale)

					if skin.sex == 0 then
						TriggerEvent('skinchanger:loadClothes', skin, SkinMale)
					else
						TriggerEvent('skinchanger:loadClothes', skin, SkinFemale)
					end
					OpenCloakroomMenu_ambulance()
				end, gradenum, job)
				end)

			elseif data.current.value == 'division_lebas' then

				ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin)
					local job =  PlayerData.job.name
					ESX.TriggerServerCallback('esx_society:getUniformsDivision', function(SkinMale, SkinFemale)
						if skin.sex == 0 then
							TriggerEvent('skinchanger:loadClothes', skin, SkinMale)
						else
							TriggerEvent('skinchanger:loadClothes', skin, SkinFemale)
						end
					end, data.current.diviname, job)
					OpenCloakroomMenu_ambulance()
				end)


			end

			menu.close()

		end, function(data, menu)

			menu.close()

		end)
	end)
end



















function OpenVehicleSpawnerMenu_ambulance(station, partNum)
	local vehicles = Config_ambulance.Hospitals[station].Vehicles
	ESX.UI.Menu.CloseAll()

	local elements = {}
	local elements2 = {}

	local grade = ESX.GetPlayerData().job.grade
	local job = ESX.GetPlayerData().job.name
	local steamhex = ESX.GetPlayerData().identifier
	ESX.TriggerServerCallback('esx_society:getVehicles', function(authorizedVehicle)

		ESX.TriggerServerCallback('esx_society:GetDivisionsPlayer', function(getdivision)
			dvisionName = nil

			for k,v in pairs(getdivision) do
				if v.status and v.job == job then


					dvisionName = v.name
				end
			end
			ESX.TriggerServerCallback('esx_society:getVehiclesdivision', function(authorizedVehicledivision)


				local found = false

				if authorizedVehicle ~= nil then
					local Vehicles = Config_ambulance.AuthorizedVehicles.Shared
					for i = 1, #Vehicles, 1 do
					local found = false


					if authorizedVehicle ~= nil then
						for _,sharedVeh in ipairs(authorizedVehicle) do
							if found then break end
								if sharedVeh.model == Vehicles[i].model and sharedVeh.status == true then
									table.insert(elements, {label = Vehicles[i].label, model = Vehicles[i].model})
									found = true


								end
							end

						end
					end

				end

				if authorizedVehicledivision then
					table.insert(elements, {label = '------ Division ------', model = nil})
					local nnname = nil
					local Vehicles2 = Config_ambulance.AuthorizedVehicles.Shared
					for i = 1, #Vehicles2, 1 do
						nnname = nil
						for t,vehs in pairs(authorizedVehicledivision) do
							for k,v in pairs(elements) do
								if vehs.status and Vehicles2[i].model == vehs.model then
									if v.model == vehs.model then
										nnname = nil
										break
									else
										nnname = vehs.model
									end
								end
							end
							if nnname then

								table.insert(elements, {label = Vehicles2[i].label, model = Vehicles2[i].model})
								break
							end
						end
					end
				end
				while elements == nil do Wait(1) end
				ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'vehicle_spawner',
				{
					title    = _U('vehicle_menu'),
					align    = 'left',
					elements = elements
				}, function(data, menu)
					menu.close()

					local model   = data.current.model

					if model then
						if not DoesEntityExist(vehicle) then

							local playerPed = PlayerPedId()

							local function requestPlate()
								local plate = lib.inputDialog('Enter Vehicle Plate', {'Plate (6 characters)'}, {max = 6})
								if plate and plate[1] then
									plate[1] = string.upper(plate[1])

									ESX.TriggerServerCallback('checkPlateInServer', function(plateExists)
										if plateExists then

											local alert = lib.alertDialog({
												header = 'Az In Plake Qablan Estefadeh Shode',
												content = 'Aya Mikhahid Hazf Shavad?',
												centered = true,
												cancel = true
											})
											if alert == 'confirm' then
												ESX.TriggerServerCallback('deletevehiclejob', function(plate)
													TriggerEvent('chat:addMessage', {
														args = {'^1SYSTEM', 'Mashin be moafaghiat hazf shod'}
													})
												end, "MD" .. plate[1])
												menu.close()

												Wait(1000)
												spawnvehicles_ambulance(data, plate, vehicle, station, partNum)

											else
												TriggerEvent('chat:addMessage', {
													args = {'^1SYSTEM', 'Cancel Shod'}
												})

											end
										else
											if #plate[1] == 6 then
												menu.close()

												spawnvehicles_ambulance(data, plate, vehicle, station, partNum)
											else
												TriggerEvent('chat:addMessage', {
													args = {'^1SYSTEM', 'Plake Mashin Bayad 6 Character Bashad'}
												})
												requestPlate()
											end
										end
									end, "MD" .. plate[1])
								end
							end
							requestPlate()
						else
							ESX.ShowNotification(_U('vehicle_out'))
						end
					end

				end, function(data, menu)
					menu.close()

					CurrentAction     = 'menu_vehicle_spawner'
					CurrentActionMsg  = _U('vehicle_spawner')
					CurrentActionData = {station = station, partNum = partNum}

				end)
			end, dvisionName, job)
		end, steamhex)
	end, grade, job)
end

function spawnvehicles_ambulance(data, plate, vehicle, station, partNum)
    plate[1] = string.upper(plate[1])
    local vehicles = Config_ambulance.Hospitals[station].Vehicles
    local vehicle = GetClosestVehicle(vehicles[partNum].SpawnPoints.x, vehicles[partNum].SpawnPoints.y, vehicles[partNum].SpawnPoints.z, 3.0, 0, 71)

    ESX.Game.SpawnVehicleJobs(data.current.model, vehicles[partNum].SpawnPoints, vehicles[partNum].Heading, function(vehicle)
        if vehicle then
            local playerPed = PlayerPedId()
            local xPlayer = ESX.GetPlayerData()
            local playerIdentifier = xPlayer.identifier

            if data.current.model == "insurgent2" or data.current.model == "riot2" or data.current.model == "riot" or data.current.model == "fbi2" or data.current.model == "fbi" then
                SetVehicleMaxMods2_ambulance(vehicle)
            elseif data.current.model == "polschafter3" then
                SetVehicleMaxMods_ambulance(vehicle, 1)
            elseif data.current.model == "polchar" or data.current.model == "poltah" or data.current.model == "poltaurus" or data.current.model == "polvic" then
                SetVehicleMaxMods_ambulance(vehicle, 1)
                SetVehicleLivery(vehicle, 2)
            elseif data.current.model == "polraptor" then
                SetVehicleMaxMods_ambulance(vehicle, 1)
                SetVehicleLivery(vehicle, 2)
            else
                SetVehicleMaxMods_ambulance(vehicle, callsign, -1)
            end

            local Vehicles2 = Config_ambulance.AuthorizedVehicles.Shared
            for _, vehicle2 in ipairs(Vehicles2) do
                if vehicle2.Extra and vehicle2.model == data.current.model then
                    for extraName, extraValue in pairs(vehicle2.Extra) do
                        SetVehicleExtra(vehicle, tonumber(extraName), tonumber(extraValue))
                    end
                end
            end


            SetVehicleLivery(vehicle, 2)
            Citizen.Wait(500)
            SetVehicleLivery(vehicle, 2)

            if CustomVehicleLiveries[data.current.model] then
            	SetVehicleLivery(vehicle, CustomVehicleLiveries[data.current.model])
            end
            TaskWarpPedIntoVehicle(playerPed, vehicle, -1)
            Citizen.Wait(500)
            SetVehicleFuelLevel(vehicle, 100.0)
            SetVehicleMaxMods_ambulance(vehicle)
            SetVehicleNumberPlateText(vehicle, "MD" .. plate[1])

            local playerIdentifier = ESX.GetPlayerData().identifier
			local vehicleModel = GetEntityModel(CurrentActionData.vehicle)
			local vehicleLabel = GetLabelText(GetDisplayNameFromVehicleModel(vehicleModel))

            TriggerServerEvent('logmdVehicleSpawn', xPlayer.name, GetPlayerServerId(PlayerId()), playerIdentifier, vehicleLabel, "MD" .. plate[1], true)

            TriggerEvent('chat:addMessage', {
                args = {'^1SYSTEM', 'Mashin Ba Plake^2 MD'..plate[1]..' ^0Spawn Shod'}
            })
        else

            TriggerEvent('chat:addMessage', {
                args = {'^1SYSTEM', 'Spawn Mashin Na Movafaq'}
            })
        end
    end)
end

function StoreNearbyVehicle_ambulance(playerCoords)

	local vehicles, vehiclePlates = ESX.Game.GetVehiclesInArea(playerCoords, 30.0), {}

	if #vehicles > 0 then

		for k,v in ipairs(vehicles) do



			if GetVehicleNumberOfPassengers(v) == 0 and IsVehicleSeatFree(v, -1) then

				table.insert(vehiclePlates, {

					vehicle = v,

					plate = ESX.Math.Trim(GetVehicleNumberPlateText(v))

				})

			end

		end

	else

		ESX.ShowNotification(_U('garage_store_nearby'))

		return

	end

	ESX.TriggerServerCallback('esx_ambulancejob:storeNearbyVehicle', function(storeSuccess, foundNum)

		if storeSuccess then

			local vehicleId = vehiclePlates[foundNum]

			local attempts = 0

			ESX.Game.DeleteVehicle(vehicleId.vehicle)

			IsBusy = true

			Citizen.CreateThread(function()

				while IsBusy do

					Citizen.Wait(1)

					drawLoadingText_ambulance(_U('garage_storing'), 255, 255, 255, 255)

				end

			end)



			while DoesEntityExist(vehicleId.vehicle) do

				Citizen.Wait(500)

				attempts = attempts + 1



				if attempts > 30 then

					break

				end

				vehicles = ESX.Game.GetVehiclesInArea(playerCoords, 30.0)

				if #vehicles > 0 then

					for k,v in ipairs(vehicles) do

						if ESX.Math.Trim(GetVehicleNumberPlateText(v)) == vehicleId.plate then

							ESX.Game.DeleteVehicle(v)



							break

						end

					end

				end

			end

			IsBusy = false

			ESX.ShowNotification(_U('garage_has_stored'))

		else

			ESX.ShowNotification(_U('garage_has_notstored'))

		end

	end, vehiclePlates)

end

function GetAvailableVehicleSpawnPoint_ambulance(hospital, part, partNum)

	local spawnPoints = Config_ambulance.Hospitals[hospital][part][partNum].SpawnPoints

	local found, foundSpawnPoint = false, nil

	for i=1, #spawnPoints, 1 do

		if ESX.Game.IsSpawnPointClear(spawnPoints[i].coords, spawnPoints[i].radius) then

			found, foundSpawnPoint = true, spawnPoints[i]

			break

		end

	end

	if found then

		return true, foundSpawnPoint

	else

		ESX.ShowNotification(_U('garage_blocked'))

		return false

	end

end

function OpenheliSpawnerMenu_ambulance(station, partNum)
	local vehicles = Config_ambulance.Hospitals[station].Helicopters
	ESX.UI.Menu.CloseAll()

	local elements = {}
	local elements2 = {}

	local grade = PlayerData.job.grade
	local job = PlayerData.job.name
	ESX.TriggerServerCallback('esx_society:getHelis', function(authorizedVehicle)
		ESX.TriggerServerCallback('esx_society:GetDivisionsPlayer', function(getdivision)
			dvisionName = nil
			for k,v in pairs(getdivision) do
				if v.status and v.job == job then


					dvisionName = v.name
				end
			end
			ESX.TriggerServerCallback('esx_society:getHelisdivision', function(authorizedVehicledivision)


				local found = false

				if authorizedVehicle ~= nil then
					local Vehicles = Config_ambulance.AuthorizedVehicles.Sharedheli
					for i = 1, #Vehicles, 1 do
					local found = false


					if authorizedVehicle ~= nil then
						for _,sharedVeh in ipairs(authorizedVehicle) do
							if found then break end
								if sharedVeh.model == Vehicles[i].model and sharedVeh.status == true then
									table.insert(elements, {label = Vehicles[i].label, model = Vehicles[i].model})
									found = true


								end
							end

						end
					end

				end

				if authorizedVehicledivision then
					table.insert(elements, {label = '------ Division ------', model = nil})
					local nnname = nil
					local Vehicles2 = Config_ambulance.AuthorizedVehicles.Sharedheli
					for i = 1, #Vehicles2, 1 do
						nnname = nil
						for t,vehs in pairs(authorizedVehicledivision) do
							for k,v in pairs(elements) do
								if vehs.status and Vehicles2[i].model == vehs.model then
									if v.model == vehs.model then
										nnname = nil
										break
									else
										nnname = vehs.model
									end
								end
							end
							if nnname then

								table.insert(elements, {label = Vehicles2[i].label, model = Vehicles2[i].model})
								break
							end
						end
					end
				end
				while elements == nil do Wait(1) end
				ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'vehicle_spawner',
				{
					title    = 'heli menu',
					align    = 'left',
					elements = elements
				}, function(data, menu)
					menu.close()

					local model   = data.current.model

					if model then
						if not DoesEntityExist(vehicle) then

							local playerPed = PlayerPedId()

							local function requestPlate()
								local plate = lib.inputDialog('Enter Heli Plate', {'Plate (6 characters)'}, {max = 6})
								if plate and plate[1] then
									plate[1] = string.upper(plate[1])

									ESX.TriggerServerCallback('checkPlateInServer', function(plateExists)
										if plateExists then

											local alert = lib.alertDialog({
												header = 'Az In Plake Qablan Estefadeh Shode',
												content = 'Aya Mikhahid Hazf Shavad?',
												centered = true,
												cancel = true
											})
											if alert == 'confirm' then
												ESX.TriggerServerCallback('deletevehiclejob', function(plate)
													TriggerEvent('chat:addMessage', {
														args = {'^1SYSTEM', 'Heli be moafaghiat hazf shod'}
													})
												end, "MD" .. plate[1])
												menu.close()

												Wait(1000)
												spawnheliss_ambulance(data, plate, vehicle, station, partNum)

											else
												TriggerEvent('chat:addMessage', {
													args = {'^1SYSTEM', 'Cancel Shod'}
												})

											end
										else
											if #plate[1] == 6 then
												menu.close()

												spawnheliss_ambulance(data, plate, vehicle, station, partNum)
											else
												TriggerEvent('chat:addMessage', {
													args = {'^1SYSTEM', 'Plake Heli Bayad 6 Character Bashad'}
												})
												requestPlate()
											end
										end
									end, "MD" .. plate[1])
								end
							end

							requestPlate()
						else
							ESX.ShowNotification(_U('heli_out'))
						end
					end

				end, function(data, menu)
					menu.close()
					CurrentAction     = 'menu_heli_spawner'
					CurrentActionMsg  = _U('heli_spawner')
					CurrentActionData = {station = station, partNum = partNum}

				end)
			end, dvisionName, job)
		end, PlayerData.identifier)
	end, grade, job)
end

function spawnheliss_ambulance(data, plate, vehicle, station, partNum)
	plate[1] = string.upper(plate[1])
	local vehicles = Config_ambulance.Hospitals[station].Helicopters
	local vehicle = GetClosestVehicle(vehicles[partNum].SpawnPoints.x, vehicles[partNum].SpawnPoints.y, vehicles[partNum].SpawnPoints.z, 3.0, 0, 71)
	ESX.Game.SpawnVehicleJobs(data.current.model, vehicles[partNum].SpawnPoints, vehicles[partNum].Heading, function(vehicle)
		if vehicle then

			local playerPed = PlayerPedId()
			if data.current.model == "insurgent2" or data.current.model == "riot2" or data.current.model == "riot" or data.current.model == "fbi2" or data.current.model == "fbi" then
				SetVehicleMaxMods2_ambulance(vehicle)
			elseif data.current.model == "polschafter3" then
				SetVehicleMaxMods_ambulance(vehicle, 1)
			elseif data.current.model == "polchar" or data.current.model == "poltah" or data.current.model == "poltaurus" or data.current.model == "polvic" then
				SetVehicleMaxMods_ambulance(vehicle, 1)
				SetVehicleLivery(vehicle, 2)
			elseif data.current.model == "polraptor" then
				SetVehicleMaxMods_ambulance(vehicle, 1)
				SetVehicleLivery(vehicle, 2)
			else
				SetVehicleMaxMods_ambulance(vehicle, callsign, -1)
			end

			local Vehicles2 = Config_ambulance.AuthorizedVehicles.Shared
			for _, vehicle2 in ipairs(Vehicles2) do
				if vehicle2.Extra and vehicle2.model == data.current.model then
					for extraName, extraValue in pairs(vehicle2.Extra) do
						SetVehicleExtra(vehicle, tonumber(extraName), tonumber(extraValue))
					end
				end
			end



			SetVehicleLivery(vehicle, 2)
			Citizen.Wait(500)
			SetVehicleLivery(vehicle, 2)

			if CustomVehicleLiveries[data.current.model] then
				SetVehicleLivery(vehicle, CustomVehicleLiveries[data.current.model])
			end
			TaskWarpPedIntoVehicle(playerPed, vehicle, -1)
			Citizen.Wait(500)
			SetVehicleFuelLevel(vehicle, 100.0)
			SetVehicleMaxMods_ambulance(vehicle)
			SetVehicleNumberPlateText(vehicle, "MD" ..plate[1] )

            local playerIdentifier = ESX.GetPlayerData().identifier
			local vehicleModel = GetEntityModel(CurrentActionData.vehicle)
			local vehicleLabel = GetLabelText(GetDisplayNameFromVehicleModel(vehicleModel))
			local playerPed = PlayerPedId()
			local xPlayer = ESX.GetPlayerData()

            TriggerServerEvent('logmdVehicleSpawn', xPlayer.name, GetPlayerServerId(PlayerId()), playerIdentifier, vehicleLabel, "MD" .. plate[1], true)



			TriggerEvent('chat:addMessage', {
				args = {'^1SYSTEM', 'Heli Ba Plake^2 MD'..plate[1]..' ^0Spawn Shod'}
			})
		else
			TriggerEvent('chat:addMessage', {
				args = {'^1SYSTEM', 'Spawn Heli Na Movafaq'}
			})

		end
	end)

end

function OpenShopMenu_ambulance(elements, restoreCoords, shopCoords)

	local playerPed = PlayerPedId()

	isInShopMenu = true

	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'vehicle_shop', {

		title    = _U('vehicleshop_title'),

		align    = 'bottom-right',

		elements = elements

	}, function(data, menu)

		ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'vehicle_shop_confirm', {

			title    = _U('vehicleshop_confirm', data.current.name, data.current.price),

			align    = 'bottom-right',

			elements = {

				{ label = _U('confirm_no'), value = 'no' },

				{ label = _U('confirm_yes'), value = 'yes' }

			}

		}, function(data2, menu2)

			if data2.current.value == 'yes' then

				local newPlate = exports['esx_vehicleshop']:GeneratePlate()

				local vehicle  = GetVehiclePedIsIn(playerPed, false)

				local props    = ESX.Game.GetVehicleProperties(vehicle)

				props.plate    = newPlate

				ESX.TriggerServerCallback('esx_ambulancejob:buyJobVehicle', function (bought)

					if bought then

						ESX.ShowNotification(_U('vehicleshop_bought', data.current.name, ESX.Math.GroupDigits(data.current.price)))

						isInShopMenu = false

						ESX.UI.Menu.CloseAll()



						DeleteSpawnedVehicles_ambulance()

						FreezeEntityPosition(playerPed, false)

						SetEntityVisible(playerPed, true)



						ESX.Game.Teleport(playerPed, restoreCoords)

					else

						ESX.ShowNotification(_U('vehicleshop_money'))

						menu2.close()

					end

				end, props, data.current.type)

			else

				menu2.close()

			end

		end, function(data2, menu2)

			menu2.close()

		end)

		end, function(data, menu)

		isInShopMenu = false

		ESX.UI.Menu.CloseAll()

		DeleteSpawnedVehicles_ambulance()

		FreezeEntityPosition(playerPed, false)

		SetEntityVisible(playerPed, true)

		ESX.Game.Teleport(playerPed, restoreCoords)

	end, function(data, menu)

		DeleteSpawnedVehicles_ambulance()

		WaitForVehicleToLoad_ambulance(data.current.model)

		ESX.Game.SpawnLocalVehicle(data.current.model, shopCoords, 0.0, function(vehicle)

			table.insert(spawnedVehicles, vehicle)

			TaskWarpPedIntoVehicle(playerPed, vehicle, -1)

			FreezeEntityPosition(vehicle, true)

		end)

	end)

	WaitForVehicleToLoad_ambulance(elements[1].model)

	ESX.Game.SpawnLocalVehicle(elements[1].model, shopCoords, 0.0, function(vehicle)

		table.insert(spawnedVehicles, vehicle)

		TaskWarpPedIntoVehicle(playerPed, vehicle, -1)

		FreezeEntityPosition(vehicle, true)

	end)

end

Citizen.CreateThread(function()

	while true do

		Citizen.Wait(1)

		if isInShopMenu then

			DisableControlAction(0, 75, true)

			DisableControlAction(27, 75, true)

		else

			Citizen.Wait(500)

		end

	end

end)

function DeleteSpawnedVehicles_ambulance()

	while #spawnedVehicles > 0 do

		local vehicle = spawnedVehicles[1]

		ESX.Game.DeleteVehicle(vehicle)

		table.remove(spawnedVehicles, 1)

	end

end

function WaitForVehicleToLoad_ambulance(modelHash)

	modelHash = (type(modelHash) == 'number' and modelHash or GetHashKey(modelHash))

	if not HasModelLoaded(modelHash) then

		RequestModel(modelHash)

		while not HasModelLoaded(modelHash) do

			Citizen.Wait(1)

			DisableControlAction(0, Keys['TOP'], true)

			DisableControlAction(0, Keys['DOWN'], true)

			DisableControlAction(0, Keys['LEFT'], true)

			DisableControlAction(0, Keys['RIGHT'], true)

			DisableControlAction(0, 176, true)

			DisableControlAction(0, Keys['BACKSPACE'], true)

			drawLoadingText_ambulance(_U('vehicleshop_awaiting_model'), 255, 255, 255, 255)

		end

	end

end

function drawLoadingText_ambulance(text, red, green, blue, alpha)

	SetTextFont(4)

	SetTextScale(0.0, 0.5)

	SetTextColour(red, green, blue, alpha)

	SetTextDropshadow(0, 0, 0, 0, 255)

	SetTextEdge(1, 0, 0, 0, 255)

	SetTextDropShadow()

	SetTextOutline()

	SetTextCentre(true)

	BeginTextCommandDisplayText("STRING")

	AddTextComponentSubstringPlayerName(text)

	EndTextCommandDisplayText(0.5, 0.5)

end

function OpenPharmacyMenu_ambulance()

	ESX.UI.Menu.CloseAll()

	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'pharmacy', {

		title    = _U('pharmacy_menu_title'),

		align    = 'bottom-right',

		elements = {

			{label = _U('pharmacy_take', _U('medikit')), value = 'medikit'},

			{label = _U('pharmacy_take', _U('bandage')), value = 'bandage'}

		}

	}, function(data, menu)

		TriggerServerEvent('esx_ambulancejob:giveItem', data.current.value)

	end, function(data, menu)

		menu.close()

	end)

end

function WarpPedInClosestVehicle_ambulance(ped)

	local coords = GetEntityCoords(ped)

	local vehicle, distance = ESX.Game.GetClosestVehicle(coords)

	if distance ~= -1 and distance <= 5.0 then

		local maxSeats, freeSeat = GetVehicleMaxNumberOfPassengers(vehicle)

		for i=maxSeats - 1, 0, -1 do

			if IsVehicleSeatFree(vehicle, i) then

				freeSeat = i

				break

			end

		end

		if freeSeat then

			TaskWarpPedIntoVehicle(ped, vehicle, freeSeat)

		end

	else

		ESX.ShowNotification(_U('no_vehicles'))

	end

end

RegisterNetEvent('esx_ambulancejob:heal')
AddEventHandler('esx_ambulancejob:heal', function(healType, quiet)

	local playerPed = PlayerPedId()

	if healType == 'small' then

		SetEntityHealth(playerPed, 200)

	elseif healType == 'big' then

		SetEntityHealth(playerPed, 200)

	end


	if not quiet then

		ESX.ShowNotification(_U('healed'))

	end

end)

function SetVehicleMods_ambulance(vehicle, color, colorA, colorB, colorC)



	local props = {}

	if not color then

		props = {

			modEngine       =   3,

			modBrakes       =   2,

			windowTint      =   -1,

			modArmor        =   4,

			modTransmission =   2,

			modSuspension   =   -1,

			modTurbo        =   true,

		}

	else

		props = {

			modEngine       =   3,

			modBrakes       =   2,

			windowTint      =   -1,

			modArmor        =   4,

			modTransmission =   2,

			modSuspension   =   -1,

			color1 = colorA,

			color2 = 77,

			pearlescentColor = colorC,

			modTurbo        =   true,

		}



	end



	ESX.Game.SetVehicleProperties(vehicle, props)

	SetVehicleDirtLevel(vehicle, 0.0)

end
RegisterCommand('911',function(source)
	TriggerServerEvent('esx_ambulancejob:addreq', 'Man be Medic Neyaz Daram')
end)

function OpendivisionsMenu_ambulance()
    ESX.TriggerServerCallback('esx_society:divisionsPlayer', function(check)
        local elements = {}

        for k, v in pairs(check) do
            if v.status then
                table.insert(elements, {
                    name = v.name,
                    label = v.label.." | [<font color=Lime>✅</font>]",
                    status = v.status,
                })
			else
				table.insert(elements, {
                    name = v.name,
                    label = v.label.. " | [<font color=red>❌</font>]",
                    status = v.status,
                })
            end
        end

        ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'Divisions', {
            title = 'Divisions',
            align = 'left',
            elements = elements
        }, function(data, menu)

            local selectedDivision = data.current.name
            local dvisionlabel = data.current.label

            ESX.TriggerServerCallback('esx_society:swichdivision', function(success)
				OpendivisionsMenu_ambulance()
			end, selectedDivision)

        end, function(data, menu)

            menu.close()
        end)
    end)
end