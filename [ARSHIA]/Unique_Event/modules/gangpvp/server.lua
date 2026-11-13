-- ============================================================================
--  Unique Gang PvP  -  SERVER  (Sun gangprop PVP + Unique_inventory)
--  ورود/خروج، کیل، SC (آیتم واقعی اینونتوری)، فروشگاه چرخشی (اسلحه‌ی PV)،
--  کارواش (PV -> واقعی با بلک‌مانی)، ماشین PvP، قفل ورود و CPR هم‌گنگی.
--  همه‌چیز سمت سرور اعتبارسنجی میشه.
-- ============================================================================
local ESX = nil
TriggerEvent(GPConfig.ESX, function(o) ESX = o end)

local InPvp = {}                 -- [src] = player table
local Stats = {}                 -- [identifier] = {kills,deaths,name}
local CmdCooldown = {}
local Bases, BasesAt = {}, 0
local Shops = { list = {}, since = 0 }
local PV = GPConfig.WeaponSerialPrefix

local function NowMs() return GetGameTimer() end
local function V(c) return { x = c.x, y = c.y, z = c.z } end
local function Notify(src, msg, typ) TriggerClientEvent('gpvp:notify', src, msg, typ or 'inform') end

local function ExemptAC(src, ms)
    local ex = GPConfig.AntiCheatExempt
    if not ex or not ex.Enabled or GetResourceState(ex.Resource) ~= 'started' then return end
    pcall(function() exports[ex.Resource]:ExemptPlayer(src, ms) end)
end

-- ----------------------------------------------------------------------------
--  DB + آیتم SC
-- ----------------------------------------------------------------------------
CreateThread(function()
    MySQL.Async.execute([[
        CREATE TABLE IF NOT EXISTS `gang_pvp_stats` (
            `identifier` VARCHAR(60) NOT NULL,
            `name` VARCHAR(100) NOT NULL DEFAULT '',
            `kills` INT NOT NULL DEFAULT 0,
            `deaths` INT NOT NULL DEFAULT 0,
            PRIMARY KEY (`identifier`)
        )
    ]], {})
    MySQL.Async.execute([[
        CREATE TABLE IF NOT EXISTS `gang_pvp_lock` (
            `identifier` VARCHAR(60) NOT NULL,
            `until_ts` INT NOT NULL DEFAULT 0,
            PRIMARY KEY (`identifier`)
        )
    ]], {})
    -- آیتم SC توی جدول items (و همون لحظه توی ESX.Items تا نیاز به ریستارت نباشه)
    local sc = GPConfig.SC
    MySQL.Async.execute('INSERT IGNORE INTO items (name, label, `limit`, rare, can_remove, weight) VALUES (@n, @l, -1, 0, 1, @w)',
        { ['@n'] = sc.item, ['@l'] = sc.label, ['@w'] = sc.weight })
    if ESX and ESX.Items and not ESX.Items[sc.item] then
        ESX.Items[sc.item] = { label = sc.label, limit = -1, rare = false, canRemove = true, weight = sc.weight }
    end
end)

local function LoadStats(identifier, name, cb)
    if Stats[identifier] then Stats[identifier].name = name return cb(Stats[identifier]) end
    MySQL.Async.fetchAll('SELECT kills, deaths FROM gang_pvp_stats WHERE identifier = @i', { ['@i'] = identifier }, function(r)
        local row = r and r[1]
        Stats[identifier] = { kills = row and row.kills or 0, deaths = row and row.deaths or 0, name = name }
        cb(Stats[identifier])
    end)
end

local function SaveStats(identifier)
    local s = Stats[identifier]
    if not s then return end
    MySQL.Async.execute([[
        INSERT INTO gang_pvp_stats (identifier, name, kills, deaths) VALUES (@i, @n, @k, @d)
        ON DUPLICATE KEY UPDATE name = @n, kills = @k, deaths = @d
    ]], { ['@i'] = identifier, ['@n'] = s.name or '', ['@k'] = s.kills, ['@d'] = s.deaths })
end

-- ----------------------------------------------------------------------------
--  Inventory helpers
-- ----------------------------------------------------------------------------
local function GetSC(xPlayer)
    local it = xPlayer and xPlayer.getInventoryItem(GPConfig.SC.item)
    return it and tonumber(it.count) or 0
end

local function AddSC(xPlayer, n)
    local ok = pcall(function() xPlayer.addInventoryItem(GPConfig.SC.item, n) end)
    return ok
end

local function RemoveSC(xPlayer, n)
    if GetSC(xPlayer) < n then return false end
    return (pcall(function() xPlayer.removeInventoryItem(GPConfig.SC.item, n) end))
end

local function IsPV(w) return type(w) == 'table' and tostring(w.serial or ''):sub(1, #PV) == PV end

-- همه‌ی اسلحه‌های PV رو از لودوات پاک میکنه (کپی لیست چون removeWeapon لیست رو تغییر میده)
local function StripPV(xPlayer)
    if not xPlayer then return 0 end
    local list = {}
    for _, w in ipairs(xPlayer.loadout or {}) do
        if IsPV(w) then list[#list + 1] = { name = w.name, ammo = w.ammo, serial = w.serial } end
    end
    for _, w in ipairs(list) do xPlayer.removeWeapon(w.name, w.ammo, w.serial) end
    return #list
end

local function PushStats(src)
    local p = InPvp[src]
    if not p then return end
    local st = Stats[p.identifier]
    TriggerClientEvent('gpvp:stats', src, { kills = st and st.kills or 0, deaths = st and st.deaths or 0, sc = GetSC(ESX.GetPlayerFromId(src)) })
end

-- ----------------------------------------------------------------------------
--  Gang bases (HQ = اولین مارکر boss با code=1 یا اولین ورودی)
-- ----------------------------------------------------------------------------
local function ExtractCoord(v)
    if type(v) ~= 'table' then return nil end
    if v.x and v.y and v.z then return tonumber(v.x), tonumber(v.y), tonumber(v.z) end
    if type(v.coord) == 'table' then return ExtractCoord(v.coord) end
    if type(v.pos) == 'table' then return ExtractCoord(v.pos) end
    return nil
end

function ParseHQ(raw)
    if type(raw) ~= 'string' or raw == '' then return nil end
    local ok, decoded = pcall(json.decode, raw)
    if not ok or type(decoded) ~= 'table' then return nil end
    local x, y, z = ExtractCoord(decoded)
    if x then return vector3(x, y, z) end
    local best
    for _, entry in ipairs(decoded) do
        local ex, ey, ez = ExtractCoord(entry)
        if ex and (not best or tonumber(entry.code) == 1) then
            best = vector3(ex, ey, ez)
            if tonumber(entry.code) == 1 then break end
        end
    end
    return best
end

local function LoadBases(cb)
    if os.time() - BasesAt < 300 and next(Bases) then return cb(Bases) end
    MySQL.Async.fetchAll('SELECT gang_name, boss FROM gangs_data', {}, function(rows)
        local b = {}
        for _, r in ipairs(rows or {}) do
            local c = ParseHQ(r.boss)
            if c then b[r.gang_name] = c end
        end
        Bases, BasesAt = b, os.time()
        cb(Bases)
    end)
end

local function SafeList(bases)
    local out = {}
    for _, c in pairs(bases) do out[#out + 1] = V(c) end
    return out
end

-- ----------------------------------------------------------------------------
--  Counters / helpers
-- ----------------------------------------------------------------------------
local function Count() local n = 0 for _ in pairs(InPvp) do n = n + 1 end return n end
local function BroadcastCount()
    local n = Count()
    for src in pairs(InPvp) do TriggerClientEvent('gpvp:count', src, n) end
end

local function GangOf(xPlayer)
    local g = xPlayer and xPlayer.gang
    if type(g) == 'table' and g.name and g.name ~= '' then return g.name, tonumber(g.grade) or 0 end
    return 'nogang', 0
end

local function NearPoint(src, c, maxDist)
    local ped = GetPlayerPed(src)
    if not ped or ped == 0 then return false end
    return #(GetEntityCoords(ped) - c) <= maxDist
end

local function MateBroadcast(p, src, down)
    for osrc, op in pairs(InPvp) do
        if osrc ~= src and op.gang == p.gang then TriggerClientEvent('gpvp:mateDown', osrc, src, down) end
    end
end

-- ----------------------------------------------------------------------------
--  Shops (چرخشی)
-- ----------------------------------------------------------------------------
local function RotateShops()
    local S = GPConfig.Shop
    local idxs = {}
    for i = 1, #S.shops do idxs[i] = i end
    for i = #idxs, 2, -1 do local j = math.random(i) idxs[i], idxs[j] = idxs[j], idxs[i] end
    local list = {}
    for k = 1, math.min(S.openCount, #idxs) do
        local idx = idxs[k]
        local set = S.sets[math.random(#S.sets)]
        local stock = {}
        for wi, w in ipairs(set) do stock[wi] = w.count end
        list[idx] = { idx = idx, set = set, stock = stock }
    end
    Shops.list, Shops.since = list, os.time()
    for src in pairs(InPvp) do TriggerClientEvent('gpvp:shopsChanged', src) end
end
RotateShops()

CreateThread(function()
    while true do
        Wait(30000)
        if os.time() - Shops.since >= GPConfig.Shop.openMinutes * 60 then RotateShops() end
    end
end)

ESX.RegisterServerCallback('gpvp:getShops', function(src, cb)
    if not InPvp[src] then return cb({}, 0) end
    local out = {}
    for idx, sh in pairs(Shops.list) do
        local weapons = {}
        for wi, w in ipairs(sh.set) do weapons[#weapons + 1] = { id = wi, name = w.name, price = w.price, count = sh.stock[wi] } end
        out[#out + 1] = { idx = idx, coords = V(GPConfig.Shop.shops[idx]), weapons = weapons }
    end
    cb(out, math.max(0, Shops.since + GPConfig.Shop.openMinutes * 60 - os.time()))
end)

RegisterNetEvent('gpvp:buyWeapon')
AddEventHandler('gpvp:buyWeapon', function(shopIdx, weaponId)
    local src = source
    local p = InPvp[src]
    if not p then return end
    local sh = Shops.list[tonumber(shopIdx) or -1]
    local wi = tonumber(weaponId)
    local w = sh and wi and sh.set[wi]
    if not w then return Notify(src, 'Shop Baz Nist !', 'error') end
    local S = GPConfig.Shop
    if not NearPoint(src, S.shops[sh.idx], S.buyDistance + S.serverTolerance) then return end
    if (p.buyCd or 0) > NowMs() then return end
    p.buyCd = NowMs() + 800
    if sh.stock[wi] <= 0 then return Notify(src, 'Mojoodi Tamam Shode !', 'error') end
    local xPlayer = ESX.GetPlayerFromId(src)
    if not xPlayer then return end
    if not RemoveSC(xPlayer, w.price) then return Notify(src, 'Shoma SC Kafi Nadarid !', 'error') end
    sh.stock[wi] = sh.stock[wi] - 1
    xPlayer.addWeapon(w.name, GPConfig.WeaponAmmo, ESX.GenerateWeaponSerial(PV))
    Notify(src, 'Aslahe PvP Kharidari Shod (Bayad Dar Karvash Shaste Shavad)', 'success')
    PushStats(src)
end)

RegisterNetEvent('gpvp:buyCar')
AddEventHandler('gpvp:buyCar', function(model)
    local src = source
    local p = InPvp[src]
    if not p then return end
    local car
    for _, c in ipairs(GPConfig.Cars) do if c.model == model then car = c break end end
    if not car then return end
    if (p.buyCd or 0) > NowMs() then return end
    p.buyCd = NowMs() + 1500
    local xPlayer = ESX.GetPlayerFromId(src)
    if not xPlayer or not RemoveSC(xPlayer, car.price) then return Notify(src, 'Shoma SC Kafi Nadarid !', 'error') end
    TriggerClientEvent('gpvp:spawnCar', src, car.model)
    PushStats(src)
end)

-- ----------------------------------------------------------------------------
--  Wash: اسلحه‌ی PV -> اسلحه‌ی واقعی با بلک‌مانی
-- ----------------------------------------------------------------------------
local WashPrice = {}
for _, w in ipairs(GPConfig.Wash.weapons) do WashPrice[string.upper(w.name)] = w.price end

local function NearWash(src)
    local W = GPConfig.Wash
    for _, c in ipairs(W.points) do
        if NearPoint(src, c, W.distance + W.serverTolerance) then return true end
    end
    return false
end

local function FindPV(xPlayer, serial)
    for _, w in ipairs(xPlayer.loadout or {}) do
        if IsPV(w) and w.serial == serial then return w end
    end
end

ESX.RegisterServerCallback('gpvp:getWashList', function(src, cb)
    local xPlayer = ESX.GetPlayerFromId(src)
    if not InPvp[src] or not xPlayer or not NearWash(src) then return cb({}) end
    local out = {}
    for _, w in ipairs(xPlayer.loadout or {}) do
        if IsPV(w) and WashPrice[w.name] then
            out[#out + 1] = { name = w.name, label = w.label or w.name, serial = w.serial, price = WashPrice[w.name] }
        end
    end
    cb(out)
end)

ESX.RegisterServerCallback('gpvp:washStart', function(src, cb, serial)
    local p, xPlayer = InPvp[src], ESX.GetPlayerFromId(src)
    if not p or not xPlayer or not NearWash(src) then return cb(false) end
    local w = FindPV(xPlayer, serial)
    if not w or not WashPrice[w.name] then return cb(false) end
    if xPlayer.getAccount(GPConfig.Wash.account).money < WashPrice[w.name] then
        Notify(src, 'Pool Kafi Nadarid !', 'error')
        return cb(false)
    end
    p.wash = { serial = serial, t = NowMs() }
    cb(true)
end)

RegisterNetEvent('gpvp:washCancel')
AddEventHandler('gpvp:washCancel', function()
    local p = InPvp[source]
    if p then p.wash = nil end
end)

RegisterNetEvent('gpvp:wash')
AddEventHandler('gpvp:wash', function(serial)
    local src = source
    local p, xPlayer = InPvp[src], ESX.GetPlayerFromId(src)
    if not p or not xPlayer or not p.wash or p.wash.serial ~= serial then return end
    local started = p.wash.t
    p.wash = nil
    if NowMs() - started < (GPConfig.Wash.seconds - 1.5) * 1000 then return end
    if not NearWash(src) then return Notify(src, 'Shoma Az Karvash Dur Shodid !', 'error') end
    local w = FindPV(xPlayer, serial)
    local price = w and WashPrice[w.name]
    if not price then return end
    local acc = GPConfig.Wash.account
    if xPlayer.getAccount(acc).money < price then return Notify(src, 'Pool Kafi Nadarid !', 'error') end
    local name, ammo = w.name, w.ammo
    xPlayer.removeAccountMoney(acc, price)
    xPlayer.removeWeapon(name, ammo, serial)
    xPlayer.addWeapon(name, ammo, ESX.GenerateWeaponSerial())
    Notify(src, 'Aslahe Shaste Shod Va Be Aslahe Vaghei Tabdil Shod', 'success')
end)

-- ----------------------------------------------------------------------------
--  Join lock (PVP Cooldown): بعد از ورود نزدیک HQ بمون؛ ماندگار توی DB
-- ----------------------------------------------------------------------------
local function GetLock(identifier, cb)
    MySQL.Async.fetchAll('SELECT until_ts FROM gang_pvp_lock WHERE identifier = @i', { ['@i'] = identifier }, function(r)
        local stored = r and r[1] and tonumber(r[1].until_ts) or 0
        local now = os.time()
        local untilTs = stored > now and stored or (now + GPConfig.JoinLockSeconds)
        if GPConfig.JoinLockSeconds <= 0 then untilTs = 0 end
        MySQL.Async.execute('INSERT INTO gang_pvp_lock (identifier, until_ts) VALUES (@i, @t) ON DUPLICATE KEY UPDATE until_ts = @t',
            { ['@i'] = identifier, ['@t'] = untilTs })
        cb(untilTs)
    end)
end

CreateThread(function()
    while true do
        Wait(2000)
        local now = os.time()
        for src, p in pairs(InPvp) do
            if p.lockUntil and p.lockUntil > now and not p.dead and not NearPoint(src, p.home, GPConfig.HQDistance + 10.0) then
                TriggerClientEvent('gpvp:pullBack', src, V(p.home))
            end
        end
    end
end)

-- ----------------------------------------------------------------------------
--  Join / Leave
-- ----------------------------------------------------------------------------
local function Join(src)
    local xPlayer = ESX.GetPlayerFromId(src)
    if not xPlayer then return end
    local gang, grade = GangOf(xPlayer)
    if gang == 'nogang' then return Notify(src, 'Shoma Ozv Gangi Nistid !', 'error') end
    if grade < GPConfig.MinGrade then return Notify(src, 'Rank Gang Shoma Baraye PvP Kafi Nist !', 'error') end
    if GetPlayerRoutingBucket(src) ~= 0 then return Notify(src, 'Shoma Dar Yek World Digar Hastid !', 'error') end
    local ped = GetPlayerPed(src)
    if not ped or ped == 0 or GetEntityHealth(ped) <= 0 then return Notify(src, 'Shoma Nemitavanid Join Shavid !', 'error') end
    local pos = GetEntityCoords(ped)
    LoadBases(function(bases)
        local home = bases[gang]
        if not home then return Notify(src, 'HQ Gang Peyda Nashod !', 'error') end
        if #(pos - home) > GPConfig.HQDistance then return Notify(src, 'Shoma Bayad Nazdik Khane Gang Khod Bashid !', 'error') end
        if InPvp[src] or GetPlayerRoutingBucket(src) ~= 0 then return end
        LoadStats(xPlayer.identifier, GetPlayerName(src) or '?', function(st)
            GetLock(xPlayer.identifier, function(lockUntil)
                if InPvp[src] or not GetPlayerName(src) or not ESX.GetPlayerFromId(src) then return end
                InPvp[src] = { identifier = xPlayer.identifier, name = GetPlayerName(src), gang = gang, home = home,
                    lastCombat = 0, lastDeath = 0, lastKillOn = {}, lockUntil = lockUntil, dead = false }
                CmdCooldown[src] = NowMs() + GPConfig.CommandCooldown * 1000
                ExemptAC(src, 15000)
                SetPlayerRoutingBucket(src, GPConfig.World)
                TriggerClientEvent('gpvp:joined', src, { home = V(home), safe = SafeList(bases), kills = st.kills, deaths = st.deaths,
                    sc = GetSC(xPlayer), lock = math.max(0, lockUntil - os.time()) })
                BroadcastCount()
            end)
        end)
    end)
end

local function Leave(src, silent)
    local p = InPvp[src]
    if not p then return end
    InPvp[src] = nil
    if p.dead then MateBroadcast(p, src, false) end
    local xPlayer = ESX.GetPlayerFromId(src)
    local stripped = StripPV(xPlayer)
    if not silent then
        SetPlayerRoutingBucket(src, 0)
        ExemptAC(src, 15000)
        TriggerClientEvent('gpvp:left', src, V(p.home))
        if stripped > 0 then Notify(src, stripped .. ' Aslahe PvP Shaste Nashode Hazf Shod', 'error') end
    end
    BroadcastCount()
end

RegisterCommand(GPConfig.Command, function(src)
    if src == 0 then return end
    local now = NowMs()
    if (CmdCooldown[src] or 0) > now then return Notify(src, 'Spam Nakonid !', 'error') end
    local p = InPvp[src]
    if p then
        if now - math.max(p.lastCombat, p.lastDeath) < GPConfig.LeaveLock * 1000 then
            return Notify(src, 'Dar Hin Darghiri Nemitavanid Kharej Shavid !', 'error')
        end
        CmdCooldown[src] = now + GPConfig.CommandCooldown * 1000
        Leave(src)
        Notify(src, 'Shoma Be World Asli Bargashtid !', 'success')
    else
        CmdCooldown[src] = now + 3000
        Join(src)
    end
end, false)

-- ----------------------------------------------------------------------------
--  Death / kills / respawn / CPR
-- ----------------------------------------------------------------------------
local function DoRespawn(src, p)
    p.dead = false
    p.cpr = nil
    MateBroadcast(p, src, false)
    ExemptAC(src, 10000)
    TriggerClientEvent('gpvp:respawn', src, V(p.home))
end

RegisterNetEvent('esx:onPlayerDeath')
AddEventHandler('esx:onPlayerDeath', function(data)
    local victim = source
    local p = InPvp[victim]
    if not p then return end
    local now = NowMs()
    if now - p.lastDeath < 2500 then return end
    p.lastDeath = now
    p.wash = nil
    p.dead = true
    p.deathId = (p.deathId or 0) + 1
    local did = p.deathId
    local vs = Stats[p.identifier]
    if vs then vs.deaths = vs.deaths + 1 SaveStats(p.identifier) end

    local kid = type(data) == 'table' and tonumber(data.killer) or nil
    local k = kid and kid ~= victim and InPvp[kid] or nil
    if k then
        k.lastCombat = now
        local ks = Stats[k.identifier]
        if ks and k.gang ~= p.gang then
            ks.kills = ks.kills + 1
            local last = k.lastKillOn[p.identifier]
            if not (last and (now - last) < GPConfig.SameVictimCooldown * 1000) then
                local kx = ESX.GetPlayerFromId(kid)
                if kx and AddSC(kx, GPConfig.RewardSC) then k.lastKillOn[p.identifier] = now end
            end
            SaveStats(k.identifier)
            PushStats(kid)
        end
    end
    PushStats(victim)
    MateBroadcast(p, victim, true)
    TriggerClientEvent('gpvp:died', victim)
    SetTimeout(GPConfig.AutoRespawnSeconds * 1000, function()
        local pp = InPvp[victim]
        if pp and pp.dead and pp.deathId == did then DoRespawn(victim, pp) end
    end)
end)

RegisterNetEvent('gpvp:requestRespawn')
AddEventHandler('gpvp:requestRespawn', function()
    local src = source
    local p = InPvp[src]
    if not p or not p.dead then return end
    if NowMs() - p.lastDeath < (GPConfig.RespawnSeconds - 1) * 1000 then return end
    DoRespawn(src, p)
end)

RegisterNetEvent('gpvp:cprStart')
AddEventHandler('gpvp:cprStart', function(target)
    local src = source
    local p, t = InPvp[src], InPvp[tonumber(target) or -1]
    if not p or not t or p.dead or not t.dead or t.gang ~= p.gang or src == target then return end
    if not NearPoint(src, GetEntityCoords(GetPlayerPed(target)), GPConfig.CprDistance + 3.0) then return end
    p.cpr = { target = target, t = NowMs(), deathId = t.deathId }
end)

RegisterNetEvent('gpvp:cprCancel')
AddEventHandler('gpvp:cprCancel', function()
    local p = InPvp[source]
    if p then p.cpr = nil end
end)

RegisterNetEvent('gpvp:cpr')
AddEventHandler('gpvp:cpr', function(target)
    local src = source
    local p = InPvp[src]
    target = tonumber(target)
    local t = target and InPvp[target]
    if not p or not t or not p.cpr or p.cpr.target ~= target then return end
    local c = p.cpr
    p.cpr = nil
    if p.dead or not t.dead or t.deathId ~= c.deathId or t.gang ~= p.gang then return end
    if NowMs() - c.t < (GPConfig.CprSeconds - 1.5) * 1000 then return end
    if not NearPoint(src, GetEntityCoords(GetPlayerPed(target)), GPConfig.CprDistance + 3.0) then return end
    t.dead = false
    MateBroadcast(t, target, false)
    TriggerClientEvent('gpvp:revived', target)
    Notify(src, 'Hamgangi Zende Shod', 'success')
end)

-- ----------------------------------------------------------------------------
--  Safety: اسلحه‌ی PV نباید بیرون PvP بمونه
-- ----------------------------------------------------------------------------
AddEventHandler('esx:playerLoaded', function(playerId)
    SetTimeout(4000, function()
        if not InPvp[playerId] then StripPV(ESX.GetPlayerFromId(playerId)) end
    end)
end)

CreateThread(function()
    Wait(8000)
    for _, id in ipairs(GetPlayers()) do
        id = tonumber(id)
        if not InPvp[id] then StripPV(ESX.GetPlayerFromId(id)) end
    end
end)

AddEventHandler('playerDropped', function()
    local src = source
    Leave(src, true)
    CmdCooldown[src] = nil
end)

AddEventHandler('onResourceStop', function(res)
    if res ~= GetCurrentResourceName() then return end
    for src in pairs(InPvp) do
        SetPlayerRoutingBucket(src, 0)
        StripPV(ESX.GetPlayerFromId(src))
    end
end)

exports('IsPlayerInGangPvp', function(src) return InPvp[src] ~= nil end)
