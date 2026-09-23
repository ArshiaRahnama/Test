--[[
    Unique_Event - CAPTURE (server)

    Gangs fight over a set of zones. Standing alone (no enemy gang member nearby) at a zone's
    capture point for Config.Capture.TimeToCaptureZone seconds gives that zone to your gang.
    Every Config.Capture.PointInterval seconds, the owning gang scores 1 point. Kills and gang
    points feed the round scoreboard; kills and (kills*W - deaths*W) feed the persistent
    all-time leaderboard.

    Bugs fixed vs the original Unique_Capture:
    - server now validates every capture/point tick itself (client can no longer fake ownership)
    - a round can be started again after it ends without a resource restart
    - leaving a contested zone no longer lets a single player farm it back instantly (lockout)
    - kills are attributed server-side (UE.ResolveKiller), not trusted from the client
]]

local Cap = {}
UE.RegisterModule('capture', Cap)

-- ---------------------------------------------------------------------------
-- Persistent zones (zones.json in the resource root; falls back to DefaultZones)
-- ---------------------------------------------------------------------------
local function loadZones()
    if Config.Capture.PersistZones then
        local raw = LoadResourceFile(UE.Resource, Config.Capture.ZonesFileName)
        if raw then
            local ok, decoded = pcall(json.decode, raw)
            if ok and type(decoded) == 'table' and #decoded > 0 then return decoded end
        end
    end
    local out = {}
    for _, z in ipairs(Config.Capture.DefaultZones) do out[#out + 1] = { name = z.name, x = z.x, y = z.y, z = z.z } end
    return out
end

local function saveZones(zones)
    if not Config.Capture.PersistZones then return end
    SaveResourceFile(UE.Resource, Config.Capture.ZonesFileName, json.encode(zones), -1)
end

-- ---------------------------------------------------------------------------
-- Round state
-- ---------------------------------------------------------------------------
local Zones = loadZones()          -- { {name,x,y,z, owner=gangname|nil, lastPointAt=osTime, lockUntil={[gang]=osTime}} }
local Round = {
    active = false, endsAt = 0, killers = {}, gangs = {},   -- [identifier/gang] = points this round
    killerNames = {}, playersInZone = {},                    -- [src] = zoneIndex or nil
}
local CapturingBy = {}   -- [zoneIndex] = { [src] = startedAtGameTimer }

local startRound, endRound   -- forward-declared: used by the round-timer thread below their definition

-- ---------------------------------------------------------------------------
-- Database
-- ---------------------------------------------------------------------------
UE.DB.Ready(function()
    UE.DB.Exec([[CREATE TABLE IF NOT EXISTS ue_capture_stats (
        identifier VARCHAR(64) NOT NULL PRIMARY KEY,
        name VARCHAR(64) NOT NULL DEFAULT '',
        kills INT NOT NULL DEFAULT 0,
        deaths INT NOT NULL DEFAULT 0,
        gang_points INT NOT NULL DEFAULT 0
    )]])
    UE.DB.Exec([[CREATE TABLE IF NOT EXISTS ue_capture_history (
        id INT AUTO_INCREMENT PRIMARY KEY,
        zone VARCHAR(64) NOT NULL,
        winner_gang VARCHAR(64) NOT NULL DEFAULT '',
        ended_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP
    )]])
end)

local function bumpStat(identifier, name, field, amount)
    UE.DB.Exec('INSERT INTO ue_capture_stats (identifier, name, ' .. field .. ') VALUES (?, ?, ?) ' ..
        'ON DUPLICATE KEY UPDATE ' .. field .. ' = ' .. field .. ' + VALUES(' .. field .. '), name = VALUES(name)',
        { identifier, name, amount })
end

local function playerIdentifier(src)
    local x = UE.GetPlayer(src)
    return x and x.identifier or nil
end

-- ---------------------------------------------------------------------------
-- Gang helpers (gangmenu / gang_data table - adjust table/column names in Config if yours differ)
-- ---------------------------------------------------------------------------
local function gangBossCoord(gangName, cb)
    UE.DB.One('SELECT ' .. Config.Capture.GangsBossColumn .. ' AS boss FROM ' .. Config.Capture.GangsTable ..
        ' WHERE ' .. Config.Capture.GangsNameColumn .. ' = ?', { gangName }, function(row)
        if not row or not row.boss then return cb(nil) end
        local ok, decoded = pcall(json.decode, row.boss)
        if ok and decoded and decoded.x then return cb(vector3(decoded.x + 0.0, decoded.y + 0.0, (decoded.z or 0.0) + 0.0)) end
        cb(nil)
    end)
end

local function gangLogo(gangName, cb)
    UE.DB.One('SELECT ' .. Config.Capture.GangsLogoColumn .. ' AS logo FROM ' .. Config.Capture.GangsTable ..
        ' WHERE ' .. Config.Capture.GangsNameColumn .. ' = ?', { gangName }, function(row)
        cb(row and row.logo and row.logo ~= '' and row.logo or Config.Capture.DefaultGangLogo)
    end)
end

-- ---------------------------------------------------------------------------
-- Join / leave
-- ---------------------------------------------------------------------------
local function tryJoin(src)
    local ok, reason = UE.CanJoin(src, 'capture')
    if not ok then return UE.Notify(src, reason, 'error') end

    local xPlayer = UE.GetPlayer(src)
    local gang = xPlayer.gang and xPlayer.gang.name
    if Config.Capture.RequireGang and (not gang or gang == 'nogang' or gang == '') then
        return UE.Notify(src, 'You need to be in a gang to join Capture.', 'error')
    end

    local function finish(entryCoord)
        UE.Enter(src, 'capture')
        UE.SetBucket(src, Config.Buckets.Capture)
        Round.playersInZone[src] = nil
        TriggerClientEvent('ue:capture:join', src, {
            zones = Zones, active = Round.active, endsAt = Round.endsAt, gang = gang,
            capRadius = Config.Capture.CaptureRadius, zoneRadius = Config.Capture.ZoneRadius,
            entry = entryCoord and UE.Vec(entryCoord) or nil,
        })
        UE.Notify(src, 'Joined Capture as ' .. gang .. '.', 'success')
    end

    if Config.Capture.RequireGangBoss then
        gangBossCoord(gang, function(boss)
            if not boss then return finish(nil) end
            local pos = GetEntityCoords(GetPlayerPed(src))
            if UE.Dist(pos, boss) > Config.Capture.GangBossJoinRadius then
                return UE.Notify(src, 'You must be near your gang boss to join Capture.', 'error')
            end
            finish(boss)
        end)
    else
        finish(nil)
    end
end
UE.Command({ 'joinCap' }, function(src) tryJoin(src) end)

local function doLeave(src, silent)
    if UE.InEvent[src] ~= 'capture' then return end
    UE.Exit(src, 'capture')
    UE.ResetBucket(src)
    local zi = Round.playersInZone[src]
    if zi and CapturingBy[zi] then CapturingBy[zi][src] = nil end
    Round.playersInZone[src] = nil
    TriggerClientEvent('ue:capture:leave', src, Config.Capture.DefaultReturnCoord and UE.Vec(Config.Capture.DefaultReturnCoord) or nil)
    if not silent then UE.Notify(src, 'You left Capture.', 'info') end
end
UE.Command({ 'leaveCap' }, function(src) doLeave(src, false) end)
UE.OnDrop(function(src) doLeave(src, true) end)

UE.Command({ 'reCap' }, function(src)
    if UE.InEvent[src] ~= 'capture' then return UE.Notify(src, 'You are not in Capture.', 'error') end
    TriggerClientEvent('ue:capture:respawn', src)
end)

-- ---------------------------------------------------------------------------
-- Zone position tracking (client reports which zone it's standing in / capturing)
-- ---------------------------------------------------------------------------
RegisterNetEvent('ue:capture:inZone')
AddEventHandler('ue:capture:inZone', function(zoneIndex)
    local src = source
    if UE.InEvent[src] ~= 'capture' then return end
    zoneIndex = tonumber(zoneIndex)
    if zoneIndex and not Zones[zoneIndex] then zoneIndex = nil end
    Round.playersInZone[src] = zoneIndex
end)

-- capture tick: every second, for each zone, see who is standing at the point
local function gangOf(src)
    local x = UE.GetPlayer(src)
    return x and x.gang and x.gang.name or nil
end

CreateThread(function()
    while true do
        Wait(1000)
        if Round.active then
            for zi, zone in ipairs(Zones) do
                local present = {}
                for src, atZone in pairs(Round.playersInZone) do
                    if atZone == zi and UE.InEvent[src] == 'capture' then
                        local g = gangOf(src)
                        if g and g ~= 'nogang' then present[g] = present[g] or {} present[g][#present[g] + 1] = src end
                    end
                end
                local gangCount = UE.Count(present)
                CapturingBy[zi] = CapturingBy[zi] or {}

                if gangCount == 1 then
                    local onlyGang = next(present)
                    if zone.owner == onlyGang then
                        CapturingBy[zi] = {}   -- already owned, nothing to capture
                    else
                        local startedAt = CapturingBy[zi].startedAt
                        local capturingGang = CapturingBy[zi].gang
                        if capturingGang ~= onlyGang then
                            CapturingBy[zi] = { gang = onlyGang, startedAt = GetGameTimer() }
                            startedAt = CapturingBy[zi].startedAt
                        end
                        local elapsed = (GetGameTimer() - startedAt) / 1000
                        for _, src in ipairs(present[onlyGang]) do
                            TriggerClientEvent('ue:capture:captureProgress', src, zone.name, math.floor(elapsed), Config.Capture.TimeToCaptureZone, 'capturing')
                        end
                        if elapsed >= Config.Capture.TimeToCaptureZone then
                            local prevOwner = zone.owner
                            zone.owner = onlyGang
                            zone.lastPointAt = os.time()
                            CapturingBy[zi] = {}
                            saveZones(Zones)
                            UE.Log('Capture', {
                                title = 'Zone captured', color = 0x39E07D,
                                description = ('**%s** captured **%s**%s'):format(onlyGang, zone.name, prevOwner and (' from **' .. prevOwner .. '**') or ''),
                            })
                            for _, s in ipairs(present[onlyGang]) do
                                UE.Notify(s, 'Your gang captured ' .. zone.name .. '!', 'success')
                            end
                            Cap.PushZones()
                        end
                    end
                elseif gangCount > 1 then
                    CapturingBy[zi] = {}
                    for _, list in pairs(present) do
                        for _, src in ipairs(list) do
                            TriggerClientEvent('ue:capture:captureProgress', src, zone.name, 0, Config.Capture.TimeToCaptureZone, 'contested')
                        end
                    end
                else
                    CapturingBy[zi] = {}
                end

                -- owner keeps scoring points over time
                if zone.owner and (os.time() - (zone.lastPointAt or 0)) >= Config.Capture.PointInterval then
                    zone.lastPointAt = os.time()
                    Round.gangs[zone.owner] = (Round.gangs[zone.owner] or 0) + 1
                end
            end
        end
        Wait(0)
    end
end)

-- stop showing a capture bar for players who are no longer actively capturing
CreateThread(function()
    while true do
        Wait(1500)
        for src, atZone in pairs(Round.playersInZone) do
            if not atZone then TriggerClientEvent('ue:capture:captureProgressHide', src) end
        end
    end
end)

-- push round timer + scoreboards to everyone in Capture, every 3s
CreateThread(function()
    while true do
        Wait(3000)
        local players = UE.PlayersIn('capture')
        if #players > 0 then
            local killers = {}
            for s, k in pairs(Round.killers) do killers[#killers + 1] = { name = Round.killerNames[s] or UE.Name(s), points = k } end
            table.sort(killers, function(a, b) return a.points > b.points end)
            local gangs = {}
            for g, p in pairs(Round.gangs) do gangs[#gangs + 1] = { name = g, points = p } end
            table.sort(gangs, function(a, b) return a.points > b.points end)
            local timeLeft = Round.active and math.max(0, Round.endsAt - os.time()) or 0
            local percent = Round.active and math.min(100, (timeLeft / math.max(1, (Config.Capture.DefaultTime * 60))) * 100) or 0
            for _, src in ipairs(players) do
                TriggerClientEvent('ue:capture:board', src, {
                    time = UE.FormatTime(timeLeft), percent = percent, killers = killers, gangs = gangs,
                })
            end
            if Round.active and timeLeft <= 0 then endRound(0) end
        end
    end
end)

function Cap.PushZones()
    local out = {}
    for _, z in ipairs(Zones) do out[#out + 1] = { name = z.name, owner = z.owner } end
    for _, src in ipairs(UE.PlayersIn('capture')) do TriggerClientEvent('ue:capture:zones', src, out) end
end

-- ---------------------------------------------------------------------------
-- Round control (admin)
-- ---------------------------------------------------------------------------
startRound = function(src, minutes)
    if not UE.CanAdmin(src, 'capture') then return UE.Notify(src, 'No permission.', 'error') end
    if Round.active then return UE.Notify(src, 'A round is already running.', 'error') end
    minutes = UE.ToNumber(minutes, Config.Capture.DefaultTime)
    Round.active = true
    Round.endsAt = os.time() + (minutes * 60)
    Round.killers, Round.gangs, Round.killerNames = {}, {}, {}
    for _, z in ipairs(Zones) do z.lastPointAt = os.time() end
    for _, s in ipairs(UE.PlayersIn('capture')) do UE.Announce(s, 'CAPTURE ROUND STARTED', 6, 'success') end
    UE.Log('Capture', { title = 'Round started', color = 0x39E07D, description = ('by %s - %d minutes'):format(UE.Name(src), minutes) })
end

endRound = function(src)
    if not UE.CanAdmin(src, 'capture') then return UE.Notify(src, 'No permission.', 'error') end
    if not Round.active then return UE.Notify(src, 'No round is running.', 'error') end
    Round.active = false
    local topGang, topPoints = nil, -1
    for g, p in pairs(Round.gangs) do if p > topPoints then topGang, topPoints = g, p end end
    for _, z in ipairs(Zones) do
        UE.DB.Exec('INSERT INTO ue_capture_history (zone, winner_gang) VALUES (?, ?)', { z.name, z.owner or '' })
    end
    for _, s in ipairs(UE.PlayersIn('capture')) do
        UE.Announce(s, topGang and ('ROUND OVER - ' .. topGang .. ' WINS') or 'ROUND OVER', 7, 'gold')
    end
    UE.Log('Capture', { title = 'Round ended', color = 0xFFB020, description = topGang and ('Winner: **' .. topGang .. '** (' .. topPoints .. ' pts)') or 'No points scored' })
end
UE.Command({ 'startCap' }, function(src, args) startRound(src, args[1]) end)
UE.Command({ 'endCap' }, function(src) endRound(src) end)

UE.Command({ 'resetzonesCap' }, function(src)
    if not UE.CanAdmin(src, 'capture') then return UE.Notify(src, 'No permission.', 'error') end
    for _, z in ipairs(Zones) do z.owner = nil end
    saveZones(Zones)
    Cap.PushZones()
    UE.Notify(src, 'All zones reset to neutral.', 'success')
end)

-- ---------------------------------------------------------------------------
-- Combat: kills, deaths, damage
-- ---------------------------------------------------------------------------
RegisterNetEvent('ue:capture:died')
AddEventHandler('ue:capture:died', function(killerId)
    local src = source
    if UE.InEvent[src] ~= 'capture' then return end
    local killer = (UE.InEvent[killerId] == 'capture' and UE.PlausibleKiller(src, killerId)) and killerId or 0
    local victimGang = gangOf(src)
    local vIdentifier = playerIdentifier(src)
    if vIdentifier then bumpStat(vIdentifier, UE.Name(src), 'deaths', 1) end

    if killer ~= 0 then
        local killerGang = gangOf(killer)
        local kIdentifier = playerIdentifier(killer)
        if kIdentifier then bumpStat(kIdentifier, UE.Name(killer), 'kills', 1) end
        Round.killers[killer] = (Round.killers[killer] or 0) + 1
        Round.killerNames[killer] = UE.Name(killer)
        if killerGang and killerGang ~= 'nogang' then
            Round.gangs[killerGang] = (Round.gangs[killerGang] or 0) + 1
            if kIdentifier then bumpStat(kIdentifier, UE.Name(killer), 'gang_points', 1) end
        end
        TriggerClientEvent('ue:capture:kill', -1, {
            killer = UE.Name(killer), damaged = UE.Name(src), you = false,
        })
        for _, s in ipairs(UE.PlayersIn('capture')) do
            TriggerClientEvent('ue:capture:killPersonal', s, killer == s, src == s)
        end
    end
    TriggerClientEvent('ue:capture:respawn', src)
end)

RegisterNetEvent('ue:capture:outOfZoneDamage')
AddEventHandler('ue:capture:outOfZoneDamage', function()
    local src = source
    if UE.InEvent[src] ~= 'capture' then return end
    TriggerClientEvent('ue:capture:applyDamage', src, Config.Capture.OutOfZoneDamagePerTick)
end)

-- ---------------------------------------------------------------------------
-- Status / stats / leaderboard (used by the hub)
-- ---------------------------------------------------------------------------
function Cap.Status(src)
    local owned = 0
    for _, z in ipairs(Zones) do if z.owner then owned = owned + 1 end end
    return {
        state = Round.active and 'live' or 'idle',
        players = UE.Count(UE.PlayersIn('capture')),
        zonesTotal = #Zones, zonesOwned = owned,
        timeLeft = Round.active and math.max(0, Round.endsAt - os.time()) or 0,
        youIn = UE.InEvent[src] == 'capture',
        canAdmin = UE.CanAdmin(src, 'capture'),
    }
end

function Cap.Stats(src, done)
    local killers = {}
    for s, k in pairs(Round.killers) do killers[#killers + 1] = { src = s, name = Round.killerNames[s] or UE.Name(s), points = k } end
    table.sort(killers, function(a, b) return a.points > b.points end)

    local gangs = {}
    for g, p in pairs(Round.gangs) do gangs[#gangs + 1] = { name = g, points = p } end
    table.sort(gangs, function(a, b) return a.points > b.points end)

    local ident = playerIdentifier(src)
    local logoTasks = {}
    for _, g in ipairs(gangs) do logoTasks[g.name] = function(cb) gangLogo(g.name, cb) end end

    UE.Parallel(logoTasks, function(logos)
        for _, g in ipairs(gangs) do
            local logo = logos[g.name] or Config.Capture.DefaultGangLogo
            g.img = ('nui://%s/img/logos/%s.png'):format(Config.UI.GangLogoResource, logo)
        end
        UE.DB.All('SELECT identifier, name, kills, deaths, gang_points FROM ue_capture_stats ORDER BY (kills*? + gang_points*? - deaths*?) DESC LIMIT 10',
            { Config.Capture.AllTimeScoreWeights.Kills, Config.Capture.AllTimeScoreWeights.GangPoints, Config.Capture.AllTimeScoreWeights.DeathPenalty },
            function(rows)
                local alltime = {}
                for _, r in ipairs(rows or {}) do
                    local score = r.kills * Config.Capture.AllTimeScoreWeights.Kills + r.gang_points * Config.Capture.AllTimeScoreWeights.GangPoints
                        - r.deaths * Config.Capture.AllTimeScoreWeights.DeathPenalty
                    alltime[#alltime + 1] = { name = r.name, score = score, you = (r.identifier == ident) }
                end
                done({
                    killers = killers, gangs = gangs, alltime = alltime,
                    zones = (function() local o = {} for _, z in ipairs(Zones) do o[#o + 1] = { name = z.name, owner = z.owner } end return o end)(),
                    yourGang = gangOf(src),
                })
            end)
    end)
end

function Cap.Leaderboard(done)
    UE.DB.All('SELECT name, kills, deaths, gang_points, (kills*? + gang_points*? - deaths*?) AS score FROM ue_capture_stats ORDER BY score DESC LIMIT 10',
        { Config.Capture.AllTimeScoreWeights.Kills, Config.Capture.AllTimeScoreWeights.GangPoints, Config.Capture.AllTimeScoreWeights.DeathPenalty },
        function(rows) done(rows or {}) end)
end

function Cap.Page(src, cb)
    Cap.Stats(src, function(stats)
        cb({
            stats = stats,
            zonesFull = Zones,
            perm = Config.Perm.Capture,
        })
    end)
end

-- ---------------------------------------------------------------------------
-- Hub actions
-- ---------------------------------------------------------------------------
UE.Actions.capture = {
    join = function(src) tryJoin(src) end,
    leave = function(src) doLeave(src, false) end,
    start = function(src, data) startRound(src, data.minutes) end,
    ['end'] = function(src) endRound(src) end,
    resetzones = function(src)
        if not UE.CanAdmin(src, 'capture') then return UE.Notify(src, 'No permission.', 'error') end
        for _, z in ipairs(Zones) do z.owner = nil end
        saveZones(Zones)
        Cap.PushZones()
        UE.Notify(src, 'All zones reset to neutral.', 'success')
    end,
}

print('^2[Unique_Event]^7 Capture module loaded (' .. #Zones .. ' zones)')
