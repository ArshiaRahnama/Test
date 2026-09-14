--[[
    kq_detective — map blips (client side).
    Both fire automatically off the server — no command involved.
]]

-- The instant-alert red blip (dojintegration.lua, fired the moment a
-- murder is recorded — see Config_detective.activeScene).
RegisterNetEvent('kq_detective:activeSceneBlip')
AddEventHandler('kq_detective:activeSceneBlip', function(coords)
    local blip = AddBlipForCoord(coords.x, coords.y, coords.z)
    SetBlipSprite(blip, Config_detective.activeScene.blipSprite)
    SetBlipColour(blip, Config_detective.activeScene.blipColor)
    SetBlipScale(blip, Config_detective.activeScene.blipScale)
    SetBlipAsShortRange(blip, false)
    SetBlipFlashes(blip, true)

    BeginTextCommandSetBlipName('STRING')
    AddTextComponentString('Sahne-ye Jorm')
    EndTextCommandSetBlipName(blip)

    Citizen.SetTimeout(Config_detective.activeScene.blipLifetimeMs, function()
        if DoesBlipExist(blip) then
            RemoveBlip(blip)
        end
    end)
end)

RegisterNetEvent('kq_detective:finalDeathBlip')
AddEventHandler('kq_detective:finalDeathBlip', function(coords)
    if not Config_detective.finalDeath.enabled then return end

    local blip = AddBlipForCoord(coords.x, coords.y, coords.z)
    SetBlipSprite(blip, Config_detective.finalDeath.blipSprite)
    SetBlipColour(blip, Config_detective.finalDeath.blipColor)
    SetBlipScale(blip, Config_detective.finalDeath.blipScale)
    SetBlipAsShortRange(blip, false)

    BeginTextCommandSetBlipName('STRING')
    AddTextComponentString(L('Unattended body'))
    EndTextCommandSetBlipName(blip)

    Citizen.SetTimeout(Config_detective.finalDeath.blipLifetimeMs, function()
        if DoesBlipExist(blip) then
            RemoveBlip(blip)
        end
    end)
end)
