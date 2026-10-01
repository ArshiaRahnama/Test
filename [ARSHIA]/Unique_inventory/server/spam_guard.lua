--[[ ===========================================================================
    Unique_inventory | server/spam_guard.lua

    ---------------------------------------------------------------------------
    چرا این فایل لازم بود
    ---------------------------------------------------------------------------
    client/inventory_main.lua یه تابع `SpamCheck()` داره که قبل از fire کردن
    "esx:removeInventoryItem" (Drop) و "esx:giveInventoryItem" (Give) صدا زده
    میشه. این چک صرفاً روی کلاینت اجراست: هر کسی که مود/اکسپلویت داشته باشه
    میتونه با TriggerServerEvent مستقیم، این دو رویداد رو با هر سرعتی که
    بخواد فایر کنه (spam drop برای لَگ‌دادن به سرور/زمین، یا spam give برای
    دور زدن هر انتی‌چیت مبتنی بر فرکانس). این فایل یه کول‌داون واقعی سمت
    سرور، برای هر پلیر، میذاره - جدا از کلاینت و غیرقابل‌دورزدن با مود.

    ---------------------------------------------------------------------------
    نحوه‌ی کار
    ---------------------------------------------------------------------------
    کلاینت به‌جای صدا زدن مستقیم "esx:giveInventoryItem"/"esx:removeInventoryItem"،
    این دو رویداد رو صدا میزنه:

        TriggerServerEvent("Unique_inventory:giveItem", target, type, item, count)
        TriggerServerEvent("Unique_inventory:dropItem", type, item, count, serial)

    این فایل کول‌داون رو چک می‌کنه و در صورت رد شدن، همون آرگومان‌ها رو با
    TriggerEvent (نه TriggerServerEvent) به رویداد اصلی essentialmode پاس
    میده - source همون تیکِ فعلی حفظ میشه، پس هیچ منطقی جای دیگه عوض نمیشه.
=========================================================================== ]]

local GiveCooldownMs = 700   -- حداقل فاصله بین دو تا "Give" پشت‌سرهم
local DropCooldownMs = 700   -- حداقل فاصله بین دو تا "Drop" پشت‌سرهم
local MaxDropsPer2Min = 3    -- همون محدودیتی که کلاینت (AlreadyDroped) هم نشون میده، ولی اینجا واقعیه

local lastGiveAt = {}
local dropLog    = {} -- src -> { timestamps... } تو ۲ دقیقه‌ی اخیر

local function now() return GetGameTimer() end

local function pruneDropLog(src)
    local list = dropLog[src]
    if not list then return {} end
    local cutoff = now() - 120000
    local kept = {}
    for _, t in ipairs(list) do
        if t >= cutoff then kept[#kept + 1] = t end
    end
    dropLog[src] = kept
    return kept
end

RegisterServerEvent('Unique_inventory:giveItem')
AddEventHandler('Unique_inventory:giveItem', function(target, itemType, itemName, itemCount)
    local src = source
    local last = lastGiveAt[src]
    if last and (now() - last) < GiveCooldownMs then
        return -- silently dropped: client is spamming faster than the UI allows
    end
    lastGiveAt[src] = now()
    TriggerEvent('esx:giveInventoryItem', target, itemType, itemName, itemCount)
end)

RegisterServerEvent('Unique_inventory:dropItem')
AddEventHandler('Unique_inventory:dropItem', function(itemType, itemName, itemCount, serial)
    local src = source
    local list = pruneDropLog(src)

    if #list > 0 and (now() - list[#list]) < DropCooldownMs then
        return
    end
    if #list >= MaxDropsPer2Min then
        TriggerClientEvent('esx:showNotification', src, 'You can drop a maximum of 3 items per 2 minutes, please wait')
        return
    end

    list[#list + 1] = now()
    dropLog[src] = list
    TriggerEvent('esx:removeInventoryItem', itemType, itemName, itemCount, serial)
end)

AddEventHandler('playerDropped', function()
    lastGiveAt[source] = nil
    dropLog[source] = nil
end)
