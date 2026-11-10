-- Pub by FleeX Team , https://discord.gg/87rGBxgCsa

ESX.RegisterPoint = function(...)
    while ESX.RegisterPointReal == nil do Citizen.Wait(1000) end
    return ESX.RegisterPointReal(...)
end

generateIsVip = function(...)
    while generateIsVipReal == nil do Citizen.Wait(1000) end
    return generateIsVipReal(...)
end

function generateIsVipReal()
    local pofak = ESX.PlayerData.pofakNamaki
    if pofak and ESX.PlayerData.isvip then
        ESX.PlayerData.pofakNamaki = nil
        return GetHashKey(tostring(((pofak / 4) * ESX.PlayerData.isvip) * ESX.src + 12))
    end
end

local PointList = {}
local Notification = nil
local textUI
local DrawText = nil
local NearId = nil
local TickTime = 500
local ZoneData = {}
ESX.RegisterPointReal = function(coords,radius,markerdata,enter,otercb)
    local invoke = GetInvokingResource()
    local p = promise.new()
    CreateThread(function()
        while ESX == nil do Wait(100) end
        if coords and markerdata then
            local id = ESX.GenerateUUID()
            local zone = ESX.GetZone(coords)
            if not ZoneData[zone] then
                ZoneData[zone] = {}
            end
            ZoneData[zone][id] = true
            p:resolve(id)
            PointList[id] = {
                Zone = zone,
                Coords = coords,
                Radius = radius,
                MarkerData = markerdata,
                world = enter.world,
                disableWorldCheck = markerdata.worldCheck,
                Enter = enter.CB,
                EnterKey = enter.Key,
                Notification = enter.Notification,
                textUI = enter.textUI,
                DrawText = enter.DrawText,
                DrawTextCoords = enter.DrawTextCoords,
                DrawTextRadius = enter.DrawTextRadius,
                In = otercb.In,
                Out = otercb.Out,
                script = invoke,
            }
        end
    end)
    return Citizen.Await(p)
end

function Check()
    local playerzone = ESX.GetZone(nil)
    local InZoneData = ZoneData[playerzone]
    if InZoneData then
        local playercoords = GetEntityCoords(PlayerPedId())
        local find = false
        for k , v in pairs(InZoneData) do
            local v = PointList[k]
            local distance = ESX.GetDistance(playercoords,v.Coords)
            if distance <= v.MarkerData.DrawDistance and (not v.MarkerData.world or v.MarkerData.world == ESX.PlayerData.World) and (not v.MarkerData.permission_level or ESX.permission_level == 0 or ESX.permission_level >= v.MarkerData.permission_level) then
                find = true
                if not v.Draw and not v.MarkerData.Disable then
                    v.Draw = true
                    v.markerId = ESX.Game.CreateMarker(v.Coords,v.MarkerData.Color.R,v.MarkerData.Color.G,v.MarkerData.Color.B,v.MarkerData.Color.A,type(v.MarkerData.Radius) == 'table' and v.MarkerData.Radius or (v.MarkerData.Radius * 1.0),v.MarkerData.Type)
                end
                if distance <= v.Radius then
                    if NearId ~= k then
                        NearId = k
                        if v.Notification then
                            Notification = v.Notification
                            CreateThread(function()
                                while Notification do
                                    Wait(10)
                                    ESX.ShowHelpNotification(Notification)
                                end
                            end)
                        elseif v.textUI and not textUI then
                            textUI = true
                            lib.showTextUI(v.textUI.text, {
                                position = v.textUI.data and v.textUI.data.position or 'left-center',
                                icon = v.textUI.data and v.textUI.data.icon,
                                style = {
                                    borderRadius = v.textUI.data and v.textUI.data.style.borderRadius or 5,
                                    backgroundColor = v.textUI.data and v.textUI.data.style.backgroundColor or '#FFA500',
                                    color = v.textUI.data and v.textUI.data.style.color or 'black',
                                }
                            })
                        end
                        if v.In then
                            v.In(k)
                        end
                    end
                elseif NearId == k then
                    if v.Out then
                        v.Out()
                        local _NearId = NearId
                        SetTimeout(3000, function()
                            if _NearId ~= NearId then
                                v.Out()
                            end
                        end)
                    end
                    Notification = nil
                    NearId = nil
                    if v.textUI then
                        textUI = nil
                        lib.hideTextUI()
                    end
                end
                if v.DrawText and distance <= v.DrawTextRadius then
                    if DrawText ~= v.DrawText then
                        DrawText = v.DrawText
                        CreateThread(function()
                            while DrawText do
                                Wait(10)
                                if DrawText then
                                    ESX.Game.Utils.Draw3D(v.DrawTextCoords,DrawText)
                                end
                            end
                        end)
                    end
                elseif DrawText == v.DrawText then
                    DrawText = nil
                end
            elseif v.Draw or NearId == k then
                ESX.Game.DeleteMarker(v.Coords)
                v.Draw = nil
                v.markerId = nil
                -- if Notification == v.Notification then
                Notification = nil
                --end
                --if DrawText == v.DrawText then
                DrawText = nil
                --end
                NearId = nil
                if textUI then
                    textUI = nil
                    lib.hideTextUI()
                end
            end
        end
        if not find then
            if NearId then
                local v = PointList[NearId]
                ESX.Game.DeleteMarker(v.Coords)
                v.markerId = nil
                v.Draw = nil
                if v.Out then
                    v.Out()
                    local _NearId = NearId
                    SetTimeout(3000, function()
                        if _NearId ~= NearId then
                            v.Out()
                        end
                    end)
                end
            end
            Notification = nil
            DrawText = nil
            NearId = nil
            if textUI then
                textUI = nil
                lib.hideTextUI()
            end
        end
    else
        if NearId then
            local _NearId = NearId
            local v = PointList[NearId]
            ESX.Game.DeleteMarker(v.Coords)
            v.Draw = nil
            v.markerId = nil
            if v.Out then
                v.Out()
                SetTimeout(3000, function()
                    if _NearId ~= NearId then
                        v.Out()
                    end
                end)
            end
        end
        Notification = nil
        DrawText = nil
        if textUI then
            textUI = nil
            lib.hideTextUI()
        end
        NearId = nil
        Wait(1000)
    end
    SetTimeout(TickTime,Check)
end

SetTimeout(TickTime,Check)

AddEventHandler('onKeyDown',function(key)
    if NearId and PointList[NearId] then
        local data = PointList[NearId]
        if key == data.EnterKey then
            if data.Enter and (ESX.PlayerData.World == 0 or data.disableWorldCheck == false) then
                data.Enter(NearId)
                Notification = nil
                if textUI then
                    textUI = nil
                    lib.hideTextUI()
                end
                --DrawText = nil
            end
        end
    end
end)

local SavedZone = {}
ESX.CheckZone = function(target,you,radius)
    local coords = GetEntityCoords(PlayerPedId())
    if you then
        coords = you
    end
    if target then
        local index = target.x .. target.y .. target.z .. (radius or 256)
        local zone = SavedZone[index]
        if not zone then
            zone = ESX.GetZone(target,radius)
            SavedZone[index] = zone
        end
        local selfzone = ESX.GetZone(nil,radius)
        if selfzone == zone then
            return true
        else
            return false
        end
    end
end

AddEventHandler('onResourceStop',function(name)
    for k,v in pairs(PointList) do
        if v.script == name then
            ZoneData[v.Zone][k] = nil
            PointList[k] = nil
        end
    end
end)

function ESX.changePointColor(zoneId, color)
    if PointList[zoneId] then
        PointList[zoneId].MarkerData.Color = color
        if PointList[zoneId].markerId then
            ESX.Game.changeMarkerColor(PointList[zoneId].markerId, color.R, color.G, color.B, color.A)
        end
    end
end