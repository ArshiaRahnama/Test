-- Modern showroom - esx_heli server side
-- Same "never trust a client-sent price" rule as esx_vehicleshop/server/shop_nui.lua:
-- the client sends a model + plate, the price always comes from Config.Vehicles here.

RegisterServerEvent('esx_heli:completePurchase')
AddEventHandler('esx_heli:completePurchase', function(vehicleProps)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	if not xPlayer then return end

	-- vehicleProps.model is a model hash here (ESX.Game.GetVehicleProperties), so match
	-- it against Config.Vehicles by hash rather than by name.
	local vehicleData = nil
	for i = 1, #Config.Vehicles, 1 do
		if GetHashKey(Config.Vehicles[i].model) == vehicleProps.model then
			vehicleData = Config.Vehicles[i]
			break
		end
	end

	if not vehicleData then
		TriggerClientEvent('esx_heli:purchaseFailed', _source, 'invalid_vehicle')
		return
	end

	if not xPlayer.canAfford(vehicleData.price) then
		TriggerClientEvent('esx_heli:purchaseFailed', _source, 'not_enough_money')
		return
	end

	xPlayer.payAny(vehicleData.price)

	MySQL.Async.execute('INSERT INTO owned_vehicles (owner, plate, vehicle, type, `stored`) VALUES (@owner, @plate, @vehicle, @type, @stored)', {
		['@owner']   = xPlayer.identifier,
		['@plate']   = vehicleProps.plate,
		['@vehicle'] = json.encode(vehicleProps),
		['@type']    = 'heli',
		['@stored']  = false,
	})

	TriggerClientEvent('esx_heli:purchaseSucceeded', _source, vehicleData.label, vehicleData.price)

	TriggerEvent('DiscordBot:ToDiscord', 'buycar', 'Buy Air', ('```css\nHeli Buy\nPlayer : %s\nHeli : %s\nPrice : $%s\nPlate : %s```'):format(xPlayer.name, vehicleData.label, vehicleData.price, vehicleProps.plate), 'user', true, _source, false)
end)
