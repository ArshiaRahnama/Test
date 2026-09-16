-- ================================================================= --
-- Timed NPC/world corpse looting. Scans nearby dead, non-player peds
-- and lets the player loot one within range with the "lootbody"
-- keybind (Config.KeyBinds, default H). Reuses the same generic
-- second-panel NUI as trunk/property/glovebox, take-only (see the
-- "corpse" branch added to inventory.js's #left-inventory droppable -
-- there's deliberately no matching #right-inventory/"main" branch,
-- since you can't put things INTO a corpse).
-- ================================================================= --

local currentCorpseNetId = nil
local currentCorpsePed = nil

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

local function setCorpseInventoryData(netId)
    TriggerServerCallback("esx_inventory:getCorpseLoot", function(data)
        if data == nil then return end

        if data.expired then
            NotificationInInventory(Locales[Config.Language]['corpse_expired'] or 'This body has nothing left to find.', 'error')
            CloseCorpseLoot()
            return
        end

        local list = {}
        for _, item in ipairs(data.items or {}) do
            table.insert(list, {
                name = item.name,
                label = item.label,
                count = item.count,
                type = "item_standard",
                image = Config.Pictures[item.name],
                usable = false,
                rare = false,
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
    end, netId)
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

    setCorpseInventoryData(currentCorpseNetId)
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
    if not currentCorpseNetId or data.item.type ~= 'item_standard' then
        cb("ok")
        return
    end
    KeyboardUtils.use(Locales[Config.Language]['quantite'], function(result)
        if result ~= nil and tonumber(result) then
            TriggerServerEvent("esx_inventory:lootCorpse", currentCorpseNetId, data.item.name, tonumber(result))
            Wait(150)
            if currentCorpseNetId then
                setCorpseInventoryData(currentCorpseNetId)
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
