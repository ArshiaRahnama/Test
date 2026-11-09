-- Pub by FleeX Team , https://discord.gg/87rGBxgCsa

ESX = nil
PlayerData = {}
local pedList = {}
local cam = nil
local name = ''
local waitMore = true
local inMenu = false
local hasEntered = false
local startingThread = false
local nearData = nil
local externalPed = false
Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent("esx:getSharedObject", function(obj) ESX = obj end)
		Citizen.Wait(0)
	end
	while ESX.GetPlayerData().job == nil do
		Citizen.Wait(10)
	end
	PlayerData = ESX.GetPlayerData()
end)

-- CREATE NPCs

Citizen.CreateThread(function()
	local pedInfo = {}
	local camCoords = nil
	local camRotation = nil
	local __ = false
	for k, v in pairs(Config.TalkToNPC) do
		RequestModel(GetHashKey(v.npc))
		while not HasModelLoaded(GetHashKey(v.npc)) do
			Wait(1)
		end

		RequestAnimDict("mini@strip_club@idles@bouncer@base")
		while not HasAnimDictLoaded("mini@strip_club@idles@bouncer@base") do
			Wait(1)
		end

		ped =  CreatePed(4, v.npc, v.coordinates[1], v.coordinates[2], v.coordinates[3], v.heading, false, true)
		SetEntityHeading(ped, v.heading)
		FreezeEntityPosition(ped, true)
		SetEntityInvincible(ped, true)
		SetBlockingOfNonTemporaryEvents(ped, true)
		TaskPlayAnim(ped,"mini@strip_club@idles@bouncer@base","base", 8.0, 0.0, -1, 1, 0, 0, 0, 0)

		if Config.AutoCamPosition then
			local px, py, pz = table.unpack(GetEntityCoords(ped, true))
			local x, y, z = px + GetEntityForwardX(ped) * 1.2, py + GetEntityForwardY(ped) * 1.2, pz + 0.52

			camCoords = vector3(x, y, z)
		end

		if Config.AutoCamRotation then
			local rx = GetEntityRotation(ped, 2)

			camRotation = rx + vector3(0.0, 0.0, 181)
		end

		pedInfo = {
			name = v.name,
			model = v.npc,
			pedCoords = v.coordinates,
			entity = ped,
			camCoords = camCoords,
			camRotation = camRotation,
			thread = v.thread,
		}
		if v.thread then
			__ = true
		end
		table.insert(pedList, pedInfo)
	end
	if __ and not startingThread then
		startThread()
	end
end)

function startThread()
	if not startingThread then
		startingThread = true
		Citizen.CreateThread(function()
			local inZone = false
			local hasSetName = false
			local nearPed = false
			local checkedJob = false
			local hasJob = false
			local npcModel = nil
			local npcName = nil
			local npcKey = 0
			
			while startingThread do
				Citizen.Wait(1000)
				local playerCoords = GetEntityCoords(PlayerPedId())
				
				inZone = false
				nearPed = false
		
				if npcName == nil and npcModel == nil then
					for k,v in pairs(Config.TalkToNPC) do
						local distance = GetDistanceBetweenCoords(playerCoords.x, playerCoords.y, playerCoords.z, v.coordinates[1], v.coordinates[2], v.coordinates[3])
					
						if v.jobs[1] ~= nil then
		
							if distance < v.interactionRange + 2 then
								npcName = v.name
								npcModel = v.npc
								npcKey = k
								nearPed = true
		
							elseif not waitMore and not nearPed then
								waitMore = true
							elseif checkedJob then
								checkedJob = false
							end
						else
							if distance < v.interactionRange + 2 then
								npcName = v.name
								npcModel = v.npc
								npcKey = k
								nearPed = true
								if not inMenu then
									waitMore = false
								end
								
							elseif not waitMore and not nearPed then
								waitMore = true
							end
						end
					end
				else
					v = Config.TalkToNPC[npcKey]
					if v ~= nil then
						local distance = GetDistanceBetweenCoords(playerCoords.x, playerCoords.y, playerCoords.z, v.coordinates[1], v.coordinates[2], v.coordinates[3])
						local zDistance = playerCoords.z - v.coordinates[3]
						
						if zDistance < 0 then
							zDistance = zDistance * -1
						end
						if zDistance < 2 then
							if v.jobs[1] ~= nil then
		
								if distance < v.interactionRange + 3 then
									if not checkedJob then
										hasJob = false
										checkedJob = true
										for k2,v2 in pairs(v.jobs) do
											if ESX.GetPlayerData().job.name == v2 then
												hasJob = true
											end
										end
									end
									
									if hasJob then
										if not nearPed then
											nearPed = true
										end
										if not inMenu then
											waitMore = false
										end
										if distance < v.interactionRange then
											if not hasSetName then
												name = v.uiText
												hasSetName = true
											end
											if not inZone then
												inZone = true
											end
											if not Config.UseOkokTextUI and not inMenu then
												ESX.ShowHelpNotification('~INPUT_CONTEXT~ To talk with ~g~'..name)
											end
											-- if IsControlJustReleased(0, Config.Key) then
											-- 	inMenu = true
											-- 	waitMore = true
											-- 	StartCam(v.coordinates, v.camOffset, v.camRotation, v.npc, v.name)
											-- 	if Config.UseOkokTextUI then
											-- 		exports['TextUI']:Close()
											-- 	end
											-- 	Citizen.Wait(500)
											-- 	if Config.HideMinimap then
											-- 		DisplayRadar(false)
											-- 	end
											-- 	SetNuiFocus(true, true)
											-- 	SendNUIMessage({
											-- 		action = 'openDialog',
											-- 		name = v.name,
											-- 		dialog = v.dialog,
											-- 		options = v.options,
											-- 	})
											-- end
											nearData = {
												{
													action = 'openDialog',
													header = v.header,
													name = v.name,
													dialog = v.dialog,
													options = v.options,
												},
												v
											}
										elseif hasSetName then
											hasSetName = false
										end
									end
								elseif not waitMore and not nearPed then
									waitMore = true
								elseif checkedJob then
									checkedJob = false
								end
								if distance > v.interactionRange + 2 and npcName ~= nil and npcModel ~= nil then
									npcModel = nil
									npcName = nil
									npcKey = 0
								end
							else
								if distance < v.interactionRange + 3 then
									if not nearPed then
										nearPed = true
									end
									if not inMenu then
										waitMore = false
									end
									if distance < v.interactionRange then
										if not hasSetName then
											name = v.uiText
											hasSetName = true
										end
										if not inZone then
											inZone = true
										end
										if not Config.UseOkokTextUI and not inMenu then
											ESX.ShowHelpNotification('~INPUT_CONTEXT~ To talk with ~g~'..name)
										end
										-- if IsControlJustReleased(0, Config.Key) then
										-- 	inMenu = true
										-- 	waitMore = true
										-- 	StartCam(v.coordinates, v.camOffset, v.camRotation, v.npc, v.name)
										-- 	if Config.UseOkokTextUI then
										-- 		exports['TextUI']:Close()
										-- 	end
										-- 	Citizen.Wait(500)
										-- 	if Config.HideMinimap then
										-- 		DisplayRadar(false)
										-- 	end
										-- 	SetNuiFocus(true, true)
										-- 	SendNUIMessage({
										-- 		action = 'openDialog',
										-- 		header = v.header,
										-- 		name = v.name,
										-- 		dialog = v.dialog,
										-- 		options = v.options,
										-- 	})
										-- end
										nearData = {
											{
												action = 'openDialog',
												header = v.header,
												name = v.name,
												dialog = v.dialog,
												options = v.options,
											},
											v
										}
									elseif hasSetName then
										hasSetName = false
									end
								elseif not waitMore and not nearPed then
									waitMore = true
								end
								if distance > v.interactionRange + 2 and npcName ~= nil and npcModel ~= nil then
									npcModel = nil
									npcName = nil
									npcKey = 0
								end
							end
						end
					end
				end	
		
				if inZone and not hasEntered then
					if Config.UseOkokTextUI then
						ESX.showTextUI('جهت صحبت با جابر [E]')
					end
					hasEntered = true
				elseif not inZone and hasEntered then
					if Config.UseOkokTextUI then
						ESX.hideTextUI()
					end
					hasEntered = false
					nearData = nil
				end 
		
				-- if waitMore then
				-- 	Citizen.Wait(1000)
				-- end
			end
		end)
	end
end

-- ACTIONS

RegisterNUICallback('action', function(data, cb)
	if data.action == 'close' then
		SetNuiFocus(false, false)
		--exports['al']:Alert("BANK", "Have a nice day.", 5000, 'info')
		if Config.HideMinimap then
			DisplayRadar(true)
		end
		hasEntered = true
		if Config.UseOkokTextUI and not externalPed then
			ESX.showTextUI('جهت صحبت با جابر [E]')
		else
			externalPed = false
		end
		EndCam()
		inMenu = false
		waitMore = false
	elseif data.action == 'option' then
		SetNuiFocus(false, false)
		if Config.HideMinimap then
			DisplayRadar(true)
		end
		hasEntered = true
		if Config.UseOkokTextUI and not externalPed then
			ESX.showTextUI('جهت صحبت با جابر [E]')
		end
		EndCam()
		inMenu = false
		waitMore = false
		if data.options[2] == 'function' then
			nearData[1].options[data.options[3]][2]()
		else
			if data.options[3] == 'c' then
				TriggerEvent(data.options[2])
			elseif data.options[3] ~= nil then
				TriggerServerEvent(data.options[2])
			end
		end
	end
end)

-- CAMERA

function StartCam(coords, offset, rotation, model, name)
	ClearFocus()

	if Config.AutoCamRotation then
		for k,v in pairs(pedList) do
			if v.pedCoords == coords then
				if v.name == name and v.model == model then
					rotation = v.camRotation
				end
			end
		end
	end

	if Config.AutoCamPosition then
		for k,v in pairs(pedList) do
			if v.pedCoords == coords then
				if v.name == name and v.model == model then
					coords = v.camCoords
				end
			end
		end
	else
		coords = coords + offset
	end

	cam = CreateCamWithParams("DEFAULT_SCRIPTED_CAMERA", coords, rotation, GetGameplayCamFov())

	SetCamActive(cam, true)
	RenderScriptCams(true, true, Config.CameraAnimationTime, true, false)
end

function StartCam2(ped)
	ClearFocus()

	local rx = GetEntityRotation(ped, 2)
	rotation = rx + vector3(0.0, 0.0, 181)

	local coords = nil
	local px, py, pz = table.unpack(GetEntityCoords(ped, true))
	local x, y, z = px + GetEntityForwardX(ped) * 1.2, py + GetEntityForwardY(ped) * 1.2, pz + 0.52

	coords = vector3(x, y, z)

	cam = CreateCamWithParams("DEFAULT_SCRIPTED_CAMERA", coords, rotation, GetGameplayCamFov())

	SetCamActive(cam, true)
	RenderScriptCams(true, true, Config.CameraAnimationTime, true, false)
end

function EndCam()
	ClearFocus()

	RenderScriptCams(false, true, Config.CameraAnimationTime, true, false)
	DestroyCam(cam, false)

	cam = nil
end

-- AddEventHandler('KeyDown:e',function()
-- 	if nearData and not inMenu and not externalPed then
-- 		StartCam(v.coordinates, v.camOffset, v.camRotation, v.npc, v.name)
-- 		externalPed = false
-- 		local v = nearData[2]
-- 		inMenu = true
-- 		if Config.UseOkokTextUI then
-- 			exports['TextUI']:Close()
-- 		end
-- 		Citizen.Wait(500)
-- 		if Config.HideMinimap then
-- 			DisplayRadar(false)
-- 		end
-- 		SetNuiFocus(true, true)
-- 		SendNUIMessage(nearData[1])
-- 	end
-- end)

_SendNUIMessage = SendNUIMessage
function SendNUIMessage(data)
	data = ESX.CopyTable(data)
	for k, v in pairs(data.options) do
		if type(v[2]) == 'table' then
			v[2] = 'function'
			v[3] = k
		end
	end
	_SendNUIMessage(data)
end

function open(data)
	if not inMenu then
		nearData = {data.data}
		inMenu = true
		externalPed = true
		StartCam2(data.ped)
		if Config.UseOkokTextUI then
			ESX.hideTextUI()
		end
		Citizen.Wait(500)
		if Config.HideMinimap then
			DisplayRadar(false)
		end
		SetNuiFocus(true, true)
		data.data.action = 'openDialog'
		SendNUIMessage(data.data)
	end
end

exports('open', open)