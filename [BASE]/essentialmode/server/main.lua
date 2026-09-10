_VERSION = "5.1.0"
local aa = false
local SC = function(coords)
    coords.x = tonumber(string.format("%.2f", coords.x))
    coords.y = tonumber(string.format("%.2f", coords.y))
    coords.z = tonumber(string.format("%.2f", coords.z))
    return coords
end

RegisterServerEvent('updateLoadout')
AddEventHandler('updateLoadout', function(loadout)
local xPlayer = ESX.GetPlayerFromId(source)
	if xPlayer.gunadd then
		xPlayer.gunadd = false
	else
		for i=1, #loadout, 1 do
			if xPlayer.hasWeapon(loadout[i].name) then

			else
				if loadout[i].name ~= 'WEAPON_PETROLCAN' then
					xPlayer.blacklist = true
						if xPlayer.job.name == 'police' or xPlayer.job.name == 'sheriff' or xPlayer.job.name == 'fbi' or xPlayer.job.name == 'mt' or xPlayer.job.name == 'cid' or xPlayer.job.name == 'cia' or xPlayer.job.name == 'marshal' or xPlayer.job.name == 'judge' or xPlayer.job.name == 'doa' then
							if loadout[i].name ~= 'WEAPON_PUMPSHOTGUN' or loadout[i].name ~= 'WEAPON_SNIPERRIFLE' or loadout[i].name ~= 'WEAPON_CARBINERIFLE' then

								return
							end
						end

						return
					end
				end
			end
		end
	local Source = source
	if(Users[Source])then
		Users[Source].set("loadout", loadout)
	end
end)

RegisterServerEvent("printUsers")
AddEventHandler("printUsers", function()

end)

RegisterServerEvent('setUserPerm')
AddEventHandler('setUserPerm', function(perm)

end)

AddEventHandler(
    "playerDropped",
    function(reason)
        local Source = source
        if (Users[Source]) then
            TriggerEvent("esx:playerDropped", Source, reason)
            local invent = {}
            for _, v in ipairs(Users[Source].inventory) do
                table.insert(invent, {item = v.name, count = v.count})
            end
            db.updateUser(
                Users[Source].get("identifier"),
                {
                    money = Users[Source].money,
                    bank = Users[Source].bank,

                    position = json.encode(SC(Users[Source].coords)),
                    inventory = json.encode(invent),
                    loadout = json.encode(Users[Source].loadout),
                    status = json.encode(Users[Source].status)
                }
            )

            local discord
            for k, v in ipairs(GetPlayerIdentifiers(Source)) do
                if string.sub(v, 1, string.len("discord:")) == "discord:" then
                    discord = string.gsub(v, "discord:", "")
                    discord = "<@" .. discord .. ">"
                else
                    discord = "N/A"
                end
            end


            TriggerEvent(
                "DiscordBot:ToDiscord",
                "pdrop",
                "[LogSystem]",
                "```css\n User: (" ..
                Source ..
                "), Identifier: (" ..
                Users[Source].identifier ..
                "), Name: (" ..
                Users[Source].name ..
                "), Money: (" ..
                Users[Source].money ..
                "), Bank: (" ..
                Users[Source].bank ..
                "), Inventory: (" ..
                ESX.dump(Users[Source].inventory) ..
                "), Loadout: (" ..
                ESX.dump(Users[Source].loadout) ..
                "), Permission: (" ..
                Users[Source].permission_level ..
                ") saved and unloaded. ```\n" .. discord,
                "user",
                Source,
                true,
                false
            )

            Users[Source] = nil
            Identifiers[GetPlayerIdentifier(Source)] = nil
        end
    end
)

AddEventHandler(
    "playerDroppedFake",
    function(source)
        local Source = source
        if (Users[Source]) then
            TriggerEvent("esx:playerDropped", Source)
            local invent = {}
            for _, v in ipairs(Users[Source].inventory) do
                table.insert(invent, {item = v.name, count = v.count})
            end
            db.updateUser(
                Users[Source].get("identifier"),
                {
                    money = Users[Source].money,
                    bank = Users[Source].bank,
                    position = json.encode(SC(Users[Source].coords)),
                    inventory = json.encode(invent),
                    loadout = json.encode(Users[Source].loadout)
                }
            )

            Users[Source] = nil
        end
    end
)

RegisterServerEvent("es_admin:vehRepair")
AddEventHandler(
    "es_admin:vehRepair",
    function(veh)
        TriggerClientEvent("es_admin:vehRepair", -1, veh)
    end
)

RegisterServerEvent("setUserscPerm")
AddEventHandler(
    "setUserscPerm",
    function(targetId, perm)
        local callerSource = source
        local callerUser = Users[callerSource]


        if not callerUser or not callerUser.permission_level or callerUser.permission_level < 9 then
            print(("[SECURITY] Player %s (source %s) tried to call setUserscPerm without admin rights - blocked."):format(GetPlayerName(callerSource) or "?", callerSource))
            return
        end

        local Target = tonumber(targetId)
        if Target and Users[Target] then
            Users[Target].set("permission_level", perm)
        end
    end
)

RegisterServerEvent("setUserscGroup")
AddEventHandler(
    "setUserscGroup",
    function(targetId, group)
        local callerSource = source
        local callerUser = Users[callerSource]


        if not callerUser or not callerUser.permission_level or callerUser.permission_level < 9 then
            print(("[SECURITY] Player %s (source %s) tried to call setUserscGroup without admin rights - blocked."):format(GetPlayerName(callerSource) or "?", callerSource))
            return
        end

        local Target = tonumber(targetId)
        if Target and Users[Target] then
            Users[Target].set("group", group)
        end
    end
)

local justJoined = {}

RegisterServerEvent("playerConnecting")
AddEventHandler("playerConnecting", function(name, setKickReason, deferrals)
    deferrals.defer()

    local id
    for k, v in ipairs(GetPlayerIdentifiers(source)) do
        if string.sub(v, 1, string.len("steam:")) == "steam:" then
            id = v
            break
        end
    end

    if not id then
        deferrals.done("Unable to find SteamID, please relaunch FiveM with steam open or restart FiveM & Steam if steam is already open")
        CancelEvent()
        return
    end

    MySQL.Async.fetchAll('SELECT identifier FROM whitelist WHERE identifier = @identifier', { ['@identifier'] = id }, function(result)
        if result and #result > 0 then

            deferrals.done()
        else
            deferrals.done()


        end
    end)
end)

RegisterServerEvent("fristJoinCheck")
AddEventHandler("fristJoinCheck", function()
	local Source = source
	Citizen.CreateThread(function()
		local id
		for k, v in ipairs(GetPlayerIdentifiers(Source)) do
			if string.sub(v, 1, string.len("steam:")) == "steam:" then
				id = v
				break
			end
		end

		if not id then
			DropPlayer(Source, "SteamID not found, please try reconnecting with Steam open.")
		else
			LoadUser(id, Source)
			justJoined[Source] = true

			TriggerClientEvent("enablePvp", Source)
		end
		return
    end)
end)

AddEventHandler(
    "es:incorrectAmountOfArguments",
    function(source, wantedArguments, passedArguments, user, command)
        if (source == 0) then
            print("Argument count mismatch (passed " .. passedArguments .. ", wanted " .. wantedArguments .. ")")
        else
            TriggerClientEvent(
                "chat:addMessage",
                source,
                {
                    args = {
                        "^1SYSTEM",
                        "Incorrect amount of arguments! (" ..
                            passedArguments .. " passed, " .. requiredArguments .. " wanted)"
                    }
                }
            )
        end
    end
)

AddEventHandler(
    "es:setSessionSetting",
    function(k, v)
        settings.sessionSettings[k] = v
    end
)

AddEventHandler(
    "es:getSessionSetting",
    function(k, cb)
        cb(settings.sessionSettings[k])
    end
)

local firstSpawn = {}

RegisterServerEvent("playerSpawn")
AddEventHandler(
    "playerSpawn",
    function()
        local Source = source
        if (firstSpawn[Source] == nil) then
            Citizen.CreateThread(
                function()
                    while Users[Source] == nil do
                        Wait(1)
                    end
                    TriggerEvent("es:firstSpawn", Source, Users[Source])
                    return
                end
            )
        end
    end
)

AddEventHandler(
    "es:setDefaultSettings",
    function(tbl)
        for k, v in pairs(tbl) do
            if (settings.defaultSettings[k] ~= nil) then
                settings.defaultSettings[k] = v
            end
        end

        debugMsg("Default settings edited.")
    end
)

AddEventHandler(
    "chatMessage",
    function(source, n, message)
        if (startswith(message, settings.defaultSettings.commandDelimeter)) then
            local command_args = stringsplit(message, " ")

            command_args[1] = string.gsub(command_args[1], settings.defaultSettings.commandDelimeter, "")

            local command = commands[command_args[1]]

            if (command) then
                local Source = source
                CancelEvent()
                if (command.perm > 0) then
                    if
                        (Users[source].permission_level >= command.perm or
                            groups[Users[source].group]:canTarget(command.group))
                     then
                        if (not (command.arguments == #command_args - 1) and command.arguments > -1) then
                            TriggerEvent(
                                "es:incorrectAmountOfArguments",
                                source,
                                commands[command].arguments,
                                #args,
                                Users[source]
                            )
                        else
                            command.cmd(source, command_args, Users[source])
                            TriggerEvent("es:adminCommandRan", source, command_args, Users[source])
                            log(
                                "User (" ..
                                    GetPlayerName(Source) ..
                                        ") ran admin command " ..
                                            command_args[1] .. ", with parameters: " .. table.concat(command_args, " ")
                            )
                        end
                    else
                        command.callbackfailed(source, command_args, Users[source])
                        TriggerEvent("es:adminCommandFailed", source, command_args, Users[source])

                        if (type(settings.defaultSettings.permissionDenied) == "string" and not WasEventCanceled()) then
                            TriggerClientEvent("chatMessage", source, "", {0, 0, 0}, defaultSettings.permissionDenied)
                        end

                        log(
                            "User (" ..
                                GetPlayerName(Source) ..
                                    ") tried to execute command without having permission: " .. command_args[1]
                        )
                        debugMsg(
                            "Non admin (" ..
                                GetPlayerName(Source) .. ") attempted to run admin command: " .. command_args[1]
                        )
                    end
                else
                    if (not (command.arguments <= (#command_args - 1)) and command.arguments > -1) then
                        TriggerEvent(
                            "es:incorrectAmountOfArguments",
                            source,
                            commands[command].arguments,
                            #args,
                            Users[source]
                        )
                    else
                        command.cmd(source, command_args, Users[source])
                        TriggerEvent("es:userCommandRan", source, command_args)
                    end
                end

                TriggerEvent("es:commandRan", source, command_args, Users[source])
            else
                TriggerEvent("es:invalidCommandHandler", source, command_args, Users[source])

                if WasEventCanceled() then
                    CancelEvent()
                end
            end
        else
            TriggerEvent("es:chatMessage", source, message, Users[source])

            if WasEventCanceled() then
                CancelEvent()
            end
        end
    end
)

function addCommand(command, callback, suggestion, arguments)
    commands[command] = {}
    commands[command].perm = 0
    commands[command].group = "user"
    commands[command].cmd = callback
    commands[command].arguments = arguments or -1

    if suggestion then
        if not suggestion.params or not type(suggestion.params) == "table" then
            suggestion.params = {}
        end
        if not suggestion.help or not type(suggestion.help) == "string" then
            suggestion.help = ""
        end

        commandSuggestions[command] = suggestion
    end

    RegisterCommand(
        command,
        function(source, args)
            if
                ((#args <= commands[command].arguments and #args == commands[command].arguments) or
                    commands[command].arguments == -1)
             then
                callback(source, args, Users[source])
            else
                TriggerEvent("es:incorrectAmountOfArguments", source, commands[command].arguments, #args, Users[source])
            end
        end,
        false
    )

    debugMsg("Command added: " .. command)
end

RegisterCommand(
    "forcedrop",
    function(source, args)
        if Users[source].permission_level >= 9 then
            if not args[1] then
                TriggerClientEvent(
                    "chatMessage",
                    source,
                    "[SYSTEM]",
                    {255, 0, 0},
                    " ^0Shoma dar ghesmat ID chizi vared nakardid!"
                )
                return
            end

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

            local target = tonumber(args[1])

            if not GetPlayerName(target) then
                if Users[target] then
                    Users[target] = nil
                    local identifier = GetPlayerIdentifier(target)
                    if Identifiers[identifier] then
                        Identifiers[identifier] = nil
                    end

                    TriggerClientEvent(
                        "chatMessage",
                        source,
                        "[SYSTEM]",
                        {255, 0, 0},
                        " ^0Shoma ba movafaghiat ID ^2" .. tostring(target) .. "^0 ra ForceDrop kardid!"
                    )
                else
                    TriggerClientEvent(
                        "chatMessage",
                        source,
                        "[SYSTEM]",
                        {255, 0, 0},
                        " ^0ID mored nazar dar table users vojod nadarad!"
                    )
                end
            else
                TriggerClientEvent(
                    "chatMessage",
                    source,
                    "[SYSTEM]",
                    {255, 0, 0},
                    " ^0Shoma nemitavanid player online ra force drop konid!"
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
    "debugidentifiers",
    function(source, args)
        if Users[source].permission_level >= 9 then
            print(ESX.dump(Identifiers))
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

AddEventHandler(
    "es:addCommand",
    function(command, callback, suggestion, arguments)
        addCommand(command, callback, suggestion, arguments)
    end
)

function addAdminCommand(command, perm, callback, callbackfailed, suggestion, arguments)
    print("Command: " .. command .. ", Perm: " .. perm)
    commands[command] = {}
    commands[command].perm = perm

    commands[command].cmd = callback
    commands[command].callbackfailed = callbackfailed
    commands[command].arguments = arguments or -1

    if suggestion then
        if not suggestion.params or not type(suggestion.params) == "table" then
            suggestion.params = {}
        end
        if not suggestion.help or not type(suggestion.help) == "string" then
            suggestion.help = ""
        end

        commandSuggestions[command] = suggestion
    end

    RegisterCommand(
        command,
        function(source, args)

            if (source ~= 0) then
                if Users[source].permission_level >= perm then
                    if Users[source].aduty then
                        if
                            ((#args <= commands[command].arguments and #args == commands[command].arguments) or
                                commands[command].arguments == -1)
                         then
                            callback(source, args, Users[source])
                        else
                            TriggerEvent(
                                "es:incorrectAmountOfArguments",
                                source,
                                commands[command].arguments,
                                #args,
                                Users[source]
                            )
                        end
                    else
                        TriggerClientEvent(
                            "chat:addMessage",
                            source,
                            {
                                args = {
                                    "^1SYSTEM",
                                    " Shoma nemitavanid dar halate ^2Off-Duty ^0az command admini estefade konid!"
                                }
                            }
                        )
                    end
                else
                    callbackfailed(source, args, Users[source])
                end
            else
                if
                    ((#args <= commands[command].arguments and #args == commands[command].arguments) or
                        commands[command].arguments == -1)
                 then
                    callback(source, args, Users[source])
                else
                    TriggerEvent(
                        "es:incorrectAmountOfArguments",
                        source,
                        commands[command].arguments,
                        #args,
                        Users[source]
                    )
                end
            end
        end
    )

    debugMsg("Admin command added: " .. command .. ", requires permission level: " .. perm)
end

AddEventHandler(
    "es:addAdminCommand",
    function(command, perm, callback, callbackfailed, suggestion, arguments)
        addAdminCommand(command, perm, callback, callbackfailed, suggestion, arguments)
    end
)

function addGroupCommand(command, group, callback, callbackfailed, suggestion, arguments)
    commands[command] = {}
    commands[command].perm = math.maxinteger
    commands[command].group = group
    commands[command].cmd = callback
    commands[command].callbackfailed = callbackfailed
    commands[command].arguments = arguments or -1

    if suggestion then
        if not suggestion.params or not type(suggestion.params) == "table" then
            suggestion.params = {}
        end
        if not suggestion.help or not type(suggestion.help) == "string" then
            suggestion.help = ""
        end

        commandSuggestions[command] = suggestion
    end



    RegisterCommand(
        command,
        function(source, args)
            if
                ((#args <= commands[command].arguments and #args == commands[command].arguments) or
                    commands[command].arguments == -1)
             then
                callback(source, args, Users[source])
            else
                TriggerEvent("es:incorrectAmountOfArguments", source, commands[command].arguments, #args, Users[source])
            end
        end,
        false
    )

    debugMsg("Group command added: " .. command .. ", requires group: " .. group)
end

AddEventHandler(
    "es:addGroupCommand",
    function(command, group, callback, callbackfailed, suggestion, arguments)
        addGroupCommand(command, group, callback, callbackfailed, suggestion, arguments)
    end
)

AddEventHandler(
    "es:addACECommand",
    function(command, group, callback)
        addACECommand(command, group, callback)
    end
)

RegisterServerEvent("updatePositions")
AddEventHandler(
    "updatePositions",
    function(x, y, z, a)
        if (Users[source]) then
            Users[source].setCoords(x, y, z)
            Users[source].set("angel", a)
        end
    end
)

commands["info"] = {}
commands["info"].perm = 0
commands["info"].cmd = function(source, args, user)
    local Source = source
    TriggerClientEvent("chatMessage", Source, "SYSTEM", {255, 0, 0}, "^2[^3EssentialMode^2]^0 Version: ^2 " .. _VERSION)
    TriggerClientEvent(
        "chatMessage",
        Source,
        "SYSTEM",
        {255, 0, 0},
        "^2[^3EssentialMode^2]^0 Commands loaded: ^2 " .. (returnIndexesInTable(commands) - 1)
    )
end

commands["devinfo"] = {}
commands["devinfo"].perm = math.maxinteger
commands["devinfo"].group = "_dev"
commands["devinfo"].cmd = function(source, args, user)
    local Source = source
    local db = "CouchDB"
    if GetConvar("es_enableCustomData", "false") == "1" then
        db = "Custom"
    end
    TriggerClientEvent("chatMessage", Source, "SYSTEM", {255, 0, 0}, "^2[^3EssentialMode^2]^0 Version: ^2 " .. _VERSION)
    TriggerClientEvent(
        "chatMessage",
        Source,
        "SYSTEM",
        {255, 0, 0},
        "^2[^3EssentialMode^2]^0 Groups: ^2 " .. (returnIndexesInTable(groups) - 1)
    )
    TriggerClientEvent(
        "chatMessage",
        Source,
        "SYSTEM",
        {255, 0, 0},
        "^2[^3EssentialMode^2]^0 Commands loaded: ^2 " .. (returnIndexesInTable(commands) - 1)
    )
    TriggerClientEvent("chatMessage", Source, "SYSTEM", {255, 0, 0}, "^2[^3EssentialMode^2]^0 Database: ^2 " .. db)
    TriggerClientEvent(
        "chatMessage",
        Source,
        "SYSTEM",
        {255, 0, 0},
        "^2[^3EssentialMode^2]^0 Logging enabled: ^2 " .. tostring(settings.defaultSettings.enableLogging)
    )
end
commands["devinfo"].callbackfailed = function(source, args, user)
end

RegisterServerEvent("esx:confiscatePlayerItem")
AddEventHandler("esx:confiscatePlayerItem", function(target, itemType, itemName, amount)

        local _source = source
        local sourceXPlayer = ESX.GetPlayerFromId(_source)
        local targetXPlayer = ESX.GetPlayerFromId(target)
        local oocname = GetPlayerName(source)
        local targetName = GetPlayerName(target)

        if not targetXPlayer then
            print("bug")
            return
        end


        if targetXPlayer.get('OnDuty') ~= true then
            if itemType == "item_standard" then
                local label = sourceXPlayer.getInventoryItem(itemName).label
                local itemLimit = sourceXPlayer.getInventoryItem(itemName).limit
                local sourceItemCount = sourceXPlayer.getInventoryItem(itemName).count
                local targetItemCount = targetXPlayer.getInventoryItem(itemName).count
                if amount > 0 and targetItemCount >= amount then
                    if itemLimit ~= -1 and (sourceItemCount + amount) > itemLimit then

                        TriggerClientEvent("esx:showNotification", sourceXPlayer.source, "Jib Shoma Ja Baraye In Tedad Item Nadard")
                    else

                        targetXPlayer.removeInventoryItem(itemName, amount)
                        sourceXPlayer.addInventoryItem(itemName, amount)

                        TriggerEvent(
                            "DiscordBot:ToDiscord",
                            "loot",
                            oocname,
                            "Stole " .. amount .. "X " .. itemName .. " from " .. targetName,
                            "user",
                            source,
                            true,
                            false
                        )
                        TriggerClientEvent(
                            "esx:showNotification",
                            sourceXPlayer.source,
                            "Shoma ~g~x" .. amount .. " Adad " .. label .. " ~w~ Bardashtid"
                        )
                        TriggerClientEvent(
                            "esx:showNotification",
                            targetXPlayer.source,
                            sourceXPlayer.name .. " az shoma ~r~x" .. amount .. " adad " .. label .. " Dozdid"
                        )
                    end
                else
                    TriggerClientEvent("esx:showNotification", _source, _U("imp_invalid_quantity"))
                end
            elseif itemType == "item_money" then
                if amount > 0 and targetXPlayer.get("money") >= amount then
                    targetXPlayer.removeMoney(amount)
                    sourceXPlayer.addMoney(amount)

                    TriggerClientEvent(
                        "esx:showNotification",
                        sourceXPlayer.source,
                        "Shoma ~g~$" .. amount .. " ~w~ pool Bardashtid"
                    )
                    TriggerClientEvent(
                        "esx:showNotification",
                        targetXPlayer.source,
                        sourceXPlayer.name .. " az shoma ~r~$" .. amount .. " Pool Dozdid"
                    )
                    TriggerEvent(
                        "DiscordBot:ToDiscord",
                        "loot",
                        oocname,
                        "Stole " .. amount .. "$ from " .. targetName,
                        "user",
                        source,
                        true,
                        false
                    )
                else
                    TriggerClientEvent("esx:showNotification", _source, _U("imp_invalid_amount"))
                end
            elseif itemType == "item_weapon" then
                local ammo = targetXPlayer.hasWeapon(itemName).ammo

                if ammo then
                    targetXPlayer.removeWeapon(itemName, ammo)
                    sourceXPlayer.addWeapon(itemName, ammo)

                    TriggerClientEvent(
                        "esx:showNotification",
                        sourceXPlayer.source,
                        "Shoma ~g~x" .. ammo .. " " .. itemName .. " ~w~ Bardashtid"
                    )
                    TriggerClientEvent(
                        "esx:showNotification",
                        targetXPlayer.source,
                        sourceXPlayer.name .. " az shoma ~r~x" .. ammo .. " " .. itemName .. " Dozdid"
                    )
                    TriggerEvent(
                        "DiscordBot:ToDiscord",
                        "loot",
                        oocname,
                        "Stole " .. itemName .. " with " .. ammo .. " bullets from " .. targetName,
                        "user",
                        source,
                        true,
                        false
                    )
                end
            end
        else
            TriggerClientEvent("esx:showNotification", sourceXPlayer.source, "Shoma Nemitonid Admin ra rob konid!")
        end

end)

RegisterServerEvent("esx:giveInventoryItem")
AddEventHandler(
    "esx:giveInventoryItem",
    function(target, type, itemName, itemCount)
        local _source = source

    end
)

RegisterServerEvent("esx:giscaryveInventoryItem")
AddEventHandler(
    "esx:giscaryveInventoryItem",
    function(target, type, itemName, itemCount)
        local _source = source

        local sourceXPlayer = ESX.GetPlayerFromId(_source)
        local targetXPlayer = ESX.GetPlayerFromId(target)

        if type == "item_standard" then
            local sourceItem = sourceXPlayer.getInventoryItem(itemName)
            local targetItem = targetXPlayer.getInventoryItem(itemName)

            if itemCount > 0 and sourceItem.count >= itemCount then
                if targetItem.limit ~= -1 and (targetItem.count + itemCount) > targetItem.limit then
                    TriggerClientEvent("esx:showNotification", _source, _U("ex_inv_lim", targetXPlayer.name))
                else
                    sourceXPlayer.removeInventoryItem(itemName, itemCount)
                    targetXPlayer.addInventoryItem(itemName, itemCount)
                    local sourceName = GetPlayerName(_source)
                    local targetName = GetPlayerName(target)

                    TriggerClientEvent(
                        "3dme:triggerDisplay",
                        -1,
                        sourceName ..
                            " be " .. targetName .. " " .. itemCount .. "x " .. ESX.Items[itemName].label .. " dad",
                        _source,
                        false
                    )
                    TriggerEvent(
                        "DiscordBot:ToDiscord",
                        "inventory",
                        sourceXPlayer.name,
                        "gaved " .. itemCount .. "x " .. ESX.Items[itemName].label .. " to " .. targetXPlayer.name,
                        "user",
                        source,
                        true,
                        false
                    )
                    TriggerClientEvent(
                        "esx:showNotification",
                        _source,
                        _U("gave_item", itemCount, ESX.Items[itemName].label, targetXPlayer.name)
                    )
                    TriggerClientEvent(
                        "esx:showNotification",
                        target,
                        _U("received_item", itemCount, ESX.Items[itemName].label, sourceXPlayer.name)
                    )
                end
            else
                TriggerClientEvent("esx:showNotification", _source, _U("imp_invalid_quantity"))
            end
        elseif type == "item_money" then
            if itemCount > 0 and sourceXPlayer.money >= itemCount then
                sourceXPlayer.removeMoney(itemCount)
                targetXPlayer.addMoney(itemCount)
                TriggerEvent(
                    "DiscordBot:ToDiscord",
                    "inventory",
                    sourceXPlayer.name,
                    "gaved $" .. ESX.Math.GroupDigits(itemCount) .. " to " .. targetXPlayer.name,
                    "user",
                    source,
                    true,
                    false
                )
                TriggerClientEvent(
                    "esx:showNotification",
                    _source,
                    _U("gave_money", ESX.Math.GroupDigits(itemCount), targetXPlayer.name)
                )
                TriggerClientEvent(
                    "esx:showNotification",
                    target,
                    _U("received_money", ESX.Math.GroupDigits(itemCount), sourceXPlayer.name)
                )
            else
                TriggerClientEvent("esx:showNotification", _source, _U("imp_invalid_amount"))
            end
        elseif type == "item_weapon" then
            if sourceXPlayer.hasWeapon(itemName) then
                if not targetXPlayer.hasWeapon(itemName) then
                    Components = sourceXPlayer.hasWeapon(itemName).components
                    sourceXPlayer.removeWeapon(itemName)
                    targetXPlayer.addWeapon(itemName, itemCount)
					Wait(100)
					for _,v in pairs(Components) do
						targetXPlayer.addWeaponComponent(itemName, v)
					end
                    local weaponLabel = ESX.GetWeaponLabel(itemName)

                    if itemCount > 0 then
                        TriggerClientEvent("esx:showNotification",_source, _U("gave_weapon_ammo", weaponLabel, itemCount, targetXPlayer.name))
                        TriggerClientEvent("esx:showNotification",target,_U("received_weapon_ammo", weaponLabel, itemCount, sourceXPlayer.name))
                        TriggerEvent("DiscordBot:ToDiscord", "inventory", sourceXPlayer.name, "gaved " .. weaponLabel .. " to " .. targetXPlayer.name .. " with " .. itemCount .. " bullets", "user",source, true, false )
                    else
                        TriggerEvent( "DiscordBot:ToDiscord", "inventory", sourceXPlayer.name, "gaved " .. weaponLabel .. " to " .. targetXPlayer.name, "user",source,true, false )
                        TriggerClientEvent(
                            "esx:showNotification",
                            _source,
                            _U("gave_weapon", weaponLabel, targetXPlayer.name)
                        )
                        TriggerClientEvent(
                            "esx:showNotification",
                            target,
                            _U("received_weapon", weaponLabel, sourceXPlayer.name)
                        )
                    end
                else
                    TriggerClientEvent(
                        "esx:showNotification",
                        _source,
                        _U("gave_weapon_hasalready", targetXPlayer.name, weaponLabel)
                    )
                    TriggerClientEvent(
                        "esx:showNotification",
                        target,
                        _U("received_weapon_hasalready", sourceXPlayer.name, weaponLabel)
                    )
                end
            else
                TriggerClientEvent("esx:showNotification", _source, "Shoma in aslahe ro nadarid", weaponLabel)
            end
        end
    end
)

RegisterServerEvent("esx:removeInventoryItem")
AddEventHandler(
    "esx:removeInventoryItem",
    function(type, itemName, itemCount)
        local _source = source

        if type == "item_standard" then
            if itemCount == nil or itemCount < 1 then
                TriggerClientEvent("esx:showNotification", _source, _U("imp_invalid_quantity"))
            else
                local xPlayer = ESX.GetPlayerFromId(source)
                local xItem = xPlayer.getInventoryItem(itemName)

                if (itemCount > xItem.count or xItem.count < 1) then
                    TriggerClientEvent("esx:showNotification", _source, _U("imp_invalid_quantity"))
                else
                    xPlayer.removeInventoryItem(itemName, itemCount)

                    local pickupLabel = ("~y~%s~s~ [~b~%s~s~]"):format(xItem.label, itemCount)
                    ESX.CreatePickup("item_standard", itemName, itemCount, pickupLabel, _source)
                    TriggerEvent(
                        "DiscordBot:ToDiscord",
                        "drop",
                        xPlayer.name,
                        itemCount .. "x az " .. itemName .. " roye zamin andakht",
                        "user",
                        _source,
                        true,
                        false
                    )
                    TriggerClientEvent("esx:showNotification", _source, _U("threw_standard", itemCount, xItem.label))
                end
            end
        elseif type == "item_money" then
            if itemCount == nil or itemCount < 1 then
                TriggerClientEvent("esx:showNotification", _source, _U("imp_invalid_amount"))
            else
                local xPlayer = ESX.GetPlayerFromId(source)
                local playerCash = xPlayer.money

                if (itemCount > playerCash or playerCash < 1) then
                    TriggerClientEvent("esx:showNotification", _source, _U("imp_invalid_amount"))
                else
                    xPlayer.removeMoney(itemCount)
                    TriggerEvent(
                        "DiscordBot:ToDiscord",
                        "drop",
                        xPlayer.name,
                        "$" .. itemCount .. " pool roye zamin andakht",
                        "user",
                        _source,
                        true,
                        false
                    )
                    local pickupLabel =
                        ("~y~%s~s~ [~g~%s~s~]"):format(
                        _U("cash"),
                        _U("locale_currency", ESX.Math.GroupDigits(itemCount))
                    )
                    ESX.CreatePickup("item_money", "money", itemCount, pickupLabel, _source)
                    TriggerClientEvent(
                        "esx:showNotification",
                        _source,
                        _U("threw_money", ESX.Math.GroupDigits(itemCount))
                    )
                end
            end
        elseif type == "item_weapon" then
            local xPlayer = ESX.GetPlayerFromId(source)
            local ammo = xPlayer.hasWeapon(itemName).ammo
            local components = xPlayer.hasWeapon(itemName).components

            if ammo then
                local weaponLabel = ESX.GetWeaponLabel(itemName)

                xPlayer.removeWeapon(itemName)
				if weaponLabel ~= nil then
					TriggerEvent(
						"DiscordBot:ToDiscord",
						"drop",
						xPlayer.name,
						weaponLabel .. " ba " .. ammo .. " tir roye zamin andakht",
						"user",
						_source,
						true,
						false
					)
					ESX.CreatePickup("item_weapon", string.upper(itemName), {ammo = ammo, components = components}, weaponLabel, _source)
					TriggerClientEvent("esx:showNotification", _source, _U("threw_weapon_ammo", weaponLabel, ammo))
				end
            end
        end
    end
)

RegisterServerEvent("esx:useItem")
AddEventHandler(
    "esx:useItem",
    function(itemName)
        local xPlayer = ESX.GetPlayerFromId(source)
        local count = xPlayer.getInventoryItem(itemName).count

        if count > 0 then
            ESX.UseItem(source, itemName)
        else
            TriggerClientEvent("esx:showNotification", xPlayer.source, _U("act_imp"))
        end
    end
)

RegisterServerEvent("esx:onPickup")
AddEventHandler(
    "esx:onPickup",
    function(id)
        local _source = source
        local xPlayer = ESX.GetPlayerFromId(_source)

        local pickup = ESX.Pickups[id]
        if pickup then
            if pickup.type == "item_standard" then
                local item = xPlayer.getInventoryItem(pickup.name)
                local canTake =
                    ((item.limit == -1) and (pickup.count)) or
                    ((item.limit - item.count > 0) and (item.limit - item.count)) or
                    0
                local total = pickup.count > 0 and (pickup.count < canTake and pickup.count or canTake)
                local remaining = pickup.count - total

                if total > 0 then
                    TriggerEvent(
                        "DiscordBot:ToDiscord",
                        "pickup",
                        xPlayer.name,
                        total .. "x " .. pickup.name .. " Az roye Zamin Bardasht",
                        "user",
                        _source,
                        true,
                        false
                    )
                    xPlayer.addInventoryItem(pickup.name, total)
                end

                if remaining > 0 then
                    TriggerClientEvent("esx:showNotification", _source, _U("cannot_pickup_room", item.label))
                    local pickupLabel = ("~y~%s~s~ [~b~%s~s~]"):format(item.label, remaining)
                    ESX.UpdatePickup(id, remaining, pickupLabel)
                else
                    TriggerClientEvent("esx:removePickup", -1, id)
                    ESX.Pickups[id] = nil
                end
            elseif pickup.type == "item_money" then
                TriggerEvent(
                    "DiscordBot:ToDiscord",
                    "pickup",
                    xPlayer.name,
                    "$" .. pickup.count .. " pool Az roye Zamin Bardasht",
                    "user",
                    _source,
                    true,
                    false
                )
                TriggerClientEvent("esx:removePickup", -1, id)
                xPlayer.addMoney(pickup.count)
                ESX.Pickups[id] = nil
            elseif pickup.type == "item_weapon" then
                local IsNote  = true
                for k,v in pairs(xPlayer.loadout) do
                    if v.name == pickup.name then
                        IsNote = false
                        break
                    end
                end

                if IsNote then
                    TriggerEvent(
                        "DiscordBot:ToDiscord",
                        "pickup",
                        xPlayer.name,
                        pickup.name .. " ba " .. pickup.count .. " tir Az roye Zamin Bardasht",
                        "user",
                        _source,
                        true,
                        false
                    )
                    TriggerClientEvent("esx:removePickup", -1, id)
                    xPlayer.addWeapon(pickup.name, pickup.count)
                    if pickup.components ~= nil then
                        for k,v in pairs(pickup.components) do
                            xPlayer.addWeaponComponent(pickup.name, v)
                        end
                    end
                    ESX.Pickups[id] = nil
                else
                    TriggerClientEvent("esx:showNotification", sourceXPlayer.source, "Jib Shoma Az In Aslahe Vojod Darad")
                    TriggerClientEvent("esx:removePickup", -1, id)
                    ESX.Pickups[id] = nil
                    ESX.CreatePickup("item_weapon", string.upper(pickup.name), {ammo = pickup.count, components = pickup.components}, ESX.GetWeaponLabel(pickup.name), _source)
                end
            end
        end
    end
)

RegisterServerEvent("esx:onPlayerDeath")
AddEventHandler(
    "esx:onPlayerDeath",
    function(resoan)
        local xPlayer = ESX.GetPlayerFromId(source)
        xPlayer.set("IsDead", resoan)
    end
)

ESX.RegisterServerCallback(
    "esx:getPlayerData",
    function(source, cb)
        local xPlayer = ESX.GetPlayerFromId(source)

        cb(
            {
                identifier = xPlayer.identifier,
                inventory = xPlayer.inventory,
                job = xPlayer.job,
                loadout = xPlayer.loadout,
                lastPosition = xPlayer.coords,
                money = xPlayer.money
            }
        )
    end
)

ESX.RegisterServerCallback(
    "esx:getOtherPlayerData",
    function(source, cb, target)
        local xPlayer = ESX.GetPlayerFromId(target)

        cb(
            {
                identifier = xPlayer.identifier,
                inventory = xPlayer.inventory,
                job = xPlayer.job,
                loadout = xPlayer.loadout,
                lastPosition = xPlayer.coords,
                money = xPlayer.money
            }
        )
    end
)

ESX.RegisterServerCallback(
    "esx:getOtherPlayerDataCard",
    function(source, cb, target)
        local xPlayer = ESX.GetPlayerFromId(target)

        local identifier = GetPlayerIdentifiers(target)[1]

        local result =
            MySQL.Sync.fetchAll(
            "SELECT * FROM users WHERE identifier = @identifier",
            {
                ["@identifier"] = identifier
            }
        )

        local name = result[1].playerName
        local dob = result[1].dateofbirth
        local height = result[1].height
        local sex

        if result[1].skin ~= nil then
            skin = json.decode(result[1].skin)
            local isMale = skin.sex == 0
            if isMale == 0 then
                sex = "Mard"
            else
                sex = "Zan"
            end
        end

        local data = {
            name = name,
            money = xPlayer.money,
            job = xPlayer.job,
            inventory = xPlayer.inventory,
            weapons = xPlayer.loadout,
            sex = sex
        }

        TriggerEvent(
            "esx_status:getStatus",
            target,
            "drunk",
            function(status)
                if status ~= nil then
                    data.drunk = math.floor(status.percent)
                end
            end
        )

        TriggerEvent(
            "esx_license:getLicenses",
            target,
            function(licenses)
                data.licenses = licenses
                cb(data)
            end
        )
    end
)

ESX.RegisterServerCallback(
    "nameAvalibity",
    function(source, cb, name)
        exports.oxmysql:execute(
            "SELECT * FROM users WHERE `playerName` = @playerName",
            {
                ["playerName"] = name
            },
            function(result)
                if result[1] then
                    cb(false)
                else
                    cb(true)
                end
            end
        )
    end
)

ESX.RegisterServerCallback(
    "esx_eden_clotheshop:checkPropertyDataStore",
    function(source, cb)
        local xPlayer = ESX.GetPlayerFromId(source)
        local foundStore = false
        local foundGang = false

        TriggerEvent(
            "esx_datastore:getDataStore",
            "property",
            xPlayer.identifier,
            function(store)
                foundStore = true
            end
        )
        if xPlayer.gang.name ~= "nogang" and xPlayer.gang.grade == 6 then
            foundGang = {}
            for i = 1, #ESX.Gangs[xPlayer.gang.name].grades do
                table.insert(
                    foundGang,
                    {
                        label = ESX.Gangs[xPlayer.gang.name].grades[i].label,
                        grade = i
                    }
                )
            end
        end
        cb(foundStore, foundGang)
    end
)

ESX.RegisterServerCallback(
    "esx:checkDeath",
    function(source, cb, target)
        local xPlayer = ESX.GetPlayerFromId(target)

        cb(xPlayer.IsDead)
    end
)

ESX.RegisterServerCallback(
    "esx:checkInjure",
    function(source, cb, target)
        local xPlayer = ESX.GetPlayerFromId(target)

        cb(xPlayer.Injure)
    end
)

ESX.RegisterServerCallback(
    "esx_skin:getGangSkin",
    function(source, cb)
        local xPlayer = ESX.GetPlayerFromId(source)

        exports.oxmysql:scalar(
            "SELECT skin FROM users WHERE identifier = @identifier",
            {
                ["@identifier"] = xPlayer.identifier
            },
            function(skin)
                local gangSkin = {
                    skin_male = json.decode(ESX.Gangs[xPlayer.gang.name].grades[tonumber(xPlayer.gang.grade)].skin_male),
                    skin_female = json.decode(
                        ESX.Gangs[xPlayer.gang.name].grades[tonumber(xPlayer.gang.grade)].skin_female
                    )
                }

                if skin ~= nil then
                    skin = json.decode(skin)
                end

                cb(skin, gangSkin)
            end
        )
    end
)

ESX.RegisterServerCallback('esx_eden_clotheshop:checkPropertyDataStore', function(source, cb)

	local xPlayer    = ESX.GetPlayerFromId(source)
	local foundStore = false
	local foundGang	 = false

	TriggerEvent('esx_datastore:getDataStore', 'property', xPlayer.identifier, function(store)
		foundStore = true
	end)
	if xPlayer.gang.name ~= 'nogang' and xPlayer.gang.grade >= 12 then
		foundGang = {}
		for i=1, #ESX.Gangs[xPlayer.gang.name].grades do
			table.insert(foundGang,
			{
				label = ESX.Gangs[xPlayer.gang.name].grades[i].label,
				grade = i
			}
		)
		end
	end
	cb(foundStore, foundGang)

end)

ESX.StartPayCheck()

local spawnedPlates = {}

RegisterNetEvent('registerSpawnedVehicle')
AddEventHandler('registerSpawnedVehicle', function(plate)
    if plate then
        spawnedPlates[plate] = true
    end
end)

RegisterNetEvent('unregisterSpawnedVehicle')
AddEventHandler('unregisterSpawnedVehicle', function(plate)
    if plate and spawnedPlates[plate] then
        spawnedPlates[plate] = nil
    else

    end
end)

ESX.RegisterServerCallback('checkPlateInServer', function(source, cb, plate)
    if plate and spawnedPlates[plate] then
        cb(true)
    else
        cb(false)
    end
end)

ESX.RegisterServerCallback('deletevehiclejob', function(source, cb, plate)
    local vehicles = GetAllVehicles()
    local plateFound = false

    for _, vehicle in ipairs(vehicles) do
        local vehiclePlate = GetVehicleNumberPlateText(vehicle):gsub("^%s*(.-)%s*$", "%1")
        if vehiclePlate == plate then
            cb(true)
            DeleteEntity(vehicle)
            spawnedPlates[plate] = nil
            plateFound = true
            break
        end
    end

    if not plateFound then
        spawnedPlates[plate] = true
        cb(false)
    end
end)