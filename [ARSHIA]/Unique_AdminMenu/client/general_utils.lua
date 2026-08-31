function drawNotification(string)
  SetNotificationTextEntry("STRING")
  AddTextComponentString(string)
  DrawNotification(true, false)
end

function LoadAnimDict( dict )
    while ( not HasAnimDictLoaded( dict ) ) do
        RequestAnimDict( dict )
        Citizen.Wait( 5 )
    end
end

function getEntity(player)
	local result, entity = GetEntityPlayerIsFreeAimingAt(player)
	return entity
end

function bulletCoords()
  local result, coord = GetPedLastWeaponImpactCoord(PlayerPedId())
  return coord
end

function getGroundZ(x, y, z)
		local result, groundZ = GetGroundZFor_3dCoord(x + 0.0, y + 0.0, z + 0.0, Citizen.ReturnResultAnyway())
		return groundZ
end

function GetUserInput(windowTitle, defaultText, maxLength)
    defaultText = defaultText or ""
    maxLength = maxLength or 40
    DisplayOnscreenKeyboard(1, "FMMC_MPM_NA", "", defaultText, "", "", "", maxLength)
    while true do
        Citizen.Wait(0)
        local status = UpdateOnscreenKeyboard()
        if status == 1 then
            return GetOnscreenKeyboardResult()
        elseif status == 2 or status == 3 then
            return nil
        end
    end
end

local function EnumerateNearbyVehicles()
    return coroutine.wrap(function()
        local handle, vehicle = FindFirstVehicle()
        local finished = false
        repeat
            coroutine.yield(vehicle)
            finished, vehicle = FindNextVehicle(handle)
        until finished
        EndFindVehicle(handle)
    end)
end

-- Ported from esx_aduty's dvrange: deletes every vehicle within `range`
-- meters of the ADMIN (not a target), so it works even on empty/unowned
-- vehicles with no driver.
function DeleteVehiclesInRange(range)
    local playerCoords = GetEntityCoords(PlayerPedId())
    local deleted = 0

    for vehicle in EnumerateNearbyVehicles() do
        if DoesEntityExist(vehicle) then
            local vehicleCoords = GetEntityCoords(vehicle)
            if #(playerCoords - vehicleCoords) <= range then
                NetworkRequestControlOfEntity(vehicle)
                Citizen.Wait(0)
                ESX.Game.DeleteVehicle(vehicle)
                deleted = deleted + 1
            end
        end
    end

    if deleted > 0 then
        drawNotification(("~g~Deleted %s vehicle(s) within %sm"):format(deleted, range))
    else
        drawNotification("~y~No vehicles found in that range")
    end
    TriggerServerEvent('Unique_AdminMenu:LogClientAction', "dvrange", ("range: %s | deleted: %s"):format(range, deleted))
end