-- Modern showroom - server side
-- Everything that touches money or the database for the new NUI shop lives here.
-- Rule followed throughout: the client may send a vehicle MODEL, a PLATE, or a choice
-- of payment method - never a price. Every price is looked up fresh from the `vehicles`
-- table on this side, so a modified client can never buy a car for less than its listed price.

local ShopNUI = {}

local function GetVehicleRow(model)
	local rows = MySQL.Sync.fetchAll('SELECT * FROM vehicles WHERE model = @model LIMIT 1', {
		['@model'] = model
	})
	return rows[1]
end

-- Computes what a purchase would actually cost right now: catalog price, trade-in
-- credit (if the plate given is really a stored vehicle owned by this player), and,
-- for financing, the down payment / installment breakdown. Nothing here charges money -
-- it's read-only, used both to show the player a quote and to validate a real purchase.
function ShopNUI.BuildQuote(xPlayer, vehicleModel, tradeInPlate)
	local vehicleRow = GetVehicleRow(vehicleModel)
	if not vehicleRow then
		return nil, 'invalid_vehicle'
	end

	local price        = tonumber(vehicleRow.price)
	local tradeInValue = 0
	local tradeInVehicle = nil

	if Config.TradeIn.Enable and tradeInPlate and tradeInPlate ~= '' then
		local ownedRows = MySQL.Sync.fetchAll('SELECT * FROM owned_vehicles WHERE plate = @plate AND owner = @owner AND stored = 1 LIMIT 1', {
			['@plate'] = tradeInPlate,
			['@owner'] = xPlayer.identifier
		})

		if ownedRows[1] then
			local ok, decoded = pcall(json.decode, ownedRows[1].vehicle)

			if ok and decoded and decoded.model then
				local tradeRow = MySQL.Sync.fetchAll('SELECT * FROM vehicles WHERE model = @model LIMIT 1', {
					['@model'] = decoded.model
				})[1]

				if tradeRow then
					tradeInValue   = ESX.Math.Round(tonumber(tradeRow.price) * (Config.TradeIn.PayoutPercent / 100))
					tradeInVehicle = { plate = tradeInPlate, name = tradeRow.name, value = tradeInValue }
				end
			end
		end
	end

	local effectivePrice = math.max(price - tradeInValue, 0)

	local quote = {
		model           = vehicleModel,
		name            = vehicleRow.name,
		price           = price,
		tradeIn         = tradeInVehicle,
		effectivePrice  = effectivePrice,
		canAffordFull   = xPlayer.canAfford(effectivePrice),
	}

	if Config.Financing.Enable then
		local downPayment    = ESX.Math.Round(effectivePrice * (Config.Financing.MinDownPaymentPercent / 100))
		local totalWithInterest = ESX.Math.Round(effectivePrice * (1 + (Config.Financing.InterestPercent / 100)))
		local remaining      = math.max(totalWithInterest - downPayment, 0)
		local installments    = math.max(Config.Financing.Installments, 1)
		local installmentAmount = math.ceil(remaining / installments)

		quote.financing = {
			downPayment       = downPayment,
			totalWithInterest = totalWithInterest,
			installmentAmount = installmentAmount,
			installments      = installments,
			canAffordDown     = xPlayer.canAfford(downPayment),
		}
	end

	return quote
end

ESX.RegisterServerCallback('esx_vehicleshop:getShowroomData', function(source, cb)
	local xPlayer = ESX.GetPlayerFromId(source)
	if not xPlayer then return cb(nil) end

	local categories = MySQL.Sync.fetchAll('SELECT * FROM vehicle_categories', {})
	local vehicles    = MySQL.Sync.fetchAll('SELECT * FROM vehicles', {})

	local ownedForTradeIn = {}
	if Config.TradeIn.Enable then
		local owned = MySQL.Sync.fetchAll('SELECT * FROM owned_vehicles WHERE owner = @owner AND stored = 1 AND (job IS NULL OR job = \'\')', {
			['@owner'] = xPlayer.identifier
		})

		for i = 1, #owned, 1 do
			local ok, decoded = pcall(json.decode, owned[i].vehicle)
			if ok and decoded and decoded.model then
				local row = GetVehicleRow(decoded.model)
				table.insert(ownedForTradeIn, {
					plate = owned[i].plate,
					name  = row and row.name or decoded.model,
				})
			end
		end
	end

	cb({
		categories   = categories,
		vehicles     = vehicles,
		cash         = xPlayer.getMoney and xPlayer.getMoney() or xPlayer.money,
		bank         = (xPlayer.getAccount and xPlayer.getAccount('bank') and xPlayer.getAccount('bank').money) or xPlayer.bank,
		ownedVehicles = ownedForTradeIn,
		config = {
			testDrive = Config.TestDrive,
			financing = Config.Financing,
			tradeIn   = Config.TradeIn,
		}
	})
end)

ESX.RegisterServerCallback('esx_vehicleshop:getQuote', function(source, cb, vehicleModel, tradeInPlate)
	local xPlayer = ESX.GetPlayerFromId(source)
	if not xPlayer then return cb(nil) end

	local quote, err = ShopNUI.BuildQuote(xPlayer, vehicleModel, tradeInPlate)
	if not quote then
		return cb(nil, err)
	end

	cb(quote)
end)

-- Client has already spawned the real vehicle and generated its plate (same flow the
-- original script used) - this finishes the sale: re-checks the price, charges the
-- player, removes the traded-in vehicle, writes the owned_vehicles row and, for
-- financed purchases, opens a loan.
RegisterServerEvent('esx_vehicleshop:completePurchase')
AddEventHandler('esx_vehicleshop:completePurchase', function(vehicleProps, paymentMethod, tradeInPlate, buyForGang)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	if not xPlayer then return end

	local quote, err = ShopNUI.BuildQuote(xPlayer, vehicleProps.model, tradeInPlate)

	if not quote then
		TriggerClientEvent('esx_vehicleshop:purchaseFailed', _source, err or 'invalid_vehicle')
		TriggerClientEvent('esx:deleteVehicle', _source)
		return
	end

	if buyForGang and (not xPlayer.gang or xPlayer.gang.name == 'nogang') then
		TriggerClientEvent('esx_vehicleshop:purchaseFailed', _source, 'no_gang')
		TriggerClientEvent('esx:deleteVehicle', _source)
		return
	end

	local owner = buyForGang and xPlayer.gang.name or xPlayer.identifier
	local job   = buyForGang and 'gang' or ''

	local function InsertOwnedVehicle()
		MySQL.Async.execute('INSERT IGNORE INTO owned_vehicles (owner, plate, vehicle, job, type, stored, engine, fuel, body) VALUES (@owner, @plate, @vehicle, @job, @type, @stored, @engine, @fuel, @body)', {
			['@owner']   = owner,
			['@plate']   = vehicleProps.plate,
			['@vehicle'] = json.encode(vehicleProps),
			['@job']     = job,
			['@type']    = 'car',
			['@stored']  = 1,
			['@engine']  = 1000,
			['@fuel']    = 100,
			['@body']    = 1000,
		})

		if quote.tradeIn then
			MySQL.Async.execute('DELETE FROM owned_vehicles WHERE plate = @plate AND owner = @owner', {
				['@plate'] = quote.tradeIn.plate,
				['@owner'] = xPlayer.identifier
			})
		end

		TriggerEvent('DiscordBot:ToDiscord', 'buycar', 'Buy Car', ('```css\nVehicle Buy (%s)\nPlayer : %s\nVehicle Name : %s\nPrice : $%s\nTrade-in : %s\nPlate : %s```'):format(
			paymentMethod, xPlayer.name, quote.name, quote.effectivePrice,
			quote.tradeIn and (quote.tradeIn.name .. ' (-$' .. quote.tradeIn.value .. ')') or 'none',
			vehicleProps.plate
		), 'user', true, _source, false)
	end

	if paymentMethod == 'finance' and Config.Financing.Enable then
		local f = quote.financing

		if not f or not xPlayer.canAfford(f.downPayment) then
			TriggerClientEvent('esx_vehicleshop:purchaseFailed', _source, 'not_enough_money')
			TriggerClientEvent('esx:deleteVehicle', _source)
			return
		end

		xPlayer.payAny(f.downPayment)
		InsertOwnedVehicle()

		MySQL.Async.execute('INSERT INTO vehicleshop_financing (owner, plate, vehicle_name, total_price, remaining_balance, installment_amount, installments_left, next_due) VALUES (@owner, @plate, @vehicle_name, @total_price, @remaining_balance, @installment_amount, @installments_left, DATE_ADD(NOW(), INTERVAL @hours HOUR))', {
			['@owner']              = xPlayer.identifier,
			['@plate']              = vehicleProps.plate,
			['@vehicle_name']       = quote.name,
			['@total_price']        = f.totalWithInterest,
			['@remaining_balance']  = f.totalWithInterest - f.downPayment,
			['@installment_amount'] = f.installmentAmount,
			['@installments_left']  = f.installments,
			['@hours']              = Config.Financing.PaymentIntervalHours,
		})

		TriggerClientEvent('esx_vehicleshop:purchaseSucceeded', _source, quote, 'finance')
	else
		if not xPlayer.canAfford(quote.effectivePrice) then
			TriggerClientEvent('esx_vehicleshop:purchaseFailed', _source, 'not_enough_money')
			TriggerClientEvent('esx:deleteVehicle', _source)
			return
		end

		xPlayer.payAny(quote.effectivePrice)
		InsertOwnedVehicle()

		TriggerClientEvent('esx_vehicleshop:purchaseSucceeded', _source, quote, 'full')
	end
end)

-- Installment billing - checked periodically rather than depending on any external
-- cron resource, so this file works on its own.
local function BillFinancing()
	local dueRows = MySQL.Sync.fetchAll('SELECT * FROM vehicleshop_financing WHERE next_due <= NOW() AND installments_left > 0', {})

	for i = 1, #dueRows, 1 do
		local loan    = dueRows[i]
		local xPlayer = ESX.GetPlayerFromIdentifier(loan.owner)

		if xPlayer and xPlayer.canAfford and xPlayer.getAccount('bank').money >= loan.installment_amount then
			xPlayer.removeBank(loan.installment_amount)

			local installmentsLeft = loan.installments_left - 1
			if installmentsLeft <= 0 then
				MySQL.Async.execute('DELETE FROM vehicleshop_financing WHERE id = @id', { ['@id'] = loan.id })
				TriggerClientEvent('esx:showNotification', xPlayer.source, ('قسط ماشین %s تسویه شد، ماشین کاملاً مال شماست.'):format(loan.vehicle_name))
			else
				MySQL.Async.execute('UPDATE vehicleshop_financing SET installments_left = @left, remaining_balance = remaining_balance - @amount, missed_payments = 0, next_due = DATE_ADD(NOW(), INTERVAL @hours HOUR) WHERE id = @id', {
					['@left']   = installmentsLeft,
					['@amount'] = loan.installment_amount,
					['@hours']  = Config.Financing.PaymentIntervalHours,
					['@id']     = loan.id,
				})
				TriggerClientEvent('esx:showNotification', xPlayer.source, ('قسط %s تومان ماشین %s کسر شد. %s قسط باقیست.'):format(ESX.Math.GroupDigits(loan.installment_amount), loan.vehicle_name, installmentsLeft))
			end
		else
			local missed = loan.missed_payments + 1

			if missed >= Config.Financing.MaxMissedPayments then
				MySQL.Async.execute('DELETE FROM owned_vehicles WHERE plate = @plate', { ['@plate'] = loan.plate })
				MySQL.Async.execute('DELETE FROM vehicleshop_financing WHERE id = @id', { ['@id'] = loan.id })

				if xPlayer then
					TriggerClientEvent('esx:showNotification', xPlayer.source, ('به‌خاطر عقب‌افتادن اقساط، ماشین %s توسط نمایندگی ضبط شد.'):format(loan.vehicle_name))
				end

				TriggerEvent('DiscordBot:ToDiscord', 'buycar', 'Vehicle Repossessed', ('```css\nRepossessed\nOwner : %s\nVehicle : %s\nPlate : %s```'):format(loan.owner, loan.vehicle_name, loan.plate), 'user', true, nil, false)
			else
				MySQL.Async.execute('UPDATE vehicleshop_financing SET missed_payments = @missed, next_due = DATE_ADD(NOW(), INTERVAL @hours HOUR) WHERE id = @id', {
					['@missed'] = missed,
					['@hours']  = Config.Financing.PaymentIntervalHours,
					['@id']     = loan.id,
				})

				if xPlayer then
					TriggerClientEvent('esx:showNotification', xPlayer.source, ('موجودی بانکتون برای قسط ماشین %s کافی نبود. (%s/%s اخطار)'):format(loan.vehicle_name, missed, Config.Financing.MaxMissedPayments))
				end
			end
		end
	end
end

if Config.Financing.Enable then
	Citizen.CreateThread(function()
		while true do
			Citizen.Wait(Config.Financing.CheckIntervalMinutes * 60 * 1000)
			BillFinancing()
		end
	end)
end
