-- Unique_Clothe / server
-- Clothes are INVENTORY ITEMS (item name = Clothes.byName key, e.g. tshirt_m_12_3).
--  * buying   -> money removed, item added to the inventory (server decides prices)
--  * wearing  -> the client reports the worn set, the server validates ownership and
--                merges ONLY the changed clothing keys into users.skin (so a job
--                uniform worn at that moment never gets saved by accident)
--  * packs    -> a saved outfit stored as an inventory item "pack_<id>"

ESX = nil
local RES = GetCurrentResourceName()
local lastBuy, lastUsed = {}, {}
local usedCache = {}          -- identifier -> { [itemName] = true }
local registeredItems = {}

-- ───────────── callback bridge ─────────────
-- ESX.RegisterServerCallback from another resource never reaches essentialmode's real
-- callback table on this base, so we register only the NAME through its export and
-- answer through the relay event (same pattern as Unique_inventory/server/callback_bridge.lua).
local LocalCallbacks, Registered = {}, {}

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
        print(('^1[%s]^0 error in callback "%s": %s'):format(RES, tostring(name), tostring(err)))
        reply(nil)
    end
end)

local function pushCallback(name)
    local ok, res = pcall(function() return exports['essentialmode']:RegisterServerCallback(name) end)
    if ok and res == true then Registered[name] = true return true end
    return false
end

local function registerCallback(name, cb)
    LocalCallbacks[name] = cb
    CreateThread(function()
        local waited = 0
        while GetResourceState('essentialmode') ~= 'started' and waited < 30000 do
            Wait(100)
            waited = waited + 100
        end
        if GetResourceState('essentialmode') == 'started' then pushCallback(name) end
    end)
end

CreateThread(function()
    while true do
        Wait(5000)
        for name in pairs(LocalCallbacks) do
            if not Registered[name] then pushCallback(name) end
        end
    end
end)

CreateThread(function()
    while ESX == nil do
        TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
        Wait(100)
    end
    -- resource restarted while players are online: re-wire their clothes
    for _, id in ipairs(GetPlayers()) do
        pcall(function()
            local xPlayer = ESX.GetPlayerFromId(tonumber(id))
            if xPlayer then registerOwnedClothes(xPlayer) end
        end)
    end
end)

-- ───────────── helpers ─────────────
local function T(key, ...)
    local s = Config.Strings[key] or key
    if select('#', ...) > 0 then return s:format(...) end
    return s
end

local function fail(message) return { success = false, type = 'error', message = message } end

local function accountMoney(xPlayer, name)
    local acc = xPlayer.getAccount(name)
    return acc and acc.money or 0
end

local function ownedCount(xPlayer, name)
    local it = xPlayer.getInventoryItem(name)
    return it and it.count or 0
end

-- Items are created lazily through essentialmode's RegisterItem export (the only
-- way to reach its real ESX.Items; it also INSERT IGNOREs into the items table).
local function ensureItem(name, label, weight)
    if registeredItems[name] then return true end
    local ok, res = pcall(function() return exports['essentialmode']:RegisterItem(name, label, weight) end)
    if ok and res then registeredItems[name] = true return true end
    return false
end

-- "Use" on a clothing item / outfit pack in the inventory. essentialmode keeps usable handlers
-- in memory only, so this is re-done for owned items whenever a player loads. It goes through
-- essentialmode's RegisterUsableItemRelay export (a plain callback cannot cross the resource
-- boundary on this base) which answers with the relay event handled below.
local registeredUsable = {}
local function ensureUsable(name)
    if registeredUsable[name] then return end
    local ok, res = pcall(function() return exports['essentialmode']:RegisterUsableItemRelay(name) end)
    if ok and res then registeredUsable[name] = true end
end

AddEventHandler('essentialmode:relayUsableItem:' .. RES, function(name, source)
    if not ESX or type(name) ~= 'string' then return end
    local xPlayer = ESX.GetPlayerFromId(source)
    if not xPlayer or ownedCount(xPlayer, name) < 1 then return end
    if Clothes.byName[name] then
        TriggerClientEvent('Unique_Clothe:toggle', source, name)
    elseif name:find('^pack_%d+$') then
        TriggerClientEvent('Unique_Clothe:usePack', source, name)
    end
end)

local function ensureClotheItem(item)
    local ok = ensureItem(item.name, item.label, Config.ClotheWeight)
    if ok then ensureUsable(item.name) end
    return ok
end

local function registerOwnedClothes(xPlayer)
    for _, it in ipairs(xPlayer.inventory or {}) do
        if (it.count or 0) > 0 and type(it.name) == 'string' and (Clothes.byName[it.name] or it.name:find('^pack_%d+$')) then
            ensureUsable(it.name)
        end
    end
end

AddEventHandler('esx:playerLoaded', function(_, xPlayer)
    if xPlayer then pcall(registerOwnedClothes, xPlayer) end
end)

local function readSkin(identifier)
    local ok, raw = pcall(MySQL.scalar.await, 'SELECT skin FROM users WHERE identifier = ?', { identifier })
    if ok and raw and raw ~= '' then
        local decoded = json.decode(raw)
        if type(decoded) == 'table' then return decoded end
    end
    return nil
end

local function writeSkin(identifier, skin)
    return (pcall(MySQL.update.await, 'UPDATE users SET skin = ? WHERE identifier = ?', { json.encode(skin), identifier }))
end

local function nearestShop(source)
    local ped = GetPlayerPed(source)
    if not ped or ped == 0 then return nil, true end
    local pc = GetEntityCoords(ped)
    if pc.x == 0.0 and pc.y == 0.0 and pc.z == 0.0 then return nil, true end
    local best, bestDist
    for _, shop in ipairs(Config.Shops) do
        for _, p in ipairs(shop.points) do
            local d = #(pc - p)
            if d <= 15.0 and (not bestDist or d < bestDist) then best, bestDist = shop, d end
        end
    end
    return best, false
end

local function shopAllows(shop, ctype)
    for _, c in ipairs(shop.categories) do
        if c == ctype then return true end
    end
    return false
end

-- ───────────── database ─────────────
CreateThread(function()
    for attempt = 1, 30 do
        local ok = pcall(function()
            MySQL.update.await([[CREATE TABLE IF NOT EXISTS `unique_clothe_used` (
                `identifier` VARCHAR(80) NOT NULL PRIMARY KEY,
                `used` LONGTEXT NULL
            ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4]])
            MySQL.update.await([[CREATE TABLE IF NOT EXISTS `unique_clothe_starter` (
                `identifier` VARCHAR(80) NOT NULL PRIMARY KEY
            ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4]])
            MySQL.update.await([[CREATE TABLE IF NOT EXISTS `unique_clothe_packs` (
                `id` INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
                `identifier` VARCHAR(80) NOT NULL,
                `label` VARCHAR(80) NOT NULL,
                `items` LONGTEXT NOT NULL,
                INDEX (`identifier`)
            ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4]])
        end)
        if ok then return end
        Wait(2000)
    end
    print(('^1[%s]^0 could not create its tables (is oxmysql running?)'):format(RES))
end)

-- ───────────── worn items ─────────────
local function loadUsed(identifier)
    if usedCache[identifier] then return usedCache[identifier] end
    local map = {}
    local ok, raw = pcall(MySQL.scalar.await, 'SELECT used FROM unique_clothe_used WHERE identifier = ?', { identifier })
    if ok and raw and raw ~= '' then
        local decoded = json.decode(raw)
        if type(decoded) == 'table' then
            for name, v in pairs(decoded) do
                if v == true and Clothes.byName[name] then map[name] = true end
            end
        end
    end
    usedCache[identifier] = map
    return map
end

local function typesOf(map)
    local t = {}
    for name in pairs(map) do t[Clothes.byName[name].type] = name end
    return t
end

-- Validates what the client says it is wearing, saves it, and merges only the
-- changed clothing keys into the saved skin. Returns the clean map.
local function applyUsed(source, requested)
    local xPlayer = ESX.GetPlayerFromId(source)
    if not xPlayer or type(requested) ~= 'table' then return nil end
    local identifier = xPlayer.identifier

    local dbSkin = readSkin(identifier)
    local sex = dbSkin and dbSkin.sex or nil

    local clean, n = {}, 0
    local seenType = {}
    for name, v in pairs(requested) do
        n = n + 1
        if n > 40 then break end
        local it = (v == true and type(name) == 'string') and Clothes.byName[name] or nil
        if it and not seenType[it.type] and ownedCount(xPlayer, name) > 0 and (sex == nil or sex == it.sex) then
            clean[name] = true
            seenType[it.type] = true
        end
    end

    local old = loadUsed(identifier)
    local oldTypes, newTypes = typesOf(old), typesOf(clean)

    if dbSkin then
        local changed = false
        local defaults = Config.Defaults[sex == 1 and 1 or 0]
        for ctype in pairs(oldTypes) do
            if not newTypes[ctype] and defaults[ctype] then
                for k, v in pairs(defaults[ctype]) do dbSkin[k] = v end
                changed = true
            end
        end
        for name in pairs(clean) do
            for k, v in pairs(Clothes.byName[name].num) do
                if dbSkin[k] ~= v then dbSkin[k] = v changed = true end
            end
        end
        if changed then writeSkin(identifier, dbSkin) end
    end

    usedCache[identifier] = clean
    pcall(MySQL.update.await, 'INSERT INTO unique_clothe_used (identifier, used) VALUES (?, ?) ON DUPLICATE KEY UPDATE used = VALUES(used)',
        { identifier, json.encode(clean) })
    return clean
end

registerCallback('Unique_Clothe:getUsed', function(source, cb)
    local xPlayer = ESX and ESX.GetPlayerFromId(source)
    if not xPlayer then return cb(nil) end
    cb(loadUsed(xPlayer.identifier))
end)

RegisterNetEvent('Unique_Clothe:setUsed')
AddEventHandler('Unique_Clothe:setUsed', function(requested)
    local src = source
    if not ESX then return end
    local now = GetGameTimer()
    if lastUsed[src] and now - lastUsed[src] < 50 then return end
    lastUsed[src] = now
    local ok, err = pcall(applyUsed, src, requested)
    if not ok then print(('^1[%s]^0 setUsed error: %s'):format(RES, tostring(err))) end
end)

-- ───────────── shop purchase ─────────────
local function processPurchase(source, names)
    local xPlayer = ESX.GetPlayerFromId(source)
    if not xPlayer then return fail(T('invalid')) end

    local now = GetGameTimer()
    if lastBuy[source] and now - lastBuy[source] < 1000 then return fail(T('slow_down')) end
    lastBuy[source] = now

    if type(names) ~= 'table' or #names == 0 or #names > 60 then return fail(T('invalid')) end

    local shop, skipDistance = nearestShop(source)
    if not shop and not skipDistance then return fail(T('invalid')) end

    local dbSkin = readSkin(xPlayer.identifier)
    local sex = dbSkin and dbSkin.sex or nil

    local chosen, total, count = {}, 0, 0
    for _, name in ipairs(names) do
        local item = type(name) == 'string' and Clothes.byName[name] or nil
        if not item or not item.buyable then return fail(T('invalid')) end
        if shop and not shopAllows(shop, item.type) then return fail(T('invalid')) end
        if sex ~= nil and sex ~= item.sex then return fail(T('wrong_sex')) end
        if not chosen[name] then
            if ownedCount(xPlayer, name) > 0 then return fail(T('already_owned')) end
            chosen[name] = item
            total = total + item.price
            count = count + 1
        end
    end

    local maxWeight = xPlayer.maxWeight
    if maxWeight and xPlayer.getUsedWeight() + count * Config.ClotheWeight > maxWeight then
        return fail(T('no_space'))
    end

    local cash = accountMoney(xPlayer, Config.MoneyAccount)
    local bank = Config.UseBankFallback and accountMoney(xPlayer, Config.BankAccount) or 0
    if cash + bank < total then return fail(T('not_enough')) end

    for _, item in pairs(chosen) do
        if not ensureClotheItem(item) then return fail(T('invalid')) end
    end

    local fromCash = math.min(cash, total)
    local fromBank = total - fromCash
    if fromCash > 0 then xPlayer.removeAccountMoney(Config.MoneyAccount, fromCash) end
    if fromBank > 0 then xPlayer.removeAccountMoney(Config.BankAccount, fromBank) end

    local purchased, refund = {}, 0
    for name, item in pairs(chosen) do
        xPlayer.addInventoryItem(name, 1)
        if ownedCount(xPlayer, name) > 0 then
            purchased[name] = true
        else
            refund = refund + item.price -- the inventory refused it: give that money back
        end
    end
    if refund > 0 then xPlayer.addAccountMoney(Config.MoneyAccount, refund) end
    if next(purchased) == nil then return fail(T('give_failed')) end

    return { success = true, type = 'success', message = T('bought', total - refund), purchased = purchased, total = total - refund }
end

registerCallback('Unique_Clothe:buy', function(source, cb, names)
    if not ESX then return cb(fail(T('invalid'))) end
    local ok, result = pcall(processPurchase, source, names)
    if not ok then
        print(('^1[%s]^0 purchase error for %s: %s'):format(RES, source, tostring(result)))
        result = fail(T('invalid'))
    end
    cb(result)
end)

-- ───────────── outfit packs ─────────────
-- (callback / event names are the ones Unique_inventory/client/clothe.lua already uses)
local function packIdFromName(name)
    local id = type(name) == 'string' and name:match('^pack_(%d+)$')
    return id and tonumber(id) or nil
end

local function readPack(xPlayer, packName)
    local id = packIdFromName(packName)
    if not id or ownedCount(xPlayer, packName) < 1 then return nil end
    local ok, row = pcall(MySQL.single.await, 'SELECT items FROM unique_clothe_packs WHERE id = ? AND identifier = ?', { id, xPlayer.identifier })
    if not ok or not row then return nil end
    local items = json.decode(row.items)
    return type(items) == 'table' and items or nil, id
end

registerCallback('clothe:getPackData', function(source, cb, packName)
    local xPlayer = ESX and ESX.GetPlayerFromId(source)
    if not xPlayer then return cb(nil) end
    cb((readPack(xPlayer, packName)))
end)

registerCallback('clothe:usePack', function(source, cb, packName)
    local xPlayer = ESX and ESX.GetPlayerFromId(source)
    if not xPlayer then return cb(nil) end
    local items, id = readPack(xPlayer, packName)
    if not items then return cb(nil) end

    local give = {}
    for name in pairs(items) do
        local it = Clothes.byName[name]
        if it then give[#give + 1] = it end
    end
    local maxWeight = xPlayer.maxWeight
    if maxWeight and xPlayer.getUsedWeight() + #give * Config.ClotheWeight - Config.PackWeight > maxWeight then
        return cb(nil)
    end

    xPlayer.removeInventoryItem(packName, 1)
    pcall(MySQL.update.await, 'DELETE FROM unique_clothe_packs WHERE id = ?', { id })

    local result = {}
    for _, it in ipairs(give) do
        if ownedCount(xPlayer, it.name) < 1 then
            ensureClotheItem(it)
            xPlayer.addInventoryItem(it.name, 1)
        end
        result[it.name] = true
    end
    cb(result)
end)

RegisterNetEvent('clothe:createPack')
AddEventHandler('clothe:createPack', function(toPack, label)
    local src = source
    local xPlayer = ESX and ESX.GetPlayerFromId(src)
    if not xPlayer or type(toPack) ~= 'table' then return end
    if type(label) ~= 'string' then label = '' end
    label = label:gsub('[%c]', ''):sub(1, Config.MaxPackNameLen)
    if label == '' then label = 'Outfit' end

    local items, n = {}, 0
    for name, v in pairs(toPack) do
        local it = (v == true and type(name) == 'string') and Clothes.byName[name] or nil
        if it and ownedCount(xPlayer, name) > 0 then
            items[name] = true
            n = n + 1
        end
    end
    if n < 2 or n > 20 then return end

    -- The pieces go into the pack, so they cannot stay worn. The client takes them off first,
    -- but its debounced setUsed can arrive AFTER this event - so do it here as well instead
    -- of refusing (which would silently lose the pack).
    local used = loadUsed(xPlayer.identifier)
    local stillWorn = false
    for name in pairs(items) do
        if used[name] then stillWorn = true break end
    end
    if stillWorn then
        local rest = {}
        for name in pairs(used) do
            if not items[name] then rest[name] = true end
        end
        applyUsed(src, rest)
    end

    local ok, id = pcall(MySQL.insert.await, 'INSERT INTO unique_clothe_packs (identifier, label, items) VALUES (?, ?, ?)',
        { xPlayer.identifier, label, json.encode(items) })
    if not ok or not id then return end

    local packName = 'pack_' .. id
    if not ensureItem(packName, label, Config.PackWeight) then
        pcall(MySQL.update.await, 'DELETE FROM unique_clothe_packs WHERE id = ?', { id })
        return
    end
    ensureUsable(packName)
    for name in pairs(items) do xPlayer.removeInventoryItem(name, 1) end
    xPlayer.addInventoryItem(packName, 1)
end)

-- ───────────── starter clothes ─────────────
local gaveStarter = {}

RegisterNetEvent('Unique_Clothe:giveStarter')
AddEventHandler('Unique_Clothe:giveStarter', function()
    local src = source
    if not ESX or gaveStarter[src] then return end
    gaveStarter[src] = true
    Wait(1500) -- let the character creator's skin save land first
    local xPlayer = ESX.GetPlayerFromId(src)
    if not xPlayer then return end

    -- once per character, ever (not just once per connection)
    local okIns, affected = pcall(MySQL.update.await,
        'INSERT IGNORE INTO unique_clothe_starter (identifier) VALUES (?)', { xPlayer.identifier })
    if not okIns or not affected or affected < 1 then return end

    local dbSkin = readSkin(xPlayer.identifier)
    local list = Config.StarterClothes[dbSkin and dbSkin.sex == 1 and 1 or 0] or {}
    for _, name in ipairs(list) do
        local it = Clothes.byName[name]
        if it and ownedCount(xPlayer, name) < 1 then
            ensureClotheItem(it)
            xPlayer.addInventoryItem(name, 1)
        end
    end
end)

AddEventHandler('playerDropped', function()
    local src = source
    lastBuy[src], lastUsed[src], gaveStarter[src] = nil, nil, nil
    local ok, xPlayer = pcall(function() return ESX and ESX.GetPlayerFromId(src) end)
    if ok and xPlayer then usedCache[xPlayer.identifier] = nil end
    -- xPlayer is often already gone when playerDropped fires, which used to leave the
    -- cache entry behind forever: also clear by the raw identifiers of the connection
    for _, id in ipairs(GetPlayerIdentifiers(src) or {}) do usedCache[id] = nil end
end)
