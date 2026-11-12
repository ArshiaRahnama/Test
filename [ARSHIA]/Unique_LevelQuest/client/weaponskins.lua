local ESX = nil
CreateThread(function()
    while ESX == nil do
        TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
        Wait(0)
    end
end)

local Wanted = {} -- [weaponHash] = tint

RegisterNetEvent('Unique_LevelQuest:weaponSkins')
AddEventHandler('Unique_LevelQuest:weaponSkins', function(map)
    Wanted = {}
    for name, tint in pairs(map or {}) do Wanted[GetHashKey(name)] = tint end
end)

-- re-apply whenever a weapon is in the loadout but not wearing its skin (spawn, weapon given again, ...)
CreateThread(function()
    while true do
        Wait(1500)
        if next(Wanted) then
            local ped = PlayerPedId()
            for hash, tint in pairs(Wanted) do
                if HasPedGotWeapon(ped, hash, false) and GetPedWeaponTintIndex(ped, hash) ~= tint then
                    SetPedWeaponTintIndex(ped, hash, tint)
                end
            end
        end
    end
end)

RegisterNUICallback('setWeaponSkin', function(data, cb)
    ESX.TriggerServerCallback('HUD_Menu:SetWeaponSkin', function(ok)
        if ok then UpdateSkills() end
    end, data.weapon, data.tint)
    cb('ok')
end)

-- the NUI needs the tint names once
function UpdateSkinOptions()
    ESX.TriggerServerCallback('HUD_Menu:GetSkinOptions', function(opts)
        SendNUIMessage({ type = 'skinOptions', options = opts })
    end)
end
