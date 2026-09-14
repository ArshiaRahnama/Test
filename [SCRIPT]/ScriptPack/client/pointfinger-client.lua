local mp_pointing = false
local keyPressed = false

local function startPointing()
	local ped = PlayerPedId()

	RequestAnimDict("anim@mp_point")
	while not HasAnimDictLoaded("anim@mp_point") do
		Citizen.Wait(1)
	end

	SetPedCurrentWeaponVisible(ped, 0, 1, 1, 1)
	SetPedConfigFlag(ped, 36, 1)
	TaskMoveNetwork(ped, "task_mp_pointing", 0.5, 0, "anim@mp_point", 24)
	RemoveAnimDict("anim@mp_point")
end

local function stopPointing()
	local ped = PlayerPedId()
	Citizen.InvokeNative(0xD01015C7316AE176, ped, "Stop")

	if not IsPedInjured(ped) then
		ClearPedSecondaryTask(ped)
	end

	if not IsPedInAnyVehicle(ped, 1) then
		SetPedCurrentWeaponVisible(ped, 1, 1, 1, 1)
	end

	SetPedConfigFlag(ped, 36, 0)
	ClearPedSecondaryTask(PlayerPedId())
	mp_pointing = false
end

local once = true

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(10)
		local ped = PlayerPedId()

		if once then
			once = false
		end

		if IsPedArmed(PlayerPedId(), 7) and mp_pointing then
			stopPointing()
		end




		if Citizen.InvokeNative(0x921CE12C489C4C41, ped) and not mp_pointing then
			stopPointing()
		end
		if Citizen.InvokeNative(0x921CE12C489C4C41, ped) then
			if not IsPedOnFoot(ped) then
				stopPointing()
			else
				local ped = ped
				local camPitch = GetGameplayCamRelativePitch()
				if camPitch < -70.0 then
					camPitch = -70.0
				elseif camPitch > 42.0 then
					camPitch = 42.0
				end
				camPitch = (camPitch + 70.0) / 112.0

				local camHeading = GetGameplayCamRelativeHeading()
				local cosCamHeading = Cos(camHeading)
				local sinCamHeading = Sin(camHeading)
				if camHeading < -180.0 then
					camHeading = -180.0
				elseif camHeading > 180.0 then
					camHeading = 180.0
				end
				camHeading = (camHeading + 180.0) / 360.0

				local blocked = 0
				local nn = 0

				local coords = GetOffsetFromEntityInWorldCoords(ped, (cosCamHeading * -0.2) - (sinCamHeading * (0.4 * camHeading + 0.3)), (sinCamHeading * -0.2) + (cosCamHeading * (0.4 * camHeading + 0.3)), 0.6)
				local ray = Cast_3dRayPointToPoint(coords.x, coords.y, coords.z - 0.2, coords.x, coords.y, coords.z + 0.2, 0.4, 95, ped, 7);
				nn,blocked,coords,coords = GetRaycastResult(ray)

				Citizen.InvokeNative(0xD5BB4025AE449A4E, ped, "Pitch", camPitch)
				Citizen.InvokeNative(0xD5BB4025AE449A4E, ped, "Heading", camHeading * -1.0 + 1.0)
				Citizen.InvokeNative(0xB0A6CFD2C69C1088, ped, "isBlocked", blocked)
				Citizen.InvokeNative(0xB0A6CFD2C69C1088, ped, "isFirstPerson", Citizen.InvokeNative(0xEE778F8C7E1142E2, Citizen.InvokeNative(0x19CAFA3C87F7C2FF)) == 4)

			end
		end
	end
end)

function notification(msg)
	SetNotificationTextEntry('STRING')
	AddTextComponentSubstringWebsite(msg)
	DrawNotification(false, true)
end

Boro_Bala = function()
	if not IsPedArmed(ped, 7) then
		startPointing()
		mp_pointing = true
	else
		notification("~h~Dast shoma por ast nemitavanid point konid!")
	end
end

AddEventHandler('onKeyDown', function(key)
	local ped = PlayerPedId()
	if key == 'b' and not mp_pointing and IsPedOnFoot(ped) and not IsPedArmed(PlayerPedId(), 7) then
		Boro_Bala()
	end
end)

AddEventHandler('onKeyUP', function(key)
	local ped = PlayerPedId()
	if key == 'b' and mp_pointing and IsPedOnFoot(ped) and not IsPedArmed(PlayerPedId(), 7) then
		stopPointing()
	end
end)