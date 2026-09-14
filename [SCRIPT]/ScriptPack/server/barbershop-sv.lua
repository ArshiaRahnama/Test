ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

RegisterServerEvent('esx_barbershop:pay')
AddEventHandler('esx_barbershop:pay', function()

	local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)

	if not xPlayer.canAfford(Config.Price) then
		TriggerClientEvent('esx:showNotification', source, "Pool Kafi Nadarid!")
		return
	end

	xPlayer.payAny(Config.Price)

	TriggerClientEvent('esx:showNotification', source, "Shoma Mablagh ~g~" .. '$' .. Config.Price.. "~0~ Pardakhtid!")

end)

ESX.RegisterServerCallback('esx_barbershop:checkMoney', function(source, cb)

	local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)

	cb(xPlayer.canAfford(Config.Price))

end)
