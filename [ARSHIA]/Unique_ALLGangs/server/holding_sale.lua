-- Holding sale. Two holdings (Config.HoldingSale.Holdings).
--   * a free holding is auctioned for AuctionMinutes; the highest bid wins
--   * the buyer keeps it for OwnershipDays; nobody can bid during that time
--   * in the LAST RequestDays of that time, requests (bids) open; at the end the
--     highest request gets the holding and a new OwnershipDays period starts.
--     Nobody requested: the owner renews for OwnershipDays.
-- Bids are held (money taken) when placed; a gang that gets outbid gets its money back.

local Owners  = {}   -- [hkey] = { owner, expires, price }
local Auction = {}   -- [hkey] = { endsAt, top = { gang, amount }, window = bool }

local function hsCfg() return Config.HoldingSale end
local function now() return os.time() end
local DAY = 86400

MySQL.ready(function()
    MySQL.Async.execute([[
        CREATE TABLE IF NOT EXISTS holding_owners (
            hkey VARCHAR(32) PRIMARY KEY,
            owner VARCHAR(64) NULL,
            expires BIGINT NOT NULL DEFAULT 0,
            price BIGINT NOT NULL DEFAULT 0
        )
    ]], {})
    MySQL.Async.fetchAll('SELECT hkey, owner, expires, price FROM holding_owners', {}, function(rows)
        for _, r in ipairs(rows or {}) do
            Owners[r.hkey] = { owner = r.owner, expires = tonumber(r.expires) or 0, price = tonumber(r.price) or 0 }
        end
    end)
end)

local function saveOwner(k)
    local o = Owners[k] or {}
    MySQL.Async.execute('INSERT INTO holding_owners (hkey, owner, expires, price) VALUES (@k, @o, @e, @p) ON DUPLICATE KEY UPDATE owner = @o, expires = @e, price = @p', {
        ['@k'] = k, ['@o'] = o.owner, ['@e'] = o.expires or 0, ['@p'] = o.price or 0,
    })
end

local function label(k) return hsCfg().Holdings[k].label end

-- the gang that owns a holding right now (nil = nobody)
function HoldingOwnerOf(hkey)
    local o = Owners[hkey]
    return o and o.owner or nil
end

-- which holding each business belongs to (business keys from the cafes config)
BusinessHolding = {
    UwU = 'meridian', Obsidian = 'meridian', Ember = 'meridian', Crimson = 'meridian',
    Voltage = 'turfco', Nightjar = 'turfco', Anchor = 'turfco', Static = 'turfco',
}

-- true when this gang owns the holding the business belongs to
function GangOwnsBusiness(gang, bkey)
    local h = BusinessHolding[bkey]
    if not h or not gang then return false end
    return HoldingOwnerOf(h) == gang
end
local function announce(text) TriggerClientEvent('esx:showNotification', -1, text) end

local function startAuction(k)
    Auction[k] = { endsAt = now() + hsCfg().AuctionMinutes * 60, top = nil, window = false }
    announce(('Mazayede-ye %s shoro shod! Gang-ha az Boss Action mitoonan bid bedan.'):format(label(k)))
end

local function openRequestWindow(k)
    local o = Owners[k]
    Auction[k] = { endsAt = o.expires, top = nil, window = true }
    announce(('%s: %d roz-e akhar ~ darkhast-ha baz shod. Har gang bishtar bede, shans-e bishtar.'):format(label(k), hsCfg().RequestDays))
end

local function finishAuction(k)
    local a = Auction[k]
    Auction[k] = nil
    local cfg = hsCfg()
    if a.window then
        local o = Owners[k]
        if a.top then
            Owners[k] = { owner = a.top.gang, expires = now() + cfg.OwnershipDays * DAY, price = a.top.amount }
            announce(('%s be gang-e %s rasid ($%d). Ta %d ruz dar ekhtiyar darad.'):format(label(k), a.top.gang, a.top.amount, cfg.OwnershipDays))
        else
            o.expires = now() + cfg.OwnershipDays * DAY
            announce(('Darkhasti baraye %s nabud. Gang-e %s baraye %d ruz tamdid kard.'):format(label(k), o.owner, cfg.OwnershipDays))
        end
        saveOwner(k)
    else
        if a.top then
            Owners[k] = { owner = a.top.gang, expires = now() + cfg.OwnershipDays * DAY, price = a.top.amount }
            saveOwner(k)
            announce(('%s ba $%d be gang-e %s rasid. Ta %d ruz dar ekhtiyar darad.'):format(label(k), a.top.amount, a.top.gang, cfg.OwnershipDays))
        else
            announce(('Mazayede-ye %s bedun kharidar tamam shod.'):format(label(k)))
        end
    end
end

CreateThread(function()
    while true do
        Wait(hsCfg().CheckSeconds * 1000)
        for k in pairs(hsCfg().Holdings) do
            local o = Owners[k]
            if not (o and o.owner) and not Auction[k] then
                startAuction(k)
            elseif o and o.owner and not Auction[k] and now() >= o.expires - hsCfg().RequestDays * DAY then
                openRequestWindow(k)
            end
            if Auction[k] and now() >= Auction[k].endsAt then
                finishAuction(k)
            end
        end
    end
end)

-- the caller's gang (for the page header)
ESX.RegisterServerCallback('HoldingSale:MyGang', function(source, cb)
    local x = ESX.GetPlayerFromId(source)
    cb(x and x.gang and x.gang.name ~= 'nogang' and x.gang.name or nil)
end)

-- what the menu shows
ESX.RegisterServerCallback('HoldingSale:Info', function(source, cb)
    local out = {}
    for k, h in pairs(hsCfg().Holdings) do
        local o = Owners[k] or {}
        local a = Auction[k]
        local minBid
        if a then
            minBid = (a.top) and math.ceil(a.top.amount * (100 + hsCfg().BidStepPct) / 100) or hsCfg().StartPrice
        end
        out[#out + 1] = {
            key = k, label = h.label, businesses = h.businesses,
            owner = o.owner, price = o.price or 0,
            expires = o.expires or 0,
            open = a ~= nil, window = a and a.window or false, endsAt = a and a.endsAt or 0,
            top = a and a.top or nil, minBid = minBid,
            lockUntil = (o.owner and not a) and (o.expires - hsCfg().RequestDays * DAY) or 0,
        }
    end
    table.sort(out, function(x, y) return x.key < y.key end)
    cb(out)
end)

-- a boss bids / requests: the money is held right away; the outbid gang gets it back
ESX.RegisterServerCallback('HoldingSale:Bid', function(source, cb, k, amount)
    local x = ESX.GetPlayerFromId(source)
    local gang = x and x.gang and x.gang.name
    local okB, isBoss = pcall(function() return IsGangBoss(source) end)
    if not gang or gang == 'nogang' or not (okB and isBoss == true) then return cb(false, 'Faghat boss-e gang mitoone bid bede.') end
    if not hsCfg().Holdings[k] then return cb(false, 'Holding nadarad.') end
    local a = Auction[k]
    if not a then return cb(false, 'Darkhast/mazayede baz nist.') end
    if a.top and a.top.gang == gang then return cb(false, 'Bid-e shoma ghablan bala-tar ast.') end

    amount = math.floor(tonumber(amount) or 0)
    local minBid = a.top and math.ceil(a.top.amount * (100 + hsCfg().BidStepPct) / 100) or hsCfg().StartPrice
    if amount < minBid then return cb(false, ('Bid bayad hadeaghal $%d bashad.'):format(minBid)) end
    if not RemoveGangMoney(gang, amount) then return cb(false, 'Pool-e gang kafi nist.') end

    if a.top then AddGangMoney(a.top.gang, a.top.amount) end
    a.top = { gang = gang, amount = amount }
    announce(('%s ba $%d %s ro bid zad!'):format(gang, amount, label(k)))
    cb(true, ('Bid-e shoma ($%d) sabt shod.'):format(amount))
end)

-- cyanide: instant death
ESX.RegisterUsableItem('cyanide', function(source)
    local x = ESX.GetPlayerFromId(source)
    if not x then return end
    local it = x.getInventoryItem('cyanide')
    if not it or (it.count or 0) < 1 then return end
    x.removeInventoryItem('cyanide', 1)
    TriggerClientEvent('holding_sale:cyanide', source)
end)
