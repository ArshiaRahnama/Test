# logs (شامل پنل مشاهده‌ی لاگ — قبلاً Unique_LogPanel)

این ریسورس دو تا کار رو با هم انجام می‌ده:

1. **جمع‌آوری لاگ**: ده‌ها ایونت سرور/کلاینت (کشتن، چت، ادمین‌منو، اقتصاد، آنتی‌چیت، رول‌پلی و...) رو
   می‌گیره، هم به دیسکورد (با وبهوک جدای هر دسته) می‌فرسته، هم عیناً تو جدول `unique_logpanel`
   ذخیره می‌کنه (`SERVER/Server.lua` → تابع `SendToSite`، که export هم شده برای ریسورس‌های دیگه).
2. **نمایش لاگ**: یه پنل NUI (تو خودِ بازی، نه یه سایت جدا) که مستقیم از همون جدول می‌خونه —
   ادمین‌ها با `/adminlogs` همه‌چیز رو می‌بینن، باسِ هر شغل با `/joblogs` یا دکمه‌ی باس‌منو فقط
   لاگ شغل خودشو. این بخش قبلاً یه ریسورس جدا به اسم `Unique_LogPanel` بود؛ چون همیشه فقط از
   همین جدول (که همین ریسورس پر می‌کنه) می‌خوند، نگه‌داشتنش جدا فقط یه وابستگی/ترتیب‌بارگذاری
   اضافه بدون فایده بود، پس داخل همین `logs` ادغام شد. هیچ منطقی عوض نشده، فقط فایل‌ها جابه‌جا شدن:

   | قبلاً (Unique_LogPanel) | الان |
   |---|---|
   | `client/main.lua` | `CLIENT/LogPanel.lua` |
   | `server/main.lua` | `SERVER/LogPanel.lua` |
   | `html/index.html` | `html/index.html` (همینجا، بدون تغییر — از `GetParentResourceName()` استفاده می‌کنه پس خودکار با اسم ریسورس جدید کار می‌کنه) |
   | `install.sql` | `install.sql` (همینجا) |
   | `exports['Unique_LogPanel']:OpenLogPanel(...)` | `exports['logs']:OpenLogPanel(...)` |

## ✅ نصب

1. `install.sql` رو یه‌بار روی دیتابیس سرورت اجرا کن. اگه قبلاً از نسخه‌ی جدای Unique_LogPanel
   استفاده می‌کردی و جدول از قبل هست، اجرای دوباره‌اش کاملاً بی‌خطره (IF NOT EXISTS / تحمل خطای
   «ستون تکراری»).
2. تو `server.cfg` دیگه لازم نیست دو خط جدا (`ensure logs` + `ensure Unique_LogPanel`) بنویسی —
   یه `ensure logs` کافیه (یا اگه از `ensure [SCRIPT]` استفاده می‌کنی که این سرور همین الانشم
   داره، حتی همون هم لازم نیست تغییر کنه).
3. اگه پوشه‌ی قدیمی `Unique_LogPanel` هنوز روی سرورت هست، پاکش کن (دیگه استفاده نمی‌شه).
4. اتصال به باس‌منو (`esx_society/client/main.lua`) نیاز به **هیچ تغییری** نداره — چون از
   `TriggerEvent('LogPanel:OpenBossPanel')` (یه client event ساده، نه export مستقیم رو اسم
   ریسورس) استفاده می‌کنه، خودکار با فایل جدید کار می‌کنه.
5. `shared/webhooks.cfg` رو پر کن (لینک‌های وبهوک واقعی دیسکوردت). **قبلش حتماً بخش هشدار امنیتی
   بالای همون فایل رو بخون** — لینک‌های قبلی لو رفته محسوب می‌شن و باید Regenerate بشن.

## 🎮 استفاده (پنل)

| کی | چطور | چی می‌بینه |
|---|---|---|
| **ادمین** (`permission_level` ≥ `Config.AdminPermissionLevel`، پیش‌فرض ۵) | `/adminlogs` | همه‌ی دسته‌ها، همه‌ی شغل‌ها، آمار کامل، خروجی CSV، حذف/پین |
| **باس هر شغل** (گرید `boss`) | `/joblogs` یا دکمه‌ی باس‌منو | فقط لاگ شغل خودش |

تنظیمات پنل (سطح دسترسی، صفحه‌بندی، پاک‌سازی خودکار، امکانات) بالای `SERVER/LogPanel.lua` هست
(`Config.AdminPermissionLevel`, `Config.BossGradeNames`, `Config.RetentionDays`, `Config.EnableExport`,
`Config.EnableDelete`, `Config.EnablePinning`, `Config.EnableLiveUpdates` و بقیه).

امکانات پنل: تب‌بندی دسته/شغل، سرچ، فیلتر بازه‌ی تاریخ، مرتب‌سازی، صفحه‌بندی، داشبورد آمار با
نمودار روند ۱۴ روزه، خروجی CSV، حذف/پین تکی و گروهی (با audit trail)، اعلان لحظه‌ای لاگ جدید،
پاک‌سازی خودکار دسته‌ای با معافیت لاگ‌های ارگان/پین‌شده، و کلیدهای میان‌بر (`/`، `Ctrl+K`، `Ctrl+E`، `R`، `Esc`، `?`).

## 🔌 وصل‌کردن باس‌منوی سفارشی خودت

```lua
TriggerEvent('LogPanel:OpenBossPanel') -- سمت کلاینت
```
یا از سمت سرور یه ریسورس دیگه:
```lua
exports['logs']:OpenLogPanel(source)
exports['logs']:OpenAdminLogPanel(source)
```

## ⚠️ امنیت

`shared/webhooks.cfg` شامل لینک‌های وبهوک واقعیه — **هیچ‌وقت این فایل رو commit/push نکن** (به
`.gitignore` اضافه‌اش کن). جزئیات کامل بالای خودِ فایل نوشته شده.
