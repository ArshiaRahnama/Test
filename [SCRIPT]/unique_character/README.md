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
- اگه اسکریپت دیگه‌ای (مثل `spawnmanager`) وسط لودینگ صفحه رو فید‌این کنه، سریع دوباره سیاه می‌شه (`Config.HoldBlack`).
- حداقل زمان سیاهی `Config.MinBlackMs` هست (پیش‌فرض ۸ ثانیه)، حتی اگه همه‌چیز زودتر آماده باشه. مدت هر مرحله: `RetrieveMs`, `PrepareMs`, `TeleportMs`, `ClothesMinMs`.
- متن پیام‌ها از `Config.Text` عوض می‌شه.
