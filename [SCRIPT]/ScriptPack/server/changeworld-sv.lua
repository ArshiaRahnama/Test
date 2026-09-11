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
    [100] = { label = "1",   mode = "gang" },
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

-- Fetch a gang's Boss Action coordinates from gangs_data (same table the
-- Unique_ALLGangs boss menu uses)
function GetGangBoss(gangName, cb)
    MySQL.Async.fetchAll('SELECT boss FROM gangs_data WHERE gang_name = @gangName LIMIT 1', {
        ['@gangName'] = gangName
    }, function(results)
        if not results or #results == 0 then
            cb(nil)
            return
        end
        local ok, coords = pcall(json.decode, results[1].boss)
        cb(ok and coords or nil)
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

function SaveInv(source)
    local identifier = GetIdentifier(source)
    local xPlayer = ESX.GetPlayerFromId(source)
    if not identifier or not xPlayer then return end

    local items, weapons = {}, {}

    for _, item in ipairs(xPlayer.inventory) do
        if item.count > 0 then
            table.insert(items, { name = item.name, count = item.count })
            xPlayer.removeInventoryItem(item.name, item.count)
        end
    end

    for _, weapon in ipairs(xPlayer.loadout) do
        local attachments = {}
        for _, component in pairs(weapon.components) do
            table.insert(attachments, component)
        end
        table.insert(weapons, { name = weapon.name, ammo = weapon.ammo, attachments = attachments })
        xPlayer.removeWeapon(weapon.name)
    end

    SetResourceKvp(KvpKey(identifier), json.encode({ items = items, weapons = weapons }))
end

function LoadInv(source)
    local identifier = GetIdentifier(source)
    local xPlayer = ESX.GetPlayerFromId(source)
    if not identifier or not xPlayer then return end

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
    TriggerClientEvent('cw:enableEKey', targetId)
    TriggerClientEvent('cw:teleport', targetId, CWConfig.ReturnPoint.x, CWConfig.ReturnPoint.y, CWConfig.ReturnPoint.z)
    Notify(targetId, "Worlde Shoma Tavasote Admin Be Worlde Asli Change Shod.")

    Log("```\n[CMD]: /backworld\n[Author]: %s\n[Player]: %s```", GetPlayerName(source), GetPlayerName(targetId))
end, false)

-- ============================================================
-- PLAYER COMMANDS
-- ============================================================

-- /cw            -> enter your world (group-whitelist, or gang + boss-action proximity)
-- /cw [targetId] -> bring a gang-mate into your gang's world (both near the boss action)
RegisterCommand('cw', function(source, args)
    local xPlayer = ESX.GetPlayerFromId(source)
    if not xPlayer then return end
    local identifier = GetIdentifier(source)

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
                Notify(source, ("Shoma %s Ro Be World %s Ferestadid."):format(GetPlayerName(targetId), world))
                Notify(targetId, ("Shoma Be World %s Raftid."):format(world))
                Log("```\n[CMD]: /cw\n[Author]: %s\n[Player]: %s\n[World]: %s```",
                    GetPlayerName(source), GetPlayerName(targetId), world)
            end)
        end)
        return
    end

    -- Entering your own world
    if GetPlayerRoutingBucket(source) ~= 0 then
        Notify(source, "Shoma Dar World Asli Nistid.")
        return
    end

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
        Log("```\n[CMD]: /cw\n[Author]: %s\n[World]: %s```", GetPlayerName(source), groupWorld)
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
        Log("```\n[CMD]: /cw\n[Author]: %s\n[World]: %s```", GetPlayerName(source), gangWorld)
    end)
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

        GetGangBoss(xPlayer.gang.name, function(bossCoords)
            if not bossCoords then
                Notify(source, "Error On Get Boss Coords!")
                return
            end
            TriggerClientEvent('cw:teleport', targetId, bossCoords.x, bossCoords.y, bossCoords.z)
            LoadInv(targetId)
            TriggerClientEvent('cw:enableEKey', targetId)
            SetPlayerRoutingBucket(targetId, 0)
            Notify(targetId, "Shoma Be World Asli Bargashtid.")
            Notify(source, ("%s Be World Asli Bargasht."):format(GetPlayerName(targetId)))
            Log("```\n[CMD]: /bw\n[Author]: %s\n[Player]: %s```", GetPlayerName(source), GetPlayerName(targetId))
        end)
        return
    end

    local bucket = GetPlayerRoutingBucket(source)
    if not IsManagedWorld(bucket) then
        Notify(source, "Shoma Dar Change World Nistid.")
        return
    end

    local cfg = GetWorldConfig(bucket)
    if cfg.mode == "gang" then
        GetGangBoss(xPlayer.gang.name, function(bossCoords)
            if not bossCoords then
                Notify(source, "Error On Get Boss Coords!")
                return
            end
            TriggerClientEvent('cw:teleport', source, bossCoords.x, bossCoords.y, bossCoords.z)
            LoadInv(source)
            TriggerClientEvent('cw:enableEKey', source)
            SetPlayerRoutingBucket(source, 0)
            Notify(source, "Shoma Be World Asli Bargashtid.")
            Log("```\n[CMD]: /bw\n[Author]: %s```", GetPlayerName(source))
        end)
    else
        TriggerClientEvent('cw:teleport', source, CWConfig.ReturnPoint.x, CWConfig.ReturnPoint.y, CWConfig.ReturnPoint.z)
        TriggerClientEvent('cw:enableEKey', source)
        SetPlayerRoutingBucket(source, 0)
        Notify(source, "Shoma Be World Asli Bargashtid.")
        Log("```\n[CMD]: /bw\n[Author]: %s```", GetPlayerName(source))
    end
end, false)

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

-- ============================================================
-- SAFETY NET: never let a player lose items if they disconnect mid-world
-- ============================================================

AddEventHandler('playerDropped', function()
    if IsManagedWorld(GetPlayerRoutingBucket(source)) then
        LoadInv(source)
    end
end)