-- Unique_AdminPanel | server/nlr.lua
-- New Life Rule, server side. The server keeps the record of every active restriction and checks
-- player positions itself, so a modified client (deleting KVP, blocking events) can't dodge it.
-- (ESX and the helpers come from server/main.lua and server/rules_common.lua)

local Cfg = NLRConfig
local Records = {}  -- identifier -> { coords, expiresAt, diedAt, started, strikes, checks, lastViolation }

local function persist(identifier)
    local rec = Records[identifier]
    if rec then SetResourceKvp('nlr:' .. identifier, json.encode(rec)) else DeleteResourceKvp('nlr:' .. identifier) end
end

local function markDeath(src, clientCoords)
    local identifier = RulesIdentifier(src)
    if not identifier then return end
    if (RulesSkipNLR[identifier] or 0) > os.time() then return end -- killed by VDM: no New Life
    -- prefer the position the SERVER sees; only fall back to the client's if OneSync can't tell
    local coords = RulesCoords(src) or clientCoords
    if type(coords) ~= 'table' or type(coords.x) ~= 'number' or type(coords.y) ~= 'number' or type(coords.z) ~= 'number' then return end
    local old = Records[identifier]
    Records[identifier] = {
        coords = { x = coords.x, y = coords.y, z = coords.z },
        diedAt = os.time(), expiresAt = os.time() + Cfg.Duration,
        started = false, strikes = old and old.strikes or 0, checks = 0, lastViolation = 0,
    }
    persist(identifier)
end

RegisterNetEvent('antiNonRP:sv:died', function(coords)
    local src = source
    if RulesLimited(src, 'nlr_died', 10) then return end
    markDeath(src, coords)
end)

RegisterNetEvent('antiNonRP:sv:started', function()
    local identifier = RulesIdentifier(source)
    local rec = identifier and Records[identifier]
    if rec then rec.started = true end
end)

local function sendRecord(src)
    local identifier = RulesIdentifier(src)
    if not identifier then return end
    if not Records[identifier] then
        local raw = GetResourceKvpString('nlr:' .. identifier)
        local rec = raw and json.decode(raw)
        if rec and rec.expiresAt and rec.expiresAt > os.time() then Records[identifier] = rec end
    end
    local rec = Records[identifier]
    if rec and rec.expiresAt > os.time() then
        TriggerClientEvent('antiNonRP:cl:record', src, { coords = rec.coords, expiresAt = rec.expiresAt })
    else
        TriggerClientEvent('antiNonRP:cl:record', src, false)
    end
end

RegisterNetEvent('antiNonRP:sv:requestRecord', function()
    if RulesLimited(source, 'nlr_req', 5) then return end
    sendRecord(source)
end)

-- push the record right after login (the client also asks once, whichever comes first wins)
AddEventHandler('esx:playerLoaded', function(src)
    SetTimeout(4000, function()
        if GetPlayerName(src) then sendRecord(src) end
    end)
end)

-- ------------------------------------------------------------ alerts ---

local function notifyAdmins(src, rec, d, label)
    local name = GetPlayerName(src) or '?'
    local coords = RulesCoords(src) or rec.coords
    RulesEachAdmin(function(id)
        TriggerClientEvent('chat:addMessage', id, { args = { '^1[NLR]',
            ('[%s] %s در ^3%dm^0 از مکان مرگش (نیو لایف) - %s'):format(src, name, math.floor(d), label) } })
        TriggerClientEvent('antiNonRP:cl:adminAlert', id, { id = src, name = name, coords = coords })
    end)
end

-- soft alert (old alarm()): no strike, once per AdminAlarmCooldown
RegisterNetEvent('antiNonRP:sv:near', function()
    local src = source
    if RulesLimited(src, 'nlr_near', Cfg.AdminAlarmCooldown) then return end
    local identifier = RulesIdentifier(src)
    local rec = identifier and Records[identifier]
    local here = RulesCoords(src)
    if not rec or rec.expiresAt <= os.time() or not here then return end
    local d = RulesDist(here, rec.coords)
    if d <= Cfg.CoreRadius + 15.0 then notifyAdmins(src, rec, d, 'نزدیک شد') end
end)

local function registerViolation(src, rec, identifier, d, via)
    if os.time() - (rec.lastViolation or 0) < 20 then return end
    rec.lastViolation = os.time()
    rec.strikes = (rec.strikes or 0) + 1
    persist(identifier)
    TriggerClientEvent('antiNonRP:cl:finalWarning', src, rec.strikes)
    notifyAdmins(src, rec, d, ('اخطار #%d (%s)'):format(rec.strikes, via))
    RulesLog('nlr_violation', ('stayed %dm from his death spot (strike %d, %s)'):format(math.floor(d), rec.strikes, via), identifier, GetPlayerName(src))
    if Cfg.AutoFlagStrikes > 0 and rec.strikes >= Cfg.AutoFlagStrikes then
        RulesFlag(identifier, ('New Life violations: %d (stayed near death location)'):format(rec.strikes))
    end
end

RegisterNetEvent('antiNonRP:sv:violation', function()
    local src = source
    if RulesLimited(src, 'nlr_violation', 20) then return end
    local identifier = RulesIdentifier(src)
    local rec = identifier and Records[identifier]
    if not rec or rec.expiresAt <= os.time() then return end
    local here = RulesCoords(src) -- never trust the client's number: measure it here
    if not here then return end
    local d = RulesDist(here, rec.coords)
    if d <= Cfg.CoreRadius + 15.0 then registerViolation(src, rec, identifier, d, 'client-report') end
end)

-- authoritative loop: only players that currently have a record are looked at
CreateThread(function()
    while true do
        Wait(Cfg.ServerCheckInterval)
        local now = os.time()
        for identifier, rec in pairs(Records) do
            if rec.expiresAt <= now then
                Records[identifier] = nil
                persist(identifier)
            else
                local x = ESX.GetPlayerFromIdentifier(identifier)
                if x then
                    local src = x.source
                    local active = rec.started or (now - rec.diedAt) > 60 -- a client that never says "started" is treated as started after 60s
                    local ped = GetPlayerPed(src)
                    if active and ped and ped ~= 0 and GetEntityHealth(ped) > 0 and GetPlayerRoutingBucket(src) == 0 then
                        local d = RulesDist(RulesCoords(src), rec.coords)
                        if d < Cfg.CoreRadius then
                            rec.checks = (rec.checks or 0) + 1
                            if rec.checks >= Cfg.ServerCheckLimit then
                                rec.checks = 0
                                registerViolation(src, rec, identifier, d, 'server-check')
                            end
                        else
                            rec.checks = 0
                        end
                    end
                end
            end
        end
    end
end)

if Cfg.PollDeath then
    local wasDead = {}
    AddEventHandler('playerDropped', function() wasDead[source] = nil end)
    CreateThread(function()
        while true do
            Wait(2000)
            for _, id in ipairs(ESX.GetPlayers()) do
                local ped = GetPlayerPed(id)
                local dead = ped and ped ~= 0 and GetEntityHealth(ped) <= 0
                if dead and not wasDead[id] then
                    local identifier = RulesIdentifier(id)
                    local rec = identifier and Records[identifier]
                    if identifier and (not rec or os.time() - (rec.diedAt or 0) > 30) then markDeath(id) end
                end
                wasDead[id] = dead
            end
        end
    end)
end

-- ------------------------------------------------------- clear / exports ---
-- exports['Unique_AdminPanel']:ClearNewLife(src, force)  replaces
-- TriggerClientEvent('antiNonRP:clearNewLifeData', src, force) in other server scripts.
function ClearNewLife(src, force)
    local identifier = RulesIdentifier(src)
    local rec = identifier and Records[identifier]
    if rec and (force or not rec.started) then
        Records[identifier] = nil
        persist(identifier)
    end
    TriggerClientEvent('antiNonRP:clearNewLifeData', src, force)
end
exports('ClearNewLife', ClearNewLife)
exports('GetNewLife', function(src)
    local identifier = RulesIdentifier(src)
    local rec = identifier and Records[identifier]
    if rec and rec.expiresAt > os.time() then return rec end
end)

-- panel button: F4 > Player Tools > Quick Actions > Clear New Life
RegisterServerEvent('Unique_AdminPanel:ClearNewLife')
AddEventHandler('Unique_AdminPanel:ClearNewLife', function(targetId)
    local src = source
    if not IsOnDutyAdmin(src) or not AdminMinLevel(src, 2) then return end
    targetId = tonumber(targetId)
    local x = targetId and ESX.GetPlayerFromId(targetId)
    if not x then return end
    ClearNewLife(targetId, true)
    LogAdminAction(src, 'nlr_clear', ('target: %s (id:%s)'):format(GetPlayerName(targetId), targetId), x.identifier, GetPlayerName(targetId))
    TriggerClientEvent('Unique_AdminPanel:MenuNotify', src, '~g~New Life cleared')
end)

RegisterCommand('nlrlist', function(src)
    if not RulesIsStaff(src, 1) then return end
    local now, n = os.time(), 0
    for identifier, rec in pairs(Records) do
        if rec.expiresAt > now then
            local x = ESX.GetPlayerFromIdentifier(identifier)
            n = n + 1
            local line = ('%s | %dm left | strikes %d'):format(x and ('[' .. x.source .. '] ' .. GetPlayerName(x.source)) or identifier, math.floor((rec.expiresAt - now) / 60), rec.strikes or 0)
            if src == 0 then dprint(line) else TriggerClientEvent('chat:addMessage', src, { args = { '^3[NLR]', line } }) end
        end
    end
    if n == 0 and src ~= 0 then TriggerClientEvent('chat:addMessage', src, { args = { '^3[NLR]', 'هیچ‌کس الان نیو لایف نیست.' } }) end
end, false)

RegisterCommand('nlrclear', function(src, args)
    if not RulesIsStaff(src, 2) then return end
    local target = tonumber(args[1])
    if target and GetPlayerName(target) then
        ClearNewLife(target, true)
        if src ~= 0 then TriggerClientEvent('chat:addMessage', src, { args = { '^2[NLR]', 'پاک شد.' } }) end
    end
end, false)
