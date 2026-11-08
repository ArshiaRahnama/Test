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

-- Humanized fallback so the UI never shows raw "WEAPON_EMPLAUNCHER" /
-- "vehicle_keys" when the framework has no label for an entry.
local PrettyWeapons = {
    EMPLAUNCHER='EMP Launcher', GRENADELAUNCHER='Grenade Launcher', RPG='RPG', MINIGUN='Minigun',
    WIDOWMAKER='Widowmaker', RAILGUN='Railgun', COMBATPDW='Combat PDW', SMG='SMG', MICROSMG='Micro SMG',
    ASSAULTSMG='Assault SMG', ASSAULTRIFLE='Assault Rifle', CARBINERIFLE='Carbine Rifle', SNIPERRIFLE='Sniper Rifle',
    HEAVYSNIPER='Heavy Sniper', PUMPSHOTGUN='Pump Shotgun', SAWNOFFSHOTGUN='Sawed-Off Shotgun', PISTOL50='Pistol .50',
    COMBATPISTOL='Combat Pistol', APPISTOL='AP Pistol', SNSPISTOL='SNS Pistol', HEAVYPISTOL='Heavy Pistol',
    VINTAGEPISTOL='Vintage Pistol', STUNGUN='Stun Gun', FLAREGUN='Flare Gun', MARKSMANPISTOL='Marksman Pistol',
    MACHINEPISTOL='Machine Pistol', MG='MG', COMBATMG='Combat MG', GUSENBERG='Gusenberg Sweeper', MUSKET='Musket',
    FIREEXTINGUISHER='Fire Extinguisher', PETROLCAN='Jerry Can', SMOKEGRENADE='Smoke Grenade', STICKYBOMB='Sticky Bomb',
    PROXMINE='Proximity Mine', BZGAS='BZ Gas', MOLOTOV='Molotov', NIGHTSTICK='Nightstick', KNIFE='Knife',
    BAT='Bat', CROWBAR='Crowbar', HAMMER='Hammer', HATCHET='Hatchet', MACHETE='Machete', SWITCHBLADE='Switchblade',
    KNUCKLE='Knuckle Dusters', POOLCUE='Pool Cue', WRENCH='Wrench', BATTLEAXE='Battle Axe', GOLFCLUB='Golf Club',
    FLASHLIGHT='Flashlight', DAGGER='Antique Dagger', BOTTLE='Broken Bottle', PARACHUTE='Parachute',
}
local function Humanize(name)
    if type(name) ~= 'string' or name == '' then return name end
    local up = string.upper(name)
    local base = up:gsub('^ITEM_WEAPON_', ''):gsub('^WEAPON_', '')
    if PrettyWeapons[base] then return PrettyWeapons[base] end
    local s = name:gsub('^[Ww][Ee][Aa][Pp][Oo][Nn]_', ''):gsub('_', ' ')
    s = s:lower():gsub('(%a)([%w]*)', function(a, b) return a:upper() .. b end)
    return s
end
local function LooksRaw(label, name)
    return label == nil or label == '' or label == name
        or (type(label) == 'string' and label:match('^WEAPON_'))
end
function HumanizeLabel(name) return Humanize(name) end

function GetCachedItemLabel(name)
    if type(name) ~= 'string' then return name end
    local key = string.lower(name)
    local cached = ItemLabelCache[key]
    if cached ~= nil then return cached end

    if not CacheESX then TriggerEvent('esx:getSharedObject', function(obj) CacheESX = obj end) end
    local label = (CacheESX and CacheESX.GetItemLabel and CacheESX.GetItemLabel(name)) or name
    if LooksRaw(label, name) then label = Humanize(name) end
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
    if LooksRaw(label, name) then label = Humanize(name) end
    WeaponLabelCache[key] = label
    return label
end
