-- Pub by FleeX Team , https://discord.gg/87rGBxgCsa

local plateModel = "prop_fib_badge"
local animDict = "missfbi_s4mop"
local animName = "swipe_card"
local plate_net = nil
local block = false

RegisterCommand('badge', function()
	if block then return ESX.Alert('Spam','Lotan spam nakonid',7000,'warning') end
	block = true
	if ESX.GetPlayerData().job.name ~= 'nojob' then
		if GetVehiclePedIsIn(PlayerPedId()) == 0 then
			TriggerEvent('badge:open')
			TriggerServerEvent('badge:show',ESX.Game.GetPlayersToSend(5))
		else
			ESX.ShowNotification('Shoma nemitavanid savar mashin in cmd ra estefade konid')
		end
	else
		ESX.Alert('Error','Shoma nemitavanid az in cmd estefade konid',7000,'error')
		block = false
	end
end, false)

RegisterCommand('bcsd', function()
	if block then return ESX.Alert('Spam','Lotan spam nakonid',7000,'warning') end
	block = true
	if ESX.GetPlayerData().job.name ~= 'nojob' then
		if GetVehiclePedIsIn(PlayerPedId()) == 0 then
			TriggerEvent('badge:open')
			TriggerServerEvent('badge:show',ESX.Game.GetPlayersToSend(5))
		else
			ESX.ShowNotification('Shoma nemitavanid savar mashin in cmd ra estefade konid')
		end
	else
		ESX.Alert('Error','Shoma nemitavanid az in cmd estefade konid',7000,'error')
		block = false
	end
end, false)

TriggerEvent('chat:addSuggestion', '/badge', 'Show badge(only GOV job)', {
})

function startAnim()
    RequestModel(GetHashKey(plateModel))
    while not HasModelLoaded(GetHashKey(plateModel)) do
        Citizen.Wait(100)
    end
	ClearPedSecondaryTask(PlayerPedId())
	RequestAnimDict(animDict)
    while not HasAnimDictLoaded(animDict) do
        Citizen.Wait(100)
    end
    local playerPed = PlayerPedId()
    local plyCoords = GetOffsetFromEntityInWorldCoords(playerPed, 0.0, 0.0, -5.0)
	ESX.Game.SpawnObject(plateModel,vector3(plyCoords.x, plyCoords.y, plyCoords.z),function(obj)
		local platespawned = obj
		Citizen.Wait(1000)
		local netid = ObjToNet(platespawned)
		SetNetworkIdExistsOnAllMachines(netid, true)
		SetNetworkIdCanMigrate(netid, false)
		TaskPlayAnim(playerPed, animDict, animName, 1.0, 1.0, -1, 50, 0, false, false, false)
		Citizen.Wait(800)
		AttachEntityToEntity(platespawned, playerPed, GetPedBoneIndex(playerPed, 28422), 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1, 1, 0, 1, 0, 1)
		plate_net = netid
		Citizen.Wait(3000)
		ClearPedSecondaryTask(playerPed)
		DetachEntity(NetToObj(plate_net), 1, 1)
		ESX.Game.DeleteObject(platespawned)
		plate_net = nil
		Wait(1000)
		block = false
	end)
end

RegisterNetEvent('badge:open')
AddEventHandler('badge:open', function()
	startAnim()
end)

RegisterNetEvent('badge:show')
AddEventHandler('badge:show', function(data)
	if not ESX.Game.PlayerExist(data.source) then return end
	if ESX.GetDistance(GetEntityCoords(PlayerPedId()),GetEntityCoords(GetPlayerPed(GetPlayerFromServerId(data.source)))) > 10 then return end
	TriggerEvent('chatMessage', "", {255, 0, 0}, "^4^*Cart Shenasaei:^0 "  .. string.gsub(data.name, "_", " "))
	TriggerEvent('chatMessage', "", {255, 0, 0}, "^4 Job : ^1".. data.job.label)
	TriggerEvent('chatMessage', "", {255, 0, 0}, "^4 Job grade : ^1".. data.job.grade_label)
end)