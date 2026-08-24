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