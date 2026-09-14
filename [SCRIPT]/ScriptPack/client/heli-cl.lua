

local ESX = nil
local PlayerData = {}

Citizen.CreateThread(function()
    while ESX == nil do
        TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
        Citizen.Wait(10)
    end

    while ESX.GetPlayerData().job == nil do
		Citizen.Wait(10)
	end

	PlayerData = ESX.GetPlayerData()
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
	PlayerData.job = job
end)

local fov_max = 80.0
local fov_min = 5.0
local zoomspeed = 3.0
local speed_lr = 4.0
local speed_ud = 4.0
local toggle_helicam = 51
local toggle_vision = 25
local toggle_rappel = 154
local toggle_spotlight = 183
local toggle_lock_on = 22
local toggle_display = 44
local lightup_key = 246
local lightdown_key = 173
local radiusup_key = 137
local radiusdown_key = 21
local maxtargetdistance = 700
local brightness = 1.0
local spotradius = 4.0
local speed_measure = "Km/h"

local target_vehicle = nil
local manual_spotlight = false
local tracking spotlight = false
local vehicle_display = 1
local helicam = false
local polmav_hash = GetHashKey("polmav")
local fov = (fov_max+fov_min)*0.5
local vision_state = 0

Citizen.CreateThread(function()
	while true do
	Citizen.Wait(1)
		if NetworkIsSessionStarted() then
			DecorRegister("SpotvectorX", 3)
			DecorRegister("SpotvectorY", 3)
			DecorRegister("SpotvectorZ", 3)
			DecorRegister("Target", 3)
			return
		end
	end
end)

Citizen.CreateThread(function()
	while true do
        Citizen.Wait(1)
		if IsPlayerInPolmav() then
			local lPed = PlayerPedId()
			local heli = GetVehiclePedIsIn(lPed)

			if IsHeliHighEnough(heli) then
				if IsControlJustPressed(0, toggle_helicam) then
					PlaySoundFrontend(-1, "SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET", false)
					helicam = true
					TriggerEvent('status:modifyShowStatus', false)
					TriggerEvent('streetlabel:modifyHide', true)
					TriggerEvent('esx_voice:changeHideStatus', true)
				end

				if IsControlJustPressed(0, toggle_rappel) then
					if GetPedInVehicleSeat(heli, 1) == lPed or GetPedInVehicleSeat(heli, 2) == lPed then
						PlaySoundFrontend(-1, "SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET", false)
						SetPedCanRagdoll(PlayerPedId(), false)
						TaskRappelFromHeli(PlayerPedId(), 1)
						Citizen.CreateThread(function()
							Wait(15000)
							SetPedCanRagdoll(PlayerPedId(), true)
						end)
					else
						SetNotificationTextEntry( "STRING" )
						AddTextComponentString("~r~Can't rappel from this seat")
						DrawNotification(false, false )
						PlaySoundFrontend(-1, "5_Second_Timer", "DLC_HEISTS_GENERAL_FRONTEND_SOUNDS", false)
					end
				end
			end

			if IsControlJustPressed(0, toggle_spotlight) and GetPedInVehicleSeat(heli, -1) == lPed and not helicam then
				if target_vehicle then
					if tracking_spotlight then
						if not pause_Tspotlight then
							pause_Tspotlight = true
							TriggerServerEvent("heli:pause.tracking.spotlight", pause_Tspotlight)
						else
							pause_Tspotlight = false
							TriggerServerEvent("heli:pause.tracking.spotlight", pause_Tspotlight)
						end
						PlaySoundFrontend(-1, "SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET", false)
					else
						if Fspotlight_state then
							Fspotlight_state = false
							TriggerServerEvent("heli:forward.spotlight", Fspotlight_state)
						end
						local target_netID = VehToNet(target_vehicle)
						local target_plate = GetVehicleNumberPlateText(target_vehicle)
						local targetposx, targetposy, targetposz = table.unpack(GetEntityCoords(target_vehicle))
						pause_Tspotlight = false
						tracking_spotlight = true
						TriggerServerEvent("heli:tracking.spotlight", target_netID, target_plate, targetposx, targetposy, targetposz)
						PlaySoundFrontend(-1, "SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET", false)
					end
				else
					if tracking_spotlight then
						pause_Tspotlight = false
						tracking_spotlight = false
						TriggerServerEvent("heli:tracking.spotlight.toggle")
					end
					Fspotlight_state = not Fspotlight_state
					TriggerServerEvent("heli:forward.spotlight", Fspotlight_state)
					PlaySoundFrontend(-1, "SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET", false)
				end
			end

			if IsControlJustPressed(0, toggle_display) and GetPedInVehicleSeat(heli, -1) == lPed then
				ChangeDisplay()
			end

			if target_vehicle and GetPedInVehicleSeat(heli, -1) == lPed then
				local coords1 = GetEntityCoords(heli)
				local coords2 = GetEntityCoords(target_vehicle)
				local target_distance = #(coords1.xy - coords2.xy)
				if IsControlJustPressed(0, toggle_lock_on) or target_distance > maxtargetdistance then

					DecorRemove(target_vehicle, "Target")
					if tracking_spotlight then
						TriggerServerEvent("heli:tracking.spotlight.toggle")
					end
					tracking_spotlight = false
					pause_Tspotlight = false
					target_vehicle = nil
					PlaySoundFrontend(-1, "SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET", false)
				end
			end

		end

		if helicam then
			SetTimecycleModifier("heliGunCam")
			SetTimecycleModifierStrength(0.3)
			local scaleform = RequestScaleformMovie("HELI_CAM")
			while not HasScaleformMovieLoaded(scaleform) do
				Citizen.Wait(1)
			end
			local lPed = PlayerPedId()
			local heli = GetVehiclePedIsIn(lPed)
			local cam = CreateCam("DEFAULT_SCRIPTED_FLY_CAMERA", true)
			AttachCamToEntity(cam, heli, 0.0,0.0,-1.5, true)
			SetCamRot(cam, 0.0,0.0,GetEntityHeading(heli))
			SetCamFov(cam, fov)
			RenderScriptCams(true, false, 0, 1, 0)
			PushScaleformMovieFunction(scaleform, "SET_CAM_LOGO")
			PushScaleformMovieFunctionParameterInt(0)
			PopScaleformMovieFunctionVoid()
			local locked_on_vehicle = nil
			while helicam and not IsEntityDead(lPed) and (GetVehiclePedIsIn(lPed) == heli) and IsHeliHighEnough(heli) do
				if IsControlJustPressed(0, toggle_helicam) then
					PlaySoundFrontend(-1, "SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET", false)
					if manual_spotlight and target_vehicle then
						TriggerServerEvent("heli:manual.spotlight.toggle")
						local target_netID = VehToNet(target_vehicle)
						local target_plate = GetVehicleNumberPlateText(target_vehicle)
						local targetposx, targetposy, targetposz = table.unpack(GetEntityCoords(target_vehicle))
						pause_Tspotlight = false
						tracking_spotlight = true
						TriggerServerEvent("heli:tracking.spotlight", target_netID, target_plate, targetposx, targetposy, targetposz)
						PlaySoundFrontend(-1, "SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET", false)
					end
					manual_spotlight = false
					helicam = false
					TriggerEvent('status:modifyShowStatus', true)
					TriggerEvent('streetlabel:modifyHide', false)
					TriggerEvent('esx_voice:changeHideStatus', false)
				end

				if IsControlJustPressed(0, toggle_vision) then
					if PlayerData.job.name == "police" or PlayerData.job.name == "sheriff" or PlayerData.job.name == "mt" or PlayerData.job.name == "fbi" then
						PlaySoundFrontend(-1, "SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET", false)
						ChangeVision()
					end
				end

				if IsControlJustPressed(0, toggle_spotlight) then
					if tracking_spotlight then
						pause_Tspotlight = true
						TriggerServerEvent("heli:pause.tracking.spotlight", pause_Tspotlight)
						manual_spotlight = not manual_spotlight
						if manual_spotlight then
							local rotation = GetCamRot(cam, 2)
							local forward_vector = RotAnglesToVec(rotation)
							local SpotvectorX, SpotvectorY, SpotvectorZ = table.unpack(forward_vector)
							DecorSetInt(lPed, "SpotvectorX", SpotvectorX)
							DecorSetInt(lPed, "SpotvectorY", SpotvectorY)
							DecorSetInt(lPed, "SpotvectorZ", SpotvectorZ)
							PlaySoundFrontend(-1, "SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET", false)
							TriggerServerEvent("heli:manual.spotlight")
						else
							TriggerServerEvent("heli:manual.spotlight.toggle")
						end
					elseif Fspotlight_state then
						Fspotlight_state = false
						TriggerServerEvent("heli:forward.spotlight", Fspotlight_state)
						manual_spotlight = not manual_spotlight
						if manual_spotlight then
							PlaySoundFrontend(-1, "SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET", false)
							TriggerServerEvent("heli:manual.spotlight")
						else
							TriggerServerEvent("heli:manual.spotlight.toggle")
						end
					else
						manual_spotlight = not manual_spotlight
						if manual_spotlight then
							PlaySoundFrontend(-1, "SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET", false)
							TriggerServerEvent("heli:manual.spotlight")
						else
							TriggerServerEvent("heli:manual.spotlight.toggle")
						end
					end
				end

				if IsControlJustPressed(0, lightup_key) then
					TriggerServerEvent("heli:light.up")
				end

				if IsControlJustPressed(0, lightdown_key) then
					TriggerServerEvent("heli:light.down")
				end

				if IsControlJustPressed(0, radiusup_key) then
					TriggerServerEvent("heli:radius.up")
				end

				if IsControlJustPressed(0, radiusdown_key) then
					TriggerServerEvent("heli:radius.down")
				end

				if IsControlJustPressed(0, toggle_display) then
					ChangeDisplay()
				end

				if locked_on_vehicle then
					if DoesEntityExist(locked_on_vehicle) then

						PointCamAtEntity(cam, locked_on_vehicle, 0.0, 0.0, 0.0, true)
						RenderVehicleInfo(locked_on_vehicle)
						local coords1 = GetEntityCoords(heli)
						local coords2 = GetEntityCoords(locked_on_vehicle)
						local target_distance = #(coords1.xy - coords2.xy)
						if IsControlJustPressed(0, toggle_lock_on) or target_distance > maxtargetdistance then

							PlaySoundFrontend(-1, "SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET", false)
							DecorRemove(target_vehicle, "Target")
							if tracking_spotlight then
								TriggerServerEvent("heli:tracking.spotlight.toggle")
								tracking_spotlight = false
							end
							target_vehicle = nil
							locked_on_vehicle = nil
							local rot = GetCamRot(cam, 2)
							local fov = GetCamFov(cam)
							local old cam = cam
							DestroyCam(old_cam, false)
							cam = CreateCam("DEFAULT_SCRIPTED_FLY_CAMERA", true)
							AttachCamToEntity(cam, heli, 0.0,0.0,-1.5, true)
							SetCamRot(cam, rot, 2)
							SetCamFov(cam, fov)
							RenderScriptCams(true, false, 0, 1, 0)
						end
					else
						locked_on_vehicle = nil
						target_vehicle = nil
					end

				else
					local zoomvalue = (1.0/(fov_max-fov_min))*(fov-fov_min)
					CheckInputRotation(cam, zoomvalue)
					local vehicle_detected = GetVehicleInView(cam)
					if DoesEntityExist(vehicle_detected) then
						RenderVehicleInfo(vehicle_detected)
						if IsControlJustPressed(0, toggle_lock_on) then
							PlaySoundFrontend(-1, "SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET", false)
							locked_on_vehicle = vehicle_detected

							if target_vehicle then
								DecorRemove(target_vehicle, "Target")
							end

							target_vehicle = vehicle_detected
							NetworkRequestControlOfEntity(target_vehicle)
							local target_netID = VehToNet(target_vehicle)
							SetNetworkIdCanMigrate(target_netID, true)
							NetworkRegisterEntityAsNetworked(VehToNet(target_vehicle))
							SetNetworkIdExistsOnAllMachines(target_vehicle, true)
							SetEntityAsMissionEntity(target_vehicle, true, true)
							target_plate = GetVehicleNumberPlateText(target_vehicle)
							DecorSetInt(locked_on_vehicle, "Target", 2)

							if tracking_spotlight then
								TriggerServerEvent("heli:tracking.spotlight.toggle")
								target_vehicle = locked_on_vehicle

								if not pause_Tspotlight then
									local target_netID = VehToNet(target_vehicle)
									local target_plate = GetVehicleNumberPlateText(target_vehicle)
									local targetposx, targetposy, targetposz = table.unpack(GetEntityCoords(target_vehicle))
									pause_Tspotlight = false
									tracking_spotlight = true
									TriggerServerEvent("heli:tracking.spotlight", target_netID, target_plate, targetposx, targetposy, targetposz)
									PlaySoundFrontend(-1, "SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET", false)
								else
									tracking_spotlight = false
									pause_Tspotlight = false
								end
							end
						end
					end
				end

				HandleZoom(cam)
				HideHUDThisFrame()
				PushScaleformMovieFunction(scaleform, "SET_ALT_FOV_HEADING")
				PushScaleformMovieFunctionParameterFloat(GetEntityCoords(heli).z)
				PushScaleformMovieFunctionParameterFloat(zoomvalue)
				PushScaleformMovieFunctionParameterFloat(GetCamRot(cam, 2).z)
				PopScaleformMovieFunctionVoid()
				DrawScaleformMovieFullscreen(scaleform, 255, 255, 255, 255)
				Citizen.Wait(1)

				if manual_spotlight then
					local rotation = GetCamRot(cam, 2)
					local forward_vector = RotAnglesToVec(rotation)
					local SpotvectorX, SpotvectorY, SpotvectorZ = table.unpack(forward_vector)
					local camcoords = GetCamCoord(cam)

					DecorSetInt(lPed, "SpotvectorX", SpotvectorX)
					DecorSetInt(lPed, "SpotvectorY", SpotvectorY)
					DecorSetInt(lPed, "SpotvectorZ", SpotvectorZ)
					DrawSpotLight(camcoords, forward_vector, 255, 255, 255, 800.0, 10.0, brightness, spotradius, 1.0, 1.0)
				else
					TriggerServerEvent("heli:manual.spotlight.toggle")
				end

			end
			if manual_spotlight then
				manual_spotlight = false
				TriggerServerEvent("heli:manual.spotlight.toggle")
			end
			helicam = false
			ClearTimecycleModifier()
			fov = (fov_max+fov_min)*0.5
			RenderScriptCams(false, false, 0, 1, 0)
			SetScaleformMovieAsNoLongerNeeded(scaleform)
			DestroyCam(cam, false)
			SetNightvision(false)
			SetSeethrough(false)
		end

		if IsPlayerInPolmav() and target_vehicle and not helicam and vehicle_display ~=2 then
			RenderVehicleInfo(target_vehicle)
		end
	end
end)

RegisterNetEvent('heli:forward.spotlight')
AddEventHandler('heli:forward.spotlight', function(serverID, state)
	local heli = GetVehiclePedIsIn(GetPlayerPed(GetPlayerFromServerId(serverID)), false)
	SetVehicleSearchlight(heli, state, false)
end)

RegisterNetEvent('heli:Tspotlight')
AddEventHandler('heli:Tspotlight', function(serverID, target_netID, target_plate, targetposx, targetposy, targetposz)


	if GetVehicleNumberPlateText(NetToVeh(target_netID)) == target_plate then
		Tspotlight_target = NetToVeh(target_netID)
	elseif GetVehicleNumberPlateText(DoesVehicleExistWithDecorator("Target")) == target_plate then
		Tspotlight_target = DoesVehicleExistWithDecorator("Target")

	elseif GetVehicleNumberPlateText(GetClosestVehicle(targetposx, targetposy, targetposz, 25.0, 0, 70)) == target_plate then
		Tspotlight_target = GetClosestVehicle(targetposx, targetposy, targetposz, 25.0, 0, 70)

	else
		vehicle_match = FindVehicleByPlate(target_plate)
		if vehicle_match then
			Tspotlight_target = vehicle_match

		else
			Tspotlight_target = nil

		end
	end

	local heli = GetVehiclePedIsIn(GetPlayerPed(GetPlayerFromServerId(serverID)), false)
	local heliPed = GetPlayerPed(GetPlayerFromServerId(serverID))
	Tspotlight_toggle = true
	Tspotlight_pause = false
	tracking_spotlight = true
	while not IsEntityDead(heliPed) and (GetVehiclePedIsIn(heliPed) == heli) and Tspotlight_target and Tspotlight_toggle do
		Citizen.Wait(1)
		local helicoords = GetEntityCoords(heli)
		local targetcoords = GetEntityCoords(Tspotlight_target)
		local spotVector = targetcoords - helicoords
		local target_distance = Vdist(targetcoords, helicoords)
		if Tspotlight_target and Tspotlight_toggle and not Tspotlight_pause then
			DrawSpotLight(helicoords['x'], helicoords['y'], helicoords['z'], spotVector['x'], spotVector['y'], spotVector['z'], 255, 255, 255, (target_distance+20), 10.0, brightness, 4.0, 1.0, 0.0)
		end
		if Tspotlight_target and Tspotlight_toggle and target_distance > maxtargetdistance then

			DecorRemove(Tspotlight_target, "Target")
			target_vehicle = nil
			tracking_spotlight = false
			TriggerServerEvent("heli:tracking.spotlight.toggle")
			Tspotlight_target = nil
			break
		end

	end
	Tspotlight_toggle = false
	Tspotlight_pause = false
	Tspotlight_target = nil
	tracking_spotlight = false
end)

RegisterNetEvent('heli:Tspotlight.toggle')
AddEventHandler('heli:Tspotlight.toggle', function(serverID)
	Tspotlight_toggle = false
	tracking_spotlight = false
end)

RegisterNetEvent('heli:pause.Tspotlight')
AddEventHandler('heli:pause.Tspotlight', function(serverID, pause_Tspotlight)
	if pause_Tspotlight then
		Tspotlight_pause = true
	else
		Tspotlight_pause = false
	end
end)

RegisterNetEvent('heli:Mspotlight')
AddEventHandler('heli:Mspotlight', function(serverID)
	if GetPlayerServerId(PlayerId()) ~= serverID then
		local heli = GetVehiclePedIsIn(GetPlayerPed(GetPlayerFromServerId(serverID)), false)
		local heliPed = GetPlayerPed(GetPlayerFromServerId(serverID))
		Mspotlight_toggle = true
		while not IsEntityDead(heliPed) and (GetVehiclePedIsIn(heliPed) == heli) and Mspotlight_toggle do
			Citizen.Wait(1)
			local helicoords = GetEntityCoords(heli)
			spotoffset = helicoords + vector3(0.0, 0.0, -1.5)
			SpotvectorX = DecorGetInt(heliPed, "SpotvectorX")
			SpotvectorY = DecorGetInt(heliPed, "SpotvectorY")
			SpotvectorZ = DecorGetInt(heliPed, "SpotvectorZ")
			if SpotvectorX then
				DrawSpotLight(spotoffset['x'], spotoffset['y'], spotoffset['z'], SpotvectorX, SpotvectorY, SpotvectorZ, 255, 255, 255, 800.0, 10.0, brightness, spotradius, 1.0, 1.0)
			end
		end
		Mspotlight_toggle = false
		DecorSetInt(heliPed, "SpotvectorX", nil)
		DecorSetInt(heliPed, "SpotvectorY", nil)
		DecorSetInt(heliPed, "SpotvectorZ", nil)
	end
end)

RegisterNetEvent('heli:Mspotlight.toggle')
AddEventHandler('heli:Mspotlight.toggle', function(serverID)
	Mspotlight_toggle = false
end)

RegisterNetEvent('heli:light.up')
AddEventHandler('heli:light.up', function(serverID)
	if brightness < 10 then
		brightness = brightness + 1.0
		PlaySoundFrontend(-1, "SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET", false)
	end
end)

RegisterNetEvent('heli:light.down')
AddEventHandler('heli:light.down', function(serverID)
	if brightness > 1.0 then
		brightness = brightness - 1.0
		PlaySoundFrontend(-1, "SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET", false)
	end
end)

RegisterNetEvent('heli:radius.up')
AddEventHandler('heli:radius.up', function(serverID)
	if spotradius < 10.0 then
		spotradius = spotradius + 1.0
		PlaySoundFrontend(-1, "SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET", false)
	end
end)

RegisterNetEvent('heli:radius.down')
AddEventHandler('heli:radius.down', function(serverID)
	if spotradius > 4.0 then
		spotradius = spotradius - 1.0
		PlaySoundFrontend(-1, "SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET", false)
	end
end)

function IsPlayerInPolmav()
	local lPed = PlayerPedId()
	local vehicle = GetVehiclePedIsIn(lPed)
	return IsVehicleModel(vehicle, polmav_hash)
end

function IsHeliHighEnough(heli)
	return GetEntityHeightAboveGround(heli) > 1.5
end

function ChangeVision()
	if vision_state == 0 then
		SetNightvision(true)
		vision_state = 1
	elseif vision_state == 1 then
		SetNightvision(false)
		SetSeethrough(true)
		vision_state = 2
	else
		SetSeethrough(false)
		vision_state = 0
	end
end

function ChangeDisplay()
	if vehicle_display == 0 then
		vehicle_display = 1
	elseif vehicle_display == 1 then
		vehicle_display = 2
	else
		vehicle_display = 0
	end
end

function HideHUDThisFrame()
	HideHelpTextThisFrame()
	HideHudAndRadarThisFrame()
	HideHudComponentThisFrame(19)
	HideHudComponentThisFrame(1)
	HideHudComponentThisFrame(2)
	HideHudComponentThisFrame(3)
	HideHudComponentThisFrame(4)
	HideHudComponentThisFrame(13)
	HideHudComponentThisFrame(11)
	HideHudComponentThisFrame(12)
	HideHudComponentThisFrame(15)
	HideHudComponentThisFrame(18)
end

function CheckInputRotation(cam, zoomvalue)
	local rightAxisX = GetDisabledControlNormal(0, 220)
	local rightAxisY = GetDisabledControlNormal(0, 221)
	local rotation = GetCamRot(cam, 2)
	if rightAxisX ~= 0.0 or rightAxisY ~= 0.0 then
		new_z = rotation.z + rightAxisX*-1.0*(speed_ud)*(zoomvalue+0.1)
		new_x = math.max(math.min(20.0, rotation.x + rightAxisY*-1.0*(speed_lr)*(zoomvalue+0.1)), -89.5)
		SetCamRot(cam, new_x, 0.0, new_z, 2)
	end
end

function HandleZoom(cam)
	if IsControlJustPressed(0,241) then
		fov = math.max(fov - zoomspeed, fov_min)
	end
	if IsControlJustPressed(0,242) then
		fov = math.min(fov + zoomspeed, fov_max)
	end
	local current_fov = GetCamFov(cam)
	if math.abs(fov-current_fov) < 0.1 then
		fov = current_fov
	end
	SetCamFov(cam, current_fov + (fov - current_fov)*0.05)
end

function GetVehicleInView(cam)
	local coords = GetCamCoord(cam)
	local forward_vector = RotAnglesToVec(GetCamRot(cam, 2))

	local rayhandle = CastRayPointToPoint(coords, coords+(forward_vector*200.0), 10, GetVehiclePedIsIn(PlayerPedId()), 0)
	local _, _, _, _, entityHit = GetRaycastResult(rayhandle)
	if entityHit>0 and IsEntityAVehicle(entityHit) then
		return entityHit
	else
		return nil
	end
end

function RenderVehicleInfo(vehicle)
	if DoesEntityExist(vehicle) then
		local model = GetEntityModel(vehicle)
		local vehname = GetLabelText(GetDisplayNameFromVehicleModel(model))
		local licenseplate = GetVehicleNumberPlateText(vehicle)

		 local x,y,z = table.unpack(GetEntityCoords(vehicle, false))
		 local streetName, crossing = GetStreetNameAtCoord(x, y, z)
		 streetName = GetStreetNameFromHashKey(streetName)
		 local location = ""
			   if crossing ~= 0 then
				   crossing = GetStreetNameFromHashKey(crossing)
				   location = streetName .. ", " .. crossing
			   else
		   location = streetName
	   end


		   local directions = { [0] = 'North', [45] = 'North-West', [90] = 'West', [135] = 'South-West', [180] = 'South', [225] = 'South-East', [270] = 'East', [315] = 'North-East', [360] = 'North', }
	   for k,v in pairs(directions)do
		   direction = GetEntityHeading(vehicle, false)
		   if(math.abs(direction - k) < 22.5)then
			   direction = v
			   break;
		   end
	   end

	   if speed_measure == "MPH" then
		   vehspeed = GetEntitySpeed(vehicle)*2.236936
	   else
		   vehspeed = GetEntitySpeed(vehicle)*3.6
	   end
	   SetTextFont(0)
	   SetTextProportional(1)
	   if vehicle_display == 0 then
		   SetTextScale(0.0, 0.40)
	   elseif vehicle_display == 1 then
		   SetTextScale(0.0, 0.40)
	   end
	   SetTextColour(255, 255, 255, 255)
	   SetTextDropshadow(0, 0, 0, 0, 255)
	   SetTextEdge(1, 0, 0, 0, 255)
	   SetTextDropShadow()
	   SetTextEntry("STRING")
	   if vehicle_display == 0 then
		   AddTextComponentString("Speed: " .. math.ceil(vehspeed) .. " " .. speed_measure .. "\nModel: " .. vehname .. "\nPlate: " .. licenseplate)
	   elseif vehicle_display == 1 then
		   AddTextComponentString("Heading: " .. direction .. "\nLocation: " .. location .. "\nSpeed: " .. math.ceil(vehspeed) .. "\nModel: " .. vehname .. "\nPlate: " .. string.gsub(licenseplate, "^%s*(.-)%s*$", "%1"))
	   end
	   DrawText(0.83, 0.83)
	end
end

function RotAnglesToVec(rot)
	local z = math.rad(rot.z)
	local x = math.rad(rot.x)
	local num = math.abs(math.cos(x))
	return vector3(-math.sin(z)*num, math.cos(z)*num, math.sin(x))
end

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

function EnumerateVehicles()
  return EnumerateEntities(FindFirstVehicle, FindNextVehicle, EndFindVehicle)
end

function FindVehicleByPlate(plate)
	for vehicle in EnumerateVehicles() do
		if GetVehicleNumberPlateText(vehicle) == plate then
			return vehicle
		end
	end
end