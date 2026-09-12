--[[
    kq_detective — final death blip (client side).
    Fires automatically off server/finaldeath.lua — no command involved.
]]

RegisterNetEvent('kq_detective:finalDeathBlip')
AddEventHandler('kq_detective:finalDeathBlip', function(coords)
    if not Config.finalDeath.enabled then return end

    local blip = AddBlipForCoord(coords.x, coords.y, coords.z)
    SetBlipSprite(blip, Config.finalDeath.blipSprite)
    SetBlipColour(blip, Config.finalDeath.blipColor)
    SetBlipScale(blip, Config.finalDeath.blipScale)
    SetBlipAsShortRange(blip, false)

    BeginTextCommandSetBlipName('STRING')
    AddTextComponentString(L('Unattended body'))
    EndTextCommandSetBlipName(blip)

    Citizen.SetTimeout(Config.finalDeath.blipLifetimeMs, function()
        if DoesBlipExist(blip) then
            RemoveBlip(blip)
        end
    end)
end)
