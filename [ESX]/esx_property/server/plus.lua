-- ============================================================
--  esx_property PLUS — server
-- ============================================================

local function getOwnedRow(name, owner, cb)
	MySQL.Async.fetchAll('SELECT * FROM owned_properties WHERE name = @name AND owner = @owner LIMIT 1', {
		['@name']  = name,
		['@owner'] = owner
	}, function(rows)
		cb(rows[1])
	end)
end

-- ---------------------------------------------------------
-- ارتقای انبار
-- ---------------------------------------------------------
RegisterServerEvent('esx_property:plus:upgradeStorage')
AddEventHandler('esx_property:plus:upgradeStorage', function(propertyName)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	if not xPlayer then return end

	getOwnedRow(propertyName, xPlayer.identifier, function(row)
		if not row then
			TriggerClientEvent('esx:showNotification', _source, 'این خونه مال تو نیست')
			return
		end

		local nextLevel = (row.storage_level or 1) + 1
		local tier      = ConfigPlus.StorageTiers[nextLevel]

		if not tier then
			TriggerClientEvent('esx:showNotification', _source, 'انبار در بالاترین سطحه')
			return
		end

		if xPlayer.canAfford(tier.price) then
			xPlayer.payAny(tier.price)

			MySQL.Async.execute('UPDATE owned_properties SET storage_level = @lvl WHERE name = @name AND owner = @owner', {
				['@lvl']    = nextLevel,
				['@name']   = propertyName,
				['@owner']  = xPlayer.identifier
			}, function()
				TriggerClientEvent('esx:showNotification', _source, ('انبار به سطح %s ارتقا پیدا کرد'):format(tier.label))
				TriggerClientEvent('esx_property:plus:syncLevels', _source, propertyName, nextLevel, row.safe_level or 1)
			end)
		else
			TriggerClientEvent('esx:showNotification', _source, 'پول کافی نداری')
		end
	end)
end)

-- ---------------------------------------------------------
-- ارتقای گاوصندوق
-- ---------------------------------------------------------
RegisterServerEvent('esx_property:plus:upgradeSafe')
AddEventHandler('esx_property:plus:upgradeSafe', function(propertyName)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	if not xPlayer then return end

	getOwnedRow(propertyName, xPlayer.identifier, function(row)
		if not row then
			TriggerClientEvent('esx:showNotification', _source, 'این خونه مال تو نیست')
			return
		end

		local nextLevel = (row.safe_level or 1) + 1
		local tier      = ConfigPlus.SafeTiers[nextLevel]

		if not tier then
			TriggerClientEvent('esx:showNotification', _source, 'گاوصندوق در بالاترین سطحه')
			return
		end

		if xPlayer.canAfford(tier.price) then
			xPlayer.payAny(tier.price)

			MySQL.Async.execute('UPDATE owned_properties SET safe_level = @lvl WHERE name = @name AND owner = @owner', {
				['@lvl']   = nextLevel,
				['@name']  = propertyName,
				['@owner'] = xPlayer.identifier
			}, function()
				TriggerClientEvent('esx:showNotification', _source, ('گاوصندوق به سطح %s ارتقا پیدا کرد'):format(tier.label))
				TriggerClientEvent('esx_property:plus:syncLevels', _source, propertyName, row.storage_level or 1, nextLevel)
			end)
		else
			TriggerClientEvent('esx:showNotification', _source, 'پول کافی نداری')
		end
	end)
end)

ESX.RegisterServerCallback('esx_property:plus:getLevels', function(source, cb, propertyName)
	local xPlayer = ESX.GetPlayerFromId(source)
	if not xPlayer then cb(nil) return end

	getOwnedRow(propertyName, xPlayer.identifier, function(row)
		if not row then cb(nil) return end
		cb({storage_level = row.storage_level or 1, safe_level = row.safe_level or 1})
	end)
end)

-- ---------------------------------------------------------
-- بازار بین بازیکن‌ها
-- ---------------------------------------------------------
RegisterServerEvent('esx_property:plus:listForSale')
AddEventHandler('esx_property:plus:listForSale', function(propertyName, price)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	price = tonumber(price)

	if not xPlayer or not price or price <= 0 then return end

	MySQL.Async.execute('UPDATE owned_properties SET for_sale = 1, sale_price = @price WHERE name = @name AND owner = @owner', {
		['@price'] = price,
		['@name']  = propertyName,
		['@owner'] = xPlayer.identifier
	}, function(rows)
		if rows > 0 then
			TriggerClientEvent('esx:showNotification', _source, ('خونه با قیمت %s$ برای فروش گذاشته شد'):format(ESX.Math.GroupDigits(price)))
		end
	end)
end)

RegisterServerEvent('esx_property:plus:unlistForSale')
AddEventHandler('esx_property:plus:unlistForSale', function(propertyName)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	if not xPlayer then return end

	MySQL.Async.execute('UPDATE owned_properties SET for_sale = 0, sale_price = 0 WHERE name = @name AND owner = @owner', {
		['@name']  = propertyName,
		['@owner'] = xPlayer.identifier
	}, function()
		TriggerClientEvent('esx:showNotification', _source, 'آگهی فروش لغو شد')
	end)
end)

ESX.RegisterServerCallback('esx_property:plus:getMarketListing', function(source, cb, propertyName)
	MySQL.Async.fetchAll('SELECT owner, sale_price FROM owned_properties WHERE name = @name AND for_sale = 1 LIMIT 1', {
		['@name'] = propertyName
	}, function(rows)
		cb(rows[1])
	end)
end)

RegisterServerEvent('esx_property:plus:buyFromPlayer')
AddEventHandler('esx_property:plus:buyFromPlayer', function(propertyName)
	local _source = source
	local buyer   = ESX.GetPlayerFromId(_source)
	if not buyer then return end

	MySQL.Async.fetchAll('SELECT * FROM owned_properties WHERE name = @name AND for_sale = 1 LIMIT 1', {
		['@name'] = propertyName
	}, function(rows)
		local listing = rows[1]
		if not listing then
			TriggerClientEvent('esx:showNotification', _source, 'این خونه دیگه برای فروش نیست')
			return
		end

		if listing.owner == buyer.identifier then
			TriggerClientEvent('esx:showNotification', _source, 'نمی‌تونی خونه‌ی خودتو بخری')
			return
		end

		if not buyer.canAfford(listing.sale_price) then
			TriggerClientEvent('esx:showNotification', _source, 'پول کافی نداری')
			return
		end

		local fee        = math.floor(listing.sale_price * (ConfigPlus.Market.feePercent / 100))
		local sellerGets  = listing.sale_price - fee
		local sellerXPlayer = ESX.GetPlayerFromIdentifier(listing.owner)

		buyer.payAny(listing.sale_price)

		if sellerXPlayer then
			sellerXPlayer.addAccountMoney('bank', sellerGets)
			TriggerClientEvent('esx:showNotification', sellerXPlayer.source, ('خونه‌ت رو %s$ فروختی (پس از کارمزد)'):format(ESX.Math.GroupDigits(sellerGets)))
			TriggerClientEvent('esx_property:setPropertyOwned', sellerXPlayer.source, propertyName, false)
		else
			-- فروشنده آفلاینه، پول بعداً باید دستی/آفلاین واریز بشه یا سیستم mail بانکی اضافه کن
			MySQL.Async.execute('UPDATE bank_accounts SET money = money + @amount WHERE identifier = @identifier', {
				['@amount']     = sellerGets,
				['@identifier'] = listing.owner
			})
		end

		MySQL.Async.execute('UPDATE owned_properties SET owner = @newOwner, for_sale = 0, sale_price = 0 WHERE name = @name', {
			['@newOwner'] = buyer.identifier,
			['@name']     = propertyName
		}, function()
			TriggerClientEvent('esx:showNotification', _source, 'خونه با موفقیت خریداری شد')
			TriggerClientEvent('esx_property:setPropertyOwned', _source, propertyName, true)
		end)
	end)
end)

-- ---------------------------------------------------------
-- اقساط / رهن
-- ---------------------------------------------------------
RegisterServerEvent('esx_property:plus:buyMortgage')
AddEventHandler('esx_property:plus:buyMortgage', function(propertyName, storageData)
	if not ConfigPlus.Mortgage.enabled then return end

	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	local property = GetProperty(propertyName)
	if not xPlayer or not property then return end

	local down = math.floor(property.price * (ConfigPlus.Mortgage.downPaymentPercent / 100))

	if not xPlayer.canAfford(down) then
		TriggerClientEvent('esx:showNotification', _source, 'پیش‌پرداخت کافی نداری')
		return
	end

	xPlayer.payAny(down)

	local remainingBase = property.price - down
	local remaining     = math.floor(remainingBase * (1 + (ConfigPlus.Mortgage.interestPercent / 100)))
	local installment    = math.ceil(remaining / ConfigPlus.Mortgage.installmentDays)

	MySQL.Async.execute([[
		INSERT INTO owned_properties
			(name, price, rented, owner, storage_data, mortgage_active, mortgage_remaining, mortgage_installment, mortgage_days_left)
		VALUES
			(@name, @price, 0, @owner, @storage_data, 1, @remaining, @installment, @days)
	]], {
		['@name']         = propertyName,
		['@price']        = property.price,
		['@owner']        = xPlayer.identifier,
		['@storage_data'] = storageData,
		['@remaining']    = remaining,
		['@installment']  = installment,
		['@days']         = ConfigPlus.Mortgage.installmentDays
	}, function()
		TriggerClientEvent('esx_property:setPropertyOwned', _source, propertyName, true)
		TriggerClientEvent('esx:showNotification', _source, ('خونه با رهن خریداری شد. قسط روزانه: %s$'):format(ESX.Math.GroupDigits(installment)))
	end)
end)

function PayMortgages()
	MySQL.Async.fetchAll('SELECT * FROM owned_properties WHERE mortgage_active = 1 AND mortgage_remaining > 0', {}, function(result)
		for i = 1, #result, 1 do
			local row     = result[i]
			local xPlayer = ESX.GetPlayerFromIdentifier(row.owner)
			local charge  = math.min(row.mortgage_installment, row.mortgage_remaining)

			if xPlayer and xPlayer.getAccount('bank').money >= charge then
				xPlayer.removeAccountMoney('bank', charge)

				local newRemaining = row.mortgage_remaining - charge
				local newActive    = newRemaining > 0 and 1 or 0

				MySQL.Async.execute('UPDATE owned_properties SET mortgage_remaining = @rem, mortgage_active = @active WHERE id = @id', {
					['@rem']    = newRemaining,
					['@active'] = newActive,
					['@id']     = row.id
				})

				if newRemaining <= 0 then
					TriggerClientEvent('esx:showNotification', xPlayer.source, 'تبریک! خونه‌ت کاملاً تسویه شد و الان مالک صد در صدیشی')
				else
					TriggerClientEvent('esx:showNotification', xPlayer.source, ('قسط خونه %s$ کسر شد'):format(ESX.Math.GroupDigits(charge)))
				end
			elseif xPlayer then
				TriggerClientEvent('esx:showNotification', xPlayer.source, 'موجودی بانکت برای قسط خونه کافی نبود، سررسید بعدی دوباره تلاش میشه')
			end
			-- توجه: در این نسخه در صورت عدم پرداخت مکرر، خونه ضبط نمیشه.
			-- اگه خواستی می‌تونیم شمارنده‌ی "عقب‌افتادگی" و ضبط خونه بعد از N بار رو هم اضافه کنیم.
		end
	end)
end

TriggerEvent('cron:runAt', 21, 0, PayMortgages)

-- ---------------------------------------------------------
-- وضعیت همه‌ی ملک‌ها (برای رنگ بلیپ/مارکر و تکست سه‌بعدی)
-- ---------------------------------------------------------
ESX.RegisterServerCallback('esx_property:plus:getStatuses', function(source, cb)
	MySQL.Async.fetchAll('SELECT name, owner, for_sale, sale_price FROM owned_properties', {}, function(rows)
		cb(rows)
	end)
end)

-- ---------------------------------------------------------
-- فرنیچر
-- ---------------------------------------------------------
ESX.RegisterServerCallback('esx_property:plus:getFurniture', function(source, cb, propertyName)
	MySQL.Async.fetchAll('SELECT * FROM property_furniture WHERE property = @property', {
		['@property'] = propertyName
	}, function(rows)
		cb(rows)
	end)
end)

RegisterServerEvent('esx_property:plus:buyFurniture')
AddEventHandler('esx_property:plus:buyFurniture', function(propertyName, catalogIndex)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	local item    = ConfigPlus.FurnitureCatalog[catalogIndex]
	if not xPlayer or not item then return end

	getOwnedRow(propertyName, xPlayer.identifier, function(row)
		if not row then
			TriggerClientEvent('esx:showNotification', _source, 'این خونه مال تو نیست')
			return
		end

		MySQL.Async.fetchAll('SELECT COUNT(*) as cnt FROM property_furniture WHERE property = @property', {
			['@property'] = propertyName
		}, function(cntRows)
			if cntRows[1].cnt >= ConfigPlus.MaxFurniturePerProperty then
				TriggerClientEvent('esx:showNotification', _source, 'به سقف تعداد فرنیچر این خونه رسیدی')
				return
			end

			if not xPlayer.canAfford(item.price) then
				TriggerClientEvent('esx:showNotification', _source, 'پول کافی نداری')
				return
			end

			xPlayer.payAny(item.price)
			TriggerClientEvent('esx_property:plus:startPlacement', _source, propertyName, item.model, catalogIndex)
		end)
	end)
end)

RegisterServerEvent('esx_property:plus:saveFurniture')
AddEventHandler('esx_property:plus:saveFurniture', function(propertyName, model, x, y, z, heading, scale)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	if not xPlayer then return end

	getOwnedRow(propertyName, xPlayer.identifier, function(row)
		if not row then return end

		MySQL.Async.execute([[
			INSERT INTO property_furniture (property, owner, model, x, y, z, heading, scale)
			VALUES (@property, @owner, @model, @x, @y, @z, @heading, @scale)
		]], {
			['@property'] = propertyName,
			['@owner']    = xPlayer.identifier,
			['@model']    = model,
			['@x']        = x,
			['@y']        = y,
			['@z']        = z,
			['@heading']  = heading,
			['@scale']    = scale
		})
	end)
end)

RegisterServerEvent('esx_property:plus:moveFurniture')
AddEventHandler('esx_property:plus:moveFurniture', function(furnitureId, x, y, z, heading, scale)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	if not xPlayer then return end

	MySQL.Async.execute('UPDATE property_furniture SET x=@x, y=@y, z=@z, heading=@h, scale=@s WHERE id = @id AND owner = @owner', {
		['@x']     = x,
		['@y']     = y,
		['@z']     = z,
		['@h']     = heading,
		['@s']     = scale,
		['@id']    = furnitureId,
		['@owner'] = xPlayer.identifier
	})
end)

RegisterServerEvent('esx_property:plus:removeFurniture')
AddEventHandler('esx_property:plus:removeFurniture', function(furnitureId)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	if not xPlayer then return end

	MySQL.Async.execute('DELETE FROM property_furniture WHERE id = @id AND owner = @owner', {
		['@id']    = furnitureId,
		['@owner'] = xPlayer.identifier
	}, function(rows)
		if rows > 0 then
			TriggerClientEvent('esx:showNotification', _source, 'فرنیچر برداشته شد و پول برنگشت')
		end
	end)
end)
