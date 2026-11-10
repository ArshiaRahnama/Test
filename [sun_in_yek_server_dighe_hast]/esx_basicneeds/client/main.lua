-- Pub by FleeX Team , https://discord.gg/87rGBxgCsa

ESX          = nil
local IsDead = false
local IsAnimated = false

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end
end)

AddEventHandler('esx_basicneeds:resetStatus', function()
	TriggerEvent('esx_status:setss', 'hunger', 500000)
	TriggerEvent('esx_status:setss', 'thirst', 500000)
end)

RegisterCommand('lowme',function()
	if ESX.GetPlayerData().permission_level >= 20 then
		TriggerEvent('esx_status:setss', 'hunger', 500)
		TriggerEvent('esx_status:setss', 'thirst', 500)
	end
end, false)

RegisterNetEvent('esx_basicneeds:healPlayer')
AddEventHandler('esx_basicneeds:healPlayer', function()
	-- restore hunger & thirst
	TriggerEvent('esx_status:setss', 'hunger', 1000000)
	TriggerEvent('esx_status:setss', 'thirst', 1000000)

	-- restore hp
	local playerPed = PlayerPedId()
	ESX.SetEntityHealth(playerPed, GetEntityMaxHealth(playerPed))
end)

RegisterNetEvent('esx_basicneeds:healPlayerrange')
AddEventHandler('esx_basicneeds:healPlayerrange', function(id,range)
    if id == nil or range == nil then return end
	if not ESX.Game.PlayerExist(id) then return end
	local coords1 = GetEntityCoords(GetPlayerPed(-1))
	local coords2 = GetEntityCoords(GetPlayerPed(GetPlayerFromServerId(id)))
	if GetDistanceBetweenCoords(coords1.x,coords1.y,coords1.z,coords2.x,coords2.y,coords2.z) < range then
	-- restore hunger & thirst
	TriggerEvent('esx_status:setss', 'hunger', 1000000)
	TriggerEvent('esx_status:setss', 'thirst', 1000000)
   -- TriggerEvent('chat:addMessage', { args = { '^5HEAL', 'You have been healed.' }}
	-- restore hp
	local playerPed = PlayerPedId()
	ESX.SetEntityHealth(playerPed, GetEntityMaxHealth(playerPed))
	end
end)

AddEventHandler('esx:onPlayerDeath', function()
	IsDead = true
end)

AddEventHandler('playerSpawned', function(spawn)
	if IsDead then
		TriggerEvent('esx_basicneeds:resetStatus')
	end

	IsDead = false
end)
local thread = false

exports('isStarving', function()
	return thread
end)

function dpemote(state)
	TriggerEvent("dpemote:enable",state)
end
AddEventHandler('esx_status:loaded', function(status)

	TriggerEvent('esx_status:registerStatus', 'hunger', 1000000, '#CFAD0F', function(status)
		return true
	end, function(status)
		status.remove(500)
	end)

	TriggerEvent('esx_status:registerStatus', 'thirst', 1000000, '#0C98F1', function(status)
		return true
	end, function(status)
		status.remove(375)
	end)
	--TriggerEvent('esx_status:registerStatus', 'armor', 0, '#CFAD0F')
	--TriggerEvent('esx_status:registerStatus', 'health', 200, '#CFAD0F')
	Citizen.CreateThread(function()
		while true do
			Citizen.Wait(1000)

			local playerPed  = PlayerPedId()
			local prevHealth = GetEntityHealth(playerPed)
			local health     = prevHealth

			TriggerEvent('esx_status:getStatus', 'hunger', function(status)
				if status.val == 0 then
					if prevHealth <= 150 then
						health = health - 5
					else
						health = health - 1
					end
				end
			end)

			TriggerEvent('esx_status:getStatus', 'thirst', function(status)
				if status.val == 0 then
					if prevHealth <= 150 then
						health = health - 5
					else
						health = health - 1
					end
				end
			end)

			if health ~= prevHealth then
				if not thread then
					thread = true
					Citizen.CreateThread(function()
						while thread do
							Wait(100)
							exports['sun-animmenu']:Walk('Drunk3')
							--dpemote(false)
						end
					end)
				end
			elseif thread then
				thread = false
				Wait(1000)
				ResetPedMovementClipset(PlayerPedId())
				--dpemote(true)
			end
		end
	end)
end)

AddEventHandler('esx_basicneeds:isEating', function(cb)
	cb(IsAnimated)
end)

RegisterNetEvent('esx_basicneeds:onEat')
AddEventHandler('esx_basicneeds:onEat', function(prop_name, progBar, disableAnim)
	LocalPlayer.state.disableAnim = true
	if ESX.isDead() then return end
	if progBar then
		ESX.progressCircle(10000)
	end
	if not IsAnimated and not disableAnim then
		prop_name = prop_name or 'prop_cs_burger_01'
		IsAnimated = true

		Citizen.CreateThread(function()
			local playerPed = PlayerPedId()
			local x,y,z = table.unpack(GetEntityCoords(playerPed))
			ESX.Game.SpawnObject(prop_name, {
				x = x,
				y = y,
				z = z + 0.2
			}, function(obj)
				local prop = obj
				local boneIndex = GetPedBoneIndex(playerPed, 18905)
				AttachEntityToEntity(prop, playerPed, boneIndex, 0.12, 0.028, 0.001, 10.0, 175.0, 0.0, true, true, false, true, 1, true)
	
				ESX.Streaming.RequestAnimDict('mp_player_inteat@burger', function()
					TaskPlayAnim(playerPed, 'mp_player_inteat@burger', 'mp_player_int_eat_burger_fp', 8.0, -8, -1, 49, 0, 0, 0, 0)
	
					Citizen.Wait(10000)
					IsAnimated = false
					-- ClearPedSecondaryTask(playerPed)
					StopAnimTask(playerPed, 'mp_player_inteat', 'mp_player_int_eat_burger_fp', 1.0)
					DeleteObject(prop)
					LocalPlayer.state.disableAnim = nil
				end)
			end)
		end)

	end
end)

RegisterNetEvent('esx_basicneeds:onDrink')
AddEventHandler('esx_basicneeds:onDrink', function(prop_name)
	if not IsAnimated then
		if ESX.isDead() then return end
		prop_name = prop_name or 'prop_ld_flow_bottle'
		IsAnimated = true

		Citizen.CreateThread(function()
			local playerPed = PlayerPedId()
			local x,y,z = table.unpack(GetEntityCoords(playerPed))
			ESX.Game.SpawnObject(prop_name, {
					x = x,
					y = y,
					z = z + 0.2
				}, function(obj)
				local prop = obj
				local boneIndex = GetPedBoneIndex(playerPed, 18905)
				AttachEntityToEntity(prop, playerPed, boneIndex, 0.12, 0.028, 0.001, 10.0, 175.0, 0.0, true, true, false, true, 1, true)

			ESX.Streaming.RequestAnimDict('mp_player_intdrink', function()
				TaskPlayAnim(playerPed, 'mp_player_intdrink', 'loop_bottle', 1.0, -1.0, 2000, 0, 1, true, true, true)

				Citizen.Wait(3000)
				IsAnimated = false
				-- ClearPedSecondaryTask(playerPed)
				StopAnimTask(playerPed, 'mp_player_intdrink', 'loop_bottle', 1.0)
				DeleteObject(prop)
			end)	
		end)	
		end)

	end
end)

local lowFoodActive = false

function lowFoodFunc()
    if lowFoodActive or ESX.isDead() then return end
    local low = false
    TriggerEvent('esx_status:getStatus', 'hunger', function(status)
        if status.val == 0 then low = true end
    end)
    TriggerEvent('esx_status:getStatus', 'thirst', function(status)
        if status.val == 0 then low = true end
    end)
    if low then
        lowFoodActive = true
        LocalPlayer.state.lowFood = true
        Wait(200)
        exports['suncore']:canRagdoll(true, 9000)
        SetPedToRagdoll(PlayerPedId(), 10000, 10000, 0, 0, 0, 0)
        Wait(10000)
        LocalPlayer.state.lowFood = nil
        lowFoodActive = false
    end
end

AddEventHandler('KeyDown:space', lowFoodFunc)
AddEventHandler('KeyDown:mouse_left', lowFoodFunc)
AddEventHandler('KeyDown:mouse_right', lowFoodFunc)