-- ============================================================================
-- sun-inventory-hud | client/00_compat.lua
-- Glue between the original "Sunset" client and Unique RP's essentialmode.
-- Loads FIRST. Builds ESX (essentialmode has no getObject export) and adds the
-- helpers the Sunset client calls but essentialmode does not have.
-- ============================================================================

local function loadESX()
    TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
end
loadESX()
CreateThread(function()
    while ESX == nil do
        Wait(200)
        loadESX()
    end
end)

-- The shared ESX object is a copy: functions still call into essentialmode,
-- but tables we add below live only in this resource. That is what we want.
local function waitESX() while ESX == nil do Wait(50) end end

-- --------------------------------------------------------------------------
-- exports stubs: resources of the original server that this server lacks.
-- A stub is used only while the real resource is NOT started.
-- --------------------------------------------------------------------------
local realExports = exports
local stubs = {
    sunset_clothe = {
        getUsedType = function() return {} end,
        getClotheData = function() return nil end,
        getUsed = function() return {} end,
        getOwnedClotheByType = function() return {} end,
        getOwnedPack = function() return {} end,
        toggleClothe = function() return false end,
        unUseByType = function() end,
    },
    sunset_utils = {
        GetServerOSTime = function() return GetCloudTimeAsInt() end,
        checkncz = function() return false end,
        canAccessToVehicle = function() return true end,
        deactiveArmoredHelmet = function() end,
        checkArmoredHelmetActive = function() return false end,
        getHandupState = function() return false end,
        tradeUICallback = function() end,
        startTrade = function() end,
        me = function() end,
    },
    ['sun-jobs'] = { notBlackListCoords = function() return true end },
    ['sun-robbery'] = { doesInRob = function() return false end },
    ['sun-animmenu'] = { PlayEmote = function() end },
    gangs = { isInGangWorld = function() return false end },
    esx_vehiclecontrol = {
        IsGOV = function() return false end,
        HaveAccess = function() return true end,
    },
}

exports = setmetatable({}, {
    __call = function(_, ...) return realExports(...) end,
    __index = function(_, res)
        local stub = stubs[res]
        if stub and GetResourceState(res) ~= 'started' then
            return setmetatable({}, {
                __index = function(_, fn)
                    local f = stub[fn]
                    return function(_, ...)
                        if f then return f(...) end
                    end
                end,
            })
        end
        return realExports[res]
    end,
})

-- --------------------------------------------------------------------------
-- key events: the original server got 'KeyDown:<key>' / 'KeyUp:<key>' events
-- from its sunset_utils resource. Without it F2 / Alt+number do nothing, so
-- we raise the same events from FiveM key mappings.
-- (Players can rebind them in Settings > Key Bindings > FiveM.)
-- --------------------------------------------------------------------------
if GetResourceState('sunset_utils') ~= 'started' then
    local keys = { f2 = 'F2', lmenu = 'LMENU' }
    for i = 0, 9 do keys[tostring(i)] = tostring(i) end
    for name, key in pairs(keys) do
        RegisterCommand('+sunkey_' .. name, function() TriggerEvent('KeyDown:' .. name) end, false)
        RegisterCommand('-sunkey_' .. name, function() TriggerEvent('KeyUp:' .. name) end, false)
        RegisterKeyMapping('+sunkey_' .. name, 'Inventory: ' .. name, 'keyboard', key)
    end
    -- manual fallback if the key is rebound/blocked:  /suninv
    RegisterCommand('suninv', function() TriggerEvent('KeyDown:f2') end, false)
end

-- --------------------------------------------------------------------------
-- stand-ins for functions that live in modules not loaded in stage 1
-- (modules/*/client/*.lua redefine these when they are enabled in stage 2)
-- --------------------------------------------------------------------------
function openTrunk() return false end
function setBag() end
function getRandomRecycle() return nil end
deleteCoords = deleteCoords or {}

-- --------------------------------------------------------------------------
-- ESX helpers
-- --------------------------------------------------------------------------
local function installHelpers()
    ESX.src = GetPlayerServerId(PlayerId())

    ESX.TriggerServerEvent = function(name, ...) TriggerServerEvent(name, ...) end

    -- items table (name -> {label, weight, limit, canRemove, rare}) from the server
    local itemsCache, fetching = nil, false
    ESX.getItems = function()
        if itemsCache then return itemsCache end
        if not fetching then
            fetching = true
            ESX.TriggerServerCallback('sun-inventory-hud:getItems', function(res)
                itemsCache = res or {}
            end)
        end
        return nil
    end
    ESX.getItem = function(name)
        local it = itemsCache and itemsCache[name]
        if it then return it end
        return { name = name, label = name, weight = 0.5, limit = -1, canRemove = true }
    end
    ESX.getItemWeight = function(name) return ESX.getItem(name).weight or 0.5 end
    ESX.fetchListedItems = function() end

    -- player state (replicated via state bags). canGive defaults to true.
    ESX.GetPlayerState = function(src, key)
        local v = Player(src).state[key]
        if v == nil and key == 'canGive' then return true end
        return v
    end
    ESX.SetPlayerState = function(key, val) LocalPlayer.state:set(key, val, true) end

    -- notifications
    local function notify(msg)
        if ESX.ShowNotification then ESX.ShowNotification(tostring(msg)) end
    end
    ESX.Alert = function(_, msg) notify(msg) end
    ESX.notification = function(_, msg) notify(msg) end
    ESX.chatMessage = function(msg) notify(msg) end

    ESX.isDead = function() return IsEntityDead(PlayerPedId()) end
    ESX.GetDistance = function(a, b) return #(vector3(a.x, a.y, a.z) - vector3(b.x, b.y, b.z)) end

    ESX.Game = ESX.Game or {}
    ESX.Game.GetPlayersToSend = function(dist)
        local out, me = {}, GetEntityCoords(PlayerPedId())
        for _, p in ipairs(GetActivePlayers()) do
            local ped = GetPlayerPed(p)
            if #(GetEntityCoords(ped) - me) <= (dist or 50.0) then
                out[#out + 1] = GetPlayerServerId(p)
            end
        end
        return out
    end
    ESX.Game.doesPlayerExist = function(id)
        for _, p in ipairs(GetActivePlayers()) do
            if GetPlayerServerId(p) == tonumber(id) then return true end
        end
        return false
    end

    -- jobs / blocked items (this server has no such restrictions yet)
    local mil = { police = true, sheriff = true, fbi = true, mt = true, justice = true, detective = true }
    ESX.militaryJobs, ESX.militaryJobs2 = mil, mil
    ESX.blackListSearch = {}
    ESX.doesBlockedItem = function() return false end
    ESX.doesBlockedItemButCanGive = function() return false end
    ESX.doesBlockedItemJob = function() return false end

    ESX.DoesHaveItem2 = function(name, count)
        for _, it in ipairs(ESX.GetPlayerData().inventory or {}) do
            if it.name == name then return (it.count or 0) >= (count or 1) end
        end
        return false
    end

    -- essentialmode's client rebuilds PlayerData.loadout from the ped's weapons
    -- every few seconds (one entry per weapon TYPE, no serial). The Sunset client
    -- needs the real, serial-bearing loadout, so we keep the server's copy here:
    --   * captured from every 'inventory:getSlots' answer (sent when the UI opens)
    --   * refreshed by the server's 'esx:updateLoadout' push after any weapon change
    local serverLoadout = nil

    local baseTSC = ESX.TriggerServerCallback
    ESX.TriggerServerCallback = function(name, cb, ...)
        if name == 'inventory:getSlots' then
            return baseTSC(name, function(res)
                if type(res) == 'table' and type(res.loadout) == 'table' then
                    serverLoadout = res.loadout
                end
                cb(res)
            end, ...)
        end
        return baseTSC(name, cb, ...)
    end

    AddEventHandler('sun-inventory-hud:setLoadout', function(loadout)
        if type(loadout) == 'table' then serverLoadout = loadout end
    end)

    local baseGetPlayerData = ESX.GetPlayerData
    ESX.GetPlayerData = function()
        local d = baseGetPlayerData() or {}
        local src = serverLoadout or d.loadout or {}
        local loadout = {}
        for _, w in ipairs(src) do
            local e = {}
            for k, v in pairs(w) do e[k] = v end
            e.serial = e.serial or ('NOSERIAL-' .. tostring(e.name))
            e.metadata = e.metadata or {}
            e.metadata.serial = e.metadata.serial or e.serial
            e.metadata.shots = e.metadata.shots or 0
            loadout[#loadout + 1] = e
        end
        d.loadout = loadout
        d.inventory = d.inventory or {}
        d.World = d.World or 0
        d.name2 = d.name2 or d.name or GetPlayerName(PlayerId())
        return d
    end
end

if ESX ~= nil then
    installHelpers()
else
    CreateThread(function() waitESX() installHelpers() end)
end

-- server pushes the whole loadout after any weapon change
RegisterNetEvent('esx:updateLoadout', function(loadout)
    TriggerEvent('sun-inventory-hud:setLoadout', loadout)
end)
