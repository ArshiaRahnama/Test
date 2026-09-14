--[[
	Registers all 30 new bakery/bar/pizza/icecream/sushi items as usable
	items in one loop, driven by shared/newbiz_items.lua, instead of 30
	duplicated ESX.RegisterUsableItem blocks.
]]

for _, item in ipairs(NewBizItems) do
	ESX.RegisterUsableItem(item.name, function(source)
		local xPlayer = ESX.GetPlayerFromId(source)

		xPlayer.removeInventoryItem(item.name, 1)

		TriggerClientEvent('esx_status:add', source, 'thirst', 200000)
		TriggerClientEvent('esx_status:add', source, 'hunger', 200000)
		TriggerClientEvent('uniquecafejobs:onConsumeNewBiz', source, item.prop)
		TriggerClientEvent('esx:showNotification', source, "Shoma ~y~" .. item.label .. "~w~ ra masraf kardid")
	end)
end
