-- Pub by FleeX Team , https://discord.gg/87rGBxgCsa

ESX                           = nil

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Wait(100)
	end
end)

--Example: /prop prop_sandwich_01 18905 mp_player_inteat@burger mp_player_int_eat_burger
RegisterCommand('prope',function(source, args, rawCommand)
    if ESX.GetPlayerData().permission_level >= 20 then
        local model = joaat(args[1] or "prop_cs_burger_01")
        if not HasModelLoaded(model) then RequestModel(model) while not HasModelLoaded(model) do Wait(1) end end
        local playerPed = PlayerPedId()
        local playerCoords = GetEntityCoords(playerPed)
        local object = CreateObject(model, playerCoords.x, playerCoords.y, playerCoords.z, false, false, false)
        local boneArg = args[2]
        local boneToNumber = tonumber(boneArg)
        local bone = (boneArg and boneToNumber) and GetPedBoneIndex(playerPed, boneToNumber) or boneArg and GetEntityBoneIndexByName(playerPed, boneArg) or 18905
        local objectPositionData = useGizmo(object, bone, args[3], args[4])
        print(objectPositionData[1])
        local numbers = {}

        for num in objectPositionData[2]:gmatch("([^,]+)") do
            table.insert(numbers, tonumber(num))
        end
        print('position', vec(numbers[1], numbers[2], numbers[3]))
        print('rotation', vec(numbers[4], numbers[5], numbers[6]))
    end
end)

RegisterCommand('prope2',function(source, args, rawCommand)
    if ESX.GetPlayerData().permission_level >= 20 then
        local model = joaat(args[1] or "prop_cs_burger_01")
        local thread = true
        local ped = PlayerPedId()
        local type = 1
        local pos, rot = vec(tonumber(args[3]) or 0, tonumber(args[4]) or 0, tonumber(args[5]) or 0), vec(tonumber(args[6]) or 0, tonumber(args[7]) or 0, tonumber(args[8]) or 0)
        local bone = GetPedBoneIndex(ped, tonumber(args[2]))
        ESX.Game.SpawnLocalObject(model, GetEntityCoords(ped), function(entity)
            while thread do
                Wait(10)
                if IsControlPressed(0, 172) then
                    if type == 1 then
                        pos = pos + vec(0.001 * (IsControlPressed(0, 21) and 10.0 or 1.0), 0.0, 0.0)
                    else
                        rot = rot + vec(0.1 * (IsControlPressed(0, 21) and 10.0 or 1.0), 0.0, 0.0)
                    end
                end
                if IsControlPressed(0, 173) then
                    if type == 1 then
                        pos = pos - vec(0.001 * (IsControlPressed(0, 21) and 10.0 or 1.0), 0.0, 0.0)
                    else
                        rot = rot - vec(0.1 * (IsControlPressed(0, 21) and 10.0 or 1.0), 0.0, 0.0)
                    end
                end
                if IsControlPressed(0, 175) then
                    if type == 1 then
                        pos = pos + vec(0.0, 0.001 * (IsControlPressed(0, 21) and 10.0 or 1.0), 0.0)
                    else
                        rot = rot + vec(0.0, 0.1 * (IsControlPressed(0, 21) and 10.0 or 1.0), 0.0)
                    end
                end
                if IsControlPressed(0, 174) then
                    if type == 1 then
                        pos = pos - vec(0.0, 0.001 * (IsControlPressed(0, 21) and 10.0 or 1.0), 0.0)
                    else
                        rot = rot - vec(0.0, 0.1 * (IsControlPressed(0, 21) and 10.0 or 1.0), 0.0)
                    end
                end
                if IsControlPressed(0, 97) then
                    if type == 1 then
                        pos = pos + vec(0.0, 0.0, 0.001 * (IsControlPressed(0, 21) and 10.0 or 1.0))
                    else
                        rot = rot + vec(0.0, 0.0, 0.1 * (IsControlPressed(0, 21) and 10.0 or 1.0))
                    end
                end
                if IsControlPressed(0, 96) then
                    if type == 1 then
                        pos = pos - vec(0.0, 0.0, 0.001 * (IsControlPressed(0, 21) and 10.0 or 1.0))
                    else
                        rot = rot - vec(0.0, 0.0, 0.1 * (IsControlPressed(0, 21) and 10.0 or 1.0))
                    end
                end
                if IsControlJustPressed(0, 113) then
                    type = type == 1 and 2 or 1
                end
                if IsControlJustPressed(0, 191) then
                    DeleteEntity(entity)
                    break
                end
                AttachEntityToEntity(entity, PlayerPedId(), bone, pos, rot, true, true, false, true, 1, true)
                print(bone, pos, rot)
            end
        end)
    end
end, false)
