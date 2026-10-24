-------------------------------------------------------------------
-- GANG WAR (contained gang war over ONE territory zone)
-- ---------------------------------------------------------------
-- Design goals (see Config.ZoneWar):
--   * Contract based: the attacker's boss declares, the defender's boss
--     must accept. Declining/ignoring is free (fee refunded).
--   * Contained: only ROSTERED players score, only INSIDE the zone
--     (+ a small buffer), only for a limited time. Nothing outside the
--     zone is affected, civilians and bystanders never score or lose.
--   * Capped: MaxConcurrentWars server-wide, MaxWarsPerWeek per gang,
--     PairCooldownHours between the same two gangs.
--   * Fair: equal roster sizes (trimmed to the smaller side), same
--     victim only scores once per cooldown, all scoring is decided by
--     the server from server-side positions - not by client claims.
--   * No money printing: both sides pay the fee, a % of the pool burns.
--
-- Plugs into: Territories / CaptureZone (server/territory.lua),
-- AddGangMoney/RemoveGangMoney (server/Gangs.lua), GrantGangXP and
-- GetGangPerk (server/level.lua), SendLog/GetCategoryWebhook.
-------------------------------------------------------------------

if not Config.ZoneWar or not Config.ZoneWar.Enabled then return end

local ZW = Config.ZoneWar

local Wars = {}          -- Wars[id] = war table (see NewWar)
local ZoneWarCache = {}  -- last list broadcast to clients

-------------------------------------------------------------------
-- DB (created automatically so no manual SQL is required)
-------------------------------------------------------------------
MySQL.ready(function()
    MySQL.Async.execute([[
        CREATE TABLE IF NOT EXISTS `gang_wars` (
          `id` int(11) NOT NULL AUTO_INCREMENT,
          `zone_key` varchar(50) NOT NULL,
          `gang_a` varchar(254) NOT NULL,
          `gang_b` varchar(254) NOT NULL,
          `score_a` int(11) DEFAULT 0,
          `score_b` int(11) DEFAULT 0,
          `status` varchar(20) DEFAULT 'pending',
          `fee_a` int(11) DEFAULT 0,
          `fee_b` int(11) DEFAULT 0,
          `created_at` int(255) DEFAULT 0,
          `starts_at` int(255) DEFAULT 0,
          `ends_at` int(255) DEFAULT 0,
          `winner` varchar(254) DEFAULT NULL,
          PRIMARY KEY (`id`),
          KEY `idx_status` (`status`)
        ) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_persian_ci;
    ]], {}, function()
        -- A restart mid-war loses the in-memory war: cancel any
        -- unfinished row and give the entry fees back.
        Wait(8000) -- let Gangs[] finish loading first
        MySQL.Async.fetchAll("SELECT * FROM gang_wars WHERE status IN ('pending','accepted','active')", {}, function(rows)
            for _, row in ipairs(rows or {}) do
                if Gangs and Gangs[row.gang_a] and (row.fee_a or 0) > 0 then AddGangMoney(row.gang_a, row.fee_a) end
                if Gangs and Gangs[row.gang_b] and (row.fee_b or 0) > 0 then AddGangMoney(row.gang_b, row.fee_b) end
                MySQL.Async.execute("UPDATE gang_wars SET status = 'cancelled' WHERE id = @id", { ['@id'] = row.id })
                print(('[Unique_ALLGangs] Gang War #%s was unfinished at restart - cancelled and fees refunded'):format(row.id))
            end
        end)
    end)
end)

-------------------------------------------------------------------
-- Helpers
-------------------------------------------------------------------
local function Notify(src, text, kind)
    TriggerClientEvent(Config.showNotification, src, text, kind or 'info')
end

-- Every war message goes to the gang's CHAT (so nobody misses it) as
-- well as a notification.
local function ChatTo(src, text)
    TriggerClientEvent('chat:addMessage', src, { color = { 255, 60, 60 }, multiline = true, args = { 'GANG WAR', text } })
end

local function NotifyGang(gang, text, kind)
    for _, playerId in ipairs(ESX.GetPlayers()) do
        local x = ESX.GetPlayerFromId(playerId)
        if x and x.gang and x.gang.name == gang then
            Notify(playerId, text, kind)
            ChatTo(playerId, text)
        end
    end
end

local function Advanced(src, title, subtitle, text)
    TriggerClientEvent(Config.showAdvancedNotification, src, title, subtitle, text, 'CHAR_MP_DETONATEPHONE', 9)
end

local function IsBoss(xPlayer)
    if not xPlayer or not xPlayer.gang or xPlayer.gang.name == 'nogang' or not Gangs[xPlayer.gang.name] then return false end
    local grades = Gangs[xPlayer.gang.name].grades
    local lastRank = CountTable(grades)
    local isBoss = xPlayer.gang.grade == lastRank
    local hasAccess = grades[xPlayer.gang.grade] and grades[xPlayer.gang.grade].access and grades[xPlayer.gang.grade].access['bossaction']
    return (isBoss or hasAccess) and true or false
end

local function FeeFor(gang)
    local discount = tonumber(GetGangPerk(gang, 'warFeeDiscount', 0)) or 0
    return math.floor((ZW.DeclareFee or 0) * (1 - math.min(discount, 0.9)))
end

local function RosterMaxFor(gang)
    return tonumber(GetGangPerk(gang, 'warRosterMax', ZW.RosterMax or 8)) or (ZW.RosterMax or 8)
end

local function Dist3(a, b)
    local dx, dy, dz = a.x - b.x, a.y - b.y, a.z - b.z
    return math.sqrt(dx * dx + dy * dy + dz * dz)
end

-- Online members per gang (a gang needs MinOnline() people on to be a target)
local function OnlineCount(gang)
    local n = 0
    for _, playerId in ipairs(ESX.GetPlayers()) do
        local x = ESX.GetPlayerFromId(playerId)
        if x and x.gang and x.gang.name == gang then n = n + 1 end
    end
    return n
end

local function MinOnline()
    return tonumber(ZW.MinOnlineToTarget) or tonumber(ZW.RosterMin) or 3
end

local NO_ZONE_LABEL = 'bedun-e zone (faghat pool)'
local function ZoneLabelOf(war)
    local cfg = war.zoneKey and ZoneConfigByKey[war.zoneKey]
    return cfg and cfg.label or NO_ZONE_LABEL
end

-- What the war is about, written so BOTH gangs see exactly the same thing.
local function StakeText(war)
    if war.zoneKey then
        return ('ZONE: "%s" (agar mohajem bebarad, zone az defender migirad)'):format(ZoneLabelOf(war))
    end
    return 'FAGHAT POOL (zone avaz nemishavad - faghat pool-e pool va XP jabeja mishavad)'
end

local function GangLabel(gang) return (Gangs[gang] and Gangs[gang].label) or gang end

local function PedCoords(src)
    local ped = GetPlayerPed(src)
    if not ped or ped == 0 then return nil end
    return GetEntityCoords(ped)
end

local function InDefaultBucket(src)
    if not GetPlayerRoutingBucket then return true end
    local ok, bucket = pcall(GetPlayerRoutingBucket, src)
    return (not ok) or bucket == nil or bucket == 0
end

local function IsLive(war)
    return war.status == 'pending' or war.status == 'accepted' or war.status == 'gathering' or war.status == 'active'
end

local function WarOfGang(gang)
    for _, war in pairs(Wars) do
        if IsLive(war) and (war.a == gang or war.b == gang) then return war end
    end
    return nil
end

local function WarOnZone(zoneKey)
    for _, war in pairs(Wars) do
        if IsLive(war) and war.zoneKey == zoneKey then return war end
    end
    return nil
end

local function CountRunning()
    local n = 0
    for _, war in pairs(Wars) do
        if war.status == 'accepted' or war.status == 'gathering' or war.status == 'active' then n = n + 1 end
    end
    return n
end

local function SideOf(war, gang)
    if war.a == gang then return 'a' end
    if war.b == gang then return 'b' end
    return nil
end

local function GangOfSide(war, side) return side == 'a' and war.a or war.b end

-- ALLY HELP: a gang's boss can tick "allies may fight for us". When ticked, members of
-- that gang's ALLIES may join its roster for a gang war. Off by default.
AllyHelp = AllyHelp or {}   -- AllyHelp[gang] = true|false
local function AlliedWith(a, b)
    if not a or not b or a == b then return a == b end
    return ((ZW_AreAllied and ZW_AreAllied(a, b)) or false) and true or false
end
-- may a player of gang `pg` fight for war side gang `sg`?
local function MayFightFor(sg, pg)
    if not sg or not pg then return false end
    if pg == sg then return true end
    return AllyHelp[sg] == true and AlliedWith(sg, pg)
end
local function MayFightForSide(war, side, pg) return MayFightFor(GangOfSide(war, side), pg) end

local function WarLog(war, text)
    for _, gang in ipairs({ war.a, war.b }) do
        if Gangs[gang] then
            SendLog({
                playerid = 'SYSTEM', identifier = '-', discord = '-',
                category = 'Territory', Text = ('[Gang War #%s] %s'):format(war.id, text),
                gang = gang, IconURL = Gangs[gang].logo, Webhook = GetCategoryWebhook(gang, 'Territory'),
            })
        end
    end
    if ZW.Webhook and ZW.Webhook ~= '' then
        PerformHttpRequest(ZW.Webhook, function() end, 'POST', json.encode({
            username = 'Gang War',
            embeds = {{ color = 16711680, title = 'Gang War #' .. war.id, description = text }},
        }), { ['Content-Type'] = 'application/json' })
    end
end

local function SaveWar(war)
    MySQL.Async.execute([[
        UPDATE gang_wars SET score_a = @sa, score_b = @sb, status = @st, fee_a = @fa, fee_b = @fb,
        starts_at = @s, ends_at = @e, winner = @w WHERE id = @id
    ]], {
        ['@sa'] = war.scoreA, ['@sb'] = war.scoreB, ['@st'] = war.status,
        ['@fa'] = war.feeA, ['@fb'] = war.feeB, ['@s'] = war.startsAt or 0, ['@e'] = war.endsAt or 0,
        ['@w'] = war.winner, ['@id'] = war.id,
    })
end

-------------------------------------------------------------------
-- Which zones currently have a live (accepted/active) war: every
-- client draws a flashing red blip there so bystanders stay away.
-------------------------------------------------------------------
local function BroadcastZones(target)
    local out = {}
    for _, war in pairs(Wars) do
        if war.status == 'active' then
            local cfg = ZoneConfigByKey[war.zoneKey]
            if cfg then
                out[#out + 1] = {
                    key = war.zoneKey, label = cfg.label,
                    x = cfg.coord.x, y = cfg.coord.y, z = cfg.coord.z, radius = cfg.radius,
                }
            end
        end
    end
    ZoneWarCache = out
    TriggerClientEvent('ZoneWar:Zones', target or -1, out)
end

ESX.RegisterServerCallback('ZoneWar:GetZones', function(source, cb) cb(ZoneWarCache) end)

-------------------------------------------------------------------
-- Per-player HUD data (only rostered players receive it)
-------------------------------------------------------------------
local function BuildHud(war, side)
    local cfg = ZoneConfigByKey[war.zoneKey]
    local mine = side == 'a' and war.scoreA or war.scoreB
    local theirs = side == 'a' and war.scoreB or war.scoreA
    local now = os.time()
    return {
        id = war.id, phase = war.status, label = cfg and cfg.label or war.zoneKey,
        zone = cfg and { x = cfg.coord.x, y = cfg.coord.y, z = cfg.coord.z, radius = cfg.radius } or nil,
        buffer = ZW.ZoneBufferMeters or 15.0,
        mineName = GangOfSide(war, side), oppName = GangOfSide(war, side == 'a' and 'b' or 'a'),
        mine = mine, theirs = theirs, toWin = ZW.ScoreToWin,
        remaining = war.status == 'active' and math.max(0, (war.endsAt or now) - now) or math.max(0, (war.startsAt or now) - now),
        insideMine = war.inside and war.inside[side] or 0,
        insideTheirs = war.inside and war.inside[side == 'a' and 'b' or 'a'] or 0,
    }
end

local function PushHud(war)
    for _, side in ipairs({ 'a', 'b' }) do
        local roster = side == 'a' and war.rosterA or war.rosterB
        for _, src in ipairs(roster) do
            TriggerClientEvent('ZoneWar:Sync', src, BuildHud(war, side))
        end
    end
end

local function ClearHud(war)
    for _, roster in ipairs({ war.rosterA, war.rosterB }) do
        for _, src in ipairs(roster) do
            TriggerClientEvent('ZoneWar:Sync', src, nil)
            TriggerClientEvent('ZoneWar:Gather', src, nil)
        end
    end
end

-------------------------------------------------------------------
-- Arena mode helpers (paintball-style isolated match)
-------------------------------------------------------------------
local function ArenaMode()
    if ZW.Mode ~= 'arena' then return false end
    local res = ZW.Arena and ZW.Arena.Resource
    return res ~= nil and GetResourceState and GetResourceState(res) == 'started'
end

-- Gang HQ = the first Boss Menu marker of the gang (Gangs[g].boss[1].coord).
local function GangHQ(gang)
    local g = Gangs[gang]
    local b = g and g.boss and g.boss[1]
    if b and b.coord and b.coord.x then return b.coord end
    return nil
end

local function NearHQ(src, hq)
    if not hq then return true end -- gang has no HQ marker: nothing to check
    local p = PedCoords(src)
    if not p then return false end
    local dx, dy, dz = p.x - hq.x, p.y - hq.y, p.z - hq.z
    return math.sqrt(dx * dx + dy * dy + dz * dz) <= (ZW.Arena.GatherRadius or 80.0)
end

-------------------------------------------------------------------
-- War lifecycle
-------------------------------------------------------------------
local function Refund(war)
    if war.feeA > 0 and Gangs[war.a] then AddGangMoney(war.a, war.feeA) end
    if war.feeB > 0 and Gangs[war.b] then AddGangMoney(war.b, war.feeB) end
    war.feeA, war.feeB = 0, 0
end

local function EndTerritoryFlags(war)
    local state = Territories[war.zoneKey]
    if state then state.inWar = false end
end

local function CancelWar(war, status, reason)
    if not IsLive(war) then return end
    local wasActive = war.status == 'active' and not war.arena
    war.status = status
    Refund(war)
    EndTerritoryFlags(war)
    SaveWar(war)
    ClearHud(war)
    NotifyGang(war.a, ('Gang War #%s laghv shod: %s (hazine bargasht)'):format(war.id, reason), 'error')
    NotifyGang(war.b, ('Gang War #%s laghv shod: %s (hazine bargasht)'):format(war.id, reason), 'error')
    WarLog(war, 'Cancelled: ' .. reason)
    if wasActive then BroadcastZones() end
end

-- winnerSide: 'a' | 'b' | nil (draw). reason: text for logs.
local function FinishWar(war, winnerSide, reason)
    if war.status ~= 'active' and war.status ~= 'gathering' then return end
    war.status = 'finished'
    local cfg = ZoneConfigByKey[war.zoneKey]
    local state = Territories[war.zoneKey]
    EndTerritoryFlags(war)

    local label = ZoneLabelOf(war)
    local text

    if not winnerSide then
        -- Draw: nobody wins, everybody gets their entry fee back.
        Refund(war)
        war.winner = nil
        text = ('Gang War #%s (%s) mosavi shod (%s-%s) - hazine bargasht'):format(war.id, label, war.scoreA, war.scoreB)
    else
        local winner = GangOfSide(war, winnerSide)
        local loser  = GangOfSide(war, winnerSide == 'a' and 'b' or 'a')
        war.winner = winner

        local pool = war.feeA + war.feeB
        local burn = math.floor(pool * ((ZW.PoolBurnPercent or 0) / 100))
        local prize = pool - burn
        if prize > 0 and Gangs[winner] then AddGangMoney(winner, prize) end
        war.feeA, war.feeB = 0, 0

        local wp = tonumber(ZW.WinnerHeistPoints) or 0
        if wp > 0 then
            pcall(function() exports['Unique_AllRobs']:AddGangHeistPoints(winner, wp, 'Gang War') end)
        end
        if GrantGangXP and Config.GangXP and Config.GangXP.Sources then
            GrantGangXP(winner, Config.GangXP.Sources.warWin, 'Gang War Win')
            GrantGangXP(loser,  Config.GangXP.Sources.warLose, 'Gang War')
        end

        if winnerSide == 'a' then
            -- attacker takes the zone (skipXP: the war XP above already covers it)
            if state and state.owner ~= winner and not ECZone(war.zoneKey) then CaptureZone(war.zoneKey, winner, nil, true) end
        end
        if state and state.owner == winner then
            local now = os.time()
            state.protectedUntil = now + (ZW.WinnerProtectHours or 0) * 3600
            state.warBonusUntil  = now + (ZW.WinnerBonusHours or 0) * 3600
        end

        text = ('Gang War #%s (%s): gang "%s" bord (%s-%s, %s) - jayeze $%s'):format(war.id, label, winner, war.scoreA, war.scoreB, reason or '-', prize)
    end

    SaveWar(war)
    ClearHud(war)
    NotifyGang(war.a, text, 'info')
    NotifyGang(war.b, text, 'info')
    WarLog(war, text)
    BroadcastZones()
    if BroadcastTerritoryState then BroadcastTerritoryState() end
end

local function StartWar(war)
    local state = Territories[war.zoneKey]
    local cfg = ZoneConfigByKey[war.zoneKey]
    if not state or not cfg then return CancelWar(war, 'cancelled', 'zone vojood nadarad') end
    if state.owner ~= war.b then return CancelWar(war, 'cancelled', 'malekiat-e zone avaz shod') end

    -- Keep only players who are still online, still in their gang, and in the normal world.
    local function Valid(side, roster)
        local out = {}
        for _, src in ipairs(roster) do
            local x = ESX.GetPlayerFromId(src)
            if x and x.gang and MayFightForSide(war, side, x.gang.name) and InDefaultBucket(src) then out[#out + 1] = src end
        end
        return out
    end
    local ra, rb = Valid('a', war.rosterA), Valid('b', war.rosterB)
    local n = math.min(#ra, #rb, RosterMaxFor(war.a), RosterMaxFor(war.b))
    if n < (ZW.RosterMin or 3) then
        return CancelWar(war, 'cancelled', ('roster kafi nist (%s/%s)'):format(n, ZW.RosterMin or 3))
    end

    war.rosterA, war.rosterB = {}, {}
    for i = 1, n do
        war.rosterA[i] = ra[i]
        war.rosterB[i] = rb[i]
    end

    local now = os.time()
    war.status = 'active'
    war.startsAt = now
    war.endsAt = now + (ZW.MaxDurationMin or 30) * 60
    war.holdAcc = 0
    war.inside = { a = 0, b = 0 }
    state.inWar = true
    SaveWar(war)

    local msg = ('Gang War #%s shoroo shod! %s vs %s dar "%s" - %s nafar dar har taraf'):format(war.id, war.a, war.b, cfg.label, n)
    for _, roster in ipairs({ war.rosterA, war.rosterB }) do
        for _, src in ipairs(roster) do
            TriggerClientEvent('ZoneWar:Banner', src, 'GANG WAR', cfg.label)
            Advanced(src, '~r~Gang War', '~r~Shoroo shod!', msg)
            ChatTo(src, msg)
        end
    end
    -- the rest of both gangs hears about it too (they just aren't in the roster)
    for _, gang in ipairs({ war.a, war.b }) do
        for _, playerId in ipairs(ESX.GetPlayers()) do
            local x = ESX.GetPlayerFromId(playerId)
            if x and x.gang and x.gang.name == gang then
                local inRoster = false
                for _, r in ipairs(gang == war.a and war.rosterA or war.rosterB) do if r == playerId then inRoster = true end end
                if not inRoster then Notify(playerId, msg .. ' (shoma dar roster nistid)', 'info') ChatTo(playerId, msg .. ' (shoma dar roster nistid)') end
            end
        end
    end
    WarLog(war, msg)
    BroadcastZones()
    PushHud(war)
end

-------------------------------------------------------------------
-- Arena mode: gather at the gang HQ -> isolated paintball match
-------------------------------------------------------------------
local function StartGathering(war)
    local state = war.zoneKey and Territories[war.zoneKey] or nil
    if war.zoneKey then
        if not state or not ZoneConfigByKey[war.zoneKey] then return CancelWar(war, 'cancelled', 'zone vojood nadarad') end
        if state.owner ~= war.b then return CancelWar(war, 'cancelled', 'malekiat-e zone avaz shod') end
    end

    local now = os.time()
    war.status = 'gathering'
    war.arena = true
    war.gatherDeadline = now + (ZW.Arena.GatherSeconds or 180)
    if state then state.inWar = true end -- the zone can't be captured the normal way while the war is being settled
    SaveWar(war)

    local mins = math.ceil((ZW.Arena.GatherSeconds or 180) / 60)
    for side, roster in pairs({ a = war.rosterA, b = war.rosterB }) do
        local gang = GangOfSide(war, side)
        local hq = GangHQ(gang)
        for _, src in ipairs(roster) do
            TriggerClientEvent('ZoneWar:Gather', src, hq and { x = hq.x, y = hq.y, z = hq.z, radius = ZW.Arena.GatherRadius or 80.0 } or nil, mins * 60)
            ChatTo(src, ('Gang War #%s shoroo shod! Shoma dar roster hastid: dar %s daghighe be gang-e khodetan (Boss Menu) bargardid - bad be arena montaghel mishavid.'):format(war.id, mins))
        end
    end
    NotifyGang(war.a, ('Gang War #%s: jangju-ha bayad dar %s daghighe nazdik-e gang bashand'):format(war.id, mins), 'info')
    NotifyGang(war.b, ('Gang War #%s: jangju-ha bayad dar %s daghighe nazdik-e gang bashand'):format(war.id, mins), 'info')
    WarLog(war, ('Gathering started (%s min) - %s vs %s'):format(mins, war.a, war.b))
end

local function ArenaWinnerSide(war, winnerTeam)
    if winnerTeam == 1 then return 'a' end -- team 1 = attacker (teamA)
    if winnerTeam == 2 then return 'b' end
    return nil
end

local function LaunchArena(war, ra, rb)
    local cfg = ZoneConfigByKey[war.zoneKey]
    local maps = ZW.Arena.Maps or {}
    local map = maps[(war.id % math.max(#maps, 1)) + 1]
    if not map then return CancelWar(war, 'cancelled', 'hich map-e arena tarif nashode') end

    local ok, lobbyId, err = pcall(function()
        return exports[ZW.Arena.Resource]:CreateExternalMatch({
            name = 'Gang War', map = map, weapon = ZW.Arena.Weapon, roundNum = ZW.Arena.RoundsToWin,
            rtime = ZW.Arena.RoundSeconds, armor = ZW.Arena.Armor, headbox = ZW.Arena.Headbox,
            teamA = ra, teamB = rb,
            onFinish = 'Unique_ALLGangs:ZoneWarArenaEnd', token = war.id,
        })
    end)
    if not ok or not lobbyId then
        return CancelWar(war, 'cancelled', 'arena sakhte nashod (' .. tostring(not ok and lobbyId or err) .. ')')
    end

    war.rosterA, war.rosterB = ra, rb
    war.lobbyId = lobbyId
    war.map = map
    war.status = 'active'
    war.startsAt = os.time()
    war.endsAt = war.startsAt + (ZW.Arena.MaxMatchMinutes or 25) * 60
    SaveWar(war)

    local msg = ('Gang War #%s: %s vs %s - %s nafar dar har taraf, arena "%s", avvalin tim ke %s round bebarad zone ro migirad.'):format(war.id, war.a, war.b, #ra, map, ZW.Arena.RoundsToWin or 3)
    for _, roster in ipairs({ ra, rb }) do
        for _, src in ipairs(roster) do
            TriggerClientEvent('ZoneWar:Gather', src, nil)
            ChatTo(src, msg)
        end
    end
    WarLog(war, msg)
end

local function ResolveGathering(war)
    local function Present(side, roster)
        local out, hq = {}, GangHQ(GangOfSide(war, side))
        for _, src in ipairs(roster) do
            local x = ESX.GetPlayerFromId(src)
            if x and x.gang and MayFightForSide(war, side, x.gang.name) and InDefaultBucket(src) and NearHQ(src, hq) then
                out[#out + 1] = src
            end
        end
        return out
    end
    local pa, pb = Present('a', war.rosterA), Present('b', war.rosterB)
    local min = ZW.RosterMin or 3
    local okA, okB = #pa >= min, #pb >= min

    if not okA and not okB then
        return CancelWar(war, 'cancelled', ('hich tarafi roster-e kafi dar gang nadasht (%s/%s, %s/%s)'):format(#pa, min, #pb, min))
    elseif not okA then
        for _, src in ipairs(war.rosterB) do ChatTo(src, 'Harif dar mohlat nayamad - shoma bordid (no-show).') end
        war.scoreA, war.scoreB = 0, 0
        return FinishWar(war, 'b', 'no-show')
    elseif not okB then
        for _, src in ipairs(war.rosterA) do ChatTo(src, 'Harif dar mohlat nayamad - shoma bordid (no-show).') end
        war.scoreA, war.scoreB = 0, 0
        return FinishWar(war, 'a', 'no-show')
    end

    local n = math.min(#pa, #pb, RosterMaxFor(war.a), RosterMaxFor(war.b))
    local ra, rb = {}, {}
    for i = 1, n do ra[i] = pa[i]; rb[i] = pb[i] end
    LaunchArena(war, ra, rb)
end

AddEventHandler('Unique_ALLGangs:ZoneWarArenaEnd', function(token, winnerTeam, info)
    local war = Wars[tonumber(token) or -1]
    if not war or war.status ~= 'active' or not war.arena then return end
    local rounds = info and info.rounds or { 0, 0 }
    war.scoreA, war.scoreB = tonumber(rounds[1]) or 0, tonumber(rounds[2]) or 0
    local side = (info and info.forced) and nil or ArenaWinnerSide(war, winnerTeam)
    FinishWar(war, side, side and 'arena' or 'time')
end)

-------------------------------------------------------------------
-- Scoring
-------------------------------------------------------------------
local function Multiplier()
    if ZW.WarNightMultiplier and ZW.WarNightMultiplier > 1 and ZW_IsWarNight and ZW_IsWarNight() then
        return ZW.WarNightMultiplier
    end
    return 1
end

local function AddPoints(war, side, pts)
    pts = pts * Multiplier()
    if side == 'a' then war.scoreA = war.scoreA + pts else war.scoreB = war.scoreB + pts end
end

local function OnRoster(war, src)
    for i, r in ipairs(war.rosterA) do if r == src then return 'a' end end
    for i, r in ipairs(war.rosterB) do if r == src then return 'b' end end
    return nil
end

-- esx:onPlayerDeath is a net event the (victim's) client fires with who
-- killed it. The client claim alone never scores: everything below is
-- re-checked from server-side state (rosters, positions, buckets).
AddEventHandler('esx:onPlayerDeath', function(data)
    local victim = source
    if type(data) ~= 'table' or not data.killedByPlayer then return end
    local killer = tonumber(data.killerServerId or data.killer)
    if not killer or killer == victim then return end

    for _, war in pairs(Wars) do
        if war.status == 'active' and not war.arena then
            local vSide, kSide = OnRoster(war, victim), OnRoster(war, killer)
            if vSide and kSide and vSide ~= kSide then
                local cfg = ZoneConfigByKey[war.zoneKey]
                local vp, kp = PedCoords(victim), PedCoords(killer)
                if cfg and vp and kp and InDefaultBucket(victim) and InDefaultBucket(killer) then
                    local reach = cfg.radius + (ZW.ZoneBufferMeters or 15.0)
                    if Dist3(vp, cfg.coord) <= reach and Dist3(kp, cfg.coord) <= reach
                    and Dist3(vp, kp) <= (ZW.MaxKillDistance or 400.0) then
                        local now = os.time()
                        war.victimCd = war.victimCd or {}
                        if (war.victimCd[victim] or 0) + (ZW.SameVictimCooldownSec or 180) <= now then
                            war.victimCd[victim] = now
                            local pts = ZW.KillPoints or 1
                            local vx = ESX.GetPlayerFromId(victim)
                            if vx and IsBoss(vx) then pts = ZW.LeaderKillPoints or pts end
                            AddPoints(war, kSide, pts)
                            PushHud(war)
                            if war.scoreA >= ZW.ScoreToWin or war.scoreB >= ZW.ScoreToWin then
                                FinishWar(war, war.scoreA >= ZW.ScoreToWin and 'a' or 'b', 'score')
                            end
                        end
                    end
                end
            end
        end
    end
end)

AddEventHandler('playerDropped', function()
    local src = source
    for _, war in pairs(Wars) do
        if war.status == 'accepted' then
            for _, roster in ipairs({ war.rosterA, war.rosterB }) do
                for i = #roster, 1, -1 do if roster[i] == src then table.remove(roster, i) end end
            end
        end
    end
end)

-------------------------------------------------------------------
-- Main tick (default every 5s): expiry, start, hold points, end checks.
-------------------------------------------------------------------
local function TickWar(war, now)
    if war.status == 'pending' then
        if now >= war.acceptDeadline then CancelWar(war, 'expired', 'defender jaavab nadad') end
        return
    end

    if war.status == 'accepted' then
        if now >= war.startsAt then
            if ArenaMode() then StartGathering(war) else StartWar(war) end
        end
        return
    end

    if war.status == 'gathering' then
        -- go as soon as both rosters are fully at their HQ, otherwise at the deadline
        local function AllHere(side, roster)
            local hq = GangHQ(GangOfSide(war, side))
            for _, src in ipairs(roster) do
                local x = ESX.GetPlayerFromId(src)
                if not (x and MayFightForSide(war, side, x.gang and x.gang.name) and InDefaultBucket(src) and NearHQ(src, hq)) then return false end
            end
            return #roster > 0
        end
        if now >= war.gatherDeadline or (AllHere('a', war.rosterA) and AllHere('b', war.rosterB)) then
            ResolveGathering(war)
        end
        return
    end

    if war.status ~= 'active' then return end

    if war.arena then
        -- the paintball resource reports the result; this is only a failsafe
        if now >= war.endsAt then
            pcall(function() exports[ZW.Arena.Resource]:EndExternalMatch(war.lobbyId, nil) end)
            if war.status == 'active' then FinishWar(war, nil, 'time') end
        end
        return
    end
    local cfg = ZoneConfigByKey[war.zoneKey]
    if not cfg then return FinishWar(war, nil, 'zone') end
    local reach = cfg.radius -- holding the point needs the real zone, not the buffer

    local online = { a = 0, b = 0 }
    war.inside = { a = 0, b = 0 }
    for side, roster in pairs({ a = war.rosterA, b = war.rosterB }) do
        for _, src in ipairs(roster) do
            local x = ESX.GetPlayerFromId(src)
            if x and x.gang and MayFightForSide(war, side, x.gang.name) then
                online[side] = online[side] + 1
                local p = PedCoords(src)
                if p and InDefaultBucket(src) and Dist3(p, cfg.coord) <= reach then
                    war.inside[side] = war.inside[side] + 1
                end
            end
        end
    end

    -- A side with nobody online for too long forfeits.
    for _, side in ipairs({ 'a', 'b' }) do
        local key = 'empty' .. side
        if online[side] == 0 then
            war[key] = war[key] or now
            if now - war[key] >= (ZW.ForfeitIfEmptySeconds or 180) then
                return FinishWar(war, side == 'a' and 'b' or 'a', 'forfeit')
            end
        else
            war[key] = nil
        end
    end

    war.holdAcc = (war.holdAcc or 0) + (ZW.TickSeconds or 5)
    if war.holdAcc >= (ZW.HoldPointEverySec or 60) then
        war.holdAcc = 0
        if war.inside.a > war.inside.b then AddPoints(war, 'a', 1)
        elseif war.inside.b > war.inside.a then AddPoints(war, 'b', 1) end
    end

    if war.scoreA >= ZW.ScoreToWin or war.scoreB >= ZW.ScoreToWin then
        return FinishWar(war, war.scoreA >= ZW.ScoreToWin and 'a' or 'b', 'score')
    end
    if now >= war.endsAt then
        if war.scoreA == war.scoreB then return FinishWar(war, nil, 'time') end
        return FinishWar(war, war.scoreA > war.scoreB and 'a' or 'b', 'time')
    end

    PushHud(war)
end

CreateThread(function()
    while true do
        Wait((ZW.TickSeconds or 5) * 1000)
        local now = os.time()
        for _, war in pairs(Wars) do TickWar(war, now) end
        -- drop finished wars from memory after a while
        for id, war in pairs(Wars) do
            if not IsLive(war) and now - (war.createdAt or 0) > 7200 then Wars[id] = nil end
        end
    end
end)

-------------------------------------------------------------------
-- Declare / respond / roster / surrender
-------------------------------------------------------------------
local function CheckWeeklyAndPair(a, b, cb)
    local weekAgo = os.time() - 7 * 86400
    local pairSince = os.time() - (ZW.PairCooldownHours or 48) * 3600
    MySQL.Async.fetchAll([[
        SELECT
          (SELECT COUNT(*) FROM gang_wars WHERE (gang_a = @a OR gang_b = @a) AND created_at >= @week AND status IN ('accepted','active','finished')) AS wa,
          (SELECT COUNT(*) FROM gang_wars WHERE (gang_a = @b OR gang_b = @b) AND created_at >= @week AND status IN ('accepted','active','finished')) AS wb,
          (SELECT COUNT(*) FROM gang_wars WHERE ((gang_a = @a AND gang_b = @b) OR (gang_a = @b AND gang_b = @a)) AND created_at >= @pair AND status IN ('accepted','active','finished')) AS wp
    ]], { ['@a'] = a, ['@b'] = b, ['@week'] = weekAgo, ['@pair'] = pairSince }, function(rows)
        local r = rows and rows[1] or { wa = 0, wb = 0, wp = 0 }
        local max = ZW.MaxWarsPerWeek or 2
        if (r.wa or 0) >= max then return cb(false, 'Gang-e shoma be saghf-e jang-haye hafteh residan') end
        if (r.wb or 0) >= max then return cb(false, 'Gang-e hadaf be saghf-e jang-haye hafteh reside') end
        if (r.wp or 0) > 0 then return cb(false, 'In dou gang dar ' .. (ZW.PairCooldownHours or 48) .. ' saat-e akhir jang kardand') end
        cb(true)
    end)
end

-- Declare a war on a GANG (picked from the list of gangs that have enough
-- people online). `zoneKey` is optional: one of the target's zones as the
-- stake (the zone changes hands if the attacker wins), or nil for a
-- money-only war (the prize pool is the stake).
ESX.RegisterServerCallback('ZoneWar:Declare', function(source, cb, targetGang, zoneKey)
    local xPlayer = ESX.GetPlayerFromId(source)
    if not IsBoss(xPlayer) then return cb(false, 'Faghat boss mitoone jang elam kone') end
    local a = xPlayer.gang.name

    local b = targetGang
    if type(b) ~= 'string' or b == 'nogang' or b == a or not Gangs[b] then return cb(false, 'Gang-e hadaf namo`tabar') end
    if ZW_AreAllied and ZW_AreAllied(a, b) then return cb(false, 'Hampeyman nemitooni jang elam koni') end
    if WarOfGang(a) then return cb(false, 'Shoma ghablan dar yek jang hastid') end
    if WarOfGang(b) then return cb(false, 'Gang-e hadaf dar yek jang digar ast') end
    if CountRunning() >= (ZW.MaxConcurrentWars or 2) then return cb(false, 'Server por ast - baadan emtehan konid') end

    local minOnline = MinOnline()
    if OnlineCount(a) < minOnline then return cb(false, ('Gang-e shoma hadaghal %s nafar online lazem darad'):format(minOnline)) end
    if OnlineCount(b) < minOnline then return cb(false, ('Gang-e hadaf hadaghal %s nafar online nadarad'):format(minOnline)) end

    -- optional zone stake
    local cfg, state
    if zoneKey ~= nil and zoneKey ~= '' then
        cfg, state = ZoneConfigByKey[zoneKey], Territories[zoneKey]
        if type(zoneKey) ~= 'string' or not cfg or not state or cfg.bossZone then return cb(false, 'Zone-e namo`tabar') end
        if state.owner ~= b then return cb(false, 'In zone male gang-e hadaf nist') end
        if state.inWar or WarOnZone(zoneKey) then return cb(false, 'Rooye in zone ghablan jang hast') end
        if state.protectedUntil and state.protectedUntil > os.time() then return cb(false, 'In zone dar hale mohafezat ast') end
        local maxZones = tonumber(GetGangPerk(a, 'maxZones', Config.Territory.MaxZonesPerGang or 999)) or 999
        if CountGangZones(a) >= maxZones then return cb(false, 'Be saghf-e zone resideid - ye zone ro ragha konid ya bedun-e zone jang konid') end
    else
        zoneKey = nil
        if not ArenaMode() then return cb(false, 'Dar in halat bayad yek zone entekhab shavad') end
    end

    local fee = FeeFor(a)
    if GetMoneyOfGang(a) < fee then return cb(false, 'Pool-e tamiz-e gang kafi nist (niaz: $' .. fee .. ')') end

    CheckWeeklyAndPair(a, b, function(ok, msg)
        if not ok then return cb(false, msg) end
        -- state may have changed while the DB query ran: re-check the important parts
        if WarOfGang(a) or WarOfGang(b) or (zoneKey and (WarOnZone(zoneKey) or (Territories[zoneKey] and Territories[zoneKey].owner ~= b))) then
            return cb(false, 'Vaziat taghir kard - dobare emtehan konid')
        end
        if not RemoveGangMoney(a, fee) then return cb(false, 'Pool-e tamiz-e gang kafi nist') end

        local now = os.time()
        MySQL.Async.insert([[
            INSERT INTO gang_wars (zone_key, gang_a, gang_b, status, fee_a, fee_b, created_at)
            VALUES (@z, @a, @b, 'pending', @fa, 0, @t)
        ]], { ['@z'] = zoneKey or '', ['@a'] = a, ['@b'] = b, ['@fa'] = fee, ['@t'] = now }, function(id)
            local war = {
                id = id or (now * 10 + math.random(0, 9)), zoneKey = zoneKey, a = a, b = b, status = 'pending',
                createdAt = now, acceptDeadline = now + (ZW.AcceptWindowMin or 10) * 60,
                scoreA = 0, scoreB = 0, feeA = fee, feeB = 0,
                rosterA = {}, rosterB = {}, victimCd = {},
            }
            Wars[war.id] = war
            local stake = StakeText(war)
            local la, lb = GangLabel(a), GangLabel(b)
            local rules = ZW.Mode == 'arena' and ArenaMode() and (' Format: arena-e paintball, avvalin tim ke %s round bebarad.'):format(ZW.Arena.RoundsToWin or 3) or ''
            WarLog(war, ('%s elam-e jang kard be %s - %s (hazine $%s)'):format(a, b, stake, fee))
            local incoming = ('Gang "%s" be gang-e shoma elam-e jang kard!  Noe-e jang: %s.%s Hazine: $%s az khazane-ye har dou taraf. Boss: Boss Menu > Gang War baraye ghabool ya rad (%s daghighe mohlat).'):format(la, stake, rules, FeeFor(b), ZW.AcceptWindowMin or 10)
            for _, playerId in ipairs(ESX.GetPlayers()) do
                local x = ESX.GetPlayerFromId(playerId)
                if x and x.gang and x.gang.name == b then
                    ChatTo(playerId, incoming)
                    if IsBoss(x) then Advanced(playerId, '~r~Gang War', '~r~Elam-e jang!', incoming) end
                elseif x and x.gang and x.gang.name == a then
                    ChatTo(playerId, ('Gang-e shoma be "%s" elam-e jang kard. Noe-e jang: %s. Montazer-e pasokh (%s daghighe).'):format(lb, stake, ZW.AcceptWindowMin or 10))
                end
            end
            cb(true, ('Jang elam shod - montazer-e pasokh-e "%s" bash (%s daghighe)'):format(lb, ZW.AcceptWindowMin or 10))
        end)
    end)
end)

ESX.RegisterServerCallback('ZoneWar:Respond', function(source, cb, warId, accept)
    local xPlayer = ESX.GetPlayerFromId(source)
    if not IsBoss(xPlayer) then return cb(false, 'Faghat boss') end
    local war = Wars[tonumber(warId) or -1]
    if not war or war.status ~= 'pending' or war.b ~= xPlayer.gang.name then return cb(false, 'Jang-e moatabar peyda nashod') end
    if os.time() >= war.acceptDeadline then CancelWar(war, 'expired', 'mohlat tamam shod') return cb(false, 'Mohlat tamam shode') end

    if not accept then
        CancelWar(war, 'declined', 'defender rad kard')
        return cb(true, 'Jang rad shod')
    end

    if CountRunning() >= (ZW.MaxConcurrentWars or 2) then return cb(false, 'Server por ast - baadan emtehan konid') end
    if war.zoneKey then
        local state = Territories[war.zoneKey]
        if not state or state.owner ~= war.b then CancelWar(war, 'cancelled', 'malekiat-e zone avaz shod') return cb(false, 'Zone dige male shoma nist') end
    end

    CheckWeeklyAndPair(war.a, war.b, function(ok, msg)
        if not ok then return cb(false, msg) end
        if war.status ~= 'pending' then return cb(false, 'Jang dige moatabar nist') end
        local fee = FeeFor(war.b)
        if not RemoveGangMoney(war.b, fee) then return cb(false, 'Pool-e tamiz-e gang kafi nist (niaz: $' .. fee .. ')') end
        war.feeB = fee
        war.status = 'accepted'
        war.startsAt = os.time() + (ZW.StartDelayMin or 15) * 60
        SaveWar(war)
        local text = ('Jang ghabool shod! Noe-e jang: ' .. StakeText(war) .. ' - shoroo %s daghighe digar. Boss ha az Boss Menu > Gang War > Roster, %s ta %s nafar ro entekhab konand.'):format(ZW.StartDelayMin or 15, ZW.RosterMin or 3, ZW.RosterMax or 8)
        NotifyGang(war.a, text, 'success')
        NotifyGang(war.b, text, 'success')
        WarLog(war, ('%s jang ro ghabool kard'):format(war.b))
        cb(true, 'Jang ghabool shod')
    end)
end)

-- Online members of the boss's gang, with whether each is on the roster.
ESX.RegisterServerCallback('ZoneWar:GetMembers', function(source, cb)
    local xPlayer = ESX.GetPlayerFromId(source)
    if not IsBoss(xPlayer) then return cb({}) end
    local gang = xPlayer.gang.name
    local war = WarOfGang(gang)
    local side = war and SideOf(war, gang)
    local roster = war and (side == 'a' and war.rosterA or war.rosterB) or {}
    local out = {}
    for _, playerId in ipairs(ESX.GetPlayers()) do
        local x = ESX.GetPlayerFromId(playerId)
        if x and x.gang and MayFightFor(gang, x.gang.name) then
            local inRoster = false
            for _, r in ipairs(roster) do if r == playerId then inRoster = true end end
            out[#out + 1] = { src = playerId, name = x.name or ('ID ' .. playerId), inRoster = inRoster,
                              gang = x.gang.name, fromAlly = x.gang.name ~= gang }
        end
    end
    cb(out)
end)

-- The BOSS picks who fights (add = true/false). Only possible between
-- accept and start; the roster is locked once the war begins.
ESX.RegisterServerCallback('ZoneWar:Roster', function(source, cb, targetSrc, add)
    local xPlayer = ESX.GetPlayerFromId(source)
    if not IsBoss(xPlayer) then return cb(false, 'Faghat boss mitoone roster ro tanzim kone') end
    local gang = xPlayer.gang.name
    local war = WarOfGang(gang)
    if not war or war.status ~= 'accepted' then return cb(false, 'Jang-e dar hale amade-sazi nist') end

    local target = tonumber(targetSrc)
    local tx = target and ESX.GetPlayerFromId(target)
    if not tx or not tx.gang or not MayFightFor(gang, tx.gang.name) then return cb(false, 'In bazikon ozv-e gang-e shoma (ya motahed-e tik-dar) nist ya online nist') end

    local side = SideOf(war, gang)
    local roster = side == 'a' and war.rosterA or war.rosterB
    local idx
    for i, r in ipairs(roster) do if r == target then idx = i end end

    if add then
        if idx then return cb(false, 'Ghablan dar roster hast') end
        if #roster >= RosterMaxFor(gang) then return cb(false, 'Roster por ast (' .. RosterMaxFor(gang) .. ')') end
        if not InDefaultBucket(target) then return cb(false, 'In bazikon dar halat-e event ast') end
        roster[#roster + 1] = target
        ChatTo(target, 'Shoma ba entekhab-e boss dar roster-e Gang War ghararid gereftid. Be zone bar-gardid ghabl az shoroo.')
        return cb(true, ('Ezafe shod (%s/%s)'):format(#roster, RosterMaxFor(gang)))
    else
        if not idx then return cb(false, 'Dar roster nist') end
        table.remove(roster, idx)
        ChatTo(target, 'Shoma az roster-e Gang War hazf shodid.')
        return cb(true, 'Hazf shod')
    end
end)

ESX.RegisterServerCallback('ZoneWar:Surrender', function(source, cb)
    local xPlayer = ESX.GetPlayerFromId(source)
    if not IsBoss(xPlayer) then return cb(false, 'Faghat boss') end
    local war = WarOfGang(xPlayer.gang.name)
    if not war or war.status ~= 'active' then return cb(false, 'Jang-e faal nist') end
    local side = SideOf(war, xPlayer.gang.name)
    FinishWar(war, side == 'a' and 'b' or 'a', 'surrender')
    cb(true, 'Taslim shodid')
end)

-------------------------------------------------------------------
-- Menu data for the client
-------------------------------------------------------------------
ESX.RegisterServerCallback('ZoneWar:GetMenu', function(source, cb)
    local xPlayer = ESX.GetPlayerFromId(source)
    if not xPlayer or not xPlayer.gang or xPlayer.gang.name == 'nogang' or not Gangs[xPlayer.gang.name] then
        return cb({ hasGang = false })
    end
    local gang = xPlayer.gang.name
    local boss = IsBoss(xPlayer)
    local now = os.time()
    local out = {
        hasGang = true, gang = gang, isBoss = boss, fee = FeeFor(gang),
        allyHelp = AllyHelp[gang] == true,
        rosterMax = RosterMaxFor(gang), rosterMin = ZW.RosterMin,
        scoreToWin = ZW.ScoreToWin, durationMin = ZW.MaxDurationMin, startDelayMin = ZW.StartDelayMin,
        mode = ArenaMode() and 'arena' or 'zone',
        busy = CountRunning() >= (ZW.MaxConcurrentWars or 2),
    }

    local war = WarOfGang(gang)
    if war then
        local side = SideOf(war, gang)
        local cfg = ZoneConfigByKey[war.zoneKey]
        local roster = side == 'a' and war.rosterA or war.rosterB
        local inRoster = false
        for _, r in ipairs(roster) do if r == source then inRoster = true end end
        out.war = {
            id = war.id, status = war.status, zone = ZoneLabelOf(war), stake = StakeText(war), hasZone = war.zoneKey ~= nil,
            role = side == 'a' and 'attacker' or 'defender',
            opponent = GangOfSide(war, side == 'a' and 'b' or 'a'),
            mine = side == 'a' and war.scoreA or war.scoreB,
            theirs = side == 'a' and war.scoreB or war.scoreA,
            rosterMine = #roster,
            inRoster = inRoster,
            secondsToAccept = war.status == 'pending' and math.max(0, war.acceptDeadline - now) or nil,
            secondsToStart  = war.status == 'accepted' and math.max(0, war.startsAt - now) or nil,
            secondsToGather = war.status == 'gathering' and math.max(0, (war.gatherDeadline or now) - now) or nil,
            arena = war.arena and true or false, map = war.map,
            secondsLeft     = war.status == 'active' and math.max(0, war.endsAt - now) or nil,
        }
    elseif boss then
        -- Targets are GANGS with enough people online right now.
        out.targets = {}
        local minOnline = MinOnline()
        local online = {}
        for _, playerId in ipairs(ESX.GetPlayers()) do
            local x = ESX.GetPlayerFromId(playerId)
            if x and x.gang and x.gang.name ~= 'nogang' then online[x.gang.name] = (online[x.gang.name] or 0) + 1 end
        end
        out.myOnline, out.minOnline = online[gang] or 0, minOnline

        for g, n in pairs(online) do
            if g ~= gang and Gangs[g] and n >= minOnline then
                local reason
                if ZW_AreAllied and ZW_AreAllied(gang, g) then reason = 'hampeyman'
                elseif WarOfGang(g) then reason = 'dar jang' end

                local zones = {}
                for key, state in pairs(Territories) do
                    local zcfg = ZoneConfigByKey[key]
                    if zcfg and not zcfg.bossZone and state.owner == g then
                        local zr
                        if state.inWar or WarOnZone(key) then zr = 'dar jang'
                        elseif state.protectedUntil and state.protectedUntil > now then zr = 'mohafezat' end
                        zones[#zones + 1] = { key = key, label = zcfg.label, tier = zcfg.tier, reason = zr }
                    end
                end
                table.sort(zones, function(x, y) return x.label < y.label end)
                out.targets[#out.targets + 1] = { gang = g, label = GangLabel(g), online = n, reason = reason, zones = zones }
            end
        end
        table.sort(out.targets, function(x, y)
            if x.online ~= y.online then return x.online > y.online end
            return x.gang < y.gang
        end)
    end

    -- incoming declaration for this gang's boss
    if boss then
        for _, w in pairs(Wars) do
            if w.status == 'pending' and w.b == gang then
                local cfg = ZoneConfigByKey[w.zoneKey]
                out.incoming = {
                    id = w.id, from = GangLabel(w.a), zone = ZoneLabelOf(w), stake = StakeText(w), hasZone = w.zoneKey ~= nil, rounds = ZW.Arena and ZW.Arena.RoundsToWin or nil,
                    secondsLeft = math.max(0, w.acceptDeadline - now), fee = FeeFor(gang),
                }
                break
            end
        end
    end
    cb(out)
end)

-------------------------------------------------------------------
-- Admin: /endwar <id>  (cancels + refunds both sides)
-------------------------------------------------------------------
RegisterCommand(ZW.AdminEndCommand or 'endwar', function(source, args)
    if source ~= 0 and not IsPlayerCanOpenPanel(source) then return end
    local war = Wars[tonumber(args[1]) or -1]
    local reply = function(msg)
        if source == 0 then print('[Unique_ALLGangs] ' .. msg) else Notify(source, msg, 'info') end
    end
    if not war or not IsLive(war) then return reply('Jang-e faal ba in shenase peyda nashod') end
    CancelWar(war, 'cancelled', 'admin laghv kard')
    reply(('Gang War #%s laghv shod'):format(war.id))
end, false)

AddEventHandler('onResourceStop', function(res)
    if res ~= GetCurrentResourceName() then return end
    for _, war in pairs(Wars) do
        if IsLive(war) then
            -- DB refund happens on next start (see MySQL.ready above); just free the zone flag
            local s = Territories[war.zoneKey]
            if s then s.inWar = false end
        end
    end
end)

-- Boss ticks / unticks "allies may fight for us" (saved in memory; resets on restart).
ESX.RegisterServerCallback('ZoneWar:SetAllyHelp', function(source, cb, enabled)
    local xPlayer = ESX.GetPlayerFromId(source)
    if not IsBoss(xPlayer) then return cb(false, 'Faghat boss mitoone in tik ro bezanad') end
    AllyHelp[xPlayer.gang.name] = enabled == true
    cb(true, AllyHelp[xPlayer.gang.name] and 'Komak-e motahedin faal shod' or 'Komak-e motahedin khamoosh shod')
end)
