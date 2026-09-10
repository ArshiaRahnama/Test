ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
local fishingPlayers = {}

local grabitems = {
    [1] = { name = 'mahigoli', price = math.random(1000, 1100) },
    [2] = { name = 'ghezelala', price = math.random(800, 1000) },
    [3] = { name = 'hamoor', price = math.random(1100, 1200) },
    [4] = { name = 'salomon', price = math.random(600, 800) },
    [5] = { name = 'meygoo', price = math.random(850, 950) },
	[6] = { name = 'jolbak', price = math.random(5, 10) },
}

ESX.RegisterServerCallback('GetMahiPrice', function(source, cb)
	cb({
		{name = 'mahigoli' 	, price = 800 },
		{name = 'ghezelala'	, price = 1100 },
		{name = 'hamoor' 	, price = 1000 },
		{name = 'salomon'	, price = 600 },
		{name = 'meygoo'	, price = 850 },
		{name = 'jolbak'	, price = 5 },
		{name = 'henmeat'	, price = 5000 },
		{name = 'rabbitmeat'	, price = 20000 },
		{name = 'gazellemeet'	, price = 20000 },
		{name = 'eaglemeet'	, price = 30000 },
	})
end)

ESX.RegisterUsableItem('fishingrod', function(source)
  TriggerClientEvent('fishing:start', source)
end)

RegisterServerEvent('fishing:done')
AddEventHandler('fishing:done', function(number)
    local xPlayer = ESX.GetPlayerFromId(source)
    if not xPlayer then return end

    -- SECURITY FIX: this used to trust `number` blindly (crashing on an
    -- out-of-range value via grab.name below) and never checked the player
    -- actually holds a fishing rod -- any client could call this event
    -- directly, bypassing both the rod requirement and the fishing
    -- minigame, for free fish every 20s.
    local grab = grabitems[number]
    if not grab then return end

    local rodItem = xPlayer.getInventoryItem("fishingrod")
    if not rodItem or rodItem.count < 1 then
        return
    end

    local xItem = xPlayer.getInventoryItem(grab.name)
    if xItem.count >= xItem.limit and xItem.limit ~= -1 then
        TriggerClientEvent('esx:showNotification', source, 'Shoma Fazaye khali baraye ' .. xItem.label .. ' ra nadarid')
        return
    end
    if fishingPlayers[source] then
        local time = os.time() - fishingPlayers[source]
        if time < 20 then

            return
        end
    end

    TriggerClientEvent("Task_System:MahiGiri", source)

    if grab.name == "mahigoli" then
        TriggerClientEvent("Task_System:Mahimahigoli", source)
    elseif grab.name == "ghezelala" then
        TriggerClientEvent("Task_System:Mahighezelala", source)
    elseif grab.name == "hamoor" then
        TriggerClientEvent("Task_System:Mahihamoor", source)
    elseif grab.name == "salomon" then
        TriggerClientEvent("Task_System:Mahisalomon", source)
    elseif grab.name == "meygoo" then
        TriggerClientEvent("Task_System:Mahimeygoo", source)
    elseif grab.name == "jolbak" then
        TriggerClientEvent("Task_System:Mahijolbak", source)
    end

    fishingPlayers[source] = os.time()
    xPlayer.addInventoryItem(grab.name, 1)
    exports['Unique_Skills']:UpdateSkill(source, "Fishing", 0.010)
end)

ESX.RegisterServerCallback('fishing:haveItem', function(source, cb)
	local xPlayer = ESX.GetPlayerFromId(source)
    local xItem = xPlayer.getInventoryItem("fishingrod")
	if xItem.count >= 1 then
		cb(true)
	else
		cb(false)
	end
end)

AddEventHandler('playerDropped', function()
    if fishingPlayers[source] then
        fishingPlayers[source] = nil
    end
end)