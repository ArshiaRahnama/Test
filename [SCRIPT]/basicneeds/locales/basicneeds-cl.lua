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

ESX          = nil

local IsAnimated = false

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(1)
	end
end)

AddEventHandler('esx_basicneeds:resetStatus', function()
	TriggerEvent('esx_status:setx', 'hunger', 400000)
	TriggerEvent('esx_status:setx', 'thirst', 400000)
end)

RegisterNetEvent('esx_basicneeds:healPlayer')
AddEventHandler('esx_basicneeds:healPlayer', function()

	TriggerEvent('esx_status:setx', 'hunger', 1000000)
	TriggerEvent('esx_status:setx', 'thirst', 1000000)


	local playerPed = PlayerPedId()
	SetEntityHealth(playerPed, 200)
end)

local thread = false
AddEventHandler('esx_status:loaded', function(status)

	TriggerEvent('esx_status:registerStatus', 'hunger', 1000000, '#CFAD0F', function(status)
		return true
	end, function(status)
		if not ESX.GetPlayerData().aduty then
			status.remove(150)
		end
	end)

	TriggerEvent('esx_status:registerStatus', 'thirst', 1000000, '#0C98F1', function(status)
		return true
	end, function(status)
		if not ESX.GetPlayerData().aduty then
			status.remove(65)
		end
	end)

	Citizen.CreateThread(function()
		while true do
			Citizen.Wait(1000)

			local playerPed  = PlayerPedId()
			local prevHealth = GetEntityHealth(playerPed)
			local health     = prevHealth

			TriggerEvent('esx_status:getStatus', 'hunger', function(status)
				if status.val == 0 then
					if prevHealth <= 150 then
						health = health - 2
					else
						health = health - 3
					end
				end
			end)

			TriggerEvent('esx_status:getStatus', 'thirst', function(status)
				if status.val == 0 then
					if prevHealth <= 150 then
						health = health - 2
					else
						health = health - 3
					end
				end
			end)

			if health ~= prevHealth then
				if not thread then
					thread = true
					Citizen.CreateThread(function()
						while thread do
							Wait(10)
							DisableControlAction(0, 24, true)
							SetWalk('move_m@drunk@verydrunk')
							if IsControlJustPressed(0, 69) then
								SetPedToRagdoll(PlayerPedId(), 5000, 0, 0, 0, 0, 0)
							end
							if IsPedJumping(PlayerPedId()) then
								SetPedToRagdoll(PlayerPedId(), 5000, 0, 0, 0, 0, 0)
							end
							if IsControlJustPressed(0, 24) then
								SetPedToRagdoll(PlayerPedId(), 5000, 0, 0, 0, 0, 0)
							end
							if IsControlJustPressed(0, 25) then
								SetPedToRagdoll(PlayerPedId(), 5000, 0, 0, 0, 0, 0)
							end
						end
					end)
				end
			elseif thread then
				thread = false
				Wait(100)
				ResetPedMovementClipset(PlayerPedId())
			end
		end
	end)
end)

function SetWalk(name)
  RequestWalking(name)
  SetPedMovementClipset(PlayerPedId(), name, 0.2)
  RemoveAnimSet(name)
end

function RequestWalking(set)
  RequestAnimSet(set)
  while not HasAnimSetLoaded(set) do
    Citizen.Wait(1)
  end
end

AddEventHandler('esx_basicneeds:isEating', function(cb)
	cb(IsAnimated)
end)

RegisterNetEvent('esx_basicneeds:onEat')
AddEventHandler('esx_basicneeds:onEat', function(prop_name)
	if not IsAnimated then
		prop_name = prop_name or 'prop_cs_burger_01'
		IsAnimated = true

		Citizen.CreateThread(function()
			local playerPed = PlayerPedId()
			local x,y,z = table.unpack(GetEntityCoords(playerPed))
			local prop = CreateObject(GetHashKey(prop_name), x, y, z + 0.2, true, true, true)
			local boneIndex = GetPedBoneIndex(playerPed, 18905)
			AttachEntityToEntity(prop, playerPed, boneIndex, 0.12, 0.028, 0.001, 10.0, 175.0, 0.0, true, true, false, true, 1, true)

			ESX.Streaming.RequestAnimDict('mp_player_inteat@burger', function()
				TaskPlayAnim(playerPed, 'mp_player_inteat@burger', 'mp_player_int_eat_burger_fp', 8.0, -8, -1, 49, 0, 0, 0, 0)

				Citizen.Wait(3000)
				IsAnimated = false
				ClearPedSecondaryTask(playerPed)
				DeleteObject(prop)
			end)
		end)

	end
end)

RegisterNetEvent('esx_basicneeds:onDrink')
AddEventHandler('esx_basicneeds:onDrink', function(prop_name)
	if not IsAnimated then
		prop_name = prop_name or 'prop_ld_flow_bottle'
		IsAnimated = true

		Citizen.CreateThread(function()
			local playerPed = PlayerPedId()
			local x,y,z = table.unpack(GetEntityCoords(playerPed))
			local prop = CreateObject(GetHashKey(prop_name), x, y, z + 0.2, true, true, true)
			local boneIndex = GetPedBoneIndex(playerPed, 18905)
			AttachEntityToEntity(prop, playerPed, boneIndex, 0.12, 0.028, 0.001, 10.0, 175.0, 0.0, true, true, false, true, 1, true)

			ESX.Streaming.RequestAnimDict('mp_player_intdrink', function()
				TaskPlayAnim(playerPed, 'mp_player_intdrink', 'loop_bottle', 1.0, -1.0, 2000, 0, 1, true, true, true)

				Citizen.Wait(3000)
				IsAnimated = false
				ClearPedSecondaryTask(playerPed)
				DeleteObject(prop)
			end)
		end)

	end
end)