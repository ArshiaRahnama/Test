-- request control of dog --
function REQUEST_CONTROL()
    if not DoesEntityExist(dog_ent) then 
        return false 
    end

    while not NetworkHasControlOfEntity(dog_ent) do
        NetworkRequestControlOfEntity(dog_ent)
        Wait(0)
    end
    
    local netId = NetworkGetNetworkIdFromEntity(dog_ent)
    if not NetworkDoesEntityExistWithNetworkId(netId) then
        return false
    end

    while not NetworkHasControlOfNetworkId(netId) do
        NetworkRequestControlOfNetworkId(netId)
        Wait(0)
    end

    return true
end

-- disable controls --
function DisableControls()
    DisableControlAction(0, 30, true) -- disable left/right
    DisableControlAction(0, 31, true) -- disable forward/back
    DisableControlAction(0, 36, true) -- INPUT_DUCK
    DisableControlAction(0, 21, true) -- disable sprint

    DisableControlAction(0, 24, true) -- Attack
    DisableControlAction(0, 257, true) -- Attack 2
    DisableControlAction(0, 25, true) -- Aim
    DisableControlAction(0, 263, true) -- Melee Attack 1

    DisableControlAction(0, 45, true) -- Reload
    DisableControlAction(0, 22, true) -- Jump
    DisableControlAction(0, 44, true) -- Cover
    DisableControlAction(0, 37, true) -- Select Weapon
    DisableControlAction(0, 23, true) -- Also 'enter'?

    DisableControlAction(0, 288, true) -- Disable phone
    DisableControlAction(0, 289, true) -- Inventory
    DisableControlAction(0, 170, true) -- Animations
    DisableControlAction(0, 167, true) -- Job

    DisableControlAction(0, 26, true) -- Disable looking behind
    DisableControlAction(0, 73, true) -- Disable clearing animation
    DisableControlAction(2, 199, true) -- Disable pause screen

    DisableControlAction(0, 59, true) -- Disable steering in vehicle
    DisableControlAction(0, 71, true) -- Disable driving forward in vehicle
    DisableControlAction(0, 72, true) -- Disable reversing in vehicle

    DisableControlAction(0, 264, true) -- Disable melee
    DisableControlAction(0, 257, true) -- Disable melee
    DisableControlAction(0, 140, true) -- Disable melee
    DisableControlAction(0, 141, true) -- Disable melee
    DisableControlAction(0, 142, true) -- Disable melee
    DisableControlAction(0, 143, true) -- Disable melee
    DisableControlAction(0, 75, true)  -- Disable exit vehicle
    DisableControlAction(27, 75, true) -- Disable exit vehicle
end

function RotationToDirection(rotation)
	local adjustedRotation = 
	{ 
		x = (math.pi / 180) * rotation.x, 
		y = (math.pi / 180) * rotation.y, 
		z = (math.pi / 180) * rotation.z 
	}
	local direction = 
	{
		x = -math.sin(adjustedRotation.z) * math.abs(math.cos(adjustedRotation.x)), 
		y = math.cos(adjustedRotation.z) * math.abs(math.cos(adjustedRotation.x)), 
		z = math.sin(adjustedRotation.x)
	}
	return direction
end

function RayCastGamePlayCamera(distance)
	local cameraRotation = GetGameplayCamRot()
	local cameraCoord = GetGameplayCamCoord()
	local direction = RotationToDirection(cameraRotation)
	local destination = 
	{ 
		x = cameraCoord.x + direction.x * distance, 
		y = cameraCoord.y + direction.y * distance, 
		z = cameraCoord.z + direction.z * distance 
	}
	local a, b, c, d, e = GetShapeTestResult(StartShapeTestRay(cameraCoord.x, cameraCoord.y, cameraCoord.z, destination.x, destination.y, destination.z, -1, -1, 1))
	return b, c, e
end

function loadPtfxAsset(dict)
    RequestNamedPtfxAsset(dict) 
    while not HasNamedPtfxAssetLoaded(dict) do 
        Wait(50) 
    end 
end

local DEG2RAD = math.pi / 180.0
local RAD2DEG = 180.0 / math.pi
function SetEntityHeadingLookAt(ped, target) 
    local pos = GetEntityCoords(ped)
    local targetPos = GetEntityCoords(target)
    local dir = targetPos - pos
    local yaw = math.atan2(-dir.x, dir.y)
    SetEntityHeading(ped, yaw * RAD2DEG)
end

function GetHeadDirection(ped)
    local yaw = GetEntityHeading(ped) * DEG2RAD
    local y = math.cos(yaw)
    local x = -math.sin(yaw)
    return vector2(x, y)
end

function ShowHelpNotification(text)
    SetTextComponentFormat("STRING")
    AddTextComponentString(text)
    DisplayHelpTextFromStringLabel(0, 0, 1, 50)
end

function ShowNotification(msg)
	SetNotificationTextEntry('STRING')
	AddTextComponentString(msg)
	DrawNotification(0, 1)
end

function loadModel(model)
    if type(model) == 'number' then model = model else model = GetHashKey(model) end
    RequestModel(model)
    while not HasModelLoaded(model) do Wait(0) end
end

function LoadAnimDict(dict) RequestAnimDict(dict) while not HasAnimDictLoaded(dict) do Wait(0) end end

function PlayAnimation(ped, dict, anim, flags, wait)
    CreateThread(function()
        LoadAnimDict(dict)
        TaskPlayAnim(ped, dict, anim, 8.0, -8.0, -1, flags, 0.0, 0, 0, 0)
        if wait then Wait(wait) ClearPedTasks(ped) end
    end)
end

-- Gets Players
function GetPlayers()
    local players = {}
    for i = 0, 256 do
        if NetworkIsPlayerActive(i) then
            table.insert(players, i)
        end
    end
    return players
end

-- Gets Player ID
function GetPlayerId(target_ped)
    local players = GetPlayers()
    for a = 1, #players do
        local ped = GetPlayerPed(players[a])
        local server_id = GetPlayerServerId(players[a])
        if target_ped == ped then
            return server_id
        end
    end
    return 0
end

function GetServerId() 
    return GetPlayerServerId(NetworkGetPlayerIndexFromPed(cache.ped)) 
end

-- compass --
function Compass(heading)
    heading = heading % 360.0
    if (heading >= 0.0 and heading < 22.5) or heading >= 337.5 then
        return "NORTH"
    elseif heading >= 22.5 and heading < 67.5 then
        return "NORTH EAST"
    elseif heading >= 67.5 and heading < 112.5 then
        return "EAST"
    elseif heading >= 112.5 and heading < 157.5 then
        return "SOUTH EAST"
    elseif heading >= 157.5 and heading < 202.5 then
        return "SOUTH"
    elseif heading >= 202.5 and heading < 247.5 then
        return "SOUTH WEST"
    elseif heading >= 247.5 and heading < 292.5 then
        return "WEST"
    elseif heading >= 292.5 and heading < 337.5 then
        return "NORTH WEST"
    end
end

-- get vehicle --
function GetVehicleAheadOfPlayer()
    local ped = PlayerPedId()
    local coordFrom = GetEntityCoords(ped, true)
    local coordTo = GetOffsetFromEntityInWorldCoords(ped, 0.0, 10.0, 0.0)
    
	local offset = 0
	local rayHandle
	local vehicle

	for i = 0, 100 do
		rayHandle = CastRayPointToPoint(coordFrom.x, coordFrom.y, coordFrom.z, coordTo.x, coordTo.y, coordTo.z + offset, 10, ped, 0)	
		a, b, c, d, vehicle = GetRaycastResult(rayHandle)
		offset = offset - 1
		if vehicle ~= 0 then break end
	end
	
	local distance = #(coordFrom - GetEntityCoords(vehicle))
	if distance > 30 then vehicle = nil end
    if DoesEntityExist(vehicle) then NetworkRequestControlOfEntity(vehicle) end
    return vehicle ~= nil and vehicle or 0
end

-- Get Closest Veh Door
function GetClosestVehicleDoor(veh)
    local pcoords = GetEntityCoords(PlayerPedId())
    local closestDist = -1
    local door, bone, seat, seatpos = false, nil, nil, nil

    local pos = {
        -- index is door number
        [1] = GetWorldPositionOfEntityBone(veh, GetEntityBoneIndexByName(veh, "door_dside_r")),
        [2] = GetWorldPositionOfEntityBone(veh, GetEntityBoneIndexByName(veh, "door_pside_f")),
        [3] = GetWorldPositionOfEntityBone(veh, GetEntityBoneIndexByName(veh, "door_pside_r"))
    }

    for k, v in pairs(pos) do
        local dist = #(pcoords - v)
        if closestDist == -1 or closestDist > dist then
            closestDist = dist

            if k == 1 then -- behind driver
                if IsVehicleSeatFree(veh, 1) then
                    door, bone, seat, seatpos = 2, "seat_dside_r", 1, v
                end
            elseif k == 2 then -- passenger
                if IsVehicleSeatFree(veh, 0) then
                    door, bone, seat, seatpos = 1, "seat_pside_f", 0, v
                end
            elseif k == 3 then -- behind passenger
                if IsVehicleSeatFree(veh, 2) then
                    door, bone, seat, seatpos = 3, "seat_pside_r", 2, v
                end
            end
        end
    end

    return door, bone, seat, seatpos
end

-- get closest player --
function GetClosestPlayer(coords)
    local ped = PlayerPedId()
    if coords then
        coords = type(coords) == 'table' and vec3(coords.x, coords.y, coords.z) or coords
    else
        coords = GetEntityCoords(ped)
    end

    local closestPlayers = GetPlayersFromCoords(coords)
    local closestDistance = -1
    local closestPlayer = -1
    for i = 1, #closestPlayers, 1 do
        if closestPlayers[i] ~= PlayerId() and closestPlayers[i] ~= -1 then
            local pos = GetEntityCoords(GetPlayerPed(closestPlayers[i]))
            local distance = #(pos - coords)

            if closestDistance == -1 or closestDistance > distance then
                closestPlayer = closestPlayers[i]
                closestDistance = distance
            end
        end
    end

    return closestPlayer, closestDistance
end

function GetPlayersFromCoords(coords, distance)
    local players = GetActivePlayers()
    local ped = PlayerPedId()
    if coords then
        coords = type(coords) == 'table' and vec3(coords.x, coords.y, coords.z) or coords
    else
        coords = GetEntityCoords(ped)
    end
    distance = distance or 5

    local closePlayers = {}
    for _, player in pairs(players) do
        local target = GetPlayerPed(player)
        local targetCoords = GetEntityCoords(target)
        local targetdistance = #(targetCoords - coords)
        if targetdistance <= distance then
            closePlayers[#closePlayers + 1] = player
        end
    end

    return closePlayers
end

-- rounding --
function round(number, decimals)
    local power = 10^decimals
    return math.floor(number * power) / power
end