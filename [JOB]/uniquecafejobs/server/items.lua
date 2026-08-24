--------------- Drink  ------------
ESX.RegisterUsableItem('abporteghal', function(source)
	local xPlayer = ESX.GetPlayerFromId(source)

	xPlayer.removeInventoryItem('abporteghal', 1)

	TriggerClientEvent('esx_status:add', source, 'thirst', 333333)
	TriggerClientEvent('AH_uwucafejob:onDrinkabporteghal', source)
	TriggerClientEvent('esx:ShowNotification', source, "Shoma Yek ~y~Ab Porteghal~w~ Noshidid")
end) 

ESX.RegisterUsableItem('bubbletetotfarangi', function(source)
	local xPlayer = ESX.GetPlayerFromId(source)

	xPlayer.removeInventoryItem('bubbletetotfarangi', 1)

	TriggerClientEvent('esx_status:add', source, 'thirst', 1000000)
	TriggerClientEvent('AH_uwucafejob:onDrinkbubbletetotfarangi', source)
	TriggerClientEvent('esx:ShowNotification', source, "Shoma Yek ~y~Bubblete Totfarangi~w~ Noshidid")
end)

ESX.RegisterUsableItem('chaee', function(source)
	local xPlayer = ESX.GetPlayerFromId(source)

	xPlayer.removeInventoryItem('chaee', 1)

	TriggerClientEvent('esx_status:add', source, 'thirst', 500000)
	TriggerClientEvent('AH_uwucafejob:onDrinkchaee', source)
	TriggerClientEvent('esx:ShowNotification', source, "Shoma Yek ~y~Chaee~w~ Noshidid")
end)

ESX.RegisterUsableItem('bastani', function(source)
	local xPlayer = ESX.GetPlayerFromId(source)

	xPlayer.removeInventoryItem('bastani', 1)

	TriggerClientEvent('esx_status:add', source, 'thirst', 200000)
	TriggerClientEvent('esx_status:add', source, 'hunger', 200000)
	TriggerClientEvent('AH_uwucafejob:onDrinkbastani', source)
	TriggerClientEvent('esx:ShowNotification', source, "Shoma Yek ~y~Bastani~w~ Khordid")
end)

ESX.RegisterUsableItem('boba_milk_tea_caramel', function(source)
	local xPlayer = ESX.GetPlayerFromId(source)

	xPlayer.removeInventoryItem('boba_milk_tea_caramel', 1)

	TriggerClientEvent('esx_status:add', source, 'thirst', 1000000)
	TriggerClientEvent('AH_uwucafejob:onDrinkboba_milk_tea_caramel', source)
	TriggerClientEvent('esx:ShowNotification', source, "Shoma Yek ~y~Boba_milk_tea_caramel~w~ Noshidid")
end)

ESX.RegisterUsableItem('boba_milk_tea_matcha', function(source)
	local xPlayer = ESX.GetPlayerFromId(source)

	xPlayer.removeInventoryItem('boba_milk_tea_matcha', 1)

	TriggerClientEvent('esx_status:add', source, 'thirst', 1000000)
	TriggerClientEvent('AH_uwucafejob:onDrinkboba_milk_tea_matcha', source)
	TriggerClientEvent('esx:ShowNotification', source, "Shoma Yek ~y~boba_milk_tea_matcha~w~ Noshidid")
end)

ESX.RegisterUsableItem('bobal_tea_matcha', function(source)
	local xPlayer = ESX.GetPlayerFromId(source)

	xPlayer.removeInventoryItem('bobal_tea_matcha', 1)

	TriggerClientEvent('esx_status:add', source, 'thirst', 1000000)
	TriggerClientEvent('AH_uwucafejob:onDrinkbobal_tea_matchaa', source)
	TriggerClientEvent('esx:ShowNotification', source, "Shoma Yek ~y~bobal_tea_matcha~w~ Noshidid")
end)

ESX.RegisterUsableItem('bobal_tea_tamshak', function(source)
	local xPlayer = ESX.GetPlayerFromId(source)

	xPlayer.removeInventoryItem('bobal_tea_tamshak', 1)

	TriggerClientEvent('esx_status:add', source, 'thirst', 1000000)
	TriggerClientEvent('AH_uwucafejob:onDrinkbobal_tea_tamshak', source)
	TriggerClientEvent('esx:ShowNotification', source, "Shoma Yek ~y~bobal_tea_tamshak~w~ Noshidid")
end)

ESX.RegisterUsableItem('ice_coffee_matcha', function(source)
	local xPlayer = ESX.GetPlayerFromId(source)

	xPlayer.removeInventoryItem('ice_coffee_matcha', 1)

	TriggerClientEvent('esx_status:add', source, 'thirst', 1000000)
	TriggerClientEvent('AH_uwucafejob:onDrinkice_coffee_matcha', source)
	TriggerClientEvent('esx:ShowNotification', source, "Shoma Yek ~y~ice_coffee_matcha~w~ Noshidid")
end)

ESX.RegisterUsableItem('ghahve50', function(source)
	local xPlayer = ESX.GetPlayerFromId(source)

	xPlayer.removeInventoryItem('ghahve50', 1)
	xPlayer.addInventoryItem('fenjonkasif', 1)

	TriggerClientEvent('esx_status:add', source, 'thirst', 500000)
	TriggerClientEvent('AH_uwucafejob:onDrinkghahve', source)
	TriggerClientEvent('esx:ShowNotification', source, "Shoma Yek ~y~Ghahve50~w~ Noshidid")
end)

ESX.RegisterUsableItem('ghahve80', function(source)
	local xPlayer = ESX.GetPlayerFromId(source)

	xPlayer.removeInventoryItem('ghahve80', 1)
	xPlayer.addInventoryItem('fenjonkasif', 1)

	TriggerClientEvent('esx_status:add', source, 'thirst', 333333)
	TriggerClientEvent('AH_uwucafejob:onDrinkghahve', source)
	TriggerClientEvent('esx:ShowNotification', source, "Shoma Yek ~y~Ghahve80~w~ Noshidid")
end)

ESX.RegisterUsableItem('ghahve100', function(source)
	local xPlayer = ESX.GetPlayerFromId(source)

	xPlayer.removeInventoryItem('ghahve100', 1)
	xPlayer.addInventoryItem('fenjonkasif', 1)

	TriggerClientEvent('esx_status:add', source, 'thirst', 1000000)
	TriggerClientEvent('AH_uwucafejob:onDrinkghahve', source)
	TriggerClientEvent('esx:ShowNotification', source, "Shoma Yek ~y~Ghahve100~w~ Noshidid")
end)

ESX.RegisterUsableItem('hot_chocolate', function(source)
	local xPlayer = ESX.GetPlayerFromId(source)

	xPlayer.removeInventoryItem('hot_chocolate', 1)

	TriggerClientEvent('esx_status:add', source, 'thirst', 800000)
	TriggerClientEvent('AH_uwucafejob:onDrinkhot_chocolate', source)
	TriggerClientEvent('esx:ShowNotification', source, "Shoma Yek ~y~Hot Chocolate~w~ Noshidid")
end)

ESX.RegisterUsableItem('latte', function(source)
	local xPlayer = ESX.GetPlayerFromId(source)

	xPlayer.removeInventoryItem('latte', 1)

	TriggerClientEvent('esx_status:add', source, 'thirst', 1000000)
	TriggerClientEvent('AH_uwucafejob:onDrinklatte', source)
	TriggerClientEvent('esx:ShowNotification', source, "Shoma Yek ~y~Lattee~w~ Noshidid")
end)

ESX.RegisterUsableItem('milkshake', function(source)
	local xPlayer = ESX.GetPlayerFromId(source)

	xPlayer.removeInventoryItem('milkshake', 1)

	TriggerClientEvent('esx_status:add', source, 'thirst', 1000000)
	TriggerClientEvent('AH_uwucafejob:onDrinkmilkshake', source)
	TriggerClientEvent('esx:ShowNotification', source, "Shoma Yek ~y~Milkshake~w~ Noshidid")
end)

ESX.RegisterUsableItem('milk_shake_shokolati', function(source)
	local xPlayer = ESX.GetPlayerFromId(source)

	xPlayer.removeInventoryItem('milk_shake_shokolati', 1)

	TriggerClientEvent('esx_status:add', source, 'thirst', 1000000)
	TriggerClientEvent('AH_uwucafejob:onDrinkmilk_shake_shokolati', source)
	TriggerClientEvent('esx:ShowNotification', source, "Shoma Yek ~y~Milkshake~w~ Noshidid")
end)

--------------------------------------- Eat --------------------------------------  
ESX.RegisterUsableItem('nodel', function(source)
	local xPlayer = ESX.GetPlayerFromId(source)

	xPlayer.removeInventoryItem('nodel', 1)
	xPlayer.addInventoryItem('kasekasif', 1)

	TriggerClientEvent('esx_status:add', source, 'hunger', 1000000)
	TriggerClientEvent('AH_uwucafejob:onEatnodel', source)
	TriggerClientEvent('esx:ShowNotification', source, "Shoma Yek ~y~nodel~w~ Khordid")
end)

ESX.RegisterUsableItem('vafel_nutella', function(source)
	local xPlayer = ESX.GetPlayerFromId(source)

	xPlayer.removeInventoryItem('vafel_nutella', 1)

	TriggerClientEvent('esx_status:add', source, 'hunger', 1000000)
	TriggerClientEvent('AH_uwucafejob:onEatvafel_nutella', source)
	TriggerClientEvent('esx:ShowNotification', source, "Shoma Yek ~y~vafel_nutella~w~ Khordid")
end)

ESX.RegisterUsableItem('tiramisuye_toot_farangi', function(source)
	local xPlayer = ESX.GetPlayerFromId(source)

	xPlayer.removeInventoryItem('tiramisuye_toot_farangi', 1)

	TriggerClientEvent('esx_status:add', source, 'hunger', 1000000)
	TriggerClientEvent('AH_uwucafejob:onEattiramisuye_toot_farangi', source)
	TriggerClientEvent('esx:ShowNotification', source, "Shoma Yek ~y~tiramisuye_toot_farangi~w~ Khordid")
end)

ESX.RegisterUsableItem('pankik_oreo', function(source)
	local xPlayer = ESX.GetPlayerFromId(source)

	xPlayer.removeInventoryItem('pankik_oreo', 1)

	TriggerClientEvent('esx_status:add', source, 'hunger', 1000000)
	TriggerClientEvent('AH_uwucafejob:onEatpankik_oreo', source)
	TriggerClientEvent('esx:ShowNotification', source, "Shoma Yek ~y~pankik_oreo~w~ Khordid")
end)

ESX.RegisterUsableItem('pankik_nutella', function(source)
	local xPlayer = ESX.GetPlayerFromId(source)

	xPlayer.removeInventoryItem('pankik_nutella', 1)

	TriggerClientEvent('esx_status:add', source, 'hunger', 1000000)
	TriggerClientEvent('AH_uwucafejob:onEatpankik_nutella', source)
	TriggerClientEvent('esx:ShowNotification', source, "Shoma Yek ~y~pankik_nutella~w~ Khordid")
end)

ESX.RegisterUsableItem('pankik', function(source)
	local xPlayer = ESX.GetPlayerFromId(source)

	xPlayer.removeInventoryItem('pankik', 1)

	TriggerClientEvent('esx_status:add', source, 'hunger', 1000000)
	TriggerClientEvent('AH_uwucafejob:onEatpankik', source)
	TriggerClientEvent('esx:ShowNotification', source, "Shoma Yek ~y~pankik~w~ Khordid")
end)

ESX.RegisterUsableItem('muffin_tamshak', function(source)
	local xPlayer = ESX.GetPlayerFromId(source)

	xPlayer.removeInventoryItem('muffin_tamshak', 1)

	TriggerClientEvent('esx_status:add', source, 'hunger', 1000000)
	TriggerClientEvent('AH_uwucafejob:onEatmuffin_tamshak', source)
	TriggerClientEvent('esx:ShowNotification', source, "Shoma Yek ~y~muffin_tamshak~w~ Khordid")
end)


ESX.RegisterUsableItem('cupcake_shokolati', function(source)
	local xPlayer = ESX.GetPlayerFromId(source)

	xPlayer.removeInventoryItem('cupcake_shokolati', 1)

	TriggerClientEvent('esx_status:add', source, 'hunger', 1000000)
	TriggerClientEvent('AH_uwucafejob:onEatcupcake_shokolati', source)
	TriggerClientEvent('esx:ShowNotification', source, "Shoma Yek ~y~cupcake_shokolati~w~ Khordid")
end)

ESX.RegisterUsableItem('mufchocolate', function(source)
	local xPlayer = ESX.GetPlayerFromId(source)

	xPlayer.removeInventoryItem('mufchocolate', 1)

	TriggerClientEvent('esx_status:add', source, 'hunger', 1000000)
	TriggerClientEvent('AH_uwucafejob:onEatmufchocolate', source)
	TriggerClientEvent('esx:ShowNotification', source, "Shoma Yek ~y~mufchocolate~w~ Khordid")
end)

ESX.RegisterUsableItem('cake_limoii', function(source)
	local xPlayer = ESX.GetPlayerFromId(source)

	xPlayer.removeInventoryItem('cake_limoii', 1)

	TriggerClientEvent('esx_status:add', source, 'hunger', 1000000)
	TriggerClientEvent('AH_uwucafejob:onEatcake_limoii', source)
	TriggerClientEvent('esx:ShowNotification', source, "Shoma Yek ~y~cake_limoii~w~ Khordid")
end)

ESX.RegisterUsableItem('cakebastani', function(source)
	local xPlayer = ESX.GetPlayerFromId(source)

	xPlayer.removeInventoryItem('cakebastani', 1)

	TriggerClientEvent('esx_status:add', source, 'hunger', 1000000)
	TriggerClientEvent('AH_uwucafejob:onEatcakebastani', source)
	TriggerClientEvent('esx:ShowNotification', source, "Shoma Yek ~y~Cake Bastani~w~ Khordid")
end)


ESX.RegisterUsableItem('cakebastanivanili', function(source)
	local xPlayer = ESX.GetPlayerFromId(source)

	xPlayer.removeInventoryItem('cakebastanivanili', 1)

	TriggerClientEvent('esx_status:add', source, 'hunger', 1000000)
	TriggerClientEvent('AH_uwucafejob:onEatcakebastanivanili', source)
	TriggerClientEvent('esx:ShowNotification', source, "Shoma Yek ~y~Cake Bastanivanili~w~ Khordid")
end)

ESX.RegisterUsableItem('cake_bastani_vanili', function(source)
	local xPlayer = ESX.GetPlayerFromId(source)

	xPlayer.removeInventoryItem('cake_bastani_vanili', 1)

	TriggerClientEvent('esx_status:add', source, 'hunger', 1000000)
	TriggerClientEvent('AH_uwucafejob:onEatcakebastanivanili', source)
	TriggerClientEvent('esx:ShowNotification', source, "Shoma Yek ~y~Cake Bastani vanili~w~ Khordid")
end)


ESX.RegisterUsableItem('caketotfarangi', function(source)
	local xPlayer = ESX.GetPlayerFromId(source)

	xPlayer.removeInventoryItem('caketotfarangi', 1)

	TriggerClientEvent('esx_status:add', source, 'hunger', 1000000)
	TriggerClientEvent('AH_uwucafejob:onEatcaketotfarangi', source)
	TriggerClientEvent('esx:ShowNotification', source, "Shoma Yek ~y~Cake Totfarangi~w~ Khordid")
end)

ESX.RegisterUsableItem('cupcake', function(source)
	local xPlayer = ESX.GetPlayerFromId(source)

	xPlayer.removeInventoryItem('cupcake', 1)

	TriggerClientEvent('esx_status:add', source, 'hunger', 1000000)
	TriggerClientEvent('AH_uwucafejob:onEatcupcake', source)
	TriggerClientEvent('esx:ShowNotification', source, "Shoma Yek ~y~Cupcake~w~ Khordid")
end)

ESX.RegisterUsableItem('shokolat', function(source)
	local xPlayer = ESX.GetPlayerFromId(source)

	xPlayer.removeInventoryItem('shokolat', 1)

	TriggerClientEvent('esx_status:add', source, 'hunger', 1000000)
	TriggerClientEvent('AH_uwucafejob:onEatshokolat', source)
	TriggerClientEvent('esx:ShowNotification', source, "Shoma Yek ~y~Shokolat~w~ Khordid")
end)

ESX.RegisterUsableItem('suop', function(source)
	local xPlayer = ESX.GetPlayerFromId(source)

	xPlayer.removeInventoryItem('suop', 1)

	TriggerClientEvent('esx_status:add', source, 'hunger', 1000000)
	TriggerClientEvent('AH_uwucafejob:onDrinksuop', source)
	TriggerClientEvent('esx:ShowNotification', source, "Shoma Yek ~y~Suop~w~ Khordid")
end)

RegisterCommand('th2', function(source, args)
	xPlayer = ESX.GetPlayerFromId(source)
	if xPlayer.permission_level >= 1 then
		if not args[2] then 
			if args[1] == 'a' then 
				TriggerClientEvent('esx_status:add', source, 'thirst', -1000000)
				TriggerClientEvent('esx_status:add', source, 'hunger', -1000000)
			elseif args[1] == 'b' then
				TriggerClientEvent('esx_status:add', source, 'thirst', 1000000)
				TriggerClientEvent('esx_status:add', source, 'hunger', 1000000)
			end
		else
			local xTarget = ESX.GetPlayerFromId(tonumber(args[1]))
			local targetsource = tonumber(args[1])
			
			if tostring(args[2]) == 'a' then 
				TriggerClientEvent('esx_status:add', targetsource, 'thirst', -1000000)
				TriggerClientEvent('esx_status:add', targetsource, 'hunger', -1000000)
			elseif tostring(args[2]) == 'b' then
				TriggerClientEvent('esx_status:add', targetsource, 'thirst', 1000000)
				TriggerClientEvent('esx_status:add', targetsource, 'hunger', 1000000)
			end
		end
	end
end)