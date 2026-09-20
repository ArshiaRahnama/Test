# Unique_inventory

ادغامِ `esx_inventory` + `esx_inventoryhud` + `esx_inventoryhud_trunk` در یک ریسورس، با رفع باگ‌های زیر.

## نصب
1. این پوشه رو با اسم `Unique_inventory` بذار توی `resources/`.
2. `esx_inventory`, `esx_inventoryhud`, `esx_inventoryhud_trunk` قدیمی رو از `server.cfg` **پاک کن** (هر سه‌تا الان همینجان).
3. `install.sql` رو (اگه قبلاً جدول‌های ترانک رو نداشتی) روی دیتابیس اجرا کن.
4. `ensure Unique_inventory` رو به `server.cfg` اضافه کن — **بعد از** `essentialmode` و `oxmysql`، و بعد از `Unique_AdminPanel` (چون کارت هویت از `esx_aduty:checkAdmin` استفاده می‌کنه).

## باگ‌های رفع‌شده

### ۱) کال‌بک‌های سرور اصلاً کار نمی‌کردن (ریشه‌ای)
هر سه ریسورس قدیمی با `ESX.RegisterServerCallback` روی یه کپیِ محلیِ ESX (از `esx:getSharedObject`) کال‌بک ثبت می‌کردن. چون این سرور `essentialmode` هست نه `es_extended`، این کپی جدولِ زنده‌ی سرور نیست و هر کدوم بی‌صدا شکست می‌خوردن — دقیقاً همون باگی که خودِ `Unique_AdminPanel` قبلاً پیدا کرده بود. همه‌شون الان از `server/callback_bridge.lua` (همون الگوی export-relay خودِ essentialmode) رد می‌شن. این شامل می‌شد:
- `Parzival:getHouseINV` / `getGangINV` / `getJobINV1` / `getJobINV2`
- `esx_inventoryhud:GetData` / `getPlayerInventory` / `getPlayerInventory1` / `getPlayerInventory2323` / `GetHouseItems` / `updateCraft` / `calculateCraft`
- `esx_trunk:getInventoryV` و بقیه‌ی کال‌بک‌های صندوق‌عقب

### ۲) وزن اینونتوری کلاً فیک بود
سرور وزن هر آیتم/اسلحه رو هارد-کد `10` می‌فرست (بدون توجه به آیتم واقعی)، و کلاینت هم `1000.0/4000.0` رو ثابت نشون می‌داد — دقیقاً همون عددی که توی اسکرین‌شات دیده می‌شه، مهم نیست چی توی اینونتوریته. الان وزن واقعی از `ESX.getItemWeight`/`ESX.getWeaponWeight` محاسبه می‌شه و مجموع واقعی برمی‌گرده. سقف وزن قابل تنظیمه: `HudConfig.MaxInventoryWeight` (پیش‌فرض ۹۰).

### ۳) کارت هویت
- ردیف Admin هیچ‌وقت `admin` رو از سرور نمی‌گرفت، پس همیشه (برای همه) نمایش داده می‌شد (fail-open). الان:
  - از همون معیاری که خودِ AdminPanel استفاده می‌کنه (`esx_aduty:checkAdmin` → `xPlayer.permission_level > 1`) میاد، نه یه حد نصاب اختراعی.
  - به‌صورت پیش‌فرض مخفیه (`display:none`) تا وقتی سرور تأیید کنه — یعنی fail-closed.
  - اگه `esx_aduty` بالا نباشه، بعد از ۲ ثانیه timeout میخوره و کارت هنگ نمی‌کنه.
- متن‌های استاتیکِ Placeholder توی HTML به پرتغالی بودن (`Passaporte`, `Telefone`, ...) در حالی که خودِ `app.js` (قبلاً به اسم گمراه‌کننده‌ی `jquery.js`) داشت درست از `config.js` (انگلیسی) استفاده می‌کرد. حالا Placeholder هم با همون لیبل‌های `config.js` هماهنگه.

### ۴) مسیر آیکن‌ها
- ۷ تا از ۸ محل `SendNUIMessage` به‌درستی به `esx_inventoryhud/html/img/items/` اشاره می‌کردن (یه وابستگی بین‌ریسورسی که فقط چون هر دو با هم اجرا می‌شدن کار می‌کرد).
- یه مورد (اینونتوری صندوق خونه/Cargo) به یه ریسورس ناموجود به اسم `inventory` اشاره می‌کرد — آیکن‌هاش هیچ‌وقت لود نمی‌شدن.
- الان هر ۸ مورد یکسان به `nui://Unique_inventory/html/img/items/` اشاره می‌کنن (همون ۴۴۲ تا آیکن که از esx_inventoryhud اومدن).

### ۵) فایل واقعیِ اپ گمراه‌کننده بود
`nui/jquery.js` جیکوئری واقعی نبود — کل منطق اینونتوری (۱۷۰۰+ خط) بود، با ۲۵ تا آدرس NUI هارد-کد به `http://esx_inventory/...`. با تغییر اسم ریسورس این‌ها می‌شکستن. اسمش شد `app.js` و همه‌ی آدرس‌ها اصلاح شدن به `Unique_inventory`.

### ۶) تداخل بین فایل‌ها بعد از ادغام (باگ‌هایی که خودِ من موقع ادغام معرفی می‌کردم، پیدا و رفع شدن قبل از تحویل)
- تابع `openmenuvehicle` توی esx_inventory و trunk هم‌نام بود → یکی دیگری رو بی‌صدا خاموش می‌کرد. اسم نسخه‌ی trunk شد `Trunk_OpenMenuVehicle`.
- هر دو `Config = {}` (هاد و ترانک) روی هم می‌نشستن و فیلدهای همو پاک می‌کردن → جدا شدن به `HudConfig` و `TrunkConfig` و همه‌ی ارجاعات آپدیت شدن.

## ظاهر (تم رنگی)
CSS از قبل دقیقاً همین تم طلایی/مشکیِ UNIQUE بود (`#d4af37` به عنوان رنگ اصلیِ لهجه، پس‌زمینه‌های مشکی/نیمه‌شفاف) — همون چیزی که توی اسکرین‌شاتت هست. نیازی به بازطراحی از صفر نبود؛ فقط باگ‌های واقعی (بالا) که ظاهرش رو خراب می‌کردن رفع شدن.

## چیزهایی که هنوز باید خودت تست کنی (اینجا امکان اجرای FiveM واقعی نیست)
- UI کامل خودِ `esx_inventoryhud` (فایل‌های `html/ui.html` و JS/CSS جداگونه‌ش) عمداً حذف شد چون `esx_inventory` رابط اصلیه و اجرای هر دو همزمان تداخل ایجاد می‌کرد. فقط منطق سرور + رویدادهای کلید (`getOwnerVehicle`/`getOwnerHouse`) نگه داشته شد. اگه جایی مستقیم داشت اون UI جدا رو صدا میزد (مثلاً یه export یا event خاص)، بگو تا چک کنم.
- بعد از نصب، حتماً لاگ کنسول سرور رو موقع استارت چک کن — اگه `callback_bridge.lua` نتونه به essentialmode وصل بشه، خطاش پرینت می‌شه.
