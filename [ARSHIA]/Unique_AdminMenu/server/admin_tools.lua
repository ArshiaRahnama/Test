

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

ESX.RegisterServerCallback('Unique_AdminMenu:GetMyPermissionLevel', function(source, cb)
    local xPlayer = ESX.GetPlayerFromId(source)
    cb(xPlayer and xPlayer.permission_level or 0)
end)

ESX.RegisterServerCallback('Unique_AdminMenu:GetButtonPerms', function(source, cb)
    MySQL.Async.fetchAll('SELECT button_id, min_level FROM admin_button_perms', {}, function(rows)
        local perms = {}
        for _, r in ipairs(rows or {}) do perms[r.button_id] = r.min_level end
        cb(perms)
    end)
end)

RegisterServerEvent('Unique_AdminMenu:SetButtonPerm')
AddEventHandler('Unique_AdminMenu:SetButtonPerm', function(buttonId, minLevel)
    local source = source
    -- Deliberately gated at a higher bar than the rest of the admin
    -- tools: this controls what OTHER admins can even see, so it
    -- shouldn't be editable by every rank that can open the menu.
    local xPlayer = ESX.GetPlayerFromId(source)
    if not xPlayer or not xPlayer.permission_level or xPlayer.permission_level < 5 then return end

    buttonId = tostring(buttonId):sub(1, 80)
    minLevel = tonumber(minLevel)
    if not minLevel then return end

    MySQL.Async.execute(
        'INSERT INTO admin_button_perms (button_id, min_level) VALUES (@id, @level) ON DUPLICATE KEY UPDATE min_level = @level',
        { ['@id'] = buttonId, ['@level'] = minLevel }
    )
    ButtonPermsCache[buttonId] = minLevel -- enforcement takes effect immediately, no restart needed
    LogAdminAction(source, "set-button-perm", ("%s -> min level %s"):format(buttonId, minLevel))
end)

ESX.RegisterServerCallback('Unique_AdminMenu:GetConfirmSummary', function(source, cb, targetId)
    if not IsOnDutyAdmin(source) then cb(nil) return end
    local Target = ESX.GetPlayerFromId(tonumber(targetId))
    if not Target then cb(nil) return end

    MySQL.Async.fetchAll(
        "SELECT " ..
        "(SELECT COUNT(*) FROM admin_warnings WHERE identifier = @id) AS warnings, " ..
        "(SELECT COUNT(*) FROM unique_adminmenu_bans WHERE identifier = @id) AS bans, " ..
        "(SELECT COUNT(*) FROM admin_action_log WHERE target_identifier = @id AND action IN ('kick','jail','community-service')) AS punishments, " ..
        "(SELECT note FROM admin_player_flags WHERE identifier = @id LIMIT 1) AS flag_note",
        { ['@id'] = Target.identifier },
        function(rows)
            local r = rows and rows[1] or { warnings = 0, bans = 0, punishments = 0, flag_note = nil }
            local score = 100 - ((r.warnings or 0) * 5) - ((r.bans or 0) * 25) - ((r.punishments or 0) * 3)
            if score < 0 then score = 0 end
            cb({
                name = GetPlayerName(targetId),
                identifier = Target.identifier,
                job = Target.job and (Target.job.label or Target.job.name) or 'n/a',
                permission_level = Target.permission_level or 0,
                trustScore = score,
                warnings = r.warnings or 0,
                bans = r.bans or 0,
                flagNote = r.flag_note,
            })
        end
    )
end)

RegisterCommand('akick', function(source, args)
    if not IsOnDutyAdminFor(source, 'btn_kick') then DenyButtonAccess(source, 'btn_kick') return end
    local targetId = tonumber(args[1])
    if not targetId then return end
    local Target = ESX.GetPlayerFromId(targetId)
    if not Target then return end

    local reason = table.concat(args, ' ', 2)
    if reason == '' then reason = 'No reason specified' end

    LogAdminAction(source, "kick", ("target: %s (id:%s) | reason: %s"):format(GetPlayerName(targetId), targetId, reason), Target.identifier, GetPlayerName(targetId))

    -- Plays a short kidnap-van cutscene on the target before they're
    -- actually dropped (10s, matches the scene's animation length).
    TriggerClientEvent('Unique_AdminMenu:PlayKickScene', targetId)
    SetTimeout(10000, function()
        if GetPlayerName(targetId) then
            DropPlayer(targetId, ("You have been kicked by an admin.\nReason: %s"):format(reason))
        end
    end)
end, false)

RegisterCommand('aban', function(source, args)
    if not IsOnDutyAdminFor(source, 'btn_ban') then DenyButtonAccess(source, 'btn_ban') return end
    local targetId = tonumber(args[1])
    if not targetId then return end
    local Target = ESX.GetPlayerFromId(targetId)
    if not Target then return end

    local durationArg = args[2]
    local reason = table.concat(args, ' ', 3)
    if reason == '' then reason = 'No reason specified' end

    local permanent = (durationArg == 'perm' or durationArg == 'permanent')
    local minutes = tonumber(durationArg) or 0

    if not permanent and minutes <= 0 then
        TriggerClientEvent('esx:showNotification', source, "~r~Usage: /aban <id> <minutes|perm> <reason>")
        return
    end

    local identifier = Target.identifier
    local license = GetPlayerIdentifierByType(targetId, 'license') or 'no info'
    local playerip = GetPlayerEndpoint(targetId) or 'no info'
    local adminName = GetPlayerName(source)
    local targetName = GetPlayerName(targetId)
    local issuer = ("Admin %s (%s)"):format(adminName, source)

    -- Plays a short "banhammer" scene on the target before the ban actually
    -- takes effect. 12s is a safe upper bound for client/ban_scene.lua's
    -- two-part scene (arrest, timing-variable but pcall-guarded, + a fixed
    -- 6s finale) - see that file's SAFE_UPPER_BOUND_MS comment.
    TriggerClientEvent('Unique_AdminMenu:PlayBanScene', targetId, reason)

    SetTimeout(12000, function()
        if not GetPlayerName(targetId) then return end -- disconnected during the scene

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
    end)
end, false)

RegisterCommand('aunban', function(source, args)
    if not IsOnDutyAdminFor(source, 'btn_unban') then DenyButtonAccess(source, 'btn_unban') return end
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
    if not IsOnDutyAdminFor(source, 'btn_unban') then cb({}) return end
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
    if not IsOnDutyAdminFor(source, 'btn_givemoney') then DenyButtonAccess(source, 'btn_givemoney') return end
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
    if not IsOnDutyAdminFor(source, 'btn_setmoney') then DenyButtonAccess(source, 'btn_setmoney') return end
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
                            MySQL.Async.fetchAll(
                                "SELECT `plate`, `vehicle`, `type`, `stored`, `job` FROM `owned_vehicles` WHERE `owner` = @identifier LIMIT 30",
                                { ['@identifier'] = Target.identifier },
                                function(vehicles)
                                    local vehList = {}
                                    for _, v in ipairs(vehicles or {}) do
                                        local ok, props = pcall(json.decode, v.vehicle or '{}')
                                        vehList[#vehList + 1] = {
                                            plate = v.plate,
                                            model = ok and props and props.model or nil,
                                            type = v.type,
                                            stored = v.stored == 1,
                                            job = v.job,
                                        }
                                    end
                                    base.vehicles = vehList
                                    MySQL.Async.fetchAll(
                                        "SELECT `note`, `admin_name`, `created_at` FROM `admin_player_flags` WHERE `identifier` = @identifier",
                                        { ['@identifier'] = Target.identifier },
                                        function(flagRows)
                                            base.flag = flagRows and flagRows[1] or nil

                                            -- Trust score: starts at 100, docked per past
                                            -- infraction. Purely a quick-glance heuristic for
                                            -- admins, not used to gate anything automatically.
                                            MySQL.Async.fetchAll(
                                                "SELECT " ..
                                                "(SELECT COUNT(*) FROM admin_warnings WHERE identifier = @id) AS warnings, " ..
                                                "(SELECT COUNT(*) FROM unique_adminmenu_bans WHERE identifier = @id) AS bans, " ..
                                                "(SELECT COUNT(*) FROM admin_action_log WHERE target_identifier = @id AND action IN ('kick','jail','community-service')) AS punishments",
                                                { ['@id'] = Target.identifier },
                                                function(scoreRows)
                                                    local s = scoreRows and scoreRows[1] or { warnings = 0, bans = 0, punishments = 0 }
                                                    local score = 100 - (s.warnings * 5) - (s.bans * 25) - (s.punishments * 3)
                                                    if score < 0 then score = 0 end
                                                    base.trustScore = score
                                                    base.trustBreakdown = { warnings = s.warnings, bans = s.bans, punishments = s.punishments }
                                                    cb(base)
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
    if not IsOnDutyAdminFor(source, 'btn_spawnveh') then DenyButtonAccess(source, 'btn_spawnveh') return end
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
AddEventHandler('Unique_AdminMenu:ImpoundTarget', function(targetId, reason)
    local source = source
    if not IsOnDutyAdminFor(source, 'btn_impound') then DenyButtonAccess(source, 'btn_impound') return end
    targetId = tonumber(targetId)
    if not targetId or not ESX.GetPlayerFromId(targetId) then return end
    reason = (type(reason) == 'string' and reason ~= '') and reason or 'No reason specified'

    TriggerClientEvent('Unique_AdminMenu:ApplyImpound', targetId, reason, GetPlayerName(source))
end)

-- Client reports back the vehicle's plate/model (captured just before
-- deleting it) so the impound actually gets logged with something
-- searchable/releasable - the old version just deleted the car with no
-- record at all.
RegisterServerEvent('Unique_AdminMenu:ImpoundRecorded')
AddEventHandler('Unique_AdminMenu:ImpoundRecorded', function(plate, modelLabel, reason, adminName)
    local source = source
    local xPlayer = ESX.GetPlayerFromId(source)
    if not xPlayer then return end
    plate = tostring(plate or ''):sub(1, 12)
    if plate == '' then return end
    local ownerName = GetPlayerName(source)

    MySQL.Async.fetchAll("SELECT `owner` FROM `owned_vehicles` WHERE `plate` = @plate LIMIT 1", { ['@plate'] = plate }, function(rows)
        local ownerIdentifier = rows and rows[1] and rows[1].owner or xPlayer.identifier

        MySQL.Async.execute(
            "INSERT INTO `admin_impound_yard` (`plate`, `model_label`, `owner_identifier`, `owner_name`, `impounded_by`, `reason`, `impounded_at`, `released`) VALUES (@plate, @model, @owner, @ownername, @by, @reason, @at, 0)",
            {
                ['@plate'] = plate, ['@model'] = modelLabel, ['@owner'] = ownerIdentifier, ['@ownername'] = ownerName,
                ['@by'] = adminName, ['@reason'] = reason, ['@at'] = os.date('%Y-%m-%d %H:%M:%S'),
            }
        )
    end)

    LogAdminAction(source, "impound", ("target: %s (id:%s) | plate: %s | reason: %s"):format(ownerName, source, plate, reason), xPlayer.identifier, ownerName)
end)

ESX.RegisterServerCallback('Unique_AdminMenu:SearchImpoundYard', function(source, cb, query)
    if not IsOnDutyAdminFor(source, 'btn_impound_yard') then cb({}) return end
    query = tostring(query or ''):sub(1, 60)
    MySQL.Async.fetchAll(
        "SELECT * FROM `admin_impound_yard` WHERE `released` = 0 AND (`plate` LIKE @q OR `owner_name` LIKE @q) ORDER BY `id` DESC LIMIT 30",
        { ['@q'] = '%' .. query .. '%' },
        function(rows) cb(rows or {}) end
    )
end)

RegisterServerEvent('Unique_AdminMenu:ReleaseImpound')
AddEventHandler('Unique_AdminMenu:ReleaseImpound', function(recordId)
    local source = source
    if not IsOnDutyAdminFor(source, 'btn_impound') then DenyButtonAccess(source, 'btn_impound') return end
    recordId = tonumber(recordId)
    if not recordId then return end

    MySQL.Async.fetchAll("SELECT * FROM `admin_impound_yard` WHERE `id` = @id AND `released` = 0 LIMIT 1", { ['@id'] = recordId }, function(rows)
        local row = rows and rows[1]
        if not row then return end

        MySQL.Async.execute(
            "UPDATE `admin_impound_yard` SET `released` = 1, `released_at` = @at, `released_by` = @by WHERE `id` = @id",
            { ['@at'] = os.date('%Y-%m-%d %H:%M:%S'), ['@by'] = GetPlayerName(source), ['@id'] = recordId }
        )
        if row.plate then
            -- Puts it back in their garage (stored = available to pull out),
            -- since the actual entity was deleted at impound time.
            MySQL.Async.execute("UPDATE `owned_vehicles` SET `stored` = 1 WHERE `plate` = @plate", { ['@plate'] = row.plate })
        end
        LogAdminAction(source, "release-impound", ("record #%s | plate: %s | owner: %s"):format(recordId, row.plate, row.owner_name), row.owner_identifier, row.owner_name)
    end)
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
    if not IsOnDutyAdminFor(source, 'btn_weather') then DenyButtonAccess(source, 'btn_weather') return end
    if type(weatherName) ~= 'string' then return end
    TriggerClientEvent('Unique_AdminMenu:ApplyWeather', -1, weatherName)
    LogAdminAction(source, "set-weather", weatherName)
end)

RegisterServerEvent('Unique_AdminMenu:SetTime')
AddEventHandler('Unique_AdminMenu:SetTime', function(hour, minute)
    local source = source
    if not IsOnDutyAdminFor(source, 'btn_time') then DenyButtonAccess(source, 'btn_time') return end
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
    if source ~= 0 and not IsOnDutyAdminFor(source, 'btn_restart') then
        DenyButtonAccess(source, 'btn_restart')
        return
    end

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

    -- Persistent per-player archive (see admin_chat_archive in the SQL file)
    -- - the in-memory ChatLog above is capped at 500 messages server-wide
    -- and wiped on restart, too small for "search one player's history".
    local xPlayer = ESX.GetPlayerFromId(source)
    if xPlayer then
        MySQL.Async.execute(
            "INSERT INTO `admin_chat_archive` (`identifier`, `playername`, `message`, `created_at`) VALUES (@identifier, @name, @message, @createdat)",
            { ['@identifier'] = xPlayer.identifier, ['@name'] = name, ['@message'] = message, ['@createdat'] = os.date('%Y-%m-%d %H:%M:%S') }
        )
    end
end)

ESX.RegisterServerCallback('Unique_AdminMenu:GetChatLog', function(source, cb)
    if not IsOnDutyAdmin(source) then cb({}) return end
    cb(ChatLog)
end)

ESX.RegisterServerCallback('Unique_AdminMenu:GetPlayerChatArchive', function(source, cb, targetId, query)
    if not IsOnDutyAdmin(source) then cb({}) return end
    local Target = ESX.GetPlayerFromId(tonumber(targetId))
    if not Target then cb({}) return end

    query = tostring(query or ''):sub(1, 100)
    MySQL.Async.fetchAll(
        "SELECT `message`, `created_at` FROM `admin_chat_archive` WHERE `identifier` = @identifier AND `message` LIKE @q ORDER BY `id` DESC LIMIT 200",
        { ['@identifier'] = Target.identifier, ['@q'] = '%' .. query .. '%' },
        function(rows) cb(rows or {}) end
    )
end)
