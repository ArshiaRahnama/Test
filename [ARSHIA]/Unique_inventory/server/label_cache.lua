--[[ ===========================================================================
    Unique_inventory | server/label_cache.lua

    ---------------------------------------------------------------------------
    چرا این فایل لازم بود (بهینه‌سازی، نه باگ امنیتی)
    ---------------------------------------------------------------------------
    server/inventory_main.lua, server/hud_data.lua و server/trunk_main.lua هر
    کدوم تو حلقه‌ی `for k,v in pairs(weapons) do ... ESX.GetWeaponLabel(v.name) end`
    یا `ESX.GetItemLabel(item)` رو صدا می‌زنن. essentialmode این توابع رو با یه
    جست‌وجوی خطی (linear scan) روی جدول کانفیگ آیتم‌ها/اسلحه‌ها پیاده می‌کنه -
    یعنی هر بار باز شدن اینونتوری یه بازیکن با ۱۵ اسلحه/آیتم = ۱۵ جست‌وجوی خطی
    جداگانه، و این روی سروری با چند نفر آنلاین که هم‌زمان اینونتوری باز می‌کنن
    جمع میشه. چون لیبل‌ها موقع اجرای سرور عوض نمیشن، یه بار کش‌شون می‌کنیم.

    ---------------------------------------------------------------------------
    استفاده
    ---------------------------------------------------------------------------
        local label = GetCachedItemLabel(itemName)
        local label = GetCachedWeaponLabel(weaponName)

    این دو تابع دقیقاً همون امضا/رفتار ESX.GetItemLabel و ESX.GetWeaponLabel رو
    دارن (ورودی lower/upper هرچی باشه نتیجه یکیه)، فقط از کش استفاده می‌کنن و
    اگه لیبل پیدا نشه (آیتم/اسلحه‌ی ناشناس) دوباره از ESX می‌پرسن، کش می‌کنن و
    برمی‌گردونن - هیچ لیبلی گم نمیشه، فقط بار دومی رایگانه.
=========================================================================== ]]

local ItemLabelCache   = {}
local WeaponLabelCache = {}
local CacheESX         = nil

TriggerEvent('esx:getSharedObject', function(obj) CacheESX = obj end)

function GetCachedItemLabel(name)
    if type(name) ~= 'string' then return name end
    local key = string.lower(name)
    local cached = ItemLabelCache[key]
    if cached ~= nil then return cached end

    if not CacheESX then TriggerEvent('esx:getSharedObject', function(obj) CacheESX = obj end) end
    local label = (CacheESX and CacheESX.GetItemLabel and CacheESX.GetItemLabel(name)) or name
    ItemLabelCache[key] = label
    return label
end

function GetCachedWeaponLabel(name)
    if type(name) ~= 'string' then return name end
    local key = string.upper(name)
    local cached = WeaponLabelCache[key]
    if cached ~= nil then return cached end

    if not CacheESX then TriggerEvent('esx:getSharedObject', function(obj) CacheESX = obj end) end
    local label = (CacheESX and CacheESX.GetWeaponLabel and CacheESX.GetWeaponLabel(name)) or name
    WeaponLabelCache[key] = label
    return label
end
