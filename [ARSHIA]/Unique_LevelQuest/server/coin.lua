-- ================================================================= --
-- Coin system (merged in from the standalone CoinSystem resource)
-- ================================================================= --
-- Same fixed/secure logic that CoinSystem had:
--   - AddCoin/RemoveCoin/SetCoin re-check permission_level SERVER-SIDE
--     (the client-side /setcoin command check is cosmetic only).
--   - AddTimer/ResetCoinTimer use a fixed server-side increment and a
--     cooldown, with only one reward loop ever running per player.
--   - No 'AddCoinCL'-style event exists — nothing lets a client add an
--     arbitrary amount of coin to themselves directly.
--
-- GrantCoin(...) below is a plain global function other files in this
-- resource (quest.lua, skill.lua) call directly — no export/network
-- round-trip needed now that it's all the same resource.
--
-- Event and callback names are kept IDENTICAL to the old CoinSystem
-- ('Coin-System:*') because esx_status/client/main.lua calls
-- ESX.TriggerServerCallback("Coin-System:GetTimerCoin", ...) — that
-- still works unchanged as long as the callback is registered
-- somewhere, regardless of which resource does it.
-- ================================================================= --

local TIMER_INCREMENT     = 5   -- fixed, server-side "timercoin" gained per tick
local TIMER_REWARD_AMOUNT = 1   -- coins granted once timercoin reaches the threshold
local TIMER_THRESHOLD     = 100
local TIMER_TICK_COOLDOWN = 140 -- seconds; client ticks every 150s, small slack allowed

local activeTimerThreads = {} -- [source] = true while a reward loop is running for that player
local lastTimerTick      = {} -- [source] = os.time() of their last accepted AddTimer call
local coinAttempts       = {}

local function isValidCoinAmount(n)
    n = tonumber(n)
    if not n then return false end
    if n ~= n or n == math.huge or n == -math.huge then return false end -- reject NaN / inf
    if n < 0 or n > Config.CoinMaxValue then return false end
    return true
end

local function isCoinAdmin(source)
    local xPlayer = ESX.GetPlayerFromId(source)
    return xPlayer ~= nil and xPlayer.permission_level ~= nil and xPlayer.permission_level >= Config.CoinAdminPermission
end

-- Shared internal implementation used by BOTH the admin-only network event
-- below AND direct calls from other files in this resource (quest.lua,
-- skill.lua). Returns true/false so callers can tell if it worked.
function GrantCoin(targetId, coinAmount)
    if not isValidCoinAmount(coinAmount) then return false end
    targetId = tonumber(targetId)
    local xPlayer = targetId and ESX.GetPlayerFromId(targetId) or nil
    if not xPlayer then return false end

    if not Config.CoinItem then
        MySQL.Async.fetchAll('SELECT coin FROM users WHERE identifier = @identifier', {
            ['@identifier'] = xPlayer.identifier
        }, function(result)
            if result[1] then
                local newCoin = (result[1].coin or 0) + coinAmount
                MySQL.Async.execute('UPDATE users SET coin = @coin WHERE identifier = @identifier', {
                    ['@coin'] = newCoin,
                    ['@identifier'] = xPlayer.identifier,
                })
                TriggerEvent("Coin-System:LoadCoin2", targetId)
            end
        end)
    else
        xPlayer.addInventoryItem("coin", coinAmount, nil, nil, 0)
        local item = xPlayer.getInventoryItem("coin")
        if item then
            TriggerClientEvent("CoinUpdate", xPlayer.source, item.count)
        end
    end
    return true
end

-- Awards a fixed "timercoin" amount for the calling player, at most once
-- every TIMER_TICK_COOLDOWN seconds. Amount and target are both decided
-- server-side; any arguments the client sends are ignored.
RegisterServerEvent('Coin-System:AddTimer')
AddEventHandler('Coin-System:AddTimer', function(_ignoredPlayerId, _ignoredCoin)
    local _source = source

    local now = os.time()
    if lastTimerTick[_source] and (now - lastTimerTick[_source]) < TIMER_TICK_COOLDOWN then
        return -- called faster than the intended client cadence, ignore
    end

    while ESX.GetPlayerFromId(_source) == nil do
        coinAttempts[_source] = (coinAttempts[_source] or 0) + 1
        if coinAttempts[_source] >= 4 then
            coinAttempts[_source] = nil
            return
        end
        Wait(1000)
    end
    coinAttempts[_source] = nil
    lastTimerTick[_source] = now

    local xPlayer = ESX.GetPlayerFromId(_source)

    MySQL.Async.fetchAll('SELECT timercoin FROM users WHERE identifier = @identifier', {
        ['@identifier'] = xPlayer.identifier
    }, function(result)
        if result[1] then
            MySQL.Async.execute('UPDATE users SET timercoin = @timercoin WHERE identifier = @identifier', {
                ['@timercoin'] = (result[1].timercoin or 0) + TIMER_INCREMENT,
                ['@identifier'] = xPlayer.identifier,
            })
            TriggerEvent("Coin-System:LoadCoin2", _source)
        end
    end)
end)

-- Admin-only: directly grant coins to a player over the network.
RegisterServerEvent('Coin-System:AddCoin')
AddEventHandler('Coin-System:AddCoin', function(playerId, coinAmount)
    if not isCoinAdmin(source) then return end
    GrantCoin(playerId, coinAmount)
end)

-- Admin-only: remove coins from a player.
RegisterServerEvent('Coin-System:RemoveCoin')
AddEventHandler('Coin-System:RemoveCoin', function(playerId, coinAmount)
    if not isCoinAdmin(source) then return end
    if not isValidCoinAmount(coinAmount) then return end

    local targetId = tonumber(playerId)
    local xPlayer = targetId and ESX.GetPlayerFromId(targetId) or nil
    if not xPlayer then return end

    if not Config.CoinItem then
        MySQL.Async.fetchAll('SELECT coin FROM users WHERE identifier = @identifier', {
            ['@identifier'] = xPlayer.identifier
        }, function(result)
            if result[1] then
                local newCoin = math.max(0, (result[1].coin or 0) - coinAmount)
                MySQL.Async.execute('UPDATE users SET coin = @coin WHERE identifier = @identifier', {
                    ['@coin'] = newCoin,
                    ['@identifier'] = xPlayer.identifier,
                })
                TriggerEvent("Coin-System:LoadCoin2", xPlayer.source)
            end
        end)
    else
        xPlayer.removeInventoryItem("coin", coinAmount)
        local item = xPlayer.getInventoryItem("coin")
        if item then
            TriggerClientEvent("CoinUpdate", xPlayer.source, item.count)
        end
    end
end)

-- Admin-only: set a player's coin balance to an exact value.
RegisterServerEvent('Coin-System:SetCoin')
AddEventHandler('Coin-System:SetCoin', function(playerId, coinAmount)
    if not isCoinAdmin(source) then return end
    if not isValidCoinAmount(coinAmount) then return end

    local targetId = tonumber(playerId)
    local xPlayer = targetId and ESX.GetPlayerFromId(targetId) or nil
    if not xPlayer then return end

    if not Config.CoinItem then
        MySQL.Async.execute('UPDATE users SET coin = @coin WHERE identifier = @identifier', {
            ['@coin'] = coinAmount,
            ['@identifier'] = xPlayer.identifier,
        })
        TriggerEvent("Coin-System:LoadCoin2", xPlayer.source)
    end
end)

RegisterServerEvent("Coin-System:LoadCoin")
AddEventHandler("Coin-System:LoadCoin", function()
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)
    if not xPlayer then return end
    if not Config.CoinItem then
        MySQL.Async.fetchAll('SELECT coin FROM users WHERE identifier = @identifier', { ['@identifier'] = xPlayer.identifier }, function(result)
            if result and result[1] then
                local coinAmount = tonumber(result[1].coin) or 0
                TriggerClientEvent("Coin-System:PlayerCoin", _source, coinAmount)
            end
        end)
    end
end)

-- Read-only balance checks. `source` (the real caller) is what's used
-- unless an explicit id is passed in for a lookup.
ESX.RegisterServerCallback('Coin-System:GetPlayerCoin', function(source, cb, id)
    local _source = tonumber(id) or source
    local xPlayer = ESX.GetPlayerFromId(_source)
    if not xPlayer then return cb(0) end
    if not Config.CoinItem then
        MySQL.Async.fetchAll('SELECT coin FROM users WHERE identifier = @identifier', { ['@identifier'] = xPlayer.identifier }, function(result)
            cb(result[1] and tonumber(result[1].coin) or 0)
        end)
    else
        local item = xPlayer.getInventoryItem("coin")
        cb(item and item.count or 0)
    end
end)

ESX.RegisterServerCallback('Coin-System:GetCoin', function(source, cb)
    local xPlayer = ESX.GetPlayerFromId(source)
    if not xPlayer then return cb(0) end
    if not Config.CoinItem then
        MySQL.Async.fetchAll('SELECT coin FROM users WHERE identifier = @identifier', { ['@identifier'] = xPlayer.identifier }, function(result)
            cb(result[1] and tonumber(result[1].coin) or 0)
        end)
    else
        local item = xPlayer.getInventoryItem("coin")
        cb(item and item.count or 0)
    end
end)

-- esx_status calls this directly (ESX.TriggerServerCallback("Coin-System:GetTimerCoin", ...))
-- — keep this name exactly as-is.
ESX.RegisterServerCallback('Coin-System:GetTimerCoin', function(source, cb)
    local xPlayer = ESX.GetPlayerFromId(source)
    if not xPlayer then return cb(0) end
    MySQL.Async.fetchAll('SELECT timercoin FROM users WHERE identifier = @identifier', { ['@identifier'] = xPlayer.identifier }, function(result)
        cb(result[1] and tonumber(result[1].timercoin) or 0)
    end)
end)

RegisterServerEvent("Coin-System:LoadCoin2")
AddEventHandler("Coin-System:LoadCoin2", function(src)
    local _source = src or source
    local xPlayer = ESX.GetPlayerFromId(_source)
    if _source and xPlayer then
        MySQL.Async.fetchAll('SELECT coin FROM users WHERE identifier = @identifier', { ['@identifier'] = xPlayer.identifier }, function(result)
            if result[1] and result[1].coin then
                local coinAmount = tonumber(result[1].coin) or 0
                TriggerClientEvent("Coin-System:PlayerCoin", _source, coinAmount)
            end
        end)
    end
end)

Citizen.CreateThread(function()
    while true do
        Wait(5000)
        for _, v in pairs(ESX.GetPlayers()) do
            local xPlayer = ESX.GetPlayerFromId(v)
            if xPlayer and xPlayer.identifier and not Config.CoinItem then
                MySQL.Async.fetchAll('SELECT coin FROM users WHERE identifier = @identifier', { ['@identifier'] = xPlayer.identifier }, function(result)
                    if result and result[1] and result[1].coin then
                        TriggerClientEvent("Coin-System:PlayerCoin", xPlayer.source, tonumber(result[1].coin) or 0)
                    end
                end)
            end
        end
    end
end)

-- Reward loop. Only one instance is ever allowed to run per connected
-- player; the coin is granted directly here, server-side.
RegisterServerEvent("Coin-System:ResetCoinTimer")
AddEventHandler("Coin-System:ResetCoinTimer", function(_ignoredSrc)
    local _source = source
    if activeTimerThreads[_source] then return end -- already running for this player
    if not ESX.GetPlayerFromId(_source) then return end
    activeTimerThreads[_source] = true

    Citizen.CreateThread(function()
        while activeTimerThreads[_source] do
            local xPlayer = ESX.GetPlayerFromId(_source)
            if not xPlayer then
                activeTimerThreads[_source] = nil
                return
            end

            MySQL.Async.fetchAll('SELECT timercoin FROM users WHERE identifier = @identifier', { ['@identifier'] = xPlayer.identifier }, function(result)
                if result[1] and result[1].timercoin and result[1].timercoin >= TIMER_THRESHOLD then
                    MySQL.Async.execute('UPDATE users SET timercoin = @timercoin WHERE identifier = @identifier', {
                        ['@timercoin'] = 0,
                        ['@identifier'] = xPlayer.identifier
                    })
                    GrantCoin(_source, TIMER_REWARD_AMOUNT)
                end
            end)

            Wait(5000)
        end
    end)
end)

AddEventHandler('playerDropped', function()
    local _source = source
    activeTimerThreads[_source] = nil
    lastTimerTick[_source] = nil
    coinAttempts[_source] = nil
end)
