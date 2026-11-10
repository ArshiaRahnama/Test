-- Pub by FleeX Team , https://discord.gg/87rGBxgCsa

local isTackling				= false
local isGettingTackled			= false

local tackleLib					= 'missmic2ig_11'
local tackleAnim 				= 'mic_2_ig_11_intro_goon'
local tackleVictimAnim			= 'mic_2_ig_11_intro_p_one'

local lastTackleTime			= 0
local isRagdoll					= false

local jobs = {
	police = true,
	sheriff = true,
	mt = true,
	fbi = true,
	justice = true,
	detective = true,
}

function thread()
	Citizen.CreateThread(function()
		while isRagdoll do
			Citizen.Wait(10)
			SetPedToRagdoll(PlayerPedId(), 1000, 1000, 0, 0, 0, 0)
		end
	end)
end

RegisterNetEvent('esx_kekke_tackle:getTackled')
AddEventHandler('esx_kekke_tackle:getTackled', function(target)
	isGettingTackled = true
	if not ESX.Game.PlayerExist(target) then return end
	local playerPed = GetPlayerPed(-1)
	local targetPed = GetPlayerPed(GetPlayerFromServerId(target))
	if lib.progressActive() then
		lib.cancelProgress()
	end
	LocalPlayer.state.blockTeleporter = true
	RequestAnimDict(tackleLib)

	while not HasAnimDictLoaded(tackleLib) do
		Citizen.Wait(10)
	end

	AttachEntityToEntity(GetPlayerPed(-1), targetPed, 11816, 0.25, 0.5, 0.0, 0.5, 0.5, 180.0, false, false, false, false, 2, false)
	TaskPlayAnim(playerPed, tackleLib, tackleVictimAnim, 8.0, -8.0, 3000, 0, 0, false, false, false)

	Citizen.Wait(3000)
	DetachEntity(GetPlayerPed(-1), true, false)

	isRagdoll = true
	thread()
	Citizen.Wait(3000)
	isRagdoll = false

	isGettingTackled = false
	LocalPlayer.state.blockTeleporter = false
end)

RegisterNetEvent('esx_kekke_tackle:playTackle')
AddEventHandler('esx_kekke_tackle:playTackle', function()
	local playerPed = GetPlayerPed(-1)

	RequestAnimDict(tackleLib)

	while not HasAnimDictLoaded(tackleLib) do
		Citizen.Wait(10)
	end

	TaskPlayAnim(playerPed, tackleLib, tackleAnim, 8.0, -8.0, 3000, 0, 0, false, false, false)

	Citizen.Wait(3000)

	isTackling = false
	LocalPlayer.state.blockTeleporter = false
end)

AddEventHandler("onMultiplePress", function(keys)
	if keys["lshift"] and keys["g"] and (not isTackling and GetGameTimer() - lastTackleTime > 10 * 1000 and jobs[ESX.PlayerData.job.name] and not ESX.isDead()) and SUN.CurrentWeaponModel == `weapon_unarmed` and not LocalPlayer.state.teleporting then
		local closestPlayer, distance = ESX.Game.GetClosestPlayer()
		local carrying = ESX.GetPlayerData().robbing == 1
		local job = ESX.GetPlayerState(GetPlayerServerId(closestPlayer), 'job')
		local targetSrc = GetPlayerServerId(closestPlayer)
		if distance ~= -1 and distance <= 3 and not carrying and not isTackling and not isGettingTackled and not IsPedInAnyVehicle(PlayerPedId()) and not IsPedInAnyVehicle(GetPlayerPed(closestPlayer)) and (not job or not ESX.militaryJobs2[ESX.GetPlayerState(GetPlayerServerId(closestPlayer), 'job')]) and not ESX.isDead(targetSrc) then
			isTackling = true
			lastTackleTime = GetGameTimer()
			LocalPlayer.state.blockTeleporter = true
			ESX.TriggerServerEvent('tackle:tryTackle', GetPlayerServerId(closestPlayer))
		end
	end
end)