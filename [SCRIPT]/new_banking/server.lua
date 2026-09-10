ESX = nil
local robbed = {}

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

RegisterServerEvent('bank:depositx')
AddEventHandler('bank:depositx', function(amount)
	local _source = source

	local xPlayer = ESX.GetPlayerFromId(_source)
	amount = tonumber(amount)
	if amount == nil or amount <= 0 or amount > xPlayer.money then

		TriggerClientEvent('esx:showAdvancedNotification', _source, 'Bank', 'Pardakhte Vajh', 'Meqdare Vorodi Eshtebah ast', 'CHAR_BANK_MAZE', 9)
	else
		xPlayer.removeMoney(amount)
		xPlayer.addBank(tonumber(amount))
		exports.ScriptPack:TransActionLog({source = xPlayer.source, type = "Variz", amount = amount})

		TriggerClientEvent('esx:showAdvancedNotification', _source, 'Bank', 'Pardakhte Vajh', 'Shoma ~g~$' .. amount .. '~s~ Dakhele Bank Khod Gozashtid', 'CHAR_BANK_MAZE', 9)
	end
end)

RegisterServerEvent('new_banking:disableforhour')
AddEventHandler('new_banking:disableforhour', function(pos)
	local _source = source
	table.insert(robbed, {
		pos = pos,
		timer = GetGameTimer()
	})
	TriggerClientEvent('new_banking:disableforhour',-1, pos, 60 * 60 * 1000)

	local xPlayer = ESX.GetPlayerFromId(_source)
	local posStr = pos and (('%.1f, %.1f, %.1f'):format(pos.x or 0, pos.y or 0, pos.z or 0)) or 'unknown'
	TriggerEvent('DiscordBot:ToDiscord', 'rob', 'BankRobberyLog', '```css\n[ Player : '..GetPlayerName(_source)..'(' .. _source .. ') ]\n[ Player Steam : '..(xPlayer and xPlayer.identifier or '?')..' ]\n[ Event : Bank Alarm Triggered - vault disabled for 1 hour ]\n[ Location : '..posStr..' ]\n```', 'user', true, _source, false)
end)

RegisterServerEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(source)
	for i = #robbed, 1, -1 do
		local v = robbed[i]
		local timer = GetGameTimer() - v.timer
		if timer < 3600000 then
			TriggerClientEvent('new_banking:disableforhour', source, v.pos, timer)
		else
			table.remove(robbed, i)
		end
	end
end)

RegisterServerEvent('bank:withdrawx')
AddEventHandler('bank:withdrawx', function(amount)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	local base = 0
	amount = tonumber(amount)
	base = xPlayer.bank
	if amount == nil or amount <= 0 or amount > base then


		TriggerClientEvent('esx:showAdvancedNotification', _source, 'Bank', 'Bardashte Vajh', 'Meqdar Eshtebah ast', 'CHAR_BANK_MAZE', 9)
	else
		xPlayer.removeBank(amount)
		xPlayer.addMoney(amount)

		exports.ScriptPack:TransActionLog({source = xPlayer.source, type = "Bardasht", amount = amount})
		TriggerClientEvent('esx:showAdvancedNotification', _source, 'Bank', 'Bardashte Vajh', 'Shoma ~r~$' .. amount .. '~s~ Az Hesabe Khod Bardashtid', 'CHAR_BANK_MAZE', 9)
	end
end)

RegisterServerEvent('bank:transferx')
AddEventHandler('bank:transferx', function(to, amountt)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	amountt = tonumber(amountt)

	if not amountt or amountt <= 0 then
		TriggerClientEvent('esx:showAdvancedNotification', _source, 'Bank', 'Enteqale Vajh', 'Lotfan Faqat Adad Vared Konid', 'CHAR_BANK_MAZE', 9)
		return
	end

	if xPlayer.bank <= 0 or xPlayer.bank < amountt then
		TriggerClientEvent('esx:showAdvancedNotification', _source, 'Bank', 'Enteqale Vajh', 'Mojodi Shoma Kafi nist', 'CHAR_BANK_MAZE', 9)
		return
	end

	to = tostring(to or ''):gsub('%s+', '')

	-- This server's IBANs are plain 7-digit numbers (generated elsewhere, e.g.
	-- Unique_Phone), which collide with numeric player IDs. Player server IDs
	-- are realistically at most 4 digits, so use digit length to tell them apart:
	-- 5+ digits => treat as IBAN, otherwise treat as a player ID.
	local targetId = tonumber(to)
	if targetId and #to <= 4 then
		if tonumber(_source) == targetId then
			TriggerClientEvent('esx:showAdvancedNotification', _source, 'Bank', 'Enteqale Vajh', 'Nemitavanid Be Khodetan Vajh Enteqal Dahid', 'CHAR_BANK_MAZE', 9)
			return
		end

		local zPlayer = ESX.GetPlayerFromId(targetId)
		if not zPlayer then
			TriggerClientEvent('esx:showAdvancedNotification', _source, 'Bank', 'Enteqale Vajh', 'Shenase Shakhs Morede Nazar Yaft nashod', 'CHAR_BANK_MAZE', 9)
			return
		end

		xPlayer.removeBank(amountt)
		zPlayer.addBank(amountt)
		exports.ScriptPack:TransferLog({source = xPlayer.source, target = zPlayer.source, type = "transfer", amount = amountt})
		TriggerClientEvent('esx:showAdvancedNotification', _source, 'Bank', 'Enteqale Vajh', 'Shoma ~r~$' .. amountt .. '~s~ Be ~r~' .. string.gsub(zPlayer.name, "_", " ") .. ' ~s~Enteqal Dadid.', 'CHAR_BANK_MAZE', 9)
		TriggerClientEvent('esx:showAdvancedNotification', zPlayer.source, 'Bank', 'Enteqale Vajh', '~r~$' .. amountt .. '~s~ Az tarafe ~r~' .. string.gsub(xPlayer.name, "_", " ") .. ' ~s~Be hesabe Shoma Variz Shod.', 'CHAR_BANK_MAZE', 9)
		return
	end

	-- Case 2: "to" is an IBAN / card number (5+ digit numbers, or any non-numeric
	-- code) — this works even if the recipient is offline
	exports.oxmysql:single('SELECT identifier FROM users WHERE iban = ?', {to}, function(result)
		if not result then
			TriggerClientEvent('esx:showAdvancedNotification', _source, 'Bank', 'Enteqale Vajh', 'Shenase Shakhs Morede Nazar Yaft nashod', 'CHAR_BANK_MAZE', 9)
			return
		end

		local targetIdentifier = result.identifier
		if targetIdentifier == xPlayer.identifier then
			TriggerClientEvent('esx:showAdvancedNotification', _source, 'Bank', 'Enteqale Vajh', 'Nemitavanid Be Khodetan Vajh Enteqal Dahid', 'CHAR_BANK_MAZE', 9)
			return
		end

		-- re-check balance: the DB lookup above is async, so the sender's bank
		-- balance could have changed in the meantime
		if xPlayer.bank <= 0 or xPlayer.bank < amountt then
			TriggerClientEvent('esx:showAdvancedNotification', _source, 'Bank', 'Enteqale Vajh', 'Mojodi Shoma Kafi nist', 'CHAR_BANK_MAZE', 9)
			return
		end

		xPlayer.removeBank(amountt)

		local zPlayer = ESX.GetPlayerFromIdentifier(targetIdentifier)
		if zPlayer then
			-- recipient is online
			zPlayer.addBank(amountt)
			TriggerClientEvent('esx:showAdvancedNotification', zPlayer.source, 'Bank', 'Enteqale Vajh', '~r~$' .. amountt .. '~s~ Az tarafe ~r~' .. string.gsub(xPlayer.name, "_", " ") .. ' ~s~Be hesabe Shoma Variz Shod.', 'CHAR_BANK_MAZE', 9)
			exports.ScriptPack:TransferLog({source = xPlayer.source, target = zPlayer.source, type = "transfer", amount = amountt})
		else
			-- recipient is offline: update their bank balance directly in the database
			exports.oxmysql:update('UPDATE users SET bank = bank + ? WHERE identifier = ?', {amountt, targetIdentifier})
			exports.ScriptPack:TransferLog({source = xPlayer.source, target = targetIdentifier, type = "transfer_offline", amount = amountt})
		end

		TriggerClientEvent('esx:showAdvancedNotification', _source, 'Bank', 'Enteqale Vajh', 'Shoma ~r~$' .. amountt .. '~s~ Be IBAN ~r~' .. to .. ' ~s~Enteqal Dadid.', 'CHAR_BANK_MAZE', 9)
	end)
end)

RegisterServerEvent('bank:balance')
AddEventHandler('bank:balance', function()
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)
    local balance = xPlayer.bank


    local identifier = xPlayer.identifier
    exports.oxmysql:scalar('SELECT iban FROM users WHERE identifier = ?', {identifier}, function(iban)
        if iban == nil then



            local digits = {tostring(math.random(1, 9))}
            for i = 1, 18 do
                digits[#digits + 1] = tostring(math.random(0, 9))
            end
            iban = 'IR' .. table.concat(digits)
            exports.oxmysql:update('UPDATE users SET iban = ? WHERE identifier = ?', {iban, identifier}, function(affectedRows)
                if affectedRows > 0 then
                    print(('IBAN generated for player %s: %s'):format(xPlayer.name, iban))
                end
            end)
        end

        TriggerClientEvent('currentbalance1', _source, balance, iban)
    end)
end)