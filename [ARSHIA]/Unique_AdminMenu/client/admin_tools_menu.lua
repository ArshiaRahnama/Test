

SelectedTargetId = nil
SavedLocationsCache = {}

-- Small helper so every category submenu gets a distinct accent color
-- without repeating the same three SetX calls everywhere.
local function ColorMenu(id, r, g, b)
    WarMenu.SetTitleBackgroundColor(id, r, g, b, 255)
    WarMenu.SetMenuFocusColor(id, r, g, b, 255)
end

Citizen.CreateThread(function()
    WarMenu.CreateSubMenu('select_target', 'main', 'Select Target Player')
    -- player_tools is only ever opened FROM select_target (you pick a
    -- player, then land here), so Backspace needs to take you back to that
    -- player list - not all the way up to the main menu. Same idea applies
    -- to every category submenu below: its "back" parent is always the hub
    -- you actually opened it from, so Backspace never skips a level.
    WarMenu.CreateSubMenu('player_tools', 'select_target', 'Player Tools')

    WarMenu.CreateSubMenu('player_quick', 'player_tools', 'Quick Actions')
    ColorMenu('player_quick', 74, 144, 201)          -- blue: everyday utility

    WarMenu.CreateSubMenu('player_punish', 'player_tools', 'Punishments')
    ColorMenu('player_punish', 200, 84, 80)          -- red: consequences

    WarMenu.CreateSubMenu('player_control', 'player_tools', 'Player Control')
    ColorMenu('player_control', 155, 110, 210)       -- purple: buffs/state

    WarMenu.CreateSubMenu('player_econ', 'player_tools', 'Economy & Job')
    ColorMenu('player_econ', 95, 174, 114)           -- green: money/job

    WarMenu.CreateSubMenu('player_investigate', 'player_tools', 'Investigate')
    ColorMenu('player_investigate', 95, 170, 170)    -- teal: information

    WarMenu.CreateSubMenu('vehicle_tools', 'main', 'Vehicle Tools')
    WarMenu.CreateSubMenu('vehicle_spawn', 'vehicle_tools', 'Spawn & Give')
    ColorMenu('vehicle_spawn', 95, 174, 114)
    WarMenu.CreateSubMenu('vehicle_nearby', 'vehicle_tools', 'Nearby Vehicle Actions')
    ColorMenu('vehicle_nearby', 74, 144, 201)

    WarMenu.CreateSubMenu('world_tools', 'main', 'World Tools')
    WarMenu.CreateSubMenu('world_weather', 'world_tools', 'Weather, Time & Traffic')
    ColorMenu('world_weather', 74, 144, 201)
    WarMenu.CreateSubMenu('world_teleport', 'world_tools', 'Teleport & Locations')
    ColorMenu('world_teleport', 155, 110, 210)
    -- Saved Locations now lives under Teleport & Locations, not the World
    -- Tools hub directly, so its back parent moves with it.
    WarMenu.CreateSubMenu('saved_locations', 'world_teleport', 'Saved Locations')

    WarMenu.CreateSubMenu('server_tools', 'main', 'Server Tools')
    WarMenu.CreateSubMenu('server_comms', 'server_tools', 'Communication')
    ColorMenu('server_comms', 74, 144, 201)
    WarMenu.CreateSubMenu('server_reports', 'server_tools', 'Reports & Logs')
    ColorMenu('server_reports', 95, 170, 170)
    WarMenu.CreateSubMenu('server_bulk', 'server_tools', 'Bulk Actions (All Players)')
    ColorMenu('server_bulk', 200, 90, 90)
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

-- ---------------------------------------------------------- PLAYER TOOLS ---
-- Player Tools is now just a hub: pick the target, then jump into whichever
-- category you need. Keeps each screen short instead of one 20+ item wall.

local function DrawPlayerToolsMenu()
    if not SelectedTargetId then
        WarMenu.OpenMenu('select_target')
        return
    end

    if WarMenu.Button("Target: [" .. SelectedTargetId .. "] " .. (PlayersCache[SelectedTargetId] or "?")) then
        OpenPlayerTools()
    end

    WarMenu.MenuButton('» Quick Actions', 'player_quick')
    WarMenu.MenuButton('» Punishments', 'player_punish')
    WarMenu.MenuButton('» Player Control', 'player_control')
    WarMenu.MenuButton('» Economy & Job', 'player_econ')
    WarMenu.MenuButton('» Investigate', 'player_investigate')
end

local function DrawPlayerQuickMenu()
    if WarMenu.Button("Teleport to Target") then
        local targetId = SelectedTargetId
        WarMenu.ForceCloseAll()
        teleportToPlayer(targetId)
    end

    if WarMenu.Button("Bring Target to Me") then
        TriggerServerEvent('Unique_AdminMenu:BringTarget', SelectedTargetId)
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
end

local function DrawPlayerPunishMenu()
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

    if WarMenu.Button("Send to Jail") then
        local dur = tonumber(GetUserInput("Minutes", "10")) or 10
        local reason = GetUserInput("Jail reason") or ""
        if reason == "" then reason = "No reason specified" end
        -- Real jail (movement lock + countdown), not a fake teleport --
        -- handled by Unique_Punishment's arshia_jail:sendto (permission_level
        -- checked server-side there too).
        TriggerServerEvent('arshia_jail:sendto', SelectedTargetId, 'admin', dur, reason)
    end

    if WarMenu.Button("Release from Jail") then
        TriggerServerEvent('arshia_jail:UnjailPlayer', SelectedTargetId)
    end

    if WarMenu.Button("Send to Community Service") then
        local count = tonumber(GetUserInput("Actions Count", "10")) or 10
        local reason = GetUserInput("Reason") or ""
        if reason == "" then reason = "No reason specified" end
        TriggerServerEvent('esx_communityGGservice:sendToCommunityService', SelectedTargetId, count, reason)
    end

    if WarMenu.Button("Impound Vehicle") then
        TriggerServerEvent('Unique_AdminMenu:ImpoundTarget', SelectedTargetId)
    end
end

local function DrawPlayerControlMenu()
    if WarMenu.Button("Set Health %") then
        local pct = tonumber(GetUserInput("Health percent (0-100)", "100"))
        if pct then
            TriggerServerEvent('Unique_AdminMenu:SetHealth', SelectedTargetId, pct)
        end
    end

    if WarMenu.Button("Set Armor %") then
        local pct = tonumber(GetUserInput("Armor percent (0-100)", "100"))
        if pct then
            TriggerServerEvent('Unique_AdminMenu:SetArmor', SelectedTargetId, pct)
        end
    end

    if WarMenu.Button("Toggle God Mode (Target)") then
        TriggerServerEvent('Unique_AdminMenu:ToggleTargetGodmode', SelectedTargetId)
    end

    if WarMenu.Button("Cuff / Uncuff") then
        TriggerServerEvent('Unique_AdminMenu:ToggleCuff', SelectedTargetId)
    end

    if WarMenu.Button("Mute Voice/Chat") then
        TriggerServerEvent('Unique_AdminMenu:MuteTarget', SelectedTargetId, true)
    end

    if WarMenu.Button("Unmute Voice/Chat") then
        TriggerServerEvent('Unique_AdminMenu:MuteTarget', SelectedTargetId, false)
    end

    if WarMenu.Button("Give Weapon") then
        local weapon = GetUserInput("Weapon name (without WEAPON_), e.g. PISTOL", "PISTOL") or ""
        local ammo = tonumber(GetUserInput("Ammo", "250")) or 250
        if weapon ~= "" then
            TriggerServerEvent('Unique_AdminMenu:GiveWeaponTarget', SelectedTargetId, weapon, ammo)
        end
    end

    if WarMenu.Button("Remove Weapon") then
        local weapon = GetUserInput("Weapon name (without WEAPON_), e.g. PISTOL", "PISTOL") or ""
        if weapon ~= "" then
            TriggerServerEvent('Unique_AdminMenu:RemoveWeaponTarget', SelectedTargetId, weapon)
        end
    end

    if WarMenu.Button("Clear Inventory") then
        local alert = lib.alertDialog({ header = 'Clear Inventory', content = 'Remove all items from this player?', centered = true, cancel = true })
        if alert == 'confirm' then
            TriggerServerEvent('Unique_AdminMenu:ClearInventoryTarget', SelectedTargetId)
        end
    end

    if WarMenu.Button("Clear Loadout (Weapons)") then
        local alert = lib.alertDialog({ header = 'Clear Loadout', content = 'Remove all weapons from this player?', centered = true, cancel = true })
        if alert == 'confirm' then
            TriggerServerEvent('Unique_AdminMenu:ClearLoadoutTarget', SelectedTargetId)
        end
    end
end

local function DrawPlayerEconMenu()
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
end

local function DrawPlayerInvestigateMenu()
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

    if WarMenu.Button("Screenshot Player") then
        TriggerServerEvent('Unique_AdminMenu:ScreenshotTarget', SelectedTargetId)
        drawNotification("~b~Requesting screenshot...")
    end

    if WarMenu.Button("Whisper Message") then
        local msg = GetUserInput("Private message to this player", "", 150) or ""
        if msg ~= "" then
            TriggerServerEvent('Unique_AdminMenu:WhisperTarget', SelectedTargetId, msg)
        end
    end
end

-- --------------------------------------------------------- VEHICLE TOOLS ---

local function DrawVehicleToolsMenu()
    WarMenu.MenuButton('» Spawn & Give', 'vehicle_spawn')
    WarMenu.MenuButton('» Nearby Vehicle Actions', 'vehicle_nearby')
end

local function DrawVehicleSpawnMenu()
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

    if WarMenu.Button("Give Vehicle to Target" .. (SelectedTargetId and (" [" .. SelectedTargetId .. "]") or " (pick a target first)")) then
        if not SelectedTargetId then
            drawNotification("~r~Pick a target in Player Tools first")
        else
            local model = GetUserInput("Vehicle model name", "adder") or ""
            if model ~= "" then
                TriggerServerEvent('Unique_AdminMenu:GiveVehicle', SelectedTargetId, model)
            end
        end
    end
end

local function DrawVehicleNearbyMenu()
    if WarMenu.Button("Nearby Vehicle List") then
        OpenVehicleList()
    end

    if WarMenu.Button("Lock/Unlock nearest vehicle") then
        TriggerServerEvent('Unique_AdminMenu:VehicleAction', 'lock')
    end

    if WarMenu.Button("Max upgrade nearest vehicle") then
        TriggerServerEvent('Unique_AdminMenu:VehicleAction', 'maxupgrade')
    end

    if WarMenu.Button("Delete nearest empty vehicle") then
        TriggerServerEvent('Unique_AdminMenu:VehicleAction', 'deletenearest')
    end

    if WarMenu.Button("Delete Vehicles In Range") then
        local range = tonumber(GetUserInput("Range (meters)", "50")) or 50
        DeleteVehiclesInRange(range)
    end
end

-- ----------------------------------------------------------- WORLD TOOLS ---

local WeatherPresets = { "EXTRASUNNY", "CLEAR", "CLOUDS", "OVERCAST", "RAIN", "THUNDER", "SMOG", "FOGGY", "XMAS", "SNOWLIGHT", "BLIZZARD" }

local function DrawWorldToolsMenu()
    WarMenu.MenuButton('» Weather, Time & Traffic', 'world_weather')
    WarMenu.MenuButton('» Teleport & Locations', 'world_teleport')
end

local function DrawWorldWeatherMenu()
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

    if WarMenu.Button("Freeze/Resume Server Time") then
        TriggerServerEvent('Unique_AdminMenu:ToggleFreezeTime')
    end

    if WarMenu.Button("Traffic Density") then
        local level = GetUserInput("off / low / normal / high", "normal") or ""
        if level ~= "" then
            TriggerServerEvent('Unique_AdminMenu:SetTrafficDensity', level:lower())
        end
    end
end

local function DrawWorldTeleportMenu()
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

-- ---------------------------------------------------------- SERVER TOOLS ---

local function DrawServerToolsMenu()
    WarMenu.MenuButton('» Communication', 'server_comms')
    WarMenu.MenuButton('» Reports & Logs', 'server_reports')
    WarMenu.MenuButton('» Bulk Actions (All Players)', 'server_bulk')

    if WarMenu.Button("⚠ Restart Resource") then
        local res = GetUserInput("Resource to restart (requires ACE: command.arestart)") or ""
        if res ~= "" then
            ExecuteCommand('arestart ' .. res)
        end
    end
end

local function DrawServerBulkMenu()
    if WarMenu.Button("Freeze / Unfreeze ALL Players") then
        local alert = lib.alertDialog({ header = 'Freeze/Unfreeze All', content = 'This toggles freeze for every player on the server. Continue?', centered = true, cancel = true })
        if alert == 'confirm' then
            TriggerServerEvent('Unique_AdminMenu:BulkAction', 'freezeall')
        end
    end

    if WarMenu.Button("Heal ALL Players") then
        TriggerServerEvent('Unique_AdminMenu:BulkAction', 'healall')
    end

    if WarMenu.Button("Revive ALL Players") then
        TriggerServerEvent('Unique_AdminMenu:BulkAction', 'reviveall')
    end

    if WarMenu.Button("Kick ALL Players") then
        local reason = GetUserInput("Kick reason for everyone", "Server maintenance") or "Server maintenance"
        local alert = lib.alertDialog({ header = 'Kick Everyone', content = 'This disconnects every player currently online. Continue?', centered = true, cancel = true })
        if alert == 'confirm' then
            TriggerServerEvent('Unique_AdminMenu:BulkAction', 'kickall', reason)
        end
    end

    if WarMenu.Button("Clear Chat For Everyone") then
        TriggerServerEvent('Unique_AdminMenu:BulkAction', 'clearall')
    end
end

local function DrawServerCommsMenu()
    if WarMenu.Button("Announce to server") then
        local msg = GetUserInput("Announcement text", "", 120) or ""
        if msg ~= "" then
            TriggerServerEvent('_chat:messageEntered', 'AdminAnnounce', {}, msg)
            ExecuteCommand('aannounce ' .. msg)
        end
    end

    if WarMenu.Button("Broadcast with Sound") then
        local msg = GetUserInput("Announcement text", "", 120) or ""
        if msg ~= "" then
            TriggerServerEvent('Unique_AdminMenu:AnnounceWithSound', msg)
        end
    end

    if WarMenu.Button("Admin Chat") then
        local msg = GetUserInput("Message (only visible to on-duty admins)", "", 150) or ""
        if msg ~= "" then
            TriggerServerEvent('Unique_AdminMenu:AdminChat', msg)
        end
    end
end

local function DrawServerReportsMenu()
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

    if WarMenu.Button("Online Players & Playtime") then
        OpenOnlinePlayersPanel()
    end

    if WarMenu.Button("Dashboard") then
        OpenDashboardPanel()
    end

    if WarMenu.Button("Ban History Search") then
        OpenBanSearch()
    end
end

-- ------------------------------------------------------------- MAIN LOOP ---

local MenuDrawers = {
    select_target        = DrawSelectTargetMenu,
    player_tools          = DrawPlayerToolsMenu,
    player_quick           = DrawPlayerQuickMenu,
    player_punish          = DrawPlayerPunishMenu,
    player_control          = DrawPlayerControlMenu,
    player_econ              = DrawPlayerEconMenu,
    player_investigate         = DrawPlayerInvestigateMenu,
    vehicle_tools         = DrawVehicleToolsMenu,
    vehicle_spawn           = DrawVehicleSpawnMenu,
    vehicle_nearby           = DrawVehicleNearbyMenu,
    world_tools           = DrawWorldToolsMenu,
    world_weather            = DrawWorldWeatherMenu,
    world_teleport            = DrawWorldTeleportMenu,
    saved_locations             = DrawSavedLocationsMenu,
    server_tools          = DrawServerToolsMenu,
    server_comms            = DrawServerCommsMenu,
    server_reports           = DrawServerReportsMenu,
    server_bulk               = DrawServerBulkMenu,
}

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        for id, drawFn in pairs(MenuDrawers) do
            if WarMenu.IsMenuOpened(id) then
                drawFn()
                WarMenu.Display()
                break
            end
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
