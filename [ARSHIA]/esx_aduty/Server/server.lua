ESX = nil
AdminPlayers = {}
tempOown = false
rcount = 1

chats = {}
Rewardalls = {}
Rewardallids = {}
event = {name = "none", coords = "nothing", status = true}
lastmessage = 1
count = 0
OnDuty = {}

messages = {







}

resetaccountAceess = {
    "steam:"
}

disbandfamilyAceess = {
    "steam:"
}

TriggerEvent(
    "esx:getSharedObject",
    function(obj)
        ESX = obj
        if ESX == nil then
            Wait(500)
        end
    end
)

AddEventHandler(
    "esx:playerDropped",
    function(source, reason)
        local _source = source
		local xPlayer = ESX.GetPlayerFromId(_source)
        if _source ~= nil then
            local identifier = GetPlayerIdentifier(_source)
            local name = GetPlayerName(_source)

            exports.oxmysql:execute(
                "INSERT INTO audit (`identifier`, `id` ,`oname`, `timestamp`, `type`) VALUES (@identifier, @id, @name, @timestamp, @type)",
                {
                    ["identifier"] = identifier,
                    ["id"] = tonumber(_source),
                    ["name"] = name,
                    ["timestamp"] = os.time(),
                    ["type"] = "Exit(" .. reason .. ")"
                },
                function(result)
                    if not result or result.affectedRows <= 0 then
                        print("Failed to save " .. name .. "Exit log!")
                    end
                end
            )


			if xPlayer.permission_level >= 8 then
				xPlayer.set("aduty", false)
				OnDuty[xPlayer.source] = false
			end

            if AdminPlayers[identifier] ~= nil then
                AdminPlayers[identifier] = nil
                TriggerClientEvent("aduty:set_tags", -1, AdminPlayers)
                TriggerEvent("DiscordBot:ToDiscord", "duty", name, "OffDuty shod", "user", true, _source, false)
            end
        end
    end
)

AddEventHandler(
    "esx:playerLoaded",
    function(source)
        Citizen.Wait(2000)
        local identifier = GetPlayerIdentifier(source)
		local xPlayer = ESX.GetPlayerFromId(source)

        TriggerClientEvent("aduty:set_tags", -1, AdminPlayers)


        exports.oxmysql:execute(
            "INSERT INTO audit (`identifier`, `id`, `oname`, `timestamp`, `type`) VALUES (@identifier, @id, @name, @timestamp, @type)",
            {
                ["identifier"] = identifier,
                ["id"] = tonumber(source),
                ["name"] = GetPlayerName(source),
                ["timestamp"] = os.time(),
                ["type"] = "Enter",
                print(identifier, id, name, timestamp, type)
            },
            function(result)
                if not result or result.affectedRows <= 0 then
                    print("Failed to save " .. name .. "Enter log!")
                end
            end
        )



        if xPlayer.permission_level >= 8 then
            xPlayer.set("aduty", true)
            OnDuty[xPlayer.source] = false
        end
    end
)

RegisterServerEvent("aduty:statusHandler")
AddEventHandler(
    "aduty:statusHandler",
    function(status)
        tempOown = status
    end
)

RegisterServerEvent("aduty:changeDutyStatus")
AddEventHandler(
    "aduty:changeDutyStatus",
    function()
        local xPlayer = ESX.GetPlayerFromId(source)

        if xPlayer then
            xPlayer.set("aduty", false)
        end
    end
)

RegisterServerEvent("aduty:setEventCoords")
AddEventHandler(
    "aduty:setEventCoords",
    function(coords)
        if coords == nil then
            return
        end

        local xPlayer = ESX.GetPlayerFromId(source)

        if xPlayer.permission_level >= 9 then
            event.coords = coords
            TriggerClientEvent(
                "chatMessage",
                -1,
                "[SYSTEM]",
                {255, 0, 0},
                " ^0Event ^3" .. event.name .. "^0 shoro shode ^1/event ^0jahat join dadan be event"
            )
        else

        end
    end
)

ESX.RegisterServerCallback(
    "esx_aduty:checkdutystatus",
    function(source, cb, target)
        CheckPlayerDutyStatus(target, cb)
    end
)

ESX.RegisterServerCallback(
    "esx_aduty:doesGangExist",
    function(source, cb, name, grade)
        if ESX.DoesGangExist(name, grade) then
            cb(true)
        else
            cb(false)
        end
    end
)

ESX.RegisterServerCallback(
    "esx_aduty:checkAdmin",
    function(source, cb)
        local xPlayer = ESX.GetPlayerFromId(source)

        if not xPlayer then
            cb(false)
            return
        end

        if xPlayer.permission_level > 1 then
            cb(true)
        else
            cb(false)
        end
    end
)

ESX.RegisterServerCallback(
    "esx_aduty:getEventCoords",
    function(source, cb)
        cb(event.coords)
    end
)

ESX.RegisterServerCallback(
    "esx_aduty:getAdminPerm",
    function(source, cb)
        if source == 0 then
            return
        end

        local xPlayer = ESX.GetPlayerFromId(source)

        Wait(1)

        if xPlayer == nil then
            Wait(1000)
        end

        local xPlayer = ESX.GetPlayerFromId(source)

        cb(xPlayer.permission_level)
    end
)

ESX.RegisterServerCallback(
    "esx_aduty:checkAduty",
    function(source, cb)
        local xPlayer = ESX.GetPlayerFromId(source)
        if xPlayer.permission_level >= 1 then
            cb(xPlayer.get("aduty"))
        else
            cb(false)
        end
    end
)

RegisterServerEvent("aduty:sendMessage")
AddEventHandler(
    "aduty:sendMessage",
    function(target, message)
        TriggerClientEvent("chatMessage", target, "Whisper(" .. source .. ")", {255, 197, 0}, message)
    end
)

RegisterServerEvent("aduty:showlicense")
AddEventHandler(
    "aduty:showlicense",
    function(target)
        local _source = source
        local identifier = GetPlayerIdentifier(_source)
        local xPlayer = ESX.GetPlayerFromId(_source)
        TriggerClientEvent("chatMessage", target, "", {255, 0, 0}, "^0^*------ ^3List Madarek ^0------")
        TriggerClientEvent(
            "chatMessage",
            target,
            "",
            {255, 0, 0},
            "^4^*Cart Shenasaei:^0 " .. string.gsub(xPlayer.name, "_", " ")
        )
        TriggerEvent(
            "esx_license:checkLicense",
            _source,
            "drive_bike",
            function(bike)
                TriggerEvent(
                    "esx_license:checkLicense",
                    _source,
                    "drive_truck",
                    function(truck)
                        TriggerEvent(
                            "esx_license:checkLicense",
                            _source,
                            "drive",
                            function(driveing)
                                TriggerEvent(
                                    "esx_license:checkLicense",
                                    _source,
                                    "dmv",
                                    function(aiinname)
                                        TriggerEvent(
                                            "esx_license:checkLicense",
                                            _source,
                                            "weapon",
                                            function(Weapon)
                                                TriggerEvent(
                                                    "esx_license:checkLicense",
                                                    _source,
                                                    "fly",
                                                    function(fly)
                                                        if driveing then
                                                            TriggerClientEvent(
                                                                "chatMessage",
                                                                target,
                                                                "",
                                                                {255, 0, 0},
                                                                "^4^*Govahiname: ^2Darad"
                                                            )
                                                        else
                                                            TriggerClientEvent(
                                                                "chatMessage",
                                                                target,
                                                                "",
                                                                {255, 0, 0},
                                                                "^4^*Govahiname: ^8Nadarad"
                                                            )
                                                        end
                                                        if truck then
                                                            TriggerClientEvent(
                                                                "chatMessage",
                                                                target,
                                                                "",
                                                                {255, 0, 0},
                                                                "^4^*Govahiname Kamyon Savari: ^2Darad"
                                                            )
                                                        else
                                                            TriggerClientEvent(
                                                                "chatMessage",
                                                                target,
                                                                "",
                                                                {255, 0, 0},
                                                                "^4^*Govahiname Kamyon Savari: ^8Nadarad"
                                                            )
                                                        end
                                                        if bike then
                                                            TriggerClientEvent(
                                                                "chatMessage",
                                                                target,
                                                                "",
                                                                {255, 0, 0},
                                                                "^4^*Govahiname Motor Savari: ^2Darad"
                                                            )
                                                        else
                                                            TriggerClientEvent(
                                                                "chatMessage",
                                                                target,
                                                                "",
                                                                {255, 0, 0},
                                                                "^4^*Govahiname Motor Savari: ^8Nadarad"
                                                            )
                                                        end
                                                        if aiinname then
                                                            TriggerClientEvent(
                                                                "chatMessage",
                                                                target,
                                                                "",
                                                                {255, 0, 0},
                                                                "^4^*Emtehane Aiinname: ^2Dade"
                                                            )
                                                        else
                                                            TriggerClientEvent(
                                                                "chatMessage",
                                                                target,
                                                                "",
                                                                {255, 0, 0},
                                                                "^4^*Emtehane Aiinname: ^2Nadade"
                                                            )
                                                        end
                                                        if fly then
                                                            TriggerClientEvent(
                                                                "chatMessage",
                                                                target,
                                                                "",
                                                                {255, 0, 0},
                                                                "^4^*Mojavez Parvaz: ^2Darad"
                                                            )
                                                        else
                                                            TriggerClientEvent(
                                                                "chatMessage",
                                                                target,
                                                                "",
                                                                {255, 0, 0},
                                                                "^4^*Mojavez Parvaz: ^8Nadarad"
                                                            )
                                                        end
                                                        if Weapon then
                                                            TriggerClientEvent(
                                                                "chatMessage",
                                                                target,
                                                                "",
                                                                {255, 0, 0},
                                                                "^4^*Mojavez aslahe: ^2Darad"
                                                            )
                                                        else
                                                            TriggerClientEvent(
                                                                "chatMessage",
                                                                target,
                                                                "",
                                                                {255, 0, 0},
                                                                "^4^*Mojavez aslahe: ^8Nadarad"
                                                            )
                                                        end
                                                        TriggerClientEvent(
                                                            "chatMessage",
                                                            target,
                                                            "",
                                                            {255, 0, 0},
                                                            "^0^*------ ^3List Madarek ^0------"
                                                        )
                                                    end
                                                )
                                            end
                                        )
                                    end
                                )
                            end
                        )
                    end
                )
            end
        )
    end
)

RegisterNetEvent("esx_aduty:GetUserInfo")
AddEventHandler(
    "esx_aduty:GetUserInfo",
    function(Type, identifier, callback)
        if Type == "steam" then
            if ESX.GetPlayerFromIdentifier(identifier) then
                local xPlayer = ESX.GetPlayerFromIdentifier(identifier)
                ESX.SavePlayer(xPlayer.source)
                Wait(1000)
                MySQL.Async.fetchAll(
                    "SELECT * FROM users WHERE identifier = @identifier",
                    {
                        ["@identifier"] = identifier
                    },
                    function(result)
                        if json.encode(result) == "[]" then
                            callback("Not Found")
                            return
                        end
                        table.insert(result, {source = xPlayer.source})
                        callback(result)
                    end
                )
            else
                MySQL.Async.fetchAll(
                    "SELECT * FROM users WHERE identifier = @identifier",
                    {
                        ["@identifier"] = identifier
                    },
                    function(result)
                        if json.encode(result) == "[]" then
                            callback("Not Found")
                            return
                        end

                        table.insert(result, {source = "Offline"})
                        callback(result)
                    end
                )
            end
        elseif Type == "id" then
            if not GetPlayerName(tonumber(identifier)) then
                callback("No ID")
            end
            local xPlayer = ESX.GetPlayerFromId(tonumber(identifier))
            ESX.SavePlayer(xPlayer.source)
            Wait(1000)
            MySQL.Async.fetchAll(
                "SELECT * FROM users WHERE identifier = @identifier",
                {
                    ["@identifier"] = xPlayer.identifier
                },
                function(result)
                    if json.encode(result) == "[]" then
                        callback("Prob")
                    end
                    table.insert(result, {source = xPlayer.source})
                    callback(result)
                end
            )
        else
            callback("No Type")
        end
    end
)

-- SECURITY FIX: this event previously had NO permission check at all --
-- any connected client could call TriggerServerEvent("esx_aduty:AddUserMoney",
-- "id", myId, 999999999) and give themselves (or anyone) unlimited cash.
-- Nothing client-side calls this event; it looks like it was meant for an
-- external admin panel and the server-side gate was simply never added.
-- Now requires the same permission_level >= 8 threshold this file uses for
-- its other admin-money actions, and unauthorized attempts are banned the
-- same way the rest of this codebase handles a raw cheat-tool call.
RegisterNetEvent("esx_aduty:AddUserMoney")
AddEventHandler(
    "esx_aduty:AddUserMoney",
    function(Type, identifier, amount, callback)
        local _source = source
        local xCaller = ESX.GetPlayerFromId(_source)
        callback = callback or function() end

        if not xCaller or not xCaller.permission_level or xCaller.permission_level < 8 then
            if exports.UNIQUE_AC then
                exports.UNIQUE_AC:BanPlayer(_source, 'Cheat Lua Executer', 'Tried esx_aduty:AddUserMoney without permission')
            end
            callback("no permission")
            return
        end

        amount = tonumber(amount)
        if not amount or amount <= 0 or amount ~= math.floor(amount) then
            callback("invalid amount")
            return
        end

        if Type == "id" then
            local xPlayer = ESX.GetPlayerFromId(tonumber(identifier))
            if not xPlayer then
                callback("Offline")
                return
            end
            xPlayer.addMoney(amount)
            callback(true)
        elseif Type == "steam" then
            if ESX.GetPlayerFromIdentifier(identifier) then
                local xPlayer = ESX.GetPlayerFromIdentifier(identifier)
                xPlayer.addMoney(amount)
                callback(true)
            else
                callback("Offline")
            end
        else
            callback("invalid type")
        end
    end
)

AddEventHandler(
    "esx_aduty:GetServerInfo",
    function(callback)
        local admins = exports.esx_playerinfo:GetAdmins()
        local info = {
            police = exports.esx_playerinfo:GetCounts("police"),
            sheriff = exports.esx_playerinfo:GetCounts("sheriff"),
            mt = exports.esx_playerinfo:GetCounts("mt"),
            fbi = exports.esx_playerinfo:GetCounts("fbi"),
            cid = exports.esx_playerinfo:GetCounts("cid"),
            cia = exports.esx_playerinfo:GetCounts("cia"),
            marshal = exports.esx_playerinfo:GetCounts("marshal"),
            judge = exports.esx_playerinfo:GetCounts("judge"),
            doa = exports.esx_playerinfo:GetCounts("doa"),
            nightclub = exports.esx_playerinfo:GetCounts("nightclub"),
            food = exports.esx_playerinfo:GetCounts("food"),
            ambulance = exports.esx_playerinfo:GetCounts("ambulance"),
            mechanic = exports.esx_playerinfo:GetCounts("mecano"),
            government = exports.esx_playerinfo:GetCounts("government"),
            total = exports.esx_playerinfo:GetCounts("total"),

            Admins = {
                on = 0,
                off = 0,
                total = 0
            }
        }
        if TableLength(admins) == 0 then
            info.Admins.on, info.Admins.off = 0, 0
            callback(info)
            return
        end
        for k, v in pairs(admins) do
            local zPlayer = ESX.GetPlayerFromId(v.id)
            local aduty = zPlayer.get("aduty")
            if aduty then
                info.Admins.on = info.Admins.on + 1
            else
                info.Admins.off = info.Admins.off + 1
            end
        end
        info.Admins.total = info.Admins.off + info.Admins.on
        callback(info)
    end
)

ESX.RegisterServerCallback("GetGangMembers", function(source, cb)
    Gangs = {}
    local xPlayer = ESX.GetPlayerFromId(source)
    local xPlayers = ESX.GetPlayers()
    for k, v in ipairs(xPlayers) do
        local xP = ESX.GetPlayerFromId(v)
        if xP.gang.name == xPlayer.gang.name then
            table.insert(Gangs, xP)
        end
    end
    if xPlayer.gang.name == 'nogang' then
        cb(false, Gangs, #Gangs, xPlayer.gang.name)
    else
        cb(true, Gangs, #Gangs, xPlayer.gang.name)
    end
end)