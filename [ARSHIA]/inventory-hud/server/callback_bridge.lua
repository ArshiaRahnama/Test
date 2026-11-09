--[[ ===========================================================================
    Unique_inventory | server/callback_bridge.lua

    ⚠ این فایل باید اولین فایل داخل server_scripts این ریسورس باشه.

    ---------------------------------------------------------------------------
    چرا این فایل لازم بود (باگ واقعی، تایید شده)
    ---------------------------------------------------------------------------
    هر سه ریسورس قبلی (esx_inventory, esx_inventoryhud, esx_inventoryhud_trunk)
    یک کپیِ محلی از ESX می‌گرفتن:

        TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

    و بعد مستقیم روی همون کپی می‌نوشتن:

        ESX.RegisterServerCallback("esx_inventoryhud:GetData", function(...) ... end)

    طبق مستندات خودِ essentialmode (BASE/essentialmode/server/common.lua،
    کامنت بالای RegisterServerCallback): چون این سرور es_extended نداره و
    essentialmode یک بیلد ادغام‌شده‌ست، کپی‌ای که از esx:getSharedObject گرفته
    میشه یک اسنپ‌شاتِ یک‌باره‌ست - رویدادها آرگومان‌هاشونو سریالایز میکنن، رفرنس
    زنده‌ی جدول رو به اشتراک نمیذارن. یعنی نوشتن روی ESX.ServerCallbacks اون
    کپی، هیچ‌وقت به جدولِ واقعیِ essentialmode نمیرسه. کلاینت با
    ESX.TriggerServerCallback همون جدولِ واقعی رو صدا میزنه و کال‌بک رو
    "does not exist" پیدا نمیکنه - یعنی:

        - Parzival:getHouseINV / getGangINV / getJobINV1 / getJobINV2
        - esx_inventoryhud:GetData / getPlayerInventory2323 / getPlayerInventory /
          getPlayerInventory1 / GetHouseItems / updateCraft / calculateCraft
        - esx_trunk:getInventoryV و کال‌بک‌های دیگه‌ی صندوق‌عقب

    همه‌شون با این الگو ثبت شده بودن و به همین دلیل بی‌صدا شکست میخوردن.

    ---------------------------------------------------------------------------
    راه‌حل
    ---------------------------------------------------------------------------
    essentialmode خودش یک export واقعی برای همین مشکل داره:

        exports['essentialmode']:RegisterServerCallback(name)

    که فقط اسم رو ثبت میکنه (صاحبش با GetInvokingResource() مشخص میشه) و یک
    relay میسازه: کلاینت -> essentialmode -> event به همین ریسورس ->
    کال‌بک واقعی همینجا اجرا میشه -> جواب برمیگرده. هیچ تابعی از مرز ریسورس
    رد نمیشه، فقط دیتای ساده. RegisterServerCallbackSafe جایگزین امنِ
    ESX.RegisterServerCallback هست با همون امضا - کدِ موجود بدون تغییر منطق
    کار میکنه، فقط اسم تابع عوض شده.
=========================================================================== ]]

local RES            = GetCurrentResourceName()
local LocalCallbacks  = {}
local Registered      = {}

AddEventHandler('essentialmode:relayServerCallback:' .. RES, function(name, requestId, source, ...)
    local fn = LocalCallbacks[name]
    if not fn then
        return TriggerEvent('essentialmode:relayServerCallbackReply', requestId)
    end

    local replied = false
    local function reply(...)
        if replied then return end
        replied = true
        TriggerEvent('essentialmode:relayServerCallbackReply', requestId, ...)
    end

    local ok, err = pcall(fn, source, reply, ...)
    if not ok then
        print(('^1[%s]^0 خطا داخل کال‌بک "%s": %s'):format(RES, tostring(name), tostring(err)))
        reply(nil)
    end
end)

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

--- جایگزین امنِ ESX.RegisterServerCallback. امضاش دقیقاً همونه.
function RegisterServerCallbackSafe(name, cb)
    if type(name) ~= 'string' or name == '' then
        return print(('^1[%s]^0 RegisterServerCallbackSafe: نام نامعتبر'):format(RES))
    end
    if type(cb) ~= 'function' then
        return print(('^1[%s]^0 RegisterServerCallbackSafe(%s): کال‌بک تابع نیست'):format(RES, name))
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
    end)
end

-- کال‌بک‌هایی که موفق نشدن ثبت بشن (essentialmode هنوز بالا نیومده بود) رو
-- هر ۵ ثانیه دوباره امتحان کن.
CreateThread(function()
    while true do
        Wait(5000)
        for name in pairs(LocalCallbacks) do
            if not Registered[name] then
                push(name)
            end
        end
    end
end)
