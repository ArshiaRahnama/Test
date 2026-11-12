-- ============================================================================
--  Unique Capture  -  SERVER  (Sun-style, lean)
--  زون‌ها، worldها، join/exit، پرچم، امتیاز، اسکوربورد. تمام رویدادها سمت سرور اعتبارسنجی میشن.
--  دیتابیس فقط دو جدول: capture_history (تاریخچه راندها) و capture_player_stats (کیل/دث/امتیاز کل).
-- ============================================================================
ESX = nil
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

function SendLog(category, embed)
    if not CapConfig.EnableDetailedLogging then return end
    local url = CapConfig.Webhooks and CapConfig.Webhooks[category]
    if not url or url == '' then return end
    embed.footer = embed.footer or { text = CapConfig.LogUsername .. ' | ' .. category }
    embed.timestamp = embed.timestamp or os.date('!%Y-%m-%dT%H:%M:%SZ')
    PerformHttpRequest(url, function() end, 'POST', json.encode({ username = CapConfig.LogUsername, embeds = { embed } }),
        { ['Content-Type'] = 'application/json' })
end

CreateThread(function()
    MySQL.Async.execute([[
        CREATE TABLE IF NOT EXISTS `capture_history` (
          `id` INT NOT NULL AUTO_INCREMENT,
          `round_date` DATETIME NOT NULL,
          `winner_gang` VARCHAR(50) DEFAULT NULL,
          `winner_points` INT DEFAULT 0,
          `top_killer_name` VARCHAR(100) DEFAULT NULL,
          `top_killer_kills` INT DEFAULT 0,
          `top_gangs_json` TEXT,
          `top_killers_json` TEXT,
          PRIMARY KEY (`id`)
        ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
    ]], {}, function() end)
    MySQL.Async.execute([[
        CREATE TABLE IF NOT EXISTS `capture_player_stats` (
          `identifier` VARCHAR(60) NOT NULL,
          `name` VARCHAR(100) DEFAULT NULL,
          `kills` INT NOT NULL DEFAULT 0,
          `deaths` INT NOT NULL DEFAULT 0,
          `gang_points` INT NOT NULL DEFAULT 0,
          `last_active` DATETIME DEFAULT NULL,
          PRIMARY KEY (`identifier`)
        ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
    ]], {}, function() end)
end)

function UpsertPlayerStat(identifier, name, column, amount)
    if column ~= 'kills' and column ~= 'deaths' and column ~= 'gang_points' then return end
    MySQL.Async.execute(
        'INSERT INTO capture_player_stats (identifier, name, ' .. column .. ', last_active) VALUES (@identifier, @name, @amount, @now) ' ..
        'ON DUPLICATE KEY UPDATE ' .. column .. ' = ' .. column .. ' + @amount, name = @name, last_active = @now',
        { ['@identifier'] = identifier, ['@name'] = name, ['@amount'] = amount, ['@now'] = os.date('%Y-%m-%d %H:%M:%S') })
end


-- ============================================================================
--  CORE  (جدید)
-- ============================================================================
local Zones      = {}   -- [id] = {id,label,coords,world,captureBy,players={[src]=true},lastAlert}
local Sessions   = {}   -- [src] = {src,identifier,name,gang,zoneId,kills,deaths,contest,lastDeath,prevBucket}
local Board      = {}   -- [identifier] = {name,kills,deaths}   (اسکوربورد راند)
local GangScore  = {}   -- [gang] = points
local Round      = { active = false, id = 0, startedAt = 0, endsAt = 0, minutes = CapConfig.DefaultTime }
local HomeCache, LeavePenalty, JoinTokens, JoinCooldown = {}, {}, {}, {}

local function NowMs() return GetGameTimer() end

local function Reply(src, color, msg)
    if src == 0 then print('[Unique-Capture] ' .. tostring(msg)) return end
    TriggerClientEvent('chat:addMessage', src, { args = { (color or '^1') .. 'Unique-CaptureSystem', msg } })
end

local function HasPerm(src)
    if src == 0 then return true end
    local xPlayer = ESX.GetPlayerFromId(src)
    return xPlayer ~= nil and (tonumber(xPlayer.permission_level) or 0) > CapConfig.CommandPerm
end

local function AdminGate(src)
    if not HasPerm(src) then Reply(src, '^1', "You Don't Have Permissions !") return false end
    return true
end

local function Notify(src, msg, typ) TriggerClientEvent('capture:notify', src, msg, typ or 'inform') end

local function GangOf(xPlayer)
    local g = xPlayer and xPlayer.gang
    if type(g) == 'table' and g.name and g.name ~= '' then return g.name end
    return 'nogang'
end

local function ExemptFromAC(src, ms)
    local ex = CapConfig.AntiCheatExempt
    if not ex or not ex.Enabled or GetResourceState(ex.Resource) ~= 'started' then return end
    pcall(function() exports[ex.Resource]:ExemptPlayer(src, ms) end)
end

local function GetSession(src, create)
    local s = Sessions[src]
    if s or not create then return s end
    local xPlayer = ESX.GetPlayerFromId(src)
    if not xPlayer then return nil end
    s = { src = src, identifier = xPlayer.identifier, name = GetPlayerName(src) or ('ID ' .. src),
          gang = GangOf(xPlayer), zoneId = nil, kills = 0, deaths = 0, contest = nil, lastDeath = 0 }
    Sessions[src] = s
    return s
end

local function RefreshGang(s)
    local xPlayer = ESX.GetPlayerFromId(s.src)
    if xPlayer then s.gang = GangOf(xPlayer) end
    return s.gang
end

-- ----------------------------------------------------------------------------
--  Zones
-- ----------------------------------------------------------------------------
local function NewZone(id, label, x, y, z, world)
    return { id = id, label = label, coords = vector3(x, y, z), world = world, captureBy = nil, players = {}, lastAlert = 0 }
end

local function ParseZones(decoded)
    if type(decoded) ~= 'table' then return nil end
    local out, count, maxId = {}, 0, 0
    local function add(id, label, x, y, z, world)
        id, x, y, z = tonumber(id), tonumber(x), tonumber(y), tonumber(z)
        if not id or not x or not y or not z or not label or label == '' then return end
        id = math.floor(id)
        world = math.floor(tonumber(world) or (CapConfig.WorldMin + id))
        out[id] = NewZone(id, tostring(label), x, y, z, world)
        count = count + 1
        if id > maxId then maxId = id end
    end
    local legacy = {}
    for k, v in pairs(decoded) do
        if type(v) == 'table' then
            if v.id then add(v.id, v.label, v.x, v.y, v.z, v.world)
            elseif type(k) == 'string' and v.x then legacy[#legacy + 1] = { name = k, v = v } end
        end
    end
    table.sort(legacy, function(a, b) return a.name < b.name end)
    for _, l in ipairs(legacy) do maxId = maxId + 1 add(maxId, l.name, l.v.x, l.v.y, l.v.z, nil) end
    return count > 0 and out or nil
end

local function LoadZones(force)
    if CapConfig.PersistZones or force then
        local content = LoadResourceFile(GetCurrentResourceName(), CapConfig.ZonesFileName)
        if content then
            local ok, decoded = pcall(json.decode, content)
            local zones = ok and ParseZones(decoded)
            if zones then return zones end
        end
    end
    if force then return nil end
    return ParseZones(CapConfig.DefaultZones) or {}
end

local function SaveZones()
    local list = {}
    for id, z in pairs(Zones) do list[#list + 1] = { id = id, label = z.label, x = z.coords.x, y = z.coords.y, z = z.coords.z, world = z.world } end
    table.sort(list, function(a, b) return a.id < b.id end)
    return SaveResourceFile(GetCurrentResourceName(), CapConfig.ZonesFileName, json.encode(list), -1)
end

Zones = LoadZones() or {}

local function CountZones() local n = 0 for _ in pairs(Zones) do n = n + 1 end return n end

local function InCaptureList()
    local list = {}
    for src, s in pairs(Sessions) do if s.zoneId then list[#list + 1] = src end end
    return list
end

local function NearFlag(src, zone, extra)
    local ped = GetPlayerPed(src)
    if not ped or ped == 0 then return false end
    return #(GetEntityCoords(ped) - zone.coords) <= (extra or (CapConfig.FlagRadius + CapConfig.FlagRadiusTolerance))
end

-- ----------------------------------------------------------------------------
--  Gang home (HQ)
-- ----------------------------------------------------------------------------
local function ExtractCoord(v)
    if type(v) ~= 'table' then return nil end
    if v.x and v.y and v.z then return tonumber(v.x), tonumber(v.y), tonumber(v.z) end
    if type(v.coord) == 'table' then return ExtractCoord(v.coord) end
    return nil
end

function ParseBossCoords(raw)
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

local function GetGangHome(gang, cb)
    local c = HomeCache[gang]
    if c and (os.time() - c.at) < 300 then return cb(c.coords) end
    local fb = CapConfig.FallbackHome
    MySQL.Async.fetchAll('SELECT ' .. CapConfig.GangsBossColumn .. ' as boss FROM ' .. CapConfig.GangsTable ..
        ' WHERE ' .. CapConfig.GangsNameColumn .. ' = @g LIMIT 1', { ['@g'] = gang }, function(rows)
        local coords = (rows and rows[1] and ParseBossCoords(rows[1].boss)) or vector3(fb.x, fb.y, fb.z)
        HomeCache[gang] = { coords = coords, at = os.time() }
        cb(coords)
    end)
end

-- ----------------------------------------------------------------------------
--  Leave-zone penalty
-- ----------------------------------------------------------------------------
local function PenaltyRemaining(identifier, zoneId)
    local t = LeavePenalty[identifier] and LeavePenalty[identifier][zoneId]
    if not t then return 0 end
    local r = t - os.time()
    return r > 0 and r or 0
end

-- ----------------------------------------------------------------------------
--  Zone membership
-- ----------------------------------------------------------------------------
local function LeaveZone(src, s)
    if s.zoneId and Zones[s.zoneId] then Zones[s.zoneId].players[src] = nil end
    s.zoneId, s.contest = nil, nil
end

local function SendHome(src, s)
    SetPlayerRoutingBucket(src, s.prevBucket or 0)
    s.prevBucket = nil
    ExemptFromAC(src, 10000)
    GetGangHome(s.gang, function(home)
        if GetPlayerName(src) then TriggerClientEvent('capture:exited', src, { x = home.x, y = home.y, z = home.z }) end
    end)
end

local function ForceExit(src)
    local s = Sessions[src]
    if not s or not s.zoneId then return end
    LeaveZone(src, s)
    SendHome(src, s)
end

local function ZonePlayerCounts(zone, gang)
    local pc, gc = 0, 0
    for psrc in pairs(zone.players) do
        pc = pc + 1
        local ps = Sessions[psrc]
        if ps and ps.gang == gang then gc = gc + 1 end
    end
    return pc, gc
end

-- ----------------------------------------------------------------------------
--  Callbacks
-- ----------------------------------------------------------------------------
ESX.RegisterServerCallback('capture:getCache', function(src, cb)
    local s = GetSession(src, true)
    local gang = s and RefreshGang(s) or 'nogang'
    local list = {}
    for id, z in pairs(Zones) do
        local pc, gc = ZonePlayerCounts(z, gang)
        list[#list + 1] = { id = id, label = z.label, coords = { x = z.coords.x, y = z.coords.y, z = z.coords.z },
            world = z.world, captureBy = z.captureBy, playerCount = pc, gangPlayerCount = gc,
            maxPlayerCount = CapConfig.MaxPlayersInZone, maxGangCount = CapConfig.MaxGangInZone }
    end
    table.sort(list, function(a, b) return a.id < b.id end)
    cb(list, { active = Round.active },
        Round.active and math.max(0, Round.endsAt - os.time()) or nil)
end)

ESX.RegisterServerCallback('capture:getScoreboard', function(src, cb)
    local players, gangs = {}, {}
    for _, b in pairs(Board) do
        players[#players + 1] = { name = b.gang and (b.name .. ' [' .. b.gang .. ']') or b.name, kills = b.kills, deaths = b.deaths }
    end
    table.sort(players, function(a, b) return a.kills > b.kills end)
    for g, p in pairs(GangScore) do
        local flags = {}
        for _, z in pairs(Zones) do if z.captureBy == g then flags[#flags + 1] = z.label end end
        gangs[#gangs + 1] = { name = g, Score = p, capturedFlags = flags }
    end
    table.sort(gangs, function(a, b) return a.Score > b.Score end)
    local outP, outG = {}, {}
    for i = 1, math.min(10, #players) do outP[i] = players[i] end
    for i = 1, math.min(10, #gangs) do outG[i] = gangs[i] end
    cb({ players = outP, gangs = outG })
end)

-- ----------------------------------------------------------------------------
--  Join / Exit
-- ----------------------------------------------------------------------------
RegisterCommand(CapConfig.JoinCaptureCommand, function(src)
    if src == 0 then return end
    local s = GetSession(src, true)
    if not s then return end
    if not Round.active then return Reply(src, '^1', 'Capture Not Active !') end
    if RefreshGang(s) == 'nogang' then return Reply(src, '^1', 'You Must First Join To A Gang !') end
    if s.zoneId then return TriggerClientEvent('Cap:OpenMenu', src) end
    local function allow()
        JoinTokens[src] = os.time() + 120
        TriggerClientEvent('Cap:OpenMenu', src)
    end
    if not CapConfig.NearGangBoss.Required then return allow() end
    local ped = GetPlayerPed(src)
    local pc = ped and ped ~= 0 and GetEntityCoords(ped) or nil
    GetGangHome(s.gang, function(home)
        if pc and #(pc - home) <= CapConfig.NearGangBoss.Distance then allow()
        else Reply(src, '^1', 'Go To Your Gang To Can Join !') end
    end)
end, false)

RegisterCommand(CapConfig.ReSpawnCaptureCommand, function(src)
    if src == 0 then return end
    local s = Sessions[src]
    if s and s.zoneId and Round.active then TriggerClientEvent('Cap:OpenMenu', src) end
end, false)

RegisterCommand(CapConfig.LeaveCaptureCommand, function(src)
    if src == 0 then return end
    local s = Sessions[src]
    if s and s.zoneId then TriggerClientEvent('capture:requestExit', src) end
end, false)

RegisterNetEvent('capture:join')
AddEventHandler('capture:join', function(zoneId)
    local src = source
    local now = NowMs()
    if (JoinCooldown[src] or 0) > now then return end
    JoinCooldown[src] = now + 1500
    local s = GetSession(src, true)
    if not s then return end
    local function deny(msg)
        Notify(src, msg, 'error')
        TriggerClientEvent('capture:joinDenied', src, msg)
    end
    if not Round.active then return deny('Capture Not Active !') end
    if RefreshGang(s) == 'nogang' then return deny('You Must First Join To A Gang !') end
    zoneId = tonumber(zoneId)
    local zone = zoneId and Zones[zoneId]
    if not zone then return deny('Zone Peyda Nashod !') end
    if not s.zoneId and (JoinTokens[src] or 0) < os.time() then return deny('Go To Your Gang To Can Join !') end
    if s.zoneId ~= zoneId then
        local pc, gc = ZonePlayerCounts(zone, s.gang)
        if pc >= CapConfig.MaxPlayersInZone then return deny('Zarfiat in zone por shode ast') end
        if gc >= CapConfig.MaxGangInZone then return deny('Zarfiat gang shoma dar in zone por shode ast') end
    end
    if not s.zoneId then s.prevBucket = GetPlayerRoutingBucket(src) end
    if s.zoneId and s.zoneId ~= zoneId and Zones[s.zoneId] then Zones[s.zoneId].players[src] = nil end
    s.contest = nil
    s.zoneId = zoneId
    zone.players[src] = true
    JoinTokens[src] = nil
    Board[s.identifier] = Board[s.identifier] or { name = s.name, kills = 0, deaths = 0 }
    Board[s.identifier].gang = s.gang
    ExemptFromAC(src, (CapConfig.SpawnProtectionTime + 6) * 1000)
    SetPlayerRoutingBucket(src, zone.world)
    TriggerClientEvent('capture:updateKillDeath', src, { kills = s.kills, deaths = s.deaths })
    TriggerClientEvent('capture:teleport', src, zoneId, zone.world)
end)

RegisterNetEvent('capture:exit')
AddEventHandler('capture:exit', function()
    local src = source
    local s = Sessions[src]
    if not s or not s.zoneId then return TriggerClientEvent('capture:exited', src, nil) end
    if Round.active and s.contest and CapConfig.LeaveZonePenaltySeconds > 0 then
        LeavePenalty[s.identifier] = LeavePenalty[s.identifier] or {}
        LeavePenalty[s.identifier][s.contest.zoneId] = os.time() + CapConfig.LeaveZonePenaltySeconds
    end
    LeaveZone(src, s)
    SendHome(src, s)
end)

AddEventHandler('playerDropped', function()
    local src = source
    local s = Sessions[src]
    if s then LeaveZone(src, s) end
    Sessions[src], JoinTokens[src], JoinCooldown[src] = nil, nil, nil
end)

-- ----------------------------------------------------------------------------
--  Flag: contest + capture   (تایمر سمت سرور هم چک میشه؛ کپچر آنی ممکن نیست)
-- ----------------------------------------------------------------------------
RegisterNetEvent('capture:setFlagContested')
AddEventHandler('capture:setFlagContested', function()
    local src = source
    local s = Sessions[src]
    if not s or not s.zoneId or not Round.active then return end
    local zone = Zones[s.zoneId]
    if not zone or zone.captureBy == RefreshGang(s) or not NearFlag(src, zone) then return end
    local rem = PenaltyRemaining(s.identifier, zone.id)
    if rem > 0 then
        Notify(src, 'Shoma Az In Zone Farar Kardid! ' .. rem .. ' Sanie Digar Nemitavanid Capture Konid.', 'error')
        return TriggerClientEvent('capture:contestDenied', src)
    end
    s.contest = { zoneId = zone.id, startedAt = NowMs() }
    if zone.captureBy and (NowMs() - zone.lastAlert) > 5000 then
        zone.lastAlert = NowMs()
        for psrc in pairs(zone.players) do
            local ps = Sessions[psrc]
            if ps and ps.gang == zone.captureBy then TriggerClientEvent('capture:setFlagContested', psrc, s.gang) end
        end
    end
end)

RegisterNetEvent('capture:cancelContest')
AddEventHandler('capture:cancelContest', function()
    local s = Sessions[source]
    if s then s.contest = nil end
end)

local function CaptureZone(zone, s)
    zone.captureBy = s.gang
    local pts, ppts = CapConfig.Points.Capture, CapConfig.Points.CapturePlayer
    GangScore[s.gang] = (GangScore[s.gang] or 0) + pts
    UpsertPlayerStat(s.identifier, s.name, 'gang_points', ppts)
    for _, src in ipairs(InCaptureList()) do
        TriggerClientEvent('capture:ChangeCaptureHandler', src, zone.id, zone.captureBy)
        Notify(src, 'Gang [' .. s.gang .. '] Zone [' .. zone.label .. '] Ra Capture Kard !', 'inform')
    end
    SendLog('ZoneCapture', { title = '🚩 Zone Captured', color = 0xF39C12, fields = {
        { name = 'Zone', value = tostring(zone.label), inline = true },
        { name = 'New Owner', value = tostring(s.gang), inline = true },
        { name = 'By', value = tostring(s.name), inline = true } } })
end

RegisterNetEvent('capture:CaptureMe')
AddEventHandler('capture:CaptureMe', function()
    local src = source
    local s = Sessions[src]
    if not s or not s.zoneId or not Round.active then return end
    local c, zone = s.contest, Zones[s.zoneId]
    s.contest = nil
    if not c or not zone or c.zoneId ~= zone.id or zone.captureBy == RefreshGang(s) then return end
    if (NowMs() - c.startedAt) < (CapConfig.CaptureSeconds * 1000 - 1500) then return end
    if not NearFlag(src, zone) then return end
    CaptureZone(zone, s)
end)

-- ----------------------------------------------------------------------------
--  Death / kills   (از ایونت سرورِ esx:onPlayerDeath خودِ بیس؛ اعتبارسنجی سرور)
-- ----------------------------------------------------------------------------
RegisterNetEvent('esx:onPlayerDeath')
AddEventHandler('esx:onPlayerDeath', function(data)
    local victim = source
    local s = Sessions[victim]
    if not s or not s.zoneId or not Round.active then return end
    local now = NowMs()
    if now - s.lastDeath < 2500 then return end
    s.lastDeath, s.contest = now, nil
    s.deaths = s.deaths + 1
    Board[s.identifier] = Board[s.identifier] or { name = s.name, kills = 0, deaths = 0 }
    Board[s.identifier].gang = s.gang
    Board[s.identifier].deaths = s.deaths
    UpsertPlayerStat(s.identifier, s.name, 'deaths', 1)
    TriggerClientEvent('capture:updateKillDeath', victim, { kills = s.kills, deaths = s.deaths })

    local kid = type(data) == 'table' and tonumber(data.killer) or nil
    local k = kid and kid ~= victim and Sessions[kid]
    if k and k.zoneId == s.zoneId then
        k.kills = k.kills + 1
        Board[k.identifier] = Board[k.identifier] or { name = k.name, kills = 0, deaths = 0 }
        Board[k.identifier].gang = k.gang
        Board[k.identifier].kills = k.kills
        UpsertPlayerStat(k.identifier, k.name, 'kills', 1)
        TriggerClientEvent('capture:updateKillDeath', kid, { kills = k.kills, deaths = k.deaths })
        local z = Zones[s.zoneId]
        SendLog('Kills', { title = '🔫 Kill', color = 0xE74C3C, fields = {
            { name = 'Killer', value = k.name .. ' (' .. k.gang .. ')' },
            { name = 'Victim', value = s.name .. ' (' .. s.gang .. ')' },
            { name = 'Zone', value = tostring(z and z.label), inline = true } } })
    end
end)

-- ----------------------------------------------------------------------------
--  Round lifecycle
-- ----------------------------------------------------------------------------
local function HoldTick()
    local P = CapConfig.Points
    for _, zone in pairs(Zones) do
        local owner = zone.captureBy
        if owner then
            GangScore[owner] = (GangScore[owner] or 0) + P.HoldTick
            for psrc in pairs(zone.players) do
                local ps = Sessions[psrc]
                if ps and ps.gang == owner and NearFlag(psrc, zone, P.HoldPresence) then
                    UpsertPlayerStat(ps.identifier, ps.name, 'gang_points', 1)
                end
            end
        end
    end
end

local function EnforceGangs()
    for src, s in pairs(Sessions) do
        if s.zoneId then
            local old = s.gang
            local now = RefreshGang(s)
            if now == 'nogang' or now ~= old then
                Notify(src, 'Gang Shoma Taghir Kard ! Az Capture Kharej Shodid.', 'error')
                TriggerClientEvent('capture:requestExit', src)
                ForceExit(src)
            end
        end
    end
end

local function TopLists()
    local gangs, killers = {}, {}
    for g, p in pairs(GangScore) do gangs[#gangs + 1] = { Name = g, Points = p } end
    for id, b in pairs(Board) do if b.kills > 0 then killers[#killers + 1] = { Name = b.name, Point = b.kills, Identifier = id } end end
    table.sort(gangs, function(a, b) return a.Points > b.Points end)
    table.sort(killers, function(a, b) return a.Point > b.Point end)
    local g5, k5 = {}, {}
    for i = 1, math.min(5, #gangs) do g5[i] = gangs[i] end
    for i = 1, math.min(5, #killers) do k5[i] = killers[i] end
    return g5, k5
end

local function Hook(url, embed)
    if type(url) ~= 'string' or url == '' then return end
    PerformHttpRequest(url, function() end, 'POST', json.encode({ username = CapConfig.LogUsername, embeds = { embed } }),
        { ['Content-Type'] = 'application/json' })
end

local function SendResult()
    local topGangs, topKillers = TopLists()
    local wg, tk = topGangs[1], topKillers[1]
    MySQL.Async.execute(
        'INSERT INTO capture_history (round_date, winner_gang, winner_points, top_killer_name, top_killer_kills, top_gangs_json, top_killers_json) ' ..
        'VALUES (@d, @wg, @wp, @tn, @tk, @gj, @kj)', {
            ['@d'] = os.date('%Y-%m-%d %H:%M:%S'), ['@wg'] = wg and wg.Name, ['@wp'] = wg and wg.Points or 0,
            ['@tn'] = tk and tk.Name, ['@tk'] = tk and tk.Point or 0,
            ['@gj'] = json.encode(topGangs), ['@kj'] = json.encode(topKillers) })
    SendLog('RoundEnd', { title = '🔴 Capture Round Ended', color = 0xE74C3C, fields = {
        { name = 'Winning Gang', value = wg and (wg.Name .. ' (' .. wg.Points .. ' pts)') or 'N/A', inline = true },
        { name = 'Top Killer', value = tk and (tk.Name .. ' (' .. tk.Point .. ' kills)') or 'N/A', inline = true } } })
    local ke, ge = { title = '🏆 Top 5 Killers', color = 0xFF0000, fields = {} }, { title = '🥇 Top 5 Gangs', color = 0x00FF00, fields = {} }
    for i, k in ipairs(topKillers) do ke.fields[#ke.fields + 1] = { name = '#' .. i .. ' - ' .. k.Name, value = 'Kills: **' .. k.Point .. '**', inline = true } end
    for i, g in ipairs(topGangs) do ge.fields[#ge.fields + 1] = { name = '#' .. i .. ' - ' .. g.Name, value = 'Points: **' .. g.Points .. '**', inline = true } end
    if #ke.fields == 0 then ke.fields[1] = { name = 'No Data', value = 'No kills.', inline = true } end
    if #ge.fields == 0 then ge.fields[1] = { name = 'No Data', value = 'No gang points.', inline = true } end
    Hook(CapConfig.KillersWebhook, ke)
    Hook(CapConfig.GangsWebhook, ge)
    return wg, tk
end

function EndRound()
    if not Round.active then return false end
    Round.active = false
    local rid = Round.id
    local wg, tk = SendResult()
    TriggerClientEvent('capture:CaptureEnded', -1)
    TriggerClientEvent('chat:addMessage', -1, { args = { '^1Unique-CaptureSystem', 'Capture Tamam Shod ! Barande Gang: ' ..
        (wg and (wg.Name .. ' (' .. wg.Points .. ' pts)') or 'N/A') .. ' | Top Killer: ' .. (tk and (tk.Name .. ' (' .. tk.Point .. ')') or 'N/A') } })
    SetTimeout(8000, function()
        if Round.active or Round.id ~= rid then return end
        for _, src in ipairs(InCaptureList()) do ForceExit(src) end
        for _, z in pairs(Zones) do z.players, z.captureBy = {}, nil end
    end)
    return true
end

function StartRound()
    if Round.active then return false, 'Capture Already Active !' end
    if CountZones() == 0 or Round.minutes <= 0 then return false, 'First Set Zones And Time !' end
    for _, src in ipairs(InCaptureList()) do ForceExit(src) end
    for _, z in pairs(Zones) do z.players, z.captureBy, z.lastAlert = {}, nil, 0 end
    Board, GangScore = {}, {}
    for _, s in pairs(Sessions) do s.kills, s.deaths, s.contest, s.zoneId = 0, 0, nil, nil end
    Round.id = Round.id + 1
    Round.active = true
    Round.startedAt = os.time()
    Round.endsAt = Round.startedAt + Round.minutes * 60
    local rid = Round.id
    TriggerClientEvent('capture:CaptureStarted', -1, Round.minutes * 60)
    CreateThread(function()
        while Round.active and Round.id == rid do
            Wait(1000)
            if Round.active and Round.id == rid and os.time() >= Round.endsAt then EndRound() end
        end
    end)
    CreateThread(function()
        local acc = 0
        while Round.active and Round.id == rid do
            Wait(1000)
            acc = acc + 1
            if acc >= CapConfig.Points.HoldInterval then acc = 0 HoldTick() EnforceGangs() end
        end
    end)
    SendLog('RoundStart', { title = '🟢 Capture Round Started', color = 0x2ECC71, fields = {
        { name = 'Zones', value = tostring(CountZones()), inline = true },
        { name = 'Duration', value = Round.minutes .. ' min', inline = true } } })
    return true
end

RegisterCommand(CapConfig.StartCaptureCommand, function(src)
    if not HasPerm(src) then return Reply(src, '^1', "You Don't Have Permissions !") end
    local ok, err = StartRound()
    if not ok then return Reply(src, '^1', err) end
    TriggerClientEvent('chat:addMessage', -1, { args = { '^1Unique-CaptureSystem', 'Capture Start Shod ! Baraye Join Shodan /' .. CapConfig.JoinCaptureCommand .. ' Bezanid' } })
    SendLog('Admin', { title = '▶️ Round Started By Admin', color = 0x2ECC71, fields = { { name = 'Admin', value = src == 0 and 'console' or GetPlayerName(src), inline = true } } })
end, false)

RegisterCommand(CapConfig.EndCaptureCommand, function(src)
    if not HasPerm(src) then return Reply(src, '^1', "You Don't Have Permissions !") end
    if not EndRound() then return Reply(src, '^1', 'Capture Active Nist !') end
    SendLog('Admin', { title = '⏹️ Round Force-Ended By Admin', color = 0xE67E22, fields = { { name = 'Admin', value = src == 0 and 'console' or GetPlayerName(src), inline = true } } })
end, false)

-- ----------------------------------------------------------------------------
--  Admin: zones & time   (/editCap)
-- ----------------------------------------------------------------------------
RegisterCommand(CapConfig.EditCaptureCommand, function(src)
    if src == 0 then return end
    if not AdminGate(src) then return end
    TriggerClientEvent('capture:OpenAdminMenu', src)
end, false)

ESX.RegisterServerCallback('capture:adminInfo', function(src, cb)
    if not HasPerm(src) then return cb(nil) end
    local list = {}
    for id, z in pairs(Zones) do list[#list + 1] = { id = id, label = z.label, world = z.world } end
    table.sort(list, function(a, b) return a.id < b.id end)
    cb({ minutes = Round.minutes, zones = list, active = Round.active })
end)

RegisterNetEvent('capture:admin:setTime')
AddEventHandler('capture:admin:setTime', function(minutes)
    local src = source
    if not HasPerm(src) then return end
    minutes = tonumber(minutes)
    if not minutes or minutes < 1 or minutes > 600 then return Notify(src, 'Zaman Na Mo\'tabar (1-600)', 'error') end
    Round.minutes = math.floor(minutes)
    Notify(src, 'Zaman Capture: ' .. Round.minutes .. ' Daghighe', 'success')
end)

RegisterNetEvent('capture:setCap')
AddEventHandler('capture:setCap', function(input)
    local src = source
    if not HasPerm(src) then return end
    if Round.active then return Notify(src, 'Dar Hin Capture Nemitavan Zone Ra Taghir Dad !', 'error') end
    if type(input) ~= 'table' then return end
    local id, label, world = tonumber(input[1]), tostring(input[2] or ''), tonumber(input[3])
    if not id or id < 1 or id > 99 or id ~= math.floor(id) then return Notify(src, 'Shomare Zone Na Mo\'tabar (1-99)', 'error') end
    label = label:gsub('^%s+', ''):gsub('%s+$', '')
    if label == '' or #label > 24 then return Notify(src, 'Label Na Mo\'tabar', 'error') end
    if not world or world < CapConfig.WorldMin or world > CapConfig.WorldMax then
        return Notify(src, 'World Bayad Beyne ' .. CapConfig.WorldMin .. ' Ta ' .. CapConfig.WorldMax .. ' Bashad', 'error')
    end
    for zid, z in pairs(Zones) do
        if zid ~= id and string.lower(z.label) == string.lower(label) then return Notify(src, 'Label Tekrari Ast !', 'error') end
    end
    local ped = GetPlayerPed(src)
    if not ped or ped == 0 then return end
    local c = GetEntityCoords(ped)
    Zones[id] = NewZone(id, label, c.x, c.y, c.z, math.floor(world))
    SaveZones()
    Notify(src, 'Zone #' .. id .. ' (' .. label .. ') Zakhire Shod', 'success')
    SendLog('Admin', { title = '📍 Zone Set', color = 0x3498DB, fields = {
        { name = 'Admin', value = GetPlayerName(src), inline = true }, { name = 'Zone', value = id .. ' / ' .. label, inline = true } } })
end)

RegisterNetEvent('capture:admin:removeZone')
AddEventHandler('capture:admin:removeZone', function(id)
    local src = source
    if not HasPerm(src) then return end
    if Round.active then return Notify(src, 'Dar Hin Capture Nemitavan Zone Ra Hazf Kard !', 'error') end
    id = tonumber(id)
    if id and Zones[id] then
        Zones[id] = nil
        SaveZones()
        Notify(src, 'Zone Hazf Shod', 'success')
    end
end)

-- ----------------------------------------------------------------------------
--  Stats / history callbacks (منوی آمار و تاریخچه)
-- ----------------------------------------------------------------------------
RegisterCommand(CapConfig.StatsCommand, function(src)
    if src ~= 0 then TriggerClientEvent('capture:OpenStatsMenu', src) end
end, false)

RegisterCommand(CapConfig.HistoryCommand, function(src)
    if src == 0 or not AdminGate(src) then return end
    TriggerClientEvent('capture:OpenHistoryMenu', src)
end, false)

ESX.RegisterServerCallback('capture:GetHistory', function(src, cb)
    if not HasPerm(src) then return cb({}) end
    MySQL.Async.fetchAll('SELECT * FROM capture_history ORDER BY id DESC LIMIT 15', {}, function(r) cb(r or {}) end)
end)

ESX.RegisterServerCallback('capture:GetMyStats', function(src, cb)
    local xPlayer = ESX.GetPlayerFromId(src)
    if not xPlayer then return cb(nil, {}) end
    MySQL.Async.fetchAll('SELECT * FROM capture_player_stats WHERE identifier = @i LIMIT 1', { ['@i'] = xPlayer.identifier }, function(mine)
        MySQL.Async.fetchAll('SELECT name, kills FROM capture_player_stats ORDER BY kills DESC LIMIT 10', {}, function(top)
            cb(mine and mine[1] or nil, top or {})
        end)
    end)
end)

-- exports (برای اسکریپت‌های دیگه)
exports('IsCaptureActive', function() return Round.active end)
exports('IsPlayerInCapture', function(src) local s = Sessions[src] return s ~= nil and s.zoneId ~= nil end)
