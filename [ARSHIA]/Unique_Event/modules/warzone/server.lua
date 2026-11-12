-- ============================================================================
--  Unique WarZone  -  SERVER  (Sun-style Battle Royale, FFA)
--  همه‌ی منطق (لوت، کیل، Blood، گولاگ، دایره، برنده) سمت سرور تصمیم‌گیری و چک میشه؛
--  کلاینت فقط نمایش میده و درخواست میفرسته.
-- ============================================================================
local ESX = nil
TriggerEvent(WZConfig.ESX, function(obj) ESX = obj end)

local State = 'closed'            -- closed | lobby | running
local Players = {}                -- [src] = player
local Match = nil
local Loot, DeadLoot, NextDeadId = {}, {}, 0
local GulagQueue, Duel = {}, nil

local function NowMs() return GetGameTimer() end
local function V(c) return { x = c.x, y = c.y, z = c.z } end

local function Reply(src, text)
    if src == 0 then print('[WarZone] ' .. text) return end
    TriggerClientEvent('chat:addMessage', src, { args = { '^1WarZone', text } })
end
local function Msg(text) TriggerClientEvent('chat:addMessage', -1, { args = { '^1WarZone', text } }) end
local function Notify(src, msg, typ) TriggerClientEvent('br:notify', src, msg, typ or 'inform') end

local function HasPerm(src)
    if src == 0 then return true end
    local xPlayer = ESX.GetPlayerFromId(src)
    return xPlayer ~= nil and (tonumber(xPlayer.permission_level) or 0) >= WZConfig.permission
end

local function ExemptAC(src, ms)
    local ex = WZConfig.AntiCheatExempt
    if not ex or not ex.Enabled or GetResourceState(ex.Resource) ~= 'started' then return end
    pcall(function() exports[ex.Resource]:ExemptPlayer(src, ms) end)
end

local function Webhook(title, desc, color)
    local url = WZConfig.DiscordWebhook
    if type(url) ~= 'string' or url == '' then return end
    PerformHttpRequest(url, function() end, 'POST', json.encode({ username = WZConfig.DiscordWebhookName,
        embeds = { { title = title, description = desc, color = color or 16753920 } } }), { ['Content-Type'] = 'application/json' })
end

-- ----------------------------------------------------------------------------
--  Database  (جدول wz_leaderboard؛ هاب و LevelQuest ازش میخونن)
-- ----------------------------------------------------------------------------
CreateThread(function()
    MySQL.Async.execute([[
        CREATE TABLE IF NOT EXISTS `wz_leaderboard` (
            `identifier` VARCHAR(60) NOT NULL,
            `name` VARCHAR(100) NOT NULL DEFAULT '',
            `kills` INT NOT NULL DEFAULT 0,
            `wins` INT NOT NULL DEFAULT 0,
            `deaths` INT NOT NULL DEFAULT 0,
            `season` INT NOT NULL DEFAULT 1,
            PRIMARY KEY (`identifier`,`season`)
        )
    ]], {})
end)

local function AddStat(identifier, name, kills, wins, deaths)
    if not identifier then return end
    MySQL.Async.execute([[
        INSERT INTO wz_leaderboard (identifier, name, kills, wins, deaths, season)
        VALUES (@identifier, @name, @kills, @wins, @deaths, 1)
        ON DUPLICATE KEY UPDATE name = @name, kills = kills + @kills, wins = wins + @wins, deaths = deaths + @deaths
    ]], { ['@identifier'] = identifier, ['@name'] = name, ['@kills'] = kills, ['@wins'] = wins, ['@deaths'] = deaths })
end

RegisterCommand(WZConfig.statsCommend, function(src)
    if src == 0 then return end
    local xPlayer = ESX.GetPlayerFromId(src)
    if not xPlayer then return end
    MySQL.Async.fetchAll('SELECT SUM(kills) k, SUM(wins) w, SUM(deaths) d FROM wz_leaderboard WHERE identifier = @i',
        { ['@i'] = xPlayer.identifier }, function(r)
            local row = r and r[1] or {}
            Reply(src, ('Kills: %s | Wins: %s | Deaths: %s'):format(row.k or 0, row.w or 0, row.d or 0))
        end)
end, false)

RegisterCommand(WZConfig.wztopCommend, function(src)
    MySQL.Async.fetchAll('SELECT name, SUM(kills) kills, SUM(wins) wins FROM wz_leaderboard GROUP BY identifier, name ORDER BY kills DESC LIMIT 10', {}, function(rows)
        if not rows or #rows == 0 then return Reply(src, 'Hanoz Amari Sabt Nashode.') end
        Reply(src, '=== WarZone Top 10 ===')
        for i, r in ipairs(rows) do Reply(src, ('#%d %s - %s kills / %s wins'):format(i, r.name, r.kills, r.wins)) end
    end)
end, false)

-- ----------------------------------------------------------------------------
--  Helpers
-- ----------------------------------------------------------------------------
local function IsAliveState(st) return st == 'war' or st == 'revive' or st == 'gulag' end

local function Alive()
    local n = 0
    for _, p in pairs(Players) do if IsAliveState(p.state) then n = n + 1 end end
    return n
end

local function CountPlayers()
    local n = 0
    for _ in pairs(Players) do n = n + 1 end
    return n
end

local function Broadcast(event, ...)
    for src, p in pairs(Players) do
        if p.state ~= 'out' then TriggerClientEvent(event, src, ...) end
    end
end

local function UpdateCount()
    if State == 'running' then Broadcast('br:updatepcount', Alive()) end
end

local function Norm(h)
    h = tonumber(h) or 0
    if h < 0 then h = h + 4294967296 end
    return h
end

local WeaponLabel, LootSet = {}, {}
for _, w in ipairs(WZConfig.Loot.Weapons) do
    WeaponLabel[Norm(GetHashKey(w))] = w:gsub('^WEAPON_', '')
    LootSet[w] = true
end
local function LabelFor(hash) return WeaponLabel[Norm(hash)] or 'UNKNOWN' end

local function Clamp(n, lo, hi, def)
    n = tonumber(n)
    if not n then return def end
    return math.max(lo, math.min(hi, math.floor(n)))
end

-- ----------------------------------------------------------------------------
--  Loot
-- ----------------------------------------------------------------------------
local function GenerateLoot()
    Loot, DeadLoot = {}, {}
    local L, c = WZConfig.Loot, Match.center
    local R = Match.radius * 0.95
    for i = 1, L.Count do
        local a, r = math.random() * 2.0 * math.pi, R * math.sqrt(math.random())
        local e = { id = i, x = c.x + math.cos(a) * r, y = c.y + math.sin(a) * r, z = c.z,
            weapon = L.Weapons[math.random(#L.Weapons)], used = false }
        local roll = math.random(100)
        if roll <= L.ArmorChance then e.armor = L.Armors[math.random(#L.Armors)]
        elseif roll <= L.ArmorChance + L.HealChance then e.heal = true end
        Loot[i] = e
    end
end

ESX.RegisterServerCallback('br:getlootsdata', function(src, cb)
    local p = Players[src]
    if not p or State ~= 'running' then return cb({}) end
    local out = {}
    for i, e in ipairs(Loot) do
        out[i] = { id = e.id, coords = { x = e.x, y = e.y, z = e.z }, weapon = e.weapon, armor = e.armor, heal = e.heal, used = e.used }
    end
    cb(out)
end)

local function NearEnough(src, x, y, maxDist)
    local ped = GetPlayerPed(src)
    if not ped or ped == 0 then return false end
    local pc = GetEntityCoords(ped)
    return #(vector2(pc.x, pc.y) - vector2(x, y)) <= maxDist
end

RegisterNetEvent('br:useloot')
AddEventHandler('br:useloot', function(id)
    local src = source
    local p = Players[src]
    if not p or p.state ~= 'war' or State ~= 'running' then return end
    local now = NowMs()
    if (p.lootCooldown or 0) > now then return end
    p.lootCooldown = now + 400
    local e = Loot[tonumber(id) or -1]
    if not e or e.used then return end
    local L = WZConfig.Loot
    if not NearEnough(src, e.x, e.y, L.PickupDistance + L.ServerPickupTolerance) then return end
    e.used = true
    TriggerClientEvent('br:lootGranted', src, { weapons = { { name = e.weapon, ammo = L.Ammo } }, armor = e.armor, heal = e.heal })
    Broadcast('br:updateloot', e.id)
end)

-- سلاح‌های جسد (فقط بعد از مرگ خودِ بازیکن، یکبار، فقط سلاح‌های لوت‌لیست)
RegisterNetEvent('br:createdeadpickup')
AddEventHandler('br:createdeadpickup', function(coords, weapons)
    local src = source
    local p = Players[src]
    if not p or State ~= 'running' or (p.dropUntil or 0) < NowMs() then return end
    p.dropUntil = 0
    if type(coords) ~= 'table' or type(weapons) ~= 'table' then return end
    local x, y, z = tonumber(coords.x), tonumber(coords.y), tonumber(coords.z)
    if not x or not y or not z or not NearEnough(src, x, y, 40.0) then return end
    local L, list = WZConfig.Loot, {}
    for _, w in ipairs(weapons) do
        if type(w) == 'table' and LootSet[w.name] and #list < L.DeadDropMaxWeapons then
            list[#list + 1] = { name = w.name, ammo = Clamp(w.ammo, 1, L.Ammo, L.Ammo) }
        end
    end
    if #list == 0 then return end
    NextDeadId = NextDeadId + 1
    DeadLoot[NextDeadId] = { id = NextDeadId, x = x, y = y, z = z, weapons = list }
    Broadcast('br:createploot', { id = NextDeadId, coords = { x = x, y = y, z = z }, weapons = list })
end)

RegisterNetEvent('br:useploot')
AddEventHandler('br:useploot', function(id)
    local src = source
    local p = Players[src]
    if not p or p.state ~= 'war' or State ~= 'running' then return end
    local d = DeadLoot[tonumber(id) or -1]
    if not d or not NearEnough(src, d.x, d.y, WZConfig.Loot.PickupDistance + WZConfig.Loot.ServerPickupTolerance) then return end
    DeadLoot[d.id] = nil
    TriggerClientEvent('br:lootGranted', src, { weapons = d.weapons })
    Broadcast('br:removeploot', d.id)
end)

-- ----------------------------------------------------------------------------
--  Elimination / winner
-- ----------------------------------------------------------------------------
local EndMatch

local function RemoveFromQueue(src)
    for i, s in ipairs(GulagQueue) do
        if s == src then table.remove(GulagQueue, i) return end
    end
end

local function BackToWar(src)
    local p = Players[src]
    if not p or p.state == 'out' then return end
    p.state = 'war'
    SetPlayerRoutingBucket(src, WZConfig.FightWorld)
    ExemptAC(src, 20000)
    TriggerClientEvent('br:backwar', src, Match and Match.radius or 500.0)
end

local function TryStartDuel()
    if Duel or State ~= 'running' then return end
    local G = WZConfig.Gulag
    while #GulagQueue >= 2 do
        local a, b = table.remove(GulagQueue, 1), table.remove(GulagQueue, 1)
        local pa, pb = Players[a], Players[b]
        local okA, okB = pa and pa.state == 'gulag', pb and pb.state == 'gulag'
        if okA and okB then
            Duel = { a = a, b = b, startedAt = NowMs() }
            TriggerClientEvent('br:waitgulag2', a, V(G.SpotA), G.FreezeA, G.Weapon, G.Ammo, V(G.SpotB))
            TriggerClientEvent('br:waitgulag3', b, V(G.SpotB), G.FreezeB, G.Weapon, G.Ammo, V(G.SpotA))
            return
        end
        if okA then table.insert(GulagQueue, 1, a) end
        if okB then table.insert(GulagQueue, 1, b) end
    end
end

local function CheckWinner()
    if State ~= 'running' or Alive() > 1 then return end
    local winner
    for src, p in pairs(Players) do if IsAliveState(p.state) then winner = src end end
    EndMatch(winner, 'last-alive')
end

local function Eliminate(src, silent)
    local p = Players[src]
    if not p or p.state == 'out' then return end
    RemoveFromQueue(src)
    local wasDuel = Duel and (Duel.a == src or Duel.b == src)
    local other = wasDuel and (Duel.a == src and Duel.b or Duel.a) or nil
    p.state = 'out'
    if wasDuel then Duel = nil end
    if not silent then
        SetPlayerRoutingBucket(src, p.prevBucket or 0)
        ExemptAC(src, 15000)
        TriggerClientEvent('br:leavemeg', src, V(WZConfig.LastCoord))
    end
    if other then BackToWar(other) end
    UpdateCount()
    CheckWinner()
    TryStartDuel()
end

local function ResolveDuel(winner, loser)
    if not Duel then return end
    Duel = nil
    BackToWar(winner)
    Eliminate(loser)
end

local function GulagEnqueue(src)
    local p = Players[src]
    p.state = 'gulag'
    p.gulagSince = NowMs()
    SetPlayerRoutingBucket(src, WZConfig.Gulagworld)
    ExemptAC(src, 20000)
    TriggerClientEvent('br:waitgulag', src, V(WZConfig.Gulag.Wait))
    GulagQueue[#GulagQueue + 1] = src
    TryStartDuel()
end

local function DoRedeploy(src)
    local p = Players[src]
    if not p or p.state ~= 'revive' then return end
    p.state = 'war'
    ExemptAC(src, 20000)
    TriggerClientEvent('br:redeploy', src)
end

RegisterNetEvent('br:redeploy')
AddEventHandler('br:redeploy', function() DoRedeploy(source) end)

-- ----------------------------------------------------------------------------
--  Death
-- ----------------------------------------------------------------------------
RegisterNetEvent('esx:onPlayerDeath')
AddEventHandler('esx:onPlayerDeath', function(data)
    local src = source
    local p = Players[src]
    if not p or State ~= 'running' or (p.state ~= 'war' and p.state ~= 'gulag') then return end
    local now = NowMs()
    if now - p.lastDeath < 2500 then return end
    p.lastDeath = now
    data = type(data) == 'table' and data or {}

    local kid = tonumber(data.killer)
    local k = kid and kid ~= src and Players[kid] or nil
    if k and k.state ~= p.state then k = nil end -- قاتل باید توی همون arena باشه

    AddStat(p.identifier, p.name, 0, 0, 1)
    if k then
        k.kills = k.kills + 1
        AddStat(k.identifier, k.name, 1, 0, 0)
    end
    if WZConfig.ShowKillFeed then
        Broadcast('br:pkilled', k and k.name or 'ZONE', p.name, k and LabelFor(data.deathCause) or 'ZONE', false)
    end

    if p.state == 'gulag' then
        if Duel and (Duel.a == src or Duel.b == src) then
            ResolveDuel(Duel.a == src and Duel.b or Duel.a, src)
        else
            Eliminate(src)
        end
        return
    end

    -- war
    p.dropUntil = now + 15000
    TriggerClientEvent('br:droploot', src)
    p.blood = p.blood - 1
    TriggerClientEvent('br:updateblood', src, p.blood)
    if p.blood > 0 then
        p.state = 'revive'
        p.reviveToken = (p.reviveToken or 0) + 1
        local token = p.reviveToken
        TriggerClientEvent('br:reviveth', src, p.blood)
        SetTimeout(WZConfig.ReviveTimeout * 1000, function()
            local pp = Players[src]
            if pp and pp.state == 'revive' and pp.reviveToken == token then DoRedeploy(src) end
        end)
    elseif not p.gulagUsed then
        p.gulagUsed = true
        GulagEnqueue(src)
    else
        Eliminate(src)
    end
    UpdateCount()
end)

-- ----------------------------------------------------------------------------
--  Match lifecycle
-- ----------------------------------------------------------------------------
local function ReturnAll(coordsEvent)
    for src, p in pairs(Players) do
        if p.state ~= 'out' then
            TriggerClientEvent(coordsEvent, src, V(WZConfig.LastCoord))
        end
    end
end

EndMatch = function(winnerSrc, reason)
    if State ~= 'running' then return end
    State = 'closed'
    local w = winnerSrc and Players[winnerSrc]
    if w then
        AddStat(w.identifier, w.name, 0, 1, 0)
        local xPlayer = ESX.GetPlayerFromId(winnerSrc)
        if xPlayer and (WZConfig.WinnerReward or 0) > 0 then xPlayer.addMoney(WZConfig.WinnerReward) end
        Msg(('Barande WarZone: %s (%d kills)'):format(w.name, w.kills))
        Webhook('🏆 WarZone Winner', ('%s - %d kills (%s)'):format(w.name, w.kills, reason or ''))
    else
        Msg('WarZone Tamam Shod.')
    end
    local restore = {}
    for src, p in pairs(Players) do
        if p.state ~= 'out' then
            TriggerClientEvent('br:end', src, V(WZConfig.LastCoord))
            restore[#restore + 1] = { src = src, bucket = p.prevBucket or 0 }
            ExemptAC(src, 20000)
        end
    end
    Players, Match, Duel = {}, nil, nil
    Loot, DeadLoot, GulagQueue = {}, {}, {}
    SetTimeout(8000, function()
        for _, r in ipairs(restore) do
            if GetPlayerName(r.src) then SetPlayerRoutingBucket(r.src, r.bucket) end
        end
    end)
end

local function BeginMatch(src, blood, stageMin, mapName)
    if State == 'running' then return false, 'Warzone has started' end
    if State ~= 'lobby' then return false, 'Lobbey has not opened' end
    if CountPlayers() < 1 then return false, 'No players in lobby' end
    local AQ = WZConfig.AutoQueue
    blood = Clamp(blood, 1, 10, AQ.defaultBlood)
    stageMin = Clamp(stageMin, 1, 30, AQ.defaultTime)
    mapName = string.upper(tostring(mapName or AQ.defaultMap))
    local map = WZConfig.Maps[mapName]
    if not map then mapName = AQ.defaultMap map = WZConfig.Maps[mapName] end

    State = 'running'
    Match = { id = (Match and Match.id or 0) + 1, map = mapName, center = map.center, radius = map.radius,
        blood = blood, stageMinutes = stageMin, startedAt = os.time() }
    local mid = Match.id
    GulagQueue, Duel = {}, nil
    GenerateLoot()

    for psrc, p in pairs(Players) do
        p.blood, p.kills, p.state, p.gulagUsed, p.lastDeath, p.dropUntil = blood, 0, 'war', false, 0, 0
        SetPlayerRoutingBucket(psrc, WZConfig.FightWorld)
        ExemptAC(psrc, 180000)
        TriggerClientEvent('br:join', psrc, V(map.center), map.radius, Alive(), blood)
        TriggerClientEvent('br:start', psrc, WZConfig.StartCountdown)
    end
    Msg(WZConfig.StartMatchNotify .. ' (' .. mapName .. ')')
    Webhook('🪖 WarZone Started', ('Map: %s | Players: %d | Blood: %d'):format(mapName, CountPlayers(), blood), 3066993)

    -- دایره
    CreateThread(function()
        local first = true
        for i, frac in ipairs(WZConfig.Ring.Stages) do
            local waitS = stageMin * 60 + (first and (WZConfig.StartCountdown + 60) or 0)
            first = false
            local t = 0
            while t < waitS do
                Wait(1000)
                t = t + 1
                if State ~= 'running' or not Match or Match.id ~= mid then return end
            end
            local nextRadius = math.floor(map.radius * frac)
            Match.radius = nextRadius
            Broadcast('br:updatemarker', nextRadius)
            Broadcast('br:notify', 'Zone Dar Hale Kochak Shodan Ast !', 'error')
        end
    end)

    -- سقف زمانی
    CreateThread(function()
        local limit = WZConfig.MaxMatchMinutes * 60
        local t = 0
        while t < limit do
            Wait(1000)
            t = t + 1
            if State ~= 'running' or not Match or Match.id ~= mid then return end
        end
        local best, bestKills = nil, -1
        for psrc, p in pairs(Players) do
            if IsAliveState(p.state) and p.kills > bestKills then best, bestKills = psrc, p.kills end
        end
        EndMatch(best, 'time-limit')
    end)

    -- گولاگ: انتظار بی‌حریف و تایم‌اوت دوئل
    CreateThread(function()
        local G = WZConfig.Gulag
        while State == 'running' and Match and Match.id == mid do
            Wait(1000)
            TryStartDuel()
            if not Duel and #GulagQueue == 1 then
                local s = GulagQueue[1]
                local p = Players[s]
                if p and NowMs() - p.gulagSince > G.WaitTimeout * 1000 then
                    table.remove(GulagQueue, 1)
                    BackToWar(s)
                end
            end
            if Duel and NowMs() - Duel.startedAt > G.DuelTimeout * 1000 then
                local a, b = Duel.a, Duel.b
                local ha, hb = GetEntityHealth(GetPlayerPed(a)), GetEntityHealth(GetPlayerPed(b))
                if ha >= hb then ResolveDuel(a, b) else ResolveDuel(b, a) end
            end
        end
    end)
    return true
end

local function OpenLobby(src)
    if State == 'running' then return false, 'Warzone has started' end
    if State == 'lobby' then return false, 'Lobbey has opened' end
    State = 'lobby'
    Players = {}
    Msg(WZConfig.StartNotify)
    local AQ = WZConfig.AutoQueue
    if AQ.enabled then
        CreateThread(function()
            while State == 'lobby' do
                Wait(3000)
                if State == 'lobby' and CountPlayers() >= AQ.minPlayers then
                    Msg('Enough players joined - match starts in ' .. AQ.countdown .. 's!')
                    local left = AQ.countdown
                    while left > 0 and State == 'lobby' do
                        Wait(1000)
                        left = left - 1
                        if CountPlayers() < AQ.minPlayers then Msg('Not enough players anymore, auto-start cancelled.') break end
                        if left > 0 and left <= 5 then Msg('Match starting in ' .. left .. '...') end
                    end
                    if State == 'lobby' and left <= 0 and CountPlayers() >= AQ.minPlayers then
                        BeginMatch(0, AQ.defaultBlood, AQ.defaultTime, AQ.defaultMap)
                    end
                end
            end
        end)
    end
    return true
end

local function CloseAll(coordsEvent)
    for src, p in pairs(Players) do
        if p.state ~= 'out' then
            SetPlayerRoutingBucket(src, p.prevBucket or 0)
            ExemptAC(src, 15000)
            TriggerClientEvent(coordsEvent, src, V(WZConfig.LastCoord))
        end
    end
    Players, Match, Duel = {}, nil, nil
    Loot, DeadLoot, GulagQueue = {}, {}, {}
end

-- ----------------------------------------------------------------------------
--  Commands
-- ----------------------------------------------------------------------------
RegisterCommand(WZConfig.StartCommend, function(src)
    if not HasPerm(src) then return Reply(src, 'You do not have permission to use this command') end
    local ok, err = OpenLobby(src)
    if not ok then Reply(src, err) end
end, false)

RegisterCommand(WZConfig.JoinLobbeyCommend, function(src)
    if src == 0 then return end
    if State ~= 'lobby' then return Reply(src, State == 'running' and 'Warzone has started' or 'Lobbey has not opened') end
    if Players[src] then return Reply(src, 'Shoma Dar Lobby Hastid') end
    local xPlayer = ESX.GetPlayerFromId(src)
    if not xPlayer then return end
    Players[src] = { src = src, identifier = xPlayer.identifier, name = GetPlayerName(src) or ('ID ' .. src), blood = 0, kills = 0,
        state = 'lobby', prevBucket = GetPlayerRoutingBucket(src), lastDeath = 0 }
    SetPlayerRoutingBucket(src, WZConfig.LobbeyWorld)
    ExemptAC(src, 20000)
    TriggerClientEvent('br:lobby', src, V(WZConfig.LobbeyCoord))
    Notify(src, 'Shoma Vared Lobby Shodid. Montazer Start Bashid.', 'success')
end, false)

RegisterCommand(WZConfig.Startmatchcommend, function(src, args)
    if not HasPerm(src) then return Reply(src, 'You do not have permission to use this command') end
    local ok, err = BeginMatch(src, args[1], args[2], args[3])
    if not ok then Reply(src, err) end
end, false)

RegisterCommand(WZConfig.closelobbey, function(src)
    if not HasPerm(src) then return Reply(src, 'You do not have permission to use this command') end
    if State == 'running' then return Reply(src, 'Warzone has started') end
    if State ~= 'lobby' then return Reply(src, 'Lobbey has not opened') end
    State = 'closed'
    CloseAll('br:leavemeg')
end, false)

RegisterCommand(WZConfig.endwarzoneCommend, function(src)
    if not HasPerm(src) then return Reply(src, 'You do not have permission to use this command') end
    if State ~= 'running' then return Reply(src, 'Warzone has not started') end
    EndMatch(nil, 'admin')
end, false)

RegisterCommand(WZConfig.exitCommend, function(src)
    if src == 0 then return end
    local p = Players[src]
    if not p or p.state == 'out' then return end
    if State == 'lobby' then
        Players[src] = nil
        SetPlayerRoutingBucket(src, p.prevBucket or 0)
        TriggerClientEvent('br:leavemeg', src, V(WZConfig.LastCoord))
    elseif State == 'running' then
        Eliminate(src)
    end
    Notify(src, 'You left the Battle', 'inform')
end, false)

AddEventHandler('playerDropped', function()
    local src = source
    local p = Players[src]
    if not p then return end
    if State == 'running' then Eliminate(src, true) else Players[src] = nil end
end)

AddEventHandler('onResourceStop', function(res)
    if res ~= GetCurrentResourceName() then return end
    for src, p in pairs(Players) do SetPlayerRoutingBucket(src, p.prevBucket or 0) end
end)

exports('IsWarzoneRunning', function() return State == 'running' end)
exports('IsPlayerInWarzone', function(src) local p = Players[src] return p ~= nil and p.state ~= 'out' end)
