-- ============================================================
-- Unique_OilRig (merged into Unique_AllRobs) -- server
--
-- The initial marker interaction, cops/party/cooldown/off-duty checks,
-- and item consumption ALL go through the EXISTING generic
-- 'Morphy_RobSystem:robberyNeeds' handler in server.lua (zero duplicated
-- code -- it already works generically for any Config.Rob.Robs entry).
-- This file only handles what happens AFTER that: travel, arrival,
-- guards, hack, crates, escape, delivery.
--
-- Final payout goes through the STOCK 'Morphy_RobSystem:robberySuccess'
-- handler in server.lua (unmodified) -- this file just scales
-- Config.Rob.RobTypes.OilRig.reward right before firing it, and restores
-- it after. Since only one Oil Rig heist can ever be active at a time
-- (single Robs entry, gated by someonerobbing), that's safe.
-- Crime-scene evidence (esx_uniquejobs/cad/crimescene.lua) fires
-- automatically off that same event -- no extra wiring needed here.
-- ============================================================

ESX = ESX or nil
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

local C = Config.OilRig
local ROBNAME = 'OilRig_1'
local BLOCKED_JOBS = { ambulance = true, taxi = true, mechanic = true }

local function isEligible(xPlayer)
    if not xPlayer then return false end
    if IsPoliceJob(xPlayer.job.name) then return false end
    if BLOCKED_JOBS[xPlayer.job.name] then return false end
    return true
end

local function notify(src, msg, typ)
    TriggerClientEvent('esx:showNotification', src, msg, typ)
end

local function distanceTo(src, coords)
    local ped = GetPlayerPed(src)
    if not ped or ped == 0 then return math.huge end
    return #(GetEntityCoords(ped) - coords)
end

local function countCops()
    local cops = 0
    local xPlayers = ESX.GetPlayers()
    for i = 1, #xPlayers do
        local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
        if xPlayer and IsPoliceJob(xPlayer.job.name) then cops = cops + 1 end
    end
    return cops
end

-- ------------------------------------------------------------------
-- Legendary Mode persistence -- plain resource KVP (built into FiveM,
-- survives resource/server restarts, no SQL migration needed). Two
-- keys: when the week-long cooldown ends, and who currently holds the
-- board (JSON-encoded).
-- ------------------------------------------------------------------
local KVP_NEXT = 'oilrig_legendary_next_available'
local KVP_HOLDER = 'oilrig_legendary_holder'

local function GetLegendaryNextAvailable()
    local v = GetResourceKvpInt(KVP_NEXT)
    return v or 0 -- 0 (or unset) means "available right now"
end

local function SetLegendaryNextAvailable(ts)
    SetResourceKvpInt(KVP_NEXT, math.floor(ts))
end

local function GetLegendaryHolder()
    local raw = GetResourceKvpString(KVP_HOLDER)
    if not raw or raw == '' then return nil end
    local ok, decoded = pcall(json.decode, raw)
    if ok then return decoded end
    return nil
end

local function SetLegendaryHolder(holder)
    SetResourceKvp(KVP_HOLDER, json.encode(holder))
end

local function IsLegendaryAvailable()
    return os.time() >= GetLegendaryNextAvailable()
end

local function BroadcastLegendaryState(target)
    local holder = GetLegendaryHolder()
    if holder then
        holder.dateText = os.date('%Y-%m-%d', holder.date or 0)
    end
    TriggerClientEvent('oilrig:client:legendarySync', target or -1, {
        available = IsLegendaryAvailable(),
        nextAvailableText = os.date('%Y-%m-%d', GetLegendaryNextAvailable()),
        holder = holder,
    })
end

-- ------------------------------------------------------------------
-- State (single instance -- OilRig_1 is the only Robs entry of this type)
-- ------------------------------------------------------------------
local function newState()
    return {
        stage         = 'idle', -- idle | travel | active | escaping
        leader        = nil,
        participants  = {},     -- [source] = true
        startedAt     = 0,
        arrivedAt     = 0,
        escapeStartAt = 0,
        crates        = {},     -- [idx] = { looted, claimedBy, claimedAt }
        hackAvailable = false,
        hackDone      = false,
        hackBy        = nil,
        hackStartedAt = 0,
        guards        = {},     -- network ids
        guardsReported = false,
        pursuitFired  = false,
        code          = 0,      -- captured from StartRobberyDispatch at arrival
        legendary     = false,  -- decided once, at oilrig:server:begin
    }
end

local State = newState()
local legendaryAnnouncedOpen = false

local function notifyParticipants(msg, typ)
    for src in pairs(State.participants) do
        if GetPlayerName(src) then notify(src, msg, typ) end
    end
end

local function remainingCrates()
    local n = 0
    for _, crate in pairs(State.crates) do
        if not crate.looted then n = n + 1 end
    end
    return n
end

local function buildPayload()
    local crates = {}
    if State.stage == 'active' and State.hackDone then
        for idx, crate in pairs(State.crates) do
            if not crate.looted and not crate.claimedBy then
                crates[#crates + 1] = idx
            end
        end
    end
    return {
        crates = crates,
        laptop = (State.stage == 'active' and State.hackAvailable) or false,
    }
end

local function syncAll()
    TriggerClientEvent('oilrig:client:sync', -1, buildPayload())
end

local function deleteGuards()
    for _, netId in ipairs(State.guards) do
        local ent = NetworkGetEntityFromNetworkId(netId)
        if ent and ent ~= 0 and DoesEntityExist(ent) then
            DeleteEntity(ent)
        end
    end
    State.guards = {}
end

local function resetOilRig()
    deleteGuards()
    State = newState()
    TriggerClientEvent('oilrig:client:reset', -1)
end

-- ------------------------------------------------------------------
-- Hook the SAME events the generic pipeline fires for OilRig_1, purely
-- additively (AddEventHandler on an event name that already has a
-- handler -- same trick esx_uniquejobs/cad/crimescene.lua already uses
-- on robberySuccess).
-- ------------------------------------------------------------------

-- robberyNeeds just passed: someonerobbing=true, RobsInProgress[leader]=OilRig_1,
-- and the client was told to run hacktype 3 (oilrig_client.lua's travel flow).
-- Nothing to do here server-side yet -- State stays 'idle' until arrival,
-- so travel doesn't get timed out by the watchdog before it even starts.
RegisterServerEvent('oilrig:server:begin')
AddEventHandler('oilrig:server:begin', function()
    local _source = source
    if RobsInProgress[_source] ~= ROBNAME then return end
    if State.stage ~= 'idle' then return end

    State = newState()
    State.stage = 'travel'
    State.leader = _source
    State.participants[_source] = true
    State.startedAt = os.time()
    State.legendary = IsLegendaryAvailable()
    if State.legendary then
        notify(_source, C.legendary.strings.run_is_legendary, 'success')
    end

    -- Bring along whoever was close enough to count as "team" for the
    -- teammatesrequired check in robberyNeeds -- they get notified/synced
    -- too, but only the leader can ultimately deliver the bag (see
    -- oilrig:server:deliver).
    local ok, inTeam, team = pcall(function()
        return exports[GetCurrentResourceName()]:IsInTeam(_source)
    end)
    if ok and inTeam and type(team) == 'table' then
        for rawId in pairs(team) do
            local mateId = tonumber(rawId)
            if mateId then State.participants[mateId] = true end
        end
    end
end)

RegisterServerEvent('oilrig:server:arrived')
AddEventHandler('oilrig:server:arrived', function()
    local _source = source
    if State.stage ~= 'travel' or _source ~= State.leader then return end
    if RobsInProgress[_source] ~= ROBNAME then return end
    if distanceTo(_source, C.middleArea) > (C.arriveRadius + 25.0) then return end

    State.stage = 'active'
    State.arrivedAt = os.time()

    -- Same dispatch/case/discord/cooldown side-effects every other
    -- robbery type gets when it "really" starts -- see StartRobberyDispatch
    -- in server.lua. Captured into State.code (not re-read from the
    -- shared RobberyCode global at delivery time) because RobberyCode
    -- keeps incrementing for OTHER robberies that can start and finish
    -- during this heist's long hack/loot/escape phase.
    State.code = StartRobberyDispatch(ROBNAME, _source, C.middleArea)

    -- Pick crates
    local idxs = {}
    for i = 1, #C.crates do idxs[i] = i end
    for i = #idxs, 2, -1 do
        local j = math.random(i)
        idxs[i], idxs[j] = idxs[j], idxs[i]
    end
    State.crates = {}
    for i = 1, math.min(C.crateCount, #idxs) do
        State.crates[idxs[i]] = { looted = false, claimedBy = nil, claimedAt = 0 }
    end

    State.hackAvailable = true

    -- Scaling: cops online + party size beyond the RobTypes baseline
    local cops = countCops()
    local partySize = 0
    for _ in pairs(State.participants) do partySize = partySize + 1 end
    local base = Config.Rob.RobTypes['OilRig']
    local extraCops = math.max(0, cops - base.copsrequired)
    local extraMembers = math.max(0, partySize - base.teammatesrequired)
    local guardCount = math.min(#C.guards.peds, C.scaling.guardsBase + extraCops * C.scaling.extraGuardsPerCop + extraMembers * C.scaling.extraGuardsPerMember)
    if State.legendary and C.legendary.forceFullGuards then
        guardCount = #C.guards.peds
    end

    TriggerClientEvent('oilrig:client:spawnGuards', _source, guardCount)
    notifyParticipants(C.strings.heist_info)
    notifyParticipants(C.strings.arrived)
    syncAll()
end)

RegisterServerEvent('oilrig:server:requestState')
AddEventHandler('oilrig:server:requestState', function()
    TriggerClientEvent('oilrig:client:sync', source, buildPayload())
    BroadcastLegendaryState(source)
end)

RegisterServerEvent('oilrig:server:guards')
AddEventHandler('oilrig:server:guards', function(netIds)
    local _source = source
    if _source ~= State.leader or State.stage == 'idle' or State.guardsReported then return end
    if type(netIds) ~= 'table' then return end
    for _, id in ipairs(netIds) do
        if type(id) == 'number' then State.guards[#State.guards + 1] = id end
    end
    State.guardsReported = true
end)

-- ------------------------------------------------------------------
-- Hack
-- ------------------------------------------------------------------
RegisterServerEvent('oilrig:server:hackStart')
AddEventHandler('oilrig:server:hackStart', function()
    local _source = source
    if State.stage ~= 'active' or State.hackDone then return end
    local xPlayer = ESX.GetPlayerFromId(_source)
    if not isEligible(xPlayer) then return end
    if State.hackBy or not State.hackAvailable then
        notify(_source, C.strings.hack_busy)
        return
    end
    if distanceTo(_source, C.laptop.coords) > C.interactDistance then return end

    State.hackBy = _source
    State.hackAvailable = false
    State.hackStartedAt = GetGameTimer()
    syncAll()
    TriggerClientEvent('oilrig:client:startHack', _source)
end)

RegisterServerEvent('oilrig:server:hackResult')
AddEventHandler('oilrig:server:hackResult', function(success)
    local _source = source
    if State.stage ~= 'active' or State.hackBy ~= _source then return end
    State.hackBy = nil

    if success and (GetGameTimer() - State.hackStartedAt) < 4000 then
        print(('[Unique_OilRig] suspicious hack result from %s - too fast, rejected'):format(_source))
        success = false
    end

    if success then
        State.hackDone = true
        State.hackAvailable = false
        local list = {}
        for idx in pairs(State.crates) do list[#list + 1] = idx end
        TriggerClientEvent('oilrig:client:reveal', -1, list)
        notifyParticipants(C.strings.hack_ok, 'success')
    else
        State.hackAvailable = true
        notify(_source, C.strings.hack_fail, 'error')
    end
    syncAll()
end)

-- ------------------------------------------------------------------
-- Crates
-- ------------------------------------------------------------------
RegisterServerEvent('oilrig:server:lootStart')
AddEventHandler('oilrig:server:lootStart', function(idx)
    local _source = source
    idx = tonumber(idx)
    if State.stage ~= 'active' or not State.hackDone or not idx then
        if State.stage == 'active' and not State.hackDone then notify(_source, C.strings.hack_first) end
        return
    end

    local crate, cfg = State.crates[idx], C.crates[idx]
    if not crate or not cfg or crate.looted then return end
    if crate.claimedBy then
        notify(_source, C.strings.crate_taken)
        return
    end

    local xPlayer = ESX.GetPlayerFromId(_source)
    if not isEligible(xPlayer) then return end
    if distanceTo(_source, cfg.coords) > C.interactDistance then return end

    for _, other in pairs(State.crates) do
        if other.claimedBy == _source then return end -- one crate at a time per player
    end

    crate.claimedBy = _source
    crate.claimedAt = GetGameTimer()
    syncAll()
    TriggerClientEvent('oilrig:client:lootCrate', _source, idx)
end)

RegisterServerEvent('oilrig:server:lootCancel')
AddEventHandler('oilrig:server:lootCancel', function(idx)
    local _source = source
    idx = tonumber(idx)
    local crate = idx and State.crates[idx]
    if crate and not crate.looted and crate.claimedBy == _source then
        crate.claimedBy = nil
        syncAll()
    end
end)

RegisterServerEvent('oilrig:server:lootDone')
AddEventHandler('oilrig:server:lootDone', function(idx)
    local _source = source
    idx = tonumber(idx)
    if State.stage ~= 'active' or not idx then return end

    local crate, cfg = State.crates[idx], C.crates[idx]
    if not crate or not cfg or crate.looted or crate.claimedBy ~= _source then return end
    if (GetGameTimer() - crate.claimedAt) < (C.lootTime * 1000 - 1500) then
        print(('[Unique_OilRig] suspicious loot from %s - finished too fast'):format(_source))
        return
    end
    if distanceTo(_source, cfg.coords) > (C.interactDistance + 4.0) then return end

    local xPlayer = ESX.GetPlayerFromId(_source)
    if not xPlayer then return end

    crate.looted = true
    crate.claimedBy = nil

    for _, r in ipairs(C.crateRewards) do
        if math.random(1, 100) <= r.chance then
            local amount = math.random(r.min, r.max)
            xPlayer.addInventoryItem(r.item, amount)
        end
    end

    if remainingCrates() == 0 then
        State.stage = 'escaping'
        State.escapeStartAt = os.time()
        local xLeader = ESX.GetPlayerFromId(State.leader)
        if xLeader then
            xLeader.addInventoryItem(C.escape.bagItem, 1)
            notify(State.leader, C.strings.got_bag, 'success')
            notify(State.leader, C.strings.escape_info)
        end
        notifyParticipants(C.strings.all_looted)
        TriggerClientEvent('oilrig:client:escapeBegin', State.leader)
    end
    syncAll()
end)

-- ------------------------------------------------------------------
-- Escape / delivery
-- ------------------------------------------------------------------
RegisterServerEvent('oilrig:server:deliver')
AddEventHandler('oilrig:server:deliver', function()
    local _source = source
    if State.stage ~= 'escaping' then return end
    if _source ~= State.leader then
        notify(_source, "In Kif Faghat Tavasote Leader Ghabele Taslim Ast.", 'error')
        return
    end
    if distanceTo(_source, C.escape.dropoff) > C.escape.dropRadius then return end

    local xPlayer = ESX.GetPlayerFromId(_source)
    if not xPlayer then return end
    local bag = xPlayer.getInventoryItem(C.escape.bagItem)
    if not bag or bag.count < 1 then return end

    xPlayer.removeInventoryItem(C.escape.bagItem, 1)
    notify(_source, C.strings.delivered, 'success')

    -- Rare loot roll -- independent of the shared reward table.
    for _, loot in ipairs(C.rareLoot) do
        if math.random(1, 100) <= loot.chance then
            xPlayer.addInventoryItem(loot.item, 1)
            notify(_source, ('Shoma Yek %s Peida Kardid!'):format(loot.label), 'success')
        end
    end

    -- Scale the shared reward table by online cops + party size, fire the
    -- STOCK robberySuccess handler (pays blackmoney + xprig, files the
    -- §13 charge, logs the criminal record, schedules the court hearing,
    -- and triggers crimescene.lua's crime-scene hook -- all unmodified),
    -- then restore the base range so the next heist starts from scratch.
    local base = Config.OilRig.rewardBase or {
        reward = { min = 3000000, max = 4500000 },
        lessreward = { min = 900000, max = 1300000 },
    }
    local cops = countCops()
    local partySize = 0
    for _ in pairs(State.participants) do partySize = partySize + 1 end
    local mult = 1 + math.min(
        C.scaling.rewardMultiplierCap - 1,
        cops * C.scaling.rewardPerCop + math.max(0, partySize - 1) * C.scaling.rewardPerPartyMember
    )
    if State.legendary then
        mult = math.min(C.legendary.totalMultiplierCap, mult * C.legendary.rewardMultiplier)
    end

    local rt = Config.Rob.RobTypes['OilRig']
    local originalReward, originalLess = rt.reward.blackmoney, rt.lessreward.blackmoney
    rt.reward.blackmoney = { min = math.floor(base.reward.min * mult), max = math.floor(base.reward.max * mult) }
    rt.lessreward.blackmoney = { min = math.floor(base.lessreward.min * mult), max = math.floor(base.lessreward.max * mult) }

    TriggerEvent('Morphy_RobSystem:robberySuccess', ROBNAME, State.code)

    rt.reward.blackmoney, rt.lessreward.blackmoney = originalReward, originalLess

    -- Legendary win: reset the weekly window and engrave the board.
    -- A run that WASN'T legendary never touches any of this, so the
    -- clock only resets on an actual legendary win, never on a normal one.
    if State.legendary then
        SetLegendaryNextAvailable(os.time() + C.legendary.cooldownDays * 86400)
        SetLegendaryHolder({
            gang      = xPlayer.gang and xPlayer.gang.name or 'nogang',
            gangLabel = xPlayer.gang and (xPlayer.gang.label or xPlayer.gang.name) or 'Nogang',
            playerName = xPlayer.name,
            date      = os.time(),
            amountMin = math.floor(base.reward.min * mult),
            amountMax = math.floor(base.reward.max * mult),
        })
        legendaryAnnouncedOpen = false -- lets the watchdog announce again once the new window opens
        BroadcastLegendaryState()

        local wonMsg = C.legendary.strings.won:format(
            xPlayer.gang and (xPlayer.gang.label or xPlayer.gang.name) or 'Nogang',
            math.floor(base.reward.max * mult)
        )
        TriggerClientEvent('esx:showNotification', -1, wonMsg, 'success')
        pcall(function()
            TriggerClientEvent('chat:addMessage', -1, {
                color = { 255, 215, 0 },
                multiline = true,
                args = { '🏆 OIL RIG ASTOOREI', wonMsg },
            })
        end)
    end

    resetOilRig()
end)

-- ------------------------------------------------------------------
-- Cancel / cleanup -- additive hooks on the shared events, same pattern
-- esx_uniquejobs/cad/crimescene.lua already uses on robberySuccess.
-- ------------------------------------------------------------------
AddEventHandler('Morphy_RobSystem:robberyCancel', function(robname)
    if robname == ROBNAME then resetOilRig() end
end)

AddEventHandler('playerDropped', function()
    local _source = source
    if State.stage ~= 'idle' and _source == State.leader then
        -- Generic playerDropped in server.lua already notifies police +
        -- dismisses the DOJ case + frees someonerobbing via RobsInProgress.
        -- This just cleans up guards/zones/local state on top of that.
        resetOilRig()
    else
        State.participants[_source] = nil
        if State.hackBy == _source then
            State.hackBy = nil
            State.hackAvailable = not State.hackDone
            syncAll()
        end
        for _, crate in pairs(State.crates) do
            if crate.claimedBy == _source then
                crate.claimedBy = nil
                syncAll()
            end
        end
    end
end)

-- Server-thread-safe equivalent of firing the shared robberyCancel path:
-- resets the SAME shared flags that handler would (someonerobbing,
-- RobsInProgress, DispatchCode, RobCases, police "cancelled" notice),
-- without relying on the `source` global (which a CreateThread loop --
-- unlike a real event handler -- can't trust to be the right player).
local function FailHeist(reason)
    if State.leader and RobsInProgress[State.leader] == ROBNAME then
        pcall(function() SetAlarmPolice(ROBNAME, 'cancel', State.leader) end)
        if RobCases[State.leader] then
            pcall(function() exports['esx_uniquejobs']:SetExternalCaseStatus(RobCases[State.leader], 'dismissed') end)
        end
        notify(State.leader, reason or 'Oil Rig Heist Cancel Shod.', 'error')
        RobCases[State.leader] = nil
        DispatchCode[State.leader] = nil
        RobsInProgress[State.leader] = nil
    end
    if Config.Rob.Robs[ROBNAME] then
        Config.Rob.Robs[ROBNAME].someonerobbing = false
    end
    resetOilRig()
end

RegisterCommand('oilrigreset', function(source)
    FailHeist('Oil Rig Reset Shod (Admin).')
    if source ~= 0 then notify(source, 'Oil Rig Reset Shod.', 'success') end
end, true)

-- ------------------------------------------------------------------
-- Legendary window watch: announces once, server-wide, the moment the
-- week turns over. Runs independently of the main heist watchdog so a
-- slow heist doesn't delay the check.
-- ------------------------------------------------------------------
legendaryAnnouncedOpen = IsLegendaryAvailable() -- don't re-announce a window that was already open before this restart

CreateThread(function()
    while true do
        Wait(C.legendary.announceCheckEvery * 1000)
        if not legendaryAnnouncedOpen and IsLegendaryAvailable() then
            legendaryAnnouncedOpen = true
            TriggerClientEvent('esx:showNotification', -1, C.legendary.strings.window_open, 'success')
            pcall(function()
                TriggerClientEvent('chat:addMessage', -1, {
                    color = { 255, 215, 0 },
                    multiline = true,
                    args = { '🔥 OIL RIG ASTOOREI', C.legendary.strings.window_open },
                })
            end)
            BroadcastLegendaryState()
        end
    end
end)

-- ------------------------------------------------------------------
-- Watchdog: timeouts + stuck locks, mirrors the rest of the codebase's
-- reset-on-timeout convention.
-- ------------------------------------------------------------------
CreateThread(function()
    while true do
        Wait(5000)
        if State.stage == 'travel' and (os.time() - State.startedAt) > C.travelTimeout then
            FailHeist('Vaghte Raftan Be Oil Rig Tamoom Shod.')
        elseif State.stage ~= 'idle' and State.arrivedAt ~= 0 and (os.time() - State.arrivedAt) > C.maxDuration then
            FailHeist('Oil Rig Heist Vaghtesh Tamoom Shod.')
        elseif State.stage == 'escaping' then
            if not State.pursuitFired and (os.time() - State.escapeStartAt) > C.escape.pursuitDelay then
                State.pursuitFired = true
                local ped = GetPlayerPed(State.leader)
                if ped and ped ~= 0 then
                    pcall(function()
                        AlertPolice(GetEntityCoords(ped), C.strings.pursuit_alert, 3 * 60 * 1000, 150.0)
                    end)
                end
            end
            if (os.time() - State.escapeStartAt) > C.escape.timeLimit then
                local xLeader = ESX.GetPlayerFromId(State.leader)
                if xLeader then
                    pcall(function() xLeader.removeInventoryItem(C.escape.bagItem, 1) end)
                end
                FailHeist(C.strings.lost_bag)
            end
        else
            local changed = false
            if State.hackBy and (GetGameTimer() - State.hackStartedAt) > 180000 then
                State.hackBy = nil
                State.hackAvailable = not State.hackDone
                changed = true
            end
            for _, crate in pairs(State.crates) do
                if crate.claimedBy and (GetGameTimer() - crate.claimedAt) > (C.lootTime * 1000 + 15000) then
                    crate.claimedBy = nil
                    changed = true
                end
            end
            if changed then syncAll() end
        end
    end
end)
