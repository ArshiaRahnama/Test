-- ================================================================= --
-- Timed NPC/world corpse looting (client side).
--
--   #9  reports the ped's model + type so the server can categorise it
--   #10 routes weapon loot through the weapon path, not AddItem
--   #11 glow on corpses that still have loot
--
-- Scans nearby dead, non-player peds and lets the player loot one
-- within range with the "lootbody" keybind (Config.KeyBinds, default
-- E). Reuses the same generic second-panel NUI as
-- trunk/property/glovebox, take-only (see the "corpse" branch in
-- inventory.js's #left-inventory droppable - there is deliberately no
-- matching #right-inventory/"main" branch, since you can't put things
-- INTO a corpse).
-- ================================================================= --

local currentCorpseNetId = nil
local currentCorpsePed = nil

-- #11 state: [netId] = {ped = entity, remaining = seconds|-1, seenAt = ms}
local lootableCorpses = {}

local function getClosestDeadPed()
    local ped = PlayerPedId()
    local coords = GetEntityCoords(ped)
    local closestPed, closestDist = nil, 2.5

    for _, entity in ipairs(GetGamePool('CPed')) do
        if entity ~= ped and DoesEntityExist(entity) and IsEntityDead(entity) and not IsPedAPlayer(entity) then
            local dist = #(coords - GetEntityCoords(entity))
            if dist < closestDist then
                closestDist = dist
                closestPed = entity
            end
        end
    end

    return closestPed
end

-- ================================================================= --
-- #9/#10 — the metadata the server needs to categorise this body.
--
-- GetEntityModel returns a hash, not a name, and there is no native to
-- turn a hash back into its string. Config.PedCategoryModels is keyed by
-- model NAME for readability, so the lookup table below is built once at
-- startup by hashing every configured name - then a dead ped's model
-- hash maps straight back to the configured name.
--
-- A ped whose model isn't in the config resolves to nil here, and the
-- server falls back to the ped-type hint. That's fine and expected;
-- there are ~700 ped models in GTA and the config only needs the ones
-- you care about.
-- ================================================================= --
local modelHashToName = {}

CreateThread(function()
    -- Wait for config (shared_scripts load before client scripts, but be
    -- defensive - a config typo shouldn't hard-error this whole file).
    while not Config or not Config.PedCategoryModels do Wait(250) end
    for name in pairs(Config.PedCategoryModels) do
        modelHashToName[GetHashKey(name)] = name
    end
end)

local function getPedMeta(ped)
    if not ped or not DoesEntityExist(ped) then return {} end

    local modelHash = GetEntityModel(ped)
    local weaponHash = GetSelectedPedWeapon(ped)
    local unarmed = GetHashKey('WEAPON_UNARMED')

    -- "Was it armed?" A dead ped keeps its selected weapon, so this is
    -- still meaningful after death. GetSelectedPedWeapon returns
    -- WEAPON_UNARMED (or 0) for an unarmed ped.
    local wasArmed = weaponHash ~= nil
        and weaponHash ~= 0
        and weaponHash ~= unarmed
        and weaponHash ~= -1569615261 -- WEAPON_UNARMED alt hash on some builds

    -- Resolve the held weapon back to a name the same way as the model.
    -- Only weapons the server's category tables actually reference need
    -- to resolve; anything else is sent as nil and the server just rolls
    -- randomly instead of preferring the held one.
    local heldWeapon = nil
    if wasArmed and Config.PedLootTables then
        for _, tbl in pairs(Config.PedLootTables) do
            for _, entry in ipairs(tbl.weapons or {}) do
                if GetHashKey(entry.name) == weaponHash then
                    heldWeapon = entry.name
                    break
                end
            end
            if heldWeapon then break end
        end
    end

    return {
        model      = modelHashToName[modelHash],
        pedType    = GetPedType(ped),
        wasArmed   = wasArmed,
        heldWeapon = heldWeapon,
    }
end

local function setCorpseInventoryData(netId, meta)
    TriggerServerCallback("esx_inventory:getCorpseLoot", function(data)
        if data == nil then return end

        if data.expired then
            NotificationInInventory(Locales[Config.Language]['corpse_expired'] or 'This body has nothing left to find.', 'error')
            CloseCorpseLoot()
            return
        end

        local list = {}
        for _, item in ipairs(data.items or {}) do
            -- #10: a weapon entry has to carry item_weapon so the NUI
            -- renders it as a weapon and TakeFromCorpse below knows to
            -- send kind='weapon' back.
            local isWeapon = item.kind == 'weapon'

            table.insert(list, {
                name = item.name,
                label = item.label,
                count = item.count,
                type = isWeapon and "item_weapon" or "item_standard",
                kind = item.kind,
                ammo = item.ammo,
                image = Config.Pictures[item.name],
                usable = false,
                rare = false,
                rank = Config.GetItemRank and Config.GetItemRank(item.name) or nil,
            })
        end

        SendNUIMessage({
            action = "trunk:WeightBarText",
            weightTrunk = 0,
            maxWeightTrunk = 0,
            textTrunk = Locales[Config.Language]['corpse_name'] or 'Body',
        })

        SendNUIMessage({
            action = "setSecondInventoryItems",
            itemList = list
        })
    end, netId, meta)
end

function OpenCorpseLoot()
    if Inv.isInInventory or Inv.isInTrunk or Inv.isInProperty or Inv.openInvPlayer or Inv.isInGlovebox or currentCorpseNetId then
        return
    end

    local corpsePed = getClosestDeadPed()
    if not corpsePed then
        NotificationInInventory(Locales[Config.Language]['no_possible'], 'error')
        return
    end

    currentCorpsePed = corpsePed
    currentCorpseNetId = NetworkGetNetworkIdFromEntity(corpsePed)

    DisplayRadar(false)
    SetNuiFocus(true, true)

    setCorpseInventoryData(currentCorpseNetId, getPedMeta(corpsePed))
    loadPlayerInventory('corpse', nil, true, true)

    SendNUIMessage({
        action = "open:Inv",
        type = "corpse",
        lootAnim = true
    })
end

function CloseCorpseLoot()
    currentCorpseNetId = nil
    currentCorpsePed = nil

    DisplayRadar(true)
    SetNuiFocus(false, false)
    SendNUIMessage({ action = "close:Inv" })
end

RegisterCommand('lootbody', function()
    if not currentCorpseNetId then
        OpenCorpseLoot()
    else
        CloseCorpseLoot()
    end
end, false)

RegisterNUICallback("TakeFromCorpse", function(data, cb)
    if not currentCorpseNetId then
        cb("ok")
        return
    end

    local item = data.item

    -- #10: weapons are one-per-entry, so there's no quantity to ask for -
    -- prompting "how many?" for a single pistol would be nonsense. Take
    -- it straight away.
    if item.kind == 'weapon' or item.type == 'item_weapon' then
        TriggerServerEvent("esx_inventory:lootCorpse", currentCorpseNetId, item.name, 1, 'weapon')
        Wait(150)
        if currentCorpseNetId then
            setCorpseInventoryData(currentCorpseNetId, getPedMeta(currentCorpsePed))
            loadPlayerInventory('corpse', nil, true, true)
        end
        cb("ok")
        return
    end

    if item.type ~= 'item_standard' then
        cb("ok")
        return
    end

    KeyboardUtils.use(Locales[Config.Language]['quantite'], function(result)
        if result ~= nil and tonumber(result) then
            local kind = (item.name == 'cash') and 'cash' or 'item'
            TriggerServerEvent("esx_inventory:lootCorpse", currentCorpseNetId, item.name, tonumber(result), kind)
            Wait(150)
            if currentCorpseNetId then
                setCorpseInventoryData(currentCorpseNetId, getPedMeta(currentCorpsePed))
                loadPlayerInventory('corpse', nil, true, true)
            end
        end
    end)
    cb("ok")
end)

-- close automatically if the player walks too far from the body they
-- were looting, rather than leaving the panel open pointed at nothing
CreateThread(function()
    while true do
        Wait(500)
        if currentCorpseNetId then
            if not currentCorpsePed or not DoesEntityExist(currentCorpsePed) then
                CloseCorpseLoot()
            else
                local dist = #(GetEntityCoords(PlayerPedId()) - GetEntityCoords(currentCorpsePed))
                if dist > 3.0 then
                    CloseCorpseLoot()
                end
            end
        end
    end
end)

-- ================================================================= --
-- #11 — GLOW ON UNLOOTED CORPSES
--
-- Two threads on purpose, because they run at very different rates:
--
--   * the SCAN thread (1/sec) walks the local ped pool, collects nearby
--     dead peds and asks the server which still have loot. Cheap enough
--     at 1Hz, far too expensive per-frame.
--   * the DRAW thread runs per-frame but only ever touches the small
--     result set the scan produced, and sleeps entirely when that set is
--     empty - so on a server with no corpses around it costs nothing.
--
-- This split is why the glow can be server-authoritative (it reflects
-- ACTUAL remaining loot, not a client guess) without being chatty.
-- ================================================================= --

local function glowCfg()
    return Config.CorpseGlow or {}
end

CreateThread(function()
    while true do
        local cfg = glowCfg()

        if not cfg.enabled then
            lootableCorpses = {}
            Wait(2000)
            goto continue
        end

        do
            local ped = PlayerPedId()
            local coords = GetEntityCoords(ped)
            local maxDist = cfg.drawDistance or 20.0

            local nearby, netIds = {}, {}
            for _, entity in ipairs(GetGamePool('CPed')) do
                if entity ~= ped
                   and DoesEntityExist(entity)
                   and IsEntityDead(entity)
                   and not IsPedAPlayer(entity) then
                    local d = #(coords - GetEntityCoords(entity))
                    if d <= maxDist then
                        local netId = NetworkGetNetworkIdFromEntity(entity)
                        if netId and netId ~= 0 then
                            nearby[netId] = entity
                            netIds[#netIds + 1] = netId
                            -- matches the server-side cap in
                            -- getLootableCorpses; no point sending more
                            if #netIds >= 64 then break end
                        end
                    end
                end
            end

            if #netIds > 0 then
                TriggerServerCallback("esx_inventory:getLootableCorpses", function(result)
                    local fresh = {}
                    for idStr, remaining in pairs(result or {}) do
                        local id = tonumber(idStr)
                        local entity = id and nearby[id]
                        if entity then
                            fresh[id] = { ped = entity, remaining = remaining }
                        end
                    end
                    lootableCorpses = fresh
                end, netIds)
            else
                lootableCorpses = {}
            end
        end

        Wait(1000)
        ::continue::
    end
end)

CreateThread(function()
    while true do
        local cfg = glowCfg()
        local sleep = 500

        if cfg.enabled and next(lootableCorpses) ~= nil then
            sleep = 0
            local style = cfg.style or 'marker'
            local m = cfg.marker or {}
            local mc = m.color or {}
            local oc = cfg.outlineColor or {}
            local playerCoords = GetEntityCoords(PlayerPedId())

            for netId, entry in pairs(lootableCorpses) do
                local entity = entry.ped
                if DoesEntityExist(entity) then
                    local c = GetEntityCoords(entity)
                    local dist = #(playerCoords - c)

                    if dist <= (cfg.drawDistance or 20.0) then
                        -- Fade out over the corpse's last seconds so
                        -- players see it expiring instead of it just
                        -- vanishing. remaining == -1 means "not rolled
                        -- yet" => full opacity.
                        local fade = 1.0
                        local fadeWindow = cfg.fadeOutSeconds or 30
                        if entry.remaining and entry.remaining >= 0 and entry.remaining < fadeWindow then
                            fade = entry.remaining / fadeWindow
                            if fade < 0.15 then fade = 0.15 end
                        end

                        if style == 'marker' or style == 'both' then
                            DrawMarker(
                                m.type or 27,
                                c.x, c.y, c.z + (m.heightOffset or 0.05),
                                0.0, 0.0, 0.0,
                                0.0, 0.0, 0.0,
                                m.scale or 0.55, m.scale or 0.55, m.scale or 0.55,
                                mc.r or 255, mc.g or 190, mc.b or 60,
                                math.floor((mc.a or 90) * fade),
                                m.bobUpAndDown or false,
                                false,   -- faceCamera
                                2,
                                m.rotate or false,
                                nil, nil, false
                            )
                        end

                        if style == 'outline' or style == 'both' then
                            SetEntityDrawOutline(entity, true)
                            SetEntityDrawOutlineColor(
                                oc.r or 255, oc.g or 190, oc.b or 60,
                                math.floor((oc.a or 180) * fade)
                            )
                        end
                    elseif style == 'outline' or style == 'both' then
                        SetEntityDrawOutline(entity, false)
                    end
                end
            end
        end

        Wait(sleep)
    end
end)

-- Clear outlines on resource stop, otherwise a restart leaves every
-- corpse permanently outlined until the ped despawns (the outline is a
-- persistent entity flag, not a per-frame draw like the marker is).
AddEventHandler('onResourceStop', function(resourceName)
    if resourceName ~= GetCurrentResourceName() then return end
    for _, entry in pairs(lootableCorpses) do
        if entry.ped and DoesEntityExist(entry.ped) then
            SetEntityDrawOutline(entry.ped, false)
        end
    end
end)
