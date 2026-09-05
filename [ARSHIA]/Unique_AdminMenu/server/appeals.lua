-- FIX: UNIQUE_AC:getAppeals / UNIQUE_AC:reviewAppeal both gate on
-- UNIQUE_AC_GETADMINS(source) - UNIQUE_AC's OWN admin check (its own
-- FrameworkPermission/ACE/uniqueac_admin config), completely separate from
-- our IsOnDutyAdminFor. An admin who passes OUR check but isn't set up on
-- UNIQUE_AC's side got a silent no-op clicking those buttons.
--
-- Fix: don't go through UNIQUE_AC's events at all. Read/write the exact
-- same tables (uniqueac_appeals, uniqueac_banlist) directly, gated only by
-- our own IsOnDutyAdminFor('btn_appeals') - one permission system, no
-- second gate that can silently disagree with it. The actual unban still
-- goes through exports.UNIQUE_AC:UnbanPlayer (not a raw DELETE), so
-- whatever cache/Central-Hub-sync UNIQUE_AC does internally on unban still
-- happens correctly.

ESX.RegisterServerCallback('Unique_AdminMenu:GetPendingAppeals', function(source, cb)
    if not IsOnDutyAdminFor(source, 'btn_appeals') then cb({}) return end
    MySQL.Async.fetchAll(
        "SELECT id, identifier, player_name, ban_id, message, UNIX_TIMESTAMP(created_at) AS at FROM uniqueac_appeals WHERE status = 'pending' ORDER BY id DESC LIMIT 100",
        {}, function(rows) cb(rows or {}) end
    )
end)

RegisterServerEvent('Unique_AdminMenu:ReviewAppeal')
AddEventHandler('Unique_AdminMenu:ReviewAppeal', function(appealId, approve)
    local source = source
    if not IsOnDutyAdminFor(source, 'btn_appeals') then DenyButtonAccess(source, 'btn_appeals') return end
    appealId = tonumber(appealId)
    if not appealId then return end

    MySQL.Async.fetchAll(
        "SELECT identifier, ban_id, player_name FROM uniqueac_appeals WHERE id = @id AND status = 'pending' LIMIT 1",
        { ['@id'] = appealId },
        function(rows)
            local row = rows and rows[1]
            if not row then return end

            local status = approve and 'approved' or 'rejected'
            local adminName = GetPlayerName(source)

            MySQL.Async.execute(
                "UPDATE uniqueac_appeals SET status = @status, reviewed_by = @by, reviewed_at = NOW() WHERE id = @id",
                { ['@status'] = status, ['@by'] = adminName, ['@id'] = appealId }
            )

            if approve and row.ban_id and exports.UNIQUE_AC then
                exports.UNIQUE_AC:UnbanPlayer(row.ban_id, ("Admin %s (%s) via appeal #%s"):format(adminName, source, appealId))
            end

            LogAdminAction(source, "review-appeal", ("appeal #%s | %s | target: %s"):format(appealId, status, row.player_name or row.identifier), row.identifier, row.player_name)
        end
    )
end)
