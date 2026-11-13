# unique_character

فلو ثبت‌نام + اسپاون کاراکتر یونیک روی استک Unique (essentialmode + oxmysql + skincreator).

## نصب
1. پوشه‌ی `unique_character` رو بذار توی `[ARSHIA]` (بعد از `essentialmode` و `oxmysql` استارت می‌شه، چون `[ARSHIA]` آخره؛ دیگه به `ps-ui` نیازی نداره).
2. `[SCRIPT]/loading/fxmanifest.lua` رو با نسخه‌ی داخل patch جایگزین کن (کلاینت قدیمی `loading` خاموش می‌شه؛ بدون این کار دو فرم ثبت‌نام همزمان باز می‌شه).
3. ریستارت سرور (نه فقط ریسورس؛ فلو اسپاون فقط موقع join کار می‌کنه).
4. اختیاری ولی پیشنهادی (جلوگیری قطعی از نام تکراری حتی اگه ریسورس دیگه‌ای playerName بنویسه):
   ```sql
   -- اول چک کن تکراری نداری:
   SELECT playerName, COUNT(*) c FROM users WHERE playerName IS NOT NULL AND playerName <> '' GROUP BY playerName HAVING c > 1;
   -- اگه خالی بود:
   ALTER TABLE users ADD UNIQUE KEY uq_users_playerName (playerName);
   ```

## اتصال به سیستم لباس
سیستم لباست وقتی لباس‌ها پوشیده شد این رو صدا بزنه، فید‌این منتظرش می‌مونه (با timeout ۸ ثانیه):
```lua
TriggerEvent('unique_character:clothesReady')
```
ایونت `skinchanger:modelLoaded` هم پذیرفته می‌شه (`Config.ClothesEvents`).
اگه `skinchanger:modelLoaded` زودتر از پوشیدن لباس نهایی میاد، از لیست حذفش کن.
بعد از اسپاون: `exports.unique_character:isReady()` و ایونت `unique_character:spawned(isNewCharacter)`.

## ویژگی‌های طراحی
- سمت سرور (اعتبارسنجی + یکتایی نام + نوشتن توی یک UPDATE شرط‌دار) کامل توی خود ریسورس نوشته شده.
- هیچ `while` بی‌timeout ای نیست؛ همه‌ی انتظارها سقف زمانی دارن.
- NUI callbackها همیشه `cb('ok')` می‌دن، cursor با ریستارت ریسورس گیر نمی‌کنه، حلقه‌ی کنترل‌ها دوبل نمی‌شه.
- `ps-ui` با امضای درست Unique صدا زده می‌شه.

## باگ‌های قبلی که اینجا رفع شده
- `playerName` هیچ‌جا ذخیره نمی‌شد (`es:newName` فقط RAM، `db:updateUser` فقط `dateofbirth`).
- `needRegister` با `false` شروع می‌شد ولی منتظر `nil` بود (بازیکن جدید با لاگین کند می‌تونست ثبت‌نام رو رد کنه).
- چک نام و ذخیره‌ی نام دو مرحله‌ی جدا بودن (race برای نام تکراری).
- هر کلاینتی می‌تونست با `es:newName` اسم دلخواه بذاره (هنوز توی essentialmode هست؛ پایین ببین).

## هنوز باز (دست نزدم)
`[BASE]/essentialmode/server/player/login.lua` → `es:newName` رو هر کلاینتی می‌تونه صدا بزنه. الان چیزی ازش استفاده نمی‌کنه؛ پیشنهاد: حذفش یا فقط سروری کردنش.

## صفحه‌ی سیاه و نوار وضعیت پایین صفحه
- صفحه همون اول سیاه می‌شه و فقط وقتی **همه‌چیز** لود شد فید‌این می‌شه (۳ ثانیه).
- پایین صفحه یه پنل کوچیک بالا میاد و مرحله‌ها رو نشون می‌ده، به همین ترتیب:
  `Retrieving data` ← `Register` (فقط بازیکن جدید) ← `Preparing for spawn` ← `Teleporting to last location` ← `Wearing clothe` ← `Welcome🙂`
- صفحه با یه **مستطیل سیاه** پوشونده می‌شه (`Config.HoldBlack`)، نه با `DoScreenFadeOut`. دلیلش: `spawnmanager` بعد از اسپاون `DoScreenFadeIn(500)` می‌زنه و **منتظر `IsScreenFadedIn()` می‌مونه** و فقط بعدش `playerSpawned` رو می‌فرسته. اگه ما مدام صفحه رو سیاه کنیم، `playerSpawned` هیچ‌وقت نمی‌رسه (قفل دوطرفه، ۶۰ ثانیه صفحه‌ی سیاه، بعد پرش و فریز). با مستطیل، `spawnmanager` آزادانه کارش رو می‌کنه و بازیکن چیزی نمی‌بینه.
- حداقل زمان سیاهی `Config.MinBlackMs` هست (پیش‌فرض ۸ ثانیه)، حتی اگه همه‌چیز زودتر آماده باشه. مدت هر مرحله: `RetrieveMs`, `PrepareMs`, `TeleportMs`, `ClothesMinMs`.
- متن پیام‌ها از `Config.Text` عوض می‌شه.

## اگه حس می‌کنی چند سیستم همزمان بازیکن رو لود می‌کنن
- `[SCRIPT]/loading` قدیمی هم فرم ثبت‌نام و اسپاون داره. اگه با این ریسورس همزمان بالا باشه، دو فرم ثبت‌نام، دو بار `loading:Loaded` و فید/فریز دوبل داری.
- این ریسورس اون رو خودش استاپ می‌کنه (هر بار که استارت یا ریستارت بشه): `Config.StopConflicting` و `Config.ConflictingResources`. دیگه نیازی به patch دستی نیست (ولی patch هم مشکلی نداره).
- برای دیدن اینکه چی چند بار اجرا می‌شه: توی F8 بزن `uc_trace` (یا `Config.Trace = true`) و بازی رو join کن. زمان هر ایونت لود (spawn، playerLoaded، freeze، لود اسکین)، تغییر فید و تعویض ped چاپ می‌شه و آخرش خلاصه‌ای که ایونت‌های تکراری رو با `<-- fired more than once` علامت می‌زنه.
- اگه بعد از ۸ ثانیه هنوز ریسورس تداخل‌دار روشن باشه، یه WARNING توی F8 میاد.

## پرش بین مکان‌ها و فریز بعد از اسپاون
ترتیب واقعی سرور:
1. `spawnmanager` بازیکن رو توی **نقطه‌ی پیش‌فرض اسپاون** می‌ذاره و `playerSpawned` می‌زنه.
2. essentialmode صبر می‌کنه تا `esx:playerLoaded` برسه، بعد بازیکن رو به **آخرین مکان** می‌بره.
3. آخرش `es_admin:freezePlayer true` می‌زنه (فریز).

اگه قبل از این‌ها فید‌این بشه، بازیکن «نقطه‌ی پیش‌فرض ← پرش به مکان قبلی ← فریز» رو می‌بینه.
حالا فید‌این فقط وقتی انجام می‌شه که `esx:playerLoaded` رسیده باشه، `playerSpawned` اومده باشه و essentialmode با فریز کارش رو تموم کرده باشه (مرحله‌ی `Teleporting to last location`).
علاوه بر ایونت‌ها، پد باید **واقعاً** نزدیک آخرین مکان ذخیره‌شده باشه (`Config.PlaceRadius`، فقط x,y). اگه سرور کند باشه (مثلاً `esx:playerLoaded` بعد از ۳۰ ثانیه برسه) صفحه همون‌قدر سیاه می‌مونه و هرگز نقطه‌ی پیش‌فرض اسپاون دیده نمی‌شه.
- هر ۱۰ ثانیه انتظار توی F8 چاپ می‌شه: `still waiting ... esx loaded / playerSpawned / placed / distance to last position`.
- سقف انتظار `Config.WorldTimeoutMs` (پیش‌فرض ۶۰ ثانیه) هست؛ بعدش فید‌این می‌شه و یه WARNING با همون جزئیات میاد.

### اگه لود سرور کنده
`esx:playerLoaded` بعد از `LoadUser` (یه `SELECT * FROM users WHERE identifier = ...`) فرستاده می‌شه. اگه توی `uc_trace` می‌بینی این ایونت خیلی دیر میاد:
- توی دیتابیس چک کن `identifier` توی جدول `users` ایندکس داره: `SHOW INDEX FROM users;`
- توی `server.cfg` هشدار کوئری کند رو روشن کن: `set mysql_slow_query_warning 200` (oxmysql کوئری‌های کندتر از ۲۰۰ms رو چاپ می‌کنه).

### اگه `playerSpawned: false` توی لاگ F8 موند
یعنی `spawnmanager` اسپاون رو تموم نکرده. دلیل‌های ممکن: چیزی نمی‌ذاره `IsScreenFadedIn()` برسه (مثلاً اسکریپتی که مدام `DoScreenFadeOut` می‌زنه)، یا `spawnmanager`/`fivem` بالا نیست. توی `uc_trace` ببین `playerSpawned` کِی میاد و `fade:` چه وضعیتی داره.
