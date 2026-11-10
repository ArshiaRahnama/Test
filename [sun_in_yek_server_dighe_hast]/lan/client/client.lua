-- Pub by FleeX Team , https://discord.gg/87rGBxgCsa

ESX = exports['essentialmode']:getObject()
PlayerLoaded = false

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

Citizen.CreateThread(function()
    while ESX == nil do
        Wait(1000)
    end
	ESX.SetPlayerData('connect', 1)
end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
    PlayerLoaded = true
end)


function dpemote(state)
	TriggerEvent("dpemote:enable",state)
end

local connected = true

function checkalive()
	if connected == false then
        ESX.SetPlayerData('connect', 0)
		dpemote(false)
		while connected == false do
			Wait(1)
			DisableControlAction(0, 30,  true) -- MoveLeftRight
			DisableControlAction(0, 31,  true) -- MoveUpDown
			DisableControlAction(2, Keys['~'], true) -- HandsUP
			DisableControlAction(2, Keys['X'], true) -- HandsUP
			DisableControlAction(2, Keys['LEFTSHIFT'], true) -- HandsUP
			DisableControlAction(2, Keys['R'], true) -- Reload
			DisableControlAction(2, Keys['TOP'], true) -- Open phone (not needed?)
			DisableControlAction(2, Keys['SPACE'], true) -- Jump
			DisableControlAction(2, Keys['Q'], true) -- Cover
			DisableControlAction(2, Keys['TAB'], true) -- Select Weapon
			DisableControlAction(2, Keys['M'], true) -- Select Weapon
			DisableControlAction(2, Keys['F'], true) -- Also 'enter'?
			DisableControlAction(2, Keys['F1'], true) -- Disable phone
			DisableControlAction(2, Keys['F2'], true) -- Inventory
			DisableControlAction(2, Keys['F3'], true) -- Animations
			DisableControlAction(2, Keys['F5'], true)
			DisableControlAction(2, Keys['F6'], true)
			DisableControlAction(2, Keys['E'], true)
			DisableControlAction(2, Keys['L'], true)
			DisableControlAction(2, Keys['P'], true) -- Disable pause screen
			DisableControlAction(2, Keys['LEFTCTRL'], true) -- Disable going stealth
			DisableControlAction(2, 24, true) -- Attack
			DisableControlAction(2, 257, true) -- Attack 2
			DisableControlAction(2, 25, true) -- Aim
			DisableControlAction(2, 263, true) -- Melee Attack 1
			DisableControlAction(2, 59, true) -- Disable steering in vehicle
			DisableControlAction(0, 47, true)  -- Disable weapon
			DisableControlAction(0, 264, true) -- Disable melee
			DisableControlAction(0, 257, true) -- Disable melee
			DisableControlAction(0, 140, true) -- Disable melee
			DisableControlAction(0, 141, true) -- Disable melee
			DisableControlAction(0, 142, true) -- Disable melee
			DisableControlAction(0, 143, true) -- Disable melee
			DisableControlAction(0, 75, true)  -- Disable exit vehicle
			DisableControlAction(27, 75, true) -- Disable exit vehicle
			DisableControlAction(0, Keys['Q'], true)
			DisableControlAction(0, Keys['PAGEDOWN'], true)
			DisableControlAction(0, Keys['M'], true)
			DisableControlAction(0, Keys['U'], true)
			DisableControlAction(0, Keys['Y'], true)
			DisableControlAction(0, Keys['Z'], true)
			DisableControlAction(0, Keys['B'], true)
		end
		dpemote(true)
        ESX.SetPlayerData('connect', 1)
	else
		connected = false
        ESX.SetPlayerData('connect', 1)
	end
end

local thread = false
-- RegisterNUICallback('lan', function(_)
-- 	if not _.connection then
-- 		if not thread then
-- 			thread = true
-- 			ESX.SetPlayerData('connect', 0)
-- 			Citizen.CreateThread(function()
-- 				while thread do 
-- 					DisableAllControlActions(0)
-- 					DisableAllControlActions(1)
-- 					Citizen.Wait(1)
-- 				end
-- 			end)
-- 		end
--    	else
-- 		ESX.SetPlayerData('connect', 1)
-- 		thread = false
--    	end
-- end)


RegisterNetEvent('lan:active')
AddEventHandler('lan:active',function(state)
	connected = true
end)

-- Citizen.CreateThread(function()
-- 	while true do
-- 		Wait(10000)
-- 		if connected then
-- 			ESX.SetPlayerData('connect', 1)
-- 			connected = false
-- 			if thread then
-- 				thread = false
-- 				SendNUIMessage({data = false})
-- 			end
-- 		else
-- 			if not thread then
-- 				ESX.SetPlayerData('connect', 0)
-- 				thread = true
-- 				SendNUIMessage({data = true})
-- 				Citizen.CreateThread(function()
-- 					while thread do 
-- 						DisableAllControlActions(0)
-- 						DisableAllControlActions(1)
-- 						Citizen.Wait(1)
-- 					end
-- 				end)
-- 			end
-- 		end
-- 	end
-- end)

-- exports('checkalive',checkalive)

local Cam = false
local uiopen = false
RegisterNetEvent("spawn:open")
AddEventHandler("spawn:open", function(pos)
	-- DoScreenFadeOut(50)
	while not PlayerLoaded do
        Citizen.Wait(10)
    end
    SetEntityVisible(playerPed, false)
	--DoScreenFadeIn(3000)
	TriggerEvent("spawn:cam")
end)

RegisterNUICallback('spawn', function(data, cb)
    DoScreenFadeOut(500)
    SetNuiFocus(false, false)
	uiopen = false
	Wait(1000)
	SetNuiFocus(false, false)
    TriggerEvent("spawn:cam")
end)


RegisterNetEvent("spawn:cam")
AddEventHandler("spawn:cam", function()
	LocalPlayer.state:set('camera', true, false)
	local coords = GetEntityCoords(PlayerPedId())
    delCam()
    doCamera(coords.x,coords.y,coords.z)
	TriggerEvent('es_admin:freezePlayer',false)
	delCam()
    --SetEntityCoords(PlayerPedId(),coords.x,coords.y,coords.z)
    SetEntityVisible(GetPlayerPed(-1), true)
    Wait(200)
    --DoScreenFadeIn(2500)
    Wait(2000)
    local aspect_ratio = GetAspectRatio(0)
    local res_x, _ = GetActiveScreenResolution()
    local res_y = res_x / aspect_ratio
	ESX.SetPlayerData('IsLoaded', 1)
    TriggerEvent('es_admin:freezePlayer',false)
	TriggerEvent("loading:Loaded")
end)

function delCam()
    ClearFocus()
	DestroyAllCams(true)
	RenderScriptCams(false, true, 1, true, true)
	LocalPlayer.state:set('camera', false, false)
end

cam = 0
function doCamera(x,y,z)

	--DoScreenFadeOut(1)
	if(not DoesCamExist(cam)) then
		cam = CreateCam('DEFAULT_SCRIPTED_CAMERA', true)
	end

	i = 3200
	SetFocusArea(x, y, z, 0.0, 0.0, 0.0)
	SetCamActive(cam,  true)
	RenderScriptCams(true,  false,  0,  true,  true)
	--DoScreenFadeIn(1500)
	local camAngle = -90.0
	while i > 1 do
		local factor = i / 50
		if i < 1 then i = 1 end
		i = i - factor
		SetCamCoord(cam, x,y,z+i)
		if i < 1200 then
			--DoScreenFadeIn(600)
		end
		if i < 90.0 then
			camAngle = i - i - i
		end
		SetCamRot(cam, camAngle, 0.0, 0.0)
		Citizen.Wait(2/i)
	end
end

function round(num, numDecimalPlaces)
	local mult = 100^(numDecimalPlaces or 0)
	return math.floor(num * mult + 0.5)
end
