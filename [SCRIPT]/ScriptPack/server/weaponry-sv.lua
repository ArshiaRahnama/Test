ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

ESX.RegisterUsableItem('lsd', function(source)
	local xPlayer = ESX.GetPlayerFromId(source)
	TriggerClientEvent('weaponry:UseLsd', source)
end)

RegisterNetEvent("weaponry:DeleteLsd")
AddEventHandler("weaponry:DeleteLsd", function()
	local xPlayer = ESX.GetPlayerFromId(source)
	xPlayer.removeInventoryItem('lsd', 1)
end)

