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
local MaxDropsPer2Min = (HudConfig and HudConfig.MaxDrops) or 15    -- همون محدودیتی که کلاینت (AlreadyDroped) هم نشون میده، ولی اینجا واقعیه

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
    local tid = tonumber(target)
    if tid and tid ~= src and GetPlayerName(tid) then
        local ok, allow = pcall(function() return Player(tid).state.uq_allowGive end)
        if ok and allow == false then
            TriggerClientEvent('esx:showNotification', src, 'This player does not accept items')
            return
        end
    end
    lastGiveAt[src] = now()
    TriggerEvent('esx:giveInventoryItem', target, itemType, itemName, itemCount)
end)

-- Drops an item on the ground without depending on `source` surviving a
-- local TriggerEvent (that is what produced the nil `xPlayer` errors).
local DropESX = nil
TriggerEvent('esx:getSharedObject', function(obj) DropESX = obj end)

function UQ_DropItem(src, itemType, itemName, itemCount, ammo)
    if not DropESX or not DropESX.CreatePickup then return false end
    local xPlayer = DropESX.GetPlayerFromId(src)
    if not xPlayer then return false end
    itemCount = math.floor(tonumber(itemCount) or 0)
    if itemCount < 1 then return true end
    local ok, res = pcall(function()
        if itemType == 'item_standard' then
            local name = string.lower(itemName)
            local xItem = xPlayer.getInventoryItem(name)
            if not xItem or xItem.count < itemCount then return false end
            xPlayer.removeInventoryItem(name, itemCount)
            DropESX.CreatePickup('item_standard', name, itemCount, (xItem.label or name) .. ' [' .. itemCount .. ']', src)
            return true
        elseif itemType == 'item_money' then
            if xPlayer.getMoney() < itemCount then return false end
            xPlayer.removeMoney(itemCount)
            DropESX.CreatePickup('item_money', 'money', itemCount, '~g~$' .. itemCount, src)
            return true
        elseif itemType == 'item_account' or itemType == 'black_money' then
            local acc = xPlayer.getAccount('black_money')
            if not acc or acc.money < itemCount then return false end
            xPlayer.removeAccountMoney('black_money', itemCount)
            DropESX.CreatePickup('item_account', 'black_money', itemCount, '~r~$' .. itemCount .. ' dirty', src)
            return true
        elseif itemType == 'item_weapon' then
            local w = string.upper(itemName)
            -- xPlayer.getWeapon throws "invalid vector field: ammo" on this server,
            -- so never call it. hasWeapon is pcall'd for the same reason.
            local okH, has = pcall(xPlayer.hasWeapon, w)
            if okH and has == false then return false end
            ammo = math.max(0, math.min(math.floor(tonumber(ammo) or 0), 9999))
            local okR, errR = pcall(xPlayer.removeWeapon, w)
            if not okR then print(('[Unique_inventory] removeWeapon %s: %s'):format(w, tostring(errR))) end
            local label = (GetCachedWeaponLabel and GetCachedWeaponLabel(w)) or w
            DropESX.CreatePickup('item_weapon', w, ammo, label .. ' [' .. ammo .. ']', src)
            return true
        end
        return false
    end)
    if not ok then
        print(('[Unique_inventory] drop failed for %s: %s'):format(tostring(src), tostring(res)))
        return false
    end
    return res == true
end

RegisterServerEvent('Unique_inventory:dropItem')
AddEventHandler('Unique_inventory:dropItem', function(itemType, itemName, itemCount, serial, ammo)
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
    itemCount = tonumber(itemCount)
    if type(itemName) ~= 'string' or not itemCount or itemCount < 1 then return end
    -- essentialmode's handler throws "attempt to index a nil value (xPlayer)"
    -- when the player is not loaded yet / already dropped; never let that
    -- bubble up as a red console error.
    local done = UQ_DropItem(src, itemType, itemName, itemCount, ammo)
    if not done then
        -- no fallback to essentialmode's handler: it throws on nil xPlayer / virtual items (keys)
        TriggerClientEvent('esx:showNotification', src, 'This item cannot be dropped')
    end
end)

AddEventHandler('playerDropped', function()
    lastGiveAt[source] = nil
    dropLog[source] = nil
end)
