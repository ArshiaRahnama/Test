
if Config.ActiveBoombox then
    ESX.RegisterUsableItem(Config.BoomboxItem, function(source)
        local xPlayer = GetPlayerFromId(source)
        if UseBoombox(source) then
            TriggerClientEvent('lgd_boombox:useBoombox', source)
            RemoveItem(xPlayer, Config.BoomboxItem, 1)
        end
    end)
end


RegisterNetEvent("lgd_boombox:soundStatus")
AddEventHandler("lgd_boombox:soundStatus", function(type, musicId, data)
    TriggerClientEvent("lgd_boombox:soundStatus", -1, type, musicId, data)
end)

-- FIX: RegisterServerEvent only ever takes the event name - it does NOT
-- register a handler the way AddEventHandler does, so passing a function
-- as a second argument here silently did nothing. Both of these were
-- never actually firing at all: deleting a boombox never told other
-- clients to remove the prop (lgd_boombox:deleteObj), and the player
-- never got their boombox item back afterwards (lgd_boombox:objDeleted -
-- it was just gone for good).
RegisterServerEvent('lgd_boombox:deleteObj')
AddEventHandler('lgd_boombox:deleteObj', function(netId)
    TriggerClientEvent('lgd_boombox:deleteObj', -1, netId)
end)

RegisterServerEvent('lgd_boombox:objDeleted')
AddEventHandler('lgd_boombox:objDeleted', function()
    local xPlayer = GetPlayerFromId(source)
    AddItem(xPlayer, Config.BoomboxItem, 1)
end)

RegisterNetEvent("lgd_boombox:syncActive")
AddEventHandler("lgd_boombox:syncActive", function(activeRadios)
    TriggerClientEvent("lgd_boombox:syncActive", -1, activeRadios)
end)