

local ServerStartTime = os.time()

function ExemptFromAntiCheat(targetId, ms, kinds)
    if GetResourceState('UNIQUE_AC') ~= 'started' then return end
    pcall(function()
        exports['UNIQUE_AC']:ExemptPlayer(targetId, ms or 5000, kinds)
    end)
end

local FrozenPlayers = {}

RegisterServerEvent('Unique_AdminMenu:FreezePlayer')
AddEventHandler('Unique_AdminMenu:FreezePlayer', function(targetId)
    local source = source
    if not IsOnDutyAdmin(source) then return end
    targetId = tonumber(targetId)
    if not targetId or not ESX.GetPlayerFromId(targetId) then return end

    FrozenPlayers[targetId] = not FrozenPlayers[targetId]
    TriggerClientEvent('Unique_AdminMenu:ApplyFreeze', targetId, FrozenPlayers[targetId])
    LogAdminAction(source, "freeze", ("target: %s (id:%s) -> %s"):format(GetPlayerName(targetId), targetId, tostring(FrozenPlayers[targetId])), ESX.GetPlayerFromId(targetId).identifier, GetPlayerName(targetId))
end)

RegisterServerEvent('Unique_AdminMenu:HealPlayer')
AddEventHandler('Unique_AdminMenu:HealPlayer', function(targetId)
    local source = source
    if not IsOnDutyAdmin(source) then return end
    targetId = tonumber(targetId)
    if not targetId or not ESX.GetPlayerFromId(targetId) then return end

    TriggerClientEvent('Unique_AdminMenu:ApplyHeal', targetId)
    LogAdminAction(source, "heal", ("target: %s (id:%s)"):format(GetPlayerName(targetId), targetId), ESX.GetPlayerFromId(targetId).identifier, GetPlayerName(targetId))
end)

RegisterServerEvent('Unique_AdminMenu:RevivePlayer')
AddEventHandler('Unique_AdminMenu:RevivePlayer', function(targetId)
    local source = source
    if not IsOnDutyAdmin(source) then return end
    targetId = tonumber(targetId)
    if not targetId or not ESX.GetPlayerFromId(targetId) then return end

    TriggerClientEvent('Unique_AdminMenu:ApplyRevive', targetId)
    LogAdminAction(source, "revive", ("target: %s (id:%s)"):format(GetPlayerName(targetId), targetId), ESX.GetPlayerFromId(targetId).identifier, GetPlayerName(targetId))
end)

RegisterCommand('akick', function(source, args)
    if not IsOnDutyAdmin(source) then return end
    local targetId = tonumber(args[1])
    if not targetId then return end
    local Target = ESX.GetPlayerFromId(targetId)
    if not Target then return end

    local reason = table.concat(args, ' ', 2)
    if reason == '' then reason = 'No reason specified' end

    LogAdminAction(source, "kick", ("target: %s (id:%s) | reason: %s"):format(GetPlayerName(targetId), targetId, reason), Target.identifier, GetPlayerName(targetId))
    DropPlayer(targetId, ("You have been kicked by an admin.\nReason: %s"):format(reason))
end, false)

RegisterCommand('aban', function(source, args)
    if not IsOnDutyAdmin(source) then return end
    local targetId = tonumber(args[1])
    if not targetId then return end
    local Target = ESX.GetPlayerFromId(targetId)
    if not Target then return end

    local durationArg = args[2]
    local reason = table.concat(args, ' ', 3)
    if reason == '' then reason = 'No reason specified' end

    local permanent = (durationArg == 'perm' or durationArg == 'permanent')
    local minutes = tonumber(durationArg) or 0

    local identifier = Target.identifier
    local license = GetPlayerIdentifierByType(targetId, 'license') or 'no info'
    local playerip = GetPlayerEndpoint(targetId) or 'no info'
    local adminName = GetPlayerName(source)
    local targetName = GetPlayerName(targetId)
    local issuer = ("Admin %s (%s)"):format(adminName, source)

    if permanent then
        -- Real, enforced ban: Unique_Login's playerConnecting checks
        -- uniqueac_banlist (owned by UNIQUE_AC), so this is what actually
        -- keeps them out on reconnect - unlike the old banlist/banlisthistory
        -- tables, which nothing checks at connect time.
        if not exports.UNIQUE_AC then
            TriggerClientEvent('esx:showNotification', source, "~r~UNIQUE_AC not found - cannot issue an enforced permanent ban.")
            return
        end
        local ok, banId = exports.UNIQUE_AC:BanPlayer(targetId, reason, issuer)
        if not ok then
            TriggerClientEvent('esx:showNotification', source, "~r~Ban failed (player was kicked instead) - see server console.")
        end
        MySQL.Async.execute(
            "INSERT INTO `unique_adminmenu_bans` (`identifier`, `license`, `ip`, `playername`, `admin_name`, `reason`, `banned_at`, `expire_at`, `external_ban_id`, `active`) VALUES (@identifier, @license, @ip, @playername, @adminname, @reason, @bannedat, NULL, @extid, 1)",
            {
                ['@identifier'] = identifier, ['@license'] = license, ['@ip'] = playerip,
                ['@playername'] = targetName, ['@adminname'] = adminName, ['@reason'] = reason,
                ['@bannedat'] = os.date('%Y-%m-%d %H:%M:%S'), ['@extid'] = ok and tostring(banId) or nil,
            }
        )
        LogAdminAction(source, "ban", ("target: %s | PERMANENT | reason: %s"):format(targetName, reason), identifier, targetName)
    else
        if minutes <= 0 then
            TriggerClientEvent('esx:showNotification', source, "~r~Usage: /aban <id> <minutes|perm> <reason>")
            return
        end
        local expireAt = os.time() + (minutes * 60)
        MySQL.Async.execute(
            "INSERT INTO `unique_adminmenu_bans` (`identifier`, `license`, `ip`, `playername`, `admin_name`, `reason`, `banned_at`, `expire_at`, `active`) VALUES (@identifier, @license, @ip, @playername, @adminname, @reason, @bannedat, @expireat, 1)",
            {
                ['@identifier'] = identifier, ['@license'] = license, ['@ip'] = playerip,
                ['@playername'] = targetName, ['@adminname'] = adminName, ['@reason'] = reason,
                ['@bannedat'] = os.date('%Y-%m-%d %H:%M:%S'), ['@expireat'] = expireAt,
            }
        )
        DropPlayer(targetId, ("You have been banned for %s minutes.\nReason: %s"):format(minutes, reason))
        LogAdminAction(source, "ban", ("target: %s | %s minutes | reason: %s"):format(targetName, minutes, reason), identifier, targetName)
    end
end, false)

RegisterCommand('aunban', function(source, args)
    if not IsOnDutyAdmin(source) then return end
    local recordId = tonumber(args[1])
    if not recordId then
        TriggerClientEvent('esx:showNotification', source, "~r~Usage: /aunban <record id> (see Ban History Search)")
        return
    end

    MySQL.Async.fetchAll("SELECT * FROM `unique_adminmenu_bans` WHERE `id` = @id AND `active` = 1", { ['@id'] = recordId }, function(rows)
        local row = rows and rows[1]
        if not row then
            TriggerClientEvent('esx:showNotification', source, "~r~No active ban with that record id.")
            return
        end

        if row.external_ban_id and exports.UNIQUE_AC then
            exports.UNIQUE_AC:UnbanPlayer(row.external_ban_id, ("Admin %s (%s)"):format(GetPlayerName(source), source))
        end

        MySQL.Async.execute("UPDATE `unique_adminmenu_bans` SET `active` = 0 WHERE `id` = @id", { ['@id'] = recordId })
        LogAdminAction(source, "unban", ("record #%s | target: %s"):format(recordId, row.playername), row.identifier, row.playername)
        TriggerClientEvent('esx:showNotification', source, ("~g~Unbanned %s (record #%s)"):format(row.playername or row.identifier, recordId))
    end)
end, false)

ESX.RegisterServerCallback('Unique_AdminMenu:SearchBans', function(source, cb, query)
    if not IsOnDutyAdmin(source) then cb({}) return end
    query = tostring(query or ''):sub(1, 60)
    MySQL.Async.fetchAll(
        "SELECT * FROM `unique_adminmenu_bans` WHERE `active` = 1 AND (`playername` LIKE @q OR `identifier` LIKE @q) ORDER BY `id` DESC LIMIT 25",
        { ['@q'] = '%' .. query .. '%' },
        function(rows) cb(rows or {}) end
    )
end)

-- Temp-ban enforcement: our own connect-time gate, independent of
-- UNIQUE_AC/Unique_Login (those only ever see permanent bans, since
-- exports.UNIQUE_AC:BanPlayer is only called for the permanent case above).
AddEventHandler('playerConnecting', function(name, setKickReason, deferrals)
    local src = source
    deferrals.defer()
    Citizen.Wait(0)

    local license = GetPlayerIdentifierByType(src, 'license') or ''
    local ip = GetPlayerEndpoint(src) or ''

    MySQL.Async.fetchAll(
        "SELECT * FROM `unique_adminmenu_bans` WHERE `active` = 1 AND `expire_at` IS NOT NULL AND `expire_at` > @now AND (`license` = @license OR `ip` = @ip) ORDER BY `expire_at` DESC LIMIT 1",
        { ['@now'] = os.time(), ['@license'] = license, ['@ip'] = ip },
        function(rows)
            local row = rows and rows[1]
            if row then
                local minutesLeft = math.ceil((row.expire_at - os.time()) / 60)
                deferrals.done(("You are temporarily banned for %s more minute(s).\nReason: %s"):format(minutesLeft, row.reason or ''))
            else
                deferrals.done()
            end
        end
    )
end)

local Config_AutoActionAtWarnCount = 3

RegisterCommand('awarn', function(source, args)
    if not IsOnDutyAdmin(source) then return end
    local targetId = tonumber(args[1])
    if not targetId then return end
    local Target = ESX.GetPlayerFromId(targetId)
    if not Target then return end

    local reason = table.concat(args, ' ', 2)
    if reason == '' then reason = 'No reason specified' end

    MySQL.Async.execute(
        "INSERT INTO `admin_warnings` (`identifier`, `playername`, `admin_identifier`, `admin_name`, `reason`, `created_at`) VALUES (@identifier, @playername, @adminidentifier, @adminname, @reason, @createdat)",
        {
            ['@identifier'] = Target.identifier,
            ['@playername'] = GetPlayerName(targetId),
            ['@adminidentifier'] = ESX.GetPlayerFromId(source).identifier,
            ['@adminname'] = GetPlayerName(source),
            ['@reason'] = reason,
            ['@createdat'] = os.date('%Y-%m-%d %H:%M:%S'),
        },
        function()
            MySQL.Async.fetchScalar(
                "SELECT COUNT(*) FROM `admin_warnings` WHERE `identifier` = @identifier",
                { ['@identifier'] = Target.identifier },
                function(count)
                    count = tonumber(count) or 0
                    TriggerClientEvent('esx:showNotification', targetId, ("~y~You were warned by an admin (%s/%s): %s"):format(count, Config_AutoActionAtWarnCount, reason))
                    LogAdminAction(source, "warn", ("target: %s | reason: %s | total warnings: %s"):format(GetPlayerName(targetId), reason, count), Target.identifier, GetPlayerName(targetId))

                    if count >= Config_AutoActionAtWarnCount then
                        LogAdminAction(source, "auto-kick (warn threshold reached)", ("target: %s reached %s warnings"):format(GetPlayerName(targetId), count), Target.identifier, GetPlayerName(targetId))
                        DropPlayer(targetId, ("You have been kicked automatically after reaching %s warnings."):format(count))
                    end
                end
            )
        end
    )
end, false)

RegisterCommand('asetjob', function(source, args)
    if not IsOnDutyAdmin(source) then return end
    local targetId = tonumber(args[1])
    local job = args[2]
    local grade = tonumber(args[3]) or 0
    if not targetId or not job then return end
    local Target = ESX.GetPlayerFromId(targetId)
    if not Target then return end

    if not ESX.DoesJobExist(job, grade) then
        TriggerClientEvent('esx:showNotification', source, "~r~Job/Grade Vojod Nadarad!")
        return
    end

    Target.setJob(job, grade)
    LogAdminAction(source, "setjob", ("target: %s | job: %s grade: %s"):format(GetPlayerName(targetId), job, grade), Target.identifier, GetPlayerName(targetId))
end, false)

RegisterCommand('agivemoney', function(source, args)
    if not IsOnDutyAdmin(source) then return end
    local targetId = tonumber(args[1])
    local account = args[2]
    local amount = tonumber(args[3])
    local reason = table.concat(args, ' ', 4)
    if reason == '' then reason = 'No reason specified' end
    if not targetId or not amount or amount <= 0 or (account ~= 'money' and account ~= 'bank') then
        TriggerClientEvent('esx:showNotification', source, "~r~Estefade: /agivemoney [id] [money|bank] [amount] [reason]")
        return
    end
    local Target = ESX.GetPlayerFromId(targetId)
    if not Target then return end

    if account == 'money' then Target.addMoney(amount) else Target.addBank(amount) end
    LogAdminAction(source, "give-money", ("target: %s | %s: +%s | reason: %s"):format(GetPlayerName(targetId), account, amount, reason), Target.identifier, GetPlayerName(targetId))
end, false)

RegisterCommand('aremovemoney', function(source, args)
    if not IsOnDutyAdmin(source) then return end
    local targetId = tonumber(args[1])
    local account = args[2]
    local amount = tonumber(args[3])
    local reason = table.concat(args, ' ', 4)
    if reason == '' then reason = 'No reason specified' end
    if not targetId or not amount or amount <= 0 or (account ~= 'money' and account ~= 'bank') then
        TriggerClientEvent('esx:showNotification', source, "~r~Estefade: /aremovemoney [id] [money|bank] [amount] [reason]")
        return
    end
    local Target = ESX.GetPlayerFromId(targetId)
    if not Target then return end

    if account == 'money' then Target.removeMoney(amount) else Target.removeBank(amount) end
    LogAdminAction(source, "remove-money", ("target: %s | %s: -%s | reason: %s"):format(GetPlayerName(targetId), account, amount, reason), Target.identifier, GetPlayerName(targetId))
end, false)

ESX.RegisterServerCallback('Unique_AdminMenu:InspectPlayer', function(source, cb, targetId)
    if not IsOnDutyAdmin(source) then cb(nil) return end
    targetId = tonumber(targetId)
    local Target = ESX.GetPlayerFromId(targetId)
    if not Target then cb(nil) return end

    local base = {
        source = targetId,
        name = GetPlayerName(targetId),
        identifier = Target.identifier,
        job = Target.job,
        money = Target.getMoney and Target.getMoney() or Target.money,
        bank = Target.getAccount and (Target.getAccount('bank') or {}).money or Target.bank,
        inventory = Target.inventory,
        permission_level = Target.permission_level,
        ping = GetPlayerPing(targetId),
        history = {},
        notes = {},
        linkedAccounts = {},
    }

    MySQL.Async.fetchAll(
        "SELECT `admin_name`, `action`, `details`, `created_at` FROM `admin_action_log` WHERE `target_identifier` = @identifier ORDER BY `id` DESC LIMIT 25",
        { ['@identifier'] = Target.identifier },
        function(history)
            base.history = history or {}
            MySQL.Async.fetchAll(
                "SELECT `note`, `admin_name`, `created_at` FROM `admin_player_notes` WHERE `identifier` = @identifier ORDER BY `id` DESC",
                { ['@identifier'] = Target.identifier },
                function(notes)
                    base.notes = notes or {}
                    MySQL.Async.fetchAll(
                        "SELECT DISTINCT `identifier`, `playername` FROM `admin_ip_log` WHERE `ip` IN (SELECT `ip` FROM `admin_ip_log` WHERE `identifier` = @identifier) AND `identifier` != @identifier",
                        { ['@identifier'] = Target.identifier },
                        function(linked)
                            base.linkedAccounts = linked or {}
                            cb(base)
                        end
                    )
                end
            )
        end
    )
end)

RegisterServerEvent('Unique_AdminMenu:AddNote')
AddEventHandler('Unique_AdminMenu:AddNote', function(targetId, note)
    local source = source
    if not IsOnDutyAdmin(source) then return end
    targetId = tonumber(targetId)
    local Target = ESX.GetPlayerFromId(targetId)
    if not Target or type(note) ~= 'string' or note == '' then return end
    note = note:sub(1, 500)

    MySQL.Async.execute(
        "INSERT INTO `admin_player_notes` (`identifier`, `note`, `admin_name`, `created_at`) VALUES (@identifier, @note, @adminname, @createdat)",
        {
            ['@identifier'] = Target.identifier,
            ['@note'] = note,
            ['@adminname'] = GetPlayerName(source),
            ['@createdat'] = os.date('%Y-%m-%d %H:%M:%S'),
        }
    )
    LogAdminAction(source, "add-note", ("target: %s | note: %s"):format(GetPlayerName(targetId), note), Target.identifier, GetPlayerName(targetId))
end)

AddEventHandler('esx:playerLoaded', function(playerId, xPlayer)
    local ip = GetPlayerEndpoint(playerId)
    if not ip or ip == '' then return end

    local license = GetPlayerIdentifierByType(playerId, 'license') or 'no info'
    local discord = GetPlayerIdentifierByType(playerId, 'discord') or 'no info'
    local playername = GetPlayerName(playerId)

    MySQL.Async.execute(
        "INSERT INTO `admin_ip_log` (`identifier`, `license`, `discord`, `ip`, `playername`, `last_seen`) VALUES (@identifier, @license, @discord, @ip, @playername, @lastseen) ON DUPLICATE KEY UPDATE `playername` = @playername, `last_seen` = @lastseen",
        {
            ['@identifier'] = xPlayer.identifier,
            ['@license'] = license,
            ['@discord'] = discord,
            ['@ip'] = ip,
            ['@playername'] = playername,
            ['@lastseen'] = os.date('%Y-%m-%d %H:%M:%S'),
        }
    )

    MySQL.Async.fetchAll(
        "SELECT DISTINCT `identifier`, `playername` FROM `admin_ip_log` WHERE `ip` = @ip AND `identifier` != @identifier",
        { ['@ip'] = ip, ['@identifier'] = xPlayer.identifier },
        function(others)
            if others and #others > 0 then
                local names = {}
                for _, row in ipairs(others) do
                    names[#names + 1] = row.playername or row.identifier
                end
                local msg = ("[Multi-Account] %s just connected from the same IP as: %s"):format(playername, table.concat(names, ', '))
                print("[Unique_AdminMenu] " .. msg)

                for _, adminId in ipairs(ESX.GetPlayers()) do
                    if IsOnDutyAdmin(adminId) then
                        TriggerClientEvent('chatMessage', adminId, "[Multi-Account]", { 255, 165, 0 }, msg)
                    end
                end
            end
        end
    )
end)

RegisterServerEvent('Unique_AdminMenu:SpawnVehicle')
AddEventHandler('Unique_AdminMenu:SpawnVehicle', function(model, plate)
    local source = source
    if not IsOnDutyAdmin(source) then return end
    if type(model) ~= 'string' or model == '' then return end
    plate = (type(plate) == 'string' and plate ~= '') and plate:sub(1, 8) or ('ADM' .. tostring(math.random(1000, 9999)))

    TriggerClientEvent('Unique_AdminMenu:ApplySpawnVehicle', source, model, plate)
    LogAdminAction(source, "spawn-vehicle", ("model: %s | plate: %s"):format(model, plate))
end)

RegisterServerEvent('Unique_AdminMenu:VehicleAction')
AddEventHandler('Unique_AdminMenu:VehicleAction', function(action)
    local source = source
    if not IsOnDutyAdmin(source) then return end
    local valid = { fix = true, clean = true, deletenearest = true }
    if not valid[action] then return end

    TriggerClientEvent('Unique_AdminMenu:ApplyVehicleAction', source, action)
    LogAdminAction(source, "vehicle-" .. action, nil)
end)

RegisterServerEvent('Unique_AdminMenu:ImpoundTarget')
AddEventHandler('Unique_AdminMenu:ImpoundTarget', function(targetId)
    local source = source
    if not IsOnDutyAdmin(source) then return end
    targetId = tonumber(targetId)
    if not targetId or not ESX.GetPlayerFromId(targetId) then return end

    TriggerClientEvent('Unique_AdminMenu:ApplyImpound', targetId)
    LogAdminAction(source, "impound", ("target: %s (id:%s)"):format(GetPlayerName(targetId), targetId), ESX.GetPlayerFromId(targetId).identifier, GetPlayerName(targetId))
end)

RegisterServerEvent('Unique_AdminMenu:BringTarget')
AddEventHandler('Unique_AdminMenu:BringTarget', function(targetId)
    local source = source
    if not IsOnDutyAdmin(source) then return end
    targetId = tonumber(targetId)
    local Target = ESX.GetPlayerFromId(targetId)
    if not Target then return end

    local coords = GetEntityCoords(GetPlayerPed(source))
    ExemptFromAntiCheat(targetId, 5000, { teleport = true, speed = true })
    TriggerClientEvent('Unique_AdminMenu:ApplyTeleportCoords', targetId, coords.x, coords.y, coords.z)
    LogAdminAction(source, "bring", ("target: %s (id:%s)"):format(GetPlayerName(targetId), targetId), Target.identifier, GetPlayerName(targetId))
end)

RegisterServerEvent('Unique_AdminMenu:SetWeather')
AddEventHandler('Unique_AdminMenu:SetWeather', function(weatherName)
    local source = source
    if not IsOnDutyAdmin(source) then return end
    if type(weatherName) ~= 'string' then return end
    TriggerClientEvent('Unique_AdminMenu:ApplyWeather', -1, weatherName)
    LogAdminAction(source, "set-weather", weatherName)
end)

RegisterServerEvent('Unique_AdminMenu:SetTime')
AddEventHandler('Unique_AdminMenu:SetTime', function(hour, minute)
    local source = source
    if not IsOnDutyAdmin(source) then return end
    hour, minute = tonumber(hour), tonumber(minute) or 0
    if not hour or hour < 0 or hour > 23 then return end
    TriggerClientEvent('Unique_AdminMenu:ApplyTime', -1, hour, minute)
    LogAdminAction(source, "set-time", ("%02d:%02d"):format(hour, minute))
end)

RegisterServerEvent('Unique_AdminMenu:TeleportCoords')
AddEventHandler('Unique_AdminMenu:TeleportCoords', function(x, y, z)
    local source = source
    if not IsOnDutyAdmin(source) then return end
    x, y, z = tonumber(x), tonumber(y), tonumber(z)
    if not (x and y and z) then return end
    ExemptFromAntiCheat(source, 5000, { teleport = true, speed = true })
    TriggerClientEvent('Unique_AdminMenu:ApplyTeleportCoords', source, x, y, z)
    LogAdminAction(source, "teleport-coords", ("%.2f, %.2f, %.2f"):format(x, y, z))
end)

RegisterServerEvent('Unique_AdminMenu:AntiCheatExempt')
AddEventHandler('Unique_AdminMenu:AntiCheatExempt', function(ms, kinds)
    local source = source
    if not IsOnDutyAdmin(source) then return end
    ExemptFromAntiCheat(source, ms, kinds)
end)

ESX.RegisterServerCallback('Unique_AdminMenu:GetSavedLocations', function(source, cb)
    if not IsOnDutyAdmin(source) then cb({}) return end
    MySQL.Async.fetchAll("SELECT `id`, `name`, `x`, `y`, `z` FROM `admin_saved_locations` ORDER BY `name` ASC", {}, function(rows)
        cb(rows or {})
    end)
end)

RegisterServerEvent('Unique_AdminMenu:SaveLocation')
AddEventHandler('Unique_AdminMenu:SaveLocation', function(name, x, y, z)
    local source = source
    if not IsOnDutyAdmin(source) then return end
    if type(name) ~= 'string' or name == '' then return end
    x, y, z = tonumber(x), tonumber(y), tonumber(z)
    if not (x and y and z) then return end

    MySQL.Async.execute(
        "INSERT INTO `admin_saved_locations` (`name`, `x`, `y`, `z`, `created_by`) VALUES (@name, @x, @y, @z, @createdby)",
        { ['@name'] = name, ['@x'] = x, ['@y'] = y, ['@z'] = z, ['@createdby'] = GetPlayerName(source) }
    )
    LogAdminAction(source, "save-location", ("name: %s"):format(name))
end)

RegisterCommand('aannounce', function(source, args)
    if source ~= 0 and not IsOnDutyAdmin(source) then return end
    local message = table.concat(args, ' ')
    if message == '' then return end

    TriggerClientEvent('chatMessage', -1, "[ANNOUNCE]", { 255, 165, 0 }, message)
    LogAdminAction(source, "announce", message)
end, false)

RegisterCommand('arestart', function(source, args)



    if source ~= 0 and not IsAllowed(source, 'command.arestart') then
        TriggerClientEvent('esx:showNotification', source, "~r~Shoma ACE Dastresi Baraye In Dastor Ra Nadarid!")
        return
    end
    local resourceName = args[1]
    if not resourceName then return end

    LogAdminAction(source, "restart-resource", resourceName)
    ExecuteCommand('restart ' .. resourceName)
end, false)

function IsAllowed(source, ace)
    return IsPlayerAceAllowed(source, ace)
end

ESX.RegisterServerCallback('Unique_AdminMenu:GetServerStats', function(source, cb)
    if not IsOnDutyAdmin(source) then cb(nil) return end

    local openReports = 0
    local ok, reports = pcall(function() return exports.esx_aduty:GetReports() end)
    if ok and reports then
        for _, r in pairs(reports) do
            if r.status == "open" then
                openReports = openReports + 1
            end
        end
    end

    cb({
        online = #ESX.GetPlayers(),
        maxPlayers = GetConvarInt('sv_maxclients', 32),
        uptimeSeconds = os.time() - ServerStartTime,
        openReports = openReports,
    })
end)

ESX.RegisterServerCallback('Unique_AdminMenu:GetReports', function(source, cb)
    if not IsOnDutyAdmin(source) then cb({}) return end
    local ok, reports = pcall(function() return exports.esx_aduty:GetReports() end)
    cb(ok and reports or {})
end)

local ChatLog = {}
local ChatLogMax = 500

AddEventHandler('chatMessage', function(source, name, message)
    table.insert(ChatLog, {
        source = source,
        name = name,
        message = message,
        time = os.date('%H:%M:%S'),
    })
    if #ChatLog > ChatLogMax then
        table.remove(ChatLog, 1)
    end
end)

ESX.RegisterServerCallback('Unique_AdminMenu:GetChatLog', function(source, cb)
    if not IsOnDutyAdmin(source) then cb({}) return end
    cb(ChatLog)
end)
