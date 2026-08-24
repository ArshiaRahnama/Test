

function isAllowedToReset(player)
    local allowed = false
    for i, id in ipairs(resetaccountAceess) do
        for x, pid in ipairs(GetPlayerIdentifiers(player)) do
            if string.lower(pid) == string.lower(id) then
                allowed = true
            end
        end
    end

    return allowed
end

function isAllowedToDisband(player)
    local allowed = false
    for i, id in ipairs(disbandfamilyAceess) do
        for x, pid in ipairs(GetPlayerIdentifiers(player)) do
            if string.lower(pid) == string.lower(id) then
                allowed = true
            end
        end
    end

    return allowed
end

function TableLength(table)
    local count = 0
    for _ in pairs(table) do
        count = count + 1
    end
    return count
end

function DutyHandler(target, state, aa, isOwner, aa2)
    local xPlayer = ESX.GetPlayerFromId(target)
    isOwner = isOwner or false
    if state then
        if aa then
            if isOwner then


                if aa2 then
                    AdminPlayers[xPlayer.identifier] = {
                        source = xPlayer.source,
                        permission = xPlayer.permission_level,
                        hide = false
                    }
                    OnDuty[xPlayer.source] = true
                    xPlayer.set('OnDuty', true)
                    ItsAA = xPlayer.get("aduty")
                    if xPlayer.permission_level >= 8 and ItsAA ~= true then
                        xPlayer.set("aduty", true)
                    end

                    ExecuteCommand("add_principal identifier." .. xPlayer.identifier .. " group.admin")
                    TriggerClientEvent("OnDutyHandler", xPlayer.source, true)
                    TriggerClientEvent('esx:ActiveAdminPerks', xPlayer.source, true)
                    TriggerClientEvent("aduty:addSuggestions", xPlayer.source)
                    TriggerClientEvent("chatMessage",xPlayer.source,"[SYSTEM]", {255, 0, 0}, " ^0Shoma ^1[AA]OnDuty ^0Shodid Ba Tag Khamosh!")

                else
                    AdminPlayers[xPlayer.identifier] = {
                        source = xPlayer.source,
                        permission = xPlayer.permission_level,
                        hide = false
                    }
                    OnDuty[xPlayer.source] = true
                    xPlayer.set('OnDuty', true)
                    ItsAA = xPlayer.get("aduty")
                    if xPlayer.permission_level >= 8 and ItsAA ~= true then
                        xPlayer.set("aduty", true)
                    end

                    TriggerClientEvent('aduty:tagChanger', xPlayer.source, true)
                    ExecuteCommand("add_principal identifier." .. xPlayer.identifier .. " group.admin")
                    TriggerClientEvent("OnDutyHandler", xPlayer.source, true)
                    TriggerClientEvent('esx:ActiveAdminPerks', xPlayer.source, true)
                    TriggerClientEvent("aduty:addSuggestions", xPlayer.source)
                    TriggerClientEvent("chatMessage",xPlayer.source,"[SYSTEM]", {255, 0, 0}, " ^0Shoma ^1[AA]OnDuty ^0Shodid!")
                end
            end
        else

            xPlayer.set("aduty", true)
            AdminPlayers[xPlayer.identifier] = {
                source = xPlayer.source,
                permission = xPlayer.permission_level,
                hide = false
            }
			xPlayer.set('OnDuty', true)
            TriggerClientEvent("aduty:tagChanger", xPlayer.source, true)
            ExecuteCommand("add_principal identifier." .. xPlayer.identifier .. " group.admin")
            TriggerClientEvent("OnDutyHandler", xPlayer.source, false)
			TriggerClientEvent("adutyHandler", xPlayer.source)
            TriggerClientEvent("aduty:addSuggestions", xPlayer.source)
			TriggerClientEvent('esx:ActiveAdminPerks', xPlayer.source, true)
            TriggerClientEvent("chatMessage", xPlayer.source, "[SYSTEM]", {255, 0, 0}, " ^0Shoma ^2OnDuty ^0Shodid!")
        end
    else
        if aa then
            if isOwner then


                xPlayer.set("aduty", false)

                AdminPlayers[xPlayer.identifier] = nil
				OnDuty[xPlayer.source] = false
				xPlayer.set('OnDuty', false)
                TriggerClientEvent('aduty:tagChanger', xPlayer.source, false)
				ExecuteCommand("add_principal identifier." .. xPlayer.identifier .. " group.admin")
                ExecuteCommand("remove_principal identifier." .. xPlayer.identifier .. " group.admin")
                TriggerClientEvent("OffDutyHandler", xPlayer.source, false)
                TriggerClientEvent('esx:ActiveAdminPerks', xPlayer.source, false)
                TriggerClientEvent("aduty:removeSuggestions", xPlayer.source)
                TriggerClientEvent("aduty:visibleForce", xPlayer.source, true)
                TriggerClientEvent(
                    "chatMessage",
                    xPlayer.source,
                    "[SYSTEM]",
                    {255, 0, 0},
                    " ^0Shoma ^1[AA]OffDuty ^0Shodid!"
                )
            end
        else
            xPlayer.set("aduty", false)
			xPlayer.set('OnDuty', false)
            ExecuteCommand("remove_principal identifier." .. xPlayer.identifier .. " group.admin")
            AdminPlayers[xPlayer.identifier] = nil
            TriggerClientEvent("aduty:tagChanger", xPlayer.source, false)
            TriggerClientEvent("OffDutyHandler", xPlayer.source, false)

            TriggerClientEvent("AdminOffDuty", xPlayer.source)
            TriggerClientEvent("aduty:removeSuggestions", xPlayer.source)
			TriggerClientEvent('esx:ActiveAdminPerks', xPlayer.source, false)
            TriggerClientEvent("aduty:visibleForce", xPlayer.source)
            TriggerClientEvent("chatMessage", xPlayer.source, "[SYSTEM]", {255, 0, 0}, " ^0Shoma ^1OffDuty ^0Shodid!")
        end
    end
end

function DutyHandlerForJail(target, state, aa, isOwner)
    local xPlayer = ESX.GetPlayerFromId(target)

    isOwner = isOwner or false
    if state then
        if aa then
            if isOwner then

                xPlayer.set("aduty", true)
                AdminPlayers[xPlayer.identifier] = {
                    source = xPlayer.source,
                    permission = xPlayer.permission_level,
                    hide = false
                }
				xPlayer.set('OnDuty', true)
                TriggerClientEvent('aduty:tagChanger', xPlayer.source, true)
                ExecuteCommand("add_principal identifier." .. xPlayer.identifier .. " group.admin")
                TriggerClientEvent("OnDutyHandler", xPlayer.source, true)
				TriggerClientEvent('esx:ActiveAdminPerks', xPlayer.source, true)
                TriggerClientEvent("aduty:addSuggestions", xPlayer.source)
                TriggerClientEvent(
                    "chatMessage",
                    xPlayer.source,
                    "[SYSTEM]",
                    {255, 0, 0},
                    " ^0On Duty!"
                )
            end
        else

            xPlayer.set("aduty", true)
            AdminPlayers[xPlayer.identifier] = {
                source = xPlayer.source,
                permission = xPlayer.permission_level,
                hide = false
            }
			xPlayer.set('OnDuty', true)
            TriggerClientEvent("aduty:tagChanger", xPlayer.source, true)
            ExecuteCommand("add_principal identifier." .. xPlayer.identifier .. " group.admin")
            TriggerClientEvent("OnDutyHandler", xPlayer.source, false)
			TriggerClientEvent("adutyHandler", xPlayer.source)
            TriggerClientEvent("aduty:addSuggestions", xPlayer.source)
			TriggerClientEvent('esx:ActiveAdminPerks', xPlayer.source, true)
            TriggerClientEvent("chatMessage", xPlayer.source, "[SYSTEM]", {255, 0, 0}, " ^0Shoma ^2OnDuty ^0Shodid!")
        end
    else
        if aa then
            if isOwner then



                AdminPlayers[xPlayer.identifier] = nil
				xPlayer.set('OnDuty', false)
                TriggerClientEvent('aduty:tagChanger', xPlayer.source, false)
				ExecuteCommand("add_principal identifier." .. xPlayer.identifier .. " group.admin")
                ExecuteCommand("remove_principal identifier." .. xPlayer.identifier .. " group.admin")
                TriggerClientEvent("OffDutyHandlerForJail", xPlayer.source)
                TriggerClientEvent('esx:ActiveAdminPerks', xPlayer.source, false)
                TriggerClientEvent("aduty:removeSuggestions", xPlayer.source)
                TriggerClientEvent("aduty:visibleForce", xPlayer.source, true)
                TriggerClientEvent("chatMessage", xPlayer.source,"[SYSTEM]", {255, 0, 0}," ^0Shoma ^1[AA]OffDuty ^0Shodid!")
            end
        else
            xPlayer.set("aduty", false)
			xPlayer.set('OnDuty', false)
            ExecuteCommand("remove_principal identifier." .. xPlayer.identifier .. " group.admin")
            AdminPlayers[xPlayer.identifier] = nil
                TriggerClientEvent('aduty:tagChanger', xPlayer.source, false)
				ExecuteCommand("add_principal identifier." .. xPlayer.identifier .. " group.EAAAdmin")
                ExecuteCommand("remove_principal identifier." .. xPlayer.identifier .. " group.EAAAdmin")
                TriggerClientEvent("OffDutyHandlerForJail", xPlayer.source)
                TriggerClientEvent('esx:ActiveAdminPerks', xPlayer.source, false)
                TriggerClientEvent("aduty:removeSuggestions", xPlayer.source)
                TriggerClientEvent("aduty:visibleForce", xPlayer.source, true)
            TriggerClientEvent("chatMessage", xPlayer.source, "[SYSTEM]", {255, 0, 0}, " ^0Shoma ^1OffDuty ^0Shodid!")
        end
    end
end

function DeleteAccounts()
    for i, v in ipairs(deleteUsers) do
        local identifier = v
        MySQL.Async.execute("DELETE FROM addon_account_data WHERE owner = @identifier", {["@identifier"] = identifier})
        MySQL.Async.execute(
            "DELETE FROM addon_inventory_items WHERE owner = @identifier",
            {["@identifier"] = identifier}
        )
        MySQL.Async.execute("DELETE FROM billing WHERE identifier = @identifier", {["@identifier"] = identifier})
        MySQL.Async.execute("DELETE FROM billing WHERE sender = @identifier", {["@identifier"] = identifier})
        MySQL.Async.execute("DELETE FROM datastore_data WHERE owner = @identifier", {["@identifier"] = identifier})
        MySQL.Async.execute("DELETE FROM owned_properties WHERE owner = @identifier", {["@identifier"] = identifier})
        MySQL.Async.execute("DELETE FROM owned_vehicles WHERE owner = @identifier", {["@identifier"] = identifier})
        MySQL.Async.execute("DELETE FROM user_accounts WHERE identifier = @identifier", {["@identifier"] = identifier})
        MySQL.Async.execute("DELETE FROM users WHERE identifier = @identifier", {["@identifier"] = identifier})
        count = count + 1
    end

    print("Total Deleted users: " .. tostring(count))
end

function CK(target, iniator, reason)
    local xPlayer = ESX.GetPlayerFromIdentifier(target.identifier)
    if xPlayer then
        DropPlayer(xPlayer.source, "Shoma character kill shodid, lotfan dobare join dahid!")
    end

    MySQL.Async.execute(
        "DELETE FROM addon_account_data WHERE owner = @identifier",
        {["@identifier"] = target.identifier}
    )
    MySQL.Async.execute(
        "DELETE FROM addon_inventory_items WHERE owner = @identifier",
        {["@identifier"] = target.identifier}
    )
    MySQL.Async.execute("DELETE FROM billing WHERE identifier = @identifier", {["@identifier"] = target.identifier})
    MySQL.Async.execute("DELETE FROM billing WHERE sender = @identifier", {["@identifier"] = target.identifier})
    MySQL.Async.execute("DELETE FROM datastore_data WHERE owner = @identifier", {["@identifier"] = target.identifier})
    MySQL.Async.execute("DELETE FROM owned_properties WHERE owner = @identifier", {["@identifier"] = target.identifier})
    MySQL.Async.execute("DELETE FROM owned_vehicles WHERE owner = @identifier", {["@identifier"] = target.identifier})
    MySQL.Async.execute(
        "DELETE FROM user_accounts WHERE identifier = @identifier",
        {["@identifier"] = target.identifier}
    )
    MySQL.Async.execute(
        'UPDATE users SET bank = 0, money = 0, job = "nojob", job_grade = 0, gang = "nogang", gang_grade = 0, inventory = "[]", loadout = "[]", position = NULL, skin = NULL, divisions = "[]" WHERE identifier = @identifier',
        {["@identifier"] = target.identifier}
    )

    TriggerEvent(
        "DiscordBot:ToDiscord",
        "disband",
        "ResetAccount Log",
        (GetPlayerName(iniator) or iniator) .. " accounte " .. target.name .. " ra reset kard be dalil: " .. reason,
        "user",
        true,
        iniator or 1,
        false
    )
    if tonumber(iniator) then
        TriggerClientEvent(
            "chatMessage",
            iniator,
            "[SYSTEM]",
            {255, 0, 0},
            " ^0Account ^1" .. target.name .. " ^0ba ^2movafaghiat ^0reset shod, Dalil: " .. reason
        )
    end
    TriggerClientEvent(
        "chatMessage",
        -1,
        "[SYSTEM]",
        {255, 0, 0},
        " ^0Account ^2" .. target.name .. " ^0be dalil ^1" .. reason .. " ^0reset shod!"
    )
end

function GetSecond()
    local date = os.date("*t")

    if date.sec < 10 then
        date.sec = "0" .. tostring(date.sec)
    end

    return tonumber(date.sec)
end

function KickAll()
    for _, id in ipairs(GetPlayers()) do
        DropPlayer(id, "Server dar hale restart shodan ast lotfan shakiba bashid")
    end
end

