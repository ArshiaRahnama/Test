local CountC = 0
local sendMSG = {}

local function ExemptFromAntiCheat(targetId, ms, kinds)
    if GetResourceState('UNIQUE_AC') ~= 'started' then return end
    pcall(function()
        exports['UNIQUE_AC']:ExemptPlayer(targetId, ms or 5000, kinds)
    end)
end

RegisterServerEvent('esx_aduty:AntiCheatExempt')
AddEventHandler('esx_aduty:AntiCheatExempt', function(ms, kinds)
    ExemptFromAntiCheat(source, ms, kinds)
end)

TriggerEvent('es:addAdminCommand', 'setwarn', 9, function(source, args)
    local Reson = table.concat(args, " ", 2)
    local steam = args[1]

    if steam then
        if args[2] then
            if tonumber(args[2]) == 0 then
                local Target = ESX.GetPlayerFromId(steam)
                if Target then
                    exports.oxmysql:execute("UPDATE users SET setwarn = ? WHERE identifier = ?", {
                        0,
                        Target.identifier
                    }, function(res)
                        if res then
                            TriggerClientEvent('chat:addMessage', source, { args = { '^1SYSTEM', 'Set Warn Laqv Shod' } })
                            sendMSG[Target.source] = nil
                        end
                    end)
                else
                    TriggerClientEvent('chat:addMessage', source, { args = { '^1SYSTEM', 'Id Wared Shode Eshtebah Ast Ya Player Online nist'}})
                end
            else
                exports.oxmysql:execute("SELECT * FROM users WHERE identifier = ?", {
                    steam
                }, function(Result)
                    if Result[1] then
                        exports.oxmysql:execute("UPDATE users SET setwarn = ? WHERE identifier = ?", {
                            Reson,
                            steam
                        }, function(res3)
                            if res3 then
                                TriggerClientEvent('chat:addMessage', source, { args = { '^1SYSTEM', 'Set Warn Sabt Shod' } })
                            end
                        end)
                    else
                        TriggerClientEvent('chat:addMessage', source, { args = { '^1SYSTEM', 'In Steam Hex Vojod Nadarad' } })
                    end
                end)
            end
        else
            TriggerClientEvent('chat:addMessage', source, { args = { '^1SYSTEM', 'Lotfan Matn Warn Ra Wared Konid!' } })
        end
    else
        TriggerClientEvent('chat:addMessage', source, { args = { '^1SYSTEM', 'Lotfan Steam Hex Wared Konid!' } })
    end

end, function(source, args)
	TriggerClientEvent('chat:addMessage', source, { args = { '^1SYSTEM', 'Insufficient Permissions.' } })
end, {help = "Set Warn", params = {{name = "SteamHex"}, {name = "Reson"}}})

AddEventHandler("esx:playerLoaded", function(source)
    sendMSG[source] = true
    local xPlayer = ESX.GetPlayerFromId(source)
    exports.oxmysql:execute("SELECT * FROM users WHERE identifier = ?", {
        xPlayer.identifier
    }, function(Result)
        CountC = 0
        if Result[1].setwarn ~= '0' and Result[1].setwarn ~= "" then
            ::reflasts::
            local xPlayer2 = ESX.GetPlayerFromId(source)
            if xPlayer2 then
                for k,v in pairs(ESX.GetPlayers()) do

                    local TaRget = ESX.GetPlayerFromId(v)
                    if TaRget.permission_level >= 1 then
                        TriggerClientEvent('chat:addMessage', TaRget.source, { args = { '^1SetWarn', 'ID(^2'..xPlayer.source..'^0)'..Result[1].setwarn}})
                    end
                    Wait(60000)
                    if CountC ~= 10 and sendMSG[source] then
                        CountC = CountC + 1
                        goto reflasts
                    end
                end
            end
        end
    end)
end)

TriggerEvent('es:addAdminCommand', 'addgangweapon', 9, function(source, args)

    if #args < 4 then
        TriggerClientEvent('chat:addMessage', source, { args = { '^1SYSTEM', 'Usage: /add2 <gang_name> <weapon_name> <ammo_count> <weapon_count>' } })
        return
    end

    local gangName = string.lower('gang_'..tostring(args[1]))
    local weaponName = string.upper('WEAPON_'..args[2])
    local ammoCount = tonumber(args[3])
    local weaponCount = tonumber(args[4])

    if not ammoCount or ammoCount <= 0 then
        TriggerClientEvent('chat:addMessage', source, { args = { '^1SYSTEM', 'Ammo count must be a positive number.' } })
        return
    end

    if not weaponCount or weaponCount <= 0 then
        TriggerClientEvent('chat:addMessage', source, { args = { '^1SYSTEM', 'Weapon count must be a positive number.' } })
        return
    end


    TriggerEvent('esx_datastore:getSharedDataStore', gangName, function(store)



        for i = 1, weaponCount do
            local storeWeapons = store.get('weapons') or {}
            table.insert(storeWeapons, {
                name = weaponName,
                ammo = ammoCount,
                components = "clip_default"
            })
            store.set('weapons', storeWeapons)
        end



        TriggerClientEvent('chat:addMessage', source, { args = { '^2SYSTEM', weaponCount .. ' weapons added successfully to the gang.' } })
    end)

end, function(source, args)
	TriggerClientEvent('chat:addMessage', source, { args = { '^1SYSTEM', 'Insufficient Permissions.' } })
end, {help = "Add Weapon To Gang", params = {{name = "Gang Name"}, {name = "Weapon Name"}, {name = "Ammo"}, {name = "Count"}}})

TriggerEvent('es:addAdminCommand', 'removegangweapon', 9, function(source, args)

    if #args < 3 then
        TriggerClientEvent('chat:addMessage', source, { args = { '^1SYSTEM', 'Usage: /removegangweapon <gang_name> <weapon_name> <weapon_count>' } })
        return
    end

    local gangName = string.lower('gang_'..tostring(args[1]))
    local weaponName = string.upper('WEAPON_'..args[2])
    local weaponCount = tonumber(args[3])

    if not weaponCount or weaponCount <= 0 then
        TriggerClientEvent('chat:addMessage', source, { args = { '^1SYSTEM', 'Weapon count must be a positive number.' } })
        return
    end

    TriggerEvent('esx_datastore:getSharedDataStore', gangName, function(store)
        local storeWeapons = store.get('weapons') or {}
        local removedCount = 0

        for i = #storeWeapons, 1, -1 do
            if storeWeapons[i].name == weaponName then
                table.remove(storeWeapons, i)
                removedCount = removedCount + 1

                if removedCount >= weaponCount then
                    break
                end
            end
        end

        store.set('weapons', storeWeapons)

        if removedCount > 0 then
            TriggerClientEvent('chat:addMessage', source, { args = { '^2SYSTEM', removedCount .. ' weapons removed successfully from the gang.' } })
        else
            TriggerClientEvent('chat:addMessage', source, { args = { '^1SYSTEM', 'No weapons found to remove.' } })
        end
    end)
end, function(source, args)
    TriggerClientEvent('chat:addMessage', source, { args = { '^1SYSTEM', 'Insufficient Permissions.' } })
end, {help = "Remove Weapon From Gang", params = {{name = "Gang Name"}, {name = "Weapon Name"}, {name = "Count"}}})

TriggerEvent('es:addAdminCommand', 'addgangitem', 9, function(source, args)
    if #args < 3 then
        TriggerClientEvent('chat:addMessage', source, { args = { '^1SYSTEM', 'Usage: /addgangitem <gang_name> <item_name> <item_count>' } })
        return
    end

    local gangName = string.lower('gang_'..tostring(args[1]))
    local itemName = string.lower(args[2])
    local itemCount = tonumber(args[3])

    if not itemCount or itemCount <= 0 then
        TriggerClientEvent('chat:addMessage', source, { args = { '^1SYSTEM', 'Item count must be a positive number.' } })
        return
    end

    TriggerEvent('esx_addoninventory:getSharedInventory', gangName, function(inventory)

        inventory.addItem(itemName, itemCount)

        TriggerClientEvent('chat:addMessage', source, { args = { '^2SYSTEM', itemCount .. ' ' .. itemName .. '(s) added successfully to the gang.' } })


    end)
end, function(source, args)
    TriggerClientEvent('chat:addMessage', source, { args = { '^1SYSTEM', 'Insufficient Permissions.' } })
end, {help = "Add Item To Gang", params = {{name = "Gang Name"}, {name = "Item Name"}, {name = "Count"}}})



TriggerEvent('es:addAdminCommand', 'addwhitelist', 9, function(source, args)
	if args[1] == nil then return TriggerClientEvent('chatMessage', source, "[SYSTEM]", {255, 0, 0}, "Lotfan SteamHex Ra Vared Konid") end
    if args[1] and string.sub(args[1], 1, string.len("steam:")) == "steam:" then

        exports.oxmysql:execute('SELECT identifier FROM whitelist WHERE identifier = ?' , {
            args[1]
        }, function(newJobCheck)
            if newJobCheck and #newJobCheck == 0 then
                exports.oxmysql:execute('INSERT INTO whitelist (identifier) VALUES (?)', {
                    tostring(args[1]),
                })
                TriggerClientEvent('chatMessage', source, "[SYSTEM]", {255, 0, 0}, "SteamHex^2 "..tostring(args[1]).." ^0Ba Movafagiat^2 Add ^0Shod")
            else
                TriggerClientEvent('chatMessage', source, "[SYSTEM]", {255, 0, 0}, "SteamHex^2 "..tostring(args[1]).."^1 In SteamHex Az Qabl Ezafe Shode")
            end
        end)
    else
        TriggerClientEvent('chatMessage', source, "[SYSTEM]", {255, 0, 0}, "Lotfan SteamHex Ra Be Sorat Sahih Vared Konid")
    end

end, function(source, args)
	TriggerClientEvent('chat:addMessage', source, { args = { '^1SYSTEM', 'Insufficient Permissions.' } })
end, {help = "Add Player Whitelist", params = {{name = "SteamHex"}}})

TriggerEvent('es:addAdminCommand', 'removewhitelist', 9, function(source, args)
	if args[1] == nil then return TriggerClientEvent('chatMessage', source, "[SYSTEM]", {255, 0, 0}, "Lotfan SteamHex Ra Vared Konid") end
    if args[1] and string.sub(args[1], 1, string.len("steam:")) == "steam:" then

        exports.oxmysql:execute('SELECT identifier FROM whitelist WHERE identifier = ?' , {
            args[1]
        }, function(newJobCheck)
            if newJobCheck and #newJobCheck ~= 0 then
                exports.oxmysql:execute('DELETE FROM whitelist WHERE identifier = ?', {
                    args[1]
                }, function(affectedRows)

                end)
                TriggerClientEvent('chatMessage', source, "[SYSTEM]", {255, 0, 0}, "SteamHex^2 "..tostring(args[1]).." ^0Ba Movafagiat^1 Delete^0 Shod")
            else
                TriggerClientEvent('chatMessage', source, "[SYSTEM]", {255, 0, 0}, "SteamHex^2 "..tostring(args[1]).."^1 In SteamHex Vojod Nadarad")
            end
        end)
    else
        TriggerClientEvent('chatMessage', source, "[SYSTEM]", {255, 0, 0}, "Lotfan SteamHex Ra Be Sorat Sahih Vared Konid")
    end

end, function(source, args)
	TriggerClientEvent('chat:addMessage', source, {'^1SYSTEM', 'Insufficient Permissions.' } )
end, {help = "Delete Player Whitelist", params = {{name = "SteamHex"}}})

TriggerEvent('es:addAdminCommand', 'changeworld', 1, function(source, args)
    local target = tonumber(args[1])
	local WebHook = GetConvar('unique_commands_1_changeworld_webhook', '')
	local xPlayer = ESX.GetPlayerFromId(source)
	if args[1] then
		if args[2] then
			if tonumber(args[2]) >= 0 and tonumber(args[2]) < 100000 then
				SetPlayerRoutingBucket(target, tonumber(args[2]))
				TriggerClientEvent('chatMessage', source, "[SYSTEM]", {255, 0, 0}, " ^0Shoma Word^1" .. GetPlayerName(target) .. "^0Ra Be^1" .. args[2] .. " ]")
				PerformHttpRequest(WebHook, function(Error, Content, Head) end, 'POST', json.encode({username = "MidNight-lOG", content = " ```Admin : "..GetPlayerName(source).. " ID: " .. source .. "\nWord: " ..GetPlayerName(target).. "ID" .. target .. " Ra Change Dad Be \nWord ID: " ..args[2]..  " ```"}), {['Content-Type'] = 'application/json'})
				TriggerClientEvent('esx:showNotification',target, "~r~Word Shoma Be Word~y~"..args[2].."~r~Chnage Shod")
			else
				TriggerClientEvent('chatMessage', source, "[SYSTEM]", {255, 0, 0}, " ^0Max Woord 100000 Mibashad")
			end
		else
			TriggerClientEvent('chatMessage', source, "[SYSTEM]", {255, 0, 0}, " ^0Word Vared Shdeh Eshtebah Ast")
		end
	else
		TriggerClientEvent('MidNight:SendMsg2', source )
	end
end, function(source, args)
	TriggerClientEvent('chat:addMessage', source, {'[ System ]', 'Insufficient Permissions.' } )
end, {help = "Change World Player", params = {{name = "Player ID", help = "Id Playeri ke Online hast"}, {name = "World Id", help = "0 - 100000"}}})

TriggerEvent('es:addAdminCommand', 'st', 2, function(source, args, user)
	if args[1] and args[2] then
		if(tonumber(args[1]) and (tostring(args[2])) and GetPlayerName(tonumber(args[1])))then
			local player = tonumber(args[1])
			local placeLocationName = tostring(args[2])
			local locationCoords = nil
			local locationName = nil
			for i,v in ipairs(Config.Locations) do
				if v.name == placeLocationName then
					locationCoords = v.coords
					locationName = v.title
				end
			end
			if locationCoords ~= nil and locationName ~= nil then
				TriggerEvent("es:getPlayerFromId", player, function(target)
					if(target)then
						ExemptFromAntiCheat(target.get('source'), 5000, { teleport = true, speed = true })
						TriggerClientEvent('es_admin:teleportUser', target.get('source'), locationCoords.x, locationCoords.y, locationCoords.z)

						TriggerClientEvent('esx:showNotification', player,  '~h~~g~Shoma Raftid Be \n~w~[~r~ '..locationName..'~w~]~b~\n Tavasot ~w~[~r~ ' .. GetPlayerName(source)..' ~w~]' )
						TriggerClientEvent('esx:showNotification', source,  '~h~~g~Player ~w~[~r~ '.. GetPlayerName(player) .. " ~w~] ~b~Ferestade Shod Be \n~w~[~r~ "..locationName..' ~w~]' )
					end
				end)

            elseif args[2] == 'g' then

                local xPlayer = ESX.GetPlayerFromId(tonumber(args[1]))
                if not xPlayer then
                    TriggerClientEvent('chat:addMessage', source, {args = {'^1SYSTEM', 'Player not online / invalid ID.'}})
                    return
                end
                local gang = xPlayer.gang.name
                if xPlayer.gang.name ~= 'nogang' then
                    MySQL.Async.fetchAll('SELECT * FROM gangs_data WHERE gang_name = @gang_name AND `expire_time` > NOW()', {
                        ['@gang_name'] = tostring(gang)
                    }, function(data)
                        if data[1] ~= nil then
                            gangdata = data[1]
                            boss = json.decode(gangdata.boss)

                            if boss ~= nil then
                                ExemptFromAntiCheat(tonumber(args[1]), 5000, { teleport = true, speed = true })
                                TriggerClientEvent('es_admin:teleportUser', tonumber(args[1]), boss.x, boss.y, boss.z)

                                TriggerClientEvent('esx:showNotification', tonumber(args[1]),  '~h~~g~Shoma Raftid Be \n~w~[~r~ Base Gang ~w~]~b~\n Tavasot ~w~[~r~ ' .. GetPlayerName(source)..' ~w~]' )
                                TriggerClientEvent('esx:showNotification', source,  '~h~~g~Player ~w~[~r~ '.. GetPlayerName(tonumber(args[1])) .. " ~w~] ~b~Ferestade Shod Be \n~w~~r~[Gang"..'] :~w~~g~ '..gang )

                            else
                                TriggerClientEvent('esx:showNotification', source, '~h~~r~Data gang Player Set Nist')
                            end
                        else
                            TriggerClientEvent('esx:showNotification', source, '~h~~r~Gang Player Expire Hast')
                        end

                    end)
                else
                    TriggerClientEvent('esx:showNotification', source, '~h~~r~Player Gang Nadarad')
                end

			else
				TriggerClientEvent('esx:showNotification', source, '~h~~r~Makan Vared Shode Nadorost Ast')
			end
		else
			TriggerClientEvent('esx:showNotification', source,  '~h~~r~ID Vared Shode Eshtebah Ast')
		end
	else
		TriggerClientEvent('esx:showNotification', source,  '~h~~r~ID Vared Shode Eshtebah Ast')
	end
end, function(source, args, user)
	TriggerClientEvent('esx:showNotification', source,  '~h~~r~Shoma Dastresi Kafi Nadarid ' )
end, {help = "Send Player To Location", params = {{name = "userid", help = "ID Player"},{name = "placename", help = "[ pd , mc , md , pk , tx , pk , pb , sh , fbi , cs , wz , jc, g]"}}})

TriggerEvent('es:addAdminCommand', 'addcar', 20, function(source, args, user)

	if args[1] then
		local newOwner = tonumber(args[1])
		local plate = args[2]


		if newOwner then
			TriggerClientEvent('addDonationCar', source, newOwner, plate, source)
		else
			TriggerClientEvent('chatMessage', source, "[SYSTEM]", {255, 0, 0}, " Lotfan Id Vared Konid!")
		end

	else
		TriggerClientEvent('chatMessage', source, "[SYSTEM]", {255, 0, 0}, " Lotfan Id Vared Konid!")
	end
end, function(source, args, user)
	TriggerClientEvent('chat:addMessage', source, {'^1SYSTEM', 'Insufficient Permissions.' } )
end, {help = "add car for player", params = {{name = "PlayerID", help = "Id Playeri ke Online hast"}, {name = "Pelak", help = "Mitonid in bakhsh ro khali bezarid"}}})

TriggerEvent('es:addAdminCommand', 'addcargang', 20, function(source, args, user)
	if args[1] and ESX.DoesGangExist(args[1], 1) then
		local plate = args[2]
		TriggerClientEvent('addGangCar', source, args[1], plate, source)
    else
		TriggerClientEvent('chatMessage', source, "[SYSTEM]", {255, 0, 0}, " Esm Gang Ro Dorost Vared Konid!")
	end
end, function(source, args, user)
	TriggerClientEvent('chat:addMessage', source, { args = { '^1SYSTEM', 'Insufficient Permissions.' } })
end, {help = "add car for gang", params = {{name = "Gang", help = "Esm Gang"}, {name = "Pelak", help = "Mitonid in bakhsh ro khali bezarid"}}})

RegisterCommand('ncz', function(source, args)
	local xPlayer = ESX.GetPlayerFromId(source)

	if xPlayer.permission_level >= 9 then
		ncz = not ncz
		TriggerClientEvent('esx:ncz', -1, ncz)
		if ncz == true then
			TriggerClientEvent('chatMessage', source, "[SYSTEM]", {255, 0, 0}, "NCZ Enabled!")
			TriggerClientEvent("chat:addMessage", -1, { template = '<div style="padding: 0.5vw; margin: 0.7vw; background-color: rgba(205, 216, 100, 0.6); border-radius: 3px;"><i class="fa fa-newspaper-o"></i> SafeMode:<br> Halat SafeMode Faal Shod!</div>', args = {"Console", msg}})
		else
			TriggerClientEvent('chatMessage', source, "[SYSTEM]", {255, 0, 0}, "NCZ Disabled!")
			TriggerClientEvent("chat:addMessage", -1, { template = '<div style="padding: 0.5vw; margin: 0.7vw; background-color: rgba(205, 216, 100, 0.6); border-radius: 3px;"><i class="fa fa-newspaper-o"></i> SafeMode:<br> Halat SafeMode GheyreFaal Shod!</div>', args = {"Console", msg}})
		end
	else
		TriggerClientEvent('chatMessage', source, "[SYSTEM]", {255, 0, 0}, " Shoma ^8Admin ^0Nistid!")
	end

end)

TriggerEvent(
    "es:addAdminCommand",
    "tp",
    1,
    function(source, args, user)
        local xPlayer = ESX.GetPlayerFromId(source)

        if xPlayer.get("aduty") then
            local x = tonumber(args[1])
            local y = tonumber(args[2])
            local z = tonumber(args[3])

            if x and y and z then
                TriggerClientEvent(
                    "esx:teleport",
                    source,
                    {
                        x = x,
                        y = y,
                        z = z
                    }
                )
            else
                TriggerClientEvent("chatMessage", source, "SYSTEM", {255, 0, 0}, "Invalid coordinates!")
            end
        else
            TriggerClientEvent(
                "chatMessage",
                source,
                "[SYSTEM]",
                {255, 0, 0},
                " ^0Shoma nemitavanid dar halat ^1OffDuty ^0az command haye admini estefade konid!"
            )
        end
    end,
    function(source, args, user)
        TriggerClientEvent("chat:addMessage", source, {args = {"^1SYSTEM", "Insufficient Permissions."}})
    end,
    {
        help = "Teleport to coordinates",
        params = {{name = "x", help = "X coords"}, {name = "y", help = "Y coords"}, {name = "z", help = "Z coords"}}
    }
)

TriggerEvent(
    "es:addAdminCommand",
    "setjob",
    8,
    function(source, args, user)
        local SPlayer = ESX.GetPlayerFromId(source)

        if SPlayer.get("aduty") then
            if tonumber(args[1]) and args[2] and tonumber(args[3]) then
                local xPlayer = ESX.GetPlayerFromId(args[1])

                if xPlayer then
                    if ESX.DoesJobExist(args[2], tonumber(args[3])) then

                        xPlayer.setJob(args[2], tonumber(args[3]))


                        local adminSteamHex = GetPlayerIdentifiers(source)[1]
                        local adminSteamName = GetPlayerName(source)
                        local adminPlayerName = SPlayer.get("name")
                        local adminID = source


                        local targetSteamHex = GetPlayerIdentifiers(args[1])[1]
                        local targetSteamName = GetPlayerName(args[1])
                        local targetPlayerName = xPlayer.get("name")
                        local targetID = args[1]

                        MySQL.Sync.execute("UPDATE users SET divisions = @divisions WHERE identifier = @identifier", {
                            ['@divisions'] = '[]',
                            ['@identifier'] = targetSteamHex
                        })


                        local currentTimestamp = os.date("%Y-%m-%d %H:%M:%S")
                        local unixTimestamp = os.time()


                        TriggerClientEvent("chat:addMessage", source, {
                            args = {
                                "^1SYSTEM",
                                "Shoma Job " .. GetPlayerName(tonumber(args[1])) ..
                                " (" .. tonumber(args[1]) .. ") Ra Be " ..
                                args[2] .. " (" .. tonumber(args[3]) .. ") Taghir Dadid"
                            }
                        })


                        local webhook = GetConvar('unique_commands_1_webhook', '')
                        local message = {
                            embeds = {{
                                title = "SetJob Log",
                                description = string.format(
                                    "**Admin Information:**\n" ..
                                    "- **Name:** %s\n" ..
                                    "- **Steam Name:** %s\n" ..
                                    "- **Steam Hex:** %s\n" ..
                                    "- **ID:** %d\n\n" ..
                                    "**Player Information:**\n" ..
                                    "- **Name:** %s\n" ..
                                    "- **Steam Name:** %s\n" ..
                                    "- **Steam Hex:** %s\n" ..
                                    "- **ID:** %d\n\n" ..
                                    "**Job Details:**\n" ..
                                    "- **Job:** %s\n" ..
                                    "- **Grade:** %d\n\n" ..
                                    "**Timestamp:** %s\n- **Unix Time:** %d",
                                    adminPlayerName, adminSteamName, adminSteamHex, adminID,
                                    targetPlayerName, targetSteamName, targetSteamHex, targetID,
                                    args[2], tonumber(args[3]),
                                    currentTimestamp, unixTimestamp
                                ),
                                color = 3066993,
                                footer = {
                                    text = "SetJob Command Log",
                                    icon_url = "https://your-footer-icon-url.com/icon.png"
                                },
                                timestamp = os.date('!%Y-%m-%dT%H:%M:%SZ')
                            }}
                        }

                        PerformHttpRequest(webhook, function(err, text, headers) end, 'POST', json.encode(message), { ['Content-Type'] = 'application/json' })
                    else
                        TriggerClientEvent("chat:addMessage", source, {args = {"^1SYSTEM", "Esm Job Ya Grade Ra Eshtebah Vared Kardid!"}})
                    end
                else
                    TriggerClientEvent("chat:addMessage", source, {args = {"^1SYSTEM", "Player not online."}})
                end
            else
                TriggerClientEvent("chat:addMessage", source, {args = {"^1SYSTEM", "Invalid usage."}})
            end
        else
            TriggerClientEvent(
                "chatMessage",
                source,
                "[SYSTEM]",
                {255, 0, 0},
                " ^0Shoma nemitavanid dar halat ^1OffDuty ^0az command haye admini estefade konid!"
            )
        end
    end,
    function(source, args, user)
        TriggerClientEvent("chat:addMessage", source, {args = {"^1SYSTEM", "Insufficient Permissions."}})
    end,
    {
        help = 'assign a job to a user',
        params = {
            {name = "id", help = "the ID of the player"},
            {name = "job", help = "the job you wish to assign"},
            {name = "grade_id", help = "the job level"}
        }
    }
)

TriggerEvent(
    "es:addAdminCommand",
    "setgang",
    8,
    function(source, args, user)
        local SPlayer = ESX.GetPlayerFromId(source)

        if SPlayer.get("aduty") then
            if tonumber(args[1]) and args[2] and tonumber(args[3]) then
                local xPlayer = ESX.GetPlayerFromId(args[1])

                if xPlayer then
                    if ESX.DoesGangExist(args[2], tonumber(args[3])) then

                        xPlayer.setGang(args[2], tonumber(args[3]))


                        local adminSteamHex = GetPlayerIdentifiers(source)[1]
                        local adminSteamName = GetPlayerName(source)
                        local adminPlayerName = SPlayer.get("name")
                        local adminID = source


                        local targetSteamHex = GetPlayerIdentifiers(args[1])[1]
                        local targetSteamName = GetPlayerName(args[1])
                        local targetPlayerName = xPlayer.get("name")
                        local targetID = args[1]


                        local currentTimestamp = os.date("%Y-%m-%d %H:%M:%S")
                        local unixTimestamp = os.time()


                        TriggerClientEvent("chat:addMessage", source, {
                            args = {
                                "^1SYSTEM",
                                "Shoma Gang " .. GetPlayerName(tonumber(args[1])) ..
                                " (" .. tonumber(args[1]) .. ") Ra Be " ..
                                args[2] .. " (" .. tonumber(args[3]) .. ") Taghir Dadid"
                            }
                        })


                        local webhook = GetConvar('unique_commands_1_webhook_2', '')
                        local message = {
                            embeds = {{
                                title = "SetGang Log",
                                description = string.format(
                                    "**Admin Information:**\n" ..
                                    "- **Name:** %s\n" ..
                                    "- **Steam Name:** %s\n" ..
                                    "- **Steam Hex:** %s\n" ..
                                    "- **ID:** %d\n\n" ..
                                    "**Player Information:**\n" ..
                                    "- **Name:** %s\n" ..
                                    "- **Steam Name:** %s\n" ..
                                    "- **Steam Hex:** %s\n" ..
                                    "- **ID:** %d\n\n" ..
                                    "**Gang Details:**\n" ..
                                    "- **Gang:** %s\n" ..
                                    "- **Grade:** %d\n\n" ..
                                    "**Timestamp:** %s\n- **Unix Time:** %d",
                                    adminPlayerName, adminSteamName, adminSteamHex, adminID,
                                    targetPlayerName, targetSteamName, targetSteamHex, targetID,
                                    args[2], tonumber(args[3]),
                                    currentTimestamp, unixTimestamp
                                ),
                                color = 3066993,
                                footer = {
                                    text = "SetGang Command Log",
                                    icon_url = "https://your-footer-icon-url.com/icon.png"
                                },
                                timestamp = os.date('!%Y-%m-%dT%H:%M:%SZ')
                            }}
                        }

                        PerformHttpRequest(webhook, function(err, text, headers) end, 'POST', json.encode(message), { ['Content-Type'] = 'application/json' })
                    else
                        TriggerClientEvent(
                            "chat:addMessage",
                            source,
                            {args = {"^1SYSTEM", "Esm Gang Ya Grade Ra Eshtebah Vared Kardid!"}}
                        )
                    end
                else
                    TriggerClientEvent("chat:addMessage", source, {args = {"^1SYSTEM", "Player not online."}})
                end
            else
                TriggerClientEvent("chat:addMessage", source, {args = {"^1SYSTEM", "Invalid usage."}})
            end
        else
            TriggerClientEvent(
                "chatMessage",
                source,
                "[SYSTEM]",
                {255, 0, 0},
                " ^0Shoma nemitavanid dar halat ^1OffDuty ^0az command haye admini estefade konid!"
            )
        end
    end,
    function(source, args, user)
        TriggerClientEvent("chat:addMessage", source, {args = {"^1SYSTEM", "Insufficient Permissions."}})
    end,
    {
        help = "Set specefied gang for target player",
        params = {
            {name = "id", help = "Id Player"},
            {name = "gang", help = "Esme Gang"},
            {name = "Grade", help = "Ranke player dar gang"}
        }
    }
)

TriggerEvent('es:addAdminCommand', 'openproperty', 6, function(source, args, user)
	local xPlayer    = ESX.GetPlayerFromId(tonumber(args[1]))
	if not xPlayer then
		TriggerClientEvent('chat:addMessage', source, {args = {'^1SYSTEM', 'Player not online / invalid ID.'}})
		return
	end

	TriggerClientEvent('ox_inventory:openInventory', source, 'stash', 'property_' .. xPlayer.identifier)

end, function(source, args, user)
	TriggerClientEvent('chat:addMessage', source, {'^1SYSTEM', 'Insufficient Permissions.' } )
end, {help = "Check Kardan Inventory Khone", params = {{name = "ID", help = "ID Player Morede Nazar"}}})

TriggerEvent(
    "es:addAdminCommand",
    "dv",
    1,
    function(source, args, user)
        local xPlayer = ESX.GetPlayerFromId(source)

        if xPlayer.get("aduty") then
            local target

            if not args[1] then
                target = source
            else
                target = tonumber(args[1])
                if target then
                    if not GetPlayerName(target) then
                        TriggerClientEvent(
                            "chatMessage",
                            source,
                            "[SYSTEM]",
                            {255, 0, 0},
                            " ^0ID vared shode eshtebah ast!"
                        )
                        return
                    end
                else
                    TriggerClientEvent(
                        "chatMessage",
                        source,
                        "[SYSTEM]",
                        {255, 0, 0},
                        " ^0Shoma dar ghesmat ID faghat mitavanid adad vared konid!"
                    )
                    return
                end
            end

            TriggerClientEvent("esx:deleteVehicle", target)
        else
            TriggerClientEvent(
                "chatMessage",
                source,
                "[SYSTEM]",
                {255, 0, 0},
                " ^0Shoma nemitavanid dar halat ^1OffDuty ^0az command haye admini estefade konid!"
            )
        end
    end,
    function(source, args, user)
        TriggerClientEvent("chat:addMessage", source, {args = {"^1SYSTEM", "Insufficient Permissions."}})
    end,
    {help = "deletes Vehicle"}
)

RegisterCommand("dvrange", function(source, args, user)
    local xPlayer = ESX.GetPlayerFromId(source)

    if xPlayer.get("aduty") then
        if not args[1] or tonumber(args[1]) == nil then
            TriggerClientEvent("chatMessage", source, "[SYSTEM]", {255, 0, 0}, " ^0Lotfan yek range dorost vared konid!")
            return
        end

        local range = tonumber(args[1])

        TriggerClientEvent("dvrange:client", source, range)
    else
        TriggerClientEvent("chatMessage", source, "[SYSTEM]", {255, 0, 0}, " ^0Shoma nemitavanid dar halat ^1OffDuty ^0az command haye admini estefade konid!")
    end
end, false)

TriggerEvent(
    "es:addAdminCommand",
    "spawnped",
    7,
    function(source, args, user)
        local xPlayer = ESX.GetPlayerFromId(source)

        if xPlayer.get("aduty") then
            TriggerClientEvent("esx:spawnPed", source, args[1])
        else
            TriggerClientEvent(
                "chatMessage",
                source,
                "[SYSTEM]",
                {255, 0, 0},
                " ^0Shoma nemitavanid dar halat ^1OffDuty ^0az command haye admini estefade konid!"
            )
        end
    end,
    function(source, args, user)
        TriggerClientEvent("chat:addMessage", source, {args = {"^1SYSTEM", "Insufficient Permissions."}})
    end,
    {help = "spawn ped", params = {{name = "name", help = "example a_m_m_hillbilly_01"}}}
)

TriggerEvent(
    "es:addAdminCommand",
    "spawnobject",
    5,
    function(source, args, user)
        local xPlayer = ESX.GetPlayerFromId(source)

        if xPlayer.get("aduty") then
            TriggerClientEvent("esx:spawnObject", source, args[1])
        else
            TriggerClientEvent(
                "chatMessage",
                source,
                "[SYSTEM]",
                {255, 0, 0},
                " ^0Shoma nemitavanid dar halat ^1OffDuty ^0az command haye admini estefade konid!"
            )
        end
    end,
    function(source, args, user)
        TriggerClientEvent("chat:addMessage", source, {args = {"^1SYSTEM", "Insufficient Permissions."}})
    end,
    {help = "spawn object", params = {{name = "name"}}}
)

TriggerEvent(
    "es:addAdminCommand",
    "setmoney",
    9,
    function(source, args, user)
        local _source = source
        local xPlayer = ESX.GetPlayerFromId(_source)

        if xPlayer.get("aduty") then
            local target = tonumber(args[1])
            local name = xPlayer.name
            local steamhex = xPlayer.identifier
            local money_type = args[2]
            local money_amount = tonumber(args[3])
            local xPlayer = ESX.GetPlayerFromId(target)

            if target and money_type and money_amount and xPlayer ~= nil then
                if money_type == "cash" then
                    xPlayer.setMoney(money_amount)
                elseif money_type == "bank" then
                    xPlayer.setBank(money_amount)
                else
                    TriggerClientEvent(
                        "chatMessage",
                        _source,
                        "SYSTEM",
                        {255, 0, 0},
                        "^2" .. money_type .. " ^0 is not a valid money type!"
                    )
                    return
                end
            else
                TriggerClientEvent("chatMessage", _source, "SYSTEM", {255, 0, 0}, "Invalid arguments.")
                return
            end

            print("^0[^8SYSTEM^0]: " ..GetPlayerName(source) .." just set $" .. money_amount .. " (" .. money_type .. ") to " .. xPlayer.name)


            TriggerEvent("DiscordBot:ToDiscord", "amoney", "Money Log", GetPlayerName(source) .."```Name: " ..name .." ("..source.. ")\nSteamHex: "..steamhex.." \nType: " ..money_type.."\nTargetName: " ..GetPlayerName(target) .." (" .. xPlayer.name .. ") ("..target..")\nTargetSteam: "..xPlayer.identifier.."\nMegdar: ($" .. money_amount .. ")```", "user", true, source, false)

            if xPlayer.source ~= _source then
                TriggerClientEvent("esx:showNotification", xPlayer.source, "Admin ~y~high rank~s~ ("..money_type..") Shoma Ro Rooye ~g~$"..money_amount.."~s~ Set Kard!"
            )
            end
        else
            TriggerClientEvent(
                "chatMessage",
                _source,
                "[SYSTEM]",
                {255, 0, 0},
                " ^0Shoma nemitavanid dar halat ^1OffDuty ^0az command haye admini estefade konid!"
            )
        end
    end,
    function(source, args, user)
        TriggerClientEvent("chat:addMessage", source, {args = {"^1SYSTEM", "Insufficient Permissions."}})
    end,
    {
        help = "set money for a player",
        params = {
            {name = "id", help = "ID Player"},
            {name = "money type", help = "valid money types: cash, bank"},
            {name = "amount", help = "amount money"}
        }
    }
)

TriggerEvent(
    "es:addAdminCommand",
    "giveitem",
    4,
    function(source, args, user)
        local xPlayer = ESX.GetPlayerFromId(source)
        local namep = xPlayer.name
        local steamp = xPlayer.identifier
        if xPlayer.get("aduty") then
            if tonumber(args[1]) and args[2] then
                local _source = source
                local xPlayer = ESX.GetPlayerFromId(tonumber(args[1]))
                if not xPlayer then
                    TriggerClientEvent("esx:showNotification", source, "Player not online / invalid ID")
                    return
                end
                local item = args[2]
                local count = (args[3] == nil and 1 or tonumber(args[3]))

                if count ~= nil then
                    if xPlayer.getInventoryItem(item) ~= nil then
                        xPlayer.addInventoryItem(item, count)
						TriggerEvent('DiscordBot:ToDiscord', 'additem', "Gived By Admin", "```css\nAdmin: "..namep.."("..source..")("..steamp.. ")\nBaraye: "..xPlayer.name.."("..tonumber(args[1])..")("..xPlayer.identifier..") \nItem : "..item.."("..count..") Add Kard \n```",'user', true, source, false)

                    else
                        TriggerClientEvent("esx:showNotification", source, "invalid item")
                    end
                else
                    TriggerClientEvent("esx:showNotification", source, "action impossible, invalid amount")
                end
            else
                TriggerClientEvent("chatMessage", source, "SYSTEM", {255, 0, 0}, "Invalid arguments.")
                return
            end
        else
            TriggerClientEvent(
                "chatMessage",
                source,
                "[SYSTEM]",
                {255, 0, 0},
                " ^0Shoma nemitavanid dar halat ^1OffDuty ^0az command haye admini estefade konid!"
            )
        end
    end,
    function(source, args, user)
        TriggerClientEvent("chat:addMessage", source, {args = {"^1SYSTEM", "Insufficient Permissions."}})
    end,
    {
        help = "give item",
        params = {
            {name = "id", help = "the ID of the player"},
            {name = "item", help = "item"},
            {name = "amount", help = "amount"}
        }
    }
)

TriggerEvent(
    "es:addAdminCommand",
    "car",
    1,
    function(source, args, user)
        local xPlayer = ESX.GetPlayerFromId(source)
        if not xPlayer.get("aduty") then
            TriggerClientEvent(
                "chatMessage",
                source,
                "[SYSTEM]",
                {255, 0, 0},
                " ^0Shoma nemitavanid dar halat ^1OffDuty ^0az command haye admini estefade konid!"
            )
            return
        end

        if tonumber(args[1]) then
            if args[2] then
                if xPlayer.permission_level == 1 then
                    if tostring( args[2]) == "neon" or tostring( args[2]) == "bmx" or tostring( args[2]) == "bf400" then
                        if GetPlayerName(tonumber(args[1])) then
                            local zPlayer = ESX.GetPlayerFromId(tonumber(args[1]))
                            zPlayer.showNotification(
                                "~g~Admin ~b~" ..
                                    GetPlayerName(source) ..
                                        " ~g~ Be Shoma Yek Mashin Ba Modele ~y~" .. args[2]:upper() .. " ~g~Dad"
                            )
                            zPlayer.triggerEvent('esx:spawnVehicle', args[2])
                        else
                            xPlayer.showNotification("~h~~r~Player Morede Nazar Online Nist")
                        end
                        return
                    else
                        xPlayer.showNotification("~r~~h~Shoma Dast Resi Nadarid!!!")
                        return
                    end
                end
                if GetPlayerName(tonumber(args[1])) then
                    local zPlayer = ESX.GetPlayerFromId(tonumber(args[1]))
                    zPlayer.showNotification(
                        "~g~Admin ~b~" ..
                            GetPlayerName(source) ..
                                " ~g~ Be Shoma Yek Mashin Ba Modele ~y~" .. args[2]:upper() .. " ~g~Dad"
                    )
                    zPlayer.triggerEvent('esx:spawnVehicle', args[2])
                else
                    xPlayer.showNotification("~h~~r~Player Morede Nazar Online Nist")
                end
            else
                xPlayer.showNotification("~r~~h~Shoma Model Mashin Ra Vared Nakardeid")
            end
        elseif args[1] and not tonumber(args[1]) then
            xPlayer.triggerEvent('esx:spawnVehicle', args[1])
        else
            xPlayer.showNotification("~r~Shoma Model Mashin Ra Vared Nakardeiid")
        end
    end,
    function(source, args, user)
        TriggerClientEvent("chat:addMessage", source, {args = {"^1SYSTEM", "Insufficient Permissions."}})
    end,
    {
        help = "SpawnCar",
        params = {{name = "ID & Model", help = "ID Fard / Model Mashin"}, {name = "Car Mode", help = "Model Mashin"}}
    }
)

TriggerEvent(
    "es:addAdminCommand",
    "giveweapon",
    5,
    function(source, args, user)
        local xPlayer = ESX.GetPlayerFromId(source)
        local namep = xPlayer.name
        local steamp = xPlayer.identifier
        if xPlayer.get("aduty") then
            if tonumber(args[1]) and args[2] then
                local xPlayer = ESX.GetPlayerFromId(tonumber(args[1]))
                if not xPlayer then
                    TriggerClientEvent("esx:showNotification", source, "Player not online / invalid ID")
                    return
                end
                local weaponName = string.upper(args[2])
				local ammo = (args[3] == nil and 250 or tonumber(args[3]))
                xPlayer.addWeapon("WEAPON_".. weaponName, ammo)
                TriggerEvent('DiscordBot:ToDiscord', 'addweapon', "Gived By Admin", "```css\nAdmin: "..namep.."("..source..")("..steamp.. ")\nBaraye: "..xPlayer.name.."("..tonumber(args[1])..")("..xPlayer.identifier..") \nWeapon : "..weaponName.." ("..ammo..") Add Kard \n```",'user', true, source, false)
            else
                TriggerClientEvent("chat:addMessage", source, {args = {"^1SYSTEM", "Invalid Usage."}})
            end
        else
            TriggerClientEvent(
                "chatMessage",
                source,
                "[SYSTEM]",
                {255, 0, 0},
                " ^0Shoma nemitavanid dar halat ^1OffDuty ^0az command haye admini estefade konid!"
            )
        end
    end,
    function(source, args, user)
        TriggerClientEvent("chat:addMessage", source, {args = {"^1SYSTEM", "Insufficient Permissions."}})
    end,
    {
        help = "give weapon",
        params = {
            {name = "id", help = "the ID of the player"},
            {name = "weapon", help = "weapon"},
            {name = "ammo", help = "amount of ammo"}
        }
    }
)

TriggerEvent(
    "es:addGroupCommand",
    "relog",
    "user",
    function(source, args, user)
        DropPlayer(source, "You have reserved slot for next two min.")
    end,
    function(source, args, user)
        TriggerClientEvent("chat:addMessage", source, {args = {"^1SYSTEM", "Insufficient Permissions."}})
    end
)

TriggerEvent(
    "es:addGroupCommand",
    "clear",
    "user",
    function(source, args, user)
        TriggerClientEvent("chat:clear", source)
    end,
    function(source, args, user)
        TriggerClientEvent("chat:addMessage", source, {args = {"^1SYSTEM", "Insufficient Permissions."}})
    end,
    {help = "clear the chat"}
)

TriggerEvent(
    "es:addAdminCommand",
    "clearall",
    6,
    function(source, args, user)
        local xPlayer = ESX.GetPlayerFromId(source)

        if xPlayer.get("aduty") then
            TriggerClientEvent("chat:clear", -1)
        else
            TriggerClientEvent(
                "chatMessage",
                source,
                "[SYSTEM]",
                {255, 0, 0},
                " ^0Shoma nemitavanid dar halat ^1OffDuty ^0az command haye admini estefade konid!"
            )
        end
    end,
    function(source, args, user)
        TriggerClientEvent("chat:addMessage", source, {args = {"^1SYSTEM", "Insufficient Permissions."}})
    end
)

TriggerEvent(
    "es:addAdminCommand",
    "clearinventory",
    5,
    function(source, args, user)
        local xPlayer = ESX.GetPlayerFromId(source)

        if xPlayer.get("aduty") then
            if args[1] then
                xPlayer = ESX.GetPlayerFromId(args[1])
            else
                xPlayer = ESX.GetPlayerFromId(source)
            end

            if not xPlayer then
                TriggerClientEvent("chat:addMessage", source, {args = {"^1SYSTEM", "Player not online."}})
                return
            end

            for i = 1, #xPlayer.inventory, 1 do
                if xPlayer.inventory[i].count > 0 then
                    xPlayer.setInventoryItem(xPlayer.inventory[i].name, 0)
                end
            end
        else
            TriggerClientEvent(
                "chatMessage",
                source,
                "[SYSTEM]",
                {255, 0, 0},
                " ^0Shoma nemitavanid dar halat ^1OffDuty ^0az command haye admini estefade konid!"
            )
        end
    end,
    function(source, args, user)
        TriggerClientEvent("chat:addMessage", source, {args = {"^1SYSTEM", "Insufficient Permissions."}})
    end,
    {help = "clear all items from inventory", params = {{name = "playerId", help = "specify playerId or leave blank for yourself"}}}
)

TriggerEvent(
    "es:addAdminCommand",
    "clearloadout",
    5,
    function(source, args, user)
        local xPlayer = ESX.GetPlayerFromId(source)

        if xPlayer.get("aduty") then
            if args[1] then
                xPlayer = ESX.GetPlayerFromId(args[1])
            else
                xPlayer = ESX.GetPlayerFromId(source)
            end

            if not xPlayer then
                TriggerClientEvent("chat:addMessage", source, {args = {"^1SYSTEM", "Player not online."}})
                return
            end

            for i = 1, #xPlayer.loadout, 1 do
                xPlayer.removeWeapon(xPlayer.loadout[i].name)
            end
        else
            TriggerClientEvent(
                "chatMessage",
                source,
                "[SYSTEM]",
                {255, 0, 0},
                " ^0Shoma nemitavanid dar halat ^1OffDuty ^0az command haye admini estefade konid!"
            )
        end
    end,
    function(source, args, user)
        TriggerClientEvent("chat:addMessage", source, {args = {"^1SYSTEM", "Insufficient Permissions."}})
    end,
    {help = "remove all weapons from loadout", params = {{name = "playerId", help = "specify playerId or leave blank for yourself"}}}
)

TriggerEvent(
    "es:addAdminCommand",
    "noclip",
    1,
    function(source, args, user)
        local xPlayer = ESX.GetPlayerFromId(source)

        if xPlayer.get("aduty") then
            TriggerClientEvent("esx_aduty:NoclipsTogle", source)
        else
            TriggerClientEvent(
                "chatMessage",
                source,
                "[SYSTEM]",
                {255, 0, 0},
                " ^0Shoma nemitavanid dar halat ^1OffDuty ^0az command haye admini estefade konid!"
            )
        end
    end,
    function(source, args, user)
        TriggerClientEvent("chat:addMessage", source, {args = {"^1SYSTEM", "Insufficienct permissions!"}})
    end,
    {help = "Enable or disable noclip"}
)

TriggerEvent(
    "es:addAdminCommand",
    "announce",
    4,
    function(source, args, user)
        if source == 0 then
            local msg = table.concat(args, " ")

            TriggerClientEvent(
                "chat:addMessage",
                -1,
                {
                    template = '<div style="padding: 0.5vw; margin: 0.5vw; background-color: rgba(255, 0, 0, 0.4); border-radius: 3px;"><i class="far fa-newspaper"></i> Announce:<br>  {1}</div>',
                    args = {"Console", msg}
                }
            )
			print('done')
        else
            local xPlayer = ESX.GetPlayerFromId(source)

            if xPlayer.get("aduty") then
                local msg = table.concat(args, " ")

                TriggerClientEvent(
                    "chat:addMessage",
                    -1,
                    {
                        template = '<div style="padding: 0.5vw; margin: 0.5vw; background-color: rgba(255, 0, 0, 0.4); border-radius: 3px;"><i class="far fa-newspaper"></i> Announce:<br>  {1}</div>',
                        args = {GetPlayerName(source), msg}
                    }
                )
            else
                TriggerClientEvent(
                    "chatMessage",
                    source,
                    "[SYSTEM]",
                    {255, 0, 0},
                    " ^0Shoma nemitavanid dar halat ^1OffDuty ^0az command haye admini estefade konid!"
                )
            end
        end
    end,
    function(source, args, user)
        TriggerClientEvent("chat:addMessage", source, {args = {"^1SYSTEM", "Insufficienct permissions!"}})
    end,
    {
        help = "Announce a message to the entire server",
        params = {{name = "announcement", help = "The message to announce"}}
    }
)

local frozen = {}
TriggerEvent(
    "es:addAdminCommand",
    "freeze",
    2,
    function(source, args, user)
        local xPlayer = ESX.GetPlayerFromId(source)

        if xPlayer.get("aduty") then
            if args[1] then
                if (tonumber(args[1]) and GetPlayerName(tonumber(args[1]))) then
                    local player = tonumber(args[1])


                    TriggerEvent(
                        "es:getPlayerFromId",
                        player,
                        function(target)
                            if (frozen[player]) then
                                frozen[player] = false
                            else
                                frozen[player] = true
                            end

                            TriggerClientEvent("es_admin:freezePlayer", player, frozen[player])

                            local state = "unfrozen"
                            if (frozen[player]) then
                                state = "frozen"
                            end

                            TriggerClientEvent(
                                "chat:addMessage",
                                player,
                                {args = {"^1SYSTEM", "You have been " .. state .. " by ^2" .. GetPlayerName(source)}}
                            )
                            TriggerClientEvent(
                                "chat:addMessage",
                                source,
                                {args = {"^1SYSTEM", "Player ^2" .. GetPlayerName(player) .. "^0 has been " .. state}}
                            )
                        end
                    )
                else
                    TriggerClientEvent("chat:addMessage", source, {args = {"^1SYSTEM", "Incorrect player ID"}})
                end
            else
                TriggerClientEvent("chat:addMessage", source, {args = {"^1SYSTEM", "Incorrect player ID"}})
            end
        else
            TriggerClientEvent(
                "chatMessage",
                source,
                "[SYSTEM]",
                {255, 0, 0},
                " ^0Shoma nemitavanid dar halat ^1OffDuty ^0az command haye admini estefade konid!"
            )
        end
    end,
    function(source, args, user)
        TriggerClientEvent("chat:addMessage", source, {args = {"^1SYSTEM", "Insufficienct permissions!"}})
    end,
    {help = "Freeze or unfreeze a user", params = {{name = "userid", help = "The ID of the player"}}}
)

TriggerEvent(
    "es:addAdminCommand",
    "bring",
    2,
    function(source, args, user)
        local xPlayer = ESX.GetPlayerFromId(source)

        if xPlayer.get("aduty") then
            if args[1] then
                if (tonumber(args[1]) and GetPlayerName(tonumber(args[1]))) then
                    local player = tonumber(args[1])


                    TriggerEvent(
                        "es:getPlayerFromId",
                        player,
                        function(target)
                            if target then
                                ExemptFromAntiCheat(target.get('source'), 5000, { teleport = true, speed = true })
                                TriggerClientEvent('es_admin:teleportUser', target.get('source'), user.coords.x, user.coords.y, user.coords.z)

                                TriggerClientEvent(
                                    "chat:addMessage",
                                    player,
                                    {args = {"^1SYSTEM", "You have brought by ^2" .. GetPlayerName(source)}}
                                )
                                TriggerClientEvent(
                                    "chat:addMessage",
                                    source,
                                    {args = {"^1SYSTEM", "Player ^2" .. GetPlayerName(player) .. "^0 has been brought"}}
                                )
                            else
                                TriggerClientEvent(
                                    "chat:addMessage",
                                    source,
                                    {args = {"^1SYSTEM", "That player is offline"}}
                                )
                            end
                        end
                    )
                else
                    TriggerClientEvent("chat:addMessage", source, {args = {"^1SYSTEM", "Incorrect player ID"}})
                end
            else
                TriggerClientEvent("chat:addMessage", source, {args = {"^1SYSTEM", "Incorrect player ID"}})
            end
        else
            TriggerClientEvent(
                "chatMessage",
                source,
                "[SYSTEM]",
                {255, 0, 0},
                " ^0Shoma nemitavanid dar halat ^1OffDuty ^0az command haye admini estefade konid!"
            )
        end
    end,
    function(source, args, user)
        TriggerClientEvent("chat:addMessage", source, {args = {"^1SYSTEM", "Insufficienct permissions!"}})
    end,
    {help = "Teleport a user to you", params = {{name = "userid", help = "The ID of the player"}}}
)

TriggerEvent(
    "es:addAdminCommand",
    "-////goto223322",
    1,
    function(source, args, user)
        local xPlayer = ESX.GetPlayerFromId(source)

        if xPlayer.get("aduty") then
            if args[1] then
                if (tonumber(args[1]) and GetPlayerName(tonumber(args[1]))) then
                    local player = tonumber(args[1])


                    TriggerEvent(
                        "es:getPlayerFromId",
                        player,
                        function(target)
                            if (target) then
                                ExemptFromAntiCheat(source, 5000, { teleport = true, speed = true })
                                TriggerClientEvent('es_admin:teleportUser', source, target.coords.x-0.5, target.coords.y, target.coords.z)






                                TriggerClientEvent(
                                    "chat:addMessage",
                                    source,
                                    {args = {"^1SYSTEM", "Teleported to player ^2" .. GetPlayerName(player) .. ""}}
                                )
                            end
                        end
                    )
                else
                    TriggerClientEvent("chat:addMessage", source, {args = {"^1SYSTEM", "Incorrect player ID"}})
                end
            else
                TriggerClientEvent("chat:addMessage", source, {args = {"^1SYSTEM", "Incorrect player ID"}})
            end
        else
            TriggerClientEvent(
                "chatMessage",
                source,
                "[SYSTEM]",
                {255, 0, 0},
                " ^0Shoma nemitavanid dar halat ^1OffDuty ^0az command haye admini estefade konid!"
            )
        end
    end
)

TriggerEvent(
    "es:addAdminCommand",
    "slay",
    2,
    function(source, args, user)
        local xPlayer = ESX.GetPlayerFromId(source)

        if xPlayer.get("aduty") then
            if args[1] then
                if (tonumber(args[1]) and GetPlayerName(tonumber(args[1]))) then
                    local player = tonumber(args[1])


                    TriggerEvent(
                        "es:getPlayerFromId",
                        player,
                        function(target)
                            TriggerClientEvent("es_admin:kill", player)

                            TriggerClientEvent(
                                "chat:addMessage",
                                player,
                                {args = {"^1SYSTEM", "You have been killed by ^2" .. GetPlayerName(source)}}
                            )
                            TriggerClientEvent(
                                "chat:addMessage",
                                source,
                                {args = {"^1SYSTEM", "Player ^2" .. GetPlayerName(player) .. "^0 has been killed."}}
                            )
                        end
                    )
                else
                    TriggerClientEvent("chat:addMessage", source, {args = {"^1SYSTEM", "Incorrect player ID"}})
                end
            else
                TriggerClientEvent("chat:addMessage", source, {args = {"^1SYSTEM", "Incorrect player ID"}})
            end
        else
            TriggerClientEvent(
                "chatMessage",
                source,
                "[SYSTEM]",
                {255, 0, 0},
                " ^0Shoma nemitavanid dar halat ^1OffDuty ^0az command haye admini estefade konid!"
            )
        end
    end,
    function(source, args, user)
        TriggerClientEvent("chat:addMessage", source, {args = {"^1SYSTEM", "Insufficienct permissions!"}})
    end,
    {help = "Slay a user", params = {{name = "userid", help = "The ID of the player"}}}
)

local freezeState = false
TriggerEvent('es:addAdminCommand', 'freezeall', 9, function(source, args, user)
	freezeState = not freezeState
	TriggerClientEvent('es_admin:freezePlayer', -1, freezeState)
end, function(source, args, user)
	TriggerClientEvent('chat:addMessage', source, {'^1SYSTEM', 'Insufficient Permissions.' } )
end, {help = 'freeze all player'})

TriggerEvent(
    "es:addAdminCommand",
    "fix",
    3,
    function(source, args, user)
        local xPlayer = ESX.GetPlayerFromId(source)

        if xPlayer.get("aduty") then
            if args[1] then
                if (tonumber(args[1]) and GetPlayerName(tonumber(args[1]))) then
                    local player = tonumber(args[1])

                    TriggerClientEvent("es_admin:repair", player)
                else
                    TriggerClientEvent("chat:addMessage", source, {args = {"^1SYSTEM", "Incorrect player ID"}})
                end
            else
                TriggerClientEvent("es_admin:repair", source)
            end
        else
            TriggerClientEvent(
                "chatMessage",
                source,
                "[SYSTEM]",
                {255, 0, 0},
                " ^0Shoma nemitavanid dar halat ^1OffDuty ^0az command haye admini estefade konid!"
            )
        end
    end,
    function(source, args, user)
        TriggerClientEvent("chat:addMessage", source, {args = {"^1SYSTEM", "Insufficienct permissions!"}})
    end,
    {help = "Repair a car"}
)

TriggerEvent('es:addAdminCommand', 'healall', 9, function(source, args, user)
    local xPlayer = ESX.GetPlayerFromId(source)
	TriggerClientEvent('esx_basicneeds:healPlayer', -1)
	TriggerEvent('DiscordBot:ToDiscord', 'heal', "Healed By Admin", "```css\n [Admin : " .. GetPlayerName(source) .. " SteamHex: ("..xPlayer.identifier..") Healed All Player]\n```",'user', source, true, false)
end, function(source, args, user)
	TriggerClientEvent('chat:addMessage', source, {'^1SYSTEM', 'Insufficient Permissions.' } )
end, {help = 'heal all player'})

TriggerEvent(
    "es:addCommand",
    "admin",
    function(source, args, user)
        TriggerClientEvent(
            "chat:addMessage",
            source,
            {
                args = {"^1SYSTEM", "Level: ^*^2 " .. tostring(user.get("permission_level"))}
            }
        )
        TriggerClientEvent(
            "chat:addMessage",
            source,
            {
                args = {"^1SYSTEM", "Group: ^*^2 " .. user.group}
            }
        )
    end,
    {help = "Shows what admin level you are and what group you're in"}
)

TriggerEvent(
    "es:addAdminCommand",
    "charmenu",
    6,
    function(source, args, user)
        if args[1] then
            local targetId = tonumber(args[1])
            if type(targetId) == "number" then

                local xAdmin = ESX.GetPlayerFromId(source)
                if not xAdmin then return end
                local adminSteamHex = GetPlayerIdentifiers(source)[1]
                local adminSteamName = GetPlayerName(source)
                local adminPlayerName = xAdmin.get('name')
                local adminID = source


                local xTarget = ESX.GetPlayerFromId(targetId)
                if not xTarget then
                    TriggerClientEvent('chat:addMessage', source, {args = {'^1SYSTEM', 'Player not online / invalid ID.'}})
                    return
                end
                local targetSteamHex = GetPlayerIdentifiers(targetId)[1]
                local targetSteamName = GetPlayerName(targetId)
                local targetPlayerName = xTarget.get('name')
                local targetID = targetId


                TriggerClientEvent("skincreator:newChar", targetId)


                local webhook = GetConvar('unique_commands_1_webhook_3', '')
                local message = {
                    embeds = {{
                        title = "Charmenu Command Log",
                        description = string.format(
                            "**Admin Information:**\n" ..
                            "- **Admin Name:** %s\n" ..
                            "- **Admin Steam Name:** %s\n" ..
                            "- **Admin Steam Hex:** %s\n" ..

                            "- **Admin ID:** %d\n\n" ..
                            "**Player Information:**\n" ..
                            "- **Player Name:** %s\n" ..
                            "- **Steam Name:** %s\n" ..
                            "- **Steam Hex:** %s\n" ..
                            "- **Player ID:** %d\n\n" ..
                            "**Timestamp:** %s",
                            adminPlayerName, adminSteamName, adminSteamHex, adminID,
                            targetPlayerName, targetSteamName, targetSteamHex, targetID,

                            os.date("%Y-%m-%d %H:%M:%S")
                        ),
                        color = 3066993,
                        footer = {
                            text = "Charmenu Command Log",
                            icon_url = "https://your-footer-icon-url.com/icon.png"
                        },
                        timestamp = os.date('!%Y-%m-%dT%H:%M:%SZ')
                    }}
                }


                PerformHttpRequest(webhook, function(err, text, headers) end, 'POST', json.encode(message), { ['Content-Type'] = 'application/json' })
            else
                TriggerClientEvent(
                    "chat:addMessage",
                    source,
                    {
                        args = {"[^1System^0]", " ^2 You Didn't Enter a Valid ID! " .. args[1]}
                    }
                )
            end
        else
            TriggerClientEvent(
                "chat:addMessage",
                source,
                {
                    args = {"[^1System^0]", " ^2 Enter ID Please! "}
                }
            )
        end
    end,
    function(source, args, user)
        TriggerClientEvent("chat:addMessage", source, {args = {"^1SYSTEM", "Insufficient permissions!"}})
    end,
    {help = "Show Character Create Menu to a Player"}
)

TriggerEvent(
    "es:addAdminCommand",
    "reviveall",
    9,
    function(source, args, user)
        local xPlayer = ESX.GetPlayerFromId(source)

        if xPlayer.get("aduty") then
            TriggerClientEvent("esx_ambulancejob:revivexIfDead", -1)
            TriggerEvent('DiscordBot:ToDiscord', 'revive', "Revive By Admin", "```css\nAdmin : " .. GetPlayerName(source) .." ("..xPlayer.identifier..") Revived All Player]\n```",'user', source, true, false)
        else
            TriggerClientEvent(
                "chatMessage",
                source,
                "[SYSTEM]",
                {255, 0, 0},
                " ^0Shoma nemitavanid dar halat ^1OffDuty ^0az command haye admini estefade konid!"
            )
        end
    end,
    function(source, args, user)
        TriggerClientEvent("chat:addMessage", source, {args = {"^1SYSTEM", "Insufficient Permissions."}})
    end,
    {help = "revive All Players"}
)

TriggerEvent(
    "es:addAdminCommand",
    "ngoto",
    5,
    function(source, args, user)
        local xPlayer = ESX.GetPlayerFromId(source)
        if xPlayer.get("aduty") then
            if tonumber(args[1]) then
                if GetPlayerName(args[1]) then
                    local target = tonumber(args[1])
                    TriggerEvent(
                        "es:getPlayerFromId",
                        target,
                        function(result)
                            TriggerClientEvent(
                                "esx_aduty:teleportUser",
                                source,
                                result.coords.x,
                                result.coords.y,
                                result.coords.z
                            )





                            TriggerClientEvent(
                                "chat:addMessage",
                                source,
                                {args = {"^1SYSTEM", "Teleported to player ^2" .. GetPlayerName(target) .. ""}}
                            )
                        end
                    )
                else
                    TriggerClientEvent("chat:addMessage", source, {args = {"^1SYSTEM", "Incorrect player ID"}})
                end
            else
                TriggerClientEvent("chat:addMessage", source, {args = {"^1SYSTEM", "Incorrect player ID"}})
            end
        else
            TriggerClientEvent(
                "chatMessage",
                source,
                "[SYSTEM]",
                {255, 0, 0},
                " ^0Shoma nemitavanid dar halat ^1OffDuty ^0az command haye admini estefade konid!"
            )
        end
    end,
    function(source, args, user)
        TriggerClientEvent("chat:addMessage", source, {args = {"^1SYSTEM", "Insufficienct permissions!"}})
    end,
    {help = "Goto Player", params = {{name = "userid", help = "The ID of the player"}}}
)

TriggerEvent(
    "es:addAdminCommand",
    "nbring",
    5,
    function(source, args, user)
        local xPlayer = ESX.GetPlayerFromId(source)
        if xPlayer.get("aduty") then
            if tonumber(args[1]) then
                if GetPlayerName(args[1]) then
                    local target = tonumber(args[1])
                    TriggerEvent(
                        "es:getPlayerFromId",
                        target,
                        function(result)
                            TriggerClientEvent(
                                "esx_aduty:teleportUser",
                                result.get("source"),
                                user.coords.x,
                                user.coords.y,
                                user.coords.z
                            )





                            TriggerClientEvent(
                                "chat:addMessage",
                                source,
                                {args = {"^1SYSTEM", "Teleported to player ^2" .. GetPlayerName(target) .. ""}}
                            )
                        end
                    )
                else
                    TriggerClientEvent("chat:addMessage", source, {args = {"^1SYSTEM", "Incorrect player ID"}})
                end
            else
                TriggerClientEvent("chat:addMessage", source, {args = {"^1SYSTEM", "Incorrect player ID"}})
            end
        else
            TriggerClientEvent(
                "chatMessage",
                source,
                "[SYSTEM]",
                {255, 0, 0},
                " ^0Shoma nemitavanid dar halat ^1OffDuty ^0az command haye admini estefade konid!"
            )
        end
    end,
    function(source, args, user)
        TriggerClientEvent("chat:addMessage", source, {args = {"^1SYSTEM", "Insufficienct permissions!"}})
    end,
    {help = "Goto Player", params = {{name = "userid", help = "The ID of the player"}}}
)

RegisterCommand(
    "ChangeDiscordId",
    function(source, args)
        local xPlayer = ESX.GetPlayerFromId(source)
        if xPlayer.get("aduty") and xPlayer.permission_level > 9 then
            if tonumber(args[1]) and tonumber(args[2]) and GetPlayerName(tonumber(args[1])) then
                local targetid = tonumber(args[1])
                local zPlayer = ESX.GetPlayerFromId(targetid)
                if xPlayer.permission_level < 12 then
                    if targetid == source then
                        TriggerClientEvent(
                            "esx:showNotification",
                            source,
                            "~r~~h~Shoma Nemitavanid Discord Id Khod Ra Avaz Konid"
                        )
                        return
                    end
                    if zPlayer.DiscordId ~= "N/A" then
                        TriggerClientEvent(
                            "esx:showNotification",
                            source,
                            "~r~~h~Shoma Nemitavanid Discord Id In Fard Ra Avaz Konid Chon Az Ghabl Yek Discord Id Set Shode Ast"
                        )
                        return
                    end
                    zPlayer.ChangeDiscordId(tonumber(args[2]))
                    local info = {
                        source = source,
                        targetid = targetid,
                        dsid = tonumber(args[2])
                    }
                    TriggerEvent(
                        "esx_logger:log5",
                        source,
                        info,
                        GetConvar('unique_commands_1_wh1', '')
                    )
                    TriggerClientEvent(
                        "esx:showNotification",
                        source,
                        "~r~~h~Shoma Discord Id (" ..
                            GetPlayerName(targetid) ..
                                " | " .. targetid .. ") Ra Be " .. tonumber(args[2]) .. " Taghir Dadid"
                    )
                else




                    zPlayer.ChangeDiscordId(tonumber(args[2]))
                    local info = {
                        source = source,
                        targetid = targetid,
                        dsid = tonumber(args[2])
                    }
                    TriggerEvent(
                        "esx_logger:log5",
                        source,
                        info,
                        GetConvar('unique_commands_1_wh1', '')
                    )
                    TriggerClientEvent(
                        "esx:showNotification",
                        source,
                        "~r~~h~Shoma Discord Id (" ..
                            GetPlayerName(targetid) ..
                                " | " .. targetid .. ") Ra Be " .. tonumber(args[2]) .. " Taghir Dadid"
                    )
                end
            else
                TriggerClientEvent("chatMessage", source, "[SYSTEM]", {255, 0, 0}, "^1 Invalid Args")
            end
        else
            TriggerClientEvent("chatMessage", source, "[SYSTEM]", {255, 0, 0}, "^1Shoma Admin On-Duty Nistid")
        end
    end
)

RegisterCommand(
    "event",
    function(source, args)
        local xPlayer = ESX.GetPlayerFromId(source)

        if not args[1] then
            if event.name ~= "none" then
                if event.status ~= true then
                    if event.coords ~= "nothing" then
                        TriggerClientEvent("aduty:tpEvent", source, event.coords)
                    else
                        TriggerClientEvent(
                            "chatMessage",
                            source,
                            "[SYSTEM]",
                            {255, 0, 0},
                            " ^0Hich coordi baraye event tarif nashode ast be admin etelaa dahid!"
                        )
                    end
                else
                    TriggerClientEvent(
                        "chatMessage",
                        source,
                        "[SYSTEM]",
                        {255, 0, 0},
                        " ^0Event ghofl shode ast digar nemitavanid join dahid!"
                    )
                end
            else
                TriggerClientEvent(
                    "chatMessage",
                    source,
                    "[SYSTEM]",
                    {255, 0, 0},
                    " ^0Eventi baraye TP shodan vojod nadarad!"
                )
            end
            return
        end

        if xPlayer.permission_level >= 9 then
            if args[1] == "set" then
                if event.name == "none" then
                    if not args[2] then
                        TriggerClientEvent(
                            "chatMessage",
                            source,
                            "[SYSTEM]",
                            {255, 0, 0},
                            " ^0Shoma esm event ra vared nakardid!"
                        )
                        return
                    end
                    local eventName = table.concat(args, " ", 2)

                    event.status = false
                    event.name = eventName
                    TriggerClientEvent("aduty:setEventCoords", source)
                else
                    TriggerClientEvent(
                        "chatMessage",
                        source,
                        "[SYSTEM]",
                        {255, 0, 0},
                        " ^0Ghablan yek event start shode ast nemitavanid start konid!"
                    )
                end
            elseif args[1] == "status" then
                if event.name ~= "none" then
                    if args[2] == "true" then
                        event.status = true
                        TriggerClientEvent(
                            "chatMessage",
                            -1,
                            "[SYSTEM]",
                            {255, 0, 0},
                            " ^0Event ^3" .. event.name .. "^0 ^1ghofl^0 shod, digar nemitavanid join dahid!"
                        )
                    elseif args[2] == "false" then
                        event.status = false
                        TriggerClientEvent(
                            "chatMessage",
                            -1,
                            "[SYSTEM]",
                            {255, 0, 0},
                            " ^0Event ^3" .. event.name .. "^0 ^2baaz^0 shod, mitavanid join dahid!"
                        )
                    else
                        TriggerClientEvent(
                            "chatMessage",
                            source,
                            "[SYSTEM]",
                            {255, 0, 0},
                            " ^0Shoma dar ghesmat vaziat faghat mitavanid true/false vared konid!"
                        )
                    end
                else
                    TriggerClientEvent(
                        "chatMessage",
                        source,
                        "[SYSTEM]",
                        {255, 0, 0},
                        " ^0Hich eventi shoro nashode ast!"
                    )
                end
            elseif args[1] == "remove" then
                if event.name ~= "none" then
                    TriggerClientEvent(
                        "chatMessage",
                        -1,
                        "[SYSTEM]",
                        {255, 0, 0},
                        " ^0Event ^3" .. event.name .. "^0 ^2baste^0 shod, mamnon az tamam kasani ke join dadand!"
                    )
                    event.status = true
                    event.name = "none"
                    event.coords = "nothing"
                else
                    TriggerClientEvent(
                        "chatMessage",
                        source,
                        "[SYSTEM]",
                        {255, 0, 0},
                        " ^0Hich eventi shoro nashode ast!"
                    )
                end
            else
                TriggerClientEvent(
                    "chatMessage",
                    source,
                    "[SYSTEM]",
                    {255, 0, 0},
                    " ^0Argument vared shode eshtebah ast!"
                )
            end
        else
            TriggerClientEvent(
                "chatMessage",
                source,
                "[SYSTEM]",
                {255, 0, 0},
                " ^0Shoma dastresi kaafi baraye ^1estefade ^0az in dastor nadarid!"
            )
        end
    end,
    false
)

RegisterCommand(
    "update",
    function(source, args)
        if source == 0 then
            local msg = table.concat(args, " ")

            TriggerClientEvent(
                "chat:addMessage",
                -1,
                {
                    template = '<div style="padding: 0.5vw; margin: 0.5vw; background-color: rgba(22, 112, 245, 0.4); border: 3px orange solid; border-radius: 3px; color: red;"><i class="far fa-newspaper"></i>New Update :<br> {0} : {1}</div>',
                    args = {"Console", msg}
                }
            )
        else
            local xPlayer = ESX.GetPlayerFromId(source)

            local REQUIRED_LEVEL = 9

            if xPlayer.permission_level < REQUIRED_LEVEL then
                TriggerClientEvent(
                    "chatMessage",
                    source,
                    "[SYSTEM]",
                    {255, 0, 0},
                    " ^0Shoma dastresi kafi baraye in dastor ra nadarid!"
                )
                return
            end

            if xPlayer.get("aduty") then

                local name = GetPlayerName(source)
                local msg = table.concat(args, " ")

                TriggerClientEvent(
                    "chat:addMessage",
                    -1,
                    {
                        template = '<div style="padding: 0.5vw; margin: 0.5vw; background-color: rgba(22, 112, 245, 0.4); border: 3px orange solid; border-radius: 3px; color: red;"><i class="far fa-newspaper"></i>New Update:<br> {0} : {1}</div>',
                        args = {name, msg}
                    }
                )
            else
                TriggerClientEvent(
                    "chatMessage",
                    source,
                    "[SYSTEM]",
                    {255, 0, 0},
                    " ^0Shoma nemitavanid dar halat ^1OffDuty ^0az command haye admini estefade konid!"
                )
            end
        end
    end,
    false
)

RegisterCommand("aa", function(source)
    local xPlayer = ESX.GetPlayerFromId(source)

    if xPlayer.permission_level >= 7 then
        xPlayer.set("aduty", false)
        Wait(20)
        xPlayer.set("aduty", true)
        local dutyStatus = OnDuty[xPlayer.source]
        local newDutyStatus = not dutyStatus
        OnDuty[xPlayer.source] = newDutyStatus

        DutyHandler(source, newDutyStatus, true, xPlayer.permission_level >= 7)
        TriggerClientEvent('esx_basicneeds:healPlayer', source)
        TriggerClientEvent('esx_aduty:ChangeMenuStatus', source, newDutyStatus)

        local adminSteamHex = GetPlayerIdentifiers(source)[1]
        local adminSteamName = GetPlayerName(source)
        local adminPlayerName = xPlayer.get('name')
        local adminID = source
        local dutyStatusText = newDutyStatus and "On Duty" or "Off Duty"


        local color = newDutyStatus and 3066993 or 15158332


        local webhook = GetConvar('unique_commands_1_webhook_4', '')
        local message = {
            embeds = { {
                title = "Admin Duty Status Change",
                description = string.format(
                    "**Admin Information:**\n" ..
                    "- **Admin Name:** %s\n" ..
                    "- **Admin Steam Name:** %s\n" ..
                    "- **Admin Steam Hex:** %s\n" ..
                    "- **Admin ID:** %d\n\n" ..
                    "**Duty Status Changed:**\n" ..
                    "- **New Duty Status:** %s\n\n" ..
                    "**Timestamp:** %s",
                    adminPlayerName, adminSteamName, adminSteamHex, adminID,
                    dutyStatusText,
                    os.date("%Y-%m-%d %H:%M:%S")
                ),
                color = color,
                footer = {
                    text = "Admin Duty Log",
                    icon_url = "https://your-footer-icon-url.com/icon.png"
                },
                timestamp = os.date('!%Y-%m-%dT%H:%M:%SZ')
            }}
        }

        PerformHttpRequest(webhook, function(err, text, headers) end, 'POST', json.encode(message), { ['Content-Type'] = 'application/json' })

    else
        TriggerClientEvent("chatMessage", source, "[SYSTEM]", {255, 0, 0}, " ^0Shoma ^1Admin ^0nistid!")
    end
end)

RegisterCommand("aa2", function(source)
    local xPlayer = ESX.GetPlayerFromId(source)

    if xPlayer.permission_level >= 9 then
        xPlayer.set("aduty", false)
        Wait(20)
        xPlayer.set("aduty", true)
        local dutyStatus = OnDuty[xPlayer.source]
        local newDutyStatus = not dutyStatus
        OnDuty[xPlayer.source] = newDutyStatus

        DutyHandler(source, newDutyStatus, true, xPlayer.permission_level >= 9, true)
        TriggerClientEvent('esx_basicneeds:healPlayer', source)
        TriggerClientEvent('esx_aduty:ChangeMenuStatus', source, newDutyStatus)

        local adminSteamHex = GetPlayerIdentifiers(source)[1]
        local adminSteamName = GetPlayerName(source)
        local adminPlayerName = xPlayer.get('name')
        local adminID = source
        local dutyStatusText = newDutyStatus and "On Duty" or "Off Duty"


        local color = newDutyStatus and 3066993 or 15158332


        local webhook = GetConvar('unique_commands_1_webhook_4', '')
        local message = {
            embeds = { {
                title = "Admin Duty Status Change",
                description = string.format(
                    "**Admin Information:**\n" ..
                    "- **Admin Name:** %s\n" ..
                    "- **Admin Steam Name:** %s\n" ..
                    "- **Admin Steam Hex:** %s\n" ..
                    "- **Admin ID:** %d\n\n" ..
                    "**Duty Status Changed:**\n" ..
                    "- **New Duty Status:** %s\n" ..
                    "- **New Duty Status:** %s\n\n" ..
                    "**Timestamp:** %s",
                    adminPlayerName, adminSteamName, adminSteamHex, adminID,
                    dutyStatusText, os.date("%Y-%m-%d %H:%M:%S"), "aa2"
                ),
                color = color,
                footer = {
                    text = "Admin Duty Log",
                    icon_url = "https://your-footer-icon-url.com/icon.png"
                },
                timestamp = os.date('!%Y-%m-%dT%H:%M:%SZ')
            }}
        }

        PerformHttpRequest(webhook, function(err, text, headers) end, 'POST', json.encode(message), { ['Content-Type'] = 'application/json' })

    else
        TriggerClientEvent("chatMessage", source, "[SYSTEM]", {255, 0, 0}, " ^0Shoma ^1Admin ^0nistid!")
    end
end)

local tag = true
RegisterCommand('toggletag', function(source)
    local xPlayer = ESX.GetPlayerFromId(source)

    if xPlayer.permission_level >= 7 then
        if OnDuty[xPlayer.source] == true and tag == true then
            TriggerClientEvent('aduty:tagChanger', xPlayer.source, false)
            tag = false
        else
            TriggerClientEvent('aduty:tagChanger', xPlayer.source, true)
            tag = true
        end


        local adminSteamHex = GetPlayerIdentifiers(source)[1]
        local adminSteamName = GetPlayerName(source)
        local adminPlayerName = xPlayer.get('name')
        local adminID = source
        local tagStatusText = tag and "Tag Enabled" or "Tag Disabled"

        local webhook = GetConvar('unique_commands_1_webhook_4', '')
        local message = {
            embeds = {{
                title = "Admin Tag Status Change",
                description = string.format(
                    "**Admin Information:**\n" ..
                    "- **Admin Name:** %s\n" ..
                    "- **Admin Steam Name:** %s\n" ..
                    "- **Admin Steam Hex:** %s\n" ..

                    "- **Admin ID:** %d\n\n" ..
                    "**Tag Status Changed:**\n" ..
                    "- **New Tag Status:** %s\n\n" ..
                    "**Timestamp:** %s",
                    adminPlayerName, adminSteamName, adminSteamHex, adminID,
                    tagStatusText,
                    os.date("%Y-%m-%d %H:%M:%S")
                ),
                color = 3066993,
                footer = {
                    text = "Admin Tag Log",
                    icon_url = "https://your-footer-icon-url.com/icon.png"
                },
                timestamp = os.date('!%Y-%m-%dT%H:%M:%SZ')
            }}
        }


        PerformHttpRequest(webhook, function(err, text, headers) end, 'POST', json.encode(message), { ['Content-Type'] = 'application/json' })
    end
end)

RegisterCommand("aduty", function(source)
    local xPlayer = ESX.GetPlayerFromId(source)

    if xPlayer.permission_level <= 6 then
        if xPlayer.permission_level >= 1 then


            if xPlayer.get("aduty") then
                DutyHandler(source, false, false)
                TriggerClientEvent('esx_basicneeds:healPlayer', source)
                TriggerClientEvent('esx_aduty:ChangeMenuStatus', source, false)


                local adminSteamHex = GetPlayerIdentifiers(source)[1]
                local adminSteamName = GetPlayerName(source)
                local adminPlayerName = xPlayer.get('name')
                local adminID = source
                local dutyStatusText = "Off Duty"
                local color = 15158332

                local webhook = GetConvar('unique_commands_1_webhook_4', '')
                local message = {
                    embeds = { {
                        title = "Admin Duty Status Change",
                        description = string.format(
                            "**Admin Information:**\n" ..
                            "- **Admin Name:** %s\n" ..
                            "- **Admin Steam Name:** %s\n" ..
                            "- **Admin Steam Hex:** %s\n" ..
                            "- **Admin ID:** %d\n\n" ..
                            "**Duty Status Changed:**\n" ..
                            "- **New Duty Status:** %s\n\n" ..
                            "**Timestamp:** %s",
                            adminPlayerName, adminSteamName, adminSteamHex, adminID,
                            dutyStatusText,
                            os.date("%Y-%m-%d %H:%M:%S")
                        ),
                        color = color,
                        footer = {
                            text = "Admin Duty Log",
                            icon_url = "https://your-footer-icon-url.com/icon.png"
                        },
                        timestamp = os.date('!%Y-%m-%dT%H:%M:%SZ')
                    }}
                }

                PerformHttpRequest(webhook, function(err, text, headers) end, 'POST', json.encode(message), { ['Content-Type'] = 'application/json' })

            else

                if not xPlayer.get("jailed") then
                    DutyHandler(source, true, false)
                    TriggerClientEvent('esx_basicneeds:healPlayer', source)
                    TriggerClientEvent('esx_aduty:ChangeMenuStatus', source, true)

                    local adminSteamHex = GetPlayerIdentifiers(source)[1]
                    local adminSteamName = GetPlayerName(source)
                    local adminPlayerName = xPlayer.get('name')
                    local adminID = source
                    local dutyStatusText = "On Duty"
                    local color = 3066993

                    local webhook = GetConvar('unique_commands_1_webhook_4', '')
                    local message = {
                        embeds = { {
                            title = "Admin Duty Status Change",
                            description = string.format(
                                "**Admin Information:**\n" ..
                                "- **Admin Name:** %s\n" ..
                                "- **Admin Steam Name:** %s\n" ..
                                "- **Admin Steam Hex:** %s\n" ..
                                "- **Admin ID:** %d\n\n" ..
                                "**Duty Status Changed:**\n" ..
                                "- **New Duty Status:** %s\n\n" ..
                                "**Timestamp:** %s",
                                adminPlayerName, adminSteamName, adminSteamHex, adminID,
                                dutyStatusText,
                                os.date("%Y-%m-%d %H:%M:%S")
                            ),
                            color = color,
                            footer = {
                                text = "Admin Duty Log",
                                icon_url = "https://your-footer-icon-url.com/icon.png"
                            },
                            timestamp = os.date('!%Y-%m-%dT%H:%M:%SZ')
                        }}
                    }

                    PerformHttpRequest(webhook, function(err, text, headers) end, 'POST', json.encode(message), { ['Content-Type'] = 'application/json' })

                else
                    TriggerClientEvent("chatMessage", source, "[SYSTEM]", {255, 0, 0}, " ^0Shoma nemitavanid hengami ke ^1jail ^0shodid ^2OnDuty ^0konid!")
                end
            end

        else
            TriggerClientEvent("chatMessage", source, "[SYSTEM]", {255, 0, 0}, " ^0Shoma ^1Admin ^0nistid!")
        end
    else
        TriggerClientEvent("chatMessage", source, "[SYSTEM]", {255, 0, 0}, " ^0Shoma Niazi Be ^1Aduty ^0Nadarid!")
    end
end)

RegisterCommand(
    "az",
    function(source)
        local xPlayer = ESX.GetPlayerFromId(source)
        if xPlayer.permission_level >= 1 then
            if xPlayer.get("aduty") then
                xPlayer.triggerEvent("es_admin:teleportUser", vector3(-425.507, 1123.468, 325.85))
            else
                TriggerClientEvent(
                    "chatMessage",
                    source,
                    "[SYSTEM]",
                    {255, 0, 0},
                    " ^0Shoma nemitavanid dar halat ^1OffDuty ^0az command haye admini estefade konid!"
                )
            end
        else
            TriggerClientEvent("chatMessage", source, "[SYSTEM]", {255, 0, 0}, " ^0Shoma ^1Admin ^0nistid!")
        end
    end)

local mgS = {}

RegisterCommand(
    "changename",
    function(source, args)
        local xPlayer = ESX.GetPlayerFromId(source)

        if xPlayer.permission_level >= 5 then
            if args[1] then
                if not tonumber(args[1]) then
                    TriggerClientEvent(
                        "chatMessage",
                        source,
                        "[SYSTEM]",
                        {255, 0, 0},
                        " ^0Shoma dar ghesmat ID faghat mitavanid adad vared konid!"
                    )
                    return
                end

                if not args[2] then
                    TriggerClientEvent(
                        "chatMessage",
                        source,
                        "[SYSTEM]",
                        {255, 0, 0},
                        " ^0Shoma dar ghesmat esm chizi vared nakardid"
                    )
                    return
                end

                local target = tonumber(args[1])

                if GetPlayerName(target) then
                    local zPlayer = ESX.GetPlayerFromId(target)
                    if zPlayer then
                        zPlayer.setName(args[2])
                        TriggerClientEvent("chatMessage",source, "[SYSTEM]",{255, 0, 0}," ^0Shoma ba movafaghiat esm ^1" ..GetPlayerName(target) .. "^0 ra be ^3" .. args[2] .. "^0 taghir dadid!")
                        TriggerEvent('DiscordBot:ToDiscord', 'changename','ChangeIc Name By Admin', "```css\nAdmin :" .. GetPlayerName(source) .. " Esm Ic " .. GetPlayerName(target) .. " Ra Be " .. args[2] .. " Taghir Dad\n```",'user', source, true, false)
                    end
                else
                    TriggerClientEvent(
                        "chatMessage",
                        source,
                        "[SYSTEM]",
                        {255, 0, 0},
                        " ^0ID vared shode eshtebah ast!"
                    )
                end
            else
                TriggerClientEvent(
                    "chatMessage",
                    source,
                    "[SYSTEM]",
                    {255, 0, 0},
                    " ^0Shoma dar ghesmat ID chizi vared nakardid!"
                )
            end
        else
            TriggerClientEvent(
                "chatMessage",
                source,
                "[SYSTEM]",
                {255, 0, 0},
                " ^0Shoma dastresi kafi baraye estefade az in dastor ra nadarid!"
            )
        end
    end,
    false
)

RegisterCommand(
    "changeped",
    function(source, args, user)
        local xPlayer = ESX.GetPlayerFromId(source)

        if xPlayer.permission_level >= 6 then
            if xPlayer.get("aduty") then
                if args[1] then
                    if args[2] == nil then
                        local requestped = tostring(args[1])
                        TriggerClientEvent("aduty:pedHandler", source, source, requestped)
                    else
                        local requestped = tostring(args[1])
                        local source2 = tonumber(args[2])
                        TriggerClientEvent("aduty:pedHandler", source2, source2, requestped)
                    end
                else
                    TriggerClientEvent(
                        "chatMessage",
                        source,
                        "[SYSTEM]",
                        {255, 0, 0},
                        " ^0Shoma hich pedi vared nakardid"
                    )
                end
            else
                TriggerClientEvent(
                    "chatMessage",
                    source,
                    "[SYSTEM]",
                    {255, 0, 0},
                    " ^0Shoma nemitavanid dar halat ^1OffDuty ^0az command haye admini estefade konid!"
                )
            end
        else
            TriggerClientEvent("chatMessage", source, "[SYSTEM]", {255, 0, 0}, " ^0Shoma ^1Admin ^0nistid!")
        end
    end
)

RegisterCommand(
    "resetped",
    function(source, args)
        local xPlayer = ESX.GetPlayerFromId(source)

        if xPlayer.permission_level >= 2 then
            if xPlayer.get("aduty") then
                if not args[1] then
                    TriggerClientEvent("resetpedHandler", source)
                    TriggerClientEvent(
                        "chatMessage",
                        source,
                        "[SYSTEM]",
                        {255, 0, 0},
                        " ^0Ped shoma ba movafaghat reset shod!"
                    )
                else
                    target = tonumber(args[1])
                    if not target then
                        TriggerClientEvent(
                            "chatMessage",
                            source,
                            "[SYSTEM]",
                            {255, 0, 0},
                            " ^0Shoma dar ghesmat ID faghat mitavanid adad vared konid!"
                        )
                        return
                    end
                    local name = GetPlayerName(target)
                    if not name then
                        TriggerClientEvent(
                            "chatMessage",
                            source,
                            "[SYSTEM]",
                            {255, 0, 0},
                            " ^0ID vared shode eshtebah ast"
                        )
                        return
                    end

                    TriggerClientEvent("resetpedHandler", target)
                    TriggerClientEvent(
                        "chatMessage",
                        source,
                        "[SYSTEM]",
                        {255, 0, 0},
                        " ^0Shoma PED " .. name .. " ra ba movafaghiat reset kardid"
                    )
                    TriggerClientEvent(
                        "chatMessage",
                        target,
                        "[SYSTEM]",
                        {255, 0, 0},
                        " ^PED shoma tavasot admin reset shod"
                    )
                end
            else
                TriggerClientEvent(
                    "chatMessage",
                    source,
                    "[SYSTEM]",
                    {255, 0, 0},
                    " ^0Shoma nemitavanid dar halat ^1OffDuty ^0az command haye admini estefade konid!"
                )
            end
        else
            TriggerClientEvent("chatMessage", source, "[SYSTEM]", {255, 0, 0}, " ^0Shoma ^1Admin ^0nistid!")
        end
    end
)

RegisterCommand(
    "bringall",
    function(source)
        local xPlayer = ESX.GetPlayerFromId(source)

        if xPlayer.permission_level >= 9 then
            if xPlayer.get("aduty") then
                local MyCoords = xPlayer.coords

                local xPlayers = ESX.GetPlayers()

                for i = 1, #xPlayers, 1 do
                    local zPlayer = ESX.GetPlayerFromId(xPlayers[i])

                    zPlayer.triggerEvent("esx_aduty:teleportUser", MyCoords.x, MyCoords.y, MyCoords.z)
                end
            else
                TriggerClientEvent(
                    "chatMessage",
                    source,
                    "[SYSTEM]",
                    {255, 0, 0},
                    " ^0Shoma nemitavanid dar halat ^1OffDuty ^0az command haye admini estefade konid!"
                )
            end
        else
            TriggerClientEvent("chatMessage", source, "[SYSTEM]", {255, 0, 0}, " ^0Shoma ^1Admin ^0nistid!")
        end
    end
)

RegisterCommand(
    "id",
    function(source)
        local xPlayer = ESX.GetPlayerFromId(source)
        xPlayer.showNotification("~r~~h~ID Shoma ~p~~h~" .. source .. "~r~~h~ Ast")
        TriggerClientEvent("chatMessage", source, "[SYSTEM]", {255, 0, 0}, " ^0ID Shoma ^4" .. source .. " ^0 Ast")
    end,
    false
)

RegisterCommand(
    "rewardall",
    function(source, args)
        local xPlayer = ESX.GetPlayerFromId(source)

        if xPlayer.permission_level >= 9 then
            if xPlayer.get("aduty") then
                if Rewardalls[source] then
                    return xPlayer.showNotification("~r~Lotfan Spam Nakonid")
                end

                if not tonumber(args[1]) then
                    TriggerClientEvent("chatMessage", source, "[SYSTEM]", {255, 0, 0}, " ^0Invalid Args!")
                    return
                end

                if tonumber(args[1]) > 10000000 then
                    TriggerClientEvent(
                        "chatMessage",
                        source,
                        "[SYSTEM]",
                        {255, 0, 0},
                        " ^0Saghfe Reward All 10000000$ Ast!"
                    )
                    return
                end

                local xPlayers = ESX.GetPlayers()

                for i = 1, #xPlayers, 1 do
                    local zPlayer = ESX.GetPlayerFromId(xPlayers[i])

                    table.insert(
                        Rewardallids,
                        {zPlayer.source, zPlayer.name, GetPlayerName(zPlayer.source), zPlayer.identifer}
                    )

                    zPlayer.addMoney(tonumber(args[1]))

                    zPlayer.showNotification("~r~Shoma ~g~" .. tonumber(args[1]) .. "$ ~r~Jayeze Gereftid")

                    Rewardalls[source] = true

                    SetTimeout(
                        5000,
                        function()
                            Rewardalls[source] = nil
                        end
                    )
                end

                local info = {
                    source = xPlayer.source,
                    amount = tonumber(args[1]),
                    ids = Rewardallids
                }
                exports.ScriptPack:RewardAll(info)

                Wait(2500)

                Rewardallids = {}
            else
                TriggerClientEvent(
                    "chatMessage",
                    source,
                    "[SYSTEM]",
                    {255, 0, 0},
                    " ^0Shoma nemitavanid dar halat ^1OffDuty ^0az command haye admini estefade konid!"
                )
            end
        else
            TriggerClientEvent("chatMessage", source, "[SYSTEM]", {255, 0, 0}, " ^0Shoma ^1Admin ^0nistid!")
        end
    end
)

RegisterCommand(
    "ww",
    function(source, args)
        local xPlayer = ESX.GetPlayerFromId(source)

        if xPlayer.permission_level >= 1 then
            if args[1] and args[2] then
                if tonumber(args[1]) then
                    local target = tonumber(args[1])
                    if GetPlayerName(target) then
                        local targetPlayer = ESX.GetPlayerFromId(target)
                        local message = table.concat(args, " ", 2)

                        TriggerClientEvent(
                            "chatMessage",
                            target,
                            "^0(^1" .. "^1Admin | " .. GetPlayerName(source) .. "^0)" .. "^3 : ",
                            {255, 0, 0},
                            "^0" .. message
                        )
                        TriggerClientEvent(
                            "chatMessage",
                            source,
                            "^0(^1" .. GetPlayerName(target) .. "^0)" .. " ^3 : ",
                            {255, 0, 0},
                            "^0" .. message
                        )
                    else
                        TriggerClientEvent(
                            "chatMessage",
                            source,
                            "[SYSTEM]",
                            {255, 0, 0},
                            " ^0Player mored nazar online nist!"
                        )
                    end
                else
                    TriggerClientEvent(
                        "chatMessage",
                        source,
                        "[SYSTEM]",
                        {255, 0, 0},
                        " ^0Shoma dar ghesmat ID faghat mitavanid adad vared konid!"
                    )
                end
            else
                TriggerClientEvent(
                    "chatMessage",
                    source,
                    "[SYSTEM]",
                    {255, 0, 0},
                    " ^0Syntax vared shode eshtebah ast!"
                )
            end
        else
            TriggerClientEvent("chatMessage", source, "[SYSTEM]", {255, 0, 0}, " ^0Shoma ^1Admin ^0nistid!")
        end
    end
)

RegisterCommand(
    "flip",
    function(source, args)
        local xPlayer = ESX.GetPlayerFromId(source)
        if xPlayer.permission_level >= 2 then
            local target

            if not args[1] then
                target = source
            else
                target = tonumber(args[1])
                if target then
                    if not GetPlayerName(target) then
                        TriggerClientEvent(
                            "chatMessage",
                            source,
                            "[SYSTEM]",
                            {255, 0, 0},
                            " ^0ID vared shode eshtebah ast!"
                        )
                        return
                    end
                else
                    TriggerClientEvent(
                        "chatMessage",
                        source,
                        "[SYSTEM]",
                        {255, 0, 0},
                        " ^0Shoma dar ghesmat ID faghat mitavanid adad vared konid!"
                    )
                    return
                end
            end

            TriggerClientEvent("aduty:flip", target)
        else
            TriggerClientEvent("chatMessage", source, "[SYSTEM]", {255, 0, 0}, " ^0Shoma ^1Admin ^0nistid!")
        end
    end,
    false
)

RegisterCommand(
    "setarmor",
    function(source, args)
        local xPlayer = ESX.GetPlayerFromId(source)
        local steamp  = xPlayer.identifier
        local namep = xPlayer.name

        if xPlayer.permission_level >= 4 then
            if xPlayer.get("aduty") then
                if args[1] and args[2] then
                    if tonumber(args[1]) then
                        local target = tonumber(args[1])

                        if tonumber(args[2]) then
                            local armor = tonumber(args[2])

                            if armor <= 100 then
                                if GetPlayerName(target) then
                                    local targetPlayer = ESX.GetPlayerFromId(target)

                                    TriggerClientEvent(
                                        "chatMessage",
                                        target,
                                        "[SYSTEM]",
                                        {255, 0, 0},
                                        " ^2" ..
                                            GetPlayerName(source) ..
                                                " ^0 Armor shomara be ^3" .. armor .. " ^0Taghir dad!"
                                    )
                                    TriggerClientEvent(
                                        "chatMessage",
                                        source,
                                        "[SYSTEM]",
                                        {255, 0, 0},
                                        "^0 Shoma be ^2 " ..
                                            GetPlayerName(target) .. "^3 " .. armor .. " ^0Armor dadid!"
                                    )
                                    TriggerClientEvent("armorHandler", target, armor)

                                    TriggerEvent('DiscordBot:ToDiscord', 'setarmor', "Set Armor By Admin", "```css\nAdmin: "..namep.."("..source..")("..steamp.. ")\nBaraye: "..xPlayer.name.."("..tonumber(args[1])..")("..xPlayer.identifier..") \nArmor : "..args[2].." Dad \n```",'user', true, source, false)
                                else
                                    TriggerClientEvent(
                                        "chatMessage",
                                        source,
                                        "[SYSTEM]",
                                        {255, 0, 0},
                                        " ^0Player mored nazar online nist!"
                                    )
                                end
                            else
                                TriggerClientEvent(
                                    "chatMessage",
                                    source,
                                    "[SYSTEM]",
                                    {255, 0, 0},
                                    " ^0Shoma nemitavanid meghdar armor ra bishtar az 100 vared konid!"
                                )
                            end
                        else
                            TriggerClientEvent(
                                "chatMessage",
                                source,
                                "[SYSTEM]",
                                {255, 0, 0},
                                " ^0Shoma dar ghesmat Armor faghat mitavanid adad vared konid!"
                            )
                        end
                    else
                        TriggerClientEvent(
                            "chatMessage",
                            source,
                            "[SYSTEM]",
                            {255, 0, 0},
                            " ^0Shoma dar ghesmat ID faghat mitavanid adad vared konid!"
                        )
                    end
                else
                    TriggerClientEvent(
                        "chatMessage",
                        source,
                        "[SYSTEM]",
                        {255, 0, 0},
                        " ^0Syntax vared shode eshtebah ast!"
                    )
                end
            else
                TriggerClientEvent(
                    "chatMessage",
                    source,
                    "[SYSTEM]",
                    {255, 0, 0},
                    " ^0Shoma nemitavanid dar halat ^1OffDuty ^0az command haye admini estefade konid!"
                )
            end
        else
            if xPlayer.permission_level > 1 then
                TriggerClientEvent(
                    "chatMessage",
                    source,
                    "[SYSTEM]",
                    {255, 0, 0},
                    " ^0Shoma dastresi kafi baraye estefade az in dastor nadarid!"
                )
            else
                TriggerClientEvent("chatMessage", source, "[SYSTEM]", {255, 0, 0}, " ^0Shoma ^1Admin ^0nistid!")
            end
        end
    end
)

RegisterCommand(
    "fineoffline",
    function(source, args, users)
        local xPlayer = ESX.GetPlayerFromId(source)
        if xPlayer.permission_level >= 3 then
            if xPlayer.get("aduty") then
                if args[1] and args[2] and args[3] then
                    local money = tonumber(args[2])
                    if money then
                        MySQL.Async.fetchAll(
                            "SELECT identifier, name, playerName, bank FROM users WHERE LOWER(playerName) = @playername",
                            {
                                ["@playername"] = string.lower(args[1])
                            },
                            function(data)
                                if data[1] then
                                    local zPlayer = ESX.GetPlayerFromIdentifier(data[1].identifier)
                                    if zPlayer then
                                        TriggerClientEvent(
                                            "chatMessage",
                                            source,
                                            "[SYSTEM]",
                                            {255, 0, 0},
                                            " ^0Player mored nazar online ast!"
                                        )
                                        return
                                    end

                                    local playerMoney = data[1].bank

                                    if playerMoney >= money then
                                        local identifier = data[1].identifier
                                        MySQL.Async.execute(
                                            "UPDATE users SET bank = bank - @money WHERE identifier=@identifier",
                                            {
                                                ["@identifier"] = identifier,
                                                ["@money"] = money
                                            },
                                            function(rowsChanged)
                                                if rowsChanged > 0 then
                                                    local previousmoney = playerMoney
                                                    local currentmoney = playerMoney - money

                                                    TriggerClientEvent(
                                                        "chatMessage",
                                                        source,
                                                        "[SYSTEM]",
                                                        {255, 0, 0},
                                                        " ^0Shoma az^1 " ..
                                                            data[1].name ..
                                                                " ^0Mablagh ^2" .. money .. "$ ^0kam kardid!"
                                                    )
                                                    TriggerClientEvent(
                                                        "chatMessage",
                                                        source,
                                                        "[SYSTEM]",
                                                        {255, 0, 0},
                                                        " ^0Pool ghadimi ^3" ..
                                                            data[1].name ..
                                                                " ^1" ..
                                                                    previousmoney ..
                                                                        "$^0 Pool jadid ^2" .. currentmoney .. "$"
                                                    )

                                                    local reason = table.concat(args, " ", 3)
                                                    TriggerClientEvent(
                                                        "chatMessage",
                                                        -1,
                                                        "[SYSTEM]",
                                                        {255, 0, 0},
                                                        " ^6" ..
                                                            data[1].name ..
                                                                " ^2" ..
                                                                    money .. "$ ^0 Jarime shod be elat ^3^*" .. reason
                                                    )

                                                    MySQL.Async.execute(
                                                        "INSERT INTO finelog (identifier, name, oocname, reason, fineamount, punisher, date) VALUES (@identifier, @name, @oocname, @reason, @fineamount, @punisher, @date)",
                                                        {
                                                            ["@identifier"] = identifier,
                                                            ["@name"] = data[1].playerName,
                                                            ["@oocname"] = data[1].name,
                                                            ["@reason"] = reason,
                                                            ["@fineamount"] = money,
                                                            ["@punisher"] = GetPlayerName(source),
                                                            ["@date"] = os.time()
                                                        }
                                                    )
                                                end
                                            end
                                        )
                                    else
                                        TriggerClientEvent(
                                            "chatMessage",
                                            source,
                                            "[SYSTEM]",
                                            {255, 0, 0},
                                            " ^0Pool player mored nazar baraye in meghdar az jarime kafi nist!"
                                        )
                                        TriggerClientEvent(
                                            "chatMessage",
                                            source,
                                            "[SYSTEM]",
                                            {255, 0, 0},
                                            " ^0Poole ^1" .. args[1] .. " ^2" .. playerMoney .. "$ ^0ast!"
                                        )
                                    end
                                else
                                    TriggerClientEvent(
                                        "chatMessage",
                                        source,
                                        "[SYSTEM]",
                                        {255, 0, 0},
                                        " ^0Player mored nazar vojoud nadarad!"
                                    )
                                end
                            end
                        )
                    else
                        TriggerClientEvent(
                            "chatMessage",
                            source,
                            "[SYSTEM]",
                            {255, 0, 0},
                            " ^0Shoma dar ghesmat fine faghat mitavanid adad vared konid!"
                        )
                    end
                else
                    TriggerClientEvent(
                        "chatMessage",
                        source,
                        "[SYSTEM]",
                        {255, 0, 0},
                        " ^0Syntax vared shode eshtebah ast!"
                    )
                end
            else
                TriggerClientEvent(
                    "chatMessage",
                    source,
                    "[SYSTEM]",
                    {255, 0, 0},
                    " ^0Shoma nemitavanid dar halat ^1OffDuty ^0az command haye admini estefade konid!"
                )
            end
        else
            TriggerClientEvent("chatMessage", source, "[SYSTEM]", {255, 0, 0}, " ^0Shoma admin nistid!")
        end
    end
)

TriggerEvent('es:addAdminCommand', 'fine', 3, function(source, args, user)
	if args[1] and args[2] and args[3] then
		target = tonumber(args[1])
		if target then
			if GetPlayerName(target) then
				local targetPlayer = ESX.GetPlayerFromId(target)
                local xPlayer = ESX.GetPlayerFromId(source)
				money = tonumber(args[2])
				if money then

						local previousmoney = targetPlayer.bank
						local reason = table.concat(args, " ",3)

						targetPlayer.removeBank(money)
						TriggerClientEvent('chat:addMessage', source, {'^1SYSTEM', " ^0Shoma az^1 " .. GetPlayerName(target) .. " ^0Mablagh ^2" .. money .. "$ ^0kam kardid!" } )
						TriggerEvent('DiscordBot:ToDiscord', 'fine', "Fine By Admin", "```css\nAdmin: "..xPlayer.name.." (" ..source..") SteamHex: ("..xPlayer.identifier..") \nTarget: "..targetPlayer.name .." ("..targetPlayer.source..")SteamHex: "..targetPlayer.identifier.." \nBe Elate (" .. reason .. ") Be Mablaqe ($" .. ESX.Math.GroupDigits(money) .. ") Jarime shod\n```",'user', source, true, false)
						TriggerClientEvent('chat:addMessage', -1, {
							template = '<div style="padding: 0.5vw; margin: 0.5vw; background-color: rgba(255, 131, 0, 0.4); border-radius: 3px;"><i class="fas fa-exclamation-triangle"></i> Admin Fine<br>  {1}</div>',
							args = { GetPlayerName(source), " ^1" .. GetPlayerName(target) .. "^0 Be Elate ^1^*" .. reason .. "^r^0 Be Mablaqe ^2$" .. ESX.Math.GroupDigits(money) .. "^0 Jarime shod" }
						})




				else
					TriggerClientEvent('chat:addMessage', source, {'^1SYSTEM', " ^0Shoma dar ghesmat fine faghat mitavanid adad vared konid!" } )
				end
			else
				TriggerClientEvent('chat:addMessage', source, {'^1SYSTEM', " ^0Player mored nazar online nist!" } )
			end
		else
			TriggerClientEvent('chat:addMessage', source, {'^1SYSTEM', " ^0Shoma dar ghesmat ID faghat mitavanid adad vared konid!" } )
		end
	else
		TriggerClientEvent('chat:addMessage', source, {'^1SYSTEM', " ^0Syntax vared shode eshtebah ast!" } )
	end
end, function(source, args, user)
	TriggerClientEvent('chat:addMessage', source, {'^1SYSTEM', 'Insufficient Permissions.' } )
end, {help = "Kam Kardane Pool az Player", params = {{name = "PlayerID", help = "Id Playeri ke Online hast"}, {name = "Price", help = "Mablaqe Jarime"}, {name = "Reason", help = "Dalil Jarime"}}})

RegisterCommand(
    "ajailoffline",
    function(source, args, users)
        local xPlayer = ESX.GetPlayerFromId(source)
        if xPlayer.permission_level >= 2 then
            if xPlayer.get("aduty") then
                if args[1] and args[2] and args[3] then
                    if tonumber(args[2]) then
                        local jailTime = tonumber(args[2])

                        MySQL.Async.fetchAll(
                            "SELECT identifier, name, playerName FROM users WHERE LOWER(playerName) = @playername",
                            {
                                ["@playername"] = string.lower(args[1])
                            },
                            function(data)
                                if data[1] then
                                    local zPlayer = ESX.GetPlayerFromIdentifier(data[1].identifier)
                                    if zPlayer then
                                        TriggerClientEvent(
                                            "chatMessage",
                                            source,
                                            "[SYSTEM]",
                                            {255, 0, 0},
                                            " ^0Player mored nazar online ast!"
                                        )
                                        return
                                    end

                                    local identifier = data[1].identifier
                                    local sentence = {time = jailTime, type = "admin", part = 0}
                                    MySQL.Async.execute(
                                        "UPDATE users SET jail = @data WHERE identifier = @identifier",
                                        {
                                            ["@identifier"] = identifier,
                                            ["@data"] = json.encode(sentence)
                                        },
                                        function(rowsChanged)
                                            if rowsChanged > 0 then
                                                local jailReason = table.concat(args, " ", 3)

                                                if jailTime ~= nil then
                                                    MySQL.Async.execute(
                                                        "INSERT INTO adminjaillog (identifier, name, oocname, jailreason, jailtime, punisher, date) VALUES (@identifier, @name, @oocname, @reason, @jailtime, @punisher, @date)",
                                                        {
                                                            ["@identifier"] = identifier,
                                                            ["@name"] = data[1].playerName,
                                                            ["@jailtime"] = jailTime,
                                                            ["@reason"] = jailReason,
                                                            ["@oocname"] = data[1].name,
                                                            ["@punisher"] = GetPlayerName(source),
                                                            ["@date"] = os.time()
                                                        }
                                                    )

                                                    TriggerClientEvent(
                                                        "chatMessage",
                                                        -1,
                                                        "[AdminJail]",
                                                        {255, 0, 0},
                                                        " ^1" ..
                                                            data[1].name ..
                                                                "^0 Admin jail shod be Dalile:^2 " ..
                                                                    jailReason ..
                                                                        "^0 Be modat ^3" .. jailTime .. " ^0Daghighe"
                                                    )
                                                    TriggerEvent(
                                                        "DiscordBot:ToDiscord", "ajail", "Jail Log", data[1].name .. " tavasot " .. GetPlayerName(source) .. " jail shod be modat " .. jailTime .. " daghighe be dalil: " .. jailReason,"user", true, source, false)

                                                    TriggerClientEvent(
                                                        "esx:showNotification",
                                                        source,
                                                        args[1] ..
                                                            " Zendani shod baraye ~r~~h~" .. args[2] .. " ~w~Daghighe!"
                                                    )
                                                else
                                                    TriggerClientEvent(
                                                        "esx:showNotification",
                                                        source,
                                                        "Zaman na motabar ast!"
                                                    )
                                                end
                                            end
                                        end
                                    )
                                else
                                    TriggerClientEvent(
                                        "chatMessage",
                                        source,
                                        "[SYSTEM]",
                                        {255, 0, 0},
                                        " ^0Player mored nazar vojoud nadarad!"
                                    )
                                end
                            end
                        )
                    else
                        TriggerClientEvent(
                            "chatMessage",
                            src,
                            "[SYSTEM]",
                            {255, 0, 0},
                            "Shoma dar ghesmat Zaman faghat mitavanid adad vared konid."
                        )
                    end
                else
                    TriggerClientEvent(
                        "chatMessage",
                        source,
                        "[SYSTEM]",
                        {255, 0, 0},
                        " ^0Syntax vared shode eshtebah ast!"
                    )
                end
            else
                TriggerClientEvent(
                    "chatMessage",
                    source,
                    "[SYSTEM]",
                    {255, 0, 0},
                    " ^0Shoma nemitavanid dar halat ^1OffDuty ^0az command haye admini estefade konid!"
                )
            end
        else
            TriggerClientEvent("chatMessage", source, "[SYSTEM]", {255, 0, 0}, " ^0Shoma admin nistid!")
        end
    end
)

RegisterCommand(
    "plate",
    function(source, args)
        local xPlayer = ESX.GetPlayerFromId(source)

        if xPlayer.permission_level >= 9 then
            if xPlayer.get("aduty") then
                if args[1] then
                    local licenseplate = table.concat(args, " ")
                    TriggerClientEvent("aduty:vehiclelicenseHandler", source, licenseplate)
                else
                    TriggerClientEvent(
                        "chatMessage",
                        source,
                        "[SYSTEM]",
                        {255, 0, 0},
                        " ^0Shoma hich pelaki vared nakardid!"
                    )
                end
            else
                TriggerClientEvent(
                    "chatMessage",
                    source,
                    "[SYSTEM]",
                    {255, 0, 0},
                    " ^0Shoma nemitavanid dar halat ^1OffDuty ^0az command haye admini estefade konid!"
                )
            end
        else
            TriggerClientEvent("chatMessage", source, "[SYSTEM]", {255, 0, 0}, " ^0Shoma admin nistid!")
        end
    end
)

RegisterCommand(
    "ac",
    function(source, args)
        local xPlayer = ESX.GetPlayerFromId(source)

        if xPlayer.permission_level >= 1 then
            if args[1] then
                local name = GetPlayerName(source)
                local message = table.concat(args, " ")

                for k, v in pairs(exports.esx_playerinfo:GetAdmins()) do
                    TriggerClientEvent(
                        "chatMessage",
                        v.id,
                        "",
                        {255, 0, 0},
                        "^4[^1AdminChat^4] ^3(" .. name .. "|" .. source .. ")^0: " .. "^0^*" .. message .. "^4"
                    )
                end
            else
                TriggerClientEvent(
                    "chatMessage",
                    source,
                    "[SYSTEM]",
                    {255, 0, 0},
                    " ^0Shoma nemitavanid matn khali befrestid!"
                )
            end
        else
            TriggerClientEvent("chatMessage", source, "[SYSTEM]", {255, 0, 0}, " ^0Shoma admin nistid!")
        end
    end
)

RegisterCommand(
    "kick",
    function(source, args, user)
        local xPlayer = ESX.GetPlayerFromId(source)

        if xPlayer.permission_level >= 4 then
            if args[1] and args[2] then
                target = tonumber(args[1])

                if target then
                    local name = GetPlayerName(target)
                    if name then
                        targetPlayer = ESX.GetPlayerFromId(target)
                        local message = table.concat(args, " ", 2)
                        DropPlayer(target, GetPlayerName(source) .. " Shomara kick kard be dalil: " .. message)
                        TriggerClientEvent(
                            "chatMessage",
                            -1,
                            "[Admin]",
                            {255, 0, 0},
                            "^1" ..
                                name .. " ^0tavasot ^2" .. GetPlayerName(source) .. " ^0kick shod dalil ^3" .. message
                        )
                    else
                        TriggerClientEvent(
                            "chatMessage",
                            source,
                            "[SYSTEM]",
                            {255, 0, 0},
                            " ^0Player mored nazar online nist!"
                        )
                    end
                else
                    TriggerClientEvent(
                        "chatMessage",
                        source,
                        "[SYSTEM]",
                        {255, 0, 0},
                        " ^0Shoma dar ghesmat ID faghat mitavanid adad vared konid!"
                    )
                end
            else
                TriggerClientEvent(
                    "chatMessage",
                    source,
                    "[SYSTEM]",
                    {255, 0, 0},
                    " ^0Syntax vared shode eshtebah ast!"
                )
            end
        else
            TriggerClientEvent("chatMessage", source, "[SYSTEM]", {255, 0, 0}, " ^0Shoma admin nistid!")
        end
    end
)

RegisterCommand(
    "mute",
    function(source, args)
        local xPlayer = ESX.GetPlayerFromId(source)

        if xPlayer.permission_level >= 2 then
            if xPlayer.get("aduty") then
                if args[1] then
                    local target = tonumber(args[1])
                    if args[2] then
                        local reason = table.concat(args, " ", 2)

                        if target then
                            if GetPlayerName(target) then
                                if GetPlayerName(source) ~= GetPlayerName(target) then
                                    TriggerClientEvent("chat:setMuteStatus", target, true)
                                    TriggerClientEvent("aduty:setMuteStatus", target, true)
                                    TriggerClientEvent(
                                        "chatMessage",
                                        source,
                                        "[SYSTEM]",
                                        {255, 0, 0},
                                        " ^0Shoma ^2" .. GetPlayerName(target) .. "^0 ra ^1mute ^0kardid!"
                                    )
                                    TriggerClientEvent(
                                        "chatMessage",
                                        -1,
                                        "[SYSTEM]",
                                        {255, 0, 0},
                                        "^1" ..
                                            GetPlayerName(target) ..
                                                " ^0tavasot ^2" ..
                                                    GetPlayerName(source) .. "^0 mute shod be dalil: ^3" .. reason
                                    )
                                else
                                    TriggerClientEvent(
                                        "chatMessage",
                                        source,
                                        "[SYSTEM]",
                                        {255, 0, 0},
                                        " ^0Shoma nemitavanid khodetan ra mute konid!"
                                    )
                                end
                            else
                                TriggerClientEvent(
                                    "chatMessage",
                                    source,
                                    "[SYSTEM]",
                                    {255, 0, 0},
                                    " ^0Player mored nazar online nist!"
                                )
                            end
                        else
                            TriggerClientEvent(
                                "chatMessage",
                                source,
                                "[SYSTEM]",
                                {255, 0, 0},
                                " ^0Shoma dar ghesmat ID faghat mitavanid adad vared konid!"
                            )
                        end
                    else
                        TriggerClientEvent(
                            "chatMessage",
                            source,
                            "[SYSTEM]",
                            {255, 0, 0},
                            " ^0Shoma dar ghesmat Dalil chizi vared nakardid!"
                        )
                    end
                else
                    TriggerClientEvent(
                        "chatMessage",
                        source,
                        "[SYSTEM]",
                        {255, 0, 0},
                        " ^0Shoma dar ghesmat ID chizi vared nakardid!"
                    )
                end
            else
                TriggerClientEvent(
                    "chatMessage",
                    source,
                    "[SYSTEM]",
                    {255, 0, 0},
                    " ^0Shoma nemitavanid dar halat ^1OffDuty ^0az command haye admini estefade konid!"
                )
            end
        else
            TriggerClientEvent("chatMessage", source, "[SYSTEM]", {255, 0, 0}, " ^0Shoma ^1Admin ^0nistid!")
        end
    end, false)

    RegisterCommand("muterange", function(source, args)
        local xPlayer = ESX.GetPlayerFromId(source)

        if xPlayer.permission_level >= 2 then
            if xPlayer.get("aduty") then
                if not args[1] or tonumber(args[1]) == nil then
                    TriggerClientEvent("chatMessage", source, "[SYSTEM]", {255, 0, 0}, " ^0Lotfan yek range dorost vared konid!")
                    return
                end

                if not args[2] then
                    TriggerClientEvent("chatMessage", source, "[SYSTEM]", {255, 0, 0}, " ^0Shoma dar ghesmat Dalil chizi vared nakardid!")
                    return
                end

                local range = tonumber(args[1])
                local reason = table.concat(args, " ", 2)
                local playerPed = GetPlayerPed(source)
                local playerCoords = GetEntityCoords(playerPed)
                local mutedCount = 0

                for _, playerId in ipairs(GetPlayers()) do

                    if playerId ~= source then
                        local targetPed = GetPlayerPed(playerId)
                        local targetCoords = GetEntityCoords(targetPed)

                        if #(playerCoords - targetCoords) <= range then
                            TriggerClientEvent("chat:setMuteStatus", playerId, true)
                            TriggerClientEvent("aduty:setMuteStatus", playerId, true)
                            mutedCount = mutedCount + 1

                            TriggerClientEvent(
                                "chatMessage",
                                playerId,
                                "[SYSTEM]",
                                {255, 0, 0},
                                " ^0Shoma tavasot ^2" .. GetPlayerName(source) .. "^0 mute shodid be dalil: ^3" .. reason
                            )
                        end
                    end
                end


                if mutedCount > 0 then
                    TriggerClientEvent("chatMessage", source, "[SYSTEM]", {0, 255, 0}, " ^0Tedad ^2" .. mutedCount .. " ^0nafar mute shodand!")
                else
                    TriggerClientEvent("chatMessage", source, "[SYSTEM]", {255, 0, 0}, " ^0Hich kasi dar range mored nazar nist!")
                end
            else
                TriggerClientEvent("chatMessage", source, "[SYSTEM]", {255, 0, 0}, " ^0Shoma nemitavanid dar halat ^1OffDuty ^0 az in dastoor estefade konid!")
            end
        else
            TriggerClientEvent("chatMessage", source, "[SYSTEM]", {255, 0, 0}, " ^0Shoma ^1Admin ^0nistid!")
        end
    end, false)





RegisterCommand(
    "unmute",
    function(source, args)
        local xPlayer = ESX.GetPlayerFromId(source)

        if xPlayer.permission_level >= 2 then
            if xPlayer.get("aduty") then
                if args[1] then
                    local target = tonumber(args[1])

                    if target then
                        if GetPlayerName(target) then
                            TriggerClientEvent("chat:setMuteStatus", target, false)
                            TriggerClientEvent("aduty:setMuteStatus", target, false)
                            TriggerClientEvent(
                                "chatMessage",
                                source,
                                "[SYSTEM]",
                                {255, 0, 0},
                                " ^0Shoma ^3" .. GetPlayerName(target) .. "^0 ra ^2unmute ^0kardid!"
                            )
                            TriggerClientEvent(
                                "chatMessage",
                                target,
                                "[SYSTEM]",
                                {255, 0, 0},
                                " ^0Shoma tavasot ^2" .. GetPlayerName(source) .. "^0 ^3unmute ^0shodid!"
                            )
                        else
                            TriggerClientEvent(
                                "chatMessage",
                                source,
                                "[SYSTEM]",
                                {255, 0, 0},
                                " ^0Player mored nazar online nist!"
                            )
                        end
                    else
                        TriggerClientEvent(
                            "chatMessage",
                            source,
                            "[SYSTEM]",
                            {255, 0, 0},
                            " ^0Shoma dar ghesmat ID faghat mitavanid adad vared konid!"
                        )
                    end
                else
                    TriggerClientEvent(
                        "chatMessage",
                        source,
                        "[SYSTEM]",
                        {255, 0, 0},
                        " ^0Shoma dar ghesmat ID chizi vared nakardid!"
                    )
                end
            else
                TriggerClientEvent(
                    "chatMessage",
                    source,
                    "[SYSTEM]",
                    {255, 0, 0},
                    " ^0Shoma nemitavanid dar halat ^1OffDuty ^0az command haye admini estefade konid!"
                )
            end
        else
            TriggerClientEvent("chatMessage", source, "[SYSTEM]", {255, 0, 0}, " ^0Shoma ^1Admin ^0nistid!")
        end
    end, false)

    RegisterCommand(
    "unmuterange",
    function(source, args)
        local xPlayer = ESX.GetPlayerFromId(source)

        if xPlayer.permission_level >= 2 then
            if xPlayer.get("aduty") then
                if not args[1] or tonumber(args[1]) == nil then
                    TriggerClientEvent(
                        "chatMessage",
                        source,
                        "[SYSTEM]",
                        {255, 0, 0},
                        " ^0Lotfan yek range dorost vared konid!"
                    )
                    return
                end

                local range = tonumber(args[1])
                local playerPed = GetPlayerPed(source)
                local playerCoords = GetEntityCoords(playerPed)
                local unmutedCount = 0

                for _, playerId in ipairs(GetPlayers()) do
                    if playerId ~= source then
                        local targetPed = GetPlayerPed(playerId)
                        local targetCoords = GetEntityCoords(targetPed)

                        if #(playerCoords - targetCoords) <= range then
                            TriggerClientEvent("chat:setMuteStatus", playerId, false)
                            TriggerClientEvent("aduty:setMuteStatus", playerId, false)
                            unmutedCount = unmutedCount + 1

                            TriggerClientEvent(
                                "chatMessage",
                                playerId,
                                "[SYSTEM]",
                                {0, 255, 0},
                                " ^0Shoma tavasot ^2" .. GetPlayerName(source) .. "^0 ^3unmute ^0shodid!"
                            )
                        end
                    end
                end

                if unmutedCount > 0 then
                    TriggerClientEvent(
                        "chatMessage",
                        source,
                        "[SYSTEM]",
                        {0, 255, 0},
                        " ^0Tedad ^2" .. unmutedCount .. " ^0nafar unmute shodand!"
                    )
                else
                    TriggerClientEvent(
                        "chatMessage",
                        source,
                        "[SYSTEM]",
                        {255, 0, 0},
                        " ^0Hich kasi dar range mored nazar nist!"
                    )
                end
            else
                TriggerClientEvent(
                    "chatMessage",
                    source,
                    "[SYSTEM]",
                    {255, 0, 0},
                    " ^0Shoma nemitavanid dar halat ^1OffDuty ^0az command haye admini estefade konid!"
                )
            end
        else
            TriggerClientEvent("chatMessage", source, "[SYSTEM]", {255, 0, 0}, " ^0Shoma ^1Admin ^0nistid!")
        end
    end,
    false
)

RegisterCommand(
    "resetaccount",
    function(source, args)
        local xPlayer = ESX.GetPlayerFromId(source)

        if xPlayer.permission_level >= 8 then
            if args[1] then
                if args[2] then
                    local name = args[1]
                    local reason = table.concat(args, " ", 2)

                    MySQL.Async.fetchAll(
                        "SELECT * FROM users WHERE playerName = @playername",
                        {
                            ["@playername"] = name
                        },
                        function(data)
                            if data[1] then
                                CK({identifier = data[1].identifier, name = name}, source, reason)
                            else
                                TriggerClientEvent(
                                    "chatMessage",
                                    source,
                                    "[SYSTEM]",
                                    {255, 0, 0},
                                    " ^0Player mored nazar vojoud nadarad!"
                                )
                            end
                        end
                    )
                else
                    TriggerClientEvent(
                        "chatMessage",
                        source,
                        "[SYSTEM]",
                        {255, 0, 0},
                        " ^0Shoma dar ghesmat dalil chizi vared nakardid!"
                    )
                end
            else
                TriggerClientEvent(
                    "chatMessage",
                    source,
                    "[SYSTEM]",
                    {255, 0, 0},
                    " ^0Shoma dar ghesmat esm chizi vared nakardid!"
                )
            end
        else
            TriggerClientEvent("chatMessage", source, "[SYSTEM]", {255, 0, 0}, " ^0Shoma ^1Admin ^0nistid!")
        end
    end,
    false
)

RegisterCommand(
    "removeweapon",
    function(source, args)
        local xPlayer = ESX.GetPlayerFromId(source)

        if xPlayer.permission_level >= 9 then
            if not args[1] then
                TriggerClientEvent(
                    "chatMessage",
                    source,
                    "[SYSTEM]",
                    {255, 0, 0},
                    " ^0Shoma dar ghesmat esm gun chizi vared nakardid!"
                )
                return
            end

            local weapon = string.upper(args[1])
            local gangs, properties, totalusers, totalvehicles, desiredWeapon = 0, 0, 0, 0, 0
            local gangsd, propertiesd, totalusersd, totalvehiclesd = 0, 0, 0, 0

            MySQL.Async.fetchAll(
                "SELECT * FROM datastore_data",
                {},
                function(data)
                    for i = 1, #data do
                        if data[i].name == "property" then
                            local weaponData = json.decode(data[i].data)
                            if weaponData.weapons then
                                local found = false

                                for j, v in ipairs(weaponData.weapons) do
                                    if v.name == weapon then
                                        found = true

                                        table.remove(weaponData.weapons, j)
                                        desiredWeapon = desiredWeapon + 1
                                        propertiesd = propertiesd + 1
                                    end
                                end

                                if found then
                                    MySQL.Async.execute(
                                        "UPDATE datastore_data SET `data` = @data WHERE `owner` = @identifier",
                                        {["@identifier"] = data[i].owner, ["@data"] = json.encode(weaponData)}
                                    )
                                end
                            end

                            properties = properties + 1
                        elseif string.match(data[i].name, "gang") then
                            local weaponData = json.decode(data[i].data)
                            if weaponData.weapons then
                                local found = false

                                for j, v in ipairs(weaponData.weapons) do
                                    if v.name == weapon then
                                        found = true

                                        table.remove(weaponData.weapons, j)
                                        desiredWeapon = desiredWeapon + 1
                                        gangsd = gangsd + 1
                                    end
                                end

                                if found then
                                    MySQL.Async.execute(
                                        "UPDATE datastore_data SET `data` = @data WHERE `name` = @name",
                                        {["@identifier"] = data[i].name, ["@data"] = json.encode(weaponData)}
                                    )
                                end
                            end

                            gangs = gangs + 1
                        end
                    end

                    MySQL.Async.fetchAll(
                        "SELECT * FROM users",
                        {},
                        function(users)
                            for i = 1, #users do
                                if users[i].loadout then
                                    local loadout = json.decode(users[i].loadout)
                                    if loadout then
                                        local found = false

                                        for j, v in ipairs(loadout) do
                                            if v.name == weapon then
                                                found = true

                                                table.remove(loadout, j)
                                                desiredWeapon = desiredWeapon + 1
                                                totalusersd = totalusersd + 1
                                            end
                                        end

                                        if found then
                                            MySQL.Async.execute(
                                                "UPDATE users SET `loadout` = @data WHERE `identifier` = @identifier",
                                                {
                                                    ["@identifier"] = users[i].identifier,
                                                    ["@data"] = json.encode(loadout)
                                                }
                                            )
                                        end
                                    end
                                end

                                totalusers = totalusers + 1
                            end

                            MySQL.Async.fetchAll(
                                "SELECT * FROM trunk_inventory",
                                {},
                                function(vehicles)
                                    for i = 1, #vehicles do
                                        if vehicles[i].data then
                                            local loadout = json.decode(vehicles[i].data)
                                            if loadout.weapons then
                                                local found = false

                                                for j, v in ipairs(loadout.weapons) do
                                                    if v.name == weapon then
                                                        found = true

                                                        table.remove(loadout.weapons, j)
                                                        desiredWeapon = desiredWeapon + 1
                                                        totalvehiclesd = totalvehiclesd + 1
                                                    end
                                                end

                                                if found then
                                                    MySQL.Async.execute(
                                                        "UPDATE trunk_inventory SET `data` = @data WHERE `id` = @id",
                                                        {["@id"] = vehicles[i].id, ["@data"] = json.encode(loadout)}
                                                    )
                                                end
                                            end
                                        end

                                        totalvehicles = totalvehicles + 1
                                    end

                                    local info = {
                                        iniator = "Purge wave",
                                        weapon = weapon,
                                        utotal = totalusers,
                                        udtotal = totalusersd,
                                        ptotal = properties,
                                        pdtotal = propertiesd,
                                        gtotal = gangs,
                                        gdtotal = gangsd,
                                        vtotal = totalvehicles,
                                        vdtotal = totalvehiclesd,
                                        dtotal = desiredWeapon
                                    }
                                    TriggerEvent("esx_logger:log2", source, info)
                                end
                            )
                        end
                    )
                end
            )
        else
            TriggerClientEvent(
                "chatMessage",
                source,
                "[SYSTEM]",
                {255, 0, 0},
                " ^0Shoma dastresi kafi baraye esfade az in dastor ra nadarid!"
            )
        end
    end,
    false
)

RegisterCommand(
    "countweapon",
    function(source, args)
        local xPlayer = ESX.GetPlayerFromId(source)

        if xPlayer.permission_level >= 8 then
            if not args[1] then
                TriggerClientEvent(
                    "chatMessage",
                    source,
                    "[SYSTEM]",
                    {255, 0, 0},
                    " ^0Shoma dar ghesmat esm gun chizi vared nakardid!"
                )
                return
            end

            local weapon = string.upper(args[1])
            local gangs, properties, totalusers, totalvehicles, desiredWeapon = 0, 0, 0, 0, 0
            local gangsd, propertiesd, totalusersd, totalvehiclesd = 0, 0, 0, 0

            MySQL.Async.fetchAll(
                "SELECT * FROM datastore_data",
                {},
                function(data)
                    for i = 1, #data do
                        if data[i].name == "property" then
                            local weaponData = json.decode(data[i].data)
                            if weaponData.weapons then
                                for j, v in ipairs(weaponData.weapons) do
                                    if v.name == weapon then

                                        MySQL.Async.fetchAll(
                                            "SELECT playerName, job FROM users WHERE identifier = @identifier",
                                            {["@identifier"] = data[i].owner},
                                            function(info)
                                                MySQL.Async.execute(
                                                    "INSERT INTO counter VALUES(@owner, @type, @job)",
                                                    {
                                                        ["@owner"] = info[1].playerName,
                                                        ["@type"] = "Property Inventory",
                                                        ["@job"] = info[1].job
                                                    }
                                                )
                                            end
                                        )

                                        desiredWeapon = desiredWeapon + 1
                                        propertiesd = propertiesd + 1
                                    end
                                end
                            end

                            properties = properties + 1
                        elseif string.match(data[i].name, "gang") then
                            local weaponData = json.decode(data[i].data)
                            if weaponData.weapons then
                                for j, v in ipairs(weaponData.weapons) do
                                    if v.name == weapon then


                                        MySQL.Async.execute(
                                            "INSERT INTO counter VALUES(@owner, @type, @job)",
                                            {["@owner"] = data[i].name, ["@type"] = "Gang Inventory", ["@job"] = "N/A"}
                                        )
                                        desiredWeapon = desiredWeapon + 1
                                        gangsd = gangsd + 1
                                    end
                                end
                            end

                            gangs = gangs + 1
                        end
                    end

                    MySQL.Async.fetchAll(
                        "SELECT * FROM users",
                        {},
                        function(users)
                            for i = 1, #users do
                                if users[i].loadout then
                                    local loadout = json.decode(users[i].loadout)
                                    if loadout then
                                        for j, v in ipairs(loadout) do
                                            if v.name == weapon then


                                                MySQL.Async.execute(
                                                    "INSERT INTO counter VALUES(@owner, @type, @job)",
                                                    {
                                                        ["@owner"] = users[i].playerName,
                                                        ["@type"] = "User Inventory",
                                                        ["@job"] = users[i].job
                                                    }
                                                )
                                                desiredWeapon = desiredWeapon + 1
                                                totalusersd = totalusersd + 1
                                            end
                                        end
                                    end
                                end

                                totalusers = totalusers + 1
                            end

                            MySQL.Async.fetchAll(
                                "SELECT * FROM trunk_inventory",
                                {},
                                function(vehicles)
                                    for i = 1, #vehicles do
                                        if vehicles[i].data then
                                            local loadout = json.decode(vehicles[i].data)
                                            if loadout.weapons then
                                                for j, v in ipairs(loadout.weapons) do
                                                    if v.name == weapon then


                                                        MySQL.Async.execute(
                                                            "INSERT INTO counter VALUES(@owner, @type, @job)",
                                                            {
                                                                ["@owner"] = users[i].playerName,
                                                                ["@type"] = "Trunk Inventory",
                                                                ["@job"] = users[i].job
                                                            }
                                                        )
                                                        desiredWeapon = desiredWeapon + 1
                                                        totalvehiclesd = totalvehiclesd + 1
                                                    end
                                                end
                                            end
                                        end

                                        totalvehicles = totalvehicles + 1
                                    end

                                    local info = {
                                        iniator = "Count wave",
                                        weapon = weapon,
                                        utotal = totalusers,
                                        udtotal = totalusersd,
                                        ptotal = properties,
                                        pdtotal = propertiesd,
                                        gtotal = gangs,
                                        gdtotal = gangsd,
                                        vtotal = totalvehicles,
                                        vdtotal = totalvehiclesd,
                                        dtotal = desiredWeapon
                                    }
                                    TriggerEvent("esx_logger:log2", source, info)
                                end
                            )
                        end
                    )
                end
            )
        else
            TriggerClientEvent(
                "chatMessage",
                source,
                "[SYSTEM]",
                {255, 0, 0},
                " ^0Shoma dastresi kafi baraye esfade az in dastor ra nadarid!"
            )
        end
    end,
    false
)

RegisterCommand(
    "disband",
    function(source, args)
	local xPlayer = ESX.GetPlayerFromId(source)
	if xPlayer.permission_level >= 9 then

            if args[1] then
                if args[2] then
                    local gang = args[1]
                    local reason = table.concat(args, " ", 2)

                    MySQL.Async.fetchAll(
                        "SELECT gang_name FROM gangs_data WHERE gang_name = @gang",
                        {
                            ["@gang"] = gang
                        },
                        function(data)
                            if data[1] then
                                MySQL.Async.execute("DELETE FROM gangs WHERE name = @gang", {["@gang"] = gang})
                                MySQL.Async.execute(
                                    "DELETE FROM gang_grades WHERE gang_name = @gang",
                                    {["@gang"] = gang}
                                )
                                MySQL.Async.execute(
                                    "DELETE FROM gang_account WHERE name = @gang",
                                    {["@gang"] = "gang_" .. string.lower(gang)}
                                )
                                MySQL.Async.execute(
                                    "DELETE FROM addon_inventory_items WHERE inventory_name = @gang",
                                    {["@gang"] = "gang_" .. string.lower(gang)}
                                )
                                MySQL.Async.execute(
                                    "DELETE FROM gang_account_data WHERE gang_name = @gang",
                                    {["@gang"] = "gang_" .. string.lower(gang)}
                                )
                                MySQL.Async.execute(
                                    "DELETE FROM datastore_data WHERE name = @gang",
                                    {["@gang"] = "gang_" .. string.lower(gang)}
                                )
                                MySQL.Async.execute(
                                    "DELETE FROM datastore WHERE name = @gang",
                                    {["@gang"] = "gang_" .. string.lower(gang)}
                                )
                                MySQL.Async.execute(
                                    "DELETE FROM addon_inventory WHERE name = @gang",
                                    {["@gang"] = "gang_" .. string.lower(gang)}
                                )
                                MySQL.Async.execute(
                                    "DELETE FROM gangs_data WHERE gang_name = @gang",
                                    {["@gang"] = gang}
                                )
                                MySQL.Async.execute(
                                    "DELETE FROM owned_vehicles WHERE owner = @gang",
                                    {["@gang"] = gang}
                                )
                                MySQL.Async.execute(
                                    'UPDATE users SET gang = "nogang" WHERE gang = @gang',
                                    {["@gang"] = gang}
                                )
                                local xPlayers = ESX.GetPlayers()

                                for i = 1, #xPlayers, 1 do
                                    local xPlayer = ESX.GetPlayerFromId(xPlayers[i])

                                    if xPlayer.gang.name == gang then
                                        xPlayer.setGang("nogang", 0)
                                    end
                                end
                                TriggerEvent(
                                    "DiscordBot:ToDiscord",
                                    "disband",
                                    "Disband Log",
                                    GetPlayerName(source) ..
                                        " gange " .. gang .. " ra disband kard be dalil: " .. reason,
                                    "user",
                                    true,
                                    source,
                                    false
                                )
                                TriggerClientEvent(
                                    "chatMessage",
                                    source,
                                    "[SYSTEM]",
                                    {255, 0, 0},
                                    " ^0gang ^1" .. gang .. " ^0ba ^2movafaghiat ^0disband shod, dalil: " .. reason
                                )
                                TriggerClientEvent(
                                    "chatMessage",
                                    -1,
                                    "[SYSTEM]",
                                    {255, 0, 0},
                                    " ^0gang ^2" .. gang .. " ^0be dalil ^1" .. reason .. " ^0disband shod!"
                                )
                            else
                                TriggerClientEvent(
                                    "chatMessage",
                                    source,
                                    "[SYSTEM]",
                                    {255, 0, 0},
                                    " ^0Family mored nazar vojoud nadarad!"
                                )
                            end
                        end
                    )
                else
                    TriggerClientEvent(
                        "chatMessage",
                        source,
                        "[SYSTEM]",
                        {255, 0, 0},
                        " ^0Shoma dar ghesmat dalil chizi vared nakardid!"
                    )
                end
            else
                TriggerClientEvent(
                    "chatMessage",
                    source,
                    "[SYSTEM]",
                    {255, 0, 0},
                    " ^0Shoma dar ghesmat esm family chizi vared nakardid!"
                )
            end

		else
        TriggerClientEvent("chatMessage", source, "[SYSTEM]", {255, 0, 0}, " ^0Shoma ^1Admin High Rank ^0Nistid!")
		end
    end,
    false

)

RegisterCommand(
    "fuel",
    function(source, args)
        local xPlayer = ESX.GetPlayerFromId(source)

        if xPlayer.permission_level >= 3 then
            if xPlayer.get("aduty") then
                local target

                if not args[1] then
                    target = source
                else
                    target = tonumber(args[1])
                    if target then
                        if not GetPlayerName(target) then
                            TriggerClientEvent(
                                "chatMessage",
                                source,
                                "[SYSTEM]",
                                {255, 0, 0},
                                " ^0ID vared shode eshtebah ast!"
                            )
                            return
                        end
                    else
                        TriggerClientEvent(
                            "chatMessage",
                            source,
                            "[SYSTEM]",
                            {255, 0, 0},
                            " ^0Shoma dar ghesmat ID faghat mitavanid adad vared konid!"
                        )
                        return
                    end
                end

                TriggerClientEvent("aduty:refuel", target)
            else
                TriggerClientEvent(
                    "chatMessage",
                    source,
                    "[SYSTEM]",
                    {255, 0, 0},
                    " ^0Shoma nemitavanid dar halat ^1OffDuty ^0az command haye admini estefade konid!"
                )
            end
        else
            TriggerClientEvent("chatMessage", source, "[SYSTEM]", {255, 0, 0}, " ^0Shoma ^1Admin ^0nistid!")
        end
    end,
    false
)

RegisterCommand(
    "vanish",
    function(source, args)
        local xPlayer = ESX.GetPlayerFromId(source)

        if xPlayer.permission_level >= 2 then
            if xPlayer.get("aduty") then
                TriggerClientEvent("aduty:vanish", source)
            else
                TriggerClientEvent(
                    "chatMessage",
                    source,
                    "[SYSTEM]",
                    {255, 0, 0},
                    " ^0Shoma nemitavanid dar halat ^1OffDuty ^0az command haye admini estefade konid!"
                )
            end
        else
            TriggerClientEvent("chatMessage", source, "[SYSTEM]", {255, 0, 0}, " ^0Shoma ^1Admin ^0nistid!")
        end
    end,
    false
)

RegisterCommand(
    "kickall",
    function(source, args)
        local xPlayer = ESX.GetPlayerFromId(source)

        if source == 0 or xPlayer.permission_level >= 9 then
            KickAll()
        else
            TriggerClientEvent(
                "chatMessage",
                source,
                "[SYSTEM]",
                {255, 0, 0},
                " ^0Shoma ^1Dastresi ^0kafi baraye estefade az in dastor ra nadarid!"
            )
        end
    end,
    false
)

RegisterCommand("timeplay", function(source, args)
	local xPlayer = ESX.GetPlayerFromId(source)
	local Target = source
	if xPlayer.permission_level >= 1 then
		if tonumber(args[1]) then
			Target = tonumber(args[1])
		else
			Target = source
		end
	else
		Target = source
	end
	MySQL.Async.fetchAll("SELECT timePlay FROM users WHERE identifier = @identifier", {
		["@identifier"] = GetPlayerIdentifier(Target)
	}, function(result)
		if result[1] then
			if xPlayer.permission_level >= 1 then
				local timeplay = result[1].timePlay
				timeplay = timeplay / 60
				timeplay = timeplay / 60
				TriggerClientEvent("chatMessage", source, "[SYSTEM]", {255, 0, 0}, " ^0Timeplay "..GetPlayerName(Target).." : ^3" .. tostring(math.floor(timeplay)) .. "^0 saat ast!")
			else
				local timeplay = result[1].timePlay
				timeplay = timeplay / 60
				timeplay = timeplay / 60
				TriggerClientEvent("chatMessage", source, "[SYSTEM]", {255, 0, 0}, " ^0Timeplay shoma: ^3" .. tostring(math.floor(timeplay)) .. "^0 saat ast!")
			end
		else
			TriggerClientEvent("chatMessage", source, "[SYSTEM]", {255, 0, 0}, " ^0Timeplay shoma sabt nashode ast!")
		end
	end)
end, false)









