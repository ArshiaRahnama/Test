ESX = nil
TriggerEvent(Config.ESX, function(obj) ESX = obj end)

local Event = false
local StartMatch = false 
local Lobbey = false 
local Alive = 0
local Prisoner = 0
local Body = 0
local Squads = {}
local SquadAlive = 0 
local SquadCount = 1
local Team = 1 
local Players = {}
local WzVehs = {}
local Spectators = {} -- source IDs currently in spectator mode (eliminated, squad still alive)
local CurrentSeason = 1
local MatchStartedAt = 0
local MatchStartCount = 0
-- Party system: PartyLeader[source] = leaderSource (a solo player is their
-- own leader). PartyMembers[leaderSource] = {member source ids}.
-- PendingInvites[targetSource] = leaderSource (one pending invite at a time).
local PartyLeader = {}
local PartyMembers = {}
local PendingInvites = {}
-- Match Replay: running log of this match's events, saved to DB on end.
local MatchLog = {}
local MatchId = 0
local CurrentMatchMap = ''
-- Killstreak rewards + On Fire highlight
local KillStreak = {}      -- [source] = consecutive kills (no death) this match
local RecentKillTimes = {} -- [source] = {timestamp, timestamp, ...} for On Fire detection
-- Golden Crate keys (in-memory, per match, like MyCash on the client)
local PlayerKeys = {}       -- [source] = number of keys held
-- Expansion: Server-Authoritative Economy -- WzCash used to live only on
-- the client with the whole shop flow running there too, trivially
-- cheatable. This table is now the real source of truth; the client HUD
-- just mirrors AWZ:SyncCash.
local PlayerCash = {}       -- [source] = current match WzCash
-- Expansion: Vehicle Loot -- car keys, same in-memory-per-match pattern as PlayerKeys
local CarKeys = {}          -- [source] = number of car keys held
-- Expansion: Team-Size / Map Vote -- collected while Lobbey is open, tallied by AutoQueueWatch
local ModeVotes = {}        -- [source] = 1..4
local MapVotes = {}         -- [source] = 'SANDY' | 'ISLAND'
-- Expansion: Custom Loadout Drop -- picked in the lobby, applied on AWZ:StartMatch
local PlayerLoadout = {}    -- [source] = Config.CustomLoadout.options entry
-- Expansion: Pre-Match Contract -- picked in the lobby, checked on death/win
local PlayerContract = {}   -- [source] = Config.PreMatchContract.options entry
local ContractStreak = {}   -- [source] = current no-death kill streak this match (for the 'streak' contract stat)
-- Expansion: Reboot Van -- players currently eliminated-but-recoverable via the van (squad matches only)
local AwaitingReboot = {}   -- [source] = true

-------------------------------------------------------------------
-- Leaderboard (Season) -- table is per-identifier/per-season, so a
-- season reset never deletes history, it just starts a new season id.
-------------------------------------------------------------------
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
    -- Migration: this table already existed on some installs from before
    -- the `deaths` column (and /wzstats) were added -- CREATE TABLE IF NOT
    -- EXISTS does nothing to an existing table, so add the column here if
    -- it's missing. If your MySQL/MariaDB version doesn't support
    -- "ADD COLUMN IF NOT EXISTS", oxmysql will just print its own error to
    -- console here -- harmless, and everything else still starts fine.
    MySQL.Async.execute([[
        ALTER TABLE `wz_leaderboard` ADD COLUMN IF NOT EXISTS `deaths` INT NOT NULL DEFAULT 0
    ]], {})
    -- Feature: Match Replay -- one row per finished match with a JSON blob
    -- of its event log, so /wzlastmatch can show a summary later.
    MySQL.Async.execute([[
        CREATE TABLE IF NOT EXISTS `wz_match_history` (
            `id` INT NOT NULL AUTO_INCREMENT,
            `ended_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
            `map` VARCHAR(20) NOT NULL DEFAULT '',
            `player_count` INT NOT NULL DEFAULT 0,
            `winners` VARCHAR(255) NOT NULL DEFAULT '',
            `summary` TEXT,
            PRIMARY KEY (`id`)
        )
    ]], {})
    -- Expansion: Persistent Rank (XP that never resets, separate from the seasonal leaderboard)
    MySQL.Async.execute([[
        CREATE TABLE IF NOT EXISTS `wz_rank` (
            `identifier` VARCHAR(60) NOT NULL,
            `xp` INT NOT NULL DEFAULT 0,
            PRIMARY KEY (`identifier`)
        )
    ]], {})
    -- Expansion: WZCoins (persistent currency spent in the Cosmetic Shop / earned via Battle Pass)
    MySQL.Async.execute([[
        CREATE TABLE IF NOT EXISTS `wz_currency` (
            `identifier` VARCHAR(60) NOT NULL,
            `coins` INT NOT NULL DEFAULT 0,
            PRIMARY KEY (`identifier`)
        )
    ]], {})
    -- Expansion: owned Cosmetic Shop items
    MySQL.Async.execute([[
        CREATE TABLE IF NOT EXISTS `wz_cosmetics` (
            `identifier` VARCHAR(60) NOT NULL,
            `item` VARCHAR(60) NOT NULL,
            PRIMARY KEY (`identifier`, `item`)
        )
    ]], {})
    -- Expansion: Battle Pass daily challenge progress (one row per player per day)
    MySQL.Async.execute([[
        CREATE TABLE IF NOT EXISTS `wz_battlepass` (
            `identifier` VARCHAR(60) NOT NULL,
            `day` VARCHAR(10) NOT NULL,
            `kills` INT NOT NULL DEFAULT 0,
            `wins` INT NOT NULL DEFAULT 0,
            `claimed` TEXT NOT NULL DEFAULT '',
            PRIMARY KEY (`identifier`, `day`)
        )
    ]], {})
    -- Expansion: player reports, reachable from the /warzone menu
    MySQL.Async.execute([[
        CREATE TABLE IF NOT EXISTS `wz_reports` (
            `id` INT NOT NULL AUTO_INCREMENT,
            `reporter` VARCHAR(100) NOT NULL,
            `reported` VARCHAR(100) NOT NULL,
            `reason` VARCHAR(255) NOT NULL,
            `created_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
            PRIMARY KEY (`id`)
        )
    ]], {})
end)

function WZ_AddStat(identifier, name, kills, wins, deaths)
    if not identifier then return end
    deaths = deaths or 0
    MySQL.Async.execute([[
        INSERT INTO wz_leaderboard (identifier, name, kills, wins, deaths, season)
        VALUES (@identifier, @name, @kills, @wins, @deaths, @season)
        ON DUPLICATE KEY UPDATE
            name = @name,
            kills = kills + @kills,
            wins = wins + @wins,
            deaths = deaths + @deaths
    ]], {
        ['@identifier'] = identifier,
        ['@name'] = name,
        ['@kills'] = kills,
        ['@wins'] = wins,
        ['@deaths'] = deaths,
        ['@season'] = CurrentSeason,
    })
end

-------------------------------------------------------------------
-- Expansion: Server-Authoritative Economy
-------------------------------------------------------------------
function WZ_GetCash(src) return PlayerCash[src] or 0 end
function WZ_SetCash(src, amount)
    PlayerCash[src] = amount
    TriggerClientEvent('AWZ:SyncCash', src, PlayerCash[src])
end
function WZ_AddCash(src, amount)
    WZ_SetCash(src, (PlayerCash[src] or 0) + amount)
end
function WZ_TrySpend(src, amount)
    if (PlayerCash[src] or 0) >= amount then
        WZ_SetCash(src, PlayerCash[src] - amount)
        return true
    end
    return false
end
RegisterServerEvent('AWZ:ResetCash')
AddEventHandler('AWZ:ResetCash', function() WZ_SetCash(source, 0) end)
RegisterServerEvent('AWZ:KillCashReward')
AddEventHandler('AWZ:KillCashReward', function() WZ_AddCash(source, 500) end)

local ShopPrices = { heal50 = 300, heal100 = 500, vest50 = 300, vest100 = 500, uav = 400, blood = 1000, loadout = 1000 }
-- Every WarZone shop purchase now goes through this single validated
-- callback instead of the client just deciding locally it can afford
-- something. The client still applies the actual item effect (gain armor,
-- gain a bandage charge, etc) once this confirms the money was real.
ESX.RegisterServerCallback('AWZ:ShopBuy', function(source, cb, item)
    local price = ShopPrices[item]
    if not price then return cb(false, WZ_GetCash(source)) end
    local ok = WZ_TrySpend(source, price)
    cb(ok, WZ_GetCash(source))
end)

-- Expansion: Buy Station -- same validated pattern, but the cost comes out
-- of the whole squad's pooled cash (split evenly across alive squadmates
-- + the buyer), not just the buyer's own.
ESX.RegisterServerCallback('AWZ:BuyStationBuy', function(source, cb, value)
    local item = nil
    for _, v in ipairs(Config.BuyStation.items) do
        if v.value == value then item = v break end
    end
    if not item then return cb(false, 'Unknown item') end
    local mates = GetAliveSquadmates(source)
    table.insert(mates, source)
    local pooled = 0
    for _, mid in ipairs(mates) do pooled = pooled + WZ_GetCash(mid) end
    if pooled < item.cost then
        return cb(false, 'Squad pooled cash is short ('..pooled..'/'..item.cost..')')
    end
    local remaining = item.cost
    local share = math.ceil(item.cost / #mates)
    for _, mid in ipairs(mates) do
        if remaining <= 0 then break end
        local take = math.min(share, WZ_GetCash(mid), remaining)
        WZ_TrySpend(mid, take)
        remaining = remaining - take
    end
    for _, mid in ipairs(mates) do
        SendNotifyServerToPlayer(mid, 'Squad bought: '..item.label, 'info')
    end
    if item.value == 'streakskip' then
        -- resolve immediately server-side instead of round-tripping through
        -- the client: pulls the buyer 2 kills closer to a Vehicle Killstreak
        KillStreak[source] = (KillStreak[source] or 0) + 2
        if Config.VehicleKillstreak.enabled and KillStreak[source] >= Config.VehicleKillstreak.kills then
            TriggerClientEvent('AWZ:VehicleKillstreak', source)
            SendNotifyServerToPlayer(source, 'Vehicle Killstreak ready -- attack chopper incoming!', 'info')
        end
    end
    cb(true, item.value)
end)

function ShowMyStats(source)
    local xPlayer = ESX.GetPlayerFromId(source)
    if not xPlayer then return end
    MySQL.Async.fetchAll([[
        SELECT SUM(kills) as kills, SUM(wins) as wins, SUM(deaths) as deaths
        FROM wz_leaderboard WHERE identifier = @identifier
    ]], {
        ['@identifier'] = xPlayer.identifier,
    }, function(rows)
        -- Fix: MySQL's SUM() comes back through oxmysql as a STRING (a
        -- common DECIMAL-serialization quirk), not a Lua number -- so
        -- `deaths > 0` below was comparing a string to a number and
        -- crashing. tonumber(...) normalizes it either way (also handles
        -- SUM() returning SQL NULL for a brand-new player with no rows yet).
        local kills = tonumber(rows and rows[1] and rows[1].kills) or 0
        local wins = tonumber(rows and rows[1] and rows[1].wins) or 0
        local deaths = tonumber(rows and rows[1] and rows[1].deaths) or 0
        local kd = deaths > 0 and string.format('%.2f', kills / deaths) or tostring(kills)
        local template = '<div style="padding: 0.6vw; margin: 0.5vw; background-color:rgba(0,0,0,0.75); border-radius: 3px; font-size:0.85vw;">🔫 Your WarZone Stats<br>Kills: '..kills..' | Deaths: '..deaths..' | K/D: '..kd..'<br>Wins: '..wins..'</div>'
        TriggerClientEvent('chat:addMessage', source, {template = template, args = {}})
    end)
end
RegisterCommand(Config.statsCommend, function(source, args)
    ShowMyStats(source)
end)
RegisterServerEvent('AWZ:ShowMyStats')
AddEventHandler('AWZ:ShowMyStats', function()
    ShowMyStats(source)
end)

function ShowLastMatch(source)
    MySQL.Async.fetchAll('SELECT * FROM wz_match_history ORDER BY id DESC LIMIT 1', {}, function(rows)
        if not rows or #rows == 0 then
            return SendNotifyServerToPlayer(source, 'No match history yet', 'error')
        end
        local match = rows[1]
        local lines = ''
        local ok, events = pcall(json.decode, match.summary or '[]')
        if ok and events then
            for i, ev in ipairs(events) do
                lines = lines .. (i)..'. '..ev..'<br>'
            end
        end
        local template = '<div style="padding: 0.6vw; margin: 0.5vw; background-color:rgba(0,0,0,0.75); border-radius: 3px; font-size:0.85vw;">📼 Last Match ('..match.map..', '..match.player_count..' players)<br>Winners: '..match.winners..'<br>'..lines..'</div>'
        TriggerClientEvent('chat:addMessage', source, {template = template, args = {}})
    end)
end
RegisterCommand(Config.lastmatchCommend, function(source, args)
    ShowLastMatch(source)
end)
RegisterServerEvent('AWZ:ShowLastMatch')
AddEventHandler('AWZ:ShowLastMatch', function()
    ShowLastMatch(source)
end)

-------------------------------------------------------------------
-- Expansion: Persistent Rank (XP that never resets)
-------------------------------------------------------------------
function WZ_AwardXP(identifier, amount)
    if not identifier or amount == 0 then return end
    if DoubleXPActive then amount = amount * 2 end
    MySQL.Async.execute([[
        INSERT INTO wz_rank (identifier, xp) VALUES (@identifier, @xp)
        ON DUPLICATE KEY UPDATE xp = xp + @xp
    ]], { ['@identifier'] = identifier, ['@xp'] = amount })
end
RegisterCommand(Config.Rank.command, function(source, args)
    local xPlayer = ESX.GetPlayerFromId(source)
    if not xPlayer then return end
    MySQL.Async.fetchAll('SELECT xp FROM wz_rank WHERE identifier = @identifier', {
        ['@identifier'] = xPlayer.identifier,
    }, function(rows)
        local xp = (rows and rows[1] and tonumber(rows[1].xp)) or 0
        local level = math.floor(xp / Config.Rank.xpPerLevel) + 1
        local intoLevel = xp % Config.Rank.xpPerLevel
        local template = '<div style="padding: 0.6vw; margin: 0.5vw; background-color:rgba(0,0,0,0.75); border-radius: 3px; font-size:0.85vw;">⭐ WarZone Rank: Level '..level..' ('..xp..' XP total, '..intoLevel..'/'..Config.Rank.xpPerLevel..' to next)</div>'
        TriggerClientEvent('chat:addMessage', source, {template = template, args = {}})
    end)
end)

-------------------------------------------------------------------
-- Expansion: WZCoins (persistent currency) + Cosmetic Shop
-------------------------------------------------------------------
function WZ_GetCoins(identifier, cb)
    MySQL.Async.fetchAll('SELECT coins FROM wz_currency WHERE identifier = @identifier', {
        ['@identifier'] = identifier,
    }, function(rows)
        cb((rows and rows[1] and tonumber(rows[1].coins)) or 0)
    end)
end
function WZ_AddCoins(identifier, amount)
    MySQL.Async.execute([[
        INSERT INTO wz_currency (identifier, coins) VALUES (@identifier, @coins)
        ON DUPLICATE KEY UPDATE coins = coins + @coins
    ]], { ['@identifier'] = identifier, ['@coins'] = amount })
end
ESX.RegisterServerCallback('AWZ:GetShopState', function(source, cb)
    local xPlayer = ESX.GetPlayerFromId(source)
    if not xPlayer then return cb(0, {}) end
    WZ_GetCoins(xPlayer.identifier, function(coins)
        MySQL.Async.fetchAll('SELECT item FROM wz_cosmetics WHERE identifier = @identifier', {
            ['@identifier'] = xPlayer.identifier,
        }, function(rows)
            local owned = {}
            for _, row in ipairs(rows or {}) do owned[row.item] = true end
            cb(coins, owned)
        end)
    end)
end)
ESX.RegisterServerCallback('AWZ:BuyCosmetic', function(source, cb, itemId)
    local xPlayer = ESX.GetPlayerFromId(source)
    if not xPlayer then return cb(false, 'No player') end
    local item = nil
    for _, v in ipairs(Config.CosmeticShop.items) do
        if v.id == itemId then item = v break end
    end
    if not item then return cb(false, 'Unknown item') end
    WZ_GetCoins(xPlayer.identifier, function(coins)
        if coins < item.cost then return cb(false, 'Not enough WZCoins') end
        WZ_AddCoins(xPlayer.identifier, -item.cost)
        MySQL.Async.execute([[
            INSERT INTO wz_cosmetics (identifier, item) VALUES (@identifier, @item)
            ON DUPLICATE KEY UPDATE item = item
        ]], { ['@identifier'] = xPlayer.identifier, ['@item'] = item.id })
        cb(true, item.variant)
    end)
end)

-------------------------------------------------------------------
-- Expansion: Battle Pass -- daily challenges, tracked per calendar day.
-- Progress is bumped from the same places WZ_AddStat already gets called
-- (a kill, a win) so it stays in sync with the seasonal leaderboard.
-------------------------------------------------------------------
function WZ_Today() return os.date('%Y-%m-%d') end
function WZ_BumpBattlePass(identifier, stat, amount)
    if not identifier or not Config.BattlePass.enabled then return end
    local day = WZ_Today()
    local col = (stat == 'wins') and 'wins' or 'kills'
    MySQL.Async.execute('INSERT INTO wz_battlepass (identifier, day, '..col..') VALUES (@identifier, @day, @amount) ON DUPLICATE KEY UPDATE '..col..' = '..col..' + @amount', {
        ['@identifier'] = identifier, ['@day'] = day, ['@amount'] = amount,
    })
end
RegisterCommand(Config.BattlePass.command, function(source, args)
    local xPlayer = ESX.GetPlayerFromId(source)
    if not xPlayer then return end
    local day = WZ_Today()
    MySQL.Async.fetchAll('SELECT * FROM wz_battlepass WHERE identifier = @identifier AND day = @day', {
        ['@identifier'] = xPlayer.identifier, ['@day'] = day,
    }, function(rows)
        local row = rows and rows[1]
        local kills = row and tonumber(row.kills) or 0
        local wins = row and tonumber(row.wins) or 0
        local claimed = {}
        for id in string.gmatch((row and row.claimed) or '', '[^,]+') do claimed[id] = true end
        local lines = ''
        local toClaim = {}
        for _, ch in ipairs(Config.BattlePass.dailyChallenges) do
            local progress = (ch.stat == 'wins') and wins or kills
            local done = progress >= ch.target
            local status = claimed[ch.id] and '✅ claimed' or (done and '🎁 ready to claim!' or (progress..'/'..ch.target))
            lines = lines..ch.label..' — '..status..'<br>'
            if done and not claimed[ch.id] then table.insert(toClaim, ch) end
        end
        local template = '<div style="padding: 0.6vw; margin: 0.5vw; background-color:rgba(0,0,0,0.75); border-radius: 3px; font-size:0.85vw;">🎫 Today\'s Battle Pass Challenges<br>'..lines..'</div>'
        TriggerClientEvent('chat:addMessage', source, {template = template, args = {}})
        for _, ch in ipairs(toClaim) do
            WZ_AddCoins(xPlayer.identifier, ch.reward)
            claimed[ch.id] = true
        end
        if #toClaim > 0 then
            local claimedList = {}
            for id, _ in pairs(claimed) do table.insert(claimedList, id) end
            MySQL.Async.execute([[
                INSERT INTO wz_battlepass (identifier, day, claimed) VALUES (@identifier, @day, @claimed)
                ON DUPLICATE KEY UPDATE claimed = @claimed
            ]], { ['@identifier'] = xPlayer.identifier, ['@day'] = day, ['@claimed'] = table.concat(claimedList, ',') })
            SendNotifyServerToPlayer(source, 'Claimed '..#toClaim..' Battle Pass reward(s)!', 'info')
        end
    end)
end)

-------------------------------------------------------------------
-- Expansion: Reports -- reachable from the /warzone menu (client side),
-- logs to wz_reports and pings every online admin immediately.
-------------------------------------------------------------------
RegisterServerEvent('AWZ:SubmitReport')
AddEventHandler('AWZ:SubmitReport', function(reportedId, reason)
    if not Config.Report.enabled then return end
    local reporterName = GetPlayerName(source) or ('#'..source)
    local reportedName = GetPlayerName(tonumber(reportedId)) or ('#'..tostring(reportedId))
    reason = tostring(reason or 'No reason given')
    MySQL.Async.execute([[
        INSERT INTO wz_reports (reporter, reported, reason) VALUES (@reporter, @reported, @reason)
    ]], { ['@reporter'] = reporterName, ['@reported'] = reportedName, ['@reason'] = reason })
    for _, playerId in ipairs(GetPlayers()) do
        local aid = tonumber(playerId)
        if IsPlayerCanStart(aid) then
            SendNotifyServerToPlayer(aid, '🚩 Report: '..reporterName..' reported '..reportedName..' — '..reason, 'error')
        end
    end
    SendNotifyServerToPlayer(source, 'Report submitted, thank you.', 'info')
end)

-------------------------------------------------------------------
-- Expansion: Team-Size Vote + Map Vote -- collected while the lobby is
-- open, tallied by AutoQueueWatch (see BeginMatch/OpenLobby edits below)
-- instead of always using Config.AutoQueue's fixed defaults.
-------------------------------------------------------------------
RegisterCommand(Config.ModeVote.voteCommend, function(source, args)
    if not Config.ModeVote.enabled then return end
    local size = tonumber(args[1])
    if not size or size < 1 or size > 4 then
        return SendNotifyServerToPlayer(source, 'Usage: /'..Config.ModeVote.voteCommend..' 1-4 (1=Solo 2=Duo 3=Trio 4=Squad)', 'error')
    end
    ModeVotes[source] = size
    SendNotifyServerToPlayer(source, 'Voted for '..Config.ModeVote.labels[size]..'!', 'info')
end)
RegisterCommand(Config.MapVote.voteCommend, function(source, args)
    if not Config.MapVote.enabled then return end
    local map = args[1] and string.upper(args[1])
    if map ~= 'SANDY' and map ~= 'ISLAND' then
        return SendNotifyServerToPlayer(source, 'Usage: /'..Config.MapVote.voteCommend..' sandy|island', 'error')
    end
    MapVotes[source] = map
    SendNotifyServerToPlayer(source, 'Voted for '..map..'!', 'info')
end)
function WZ_TallyVotes(votes)
    local counts = {}
    local best, bestCount = nil, 0
    for src, v in pairs(votes) do
        counts[v] = (counts[v] or 0) + 1
        if counts[v] > bestCount then best, bestCount = v, counts[v] end
    end
    return best
end

-------------------------------------------------------------------
-- Epic: Kill Feed, First Blood, Squad Wiped, Legendary Find, MVP, Double
-- XP -- all layered on top of existing kill/win/squad events so they
-- can't change match outcomes, only announce them louder.
-------------------------------------------------------------------
-- Fix: declared without `local`, same reasoning as DoubleXPActive above --
-- BeginMatch() (defined earlier in this file) resets these too, and a
-- `local` here would be invisible to code above this point.
FirstBloodDone = false
LastAnnouncedSquadCount = nil
MatchKillTotals = {} -- [source] = kills this match, for the MVP announcement
-- Fix: declared without `local` on purpose -- WZ_AwardXP() (defined
-- earlier in this file, in the Rank section) reads this flag too, and a
-- `local` here would only be visible to code textually AFTER this point,
-- silently making WZ_AwardXP's check always see an unset value.
DoubleXPActive = false

RegisterServerEvent('AWZ:AnnounceLegendaryFind')
AddEventHandler('AWZ:AnnounceLegendaryFind', function(weaponLabel)
    if not StartMatch then return end
    SendMessage('✨ '..GetPlayerName(source)..' just found a ~y~LEGENDARY ~w~'..tostring(weaponLabel)..'!')
end)

RegisterCommand('wzdoublexp', function(source, args)
    if not IsPlayerCanStart(source) then return end
    DoubleXPActive = not DoubleXPActive
    SendMessage(DoubleXPActive and '⭐ Double XP is now ACTIVE for WarZone!' or '⭐ Double XP has ended.')
end, false)

-------------------------------------------------------------------
-- Party system: keep a group of players together in the same squad when
-- the match starts, instead of everyone being grouped by join order only.
-------------------------------------------------------------------
function GetPartyLeader(src)
    return PartyLeader[src] or src
end
function GetPartyMembers(leaderSrc)
    return PartyMembers[leaderSrc] or {leaderSrc}
end
function PartyInviteAction(source, target)
    if not target or not GetPlayerName(target) then
        return SendNotifyServerToPlayer(source, 'Invalid player id', 'error')
    end
    if target == source then
        return SendNotifyServerToPlayer(source, "You can't invite yourself", 'error')
    end
    local myLeader = GetPartyLeader(source)
    if #GetPartyMembers(myLeader) >= 4 then
        return SendNotifyServerToPlayer(source, 'Your party is already full (max 4)', 'error')
    end
    PendingInvites[target] = myLeader
    SendNotifyServerToPlayer(target, GetPlayerName(source)..' invited you to their WarZone party. Open /'..Config.menuCommend..' to accept', 'info')
    SendNotifyServerToPlayer(source, 'Invite sent to '..GetPlayerName(target), 'info')
end
function PartyAcceptAction(source)
    local leader = PendingInvites[source]
    if not leader or not GetPlayerName(leader) then
        return SendNotifyServerToPlayer(source, 'You have no pending party invite', 'error')
    end
    if #GetPartyMembers(leader) >= 4 then
        PendingInvites[source] = nil
        return SendNotifyServerToPlayer(source, 'That party is already full', 'error')
    end
    -- leave any existing party first
    LeaveParty(source)
    PartyLeader[source] = leader
    PartyMembers[leader] = PartyMembers[leader] or {leader}
    table.insert(PartyMembers[leader], source)
    PendingInvites[source] = nil
    for _, mid in ipairs(PartyMembers[leader]) do
        SendNotifyServerToPlayer(mid, GetPlayerName(source)..' joined the party', 'info')
    end
end
function PartyLeaveAction(source)
    LeaveParty(source)
    SendNotifyServerToPlayer(source, 'You left your party', 'info')
end
function PartyListAction(source)
    local leader = GetPartyLeader(source)
    local names = {}
    for _, mid in ipairs(GetPartyMembers(leader)) do
        table.insert(names, GetPlayerName(mid) or ('#'..mid))
    end
    SendNotifyServerToPlayer(source, 'Party: '..table.concat(names, ', '), 'info')
end
RegisterCommand(Config.partyCommend, function(source, args)
    local sub = args[1]
    if sub == 'invite' then
        PartyInviteAction(source, tonumber(args[2]))
    elseif sub == 'accept' then
        PartyAcceptAction(source)
    elseif sub == 'leave' then
        PartyLeaveAction(source)
    elseif sub == 'list' then
        PartyListAction(source)
    else
        SendNotifyServerToPlayer(source, 'Usage: /'..Config.partyCommend..' invite <id> | accept | leave | list', 'error')
    end
end)
RegisterServerEvent('AWZ:PartyInviteEvent')
AddEventHandler('AWZ:PartyInviteEvent', function(target)
    PartyInviteAction(source, tonumber(target))
end)
RegisterServerEvent('AWZ:PartyAcceptEvent')
AddEventHandler('AWZ:PartyAcceptEvent', function()
    PartyAcceptAction(source)
end)
RegisterServerEvent('AWZ:PartyLeaveEvent')
AddEventHandler('AWZ:PartyLeaveEvent', function()
    PartyLeaveAction(source)
end)
function LeaveParty(src)
    local leader = PartyLeader[src]
    if not leader then return end
    if PartyMembers[leader] then
        for k, mid in ipairs(PartyMembers[leader]) do
            if mid == src then table.remove(PartyMembers[leader], k) break end
        end
        if #PartyMembers[leader] <= 1 then
            PartyMembers[leader] = nil
        end
    end
    PartyLeader[src] = nil
end
AddEventHandler('playerDropped', function()
    LeaveParty(source)
    PendingInvites[source] = nil
end)

-- Feature: /warzone menu support -- current party state and the online
-- player list, both used to build the icon_menu client-side without
-- needing the player to type anyone's id.
ESX.RegisterServerCallback('AWZ:GetPartyInfo', function(source, cb)
    local leader = GetPartyLeader(source)
    local members = GetPartyMembers(leader)
    local memberNames = {}
    local inParty = #members > 1
    if inParty then
        for _, mid in ipairs(members) do
            if mid ~= source then
                table.insert(memberNames, GetPlayerName(mid) or ('#'..mid))
            end
        end
    end
    local pendingFromName = nil
    if PendingInvites[source] then
        pendingFromName = GetPlayerName(PendingInvites[source])
    end
    cb({
        inParty = inParty,
        isLeader = (leader == source),
        members = memberNames,
        pendingFrom = pendingFromName,
    })
end)
ESX.RegisterServerCallback('AWZ:GetOnlinePlayers', function(source, cb)
    local list = {}
    for _, playerId in ipairs(GetPlayers()) do
        local pid = tonumber(playerId)
        if pid ~= source then
            table.insert(list, { id = pid, name = GetPlayerName(pid) })
        end
    end
    cb(list)
end)


RegisterCommand(Config.wztopCommend, function(source, args)
    MySQL.Async.fetchAll('SELECT name, kills, wins FROM wz_leaderboard WHERE season = @season ORDER BY (wins*5 + kills) DESC LIMIT @lim', {
        ['@season'] = CurrentSeason,
        ['@lim'] = Config.Leaderboard.top,
    }, function(rows)
        if not rows or #rows == 0 then
            return SendNotifyServerToPlayer(source, 'Leaderboard is empty for this season', 'error')
        end
        local lines = ''
        for i, row in ipairs(rows) do
            lines = lines .. i..'. '..row.name..' — '..row.wins..' wins / '..row.kills..' kills<br>'
        end
        local template = '<div style="padding: 0.6vw; margin: 0.5vw; background-color:rgba(0,0,0,0.75); border-radius: 3px; font-size:0.85vw;">🏆 WarZone Leaderboard (Season '..CurrentSeason..')<br>'..lines..'</div>'
        TriggerClientEvent('chat:addMessage', source, {template = template, args = {}})
    end)
end)

RegisterCommand(Config.seasonresetCommend, function(source, args)
    if not IsPlayerCanStart(source) then
        return SendNotifyServerToPlayer(source, 'You do not have permission to use this command', 'error')
    end
    MySQL.Async.fetchAll('SELECT identifier, name, kills, wins FROM wz_leaderboard WHERE season = @season ORDER BY (wins*5 + kills) DESC LIMIT 1', {
        ['@season'] = CurrentSeason,
    }, function(rows)
        local rewardedText = 'No players on the leaderboard this season.'
        if rows and #rows > 0 then
            local top = rows[1]
            -- Only pay out if the #1 player is currently online (we only
            -- have a `source` for connected players).
            for _, playerId in ipairs(GetPlayers()) do
                local xPlayer = ESX.GetPlayerFromId(tonumber(playerId))
                if xPlayer and xPlayer.identifier == top.identifier then
                    xPlayer.addMoney(Config.Leaderboard.seasonRewardTop1)
                    rewardedText = top.name..' wins Season '..CurrentSeason..' and gets $'..Config.Leaderboard.seasonRewardTop1..'!'
                end
            end
            if rewardedText == 'No players on the leaderboard this season.' then
                rewardedText = top.name..' wins Season '..CurrentSeason..' with '..top.wins..' wins / '..top.kills..' kills, but is offline so the reward was not paid automatically.'
            end
        end
        SendMessage(rewardedText)
        SendDiscordWebhook('🏆 Season '..CurrentSeason..' ended', rewardedText, 15844367)
        CurrentSeason = CurrentSeason + 1
        SendMessage('Season '..CurrentSeason..' has begun!')
    end)
end)

-------------------------------------------------------------------
-- Discord Webhook
-------------------------------------------------------------------
function SendDiscordWebhook(title, description, color)
    if not Config.DiscordWebhook or Config.DiscordWebhook == '' then return end
    PerformHttpRequest(Config.DiscordWebhook, function() end, 'POST',
        json.encode({
            username = Config.DiscordWebhookName,
            embeds = { { title = title, description = description, color = color or 3447003 } }
        }),
        { ['Content-Type'] = 'application/json' }
    )
end

-------------------------------------------------------------------
-- Auto-Queue: once enough players have joined the open lobby, count
-- down and auto-start the match with the configured defaults. Any
-- admin can still start manually at any time (this thread just backs
-- off once StartMatch/Lobbey flip).
-------------------------------------------------------------------
function AutoQueueWatch()
    -- Fix: this used to gate on a global `AutoQueueRunning` flag that only
    -- got cleared once the OLD thread's `Wait()` resolved and it noticed
    -- Lobbey had flipped false -- up to a few seconds later. If an admin
    -- closed and reopened the lobby quickly, the new call could see the
    -- flag still "true" and skip starting a watcher entirely, silently
    -- disabling Auto-Queue for that session. BeginMatch() already guards
    -- against double-starting a match (via the StartMatch flag), so it's
    -- safe to just let a fresh thread run per lobby session instead.
    CreateThread(function()
        while Lobbey and not StartMatch do
            Wait(3000)
            if Lobbey and not StartMatch and #Players >= Config.AutoQueue.minPlayers then
                SendMessage('Enough players joined — match starts in '..Config.AutoQueue.countdown..'s!')
                local secondsLeft = Config.AutoQueue.countdown
                while secondsLeft > 0 and Lobbey and not StartMatch do
                    Wait(1000)
                    secondsLeft = secondsLeft - 1
                    -- lost enough players in the meantime, abort the countdown
                    if #Players < Config.AutoQueue.minPlayers then
                        SendMessage('Not enough players anymore, auto-start cancelled.')
                        break
                    end
                    if secondsLeft > 0 and secondsLeft <= 5 then
                        SendMessage('Match starting in '..secondsLeft..'...')
                    end
                end
                if Lobbey and not StartMatch and #Players >= Config.AutoQueue.minPlayers and secondsLeft <= 0 then
                    -- Expansion: Team-Size Vote / Map Vote -- use the
                    -- lobby's vote tally when available, falling back to
                    -- Config.AutoQueue's fixed defaults otherwise (voting
                    -- disabled, or nobody voted).
                    local votedTeam = Config.ModeVote.enabled and WZ_TallyVotes(ModeVotes) or nil
                    local votedMap = Config.MapVote.enabled and WZ_TallyVotes(MapVotes) or nil
                    BeginMatch(0, Config.AutoQueue.defaultBlood, Config.AutoQueue.defaultTime,
                        votedMap or Config.AutoQueue.defaultMap, votedTeam or Config.AutoQueue.defaultTeam)
                end
            end
        end
    end)
end

-- Shared match-start logic used by /startmatch, the admin NUI panel, and
-- Auto-Queue. `source` is 0 for system/auto-queue starts (no player to
-- notify). Returns true on success, false + an error string otherwise.
function BeginMatch(source, blood, time, mapArg, teamArg)
    print('[WZ DEBUG] BeginMatch called: source='..tostring(source)..' blood='..tostring(blood)..' time='..tostring(time)..' map='..tostring(mapArg)..' team='..tostring(teamArg)..' | StartMatch='..tostring(StartMatch)..' Lobbey='..tostring(Lobbey)..' #Players='..#Players)
    if StartMatch then
        print('[WZ DEBUG] BeginMatch REJECTED: match already started')
        if source and source ~= 0 then SendNotifyServerToPlayer(source, 'Warzone has started', 'error') end
        return false, 'already started'
    end
    if not Lobbey then
        print('[WZ DEBUG] BeginMatch REJECTED: lobby not open')
        if source and source ~= 0 then SendNotifyServerToPlayer(source, 'Lobbey has not opened', 'error') end
        return false, 'lobby not open'
    end
    blood = tonumber(blood)
    time = tonumber(time)
    if not blood or not time or blood <= 0 or time <= 0 or not mapArg then
        print('[WZ DEBUG] BeginMatch REJECTED: bad args (blood='..tostring(blood)..' time='..tostring(time)..' map='..tostring(mapArg)..')')
        if source and source ~= 0 then SendNotifyServerToPlayer(source, 'Enter the elements correctly', 'error') end
        return false, 'bad args'
    end
    local Coords, Map
    if string.upper(mapArg) == 'ISLAND' then
        Coords = Config.IslandZone
        Map = 'ISLAND'
    else
        Coords = Config.SandyZone
        Map = 'SANDY'
    end
    teamArg = tonumber(teamArg)
    if teamArg and teamArg > 0 and teamArg <= 4 then
        Team = teamArg
    else
        Team = 1
    end
    StartMatch = true
    Lobbey = false
    MatchStartedAt = os.time()
    MatchStartCount = #Players
    MatchId = MatchId + 1
    MatchLog = {'Match started on '..Map..' with '..#Players..' players'}
    KillStreak = {}
    RecentKillTimes = {}
    PlayerKeys = {}
    -- Expansion: match-scoped state, reset for every new match
    PlayerCash = {}
    CarKeys = {}
    AwaitingReboot = {}
    ContractStreak = {}
    ModeVotes = {}
    MapVotes = {}
    -- Epic: reset per-match announcement state
    FirstBloodDone = false
    LastAnnouncedSquadCount = nil
    MatchKillTotals = {}
    CurrentMatchMap = Map
    print('[WZ DEBUG] BeginMatch ACCEPTED: Map='..Map..' Team='..Team..' #Players going in='..#Players)
    TriggerClientEvent("AWZ:CloseUI", -1)
    AntiCheatMonitor()
    SpawnMatchVehicles(Map) -- Expansion: Vehicle Loot
    StartWarZone(blood, time, Coords, Team, Map)
    return true
end

----Commend
function OpenLobby(source)
    if StartMatch then
        if source and source ~= 0 then SendNotifyServerToPlayer(source , 'Warzone has started' , 'error') end
        return false
    end
    if Lobbey then
        if source and source ~= 0 then SendNotifyServerToPlayer(source , 'Lobbey has opened' , 'error') end
        return false
    end
    Lobbey = true 
    Event = true 
    SquadCount = 1
    Squads = {} 
    Team = 1 
    Body = 0 
    SendMessage(Config.StartNotify) 
    UpdateMembers()
    if Config.AutoQueue.enabled then
        AutoQueueWatch()
    end
    return true
end
RegisterCommand(Config.StartCommend,function(source,args) 
    if IsPlayerCanStart(source) then 
        OpenLobby(source)
    else
        -- Fix: this used to fail completely silently when the player's
        -- permission_level was too low, giving no feedback at all.
        SendNotifyServerToPlayer(source , 'You do not have permission to use this command' , 'error')
    end 
end) 
-- Admin GUI panel entry point for opening the lobby.
RegisterServerEvent('AWZ:AdminOpenLobby')
AddEventHandler('AWZ:AdminOpenLobby', function()
    if IsPlayerCanStart(source) then
        OpenLobby(source)
    else
        SendNotifyServerToPlayer(source , 'You do not have permission to use this command' , 'error')
    end
end)
RegisterCommand(Config.Startmatchcommend ,function(source,args)
    if IsPlayerCanStart(source) then 
        BeginMatch(source, args[1], args[2], args[3], args[4])
    else
        SendNotifyServerToPlayer(source , 'You do not have permission to use this command' , 'error')
    end 
end)
-- Admin NUI panel: opens client-side (permission is re-checked here before
-- opening, and again in AWZ:AdminStart below before actually starting).
RegisterCommand(Config.panelCommend, function(source, args)
    if IsPlayerCanStart(source) then
        TriggerClientEvent('AWZ:OpenAdminPanel', source, Lobbey, StartMatch)
    else
        SendNotifyServerToPlayer(source , 'You do not have permission to use this command' , 'error')
    end
end)
RegisterServerEvent('AWZ:AdminStart')
AddEventHandler('AWZ:AdminStart', function(blood, time, mapArg, teamArg)
    if IsPlayerCanStart(source) then
        BeginMatch(source, blood, time, mapArg, teamArg)
    else
        SendNotifyServerToPlayer(source , 'You do not have permission to use this command' , 'error')
    end
end)

RegisterCommand(Config.JoinLobbeyCommend,function(source,args)
    local InWz = false 
    for k,v in pairs(Players) do if v.ID == source then  InWz = true  end end 
    if Lobbey  then 
        if not InWz then 
            TriggerClientEvent("AWZ:OpenUI",source)

        end
    else 
        SendNotifyServerToPlayer(source , 'Lobbey has not opened' , 'error')  
    end
end)
RegisterCommand(Config.closelobbey,function(source,args)
    if IsPlayerCanStart(source) then 
        if  StartMatch then return SendNotifyServerToPlayer(source , 'Warzone has started' , 'error') end 
        if not  Lobbey then return SendNotifyServerToPlayer(source , 'Lobbey has not  opened' , 'error')  end 
        for k,v in pairs(Players) do  print('[WZ DEBUG] ExitMision -> '..v.ID..' from CLOSELOBBEY command') TriggerClientEvent("AWZ:ExitMision",v.ID )  end 
        Players = {}
        StartMatch = false 
        Lobbey = false 
        Event = false 
    else
        SendNotifyServerToPlayer(source , 'You do not have permission to use this command' , 'error')
    end 
end)
RegisterCommand(Config.endwarzoneCommend ,function(source,args)
    if IsPlayerCanStart(source) then 
        if not StartMatch then return SendNotifyServerToPlayer(source , 'Warzone has not started' , 'error') end 
        if  Lobbey then return SendNotifyServerToPlayer(source , 'Lobbey has opened' , 'error')  end 
        for k,v in pairs(Players) do  print('[WZ DEBUG] ExitMision -> '..v.ID..' from ENDWARZONE command') TriggerClientEvent("AWZ:ExitMision",v.ID )  end 
        Players = {}
        StartMatch = false 
        Lobbey = false 
        Event = false 
    else
        SendNotifyServerToPlayer(source , 'You do not have permission to use this command' , 'error')
    end 
end)
RegisterCommand(Config.exitCommend,function(source,args)
    if StartMatch  or Lobbey then 
        for k,v in pairs(Players) do 
            if v.ID  ==  source then 
                -- Fix: leaving via /exitwz while in the Gulag never
                -- decremented Prisoner (only dying there did), leaving the
                -- counter permanently stale and able to block the match from
                -- ever detecting a winner.
                if v.ingulag then
                    Prisoner = Prisoner - 1
                end
                table.remove(Players , k,v) 
                print('[WZ DEBUG] ExitMision -> '..source..' from EXITWZ command')
                TriggerClientEvent("AWZ:ExitMision",source )
                SendNotifyServerToPlayer(source , 'You left the Battle' , 'info') 
                break 
            end 
        end 
    end 
end)
function StartWarZone( Blood , Time , Coord , Team , Map) 
    SendMessage(Config.StartMatchNotify) 
    CreateThread(function()
        print('[WZ DEBUG] StartWarZone thread begins, snapshotting #Players='..#Players)
        -- Fix: this loop used to read the live `Players` table across
        -- Wait(5) yields, so a player disconnecting/leaving mid-loop (still
        -- possible: StartMatch is already true, and playerDropped/exitwz
        -- both still remove from Players once it is) could shift indices
        -- out from under it, or shrink Players below `KeyNumber` --
        -- crashing this thread on `Players[KeyNumber].ID` being nil and
        -- leaving squads only half-assigned for the whole match. Snapshot
        -- the roster synchronously (no yields) first, then build squads
        -- from the stable copy.
        local PlayersSnapshot = {}
        for _, p in ipairs(Players) do
            table.insert(PlayersSnapshot, p)
        end
        local KeyNumber = 0 
        SquadCount = 1
        -- Feature: Party-aware squad building + Squad Fill. Group the
        -- snapshot by party leader first (a solo player is their own
        -- "party" of one), place each party into its own squad slot(s),
        -- then top up any squad still short of `Team` with leftover solo
        -- players instead of leaving them in their own tiny squad.
        local seen = {}
        local groups = {}
        for _, p in ipairs(PlayersSnapshot) do
            if not seen[p.ID] then
                local leader = GetPartyLeader(p.ID)
                local group = {}
                for _, memberId in ipairs(GetPartyMembers(leader)) do
                    -- only include party members who actually joined this lobby
                    for _, p2 in ipairs(PlayersSnapshot) do
                        if p2.ID == memberId and not seen[memberId] then
                            table.insert(group, memberId)
                            seen[memberId] = true
                        end
                    end
                end
                if #group == 0 then
                    table.insert(group, p.ID)
                    seen[p.ID] = true
                end
                table.insert(groups, group)
            end
        end
        local soloLeftovers = {}
        for _, group in ipairs(groups) do
            Wait(5)
            if #group > Team then
                -- party bigger than the team size: split across squads
                for i = 1, #group, Team do
                    Squads[SquadCount] = {}
                    for j = i, math.min(i + Team - 1, #group) do
                        table.insert(Squads[SquadCount], group[j])
                    end
                    SquadCount = SquadCount + 1
                end
            elseif #group == 1 then
                -- solo player -- park them for the fill-in pass below
                table.insert(soloLeftovers, group[1])
            else
                Squads[SquadCount] = {}
                for _, memberId in ipairs(group) do
                    table.insert(Squads[SquadCount], memberId)
                end
                SquadCount = SquadCount + 1
            end
        end
        -- Feature: WarZone is meant to always be played as squads. Anyone
        -- who didn't come in with a party gets grouped with their real-life
        -- "team" instead of being randomly bucketed: first their gang, then
        -- their job (unless they have none), then everyone with no
        -- job/gang at all. Only once none of that applies does the generic
        -- Squad Fill below just top up whoever has room.
        local categoryBuckets = {}   -- key -> {ids}
        local categoryOrder = {}     -- preserves first-seen order
        for _, soloId in ipairs(soloLeftovers) do
            local xPlayer = ESX.GetPlayerFromId(soloId)
            local key = 'unemployed'
            if xPlayer then
                if xPlayer.gang and xPlayer.gang.name and xPlayer.gang.name ~= '' and xPlayer.gang.name ~= 'none' then
                    key = 'gang:'..xPlayer.gang.name
                elseif xPlayer.job and xPlayer.job.name and xPlayer.job.name ~= '' and xPlayer.job.name ~= 'unemployed' then
                    key = 'job:'..xPlayer.job.name
                end
            end
            if not categoryBuckets[key] then
                categoryBuckets[key] = {}
                table.insert(categoryOrder, key)
            end
            table.insert(categoryBuckets[key], soloId)
        end
        soloLeftovers = {} -- rebuilt below: only true one-offs remain solo
        for _, key in ipairs(categoryOrder) do
            local bucket = categoryBuckets[key]
            if #bucket > Team then
                for i = 1, #bucket, Team do
                    Squads[SquadCount] = {}
                    for j = i, math.min(i + Team - 1, #bucket) do
                        table.insert(Squads[SquadCount], bucket[j])
                    end
                    SquadCount = SquadCount + 1
                end
            elseif #bucket == 1 then
                table.insert(soloLeftovers, bucket[1])
            else
                Squads[SquadCount] = {}
                for _, memberId in ipairs(bucket) do
                    table.insert(Squads[SquadCount], memberId)
                end
                SquadCount = SquadCount + 1
            end
        end
        -- Squad Fill: top up the last party squad (if it has room) and any
        -- solo players into shared squads, instead of every solo player
        -- getting their own squad.
        local fillIndex = SquadCount - 1
        if type(Squads[fillIndex]) ~= 'table' or #Squads[fillIndex] >= Team then
            fillIndex = SquadCount
        end
        for _, soloId in ipairs(soloLeftovers) do
            if type(Squads[fillIndex]) ~= 'table' then Squads[fillIndex] = {} end
            table.insert(Squads[fillIndex], soloId)
            if #Squads[fillIndex] >= Team then
                fillIndex = fillIndex + 1
            end
        end
        if type(Squads[fillIndex]) == 'table' and #Squads[fillIndex] == 0 then
            Squads[fillIndex] = nil
        end
        -- Defensive: a player could still disconnect during the snapshot
        -- window above (or the Wait(5) ticks while squads are built). Drop
        -- any squad member no longer in the live Players table so they
        -- can't linger as a "ghost" member -- which CountSquads()/the win
        -- check would otherwise never be able to clear, since a departed
        -- player never triggers their own squad cleanup twice.
        for i, squad in pairs(Squads) do
            if type(squad) == 'table' then
                for k = #squad, 1, -1 do
                    local stillHere = false
                    for _, p in ipairs(Players) do
                        if p.ID == squad[k] then stillHere = true break end
                    end
                    if not stillHere then
                        table.remove(squad, k)
                    end
                end
                if #squad == 0 then
                    Squads[i] = nil
                end
            end
        end
        local squadDebug = ''
        for i, squad in pairs(Squads) do
            if type(squad) == 'table' then
                squadDebug = squadDebug..'squad'..i..'=['..table.concat(squad, ',')..'] '
            end
        end
        print('[WZ DEBUG] Squads built: '..squadDebug)
        -- Feature: Team Uniform -- offer a matching outfit to any squad of
        -- 2+ players (colors cycle per squad) before the drop.
        local SquadColors = {'Red', 'Blue', 'Green', 'Yellow', 'Purple', 'Orange'}
        local colorIndex = 0
        for i, squad in pairs(Squads) do
            if type(squad) == 'table' and #squad > 1 then
                colorIndex = colorIndex + 1
                local color = SquadColors[((colorIndex - 1) % #SquadColors) + 1]
                for _, memberId in ipairs(squad) do
                    TriggerClientEvent('AWZ:OfferTeamUniform', memberId, color)
                end
            end
        end
        InsertTeam ()
        Wait(1000)
        print('[WZ DEBUG] About to send AWZ:StartMatch to #Players='..#Players..' (live table, post-Wait(1000))')
        for k,v in pairs(Players) do 
            print('[WZ DEBUG] -> sending AWZ:StartMatch to source='..v.ID)
            SetPlayerRoutingBucket(v.ID, Config.FightWorld  )
            AntiCheatGrace(v.ID)
            TriggerClientEvent('AWZ:StartMatch' ,v.ID, Blood , Config.DistanceZone , Coord , Time , 0  , Map )
            -- Expansion: Custom Loadout Drop
            local loadout = PlayerLoadout[v.ID]
            if loadout and loadout.value ~= 'none' then
                TriggerClientEvent('AWZ:ApplyCustomLoadout', v.ID, loadout.weapons)
            end
        end 
    end)
    StartHazards(Coord) -- Expansion: Environmental Hazards
end 

-------------------------------------------------------------------
-- Expansion: Environmental Hazards. Picks a random point around the
-- match's starting zone center and radius every Config.Hazards.everyMs;
-- this is deliberately approximate rather than tracking the live shrinking
-- zone (that's computed entirely client-side in ZoneRuning()) -- it stays
-- roughly centered on the play area for the whole match instead of always
-- being inside the current, smaller circle late in a match.
-------------------------------------------------------------------
function StartHazards(Coord)
    if not Config.Hazards.enabled then return end
    CreateThread(function()
        while StartMatch do
            Wait(Config.Hazards.everyMs)
            if not StartMatch then break end
            local hType = Config.Hazards.types[math.random(1, #Config.Hazards.types)]
            local angle = math.random(0, 360) * (math.pi / 180)
            local dist = math.random(0, math.floor(Config.DistanceZone / 2))
            local hCoord = vector3(Coord.x + math.cos(angle) * dist, Coord.y + math.sin(angle) * dist, Coord.z)
            SendMessage('⚠️ '..(hType == 'gas' and 'A toxic gas cloud' or hType == 'sandstorm' and 'A sandstorm' or 'A lightning storm')..' is forming somewhere on the map!')
            TriggerClientEvent('AWZ:Hazard', -1, hType, hCoord, Config.Hazards.radius, Config.Hazards.damagePerTick)
        end
    end)
end
function InsertTeam ()
    if #Squads  ~= 0  and #Players ~= 0 then 
        for i=1 , #Squads  , 1 do 
            local Myteam = {}
            for d = 1 , #Squads[i]  , 1 do  
                table.insert(Myteam , { ID = Squads[i][d]  , Name =  GetPlayerName(Squads[i][d])} )
            end 
            for k,v in pairs( Myteam ) do
                TriggerClientEvent("AWZ:MyTeam",v.ID , Myteam  , Team  , v.ID , GetPlayerName( v.ID )  )
            end
        end     
    end 
end 

AddEventHandler('playerDropped', function () 
    if StartMatch  or Lobbey then  
        for k,v in pairs(Players) do 
            if v.ID == source then 
                -- Fix: disconnecting while in the Gulag never decremented
                -- Prisoner either, same stale-counter problem as /exitwz.
                if v.ingulag then
                    Prisoner = Prisoner - 1
                end
                table.remove(Players , k,v) 
                RemovePlayerFromSquad( source )
                break 
            end 
        end 
    end 
    for k, v in pairs(Spectators) do
        if v == source then
            table.remove(Spectators, k)
            break
        end
    end
    -- Expansion: clear per-source expansion state on disconnect. Without
    -- this, a lobby vote or a Reboot Van wait from someone who already
    -- left would keep counting/blocking for everyone else.
    ModeVotes[source] = nil
    MapVotes[source] = nil
    PlayerLoadout[source] = nil
    PlayerContract[source] = nil
    ContractStreak[source] = nil
    CarKeys[source] = nil
    PlayerCash[source] = nil
    AwaitingReboot[source] = nil
end) 
RegisterServerEvent("esx:onPlayerDeath")
AddEventHandler("esx:onPlayerDeath", function(KillData)
    if not StartMatch then return end
    local InWzNormal, InWzGulag = false, false
    for k, v in pairs(Players) do
        if v.ID == source then
            if v.ingulag then InWzGulag = true else InWzNormal = true end
        end
    end
    if not InWzNormal and not InWzGulag then return end

    -- Leaderboard: track the kill regardless of which branch this death
    -- falls into (a Gulag kill still counts), and always count a death for
    -- the victim (used for /wzstats K/D).
    local killerName = 'the Gulag'
    if KillData.killer ~= false and KillData.killer ~= "Leaved" then
        local killerPlayer = ESX.GetPlayerFromId(KillData.killer)
        if killerPlayer then
            WZ_AddStat(killerPlayer.identifier, GetPlayerName(KillData.killer), 1, 0, 0)
            killerName = GetPlayerName(KillData.killer)
            -- Expansion: server-authoritative kill reward (used to be a
            -- purely client-side `MyCash = MyCash + 500`)
            WZ_AddCash(KillData.killer, 500)
            -- Expansion: Persistent Rank XP + Battle Pass daily progress
            WZ_AwardXP(killerPlayer.identifier, Config.Rank.xpPerKill)
            WZ_BumpBattlePass(killerPlayer.identifier, 'kills', 1)
            -- Epic: Kill Feed + First Blood + MVP tracking
            MatchKillTotals[KillData.killer] = (MatchKillTotals[KillData.killer] or 0) + 1
            if not FirstBloodDone and InWzNormal then
                FirstBloodDone = true
                SendMessage('🩸 FIRST BLOOD -- '..killerName..' drew first blood!')
            end
            SendMessage((InWzGulag and '⚔️ ' or '💀 ')..killerName..' eliminated '..GetPlayerName(source)..(InWzGulag and ' (Gulag)' or ''))
        end

        -- Expansion: Pre-Match Contract -- track a no-death kill streak
        -- separately from the Killstreak-reward counter below, so a
        -- 'nodeath3' contract doesn't get consumed/reset by the UAV/airdrop
        -- streak payouts.
        ContractStreak[KillData.killer] = (ContractStreak[KillData.killer] or 0) + 1
        local contract = PlayerContract[KillData.killer]
        if contract and contract.stat == 'streak' and ContractStreak[KillData.killer] == contract.target then
            local cp = ESX.GetPlayerFromId(KillData.killer)
            if cp then WZ_AddCoins(cp.identifier, contract.reward) end
            SendNotifyServerToPlayer(KillData.killer, 'Contract complete: '..contract.label..' (+'..contract.reward..' WZCoins)', 'info')
            PlayerContract[KillData.killer] = nil
        end

        -- Expansion: Killcam -- give the victim a quick look at their
        -- killer's final position/heading (open battlefield only; a Gulag
        -- death is already a 1v1 duel the victim watched happen).
        if Config.Killcam.enabled and InWzNormal then
            local killerPed = GetPlayerPed(KillData.killer)
            if killerPed and killerPed ~= 0 then
                local kc = GetEntityCoords(killerPed)
                local kh = GetEntityHeading(killerPed)
                TriggerClientEvent('AWZ:PlayKillcam', source, kc, kh, GetPlayerName(KillData.killer))
            end
        end

        -- Feature: Killstreak rewards -- 3 kills in a row (no death) gives
        -- a free UAV, 5 gives a free airdrop, then the streak resets so it
        -- can happen again.
        KillStreak[KillData.killer] = (KillStreak[KillData.killer] or 0) + 1
        if KillStreak[KillData.killer] == Config.Killstreak.uavKills then
            TriggerClientEvent('AWZ:FreeUAV', KillData.killer)
            SendNotifyServerToPlayer(KillData.killer, Config.Killstreak.uavKills..' kills in a row -- free UAV!', 'info')
        elseif KillStreak[KillData.killer] == Config.Killstreak.airdropKills then
            TriggerClientEvent('AWZ:FreeAirdrop', KillData.killer)
            SendNotifyServerToPlayer(KillData.killer, Config.Killstreak.airdropKills..' kills in a row -- free airdrop!', 'info')
            KillStreak[KillData.killer] = 0
        end
        -- Expansion: Vehicle Killstreak -- a longer streak than the
        -- UAV/airdrop rewards grants a temporary attack helicopter.
        if Config.VehicleKillstreak.enabled and KillStreak[KillData.killer] == Config.VehicleKillstreak.kills then
            TriggerClientEvent('AWZ:VehicleKillstreak', KillData.killer)
            SendNotifyServerToPlayer(KillData.killer, Config.VehicleKillstreak.kills..' kills in a row -- attack chopper incoming!', 'info')
        end

        -- Feature: On Fire -- announce a hot streak (3+ kills inside a
        -- short window), separate from the no-death Killstreak above.
        RecentKillTimes[KillData.killer] = RecentKillTimes[KillData.killer] or {}
        table.insert(RecentKillTimes[KillData.killer], GetGameTimer())
        local cutoff = GetGameTimer() - Config.OnFire.windowMs
        local recent = {}
        for _, t in ipairs(RecentKillTimes[KillData.killer]) do
            if t >= cutoff then table.insert(recent, t) end
        end
        RecentKillTimes[KillData.killer] = recent
        if #recent == Config.OnFire.kills then
            SendMessage('🔥 '..GetPlayerName(KillData.killer)..' is ON FIRE! ('..#recent..' kills in '..math.floor(Config.OnFire.windowMs/1000)..'s)')
        end

        -- Feature: Golden Crate key -- a kill has a small chance to drop a
        -- key for the locked crate.
        if math.random(1, 100) <= Config.GoldenCrateKeyDropChance then
            PlayerKeys[KillData.killer] = (PlayerKeys[KillData.killer] or 0) + 1
            SendNotifyServerToPlayer(KillData.killer, 'You found a Golden Crate key!', 'info')
        end
        -- Expansion: Vehicle Loot -- a kill also has a chance to drop a car key
        if Config.VehicleLoot.enabled and math.random(1, 100) <= Config.VehicleLoot.keyDropChance then
            CarKeys[KillData.killer] = (CarKeys[KillData.killer] or 0) + 1
            TriggerClientEvent('AWZ:SyncCarKeys', KillData.killer, CarKeys[KillData.killer])
            SendNotifyServerToPlayer(KillData.killer, 'You found a Car Key!', 'info')
        end
    end
    ContractStreak[source] = 0 -- the victim's own no-death streak resets on death
    KillStreak[source] = 0 -- the victim's own streak resets on death
    local victimPlayer = ESX.GetPlayerFromId(source)
    if victimPlayer then
        WZ_AddStat(victimPlayer.identifier, GetPlayerName(source), 0, 0, 1)
    end
    table.insert(MatchLog, GetPlayerName(source)..' was eliminated by '..killerName)

    if InWzNormal then
        -- Normal battlefield death
        AntiCheatGrace(source) -- they may redeploy via the plane if lives remain
        TriggerClientEvent("AWZ:respwan", source, false)
        if KillData.killer ~= false and KillData.killer ~= "Leaved" then
            TriggerClientEvent("AWZ:respwan", KillData.killer, true, GetPlayerName(source), GetPlayerName(KillData.killer))
        end
    elseif InWzGulag then
        -- Death while in the Gulag: this is a real elimination. If any
        -- squadmate is still alive, send the player to spectator mode
        -- instead of exiting them straight out of the resource.
        local mates = GetAliveSquadmates(source)
        for k, v in pairs(Players) do
            if v.ID == source then
                table.remove(Players, k)
                break
            end
        end
        -- Fix: this player is done either way (fighting or spectating), so
        -- they must be removed from Squads now. Leaving them listed there
        -- while spectating meant a squad whose last real fighter had died
        -- still looked "alive" to CountSquads()/the win check forever,
        -- since the squad's entry was never emptied.
        RemovePlayerFromSquad(source)
        if #mates > 0 then
            table.insert(Spectators, source)
            TriggerClientEvent("AWZ:EnterSpectator", source, mates)
        else
            print("[WZ DEBUG] ExitMision -> "..source.." from GULAG DEATH (no alive squadmates)") TriggerClientEvent("AWZ:ExitMision", source)
        end
        Prisoner = Prisoner - 1
        if KillData.killer ~= false and KillData.killer ~= "Leaved" then
            for k, v in pairs(Players) do
                if v.ID == KillData.killer then
                    v.ingulag = false
                    Prisoner = Prisoner - 1
                end
            end
            TriggerClientEvent("AWZ:respwan", KillData.killer, true, GetPlayerName(source), GetPlayerName(KillData.killer))
            AntiCheatGrace(KillData.killer) -- Gulag winner also redeploys via the plane
            TriggerClientEvent("AWZ:Prisonbreak", KillData.killer)
        end
    end
end)
-- Returns the source IDs of `src`'s squadmates that are still alive
-- (present in Players), used to decide whether to spectate or fully exit.
function GetAliveSquadmates(src)
    local mates = {}
    for i, squad in pairs(Squads) do
        if type(squad) == 'table' then
            local isMember = false
            for _, id in pairs(squad) do
                if id == src then isMember = true end
            end
            if isMember then
                for _, id in pairs(squad) do
                    if id ~= src then
                        for _, p in pairs(Players) do
                            if p.ID == id then
                                table.insert(mates, id)
                            end
                        end
                    end
                end
                break
            end
        end
    end
    return mates
end
-- Feature: Ping System -- relay a ping to squadmates only (uses the same
-- squad lookup as spectator targets).
-- Feature: Downed State -- relay to squadmates, and validate revive
-- requests (must actually be a squadmate of the downed player).
RegisterServerEvent('AWZ:PlayerDowned')
AddEventHandler('AWZ:PlayerDowned', function(pos)
    local mates = GetAliveSquadmates(source)
    for _, mid in ipairs(mates) do
        TriggerClientEvent('AWZ:SquadmateDowned', mid, source)
    end
end)
RegisterServerEvent('AWZ:PlayerDownedTimeout')
AddEventHandler('AWZ:PlayerDownedTimeout', function()
    local mates = GetAliveSquadmates(source)
    for _, mid in ipairs(mates) do
        TriggerClientEvent('AWZ:SquadmateRevivedOrGone', mid, source)
    end
end)
RegisterServerEvent('AWZ:ReviveRequest')
AddEventHandler('AWZ:ReviveRequest', function(downedId)
    local mates = GetAliveSquadmates(downedId)
    local isMate = false
    for _, mid in ipairs(mates) do
        if mid == source then isMate = true end
    end
    if not isMate then return end
    TriggerClientEvent('AWZ:Revived', downedId, GetPlayerName(source))
    for _, mid in ipairs(mates) do
        TriggerClientEvent('AWZ:SquadmateRevivedOrGone', mid, downedId)
    end
end)
RegisterServerEvent('AWZ:SendPing')
AddEventHandler('AWZ:SendPing', function(coords, pingType)
    local mates = GetAliveSquadmates(source)
    for _, mid in ipairs(mates) do
        TriggerClientEvent('AWZ:ReceivePing', mid, coords, pingType, GetPlayerName(source))
    end
end)
RegisterServerEvent('AWZ:LeaveSpectator')
AddEventHandler('AWZ:LeaveSpectator', function()
    for k, v in pairs(Spectators) do
        if v == source then
            table.remove(Spectators, k)
            break
        end
    end
    print("[WZ DEBUG] ExitMision -> "..source.." from LEAVE SPECTATOR") TriggerClientEvent("AWZ:ExitMision", source)
end)
RegisterServerEvent("AWZ:SetRBucket")
AddEventHandler("AWZ:SetRBucket", function(Wz)
    SetPlayerRoutingBucket(source,Wz)
end)
-- Fix: this event was triggered by the client (entering the Gulag) but never
-- handled server-side, so players were never actually moved to the Gulag's
-- routing bucket and stayed visible/interactable in the main fight world.
RegisterServerEvent("Warzone:SetW")
AddEventHandler("Warzone:SetW", function(Wz)
    SetPlayerRoutingBucket(source, Wz)
end)
RegisterServerEvent("AWZ:Loadout")
AddEventHandler("AWZ:Loadout", function(loadout)
    for k,v in pairs(Players) do 
        TriggerClientEvent("AWZ:UpdateLoadout",v.ID,loadout)
    end 
end)

-------------------------------------------------------------------
-- Expansion: Custom Loadout Drop / Pre-Match Contract -- picked from the
-- /warzone menu before the match starts, applied on AWZ:StartMatch.
-------------------------------------------------------------------
RegisterServerEvent('AWZ:SetLoadoutChoice')
AddEventHandler('AWZ:SetLoadoutChoice', function(value)
    for _, opt in ipairs(Config.CustomLoadout.options) do
        if opt.value == value then PlayerLoadout[source] = opt return end
    end
end)
RegisterServerEvent('AWZ:SetContractChoice')
AddEventHandler('AWZ:SetContractChoice', function(id)
    for _, opt in ipairs(Config.PreMatchContract.options) do
        if opt.id == id then
            PlayerContract[source] = (opt.id ~= 'none') and opt or nil
            return
        end
    end
end)

-------------------------------------------------------------------
-- Expansion: a client-asserted cash gain (airdrop pickup, body loot) gets
-- folded into the server-authoritative total through one funnel with a
-- sanity cap, instead of just being trusted outright. This does not make
-- loot amounts themselves server-verified (loot is still generated
-- client-side, see the code comments in client/main.lua) but it does mean
-- no purchase can ever spend more than what actually passed through here.
-------------------------------------------------------------------
RegisterServerEvent('AWZ:AddCashSync')
AddEventHandler('AWZ:AddCashSync', function(amount)
    if type(amount) == 'number' and amount > 0 and amount <= 5000 then
        WZ_AddCash(source, amount)
    end
end)

-------------------------------------------------------------------
-- Expansion: Vehicle Loot -- spawn vehicles for the match (server-side, so
-- there's exactly one shared set instead of one per connected client),
-- lock a share of them, and let a found Car Key unlock one on request.
-- Config.SandyVehicles/IslandVehicles existed before this but nothing
-- ever spawned anything at those coordinates.
-------------------------------------------------------------------
function SpawnMatchVehicles(map)
    local list = (map == 'ISLAND') and Config.IslandVehicles or Config.SandyVehicles
    if not Config.VehicleLoot.enabled or not list then return end
    for _, coord in ipairs(list) do
        local model = Config.VehicleLoot.models[math.random(1, #Config.VehicleLoot.models)]
        local veh = CreateVehicle(GetHashKey(model), coord.x, coord.y, coord.z, 0.0, true, false)
        if veh and veh ~= 0 then
            SetVehicleOnGroundProperly(veh)
            local locked = math.random(1, 100) <= Config.VehicleLoot.lockedChance
            SetVehicleDoorsLocked(veh, locked and 2 or 1)
            table.insert(WzVehs, veh)
        end
    end
end
ESX.RegisterServerCallback('AWZ:UnlockVehicleWithKey', function(source, cb, netId)
    if (CarKeys[source] or 0) < 1 then return cb(false) end
    local veh = NetworkGetEntityFromNetworkId(netId)
    if not veh or veh == 0 then return cb(false) end
    CarKeys[source] = CarKeys[source] - 1
    TriggerClientEvent('AWZ:SyncCarKeys', source, CarKeys[source])
    SetVehicleDoorsLocked(veh, 1)
    cb(true)
end)
RegisterServerEvent('AWZ:HotwireVehicle')
AddEventHandler('AWZ:HotwireVehicle', function(netId)
    local veh = NetworkGetEntityFromNetworkId(netId)
    if veh and veh ~= 0 then SetVehicleDoorsLocked(veh, 1) end
end)

-------------------------------------------------------------------
-- Expansion: Reboot Van (squad matches only -- replaces the Gulag duel).
-- See client/main.lua SetPLayerInGulag() for where a squad member gets
-- routed here instead of into the Gulag.
-------------------------------------------------------------------
RegisterServerEvent('AWZ:RequestReboot')
AddEventHandler('AWZ:RequestReboot', function()
    local src = source
    local mates = GetAliveSquadmates(src)
    for k, v in pairs(Players) do
        if v.ID == src then table.remove(Players, k) break end
    end
    RemovePlayerFromSquad(src)
    AwaitingReboot[src] = { mates = mates }
    if #mates > 0 then
        table.insert(Spectators, src)
        TriggerClientEvent('AWZ:EnterSpectator', src, mates)
    else
        TriggerClientEvent('AWZ:ExitMision', src)
    end
end)
RegisterServerEvent('AWZ:RebootVanComplete')
AddEventHandler('AWZ:RebootVanComplete', function()
    local reviver = source
    local targetId = nil
    for downedId, info in pairs(AwaitingReboot) do
        for _, m in ipairs(info.mates) do
            if m == reviver then targetId = downedId break end
        end
        if targetId then break end
    end
    if not targetId then
        return SendNotifyServerToPlayer(reviver, 'No squadmate is waiting on the Reboot Van right now.', 'error')
    end
    AwaitingReboot[targetId] = nil
    for k, v in pairs(Spectators) do
        if v == targetId then table.remove(Spectators, k) break end
    end
    table.insert(Players, { ID = targetId, ingulag = false })
    -- put them back in the reviver's current squad
    for i, squad in pairs(Squads) do
        if type(squad) == 'table' then
            for _, id in pairs(squad) do
                if id == reviver then
                    table.insert(Squads[i], targetId)
                    goto placed
                end
            end
        end
    end
    ::placed::
    SetPlayerRoutingBucket(targetId, Config.FightWorld)
    local reviverPed = GetPlayerPed(reviver)
    TriggerClientEvent('AWZ:RebootRevive', targetId, reviverPed and GetEntityCoords(reviverPed) or nil)
    SendNotifyServerToPlayer(reviver, 'Squadmate rebooted!', 'info')
end)

ESX.RegisterServerCallback('AWZ:SetPlayerInWarZone', function(source, cb)
    local CanInsert =  true 
    for k,v in pairs(Players) do 
        if v.ID == source then 
            CanInsert = false 
        end
    end 
    if CanInsert then 
        SetPlayerRoutingBucket(source , Config.LobbeyWorld  )
        table.insert(Players , { ID = source , ingulag = false })
    end    
    print('[WZ DEBUG] AWZ:SetPlayerInWarZone source='..source..' CanInsert='..tostring(CanInsert)..' #Players now='..#Players)
     cb(CanInsert)
end)
ESX.RegisterServerCallback('AWZ:SetPlayerInGulag', function(source, cb)
    local CanInsert =  true 
    for k,v in pairs(Players) do 
        if v.ID == source then 
          v.ingulag = true 
          Prisoner = Prisoner + 1
        end
    end 
     cb(Prisoner)
end)
ESX.RegisterServerCallback('AWZ:GetPlayerInGulag', function(source, cb)
    cb(Prisoner)
end)
-- Fix: the client called this callback (when the Gulag timer runs out with no
-- opponent) but it was never registered server-side, so the prisoner never
-- actually got cleared and the Prisoner counter stayed stale.
ESX.RegisterServerCallback('AWZ:SetPlayerRemoveGulag', function(source, cb)
    for k, v in pairs(Players) do
        if v.ID == source and v.ingulag then
            v.ingulag = false
            Prisoner = Prisoner - 1
        end
    end
    cb(true)
end)
function UpdateMembers()
    CreateThread(function()
        while Event do  
            Wait(10 * 1000)
            -- Fix: this used to count live players via routing-bucket
            -- membership (GetPlayersFromWolrd), which breaks with Spectator
            -- Mode -- a spectating (eliminated) player deliberately stays in
            -- the fight world's bucket so they can see their teammates, so
            -- the bucket count would never drop for them. `#Players` is the
            -- authoritative "still competing" count (spectators are removed
            -- from it the moment they're eliminated).
            local PlayerCount = #Players
            SquadAlive = CountSquads()
            -- Epic: announce squad-count milestones once each, only for
            -- real squad matches (a solo match's "squad count" is just its
            -- player count, which would spam constantly).
            if StartMatch and Team and Team > 1 and SquadAlive ~= LastAnnouncedSquadCount then
                if SquadAlive == 5 or SquadAlive == 3 or SquadAlive == 2 then
                    SendMessage('🔥 Only '..SquadAlive..' squads remain!')
                end
                LastAnnouncedSquadCount = SquadAlive
            end
            Wait(500)
            Alive = PlayerCount
            -- Fix: with no minimum-player gate, both win checks below were
            -- trivially true from the very first check (10s after the
            -- lobby opened) whenever a match only ever had 1 player in it
            -- (e.g. solo testing) -- declaring an instant "win" and exiting
            -- the match seconds into the drop, every time. A real
            -- battle-royale win only makes sense once the match started
            -- with more than one player.
          if CountSquads()  == 1  and StartMatch and  Alive <= Team  and MatchStartCount > 1 then 
                for k ,v in pairs(Squads) do 
                    WarZoneWinner( v) 
                    DelVehs()
                    Event = false
                    StartMatch = false 
                    Lobbey = false 
                    Alive = 0
                    Prisoner = 0
                    Body = 0
                    SquadAlive = 0 
                    Team = 1 
                    Players = {}
                    WzVehs = {}
                    break 
                end 
            end 
            if PlayerCount  == 1   and StartMatch and MatchStartCount > 1 then 
                for k ,v in pairs(Players) do 
                    local Won = {}
                    table.insert(Won , v.ID )
                    Wait(500)
                    WarZoneWinner( Won ) 
                    DelVehs()
                    Event = false
                    StartMatch = false 
                    Lobbey = false 
                    Alive = 0
                    Prisoner = 0
                    Body = 0
                    SquadAlive = 0 
                    Team = 1 
                    Players = {}
                    WzVehs = {}
                    break 
                end 
            end 
            for k,v in pairs(Players) do 
                TriggerClientEvent("AWZ:UpdateAlive",v.ID,PlayerCount , SquadAlive)
            end 
        end 
    end)
end 
function DelVehs()
    CreateThread(function()
        for k,v in pairs(WzVehs) do 
            if DoesEntityExist(v) then 
             
                DeleteEntity(v)
            end 
        end 
    end)
end 

function WarZoneWinner(Winners)
    local p1 , p2 , p3 , p4 = '' , '', '' ,''
    local Squad = {}
    for k,v in pairs( Winners ) do 
        if k == 1 then 
            p1 = GetPlayerName( v )
            table.insert( Squad, v )
            Reward(v )
        elseif k == 2 then 
            p2 = GetPlayerName( v )
            table.insert( Squad, v )
            Reward(v )
        elseif k == 3 then 
            p3 = GetPlayerName( v )
            table.insert( Squad, v )
            Reward(v )
        elseif k == 4 then 
            p4 = GetPlayerName( v )
            table.insert( Squad, v )
            Reward(v )
        end 
    end 
    for k,v in pairs( Squad) do 
        TriggerClientEvent("AWZ:WinnerTeam",v , true )
        -- Leaderboard: record a win for every member of the winning squad.
        local xPlayer = ESX.GetPlayerFromId(v)
        if xPlayer then
            WZ_AddStat(xPlayer.identifier, GetPlayerName(v), 0, 1)
            -- Expansion: Persistent Rank XP + Battle Pass daily progress for the win
            WZ_AwardXP(xPlayer.identifier, Config.Rank.xpPerWin)
            WZ_BumpBattlePass(xPlayer.identifier, 'wins', 1)
            -- Expansion: Pre-Match Contract -- award the 'win the match' contract
            local contract = PlayerContract[v]
            if contract and contract.stat == 'win' then
                WZ_AddCoins(xPlayer.identifier, contract.reward)
                SendNotifyServerToPlayer(v, 'Contract complete: '..contract.label..' (+'..contract.reward..' WZCoins)', 'info')
                PlayerContract[v] = nil
            end
        end
    end 
    Wait(1000)
    TriggerClientEvent("AWZ:ShowWinner", -1  , p1 , p2 , p3 ,p4 , true , Squad    )

    -- Discord Webhook: announce the result.
    local winnerNames = {}
    for _, n in ipairs({p1, p2, p3, p4}) do
        if n ~= '' then table.insert(winnerNames, n) end
    end
    local durationMin = math.floor((os.time() - MatchStartedAt) / 60)
    SendDiscordWebhook(
        '🔫 WarZone match ended',
        '**Winners:** '..table.concat(winnerNames, ', ')..'\n**Players:** '..MatchStartCount..'\n**Duration:** '..durationMin..' min',
        3066993
    )

    -- Epic: MVP of the Match -- whoever racked up the most kills, win or lose.
    local mvpId, mvpKills = nil, 0
    for pid, kills in pairs(MatchKillTotals) do
        if kills > mvpKills then mvpId, mvpKills = pid, kills end
    end
    if mvpId and mvpKills > 0 then
        SendMessage('🏆 MVP of the Match: '..(GetPlayerName(mvpId) or ('#'..mvpId))..' with '..mvpKills..' kills!')
    end

    -- Feature: Match Replay -- save this match's event log for /wzlastmatch.
    table.insert(MatchLog, 'Winner: '..table.concat(winnerNames, ', '))
    MySQL.Async.execute([[
        INSERT INTO wz_match_history (map, player_count, winners, summary)
        VALUES (@map, @player_count, @winners, @summary)
    ]], {
        ['@map'] = CurrentMatchMap or '',
        ['@player_count'] = MatchStartCount,
        ['@winners'] = table.concat(winnerNames, ', '),
        ['@summary'] = json.encode(MatchLog),
    })

    -- Any players still in spectator mode (their squad lost, so the match
    -- ending is their cue to leave too) get sent out now.
    for k, v in pairs(Spectators) do
        print("[WZ DEBUG] ExitMision -> "..v.." from MATCH WINNER cleanup (leftover spectator)") TriggerClientEvent("AWZ:ExitMision", v)
    end
    Spectators = {}

    Event = false 
end  

-- Fix: RemovePlayerFromSquad() sets Squads[i] = nil for an eliminated squad,
-- which leaves a hole in the Squads table. Lua's `#` length operator is
-- undefined behaviour on a table with holes (it can return any valid
-- "border" index, not the real count) -- so `#Squads` could silently give
-- the wrong number of remaining squads once any squad other than the last
-- one is fully eliminated, and the "only 1 squad left" win check could
-- then never fire. This counts non-nil entries directly instead.
function CountSquads()
    local count = 0
    for k, v in pairs(Squads) do
        if type(v) == 'table' then
            count = count + 1
        end
    end
    return count
end
-- Fix: two real bugs here.
-- 1) The `Players` removal ran inside CreateThread(...), i.e. deferred to
--    the next tick instead of happening immediately. Every caller of this
--    function (AWZ:RemoveForSquad callback, the Gulag-death branch) reads
--    #Players / Squads state right around the same time, so there was a
--    window where a player who had just left/died was still counted as
--    present -- CountSquads()/the win-check thread could briefly see stale
--    numbers. Nothing here needs a Wait, so it can just run synchronously.
-- 2) Both loops called table.remove() on a table while iterating that same
--    table with pairs()/ipairs() -- table.remove() shifts every later
--    array index down by one, which is more than "setting an existing
--    field", and the Lua manual only guarantees next() behaves if you set
--    existing fields (including to nil), not if you reshuffle them mid-
--    traversal. In practice this risks silently skipping the element right
--    after the one removed. Since each id can only appear once, this finds
--    the index first and removes it after the loop ends instead.
function RemovePlayerFromSquad ( src )
    if #Squads  ~= 0  and #Players ~= 0 then 
        for k,v in pairs(Players) do 
            if v.ID == src then 
                table.remove(Players , k) 
                break 
            end 
        end 
        for i,m in pairs(Squads) do 
            if type( Squads[i] ) == 'table'  then 
                local removeAt = nil
                for k,v in pairs(Squads[i]) do 
                    if v == src then 
                        removeAt = k
                        break 
                    end 
                end 
                if removeAt then 
                    table.remove(Squads[i] , removeAt) 
                end 
                if #Squads[i] == 0 then 
                    Squads[i] = nil 
                    -- Epic: announce a full squad wipe (only during a live
                    -- match with actual squads, not a solo lobby cleanup)
                    if StartMatch and Team and Team > 1 then
                        SendMessage('☠️ A squad has been wiped out! '..CountSquads()..' squad(s) remain.')
                    end
                 end 
            end 
        end 
    end 
end 
-- Feature: Golden Crate key -- spend one to open a locked crate.
ESX.RegisterServerCallback('AWZ:UseGoldenKey', function(source, cb)
    if (PlayerKeys[source] or 0) > 0 then
        PlayerKeys[source] = PlayerKeys[source] - 1
        cb(true)
    else
        cb(false)
    end
end)
ESX.RegisterServerCallback('AWZ:RemoveForSquad', function(source, cb)
    RemovePlayerFromSquad ( source  )
    cb(true)
end)

RegisterNetEvent("WarZone:SetBodyBox")
AddEventHandler("WarZone:SetBodyBox",function(Weapons , Coords)
CreateThread(function()
    local Weapons = Weapons
    local Coords = Coords
    Wait(5000)
    Body = Body + 1
    for k,v in pairs(Players) do 
        TriggerClientEvent("WarZone:GetBoxLoot", v.ID ,Weapons , Coords , Body )
    end 
end)
end) 
RegisterNetEvent("WarZone:SyncDelBox")
AddEventHandler("WarZone:SyncDelBox",function( codeBox )
    for k,v in pairs(Players) do
        TriggerClientEvent("WarZone:clSyncDelBox", v.ID  ,codeBox)
    end 
end)
function SendMessage( msg )
    local template = '<div style="padding: 0.5vw; margin: 0.5vw; background-color:rgba(255, 0, 0, 0.4);  border-radius: 3px;">🔫 WarZone   <br> '..msg..' <br> </div>'
    -- Fix: the default chat resource's detectChannel() does table.concat(args, ...),
    -- so `args` must be a table -- passing a string (".") crashed cl_chat.lua
    -- every time this function ran (e.g. on /startwarzone).
    TriggerClientEvent('chat:addMessage', -1 , {template = template ,args = {}})
end 
-------------------------------------------------------------------
-- Anti-Cheat (simple): samples each in-match player's position every
-- Config.AntiCheat.checkIntervalMs and flags anyone moving faster than
-- Config.AntiCheat.maxSpeed. This is intentionally basic (alert-only by
-- default) -- it resets its own tracking whenever a player's Gulag state
-- changes, since entering/leaving the Gulag is a legitimate long-distance
-- teleport that would otherwise always false-positive.
-------------------------------------------------------------------
local AntiCheatLastPos = {}
local AntiCheatLastGulag = {}
-- Fix: the plane drop (initial spawn AND every mid-life redeploy) and its
-- parachute flight legitimately cover a lot of ground fast -- easily
-- 300+ km/h -- which is exactly what triggered a false "speed hack" alert
-- during normal testing. Give each player a grace window (no anti-cheat
-- checks) whenever a drop sequence is about to start for them.
local AntiCheatGraceUntil = {}
function AntiCheatGrace(src)
    AntiCheatGraceUntil[src] = GetGameTimer() + Config.AntiCheat.dropGraceMs
end
function AntiCheatMonitor()
    if not Config.AntiCheat.enabled then return end
    CreateThread(function()
        AntiCheatLastPos = {}
        AntiCheatLastGulag = {}
        while StartMatch do
            Wait(Config.AntiCheat.checkIntervalMs)
            for _, p in ipairs(Players) do
                local ped = GetPlayerPed(p.ID)
                if ped and ped ~= 0 and DoesEntityExist(ped) then
                    local coords = GetEntityCoords(ped)
                    local last = AntiCheatLastPos[p.ID]
                    local gulagChanged = AntiCheatLastGulag[p.ID] ~= nil and AntiCheatLastGulag[p.ID] ~= p.ingulag
                    local inGrace = (AntiCheatGraceUntil[p.ID] or 0) > GetGameTimer()
                    if last and not gulagChanged and not inGrace then
                        local dist = #(coords - last.coords)
                        local dt = (GetGameTimer() - last.time) / 1000.0
                        if dt > 0.1 then
                            local speed = dist / dt
                            if speed > Config.AntiCheat.maxSpeed then
                                local msg = (GetPlayerName(p.ID) or ('#'..p.ID))..' moved '..math.floor(dist)..'m in '..string.format('%.1f', dt)..'s (~'..math.floor(speed)..' m/s) in WarZone -- possible speed/teleport hack'
                                print('[WZ ANTICHEAT] '..msg)
                                SendDiscordWebhook('⚠️ Possible cheat detected', msg, 15158332)
                                for _, adminId in ipairs(GetPlayers()) do
                                    local aid = tonumber(adminId)
                                    if IsPlayerCanStart(aid) then
                                        SendNotifyServerToPlayer(aid, msg, 'error')
                                    end
                                end
                                if Config.AntiCheat.action == 'kick' then
                                    DropPlayer(p.ID, 'Kicked: suspicious movement detected in WarZone')
                                end
                            end
                        end
                    end
                    AntiCheatLastPos[p.ID] = {coords = coords, time = GetGameTimer()}
                    AntiCheatLastGulag[p.ID] = p.ingulag
                end
            end
        end
    end)
end

function GetPlayersFromWolrd( Wolrd )
    local xPlayers = ESX.GetPlayers()
    local Players = 0 
    for k, v in pairs (xPlayers) do 
        if GetPlayerRoutingBucket(v) == Wolrd then
            Players = Players + 1 
        end 
    end 
    return Players
end

ESX.RegisterServerCallback('setweapons', function(source, cb, weapons)
    local xPlayer = ESX.GetPlayerFromId(source)
    if weapons then
        for k,v in pairs(weapons) do
            xPlayer.addWeapon(v.name, v.ammo)
            for kk,vv in pairs(v.components) do 
                xPlayer.addWeaponComponent(v.name, vv)
            end
        end
        cb(true)
    end
end)



