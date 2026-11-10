-- Pub by FleeX Team , https://discord.gg/87rGBxgCsa

local isback = nil

RegisterNetEvent('justice:notifyp', function(message, passedJob,share)
    if ESX.PlayerData.job.name == passedJob then
        if share then
            TriggerEvent('chat:addMessage', { color = {0, 95, 254}, multiline = true, args = {"[DISPATCH SHARE]", message}}, 'dispatch')
        else
            TriggerEvent('chat:addMessage', { color = {0, 95, 254}, multiline = true, args = {"[DISPATCH]", message}}, 'dispatch')
        end
    end
end)

RegisterNetEvent('justice:playSound', function(file, volume, passedJob,ext)
    if ext then ExecuteCommand("resp ".. ext) end
        if not passedJob then
        if ESX.PlayerData.job.name == "justice" then
            TriggerEvent('InteractSound_CL:PlayOnOne', file, volume)
        end
    else
        if ESX.PlayerData.job.name == passedJob then
            TriggerEvent('InteractSound_CL:PlayOnOne', file, volume)
        end
    end
end)

RegisterNetEvent('justice:respcall', function(source,data)
    if ESX.PlayerData.job.name == "justice" then
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

RegisterNetEvent('justice:addback', function(source,data)
    if ESX.PlayerData.job.name == "justice" then
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

function checkPlayerJailInfo()
    ESX.selectPlayerMenu(function(src)
        ESX.TriggerServerCallback('jail:justiceJail', function(data)
            if data then
                ESX.chatMessage(('Fard mored nazar %s daghige be dalile %s bayad jail shavad'):format(data.time, data.reason), 'job')
            else
                ESX.chatMessage('Fard mored nazar jail nist!', 'job')
            end
        end, src)
    end, 5)
end

local trackList = {}
local trackThread = false
local trackBlips = {}

local function startTrackThread()
    if not trackThread then
        trackThread = true
        CreateThread(function()
            while trackThread and ESX.tableLength(trackList) > 0 do
                for k, v in pairs(trackList) do
                    ESX.TriggerServerCallback('getplayercoords', function(coords)
                        if coords then
                            if trackBlips[v.src] then
                                SetBlipCoords(trackBlips[v.src], coords.x, coords.y, coords.z)
                            else
                                local blip = AddBlipForCoord(coords.x, coords.y, coords.z)
                                SetBlipAlpha(blip, 180)
                                SetBlipSprite(blip, 1)
                                SetBlipScale(blip, 1.8)
                                SetBlipShrink(blip, true)
                                SetBlipCategory(blip, 7)
                                SetBlipDisplay(blip, 6)
                                SetBlipColour(blip, 73)
                                BeginTextCommandSetBlipName("STRING")
                                AddTextComponentString(v.name)
                                EndTextCommandSetBlipName(blip)
                                trackBlips[v.src] = blip
                            end
                        else
                            if trackBlips[v.src] then
                                RemoveBlip(trackBlips[v.src])
                            end
                            trackList[v.src] = nil
                        end
                    end, v.src)
                end
                for k, v in pairs(trackBlips) do
                    if not trackList[k] then
                        trackBlips[k] = nil
                        RemoveBlip(v)
                    end
                end
                Wait(5000)
            end
            trackThread = false
            for k, v in pairs(trackBlips) do
                RemoveBlip(v)
            end
            trackBlips = {}
        end)
    end
end

local function openWarnMenu(data)
    lib.registerMenu({
        id = 'justicewarn2',
        title = 'Warns',
        options = {{label = (trackList[data.src] and 'Untrack' or 'Track') .. ' location', args = 'track'}}
    }, function (selected, scrollIndex, args, checked)
        if args == 'track' then
            if trackList[data.src] then
                trackList[data.src] = nil
            else
                trackList[data.src] = {
                    src = data.src,
                    name = data.name
                }
                startTrackThread()
            end
        end
        openWarnMenu(data)
    end)
    lib.showMenu('justicewarn2')
end

RegisterNetEvent('justice:openWarnMenu', function(data)
    if ESX.tableLength(data) == 0 then
        return xPlayer.chatMessage('List khali ast', 'job')
    end
    local options = {}
    for k, v in pairs(data) do
        table.insert(options, {label = ('%s %s'):format(v.name, v.data.reason), args = k})
    end
    lib.registerMenu({
        id = 'justicewarn1',
        title = 'Warns',
        options = options
    }, function (selected, scrollIndex, args, checked)
        openWarnMenu(data[args])
    end)
    lib.showMenu('justicewarn1')
end)




local function openWarnMenu2(identifier)
    lib.registerMenu({
        id = 'justicewarn2',
        title = 'Warns',
        options = {{label = 'delete', args = 'delete'}}
    }, function (selected, scrollIndex, args, checked)
        if args == 'delete' then
            ExecuteCommand('setjwarn ' .. identifier)
        end
    end)
    lib.showMenu('justicewarn2')
end

RegisterNetEvent('justice:openWarnMenu2', function(data)
    if ESX.tableLength(data) == 0 then
        return ESX.chatMessage('List khali ast', 'job')
    end

    local options = {}
    for k, v in pairs(data) do
        table.insert(options, {label = ('%s %s'):format(k, v.reason), args = k, ts = v.ts})
    end
    table.sort(options, function (a, b)
        return a.ts > b.ts
    end)

    lib.registerMenu({
        id = 'justicewarn3',
        title = 'Warns',
        options = options
    }, function (selected, scrollIndex, args, checked)
        openWarnMenu2(args)
    end)
    lib.showMenu('justicewarn3')
end)