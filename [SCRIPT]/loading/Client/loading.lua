local guiEnabled = false
local myIdentity = {}
local needRegister = false
local loaded       = false
ESX                = nil

Citizen.CreateThread(function ()
	EnableGui(false)
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(1)
	end
end)

function EnableGui(enable)
    SetNuiFocus(enable, enable)
    guiEnabled = enable

    SendNUIMessage({
        type = "enableui",
        enable = enable
    })
end

function CameraLoadToGround2(x, y, z)
	if not DoesCamExist(cam) then
		cam = CreateCam("DEFAULT_SCRIPTED_CAMERA",false)
	end
	local altura = 1000
	SetCamCoord(cam,vector3(x, y,f(1000)))
	while altura > (z - 5.0) do
		SetEntityCoords(PlayerPedId(), x, y, z)
		if altura <= 300 then
			altura = altura - 6
		elseif altura >= 301 and altura <= 700 then
			altura = altura - 4
		else
			altura = altura - 2
		end
		setCamHeight(altura)
		Citizen.Wait(10)
	end
end

function ToggleSound(state)
    if state then
        StartAudioScene("MP_LEADERBOARD_SCENE");
    else
        StopAudioScene("MP_LEADERBOARD_SCENE");
    end
end

function showLoadingPromt(label, time)
    Citizen.CreateThread(function()
        BeginTextCommandBusyString(tostring(label))
        EndTextCommandBusyString(3)
        Citizen.Wait(time)
        RemoveLoadingPrompt()
    end)
end

RegisterNetEvent('registerForm')
AddEventHandler('registerForm', function(bool)
needRegister = bool
end)

RegisterNetEvent("showRegisterForm")
AddEventHandler("showRegisterForm", function()
  EnableGui(true)
end)

local function EndFade()
	ShutdownLoadingScreen()
	DoScreenFadeIn(500)
	while IsScreenFadingIn() do
		Citizen.Wait(1)
	end
end

function ReadToPlay(x, y, z)
	TriggerServerEvent('asgm_LoadingSystem:ChangeKobs', false)
	disableAttack = false
	if x ~= nil and  y ~= nil and  z ~= nil then
		CameraLoadToGround2(x, y, z)
	else
		CameraLoadToGround()
	end
	SetEntityInvincible(PlayerPedId(),false)
	SetEntityVisible(PlayerPedId(),true)
	FreezeEntityPosition(PlayerPedId(),false)
	SetPedDiesInWater(PlayerPedId(),true)
	TriggerEvent('es_admin:freezePlayer', false)
	if x ~= nil and  y ~= nil and  z ~= nil then
		SetEntityCoords(PlayerPedId(), x, y, z)
	end
	KillCamera()
	TriggerEvent('esx:restoreLoadout')
	TriggerServerEvent('asgm_streetlabel:spawned')
	TriggerServerEvent('asgm_hud:spawned')
	if x ~= nil and  y ~= nil and  z ~= nil then
		SetEntityCoords(PlayerPedId(), x, y, z)
	end
	TriggerEvent('esx_status:setLastStats')
	TriggerServerEvent('esx_rack:loaded')
	Wait(500)
	TriggerEvent('es_admin:freezePlayer', false)
	TriggerEvent('esx:playerSpawned')
	Wait(500)
	TriggerEvent('es_admin:freezePlayer', false)







	ESX.SetPlayerData('IsPlayerLoaded', 1)
	TriggerEvent('esx_best:checkVanish')
	ESX.SetPlayerData('IsLoaded', 1)
	DisplayRadar(true)
	Wait(2000)
	FreezeEntityPosition(PlayerPedId(),false)
	TriggerEvent('es_admin:freezePlayer', false)
	Wait(5000)
	FreezeEntityPosition(PlayerPedId(),false)
	TriggerEvent('es_admin:freezePlayer', false)
	Wait(2000)
	FreezeEntityPosition(PlayerPedId(),false)
	TriggerEvent('es_admin:freezePlayer', false)
	Wait(3000)
	FreezeEntityPosition(PlayerPedId(),false)
	TriggerEvent('es_admin:freezePlayer', false)
	Wait(3000)
	FreezeEntityPosition(PlayerPedId(),false)
	TriggerEvent('es_admin:freezePlayer', false)
end

RegisterNUICallback('register', function(data)
	Citizen.Wait(3000)
	local player = {}
	player.playerName 	= data.name ..'_'.. data.family
	player.dateofbirth 	= data.dateofbirth
	ESX.TriggerServerCallback('nameAvalibity' , function(avalible)
		if avalible then
			TriggerServerEvent('db:updateUser', player)
			TriggerServerEvent('es:newName', player.playerName)
			Wait(1500)
			TriggerEvent("nameUpdate", player.playerName)
			EnableGui(false)
			Wait (500)

			CreateCameraOnTop()
			EndFade()
			ReadToPlay()
			Wait(2000)
			TriggerEvent('skincreator:newChar')
			FreezeEntityPosition(PlayerPedId(),false)
			TriggerEvent('es_admin:freezePlayer', false)
		else
			SendNUIMessage({
				action = 'notification',
				message= 'In moshakhasat qablan sabt shode, lotfan dobare emtehan konid!'
			})
		end
	end ,player.playerName)
end)

function setCamHeight(height)
	local pos = GetEntityCoords(PlayerPedId())
	SetCamCoord(cam,vector3(pos.x,pos.y,f(height)))
end

function KillCamera()
	if not DoesCamExist(cam) then
		cam = CreateCam("DEFAULT_SCRIPTED_CAMERA",false)
	end
	SetCamActive(cam,false)
	StopCamPointing(cam)
	RenderScriptCams(0,0,0,0,0,0)
	SetFocusEntity(PlayerPedId())
	Wait(2000)
	FreezeEntityPosition(PlayerPedId(),false)
	TriggerEvent('es_admin:freezePlayer', false)
end

local function StartFade()
	DoScreenFadeOut(500)
	while IsScreenFadingOut() do
		Citizen.Wait(1)
	end
end

function CameraLoadToGround()
	if not DoesCamExist(cam) then
		cam = CreateCam("DEFAULT_SCRIPTED_CAMERA",false)
	end
	local altura = 1000
	local pos = GetEntityCoords(PlayerPedId())
	SetCamCoord(cam,vector3(pos.x,pos.y,f(1000)))
	while altura > (pos.z - 5.0) do
		if altura <= 300 then
			altura = altura - 6
		elseif altura >= 301 and altura <= 700 then
			altura = altura - 4
		else
			altura = altura - 2
		end
		setCamHeight(altura)
		Citizen.Wait(10)
	end
end

function CreateCameraOnTop()
	if not DoesCamExist(cam) then
		cam = CreateCam("DEFAULT_SCRIPTED_CAMERA",false)
	end
	local pos = GetEntityCoords(PlayerPedId())
	SetCamCoord(cam,vector3(pos.x,pos.y,f(1000)))
	SetCamRot(cam,-f(90),f(0),f(0),2)
	SetCamActive(cam,true)
	StopCamPointing(cam)
	RenderScriptCams(true,true,0,0,0,0)
end

function f(n)
	n = n + 0.00000
	return n
end

function DisalbeAttack()
	DisableControlAction(0, 19, true)
	DisableControlAction(0, 45, true)
	DisableControlAction(0, 24, true)
	DisableControlAction(0, 257, true)
	DisableControlAction(0, 25, true)
	DisableControlAction(0, 68, true)
	DisableControlAction(0, 69, true)
	DisableControlAction(0, 70, true)
	DisableControlAction(0, 92, true)
	DisableControlAction(0, 346, true)
	DisableControlAction(0, 347, true)
	DisableControlAction(0, 264, true)
	DisableControlAction(0, 257, true)
	DisableControlAction(0, 140, true)
	DisableControlAction(0, 141, true)
	DisableControlAction(0, 142, true)
	DisableControlAction(0, 143, true)
	DisableControlAction(0, 263, true)
	if disableAttack then
		SetTimeout(0, function ()
			DisalbeAttack()
		end)
	end
end

Citizen.CreateThread(function()
	StartFade()
	ShutdownLoadingScreen()
	ShutdownLoadingScreenNui()
	showLoadingPromt("MP_SPINLOADING", 500000)
	CreateCameraOnTop()
	SetEntityVisible(PlayerPedId(),true)
	DisalbeAttack()
	SetEntityInvincible(PlayerPedId(),true)
	FreezeEntityPosition(PlayerPedId(),true)
	SetPedDiesInWater(PlayerPedId(),false)
	DisplayRadar(false)
	Wait(1000)
	EndFade()
	DoScreenFadeIn(500)
	while needRegister == nil do
		Wait(5000)
	end

	if needRegister then
		showLoadingPromt("MP_SPINLOADING", 0)
		showLoadingPromt("PCARD_JOIN_GAME", 500000)
		Wait(1000)
		showLoadingPromt("PCARD_JOIN_GAME", 0)
		CreateCameraOnTop()
		SetTimeout(1000,function()
			EnableGui(true)
		end)
	else
		TriggerEvent('freezePlayer', true)
		showLoadingPromt("MP_SPINLOADING", 0)
		showLoadingPromt("PCARD_JOIN_GAME", 500000)
		Wait(1000)
		showLoadingPromt("PCARD_JOIN_GAME", 0)
		CreateCameraOnTop()
		EndFade()
		ReadToPlay()
	end
end)

Citizen.CreateThread(function()
    while true do
        if guiEnabled then
            DisableControlAction(0, 18, guiEnabled)
            DisableControlAction(0, 322, guiEnabled)
        end
		Citizen.Wait(1)
	end
end)

