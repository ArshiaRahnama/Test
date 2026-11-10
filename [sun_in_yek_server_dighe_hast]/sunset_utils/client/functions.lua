-- Pub by FleeX Team , https://discord.gg/87rGBxgCsa

function setVehicleDoorState(vehicle, index, open)
	if DoesEntityExist(vehicle) then
		if NetworkHasControlOfEntity(vehicle) then
			if open then
				SetVehicleDoorOpen(vehicle, index)
			else
				SetVehicleDoorShut(vehicle, index)
			end
		else
			local netId = NetworkGetNetworkIdFromEntity(vehicle)
			TriggerServerEvent('sunset_utils:setVehicleDoorState', netId, index, open,ESX.GetPlayersToSend(300))
		end
	end
end
exports('setVehicleDoorState',setVehicleDoorState)

RegisterNetEvent('sunset_utils:setVehicleDoorStateClient')
AddEventHandler('sunset_utils:setVehicleDoorStatelient', function(netId, index, open)
	if not tonumber(netId) then
		return
	end
	local vehicle = NetworkGetEntityFromNetworkId(netId)
	if DoesEntityExist(vehicle) then
		if open then
			SetVehicleDoorOpen(vehicle, index)
		else
			SetVehicleDoorShut(vehicle, index)
		end
	end
end)

function waitForLoad(wait)
	while ESX == nil or SUN.PlayerCoords == nil or lib == nil or ESX.PlayerData == nil or ESX.PlayerData.job == nil do Citizen.Wait(0) end
	Wait(wait or 0)
end

function disableFiring()
	DisablePlayerFiring(SUN.PlayerId,true)
	DisableControlAction(0,24,true) -- disable attack
	DisableControlAction(0,47,true) -- disable weapon
	DisableControlAction(0,58,true) -- disable weapon
	DisableControlAction(0,263,true) -- disable melee
	DisableControlAction(0,264,true) -- disable melee
	DisableControlAction(0,257,true) -- disable melee
	DisableControlAction(0,140,true) -- disable melee
	DisableControlAction(0,141,true) -- disable melee
	DisableControlAction(0,142,true) -- disable melee
	DisableControlAction(0,143,true) -- disable melee
	DisableControlAction(0, 45, true)
	DisableControlAction(0, 69, true) -- Melee Attack 1
	DisableControlAction(0, 70, true)
	DisableControlAction(0, 92, true)
end

exports('disableFiring',disableFiring)

local localPeds = {}
local localPedId = 0
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(2000)

		local coords = GetEntityCoords(PlayerPedId())

		for k, ped in pairs(localPeds) do
			local distance = #(coords - vector3(ped.x, ped.y, ped.z))

			if distance > Config.NPCSpawnDistance then
				if DoesEntityExist(ped.ped) then
					DeleteEntity(ped.ped)
				end
			else
				if not DoesEntityExist(ped.ped) then
                    ESX.Streaming.RequestModel(ped.modelHash)
					ped.ped = CreatePed(ped.pedType, ped.modelHash, ped.x, ped.y, ped.z, ped.heading, ped.isNetwork, ped.netMissionEntity)
                    SetModelAsNoLongerNeeded(ped.modelHash)
					if ped.cb then
                        Citizen.CreateThreadNow(function()
                            ped.cb(ped.ped)
                        end)
					end
				end
			end
			Citizen.Wait(0)
		end
	end
end)

function createLocalPed(pedType, modelHash, coords, cb, removeCb) -- cb to call on ped
	for k, ped in pairs(localPeds) do
		if ped.x == x and ped.y == y and ped.z == z then
			print('Ped already spawned')
			return
		end
	end
	localPedId = localPedId + 1
	table.insert(localPeds, {pedType=pedType, modelHash=modelHash, x=coords.x, y=coords.y, z=coords.z, heading=coords.w, isNetwork=isNetwork, netMissionEntity=netMissionEntity, cb=cb, removeCb = removeCb, id = localPedId})
	return localPedId
end
exports('createLocalPed', createLocalPed)

function removeLocalPed(modelHash, coords)
	for i, ped in pairs(localPeds) do
		if ped.id == modelHash or (ped.modelHash == modelHash and ped.x == coords.x and ped.y == coords.y and ped.z == coords.z) then
			if DoesEntityExist(ped.ped) then
				DeleteEntity(ped.ped)
				if ped.removeCb then
					Citizen.CreateThreadNow(function()
						ped.removeCb(ped.ped)
					end)
				end
			end
			table.remove(localPeds, i)
			return
		end
	end
end
exports('removePed', removePed)