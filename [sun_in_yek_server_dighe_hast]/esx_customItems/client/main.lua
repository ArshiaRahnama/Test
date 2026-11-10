-- Pub by FleeX Team , https://discord.gg/87rGBxgCsa

ESX          = exports['essentialmode']:getObject()

RegisterNetEvent('item:playSmoke', function(name)
	exports['sun-animmenu']:PlayEmote('smoke', true)
end)


RegisterNetEvent('esx_customItems:useArmor')
AddEventHandler('esx_customItems:useArmor', function(armor)
	if not exports['sun-jobs']:notBlackListCoords() then return ESX.chatMessage('Shoma nemitavanid dar in location in item ra use konid!', 'plarms') end
	TriggerEvent("mythic_progbar:client:progress", {
		name = "armor_putin",
		duration = 5000,
		label = "Dar hale poshidan armor",
		useWhileDead = false,
		canCancel = true,
		controlDisables = {
			disableMovement = true,
			disableCarMovement = true,
			disableMouse = false,
			disableCombat = true,
		},
		animation = {
            animDict = "rcmfanatic3",
            anim = "kneel_idle_a",
        },
        prop = {
            model = "prop_bodyarmour_03",
        }
	}, function(status)
		if not status then
			ClearPedTasksImmediately(GetPlayerPed(-1))
			ESX.TriggerServerCallback('esx_customItems:removeArmor', function(doesHave)
				if doesHave then
					local job = ESX.GetPlayerData().job.name
					TriggerEvent('skinchanger:getSkin', function(skin)
						if skin.sex == 0 then
							if ESX.militaryJobs2[job] then
								TriggerEvent('skinchanger:loadClothes', skin, {['bproof_1'] = 208,  ['bproof_2'] = 0})
							else
								TriggerEvent('skinchanger:loadClothes', skin, {['bproof_1'] = 15,  ['bproof_2'] = 2})
							end
						elseif skin.sex == 1 then
							if ESX.militaryJobs2[job] then
								TriggerEvent('skinchanger:loadClothes', skin, {['bproof_1'] = 184,  ['bproof_2'] = 1})
							else
								TriggerEvent('skinchanger:loadClothes', skin, {['bproof_1'] = 17,  ['bproof_2'] = 2})
							end
						end
					end)
					ESX.SetPedArmour(GetPlayerPed(-1), armor or 50)
					ESX.ShowNotification("~h~Shoma ba movafaghiat ~g~Armor ~w~use kardid!")
				else
					ESX.ShowNotification("~h~Shoma armor nadarid!")
				end
			end, armor or 50)
		elseif status then
		  	ClearPedTasksImmediately(GetPlayerPed(-1))
		end
	end)

end)


AddEventHandler('onKeyUP',function(key)
	if key == 'r' then
		if GetAmmoInPedWeapon(PlayerPedId(),GetSelectedPedWeapon(PlayerPedId())) <= 50 and GetSelectedPedWeapon(PlayerPedId()) ~= GetHashKey('WEAPON_UNARMED') and GetSelectedPedWeapon(PlayerPedId()) ~= GetHashKey('WEAPON_BAT') and GetSelectedPedWeapon(PlayerPedId()) ~= GetHashKey('WEAPON_FLASHLIGHT') then
			TriggerServerEvent('useclip')
		end
	end
end)

RegisterNetEvent('usediastat')
AddEventHandler('usediastat',function()
	local lib, anim = 'anim@mp_player_intcelebrationmale@face_palm', 'face_palm' -- TODO better animations
	local playerPed = PlayerPedId()
	ESX.Streaming.RequestAnimDict(lib, function()
		TaskPlayAnim(playerPed, lib, anim, 8.0, -8.0, 10000, 32, 0, false, false, false)

		Citizen.Wait(500)
		while IsEntityPlayingAnim(playerPed, lib, anim, 3) do
			Citizen.Wait(0)
			DisableAllControlActions(0)
		end

		Citizen.CreateThread(function()
			local timer = true
			SetTimeout(1000*60, function()
				timer = false
			end)
			SetPedMoveRateOverride(PlayerId(), 10.0)
			SetRunSprintMultiplierForPlayer(PlayerId(), 10.49)
			while timer do
				Citizen.Wait(0)
				RestorePlayerStamina(PlayerId(), 1.0)
			end
			SetPedMoveRateOverride(PlayerId(), 0.0)
			SetRunSprintMultiplierForPlayer(PlayerId(), 10.0)
		end)
	end)
end)


RegisterNetEvent('usedesomorphine')
AddEventHandler('usedesomorphine',function()
	local lib, anim = 'anim@mp_player_intcelebrationmale@face_palm', 'face_palm' -- TODO better animations
	local playerPed = PlayerPedId()
	ESX.Streaming.RequestAnimDict(lib, function()
		TaskPlayAnim(playerPed, lib, anim, 8.0, -8.0, 10000, 32, 0, false, false, false)

		Citizen.Wait(500)
		while IsEntityPlayingAnim(playerPed, lib, anim, 3) do
			Citizen.Wait(0)
			DisableAllControlActions(0)
		end

		ESX.SetPedArmour(PlayerPedId(),50)

	end)
end)

RegisterNetEvent('titopgold')
AddEventHandler('titopgold',function()
	TriggerServerEvent('InteractSound_SV:PlayWithinDistance',8,"titopgold",0.9)
	ExecuteCommand('me khar keif mishavad be dalil khordan titop talaee')
	exports['sun-animmenu']:PlayEmote("clown")
end)

RegisterNetEvent('usewellbutrin')
AddEventHandler('usewellbutrin',function()
	local lib, anim = 'anim@mp_player_intcelebrationmale@face_palm', 'face_palm' -- TODO better animations
	local playerPed = PlayerPedId()
	ESX.Streaming.RequestAnimDict(lib, function()
		TaskPlayAnim(playerPed, lib, anim, 8.0, -8.0, 10000, 32, 0, false, false, false)

		Citizen.Wait(500)
		while IsEntityPlayingAnim(playerPed, lib, anim, 3) do
			Citizen.Wait(0)
			DisableAllControlActions(0)
		end

		while GetEntityHealth(PlayerPedId()) < 200 and not exports['sun-robbery']:doesInRob() do
			Citizen.Wait(1000)
			ESX.SetEntityHealth(PlayerPedId(),GetEntityHealth(PlayerPedId()) + 1)
		end

	end)
end)


--------


local fov_max = 70.0
local fov_min = 5.0 -- max zoom level (smaller fov is more zoom)
local zoomspeed = 10.0 -- camera zoom speed
local speed_lr = 8.0 -- speed by which the camera pans left-right
local speed_ud = 8.0 -- speed by which the camera pans up-down

local binoculars = false
local fov = (fov_max+fov_min)*0.5

local Keys = {
	["ESC"] = 322, ["F1"] = 288, ["F2"] = 289, ["F3"] = 170, ["F5"] = 166, ["F6"] = 167, ["F7"] = 168, ["F8"] = 169, ["F9"] = 56, ["F10"] = 57,
	["~"] = 243, ["1"] = 157, ["2"] = 158, ["3"] = 160, ["4"] = 164, ["5"] = 165, ["6"] = 159, ["7"] = 161, ["8"] = 162, ["9"] = 163, ["-"] = 84, ["="] = 83, ["BACKSPACE"] = 177,
	["TAB"] = 37, ["Q"] = 44, ["W"] = 32, ["E"] = 38, ["R"] = 45, ["T"] = 245, ["Y"] = 246, ["U"] = 303, ["P"] = 199, ["["] = 39, ["]"] = 40, ["ENTER"] = 18,
	["CAPS"] = 137, ["A"] = 34, ["S"] = 8, ["D"] = 9, ["F"] = 23, ["G"] = 47, ["H"] = 74, ["K"] = 311, ["L"] = 182,
	["LEFTSHIFT"] = 21, ["Z"] = 20, ["X"] = 73, ["C"] = 26, ["V"] = 0, ["B"] = 29, ["N"] = 249, ["M"] = 244, [","] = 82, ["."] = 81,
	["LEFTCTRL"] = 36, ["LEFTALT"] = 19, ["SPACE"] = 22, ["RIGHTCTRL"] = 70,
	["HOME"] = 213, ["PAGEUP"] = 10, ["PAGEDOWN"] = 11, ["DELETE"] = 178,
	["LEFT"] = 174, ["RIGHT"] = 175, ["TOP"] = 27, ["DOWN"] = 173,
	["NENTER"] = 201, ["N4"] = 108, ["N5"] = 60, ["N6"] = 107, ["N+"] = 96, ["N-"] = 97, ["N7"] = 117, ["N8"] = 61, ["N9"] = 118
}

local keybindEnabled = true -- When enabled, binocular are available by keybind
local binocularKey = Keys["G"]
local storeBinoclarKey = Keys["BACKSPACE"]

--THREADS--


--EVENTS--

-- Activate binoculars
RegisterNetEvent('binoculars:Activate')
AddEventHandler('binoculars:Activate', function()
    if not ESX.GetPlayerData().HandCuffed and not ESX.GetPlayerData().IsInjure and not ESX.GetPlayerData().IsDead then
        binoculars = not binoculars
        Citizen.CreateThread(function()
            while binoculars do
                Citizen.Wait(10)
                local lPed = GetPlayerPed(-1)
                if binoculars and not ( IsPedSittingInAnyVehicle( lPed ) ) then
                    Citizen.CreateThread(function()
                        TaskStartScenarioInPlace(GetPlayerPed(-1), "WORLD_HUMAN_BINOCULARS", 0, 1)
                        PlayAmbientSpeech1(GetPlayerPed(-1), "GENERIC_CURSE_MED", "SPEECH_PARAMS_FORCE")
                    end)

                    Wait(2000)


                    local scaleform = RequestScaleformMovie("BINOCULARS")

                    while not HasScaleformMovieLoaded(scaleform) do
                        Citizen.Wait(10)
                    end

                    local lPed = GetPlayerPed(-1)
                    local vehicle = GetVehiclePedIsIn(lPed)
                    local cam = CreateCam("DEFAULT_SCRIPTED_FLY_CAMERA", true)

                    AttachCamToEntity(cam, lPed, 0.0,0.0,1.0, true)
                    SetCamRot(cam, 0.0,0.0,GetEntityHeading(lPed))
                    SetCamFov(cam, fov)
                    RenderScriptCams(true, false, 0, 1, 0)
                    PushScaleformMovieFunction(scaleform, "SET_CAM_LOGO")
                    PushScaleformMovieFunctionParameterInt(0) -- 0 for nothing, 1 for LSPD logo
                    PopScaleformMovieFunctionVoid()

                    while binoculars and not IsEntityDead(lPed) and (GetVehiclePedIsIn(lPed) == vehicle) and true and not ESX.GetPlayerData().HandCuffed and not ESX.GetPlayerData().IsInjure and not ESX.GetPlayerData().IsDead do
                        if IsControlJustPressed(0, storeBinoclarKey) or IsControlJustPressed(0, Keys['X']) then -- Toggle binoculars
                            PlaySoundFrontend(-1, "SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET", false)
                            ClearPedTasks(GetPlayerPed(-1))
                            binoculars = false
                        end

                        local zoomvalue = (1.0/(fov_max-fov_min))*(fov-fov_min)
                        CheckInputRotation(cam, zoomvalue)

                        HandleZoom(cam)
                        HideHUDThisFrame()
                        DrawScaleformMovieFullscreen(scaleform, 255, 255, 255, 255)
                        Citizen.Wait(1)
                    end

                    binoculars = false
                    fov = (fov_max+fov_min)*0.5
                    RenderScriptCams(false, false, 0, 1, 0)
                    SetScaleformMovieAsNoLongerNeeded(scaleform)
                    DestroyCam(cam, false)
                    SetNightvision(false)
                    SetSeethrough(false)
                end
            end
        end)
    end
end)

--FUNCTIONS--
function HideHUDThisFrame()
	HideHelpTextThisFrame()
	HideHudAndRadarThisFrame()
	HideHudComponentThisFrame(1) -- Wanted Stars
	HideHudComponentThisFrame(2) -- Weapon icon
	HideHudComponentThisFrame(3) -- Cash
	HideHudComponentThisFrame(4) -- MP CASH
	HideHudComponentThisFrame(6)
	HideHudComponentThisFrame(7)
	HideHudComponentThisFrame(8)
	HideHudComponentThisFrame(9)
	HideHudComponentThisFrame(13) -- Cash Change
	HideHudComponentThisFrame(11) -- Floating Help Text
	HideHudComponentThisFrame(12) -- more floating help text
	HideHudComponentThisFrame(15) -- Subtitle Text
	HideHudComponentThisFrame(18) -- Game Stream
	HideHudComponentThisFrame(19) -- weapon wheel
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
	local lPed = GetPlayerPed(-1)
	if not ( IsPedSittingInAnyVehicle( lPed ) ) then

		if IsControlJustPressed(0,241) then -- Scrollup
			fov = math.max(fov - zoomspeed, fov_min)
		end
		if IsControlJustPressed(0,242) then
			fov = math.min(fov + zoomspeed, fov_max) -- ScrollDown
		end
		local current_fov = GetCamFov(cam)
		if math.abs(fov-current_fov) < 0.1 then
			fov = current_fov
		end
		SetCamFov(cam, current_fov + (fov - current_fov)*0.05)
	else
		if IsControlJustPressed(0,17) then -- Scrollup
			fov = math.max(fov - zoomspeed, fov_min)
		end
		if IsControlJustPressed(0,16) then
			fov = math.min(fov + zoomspeed, fov_max) -- ScrollDown
		end
		local current_fov = GetCamFov(cam)
		if math.abs(fov-current_fov) < 0.1 then -- the difference is too small, just set the value directly to avoid unneeded updates to FOV of order 10^-5
			fov = current_fov
		end
		SetCamFov(cam, current_fov + (fov - current_fov)*0.05) -- Smoothing of camera zoom
	end
end