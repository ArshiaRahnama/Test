ESX = nil

local isCraftOpen = false
local SE = TriggerServerEvent
local waitMore = true
local hasEntered = false
local blipsLoaded = false
local itemAmnt, timeCraft, itemRecipe, craftss, success, isItem
local queue = {}
local closestBlip
local maxCraftRadius

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent(Config.ESX, function(obj) ESX = obj end)
		Citizen.Wait(0)
	end
	while ESX.GetPlayerData().job == nil do
		Citizen.Wait(10)
	end
	PlayerData = ESX.GetPlayerData()
end)


RegisterNetEvent('For5M:OpenCraftMenu')
AddEventHandler('For5M:OpenCraftMenu', function()
	ESX.TriggerServerCallback("FMGangs:MyGangLevel", function(GangLevel)
		SetNuiFocus(true, true)
		local CraftTable = CraftData.Crafting.crafts
		CraftData.Crafting.crafts = {}
		for k,v in pairs(CraftTable) do
			if GangLevel >= v.Level then
				table.insert(CraftData.Crafting.crafts, {
					item = v.item, -- Item id and name of the image
					amount = v.amount,
					Level = v.Level,
					successCraftPercentage = v.successCraftPercentage, -- Percentage of successful craft 0 = 0% | 50 = 50% | 100 = 100%
					isItem = v.isItem, -- if true = is item | if false = is weapon
					time = v.time, -- Time to craft (in seconds)
					recipe = v.recipe
				})
			end
		end
		SendNUIMessage({
			action = "openCraft",
			name = CraftData.Crafting.tableName,
			craft = CraftData.Crafting.crafts,
			itemNames = {},
			wb = CraftData.Crafting.tableID,
			imgs = Config.inventoryimg ,
		})
	end)
end)

RegisterNUICallback('action', function(data, cb)
	if data.action == 'close' then
		TriggerScreenblurFadeOut(5000)
		SetNuiFocus(false, false)
		if CraftData.HideMinimap then
			DisplayRadar(true)
		end
		hasEntered = true
	
		isCraftOpen = false
		waitMore = false
	elseif data.action == 'craft' then
		local invItems = {}
		local loop = 0
		local added = 0
		for k,v in pairs(data.crafts) do
			if data.item == v.item then
				for k2,v2 in pairs(v.recipe) do
					loop = loop + 1
					ESX.TriggerServerCallback("FMCrafting:inv2", function(item)
						local key = item.name
						local value = {key = item.count}
						table.insert(invItems, value)
						added = added + 1
					end, v2[1])
				end
				while added ~= loop do
					Citizen.Wait(100)
				end
				itemAmnt, timeCraft, itemRecipe, craftss, success, isItem = v.amount, v.time, v.recipe, data.crafts, v.successCraftPercentage, v.isItem
				SendNUIMessage({
					action = "openSideCraft",
					itemNameID = data.item,
					itemName = data.itemName[data.item],
					itemNames = data.itemName,
					itemAmount = v.amount,
					percentage = v.successCraftPercentage,
					time = v.time,
					recipe = v.recipe,
					inventory = invItems,
					crafts = data.crafts,
				})
				break
			end
		end
	elseif data.action == 'craft-button' then
		local recipeTable = Split(data.recipe, ",")
		local invItems = {}
		local loop = 0
		local added = 0

		local item = {
			item = data.itemID,
			recipe = recipeTable,
			amount = data.amount,
			success = success,
			isItem = isItem,
			time = timeCraft,
			recipe = itemRecipe,
			crafts = craftss,
			closeBlip = closestBlip,
			maxCraftRadius = maxCraftRadius,
		}
		table.insert(queue, item)
		--ESX.TriggerServerCallback("FMCrafting:itemNames", function(itemNames)
			local itemNames = {}
			ESX.TriggerServerCallback("FMCrafting:CanCraftItem", function(canCraft)
				if canCraft then
					for k2,v2 in pairs(recipeTable) do
						loop = loop + 1
						ESX.TriggerServerCallback("FMCrafting:inv2", function(item)
							local key = item.name
							local value = {key = item.count}
							table.insert(invItems, value)
							added = added + 1
						end, v2[1])
					end
					while added ~= loop do
						Citizen.Wait(100)
					end
					SendNUIMessage({
						action = "openSideCraft",
						itemNameID = data.itemID,
						itemName = itemNames[data.itemID],
						itemNames = itemNames,
						itemAmount = data.amount,
						time = timeCraft,
						recipe = itemRecipe,
						inventory = invItems,
						crafts = craftss,
					})
					if queue[1] == item then
						local crafting = false
						while queue[1] ~= nil do
							Citizen.Wait(100)
							if not crafting then
								crafting = true
								SE('FMCrafting:craftStartItem')
								local invItems = {}
								local loop = 0
								local added = 0
								
								for k,v in pairs(queue[1].recipe) do
									loop = loop + 1
									ESX.TriggerServerCallback("FMCrafting:inv2", function(item)
										local key = item.name
										local value = {key = item.count}
										table.insert(invItems, value)
										added = added + 1
									end, v[1])
								end
								while added ~= loop do
									Citizen.Wait(50)
								end

								local timePassed = 0
								while timePassed < queue[1].time do
									local playerCoords = GetEntityCoords(PlayerPedId())
									local distance =  3.0 -- GetDistanceBetweenCoords(playerCoords.x, playerCoords.y, playerCoords.z, queue[1].closeBlip[1], queue[1].closeBlip[2], queue[1].closeBlip[3])
									SendNUIMessage({
										action = "ShowCraftCount",
										time = queue[1].time - timePassed,
										name = queue[1].item,
									})
									--if distance <= queue[1].maxCraftRadius then
										timePassed = timePassed + 1
								--	end
									Citizen.Wait(1000)

									if IsEntityDead(PlayerPedId()) then
										SE('FMCrafting:craftStopItem')
										break
									end
								end
								if IsEntityDead(PlayerPedId()) then
									SendNUIMessage({
										action = "HideCraftCount",
									})
									SE('FMCrafting:craftItemDeath', queue)
									for k,v in pairs(queue) do
										queue[k] = nil
									end
									break
								end
								local randomNumber = math.random(0, 100)

								if randomNumber <= queue[1].success then
									SE('FMCrafting:craftItemFinished', queue[1].item, queue[1].crafts, queue[1].item, queue[1].isItem)
									SendNUIMessage({
										action = "CompleteCraftCount",
										name = queue[1].item,
									})
								else
									SendNUIMessage({
										action = "FailedCraftCount",
										name = queue[1].item,
									})
									SE('FMCrafting:failedCraft', queue[1].item)
								end
								
								Citizen.Wait(2000)
								SendNUIMessage({
									action = "HideCraftCount",
								})
								table.remove(queue, 1)
								crafting = false
							end
							while crafting do
								Citizen.Wait(500)
							end
						end
					end
				end
			end, data.itemID, recipeTable, itemNames, data.amount)
	--	end)
	end
end)

function Split(s, delimiter)
	local index = 0
	local result = {}
	local line = {}

	for match in (s..delimiter):gmatch("(.-)"..delimiter) do
		if tonumber(match) ~= nil then
			match = tonumber(match)
		end
		if index == 0 or index % 3 ~= 0 then
			table.insert(line, match)
		else
			table.insert(result, line)
			line = {}
			table.insert(line, match)
		end
		index = index + 1
	end
	table.insert(result, line)
	return result
end