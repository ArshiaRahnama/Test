-- This Script Dump By FleeX Team  , discord.gg/2D79ZtUjxB

local currentVehicle, currentVehicleModel = 0
local ownedState = {}
local rubble = `rubble`

local function validateTrunkAccess(vehicle, realOwner, gloveBox)
    if vehicle == 0 or not DoesEntityExist(vehicle) then
        return false, 'Mashin digar vojood nadarad!'
    end

    local coords = GetEntityCoords(PlayerPedId())
    local vehicleCoords = GetEntityCoords(vehicle)
    if ESX.GetDistance(coords, vehicleCoords) >= 6.0 then
        return false, 'Shoma az mashin door hastid!'
    end

    if GetVehicleDoorLockStatus(vehicle) ~= 1 and not realOwner then
        return false, 'Dar vasile naghlie ghofl shode ast!'
    end

    if not IsVehicleDoorFullyOpen(vehicle, 5) then
        SetVehicleDoorOpen(vehicle, 5, false, false)
    end

    if not IsVehicleSeatFree(vehicle, -1) and not gloveBox then
        return false, 'In mashin ranande darad!'
    end


    return true, nil
end

local function haveAccessLegal(vehicle)
    return exports['Unique_utils']:canAccessToVehicle(vehicle)
end

function openTrunk(vehicle, gloveBox, parkMeter)
    if vehicle and vehicle ~= 0 then
        local model = GetEntityModel(vehicle)
        local ped = PlayerPedId()
        if configTrunk.blackListVehicles[model] then ESX.Alert('', 'In vasile naghlie sandugh nadarad.', 7000, 'error') return false end
        if not IsVehicleSeatFree(vehicle, -1) and not gloveBox then ESX.Alert('', 'In mashin ranande darad', 5000, 'error') return false end
        if ESX.GetPlayerData().World ~= 0 and not ESX.GetPlayerData().inHouse and not exports['gangs']:isInGangWorld()  then return ESX.notification('warn', 'Shoma nemitavanid dar world haye digar az gav sandoogh estefade konid') end
        local locked = GetVehicleDoorLockStatus(vehicle)
        local class = GetVehicleClass(vehicle)
        local plate = ESX.Math.Trim(GetVehicleNumberPlateText(vehicle))
        if IsPedInAnyVehicle(ped) and not gloveBox then return false end
        if configTrunk.noTrunkClass[class] then return false end
        ESX.UI.Menu.CloseAll()
        local owner = (exports['Unique_utils']:canAccessToVehicle(vehicle) or ESX.militaryJobs2[ESX.GetPlayerData().job.name]) or NetworkGetEntityIsNetworked(vehicle) == false
        if gloveBox and not (GetPedInVehicleSeat(vehicle, -1) == ped or GetPedInVehicleSeat(vehicle, 0) == ped ) then
            ESX.Alert('', 'Shoma dastresi be dashboard nadarid.', 5000, 'error')
            return false
        end

        if gloveBox then
            local p = promise.new()
            ESX.TriggerServerCallback('parking:getVehicleMetadataWithKey', function(dashboardLock)
                p:resolve(dashboardLock)
            end, plate, 'dashboardLock')
            local dashboardLock = Citizen.Await(p)
            if dashboardLock then
                if not owner then
                    ESX.notification('error', 'شما اجازه دسترسی به داشبورد این ماشین را ندارید')
                    return false
                end
            else
                owner = true
            end
        end

        if not haveAccessLegal(vehicle) and NetworkGetEntityIsNetworked(vehicle) then
            if not ESX.progressCircle(5000, true, true) then return end
        end

        local realOwner = owner
        if locked == 1 or owner then
            if plate and plate ~= '' then
                local canAccess = false
                local maxWeight = 0
                if exports['esx_vehiclecontrol']:IsGOV(vehicle) and exports['esx_vehiclecontrol']:HaveAccess(vehicle) then
                    maxWeight = 300000
                    canAccess = true
                    realOwner = true
                elseif not exports['esx_vehiclecontrol']:IsGOV(vehicle) then
                    if exports['Unique_utils']:checkncz() then
                        canAccess = owner
                    else
                        canAccess = true
                    end
                end

                if Entity(vehicle).state.JobCenter then
                    if not owner then
                        canAccess = false
                    end
                end

                if canAccess then
                    if gloveBox then
                        maxWeight = configTrunk.vehicleLimitGlove[class]
                        for k,v in pairs(configTrunk.customLimitGlove) do
                            if tonumber(GetHashKey(v.model)) == tonumber(GetEntityModel(vehicle)) then
                                maxWeight = v.limit
                                break
                            end
                        end
                    else
                        maxWeight = configTrunk.vehicleLimit[class]
                        for k,v in pairs(configTrunk.customLimit) do
                            if tonumber(GetHashKey(v.model)) == tonumber(GetEntityModel(vehicle)) then
                                maxWeight = v.limit
                                break
                            end
                        end
                    end
                    currentVehicle = vehicle
                    SetEntityDrawOutline(currentVehicle, true)
                    SetVehicleDoorOpen(currentVehicle, 5, false, false)
                    currentVehicleModel = GetEntityModel(currentVehicle)
                    openOtherInventory({fetch = function(mode, weaponName) return getSecondLazy(gloveBox and ('trunk:glove-box:' .. plate) or ('trunk:' .. plate), mode, weaponName) end, timeout = 1000, label = plate .. (gloveBox and ' (Dashboard)' or ' (Trunk)'), maxWeight = maxWeight, type = 'trunk', disableExitCheck = gloveBox}, function(data)
                        if data.type == 'close' then
                            SetEntityDrawOutline(currentVehicle, false)
                            SetVehicleDoorShut(currentVehicle, 5, false)
                            currentVehicle = 0
                        elseif data.type == 'update' then
                            return sortItems(getVehicleTrunk(plate, gloveBox), 'trunk')
                        elseif data.type == 'moveInside' then
                            data.data.gloveBox = gloveBox
                            ESX.TriggerServerEvent('inventory-trunk:updateSlot', plate, data.data)
                        elseif data.type == 'moveToOther' then
                            if ESX.isDead() then return end
                            local valid, msg = validateTrunkAccess(currentVehicle, realOwner, gloveBox)
                            if not valid then
                                ESX.Alert('', msg, 5000, 'error')
                                closeInventory()
                                return
                            end
                            local used = calculateUsedWeight(plate, gloveBox)
                            data.data.gloveBox = gloveBox
                            if blackListJob[ESX.GetPlayerData().job.name] then
                                local JobAccess = exports['esx_vehiclecontrol']:HaveAccess(currentVehicle)
                                if not JobAccess then return ESX.ShowNotification('Shoma nemitavanid dar in mashin chizi bezarid!') end
                            end
                            if data.data.name == 'stone' and currentVehicleModel ~= rubble then
                                return ESX.Alert('', 'In mashin fazaye sang ra nadarad!', 8000, 'error')
                            end
                            if used + (getItemWeightTrunk(data.data.name) * (data.data.ammo and 1 or data.data.count)) > maxWeight then
                                ESX.Alert('', 'Fazaye mashin por shode ast!', 8000, 'error')
                                local newCount = ESX.Math.Round((maxWeight - used) / getItemWeightTrunk(data.data.name), nil, true)
                                if newCount > 0 then
                                    data.data.count = newCount
                                    data.data.realCount = newCount
                                    ESX.TriggerServerEvent('inventory-trunk:put', plate, data.data, maxWeight)
                                end
                            else
                                ESX.TriggerServerEvent('inventory-trunk:put', plate, data.data, maxWeight)
                            end
                        elseif data.type == 'moveToMain' then
                            if ESX.isDead() then return end
                            local valid, msg = validateTrunkAccess(currentVehicle, realOwner, gloveBox)
                            if not valid then
                                ESX.Alert('', msg, 5000, 'error')
                                closeInventory()
                                return
                            end
                            data.data.gloveBox = gloveBox
                            ESX.TriggerServerEvent('inventory-trunk:get', plate, data.data)
                            Wait(500)
                            if data.data.droppedTo then
                                data.data.inventoryType = 'main'
                                moveInsideHandler(data.data)
                            end
                        end
                    end)
                    Citizen.CreateThread(function()
                        while currentVehicle ~= 0 do
                            Wait(100)
                            local ped = PlayerPedId()
                            if gloveBox then
                                if GetVehiclePedIsIn(ped, false) ~= currentVehicle then
                                    closeInventory()
                                    break
                                end
                            else
                                local coords = GetEntityCoords(ped)
                                local vehicleCoords = GetEntityCoords(currentVehicle)
                                if ESX.GetDistance(coords, vehicleCoords) >= 6.0 or (GetVehicleDoorLockStatus(currentVehicle) ~= 1 and not realOwner) then
                                    closeInventory()
                                    break
                                end
                            end
                        end
                    end)
                else
                    ESX.Alert('', 'Dar vasile naghlie ghofl ast!', 5000, 'error')
                end
            end
        else
            ESX.Alert('', 'Dar vasile naghlie ghofl ast!', 5000, 'error')
        end
    end
end

function getVehicleTrunk(plate, gloveBox)
    local p = promise.new()
    ESX.TriggerServerCallback('inventory-trunk:getVehicleTrunk', function(data)
        p:resolve(data)
    end, plate, gloveBox)
    return Citizen.Await(p)
end

function calculateUsedWeight(plate, gloveBox)
    local items = getVehicleTrunk(plate, gloveBox)
    local used = 0
    if items.items then
        for k, v in pairs(items.items) do
            local item = ESX.getItem(v.name)
            if item then
                used = used + ((ESX.getItemWeight(v.name, 'trunk')) * v.count)
            end
        end
    end
    if items.weapons then
        for k, v in pairs(items.weapons) do
            used = used + ((ESX.getItemWeight(v.name, 'trunk')) or ESX.getWeaponWeight(v.name))
        end
    end
    return used
end

function getItemWeightTrunk(name)
    if name then
        return ESX.getItemWeight(name, 'trunk')
    end
end
exports('openTrunk', openTrunk)

exports('getVehicleMaxWeight',function(vehicle, gloveBox)
    local maxWeight = 0
    local class = GetVehicleClass(vehicle)
    if gloveBox then
        maxWeight = configTrunk.vehicleLimitGlove[class]
        for k,v in pairs(configTrunk.customLimitGlove) do
            if tonumber(GetHashKey(v.model)) == tonumber(GetEntityModel(vehicle)) then
                maxWeight = v.limit
                break
            end
        end
    else
        maxWeight = configTrunk.vehicleLimit[class]
        for k,v in pairs(configTrunk.customLimit) do
            if tonumber(GetHashKey(v.model)) == tonumber(GetEntityModel(vehicle)) then
                maxWeight = v.limit
                break
            end
        end
    end
    return maxWeight
end)
