-- Pub by FleeX Team , https://discord.gg/87rGBxgCsa

ESX = nil
world = 0
worldPVPThread = false
local timing, isPlayerWhitelisted = math.ceil(Config.Timer * 60000), false
local streetName, playerGender
local disable = true

AddEventHandler('outlaw:state', function(state)
	disable = state
end)

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end

	while ESX.GetPlayerData().job == nil do
		Citizen.Wait(10)
	end

	ESX.PlayerData = ESX.GetPlayerData()

	TriggerEvent('skinchanger:getSkin', function(skin)
		playerGender = skin.sex
	end)

	isPlayerWhitelisted = refreshPlayerWhitelisted()
end)

RegisterNetEvent('esx:changeworld')
AddEventHandler('esx:changeworld',function(_)
	world = _
	if world == 97 then
		if not worldPVPThread then
			worldPVPThread = true
			Citizen.CreateThread(function()
				while worldPVPThread do
					local players = #ESX.Game.GetPlayersInArea(GetEntityCoords(PlayerPedId()),150)
					local havePVP = false
					for k,v in ipairs(ESX.GetPlayerData().loadout) do
						if (v.metadata and v.metadata.serial and v.metadata.serial:find('PV')) then
							havePVP = true
						end
					end
					if players >= 10 or havePVP then
						TriggerServerEvent('esx_outlawalert:imHere')
					end
					Citizen.Wait(10000)
				end
			end)
		end
	else
		worldPVPThread = false
	end
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
	ESX.PlayerData.job = job

	isPlayerWhitelisted = refreshPlayerWhitelisted()
end)

function Alert(alert)
	if isPlayerWhitelisted then
		ESX.ShowNotification(alert)
	end
end

RegisterNetEvent('esx_outlawalert:outlawNotify2')
AddEventHandler('esx_outlawalert:outlawNotify2', function(alert)
	if ESX.GetPlayerData().World == 97 then
		ESX.ShowNotification(alert)
	end
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(3000)

		local playerCoords = GetEntityCoords(PlayerPedId())
		streetName,_ = GetStreetNameAtCoord(playerCoords.x, playerCoords.y, playerCoords.z)
		streetName = GetStreetNameFromHashKey(streetName)
	end
end)

AddEventHandler('skinchanger:loadSkin', function(character)
	playerGender = character.sex
end)

function refreshPlayerWhitelisted()
	if not ESX.PlayerData then
		return false
	end

	if not ESX.PlayerData.job then
		return false
	end

	for k,v in ipairs(Config.WhitelistedCops) do
		if v == ESX.PlayerData.job.name then
			return true
		end
	end

	return false
end

RegisterNetEvent('esx_outlawalert:gunshotInProgress')
AddEventHandler('esx_outlawalert:gunshotInProgress', function(targetCoords,text)
	if isPlayerWhitelisted and Config.GunshotAlert then
		Alert(text)
		local alpha = 250
		local gunshotBlip = AddBlipForRadius(targetCoords.x, targetCoords.y, targetCoords.z, Config.BlipGunRadius)

		SetBlipHighDetail(gunshotBlip, true)
		SetBlipColour(gunshotBlip, 1)
		SetBlipAlpha(gunshotBlip, alpha)
		SetBlipAsShortRange(gunshotBlip, true)

		while alpha ~= 0 do
			Citizen.Wait(Config.BlipGunTime * 4)
			alpha = alpha - 1
			SetBlipAlpha(gunshotBlip, alpha)

			if alpha == 0 then
				RemoveBlip(gunshotBlip)
				return
			end
		end
	end
end)

RegisterNetEvent('esx_outlawalert:pvpAlert')
AddEventHandler('esx_outlawalert:pvpAlert', function(data)
	if ESX.GetPlayerData().World == 97 then
		for k,targetCoords in pairs(data) do
			local alpha = 200
			local gunshotBlip = AddBlipForRadius(targetCoords.x, targetCoords.y, targetCoords.z, 150.0)

			SetBlipHighDetail(gunshotBlip, true)
			SetBlipColour(gunshotBlip, 1)
			SetBlipAlpha(gunshotBlip, alpha)
			SetBlipAsShortRange(gunshotBlip, true)
			Citizen.CreateThread(function()
				while alpha ~= 0 do
					Citizen.Wait(Config.BlipGunTime * 4)
					alpha = alpha - 1
					SetBlipAlpha(gunshotBlip, alpha)

					if alpha == 0 then
						RemoveBlip(gunshotBlip)
						return
					end
				end
			end)
		end
	end
end)

RegisterNetEvent('esx_outlawalert:combatInProgress')
AddEventHandler('esx_outlawalert:combatInProgress', function(targetCoords,text)
	if isPlayerWhitelisted and Config.MeleeAlert then
		Alert(text)
		local alpha = 250
		local meleeBlip = AddBlipForRadius(targetCoords.x, targetCoords.y, targetCoords.z, Config.BlipMeleeRadius)

		SetBlipHighDetail(meleeBlip, true)
		SetBlipColour(meleeBlip, 17)
		SetBlipAlpha(meleeBlip, alpha)
		SetBlipAsShortRange(meleeBlip, true)

		while alpha ~= 0 do
			Citizen.Wait(Config.BlipMeleeTime * 4)
			alpha = alpha - 1
			SetBlipAlpha(meleeBlip, alpha)

			if alpha == 0 then
				RemoveBlip(meleeBlip)
				return
			end
		end
	end
end)

local sendCD = false
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(100)

		local playerPed = PlayerPedId()
		local playerCoords = GetEntityCoords(playerPed)
		-- is jackin'
		if not disable then
			if IsPedInMeleeCombat(playerPed) and Config.MeleeAlert and not sendCD and world == 0 then

				Citizen.Wait(100)

				if (isPlayerWhitelisted and Config.ShowCopsMisbehave) or not isPlayerWhitelisted then
					sendCD = true
					Citizen.SetTimeout(20000,function()
						sendCD = false
					end)
					TriggerServerEvent('esx_outlawalert:combatInProgress', {
						x = ESX.Math.Round(playerCoords.x, 1),
						y = ESX.Math.Round(playerCoords.y, 1),
						z = ESX.Math.Round(playerCoords.z, 1)
					}, streetName, playerGender,ESX.Game.GetPlayersToSend(400))
				end

			elseif IsPedShooting(playerPed) and not IsPedCurrentWeaponSilenced(playerPed) and Config.GunshotAlert and not sendCD and world == 0 then

				Citizen.Wait(100)

				if (isPlayerWhitelisted and Config.ShowCopsMisbehave) or not isPlayerWhitelisted then
					sendCD = true
					Citizen.SetTimeout(20000,function()
						sendCD = false
					end)
					TriggerServerEvent('esx_outlawalert:gunshotInProgress', {
						x = ESX.Math.Round(playerCoords.x, 1),
						y = ESX.Math.Round(playerCoords.y, 1),
						z = ESX.Math.Round(playerCoords.z, 1)
					}, streetName, playerGender,ESX.Game.GetPlayersToSend(400))
				end

			end
		end
	end
end)