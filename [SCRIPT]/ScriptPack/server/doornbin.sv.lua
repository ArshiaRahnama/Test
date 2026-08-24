
ESX = nil
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

ESX.RegisterUsableItem('jumelles', function(source)

	local xPlayer = ESX.GetPlayerFromId(source)

	TriggerClientEvent('jumelles:Active', source)

end)