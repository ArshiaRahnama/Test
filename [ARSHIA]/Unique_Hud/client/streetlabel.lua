-- ============================================================
-- Unique_Hud / client / streetlabel.lua  (از sun-streetlabel ادغام شد)
-- ============================================================

local UH_ESX = nil
local UH_world = 0
CreateThread(function()
    while UH_ESX == nil do
        TriggerEvent('esx:getSharedObject', function(obj) UH_ESX = obj end)
        Wait(0)
    end
end)

RegisterNetEvent('esx:changeworld', function(w)
    UH_world = w
end)

CreateThread(function()
    while UH_ESX == nil do Wait(0) end
    while true do
        UH_ESX.TriggerServerCallback('sun-streetlabel:getWorld', function(w)
            UH_world = w or 0
        end)
        Wait(2000)
    end
end)

local UH_directions = {
    N = 360, NE = 315, E = 270, SE = 225, S = 180, SW = 135, W = 90, NW = 45,
}

local UH_isGpsOn = true
local UH_isLoaded = false
local UH_streetHash1, UH_streetHash2, UH_playerDirection
local UH_accountId = 0
local UH_ts = 0

local function UH_sendUIMessage(data)
    data.type = 'streetLabel:MSG'
    SendNUIMessage(data)
end

RegisterCommand('gps', function()
    if GetResourceKvpInt('gps') == 1 then
        SetResourceKvpInt('gps', 0)
        UH_isLoaded = false
    else
        SetResourceKvpInt('gps', 1)
        UH_isLoaded = true
    end
end, false)

CreateThread(function()
    TriggerEvent('chat:addSuggestion', '/gps', 'Toggle street label', {})
    UH_isLoaded = GetResourceKvpInt('gps') == 1

    while UH_ESX == nil do Wait(0) end

    UH_ESX.TriggerServerCallback('sun-streetlabel:getAccountId', function(id)
        UH_accountId = id or 0
    end)
    UH_ESX.TriggerServerCallback('sun-streetlabel:getServerTime', function(time)
        UH_ts = time or UH_ts
    end)

    local svID = GetPlayerServerId(PlayerId())

    while true do
        local ped = PlayerPedId()
        local coords = GetEntityCoords(ped)
        local zone = GetNameOfZone(coords.x, coords.y, coords.z)
        local zoneLabel = GetLabelText(zone)
        local street2 = ''

        if UH_isGpsOn then
            local var1, var2 = GetStreetNameAtCoord(coords.x, coords.y, coords.z, Citizen.ResultAsInteger(), Citizen.ResultAsInteger())
            UH_streetHash1 = GetStreetNameFromHashKey(var1)
            UH_streetHash2 = GetStreetNameFromHashKey(var2)
            UH_playerDirection = GetEntityHeading(ped)

            for k, v in pairs(UH_directions) do
                if math.abs(UH_playerDirection - v) < 22.5 then
                    UH_playerDirection = k
                    break
                end
            end

            street2 = (UH_streetHash2 == '') and zoneLabel or (UH_streetHash2 .. ', ' .. zoneLabel)
        end

        UH_sendUIMessage({
            active = UH_isLoaded,
            direction = UH_playerDirection,
            zone = UH_streetHash1,
            street = street2,
            time = GetClockHours() .. ':' .. GetClockMinutes(),
            ts = UH_ts .. ' | ' .. UH_accountId .. ' | W' .. UH_world .. ' | ID : ',
            src = svID,
            server = (UH_ESX.serverNum == 1) and '*' or '**',
            hud = true,
        })

        Wait(1000)
    end
end)

CreateThread(function()
    while true do
        Wait(1000)
        UH_ts = UH_ts + 1
    end
end)

CreateThread(function()
    while true do
        Wait(60000)
        if UH_ESX then
            UH_ESX.TriggerServerCallback('sun-streetlabel:getServerTime', function(time)
                if time then UH_ts = time end
            end)
        end
    end
end)
