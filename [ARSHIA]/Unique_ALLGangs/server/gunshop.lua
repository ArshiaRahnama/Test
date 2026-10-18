-- ================================================================= --
-- GUN SHOPS (leased to gangs) + ZONE WORKSHOP (craft weapons from materials)
-- ================================================================= --
local G = GunShopCfg
local DAY = 24 * 60 * 60

Shops = {}      -- Shops[id] = { id, label, coords, owner, ownerLabel, expiresAt, paid, bids = { {gang,label,amount,at} } }
Workshop = {}   -- Workshop[zoneKey] = { materials = {[item]=n}, weapons = {[w]=n}, jobs = { {weapon, doneAt} } }

-- ---------------- persistence ----------------
MySQL.ready(function()
    MySQL.Async.execute([[
        CREATE TABLE IF NOT EXISTS `gunshop_shops` (
          `id` int(11) NOT NULL, `owner` varchar(254) DEFAULT NULL, `owner_label` varchar(254) DEFAULT NULL,
          `expires_at` int(255) NOT NULL DEFAULT 0, `paid` int(255) NOT NULL DEFAULT 0,
          `bids` longtext, PRIMARY KEY (`id`)
        ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
    ]])
    MySQL.Async.execute([[
        CREATE TABLE IF NOT EXISTS `zone_workshop` (
          `zone_key` varchar(60) NOT NULL, `data` longtext, PRIMARY KEY (`zone_key`)
        ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
    ]])
    MySQL.Async.fetchAll('SELECT * FROM gunshop_shops', {}, function(rows)
        for _, r in ipairs(rows or {}) do
            local s = Shops[r.id]
            if s then
                s.owner, s.ownerLabel, s.expiresAt, s.paid = r.owner, r.owner_label, tonumber(r.expires_at) or 0, tonumber(r.paid) or 0
                s.bids = (r.bids and r.bids ~= '') and json.decode(r.bids) or {}
            end
        end
    end)
    MySQL.Async.fetchAll('SELECT * FROM zone_workshop', {}, function(rows)
        for _, r in ipairs(rows or {}) do
            Workshop[r.zone_key] = (r.data and r.data ~= '') and json.decode(r.data) or { materials = {}, weapons = {}, jobs = {} }
        end
    end)
end)

function SaveShop(s)
    MySQL.Async.execute([[
        INSERT INTO gunshop_shops (id, owner, owner_label, expires_at, paid, bids) VALUES (@id, @o, @l, @e, @p, @b)
        ON DUPLICATE KEY UPDATE owner = @o, owner_label = @l, expires_at = @e, paid = @p, bids = @b
    ]], { ['@id'] = s.id, ['@o'] = s.owner, ['@l'] = s.ownerLabel, ['@e'] = s.expiresAt or 0, ['@p'] = s.paid or 0, ['@b'] = json.encode(s.bids or {}) })
end

function SaveWorkshop(zoneKey)
    MySQL.Async.execute('INSERT INTO zone_workshop (zone_key, data) VALUES (@z, @d) ON DUPLICATE KEY UPDATE data = @d',
        { ['@z'] = zoneKey, ['@d'] = json.encode(Workshop[zoneKey]) })
end

-- ---------------- shops: init ----------------
for _, def in ipairs(G.Shops) do
    Shops[def.id] = { id = def.id, label = def.label, coords = def.coords, owner = nil, ownerLabel = nil, expiresAt = 0, paid = 0, bids = {} }
end

local function labelOf(gang) return (Gangs[gang] and Gangs[gang].label) or gang end
local function isBossSrc(src)
    local ok, res = pcall(function() return IsGangBoss(src) end)
    return ok and res == true
end
local function gangOfSrc(src)
    local x = ESX.GetPlayerFromId(src)
    if not x or not x.gang or x.gang.name == 'nogang' then return nil end
    return x.gang.name
end
local function note(gang, text)
    for _, pid in ipairs(ESX.GetPlayers()) do
        local x = ESX.GetPlayerFromId(pid)
        if x and x.gang and x.gang.name == gang then
            TriggerClientEvent('esx:showNotification', pid, text)
            TriggerClientEvent('chat:addMessage', pid, { color = { 255, 200, 90 }, args = { 'GUN SHOP', text } })
        end
    end
end

-- client blips: every shop, owned or free
function BroadcastShops(target)
    local out = {}
    for _, s in pairs(Shops) do
        out[#out + 1] = { id = s.id, label = s.label, coords = { x = s.coords.x, y = s.coords.y, z = s.coords.z },
                          owner = s.owner, ownerLabel = s.ownerLabel, expiresAt = s.expiresAt or 0 }
    end
    TriggerClientEvent('GunShop:Sync', target or -1, out)
end

-- ---------------- shops: buying / bidding ----------------
-- Free shop: buy now for BasePrice, the lease starts immediately.
function ShopBuyNow(gang, shopId, now)
    local s = Shops[shopId]
    if not s or not gang then return false, 'Maghaze peyda nashod' end
    if s.owner then return false, 'In maghaze kharide va ghofl ast. Bid bezanid.' end
    if not RemoveGangMoney(gang, G.BasePrice) then return false, 'Pool-e gang kafi nist' end
    s.owner, s.ownerLabel = gang, labelOf(gang)
    s.paid = G.BasePrice
    s.expiresAt = (now or os.time()) + G.LeaseDays * DAY
    s.bids = {}
    SaveShop(s)
    return true, 'Maghaze kharide shod'
end

-- Owned shop: a bid is held (escrow) until the lease ends. A new bid must beat the highest
-- bid of OTHER gangs by BidStep and be at least MinBid. Your own older bid is refunded first.
function ShopBid(gang, shopId, amount, now)
    local s = Shops[shopId]
    if not s or not gang then return false, 'Maghaze peyda nashod' end
    if not s.owner then return false, 'In maghaze ghofl nist - kharide mostaghim bezanid' end
    amount = math.floor(tonumber(amount) or 0)
    local highestOther = 0
    for _, b in ipairs(s.bids) do if b.gang ~= gang and b.amount > highestOther then highestOther = b.amount end end
    local need = math.max(G.MinBid, highestOther > 0 and (highestOther + G.BidStep) or 0)
    if amount < need then return false, ('Bid bayad hadaghal $%d bashe'):format(need) end
    -- refund this gang's older bid first, so the escrow is never counted twice
    for i = #s.bids, 1, -1 do
        if s.bids[i].gang == gang then AddGangMoney(gang, s.bids[i].amount); table.remove(s.bids, i) end
    end
    if not RemoveGangMoney(gang, amount) then return false, 'Pool-e gang kafi nist' end
    s.bids[#s.bids + 1] = { gang = gang, label = labelOf(gang), amount = amount, at = now or os.time() }
    SaveShop(s)
    return true, 'Bid sabt shod'
end

-- Lease end: the highest bid wins (ties: earlier bid). Everybody else gets their escrow back.
-- No bids: the shop becomes free again.
function ShopSettle(s, now)
    now = now or os.time()
    if not s.owner or (s.expiresAt or 0) > now then return end
    local settledAt = now
    local winner
    for _, b in ipairs(s.bids) do
        if not winner or b.amount > winner.amount or (b.amount == winner.amount and b.at < winner.at) then winner = b end
    end
    local lost = {}
    for _, b in ipairs(s.bids) do if not winner or b ~= winner then lost[#lost + 1] = b end end
    for _, b in ipairs(lost) do AddGangMoney(b.gang, b.amount) end
    if winner then
        s.owner, s.ownerLabel, s.paid = winner.gang, winner.label, winner.amount
        s.expiresAt = now + G.LeaseDays * DAY
        note(winner.gang, ('Maghaze "%s" ba bid $%d baraye %d rooz be gang-e shoma reside.'):format(s.label, winner.amount, G.LeaseDays))
    else
        s.owner, s.ownerLabel, s.paid, s.expiresAt = nil, nil, 0, 0
    end
    for _, b in ipairs(lost) do note(b.gang, ('Bid-e shoma baraye "%s" ($%d) bargasht.'):format(s.label, b.amount)) end
    s.bids = {}
    SaveShop(s)
    BroadcastShops()
end

-- Owner gang buys a weapon from its shop catalog (paid from gang money, goes to gang armory).
function ShopBuyWeapon(gang, shopId, weapon)
    local s = Shops[shopId]
    if not s or s.owner ~= gang then return false, 'In maghaze ye gang-e shoma nist' end
    local item
    for _, c in ipairs(G.Catalog) do if c.weapon == weapon then item = c end end
    if not item then return false, 'In aslahe too katalog nist' end
    if not RemoveGangMoney(gang, item.price) then return false, 'Pool-e gang kafi nist' end
    local ok = pcall(function() return exports['Unique_inventory']:AddGangArmoryWeapon(gang, weapon, 1) end)
    if not ok then AddGangMoney(gang, item.price); return false, 'Armory dar dastres nist' end
    return true, 'Aslahe be armory-e gang ezafe shod'
end

-- ---------------- zone workshop ----------------
local function ensureWS(zoneKey)
    if not Workshop[zoneKey] then Workshop[zoneKey] = { materials = {}, weapons = {}, jobs = {} } end
    return Workshop[zoneKey]
end
local function zoneOwner(zoneKey)
    local st = Territories and Territories[zoneKey]
    return st and st.owner or nil
end

-- Boss moves materials from the gang armory into the zone the gang owns.
function WorkshopDeposit(gang, zoneKey, item, count)
    count = math.floor(tonumber(count) or 0)
    if zoneOwner(zoneKey) ~= gang then return false, 'In zone male gang-e shoma nist' end
    if not G.Materials[item] then return false, 'In aitem mavad nist' end
    if count <= 0 then return false, 'Tedad na-motabar' end
    local ok, res = pcall(function() return exports['Unique_inventory']:RemoveGangArmoryItem(gang, item, count) end)
    if not ok or not res then return false, 'Mavad too armory-e gang kafi nist' end
    local w = ensureWS(zoneKey)
    w.materials[item] = (w.materials[item] or 0) + count
    SaveWorkshop(zoneKey)
    return true, ('%dx %s be karghah ezafe shod'):format(count, item)
end

-- Boss starts a craft: the materials are taken now, the weapon appears when the time is up.
function WorkshopCraft(gang, zoneKey, weapon, now)
    if zoneOwner(zoneKey) ~= gang then return false, 'In zone male gang-e shoma nist' end
    local r = G.Recipes[weapon]
    if not r then return false, 'Dastur-e sakht peyda nashod' end
    local w = ensureWS(zoneKey)
    if #w.jobs >= G.Workshop.MaxQueue then return false, 'Karghah por ast' end
    for item, n in pairs(r.ingr) do
        if (w.materials[item] or 0) < n then return false, ('Mavad kafi nist: %s (%d/%d)'):format(item, w.materials[item] or 0, n) end
    end
    for item, n in pairs(r.ingr) do w.materials[item] = w.materials[item] - n end
    w.jobs[#w.jobs + 1] = { weapon = weapon, doneAt = (now or os.time()) + r.time }
    SaveWorkshop(zoneKey)
    return true, ('Sakht %s shoroo shod (%d sanie)'):format(weapon, r.time)
end

-- Finished crafts go into the zone workshop's weapon store.
function WorkshopTick(now)
    now = now or os.time()
    for zoneKey, w in pairs(Workshop) do
        local changed = false
        for i = #w.jobs, 1, -1 do
            if w.jobs[i].doneAt <= now then
                w.weapons[w.jobs[i].weapon] = (w.weapons[w.jobs[i].weapon] or 0) + 1
                table.remove(w.jobs, i)
                changed = true
            end
        end
        if changed then SaveWorkshop(zoneKey) end
    end
end

-- Only the zone's CURRENT owner can take weapons. When the zone changes hands, access moves with it.
function WorkshopWithdraw(gang, zoneKey, weapon)
    if zoneOwner(zoneKey) ~= gang then return false, 'In zone male gang-e shoma nist - aslahe ro gerefte nemishe' end
    local w = ensureWS(zoneKey)
    if (w.weapons[weapon] or 0) < 1 then return false, 'In aslahe dar karghah nist' end
    local ok, res = pcall(function() return exports['Unique_inventory']:AddGangArmoryWeapon(gang, weapon, 1) end)
    if not ok or not res then return false, 'Armory-e gang dar dastres nist' end
    w.weapons[weapon] = w.weapons[weapon] - 1
    SaveWorkshop(zoneKey)
    return true, ('%s be armory-e gang ezafe shod'):format(weapon)
end

-- ---------------- loops ----------------
CreateThread(function()
    while true do
        Wait(60 * 1000)
        local now = os.time()
        for _, s in pairs(Shops) do ShopSettle(s, now) end
        WorkshopTick(now)
    end
end)

-- ---------------- callbacks (ESX) ----------------
ESX.RegisterServerCallback('GunShop:GetAll', function(source, cb)
    local gang = gangOfSrc(source)
    local shops = {}
    for _, s in pairs(Shops) do
        shops[#shops + 1] = { id = s.id, label = s.label, owner = s.owner, ownerLabel = s.ownerLabel, expiresAt = s.expiresAt or 0,
                              paid = s.paid or 0, bids = s.bids or {}, mine = gang ~= nil and s.owner == gang }
    end
    table.sort(shops, function(a, b) return a.id < b.id end)
    cb({ shops = shops, catalog = G.Catalog, isBoss = isBossSrc(source), gang = gang, basePrice = G.BasePrice, minBid = G.MinBid, bidStep = G.BidStep, leaseDays = G.LeaseDays })
end)

ESX.RegisterServerCallback('GunShop:BuyNow', function(source, cb, id)
    local gang = gangOfSrc(source)
    if not isBossSrc(source) then return cb(false, 'Faghat boss mitoone kharid kone') end
    local ok, msg = ShopBuyNow(gang, tonumber(id), os.time())
    if ok then BroadcastShops() end
    cb(ok, msg)
end)

ESX.RegisterServerCallback('GunShop:Bid', function(source, cb, id, amount)
    local gang = gangOfSrc(source)
    if not isBossSrc(source) then return cb(false, 'Faghat boss mitoone bid bezane') end
    local ok, msg = ShopBid(gang, tonumber(id), amount, os.time())
    cb(ok, msg)
end)

ESX.RegisterServerCallback('GunShop:BuyWeapon', function(source, cb, id, weapon)
    local gang = gangOfSrc(source)
    if not gang then return cb(false, 'Gang nadarid') end
    cb(ShopBuyWeapon(gang, tonumber(id), tostring(weapon)))
end)

ESX.RegisterServerCallback('Workshop:Get', function(source, cb, zoneKey)
    local gang = gangOfSrc(source)
    local w = ensureWS(zoneKey)
    cb({ mine = gang ~= nil and zoneOwner(zoneKey) == gang, materials = w.materials, weapons = w.weapons, jobs = w.jobs, recipes = G.Recipes })
end)

ESX.RegisterServerCallback('Workshop:Deposit', function(source, cb, zoneKey, item, count)
    if not isBossSrc(source) then return cb(false, 'Faghat boss') end
    cb(WorkshopDeposit(gangOfSrc(source), zoneKey, tostring(item), count))
end)

ESX.RegisterServerCallback('Workshop:Craft', function(source, cb, zoneKey, weapon)
    if not isBossSrc(source) then return cb(false, 'Faghat boss') end
    cb(WorkshopCraft(gangOfSrc(source), zoneKey, tostring(weapon), os.time()))
end)

ESX.RegisterServerCallback('Workshop:Withdraw', function(source, cb, zoneKey, weapon)
    local gang = gangOfSrc(source)
    if not gang then return cb(false, 'Gang nadarid') end
    cb(WorkshopWithdraw(gang, zoneKey, tostring(weapon)))
end)

