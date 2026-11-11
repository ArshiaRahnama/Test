ESX, LastCamera, currentVeh = nil, nil, nil
PlayerData = nil
LastGangJob = nil
local inGarage = 0
HZ = Citizen

-- ================= FMGangs bridge =================
-- FMGangs handles its own marker/proximity/E-press UI for gang garages; it
-- just calls these two events to open the take-out menu and to store the
-- vehicle the player is currently sitting in.
RegisterNetEvent('Unique_Garage:OpenGangGarage')
AddEventHandler('Unique_Garage:OpenGangGarage', function(gangName, coord, vehType)
	OpenMenuG('gang', { gangName = gangName, coord = coord, vehType = vehType or 'car' })
end)

-------------------------------------------------------------------
-- FEATURE (requested: bring the same garage menu that already works for
-- gangs to organization/job vehicle garages too). esx_uniquejobs'
-- per-job client files (police_main.lua etc.) call this the exact same
-- way FMGangs calls OpenGangGarage above - see OpenMenuG's new "jobfleet"
-- branch further down for how this reuses the SAME GetVehicles/
-- IsVehOwned/SetVehState calls the gang menu already proved out (they're
-- driven by a plain `owner` string + a literal "Gang" type tag, nothing
-- in Unique_Garage/server.lua actually validates it's a real gang - a job
-- name in that same slot works identically).
-------------------------------------------------------------------
RegisterNetEvent('esx_society:jobRankVehicleAccessResult') -- FIX: server->client event must be net-registered or it is dropped ('not safe for net')
RegisterNetEvent('Unique_Garage:OpenJobFleetGarage')
AddEventHandler('Unique_Garage:OpenJobFleetGarage', function(jobName, coord, vehType)
	OpenMenuG('jobfleet', { jobName = jobName, coord = coord, vehType = vehType or 'car' })
end)

RegisterNetEvent('Unique_Garage:StoreJobFleetVehicle')
AddEventHandler('Unique_Garage:StoreJobFleetVehicle', function(jobName)
	-- Identical body to StoreGangVehicle below - the server side
	-- (SetVehState/IsVehOwned) only ever looks at the string passed as
	-- `playerjob` when `job == 'Gang'`, so this reuses it unchanged.
	TriggerEvent('Unique_Garage:StoreGangVehicle', jobName)
end)

RegisterNetEvent('Unique_Garage:StoreGangVehicle')
AddEventHandler('Unique_Garage:StoreGangVehicle', function(gangName)
	local PlayerPed = PlayerPedId()
	local veh = GetVehiclePedIsIn(PlayerPed, false)
	if veh == 0 then
		SafeNotify('Shoma Bayad Dakhele Mashin Bashid!')
		return
	end
	if GetVehicleNumberOfPassengers(veh) ~= 0 then return end
	local Plate = GetPlate(veh)
	ESX.TriggerServerCallback('IsVehOwned', function(owned)
		if not owned then
			SafeNotify('In Mashin Motaalegh Be In Gang Nist!')
			return
		end
		local bodyDamage = math.ceil(GetVehicleBodyHealth(veh))
		local engineDamage = math.ceil(GetVehicleEngineHealth(veh))
		local totalFuel = Customize.GetVehFuel(veh)
		local vehicleProps = ESX.Game.GetVehicleProperties(veh)
		TriggerServerEvent('SetVehState', 1, Plate, {
			fuel = totalFuel, engine = engineDamage, body = bodyDamage, props = vehicleProps
		}, 'Gang', gangName)
		for i = -1, 5, 1 do
			local seat = GetPedInVehicleSeat(veh, i)
			if seat then TaskLeaveVehicle(seat, veh, 0) end
		end
		SetVehicleDoorsLocked(veh)
		Wait(1500)
		HZDeleteVehicle(veh)
	end, Plate, 'Gang', gangName)
end)

function SafeNotify(msg)
    local ok = pcall(function() ESX.ShowNotification(msg) end)
    if not ok then
        SetNotificationTextEntry("STRING")
        AddTextComponentString(msg)
        DrawNotification(false, false)
    end
end

-- FIX: the server used to fire 'esx_Notification:SendNotification', an event
-- this resource never registered a handler for, so "You Don't Have Money"
-- and similar server-side messages were silently swallowed on the client.
-- This gives the server a reliable way to talk to SafeNotify.
RegisterNetEvent('Unique_Garage:Notify', function(msg)
    SafeNotify(msg)
end)

function ToStoredNum(v)
    if type(v) == 'boolean' then
        return v and 1 or 0
    end
    return tonumber(v) or 0
end


if Customize.ESX == 'ESX' then
    HZ.CreateThread(function() while not ESX do TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end) PlayerData = ESX.GetPlayerData() HZ.Wait(10) end end)
end

RegisterNetEvent('ImpoundVehicle', function(vehicles)
	local vehicle
	if vehicles then
		vehicle = vehicles
	else
		vehicle = GetClosestVehicle()
	end
    local bodyDamage = math.ceil(GetVehicleBodyHealth(vehicle))
    local engineDamage = math.ceil(GetVehicleEngineHealth(vehicle))
    local totalFuel = Customize.GetVehFuel(vehicle)
    if vehicle ~= 0 and vehicle then
        local ped = PlayerPedId()
        local pos = GetEntityCoords(ped)
        local vehpos = GetEntityCoords(vehicle)


		if (not IsPedAPlayer(GetPedInVehicleSeat(vehicle, -1))) then
            local plate = GetPlate(vehicle)
            TriggerServerEvent("SetVehImpound", plate, bodyDamage, engineDamage, totalFuel)
            HZDeleteVehicle(vehicle)
        end
    end
end)

RegisterNetEvent('Unique_Garage:DeleteAllVehicle')
AddEventHandler('Unique_Garage:DeleteAllVehicle', function()
	local vehicles = ESX.Game.GetVehicles()
	for _,entity in ipairs(vehicles) do
		if IsAnyPedInVehicle(entity) then
			return
		end
		NetworkRequestControlOfEntity(entity)
		local timeout = 2000
		while timeout > 0 and not NetworkHasControlOfEntity(entity) do
			Wait(100)
			timeout = timeout - 100
		end
		SetEntityAsMissionEntity(entity, true, true)
		local timeout = 2000
		while timeout > 0 and not IsEntityAMissionEntity(entity) do
			Wait(100)
			timeout = timeout - 100
		end
		TriggerEvent("ImpoundVehicle", entity)
		if (DoesEntityExist(entity)) then
			DeleteEntity(entity)
		end
	end
end)

function IsAnyPedInVehicle(veh)
	return (GetVehicleNumberOfPassengers(veh)+(IsVehicleSeatFree(veh,-1) and 0 or 1))>0
end

RegisterNetEvent("Unique_Garage:DeleteAllVehicle")
AddEventHandler("Unique_Garage:DeleteAllVehicle", function()
    for vehicle in EnumerateVehicles() do
        if (not IsPedAPlayer(GetPedInVehicleSeat(vehicle, -1))) then
            SetVehicleHasBeenOwnedByPlayer(vehicle, false)
            SetEntityAsMissionEntity(vehicle, false, false)
			TriggerEvent("ImpoundVehicle", vehicle)
            ESX.Game.DeleteVehicle(vehicle)
            DeleteVehicle(vehicle)
            if (DoesEntityExist(vehicle)) then
                DeleteVehicle(vehicle)
            end
        end
    end
end)

local entityEnumerator = {
    __gc = function(enum)
    if enum.destructor and enum.handle then
      enum.destructor(enum.handle)
    end
    enum.destructor = nil
    enum.handle = nil
  end
}

local function EnumerateEntities(initFunc, moveFunc, disposeFunc)
	return coroutine.wrap(function()
		local iter, id = initFunc()
		if not id or id == 0 then
		  disposeFunc(iter)
		  return
		end

		local enum = {handle = iter, destructor = disposeFunc}
		setmetatable(enum, entityEnumerator)

		local next = true
		repeat
		  coroutine.yield(id)
		  next, id = moveFunc(iter)
		until not next

		enum.destructor, enum.handle = nil, nil
		disposeFunc(iter)
	end)
end

function EnumerateObjects()
	return EnumerateEntities(FindFirstObject, FindNextObject, EndFindObject)
end

function EnumeratePeds()
	return EnumerateEntities(FindFirstPed, FindNextPed, EndFindPed)
end

function EnumerateVehicles()
	return EnumerateEntities(FindFirstVehicle, FindNextVehicle, EndFindVehicle)
end

function EnumeratePickups()
	return EnumerateEntities(FindFirstPickup, FindNextPickup, EndFindPickup)
end

RegisterNetEvent('esx_SetJobPlayers')
AddEventHandler('esx_SetJobPlayers', function(job)
    if PlayerData then PlayerData.job = job end
end)


-- gang / organisation fleet camera: same shot at every location (relative to the marker heading)
local function BuildFleetCamera(extra)
    local heading = extra.coord.h or 0.0
    local camAngleOffset, camDistance, camHeight = 40.0, 4.5, 1.3
    local placeAngle = math.rad(heading + camAngleOffset)
    LastCamera = {
        vehSpawn = vector4(extra.coord.x, extra.coord.y, extra.coord.z, extra.coord.h),
        location = {
            posX = extra.coord.x + camDistance * -math.sin(placeAngle),
            posY = extra.coord.y + camDistance * math.cos(placeAngle),
            posZ = extra.coord.z + camHeight,
            rotX = -8.0, rotY = 0.0, rotZ = heading + camAngleOffset + 180.0, fov = 45.0
        }
    }
    LastSpawnPos = LastCamera.vehSpawn
end

OpenMenuG = function(type, extra)
    local Callback = ESX.TriggerServerCallback
    LastGangJob = nil
    MenuContext = { kind = type }
    if type == 'gang' then
        BuildFleetCamera(extra)
        LastGangJob = extra.gangName
        Callback('FMGangs:GetRankAccess', function(access)
            local vehicleAccess = access and access.vehicleAccess
            Callback('GetVehicles', function(data)
                if data == nil then SafeNotify("Shoma Hich Mashini Nadarid!") return end
                inGarage = 0
                local newData = {}
                for _, vh in pairs(data) do
                    PrepareRow(vh)
                    if not (vehicleAccess and vehicleAccess[vh.VehKey] == false) then NewTable(newData, vh) end
                end
                Camera()
                SendReactMessage('setOpen', { setVeh = newData, setName = extra.gangName .. ' Garage', inGarage = inGarage, Price = 0,
                    allVehicleCount = #GetAllVehicleModels(), ownedVehicleCount = #newData, ownedVehicleCountUniq = #newData })
                SetNuiFocus(true, true)
            end, "Gang", extra.gangName, extra.vehType)
        end, extra.gangName)
    elseif type == 'jobfleet' then
        BuildFleetCamera(extra)
        LastGangJob = extra.jobName
        local jobAccessReceived, jobVehicleAccess = false, {}
        local jobAccessHandler = AddEventHandler('esx_society:jobRankVehicleAccessResult', function(access)
            jobVehicleAccess = (access and access.vehicleAccess) or {}
            jobAccessReceived = true
        end)
        TriggerServerEvent('esx_society:requestJobRankVehicleAccess')
        Citizen.CreateThread(function()
            local timeout = GetGameTimer() + 3000
            while not jobAccessReceived and GetGameTimer() < timeout do Citizen.Wait(0) end
            RemoveEventHandler(jobAccessHandler)
            local vehicleAccess = jobVehicleAccess
            Callback('GetVehicles', function(data)
                data = data or {}
                inGarage = 0
                local newData = {}
                for _, vh in pairs(data) do
                    PrepareRow(vh)
                    if not (vehicleAccess and vehicleAccess[vh.VehKey] == false) then NewTable(newData, vh) end
                end
                Camera()
                SendReactMessage('setOpen', { setVeh = newData, setName = extra.jobName .. ' Garage', inGarage = inGarage, Price = 0,
                    allVehicleCount = #GetAllVehicleModels(), ownedVehicleCount = #newData, ownedVehicleCountUniq = #newData })
                SetNuiFocus(true, true)
            end, "Gang", extra.jobName, extra.vehType)
        end)
    end
end

-- Turns a raw owned_vehicles row (gang / org fleet) into what the Unique expects.
function PrepareRow(vh)
    local props = type(vh.vehicle) == 'string' and json.decode(vh.vehicle) or vh.vehicle or {}
    vh.vehicle = props
    vh.stored  = ToStoredNum(vh.stored)
    vh.engine  = tonumber(vh.engine) or 1000
    vh.fuel    = tonumber(vh.fuel) or 100
    vh.body    = tonumber(vh.body) or 1000
    local disp = GetDisplayNameFromVehicleModel(props.model or 0)
    local label = GetLabelText(disp)
    if label == 'NULL' or label == '' then label = disp end
    vh.VehKey   = string.gsub(disp, "%s+", ""):lower()
    vh.VehModel = ('%s - %s'):format(label, vh.plate)
    vh.VehText  = label
    vh.image    = Customize.VehicleImageUrl:format(disp:lower())
    vh.image2   = vh.image
    vh.state    = (vh.stored == 1) and 1 or 0
    vh.metaData = { fuel = vh.fuel, engine = vh.engine, body = vh.body }
    return vh
end

function NewTable(newData, vh)
    table.insert(newData, vh)
    if vh.stored == 1 then
        inGarage = inGarage + 1
    end
end

function Camera()
    local cam = CreateCameraWithParams('DEFAULT_SCRIPTED_CAMERA', LastCamera.location.posX, LastCamera.location.posY, LastCamera.location.posZ, LastCamera.location.rotX, LastCamera.location.rotY, LastCamera.location.rotZ, LastCamera.location.fov, false, 2)
    SetCamActive(cam, true)
    RenderScriptCams(true, true, 2000, true, false, false)
    SetFocusPosAndVel(LastCamera.location.posX, LastCamera.location.posY, LastCamera.location.posZ, 0.0, 0.0, 0.0)
end

function SendReactMessage(action, data) SendNUIMessage({ action = action, data = data }) end

function GetPlate(vehicle)
    if vehicle == 0 then return end
    return Trim(GetVehicleNumberPlateText(vehicle))
end

function Trim(value)
	if not value then return nil end
    return (string.gsub(value, '^%s*(.-)%s*$', '%1'))
end

local ownCarBlips = {}

function AttachOwnCarBlip(vehicle)
    if not vehicle or vehicle == 0 then return end
    if ownCarBlips[vehicle] and DoesBlipExist(ownCarBlips[vehicle]) then return end

    local blip = AddBlipForEntity(vehicle)
    SetBlipSprite(blip, 225)
    SetBlipColour(blip, 3)
    SetBlipScale(blip, 0.7)
    SetBlipCategory(blip, 7)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString("Mashine Man")
    EndTextCommandSetBlipName(blip)

    ownCarBlips[vehicle] = blip
end

function RemoveOwnCarBlip(vehicle)
    local blip = ownCarBlips[vehicle]
    if blip and DoesBlipExist(blip) then
        RemoveBlip(blip)
    end
    ownCarBlips[vehicle] = nil
end

function HZDeleteVehicle(vehicle)
	TriggerServerEvent("CarLock:ToggleKey", false, GetPlate(vehicle))
    RemoveOwnCarBlip(vehicle)
    SetEntityAsMissionEntity(vehicle, true, true)
    DeleteVehicle(vehicle)
end

function HZSpawnVehicle(model, cb, coords, isnetworked, teleportInto)
    local ped = PlayerPedId()
    model = type(model) == 'string' and GetHashKey(model) or model
    -- FIX: this used to `return` here with zero feedback whenever the model
    -- wasn't a valid/streamed vehicle model, so the SPAWN button looked like
    -- it did nothing (menu stayed open, no vehicle, no error). Now it
    -- notifies the player and logs the exact model hash to console.
    if not model or not IsModelInCdimage(model) or not IsModelAVehicle(model) then
        SafeNotify('~r~In Mashin Dar Bazi Mojood Nist! (Model: ' .. tostring(model) .. ')')
        print('^1[Unique_Garage] HZSpawnVehicle: model ' .. tostring(model) .. ' is not a valid/streamed vehicle model.^0')
        return
    end
    if coords then
        coords = type(coords) == 'table' and vec3(coords.x, coords.y, coords.z) or coords
    else
        coords = GetEntityCoords(ped)
    end
    isnetworked = isnetworked or true
    ELoadModel(model)
    local veh = CreateVehicle(model, coords.x, coords.y, coords.z, coords.w, isnetworked, false)
    local netid = NetworkGetNetworkIdFromEntity(veh)
    SetVehicleHasBeenOwnedByPlayer(veh, true)
    SetNetworkIdCanMigrate(netid, true)
    SetVehicleNeedsToBeHotwired(veh, false)
    SetVehRadioStation(veh, 'OFF')
    SetVehicleFuelLevel(veh, 100.0)
    SetModelAsNoLongerNeeded(model)

    if teleportInto then TaskWarpPedIntoVehicle(PlayerPedId(), veh, -1)  end
    if cb then cb(veh) end
end

function ELoadModel(model)
    if HasModelLoaded(model) then return end
	RequestModel(model)
	while not HasModelLoaded(model) do
		Wait(0)
	end
end

function GetClosestVehicle()
    local vehicles = GetGamePool('CVehicle')
    local closestDistance = -1
    local closestVehicle = -1
    for i = 1, #vehicles, 1 do
        local vehicleCoords = GetEntityCoords(vehicles[i])
        local distance = #(vehicleCoords - GetEntityCoords(PlayerPedId()))

        if closestDistance == -1 or closestDistance > distance then
            closestVehicle = vehicles[i]
            closestDistance = distance
        end
    end
    return closestVehicle, closestDistance
end

function ShowHelpNotification(text)
    BeginTextCommandDisplayHelp("STRING")
    AddTextComponentSubstringPlayerName(text)
    EndTextCommandDisplayHelp(0, false, false, -1)
end

function Draw3DText(x, y, z, text)
    local onScreen, _x, _y = World3dToScreen2d(x, y, z)
    if onScreen then
        SetTextScale(0.35, 0.35)
        SetTextFont(4)
        SetTextProportional(1)
        SetTextColour(255, 255, 255, 215)
        SetTextDropShadow(0, 0, 0, 55)
        SetTextEdge(0, 0, 0, 150)
        SetTextDropShadow()
        SetTextOutline()
        SetTextEntry("STRING")
        SetTextCentre(1)
        AddTextComponentString(text)
        DrawText(_x, _y)
    end
end
