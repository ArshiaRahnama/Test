-- ============================================================================
--  Unique GunGame  -  SERVER  (Sun-style, lean)
--  هر کیل = سلاح بعدی. کیل/لول/برنده فقط سمت سرور تعیین میشه.
-- ============================================================================
local ESX = nil
TriggerEvent('esx:getSharedObject', function(o) ESX = o end)

local State = 'idle'              -- idle | lobby | running
local Players = {}                -- [src] = {src,identifier,name,level,kills,state='lobby'|'alive'|'dead',prevBucket,lastDeath,deathId}
local Match = nil                 -- {id, endsAt, warmupUntil}
local StartToken = 0
local Prog = GGConfig.Progression
local KNIFE = GetHashKey(GGConfig.KnifeWeapon)

local function NowMs() return GetGameTimer() end
local function V(c) return { x = c.x, y = c.y, z = c.z } end
local function Msg(src, text)
    TriggerClientEvent('chat:addMessage', src or -1, { args = { '^2GunGame', text } })
end
local function Notify(src, text, typ) TriggerClientEvent('gg:notify', src, text, typ or 'inform') end

local function HasPerm(src)
    if src == 0 then return true end
    local x = ESX.GetPlayerFromId(src)
    return x ~= nil and (tonumber(x.permission_level) or 0) >= GGConfig.PermissionLevel
end

local function ExemptAC(src, ms)
    local ex = GGConfig.AntiCheatExempt
    if not ex or not ex.Enabled or GetResourceState(ex.Resource) ~= 'started' then return end
    pcall(function() exports[ex.Resource]:ExemptPlayer(src, ms) end)
end

local function Count() local n = 0 for _ in pairs(Players) do n = n + 1 end return n end

-- ----------------------------------------------------------------------------
--  Stats (unique_gungame_stats: هاب و LevelQuest ازش میخونن)
-- ----------------------------------------------------------------------------
CreateThread(function()
    if not GGConfig.UseDatabase then return end
    MySQL.Async.execute([[
        CREATE TABLE IF NOT EXISTS unique_gungame_stats (
            identifier VARCHAR(60) NOT NULL PRIMARY KEY,
            name VARCHAR(100) NOT NULL,
            kills INT NOT NULL DEFAULT 0,
            wins INT NOT NULL DEFAULT 0,
            matches_played INT NOT NULL DEFAULT 0
        )
    ]], {})
end)

local function AddStats(identifier, name, kills, wins, matches)
    if not GGConfig.UseDatabase or not identifier then return end
    MySQL.Async.execute([[
        INSERT INTO unique_gungame_stats (identifier, name, kills, wins, matches_played) VALUES (@i, @n, @k, @w, @m)
        ON DUPLICATE KEY UPDATE name = @n, kills = kills + @k, wins = wins + @w, matches_played = matches_played + @m
    ]], { ['@i'] = identifier, ['@n'] = name, ['@k'] = kills, ['@w'] = wins, ['@m'] = matches })
end

RegisterCommand(GGConfig.StatsCommand, function(src)
    if not GGConfig.UseDatabase then return Msg(src, 'Database Khamoosh Ast.') end
    MySQL.Async.fetchAll('SELECT name, kills, wins FROM unique_gungame_stats ORDER BY kills DESC LIMIT 10', {}, function(rows)
        if not rows or #rows == 0 then return Msg(src, 'Hanoz Amari Sabt Nashode.') end
        Msg(src, '=== GunGame Top 10 ===')
        for i, r in ipairs(rows) do Msg(src, ('#%d %s - %s kills / %s wins'):format(i, r.name, r.kills, r.wins)) end
    end)
end, false)

-- ----------------------------------------------------------------------------
--  Scoreboard / kill feed (فقط برای بازیکن‌های مچ)
-- ----------------------------------------------------------------------------
local WeaponName = {}
for _, w in ipairs(Prog) do
    local h = GetHashKey(w)
    if h < 0 then h = h + 4294967296 end
    WeaponName[h] = w
end
WeaponName[(KNIFE < 0) and (KNIFE + 4294967296) or KNIFE] = GGConfig.KnifeWeapon
for _, w in ipairs(WZConfig and WZConfig.AllWeapons or {}) do
    local h = GetHashKey(w)
    if h < 0 then h = h + 4294967296 end
    WeaponName[h] = WeaponName[h] or w
end
local function WeaponOf(hash)
    hash = tonumber(hash) or 0
    if hash < 0 then hash = hash + 4294967296 end
    return WeaponName[hash] or 'UNKNOWN'
end

local function Broadcast(ev, ...)
    for src, p in pairs(Players) do if p.state ~= 'lobby' or State == 'lobby' then TriggerClientEvent(ev, src, ...) end end
end

local function BuildBoard()
    local rows = {}
    for src, p in pairs(Players) do rows[#rows + 1] = { src = src, name = p.name, level = p.level, kills = p.kills } end
    table.sort(rows, function(a, b)
        if a.level ~= b.level then return a.level > b.level end
        return a.kills > b.kills
    end)
    return rows
end

local function PushBoard()
    local rows = BuildBoard()
    for src in pairs(Players) do
        local top, mine = {}, nil
        for i, r in ipairs(rows) do
            if r.src == src then mine = i end
            if i <= GGConfig.ScoreboardTopCount then top[#top + 1] = { name = r.name, level = r.level, kills = r.kills, me = (r.src == src) } end
        end
        TriggerClientEvent('gg:board', src, top, mine, #Prog)
    end
end

-- ----------------------------------------------------------------------------
--  Spawn / weapons
-- ----------------------------------------------------------------------------
local function RandomPoint()
    return GGConfig.ArenaPoints[math.random(#GGConfig.ArenaPoints)]
end

local function SendSpawn(src, p, respawn)
    p.state = 'alive'
    ExemptAC(src, 15000)
    TriggerClientEvent('gg:spawn', src, V(RandomPoint()), p.level, Prog[math.min(p.level, #Prog)], respawn and 0 or GGConfig.WarmupTime)
end

-- ----------------------------------------------------------------------------
--  End / winner
-- ----------------------------------------------------------------------------
local function Webhook(text)
    local url = GGConfig.DiscordWebhook
    if type(url) ~= 'string' or url == '' then return end
    PerformHttpRequest(url, function() end, 'POST', json.encode({ username = 'GunGame', content = text }), { ['Content-Type'] = 'application/json' })
end

local function EndMatch(winnerSrc, reason)
    if State ~= 'running' then return end
    State = 'idle'
    StartToken = StartToken + 1
    local w = winnerSrc and Players[winnerSrc]
    if w then
        Msg(nil, ('Barande GunGame: %s (Level %d / %d kills)'):format(w.name, math.min(w.level, #Prog), w.kills))
        Webhook(('🏆 GunGame Winner: %s (%s)'):format(w.name, reason or ''))
    else
        Msg(nil, 'GunGame Tamam Shod.')
    end
    local restore = {}
    for src, p in pairs(Players) do
        AddStats(p.identifier, p.name, p.kills, (src == winnerSrc) and 1 or 0, 1)
        ExemptAC(src, 15000)
        TriggerClientEvent('gg:end', src, V(GGConfig.Exit), w and w.name or nil)
        restore[#restore + 1] = { src = src, bucket = p.prevBucket or 0 }
    end
    Players, Match = {}, nil
    SetTimeout(8000, function()
        for _, r in ipairs(restore) do
            if GetPlayerName(r.src) then SetPlayerRoutingBucket(r.src, r.bucket) end
        end
    end)
end

local function BestPlayer()
    local rows = BuildBoard()
    return rows[1] and rows[1].src or nil
end

-- ----------------------------------------------------------------------------
--  Start
-- ----------------------------------------------------------------------------
local function StartMatch()
    if State == 'running' or Count() < 1 then return false end
    State = 'running'
    StartToken = StartToken + 1
    local tok = StartToken
    Match = { endsAt = os.time() + GGConfig.MatchTime + GGConfig.WarmupTime }
    for src, p in pairs(Players) do
        p.level, p.kills, p.lastDeath = 1, 0, 0
        SetPlayerRoutingBucket(src, GGConfig.MatchWorld)
        SendSpawn(src, p, false)
        TriggerClientEvent('gg:time', src, GGConfig.MatchTime)
    end
    PushBoard()
    Msg(nil, ('GunGame Shoroo Shod ! (%d Player)'):format(Count()))
    CreateThread(function()
        while State == 'running' and StartToken == tok do
            Wait(1000)
            if State ~= 'running' or StartToken ~= tok or not Match then return end
            local left = Match.endsAt - os.time()
            Broadcast('gg:time', math.max(0, left - GGConfig.WarmupTime) )
            if left <= 0 then EndMatch(BestPlayer(), 'time-limit') return end
        end
    end)
    return true
end

local function ScheduleStart()
    if State ~= 'idle' and State ~= 'lobby' then return end
    local tok = StartToken
    CreateThread(function()
        local left = GGConfig.StartDelay
        Msg(nil, ('GunGame: Mach Dar %d Sanie Shoroo Mishavad. /%s'):format(left, GGConfig.JoinCommand))
        while left > 0 and State == 'lobby' and StartToken == tok do
            Wait(1000)
            left = left - 1
            Broadcast('gg:countdown', left)
            if Count() < GGConfig.MinPlayers then Msg(nil, 'GunGame: Bazikon Kafi Nist, Start Laghv Shod.') return end
        end
        if State == 'lobby' and StartToken == tok and Count() >= GGConfig.MinPlayers then StartMatch() end
    end)
end

-- ----------------------------------------------------------------------------
--  Join / Leave
-- ----------------------------------------------------------------------------
local function Remove(src, silent)
    local p = Players[src]
    if not p then return end
    Players[src] = nil
    if not silent then
        SetPlayerRoutingBucket(src, p.prevBucket or 0)
        ExemptAC(src, 15000)
        TriggerClientEvent('gg:leave', src, V(GGConfig.Exit))
    end
    if State == 'running' then
        PushBoard()
        if Count() == 0 then State = 'idle' StartToken = StartToken + 1 Match = nil end
    elseif State == 'lobby' and Count() == 0 then
        State = 'idle'
        StartToken = StartToken + 1
    end
end

RegisterCommand(GGConfig.JoinCommand, function(src)
    if src == 0 then return end
    local x = ESX.GetPlayerFromId(src)
    if not x then return end
    if Players[src] then return Notify(src, 'Shoma Dar GunGame Hastid', 'error') end
    if x.job and GGConfig.RestrictedJobs[x.job.name] then return Notify(src, 'Shoghl Shoma Ejaze Join Nadarad', 'error') end
    if GetPlayerRoutingBucket(src) ~= 0 then return Notify(src, 'Shoma Dar Yek World Digar Hastid !', 'error') end
    if Count() >= GGConfig.MaxPlayers then return Notify(src, 'Zarfiat GunGame Por Ast', 'error') end
    local ped = GetPlayerPed(src)
    if not ped or ped == 0 or GetEntityHealth(ped) <= 0 then return Notify(src, 'Shoma Nemitavanid Join Shavid !', 'error') end
    local p = { src = src, identifier = x.identifier, name = GetPlayerName(src) or ('ID ' .. src), level = 1, kills = 0,
        state = 'lobby', prevBucket = 0, lastDeath = 0 }
    Players[src] = p
    if State == 'running' then
        -- Sun: لابی باز؛ وسط مچ هم میشه وارد شد (از لول ۱)
        SetPlayerRoutingBucket(src, GGConfig.MatchWorld)
        ExemptAC(src, 15000)
        TriggerClientEvent('gg:lobby', src, V(GGConfig.Lobby))
        SetTimeout(500, function() if Players[src] and State == 'running' then SendSpawn(src, p, false) PushBoard() end end)
        TriggerClientEvent('gg:time', src, math.max(0, Match.endsAt - os.time() - GGConfig.WarmupTime))
    else
        SetPlayerRoutingBucket(src, GGConfig.LobbyWorld)
        ExemptAC(src, 15000)
        TriggerClientEvent('gg:lobby', src, V(GGConfig.Lobby))
        if State == 'idle' then State = 'lobby' end
        Msg(nil, ('%s Be GunGame Peyvast (%d/%d)'):format(p.name, Count(), GGConfig.MinPlayers))
        if Count() >= GGConfig.MinPlayers and State == 'lobby' then ScheduleStart() end
    end
end, false)

RegisterCommand(GGConfig.LeaveCommand, function(src)
    if src == 0 or not Players[src] then return end
    Remove(src)
    Notify(src, 'Shoma Az GunGame Kharej Shodid', 'inform')
end, false)

RegisterCommand(GGConfig.AdminCommand, function(src, args)
    if not HasPerm(src) then return end
    local a = tostring(args[1] or ''):lower()
    if a == 'start' then
        if State == 'running' then return Msg(src, 'Match Ghablan Shoroo Shode') end
        if Count() < 1 then return Msg(src, 'Hich Bazikoni Dar Lobby Nist') end
        StartMatch()
    elseif a == 'stop' then
        if State ~= 'running' then return Msg(src, 'Match Dar Hale Ejra Nist') end
        EndMatch(nil, 'admin')
    else
        Msg(src, 'Usage: /' .. GGConfig.AdminCommand .. ' start | stop')
    end
end, false)

AddEventHandler('playerDropped', function() Remove(source, true) end)

-- ----------------------------------------------------------------------------
--  Death: تنها منبع کیل/لول (esx:onPlayerDeath خودِ بیس)
-- ----------------------------------------------------------------------------
RegisterNetEvent('esx:onPlayerDeath')
AddEventHandler('esx:onPlayerDeath', function(data)
    local victim = source
    local p = Players[victim]
    if State ~= 'running' or not p or p.state ~= 'alive' then return end
    local now = NowMs()
    if now - p.lastDeath < 2000 then return end
    p.lastDeath = now
    p.state = 'dead'
    p.deathId = (p.deathId or 0) + 1
    local did = p.deathId
    data = type(data) == 'table' and data or {}

    local kid = tonumber(data.killer)
    local k = kid and kid ~= victim and Players[kid] or nil
    if k and k.state ~= 'alive' then k = nil end
    if k then
        k.kills = k.kills + 1
        if GGConfig.KnifeDemote and WeaponOf(data.deathCause) == GGConfig.KnifeWeapon and p.level > 1 then
            p.level = p.level - 1
        end
        k.level = k.level + 1
        if k.level > #Prog then
            Broadcast('gg:kill', k.name, p.name, WeaponOf(data.deathCause))
            return EndMatch(kid, 'final-kill')
        end
        TriggerClientEvent('gg:weapon', kid, Prog[k.level], k.level)
    end
    Broadcast('gg:kill', k and k.name or 'WORLD', p.name, k and WeaponOf(data.deathCause) or 'WORLD')
    PushBoard()
    TriggerClientEvent('gg:died', victim, GGConfig.RespawnDelay)
    SetTimeout(GGConfig.RespawnDelay * 1000, function()
        local pp = Players[victim]
        if State == 'running' and pp and pp.state == 'dead' and pp.deathId == did then SendSpawn(victim, pp, true) end
    end)
end)

AddEventHandler('onResourceStop', function(res)
    if res ~= GetCurrentResourceName() then return end
    for src, p in pairs(Players) do SetPlayerRoutingBucket(src, p.prevBucket or 0) end
end)

exports('IsGunGameRunning', function() return State == 'running' end)
exports('IsPlayerInGunGame', function(src) return Players[src] ~= nil end)
