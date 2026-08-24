ESX = nil
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
ESX.RegisterUsableItem('lotteryticket', function(source)
	local xPlayer = ESX.GetPlayerFromId(source)
	xPlayer.removeInventoryItem('lotteryticket', 1)
	local reward = math.random(250, 600)
	xPlayer.addMoney(reward)
	TriggerClientEvent('chatMessage', source, "[SYSTEM]", {255, 0, 0}, " ^0Shoma yek blit bakht azmayi baz kardid va ^2" .. reward .. "$ ^0 bordid")
end)
ESX.RegisterUsableItem('chips', function(source)
	local xPlayer = ESX.GetPlayerFromId(source)
	xPlayer.removeInventoryItem('chips', 1)
	TriggerClientEvent('esx_status:add', source, 'hunger', 40000)
	TriggerClientEvent('esx_basicneeds:onEat', source, "prop_ld_snack_01")
	TriggerClientEvent('esx:showNotification', source, "Shoma yek ~g~Chips ~w~khordid")
end)
ESX.RegisterUsableItem('cheesebows', function(source)
	local xPlayer = ESX.GetPlayerFromId(source)
	xPlayer.removeInventoryItem('cheesebows', 1)
	TriggerClientEvent('esx_status:add', source, 'hunger', 40000)
	TriggerClientEvent('esx_basicneeds:onEat', source, "prop_food_bs_burger2")
	TriggerClientEvent('esx:showNotification', source, "Shoma yek ~g~Snack ~w~khordid")
end)
ESX.RegisterUsableItem('marabou', function(source)
	local xPlayer = ESX.GetPlayerFromId(source)
	xPlayer.removeInventoryItem('marabou', 1)
	TriggerClientEvent('esx_status:add', source, 'hunger', 40000)
	TriggerClientEvent('esx_basicneeds:onEat', source, "prop_choc_ego")
	TriggerClientEvent('esx:showNotification', source, "Shoma yek ~g~Shokolat ~w~khordid")
end)
ESX.RegisterUsableItem('fanta', function(source)
	local xPlayer = ESX.GetPlayerFromId(source)
	xPlayer.removeInventoryItem('fanta', 1)
	TriggerClientEvent('esx_status:add', source, 'thirst', 200000)
	TriggerClientEvent('esx_basicneeds:onDrink', source, "ng_proc_sodacan_01b")
	TriggerClientEvent('esx:showNotification', source, "Shoma yek ~g~Fanta ~w~noshidid")
end)
ESX.RegisterUsableItem('sprite', function(source)
	local xPlayer = ESX.GetPlayerFromId(source)
	xPlayer.removeInventoryItem('sprite', 1)
	TriggerClientEvent('esx_status:add', source, 'thirst', 200000)
	TriggerClientEvent('esx_basicneeds:onDrink', source, "ng_proc_sodacan_01b")
	TriggerClientEvent('esx:showNotification', source, "Shoma yek ~g~Sprite ~w~noshidid")
end)
ESX.RegisterUsableItem('cocacola', function(source)
	local xPlayer = ESX.GetPlayerFromId(source)
	xPlayer.removeInventoryItem('cocacola', 1)
	TriggerClientEvent('esx_status:add', source, 'thirst', 200000)
	TriggerClientEvent('esx_basicneeds:onDrink', source, "ng_proc_sodacan_01b")
	TriggerClientEvent('esx:showNotification', source, "Shoma yek ~g~cocacola ~w~noshidid")
end)
ESX.RegisterUsableItem('sandwich', function(source)
	local xPlayer = ESX.GetPlayerFromId(source)
	xPlayer.removeInventoryItem('sandwich', 1)
	TriggerClientEvent('esx_status:add', source, 'hunger', 100000)
	TriggerClientEvent('esx_basicneeds:playAnim', source, "sandwich")
	TriggerClientEvent('esx:showNotification', source, "Shoma yek ~g~Sandwich ~w~khordid")
end)
ESX.RegisterUsableItem('cigarett', function(source)
	local xPlayer = ESX.GetPlayerFromId(source)
	local lighter = xPlayer.getInventoryItem('lighter')
	if lighter.count > 0 then
		xPlayer.removeInventoryItem('cigarett', 1)
		TriggerClientEvent('esx_basicneeds:playAnim', source, "smoke")
		TriggerClientEvent('esx:showNotification', source, ('Shoma shoro be keshidan cigar kardid'))
	else
		TriggerClientEvent('chatMessage', source, "[SYSTEM]", {255, 0, 0}, " ^0Shoma baraye etefade az cigar niaz be fandak darid!")
	end
end)

RegisterServerEvent('esx_customItems:remove')
AddEventHandler('esx_customItems:remove', function(itemName)
	local xPlayer = ESX.GetPlayerFromId(source)
	xPlayer.removeInventoryItem(itemName, 1)
end)
ESX.RegisterUsableItem('blowtorch', function(source)
    TriggerClientEvent('esx_customItems:useBlowtorch', source)
end)
ESX.RegisterUsableItem('armor', function(source)
	TriggerClientEvent('esx_customItems:useArmor', source)
end)
ESX.RegisterUsableItem('sianor', function(source)
	TriggerClientEvent('esx_customItems:useSianor', source)
	TriggerClientEvent('esx_basicneeds:playAnim', source, "sianor")
end)

ESX.RegisterUsableItem('noshab', function(source)
	TriggerClientEvent('esx_customItems:useNoshab', source)
end)
ESX.RegisterUsableItem('ss', function(source)
	TriggerClientEvent('esx_customItems:useSS', source)
	TriggerClientEvent('esx_basicneeds:playAnim', source, "sandwich")
	Wait (30000)
	TriggerClientEvent('esx_status:add', source, 'hunger', 500000)
end)
ESX.RegisterUsableItem('sibp', function(source)
	TriggerClientEvent('esx_customItems:useSibp', source)
	TriggerClientEvent('esx_basicneeds:playAnim', source, "sibzamini")
	Wait (30000)
	TriggerClientEvent('esx_status:add', source, 'hunger', 200000)
end)
ESX.RegisterUsableItem('sf', function(source)
	TriggerClientEvent('esx_customItems:useSF', source)
	TriggerClientEvent('esx_basicneeds:playAnim', source, "sandwich")
	Wait (30000)
	TriggerClientEvent('esx_status:add', source, 'hunger', 500000)
end)
ESX.RegisterUsableItem('sh', function(source)
	TriggerClientEvent('esx_customItems:useSH', source)
	TriggerClientEvent('esx_basicneeds:playAnim', source, "sh")
	Wait (30000)
	TriggerClientEvent('esx_status:add', source, 'hunger', 500000)
end)
ESX.RegisterUsableItem('sm', function(source)
	TriggerClientEvent('esx_customItems:useSM', source)
	TriggerClientEvent('esx_basicneeds:playAnim', source, "sandwich")
	Wait (30000)
	TriggerClientEvent('esx_status:add', source, 'hunger', 1000000)
end)
ESX.RegisterUsableItem('pizzamo', function(source)
	TriggerClientEvent('esx_customItems:usePMO', source)
	TriggerClientEvent('esx_basicneeds:playAnim', source, "sandwich")
	Wait (30000)
	TriggerClientEvent('esx_status:add', source, 'hunger', 1000000)
end)
ESX.RegisterUsableItem('pizzama', function(source)
	TriggerClientEvent('esx_customItems:usePMA', source)
	TriggerClientEvent('esx_basicneeds:playAnim', source, "sandwich")
	Wait (30000)
	TriggerClientEvent('esx_status:add', source, 'hunger', 600000)
end)
ESX.RegisterUsableItem('kabab', function(source)
	TriggerClientEvent('esx_customItems:useKABAB', source)
	TriggerClientEvent('esx_basicneeds:playAnim', source, "sandwich")
	Wait (30000)
	TriggerClientEvent('esx_status:add', source, 'hunger', 750000)
end)
ESX.RegisterUsableItem('joje', function(source)
	TriggerClientEvent('esx_customItems:useJOJE', source)
	TriggerClientEvent('esx_basicneeds:playAnim', source, "sandwich")
	Wait (30000)
	TriggerClientEvent('esx_status:add', source, 'hunger', 1000000)
end)
ESX.RegisterUsableItem('mahighezel', function(source)
	TriggerClientEvent('esx_customItems:useMAHIGHEZEL', source)
	TriggerClientEvent('esx_basicneeds:playAnim', source, "sandwich")
	Wait (30000)
	TriggerClientEvent('esx_status:add', source, 'hunger', 750000)
end)
ESX.RegisterUsableItem('mahihamoor', function(source)
	TriggerClientEvent('esx_customItems:useMAHIHAMOOR', source)
	TriggerClientEvent('esx_basicneeds:playAnim', source, "sandwich")
	Wait (30000)
	TriggerClientEvent('esx_status:add', source, 'hunger', 750000)
end)
ESX.RegisterUsableItem('mahgolip', function(source)
	TriggerClientEvent('esx_customItems:useMAHIGOLIP', source)
	TriggerClientEvent('esx_basicneeds:playAnim', source, "sandwich")
	Wait (30000)
	TriggerClientEvent('esx_status:add', source, 'hunger', 750000)
end)
ESX.RegisterUsableItem('unagieelroll', function(source)
	TriggerClientEvent('esx_customItems:useUNAGIEELROLL', source)
	TriggerClientEvent('esx_basicneeds:playAnim', source, "sandwich")
	Wait (30000)
	TriggerClientEvent('esx_status:add', source, 'hunger', 1000000)
end)
ESX.RegisterUsableItem('ebitenrol', function(source)
	TriggerClientEvent('esx_customItems:useEBITENROL', source)
	TriggerClientEvent('esx_basicneeds:playAnim', source, "sandwich")
	Wait (30000)
	TriggerClientEvent('esx_status:add', source, 'hunger', 1000000)
end)
ESX.RegisterUsableItem('dooghbg', function(source)
	local xPlayer = ESX.GetPlayerFromId(source)
	TriggerClientEvent('esx_customItems:useDOGHBEDOONGAZ', source)
	TriggerClientEvent('esx_basicneeds:playAnim', source, "beer")
	Wait (30000)
	TriggerClientEvent('esx_status:add', source, 'thirst', 500000)
end)
ESX.RegisterUsableItem('dooghg', function(source)
	local xPlayer = ESX.GetPlayerFromId(source)
	TriggerClientEvent('esx_customItems:useDOGHGAZDAR', source)
	TriggerClientEvent('esx_basicneeds:playAnim', source, "beer")
	Wait (30000)
	TriggerClientEvent('esx_status:add', source, 'thirst', 50000)
end)
ESX.RegisterUsableItem('delester', function(source)
	local xPlayer = ESX.GetPlayerFromId(source)
	TriggerClientEvent('esx_customItems:useDELESTER', source)
	TriggerClientEvent('esx_basicneeds:playAnim', source, "beer")
	Wait (30000)
	TriggerClientEvent('esx_status:add', source, 'thirst', 50000)
end)
ESX.RegisterUsableItem('picklock', function(source)
	local xPlayer = ESX.GetPlayerFromId(source)
	TriggerClientEvent('esx_vehiclecontrol:HiJack', source)
end)
ESX.RegisterServerCallback("esx_customItems:removeArmor", function(source, cb)
	local xPlayer = ESX.GetPlayerFromId(source)
	if xPlayer then
		local armor  = xPlayer.getInventoryItem('armor')
		if armor then
			if armor.count > 0 then
				xPlayer.removeInventoryItem('armor', 1)
				cb(true)
			else
				cb(false)
			end
		else
			cb(false)
		end
	else
		cb(false)
	end
end)
ESX.RegisterServerCallback("esx_customItems:removeSianor", function(source, cb)
	local xPlayer = ESX.GetPlayerFromId(source)
	if xPlayer then
		local sianor  = xPlayer.getInventoryItem('sianor')
		if sianor then
			if sianor.count > 0 then
				xPlayer.removeInventoryItem('sianor', 1)
				cb(true)
			else
				cb(false)
			end
		else
			cb(false)
		end
	else
		cb(false)
	end
end)
ESX.RegisterServerCallback("esx_customItems:removeNoshab", function(source, cb)
	local xPlayer = ESX.GetPlayerFromId(source)
	if xPlayer then
		local noshab  = xPlayer.getInventoryItem('noshab')
		if noshab then
			if noshab.count > 0 then
				xPlayer.removeInventoryItem('noshab', 1)
				cb(true)
			else
				cb(false)
			end
		else
			cb(false)
		end
	else
		cb(false)
	end
end)
ESX.RegisterServerCallback("esx_customItems:removeSH", function(source, cb)
	local xPlayer = ESX.GetPlayerFromId(source)
	if xPlayer then
		local sh  = xPlayer.getInventoryItem('sh')
		if sh then
			if sh.count > 0 then
				xPlayer.removeInventoryItem('sh', 1)
				cb(true)
			else
				cb(false)
			end
		else
			cb(false)
		end
	else
		cb(false)
	end
end)
ESX.RegisterServerCallback("esx_customItems:removeSM", function(source, cb)
	local xPlayer = ESX.GetPlayerFromId(source)
	if xPlayer then
		local sm  = xPlayer.getInventoryItem('sm')
		if sm then
			if sm.count > 0 then
				xPlayer.removeInventoryItem('sm', 1)
				cb(true)
			else
				cb(false)
			end
		else
			cb(false)
		end
	else
		cb(false)
	end
end)
ESX.RegisterServerCallback("esx_customItems:removeSF", function(source, cb)
	local xPlayer = ESX.GetPlayerFromId(source)
	if xPlayer then
		local sf  = xPlayer.getInventoryItem('sf')
		if sf then
			if sf.count > 0 then
				xPlayer.removeInventoryItem('sf', 1)
				cb(true)
			else
				cb(false)
			end
		else
			cb(false)
		end
	else
		cb(false)
	end
end)
ESX.RegisterServerCallback("esx_customItems:removeSS", function(source, cb)
	local xPlayer = ESX.GetPlayerFromId(source)
	if xPlayer then
		local ss  = xPlayer.getInventoryItem('ss')
		if ss then
			if ss.count > 0 then
				xPlayer.removeInventoryItem('ss', 1)
				cb(true)
			else
				cb(false)
			end
		else
			cb(false)
		end
	else
		cb(false)
	end
end)
ESX.RegisterServerCallback("esx_customItems:removeSibp", function(source, cb)
	local xPlayer = ESX.GetPlayerFromId(source)
	if xPlayer then
		local sibp  = xPlayer.getInventoryItem('sibp')
		if sibp then
			if sibp.count > 0 then
				xPlayer.removeInventoryItem('sibp', 1)
				cb(true)
			else
				cb(false)
			end
		else
			cb(false)
		end
	else
		cb(false)
	end
end)
ESX.RegisterServerCallback("esx_customItems:removePMA", function(source, cb)
	local xPlayer = ESX.GetPlayerFromId(source)
	if xPlayer then
		local pizzama  = xPlayer.getInventoryItem('pizzama')
		if pizzama then
			if pizzama.count > 0 then
				xPlayer.removeInventoryItem('pizzama', 1)
				cb(true)
			else
				cb(false)
			end
		else
			cb(false)
		end
	else
		cb(false)
	end
end)
ESX.RegisterServerCallback("esx_customItems:removePMO", function(source, cb)
	local xPlayer = ESX.GetPlayerFromId(source)
	if xPlayer then
		local pizzamo  = xPlayer.getInventoryItem('pizzamo')
		if pizzamo then
			if pizzamo.count > 0 then
				xPlayer.removeInventoryItem('pizzamo', 1)
				cb(true)
			else
				cb(false)
			end
		else
			cb(false)
		end
	else
		cb(false)
	end
end)
ESX.RegisterServerCallback("esx_customItems:removeKABAB", function(source, cb)
	local xPlayer = ESX.GetPlayerFromId(source)
	if xPlayer then
		local kabab  = xPlayer.getInventoryItem('kabab')
		if kabab then
			if kabab.count > 0 then
				xPlayer.removeInventoryItem('kabab', 1)
				cb(true)
			else
				cb(false)
			end
		else
			cb(false)
		end
	else
		cb(false)
	end
end)
ESX.RegisterServerCallback("esx_customItems:removeJOJE", function(source, cb)
	local xPlayer = ESX.GetPlayerFromId(source)
	if xPlayer then
		local joje  = xPlayer.getInventoryItem('joje')
		if joje then
			if joje.count > 0 then
				xPlayer.removeInventoryItem('joje', 1)
				cb(true)
			else
				cb(false)
			end
		else
			cb(false)
		end
	else
		cb(false)
	end
end)
ESX.RegisterServerCallback("esx_customItems:removeMAHIGHEZEL", function(source, cb)
	local xPlayer = ESX.GetPlayerFromId(source)
	if xPlayer then
		local mahighezel  = xPlayer.getInventoryItem('mahighezel')
		if mahighezel then
			if mahighezel.count > 0 then
				xPlayer.removeInventoryItem('mahighezel', 1)
				cb(true)
			else
				cb(false)
			end
		else
			cb(false)
		end
	else
		cb(false)
	end
end)
ESX.RegisterServerCallback("esx_customItems:removeMAHIGOLIP", function(source, cb)
	local xPlayer = ESX.GetPlayerFromId(source)
	if xPlayer then
		local mahigolip  = xPlayer.getInventoryItem('mahigolip')
		if mahigolip then
			if mahigolip.count > 0 then
				xPlayer.removeInventoryItem('mahigolip', 1)
				cb(true)
			else
				cb(false)
			end
		else
			cb(false)
		end
	else
		cb(false)
	end
end)
ESX.RegisterServerCallback("esx_customItems:removeMAHIHAMOOR", function(source, cb)
	local xPlayer = ESX.GetPlayerFromId(source)
	if xPlayer then
		local mahihamoor  = xPlayer.getInventoryItem('mahihamoor')
		if mahihamoor then
			if mahihamoor.count > 0 then
				xPlayer.removeInventoryItem('mahihamoor', 1)
				cb(true)
			else
				cb(false)
			end
		else
			cb(false)
		end
	else
		cb(false)
	end
end)
ESX.RegisterServerCallback("esx_customItems:removeUNAGIEELROLL", function(source, cb)
	local xPlayer = ESX.GetPlayerFromId(source)
	if xPlayer then
		local unagieelroll  = xPlayer.getInventoryItem('unagieelroll')
		if unagieelroll then
			if unagieelroll.count > 0 then
				xPlayer.removeInventoryItem('unagieelroll', 1)
				cb(true)
			else
				cb(false)
			end
		else
			cb(false)
		end
	else
		cb(false)
	end
end)
ESX.RegisterServerCallback("esx_customItems:removeEBITENROL", function(source, cb)
	local xPlayer = ESX.GetPlayerFromId(source)
	if xPlayer then
		local ebitenrol  = xPlayer.getInventoryItem('ebitenrol')
		if ebitenrol then
			if ebitenrol.count > 0 then
				xPlayer.removeInventoryItem('ebitenrol', 1)
				cb(true)
			else
				cb(false)
			end
		else
			cb(false)
		end
	else
		cb(false)
	end
end)
ESX.RegisterServerCallback("esx_customItems:removeDOGHGAZDAR", function(source, cb)
	local xPlayer = ESX.GetPlayerFromId(source)
	if xPlayer then
		local dooghg  = xPlayer.getInventoryItem('dooghg')
		if dooghg then
			if dooghg.count > 0 then
				xPlayer.removeInventoryItem('dooghg', 1)
				cb(true)
			else
				cb(false)
			end
		else
			cb(false)
		end
	else
		cb(false)
	end
end)
ESX.RegisterServerCallback("esx_customItems:removeDOGHBEDOONGAZ", function(source, cb)
	local xPlayer = ESX.GetPlayerFromId(source)
	if xPlayer then
		local dooghbg  = xPlayer.getInventoryItem('dooghbg')
		if dooghbg then
			if dooghbg.count > 0 then
				xPlayer.removeInventoryItem('dooghbg', 1)
				cb(true)
			else
				cb(false)
			end
		else
			cb(false)
		end
	else
		cb(false)
	end
end)
ESX.RegisterServerCallback("esx_customItems:removeDELESTER", function(source, cb)
	local xPlayer = ESX.GetPlayerFromId(source)
	if xPlayer then
		local delester  = xPlayer.getInventoryItem('delester')
		if delester then
			if delester.count > 0 then
				xPlayer.removeInventoryItem('delester', 1)
				cb(true)
			else
				cb(false)
			end
		else
			cb(false)
		end
	else
		cb(false)
	end
end)
ESX.RegisterServerCallback("esx_customItems:removeLSD", function(source, cb)
	local xPlayer = ESX.GetPlayerFromId(source)
	if xPlayer then
		local lsd  = xPlayer.getInventoryItem('lsd')
		if lsd then
			if lsd.count > 0 then
				xPlayer.removeInventoryItem('lsd', 1)
				cb(true)
			else
				cb(false)
			end
		else
			cb(false)
		end
	else
		cb(false)
	end
end)
ESX.RegisterUsableItem('wine', function(source)
	local xPlayer = ESX.GetPlayerFromId(source)
	xPlayer.removeInventoryItem('wine', 1)
	TriggerEvent('Stress-System:RemoveStress', source, 20)
	TriggerClientEvent('esx_basicneeds:playAnim', source, "wine")
	TriggerClientEvent('esx:showNotification', source, "Shoma yek ~g~Sharab ~w~noshidid")
end)
ESX.RegisterUsableItem('beer', function(source)
	local xPlayer = ESX.GetPlayerFromId(source)
	xPlayer.removeInventoryItem('beer', 1)
	TriggerEvent('Stress-System:RemoveStress', source, 10)
	TriggerClientEvent('esx_optionalneeds:onDrink', source)
	TriggerClientEvent('esx:showNotification', source, 'Shoma 1x ~y~Abjo~s~ Noshidid')
	Citizen.Wait(1000)
end)
ESX.RegisterUsableItem('tequila', function(source)
	local xPlayer = ESX.GetPlayerFromId(source)
	xPlayer.removeInventoryItem('tequila', 1)
	TriggerEvent('Stress-System:RemoveStress', source, 25)
	TriggerClientEvent('esx_optionalneeds:onDrink', source)
	TriggerClientEvent('esx:showNotification', source, 'Shoma 1x ~y~Tequila~s~ Noshidid')
	Citizen.Wait(1000)
end)
ESX.RegisterUsableItem('vodka', function(source)
	local xPlayer = ESX.GetPlayerFromId(source)
	xPlayer.removeInventoryItem('vodka', 1)
	TriggerEvent('Stress-System:RemoveStress', source, 35)
	TriggerClientEvent('esx_optionalneeds:onDrink', source)
	TriggerClientEvent('esx:showNotification', source, 'Shoma 1x ~y~Vodka~s~ Noshidid')
	Citizen.Wait(1000)
end)
ESX.RegisterUsableItem('whiskey', function(source)
	local xPlayer = ESX.GetPlayerFromId(source)
	xPlayer.removeInventoryItem('whiskey', 1)
	TriggerEvent('Stress-System:RemoveStress', source, 40)
	TriggerClientEvent('Stress-System:TimeOut', source, 60)
	TriggerClientEvent('esx:showNotification', source, 'Shoma 1x ~y~Whiskey~s~ Noshidid')
	TriggerClientEvent('esx_basicneeds:playAnim', source, "whiskey")
	Citizen.Wait(1000)
end)
ESX.RegisterUsableItem('loka', function(source)
	local xPlayer = ESX.GetPlayerFromId(source)
	xPlayer.removeInventoryItem('loka', 1)
	TriggerEvent('Stress-System:RemoveStress', source, 10)
	TriggerClientEvent('esx_status:add', source, 'thirst', 100000)
	TriggerClientEvent('esx_basicneeds:onDrink', source)
	TriggerClientEvent('esx:showNotification', source, "Shoma yek ~g~Abmive ~w~noshidid")
end)
ESX.RegisterUsableItem('soda', function(source)
	local xPlayer = ESX.GetPlayerFromId(source)
	xPlayer.removeInventoryItem('soda', 1)
	TriggerEvent('Stress-System:RemoveStress', source, 10)
	TriggerClientEvent('esx_status:add', source, 'thirst', 100000)
	TriggerClientEvent('esx_basicneeds:playAnim', source, "soda")
	TriggerClientEvent('esx:showNotification', source, "Shoma yek ~g~Soda ~w~noshidid")
end)
ESX.RegisterUsableItem('coffee', function(source)
	local xPlayer = ESX.GetPlayerFromId(source)
	xPlayer.removeInventoryItem('coffee', 1)
	TriggerEvent('Stress-System:RemoveStress', source, 40)
	TriggerClientEvent('Stress-System:TimeOut', source, 60)
	TriggerClientEvent('esx_status:add', source, 'thirst', 200000)
	TriggerClientEvent('esx_basicneeds:playAnim', source, "coffee")
	TriggerClientEvent('esx:showNotification', source, "Shoma yek ~g~Coffee ~w~noshidid")
end)
ESX.RegisterUsableItem('tea', function(source)
	local xPlayer = ESX.GetPlayerFromId(source)
	xPlayer.removeInventoryItem('tea', 1)
	TriggerEvent('Stress-System:RemoveStress', source, 40)
	TriggerClientEvent('esx_status:add', source, 'thirst', 200000)
	TriggerClientEvent('esx_basicneeds:playAnim', source, "tea")
	TriggerClientEvent('esx:showNotification', source, "Shoma yek ~g~Chaee ~w~noshidid")
end)
ESX.RegisterUsableItem('donut', function(source)
	local xPlayer = ESX.GetPlayerFromId(source)
	xPlayer.removeInventoryItem('donut', 1)
	TriggerClientEvent('esx_status:add', source, 'hunger', 100000)
	TriggerClientEvent('esx_basicneeds:playAnim', source, "donut")
	TriggerClientEvent('esx:showNotification', source, "Shoma yek ~g~Donut ~w~Khordid")
end)