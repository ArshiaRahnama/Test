--[[
    ================================================================
    #5 — PER-ITEM EDITABLE DESCRIPTIONS
    ================================================================

    Table inv_item_notes already existed in sql_security.sql. This is
    the read/write side.

    `slot_key` is what makes a note stick to the right THING:
      item:<name>            a stackable item ("my lockpick set")
      weapon:<serial>        one specific weapon instance
      clothe:<rowId>         one specific clothing row

    Weapon notes follow the SERIAL, not the owner - so a note written by
    a previous owner travels with the gun. That is intentional and it is
    the interesting version of this feature: combined with #7 it lets a
    weapon carry a readable story. The `identifier` column still scopes
    plain item notes per-owner so two players' "lockpick" notes don't
    collide.

    Notes are cached in memory because they are read on every single
    grid build (once per inventory open, plus on every change) and a DB
    round-trip there would be felt.
]]

InvNotes = {}

local cache = {}          -- [identifier .. '|' .. slot_key] = note
local loadedOwners = {}   -- [identifier] = true

local MAX_LEN = 255

local function cacheKey(identifier, slotKey)
    return tostring(identifier) .. '|' .. tostring(slotKey)
end

--- Weapon notes are owner-independent (they follow the serial), so they
--- are stored under a fixed pseudo-owner.
local function ownerFor(identifier, slotKey)
    if type(slotKey) == 'string' and slotKey:sub(1, 7) == 'weapon:' then
        return '@serial'
    end
    return identifier
end

function InvNotes.load(identifier, cb)
    if loadedOwners[identifier] then
        if cb then cb() end
        return
    end
    MySQL.Async.fetchAll('SELECT slot_key, note FROM inv_item_notes WHERE identifier = @id OR identifier = \'@serial\'', {
        ['@id'] = identifier
    }, function(rows)
        for _, row in ipairs(rows or {}) do
            cache[cacheKey(ownerFor(identifier, row.slot_key), row.slot_key)] = row.note
        end
        loadedOwners[identifier] = true
        if cb then cb() end
    end)
end

--- Synchronous read from cache. Returns nil if not loaded yet, which the
--- grid treats as "no note" - it fills in on the next refresh rather
--- than blocking the whole payload on a query.
function InvNotes.get(identifier, slotKey)
    return cache[cacheKey(ownerFor(identifier, slotKey), slotKey)]
end

function InvNotes.set(identifier, slotKey, note)
    local owner = ownerFor(identifier, slotKey)

    if note == nil or note == '' then
        cache[cacheKey(owner, slotKey)] = nil
        MySQL.Async.execute('DELETE FROM inv_item_notes WHERE identifier = @id AND slot_key = @k', {
            ['@id'] = owner, ['@k'] = slotKey
        })
        return
    end

    note = tostring(note):sub(1, MAX_LEN)
    cache[cacheKey(owner, slotKey)] = note

    MySQL.Async.execute([[
        INSERT INTO inv_item_notes (identifier, slot_key, note)
        VALUES (@id, @k, @n)
        ON DUPLICATE KEY UPDATE note = @n, updated_at = NOW()
    ]], { ['@id'] = owner, ['@k'] = slotKey, ['@n'] = note })
end

AddEventHandler('esx:playerLoaded', function(source, xPlayer)
    if xPlayer then InvNotes.load(GetPlayerLicense(xPlayer)) end
end)

--═════════════════════════════════════════════════════════════════════
-- Client entry points
--═════════════════════════════════════════════════════════════════════

RegisterNetEvent('esx_inventory:setItemNote')
AddEventHandler('esx_inventory:setItemNote', function(slotKey, note)
    local source = source
    local xPlayer = GetPlayerFromId(source)
    if not xPlayer or type(slotKey) ~= 'string' then return end
    if _G.InvGuard and not _G.InvGuard.rateLimit(source, 'default') then return end

    -- Shape check: only the three key namespaces this feature defines.
    local ns = slotKey:match('^(%a+):')
    if ns ~= 'item' and ns ~= 'weapon' and ns ~= 'clothe' then return end
    if #slotKey > 120 then return end

    local identifier = GetPlayerLicense(xPlayer)

    -- Ownership: you may only annotate something you currently hold.
    -- Without this, `weapon:<serial>` (which is deliberately global) would
    -- let anyone rewrite the description on anyone else's gun.
    if ns == 'item' then
        local item = GetItem(xPlayer, slotKey:sub(6))
        if not item or GetItemAmount(item) <= 0 then return end
    elseif ns == 'weapon' then
        local serial = slotKey:sub(8)
        local owns = false
        for _, w in ipairs(GetPlayerWeapon(xPlayer) or {}) do
            if w.serial == serial then owns = true break end
        end
        if not owns then return end
    elseif ns == 'clothe' then
        local rowId = tonumber(slotKey:sub(8))
        if not rowId then return end
        local owner = MySQL.Sync.fetchScalar('SELECT identifier FROM lc_clothes WHERE id = @id', { ['@id'] = rowId })
        if owner ~= identifier then return end
    end

    if type(note) == 'string' then
        -- Strip control characters; the note is rendered into the NUI and
        -- there is no reason for it to contain anything but text.
        note = note:gsub('%c', ' '):sub(1, MAX_LEN)
    else
        note = nil
    end

    InvNotes.set(identifier, slotKey, note)
    if _G.PushInventoryGrid then _G.PushInventoryGrid(source) end
end)

RegisterServerCallback('esx_inventory:getItemNote', function(source, cb, slotKey)
    local xPlayer = GetPlayerFromId(source)
    if not xPlayer or type(slotKey) ~= 'string' then return cb(nil) end
    local identifier = GetPlayerLicense(xPlayer)
    InvNotes.load(identifier, function()
        cb(InvNotes.get(identifier, slotKey))
    end)
end)

exports('getItemNote', function(source, slotKey)
    local xPlayer = GetPlayerFromId(source)
    if not xPlayer then return nil end
    return InvNotes.get(GetPlayerLicense(xPlayer), slotKey)
end)
