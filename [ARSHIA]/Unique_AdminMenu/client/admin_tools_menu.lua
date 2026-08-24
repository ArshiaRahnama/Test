

SelectedTargetId = nil
SavedLocationsCache = {}

Citizen.CreateThread(function()
    WarMenu.CreateSubMenu('select_target', 'main', 'Select Target Player')
    WarMenu.CreateSubMenu('player_tools', 'main', 'Player Tools')
    WarMenu.CreateSubMenu('vehicle_tools', 'main', 'Vehicle Tools')
    WarMenu.CreateSubMenu('world_tools', 'main', 'World Tools')
    WarMenu.CreateSubMenu('saved_locations', 'world_tools', 'Saved Locations')
    WarMenu.CreateSubMenu('server_tools', 'main', 'Server Tools')
end)

local function OpenPlayerTools()
    AdminM()
    WarMenu.OpenMenu('select_target')
end

local function DrawSelectTargetMenu()
    for i = 1, GetLast(PlayersCache) do
        if PlayersCache[i] then
            if WarMenu.Button("[" .. i .. "] " .. PlayersCache[i]) then
                SelectedTargetId = i
                WarMenu.OpenMenu('player_tools')
            end
        end
    end
end

local function DrawPlayerToolsMenu()
    if not SelectedTargetId then
        WarMenu.OpenMenu('select_target')
        return
    end

    if WarMenu.Button("Target: [" .. SelectedTargetId .. "] " .. (PlayersCache[SelectedTargetId] or "?")) then
        OpenPlayerTools()
    end

    if WarMenu.Button("Freeze / Unfreeze") then
        TriggerServerEvent('Unique_AdminMenu:FreezePlayer', SelectedTargetId)
    end

    if WarMenu.Button("Heal") then
        TriggerServerEvent('Unique_AdminMenu:HealPlayer', SelectedTargetId)
    end

    if WarMenu.Button("Revive") then
        TriggerServerEvent('Unique_AdminMenu:RevivePlayer', SelectedTargetId)
    end

    if WarMenu.Button("Inspect") then
        ESX.TriggerServerCallback('Unique_AdminMenu:InspectPlayer', function(data)
            if not data then
                drawNotification("~r~Could not inspect that player")
                return
            end
            SendNUIMessage({ type = 'inspect', data = data })
            SetNuiFocus(true, true)
            InAdminNui = true
        end, SelectedTargetId)
    end

    if WarMenu.Button("Add Note") then
        local note = GetUserInput("Note about this player", "", 200) or ""
        if note ~= "" then
            TriggerServerEvent('Unique_AdminMenu:AddNote', SelectedTargetId, note)
            drawNotification("~b~Note saved")
        end
    end

    if WarMenu.Button("Kick") then
        local reason = GetUserInput("Kick reason") or ""
        ExecuteCommand('akick ' .. SelectedTargetId .. ' ' .. reason)
    end

    if WarMenu.Button("Ban (minutes)") then
        local dur = GetUserInput("Minutes (or type perm)", "60") or ""
        local reason = GetUserInput("Ban reason") or ""
        ExecuteCommand('aban ' .. SelectedTargetId .. ' ' .. dur .. ' ' .. reason)
    end

    if WarMenu.Button("Warn") then
        local reason = GetUserInput("Warn reason") or ""
        ExecuteCommand('awarn ' .. SelectedTargetId .. ' ' .. reason)
    end

    if WarMenu.Button("Set Job/Grade") then
        local job = GetUserInput("Job name (e.g. police)") or ""
        local grade = GetUserInput("Grade", "0") or "0"
        ExecuteCommand('asetjob ' .. SelectedTargetId .. ' ' .. job .. ' ' .. grade)
    end

    if WarMenu.Button("Give Money") then
        local acc = GetUserInput("Account: money or bank", "money") or "money"
        local amt = GetUserInput("Amount", "1000") or "0"
        local reason = GetUserInput("Reason") or ""
        ExecuteCommand('agivemoney ' .. SelectedTargetId .. ' ' .. acc .. ' ' .. amt .. ' ' .. reason)
    end

    if WarMenu.Button("Remove Money") then
        local acc = GetUserInput("Account: money or bank", "money") or "money"
        local amt = GetUserInput("Amount", "1000") or "0"
        local reason = GetUserInput("Reason") or ""
        ExecuteCommand('aremovemoney ' .. SelectedTargetId .. ' ' .. acc .. ' ' .. amt .. ' ' .. reason)
    end

    if WarMenu.Button("Impound Vehicle") then
        TriggerServerEvent('Unique_AdminMenu:ImpoundTarget', SelectedTargetId)
    end
end

local function DrawVehicleToolsMenu()
    if WarMenu.Button("Spawn Vehicle") then
        local model = GetUserInput("Vehicle model name", "adder") or ""
        if model ~= "" then
            local plate = GetUserInput("Plate (optional)", "") or ""
            TriggerServerEvent('Unique_AdminMenu:SpawnVehicle', model, plate)
        end
    end

    if WarMenu.Button("Fix/Repair current vehicle") then
        TriggerServerEvent('Unique_AdminMenu:VehicleAction', 'fix')
    end

    if WarMenu.Button("Clean current vehicle") then
        TriggerServerEvent('Unique_AdminMenu:VehicleAction', 'clean')
    end

    if WarMenu.Button("Delete nearest empty vehicle") then
        TriggerServerEvent('Unique_AdminMenu:VehicleAction', 'deletenearest')
    end
end

local WeatherPresets = { "EXTRASUNNY", "CLEAR", "CLOUDS", "OVERCAST", "RAIN", "THUNDER", "SMOG", "FOGGY", "XMAS", "SNOWLIGHT", "BLIZZARD" }

local function DrawWorldToolsMenu()
    if WarMenu.Button("Set Weather") then
        local weather = GetUserInput(table.concat(WeatherPresets, "/"), "CLEAR") or ""
        if weather ~= "" then
            TriggerServerEvent('Unique_AdminMenu:SetWeather', weather:upper())
        end
    end

    if WarMenu.Button("Set Time") then
        local hour = GetUserInput("Hour (0-23)", "12") or "12"
        local minute = GetUserInput("Minute (0-59)", "0") or "0"
        TriggerServerEvent('Unique_AdminMenu:SetTime', hour, minute)
    end

    if WarMenu.Button("Teleport to Waypoint") then
        local waypoint = GetFirstBlipInfoId(8)
        if DoesBlipExist(waypoint) then
            local coords = GetBlipInfoIdCoord(waypoint)
            local groundZ = getGroundZ(coords.x, coords.y, 1000.0)
            TriggerServerEvent('Unique_AdminMenu:TeleportCoords', coords.x, coords.y, groundZ > 0 and groundZ or coords.z)
        else
            drawNotification("~r~No waypoint set on the map")
        end
    end

    if WarMenu.Button("Teleport to Coords") then
        local x = GetUserInput("X") or ""
        local y = GetUserInput("Y") or ""
        local z = GetUserInput("Z") or ""
        if x ~= "" and y ~= "" and z ~= "" then
            TriggerServerEvent('Unique_AdminMenu:TeleportCoords', x, y, z)
        end
    end

    if WarMenu.Button("Save current location") then
        local name = GetUserInput("Location name") or ""
        if name ~= "" then
            local c = GetEntityCoords(PlayerPedId())
            TriggerServerEvent('Unique_AdminMenu:SaveLocation', name, c.x, c.y, c.z)
        end
    end

    WarMenu.MenuButton('Saved Locations', 'saved_locations')
end

local function DrawSavedLocationsMenu()
    if #SavedLocationsCache == 0 then
        ESX.TriggerServerCallback('Unique_AdminMenu:GetSavedLocations', function(rows)
            SavedLocationsCache = rows
        end)
    end
    for i = 1, #SavedLocationsCache do
        local loc = SavedLocationsCache[i]
        if WarMenu.Button(loc.name) then
            TriggerServerEvent('Unique_AdminMenu:TeleportCoords', loc.x, loc.y, loc.z)
        end
    end
    if WarMenu.Button("Refresh list") then
        SavedLocationsCache = {}
    end
end

local function DrawServerToolsMenu()
    if WarMenu.Button("Announce to server") then
        local msg = GetUserInput("Announcement text", "", 120) or ""
        if msg ~= "" then
            TriggerServerEvent('_chat:messageEntered', 'AdminAnnounce', {}, msg)
            ExecuteCommand('aannounce ' .. msg)
        end
    end

    if WarMenu.Button("Restart Resource") then
        local res = GetUserInput("Resource to restart (requires ACE: command.arestart)") or ""
        if res ~= "" then
            ExecuteCommand('arestart ' .. res)
        end
    end

    if WarMenu.Button("Report Queue") then
        OpenReportsMenu()
    end

    if WarMenu.Button("Chat Log") then
        ESX.TriggerServerCallback('Unique_AdminMenu:GetChatLog', function(log)
            SendNUIMessage({ type = 'chatlog', data = log })
            SetNuiFocus(true, true)
            InAdminNui = true
        end)
    end
end

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        if WarMenu.IsMenuOpened('select_target') then
            DrawSelectTargetMenu()
            WarMenu.Display()
        elseif WarMenu.IsMenuOpened('player_tools') then
            DrawPlayerToolsMenu()
            WarMenu.Display()
        elseif WarMenu.IsMenuOpened('vehicle_tools') then
            DrawVehicleToolsMenu()
            WarMenu.Display()
        elseif WarMenu.IsMenuOpened('world_tools') then
            DrawWorldToolsMenu()
            WarMenu.Display()
        elseif WarMenu.IsMenuOpened('saved_locations') then
            DrawSavedLocationsMenu()
            WarMenu.Display()
        elseif WarMenu.IsMenuOpened('server_tools') then
            DrawServerToolsMenu()
            WarMenu.Display()
        end
    end
end)

RegisterNetEvent('Unique_AdminMenu:ApplyFreeze')
AddEventHandler('Unique_AdminMenu:ApplyFreeze', function(frozen)
    FreezeEntityPosition(PlayerPedId(), frozen)
    drawNotification(frozen and "~b~You have been frozen by an admin" or "~r~You have been unfrozen")
end)

RegisterNetEvent('Unique_AdminMenu:ApplyHeal')
AddEventHandler('Unique_AdminMenu:ApplyHeal', function()
    SetEntityHealth(PlayerPedId(), GetEntityMaxHealth(PlayerPedId()))
    drawNotification("~b~You have been healed by an admin")
end)

RegisterNetEvent('Unique_AdminMenu:ApplyRevive')
AddEventHandler('Unique_AdminMenu:ApplyRevive', function()
    local ped = PlayerPedId()
    NetworkResurrectLocalPlayer(GetEntityCoords(ped), GetEntityHeading(ped), true, false)
    SetEntityHealth(ped, GetEntityMaxHealth(ped))
    ClearPedBloodDamage(ped)
    drawNotification("~b~You have been revived by an admin")
end)

RegisterNetEvent('Unique_AdminMenu:ApplySpawnVehicle')
AddEventHandler('Unique_AdminMenu:ApplySpawnVehicle', function(model, plate)
    local hash = GetHashKey(model)
    RequestModel(hash)
    local tries = 0
    while not HasModelLoaded(hash) and tries < 200 do
        Citizen.Wait(10)
        tries = tries + 1
    end
    if not HasModelLoaded(hash) then
        drawNotification("~r~Unknown vehicle model: " .. model)
        return
    end
    local coords = GetEntityCoords(PlayerPedId())
    local heading = GetEntityHeading(PlayerPedId())
    local veh = CreateVehicle(hash, coords.x, coords.y, coords.z, heading, true, false)
    SetVehicleNumberPlateText(veh, plate)
    SetPedIntoVehicle(PlayerPedId(), veh, -1)
    SetModelAsNoLongerNeeded(hash)
end)

RegisterNetEvent('Unique_AdminMenu:ApplyVehicleAction')
AddEventHandler('Unique_AdminMenu:ApplyVehicleAction', function(action)
    if action == 'deletenearest' then
        local coords = GetEntityCoords(PlayerPedId())
        local veh = GetClosestVehicle(coords.x, coords.y, coords.z, 5.0, 0, 70)
        if veh and veh ~= 0 and GetPedInVehicleSeat(veh, -1) == 0 then
            DeleteEntity(veh)
            drawNotification("~b~Nearest empty vehicle deleted")
        else
            drawNotification("~r~No empty vehicle nearby")
        end
        return
    end

    local ped = PlayerPedId()
    if not IsPedInAnyVehicle(ped, false) then
        drawNotification("~r~You are not in a vehicle")
        return
    end
    local veh = GetVehiclePedIsIn(ped, false)
    if action == 'fix' then
        SetVehicleFixed(veh)
        SetVehicleDeformationFixed(veh)
        SetVehicleUndriveable(veh, false)
        SetVehicleEngineOn(veh, true, true, false)
        drawNotification("~b~Vehicle repaired")
    elseif action == 'clean' then
        SetVehicleDirtLevel(veh, 0.0)
        WashDecalsFromVehicle(veh, 1.0)
        drawNotification("~b~Vehicle cleaned")
    end
end)

RegisterNetEvent('Unique_AdminMenu:ApplyImpound')
AddEventHandler('Unique_AdminMenu:ApplyImpound', function()
    local ped = PlayerPedId()
    if IsPedInAnyVehicle(ped, false) then
        DeleteEntity(GetVehiclePedIsIn(ped, false))
    end
    drawNotification("~b~Your vehicle has been impounded by an admin")
end)

RegisterNetEvent('Unique_AdminMenu:ApplyWeather')
AddEventHandler('Unique_AdminMenu:ApplyWeather', function(weatherName)
    ClearWeatherTypePersist()
    SetWeatherTypeOvertimePersist(weatherName, 5.0)
    drawNotification("~b~Weather set to " .. weatherName)
end)

RegisterNetEvent('Unique_AdminMenu:ApplyTime')
AddEventHandler('Unique_AdminMenu:ApplyTime', function(hour, minute)
    NetworkOverrideClockTime(tonumber(hour), tonumber(minute), 0)
end)

RegisterNetEvent('Unique_AdminMenu:ApplyTeleportCoords')
AddEventHandler('Unique_AdminMenu:ApplyTeleportCoords', function(x, y, z)
    DoScreenFadeOut(300)
    Citizen.Wait(300)
    SetEntityCoords(PlayerPedId(), x, y, z, false, false, false, true)
    Citizen.Wait(300)
    DoScreenFadeIn(300)
    drawNotification("~b~Teleported")
end)
