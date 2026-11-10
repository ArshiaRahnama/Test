-- Pub by FleeX Team , https://discord.gg/87rGBxgCsa

local isChopping = false
local currentVehicle = nil
local outlineEffect = nil
local registeredPoints = {}
local chopBlips = {}
local pointsDisabled = false

local movementLocked = false


Citizen.CreateThread(function()
	while true do
		if movementLocked then
			DisableControlAction(0, 30, true) -- MOVE_LR (A/D)
			DisableControlAction(0, 31, true) -- MOVE_UD (W/S)
			DisableControlAction(0, 21, true) -- Sprint (Shift)
			DisableControlAction(0, 22, true) -- Jump (Space)
			DisableControlAction(0, 32, true) -- W
			DisableControlAction(0, 33, true) -- S
			DisableControlAction(0, 34, true) -- A
			DisableControlAction(0, 35, true) -- D
			DisableControlAction(0, 36, true) -- Duck (Ctrl)
			Wait(0)
		else
			Wait(50)
		end
	end
end)

function LockMovement()
	movementLocked = true
	DisableControlAction(0, 30, true)
	DisableControlAction(0, 31, true)
	DisableControlAction(0, 21, true)
	DisableControlAction(0, 22, true)
	DisableControlAction(0, 32, true)
	DisableControlAction(0, 33, true)
	DisableControlAction(0, 34, true)
	DisableControlAction(0, 35, true)
	DisableControlAction(0, 36, true)
end

function UnlockMovement()
	movementLocked = false
end

local function CleanupChopShops()
	for _, pointId in ipairs(registeredPoints) do
		if ESX.RemovePoint then
			ESX.RemovePoint(pointId)
		end
	end
	registeredPoints = {}
	for _, blip in ipairs(chopBlips) do
		if DoesBlipExist(blip) then
			RemoveBlip(blip)
		end
	end
	chopBlips = {}
end

Citizen.CreateThread(function()
	waitForLoad(1000)
	CleanupChopShops()

	for k, v in ipairs(chopConfig.Chopshops) do
		local blip = AddBlipForCoord(v.x, v.y, v.z)
		SetBlipSprite(blip, 89)
		SetBlipDisplay(blip, 4)
		SetBlipScale(blip, 0.8)
		SetBlipColour(blip, 57)
		SetBlipAsShortRange(blip, true)
		BeginTextCommandSetBlipName("STRING")
		AddTextComponentString('Chop shop')
		EndTextCommandSetBlipName(blip)
		table.insert(chopBlips, blip)

		local pointId = ESX.RegisterPoint(v, 50, {
			Color = {R = chopConfig.MarkerColor.r, G = chopConfig.MarkerColor.g, B = chopConfig.MarkerColor.b, A = 100},
			DrawDistance = 10,
			Radius = chopConfig.MarkerSize.x,
			Type = chopConfig.MarkerType,
			world = 0,
			Hide = function()
				return isChopping or pointsDisabled
			end,
		}, {
			Notification = nil,
			Key = 'e',
			CB = function()
				if pointsDisabled then
					return
				end

				if not isChopping and SUN.PlayerIsInVehicle and SUN.PlayerIsDriver then
					if ESX.GetPlayerData().World == 97 then
						return ESX.notification('error', 'Shoma nemitavanid dar in world chop shop konid!')
					end

					local plate = GetVehicleNumberPlateText(SUN.vehiclePlayerIsIn)
					ESX.TriggerServerCallback('carlock:isVehicleowned',function(can)
							if can then
								ESX.TriggerServerCallback('chopshop:server:isChopped', function(choped)
									if choped then
										return
										ESX.notification('error', 'In mashin ghablan oragh shode ast!')
									else
										if Entity(SUN.vehiclePlayerIsIn).state.chop then return end

										local alert = lib.alertDialog({
											header = 'Oragh kardan',
											content = 'Aya motmaen hastid ke mikhayd in mashin ra oragh konid?',
											centered = true,
											cancel = true,
											labels = {
												confirm = 'Bale',
												cancel = 'Kheir'
											}
										})

										if alert == 'confirm' then
											local playerCoords = SUN.PlayerCoords
											local distance = #(v - playerCoords)

											if distance > 10 then
												return
											end

											ESX.TriggerServerEvent('setEntityState', NetworkGetNetworkIdFromEntity(SUN.vehiclePlayerIsIn), 'chop', true)

											local lock = GetVehicleDoorLockStatus(SUN.vehiclePlayerIsIn)
											if lock == 1 or lock == 0 then
												local NetId = NetworkGetNetworkIdFromEntity(SUN.vehiclePlayerIsIn)
												TriggerServerEvent("esx_vehiclecontrol:sync", NetId, true)
											end

											StartChoppingSequence(SUN.vehiclePlayerIsIn, plate)
										end
									end
								end, plate)
							else
							ESX.notification('error', 'In mashin dar takhasos ma nist!')
							end
					end, plate)
				elseif not SUN.PlayerIsInVehicle then
					ESX.notification('error', 'Shoma bayad savare mashin bashid')
				elseif not SUN.PlayerIsDriver then
					ESX.notification('error', 'Shoma bayad ranande mashin bashid')
				end
			end,
		}, {
			In = function()
				if not pointsDisabled then
					if SUN.PlayerIsInVehicle and SUN.PlayerIsDriver and not isChopping then
						chop = true
						ESX.showTextUI('Dokme E jahat shoroe chop shop')
					end
				end
			end,
			Out = function()
				if not pointsDisabled then
					chop = false
					lib.hideTextUI()
				end
			end
		})
		if pointId then
			table.insert(registeredPoints, pointId)
		end
	end
end)

function HighlightVehiclePart(vehicle, partIndex)
	if outlineEffect then
		if outlineEffect.marker then
			outlineEffect.marker = nil
		end
	end

	local partArray = getPartArray(vehicle)

	local partConfig = partArray[partIndex]

	if partConfig.type == 'timer' then
		local vehicleCoords = GetEntityCoords(vehicle)
		outlineEffect = {
			active = true,
			coords = vehicleCoords,
			marker = true
		}
		return
	end

	local boneIndex = GetEntityBoneIndexByName(vehicle, partConfig.bone)
	if boneIndex ~= -1 then
		local boneCoords = GetWorldPositionOfEntityBone(vehicle, boneIndex)
		outlineEffect = {
			active = true,
			coords = boneCoords,
			marker = true
		}
	end
end

function RemoveHighlight(vehicle)
	if outlineEffect then
		outlineEffect = nil
	end
end

Citizen.CreateThread(function()
	while true do
		Wait(0)
		if outlineEffect and outlineEffect.marker and isChopping then
			DrawMarker(2, outlineEffect.coords.x, outlineEffect.coords.y, outlineEffect.coords.z + 1.0, 0.0, 0.0, 0.0, 180.0, 0.0, 0.0, 0.3, 0.3, 0.3, 255, 165, 0, 200, true, true, 2, false, false, false, false)
		else
			Wait(500)
		end
	end
end)

function CreatePartProp(vehicle, partConfig)
	if partConfig.type == 'hood' then
		SetVehicleDoorBroken(vehicle, 4, true)
	elseif partConfig.type == 'trunk' then
		SetVehicleDoorBroken(vehicle, 5, true)
	elseif partConfig.type == 'door' then
		SetVehicleDoorBroken(vehicle, partConfig.door, true)
	elseif partConfig.type == 'timer' then
		-- No physical part to remove
	end
end

function PlayChopAnimation(vehicle, partConfig)
	local hasInsurance = exports['sun-jobs']:getVehicleInsuranceData(vehicle)
	local animTime = hasInsurance and partConfig.insurancedtime or partConfig.time
	local completed = false

	Wait(200)

	if SUN.PlayerIsInVehicle then
		return true
	end

	local animationCancelled = false
	local monitorThread = Citizen.CreateThread(function()
		while not completed and not animationCancelled do
			Wait(100)
			if SUN.PlayerIsInVehicle then
				animationCancelled = true
				exports.ox_lib:cancelProgress()
				break
			end
		end
	end)

	if partConfig.type == 'hood' or partConfig.type == 'trunk' then
		SetVehicleDoorOpen(vehicle, partConfig.door, false, false)
		Wait(300)

		if SUN.PlayerIsInVehicle then
			return true
		end

		TaskStartScenarioInPlace(SUN.ped, 'WORLD_HUMAN_WELDING', 0, true)

		completed = lib.progressBar({
			duration = animTime,
			label = "Dar hale oragh kardan " .. partConfig.name,
			useWhileDead = false,
			canCancel = true,
			disable = {
				move = true,
				car = true,
				mouse = false,
				combat = true,
			}
		})

		ClearPedTasks(SUN.ped)

	elseif partConfig.type == 'door' then
		SetVehicleDoorOpen(vehicle, partConfig.door, false, false)
		Wait(300)

		if SUN.PlayerIsInVehicle then
			return true
		end

		TaskStartScenarioInPlace(SUN.ped, 'WORLD_HUMAN_WELDING', 0, true)

		completed = lib.progressBar({
			duration = animTime,
			label = "Dar hale oragh kardan " .. partConfig.name,
			useWhileDead = false,
			canCancel = true,
			disable = {
				move = true,
				car = true,
				mouse = false,
				combat = true,
			}
		})

		ClearPedTasks(SUN.ped)

	elseif partConfig.type == 'wheel' then
		if SUN.PlayerIsInVehicle then
			return true
		end

		ESX.Streaming.RequestAnimDict("anim@amb@clubhouse@tutorial@bkr_tut_ig3@")
		TaskPlayAnim(SUN.ped, "anim@amb@clubhouse@tutorial@bkr_tut_ig3@", "machinic_loop_mechandplayer", 8.0, -8.0, -1, 1, 0, false, false, false)
		TaskPlayAnim(ped, "anim@amb@clubhouse@tutorial@bkr_tut_ig3@", "machinic_loop_mechandplayer", 8.0, -8.0, -1, 1, 0, false, false, false)

		completed = lib.progressBar({
			duration = animTime,
			label = "Dar hale oragh kardan " .. partConfig.name,
			useWhileDead = false,
			canCancel = true,
			disable = {
				move = true,
				car = true,
				mouse = false,
				combat = true,
			}
		})

		ClearPedTasks(SUN.ped)

	elseif partConfig.type == 'timer' then
		if SUN.PlayerIsInVehicle then
			return true
		end

		TaskStartScenarioInPlace(SUN.ped, 'WORLD_HUMAN_WELDING', 0, true)

		completed = lib.progressBar({
			duration = animTime,
			label = "Dar hale oragh kardan " .. partConfig.name,
			useWhileDead = false,
			canCancel = true,
			disable = {
				move = true,
				car = true,
				mouse = false,
				combat = true,
			}
		})

		ClearPedTasks(SUN.ped)
	end

	if animationCancelled then
		ClearPedTasks(SUN.ped)
		return true
	end

	return not completed
end

function RemoveVehiclePart(vehicle, partConfig)
	if partConfig.type == 'wheel' then
		SetVehicleTyreBurst(vehicle, partConfig.wheel, true, 1000.0)
		BreakOffVehicleWheel(vehicle, partConfig.wheel, true, true, true, false)
	end
end

local currentPartIndex = 1

function StartChoppingSequence(vehicle, plate)
	isChopping = true
	pointsDisabled = true
	lib.hideTextUI()
	currentVehicle = vehicle
	currentPartIndex = 1

	FreezeEntityPosition(vehicle, true)
	TaskLeaveVehicle(SUN.ped, vehicle, 0)
	Wait(1500)

	TriggerServerEvent('chopshop:server:startChopping', NetworkGetNetworkIdFromEntity(vehicle), plate)

	ChopNextPart()
end

function ChopNextPart()
	if not isChopping or not DoesEntityExist(currentVehicle) then
		EndChopping()
		return
	end

	local partArray = getPartArray(currentVehicle)

	if currentPartIndex > #partArray then
		CompleteChopping()
		return
	end

	local partConfig = partArray[currentPartIndex]
	local vehicle = currentVehicle

	HighlightVehiclePart(vehicle, currentPartIndex)

	if partConfig.type == 'timer' then
		Citizen.CreateThread(function()
			local lastPartIndex = currentPartIndex
			local notificationShown = false
			local vehicleCoords = GetEntityCoords(vehicle)

			while isChopping and currentPartIndex == lastPartIndex and DoesEntityExist(currentVehicle) do
				Wait(0)
				local distance = #(vehicleCoords - SUN.PlayerCoords)

				if distance < 5.0 and not SUN.PlayerIsInVehicle then
					if not notificationShown then
						ESX.showTextUI('Dokme E jahat chop kardan')
						notificationShown = true
					end

					if IsControlJustPressed(0, 38) then
						LockMovement()
						ProcessChopPart(vehicle, partConfig)
						break
					end
				else
					if notificationShown then
						notificationShown = false
						ESX.hideTextUI()
					end
				end
			end
		end)
		return
	end

	local boneIndex = GetEntityBoneIndexByName(vehicle, partConfig.bone)
	if boneIndex == -1 then
		currentPartIndex = currentPartIndex + 1
		ChopNextPart()
		return
	end

	Citizen.CreateThread(function()
		local lastPartIndex = currentPartIndex
		local notificationShown = false
		while isChopping and currentPartIndex == lastPartIndex and DoesEntityExist(currentVehicle) do
			Wait(0)
			local currentPart = partArray[currentPartIndex]
			local currentBoneIndex = GetEntityBoneIndexByName(vehicle, currentPart.bone)

			if currentBoneIndex ~= -1 then
				local currentBoneCoords = GetWorldPositionOfEntityBone(vehicle, currentBoneIndex)
				local distance = #(currentBoneCoords - SUN.PlayerCoords)

				if distance < 1.5 and not SUN.PlayerIsInVehicle then
					if not notificationShown then
						ESX.showTextUI('Dokme E jahat chop kardan')
						notificationShown = true
					end

					if IsControlJustPressed(0, 38) then
						LockMovement()
						ProcessChopPart(vehicle, currentPart)
						break
					end
				else
					if notificationShown then
						notificationShown = false
						ESX.hideTextUI()
					end
				end
			end
		end
	end)
end

function ProcessChopPart(vehicle, partConfig)
	RemoveHighlight(vehicle)
	ESX.hideTextUI()

	if SUN.PlayerIsInVehicle then
		UnlockMovement()
		ESX.notification('error', 'Shoma nemitavanid dar mashin bashin!')
		Wait(10)
		ChopNextPart()
		return
	end

	local vehicleCoords = GetEntityCoords(vehicle)
	local playerPos = GetEntityCoords(SUN.ped)
	local vehicleHeading = GetEntityHeading(vehicle)
	local offsetDistance = 0.9
	local targetX, targetY, targetZ
	local needsMovement = true
	local targetCoords

	if partConfig.type == 'timer' then
		targetCoords = GetOffsetFromEntityInWorldCoords(vehicle, 0.0, 2.5, 0.0)
		needsMovement = false
	else
		local boneIndex = GetEntityBoneIndexByName(vehicle, partConfig.bone)
		if boneIndex == -1 then
			UnlockMovement()
			currentPartIndex = currentPartIndex + 1
			ChopNextPart()
			return
		end

		local boneCoords = GetWorldPositionOfEntityBone(vehicle, boneIndex)

		if partConfig.type == 'hood' then
			targetCoords = GetOffsetFromEntityInWorldCoords(vehicle, 0.0, 2.5, 0.0)
			needsMovement = false

		elseif partConfig.type == 'trunk' then
			targetCoords = GetOffsetFromEntityInWorldCoords(vehicle, 0.0, -2.5, 0.0)
			needsMovement = false

		elseif partConfig.type == 'door' then
			if partConfig.door == 0 or partConfig.door == 2 then
				local radians = math.rad(vehicleHeading - 90.0)
				targetX = vehicleCoords.x + (math.sin(radians) * offsetDistance)
				targetY = vehicleCoords.y - (math.cos(radians) * offsetDistance)
			else
				local radians = math.rad(vehicleHeading + 90.0)
				targetX = vehicleCoords.x + (math.sin(radians) * offsetDistance)
				targetY = vehicleCoords.y - (math.cos(radians) * offsetDistance)
			end
			targetCoords = boneCoords

		elseif partConfig.type == 'wheel' then
			local wheelOffset = GetWorldPositionOfEntityBone(vehicle, boneIndex)
			local heading = GetHeadingFromVector_2d(vehicleCoords.x - wheelOffset.x, vehicleCoords.y - wheelOffset.y)
			local radians = math.rad(heading + 180.0)
			targetX = wheelOffset.x + (math.sin(radians) * 0.7)
			targetY = wheelOffset.y - (math.cos(radians) * 0.7)
			targetCoords = wheelOffset
		else
			local heading = GetHeadingFromVector_2d(boneCoords.x - playerPos.x, boneCoords.y - playerPos.y)
			local radians = math.rad(heading + 180.0)
			targetX = boneCoords.x + (math.sin(radians) * offsetDistance)
			targetY = boneCoords.y - (math.cos(radians) * offsetDistance)
			targetCoords = boneCoords
		end
	end

	if needsMovement then
		targetZ = playerPos.z
		local groundFound, groundZ = GetGroundZFor_3dCoord(targetX, targetY, targetZ + 1.0, false)
		if groundFound then
			targetZ = groundZ
		end

		TaskGoToCoordAnyMeans(SUN.ped, targetX, targetY, targetZ, 1.0, 0, false, 786603, 0.0)

		local timeout = 0
		local maxTimeout = 3000
		while timeout < maxTimeout do
			Wait(1)
			timeout = timeout + 100
			local currentPos = GetEntityCoords(SUN.ped)
			local currentDist = #(vector3(targetX, targetY, targetZ) - currentPos)
			if currentDist < 0.5 then
				break
			end
			if SUN.PlayerIsInVehicle then
				UnlockMovement()
				ClearPedTasks(SUN.ped)
				return
			end
		end

		ClearPedTasks(SUN.ped)
		Wait(1)
	end

	local pedCoords = GetEntityCoords(SUN.ped, true)
	local dx = targetCoords.x - pedCoords.x
	local dy = targetCoords.y - pedCoords.y
	local heading = GetHeadingFromVector_2d(dx, dy)
	SetEntityHeading(SUN.ped, heading)
	Wait(1)

	UnlockMovement()

	local wasCancelled = PlayChopAnimation(vehicle, partConfig)

	if wasCancelled then
		if SUN.PlayerIsInVehicle then
			ESX.notification('error', 'Chop laghv shod - shoma nemitavanid dar mashin bashin!')
			TaskLeaveVehicle(SUN.ped,vehicle,0)
		end
		Wait(500)
		ChopNextPart()
		return
	end

	CreatePartProp(vehicle, partConfig)

	RemoveVehiclePart(vehicle, partConfig)

	TriggerServerEvent('chopshop:server:partCompleted', NetworkGetNetworkIdFromEntity(vehicle), currentPartIndex)

	currentPartIndex = currentPartIndex + 1

	Wait(500)
	ChopNextPart()
end

function CompleteChopping()
	if not DoesEntityExist(currentVehicle) then
		EndChopping()
		return
	end

	RemoveHighlight(currentVehicle)

	local plate = GetVehicleNumberPlateText(currentVehicle)
	local model = GetEntityModel(currentVehicle)
	ESX.TriggerServerEvent('chopshop:server:complete', NetworkGetNetworkIdFromEntity(currentVehicle), plate, model)
	Wait(1000)

	if DoesEntityExist(currentVehicle) then
		DeleteEntity(currentVehicle)
	end

	EndChopping()
end

function EndChopping()
	isChopping = false
	pointsDisabled = false
	UnlockMovement()
	ESX.hideTextUI()
	if currentVehicle and DoesEntityExist(currentVehicle) then
		RemoveHighlight(currentVehicle)
		FreezeEntityPosition(currentVehicle, false)
	end

	currentVehicle = nil
	currentPartIndex = 1
	droppedProps = {}
end

RegisterNetEvent('chopshop:client:cancel', function()
	EndChopping()
	ESX.notification('error', 'Chop shop laghv shod')
end)

AddEventHandler('onResourceStop', function(resourceName)
	if GetCurrentResourceName() == resourceName then
		EndChopping()
		CleanupChopShops()
	end
end)

function getPartArray(vehicle)
	local class = GetVehicleClass(vehicle)
	local parts = chopConfig.ChopParts[class] or chopConfig.ChopParts.all

	local validParts = {}
	for _, part in ipairs(parts) do
		if part.type == 'timer' then
			table.insert(validParts, part)
		else
			local boneIndex = GetEntityBoneIndexByName(vehicle, part.bone)
			if boneIndex ~= -1 then
				table.insert(validParts, part)
			end
		end
	end

	if #validParts == 0 then
		return chopConfig.fallbackPart
	end

	return validParts
end