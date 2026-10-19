-- Auction House (server). UCConfig: auctionhouse/config.lua (Config_ah).
-- The client only sends a listing id, an item name and a number. Price, owner,
-- stock and bank money are always read/checked here.

ESX = ESX or nil
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

local function lower(s) return string.lower(tostring(s or '')) end
local function isWeapon(name) return string.find(name, 'WEAPON_') ~= nil end

-- Whole number inside [min, max] or nil.
local function toInt(v, min, max)
    local n = tonumber(v)
    if not n then return nil end
    n = math.floor(n)
    if n < min or n > max then return nil end
    return n
end

local function playerCoords(src)
    local ped = GetPlayerPed(src)
    if not ped or ped == 0 then return nil end
    return GetEntityCoords(ped)
end

-- Gun shops (Unique_ALLGangs) are the auction houses. Each gun shop is run by its owner gang.
local function gunShops()
    local ok, list = pcall(function() return GunShopsForAH() end)
    if ok and type(list) == 'table' then return list end
    return {}
end

-- Weapons a gun shop sells = its catalog. Extra items come from Config_ah.ValidItems.
local function catalogSet()
    local set = {}
    local ok, list = pcall(function() return GunShopWeaponCatalog() end)
    if ok and type(list) == 'table' then
        for _, w in ipairs(list) do set[w] = true end
    end
    return set
end

-- The owned gun shop the player is standing at (nil if none, or no owner).
local function ownedShopAt(src)
    local p = playerCoords(src)
    if not p then return nil end
    for _, s in ipairs(gunShops()) do
        if s.coords and #(p - vector3(s.coords.x, s.coords.y, s.coords.z)) <= 10.0 then
            return s.owner and s or nil
        end
    end
    return nil
end

-- Standing at any gun shop, owned or not.
local function nearAnyGunShop(src)
    local p = playerCoords(src)
    if not p then return false end
    for _, s in ipairs(gunShops()) do
        if s.coords and #(p - vector3(s.coords.x, s.coords.y, s.coords.z)) <= 10.0 then return true end
    end
    return false
end

-- Member = holds the gang that owns this gun shop.
local function isOwnerOf(xPlayer, shop)
    if not xPlayer or not shop or not shop.owner then return false end
    return xPlayer.gang ~= nil and xPlayer.gang.name ~= nil and lower(xPlayer.gang.name) == lower(shop.owner)
end

-- Weapons: must be in the gun shop catalog. Other items: the extras list.
local function allowedIn(item)
    if isWeapon(item) then return catalogSet()[item] == true end
    for _, name in ipairs(Config_ah.ValidItems['Mafia'] or {}) do
        if name == item and not isWeapon(name) then return true end
    end
    return false
end

local function weaponAmmo(xPlayer, name)
    for _, w in ipairs(xPlayer.loadout or {}) do
        if w.name == name then return tonumber(w.ammo) or 0 end
    end
    return 0
end

local function labelOf(xPlayer, name)
    if isWeapon(name) then return name end
    local it = xPlayer.getInventoryItem(name)
    return (it and it.label) or name
end

local function hasSpaceFor(xPlayer, name, amount)
    if isWeapon(name) then return true end
    local it = xPlayer.getInventoryItem(name)
    if not it then return false end
    if it.limit ~= -1 and it.count + amount > it.limit then return false end
    return true
end

-- Pay a seller, online or offline.
local function payIdentifier(identifier, amount)
    local xp = ESX.GetPlayerFromIdentifier(identifier)
    if xp then
        xp.addBank(amount)
    else
        addBankMoney(identifier, amount)
    end
end

local function notify(src, msg)
    TriggerClientEvent('esx:showNotification', src, msg)
end

local function sendDiscord(text)
    local hook = Config_ah.Webhook
    if not hook or hook == '' then return end
    local embed = {{
        ['color'] = 65280,
        ['title'] = 'Product Announce',
        ['fields'] = {{ ['name'] = 'Info:', ['value'] = text }},
        ['footer'] = { ['text'] = 'Auction House', ['icon_url'] = Config_ah.Icon },
    }}
    PerformHttpRequest(hook, function() end, 'POST',
        json.encode({ username = 'Shop', embeds = embed, avatar_url = Config_ah.Icon }),
        { ['Content-Type'] = 'application/json' })
end

-- ── callbacks ───────────────────────────────────────────────────────────────

-- Listings for the shop the player stands at. Anyone can buy; only members sell.
-- Gun shop list for the client's markers (owned and free).
ESX.RegisterServerCallback('auction-house2:GetShops', function(source, cb)
    local out = {}
    for _, s in ipairs(gunShops()) do
        if s.owner then
            out[#out + 1] = { key = s.key, label = s.label, coords = s.coords, owner = s.owner }
        end
    end
    cb(out)
end)

ESX.RegisterServerCallback('auction-house2:GetShopItems', function(source, cb)
    local xPlayer = ESX.GetPlayerFromId(source)
    local shop = xPlayer and ownedShopAt(source)
    if not shop then return cb({ shop = nil }) end

    MySQL.Async.fetchAll('SELECT id, owner, item, amount, price FROM auctionhouse2 WHERE job = @job ORDER BY id DESC',
        { ['@job'] = shop.key }, function(rows)
            local mItems, sItems = {}, {}
            for _, r in ipairs(rows or {}) do
                local mine = (r.owner == xPlayer.identifier)
                local entry = {
                    id = r.id, name = r.item, label = labelOf(xPlayer, r.item),
                    amount = r.amount, price = r.price, mine = mine,
                }
                table.insert(sItems, entry)          -- the market shows everything, yours included
                if mine then table.insert(mItems, entry) end
            end
            cb({ shop = { key = shop.key, label = shop.label, owner = shop.owner }, canSell = isOwnerOf(xPlayer, shop), mItems = mItems, sItems = sItems })
        end)
end)

-- Items the player may list (member + allowed item + has them).
ESX.RegisterServerCallback('auction-house2:GetSellItems', function(source, cb)
    local xPlayer = ESX.GetPlayerFromId(source)
    local shop = xPlayer and ownedShopAt(source)
    if not shop or not isOwnerOf(xPlayer, shop) then return cb({}) end

    local list = {}
    for _, it in ipairs(xPlayer.inventory or {}) do
        if it.count and it.count >= 1 and allowedIn(it.name) then
            table.insert(list, { name = it.name, label = it.label or it.name, amount = it.count })
        end
    end
    for _, w in ipairs(xPlayer.loadout or {}) do
        if allowedIn(w.name) and (tonumber(w.ammo) or 0) > 0 then
            table.insert(list, { name = w.name, label = w.name, amount = tonumber(w.ammo) })
        end
    end
    cb(list)
end)

-- ── events ──────────────────────────────────────────────────────────────────

RegisterServerEvent('auction-house2:AddItemToShop', function(data)
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)
    if not xPlayer or type(data) ~= 'table' then return end

    local shop = ownedShopAt(src)
    if not shop or not isOwnerOf(xPlayer, shop) then
        return notify(src, 'You do not have access to sell here.')
    end

    local item = type(data.item) == 'string' and data.item or nil
    if not item or #item > 64 or not allowedIn(item) then
        return notify(src, 'This item cannot be sold here.')
    end

    local price = toInt(data.price, 1, 1000000000)
    if not price then return notify(src, 'Invalid price.') end

    local amount
    if isWeapon(item) then
        amount = weaponAmmo(xPlayer, item)
        if amount <= 0 then return notify(src, 'You do not have this weapon.') end
        xPlayer.removeWeapon(item, amount)
    else
        amount = toInt(data.amount, 1, 100000)
        if not amount then return notify(src, 'Invalid amount.') end
        local inv = xPlayer.getInventoryItem(item)
        if not inv or inv.count < amount then
            return notify(src, "You don't have enough of this item.")
        end
        xPlayer.removeInventoryItem(item, amount)
    end

    MySQL.Async.execute('INSERT INTO auctionhouse2 (owner, item, amount, price, job) VALUES (@owner, @item, @amount, @price, @job)', {
        ['@owner'] = xPlayer.identifier, ['@item'] = item, ['@amount'] = amount,
        ['@price'] = price, ['@job'] = shop.key,
    }, function(affected)
        if not affected or affected < 1 then
            -- give it back if the insert failed
            if isWeapon(item) then xPlayer.addWeapon(item, amount) else xPlayer.addInventoryItem(item, amount) end
            return notify(src, 'Could not list the item. It was returned to you.')
        end
        notify(src, 'Item listed.')
        TriggerClientEvent('auction-house2:RefreshShop', src)
    end)

    if data.discord and (Config_ah.Webhook or '') ~= '' then
        if (getBankMoney(src) or 0) >= 30000 then
            removeBankMoney(src, 30000)
            sendDiscord(item .. '\nAmount: ' .. amount .. '\nPrice: ' .. price .. '$')
        else
            notify(src, "You don't have enough money for the Discord announcement.")
        end
    end
end)

RegisterServerEvent('auction-house2:RemoveItemFromShop', function(data)
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)
    if not xPlayer or type(data) ~= 'table' then return end
    if not nearAnyGunShop(src) then return notify(src, 'You are not at a gun shop.') end

    local id = toInt(data.id, 1, 2147483647)
    if not id then return end

    local row = MySQL.Sync.fetchAll('SELECT id, owner, item, amount FROM auctionhouse2 WHERE id = @id AND owner = @owner',
        { ['@id'] = id, ['@owner'] = xPlayer.identifier })[1]
    if not row then return notify(src, 'This listing is not yours or no longer exists.') end

    if not hasSpaceFor(xPlayer, row.item, row.amount) then
        return notify(src, 'Not enough space in your inventory.')
    end

    -- Only one request can delete the row; the item is given only after that succeeds.
    local affected = MySQL.Sync.execute('DELETE FROM auctionhouse2 WHERE id = @id AND owner = @owner',
        { ['@id'] = id, ['@owner'] = xPlayer.identifier })
    if (affected or 0) ~= 1 then return notify(src, 'Listing already changed.') end

    if isWeapon(row.item) then
        xPlayer.addWeapon(row.item, row.amount)
    else
        xPlayer.addInventoryItem(row.item, row.amount)
    end
    notify(src, 'Listing removed.')
    TriggerClientEvent('auction-house2:RefreshShop', src)
end)

RegisterServerEvent('auction-house2:BuyItemFromShop', function(data)
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)
    if not xPlayer or type(data) ~= 'table' then return end
    local shop = ownedShopAt(src)
    if not shop then return notify(src, 'Buy from an owned gun shop.') end

    local id = toInt(data.id, 1, 2147483647)
    if not id then return end

    local row = MySQL.Sync.fetchAll('SELECT id, owner, item, amount, price, job FROM auctionhouse2 WHERE id = @id', { ['@id'] = id })[1]
    if not row then return notify(src, 'This listing no longer exists.') end
    if row.job ~= shop.key then return notify(src, 'This listing is at another gun shop.') end
    if row.owner == xPlayer.identifier then return notify(src, "You can't buy your own item.") end

    local price = tonumber(row.price) or 0
    if (getBankMoney(src) or 0) < price then return notify(src, "You don't have enough money.") end
    if not hasSpaceFor(xPlayer, row.item, row.amount) then return notify(src, 'Not enough space in your inventory.') end

    -- Atomic claim: whoever deletes the row first buys it.
    local affected = MySQL.Sync.execute('DELETE FROM auctionhouse2 WHERE id = @id', { ['@id'] = id })
    if (affected or 0) ~= 1 then return notify(src, 'Someone else bought this item first.') end

    removeBankMoney(src, price)
    if isWeapon(row.item) then
        xPlayer.addWeapon(row.item, row.amount)
    else
        xPlayer.addInventoryItem(row.item, row.amount)
    end
    payIdentifier(row.owner, price)

    notify(src, ('You bought %s x%d for $%d.'):format(row.item, row.amount, price))
    TriggerClientEvent('auction-house2:RefreshShop', src)
end)
