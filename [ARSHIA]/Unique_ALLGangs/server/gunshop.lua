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
    MySQL.Async.execute("ALTER TABLE gunshop_shops ADD COLUMN IF NOT EXISTS `stock` longtext", {})
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
                s.stock = (r.stock and r.stock ~= '') and json.decode(r.stock) or {}
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
        INSERT INTO gunshop_shops (id, owner, owner_label, expires_at, paid, bids, stock) VALUES (@id, @o, @l, @e, @p, @b, @st)
        ON DUPLICATE KEY UPDATE owner = @o, owner_label = @l, expires_at = @e, paid = @p, bids = @b, stock = @st
    ]], { ['@id'] = s.id, ['@o'] = s.owner, ['@l'] = s.ownerLabel, ['@e'] = s.expiresAt or 0, ['@p'] = s.paid or 0,
          ['@b'] = json.encode(s.bids or {}), ['@st'] = json.encode(s.stock or {}) })
end

function SaveWorkshop(zoneKey)
    MySQL.Async.execute('INSERT INTO zone_workshop (zone_key, data) VALUES (@z, @d) ON DUPLICATE KEY UPDATE data = @d',
        { ['@z'] = zoneKey, ['@d'] = json.encode(Workshop[zoneKey]) })
end

-- ---------------- shops: init ----------------
for _, def in ipairs(G.Shops) do
    Shops[def.id] = { id = def.id, label = def.label, coords = def.coords, owner = nil, ownerLabel = nil, expiresAt = 0, paid = 0, bids = {}, stock = {} }
end

local function labelOf(gang) return (Gangs[gang] and Gangs[gang].label) or gang end
-- a gang may hold ONE gun shop only
local function ownsAnotherShop(gang, shopId)
    for id, s in pairs(Shops) do if id ~= shopId and s.owner == gang then return true end end
    return false
end
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
    if ownsAnotherShop(gang, shopId) then return false, 'Gang-e shoma yek maghaze darad. Har gang faghat yek maghaze mitoone dashte bashe.' end
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
    if ownsAnotherShop(gang, shopId) then return false, 'Gang-e shoma yek maghaze darad. Har gang faghat yek maghaze mitoone dashte bashe.' end
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

-- Owner moves weapons from the gang armory into its shop stock (the NPC sells only stock).
function ShopDepositStock(gang, shopId, weapon, count)
    local s = Shops[shopId]
    count = math.floor(tonumber(count) or 0)
    if not s or s.owner ~= gang then return false, 'In maghaze ye gang-e shoma nist' end
    if count <= 0 then return false, 'Tedad na-motabar' end
    if not weapon or not weapon:match('^WEAPON_') then return false, 'Faghat aslahe ro mitoon too maghaze bezarid' end
    local ok, res = pcall(function() return exports['Unique_inventory']:RemoveGangArmoryWeapon(gang, weapon, count) end)
    if not ok or not res then return false, 'Aslahe too armory-e gang kafi nist' end
    s.stock = s.stock or {}
    s.stock[weapon] = (s.stock[weapon] or 0) + count
    SaveShop(s)
    return true, ('%dx %s be maghaze ezafe shod'):format(count, weapon)
end

-- Can the NPC sell this to this buyer now? Weapons of an OWNED shop need stock. Everything else is open.
function ShopCanSell(shopId, weapon, amount)
    local s = Shops[shopId]
    if not s or not s.owner then return true end
    if not weapon or not weapon:match('^WEAPON_') then return true end
    return ((s.stock or {})[weapon] or 0) >= (amount or 1)
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

-- Zone armory: the zone's owner puts weapons from its gang armory into the zone's store.
function WorkshopDepositWeapon(gang, zoneKey, weapon, count)
    count = math.floor(tonumber(count) or 0)
    if zoneOwner(zoneKey) ~= gang then return false, 'In zone male gang-e shoma nist' end
    if not weapon or not weapon:match('^WEAPON_') or count <= 0 then return false, 'Aslahe ya tedad na-motabar' end
    local ok, res = pcall(function() return exports['Unique_inventory']:RemoveGangArmoryWeapon(gang, weapon, count) end)
    if not ok or not res then return false, 'Aslahe too armory-e gang kafi nist' end
    local w = ensureWS(zoneKey)
    w.weapons[weapon] = (w.weapons[weapon] or 0) + count
    SaveWorkshop(zoneKey)
    return true, ('%dx %s be armory-e zone ezafe shod'):format(count, weapon)
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
        shops[#shops + 1] = { id = s.id, label = s.label, coords = { x = s.coords.x, y = s.coords.y, z = s.coords.z }, owner = s.owner, ownerLabel = s.ownerLabel, expiresAt = s.expiresAt or 0,
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
    local now = os.time()
    local jobs = {}
    for _, j in ipairs(w.jobs) do
        local rec = G.Recipes[j.weapon] or { time = 1 }
        jobs[#jobs + 1] = { weapon = j.weapon, remaining = math.max(0, j.doneAt - now), total = rec.time }
    end
    cb({ mine = gang ~= nil and zoneOwner(zoneKey) == gang, isBoss = isBossSrc(source), label = zoneKey,
         materials = w.materials, weapons = w.weapons, jobs = jobs, recipes = G.Recipes, maxQueue = G.Workshop.MaxQueue })
end)

ESX.RegisterServerCallback('Workshop:Deposit', function(source, cb, zoneKey, item, count)
    cb(WorkshopDeposit(gangOfSrc(source), zoneKey, tostring(item), count))
end)

-- materials back from the zone armory into the gang armory
function WorkshopWithdrawMaterial(gang, zoneKey, item, count)
    count = math.floor(tonumber(count) or 0)
    if zoneOwner(zoneKey) ~= gang then return false, 'In zone male gang-e shoma nist' end
    local w = ensureWS(zoneKey)
    if not G.Materials[item] or count <= 0 or (w.materials[item] or 0) < count then return false, 'Mavad kafi nist' end
    local ok, res = pcall(function() return exports['Unique_inventory']:AddGangArmoryItem(gang, item, count) end)
    if not ok or not res then return false, 'Armory-e gang dar dastres nist' end
    w.materials[item] = w.materials[item] - count
    if w.materials[item] <= 0 then w.materials[item] = nil end
    SaveWorkshop(zoneKey)
    return true, ('%dx %s be armory-e gang ezafe shod'):format(count, item)
end
ESX.RegisterServerCallback('Workshop:WithdrawMaterial', function(source, cb, zoneKey, item, count)
    cb(WorkshopWithdrawMaterial(gangOfSrc(source), zoneKey, tostring(item), count))
end)


ESX.RegisterServerCallback('Workshop:Withdraw', function(source, cb, zoneKey, weapon)
    local gang = gangOfSrc(source)
    if not gang then return cb(false, 'Gang nadarid') end
    cb(WorkshopWithdraw(gang, zoneKey, tostring(weapon)))
end)

-- ================= SALES FROM THE SCRIPTPACK GUN SHOP (NPC) =================
-- ScriptPack's gun shop ped sells weapons; the money from a sale goes to the bank of the gang
-- that OWNS the shop nearest to the buyer. Every sale is logged for the owner's GunShop tab.
GunShopSales = GunShopSales or {}      -- [gang] = { {at, buyer, weapon, amount, price}, ... } (last 50)
local SALE_RADIUS = 40.0

local function nearestShop(coords)
    local best, bestD
    for _, s in pairs(Shops) do
        local dx, dy, dz = coords.x - s.coords.x, coords.y - s.coords.y, coords.z - s.coords.z
        local d = math.sqrt(dx * dx + dy * dy + dz * dz)
        if d <= SALE_RADIUS and (not bestD or d < bestD) then best, bestD = s, d end
    end
    return best
end

local function logSale(gang, entry)
    local list = GunShopSales[gang] or {}
    table.insert(list, 1, entry)
    while #list > 50 do table.remove(list) end
    GunShopSales[gang] = list
    MySQL.Async.execute('INSERT INTO gunshop_sales (gang, at, buyer, weapon, amount, price) VALUES (@g, @a, @b, @w, @n, @p)',
        { ['@g'] = gang, ['@a'] = entry.at, ['@b'] = entry.buyer, ['@w'] = entry.weapon, ['@n'] = entry.amount, ['@p'] = entry.price })
end

-- called by ScriptPack (shop-sv.lua) right after the buyer has paid
-- The NPC's menu: the buyer must be near a shop. Returns false + reason when the stock is out.
exports('GunShopCanSell', function(source, weapon, amount)
    local ped = GetPlayerPed(source)
    if not ped or ped == 0 then return true end
    local shop = nearestShop(GetEntityCoords(ped))
    if not shop then return true end
    if ShopCanSell(shop.id, tostring(weapon), tonumber(amount) or 1) then return true end
    return false, 'Aslahe too maghaze tamoom shode'
end)

-- 40% of every NPC purchase goes to the owner gang, 60% disappears (money sink).
local OWNER_SHARE = 0.40
exports('RecordGunShopSale', function(source, weapon, price, amount)
    local ped = GetPlayerPed(source)
    if not ped or ped == 0 then return nil end
    local shop = nearestShop(GetEntityCoords(ped))
    if not shop or not shop.owner then return nil end            -- free shop: nothing to credit
    price = math.floor(tonumber(price) or 0); amount = math.floor(tonumber(amount) or 1)
    if price <= 0 then return nil end
    weapon = tostring(weapon)
    if weapon:match('^WEAPON_') then
        if not ShopCanSell(shop.id, weapon, amount) then return nil end
        shop.stock[weapon] = shop.stock[weapon] - amount
        if shop.stock[weapon] <= 0 then shop.stock[weapon] = nil end
        SaveShop(shop)
    end
    local share = math.floor(price * OWNER_SHARE)
    if share > 0 then AddGangMoney(shop.owner, share) end
    price = share
    local x = ESX.GetPlayerFromId(source)
    logSale(shop.owner, { at = os.time(), buyer = x and x.name or ('ID ' .. source), weapon = weapon, amount = amount, price = price, shop = shop.label })
    note(shop.owner, ('Forush dar "%s": %dx %s - $%d be khazane-ye gang vared shod.'):format(shop.label, amount, weapon, price))
    return shop.owner
end)

ESX.RegisterServerCallback('GunShop:Sales', function(source, cb)
    local gang = gangOfSrc(source)
    if not gang or not isBossSrc(source) then return cb({}) end
    cb(GunShopSales[gang] or {})
end)

MySQL.ready(function()
    MySQL.Async.execute([[
        CREATE TABLE IF NOT EXISTS `gunshop_sales` (
          `id` int(11) NOT NULL AUTO_INCREMENT, `gang` varchar(254) NOT NULL, `at` int(255) NOT NULL DEFAULT 0,
          `buyer` varchar(120) DEFAULT NULL, `weapon` varchar(80) DEFAULT NULL, `amount` int(11) DEFAULT 1,
          `price` int(11) DEFAULT 0, PRIMARY KEY (`id`), KEY `idx_gang` (`gang`)
        ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
    ]], {}, function()
        MySQL.Async.fetchAll('SELECT gang, at, buyer, weapon, amount, price FROM gunshop_sales ORDER BY id DESC LIMIT 2000', {}, function(rows)
            for _, r in ipairs(rows or {}) do
                local list = GunShopSales[r.gang] or {}
                if #list < 50 then table.insert(list, { at = r.at, buyer = r.buyer, weapon = r.weapon, amount = r.amount, price = r.price }) end
                GunShopSales[r.gang] = list
            end
        end)
    end)
end)

ESX.RegisterServerCallback('GunShop:DepositStock', function(source, cb, id, weapon, count)
    local gang = gangOfSrc(source)
    if not isBossSrc(source) then return cb(false, 'Faghat boss') end
    cb(ShopDepositStock(gang, tonumber(id), tostring(weapon), count))
end)

-- the owner boss standing at a shop asks to manage it (the NPC's E menu uses this)
ESX.RegisterServerCallback('GunShop:Manage', function(source, cb)
    local gang = gangOfSrc(source)
    local ped = GetPlayerPed(source)
    local shop = (ped and ped ~= 0) and nearestShop(GetEntityCoords(ped)) or nil
    if not gang or not shop or shop.owner ~= gang or not isBossSrc(source) then return cb({ manage = false }) end
    cb({ manage = true, shopId = shop.id, label = shop.label })
end)

ESX.RegisterServerCallback('Workshop:DepositWeapon', function(source, cb, zoneKey, weapon, count)
    cb(WorkshopDepositWeapon(gangOfSrc(source), zoneKey, tostring(weapon), count))
end)

-- ================= AUCTION HOUSE LINK (uniquecafejobs/auctionhouse) =================
-- The auction house runs at each gun shop. Its listings belong to the shop's owner gang.
-- Plain tables only (vector3 does not survive an export call reliably).
function GunShopsForAH()
    local out = {}
    for _, s in pairs(Shops) do
        out[#out + 1] = {
            key = 'gunshop_' .. s.id, id = s.id, label = s.label,
            coords = { x = s.coords.x, y = s.coords.y, z = s.coords.z },
            owner = s.owner, ownerLabel = s.ownerLabel,
        }
    end
    table.sort(out, function(a, b) return a.id < b.id end)
    return out
end

-- Weapons the auction house may sell at a gun shop: the shop's own catalog.
function GunShopWeaponCatalog()
    local out = {}
    for _, c in ipairs(G.Catalog) do out[#out + 1] = c.weapon end
    return out
end
exports('GunShopsForAH', GunShopsForAH)
exports('GunShopWeaponCatalog', GunShopWeaponCatalog)
