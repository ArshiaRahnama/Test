--[[ ===========================================================================
    Unique RP | server/esm_callback_bridge.lua
    arshiahub.ir

    ⚠ این فایل باید اولین فایل داخل server_scripts باشه.

    ---------------------------------------------------------------------------
    چرا این فایل وجود داره
    ---------------------------------------------------------------------------
    سرور ما es_extended نداره. فریم‌ورک، خودِ essentialmode هست
    (BASE/essentialmode) که یک بیلد ادغام‌شده‌ست و همون ESX رو فراهم میکنه.

    داخل essentialmode/server/functions.lua:

        ESX.RegisterServerCallback = function(name, cb)
            ESX.ServerCallbacks[name] = cb
        end

    وقتی یک ریسورس دیگه با esx:getSharedObject یک کپی از ESX میگیره، اون کپی
    یک اسنپ‌شات جداست. پس نوشتن روی ESX.ServerCallbacks اون کپی، هیچ اثری روی
    جدولِ واقعیِ essentialmode نداره. دیسپچرِ واقعی (که کلاینت باهاش حرف میزنه)
    اون ثبت رو **هیچ‌وقت نمیبینه** و کال‌بک بی‌صدا شکست میخوره.

    خودِ نویسنده‌ی essentialmode این رو داخل server/common.lua مستند کرده و
    یک مکانیزم relay ساخته:

        exports['essentialmode']:RegisterServerCallback(name)   -- فقط اسم
        AddEventHandler('essentialmode:relayServerCallback:<resource>', ...)
        TriggerEvent('essentialmode:relayServerCallbackReply', requestId, ...)

    دلیلش هم نوشته: اگه خودِ تابع کال‌بک از مرز exports رد بشه، اون طرف
    به‌جای function به‌صورت table میرسه (محدودیت FXServer). پس فقط دیتای
    ساده رد و بدل میشه و تابع واقعی ۱۰۰٪ داخل همین ریسورس میمونه.

    این دقیقاً همون الگوییه که esx_inventory هم استفاده میکنه
    (BASE/esx_inventory/server/custom/framework/esx.lua) و روی همین سرور
    جواب داده.

    ---------------------------------------------------------------------------
    چی درست میشه
    ---------------------------------------------------------------------------
    ۵۶ تا ESX.RegisterServerCallback داخل Unique_AdminPanel وجود داشت که
    همه‌شون بی‌صدا مرده بودن — یعنی این‌ها هیچ‌کدوم کار نمیکردن:

        پنل ادمین (GetOnlinePlayers, GetDashboard, InspectPlayer,
        SearchBans, GetServerStats, GetChatLog, ...)
        اسپکتیت (esx_spectate:getPlayerData و ...)
        جیل (arshia_jail:retriveJail)
        ریسک اسکور، آپیل‌ها، لاگ دیوتی، آدیت فکشن‌ها
        و کل سیستم ریپورت

    با این فایل، همه‌ی اون‌ها بدون تغییر در منطقشون زنده میشن.
=========================================================================== ]]

local RES            = GetCurrentResourceName()
local LocalCallbacks = {}          -- [name] = تابع واقعی؛ هرگز از این ریسورس خارج نمیشه
local Registered     = {}          -- [name] = true وقتی essentialmode قبولش کرد

-- ------------------------------------------------------- دریافت درخواست ---

AddEventHandler('essentialmode:relayServerCallback:' .. RES, function(name, requestId, source, ...)
    local fn = LocalCallbacks[name]
    if not fn then
        -- جواب خالی بده تا کلاینت تا ابد منتظر نمونه
        return TriggerEvent('essentialmode:relayServerCallbackReply', requestId)
    end

    local replied = false
    local function reply(...)
        if replied then return end
        replied = true
        TriggerEvent('essentialmode:relayServerCallbackReply', requestId, ...)
    end

    -- pcall تا یک خطا داخل یک کال‌بک، کال‌بک‌های دیگه رو از کار نندازه
    -- و مهم‌تر: تا کلاینت بدون جواب معلق نمونه.
    local ok, err = pcall(fn, source, reply, ...)
    if not ok then
        dprint(('^1[%s]^0 خطا داخل کال‌بک "%s": %s'):format(RES, tostring(name), tostring(err)))
        reply(nil)
    end
end)

-- -------------------------------------------------------- ثبت در هسته ---

local function push(name)
    local ok, res = pcall(function()
        return exports['essentialmode']:RegisterServerCallback(name)
    end)
    if ok and res == true then
        Registered[name] = true
        return true
    end
    return false
end

--- جایگزین امنِ ESX.RegisterServerCallback.
--- امضاش دقیقاً همونه، پس کدِ موجود بدون تغییر کار میکنه.
function RegisterServerCallbackSafe(name, cb)
    if type(name) ~= 'string' or name == '' then
        return dprint(('^1[%s]^0 RegisterServerCallbackSafe: نام نامعتبر'):format(RES))
    end
    if type(cb) ~= 'function' then
        return dprint(('^1[%s]^0 RegisterServerCallbackSafe(%s): کال‌بک تابع نیست'):format(RES, name))
    end

    LocalCallbacks[name] = cb

    CreateThread(function()
        local waited = 0
        while GetResourceState('essentialmode') ~= 'started' and waited < 30000 do
            Wait(100)
            waited = waited + 100
        end
        if GetResourceState('essentialmode') == 'started' then
            push(name)
        end
        -- اگه نشد، تایمر پایین خودش دوباره تلاش میکنه
    end)
end

-- ------------------------------------------- مقاومت در برابر ری‌استارت ---
-- اگه essentialmode جدا ری‌استارت بشه، جدولِ ServerCallbacks اون خالی میشه
-- و همه‌ی ثبت‌های ما از بین میره. هم به رویداد استارت گوش میدیم هم یک
-- تایمر آروم داریم (روی VPS کند، رویداد به‌تنهایی قابل اتکا نبود).

AddEventHandler('onResourceStart', function(resourceName)
    if resourceName ~= 'essentialmode' then return end
    Registered = {}
    CreateThread(function()
        Wait(2000)   -- بذار essentialmode کامل بالا بیاد
        for name in pairs(LocalCallbacks) do push(name) end
    end)
end)

CreateThread(function()
    while true do
        Wait(15000)
        if GetResourceState('essentialmode') == 'started' then
            for name in pairs(LocalCallbacks) do
                if not Registered[name] then push(name) end
            end
        end
    end
end)

-- ------------------------------------------------------------- تشخیص ---

RegisterCommand('reportbridge', function(source)
    if source ~= 0 then return end   -- فقط کنسول سرور
    local total, ok = 0, 0
    for name in pairs(LocalCallbacks) do
        total = total + 1
        if Registered[name] then ok = ok + 1 end
    end
    dprint(('^5[%s]^0 پل کال‌بک: %d از %d ثبت شده. essentialmode: %s')
        :format(RES, ok, total, GetResourceState('essentialmode')))
    for name in pairs(LocalCallbacks) do
        dprint(('   %s %s'):format(Registered[name] and '^2✓^0' or '^1✗^0', name))
    end
end, true)

CreateThread(function()
    Wait(20000)
    local total, ok = 0, 0
    for name in pairs(LocalCallbacks) do
        total = total + 1
        if Registered[name] then ok = ok + 1 end
    end
    if total == 0 then return end
    if ok == total then
        dprint(('^2[%s]^0 هر %d کال‌بک سرور با موفقیت به essentialmode وصل شد.'):format(RES, total))
    else
        dprint(('^1[%s]^0 فقط %d از %d کال‌بک وصل شد. برای جزئیات تو کنسول بزن: reportbridge'):format(RES, ok, total))
    end
end)
