ESX = nil

TriggerEvent('esx:getSharedObject', function(obj)ESX = obj end)

ESX.RegisterServerCallback('esx_spectate:getPlayerData', function(source, cb, id)
    local xPlayer = ESX.GetPlayerFromId(id)
    if xPlayer ~= nil then
        cb(xPlayer)
    end
end)

ESX.RegisterServerCallback('esx_spectate:getOtherPlayerData', function(source, cb, target)

        local xPlayer = ESX.GetPlayerFromId(target)
        if xPlayer ~= nil then
            local identifier = GetPlayerIdentifiers(target)[1]

            local result = MySQL.Sync.fetchAll("SELECT * FROM users WHERE identifier = @identifier", {
                ['@identifier'] = identifier
            })

            local name = string.gsub(result[1].playerName, "_", " ")
            local sex = result[1].sex
            local dob = result[1].dateofbirth
            local money = result[1].money
            local bank = result[1].bank

            local data = {
                name = GetPlayerName(target),
                job = xPlayer.job,
                inventory = xPlayer.inventory,
                weapons = xPlayer.loadout,
                name = name,
                sex = sex,
                dob = dob,
                money = money,
                bank = bank,
                gang = xPlayer.gang,
            }

            TriggerEvent('esx_license:getLicenses', target, function(licenses)
                data.licenses = licenses
                cb(data)
            end)
        end
end)

RegisterCommand('sp2', function(source, args, user)
    local xPlayer = ESX.GetPlayerFromId(source)

    if xPlayer.permission_level >= 1 then
        if xPlayer.get('aduty') then

            if args[1] then

                target = tonumber(args[1])

                    if target then

                        local name = GetPlayerName(target)
                        if name then
							targetPlayer = ESX.GetPlayerFromId(target)



		                    TriggerClientEvent('ManageAdmins', -1, false, source)
							local xPlayers = ESX.GetPlayers()
                            for i=1, #xPlayers, 1 do
                                local xP = ESX.GetPlayerFromId(xPlayers[i])
                                if xP.permission_level > 0 then

                                end
                            end
							TriggerClientEvent('esx_spectate:spectatexxxx',source,target)

                        else
                            TriggerClientEvent('chatMessage', source, "[SYSTEM]", {255, 0, 0}, " ^0Player mored nazar online nist!")
                        end

                    else

                        TriggerClientEvent('chatMessage', source, "[SYSTEM]", {255, 0, 0}, " ^0Shoma dar ghesmat ID faghat mitavanid adad vared konid!")

                    end


                else
                    TriggerClientEvent('chatMessage', source, "[SYSTEM]", {255, 0, 0}, " ^0Syntax vared shode eshtebah ast!")
            end
        else
            TriggerClientEvent('chatMessage', source, "[SYSTEM]", {255, 0, 0}, " ^0Shoma nemitavanid dar halat ^1OffDuty ^0az command haye admini estefade konid!")
        end
    else
        TriggerClientEvent('chatMessage', source, "[SYSTEM]", {255, 0, 0}, " ^0Shoma ^1Admin ^0nistid!")
    end
end)

RegisterCommand('sp', function(source, args, user)
    local xPlayer = ESX.GetPlayerFromId(source)

    if xPlayer.permission_level >= 1 then
        if xPlayer.get('aduty') then

            if args[1] then

                target = tonumber(args[1])

                    if target then

                        local name = GetPlayerName(target)
                        if name then
							targetPlayer = ESX.GetPlayerFromId(target)




							local xPlayers = ESX.GetPlayers()
                            for i=1, #xPlayers, 1 do
                                local xP = ESX.GetPlayerFromId(xPlayers[i])
                                if xP.permission_level > 0 then

                                end
                            end
							TriggerClientEvent('Admin_Menu:spec',source,target)

                        else
                            TriggerClientEvent('chatMessage', source, "[SYSTEM]", {255, 0, 0}, " ^0Player mored nazar online nist!")
                        end

                    else

                        TriggerClientEvent('chatMessage', source, "[SYSTEM]", {255, 0, 0}, " ^0Shoma dar ghesmat ID faghat mitavanid adad vared konid!")

                    end


                else
                    TriggerClientEvent('chatMessage', source, "[SYSTEM]", {255, 0, 0}, " ^0Syntax vared shode eshtebah ast!")
            end
        else
            TriggerClientEvent('chatMessage', source, "[SYSTEM]", {255, 0, 0}, " ^0Shoma nemitavanid dar halat ^1OffDuty ^0az command haye admini estefade konid!")
        end
    else
        TriggerClientEvent('chatMessage', source, "[SYSTEM]", {255, 0, 0}, " ^0Shoma ^1Admin ^0nistid!")
    end
end)

RegisterCommand('csp', function(source)
    local xPlayer = ESX.GetPlayerFromId(source)

    if xPlayer.permission_level >= 1 then

	    local xPlayers = ESX.GetPlayers()
        for i=1, #xPlayers, 1 do
            local xP = ESX.GetPlayerFromId(xPlayers[i])
            if xP.permission_level > 0 then

            end
        end
        TriggerClientEvent('esx_spectate:spectateclose',source)
        TriggerClientEvent('ManageAdmins', -1, 2, source)
    else
        TriggerClientEvent('chatMessage', source, "[SYSTEM]", {255, 0, 0}, " ^0Shoma ^1Admin ^0nistid!")
    end
end)