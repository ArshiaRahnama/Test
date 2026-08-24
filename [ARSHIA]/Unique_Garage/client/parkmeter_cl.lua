
local vehsdamage = {}
local vehsprop   = {}

local playerParkingStatus  = {}
local ParkMeterBlips       = {}
local PosCorrds            = {}
local VehLocal             = {}
local activeAutoParkTimers = {}
local lastDriver           = nil

function SimpleProgressBar(duration, text)
    return lib.progressBar({
        duration = duration,
        label = text or "...",
        useWhileDead = false,
        canCancel = false,
        disable = { move = true, car = true, combat = true, mouse = false },
    })
end

Citizen.CreateThread(function()
    while ESX == nil do Wait(10) end
    Wait(5)
    local playerPed = PlayerPedId()
    local coords    = GetEntityCoords(playerPed)

    for k , v in pairs(Customize.ParkMeter) do

        local blip = AddBlipForCoord(v.xyz)
        SetBlipSprite(blip, 267)
        SetBlipDisplay(blip, 5)
        SetBlipScale(blip, 0.7)
        SetBlipAsShortRange(blip, true)


        SetBlipColour(blip, 2)

        BeginTextCommandSetBlipName("STRING")
        AddTextComponentString('Park meter')
        EndTextCommandSetBlipName(blip)


        ParkMeterBlips[k] = blip
        Citizen.Wait(10)
    end
end)

Citizen.CreateThread(function()
    while ESX == nil do Wait(10) end

    local padModel = GetHashKey('prop_para_target')
    RequestModel(padModel)
    local waited = 0
    while not HasModelLoaded(padModel) and waited < 5000 do Wait(50) waited = waited + 50 end

    for i, location in ipairs(Customize.ParkMeter) do
        if HasModelLoaded(padModel) then
            local pad = CreateObject(padModel, location.x, location.y, location.z - 0.98, false, false, false)
            SetEntityHeading(pad, location.w)
            FreezeEntityPosition(pad, true)
            SetEntityAsMissionEntity(pad, true, true)
        end
    end
end)

Citizen.CreateThread(function()
    while true do
        local sleep = 500
        local ped = PlayerPedId()
        local pedCoords = GetEntityCoords(ped)

        for i, location in ipairs(Customize.ParkMeter) do
            local dist = #(pedCoords - vector3(location.x, location.y, location.z))
            if dist <= 2.5 then
                sleep = 0
                ParkMeter_Draw3DText(location.x, location.y, location.z + 1.2, "~b~Parking Meter")
                ShowHelpNotification("~INPUT_CONTEXT~ Park / Baziabi Mashin")

                if IsControlJustReleased(0, 38) then
                    HandleParkingOrRetrieve(i)
                end
            end
        end

        Wait(sleep)
    end
end)

Citizen.CreateThread(function()
    while true do
        local sleep = 1000
        local ped = PlayerPedId()
        local playerCoords = GetEntityCoords(ped)

        for i, location in ipairs(Customize.ParkMeter) do
            local distance = #(playerCoords - vector3(location.x, location.y, location.z))

            if distance < 20.0 then
                sleep = 5
                local markerColor = {r = 0, g = 255, b = 0}
                local blipColor = 2

                if playerParkingStatus[i] then
                    markerColor = {r = 255, g = 0, b = 0}
                    blipColor = 1
                end

                PosCorrds = {x = location.x, y = location.y, z = location.z}

                DrawMarker(36, location.x, location.y, location.z, 0.0, 0.0, 0.0, 0, 0.0, 0.0, 1.0, 1.0, 1.0, markerColor.r, markerColor.g, markerColor.b, 100, false, true, 2, false, false, false, false)
                DrawMarker(6, location.x, location.y, location.z, 0.0, 0.0, 0.0, 0, 0.0, 0.0, 1.5, 1.5, 1.5, markerColor.r, markerColor.g, markerColor.b, 100, false, true, 2, false, false, false, false)

                SetBlipColour(ParkMeterBlips[i], blipColor)
            else
                PosCorrds = {}
            end
        end

        Citizen.Wait(sleep)
    end
end)

function GetVehicleDamagesPM(vehicle)
	local damages 	   = {['damaged_windows'] = {}, ['burst_tires'] = {}, ['broken_doors'] = {}, ['body_health'] = GetVehicleBodyHealth(vehicle), ['engine_health'] = GetVehicleEngineHealth(vehicle), ['fuel_health'] = GetVehicleFuelLevel(vehicle)}

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

function setDamagesPM(car, damages)
	if type(damages) == 'table' and next (damages) then
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
			SetVehicleBodyHealth(car, (tonumber(damages['body_health']) or 1000) + 0.0)
		end
		if damages['engine_health'] then
			SetVehicleEngineHealth(car, (tonumber(damages['engine_health']) or 1000) + 0.0)
		end
		if damages['fuel_health'] then
			SetVehicleFuelLevel(car, damages['fuel_health'])
		end
	end
end

function ShowFloatingHelpNotification(msg, coords)
    AddTextEntry('floatingHelp', msg)
    SetFloatingHelpTextWorldPosition(1, coords)
    SetFloatingHelpTextStyle(1, 1, 2, -1, 3, 0)
    BeginTextCommandDisplayHelp('floatingHelp')
    EndTextCommandDisplayHelp(2, false, false, -1)
end

function HandleParkingOrRetrieve(markerIndex)
    local ped = GetPlayerPed(-1)
    local vehicle = GetVehiclePedIsIn(ped, false)
    if IsPedInAnyVehicle(ped, false) and GetPedInVehicleSeat(vehicle, -1) == ped then

        vehsprop = ESX.Game.GetVehicleProperties(vehicle)
        vehsdamage = GetVehicleDamagesPM(vehicle)
        ESX.TriggerServerCallback('temporaryParking:getVehicleDatas', function(Chek)
            if not Chek then
                lib.notify({title = 'Parking', description = 'Error!', type = 'error', position = 'center-right'})
                return
            end

            if playerParkingStatus[markerIndex] then
                lib.notify({title = 'Parking', description = 'Shoma Dar In Parking Mashin Darid!', type = 'error', position = 'center-right'})
                return
            end

            local Rest = SimpleProgressBar(3000, "Parking...")

            if Rest then
                RemoveOwnCarBlip(vehicle)
                ESX.Game.DeleteVehicle(vehicle)
                TriggerServerEvent('temporaryParking:storeVehicle', vehsprop, markerIndex)
                PlaySoundFrontend(-1, "CHECKPOINT_NORMAL", "HUD_MINI_GAME_SOUNDSET", true)
                lib.notify({title = 'Parking', description = 'Mashin Shoma Park Shod.', type = 'success', position = 'center-right'})
                playerParkingStatus[markerIndex] = true

                local coords = vector3(Customize.ParkMeter[markerIndex].x, Customize.ParkMeter[markerIndex].y, Customize.ParkMeter[markerIndex].z)
                local heading = Customize.ParkMeter[markerIndex].w

                ESX.Game.SpawnLocalVehicle(vehsprop.model, coords, heading, function(vehicle)
                    ESX.Game.SetVehicleProperties(vehicle, vehsprop)
                    SetVehicleNumberPlateText(vehicle, vehsprop.plate)
                    SetEntityAlpha(vehicle, 150, false)
                    VehLocal[markerIndex] = vehicle
                    setDamagesPM(vehicle, vehsdamage)
                    SetEntityCollision(vehicle, true, true)
                    SetEntityNoCollisionEntity(vehicle, PlayerPedId(), false)
                    SetVehicleCanBeVisiblyDamaged(vehicle, false)
                    SetVehicleUndriveable(vehicle, false)
                    FreezeEntityPosition(vehicle, true)
                    SetVehicleDoorsLocked(vehicle, 0)
                    Wait(500)
                    SetVehicleEngineHealth(vehicle, 1000.0)
                    SetVehicleBodyHealth(vehicle, -10000.0)
                    SetVehiclePetrolTankHealth(vehicle, -10000.0)
                    SetDisableVehiclePetrolTankDamage(vehicle, true)
                    SetDisableVehiclePetrolTankFires(vehicle, true)
                end)
            end
        end, vehsprop.plate)
    else
        TriggerServerEvent('temporaryParking:retrieveVehicle', markerIndex)
    end
end

RegisterNetEvent('temporaryParking:spawnVehicle')
AddEventHandler('temporaryParking:spawnVehicle', function(vehsprop, markerIndex)
    local ped = PlayerPedId()
    local parkingLocation = Customize.ParkMeter[markerIndex]
    local coords = vector3(parkingLocation.x, parkingLocation.y, parkingLocation.z)
    local heading = parkingLocation.w

    local Rest = SimpleProgressBar(3000, "Retrieving...")

    if Rest then
        local Chekorgan = string.sub(vehsprop.plate, 1, 2)
        RemoveOwnCarBlip(VehLocal[markerIndex])
        ESX.Game.DeleteVehicle(VehLocal[markerIndex])
        Wait(50)
        if Chekorgan == "PD" or Chekorgan == "MD" or Chekorgan == 'MC' or Chekorgan == "SH" or Chekorgan == "FB" or Chekorgan == "TX" or Chekorgan == "WZ" then
            ESX.Game.SpawnVehicleJobs(vehsprop.model, coords, heading, function(vehicle)
                ESX.Game.SetVehicleProperties(vehicle, vehsprop)
                setDamagesPM(vehicle, vehsdamage)
                TaskWarpPedIntoVehicle(PlayerPedId(), vehicle, -1)
                AttachOwnCarBlip(vehicle)
            end)
        else
            ESX.Game.SpawnVehicle(vehsprop.model, coords, heading, function(vehicle)
                ESX.Game.SetVehicleProperties(vehicle, vehsprop)
                setDamagesPM(vehicle, vehsdamage)
                TaskWarpPedIntoVehicle(PlayerPedId(), vehicle, -1)
                AttachOwnCarBlip(vehicle)
            end)
        end
        PlaySoundFrontend(-1, "CHECKPOINT_NORMAL", "HUD_MINI_GAME_SOUNDSET", true)
        lib.notify({title = 'Parking', description = 'ماشین شما اسپاون شد', type = 'success', position = 'center-right'})
        playerParkingStatus[markerIndex] = false
    end
end)

Citizen.CreateThread(function()
    while true do
        Wait(1000)
        local ped = PlayerPedId()
        local vehicle = GetVehiclePedIsIn(ped, false)

        if vehicle ~= 0 and GetPedInVehicleSeat(vehicle, -1) == ped then
            lastDriver = vehicle
        end
    end
end)

Citizen.CreateThread(function()
    while true do
        Wait(500)
        local ped = PlayerPedId()
        local isInVehicle = IsPedInAnyVehicle(ped, false)

        if not isInVehicle and lastDriver ~= nil then
            local veh = lastDriver
            lastDriver = nil

            local plate = ESX.Math.Trim(GetVehicleNumberPlateText(veh))
            local coords = GetEntityCoords(veh)

            for i, location in ipairs(Customize.ParkMeter) do
                local dist = #(coords - vector3(location.x, location.y, location.z))
                if dist < 10.0 then
                    ESX.TriggerServerCallback('CarLock:haskey', function(hasKey)
                        if hasKey then
                            if not activeAutoParkTimers[plate] then
                                StartParkCountdown(veh, plate, i)
                            end
                        end
                    end, plate)
                    break
                end
            end
        end

        Wait(1000)
    end
end)

function StartParkCountdown(vehicle, plate, zoneIndex)
    local duration = 15
    local Sonie = 15
    local DrawTex = true
    if playerParkingStatus[zoneIndex] then return end

    activeAutoParkTimers[plate] = duration
    ESX.TriggerServerCallback('temporaryParking:getVehicleDatas', function(bucket)

        if not bucket then activeAutoParkTimers[plate] = nil return end

        local playerPed = PlayerPedId()
        Citizen.CreateThread(function()
            while duration ~= 0  and DoesEntityExist(vehicle) do
                duration = duration - 1

                local playerPed = PlayerPedId()
                local playerCoords = GetEntityCoords(playerPed)
                local vehCoords = GetEntityCoords(vehicle)
                local dist = #(playerCoords - vehCoords)

                if GetPedInVehicleSeat(vehicle, -1) == PlayerPedId() then
                    activeAutoParkTimers[plate] = nil
                    DrawTex = false
                    return
                end

                if dist < 3.0 then
                    duration = duration + 1
                else
                    Sonie = Sonie - 1
                end

                Citizen.CreateThread(function()
                    while DrawTex do
                        ParkMeter_Draw3DText(vehCoords.x, vehCoords.y, vehCoords.z + 1.5, "~w~Park in : ~r~" .. Sonie .. " s")
                        Wait(1)
                    end
                end)

                Wait(1000)
            end
            DrawTex = false

            if DoesEntityExist(vehicle) and activeAutoParkTimers[plate] then
                vehsprop = ESX.Game.GetVehicleProperties(vehicle)
                vehsdamage = GetVehicleDamagesPM(vehicle)

                ESX.Game.DeleteVehicle(vehicle)
                RemoveOwnCarBlip(vehicle)
                TriggerServerEvent('temporaryParking:storeVehicle', vehsprop, zoneIndex)
                playerParkingStatus[zoneIndex] = true
                local coords = vector3(Customize.ParkMeter[zoneIndex].x, Customize.ParkMeter[zoneIndex].y, Customize.ParkMeter[zoneIndex].z)
                local heading = Customize.ParkMeter[zoneIndex].w

                ESX.Game.SpawnLocalVehicle(vehsprop.model, coords, heading, function(vehicle)
                    ESX.Game.SetVehicleProperties(vehicle, vehsprop)
                    SetVehicleNumberPlateText(vehicle, vehsprop.plate)
                    SetEntityAlpha(vehicle, 150, false)
                    VehLocal[zoneIndex] = vehicle
                    setDamagesPM(vehicle, vehsdamage)
                    SetEntityCollision(vehicle, true, true)
                    SetEntityNoCollisionEntity(vehicle, PlayerPedId(), false)
                    SetVehicleCanBeVisiblyDamaged(vehicle, false)
                    SetVehicleUndriveable(vehicle, false)
                    FreezeEntityPosition(vehicle, true)
                    SetVehicleDoorsLocked(vehicle, 0)
                    Wait(500)
                    SetVehicleEngineHealth(vehicle, 1000.0)
                    SetVehicleBodyHealth(vehicle, -10000.0)
                    SetVehiclePetrolTankHealth(vehicle, -10000.0)
                    SetDisableVehiclePetrolTankDamage(vehicle, true)
                    SetDisableVehiclePetrolTankFires(vehicle, true)
                end)

                lib.notify({title = 'Parking', description = 'ماشین شما به صورت خودکار پارک شد.', type = 'success', position = 'center-right'})
            end

            activeAutoParkTimers[plate] = nil

        end)
    end, plate)
end

function ParkMeter_Draw3DText(x, y, z, text)
    SetTextScale(0.50, 0.50)
    SetTextFont(4)
    SetTextProportional(1)
    SetTextColour(255, 255, 255, 215)
    SetTextEntry("STRING")
    SetTextCentre(true)
    AddTextComponentString(text)
    SetDrawOrigin(x, y, z, 0)
    DrawText(0.0, 0.0)
    ClearDrawOrigin()
end