-- Pub by FleeX Team , https://discord.gg/87rGBxgCsa

local walkstickUsed = false
local walkstickObject = nil

RegisterNetEvent('cane:open')
AddEventHandler('cane:open', function()
    local ped = PlayerPedId()
    if not walkstickUsed then
        ESX.Streaming.RequestAnimSet('move_heist_lester')
        SetPedMovementClipset(ped, 'move_heist_lester', 1.0) 
        ESX.Game.SpawnObject('prop_cs_walking_stick',vector3(0, 0, 0),function(obj)
            walkstickObject = obj
            AttachEntityToEntity(walkstickObject, ped, GetPedBoneIndex(ped, 57005), 0.16, 0.06, 0.0, 335.0, 300.0, 120.0, true, true, false, true, 5, true)
            Citizen.CreateThread(function()
                while DoesEntityExist(walkstickObject) do
                    Citizen.Wait(100)
                    SetPedMovementClipset(ped, 'move_heist_lester', 1.0) 
                end
                ResetPedMovementClipset(PlayerPedId())
                walkstickUsed = false
            end)
        end)
    else
        ResetPedMovementClipset(PlayerPedId())
        ESX.Game.DeleteEntity(walkstickObject)
    end
    walkstickUsed = not walkstickUsed
end)

RegisterNetEvent('esx:removeInventoryItemss',function(label,count,name,newcount)
    if name == 'asa' and newcount <= 0 and walkstickUsed then
        TriggerEvent('cane:open')
    end
end)