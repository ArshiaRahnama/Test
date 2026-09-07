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

## نصب

فقط **کافیه این پوشه رو جایگزین پوشه‌ی فعلی `[JOB]/esx_uniquejobs` روی
سرورتون کنید و ریسورس رو ری‌استارت کنید.** به محض استارت، `db_migrations.lua`
خودکار جدول‌های جدید رو می‌سازه -- نیازی به اجرای هیچ فایل `.sql` نیست
(فایل‌های `dept_features_ext.sql` و `rap_sheet_and_custody_ext.sql` فقط
برای مستندسازی نگه داشته شدن، دقیقاً مثل بقیه‌ی فایل‌های `.sql` قدیمی این
ریسورس).

راهنمای کامل استفاده در بازی داخل `NEW_FEATURES_USAGE.md` هست.
