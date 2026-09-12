--[[
    Change World System - Final Merged Version
    Access model:
      - "group" worlds (e.g. Streamer): simple Steam-identifier whitelist,
        entered near CWConfig.ReturnPoint. No admin action needed.
      - "gang" worlds (e.g. Police/Sheriff/Medic): any player whose ESX gang
        matches the world's `label` may use /cw, but only while standing next
        to their gang's Boss Action point (fetched from gangs_data, same as
        the Unique_ALLGangs boss menu). This mirrors how gang boss actions
        already work elsewhere on this server.
      - /changeworld, /backworld, /getworld: admin-only, force override,
        bypasses every check above.
    Combines:
      - the above access model
      - per-player inventory save/load while inside a world
      - Discord webhook logging
    Fixes applied vs earlier drafts:
      - removed duplicate [104] key in world config
      - removed the unauthenticated "send player to any world" event
        (was: ArSa:SetWorld2Player) - replaced with an admin-checked command
      - Discord webhook is empty by default; never commit a real URL to source control
]]

-- NOTE: this server runs an OLD ESX build (on top of essentialmode), which
-- does not expose the exports-based getSharedObject(). It must be fetched
-- with the event, and anything that needs ESX at load time must wait for it.
local ESX = nil

-- ============================================================
-- CONFIG
-- ============================================================

CWConfig = {}

-- Discord webhook URL for action logs. Leave blank to disable logging.
-- NEVER hardcode a real webhook URL in a file you share or commit publicly.
CWConfig.Webhook = ""

-- Where players land when they leave a "group" world (e.g. streamer world)
CWConfig.ReturnPoint = vector3(632.2348, -10.6546, 82.779)

-- Distance from a gang's Boss Action point required to use /cw or /bw in a
-- "gang" world, and from CWConfig.ReturnPoint required for a "group" world.
CWConfig.EntryRadius = 40.0

-- Cooldown (seconds) between /cw or /bw actions - does NOT apply to
-- admin-forced /changeworld or /backworld.
CWConfig.ActionCooldown = 10

-- ESX groups allowed to use the admin commands below
CWConfig.AdminGroups = {
    admin = true,
    superadmin = true,
}

-- World definitions.
-- mode = "group" -> plain Steam-identifier whitelist (see `identifiers`), no
--                   gang or boss-action check, just proximity to ReturnPoint.
-- mode = "gang"  -> any player whose ESX gang name matches `label`
--                   (case-insensitive) may use /cw, provided they are near
--                   their gang's Boss Action point (from gangs_data).
CWConfig.Worlds = {
    [90] = {
        label = "Streamer",
        mode  = "group",
        identifiers = {
            ["steam:110000152126a25"] = true, -- Dariush
            ["steam:110000166709e1e"] = true, -- Morphy
        },
    },
    [100] = { label = "Police",   mode = "gang" },
    [101] = { label = "Sheriff",  mode = "gang" },
    [102] = { label = "Medic",    mode = "gang" },
    [103] = { label = "Mechanic", mode = "gang" },
    [104] = { label = "Taxi",     mode = "gang" },
    [105] = { label = "MT",       mode = "gang" },
}

-- ============================================================
-- HELPERS
-- ============================================================

local function Notify(target, msg)
    TriggerClientEvent('cw:notify', target, msg)
end

local function Log(fmt, ...)
    if CWConfig.Webhook == "" then return end
    local payload = json.encode({
        content = string.format(fmt, ...),
        username = "Change World",
    })
    PerformHttpRequest(CWConfig.Webhook, function() end, 'POST', payload, { ['Content-Type'] = 'application/json' })
end

local function GetIdentifier(source)
    for _, id in ipairs(GetPlayerIdentifiers(source)) do
        if id:sub(1, 6) == 'steam:' then return id end
    end
    return nil
end

local function IsAdmin(source)
    local xPlayer = ESX.GetPlayerFromId(source)
    return xPlayer ~= nil and CWConfig.AdminGroups[xPlayer.group] == true
end

local function GetWorldConfig(world)
    return CWConfig.Worlds[world]
end

-- Is `bucket` a world managed by this resource?
local function IsManagedWorld(bucket)
    return CWConfig.Worlds[bucket] ~= nil
end

-- Exported so OTHER resources (lc-inventory, etc.) can check whether a
-- player is currently inside a managed Change World, and refuse actions
-- that would let items/weapons leak out of it (trunk, stash, loot,
-- property, give-item, etc.). See the lc-inventory patch that goes with
-- this file.
exports('IsInChangeWorld', function(source)
    return IsManagedWorld(GetPlayerRoutingBucket(source))
end)

-- ---- Cooldown between /cw and /bw actions (does NOT apply to admin commands) ----

local lastActionAt = {} -- [source] = GetGameTimer() ms

-- Returns true and blocks (with a notify) if `source` is still on cooldown.
-- Otherwise starts a fresh cooldown and returns false.
local function OnCooldown(source)
    local last = lastActionAt[source]
    if last then
        local remaining = CWConfig.ActionCooldown - ((GetGameTimer() - last) / 1000)
        if remaining > 0 then
            Notify(source, ("Sabr Konid! %s Sanie Dige Talash Konid."):format(math.ceil(remaining)))
            return true
        end
    end
    lastActionAt[source] = GetGameTimer()
    return false
end

-- Refreshes the cooldown without checking it (used on the "bring/pull a
-- gang-mate" side, since they didn't type the command themselves)
local function TouchCooldown(source)
    lastActionAt[source] = GetGameTimer()
end

-- Find the world id whose label matches a gang name (case-insensitive)
local function FindGangWorld(gangName)
    if not gangName or gangName == 'nogang' then return nil end
    for world, cfg in pairs(CWConfig.Worlds) do
        if cfg.mode == "gang" and cfg.label:lower() == gangName:lower() then
            return world
        end
    end
    return nil
end

-- Find a "group" world this Steam identifier is whitelisted for
local function FindGroupWorld(identifier)
    if not identifier then return nil end
    for world, cfg in pairs(CWConfig.Worlds) do
        if cfg.mode == "group" and cfg.identifiers[identifier] then
            return world
        end
    end
    return nil
end

-- gangs_data.boss is a JSON array of ped definitions, e.g.:
-- [{"coord":{"x":..,"y":..,"z":..}, "type":"ped", ...}, {...}]
-- We use the first ped's coord as "the" boss action point.
function GetGangBoss(gangName, cb)
    MySQL.Async.fetchAll('SELECT boss FROM gangs_data WHERE gang_name = @gangName LIMIT 1', {
        ['@gangName'] = gangName
    }, function(results)
        if not results or #results == 0 or not results[1].boss then
            cb(nil)
            return
        end
        local ok, list = pcall(json.decode, results[1].boss)
        if not ok or type(list) ~= 'table' or not list[1] or not list[1].coord then
            cb(nil)
            return
        end
        cb(list[1].coord)
    end)
end

-- Runs cb(true/false, bossCoords) depending on whether `source` is within
-- CWConfig.EntryRadius of their own gang's Boss Action point
local function IsNearOwnGangBoss(source, cb)
    local xPlayer = ESX.GetPlayerFromId(source)
    if not xPlayer or xPlayer.gang.name == 'nogang' then
        cb(false)
        return
    end

    GetGangBoss(xPlayer.gang.name, function(bossCoords)
        if not bossCoords or not bossCoords.x then
            cb(false)
            return
        end
        local ped = GetPlayerPed(source)
        local playerCoords = GetEntityCoords(ped)
        local dist = #(playerCoords - vector3(bossCoords.x, bossCoords.y, bossCoords.z))
        cb(dist <= CWConfig.EntryRadius, bossCoords)
    end)
end

-- Is `source` within CWConfig.EntryRadius of the fixed group-world entry point?
local function IsNearEntryPoint(source)
    local ped = GetPlayerPed(source)
    local coords = GetEntityCoords(ped)
    return #(coords - CWConfig.ReturnPoint) <= CWConfig.EntryRadius
end

-- ============================================================
-- INVENTORY SAVE / LOAD (KVP-backed, per steam identifier)
-- ============================================================

local function KvpKey(identifier)
    return ('cw_inv:%s'):format(identifier)
end

-- Removes EVERYTHING the player is currently carrying (items + weapons),
-- regardless of how they got it. This is the real safety net: it doesn't
-- matter which of the 39+ other scripts on this server (jobs, drug labs,
-- chopshop, shops, admin menus, etc.) handed them something while they
-- were inside a Change World - none of it survives the exit boundary.
local function StripInv(xPlayer)
    local items = {}
    for _, item in ipairs(xPlayer.inventory) do
        if item.count > 0 then
            table.insert(items, { name = item.name, count = item.count })
        end
    end
    for _, item in ipairs(items) do
        xPlayer.removeInventoryItem(item.name, item.count)
    end

    local weapons = {}
    for _, weapon in ipairs(xPlayer.loadout) do
        table.insert(weapons, weapon.name)
    end
    for _, weaponName in ipairs(weapons) do
        xPlayer.removeWeapon(weaponName)
    end
end

function SaveInv(source)
    local identifier = GetIdentifier(source)
    local xPlayer = ESX.GetPlayerFromId(source)
    if not identifier or not xPlayer then return end

    local items, weapons = {}, {}

    for _, item in ipairs(xPlayer.inventory) do
        if item.count > 0 then
            table.insert(items, { name = item.name, count = item.count })
        end
    end

    for _, weapon in ipairs(xPlayer.loadout) do
        local attachments = {}
        for _, component in pairs(weapon.components) do
            table.insert(attachments, component)
        end
        table.insert(weapons, { name = weapon.name, ammo = weapon.ammo, attachments = attachments })
    end

    SetResourceKvp(KvpKey(identifier), json.encode({ items = items, weapons = weapons }))

    -- Now that the snapshot is safely written to KVP, wipe everything -
    -- this is the moment "entering the world" becomes a clean slate.
    StripInv(xPlayer)
end

-- Wipes whatever the player picked up while inside (from ANY script, not
-- just this resource's own menu), then restores exactly what they walked
-- in with. This is the actual anti-smuggling guarantee, not the individual
-- lc-inventory patches - those just stop the obvious deliberate routes,
-- this stops everything else too.
function LoadInv(source)
    local identifier = GetIdentifier(source)
    local xPlayer = ESX.GetPlayerFromId(source)
    if not identifier or not xPlayer then return end

    StripInv(xPlayer)

    local raw = GetResourceKvpString(KvpKey(identifier))
    if not raw then return end

    local ok, data = pcall(json.decode, raw)
    if not ok or not data then return end

    for _, item in ipairs(data.items or {}) do
        xPlayer.addInventoryItem(item.name, item.count)
    end
    for _, weapon in ipairs(data.weapons or {}) do
        xPlayer.addWeapon(weapon.name, weapon.ammo)
        for _, attachment in ipairs(weapon.attachments) do
            xPlayer.addWeaponComponent(weapon.name, attachment)
        end
    end

    DeleteResourceKvp(KvpKey(identifier))
end

-- ============================================================
-- ADMIN COMMANDS (force override, bypasses gang/group checks)
-- ============================================================

RegisterCommand('getworld', function(source, args)
    if not IsAdmin(source) then
        Notify(source, "Dastresi Nadarid.")
        return
    end
    local targetId = tonumber(args[1])
    if not targetId then
        Notify(source, "ID Vared Konid.")
        return
    end
    Notify(source, ("ID: %s | World: %s"):format(targetId, GetPlayerRoutingBucket(targetId)))
end, false)

RegisterCommand('changeworld', function(source, args)
    if not IsAdmin(source) then
        Notify(source, "Dastresi Nadarid.")
        return
    end
    local targetId, newWorld = tonumber(args[1]), tonumber(args[2])
    if not (targetId and newWorld) then
        Notify(source, "ID Va World Ro Vared Konid.")
        return
    end

    SetPlayerRoutingBucket(targetId, newWorld)
    Notify(targetId, ("World Shoma Be %s Taghir Kard."):format(newWorld))
    TriggerClientEvent(newWorld == 0 and 'cw:enableEKey' or 'cw:disableEKey', targetId)
    if newWorld == 0 then
        TriggerClientEvent('cw:resetWorldState', targetId)
    end

    Log("```\n[CMD]: /changeworld\n[Author]: %s\n[Player]: %s\n[World]: %s```",
        GetPlayerName(source), GetPlayerName(targetId), newWorld)
end, false)

RegisterCommand('backworld', function(source, args)
    if not IsAdmin(source) then
        Notify(source, "Dastresi Nadarid.")
        return
    end
    local targetId = tonumber(args[1]) or source

    SetPlayerRoutingBucket(targetId, 0)
    TriggerClientEvent('cw:resetWorldState', targetId)
    TriggerClientEvent('cw:enableEKey', targetId)
    TriggerClientEvent('cw:teleport', targetId, CWConfig.ReturnPoint.x, CWConfig.ReturnPoint.y, CWConfig.ReturnPoint.z)
    Notify(targetId, "Worlde Shoma Tavasote Admin Be Worlde Asli Change Shod.")

    Log("```\n[CMD]: /backworld\n[Author]: %s\n[Player]: %s```", GetPlayerName(source), GetPlayerName(targetId))
end, false)

-- ============================================================
-- PLAYER COMMANDS
-- ============================================================

-- Enter the calling player's own world (group-whitelist, or gang + boss
-- proximity). Used by both /cw (no args) and the ox_target gate ped.
local function EnterOwnWorld(source, via)
    local xPlayer = ESX.GetPlayerFromId(source)
    if not xPlayer then return end
    local identifier = GetIdentifier(source)

    if GetPlayerRoutingBucket(source) ~= 0 then
        Notify(source, "Shoma Dar World Asli Nistid.")
        return
    end

    if OnCooldown(source) then return end

    -- Group-whitelisted world (e.g. streamer) - just needs proximity to the entry point
    local groupWorld = FindGroupWorld(identifier)
    if groupWorld then
        if not IsNearEntryPoint(source) then
            Notify(source, "Shoma Be Noghteye Vorood Nazdik Nistid!")
            return
        end
        SetPlayerRoutingBucket(source, groupWorld)
        TriggerClientEvent('cw:disableEKey', source)
        Notify(source, ("Shoma Be World %s Raftid."):format(groupWorld))
        Log("```\n[CMD]: %s\n[Author]: %s\n[World]: %s```", via, GetPlayerName(source), groupWorld)
        return
    end

    -- Gang world - needs to be a gang member near their Boss Action point
    if xPlayer.gang.name == 'nogang' then
        Notify(source, "Shoma Dastresi Be In Komand Ra Nadarid.")
        return
    end

    local gangWorld = FindGangWorld(xPlayer.gang.name)
    if not gangWorld then
        Notify(source, "Shoma Dastresi Be In Komand Ra Nadarid.")
        return
    end

    IsNearOwnGangBoss(source, function(isNear)
        if not isNear then
            Notify(source, "Shoma Az Boss Action Gang Fasele Darid!")
            return
        end
        SaveInv(source)
        TriggerClientEvent('cw:disableEKey', source)
        SetPlayerRoutingBucket(source, gangWorld)
        Notify(source, ("Shoma Be World %s Raftid."):format(gangWorld))
        Log("```\n[CMD]: %s\n[Author]: %s\n[World]: %s```", via, GetPlayerName(source), gangWorld)
    end)
end

-- Exit the calling player's current world back to their Boss Action point
-- (gang world) or CWConfig.ReturnPoint (group world). Used by both /bw and
-- the ox_target gate ped.
local function ExitOwnWorld(source, via)
    local xPlayer = ESX.GetPlayerFromId(source)
    if not xPlayer then return end

    local bucket = GetPlayerRoutingBucket(source)
    if not IsManagedWorld(bucket) then
        Notify(source, "Shoma Dar Change World Nistid.")
        return
    end

    if OnCooldown(source) then return end

    local cfg = GetWorldConfig(bucket)
    if cfg.mode == "gang" then
        GetGangBoss(xPlayer.gang.name, function(bossCoords)
            if not bossCoords then
                Notify(source, "Error On Get Boss Coords!")
                return
            end
            TriggerClientEvent('cw:resetWorldState', source)
            TriggerClientEvent('cw:teleport', source, bossCoords.x, bossCoords.y, bossCoords.z)
            LoadInv(source)
            TriggerClientEvent('cw:enableEKey', source)
            SetPlayerRoutingBucket(source, 0)
            Notify(source, "Shoma Be World Asli Bargashtid.")
            Log("```\n[CMD]: %s\n[Author]: %s```", via, GetPlayerName(source))
        end)
    else
        TriggerClientEvent('cw:resetWorldState', source)
        TriggerClientEvent('cw:teleport', source, CWConfig.ReturnPoint.x, CWConfig.ReturnPoint.y, CWConfig.ReturnPoint.z)
        TriggerClientEvent('cw:enableEKey', source)
        SetPlayerRoutingBucket(source, 0)
        Notify(source, "Shoma Be World Asli Bargashtid.")
        Log("```\n[CMD]: %s\n[Author]: %s```", via, GetPlayerName(source))
    end
end

-- /cw            -> enter your world (group-whitelist, or gang + boss-action proximity)
-- /cw [targetId] -> bring a gang-mate into your gang's world (both near the boss action)
RegisterCommand('cw', function(source, args)
    local xPlayer = ESX.GetPlayerFromId(source)
    if not xPlayer then return end

    local targetId = tonumber(args[1])

    -- Bringing a gang-mate in with you
    if targetId and targetId ~= source then
        local zPlayer = ESX.GetPlayerFromId(targetId)
        if not zPlayer then
            Notify(source, "Player Online Nist!")
            return
        end
        if xPlayer.gang.name == 'nogang' then
            Notify(source, "Shoma Dar Gangy Ozv Nistid.")
            return
        end
        if xPlayer.gang.name ~= zPlayer.gang.name then
            Notify(source, "Fard Dar Gang Shoma Nist!")
            return
        end
        if GetPlayerRoutingBucket(targetId) ~= 0 then
            Notify(source, "Fard Dar World Asli Nist.")
            return
        end

        local world = FindGangWorld(xPlayer.gang.name)
        if not world then
            Notify(source, "Gang Shoma World Nadarad.")
            return
        end

        if OnCooldown(source) then return end

        IsNearOwnGangBoss(source, function(sourceNear)
            if not sourceNear then
                Notify(source, "Shoma Az Boss Action Gang Fasele Darid!")
                return
            end
            IsNearOwnGangBoss(targetId, function(targetNear)
                if not targetNear then
                    Notify(source, "Faseleye Fard Az Boss Action Door Ast!")
                    return
                end
                SaveInv(targetId)
                TriggerClientEvent('cw:disableEKey', targetId)
                SetPlayerRoutingBucket(targetId, world)
                TouchCooldown(targetId)
                Notify(source, ("Shoma %s Ro Be World %s Ferestadid."):format(GetPlayerName(targetId), world))
                Notify(targetId, ("Shoma Be World %s Raftid."):format(world))
                Log("```\n[CMD]: /cw\n[Author]: %s\n[Player]: %s\n[World]: %s```",
                    GetPlayerName(source), GetPlayerName(targetId), world)
            end)
        end)
        return
    end

    EnterOwnWorld(source, "/cw")
end, false)

-- /bw            -> leave your current world (back to your Boss Action point, or ReturnPoint for group worlds)
-- /bw [targetId] -> pull a gang-mate out of the gang world back to base
RegisterCommand('bw', function(source, args)
    local xPlayer = ESX.GetPlayerFromId(source)
    if not xPlayer then return end

    local targetId = tonumber(args[1])

    if targetId and targetId ~= source then
        local zPlayer = ESX.GetPlayerFromId(targetId)
        if not zPlayer then
            Notify(source, "Player Online Nist!")
            return
        end
        if not IsManagedWorld(GetPlayerRoutingBucket(targetId)) then
            Notify(source, "Fard Dar Change World Nist.")
            return
        end
        if xPlayer.gang.name ~= zPlayer.gang.name then
            Notify(source, "Fard Dar Gang Shoma Nist!")
            return
        end

        if OnCooldown(source) then return end

        GetGangBoss(xPlayer.gang.name, function(bossCoords)
            if not bossCoords then
                Notify(source, "Error On Get Boss Coords!")
                return
            end
            TriggerClientEvent('cw:teleport', targetId, bossCoords.x, bossCoords.y, bossCoords.z)
            TriggerClientEvent('cw:resetWorldState', targetId)
            LoadInv(targetId)
            TriggerClientEvent('cw:enableEKey', targetId)
            SetPlayerRoutingBucket(targetId, 0)
            TouchCooldown(targetId)
            Notify(targetId, "Shoma Be World Asli Bargashtid.")
            Notify(source, ("%s Be World Asli Bargasht."):format(GetPlayerName(targetId)))
            Log("```\n[CMD]: /bw\n[Author]: %s\n[Player]: %s```", GetPlayerName(source), GetPlayerName(targetId))
        end)
        return
    end

    ExitOwnWorld(source, "/bw")
end, false)

-- ============================================================
-- OX_TARGET GATE PED (alternative to typing /cw and /bw)
-- ============================================================

-- Tells the client where (if anywhere) to spawn a "gate" ped for this
-- player's own world: gang worlds spawn it at the Boss Action point,
-- group worlds spawn it at CWConfig.ReturnPoint.
-- (Registered inside the ESX-ready thread below, alongside cw:menuAccess.)

RegisterServerEvent('cw:targetEnter')
AddEventHandler('cw:targetEnter', function()
    EnterOwnWorld(source, "ox_target")
end)

RegisterServerEvent('cw:targetExit')
AddEventHandler('cw:targetExit', function()
    ExitOwnWorld(source, "ox_target")
end)

-- ============================================================
-- IN-WORLD MENU (F11 on the client)
-- ============================================================

CreateThread(function()
    while ESX == nil do
        TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
        Wait(0)
    end

    -- Anything that needs ESX at registration time (not just when a
    -- command/event fires later) must go here, after ESX is confirmed ready.
    ESX.RegisterServerCallback('cw:menuAccess', function(source, cb)
        cb(IsManagedWorld(GetPlayerRoutingBucket(source)))
    end)

    ESX.RegisterServerCallback('cw:getGateInfo', function(source, cb)
        local xPlayer = ESX.GetPlayerFromId(source)
        if not xPlayer then cb(nil) return end

        local identifier = GetIdentifier(source)
        local groupWorld = FindGroupWorld(identifier)
        if groupWorld then
            cb({ world = groupWorld, coords = CWConfig.ReturnPoint })
            return
        end

        if xPlayer.gang.name == 'nogang' then cb(nil) return end
        local gangWorld = FindGangWorld(xPlayer.gang.name)
        if not gangWorld then cb(nil) return end

        GetGangBoss(xPlayer.gang.name, function(bossCoords)
            if not bossCoords then cb(nil) return end
            cb({ world = gangWorld, coords = vector3(bossCoords.x, bossCoords.y, bossCoords.z) })
        end)
    end)

    ESX.RegisterServerCallback('cw:adminListPlayers', function(source, cb)
        if not IsAdmin(source) then
            cb(nil)
            return
        end
        local list = {}
        for _, playerId in ipairs(GetPlayers()) do
            playerId = tonumber(playerId)
            local bucket = GetPlayerRoutingBucket(playerId)
            if IsManagedWorld(bucket) then
                table.insert(list, {
                    id = playerId,
                    name = GetPlayerName(playerId),
                    world = bucket,
                    label = CWConfig.Worlds[bucket].label,
                })
            end
        end
        cb(list)
    end)
end)

RegisterServerEvent('cw:spawnVehicle')
AddEventHandler('cw:spawnVehicle', function(vehicleName)
    if not IsManagedWorld(GetPlayerRoutingBucket(source)) then return end
    TriggerClientEvent('cw:doSpawnVehicle', source, vehicleName)
end)

RegisterServerEvent('cw:deleteVehicle')
AddEventHandler('cw:deleteVehicle', function()
    if not IsManagedWorld(GetPlayerRoutingBucket(source)) then return end
    TriggerClientEvent('cw:doDeleteVehicle', source)
end)

RegisterServerEvent('cw:revive')
AddEventHandler('cw:revive', function()
    local src = source
    if not IsManagedWorld(GetPlayerRoutingBucket(src)) then return end
    TriggerClientEvent('esx_ambulancejob:revive', src)
    Notify(src, "Shoma Revive Shodid!")
end)

RegisterServerEvent('cw:armor')
AddEventHandler('cw:armor', function()
    if not IsManagedWorld(GetPlayerRoutingBucket(source)) then return end
    TriggerClientEvent('cw:setArmor', source, 100)
end)

RegisterServerEvent('cw:maxAmmo')
AddEventHandler('cw:maxAmmo', function()
    if not IsManagedWorld(GetPlayerRoutingBucket(source)) then return end
    TriggerClientEvent('cw:setMaxAmmo', source, 250)
end)

RegisterServerEvent('cw:tpWaypoint')
AddEventHandler('cw:tpWaypoint', function()
    if not IsManagedWorld(GetPlayerRoutingBucket(source)) then return end
    TriggerClientEvent('cw:doTpWaypoint', source)
end)

-- ---- Self: extra options ----

RegisterServerEvent('cw:heal')
AddEventHandler('cw:heal', function()
    if not IsManagedWorld(GetPlayerRoutingBucket(source)) then return end
    TriggerClientEvent('cw:doHeal', source)
    Notify(source, "Salamat Shoma Por Shod!")
end)

RegisterServerEvent('cw:refillNeeds')
AddEventHandler('cw:refillNeeds', function()
    if not IsManagedWorld(GetPlayerRoutingBucket(source)) then return end
    TriggerClientEvent('esx_status:add', source, 'hunger', 1000000)
    TriggerClientEvent('esx_status:add', source, 'thirst', 1000000)
    Notify(source, "Gorosnegi Va Teshnegi Por Shod!")
end)

local invisiblePlayers = {}
RegisterServerEvent('cw:toggleInvisible')
AddEventHandler('cw:toggleInvisible', function()
    if not IsManagedWorld(GetPlayerRoutingBucket(source)) then return end
    invisiblePlayers[source] = not invisiblePlayers[source]
    TriggerClientEvent('cw:setInvisible', source, invisiblePlayers[source])
    Notify(source, invisiblePlayers[source] and "Invisible: ON" or "Invisible: OFF")
end)

local godModePlayers = {}
RegisterServerEvent('cw:toggleGodMode')
AddEventHandler('cw:toggleGodMode', function()
    if not IsManagedWorld(GetPlayerRoutingBucket(source)) then return end
    godModePlayers[source] = not godModePlayers[source]
    TriggerClientEvent('cw:setGodMode', source, godModePlayers[source])
    Notify(source, godModePlayers[source] and "God Mode: ON" or "God Mode: OFF")
end)

-- ---- Vehicle: extra options ----

RegisterServerEvent('cw:repairVehicle')
AddEventHandler('cw:repairVehicle', function()
    if not IsManagedWorld(GetPlayerRoutingBucket(source)) then return end
    TriggerClientEvent('cw:doRepairVehicle', source)
end)

RegisterServerEvent('cw:flipVehicle')
AddEventHandler('cw:flipVehicle', function()
    if not IsManagedWorld(GetPlayerRoutingBucket(source)) then return end
    TriggerClientEvent('cw:doFlipVehicle', source)
end)

local vehGodModePlayers = {}
RegisterServerEvent('cw:toggleVehGodMode')
AddEventHandler('cw:toggleVehGodMode', function()
    if not IsManagedWorld(GetPlayerRoutingBucket(source)) then return end
    vehGodModePlayers[source] = not vehGodModePlayers[source]
    TriggerClientEvent('cw:setVehGodMode', source, vehGodModePlayers[source])
    Notify(source, vehGodModePlayers[source] and "Vehicle God Mode: ON" or "Vehicle God Mode: OFF")
end)

-- ---- Self: NoClip, weapons, appearance ----

local noclipPlayers = {}
RegisterServerEvent('cw:toggleNoclip')
AddEventHandler('cw:toggleNoclip', function()
    if not IsManagedWorld(GetPlayerRoutingBucket(source)) then return end
    noclipPlayers[source] = not noclipPlayers[source]
    TriggerClientEvent('cw:setNoclip', source, noclipPlayers[source])
    Notify(source, noclipPlayers[source] and "NoClip: ON" or "NoClip: OFF")
end)

-- Whitelisted weapon names the in-world menu is allowed to spawn - keeps
-- this from ever being turned into "give me any hash the client sends"
CWConfig.MenuWeapons = {
    "WEAPON_PISTOL", "WEAPON_PISTOL50", "WEAPON_COMBATPISTOL", "WEAPON_APPISTOL",
    "WEAPON_MICROSMG", "WEAPON_SMG", "WEAPON_ASSAULTSMG",
    "WEAPON_ASSAULTRIFLE", "WEAPON_CARBINERIFLE", "WEAPON_BULLPUPRIFLE",
    "WEAPON_PUMPSHOTGUN", "WEAPON_SAWNOFFSHOTGUN",
    "WEAPON_SNIPERRIFLE", "WEAPON_HEAVYSNIPER",
    "WEAPON_KNIFE", "WEAPON_BAT", "WEAPON_NIGHTSTICK",
    "WEAPON_GRENADE", "WEAPON_STICKYBOMB", "WEAPON_SMOKEGRENADE",
}
local menuWeaponSet = {}
for _, w in ipairs(CWConfig.MenuWeapons) do menuWeaponSet[w] = true end

RegisterServerEvent('cw:giveWeapon')
AddEventHandler('cw:giveWeapon', function(weaponName)
    if not IsManagedWorld(GetPlayerRoutingBucket(source)) then return end
    if not menuWeaponSet[weaponName] then return end
    TriggerClientEvent('cw:doGiveWeapon', source, weaponName)
end)

-- Whitelisted cosmetic ped models the appearance menu is allowed to set
CWConfig.MenuAppearances = {
    { label = "SWAT",           model = "s_m_y_swat_01" },
    { label = "Police Officer", model = "s_m_y_cop_01" },
    { label = "FIB Agent",      model = "csb_agent" },
    { label = "Firefighter",    model = "s_m_y_fireman_01" },
    { label = "Paramedic",      model = "s_m_m_paramedic_01" },
    { label = "Pilot",          model = "s_m_y_pilot_01" },
    { label = "Business Man",   model = "a_m_y_business_01" },
    { label = "Business Woman", model = "a_f_y_business_02" },
    { label = "Farmer",         model = "a_m_m_farmer_01" },
}
local menuAppearanceSet = {}
for _, a in ipairs(CWConfig.MenuAppearances) do menuAppearanceSet[a.model] = true end

RegisterServerEvent('cw:setAppearance')
AddEventHandler('cw:setAppearance', function(model)
    if not IsManagedWorld(GetPlayerRoutingBucket(source)) then return end
    if not menuAppearanceSet[model] then return end
    TriggerClientEvent('cw:doSetAppearance', source, model)
end)

-- ---- World: time & weather ----

RegisterServerEvent('cw:setWeather')
AddEventHandler('cw:setWeather', function(weatherName)
    if not IsManagedWorld(GetPlayerRoutingBucket(source)) then return end
    TriggerClientEvent('cw:doSetWeather', source, weatherName)
end)

RegisterServerEvent('cw:setTime')
AddEventHandler('cw:setTime', function(hour)
    if not IsManagedWorld(GetPlayerRoutingBucket(source)) then return end
    hour = tonumber(hour)
    if not hour or hour < 0 or hour > 23 then return end
    TriggerClientEvent('cw:doSetTime', source, hour)
end)

local frozenTimePlayers = {}
RegisterServerEvent('cw:toggleFreezeTime')
AddEventHandler('cw:toggleFreezeTime', function()
    if not IsManagedWorld(GetPlayerRoutingBucket(source)) then return end
    frozenTimePlayers[source] = not frozenTimePlayers[source]
    TriggerClientEvent('cw:setFreezeTime', source, frozenTimePlayers[source])
    Notify(source, frozenTimePlayers[source] and "Freeze Time: ON" or "Freeze Time: OFF")
end)

-- ---- Teleport: save / recall a personal position (per-world, in-memory) ----

local savedPositions = {}
RegisterServerEvent('cw:savePos')
AddEventHandler('cw:savePos', function()
    if not IsManagedWorld(GetPlayerRoutingBucket(source)) then return end
    local coords = GetEntityCoords(GetPlayerPed(source))
    savedPositions[source] = coords
    Notify(source, "Mokan Shoma Save Shod!")
end)

RegisterServerEvent('cw:tpSavedPos')
AddEventHandler('cw:tpSavedPos', function()
    if not IsManagedWorld(GetPlayerRoutingBucket(source)) then return end
    local coords = savedPositions[source]
    if not coords then
        Notify(source, "Hich Mokani Save Nashode!")
        return
    end
    TriggerClientEvent('cw:teleport', source, coords.x, coords.y, coords.z)
end)

-- ============================================================
-- ADMIN PANEL: list who is in which world, with Goto/Return (F9 on client)
-- ============================================================

-- Where an admin was, and which bucket, before using Goto (so we can send
-- them back exactly where they came from)
local adminGotoState = {}

RegisterServerEvent('cw:requestAdminPanel')
AddEventHandler('cw:requestAdminPanel', function()
    if not IsAdmin(source) then
        Notify(source, "Dastresi Nadarid.")
        return
    end
    TriggerClientEvent('cw:openAdminPanel', source)
end)

RegisterServerEvent('cw:adminGoto')
AddEventHandler('cw:adminGoto', function(targetId)
    local source = source
    if not IsAdmin(source) then return end
    targetId = tonumber(targetId)
    if not targetId or not GetPlayerName(targetId) then
        Notify(source, "Player Online Nist!")
        return
    end

    local targetBucket = GetPlayerRoutingBucket(targetId)
    if not IsManagedWorld(targetBucket) then
        Notify(source, "In Fard Dige Dar Change World Nist.")
        return
    end

    -- Remember where the admin was, so /cwadmin -> Return can send them back
    if not adminGotoState[source] then
        adminGotoState[source] = {
            bucket = GetPlayerRoutingBucket(source),
            coords = GetEntityCoords(GetPlayerPed(source)),
        }
    end

    local targetCoords = GetEntityCoords(GetPlayerPed(targetId))
    SetPlayerRoutingBucket(source, targetBucket)
    TriggerClientEvent('cw:teleport', source, targetCoords.x, targetCoords.y, targetCoords.z)
    Notify(source, ("Be %s (World %s) Goto Shodid."):format(GetPlayerName(targetId), targetBucket))
end)

RegisterServerEvent('cw:adminReturn')
AddEventHandler('cw:adminReturn', function()
    local source = source
    if not IsAdmin(source) then return end

    local state = adminGotoState[source]
    if not state then
        Notify(source, "Chizi Baraye Bargasht Nist.")
        return
    end

    SetPlayerRoutingBucket(source, state.bucket)
    TriggerClientEvent('cw:teleport', source, state.coords.x, state.coords.y, state.coords.z)
    adminGotoState[source] = nil
    Notify(source, "Be Mokane Ghabli Bargashtid.")
end)

-- ============================================================
-- SAFETY NET: never let a player lose items if they disconnect mid-world
-- ============================================================

AddEventHandler('playerDropped', function()
    if IsManagedWorld(GetPlayerRoutingBucket(source)) then
        LoadInv(source)
    end
    invisiblePlayers[source] = nil
    godModePlayers[source] = nil
    vehGodModePlayers[source] = nil
    noclipPlayers[source] = nil
    frozenTimePlayers[source] = nil
    savedPositions[source] = nil
    lastActionAt[source] = nil
    adminGotoState[source] = nil
end)