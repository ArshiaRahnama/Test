--[[
    ================================================================
    GRID SLOTS — features #1, #2, #3, #15, #23 (server half)
    ================================================================

    The placement map itself lives on the player object (essentialmode/
    server/classes/slots.lua). This file is only the transport: it
    builds the display payload the NUI needs, and exposes exactly three
    mutations to the client — move, split, drop.

    ── Why there is no "setGrid" event ──
    The obvious shape for a drag-and-drop grid is "client sends me its
    whole layout, server stores it". That is also the single easiest
    dupe in any inventory ever written: the client declares the truth.
    Instead every mutation here is a *relative* operation the server
    performs itself against its own state:

        move(from, to)          — rearranges, conserves total by proof
        split(from, to, count)  — count is clamped to what's in `from`
        drop(slot, count)       — clamped, then removed via the same
                                  RemoveItem path everything else uses

    None of them can produce a unit that didn't exist. The client never
    sends a count it owns, a name it owns, or a layout it owns.
]]

if Config.Framework ~= "esx" then
    return
end

--═════════════════════════════════════════════════════════════════════
-- Display payload
--═════════════════════════════════════════════════════════════════════

local function itemMeta(name)
    local label = (GetItemLabel and GetItemLabel(name)) or name
    return {
        label  = label,
        image  = Config.Pictures and (Config.Pictures[name] or Config.Pictures[string.lower(name)]) or nil,
        weight = (ESX and ESX.getItemWeight and ESX.getItemWeight(name)) or 0,
        rank   = Config.GetItemRank and Config.GetItemRank(name) or 'common',
        usable = true,
    }
end

--- Everything the NUI needs to draw the grid in one payload.
--- Deliberately ONE callback rather than one per section: the old UI
--- fired getPlayerInventory plus a second-panel call plus a slot call on
--- every single interaction, which is why the panel visibly flickered.
local function buildGrid(xPlayer)
    local slots, stackLimits = {}, {}

    for slotStr, entry in pairs(xPlayer.getSlots()) do
        local meta = itemMeta(entry.name)
        stackLimits[entry.name] = ESX_StackLimit and ESX_StackLimit(entry.name) or 50
        slots[slotStr] = {
            slot   = tonumber(slotStr),
            name   = entry.name,
            count  = entry.count,
            label  = meta.label,
            image  = meta.image,
            weight = meta.weight,
            rank   = meta.rank,
            type   = 'item_standard',
            usable = meta.usable,
            stackLimit = stackLimits[entry.name],
            -- #5: per-item note, if the owner wrote one
            note   = InvNotes and InvNotes.get(GetPlayerLicense(xPlayer), 'item:' .. entry.name) or nil,
        }
    end

    local unplaced = {}
    for _, entry in ipairs(xPlayer.getUnplaced()) do
        local meta = itemMeta(entry.name)
        unplaced[#unplaced + 1] = {
            name = entry.name, count = entry.count,
            label = meta.label, image = meta.image,
            weight = meta.weight, rank = meta.rank,
            type = 'item_standard',
        }
    end

    return {
        slots           = slots,
        unplaced        = unplaced,
        normalSlots     = Config.InventorySlots or 50,
        backpackStart   = Config.BackpackSlotStart or 101,
        backpackCount   = xPlayer.backpackSlotCount or 0,
        weight          = GetPlayerWeight(xPlayer),
        maxWeight       = GetPlayerMaxWeight(xPlayer),
    }
end

RegisterServerCallback('esx_inventory:getGrid', function(source, cb)
    local xPlayer = GetPlayerFromId(source)
    if not xPlayer or not xPlayer.getSlots then
        -- Slot layer missing = essentialmode wasn't restarted after the
        -- update. Say so loudly once rather than silently showing an
        -- empty inventory, which looks exactly like item loss.
        print('^1[esx_inventory/slots] player object has no slot layer — restart essentialmode (server/classes/slots.lua must load).^7')
        cb(nil)
        return
    end
    cb(buildGrid(xPlayer))
end)

local function pushGrid(source)
    local xPlayer = GetPlayerFromId(source)
    if not xPlayer or not xPlayer.getSlots then return end
    TriggerClientEvent('esx_inventory:gridUpdated', source, buildGrid(xPlayer))
end

_G.PushInventoryGrid = pushGrid

-- Any inventory change from ANYWHERE (a shop, a job, an admin command,
-- another player's give) re-pushes the grid to that player if they have
-- it open. This is what makes the grid feel live instead of stale.
AddEventHandler('esx:onaddInventoryItem', function(src) pushGrid(src) end)
AddEventHandler('esx:onRemoveInventoryItem', function(src) pushGrid(src) end)

--═════════════════════════════════════════════════════════════════════
-- #1 — MOVE
--═════════════════════════════════════════════════════════════════════

RegisterNetEvent('esx_inventory:moveSlot')
AddEventHandler('esx_inventory:moveSlot', function(from, to)
    local source = source
    if _G.InvGuard and not _G.InvGuard.rateLimit(source, 'default') then return end

    local xPlayer = GetPlayerFromId(source)
    if not xPlayer or not xPlayer.moveSlot then return end

    if xPlayer.moveSlot(from, to) then
        pushGrid(source)
    end
end)

--═════════════════════════════════════════════════════════════════════
-- #2 — SPLIT  (right-drag / shift-drag a partial stack)
--═════════════════════════════════════════════════════════════════════

RegisterNetEvent('esx_inventory:splitSlot')
AddEventHandler('esx_inventory:splitSlot', function(from, to, count)
    local source = source
    if _G.InvGuard and not _G.InvGuard.rateLimit(source, 'default') then return end

    local xPlayer = GetPlayerFromId(source)
    if not xPlayer or not xPlayer.splitSlot then return end

    if xPlayer.splitSlot(from, to, count) then
        pushGrid(source)
    end
end)

--═════════════════════════════════════════════════════════════════════
-- #3 — DRAG STRAIGHT ONTO THE GROUND
--
-- The client reports "slot N, count C was dragged outside the window".
-- It does NOT report what that slot contains — the server reads that
-- from its own map. So a forged message can at worst drop something the
-- player genuinely has.
--═════════════════════════════════════════════════════════════════════

RegisterNetEvent('esx_inventory:dropSlotToGround')
AddEventHandler('esx_inventory:dropSlotToGround', function(slot, count)
    local source = source
    if not Config.Drop or not Config.Drop.enabled then return end
    if _G.InvGuard and not _G.InvGuard.rateLimit(source, 'drop') then return end

    local xPlayer = GetPlayerFromId(source)
    if not xPlayer or not xPlayer.invSlots then return end

    slot = tonumber(slot)
    if not slot or not xPlayer.isValidSlot(slot) then return end

    local entry = xPlayer.invSlots[slot]
    if not entry then return end

    count = tonumber(count) or entry.count
    count = math.floor(count)
    if count <= 0 then return end
    count = math.min(count, entry.count)

    if Config.ItemNoDrop and Config.ItemNoDrop[entry.name] then
        showNotification(xPlayer, Locales[Config.Language]['no_possible'], 'error')
        return
    end

    -- Hand off to the existing, already server-validated drop system
    -- rather than duplicating its spawn/despawn/cap logic here.
    local item = {
        type  = 'item_standard',
        name  = entry.name,
        label = (GetItemLabel and GetItemLabel(entry.name)) or entry.name,
    }
    TriggerEvent('esx_inventory:internalDrop', source, item, count)
    pushGrid(source)
end)

--═════════════════════════════════════════════════════════════════════
-- #15 — backpack band resize, called by the backpack equip/unequip flow
--═════════════════════════════════════════════════════════════════════

exports('setBackpackSlots', function(source, backpackName)
    local xPlayer = GetPlayerFromId(source)
    if not xPlayer or not xPlayer.setBackpackSlots then return 0 end
    local n = xPlayer.setBackpackSlots(backpackName)
    pushGrid(source)
    return n
end)
