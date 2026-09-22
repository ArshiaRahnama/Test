-- Unique_OilRig | server.lua
--
-- Everything that matters is decided HERE. The client only draws things
-- (peds, target zones, blips, minigames) and reports what happened.
--
-- Server conventions this file follows (same as Unique_AllRobs):
--   * ESX comes from essentialmode via esx:getSharedObject
--   * players must be in routing bucket 0
--   * police jobs can't rob, ambulance/taxi/mechanic must be off duty
--   * cops required, /party leader + close teammates required
--   * police are alerted through exports['Unique_AllRobs']:AlertPolice
--   * logs go through the DiscordBot:ToDiscord event ('rob' channel)
--
-- NOTE: no ESX.RegisterServerCallback anywhere on purpose. On this server a
-- callback registered from a resource's own ESX copy never reaches
-- essentialmode (see Unique_inventory/server/callback_bridge.lua), so every
-- request/response here is a plain server event + client event instead.

ESX = nil
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

math.randomseed(os.time())

local C = Config.OilRig
local S = Config.Strings

-- ----------------------------------------------------------------------
-- State
-- ----------------------------------------------------------------------
local function newState()
    return {
        stage        = 'idle',   -- idle | travel | active | done
        owner        = nil,      -- source of the player who started it
        participants = {},       -- [source] = true  (leader + close party members)
        startedAt    = 0,
        doneAt       = 0,
        crates       = {},       -- [crateIndex] = { looted, claimedBy, claimedAt }
        hackAvailable = false,
        hackDone     = false,
        hackBy       = nil,
        hackStartedAt = 0,
        guards       = {},       -- network ids reported by the leader's client
        guardsReported = false,
    }
end

local Heist = newState()
local LastRob = 0

if Config.TestMode then
    print('^3[Unique_OilRig] TEST MODE IS ON - cops/party/cooldown/item/job checks are skipped. Set Config.TestMode = false for the live server.^0')
end
local lastAttempt = {}

-- ----------------------------------------------------------------------
-- Helpers
-- ----------------------------------------------------------------------
local function notify(src, msg, typ)
    TriggerClientEvent('esx:showNotification', src, msg, typ)
end

local function inList(list, value)
    for i = 1, #list do
        if list[i] == value then return true end
    end
    return false
end

local function isPolice(jobName)
    return inList(Config.PoliceJobs, jobName)
end

local function distanceTo(src, coords)
    local ped = GetPlayerPed(src)
    if not ped or ped == 0 then return math.huge end
    return #(GetEntityCoords(ped) - coords)
end

local function isOnline(src)
    return GetPlayerName(src) ~= nil
end

local function countCops()
    local cops = 0
    local xPlayers = ESX.GetPlayers()
    for i = 1, #xPlayers do
        local yPlayer = ESX.GetPlayerFromId(xPlayers[i])
        if yPlayer and isPolice(yPlayer.job.name) then
            cops = cops + 1
        end
    end
    return cops
end

local function logHeist(src, xPlayer, status, extra)
    local gang = (xPlayer.gang and xPlayer.gang.name) or 'nogang'
    local msg = ("```css\n[ID] : %s\n[IC Name] : %s\n[Steam Name] : %s\n[Gang Name] : %s\n[Steam Hex] : %s\n[Status] : %s%s\n```")
        :format(src, tostring(xPlayer.name), GetPlayerName(src) or '?', gang, tostring(xPlayer.identifier), status,
            extra and ('\n[Info] : ' .. extra) or '')
    TriggerEvent('DiscordBot:ToDiscord', 'rob', 'Oil Rig Heist', msg, 'user', src, true, false)
end

--- Common gate for anything a player does inside the heist.
--- Returns the xPlayer, or nil after telling the player why not.
local function getEligiblePlayer(src)
    local xPlayer = ESX.GetPlayerFromId(src)
    if not xPlayer then return nil end
    if GetPlayerRoutingBucket(src) ~= 0 then
        notify(src, S.wrong_world, 'error')
        return nil
    end
    if not Config.TestMode then
        if isPolice(xPlayer.job.name) then
            notify(src, S.police_cant, 'error')
            return nil
        end
        if inList(Config.BlockedJobs, xPlayer.job.name) then
            notify(src, S.off_duty, 'error')
            return nil
        end
    end
    return xPlayer
end

local function notifyParticipants(msg, typ)
    for src in pairs(Heist.participants) do
        if isOnline(src) then notify(src, msg, typ) end
    end
end

-- What every client should currently have as target zones.
local function buildPayload()
    local crates = {}
    if Heist.stage == 'active' and (not C.requireHackForLoot or Heist.hackDone) then
        for idx, crate in pairs(Heist.crates) do
            if not crate.looted and not crate.claimedBy then
                crates[#crates + 1] = idx
            end
        end
    end
    return {
        crates = crates,
        laptop = (Heist.stage == 'active' and Heist.hackAvailable) or false,
    }
end

local function syncAll()
    TriggerClientEvent('oilrig:client:sync', -1, buildPayload())
end

local function deleteGuards()
    for _, netId in ipairs(Heist.guards) do
        local ent = NetworkGetEntityFromNetworkId(netId)
        if ent and ent ~= 0 and DoesEntityExist(ent) then
            DeleteEntity(ent)
        end
    end
    Heist.guards = {}
end

local function resetHeist(reason, refundCooldown)
    deleteGuards()
    Heist = newState()
    if refundCooldown then LastRob = 0 end
    TriggerClientEvent('oilrig:client:reset', -1)
    if reason then
        print(('[Unique_OilRig] heist reset (%s)'):format(reason))
    end
end

local function remainingCrates()
    local n = 0
    for _, crate in pairs(Heist.crates) do
        if not crate.looted then n = n + 1 end
    end
    return n
end

local function pickCrates()
    local idxs = {}
    for i = 1, #C.crates do idxs[i] = i end
    for i = #idxs, 2, -1 do
        local j = math.random(i)
        idxs[i], idxs[j] = idxs[j], idxs[i]
    end
    local count = math.min(C.crateCount, #idxs)
    Heist.crates = {}
    for i = 1, count do
        Heist.crates[idxs[i]] = { looted = false, claimedBy = nil, claimedAt = 0 }
    end
end

local function giveRewards(src, xPlayer)
    for _, r in ipairs(C.crateRewards) do
        if math.random(1, 100) <= (r.chance or 100) then
            local amount = math.random(r.min, r.max)
            if amount > 0 then
                xPlayer.addInventoryItem(r.item, amount)
                notify(src, S.got_item:format(r.item, amount), 'success')
                logHeist(src, xPlayer, 'Crate Reward', ('%s x%d'):format(r.item, amount))
            end
        end
    end
end

-- ----------------------------------------------------------------------
-- Start
-- ----------------------------------------------------------------------
RegisterServerEvent('oilrig:server:start')
AddEventHandler('oilrig:server:start', function()
    local src = source

    -- basic spam guard + must actually be at the start ped
    local now = GetGameTimer()
    if lastAttempt[src] and (now - lastAttempt[src]) < 3000 then return end
    lastAttempt[src] = now
    if distanceTo(src, C.startHeist.pos) > 10.0 then return end

    local xPlayer = getEligiblePlayer(src)
    if not xPlayer then return end

    if Heist.stage ~= 'idle' then
        notify(src, S.in_progress)
        return
    end

    if not Config.TestMode and LastRob ~= 0 and (os.time() - LastRob) < C.cooldown then
        local left = C.cooldown - (os.time() - LastRob)
        notify(src, S.cooldown:format(math.ceil(left / 60)))
        return
    end

    -- Party: leader + close teammates (same logic as Unique_AllRobs)
    local participants = { [src] = true }
    if not Config.TestMode and C.teammatesRequired and C.teammatesRequired > 0 then
        local ok, inTeam, team = pcall(function()
            return exports['Unique_AllRobs']:IsInTeam(src)
        end)
        if not ok then
            notify(src, S.party_down, 'error')
            return
        end
        if not inTeam or not team then
            notify(src, S.need_party)
            return
        end

        local me = team[src] or team[tostring(src)]
        if not me or me.rank ~= 'Leader' then
            notify(src, S.need_leader)
            return
        end

        local total, close = 0, 0
        local myCoords = GetEntityCoords(GetPlayerPed(src))
        for rawId in pairs(team) do
            local mateId = tonumber(rawId)
            if mateId then
                total = total + 1
                local matePed = GetPlayerPed(mateId)
                if matePed and matePed ~= 0 and #(myCoords - GetEntityCoords(matePed)) <= C.teamMaxDistance then
                    close = close + 1
                    participants[mateId] = true
                end
            end
        end

        if total < C.teammatesRequired then
            notify(src, S.need_members:format(C.teammatesRequired))
            return
        end
        if close < C.teammatesRequired then
            notify(src, S.members_far, 'error')
            return
        end
    end

    if not Config.TestMode and countCops() < C.copsRequired then
        notify(src, S.need_police:format(C.copsRequired))
        return
    end

    -- All good: start it
    Heist = newState()
    Heist.stage = 'travel'
    Heist.owner = src
    Heist.participants = participants
    Heist.startedAt = os.time()
    if not Config.TestMode then LastRob = os.time() end

    notify(src, S.heist_started, 'success')
    for pid in pairs(participants) do
        TriggerClientEvent('oilrig:client:begin', pid, pid == src)
    end
    logHeist(src, xPlayer, 'Started')
end)

-- The leader's client tells us it is inside the arrive radius. We verify
-- with the server-side ped position before doing anything.
RegisterServerEvent('oilrig:server:arrived')
AddEventHandler('oilrig:server:arrived', function()
    local src = source
    if Heist.stage ~= 'travel' or src ~= Heist.owner then return end
    if distanceTo(src, C.middleArea) > (C.arriveRadius + 25.0) then return end

    Heist.stage = 'active'
    pickCrates()
    Heist.hackAvailable = true

    -- Dispatch alert for police (blip + chat + HUD timer), handled by Unique_AllRobs
    pcall(function()
        exports['Unique_AllRobs']:AlertPolice(C.middleArea, S.police_alert, C.alertDuration, C.alertRadius)
    end)

    TriggerClientEvent('oilrig:client:spawnGuards', src)
    notifyParticipants(S.arrived)
    syncAll()

    local xPlayer = ESX.GetPlayerFromId(src)
    if xPlayer then logHeist(src, xPlayer, 'Arrived At Rig') end
end)

-- The leader's client spawns the guards as networked peds and reports the
-- ids so the server can delete them when the heist ends.
RegisterServerEvent('oilrig:server:guards')
AddEventHandler('oilrig:server:guards', function(netIds)
    local src = source
    if src ~= Heist.owner or Heist.stage ~= 'active' or Heist.guardsReported then return end
    if type(netIds) ~= 'table' or #netIds > #C.guards.peds then return end
    for _, id in ipairs(netIds) do
        if type(id) == 'number' then
            Heist.guards[#Heist.guards + 1] = id
        end
    end
    Heist.guardsReported = true
end)

-- ----------------------------------------------------------------------
-- Hack
-- ----------------------------------------------------------------------
RegisterServerEvent('oilrig:server:hackStart')
AddEventHandler('oilrig:server:hackStart', function()
    local src = source
    if Heist.stage ~= 'active' then return end

    local xPlayer = getEligiblePlayer(src)
    if not xPlayer then return end

    if Heist.hackDone then return end
    if Heist.hackBy or not Heist.hackAvailable then
        notify(src, S.hack_busy)
        return
    end
    if distanceTo(src, C.laptop.coords) > C.interactDistance then return end

    if not Config.TestMode then
        local item = xPlayer.getInventoryItem(C.requiredItem)
        if not item or item.count < 1 then
            notify(src, S.need_item:format(item and item.label or C.requiredItem), 'error')
            return
        end

        if C.consumeItem then
            xPlayer.removeInventoryItem(C.requiredItem, 1)
        end
    end

    Heist.hackBy = src
    Heist.hackAvailable = false
    Heist.hackStartedAt = GetGameTimer()
    syncAll() -- laptop zone disappears for everyone else
    TriggerClientEvent('oilrig:client:startHack', src)
    logHeist(src, xPlayer, 'Hack Started')
end)

RegisterServerEvent('oilrig:server:hackResult')
AddEventHandler('oilrig:server:hackResult', function(success)
    local src = source
    if Heist.stage ~= 'active' or Heist.hackBy ~= src then return end
    Heist.hackBy = nil

    local xPlayer = ESX.GetPlayerFromId(src)

    -- A real minigame can't be finished in under 4 seconds
    if success and (GetGameTimer() - Heist.hackStartedAt) < 4000 then
        print(('[Unique_OilRig] suspicious hack result from %s (%s) - too fast, rejected'):format(src, GetPlayerName(src)))
        success = false
    end

    if success then
        Heist.hackDone = true
        Heist.hackAvailable = false

        local list = {}
        for idx, crate in pairs(Heist.crates) do
            if not crate.looted then list[#list + 1] = idx end
        end
        Heist.participants[src] = true
        for pid in pairs(Heist.participants) do
            if isOnline(pid) then
                TriggerClientEvent('oilrig:client:reveal', pid, list)
                notify(pid, S.hack_ok, 'success')
            end
        end
        if xPlayer then logHeist(src, xPlayer, 'Hack Success') end
    else
        Heist.hackAvailable = true
        notify(src, S.hack_fail, 'error')
        if xPlayer then logHeist(src, xPlayer, 'Hack Failed') end
    end
    syncAll()
end)

-- ----------------------------------------------------------------------
-- Crates
-- ----------------------------------------------------------------------
RegisterServerEvent('oilrig:server:lootStart')
AddEventHandler('oilrig:server:lootStart', function(idx)
    local src = source
    idx = tonumber(idx)
    if Heist.stage ~= 'active' or not idx then return end

    local crate, cfg = Heist.crates[idx], C.crates[idx]
    if not crate or not cfg or crate.looted then return end

    local xPlayer = getEligiblePlayer(src)
    if not xPlayer then return end

    if C.requireHackForLoot and not Heist.hackDone then
        notify(src, S.hack_first)
        return
    end
    if crate.claimedBy then
        notify(src, S.crate_taken)
        return
    end
    if distanceTo(src, cfg.coords) > C.interactDistance then return end

    -- one crate at a time per player
    for _, other in pairs(Heist.crates) do
        if other.claimedBy == src then return end
    end

    crate.claimedBy = src
    crate.claimedAt = GetGameTimer()
    syncAll() -- zone disappears for everyone else while it is being searched
    TriggerClientEvent('oilrig:client:lootCrate', src, idx)
end)

RegisterServerEvent('oilrig:server:lootCancel')
AddEventHandler('oilrig:server:lootCancel', function(idx)
    local src = source
    idx = tonumber(idx)
    local crate = idx and Heist.crates[idx]
    if crate and not crate.looted and crate.claimedBy == src then
        crate.claimedBy = nil
        syncAll() -- crate is searchable again
    end
end)

RegisterServerEvent('oilrig:server:lootDone')
AddEventHandler('oilrig:server:lootDone', function(idx)
    local src = source
    idx = tonumber(idx)
    if Heist.stage ~= 'active' or not idx then return end

    local crate, cfg = Heist.crates[idx], C.crates[idx]
    if not crate or not cfg or crate.looted or crate.claimedBy ~= src then return end

    -- must have really waited (small tolerance for latency) and still be nearby
    if (GetGameTimer() - crate.claimedAt) < (C.lootTime * 1000 - 1500) then
        print(('[Unique_OilRig] suspicious loot from %s (%s) - finished too fast'):format(src, GetPlayerName(src)))
        return
    end
    if distanceTo(src, cfg.coords) > (C.interactDistance + 4.0) then return end

    local xPlayer = ESX.GetPlayerFromId(src)
    if not xPlayer then return end

    crate.looted = true
    crate.claimedBy = nil
    giveRewards(src, xPlayer)

    if remainingCrates() == 0 then
        Heist.stage = 'done'
        Heist.doneAt = os.time()
        notifyParticipants(S.all_looted)
        notify(src, S.all_looted)
        logHeist(src, xPlayer, 'All Crates Looted')
    end
    syncAll()
end)

-- ----------------------------------------------------------------------
-- Late joiners / reconnects
-- ----------------------------------------------------------------------
RegisterServerEvent('oilrig:server:requestState')
AddEventHandler('oilrig:server:requestState', function()
    TriggerClientEvent('oilrig:client:sync', source, buildPayload())
end)

-- ----------------------------------------------------------------------
-- Commands
-- ----------------------------------------------------------------------
-- Police can reset the rig (same as the original /pdoilrig)
RegisterCommand('pdoilrig', function(source)
    if source == 0 then
        resetHeist('console')
        return
    end
    local xPlayer = ESX.GetPlayerFromId(source)
    if not xPlayer then return end
    if isPolice(xPlayer.job.name) then
        resetHeist('police ' .. source)
        notify(source, S.reset, 'success')
    else
        notify(source, S.not_cop, 'error')
    end
end)

-- Admin reset (ace restricted: command.oilrigreset). Also clears the cooldown.
RegisterCommand('oilrigreset', function(source)
    resetHeist('admin ' .. tostring(source), true)
    if source ~= 0 then notify(source, S.reset, 'success') end
end, true)

-- ----------------------------------------------------------------------
-- Cleanup
-- ----------------------------------------------------------------------
AddEventHandler('playerDropped', function()
    local src = source
    lastAttempt[src] = nil
    if Heist.stage == 'idle' then return end

    local changed = false
    Heist.participants[src] = nil

    if Heist.hackBy == src then
        Heist.hackBy = nil
        Heist.hackAvailable = not Heist.hackDone
        changed = true
    end
    for _, crate in pairs(Heist.crates) do
        if crate.claimedBy == src then
            crate.claimedBy = nil
            changed = true
        end
    end

    -- Leader left before even reaching the rig: nothing was spawned, give the cooldown back
    if Heist.stage == 'travel' and Heist.owner == src then
        resetHeist('leader dropped before arrival', true)
        return
    end
    if changed then syncAll() end
end)

AddEventHandler('onResourceStop', function(res)
    if res == GetCurrentResourceName() then
        deleteGuards()
    end
end)

-- Watchdog: timeouts, stuck locks
CreateThread(function()
    while true do
        Wait(5000)
        if Heist.stage ~= 'idle' then
            local age = os.time() - Heist.startedAt

            if Heist.stage == 'travel' and age > C.travelTimeout then
                notify(Heist.owner, S.aborted, 'error')
                resetHeist('travel timeout', true)
            elseif age > C.maxDuration then
                resetHeist('max duration')
            elseif Heist.stage == 'done' and (os.time() - Heist.doneAt) > C.cleanupAfterDone then
                resetHeist('completed')
            else
                local changed = false

                -- laptop lock held too long (client crashed mid-minigame)
                if Heist.hackBy and (GetGameTimer() - Heist.hackStartedAt) > 180000 then
                    Heist.hackBy = nil
                    Heist.hackAvailable = not Heist.hackDone
                    changed = true
                end

                -- crate claim held too long (client crashed mid-loot)
                for _, crate in pairs(Heist.crates) do
                    if crate.claimedBy and (GetGameTimer() - crate.claimedAt) > (C.lootTime * 1000 + 15000) then
                        crate.claimedBy = nil
                        changed = true
                    end
                end

                if changed then syncAll() end
            end
        end
    end
end)
