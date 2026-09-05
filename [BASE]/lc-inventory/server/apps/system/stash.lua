-------------------------------------------------------------------
-- Generic "stash" (shared/ground storage) server for lc-inventory.
--
-- Added because lc-inventory has no built-in shared-storage container
-- (only player inventory, per-vehicle trunk, and player-to-player
-- loot). External resources that need one (e.g. Unique_ALLGangs' gang
-- armories) open it through exports('stash', ...) client-side; this
-- file is the server half that actually reads/writes the data.
--
-- Storage: `stashs` table, `inventory` column = JSON object keyed by
-- slot number, each entry { name, count, slot, info, weight }. This
-- exact shape matches what Unique_ALLGangs/server/Gangs.lua already
-- expects and reads directly via SQL - so that resource works with
-- zero changes to its own stash-reading code.
-------------------------------------------------------------------

if Config.Framework ~= "esx" then
    return
end

local Stashes = {}      -- [stashId] = { items = {[slot] = {...}}, maxWeight = n, label = "" }
local StashViewers = {} -- [stashId] = { [source] = true }

local function isWeaponName(name)
    return type(name) == 'string' and name:sub(1, 7) == 'WEAPON_'
end

local function loadStash(stashId)
    if Stashes[stashId] then return Stashes[stashId] end

    local items = {}
    local result = MySQL.Sync.fetchScalar('SELECT inventory FROM stashs WHERE stash = ?', { stashId })
    if result then
        local ok, decoded = pcall(json.decode, result)
        if ok and type(decoded) == 'table' then
            items = decoded
        end
    end

    Stashes[stashId] = { items = items, maxWeight = 100000, label = stashId }
    return Stashes[stashId]
end

local function saveStash(stashId)
    local stash = Stashes[stashId]
    if not stash then return end

    MySQL.Async.execute('INSERT INTO stashs (stash, inventory) VALUES (:stash, :inventory) ON DUPLICATE KEY UPDATE inventory = :inventory', {
        ['stash'] = stashId,
        ['inventory'] = json.encode(stash.items)
    })
end

local function getStashWeight(stash)
    local total = 0
    for _, item in pairs(stash.items) do
        total = total + (tonumber(item.weight) or 0) * (tonumber(item.count) or 1)
    end
    return total
end

local function findFreeSlot(stash)
    local slot = 1
    while stash.items[slot] do
        slot = slot + 1
    end
    return slot
end

local function findItemSlot(stash, name)
    for slot, item in pairs(stash.items) do
        if item.name == name then return slot end
    end
    return nil
end

local function refreshStashViewers(stashId)
    if not StashViewers[stashId] then return end
    for src in pairs(StashViewers[stashId]) do
        TriggerClientEvent('lc-inventory:stashUpdated', src, stashId)
    end
end

-------------------------------------------------------------------
-- Item access control (rank/job-gated stashes)
--
-- Other resources register a checker function per stashId:
--   exports['lc-inventory']:registerStashAccessCheck('gang_ballas_armory', function(source, itemName)
--       -- return true if this player is allowed to take/see-unlocked this item
--   end)
-- If no checker is registered for a stashId, every item is accessible
-- (unrestricted stash - the default/previous behaviour).
-------------------------------------------------------------------

local StashAccessCheckers = {}

exports('registerStashAccessCheck', function(stashId, checkerFn)
    if type(stashId) == 'string' and type(checkerFn) == 'function' then
        StashAccessCheckers[stashId] = checkerFn
    end
end)

exports('clearStashAccessCheck', function(stashId)
    StashAccessCheckers[stashId] = nil
end)

local function canAccessStashItem(source, stashId, itemName)
    local checker = StashAccessCheckers[stashId]
    if not checker then return true end

    local ok, result = pcall(checker, source, itemName)
    if not ok then return true end -- a broken checker shouldn't lock the whole stash
    return result and true or false
end

RegisterServerCallback('lc-inventory:getStash', function(source, cb, stashId, maxWeight, label)
    if type(stashId) ~= 'string' then return cb({ items = {}, weight = 0, maxWeight = 0, label = '' }) end

    local stash = loadStash(stashId)
    stash.maxWeight = tonumber(maxWeight) or stash.maxWeight
    stash.label = label or stash.label

    local list = {}
    for _, item in pairs(stash.items) do
        local weapon = isWeaponName(item.name)
        local itemType = weapon and 'item_weapon' or 'item_standard'
        local itemLabel = weapon and ESX.GetWeaponLabel(item.name) or (GetItemLabel(item.name) or item.name)
        local locked = not canAccessStashItem(source, stashId, item.name)

        table.insert(list, {
            label = itemLabel,
            count = weapon and 1 or tonumber(item.count) or 1,
            limit = 0,
            type = itemType,
            name = item.name,
            image = Config.Pictures[item.name] or Config.Pictures[string.lower(item.name)],
            canRemove = false,
            usable = false,
            rare = false,
            stash = stashId,
            locked = locked
        })
    end

    cb({
        items = list,
        weight = getStashWeight(stash),
        maxWeight = stash.maxWeight,
        label = stash.label
    })
end)

RegisterNetEvent('lc-inventory:stashViewer')
AddEventHandler('lc-inventory:stashViewer', function(stashId, opening)
    local source = source
    if type(stashId) ~= 'string' then return end

    StashViewers[stashId] = StashViewers[stashId] or {}
    if opening then
        StashViewers[stashId][source] = true
    else
        StashViewers[stashId][source] = nil
    end
end)

RegisterNetEvent('lc-inventory:stashDeposit')
AddEventHandler('lc-inventory:stashDeposit', function(stashId, itemType, name, count)
    local source = source
    if type(stashId) ~= 'string' or type(name) ~= 'string' then return end

    local xPlayer = GetPlayerFromId(source)
    if not xPlayer then return end

    local stash = loadStash(stashId)
    count = tonumber(count) or 1
    if count <= 0 then return end

    if itemType == 'item_weapon' then
        if Config.WeaponNoGive[name] or not getWeapon(xPlayer, name) then return end

        local weight = Config.WeaponWeight[name] or Config.WeaponDefaultWeight
        if getStashWeight(stash) + weight > stash.maxWeight then
            showNotification(xPlayer, Locales[Config.Language]['trunk_weight_max'], 'error')
            return
        end

        local slot = findItemSlot(stash, name) or findFreeSlot(stash)
        stash.items[slot] = { name = name, count = 1, slot = slot, info = {}, weight = weight }
        removeWeapon(xPlayer, name)

    elseif itemType == 'item_account' then
        if getAccount(xPlayer, name) < count then return end

        local slot = findItemSlot(stash, name)
        if slot then
            stash.items[slot].count = tonumber(stash.items[slot].count) + count
        else
            slot = findFreeSlot(stash)
            stash.items[slot] = { name = name, count = count, slot = slot, info = {}, weight = 0 }
        end
        removeMoney(xPlayer, name, count)

    else
        local playerItem = GetItem(xPlayer, name)
        if not playerItem or GetItemAmount(playerItem) < count then return end

        local itemInfo = ESX.Items[string.lower(name)]
        local weight = itemInfo and itemInfo.weight or 0
        if getStashWeight(stash) + (weight * count) > stash.maxWeight then
            showNotification(xPlayer, Locales[Config.Language]['trunk_weight_max'], 'error')
            return
        end

        local slot = findItemSlot(stash, name)
        if slot then
            stash.items[slot].count = tonumber(stash.items[slot].count) + count
        else
            slot = findFreeSlot(stash)
            stash.items[slot] = { name = name, count = count, slot = slot, info = {}, weight = weight }
        end
        RemoveItem(xPlayer, name, count)
    end

    saveStash(stashId)
    refreshStashViewers(stashId)
end)

RegisterNetEvent('lc-inventory:stashWithdraw')
AddEventHandler('lc-inventory:stashWithdraw', function(stashId, itemType, name, count)
    local source = source
    if type(stashId) ~= 'string' or type(name) ~= 'string' then return end

    local xPlayer = GetPlayerFromId(source)
    if not xPlayer then return end

    local stash = loadStash(stashId)
    local slot = findItemSlot(stash, name)
    if not slot then return end

    if not canAccessStashItem(source, stashId, name) then
        showNotification(xPlayer, Locales[Config.Language]['no_access_item'] or 'You do not have access to this item.', 'error')
        return
    end

    local item = stash.items[slot]
    count = math.min(tonumber(count) or 1, tonumber(item.count) or 1)
    if count <= 0 then return end

    if itemType == 'item_weapon' then
        if Config.WeaponNoGive[name] then return end
        addWeapon(xPlayer, name, 250)
        stash.items[slot] = nil

    elseif itemType == 'item_account' then
        item.count = tonumber(item.count) - count
        addMoney(xPlayer, name, count)
        if item.count <= 0 then stash.items[slot] = nil end

    else
        if not getWeight(xPlayer, name, count) then
            showNotification(xPlayer, Locales[Config.Language]['trunk_weight_player_max'] or Locales[Config.Language]['trunk_weight_max'], 'error')
            return
        end
        AddItem(xPlayer, name, count)
        item.count = tonumber(item.count) - count
        if item.count <= 0 then stash.items[slot] = nil end
    end

    saveStash(stashId)
    refreshStashViewers(stashId)
end)

CreateThread(function()
    while true do
        Wait((Config.savingTimer or 5) * 60 * 1000)
        for stashId in pairs(Stashes) do
            saveStash(stashId)
        end
    end
end)
