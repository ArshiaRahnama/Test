-- Pub by FleeX Team , https://discord.gg/87rGBxgCsa

local nearVehicle
local vehiclesOwnerCache, canAccessCache, blipsData = {}, {}, {vehicles = {}, thread = false}

AddEventHandler('onKeyDown', function(key)
    if key == 'y' then
        if not ESX.isDead() then
            ManageLockAction('lock')
        end
    elseif key == 'u' then
        if not ESX.isDead() then
            ManageLockAction('unlock')
        end
    end
end)

local function Me(bool)
    if bool then
        ExecuteCommand('me vasile ro ghofl mikone')
    else
        ExecuteCommand('me vasile ro baz mikone')
    end
end

local function lockVehicle(vehicle)
    SetVehicleDoorShut(vehicle, 0, false)
    SetVehicleDoorShut(vehicle, 1, false)
    SetVehicleDoorShut(vehicle, 2, false)
    SetVehicleDoorShut(vehicle, 3, false)
    SetVehicleDoorsLocked(vehicle, 2)
    local NetId = NetworkGetNetworkIdFromEntity(vehicle)
    TriggerServerEvent('esx_vehiclecontrol:sync', NetId, true)
    PlayVehicleDoorCloseSound(vehicle, 1)
end
exports('lockVehicle', lockVehicle)

local function unlockVehicle(vehicle)
    SetVehicleDoorsLocked(vehicle, 1)
    local NetId = NetworkGetNetworkIdFromEntity(vehicle)
    TriggerServerEvent('esx_vehiclecontrol:sync', NetId, false)
    PlayVehicleDoorOpenSound(vehicle, 0)
end
exports('unlockVehicle', unlockVehicle)

local dict = "anim@mp_player_intmenu@key_fob@"
function ManageLockAction(action)
    ESX.Streaming.RequestAnimDict(dict)
    if ESX.checkCooldown('carlock', 1000) then
        local ped = PlayerPedId()
        local vehicle = IsPedSittingInAnyVehicle(ped) and GetVehiclePedIsIn(ped, false) or nearVehicle
        if vehicle then
            local plate = ESX.Math.Trim(GetVehicleNumberPlateText(vehicle))
            if canAccessToVehicle(vehicle) or exports['esx_vehiclecontrol']:HaveAccess(vehicle) then
                local vehicleLabel = GetDisplayNameFromVehicleModel(GetEntityModel(vehicle))
                vehicleLabel = GetLabelText(vehicleLabel)
                if string.lower(vehicleLabel) == 'null' then
                    local newname = ESX.GetVehicleLabelFromName(GetDisplayNameFromVehicleModel(GetEntityModel(vehicle)))
                    if newname ~= "Unknown" then
                        vehicleLabel = newname
                    end
                end
                SetCurrentPedWeapon(ped, `WEAPON_UNARMED`, true)
                local lock = GetVehicleDoorLockStatus(vehicle)

                if action == 'lock' then
                    if lock == 2 then
                        ESX.ShowNotification('~y~'..vehicleLabel..'~s~ az ghabl ~r~ghofle~w~!')
                        lib.showTextUI('[ Y ] Ghofl shod - [ U ] Jahat baz kardan', { icon = 'lock', color = 'red' })
                        SetTimeout(10000, function() lib.hideTextUI() end)
                        return
                    end
                    lockVehicle(vehicle)
                    SetEntityDrawOutline(vehicle, true)
                    SetTimeout(1000, function() SetEntityDrawOutline(vehicle, false) end)
                    ESX.ShowNotification('Shoma dar ~y~'..vehicleLabel..'~s~ ('.. plate ..') ra ~r~bastid~w~!')
                    lib.showTextUI('[ Y ] Ghofl shod - [ U ] Jahat baz kardan', { icon = 'lock', color = 'red' })
                    SetTimeout(10000, function() lib.hideTextUI() end)
                    Me(true)
                    if not IsPedInAnyVehicle(ped, true) then
                        TaskPlayAnim(ped, dict, "fob_click_fp", 8.0, 8.0, -1, 48, 1, false, false, false)
                    end
                    TriggerServerEvent("InteractSound_SV:PlayWithinDistance", 3, "lock", 0.5)

                elseif action == 'unlock' then
                    if lock == 1 or lock == 0 then
                        ESX.ShowNotification('~y~'..vehicleLabel..'~s~ az ghabl ~g~baze~w~!')
                        lib.showTextUI('[ U ] Baz shod - [ Y ] Jahat ghofl kardan', { icon = 'lock-open', color = 'green' })
                        SetTimeout(10000, function() lib.hideTextUI() end)
                        return
                    end
                    unlockVehicle(vehicle)
                    SetEntityDrawOutline(vehicle, true)
                    SetTimeout(1000, function() SetEntityDrawOutline(vehicle, false) end)
                    ESX.ShowNotification('Shoma dar ~y~'..vehicleLabel..'~s~ ('.. plate ..') ra ~g~baz~w~ kardid!')
                    lib.showTextUI('[ U ] Baz shod - [ Y ] Jahat ghofl kardan', { icon = 'lock-open', color = 'green' })
                    SetTimeout(10000, function() lib.hideTextUI() end)
                    Me(false)
                    if not IsPedInAnyVehicle(ped, true) then
                        TaskPlayAnim(ped, dict, "fob_click_fp", 8.0, 8.0, -1, 48, 1, false, false, false)
                    end
                    TriggerServerEvent("InteractSound_SV:PlayWithinDistance", 3, "unlock", 0.5)
                end
            else
                ESX.ShowNotification('Mashini kenar shoma nist')
            end
        else
            ESX.ShowNotification('Mashini kenar shoma nist')
        end
    else
        ESX.ShowNotification("~r~Spam nakonid")
    end
end

function ManageLock()
    local ped = PlayerPedId()
    local vehicle = IsPedSittingInAnyVehicle(ped) and GetVehiclePedIsIn(ped, false) or nearVehicle
    if vehicle then
        local lock = GetVehicleDoorLockStatus(vehicle)
        if lock == 1 or lock == 0 then
            ManageLockAction('lock')
        elseif lock == 2 then
            ManageLockAction('unlock')
        end
    end
end

RegisterCommand('netid', function(source)
    if ESX.GetPlayerData().permission_level > 0 then
        local vehicle = GetVehiclePedIsIn(GetPlayerPed(-1))
        if vehicle then
            local netID = NetworkGetNetworkIdFromEntity(vehicle)
            TriggerEvent("chatMessage", "[DevTools]", {255, 0, 0}, "^0This is vehicle network ID: " .. tostring(netID), 'plarms')
        else
            TriggerEvent("chatMessage", "[DevTools]", {255, 0, 0}, "^0Shoma dakhel hich mashini nistid!", 'plarms')
        end
    end
end, false)

exports('ManageLock',ManageLock)

function canAccessToVehicle(vehicle)
    local plate = ESX.GetPlate(vehicle)
    if plate then
        if not vehiclesOwnerCache[plate] then
            local p = promise.new()
            ESX.TriggerServerCallback('carlock:isVehicleOwner', function(owner, gang)
                if owner then
                    vehiclesOwnerCache[plate] = {owner = owner, gang = gang}
                end
                p:resolve()
            end, ESX.GetPlate(vehicle))
            SetTimeout(4000, function()
                if p then
                    vehiclesOwnerCache[plate] = {owner = 'n', gang = 'n'}
                    p:resolve()
                end
            end)
            Citizen.Await(p)
            p = nil
        end
        local canAccess = (ESX.DoesHaveItem2(('key_%s'):format(plate), 1)) or (vehiclesOwnerCache[plate] and (vehiclesOwnerCache[plate].owner == ESX.PlayerData.identifier or ((vehiclesOwnerCache[plate].owner == ESX.PlayerData.gang.name:lower() or vehiclesOwnerCache[plate].owner == ESX.PlayerData.gang.name or vehiclesOwnerCache[plate].gang == ESX.PlayerData.gang.name:lower()) and ESX.PlayerData.gang.grade > 1))) or exports['esx_vehiclecontrol']:HaveAccess(vehicle)
        if canAccess then
            canAccessCache[plate] = true
        else
            canAccessCache[plate] = nil
        end
        return canAccess
    else
        return false
    end
end

exports('canAccessToVehicle', canAccessToVehicle)

CreateThread(function()
    while true do
        Wait(1000)
        local ped = PlayerPedId()
        if not IsPedSittingInAnyVehicle(ped) then
            local vehicles = GetGamePool('CVehicle')
            local near
            local coords = GetEntityCoords(PlayerPedId())
            for i = 1, #vehicles do
                local distance = #(coords - GetEntityCoords(vehicles[i]))
                if (not near or distance < near.distance) and distance < 20 then
                    near = {vehicle = vehicles[i], distance = distance}
                end
            end
            if near then
                if nearVehicle ~= near.vehicle and IsVehicleSeatFree(near.vehicle, -1) then
                    if IsEntityDead(near.vehicle) then
                        nearVehicle = nil
                        ESX.Game.DeleteEntity(near.vehicle)
                    else
                        nearVehicle = near.vehicle
                        local plate = ESX.Math.Trim(GetVehicleNumberPlateText(nearVehicle))
                        if not blipsData.vehicles[nearVehicle] and canAccessCache[plate] then
                            local blip = AddBlipForEntity(nearVehicle)
                            SetBlipSprite(blip, 595)
                            SetBlipColour(blip, 2)
                            SetBlipScale(blip, 0.7)
                            SetBlipDisplay(blip, 5)
                            SetBlipAsShortRange(blip, true)
                            blipsData.vehicles[nearVehicle] = blip
                            if not blipsData.thread then
                                blipsData.thread = true
                                CreateThread(function()
                                    while blipsData.thread do
                                        Wait(15000)
                                        if ESX.tableLength(blipsData.vehicles) == 0 then
                                            blipsData.thread = false
                                            break
                                        end
                                        local coords = GetEntityCoords(PlayerPedId())
                                        for k, v in pairs(blipsData.vehicles) do
                                            if DoesEntityExist(k) then
                                                if #(coords - GetEntityCoords(k)) > 50 then
                                                    RemoveBlip(v)
                                                    blipsData.vehicles[k] = nil
                                                end
                                            else
                                                blipsData.vehicles[k] = nil
                                            end
                                        end
                                    end
                                end)
                            end
                        end
                        CreateThread(function()
                            local minV, maxV = GetModelDimensions(GetEntityModel(nearVehicle))
                            local modelResult = maxV - minV
                            local modelz = modelResult.z - (modelResult.z * 25 / 100)
                            while nearVehicle == near.vehicle do
                                if IsPedSittingInAnyVehicle(ped) or not IsVehicleSeatFree(nearVehicle, -1) then
                                    nearVehicle = nil
                                    break
                                end
                                local color = canAccessCache[plate] and {0, 255, 0} or {255, 128, 0}
                                local coords = GetEntityCoords(nearVehicle)
                                DrawMarker(3, coords.x, coords.y, coords.z + modelz, 0.0, 0.0, 0.0, 0.0, 180.0, 0.0, 0.15, 0.15, 0.15, color[1], color[2], color[3], 150, false, true, 2, false, nil, nil, nil)
                                Wait(0)
                            end
                        end)
                    end
                end
            else
                nearVehicle = nil
            end
        end
    end
end)

local checkedKVP = false
local function ShowLockChangePopup()
    exports['sun-helpmenu']:open2('carctl')
    SetResourceKvp("carlock_popup_seen", "true")
end

AddEventHandler('enterVehicle', function(vehicle)
    if blipsData.vehicles[vehicle] then
        RemoveBlip(blipsData.vehicles[vehicle])
        blipsData.vehicles[vehicle] = nil
    end

    if not checkedKVP then
        checkedKVP = true
        if GetResourceKvpString("carlock_popup_seen") ~= "true" then
            ShowLockChangePopup()
        end
    end
end)

AddEventHandler('KeyDown:f', function()
    Wait(100)
    local ped = PlayerPedId()
    local vehicle = GetVehiclePedIsTryingToEnter(ped)
    if vehicle ~= 0 then
        if GetVehicleDoorLockStatus(vehicle) == 2 and canAccessToVehicle(vehicle) then
            SetVehicleDoorsLocked(vehicle, 1)
            PlayVehicleDoorOpenSound(vehicle, 0)
            SetEntityDrawOutline(vehicle, true)
            SetTimeout(2000, function()
                SetVehicleDoorsLocked(vehicle, 2)
                SetEntityDrawOutline(vehicle, false)
            end)
        end
    end
end)