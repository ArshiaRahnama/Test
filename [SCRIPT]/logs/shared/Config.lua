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
-- توجه: از وقتی Unique_LogPanel اضافه شده (مستقیم از دیتابیس می‌خونه)، این وبهوک
-- دیگه لازم نیست مگه یه سایت واقعاً بیرونی خواسته باشی. اگه لینکش رو ست نکنی
-- یا سایتت جواب خطا بده، دیگه هیچ اسپمی تو کنسول سرور ایجاد نمی‌شه.
SiteLogWebhook = GetConvar('unique_logs_SiteLogWebhook', '')
-- فقط برای دیباگ: اگه true کنی، خطاهای HTTP این وبهوک دوباره تو کنسول چاپ می‌شن
SiteDebugMode = GetConvar('unique_logs_SiteDebugMode', 'false') == 'true'

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

-- ✅ اضافه شد: دو دسته‌ی لاگِ کاملاً جدید (قبلاً هیچ Convar/کدی براشون نبود)
DiscordWebhookAFK           = GetConvar('unique_logs_DiscordWebhookAFK', '')        -- گزارش بی‌تحرکی طولانی (AFK) - فقط لاگ
DiscordWebhookAntiCheat     = GetConvar('unique_logs_DiscordWebhookAntiCheat', '')  -- ناهنجاری سرعت/تله‌پورت/گاد/سوپرهلث/آرمور/نامرئی/فشنگ‌بی‌نهایت (همه یه کانال)

-- ✅ اضافه شد (راند دوم): سه دسته‌ی جدیدِ دیگه
DiscordWebhookIllegalWeapon = GetConvar('unique_logs_DiscordWebhookIllegalWeapon', '')  -- حمل اسلحه‌ی مسدود (لیست پایین همین فایل)
DiscordWebhookExplosiveUsed = GetConvar('unique_logs_DiscordWebhookExplosiveUsed', '')  -- استفاده از اسلحه‌ی انفجاری (نارنجک/آر‌پی‌جی/بمب چسبان/مولوتوف)
DiscordWebhookSafezoneShot  = GetConvar('unique_logs_DiscordWebhookSafezoneShot', '')   -- شلیک داخل محدوده‌ی سیف‌زون تعریف‌شده‌ی پایین

-- ✅ اضافه شد (راند سوم): پنج دسته‌ی جدیدِ رول‌پلی/رفتاری - همه فقط لاگ، هیچ اکشن خودکاری ندارن
DiscordWebhookSidewalkDanger = GetConvar('unique_logs_DiscordWebhookSidewalkDanger', '')  -- رانندگی خطرناک روی پیاده‌رو نزدیک NPC
DiscordWebhookCombatLog      = GetConvar('unique_logs_DiscordWebhookCombatLog', '')       -- دیسکانکت مشکوک بعد از دیمج/وسط تعقیب پلیس
DiscordWebhookRDMPattern     = GetConvar('unique_logs_DiscordWebhookRDMPattern', '')      -- الگوی مشکوک کشتن چندنفر غیرمرتبط
DiscordWebhookNLRViolation   = GetConvar('unique_logs_DiscordWebhookNLRViolation', '')    -- برگشتن به محل مرگ قبلی ظرف مدت کوتاه
DiscordWebhookFakeName       = GetConvar('unique_logs_DiscordWebhookFakeName', '')        -- جعل هویت استاف تو چت

-- ============================================================================
-- ✅ اضافه شد: تنظیمات لاگ‌های ریزِ ضدچیت/آدیت جدید
-- برخلاف بقیه‌ی این فایل (که همه Convar متنی‌ان)، اینا جدول Lua هستن چون لیست/چندمقداری‌ان؛
-- مستقیم همینجا ویرایششون کن، نیازی به server.cfg نیست.
-- ============================================================================

-- اسلحه‌هایی که تو سرورت اصلاً نباید کسی داشته باشه (اسم دقیق طبق مستندات نیتیوهای GTA)
Config = Config or {}
Config.IllegalWeapons = {
	'WEAPON_RAILGUN',
	'WEAPON_MINIGUN',
	'WEAPON_RPG',
	'WEAPON_HOMINGLAUNCHER',
	'WEAPON_COMPACTLAUNCHER',
	-- هر اسلحه‌ی دیگه‌ای که تو سرورت باید ممنوع باشه رو همینجا (با همین فرمت) اضافه کن
}

-- محدوده‌های سیف‌زون: هر شلیکی داخل این دایره‌ها جدا لاگ می‌شه (مثلاً دور اسپاون/بانک اصلی/میدون شهر)
-- پیش‌فرض خالیه؛ برای فعال‌کردن، یه مختصات و شعاع (بر حسب متر) بذار:
Config.SafeZones = {
	-- { name = 'اسپاون مرکزی', x = 215.0, y = -810.0, z = 30.0, radius = 60.0 },
}

-- آستانه‌های تشخیص ناهنجاری (پیش‌فرض‌های استاندارد بازی؛ اگه سرورت پرک/جاب خاص با
-- سلامتی/زره بالاتر از پیش‌فرض داره، این عددها رو بالا ببر تا false-positive نده)
Config.AntiCheatMaxHealth = 200   -- سلامتی پیش‌فرض پلیر تو GTA
Config.AntiCheatMaxArmor  = 100   -- زره پیش‌فرض؛ اگه جاب/آیتمی زره رو تا مثلاً ۱۵۰ بالا می‌بره، اینو عوض کن

-- ============================================================================
-- ✅ اضافه شد (راند سوم): پنج لاگِ رول‌پلی/رفتاری جدید
-- هر پنج‌تا فقط لاگ می‌کنن؛ هیچ‌کدوم خودشون کیک/بن نمی‌زنن. تشخیص نهایی همیشه با ادمینه.
-- ============================================================================

-- برای «Combat Log» و «RDM Pattern» لازمه بدونیم کی پلیسه (برای محاسبه‌ی فاصله تا نزدیک‌ترین افسر)
Config.PoliceJobs = { 'police', 'sheriff', 'mt' }

-- رانندگی خطرناک روی پیاده‌رو
Config.SidewalkDangerSpeedKmh = 50.0  -- سرعت (کیلومتر/ساعت) که بالاترش مشکوک می‌شه
Config.SidewalkDangerMinPeds  = 2     -- حداقل تعداد NPC/پلیرِ پیاده‌ی نزدیک برای فلگ‌شدن

-- Combat Log: قطع اتصال ظرف چند ثانیه بعد از خوردن دیمج
Config.CombatLogWindowMs = 45 * 1000  -- اگه ظرف این مدت (میلی‌ثانیه) بعد از آخرین دیمج دیسکانکت بشه، مشکوکه

-- RDM Pattern: کشتن چندنفر غیرمرتبط تو یه بازه‌ی کوتاه
Config.RDMWindowMs        = 90 * 1000  -- بازه‌ی زمانی (میلی‌ثانیه)
Config.RDMVictimThreshold = 3          -- حداقل تعداد قربانیِ متفاوت تو همون بازه برای فلگ‌شدن

-- New Life Rule: برگشتن به محل مرگ قبلی ظرف مدت کوتاه
Config.NLRWindowMs = 10 * 60 * 1000  -- ۱۰ دقیقه
Config.NLRRadius   = 100.0           -- متر

-- Fake Name / جعل هویت استاف: این کلمات تو چت (وقتی گوینده خودش واقعاً استاف نیست) فلگ می‌شن
-- توجه: تطبیق substring و case-insensitive ـه، پس مراقب انتخاب کلمه‌ها باش که خیلی عمومی نباشن
Config.BannedNameWords = {
	'admin', 'ادمین', 'ادمینم',
	'staff', 'استاف',
	'مدیر', 'moderator', 'مدیرکل',
	'owner', 'مالک سرور',
	'developer', 'دولوپر',
}

-- ============================================================================
-- ✅ اضافه شد (راند چهارم): تشخیص چند اکانتی (اشتراک آیدنتیفایر بین چند پلیرِ
-- هم‌زمان آنلاین) + تنظیمات صفحه‌ی پروفایل تجمیعی پلیر تو پنل
-- ============================================================================

-- وقتی دو (یا بیشتر) پلیرِ هم‌زمان آنلاین یکی از این آیدنتیفایرها رو مشترک داشته
-- باشن (یعنی به‌احتمال زیاد یه نفرن که با دو کلاینت جدا وصل شده)، پرچم‌گذاری می‌شه
Config.MultiAccount = {
	Enabled = true,
	-- کدوم نوع آیدنتیفایرها مقایسه بشن. 'license' پایدارترین و قابل‌اعتمادترینه.
	CheckTypes = { 'license', 'license2', 'xbl', 'live', 'discord', 'fivem', 'steam' },
	-- عمداً پیش‌فرض خاموشه: چند نفر پشت یه IP مشترک (خونه/دانشگاه/نت‌کافه/موبایل)
	-- می‌تونن کاملاً بی‌گناه باشن، پس فعال‌کردنش false-positive زیاد می‌ده. اگه
	-- سرورت جمعیت کوچیک/شناخته‌شده داره و می‌خوای سخت‌گیرتر باشه، true کن.
	CheckIP = false,
	-- بعد از یه بار پرچم‌گذاری برای یه جفت پلیرِ خاص، تا این مدت (میلی‌ثانیه) دوباره
	-- گزارش نده (جلوگیری از اسپم دیسکورد موقع relog/دیسکانکت‌شدن‌های پشت‌سرهم)
	CooldownMs = 5 * 60 * 1000,
}
DiscordWebhookMultiAccount = GetConvar('unique_logs_DiscordWebhookMultiAccount', '')  -- چند اکانتی (اشتراک آیدنتیفایر بین پلیرهای آنلاین)

-- صفحه‌ی «پروفایل تجمیعی پلیر» تو پنل (کلیک رو دکمه‌ی 🧾 کنار اسم پلیر) — فقط ادمین
Config.EnableProfileView    = true
Config.ProfileTimelineLimit = 200  -- حداکثر تعداد ردیف تایم‌لاین که برای هر پلیر لود می‌شه



