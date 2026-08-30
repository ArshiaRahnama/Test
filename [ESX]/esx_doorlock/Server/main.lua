ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
local _doorCache = {}

function isAllowedToChange(player)
    local xPlayer = ESX.GetPlayerFromId(player)
    return xPlayer and xPlayer.permission_level >= 9
end

ESX.RegisterServerCallback('NUI_doorlock:cb:getDoors', function(source, cb)
    local doors = LoadResourceFile(GetCurrentResourceName(), "Server/Files/Doors.json")
    doors = json.decode(doors)
    cb(doors, _doorCache)
end)

RegisterServerEvent("NUI_doorlock:server:addDoor", function(_doorCoords, _doorModel, _heading, type, _textCoords, dist, jobs, pin, item)
    local _src = source
    if isAllowedToChange(_src) then
        local usePin = pin ~= ""
        local useitem = item ~= ""
        local doors = LoadResourceFile(GetCurrentResourceName(), "Server/Files/Doors.json")
        doors = json.decode(doors)
        local tableToIns = {
            doorCoords = _doorCoords,
            _doorModel = _doorModel,
            _heading = _heading,
            _type = type,
            _textCoords = _textCoords,
            dist = dist,
            jobs = jobs,
            usePin = usePin,
            pin = pin,
            useitem = useitem,
            item = item
        }
        table.insert(doors, tableToIns)
        SaveResourceFile(GetCurrentResourceName(), "Server/Files/Doors.json", json.encode(doors, { indent = true }), -1)
        TriggerClientEvent("NUI_doorlock:client:refreshDoors", -1, tableToIns)
        TriggerEvent('DiscordBot:ToDiscord', 'adminmenu', 'DoorlockLog', '```css\n[ Admin : '..GetPlayerName(_src)..'(' .. _src .. ') ]\n[ Action : ADDED DOOR ]\n[ Model : '..tostring(_doorModel)..' ]\n[ Coords : '..tostring(_doorCoords)..' ]\n```', 'user', true, _src, false)
    end
end)

RegisterServerEvent("NUI_doorlock:server:addDoubleDoor", function(_doorsDobule, type, _textCoords, dist, jobs, pin, item)
    local _src = source
    if isAllowedToChange(_src) then
        local doors = LoadResourceFile(GetCurrentResourceName(), "Server/Files/Doors.json")
        doors = json.decode(doors)
        local usePin = pin ~= ""
        local useitem = item ~= ""
        local tableToIns = {
            _doorsDouble = _doorsDobule,
            _type = type,
            _textCoords = _textCoords,
            dist = dist,
            jobs = jobs,
            usePin = usePin,
            pin = pin,
            useitem = useitem,
            item = item,
        }
        table.insert(doors, tableToIns)
        SaveResourceFile(GetCurrentResourceName(), "Server/Files/Doors.json", json.encode(doors, { indent = true }), -1)
        TriggerClientEvent("NUI_doorlock:client:refreshDoors", -1, tableToIns)
        TriggerEvent('DiscordBot:ToDiscord', 'adminmenu', 'DoorlockLog', '```css\n[ Admin : '..GetPlayerName(_src)..'(' .. _src .. ') ]\n[ Action : ADDED DOUBLE DOOR ]\n[ Coords : '..tostring(_textCoords)..' ]\n```', 'user', true, _src, false)
    end
end)

RegisterServerEvent("NUI_doorlock:server:updateDoor", function(id, type)
    _doorCache[id] = type
    TriggerClientEvent("NUI_doorlock:client:updateDoorState", -1, id, type)
end)

RegisterServerEvent("NUI_doorlock:server:syncRemove", function(id)
    local _src = source
    if isAllowedToChange(_src) then
        local doors = LoadResourceFile(GetCurrentResourceName(), "Server/Files/Doors.json")
        doors = json.decode(doors)
        table.remove(doors, id)
        SaveResourceFile(GetCurrentResourceName(), "Server/Files/Doors.json", json.encode(doors, { indent = true }), -1)
        TriggerClientEvent("NUI_doorlock:client:removeGlobDoor", -1, id)
        TriggerEvent('DiscordBot:ToDiscord', 'adminmenu', 'DoorlockLog', '```css\n[ Admin : '..GetPlayerName(_src)..'(' .. _src .. ') ]\n[ Action : REMOVED DOOR ]\n[ Door ID : '..tostring(id)..' ]\n```', 'user', true, _src, false)
    end
end)

RegisterCommand(Config.commands.CreateDoor, function(source, args)
    if isAllowedToChange(source) then
        TriggerClientEvent("NUI_doorlock:client:setUpDoor", source)
    else
        TriggerClientEvent('ESX:showNotification', source, '~r~Shoma Dastrasi nadarid')
    end
end, false)

RegisterCommand(Config.commands.RemoveDoor, function(source, args)
    if isAllowedToChange(source) then
        TriggerClientEvent("NUI_doorlock:client:deleteDoor", source)
    else
        TriggerClientEvent('ESX:showNotification', source, '~r~Shoma Dastrasi nadarid')
    end
end, false)

ESX.RegisterServerCallback('NUI_doorlock:cb:hasObj', function(source, cb, item)
    local xPlayer = ESX.GetPlayerFromId(source)
    local itemPly = xPlayer.getInventoryItem(item)
    cb(itemPly and itemPly.count > 0)
end)
