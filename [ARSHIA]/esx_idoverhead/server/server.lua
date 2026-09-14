ESX = nil
labels = {}
netIds = {}
timePlays = {}

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

RegisterServerEvent('esx_idoverhead:changeLabelHideStatus')
AddEventHandler('esx_idoverhead:changeLabelHideStatus', function(id, status)
    if id == nil or type(status) ~= "boolean" then return end

    local xPlayer = ESX.GetPlayerFromId(source)

    if xPlayer.permission_level > 0 then
        if labels[id] then
            TriggerClientEvent('esx_idoverhead:changeLabelHideStatus', -1, id, status)
        end
    else
        print(('esx_idoverhead: %s attempted to modify label hide status!'):format(xPlayer.identifier))
        TriggerEvent('DiscordBot:ToDiscord', 'adminmenu', 'JobSuspiciousLog', '```css\n[ Resource : esx_idoverhead ]\n[ Player Steam : '..tostring(xPlayer.identifier)..' ]\n[ Attempted : to modify label hide status! ]\n[ Reason Blocked : not authorized / invalid data ]\n```', 'user', true, source, false)
    end
end)

RegisterNetEvent('esx_idoverhead:modifyLabel')
AddEventHandler('esx_idoverhead:modifyLabel', function(id, label)
    if id == nil or label == nil then return end

    local xPlayer = ESX.GetPlayerFromId(source)

    if label.badge == false then
        if xPlayer.permission_level > 0 then
            if not labels[id] then
                labels[id] = {}
            end

            if DoesTagExist(id, label.badge) then
                RemoveTag(id, label.badge)
            end

            if not DoesTagExist(id, label.badge) then
                table.insert(labels[id], label)
                TriggerClientEvent("esx_idoverhead:modifyLabel", -1, id, label)
                AddToNet(xPlayer.source, "label", id)
            else
                print("Error regarding adding admin tag because already exist!")
            end
        else
            TriggerEvent('esx_logger:log', source, "Attempted to modify admin labels")
            DropPlayer(source, "Attempted to modify admin labels")
        end
    elseif label.badge == true then
        if xPlayer.job.name == "police" or xPlayer.job.name == "ambulance" or xPlayer.job.name == "sheriff" or xPlayer.job.name == "mt" or xPlayer.job.name == "fbi" or xPlayer.job.name == "cid" or xPlayer.job.name == "cia" or xPlayer.job.name == "marshal" or xPlayer.job.name == "judge" or xPlayer.job.name == "doa" then
            if not labels[id] then
                labels[id] = {}
            end

            if DoesTagExist(id, label.badge) then
                RemoveTag(id, label.badge)
            end

            if not DoesTagExist(id, label.badge) then
                table.insert(labels[id], label)
                TriggerClientEvent("esx_idoverhead:modifyLabel", -1, id, label)
                AddToNet(xPlayer.source, "label", id)
            else
                print("Error regarding adding job tag because already exist!")
            end
        else
            TriggerEvent('esx_logger:log', source, "Attempted to modify job labels")
            DropPlayer(source, "Attempted to modify job labels")
        end
    end
end)

RegisterNetEvent('esx_idoverhead:removeLabel')
AddEventHandler('esx_idoverhead:removeLabel', function(id, state)
    if id == nil or state == nil then return end

    local xPlayer = ESX.GetPlayerFromId(source)

    if state == false then
        if xPlayer.permission_level > 0 then
            if DoesTagExist(id, state) then
                RemoveTag(id, state)
            end

            if not DoesTagExist(id, state) then
                TriggerClientEvent('esx_idoverhead:updateLabels', -1, labels)
            end
        else
            TriggerEvent('esx_logger:log', source, "Attempted to remove admin labels")
            DropPlayer(source, "Attempted to remove admin labels")
        end
    elseif state == true then
        if xPlayer.job.name == "police" or xPlayer.job.name == "ambulance" or xPlayer.job.name == "sheriff" or xPlayer.job.name == "mt" or xPlayer.job.name == "fbi" or xPlayer.job.name == "cid" or xPlayer.job.name == "cia" or xPlayer.job.name == "marshal" or xPlayer.job.name == "judge" or xPlayer.job.name == "doa" then
            if DoesTagExist(id, state) then
                RemoveTag(id, state)
            end

            if not DoesTagExist(id, state) then
                TriggerClientEvent('esx_idoverhead:updateLabels', -1, labels)
            end
        else
            TriggerEvent('esx_logger:log', source, "Attempted to remove job labels")
            DropPlayer(source, "Attempted to remove job labels")
        end
    end
end)

AddEventHandler('esx:playerLoaded', function(source)
    local _source = source
    TriggerClientEvent('esx_idoverhead:updateLabels', source, labels)
end)

ESX.RegisterServerCallback("esx_idoverhead:retrievePlayTime", function(source, cb)
    local src = source
    local identifier = GetPlayerIdentifier(src)

    MySQL.Async.fetchAll("SELECT timePlay FROM users WHERE identifier = @identifier", { ["@identifier"] = identifier }, function(result)
        if result and result[1] then
            local timePlayP = result[1].timePlay
            if timePlayP < 21600 then
                cb(true)
            else
                cb(false)
            end
        else
            cb(false)
        end
    end)
end)

RegisterNetEvent('esx_idoverhead:checkTimePlay')
AddEventHandler('esx_idoverhead:checkTimePlay', function()
    local src = source
    if src == nil then return end

    local xPlayer = ESX.GetPlayerFromId(src)
    if not xPlayer then return end







    if timePlays[src] == nil then
        local identifier = GetPlayerIdentifier(src)

        MySQL.Async.fetchAll("SELECT timePlay FROM users WHERE identifier = @identifier", { ["@identifier"] = identifier }, function(result)
            if result and result[1] then
                local timePlayP = result[1].timePlay
                timePlays[src] = { source = src, joinTime = os.time(), timePlay = timePlayP }

                if timePlayP < 21600 and xPlayer.permission_level <= 0 then

                else
                    AddToNet(src, "timePlay", src)
                end
            end
        end)
    else
        print("esx_idoverhead: duplicate checkTimePlay call ignored for source " .. src)
    end
end)

RegisterNetEvent('ido:ShowID')
AddEventHandler('ido:ShowID', function()
    local _source = source
    if _source == nil then return end
    TriggerClientEvent('3dme:triggerDisplay', -1, " Player [ " .. _source .. " ] Be ID Ha Negah Kard", _source, true)
end)

AddEventHandler("playerDropped", function()
    local _source = source
    if _source ~= nil then
        local identifier = GetPlayerIdentifier(_source)

        if netIds[identifier] == nil then
            return
        end

        if netIds[identifier].label ~= nil then
            labels[netIds[identifier].label] = nil
            netIds[identifier]["label"] = nil
            TriggerClientEvent('esx_idoverhead:updateLabels', -1, labels)
        end

        if netIds[identifier].new ~= nil then
            if timePlays[netIds[identifier].new] ~= nil then
                local leaveTime = os.time()
                local saveTime = leaveTime - timePlays[netIds[identifier].new].joinTime

                MySQL.Async.execute('UPDATE users SET timePlay = timePlay + @timePlay WHERE identifier=@identifier', {
                    ['@identifier'] = identifier,
                    ['@timePlay'] = saveTime
                }, function()
                    timePlays[netIds[identifier].new] = nil
                    labels[netIds[identifier].new] = nil
                    netIds[identifier]["new"] = nil
                    TriggerClientEvent('esx_idoverhead:updateLabels', -1, labels)
                end)
            else
                print("There was an error regarding saving play time!")
            end
        elseif netIds[identifier].timePlay ~= nil then
            local leaveTime = os.time()
            local saveTime = leaveTime - timePlays[netIds[identifier].timePlay].joinTime

            MySQL.Async.execute('UPDATE users SET timePlay = timePlay + @timePlay WHERE identifier=@identifier', {
                ['@identifier'] = identifier,
                ['@timePlay'] = saveTime
            }, function()
                timePlays[netIds[identifier].timePlay] = nil
                netIds[identifier]["timePlay"] = nil
            end)
        end
    end
end)

function addNewPlayer(source, id, label)
    if id == nil or label == nil or label.badge == nil then return end

    if label.badge == true then
        if not labels[id] then
            labels[id] = {}
        end

        if DoesTagExist(id, label.badge) then
            RemoveTag(id, label.badge)
        end

        if not DoesTagExist(id, label.badge) then
            table.insert(labels[id], label)
            TriggerClientEvent("esx_idoverhead:modifyLabel", -1, id, label)
            AddToNet(source, "new", id)
        else
            print("Error regarding adding new tag because already exist!")
        end
    else
        TriggerEvent('esx_logger:log', source, "Attempted to modify new labels")
        DropPlayer(source, "Attempted to modify new labels")
    end
end

function DoesTagExist(player, badge)
    if labels[player] == nil then return false end
    for k, v in pairs(labels[player]) do
        if v.badge == badge then
            return true
        end
    end
    return false
end

function RemoveTag(player, badge)
    if labels[player] == nil then return end
    for k, v in pairs(labels[player]) do
        if v.badge == badge then
            labels[player][k] = nil
        end
    end
end

function AddToNet(source, netType, id)
    if source == nil or netType == nil or id == nil then return end

    local identifier = GetPlayerIdentifier(source)

    if netIds[identifier] == nil then
        netIds[identifier] = {}
    end

    if netIds[identifier][netType] == nil then
        netIds[identifier][netType] = id
    end
end

