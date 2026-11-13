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
    -- اسم رنک‌های Sunset، روی شماره‌ی لول‌های همین سرور (۱۲ تا ۱۵ استفاده نمی‌شه؛ اگه بود، Manager نشون داده می‌شه)
    [1]   = 'SUPPORT',
    [2]   = 'HELPER',
    [3]   = 'SENIOR HELPER',
    [4]   = 'HEAD HELPER',
    [5]   = 'ADMIN',
    [6]   = 'SENIOR ADMIN',
    [7]   = 'HEAD ADMIN',
    [8]   = 'EXECUTIVE ADMIN',
    [9]   = 'ADMIN MANAGEMENT',
    [10]  = 'MODERATOR',
    [11]  = 'MANAGER',
    [16]  = 'MANAGER',
    [17]  = 'OWNER',
    [100] = 'DEVELOPER',
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

-- ------------------------------------------- دسته‌های ریپورتِ سبک Unique ---
-- فرم ریپورتِ چت (Unique-style) فقط همین‌ها رو نشون میده (unique = true).
-- uniqueKey همون کلیدهای فرم Unique هست؛ label همون چیزیه که تو لیست ادمین دیده میشه.
local uniqueCats = {
    { 'REPORT_COMBAT_LOGOUT', 'Combat Logout',     3 },
    { 'REPORT_KOS',           'K.O.S',             3 },
    { 'REPORT_NCZ_SAFEZONE',  'N.C.Z & Safe Zone', 3 },
    { 'REPORT_POWER_GAMING',  'Power Gaming',      3 },
    { 'REPORT_VDM',           'VDM',               3 },
    { 'REPORT_FEAR_RP',       'Fear Rp',           2 },
    { 'REPORT_SEARCH',        'Search',            2 },
    { 'REPORT_META_GAMING',   'Meta Gaming',       2 },
    { 'REPORT_MIX_IC_OOC',    'MIX IC OOC',        2 },
    { 'REPORT_FAHASHI',       'Fahashi',           3 },
    { 'REPORT_BUG_GLITCH',    'Bug & Glitch',      2 },
    { 'HELP',                 'Soal',              1 },
    { 'REPORT_MORE',          'More',              1 },
}
for _, c in ipairs(uniqueCats) do
    Config_Shared.Categories[#Config_Shared.Categories + 1] = {
        key = 'unique_' .. c[1]:lower(), label = c[2], priority = c[3], icon = 'fa-flag',
        unique = true, uniqueKey = c[1],
    }
end

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

-- --------------------------------------------------------- پاسخ آماده ---
-- دکمه‌های سریع بالای چتِ ادمین. با یک کلیک همون متن رو به‌عنوان پیامِ
-- ادمین می‌فرستن (از همون مسیر چتِ معمولی رد میشن - چیز جدیدی سمت سرور
-- لازم ندارن). اینجاست (نه report_server_config) چون کلاینت باید بتونه
-- بخونتش.
Config_Shared.CannedReplies = {
    { key = 'clip',     label = 'درخواست کلیپ',    text = 'لطفاً یک کلیپ یا اسکرین‌شات از اتفاق بفرست تا بررسی کنیم.' },
    { key = 'noissue',  label = 'مشکلی پیدا نشد',  text = 'بررسی شد، مشکل یا تخلفی پیدا نکردیم. اگه اتفاق جدیدی افتاد دوباره ریپورت بده.' },
    { key = 'escalate', label = 'ارجاع به بالاتر', text = 'این مورد رو به تیم ارشدتر ارجاع دادم، به‌زودی رسیدگی میشه.' },
    { key = 'wait',     label = 'کمی صبر کن',      text = 'در حال بررسیم، چند دقیقه صبر کن.' },
    { key = 'resolved', label = 'حل شد',           text = 'موضوع حل شد. اگه دوباره پیش اومد ریپورت بده.' },
}

function Config_Shared.GetCategory(key)
    for _, c in ipairs(Config_Shared.Categories) do
        if c.key == key then return c end
    end
    return nil
end
