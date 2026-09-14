local ESX = nil
local PlayerData = {}
local onDuty = false
local inVeh = false
local lastSirenState = false

local longBlips = {}
local nearBlips = {}
local myBlip = {}

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Wait(1)
	end

    while ESX.GetPlayerData().job == nil do
        Wait(100)
    end

	PlayerData = ESX.GetPlayerData()

    if Config.blipGroup.renameGroup then
        AddTextEntryByHash(`BLIP_OTHPLYR`, Config.blipGroup.groupName..'~w~')
    end
    checkJob()
end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
	PlayerData = xPlayer
    Wait(30000)
    checkJob()
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
	PlayerData.job = job
    if onDuty then
        goOffDuty()
    end
    checkJob()
end)

AddEventHandler('onResourceStop', function(resourceName)
    if GetCurrentResourceName() ~= resourceName then return end

    if Config.bigmapTags then
        DisplayPlayerNameTagsOnBlips(false)
    end
    removeAllBlips()
end)

if Config.useBaseEvents then
    AddEventHandler("baseevents:enteredVehicle", function(veh, seat, vehiclelabel)
        inVeh = true
        if onDuty then
            inVehChecks(veh, seat, vehiclelabel)

            local cfg = Config.emergencyJobs[PlayerData.job.name].vehBlip and Config.emergencyJobs[PlayerData.job.name].vehBlip[GetEntityModel(veh)] or nil
            TriggerServerEvent('rflx_pdblips:enteredVeh', cfg)
        end
    end)

    AddEventHandler("baseevents:leftVehicle", function(veh, seat, vehiclelabel)
        inVeh = false
        if lastSirenState then
            lastSirenState = false
            Citizen.Wait(1000)
            TriggerServerEvent('rflx_pdblips:toggleSiren', false)
        end
        if onDuty then
            TriggerServerEvent('rflx_pdblips:leftVeh')
        end
    end)
else
    Citizen.CreateThread(function()
        while true do
            if onDuty then
                local veh = GetVehiclePedIsIn(PlayerPedId(), false)
                if veh ~= 0 and not inVeh then
                    inVeh = true
                    inVehChecks(veh)

                    local cfg = Config.emergencyJobs[PlayerData.job.name].vehBlip and Config.emergencyJobs[PlayerData.job.name].vehBlip[GetEntityModel(veh)] or nil
                    TriggerServerEvent('rflx_pdblips:enteredVeh', cfg)
                elseif veh == 0 and inVeh then
                    inVeh = false
                    if lastSirenState then
                        lastSirenState = false
                        Citizen.Wait(1000)
                        TriggerServerEvent('rflx_pdblips:toggleSiren', false)
                    end
                    if onDuty then
                        TriggerServerEvent('rflx_pdblips:leftVeh')
                    end
                end
                Citizen.Wait(750)
            else
                Citizen.Wait(1000)
            end
        end
    end)
end

function inVehChecks(veh, seat, vehiclelabel)
    Citizen.CreateThread(function()
        while inVeh do
            if IsVehicleSirenOn(veh) and not lastSirenState then
                lastSirenState = true
                Citizen.Wait(1000)
                TriggerServerEvent('rflx_pdblips:toggleSiren', true)
            elseif not IsVehicleSirenOn(veh) and lastSirenState then
                lastSirenState = false
                Citizen.Wait(1000)
                TriggerServerEvent('rflx_pdblips:toggleSiren', false)
            end
            Citizen.Wait(500)
        end
    end)
end

function checkJob()
    if PlayerData and PlayerData.job and Config.emergencyJobs[PlayerData.job.name] and Config.emergencyJobs[PlayerData.job.name].ignoreDuty then
        goOnDuty()
    end
end

function goOnDuty()
    onDuty = true
    TriggerServerEvent('rflx_pdblips:setDuty', true)

    if Config.notifications.enable and Config.notifications.useMythic then

    elseif Config.notifications.enable then
        ESX.ShowNotification(Config.notifications.onDutyText)
    end


    if Config.bigmapTags then
        SetBigmapActive(true, false)
        DisplayPlayerNameTagsOnBlips(true)
    end
    if inVeh then
        TriggerServerEvent('rflx_pdblips:enteredVeh', Config.emergencyJobs[PlayerData.job.name].vehBlip[GetEntityModel(GetVehiclePedIsIn(PlayerPedId(), false))])
    end
end
AddEventHandler('rflx_pdblips:goOnDuty', goOnDuty)

function goOffDuty()
    onDuty = false
    TriggerServerEvent('rflx_pdblips:setDuty', false)

    if Config.notifications.enable and Config.notifications.useMythic then

    elseif Config.notifications.enable then
        ESX.ShowNotification(Config.notifications.offDutyText)
    end


    if Config.bigmapTags then
        DisplayPlayerNameTagsOnBlips(false)
    end
    removeAllBlips()
end
AddEventHandler('rflx_pdblips:goOffDuty', goOffDuty)

AddEventHandler('rflx_pdblips:toggleDuty', function(bool)
    if bool then
        goOnDuty()
    else
        goOffDuty()
    end
end)

function removeAllBlips()
    restoreBlip(myBlip.blip or GetMainPlayerBlipId())
    for k, v in pairs(nearBlips) do
        RemoveBlip(v.blip)
    end
    for k, v in pairs(longBlips) do
        RemoveBlip(v.blip)
    end
    nearBlips = {}
    longBlips = {}
    myBlip = {}
end

RegisterNetEvent('rflx_pdblips:removeUser')
AddEventHandler('rflx_pdblips:removeUser', function(plyId)
    if nearBlips[plyId] then
        RemoveBlip(nearBlips[plyId].blip)
        nearBlips[plyId] = nil
    end
    if longBlips[plyId] then
        RemoveBlip(longBlips[plyId].blip)
        longBlips[plyId] = nil
    end
end)

RegisterNetEvent('rflx_pdblips:receiveData')
AddEventHandler('rflx_pdblips:receiveData', function(myId, data)
    for k, v in pairs(data) do
        local cId = GetPlayerFromServerId(v.playerId)
        local canSee = Config.emergencyJobs[v.job].canSee and Config.emergencyJobs[v.job].canSee[PlayerData.job.name]

        if canSee then
            if myId ~= v.playerId then
                if cId ~= -1 then
                    if nearBlips[v.playerId] == nil then
                        if longBlips[v.playerId] then
                            RemoveBlip(longBlips[v.playerId].blip)
                            longBlips[v.playerId] = nil
                        end
                        nearBlips[v.playerId] = {}
                        nearBlips[v.playerId].blip = AddBlipForEntity(GetPlayerPed(cId))
                        setupBlip(nearBlips[v.playerId].blip, v)
                    end

                    if v.inVeh and not nearBlips[v.playerId].inVeh then
                        nearBlips[v.playerId].inVeh = true
                        vehBlipSetup(nearBlips[v.playerId].blip, v)
                    elseif not v.inVeh and nearBlips[v.playerId].inVeh then
                        nearBlips[v.playerId].inVeh = false
                        vehBlipSetup(nearBlips[v.playerId].blip, v)
                    end

                    if v.siren and not nearBlips[v.playerId].siren then
                        nearBlips[v.playerId].siren = true
                        nearBlips[v.playerId].sirenState = 1
                    elseif not v.siren and nearBlips[v.playerId].siren then
                        nearBlips[v.playerId].siren = false
                        if v.inVeh then
                            vehBlipSetup(nearBlips[v.playerId].blip, v)
                        else
                            setupBlip(nearBlips[v.playerId].blip, v)
                        end
                    elseif nearBlips[v.playerId].siren then
                        nearBlips[v.playerId].sirenState = v.flashColors[nearBlips[v.playerId].sirenState + 1] and nearBlips[v.playerId].sirenState + 1 or 1
                        updateBlipFlash(nearBlips[v.playerId].blip, v.flashColors[nearBlips[v.playerId].sirenState])
                    end
                else
                    if longBlips[v.playerId] == nil then
                        if nearBlips[v.playerId] then
                            RemoveBlip(nearBlips[v.playerId].blip)
                            nearBlips[v.playerId] = nil
                        end
                        longBlips[v.playerId] = {}
                        longBlips[v.playerId].blip = AddBlipForCoord(v.coords)
                        setupBlip(longBlips[v.playerId].blip, v)
                        if v.inVeh then
                            vehBlipSetup(longBlips[v.playerId].blip, v)
                        end
                    else
                        if longBlips[v.playerId] then
                            RemoveBlip(longBlips[v.playerId].blip)
                        end
                        longBlips[v.playerId].blip = AddBlipForCoord(v.coords)
                        setupBlip(longBlips[v.playerId].blip, v)
                        if v.inVeh then
                            vehBlipSetup(longBlips[v.playerId].blip, v)
                        end
                    end

                    if v.inVeh and not longBlips[v.playerId].inVeh then
                        longBlips[v.playerId].inVeh = true
                        vehBlipSetup(longBlips[v.playerId].blip, v)
                    elseif not v.inVeh and longBlips[v.playerId].inVeh then
                        longBlips[v.playerId].inVeh = false
                        vehBlipSetup(longBlips[v.playerId].blip, v)
                    end

                    if v.siren and not longBlips[v.playerId].siren then
                        longBlips[v.playerId].siren = true
                        longBlips[v.playerId].sirenState = 1
                    elseif not v.siren and longBlips[v.playerId].siren then
                        longBlips[v.playerId].siren = false
                        if v.inVeh then
                            vehBlipSetup(longBlips[v.playerId].blip, v)
                        else
                            setupBlip(longBlips[v.playerId].blip, v)
                        end
                    elseif longBlips[v.playerId].siren then
                        longBlips[v.playerId].sirenState = v.flashColors[longBlips[v.playerId].sirenState + 1] and longBlips[v.playerId].sirenState + 1 or 1
                        updateBlipFlash(longBlips[v.playerId].blip, v.flashColors[longBlips[v.playerId].sirenState])
                    end
                end
            elseif Config.selfBlip then
                if myBlip.blip == nil then
                    myBlip.blip = GetMainPlayerBlipId()

                    while myBlip.blip == nil do
                        Citizen.Wait(100)
                    end
                    setupBlip(myBlip.blip, v)
                end

                if v.inVeh and not myBlip.inVeh then
                    myBlip.inVeh = true
                    vehBlipSetup(myBlip.blip, v)
                elseif not v.inVeh and myBlip.inVeh then
                    myBlip.inVeh = false
                    vehBlipSetup(myBlip.blip, v)
                end

                if v.siren and not myBlip.siren then
                    myBlip.siren = true
                    myBlip.sirenState = 1
                elseif not v.siren and myBlip.siren then
                    myBlip.siren = false
                    if v.inVeh then
                        vehBlipSetup(myBlip.blip, v)
                    else
                        setupBlip(myBlip.blip, v)
                    end
                elseif myBlip.siren then
                    myBlip.sirenState = v.flashColors[myBlip.sirenState + 1] ~= nil and myBlip.sirenState + 1 or 1
                    updateBlipFlash(myBlip.blip, v.flashColors[myBlip.sirenState])
                end

                BeginTextCommandSetBlipName("STRING")
                AddTextComponentString(Config.usePrefix and v.prefix..' '..v.name or v.name)
                EndTextCommandSetBlipName(myBlip.blip)
            end
        end
    end
end)

function setupBlip(blip, data)
	SetBlipSprite(blip, 1)
	SetBlipDisplay(blip, 2)
	SetBlipScale(blip, 0.7)
	SetBlipColour(blip, Config.emergencyJobs[data.job].blip.color)
    SetBlipFlashes(blip, false)
    ShowHeightOnBlip(blip, false)
    SetBlipShowCone(blip, Config.blipCone)
    SetBlipCategory(blip, 7)
    ShowHeadingIndicatorOnBlip(blip, true)
    SetBlipRotation(blip, true)
	BeginTextCommandSetBlipName("STRING")
    if Config.font.useCustom then
        AddTextComponentString("<font face='"..Config.font.name.."'>"..data.prefix.." "..data.name.."</font>")
    else
        AddTextComponentString(Config.usePrefix and data.prefix..' '..data.name or data.name)
    end
	EndTextCommandSetBlipName(blip)
end

function vehBlipSetup(blip, data)
    if data.inVeh then
        SetBlipSprite(blip, data.vehSprite)
        SetBlipDisplay(blip, 2)
        SetBlipScale(blip, 0.7)
        SetBlipColour(blip, data.vehColor)
        SetBlipShowCone(blip, Config.blipCone)
        SetBlipRotation(blip, false)
        BeginTextCommandSetBlipName("STRING")
        if Config.font.useCustom then
            AddTextComponentString("<font face='"..Config.font.name.."'>"..data.prefix.." "..data.name.."</font>")
        else
            AddTextComponentString(Config.usePrefix and data.prefix..' '..data.name or data.name)
        end
        EndTextCommandSetBlipName(blip)
        SetBlipCategory(blip, 7)
        ShowHeadingIndicatorOnBlip(blip, false)
        SetBlipRotation(blip, false)
    else
        SetBlipSprite(blip, 1)
        SetBlipDisplay(blip, 2)
        SetBlipScale(blip, 0.7)
        SetBlipColour(blip, Config.emergencyJobs[data.job].blip.color)
        SetBlipShowCone(blip, Config.blipCone)
        ShowHeadingIndicatorOnBlip(blip, true)
        SetBlipRotation(blip, true)
        BeginTextCommandSetBlipName("STRING")
        if Config.font.useCustom then
            AddTextComponentString("<font face='"..Config.font.name.."'>"..data.prefix.." "..data.name.."</font>")
        else
            AddTextComponentString(Config.usePrefix and data.prefix..' '..data.name or data.name)
        end
        EndTextCommandSetBlipName(blip)
        SetBlipCategory(blip, 7)
    end
end

function updateBlipFlash(blip, color)
    SetBlipColour(blip, color)
end

function restoreBlip(blip)
    SetBlipSprite(blip, 6)
    SetBlipDisplay(blip, 4)
    SetBlipScale(blip, 0.7)
    SetBlipRotation(blip, false)
    ShowHeadingIndicatorOnBlip(blip, false)
    SetBlipColour(blip, 0)
    SetBlipShowCone(blip, false)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString(GetPlayerName(PlayerId()))
    EndTextCommandSetBlipName(blip)
    SetBlipCategory(blip, 1)
end

