--[[ ===========================================================================
    Unique RP - Report System | shared/report_shared_config.lua
    arshiahub.ir

    این فایل روی کلاینت و سرور هردو لود میشه.
    هرچیزی که هردو طرف لازمش دارن اینجاست.
=========================================================================== ]]

Config_Shared = {}

Config_Shared.ServerName    = "Unique RP"
Config_Shared.ServerSite    = "arshiahub.ir"
Config_Shared.BotName       = "Unique Bot"

Config_Shared.Framework     = "ESX"

-- ⚠ روی این سرور باید 1 بمونه.
-- es_extended نصب نیست؛ هسته‌ی ESX خودِ essentialmode هست
-- ([BASE]/essentialmode/server/common.lua که esx:getSharedObject رو ثبت میکنه).
-- گذاشتن 2 باعث میشه exports['es_extended'] رو صدا بزنه که وجود نداره.
Config_Shared.ESX_Version   = 1   -- [1] essentialmode/ESS  |  [2] ESX Legacy
Config_Shared.ESX_Export    = "es_extended"   -- فقط وقتی ESX_Version = 2
Config_Shared.ESX_Event     = "esx:getSharedObject"

-- ---------------------------------------------------------------- رنک‌ها ---
Config_Shared.Rank = {
    [1]   = 'Intern',
    [2]   = 'Helper',
    [3]   = 'Senior Helper',
    [4]   = 'Head Helper',
    [5]   = 'Admin',
    [6]   = 'Senior Admin',
    [7]   = 'Executive Admin',
    [8]   = 'Head Admin',
    [9]   = 'Moderator',
    [10]  = 'Supervisor',
    [11]  = 'Administrator',
    [16]  = 'Manager',
    [17]  = 'Owner',
    [100] = 'Developer',
}

-- -------------------------------------------------------------- دسترسی‌ها ---
Config_Shared.accessToAdminCommand = 1
Config_Shared.accessToAcceptReport = 1
Config_Shared.accessToDelReport    = 5   -- حذف کامل: فقط ادمین بالا
Config_Shared.accessToArchive      = 1   -- بایگانی (جای حذف) برای همه ادمین‌ها

-- دسترسی به اکشن‌های روی پلیر (قبلا تعریف شده بود ولی هیچوقت چک نمیشد - باگ امنیتی)
Config_Shared.AccessToGiveCar      = 1
Config_Shared.AccessToSpect        = 2
Config_Shared.AccessToTeleport     = 2
Config_Shared.AccessToRevive       = 2
Config_Shared.AccessToBring        = 3   -- جدید: آوردن پلیر پیش ادمین
Config_Shared.AccessToFreeze       = 3   -- جدید
Config_Shared.AccessToReturn       = 2   -- جدید: برگردوندن ادمین به جای قبلی

Config_Shared.AdminXPAccess        = 100 -- دستورات /addxp /delxp /cleanxp

-- ---------------------------------------------- موضوعات و اولویت ریپورت ---
-- key باید یکتا باشه. سمت سرور هم دقیقا با همین لیست اعتبارسنجی میشه،
-- پس هرچی اینجا نباشه از سمت سرور رد میشه (جلوگیری از دیتای دستکاری‌شده).
Config_Shared.Categories = {
    { key = 'rule',    label = 'نقض قوانین',            priority = 3, icon = 'fa-gavel'          },
    { key = 'cheat',   label = 'تقلب / هک',             priority = 4, icon = 'fa-bug-slash'      },
    { key = 'bug',     label = 'باگ سرور',              priority = 2, icon = 'fa-bug'            },
    { key = 'shop',    label = 'خرید از فروشگاه',       priority = 3, icon = 'fa-cart-shopping'  },
    { key = 'stuck',   label = 'گیر کردن / وسیله گم‌شده', priority = 2, icon = 'fa-car-burst'     },
    { key = 'quest',   label = 'سوال',                  priority = 1, icon = 'fa-circle-question'},
    { key = 'help',    label = 'راهنمایی',              priority = 1, icon = 'fa-hands-helping'  },
    { key = 'other',   label = 'موارد دیگر',            priority = 1, icon = 'fa-ellipsis'       },
}

-- اولویت‌ها: عدد بزرگ‌تر = فوری‌تر
Config_Shared.Priorities = {
    [1] = { label = 'کم',   color = '#6C7689' },
    [2] = { label = 'عادی', color = '#4E8CD9' },
    [3] = { label = 'بالا', color = '#E8A33D' },
    [4] = { label = 'فوری', color = '#D9534F' },
}

-- ------------------------------------------------------ محدودیت‌های متنی ---
Config_Shared.Limits = {
    titleMin = 5,   titleMax = 64,
    infoMin  = 15,  infoMax  = 1000,
    chatMax  = 500,
}

function Config_Shared.GetCategory(key)
    for _, c in ipairs(Config_Shared.Categories) do
        if c.key == key then return c end
    end
    return nil
end
