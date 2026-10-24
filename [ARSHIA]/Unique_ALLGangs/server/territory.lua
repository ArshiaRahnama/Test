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

local ZoneUpgrades = {}  -- must be declared before BroadcastTerritoryState uses it
function BroadcastTerritoryState()
    local out = {}
    for zoneKey, state in pairs(Territories) do
        -- upgrades travel with the state too, otherwise the menu always shows level 0
        out[zoneKey] = { owner = state.owner, contested = state.contested, vulnerable = state.vulnerable, upgrades = ZoneUpgrades[zoneKey] }
    end
    TriggerClientEvent('Territory:SyncState', -1, out)
end

-- Exposed for server/zonewar.lua (the helpers below are file-local).
function ZW_IsZoneOnWar(zoneKey)
    local s = Territories[zoneKey]
    return s and s.inWar or false
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
ZoneUpgrades = ZoneUpgrades or {} -- ZoneUpgrades[zoneKey][upgradeType] = level (declared at the top, see below)
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

    local speed = GetGangPerk and tonumber(GetGangPerk(challengerGang, 'captureSpeed', 0)) or 0
    if speed > 0 then base = base * (1 - math.min(speed, 0.5)) end

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

    -- Players inside another routing bucket (Warzone/Gungame matches run
    -- on the same island) are in a different world: they must never count
    -- as "present" in a real territory zone.
    if GetPlayerRoutingBucket then
        local okB, bucket = pcall(GetPlayerRoutingBucket, src)
        if okB and bucket and bucket ~= 0 then return end
    end

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
-------------------------------------------------------------------
-- CAPTURE REWARD (Config.Territory.CaptureReward): items into the
-- gang's armory + a chat/notification to every online member.
-------------------------------------------------------------------
math.randomseed(os.time())
local RewardItemLabels = {}   -- item name -> label (from the `items` table, for the message)
local RewardCooldownAt = {}   -- RewardCooldownAt[zoneKey] = os.time() of the last payout

local function AllRewardItemNames()
    local names, seen = {}, {}
    local rw = Config.Territory.CaptureReward
    if not rw then return names end
    local function add(list) for _, it in ipairs(list or {}) do if it.name and not seen[it.name] then seen[it.name] = true names[#names + 1] = it.name end end end
    add(rw.default); add(rw.bossZone)
    for _, list in pairs(rw.byTier or {}) do add(list) end
    local function addPool(b) for _, e in ipairs((b and b.pool) or {}) do if e.type == 'item' and e.name and not seen[e.name] then seen[e.name] = true names[#names + 1] = e.name end end end
    if rw.bonus then
        addPool(rw.bonus.default); addPool(rw.bonus.bossZone)
        for _, b in pairs(rw.bonus.byTier or {}) do addPool(b) end
    end
    return names
end

-- Warn at start if a configured reward item doesn't exist in the `items` table.
MySQL.ready(function()
    local rw = Config.Territory.CaptureReward
    if not rw or not rw.Enabled then return end
    local names = AllRewardItemNames()
    if #names == 0 then return end
    local quoted = {}
    for _, n in ipairs(names) do
        if n:match('^[%w_%-]+$') then quoted[#quoted + 1] = "'" .. n .. "'" end -- config-only names; anything odd is skipped
    end
    if #quoted == 0 then return end
    MySQL.Async.fetchAll('SELECT name, label FROM items WHERE name IN (' .. table.concat(quoted, ',') .. ')', {}, function(rows)
        local found = {}
        for _, r in ipairs(rows or {}) do found[r.name] = true RewardItemLabels[r.name] = r.label end
        for _, n in ipairs(names) do
            if not found[n] then
                print(('[Unique_ALLGangs] WARNING: Territory capture reward item "%s" does not exist in the items table - gangs will get nothing for it. Fix Config.Territory.CaptureReward.'):format(n))
            end
        end
    end)
end)

local function AddItemToGangArmory(gang, itemName, count)
    local rw = Config.Territory.CaptureReward
    local res = rw and rw.inventoryResource or 'Unique_inventory'
    local ok, success = pcall(function() return exports[res]:AddGangArmoryItem(gang, itemName, count) end)
    if ok and success then return true end
    -- fallback: talk to esx_addoninventory directly (shared store "gang_<name>")
    local inv
    TriggerEvent('esx_addoninventory:getSharedInventory', 'gang_' .. string.lower(gang), function(i) inv = i end)
    if inv then inv.addItem(itemName, count) return true end
    print(('[Unique_ALLGangs] could not add %sx %s to the armory of "%s" (is %s running?)'):format(count, itemName, gang, res))
    return false
end

-- Weapons live in the armory's separate weapon list (esx_datastore "gang_<name>").
local function AddWeaponToGangArmory(gang, weaponName, count)
    local rw = Config.Territory.CaptureReward
    local res = rw and rw.inventoryResource or 'Unique_inventory'
    local ok, success = pcall(function() return exports[res]:AddGangArmoryWeapon(gang, weaponName, count) end)
    if ok and success then return true end
    local store
    TriggerEvent('esx_datastore:getSharedDataStore', 'gang_' .. string.lower(gang), function(st) store = st end)
    if store then
        local upper = string.upper(weaponName)
        local weapons = store.get('weapons') or {}
        local found = false
        for i = 1, #weapons do
            if string.upper(weapons[i].name) == upper then
                weapons[i].count = (tonumber(weapons[i].count or weapons[i].ammo) or 0) + count
                weapons[i].ammo = nil
                found = true
                break
            end
        end
        if not found then table.insert(weapons, { name = upper, count = count }) end
        store.set('weapons', weapons)
        return true
    end
    print(('[Unique_ALLGangs] could not add %sx %s to the armory of "%s" (is %s running?)'):format(count, weaponName, gang, res))
    return false
end

local function TellGang(gang, text, kind)
    for _, playerId in ipairs(ESX.GetPlayers()) do
        local x = ESX.GetPlayerFromId(playerId)
        if x and x.gang and x.gang.name == gang then
            TriggerClientEvent(Config.showNotification, playerId, text, kind or 'success')
            TriggerClientEvent('chat:addMessage', playerId, { color = { 255, 200, 0 }, multiline = true, args = { 'TERRITORY', text } })
        end
    end
end

-- Everyone physically INSIDE the island circle (the red blip), except the
-- gangs in `skipGangs` (they get their own, more specific message), hears
-- that a zone changed hands. Players in another routing bucket (paintball
-- arena, events) are not on the island and are skipped.
local function AnnounceToIsland(text, skipGangs)
    local isl = Config.Territory.Island
    if not isl or isl.Enabled == false or isl.captureAnnounce == false then return end
    for _, playerId in ipairs(ESX.GetPlayers()) do
        local x = ESX.GetPlayerFromId(playerId)
        local skip = x and x.gang and skipGangs and skipGangs[x.gang.name]
        if not skip then
            local ped = GetPlayerPed(playerId)
            local inBucket0 = true
            if GetPlayerRoutingBucket then
                local okB, bucket = pcall(GetPlayerRoutingBucket, playerId)
                inBucket0 = (not okB) or bucket == nil or bucket == 0
            end
            if ped and ped ~= 0 and inBucket0 then
                local c = GetEntityCoords(ped)
                local dx, dy = c.x - isl.coords.x, c.y - isl.coords.y
                if (dx * dx + dy * dy) <= (isl.radius * isl.radius) then
                    TriggerClientEvent(Config.showNotification, playerId, text, 'info')
                    TriggerClientEvent('chat:addMessage', playerId, { color = { 255, 120, 60 }, multiline = true, args = { 'JAZIRE', text } })
                end
            end
        end
    end
end

-- One random extra (weapon or item) with a LOW chance, picked by weight.
local function RollBonus(cfg, newGang)
    if Config.Territory.ZoneArmory == false then return nil end
    local rw = Config.Territory.CaptureReward
    local bonus = rw and rw.bonus
    if not bonus then return nil end
    local entry = (cfg.bossZone and bonus.bossZone) or (bonus.byTier and bonus.byTier[cfg.tier]) or bonus.default
    if not entry or not entry.pool or #entry.pool == 0 then return nil end
    if math.random(100) > (tonumber(entry.chance) or 0) then return nil end

    local total = 0
    for _, e in ipairs(entry.pool) do total = total + (tonumber(e.weight) or 1) end
    local pick = math.random() * total
    local chosen = entry.pool[#entry.pool]
    for _, e in ipairs(entry.pool) do
        pick = pick - (tonumber(e.weight) or 1)
        if pick <= 0 then chosen = e break end
    end

    local count = chosen.count or 1
    local ok
    if chosen.type == 'weapon' then ok = AddWeaponToGangArmory(newGang, chosen.name, count)
    else ok = AddItemToGangArmory(newGang, chosen.name, count) end
    if not ok then return nil end
    local label = chosen.type == 'weapon' and (chosen.name:gsub('^WEAPON_', '')) or (RewardItemLabels[chosen.name] or chosen.name)
    return ('%sx %s'):format(count, label)
end

local function GiveCaptureReward(zoneKey, newGang, cfg)
    if Config.Territory.ZoneArmory == false then return end
    local rw = Config.Territory.CaptureReward
    if not rw or not rw.Enabled then return end
    local items = (cfg.bossZone and rw.bossZone) or (rw.byTier and rw.byTier[cfg.tier]) or rw.default
    if not items or #items == 0 then return end

    local now = os.time()
    local cd = (tonumber(rw.cooldownMinutes) or 60) * 60
    if RewardCooldownAt[zoneKey] and now - RewardCooldownAt[zoneKey] < cd then
        TellGang(newGang, ('Gang-e shoma "%s" ro tasarrof kard - in zone nazdik be pish jayeze dade shode, in bar jayeze-i nadarad.'):format(cfg.label), 'info')
        return
    end

    local parts = {}
    for _, it in ipairs(items) do
        if AddItemToGangArmory(newGang, it.name, it.count) then
            parts[#parts + 1] = ('%sx %s'):format(it.count, RewardItemLabels[it.name] or it.name)
        end
    end
    if #parts > 0 then
        -- only start the per-zone cooldown when something was really paid out
        -- (an armory/inventory outage must not burn the zone's reward for an hour)
        RewardCooldownAt[zoneKey] = now
        -- Robbery-lottery points (Unique_AllRobs). pcall: the resource may not be running.
        local hp = rw.heistPoints
        local pts = hp and ((cfg.bossZone and hp.bossZone) or hp[cfg.tier] or hp.default) or 0
        if pts and pts > 0 then
            pcall(function() exports['Unique_AllRobs']:AddGangHeistPoints(newGang, pts, 'tasarrof-e zone') end)
        end
        local text = ('Gang-e shoma "%s" ro tasarrof kard! Jayeze be armory-e gang ezafe shod: %s'):format(cfg.label, table.concat(parts, ', '))
        local extra = RollBonus(cfg, newGang)
        if extra then text = text .. (' + BONUS (shans): %s'):format(extra) end
        TellGang(newGang, text .. ' - az armory bardarid.', 'success')
    end
end

function CaptureZone(zoneKey, newGang, actorSource, skipXP)
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

    if not skipXP and GrantGangXP and Config.GangXP and Config.GangXP.Sources then
        GrantGangXP(newGang, cfg.bossZone and Config.GangXP.Sources.bossZone or Config.GangXP.Sources.capture, cfg.bossZone and 'Boss Zone' or 'Territory Capture')
    end

    GiveCaptureReward(zoneKey, newGang, cfg)

    if not cfg.bossZone then
        local who = (Gangs[newGang] and Gangs[newGang].label) or newGang
        local from = oldGang and oldGang ~= newGang and ((Gangs[oldGang] and Gangs[oldGang].label) or oldGang) or nil
        AnnounceToIsland(('Mantaghe-ye "%s" tavasot-e gang-e "%s" tasarrof shod%s!'):format(cfg.label, who, from and (' (az "' .. from .. '")') or ''), { [newGang] = true, [oldGang or ''] = true })
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

    -- Bystanders get the "something just happened here" heads-up too,
    -- but only if they're actually near the zone when it flips - not
    -- the whole server. Members of the two gangs involved are excluded
    -- here since they already got their own personalized message above.
    if not cfg.bossZone then -- the Boss Zone already sent its own server-wide banner above
        for _, playerId in ipairs(ESX.GetPlayers()) do
            local xTarget = ESX.GetPlayerFromId(playerId)
            local isInvolved = xTarget and xTarget.gang and (xTarget.gang.name == newGang or xTarget.gang.name == oldGang)
            if xTarget and not isInvolved then
                local ped = GetPlayerPed(playerId)
                if ped and ped ~= 0 then
                    local pcoords = GetEntityCoords(ped)
                    local dx, dy, dz = pcoords.x - cfg.coord.x, pcoords.y - cfg.coord.y, pcoords.z - cfg.coord.z
                    if math.sqrt(dx * dx + dy * dy + dz * dz) <= cfg.radius then -- strictly inside the zone itself, no buffer
                        TriggerClientEvent(Config.showAdvancedNotification, playerId, '~b~Ghalamro', '~b~Taghir-e malekiat', 'Gang "' .. newGang .. '" mantaghe "' .. cfg.label .. '" ro tasarrof kard.', 'CHAR_MP_DETONATEPHONE', 9)
                    end
                end
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
-------------------------------------------------------------------
-- Live capture timer: every tick the server tells all clients which
-- zones are being captured, by whom, and how many seconds are left.
-- Clients count down locally between ticks (client/territory.lua).
-- An empty table is sent once when the last capture stops so the
-- timers disappear.
-------------------------------------------------------------------
local LastProgressHad = false
local function BroadcastCaptureProgress()
    local out, any = {}, false
    local now = os.time()
    local window = ((Config.Territory.TickIntervalMs or 5000) / 1000) + 1
    for zoneKey, prog in pairs(ZoneProgress) do
        local state = Territories[zoneKey]
        -- Progress is kept when a gang walks away (the zone isn't reset), but a timer
        -- must only count down while someone is really there capturing it.
        if state and prog.gang and state.captureActiveAt and now - state.captureActiveAt <= window then
            local needed = EffectiveCaptureSeconds(zoneKey, state, prog.gang)
            out[zoneKey] = { gang = prog.gang, remaining = math.max(0, math.floor(needed - prog.seconds)) }
            any = true
        end
    end
    if any or LastProgressHad then
        TriggerClientEvent('Territory:CaptureProgress', -1, out)
    end
    LastProgressHad = any
end

-- Owner beat back a real capture attempt: the challenger had been
-- holding the zone for a while and then got cleared (owner showed up,
-- or it turned into a contest). Throttled per zone + daily-capped.
local function RewardDefense(zoneKey, state, now)
    local xp = Config.GangXP
    if not (xp and xp.Enabled and GrantGangXP and state.owner) then return end
    local prog = ZoneProgress[zoneKey]
    if not prog or prog.seconds < (xp.DefendMinProgressSeconds or 60) then return end
    if now - (state.lastDefendXP or 0) < (xp.DefendThrottleSeconds or 300) then return end
    state.lastDefendXP = now
    GrantGangXP(state.owner, xp.Sources.defend, 'Territory Defense')
end

local function ProcessTerritoryTick()
    -- the E-capture zones are taken by pressing E (server/ecapture.lua), not by presence
    for _, k in ipairs((Config.Territory and Config.Territory.ECapture and Config.Territory.ECapture.Zones) or {}) do
        ZoneProgress[k] = nil
    end
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

        if (cfg and cfg.bossZone and not IsBossZoneOpen()) or state.inWar or (state.protectedUntil and state.protectedUntil > now) then
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
                RewardDefense(zoneKey, state, now)
                ZoneProgress[zoneKey] = nil
            else
                state.contested = false
                local sideGangs = sides[1].gangs

                local ownerOnThisSide = false
                for _, g in ipairs(sideGangs) do
                    if g == state.owner then ownerOnThisSide = true break end
                end

                if ownerOnThisSide then
                    RewardDefense(zoneKey, state, now)
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

                    if CountGangZones(creditedGang) >= (GetGangPerk and GetGangPerk(creditedGang, 'maxZones', Config.Territory.MaxZonesPerGang or 999) or Config.Territory.MaxZonesPerGang or 999) then
                        -- that gang is at its territory cap - no progress accrues until they drop one
                    else
                        local prog = ZoneProgress[zoneKey]
                        if not prog or prog.gang ~= creditedGang then
                            prog = { gang = creditedGang, seconds = 0 }
                            ZoneProgress[zoneKey] = prog
                        end
                        prog.seconds = prog.seconds + tickSeconds
                        state.captureActiveAt = now -- someone is capturing RIGHT NOW (the live timer only shows these)

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
            BroadcastCaptureProgress()
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
    local xpTotals = {}

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

            if state.warBonusUntil and state.warBonusUntil > os.time() then
                amount = amount * (1 + ((Config.ZoneWar and Config.ZoneWar.WinnerIncomeBonus) or 0))
            end

            amount = math.floor(amount)
            if amount > 0 then
                totals[state.owner] = (totals[state.owner] or 0) + amount
                local xpTier = Config.GangXP and Config.GangXP.Sources and Config.GangXP.Sources.territoryIncome
                if xpTier and xpTier[cfg.tier] then
                    xpTotals[state.owner] = (xpTotals[state.owner] or 0) + xpTier[cfg.tier]
                end
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

    -- Gang XP for holding territory (daily-capped inside GrantGangXP).
    if GrantGangXP then
        for gang, xp in pairs(xpTotals) do GrantGangXP(gang, xp, 'Territory Income') end
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
    local discount = GetGangPerk and tonumber(GetGangPerk(xPlayer.gang.name, 'upgradeDiscount', 0)) or 0
    if discount > 0 then cost = math.floor(cost * (1 - math.min(discount, 0.9))) end

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

    BroadcastTerritoryState()
    cb(true, upgradeCfg.label .. ' be sath-e ' .. newLevel .. ' ertegha yaft', newLevel)
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
    if GrantGangXP and Config.GangXP and Config.GangXP.Sources then GrantGangXP(xPlayer.gang.name, Config.GangXP.Sources.sabotage, 'Sabotage') end

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

-------------------------------------------------------------------
-- /zonepos (admin) - prints the caller's exact position as a ready to
-- paste `coord = vector3(...)` line, for placing zones on the island.
-------------------------------------------------------------------
RegisterCommand('zonepos', function(source)
    if source == 0 then return end
    if not IsPlayerCanOpenPanel(source) then return end
    TriggerClientEvent('Territory:PrintPos', source)
end, false)

-------------------------------------------------------------------
-- Wrappers so server/zonewar.lua can reuse the file-local helpers.
-------------------------------------------------------------------
function ZW_AreAllied(a, b) return AreGangsAllied(a, b) end
function ZW_IsWarNight() return IsWarNight() end

-- Alliances for other resources (Unique_AllRobs: allied gangs count together for a heist party).
exports('AreGangsAllied', function(gangA, gangB)
    return AreGangsAllied(gangA, gangB) and true or false
end)

-- Overview for the Gang Friends screen (Unique_AllRobs NUI): current allies,
-- incoming/outgoing proposals, and the gangs you can propose to.
ESX.RegisterServerCallback('Allies:Overview', function(source, cb)
    local xPlayer = ESX.GetPlayerFromId(source)
    if not xPlayer or not xPlayer.gang or xPlayer.gang.name == 'nogang' then return cb({ hasGang = false }) end
    local me = xPlayer.gang.name
    local online = {}
    for _, playerId in ipairs(ESX.GetPlayers()) do
        local x = ESX.GetPlayerFromId(playerId)
        if x and x.gang and x.gang.name ~= 'nogang' then online[x.gang.name] = (online[x.gang.name] or 0) + 1 end
    end
    local function labelOf(g) return (Gangs[g] and Gangs[g].label) or g end

    local allies, incoming, outgoing, candidates = {}, {}, {}, {}
    for other in pairs(Alliances[me] or {}) do allies[#allies + 1] = { gang = other, label = labelOf(other), online = online[other] or 0 } end
    for key in pairs(PendingAlliances) do
        local proposer, target = key:match('^(.-):(.*)$')
        if target == me then incoming[#incoming + 1] = { gang = proposer, label = labelOf(proposer) } end
        if proposer == me then outgoing[#outgoing + 1] = { gang = target, label = labelOf(target) } end
    end
    for g in pairs(Gangs) do
        if g ~= me and g ~= 'nogang' and not AreGangsAllied(me, g) then
            local pending = PendingAlliances[me .. ':' .. g] == true
            candidates[#candidates + 1] = { gang = g, label = labelOf(g), online = online[g] or 0, pending = pending }
        end
    end
    local byLabel = function(a, b) return a.label < b.label end
    table.sort(allies, byLabel); table.sort(incoming, byLabel); table.sort(outgoing, byLabel); table.sort(candidates, byLabel)
    cb({
        hasGang = true, gang = me, label = labelOf(me), isBoss = HasBossAccess(xPlayer),
        enabled = Config.Territory.Alliance and Config.Territory.Alliance.Enabled or false,
        allies = allies, incoming = incoming, outgoing = outgoing, candidates = candidates,
    })
end)

-- Same gang, or allied gangs (alliances are stored in the local table above).
-- Used by the island death / revive rules (server/island_death.lua).
function AreGangsAllied(a, b)
    if not a or not b or a == 'nogang' or b == 'nogang' then return false end
    if a == b then return true end
    return Alliances[a] ~= nil and Alliances[a][b] == true
end

-- True for the zones that are taken with E (Config.Territory.ECapture).
function ECZone(k)
    for _, z in ipairs((Config.Territory and Config.Territory.ECapture and Config.Territory.ECapture.Zones) or {}) do
        if z == k then return true end
    end
    return false
end

