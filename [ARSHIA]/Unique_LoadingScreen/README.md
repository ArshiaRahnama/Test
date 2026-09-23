# Unique_LoadingScreen — Unique RP

## نصب
1. پوشه رو بذار توی `[SCRIPT]/Unique_LoadingScreen` (با `ensure [SCRIPT]` خودکار استارت میشه).
2. تنظیمات همه توی `assets/js/config.js` هست: لینک دیسکورد/تیم‌اسپیک، متن‌ها، امکانات، IP آمار زنده.
3. فقط **یک** رزورس با `loadscreen` باید فعال باشه.
4. `assets/background.mp4` رو فشرده کن (مثلاً ۸ تا ۱۰ مگابایت، H.264) تا لود سریع‌تر بشه.

## کارها
- ظاهر: تم طلایی مطابق لوگوی سرور، فارسی/انگلیسی (دکمه EN/FA)، حالت سبک (کلید L) برای سیستم ضعیف.
- لاگ واقعی FiveM (`onLogLine`) به جای متن‌های فیک نمایش داده میشه.
- بسته شدن خودکار با fade بعد از `playerSpawned` / `esx:playerLoaded` / `loading:Loaded` / `showRegisterForm` + failsafe ۴۵ ثانیه‌ای.
- آمار آنلاین از `players.json` (اگه بلاک شد چیپ مخفی میشه).
- کلیدها: `M`/Space = صدا، ↑↓ = ولوم، `L` = حالت سبک.
