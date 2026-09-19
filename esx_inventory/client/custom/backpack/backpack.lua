--[[
    ================================================================
    #13 — VISIBLE BACKPACK ON THE CHARACTER MODEL
    #14 — POLICE SEARCH OF A WORN BACKPACK
    ================================================================

    ── Why a PROP and not a clothing component ──
    The obvious implementation is SetPedComponentVariation(ped, 5, ...)
    — GTA's own "bags" slot. It is also the wrong one here, for two
    reasons that only show up on a live server:

      * component 5 is already owned by the clothing system
        (Config.Clothes['bags'], esx_skin, the clothes shop). Writing to
        it from here would silently overwrite whatever the player bought,
        and taking the pack off would restore drawable 0 rather than
        their actual bag — i.e. the inventory would eat their clothing.
      * drawable ids for bags are per-ped-model. mp_m_freemode_01 and a
        story ped do not agree on what "drawable 45" is, so a single
        configured id looks correct on some characters and absurd on
        others.

    An attached prop has neither problem: it composes with whatever the
    player is wearing, it looks identical on every ped model, and taking
    it off is a DeleteEntity rather than a guess about what to restore.

    Props are local-only and re-attached from a server broadcast, so
    there is no networked-entity ownership to fight over.
]]

if Config.Framework ~= "esx" then
    return
end

--═════════════════════════════════════════════════════════════════════
-- #13 — prop config
--═════════════════════════════════════════════════════════════════════

-- bone 24818 = SKEL_Spine3 (upper back). Offsets are tuned for the
-- freemode skeleton; every ped shares that bone so they hold up.
Config.BackpackProps = Config.BackpackProps or {
    ['backpack']        = { model = 'prop_michael_backpack', pos = vector3(-0.16, -0.16, 0.00), rot = vector3(  0.0,  180.0,   0.0) },
    ['backpack_medium'] = { model = 'prop_cs_heist_bag_02',  pos = vector3(-0.18, -0.17, 0.00), rot = vector3(  0.0,  180.0,   0.0) },
    ['backpack_large']  = { model = 'prop_mil_crate_case',   pos = vector3(-0.20, -0.19, 0.00), rot = vector3(  0.0,  180.0,   0.0) },
}
Config.BackpackBone = Config.BackpackBone or 24818

local wornProps = {}   -- [serverId] = { entity = handle, name = itemName }

local function loadModel(model)
    local hash = GetHashKey(model)
    if not IsModelValid(hash) then return nil end
    local tries = 0
    while not HasModelLoaded(hash) and tries < 200 do
        RequestModel(hash)
        Wait(0)
        tries = tries + 1
    end
    if not HasModelLoaded(hash) then return nil end
    return hash
end

local function detachProp(serverId)
    local worn = wornProps[serverId]
    if not worn then return end
    if worn.entity and DoesEntityExist(worn.entity) then
        DeleteEntity(worn.entity)
    end
    wornProps[serverId] = nil
end

local function attachProp(serverId, itemName)
    detachProp(serverId)
    if not itemName then return end

    local cfg = Config.BackpackProps[itemName]
    if not cfg then return end

    local playerIdx = GetPlayerFromServerId(serverId)
    if playerIdx == -1 then return end            -- not streamed in for us
    local ped = GetPlayerPed(playerIdx)
    if not ped or ped == 0 or not DoesEntityExist(ped) then return end

    local hash = loadModel(cfg.model)
    if not hash then return end

    local obj = CreateObject(hash, 0.0, 0.0, 0.0, false, false, false)
    AttachEntityToEntity(
        obj, ped, GetPedBoneIndex(ped, Config.BackpackBone),
        cfg.pos.x, cfg.pos.y, cfg.pos.z,
        cfg.rot.x, cfg.rot.y, cfg.rot.z,
        true, true, false, true, 1, true
    )
    SetModelAsNoLongerNeeded(hash)

    wornProps[serverId] = { entity = obj, name = itemName }
end

RegisterNetEvent('esx_inventory:syncBackpackProp')
AddEventHandler('esx_inventory:syncBackpackProp', function(serverId, itemName)
    -- Remember the intent even if the ped isn't streamed in right now;
    -- the reconcile loop below picks it up once they come into range.
    if not itemName then
        detachProp(serverId)
        wornProps[serverId] = nil
        return
    end
    wornProps[serverId] = wornProps[serverId] or {}
    wornProps[serverId].name = itemName
    attachProp(serverId, itemName)
end)

-- Re-attach loop. A prop attached to a ped dies with that ped's entity,
-- which happens on every stream-out, every respawn and every model
-- change - so "attach once on equip" only works until the first time
-- someone walks away and back.
CreateThread(function()
    Wait(2000)
    TriggerServerEvent('esx_inventory:requestBackpackProps')

    while true do
        Wait(1500)
        for serverId, worn in pairs(wornProps) do
            if worn.name then
                local playerIdx = GetPlayerFromServerId(serverId)
                if playerIdx == -1 then
                    -- streamed out: drop the handle but keep the intent
                    if worn.entity and DoesEntityExist(worn.entity) then
                        DeleteEntity(worn.entity)
                    end
                    worn.entity = nil
                elseif not worn.entity or not DoesEntityExist(worn.entity) then
                    attachProp(serverId, worn.name)
                end
            end
        end
    end
end)

AddEventHandler('onResourceStop', function(resourceName)
    if resourceName ~= GetCurrentResourceName() then return end
    for serverId in pairs(wornProps) do detachProp(serverId) end
end)

--═════════════════════════════════════════════════════════════════════
-- #14 — police search
--
-- Separate command from /fouiller on purpose: a pack search is a
-- narrower action than a full body search, and keeping them separate is
-- what makes "carry it in your pockets instead" an actual decision.
--═════════════════════════════════════════════════════════════════════

RegisterCommand('searchbag', function()
    if Inv.isInInventory or Inv.isInTrunk or Inv.openInvPlayer or Inv.isInProperty then return end

    local closestPlayer, closestDistance = GetClosestPlayer()
    if closestPlayer == -1 or closestDistance > 2.5 then
        NotificationInInventory(Locales[Config.Language]['no_player'], 'error')
        return
    end

    TriggerServerCallback('esx_inventory:searchBackpack', function(result)
        -- nil = the server refused (not police / too far). It already
        -- notified; don't second-guess it with a second message.
        if not result then return end

        if not result.backpack then
            NotificationInInventory(Locales[Config.Language]['bag_none'] or 'This person is not wearing a backpack.', 'error')
            return
        end

        Inventaire:startAnimAction('mp_common', 'givetake2_a')

        SendNUIMessage({
            action  = 'open:BagSearch',
            label   = result.label,
            items   = result.items,
            empty   = Locales[Config.Language]['bag_empty'] or 'The backpack is empty.',
        })
        SetNuiFocus(true, true)
    end, GetPlayerServerId(closestPlayer))
end, false)

RegisterNUICallback('closeBagSearch', function(_, cb)
    SetNuiFocus(false, false)
    ClearPedTasks(PlayerPedId())
    if cb then cb('ok') end
end)
