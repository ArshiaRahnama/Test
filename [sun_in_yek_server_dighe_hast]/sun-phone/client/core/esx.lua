-- Pub by FleeX Team , https://discord.gg/87rGBxgCsa

ESX = nil

Citizen.CreateThread(function()
    ESX = exports['essentialmode']:getObject()
    
    while ESX.GetPlayerData() == nil do
        Wait(1000)
    end
    
    ESX.PlayerData = ESX.GetPlayerData()
end)
