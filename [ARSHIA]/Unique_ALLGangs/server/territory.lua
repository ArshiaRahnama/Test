-------------------------------------------------------------------
-- TERRITORY CONTROL (add-on)
-- ---------------------------------------------------------------
-- Gives gangs a reason to be active even when nobody's actively
-- planning a heist: a handful of fixed zones (Config.Territory.Zones)
-- pay dirty money to whichever gang holds them, but holding one means
-- physically defending it.
--
-- Server-authoritative by design:
--   - Ownership, capture progress and timers all live ONLY here.
--   - Clients only ever send their own coords + which zone they claim
--     to be standing in (Territory:Ping); this file re-checks the
--     distance itself before trusting it (see Territory:Ping below),
--     so a modified client can't fake capturing a zone from across
--     the map or skip the timer.
--   - A zone can only make capture progress while EXACTLY ONE gang
--     has members present - the moment a second gang shows up it's
--     "contested" and progress freezes. That's the entire war
--     mechanic: to flip a zone you have to hold it alone, which
--     usually means clearing whoever else is standing on it.
--
-- Plugs into systems that already exist in this resource instead of
-- duplicating them:
--   - Income is paid as BLACKMONEY (AddGangBlackMoney, server/boss.lua)
--     - a boss has to run it through the existing washMoney flow to
--     spend it, which is what already feeds Config.FederalCase's
--     WashMoneyThreshold. More territory = more laundering = more
--     federal heat, with zero extra code needed for that part.
--   - Captures/losses/vulnerable-alerts are logged through the SAME
--     SendLog(...)/GetCategoryWebhook(...) pipeline every other boss
--     action uses (server/main.lua) - just add a "Territory" webhook
--     from the boss menu's existing "Set Log Webhook" UI and it's
--     wired in, no new UI needed.
--   - Adds a second AddEventHandler onto the EXISTING
--     'FMGangs:ReportGangShotFired' event (server/Gangs.lua,
--     client/gangwar.lua) instead of touching that file - if a
--     detected gang shootout happens inside someone's territory, it
--     gets a log entry. Multiple AddEventHandlers on the same event
--     name is normal FiveM behaviour; both run.
-------------------------------------------------------------------

Territories     = {} -- Territories[zoneKey] = { owner, captured_at, contested, vulnerable, vulnerable_until, lastCombatLog }
ZoneConfigByKey = {}
local ZoneProgress = {} -- ZoneProgress[zoneKey] = { gang = 'name', seconds = n } - progress of the gang currently alone in a contested/neutral zone
local LastPing      = {} -- LastPing[source] = { zone = 'key', gang = 'name', t = os.time() }

for _, zoneCfg in ipairs((Config.Territory and Config.Territory.Zones) or {}) do
    ZoneConfigByKey[zoneCfg.key] = zoneCfg
    Territories[zoneCfg.key] = {
        owner = nil,
        captured_at = 0,
        contested = false,
        vulnerable = false,
        vulnerable_until = 0,
        lastCombatLog = 0,
    }
end

-------------------------------------------------------------------
-- Boss Zone (system 4) registers into the SAME Territories/ZoneConfigByKey
-- tables as the regular zones above - it's deliberately just one more
-- entry with `bossZone = true` on its config, so every existing piece
-- of logic (capture, contest, blips, leaderboard) already handles it
-- for free. Only the tick loop treats it differently (see
-- IsBossZoneOpen below): outside its weekly window it's simply never
-- eligible to make capture progress.
-------------------------------------------------------------------
if Config.Territory and Config.Territory.BossZone and Config.Territory.BossZone.Enabled then
    local bz = Config.Territory.BossZone
    ZoneConfigByKey[bz.key] = bz
    Territories[bz.key] = {
        owner = nil,
        captured_at = 0,
        contested = false,
        vulnerable = false,
        vulnerable_until = 0,
        lastCombatLog = 0,
    }
end

function BroadcastTerritoryState()
    local out = {}
    for zoneKey, state in pairs(Territories) do
        out[zoneKey] = { owner = state.owner, contested = state.contested, vulnerable = state.vulnerable }
    end
    TriggerClientEvent('Territory:SyncState', -1, out)
end

function CountGangZones(gang)
    local count = 0
    for _, state in pairs(Territories) do
        if state.owner == gang then count = count + 1 end
    end
    return count
end

-------------------------------------------------------------------
-- Shared state + helpers for the 6 expansion systems. Declared here
-- (before ProcessTerritoryTick) since the tick loop needs to read
-- alliances/upgrades/war-night/boss-zone-window every pass.
-------------------------------------------------------------------
local ZoneUpgrades  = {} -- ZoneUpgrades[zoneKey][upgradeType] = level
local Alliances     = {} -- Alliances[gangA][gangB] = true (stored both directions once active)
local ZoneTitles    = {} -- ZoneTitles[gang] = 'title text' (Boss Zone reward)
local ScoutCooldown = {} -- ScoutCooldown[source] = os.time() of last scout
local SabotageCooldown = {} -- SabotageCooldown['gang:zoneKey'] = os.time() of last sabotage

local function AreGangsAllied(gangA, gangB)
    if not gangA or not gangB or gangA == gangB then return gangA == gangB end
    if not Config.Territory.Alliance or not Config.Territory.Alliance.Enabled then return false end
    return (Alliances[gangA] and Alliances[gangA][gangB]) == true
end

-- Groups a zone's distinct present gangs into "sides" - allied gangs
-- collapse into the SAME side, so a zone stays capturable/defendable
-- by a coalition instead of instantly freezing the moment an ally
-- shows up to help. Returns the number of distinct SIDES and, when
-- exactly one, that side's "primary" gang (whichever owns the zone if
-- one of them does, else just the first one found) plus the full list
-- of gangs on that side (for crediting/notifying all of them).
local function GroupPresentGangsIntoSides(distinctGangs)
    local sides = {} -- list of { gangs = { ... } }
    for _, gang in ipairs(distinctGangs) do
        local placed = false
        for _, side in ipairs(sides) do
            for _, existing in ipairs(side.gangs) do
                if AreGangsAllied(existing, gang) then
                    side.gangs[#side.gangs + 1] = gang
                    placed = true
                    break
                end
            end
            if placed then break end
        end
        if not placed then
            sides[#sides + 1] = { gangs = { gang } }
        end
    end
    return sides
end

local function IsWarNight()
    local wn = Config.Territory.WarNight
    if not wn or not wn.Enabled then return false end
    local t = os.date('*t')
    if t.wday ~= wn.day then return false end
    return t.hour >= wn.startHour and t.hour < wn.endHour
end

local function IsBossZoneOpen()
    local bz = Config.Territory.BossZone
    if not bz or not bz.Enabled then return false end
    local t = os.date('*t')
    if t.wday ~= bz.openDay then return false end
    return t.hour >= bz.openHour and t.hour < (bz.openHour + bz.openDurationHours)
end

local function GetUpgradeLevel(zoneKey, upgradeType)
    return (ZoneUpgrades[zoneKey] and ZoneUpgrades[zoneKey][upgradeType]) or 0
end

-- How long a challenger must hold a zone alone, after stacking every
-- modifier that changes it: base -> vulnerable window -> fortify
-- upgrade (defender's investment) -> catch-up (challenger is behind)
-- -> war night (server-wide push). Order matters for fairness: the
-- defender's fortify bonus is applied before the challenger's
-- catch-up discount, so a well-invested zone is never trivially free
-- just because the challenger happens to own nothing yet.
local function EffectiveCaptureSeconds(zoneKey, state, challengerGang)
    local base = state.vulnerable and (Config.Territory.VulnerableCaptureSeconds or 120) or (Config.Territory.CaptureSeconds or 240)

    if Config.Territory.Upgrades and Config.Territory.Upgrades.Enabled then
        local fortifyLevel = GetUpgradeLevel(zoneKey, 'fortify')
        if fortifyLevel > 0 then
            base = base * (1 + fortifyLevel * (Config.Territory.Upgrades.fortify.captureTimeBonusPerLevel or 0))
        end
    end

    if Config.Territory.CatchUp and Config.Territory.CatchUp.Enabled then
        local ownedByChallenger = CountGangZones(challengerGang)
        if ownedByChallenger == 0 then
            base = base * (Config.Territory.CatchUp.ZeroZonesMultiplier or 1)
        else
            local totalZones, gangsWithZones = 0, 0
            local seen = {}
            for _, st in pairs(Territories) do
                if st.owner and not seen[st.owner] then
                    seen[st.owner] = true
                    gangsWithZones = gangsWithZones + 1
                end
                if st.owner then totalZones = totalZones + 1 end
            end
            local average = gangsWithZones > 0 and (totalZones / gangsWithZones) or 0
            if average > 0 and ownedByChallenger < average then
                base = base * (Config.Territory.CatchUp.BelowAverageMultiplier or 1)
            end
        end
    end

    if IsWarNight() then
        base = base * (Config.Territory.WarNight.captureMultiplier or 1)
    end

    return base
end

-------------------------------------------------------------------
-- Load saved ownership after Config-defined zones are in memory.
-- Registered here so it doesn't depend on load order against
-- server/Gangs.lua's own MySQL.ready block - both just get called
-- once oxmysql/mysql-async is actually ready, in registration order.
-------------------------------------------------------------------
MySQL.ready(function()
    if not Config.Territory or not Config.Territory.Enabled then return end
    MySQL.Async.fetchAll('SELECT zone_key, owner_gang, captured_at FROM gang_territories', {}, function(rows)
        for _, row in ipairs(rows or {}) do
            if Territories[row.zone_key] then
                local owner = row.owner_gang
                if owner == nil or owner == '' then owner = nil end -- explicit, so a stray '' from the DB can never end up stored as owner
                Territories[row.zone_key].owner = owner
                Territories[row.zone_key].captured_at = tonumber(row.captured_at) or 0
            end
        end
        BroadcastTerritoryState()
    end)

    if Config.Territory.Upgrades and Config.Territory.Upgrades.Enabled then
        MySQL.Async.fetchAll('SELECT zone_key, upgrade_type, level FROM gang_territory_upgrades', {}, function(rows)
            for _, row in ipairs(rows or {}) do
                ZoneUpgrades[row.zone_key] = ZoneUpgrades[row.zone_key] or {}
                ZoneUpgrades[row.zone_key][row.upgrade_type] = tonumber(row.level) or 0
            end
        end)
    end

    if Config.Territory.Alliance and Config.Territory.Alliance.Enabled then
        MySQL.Async.fetchAll("SELECT gang_a, gang_b FROM gang_alliances WHERE status = 'active'", {}, function(rows)
            for _, row in ipairs(rows or {}) do
                Alliances[row.gang_a] = Alliances[row.gang_a] or {}
                Alliances[row.gang_a][row.gang_b] = true
                Alliances[row.gang_b] = Alliances[row.gang_b] or {}
                Alliances[row.gang_b][row.gang_a] = true
            end
        end)
    end

    MySQL.Async.fetchAll('SELECT gang, title FROM gang_territory_titles', {}, function(rows)
        for _, row in ipairs(rows or {}) do
            ZoneTitles[row.gang] = row.title
        end
    end)
end)

-------------------------------------------------------------------
-- Ownership sanity sweep - if a zone's owner gang was disbanded or
-- deleted (server/Gangs.lua's DisbandGang/DeleteGang, or a gang that
-- simply expired) since the last time this checked, Gangs[owner] no
-- longer exists. Rather than hook those callbacks directly (would
-- mean editing Gangs.lua), this just periodically confirms every
-- zone's current owner still exists and releases the zone back to
-- neutral if not - so a dead gang can never permanently squat a zone.
-------------------------------------------------------------------
local function ValidateZoneOwners()
    local changed = false
    for zoneKey, state in pairs(Territories) do
        if state.owner and not Gangs[state.owner] then
            state.owner = nil
            state.captured_at = 0
            state.vulnerable = false
            state.vulnerable_until = 0
            changed = true
            MySQL.Async.execute('UPDATE gang_territories SET owner_gang = NULL, captured_at = 0 WHERE zone_key = @zone_key', {
                ['@zone_key'] = zoneKey,
            })
            -- Same rule as a normal capture-by-someone-else: a disbanded
            -- gang's investment in the zone doesn't linger for whoever
            -- takes it next.
            if ZoneUpgrades[zoneKey] then
                ZoneUpgrades[zoneKey] = nil
                MySQL.Async.execute('DELETE FROM gang_territory_upgrades WHERE zone_key = @zone_key', { ['@zone_key'] = zoneKey })
            end
        end
    end
    if changed then BroadcastTerritoryState() end
end

CreateThread(function()
    while true do
        Wait(300000) -- every 5 minutes
        if Config.Territory and Config.Territory.Enabled then
            ValidateZoneOwners()
        end
    end
end)

-------------------------------------------------------------------
-- Client presence ping. Re-validates distance server-side against
-- the zone's OWN config radius (+small tolerance for lag) before
-- accepting it - never trusts the client's claim of "I'm in zone X"
-- on its own.
-------------------------------------------------------------------
RegisterServerEvent('Territory:Ping')
AddEventHandler('Territory:Ping', function(zoneKey, x, y, z)
    if not Config.Territory or not Config.Territory.Enabled then return end
    local src = source
    local cfg = ZoneConfigByKey[zoneKey]
    if not cfg then return end
    if type(x) ~= 'number' or type(y) ~= 'number' or type(z) ~= 'number' then return end

    local xPlayer = ESX.GetPlayerFromId(src)
    if not xPlayer or not xPlayer.gang or xPlayer.gang.name == 'nogang' then return end

    local dx, dy, dz = x - cfg.coord.x, y - cfg.coord.y, z - cfg.coord.z
    if math.sqrt(dx * dx + dy * dy + dz * dz) > (cfg.radius + 10.0) then return end -- reject spoofed/out-of-range pings

    LastPing[src] = { zone = zoneKey, gang = xPlayer.gang.name, t = os.time() }
end)

AddEventHandler('playerDropped', function()
    LastPing[source] = nil
end)

-------------------------------------------------------------------
-- Capture: persists ownership, logs both sides, broadcasts the new
-- state to everyone, notifies both gangs, and sends a Discord log
-- through the resource's existing per-category webhook system.
-------------------------------------------------------------------
function CaptureZone(zoneKey, newGang, actorSource)
    local state = Territories[zoneKey]
    local cfg = ZoneConfigByKey[zoneKey]
    if not state or not cfg then return end

    local oldGang = state.owner
    state.owner = newGang
    state.captured_at = os.time()
    state.vulnerable = false
    state.vulnerable_until = 0

    MySQL.Async.execute([[
        INSERT INTO gang_territories (zone_key, owner_gang, captured_at) VALUES (@zone_key, @owner, @ts)
        ON DUPLICATE KEY UPDATE owner_gang = @owner, captured_at = @ts
    ]], {
        ['@zone_key'] = zoneKey, ['@owner'] = newGang, ['@ts'] = state.captured_at,
    })
    MySQL.Async.execute('INSERT INTO gang_territory_log (zone_key, gang, action, ts) VALUES (@zone_key, @gang, @action, @ts)', {
        ['@zone_key'] = zoneKey, ['@gang'] = newGang, ['@action'] = 'captured', ['@ts'] = state.captured_at,
    })
    if oldGang and oldGang ~= newGang then
        MySQL.Async.execute('INSERT INTO gang_territory_log (zone_key, gang, action, ts) VALUES (@zone_key, @gang, @action, @ts)', {
            ['@zone_key'] = zoneKey, ['@gang'] = oldGang, ['@action'] = 'lost', ['@ts'] = state.captured_at,
        })

        -- Upgrades belong to whoever built them - losing the zone to a
        -- DIFFERENT gang wipes the investment (the new owner starts from
        -- zero), which is what makes holding a zone long-term matter
        -- more than just owning it for a moment.
        if ZoneUpgrades[zoneKey] then
            ZoneUpgrades[zoneKey] = nil
            MySQL.Async.execute('DELETE FROM gang_territory_upgrades WHERE zone_key = @zone_key', { ['@zone_key'] = zoneKey })
        end
    end

    if cfg.bossZone then
        local bz = Config.Territory.BossZone
        if bz.rewardBlackMoney and bz.rewardBlackMoney > 0 then
            AddGangBlackMoney(newGang, bz.rewardBlackMoney)
        end
        if bz.titleReward then
            ZoneTitles[newGang] = bz.titleReward
            MySQL.Async.execute([[
                INSERT INTO gang_territory_titles (gang, title, earned_at) VALUES (@gang, @title, @ts)
                ON DUPLICATE KEY UPDATE title = @title, earned_at = @ts
            ]], { ['@gang'] = newGang, ['@title'] = bz.titleReward, ['@ts'] = state.captured_at })
        end
        TriggerClientEvent(Config.showAdvancedNotification, -1, '~p~Ghalamroye Padeshah', '~p~Fath shod!', 'Gang "' .. newGang .. '" Ghalamroye Padeshah ro tasarrof kard va laghabe "' .. (bz.titleReward or '') .. '" ro be dast avard!', 'CHAR_MP_DETONATEPHONE', 9)
    end

    BroadcastTerritoryState()

    for _, playerId in ipairs(ESX.GetPlayers()) do
        local xTarget = ESX.GetPlayerFromId(playerId)
        if xTarget and xTarget.gang then
            if xTarget.gang.name == newGang then
                TriggerClientEvent(Config.showAdvancedNotification, playerId, '~g~Ghalamro', '~g~Tasarrof shod', 'Gang-e shoma mantaghe "' .. cfg.label .. '" ro tasarrof kard!', 'CHAR_MP_DETONATEPHONE', 9)
            elseif oldGang and xTarget.gang.name == oldGang then
                TriggerClientEvent(Config.showAdvancedNotification, playerId, '~r~Ghalamro', '~r~Az dast raft', 'Mantaghe "' .. cfg.label .. '" az control-e gang-e shoma kharej shod!', 'CHAR_MP_DETONATEPHONE', 9)
            end
        end
    end

    if actorSource then
        local xActor = ESX.GetPlayerFromId(actorSource)
        if xActor then
            local ids = ExtractIdentifiers(actorSource)
            SendLog({
                playerid   = actorSource,
                identifier = ids and ids.steam or '-',
                discord    = ids and ids.discord or '-',
                category   = 'Territory',
                Text       = 'Captured territory "' .. cfg.label .. '" (Tier ' .. tostring(cfg.tier) .. ')' .. (oldGang and (' from "' .. oldGang .. '"') or ''),
                gang       = newGang,
                IconURL    = Gangs[newGang] and Gangs[newGang].logo,
                Webhook    = GetCategoryWebhook(newGang, 'Territory'),
            })
        end
    end
end

-------------------------------------------------------------------
-- Main tick: reads the last few seconds of presence pings, groups
-- present gangs into SIDES (allies collapse together - system 5),
-- works out who (if any single side) is holding each zone, and
-- advances capture progress accordingly, with every modifier from
-- systems 1/3/4/6 folded into the required time via
-- EffectiveCaptureSeconds. This is the only place ownership changes.
-------------------------------------------------------------------
local function ProcessTerritoryTick()
    local now = os.time()
    local staleAfter = Config.Territory.PingStaleSeconds or 12
    local tickSeconds = (Config.Territory.TickIntervalMs or 5000) / 1000

    local zoneGangCounts = {} -- [zoneKey][gang] = count
    local zoneGangActor  = {} -- [zoneKey][gang] = last source seen there

    for src, ping in pairs(LastPing) do
        if now - ping.t <= staleAfter then
            zoneGangCounts[ping.zone] = zoneGangCounts[ping.zone] or {}
            zoneGangCounts[ping.zone][ping.gang] = (zoneGangCounts[ping.zone][ping.gang] or 0) + 1
            zoneGangActor[ping.zone] = zoneGangActor[ping.zone] or {}
            zoneGangActor[ping.zone][ping.gang] = src
        else
            LastPing[src] = nil
        end
    end

    for zoneKey, state in pairs(Territories) do
        local cfg = ZoneConfigByKey[zoneKey]

        if cfg and cfg.bossZone and not IsBossZoneOpen() then
            -- Closed for the week: never eligible for progress, and any
            -- progress from right before it closed doesn't carry over.
            state.contested = false
            ZoneProgress[zoneKey] = nil
        else
            local gangsPresent = zoneGangCounts[zoneKey] or {}
            local distinct = {}
            for g in pairs(gangsPresent) do distinct[#distinct + 1] = g end

            -- Alarm upgrade (system 1): the instant a non-allied gang is
            -- detected in a zone the owner controls, ping the owner live -
            -- independent of whether it ends up contested this tick.
            if state.owner and Config.Territory.Upgrades and Config.Territory.Upgrades.Enabled
            and GetUpgradeLevel(zoneKey, 'alarm') > 0 then
                local intruderFound = false
                for _, g in ipairs(distinct) do
                    if g ~= state.owner and not AreGangsAllied(g, state.owner) then intruderFound = true break end
                end
                if intruderFound and now - (state.lastAlarm or 0) > 300 then -- throttle: 1 alert / 5 min / zone
                    state.lastAlarm = now
                    for _, playerId in ipairs(ESX.GetPlayers()) do
                        local xTarget = ESX.GetPlayerFromId(playerId)
                        if xTarget and xTarget.gang and xTarget.gang.name == state.owner then
                            TriggerClientEvent(Config.showAdvancedNotification, playerId, '~r~Hoshdar!', '~r~Nofooz shenasaei shod', 'Ye grouh-e nashenas vared-e ghalamro "' .. cfg.label .. '" shode!', 'CHAR_MP_DETONATEPHONE', 9)
                        end
                    end
                end
            end

            local sides = GroupPresentGangsIntoSides(distinct)

            if #sides == 0 then
                -- nobody there - leave progress as-is, nothing to evaluate this tick
            elseif #sides >= 2 then
                state.contested = true
                ZoneProgress[zoneKey] = nil
            else
                state.contested = false
                local sideGangs = sides[1].gangs

                local ownerOnThisSide = false
                for _, g in ipairs(sideGangs) do
                    if g == state.owner then ownerOnThisSide = true break end
                end

                if ownerOnThisSide then
                    ZoneProgress[zoneKey] = nil -- owner (or an ally) reinforcing, nothing to contest
                else
                    -- Credit progress to whichever single gang on this side
                    -- has the most members present this tick - matters for
                    -- MaxZonesPerGang and for who ends up owning the zone.
                    local creditedGang, bestCount = sideGangs[1], -1
                    for _, g in ipairs(sideGangs) do
                        local c = gangsPresent[g] or 0
                        if c > bestCount then bestCount, creditedGang = c, g end
                    end

                    if CountGangZones(creditedGang) >= (Config.Territory.MaxZonesPerGang or 999) then
                        -- that gang is at its territory cap - no progress accrues until they drop one
                    else
                        local prog = ZoneProgress[zoneKey]
                        if not prog or prog.gang ~= creditedGang then
                            prog = { gang = creditedGang, seconds = 0 }
                            ZoneProgress[zoneKey] = prog
                        end
                        prog.seconds = prog.seconds + tickSeconds

                        local needed = EffectiveCaptureSeconds(zoneKey, state, creditedGang)
                        if prog.seconds >= needed then
                            local actor = zoneGangActor[zoneKey] and zoneGangActor[zoneKey][creditedGang]
                            ZoneProgress[zoneKey] = nil
                            CaptureZone(zoneKey, creditedGang, actor)
                        end
                    end
                end
            end
        end
    end
end

CreateThread(function()
    while true do
        Wait(Config.Territory and Config.Territory.TickIntervalMs or 5000)
        if Config.Territory and Config.Territory.Enabled then
            ProcessTerritoryTick()
        end
    end
end)

-------------------------------------------------------------------
-- Hourly (configurable) income: pays every owned zone's tier income
-- into the owning gang's BLACKMONEY pool - has to be washed through
-- the existing boss "Wash Money" action like any other dirty money.
-- Folds in the production upgrade bonus, an active sabotage penalty,
-- and the war night multiplier. The Boss Zone never pays periodic
-- income - its payout is the one-time capture reward in CaptureZone.
-------------------------------------------------------------------
local function DistributeTerritoryIncome()
    local warNight = IsWarNight()
    local totals = {}

    for zoneKey, state in pairs(Territories) do
        local cfg = ZoneConfigByKey[zoneKey]
        if state.owner and cfg and not cfg.bossZone then
            local amount = Config.Territory.TierIncome and Config.Territory.TierIncome[cfg.tier] or 0

            if Config.Territory.Upgrades and Config.Territory.Upgrades.Enabled then
                local prodLevel = GetUpgradeLevel(zoneKey, 'production')
                if prodLevel > 0 then
                    amount = amount * (1 + prodLevel * (Config.Territory.Upgrades.production.incomeBonusPerLevel or 0))
                end
            end

            if Config.Territory.Sabotage and Config.Territory.Sabotage.Enabled
            and state.sabotagedUntil and state.sabotagedUntil > os.time() then
                amount = amount * (1 - (Config.Territory.Sabotage.IncomeReductionPercent or 0) / 100)
            end

            if warNight then
                amount = amount * (Config.Territory.WarNight.incomeMultiplier or 1)
            end

            amount = math.floor(amount)
            if amount > 0 then
                totals[state.owner] = (totals[state.owner] or 0) + amount
            end
        end
    end

    for gang, amount in pairs(totals) do
        if AddGangBlackMoney(gang, amount) then
            for _, playerId in ipairs(ESX.GetPlayers()) do
                local xTarget = ESX.GetPlayerFromId(playerId)
                if xTarget and xTarget.gang and xTarget.gang.name == gang then
                    TriggerClientEvent(Config.showAdvancedNotification, playerId, '~y~Ghalamro', '~y~Daramad-e ghalamro', 'Ghalamro-haye gang-e shoma $' .. amount .. ' pool-e kasif variz kard.', 'CHAR_MP_DETONATEPHONE', 9)
                end
            end
        end
    end
end

CreateThread(function()
    while true do
        Wait((Config.Territory and Config.Territory.IncomeIntervalMinutes or 60) * 60000)
        if Config.Territory and Config.Territory.Enabled then
            DistributeTerritoryIncome()
        end
    end
end)

-------------------------------------------------------------------
-- Vulnerable window: every 90-180 min (configurable), one random
-- OWNED zone becomes easier to steal for a while and its owner gets
-- warned - gives gangs a reason to keep checking in even when no one
-- is actively pushing a war.
-------------------------------------------------------------------
local function TriggerVulnerableEvent()
    local owned = {}
    for zoneKey, state in pairs(Territories) do
        if state.owner and not state.vulnerable then owned[#owned + 1] = zoneKey end
    end
    if #owned == 0 then return end

    local zoneKey = owned[math.random(1, #owned)]
    local state = Territories[zoneKey]
    local cfg = ZoneConfigByKey[zoneKey]
    state.vulnerable = true
    state.vulnerable_until = os.time() + (Config.Territory.VulnerableWindowSeconds or 600)

    for _, playerId in ipairs(ESX.GetPlayers()) do
        local xTarget = ESX.GetPlayerFromId(playerId)
        if xTarget and xTarget.gang and xTarget.gang.name == state.owner then
            TriggerClientEvent(Config.showAdvancedNotification, playerId, '~r~Hoshdar-e ghalamro', '~r~Dar khatar!', 'Mantaghe "' .. cfg.label .. '" hadaf-e hamle-ye ehtemali gharar gerefte - az an defa konid!', 'CHAR_MP_DETONATEPHONE', 9)
        end
    end

    SendLog({
        playerid = 'SYSTEM', identifier = '-', discord = '-',
        category = 'Territory',
        Text = 'Zone "' .. cfg.label .. '" flagged vulnerable for ' .. math.floor((Config.Territory.VulnerableWindowSeconds or 600) / 60) .. ' minutes (faster to capture)',
        gang = state.owner,
        IconURL = Gangs[state.owner] and Gangs[state.owner].logo,
        Webhook = GetCategoryWebhook(state.owner, 'Territory'),
    })

    BroadcastTerritoryState()

    SetTimeout((Config.Territory.VulnerableWindowSeconds or 600) * 1000, function()
        if Territories[zoneKey] and Territories[zoneKey].vulnerable then
            Territories[zoneKey].vulnerable = false
            BroadcastTerritoryState()
        end
    end)
end

CreateThread(function()
    while true do
        local minM = Config.Territory and Config.Territory.VulnerableEventMinMinutes or 90
        local maxM = Config.Territory and Config.Territory.VulnerableEventMaxMinutes or 180
        Wait(math.random(minM, maxM) * 60000)
        if Config.Territory and Config.Territory.Enabled then
            TriggerVulnerableEvent()
        end
    end
end)

-------------------------------------------------------------------
-- Reuses the shootout detector that already exists for GangWar
-- (server/Gangs.lua, event fired from client/gangwar.lua) WITHOUT
-- touching that file - just an extra listener on the same event
-- name. If the shots landed inside someone's territory, it's worth a
-- log entry so a boss watching the webhook sees their turf is under
-- fire even if they're offline.
-------------------------------------------------------------------
AddEventHandler('FMGangs:ReportGangShotFired', function(x, y, z)
    if not Config.Territory or not Config.Territory.Enabled then return end
    if type(x) ~= 'number' or type(y) ~= 'number' or type(z) ~= 'number' then return end

    for zoneKey, cfg in pairs(ZoneConfigByKey) do
        local dx, dy, dz = x - cfg.coord.x, y - cfg.coord.y, z - cfg.coord.z
        if math.sqrt(dx * dx + dy * dy + dz * dz) <= cfg.radius then
            local state = Territories[zoneKey]
            if state and state.owner then
                local now = os.time()
                if now - (state.lastCombatLog or 0) > 60 then -- 1 log per zone per minute max, avoid webhook spam
                    state.lastCombatLog = now
                    SendLog({
                        playerid = 'SYSTEM', identifier = '-', discord = '-',
                        category = 'Territory',
                        Text = 'Armed clash detected inside territory "' .. cfg.label .. '"',
                        gang = state.owner,
                        IconURL = Gangs[state.owner] and Gangs[state.owner].logo,
                        Webhook = GetCategoryWebhook(state.owner, 'Territory'),
                    })
                end
            end
        end
    end
end)

-------------------------------------------------------------------
-- Client-facing reads: full state for the initial blip render/UI,
-- and a leaderboard sorted by zone count (with each gang's Boss Zone
-- title, if any, attached).
-------------------------------------------------------------------
ESX.RegisterServerCallback('Territory:GetState', function(source, cb)
    local out = {}
    for zoneKey, state in pairs(Territories) do
        local cfg = ZoneConfigByKey[zoneKey]
        out[zoneKey] = {
            label      = cfg and cfg.label,
            tier       = cfg and cfg.tier,
            owner      = state.owner,
            ownerLabel = state.owner and Gangs[state.owner] and Gangs[state.owner].label or state.owner,
            contested  = state.contested,
            vulnerable = state.vulnerable,
            bossZone   = cfg and cfg.bossZone or false,
            upgrades   = ZoneUpgrades[zoneKey],
        }
    end
    cb(out)
end)

ESX.RegisterServerCallback('Territory:GetLeaderboard', function(source, cb)
    local counts = {}
    for _, state in pairs(Territories) do
        if state.owner then
            counts[state.owner] = (counts[state.owner] or 0) + 1
        end
    end
    local list = {}
    for gang, zones in pairs(counts) do
        list[#list + 1] = { gang = gang, label = (Gangs[gang] and Gangs[gang].label) or gang, zones = zones, title = ZoneTitles[gang] }
    end
    table.sort(list, function(a, b) return a.zones > b.zones end)
    cb(list)
end)

-------------------------------------------------------------------
-- SYSTEM 1: UPGRADES
-- A boss (same bossaction/grade check every other boss action in this
-- resource uses) spends the gang's CLEAN money to permanently improve
-- a zone THEY currently own. RemoveGangMoney itself refuses if the
-- gang can't afford it, so there's no separate balance check needed.
-------------------------------------------------------------------
local function HasBossAccess(xPlayer)
    if not xPlayer or not xPlayer.gang or xPlayer.gang.name == 'nogang' or not Gangs[xPlayer.gang.name] then return false end
    local grades = Gangs[xPlayer.gang.name].grades
    local lastRank = CountTable(grades)
    local isBoss = xPlayer.gang.grade == lastRank
    local hasAccess = grades[xPlayer.gang.grade] and grades[xPlayer.gang.grade].access['bossaction']
    return isBoss or hasAccess or false
end

ESX.RegisterServerCallback('Territory:PurchaseUpgrade', function(source, cb, zoneKey, upgradeType)
    if not Config.Territory.Upgrades or not Config.Territory.Upgrades.Enabled then return cb(false, 'Sisteme upgrade gheyrefaal ast') end
    local upgradeCfg = Config.Territory.Upgrades[upgradeType]
    local state = Territories[zoneKey]
    if not upgradeCfg or not state then return cb(false, 'Darkhaste namotabar') end

    local xPlayer = ESX.GetPlayerFromId(source)
    if not xPlayer or not xPlayer.gang or xPlayer.gang.name == 'nogang' then return cb(false, 'Shoma dar gang-i nistid') end
    if state.owner ~= xPlayer.gang.name then return cb(false, 'In ghalamro motaalegh be gang-e shoma nist') end
    if not HasBossAccess(xPlayer) then return cb(false, 'Shoma dastrasi-e modiriati nadarid') end

    local currentLevel = GetUpgradeLevel(zoneKey, upgradeType)
    if currentLevel >= upgradeCfg.maxLevel then return cb(false, 'In upgrade be hadeaksar-e sath reside') end

    local cost = upgradeCfg.cost[currentLevel + 1]
    if not cost then return cb(false, 'Hazine-ye in sath moshakhas nist') end

    if not RemoveGangMoney(xPlayer.gang.name, cost) then
        return cb(false, 'Pool-e tamiz-e kafi dar khazane-ye gang nist (niaz: $' .. cost .. ')')
    end

    local newLevel = currentLevel + 1
    ZoneUpgrades[zoneKey] = ZoneUpgrades[zoneKey] or {}
    ZoneUpgrades[zoneKey][upgradeType] = newLevel
    MySQL.Async.execute([[
        INSERT INTO gang_territory_upgrades (zone_key, upgrade_type, level) VALUES (@zone_key, @type, @level)
        ON DUPLICATE KEY UPDATE level = @level
    ]], { ['@zone_key'] = zoneKey, ['@type'] = upgradeType, ['@level'] = newLevel })

    local cfg = ZoneConfigByKey[zoneKey]
    local ids = ExtractIdentifiers(source)
    SendLog({
        playerid = source, identifier = ids and ids.steam or '-', discord = ids and ids.discord or '-',
        category = 'Territory',
        Text = 'Upgraded "' .. upgradeCfg.label .. '" to level ' .. newLevel .. ' on territory "' .. (cfg and cfg.label or zoneKey) .. '" for $' .. cost,
        gang = xPlayer.gang.name, IconURL = Gangs[xPlayer.gang.name] and Gangs[xPlayer.gang.name].logo,
        Webhook = GetCategoryWebhook(xPlayer.gang.name, 'Territory'),
    })

    cb(true, upgradeCfg.label .. ' be sath-e ' .. newLevel .. ' ertegha yaft')
end)

-------------------------------------------------------------------
-- SYSTEM 2: ESPIONAGE (Scout + Sabotage)
-- Both require the caller to physically be inside the TARGET zone
-- (re-validated server-side, same distance check style as Territory:Ping)
-- and are on their own cooldowns so they can't be spammed.
-------------------------------------------------------------------
ESX.RegisterServerCallback('Territory:Scout', function(source, cb, zoneKey)
    if not Config.Territory.Scout or not Config.Territory.Scout.Enabled then return cb(false, 'Sisteme shenasaei gheyrefaal ast') end
    local cfg = ZoneConfigByKey[zoneKey]
    local state = Territories[zoneKey]
    if not cfg or not state then return cb(false, 'Mantaghe namotabar') end
    if not state.owner then return cb(false, 'In mantaghe saheb nadarad') end

    local xPlayer = ESX.GetPlayerFromId(source)
    if not xPlayer or not xPlayer.gang or xPlayer.gang.name == 'nogang' then return cb(false, 'Shoma dar gang-i nistid') end
    if state.owner == xPlayer.gang.name or AreGangsAllied(state.owner, xPlayer.gang.name) then
        return cb(false, 'In ghalamro motaalegh be shoma ya hampeymanetoone')
    end

    local now = os.time()
    if (ScoutCooldown[source] or 0) + (Config.Territory.Scout.Cooldown or 600) > now then
        return cb(false, 'Hanooz dar cooldown-e shenasaei hastid')
    end

    local ped = GetPlayerPed(source)
    if not ped or ped == 0 then return cb(false, 'Khataye dakheli') end
    local pcoords = GetEntityCoords(ped)
    local dx, dy, dz = pcoords.x - cfg.coord.x, pcoords.y - cfg.coord.y, pcoords.z - cfg.coord.z
    if math.sqrt(dx * dx + dy * dy + dz * dz) > (cfg.radius + 10.0) then
        return cb(false, 'Bayad dakhele khod-e mantaghe bashid')
    end

    ScoutCooldown[source] = now

    -- Count that gang's currently-online members (not just who's in the zone)
    local memberCount = 0
    for _, playerId in ipairs(ESX.GetPlayers()) do
        local xTarget = ESX.GetPlayerFromId(playerId)
        if xTarget and xTarget.gang and xTarget.gang.name == state.owner then memberCount = memberCount + 1 end
    end

    local report = {
        onlineMembers = memberCount,
        upgrades = ZoneUpgrades[zoneKey],
        vulnerable = state.vulnerable,
    }

    if math.random(1, 100) <= (Config.Territory.Scout.DetectionChance or 0) then
        for _, playerId in ipairs(ESX.GetPlayers()) do
            local xTarget = ESX.GetPlayerFromId(playerId)
            if xTarget and xTarget.gang and xTarget.gang.name == state.owner then
                TriggerClientEvent(Config.showAdvancedNotification, playerId, '~o~Hoshdar', '~o~Jasoos shenasaei shod', 'Gang "' .. xPlayer.gang.name .. '" dar hale shenasaei-e ghalamro "' .. cfg.label .. '" shomast!', 'CHAR_MP_DETONATEPHONE', 9)
            end
        end
    end

    cb(true, nil, report)
end)

RegisterServerEvent('Territory:Sabotage')
AddEventHandler('Territory:Sabotage', function(zoneKey)
    if not Config.Territory.Sabotage or not Config.Territory.Sabotage.Enabled then return end
    local src = source
    local cfg = ZoneConfigByKey[zoneKey]
    local state = Territories[zoneKey]
    if not cfg or not state or not state.owner then return end

    local xPlayer = ESX.GetPlayerFromId(src)
    if not xPlayer or not xPlayer.gang or xPlayer.gang.name == 'nogang' then return end
    if state.owner == xPlayer.gang.name or AreGangsAllied(state.owner, xPlayer.gang.name) then
        return TriggerClientEvent(Config.showNotification, src, 'In ghalamro motaalegh be shoma ya hampeymanetoone', 'error')
    end

    local key = xPlayer.gang.name .. ':' .. zoneKey
    local now = os.time()
    if (SabotageCooldown[key] or 0) + (Config.Territory.Sabotage.Cooldown or 3600) > now then
        return TriggerClientEvent(Config.showNotification, src, 'In kharabkari hanooz dar cooldoone', 'error')
    end

    local ped = GetPlayerPed(src)
    if not ped or ped == 0 then return end
    local pcoords = GetEntityCoords(ped)
    local dx, dy, dz = pcoords.x - cfg.coord.x, pcoords.y - cfg.coord.y, pcoords.z - cfg.coord.z
    if math.sqrt(dx * dx + dy * dy + dz * dz) > (cfg.radius + 10.0) then
        return TriggerClientEvent(Config.showNotification, src, 'Bayad dakhele khod-e mantaghe bashid', 'error')
    end

    SabotageCooldown[key] = now
    state.sabotagedUntil = now + (Config.Territory.Sabotage.DurationSeconds or 7200)

    TriggerClientEvent(Config.showNotification, src, 'Kharabkari ba movafaghiat anjam shod - daramad-e in mantaghe baraye moddati kahesh miyabad', 'success')

    local detected = math.random(1, 100) <= (Config.Territory.Sabotage.DetectionChance or 0)
    for _, playerId in ipairs(ESX.GetPlayers()) do
        local xTarget = ESX.GetPlayerFromId(playerId)
        if xTarget and xTarget.gang and xTarget.gang.name == state.owner then
            local text = detected
                and ('Gang "' .. xPlayer.gang.name .. '" dar ghalamro "' .. cfg.label .. '" kharabkari kard!')
                or ('Yek nafar-e nashenas dar ghalamro "' .. cfg.label .. '" kharabkari kard!')
            TriggerClientEvent(Config.showAdvancedNotification, playerId, '~r~Kharabkari!', '~r~Daramad kahesh yaft', text, 'CHAR_MP_DETONATEPHONE', 9)
        end
    end

    local ids = ExtractIdentifiers(src)
    SendLog({
        playerid = src, identifier = ids and ids.steam or '-', discord = ids and ids.discord or '-',
        category = 'Territory',
        Text = 'Sabotaged territory "' .. cfg.label .. '" owned by "' .. state.owner .. '"',
        gang = xPlayer.gang.name, IconURL = Gangs[xPlayer.gang.name] and Gangs[xPlayer.gang.name].logo,
        Webhook = GetCategoryWebhook(xPlayer.gang.name, 'Territory'),
    })
end)

-------------------------------------------------------------------
-- SYSTEM 5: ALLIANCES
-- Propose -> the other gang's boss accepts -> both directions marked
-- active in memory AND persisted, so a restart doesn't undo it.
-------------------------------------------------------------------
local PendingAlliances = {} -- PendingAlliances['gangA:gangB'] = true (A proposed to B)

ESX.RegisterServerCallback('Territory:ProposeAlliance', function(source, cb, targetGang)
    if not Config.Territory.Alliance or not Config.Territory.Alliance.Enabled then return cb(false, 'Sisteme etehad gheyrefaal ast') end
    local xPlayer = ESX.GetPlayerFromId(source)
    if not xPlayer or not xPlayer.gang or xPlayer.gang.name == 'nogang' then return cb(false, 'Shoma dar gang-i nistid') end
    if not HasBossAccess(xPlayer) then return cb(false, 'Shoma dastrasi-e modiriati nadarid') end
    if not Gangs[targetGang] or targetGang == xPlayer.gang.name then return cb(false, 'Gang-e maghsad namotabar ast') end
    if AreGangsAllied(xPlayer.gang.name, targetGang) then return cb(false, 'Shoma az ghabl ba in gang mottahed hastid') end

    PendingAlliances[xPlayer.gang.name .. ':' .. targetGang] = true

    for _, playerId in ipairs(ESX.GetPlayers()) do
        local xTarget = ESX.GetPlayerFromId(playerId)
        if xTarget and xTarget.gang and xTarget.gang.name == targetGang and HasBossAccess(xTarget) then
            TriggerClientEvent(Config.showAdvancedNotification, playerId, '~b~Pishnahade etehad', '~b~Darkhaste jadid', 'Gang "' .. xPlayer.gang.name .. '" pishnahade etehad dade - az menuye Boss Actions ghabool konid', 'CHAR_MP_DETONATEPHONE', 9)
        end
    end

    cb(true, 'Pishnahade etehad ersal shod')
end)

ESX.RegisterServerCallback('Territory:AcceptAlliance', function(source, cb, proposerGang)
    if not Config.Territory.Alliance or not Config.Territory.Alliance.Enabled then return cb(false, 'Sisteme etehad gheyrefaal ast') end
    local xPlayer = ESX.GetPlayerFromId(source)
    if not xPlayer or not xPlayer.gang or xPlayer.gang.name == 'nogang' then return cb(false, 'Shoma dar gang-i nistid') end
    if not HasBossAccess(xPlayer) then return cb(false, 'Shoma dastrasi-e modiriati nadarid') end

    if not PendingAlliances[proposerGang .. ':' .. xPlayer.gang.name] then
        return cb(false, 'Pishnahade etehadi az in gang peyda nashod')
    end
    PendingAlliances[proposerGang .. ':' .. xPlayer.gang.name] = nil

    Alliances[proposerGang] = Alliances[proposerGang] or {}
    Alliances[proposerGang][xPlayer.gang.name] = true
    Alliances[xPlayer.gang.name] = Alliances[xPlayer.gang.name] or {}
    Alliances[xPlayer.gang.name][proposerGang] = true

    MySQL.Async.execute([[
        INSERT INTO gang_alliances (gang_a, gang_b, status) VALUES (@a, @b, 'active')
        ON DUPLICATE KEY UPDATE status = 'active'
    ]], { ['@a'] = proposerGang, ['@b'] = xPlayer.gang.name })

    for _, playerId in ipairs(ESX.GetPlayers()) do
        local xTarget = ESX.GetPlayerFromId(playerId)
        if xTarget and xTarget.gang and (xTarget.gang.name == proposerGang or xTarget.gang.name == xPlayer.gang.name) then
            TriggerClientEvent(Config.showAdvancedNotification, playerId, '~b~Etehad', '~b~Barghar shod', 'Gang-haye "' .. proposerGang .. '" va "' .. xPlayer.gang.name .. '" aknoon mottahed hastand!', 'CHAR_MP_DETONATEPHONE', 9)
        end
    end

    cb(true, 'Etehad ba movafaghiat barghar shod')
end)

ESX.RegisterServerCallback('Territory:BreakAlliance', function(source, cb, otherGang)
    local xPlayer = ESX.GetPlayerFromId(source)
    if not xPlayer or not xPlayer.gang or xPlayer.gang.name == 'nogang' then return cb(false, 'Shoma dar gang-i nistid') end
    if not HasBossAccess(xPlayer) then return cb(false, 'Shoma dastrasi-e modiriati nadarid') end
    if not AreGangsAllied(xPlayer.gang.name, otherGang) then return cb(false, 'Etehadi ba in gang vojood nadarad') end

    if Alliances[xPlayer.gang.name] then Alliances[xPlayer.gang.name][otherGang] = nil end
    if Alliances[otherGang] then Alliances[otherGang][xPlayer.gang.name] = nil end

    MySQL.Async.execute('DELETE FROM gang_alliances WHERE (gang_a = @a AND gang_b = @b) OR (gang_a = @b AND gang_b = @a)', {
        ['@a'] = xPlayer.gang.name, ['@b'] = otherGang,
    })

    cb(true, 'Etehad laghv shod')
end)

ESX.RegisterServerCallback('Territory:GetAlliances', function(source, cb)
    local xPlayer = ESX.GetPlayerFromId(source)
    if not xPlayer or not xPlayer.gang or xPlayer.gang.name == 'nogang' then return cb({}) end
    local list = {}
    if Alliances[xPlayer.gang.name] then
        for otherGang in pairs(Alliances[xPlayer.gang.name]) do
            list[#list + 1] = otherGang
        end
    end
    cb(list)
end)

-- Lets the boss menu show "accept alliance" as a pick-from-a-list
-- instead of needing the exact gang name typed blind.
ESX.RegisterServerCallback('Territory:GetPendingAlliances', function(source, cb)
    local xPlayer = ESX.GetPlayerFromId(source)
    if not xPlayer or not xPlayer.gang or xPlayer.gang.name == 'nogang' then return cb({}) end
    local list = {}
    for key in pairs(PendingAlliances) do
        local proposer, target = key:match('^(.-):(.*)$')
        if target == xPlayer.gang.name then
            list[#list + 1] = proposer
        end
    end
    cb(list)
end)

-------------------------------------------------------------------
-- SYSTEM 6: WAR NIGHT
-- Just announces the window opening/closing - the actual capture/
-- income multipliers are already folded into EffectiveCaptureSeconds
-- and DistributeTerritoryIncome above, so this thread has nothing to
-- do but tell people about it.
-------------------------------------------------------------------
CreateThread(function()
    local wasActive = false
    while true do
        Wait(30000) -- check every 30s, cheap and plenty precise for an hour-wide window
        if Config.Territory.WarNight and Config.Territory.WarNight.Enabled then
            local active = IsWarNight()
            if active and not wasActive then
                TriggerClientEvent(Config.showAdvancedNotification, -1, '~r~Shabe jang!', '~r~Shoroo shod', 'Zamane tasarrof nesf va daramade ghalamro-ha dobarabar shod - vaghte jangidane!', 'CHAR_MP_DETONATEPHONE', 9)
                SendLog({ playerid = 'SYSTEM', identifier = '-', discord = '-', category = 'Territory', Text = 'War Night started (half capture time, double income)', gang = '-', Webhook = GetCategoryWebhook(nil, 'Territory') })
            elseif not active and wasActive then
                TriggerClientEvent(Config.showAdvancedNotification, -1, '~y~Shabe jang', '~y~Tamam shod', 'Zamane tasarrof va daramade ghalamro-ha be halate adi bargasht.', 'CHAR_MP_DETONATEPHONE', 9)
            end
            wasActive = active
        end
    end
end)

-------------------------------------------------------------------
-- SYSTEM 4 (cont.): BOSS ZONE open/close announcements + guard spawn
-- signal. The zone itself already lives in Territories/ZoneConfigByKey
-- (see the init block near the top) and is captured through the exact
-- same tick/CaptureZone path as every other zone - this thread only
-- handles the weekly open/close broadcast and tells clients when to
-- spawn/despawn the cosmetic guard NPCs.
-------------------------------------------------------------------
if Config.Territory.BossZone and Config.Territory.BossZone.Enabled then
    CreateThread(function()
        local wasOpen = false
        while true do
            Wait(30000)
            local open = IsBossZoneOpen()
            if open and not wasOpen then
                TriggerClientEvent(Config.showAdvancedNotification, -1, '~p~Ghalamroye Padeshah', '~p~Baz shod!', 'Ghalamroye Padeshah baraye ' .. Config.Territory.BossZone.openDurationHours .. ' saat-e ayande baz ast - negahbanane mosallah az an defa mikonand!', 'CHAR_MP_DETONATEPHONE', 9)
                TriggerClientEvent('Territory:BossZoneState', -1, true)
            elseif not open and wasOpen then
                TriggerClientEvent(Config.showAdvancedNotification, -1, '~p~Ghalamroye Padeshah', '~p~Baste shod', 'Ghalamroye Padeshah ta hafte-ye ayande baste ast.', 'CHAR_MP_DETONATEPHONE', 9)
                TriggerClientEvent('Territory:BossZoneState', -1, false)
            end
            wasOpen = open
        end
    end)
end

