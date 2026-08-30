

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
	for _,v in pairs(robbed) do
		local timer = GetGameTimer() - v.timer
		if timer < 3600000 then
			TriggerClientEvent('new_banking:disableforhour', source, v.pos, timer)
		else
			table.remove(robbed, _)
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
	local zPlayer = ESX.GetPlayerFromId(to)
	local balance = 0
	amountt = tonumber(amountt)
	if not amountt then
		TriggerClientEvent('esx:showAdvancedNotification', _source, 'Bank', 'Enteqale Vajh', 'Lotfan Faqat Adad Vared Konid', 'CHAR_BANK_MAZE', 9)
		return
	end
	if not zPlayer then
		TriggerClientEvent('esx:showAdvancedNotification', _source, 'Bank', 'Enteqale Vajh', 'Shenase Shakhs Morede Nazar Yaft nashod', 'CHAR_BANK_MAZE', 9)
		return
	end
	balance = xPlayer.bank
	if tonumber(_source) == tonumber(to) then
		TriggerClientEvent('esx:showAdvancedNotification', _source, 'Bank', 'Enteqale Vajh', 'Nemitavanid Be Khodetan Vajh Enteqal Dahid', 'CHAR_BANK_MAZE', 9)
	else
		if balance <= 0 or balance < tonumber(amountt) or tonumber(amountt) <= 0 then
			TriggerClientEvent('esx:showAdvancedNotification', _source, 'Bank', 'Enteqale Vajh', 'Mojodi Shoma Kafi nist', 'CHAR_BANK_MAZE', 9)
		else
			xPlayer.removeBank(amountt)
			zPlayer.addBank(amountt)
			exports.ScriptPack:TransferLog({source = xPlayer.source, target = zPlayer.source, type = "transfer", amount = amountt})
			TriggerClientEvent('esx:showAdvancedNotification', _source, 'Bank', 'Enteqale Vajh', 'Shoma ~r~$' .. amountt .. '~s~ Be ~r~' .. string.gsub(zPlayer.name, "_", " ") .. ' ~s~Enteqal Dadid.', 'CHAR_BANK_MAZE', 9)
			TriggerClientEvent('esx:showAdvancedNotification', to, 'Bank', 'Enteqale Vajh', '~r~$' .. amountt .. '~s~ Az tarafe ~r~' .. string.gsub(xPlayer.name, "_", " ") .. ' ~s~Be hesabe Shoma Variz Shod.', 'CHAR_BANK_MAZE', 9)
		end
	end
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