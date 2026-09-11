# فیچرهای جدید DOJ/LAW -- تغییرات نسبت به نسخه‌ی اصلی گیت‌هاب

این نسخه بر پایه‌ی آخرین commit موجود روی
`github.com/ArshiaRahnama/Test` (`main`, commit `0334da9` --
"Update2026/9/07 _ fIX bug") ساخته شده. بین این commit و commit پایه‌ای که
اول کار ازش شروع شد (`9567a07`) هیچ تغییری داخل پوشه‌ی
`[JOB]/esx_uniquejobs` وجود نداشت، پس این نسخه کاملاً هم‌راستا با آخرین
نسخه‌ی گیت‌هاب شماست.

## فایل‌های کاملاً جدید

**سرور:**
- `server/court_docket.lua` -- تقویم دادگاه + حکم نهایی judge
- `server/case_timeline.lua` -- Timeline یکپارچه‌ی پرونده
- `server/stats_dashboard.lua` -- داشبورد آماری
- `server/officer_performance.lua` -- بازبینی عملکرد افسر
- `server/mugshot_manager.lua` -- Mugshot + Rap Sheet کامل
- `server/traffic_stop_manager.lua` -- ثبت توقف سریع
- `server/evidence_custody.lua` -- زنجیره‌ی نگهداری مدارک

**کلاینت:**
- `client/court_docket_menu.lua`
- `client/case_timeline_menu.lua`
- `client/stats_dashboard_menu.lua`
- `client/officer_performance_menu.lua`
- `client/mugshot_menu.lua`
- `client/traffic_stop_menu.lua`
- `client/evidence_custody_menu.lua`

## فایل‌های ویرایش‌شده (نسبت به نسخه‌ی گیت‌هاب)

- **`server/db_migrations.lua`** -- ۵ جدول جدید (`dept_case_docket`,
  `dept_case_events`, `dept_traffic_stops`, `dept_mugshots`,
  `dept_evidence_custody`) به همون سیستم Self-Healing Migration که خود
  ریسورس از قبل داشت اضافه شد؛ یعنی **هیچ اجرای دستی SQL لازم نیست** --
  دقیقاً هم‌سبک با بقیه‌ی جدول‌ها (`doj_cases`, `dept_cases`, ...) که همین‌جا
  مدیریت می‌شن.
- `client/doj_menu.lua` -- ۳ گزینه به منوی اصلی + ۳ گزینه به جزئیات پرونده
- `client/law_menu.lua` -- ۲ گزینه (ثبت توقف، Mugshot) اضافه شد
- `fxmanifest.lua` -- فایل‌های بالا به `server_scripts`/`client_scripts` اضافه شد

هیچ فایل دیگه‌ای (Inventory, Phone, Gang, و غیره) که در commit های
اخیر شما تغییر کرده بودن، دست نخورده.

## آپدیت -- رفع باگ + اتصال به BOLO سیستم CAD

- **باگ رفع شد:** `os.time()`/`os.date()` سمت کلاینت توی FiveM اصلاً وجود
  ندارن (`os` سمت کلاینت `nil` است) -- این باعث ارور
  `attempt to index a nil value (global 'os')` توی چند تا از منوهای جدید
  می‌شد (`court_docket_menu.lua`, `case_timeline_menu.lua`,
  `evidence_custody_menu.lua`, `traffic_stop_menu.lua`,
  `stats_dashboard_menu.lua`). راه‌حل: دو فایل جدید `server/server_time.lua`
  + `client/server_time.lua` اضافه شد که یک‌بار زمان واقعی رو از سرور
  می‌گیره و از اون به بعد با `GetGameTimer()` (native واقعی کلاینت) محاسبه
  می‌کنه -- تابع `GetServerUnixTime()` رو همه‌جا به‌جای `os.time()` صدا
  می‌زنیم. برای `stats_dashboard`، فرمت تاریخ (`os.date`) بردیم سمت سرور.
- **اتصال به BOLO سیستم CAD:** `client/traffic_stop_menu.lua` کاملاً
  بازنویسی شد تا مستقیم به `CrimeScene:checkPlate` /
  `CrimeScene:getActiveBOLOs` (که خود CAD از قبل داره، بدون هیچ جدول یا
  کد سروری جدید) وصل بشه:
  - موقع ثبت تعقیب (Traffic Stop)، وارد کردن پلاک (اختیاری) خودکار پلاک
    رو با BOLO های فعال CAD چک می‌کنه.
  - گزینه‌ی جدید «Barresi Pelak (BOLO)» برای چک سریع یک پلاک بدون ثبت
    تعقیب.
  - گزینه‌ی جدید «BOLO-haye Active» فهرست تمام BOLO های فعلی رو نشون
    می‌ده (همون داده‌ای که پنل `/cad` نشون می‌ده).
  - یک هشدار صوتی + پنجره‌ی native (به‌جای فقط یک پیام چت) برای هر Hit
    روی BOLO -- چه از این منو چک بشه، چه از پنل `/cad`.
- **Rap Sheet کامل‌تر:** حالا علاوه بر `criminal_records`، مستقیم از خودِ
  جدول‌های CAD هم می‌خونه (فقط خوندن، هیچی رو تغییر نمی‌ده):
  `doj_cases`/`doj_case_suspects` (پرونده‌هایی که این شخص توشون مظنون یا
  همدست بوده) و `doj_criminal_records` (سابقه‌ی Booking ثبت‌شده از خود CAD).
  یعنی الان واقعاً هر دو سیستم پرونده (dept_cases و doj_cases) رو با هم
  نشون می‌ده.
- **میان‌بر CAD:** یک گزینه‌ی «Baz Kardan CAD (MDT)» به منوی اصلی `/doj` و
  `/law` اضافه شد که مستقیم پنل `/cad` رو باز می‌کنه.

## نصب

فقط **کافیه این پوشه رو جایگزین پوشه‌ی فعلی `[JOB]/esx_uniquejobs` روی
سرورتون کنید و ریسورس رو ری‌استارت کنید.** به محض استارت، `db_migrations.lua`
خودکار جدول‌های جدید رو می‌سازه -- نیازی به اجرای هیچ فایل `.sql` نیست
(فایل‌های `dept_features_ext.sql` و `rap_sheet_and_custody_ext.sql` فقط
برای مستندسازی نگه داشته شدن، دقیقاً مثل بقیه‌ی فایل‌های `.sql` قدیمی این
ریسورس).

## آپدیت -- Mugshot این‌بار واقعاً پیاده‌سازی شد (و خفن‌تر از نسخه‌ی قبلی)

نسخه‌ی قبلی همین changelog از `server/mugshot_manager.lua` و
`client/mugshot_menu.lua` اسم برده بود، ولی این دو فایل هیچ‌وقت واقعاً روی
دیسک نبودن -- نه جدول `dept_mugshots` ساخته شده بود، نه `fxmanifest.lua`
اون‌ها رو لود می‌کرد، نه `law_menu.lua` هیچ گزینه‌ای براش داشت. کامنت خودِ
`server/records_manager.lua` هم صریح می‌گفت این سیستم قبلاً «dead code» بوده
و حذف شده. این‌بار واقعاً از صفر ساخته شد:

- **`server/mugshot_manager.lua`** -- ذخیره‌ی هر عکس به‌عنوان یک ردیف جدید در
  `dept_mugshots` (تاریخچه‌ی کامل، نه یک ستون overwrite‌شونده) + یک تابع
  export شده (`GetLatestMugshot`) که `records_manager.lua` مستقیم صداش می‌زنه.
- **`client/mugshot_menu.lua`**:
  - **Gereftan Aks Jadid** -- اگه شهروند آنلاین باشه، یک دوربین واقعی
    (`CreateCamWithParams` + `PointCamAtCoord`) مستقیم روی سرش zoom می‌کنه،
    هر دو نفر فریز می‌شن، یک صدای شاتر پخش می‌شه، و بعد عکس یا خودکار با
    `screenshot-basic` آپلود می‌شه (convar `mugshot_upload_url` +
    اختیاری `mugshot_upload_field` برای اسم فیلد فرم -- پیش‌فرض `files[]`)،
    یا اگه تنظیم نشده/شهروند آفلاینه یک URL دستی گرفته می‌شه.
  - **Tarikhche-ye Aks-ha** -- فهرست تمام عکس‌های قبلی، هرکدوم با
    thumbnail واقعی (ویژگی `image` در ox_lib context) + سابت‌کننده + زمان.
  - **Rap Sheet + Aks** -- به‌جای یک کارت شناسایی جدا و تکراری، مستقیم همون
    Rap Sheet مشترک `/doj`+`/law` رو باز می‌کنه (زیر).
- **`server/records_manager.lua` ویرایش شد:** همون Rap Sheet
  (`esx_uniquejobs:menuGetCriminalRecord`) الان علاوه بر قبل، `sex` /
  `dateofbirth` / `height` از `users` (همون ستون‌هایی که `cia_main.lua`/
  `fbi_main.lua` استفاده می‌کنن) و آخرین Mugshot ثبت‌شده رو هم برمی‌گردونه.
- **`client/agent_speact.lua` ویرایش شد:** نمایش Rap Sheet الان
  thumbnail عکس رو توی خط اول نشون می‌ده، یک گزینه‌ی جدا برای دیدن عکس در
  سایز بزرگ داره، و یک گزینه‌ی **«Namayesh-e Motn-e Kamel (Copy)»** که کل
  Rap Sheet رو به‌صورت یک بلاک متنی کپی‌شدنی نشون می‌ده -- دقیقاً همون
  چیزی که نسخه‌ی قبلی این مستندات وعده داده بود ولی هیچ‌وقت پیاده‌سازی
  نشده بود.
- `client/law_menu.lua` -- یک گزینه‌ی «Mugshot» به منوی اصلی اضافه شد.
- `fxmanifest.lua` -- `server/mugshot_manager.lua` و
  `client/mugshot_menu.lua` واقعاً به `server_scripts`/`client_scripts`
  اضافه شدن (قبلاً اصلاً نبودن، با این‌که اسمشون توی این changelog بود).
- `server/db_migrations.lua` -- جدول `dept_mugshots` واقعاً به لیست
  `CREATE TABLE IF NOT EXISTS` اضافه شد (قبلاً فقط توی این changelog اسمش
  بود، هیچ‌وقت واقعاً ساخته نمی‌شد).

تمام فایل‌های تغییریافته/جدید با `luac5.4 -p` سینتکس‌چک شدن.

راهنمای به‌روز استفاده در بازی داخل `NEW_FEATURES_USAGE.md` هست.
