DiscordConnect = GetConvar('unique_logs_DiscordConnect', '')
DiscordDisconnect = GetConvar('unique_logs_DiscordDisconnect', '')
Discordpdrop = GetConvar('unique_logs_Discordpdrop', '')
Discordpjoin = GetConvar('unique_logs_Discordpjoin', '')
DiscordWebhookKillinglogs = GetConvar('unique_logs_DiscordWebhookKillinglogs', '')
DiscordWebhookChat = GetConvar('unique_logs_DiscordWebhookChat', '')
DiscordWebhookPwi = GetConvar('unique_logs_DiscordWebhookPwi', '')
DiscordWebhookDwi = GetConvar('unique_logs_DiscordWebhookDwi', '')
DiscordWebhookloot = GetConvar('unique_logs_DiscordWebhookloot', '')
DiscordWebhookduty = GetConvar('unique_logs_DiscordWebhookduty', '')
DiscordWebhookRob = GetConvar('unique_logs_DiscordWebhookRob', '')
DiscordWebhookInventory = GetConvar('unique_logs_DiscordWebhookInventory', '')
DiscordWebhookJail = GetConvar('unique_logs_DiscordWebhookJail', '')
DiscordWebhookaJail = GetConvar('unique_logs_DiscordWebhookaJail', '')
DiscordWebhookBansystem = GetConvar('unique_logs_DiscordWebhookBansystem', '')
DiscordWebhookBansystemP = GetConvar('unique_logs_DiscordWebhookBansystemP', '')
DiscordWebhookDisband = GetConvar('unique_logs_DiscordWebhookDisband', '')
DiscordWebhookReset = GetConvar('unique_logs_DiscordWebhookReset', '')
DiscordWebhookDrop = GetConvar('unique_logs_DiscordWebhookDrop', '')
DiscordWebhookPickUP = GetConvar('unique_logs_DiscordWebhookPickUP', '')
DiscordWebhookAmoneyLog = GetConvar('unique_logs_DiscordWebhookAmoneyLog', '')
DiscordWebhookTrasferLog = GetConvar('unique_logs_DiscordWebhookTrasferLog', '')
DiscordWebhookNameLog = GetConvar('unique_logs_DiscordWebhookNameLog', '')
DiscordWebhookDID = GetConvar('unique_logs_DiscordWebhookDID', '')
DiscordGivePerm = GetConvar('unique_logs_DiscordGivePerm', '')
DiscordReport = GetConvar('unique_logs_DiscordReport', '')
DiscordAcceptReport = GetConvar('unique_logs_DiscordAcceptReport', '')
DiscordNLR = GetConvar('unique_logs_DiscordNLR', '')
DiscordGangsChangeLog = GetConvar('unique_logs_DiscordGangsChangeLog', '')
DiscordWebhookHome = GetConvar('unique_logs_DiscordWebhookHome', '')
DiscordSetArmor = GetConvar('unique_logs_DiscordSetArmor', '')
DiscordSetGang = GetConvar('unique_logs_DiscordSetGang', '')
DiscordSetJob = GetConvar('unique_logs_DiscordSetJob', '')
DiscordAddCar = GetConvar('unique_logs_DiscordAddCar', '')
DiscordBuyCar = GetConvar('unique_logs_DiscordBuyCar', '')
DiscordSellCar = GetConvar('unique_logs_DiscordSellCar', '')
DiscordRevive = GetConvar('unique_logs_DiscordRevive', '')
DiscordFine = GetConvar('unique_logs_DiscordFine', '')
DiscordHeal = GetConvar('unique_logs_DiscordHeal', '')
additemItem = GetConvar('unique_logs_additemItem', '')
additemWeapon = GetConvar('unique_logs_additemWeapon', '')
DiscordCuff = GetConvar('unique_logs_DiscordCuff', '')
DiscordCuffAll = GetConvar('unique_logs_DiscordCuffAll', '')
DiscordBoss = GetConvar('unique_logs_DiscordBoss', '')
DiscordWebhookStarter = GetConvar('unique_logs_DiscordWebhookStarter', '')
WebhogVehicleSouter = GetConvar('unique_logs_WebhogVehicleSouter', '')
DiscordPutTrunk = GetConvar('unique_logs_DiscordPutTrunk', '')

SystemAvatar = 'https://media.discordapp.net/attachments/669926392921849875/939876376784273458/ServerTest.png'

UserAvatar = ''

SystemName = 'Unique-Log'

SpecialCommands = {
				   {'/ooc', '**[OOC]:**'},
				   {'/911', '**[911]: (CALLER ID: [ USERNAME_NEEDED_HERE | USERID_NEEDED_HERE ])**'},
				  }



BlacklistedCommands = {
					   '/AnyCommand',
					   '/AnyCommand2',
					  }

OwnWebhookCommands = {
					  {'/AnotherCommand', 'WEBHOOK_LINK_HERE'},
					  {'/AnotherCommand2', 'WEBHOOK_LINK_HERE'},
					 }

TTSCommands = {
			   '/Whatever',
			   '/Whatever2',
			  }

-- ✅ اضافه شد: برای لاگ‌های ضد VDM (سیستم Unique_Combat). اگه می‌خوای این لاگ‌ها
-- تو یه کانال جدا از بقیه بره، آدرس وبهوک واقعی دیسکوردت رو (دقیقاً مثل بقیه‌ی
-- خط‌های بالا) جای رشته‌ی خالی زیر بذار. تا وقتی خالی بمونه، خودِ درخواست ارسال
-- می‌شه ولی چون URL نداره شکست می‌خوره - یعنی کرش نمی‌کنه، فقط لاگ ارسال نمیشه.
DiscordWebhookVDM           = GetConvar('unique_logs_DiscordWebhookVDM', '')
DiscordWebhookTireLog       = GetConvar('unique_logs_DiscordWebhookTireLog', '')
DiscordWebhookVehicleEntry  = GetConvar('unique_logs_DiscordWebhookVehicleEntry', '')

-- ================= وبهوک سایت خودمون =================
-- هر لاگی که به دیسکورد فرستاده میشه، عیناً (به‌صورت JSON) به این آدرس هم POST میشه
-- تا هیچ لاگی گم نشه و آرشیو کامل روی سایت خودمون هم باشه.
SiteLogWebhook = GetConvar('unique_logs_SiteLogWebhook', '')

-- ================= لاگ‌های ریز جدید (تصادف، شلیک بدون کشتن، دزدیدن ماشین، NCZ، قفل‌بازکردن، انفجار، غرق‌شدن، سقوط، فرار از دستبند) =================
-- همه از server.cfg خونده می‌شن؛ تا وقتی مقدارشون خالی باشه، فقط سمت سایت لاگ می‌شه (دیسکوردش ساکت fail می‌شه، کرش نمی‌کنه)
DiscordWebhookVehicleCrash   = GetConvar('unique_logs_DiscordWebhookVehicleCrash', '')
DiscordWebhookNonLethalShot  = GetConvar('unique_logs_DiscordWebhookNonLethalShot', '')
DiscordWebhookCarJack        = GetConvar('unique_logs_DiscordWebhookCarJack', '')
DiscordWebhookNCZEnter       = GetConvar('unique_logs_DiscordWebhookNCZEnter', '')
DiscordWebhookLockpick       = GetConvar('unique_logs_DiscordWebhookLockpick', '')
DiscordWebhookExplosion      = GetConvar('unique_logs_DiscordWebhookExplosion', '')
DiscordWebhookDrowning       = GetConvar('unique_logs_DiscordWebhookDrowning', '')
DiscordWebhookHardFall       = GetConvar('unique_logs_DiscordWebhookHardFall', '')
DiscordWebhookCuffEscape     = GetConvar('unique_logs_DiscordWebhookCuffEscape', '')

-- این چهارتا هم قبلاً استفاده می‌شدن ولی هیچوقت اینجا تعریف نشده بودن (یعنی
-- سمت دیسکورد ساکت fail می‌خورد، فقط سمت سایت کار می‌کرد). الان از server.cfg می‌خونن:
DiscordWebhookManage         = GetConvar('unique_logs_DiscordWebhookManage', '')  -- لاگ‌های مدیریتی esx_society (استخدام/اخراج/ترفیع/تلاش‌های مشکوک)
DiscordWebhookAdminMenu      = GetConvar('unique_logs_DiscordWebhookAdminMenu', '')  -- لاگ‌های منوی ادمین + تلاش‌های مشکوک اکشن‌های شغلی (police/ambulance/fbi/cia/...)
DiscordWebhookServerError    = GetConvar('unique_logs_DiscordWebhookServerError', '')  -- کرش/خطای اجراییِ سرور (از SafeCall)
DiscordWebhookClientError    = GetConvar('unique_logs_DiscordWebhookClientError', '')  -- خطای اجراییِ کلاینت که پلیر باعثش شده

