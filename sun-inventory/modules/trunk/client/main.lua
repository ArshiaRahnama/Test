--[[
    sun-inventory — vehicle trunk/glovebox client.

    FIXES applied here (verified against the actual resources on this
    server, not assumed):
      - ESX.Alert doesn't exist anywhere in essentialmode -> ESX.ShowNotification
        (which does: client/functions.lua).
      - ESX.GetDistance doesn't exist -> plain vector subtraction.
      - ESX.getItem / ESX.getItemWeight / ESX.getWeaponWeight are SERVER-ONLY
        in this essentialmode (server/common.lua is a server_script, never
        shared) - calling them client-side would hard-error. Item weight is
        already sent to the client on every item (see essentialmode
        server/classes/player.lua: `weight = ESX.getItemWeight(name)` is
        baked into each inventory item), so this now reads `.weight` off
        the player's own live inventory/loadout instead of calling a
        function that was never going to exist here.
      - exports['esx_vehiclecontrol'] and exports.sunset_chop_shop point at
        resources that don't exist ANYWHERE in this project (checked the
        whole codebase) - calling exports on a resource that isn't running
        throws, it doesn't return nil. Both are now guarded with
        GetResourceState() and fall back to "not government / no special
        access" when absent, so trunk access still works normally, it just
        never grants the GOV/chop-shop bonuses those integrations would add
        if you actually install them.
]]

local currentVehicle = 0

local function resourceStarted(name)
    return GetResourceState(name) == 'started'
end

local function isGovVehicle(vehicle)
    if not resourceStarted('esx_vehiclecontrol') then return false end
    local ok, result = pcall(function() return exports['esx_vehiclecontrol']:IsGOV(vehicle) end)
    return ok and result or false
end

local function haveGovAccess(vehicle)
    if not resourceStarted('esx_vehiclecontrol') then return false end
    local ok, result = pcall(function() return exports['esx_vehiclecontrol']:HaveAccess(vehicle) end)
    return ok and result or false
end

local function inChopShopZone()
    if not resourceStarted('sunset_chop_shop') then return false end
    local ok, result = pcall(function() return exports.sunset_chop_shop:checkncz() end)
    return ok and result or false
end

-- Player's own inventory already carries each item's precomputed .weight
-- (see essentialmode/server/classes/player.lua) - use that instead of a
-- server-only ESX function.
function getItemWeightTrunk(name)
    if not name then return 0 end
    local playerData = ESX.GetPlayerData()
    for _, v in pairs(playerData.inventory or {}) do
        if v.name == name and v.weight then return v.weight end
    end
    for _, v in pairs(playerData.loadout or {}) do
        if v.name == name then return v.weight or (Config and Config.WeaponDefaultWeight) or 2 end
    end
    return 0.5
end

function openTrunk(vehicle, gloveBox)
    if vehicle and vehicle ~= 0 then
        local model = GetEntityModel(vehicle)
        local ped = PlayerPedId()
        if configTrunk.blackListVehicles[model] then ESX.ShowNotification('In vasile naghlie sandugh nadarad.') return false end
        if not IsVehicleSeatFree(vehicle, -1) and not gloveBox then ESX.ShowNotification('In mashin ranande darad') return false end
        local locked = GetVehicleDoorLockStatus(vehicle)
        local class = GetVehicleClass(vehicle)
        local plate = ESX.Math.Trim(GetVehicleNumberPlateText(vehicle))
        if IsPedInAnyVehicle(ped) and not gloveBox then return false end
        if configTrunk.noTrunkClass[class] then return false end
        ESX.UI.Menu.CloseAll()
        local owner = false
        local p = promise.new()
        -- FIX: 'carlock:isVehicleOwner' was never registered anywhere on this
        -- server (checked the whole codebase) — opening a trunk would just
        -- hang forever waiting on a callback nobody answers. Unique_Garage's
        -- carlock_sv.lua registers 'CarLock:haskey' with the exact same
        -- signature (plate in, boolean owner/key-holder out), so use that.
        ESX.TriggerServerCallback('CarLock:haskey', function(result)
            p:resolve(result)
        end, plate)
        owner = Citizen.Await(p) or gloveBox
        if gloveBox and not (GetPedInVehicleSeat(vehicle, -1) == ped or GetPedInVehicleSeat(vehicle, 0) == ped ) then
            ESX.ShowNotification('Shoma dastresi be dashboard nadarid.')
            return false
        end
        local realOwner = owner
        if locked == 1 or owner then
            if plate and plate ~= '' then
                local canAccess = false
                local maxWeight = 0
                if isGovVehicle(vehicle) and haveGovAccess(vehicle) then
                    maxWeight = 300000
                    canAccess = true
                    realOwner = true
                elseif not isGovVehicle(vehicle) then
                    if inChopShopZone() then
                        canAccess = owner
                    else
                        canAccess = true
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
                    local items = sortItems(getVehicleTrunk(plate, gloveBox), 'trunk')
                    openOtherInventory({items = items, timeout = 1000, label = plate .. (gloveBox and ' (Dashboard)' or ' (Trunk)'), maxWeight = maxWeight, disableExitCheck = gloveBox}, function(data)
                        if data.type == 'close' then
                            SetEntityDrawOutline(currentVehicle, false)
                            SetVehicleDoorShut(currentVehicle, 5, false)
                            currentVehicle = 0
                        elseif data.type == 'update' then
                            return sortItems(getVehicleTrunk(plate, gloveBox), 'trunk')
                        elseif data.type == 'moveInside' then
                            data.data.gloveBox = gloveBox
                            TriggerServerEvent('inventory-trunk:updateSlot', plate, data.data)
                        elseif data.type == 'moveToOther' then
                            if IsPlayerDead() then return end
                            local used = calculateUsedWeight(plate, gloveBox)
                            data.data.gloveBox = gloveBox
                            if blackListJob[ESX.GetPlayerData().job.name] then
                                if not haveGovAccess(currentVehicle) then return ESX.ShowNotification('Shoma nemitavanid dar in mashin chizi bezarid!') end
                            end
                            if used + (getItemWeightTrunk(data.data.name) * (data.data.ammo and 1 or data.data.count)) > maxWeight then
                                ESX.ShowNotification('Fazaye mashin por shode ast!')
                                local newCount = math.floor((maxWeight - used) / getItemWeightTrunk(data.data.name))
                                if newCount > 0 then
                                    data.data.count = newCount
                                    data.data.realCount = newCount
                                    TriggerServerEvent('inventory-trunk:put', plate, data.data)
                                end
                            else
                                TriggerServerEvent('inventory-trunk:put', plate, data.data)
                            end
                        elseif data.type == 'moveToMain' then
                            if IsPlayerDead() then return end
                            data.data.gloveBox = gloveBox
                            TriggerServerEvent('inventory-trunk:get', plate, data.data)
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
                            local coords = GetEntityCoords(PlayerPedId())
                            local vehicleCoords = GetEntityCoords(currentVehicle)
                            if #(coords - vehicleCoords) >= 6.0 or (GetVehicleDoorLockStatus(currentVehicle) ~= 1 and not realOwner) then
                                closeInventory()
                                break
                            end
                        end
                    end)
                else
                    ESX.ShowNotification('Dar vasile naghlie ghofl ast!')
                end
            end
        else
            ESX.ShowNotification('Dar vasile naghlie ghofl ast!')
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
            used = used + (getItemWeightTrunk(v.name) * v.count)
        end
    end
    if items.weapons then
        for k, v in pairs(items.weapons) do
            used = used + getItemWeightTrunk(v.name)
        end
    end
    return used
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
