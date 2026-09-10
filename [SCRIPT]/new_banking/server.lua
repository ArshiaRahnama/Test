ESX = nil
local robbed = {}

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

CreateThread(function()
	exports.oxmysql:execute([[
		CREATE TABLE IF NOT EXISTS new_banking_transactions (
			id INT AUTO_INCREMENT PRIMARY KEY,
			identifier VARCHAR(64) NOT NULL,
			type VARCHAR(20) NOT NULL,
			amount INT NOT NULL,
			counterparty VARCHAR(64) NULL,
			counterparty_id INT NULL,
			created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
			INDEX idx_identifier (identifier)
		)
	]])
	-- in case this table already existed from an earlier version, add the new column
	exports.oxmysql:scalar([[
		SELECT COUNT(*) FROM information_schema.COLUMNS
		WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'new_banking_transactions' AND COLUMN_NAME = 'counterparty_id'
	]], {}, function(exists)
		if not exists or exists == 0 then
			exports.oxmysql:execute('ALTER TABLE new_banking_transactions ADD COLUMN counterparty_id INT NULL')
		end
	end)
end)

-- ================= Helpers =================

-- Writes one row into our own history table (used for the player-facing "Tarikhche" tab
-- and for the "recent contacts" quick-pick chips).
local function RecordTransaction(identifier, txType, amount, counterparty, counterpartyId)
	if not identifier then return end
	exports.oxmysql:insert('INSERT INTO new_banking_transactions (identifier, type, amount, counterparty, counterparty_id) VALUES (?, ?, ?, ?, ?)', {
		identifier, txType, amount, counterparty, counterpartyId
	})
end

-- Writes straight into the Unique_LogPanel database table (`unique_logpanel`), via the
-- `logs` resource's exported SendToSite. Safe to call with an offline target (no numeric
-- source), unlike ScriptPack's TransferLog which expects both sides to be online.
local function LogToPanel(title, message, source)
	local ok = pcall(function()
		exports['logs']:SendToSite('bank', title, message, source)
	end)
	if not ok then
		print(('[new_banking] could not write to Unique_LogPanel: %s'):format(title))
	end
end

-- Pushes a fresh balance/IBAN snapshot to a specific client's NUI, without needing to
-- close and reopen the bank panel. Used after every successful action so the number on
-- screen updates live.
local function PushBalance(_source)
	local xPlayer = ESX.GetPlayerFromId(_source)
	if not xPlayer then return end
	local balance = xPlayer.bank
	local cash = xPlayer.money
	exports.oxmysql:scalar('SELECT iban FROM users WHERE identifier = ?', {xPlayer.identifier}, function(iban)
		TriggerClientEvent('currentbalance1', _source, balance, iban, cash)
	end)
end

-- Tells the NUI whether an action succeeded, so it can show an in-panel toast/animation
-- instead of just relying on the ESX corner notification.
local function PushResult(_source, ok, kind, amount)
	TriggerClientEvent('bank:actionResult', _source, { ok = ok, kind = kind, amount = amount })
end

-- ================= Deposit =================

RegisterServerEvent('bank:depositx')
AddEventHandler('bank:depositx', function(amount)
	local _source = source

	local xPlayer = ESX.GetPlayerFromId(_source)
	amount = tonumber(amount)
	if amount == nil or amount <= 0 or amount > xPlayer.money then

		TriggerClientEvent('esx:showAdvancedNotification', _source, 'Bank', 'Pardakhte Vajh', 'Meqdare Vorodi Eshtebah ast', 'CHAR_BANK_MAZE', 9)
		PushResult(_source, false, 'deposit', amount)
	else
		xPlayer.removeMoney(amount)
		xPlayer.addBank(tonumber(amount))
		exports.ScriptPack:TransActionLog({source = xPlayer.source, type = "Variz", amount = amount})
		RecordTransaction(xPlayer.identifier, 'deposit', amount, nil, nil)
		LogToPanel('Bank Deposit', ('**Player:** %s [%s]\n**Amount:** $%s'):format(GetPlayerName(_source), _source, amount), _source)

		TriggerClientEvent('esx:showAdvancedNotification', _source, 'Bank', 'Pardakhte Vajh', 'Shoma ~g~$' .. amount .. '~s~ Dakhele Bank Khod Gozashtid', 'CHAR_BANK_MAZE', 9)
		PushResult(_source, true, 'deposit', amount)
		PushBalance(_source)
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

-- ================= Withdraw =================

RegisterServerEvent('bank:withdrawx')
AddEventHandler('bank:withdrawx', function(amount)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	local base = 0
	amount = tonumber(amount)
	base = xPlayer.bank
	if amount == nil or amount <= 0 or amount > base then


		TriggerClientEvent('esx:showAdvancedNotification', _source, 'Bank', 'Bardashte Vajh', 'Meqdar Eshtebah ast', 'CHAR_BANK_MAZE', 9)
		PushResult(_source, false, 'withdraw', amount)
	else
		xPlayer.removeBank(amount)
		xPlayer.addMoney(amount)

		exports.ScriptPack:TransActionLog({source = xPlayer.source, type = "Bardasht", amount = amount})
		RecordTransaction(xPlayer.identifier, 'withdraw', amount, nil, nil)
		LogToPanel('Bank Withdraw', ('**Player:** %s [%s]\n**Amount:** $%s'):format(GetPlayerName(_source), _source, amount), _source)

		TriggerClientEvent('esx:showAdvancedNotification', _source, 'Bank', 'Bardashte Vajh', 'Shoma ~r~$' .. amount .. '~s~ Az Hesabe Khod Bardashtid', 'CHAR_BANK_MAZE', 9)
		PushResult(_source, true, 'withdraw', amount)
		PushBalance(_source)
	end
end)

-- ================= Transfer =================

RegisterServerEvent('bank:transferx')
AddEventHandler('bank:transferx', function(to, amountt)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	amountt = tonumber(amountt)

	if not amountt or amountt <= 0 then
		TriggerClientEvent('esx:showAdvancedNotification', _source, 'Bank', 'Enteqale Vajh', 'Lotfan Faqat Adad Vared Konid', 'CHAR_BANK_MAZE', 9)
		PushResult(_source, false, 'transfer', amountt)
		return
	end

	if xPlayer.bank <= 0 or xPlayer.bank < amountt then
		TriggerClientEvent('esx:showAdvancedNotification', _source, 'Bank', 'Enteqale Vajh', 'Mojodi Shoma Kafi nist', 'CHAR_BANK_MAZE', 9)
		PushResult(_source, false, 'transfer', amountt)
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
			PushResult(_source, false, 'transfer', amountt)
			return
		end

		local zPlayer = ESX.GetPlayerFromId(targetId)
		if not zPlayer then
			TriggerClientEvent('esx:showAdvancedNotification', _source, 'Bank', 'Enteqale Vajh', 'Shenase Shakhs Morede Nazar Yaft nashod', 'CHAR_BANK_MAZE', 9)
			PushResult(_source, false, 'transfer', amountt)
			return
		end

		xPlayer.removeBank(amountt)
		zPlayer.addBank(amountt)
		exports.ScriptPack:TransferLog({source = xPlayer.source, target = zPlayer.source, type = "transfer", amount = amountt})
		RecordTransaction(xPlayer.identifier, 'transfer_out', amountt, zPlayer.name, zPlayer.source)
		RecordTransaction(zPlayer.identifier, 'transfer_in', amountt, xPlayer.name, xPlayer.source)
		LogToPanel('Bank Transfer', ('**From:** %s [%s]\n**To:** %s [%s]\n**Amount:** $%s'):format(GetPlayerName(_source), _source, GetPlayerName(zPlayer.source), zPlayer.source, amountt), _source)
		TriggerClientEvent('esx:showAdvancedNotification', _source, 'Bank', 'Enteqale Vajh', 'Shoma ~r~$' .. amountt .. '~s~ Be ~r~' .. string.gsub(zPlayer.name, "_", " ") .. ' ~s~Enteqal Dadid.', 'CHAR_BANK_MAZE', 9)
		TriggerClientEvent('esx:showAdvancedNotification', zPlayer.source, 'Bank', 'Enteqale Vajh', '~r~$' .. amountt .. '~s~ Az tarafe ~r~' .. string.gsub(xPlayer.name, "_", " ") .. ' ~s~Be hesabe Shoma Variz Shod.', 'CHAR_BANK_MAZE', 9)
		PushResult(_source, true, 'transfer', amountt)
		PushBalance(_source)
		PushBalance(zPlayer.source)
		return
	end

	-- Case 2: "to" is an IBAN / card number (5+ digit numbers, or any non-numeric
	-- code) — this works even if the recipient is offline
	exports.oxmysql:single('SELECT identifier FROM users WHERE iban = ?', {to}, function(result)
		if not result then
			TriggerClientEvent('esx:showAdvancedNotification', _source, 'Bank', 'Enteqale Vajh', 'Shenase Shakhs Morede Nazar Yaft nashod', 'CHAR_BANK_MAZE', 9)
			PushResult(_source, false, 'transfer', amountt)
			return
		end

		local targetIdentifier = result.identifier
		if targetIdentifier == xPlayer.identifier then
			TriggerClientEvent('esx:showAdvancedNotification', _source, 'Bank', 'Enteqale Vajh', 'Nemitavanid Be Khodetan Vajh Enteqal Dahid', 'CHAR_BANK_MAZE', 9)
			PushResult(_source, false, 'transfer', amountt)
			return
		end

		-- re-check balance: the DB lookup above is async, so the sender's bank
		-- balance could have changed in the meantime
		if xPlayer.bank <= 0 or xPlayer.bank < amountt then
			TriggerClientEvent('esx:showAdvancedNotification', _source, 'Bank', 'Enteqale Vajh', 'Mojodi Shoma Kafi nist', 'CHAR_BANK_MAZE', 9)
			PushResult(_source, false, 'transfer', amountt)
			return
		end

		xPlayer.removeBank(amountt)

		local zPlayer = ESX.GetPlayerFromIdentifier(targetIdentifier)
		if zPlayer then
			-- recipient is online
			zPlayer.addBank(amountt)
			TriggerClientEvent('esx:showAdvancedNotification', zPlayer.source, 'Bank', 'Enteqale Vajh', '~r~$' .. amountt .. '~s~ Az tarafe ~r~' .. string.gsub(xPlayer.name, "_", " ") .. ' ~s~Be hesabe Shoma Variz Shod.', 'CHAR_BANK_MAZE', 9)
			exports.ScriptPack:TransferLog({source = xPlayer.source, target = zPlayer.source, type = "transfer", amount = amountt})
			RecordTransaction(xPlayer.identifier, 'transfer_out', amountt, zPlayer.name, zPlayer.source)
			RecordTransaction(zPlayer.identifier, 'transfer_in', amountt, xPlayer.name, xPlayer.source)
			LogToPanel('Bank Transfer (IBAN)', ('**From:** %s [%s]\n**To:** %s [%s] (IBAN %s)\n**Amount:** $%s'):format(GetPlayerName(_source), _source, GetPlayerName(zPlayer.source), zPlayer.source, to, amountt), _source)
			PushBalance(zPlayer.source)
		else
			-- recipient is offline: update their bank balance directly in the database.
			-- ScriptPack's TransferLog assumes both sides are online, so we log this
			-- case ourselves instead of calling it (avoids an error on a nil source).
			exports.oxmysql:update('UPDATE users SET bank = bank + ? WHERE identifier = ?', {amountt, targetIdentifier})
			RecordTransaction(xPlayer.identifier, 'transfer_out', amountt, to, nil)
			RecordTransaction(targetIdentifier, 'transfer_in', amountt, xPlayer.name, xPlayer.source)
			LogToPanel('Bank Transfer (Offline Recipient)', ('**From:** %s [%s]\n**To Identifier:** %s (IBAN %s, offline)\n**Amount:** $%s'):format(GetPlayerName(_source), _source, targetIdentifier, to, amountt), _source)
		end

		TriggerClientEvent('esx:showAdvancedNotification', _source, 'Bank', 'Enteqale Vajh', 'Shoma ~r~$' .. amountt .. '~s~ Be IBAN ~r~' .. to .. ' ~s~Enteqal Dadid.', 'CHAR_BANK_MAZE', 9)
		PushResult(_source, true, 'transfer', amountt)
		PushBalance(_source)
	end)
end)

-- ================= Balance / IBAN =================

RegisterServerEvent('bank:balance')
AddEventHandler('bank:balance', function()
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)
    local balance = xPlayer.bank
    local cash = xPlayer.money


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

        TriggerClientEvent('currentbalance1', _source, balance, iban, cash)
    end)
end)

-- ================= Transaction history (for the "Tarikhche" tab) =================

RegisterServerEvent('bank:history')
AddEventHandler('bank:history', function()
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	if not xPlayer then return end

	exports.oxmysql:query('SELECT type, amount, counterparty, created_at FROM new_banking_transactions WHERE identifier = ? ORDER BY id DESC LIMIT 20', {xPlayer.identifier}, function(rows)
		TriggerClientEvent('bank:historyBack', _source, rows or {})
	end)
end)

-- ================= Recent contacts (quick-pick chips on the transfer screen) =================

RegisterServerEvent('bank:recentContacts')
AddEventHandler('bank:recentContacts', function()
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	if not xPlayer then return end

	-- most recent distinct people this player has sent money to (online transfers only,
	-- since only those have a usable numeric id to quick-fill)
	exports.oxmysql:query([[
		SELECT counterparty, counterparty_id, MAX(id) as last_id
		FROM new_banking_transactions
		WHERE identifier = ? AND type = 'transfer_out' AND counterparty_id IS NOT NULL
		GROUP BY counterparty, counterparty_id
		ORDER BY last_id DESC
		LIMIT 3
	]], {xPlayer.identifier}, function(rows)
		TriggerClientEvent('bank:recentContactsBack', _source, rows or {})
	end)
end)

-- ================= Online players (for the name-search field) =================

RegisterServerEvent('bank:getOnlinePlayers')
AddEventHandler('bank:getOnlinePlayers', function()
	local _source = source
	local list = {}
	for _, playerId in ipairs(GetPlayers()) do
		local pid = tonumber(playerId)
		if pid and pid ~= _source then
			table.insert(list, { id = pid, name = GetPlayerName(pid) })
		end
	end
	TriggerClientEvent('bank:onlinePlayersBack', _source, list)
end)
