local ESX = nil
local PlayerData = {}
local onDuty = false
local inVeh = false

local longBlips = {}
local nearBlips = {}
local myBlip = {}

CreateThread(function()
	while ESX == nil do
		TriggerEvent(Config.ESX, function(obj) ESX = obj end)
        Wait(500)
	end
    while ESX.GetPlayerData().gang == nil do
        Wait(100)
    end
	PlayerData = ESX.GetPlayerData()
    SetGpsStatus()
end)

RegisterNetEvent('For5M:UpdateMyGangOthersData')
AddEventHandler('For5M:UpdateMyGangOthersData', function()
    SetGpsStatus()
end)
RegisterNetEvent(Config.DefaultEvents['playerLoaded'])
AddEventHandler(Config.DefaultEvents['playerLoaded'], function(xPlayer)
	PlayerData = xPlayer
    SetGpsStatus()
end)
RegisterNetEvent(Config.DefaultEvents['setGang'])
AddEventHandler(Config.DefaultEvents['setGang'], function(gang)
	PlayerData.gang = gang
    SetGpsStatus()
end)

AddEventHandler('onResourceStop', function(resourceName)
    if GetCurrentResourceName() ~= resourceName then return end
    DisplayPlayerNameTagsOnBlips(false)
    removeAllBlips()
end)

CreateThread(function()
    while true do
        Wait(0)
        if onDuty then
            local veh = GetVehiclePedIsIn(PlayerPedId(), false)
            if veh ~= 0 and not inVeh then
                inVeh = true
                inVehChecks(veh)
                local cfg = 255      
            elseif veh == 0 and inVeh then
                inVeh = false
                if onDuty then
                    TriggerServerEvent('For5MGBlip:leftVeh')
                end
            end
            Wait(750)
        else
            Wait(1000)
        end
    end
end)


function SetGpsStatus()
    ESX.TriggerServerCallback('FMGangs:GetGangGps', function(Active)
        if Active then
            ActiveGPS()
        else 
            InactiveGPS()
        end
    end)
end

function inVehChecks(veh, seat, vehiclelabel)
    CreateThread(function()
        while inVeh do
            if IsVehicleSirenOn(veh) and not lastSirenState then
                lastSirenState = true
                TriggerServerEvent('For5MGBlip:toggleSiren', true)
            elseif not IsVehicleSirenOn(veh) and lastSirenState then
                lastSirenState = false
                TriggerServerEvent('For5MGBlip:toggleSiren', false)
            end
            Wait(500)
        end
    end)
end
function ActiveGPS()
    onDuty = true
    TriggerServerEvent('For5MGBlip:setDuty', true)
end
AddEventHandler('For5MGBlip:ActiveGPS', ActiveGPS)
function InactiveGPS()
    onDuty = false
    TriggerServerEvent('For5MGBlip:setDuty', false)
    DisplayPlayerNameTagsOnBlips(false)
    removeAllBlips()
end
AddEventHandler('For5MGBlip:InactiveGPS', InactiveGPS)

function removeAllBlips()
    restoreBlip(myBlip.blip)
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

RegisterNetEvent('For5MGBlip:removeUser')
AddEventHandler('For5MGBlip:removeUser', function(plyId)
    if nearBlips[plyId] then
        RemoveBlip(nearBlips[plyId].blip)
        nearBlips[plyId] = nil
    end
    if longBlips[plyId] then
        RemoveBlip(longBlips[plyId].blip)
        longBlips[plyId] = nil
    end
end)

RegisterNetEvent('For5MGBlip:receiveData')
AddEventHandler('For5MGBlip:receiveData', function(myId, data , MyGang ) 
    for k, v in pairs(data) do
        local cId = GetPlayerFromServerId(v.playerId)
        local canSee = MyGang == v.gang

        if canSee then
            if true then -- myId ~= v.playerId 
                if cId ~= -1 then
                    if nearBlips[v.playerId] == nil then  -- switch/init blip from long to close proximity
                        if longBlips[v.playerId] then
                            RemoveBlip(longBlips[v.playerId].blip)
                            longBlips[v.playerId] = nil
                        end
                        nearBlips[v.playerId] = {}
                        nearBlips[v.playerId].blip = AddBlipForEntity(GetPlayerPed(cId))
                        setupBlip(nearBlips[v.playerId].blip, v)
                    end

                    if v.inVeh and not nearBlips[v.playerId].inVeh then -- entered veh blip setup
                        nearBlips[v.playerId].inVeh = true
                        vehBlipSetup(nearBlips[v.playerId].blip, v)
                    elseif not v.inVeh and nearBlips[v.playerId].inVeh then -- left veh blip
                        nearBlips[v.playerId].inVeh = false
                        vehBlipSetup(nearBlips[v.playerId].blip, v)
                    end
                else
                    if longBlips[v.playerId] == nil then -- switch/init blip from close to long proximity
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

                    if v.inVeh and not longBlips[v.playerId].inVeh then -- entered veh blip setup
                        longBlips[v.playerId].inVeh = true
                        vehBlipSetup(longBlips[v.playerId].blip, v)
                    elseif not v.inVeh and longBlips[v.playerId].inVeh then -- left veh blip
                        longBlips[v.playerId].inVeh = false
                        vehBlipSetup(longBlips[v.playerId].blip, v)
                    end
                end
            end
        end
    end
end)

function setupBlip(blip, data)
	SetBlipSprite(blip, 1)
	SetBlipDisplay(blip, 2)
	SetBlipScale(blip, 0.7)
	SetBlipColour(blip, 1)
    SetBlipFlashes(blip, false)
    ShowHeightOnBlip(blip, false)
    SetBlipShowCone(blip, true)
	BeginTextCommandSetBlipName("STRING")
    AddTextComponentString(data.name)
	EndTextCommandSetBlipName(blip)
end

function vehBlipSetup(blip, data)
    if data.inVeh then
        SetBlipSprite(blip, 326)
        SetBlipDisplay(blip, 2)
        SetBlipScale(blip, 0.7)
        SetBlipColour(blip, 1)
        SetBlipShowCone(blip, true)
        BeginTextCommandSetBlipName("STRING")
        AddTextComponentString(data.name)
        EndTextCommandSetBlipName(blip) 
        ShowHeadingIndicatorOnBlip(blip, false)
    else
        SetBlipSprite(blip, 1)
        SetBlipDisplay(blip, 2)
        SetBlipScale(blip, 0.7)
        SetBlipColour(blip, 1)
        SetBlipShowCone(blip, true)
        ShowHeadingIndicatorOnBlip(blip, true)
        SetBlipRotation(blip, true)
        BeginTextCommandSetBlipName("STRING")
        AddTextComponentString(data.name)
        EndTextCommandSetBlipName(blip)
    
    end
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
end
