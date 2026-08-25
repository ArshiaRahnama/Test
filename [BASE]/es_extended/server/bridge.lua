--[[
    BRIDGE RESOURCE — essentialmode  ->  es_extended (fake)
    ---------------------------------------------------------
    essentialmode STAYS untouched. This resource only wraps its
    existing ESX shared object (already exposed via the classic
    "esx:getSharedObject" event that essentialmode fires) and
    patches on the few extra fields that ox_inventory expects
    from a real es_extended ('1.6.0'+).

    IMPORTANT: no Wait()/yield anywhere in here that could run
    during an export call — yielding across an export boundary
    can throw and take down the calling resource (this is what
    broke every menu last time).
]]

local ESX = nil

local function patchPlayer(xPlayer)
    if not xPlayer or xPlayer.__bridgePatched then return xPlayer end

    xPlayer.getAccount = function(name)
        if name == 'bank' then
            return { money = xPlayer.bank or 0 }
        elseif name == 'money' or name == 'cash' then
            return { money = xPlayer.money or 0 }
        end
        return { money = 0 }
    end

    xPlayer.sex = xPlayer.sex or 'm'
    xPlayer.dateofbirth = xPlayer.dateofbirth or '01/01/1990'

    -- essentialmode has no equivalent of es_extended's xPlayer.syncInventory
    -- (used by ox_inventory to push weight/account updates to the client).
    -- essentialmode's own HUD/money display updates through its own separate
    -- mechanism already, so a safe no-op here is enough to stop the crash.
    xPlayer.syncInventory = xPlayer.syncInventory or function(weight, maxWeight, items, money) end

    xPlayer.__bridgePatched = true
    return xPlayer
end

local function setupESX()
    if not ESX then return false end

    if not ESX.GetConfig then
        ESX.GetConfig = function()
            return { CustomInventory = 'ox' }
        end
    end

    if not ESX.UseItem then
        ESX.UseItem = function(source, item)
            local cb = ESX.UsableItemsCallbacks and ESX.UsableItemsCallbacks[item]
            if cb then
                cb(source)
                return true
            end
            return false
        end
    end

    if not ESX.__bridgeWrapped then
        local originalGetPlayerFromId = ESX.GetPlayerFromId
        ESX.GetPlayerFromId = function(source)
            return patchPlayer(originalGetPlayerFromId(source))
        end
        ESX.__bridgeWrapped = true
    end

    if ESX.Players then
        for _, xPlayer in pairs(ESX.Players) do
            patchPlayer(xPlayer)
        end
    end

    return true
end

-- Runs synchronously (no Wait) right when this resource starts.
-- essentialmode is a hard `dependency`, so it is guaranteed to already
-- be started and its esx:getSharedObject handler already registered.
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

if setupESX() then
    print('^2[es_extended bridge] Ready — essentialmode is now exposed as es_extended for ox_inventory.^0')
else
    print('^1[es_extended bridge] ERROR: essentialmode did not answer esx:getSharedObject. Check that essentialmode is actually running.^0')
end

-- essentialmode fires "es:firstSpawn" (source, player) once a player's data is
-- fully loaded and they've spawned for the first time this session.
-- ox_inventory's own ESX bridge only sets up inventories ONCE, 500ms after
-- ox_inventory itself starts, for whoever is already connected at that
-- instant — anyone who joins afterwards (i.e. basically every real player)
-- never gets an inventory, which is why F2 / the whole inventory silently
-- does nothing for them. Wire it up here.
local function convertInventoryFormat(inventory)
    -- essentialmode stores player.inventory as a LIST of {name=.., count=..}
    -- entries. ox_inventory's own convertInventory() expects a DICT of
    -- {[itemName] = count} (old ESX 1.0 style) and breaks (silently compares
    -- a table > 0) when handed essentialmode's list shape instead. Convert
    -- straight to ox_inventory's real slotted format ourselves so it's used
    -- as-is and convertInventory is never invoked at all.
    local slots = {}
    local slot = 0

    if type(inventory) == 'table' then
        for _, v in pairs(inventory) do
            if type(v) == 'table' and v.name and v.count and v.count > 0 then
                slot = slot + 1
                slots[slot] = { slot = slot, name = v.name, count = v.count }
            end
        end
    end

    return slots
end

local alreadySetup = {}

local function setupPlayerInventory(source, player)
    if alreadySetup[source] then
        return
    end
    alreadySetup[source] = true

    print(('^3[es_extended bridge DEBUG] es:firstSpawn fired for source %s (identifier=%s, name=%s)^0'):format(
        tostring(source), tostring(player and player.identifier), tostring(player and player.name)
    ))

    if not player then
        print('^1[es_extended bridge DEBUG] es:firstSpawn fired but player object is nil — cannot set up inventory.^0')
        return
    end

    CreateThread(function()
        local waited = 0
        while GetResourceState('ox_inventory') ~= 'started' do
            Wait(200)
            waited = waited + 200
            if waited >= 10000 then
                print('^1[es_extended bridge DEBUG] Gave up waiting for ox_inventory to start after 10s for source ' .. tostring(source) .. '^0')
                return
            end
        end

        patchPlayer(player)
        player.source = source

        local ok, err = pcall(function()
            exports.ox_inventory:setPlayerInventory(player, convertInventoryFormat(player.inventory))
        end)

        if ok then
            print(('^2[es_extended bridge DEBUG] setPlayerInventory called successfully for source %s.^0'):format(tostring(source)))
        else
            print(('^1[es_extended bridge DEBUG] setPlayerInventory ERRORED for source %s: %s^0'):format(tostring(source), tostring(err)))
        end
    end)
end

AddEventHandler('es:firstSpawn', setupPlayerInventory)

AddEventHandler('esx:playerDropped', function(source)
    alreadySetup[source] = nil
end)

-- Also cover players already connected & spawned when this resource (re)starts
-- mid-session (es:firstSpawn only fires once per player per server session).
-- Note: essentialmode's ESX.Players table is never actually populated — real
-- player objects live in its internal Users[source] table, only reachable
-- through ESX.GetPlayerFromId(source). So we walk currently connected
-- player IDs instead of iterating ESX.Players.
for _, src in ipairs(GetPlayers()) do
    local player = ESX and ESX.GetPlayerFromId and ESX.GetPlayerFromId(tonumber(src))
    if player then
        setupPlayerInventory(tonumber(src), player)
    end
end

-- Never yield inside this export — always return immediately.
exports('getSharedObject', function()
    if not ESX then
        -- one retry in case this is ever called unusually early
        TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
        setupESX()
    end
    return ESX
end)
