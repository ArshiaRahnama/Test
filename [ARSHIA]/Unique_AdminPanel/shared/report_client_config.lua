--[[ ===========================================================================
    Unique RP - Report System | shared/report_client_config.lua  (client only)
=========================================================================== ]]

Client_Config = {}

-- ------------------------------------------------------------- دستورات ---
Client_Config.CommandForUser  = "ticket"   -- پنل قدیمی حالا فقط تیکت + برترین ادمین‌هاست؛ /report = فرم Sun-style چت
Client_Config.CommandForAdmin = "areport"

-- کیبایند اختیاری (خالی = غیرفعال). بازیکن از Settings > Keybinds میتونه عوضش کنه.
Client_Config.KeyForUser      = ""        -- مثلا "F6"
Client_Config.KeyForAdmin     = ""        -- مثلا "F7"

Client_Config.commandCooldown = 1500      -- میلی‌ثانیه (برای هر دستور جداگانه شمرده میشه)

-- ------------------------------------------------------- ماشین ادمین ---
Client_Config.AdminCar              = '405glx'
Client_Config.AddKeyAfterSpwanCar   = "garage:addKeys"   -- سرور-ایونت، arg1 = پلاک
Client_Config.DeleteAdminCarOnClose = true               -- با بسته شدن ریپورت ماشین حذف بشه

-- --------------------------------------------------------- اسپکتیت ---
Client_Config.SpectateEvent = "esx_spectate:spectatexxxx"

-- true = فرم/امتیازدهی/نشانگر ریپورت بازیکن داخل چت (سبک Sun) هست و پنل NUI قدیمی askRating نشون نمیده
Client_Config.SunReportUI = true
