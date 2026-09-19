-- ================================================================= --
-- Glovebox: a small, items-only storage separate from the trunk
-- (Config.WeightVehicle / VehCoffre in trunk.lua). Opened while seated
-- in a vehicle (driver or passenger) with the "glovebox" keybind
-- (Config.KeyBinds, default G). Reuses the same generic second-panel
-- NUI (open:Inv / trunk:WeightBarText / setSecondInventoryItems) the
-- trunk and property panels already use - see the "glovebox" branches
-- added to src/html/assets/js/inventory.js's two #left-inventory /
-- #right-inventory droppable handlers for the matching drop side.
-- ================================================================= --

local currentGlovebox = nil

local function setGloveboxInventoryData(plate)
    TriggerServerCallback("lgddddd:getGlovebox", function(data)
        if data == nil then return end

        local text = tostring(data.weight) .. " / " .. tostring(data.maxWeight) .. Locales[Config.Language]['weight_unity']
        SendNUIMessage({
            action = "trunk:WeightBarText",
            weightTrunk = tonumber(data.weight),
            maxWeightTrunk = tonumber(data.maxWeight),
            textTrunk = text,
            plate = (Locales[Config.Language]['glovebox_name'] or 'Glovebox - ') .. plate
        })

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
            action = "setSecondInventoryItems",
            itemList = list
        })
    end, plate)
end

local function RefreshGlovebox()
    if not currentGlovebox then return end
    setGloveboxInventoryData(currentGlovebox)
    loadPlayerInventory('glovebox', nil, true, true)
end

local function OpenGlovebox()
    if Inv.isInInventory or Inv.isInTrunk or Inv.isInProperty or Inv.openInvPlayer or Inv.isInGlovebox then
        return
    end

    local ped = PlayerPedId()
    if not IsPedInAnyVehicle(ped, false) then
        return
    end

    local vehicle = GetVehiclePedIsIn(ped, false)
    local plate = GetVehicleNumberPlateText(vehicle):gsub("^%s*(.-)%s*$", "%1")

    Inv.isInGlovebox = true
    currentGlovebox = plate

    DisplayRadar(false)
    SetNuiFocus(true, true)

    setGloveboxInventoryData(plate)
    loadPlayerInventory('glovebox', nil, true, true)

    SendNUIMessage({
        action = "open:Inv",
        type = "glovebox"
    })
end

local function CloseGlovebox()
    Inv.isInGlovebox = false
    currentGlovebox = nil

    DisplayRadar(true)
    SetNuiFocus(false, false)
    SendNUIMessage({ action = "close:Inv" })
end

RegisterCommand('glovebox', function()
    if not Inv.isInGlovebox then
        OpenGlovebox()
    else
        CloseGlovebox()
    end
end, false)

-- keybind itself is registered generically from Config.KeyBinds in
-- client/apps/system/slot.lua - no RegisterKeyMapping call needed here.

RegisterNUICallback("PutIntoGlovebox", function(data, cb)
    if not currentGlovebox or data.item.type ~= 'item_standard' then
        cb("ok")
        return
    end
    KeyboardUtils.use(Locales[Config.Language]['quantite'], function(result)
        if result ~= nil and tonumber(result) then
            TriggerServerEvent("lgd:actionGlovebox", currentGlovebox, "deposit", data.item.name, data.item.label, tonumber(result))
            Wait(150)
            RefreshGlovebox()
        end
    end)
    cb("ok")
end)

RegisterNUICallback("TakeFromGlovebox", function(data, cb)
    if not currentGlovebox or data.item.type ~= 'item_standard' then
        cb("ok")
        return
    end
    KeyboardUtils.use(Locales[Config.Language]['quantite'], function(result)
        if result ~= nil and tonumber(result) then
            TriggerServerEvent("lgd:actionGlovebox", currentGlovebox, "remove", data.item.name, data.item.label, tonumber(result))
            Wait(150)
            RefreshGlovebox()
        end
    end)
    cb("ok")
end)

-- If the vehicle is left (or the player gets out) while the glovebox is
-- open, close it out from under them instead of leaving a stuck-open
-- panel with no vehicle context behind it.
CreateThread(function()
    while true do
        Wait(500)
        if Inv.isInGlovebox then
            local ped = PlayerPedId()
            if not IsPedInAnyVehicle(ped, false) then
                CloseGlovebox()
            end
        end
    end
end)
