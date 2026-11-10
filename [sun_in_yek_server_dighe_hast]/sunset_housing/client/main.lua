-- Pub by FleeX Team , https://discord.gg/87rGBxgCsa

mainLoaded = true
local NearKey = 0
NearKeyAP = 0
local NearShop = false
local NearMarker = false
local KnockedId = 0
OwnedId = {}
local UrOwnedKey = 0
local NearGarage = false
CreateThread(function()
    while not Loaded do Wait(100) end
    local hex = ESX.GetPlayerData().identifier
    CreateThread(function()
        while true do
            Wait(500)
            local pcoords = GetEntityCoords(PlayerPedId())
            local myzone = getGridZone()
            local zdata = ZoneData[myzone]
            if zdata then
                for k, v in pairs(zdata) do
                    if v.Owner ~= hex then
                        local hdistance = ESX.GetDistance(pcoords,vector3(v.Entercoords.x,v.Entercoords.y,v.Entercoords.z))
                        if hdistance <= 4.0 then
                            if not v.CreatedPoint then
                                NearKey = k
                                Config.Houses[k].CreatedPoint = true
                                if v.Owned then
                                    --if v.Owner == hex then
                                        -- ESX.Game.CreateMarker(vector3(v.Entercoords.x,v.Entercoords.y,v.Entercoords.z),0,255,0,200,0.5)
                                        -- if v.Garagecoords ~= 'no' then
                                        --     local Gdistance = ESX.GetDistance(pcoords,vector3(v.Garagecoords.x,v.Garagecoords.y,v.Garagecoords.z))
                                        --     print(Gdistance)
                                        --     if Gdistance < 6 then
                                        --         ESX.Game.CreateMarker(vector3(v.Garagecoords.x,v.Garagecoords.y,v.Garagecoords.z),0,255,0,200,1.5)
                                        --     end
                                        -- end
                                    --else
                                        ESX.Game.CreateMarker(vector3(v.Entercoords.x,v.Entercoords.y,v.Entercoords.z + 1),255,100,0,200,0.5,12)
                                    --end
                                else
                                    ESX.Game.CreateMarker(vector3(v.Entercoords.x,v.Entercoords.y,v.Entercoords.z + 1),255,255,0,200,0.5,12)
                                end
                                if v.Owner ~= hex then
                                    Citizen.CreateThread(function()
                                        while true do
                                            Wait(0)
                                            local pcoords = GetEntityCoords(PlayerPedId())
                                            local hdistance = ESX.GetDistance(pcoords,vector3(v.Entercoords.x,v.Entercoords.y,v.Entercoords.z))
                                            if hdistance <= 2.0 then
                                                ESX.Game.Utils.Draw3D(vector3(v.Entercoords.x,v.Entercoords.y,v.Entercoords.z) + vector3(0,0,1),'~INPUT_CONTEXT~ Jahat baz kardan menu')
                                            end
                                            local Gdistance = nil
                                            if v.Garagecoords ~= 'no' and v.Owner == hex then
                                                Gdistance = ESX.GetDistance(pcoords,vector3(v.Garagecoords.x,v.Garagecoords.y,v.Garagecoords.z))
                                            end
                                            local lostFocus = NearKey ~= k
                                            local outOfRange = v.CreatedPoint and hdistance > 4 and (Gdistance == nil or Gdistance > 6)
                                            if lostFocus or outOfRange then
                                                if NearKey == k then
                                                    exports.icon_menu:ForceCloseMenu()
                                                    NearKey = 0
                                                end
                                                Config.Houses[k].CreatedPoint = false
                                                ESX.Game.DeleteMarker(vector3(v.Entercoords.x,v.Entercoords.y,v.Entercoords.z + 1))
                                                if v.Garagecoords ~= 'no' then
                                                    ESX.Game.DeleteMarker(vector3(v.Garagecoords.x,v.Garagecoords.y,v.Garagecoords.z + 1))
                                                end
                                                break
                                            end
                                        end
                                    end)
                                end
                            end
                            break
                        end
                    end
                end
            end
            ----
            for k, v in pairs(Config.Apartment) do
                local hdistance = ESX.GetDistance(pcoords,vector3(v.Entercoords.x,v.Entercoords.y,v.Entercoords.z))
                if hdistance <= 5.0 then
                    if not v.CreatedPoint then
                        Config.Apartment[k].CreatedPoint = true
                        ESX.Game.CreateMarker(vector3(v.Entercoords.x,v.Entercoords.y,v.Entercoords.z + 1),0,255,0,170,0.5,12)
                        Citizen.CreateThread(function()
                            while NearKeyAP == k do
                                Wait(0)
                                ESX.Game.Utils.Draw3D(vector3(v.Entercoords.x,v.Entercoords.y,v.Entercoords.z) + vector3(0,0,1),'~INPUT_CONTEXT~ Jahat baz kardan menu')
                                local pcoords = GetEntityCoords(PlayerPedId())
                                local hdistance = ESX.GetDistance(pcoords,vector3(v.Entercoords.x,v.Entercoords.y,v.Entercoords.z))
                                if v.CreatedPoint and hdistance > 5 then
                                    exports.icon_menu:ForceCloseMenu()
                                    NearKeyAP = 0
                                    Config.Apartment[k].CreatedPoint = false
                                    ESX.Game.DeleteMarker(vector3(v.Entercoords.x,v.Entercoords.y,v.Entercoords.z + 1))  
                                    break
                                end
                            end
                        end)
                    end
                    NearKeyAP = k
                    break
                end
            end
        end
    end)
    CreateThread(function()
        while true do
            Wait(200)
            local pcoords = GetEntityCoords(PlayerPedId())
            local myzone = getGridZone()
            local zdata = ZoneData[myzone]
            if zdata then
                for k, v in pairs(zdata) do
                    if OwnedId[v.Id] then
                        local hdistance = ESX.GetDistance(pcoords,vector3(v.Entercoords.x,v.Entercoords.y,v.Entercoords.z))
                        if hdistance <= 10.0 or (v.Garagecoords ~= 'no' and ESX.GetDistance(pcoords,vector3(v.Garagecoords.x,v.Garagecoords.y,v.Garagecoords.z)) <= 10) then
                            UrOwnedKey = k
                            if not v.CreatedPoint then
                                Config.Houses[k].CreatedPoint = true
                                if v.Owner == hex then
                                    ESX.Game.CreateMarker(vector3(v.Entercoords.x,v.Entercoords.y,v.Entercoords.z + 1),0,255,0,200,0.5,12)
                                    if v.Garagecoords ~= 'no' then
                                        local Gdistance = ESX.GetDistance(pcoords,vector3(v.Garagecoords.x,v.Garagecoords.y,v.Garagecoords.z))
                                        if Gdistance < 20 then
                                            ESX.Game.CreateMarker(vector3(v.Garagecoords.x,v.Garagecoords.y,v.Garagecoords.z + 1),0,255,0,200,1.5,15)
                                        end
                                    end
                                    Citizen.CreateThread(function()
                                        while UrOwnedKey == k do
                                            Wait(0)
                                            local pcoords = GetEntityCoords(PlayerPedId())
                                            local hdistance = ESX.GetDistance(pcoords,vector3(v.Entercoords.x,v.Entercoords.y,v.Entercoords.z))
                                            local Gdistance = nil
                                            if v.Garagecoords ~= 'no' then
                                                Gdistance = ESX.GetDistance(pcoords,vector3(v.Garagecoords.x,v.Garagecoords.y,v.Garagecoords.z))
                                            end
                                            if hdistance <= 2.0 then
                                                ESX.Game.Utils.Draw3D(vector3(v.Entercoords.x,v.Entercoords.y,v.Entercoords.z) + vector3(0,0,1),'~INPUT_CONTEXT~ Jahat baz kardan menu')
                                            end
                                            if Gdistance and Gdistance <= 5 then
                                                if Gdistance <= 2.0 then
                                                    ESX.Game.Utils.Draw3D(vector3(v.Garagecoords.x,v.Garagecoords.y,v.Garagecoords.z) + vector3(0,0,1),'~INPUT_CONTEXT~ Jahat park kardan mashin')
                                                end
                                                NearGarage = true
                                            else
                                                NearGarage = false
                                            end
                                            if v.CreatedPoint and hdistance > 3 and (Gdistance == nil or Gdistance > 3) then
                                                exports.icon_menu:ForceCloseMenu()
                                            end
                                            if v.CreatedPoint and hdistance > 10 and (Gdistance == nil or Gdistance > 10)then
                                                UrOwnedKey = 0
                                                Config.Houses[k].CreatedPoint = false
                                                ESX.Game.DeleteMarker(vector3(v.Entercoords.x,v.Entercoords.y,v.Entercoords.z + 1))
                                                if v.Garagecoords ~= 'no' then
                                                    ESX.Game.DeleteMarker(vector3(v.Garagecoords.x,v.Garagecoords.y,v.Garagecoords.z + 1))
                                                end
                                                break
                                            end
                                        end
                                    end)
                                else
                                    ESX.Game.CreateMarker(vector3(v.Entercoords.x,v.Entercoords.y,v.Entercoords.z + 1),255,100,0,200,0.5,12)
                                end
                            end
                            break
                        end
                    end
                end
            end
        end
    end)
end)

AddEventHandler('onKeyDown',function(key)
    if key == 'e' then
        local nearKeyInRange = false
        if NearKey ~= 0 then
            local nkData = Config.Houses[NearKey]
            if nkData then
                local nkDist = ESX.GetDistance(GetEntityCoords(PlayerPedId()),vector3(nkData.Entercoords.x,nkData.Entercoords.y,nkData.Entercoords.z))
                if nkDist <= 1.5 then
                    nearKeyInRange = true
                end
            end
        end
        local urOwnedInRange = false
        if UrOwnedKey ~= 0 then
            local uoData = Config.Houses[UrOwnedKey]
            if uoData then
                local uoDist = ESX.GetDistance(GetEntityCoords(PlayerPedId()),vector3(uoData.Entercoords.x,uoData.Entercoords.y,uoData.Entercoords.z))
                if uoDist <= 3.0 or NearGarage then
                    urOwnedInRange = true
                end
            end
        end
        if urOwnedInRange then
            NearKey = 0
        end
        if NearKey ~= 0 and nearKeyInRange then
            if ESX.GetPlayerData().World ~= 0 then return end
            local List = {}
            local data = Config.Houses[NearKey]
            local canopen = true
            if canopen then
                ESX.TriggerServerCallback("sunset_housing:GetHouseKey", function(keydata)
                    local owned = false
                    local owner = false
                    if data.Owned then
                        owned = true
                        if data.Owner == ESX.GetPlayerData().identifier then
                            owner = true
                        end
                    end
                    if not owned then
                        table.insert(List,{
                            img = 'SS_gold.png',
                            text = 'Info', 
                            text2 = 'Info', 
                            callBack = function()
                                exports.icon_menu:ForceCloseMenu()
                                if Config.ShellCoords[data.Shell] then
                                    List = {}
                                    table.insert(List,{
                                        img = 'SS_gold.png',
                                        text = "Inventory info : ", 
                                        text2 = '', 
                                        callBack = function()
                                    end})
                                    for k , v in pairs(Config.ShellCoords[data.Shell].InventoryLevel) do
                                        local price = 0
                                        if v.Price == 0 then
                                            price = 50000
                                        else
                                            price = v.Price
                                        end
                                        table.insert(List,{
                                            img = 'SS_gold.png',
                                            text =  "Level : ".. k .. " | Size : ".. v.Size .. " | Price : ".. price, 
                                            text2 = '', 
                                            callBack = function()
                                        end})
                                    end
                                    table.insert(List,{
                                        img = 'SS_gold.png',
                                        text = "Safe info : ", 
                                        text2 = '', 
                                        callBack = function()
                                    end})
                                    for k , v in pairs(Config.ShellCoords[data.Shell].SafeLevel) do
                                        local price = 0
                                        if v.Price == 0 then
                                            price = 1000000
                                        else
                                            price = v.Price
                                        end
                                        table.insert(List,{
                                            img = 'SS_gold.png',
                                            text = "Level : ".. k .. " | Size : ".. v.Size .. " | Price : ".. price, 
                                            text2 = '', 
                                            callBack = function()
                                        end})
                                    end
                                    exports.icon_menu:OpenMenu(List, configs)
                                end
                        end})
                        table.insert(List,{
                            img = 'SS_gold.png',
                            text = 'Buy', 
                            text2 = 'Price : $'.. ESX.Math.GroupDigits(data.Price), 
                            callBack = function()
                                ESX.TriggerServerEvent('sunset_housing:buy',data.Id)
                                exports.icon_menu:ForceCloseMenu()
                        end})
                        table.insert(List,{
                            img = 'SS_gold.png',
                            text = 'Preview', 
                            text2 = 'Preview', 
                            callBack = function()
                                exports.icon_menu:ForceCloseMenu()
                                if ESX.progressCircle(4000, true, true) then
                                    PreviewHouse(data) 
                                end
                        end})
                        if data.Shellgarage then
                            table.insert(List,{
                                img = 'SS_gold.png',
                                text = 'Garage slot : '.. ESX.TableLength(Config.GarageCoords[data.Shellgarage].Slot), 
                                text2 = '', 
                                callBack = function()
                            end})
                            table.insert(List,{
                                img = 'SS_gold.png',
                                text = 'Preview garage', 
                                text2 = 'Preview garage', 
                                callBack = function()
                                    exports.icon_menu:ForceCloseMenu()
                                    if ESX.progressCircle(4000, true, true) then
                                        PreviewGarage(data) 
                                    end
                            end})
                        end
                        table.insert(List,{
                            img = 'SS_gold.png',
                            text = 'Copy postal code', 
                            text2 = '', 
                            callBack = function()
                                exports.esx_carjob:SetClipboard(data.Id)
                        end})
                        exports.icon_menu:OpenMenu(List, configs)
                    else
                        if owner then
                            table.insert(List,{
                                img = 'SS_gold.png',
                                text = 'Enter', 
                                text2 = '', 
                                callBack = function()
                                    exports.icon_menu:ForceCloseMenu()
                                    if IsPedInAnyVehicle(PlayerPedId(), false) or ESX.isDead() then return end
                                    if ESX.progressCircle(4000, true, true) then
                                        if IsPedInAnyVehicle(PlayerPedId(), false) or ESX.isDead() then return end
                                        EnterHouse(data) 
                                    end
                            end})
                            table.insert(List,{
                                img = 'SS_gold.png',
                                text = 'Enter garage', 
                                text2 = '', 
                                callBack = function()
                                    exports.icon_menu:ForceCloseMenu()
                                    if IsPedInAnyVehicle(PlayerPedId(), false) or ESX.isDead() then return end
                                    if ESX.progressCircle(4000, true, true) then
                                        if IsPedInAnyVehicle(PlayerPedId(), false) or ESX.isDead() then return end
                                        --EnterGarage(data,true)
                                    end
                            end})
                            table.insert(List,{
                                img = 'SS_gold.png',
                                text = 'Open Post Box',
                                text2 = '',
                                callBack = function()
                                    openPostBox(data.Id)
                            end})
                            table.insert(List,{
                                img = 'SS_gold.png',
                                text = 'Copy postal code', 
                                text2 = '', 
                                callBack = function()
                                    exports.esx_carjob:SetClipboard(data.Id)
                            end})
                            table.insert(List,{
                                img = 'SS_gold.png',
                                text = 'Pets', 
                                text2 = '', 
                                callBack = function()
                                    exports['sunset_utils']:openPetMenu()
                            end})
                            exports.icon_menu:OpenMenu(List, configs)
                        elseif keydata[ESX.GetPlayerData().identifier] then
                            table.insert(List,{
                                img = 'SS_gold.png',
                                text = 'Enter', 
                                text2 = '', 
                                callBack = function()
                                    exports.icon_menu:ForceCloseMenu()
                                    if IsPedInAnyVehicle(PlayerPedId(), false) or ESX.isDead() then return end
                                    if ESX.progressCircle(4000, true, true) then
                                        if IsPedInAnyVehicle(PlayerPedId(), false) or ESX.isDead() then return end
                                        EnterHouseKey(data)
                                    end
                            end})
                            if data.Shellgarage then
                                local wait = true
                                ESX.TriggerServerCallback('sunset_housing:GetHouseGarage',function(cb)
                                    table.insert(List,{
                                        img = 'SS_gold.png',
                                        text = 'Enter garage', 
                                        text2 = ESX.TableLength(cb) .. '/' .. ESX.TableLength(Config.GarageCoords[data.Shellgarage].Slot), 
                                        callBack = function()
                                            exports.icon_menu:ForceCloseMenu()
                                            if IsPedInAnyVehicle(PlayerPedId(), false) or ESX.isDead() then return end
                                            if ESX.progressCircle(4000, true, true) then
                                                if IsPedInAnyVehicle(PlayerPedId(), false) or ESX.isDead() then return end
                                                EnterGarage(data,cb,false,2)
                                            end
                                    end})
                                    wait = false
                                end,data.Id)
                                while wait do Wait(10) end
                            end
                            table.insert(List,{
                                img = 'SS_gold.png',
                                text = 'Open Post Box',
                                text2 = '',
                                callBack = function()
                                    openPostBox(data.Id)
                            end})
                            table.insert(List,{
                                img = 'SS_gold.png',
                                text = 'Copy postal code', 
                                text2 = '', 
                                callBack = function()
                                    exports.esx_carjob:SetClipboard(data.Id)
                            end})
                            table.insert(List,{
                                img = 'SS_gold.png',
                                text = 'Pets', 
                                text2 = '', 
                                callBack = function()
                                    exports['sunset_utils']:openPetMenu()
                            end})
                            exports.icon_menu:OpenMenu(List, configs)
                        else
                            ESX.TriggerServerCallback('sunset_housing:GetNameByIdentifier',function(name)
                                table.insert(List,{
                                    img = 'SS_gold.png',
                                    text = name, 
                                    text2 = 'Owner name', 
                                    callBack = function()
                                end})
                                table.insert(List,{
                                    img = 'SS_gold.png',
                                    text = 'Zang zadan', 
                                    text2 = '', 
                                    callBack = function()
                                        exports.icon_menu:ForceCloseMenu()
                                        if KnockedId ~= data.Id then
                                            KnockedId = data.Id
                                            TriggerServerEvent('sunset_housing:Knock',data.Id)
                                            TriggerEvent('InteractSound_CL:PlayOnOne','knock',0.1)
                                            Citizen.CreateThread(function()
                                                while true and HouseId == 0 do
                                                    Wait(100)
                                                    local distance = ESX.GetDistance(GetEntityCoords(PlayerPedId()),vector3(data.Entercoords.x,data.Entercoords.y,data.Entercoords.z)) 
                                                    if distance > 5 then
                                                        KnockedId = 0
                                                        TriggerServerEvent('sunset_housing:CancelKnock')  
                                                        break
                                                    end
                                                end
                                                KnockedId = 0
                                            end)
                                        else
                                            ESX.Alert('Ajab','Shoma yekbar dar in khane ra zadid lotfan sabur bashid',5000,'warning')
                                        end
                                end})
                                table.insert(List,{
                                    img = 'SS_gold.png',
                                    text = 'Open Post Box',
                                    text2 = '',
                                    callBack = function()
                                        openPostBox(data.Id)
                                end})
                                table.insert(List,{
                                    img = 'SS_gold.png',
                                    text = 'Copy postal code', 
                                    text2 = '', 
                                    callBack = function()
                                        exports.esx_carjob:SetClipboard(data.Id)
                                end})
                                exports.icon_menu:OpenMenu(List, configs)
                            end,data.Owner)
                        end
                    end 
                end,NearKey)
            end
        elseif UrOwnedKey ~= 0 then
            if ESX.GetPlayerData().World ~= 0 then return end
            local data = Config.Houses[UrOwnedKey]
            if NearGarage then
                local vehicle = GetVehiclePedIsIn(PlayerPedId())
                if DoesEntityExist(vehicle) and GetPedInVehicleSeat(vehicle,-1) == PlayerPedId() then
                    local plate = GetVehicleNumberPlateText(vehicle)
                    ESX.TriggerServerCallback('sunset_housing:GetHouseGarage',function(cb)
                        if ESX.TableLength(cb) >= ESX.TableLength(Config.GarageCoords[data.Shellgarage].Slot) then
                            ESX.Alert('Warning','Garage khane por ast',5000,'warning')
                        else
                            ESX.TriggerServerCallback('carlock:isVehicleOwnerJustIdentifier', function(owner)
                                if owner then
                                    local vehicleProps = ESX.Game.GetVehicleProperties(vehicle)
                                    local damages = GetVehicleDamages(vehicle)
                                    local metaData = ESX.Game.getVehicleMetaData(vehicle)
                                    ESX.Game.DeleteVehicle(vehicle)
                                    TriggerServerEvent('garage:setVehicleState', vehicleProps.plate, true,json.encode(damages))
                                    TriggerServerEvent('garage:setvehiclelocation',ESX.Math.Trim(plate),0,UrOwnedKey)
                                    ESX.TriggerServerEvent('parking:setVehicleMetaData2', vehicleProps.plate, metaData)
                                    ESX.ShowNotification('Mashin dar Garage Park shod')
                                    Wait(2000)
                                    TriggerServerEvent('sunset_housing:ReloadHouseVeh',UrOwnedKey)
                                end
                            end, plate)
                        end
                    end,data.Id)
                end
            end
            local List = {}
            local canopen = ESX.GetDistance(GetEntityCoords(PlayerPedId()),vector3(data.Entercoords.x,data.Entercoords.y,data.Entercoords.z)) <= 2.0
            if canopen then
                ESX.TriggerServerCallback("sunset_housing:GetHouseKey", function(keydata)
                    local owned = false
                    local owner = false
                    if data.Owned then
                        owned = true
                        if data.Owner == ESX.GetPlayerData().identifier then
                            owner = true
                        end
                    end
                    if not owned then
                        table.insert(List,{
                            img = 'SS_gold.png',
                            text = 'Info', 
                            text2 = 'Info', 
                            callBack = function()
                                exports.icon_menu:ForceCloseMenu()
                                if Config.ShellCoords[data.Shell] then
                                    List = {}
                                    table.insert(List,{
                                        img = 'SS_gold.png',
                                        text = "Inventory info : ", 
                                        text2 = '', 
                                        callBack = function()
                                    end})
                                    for k , v in pairs(Config.ShellCoords[data.Shell].InventoryLevel) do
                                        local price = 0
                                        if v.Price == 0 then
                                            price = 50000
                                        else
                                            price = v.Price
                                        end
                                        table.insert(List,{
                                            img = 'SS_gold.png',
                                            text =  "Level : ".. k .. " | Size : ".. v.Size .. " | Price : ".. price, 
                                            text2 = '', 
                                            callBack = function()
                                        end})
                                    end
                                    table.insert(List,{
                                        img = 'SS_gold.png',
                                        text = "Safe info : ", 
                                        text2 = '', 
                                        callBack = function()
                                    end})
                                    for k , v in pairs(Config.ShellCoords[data.Shell].SafeLevel) do
                                        local price = 0
                                        if v.Price == 0 then
                                            price = 1000000
                                        else
                                            price = v.Price
                                        end
                                        table.insert(List,{
                                            img = 'SS_gold.png',
                                            text = "Level : ".. k .. " | Size : ".. v.Size .. " | Price : ".. price, 
                                            text2 = '', 
                                            callBack = function()
                                        end})
                                    end
                                    exports.icon_menu:OpenMenu(List, configs)
                                end
                        end})
                        table.insert(List,{
                            img = 'SS_gold.png',
                            text = 'Buy', 
                            text2 = 'Price : $'.. ESX.Math.GroupDigits(data.Price), 
                            callBack = function()
                                ESX.TriggerServerEvent('sunset_housing:buy',data.Id)
                                exports.icon_menu:ForceCloseMenu()
                        end})
                        table.insert(List,{
                            img = 'SS_gold.png',
                            text = 'Preview', 
                            text2 = 'Preview', 
                            callBack = function()
                                exports.icon_menu:ForceCloseMenu()
                                if ESX.progressCircle(4000, true, true) then
                                    PreviewHouse(data)
                                end
                        end})
                        if data.Shellgarage then
                            table.insert(List,{
                                img = 'SS_gold.png',
                                text = 'Garage slot : '.. ESX.TableLength(Config.GarageCoords[data.Shellgarage].Slot), 
                                text2 = '', 
                                callBack = function()
                            end})
                            table.insert(List,{
                                img = 'SS_gold.png',
                                text = 'Preview garage', 
                                text2 = 'Preview garage', 
                                callBack = function()
                                    exports.icon_menu:ForceCloseMenu()
                                    if ESX.progressCircle(4000, true, true) then
                                        PreviewGarage(data)
                                    end
                            end})
                        end
                        table.insert(List,{
                            img = 'SS_gold.png',
                            text = 'Copy postal code', 
                            text2 = '', 
                            callBack = function()
                                exports.esx_carjob:SetClipboard(data.Id)
                        end})
                        exports.icon_menu:OpenMenu(List, configs)
                    else
                        if owner then
                            table.insert(List,{
                                img = 'SS_gold.png',
                                text = 'Enter', 
                                text2 = '', 
                                callBack = function()
                                    exports.icon_menu:ForceCloseMenu()
                                    if IsPedInAnyVehicle(PlayerPedId(), false) or ESX.isDead() then return end
                                    if ESX.progressCircle(4000, true, true) then
                                        if IsPedInAnyVehicle(PlayerPedId(), false) or ESX.isDead() then return end
                                        EnterHouse(data)
                                    end
                            end})
                            if data.Shellgarage then
                                local wait = true
                                ESX.TriggerServerCallback('sunset_housing:GetHouseGarage',function(cb)
                                    table.insert(List,{
                                        img = 'SS_gold.png',
                                        text = 'Enter garage', 
                                        text2 = ESX.TableLength(cb) .. '/' .. ESX.TableLength(Config.GarageCoords[data.Shellgarage].Slot), 
                                        callBack = function()
                                            exports.icon_menu:ForceCloseMenu()
                                            if IsPedInAnyVehicle(PlayerPedId(), false) or ESX.isDead() then return end
                                            if ESX.progressCircle(4000, true, true) then
                                                if IsPedInAnyVehicle(PlayerPedId(), false) or ESX.isDead() then return end
                                                EnterGarage(data,cb,true,1)
                                            end
                                    end})
                                    wait = false
                                end,data.Id)
                                while wait do Wait(10) end
                            end
                            table.insert(List,{
                                img = 'SS_gold.png',
                                text = 'Open Post Box',
                                text2 = '',
                                callBack = function()
                                    openPostBox(data.Id)
                            end})
                            table.insert(List,{
                                img = 'SS_gold.png',
                                text = 'Copy postal code', 
                                text2 = '', 
                                callBack = function()
                                    exports.esx_carjob:SetClipboard(data.Id)
                            end})
                            table.insert(List,{
                                img = 'SS_gold.png',
                                text = 'Pets', 
                                text2 = '', 
                                callBack = function()
                                    exports['sunset_utils']:openPetMenu()
                            end})
                            exports.icon_menu:OpenMenu(List, configs)
                        elseif keydata[ESX.GetPlayerData().identifier] then
                            table.insert(List,{
                                img = 'SS_gold.png',
                                text = 'Enter', 
                                text2 = '', 
                                callBack = function()
                                    exports.icon_menu:ForceCloseMenu()
                                    if IsPedInAnyVehicle(PlayerPedId(), false) or ESX.isDead() then return end
                                    if ESX.progressCircle(4000, true, true) then
                                        if IsPedInAnyVehicle(PlayerPedId(), false) or ESX.isDead() then return end
                                        EnterHouseKey(data)
                                    end
                            end})
                            table.insert(List,{
                                img = 'SS_gold.png',
                                text = 'Open Post Box',
                                text2 = '',
                                callBack = function()
                                    openPostBox(data.Id)
                            end})
                            table.insert(List,{
                                img = 'SS_gold.png',
                                text = 'Copy postal code', 
                                text2 = '', 
                                callBack = function()
                                    exports.esx_carjob:SetClipboard(data.Id)
                            end})
                            table.insert(List,{
                                img = 'SS_gold.png',
                                text = 'Pets', 
                                text2 = '', 
                                callBack = function()
                                    exports['sunset_utils']:openPetMenu()
                            end})
                            exports.icon_menu:OpenMenu(List, configs)
                        else
                            table.insert(List,{
                                img = 'SS_gold.png',
                                text = 'Zang zadan', 
                                text2 = '', 
                                callBack = function()
                                    exports.icon_menu:ForceCloseMenu()
                                    if KnockedId ~= data.Id then
                                        KnockedId = data.Id
                                        TriggerServerEvent('sunset_housing:Knock',data.Id)
                                        TriggerEvent('InteractSound_CL:PlayOnOne','knock',0.1)
                                        Citizen.CreateThread(function()
                                            while true and HouseId == 0 do
                                                Wait(100)
                                                local distance = ESX.GetDistance(GetEntityCoords(PlayerPedId()),vector3(data.Entercoords.x,data.Entercoords.y,data.Entercoords.z)) 
                                                if distance > 5 then
                                                    KnockedId = 0
                                                    TriggerServerEvent('sunset_housing:CancelKnock')  
                                                    break
                                                end
                                            end
                                            KnockedId = 0
                                        end)
                                    else
                                        ESX.Alert('Ajab','Shoma yekbar dar in khane ra zadid lotfan sabur bashid',5000,'warning')
                                    end
                            end})
                            table.insert(List,{
                                img = 'SS_gold.png',
                                text = 'Copy postal code', 
                                text2 = '', 
                                callBack = function()
                                    exports.esx_carjob:SetClipboard(data.Id)
                            end})
                            exports.icon_menu:OpenMenu(List, configs)
                        end
                    end 
                end,UrOwnedKey)
            end
        elseif NearKeyAP ~= 0 then
            if ESX.GetPlayerData().World ~= 0 then return end
            ESX.TriggerServerCallback("sunset_housing:GetAPSummary", function(data)
                if not data or type(data) ~= 'table' then
                    return
                end
                local List = {}
                local owned = data.ownedHouseId ~= nil
                local ownedkey = data.ownedHouseId
                local ownedUnit = data.ownedUnit
                local buyed = data.buyed
                if not owned then
                    table.insert(List,{
                        img = 'SS_gold.png',
                        text = buyed .. '/'.. data.floor ..' Units purchased', 
                        text2 = '', 
                        callBack = function()
                    end})
                    if buyed < data.floor then
                        table.insert(List,{
                            img = 'SS_gold.png',
                            text = 'Info', 
                            text2 = 'Info', 
                            callBack = function()
                                exports.icon_menu:ForceCloseMenu()
                                if Config.ShellCoords[data.shell] then
                                    List = {}
                                    table.insert(List,{
                                        img = 'SS_gold.png',
                                        text = "Inventory info : ", 
                                        text2 = '', 
                                        callBack = function()
                                    end})
                                    for k , v in pairs(Config.ShellCoords[data.shell].InventoryLevel) do
                                        local price = 0
                                        if v.Price == 0 then
                                            price = 50000
                                        else
                                            price = v.Price
                                        end
                                        table.insert(List,{
                                            img = 'SS_gold.png',
                                            text =  "Level : ".. k .. " | Size : ".. v.Size .. " | Price : ".. price, 
                                            text2 = '', 
                                            callBack = function()
                                        end})
                                    end
                                    table.insert(List,{
                                        img = 'SS_gold.png',
                                        text = "Safe info : ", 
                                        text2 = '', 
                                        callBack = function()
                                    end})
                                    for k , v in pairs(Config.ShellCoords[data.shell].SafeLevel) do
                                        local price = 0
                                        if v.Price == 0 then
                                            price = 1000000
                                        else
                                            price = v.Price
                                        end
                                        table.insert(List,{
                                            img = 'SS_gold.png',
                                            text = "Level : ".. k .. " | Size : ".. v.Size .. " | Price : ".. price, 
                                            text2 = '', 
                                            callBack = function()
                                        end})
                                    end
                                    exports.icon_menu:OpenMenu(List, configs)
                                end
                        end})
                        table.insert(List,{
                            img = 'SS_gold.png',
                            text = 'Buy', 
                            text2 = 'Price : $'.. ESX.Math.GroupDigits(data.price), 
                            callBack = function()
                                ESX.TriggerServerEvent('sunset_housing:buyap',NearKeyAP)
                                exports.icon_menu:ForceCloseMenu()
                        end})
                    end
                    table.insert(List,{
                        img = 'SS_gold.png',
                        text = 'Zang zadan', 
                        text2 = '', 
                        callBack = function()
                            exports.icon_menu:ForceCloseMenu()
                            ESX.UI.Menu.Open(
                            'dialog',
                            GetCurrentResourceName(),
                            'get_unit',
                            {
                                title = "Shomare vahed ra vared konid"
                            },
                            function(data1,menu1)
                                menu1.close()
                                if data1.value then
                                    ESX.TriggerServerCallback('sunset_housing:GetUnitHouseId', function(unitData)
                                        if not unitData or ownedkey == unitData.id then
                                            ESX.Alert('Error','In vahed vojoud nadarad',5000,'warning')
                                            return
                                        end
                                        local Id = unitData.id
                                        if KnockedId == Id then
                                            ESX.Alert('Ajab','Shoma yekbar dar in khane ra zadid lotfan sabur bashid',5000,'warning')
                                            return
                                        end
                                        KnockedId = Id
                                        TriggerServerEvent('sunset_housing:Knock',Id)
                                        TriggerEvent('InteractSound_CL:PlayOnOne','knock',0.1)
                                        Citizen.CreateThread(function()
                                            local Entercoords = Config.Apartment[NearKeyAP].Entercoords
                                            while true and HouseId == 0 do
                                                Wait(100)
                                                local distance = ESX.GetDistance(GetEntityCoords(PlayerPedId()),vector3(Entercoords.x,Entercoords.y,Entercoords.z))
                                                if distance > 5 then
                                                    KnockedId = 0
                                                    TriggerServerEvent('sunset_housing:CancelKnock')
                                                    break
                                                end
                                            end
                                            KnockedId = 0
                                        end)
                                    end, NearKeyAP, data1.value)
                                end
                            end, function(data1,menu1)
                                menu1.close()
                            end)
                    end})
                    table.insert(List,{
                        img = 'SS_gold.png',
                        text = 'Preview', 
                        text2 = 'Preview', 
                        callBack = function()
                            exports.icon_menu:ForceCloseMenu()
                            local data = {
                                Shell = data.shell,
                                Entercoords = Config.Apartment[NearKeyAP].Entercoords
                            }
                            if ESX.progressCircle(4000, true, true) then
                                PreviewHouse(data)
                            end
                    end})
                    table.insert(List,{
                        img = 'SS_gold.png',
                        text = 'Open Post Box',
                        text2 = '',
                        callBack = function()
                            local input = lib.inputDialog('Post Box vahed chand baz shavad?', {{type = 'number', label = 'Vahed', required = true}})
                            if input and input[1] then
                                ESX.TriggerServerCallback('sunset_housing:GetUnitHouseId', function(unitData)
                                    if unitData and unitData.owned then
                                        openPostBox(unitData.id)
                                    else
                                        ESX.chatMessage('In vahed khali ast', 'plarms')
                                    end
                                end, NearKeyAP, input[1])
                            end
                    end})
                    table.insert(List,{
                        img = 'SS_gold.png',
                        text = 'Copy postal code', 
                        text2 = '', 
                        callBack = function()
                            exports.esx_carjob:SetClipboard(NearKeyAP)
                    end})
                    exports.icon_menu:OpenMenu(List, configs)
                else
                    table.insert(List,{
                        img = 'SS_gold.png',
                        text = 'Enter('.. ownedUnit ..')',
                        text2 = '', 
                        callBack = function()
                            exports.icon_menu:ForceCloseMenu()
                            if IsPedInAnyVehicle(PlayerPedId(), false) or ESX.isDead() then return end
                            if ESX.progressCircle(4000, true, true) then
                                EnterHouseAP(ownedkey)
                                if IsPedInAnyVehicle(PlayerPedId(), false) or ESX.isDead() then return end
                            end
                    end})
                    table.insert(List,{
                        img = 'SS_gold.png',
                        text = buyed .. '/'.. data.floor ..' Units purchased', 
                        text2 = '', 
                        callBack = function()
                    end})
                    table.insert(List,{
                        img = 'SS_gold.png',
                        text = 'Zang zadan', 
                        text2 = '', 
                        callBack = function()
                            exports.icon_menu:ForceCloseMenu()
                            ESX.UI.Menu.Open(
                            'dialog',
                            GetCurrentResourceName(),
                            'get_unit',
                            {
                                title = "Shomare vahed ra vared konid"
                            },
                            function(data1,menu1)
                                menu1.close()
                                if data1.value then
                                    ESX.TriggerServerCallback('sunset_housing:GetUnitHouseId', function(unitData)
                                        if not unitData or ownedkey == unitData.id then
                                            ESX.Alert('Error','In vahed vojoud nadarad',5000,'warning')
                                            return
                                        end
                                        local Id = unitData.id
                                        if KnockedId == Id then
                                            ESX.Alert('Ajab','Shoma yekbar dar in khane ra zadid lotfan sabur bashid',5000,'warning')
                                            return
                                        end
                                        KnockedId = Id
                                        TriggerServerEvent('sunset_housing:Knock',Id)
                                        TriggerEvent('InteractSound_CL:PlayOnOne','knock',0.1)
                                        Citizen.CreateThread(function()
                                            local Entercoords = Config.Apartment[NearKeyAP].Entercoords
                                            while true and HouseId == 0 do
                                                Wait(100)
                                                local distance = ESX.GetDistance(GetEntityCoords(PlayerPedId()),vector3(Entercoords.x,Entercoords.y,Entercoords.z))
                                                if distance > 5 then
                                                    KnockedId = 0
                                                    TriggerServerEvent('sunset_housing:CancelKnock')
                                                    break
                                                end
                                            end
                                            KnockedId = 0
                                        end)
                                    end, NearKeyAP, data1.value)
                                end
                            end, function(data1,menu1)
                                menu1.close()
                            end)
                    end})
                    table.insert(List,{
                        img = 'SS_gold.png',
                        text = 'Open Post Box',
                        text2 = '',
                        callBack = function()
                            local input = lib.inputDialog('Post Box vahed chand baz shavad?', {{type = 'number', label = 'Vahed', required = true}})
                            if input and input[1] then
                                ESX.TriggerServerCallback('sunset_housing:GetUnitHouseId', function(unitData)
                                    if unitData and unitData.owned then
                                        openPostBox(unitData.id)
                                    else
                                        ESX.chatMessage('In vahed khali ast', 'plarms')
                                    end
                                end, NearKeyAP, input[1])
                            end
                    end})
                    table.insert(List,{
                        img = 'SS_gold.png',
                        text = 'Copy postal code', 
                        text2 = '', 
                        callBack = function()
                            exports.esx_carjob:SetClipboard(NearKeyAP)
                    end})
                    table.insert(List,{
                        img = 'SS_gold.png',
                        text = 'Pets', 
                        text2 = '', 
                        callBack = function()
                            exports['sunset_utils']:openPetMenu()
                    end})
                    exports.icon_menu:OpenMenu(List, configs)
                end 
            end,NearKeyAP)
        end
    end
end)