-- Pub by FleeX Team , https://discord.gg/87rGBxgCsa

Loaded = false
Cache = {}
SpawnedObject = {}
SpawnedVehicle = {}
ObjectList = {}
HouseId = 0
ZoneData = {}
VehicleName = {}
VehicleAvailble = {}
Access = 0
stressThreadBool = false
CreateThread(function()
    while not NetworkIsSessionStarted() do
        Wait(250)
    end

    while ESX == nil do
        TriggerEvent('esx:getSharedObject', function(obj)
            ESX = obj
        end)
        Wait(250)
    end

    while ESX.GetPlayerData().job == nil or not mainLoaded do
        Wait(250)
    end

    -- if Config.PoliceRaid and Config.PoliceRaid.Enabled then
    --     if ESX.GetPlayerData().job.name == Config.PoliceRaid.Job.Name then
    --         if (Config.PoliceRaid.OnlyBoss and ESX.GetPlayerData().job.grade_name == Config.PoliceRaid.Job.Boss) or not Config.PoliceRaid.OnlyBoss then
    --             Cache.IsPolice = true
    --         end
    --     end
    -- end
    TriggerServerEvent("sunset_housing:request_houses")
    TriggerEvent('chat:addSuggestion', '/showhouse', 'Show availble houses', {
    })
    TriggerEvent('chat:addSuggestion', '/reloadhouse', 'Reload houses', {
    })
end)

local gangsCoords = {
    [1]  =  { coords = vec(828.72, -2482.12, 24.02),    color = 80 },
    [2]  =  { coords = vec(995.91, -2507.33, 28.3),     color = 83 },
    [3]  =  { coords = vec(1093.41, -2264.68, 30.29),   color = 80 },
    [4]  =  { coords = vec(949.31, -2108.95, 30.55),    color = 80 },
    [5]  =  { coords = vec(1369.47, -2076.11, 52.0),    color = 80 },
    [6]  =  { coords = vec(-2006.53, 454.97, 102.63),              },
    [7]  =  { coords = vec(133.88, -2194.56, 6.03),     color = 80 },
    [8]  =  { coords = vec(-26.84, -2156.18, 10.31),    color = 80 },
    [9]  =  { coords = vec(-452.53, -1704.59, 18.84),   color = 80 },
    [10] =  { coords = vec(-616.19, -1603.06, 26.75),   color = 80 },
    [11] =  { coords = vec(974.75, -118.77, 74.34),     color = 80 },
    [12] =  { coords = vec(1379.83, 1147.16, 114.33),   color = 83 },
    [13] =  { coords = vec(214.62, 759.89, 204.69),                },
    [14] =  { coords = vec(15.41, 541.87, 176.02),      color = 80 },
    [15] =  { coords = vec(-88.92, 834.14, 235.72),                },
    [16] =  { coords = vec(-141.88, 906.82, 235.68),    color = 80 },
    [17] =  { coords = vec(-189.39, 973.66, 232.13),               },
    [18] =  { coords = vec(-115.86, 988.49, 235.75),    color = 80 },
    [19] =  { coords = vec(-559.68, 301.54, 83.16),     color = 80 },
    [20] =  { coords = vec(-875.62, -44.52, 38.16),     color = 80 },
    [21] =  { coords = vec(-927.28, 11.62, 47.72),                 },
    [22] =  { coords = vec(-875.72, 43.69, 48.76),                 },
    [23] =  { coords = vec(-918.38, 109.96, 55.32),                },
    [24] =  { coords = vec(-968.85, 123.33, 56.8),                 },
    [25] =  { coords = vec(-940.74, 191.18, 67.05),                },
    [26] =  { coords = vec(-907.22, 182.68, 69.44),                },
    [27] =  { coords = vec(-824.69, 180.24, 71.53),     color = 80 },
    [28] =  { coords = vec(-872.9, 302.77, 83.98),                 },
    [29] =  { coords = vec(-881.94, 365.46, 85.17),                },
    [30] =  { coords = vec(-1020.4, 362.02, 71.08),                },
    [31] =  { coords = vec(-1122.42, 368.19, 70.75),    color = 80 },
    [32] =  { coords = vec(-1116.24, 298.93, 65.95),               },
    [33] =  { coords = vec(-1184.61, 284.78, 69.5),                },
    [34] =  { coords = vec(-1369.48, 56.35, 53.71),                },
    [35] =  { coords = vec(-1521.65, 95.5, 56.62),      color = 83 },
    [36] =  { coords = vec(-1568.83, -35.08, 56.95),    color = 80 },
    [37] =  { coords = vec(-1547.1, -87.29, 54.62),     color = 80 },
    [38] =  { coords = vec(-1932.1, 186.01, 84.53),                },
    [39] =  { coords = vec(-1991.55, 289.09, 91.57),               },
    [40] =  { coords = vec(-1931.21, 400.97, 96.5),                },
    [41] =  { coords = vec(-1954.52, 456.87, 101.51),              },
    [42] =  { coords = vec(-1928.22, 543.56, 114.83),   color = 80 },
    [43] =  { coords = vec(-1808.89, 458.72, 128.27),   color = 80 },
    [44] =  { coords = vec(-1754.74, 363.6, 89.56),     color = 80 },
    [45] =  { coords = vec(-1535.05, 429.48, 109.26),   color = 80 },
    [46] =  { coords = vec(-1379.66, 451.63, 104.71),              },
    [47] =  { coords = vec(-1352.48, 486.04, 103.89),              },
    [48] =  { coords = vec(-1268.42, 499.06, 97.03),               },
    [49] =  { coords = vec(-1523.48, 863.26, 181.66),   color = 80 },
    [50] =  { coords = vec(-704.37, 661.21, 155.16),               },
    [51] =  { coords = vec(-3200.45, 812.87, 8.93),     color = 80 },
    [52] =  { coords = vec(-2669.66, 1319.38, 147.44),  color = 80 },
    [53] =  { coords = vec(-2601.71, 1675.97, 141.89),  color = 80 },
    [54] =  { coords = vec(-2589.26, 1910.81, 167.5),              },
    [55] =  { coords = vec(-1901.38, 2048.48, 140.75),  color = 80 },
    [56] =  { coords = vec(-1451.94, 492.42, 116.21),              },
    [57] =  { coords = vec(-2791.54, 1433.75, 100.98),             },
    [58] =  { coords = vec(-2009.35, 492.86, 106.96),              },
    [59] =  { coords = vec(94.97, 3622.64, 40.01),                 },
    [60] =  { coords = vec(1991.89, 3053.16, 47.21),               },
    [61] =  { coords = vec(-1569.89, -262.12, 48.28),   color = 80 },
    [62] =  { coords = vec(-332.54, -2779.6, 5.14),     color = 80 },
    [63] =  { coords = vec(-834.63, 114.67, 55.32),                },
    [64] =  { coords = vec(-1473.94, 34.93, 54.31),                },
    [65] =  { coords = vec(-1466.98, -30.02, 54.7),     color = 80 },
    [66] =  { coords = vec(6.11, -1824.82, 25.19),      color = 80 },
    [67] =  { coords = vec(219.97, -2002.28, 20.31),    color = 80 },
    [68] =  { coords = vec(-144.82, -2223.07, 7.81),    color = 80 },
    [69] =  { coords = vec(581.25, -2805.96, 6.06),     color = 80 },
    [70] =  { coords = vec(-999.77, 307.81, 68.57),     color = 83 },
    [71] =  { coords = vec(1408.7, 3616.27, 34.9),                 },
    [72] =  { coords = vec(-56.35, -1836.47, 26.61),    color = 83 },
    [73] =  { coords = vec(182.45, 1698.98, 227.39),    color = 80 },
    [74] =  { coords = vec(-669.14, -2385.35, 13.91),   color = 80 },
    [75] =  { coords = vec(2046.51, 3181.47, 45.03),               },
    [76] =  { coords = vec(2045.28, 3439.55, 43.87),               },
    [77] =  { coords = vec(-1039.12, 222.13, 64.38),               },
    [78] =  { coords = vec(304.98, -2554.01, 5.72),     color = 80 },
    [79] =  { coords = vec(903.21, 3654.62, 32.61),                },
    [80] =  { coords = vec(152.65, 6391.92, 32.99),                },
    [81] =  { coords = vec(2383.22, 3330.46, 47.39),               },
    [82] =  { coords = vec(-1968.87, 246.8, 87.73),                },
    [83] =  { coords = vec(-1896.92, 133.85, 82.36),               },
    [84] =  { coords = vec(-736.01, -1456.31, 5.0),     color = 83 },
    [85] =  { coords = vec(-1570.37, 24.61, 59.55),     color = 80 },
    [86] =  { coords = vec(-597.44, -2326.74, 13.83),   color = 80 },
    [87] =  { coords = vec(-402.58, -2267.99, 7.60),    color = 83 },
    [88] =  { coords = vec(-1927.45, 291.28, 89.07),               },
    [89] =  { coords = vec(-395.56, 428.45, 112.34),               },
    [90] =  { coords = vec(-1939.45, 356.8, 93.29),                },
    [91] =  { coords = vec(2099.06, 3245.08, 47.97),               },
    [92] =  { coords = vec(958.25, 3616.23, 32.92),                },
    [93] =  { coords = vec(1917.21, 2922.35, 48.66),               },
    [94] =  { coords = vec(2187.09, 3319.11, 46.34),               },
    [95] =  { coords = vec(797.47, -2770.11, 7.45),     color = 80 },
    [96] =  { coords = vec(2477.4, 3425.26, 49.86),                },
    [97] =  { coords = vec(-1510.6, 29.62, 56.04),                 },
    [98] =  { coords = vec(-602.96, 6162.19, 4.8),                 },
    [99] =  { coords = vec(-293.23, 6124.52, 31.5),                },
    [100] = { coords = vec(17.17, 678.78, 209.67),      color = 80 },
    [101] = { coords = vec(-699.03, 6049.26, 9.65),                },
    [102] = { coords = vec(1015.62, -2353.22, 30.55),   color = 80 },
    [103] = { coords = vec(1228.49, -401.95, 68.86),    color = 80 },
    [104] = { coords = vec(-2209.49, -385.8, 13.32),    color = 80 },
    [105] = { coords = vec(1902.02, 3090.79, 50.36),               },
    [106] = { coords = vec(1122.76, 3589.83, 34.33),               },
    [107] = { coords = vec(1075.01, 3594.4, 34.39),                },
    [108] = { coords = vec(1027.73, 3595.95, 35.73),               },
    [109] = { coords = vec(-1603.81, -825.65, 10.03),   color = 80 },
    [110] = { coords = vec(-1661.29, -791.02, 10.34),   color = 80 },
    [111] = { coords = vec(-1706.68, -742.58, 11.73),   color = 80 },
    [112] = { coords = vec(-1493.61, -197.35, 50.4),    color = 80 },
    [113] = { coords = vec(-444.34, 290.43, 83.23),     color = 80 },
    [114] = { coords = vec(1337.87, -2636.56, 49.23),   color = 80 },
    [115] = { coords = vec(-299.97, -2707.82, 6.0),     color = 80 },
    [116] = { coords = vec(-1473.89, -169.59, 48.82),   color = 80 },
    [117] = { coords = vec(631.12, -2925.87, 6.07),     color = 80 },
    [118] = { coords = vec(-980.47, -2054.85, 9.41),    color = 80 },
    [119] = { coords = vec(-918.38, -2075.77, 9.3),     color = 80 },
    [120] = { coords = vec(932.05, -2490.23, 28.41),    color = 80 },
    [121] = { coords = vec(306.42, -2733.66, 6.03),     color = 80 },
    [122] = { coords = vec(1606.03, -2612.66, 53.69),   color = 80 },
    [123] = { coords = vec(-1088.17, -2161.05, 13.4),   color = 80 },
    [124] = { coords = vec(-1169.47, -2147.56, 13.42),  color = 80 },
    [125] = { coords = vec(-1019.96, -2212.9, 8.98),    color = 80 },
    [126] = { coords = vec(-875.2, -2737.15, 13.91),    color = 80 },
    [127] = { coords = vec(-955.86, -1969.6, 13.19),    color = 80 },
    [128] = { coords = vec(-1169.95, -1173.24, 5.62),   color = 80 },
    [129] = { coords = vec(-813.95, -2685.97, 13.81),   color = 80 },
    [130] = { coords = vec(-247.17, -2662.18, 6.0),     color = 80 },
}

function getGridZone(coords)
	local plyPos = GetEntityCoords(PlayerPedId(), false)
    if coords then
        plyPos = coords
    end
	local zoneRadius = 256
	local zoneOffset = (256 / zoneRadius)
	local upzone = 0
	if plyPos.x < 0 then
		upzone = 5
	elseif plyPos.x > 0 then
		upzone = 10
	elseif plyPos.x > 100 then
		upzone = 15
	elseif plyPos.x > 200 then
		upzone = 20
	elseif plyPos.x > 300 then
		upzone = 25
	elseif plyPos.x > 400 then
		upzone = 30
	elseif plyPos.x > 500 then
		upzone = 35
	else
		upzone = 40
	end
	return (math.floor( 31 * (zoneOffset) + (zoneOffset * 6) - 6 )) + (((LocalPlayer.state.routingBucket or 0) * 5) + 5) + math.ceil((plyPos.x + plyPos.y) / (zoneRadius) + upzone)
end

function ClearAllProp()
    for k , v in pairs(SpawnedObject) do
        ESX.Game.DeleteLocalObject(v)
    end
    SpawnedObject = {}
    ESX.Game.DeleteLocalObject(Cache.shell_object)
    Cache.shell_object = 0
end

function reqHouse(id)
    while Config.Houses == nil do Citizen.Wait(10) end
    if not id or Config.Houses[id] then return end
    local p = promise.new()
    ESX.TriggerServerCallback('sunset_housing:getHouse',function(data)
        p:resolve(data)
    end,id)
    Config.Houses[id] = Citizen.Await(p)
end

exports('GetObjectId',function(object)
    for k , v in pairs(SpawnedObject) do
        if v == object then
            return k
        end
    end
end)

RegisterCommand('reloadhouse',function()
    ZoneData = {}
    for k, v in pairs(Config.Houses) do
        if not v.IsAP then
            Config.Houses[k].Zone = getGridZone(v.Entercoords.xyz)
            if ZoneData[Config.Houses[k].Zone] then
                ZoneData[Config.Houses[k].Zone][v.Id] = v
            else
                ZoneData[Config.Houses[k].Zone] = {}
                ZoneData[Config.Houses[k].Zone][v.Id] = v
            end
        end
    end
end)


RegisterNetEvent("sunset_housing:set_houses")
AddEventHandler("sunset_housing:set_houses", function(houses,ap,ap2)
    Config.Houses = houses
    Config.Apartment = ap
    local identifier = ESX.GetPlayerData().identifier
    if houses == nil or ap == nil then
        return TriggerServerEvent("sunset_housing:request_houses")
    end
    for k, v in pairs(Config.Houses) do
        if not v.IsAP then
            Config.Houses[k].Zone = getGridZone(v.Entercoords.xyz)
            if ZoneData[Config.Houses[k].Zone] then
                ZoneData[Config.Houses[k].Zone][v.Id] = v
            else
                ZoneData[Config.Houses[k].Zone] = {}
                ZoneData[Config.Houses[k].Zone][v.Id] = v
            end
            if Config.Houses[k].Owner == identifier then
                AddBlip(v.Entercoords.xyz, 40, 2, 'House', 0.8)
                OwnedId[k] = true
            end
        end
    end
    for k , v in pairs(Config.Apartment) do
        AddBlip(Config.Apartment[k].Entercoords.xyz, 475, 2, 'Apartment', 1.0)
    end
    Loaded = true
end)

local HBlip = {}
RegisterCommand('showhouse',function()
    if ESX.TableLength(HBlip) == 0 then
        for k, v in pairs(Config.Houses) do
            if not v.Owned and not v.IsAP then
                table.insert(HBlip,AddBlip(v.Entercoords.xyz, 40, 1, 'House', 0.8))
            end
        end
    else
        for k , v in pairs(HBlip) do
            RemoveBlip(v)
        end
        HBlip = {}
    end
end)

local gBlip = {}
RegisterCommand('showgang',function()
    if ESX.TableLength(gBlip) == 0 then
        for k, v in ipairs(gangsCoords) do
            Wait(35)
            local cat = math.ceil(k / 100)
            if cat == 0 or true then
                cat = 1
            end
            if type(v) == 'table' then
                local blip = AddBlip(v.coords.xyz, 183, cat == 1 and 5 or 27, 'Gang Base '.. cat, 0.8)
                if v.color then
                    local radius = AddBlipForRadius(v.coords.xyz, 40.0)
                    SetBlipAlpha(radius, 100)
                    SetBlipColour(radius, v.color or 38)
                    table.insert(gBlip, radius)
                end
                table.insert(gBlip, blip)
            else
                table.insert(gBlip,AddBlip(v, 183, 5, 'Gang Base '.. cat, 0.8))
            end
        end
    else
        for k , v in pairs(gBlip) do
            RemoveBlip(v)
        end
        gBlip = {}
    end
end)

RegisterNetEvent('housing:tpToGang', function(index)
    if gangsCoords[index] then
        ESX.Game.Teleport(PlayerPedId(), gangsCoords[index])
    end
end)

RegisterNetEvent("esx:setJob")
AddEventHandler("esx:setJob", function(job)
	if Config.PoliceRaid and Config.PoliceRaid.Enabled then
        if job.name == Config.PoliceRaid.Job.Name then
            if (Config.PoliceRaid.OnlyBoss and job.grade_name == Config.PoliceRaid.Job.Boss) or not Config.PoliceRaid.OnlyBoss then
                Cache.IsPolice = true
            else
                Cache.IsPolice = false
            end
        else
            Cache.IsPolice = false
        end
    else
        Cache.IsPolice = false
    end
end)

RegisterNetEvent("sunset_housing:updatehouse")
AddEventHandler("sunset_housing:updatehouse", function(id,data)
    reqHouse(id)
    ESX.Game.DeleteMarker(vector3(Config.Houses[id].Entercoords.x,Config.Houses[id].Entercoords.y,Config.Houses[id].Entercoords.z))
    Config.Houses[id] = data
    if not data.IsAP then
        Config.Houses[id].Zone = getGridZone(data.Entercoords.xyz)
        if Config.Houses[id].Owner == ESX.GetPlayerData().identifier then
            AddBlip(Config.Houses[id].Entercoords.xyz, 40, 2, 'House', 0.8)
            OwnedId[id] = true
        end
        if ZoneData[Config.Houses[id].Zone] then
            ZoneData[Config.Houses[id].Zone][id] = data
        else
            ZoneData[Config.Houses[id].Zone] = {}
            ZoneData[Config.Houses[id].Zone][id] = data
        end
    end
end)

RegisterNetEvent("sunset_housing:DeleteHouse")
AddEventHandler("sunset_housing:DeleteHouse", function(id)
    reqHouse(id)
    ESX.Game.DeleteMarker(vector3(Config.Houses[id].Entercoords.x,Config.Houses[id].Entercoords.y,Config.Houses[id].Entercoords.z))
    if HouseId == id then
        TriggerEvent('sunset_housing:ExitMe',HouseId)
    end
    ZoneData[Config.Houses[id].Zone][id] = nil
    Config.Houses[id] = nil
end)

RegisterNetEvent("sunset_housing:AddHouse")
AddEventHandler("sunset_housing:AddHouse", function(data)
    Config.Houses[data.Id] = data
    if ZoneData[data.Zone] then
        ZoneData[data.Zone][data.Id] = data
    else
        ZoneData[data.Zone] = {}
        ZoneData[data.Zone][data.Id] = data
    end
end)

AddBlip = function(coords, sprite, colour, label, scale)
    local blip = AddBlipForCoord(coords)
    -- if category then
    --     SetBlipCategory(blip, category)
    -- end
    SetBlipSprite(blip, sprite)
    SetBlipColour(blip, colour)
    SetBlipScale(blip, scale)
    SetBlipAsShortRange(blip, true)

    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString(label)
    EndTextCommandSetBlipName(blip)

    return blip
end

PreviewHouse = function(data)
    DoScreenFadeOut(750)
    ESX.Streaming.RequestModel(data.Shell)
    ESX.Game.SpawnLocalObject(data.Shell,Config.HousePosition,function(obj)
        Cache.shell_object = obj
        SetEntityHeading(Cache.shell_object, 0.0)
        FreezeEntityPosition(Cache.shell_object, true)
        while not IsScreenFadedOut() do Wait(0) end
        local newcoords = Config.ShellCoords[data.Shell].Join.xyz + Config.HousePosition
        for i = 1, 25 do
            ESX.SetEntityCoords(PlayerPedId(),newcoords)
            Wait(50)
        end
        while IsEntityWaitingForWorldCollision(PlayerPedId()) do
            ESX.SetEntityCoords(PlayerPedId(),newcoords)
            Wait(50)
        end
        SetEntityHeading(PlayerPedId(),Config.ShellCoords[data.Shell].Join.w)
        DoScreenFadeIn(1500)
        Citizen.CreateThread(function()
            while Cache.shell_object do
                Wait(0)
                local Players = ESX.Game.GetPlayers()
                for k,v in pairs(Players) do
                    if PlayerId() ~= v then
                        SetEntityVisible(GetPlayerPed(v), false, false)
                        SetEntityNoCollisionEntity(GetPlayerPed(v), PlayerPedId(), false)
                    end
                end
            end
            Wait(2000)
            local Players = ESX.Game.GetPlayers()
            for k,v in pairs(Players) do
                if PlayerId() ~= v then
                    SetEntityVisible(GetPlayerPed(v), true, false)
                end
            end
        end)
        while Cache.shell_object do
            Wait(0)
            if ESX.GetDistance(newcoords,GetEntityCoords(PlayerPedId())) <= 2 then
                ESX.Game.Utils.Draw3D(newcoords,'~INPUT_CONTEXT~ Jahat khoruj')
                if IsControlJustReleased(0,38) then
                    DoScreenFadeOut(750)
                    while not IsScreenFadedOut() do Wait(0) end
                    ESX.Game.DeleteObject(Cache.shell_object)
                    Cache.shell_object = nil
                    for i = 1, 25 do
                        ESX.SetEntityCoords(PlayerPedId(), data.Entercoords)
                        Wait(50)
                    end
                    while IsEntityWaitingForWorldCollision(PlayerPedId()) do
                        ESX.SetEntityCoords(PlayerPedId(), data.Entercoords)
                        Wait(50)
                    end
                    SetEntityHeading(PlayerPedId(),data.Entercoords.w)
                    DoScreenFadeIn(1500)
                    Wait(3000)
                    SetEntityVisible(PlayerPedId(), true)
                    return
                end
            end
        end
    end)
end

PreviewGarage = function(data)
    DoScreenFadeOut(750)
    ESX.Streaming.RequestModel(data.Shellgarage)
    ESX.Game.SpawnLocalObject(data.Shellgarage,Config.GaragePosition,function(obj)
        Cache.shell_object = obj
        SetEntityHeading(Cache.shell_object, 0.0)
        FreezeEntityPosition(Cache.shell_object, true)
        while not IsScreenFadedOut() do Wait(0) end
        local newcoords = Config.ShellCoords[data.Shellgarage].Join.xyz + Config.GaragePosition
        for i = 1, 25 do
            ESX.SetEntityCoords(PlayerPedId(),newcoords)
            Wait(50)
        end
        while IsEntityWaitingForWorldCollision(PlayerPedId()) do
            ESX.SetEntityCoords(PlayerPedId(),newcoords)
            Wait(50)
        end
        SetEntityHeading(PlayerPedId(),Config.ShellCoords[data.Shellgarage].Join.w)
        DoScreenFadeIn(1500)
        Citizen.CreateThread(function()
            while Cache.shell_object do
                Wait(0)
                local Players = ESX.Game.GetPlayers()
                for k,v in pairs(Players) do
                    if PlayerId() ~= v then
                        SetEntityVisible(GetPlayerPed(v), false, false)
                        SetEntityNoCollisionEntity(GetPlayerPed(v), PlayerPedId(), false)
                    end
                end
            end
            Wait(2000)
            local Players = ESX.Game.GetPlayers()
            for k,v in pairs(Players) do
                if PlayerId() ~= v then
                    SetEntityVisible(GetPlayerPed(v), true, false)
                end
            end
        end)
        while Cache.shell_object do
            Wait(0)
            if ESX.GetDistance(newcoords,GetEntityCoords(PlayerPedId())) <= 2 then
                ESX.Game.Utils.Draw3D(newcoords,'~INPUT_CONTEXT~ Jahat khoruj')
                if IsControlJustReleased(0,38) then
                    DoScreenFadeOut(750)
                    while not IsScreenFadedOut() do Wait(0) end
                    ESX.Game.DeleteObject(Cache.shell_object)
                    Cache.shell_object = nil
                    for i = 1, 25 do
                        ESX.SetEntityCoords(PlayerPedId(), data.Entercoords)
                        Wait(50)
                    end
                    while IsEntityWaitingForWorldCollision(PlayerPedId()) do
                        ESX.SetEntityCoords(PlayerPedId(), data.Entercoords)
                        Wait(50)
                    end
                    SetEntityHeading(PlayerPedId(),data.Entercoords.w)
                    DoScreenFadeIn(1500)
                    Wait(3000)
                    SetEntityVisible(PlayerPedId(), true)
                    return
                end
            end
        end
    end)
end

LoadModel = function(model)
    local ogmodel = model
    if type(model) == "string" then model = GetHashKey(model) elseif type(model) ~= "number" then return {loaded = false, model = model} end
    local timer = GetGameTimer() + 10000

    AddTextEntry("LOADING",'Load objects')
    BeginTextCommandBusyspinnerOn("LOADING")
    EndTextCommandBusyspinnerOn(3)

    if not HasModelLoaded(model) and IsModelInCdimage(model) then
        RequestModel(model)
        while not HasModelLoaded(model) and timer >= GetGameTimer() do
            Wait(1)
        end
    end

    BusyspinnerOff()

    if HasModelLoaded(model) then
        if not Cache.RemoveModels then Cache.RemoveModels = {} end
        table.insert(Cache.RemoveModels, {
            Model = model,
            Remove = GetGameTimer() + 5000,
        })

        return {loaded = true, model = model}
    else
        if not IsModelInCdimage(model) then
            ESX.ShowNotification("Model " .. ogmodel .. " is not in cd image")
        else
            ESX.ShowNotification("Contact your server owner, the model couldn't load (doesn't exist?): " .. ogmodel)
        end
        return {loaded = false, model = model}
    end
end

function EnterHouse(data, garage)
    if HouseId ~= 0 and not garage then return end
    Access = 1
    local data = data
    local id = data.Id
    HouseId = id
    stressThread()
    ESX.TriggerServerCallback("sunset_housing:FindSpace", function(space)
        if space ~= 0 then
            ESX.TriggerServerCallback("sunset_housing:GetHouseData", function(hdata)
                DoScreenFadeOut(750)
                ESX.Streaming.RequestModel(data.Shell)
                ESX.Game.SpawnLocalObject(data.Shell,Config.HousePosition,function(obj)
                    Cache.shell_object = obj
                    SetEntityHeading(Cache.shell_object, 0.0)
                    FreezeEntityPosition(Cache.shell_object, true)
                    local newcoords = Config.ShellCoords[data.Shell].Join.xyz + Config.HousePosition
                    while not IsScreenFadedOut() do Wait(0) end
                    for i = 1, 25 do
                        ESX.SetEntityCoords(PlayerPedId(),newcoords)
                        Wait(50)
                    end
                    while IsEntityWaitingForWorldCollision(PlayerPedId()) do
                        ESX.SetEntityCoords(PlayerPedId(),newcoords)
                        Wait(50)
                    end
                    SetEntityHeading(PlayerPedId(),Config.ShellCoords[data.Shell].Join.w)
                    DoScreenFadeIn(1500)
                    ObjectList = hdata.objects
                    for k, v in pairs(ObjectList) do
                        local Model = LoadModel(v.item.object)
                        if Model.loaded then
                            ESX.Game.SpawnLocalObject(Model.model,GetOffsetFromEntityInWorldCoords(Cache.shell_object, v.pos.x, v.pos.y, v.pos.z),function(object)
                                FreezeEntityPosition(object, true)
                                ESX.SetEntityCoordsNoOffset(object, GetOffsetFromEntityInWorldCoords(Cache.shell_object, v.pos.x, v.pos.y, v.pos.z))
                                if v.rot then SetEntityRotation(object,v.rot.x * 1.0,v.rot.y * 1.0,v.rot.z * 1.0,2) end
                                SetEntityCollision(object,true,true)
                                if Config.LockerHash[Model.model] then
                                    Citizen.CreateThread(function()
                                        local near = false
                                        while DoesEntityExist(object) do
                                            Wait(5)
                                            local distance = ESX.GetDistance(GetEntityCoords(PlayerPedId()),GetEntityCoords(object))
                                            if distance <= 2 then
                                                ESX.ShowHelpNotification('Dokme ~INPUT_CONTEXT~ jahat baz kardan inventory')
                                                near = true
                                                if IsControlJustReleased(0,  51) then
                                                    OpenInventory()
                                                end
                                            elseif near then
                                                near = false
                                                exports.icon_menu:ForceCloseMenu()
                                            end
                                        end
                                    end)
                                end
                                if Config.SafeHash[Model.model] then
                                    Citizen.CreateThread(function()
                                        local near = false
                                        while DoesEntityExist(object) do
                                            Wait(5)
                                            local distance = ESX.GetDistance(GetEntityCoords(PlayerPedId()),GetEntityCoords(object))
                                            if distance <= 2 then
                                                ESX.ShowHelpNotification('Dokme ~INPUT_CONTEXT~ jahat baz kardan gav sandogh')
                                                near = true
                                                if IsControlJustReleased(0,  51) then
                                                    OpenSafe()
                                                end
                                            elseif near then
                                                near = false
                                                exports.icon_menu:ForceCloseMenu()
                                            end
                                        end
                                    end)
                                end
                                table.insert(SpawnedObject,object)
                            end)
                        end
                    end
                    TriggerEvent('Allhousing:Enter',id,Cache.shell_object)
                    TriggerEvent('Allhousing:OpenFurni')
                    while Cache.shell_object ~= 0 do
                        Wait(0)
                        local distance = ESX.GetDistance(newcoords,GetEntityCoords(PlayerPedId()))
                        if distance < 3 then
                            ESX.Game.Utils.Draw3D(newcoords,'~INPUT_CONTEXT~ Open menu')
                            if IsControlJustReleased(0,38) then
                                HouseMenu(id,data)
                            end
                        elseif distance > 200 then
                            TriggerEvent('Allhousing:Leave')
                            ESX.UI.Menu.CloseAll()
                            DoScreenFadeOut(750)
                            while not IsScreenFadedOut() do Wait(0) end
                            for k , v in pairs(SpawnedObject) do
                                ESX.Game.DeleteLocalObject(v)
                            end
                            SpawnedObject = {}
                            ESX.Game.DeleteLocalObject(Cache.shell_object)
                            Cache.shell_object = 0
                            HouseId = 0
                            for i = 1, 25 do
                                ESX.SetEntityCoords(PlayerPedId(),data.Entercoords)
                                Wait(50)
                            end
                            while IsEntityWaitingForWorldCollision(PlayerPedId()) do
                                ESX.SetEntityCoords(PlayerPedId(),data.Entercoords)
                                Wait(50)
                            end
                            SetEntityHeading(PlayerPedId(),data.Entercoords.w)
                            DoScreenFadeIn(1500)
                            TriggerServerEvent('sunset_housing:Exit')
                            break
                        end
                    end
                end)
            end,id)
        else
            ESX.ShowNotification('Yek bug vojoud darad,in mored ro be developer gozaresh dahid')
        end
    end,id)
end

function EnterHouseAP(id, garage)
    if HouseId ~= 0 and not garage then return end
    Access = 1
    reqHouse(id)
    local data = Config.Houses[id]
    local id = data.Id
    HouseId = id
    stressThread()
    ESX.TriggerServerCallback("sunset_housing:FindSpace", function(space)
        if space ~= 0 then
            ESX.TriggerServerCallback("sunset_housing:GetHouseData", function(hdata)
                DoScreenFadeOut(750)
                ESX.Streaming.RequestModel(data.Shell)
                ESX.Game.SpawnLocalObject(data.Shell,Config.HousePosition,function(obj)
                    Cache.shell_object = obj
                    SetEntityHeading(Cache.shell_object, 0.0)
                    FreezeEntityPosition(Cache.shell_object, true)
                    local newcoords = Config.ShellCoords[data.Shell].Join.xyz + Config.HousePosition
                    while not IsScreenFadedOut() do Wait(0) end
                    for i = 1, 25 do
                        ESX.SetEntityCoords(PlayerPedId(),newcoords)
                        Wait(50)
                    end
                    while IsEntityWaitingForWorldCollision(PlayerPedId()) do
                        ESX.SetEntityCoords(PlayerPedId(),newcoords)
                        Wait(50)
                    end
                    SetEntityHeading(PlayerPedId(),Config.ShellCoords[data.Shell].Join.w)
                    DoScreenFadeIn(1500)
                    ObjectList = hdata.objects
                    for k, v in pairs(ObjectList) do
                        local Model = LoadModel(v.item.object)
                        if Model.loaded then
                            ESX.Game.SpawnLocalObject(Model.model,GetOffsetFromEntityInWorldCoords(Cache.shell_object, v.pos.x, v.pos.y, v.pos.z),function(object)
                                FreezeEntityPosition(object, true)
                                ESX.SetEntityCoordsNoOffset(object, GetOffsetFromEntityInWorldCoords(Cache.shell_object, v.pos.x, v.pos.y, v.pos.z))
                                if v.rot then SetEntityRotation(object,v.rot.x * 1.0,v.rot.y * 1.0,v.rot.z * 1.0,2) end
                                if Config.LockerHash[Model.model] then
                                    Citizen.CreateThread(function()
                                        local near = false
                                        while DoesEntityExist(object) do
                                            Wait(5)
                                            local distance = ESX.GetDistance(GetEntityCoords(PlayerPedId()),GetEntityCoords(object))
                                            if distance <= 2 then
                                                ESX.ShowHelpNotification('Dokme ~INPUT_CONTEXT~ jahat baz kardan inventory')
                                                near = true
                                                if IsControlJustReleased(0,  51) then
                                                    OpenInventory()
                                                end
                                            elseif near then
                                                near = false
                                                exports.icon_menu:ForceCloseMenu()
                                            end
                                        end
                                    end)
                                end
                                if Config.SafeHash[Model.model] then
                                    Citizen.CreateThread(function()
                                        local near = false
                                        while DoesEntityExist(object) do
                                            Wait(5)
                                            local distance = ESX.GetDistance(GetEntityCoords(PlayerPedId()),GetEntityCoords(object))
                                            if distance <= 2 then
                                                ESX.ShowHelpNotification('Dokme ~INPUT_CONTEXT~ jahat baz kardan gav sandogh')
                                                near = true
                                                if IsControlJustReleased(0,  51) then
                                                    OpenSafe()
                                                end
                                            elseif near then
                                                near = false
                                                exports.icon_menu:ForceCloseMenu()
                                            end
                                        end
                                    end)
                                end
                                table.insert(SpawnedObject,object)
                            end)
                        end
                    end
                    TriggerEvent('Allhousing:Enter',id,Cache.shell_object)
                    TriggerEvent('Allhousing:OpenFurni')
                    while Cache.shell_object ~= 0 do
                        Wait(0)
                        local distance = ESX.GetDistance(newcoords,GetEntityCoords(PlayerPedId()))
                        if distance < 3 then
                            ESX.Game.Utils.Draw3D(newcoords,'~INPUT_CONTEXT~ Open menu')
                            if IsControlJustReleased(0,38) then
                                HouseMenuAP(id,data)
                            end
                        elseif distance > 200 then
                            TriggerEvent('Allhousing:Leave')
                            ESX.UI.Menu.CloseAll()
                            DoScreenFadeOut(750)
                            while not IsScreenFadedOut() do Wait(0) end
                            for k , v in pairs(SpawnedObject) do
                                ESX.Game.DeleteLocalObject(v)
                            end
                            SpawnedObject = {}
                            ESX.Game.DeleteLocalObject(Cache.shell_object)
                            Cache.shell_object = 0
                            HouseId = 0
                            for i = 1, 25 do
                                ESX.SetEntityCoords(PlayerPedId(),data.Entercoords)
                                Wait(50)
                            end
                            while IsEntityWaitingForWorldCollision(PlayerPedId()) do
                                ESX.SetEntityCoords(PlayerPedId(),data.Entercoords)
                                Wait(50)
                            end
                            SetEntityHeading(PlayerPedId(),data.Entercoords.w)
                            DoScreenFadeIn(1500)
                            TriggerServerEvent('sunset_housing:Exit')
                            break
                        end
                    end
                end)
            end,id)
        else
            ESX.ShowNotification('Yek bug vojoud darad,in mored ro be developer gozaresh dahid')
        end
    end,id)
end

function EnterHouseKey(data, garage)
    if HouseId ~= 0 and not garage then return end
    Access = 2
    local data = data
    local id = data.Id
    HouseId = id
    stressThread()
    ESX.TriggerServerCallback("sunset_housing:FindSpace", function(space)
        if space ~= 0 then
            ESX.TriggerServerCallback("sunset_housing:GetHouseData", function(hdata)
                DoScreenFadeOut(750)
                ESX.Streaming.RequestModel(data.Shell)
                ESX.Game.SpawnLocalObject(data.Shell,Config.HousePosition,function(obj)
                    Cache.shell_object = obj
                    SetEntityHeading(Cache.shell_object, 0.0)
                    FreezeEntityPosition(Cache.shell_object, true)
                    local newcoords = Config.ShellCoords[data.Shell].Join.xyz + Config.HousePosition
                    while not IsScreenFadedOut() do Wait(0) end
                    for i = 1, 25 do
                        ESX.SetEntityCoords(PlayerPedId(),newcoords)
                        Wait(50)
                    end
                    while IsEntityWaitingForWorldCollision(PlayerPedId()) do
                        ESX.SetEntityCoords(PlayerPedId(),newcoords)
                        Wait(50)
                    end
                    SetEntityHeading(PlayerPedId(),Config.ShellCoords[data.Shell].Join.w)
                    DoScreenFadeIn(1500)
                    ObjectList = hdata.objects
                    for k, v in pairs(ObjectList) do
                        local Model = LoadModel(v.item.object)
                        if Model.loaded then
                            ESX.Game.SpawnLocalObject(Model.model,GetOffsetFromEntityInWorldCoords(Cache.shell_object, v.pos.x, v.pos.y, v.pos.z),function(object)
                                FreezeEntityPosition(object, true)
                                ESX.SetEntityCoordsNoOffset(object, GetOffsetFromEntityInWorldCoords(Cache.shell_object, v.pos.x, v.pos.y, v.pos.z))
                                if v.rot then SetEntityRotation(object,v.rot.x * 1.0,v.rot.y * 1.0,v.rot.z * 1.0,2) end
                                if Config.LockerHash[Model.model] then
                                    Citizen.CreateThread(function()
                                        local near = false
                                        while DoesEntityExist(object) do
                                            Wait(5)
                                            local distance = ESX.GetDistance(GetEntityCoords(PlayerPedId()),GetEntityCoords(object))
                                            if distance <= 2 then
                                                ESX.ShowHelpNotification('Dokme ~INPUT_CONTEXT~ jahat baz kardan inventory')
                                                near = true
                                                if IsControlJustReleased(0,  51) then
                                                    OpenInventory()
                                                end
                                            elseif near then
                                                near = false
                                                exports.icon_menu:ForceCloseMenu()
                                            end
                                        end
                                    end)
                                end
                                table.insert(SpawnedObject,object)
                            end)
                        end
                    end
                    TriggerEvent('Allhousing:Enter',id,Cache.shell_object)
                    TriggerEvent('Allhousing:OpenFurni')
                    while Cache.shell_object ~= 0 do
                        Wait(0)
                        local distance = ESX.GetDistance(newcoords,GetEntityCoords(PlayerPedId()))
                        if distance < 3 then
                            ESX.Game.Utils.Draw3D(newcoords,'~INPUT_CONTEXT~ Open menu')
                            if IsControlJustReleased(0,38) then
                                HouseMenuKey(id,data)
                            end
                        elseif distance > 200 then
                            TriggerEvent('Allhousing:Leave')
                            ESX.UI.Menu.CloseAll()
                            DoScreenFadeOut(750)
                            while not IsScreenFadedOut() do Wait(0) end
                            for k , v in pairs(SpawnedObject) do
                                ESX.Game.DeleteLocalObject(v)
                            end
                            SpawnedObject = {}
                            ESX.Game.DeleteLocalObject(Cache.shell_object)
                            Cache.shell_object = 0
                            HouseId = 0
                            for i = 1, 25 do
                                ESX.SetEntityCoords(PlayerPedId(),data.Entercoords)
                                Wait(50)
                            end
                            while IsEntityWaitingForWorldCollision(PlayerPedId()) do
                                ESX.SetEntityCoords(PlayerPedId(),data.Entercoords)
                                Wait(50)
                            end
                            SetEntityHeading(PlayerPedId(),data.Entercoords.w)
                            DoScreenFadeIn(1500)
                            TriggerServerEvent('sunset_housing:Exit')
                            break
                        end
                    end
                end)
            end,id)
        else
            ESX.ShowNotification('Yek bug vojoud darad,in mored ro be developer gozaresh dahid')
        end
    end,id)
end

function EnterHouseGuest(data, garage)
    if HouseId ~= 0 and not garage then return end
    Access = 3
    local data = data
    local id = data.Id
    HouseId = id
    stressThread()
    ESX.TriggerServerCallback("sunset_housing:FindSpace", function(space)
        if space ~= 0 then
            ESX.TriggerServerCallback("sunset_housing:GetHouseData", function(hdata)
                DoScreenFadeOut(750)
                ESX.Streaming.RequestModel(data.Shell)
                ESX.Game.SpawnLocalObject(data.Shell,Config.HousePosition,function(obj)
                    Cache.shell_object = obj
                    SetEntityHeading(Cache.shell_object, 0.0)
                    FreezeEntityPosition(Cache.shell_object, true)
                    local newcoords = Config.ShellCoords[data.Shell].Join.xyz + Config.HousePosition
                    while not IsScreenFadedOut() do Wait(0) end
                    for i = 1, 25 do
                        ESX.SetEntityCoords(PlayerPedId(),newcoords)
                        Wait(50)
                    end
                    while IsEntityWaitingForWorldCollision(PlayerPedId()) do
                        ESX.SetEntityCoords(PlayerPedId(),newcoords)
                        Wait(50)
                    end
                    SetEntityHeading(PlayerPedId(),Config.ShellCoords[data.Shell].Join.w)
                    DoScreenFadeIn(1500)
                    ObjectList = hdata.objects
                    for k, v in pairs(ObjectList) do
                        local Model = LoadModel(v.item.object)
                        if Model.loaded then
                            ESX.Game.SpawnLocalObject(Model.model,GetOffsetFromEntityInWorldCoords(Cache.shell_object, v.pos.x, v.pos.y, v.pos.z),function(object)
                                FreezeEntityPosition(object, true)
                                ESX.SetEntityCoordsNoOffset(object, GetOffsetFromEntityInWorldCoords(Cache.shell_object, v.pos.x, v.pos.y, v.pos.z))
                                if v.rot then SetEntityRotation(object,v.rot.x * 1.0,v.rot.y * 1.0,v.rot.z * 1.0,2) end
                                table.insert(SpawnedObject,object)
                            end)
                        end
                    end
                    while Cache.shell_object ~= 0 do
                        Wait(0)
                        local distance = ESX.GetDistance(newcoords,GetEntityCoords(PlayerPedId()))
                        if distance < 3 then
                            ESX.Game.Utils.Draw3D(newcoords,'~INPUT_CONTEXT~ Open menu')
                            if IsControlJustReleased(0,38) then
                                HouseMenu2(id,data)
                            end
                        elseif distance > 200 then
                            ESX.UI.Menu.CloseAll()
                            DoScreenFadeOut(750)
                            while not IsScreenFadedOut() do Wait(0) end
                            for k , v in pairs(SpawnedObject) do
                                ESX.Game.DeleteLocalObject(v)
                            end
                            SpawnedObject = {}
                            ESX.Game.DeleteLocalObject(Cache.shell_object)
                            Cache.shell_object = 0
                            HouseId = 0
                            for i = 1, 25 do
                                ESX.SetEntityCoords(PlayerPedId(),data.Entercoords)
                                Wait(50)
                            end
                            while IsEntityWaitingForWorldCollision(PlayerPedId()) do
                                ESX.SetEntityCoords(PlayerPedId(),data.Entercoords)
                                Wait(50)
                            end
                            SetEntityHeading(PlayerPedId(),data.Entercoords.w)
                            DoScreenFadeIn(1500)
                            TriggerServerEvent('sunset_housing:Exit')
                            break
                        end
                    end
                end)
            end,id)
        else
            ESX.ShowNotification('Yek bug vojoud darad,in mored ro be developer gozaresh dahid')
        end
    end,id)
end

function HouseMenu(id,hdata)
    local List = {}
    reqHouse(HouseId)
    if Config.Houses[HouseId].Garagecoords ~= 'no' then
        table.insert(List,{
            img = 'SS_gold.png',
            text = 'Garage',
            text2 = '',
            callBack = function()
                local hdata = Config.Houses[HouseId]
                for k , v in pairs(SpawnedVehicle) do
                    ESX.Game.DeleteVehicle2(v)
                end
                SpawnedVehicle = {}
                TriggerEvent('Allhousing:Leave')
                DoScreenFadeOut(750)
                while not IsScreenFadedOut() do Wait(0) end
                for k , v in pairs(SpawnedObject) do
                    ESX.Game.DeleteLocalObject(v)
                end
                SpawnedObject = {}
                ESX.Game.DeleteLocalObject(Cache.shell_object)
                Cache.shell_object = 0
                ESX.TriggerServerCallback('sunset_housing:GetHouseGarage',function(cb)
                    exports.icon_menu:ForceCloseMenu()
                    if hdata.Owner == ESX.GetPlayerData().identifier then
                        EnterGarage(hdata,cb,true)
                    else
                        EnterGarage(hdata,cb,false)
                    end
                end,HouseId)
        end})
    end
    table.insert(List,{
        img = 'SS_gold.png',
        text = 'List afrad poshte dar',
        text2 = '',
        callBack = function()
            exports.icon_menu:ForceCloseMenu()
            ESX.TriggerServerCallback("sunset_housing:GetPosht", function(players)
                local List = {}
                for k, v in pairs(players) do
                    table.insert(List,{
                        img = 'SS_gold.png',
                        text = v.name,
                        text2 = '',
                        callBack = function()
                            exports.icon_menu:ForceCloseMenu()
                            TriggerServerEvent('sunset_housing:AcceptInvite',v.id,id)
                    end})
                end
                exports.icon_menu:OpenMenu(List, configs)
            end,id)
    end})
    table.insert(List,{
        img = 'SS_gold.png',
        text = 'Kick',
        text2 = '',
        callBack = function()
            exports.icon_menu:ForceCloseMenu()
            ESX.TriggerServerCallback("sunset_housing:GetPlayersInHouse", function(players)
                if players then
                    local List = {}
                    for k, v in pairs(players) do
                        table.insert(List,{
                            img = 'SS_gold.png',
                            text = v.name,
                            text2 = '',
                            callBack = function()
                                exports.icon_menu:ForceCloseMenu()
                                TriggerServerEvent("sunset_housing:kickOut", id, v.id)
                        end})
                    end
                    exports.icon_menu:OpenMenu(List, configs)
                end
            end,id)
    end})
    table.insert(List,{
        img = 'SS_gold.png',
        text = 'Manage key',
        text2 = '',
        callBack = function()
            local List = {}
            table.insert(List,{
                img = 'SS_gold.png',
                text = 'Give key',
                text2 = '',
                callBack = function()
                    ESX.TriggerServerCallback("sunset_housing:GetPlayersInHouse", function(players)
                        if players then
                            if ESX.TableLength(players) > 0 then
                                ESX.TriggerServerCallback("sunset_housing:GetHouseKey", function(keydata)
                                    local List = {}
                                    for k, v in pairs(players) do
                                        if not keydata[v.hex] then
                                            table.insert(List,{
                                                img = 'SS_gold.png',
                                                text = v.name,
                                                text2 = '',
                                                callBack = function()
                                                    exports.icon_menu:ForceCloseMenu()
                                                    TriggerServerEvent("sunset_housing:GiveKey", id, v.hex)
                                            end})
                                        end
                                    end
                                    if ESX.TableLength(List) > 0 then
                                        exports.icon_menu:ForceCloseMenu()
                                        exports.icon_menu:OpenMenu(List, configs)
                                    else
                                        ESX.Alert('Warning','Kasi ra dar khane invite nakardid',5000,'warning')
                                    end
                                end,id)
                            else
                                ESX.Alert('Warning','Kasi ra dar khane invite nakardid',5000,'warning')
                            end
                        end
                    end,id)
            end})
            table.insert(List,{
                img = 'SS_gold.png',
                text = 'Remove key',
                text2 = '',
                callBack = function()
                    ESX.TriggerServerCallback("sunset_housing:GetHouseKey", function(keydata)
                        local List = {}
                        for k, v in pairs(keydata) do
                            table.insert(List,{
                                img = 'SS_gold.png',
                                text = v,
                                text2 = '',
                                callBack = function()
                                    exports.icon_menu:ForceCloseMenu()
                                    TriggerServerEvent("sunset_housing:RemoveKey", id, k)
                            end})
                        end
                        if ESX.TableLength(List) > 0 then
                            exports.icon_menu:ForceCloseMenu()
                            exports.icon_menu:OpenMenu(List, configs)
                        else
                            ESX.Alert('Warning','Shoma be kasi kelid nadadid',5000,'warning')
                        end
                    end,id)
            end})
            exports.icon_menu:OpenMenu(List, configs)
    end})
    table.insert(List,{
        img = 'SS_gold.png',
        text = 'Open Post Box',
        text2 = '',
        callBack = function()
            openPostBox(HouseId, true)
    end})
    table.insert(List,{
        img = 'SS_gold.png',
        text = 'Object menu',
        text2 = '',
        callBack = function()
            exports.icon_menu:ForceCloseMenu()
            ObjectMenu()
    end})
    table.insert(List,{
        img = 'SS_gold.png',
        text = 'Ped menu',
        text2 = '',
        callBack = function()
            exports.icon_menu:ForceCloseMenu()
            pedMenu()
    end})
    table.insert(List,{
        img = 'SS_gold.png',
        text = 'Exit',
        text2 = '',
        callBack = function()
            exports.icon_menu:ForceCloseMenu()
            TriggerEvent('Allhousing:Leave')
            DoScreenFadeOut(750)
            while not IsScreenFadedOut() do Wait(0) end
            for k , v in pairs(SpawnedObject) do
                ESX.Game.DeleteLocalObject(v)
            end
            SpawnedObject = {}
            ESX.Game.DeleteLocalObject(Cache.shell_object)
            Cache.shell_object = 0
            HouseId = 0
            for i = 1, 25 do
                ESX.SetEntityCoords(PlayerPedId(),hdata.Entercoords)
                Wait(50)
            end
            while IsEntityWaitingForWorldCollision(PlayerPedId()) do
                ESX.SetEntityCoords(PlayerPedId(),hdata.Entercoords)
                Wait(50)
            end
            SetEntityHeading(PlayerPedId(),hdata.Entercoords.w)
            DoScreenFadeIn(1500)
            TriggerServerEvent('sunset_housing:Exit')
    end})
    exports.icon_menu:OpenMenu(List, configs)
end

function HouseMenuAP(id,hdata)
    local List = {}
    table.insert(List,{
        img = 'SS_gold.png',
        text = 'List afrad poshte dar',
        text2 = '',
        callBack = function()
            exports.icon_menu:ForceCloseMenu()
            ESX.TriggerServerCallback("sunset_housing:GetPosht", function(players)
                local List = {}
                for k, v in pairs(players) do
                    table.insert(List,{
                        img = 'SS_gold.png',
                        text = v.name,
                        text2 = '',
                        callBack = function()
                            exports.icon_menu:ForceCloseMenu()
                            TriggerServerEvent('sunset_housing:AcceptInvite',v.id,id)
                    end})
                end
                exports.icon_menu:OpenMenu(List, configs)
            end,id)
    end})
    table.insert(List,{
        img = 'SS_gold.png',
        text = 'Kick',
        text2 = '',
        callBack = function()
            exports.icon_menu:ForceCloseMenu()
            ESX.TriggerServerCallback("sunset_housing:GetPlayersInHouse", function(players)
                if players then
                    local List = {}
                    for k, v in pairs(players) do
                        table.insert(List,{
                            img = 'SS_gold.png',
                            text = v.name,
                            text2 = '',
                            callBack = function()
                                exports.icon_menu:ForceCloseMenu()
                                TriggerServerEvent("sunset_housing:kickOut", id, v.id)
                        end})
                    end
                    exports.icon_menu:OpenMenu(List, configs)
                end
            end,id)
    end})
    table.insert(List,{
        img = 'SS_gold.png',
        text = 'Open Post Box',
        text2 = '',
        callBack = function()
            openPostBox(HouseId, true)
    end})
    table.insert(List,{
        img = 'SS_gold.png',
        text = 'Object menu',
        text2 = '',
        callBack = function()
            exports.icon_menu:ForceCloseMenu()
            ObjectMenu()
    end})
    table.insert(List,{
        img = 'SS_gold.png',
        text = 'Ped menu',
        text2 = '',
        callBack = function()
            exports.icon_menu:ForceCloseMenu()
            pedMenu()
    end})
    table.insert(List,{
        img = 'SS_gold.png',
        text = 'Exit',
        text2 = '',
        callBack = function()
            exports.icon_menu:ForceCloseMenu()
            TriggerEvent('Allhousing:Leave')
            DoScreenFadeOut(750)
            while not IsScreenFadedOut() do Wait(0) end
            for k , v in pairs(SpawnedObject) do
                ESX.Game.DeleteLocalObject(v)
            end
            SpawnedObject = {}
            ESX.Game.DeleteLocalObject(Cache.shell_object)
            Cache.shell_object = 0
            HouseId = 0
            for i = 1, 25 do
                ESX.SetEntityCoords(PlayerPedId(),hdata.Entercoords)
                Wait(50)
            end
            while IsEntityWaitingForWorldCollision(PlayerPedId()) do
                ESX.SetEntityCoords(PlayerPedId(),hdata.Entercoords)
                Wait(50)
            end
            SetEntityHeading(PlayerPedId(),hdata.Entercoords.w)
            if NearKeyAP == 'nmxjktzwc36xiy3drohv56cv' then
                CreateThread(function()
                    TriggerEvent('es_admin:freezePlayer', true)
                    Wait(6000)
                    TriggerEvent('es_admin:freezePlayer', false)
                    ESX.Game.Teleport(PlayerPedId(), hdata.Entercoords)
                end)
            end
            DoScreenFadeIn(1500)
            TriggerServerEvent('sunset_housing:Exit')
    end})
    exports.icon_menu:OpenMenu(List, configs)
end

function HouseMenuKey(id,hdata)
    local List = {}
    reqHouse(HouseId)
    if Config.Houses[HouseId].Garagecoords ~= 'no' then
        table.insert(List,{
            img = 'SS_gold.png',
            text = 'Garage',
            text2 = '',
            callBack = function()
                local hdata = Config.Houses[HouseId]
                for k , v in pairs(SpawnedVehicle) do
                    ESX.Game.DeleteVehicle2(v)
                end
                SpawnedVehicle = {}
                TriggerEvent('Allhousing:Leave')
                DoScreenFadeOut(750)
                while not IsScreenFadedOut() do Wait(0) end
                for k , v in pairs(SpawnedObject) do
                    ESX.Game.DeleteLocalObject(v)
                end
                SpawnedObject = {}
                ESX.Game.DeleteLocalObject(Cache.shell_object)
                Cache.shell_object = 0
                ESX.TriggerServerCallback('sunset_housing:GetHouseGarage',function(cb)
                    exports.icon_menu:ForceCloseMenu()
                    if hdata.Owner == ESX.GetPlayerData().identifier then
                        EnterGarage(hdata,cb,true)
                    else
                        EnterGarage(hdata,cb,false)
                    end
                end,HouseId)
        end})
    end

    table.insert(List,{
        img = 'SS_gold.png',
        text = 'List afrad poshte dar',
        text2 = '',
        callBack = function()
            exports.icon_menu:ForceCloseMenu()
            ESX.TriggerServerCallback("sunset_housing:GetPosht", function(players)
                local List = {}
                for k, v in pairs(players) do
                    table.insert(List,{
                        img = 'SS_gold.png',
                        text = v.name,
                        text2 = '',
                        callBack = function()
                            exports.icon_menu:ForceCloseMenu()
                            TriggerServerEvent('sunset_housing:AcceptInvite',v.id,id)
                    end})
                end
                exports.icon_menu:OpenMenu(List, configs)
            end,id)
    end})
    table.insert(List,{
        img = 'SS_gold.png',
        text = 'Kick',
        text2 = '',
        callBack = function()
            exports.icon_menu:ForceCloseMenu()
            ESX.TriggerServerCallback("sunset_housing:GetPlayersInHouse", function(players)
                if players then
                    local List = {}
                    for k, v in pairs(players) do
                        table.insert(List,{
                            img = 'SS_gold.png',
                            text = v.name,
                            text2 = '',
                            callBack = function()
                                exports.icon_menu:ForceCloseMenu()
                                TriggerServerEvent("sunset_housing:kickOut", id, v.id)
                        end})
                    end
                    exports.icon_menu:OpenMenu(List, configs)
                end
            end,id)
    end})
    -- table.insert(List,{
    --     img = 'SS_gold.png',
    --     text = 'Object menu',
    --     text2 = '',
    --     callBack = function()
    --         exports.icon_menu:ForceCloseMenu()
    --         ObjectMenu()
    -- end})
    table.insert(List,{
        img = 'SS_gold.png',
        text = 'Exit',
        text2 = '',
        callBack = function()
            exports.icon_menu:ForceCloseMenu()
            TriggerEvent('Allhousing:Leave')
            DoScreenFadeOut(750)
            while not IsScreenFadedOut() do Wait(0) end
            for k , v in pairs(SpawnedObject) do
                ESX.Game.DeleteLocalObject(v)
            end
            SpawnedObject = {}
            ESX.Game.DeleteLocalObject(Cache.shell_object)
            Cache.shell_object = 0
            HouseId = 0
            for i = 1, 25 do
                ESX.SetEntityCoords(PlayerPedId(),hdata.Entercoords)
                Wait(50)
            end
            while IsEntityWaitingForWorldCollision(PlayerPedId()) do
                ESX.SetEntityCoords(PlayerPedId(),hdata.Entercoords)
                Wait(50)
            end
            SetEntityHeading(PlayerPedId(),hdata.Entercoords.w)
            DoScreenFadeIn(1500)
            TriggerServerEvent('sunset_housing:Exit')
    end})
    exports.icon_menu:OpenMenu(List, configs)
end

function ObjectMenu()
    local options = {}
    for k, v in pairs(SpawnedObject) do
        table.insert(options, {label = ('#%s'):format(k), args = {v}})
    end
    if #options == 0 then
        ESX.ShowNotification('Hich furniture yaft nashod!')
        return
    end
    local outline
    -- exports.icon_menu:OpenMenu(List, configs)
    lib.registerMenu({
        id = 'he_1',
        title = 'Edit house',
        options = options,
        onSelected = function(selected, secondary, args)
            if outline then
                SetEntityDrawOutline(outline, false)
            end
            outline = args[1]
            SetEntityDrawOutline(args[1], true)
        end,
        onClose = function(keyPressed)
            if outline then
                SetEntityDrawOutline(outline, false)
            end
        end,
    }, function(selected, scrollIndex, args)
        local options = {
            {label = 'Bring', args = 'bring'},
            {label = 'Delete', args = 'delete'}
        }
        local object = args[1]
        lib.registerMenu({
            id = 'he_2',
            title = 'Edit house',
            options = options,
        }, function(selected, scrollIndex, args2)
            if args2 == 'bring' then
                SetEntityCoords(object, GetEntityCoords(PlayerPedId()))
                local id = exports['sunset_housing']:GetObjectId(object)
                local pos = GetEntityCoords(object) - GetEntityCoords(Cache.shell_object)
                local rot = GetEntityRotation(object, 2)
                local data = {
                    pos = pos,
                    rot = rot,
                    id = id
                }
                DeleteEntity(object)
                ESX.TriggerServerEvent('sunset_housing:ReplaceFurniture', HouseId, data)
            elseif args2 == 'delete' then
                local id = exports['sunset_housing']:GetObjectId(object)
                ESX.TriggerServerEvent('sunset_housing:DeleteFurniture',HouseId, id)
            end
        end)
        lib.showMenu('he_2')
    end)
    lib.showMenu('he_1')
    Citizen.Wait(500)
    Citizen.CreateThread(function()
        while lib.getOpenMenu() == 'he_1' do
            Wait(0)
            for k, v in pairs(SpawnedObject) do
                ESX.Game.Utils.DrawText3D(GetEntityCoords(v), "#" .. k, 1.0)
            end
        end
    end)
end
local last = false
local lasthp = 0

function pedMenu()
	local elements = {}
	ESX.TriggerServerCallback('esx_skin:getped', function(data)
        for k , v in pairs(data) do
          if v then
			local used = "❌"
			if v.used then
				used = "✔️"
			end
			table.insert(elements,{label = "Name : ".. k .. " | Expire : ".. v.endtime .. " | Used :"..used,value = k})
          end
        end
		table.insert(elements,{label = "🔄Reset ped🔄",value = "reset"})
		ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'ped', {
			title    = 'Ped menu',
			align    = 'top-left',
			elements = elements
		}, function(data, menu)
			menu.close()
			if last then return ESX.ShowNotification('Dont fucking spam') end
			lasthp = GetEntityHealth(PlayerPedId())
			last = true
			SetTimeout(10000,function()
				last = false
			end)
			TriggerServerEvent('esx_skin:falseall')
			if data.current.value == 'reset' then
				ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(LastSkin, jobSkin)
					local model = nil
					if LastSkin.sex == 0 then
						model = 'mp_m_freemode_01'
					else
						model = 'mp_f_freemode_01'
					end
					TriggerEvent("resetpedHandler",model)
					Wait(500)
					TriggerEvent('skinchanger:loadSkin', LastSkin)
                    exports['sunset_clothe']:removeStuffJob()
                    Citizen.Wait(1000)
                    exports['sunset_clothe']:loadUsed()
					TriggerEvent("esx:restoreLoadout")
				end)
			else
				TriggerEvent("resetpedHandler",data.current.value)
				Wait(500)
				TriggerEvent("esx:restoreLoadout")
				TriggerServerEvent('esx_skin:useped',data.current.value)
			end
			Wait(1000)
			SetEntityMaxHealth(PlayerPedId(),200)
			if lasthp then
				ESX.SetEntityHealth(PlayerPedId(),lasthp)
			end
		end, function(data, menu)
			menu.close()
		end)
    end)
end

function HouseMenu2(id,hdata)
    local List = {}
    reqHouse(HouseId)
    if Config.Houses[HouseId].Garagecoords ~= 'no' then
        table.insert(List,{
            img = 'SS_gold.png',
            text = 'Garage',
            text2 = '',
            callBack = function()
                local hdata = Config.Houses[HouseId]
                for k , v in pairs(SpawnedVehicle) do
                    ESX.Game.DeleteVehicle2(v)
                end
                SpawnedVehicle = {}
                TriggerEvent('Allhousing:Leave')
                DoScreenFadeOut(750)
                while not IsScreenFadedOut() do Wait(0) end
                for k , v in pairs(SpawnedObject) do
                    ESX.Game.DeleteLocalObject(v)
                end
                SpawnedObject = {}
                ESX.Game.DeleteLocalObject(Cache.shell_object)
                Cache.shell_object = 0
                ESX.TriggerServerCallback('sunset_housing:GetHouseGarage',function(cb)
                    exports.icon_menu:ForceCloseMenu()
                    if hdata.Owner == ESX.GetPlayerData().identifier then
                        EnterGarage(hdata,cb,true)
                    else
                        EnterGarage(hdata,cb,false)
                    end
                end,HouseId)
        end})
    end
    table.insert(List,{
        img = 'SS_gold.png',
        text = 'Exit',
        text2 = '',
        callBack = function()
            exports.icon_menu:ForceCloseMenu()
            TriggerEvent('Allhousing:Leave')
            DoScreenFadeOut(750)
            while not IsScreenFadedOut() do Wait(0) end
            for k , v in pairs(SpawnedObject) do
                ESX.Game.DeleteLocalObject(v)
            end
            SpawnedObject = {}
            ESX.Game.DeleteLocalObject(Cache.shell_object)
            Cache.shell_object = 0
            HouseId = 0
            for i = 1, 25 do
                ESX.SetEntityCoords(PlayerPedId(),hdata.Entercoords)
                Wait(50)
            end
            while IsEntityWaitingForWorldCollision(PlayerPedId()) do
                ESX.SetEntityCoords(PlayerPedId(),hdata.Entercoords)
                Wait(50)
            end
            SetEntityHeading(PlayerPedId(),hdata.Entercoords.w)
            DoScreenFadeIn(1500)
            TriggerServerEvent('sunset_housing:Exit')
    end})
    exports.icon_menu:OpenMenu(List, configs)
end

function GarageMenu(id,hdata)
    local List = {}
    table.insert(List,{
        img = 'SS_gold.png',
        text = 'Home',
        text2 = '',
        callBack = function()
            exports.icon_menu:ForceCloseMenu()
            reqHouse(HouseId)
            local hdata = Config.Houses[HouseId]
            for k , v in pairs(SpawnedVehicle) do
                ESX.Game.DeleteVehicle2(v)
            end
            SpawnedVehicle = {}
            TriggerEvent('Allhousing:Leave')
            DoScreenFadeOut(750)
            while not IsScreenFadedOut() do Wait(0) end
            for k , v in pairs(SpawnedObject) do
                ESX.Game.DeleteLocalObject(v)
            end
            SpawnedObject = {}
            ESX.Game.DeleteLocalObject(Cache.shell_object)
            Cache.shell_object = 0
            if Access == 1 then
                EnterHouse(hdata, true)
            elseif Access == 2 then
                EnterHouseKey(hdata, true)
            elseif Access == 3 then
                EnterHouseGuest(hdata, true)
            end
    end})
    if Access == 1 or Access == 2 then
        table.insert(List,{
            img = 'SS_gold.png',
            text = 'List afrad poshte dar',
            text2 = '',
            callBack = function()
                exports.icon_menu:ForceCloseMenu()
                ESX.TriggerServerCallback("sunset_housing:GetPosht", function(players)
                    local List = {}
                    for k, v in pairs(players) do
                        table.insert(List,{
                            img = 'SS_gold.png',
                            text = v.name,
                            text2 = '',
                            callBack = function()
                                exports.icon_menu:ForceCloseMenu()
                                TriggerServerEvent('sunset_housing:AcceptInvite',v.id,id)
                        end})
                    end
                    exports.icon_menu:OpenMenu(List, configs)
                end,id)
        end})
        table.insert(List,{
            img = 'SS_gold.png',
            text = 'Kick',
            text2 = '',
            callBack = function()
                exports.icon_menu:ForceCloseMenu()
                ESX.TriggerServerCallback("sunset_housing:GetPlayersInHouse", function(players)
                    if players then
                        local List = {}
                        for k, v in pairs(players) do
                            table.insert(List,{
                                img = 'SS_gold.png',
                                text = v.name,
                                text2 = '',
                                callBack = function()
                                    exports.icon_menu:ForceCloseMenu()
                                    TriggerServerEvent("sunset_housing:kickOut", id, v.id)
                            end})
                        end
                        exports.icon_menu:OpenMenu(List, configs)
                    end
                end,id)
        end})
    end
    table.insert(List,{
        img = 'SS_gold.png',
        text = 'Exit',
        text2 = '',
        callBack = function()
            exports.icon_menu:ForceCloseMenu()
            ExitKon()
    end})
    exports.icon_menu:OpenMenu(List, configs)
end

function ExitKon()
    reqHouse(HouseId)
    local hdata = Config.Houses[HouseId]
    for k , v in pairs(SpawnedVehicle) do
        ESX.Game.DeleteVehicle2(v)
    end
    SpawnedVehicle = {}
    TriggerEvent('Allhousing:Leave')
    DoScreenFadeOut(750)
    while not IsScreenFadedOut() do Wait(0) end
    for k , v in pairs(SpawnedObject) do
        ESX.Game.DeleteLocalObject(v)
    end
    SpawnedObject = {}
    ESX.Game.DeleteLocalObject(Cache.shell_object)
    Cache.shell_object = 0
    HouseId = 0
    for i = 1, 25 do
        ESX.SetEntityCoords(PlayerPedId(),hdata.Entercoords)
        Wait(50)
    end
    while IsEntityWaitingForWorldCollision(PlayerPedId()) do
        ESX.SetEntityCoords(PlayerPedId(),hdata.Entercoords)
        Wait(50)
    end
    SetEntityHeading(PlayerPedId(),hdata.Entercoords.w)
    DoScreenFadeIn(1500)
    TriggerServerEvent('sunset_housing:Exit')
end

RegisterNetEvent('sunset_housing:ReloadHouseObject')
AddEventHandler('sunset_housing:ReloadHouseObject',function(id)
    if HouseId == id then
        for k , v in pairs(SpawnedObject) do
            ESX.Game.DeleteLocalObject(v)
        end
        local identifier = ESX.GetPlayerData().identifier
        SpawnedObject = {}
        ESX.TriggerServerCallback("sunset_housing:GetHouseData", function(hdata)
            ObjectList = hdata.objects
            for k, v in pairs(ObjectList) do
                local Model = LoadModel(v.item.object)
                if Model.loaded then
                    ESX.Game.SpawnLocalObject(Model.model,GetOffsetFromEntityInWorldCoords(Cache.shell_object, v.pos.x, v.pos.y, v.pos.z),function(object)
                        FreezeEntityPosition(object, true)
                        ESX.SetEntityCoordsNoOffset(object, GetOffsetFromEntityInWorldCoords(Cache.shell_object, v.pos.x, v.pos.y, v.pos.z))
                        if v.rot then SetEntityRotation(object,v.rot.x * 1.0,v.rot.y * 1.0,v.rot.z * 1.0,2) end
                        if Config.LockerHash[Model.model] and (Access == 1 or Access == 2) then
                            Citizen.CreateThread(function()
                                local near = false
                                while DoesEntityExist(object) do
                                    Wait(5)
                                    local distance = ESX.GetDistance(GetEntityCoords(PlayerPedId()),GetEntityCoords(object))
                                    if distance <= 2 then
                                        ESX.ShowHelpNotification('Dokme ~INPUT_CONTEXT~ jahat baz kardan inventory')
                                        near = true
                                        if IsControlJustReleased(0,  51) then
                                            OpenInventory()
                                        end
                                    elseif near then
                                        near = false
                                        exports.icon_menu:ForceCloseMenu()
                                    end
                                end
                            end)
                        end
                        if hdata.owner == identifier then
                            if Config.SafeHash[Model.model] then
                                Citizen.CreateThread(function()
                                    local near = false
                                    while DoesEntityExist(object) do
                                        Wait(5)
                                        local distance = ESX.GetDistance(GetEntityCoords(PlayerPedId()),GetEntityCoords(object))
                                        if distance <= 2 then
                                            ESX.ShowHelpNotification('Dokme ~INPUT_CONTEXT~ jahat baz kardan gav sandogh')
                                            near = true
                                            if IsControlJustReleased(0,  51) then
                                                OpenSafe()
                                            end
                                        elseif near then
                                            near = false
                                            exports.icon_menu:ForceCloseMenu()
                                        end
                                    end
                                end)
                            end
                        end
                        table.insert(SpawnedObject,object)
                    end)
                end
            end
        end,id)
    end
end)

RegisterNetEvent('sunset_housing:JoinGuest')
AddEventHandler('sunset_housing:JoinGuest',function(id)
    KnockedId = 0
    reqHouse(id)
    EnterHouseGuest(Config.Houses[id])
end)

RegisterNetEvent('sunset_housing:ExitMe')
AddEventHandler('sunset_housing:ExitMe',function(id)
    if HouseId == 0 then return end
    reqHouse(HouseId)
    hdata = Config.Houses[HouseId]
    ESX.UI.Menu.CloseAll()
    DoScreenFadeOut(750)
    while not IsScreenFadedOut() do Wait(0) end
    for k , v in pairs(SpawnedObject) do
        ESX.Game.DeleteLocalObject(v)
    end
    SpawnedObject = {}
    ESX.Game.DeleteLocalObject(Cache.shell_object)
    Cache.shell_object = 0
    HouseId = 0
    for i = 1, 25 do
        ESX.SetEntityCoords(PlayerPedId(),hdata.Entercoords)
        Wait(50)
    end
    while IsEntityWaitingForWorldCollision(PlayerPedId()) do
        ESX.SetEntityCoords(PlayerPedId(),hdata.Entercoords)
        Wait(50)
    end
    SetEntityHeading(PlayerPedId(),hdata.Entercoords.w)
    DoScreenFadeIn(1500)
    TriggerServerEvent('sunset_housing:Exit')
end)

local adddata = {}

RegisterNetEvent('housing:editHouse', function()
    ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'get_id', {
        title = "Id khane ra vared konid"
    },
    function(data1,menu1)
        menu1.close()
        if data1.value then
            id = data1.value
            EditHouse(id)
        end
    end, function(data1,menu1)
        menu1.close()
    end)
end)

RegisterNetEvent('housing:addHouse', function()
    AddHouse()
end)

FormatCoord = function(coord)
	if coord == nil then
		return "unknown"
	end

	return tonumber(string.format("%.2f", coord))
end

function AddHouse()
    local List = {}
    local coords = nil
    local interior = nil
    local coordsgarage = nil
    local interiorgarage  = nil
    local price = 0
    if adddata.enter then
        coords = ('vector4(%s,%s,%s,%s)'):format(FormatCoord(adddata.enter.x),FormatCoord(adddata.enter.y),FormatCoord(adddata.enter.z),FormatCoord(adddata.enter.w))
    end
    if adddata.entergarage then
        coordsgarage = ('vector4(%s,%s,%s,%s)'):format(FormatCoord(adddata.entergarage.x),FormatCoord(adddata.entergarage.y),FormatCoord(adddata.entergarage.z),FormatCoord(adddata.entergarage.w))
    end
    table.insert(List,{
        img = 'SS_gold.png',
        text = 'Coords',
        text2 = coords,
        callBack = function()
            exports.icon_menu:ForceCloseMenu()
            local pcoords = GetEntityCoords(PlayerPedId())
            adddata.enter = vector4(pcoords.x,pcoords.y,pcoords.z,GetEntityHeading(PlayerPedId())) - vector4(0,0,1,0)
            adddata.zone = getGridZone()
            AddHouse()
    end})
    if adddata.interior then
        interior = adddata.interior
    end
    table.insert(List,{
        img = 'SS_gold.png',
        text = 'Interior',
        text2 = interior,
        callBack = function()
            exports.icon_menu:ForceCloseMenu()
            ESX.UI.Menu.Open(
            'dialog',
            GetCurrentResourceName(),
            'get_interior',
            {
                title = "Esm inetrior ra vared konid"
            },
            function(data1,menu1)
                menu1.close()
                if data1.value then
                    name = data1.value
                    if Config.ShellCoords[name] then
                        adddata.interior = name
                        AddHouse()
                    else
                        ESX.Alert('Error','In entrior vojoud nadarad',5000,'warning')
                        AddHouse()
                    end
                end
            end, function(data1,menu1)
                menu1.close()
            end)
    end})
    --
    table.insert(List,{
        img = 'SS_gold.png',
        text = 'Coords garage',
        text2 = coordsgarage,
        callBack = function()
            exports.icon_menu:ForceCloseMenu()
            local pcoords = GetEntityCoords(PlayerPedId())
            adddata.entergarage = vector4(pcoords.x,pcoords.y,pcoords.z,GetEntityHeading(PlayerPedId())) - vector4(0,0,1,0)
            AddHouse()
    end})
    if adddata.interiorgarage then
        interiorgarage = adddata.interiorgarage
    end
    table.insert(List,{
        img = 'SS_gold.png',
        text = 'Interior',
        text2 = interiorgarage,
        callBack = function()
            exports.icon_menu:ForceCloseMenu()
            ESX.UI.Menu.Open(
            'dialog',
            GetCurrentResourceName(),
            'get_interior',
            {
                title = "Esm inetrior ra vared konid"
            },
            function(data1,menu1)
                menu1.close()
                if data1.value then
                    name = data1.value
                    if Config.GarageCoords[name] then
                        adddata.interiorgarage = name
                        AddHouse()
                    else
                        ESX.Alert('Error','In interior vojoud nadarad',5000,'warning')
                        AddHouse()
                    end
                end
            end, function(data1,menu1)
                menu1.close()
            end)
    end})
    --
    if adddata.price then
        price = adddata.price
    end
    table.insert(List,{
        img = 'SS_gold.png',
        text = 'Price',
        text2 = ESX.Math.GroupDigits(price),
        callBack = function()
            exports.icon_menu:ForceCloseMenu()
            ESX.UI.Menu.Open(
            'dialog',
            GetCurrentResourceName(),
            'get_interior',
            {
                title = "Enter price"
            },
            function(data1,menu1)
                menu1.close()
                if data1.value then
                    price = tonumber(data1.value)
                    if price and price > 0 then
                        adddata.price = price
                        AddHouse()
                    end
                end
            end, function(data1,menu1)
                menu1.close()
            end)
    end})
    table.insert(List,{
        img = 'SS_gold.png',
        text = 'Confirm',
        text2 = ESX.Math.GroupDigits(price),
        callBack = function()
            exports.icon_menu:ForceCloseMenu()
            if adddata.price > 0 and adddata.interior and adddata.enter and (adddata.entergarage == nil and adddata.interiorgarage == nil or adddata.entergarage and adddata.interiorgarage) then
                TriggerServerEvent('sunset_housing:AddHouse',adddata)
                adddata = {}
            else
                AddHouse()
                ESX.Alert('Error','Data kamel nist',5000,'warning')
            end
    end})
    exports.icon_menu:OpenMenu(List, configs)
end

local editdata = {}
function EditHouse(id)
    local List = {}
    reqHouse(id)
    if Config.Houses[id] then
        local data = Config.Houses[id]
        if editdata.id ~= id then
            editdata = {}
            editdata.id = id
            editdata.coords = data.Entercoords
            editdata.price = data.Price
            editdata.shell = data.Shell
        end
        local coords = editdata.coords
        local coordsstr = ('vector4(%s,%s,%s,%s)'):format(FormatCoord(coords.x),FormatCoord(coords.y),FormatCoord(coords.z),FormatCoord(coords.w))
        table.insert(List,{
            img = 'SS_gold.png',
            text = 'Coords',
            text2 = coordsstr,
            callBack = function()
                exports.icon_menu:ForceCloseMenu()
                local pcoords = GetEntityCoords(PlayerPedId())
                editdata.coords = vector4(pcoords.x,pcoords.y,pcoords.z,GetEntityHeading(PlayerPedId())) - vector4(0,0,1,0)
                EditHouse(id)
        end})
        table.insert(List,{
            img = 'SS_gold.png',
            text = 'Interior',
            text2 = editdata.shell,
            callBack = function()
                exports.icon_menu:ForceCloseMenu()
                ESX.UI.Menu.Open(
                'dialog',
                GetCurrentResourceName(),
                'get_interior',
                {
                    title = "Esm inetrior ra vared konid"
                },
                function(data1,menu1)
                    menu1.close()
                    if data1.value then
                        name = data1.value
                        if Config.ShellCoords[name] then
                            editdata.shell = name
                            EditHouse(id)
                        else
                            ESX.Alert('Error','In entrior vojoud nadarad',5000,'warning')
                            EditHouse(id)
                        end
                    end
                end, function(data1,menu1)
                    menu1.close()
                end)
        end})
        table.insert(List,{
            img = 'SS_gold.png',
            text = 'Price',
            text2 = ESX.Math.GroupDigits(editdata.price),
            callBack = function()
                exports.icon_menu:ForceCloseMenu()
                ESX.UI.Menu.Open(
                'dialog',
                GetCurrentResourceName(),
                'get_interior',
                {
                    title = "Enter price"
                },
                function(data1,menu1)
                    menu1.close()
                    if data1.value then
                        price = tonumber(data1.value)
                        if price > 0 then
                            editdata.price = price
                            EditHouse(id)
                        end
                    end
                end, function(data1,menu1)
                    menu1.close()
                end)
        end})
        table.insert(List,{
            img = 'SS_gold.png',
            text = 'Confirm',
            text2 = ESX.Math.GroupDigits(editdata.price),
            callBack = function()
                exports.icon_menu:ForceCloseMenu()
                TriggerServerEvent('sunset_housing:EditHouse',editdata)
        end})
        table.insert(List,{
            img = 'SS_gold.png',
            text = 'Delete',
            text2 = ESX.Math.GroupDigits(editdata.price),
            callBack = function()
                exports.icon_menu:ForceCloseMenu()
                TriggerServerEvent('sunset_housing:DeleteHouse',editdata)
        end})
        exports.icon_menu:OpenMenu(List, configs)
    else
        ESX.Alert('Error','In khane vojoud nadarad',5000,'error')
    end
end

function OpenInventory()
    ESX.TriggerServerCallback("sunset_housing:GetHouseData", function(hdata)
        local level = hdata.inventorylevel
        local List = {}
        table.insert(List,{
            img = 'SS_gold.png',
            text = 'Open inventory',
            text2 = '',
            callBack = function()
                openInventory(HouseId, nil, hdata)
        end})
        table.insert(List,{
            img = 'SS_gold.png',
            text = 'Inventory level : ' .. level,
            text2 = 'Inventory size : '.. Config.ShellCoords[hdata.shell].InventoryLevel[level].Size,
            callBack = function()
        end})
        if Config.ShellCoords[hdata.shell].InventoryLevel[level + 1] then
            table.insert(List,{
                img = 'SS_gold.png',
                text = 'Upgrade price : ' .. ESX.Math.GroupDigits(Config.ShellCoords[hdata.shell].InventoryLevel[level + 1].Price),
                text2 = 'Upgrade size : '.. Config.ShellCoords[hdata.shell].InventoryLevel[level + 1].Size,
                callBack = function()
                    TriggerServerEvent('sunset_housing:UpgradeHouseInventory',HouseId)
                    exports.icon_menu:ForceCloseMenu()
                    Wait(5000)
                    OpenInventory()
            end})
        end
        table.insert(List,{
            img = 'SS_gold.png',
            text = 'Open old job/gang closet',
            text2 = '',
            callBack = function()
                exports.icon_menu:ForceCloseMenu()
                exports['sunset_utils']:openOldGangCloset();
        end})
        exports.icon_menu:OpenMenu(List, configs)
    end,HouseId)
end

function openInventory(houseId, safe, hdata)
    exports.icon_menu:ForceCloseMenu()
    local max = safe and Config.ShellCoords[hdata.shell].SafeLevel[hdata.safelevel].Size or Config.ShellCoords[hdata.shell].InventoryLevel[hdata.inventorylevel].Size
    local items2 = getHouseInventory(houseId, safe)
    local items = exports['sun-inventory-hud']:sortItems(items2)
    exports['sun-inventory-hud']:openOtherInventory({items = items, timeout = 1000, label = safe and 'Safe' or 'Main'}, function(data)
        if data.type == 'close' then
        elseif data.type == 'update' then
            return exports['sun-inventory-hud']:sortItems(getHouseInventory(houseId, safe))
        elseif data.type == 'moveInside' then
            ESX.TriggerServerEvent('housing:inventory:updateSlot', houseId, items2.hex, data.data)
        elseif data.type == 'moveToOther' then
            if ESX.isDead() then return end
            local items2 = getHouseInventory(houseId, safe)
            local usedBox = 0
            for k, v in pairs(items2.items) do
                if v.count > 0 then
                    usedBox = usedBox + 1
                end
            end
            usedBox = usedBox + ESX.tableLength(items2.weapons)
            if usedBox >= max then
                ESX.Alert('', 'Anbar khane por shode ast', 7000, 'error')
            else
                ESX.TriggerServerEvent('sunset_housing:inventory:put', items2.hex, houseId, data.data.itemType, data.data.name, data.data.count, data.data)
            end
        elseif data.type == 'moveToMain' then
            if ESX.isDead() then return end
            ESX.TriggerServerEvent('sunset_housing:inventory:get', items2.hex, houseId, data.data.itemType, data.data.name, data.data.count, data.data)
            Wait(500)
            if data.data.droppedTo then
                data.data.inventoryType = 'main'
                exports['sun-inventory-hud']:moveInside(data.data)
            end
        end
    end)
end

function getHouseInventory(houseId, safe)
    local p = promise.new()
    if safe == true then
        ESX.TriggerServerCallback('sunset_housing:GetHouseSafe', function(data)
            p:resolve(data)
        end, houseId)
    elseif safe == 1 then
        ESX.TriggerServerCallback('sunset_housing:getHousePostBox', function(data)
            p:resolve(data)
        end, houseId)
    else
        ESX.TriggerServerCallback('sunset_housing:GetHouseInventory', function(data)
            p:resolve(data)
        end, houseId)
    end
    return Citizen.Await(p)
end

function OpenSafe()
    ESX.TriggerServerCallback("sunset_housing:GetHouseData", function(hdata)
        local level = hdata.safelevel
        local List = {}
        table.insert(List,{
            img = 'SS_gold.png',
            text = 'Open safe',
            text2 = '',
            callBack = function()
                openInventory(HouseId, true, hdata)
        end})
        table.insert(List,{
            img = 'SS_gold.png',
            text = 'Safe level : ' .. level,
            text2 = 'Safe size : '.. Config.ShellCoords[hdata.shell].SafeLevel[level].Size,
            callBack = function()
        end})
        if Config.ShellCoords[hdata.shell].SafeLevel[level + 1] then
            table.insert(List,{
                img = 'SS_gold.png',
                text = 'Upgrade price : ' .. ESX.Math.GroupDigits(Config.ShellCoords[hdata.shell].SafeLevel[level + 1].Price),
                text2 = 'Upgrade size : '.. Config.ShellCoords[hdata.shell].SafeLevel[level + 1].Size,
                callBack = function()
                    TriggerServerEvent('sunset_housing:UpgradeHouseSafe',HouseId)
                    exports.icon_menu:ForceCloseMenu()
                    Wait(5000)
                    OpenSafe()
            end})
        end
        exports.icon_menu:OpenMenu(List, configs)
    end,HouseId)
end

local adddata2 = {}

RegisterCommand('addap', function(source, args)
    ESX.TriggerServerCallback('esx_aduty:getAdminPerm', function(aperm)
        if aperm >= 8 then
            AddAP()
        else
            TriggerEvent('chat:addMessage', {color = { 255, 0, 0}, multiline = true ,args = {"[SYSTEM]", "^0Shoma dastresi kafi baraye estefade az in dastor ra nadarid!"}}, 'plarms')
        end
    end)
end, false)

function AddAP()
    local List = {}
    local coords = ''
    local interior = ''
    local price = 0
    local floor = 0
    if adddata2.enter then
        coords = ('vector4(%s,%s,%s,%s)'):format(FormatCoord(adddata2.enter.x),FormatCoord(adddata2.enter.y),FormatCoord(adddata2.enter.z),FormatCoord(adddata2.enter.w))
    end
    table.insert(List,{
        img = 'SS_gold.png',
        text = 'Coords',
        text2 = coords,
        callBack = function()
            exports.icon_menu:ForceCloseMenu()
            local pcoords = GetEntityCoords(PlayerPedId())
            adddata2.enter = vector4(pcoords.x,pcoords.y,pcoords.z,GetEntityHeading(PlayerPedId())) - vector4(0,0,1,0)
            adddata2.zone = getGridZone()
            AddAP()
    end})
    if adddata2.interior then
        interior = adddata2.interior
    end
    table.insert(List,{
        img = 'SS_gold.png',
        text = 'Interior',
        text2 = interior,
        callBack = function()
            exports.icon_menu:ForceCloseMenu()
            ESX.UI.Menu.Open(
            'dialog',
            GetCurrentResourceName(),
            'get_interior',
            {
                title = "Esm inetrior ra vared konid"
            },
            function(data1,menu1)
                menu1.close()
                if data1.value then
                    name = data1.value
                    if Config.ShellCoords[name] then
                        adddata2.interior = name
                        AddAP()
                    else
                        ESX.Alert('Error','In entrior vojoud nadarad',5000,'warning')
                        AddAP()
                    end
                end
            end, function(data1,menu1)
                menu1.close()
            end)
    end})
    if adddata2.price then
        price = adddata2.price
    end
    table.insert(List,{
        img = 'SS_gold.png',
        text = 'Price',
        text2 = ESX.Math.GroupDigits(price),
        callBack = function()
            exports.icon_menu:ForceCloseMenu()
            ESX.UI.Menu.Open(
            'dialog',
            GetCurrentResourceName(),
            'get_interior',
            {
                title = "Enter price"
            },
            function(data1,menu1)
                menu1.close()
                if data1.value then
                    price = tonumber(data1.value)
                    if price > 0 then
                        adddata2.price = price
                        AddAP()
                    end
                end
            end, function(data1,menu1)
                menu1.close()
            end)
    end})
    --
    if adddata2.floor then
        floor = adddata2.floor
    end
    table.insert(List,{
        img = 'SS_gold.png',
        text = 'Floor',
        text2 = ESX.Math.GroupDigits(floor),
        callBack = function()
            exports.icon_menu:ForceCloseMenu()
            ESX.UI.Menu.Open(
            'dialog',
            GetCurrentResourceName(),
            'get_floor',
            {
                title = "Enter floor"
            },
            function(data1,menu1)
                menu1.close()
                if data1.value then
                    floor = tonumber(data1.value)
                    if floor > 0 then
                        adddata2.floor = floor
                        AddAP()
                    end
                end
            end, function(data1,menu1)
                menu1.close()
            end)
    end})
    --
    table.insert(List,{
        img = 'SS_gold.png',
        text = 'Confirm',
        text2 = ESX.Math.GroupDigits(price),
        callBack = function()
            exports.icon_menu:ForceCloseMenu()
            if adddata2.price > 0 and adddata2.floor > 0 and adddata2.interior and adddata2.enter then
                TriggerServerEvent('sunset_housing:AddAP',adddata2)
            else
                AddAP()
                ESX.Alert('Error','Data kamel nist',5000,'warning')
            end
    end})
    exports.icon_menu:OpenMenu(List, configs)
end

RegisterCommand('sph', function(source, args)
    ESX.TriggerServerCallback('esx_aduty:getAdminPerm', function(aperm)
        if aperm >= 8 then
            local hex = args[1]
            if hex then
                local List = {}
                for k , v in pairs(Config.Houses) do
                    if v.Owner == hex then
                        table.insert(List,{
                            img = 'SS_gold.png',
                            text = k,
                            text2 = 'Distance : '.. ESX.Math.Round(ESX.GetDistance(GetEntityCoords(PlayerPedId()),v.Entercoords.xyz)),
                            callBack = function()
                                exports.icon_menu:ForceCloseMenu()
                                EnterHouse(v)
                        end})
                    end
                end
                exports.icon_menu:OpenMenu(List, configs)
            else
                TriggerEvent('chat:addMessage', {color = { 255, 0, 0}, multiline = true ,args = {"[SYSTEM]", "^0Shoma hexi vared nakardid!"}}, 'alarms')
            end
        else
            TriggerEvent('chat:addMessage', {color = { 255, 0, 0}, multiline = true ,args = {"[SYSTEM]", "^0Shoma dastresi kafi baraye estefade az in dastor ra nadarid!"}}, 'plarms')
        end
    end)
end, false)

RegisterCommand('enterhouse', function(source, args)
    ESX.TriggerServerCallback('esx_aduty:getAdminPerm', function(aperm)
        if aperm >= 8 then
            local id = args[1]
            if id then
                reqHouse(id)
                if Config.Houses[id] then
                    EnterHouse(Config.Houses[id])
                end
            else
                TriggerEvent('chat:addMessage', {color = { 255, 0, 0}, multiline = true ,args = {"[SYSTEM]", "^0Shoma id ra vared nakardid!"}}, 'alarms')
            end
        else
            TriggerEvent('chat:addMessage', {color = { 255, 0, 0}, multiline = true ,args = {"[SYSTEM]", "^0Shoma dastresi kafi baraye estefade az in dastor ra nadarid!"}}, 'plarms')
        end
    end)
end, false)

-- AddEventHandler('onKeyDown',function(key)
--     if key == 'q' then
--         adddata = {}
--         local pcoords = GetEntityCoords(PlayerPedId())
--         adddata.enter = vector4(pcoords.x,pcoords.y,pcoords.z,GetEntityHeading(PlayerPedId())) - vector4(0,0,1,0)
--         adddata.zone = getGridZone()
--         adddata.interior = 'shell_michael'
--         adddata.price = 1000
--         TriggerServerEvent('sunset_housing:AddHouse',adddata)
--     end
-- end)

-- RegisterCommand('house', function(source, args)
--     -- ESX.TriggerServerCallback('esx_aduty:getAdminPerm', function(aperm)
--     --     if aperm >= 8 then
--     --         local hex = args[1]
--     --         if hex then
--     --             local List = {}
--     --             for k , v in pairs(Config.Houses) do
--     --                 if v.Owner == hex then
--     --                     table.insert(List,{
--     --                         img = 'SS_gold.png',
--     --                         text = k,
--     --                         text2 = 'Distance : '.. ESX.Math.Round(ESX.GetDistance(GetEntityCoords(PlayerPedId()),v.Entercoords.xyz)),
--     --                         callBack = function()
--     --                             exports.icon_menu:ForceCloseMenu()
--     --                             EnterHouse(v)
--     --                     end})
--     --                 end
--     --             end
--     --             exports.icon_menu:OpenMenu(List, configs)
--     --         else
--     --             TriggerEvent('chat:addMessage', {color = { 255, 0, 0}, multiline = true ,args = {"[SYSTEM]", "^0Shoma hexi vared nakardid!"}}, 'alarms')
--     --         end
--     --     else
--     --         TriggerEvent('chat:addMessage', {color = { 255, 0, 0}, multiline = true ,args = {"[SYSTEM]", "^0Shoma dastresi kafi baraye estefade az in dastor ra nadarid!"}}, 'plarms')
--     --     end
--     -- end)
--     local List = {}
--     for k , v in pairs(Config.ShellCoords) do
--         table.insert(List,{
--             img = 'SS_gold.png',
--             text = k,
--             text2 = k,
--             callBack = function()
--                 exports.icon_menu:ForceCloseMenu()
--                 TriggerEvent('sunset_housing:ExitMe')
--                 Wait(1000)
--                 local data = {
--                     Shell =k,
--                     Entercoords = GetEntityCoords(PlayerPedId())
--                 }
--                 PreviewHouse(data)
--         end})
--     end
--     exports.icon_menu:OpenMenu(List, configs)
-- end, false)

function GetVehicleDamages(vehicle)
	local damages 	   = {['damaged_windows'] = {}, ['burst_tires'] = {}, ['broken_doors'] = {}, ['body_health'] = GetVehicleBodyHealth(vehicle), ['engine_health'] = GetVehicleEngineHealth(vehicle)}

	for i = 0, GetVehicleNumberOfWheels(vehicle) do
		if IsVehicleTyreBurst(vehicle, i, false) then table.insert(damages['burst_tires'], i) end
	end
	for i = 0, 7 do
		if not IsVehicleWindowIntact(vehicle, i) then table.insert(damages['damaged_windows'], i) end
	end
	for i = 0, GetNumberOfVehicleDoors(vehicle) do
		if IsVehicleDoorDamaged(vehicle, i) then table.insert(damages['broken_doors'], i) end
	end

	return damages
end

function EnterGarage(data,vehicledata,owner,access)
    local data = data
    local id = data.Id
    if access then
        Access = access
    end
    HouseId = id
    stressThread()
    if not data.Shellgarage  then return end
    ESX.TriggerServerCallback("sunset_housing:FindSpace", function(space)
        if space ~= 0 then
            ESX.TriggerServerCallback("sunset_housing:GetHouseData", function(hdata)
                DoScreenFadeOut(750)
                ESX.Streaming.RequestModel(data.Shellgarage)
                ESX.Game.SpawnLocalObject(data.Shellgarage,Config.GaragePosition,function(obj)
                    Cache.shell_object = obj
                    SetEntityHeading(Cache.shell_object, 0.0)
                    FreezeEntityPosition(Cache.shell_object, true)
                    local newcoords = Config.ShellCoords[data.Shellgarage].Join.xyz + Config.GaragePosition
                    while not IsScreenFadedOut() do Wait(0) end
                    for i = 1, 25 do
                        ESX.SetEntityCoords(PlayerPedId(),newcoords)
                        Wait(50)
                    end
                    while IsEntityWaitingForWorldCollision(PlayerPedId()) do
                        ESX.SetEntityCoords(PlayerPedId(),newcoords)
                        Wait(50)
                    end
                    SetEntityHeading(PlayerPedId(),Config.ShellCoords[data.Shellgarage].Join.w)
                    local usedcoords = {}
                    for k , v in pairs(vehicledata) do
                        if v.stored then
                            local vehdata = json.decode(v.vehicle)
                            for k2 , v2 in pairs(Config.GarageCoords[data.Shellgarage].Slot) do
                                if not usedcoords[k2] then
                                    usedcoords[k2] = true
                                    local coords = v2.xyz + Config.GaragePosition
                                    ESX.Game.SpawnLocalVehicle(vehdata.model,coords.xyz,v2.w,function(vehicle)
                                        ESX.Game.SetVehicleProperties(vehicle,vehdata)
                                        Wait(100)
                                        FreezeEntityPosition(vehicle,true)
                                        if not owner then
                                            SetVehicleDoorsLocked(vehicle,2)
                                        end
                                        setDamages(vehicle,v.bodydamage)
                                        local aheadVehName = GetDisplayNameFromVehicleModel(GetEntityModel(vehicle))
                                        local vehicleName  = GetLabelText(aheadVehName)
                                        if string.lower(tostring(GetLabelText(aheadVehName))) == "null" then
                                            local newname = ESX.GetVehicleLabelFromName(aheadVehName)
                                            if newname ~= "Unknown" then
                                                vehicleName = newname
                                            end
                                        else
                                            vehicleName = GetLabelText(aheadVehName)
                                        end
                                        VehicleName[GetEntityModel(vehicle)] = vehicleName
                                        table.insert(SpawnedVehicle,vehicle)
                                        Wait(100)
                                    end)
                                    break
                                end
                            end
                        end
                    end
                    Citizen.CreateThread(function()
                        while Cache.shell_object ~= 0 and owner do
                            Wait(0)
                            local vehicle = GetVehiclePedIsIn(PlayerPedId())
                            if DoesEntityExist(vehicle) then
                                local plate = GetVehicleNumberPlateText(vehicle)
                                local vehpos = GetOffsetFromEntityInWorldCoords(vehicle, 0.0, 0.0, 2.0)
                                ESX.Game.Utils.DrawText3D(vector3(vehpos.x, vehpos.y, vehpos.z - 0.5),VehicleName[GetEntityModel(vehicle)],1)
                                ESX.Game.Utils.DrawText3D(vector3(vehpos.x, vehpos.y, vehpos.z - 0.75),"Plate : " .. plate,1)
								ESX.Game.Utils.DrawText3D(vector3(vehpos.x, vehpos.y, vehpos.z - 1),"Body health : " .. ESX.Math.Round(GetVehicleEngineHealth(vehicle) / 10) .. "%",1)
                                ESX.ShowHelpNotification('Dokme ~INPUT_CONTEXT~ jahat dar avordan mashin')
                                if IsControlJustReleased(0,51) then
                                    SpawnVehicle(vehicledata,plate)
                                    break
                                end
                            end
                        end
                    end)
                    DoScreenFadeIn(1500)
                    -- ObjectList = hdata.objects
                    -- for k, v in pairs(ObjectList) do
                    --     local Model = LoadModel(v.item.object)
                    --     if Model.loaded then
                    --         ESX.Game.SpawnLocalObject(Model.model,GetOffsetFromEntityInWorldCoords(Cache.shell_object, v.pos.x, v.pos.y, v.pos.z),function(object)
                    --             FreezeEntityPosition(object, true)
                    --             SetEntityCoordsNoOffset(object, GetOffsetFromEntityInWorldCoords(Cache.shell_object, v.pos.x, v.pos.y, v.pos.z))
                    --             if v.rot then SetEntityRotation(object,v.rot.x * 1.0,v.rot.y * 1.0,v.rot.z * 1.0,2) end
                    --             if Config.LockerHash[Model.model] then
                    --                 Citizen.CreateThread(function()
                    --                     local near = false
                    --                     while DoesEntityExist(object) do
                    --                         Wait(10)
                    --                         local distance = ESX.GetDistance(GetEntityCoords(PlayerPedId()),GetEntityCoords(object))
                    --                         if distance <= 2 then
                    --                             ESX.ShowHelpNotification('Dokme ~INPUT_CONTEXT~ jahat baz kardan inventory')
                    --                             near = true
                    --                             if IsControlJustReleased(0,  51) then
                    --                                 OpenInventory()
                    --                             end
                    --                         elseif near then
                    --                             near = false
                    --                             exports.icon_menu:ForceCloseMenu()
                    --                         end
                    --                     end
                    --                 end)
                    --             end
                    --             if Config.SafeHash[Model.model] then
                    --                 Citizen.CreateThread(function()
                    --                     local near = false
                    --                     while DoesEntityExist(object) do
                    --                         Wait(10)
                    --                         local distance = ESX.GetDistance(GetEntityCoords(PlayerPedId()),GetEntityCoords(object))
                    --                         if distance <= 2 then
                    --                             ESX.ShowHelpNotification('Dokme ~INPUT_CONTEXT~ jahat baz kardan gav sandogh')
                    --                             near = true
                    --                             if IsControlJustReleased(0,  51) then
                    --                                 OpenSafe()
                    --                             end
                    --                         elseif near then
                    --                             near = false
                    --                             exports.icon_menu:ForceCloseMenu()
                    --                         end
                    --                     end
                    --                 end)
                    --             end
                    --             table.insert(SpawnedObject,object)
                    --         end)
                    --     end
                    -- end
                    -- TriggerEvent('Allhousing:Enter',id,Cache.shell_object)
                    -- TriggerEvent('Allhousing:OpenFurni')
                    while Cache.shell_object ~= 0 do
                        Wait(0)
                        local distance = ESX.GetDistance(newcoords,GetEntityCoords(PlayerPedId()))
                        if distance < 3 then
                            ESX.Game.Utils.Draw3D(newcoords,'~INPUT_CONTEXT~ Open menu')
                            if IsControlJustReleased(0,38) then
                                GarageMenu(id,data)
                            end
                        elseif distance > 200 then
                            -- TriggerEvent('Allhousing:Leave')
                            -- ESX.UI.Menu.CloseAll()
                            -- DoScreenFadeOut(750)
                            -- while not IsScreenFadedOut() do Wait(0) end
                            -- for k , v in pairs(SpawnedObject) do
                            --     ESX.Game.DeleteLocalObject(v)
                            -- end
                            -- SpawnedObject = {}
                            -- ESX.Game.DeleteLocalObject(Cache.shell_object)
                            -- Cache.shell_object = 0
                            -- HouseId = 0
                            -- for i = 1, 25 do
                            --     SetEntityCoords(PlayerPedId(),data.Entercoords)
                            --     Wait(50)
                            -- end
                            -- while IsEntityWaitingForWorldCollision(PlayerPedId()) do
                            --     SetEntityCoords(PlayerPedId(),data.Entercoords)
                            --     Wait(50)
                            -- end
                            -- SetEntityHeading(PlayerPedId(),data.Entercoords.w)
                            -- DoScreenFadeIn(1500)
                            -- TriggerServerEvent('sunset_housing:Exit')
                            --disback
                            break
                        end
                    end
                end)
            end,id)
        else
            ESX.ShowNotification('Yek bug vojoud darad,in mored ro be developer gozaresh dahid')
        end
    end,id)
end
-- RegisterCommand('zs',function()
--     TriggerEvent('sunset_housing:ReloadHouseVeh',HouseId)
-- end)
RegisterNetEvent('sunset_housing:ReloadHouseVeh')
AddEventHandler('sunset_housing:ReloadHouseVeh',function(id)
    if HouseId == id then
        reqHouse(HouseId)
        local data = Config.Houses[HouseId]
        local TableLength = ESX.TableLength(SpawnedVehicle)
        for k , v in pairs(SpawnedVehicle) do
            ESX.Game.DeleteVehicle2(v)
        end
        SpawnedVehicle = {}
        local identifier = ESX.GetPlayerData().identifier
        if TableLength > 0 and (Access == 2 or Access == 3) then
            ESX.TriggerServerCallback('sunset_housing:GetHouseGarage',function(cb)
                local usedcoords = {}
                for k , v in pairs(cb) do
                    if v.stored then
                        local vehdata = json.decode(v.vehicle)
                        for k2 , v2 in pairs(Config.GarageCoords[data.Shellgarage].Slot) do
                            if not usedcoords[k2] then
                                usedcoords[k2] = true
                                local coords = v2.xyz + Config.GaragePosition
                                ESX.Game.SpawnLocalVehicle(vehdata.model,coords.xyz,v2.w,function(vehicle)
                                    ESX.Game.SetVehicleProperties(vehicle,vehdata)
                                    Wait(100)
                                    FreezeEntityPosition(vehicle,true)
                                    SetVehicleDoorsLocked(vehicle,2)
                                    setDamages(vehicle,v.bodydamage)
                                    local aheadVehName = GetDisplayNameFromVehicleModel(GetEntityModel(vehicle))
                                    local vehicleName  = GetLabelText(aheadVehName)
                                    if string.lower(tostring(GetLabelText(aheadVehName))) == "null" then
                                        local newname = ESX.GetVehicleLabelFromName(aheadVehName)
                                        if newname ~= "Unknown" then
                                            vehicleName = newname
                                        end
                                    else
                                        vehicleName = GetLabelText(aheadVehName)
                                    end
                                    VehicleName[GetEntityModel(vehicle)] = vehicleName
                                    table.insert(SpawnedVehicle,vehicle)
                                    Wait(100)
                                end)
                                break
                            end
                        end
                    end
                end
            end,HouseId)
        end
    end
end)

function SpawnVehicle(vehicledata,plate)
    reqHouse(HouseId)
    local hdata = Config.Houses[HouseId]
    for k , v in pairs(SpawnedVehicle) do
        ESX.Game.DeleteVehicle2(v)
    end
    SpawnedVehicle = {}
    TriggerEvent('Allhousing:Leave')
    DoScreenFadeOut(750)
    while not IsScreenFadedOut() do Wait(0) end
    for k , v in pairs(SpawnedObject) do
        ESX.Game.DeleteLocalObject(v)
    end
    SpawnedObject = {}
    ESX.Game.DeleteLocalObject(Cache.shell_object)
    Cache.shell_object = 0
    HouseId = 0
    for i = 1, 25 do
        ESX.SetEntityCoords(PlayerPedId(),hdata.Entercoords)
        Wait(50)
    end
    while IsEntityWaitingForWorldCollision(PlayerPedId()) do
        ESX.SetEntityCoords(PlayerPedId(),hdata.Entercoords)
        Wait(50)
    end
    SetEntityHeading(PlayerPedId(),hdata.Entercoords.w)
    DoScreenFadeIn(1500)
    TriggerServerEvent('sunset_housing:Exit')
    Wait(1000)
    for k , v in pairs(vehicledata) do
        if ESX.Math.Trim(string.lower(v.plate)) == ESX.Math.Trim(string.lower(plate)) then
            if v.banned then
                return ESX.chatMessage('In mashin be dalile "'.. v.banned ..'" toghif shode ast!', 'plarms')
            end
            local vehdata = json.decode(v.vehicle)
            local metaData = json.decode(v.metaData or '{}')
            ESX.Game.SpawnVehicle(vehdata.model, hdata.Garagecoords.xyz, hdata.Garagecoords.w, function(callback_vehicle)
                ESX.Game.SetVehicleProperties(callback_vehicle, vehdata)
                SetVehRadioStation(callback_vehicle, "OFF")
                TaskWarpPedIntoVehicle(GetPlayerPed(-1), callback_vehicle, -1)
                TriggerEvent('esx:createvehiclekey')
                setDamages(callback_vehicle,v.bodydamage)
                local plate = vehdata.plate
                ESX.TriggerServerCallback('chopshop:server:isChopped',function(choped)
                    if choped then
                        ESX.TriggerServerCallback('chopshop:server:getEngineLevel',function(engine)
                            if engine ~= 0 then
                                ESX.ShowNotification('Motor mashin shoma sadame dide,shoma be yek Engine X'..engine..' niaz darid')
                            else
                                ESX.ShowNotification('Motor mashin shoma sadame dide')
                            end
                            ESX.TriggerServerEvent('setEntityState', NetworkGetNetworkIdFromEntity(callback_vehicle), 'choped', true)
                        end,GetEntityModel(callback_vehicle))
                    end
                end,plate)
                TriggerServerEvent('garage:setVehicleState', plate, false)
                ESX.Game.setVehicleMetaData(callback_vehicle, metaData)
            end)
        end
    end
    Wait(2000)
    TriggerServerEvent('sunset_housing:ReloadHouseVeh',hdata.Id)
end

function setDamages(car, damages)
	damages = json.decode(damages)
	for i = 0, GetVehicleNumberOfWheels(car) do
        if damages['burst_tires'] then
            if damages['burst_tires'][i] then
                SetVehicleTyreBurst(car, damages['burst_tires'][i], true, 1000.0)
            end
        end
	end

	for i = 0, 7 do
        if damages['damaged_windows'] then
            if damages['damaged_windows'][i] then
                SmashVehicleWindow(car, damages['damaged_windows'][i])
            end
        end
	end

	for i = 0, GetNumberOfVehicleDoors(car) do
        if damages['broken_doors'] then
			if damages['broken_doors'][i] then
                SetVehicleDoorBroken(car, damages['broken_doors'][i], true)
            end
        end
	end
    if damages['body_health'] then
        SetVehicleBodyHealth(car, damages['body_health'])
    end
    if damages['engine_health'] then
        ESX.SetVehicleEngineHealth(car, damages['engine_health'])
    end
end

RegisterNetEvent('ReloadWeapon',function()
    TriggerEvent('esx:restoreLoadout')
end)

function openPostBox(houseId, owner)
    exports.icon_menu:ForceCloseMenu()
    local items2 = getHouseInventory(houseId, 1)
    if not owner then
        items2.items = {}
        items2.weapons = {}
    end
    local items = exports['sun-inventory-hud']:sortItems(items2)
    exports['sun-inventory-hud']:openOtherInventory({items = items, timeout = 1000, label = 'Post Box', maxWeight = 40}, function(data)
        if data.type == 'close' then
        elseif data.type == 'update' then
            local items22 = getHouseInventory(houseId, 1)
            if not owner then
                items22.items = {}
                items22.weapons = {}
            end
            return exports['sun-inventory-hud']:sortItems(items22)
        elseif data.type == 'moveToOther' then
            if ESX.isDead() then return end
            ESX.TriggerServerEvent('sunset_housing:inventory:put', items2.hex, houseId, data.data.itemType, data.data.name, data.data.count, data.data)
        elseif data.type == 'moveToMain' then
            if ESX.isDead() or not owner then return end
            ESX.TriggerServerEvent('sunset_housing:inventory:get', items2.hex, houseId, data.data.itemType, data.data.name, data.data.count, data.data)
        end
    end)
end

function stressThread()
    if not stressThreadBool then
        stressThreadBool = true
        CreateThread(function()
            while HouseId ~= 0 do
                Wait(1000)
                exports['sunset_utils']:removeStress('enterzone_house')
            end
            stressThreadBool = false
        end)
    end
end

RegisterNetEvent('house:setState', function(_state)
    ESX.SetPlayerData('inHouse', _state)
end)