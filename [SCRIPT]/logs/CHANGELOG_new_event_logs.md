# تغییرات این نسخه — تکمیل و اضافه‌کردن لاگ‌های ریز

## ۱) شش دسته‌ای که «نیمه‌کاره» رها شده بودن، الان کامل شدن
توی کد از قبل Convar وبهوک و مسیر روت‌کردنشون تو `DiscordBot:ToDiscord` آماده بود،
ولی هیچ `RegisterServerEvent` یا تشخیص کلاینتی‌ای صداشون نمی‌زد:

| دسته | چطور الان کار می‌کنه |
|---|---|
| `lockpick` | Export کلاینتی `exports['logs']:ReportLockpick(vehicle, success)` — باید از ریسورس لاک‌پیک واقعی (qb-lockpick / esx_advancedlockpicksystem / اسکریپت اختصاصی) صدا زده بشه |
| `cuffescape` | Export کلاینتی `exports['logs']:ReportCuffEscape()` — باید از سیستم دستبند (پلیس‌جاب) صدا زده بشه |
| `tirelog` | کاملاً خودکار: هر پنچرشدنِ لاستیکِ ماشینی که راننده‌اش پلیره تشخیص داده می‌شه |
| `entervehicle` | کاملاً خودکار: سوارشدن به ماشینی که چند ثانیه‌ی قبل قفل بوده رو لاگ می‌کنه |
| `hardfall` | کاملاً خودکار: سقوط شدید (بیس‌جامپ بدون چتر و مشابه) که HP زیادی کم کرده ولی نکشته |
| `drowning` | مرگ‌های غرق‌شدگی از حالا جدا از لاگ عمومیِ «کشتن» می‌رن، تو کانال/جدول دسته‌ی خودشون |

## ۲) دو دسته‌ی کاملاً جدید (قبلاً اصلاً وجود نداشتن)
- **`afk`** — گزارشِ بی‌تحرکیِ طولانی (بعد از ۱۵ دقیقه بی‌حرکتی کامل) — **فقط لاگ، هیچ کیکی انجام نمی‌شه**
- **`anticheat`** — لاگِ (نه اکشن خودکار) جابه‌جایی/سرعت غیرطبیعی بین دو تیک، به‌عنوان سیگنال احتمالِ اسپیدهک/تله‌پورت‌هک

## ۳) راند دوم — لاگ‌های ریزترِ ضدچیت + آدیت اسلحه (جدید)
این‌ها کاملاً خودکارن، هیچ export یا وابستگی بیرونی نمی‌خوان:

| دسته | چی رو تشخیص می‌ده | قابلیت اطمینان |
|---|---|---|
| `godmode` (زیرمجموعه‌ی `anticheat`) | `IsPlayerInvincible` روشن باشه | خیلی بالا — تقریباً هیچ اسکریپت RP معمولی این فلگ رو ست نمی‌کنه |
| `superhealth` (زیرمجموعه‌ی `anticheat`) | Max Health بالاتر از `Config.AntiCheatMaxHealth` (پیش‌فرض ۲۰۰) | بالا، ولی اگه جاب/پرکی سلامتی پایه رو بالا می‌بره باید عدد Config رو عوض کنی |
| `superarmor` (زیرمجموعه‌ی `anticheat`) | زره بالاتر از `Config.AntiCheatMaxArmor` (پیش‌فرض ۱۰۰) | مثل بالا |
| `invisible` (زیرمجموعه‌ی `anticheat`) | `IsEntityVisible` فالس باشه، خارج از کات‌سین/فید/پاز | متوسط-بالا |
| `illegalweapon` | حمل هر اسلحه‌ای که تو `Config.IllegalWeapons` لیست شده | کاملاً قطعی (لیست خودته) |
| `explosiveused` | شلیک/استفاده از نارنجک، RPG، بمب چسبان، مولوتوف و... | آدیت محض، نه چیت |
| `safezoneshot` | شلیک داخل هر محدوده‌ای که تو `Config.SafeZones` تعریف کردی | آدیت محض، نه چیت |

### تنظیمات جدید (مستقیم تو `shared/Config.lua`، نه server.cfg)
```lua
Config.IllegalWeapons = { 'WEAPON_RAILGUN', 'WEAPON_MINIGUN', ... }
Config.SafeZones = {
    { name = 'اسپاون مرکزی', x = 215.0, y = -810.0, z = 30.0, radius = 60.0 },
}
Config.AntiCheatMaxHealth = 200
Config.AntiCheatMaxArmor  = 100
```

### وبهوک‌های جدید (اختیاری، تو server.cfg)
```
setr unique_logs_DiscordWebhookIllegalWeapon "..."
setr unique_logs_DiscordWebhookExplosiveUsed "..."
setr unique_logs_DiscordWebhookSafezoneShot "..."
```
(godmode/superhealth/superarmor/invisible همون کانال قدیمیِ `unique_logs_DiscordWebhookAntiCheat` رو استفاده می‌کنن، چیز جدیدی لازم نیست.)


- `shared/Config.lua` — دو Convar جدید: `unique_logs_DiscordWebhookAFK`, `unique_logs_DiscordWebhookAntiCheat`
- `SERVER/Server.lua` — ۷ `RegisterServerEvent` جدید + روت‌کردن ۲ دسته‌ی جدید + دسته‌بندی جدای غرق‌شدگی
- `CLIENT/EventLogs.lua` — ۲ export جدید + ۵ Thread تشخیص جدید
- `fxmanifest.lua` — دو `export` جدید اعلام شدن

## ۴) راند سوم — ۵ لاگ رول‌پلی/رفتاری (فقط لاگ، هیچ بن/کیک خودکاری ندارن)

| دسته | چی رو تشخیص می‌ده | نکته‌ی مهم |
|---|---|---|
| `sidewalkdanger` | رانندگی با سرعت > `Config.SidewalkDangerSpeedKmh` (پیش‌فرض ۵۰) روی نقطه‌ای که `IsPointOnRoad` می‌گه جاده نیست، درحالی‌که حداقل `Config.SidewalkDangerMinPeds` (پیش‌فرض ۲) پیاده نزدیکشه | هیوریستیکه، نه قطعی؛ بعضی میدون‌ها/پارکینگ‌ها ممکنه اشتباهی «غیرجاده» حساب بشن |
| `combatlog` | دیسکانکت ظرف `Config.CombatLogWindowMs` (پیش‌فرض ۴۵ ثانیه) بعد از آخرین دیمج خوردن + فاصله تا نزدیک‌ترین آنلاینِ پلیس (طبق `Config.PoliceJobs`) | فقط لاگ برای بررسی موقع وصل‌شدن دوباره‌ی همون پلیر |
| `rdmpattern` | یه پلیر ظرف `Config.RDMWindowMs` (پیش‌فرض ۹۰ ثانیه) حداقل `Config.RDMVictimThreshold` (پیش‌فرض ۳) قربانیِ متفاوت داشته | فقط وقتی قاتل واقعاً یه پلیرِ آنلاینه (نه NPC/ماشین/محیط) |
| `nlrviolation` | پلیری که مرده، ظرف `Config.NLRWindowMs` (پیش‌فرض ۱۰ دقیقه) داخل `Config.NLRRadius` (پیش‌فرض ۱۰۰ متر) محل مرگ قبلیش برگرده | مبنا «زمان مرگ»ه نه «زمان ریوایو» (چون این ریسورس به ambulance وصل نیست)؛ کلاینت هر ۲۰ ثانیه موقعیتش رو پینگ می‌کنه |
| `fakename` | تو چت از کلمات `Config.BannedNameWords` (ادمین/استاف/مدیر/...) استفاده کنه ولی خودش واقعاً `permission_level` نداشته باشه | همچنین یه export سرور: `exports['logs']:CheckNameForImpersonation(source, fullName)` برای اسکریپت ساخت کاراکتر |

### تنظیمات جدید (تو `shared/Config.lua`)
```lua
Config.PoliceJobs = { 'police', 'sheriff', 'mt' }              -- برای Combat Log
Config.SidewalkDangerSpeedKmh = 50.0
Config.SidewalkDangerMinPeds  = 2
Config.CombatLogWindowMs = 45 * 1000
Config.RDMWindowMs        = 90 * 1000
Config.RDMVictimThreshold = 3
Config.NLRWindowMs = 10 * 60 * 1000
Config.NLRRadius   = 100.0
Config.BannedNameWords = { 'admin', 'ادمین', 'staff', 'استاف', ... }
```

### وبهوک‌های جدید (اختیاری، تو server.cfg)
```
setr unique_logs_DiscordWebhookSidewalkDanger "..."
setr unique_logs_DiscordWebhookCombatLog "..."
setr unique_logs_DiscordWebhookRDMPattern "..."
setr unique_logs_DiscordWebhookNLRViolation "..."
setr unique_logs_DiscordWebhookFakeName "..."
```

### یه باگ واقعی که موقع تست پیدا و رفع شد
تو نسخه‌ی اول Combat Log، پارامتر `Image` رو اشتباهی `false` فرستاده بودم؛ ولی تابع مرکزی `DiscordBot:ToDiscord` همیشه `Image:lower()` صدا می‌زنه (بدون چک نوع)، پس با `false` کرش می‌کرد. با `'user'` (مثل همه‌جای دیگه‌ی کد) جایگزین شد.

## نکات مهم قبل از استفاده
1. برای هر دسته‌ی جدید، اگه می‌خوای تو دیسکورد هم ببینیش، باید تو `server.cfg` این خط‌ها رو (با لینک وبهوک واقعی) اضافه کنی؛ وگرنه فقط تو دیتابیس/سایت ثبت می‌شه:
   ```
   setr unique_logs_DiscordWebhookAFK "https://discord.com/api/webhooks/..."
   setr unique_logs_DiscordWebhookAntiCheat "https://discord.com/api/webhooks/..."
   setr unique_logs_DiscordWebhookLockpick "..."
   setr unique_logs_DiscordWebhookCuffEscape "..."
   setr unique_logs_DiscordWebhookTireLog "..."
   setr unique_logs_DiscordWebhookVehicleEntry "..."
   setr unique_logs_DiscordWebhookHardFall "..."
   setr unique_logs_DiscordWebhookDrowning "..."
   ```
2. آستانه‌ی AFK (۱۵ دقیقه) و بافرهای سرعتِ آنتی‌چیت هاردکد شدن؛ اگه سرورت رول‌پلیِ خیلی پیاده/پرواز زیاده، ممکنه لازم باشه عددهاشون رو دستی تیون کنی (کامنت‌های بالای هر Thread تو `EventLogs.lua` دقیقاً کجاش رو مشخص کرده).
3. `anticheat` عمداً هیچ کیک/بنی خودش نمی‌زنه — چون لگ سرور/ری‌کانکت/تله‌پورت رسمی گاراژ و غیره می‌تونه false-positive بده. فقط لاگ می‌کنه تا ادمین دستی تصمیم بگیره.
4. `Unique_LogPanel` بدون هیچ تغییری این دسته‌های جدید رو هم نشون می‌ده، چون مستقیم از جدول `unique_logpanel` می‌خونه و دسته‌بندی رو دینامیک لیست می‌کنه.
