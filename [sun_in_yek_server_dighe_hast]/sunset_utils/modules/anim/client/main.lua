-- Pub by FleeX Team , https://discord.gg/87rGBxgCsa

local objects = {}

local function stop()
    ClearPedTasks(PlayerPedId())
    for k, v in pairs(objects) do
        ESX.Game.DeleteEntity(v)
    end
    objects = {}
    ESX.disableKey('x', false)
    ESX.disableKey('f3', false)
    ESX.emoteMenu(true)
end

RegisterNetEvent('anim:play', function(animName)
    if animConfig[animName] and ESX.isEmoteMenuActive() and not LocalPlayer.state.reviveThread then
        ESX.disableKey('x', true)
        ESX.disableKey('f3', true)
        ESX.emoteMenu(false)
        local config = animConfig[animName]
        local ped = PlayerPedId()
        local coords = GetEntityCoords(ped)
        local playing = true
        CreateThread(function()
            while playing do
                disableFiring()
                if config.disableVehicle then
                    DisableControlAction(0, 23, true)
                end
                Wait(0)
            end
        end)
        if config.objects then
            for k, v in pairs(config.objects) do
                local object = ESX.Game.SpawnObject(v.model, coords, nil, true)
                AttachEntityToEntity(object, ped, GetPedBoneIndex(ped, v.bone), v.pos.x, v.pos.y, v.pos.z, v.rot.x, v.rot.y, v.rot.z, true, true, false, true, 1, true)
                table.insert(objects, object)
            end
        end
        ESX.Streaming.RequestAnimDict(config.anim.dict)
        TaskPlayAnim(ped, config.anim.dict, config.anim.name, 8.0, 8.0, config.anim.duration, config.anim.flag, 0, false, false, false)
        SetTimeout(config.duration, function()
            playing = false
            stop()
            RemoveAnimDict(config.anim.dict)
        end)
        if not config.disableProgress then
            lib.progressCircle({
                duration = config.duration,
                position = 'bottom',
                useWhileDead = false,
                canCancel = false,
                allowRagdoll = true,
                allowFalling = true,
                disable = {
                },
            })
        end
    end
end)

RegisterNetEvent('anim:stop', function(animName)
    stop()
end)

-- RegisterCommand('asdzxcasd', function()
--     TriggerEvent('anim:play', 'abyari')
-- end)