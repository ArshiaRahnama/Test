ESX = nil

TriggerEvent(
    "esx:getSharedObject",
    function(obj)
        ESX = obj
    end
)

RegisterCommand(
    "givelicense",
    function(source, args, user)
        local xPlayer = ESX.GetPlayerFromId(source)

        if xPlayer.job.name == "police" and xPlayer.job.grade > 12 then
            if args[1] then
                if args[2] then

					if xPlayer.job.name == "police" and xPlayer.job.grade > 12 then
                        local target = tonumber(args[1])
                        if target ~= nil then
                            if GetPlayerName(target) then
                                if
                                    args[2] == "weapon" or args[2] == "dmv" or args[2] == "drive" or args[2] == "truck" or
                                        args[2] == "bike" or
                                        args[2] == "fly"
                                 then
                                    local type = nil
                                    local name = nil
                                    if args[2] == "weapon" or args[2] == "dmv" or args[2] == "drive" or args[2] == "fly" then
                                        type = args[2]
                                    elseif args[2] == "truck" or args[2] == "bike" then
                                        type = "drive_" .. args[2]
                                    end

                                    if args[2] == "weapon" then
                                        name = "Mojavez Aslahe"
                                    elseif args[2] == "dmv" then
                                        name = "Ayin Naame"
                                    elseif args[2] == "drive" then
                                        name = "Govahiname Ranandegi"
                                    elseif args[2] == "truck" then
                                        name = "Govahiname Kamiyon"
                                    elseif args[2] == "bike" then
                                        name = "Govahiname Motor"
                                    elseif args[2] == "fly" then
                                        if xPlayer.hasDivision("fld") then
                                            name = "Mojaveze Parvaz"
                                        else
                                            TriggerClientEvent(
                                                "esx:showNotification",
                                                source,
                                                "~r~~h~Shoam Division FLD Nadarid"
                                            )
                                            return
                                        end
                                    end

                                    MySQL.Async.fetchAll( "SELECT * FROM user_licenses WHERE owner=@identifier AND type = @type",{
                                            ["@identifier"] = GetPlayerIdentifiers(target)[1],
                                            ["@type"] = type
                                        }, function(data)
                                            if data[1] then
                                                TriggerClientEvent(
                                                    "chatMessage",
                                                    source,
                                                    "[LICENSE]",
                                                    {255, 0, 0},
                                                    "^2" ..
                                                        GetPlayerName(target) ..
                                                            " ^0Dar hale hazer " .. name .. " darad!"
                                                )
                                            else
                                                if args[2] == "fly" then
                                                    TriggerClientEvent("esx_tracker:flyLicense", target, true)
                                                    TriggerEvent("esx_license:addLicense", target, type)
                                                end
                                                TriggerClientEvent(
                                                    "chatMessage",
                                                    source,
                                                    "[LICENSE]",
                                                    {255, 0, 0},
                                                    " ^0Shoma be^2 " ..
                                                        GetPlayerName(target) .. "^0 " .. name .. " dadid!"
                                                )
                                                TriggerClientEvent(
                                                    "chatMessage",
                                                    target,
                                                    "[LICENSE]",
                                                    {255, 0, 0},
                                                    " ^0Shoma " .. name .. " daryaft kardid!"
                                                )

                                                Citizen.Wait(1000)
                                                if
                                                    args[2] == "dmv" or args[2] == "drive" or args[2] == "truck" or
                                                        args[2] == "bike" or args[2] == "weapon"
                                                 then
                                                    TriggerEvent("esx_license:addLicense", target, type)
                                                end
                                            end
                                        end
                                    )
                                else
                                    TriggerClientEvent(
                                        "chatMessage",
                                        source,
                                        "[LICENSE]",
                                        {255, 0, 0},
                                        " ^0Mojavezi ke vared kardid na motabar ast!"
                                    )
                                end
                            else
                                TriggerClientEvent(
                                    "chatMessage",
                                    source,
                                    "[LICENSE]",
                                    {255, 0, 0},
                                    " ^0ID vared shode na motabar ast!"
                                )
                            end
                        else
                            TriggerClientEvent(
                                "chatMessage",
                                source,
                                "[LICENSE]",
                                {255, 0, 0},
                                " ^0Shoma bayad dar ghesmmat ID faghat adad vared konid!"
                            )
                        end
                    else
                        TriggerClientEvent("chatMessage", source, "[LICENSE]", {255, 0, 0}, " ^1Shoma fld Nistid")
                    end
                else
                    TriggerClientEvent(
                        "chatMessage",
                        source,
                        "[LICENSE]",
                        {255, 0, 0},
                        " ^0Shoma dar ghesmat mojavez chizi vared nakardid!"
                    )
                end
            else
                TriggerClientEvent(
                    "chatMessage",
                    source,
                    "[LICENSE]",
                    {255, 0, 0},
                    " ^0Shoma bayad ID player marbote ra vared konid!"
                )
            end
        else
            TriggerClientEvent("esx:showNotification", source, "~r~~h~Shoma police ya highrank nistid!")
        end
    end,
    false
)

RegisterCommand(
    "removelicense",
    function(source, args, user)
        local xPlayer = ESX.GetPlayerFromId(source)

        if xPlayer.job.name == "police" and xPlayer.job.grade > 12 then
            if args[1] then
                if args[2] then
                    local target = tonumber(args[1])
                    if target ~= nil then
                        if GetPlayerName(target) then
                            if
                                args[2] == "weapon" or args[2] == "dmv" or args[2] == "drive" or args[2] == "truck" or
                                    args[2] == "bike" or
                                    args[2] == "fly"
                             then
                                local type = nil
                                local name = nil
                                if args[2] == "weapon" or args[2] == "dmv" or args[2] == "drive" or args[2] == "fly" then
                                    type = args[2]
                                elseif args[2] == "truck" or args[2] == "bike" then
                                    type = "drive_" .. args[2]
                                end

                                if args[2] == "weapon" then
                                    name = "Mojavez Aslahe"
                                elseif args[2] == "dmv" then
                                    name = "Ayin Naame"
                                elseif args[2] == "drive" then
                                    name = "Govahiname Ranandegi"
                                elseif args[2] == "truck" then
                                    name = "Govahiname Kamiyon"
                                elseif args[2] == "bike" then
                                    name = "Govahiname Motor"
                                elseif args[2] == "fly" then
                                    if xPlayer.hasDivision("xray") then
                                        name = "Mojaveze Parvaz"
                                    else
                                        TriggerClientEvent("esx:showNotification", source, "~r~~h~Shoma Xray Nistid")
                                        return
                                    end
                                end

                                MySQL.Async.fetchAll(
                                    "SELECT * FROM user_licenses WHERE owner=@identifier AND type = @type",
                                    {
                                        ["@identifier"] = GetPlayerIdentifiers(target)[1],
                                        ["@type"] = type
                                    },
                                    function(data)
                                        if data[1] then
                                            if args[2] == "fly" then
                                                TriggerClientEvent("esx_tracker:flyLicense", target, false)
                                                TriggerEvent("esx_license:removeLicense", target, type)
                                            else
                                                TriggerEvent("esx_license:removeLicense", target, type)
                                            end
                                            TriggerClientEvent(
                                                "chatMessage",
                                                source,
                                                "[LICENSE]",
                                                {255, 0, 0},
                                                " ^0Shoma ^2 " ..
                                                    name .. "^0 ^1" .. GetPlayerName(target) .. " ^0ra batel kardid!"
                                            )
                                            TriggerClientEvent(
                                                "chatMessage",
                                                target,
                                                "[LICENSE]",
                                                {255, 0, 0},
                                                " ^0" .. name .. " shoma ^1batel ^0shod!"
                                            )

                                            Citizen.Wait(1000)
                                            if
                                                args[2] == "dmv" or args[2] == "drive" or args[2] == "truck" or
                                                    args[2] == "bike"
                                             then
                                                TriggerEvent("esx_dmvschool:updateLicense", target)
                                            end
                                        else
                                            TriggerClientEvent(
                                                "chatMessage",
                                                source,
                                                "[LICENSE]",
                                                {255, 0, 0},
                                                "^2" .. GetPlayerName(target) .. " ^0 " .. name .. " nadarad!"
                                            )
                                        end
                                    end
                                )
                            else
                                TriggerClientEvent(
                                    "chatMessage",
                                    source,
                                    "[LICENSE]",
                                    {255, 0, 0},
                                    " ^0Mojavezi ke vared kardid na motabar ast!"
                                )
                            end
                        else
                            TriggerClientEvent(
                                "chatMessage",
                                source,
                                "[LICENSE]",
                                {255, 0, 0},
                                " ^0ID vared shode na motabar ast!"
                            )
                        end
                    else
                        TriggerClientEvent(
                            "chatMessage",
                            source,
                            "[LICENSE]",
                            {255, 0, 0},
                            " ^0Shoma bayad dar ghesmmat ID faghat adad vared konid!"
                        )
                    end
                else
                    TriggerClientEvent(
                        "chatMessage",
                        source,
                        "[LICENSE]",
                        {255, 0, 0},
                        " ^0Shoma dar ghesmat mojavez chizi vared nakardid!"
                    )
                end
            else
                TriggerClientEvent(
                    "chatMessage",
                    source,
                    "[LICENSE]",
                    {255, 0, 0},
                    " ^0Shoma bayad ID player marbote ra vared konid!"
                )
            end
        else
            TriggerClientEvent("esx:showNotification", source, "~r~~h~Shoma police ya highrank nistid!")
        end
    end,
    false
)