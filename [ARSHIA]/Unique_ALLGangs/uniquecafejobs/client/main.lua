ESX = nil
UCPlayerData = nil
Citizen.CreateThread(function()
    while ESX == nil do
        TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
        Citizen.Wait(0)
    end

    while ESX.GetPlayerData().job == nil do 
        Wait(10)
    end

    UCPlayerData = ESX.GetPlayerData()
    
    
   
    if IsCafeJob(UCPlayerData.job.name) then 
        FreezerTarget()
        SpawnVeh()
    end
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
    UCPlayerData.job = job
    if IsCafeJob(UCPlayerData.job.name) then 
        RemoveTarget()
        Citizen.Wait(2000)
        FreezerTarget()
        SpawnVeh()
    else
        RemoveTarget()
    end
end)



RegisterNetEvent('AH_uwucafejob:OpenInventory')
AddEventHandler('AH_uwucafejob:OpenInventory', function()
    ESX.TriggerServerCallback("AH_uwucafejob:getPropertyInventory",function(inventory)
        ESX.TriggerServerCallback('esx_society:getItems', function(jobGradeItems)
            local items = {}
            for _, item in pairs(inventory.items) do
                for _, sharedItem in pairs(jobGradeItems) do
                    if sharedItem.name == item.name and sharedItem.status == true then
                        table.insert(items, {
                            count = item.count,
                            name = item.name,
                            label = item.label
                        })
                    end
                end
            end

            invent = {
                dirty_money = {},
                items      = items,
                weapons    = {}
            }
            TriggerEvent("esx_inventoryhud:openuwInventory", invent)
        end, UCPlayerData.job.grade, UCPlayerData.job.name)
    end)
end)

RegisterNetEvent('esx_inventoryhud:RefreshInventory')
AddEventHandler('esx_inventoryhud:RefreshInventory', function()
    ESX.TriggerServerCallback("AH_uwucafejob:getPropertyInventory",function(inventory)
        ESX.TriggerServerCallback('esx_society:getItems', function(jobGradeItems)
            local items = {}
            for _, item in pairs(inventory.items) do
                for _, sharedItem in pairs(jobGradeItems) do
                    if sharedItem.name == item.name and sharedItem.status == true then
                        table.insert(items, {
                            count = item.count,
                            name = item.name,
                            label = item.label
                        })
                    end
                end
            end

            invent = {
                dirty_money = {},
                items      = items,
                weapons    = {}
            }
            TriggerEvent("esx_inventoryhud:openuwInventory", invent)
        end, UCPlayerData.job.grade, UCPlayerData.job.name)
    end)
end)



RegisterNetEvent('AH_uwucafejob:OpenShopMenus')
AddEventHandler('AH_uwucafejob:OpenShopMenus', function()
    OpendMenuShops()
end)
    
RegisterNetEvent('AH_uwucafejob:OpenBossMenus')
AddEventHandler('AH_uwucafejob:OpenBossMenus', function()
    ESX.UI.Menu.CloseAll()

    local biz = GetCafeForJob(UCPlayerData.job.name)
    local holding = biz and (HoldingOverrides and HoldingOverrides[biz.Job] or biz.Holding)
    local hc = holding and GetHoldingConfig(holding)

    local elements = {
        MenuInfo('Owned by: ' .. ((hc and hc.Label) or 'No Holding')),
        MenuSection('BUSINESS'),
        { label = '» Manage Business (Society)', value = 'manage_business' },
    }
    if UCPlayerData.job.grade_name == 'boss' then
        table.insert(elements, MenuSection('MANAGE'))
        table.insert(elements, { label = '» Set Work Uniform', value = 'set_uniform' })
        table.insert(elements, { label = '» Manage Vehicles', value = 'manage_vehicles' })
    end

    ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'uwu_boss_action', {
        title    = GetDisplayLabel(UCPlayerData.job.name, GetCafeForJob(UCPlayerData.job.name) and GetCafeForJob(UCPlayerData.job.name).Label or UCPlayerData.job.label),
        align    = 'top-left',
        elements = elements,
    }, function(data, menu)
        if data.current.value == 'manage_business' then
            menu.close()
            TriggerEvent('esx_society:openBosscarysMenu', UCPlayerData.job.name, function(data2, menu2)
                menu2.close()
            end, { wash = false })
        elseif data.current.value == 'set_uniform' then
            menu.close()
            OpenSetCafeUniformMenu()
        elseif data.current.value == 'manage_vehicles' then
            menu.close()
            OpenManageJobVehicleGradesMenu(UCPlayerData.job.name)
        end
    end, function(data, menu)
        menu.close()
    end)
end)

RegisterNetEvent('AH_uwucafejob:OpenCloakroomMenu')
AddEventHandler('AH_uwucafejob:OpenCloakroomMenu', function()
    OpenCloakroomMenu()
end)


-- local spawnedCats = {}

-- function changeCatPose(cat)
--     Citizen.CreateThread(function()
--         while DoesEntityExist(cat) do
--             Wait(math.random(20000, 40000)) 
            
--             if DoesEntityExist(cat) then
--                 ClearPedTasksImmediately(cat) 
                
--                 if math.random(1, 2) == 1 then
--                     TaskStartScenarioInPlace(cat, "WORLD_CAT_SLEEPING_GROUND", 0, true)
--                 else
--                     TaskStartScenarioInPlace(cat, "WORLD_CAT_SLEEPING_LEDGE", 0, true) 
--                 end
--             end
--         end
--     end)
-- end

-- function spawnCat(location)
--     RequestModel(GetHashKey(UCConfig.catModels[1]))
--     while not HasModelLoaded(GetHashKey(UCConfig.catModels[1])) do
--         Wait(100)
--     end
    
--     local cat = CreatePed(28, GetHashKey(UCConfig.catModels[1]), location.x, location.y, location.z, 0.0, true, true)
--     Wait(200)
    
--     SetEntityInvincible(cat, true) 
--     SetBlockingOfNonTemporaryEvents(cat, true) 
--     SetPedCanRagdoll(cat, false) 
--     PlaceObjectOnGroundProperly(cat) 
--     DisablePedPainAudio(cat, true) 
--     SetEntityAsMissionEntity(cat, true, true) 
    

--     if math.random(1, 2) == 1 then
--         TaskStartScenarioInPlace(cat, "WORLD_CAT_SLEEPING_GROUND", 0, true) 
--     else
--         TaskStartScenarioInPlace(cat, "WORLD_CAT_SLEEPING_LEDGE", 0, true) 
--     end
    
--     table.insert(spawnedCats, {entity = cat, location = location})

   
--     changeCatPose(cat)
-- end

-- Citizen.CreateThread(function()
--     for _, location in ipairs(UCConfig.spawnLocations) do
--         spawnCat(location)
--     end
-- end)

-- Citizen.CreateThread(function()
--     while true do
--         Wait(60000) 

--         for i = #spawnedCats, 1, -1 do  
--             if not DoesEntityExist(spawnedCats[i].entity) then
--                 table.remove(spawnedCats, i) 
--                 spawnCat(spawnedCats[i].location) 
--             end
--         end
--     end
-- end)



local markerRadius = 2.0
local canSpawn = true
local spawnVehGen = 0

function SpawnVeh()
    spawnVehGen = spawnVehGen + 1
    local myGen = spawnVehGen

    Citizen.Wait(2000)
    while myGen == spawnVehGen do
        Citizen.Wait(0)
        local myCafe = GetCafeForJob(UCPlayerData.job.name)
        if not myCafe then return end

        local playerPed = PlayerPedId()
        local playerCoords = GetEntityCoords(playerPed)
        local spawnMarker = vector3(myCafe.SpawnMarker.x, myCafe.SpawnMarker.y, myCafe.SpawnMarker.z)
        local deleteMarker = vector3(myCafe.DeleteMarker.x, myCafe.DeleteMarker.y, myCafe.DeleteMarker.z)
        local spawnDistance = #(playerCoords - spawnMarker)
        local deleteDistance = #(playerCoords - deleteMarker)


        if spawnDistance < 10.0 then
            DrawMarker(36, spawnMarker.x, spawnMarker.y, spawnMarker.z - 1.0, 0, 0, 0, 0, 0, 0, 1.5, 1.5, 1.0, 0, 255, 0, 100, false, true, 2, false, nil, nil, false)

            if spawnDistance < markerRadius then
                ESX.ShowHelpNotification("Baraye daryafte mashin ~INPUT_CONTEXT~ ro feshar bedid")

                if IsControlJustPressed(0, 38) and canSpawn then 
                    canSpawn = false
                    TriggerServerEvent("spawnCarOnMarker", myCafe.SpawnVehicle)
                    Citizen.SetTimeout(5000, function()
                        canSpawn = true
                    end)
                end
            end
        end

        if deleteDistance < 10.0 then
            DrawMarker(24, deleteMarker.x, deleteMarker.y, deleteMarker.z - 1.0, 0, 0, 0, 0, 0, 0, 1.5, 1.5, 1.0, 255, 0, 0, 100, false, true, 2, false, nil, nil, false)

            if deleteDistance < markerRadius then
                ESX.ShowHelpNotification("Baraye hazfe mashin ~INPUT_CONTEXT~ ro feshar bedid")

                if IsControlJustPressed(0, 38) then 
                    local vehicle = GetVehiclePedIsIn(playerPed, false)
                    if vehicle and vehicle ~= 0 then
                        ESX.Game.DeleteVehicle(vehicle)
                    end
                end
            end
        end
    end
end

RegisterNetEvent("spawnCarClient")
AddEventHandler("spawnCarClient", function(vehicleName)
    local myCafe = GetCafeForJob(UCPlayerData.job.name)
    if not myCafe then return end
    local spawnPoint = vector4(myCafe.SpawnPoint.x, myCafe.SpawnPoint.y, myCafe.SpawnPoint.z, myCafe.SpawnPoint.w)
    ESX.Game.SpawnVehicle(vehicleName, spawnPoint, spawnPoint.w, function(vehicle)
        TaskWarpPedIntoVehicle(PlayerPedId(), vehicle, -1)
        SetEntityAsNoLongerNeeded(vehicle)
    end)
end)

