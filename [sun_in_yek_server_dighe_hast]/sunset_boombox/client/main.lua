-- Pub by FleeX Team , https://discord.gg/87rGBxgCsa

ESX = exports['essentialmode']:getObject()
local BoomBoxes = {}
local playList = {}
local boomboxID = 0
local boomboxID2 = 0
local BoomboxMenuOpened = false
local CarriedBoombox = false
local boomboxMute = true
local showRangeCircle = false
local currentRangePreview = 0
local mutedZoneNotified = false

RegisterNetEvent('setting:boomboxMute', function(mode)
	boomboxMute = mode
end)

Citizen.CreateThread(function()
	while true do
		if showRangeCircle and currentRangePreview > 0 and CarriedBoombox then
			local playerPed = PlayerPedId()
			local coords = GetEntityCoords(playerPed)
			DrawMarker(1, coords.x, coords.y, coords.z - 1.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, currentRangePreview * 2.0, currentRangePreview * 2.0, 1.0, 155, 89, 182, 100, false, false, 2, false, nil, nil, false)
			DrawMarker(27, coords.x, coords.y, coords.z - 0.98, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, currentRangePreview * 2.0, currentRangePreview * 2.0, 1.0, 187, 107, 217, 150, false, false, 2, false, nil, nil, false)
			Citizen.Wait(0)
		else
			Citizen.Wait(500)
		end
	end
end)

Citizen.CreateThread(function()
	while ESX == nil do
		Citizen.Wait(1000)
	end

	Citizen.Wait(5000)
	while not exports['sunset_utils']:GetServerOSTime() do Citizen.Wait(1000) end
    PlayEndCreditsMusic(false)
    TriggerServerEvent('sunset_boombox:requestBoomBoxesResync')
	while true do
		Citizen.Wait(1000)
		local coords = GetEntityCoords(PlayerPedId())
		local inMutedZone = false
		for k , v in pairs(playList) do
			v.check = false
		end
		for id,v in pairs(BoomBoxes) do
			if NetworkDoesEntityExistWithNetworkId(v.object) then
				local object = NetworkGetEntityFromNetworkId(v.object)
				if DoesEntityExist(object) then
					local distance = ESX.GetDistance(coords,GetEntityCoords(object))
					if boomboxMute and distance < v.distance then inMutedZone = true end
					if distance < v.distance and not boomboxMute then
						if v.url then
							local volume = math.floor((v.volume * (1 - (distance / (v.distance)))) * 0.2)
							volume =  math.max(0.0, ESX.Math.Round(volume/100, 2))
							if not playList[id] then
                                TriggerEvent('chatMessage', '[BoomBox]', {255, 0, 0}, '^0Enter zone['.. id ..' - '.. v.src ..']', 'plarms')
								local ts = exports['sunset_utils']:GetServerOSTime()
								local time = ts - v.startTime
								SendNUIMessage({
									id = id,
									type = 'play',
									url = v.url,
									volume = volume,
									time = time
								})
								playList[id] = v
								playList[id].check = true
							elseif playList[id].url ~= v.url or playList[id].startTime ~= v.startTime then
								playList[id] = nil
							else
								SendNUIMessage({
									id = id,
									type = 'volume',
									volume = volume
								})
								playList[id].check = true
							end
						elseif playList[id] then
							playList[id] = nil
							SendNUIMessage({
								id = id,
								type = 'stop'
							})
						end
					elseif playList[id] or boomboxMute then
						if playList[id] then
							TriggerEvent('chatMessage', '[BoomBox]', {255, 0, 0}, '^0Exit zone['.. id ..' - '.. v.src ..']', 'plarms')
							playList[id] = nil
							SendNUIMessage({
								id = id,
								type = 'stop'
							})
						end
					end
				elseif playList[id] then
					playList[id] = nil
					SendNUIMessage({
						id = id,
						type = 'stop'
					})
				end
			elseif playList[id] then
				playList[id] = nil
				SendNUIMessage({
					id = id,
					type = 'stop'
				})
			end
		end
		for id , v in pairs(playList) do
			if not v.check then
				playList[id] = nil
				SendNUIMessage({
					id = id,
					type = 'stop'
				})
			end
		end
		if ESX.tableLength(playList) > 0 then
			exports['sunset_utils']:addStress('enterzone_boombox')
		end
		if inMutedZone then
			if not mutedZoneNotified then
				mutedZoneNotified = true
				ESX.chatMessage('Shoma dar halate sokoot boombox hastid! Baraye shenidan, be tanzimat (F2) berid va khamoosh-esh konid.', 'plarms')
			end
		else
			mutedZoneNotified = false
		end
	end
end)

AddEventHandler('esx:onPlayerDeath', function()
	if CarriedBoombox then
        BoomBoxPickup(boomboxID)
    end
end)

RegisterNetEvent('sunset_boombox:resyncBoomBoxes')
AddEventHandler('sunset_boombox:resyncBoomBoxes', function(boomboxes)
	BoomBoxes = boomboxes
end)

RegisterNetEvent('sunset_boombox:resyncBoomBox', function(id, boombox)
	BoomBoxes[id] = boombox
end)

RegisterNetEvent('sunset_boombox:pause', function(id)
	SendNUIMessage({
		id = id,
		type = 'pause'
	})
end)

RegisterNetEvent('esx:removeInventoryItemss',function(label,count,name,newcount)
    if name == Config.itemName and newcount <= 0 then
		if CarriedBoombox then
			BoomBoxPickup(boomboxID)
		end
    end
end)

function StartAnimation(lib, anim, sleep)
	ESX.Streaming.RequestAnimDict(lib)
	TaskPlayAnim(PlayerPedId(), lib, anim, 8.0, -8.0, -1, 1, 0, false, false, false)
	Citizen.Wait(sleep)
	ClearPedTasks(PlayerPedId())
end

function OpenBoomBoxMenuNUI(id)
	local boombox = BoomBoxes[id]

	BoomboxMenuOpened = true
	SetNuiFocus(true, true)

	SendNUIMessage({
		action = 'open',
		boomboxId = id,
		volume = boombox and boombox.volume or Config.DefaultVolume,
		range = boombox and boombox.distance or Config.Distance,
		url = boombox and boombox.url or nil,
		isPlaying = boombox and boombox.url ~= nil or false
	})
end

function CloseBoomBoxMenuNUI()
	BoomboxMenuOpened = false
	SetNuiFocus(false, false)
	SendNUIMessage({ action = 'close' })
end

RegisterNUICallback('close', function(data, cb)
	CloseBoomBoxMenuNUI()
	cb('ok')
end)

RegisterNUICallback('play', function(data, cb)
	if data.url and boomboxID ~= 0 then
		TriggerServerEvent('sunset_boombox:play', boomboxID, data.url)
	end
	cb('ok')
end)

RegisterNUICallback('resume', function(data, cb)
	if data.url and boomboxID ~= 0 then
		local time = tonumber(data.time) or 0
		TriggerServerEvent('sunset_boombox:resume', boomboxID, data.url, time)
	end
	cb('ok')
end)

RegisterNUICallback('stop', function(data, cb)
	if boomboxID ~= 0 then
		TriggerServerEvent('sunset_boombox:stop', boomboxID)
	end
	cb('ok')
end)

RegisterNUICallback('pause', function(data, cb)
	if boomboxID ~= 0 then
		TriggerServerEvent('sunset_boombox:pause', boomboxID)
	end
	cb('ok')
end)

RegisterNUICallback('setVolume', function(data, cb)
	if data.volume and boomboxID ~= 0 then
		local volume = tonumber(data.volume)
		if volume and volume >= 10 and volume <= 100 then
			TriggerServerEvent('sunset_boombox:setVolume', boomboxID, volume)
		end
	end
	cb('ok')
end)

RegisterNUICallback('setRange', function(data, cb)
	if data.range and boomboxID ~= 0 then
		local range = tonumber(data.range)
		if range and range >= 10 and range <= 50 then
			TriggerServerEvent('sunset_boombox:setRange', boomboxID, range)
		end
	end
	cb('ok')
end)

RegisterNUICallback('previewRange', function(data, cb)
	if data.range then
		currentRangePreview = tonumber(data.range) or 0
		showRangeCircle = data.show == true
	end
	cb('ok')
end)

RegisterNUICallback('seek', function(data, cb)
	if data.time and boomboxID ~= 0 then
		local time = tonumber(data.time)
		if time and time >= 0 then
			TriggerServerEvent('sunset_boombox:seek', boomboxID, time)
		end
	end
	cb('ok')
end)

RegisterNUICallback('pickup', function(data, cb)
	CloseBoomBoxMenuNUI()
	BoomBoxPickup(boomboxID)
	cb('ok')
end)

function BoomBoxPickup(id)
	ESX.Game.DeleteObject(NetworkGetEntityFromNetworkId(boomboxID))
	TriggerServerEvent('sunset_boombox:pickup', boomboxID)
	CarriedBoombox = false
	boomboxID = 0
	ClearPedTasks(PlayerPedId())
end

RegisterNetEvent('sunset_boombox:place')
AddEventHandler('sunset_boombox:place', function()
    if not ESX.GetPlayerData().IsInjure and not ESX.GetPlayerData().IsDead and not ESX.GetPlayerData().Cuffed then
		if not CarriedBoombox and boomboxID == 0 then
			exports['sun-inventory-hud']:closeInventory()
			ESX.Streaming.RequestAnimDict(Config.CarryAnimDict)
			ESX.Game.SpawnObject(Config.PropModel, GetEntityCoords(PlayerPedId()), function(boomboxObject)
				SetEntityCollision(boomboxObject, false, true)
				AttachEntityToEntity(boomboxObject, PlayerPedId(), GetPedBoneIndex(PlayerPedId(), 28422), 0.0, 0.0, 0.15, 0.0, 0.0, 0.0, true, true, false, false, 2, true)
				boomboxID = NetworkGetNetworkIdFromEntity(boomboxObject)
				boomboxID2 = boomboxObject
				TriggerServerEvent('sunset_boombox:register',boomboxID)
				carryBoombox()
			end)
		end
    end
end)

AddEventHandler('KeyDown:e',function()
	if CarriedBoombox and not BoomboxMenuOpened then
		OpenBoomBoxMenuNUI(boomboxID)
	end
end)

function carryBoombox()
	if not CarriedBoombox then
		CarriedBoombox = true
		local lastHintState = nil
		SendNUIMessage({ action = 'showHint' })
		Citizen.CreateThread(function()
			exports['essentialmode']:disablecontrol('x',true)
			while CarriedBoombox do
				local playerPed = PlayerPedId()
				if not IsEntityPlayingAnim(playerPed, Config.CarryAnimDict, Config.CarryAnim, 3) then
					TaskPlayAnim(playerPed, Config.CarryAnimDict, Config.CarryAnim, 8.0, -8.0, -1, 51, 0, false, false, false)
				end
				if not GetSelectedPedWeapon(playerPed) ~= `WEAPON_UNARMED` then
					SetCurrentPedWeapon(playerPed, `WEAPON_UNARMED`, true)
				end
				local shouldShowHint = not BoomboxMenuOpened
				if lastHintState ~= shouldShowHint then
					lastHintState = shouldShowHint
					SendNUIMessage({ action = shouldShowHint and 'showHint' or 'hideHint' })
				end
				DisablePlayerFiring(PlayerPedId(),true)
				if IsPedInAnyVehicle(PlayerPedId()) then
					if GetPedInVehicleSeat(GetVehiclePedIsIn(PlayerPedId()), -1) == PlayerPedId() then
						TaskLeaveVehicle(PlayerPedId(), GetVehiclePedIsIn(PlayerPedId()), 16)
					end
				end
				if not DoesEntityExist(boomboxID2) then
					BoomBoxPickup(boomboxID)
					break
				end
				Citizen.Wait(100)
			end
			SendNUIMessage({ action = 'hideHint' })
			exports['essentialmode']:disablecontrol('x',false)
		end)
	end
end
