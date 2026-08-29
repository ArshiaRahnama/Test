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

-- Serial-prefix rules for weapon registration, based on the giving player's
-- job/gang at the moment the weapon is created:
--   Law Enforcement jobs -> serial starts with "LAW"
--   Department of Justice jobs -> serial starts with "DOJ"
--   Anyone in a gang (no matching job) -> serial contains "GANG"
-- (mirrors [JOB]/esx_uniquejobs/shared/departments.lua's LE/DOJ job lists)
local LAW_JOBS = { police = true, sheriff = true, mt = true }
local DOJ_JOBS = { cid = true, cia = true, marshal = true, fbi = true, judge = true, doa = true }

local function randomDigits(n)
    local out = {}
    for i = 1, n do out[i] = tostring(math.random(0, 9)) end
    return table.concat(out)
end

local function buildSerial(xPlayer)
    local jobName = xPlayer.job and xPlayer.job.name
    local prefix

    if jobName and LAW_JOBS[jobName] then
        prefix = 'LAW'
    elseif jobName and DOJ_JOBS[jobName] then
        prefix = 'DOJ'
    elseif xPlayer.gang and xPlayer.gang.name and xPlayer.gang.name ~= '' then
        prefix = 'GANG'
    end

    if not prefix then
        return nil -- let ox_inventory generate its normal random serial
    end

    return ('%s-%s'):format(prefix, randomDigits(6))
end

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

    -- some scripts (e.g. Unique_Radio) call xPlayer.getName() — essentialmode
    -- only has the plain .name field, not a getter method for it.
    xPlayer.getName = xPlayer.getName or function()
        return xPlayer.name
    end

    -- Route essentialmode's weapon system through ox_inventory instead of its
    -- own internal `self.loadout` table, so weapons actually show up as items
    -- you can drag/drop/equip from the inventory UI.
    if not xPlayer.__weaponsBridged then
        xPlayer.addWeapon = function(weaponName, ammo)
            -- normalize casing defensively — some old commands/scripts pass
            -- "weapon_x" (lowercase prefix), but ox_inventory's weapon items
            -- are registered as "WEAPON_X" (all caps) and are case-sensitive.
            weaponName = string.upper(weaponName)
            local serial = buildSerial(xPlayer)
            exports.ox_inventory:AddItem(xPlayer.source, weaponName, 1, { ammo = ammo or 0, serial = serial })
        end

        xPlayer.removeWeapon = function(weaponName)
            weaponName = string.upper(weaponName)
            exports.ox_inventory:RemoveItem(xPlayer.source, weaponName, 1)
        end

        xPlayer.hasWeapon = function(weaponName)
            weaponName = string.upper(weaponName)
            return exports.ox_inventory:Search(xPlayer.source, 'count', weaponName) > 0
        end

        -- Same problem exists for regular items: essentialmode's own
        -- getInventoryItem/addInventoryItem/removeInventoryItem write
        -- straight into self.inventory, completely bypassing ox_inventory.
        -- Any admin command or script using these (like /giveitem) needs
        -- to go through ox_inventory too, or the item never actually shows
        -- up for the player.
        xPlayer.addInventoryItem = function(name, count)
            exports.ox_inventory:AddItem(xPlayer.source, name, tonumber(count) or 1)
        end

        xPlayer.removeInventoryItem = function(name, count)
            exports.ox_inventory:RemoveItem(xPlayer.source, name, tonumber(count) or 1)
        end

        xPlayer.getInventoryItem = function(name)
            local count = exports.ox_inventory:Search(xPlayer.source, 'count', name) or 0
            local itemData = exports.ox_inventory:Items(name)

            if not itemData then return nil end

            return {
                name = name,
                count = count,
                label = itemData.label,
                limit = itemData.stack == false and 1 or nil,
                usable = itemData.consume ~= nil or itemData.client ~= nil,
                rare = false,
                canRemove = true
            }
        end

        xPlayer.__weaponsBridged = true
    end

    -- CASH AS A REAL ITEM
    -- ---------------------------------------------------------------
    -- essentialmode keeps cash as a plain `self.money` number. To make
    -- it a real draggable/giveable "money" item in ox_inventory while
    -- keeping essentialmode itself untouched, we sync in both directions:
    --   1) addMoney/removeMoney/setMoney -> also update the ox_inventory
    --      "money" item count to match (script gives you cash -> item updates)
    --   2) A periodic check compares the item count against what we last
    --      synced; any difference (player dropped/gave/spent it from the
    --      UI) gets applied back to the real self.money via the same
    --      addMoney/removeMoney functions everything else already uses.
    if not xPlayer.__cashBridged then
        xPlayer.__lastSyncedCash = xPlayer.money or 0

        local originalAddMoney = xPlayer.addMoney
        local originalRemoveMoney = xPlayer.removeMoney
        local originalSetMoney = xPlayer.setMoney

        local function pushCashToItem()
            local ok = pcall(function()
                local current = exports.ox_inventory:Search(xPlayer.source, 'count', 'money') or 0
                local target = xPlayer.money or 0
                local diff = target - current

                if diff > 0 then
                    exports.ox_inventory:AddItem(xPlayer.source, 'money', diff)
                elseif diff < 0 then
                    exports.ox_inventory:RemoveItem(xPlayer.source, 'money', -diff)
                end

                xPlayer.__lastSyncedCash = target
            end)

            if not ok then
                -- inventory isn't ready yet (e.g. still on the character
                -- creation screen) — just remember the real balance so the
                -- first real setPlayerInventory picks it up correctly.
                xPlayer.__lastSyncedCash = xPlayer.money or 0
            end
        end

        xPlayer.addMoney = function(m)
            originalAddMoney(m)
            pushCashToItem()
        end

        xPlayer.removeMoney = function(m)
            originalRemoveMoney(m)
            pushCashToItem()
        end

        xPlayer.setMoney = function(m)
            originalSetMoney(m)
            pushCashToItem()
        end

        -- Reverse direction: ox_inventory calls xPlayer.syncInventory(weight,
        -- maxWeight, items, accounts) every time this player's inventory
        -- changes, and `accounts.money` is the current count of the "money"
        -- item sitting in it (ox_inventory tracks this automatically). If
        -- that count moved on its own (player gave/dropped/spent cash from
        -- the UI, not through addMoney/removeMoney), apply the difference
        -- to the real balance so the two stay in sync either way.
        xPlayer.syncInventory = function(weight, maxWeight, items, accounts)
            if not accounts or accounts.money == nil then return end

            local diff = accounts.money - xPlayer.__lastSyncedCash

            if diff > 0 then
                originalAddMoney(diff)
            elseif diff < 0 then
                originalRemoveMoney(-diff)
            end

            xPlayer.__lastSyncedCash = accounts.money
        end

        xPlayer.__cashBridged = true
    end

    xPlayer.sex = xPlayer.sex or 'm'
    xPlayer.dateofbirth = xPlayer.dateofbirth or '01/01/1990'

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

    -- essentialmode already defines its OWN ESX.UseItem (in
    -- server/functions.lua) that only calls `callback(source)` — no slot
    -- data. Since it always exists, "if not ESX.UseItem" here never ran,
    -- so the metadata (clothing drawable/texture, etc) never reached any
    -- usable-item callback and things like wearing clothes silently did
    -- nothing. Always override it instead of only filling a gap.
    ESX.UseItem = function(source, item, slotData)
        print(('^3[es_extended bridge DEBUG] ESX.UseItem called: source=%s item=%s hasSlotData=%s^0'):format(tostring(source), tostring(item), tostring(slotData ~= nil)))

        local cb = ESX.UsableItemsCallbacks and ESX.UsableItemsCallbacks[item]
        if cb then
            print(('^2[es_extended bridge DEBUG] Found usable callback for "%s", invoking it.^0'):format(tostring(item)))
            -- pass the full ox_inventory slot (includes .metadata, e.g.
            -- clothing drawable/texture/label) through as a 3rd arg —
            -- existing callbacks that only take `source` still work fine
            cb(source, slotData)
            return true
        end

        print(('^1[es_extended bridge DEBUG] No usable callback registered for "%s" — nothing happens.^0'):format(tostring(item)))
        return false
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
local function convertInventoryFormat(inventory, loadout, cashAmount)
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

    -- essentialmode keeps weapons in a SEPARATE table (self.loadout), not in
    -- .inventory at all. Bring them into the same slot list as weapon items
    -- with ammo/components carried over as metadata, so existing weapons
    -- migrate into ox_inventory instead of silently vanishing.
    if type(loadout) == 'table' then
        for _, w in ipairs(loadout) do
            if w.name then
                slot = slot + 1
                slots[slot] = {
                    slot = slot,
                    name = w.name,
                    count = 1,
                    metadata = {
                        ammo = w.ammo or 0,
                        components = w.components or {}
                    }
                }
            end
        end
    end

    -- Give the player their real cash as an actual "money" item slot too,
    -- so it's there to drag/give/drop from the very first load — not just
    -- something that appears the next time addMoney/removeMoney runs.
    local cash = tonumber(cashAmount) or 0
    if cash > 0 then
        slot = slot + 1
        slots[slot] = { slot = slot, name = 'money', count = cash }
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

        -- Only build a fresh inventory from essentialmode's own data the
        -- FIRST time this player is ever seen by ox_inventory. After that,
        -- ox_inventory already has its own real saved copy (in the
        -- ox_inventory_data column) with whatever slot arrangement the
        -- player left it in — passing nil here makes it load that instead
        -- of us re-generating (and overwriting) it from essentialmode every
        -- single time they connect.
        local hasSavedInventory = MySQL.scalar.await(
            'SELECT 1 FROM `users` WHERE `identifier` = ? AND `ox_inventory_data` IS NOT NULL',
            { player.identifier }
        )

        local initialData = nil
        if not hasSavedInventory then
            initialData = convertInventoryFormat(player.inventory, player.loadout, player.money)
            print(('^3[es_extended bridge DEBUG] No existing ox_inventory save for %s — migrating from essentialmode once.^0'):format(tostring(player.identifier)))
        end

        local ok, err = pcall(function()
            exports.ox_inventory:setPlayerInventory(player, initialData)
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
