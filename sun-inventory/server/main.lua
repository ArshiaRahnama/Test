--[[
    sun-inventory — server core.

    Handles: shared per-key JSON storage (bags/trunks/job stashes/public
    stashes all reuse this) + the three bare inventory events the main
    UI fires directly (throw / give-to-target / swap-money).

    Every mutation here follows the same shape the rest of this base's
    security-hardened resources use: verify -> lock -> mutate -> notify.
]]

CreateThread(function()
    MySQL.Async.execute([[
        CREATE TABLE IF NOT EXISTS `sun_inventories` (
            `identifier` VARCHAR(100) NOT NULL PRIMARY KEY,
            `items` LONGTEXT NULL,
            `weapons` LONGTEXT NULL
        )
    ]], {})
end)

Inventory = {}

function Inventory.Get(identifier)
    local result = MySQL.Sync.fetchAll('SELECT * FROM sun_inventories WHERE identifier = @identifier', { ['@identifier'] = identifier })
    if result[1] then
        return {
            items = json.decode(result[1].items or '[]') or {},
            weapons = json.decode(result[1].weapons or '[]') or {},
        }
    end
    return { items = {}, weapons = {} }
end

function Inventory.Save(identifier, data)
    MySQL.Async.execute([[
        INSERT INTO sun_inventories (identifier, items, weapons) VALUES (@identifier, @items, @weapons)
        ON DUPLICATE KEY UPDATE items = @items, weapons = @weapons
    ]], {
        ['@identifier'] = identifier,
        ['@items'] = json.encode(data.items or {}),
        ['@weapons'] = json.encode(data.weapons or {}),
    })
end

-- ---------------------------------------------------------------------------
-- Anti-dupe: simple per-source mutex. Two rapid-fire NUI events on the same
-- player (double-click, laggy client retry) must not both pass their
-- pre-checks before either has actually mutated state.
-- ---------------------------------------------------------------------------
local locks = {}

local function withLock(source, fn)
    if locks[source] then return end
    locks[source] = true
    local ok, err = pcall(fn)
    locks[source] = nil
    if not ok then
        debugprint(('[sun-inventory] handler error for %s: %s'):format(source, tostring(err)))
    end
end

-- ---------------------------------------------------------------------------
-- THROW / GIVE / SWAP MONEY  (client/main.lua: inventory:throwItem,
-- inventory:giveItemToTarget, inventory:swapMoney)
-- ---------------------------------------------------------------------------

RegisterServerEvent('inventory:throwItem')
AddEventHandler('inventory:throwItem', function(itemName, count, isAmmo)
    local source = source
    local xPlayer = ESX.GetPlayerFromId(source)
    if not xPlayer then return end
    if isAmmo then
        -- Ammo "throw" needs a real pickup-prop implementation to be safe
        -- (dropping ammo with no world pickup just deletes it, which is
        -- fine, but silently succeeding either way is intentional here).
        return
    end

    count = tonumber(count)
    if not count or count <= 0 or count ~= math.floor(count) then return end

    withLock(source, function()
        local item = xPlayer.getInventoryItem(itemName)
        if not item or item.count < count then return end
        xPlayer.removeInventoryItem(itemName, count)
        -- Spawn a pickup prop here if your framework supports it
        -- (esx_property/esx_pickups etc.) — left as a hook.
    end)
end)

RegisterServerEvent('inventory:giveItemToTarget')
AddEventHandler('inventory:giveItemToTarget', function(targetId, itemName, count, isAmmo)
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)
    local xTarget = ESX.GetPlayerFromId(tonumber(targetId))
    if not xPlayer or not xTarget then return end
    if xPlayer.source == xTarget.source then return end

    local pPed, tPed = GetPlayerPed(src), GetPlayerPed(xTarget.source)
    if #(GetEntityCoords(pPed) - GetEntityCoords(tPed)) > 5.0 then return end

    count = tonumber(count)
    if not count or count <= 0 or count ~= math.floor(count) then return end

    withLock(src, function()
        local item = xPlayer.getInventoryItem(itemName)
        if not item or item.count < count then return end

        -- Weight check on the RECEIVING end. addInventoryItem does not
        -- enforce carry capacity itself, so without this a give could push
        -- the target arbitrarily over their max weight.
        if not xTarget.canCarryItem(itemName, count) then
            xPlayer.showNotification('Target cannot carry that much weight.')
            return
        end

        xPlayer.removeInventoryItem(itemName, count)
        xTarget.addInventoryItem(itemName, count)
    end)
end)

RegisterServerEvent('inventory:swapMoney')
AddEventHandler('inventory:swapMoney', function(targetId, amount)
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)
    local xTarget = ESX.GetPlayerFromId(tonumber(targetId))
    if not xPlayer or not xTarget then return end
    if xPlayer.source == xTarget.source then return end

    amount = tonumber(amount)
    if not amount or amount <= 0 or amount ~= math.floor(amount) then return end

    withLock(src, function()
        if xPlayer.getMoney() < amount then return end
        xPlayer.removeMoney(amount)
        xTarget.addMoney(amount)
    end)
end)

-- Exposed so module server files share the same lock without re-declaring it.
Inventory.withLock = withLock
