ESX = nil
getkillers = {}

TriggerEvent("esx:getSharedObject",function(obj)
    ESX = obj
end)

if DiscordConnect == nil and DiscordWebhookKillinglogs == nil and DiscordWebhookChat == nil then
	local Content = LoadResourceFile(GetCurrentResourceName(), 'config.lua')
	Content = load(Content)
	Content()
end
if DiscordConnect == 'WEBHOOK_LINK_HERE' then

else
	PerformHttpRequest(DiscordConnect, function(Error, Content, Head)
		if Content == '{"code": 50027, "message": "Invalid Webhook Token"}' then

		end
	end)
end
if DiscordWebhookKillinglogs == 'WEBHOOK_LINK_HERE' then

else
	PerformHttpRequest(DiscordWebhookKillinglogs, function(Error, Content, Head)
		if Content == '{"code": 50027, "message": "Invalid Webhook Token"}' then

		end
	end)
end
if DiscordWebhookChat == 'WEBHOOK_LINK_HERE' then

else
	PerformHttpRequest(DiscordWebhookChat, function(Error, Content, Head)
		if Content == '{"code": 50027, "message": "Invalid Webhook Token"}' then

		end
	end)
end


PerformHttpRequest(DiscordConnect, function(Error, Content, Head) end, 'POST', json.encode({username = SystemName, content = '**FiveM server webhook started**'}), { ['Content-Type'] = 'application/json' })

AddEventHandler('playerConnecting', function()
	TriggerEvent('DiscordBot:ToDiscord', DiscordConnect, SystemName, '```css\n[ Name : '..GetPlayerName(source).." ]\n[ identifier : "..GetPlayerIdentifier(source).." ]\n[ Player Connected ]```", SystemAvatar, false)
end)

AddEventHandler('playerDropped', function(Reason)
	TriggerEvent('DiscordBot:ToDiscord', DiscordDisconnect, SystemName, '```css\n[ Name : '..GetPlayerName(source).." ]\n[ identifier : "..GetPlayerIdentifier(source).." ]\n[ ID : "..source.." ]\n[ Player Disconnected ]\n[ Reason : " .. Reason .. " ]```", SystemAvatar, false)
end)

RegisterServerEvent('DiscordBot:plascaryyerDied')
AddEventHandler('DiscordBot:plascaryyerDied', function(Message, killer, Deader, Weapon, KillerCorrd, PlayerCorrd)
	local date = os.date('*t')
	local xPlayer = ESX.GetPlayerFromId(Deader)
	local xTarget = ESX.GetPlayerFromId(killer)
	local Wep = Weapon or 'Null'
	getkillers[Deader] = killer.." ^0) Ba WEAPON :(^1"..Wep.."^0"
	if date.day < 10 then date.day = '0' .. tostring(date.day) end
	if date.month < 10 then date.month = '0' .. tostring(date.month) end
	if date.hour < 10 then date.hour = '0' .. tostring(date.hour) end
	if date.min < 10 then date.min = '0' .. tostring(date.min) end
	if date.sec < 10 then date.sec = '0' .. tostring(date.sec) end
	if Weapon then

		Message = "```Player : "..xPlayer.name.." ("..xPlayer.source..") \n".."Steam : "..xPlayer.identifier.."\n"..PlayerCorrd.."\n **Tavasote:**\nPlayer : "..xTarget.name.." ("..xTarget.source..")\nSteam : "..xTarget.identifier.."\n"..KillerCorrd.."\n Weapon : "..Weapon.."\n Reason : "..Message.."```"
	end
	TriggerEvent('DiscordBot:ToDiscord', DiscordWebhookKillinglogs, SystemName, Message .. ' `' .. date.day .. '.' .. date.month .. '.' .. date.year .. ' - ' .. date.hour .. ':' .. date.min .. ':' .. date.sec .. '`', SystemAvatar, false)
end)

TriggerEvent('es:addAdminCommand', 'getkiller', 1, function(source, args, user)
    if args[1] then
		local DeadId = tonumber(args[1])
		if getkillers[DeadId] then
			TriggerClientEvent('chat:addMessage', source, { args = { "^1[System]", "ID (^1"..DeadId.."^0) Tavasote ID(^1"..getkillers[DeadId].."^0) Dead Shode" } })
		else
			TriggerClientEvent('chat:addMessage', source, { args = { "^1[System]", "^1 Data Yaft Nashod"}})
		end
    else
		TriggerClientEvent('chat:addMessage', source, { args = { "^1[System]", "^1 Lotfan ID Vared Konid" } })
    end
end, function(source, args, user)
    TriggerClientEvent('chat:addMessage', source, { args = { "System", "Dastresi Nadarid" } })
end, {help = "Get Killer", params = {{name = "Id", help = "ID Killer"}}})



RegisterServerEvent('DiscordBot:ToDiscord')
AddEventHandler('DiscordBot:ToDiscord', function(WebHook, Name, Message, Image, External, Source, TTS)
	if Message == nil or Message == '' then
		return nil
	end
	if TTS == nil or TTS == '' then
		TTS = false
	end
	if External then
		if WebHook:lower() == 'chat' then
			WebHook = DiscordWebhookChat
		elseif WebHook:lower() == 'system' then
			WebHook = DiscordConnect
		elseif WebHook:lower() == 'kill' then
			WebHook = DiscordWebhookKillinglogs
		elseif WebHook:lower() == 'pwi' then
			WebHook = DiscordWebhookPwi
		elseif WebHook:lower() == 'dwi' then
			WebHook = DiscordWebhookDwi
		elseif WebHook:lower() == 'rob' then
			WebHook = DiscordWebhookRob
		elseif WebHook:lower() == 'loot' then
			WebHook = DiscordWebhookloot
		elseif WebHook:lower() == 'home' then
			WebHook = DiscordWebhookHome
		elseif WebHook:lower() == 'inventory' then
			WebHook = DiscordWebhookInventory
		elseif WebHook:lower() == 'duty' then
			WebHook = DiscordWebhookduty
		elseif WebHook:lower() == 'jail' then
			WebHook = DiscordWebhookJail
		elseif WebHook:lower() == 'ajail' then
			WebHook = DiscordWebhookaJail
		elseif WebHook:lower() == 'bansystem' then
			WebHook = DiscordWebhookBansystem
		elseif WebHook:lower() == 'bansystemp' then
			WebHook = DiscordWebhookBansystemP
		elseif WebHook:lower() == 'disband' then
			WebHook = DiscordWebhookDisband
		elseif WebHook:lower() == 'reset' then
			WebHook = DiscordWebhookReset
		elseif WebHook:lower() == 'drop' then
			WebHook = DiscordWebhookDrop
		elseif WebHook:lower() == 'pickup' then
			WebHook = DiscordWebhookPickUP
		elseif WebHook:lower() == 'amoney' then
			WebHook = DiscordWebhookAmoneyLog
		elseif WebHook:lower() == 'transfer' then
			WebHook = DiscordWebhookTrasferLog
		elseif WebHook:lower() == 'changename' then
			WebHook = DiscordWebhookNameLog
		elseif WebHook:lower() == 'starterpack' then
			WebHook = DiscordWebhookStarter
		elseif WebHook:lower() == 'cdi' then
			WebHook = DiscordWebhookDID
		elseif WebHook:lower() == 'pdrop' then
			WebHook = Discordpdrop
		elseif WebHook:lower() == "co" then
			WebHook = Discordpjoin
		elseif WebHook:lower() == "gp" then
			WebHook = DiscordGivePerm
		elseif WebHook:lower() == "pitem" then
			WebHook = DiscordPutTrunk
		elseif WebHook:lower() == "report" then
			WebHook = DiscordReport
		elseif WebHook:lower() == "reportaccept" then
			WebHook = DiscordAcceptReport
		elseif WebHook:lower() == "nlr" then
			WebHook = DiscordNLR
		elseif WebHook:lower() == "gangs" then
			WebHook = DiscordGangsChangeLog
		elseif WebHook:lower() == "setarmor" then
			WebHook = DiscordSetArmor
		elseif WebHook:lower() == "setgang" then
			WebHook = DiscordSetGang
		elseif WebHook:lower() == "setjob" then
			WebHook = DiscordSetJob
		elseif WebHook:lower() == "addcar" then
			WebHook = DiscordAddCar
		elseif WebHook:lower() == "buycar" then
			WebHook = DiscordBuyCar
		elseif WebHook:lower() == "sellcar" then
			WebHook = DiscordSellCar
		elseif WebHook:lower() == "revive" then
			WebHook = DiscordRevive
		elseif WebHook:lower() == "heal" then
			WebHook = DiscordHeal
		elseif WebHook:lower() == "addweapon" then
			WebHook = additemWeapon
		elseif WebHook:lower() == "additem" then
			WebHook = additemItem
		elseif WebHook:lower() == "bossaction" then
			WebHook = DiscordBoss
		elseif WebHook:lower() == "cuff" then
			WebHook = DiscordCuff
		elseif WebHook:lower() == "cuffall" then
			WebHook = DiscordCuffAll
		elseif WebHook:lower() == "fine" then
			WebHook = DiscordFine
		elseif WebHook:lower() == "vdm" then
			WebHook = DiscordWebhookVDM
		elseif WebHook:lower() == "tirelog" then
			WebHook = DiscordWebhookTireLog
		elseif WebHook:lower() == "entervehicle" then
			WebHook = DiscordWebhookVehicleEntry
		end

		if Image:lower() == 'steam' then
			Image = UserAvatar
			if GetIDFromSource('steam', Source) then
				PerformHttpRequest('http://steamcommunity.com/profiles/' .. tonumber(GetIDFromSource('steam', Source), 16) .. '/?xml=1', function(Error, Content, Head)
					local SteamProfileSplitted = stringsplit(Content, '\n')
					for i, Line in ipairs(SteamProfileSplitted) do
						if Line:find('<avatarFull>') then
							Image = Line:gsub('	<avatarFull><!%[CDATA%[', ''):gsub(']]></avatarFull>', '')
							return PerformHttpRequest(WebHook, function(Error, Content, Head) end, 'POST', json.encode({username = Name, content = Message, avatar_url = Image, tts = TTS}), {['Content-Type'] = 'application/json'})
						end
					end
				end)
			end
		elseif Image:lower() == 'user' then
			Image = UserAvatar
		else
			Image = SystemAvatar
		end
	end
	PerformHttpRequest(WebHook, function(Error, Content, Head) end, 'POST', json.encode({username = Name, content = Message, avatar_url = Image, tts = TTS}), {['Content-Type'] = 'application/json'})
end)

function IsCommand(String, Type)
	if Type == 'Blacklisted' then
		for i, BlacklistedCommand in ipairs(BlacklistedCommands) do
			if String[1]:lower() == BlacklistedCommand:lower() then
				return true
			end
		end
	elseif Type == 'Special' then
		for i, SpecialCommand in ipairs(SpecialCommands) do
			if String[1]:lower() == SpecialCommand[1]:lower() then
				return true
			end
		end
	elseif Type == 'HavingOwnWebhook' then
		for i, OwnWebhookCommand in ipairs(OwnWebhookCommands) do
			if String[1]:lower() == OwnWebhookCommand[1]:lower() then
				return true
			end
		end
	elseif Type == 'TTS' then
		for i, TTSCommand in ipairs(TTSCommands) do
			if String[1]:lower() == TTSCommand:lower() then
				return true
			end
		end
	end
	return false
end

function ReplaceSpecialCommand(String)
	for i, SpecialCommand in ipairs(SpecialCommands) do
		if String[1]:lower() == SpecialCommand[1]:lower() then
			String[1] = SpecialCommand[2]
		end
	end
	return String
end

function GetOwnWebhook(String)
	for i, OwnWebhookCommand in ipairs(OwnWebhookCommands) do
		if String[1]:lower() == OwnWebhookCommand[1]:lower() then
			if OwnWebhookCommand[2] == 'WEBHOOK_LINK_HERE' then
				print('Please enter a webhook link for the command: ' .. String[1])
				return DiscordWebhookChat
			else
				return OwnWebhookCommand[2]
			end
		end
	end
end

function stringsplit(input, seperator)
	if seperator == nil then
		seperator = '%s'
	end

	local t={} ; i=1

	for str in string.gmatch(input, '([^'..seperator..']+)') do
		t[i] = str
		i = i + 1
	end

	return t
end

function GetIDFromSource(Type, ID)
    local IDs = GetPlayerIdentifiers(ID)
    for k, CurrentID in pairs(IDs) do
        local ID = stringsplit(CurrentID, ':')
        if (ID[1]:lower() == string.lower(Type)) then
            return ID[2]:lower()
        end
    end
    return nil
end

local lastDamagers = {}

RegisterServerEvent("adminsys:storeLastDamage")
AddEventHandler("adminsys:storeLastDamage", function(attackerId, weapon, coords, coordsatacer)
    local victimId = source
    weapon = tonumber(weapon) or 0

    if not lastDamagers[victimId] then
        lastDamagers[victimId] = {}
    end

    table.insert(lastDamagers[victimId], 1, {
        attackerId = attackerId,
        weapon = weapon,
        coords = coords,
		coordsatacer = coordsatacer
    })

    if #lastDamagers[victimId] > 5 then
        table.remove(lastDamagers[victimId], 6)
    end
end)

RegisterCommand("getdamage", function(source, args)
    local targetId = tonumber(args[1])
	local xPlayer = ESX.GetPlayerFromId(source)
	if xPlayer.permission_level >= 1 then

		if not targetId then
			TriggerClientEvent('chat:addMessage', source, { args = { "Id vared konin" } })
			return
		end

		local damageList = lastDamagers[targetId]
		if damageList and #damageList > 0 then
			for i, dmg in ipairs(damageList) do
				local x, y, z = table.unpack(dmg.coords or {0, 0, 0})
				local x2, y2, z2 = table.unpack(dmg.coordsatacer or {0, 0, 0})
				TriggerClientEvent('chat:addMessage', source, {
					args = {
						string.format("[%d] Damage by ID %s | PT: (%.2f, %.2f, %.2f) | PA: (%.3f, %.3f, %.3f)",
							i,
							dmg.attackerId or "?",
							x, y, z, x2, y2, z2)
					}
				})
			end
		else
			TriggerClientEvent('chat:addMessage', source, {
				args = { "Hich damagei peyda nashod." }
			})
		end
	else
		TriggerClientEvent('chat:addMessage', source, {
			args = { "Shoma Dast Resi Nadarid." }
		})
	end
end, false)