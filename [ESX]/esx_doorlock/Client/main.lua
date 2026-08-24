ESX = nil
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

local showedEntity = nil
local _enabledDoors, _doorState = {}, {}
local DrawTxt = DrawTxt
local pulsed = false
local nearId = ""
local _coordsToShow = nil
local text = ""
local lazer = false
local PlayerData = false

TriggerEvent("chat:addSuggestion", Config.commands.CreateDoor, ("Add a door"), {})
TriggerEvent("chat:addSuggestion", Config.commands.RemoveDoor, ("Remove a door"), {})

local _doorType, _distToDoor, allowedJobs, doorPin, item = "normal", 2, {}, "", ""

Citizen.CreateThread(function()
    Citizen.Wait(2000)
    ESX.TriggerServerCallback('NUI_doorlock:cb:getDoors', function(doors, state)
        _enabledDoors = doors
        _doorState = state
    end)
	PlayerData = ESX.GetPlayerData()
end)

RegisterNetEvent("NUI_doorlock:client:setUpDoor", function()
    local elements = {}
    table.insert(elements, {label = "Door Type: " .._doorType, value = "doortype"})
    table.insert(elements, {label = "Distance To Door: " .._distToDoor, value = "doordist"})
    table.insert(elements, {label = "Add Job or Gang", value = "addjob"})
    table.insert(elements, {label = "Add Pin: " ..doorPin, value = "doorpin"})
    table.insert(elements, {label = "Add Item: " ..item, value = "dooritem"})
    for k, v in pairs(allowedJobs) do
        table.insert(elements, {label = v, value = k})
    end
    table.insert(elements, {label = "Confirm Creation", value = "conf"})
    ESX.UI.Menu.Open('default',GetCurrentResourceName(),"menu_door",
    {
    title = "Door Menu",
    align = "top-right",
    elements = elements,
    }, function(data, menu)
        local v = data.current.value
        if v == "doortype" then
            ESX.UI.Menu.Open('default',GetCurrentResourceName(),"menu_door2",
            {
            title = "Type Menu",
            align = "top-right",
            elements = {
                {label = "Slider", value = "slide"},
                {label = "Normal", value = "normal"},
                {label = "Double", value = "double"},
            },
            }, function(data2, menu2)
                local v = data2.current.value
                _doorType = v
                menu2.close()
                ExecuteCommand(Config.commands.CreateDoor)
            end, function(data2, menu2)
                menu2.close()
                ExecuteCommand(Config.commands.CreateDoor)
            end)
        elseif v == "doordist" then
            ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'dist_to_door', {
                title = 'Distance to door'
            }, function(data2, menu2)
                local dist = tonumber(data2.value)
                if dist == nil then
                ESX.ShowNotification('~r~Invalid Distance, Try Again')
				else
                    menu2.close()
                    _distToDoor = dist
                    ExecuteCommand(Config.commands.CreateDoor)
                end
            end, function(data2, menu2)
                menu2.close()
                ExecuteCommand(Config.commands.CreateDoor)
            end)
        elseif v == "addjob" then
            ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'new_job', {
                title = 'Introduce The Job Name'
            }, function(data2, menu2)
                local job = data2.value
                if job == nil then
                    ESX.ShowNotification('~r~Invalid Job, Try Again')
                else
                    menu2.close()
                    table.insert(allowedJobs, job)
                    ESX.UI.Menu.CloseAll()
                    ExecuteCommand(Config.commands.CreateDoor)

                end
            end, function(data2, menu2)
                menu2.close()
                ESX.UI.Menu.CloseAll()
                ExecuteCommand(Config.commands.CreateDoor)
            end)
        elseif v == "conf" then
            addDoor(_doorType, _distToDoor, allowedJobs, doorPin, item)
            ESX.UI.Menu.CloseAll()
            _doorType = "normal"
            _distToDoor = 2
            doorPin = ""
            allowedJobs = {}
        elseif v == "doorpin" then
            ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'new_job', {
                title = 'Introduce The Door Pin'
            }, function(data2, menu2)
                local pin = data2.value
                if pin == nil then
                    ESX.ShowNotification('~r~Invalid Pin, Try Again')
                else
                    doorPin = pin
                    ESX.UI.Menu.CloseAll()
                    ExecuteCommand(Config.commands.CreateDoor)
                end
            end, function(data2, menu2)
                menu2.close()
                ESX.UI.Menu.CloseAll()
                ExecuteCommand(Config.commands.CreateDoor)
            end)
        elseif v == "dooritem" then
            ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'new_jobitem', {
                title = 'Introduce The Door Item'
            }, function(data2, menu2)
                local pin = data2.value
                if pin == nil then
                    ESX.ShowNotification('~r~Invalid Item, Try Again')
                else
                    item = pin
                    ESX.UI.Menu.CloseAll()
                    ExecuteCommand(Config.commands.CreateDoor)
                end
            end, function(data2, menu2)
                menu2.close()
                ESX.UI.Menu.CloseAll()
                ExecuteCommand(Config.commands.CreateDoor)
            end)
        else
            for key, val in pairs(allowedJobs) do
                if k == tonumber(val) then
                    table.remove(allowedJobs, k)
                end
            end
            menu.close()
            ExecuteCommand(Config.commands.CreateDoor)
        end
    end, function(data, menu)
        menu.close()
        _doorType = "normal"
        _distToDoor = 2
        doorPin = ""
        allowedJobs = {}
    end)
end)

RegisterNetEvent("NUI_doorlock:client:deleteDoor", function()
	lazer = not lazer
	Wait(1)
    Citizen.CreateThread(function()
        while true do
			if not lazer then break end
            local _Wait = 0
            local _ped = PlayerPedId()
            local _coords = GetEntityCoords(_ped)
            local hit, coords, entity = RayCastGamePlayCamera(5000.0)
            local _found = false
            DrawLine(_coords, coords, 255, 0, 0, 255)
            ESX.ShowHelpNotification("Press ~INPUT_CONTEXT~ To ~r~Remove ~w~The Door")
            for k, v in pairs(_enabledDoors) do
                if v._type ~= "double" then
                    local _doorCoords = vector3(v.doorCoords.x, v.doorCoords.y, v.doorCoords.z)
                    DrawMarker(28, _doorCoords, 0.0, 0.0, 0.0, 0.0, 180.0, 0.0, 0.18, 0.18, 0.18, 255, 0, 0, 100, false, true, 2, nil, nil, false)
                else
                    local _doorCoords = vector3(v._textCoords.x, v._textCoords.y, v._textCoords.z)
                    DrawMarker(28, _doorCoords, 0.0, 0.0, 0.0, 0.0, 180.0, 0.0, 0.18, 0.18, 0.18, 255, 0, 0, 100, false, true, 2, nil, nil, false)
                end
            end
            if IsControlJustPressed(1, 38) then
                for k, v in pairs(_enabledDoors) do
                    if v._type ~= "double" then
                        local _doorCoords = vector3(v.doorCoords.x, v.doorCoords.y, v.doorCoords.z)
                        local _distTo = #(coords - _doorCoords)
                        if _distTo < 1 then
                            TriggerServerEvent("NUI_doorlock:server:syncRemove", k)
                            _found = true
                        end
                    else
                        local _doorCoords = vector3(v._textCoords.x, v._textCoords.y, v._textCoords.z)
                        local _distTo = #(coords - _doorCoords)
                        if _distTo < 1 then
                            TriggerServerEvent("NUI_doorlock:server:syncRemove", k)
                            _found = true
                        end
                    end
                end
                if _found then
                    ESX.ShowNotification("~g~The Door Was Deleted")
					lazer = false
                    break
                else
                    ESX.ShowNotification("~r~The Door Wasn't Deleted")
                end
            end
            Citizen.Wait(_Wait)
        end
    end)
end)

RegisterNetEvent("NUI_doorlock:client:removeGlobDoor", function(id)
    table.remove(_enabledDoors, id)
end)

AddEventHandler("onResourceStop", function(resource)
    if resource == GetCurrentResourceName() then
        SetEntityDrawOutline(showedEntity, false)
    end
end)

addDoor = function(type, dist, jobs, pin, item)
	lazer = not lazer
    dist = tonumber(dist)
    if not dist then
        dist = 2
    end
    if type ~= "double" then
        Citizen.CreateThread(function()
            while true do
				if not lazer then break end
                local _Wait = 5
                local _ped = PlayerPedId()
                local _coords = GetEntityCoords(_ped)
                local hit, coords, entity = RayCastGamePlayCamera(5000.0)
                if IsEntityAnObject(entity) then
                    ESX.ShowHelpNotification("Press ~INPUT_CONTEXT~ To ~g~Add ~w~The Door")
                    DrawLine(_coords, coords, 0, 255, 34, 255)
                    if showedEntity ~= entity then
                        SetEntityDrawOutline(showedEntity, false)
                        showedEntity = entity
                    end
                    if IsControlJustPressed(1, 38) then
                        local _doorCoords = GetEntityCoords(entity)
                        local _doorModel = GetEntityModel(entity)
                        local _heading = GetEntityHeading(entity)
                        local _textCoords = coords
                        TriggerServerEvent("NUI_doorlock:server:addDoor", _doorCoords, _doorModel, _heading, type, _textCoords, dist, jobs, pin, item)
                        SetEntityDrawOutline(entity, false)
						lazer = false
                        break
                    end
                    SetEntityDrawOutline(entity, true)
                else
                    if showedEntity ~= entity then
                        SetEntityDrawOutline(showedEntity, false)
                        showedEntity = entity
                    end
                end
                Citizen.Wait(_Wait)
            end
        end)
    else
        local _doorsDobule, entities = {}, {}
        Citizen.CreateThread(function()
            while true do
				if not lazer then break end
                local _Wait = 5
                local _ped = PlayerPedId()
                local _coords = GetEntityCoords(_ped)
                local hit, coords, entity = RayCastGamePlayCamera(5000.0)
                if IsEntityAnObject(entity) then
                    for k, v in pairs(entities) do
                        SetEntityDrawOutline(v, true)
                    end
                    if #_doorsDobule ~= 2 then
                        DrawLine(_coords, coords, 0, 255, 34, 255)
                        ESX.ShowHelpNotification("Press ~INPUT_CONTEXT~ To ~g~Add a Door")
                    else
                        DrawLine(_coords, coords, 0, 255, 34, 255)
                        ESX.ShowHelpNotification("Press ~INPUT_CONTEXT~ To Confirm And Point To The Coords Where The Text Will Be Added (Important)")
                    end
                    showedEntity = entity
                    if IsControlJustPressed(1, 38) then
                        local _doorCoords = GetEntityCoords(entity)
                        local _doorModel = GetEntityModel(entity)
                        local _heading = GetEntityHeading(entity)
                        local _textCoords = coords
                        if #_doorsDobule == 2 then
                            for k, v in pairs(entities) do
                                SetEntityDrawOutline(v, false)
                            end
                            entities = {}
                            TriggerServerEvent("NUI_doorlock:server:addDoubleDoor", _doorsDobule, type, _textCoords, dist, jobs, pin, item)
                            _doorsDobule = {}
							lazer = false
                            break
                        else
                            table.insert(_doorsDobule, {coords = _doorCoords, model = _doorModel, heading = _heading})
                            table.insert(entities, entity)
                        end
                    end
                end
                Citizen.Wait(_Wait)
            end
        end)
    end
end

RegisterNetEvent("NUI_doorlock:client:refreshDoors", function(tableToIns)
    table.insert(_enabledDoors, tableToIns)
end)

local _selectedDoorJobs, pin, object = {}, nil, nil

Citizen.CreateThread(function()
    while true do
        local isNearToDoor = false
        local _Wait = 800
        for k, v in pairs(_enabledDoors) do
            local _doorHash = GetHashKey(v._doorModel)
            local _ped = PlayerPedId()
            local _coords = GetEntityCoords(_ped)

            if v._type == "normal" then
                local _doorCoords = vector3(v.doorCoords.x, v.doorCoords.y, v.doorCoords.z)
                local _distTo = #(_coords - _doorCoords)
                if _distTo < 30 then
                    door = GetClosestObjectOfType(v.doorCoords.x, v.doorCoords.y, v.doorCoords.z, 1.0, v._doorModel, false, false, false)
                    if _doorState[k] ~= nil then
                        FreezeEntityPosition(door, false)
                    else
                        FreezeEntityPosition(door, true)
                    end
                end
                if _distTo < v.dist then
                    door = GetClosestObjectOfType(v.doorCoords.x, v.doorCoords.y, v.doorCoords.z, 1.0, v._doorModel, false, false, false)
                    _coordsToShow = vector3(v._textCoords.x, v._textCoords.y, v._textCoords.z)
                    isNearToDoor = true
                    _selectedDoorJobs = v.jobs
                    if v.usePin then
                        pin = v.pin
                    else
                        pin = nil
                    end
                    if v.useitem then
                        object = v.item
                    else
                        object = nil
                    end
                    if _doorState[k] ~= nil then
                        text = Config.strings.close
                        FreezeEntityPosition(door, false)
                        if pulsed then
                            TriggerServerEvent("NUI_doorlock:server:updateDoor", k, nil)
                            animatePlyDoor()
                            pulsed = false
                        end
                    else
                        FreezeEntityPosition(door, true)
                        text = Config.strings.open
                        if pulsed then
                            TriggerServerEvent("NUI_doorlock:server:updateDoor", k, "locked")
                            animatePlyDoor()
                            pulsed = false
                        end
                        if v._type == "normal" then
                            SetEntityHeading(door, v._heading)
                        end
                    end

                    _Wait = 120
                end
            elseif v._type == "double" then
                local _doorCoords = vector3(v._doorsDouble[1].coords.x, v._doorsDouble[1].coords.y, v._doorsDouble[1].coords.z)
                local _doorCoords2 = vector3(v._doorsDouble[2].coords.x, v._doorsDouble[2].coords.y, v._doorsDouble[2].coords.z)
                local _distTo = #(_coords - vector3(v._textCoords.x, v._textCoords.y, v._textCoords.z))
                if _distTo < 30 then
                    _coordsToShow = vector3(v._textCoords.x, v._textCoords.y, v._textCoords.z)
                    door1 = GetClosestObjectOfType(_doorCoords, 1.0, v._doorsDouble[1].model, false, false, false)
                    door2 = GetClosestObjectOfType(_doorCoords2, 1.0, v._doorsDouble[2].model, false, false, false)
                    if _doorState[k] ~= nil then
                        FreezeEntityPosition(door1, false)
                        FreezeEntityPosition(door2, false)
                    else
                        FreezeEntityPosition(door1, true)
                        FreezeEntityPosition(door2, true)
                        SetEntityHeading(door1, v._doorsDouble[1].heading)
                        SetEntityHeading(door2, v._doorsDouble[2].heading)
                    end
                    if _distTo < v.dist then
                        if v.usePin then
                            pin = v.pin
                        else
                            pin = nil
                        end
                        if v.useitem then
                            object = v.item
                        else
                            object = nil
                        end
                        _selectedDoorJobs = v.jobs
                        if _doorState[k] ~= nil then
                            isNearToDoor = true
                            text = Config.strings.close
                            FreezeEntityPosition(door1, false)
                            FreezeEntityPosition(door2, false)
                            if pulsed then
                                TriggerServerEvent("NUI_doorlock:server:updateDoor", k, nil)
                                animatePlyDoor()
                                pulsed = false
                                pin = nil
                            end
                        else
                            isNearToDoor = true
                            FreezeEntityPosition(door1, true)
                            FreezeEntityPosition(door2, true)
                            text = Config.strings.open
                            if pulsed then
                                TriggerServerEvent("NUI_doorlock:server:updateDoor", k, "locked")
                                animatePlyDoor()
                                pulsed = false
                                pin = nil
                            end
                            SetEntityHeading(door1, v._doorsDouble[1].heading)
                            SetEntityHeading(door2, v._doorsDouble[2].heading)
                        end
                        _Wait = 120
                    end
                end
            else
                local _doorCoords = vector3(v.doorCoords.x, v.doorCoords.y, v.doorCoords.z)
                local _distTo = #(_coords - _doorCoords)
                if _distTo < 30 then
                    door = GetClosestObjectOfType(v.doorCoords.x, v.doorCoords.y, v.doorCoords.z, 1.0, v._doorModel, false, false, false)
                    if not IsDoorRegisteredWithSystem(v._doorModel.. "door"..k) then
                        AddDoorToSystem(v._doorModel.. "door"..k, v._doorModel, _doorCoords, false, false, false)
                        print(k.. " - Slider Registered")
                    end
                    if _doorState[k] ~= nil then
                        DoorSystemSetDoorState(v._doorModel.. "door"..k, 0, false, false)
                        DoorSystemSetAutomaticDistance(v._doorModel.. "door"..k, 30.0, false, false)
                    else
                        DoorSystemSetAutomaticDistance(v._doorModel.. "door"..k, 0.0, false, false)
                        DoorSystemSetDoorState(v._doorModel.. "door"..k, 4, false, false)
                    end
                end
                if _distTo < v.dist then
                    door = GetClosestObjectOfType(v.doorCoords.x, v.doorCoords.y, v.doorCoords.z, 1.0, v._doorModel, false, false, false)
                    _coordsToShow = vector3(v._textCoords.x, v._textCoords.y, v._textCoords.z)
                    isNearToDoor = true
                    _selectedDoorJobs = v.jobs
                    if v.usePin then
                        pin = v.pin
                    else
                        pin = nil
                    end
                    if v.useitem then
                        object = v.item
                    else
                        object = nil
                    end
                    if _doorState[k] ~= nil then
                        text = Config.strings.close
                        DoorSystemSetDoorState(v._doorModel.. "door"..k, 0, false, false)
                        DoorSystemSetAutomaticDistance(v._doorModel.. "door"..k, 30.0, false, false)
                        if pulsed then
                            TriggerServerEvent("NUI_doorlock:server:updateDoor", k, nil)
                            animatePlyDoor()
                            pulsed = false
                        end
                    else
                        DoorSystemSetDoorState(v._doorModel.. "door"..k, 4, false, false)
                        DoorSystemSetAutomaticDistance(v._doorModel.. "door"..k, 0.0, false, false)
                        text = Config.strings.open
                        if pulsed then
                            TriggerServerEvent("NUI_doorlock:server:updateDoor", k, "locked")
                            animatePlyDoor()
                            pulsed = false
                        end
                    end

                    _Wait = 120
                end
            end
        end
        if isNearToDoor then
            show = true
        else
            show = false
        end
        Citizen.Wait(_Wait)
    end
end)

animatePlyDoor = function()
	Citizen.CreateThread(function()
        while not HasAnimDictLoaded("anim@heists@keycard@") do
            RequestAnimDict("anim@heists@keycard@")
            Citizen.Wait(1)
        end
        TaskPlayAnim(PlayerPedId(), "anim@heists@keycard@", "exit", 8.0, 1.0, -1, 16, 0, 0, 0, 0)
        Citizen.Wait(200)
        ClearPedTasks(PlayerPedId())
	end)
end

local _nuiDone = false

Citizen.CreateThread(function()
    while true do
        local _Wait = 800
        if show then
            if Config.enableNuiIndicator then
                SendNUIMessage({
                    show = true;
                    text = replaceColorText(text);
                })
                _nuiDone = false
                _Wait = 500
            else
                _Wait = 3
                DrawTxt(_coordsToShow, text, 0.7, 8)
            end
        else
            if Config.enableNuiIndicator then
                if not _nuiDone then
                    SendNUIMessage({
                        show = false;
                    })
                    _nuiDone = true
                end
            end
        end
        Citizen.Wait(_Wait)
    end
end)

DrawTxt = function(coords, text, size, font)
    local coords = vector3(coords.x, coords.y, coords.z)

    local camCoords = GetGameplayCamCoords()
    local distance = #(coords - camCoords)

    if not size then size = 1 end
    if not font then font = 0 end

    local scale = (size / distance) * 2
    local fov = (1 / GetGameplayCamFov()) * 100
    scale = scale * fov

    SetTextScale(0.0 * scale, 0.55 * scale)
    SetTextFont(font)
    SetTextColour(255, 255, 255, 215)
    SetTextDropshadow(0, 0, 0, 0, 255)
    SetTextEdge(2, 0, 0, 0, 150)
    SetTextDropShadow()
    SetTextOutline()
    SetTextEntry("STRING")
    SetTextCentre(true)

    SetDrawOrigin(coords, 0)
    BeginTextCommandDisplayText('STRING')
    AddTextComponentSubstringPlayerName(text)
    EndTextCommandDisplayText(0.0, 0.0)
    ClearDrawOrigin()
end

RegisterNetEvent("NUI_doorlock:client:updateDoorState", function(id, type, h)
    _doorState[id] = type
end)

RegisterNetEvent("esx:setJob")
AddEventHandler("esx:setJob",function(job)
	PlayerData.job = job
end)

RegisterNetEvent("esx:setGang")
AddEventHandler("esx:setGang",function(gang)
	PlayerData.gang = gang
end)

RegisterCommand("lockdoor", function()
    if show then
        local _allowed = false
        for k, v in pairs(_selectedDoorJobs) do
            if ((v == PlayerData.job.name) or (v == PlayerData.gang.name)) then
                _allowed = true
            end
        end
        if _allowed then
            pulsed = true
            return
        end
        if not allowed then
            if pin then
                ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'intr_pin', {
                    title = 'Introduce the pin'
                }, function(data2, menu2)
                    local pinIntr = data2.value
                    if pinIntr ~= pin then
                        ESX.ShowNotification('~r~Invalid Pin, Try Again')

                        ESX.UI.Menu.CloseAll()
                    else
                        pulsed = true
                        menu2.close()
                        ESX.UI.Menu.CloseAll()
                        pin = nil
                    end
                end, function(data2, menu2)
                    menu2.close()
                    ESX.UI.Menu.CloseAll()
                end)
            else
                ESX.ShowNotification('~r~Shoma Dastrasi Nadarid')
            end
            if object then
                ESX.TriggerServerCallback('NUI_doorlock:cb:hasObj', function(has)
                    if has then
                        pulsed = true
                        object = nil
                    end
                end, object)
            end
        end
    end
end)

RegisterKeyMapping("lockdoor", "Lock a door", 'keyboard', 'e')

RayCastGamePlayCamera = function(distance)
    local cameraRotation = GetGameplayCamRot()
	local cameraCoord = GetGameplayCamCoord()
	local direction = RotationToDirection(cameraRotation)
	local destination =
	{
		x = cameraCoord.x + direction.x * distance,
		y = cameraCoord.y + direction.y * distance,
		z = cameraCoord.z + direction.z * distance
	}
	local a, b, c, d, e = GetShapeTestResult(StartShapeTestRay(cameraCoord.x, cameraCoord.y, cameraCoord.z, destination.x, destination.y, destination.z, -1, PlayerPedId(), 0))
	return b, c, e
end

replaceColorText = function(text)
    text = text:gsub("~r~", "<span class='red'>")
    text = text:gsub("~b~", "<span class='blue'>")
    text = text:gsub("~g~", "<span class='green'>")
    text = text:gsub("~y~", "<span class='yellow'>")
    text = text:gsub("~p~", "<span class='purple'>")
    text = text:gsub("~c~", "<span class='grey'>")
    text = text:gsub("~m~", "<span class='darkgrey'>")
    text = text:gsub("~u~", "<span class='black'>")
    text = text:gsub("~o~", "<span class='gold'>")
    text = text:gsub("~s~", "</span>")
    text = text:gsub("~w~", "</span>")
    text = text:gsub("~b~", "<b>")
    text = text:gsub("~n~", "<br>")
    text = "<span>" .. text .. "</span>"
    return text
end

RotationToDirection = function(rotation)
	local adjustedRotation =
	{
		x = (math.pi / 180) * rotation.x,
		y = (math.pi / 180) * rotation.y,
		z = (math.pi / 180) * rotation.z
	}
	local direction =
	{
		x = -math.sin(adjustedRotation.z) * math.abs(math.cos(adjustedRotation.x)),
		y = math.cos(adjustedRotation.z) * math.abs(math.cos(adjustedRotation.x)),
		z = math.sin(adjustedRotation.x)
	}
	return direction
end
