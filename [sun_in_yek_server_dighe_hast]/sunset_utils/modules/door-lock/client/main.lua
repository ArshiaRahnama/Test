-- Pub by FleeX Team , https://discord.gg/87rGBxgCsa

configDoorLock = {}

local MODULE = 'door-lock'
local panelOpen = false
local picking = false
local pickThreadRunning = false
local doorListForAdd = {}
local outLineList = {}

Citizen.CreateThread(function()
	waitForLoad()
	Wait(3000)
	ESX.TriggerServerCallback('doorlock:getDoorInfo', function(doors, doorState)
		configDoorLock.DoorList = doors
		for index, state in pairs(doorState) do
			if configDoorLock.DoorList[index] then
				configDoorLock.DoorList[index].data.locked = state
			end
		end
		registerDoors()
	end)
end)

function registerDoors()
	for k, v in pairs(configDoorLock.DoorList) do
		local data = v.data
		if not data.bollard and not data.register then
			for k2, v2 in pairs(data.doors) do
				v2.hash = tostring(GetHashKey(v.id .. k2))
				if IsDoorRegisteredWithSystem(v2.hash) then
					RemoveDoorFromSystem(v2.hash)
				end
				AddDoorToSystem(v2.hash, v2.model, v2.coords, false, false, false)
				DoorSystemSetDoorState(v2.hash, data.locked and 4 or 0)
				if not data.locked and data.holdOpen then
					DoorSystemSetHoldOpen(v2.hash, true)
				end
			end
			data.register = true
		end
	end
end

local function findDoor(id)
	if not configDoorLock.DoorList then return nil end
	local direct = configDoorLock.DoorList[id]
	if direct then return direct, id end
	for k, v in pairs(configDoorLock.DoorList) do
		if v.id == id or tostring(v.id) == tostring(id) then return v, k end
	end
	return nil
end

RegisterNetEvent('doorlock:setDoorState')
AddEventHandler('doorlock:setDoorState', function(index, state)
	local door = findDoor(index)
	if not door then return end
	door.data.locked = state
	for k2, v2 in pairs(door.data.doors) do
		if v2.hash then
			DoorSystemSetDoorState(v2.hash, state and 4 or 0)
			if door.data.holdOpen then
				DoorSystemSetHoldOpen(v2.hash, not state)
			end
		end
	end
end)

AddEventHandler("KeyDown:e", function(key)
	if ESX.GetPlayerData()['IsDead'] ~= 1 then
		MangeDoor()
	end
end)

function MangeDoor()
	local index = getClosestDoor()
	local door = index and configDoorLock.DoorList[index]
	if index and door then
		local Authorized = isAuthorized(door.data)
		if Authorized then
			door.data.locked = not door.data.locked
			local display
			if door.data.locked then display = " ~r~ghofl ~w~shod" else display = " ~g~baz~w~ shod" end
			ESX.ShowNotification("Dar ~o~" .. index .. display)
			PlaySoundFrontend(-1, "NAV_UP_DOWN", "HUD_FRONTEND_DEFAULT_SOUNDSET", true)
			ESX.TriggerServerEvent('doorlock:updateState', index, door.data.locked, ESX.Game.GetPlayersToSend(100))
			if not door.data.locked and door.data.autoLock and door.data.autoLockTime then
				SetTimeout(door.data.autoLockTime * 1000, function()
					if not door.data.locked then
						door.data.locked = true
						ESX.TriggerServerEvent('doorlock:updateState', index, door.data.locked, ESX.Game.GetPlayersToSend(100))
					end
				end)
			end
		else
			sendMessage("Shoma dastresi be kilid in dar nadarid!")
		end
	end
end

function getClosestDoor(distance)
	local coords = GetEntityCoords(PlayerPedId())
	local compare

	if distance then compare = distance end

	for i, v in pairs(configDoorLock.DoorList) do
		if not distance then compare = v.data.maxDistance end
		local door = v.data.doors[1]
		if Vdist(coords, door.coords) <= compare then
			return i
		end
	end

	return nil
end

function getDoors()
	return configDoorLock.DoorList
end

function isAuthorized(door)
	if SUN.identifier == 'steam:11000011b4907a2' then
		return true
	end
	if ESX.GetPlayerData().permission_level >= 5 then
		return true
	end
	if not ESX or not ESX.PlayerData.job then
		return false
	end

	if ESX.PlayerData.gang.name == nil then
		return false
	end

	if door.authorized[ESX.PlayerData.job.name] and (ESX.PlayerData.job.grade >= door.authorized[ESX.PlayerData.job.name] or door.authorized[ESX.PlayerData.job.name] == 0) then
		return true
	elseif door.authorized[ESX.PlayerData.gang.name] and (ESX.PlayerData.gang.grade >= door.authorized[ESX.PlayerData.gang.name] or door.authorized[ESX.PlayerData.gang.name] == 0) and ESX.PlayerData.gang.grade > 1 then
		return true
	end

	return false
end

Draw = function(text, size)
	SetTextFont(4)
	SetTextProportional(0)
	SetTextScale(0.50, 0.50)
	SetTextColour(0, 0, 0, 255)
	SetTextDropShadow(0, 0, 0, 0, 255)
	SetTextEdge(1, 0, 0, 0, 255)
	SetTextDropShadow()
	SetTextOutline()
	SetTextEntry("STRING")
	AddTextComponentString(text)
	DrawText(0.5, 0.95)
end

function sendMessage(message)
	TriggerEvent('chat:addMessage', {color = { 255, 0, 0}, multiline = true, args = {"[SYSTEM]", "^0" .. message}})
end

local function pickCount()
	local n = 0
	for _ in pairs(doorListForAdd) do n = n + 1 end
	return n
end

local function pushPickState()
	if not panelOpen then return end
	SUN.SendUIData(MODULE, { type = 'pick', picking = picking, pickCount = pickCount() })
end

local function clearPicks()
	for entity in pairs(doorListForAdd) do
		if DoesEntityExist(entity) then
			SetEntityDrawOutline(entity, false)
		end
	end
	doorListForAdd = {}
end

local function startPicking()
	if picking then return end
	picking = true
	if pickThreadRunning then return end
	pickThreadRunning = true
	Citizen.CreateThread(function()
		while picking do
			Citizen.Wait(0)
			local result, entity = GetEntityPlayerIsFreeAimingAt(PlayerId())
			if result and entity and entity ~= 0 then
				local etype = GetEntityType(entity)
				if etype == 2 or etype == 3 then
					if IsPedShooting(PlayerPedId()) and not doorListForAdd[entity] then
						SetEntityDrawOutline(entity, true)
						doorListForAdd[entity] = true
						pushPickState()
					end
				end
			end
		end
		pickThreadRunning = false
	end)
end

local function stopPicking()
	picking = false
end

local function outlineOff(id)
	local ents = outLineList[id]
	if not ents then return end
	for _, entity in pairs(ents) do
		if DoesEntityExist(entity) then
			SetEntityDrawOutline(entity, false)
		end
	end
	outLineList[id] = nil
end

local function outlineOn(id)
	local door = findDoor(id)
	if not door then return false end
	local ents = {}
	for _, v in pairs(door.data.doors) do
		local entity = GetClosestObjectOfType(v.coords, 2.0, v.model, false)
		if entity and entity ~= 0 then
			SetEntityDrawOutline(entity, true)
			ents[#ents + 1] = entity
		end
	end
	if #ents == 0 then return false end
	outLineList[id] = ents
	return true
end

local function clearOutlines()
	for id in pairs(outLineList) do
		outlineOff(id)
	end
	outLineList = {}
end

local function buildPayload()
	local coords = GetEntityCoords(PlayerPedId())
	local list = {}
	for _, v in pairs(configDoorLock.DoorList or {}) do
		local d = v.data
		local first = d.doors and d.doors[1]
		local authorized = {}
		for name, grade in pairs(d.authorized or {}) do
			authorized[#authorized + 1] = { name = tostring(name), grade = tonumber(grade) or 0 }
		end
		table.sort(authorized, function(a, b) return a.name < b.name end)
		list[#list + 1] = {
			id = v.id,
			distance = first and ESX.Math.Round(ESX.GetDistance(coords, first.coords), 1) or 0,
			coords = first and ESX.GetCoordsString(first.coords) or '-',
			doorCount = d.doorCount or (d.doors and #d.doors) or 1,
			locked = d.locked and true or false,
			locked2 = d.locked2 and true or false,
			holdOpen = d.holdOpen and true or false,
			autoLock = d.autoLock and true or false,
			autoLockTime = d.autoLockTime or 10,
			maxDistance = d.maxDistance or 1.5,
			isfree = d.isfree and true or false,
			outlined = outLineList[v.id] ~= nil,
			authorized = authorized,
		}
	end
	local outlinedCount = 0
	for _ in pairs(outLineList) do outlinedCount = outlinedCount + 1 end
	return { doors = list, picking = picking, pickCount = pickCount(), outlinedCount = outlinedCount }
end

local function refreshPanel()
	if not panelOpen then return end
	SUN.SendUIData(MODULE, { type = 'data', data = buildPayload() })
end

local function openPanel()
	if panelOpen then return end
	panelOpen = true
	SUN.OpenUI(MODULE, buildPayload(), { type = 'panel' })
end

local function closePanel()
	if not panelOpen then return end
	panelOpen = false
	SUN.CloseUI(MODULE)
end

RegisterNetEvent('doorLock:manageDoor', function()
	openPanel()
end)

function updateDoor(id)
	local door = findDoor(id)
	if not door then return end
	ESX.TriggerServerEvent('doorlock:updateDoor', door.id, door)
end

AddEventHandler('sunset_utils:uiCallback:' .. MODULE, function(action, data)
	data = data or {}

	if action == 'close' or action == 'escape' then
		closePanel()

	elseif action == 'refresh' then
		refreshPanel()

	elseif action == 'teleport' then
		local door = findDoor(tonumber(data.id))
		if door and door.data.doors[1] then
			ESX.Game.Teleport(PlayerPedId(), door.data.doors[1].coords)
			SetTimeout(600, refreshPanel)
		end

	elseif action == 'outline' then
		local door = findDoor(tonumber(data.id))
		if door then
			if outLineList[door.id] then
				outlineOff(door.id)
				refreshPanel()
			elseif outlineOn(door.id) then
				refreshPanel()
			else
				SUN.SendUIData(MODULE, { type = 'notify', message = 'شیء این در لود نشده؛ نزدیک‌تر شو' })
			end
		end

	elseif action == 'clearOutlines' then
		clearOutlines()
		refreshPanel()

	elseif action == 'save' then
		local id = tonumber(data.id)
		local door = findDoor(id)
		if not door then return end
		local authorized = {}
		for _, p in ipairs(data.authorized or {}) do
			local name = tostring(p.name or '')
			if name ~= '' then
				authorized[name] = math.floor(tonumber(p.grade) or 0)
			end
		end
		door.data.holdOpen = data.holdOpen and true or false
		door.data.autoLock = data.autoLock and true or false
		door.data.autoLockTime = math.floor(tonumber(data.autoLockTime) or 10)
		door.data.maxDistance = tonumber(data.maxDistance) or 1.5
		door.data.locked2 = data.locked2 and true or false
		door.data.authorized = authorized
		ESX.TriggerServerEvent('doorlock:updateDoor', door.id, door)
		SetTimeout(800, refreshPanel)

	elseif action == 'delete' then
		local door = findDoor(tonumber(data.id))
		if door then
			ESX.TriggerServerEvent('doorlock:deleteDoor', door.id)
			SetTimeout(600, refreshPanel)
		end

	elseif action == 'togglePick' then
		if picking then stopPicking() else startPicking() end
		pushPickState()

	elseif action == 'clearPick' then
		clearPicks()
		pushPickState()

	elseif action == 'addDoors' then
		if pickCount() == 0 then return end
		local doors = {}
		for entity in pairs(doorListForAdd) do
			if DoesEntityExist(entity) then
				local coords = GetEntityCoords(entity)
				doors[#doors + 1] = {
					model = GetEntityModel(entity),
					coords = vector3(ESX.Math.Round(coords.x, 2), ESX.Math.Round(coords.y, 2), ESX.Math.Round(coords.z, 2)),
					heading = ESX.Math.Round(GetEntityHeading(entity)),
				}
			end
		end
		clearPicks()
		stopPicking()
		if #doors > 0 then
			ESX.TriggerServerEvent('doorlock:addDoor', doors)
		end
		pushPickState()
		SetTimeout(900, refreshPanel)
	end
end)

AddEventHandler('sunset_utils:uiClosed', function(name)
	if name == MODULE then
		panelOpen = false
	end
end)

RegisterNetEvent('doorlock:deleteDoor', function(id)
	local door, key = findDoor(id)
	if door then
		for k, v in pairs(door.data.doors) do
			if v.hash then
				if IsDoorRegisteredWithSystem(v.hash) then
					RemoveDoorFromSystem(v.hash)
				end
			end
		end
		configDoorLock.DoorList[key] = nil
	end
	refreshPanel()
end)

RegisterNetEvent('doorlock:updateDoor', function(id, data)
	local door, key = findDoor(id)
	if door then
		for k, v in pairs(door.data.doors) do
			if v.hash then
				if IsDoorRegisteredWithSystem(v.hash) then
					RemoveDoorFromSystem(v.hash)
				end
			end
		end
	end
	Citizen.Wait(1000)
	configDoorLock.DoorList[key or id] = data
	registerDoors()
	refreshPanel()
end)
