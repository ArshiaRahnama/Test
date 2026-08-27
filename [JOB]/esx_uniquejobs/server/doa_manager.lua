-- ============================================================
-- DOA Manager
-- Powers the DOA-specific section of the /doj menu: seizure
-- logging and informant management (register, log tips, pay).
-- Requires doj_tables.sql to be imported once.
-- ============================================================

ESX = nil
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

local function isDoa(jobname)
	return jobname == 'doa'
end

local function resolveIdentifier(query, cb)
	local asId = tonumber(query)
	if asId then
		local xTarget = ESX.GetPlayerFromId(asId)
		if xTarget then
			cb(xTarget.identifier, xTarget.name)
			return
		end
	end

	MySQL.Async.fetchAll('SELECT identifier, playerName FROM users WHERE playerName LIKE @name LIMIT 1', {
		['@name'] = '%' .. query .. '%',
	}, function(result)
		if result[1] then
			cb(result[1].identifier, result[1].playerName)
		else
			cb(nil, nil)
		end
	end)
end

-- ============================================================
-- Seizure log
-- ============================================================

RegisterServerEvent('esx_uniquejobs:doaLogSeizure')
AddEventHandler('esx_uniquejobs:doaLogSeizure', function(itemLabel, quantity, estValue, suspectQuery)
	local source = source
	local xPlayer = ESX.GetPlayerFromId(source)
	if not xPlayer or not isDoa(xPlayer.job.name) then return end

	if not itemLabel or itemLabel == '' then
		TriggerClientEvent('esx:showNotification', source, '~r~Esm-e Zabti Ra Vared Konid')
		return
	end

	quantity = tonumber(quantity) or 1
	estValue = tonumber(estValue) or 0

	local function insert(suspectIdentifier, suspectName)
		MySQL.Async.execute(
			'INSERT INTO doa_seizures (item_label, quantity, est_value, suspect_identifier, suspect_name, officer_name, timestamp) VALUES (@item, @qty, @val, @sid, @sname, @officer, @ts)',
			{
				['@item'] = itemLabel,
				['@qty'] = quantity,
				['@val'] = estValue,
				['@sid'] = suspectIdentifier,
				['@sname'] = suspectName,
				['@officer'] = xPlayer.name,
				['@ts'] = os.time(),
			}
		)
		TriggerClientEvent('esx:showNotification', source, '~g~Zabti Sabt Shod')
	end

	if suspectQuery and suspectQuery ~= '' then
		resolveIdentifier(suspectQuery, function(identifier, name)
			insert(identifier, name)
		end)
	else
		insert(nil, nil)
	end
end)

ESX.RegisterServerCallback('esx_uniquejobs:doaGetSeizures', function(source, cb)
	local xPlayer = ESX.GetPlayerFromId(source)
	if not xPlayer or not isDoa(xPlayer.job.name) then cb(nil) return end

	MySQL.Async.fetchAll('SELECT item_label, quantity, est_value, suspect_name, officer_name, timestamp FROM doa_seizures ORDER BY timestamp DESC LIMIT 20', {}, function(rows)
		cb(rows)
	end)
end)

-- ============================================================
-- Informants
-- ============================================================

RegisterServerEvent('esx_uniquejobs:doaRegisterInformant')
AddEventHandler('esx_uniquejobs:doaRegisterInformant', function(targetQuery, codename)
	local source = source
	local xPlayer = ESX.GetPlayerFromId(source)
	if not xPlayer or not isDoa(xPlayer.job.name) then return end

	if not targetQuery or targetQuery == '' or not codename or codename == '' then
		TriggerClientEvent('esx:showNotification', source, '~r~Hadaf Va Codename Ra Vared Konid')
		return
	end

	resolveIdentifier(targetQuery, function(identifier, name)
		if not identifier then
			TriggerClientEvent('esx:showNotification', source, '~r~Hadaf Peida Nashod')
			return
		end

		MySQL.Async.execute(
			'INSERT INTO doa_informants (identifier, codename, registered_by, timestamp) VALUES (@id, @codename, @by, @ts) ON DUPLICATE KEY UPDATE codename = @codename',
			{
				['@id'] = identifier,
				['@codename'] = codename,
				['@by'] = xPlayer.name,
				['@ts'] = os.time(),
			},
			function()
				TriggerClientEvent('esx:showNotification', source, '~g~Khabarchin "' .. codename .. '" Sabt Shod')
			end
		)
	end)
end)

ESX.RegisterServerCallback('esx_uniquejobs:doaGetInformants', function(source, cb)
	local xPlayer = ESX.GetPlayerFromId(source)
	if not xPlayer or not isDoa(xPlayer.job.name) then cb(nil) return end

	MySQL.Async.fetchAll('SELECT id, codename, registered_by, total_paid FROM doa_informants ORDER BY id DESC', {}, function(rows)
		cb(rows)
	end)
end)

RegisterServerEvent('esx_uniquejobs:doaSubmitTip')
AddEventHandler('esx_uniquejobs:doaSubmitTip', function(informantId, tipText)
	local source = source
	local xPlayer = ESX.GetPlayerFromId(source)
	if not xPlayer or not isDoa(xPlayer.job.name) then return end

	if not tipText or tipText == '' then return end

	MySQL.Async.execute('INSERT INTO doa_tips (informant_id, tip_text, logged_by, timestamp) VALUES (@iid, @text, @by, @ts)', {
		['@iid'] = informantId,
		['@text'] = tipText,
		['@by'] = xPlayer.name,
		['@ts'] = os.time(),
	}, function()
		TriggerClientEvent('esx:showNotification', source, '~g~Tip Sabt Shod')
	end)
end)

ESX.RegisterServerCallback('esx_uniquejobs:doaGetTips', function(source, cb, informantId)
	local xPlayer = ESX.GetPlayerFromId(source)
	if not xPlayer or not isDoa(xPlayer.job.name) then cb(nil) return end

	MySQL.Async.fetchAll('SELECT tip_text, logged_by, timestamp FROM doa_tips WHERE informant_id = @iid ORDER BY timestamp DESC LIMIT 10', {
		['@iid'] = informantId,
	}, function(rows)
		cb(rows)
	end)
end)

RegisterServerEvent('esx_uniquejobs:doaPayInformant')
AddEventHandler('esx_uniquejobs:doaPayInformant', function(informantId, amount)
	local source = source
	local xPlayer = ESX.GetPlayerFromId(source)
	if not xPlayer or not isDoa(xPlayer.job.name) then return end

	amount = tonumber(amount)
	if not amount or amount <= 0 then
		TriggerClientEvent('esx:showNotification', source, '~r~Mablagh-e Nadorost')
		return
	end

	MySQL.Async.fetchAll('SELECT identifier FROM doa_informants WHERE id = @id', { ['@id'] = informantId }, function(result)
		if not result[1] then
			TriggerClientEvent('esx:showNotification', source, '~r~Khabarchin Peida Nashod')
			return
		end

		local identifier = result[1].identifier

		TriggerEvent('esx_addonaccount:getSharedAccount', 'society_doa', function(account)
			if account.money < amount then
				TriggerClientEvent('esx:showNotification', source, '~r~Mojoodi-e Society Kafi Nist')
				return
			end

			account.removeMoney(amount)

			-- Works whether the informant is online or offline
			local xInformant = ESX.GetPlayerFromIdentifier(identifier)
			if xInformant then
				xInformant.addAccountMoney('bank', amount)
			else
				MySQL.Async.execute('UPDATE users SET bank = bank + @amount WHERE identifier = @id', {
					['@amount'] = amount,
					['@id'] = identifier,
				})
			end

			MySQL.Async.execute('UPDATE doa_informants SET total_paid = total_paid + @amount WHERE id = @id', {
				['@amount'] = amount,
				['@id'] = informantId,
			})

			TriggerClientEvent('esx:showNotification', source, '~g~$' .. amount .. ' Be Khabarchin Pardakht Shod')
		end)
	end)
end)
