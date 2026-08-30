if Config.UseESX then
	local ESX = nil
	TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

	-- SECURITY FIX: `price` came straight from the client (accumulated
	-- purely client-side while pumping) with no server-side floor or
	-- ceiling, so a modified client could send price = 0.01 and fill up
	-- almost for free. There's no per-liter rate tracked server-side to
	-- validate exactly, so this bounds it instead: positive, and no higher
	-- than a generous full-tank estimate (3x a jerry can's cost, the only
	-- real price reference this resource has).
	local MaxFuelPay = (Config.JerryCanCost or 2000) * 3

	RegisterServerEvent('fuel:pay')
	AddEventHandler('fuel:pay', function(price)
		local xPlayer = ESX.GetPlayerFromId(source)
		if not xPlayer then return end
		local amount = ESX.Math.Round(tonumber(price) or 0)
		if amount > MaxFuelPay then amount = MaxFuelPay end
		if amount > 0 and xPlayer.canAfford(amount) then
			xPlayer.payAny(amount)
		end
	end)
end
