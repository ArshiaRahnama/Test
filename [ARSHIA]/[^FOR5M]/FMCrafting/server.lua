ESX = nil

local Webhook = ''
local sessions = {}

TriggerEvent(Config.ESX, function(obj) ESX = obj end)

RegisterServerEvent('FMCrafting:craftStartItem')
AddEventHandler('FMCrafting:craftStartItem',function()
	sessions[source] = {
		stoppedCraft = false,
		isCrafting = true,
		last = GetGameTimer(),
	}
end)

RegisterServerEvent('FMCrafting:craftStopItem')
AddEventHandler('FMCrafting:craftStopItem',function()
	sessions[source] = {
		stoppedCraft = true,
		isCrafting = false,
	}
end)

RegisterServerEvent('FMCrafting:failedCraft')
AddEventHandler('FMCrafting:failedCraft',function(item)
	local xPlayer = ESX.GetPlayerFromId(source)
	if true then
		local identifierlist = ExtractIdentifiers(xPlayer.source)
		local data = {
			playerid = xPlayer.source,
			identifier = identifierlist.license:gsub("license2:", ""),
			discord = "<@"..identifierlist.discord:gsub("discord:", "")..">",
			type = "failed",
			item = item,
		}
		noSession(data)
	end
end)

RegisterServerEvent('FMCrafting:craftItemDeath')
AddEventHandler('FMCrafting:craftItemDeath',function(queueClient)
	local xPlayer = ESX.GetPlayerFromId(source)
	local queue = queueClient

	if sessions[source] then
		if sessions[source].stoppedCraft then
			for k,v in ipairs(queue) do
				for k2,v2 in ipairs(v.recipe) do
					xPlayer.addInventoryItem(v2[1], v2[2])
				end
			end
			TriggerClientEvent('okokNotify:Alert', source, "CRAFTING", "You died, all crafting items were given back", 5000, 'info')
			sessions[xPlayer.source] = nil
		end
	else
		if true then
			local identifierlist = ExtractIdentifiers(xPlayer.source)
			local data = {
				playerid = xPlayer.source,
				identifier = identifierlist.license:gsub("license2:", ""),
				discord = "<@"..identifierlist.discord:gsub("discord:", "")..">",
				type = "Death",
			}
			noSession(data)
		end
		TriggerClientEvent('okokNotify:Alert', source, "CRAFTING", "No session!", 5000, 'error')
	end
			
end)

RegisterServerEvent('FMCrafting:craftItemFinished')
AddEventHandler('FMCrafting:craftItemFinished', function(item, crafts, itemName, isItem)
	local xPlayer = ESX.GetPlayerFromId(source)
	local timeToCraft = 600000
	local amount = 0

	if sessions[source] then
		for k,v in ipairs(crafts) do
			if v.item == item then
				amount = v.amount
				timeToCraft = v.time * 1000
			end
		end
		sessions[source].last = GetGameTimer() - sessions[source].last

		if sessions[source].last+500 >= timeToCraft then
			if isItem then
				xPlayer.addInventoryItem(item, amount)
			else
				xPlayer.addWeapon(item, 1)
			end
			if true then
				local identifierlist = ExtractIdentifiers(xPlayer.source)
				local data = {
					playerid = xPlayer.source,
					identifier = identifierlist.license:gsub("license2:", ""),
					discord = "<@"..identifierlist.discord:gsub("discord:", "")..">",
					type = "conclude-crafting",
					itemName = itemName,
					time = sessions[xPlayer.source].last,
				}
				noSession(data)
			end
			sessions[xPlayer.source] = nil
		else
			if true then
				local identifierlist = ExtractIdentifiers(xPlayer.source)
				local data = {
					playerid = xPlayer.source,
					identifier = identifierlist.license:gsub("license2:", ""),
					discord = "<@"..identifierlist.discord:gsub("discord:", "")..">",
					type = "crafted-soon",
					time_taken = sessions[source].last,
					time_needed = timeToCraft,
					itemName = itemName,
				}
				noSession(data)
			end
			TriggerClientEvent('okokNotify:Alert', source, "CRAFTING", "Anti-cheat protection!", 5000, 'error')
		end
	else
		if true then
			local identifierlist = ExtractIdentifiers(xPlayer.source)
			local data = {
				playerid = xPlayer.source,
				identifier = identifierlist.license:gsub("license2:", ""),
				discord = "<@"..identifierlist.discord:gsub("discord:", "")..">",
				type = "conclude",
			}
			noSession(data)
		end
		TriggerClientEvent('okokNotify:Alert', source, "CRAFTING", "No session!", 5000, 'error')
	end
			
end)

ESX.RegisterServerCallback("FMCrafting:inv2", function(source, cb, item)
	local xPlayer = ESX.GetPlayerFromId(source)
	local item = xPlayer.getInventoryItem(item)

	cb(item)
end)


ESX.RegisterServerCallback("FMCrafting:CanCraftItem", function(source, cb, itemID, recipe, itemName, amount)
	local xPlayer = ESX.GetPlayerFromId(source)
	local canCraft = true

	for k,v in pairs(recipe) do
		local item = xPlayer.getInventoryItem(v[1])

		if item.count < v[2] then
			canCraft = false
		end
	end
	if canCraft then
		if true then
			for k,v in pairs(recipe) do
				if v[3] == "true" then
					xPlayer.removeInventoryItem(v[1], v[2])
				end
			end
			cb(true)
			TriggerClientEvent('okokNotify:Alert', source, "CRAFTING", itemID .." added to the crafting queue", 5000, 'success')
			if true then
				local identifierlist = ExtractIdentifiers(xPlayer.source)
				local data = {
					playerid = xPlayer.source,
					identifier = identifierlist.license:gsub("license2:", ""),
					discord = "<@"..identifierlist.discord:gsub("discord:", "")..">",
					type = "crafting",
					itemName = itemID ,
				}
				noSession(data)
			end
		else
			cb(false)
			TriggerClientEvent('okokNotify:Alert', source, "CRAFTING", "You can't carry "..itemID, 5000, 'error')
		end
	else
		cb(false)
		TriggerClientEvent('okokNotify:Alert', source, "CRAFTING", "You can't craft "..itemID, 5000, 'error')
	end
end)

-------------------------- IDENTIFIERS

function ExtractIdentifiers(id)
    local identifiers = {
        steam = "",
        ip = "",
        discord = "",
        license = "",
        xbl = "",
        live = ""
    }

    for i = 0, GetNumPlayerIdentifiers(id) - 1 do
        local playerID = GetPlayerIdentifier(id, i)

        if string.find(playerID, "steam") then
            identifiers.steam = playerID
        elseif string.find(playerID, "ip") then
            identifiers.ip = playerID
        elseif string.find(playerID, "discord") then
            identifiers.discord = playerID
        elseif string.find(playerID, "license") then
            identifiers.license = playerID
        elseif string.find(playerID, "xbl") then
            identifiers.xbl = playerID
        elseif string.find(playerID, "live") then
            identifiers.live = playerID
        end
    end

    return identifiers
end


function noSession(data)
	local category = 'craft'
	if data.type == 'Death' then

		category = 'Tried to receive the crafting items without starting a crafting, he might be cheating'
	
	elseif data.type == 'conclude' then

		category = 'Tried to conclude a crafting without starting it first, he might be cheating'
	
	elseif data.type == 'crafted-soon' then

		category = 'Concluded the crafting of '..data.itemName..' after '..data.time_taken..'ms while it takes '..data.time_needed..'ms to craft, he might be cheating'
	
	elseif data.type == 'crafting' then
	
		category = 'Added '..data.itemName..' to queue'

	elseif data.type == 'conclude-crafting' then
	
		category = 'Crafted a '..data.itemName..' after '..data.time..'ms'

	elseif data.type == 'failed' then

		category = 'Failed to craft a '..data.item
	end
	TriggerEvent('For5M:SendLog', data.playerid , 'CRAFTING' , category )
end 																																																																																																																																																																																																																																														