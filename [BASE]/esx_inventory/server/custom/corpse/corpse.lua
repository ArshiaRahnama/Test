-------------------------------------------------------------------
-- Timed NPC/world corpse looting.
--
--   #9  loot tables per ped category (police / gang / army / medic /
--       business / homeless / civilian / security / animal)
--   #10 real weapon loot from armed peds
--
-- Not for dead players - looting those goes through the existing
-- /fouiller command (server/apps/system/loot.lua) and is untouched.
--
-- A corpse's loot is rolled ONCE, the first time any player requests it
-- (lazy init, same as property.lua/glovebox.lua), keyed by the ped's
-- network id so everyone looting the same body sees and depletes the
-- same contents. Expires Config.CorpseLootDuration seconds after that
-- first roll.
--
-- ── Trust model ──
-- Ped category and "was it armed" both originate from client natives
-- (GetPedType / the ped's model / the ped's current weapon), because the
-- server has no direct native for a ped it doesn't own. The client is
-- therefore the only possible source - but it is never blindly trusted:
--
--   * The category is resolved from the reported MODEL first, against a
--     server-side table. A client claiming "this tramp is an army ped"
--     has to name an actual army model to get army loot.
--   * A reported held-weapon is only honoured if that exact weapon is in
--     the resolved category's own weapon list. So the worst a spoofing
--     client can do is pick WHICH of the weapons that category could
--     already legitimately drop it gets - it cannot invent one.
--   * The roll happens once, server-side, and is cached. Re-requesting
--     with different claimed values does not re-roll.
--   * Every weapon that comes off a corpse is rate-limited and logged.
-------------------------------------------------------------------

local Corpses = {} -- [netId] = { items=, cash=, weapons=, expiresAt=, category= }

--═════════════════════════════════════════════════════════════════════════
-- #9 — Category resolution (server-authoritative)
--═════════════════════════════════════════════════════════════════════════

local function resolveCategory(modelName, reportedPedType)
    if not Config.UsePedCategories then
        return nil -- caller falls back to the flat legacy table
    end

    -- 1. explicit model match (most specific, fully server-side)
    if modelName and Config.PedCategoryModels then
        local key = tostring(modelName):lower()
        local byModel = Config.PedCategoryModels[key]
        if byModel then return byModel, 'model' end
    end

    -- 2. ped type. This one genuinely originates client-side, so it's
    --    treated as a hint: it can only select from the fixed
    --    Config.PedCategoryByType map, never name a category directly.
    local pedType = tonumber(reportedPedType)
    if pedType and Config.PedCategoryByType then
        local byType = Config.PedCategoryByType[pedType]
        if byType then return byType, 'type' end
    end

    return Config.DefaultPedCategory or 'civilian', 'default'
end

--═════════════════════════════════════════════════════════════════════════
-- Rolling
--═════════════════════════════════════════════════════════════════════════

local function rollCash(tbl)
    local c = tbl and tbl.cash
    if not c then return 0 end
    if math.random(100) > (c.chance or 0) then return 0 end
    return math.random(c.min or 0, c.max or 0)
end

local function shuffledIndices(list)
    -- Fisher-Yates over a copy of the indices. The config table itself is
    -- never mutated. Matters because maxItemRolls caps the result, and
    -- without a shuffle the entries listed first in the config would
    -- always be the ones that win the cap.
    local order = {}
    for i = 1, #list do order[i] = i end
    for i = #order, 2, -1 do
        local j = math.random(i)
        order[i], order[j] = order[j], order[i]
    end
    return order
end

local function rollItems(tbl)
    local out = {}
    if not tbl or not tbl.items then return out end

    local rolls, cap = 0, tbl.maxItemRolls

    for _, idx in ipairs(shuffledIndices(tbl.items)) do
        if cap and rolls >= cap then break end
        local entry = tbl.items[idx]
        if entry and entry.name and math.random(100) <= (entry.chance or 100) then
            local weight = (ESX and ESX.getItemWeight and ESX.getItemWeight(entry.name)) or 0
            out[entry.name] = {
                label = entry.label or entry.name,
                count = math.random(entry.min or 1, entry.max or 1),
                weight = weight,
            }
            rolls = rolls + 1
        end
    end

    return out
end

--═════════════════════════════════════════════════════════════════════════
-- #10 — Weapon rolling
--═════════════════════════════════════════════════════════════════════════

-- Is `weaponName` something this category is allowed to drop? This is the
-- gate that makes a spoofed held-weapon report harmless.
local function categoryAllowsWeapon(tbl, weaponName)
    if not tbl or not tbl.weapons or not weaponName then return nil end
    local upper = tostring(weaponName):upper()
    for _, entry in ipairs(tbl.weapons) do
        if tostring(entry.name):upper() == upper then
            return entry
        end
    end
    return nil
end

local function rollWeapons(tbl, heldWeaponName, wasArmed)
    local cfg = Config.CorpseWeapons or {}
    if not cfg.enabled then return {} end
    if not tbl or not tbl.weapons or #tbl.weapons == 0 then return {} end

    -- "Only armed peds drop weapons." Without this, unarmed pedestrians
    -- spawn guns out of nowhere, which is the single fastest way to
    -- flood a server's weapon economy.
    if cfg.requireArmed and not wasArmed then
        return {}
    end

    local out = {}
    local maxCount = cfg.maxPerCorpse or 1

    -- Preferred path: the ped actually had this weapon in hand, and the
    -- category legitimately drops it.
    if cfg.preferHeldWeapon and heldWeaponName then
        local entry = categoryAllowsWeapon(tbl, heldWeaponName)
        if entry then
            local ammo = entry.ammo or {}
            out[#out + 1] = {
                name = tostring(entry.name):upper(),
                ammo = math.random(ammo.min or 1, ammo.max or 1),
            }
        end
    end

    -- Fill any remaining slots with independent chance rolls.
    if #out < maxCount then
        for _, idx in ipairs(shuffledIndices(tbl.weapons)) do
            if #out >= maxCount then break end
            local entry = tbl.weapons[idx]
            local upper = tostring(entry.name):upper()

            local already = false
            for _, w in ipairs(out) do
                if w.name == upper then already = true break end
            end

            if not already and math.random(100) <= (entry.chance or 0) then
                local ammo = entry.ammo or {}
                out[#out + 1] = {
                    name = upper,
                    ammo = math.random(ammo.min or 1, ammo.max or 1),
                }
            end
        end
    end

    -- Trim in case preferHeldWeapon pushed us over the cap.
    while #out > maxCount do table.remove(out) end

    return out
end

--═════════════════════════════════════════════════════════════════════════
-- Corpse lifecycle
--═════════════════════════════════════════════════════════════════════════

local function rollLegacy()
    -- Backwards-compatible path: the old flat Config.NPCLootTable, used
    -- when Config.UsePedCategories is off. Unchanged behaviour.
    local items, cash = {}, 0
    for _, entry in ipairs(Config.NPCLootTable or {}) do
        if math.random(100) <= (entry.chance or 100) then
            if entry.type == 'cash' then
                cash = cash + math.random(entry.min or 0, entry.max or 0)
            elseif entry.type == 'item' and entry.name then
                local weight = (ESX and ESX.getItemWeight and ESX.getItemWeight(entry.name)) or 0
                items[entry.name] = {
                    label = entry.label or entry.name,
                    count = math.random(entry.min or 1, entry.max or 1),
                    weight = weight,
                }
            end
        end
    end
    return items, cash
end

local function getOrCreateCorpse(netId, meta)
    local corpse = Corpses[netId]
    if corpse then return corpse end

    meta = meta or {}
    local category, how = resolveCategory(meta.model, meta.pedType)

    local items, cash, weapons

    if category then
        local tbl = (Config.PedLootTables or {})[category]
        if not tbl then
            -- Category resolved to something with no table configured -
            -- fall back rather than silently giving nothing.
            tbl = (Config.PedLootTables or {})[Config.DefaultPedCategory or 'civilian']
        end
        cash    = rollCash(tbl)
        items   = rollItems(tbl)
        weapons = rollWeapons(tbl, meta.heldWeapon, meta.wasArmed)
    else
        items, cash = rollLegacy()
        weapons = {}
    end

    corpse = {
        items = items,
        cash = cash,
        weapons = weapons,
        category = category,
        expiresAt = os.time() + (Config.CorpseLootDuration or 300),
    }
    Corpses[netId] = corpse

    if Config.Debug and debugprint then
        debugprint(('corpse %s categorised as %s (via %s): %d cash, %d weapon(s)')
            :format(tostring(netId), tostring(category), tostring(how), cash, #weapons))
    end

    return corpse
end

RegisterServerCallback("esx_inventory:getCorpseLoot", function(source, cb, netId, meta)
    netId = tonumber(netId)
    if not netId then
        cb(nil)
        return
    end

    -- #18: reuse the shared guard rather than a bespoke limiter here.
    if _G.InvGuard and not _G.InvGuard.rateLimit(source, 'loot') then
        cb(nil)
        return
    end

    local corpse = getOrCreateCorpse(netId, meta)
    if os.time() > corpse.expiresAt then
        cb({ expired = true })
        return
    end

    local items = {}
    for name, entry in pairs(corpse.items) do
        table.insert(items, { name = name, label = entry.label, count = entry.count, kind = 'item' })
    end

    -- #10: weapons are sent as their own kind so the NUI can render them
    -- with the weapon icon/rank rather than as a generic item, and so
    -- TakeFromCorpse knows to route them through addWeapon instead of
    -- AddItem.
    for i, w in ipairs(corpse.weapons) do
        table.insert(items, {
            name  = w.name,
            label = (GetItemLabel and GetItemLabel(w.name)) or w.name,
            count = 1,
            kind  = 'weapon',
            ammo  = w.ammo,
            idx   = i,
        })
    end

    if corpse.cash > 0 then
        table.insert(items, {
            name = 'cash',
            label = Locales[Config.Language]['cash_label'] or 'Cash',
            count = corpse.cash,
            kind = 'cash',
        })
    end

    cb({ expired = false, items = items, category = corpse.category })
end)

RegisterNetEvent("esx_inventory:lootCorpse")
AddEventHandler("esx_inventory:lootCorpse", function(netId, name, count, kind)
    local source = source
    local xPlayer = GetPlayerFromId(source)
    netId = tonumber(netId)
    count = tonumber(count) or 0
    if not xPlayer or not netId or type(name) ~= 'string' then return end

    if _G.InvGuard and not _G.InvGuard.rateLimit(source, 'loot') then return end

    local corpse = Corpses[netId]
    if not corpse or os.time() > corpse.expiresAt then return end

    -- Distance re-check. The client closes its panel at 3m, but that's a
    -- UI convenience - this is the actual enforcement, same reasoning as
    -- the drop pickup check in server/custom/drop/drop.lua.
    local ped = GetPlayerPed(source)
    local corpsePed = NetworkGetEntityFromNetworkId(netId)
    if ped and corpsePed and ped ~= 0 and corpsePed ~= 0 and DoesEntityExist(corpsePed) then
        local d = #(GetEntityCoords(ped) - GetEntityCoords(corpsePed))
        if d > 5.0 then
            if _G.InvGuard then
                _G.InvGuard.addAnomalyScore(source, 30, ('looted a corpse from %.1fm'):format(d))
            end
            return
        end
    end

    --── cash ──────────────────────────────────────────────────────────
    if kind == 'cash' or name == 'cash' then
        count = math.min(count, corpse.cash)
        if count <= 0 then return end
        corpse.cash = corpse.cash - count
        xPlayer.addMoney(count)
        return
    end

    --── #10 weapons ───────────────────────────────────────────────────
    if kind == 'weapon' then
        local found, foundIdx
        for i, w in ipairs(corpse.weapons) do
            if w.name == tostring(name):upper() then
                found, foundIdx = w, i
                break
            end
        end
        if not found then return end

        -- Remove from the corpse BEFORE granting. If addWeapon somehow
        -- fails the player just doesn't get it; the reverse order would
        -- let two near-simultaneous requests both pass the lookup and
        -- both grant - the same dupe shape guard.lua exists to stop.
        table.remove(corpse.weapons, foundIdx)

        local cfg = Config.CorpseWeapons or {}
        local serial = (ESX and ESX.GenerateWeaponSerial)
            and ESX.GenerateWeaponSerial(cfg.serialPrefix or 'STRT')
            or nil

        addWeapon(xPlayer, found.name, found.ammo or 1, serial)

        showNotification(xPlayer,
            (Locales[Config.Language]['corpse_weapon_taken'] or 'You took a %s off the body.')
                :format((GetItemLabel and GetItemLabel(found.name)) or found.name),
            'success')

        -- Logged: an untraceable weapon entering circulation is exactly
        -- what the chain-of-custody feature (#7) needs to see.
        if sendToDiscordWithSpecialURL and webhooks and webhooks['giveItem'] then
            sendToDiscordWithSpecialURL(
                "🔫 Corpse weapon loot",
                ("\n\n``🔢``ID : ``[%s] %s``\n``💿``Licence: ``%s``\n``💬``Weapon: ``%s (%s ammo)``\n``🔖``Serial: ``%s``\n``🧍``Category: ``%s``")
                    :format(source, xPlayer.getName(), GetPlayerLicense(xPlayer),
                            found.name, tostring(found.ammo), tostring(serial), tostring(corpse.category)),
                webhooks['giveItem'].color,
                webhooks['giveItem'].webhook
            )
        end
        return
    end

    --── standard items ────────────────────────────────────────────────
    if count <= 0 then return end

    local entry = corpse.items[name]
    if not entry then return end
    count = math.min(count, entry.count)
    if count <= 0 then return end

    if not getWeight(xPlayer, name, count) then
        showNotification(xPlayer, Locales[Config.Language]['trunk_weight_player_max'], 'error')
        return
    end

    entry.count = entry.count - count
    if entry.count <= 0 then corpse.items[name] = nil end
    AddItem(xPlayer, name, count)
end)

--═════════════════════════════════════════════════════════════════════════
-- #11 — tell clients which corpses still have loot, for the glow
--
-- The client cannot know whether a body is worth glowing without asking,
-- and having every client poll per ped would be far too chatty. Instead
-- the server answers one batched question: "of these net ids near me,
-- which are still lootable?"
--═════════════════════════════════════════════════════════════════════════

RegisterServerCallback("esx_inventory:getLootableCorpses", function(source, cb, netIds)
    if type(netIds) ~= 'table' then
        cb({})
        return
    end

    local now = os.time()
    local out = {}
    local scanned = 0

    for _, id in ipairs(netIds) do
        -- Hard cap: a client could otherwise send a huge list and make
        -- the server walk it every second.
        scanned = scanned + 1
        if scanned > 64 then break end

        id = tonumber(id)
        if id then
            local corpse = Corpses[id]
            if corpse then
                -- Already rolled: lootable only if something is left AND
                -- it hasn't expired.
                local hasLoot = corpse.cash > 0
                    or next(corpse.items) ~= nil
                    or #corpse.weapons > 0
                if hasLoot and now <= corpse.expiresAt then
                    out[tostring(id)] = corpse.expiresAt - now
                end
            else
                -- Never looted by anyone yet. Deliberately NOT rolled
                -- here - rolling on a glow query would let a client
                -- force-roll every corpse on the map just by walking
                -- past, and would start the expiry countdown on bodies
                -- nobody has touched. Reported as lootable with an
                -- unknown remaining time (-1); it rolls for real on the
                -- first actual open.
                out[tostring(id)] = -1
            end
        end
    end

    cb(out)
end)

-- Periodic cleanup so long-running servers don't accumulate looted-out /
-- expired corpses in memory forever.
CreateThread(function()
    while true do
        Wait(5 * 60000)
        local now = os.time()
        for netId, corpse in pairs(Corpses) do
            if now > corpse.expiresAt + 600 then
                Corpses[netId] = nil
            end
        end
    end
end)
