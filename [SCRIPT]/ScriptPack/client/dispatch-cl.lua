ESX = nil
local PlayerData              = {}

Citizen.CreateThread(function()
    while ESX == nil do
        TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
        Citizen.Wait(1)
    end

    while ESX.GetPlayerData().job == nil do
        Citizen.Wait(10)
    end

    PlayerData = ESX.GetPlayerData()
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
    PlayerData.job = job
end)

RegisterNetEvent('esx_dispatch:assignBadge')
AddEventHandler('esx_dispatch:assignBadge',function(label)
   if PlayerData.job.name == "police" or PlayerData.job.name == "ambulance" then
        local id = PlayerId()
        TriggerServerEvent('esx_idoverhead:modifyLabel', id, label)
   end
end)

local badgeAnimBusy = false

RegisterNetEvent('scriptpack:playBadgeAnim')
AddEventHandler('scriptpack:playBadgeAnim', function()
    if badgeAnimBusy then return end
    badgeAnimBusy = true

    local playerPed = PlayerPedId()

    if IsPedInAnyVehicle(playerPed, false) or IsPedArmed(playerPed, 7) then
        badgeAnimBusy = false
        return
    end

    local boneIndex = GetPedBoneIndex(playerPed, 28422)




    local badgeModel = GetHashKey('prop_fib_badge')
    RequestModel(badgeModel)
    local attempts = 0
    while not HasModelLoaded(badgeModel) and attempts < 100 do
        Citizen.Wait(10)
        attempts = attempts + 1
    end

    local badgeProp = CreateObject(badgeModel, 0, 0, 0, true, true, true)
    AttachEntityToEntity(badgeProp, playerPed, boneIndex, 0.065, 0.029, -0.035, 80.0, -1.90, 75.0, true, true, false, true, 1, true)
    SetModelAsNoLongerNeeded(badgeModel)

    RequestAnimDict('paper_1_rcm_alt1-9')
    while not HasAnimDictLoaded('paper_1_rcm_alt1-9') do
        Citizen.Wait(100)
    end

    TaskPlayAnim(playerPed, 'paper_1_rcm_alt1-9', 'player_one_dual-9', 8.0, -8, 10.0, 49, 0, 0, 0, 0)
    Citizen.Wait(3000)
    ClearPedSecondaryTask(playerPed)
    DeleteObject(badgeProp)

    badgeAnimBusy = false
end)
