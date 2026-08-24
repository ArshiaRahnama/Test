-- ================================================================= --
-- XP / Level system (was XP_Level_System)
-- ================================================================= --
-- COMPATIBILITY FIX (important): the original pack assumed ESX player
-- objects already have .xp / .rank fields and :setXP() / :setRank()
-- methods. This server's essentialmode/server/classes/player.lua has
-- NONE of those — every xPlayer.rank / xPlayer.setXP(...) call would
-- have thrown "attempt to index/call a nil value" the first time it
-- ran. Rather than patch essentialmode's core player class (risky —
-- other resources could depend on its current shape), this file tracks
-- xp/rank itself with direct SQL reads/writes, exactly the same
-- pattern CoinSystem already uses successfully for coin/timercoin on
-- this server. A small in-memory cache avoids hitting the DB on every
-- read.
--
-- SECURITY FIX: 'XP_System:AddXP' / 'RemoveXP' used RegisterServerEvent
-- with NO permission check inside the handler at all — the only gate
-- was the /addxp /removexp chat command (via es:addAdminCommand), a
-- SEPARATE code path from the raw network event. Any player could call
-- TriggerServerEvent('XP_System:AddXP', myId, 999999999) directly and
-- max out their own level instantly. Both handlers now re-check
-- permission_level on the server before doing anything.
--
-- GrantXP(...) is the safe internal entry point other files in THIS
-- resource (quest.lua) use to award XP for completing a quest — it's a
-- plain Lua function, never exposed to the network, so it can't be
-- spoofed and needs no permission check of its own.
-- ================================================================= --

local PlayerXP   = {} -- [source] = number, cached
local PlayerRank = {} -- [source] = number, cached

local function clearCache(source)
    PlayerXP[source] = nil
    PlayerRank[source] = nil
end

-- Always returns via callback(xp, rank). Uses the cache if we already
-- know it for this session; otherwise reads once from `users` and caches.
local function getXPRank(playerId, cb)
    if PlayerXP[playerId] and PlayerRank[playerId] then
        cb(PlayerXP[playerId], PlayerRank[playerId])
        return
    end

    local xPlayer = ESX.GetPlayerFromId(playerId)
    if not xPlayer then cb(nil, nil) return end

    MySQL.Async.fetchAll('SELECT xp, rank FROM users WHERE identifier = @identifier', {
        ['@identifier'] = xPlayer.identifier
    }, function(result)
        local xp   = (result[1] and tonumber(result[1].xp)) or 0
        local rank = (result[1] and tonumber(result[1].rank)) or 1
        if rank < 1 then rank = 1 end
        PlayerXP[playerId] = xp
        PlayerRank[playerId] = rank
        cb(xp, rank)
    end)
end

local function saveXPRank(playerId, xp, rank)
    local xPlayer = ESX.GetPlayerFromId(playerId)
    if not xPlayer then return end
    PlayerXP[playerId] = xp
    PlayerRank[playerId] = rank
    MySQL.Async.execute('UPDATE users SET xp = @xp, rank = @rank WHERE identifier = @identifier', {
        ['@identifier'] = xPlayer.identifier,
        ['@xp']         = xp,
        ['@rank']       = rank,
    })
    TriggerClientEvent('XP_System:SetDecor', playerId, rank)
end

function GrantXP(playerId, xp, notifySource)
    playerId = tonumber(playerId)
    xp = tonumber(xp)
    if not playerId or not xp or xp <= 0 then return end

    getXPRank(playerId, function(curXP, curRank)
        if not curXP then
            if notifySource then
                TriggerClientEvent('esx:showNotification', notifySource, "Playere Morede Nazar Online Nist", "error")
            end
            return
        end

        local rankadded = 0
        local sumxp = curXP + xp
        while config.Levels[curRank + rankadded] and sumxp >= config.Levels[curRank + rankadded] do
            sumxp = sumxp - config.Levels[curRank + rankadded]
            rankadded = rankadded + 1
            if not config.Levels[curRank + rankadded] then
                rankadded = 101
                sumxp = 0
                break
            end
        end

        local newrank = curRank + rankadded
        if newrank >= 100 then
            sumxp = 0
            newrank = 100
        end

        saveXPRank(playerId, sumxp, newrank)

        if notifySource then
            local xPlayer = ESX.GetPlayerFromId(playerId)
            local name = xPlayer and xPlayer.name or ("id " .. playerId)
            TriggerClientEvent('chat:addMessage', notifySource, { args = { '^4XP/Level ^0Jadide ^3' .. name .. " :" } })
            TriggerClientEvent('chat:addMessage', notifySource, { args = { '^1XP : ^0' .. sumxp .. ' | ^1Level : ^0' .. newrank } })
        end
    end)
end

function RevokeXP(playerId, xp, notifySource)
    playerId = tonumber(playerId)
    xp = tonumber(xp)
    if not playerId or not xp or xp <= 0 then return end

    getXPRank(playerId, function(curXP, curRank)
        if not curXP then
            if notifySource then
                TriggerClientEvent('esx:showNotification', notifySource, "Playere Morede Nazar Online Nist", "error")
            end
            return
        end

        local rankremoved = 0
        local sumxp = curXP - xp
        while sumxp < 0 do
            if not config.Levels[(curRank - rankremoved) - 1] then
                sumxp = 0
                rankremoved = curRank
                break
            end
            sumxp = sumxp + config.Levels[(curRank - rankremoved) - 1]
            rankremoved = rankremoved + 1
        end

        local newrank = curRank - rankremoved
        if newrank < 1 then
            sumxp = 0
            newrank = 1
        end

        saveXPRank(playerId, sumxp, newrank)

        if notifySource then
            local xPlayer = ESX.GetPlayerFromId(playerId)
            local name = xPlayer and xPlayer.name or ("id " .. playerId)
            TriggerClientEvent('chat:addMessage', notifySource, { args = { '^4XP/Level ^0Jadide ^3' .. name .. " :" } })
            TriggerClientEvent('chat:addMessage', notifySource, { args = { '^1XP : ^0' .. sumxp .. ' | ^1Level : ^0' .. newrank } })
        end
    end)
end

RegisterCommand('myxp', function(source)
    getXPRank(source, function(xp, rank)
        if not xp then return end
        TriggerClientEvent('chat:addMessage', source, { args = { '^1[ System ] : ', 'XP : ' .. xp .. " Level : " .. rank } })
    end)
end, false)

TriggerEvent('es:addAdminCommand', 'addxp', config.AdminXPPermission, function(source, args)
    GrantXP(tonumber(args[1]), args[2], source)
end, function(source)
    TriggerClientEvent('chat:addMessage', source, { args = { '^1SYSTEM', 'Insufficient Permissions.' } })
end, { help = "Add Xp To Player", params = { { name = "ID", help = "ID Player" }, { name = "Amount", help = "Meghdare XP" } } })

TriggerEvent('es:addAdminCommand', 'removexp', config.AdminXPPermission, function(source, args)
    RevokeXP(tonumber(args[1]), args[2], source)
end, function(source)
    TriggerClientEvent('chat:addMessage', source, { args = { '^1SYSTEM', 'Insufficient Permissions.' } })
end, { help = "Remove Xp From Player", params = { { name = "ID", help = "ID Player" }, { name = "Amount", help = "Meghdare XP" } } })

-- Kept as network events ONLY for backward compatibility with anything
-- that still calls them directly — now permission-checked server-side
-- so they can't be exploited even without going through the commands.
RegisterServerEvent('XP_System:AddXP')
AddEventHandler('XP_System:AddXP', function(playerId, xp)
    local _source = source
    local caller = ESX.GetPlayerFromId(_source)
    if not caller or not caller.permission_level or caller.permission_level < config.AdminXPPermission then
        return
    end
    GrantXP(tonumber(playerId), xp, _source)
end)

RegisterServerEvent('XP_System:RemoveXP')
AddEventHandler('XP_System:RemoveXP', function(playerId, xp)
    local _source = source
    local caller = ESX.GetPlayerFromId(_source)
    if not caller or not caller.permission_level or caller.permission_level < config.AdminXPPermission then
        return
    end
    RevokeXP(tonumber(playerId), xp, _source)
end)

-- Used on spawn (client/xp.lua in THIS resource) to fetch your OWN rank
-- and push it back down so idoverhead can set your decor.
RegisterServerEvent("XP_System:setMyDecor")
AddEventHandler("XP_System:setMyDecor", function()
    local src = source
    getXPRank(src, function(xp, rank)
        if rank then
            TriggerClientEvent('XP_System:SetDecor', src, rank)
        end
    end)
end)

-- Used by idoverhead (own resource) to fetch ANOTHER player's rank, to
-- show above their head. Read-only, no permission check needed — it's
-- just their current level, the same thing everyone can already see
-- rendered in-world.
ESX.RegisterServerCallback('XP_System:getRank', function(_source, cb, targetId)
    getXPRank(tonumber(targetId), function(_, rank)
        cb(rank or -1)
    end)
end)

-- Exposes xp/rank to other files in this resource (menu.lua) without a
-- second, separate SQL round trip.
function GetXPRankCached(playerId, cb)
    getXPRank(playerId, cb)
end

AddEventHandler('playerDropped', function()
    clearCache(source)
end)
