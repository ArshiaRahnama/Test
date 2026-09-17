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
AddEventHandler('DiscordBot:plascaryyerDied', SafeWrap('DiscordBot:plascaryyerDied', function(Message, killer, Deader, Weapon, KillerCorrd, PlayerCorrd)
	-- ✅ محافظ دفاعی: اگه به هر دلیلی (باگ کلاینت، یا یه ریسورس دیگه که این ایونت رو صدا
	-- می‌زنه) Deader خالی برسه، به‌جای کرش‌کردن رو getkillers[Deader]، بیفت رو source همین
	-- ایونت (که همیشه همون پلیریه که مرده، چون کلاینت خودش این ایونت رو موقع مرگ خودش می‌زنه)
	Deader = tonumber(Deader) or source
	local date = os.date('*t')
	local xPlayer = ESX.GetPlayerFromId(Deader)
	local xTarget = killer and ESX.GetPlayerFromId(killer) or nil
	local Wep = Weapon or 'Null'
	getkillers[Deader] = tostring(killer or 'N/A').." ^0) Ba WEAPON :(^1"..Wep.."^0"
	if date.day < 10 then date.day = '0' .. tostring(date.day) end
	if date.month < 10 then date.month = '0' .. tostring(date.month) end
	if date.hour < 10 then date.hour = '0' .. tostring(date.hour) end
	if date.min < 10 then date.min = '0' .. tostring(date.min) end
	if date.sec < 10 then date.sec = '0' .. tostring(date.sec) end
	if Weapon then
		local killerName    = (xTarget and xTarget.name) or 'Unknown/Environment'
		local killerSource   = (xTarget and xTarget.source) or tostring(killer or 'N/A')
		local killerSteam    = (xTarget and xTarget.identifier) or 'N/A'
		local deaderName     = (xPlayer and xPlayer.name) or 'Unknown'
		local deaderSourceId = (xPlayer and xPlayer.source) or tostring(Deader)
		local deaderSteam    = (xPlayer and xPlayer.identifier) or 'N/A'

		Message = "```Player : "..deaderName.." ("..deaderSourceId..") \n".."Steam : "..deaderSteam.."\n"..tostring(PlayerCorrd).."\n **Tavasote:**\nPlayer : "..killerName.." ("..killerSource..")\nSteam : "..killerSteam.."\n"..tostring(KillerCorrd).."\n Weapon : "..Weapon.."\n Reason : "..tostring(Message).."```"

		-- ✅ اضافه شد (راند سوم): RDM Pattern Detector - فقط وقتی قاتل واقعاً یه پلیرِ متصله
		-- (xTarget معتبره)، نه NPC/محیط. فقط لاگ برای بررسی دستی، هیچ بن/کیک خودکاری نداره.
		if xTarget and killer and tonumber(killer) then
			local killerId = tonumber(killer)
			rdmKillTracker = rdmKillTracker or {}
			rdmWarnedUntil = rdmWarnedUntil or {}

			rdmKillTracker[killerId] = rdmKillTracker[killerId] or {}
			table.insert(rdmKillTracker[killerId], { victim = Deader, time = GetGameTimer() })

			-- پاک‌سازی رکوردهای قدیمی‌تر از بازه‌ی زمانی و شمارش قربانی‌های متفاوت
			local window = Config.RDMWindowMs or 90000
			local now = GetGameTimer()
			local kept, distinctVictims = {}, {}
			for _, entry in ipairs(rdmKillTracker[killerId]) do
				if (now - entry.time) <= window then
					table.insert(kept, entry)
					distinctVictims[entry.victim] = true
				end
			end
			rdmKillTracker[killerId] = kept

			local distinctCount = 0
			for _ in pairs(distinctVictims) do distinctCount = distinctCount + 1 end

			if distinctCount >= (Config.RDMVictimThreshold or 3) and (not rdmWarnedUntil[killerId] or now > rdmWarnedUntil[killerId]) then
				rdmWarnedUntil[killerId] = now + 120000 -- تا ۲ دقیقه دوباره اسپم نده
				local desc = '```css\n[ Player : '..killerName..'(' .. killerId .. ') ]\n[ Distinct Victims : '..distinctCount..' in ~'..math.floor(window/1000)..'s ]\n[ Note : Possible RDM pattern - needs manual review, NOT auto-banned ]\n```'
				TriggerEvent('DiscordBot:ToDiscord', 'rdmpattern', 'RDMPatternLog', desc, 'user', true, killerId, false)
			end
		end
	end

	-- ✅ اضافه شد (راند سوم): برای تشخیص New Life Rule، محل و زمان این مرگ رو ذخیره می‌کنیم
	lastDeathInfo[Deader] = { coords = PlayerCorrd, time = GetGameTimer() }
	nlrFlaggedForDeath[Deader] = nil -- بازه‌ی جدید شروع شد، اجازه بده دوباره چک بشه

	-- ✅ اضافه شد: مرگ‌های غرق‌شدگی (WEAPON_DROWNING / WEAPON_DROWNING_IN_VEHICLE) دیگه با بقیه‌ی
	-- کشته‌شدن‌ها قاطی وبهوک/کانال «کشتن» عمومی نمی‌شن؛ چون Config.lua از قبل یه Convar جدا
	-- (DiscordWebhookDrowning) براش داشت که تا الان هیچ‌وقت واقعاً استفاده نمی‌شد.
	-- توجه: تو مسیر «مرد/خودکشی» (DeathReason == 'died'/'committed suicide')، پارامتر killer
	-- همون اسم خوانای اسلحه‌ست (چون کلاینت فقط دوتا آرگومان می‌فرسته)، نه یه Source عددی؛
	-- تو مسیر «کشته‌شدن توسط کسی/چیزی» هم Weapon همون اسمه. هر دو حالت رو چک می‌کنیم.
	local category = 'kill'
	local weaponLabel = tostring(killer or Weapon or '')
	if weaponLabel:find('Drowning') then
		category = 'drowning'
	end

	TriggerEvent('DiscordBot:ToDiscord', category, SystemName, Message .. ' `' .. date.day .. '.' .. date.month .. '.' .. date.year .. ' - ' .. date.hour .. ':' .. date.min .. ':' .. date.sec .. '`', SystemAvatar, true, Deader, false)
end))

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

	-- ✅ باگ فیکس شد: playerConnecting/playerDropped مستقیم لینک وبهوک (DiscordConnect/
	-- DiscordDisconnect) رو به‌عنوان WebHook می‌فرستن، نه یه اسم دسته (چون External=false
	-- ـه و نیازی به روتینگ ندارن). بدون این فیکس، ستون category تو دیتابیس/پنل پر می‌شد
	-- از خودِ URL کامل وبهوک دیسکورد (یا رشته‌ی خالی، تا وقتی ست نشده) به‌جای یه اسم تمیز؛
	-- که هم تو UI پنل زشت به‌نظر می‌رسید هم فیلتر/گروه‌بندی دسته‌ای رو خراب می‌کرد.
	if WebHook == DiscordConnect then
		category = 'connect'
	elseif WebHook == DiscordDisconnect then
		category = 'disconnect'
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
		-- ✅ اضافه شد: دو دسته‌ی کاملاً جدید (قبلاً اصلاً وجود نداشتن)
		elseif WebHook:lower() == "afk" then
			WebHook = DiscordWebhookAFK
		elseif WebHook:lower() == "anticheat" then
			WebHook = DiscordWebhookAntiCheat
		-- ✅ اضافه شد (راند دوم): سه دسته‌ی جدید دیگه
		elseif WebHook:lower() == "illegalweapon" then
			WebHook = DiscordWebhookIllegalWeapon
		elseif WebHook:lower() == "explosiveused" then
			WebHook = DiscordWebhookExplosiveUsed
		elseif WebHook:lower() == "safezoneshot" then
			WebHook = DiscordWebhookSafezoneShot
		-- ✅ اضافه شد (راند سوم)
		elseif WebHook:lower() == "sidewalkdanger" then
			WebHook = DiscordWebhookSidewalkDanger
		elseif WebHook:lower() == "combatlog" then
			WebHook = DiscordWebhookCombatLog
		elseif WebHook:lower() == "rdmpattern" then
			WebHook = DiscordWebhookRDMPattern
		elseif WebHook:lower() == "nlrviolation" then
			WebHook = DiscordWebhookNLRViolation
		elseif WebHook:lower() == "fakename" then
			WebHook = DiscordWebhookFakeName
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
	local identifier = nil
	local playerName = nil
	local job = nil
	if source and tonumber(source) then
		playerName = GetPlayerName(tonumber(source))
		identifier = GetPlayerIdentifier(tonumber(source), 0) or GetPlayerIdentifier(tonumber(source), 1)
		if ESX then
			local xPlayer = ESX.GetPlayerFromId(tonumber(source))
			if xPlayer and xPlayer.job then
				job = xPlayer.job.name
			end
		end
	end

	-- ================= ذخیره تو دیتابیس (منبع اصلی پنل ادمین/باس) =================
	if MySQL and MySQL.Async then
		MySQL.Async.execute(
			'INSERT INTO unique_logpanel (category, job, title, message, source, identifier, player_name) VALUES (@category, @job, @title, @message, @source, @identifier, @player_name)',
			{
				['@category']    = tostring(category or 'unknown'),
				['@job']         = job,
				['@title']       = tostring(name or ''),
				['@message']     = tostring(message or ''),
				['@source']      = source and tonumber(source) or nil,
				['@identifier']  = identifier,
				['@player_name'] = playerName,
			}
		)
	end

	-- ================= ارسال به سایت خارجی (اختیاری) =================
	if not SiteLogWebhook or SiteLogWebhook == '' or SiteLogWebhook == 'WEBHOOK_LINK_HERE' then
		return
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
		-- توجه: از وقتی Unique_LogPanel اضافه شده، منبع اصلی لاگ‌ها همون جدول
		-- دیتابیسه (بالاتر همین تابع) که پنل مستقیم ازش می‌خونه؛ این POST بیرونی
		-- صرفاً یه کپی اضافیه برای سایت خودتونه. اگه اون سایت جواب خطا بده،
		-- دیگه لازم نیست تو کنسول سرور اسپم بشه (SiteDebugMode رو تو Config.lua
		-- می‌تونی true کنی اگه خواستی دوباره این خطاها رو ببینی).
		if SiteDebugMode and Error ~= 200 and Error ~= 201 and Error ~= 204 then
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
		coordsatacer = coordsatacer,
		time = GetGameTimer() -- ✅ اضافه شد: برای تشخیص Combat Log لازمه بدونیم دیمج «کِی» خورده
    })

    if #lastDamagers[victimId] > 5 then
        table.remove(lastDamagers[victimId], 6)
    end
end)

-- ============================================================================
-- ✅ اضافه شد (راند سوم): Combat Log تشخیص خودکار
-- ============================================================================
-- توجه: چون lastDamagers بالاتر از handler اصلیِ playerDropped (نزدیک ابتدای فایل)
-- تعریف نشده بود، یه AddEventHandler جدا و مستقل برای همین event ثبت می‌کنیم
-- (FiveM اجازه می‌ده چندتا handler روی یه event باشه؛ هر دو اجرا می‌شن، تداخلی نداره).
-- فقط لاگ می‌کنه - هیچ بن/کیکی نمی‌زنه (چون پلیر که دیسکانکت شده دیگه چیزی نمی‌شه بهش زد،
-- ولی این لاگ برای بررسی دستیِ ادمین موقع وصل‌شدن دوباره‌ی همون پلیره).
function isPoliceJob(jobName)
	if not jobName then return false end
	for _, j in ipairs(Config.PoliceJobs or {}) do
		if j == jobName then return true end
	end
	return false
end

AddEventHandler('playerDropped', SafeWrap('EventLogs:CombatLogCheck', function(Reason)
	local _source = source
	local lastHit = lastDamagers[_source] and lastDamagers[_source][1]
	if not lastHit or not lastHit.time then return end

	local elapsed = GetGameTimer() - lastHit.time
	if elapsed > (Config.CombatLogWindowMs or 45000) then return end -- خیلی وقته دیمج نخورده، ربطی نداره

	-- نزدیک‌ترین افسر پلیس آنلاین به مختصات لحظه‌ی آخرین دیمج (اگه پلیسی باشه)
	local nearestCopDist, nearestCopName = nil, nil
	if lastHit.coords then
		for _, plyIdStr in ipairs(GetPlayers()) do
			local plyId = tonumber(plyIdStr)
			local xT = ESX.GetPlayerFromId(plyId)
			if xT and xT.job and isPoliceJob(xT.job.name) then
				local tPed = GetPlayerPed(plyId)
				if tPed and tPed ~= 0 then
					local dist = #(lastHit.coords - GetEntityCoords(tPed))
					if not nearestCopDist or dist < nearestCopDist then
						nearestCopDist = dist
						nearestCopName = GetPlayerName(plyId)
					end
				end
			end
		end
	end

	local copInfo = 'کسی نزدیک نبود'
	if nearestCopDist then
		copInfo = nearestCopName .. ' (~' .. math.floor(nearestCopDist) .. ' متری)'
	end

	local desc = '```css\n[ Player : '..GetPlayerName(_source)..'(' .. _source .. ') ]\n[ Disconnect Reason : '..tostring(Reason)..' ]\n[ Time Since Last Hit : ~'..math.floor(elapsed/1000)..'s ]\n[ Last Attacker : '..tostring(lastHit.attackerId)..' ]\n[ Nearest Cop : '..copInfo..' ]\n[ Note : Suspected combat-log (disconnected shortly after taking damage) ]\n```'
	TriggerEvent('DiscordBot:ToDiscord', 'combatlog', 'CombatLogSuspectedLog', desc, 'user', false, _source, false)
end))

-- ============================================================================
-- ✅ اضافه شد (راند سوم): New Life Rule Violation (برگشتن به محل مرگ قبلی)
-- ============================================================================
-- محدودیت صادقانه: چون این ریسورس به سیستم ریوایو (ambulance job و غیره) وصل نیست،
-- "زمان مرگ" رو به‌جای "زمان ریوایو" مبنا می‌گیریم - تقریب منطقی و کافی برای اکثر سرورها.
-- کلاینت هر ۲۰ ثانیه موقعیتش رو با این event گزارش می‌ده (توی EventLogs.lua).
-- توجه: این دو تا global هستن (نه local) چون پرشدنشون تو handler دیگه‌ای بالاتر تو همین
-- فایل (DiscordBot:plascaryyerDied) اتفاق می‌افته؛ globalبودن یعنی ترتیب تعریف مهم نیست.
lastDeathInfo = {}
nlrFlaggedForDeath = {}

RegisterServerEvent('EventLogs:PositionPing')
AddEventHandler('EventLogs:PositionPing', SafeWrap('EventLogs:PositionPing', function(coords)
	local _source = source
	local death = lastDeathInfo[_source]
	if not death or nlrFlaggedForDeath[_source] then return end

	local elapsed = GetGameTimer() - death.time
	if elapsed > (Config.NLRWindowMs or 600000) then
		lastDeathInfo[_source] = nil -- دیگه بازه‌ش تموم شده، پاکش کن
		return
	end

	local dist = #(coords - death.coords)
	if dist < (Config.NLRRadius or 100.0) then
		nlrFlaggedForDeath[_source] = true
		local desc = '```css\n[ Player : '..GetPlayerName(_source)..'(' .. _source .. ') ]\n[ Death Coords : '..tostring(death.coords)..' ]\n[ Returned After : ~'..math.floor(elapsed/1000)..'s ]\n[ Distance From Death : ~'..math.floor(dist)..'m ]\n[ Note : Possible New Life Rule violation ]\n```'
		TriggerEvent('DiscordBot:ToDiscord', 'nlrviolation', 'NLRViolationLog', desc, 'user', true, _source, false)
	end
end))

-- ============================================================================
-- ✅ اضافه شد (راند سوم): جعل هویت استاف تو چت (Fake Name)
-- ============================================================================
-- توجه: کلماتِ Config.BannedNameWords رو با substring چک می‌کنیم؛ اگه گوینده خودش
-- واقعاً permission_level داشته باشه (استاف واقعیه) کاملاً نادیده گرفته می‌شه.
AddEventHandler('chatMessage', SafeWrap('EventLogs:FakeNameCheck', function(source, name, message)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	local isRealStaff = xPlayer and xPlayer.permission_level and xPlayer.permission_level >= 1
	if isRealStaff then return end

	local lowerMsg = tostring(message or ''):lower()
	for _, word in ipairs(Config.BannedNameWords or {}) do
		if lowerMsg:find(word:lower(), 1, true) then
			local desc = '```css\n[ Player : '..GetPlayerName(_source)..'(' .. _source .. ') ]\n[ Matched Word : '..word..' ]\n[ Message : '..tostring(message)..' ]\n[ Note : Sender is NOT actual staff (permission_level < 1) ]\n```'
			TriggerEvent('DiscordBot:ToDiscord', 'fakename', 'FakeNameLog', desc, 'user', true, _source, false)
			break -- یه کلمه کافیه، نیازی به گزارش تکراری برای همون پیام نیست
		end
	end
end))

-- Export سرور برای اسکریپت‌های ساخت کاراکتر/چندشخصیتی که بخوان اسم انتخابی رو هم چک کنن:
--   exports['logs']:CheckNameForImpersonation(source, 'John Admin Smith')
exports('CheckNameForImpersonation', function(targetSource, fullName)
	local xPlayer = ESX.GetPlayerFromId(targetSource)
	local isRealStaff = xPlayer and xPlayer.permission_level and xPlayer.permission_level >= 1
	if isRealStaff then return false end

	local lowerName = tostring(fullName or ''):lower()
	for _, word in ipairs(Config.BannedNameWords or {}) do
		if lowerName:find(word:lower(), 1, true) then
			local desc = '```css\n[ Player : '..GetPlayerName(targetSource)..'(' .. targetSource .. ') ]\n[ Character Name : '..tostring(fullName)..' ]\n[ Matched Word : '..word..' ]\n```'
			TriggerEvent('DiscordBot:ToDiscord', 'fakename', 'FakeNameLog', desc, 'user', true, targetSource, false)
			return true
		end
	end
	return false
end)

-- ============================================================================
-- ✅ اضافه شد (راند سوم): رانندگی خطرناک روی پیاده‌رو نزدیک NPC
-- ============================================================================
RegisterServerEvent('EventLogs:SidewalkDanger')
AddEventHandler('EventLogs:SidewalkDanger', SafeWrap('EventLogs:SidewalkDanger', function(plate, model, speedKmh, pedCount, coords)
	local _source = source
	local desc = '```css\n[ Driver : '..GetPlayerName(_source)..'(' .. _source .. ') ]\n[ Vehicle : '..tostring(model)..' | Plate: '..tostring(plate)..' ]\n[ Speed : ~'..tostring(speedKmh)..' km/h ]\n[ Nearby Pedestrians : '..tostring(pedCount)..' ]\n[ Coords : '..tostring(coords)..' ]\n[ Note : Off-road (sidewalk-like) at high speed near pedestrians ]\n```'
	TriggerEvent('DiscordBot:ToDiscord', 'sidewalkdanger', 'SidewalkDangerLog', desc, 'user', true, _source, false)
end))

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

-- ============================================================================
-- ✅ اضافه شد: لاگ‌های ریزِ جدید
-- شش تای اول (Lockpick, CuffEscape, TireBurst, VehicleEntry, HardFall) از قبل
-- Convar و مسیر وبهوکشون تو Config.lua آماده بود ولی هیچ‌وقت هیچ event ای
-- بهشون وصل نشده بود - یعنی این دسته‌ها عملاً "مرده" بودن. دو تای آخر
-- (AFKKick, AntiCheatAnomaly) کاملاً جدیدن.
-- ============================================================================

-- قفل‌بازکردن ماشین: چون خودِ مینی‌گیم لاک‌پیک معمولاً تو یه ریسورس جدا پیاده‌سازی
-- می‌شه (مثل qb-lockpick / esx_advancedlockpicksystem / اسکریپت اختصاصی سرور)، این
-- ریسورس فقط event رو می‌گیره و لاگ می‌کنه؛ کافیه از هر ریسورس دیگه بعد از موفق یا
-- ناموفق‌شدن مینی‌گیم این خط رو بزنی:
--   TriggerServerEvent('EventLogs:Lockpick', GetVehicleNumberPlateText(veh), GetDisplayNameFromVehicleModel(GetEntityModel(veh)), true/false)
RegisterServerEvent('EventLogs:Lockpick')
AddEventHandler('EventLogs:Lockpick', SafeWrap('EventLogs:Lockpick', function(plate, model, success)
	local _source = source
	local desc = '```css\n[ Player : '..GetPlayerName(_source)..'(' .. _source .. ') ]\n[ Vehicle : '..tostring(model)..' | Plate: '..tostring(plate)..' ]\n[ Result : '..(success and 'Success' or 'Failed')..' ]\n```'
	TriggerEvent('DiscordBot:ToDiscord', 'lockpick', 'LockpickLog', desc, 'user', true, _source, false)
end))

-- فرار از دستبند: مثل بالا، خودِ سیستم دستبند (esx_policejob یا مشابه) باید صدا بزنه:
--   TriggerServerEvent('EventLogs:CuffEscape', coords)
-- وقتی تشخیص بده یه پلیرِ دستبندزده، بدون آزادسازیِ رسمیِ افسر، آزاد شده.
RegisterServerEvent('EventLogs:CuffEscape')
AddEventHandler('EventLogs:CuffEscape', SafeWrap('EventLogs:CuffEscape', function(coords)
	local _source = source
	local desc = '```css\n[ Player : '..GetPlayerName(_source)..'(' .. _source .. ') ]\n[ Coords : '..tostring(coords)..' ]\n[ Note : Escaped handcuffs without official release ]\n```'
	TriggerEvent('DiscordBot:ToDiscord', 'cuffescape', 'CuffEscapeLog', desc, 'user', true, _source, false)
end))

-- ترکیدن لاستیک ماشینی که پلیر داخلشه (چه با گلوله، چه با خاراندن/تصادف) - خودِ کلاینت تشخیص می‌ده
RegisterServerEvent('EventLogs:TireBurst')
AddEventHandler('EventLogs:TireBurst', SafeWrap('EventLogs:TireBurst', function(plate, model, wheelIndex, coords)
	local _source = source
	local desc = '```css\n[ Driver : '..GetPlayerName(_source)..'(' .. _source .. ') ]\n[ Vehicle : '..tostring(model)..' | Plate: '..tostring(plate)..' ]\n[ Wheel Index : '..tostring(wheelIndex)..' ]\n[ Coords : '..tostring(coords)..' ]\n```'
	TriggerEvent('DiscordBot:ToDiscord', 'tirelog', 'TireBurstLog', desc, 'user', true, _source, false)
end))

-- ورود مشکوک به ماشین: پلیر سوار ماشینی شده که چند ثانیه قبل قفل بوده (بدون اینکه
-- Lockpick رسمی ثبت شده باشه) - یعنی یا با ابزار دیگه‌ای باز شده یا از یه باگ/اکسپلویت.
RegisterServerEvent('EventLogs:VehicleEntry')
AddEventHandler('EventLogs:VehicleEntry', SafeWrap('EventLogs:VehicleEntry', function(plate, model, coords)
	local _source = source
	local desc = '```css\n[ Player : '..GetPlayerName(_source)..'(' .. _source .. ') ]\n[ Vehicle : '..tostring(model)..' | Plate: '..tostring(plate)..' ]\n[ Coords : '..tostring(coords)..' ]\n[ Note : Entered a vehicle that was locked moments earlier ]\n```'
	TriggerEvent('DiscordBot:ToDiscord', 'entervehicle', 'SuspiciousVehicleEntryLog', desc, 'user', true, _source, false)
end))

-- سقوط شدید (فاصله‌ی زیاد + افت زیاد HP بدون مردن) - مثلاً بیس‌جامپ بدون چتر یا پرش از ساختمون
RegisterServerEvent('EventLogs:HardFall')
AddEventHandler('EventLogs:HardFall', SafeWrap('EventLogs:HardFall', function(fallHeight, hpLost, coords)
	local _source = source
	local desc = '```css\n[ Player : '..GetPlayerName(_source)..'(' .. _source .. ') ]\n[ Fall Height : ~'..tostring(fallHeight)..'m ]\n[ HP Lost : '..tostring(hpLost)..' ]\n[ Coords : '..tostring(coords)..' ]\n```'
	TriggerEvent('DiscordBot:ToDiscord', 'hardfall', 'HardFallLog', desc, 'user', true, _source, false)
end))

-- ✅ اصلاح شد (طبق درخواست): این دیگه هیچ‌کس رو کیک نمی‌کنه، فقط لاگ می‌کنه.
-- اسم event/دسته رو عمداً همون AFKKick/afk نگه داشتم تا با Config و کلاینت هماهنگ بمونه،
-- ولی معنیش الان یعنی «گزارشِ بی‌تحرکیِ طولانی»، نه اخراج واقعی.
RegisterServerEvent('EventLogs:AFKKick')
AddEventHandler('EventLogs:AFKKick', SafeWrap('EventLogs:AFKKick', function(idleMinutes)
	local _source = source
	local name = GetPlayerName(_source) or 'Unknown'
	local identifier = GetPlayerIdentifier(_source)
	local desc = '```css\n[ Player : '..name..'(' .. _source .. ') ]\n[ Identifier : '..tostring(identifier)..' ]\n[ Idle Time : ~'..tostring(idleMinutes)..' min ]\n[ Action : Logged Only (no kick) ]\n```'
	TriggerEvent('DiscordBot:ToDiscord', 'afk', 'AFKKickLog', desc, 'user', true, _source, false)
end))

-- ناهنجاری آنتی‌چیت: جابه‌جاییِ غیرطبیعی موقعیت پلیر بین دو تیک (پرش مکانی بزرگ در زمان کوتاه)
-- که می‌تونه نشونه‌ی اسپیدهک/تله‌پورت‌هک/لگ سرور باشه. این فقط لاگ می‌کنه، خودش هیچ اکشنی
-- (کیک/بن) نمی‌زنه چون false-positive (لگ شدید، ری‌کانکت، ماشین سریع) داره؛ تشخیص نهاییش با ادمینه.
RegisterServerEvent('EventLogs:AntiCheatAnomaly')
AddEventHandler('EventLogs:AntiCheatAnomaly', SafeWrap('EventLogs:AntiCheatAnomaly', function(kind, distance, seconds, fromCoords, toCoords)
	local _source = source
	local desc = '```css\n[ Player : '..GetPlayerName(_source)..'(' .. _source .. ') ]\n[ Type : '..tostring(kind)..' ]\n[ Distance : ~'..tostring(distance)..'m in '..tostring(seconds)..'s ]\n[ From : '..tostring(fromCoords)..' ]\n[ To : '..tostring(toCoords)..' ]\n```'
	TriggerEvent('DiscordBot:ToDiscord', 'anticheat', 'AntiCheatLog', desc, 'user', true, _source, false)
end))

-- ============================================================================
-- ✅ اضافه شد (راند دوم): سیگنال‌های آنتی‌چیتِ مبتنی بر فلگ‌های موتور بازی
-- ============================================================================
-- این‌ها نسبت به تشخیص سرعت/تله‌پورت قابل‌اعتمادتر هستن، چون فلگ‌هایی مثل
-- "invincible" یا max-health بالای پیش‌فرض تقریباً هیچ‌وقت به‌خودی‌خود توسط
-- اسکریپت‌های معمولیِ ESX ست نمی‌شن؛ اگه روشن باشن، تقریباً همیشه یعنی یه
-- منوی چیت/تِرینر داره کار می‌کنه. با این‌حال بازم فقط لاگ می‌کنیم نه کیک/بن،
-- چون تصمیم نهایی باید دست ادمین باشه (طبق قانون کلی این ریسورس).
RegisterServerEvent('EventLogs:AntiCheatFlag')
AddEventHandler('EventLogs:AntiCheatFlag', SafeWrap('EventLogs:AntiCheatFlag', function(kind, details, coords)
	local _source = source
	local desc = '```css\n[ Player : '..GetPlayerName(_source)..'(' .. _source .. ') ]\n[ Flag : '..tostring(kind)..' ]\n[ Details : '..tostring(details)..' ]\n[ Coords : '..tostring(coords)..' ]\n```'
	TriggerEvent('DiscordBot:ToDiscord', 'anticheat', 'AntiCheatLog', desc, 'user', true, _source, false)
end))

-- حمل اسلحه‌ی مسدود (طبق Config.IllegalWeapons)
RegisterServerEvent('EventLogs:IllegalWeapon')
AddEventHandler('EventLogs:IllegalWeapon', SafeWrap('EventLogs:IllegalWeapon', function(weaponName, coords)
	local _source = source
	local desc = '```css\n[ Player : '..GetPlayerName(_source)..'(' .. _source .. ') ]\n[ Weapon : '..tostring(weaponName)..' ]\n[ Coords : '..tostring(coords)..' ]\n```'
	TriggerEvent('DiscordBot:ToDiscord', 'illegalweapon', 'IllegalWeaponLog', desc, 'user', true, _source, false)
end))

-- استفاده از اسلحه‌ی انفجاری (صرفاً آدیت - برای بررسی احتمالیِ سوءاستفاده تو منطقه‌ی رول‌پلی)
RegisterServerEvent('EventLogs:ExplosiveUsed')
AddEventHandler('EventLogs:ExplosiveUsed', SafeWrap('EventLogs:ExplosiveUsed', function(weaponName, coords)
	local _source = source
	local desc = '```css\n[ Player : '..GetPlayerName(_source)..'(' .. _source .. ') ]\n[ Weapon : '..tostring(weaponName)..' ]\n[ Coords : '..tostring(coords)..' ]\n```'
	TriggerEvent('DiscordBot:ToDiscord', 'explosiveused', 'ExplosiveUsedLog', desc, 'user', true, _source, false)
end))

-- شلیک داخل محدوده‌ی سیف‌زون (طبق Config.SafeZones)
RegisterServerEvent('EventLogs:SafezoneShot')
AddEventHandler('EventLogs:SafezoneShot', SafeWrap('EventLogs:SafezoneShot', function(zoneName, coords)
	local _source = source
	local desc = '```css\n[ Player : '..GetPlayerName(_source)..'(' .. _source .. ') ]\n[ Zone : '..tostring(zoneName)..' ]\n[ Coords : '..tostring(coords)..' ]\n```'
	TriggerEvent('DiscordBot:ToDiscord', 'safezoneshot', 'SafezoneShotLog', desc, 'user', true, _source, false)
end))

RegisterCommand("getdamage", SafeWrap('getdamage', function(source, args)
    local targetId = tonumber(args[1])
	local xPlayer = ESX.GetPlayerFromId(source)
	-- ✅ باگ فیکس شد: اگه دستور از کنسول سرور (source == 0) یا قبل از لود کامل پلیر تو ESX
	-- اجرا بشه، ESX.GetPlayerFromId می‌تونه nil برگردونه؛ چک قبلی (xPlayer.permission_level)
	-- مستقیم رو nil ایندکس می‌زد و کرش می‌کرد ("attempt to index a nil value").
	if xPlayer and xPlayer.permission_level and xPlayer.permission_level >= 1 then

		if not targetId then
			TriggerClientEvent('chat:addMessage', source, { args = { "Id vared konin" } })
			return
		end

		local damageList = lastDamagers[targetId]
		if damageList and #damageList > 0 then
			for i, dmg in ipairs(damageList) do
				-- ✅ باگ فیکس شد: dmg.coords/dmg.coordsatacer یه vector3 هستن (از
				-- GetEntityCoords)، نه یه Lua table با ایندکس عددی ۱/۲/۳؛ table.unpack
				-- روشون چیزی برنمی‌گردوند (x,y,z همیشه nil می‌شدن) و همین باعث کرش
				-- string.format می‌شد ("number expected, got nil") به‌محض اینکه واقعاً
				-- دیتای دیمج وجود داشت. الان مستقیم از .x/.y/.z می‌خونیم.
				local pt = dmg.coords
				local pa = dmg.coordsatacer
				local x,  y,  z  = (pt and pt.x) or 0.0, (pt and pt.y) or 0.0, (pt and pt.z) or 0.0
				local x2, y2, z2 = (pa and pa.x) or 0.0, (pa and pa.y) or 0.0, (pa and pa.z) or 0.0
				TriggerClientEvent('chat:addMessage', source, {
					args = {
						string.format("[%d] Damage by ID %s | PT: (%.2f, %.2f, %.2f) | PA: (%.2f, %.2f, %.2f)",
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
end), false)