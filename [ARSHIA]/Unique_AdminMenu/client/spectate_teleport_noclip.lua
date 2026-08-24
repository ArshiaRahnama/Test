ESX = nil

Citizen.CreateThread(function()
	while ESX == nil do
    TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
    Wait(0)
  end
end)
function DoesPlayerExistInArea(source)
  local Players = GetActivePlayers()
  for k,v in pairs(Players) do
    if GetPlayerServerId(v) == source then
      return true
    end
  end
  return false
end
InSpectatorMode	= false
TargetSpectate	= nil
spec = {}
local LastPosition		= nil
local polarAngleDeg		= 0;
local azimuthAngleDeg	= 90;
local radius			    = -3.5;
local cam 				    = nil
local ShowInfos			  = false

function polar3DToWorld3D(entityPosition, radius, polarAngleDeg, azimuthAngleDeg)
	local polarAngleRad   = polarAngleDeg   * math.pi / 180.0
	local azimuthAngleRad = azimuthAngleDeg * math.pi / 180.0

	local pos = {
		x = entityPosition.x + radius * (math.sin(azimuthAngleRad) * math.cos(polarAngleRad)),
		y = entityPosition.y - radius * (math.sin(azimuthAngleRad) * math.sin(polarAngleRad)),
		z = entityPosition.z - radius * math.cos(azimuthAngleRad)
	}

	return pos
end

function spectate(serverid)
	if GetPlayerServerId(PlayerId()) == serverid then
	  return
	end

  if not InSpectatorMode then
    LastPosition = GetEntityCoords(PlayerPedId())
    TriggerServerEvent('Admin_Menu:SpectStatus', true)
    Wait(250)
	else
    NetworkSetInSpectatorMode(false, 0)
    TargetSpectate = nil
	  local playerPed = PlayerPedId()
    DetachEntity(playerPed, true, true)
	  SetEntityCompletelyDisableCollision(playerPed, true, true)
  end

  ESX.TriggerServerCallback('Admin_Menu:GetTargetPosition', function(coords)
    SetEntityVisible(PlayerPedId(), false)
	  SetEntityCoords(PlayerPedId(), coords.x, coords.y, coords.z-50.0)
    local Timer = GetGameTimer()
	  while not ESX.Game.DoesPlayerExistInArea(serverid) or (GetGameTimer() - Timer > 10000)  do
		  Wait(1)
    end
    if not ESX.Game.DoesPlayerExistInArea(serverid) then return end
    local pl  = GetPlayerFromServerId(serverid)
    local pl2 = GetPlayerPed(pl)

    local Timer = GetGameTimer()
    while not DoesEntityExist(pl2) or (GetGameTimer() - Timer > 5000) do
      Wait(0)
      pl2 = GetPlayerPed(pl)
    end

    if DoesEntityExist(pl2) then
      NetworkSetInSpectatorMode(true, pl2)
      InSpectatorMode = true
      TargetSpectate = serverid
      DoSpecThread()
    else
      resetNormalCamera()
    end
	end, serverid)
end

function resetNormalCamera()
	local playerPed = PlayerPedId()
	InSpectatorMode = false
  spec[lastspec] = false
	TargetSpectate  = nil
  lastspec = 0
  sp = 0

	NetworkSetInSpectatorMode(false, 0)
  DetachEntity(playerPed, true, true)
  TriggerServerEvent('Unique_AdminMenu:AntiCheatExempt', 5000, { teleport = true, speed = true, invisibility = true })
  SetEntityCoords(playerPed, LastPosition)

	if not invisibility or not invisibility2 then
    SetEntityVisible(playerPed, true)
  end
  SetEntityCompletelyDisableCollision(playerPed, true, true)

  SetTimeout(500, function()
    TriggerServerEvent('Admin_Menu:SpectStatus', nil)
  end)
end

RegisterNetEvent('Admin_Menu:PlayerVehicleList')
AddEventHandler('Admin_Menu:PlayerVehicleList', function(ownedCars)
  GetVehicles(ownedCars, 10)
end)

RegisterNetEvent('es_admin:teleportUser')
AddEventHandler('es_admin:teleportUser', function(x, y, z)
  if InSpectatorMode then
	  InSpectatorMode = false
	  NetworkSetInSpectatorMode(false, 0)
	  spec[lastspec] = false
	  lastspec = 0
	  TargetSpectate  = nil
	  local playerPed = PlayerPedId()
	  DetachEntity(playerPed, true, true)
	  SetEntityCompletelyDisableCollision(playerPed, true, true)
	  if not invisibility or not invisibility2 then
      SetEntityVisible(playerPed, true)
    end
    TriggerServerEvent('Admin_Menu:SpectStatus', nil)
  end
end)

function DoSpecThread()
  if InSpectatorMode and TargetSpectate then
    local targetPlayerId = GetPlayerFromServerId(TargetSpectate)

    local targetPed	= GetPlayerPed(targetPlayerId)
    if ESX.Game.DoesPlayerExistInArea(TargetSpectate) then
      SetEntityVisible(PlayerPedId(), false)
      AttachEntityToEntity(PlayerPedId(), targetPed, headBone, 0, 0, -3.0, 0, 0, 0, true, true, false, true, 0, false)
      SetEntityCompletelyDisableCollision(PlayerPedId(), false, true)
    else
      resetNormalCamera()
    end
































    local text = {}











    if TargetSpectate then
      table.insert(text,"ID: "..TargetSpectate)
      table.insert(text,"Steam Name: "..GetPlayerName(targetPlayerId))
      table.insert(text,"Health: ".. (GetEntityHealth(targetPed) - 100).."/".. (GetEntityMaxHealth(targetPed) - 100))
      table.insert(text,"Armor: "..GetPedArmour(targetPed))
      if IsPedInAnyVehicle(targetPed, false) then
        table.insert(text,"Vehicle Speed: "..math.floor(GetEntitySpeed(GetVehiclePedIsIn(targetPed, false))*3.6))
        table.insert(text,"Vehicle Health: "..GetEntityHealth(GetVehiclePedIsIn(targetPed)))
        table.insert(text,"Vehicle Engine Health: "..GetVehicleEngineHealth(GetVehiclePedIsIn(targetPed)))
      end
      if NetworkIsPlayerTalking(targetPlayerId) then
        table.insert(text,"Talking: ~g~True")
      else
        table.insert(text,"Talking: ~r~False")
      end

      for i, theText in pairs(text) do
        SetTextFont(0)
        SetTextProportional(1)
        SetTextScale(0.0, 0.30)
        SetTextDropshadow(0, 0, 0, 0, 255)
        SetTextEdge(1, 0, 0, 0, 255)
        SetTextDropShadow()
        SetTextOutline()
        SetTextEntry("STRING")
        AddTextComponentString(theText)
        EndTextCommandDisplayText(0.03, 0.4+(i/30))
      end
      if not NetworkIsPlayerActive(targetPlayerId) then
        spec[TargetSpectate] = false
        InSpectatorMode = false
        lastspec = 0
        TargetSpectate = nil
      end

      if IsControlPressed(0, 47) then

      elseif IsControlJustReleased(2, 73) then
        ESX.TriggerServerCallback('esx_aduty:checkAduty', function(isAduty)
          if isAduty then
            resetNormalCamera()
          else
            ESX.ShowNotification("Abuse Mikoni? bara manager befrestam? boro tobe kon!")
          end
        end)
      end
    end
    SetTimeout(0, DoSpecThread)
  end
end

function teleportToPlayer(serverId)
  local targetId = GetPlayerFromServerId(serverId)
  local playerPed = PlayerPedId()
  local targetPed = GetPlayerPed(targetId)

  TriggerServerEvent('Unique_AdminMenu:AntiCheatExempt', 5000, { teleport = true, speed = true })
  NetworkSetInSpectatorMode(false, playerPed)
  TriggerServerEvent('Admin_Menu:SpectStatus', nil)
  DetachEntity(playerPed, true, true)
  SetEntityCompletelyDisableCollision(playerPed, true, true)
  if not invisibility or not invisibility2 then
    SetEntityVisible(playerPed, true)
  end
  if PlayerId() == targetId then
    drawNotification("~r~This player is you!")
  elseif not NetworkIsPlayerActive(targetId) then
    drawNotification("~r~This player is not in game.")
  else
    local targetCoords = GetEntityCoords(targetPed)
    local targetVeh = GetVehiclePedIsIn(targetPed, False)
    local seat = -1

    drawNotification("~g~Teleporting to " .. GetPlayerName(targetId) .. " (Player " .. serverId .. ").")

    if targetVeh then
      local numSeats = GetVehicleModelNumberOfSeats(GetEntityModel(targetVeh))
      if numSeats > 1 then
        for i=0, numSeats do
          if seat == -1 and IsVehicleSeatFree(targetveh, i) then seat = 1 end
        end
      end
    end
    if seat == -1 then
      SetEntityCoords(playerPed, targetCoords, 1, 0, 0, 1)
    else
      SetPedIntoVehicle(playerPed, targetVeh, seat)
    end
  end
end

IsNoclipActive = false;
local MovingSpeed = 0;
local Scale = -1;
local FollowCamMode = false;
local speeds = {
    [0] = "Very Slow",
    [1] = "Slow",
    [2] = "Normal",
    [3] = "Fast",
    [4] = "Very Fast",
    [5] = "Extremely Fast",
    [6] = "Extremely Fast v2.0",
    [7] = "Max Speed"
}

function NoClipThread()
	local function NoClipFunc()
		if (IsNoclipActive) then
			Scale = RequestScaleformMovie("INSTRUCTIONAL_BUTTONS");
			while (not HasScaleformMovieLoaded(Scale)) do
				Wait(0)
			end
		end

		while IsNoclipActive do
			local playerPed = PlayerPedId()






			noclipExemptRefresh = (noclipExemptRefresh or 0)
			if GetGameTimer() - noclipExemptRefresh > 3000 then
				TriggerServerEvent('Unique_AdminMenu:AntiCheatExempt', 4000,
					{ noclip = true, teleport = true, speed = true, superjump = true })
				noclipExemptRefresh = GetGameTimer()
			end

        	if (not IsHudHidden()) then
                BeginScaleformMovieMethod(Scale, "CLEAR_ALL")
                EndScaleformMovieMethod()

                BeginScaleformMovieMethod(Scale, "SET_DATA_SLOT")
                ScaleformMovieMethodAddParamInt(0)
                PushScaleformMovieMethodParameterString("~INPUT_SPRINT~")
                PushScaleformMovieMethodParameterString("Change Speed ("..speeds[MovingSpeed]..")")
                EndScaleformMovieMethod()

                BeginScaleformMovieMethod(Scale, "SET_DATA_SLOT")
                ScaleformMovieMethodAddParamInt(1)
                PushScaleformMovieMethodParameterString("~INPUT_MOVE_LR~")
                PushScaleformMovieMethodParameterString("Turn Left/Right")
                EndScaleformMovieMethod()

                BeginScaleformMovieMethod(Scale, "SET_DATA_SLOT")
                ScaleformMovieMethodAddParamInt(2)
                PushScaleformMovieMethodParameterString("~INPUT_MOVE_UD~")
                PushScaleformMovieMethodParameterString("Move")
                EndScaleformMovieMethod()

                BeginScaleformMovieMethod(Scale, "SET_DATA_SLOT")
                ScaleformMovieMethodAddParamInt(3)
                PushScaleformMovieMethodParameterString("~INPUT_MULTIPLAYER_INFO~")
                PushScaleformMovieMethodParameterString("Down")
                EndScaleformMovieMethod();

                BeginScaleformMovieMethod(Scale, "SET_DATA_SLOT")
                ScaleformMovieMethodAddParamInt(4)
                PushScaleformMovieMethodParameterString("~INPUT_COVER~")
                PushScaleformMovieMethodParameterString("Up")
                EndScaleformMovieMethod()

                BeginScaleformMovieMethod(Scale, "SET_DATA_SLOT")
                ScaleformMovieMethodAddParamInt(5)
                PushScaleformMovieMethodParameterString("~INPUT_VEH_HEADLIGHT~")
				local CamModeText
				if FollowCamMode then
					CamModeText = 'Active'
				else
					CamModeText = 'Deactive'
				end
                PushScaleformMovieMethodParameterString("Cam Mode: "..CamModeText)
                EndScaleformMovieMethod()

                BeginScaleformMovieMethod(Scale, "DRAW_INSTRUCTIONAL_BUTTONS")
                ScaleformMovieMethodAddParamInt(0)
                EndScaleformMovieMethod()

                DrawScaleformMovieFullscreen(Scale, 255, 255, 255, 255, 0)
            end

			local noclipEntity
			if IsPedInAnyVehicle(playerPed, true) then
				noclipEntity = GetVehiclePedIsIn(playerPed, false)
			else
				noclipEntity = playerPed
			end

            FreezeEntityPosition(noclipEntity, true);
            SetEntityInvincible(noclipEntity, true);

            DisableControlAction(0, 32)
            DisableControlAction(0, 268)
            DisableControlAction(0, 31)
            DisableControlAction(0, 269)
            DisableControlAction(0, 33)
            DisableControlAction(0, 266)
            DisableControlAction(0, 34)
            DisableControlAction(0, 30)
            DisableControlAction(0, 267)
            DisableControlAction(0, 35)
            DisableControlAction(0, 44)
            DisableControlAction(0, 20)
            DisableControlAction(0, 74)
            if (IsPedInAnyVehicle(playerPed, true)) then
                DisableControlAction(0, 85)
			end

            local yoff = 0.0;
            local zoff = 0.0;

            if (UpdateOnscreenKeyboard() ~= 0 and not IsPauseMenuActive()) then
                if (IsControlJustPressed(0, 21)) then
                    MovingSpeed = MovingSpeed+1
                    if (MovingSpeed > #speeds) then
                        MovingSpeed = 0;
                    end
                end

                if (IsDisabledControlPressed(0, 32)) then
                    yoff = 0.5
                end
                if (IsDisabledControlPressed(0, 33)) then
                    yoff = -0.5
                end
                if (IsDisabledControlPressed(0, 34)) then
                    SetEntityHeading(playerPed, GetEntityHeading(playerPed)+3)
                end
                if (IsDisabledControlPressed(0, 35)) then
                    SetEntityHeading(playerPed, GetEntityHeading(playerPed)-3)
            	end
                if (IsDisabledControlPressed(0, 44)) then
                    zoff = 0.21
                end
                if (IsDisabledControlPressed(0, 20)) then
                    zoff = -0.21
                end
				if (IsDisabledControlJustPressed(0, 74)) then
					FollowCamMode = not FollowCamMode
				end
                moveSpeed = MovingSpeed
                if (MovingSpeed > #speeds/2) then
                    moveSpeed = moveSpeed*1.8;
                end

                newPos = GetOffsetFromEntityInWorldCoords(noclipEntity, 0, yoff*(moveSpeed + 0.3), zoff*(moveSpeed + 0.3))

                local heading = GetEntityHeading(noclipEntity)
                SetEntityVelocity(noclipEntity, 0, 0, 0)
                SetEntityRotation(noclipEntity, 0, 0, 0, 0, false)
				if FollowCamMode then
					SetEntityHeading(noclipEntity, GetGameplayCamRelativeHeading())
				else
					SetEntityHeading(noclipEntity, heading)
				end

                SetEntityCollision(noclipEntity, false, false)
                SetEntityCoordsNoOffset(noclipEntity, newPos.x, newPos.y, newPos.z, true, true, true)

                SetLocalPlayerVisibleLocally(true)
                SetEntityAlpha(noclipEntity, 255*0.2, 0)

                SetEveryoneIgnorePlayer(PlayerId(), true)
                SetPoliceIgnorePlayer(PlayerId(), true)

                FreezeEntityPosition(noclipEntity, false)
                SetEntityInvincible(noclipEntity, false)
                SetEntityCollision(noclipEntity, true, true)

                SetLocalPlayerVisibleLocally(true)
                ResetEntityAlpha(noclipEntity)

                SetEveryoneIgnorePlayer(PlayerId(), false)
                SetPoliceIgnorePlayer(PlayerId(), false)
            end
            Wait(0)
		end
	end
	CreateThread(NoClipFunc)
end

RegisterNetEvent("Admin_Menu:ToggleNoclip")
AddEventHandler("Admin_Menu:ToggleNoclip", function()
	IsNoclipActive = not IsNoclipActive
	if IsNoclipActive then
		NoClipThread()
	end
end)

