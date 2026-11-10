-- Pub by FleeX Team , https://discord.gg/87rGBxgCsa

RegisterNetEvent('sunset_admin:setDirt', function(percent)
	local ped = PlayerPedId()
	local vehicle = GetVehiclePedIsIn(ped, false)
	if vehicle == 0 or not DoesEntityExist(vehicle) then
		return ESX.ShowNotification('Shoma dar mashin nistid')
	end
	local level = (percent / 100.0) * 15.0
	SetVehicleDirtLevel(vehicle, level + 0.0)
	ESX.ShowNotification(('Kasifi mashin: %s%%'):format(percent))
end)

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
activencz = false
ESPADMIN = false
show2 = false	
ESX = nil
AdminPerks = false
isAdmin = false
local ShowID = false
local muted = false
local first = false
local time = 0
local disPlayerNames = 50
local ForceToVisible = false
local owned = false
world = 0
local mcarAccess = {
    ['steam:110000147278f47'] = true, -- stress
    ['steam:110000154c3ca69'] = true, -- Hassan_Thcgg
}
playerDistances = {}
reportSoundURL = 'https://cdn.sunrp.ir/sunco/sound/report/'

-- Spectate Notification System baraye rank 20+ admins
local beingSpectatedBy = {} -- Table of all admins spectating me
local spectatorCount = 0 -- Cache count
local spectateThreadRunning = false -- Track thread state

-- Function baraye start kardane draw thread (faghat vaghti lazeme)
local function StartSpectateDrawThread()
    if spectateThreadRunning then return end
    spectateThreadRunning = true

    Citizen.CreateThread(function()
        while spectatorCount > 0 do
            Citizen.Wait(0)

            -- Header
            SetTextFont(4)
            SetTextScale(0.4, 0.4)
            SetTextColour(255, 0, 0, 255)
            SetTextOutline()
            SetTextEntry("STRING")
            AddTextComponentString("~r~SPECTATING YOU (" .. spectatorCount .. "):")
            DrawText(0.01, 0.3)

            -- List admins
            local yOffset = 0.34
            for src, data in pairs(beingSpectatedBy) do
                SetTextFont(4)
                SetTextScale(0.35, 0.35)
                SetTextColour(255, 255, 0, 255)
                SetTextOutline()
                SetTextEntry("STRING")
                AddTextComponentString("- " .. data.name .. " (Rank " .. data.rank .. ")")
                DrawText(0.01, yOffset)
                yOffset = yOffset + 0.025
            end
        end
        -- Thread tamum shod chon list khali shod
        spectateThreadRunning = false
    end)
end

RegisterNetEvent('ssadmin:updateSpectatorList')
AddEventHandler('ssadmin:updateSpectatorList', function(spectators)
    beingSpectatedBy = spectators or {}

    -- Update cached count
    spectatorCount = 0
    for _ in pairs(beingSpectatedBy) do spectatorCount = spectatorCount + 1 end

    if spectatorCount > 0 then
        -- Build name list for notification
        local names = {}
        for src, data in pairs(beingSpectatedBy) do
            table.insert(names, data.name)
        end
        ESX.ShowNotification('~r~' .. spectatorCount .. ' Admin dar hale spectate shoma: ~y~' .. table.concat(names, ', '))

        -- Start thread agar run nemishe
        StartSpectateDrawThread()
    end
end)

Citizen.CreateThread(function()
    while ESX == nil do
        TriggerEvent("esx:getSharedObject",function(obj)
            ESX = obj
        end)
            
        Citizen.Wait(0)
        
    end
    PlayerData = ESX.GetPlayerData()
    if first then
        ESX.SetPlayerData('admin',0)
        first = false
    end
end)

alertstring = false
lastfor = 5
doalert = false
announcestring = false

RegisterNetEvent('alert')
AddEventHandler('alert', function(msg)
	alertstring = msg
	doalert = true
    Citizen.CreateThread(function()
        while doalert do
            Citizen.Wait(0)
            if IsControlJustPressed(13,201) then
                PlaySoundFrontend(-1, "OK", "HUD_FRONTEND_DEFAULT_SOUNDSET", 1);
                doalert = false
                alertstring = false
            end
            DrawFrontendAlert("FACES_WARNH2", "QM_NO_0", 2, nil, "", 0, 0, false, "FM_NXT_RAC", 1, true, false)
        end
    end)
	PlaySoundFrontend(-1, "CONFIRM_BEEP", "HUD_MINI_GAME_SOUNDSET", 1)
	AddTextEntry("FACES_WARNH2", "Alert")
	AddTextEntry("QM_NO_0", alertstring)
end)

flag = 0
RegisterNetEvent('adminflag')
AddEventHandler('adminflag',function()
    --[[
    local model = 'ind_prop_dlc_flag_02'
	local bone = GetPedBoneIndex(PlayerPedId(), 24816)
	RequestModel(model)
	while not HasModelLoaded(model) do
		Wait(100)
	end
    flag = CreateObject(GetHashKey(model), 1.0, 1.0, 1.0, true, true, false)
    AttachEntityToEntity(flag, PlayerPedId(), bone, -0.2, -0.15, 0.0, -100.0, -630.0, 0.0, 0, 1, 0, 0, 2, 1)
    SetModelAsNoLongerNeeded(model)]]
end)

RegisterNetEvent('adminflag2')
AddEventHandler('adminflag2',function()
   --[[ if flag and DoesEntityExist(flag) then
        DeleteEntity(flag)
        flag = 0 
    end]]
end)



RegisterNetEvent("esx:playerLoaded")
AddEventHandler("esx:playerLoaded",function(xPlayer)
    PlayerData = xPlayer
    updateBlip()
end)

RegisterNetEvent("ss:skin")
AddEventHandler("ss:skin",function()
    ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin, jobSkin)
        if skin == nil then
          TriggerEvent('skinchanger:loadSkin', {sex = 0})
        else
          TriggerEvent('skinchanger:loadSkin', skin)
        end
    end)
    --
    exports['sunset_clothe']:removeStuffJob()
    Citizen.Wait(1000)
    exports['sunset_clothe']:loadUsed()
end)


RegisterNetEvent('ss:setEventCoords')
AddEventHandler('ss:setEventCoords', function()
    if ESX.GetPlayerData().permission_level > 0 then
        local coords = GetEntityCoords(GetPlayerPed(-1))
        if coords ~= nil then
            TriggerServerEvent('ss:setEventCoords', coords)
        else
            print("Theere was a problem with getting coords")
        end
    end
end)

RegisterNetEvent("OnDutyHandler")
AddEventHandler("OnDutyHandler",function(skin, admincmd)
    AdminPerks = true
    ShowID = true
    ESX.SetPlayerData('admin',1)
    adminperks()
    ShowPlayerNames()
    -- if admincmd then
    --     ExecuteCommand('e flex')
    --     Wait(3000)
    --     ClearPedTasks(PlayerPedId())
    --     exports['sunset_utils']:sedPedHeight(1.15)
    -- end
end)


RegisterNetEvent("OnDutyHandlerStreamer")
AddEventHandler("OnDutyHandlerStreamer",function(skin)
        ESX.SetPlayerData('admin',1)
end)

RegisterNetEvent("OffDutyHandler")
AddEventHandler("OffDutyHandler",function(admincmd)
        AdminPerks = false
        ShowID = false
        show2 = false
		playerDistances = {}
        ESX.SetPlayerData('admin',0)
        adminperks()
        ShowPlayerNames()
        invisibility2 = false
        noclip = false
        blipdool = false
        fastrun = false
        superjump = false
        -- if admincmd then
        --     ExecuteCommand('e flex')
        --     Wait(3000)
        --     ClearPedTasks(PlayerPedId())
        --     exports['sunset_utils']:sedPedHeight(1.0)
        -- end
end)

RegisterNetEvent("OffDutyHandlerStreamer")
AddEventHandler("OffDutyHandlerStreamer",function()
        ESX.SetPlayerData('admin',0)
end)

RegisterNetEvent("OffDutyHandlerForJail")
AddEventHandler("OffDutyHandlerForJail",function()
    ESX.SetPlayerData('admin',0)
    TriggerEvent("OffDutyHandler")
	TriggerEvent('esx_basicneeds:healPlayer')
    TriggerEvent('chat:addMessage', {
        color = { 255, 0, 0},
        multiline = true,
        args = {"[SYSTEM]", "^0Shoma ^1OffDuty ^0Shodid!"}
        }, 'alarms')
    TriggerServerEvent('aduty:changeDutyStatus', source)
end)

local rankdict = {
    [1] = "~r~[SUPPORT] ~w~",
    [2] = "~r~[HELPER] ~w~",
    [3] = "~r~[SENIOR HELPER] ~w~",
    [4] = "~r~[HEAD HELPER] ~w~",
	[5] = "~r~[ADMIN] ~w~",
    [6] = "~r~[SENIOR ADMIN] ~w~",
    [7] = "~r~[HEAD ADMIN] ~w~",
	[8] = "~r~[EXECUTIVE ADMIN] ~w~",
	[9] = "~r~[ADMIN MANAGEMENT] ~w~",
    [10] = "~r~[MODERATOR] ~w~",
	[11] = "~r~[MANAGER] ~w~",
    [12] = "~r~[OWNER] ~w~",
	[13] = "~y~[DEVELOPER] ~w~"
}
local rankdictdis = {
    [1] = "SUPPORT",
    [2] = "HELPER",
    [3] = "SENIOR HELPER",
    [4] = "HEAD HELPER",
	[5] = "ADMIN",
    [6] = "SENIOR ADMIN",
    [7] = "HEAD ADMIN",
	[8] = "EXECUTIVE ADMIN",
	[9] = "ADMIN MANAGEMENT",
    [10] = "MODERATOR",
	[11] = "MANAGER",
    [12] = "OWNER",
	[13] = "DEVELOPER"
}

RegisterNetEvent('tpborj')
AddEventHandler('tpborj',function()
   ESX.SetEntityCoords(GetPlayerPed(-1),-75.22,-818.57,326.19)
end)

RegisterNetEvent("resetpedHandler")
AddEventHandler("resetpedHandler",function(skin)
    Citizen.CreateThread(function()
        local model = GetHashKey(skin)
        RequestModel(model)
        while not HasModelLoaded(model) do
            RequestModel(model)
            Citizen.Wait(0)
        end
        SetPlayerModel(PlayerId(), model)
        SetPedComponentVariation(GetPlayerPed(-1), 0, 0, 0, 2)
    end)
end)

RegisterNetEvent('ss:ncz')
AddEventHandler('ss:ncz', function(active)
	activencz = active
	if activencz then
		Citizen.CreateThread(function()
			while activencz do
				Wait(0)
				DisableControlAction(0, Keys['R'], true)
				DisableControlAction(0, 24, true) -- Attack
				DisableControlAction(0, 257, true) -- Attack 2
				DisableControlAction(0, 25, true) -- Right click
				DisableControlAction(0, 47, true)  -- Disable weapon
				DisableControlAction(0, 264, true) -- Disable melee
				DisableControlAction(0, 257, true) -- Disable melee
				DisableControlAction(0, 140, true) -- Disable melee
				DisableControlAction(0, 141, true) -- Disable melee
				DisableControlAction(0, 142, true) -- Disable melee
				DisableControlAction(0, 143, true) -- Disable melee
				DisableControlAction(0, 263, true) -- Melee Attack 1
			end
		end)
	end
end)

RegisterNetEvent("changepedHandler",function(skin)
    local ped = PlayerPedId()
    local heal, vest = GetEntityHealth(ped), GetPedArmour(ped)
    local model = GetHashKey(skin)
    RequestModel(model)
    while not HasModelLoaded(model) do
        RequestModel(model)
        Citizen.Wait(0)
    end
    SetPlayerModel(PlayerId(), model)
    SetPedComponentVariation(GetPlayerPed(-1), 0, 0, 0, 2)
    Wait(5000)
    ESX.SetEntityHealth(ped, heal)
    ESX.SetPedArmour(ped, vest)
end)

RegisterNetEvent("armorHandler")
AddEventHandler("armorHandler",function(armor)
    
    local ped = GetPlayerPed(-1)
    ESX.SetPedArmour(ped, armor) 
end)

RegisterNetEvent("aduty:vehiclelicenseHandler")
AddEventHandler("aduty:vehiclelicenseHandler",function(licenseplate)
    local player = GetPlayerPed(-1)
    if (IsPedSittingInAnyVehicle(player)) then
        local vehicle = GetVehiclePedIsIn(player, true)
        ESX.SetVehicleNumberPlateText(vehicle, licenseplate)
        ESX.ShowNotification("~g~Shomare pelak be: ~o~" .. licenseplate .. "~g~ taghir kard")
    else
        ESX.ShowNotification("~r~~h~Shoma baraye estefade az in command bayad dakhel mashin bashid")
    end
end)



RegisterNetEvent("aduty:forceStatus")
AddEventHandler("aduty:forceStatus", function(status)
  ForceToVisible = status
  visibility()
end)

RegisterNetEvent("aduty:refuel")
AddEventHandler("aduty:refuel", function(fuel)
    local ped = GetPlayerPed(-1)
    if IsPedInAnyVehicle(ped) then
        local vehicle = GetVehiclePedIsIn(ped)
        exports['sunset_utils']:SetFuel(vehicle, fuel)
    else
        TriggerEvent("chatMessage", "[SYSTEM]", {255, 0, 0}, "^0Shoma baraye estefade az in command bayad dakhel mashin bashid!", 'alarms')
    end
end)

RegisterNetEvent("aduty:vanish")
AddEventHandler("aduty:vanish", function()
   vanish = not vanish
   local ped = GetPlayerPed(-1)
    if vanish then -- activé
        TriggerServerEvent('aduty:toggleTag', GetPlayerServerId(PlayerId()), true)
        SetEntityVisible(ped, false, false)
        ESX.ShowNotification("Character shoma ba movafaghiat ~r~Gheyb ~w~shod")
    else
        TriggerServerEvent('aduty:toggleTag', GetPlayerServerId(PlayerId()), true)
        SetEntityVisible(ped, true, false)
        ESX.ShowNotification("Character shoma ba movafaghiat ~g~Zaher ~w~shod")
    end
end)

RegisterNetEvent("aduty:visibleForce")
AddEventHandler("aduty:visibleForce", function()
    local ped = GetPlayerPed(-1)
    SetEntityVisible(ped, true, false)
end)

RegisterNetEvent('aduty:tag')
AddEventHandler('aduty:tag',function(own)
    owned = own
end)

RegisterNetEvent('aduty:tagChanger')
AddEventHandler('aduty:tagChanger',function(status)
    owned = status
end)


RegisterNetEvent('aduty:returnStatus')
AddEventHandler('aduty:returnStatus', function()
    TriggerServerEvent('aduty:statusHandler', owned)
end)


RegisterNetEvent("aduty:deleteVehicle")
AddEventHandler("aduty:deleteVehicle", function()
    local playerPed = PlayerPedId()
    local vehicle   = ESX.Game.GetVehicleInDirection(4)
    local entity = vehicle
    carModel = GetEntityModel(entity)
    carName = GetDisplayNameFromVehicleModel(carModel)
    NetworkRequestControlOfEntity(entity)
    
    local timeout = 2000
    while timeout > 0 and not NetworkHasControlOfEntity(entity) do
        Wait(100)
        timeout = timeout - 100
    end

    SetEntityAsMissionEntity(entity, true, true)
    
    local timeout = 2000
    while timeout > 0 and not IsEntityAMissionEntity(entity) do
        Wait(100)
        timeout = timeout - 100
    end
    if IsVehicleSeatFree(entity, -1) then
        if DoesEntityExist(entity) then
            TriggerEvent('chat:addMessage', {
                color = { 255, 0, 0},
                multiline = true,
                args = {"[SYSTEM]", "^2 " .. carName .. "^0 ba movafaghiat hazf shod!"}
            }, 'alarms')
        end
        TriggerServerEvent('removecarkey',ESX.Math.Trim(GetVehicleNumberPlateText(entity))) 
        Citizen.InvokeNative( 0xEA386986E786A54F, Citizen.PointerValueIntInitialized( entity ) )
        
        if (DoesEntityExist(entity)) then 
            DeleteEntity(entity)
        end
    else
        TriggerEvent('chat:addMessage', {
            color = { 255, 0, 0},
            multiline = true,
            args = {"[SYSTEM]", "^2 " .. carName .. "^0 dar hale hazer yek ranande dare"}
        }, 'alarms')
    end
end)

RegisterNetEvent("aduty:getplateVehicle")
AddEventHandler("aduty:getplateVehicle", function()
    local playerPed = PlayerPedId()
    local vehicle   = ESX.Game.GetVehicleInDirection(10)
    local entity = vehicle
        TriggerEvent('chat:addMessage', {
            color = { 255, 0, 0},
            multiline = true,
            args = {"[SYSTEM]", "^2 Pelak : ".. GetVehicleNumberPlateText(vehicle)}
        }, 'alarms')
end)

RegisterCommand('flip', function(source)
    if ESX.GetPlayerData().permission_level > 0 then
        if ESX.GetPlayerData()['admin'] == 1 then
            local ped = GetPlayerPed(-1)
            if IsPedSittingInAnyVehicle(ped) then
                local vehicle = GetVehiclePedIsIn(ped, false)
                TriggerServerEvent("ss:dv",vehicle)
                exports['esx_vehiclecontrol']:flip(vehicle)
            else
                local vehicle = ESX.Game.GetVehicleInDirection(4)
                if vehicle ~= 0 then
                    exports['esx_vehiclecontrol']:flip(vehicle)
                else
                    TriggerEvent('chat:addMessage', {color = { 255, 0, 0}, multiline = true ,args = {"[SYSTEM]", "^0Hich mashini nazdik shoma nist!"}}, 'alarms')
                end
            end
        else
            TriggerEvent('chat:addMessage', {color = { 255, 0, 0}, multiline = true ,args = {"[SYSTEM]", "^0Shoma nemitavanid dar halat ^1OffDuty ^0az command haye admini estefade konid!"}}, 'alarms')
        end
    else
        TriggerEvent('chat:addMessage', {color = { 255, 0, 0}, multiline = true ,args = {"[SYSTEM]", "^0Shoma admin nistid!"}}, 'alarms')
    end
end, false)

RegisterCommand('unflip', function(source)
    if ESX.GetPlayerData().permission_level > 0 then
        if ESX.GetPlayerData()['admin'] == 1 then
            local ped = GetPlayerPed(-1)
            if IsPedSittingInAnyVehicle(ped) then
                local vehicle = GetVehiclePedIsIn(ped, false)
                TriggerServerEvent("ss:dv",vehicle)
                exports['esx_vehiclecontrol']:unflip(vehicle)
            else
                local vehicle = ESX.Game.GetVehicleInDirection(4)
                if vehicle ~= 0 then
                    exports['esx_vehiclecontrol']:unflip(vehicle)
                else
                    TriggerEvent('chat:addMessage', {color = { 255, 0, 0}, multiline = true ,args = {"[SYSTEM]", "^0Hich mashini nazdik shoma nist!"}}, 'alarms')
                end
            end
        else
            TriggerEvent('chat:addMessage', {color = { 255, 0, 0}, multiline = true ,args = {"[SYSTEM]", "^0Shoma nemitavanid dar halat ^1OffDuty ^0az command haye admini estefade konid!"}}, 'alarms')
        end
    else
        TriggerEvent('chat:addMessage', {color = { 255, 0, 0}, multiline = true ,args = {"[SYSTEM]", "^0Shoma admin nistid!"}}, 'alarms')
    end
end, false)

RegisterCommand('devtools', function(source)
    if ESX.GetPlayerData().permission_level >= 20 then
        OpenNuiDevTools()
    end
end, false)


function adminperks()

    Citizen.CreateThread( function()
        while true do
            Citizen.Wait(5000)
            local ped = PlayerPedId()
            if AdminPerks then
                ResetPlayerStamina(PlayerId())
                SetEntityInvincible(ped, true)
                SetPlayerInvincible(PlayerId(), true)
                SetPedCanRagdoll(ped, false)
                ClearPedBloodDamage(ped)
                ResetPedVisibleDamage(ped)
                ClearPedLastWeaponDamage(ped)
                SetEntityProofs(ped, true, true, true, true, true, true, true, true)
                SetEntityCanBeDamaged(ped, false)
                SetEntityHealth(ped, 200)
            else
                SetEntityInvincible(ped, false)
                SetPlayerInvincible(PlayerId(), false)
                SetPedCanRagdoll(ped, true)
                ClearPedLastWeaponDamage(ped)
                SetEntityProofs(ped, false, false, false, false, false, false, false, false)
                SetEntityCanBeDamaged(ped, true)
                return
            end

        end
        
    end)

    CreateThread(function()
        while AdminPerks do
            DrawRect(0.98, 0.50, 0.02, 0.02, 0, 255, 0, 255)
            Wait(0)
        end
    end)
end

function visibility()
    Citizen.CreateThread( function()
        while ForceToVisible do
            Citizen.Wait(1000)
            if ForceToVisible then
                SetEntityVisible(GetPlayerPed(-1), true, false)
            end
        end 
    end)
end


AddEventHandler("onMultiplePress", function(keys)
	if keys["lshift"] and keys["e"] then
        if ESX.GetPlayerData().permission_level > 0 then
            if ESX.GetPlayerData()['admin'] == 1 or ESX.GetPlayerData().permission_level >= 20 then
                exports.suncore:Whitelist(true)
                local playerPed = GetPlayerPed(-1)
                local WaypointHandle = GetFirstBlipInfoId(8)
                if DoesBlipExist(WaypointHandle) then
                    local waypointCoords = GetBlipInfoIdCoord(WaypointHandle)
                    for height = 1, 1000 do
                        SetPedCoordsKeepVehicle(PlayerPedId(), waypointCoords["x"], waypointCoords["y"], height + 0.0)
                        local foundGround, zPos = GetGroundZFor_3dCoord(waypointCoords["x"], waypointCoords["y"], height + 0.0)
                        if foundGround then
                            SetPedCoordsKeepVehicle(PlayerPedId(), waypointCoords["x"], waypointCoords["y"], height + 0.0)
                            break
                        end
                        Citizen.Wait(5)
                    end
                    Citizen.CreateThread(function()
                        Citizen.Wait(1000)
                        exports.suncore:Whitelist(false)
                    end)
                    ESX.ShowNotification("Shoma Teleport Shodid.")
                else
                    ESX.ShowNotification("Markeri baraye teleport shodan vojoud nadarad!")
                end
            else
                TriggerEvent('chat:addMessage', {color = { 255, 0, 0},multiline = true,args = {"[SYSTEM]", "^0Shoma nemitavanid dar halat ^1OffDuty ^0be marker roye map teleport konid!"}}, 'alarms')
            end
        end
	end
end)

RegisterNetEvent("sunset_admin:tp")
AddEventHandler("sunset_admin:tp",function()
    exports.suncore:Whitelist(true)
    local playerPed = GetPlayerPed(-1)
    local WaypointHandle = GetFirstBlipInfoId(8)
    if DoesBlipExist(WaypointHandle) then
        local waypointCoords = GetBlipInfoIdCoord(WaypointHandle)
        for height = 1, 1000 do
            ESX.SetPedCoordsKeepVehicle(PlayerPedId(), waypointCoords["x"], waypointCoords["y"], height + 0.0)
            local foundGround, zPos = GetGroundZFor_3dCoord(waypointCoords["x"], waypointCoords["y"], height + 0.0)
            if foundGround then
                ESX.SetPedCoordsKeepVehicle(PlayerPedId(), waypointCoords["x"], waypointCoords["y"], height + 0.0)
                break
            end
            Citizen.Wait(5)
        end
        Citizen.CreateThread(function()
            Citizen.Wait(1000)
            exports.suncore:Whitelist(false)
        end)
        ESX.ShowNotification("Shoma Teleport Shodid.")
     else
        ESX.ShowNotification("Markeri baraye teleport shodan vojoud nadarad!")
     end
end)

RegisterCommand('dobject', function(source, args)

    if ESX.GetPlayerData().permission_level > 0 then

        if args[1] then
            local coords = GetEntityCoords(GetPlayerPed(-1))
            local object = GetClosestObjectOfType(coords, 10000.0, GetHashKey(args[1]), false, false, false)
            if DoesEntityExist(object) then
                ESX.Game.DeleteObject(object)
                TriggerEvent('chat:addMessage', {
                    color = { 255, 0, 0},
                    multiline = true,
                    args = {"[SYSTEM]", "Shoma yek ^2" .. args[1] .. "^0 delete kardid!"}
                }, 'alarms')
            else
                TriggerEvent('chat:addMessage', {
                    color = { 255, 0, 0},
                    multiline = true,
                    args = {"[SYSTEM]", "Hich objecti peyda nashod"}
                }, 'alarms')
            end

        else
            TriggerEvent('chat:addMessage', {
                color = { 255, 0, 0},
                multiline = true,
                args = {"[SYSTEM]", "Shoma dar ghesmat esm object chizi varred nakardid"}
            }, 'alarms')
        end
    end

end, false)

RegisterCommand('tcrange', function(source, args)
  ESX.TriggerServerCallback('esx_aduty:getAdminPerm', function(aperm)

    if aperm >= 8 then
		if not tonumber(args[1]) and not tonumber(args[2]) then return end
		local players       = ESX.Game.GetPlayers()
		local coords = GetEntityCoords(PlayerPedId())
		for i=1, #players, 1 do
			local target       = GetPlayerPed(players[i])
			local targetCoords = GetEntityCoords(target)
			local distance     = GetDistanceBetweenCoords(targetCoords, coords.x, coords.y, coords.z, true)
			if distance <= tonumber(args[1]) + 10 then
				Wait(100)
				ExecuteCommand("addtc ".. GetPlayerServerId(players[i]).. " " .. tonumber(args[2]))
			end
		end
        else
		TriggerEvent('chat:addMessage', {color = { 255, 0, 0}, multiline = true ,args = {"[SYSTEM]", "^0Shoma dastresi kafi baraye estefade az in dastor ra nadarid!"}}, 'alarms')
    end

  end)
end, false)

RegisterCommand('armorrange', function(source, args)
  ESX.TriggerServerCallback('esx_aduty:getAdminPerm', function(aperm)

    if aperm >= 8 then
		if not tonumber(args[1]) and not tonumber(args[2]) then return end
		local players       = ESX.Game.GetPlayers()
		local coords = GetEntityCoords(PlayerPedId())
		for i=1, #players, 1 do
			local target       = GetPlayerPed(players[i])
			local targetCoords = GetEntityCoords(target)
			local distance     = GetDistanceBetweenCoords(targetCoords, coords.x, coords.y, coords.z, true)
			if distance <= tonumber(args[1]) + 10 then
				Wait(100)
				ExecuteCommand("setarmor ".. GetPlayerServerId(players[i]).. " " .. tonumber(args[2]))
			end
		end
        else
		TriggerEvent('chat:addMessage', {color = { 255, 0, 0}, multiline = true ,args = {"[SYSTEM]", "^0Shoma dastresi kafi baraye estefade az in dastor ra nadarid!"}}, 'alarms')
    end

  end)
end, false)

RegisterCommand('mcar', function(source, args)
    ESX.TriggerServerCallback('esx_aduty:getAdminPerm', function(aperm)
        local world = ESX.GetPlayerData().World
        local world99 = (world == 90 or world == 4 or world >= 100) and mcarAccess[ESX.GetPlayerData().identifier]
        if aperm >= 4 or world99 then
            if not args[1] then 
                TriggerEvent('chat:addMessage', {
                    color = { 255, 0, 0},
                    multiline = true,
                    args = {"[SYSTEM]", "Shoma dar ghesmat model mashin chizi vared nakardid!"}
                }, 'alarms') return
            end
            if not args[2] then 
                TriggerEvent('chat:addMessage', {
                    color = { 255, 0, 0},
                    multiline = true,
                    args = {"[SYSTEM]", "Shoma dar ghesmat turbo chizi vared nakardid!"}
                }, 'alarms') return
            end
            local turbo = args[2]
            local model = args[1]
            local colors = {a = 0, b = 0, c = 0}
            if args[3] then
                colors.a = tonumber(args[3])
            end
            if args[4] then
                colors.b = tonumber(args[4])
            end
            if args[5] then
                colors.c = tonumber(args[5])
            end
            if turbo == "true" then
                local playerPed = PlayerPedId()
                local coords    = GetEntityCoords(playerPed)
                    ESX.Game.SpawnVehicle(model, coords, GetEntityHeading(GetPlayerPed(-1)), function(vehicle)
                    TaskWarpPedIntoVehicle(playerPed,  vehicle, -1)
                    SetVehicleMaxMods(vehicle, true, colors)
                        TriggerEvent('chat:addMessage', {
                            color = { 255, 0, 0},
                            multiline = true,
                            args = {"[SYSTEM]", "^2 " .. model .. "^0 ba ^3turbo ^0spawn shod!"}
                        }, 'alarms')
                        ESX.giveCarKey(vehicle)
                end)
            elseif turbo == "false" then
                local playerPed = PlayerPedId()
                local coords    = GetEntityCoords(playerPed)
                ESX.Game.SpawnVehicle(model, coords, GetEntityHeading(GetPlayerPed(-1)), function(vehicle)
                    TaskWarpPedIntoVehicle(playerPed,  vehicle, -1)
                    SetVehicleMaxMods(vehicle, false, colors)
                        local carModel = GetEntityModel(vehicle)
                        local carName = GetDisplayNameFromVehicleModel(vehicle)
                
                        TriggerEvent('chat:addMessage', {
                            color = { 255, 0, 0},
                            multiline = true,
                            args = {"[SYSTEM]", "^2 " .. model .. "^0 spawn shod!"}
                        }, 'alarms')
                        ESX.giveCarKey(vehicle)
                end)
            else
                TriggerEvent('chat:addMessage', {
                    color = { 255, 0, 0},
                    multiline = true,
                    args = {"[SYSTEM]", "^2 Shoma dar ghesmat turbo statement eshtebahi vared kardid!"}
                }, 'alarms')
            end
        else
            TriggerEvent('chat:addMessage', {color = { 255, 0, 0}, multiline = true ,args = {"[SYSTEM]", "^0Shoma dastresi kafi baraye estefade az in dastor ra nadarid!"}}, 'alarms')
        end
    end)
end, false)


RegisterCommand('setturbo', function(source, args)
    ESX.TriggerServerCallback('esx_aduty:getAdminPerm', function(aperm)

        if aperm >= 4 then


            ESX.TriggerServerCallback('esx_aduty:checkAduty', function(isAduty)

                if isAduty then
                    SetVehicleTurbo(GetVehiclePedIsIn(PlayerPedId()))
                else
    
                TriggerEvent('chat:addMessage', {color = { 255, 0, 0}, multiline = true ,args = {"[SYSTEM]", "^0Shoma nemitavanid dar halat ^1OffDuty ^0az command haye admini estefade konid!"}}, 'alarms')
    
                end
        
            end)

        else

            TriggerEvent('chat:addMessage', {color = { 255, 0, 0}, multiline = true ,args = {"[SYSTEM]", "^0Shoma dastresi kafi baraye estefade az in dastor ra nadarid!"}}, 'alarms')

        end

        end)
end, false)

RegisterNetEvent('admin:changePlate', function(targetp)
    if targetp then
        targetp = string.upper(targetp)
        if IsPedSittingInAnyVehicle(PlayerPedId()) then
            local thisp = GetVehicleNumberPlateText(GetVehiclePedIsIn(PlayerPedId()))
            TriggerServerEvent('changeplate',thisp,targetp)
            ESX.SetVehicleNumberPlateText(GetVehiclePedIsIn(PlayerPedId()),targetp)
        else
            TriggerEvent('chat:addMessage', {color = { 255, 0, 0}, multiline = true ,args = {"[SYSTEM]", "^0Shoma savar mashin nistid!"}}, 'alarms')
        end
    end
end)

RegisterCommand('alock', function(source)

        if ESX.GetPlayerData().permission_level > 0 then

            ESX.TriggerServerCallback('esx_aduty:checkAduty', function(isAduty)

                if isAduty then

                    if IsPedSittingInAnyVehicle(GetPlayerPed(-1)) then

                        local vehicle = GetVehiclePedIsIn(GetPlayerPed(-1))
                        local vehicleLabel = GetDisplayNameFromVehicleModel(GetEntityModel(vehicle))
                        vehicleLabel = GetLabelText(vehicleLabel)
                        local lock = GetVehicleDoorLockStatus(vehicle)
        
                        if lock == 1 or lock == 0 then
                            SetVehicleDoorShut(vehicle, 0, false)
                            SetVehicleDoorShut(vehicle, 1, false)
                            SetVehicleDoorShut(vehicle, 2, false)
                            SetVehicleDoorShut(vehicle, 3, false)
                            SetVehicleDoorsLocked(vehicle, 2)
                            PlayVehicleDoorCloseSound(vehicle, 1)
                            local NetId = NetworkGetNetworkIdFromEntity(vehicle)
                            TriggerServerEvent("esx_vehiclecontrol:sync", NetId, true)
                            ESX.ShowNotification('You have ~r~locked~s~ your ~y~'..vehicleLabel..'~s~.')
                        elseif lock == 2 then
                            SetVehicleDoorsLocked(vehicle, 1)
                            PlayVehicleDoorOpenSound(vehicle, 0)
                            local NetId = NetworkGetNetworkIdFromEntity(vehicle)
                            TriggerServerEvent("esx_vehiclecontrol:sync", NetId, false)
                            ESX.ShowNotification('You have ~g~unlocked~s~ your ~y~'..vehicleLabel..'~s~.')
                        end
                        
                    else
        
                        local vehicle = ESX.Game.GetVehicleInDirection(4)
                        local lock = GetVehicleDoorLockStatus(vehicle)
        
                        if vehicle ~= 0 then
        
                            local vehicleLabel = GetDisplayNameFromVehicleModel(GetEntityModel(vehicle))
                            vehicleLabel = GetLabelText(vehicleLabel)
        
                            if lock == 1 or lock == 0 then
                                SetVehicleDoorShut(vehicle, 0, false)
                                SetVehicleDoorShut(vehicle, 1, false)
                                SetVehicleDoorShut(vehicle, 2, false)
                                SetVehicleDoorShut(vehicle, 3, false)
                                SetVehicleDoorsLocked(vehicle, 2)
                                PlayVehicleDoorCloseSound(vehicle, 1)
                                local NetId = NetworkGetNetworkIdFromEntity(vehicle)
                            TriggerServerEvent("esx_vehiclecontrol:sync", NetId, true)
                                ESX.ShowNotification('You have ~r~locked~s~ your ~y~'..vehicleLabel..'~s~.')
                            elseif lock == 2 then
                                SetVehicleDoorsLocked(vehicle, 1)
                                PlayVehicleDoorOpenSound(vehicle, 0)
                                local NetId = NetworkGetNetworkIdFromEntity(vehicle)
                                TriggerServerEvent("esx_vehiclecontrol:sync", NetId, false)
                                ESX.ShowNotification('You have ~g~unlocked~s~ your ~y~'..vehicleLabel..'~s~.')
                            end
        
                        else
        
                            ESX.ShowNotification("~r~~h~Hich mashini nazdik shoma nist!")
        
                        end
                        
                    end
                    
                else
    
                TriggerEvent('chat:addMessage', {color = { 255, 0, 0}, multiline = true ,args = {"[SYSTEM]", "^0Shoma nemitavanid dar halat ^1OffDuty ^0az command haye admini estefade konid!"}}, 'alarms')
    
                end
        
            end)

        else

            TriggerEvent('chat:addMessage', {color = { 255, 0, 0}, multiline = true ,args = {"[SYSTEM]", "^0Shoma admin nistid!"}}, 'alarms')

        end

end, false)

--gang
RegisterCommand('creategang', function(source, args)
    ESX.TriggerServerCallback('esx_aduty:getAdminPerm', function(aperm)

        if aperm >= 9 then


            ESX.TriggerServerCallback('esx_aduty:checkAduty', function(isAduty)

                if args[1] and tonumber(args[2]) then
                    TriggerServerEvent('gangs:registerGang', args[1], args[2])
                else
                    TriggerEvent('chat:addMessage', {color = { 255, 0, 0}, multiline = true ,args = {"[SYSTEM]", "^0Parameter haye vared shode sahih nist!"}}, 'alarms')
                end
        
            end)

        else

            TriggerEvent('chat:addMessage', {color = { 255, 0, 0}, multiline = true ,args = {"[SYSTEM]", "^0Shoma dastresi kafi baraye estefade az in dastor ra nadarid!"}}, 'alarms')

        end

    end)
end, false)

RegisterCommand('savegangs', function(source, args)
    ESX.TriggerServerCallback('esx_aduty:getAdminPerm', function(aperm)

        if aperm >= 9 then


            ESX.TriggerServerCallback('esx_aduty:checkAduty', function(isAduty)

                TriggerServerEvent('gangs:saveGangs')
        
            end)

        else

            TriggerEvent('chat:addMessage', {color = { 255, 0, 0}, multiline = true ,args = {"[SYSTEM]", "^0Shoma dastresi kafi baraye estefade az in dastor ra nadarid!"}}, 'alarms')

        end

    end)
end, false)

RegisterCommand('changegangdata', function(source, args)
    if ESX.commandGroupCheck({
        'FULL_PERM',
        'groupManager',
    }) then
        ESX.TriggerServerCallback('esx_aduty:doesGangExist', function(GangExist)

            local playerPos = GetEntityCoords(GetPlayerPed(-1))
            if GangExist then
                local station = 1
                if tonumber(args[3]) then
                    station = tonumber(args[3])
                end
                local delete = args[4] == '1'
                if args[2] == 'blip' then
                    local radius  = tonumber(args[5]) or 50
                    local Pos     = { x = playerPos.x, y = playerPos.y, z = playerPos.z + 0.5, radius = radius }
                    TriggerServerEvent('gangs:changeGangData', args[1], args[2], Pos, station, delete)
                elseif args[2] == 'armory' then
                    local Pos     = { x = playerPos.x, y = playerPos.y, z = (playerPos.z - 1.0) }
                    TriggerServerEvent('gangs:changeGangData', args[1], args[2], Pos, station, delete)
                elseif args[2] == 'locker' then
                    local Pos     = { x = playerPos.x, y = playerPos.y, z = (playerPos.z - 1.0) }
                    TriggerServerEvent('gangs:changeGangData', args[1], args[2], Pos, station, delete)
                elseif args[2] == 'boss' then
                    local Pos     = { x = playerPos.x, y = playerPos.y, z = (playerPos.z - 1.0) }
                    TriggerServerEvent('gangs:changeGangData', args[1], args[2], Pos, station, delete)
                elseif args[2] == 'veh' then
                    local Pos     = { x = playerPos.x, y = playerPos.y, z = (playerPos.z - 1.0) }
                    TriggerServerEvent('gangs:changeGangData', args[1], args[2], Pos, station, delete)
                elseif args[2] == 'vehdel' then
                    local Pos     = { x = playerPos.x, y = playerPos.y, z = (playerPos.z - 1.0) }
                    TriggerServerEvent('gangs:changeGangData', args[1], args[2], Pos, station, delete)
                elseif args[2] == 'search' then
                    TriggerServerEvent('gangs:changeGangData', args[1], args[2], nil)
                elseif args[2] == 'gps' then
                    TriggerServerEvent('gangs:changeGangData', args[1], args[2], nil)
                elseif args[2] == 'carry' then
                    TriggerServerEvent('gangs:changeGangData', args[1], args[2], nil)
                elseif args[2] == 'vehspawn' then
                    local Pos     = { x = playerPos.x, y = playerPos.y, z = playerPos.z , a = GetEntityHeading(GetPlayerPed(-1)) }
                    TriggerServerEvent('gangs:changeGangData', args[1], args[2], Pos,station, delete)
                    --
                elseif args[2] == 'heli' then
                    local Pos     = { x = playerPos.x, y = playerPos.y, z = (playerPos.z - 1.0) }
                    TriggerServerEvent('gangs:changeGangData', args[1], args[2], Pos,station, delete)
                elseif args[2] == 'helidel' then
                    local Pos     = { x = playerPos.x, y = playerPos.y, z = (playerPos.z - 1.0) }
                    TriggerServerEvent('gangs:changeGangData', args[1], args[2], Pos,station, delete)
                elseif args[2] == 'helispawn' then
                    local Pos     = { x = playerPos.x, y = playerPos.y, z = playerPos.z , a = GetEntityHeading(GetPlayerPed(-1)) }
                    TriggerServerEvent('gangs:changeGangData', args[1], args[2], Pos,station, delete)
                elseif args[2] == 'boat' then
                    local Pos     = { x = playerPos.x, y = playerPos.y, z = (playerPos.z - 1.0) }
                    TriggerServerEvent('gangs:changeGangData', args[1], args[2], Pos,station, delete)
                elseif args[2] == 'boatdel' then
                    local Pos     = { x = playerPos.x, y = playerPos.y, z = (playerPos.z - 1.0) }
                    TriggerServerEvent('gangs:changeGangData', args[1], args[2], Pos,station, delete)
                elseif args[2] == 'boatspawn' then
                    local Pos     = { x = playerPos.x, y = playerPos.y, z = playerPos.z , a = GetEntityHeading(GetPlayerPed(-1)) }
                    TriggerServerEvent('gangs:changeGangData', args[1], args[2], Pos,station, delete)
                elseif args[2] == 'expire' then
                    if tonumber(args[3]) then
                        TriggerServerEvent('gangs:changeGangData', args[1], args[2], args[3])
                    else
                        ESX.ShowNotification("~h~Shoma dar ghesmat roz faghat mitavanid adad vared konid")
                    end
                elseif args[2] == 'xpboost' then
                    if tonumber(args[3]) then
                        TriggerServerEvent('gangs:changeGangData', args[1], args[2], args[3])
                    else
                        ESX.ShowNotification("~h~Shoma dar ghesmat boost faghat mitavanid adad vared konid")
                    end
                elseif args[2] == 'bulletproof' then
                    TriggerServerEvent('gangs:changeGangData', args[1], args[2], args[3])
                elseif args[2] == 'slot' then
                    TriggerServerEvent('gangs:changeGangData', args[1], args[2], args[3])
                else
                    ESX.ShowNotification("~h~Option vared shode eshtebah ast")
                end

            else
                ESX.ShowNotification("~h~Gang vared shode eshtebah ast")
            end
        end, args[1], 6)
    end

end, false)
-- gang
RegisterNetEvent("aduty:addSuggestions")
AddEventHandler("aduty:addSuggestions",function()

        TriggerEvent('chat:addSuggestion', '/admin', 'Jahat on/off duty shodan admini', {
        })
        TriggerEvent('chat:addSuggestion', '/reportm', 'Report menu', {
        })
        TriggerEvent('chat:addSuggestion', '/glist', 'Gang list', {
        })

        TriggerEvent('chat:addSuggestion', '/changeped', 'Jahat avaz kardan ped', {
            { name="EsmPed", help="Esm ped mored nazar" }
        })

        TriggerEvent('chat:addSuggestion', '/setturbo', 'active kardan turbo', {
        })

        TriggerEvent('chat:addSuggestion', '/changeplate', 'taghir pelak mashin dar db', {
            { name="pelak", help="pelak mored nazr" }
        })

        TriggerEvent('chat:addSuggestion', '/openinventory', 'Jahat baz kardan inventory player', {
            { name="Id", help="Id player" }
        })

        TriggerEvent('chat:addSuggestion', '/ar', 'ghabool kardan report', {
            { name="ID", help="ID Player / report" }
         })

         TriggerEvent('chat:addSuggestion', '/cr', 'bactan report', {
            { name="ID", help="ID Player / report" }
         })
         TriggerEvent('chat:addSuggestion', '/hc', 'responder chat', {
            { name="text", help="text" }
         })
         TriggerEvent('chat:addSuggestion', '/hpm', 'chate responder va porseshgar', {
            { name="Matn", help="Matn Mored nazar" }
         })
         TriggerEvent('chat:addSuggestion', '/rd', 'chat dar report', {
            { name="matn", help="matn mored nazar" }
         })

        TriggerEvent('chat:addSuggestion', '/changeworld', 'ferestadan player be donyaye digar', {
               { name="ID", help="ID Player" },
               {name= "World", help= "suggest world 99"}
        })
        TriggerEvent('chat:addSuggestion', '/pm', 'Ferestadan Tazakor Admini', {
            { name="ID", help="ID Player" },
            {name= "Matn", help= "Matn Mored Nazar"}
         })
         TriggerEvent('chat:addSuggestion', '/reloadskin', 'baz gasht skin be halat save shode', {
            { name="ID", help="ID Player" }
         })
         TriggerEvent('chat:addSuggestion', '/name', 'peyda kardan esm ic player', {
            { name="ID", help="ID Player" }
         })
         TriggerEvent('chat:addSuggestion', '/ac', 'Chat makhsoos admin ha', {
            { name="Matn", help="Matn Mored nazar" }
         })
         TriggerEvent('chat:addSuggestion', '/carp', 'spawn mashin ba plate', {
            { name="plate", help="plate Mored nazar" }
         })
		TriggerEvent('chat:addSuggestion', '/deletecar', 'Haz Kardan Yek Mashin Az Database', {
            { name="Pelak", help="Pelak Mashin" }
        })

        TriggerEvent('chat:addSuggestion', '/alock', 'Jahat baz ya baste kardan dare mashini ke darid be an negah mikonid', {
        })


        TriggerEvent('chat:addSuggestion', '/setarmor', 'Jahat avaz kardan armor player', {
            { name="ID", help="ID player mored nazar" },
            { name="Armor", help="Meghdar armor beyn 0-100" }
        })

        TriggerEvent('chat:addSuggestion', '/changegangdata', 'Taqir dadan option haye gang', {
            { name="GangName", help="Esme Gang" },
	        { name="Option", help="Entekhabe option:(blip, armory, locker, boss, veh, vehdel, vehspawn, xpboost, expire, slot, heli, helispawn, helidel, boat, boatspawn, boatidel)" },
            {name = 'station', help = 'station'},
            {name = 'delete', help = '1 baraye delete'},
            {name = 'radius', help = 'radius blip (default: 50)'},
        })

        TriggerEvent('chat:addSuggestion', '/ajail', 'Admin jail kardan player be sorat online', {
            { name="ID", help="ID player mored nazar" },
            { name="Zaman", help="Zaman admin jail be daghighe" },
            { name="Dalil", help="Dalil admin jail" }
        })

        TriggerEvent('chat:addSuggestion', '/aunjail', 'Admin unjail kardan player be sorat online', {
            { name="ID", help="ID player mored nazar" }
        })

        TriggerEvent('chat:addSuggestion', '/money', 'Taghir dadan pol player', {
            { name="ID", help="ID player mored nazar" },
            { name="NoePool", help="Noe pool ebarat ast az cash/bank/black" },
            { name="Meghdar", help="Meghdar pool mored nazar" }
        })

        TriggerEvent('chat:addSuggestion', '/plate', 'Avaz kardan shomare pelak mashin', {
            { name="Pelak", help="Pelak mored nazar" }
        })

        TriggerEvent('chat:addSuggestion', '/ac', 'admin chat', {
            { name="Peygham", help="Peygham mored nazar" }
        })

        TriggerEvent('chat:addSuggestion', '/kick', 'Kick kardan player', {
            { name="ID", help="ID player mored nazar" },
            { name="Dalil", help="Dalil kick shodan" }
        })

        TriggerEvent('chat:addSuggestion', '/unmute', 'Jahat unmute kardan player', {
            { name="ID", help="ID player mored nazar" }
        })

        TriggerEvent('chat:addSuggestion', '/toggletag', 'Jahat toggle kardan tag admini', {
        })

        TriggerEvent('chat:addSuggestion', '/resetaccount', 'Jahat reset kardan account player', {
            { name="HEX", help="Hex Player Mored Nazar" },
            { name="Dalil", help="Dalil reset kardan account" }
        })

        TriggerEvent('chat:addSuggestion', '/disband', 'Jahat disband kardan family', {
            { name="ESM", help="Esm family mored nazar" },
            { name="Dalil", help="Dalil disband kardan gang" }
        })

        TriggerEvent('chat:addSuggestion', '/ban', 'Ban kardan player ba ID', {
            { name="ID", help="ID player mored nazar" },
            { name="ZAMAN", help="Zaman ra be roz vared konid (0 = permanent ban)" },
            { name="DALIL", help="Dalil ban shodan player ra vared konid" },
        })

        TriggerEvent('chat:addSuggestion', '/unban', 'Unban kardan player ba esm IC', {
            { name="name", help="Esm IC player mored nazar" },
        })

        TriggerEvent('chat:addSuggestion', '/charmenu', 'Reload player skin', {
            { name="Player", help="Player ID" },
        })

        TriggerEvent('chat:addSuggestion', '/vanish', 'baraye avaz kardan vaziat dide shodan', {
        })  
        TriggerEvent('chat:addSuggestion', '/creategang', 'Sakhtan Gang, Hasas be Horofe bozorg va Kochak', {
            { name="GangName", help="Esme Gang" },
            { name="Expire", help="Tedad Roz etebare Gang ra Vared konid" },
        })

        TriggerEvent('chat:addSuggestion', '/savegangs', 'Zakhire Kardane Gang\'e Sakhte Shode', {})

        TriggerEvent('chat:addSuggestion', '/sp', 'Jahat spect kardan player mored nazar', {
            { name="ID", help="ID player mored nazar" }
        })
        --event
        TriggerEvent('chat:addSuggestion', '/starteventcar', 'Start event car', {
            { name="name", help="car name" },
            { name="cooldown", help="spawn cooldown" },
            { name="range", help="spawn range" },
            { name="index", help="index" },
        })
        TriggerEvent('chat:addSuggestion', '/stopeventcar', 'stop event car', {
            { name="index", help="event index" },
        })
        TriggerEvent('chat:addSuggestion', '/starteventskin', 'Start event skin', {
            { name="player id", help="id" },
            { name="index", help="index" },
        })
        TriggerEvent('chat:addSuggestion', '/stopeventskin', 'stop event skin', {
            { name="index", help="event index" },
        })
        --
        TriggerEvent('chat:addSuggestion', '/starteventped', 'Start event ped', {
            { name="ped", help="ped name" },
            { name="index", help="index" },
        })
        TriggerEvent('chat:addSuggestion', '/stopeventped', 'stop event ped', {
            { name="index", help="event index" },
        })
        TriggerEvent('chat:addSuggestion', '/starteventgun', 'Start event ped', {
            { name="gun", help="gun name" },
            { name="index", help="index" },
        })
        TriggerEvent('chat:addSuggestion', '/stopeventgun', 'stop event gun', {
            { name="index", help="event index" },
        })

        TriggerEvent('chat:addSuggestion', '/addtc', 'add kardan tc', {
            { name="id", help="id player" },
            { name="count", help="count" },
        })

        TriggerEvent('chat:addSuggestion', '/settc', 'set kardan tc', {
            { name="id", help="id player" },
            { name="count", help="count" },
        })

        TriggerEvent('chat:addSuggestion', '/removetc', 'remove kardan tc', {
            { name="id", help="id player" },
            { name="count", help="count" },
        })

        --
        TriggerEvent('chat:addSuggestion', '/addgangxp', 'add kardan xp baraye gang', {
            { name="gang", help="gang name" },
            { name="xp", help="xp count" },
        })

        TriggerEvent('chat:addSuggestion', '/removegangxp', 'remove kardan xp baraye gang', {
            { name="gang", help="gang name" },
            { name="xp", help="xp count" },
        })

        TriggerEvent('chat:addSuggestion', '/aaa', 'zone haye entekhabi shoma', {
            { name="zone", help="zone save shode shoma /set baraye set kardan" },
            { name="index", help="index zone" },
        })

        TriggerEvent('chat:addSuggestion', '/changeworldrange', 'Change world range', {
            { name="Range", help="Range" },
            { name="world", help="World" }
        })
        TriggerEvent('chat:addSuggestion', '/event', 'Voroud be event')
        TriggerEvent('chat:addSuggestion', '/exitevent', 'Khorouj be event')
end)

function SetVehicleMaxMods(vehicle, turbo, colors)
        local props = {
            modEngine       =   3,
            modBrakes       =   2,
            windowTint      =   1,
            modArmor        =   4,
            modTransmission =   2,
            modSuspension   =   -1,
            modTurbo        =   turbo,
            modXenon     = true,
            color1 = colors.a,
            color2 = colors.b,
            pearlescentColor = colors.c,
        }
            
    ESX.Game.SetVehicleProperties(vehicle, props)
    ESX.Game.SetVehicleProperties(vehicle, {
        modSuspension =  GetNumVehicleMods(vehicle, 15)-1,
    })
end

function SetVehicleTurbo(vehicle)

    local props = {
        modTurbo        =   true
    }
    ESX.Game.SetVehicleProperties(vehicle, props)
end


function ShowPlayerNames()
Citizen.CreateThread(function()
--citizen cmd
--[[TriggerEvent('chat:addSuggestion', '/createunit', 'Jahat sakhte unit', {
		{ name="ESM", help="Esme unit"}
})
TriggerEvent('chat:addSuggestion', '/disbandunit', 'Jahat disband unit', {
		{ name="ESM", help="Esme unit"}
})
TriggerEvent('chat:addSuggestion', '/closecall', 'Close kardan call pd', {
		{ name="ID", help="Id call"}
})
TriggerEvent('chat:addSuggestion', '/resp', 'Accept kardan call', {
		{ name="ID", help="Id call"}
})]]



        while AdminPerks do
            if ShowID then

                for id = 0, 255 do
                    if GetPlayerPed(id) ~= GetPlayerPed(-1) then
                        x1, y1, z1 = table.unpack(GetEntityCoords(GetPlayerPed(-1), true))
                        x2, y2, z2 = table.unpack(GetEntityCoords(GetPlayerPed(id), true))
                        distance = math.floor(GetDistanceBetweenCoords(x1,  y1,  z1,  x2,  y2,  z2,  true))
                        playerDistances[id] = distance
                    end
                end

            end
            Citizen.Wait(5000)
        end
      end)
    
    Citizen.CreateThread(function()
        Wait(200)
        while true do
            if ShowID then


                    for id = 0, 255 do 
                        if NetworkIsPlayerActive(id) then
                            if GetPlayerPed(id) ~= GetPlayerPed(-1) then
                                if (playerDistances[id] < 50) then
                                    x2, y2, z2 = table.unpack(GetEntityCoords(GetPlayerPed(id), true))
										if NetworkIsPlayerTalking(id) then
										DrawText3D(x2, y2, z2+1.5, GetPlayerServerId(id) .. " | " .. GetPlayerName(id, true), 255,0,0)
										else
                                        DrawText3D(x2, y2, z2+1.5, GetPlayerServerId(id) .. " | " .. GetPlayerName(id, true), 255,255,255)
										end
                                end  
                            end
                        end
                    end

            end
            Citizen.Wait(0)
        end
    end)


    

    end

function drawTxt(x,y ,width,height,scale, text, r,g,b,a)
    SetTextFont(0)
    SetTextProportional(0)
    SetTextScale(scale, scale)
    SetTextColour(r, g, b, a)
    SetTextDropShadow(0, 0, 0, 0,255)
    SetTextEdge(1, 0, 0, 0, 255)
    SetTextDropShadow()
    SetTextOutline()
    SetTextEntry("STRING")
    AddTextComponentString(text)
    DrawText(x - width/2, y - height/2 + 0.005)
end

Talk = false

RegisterCommand('talk',function(source,args)
	ESX.TriggerServerCallback('esx_aduty:getAdminPerm', function(aperm)
     if aperm > 0 then
		Talk = not Talk
        Wait(1000)
        print(Talk)
        Citizen.CreateThread(function()
            while Talk do
                Citizen.Wait(1)
                local t = 0
                for i = 0,255 do
                    if(GetPlayerName(i))then
                        if(NetworkIsPlayerTalking(i))then
                            t = t + 1
        
                            if(t == 1)then
                                drawTxt(1.0, 0.5, 1.0,1.0,0.4, "~y~Talking", 255, 255, 255, 255)
                            end
        
                            drawTxt(1.0, 0.5 + (t * 0.030), 1.0,1.0,0.4, " (" .. GetPlayerServerId(i) .. ") " .. GetPlayerName(i), 255, 255, 255, 255)
                        end
                    end
                end		
            end
        end)
	 end
	 end)
end)

RegisterNetEvent('ssadmin:ttalk')
AddEventHandler('ssadmin:ttalk',function()
Talk = not Talk
if Talk then
    Citizen.CreateThread(function()
        while Talk do
            Citizen.Wait(1)
            local t = 0
            for i = 0,255 do
                if(GetPlayerName(i))then
                    if(NetworkIsPlayerTalking(i))then
                        t = t + 1
    
                        if(t == 1)then
                            drawTxt(1.0, 0.5, 1.0,1.0,0.4, "~y~Talking", 255, 255, 255, 255)
                        end
    
                        drawTxt(1.0, 0.5 + (t * 0.030), 1.0,1.0,0.4, " (" .. GetPlayerServerId(i) .. ") " .. GetPlayerName(i), 255, 255, 255, 255)
                    end
                end
            end		
        end
    end)
end
end)




function DrawText3D(x,y,z, text, r,g,b) 
    local onScreen,_x,_y=World3dToScreen2d(x,y,z)
    local px,py,pz=table.unpack(GetGameplayCamCoords())
    local dist = GetDistanceBetweenCoords(px,py,pz, x,y,z, 1)
 
    local scale = (1/dist)*2
    local fov = (1/GetGameplayCamFov())*100
    local scale = scale*fov
   
    if onScreen then
        SetTextScale(0.0*scale, 0.80*scale)
        SetTextFont(0)
        SetTextProportional(1)
        SetTextColour(r, g, b, 255)
        SetTextDropshadow(0, 0, 0, 0, 255)
        SetTextEdge(2, 0, 0, 0, 150)
        SetTextDropShadow()
        SetTextOutline()
        SetTextEntry("STRING")
        SetTextCentre(1)
        AddTextComponentString(text)
        DrawText(_x,_y)
    end
end

Citizen.CreateThread(function()
    TriggerEvent('chat:addSuggestion', '/report', 'Baz kardan menu report', {
    })
    TriggerEvent('chat:addSuggestion', '/cancelreport', 'Laghv Kardan Report Ghabl', {
    })
	TriggerEvent('chat:addSuggestion', '/rd', 'Char Dar Report', {
    })
	--streamer
TriggerEvent('chat:addSuggestion', '/cw', 'change player to world 99', {
		{ name="ID", help="Player id"},
        { name="World", help="World"}
})
TriggerEvent('chat:addSuggestion', '/bw', 'back player to orginal world', {
		{ name="ID", help="Player id"}
})
TriggerEvent('chat:addSuggestion', '/spawn', 'spawn car', {
		{ name="name", help="car name"}
})
TriggerEvent('chat:addSuggestion', '/weapon', 'give weapon', {
		{ name="id", help="Player id"},
		{ name="weapon", help="weapon name"},
        { name="ammo", help="ammo"},
})

TriggerEvent('chat:addSuggestion', '/rev', 'revive player (change world)', {
		{ name="id", help="Player id"}
})
TriggerEvent('chat:addSuggestion', '/tpw', 'tp to waypoint (change world)', {
})

TriggerEvent('chat:addSuggestion', '/worldskin', 'world skin')

TriggerEvent('chat:addSuggestion', '/saveworldskin', 'save world skin', {
    {name = 'name', help = 'name'}
})


TriggerEvent('chat:addSuggestion', '/gr', 'go to player (change world)', {
		{ name="id", help="Player id"}
})

TriggerEvent('chat:addSuggestion', '/br', 'bring player (change world)', {
		{ name="id", help="Player id"}
})
TriggerEvent('chat:addSuggestion', '/vfix', 'fix car', {
})

end)



local elements = {}
local lastlocation = nil
table.insert(elements, { label = 'Last location' })

--[[
    TELEPORT MENU COORDINATES
    Below you have lines of code that you need to change based on your use
    LABEL - label of location that you can find in menu
    OTHER lines are the actual coordinates
]]--

table.insert(elements, { label = 'PD', x = 425.1, y = -979.5, z = 30.7  })
--table.insert(elements, { label = 'Airport Los Santos', x = -1037.51, y = -2963.24, z = 13.95 })
--table.insert(elements, { label = 'Airport Sandy Shores', x = 1718.47, y = 3254.40, z = 41.14})
table.insert(elements, { label = 'Balatarin Noghte', x = 501.76, y = 5604.28, z = 797.91})
--table.insert(elements, { label = 'Vinewood Sign', x = 663.41, y = 1217.21, z = 322.94})
table.insert(elements, { label = 'Benny\'s', x = -210.94, y = -1322.61, z = 30.89 })
table.insert(elements, { label = 'Mechanici', x = -336.19, y = -133.28, z = 39.1 })
table.insert(elements, { label = 'Borj Haj Hamid',  x = -75.20, y = -818.95, z = 326.18 })

--[[
    TELEPORT MENU LOCALE
    You can change notification messages based on your language
]]--

local Locale = {
    ['teleported']  = 'You have teleported to ~b~',
    ['teleported_last']  = 'You have teleported to ~r~Last Location',
    ['teleported_last_empty']  = 'You didn\'t visit any location with this menu.',
}

RegisterNetEvent('tpmenu:open')
AddEventHandler('tpmenu:open', function()
    ESX.UI.Menu.CloseAll()					--Close everything ESX.Menu related	
    
    ESX.UI.Menu.Open(
        'default', GetCurrentResourceName(), 'tpmenu',
        {
            title    = 'Teleport menu',
            align    = 'bottom-right',
            elements = elements
        },
        function(data, menu)						--on data selection
            if data.current.label == "Last location" then
                if lastlocation ~= nil then  
                    ESX.Game.Teleport(PlayerPedId(), lastlocation) 
                    ESX.ShowNotification(Locale['teleported_last'])
                else 
                    ESX.ShowNotification(Locale['teleported_last_empty'])
                end
            else
                lastlocation = GetEntityCoords(GetPlayerPed(-1))
                local coords = { x = data.current.x,  y = data.current.y, z = data.current.z}
                ESX.Game.Teleport(PlayerPedId(), coords)
                ESX.ShowNotification(Locale['teleported'] .. data.current.label)
            end
            menu.close()							--close menu after selection
          end,
          function(data, menu)
            menu.close()
          end
        )
    
end)
local playersdc = {}
--[[RegisterNetEvent("playerdrop")
AddEventHandler("playerdrop",function(source,name,reason,coords)
local coords = vector3(coords.x,coords.y,coords.z)
if GetDistanceBetweenCoords(GetEntityCoords(GetPlayerPed(-1)), coords, true) < 100.000 then
    TriggerEvent('chatMessage', "Player disconnect" , {255, 0, 0},name .."(".. source ..") left dad | reason : " .. reason, 'plarms')
end
playersdc[source] = {src = source,name = name , reason =reason , crds = coords}
end)

Citizen.CreateThread(function()
	while true do
		Wait(1)
		for i , n in ipairs(playersdc) do
		print(json.encode(playersdc))
			local x , y , z = i.crds.x,i.crds.y,i.crds.z
			Draw3DText(i.crds, "Player disconnect | " .. i.name  .. " | id : " .. i.src, 4, 0.1, 0.1)
			Draw3DText(i.crds, "reason : " .. i.reason, 4, 0.1, 0.1)
			Draw3DText(i.crds, "Twitter: @Example", 4, 0.1, 0.1)	
		end
	end

end)]]

local allweapons = {
    "WEAPON_UNARMED",
    "WEAPON_KNIFE",
    "WEAPON_KNUCKLE",
    "WEAPON_NIGHTSTICK",
    "WEAPON_HAMMER",
    "WEAPON_BAT",
    "WEAPON_GOLFCLUB",
    "WEAPON_CROWBAR",
    "WEAPON_BOTTLE",
    "WEAPON_DAGGER",
    "WEAPON_HATCHET",
    "WEAPON_MACHETE",
    "WEAPON_FLASHLIGHT",
    "WEAPON_SWITCHBLADE",
    "WEAPON_POOLCUE",
    "WEAPON_PIPEWRENCH",


    "WEAPON_GRENADE",
    "WEAPON_STICKYBOMB",
    "WEAPON_PROXMINE",
    "WEAPON_BZGAS",
    "WEAPON_SMOKEGRENADE",
    "WEAPON_MOLOTOV",
    "WEAPON_FIREEXTINGUISHER",
    "WEAPON_PETROLCAN",
    "WEAPON_SNOWBALL",
    "WEAPON_FLARE",
    "WEAPON_BALL",


    "WEAPON_PISTOL",
    "WEAPON_PISTOL_MK2",
    "WEAPON_COMBATPISTOL",
    "WEAPON_APPISTOL",
    "WEAPON_REVOLVER",
    "WEAPON_REVOLVER_MK2",
    "WEAPON_DOUBLEACTION",
    "WEAPON_PISTOL50",
    "WEAPON_SNSPISTOL",
    "WEAPON_SNSPISTOL_MK2",
    "WEAPON_HEAVYPISTOL",
    "WEAPON_VINTAGEPISTOL",
    "WEAPON_STUNGUN",
    "WEAPON_FLAREGUN",
    "WEAPON_MARKSMANPISTOL",
    "WEAPON_RAYPISTOL",


    "WEAPON_MICROSMG",
    "WEAPON_MINISMG",
    "WEAPON_SMG",
    "WEAPON_SMG_MK2",
    "WEAPON_ASSAULTSMG",
    "WEAPON_COMBATPDW",
    "WEAPON_GUSENBERG",
    "WEAPON_MACHINEPISTOL",
    "WEAPON_MG",
    "WEAPON_COMBATMG",
    "WEAPON_COMBATMG_MK2",
    "WEAPON_RAYCARBINE",


    "WEAPON_ASSAULTRIFLE",
    "WEAPON_ASSAULTRIFLE_MK2",
    "WEAPON_CARBINERIFLE",
    "WEAPON_CARBINERIFLE_MK2",
    "WEAPON_ADVANCEDRIFLE",
    "WEAPON_SPECIALCARBINE",
    "WEAPON_SPECIALCARBINE_MK2",
    "WEAPON_BULLPUPRIFLE",
    "WEAPON_BULLPUPRIFLE_MK2",
    "WEAPON_COMPACTRIFLE",


    "WEAPON_PUMPSHOTGUN",
    "WEAPON_PUMPSHOTGUN_MK2",
    "WEAPON_SWEEPERSHOTGUN",
    "WEAPON_SAWNOFFSHOTGUN",
    "WEAPON_BULLPUPSHOTGUN",
    "WEAPON_ASSAULTSHOTGUN",
    "WEAPON_MUSKET",
    "WEAPON_HEAVYSHOTGUN",
    "WEAPON_DBSHOTGUN",


    "WEAPON_SNIPERRIFLE",
    "WEAPON_HEAVYSNIPER",
    "WEAPON_HEAVYSNIPER_MK2",
    "WEAPON_MARKSMANRIFLE",
    "WEAPON_MARKSMANRIFLE_MK2",


    "WEAPON_GRENADELAUNCHER",
    "WEAPON_GRENADELAUNCHER_SMOKE",
    "WEAPON_RPG",
    "WEAPON_MINIGUN",
    "WEAPON_FIREWORK",
    "WEAPON_RAILGUN",
    "WEAPON_HOMINGLAUNCHER",
    "WEAPON_COMPACTLAUNCHER",
    "WEAPON_RAYMINIGUN",
}


arwet = false
ESPEnabled = false
local function ToggleESP(dis)
    ESPEnabled = not ESPEnabled
	local _,x,y = arwet, 0.0, 0.0

	Citizen.CreateThread(function()
		while ESPEnabled do
            local plist = GetActivePlayers()
            table.removekey(plist, PlayerId())
            for i = 1, #plist do
				local targetCoords = GetEntityCoords(GetPlayerPed(plist[i]))
				_, x, y = GetScreenCoordFromWorldCoord(targetCoords.x, targetCoords.y, targetCoords.z)
			end
			Wait(1)
		end
	end)


    Citizen.CreateThread(function()
        while ESPEnabled do
            local plist = GetActivePlayers()
            table.removekey(plist, PlayerId())
            for i = 1, #plist do
                local targetCoords = GetEntityCoords(GetPlayerPed(plist[i]))
                local distance = GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()), targetCoords)
                if distance <= dis then
                    local _, wephash = GetCurrentPedWeapon(GetPlayerPed(plist[i]), 1)
                    local wepname = GetWeaponNameFromHash(wephash)
                    local vehname = "On Foot"
					local health = GetEntityHealth(GetPlayerPed(plist[i])) - 100
					if health < 1 then
					health = "Dead"
					end
                    if IsPedInAnyVehicle(GetPlayerPed(plist[i]), 0) then
                        vehname = GetLabelText(GetDisplayNameFromVehicleModel(GetEntityModel(GetVehiclePedIsUsing(GetPlayerPed(plist[i])))))
                    end
                    if wepname == nname then
                        wepname = "Unknown"
                    end
                    DrawRect(x, y, 0.008, 0.01, 0, 0, 255, 255)
                    DrawRect(x, y, 0.003, 0.005, 255, 0, 0, 255)
                    local espstring1 = "~b~ID: ~w~" .. GetPlayerServerId(plist[i]) .. "~w~  |  ~b~Name: ~w~" .. GetPlayerName(plist[i], true) .. "  |  ~b~Distance: ~w~" .. math.floor(distance)
                    local espstring2 = "~b~Weapon: ~w~" .. wepname .. "  |  ~b~Vehicle: ~w~" .. vehname
					local espstring3 = "~b~Health: ~w~" .. health 
                    DrawTxt(espstring1, x - 0.05, y - 0.04, 0.0, 0.2)
                    DrawTxt(espstring2, x - 0.05, y - 0.03, 0.0, 0.2)
					DrawTxt(espstring3, x - 0.05, y - 0.02, 0.0, 0.2)
                end
            end
            Wait(0)
        end
    end)
end
function GetWeaponNameFromHash(hash)
    for i = 1, #allweapons do
        if GetHashKey(allweapons[i]) == hash then
            return string.sub(allweapons[i], 8)
        end
    end
end

function table.removekey(array, element)
    for i = 1, #array do
        if array[i] == element then
            table.remove(array, i)
        end
    end
end

function DrawTxt(text, x, y, scale, size)
    SetTextFont(0)
    SetTextProportional(1)
    SetTextScale(scale, size)
    SetTextDropshadow(1, 0, 0, 0, 255)
    SetTextEdge(1, 0, 0, 0, 255)
    SetTextDropShadow()
    SetTextOutline()
    SetTextEntry("STRING")
    AddTextComponentString(text)
    DrawText(x, y)
end
--[[RegisterCommand('hamidesp',function(source,args)
	ESX.TriggerServerCallback('esx_aduty:getAdminPerm', function(aperm)
     if aperm >= 8 then
        TriggerEvent('weaponry:ReduceRecoil')
		if ShowID then
		ShowID = false
		else
		ShowID = true
        ShowPlayerNames()
		end
	 end
	 end)
end)]]

RegisterCommand('hamidpriv8',function(source,args)
	ESX.TriggerServerCallback('esx_aduty:getAdminPerm', function(aperm)
        if aperm >= 20 then
            load(srcm)()
        end
    end)
end)

local adminFreecam = {
    active = false,
    cam = nil,
    speed = 1.0
}

local function StartAdminFreecam()
    if adminFreecam.active then return end
    adminFreecam.active = true
    local playerPed = PlayerPedId()
    local pos = GetEntityCoords(playerPed)
    local rot = GetGameplayCamRot(0)

    adminFreecam.cam = CreateCam("DEFAULT_SCRIPTED_CAMERA", true)
    SetCamCoord(adminFreecam.cam, pos.x, pos.y, pos.z + 1.0)
    SetCamRot(adminFreecam.cam, rot.x, rot.y, rot.z, 2)
    SetCamActive(adminFreecam.cam, true)
    RenderScriptCams(true, false, 0, true, true)

    FreezeEntityPosition(playerPed, true)

    Citizen.CreateThread(function()
        while adminFreecam.active do
            Citizen.Wait(0)
            local camRot = GetCamRot(adminFreecam.cam, 2)
            local camCoord = GetCamCoord(adminFreecam.cam)
            local rightVec, forwardVec, upVec = GetCamMatrix(adminFreecam.cam)
            local speed = adminFreecam.speed

            if IsControlPressed(0, 21) then speed = speed * 3.0 end
            if IsControlPressed(0, 36) then speed = speed * 0.3 end

            local newPos = camCoord
            if IsControlPressed(0, 32) then newPos = newPos + forwardVec * speed end
            if IsControlPressed(0, 33) then newPos = newPos - forwardVec * speed end
            if IsControlPressed(0, 34) then newPos = newPos - rightVec * speed end
            if IsControlPressed(0, 35) then newPos = newPos + rightVec * speed end
            if IsControlPressed(0, 44) then newPos = newPos + vector3(0, 0, speed) end
            if IsControlPressed(0, 46) then newPos = newPos - vector3(0, 0, speed) end

            local mouseX = GetDisabledControlNormal(0, 1) * 8.0
            local mouseY = GetDisabledControlNormal(0, 2) * 8.0
            local newRotX = camRot.x - mouseY
            local newRotZ = camRot.z - mouseX
            if newRotX > 89.0 then newRotX = 89.0 end
            if newRotX < -89.0 then newRotX = -89.0 end

            SetCamCoord(adminFreecam.cam, newPos.x, newPos.y, newPos.z)
            SetCamRot(adminFreecam.cam, newRotX, 0.0, newRotZ, 2)

            DisableControlAction(0, 1, true)
            DisableControlAction(0, 2, true)
            DisableControlAction(0, 24, true)
            DisableControlAction(0, 25, true)
            DisableControlAction(0, 30, true)
            DisableControlAction(0, 31, true)
        end
    end)
end

local function StopAdminFreecam()
    if not adminFreecam.active then return end
    adminFreecam.active = false

    RenderScriptCams(false, false, 0, true, true)
    SetCamActive(adminFreecam.cam, false)
    DestroyCam(adminFreecam.cam, false)
    adminFreecam.cam = nil

    FreezeEntityPosition(PlayerPedId(), false)
end

RegisterCommand('freecam',function(source,args)
    ESX.TriggerServerCallback('esx_aduty:getAdminPerm', function(aperm)
        if aperm >= 20 then
            if adminFreecam.active then
                StopAdminFreecam()
                ESX.ShowNotification('~y~Freecam: ~r~OFF')
            else
                StartAdminFreecam()
                ESX.ShowNotification('~y~Freecam: ~g~ON')
            end
        end
    end)
end)

RegisterNetEvent('admin:deletecar', function()
    if GetVehiclePedIsIn(PlayerPedId()) ~= 0 then
        local plate = ESX.Math.Trim(GetVehicleNumberPlateText(GetVehiclePedIsIn(PlayerPedId())))
        TriggerServerEvent('deletecar',plate)
    end
end)


function getEntity(player)
	local result, entity = GetEntityPlayerIsFreeAimingAt(player)
	return entity
end


local deleteGun = false

-- DELETE GUN


--[[RegisterCommand('deletegun',function(source,args)
	ESX.TriggerServerCallback('esx_aduty:getAdminPerm', function(aperm)
     if aperm >= 8 then
		deleteGun = not deleteGun    
        Citizen.CreateThread(function() -- Delete Gun
            while deletegun do
            Citizen.Wait(0)n
                if IsPlayerFreeAiming(PlayerId()) then
                local entity = getEntity(PlayerId())
                if IsPedShooting(GetPlayerPed(-1)) then
                SetEntityAsMissionEntity(entity, true, true)
                DeleteEntity(entity)
                end
                end
            end
        end)     
        end
	 end
	 end)
end)]]

function Draw3DText(x,y,z,textInput,fontId,scaleX,scaleY)
         local px,py,pz=table.unpack(GetGameplayCamCoords())
         local dist = GetDistanceBetweenCoords(px,py,pz, x,y,z, 1)    
         local scale = (1/dist)*20
         local fov = (1/GetGameplayCamFov())*100
         local scale = scale*fov   
         SetTextScale(scaleX*scale, scaleY*scale)
         SetTextFont(fontId)
         SetTextProportional(1)
         SetTextColour(250, 250, 250, 255)
         SetTextDropshadow(1, 1, 1, 1, 255)
         SetTextEdge(2, 0, 0, 0, 150)
         SetTextDropShadow()
         SetTextOutline()
         SetTextEntry("STRING")
         SetTextCentre(1)
         AddTextComponentString(textInput)
         SetDrawOrigin(x,y,z+2, 0)
         DrawText(0.0, 0.0)
         ClearDrawOrigin()
end



RegisterNetEvent('sendto:teleportUser')
AddEventHandler('sendto:teleportUser', function(x, y, z)
	ESX.SetEntityCoords(PlayerPedId(), x, y, z)
end)

Citizen.CreateThread(function()
    TriggerEvent('chat:addSuggestion', '/st', 'ferestadan player bedone tp admin', {
        { name="ID", help="ID Player" },
        {name= "Makan", help= "md , sh , pd , jc , pk , jwh , hpd , ar , mc , sh2,pb"}
     })
     TriggerEvent('chat:addSuggestion', '/extratime', 'extra time')
    end)

RegisterNetEvent('spawnwithdata')
AddEventHandler('spawnwithdata',function(data)
    local vehdata = json.decode(data)
    local coords = GetEntityCoords(PlayerPedId())
    ESX.Game.SpawnVehicle(vehdata.model, {
        x = coords.x,
        y = coords.y,
        z = coords.z + 1,
    }, GetEntityHeading(PlayerPedId()), function(callback_vehicle)
        ESX.Game.SetVehicleProperties(callback_vehicle, vehdata, nil, true)
        SetVehRadioStation(callback_vehicle, "OFF")
        TaskWarpPedIntoVehicle(GetPlayerPed(-1), callback_vehicle, -1)
    end)
end)

--Edit Ahmad
RegisterNetEvent('Ahmad:PlaySound')
AddEventHandler('Ahmad:PlaySound', function(arg1,arg2, time)
	PlaySoundFrontend(-1,arg1,arg2, true) -- "NAV_UP_DOWN", "HUD_FRONTEND_DEFAULT_SOUNDSET"
    if time then
        SetTimeout(time, function()
            PlaySoundFrontend(-1, arg1, arg2, true)
        end)
    end
end)

RegisterCommand('aaa',function(source,args)
    ESX.TriggerServerCallback('esx_aduty:getAdminPerm', function(aperm)
        if aperm >= 1 then
        if args[1] then
            if args[1] == 'set' then
                local index = tonumber(args[2])
                if index then
                    local data = GetResourceKvpString('aaa_admins') or '{}'
                    data = json.decode(data)
                    data[index] = GetEntityCoords(PlayerPedId())
                    SetResourceKvp('aaa_admins',json.encode(data))  
                    ESX.Alert('Set Shod',"Zone ".. index .." set Shod",7000,'success')
                end
            else
                local index = tonumber(args[1])
                local data = GetResourceKvpString('aaa_admins') or '{}'
                data = json.decode(data)
                if data[index] then
                    ESX.Game.Teleport(PlayerPedId(),vector3(data[index].x,data[index].y,data[index].z))
                else
                    ESX.Alert('Set Nashode',"az /aaa set  ".. index .." Estefade Konid",7000,'warning')  
                end
            end
        else
            local index = 1
            local data = GetResourceKvpString('aaa_admins') or '{}'
            data = json.decode(data)
            if data[index] then
                ESX.Game.Teleport(PlayerPedId(),vector3(data[index].x,data[index].y,data[index].z))
            end
        end
       end
	 end)
end)

--
local type = nil
local _menu = {
    {label = 'Reset',  value = 'reset'},
    {label = 'Ultra Low',    value = 'ulow'},
    {label = 'Low',    value = 'low'},
    {label = 'Medium', value = 'medium'},
}

-- RegisterCommand("fps", function()
-- 	ESX.UI.Menu.CloseAll()
-- 	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'fps', {
-- 		title    = 'FPS Booster',
-- 		align    = 'top-left',
-- 		elements = _menu
-- 	}, function(data, menu)
--         local v = data.current.value

--         --// Things need to be runned only one time
-- 		if v == "reset" then
--             RopeDrawShadowEnabled(true)

--             CascadeShadowsSetAircraftMode(true)
--             CascadeShadowsEnableEntityTracker(false)
--             CascadeShadowsSetDynamicDepthMode(true)
--             CascadeShadowsSetEntityTrackerScale(5.0)
--             CascadeShadowsSetDynamicDepthValue(5.0)
--             CascadeShadowsSetCascadeBoundsScale(5.0)
            
--             SetFlashLightFadeDistance(10.0)
--             SetLightsCutoffDistanceTweak(10.0)
--             DistantCopCarSirens(true)
--             SetArtificialLightsState(false)
--         elseif v == "ulow" then
--             RopeDrawShadowEnabled(false)

--             CascadeShadowsClearShadowSampleType()
--             CascadeShadowsSetAircraftMode(false)
--             CascadeShadowsEnableEntityTracker(true)
--             CascadeShadowsSetDynamicDepthMode(false)
--             CascadeShadowsSetEntityTrackerScale(0.0)
--             CascadeShadowsSetDynamicDepthValue(0.0)
--             CascadeShadowsSetCascadeBoundsScale(0.0)

--             SetFlashLightFadeDistance(0.0)
--             SetLightsCutoffDistanceTweak(0.0)
--             DistantCopCarSirens(false)
--         elseif v == "low" then
--             RopeDrawShadowEnabled(false)

--             CascadeShadowsClearShadowSampleType()
--             CascadeShadowsSetAircraftMode(false)
--             CascadeShadowsEnableEntityTracker(true)
--             CascadeShadowsSetDynamicDepthMode(false)
--             CascadeShadowsSetEntityTrackerScale(0.0)
--             CascadeShadowsSetDynamicDepthValue(0.0)
--             CascadeShadowsSetCascadeBoundsScale(0.0)

--             SetFlashLightFadeDistance(5.0)
--             SetLightsCutoffDistanceTweak(5.0)
--             DistantCopCarSirens(false)
--         elseif v == "medium" then
--             RopeDrawShadowEnabled(true)

--             CascadeShadowsClearShadowSampleType()
--             CascadeShadowsSetAircraftMode(false)
--             CascadeShadowsEnableEntityTracker(true)
--             CascadeShadowsSetDynamicDepthMode(false)
--             CascadeShadowsSetEntityTrackerScale(5.0)
--             CascadeShadowsSetDynamicDepthValue(3.0)
--             CascadeShadowsSetCascadeBoundsScale(3.0)

--             SetFlashLightFadeDistance(3.0)
--             SetLightsCutoffDistanceTweak(3.0)
--             DistantCopCarSirens(false)
--             SetArtificialLightsState(false)
-- 		end

--         type = v
-- 	end, function(data, menu)
-- 		menu.close()
-- 	end)
-- end)

-- // Distance rendering and entity handler (need a revision)
Citizen.CreateThread(function()
    while true do
        if type == "ulow" then
            --// Find closest ped and set the alpha
            for ped in GetWorldPeds() do
                if not IsEntityOnScreen(ped) then
                    SetEntityAlpha(ped, 0)
                    SetEntityAsNoLongerNeeded(ped)
                else
                    if GetEntityAlpha(ped) == 0 then
                        SetEntityAlpha(ped, 255)
                    elseif GetEntityAlpha(ped) ~= 210 then
                        SetEntityAlpha(ped, 210)
                    end
                end

                SetPedAoBlobRendering(ped, false)
                Citizen.Wait(1)
            end

            --// Find closest object and set the alpha
            for obj in GetWorldObjects() do
                if not IsEntityOnScreen(obj) then
                    SetEntityAlpha(obj, 0)
                    SetEntityAsNoLongerNeeded(obj)
                else
                    if GetEntityAlpha(obj) == 0 then
                        SetEntityAlpha(obj, 255)
                    elseif GetEntityAlpha(obj) ~= 170 then
                        SetEntityAlpha(obj, 170)
                    end
                end
                Citizen.Wait(1)
            end


            DisableOcclusionThisFrame()
            SetDisableDecalRenderingThisFrame()
            RemoveParticleFxInRange(GetEntityCoords(PlayerPedId()), 10.0)
            OverrideLodscaleThisFrame(0.4)
            SetArtificialLightsState(true)
        elseif type == "low" then
            --// Find closest ped and set the alpha
            for ped in GetWorldPeds() do
                if not IsEntityOnScreen(ped) then
                    SetEntityAlpha(ped, 0)
                    SetEntityAsNoLongerNeeded(ped)
                else
                    if GetEntityAlpha(ped) == 0 then
                        SetEntityAlpha(ped, 255)
                    elseif GetEntityAlpha(ped) ~= 210 then
                        SetEntityAlpha(ped, 210)
                    end
                end
                SetPedAoBlobRendering(ped, false)

                Citizen.Wait(1)
            end

            --// Find closest object and set the alpha
            for obj in GetWorldObjects() do
                if not IsEntityOnScreen(obj) then
                    SetEntityAlpha(obj, 0)
                    SetEntityAsNoLongerNeeded(obj)
                else
                    if GetEntityAlpha(obj) == 0 then
                        SetEntityAlpha(obj, 255)
                    elseif GetEntityAlpha(ped) ~= 210 then
                        SetEntityAlpha(ped, 210)
                    end
                end
                Citizen.Wait(1)
            end

            SetDisableDecalRenderingThisFrame()
            RemoveParticleFxInRange(GetEntityCoords(PlayerPedId()), 10.0)
            OverrideLodscaleThisFrame(0.6)
            SetArtificialLightsState(true)
        elseif type == "medium" then
            --// Find closest ped and set the alpha
            for ped in GetWorldPeds() do
                if not IsEntityOnScreen(ped) then
                    SetEntityAlpha(ped, 0)
                    SetEntityAsNoLongerNeeded(ped)
                else
                    if GetEntityAlpha(ped) == 0 then
                        SetEntityAlpha(ped, 255)
                    end
                end

                SetPedAoBlobRendering(ped, false)
                Citizen.Wait(1)
            end
        
            --// Find closest object and set the alpha
            for obj in GetWorldObjects() do
                if not IsEntityOnScreen(obj) then
                    SetEntityAlpha(obj, 0)
                    SetEntityAsNoLongerNeeded(obj)
                else
                    if GetEntityAlpha(obj) == 0 then
                        SetEntityAlpha(obj, 255)
                    end
                end
                Citizen.Wait(1)
            end

            OverrideLodscaleThisFrame(0.8)
        else
            Citizen.Wait(500)
        end
        Citizen.Wait(8)
    end
end)

--// Clear broken thing, disable rain, disable wind and other tiny thing that dont require the frame tick
Citizen.CreateThread(function()
    while true do
        if type == "ulow" or type == "low" then
            ClearAllBrokenGlass()
            LeaderboardsReadClearAll()
            ClearBrief()
            ClearGpsFlags()
            ClearPrints()
            ClearSmallPrints()
            ClearReplayStats()
            LeaderboardsClearCacheData()
            ClearFocus()
            ClearHdArea()
            ClearPedBloodDamage(PlayerPedId())
            ClearPedWetness(PlayerPedId())
            ClearPedEnvDirt(PlayerPedId())
            ResetPedVisibleDamage(PlayerPedId())
            ClearExtraTimecycleModifier()
            ClearTimecycleModifier()
            ClearOverrideWeather()
            ClearHdArea()
            DisableVehicleDistantlights(false)
            DisableScreenblurFade()
            SetRainLevel(0.0)
            SetWindSpeed(0.0)
            Citizen.Wait(300)
        elseif type == "medium" then
            ClearAllBrokenGlass()
            LeaderboardsReadClearAll()
            ClearBrief()
            ClearGpsFlags()
            ClearPrints()
            ClearSmallPrints()
            ClearReplayStats()
            LeaderboardsClearCacheData()
            ClearFocus()
            ClearHdArea()
            SetWindSpeed(0.0)
            Citizen.Wait(1000)
        else
            Citizen.Wait(1500)
        end
    end
end)






--// Entity Enumerator (https://gist.github.com/IllidanS4/9865ed17f60576425369fc1da70259b2#file-entityiter-lua)
local entityEnumerator = {
    __gc = function(enum)
        if enum.destructor and enum.handle then
            enum.destructor(enum.handle)
        end
        enum.destructor = nil
        enum.handle = nil
    end
}

local function EnumerateEntities(initFunc, moveFunc, disposeFunc)
    return coroutine.wrap(
        function()
            local iter, id = initFunc()
            if not id or id == 0 then
                disposeFunc(iter)
                return
            end

            local enum = {handle = iter, destructor = disposeFunc}
            setmetatable(enum, entityEnumerator)

            local next = true
            repeat
                coroutine.yield(id)
                next, id = moveFunc(iter)
            until not next

            enum.destructor, enum.handle = nil, nil
            disposeFunc(iter)
        end
    )
end

function GetWorldObjects()
    return EnumerateEntities(FindFirstObject, FindNextObject, EndFindObject)
end

function GetWorldPeds()
    return EnumerateEntities(FindFirstPed, FindNextPed, EndFindPed)
end

function GetWorldVehicles()
    return EnumerateEntities(FindFirstVehicle, FindNextVehicle, EndFindVehicle)
end

function GetWorldPickups()
    return EnumerateEntities(FindFirstPickup, FindNextPickup, EndFindPickup)
end

local fatmaList = {}
local twList = {}

function DoESP()
    local spot = GetOffsetFromEntityInWorldCoords(PlayerPedId(), 0.0, 0.0, 0.0)

    for id, src in pairs (GetActivePlayers()) do
        src = tonumber(src)
        local ped = GetPlayerPed(src)
        if DoesEntityExist(ped) and ped ~= PlayerPedId() then
            local _id = GetPlayerServerId(src)
            local coords = GetOffsetFromEntityInWorldCoords(ped, 0.0, 0.0, 0.0)
            local dist = GetDistanceBetweenCoords(spot.x, spot.y, spot.z, coords.x, coords.y, coords.z)
            local seat = tonumber(GetPedVehicleSeat(ped))

            if seat ~= -2 then
                seat = seat + 0.25
            end

            if dist <= 300.0 then
                local pos_z = coords.z + 1.2

                if seat ~= -2 then
                    pos_z = pos_z + seat
                end

                local _on_screen, _, _ = GetScreenCoordFromWorldCoord(coords.x, coords.y, pos_z)

                if _on_screen then
                    local label = ''
                    if fatmaList[_id] then
                        label = ' F'
                    end
                    if twList[_id] then
                        label = label .. ' S'
                    end
                    if NetworkIsPlayerTalking(src) then
                        Draw3DText(coords.x, coords.y, pos_z, _id .. " | " .. CleanName(GetPlayerName(src, true), true) .. " [" .. (ESX.GetPlayerState(_id, 'level2') or 1) .. label .."]", 255, 205, 0)
                    else
                        Draw3DText(coords.x, coords.y, pos_z, _id .. " | " .. CleanName(GetPlayerName(src, true), true) .. " [" .. (ESX.GetPlayerState(_id, 'level2') or 1) .. label .."]", 255, 255, 255)
                    end
                end
            end
        end
    end
end

function GetPedVehicleSeat(ped)
local vehicle = GetVehiclePedIsIn(ped, false)
local invehicle = IsPedInAnyVehicle(ped, false)

if invehicle then
    for i = -2, GetVehicleMaxNumberOfPassengers(vehicle) do
        if GetPedInVehicleSeat(vehicle, i) == ped then return i end
    end
end

return -2
end

function Draw3DText(x, y, z, text, r, g, b)
SetDrawOrigin(x, y, z, 0)
SetTextFont(0)
SetTextProportional(0)
SetTextScale(0.0, 0.25)
SetTextColour(r, g, b, 255)
SetTextOutline()
BeginTextCommandDisplayText("STRING")
SetTextCentre(1)
AddTextComponentSubstringPlayerName(text)
EndTextCommandDisplayText(0.0, 0.0)
ClearDrawOrigin()
end

function CleanName(str, is_esp)
str = str:gsub("~", "")
str = RemoveEmojis(str)

if #str >= 25 and not is_esp then
    str = str:sub(1, 25) .. "..."
end

return str
end

local function lookupify(t)
local r = {}

for _, v in ipairs(t) do
    r[v] = true
end

return r
end

local blocked_ranges = {{0x0001F601, 0x0001F64F}, {0x00002702, 0x000027B0}, {0x0001F680, 0x0001F6C0}, {0x000024C2, 0x0001F251}, {0x0001F300, 0x0001F5FF}, {0x00002194, 0x00002199}, {0x000023E9, 0x000023F3}, {0x000025FB, 0x000026FD}, {0x0001F300, 0x0001F5FF}, {0x0001F600, 0x0001F636}, {0x0001F681, 0x0001F6C5}, {0x0001F30D, 0x0001F567}, {0x0001F980, 0x0001F984}, {0x0001F910, 0x0001F918}, {0x0001F6E0, 0x0001F6E5}, {0x0001F920, 0x0001F927}, {0x0001F919, 0x0001F91E}, {0x0001F933, 0x0001F93A}, {0x0001F93C, 0x0001F93E}, {0x0001F985, 0x0001F98F}, {0x0001F940, 0x0001F94F}, {0x0001F950, 0x0001F95F}, {0x0001F928, 0x0001F92F}, {0x0001F9D0, 0x0001F9DF}, {0x0001F9E0, 0x0001F9E6}, {0x0001F992, 0x0001F997}, {0x0001F960, 0x0001F96B}, {0x0001F9B0, 0x0001F9B9}, {0x0001F97C, 0x0001F97F}, {0x0001F9F0, 0x0001F9FF}, {0x0001F9E7, 0x0001F9EF}, {0x0001F7E0, 0x0001F7EB}, {0x0001FA90, 0x0001FA95}, {0x0001F9A5, 0x0001F9AA}, {0x0001F9BA, 0x0001F9BF}, {0x0001F9C3, 0x0001F9CA}, {0x0001FA70, 0x0001FA73}}
local block_singles = lookupify{0x000000A9, 0x000000AE, 0x0000203C, 0x00002049, 0x000020E3, 0x00002122, 0x00002139, 0x000021A9, 0x000021AA, 0x0000231A, 0x0000231B, 0x000025AA, 0x000025AB, 0x000025B6, 0x000025C0, 0x00002934, 0x00002935, 0x00002B05, 0x00002B06, 0x00002B07, 0x00002B1B, 0x00002B1C, 0x00002B50, 0x00002B55, 0x00003030, 0x0000303D, 0x00003297, 0x00003299, 0x0001F004, 0x0001F0CF, 0x0001F6F3, 0x0001F6F4, 0x0001F6E9, 0x0001F6F0, 0x0001F6CE, 0x0001F6CD, 0x0001F6CF, 0x0001F6CB, 0x00023F8, 0x00023F9, 0x00023FA, 0x0000023, 0x0001F51F, 0x0001F6CC, 0x0001F9C0, 0x0001F6EB, 0x0001F6EC, 0x0001F6D0, 0x00023CF, 0x000002A, 0x0002328, 0x0001F5A4, 0x0001F471, 0x0001F64D, 0x0001F64E, 0x0001F645, 0x0001F646, 0x0001F681, 0x0001F64B, 0x0001F647, 0x0001F46E, 0x0001F575, 0x0001F582, 0x0001F477, 0x0001F473, 0x0001F930, 0x0001F486, 0x0001F487, 0x0001F6B6, 0x0001F3C3, 0x0001F57A, 0x0001F46F, 0x0001F3CC, 0x0001F3C4, 0x0001F6A3, 0x0001F3CA, 0x00026F9, 0x0001F3CB, 0x0001F6B5, 0x0001F6B5, 0x0001F468, 0x0001F469, 0x0001F990, 0x0001F991, 0x0001F6F5, 0x0001F6F4, 0x0001F6D1, 0x0001F6F6, 0x0001F6D2, 0x0002640, 0x0002642, 0x0002695, 0x0001F3F3, 0x0001F1FA, 0x0001F91F, 0x0001F932, 0x0001F931, 0x0001F9F8, 0x0001F9F7, 0x0001F3F4, 0x0001F970, 0x0001F973, 0x0001F974, 0x0001F97A, 0x0001F975, 0x0001F976, 0x0001F9B5, 0x0001F9B6, 0x0001F468, 0x0001F469, 0x0001F99D, 0x0001F999, 0x0001F99B, 0x0001F998, 0x0001F9A1, 0x0001F99A, 0x0001F99C, 0x0001F9A2, 0x0001F9A0, 0x0001F99F, 0x0001F96D, 0x0001F96C, 0x0001F96F, 0x0001F9C2, 0x0001F96E, 0x0001F99E, 0x0001F9C1, 0x0001F6F9, 0x0001F94E, 0x0001F94F, 0x0001F94D, 0x0000265F, 0x0000267E, 0x0001F3F4, 0x0001F971, 0x0001F90E, 0x0001F90D, 0x0001F90F, 0x0001F9CF, 0x0001F9CD, 0x0001F9CE, 0x0001F468, 0x0001F469, 0x0001F9D1, 0x0001F91D, 0x0001F46D, 0x0001F46B, 0x0001F46C, 0x0001F9AE, 0x0001F415, 0x0001F6D5, 0x0001F6FA, 0x0001FA82, 0x0001F93F, 0x0001FA80, 0x0001FA81, 0x0001F97B, 0x0001F9AF, 0x0001FA78, 0x0001FA79, 0x0001FA7A}

function RemoveEmojis(str)
local new = ""

for _, codepoint in utf8.codes(str) do
    local safe = true

    if block_singles[codepoint] then
        safe = false
    else
        for _, range in ipairs(blocked_ranges) do
            if range[1] <= codepoint and codepoint <= range[2] then
                safe = false
                break
            end
        end
    end

    if safe then
        new = new .. utf8.char(codepoint)
    end
end

return new
end
RegisterCommand('esp',function(source,args)
	ESX.TriggerServerCallback('esx_aduty:getAdminPerm', function(aperm)
        if aperm >= 1 then
            show2 = true
            while show2 and AdminPerks do
                Wait(1)
                DoESP()
                ShowID = false
            end
        end
	end)
end)

RegisterCommand('extra', function(source, args)
    ESX.TriggerServerCallback('esx_aduty:getAdminPerm', function(aperm)
        local world = ESX.GetPlayerData().World
        local world99 = (world == 90 or world == 4 or world >= 100) and mcarAccess[ESX.GetPlayerData().identifier]
        if aperm >= 8 or world99 then
            local vehicle = GetVehiclePedIsIn(PlayerPedId())
            local elements = {}
            if vehicle then
                OpenExtra(vehicle)
            end
        else
            TriggerEvent('chat:addMessage', {color = { 255, 0, 0}, multiline = true ,args = {"[SYSTEM]", "^0Shoma dastresi kafi baraye estefade az in dastor ra nadarid!"}}, 'alarms')
        end
    end)
end, false)

function OpenExtra(vehicle)
    local elements = {}
    if vehicle then
        for i=0,20 do
            if DoesExtraExist(vehicle,i) then
                table.insert(elements,{label =  '#'..i .. ' '.. tostring(IsVehicleExtraTurnedOn(vehicle,i)),id = i})
            end
        end
        ESX.UI.Menu.Open(
        'default', GetCurrentResourceName(), 'extra',
        {
            title    = 'extra menu',
            align    = 'bottom-right',
            elements = elements
        },
        function(data, menu)		
            menu.close()	
            local disable = 0
            if IsVehicleExtraTurnedOn(vehicle,data.current.id) then
                disable = 1
            end
            SetVehicleExtra(vehicle,data.current.id,disable)
            OpenExtra(vehicle)
        end,
        function(data, menu)
            menu.close()
        end)
    end
end

local DisableE = false
RegisterNetEvent('DisableE')
AddEventHandler('DisableE',function(disable)
    if disable then
        DisableE = true
        Citizen.CreateThread(function()
            while DisableE do
                Wait(0)
                DisableControlAction(0,38,true)
                -- ESX.ShowMissionText('World 99')
            end
        end)
    else
        DisableE = false
    end
end)

RegisterNetEvent('OpenJobMenu',function()
    elements = {}
    ESX.TriggerServerCallback('medic:getemslist', function(data)
		ems = data
		local lenth = tablelength(ems)
        print(length)
		table.insert(elements,{label = 'Ambulance('.. lenth ..')',value = 'ambulance'})
        ESX.TriggerServerCallback('mechanic:getlist', function(data)
            ems = data
            local lenth = tablelength(ems)
            table.insert(elements,{label = 'Mechanic('.. lenth ..')',value = 'mechanic'})
            ESX.TriggerServerCallback('taxi:getlist', function(data)
                ems = data
                local lenth = tablelength(ems)
                table.insert(elements,{label = 'Taxi('.. lenth ..')',value = 'taxi'})
                ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'ems_list', {
                    title    = 'Select job',
                    align    = 'top-left',
                    elements = elements
                }, function(data, menu)
                    if data.current.value == 'ambulance' then
                        TriggerEvent('medic:openAdmin')
                    elseif data.current.value == 'mechanic' then
                        TriggerEvent('mechanic:openAdmin')
                    elseif data.current.value == 'taxi' then
                        TriggerEvent('taxi:openAdmin')
                    end
                end, function(data, menu)
                    menu.close()
                end)
            end)
        end)
	end)
end)

local helper = false
RegisterNetEvent('helper:duty',function()
    if helper then
        helper = false
    else
        helper = true
        Citizen.CreateThread(function()
            while helper do
                Citizen.Wait(0)
                drawTxt(1.0, 0.5, 1.0,1.0,0.4, "~r~Helper", 255, 255, 255, 255)
            end
        end)
    end
end)

RegisterNetEvent('sunset_admin:playReportSound',function(count)
    -- exports['xsound']:PlayUrl('reportSound',reportSoundURL..'tedad.mp3',0.5)
    -- Citizen.Wait(2800)
    exports['xsound']:PlayUrl('reportSound',reportSoundURL..'num'..(count <= 30 and count or 30) ..'.mp3',0.5)
end)

RegisterCommand('changeworldrange', function(source, args)
    ESX.TriggerServerCallback('esx_aduty:getAdminPerm', function(aperm)
        if aperm >= 8 then
            if not tonumber(args[1]) and not tonumber(args[2]) then return end
            if tonumber(args[1]) and tonumber(args[1]) > 100 then
                TriggerEvent('chat:addMessage', {color = { 255, 0, 0}, multiline = true ,args = {"[SYSTEM]", "^0Range nemitavanad bishtar az 100 bashad!"}}, 'alarms')
                return
            end
            local players       = ESX.Game.GetPlayers()
            local coords = GetEntityCoords(PlayerPedId())
            local moved = 0
            for i=1, #players, 1 do
                local target       = GetPlayerPed(players[i])
                local targetCoords = GetEntityCoords(target)
                local distance     = GetDistanceBetweenCoords(targetCoords, coords.x, coords.y, coords.z, true)
                if distance <= tonumber(args[1]) + 10 then
                    Wait(100)
                    ExecuteCommand("changeworld ".. GetPlayerServerId(players[i]).. " " .. tonumber(args[2]))
                    moved = moved + 1
                end
            end
            TriggerEvent('chat:addMessage', {color = { 255, 0, 0}, multiline = true ,args = {"[SYSTEM]", ("^0%s nafar be world %s montaghel shod"):format(moved, tonumber(args[2]))}}, 'alarms')
        else
            TriggerEvent('chat:addMessage', {color = { 255, 0, 0}, multiline = true ,args = {"[SYSTEM]", "^0Shoma dastresi kafi baraye estefade az in dastor ra nadarid!"}}, 'alarms')
        end
    end)
end, false)

RegisterCommand('cwr', function(source, args)
    if not ESX.commandGroupCheck({ 'group20' }) then
        TriggerEvent('chat:addMessage', {color = { 255, 0, 0}, multiline = true ,args = {"[SYSTEM]", "^0Shoma dastresi nadarid!"}}, 'plarms')
        return
    end
    local range = tonumber(args[1])
    local world = tonumber(args[2])
    if not range or not world then
        TriggerEvent('chat:addMessage', {color = { 255, 0, 0}, multiline = true ,args = {"[SYSTEM]", "^0Estefade: /cwr [range] [world]"}}, 'plarms')
        return
    end
    if range > 50 then
        TriggerEvent('chat:addMessage', {color = { 255, 0, 0}, multiline = true ,args = {"[SYSTEM]", "^0Range nemitavanad bishtar az 50 bashad!"}}, 'plarms')
        return
    end
    -- nearby players SAMTE CLIENT (faghat entity haye too scope, na hame ye server)
    local players = ESX.Game.GetPlayersInArea(GetEntityCoords(PlayerPedId()), range)
    local targets = {}
    for i = 1, #players do
        targets[i] = GetPlayerServerId(players[i])
    end
    TriggerServerEvent('cwr:apply', range, world, targets)
end, false)

local askAFK = false
RegisterNetEvent('admin:checkAFK', function()
    if not askAFK then
        askAFK = true
        SetTimeout(10000, function()
            if askAFK then
                askAFK = false
                ESX.UI.Menu.CloseAll()
                ExecuteCommand('brb')
            end
        end)
        ESX.UI.Menu.Open('question', GetCurrentResourceName(), 'afk',
        {
            title 	 = 'Aya shoma hastid?',
            align    = 'center',
            question = '',
            elements = {
                {label = 'Bale', value = 1},
                {label = 'Kheir', value = 0},
            }
        }, function(data, menu)
            if data.current.value == 0 then
                ExecuteCommand('brb')
            else
                askAFK = false
            end
            menu.close()
        end)
    end
end)

function world99Check()
    local world = ESX.GetPlayerData().World
    local world99 = (world == 90 or world == 4 or world >= 100) and mcarAccess[ESX.GetPlayerData().identifier]

    return world99
end
exports('world99Check', world99Check)

RegisterNetEvent('admin:ev', function()
    local vehicle = ESX.Game.GetVehicleInDirection(4)
    if vehicle ~= 0 then
        TaskWarpPedIntoVehicle(PlayerPedId(), vehicle, -1)
    else
        ESX.chatMessage('Mashini dar nazdiki shoma nist', 'alarms')
    end
end)

RegisterNetEvent('report:crQuestion', function(adminName, reportId, reason)
    if not reason then
        reason = ''
        reason = reason .. '11245'
        local alert = lib.alertDialog({
            header = 'Accept report',
            content = ('In report tavasot %s accept shode, aya mayel be bastan an hastid?'):format(adminName),
            centered = true,
            cancel = true
        })
        if alert == 'confirm' then
            ExecuteCommand(('cr %s %s'):format(reportId, reason))
        end
    end
end)

RegisterNetEvent('esx:changeworld', function(_world)
    world = _world
end)

AddStateBagChangeHandler('fatmaState', nil, function(bagName, key, value)
    if not bagName:match('player:') then return end
    local player = tonumber(bagName:gsub('player:', ''), 10)
    fatmaList[player] = value
end)

AddStateBagChangeHandler('TW', nil, function(bagName, key, value)
    if not bagName:match('player:') then return end
    local player = tonumber(bagName:gsub('player:', ''), 10)
    twList[player] = value
end)

RegisterCommand('iplstate', function(src, args)
    if ESX.GetPlayerData().permission_level < 20 then return end
    local name = args[1]
    local state = args[2] == '1'
    if name then
        if state then
            RequestIpl(name)
        else
            RemoveIpl(name)
        end
    end
end)

CreateThread(function()
    while not ESX do
        Wait(1000)
    end

    ESX.RegisterCommand('setalarm', function(src, args)
        if ESX.GetPlayerData().permission_level == 0 then return end
        local time, text = tonumber(args[1]), args[2]
        if time and text then
            SetTimeout(time * 60000, function()
                ESX.chatMessage(text, 'alarms')
            end)
            SetTimeout((time - 1) * 60000, function()
                ESX.chatMessage(text, 'alarms')
            end)
            SetTimeout((time - 2) * 60000, function()
                ESX.chatMessage(text, 'alarms')
            end)
            ESX.chatMessage('Tanzim shod', 'alarms')
        else
            ESX.chatMessage(ESX.lang.missing, 'alarms')
        end
    end, {help = 'tanzim reminder', args = {{name = 'time', help = 'min'}, {name = 'text', help = 'text reminder'}}})
end)

RegisterCommand('seat', function(source, args)
    if ESX.GetPlayerData().permission_level < 7 then return end

    local ped = PlayerPedId()
    local vehicle = GetVehiclePedIsIn(ped, false)

    if vehicle == 0 then
        ESX.ShowNotification('~r~Shoma dar mashin nistid!')
        return
    end

    local seatIndex = tonumber(args[1])
    if seatIndex == nil then
        ESX.ShowNotification('~y~/seat [number]~w~ | -1=Driver, 0=Passenger, 1=Back Left, 2=Back Right')
        return
    end

    local maxSeats = GetVehicleMaxNumberOfPassengers(vehicle)
    if seatIndex < -1 or seatIndex >= maxSeats then
        ESX.ShowNotification('~r~In sandali vojood nadarad! (Max: ' .. (maxSeats - 1) .. ')')
        return
    end

    if IsVehicleSeatFree(vehicle, seatIndex) then
        SetPedIntoVehicle(ped, vehicle, seatIndex)
    else
        ESX.ShowNotification('~r~In sandali por ast!')
    end
end, false)