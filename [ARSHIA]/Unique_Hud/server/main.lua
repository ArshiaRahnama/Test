-- ============================================================
-- Unique_Hud / server / main.lua  (status ادغام شد)
-- ============================================================

ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

ESX.RegisterServerCallback('reloaddata', function(source, cb)
	local xPlayer = ESX.GetPlayerFromId(source)

	if xPlayer then
		if ESX.ServerCallbacks['Coin-System:GetCoin'] then
			ESX.ServerCallbacks['Coin-System:GetCoin'](source, function(coinAmount)
				xPlayer.coin = coinAmount or 0
				cb(xPlayer)
			end)
		else
			xPlayer.coin = 0
			cb(xPlayer)
		end
	end
end)
