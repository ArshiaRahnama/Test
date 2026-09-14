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

ESX = nil
local PlayerData = nil
Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent("esx:getSharedObject", function(obj) ESX = obj end)
		Citizen.Wait(0)
    end

	while ESX.GetPlayerData().job == nil do
		Citizen.Wait(50)
	end
	Citizen.Wait(500)

	PlayerData = ESX.GetPlayerData()


end)

status = {}

carry = {
	Requested = false,
	InProgress = false,
	targetSrc = -1,
	type = "",
	personCarrying = {
		animDict = "missfinale_c2mcs_1",
		anim = "fin_c2_mcs_1_camman",
		flag = 49,
	},
	personCarried = {
		animDict = "nm",
		anim = "firemans_carry",
		attachX = 0.27,
		attachY = 0.15,
		attachZ = 0.63,
		flag = 33,
	}
}

local dead = 0
local disablecarryanim  = false

local function GetClosestPlayer(radius)
    local players = GetActivePlayers()
    local closestDistance = -1
    local closestPlayer = -1
    local playerPed = PlayerPedId()
    local playerCoords = GetEntityCoords(playerPed)

    for _,playerId in ipairs(players) do
        local targetPed = GetPlayerPed(playerId)
        if targetPed ~= playerPed then
            local targetCoords = GetEntityCoords(targetPed)
            local distance = #(targetCoords-playerCoords)
            if closestDistance == -1 or closestDistance > distance then
                closestPlayer = playerId
                closestDistance = distance
            end
        end
    end
	if closestDistance ~= -1 and closestDistance <= radius then
		return closestPlayer
	else
		return nil
	end
end

local function ensureAnimDict(animDict)
    if not HasAnimDictLoaded(animDict) then
        RequestAnimDict(animDict)
        while not HasAnimDictLoaded(animDict) do
            Wait(500)
        end
    end
    return animDict
end

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)

    PlayerData.job = job


end)

RegisterNetEvent("citizen:cl_stop")
AddEventHandler("citizen:cl_stop", function()
	carry.InProgress = false
	ClearPedSecondaryTask(PlayerPedId())
	DetachEntity(PlayerPedId(), true, false)
end)

function dragthread()
	Citizen.CreateThread(function()
		while carry.InProgress do

			if IsPedInAnyVehicle(PlayerPedId(), false) then

				TaskLeaveAnyVehicle(PlayerPedId(), true, true)
			end

			if carry.type == "beingcarried" and not disablecarryanim then
				if not IsEntityPlayingAnim(PlayerPedId(), carry.personCarried.animDict, carry.personCarried.anim, 3) then
					TaskPlayAnim(PlayerPedId(), carry.personCarried.animDict, carry.personCarried.anim, 8.0, -8.0, 100000, carry.personCarried.flag, 0, false, false, false)
				end
			elseif carry.type == "carrying" and not disablecarryanim then
				if not IsEntityPlayingAnim(PlayerPedId(), carry.personCarrying.animDict, carry.personCarrying.anim, 3) then
					TaskPlayAnim(PlayerPedId(), carry.personCarrying.animDict, carry.personCarrying.anim, 8.0, -8.0, 100000, carry.personCarrying.flag, 0, false, false, false)
				end
				local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
				if GetPedInVehicleSeat(vehicle, -1) == PlayerPedId() and carry.InProgress == true then
					local closestPlayer = GetClosestPlayer(3)
					local targetSrc = GetPlayerServerId(closestPlayer)
					cancel = false
					disable = false
					carry.InProgress = false
					ClearPedSecondaryTask(PlayerPedId())
					DetachEntity(PlayerPedId(), true, false)
					carry.targetSrc = 0
					status.dragingid = nil
					TriggerServerEvent('citizen:stopcarry', targetSrc)
				end
			end
			DisableControlAction(0, 45, true)
			DisableControlAction(0, 24, true)
			DisableControlAction(0, 257, true)
			DisableControlAction(0, 25, true)
			DisableControlAction(0, 47, true)
			DisableControlAction(0, 264, true)
			DisableControlAction(0, 257, true)
			DisableControlAction(0, 140, true)
			DisableControlAction(0, 141, true)
			DisableControlAction(0, 142, true)
			DisableControlAction(0, 143, true)
			DisableControlAction(0, 263, true)
			DisableControlAction(0, 170, true)
			DisableControlAction(0, 23, true)
			DisableControlAction(0, Keys["LEFTSHIFT"], true)
			SetCurrentPedWeapon(PlayerPedId(),GetHashKey('WEAPON_UNARMED'))
			Wait(5)
		end
	end)
end

RegisterNetEvent("citizen:syncTarget")
AddEventHandler("citizen:syncTarget", function(targetSrc)
	local targetPed = GetPlayerPed(GetPlayerFromServerId(targetSrc))
	carry.InProgress = true
	ensureAnimDict(carry.personCarried.animDict)
	AttachEntityToEntity(PlayerPedId(), targetPed, 0, carry.personCarried.attachX, carry.personCarried.attachY, carry.personCarried.attachZ, 0.5, 0.5, 180, false, false, false, false, 2, false)
	carry.type = "beingcarried"
	dragthread()
end)

PlayerExist = function(src)
    local Players = GetActivePlayers()
    for k,v in pairs(Players) do
        if GetPlayerServerId(v) == src then
            return true
        end
	end
    return false
end

RegisterNetEvent('carry:SendRequest')
AddEventHandler('carry:SendRequest', function(playerid)

	local PlayerId = playerid
	local nojobss = true
	local targetPlayer = GetPlayerFromServerId(targetServerId)
	local targetPed = GetPlayerPed(targetPlayer)
    local targetHealth = GetEntityHealth(targetPed)
	IsPedDeadOrDying(targetPed, true)
	if PlayerNew == 0 then return end
	if not PlayerId then ESX.ShowNotification('Id Ra Vared Konid') return end

	if ESX.GetPlayerData().IsDead then
		ESX.ShowNotification('shoma Nemi Tavanin Vaghti Dead Hastid Kasi Ra Carry Konid')
		return
	end

	if carry.Requested or carry.InProgress then
		ESX.ShowNotification('shoma yek darkhast carry ersal kardid lotfan 5 sanie sabr konid')
		return
	end


	target = PlayerId

	if not PlayerExist(target) then
		ESX.ShowNotification('fard mored nazar kenar shoma nistd')
		return
	end



	local targetVeh = GetVehiclePedIsIn(GetPlayerPed(PlayerId), false)

	if targetVeh ~= 0 then
		return ESX.ShowNotification("Kasi Nazdik Shoma Nist")
	end

	local distance = #(GetEntityCoords(GetPlayerPed(GetPlayerFromServerId(PlayerId))) - GetEntityCoords(PlayerPedId()))

	if distance > 3 then
		ESX.ShowNotification('fard bayad dar 3 metri shoma bashad')
		return
	end

	if carry.InProgress == true then
		ESX.ShowNotification('Shoma Nemitaniv Dar In Halat Carry Konid!')
		return
	end

	if distance > 3 and (carry.InProgress == true) then
		ESX.ShowNotification('Shoma Nemitaniv Dar In Halat Carry Konid!')
		return
	end

	carry.Requested = true
	Citizen.SetTimeout(5000,function()
		if carry.Requested then
			carry.Requested = false
		end
	end)
	if PlayerData.job.name == 'ambulance' or PlayerData.job.name == 'police' or PlayerData.job.name == 'fbi' or PlayerData.job.name == 'sheriff' or PlayerData.job.name == 'mt' or PlayerData.job.name == 'cid' or PlayerData.job.name == 'cia' or PlayerData.job.name == 'marshal' or PlayerData.job.name == 'judge' or PlayerData.job.name == 'doa' then
		ESX.TriggerServerCallback("esx:checkInjure", function(IsDead)

			if IsDead and (PlayerData.job.name == 'ambulance' or PlayerData.job.name == 'police' or PlayerData.job.name == 'fbi' or PlayerData.job.name == 'sheriff' or PlayerData.job.name == 'mt' or PlayerData.job.name == 'cid' or PlayerData.job.name == 'cia' or PlayerData.job.name == 'marshal' or PlayerData.job.name == 'judge' or PlayerData.job.name == 'doa') then
				TriggerServerEvent('carry:sendjob', target)
			else
				ESX.ShowNotification('darkhast carry ersal shod')
				TriggerServerEvent('carry:send',target)

			end
		end, target)
	else
		ESX.ShowNotification('darkhast carry ersal shod')
		TriggerServerEvent('carry:send',target)

	end

end)

RegisterCommand('carrymdd',function(source, args)
	if not args[1] then return end
	if PlayerData.job.name == "ambulance" then
		TriggerServerEvent('carry:sendjob', tonumber(args[1]))
	end
end)

RegisterNetEvent("carry:sendtocljob")
AddEventHandler("carry:sendtocljob", function(targetSrc)



	TriggerServerEvent('carry:respone',true)
	TriggerServerEvent("citizen:syncjob", targetSrc)

end)

local showrequest = false
local targetSrc
RegisterNetEvent("carry:sendtocl")
AddEventHandler("carry:sendtocl", function(targetSrc2)
	showrequest = true
	targetSrc = targetSrc2

	Citizen.SetTimeout(20000,function()
		showrequest = false
	end)
	Citizen.CreateThread(function()
		while showrequest do
			Wait(1)
			ESX.ShowHelpNotification('Carry Accept : ~INPUT_MP_TEXT_CHAT_TEAM~ Decline : ~INPUT_CELLPHONE_CAMERA_FOCUS_LOCK~')
		end
	end)
end)

RegisterNetEvent("carry:decline")
AddEventHandler("carry:decline", function()
	carry.Requested = false
end)

RegisterNetEvent("carry:sync1")
AddEventHandler("carry:sync1", function(src, target)
	carry.InProgress = true
	dragthread()
	carry.targetSrc = src
	status.dragingid = target
	carry.Requested = false
	ensureAnimDict(carry.personCarrying.animDict)
	carry.type = "carrying"
end)

AddEventHandler('carry:cascel', function(terayto)
	carry.InProgress = terayto
end)

local cancel = false
local disable = false
AddEventHandler('onKeyDown',function(key)
	local closestPlayer = GetClosestPlayer(3)
	local targetSrc22 = GetPlayerServerId(closestPlayer)


	if showrequest then
		if key == "l" then
			showrequest = false
			TriggerServerEvent('carry:respone',false)
			TriggerServerEvent('citizen:stopcarry', targetSrc)
			carry.targetSrc = nil
		end
		if key == "y" then
			showrequest = false
			TriggerServerEvent('carry:respone',true)
			TriggerServerEvent("citizen:sync", targetSrc)
		end
	end

	if cancel then
		if key == "l" then
			cancel = false
			disable = false
			carry.InProgress = false
			ClearPedSecondaryTask(PlayerPedId())
			DetachEntity(PlayerPedId(), true, false)
			carry.targetSrc = 0
			status.dragingid = nil
			TriggerServerEvent('citizen:stopcarry', targetSrc22)
		end
	end

	if disable then
		if key == "l" then
		disable = false
		cancel = false
		carry.InProgress = false
		ClearPedSecondaryTask(PlayerPedId())
		DetachEntity(PlayerPedId(), true, false)
		carry.targetSrc = 0
		status.dragingid = nil
		TriggerServerEvent('citizen:stopcarry', targetSrc22)
		end
	end
end)

RegisterNetEvent("carry:showcancel")
AddEventHandler("carry:showcancel", function()
	cancel = true
	while carry.InProgress do
		Wait(1)
		ESX.ShowHelpNotification('Cancel carry : ~INPUT_CELLPHONE_CAMERA_FOCUS_LOCK~')
	end
end)

RegisterNetEvent("carry:showdrop")
AddEventHandler("carry:showdrop", function()
	disable = true
	while carry.InProgress do
		Wait(1)
		ESX.ShowHelpNotification('Drop Body : ~INPUT_CELLPHONE_CAMERA_FOCUS_LOCK~')
	end
end)