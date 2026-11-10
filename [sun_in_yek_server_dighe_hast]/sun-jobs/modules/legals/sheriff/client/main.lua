-- Pub by FleeX Team , https://discord.gg/87rGBxgCsa

local isback = nil

RegisterNetEvent('sheriff:notifyp', function(message, passedJob,share)
    if ESX.PlayerData.job.name == passedJob then
        if share then
            TriggerEvent('chat:addMessage', { color = {0, 95, 254}, multiline = true, args = {"[DISPATCH SHARE]", message}}, 'dispatch')
        else
            TriggerEvent('chat:addMessage', { color = {0, 95, 254}, multiline = true, args = {"[DISPATCH]", message}}, 'dispatch')
        end
    end
end)

RegisterNetEvent('sheriff:playSound', function(file, volume, passedJob,ext)
    if ext then ExecuteCommand("resp ".. ext) end
        if not passedJob then
        if ESX.PlayerData.job.name == "sheriff" then
            TriggerEvent('InteractSound_CL:PlayOnOne', file, volume)
        end
    else
        if ESX.PlayerData.job.name == passedJob then
            TriggerEvent('InteractSound_CL:PlayOnOne', file, volume)
        end
    end
end)

RegisterNetEvent('sheriff:respcall', function(source,data)
    if ESX.PlayerData.job.name == "sheriff" then
        local ped = GetPlayerPed(GetPlayerFromServerId(source))
        if ped == PlayerPedId then return end
        --   local coords
        if DoesEntityExist(ped) then
            local coords = data.coords
            SetNewWaypoint(coords.x,coords.y)
            SetNewWaypoint(coords.x,coords.y)
        end
    end
end)

RegisterNetEvent('sheriff:addback', function(source,data)
    if ESX.PlayerData.job.name == "sheriff" then
        local ped = GetPlayerPed(GetPlayerFromServerId(source))
        if ped == PlayerPedId then return end
        --   local coords
        if DoesEntityExist(ped) then
            local coords = GetEntityCoords(ped)
            isback = data.coords
            Citizen.SetTimeout(17000,function()
                isback = nil
            end)
        end
    end
end)

AddEventHandler('KeyDown:e',function()
	if isback ~= nil then
		SetNewWaypoint(isback.x,isback.y)
		SetNewWaypoint(isback.x,isback.y)
	end
end)