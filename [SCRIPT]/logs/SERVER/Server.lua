ESX = nil
getkillers = {}

TriggerEvent("esx:getSharedObject",function(obj)
    ESX = obj
end)

-- ============================================================================
-- گرفتن خطاهای اجراییِ لوا (کرش‌ها) و فرستادنشون به دیسکورد + سایت
-- ============================================================================
-- توجه فنی: FiveM هیچ هوک عمومی‌ای برای گرفتن خودکار *همه‌ی* خطاهای لوا
-- (چیزهایی که به‌صورت متن قرمز تو کنسول سرور چاپ می‌شن) نداره؛ این یه
-- محدودیت خود پلتفرمه. بهترین معادل عملی همینه: هر ایونت/کالبک حساس رو
-- با pcall بپیچیم، و اگه خطا داد، به‌جای اینکه فقط تو کنسول چاپ بشه،
-- کامل (با پیام خطا + پشته‌ی صدازدن‌ها) به دیسکورد و سایت هم بره.
--
-- استفاده تو همین ریسورس یا هر ریسورس دیگه (چون export شده):
--   SafeCall('اسم توضیحی این کار', function() ... کد اصلی ... end)
-- یا برای پیچیدن مستقیم یه event handler:
--   RegisterServerEvent('my:event')
--   AddEventHandler('my:event', SafeWrap('my:event', function(arg1, arg2) ... end))

local ErrorCooldown = {}

function SafeCall(context, fn, ...)
	local args = {...}
	local ok, err = pcall(function() return fn(table.unpack(args)) end)
	if not ok then
		local traceback = debug.traceback('', 2)
		print(('^1[ERROR]^0 [%s] %s\n%s'):format(tostring(context), tostring(err), tostring(traceback)))

		-- جلوگیری از اسپم: اگه دقیقاً همون خطا تو ۱۰ ثانیه‌ی اخیر لاگ شده، دوباره نفرست
		local key = tostring(context) .. '|' .. tostring(err)
		local now = GetGameTimer()
		if not ErrorCooldown[key] or (now - ErrorCooldown[key]) > 10000 then
			ErrorCooldown[key] = now
			local desc = '```css\n[ Context : '..tostring(context)..' ]\n[ Error : '..tostring(err)..' ]\n[ Resource : '..tostring(GetInvokingResource() or GetCurrentResourceName())..' ]\n```'
			TriggerEvent('DiscordBot:ToDiscord', 'servererror', 'ServerErrorLog', desc, 'user', true, nil, false)
			-- برای دیباگ عمیق‌تر، traceback کامل مستقیم به سایت می‌ره (متن طولانی رو دیسکورد قبول نمی‌کنه)
			SendToSite('servererror', 'ServerErrorLog', desc .. '\n\nTraceback:\n' .. tostring(traceback), nil)
		end
	end
	return ok, err
end

-- یه wrapper که میشه مستقیم به‌عنوان خودِ callback یه AddEventHandler/RegisterCommand پاس داد
function SafeWrap(context, fn)
	return function(...)
		SafeCall(context, fn, ...)
	end
end

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
	TriggerEvent('DiscordBot:ToDiscord', 'kill', SystemName, Message .. ' `' .. date.day .. '.' .. date.month .. '.' .. date.year .. ' - ' .. date.hour .. ':' .. date.min .. ':' .. date.sec .. '`', SystemAvatar, true, Deader, false)
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

	-- دسته‌بندی خام (مثل "gp", "kill", "amoney", ...) رو قبل از تبدیل به URL دیسکورد نگه می‌داریم
	-- تا برای سایت خودمون هم به‌عنوان category بفرستیمش
	local category = 'unknown'
	if type(WebHook) == 'string' then
		category = WebHook:lower()
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
		elseif WebHook:lower() == "vehiclecrash" then
			WebHook = DiscordWebhookVehicleCrash
		elseif WebHook:lower() == "nonlethalshot" then
			WebHook = DiscordWebhookNonLethalShot
		elseif WebHook:lower() == "carjack" then
			WebHook = DiscordWebhookCarJack
		elseif WebHook:lower() == "nczenter" then
			WebHook = DiscordWebhookNCZEnter
		elseif WebHook:lower() == "lockpick" then
			WebHook = DiscordWebhookLockpick
		elseif WebHook:lower() == "explosion" then
			WebHook = DiscordWebhookExplosion
		elseif WebHook:lower() == "drowning" then
			WebHook = DiscordWebhookDrowning
		elseif WebHook:lower() == "hardfall" then
			WebHook = DiscordWebhookHardFall
		elseif WebHook:lower() == "cuffescape" then
			WebHook = DiscordWebhookCuffEscape
		elseif WebHook:lower() == "servererror" then
			WebHook = DiscordWebhookServerError
		elseif WebHook:lower() == "clienterror" then
			WebHook = DiscordWebhookClientError
		elseif WebHook:lower() == "manage" then
			WebHook = DiscordWebhookManage
		elseif WebHook:lower() == "adminmenu" then
			WebHook = DiscordWebhookAdminMenu
		end

		if Image:lower() == 'steam' then
			Image = UserAvatar
			if GetIDFromSource('steam', Source) then
				PerformHttpRequest('http://steamcommunity.com/profiles/' .. tonumber(GetIDFromSource('steam', Source), 16) .. '/?xml=1', function(Error, Content, Head)
					local SteamProfileSplitted = stringsplit(Content, '\n')
					for i, Line in ipairs(SteamProfileSplitted) do
						if Line:find('<avatarFull>') then
							Image = Line:gsub('	<avatarFull><!%[CDATA%[', ''):gsub(']]></avatarFull>', '')
							PerformHttpRequest(WebHook, function(Error, Content, Head) end, 'POST', json.encode({username = Name, content = Message, avatar_url = Image, tts = TTS}), {['Content-Type'] = 'application/json'})
							SendToSite(category, Name, Message, Source)
							return
						end
					end
				end)
				return
			end
		elseif Image:lower() == 'user' then
			Image = UserAvatar
		else
			Image = SystemAvatar
		end
	end

	if WebHook and WebHook ~= '' and WebHook ~= 'WEBHOOK_LINK_HERE' then
		PerformHttpRequest(WebHook, function(Error, Content, Head) end, 'POST', json.encode({username = Name, content = Message, avatar_url = Image, tts = TTS}), {['Content-Type'] = 'application/json'})
	end

	-- همون لاگ عیناً به سایت خودمون هم فرستاده میشه تا هیچی گم نشه
	SendToSite(category, Name, Message, Source)
end)

-- ================= ارسال به سایت خودمون =================
-- هر لاگی که به دیسکورد میره، از این تابع هم برای آرشیو روی سایت رد میشه.
function SendToSite(category, name, message, source)
	if not SiteLogWebhook or SiteLogWebhook == '' or SiteLogWebhook == 'WEBHOOK_LINK_HERE' then
		return
	end

	local identifier = nil
	local playerName = nil
	if source and tonumber(source) then
		playerName = GetPlayerName(tonumber(source))
		identifier = GetPlayerIdentifier(tonumber(source), 0) or GetPlayerIdentifier(tonumber(source), 1)
	end

	local payload = {
		category    = category,
		name        = name,
		message     = message,
		source      = source,
		playerName  = playerName,
		identifier  = identifier,
		server_time = os.time(),
	}

	PerformHttpRequest(SiteLogWebhook, function(Error, Content, Head)
		if Error ~= 200 and Error ~= 201 and Error ~= 204 then
			print(('[SiteLog] Failed to send log (category=%s) to site. HTTP status: %s'):format(tostring(category), tostring(Error)))
		end
	end, 'POST', json.encode(payload), { ['Content-Type'] = 'application/json' })
end

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

-- ============================================================================
-- لاگ‌های ریز: NCZ، شلیک بدون کشتن، دزدیدن ماشین، تصادف شدید
-- ============================================================================
RegisterServerEvent('EventLogs:NCZEnter')
AddEventHandler('EventLogs:NCZEnter', SafeWrap('EventLogs:NCZEnter', function(zoneName)
	local _source = source
	local desc = '```css\n[ Player : '..GetPlayerName(_source)..'(' .. _source .. ') ]\n[ Zone : '..tostring(zoneName)..' ]\n```'
	TriggerEvent('DiscordBot:ToDiscord', 'nczenter', 'NCZEnterLog', desc, 'user', true, _source, false)
end))

RegisterServerEvent('EventLogs:NonLethalShot')
AddEventHandler('EventLogs:NonLethalShot', SafeWrap('EventLogs:NonLethalShot', function(attackerServerId, boneName, weaponName)
	local _source = source
	local victimName = GetPlayerName(_source) or 'Unknown'
	local attackerName = (attackerServerId and GetPlayerName(attackerServerId)) or 'Unknown'

	local desc = '```css\n[ Shooter : '..attackerName..'(' .. tostring(attackerServerId) .. ') ]\n[ Victim : '..victimName..'(' .. _source .. ') ]\n[ Hit Location : '..tostring(boneName)..' ]\n[ Weapon : '..tostring(weaponName)..' ]\n[ Result : Survived ]\n```'
	TriggerEvent('DiscordBot:ToDiscord', 'nonlethalshot', 'NonLethalShotLog', desc, 'user', true, _source, false)
end))

RegisterServerEvent('EventLogs:CarJacked')
AddEventHandler('EventLogs:CarJacked', SafeWrap('EventLogs:CarJacked', function(victimDriverServerId, plate, model)
	local _source = source
	local jackerName = GetPlayerName(_source) or 'Unknown'
	local victimName = (victimDriverServerId and GetPlayerName(victimDriverServerId)) or 'Unknown'

	local desc = '```css\n[ Jacker : '..jackerName..'(' .. _source .. ') ]\n[ Victim (Driver) : '..victimName..'(' .. tostring(victimDriverServerId) .. ') ]\n[ Vehicle : '..tostring(model)..' | Plate: '..tostring(plate)..' ]\n```'
	TriggerEvent('DiscordBot:ToDiscord', 'carjack', 'CarJackLog', desc, 'user', true, _source, false)
end))

RegisterServerEvent('EventLogs:VehicleCrash')
AddEventHandler('EventLogs:VehicleCrash', SafeWrap('EventLogs:VehicleCrash', function(plate, model, coords, impactKmh)
	local _source = source
	local desc = '```css\n[ Driver : '..GetPlayerName(_source)..'(' .. _source .. ') ]\n[ Vehicle : '..tostring(model)..' | Plate: '..tostring(plate)..' ]\n[ Impact Speed : ~'..tostring(impactKmh)..' km/h ]\n[ Coords : '..tostring(coords)..' ]\n```'
	TriggerEvent('DiscordBot:ToDiscord', 'vehiclecrash', 'VehicleCrashLog', desc, 'user', true, _source, false)
end))

RegisterServerEvent('EventLogs:VehicleExploded')
AddEventHandler('EventLogs:VehicleExploded', SafeWrap('EventLogs:VehicleExploded', function(plate, model, coords)
	local _source = source
	local desc = '```css\n[ Reported By : '..GetPlayerName(_source)..'(' .. _source .. ') ]\n[ Vehicle : '..tostring(model)..' | Plate: '..tostring(plate)..' ]\n[ Coords : '..tostring(coords)..' ]\n```'
	TriggerEvent('DiscordBot:ToDiscord', 'vehiclecrash', 'VehicleExplosionLog', desc, 'user', true, _source, false)
end))

RegisterServerEvent('EventLogs:ClientError')
AddEventHandler('EventLogs:ClientError', SafeWrap('EventLogs:ClientError', function(context, err)
	local _source = source
	local key = tostring(_source) .. '|' .. tostring(context) .. '|' .. tostring(err)
	local now = GetGameTimer()
	ErrorCooldown = ErrorCooldown or {}
	if ErrorCooldown[key] and (now - ErrorCooldown[key]) < 10000 then
		return
	end
	ErrorCooldown[key] = now

	local desc = '```css\n[ Player : '..(GetPlayerName(_source) or 'Unknown')..'(' .. _source .. ') ]\n[ Context : '..tostring(context)..' ]\n[ Error : '..tostring(err)..' ]\n```'
	TriggerEvent('DiscordBot:ToDiscord', 'clienterror', 'ClientErrorLog', desc, 'user', true, _source, false)
end))

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