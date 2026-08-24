
Keys = {
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

local FirstSpawn, PlayerLoaded, inCapture, inPaintball = true, false, false, false

IsDead, InJure, beingrevived = false, false , false
ESX = nil

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(1)
	end

	while ESX.GetPlayerData().job == nil do
		Citizen.Wait(100)
	end

	PlayerLoaded = true
	ESX.PlayerData = ESX.GetPlayerData()
end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
	ESX.PlayerData = xPlayer
	PlayerLoaded = true
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
	ESX.PlayerData.job = job
end)

RegisterNetEvent('esx_ambulancejob:revivexIfDead')
AddEventHandler('esx_ambulancejob:revivexIfDead', function()

	if IsDead or InJure then
	local playerPed = PlayerPedId()
	local coords = GetEntityCoords(playerPed)
	IsDead = false
	InJure = false
	TriggerServerEvent('esx_ambulancejob:setDeathStatusx', false)
	ESX.SetPlayerData('IsDead', false)
	Citizen.CreateThread(function()
		DoScreenFadeOut(800)

		while not IsScreenFadedOut() do
			Citizen.Wait(50)
		end

		local formattedCoords = {
			x = ESX.Math.Round(coords.x, 1),
			y = ESX.Math.Round(coords.y, 1),
			z = ESX.Math.Round(coords.z, 1)
		}

		ESX.SetPlayerData('lastPosition', formattedCoords)

		TriggerServerEvent('esx:updateLastPosition', formattedCoords)

		RespawnPed_ambulance(playerPed, GetEntityCoords(PlayerPedId()), 0.0)

		DoScreenFadeIn(800)
		Citizen.Wait(250)
		StopScreenEffect('DeathFailOut')
		ClearPedTasks(playerPed)
		ClearPedBloodDamage(ped)
		coords = nil
		end)
	end
end)

RegisterNetEvent('esx_ambulancejob:revivexIfDeadx')
AddEventHandler('esx_ambulancejob:revivexIfDeadx', function()

	local playerPed = PlayerPedId()
	local coords = GetEntityCoords(playerPed)
	IsDead = false
	InJure = false
	TriggerServerEvent('esx_ambulancejob:setDeathStatusx', false)
	ESX.SetPlayerData('IsDead', false)
	Citizen.CreateThread(function()
		DoScreenFadeOut(800)

		while not IsScreenFadedOut() do
			Citizen.Wait(50)
		end

		local formattedCoords = {
			x = ESX.Math.Round(GetEntityCoords(PlayerPedId()).x, 1),
			y = ESX.Math.Round(GetEntityCoords(PlayerPedId()).y, 1),
			z = ESX.Math.Round(GetEntityCoords(PlayerPedId()).z, 1)
		}

		ESX.SetPlayerData('lastPosition', formattedCoords)

		TriggerServerEvent('esx:updateLastPosition', formattedCoords)

		RespawnPed_ambulance(playerPed, GetEntityCoords(PlayerPedId()), 0.0)

		DoScreenFadeIn(800)
		Citizen.Wait(250)
		StopScreenEffect('DeathFailOut')
		ClearPedTasks(playerPed)
		ClearPedBloodDamage(ped)
		end)
end)

AddEventHandler('playerSpawned', function()
	Citizen.Wait(10000)
	IsDead = false
	animations = false
	if FirstSpawn then
		exports.spawnmanager:setAutoSpawn(false)
		FirstSpawn = false

		ESX.TriggerServerCallback('esx_ambulancejob:getDeathStatus', function(isDead)
			if isDead and Config_ambulance.AntiCombatLog then
				while not PlayerLoaded do
					Citizen.Wait(1000)
				end

				ESX.ShowNotification(_U('combatlog_message'))
				RemoveItemsAfterRPDeath_ambulance()
			end
		end)
	end
end)

function loadAnimDict_ambulance(dict)
    while (not HasAnimDictLoaded(dict)) do
        RequestAnimDict(dict)
        Wait(1)
    end
end

Citizen.CreateThread(function()
	for k,v in pairs(Config_ambulance.Hospitals) do
		local blip = AddBlipForCoord(v.Blip.coords)
		local blip2 = AddBlipForCoord(v.Blip.coords2)

		SetBlipSprite(blip, v.Blip.sprite)
		SetBlipScale(blip, 0.7)
		SetBlipColour(blip, v.Blip.color)
		SetBlipAsShortRange(blip, true)
		SetBlipSprite(blip2, v.Blip.sprite)
		SetBlipScale(blip2, 0.7)
		SetBlipColour(blip2, v.Blip.color)
		SetBlipAsShortRange(blip2, true)
		SetBlipAsShortRange(blip, true)

		BeginTextCommandSetBlipName('STRING')
		AddTextComponentSubstringPlayerName(_U('hospital'))
		EndTextCommandSetBlipName(blip)
		BeginTextCommandSetBlipName('STRING')
		AddTextComponentSubstringPlayerName(_U('hospital'))
		EndTextCommandSetBlipName(blip2)

	end
end)

local animations = true
local InBed = nil
local IsDragged = nil
function StartDeathAnim_ambulance(ped, coords, heading)
	local pos = GetEntityCoords(ped)
	local animDict = 'combat@damage@writhe'
	local animName = 'writhe_loop'
	SetPlayerInvincible(ped, false)
	SetPlayerHealthRechargeMultiplier(PlayerId(-1), 0.0)
	SetEntityHealth(ped, 200)

	if IsPedInAnyVehicle(ped, false) then
		loadAnimDict_ambulance("veh@low@front_ps@idle_duck")
		TaskPlayAnim(ped, "veh@low@front_ps@idle_duck", "sit", 1.0, 1.0, -1, 1, 0, 0, 0, 0)
	else
		loadAnimDict_ambulance(animDict)
		TaskPlayAnim(ped, animDict, animName, 1.0, 1.0, -1, 1, 0, 0, 0, 0)
	end
	if IsPedInAnyVehicle(ped) then
		local veh = GetVehiclePedIsIn(ped)
		local vehseats = GetVehicleModelNumberOfSeats(GetHashKey(GetEntityModel(veh)))
		for i = -1, vehseats do
			local occupant = GetPedInVehicleSeat(veh, i)
			if occupant == ped then
				SetPedIntoVehicle(ped, veh, i)
				animations = false
			end
		end
	else
		if not IsPedInAnyVehicle(ped) then
			TriggerServerEvent('esx_uniquejobs:AntiCheatExempt', 5000, { teleport = true, speed = true })
			NetworkResurrectLocalPlayer(pos.x, pos.y, pos.z, heading, true, false)
			TriggerServerEvent('esx_uniquejobs:AntiCheatExempt', 5000, { teleport = true, speed = true })
			SetEntityCoordsNoOffset(ped, pos.x, pos.y, pos.z, false, false, false, true)
			loadAnimDict_ambulance(animDict)
			TaskPlayAnim(ped, animDict, animName, 1.0, 1.0, -1, 1, 0, 0, 0, 0)
		end
	end
	ESX.UI.Menu.CloseAll()
end

Citizen.SetTimeout(5000, function() animations = true end)

function OnPlayerDeath_ambulance(deathCause)
	if not ESX.GetPlayerData().IsDead then
		InJure = true
		ESX.SetPlayerData('IsDead', true)
		local playerPed = PlayerPedId()
		local ped = GetPlayerPed(-1)
		local coords = GetEntityCoords(ped)
		local heading = GetEntityHeading(ped)
		local formattedCoords = {
			x = ESX.Math.Round(coords.x, 1),
			y = ESX.Math.Round(coords.y, 1),
			z = ESX.Math.Round(coords.z, 1) - 1
		}

		Wait(2000)
		StartDeathAnim_ambulance(playerPed, formattedCoords, heading)
		TriggerServerEvent('esx_ambulancejob:setDeathStatusx', deathCause)


		TriggerEvent("SetDeadTrueMotherFucker")
		StartDistressSignal_ambulance()
		StartBleading_ambulance()

		StartScreenEffect('DeathFailOut', 0, true)
		ESX.UI.Menu.CloseAll()

		Citizen.CreateThread(function()
			while InJure do
				Wait(1)
				DisableControlAction(0, Keys['F1'],true)

				DisableControlAction(0, Keys['F3'],true)
				DisableControlAction(0, Keys['F5'],true)
				DisableControlAction(0, Keys['F6'],true)
				DisableControlAction(0, Keys['R'], true)
				DisableControlAction(0, Keys['W'],true)
				DisableControlAction(0, Keys['S'],true)
				DisableControlAction(0, Keys['A'],true)
				DisableControlAction(0, Keys['D'], true)
				DisableControlAction(0, Keys['SPACE'], true)
				DisableControlAction(0, Keys['TAB'], true)
				DisableControlAction(0, Keys['K'], true)
				DisableControlAction(0, Keys['X'], true)
				DisableControlAction(0, Keys['M'], true)
				DisableControlAction(0, Keys['E'], true)
				DisableControlAction(0, Keys['F'], true)
				DisableControlAction(0, Keys['L'], true)
				DisableControlAction(0, 24, true)
				DisableControlAction(0, 257, true)
				DisableControlAction(0, 25, true)
				DisableControlAction(0, 264, true)
				DisableControlAction(0, 257, true)
				DisableControlAction(0, 140, true)
				DisableControlAction(0, 141, true)
				DisableControlAction(0, 142, true)
				DisableControlAction(0, 143, true)
				DisableControlAction(0, 263, true)
				DisableControlAction(0, 27, true)
				DisableControlAction(0, 23, true)
				DisableControlAction(0, 182, true)
				DisableControlAction(0, 44, true)
				DisableControlAction(0, 75, true)
				if IsPedInAnyVehicle(PlayerPedId(), false) then
					SetCurrentPedWeapon(PlayerPedId(), GetHashKey("weapon_unarmed"), true)
				end
			end

		end)
		Citizen.CreateThread(function()
			local active_timeout = false
			while InJure and not be do
				local stopped = IsPedStopped(GetPlayerPed(-1))
				if stopped == false then
					if beingrevived then
						if not active_timeout then
							active_timeout = true
							SetTimeout(15 * 1000 * 60, function()
								beingrevived = false
								active_timeout = false
							end)
						end
					else
						StartDeathAnim_ambulance(playerPed, formattedCoords, heading)
					end
				end
				Citizen.Wait(100)
			end
			return
		end)



		if IsPedInAnyVehicle(ped, true) then
			Wait(1000)
			plyPos = GetEntityCoords(GetPlayerPed(-1),  true)
			local xnew = plyPos.x+0.1
			local ynew = plyPos.y+0.1
			TriggerEvent('Unique_Scripts_HuD:changeStatus', false)
			TriggerServerEvent('esx_uniquejobs:AntiCheatExempt', 5000, { teleport = true, speed = true })
			SetEntityCoords(GetPlayerPed(-1), xnew, ynew, plyPos.z)
		end

	else

		InJure = false
		IsDead = true
		TriggerServerEvent('esx_ambulancejob:setDeathStatusx', -1)
		ESX.SetPlayerData('IsDead', -1)
		StartDeathTimer_ambulance()
		Citizen.CreateThread(function()
			while IsDead do
				Wait(1)
				DisableAllControlActions(0)
				EnableControlAction(0, Keys['T'], true)
			end
		end)
		Citizen.CreateThread(function()
			local timer = 5 * 60
			while IsDead and timer > 0 do
				Citizen.Wait(1000)
				timer = timer - 1
			end
			if timer < 1 then
				RemoveItemsAfterRPDeath_ambulance()
			end
		end)
	end
end

RegisterNetEvent('esx_ambulancejob:useItem')
AddEventHandler('esx_ambulancejob:useItem', function(itemName)
	ESX.UI.Menu.CloseAll()

	if itemName == 'medikit' then
		local lib, anim = 'anim@heists@narcotics@funding@gang_idle', 'gang_chatting_idle01'
		local playerPed = PlayerPedId()

		ESX.Streaming.RequestAnimDict(lib, function()
			TaskPlayAnim(playerPed, lib, anim, 8.0, -8.0, -1, 0, 0, false, false, false)

			Citizen.Wait(500)
			while IsEntityPlayingAnim(playerPed, lib, anim, 3) do
				Citizen.Wait(1)
				DisableAllControlActions(0)
				EnableControlAction(0, Keys['N'], true)
				EnableControlAction(0, Keys['T'], true)
				EnableControlAction(0, 1, true)
				EnableControlAction(0, 2, true)
				EnableControlAction(0, 4, true)
				EnableControlAction(0, 6, true)
			end

			TriggerEvent('esx_ambulancejob:heal', 'big', true)
			ESX.ShowNotification(_U('used_medikit'))
		end)

	elseif itemName == 'bandage' then
		local lib, anim = 'anim@heists@narcotics@funding@gang_idle', 'gang_chatting_idle01'
		local playerPed = PlayerPedId()

		ESX.Streaming.RequestAnimDict(lib, function()
			TaskPlayAnim(playerPed, lib, anim, 8.0, -8.0, -1, 0, 0, false, false, false)

			Citizen.Wait(500)
			while IsEntityPlayingAnim(playerPed, lib, anim, 3) do
				Citizen.Wait(1)
				DisableAllControlActions(0)
				EnableControlAction(0, Keys['N'], true)
				EnableControlAction(0, Keys['T'], true)
				EnableControlAction(0, 1, true)
				EnableControlAction(0, 2, true)
				EnableControlAction(0, 4, true)
				EnableControlAction(0, 6, true)
			end

			TriggerEvent('esx_ambulancejob:heal', 'small', true)
			ESX.ShowNotification(_U('used_bandage'))
		end)
	end
end)

function StartDistressSignal_ambulance()
	Citizen.CreateThread(function()
		local timer = Config_ambulance.BleedoutTimer

		while timer > 0 and InJure do
			Citizen.Wait(2)
			timer = timer - 30

			SetTextFont(4)
			SetTextScale(0.45, 0.45)
			SetTextColour(185, 185, 185, 255)
			SetTextDropshadow(0, 0, 0, 0, 255)
			SetTextEdge(1, 0, 0, 0, 255)
			SetTextDropShadow()
			SetTextOutline()
			BeginTextCommandDisplayText('STRING')
			AddTextComponentSubstringPlayerName(_U('distress_send'))
			EndTextCommandDisplayText(0.175, 0.805)

			if IsControlPressed(0, Keys['G']) then

				TriggerServerEvent('esx_ambulancejob:addreq', 'Man be Medic Neyaz Daram')
				Citizen.CreateThread(function()
					Citizen.Wait(1000 * 60 * 5)
					if InJure then
						StartDistressSignal_ambulance()
					end
				end)

				break
			end
		end
	end)
end

function SendDistressSignal_ambulance()
	local playerPed = PlayerPedId()
	PedPosition		= GetEntityCoords(playerPed)

	local PlayerCoords = { x = PedPosition.x, y = PedPosition.y, z = PedPosition.z }

	ESX.ShowNotification(_U('distress_sent'))
	local data = {
		message = _U('distress_message'),
		number = 'ambulance',
		coords = PlayerCoords
	}
    TriggerEvent('esx_addons_gcphone:call', data)
end

function DrawGenericTextThisFrame_ambulance()
	SetTextFont(4)
	SetTextScale(0.0, 0.5)
	SetTextColour(255, 255, 255, 255)
	SetTextDropshadow(0, 0, 0, 0, 255)
	SetTextEdge(1, 0, 0, 0, 255)
	SetTextDropShadow()
	SetTextOutline()
	SetTextCentre(true)
end

function secondsToClock_ambulance(seconds)
	local seconds, hours, mins, secs = tonumber(seconds), 0, 0, 0

	if seconds <= 0 then
		return 0, 0
	else
		local hours = string.format("%02.f", math.floor(seconds / 3600))
		local mins = string.format("%02.f", math.floor(seconds / 60 - (hours * 60)))
		local secs = string.format("%02.f", math.floor(seconds - hours * 3600 - mins * 60))

		return mins, secs
	end
end

function StartBleading_ambulance()
	local bleedingTimer = ESX.Math.Round(Config_ambulance.EarlyRespawnTimer / 1000)

	Citizen.CreateThread(function()

		while bleedingTimer > 0 and InJure do
			Citizen.Wait(1000)
			bleedingTimer = bleedingTimer - 1
		end
		if bleedingTimer < 1 then
			OnPlayerDeath_ambulance(-1)
		end
	end)

	Citizen.CreateThread(function()
		local text
		while bleedingTimer > 0 and InJure do
			Citizen.Wait(1)
			text = _U('respawn_available_in', secondsToClock_ambulance(bleedingTimer))

			DrawGenericTextThisFrame_ambulance()

			SetTextEntry("STRING")
			AddTextComponentString(text)
			DrawText(0.5, 0.8)
		end
	end)
end

function StartDeathTimer_ambulance()
	local DeathTimer = ESX.Math.Round(Config_ambulance.BleedoutTimer / 1000)

	Citizen.CreateThread(function()

		while DeathTimer > 0 and IsDead do
			Citizen.Wait(1000)
			DeathTimer = DeathTimer - 1
		end
	end)

	Citizen.CreateThread(function()
		local text
		while DeathTimer > 0 and IsDead do
			Citizen.Wait(1)
			text = _U('respawn_bleedout_in', secondsToClock_ambulance(DeathTimer))
			DrawGenericTextThisFrame_ambulance()

			SetTextEntry("STRING")
			AddTextComponentString(text)
			DrawText(0.5, 0.8)
		end
	end)
end

function RemoveItemsAfterRPDeath_ambulance()
	IsDead = false
	ESX.SetPlayerData('IsDead', false)
	TriggerServerEvent('esx_ambulancejob:setDeathStatusx', false)

	Citizen.CreateThread(function()
		DoScreenFadeOut(800)

		while not IsScreenFadedOut() do
			Citizen.Wait(10)
		end

		ESX.TriggerServerCallback('esx_ambulancejob:removeItemsAfterRPDeath', function()
			local formattedCoords = {
				x = Config_ambulance.RespawnPoint.coords.x,
				y = Config_ambulance.RespawnPoint.coords.y,
				z = Config_ambulance.RespawnPoint.coords.z
			}

			ESX.SetPlayerData('lastPosition', formattedCoords)
			ESX.SetPlayerData('loadout', {})

			TriggerServerEvent('esx:updateLastPosition', formattedCoords)
			RespawnPed_ambulance(PlayerPedId(), formattedCoords, Config_ambulance.RespawnPoint.heading)

			StopScreenEffect('DeathFailOut')
			DoScreenFadeIn(800)
		end)
	end)
end

function RespawnPed_ambulance(ped, coords, heading)
	TriggerServerEvent('esx_uniquejobs:AntiCheatExempt', 5000, { teleport = true, speed = true })
	SetEntityCoordsNoOffset(ped, coords.x, coords.y, coords.z, false, false, false, true)
	TriggerServerEvent('esx_uniquejobs:AntiCheatExempt', 5000, { teleport = true, speed = true })
	NetworkResurrectLocalPlayer(coords.x, coords.y, coords.z, heading, true, false)
	SetPlayerInvincible(ped, false)
	TriggerEvent('playerSpawned', coords.x, coords.y, coords.z)
	ClearPedBloodDamage(ped)
	setDeathDecor_ambulance(ped, false)
	ESX.UI.Menu.CloseAll()

end

RegisterNetEvent('esx_phone:loaded')
AddEventHandler('esx_phone:loaded', function(phoneNumber, contacts)
	local specialContact = {
		name       = 'Ambulance',
		number     = 'ambulance',
		base64Icon = 'data:image/png;base64,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'
	}

	TriggerEvent('esx_phone:addSpecialContact', specialContact.name, specialContact.number, specialContact.base64Icon)
end)

AddEventHandler('capture:inCapture', function(bool)
	inCapture = bool
end)

AddEventHandler('esx_paintball:inPaintBall', function(bool)
	inPaintball = bool
end)

AddEventHandler('esx:onPlayerDeath', function(data)
	if inPaintball then
		Wait(500)
	elseif inCapture then
		Wait(1000)
		local playerPed = PlayerPedId()
		local coords = GetEntityCoords(playerPed)
		TriggerServerEvent('esx_ambulancejob:revivex', GetPlayerServerId(source))
		local formattedCoords = {
			x = ESX.Math.Round(GetEntityCoords(PlayerPedId()).x, 1),
			y = ESX.Math.Round(GetEntityCoords(PlayerPedId()).y, 1),
			z = ESX.Math.Round(GetEntityCoords(PlayerPedId()).z, 1)
		}

		ESX.SetPlayerData('lastPosition', formattedCoords)

		TriggerServerEvent('esx:updateLastPosition', formattedCoords)
		TriggerServerEvent('esx_ambulancejob:revivex', GetPlayerServerId(source))

		StopScreenEffect('DeathFailOut')
		DoScreenFadeIn(800)
	else
		OnPlayerDeath_ambulance(true)
		setDeathDecor_ambulance(PlayerPedId(), true)
	end
end)

RegisterNetEvent('esx_ambulancejob:revivex')
AddEventHandler('esx_ambulancejob:revivex', function()

	local playerPed = PlayerPedId()
	local coords = GetEntityCoords(PlayerPedId())
	TriggerServerEvent('esx_ambulancejob:requestfalse', GetPlayerServerId(PlayerId()))
	IsDead = false
	InJure = false
	TriggerServerEvent('esx_ambulancejob:setDeathStatusx', false)
	ESX.SetPlayerData('IsDead', false)
	Citizen.CreateThread(function()
		DoScreenFadeOut(800)

		while not IsScreenFadedOut() do
			Citizen.Wait(50)
		end

		local formattedCoords = {x = ESX.Math.Round(GetEntityCoords(PlayerPedId()).x, 1),
		y = ESX.Math.Round(GetEntityCoords(PlayerPedId()).y, 1),
		z = ESX.Math.Round(GetEntityCoords(PlayerPedId()).z, 1)
		}

		ESX.SetPlayerData('lastPosition', formattedCoords)

		TriggerServerEvent('esx:updateLastPosition', formattedCoords)

		RespawnPed_ambulance(playerPed, GetEntityCoords(PlayerPedId()), 0.0)

		DoScreenFadeIn(800)
		Citizen.Wait(250)
		StopScreenEffect('DeathFailOut')
		ClearPedTasks(playerPed)
		coords = nil

	end)

end)

if Config_ambulance.LoadIpl then
	Citizen.CreateThread(function()
		RequestIpl('Coroner_Int_on')
	end)
end


RegisterNetEvent('esx_ambulancejob:openreqs')
AddEventHandler('esx_ambulancejob:openreqs', function(source)
	OpenReqsList_ambulance()
end)

RegisterNetEvent('esx_ambulancejob:acceptreq')
AddEventHandler('esx_ambulancejob:acceptreq', function(loc)
	SetNewWaypoint(loc)
end)

RegisterNetEvent('esx_ambulancejob:addblip')
AddEventHandler('esx_ambulancejob:addblip', function(id, coords)
	local id = id
	if carblip ~= 0 then
		RemoveBlip(carblip)
		carblip = 0
	end
	Wait(1)
	carblip = AddBlipForCoord(coords)
	SetBlipSprite(carblip, 586)
	SetBlipFlashes(carblip, true)
	SetBlipColour(carblip,5)
	SetBlipFlashTimer(carblip, 5000)
	BeginTextCommandSetBlipName('STRING')
	AddTextComponentSubstringPlayerName('Medic')
	EndTextCommandSetBlipName(carblip)
	while carblip ~= 0 do
		Wait(1)
		ESX.TriggerServerCallback('esx_ambulancejob:getcoord', function(coords)
			if coords ~= nil then
				SetBlipCoords(carblip,coords)
			else
				RemoveBlip(carblip)
				carblip = 0
			end
		end,id)
	end
end)

RegisterNetEvent('esx_ambulancejob:delblip')
AddEventHandler('esx_ambulancejob:delblip',function()
	if carblip ~= 0 then
		RemoveBlip(carblip)
		carblip = 0
	end
end)

RegisterNetEvent('requestambulance')
AddEventHandler('requestambulance', function()

end)

function OpenReqsList_ambulance()
	ESX.TriggerServerCallback('esx_ambulancejob:getReqs', function(reqs)

	local elements = {}
	for i=1, #reqs, 1 do

		table.insert(elements, {
			label = "Request Id : "..reqs[i].reqid.." | Accept : "..reqs[i].status.." | Distance : ".. ESX.Math.Round(GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()),reqs[i].coord)),
			icname = reqs[i].name,
			reqid = reqs[i].reqid,
			text = reqs[i].reason,
			status = reqs[i].status,
			phone = reqs[i].phone,
			id = reqs[i].id,
			coord = reqs[i].coord,
			accept = reqs[i].accept,
		})
	end


 	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'reqs_lists', {

		title    = "Requests",
		align    = 'bottom-right',
		elements = elements
	}, function(data, menu)

		local elements = {}
		local id = data.current.reqid
		ESX.TriggerServerCallback('esx_ambulancejob:acceptername', function(acceptername, accepterID)
		ESX.TriggerServerCallback('esx_ambulancejob:icname', function(name)
		table.insert(elements,{label = "RequestId : ".. data.current.reqid.." | PlayerID : "..data.current.id ,value = "nil"})

		table.insert(elements,{label = "Accept status : "..data.current.status ,value = "nil"})

		table.insert(elements,{label = "Request by : ".. data.current.icname.." | "..data.current.id, value = "nil"})

			if data.current.accept == "open" then
				table.insert(elements,{label = "Accept", value = "yes"})
			else

				table.insert(elements,{label = "Accepted by : ".. acceptername.." | "..accepterID, value = "nil"})
				table.insert(elements,{label = "Carry 50m ", value = "carry"})


			end

			if acceptername == name then
				table.insert(elements,{label = "Decline",value = "decline"})
				table.insert(elements,{label = "Finish",value = "finish"})
			end

		table.insert(elements,{label = "Pin location",value = "loc"})
		table.insert(elements,{label = "Call",value = "call"})


 		ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'reqs_list', {

				title    = "Request",
				align    = 'bottom-right',
				elements = elements
				}, function(data2, menu2)

				menu2.close()
 				if data2.current.value == 'yes' then
					TriggerServerEvent('esx_ambulancejob:areqs', data.current.reqid)
					menu.close()
				elseif data2.current.value == 'call' then
					TriggerEvent('gcphone:autoCall', data.current.phone)
					menu.close()
				elseif data2.current.value == 'finish' then
					TriggerServerEvent("esx_ambulancejob:creqs", data.current.reqid)
					menu.close()
				elseif data2.current.value == 'decline' then
					TriggerServerEvent("esx_ambulancejob:decline", data.current.reqid)
					menu.close()
				elseif data2.current.value == 'carry' then
					ExecuteCommand('carrymdd '..data.current.id)
				elseif data2.current.value == 'matn' then
					TriggerServerEvent("esx_ambulancejob:chat", data.current.text)
					menu.close()
				elseif data2.current.value == 'loc' then
					local Ped = GetPlayerPed(GetPlayerFromServerId(data.current.id))
					local coords = GetEntityCoords(Ped)
					SetNewWaypoint(coords)
					menu.close()
				end
			end, function(data2, menu2)
				menu2.close()
			end)
			end)
			end, id)
 		end, function(data, menu)
			menu.close()

		end)

	end)
end

function setDeathDecor_ambulance(ped, state)
	DecorSetBool(ped, "isDead", state)
end