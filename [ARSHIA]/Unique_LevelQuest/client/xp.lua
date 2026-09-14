local ESX = nil

Citizen.CreateThread(function()
    while ESX == nil do
        TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
        Citizen.Wait(0)
    end
    Citizen.Wait(1000)
    TriggerServerEvent('XP_System:setMyDecor')
end)

-- FIX: this used to re-fetch the player's rank via a server callback that
-- belongs to a DIFFERENT resource (esx_aduty's 'esx_spectate:getPlayerData'),
-- throwing away the `rank` value the server had just sent as an argument.
-- That's an unnecessary cross-resource dependency AND a wasted round trip.
-- The server already tells us the correct rank; just use it.
RegisterNetEvent('XP_System:SetDecor')
AddEventHandler('XP_System:SetDecor', function(rank)
    rank = tonumber(rank) or 1
    if rank < 1 then rank = 1 end
    DecorSetInt(PlayerPedId(), 'rank', rank)
end)
