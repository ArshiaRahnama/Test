-- Pub by FleeX Team , https://discord.gg/87rGBxgCsa

local deathId = 1
Citizen.CreateThread(function()

	while true do
		Wait(0)

		local player = PlayerId()

		local playerPed = PlayerPedId()

		if IsEntityDead(PlayerPedId()) then
			local killer, killerWeapon = NetworkGetEntityKillerOfPlayer(player)
			local killerServerId = NetworkGetPlayerIndexFromPed(killer)
			deathId = deathId + 1
			if killer ~= playerPed and killerServerId ~= nil and NetworkIsPlayerActive(killerServerId) then
				PlayerKilledByPlayer(GetPlayerServerId(killerServerId), killerServerId, killerWeapon)
			else
				PlayerKilled()
			end
		end
		while IsEntityDead(PlayerPedId()) do
			Wait(0)
		end
	end
end)

function PlayerKilledByPlayer(killerServerId, killerClientId, killerWeapon)
	local victimCoords = GetEntityCoords(PlayerPedId())
	local killerCoords = GetEntityCoords(GetPlayerPed(killerClientId))
	local distance     = #(victimCoords - killerCoords)
	local headshot = false
	local _, outbone = GetPedLastDamageBone(PlayerPedId())
	if outbone == 31086 then headshot = true end

	local data = {
		victimCoords = { x = ESX.Math.Round(victimCoords.x, 1), y = ESX.Math.Round(victimCoords.y, 1), z = ESX.Math.Round(victimCoords.z, 1) },
		killerCoords = { x = ESX.Math.Round(killerCoords.x, 1), y = ESX.Math.Round(killerCoords.y, 1), z = ESX.Math.Round(killerCoords.z, 1) },

		killedByPlayer = true,
		deathCause     = killerWeapon,
		distance       = ESX.Math.Round(distance, 1),

		killerServerId = killerServerId,
		killerClientId = killerClientId,
		headshot = headshot,
		deathId = deathId,
		weapon = ESX.GetWeaponFromHash(killerWeapon),
		inWhiteListCoords = exports['sunset_utils']:inWhiteListCoords()
	}

	TriggerEvent('esx:onPlayerDeath', data)
	TriggerServerEvent('esx:onPlayerDeath', data)
	ESX.TriggerServerEvent('core:onPlayerDeath', data)
end

function PlayerKilled()
	local playerPed = PlayerPedId()
	local victimCoords = GetEntityCoords(PlayerPedId())

	local data = {
		victimCoords = { x = ESX.Math.Round(victimCoords.x, 1), y = ESX.Math.Round(victimCoords.y, 1), z = ESX.Math.Round(victimCoords.z, 1) },

		killedByPlayer = false,
		deathCause     = GetPedCauseOfDeath(playerPed),
		headshot = false,
		deathId = deathId,
	}

	TriggerEvent('esx:onPlayerDeath', data)
	TriggerServerEvent('esx:onPlayerDeath', data)
	ESX.TriggerServerEvent('core:onPlayerDeath', data)
end