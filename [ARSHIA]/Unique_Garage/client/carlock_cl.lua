
local DisableOnKey = false
local hotwireActive = {}
local showHotwireText = false
local canHotwireVehicle = false
local hotwireText = "~r~[H] ~w~Baraye Pich Goshti Kardan"

local restrictedPrefixes = {

    ["CID"] = true,
    ["CIA"] = true,
    ["MS"]  = true,
    ["FBI"] = true,
    ["JD"]  = true,
    ["DOA"] = true,

    ["PD"] = true,
    ["SH"] = true,
    ["MT"] = true,

    ["TX"] = true,
    ["MC"] = true,
    ["MD"] = true,
    ["WZ"] = true,
}

local function matchesRestrictedPrefix(plate)
    for prefix in pairs(restrictedPrefixes) do
        if string.upper(string.sub(plate, 1, #prefix)) == prefix then
            return true
        end
    end
    return false
end

local function flashOutline(vehicle)
    SetEntityDrawOutline(vehicle, true)
    SetTimeout(1000, function()
        if DoesEntityExist(vehicle) then
            SetEntityDrawOutline(vehicle, false)
        end
    end)
end

CreateThread(function()
    while ESX == nil do Citizen.Wait(100) end
    while true do
        local ped = PlayerPedId()
        local vehicle = GetVehiclePedIsIn(ped, false)
        local plate = vehicle ~= 0 and GetVehicleNumberPlateText(vehicle) or nil

        if vehicle ~= 0 then
            if GetPedInVehicleSeat(vehicle, -1) == ped then
                ESX.TriggerServerCallback('CarLock:haskey', function(haskey)
                    if not haskey and not (plate and hotwireActive[plate]) then
                        SetVehicleLights(vehicle, false)
                        BringVehicleToHalt(vehicle, 0, 1000, false)
                        DisableOnKey = true
                        showHotwireText = true
                        canHotwireVehicle = true
                    else
                        DisableOnKey = false
                        StopBringVehicleToHalt(vehicle)
                        showHotwireText = false
                        canHotwireVehicle = false
                    end
                end, plate)
            else
                Wait(2000)
                showHotwireText = false
                canHotwireVehicle = false
            end
        else
            Wait(2000)
            showHotwireText = false
            canHotwireVehicle = false
        end
        Wait(3000)
    end
end)

CreateThread(function()
    while true do
        if showHotwireText then
            SetTextFont(4)
            SetTextScale(0.7, 0.7)
            SetTextColour(255, 255, 255, 255)
            SetTextOutline()
            SetTextCentre(true)
            BeginTextCommandDisplayText("STRING")
            AddTextComponentSubstringPlayerName(hotwireText)
            EndTextCommandDisplayText(0.5, 0.9)
        end
        Wait(0)
    end
end)

function UseHotwireKit()
    if not canHotwireVehicle then
        return
    end

    local ped = PlayerPedId()
    local vehicle = GetVehiclePedIsIn(ped, false)

    if vehicle == 0 then
        SafeNotify("~r~Shoma Savar Mashin nistid")
        return
    end

    local plate = GetVehicleNumberPlateText(vehicle)
    local globalplate = string.gsub(plate, "%s+", "")

    if matchesRestrictedPrefix(globalplate) then
        SafeNotify("~r~In yek vasile edari ast, nemitanid hotwire konid!")
        return
    end

    ESX.TriggerServerCallback('CarLock:hasHotwireItem', function(hasItem)
        if not hasItem then
            SafeNotify("~r~Shoma Pich Goshti Nadarid!")
            return
        end

        local success = lib.skillCheck(
            {'easy', 'easy', {areaSize = 60, speedMultiplier = 2}, 'hard'},
            {'w', 'a', 's', 'd'}
        )

        if success then



            TriggerServerEvent('CarLock:useHotwireKit', globalplate)
            SafeNotify("~g~Mashin ba movafaghiat roshan shod!")
        else
            SafeNotify("~r~Pich Goshti Shekast!")
        end
    end)
end

RegisterNetEvent('CarLock:enableVehicleTemporarily')
AddEventHandler('CarLock:enableVehicleTemporarily', function()
    local ped = PlayerPedId()
    local vehicle = GetVehiclePedIsIn(ped, false)
    local plate = vehicle ~= 0 and GetVehicleNumberPlateText(vehicle) or nil

    if not plate then return end

    hotwireActive[plate] = true
    showHotwireText = false

    DisableOnKey = false
    StopBringVehicleToHalt(vehicle)
    SetVehicleEngineOn(vehicle, true, false, false)
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        local ped = PlayerPedId()
        local vehicle = GetVehiclePedIsIn(ped, false)

        if vehicle ~= 0 and GetPedInVehicleSeat(vehicle, -1) == ped then
            if IsControlJustReleased(0, 74) and showHotwireText then
                UseHotwireKit()
            end
        else
            Citizen.Wait(1000)
        end
    end
end)

local function GetOrgLabel(plate)
    local orgNames = {

        CID = "CID", CIA = "CIA", MS = "Marshal", FBI = "FBI", JD = "Judge", DOA = "DOA",

        PD = "Police", SH = "Sheriff", MT = "MT",

        TX = "Taxi", MC = "Mechanic", MD = "Ambulance", WZ = "Weazel",
    }
    local p3 = string.upper(string.sub(plate, 1, 3))
    local p2 = string.upper(string.sub(plate, 1, 2))
    return orgNames[p3] or orgNames[p2]
end

function unlockVehicle(vehicle)
    local ply = PlayerPedId()
    local vehicleModel = GetEntityModel(vehicle)
    local vehicleName = GetDisplayNameFromVehicleModel(vehicleModel)
    local vehicleLabel = GetLabelText(vehicleName)
    local plate = GetVehicleNumberPlateText(vehicle)
    local orgLabel = GetOrgLabel(plate)
    local tag = orgLabel and (" ~b~[" .. orgLabel .. "]~w~") or ""

    SetVehicleDoorsLocked(vehicle, 1)
    SetVehicleAlarm(vehicle, 0)
    flashOutline(vehicle)
    SafeNotify("~w~Shoma Dar ~b~" .. vehicleLabel .. tag .. " ~w~(" .. plate .. ") ~w~Ra ~g~Baz ~w~Kardid!")
    lockStatus = 1

    if IsPedInAnyVehicle(ply, true) then
        TriggerEvent('InteractSound_CL:PlayOnOne', 'unlock', 1.0)
    else
        playAnimation(false)
    end
end

function lockVehicle(vehicle)
    local ply = PlayerPedId()
    local vehicleModel = GetEntityModel(vehicle)
    local vehicleName = GetDisplayNameFromVehicleModel(vehicleModel)
    local vehicleLabel = GetLabelText(vehicleName)
    local plate = GetVehicleNumberPlateText(vehicle)
    local orgLabel = GetOrgLabel(plate)
    local tag = orgLabel and (" ~b~[" .. orgLabel .. "]~w~") or ""



    SetVehicleDoorShut(vehicle, 0, false)
    SetVehicleDoorShut(vehicle, 1, false)
    SetVehicleDoorShut(vehicle, 2, false)
    SetVehicleDoorShut(vehicle, 3, false)
    SetVehicleDoorsLocked(vehicle, 2)
    flashOutline(vehicle)
    SafeNotify("~w~Shoma Dar ~b~" .. vehicleLabel .. tag .. " ~w~(" .. plate .. ") ~w~Ra ~r~Gofl ~w~Kardid!")
    lockStatus = 2

    if IsPedInAnyVehicle(ply, true) then
        TriggerEvent('InteractSound_CL:PlayOnOne', 'lock', 1.0)
    else
        playAnimation(true)
    end
end

function getVehicleNetId(vehID)
	return NetToVeh(NetworkGetNetworkIdFromEntity(vehID))
end

function getVehicleInDirection(coordFrom, coordTo)
	local rayHandle = CastRayPointToPoint(coordFrom.x, coordFrom.y, coordFrom.z, coordTo.x, coordTo.y, coordTo.z, 10, PlayerPedId(), 0)
	local a, b, c, d, vehicle = GetRaycastResult(rayHandle)
	return vehicle
end

function playAnimation(lock)
	local ply = PlayerPedId()
	local lib = "anim@mp_player_intmenu@key_fob@"
	local anim = "fob_click"

	ESX.Streaming.RequestAnimDict(lib, function()
		if lock then
			TriggerEvent('InteractSound_CL:PlayOnOne' , 'lock', 1.0)
		else
			TriggerEvent('InteractSound_CL:PlayOnOne' , 'unlock', 1.0)
		end
		TaskPlayAnim(ply, lib, anim, 8.0, -8.0, -1, 0, 0, false, false, false)
	end)
end

RegisterCommand("uniquegarage_carlock_toggle", function()
	local ply = PlayerPedId()
	if (IsPedInAnyVehicle(ply, true)) and GetPedInVehicleSeat(GetVehiclePedIsIn(ply, false), -1) == ply then
		local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
		local plate = GetVehicleNumberPlateText(vehicle)
		ESX.TriggerServerCallback('CarLock:haskey', function(result)
			if result then
				lockStatus     = GetVehicleDoorLockStatus(vehicle)
				if lockStatus == 2 then
					unlockVehicle(vehicle)
				else
					lockVehicle(vehicle)
				end
			else
				SafeNotify("~r~Shoma kilid in mashin ra nadarid")
			end
		end, plate)
	else
		local coordA = GetEntityCoords(ply, 1)
		local coordB = GetOffsetFromEntityInWorldCoords(ply, 0.0, 8.0, 0.0)

		local vehicle = ESX.Game.GetClosestVehicle(coordA)
		local vehicleDistance = vehicle and vehicle ~= 0 and #(GetEntityCoords(ply) - GetEntityCoords(vehicle)) or nil
		if vehicle and vehicle ~= 0 and vehicleDistance and vehicleDistance <= 10.0 then
			local plate = GetVehicleNumberPlateText(vehicle)
			ESX.TriggerServerCallback('CarLock:haskey', function(result)
				if result then
					lockStatus     = GetVehicleDoorLockStatus(vehicle)
					if lockStatus == 2 then
						unlockVehicle(vehicle)
					else
						lockVehicle(vehicle)
					end
				else
					SafeNotify("~r~Shoma kilid in mashin ra nadarid")
				end
			end, plate)
		else
			SafeNotify("Mashin Nazdik Shoma Nist")
		end
	end
end)

RegisterKeyMapping("uniquegarage_carlock_toggle", "Lock/Unlock nearby vehicle", "keyboard", Customize.Hotkey or "U")

RegisterCommand("keys", function()
	TriggerEvent("CarLock:RefreshKeys")
end)

RegisterNetEvent("CarLock:RefreshKeys")
AddEventHandler("CarLock:RefreshKeys", function()
	local KYES = {}
    for vehicle in CarLock_EnumerateVehicles() do
        Plate = GetVehicleNumberPlateText(vehicle)
		if DoesEntityExist(vehicle) then
			table.insert(KYES,("CarKey|"..ESX.Math.Trim(Plate)))
		end
    end
	TriggerServerEvent("CarLock:CheckKeys", KYES)
end)

local carLockEntityEnumerator = {
    __gc = function(enum)
    if enum.destructor and enum.handle then
      enum.destructor(enum.handle)
    end
    enum.destructor = nil
    enum.handle = nil
  end
}

local function CarLock_EnumerateEntities(initFunc, moveFunc, disposeFunc)
	return coroutine.wrap(function()
		local iter, id = initFunc()
		if not id or id == 0 then
		  disposeFunc(iter)
		  return
		end

		local enum = {handle = iter, destructor = disposeFunc}
		setmetatable(enum, carLockEntityEnumerator)

		local next = true
		repeat
		  coroutine.yield(id)
		  next, id = moveFunc(iter)
		until not next

		enum.destructor, enum.handle = nil, nil
		disposeFunc(iter)
	end)
end

function CarLock_EnumerateVehicles()
	return CarLock_EnumerateEntities(FindFirstVehicle, FindNextVehicle, EndFindVehicle)
end

RegisterNetEvent('givekey_Cl')
AddEventHandler('givekey_Cl',function(target)
	GiveCarkey(target)
end)

function GiveCarkey(target)
	local ped = PlayerPedId()
	local vehicle = GetVehiclePedIsIn(ped, true)
	if not IsPedInAnyVehicle(ped) then return SafeNotify('~r~ Zamani Ke Savar Mashin Hastid mitvanid Give Key Konid') end
	if not vehicle or vehicle == 0 then return SafeNotify('~r~ Mashin Peyda Nashod') end
	if #(GetEntityCoords(vehicle)  - GetEntityCoords(ped)    ) > 15.0 then return SafeNotify('~r~ Fasle Shoma Ba Akharin Mashin Ke Savar Shodid Besyar Zeyad Ast') end
	local plate = GetVehicleNumberPlateText(vehicle)



	TriggerServerEvent('CarLock:ToggleKey2', true, plate, target)
end
