
ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

RegisterServerEvent('changePlayerBucket')
AddEventHandler('changePlayerBucket', function(bucket)
    local _source = source
    SetPlayerRoutingBucket(_source, bucket)
end)





RegisterCommand('spawn', function(source, args)
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)

    if xPlayer then
        local playerBucket = GetPlayerRoutingBucket(_source)
        if playerBucket == 90 then
            if args[1] then
                local vehicleName = args[1]
                TriggerClientEvent('spawnVehicle', _source, vehicleName)
            else
                TriggerClientEvent('showNotification', _source, "Lotfan Esm Mashin Ra Vared Konid.")
            end
        else
            TriggerClientEvent('showNotification', _source, "Shoma Dastresi Be In Komand Ra Dar in World Nadarid.")
        end
    end
end, false)

RegisterCommand('dveh', function(source)
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)

    if xPlayer then
        local playerBucket = GetPlayerRoutingBucket(_source)
        if playerBucket == 90 then
            TriggerClientEvent('deleteVehicle', _source)
        else
            TriggerClientEvent('showNotification', _source, "Shoma Dastresi Be In Komand Ra Dar in World Nadarid.")
        end
    end
end, false)

RegisterCommand('revme', function(source)
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)

    if xPlayer then
        local playerBucket = GetPlayerRoutingBucket(_source)
        if playerBucket == 90 then
            TriggerClientEvent('esx_ambulancejob:revivex', _source)
            TriggerClientEvent('showNotification', _source, "Shoma Revive Shodid!")
        else
            TriggerClientEvent('showNotification', _source, "Shoma Dastresi Be In Komand Ra Dar in World Nadarid.")
        end
    end
end, false)

RegisterCommand('cw', function(source, args)
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)

    if xPlayer then
        exports.oxmysql:scalar('SELECT `group` FROM users WHERE identifier = @identifier', {
            ['@identifier'] = xPlayer.identifier
        }, function(group)

            if group == "streamer" then
                local targetId = tonumber(args[1]) or _source
                local targetPlayer = ESX.GetPlayerFromId(targetId)

                if targetPlayer then
                    local playerPed = GetPlayerPed(targetId)
                    local playerCoords = GetEntityCoords(playerPed)
                    local targetCoords = vector3(632.2348, -10.6546, 82.779)

                    if #(playerCoords - targetCoords) <= 20.0 then
                        SetPlayerRoutingBucket(targetId, 90)
                        TriggerClientEvent('showNotification', targetId, "Shoma Be World 90 Vared Shodid!")
                        if _source ~= targetId then
                            TriggerClientEvent('showNotification', _source, "Bazikon ID " .. targetId .. " Be World 90 Vared Shod!")
                        end
                    else
                        TriggerClientEvent('showNotification', _source, "Bazikon Mored Nazar Nazdik Be Noghteye Vared Shodan Nist!")
                    end
                else
                    TriggerClientEvent('showNotification', _source, "Bazikon Mored Nazar Peyda Nashod!")
                end
            else
                TriggerClientEvent('showNotification', _source, "Shoma Dastresi Be In Komand Ra Nadarid!")
            end
        end)
    end
end, false)

RegisterCommand('bw', function(source)
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)

    if xPlayer then
        local playerBucket = GetPlayerRoutingBucket(_source)

        if playerBucket == 90 then
            SetPlayerRoutingBucket(_source, 0)
            TriggerClientEvent('teleportPlayer', _source, vector3(632.2348, -10.6546, 82.779))
            TriggerClientEvent('showNotification', _source, "Shoma Be World Asli Bargashtid!")
        else
            TriggerClientEvent('showNotification', _source, "Shoma Dar World 90 Nistid!")
        end
    end
end, false)

RegisterCommand('ctp', function(source)
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)

    if xPlayer then
        local playerBucket = GetPlayerRoutingBucket(_source)

        if playerBucket == 90 then
            TriggerClientEvent('gpstools:tpwaypointt', _source)
        else
            TriggerClientEvent('showNotification', _source, "Shoma Dastresi Be In Komand Ra Dar in World Nadarid.")
        end
    end
end, false)

RegisterCommand('armorme', function(source)
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)

    if xPlayer then
        local playerBucket = GetPlayerRoutingBucket(_source)


        if playerBucket == 90 then
            TriggerClientEvent('setArmorToFull', _source)
            TriggerClientEvent('showNotification', _source, "Armor Shoma Por Shod!")
        else
            TriggerClientEvent('showNotification', _source, "Shoma Dastresi Be In Komand Ra Dar in World Nadarid.")
        end
    end
end, false)

RegisterCommand('cgetmaxammo', function(source)
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)

    if xPlayer then
        local playerBucket = GetPlayerRoutingBucket(_source)

        if playerBucket == 90 then
            TriggerClientEvent('setMaxAmmo', _source)
            TriggerClientEvent('showNotification', _source, "Tir Aslahe Shoma Por Shod!")
        else
            TriggerClientEvent('showNotification', _source, "Shoma Dastresi Be In Komand Ra Dar in World Nadarid.")
        end
    end
end, false)

RegisterCommand("openmenu", function(source)
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)

    local playerBucket = GetPlayerRoutingBucket(_source)

    if playerBucket == 90 then

        TriggerClientEvent('menu:openMainMenu', _source)
    end
end, false)