-- Character transfer: moves money/bank/black_money/inventory/loadout and
-- reassigns all owned_vehicles from one identifier to another. Support
-- tool for edge cases (lost FiveM ID, account merge requests, etc.) - NOT
-- meant for routine use, hence the extra hard-coded permission floor below
-- on top of whatever the Button Permissions panel has btn_transfer set to.
--
-- Both accounts must be OFFLINE: if either is connected, their live
-- in-memory ESX player object would just overwrite our DB changes the
-- next time anything saves (money change, disconnect, etc.), silently
-- undoing the transfer or corrupting it halfway.
--
-- The destination's pre-transfer row is snapshotted into
-- admin_transfer_backups first, so a mistake is recoverable.

local TRANSFER_MIN_LEVEL = 4 -- hard floor, regardless of btn_transfer's configured level

local function IsIdentifierOnline(identifier)
    for _, playerId in ipairs(ESX.GetPlayers()) do
        local xPlayer = ESX.GetPlayerFromId(playerId)
        if xPlayer and xPlayer.identifier == identifier then return true end
    end
    return false
end

RegisterServerEvent('Unique_AdminMenu:TransferCharacter')
AddEventHandler('Unique_AdminMenu:TransferCharacter', function(sourceIdentifier, destIdentifier)
    local source = source
    local xPlayer = ESX.GetPlayerFromId(source)
    if not xPlayer or not xPlayer.permission_level or xPlayer.permission_level < TRANSFER_MIN_LEVEL
        or not IsOnDutyAdminFor(source, 'btn_transfer') then
        DenyButtonAccess(source, 'btn_transfer')
        return
    end

    sourceIdentifier = tostring(sourceIdentifier or ''):sub(1, 60)
    destIdentifier = tostring(destIdentifier or ''):sub(1, 60)
    if sourceIdentifier == '' or destIdentifier == '' or sourceIdentifier == destIdentifier then
        TriggerClientEvent('esx:showNotification', source, "~r~Need two different, valid identifiers.")
        return
    end

    if IsIdentifierOnline(sourceIdentifier) or IsIdentifierOnline(destIdentifier) then
        TriggerClientEvent('esx:showNotification', source, "~r~Both accounts must be OFFLINE for a transfer.")
        return
    end

    MySQL.Async.fetchAll("SELECT * FROM `users` WHERE `identifier` = @id LIMIT 1", { ['@id'] = sourceIdentifier }, function(srcRows)
        local src = srcRows and srcRows[1]
        if not src then
            TriggerClientEvent('esx:showNotification', source, "~r~Source identifier not found in users.")
            return
        end

        MySQL.Async.fetchAll("SELECT * FROM `users` WHERE `identifier` = @id LIMIT 1", { ['@id'] = destIdentifier }, function(destRows)
            local dest = destRows and destRows[1]
            if not dest then
                TriggerClientEvent('esx:showNotification', source, "~r~Destination identifier not found in users.")
                return
            end

            -- Backup destination's current state first.
            MySQL.Async.execute(
                "INSERT INTO `admin_transfer_backups` (`source_identifier`, `dest_identifier`, `dest_snapshot_json`, `admin_name`, `created_at`) VALUES (@src, @dest, @snapshot, @admin, @createdat)",
                {
                    ['@src'] = sourceIdentifier, ['@dest'] = destIdentifier, ['@snapshot'] = json.encode(dest),
                    ['@admin'] = GetPlayerName(source), ['@createdat'] = os.date('%Y-%m-%d %H:%M:%S'),
                }
            )

            MySQL.Async.execute(
                "UPDATE `users` SET `money` = @money, `bank` = @bank, `black_money` = @blackmoney, `inventory` = @inventory, `loadout` = @loadout WHERE `identifier` = @dest",
                {
                    ['@money'] = src.money, ['@bank'] = src.bank, ['@blackmoney'] = src.black_money,
                    ['@inventory'] = src.inventory, ['@loadout'] = src.loadout, ['@dest'] = destIdentifier,
                },
                function()
                    MySQL.Async.execute(
                        "UPDATE `owned_vehicles` SET `owner` = @dest WHERE `owner` = @src",
                        { ['@dest'] = destIdentifier, ['@src'] = sourceIdentifier },
                        function(vehiclesMoved)
                            local summary = ("%s -> %s | money:%s bank:%s | %s vehicle(s) reassigned"):format(
                                sourceIdentifier, destIdentifier, src.money, src.bank, vehiclesMoved or 0)
                            LogAdminAction(source, "character-transfer", summary)
                            TriggerClientEvent('esx:showNotification', source, ("~g~Transfer complete. %s vehicle(s) reassigned."):format(vehiclesMoved or 0))
                        end
                    )
                end
            )
        end)
    end)
end)
