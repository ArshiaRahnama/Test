ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

RegisterServerEvent('InteractSound_SV:PlayOnOne')
AddEventHandler('InteractSound_SV:PlayOnOne', function(clientNetId, soundFile, soundVolume)
    TriggerClientEvent('InteractSound_CL:PlayOnOne', clientNetId, soundFile, soundVolume)
end)

RegisterServerEvent('InteractSound_SV:PlayOnSource')
AddEventHandler('InteractSound_SV:PlayOnSource', function(soundFile, soundVolume)
    TriggerClientEvent('InteractSound_CL:PlayOnOne', source, soundFile, soundVolume)
end)

RegisterServerEvent('InteractSound_SV:PlayOnAll')
AddEventHandler('InteractSound_SV:PlayOnAll', function(soundFile, soundVolume)
    TriggerClientEvent('InteractSound_CL:PlayOnAll', -1, soundFile, soundVolume)
end)

RegisterServerEvent('InteractSound_SV:PlayWithinDistance')
AddEventHandler('InteractSound_SV:PlayWithinDistance', function(maxDistance, soundFile, soundVolume)
    local xPlayer = ESX.GetPlayerFromId(source)
    TriggerClientEvent('InteractSound_CL:PlayWithinDistance', -1, xPlayer.coords.x, xPlayer.coords.y, xPlayer.coords.z, maxDistance, soundFile, soundVolume)
end)

RegisterServerEvent('InteractSound_SV:PlayWithinDistancePolice')
AddEventHandler('InteractSound_SV:PlayWithinDistancePolice', function(xPlayer, maxDistance, soundFile, soundVolume)

    TriggerClientEvent('InteractSound_CL:PlayWithinDistance', -1, xPlayer.coords.x, xPlayer.coords.y, xPlayer.coords.z, maxDistance, soundFile, soundVolume)
end)
