-- Pub by FleeX Team , https://discord.gg/87rGBxgCsa

ESX = nil
Core = nil
CoreName = nil
CoreReady = false
Ban = false
Citizen.CreateThread(function()
    for k, v in pairs(Cores) do
        if GetResourceState(v.ResourceName) == "starting" or GetResourceState(v.ResourceName) == "started" then
            CoreName = v.ResourceName
            ESX = v.GetFramework()
            Core = ESX
            CoreReady = true
        end
    end
end)

function GetPlayerData()
    if CoreName == "qb-core" or CoreName == "qbx_core" then
        local player = Core.Functions.GetPlayerData()
        return player
    elseif CoreName == "essentialmode" then
        local player = Core.GetPlayerData()
        if player then
            return player
        else
            return {}
        end
    end
end

RegisterNetEvent('esx:playerLoaded', function()
    Wait(5000)
    ESX.TriggerServerCallback('dpemote:CheckBan', function(ban)
        Ban = ban
    end)
end)

RegisterNetEvent('Emote:SetBan', function(state)
    Ban = state
end)
