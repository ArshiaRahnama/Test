-- Pub by FleeX Team , https://discord.gg/87rGBxgCsa

local isTaz = false

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(1000)
		
		if IsPedBeingStunned(GetPlayerPed(-1)) then
			exports['essentialmode']:disablecontrol('x',true)
			SetPedToRagdoll(GetPlayerPed(-1), 5000, 5000, 0, 0, 0, 0)
			DisableActionTZ()
			
		end
		
		if IsPedBeingStunned(GetPlayerPed(-1)) and not isTaz then
			
			isTaz = true
			TriggerEvent('core:applyScreenEffect', 'REDMIST_blend', 1.0, 10)
			ShakeGameplayCam("FAMILY5_DRUG_TRIP_SHAKE", 1.0)
			
		elseif not IsPedBeingStunned(GetPlayerPed(-1)) and isTaz then
			isTaz = false
			Wait(5000)
			if ESX.GetPlayerData().HandCuffed == 1 then
				RequestAnimDict("mp_arresting")
				while not HasAnimDictLoaded( "mp_arresting") do
					Citizen.Wait(1)
				end
				TaskPlayAnim(GetPlayerPed(-1), 'mp_arresting', 'idle', 8.0, -8, -1, 49, 0.0, false, false, false)
			end

			TriggerEvent('core:applyScreenEffect', 'hud_def_desat_Trevor', 1.0, 10)
			
			Wait(10000)
			exports['essentialmode']:disablecontrol('x',false)
			TriggerEvent('core:applyScreenEffect', 'hud_def_desat_Trevor')
			TriggerEvent('core:applyScreenEffect', 'REDMIST_blend')
			StopGameplayCamShaking()
		end
	end
end)

AddEventHandler('esx:onPlayerDeath', function(data)
	DisableActionTZ()
end)


function DisableActionTZ()
	if lib.progressActive() then
		lib.cancelProgress()
	end
	TriggerEvent("mythic_progbar:client:cancel")
	if lib.progressActive() then
		lib.cancelProgress()
	end
end