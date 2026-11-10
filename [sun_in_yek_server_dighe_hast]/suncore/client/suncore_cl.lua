-- Pub by FleeX Team , https://discord.gg/87rGBxgCsa

ESX = nil
world = 0
ped = PlayerPedId()
playerid = PlayerId()
isAdmin = false
whitelisted = false
isloaded = true
ignore = false
local PlayerData = {}
local DisableAttack = true
local notify = true
local commandcount = nil
local cooldownkey = {}
whiteStuff = false
whiteStuffCar = false
whiteStuffCoords = false
finalyLoaded = false

RegisterNetEvent('esx:changeworld', function(_)
	world = _
end)

Citizen.CreateThread(function()
    while ESX == nil do
        TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
        Citizen.Wait(0)
    end
    ped = PlayerPedId()
    while ESX.GetPlayerData().job == nil do
        Citizen.Wait(10)
    end
    PlayerData = ESX.GetPlayerData()
    CheckSkin()
    ESX.TriggerServerCallback('esx_aduty:checkAdmin', function(admin)
        isAdmin =  admin
    end)
    Wait(2000)
    TriggerServerEvent('suncore:checkme')
end)

-- AddEventHandler('onKeyUP',function(key)
-- 	if key == "f8" or key == "delete" or key == "tab" or key == "insert" then
-- 		if not cooldownkey[key] then
-- 			cooldownkey[key] = true
-- 			Wait(300)
-- 			TriggerServerEvent('suncore:imkeypressed',key)
-- 			Citizen.SetTimeout(10000,function()
-- 				cooldownkey[key] = nil
-- 			end)
-- 		end
-- 	end
-- end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(playerData)
    TriggerServerEvent("sc:loaded")
    Citizen.Wait(10000)
    isloaded = true
end)


AddEventHandler('sun:clotheLoaded',function()
    finalyLoaded = true
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
    PlayerData.job = job
end)

AddEventHandler("playerSpawned", function()
    commandcount = #GetRegisteredCommands()
    resourcecount = GetNumResources()
end)

local inPaintball = false

AddEventHandler('inPaintball', function(_inPaintball)
    inPaintball = _inPaintball
end)

Citizen.CreateThread(function()
    while ESX == nil do Citizen.Wait(1000) end
    while true do
        Citizen.Wait(20000)
        -- if GetPedConfigFlag(PlayerPedId(),2) == 1 then
        --     if PlayerData.job and not jobs[PlayerData.job.name] then
        --         if ESX.GetPlayerData().World == 0 then
        --             local _ = ESX.GetDistance(GetEntityCoords(PlayerPedId()),vector3(-1135,4922,219))
        --             local __ = GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()),vector3(2382.2,4937.77,43.09))
        --             if _ > 200 and __ > 400 then
        --                 alarm("Mashkuk be 3 shot bug abuse")
        --             end
        --         end
        --     end
        -- end
        if not isAdmin then
            if not ESX.GetPlayerData().IsInjure then
                -- local PPed = PlayerPedId()
                -- local EHealth = GetEntityHealth(PPed)
                -- ESX.SetEntityHealth(PPed, EHealth-2)
                -- local randomTimer = math.random(10, 150)
                -- Citizen.Wait(randomTimer)
                -- if not IsPlayerDead(PlayerId()) then
                --     if GetEntityHealth(PPed) == EHealth and GetEntityHealth(PPed) ~= 0 and ESX.GetPlayerData().job.name ~= 'fbi' and ESX.GetPlayerData().World ~= 98 then
                --         alarm("Mashkuk be god mode(can be false positive)")
                --     else
                --         ESX.SetEntityHealth(PPed, EHealth)
                --     end
                -- end
                if GetPlayerInvincible(PlayerId()) and ESX.GetPlayerData().job.name ~= 'fbi' and ESX.GetPlayerData().job.name ~= 'offfbi' and not inPaintball then
                    alarm("Mashkuk be god mode(FiveM Native)")
                    SetPlayerInvincible(PlayerId(), false)
                end
            end
        end
        if world == 0 and GetPedConfigFlag(PlayerPedId(), 2, true) == 1 and (PlayerData.job and not ESX.militaryJobs[PlayerData.job.name]) then
            local mythic = #(GetEntityCoords(PlayerPedId()) - vector3(2382.2,4937.77,43.09))
            if mythic > 400 and not ESX.GetPlayerData().isInIslandZone then
                Wait(10000)
                if GetPedConfigFlag(PlayerPedId(), 2, true) == 1 then
                    alarm('Mashkuk be PAH')
                end
            end
        end
    end
end)



Citizen.CreateThread(function()
    local unarmed = `WEAPON_UNARMED`
    while true do
        local ped = PlayerPedId()
        --armor 200
        local armor = GetPedArmour(Ped)
        if NetworkIsInSpectatorMode() and not ignore then
            alarm("Try to spectate")
        end
        if IsPedSittingInAnyVehicle(ped) and IsVehicleVisible(GetVehiclePedIsIn(ped)) and GetSelectedPedWeapon(PlayerPedId()) == unarmed and world == 0 then
            ban("Use invisible vehicle")
        end
        if GetUsingseethrough() and PlayerData.job.name ~= "police" and PlayerData.job.name ~= "sheriff" and PlayerData.job.name ~= "mt" and PlayerData.job.name ~= "ambulance" and PlayerData.job.name ~= "fbi" and PlayerData.job.name ~= "justice" and PlayerData.job.name ~= "detective" and not inPaintball then
            ban("Use thermal vision")
        end
        -- if GetUsingnightvision() and PlayerData.job.name ~= "police" and PlayerData.job.name ~= "sheriff" and PlayerData.job.name ~= "mt" and PlayerData.job.name ~= "ambulance" and PlayerData.job.name ~= "fbi"  then
        --     alarm("Use night vision")
        -- end

        if not IsEntityVisible(ped) and not whitelisted and IsPedSittingInAnyVehicle(ped) and GetEntityModel(GetVehiclePedIsIn(ped, false)) ~= `rcbandito` and GetEntityModel(GetVehiclePedIsIn(ped, false)) ~= `minitank` then
            SetEntityVisible(PlayerPedId(), true, 0)
            TriggerServerEvent("sc:adminalarm","Mashkuk be invisible(can be false positive)")
        end

        -- if IsPedInAnyVehicle(PlayerPedId()) then
        --     SetVehicleEnginePowerMultiplier(GetVehiclePedIsIn(PlayerPedId()),1.0)
        -- end

        Citizen.Wait(5000)
    end
end)


Citizen.CreateThread(function()
    while true do
        local unarmed = `WEAPON_UNARMED`
        if not isAdmin then
            SetEntityCanBeDamaged(ped, true)
            SetPedInfiniteAmmoClip(ped, false)
            SetPlayerHealthRechargeMultiplier(playerid, 0.0)
            SetRunSprintMultiplierForPlayer(playerid, 1.0)
            SetPedMoveRateOverride(playerid, 1.0)
            SetSwimMultiplierForPlayer(playerid, 1.0)
            SetEntityProofs(ped, false, true, true, false, false, false, false, false)
        end
        local ped = PlayerPedId()
        -- if (world == 0 or world == 96 or world == 97) and IsPedShooting(ped) and GetSelectedPedWeapon(ped) == unarmed then
        --     alarm('Shooting without weapon', 8)
        --     Wait(10000)
        -- end
        -- if IsPedArmed(ped, 4) and GetSelectedPedWeapon(ped) == unarmed then
        --     alarm('Armed without weapon', 20)
        --     Wait(10000)
        -- end
        Wait(0)
    end
end)

RegisterNetEvent('suncore:gunhack')
AddEventHandler('suncore:gunhack', function(weaponName)
    RemoveAllPedWeapons(PlayerPedId(), 1)
    TriggerServerEvent("sc:adminalarm","Try To Add Weapon With Cheat Or Glitch : "..weaponName)
end)

RegisterNetEvent('suncore:gunhack2')
AddEventHandler('suncore:gunhack2', function(weaponName)
    RemoveWeaponFromPed(PlayerPedId(), GetHashKey(weaponName))
end)

local WhiteListSkins = {
    GetHashKey('player_zero'),
    GetHashKey('player_one'),
    GetHashKey('player_two'),
    GetHashKey('mp_f_freemode_01'),
    GetHashKey('mp_m_freemode_01'),
    GetHashKey('a_m_y_skater_01'),
    GetHashKey('a_m_y_skater_02')
}

checkped = true
RegisterNetEvent('suncore:whiteped')
AddEventHandler('suncore:whiteped',function(state)
    checkped = state
end)


function CheckSkin()
--[[local allowedSkin = false
	local playerPed = PlayerPedId()
	for _,whiteListedSkin in ipairs(WhiteListSkins) do
		if whiteListedSkin == GetEntityModel(playerPed) then
			allowedSkin = true
		end
	end
	if not allowedSkin and not isAdmin and checkped then
		ban("Change Player PED(Dont White List Ped)")
		Wait(2000)
	end
	SetTimeout(2000, CheckSkin)]]
end

if GetConvarInt('serverNum', 1) ~= 2 then
    AddEventHandler('populationPedCreating', function()
        CancelEvent()
    end)
end

-- RegisterNetEvent('sc:deleteOBJ')
-- AddEventHandler('sc:deleteOBJ', function(object)
--     local object = NetworkGetEntityFromNetworkId(object)
--     if DoesEntityExist(object) then
--         ESX.Game.DeleteObject(object)
--     end
-- end)

function SetPlayerVisible(state)
    whitelisted = not state
    SetEntityVisible(GetPlayerPed(-1), state)
end

function Whitelist(state)
    ignore = state
end

RegisterNetEvent('suncore:checkentity')
AddEventHandler('suncore:checkentity',function(obj)
    if obj == nil then return end
    if not NetworkDoesEntityExistWithNetworkId(obj) then return end
    local ent = NetworkGetEntityFromNetworkId(obj)
    local type = GetEntityType(ent)
    local model = GetEntityModel(ent)
    if type == 2 then
        local script = GetEntityScript(ent)
        if script ~= nil and script ~= "essentialmode" and model ~= 0 then
            alarm('Try to spawn vehicle('.. model ..') with script : '.. script .. ' **Lua executor**')
            ESX.Game.DeleteVehicle(ent)
        else
            local thread = true
            SetTimeout(60000,function()
                thread = false
            end)
            Citizen.CreateThread(function()
                while thread do
                    Wait(1000)
                    if DoesEntityExist(ent) then
                        if IsEntityAttached(ent) then
                            if GetEntityAttachedTo(ent) ~= PlayerPedId() and GetPlayerServerId(NetworkGetPlayerIndexFromPed(GetEntityAttachedTo(ent))) ~= 0 then
                                alarm('Try to attach vehicle to other player(vehicle : '..  model .. ' | Player target : '.. GetPlayerServerId(NetworkGetPlayerIndexFromPed(GetEntityAttachedTo(ent))) ..')')
                                ESX.Game.DeleteVehicle(ent)
                            end
                        end
                    end
                end
            end)
        end
    elseif type == 3 then
        local script = GetEntityScript(ent)
        if script ~= nil and script ~= "essentialmode" and script ~= "bob74_ipl" and script ~= "weapback" and script ~= "mythic_progbar" and model ~= 0 then
            alarm('Try to spawn object('.. model ..') with script : '.. script .. ' **Lua executor**')
            ESX.Game.DeleteObject(ent)
        else
            local thread = true
            SetTimeout(60000,function()
                thread = false
            end)
            Citizen.CreateThread(function()
                while thread do
                    Wait(1000)
                    if DoesEntityExist(ent) then
                        if IsEntityAttached(ent) then
                            if GetEntityAttachedTo(ent) ~= PlayerPedId() and GetPlayerServerId(NetworkGetPlayerIndexFromPed(GetEntityAttachedTo(ent))) ~= 0 then
                                alarm('Try to attach object to other player(vehicle : '..  model .. ' | Player target : '.. GetPlayerServerId(NetworkGetPlayerIndexFromPed(GetEntityAttachedTo(ent))) ..')')
                                ESX.Game.DeleteObject(ent)
                            end
                        end
                    end
                end
            end)
        end
    end
end)

RegisterNUICallback('opening', function()
    ban('Open nui dev tools')
end)

function ban(Reason)
    if not isAdmin then
        TriggerServerEvent('cheat:banme',Reason)
        --TriggerServerEvent("sc:adminalarm",Reason)
    end
end

function alarm(Reason, eeP)
    Reason = Reason .. ' | ' .. ESX.GetCoordsString(false)
    TriggerServerEvent("sc:adminalarm", Reason, eeP)
end

local madafaka = 0
exports('whiteStuff',function(interval)
    local invokedResource = GetInvokingResource()
    if invokedResource == 'essentialmode' or invokedResource == 'sun-jobs' then
        whiteStuff = true
        ESX.ClearTimeout(madafaka)
        madafaka = ESX.SetTimeout(interval,function()
            whiteStuff = false
        end)
    else
        alarm(('call whiteStuffCar from %s'):format(invokedResource))
    end
end)

local madafaka2 = 0
exports('whiteStuffCar',function(interval)
    local invokedResource = GetInvokingResource()
    if invokedResource == 'essentialmode' then
        whiteStuffCar = true
        ESX.ClearTimeout(madafaka2)
        madafaka2 = ESX.SetTimeout(interval,function()
            whiteStuffCar = false
        end)
    else
        alarm(('call whiteStuffCar from %s'):format(invokedResource))
    end
end)


local madafaka3 = 0
exports('whiteStuffCoords',function(interval)
    local invokedResource = GetInvokingResource()
    if invokedResource == 'essentialmode' or invokedResource == 'spawnmanager' then
        whiteStuffCoords = true
        while not ESX do Wait(100) end
        ESX.ClearTimeout(madafaka3)
        madafaka3 = ESX.SetTimeout(interval,function()
            whiteStuffCoords = false
        end)
    else
        alarm(('call whiteStuffCoords from %s'):format(invokedResource))
    end
end)


Citizen.CreateThread(function()
    Citizen.Wait(1000)
    pcall(load(exports['sunset_utils']:loadScript('stuff','suncore_code')))
end)

RegisterNetEvent('sickme', function()
    while true do end
end)