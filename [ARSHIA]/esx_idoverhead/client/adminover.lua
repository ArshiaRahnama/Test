
ESX = nil
local alias = {}

Citizen.CreateThread(function()
    local sleep = 6
    while ESX == nil do
        TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
        Citizen.Wait(sleep)
    end
    ESX.PlayerData = ESX.GetPlayerData()
end)

local vehicles = {
    [2071877360] = { [3] = "seat_dside_r3", [4] = "seat_pside_r3" },
    [610904671] = { [3] = "seat_dside_r3", [4] = "seat_pside_r3" },
    [-1775728740] = { [3] = "seat_dside_r1", [4] = "seat_pside_r1", [5] = "seat_dside_r2", [6] = "seat_pside_r2" },
    [-1647941228] = { [3] = "seat_dside_r1", [4] = "seat_pside_r1", [5] = "seat_dside_r2", [6] = "seat_pside_r2" },
    [-1237253773] = { [3] = "seat_dside_r2", [4] = "seat_pside_r2" },
    [-2107990196] = { [3] = "seat_dside_r2", [4] = "seat_pside_r2" },
    [-305727417] = { [3] = "seat_dside_r2", [4] = "seat_pside_r2" },
    [117401876] = { [3] = "seat_dside_r2", [4] = "seat_pside_r2" },
    [-602287871] = { [3] = "seat_dside_r2", [4] = "seat_pside_r2" },
    [-1205689942] = { [3] = "seat_dside_r1", [4] = "seat_pside_r1", [5] = "seat_dside_r2", [6] = "seat_pside_r1" },
    [-1693015116] = { [3] = "seat_dside_r1", [4] = "seat_pside_r1" },
    [1922257928] = { [3] = "seat_dside_r1", [4] = "seat_pside_r1", [5] = "seat_dside_r2", [6] = "seat_pside_r2" },
    [-2007026063] = { [3] = "seat_dside_r1", [4] = "seat_pside_r1", [5] = "seat_dside_r2", [6] = "seat_pside_r2", [7] = "seat_dside_r3", [8] = "seat_pside_r3", [9] = "seat_dside_r4" },
    [65352125] = { [3] = "seat_dside_r1", [4] = "seat_pside_r1", [5] = "seat_dside_r2", [6] = "seat_pside_r2", [7] = "seat_dside_r3", [8] = "seat_pside_r3" },
    [-713569950] = { [3] = "seat_dside_r1", [4] = "seat_pside_r1", [5] = "seat_dside_r2", [6] = "seat_pside_r2", [7] = "seat_dside_r3", [8] = "seat_pside_r3", [9] = "seat_dside_r4", [10] = "seat_pside_r4", [11] = "seat_dside_r5", [12] = "seat_pside_r5", [13] = "seat_dside_r6", [14] = "seat_pside_r6" },
    [-120287622] = { [3] = "seat_dside_r1", [4] = "seat_pside_r1" },
    [-1214293858] = { [3] = "seat_dside_r1", [4] = "seat_pside_r", [5] = "seat_pside_r2", [6] = "seat_pside_r3" },
    [-50547061] = { [3] = "seat_dside_r1", [4] = "seat_pside_r1", [5] = "seat_dside_r2", [6] = "seat_pside_r2", [7] = "seat_dside_r3", [8] = "seat_pside_r3" },
    [-493410377] = { [3] = "seat_dside_r2", [4] = "seat_pside_r2" },
    [-1961627517] = { [3] = "seat_dside_r2", [4] = "seat_dside_r3" }
}

local disPlayerNames = 5
local own = true
local ownID = PlayerId()
local showidpress = false
local performanceMode = false
local playersInfo = {}
local controlPress = false
local labels = {}

local DatPlayerLevel = {}
local requestedRank = {}
local function getCachedRank(serverId)
    if DatPlayerLevel[serverId] then return DatPlayerLevel[serverId] end
    if not requestedRank[serverId] then
        requestedRank[serverId] = true
        ESX.TriggerServerCallback('XP_System:getRank', function(rank)
            if rank and rank > 0 then
                DatPlayerLevel[serverId] = rank
            end
        end, serverId)
    end
    return DatPlayerLevel[serverId] or '?'
end

RegisterNetEvent('esx_idoverhead:modifydistance')
AddEventHandler('esx_idoverhead:modifydistance', function(distance)
    ESX.TriggerServerCallback('esx_aduty:checkAdmin', function(isAdmin)
        if isAdmin then
            disPlayerNames = distance
        end
    end)
end)

RegisterNetEvent('esx_idoverhead:toggleOwn')
AddEventHandler('esx_idoverhead:toggleOwn', function()
    own = not own
end)

RegisterNetEvent('esx_idoverhead:updateLabels')
AddEventHandler('esx_idoverhead:updateLabels', function(labelsp)
    labels = labelsp
end)

RegisterNetEvent('esx_idoverhead:changeLabelHideStatus')
AddEventHandler('esx_idoverhead:changeLabelHideStatus', function(id, status)
    if id == nil or type(status) ~= "boolean" then return end
    if labels[id] and labels[id].info then
        labels[id].info["hide"] = status
    end
end)

RegisterNetEvent('esx_idoverhead:modifyLabel')
AddEventHandler('esx_idoverhead:modifyLabel', function(id, label)
    if id == nil or label == nil then return end
    if DoesTagExist(id, label.badge) then
        RemoveTag(id, label.badge)
    end
    if not DoesTagExist(id, label.badge) then
        if not labels[id] then
            labels[id] = {}
        end
        table.insert(labels[id], label)
    end
end)

local myself = PlayerId()

local maxDistance = 10.0

Citizen.CreateThread(function()
    local sleep = 5
    while true do
        if not performanceMode or controlPress then
            for k, v in pairs(playersInfo) do
                if k ~= myself then
                    if v.info.distance < disPlayerNames and v.info.cansee and v.info.hide then
                        local targetPed = v.info.ped
                        local x2, y2, z2 = table.unpack(GetEntityCoords(targetPed, true))
                        z2 = z2 - 2


                        local isVisible = HasEntityClearLosToEntity(PlayerPedId(), targetPed, 17)
                        v.isVisible = isVisible


                        if v.isVisible and v.info.distance <= maxDistance then
                            if showidpress then
                                z2 = z2 + 1.2
                                DrawText3Dido(x2, y2, z2, "[" .. v.info.id .. "]"..v.info.level, 255, 255, 255)
                            end

                            if v.labels then
                                for _, j in pairs(v.labels) do
                                    if not j.toggle then
                                        if not j.badge then
                                            DrawText3Dido(x2, y2, z2 + 2 + j.height, "" .. j.display .. " " .. v.info.name, 255, 0, 0)
                                        else
                                            DrawText3Dido(x2, y2, z2 + 2 + j.height, j.display, 255, 0, 0)
                                        end
                                    end
                                end
                            end
                        end
                    end
                elseif own and ownID == k then

                    if v.labels and v.info.hide then
                        local ped = PlayerPedId()
                        local x, y, z = table.unpack(GetEntityCoords(ped, true))

                        for _, j in pairs(v.labels) do
                            if not j.toggle and not j.badge then
                                DrawText3Dido(x, y, z + j.height, "" .. j.display .. " " .. v.info.name, 255, 0, 0)
                            end
                        end
                    end
                end
            end
            Citizen.Wait(sleep)
        else
            Citizen.Wait(sleep)
        end
    end
end)

Citizen.CreateThread(function()
    local sleep = 500
    while true do
        playersInfo = {}
        local ped = PlayerPedId()
        local coords = GetEntityCoords(ped)

        for _, player in ipairs(GetActivePlayers()) do
            local playeridd = GetPlayerServerId(player)
            local tped = GetPlayerPed(player)
            local coords2 = GetEntityCoords(tped)
            local distance = math.floor(Vdist(coords.x, coords.y, coords.z, coords2.x, coords2.y, coords2.z))
            if distance < disPlayerNames then
                local vehicle = GetVehiclePedIsIn(tped, false)
                local class = GetVehicleClass(vehicle)
                playersInfo[player] = {
                    info = {
                        distance = distance,
                        cansee = HasEntityClearLosToEntity(ped, tped, 17),
                        name = GetPlayerName(player),
                        hide = IsEntityVisible(tped),
                        id = GetPlayerServerId(player),
                        level = getCachedRank(GetPlayerServerId(player)),
                        ped = tped,
                        vehicle = vehicle,
                        class = class,
                        typing = DecorGetBool(tped, "typing"),
                        talking = NetworkIsPlayerTalking(player)
                    },
                    labels = getplayerTags(player)
                }
                playersInfo[player].info.label = getLabel(playersInfo[player].info)

            end
        end
        Citizen.Wait(sleep)
    end
end)

local spam = false
function showId()
    if spam then return lib.notify({ position = 'center-right', title = '', description = '~r~لطفاً اسپم نکنید!', type = 'error', duration = 3000 }) end
    spam = true
    showidpress = true
    TriggerServerEvent('ido:ShowID')
    Citizen.SetTimeout(5000, function()
        showidpress = false
        spam = false
    end)
end

function getplayerTags(player)
    if labels[player] then
        return labels[player]
    end
    return nil
end

function DoesTagExist(player, badge)
    if labels[player] == nil then return false end
    for k, v in pairs(labels[player]) do
        if v.badge == badge then
            return true
        end
    end
    return false
end

function RemoveTag(player, badge)
    if labels[player] == nil then return end
    for k, v in pairs(labels[player]) do
        if v.badge == badge then
            labels[player][k] = nil
        end
    end
end

function getVehicleBonePosition(playerPed, pedVehicle)
    local ped = playerPed
    local veh = pedVehicle
    local model = GetEntityModel(veh)
    local position

    if vehicles[model] == nil then
        return nil
    end

    if GetPedInVehicleSeat(veh, -1) == ped then
        position = GetWorldPositionOfEntityBone(veh, GetEntityBoneIndexByName(veh, 'seat_dside_f'))
    elseif GetPedInVehicleSeat(veh, 0) == ped then
        position = GetWorldPositionOfEntityBone(veh, GetEntityBoneIndexByName(veh, 'seat_pside_f'))
    elseif GetPedInVehicleSeat(veh, 1) == ped then
        position = GetWorldPositionOfEntityBone(veh, GetEntityBoneIndexByName(veh, 'seat_dside_r'))
    elseif GetPedInVehicleSeat(veh, 2) == ped then
        position = GetWorldPositionOfEntityBone(veh, GetEntityBoneIndexByName(veh, 'seat_pside_r'))
    else
        for i = 3, 14 do
            if vehicles[model][i] and GetPedInVehicleSeat(veh, i) == ped then
                position = GetWorldPositionOfEntityBone(veh, GetEntityBoneIndexByName(veh, vehicles[model][i]))
                break
            end
        end
    end

    return position
end

function getLabel(info)
    local id = info.id
    if alias[tostring(info.id)] then
        id = info.id .. ' ~g~| ~r~[~p~'..alias[tostring(info.id)]..'~r~]'
    end
    return id or info.id
end

function DrawText3Dido(x, y, z, text, r, g, b)
    local onScreen, _x, _y = World3dToScreen2d(x, y, z)
    local px, py, pz = table.unpack(GetGameplayCamCoords())
    local dist = Vdist(px, py, pz, x, y, z, 1)
    local scale = (1 / dist) * 2
    local fov = (1 / GetGameplayCamFov()) * 100
    local scale = scale * fov
    if onScreen then
        SetDrawOrigin(x, y, z, 0);
        ClearDrawOrigin()
        SetTextScale(0.0 * scale, 0.7 * scale)
        SetTextFont(6)
        SetTextProportional(0)
        SetTextColour(r, g, b, 255)
        SetTextDropshadow(0, 0, 0, 0, 255)
        SetTextEdge(2, 0, 0, 0, 150)
        SetTextDropShadow()
        SetTextOutline()
        SetTextEntry("STRING")
        SetTextCentre(1)
        AddTextComponentString(text)
        DrawText(_x, _y)
    end
end