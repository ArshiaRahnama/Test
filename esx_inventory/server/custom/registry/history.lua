--[[
    ================================================================
    #7 CHAIN OF CUSTODY  +  #8 STOLEN WEAPON REGISTER
    ================================================================

    Both tables already existed in sql_security.sql; this is the code
    that finally writes to and reads from them.

    ── Design note on #7 ──
    A custody ledger is only useful if it is APPEND-ONLY and if every
    path that moves a weapon writes to it. A ledger with holes is worse
    than no ledger, because it looks authoritative while quietly
    omitting exactly the transfers someone cared enough to hide.

    So `record()` is called from every weapon-moving path in the
    resource: give, search/loot, ground drop + pickup, trunk, stash,
    property, corpse loot, and shop/armory grants (those call the
    exported version). If you add another path later, call it there too.

    ── Design note on #8 ──
    The serial stays PLAINTEXT and indexed. That was already the
    deliberate conclusion in server/custom/security/core.lua (the brief
    asked to "encrypt the serial", which would have broken exactly this
    feature while defending against nothing). The integrity guarantee
    comes from the HMAC tag, not from hiding the value.
]]

InvHistory = {}

local function nameOf(xPlayer)
    if not xPlayer then return nil end
    local ok, n = pcall(function() return xPlayer.getName() end)
    return ok and n or nil
end

--═════════════════════════════════════════════════════════════════════
-- #7 — record a custody change
--═════════════════════════════════════════════════════════════════════

--- @param serial string   weapon serial (nil = unserialised weapon, skipped)
--- @param weapon string   WEAPON_* name
--- @param fromPlayer      xPlayer losing it, or nil (world/shop/NPC)
--- @param toPlayer        xPlayer gaining it, or nil (destroyed/stored)
--- @param via string      'give'|'drop'|'pickup'|'loot'|'search'|'shop'|'admin'|'corpse'|'trunk'|'stash'|'property'
function InvHistory.record(serial, weapon, fromPlayer, toPlayer, via)
    if type(serial) ~= 'string' or serial == '' then return end

    MySQL.Async.execute([[
        INSERT INTO inv_weapon_history (serial, weapon, from_ident, to_ident, from_name, to_name, via)
        VALUES (@serial, @weapon, @fi, @ti, @fn, @tn, @via)
    ]], {
        ['@serial'] = serial,
        ['@weapon'] = tostring(weapon or '?'),
        ['@fi']  = fromPlayer and GetPlayerLicense(fromPlayer) or nil,
        ['@ti']  = toPlayer and GetPlayerLicense(toPlayer) or nil,
        ['@fn']  = nameOf(fromPlayer),
        ['@tn']  = nameOf(toPlayer),
        ['@via'] = tostring(via or 'unknown'),
    })

    -- #8: a stolen weapon resurfacing in someone's hands is the single
    -- most useful alert this whole system can produce, so raise it the
    -- moment it happens rather than waiting for a police scan.
    if toPlayer then
        MySQL.Async.fetchAll('SELECT status, reported_name FROM inv_stolen_weapons WHERE serial = @s AND status = \'stolen\'', {
            ['@s'] = serial
        }, function(rows)
            if rows and rows[1] and _G.InvGuard then
                _G.InvGuard.report('Stolen weapon changed hands', GetPlayerLicense(toPlayer),
                    ('%s #%s (reported by %s) via %s'):format(tostring(weapon), serial,
                        tostring(rows[1].reported_name), tostring(via)))
            end
        end)
    end
end

exports('recordWeaponHistory', function(serial, weapon, fromSource, toSource, via)
    InvHistory.record(serial, weapon,
        fromSource and GetPlayerFromId(fromSource) or nil,
        toSource and GetPlayerFromId(toSource) or nil,
        via)
end)

--═════════════════════════════════════════════════════════════════════
-- #7 — read it back (police only)
--═════════════════════════════════════════════════════════════════════

local function isPoliceJob(jobName)
    for _, allowed in ipairs(Config.PoliceJobs or {}) do
        if jobName == allowed then return true end
    end
    return false
end

local function jobNameOf(xPlayer)
    local job = GetJob(xPlayer)
    return type(job) == 'table' and job.name or job
end

RegisterServerCallback('esx_inventory:getWeaponHistory', function(source, cb, serial)
    local xPlayer = GetPlayerFromId(source)
    if not xPlayer or type(serial) ~= 'string' then return cb(nil) end
    if _G.InvGuard and not _G.InvGuard.rateLimit(source, 'scan') then return cb(nil) end

    -- Same reasoning as the existing scanWeapon event: the answer is
    -- never sent to a non-police client, so it can't be read out of
    -- network traffic by someone who just faked the UI state.
    if not isPoliceJob(jobNameOf(xPlayer)) then
        showNotification(xPlayer, Locales[Config.Language]['scan_no_equipment'] or "You don't have the equipment to run this check.", 'error')
        return cb(nil)
    end

    MySQL.Async.fetchAll([[
        SELECT weapon, from_name, to_name, via, created_at
        FROM inv_weapon_history
        WHERE serial = @s
        ORDER BY id ASC
        LIMIT 50
    ]], { ['@s'] = serial }, function(rows)
        MySQL.Async.fetchAll('SELECT status, reported_name, note, reported_at FROM inv_stolen_weapons WHERE serial = @s', {
            ['@s'] = serial
        }, function(stolen)
            cb({
                serial  = serial,
                entries = rows or {},
                stolen  = stolen and stolen[1] or nil,
            })
        end)
    end)
end)

--═════════════════════════════════════════════════════════════════════
-- #8 — report a weapon stolen / recovered
--═════════════════════════════════════════════════════════════════════

RegisterNetEvent('esx_inventory:reportWeaponStolen')
AddEventHandler('esx_inventory:reportWeaponStolen', function(serial, weapon, note)
    local source = source
    local xPlayer = GetPlayerFromId(source)
    if not xPlayer or type(serial) ~= 'string' or serial == '' then return end
    if _G.InvGuard and not _G.InvGuard.rateLimit(source, 'scan') then return end

    note = type(note) == 'string' and note:sub(1, 255) or nil

    -- Only the last known owner may report it stolen. Without this any
    -- player could brick any serial they happened to see in a screenshot
    -- by flagging it - griefing dressed up as a feature.
    MySQL.Async.fetchScalar([[
        SELECT to_ident FROM inv_weapon_history
        WHERE serial = @s ORDER BY id DESC LIMIT 1
    ]], { ['@s'] = serial }, function(lastOwner)
        local me = GetPlayerLicense(xPlayer)
        if lastOwner ~= nil and lastOwner ~= me then
            showNotification(xPlayer, Locales[Config.Language]['stolen_not_owner'] or 'You are not the registered owner of that serial.', 'error')
            return
        end

        MySQL.Async.execute([[
            INSERT INTO inv_stolen_weapons (serial, weapon, reported_by, reported_name, note, status)
            VALUES (@s, @w, @by, @bn, @note, 'stolen')
            ON DUPLICATE KEY UPDATE status = 'stolen', note = @note,
                reported_by = @by, reported_name = @bn, reported_at = NOW(),
                resolved_at = NULL, resolved_by = NULL
        ]], {
            ['@s'] = serial, ['@w'] = tostring(weapon or '?'),
            ['@by'] = me, ['@bn'] = nameOf(xPlayer), ['@note'] = note
        }, function()
            showNotification(xPlayer, (Locales[Config.Language]['stolen_reported'] or 'Serial #%s reported stolen.'):format(serial), 'success')
        end)
    end)
end)

--- Police clearing / recovering a report.
RegisterNetEvent('esx_inventory:resolveStolenWeapon')
AddEventHandler('esx_inventory:resolveStolenWeapon', function(serial, status)
    local source = source
    local xPlayer = GetPlayerFromId(source)
    if not xPlayer or type(serial) ~= 'string' then return end
    if not isPoliceJob(jobNameOf(xPlayer)) then return end
    if status ~= 'recovered' and status ~= 'cleared' then return end

    MySQL.Async.execute([[
        UPDATE inv_stolen_weapons
        SET status = @st, resolved_at = NOW(), resolved_by = @by
        WHERE serial = @s
    ]], { ['@st'] = status, ['@by'] = GetPlayerLicense(xPlayer), ['@s'] = serial })

    showNotification(xPlayer, (Locales[Config.Language]['stolen_resolved'] or 'Serial #%s marked %s.'):format(serial, status), 'success')
end)

--- Open list for a police MDT / panel.
RegisterServerCallback('esx_inventory:getStolenList', function(source, cb)
    local xPlayer = GetPlayerFromId(source)
    if not xPlayer or not isPoliceJob(jobNameOf(xPlayer)) then return cb({}) end

    MySQL.Async.fetchAll([[
        SELECT serial, weapon, reported_name, note, reported_at
        FROM inv_stolen_weapons WHERE status = 'stolen'
        ORDER BY reported_at DESC LIMIT 100
    ]], {}, function(rows) cb(rows or {}) end)
end)
