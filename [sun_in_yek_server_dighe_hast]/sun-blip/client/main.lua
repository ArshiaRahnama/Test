-- Pub by FleeX Team , https://discord.gg/87rGBxgCsa

ESX = nil
Citizen.CreateThread(function()
    while ESX == nil do
        TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
        Citizen.Wait(0)
    end
    Citizen.Wait(5000)
    init()
end)

local isMapActive = false

playerBlips = {}

local hiddenBlipsKvp = "hiddenBlip-" ..GetConvarInt('serverNum',0)
local localBlipsKvp = "localBlip-" ..GetConvarInt('serverNum',0)

local hiddenBlips = json.decode(GetResourceKvpString(hiddenBlipsKvp)) or {}
local localBlips = json.decode(GetResourceKvpString(localBlipsKvp)) or {}
local globalsCallback = nil
local activatedNuiAdmin = false
local isAdmin = false

function saveBlip(blipId)
    if playerBlips[blipId].isLocal or not isAdmin then
        localBlips[blipId] = playerBlips[blipId]
        localBlips[blipId].isLocal = true
        SetResourceKvp(localBlipsKvp, json.encode(localBlips))
    else
        TriggerServerEvent('blips_creator:saveBlip', blipId, playerBlips[blipId])
    end
end

function hideBlip(blipId)
    local blip = playerBlips[blipId].blip

    SetBlipAlpha(blip, 0.0)
    SetBlipDisplay(blip, 0)
    SetBlipHiddenOnLegend(blip, true)

    playerBlips[blipId].isHidden = true

    hiddenBlips[blipId] = true

    SetResourceKvp(hiddenBlipsKvp, json.encode(hiddenBlips))
end

function showBlip(blipId)
    local blip = playerBlips[blipId].blip

    SetBlipAlpha(blip, playerBlips[blipId].alpha)
    SetBlipDisplay(blip, playerBlips[blipId].display)
    SetBlipHiddenOnLegend(blip, false)

    playerBlips[blipId].isHidden = false

    hiddenBlips[blipId] = false
    SetResourceKvp(hiddenBlipsKvp, json.encode(hiddenBlips))
end

local function blipFromWaypoint()
    local wBlip = GetFirstBlipInfoId(8)
    local wBlipCoords = GetBlipCoords(wBlip)
    local newBlip = AddBlipForCoord(wBlipCoords)

    SetWaypointOff()

    return newBlip
end

AddEventHandler('KeyDown2:home',function()
    if (IsPauseMenuActive()) then
        SendNUIMessage({
            action = "mapActive"
        })
        if(not activatedNuiAdmin and isAdmin) then
            activatedNuiAdmin = true
            SendNUIMessage({
                action = "activateAdmin",
            })
        end

        SendNUIMessage({
            action = "openBlipsMenu",
        })
        SetNuiFocus(true, true)
        while IsPauseMenuActive() do
            Citizen.Wait(100)
        end
    
        SendNUIMessage({
            action = "mapClosed"
        })
    end
end)

function exit()
    SetNuiFocus(false, false)
end

function focus()
    SetNuiFocus(true, true)
end

function setCustomBlipName(blipId, text)
    debugPrint("Set blip name")
    blipId = tonumber(blipId)

    if (text) then
        playerBlips[blipId].name = text

        AddTextEntry('blipname', text)

        BeginTextCommandSetBlipName("blipname")
        EndTextCommandSetBlipName(playerBlips[blipId].blip)
    end
end

function setCustomBlipColor(blipId, color)
    debugPrint("Set blip color")
    blipId = tonumber(blipId)
    color = tonumber(color)

    if (color) then
        SetBlipColour(playerBlips[blipId].blip, color)
        playerBlips[blipId].color = color
    end
end

function setCustomBlipAlpha(blipId, alpha)
    debugPrint("Set blip alpha")

    blipId = tonumber(blipId)
    alpha = tonumber(alpha)

    if (alpha) then
        SetBlipAlpha(playerBlips[blipId].blip, alpha)
        playerBlips[blipId].alpha = alpha
    end
end

function setCustomBlipScale(blipId, scale)
    debugPrint("Set blip scale")
    
    blipId = tonumber(blipId)
    scale = tonumber(scale) + .0
    if (scale) then
        SetBlipScale(playerBlips[blipId].blip, scale)
        playerBlips[blipId].scale = scale
    end
end

function setCustomBlipSprite(blipId, sprite)
    debugPrint("Set blip sprite")

    blipId = tonumber(blipId)
    sprite = tonumber(sprite)
    if (sprite) then
        local color = playerBlips[blipId].color
        SetBlipSprite(playerBlips[blipId].blip, sprite)
        setCustomBlipName(blipId, playerBlips[blipId].name)
        SetBlipColour(playerBlips[blipId].blip, color)
        playerBlips[blipId].sprite = sprite
    end
end

function setCustomBlipTick(blipId, isTicked)
    debugPrint("Set blip tick")

    blipId = tonumber(blipId)

    ShowTickOnBlip(playerBlips[blipId].blip, isTicked)
    playerBlips[blipId].ticked = isTicked
end

function setCustomBlipOutline(blipId, isOutlined)
    debugPrint("Set blip outline")

    blipId = tonumber(blipId)

    ShowOutlineIndicatorOnBlip(playerBlips[blipId].blip, isOutlined)

    playerBlips[blipId].outline = isOutlined
end

function setCustomBlipDisplay(blipId, display)
    debugPrint("Set blip display")

    blipId = tonumber(blipId)

    if (display) then
        SetBlipDisplay(playerBlips[blipId].blip, display)
        playerBlips[blipId].display = display
    end
end

function createBlip(cb)
    debugPrint("creating a blip")

    SetCursorLocation(0.50, 0.50)

    local blipCreated = false

    while not blipCreated do
        SetCursorSprite(11)

        if (IsWaypointActive()) then
            blipCreated = true
            local blip = blipFromWaypoint()

            local blipCoords = GetBlipCoords(blip)
            local inwater , waterheight = GetWaterHeight(
                ESX.Math.Round(blipCoords.x, 1),
                ESX.Math.Round(blipCoords.y, 1),
                ESX.Math.Round(150.0, 1)
            )
            if inwater then
                RemoveBlip(blip)    
                return 
            end
            local blipSprite = GetBlipSprite(blip)
            local blipColor = GetBlipColour(blip)
            local streetNameHash = GetStreetNameAtCoord(blipCoords.x, blipCoords.y, blipCoords.z)

            local blipData = {
                x = blipCoords.x,
                y = blipCoords.y,
                z = blipCoords.z,
                streetName = GetStreetNameFromHashKey(streetNameHash),
                sprite = blipSprite,
                name = "New Blip",
                scale = 1.0,
                alpha = 255,
                color = blipColor,
                ticked = false,
                outline = false,
                display = 3,
                id = math.random(10000,1000000),
                isLocal = true,
            }

            RemoveBlip(blip)

            localBlips[blipData.id] = blipData
            SetResourceKvp(localBlipsKvp, json.encode(localBlips))
            refreshBlips()
            Citizen.Wait(1000)
        end

        Citizen.Wait(0)
    end

    cb(true)
end

function createBlipFromCoords(x, y, cb)
    debugPrint("creating blip from coords")
    

    x = tonumber(x) + 0.0
    y = tonumber(y) + 0.0
    local inwater , waterheight = GetWaterHeight(
        ESX.Math.Round(x, 1),
        ESX.Math.Round(y, 1),
        ESX.Math.Round(150.0, 1)
    )
    if inwater then 
        RemoveBlip(blip) 
        return 
    end
    local blip = AddBlipForCoord(x, y, 0.0)

    local blipCoords = GetBlipCoords(blip)
    local blipSprite = GetBlipSprite(blip)
    local blipColor = GetBlipColour(blip)
    local streetNameHash = GetStreetNameAtCoord(blipCoords.x, blipCoords.y, blipCoords.z)

    local blipData = {
        x = blipCoords.x,
        y = blipCoords.y,
        z = blipCoords.z,
        streetName = GetStreetNameFromHashKey(streetNameHash),
        sprite = blipSprite,
        name = "New Blip",
        scale = 1.0,
        alpha = 255,
        color = blipColor,
        ticked = false,
        outline = false,
        id = math.random(10000,1000000),
        isLocal = true,
        display = 3
    }

    RemoveBlip(blip)

    localBlips[blipData.id] = blipData
    SetResourceKvp(localBlipsKvp, json.encode(localBlips))
    refreshBlips()

    Citizen.Wait(1000)

    cb(true)
end

function createGlobalBlipFromCoords(x, y, cb)
    debugPrint("Creating global blip form coords")

    x = tonumber(x) + 0.0
    y = tonumber(y) + 0.0

    local blip = AddBlipForCoord(x, y, 0.0)

    local streetNameHash = GetStreetNameAtCoord(x, y, 0.0)

    local blipData = {
        x = x,
        y = y,
        z = 0.0,
        streetName = GetStreetNameFromHashKey(streetNameHash),
        sprite = 1,
        name = "New Blip",
        scale = 1.0,
        alpha = 255,
        color = 0,
        ticked = false,
        outline = false,
        display = 3,
        isGlobal = true
    }

    SetBlipAsShortRange(blip, true)
    
    RemoveBlip(blip)

    TriggerServerEvent('blips_creator:createGlobalBlip', blipData)

    Citizen.Wait(1000)

    cb(true)
end

function createGlobalBlip(cb)
    debugPrint("Creating global blip")

    SetCursorLocation(0.50, 0.50)

    local blipCreated = false

    while not blipCreated do
        SetCursorSprite(11)

        if (IsWaypointActive()) then
            blipCreated = true
            local blip = blipFromWaypoint()

            local blipCoords = GetBlipCoords(blip)
            local blipSprite = GetBlipSprite(blip)
            local blipColor = GetBlipColour(blip)
            local streetNameHash = GetStreetNameAtCoord(blipCoords.x, blipCoords.y, blipCoords.z)

            local blipData = { 
                x = blipCoords.x,
                y = blipCoords.y,
                z = blipCoords.z,
                streetName = GetStreetNameFromHashKey(streetNameHash),
                sprite = blipSprite,
                name = "New Blip",
                scale = 1.0,
                alpha = 255,
                color = blipColor,
                ticked = false,
                outline = false,
                display = 3,
                isGlobal = true
            }

            TriggerServerEvent('blips_creator:createGlobalBlip', blipData)

            RemoveBlip(blip)

            Citizen.Wait(1000)

            cb({})
        end

        Citizen.Wait(0)
    end
end

function deleteBlip(blipId)
    debugPrint("Deleting a blip")

    blipId = tonumber(blipId)

    if (DoesBlipExist(playerBlips[blipId].blip)) then
        RemoveBlip(playerBlips[blipId].blip)
    end
    if playerBlips[blipId] and playerBlips[blipId].isLocal then
        localBlips[blipId] = nil
        localBlips[tostring(blipId)] = nil
        SetResourceKvp(localBlipsKvp, json.encode(localBlips))
    else
        TriggerServerEvent('blips_creator:deleteBlip', blipId)
    end
    playerBlips[blipId] = nil
end

function shareBlipToPlayerId(playerId, blipId)
    debugPrint("Sharing a blip")

    blipId = tonumber(blipId)
    if ESX.Game.PlayerExist(playerId) then
        local distance = GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()), GetEntityCoords(GetPlayerPed(GetPlayerFromServerId(playerId))), true)
        if distance < 10 then
            ESX.TriggerServerEvent('blips_creator:shareBlipToPlayerId', playerId, playerBlips[blipId])
        else
            ESX.Alert('Error', 'Shoma az fard mored nazar fasele darid!', 5000,'error')
        end
    else
        ESX.Alert('Error', 'Shoma az fard mored nazar fasele darid!', 5000,'error')
    end
end

local function addBlips()
    debugPrint("Adding all blips")

    for blipId, blipData in pairs(playerBlips) do
        local blip = AddBlipForCoord(blipData.x + .0, blipData.y + .0, blipData.z + .0)

        playerBlips[blipId].blip = blip

        SetBlipAlpha(blip, blipData.alpha)
        SetBlipScale(blip, blipData.scale + .0)
        SetBlipSprite(blip, blipData.sprite)
        SetBlipColour(blip, blipData.color)
        ShowTickOnBlip(blip, blipData.ticked)
        ShowOutlineIndicatorOnBlip(blip, blipData.outline)
        SetBlipDisplay(blip, blipData.display)
        SetBlipAsShortRange(blip, true)

        AddTextEntry('blipname', blipData.name)

        BeginTextCommandSetBlipName("blipname")
        EndTextCommandSetBlipName(blip)

        if(hiddenBlips[blipId]) then
            hideBlip(blipId)
        end
    end
end

function refreshBlips(data)
    debugPrint("Refreshing blips")

    for blipId, blipData in pairs(playerBlips) do
        if (DoesBlipExist(blipData.blip)) then
            RemoveBlip(blipData.blip)
        end
    end
    
    playerBlips = {}
    if data then
        playerBlips = data
        for k, v in pairs(localBlips) do
            playerBlips[tonumber(k)] = v
        end
        addBlips()
    else
        ESX.TriggerServerCallback('blips_creator:getBlips', function(blips)
            playerBlips = blips
            for k, v in pairs(localBlips) do
                playerBlips[tonumber(k)] = v
            end
            addBlips()
        end)
    end
    
end
RegisterNetEvent('blips_creator:refreshBlips', refreshBlips)

function init()
    refreshBlips()

    TriggerServerEvent('blips_creator:isAdmin')
end
RegisterNetEvent('blips_creator:init', init)


RegisterNetEvent('blips_creator:isAdmin')
AddEventHandler('blips_creator:isAdmin', function(result)
    isAdmin = result
end)

RegisterNetEvent('blips_creator:giveNewBlip')
AddEventHandler('blips_creator:giveNewBlip', function(senderName, blipData)
    debugPrint("Receiving new blip")

    local running = true

    local msg = string.format(language["confirm_blip"], senderName, blipData.name)

    AddTextEntry("blips_creator_confirm", msg)

    while running do
        Citizen.Wait(0)

        DisplayHelpTextThisFrame("blips_creator_confirm", false)

        if (IsControlJustReleased(0, 191)) then
            running = false

            localBlips[blipData.id] = blipData
            SetResourceKvp(localBlipsKvp, json.encode(localBlips))
            refreshBlips()
        elseif (IsControlJustReleased(0, 194)) then
            running = false
        end
    end
end)

local function editBlip(blipId)

end
RegisterNetEvent('blips_creator:editBlip', editBlip)