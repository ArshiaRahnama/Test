-- ================================================================= --
-- HUD menu callbacks (was Interaction_Menu/server.lua)
-- ================================================================= --
-- FIX: GetAcc used to hand back the ENTIRE raw xPlayer object over the
-- network. It's always for the requesting player's own data (source is
-- fixed server-side, can't be spoofed to fetch someone else's), so it
-- wasn't a cross-player leak — but it was still sending internal fields
-- the UI never uses. Trimmed to just what the HUD needs.
-- ================================================================= --

ESX.RegisterServerCallback("HUD_Menu:GetAcc", function(source, cb)
    local xPlayer = ESX.GetPlayerFromId(source)
    if not xPlayer then return cb(nil) end

    GetXPRankCached(source, function(xp, rank)
        MySQL.Async.fetchAll('SELECT Profile_Pic, divisions, iban, account_num, timePlay, DATE_FORMAT(created_at, "%Y-%m-%d") AS memberSince FROM users WHERE identifier = @identifier', {
            ['@identifier'] = xPlayer.identifier
        }, function(result)
            local row = result[1] or {}
            local profilePic = row.Profile_Pic

            -- Real division system already used by esx_society: users.divisions
            -- is a JSON array of {label, status, job, name}. We only care
            -- about one that's active (status == true) for the player's
            -- CURRENT job.
            local divisionLabel = nil
            if row.divisions and row.divisions ~= '' then
                local ok, divisions = pcall(json.decode, row.divisions)
                if ok and type(divisions) == 'table' then
                    for _, div in pairs(divisions) do
                        if div.status and div.job == xPlayer.job.name then
                            divisionLabel = div.label
                            break
                        end
                    end
                end
            end

            local function withGangLogo(gangLogo)
                cb({
                    name             = xPlayer.name,
                    job              = xPlayer.job,
                    gang             = xPlayer.gang,
                    rank             = rank or 1,
                    xp               = xp or 0,
                    money            = xPlayer.money,
                    bank             = xPlayer.bank,
                    permission_level = xPlayer.permission_level,
                    aduty            = xPlayer.aduty,
                    avatarUrl        = (profilePic ~= nil and profilePic ~= '') and profilePic or nil,
                    gangLogoUrl      = gangLogo,
                    divisionLabel    = divisionLabel,
                    iban             = row.iban,
                    accountNum       = row.account_num,
                    memberSince      = row.memberSince,
                    hours            = math.floor((row.timePlay or 0) / 3600),
                })
            end

            if xPlayer.gang and xPlayer.gang.name and xPlayer.gang.name ~= 'nogang' then
                MySQL.Async.fetchScalar('SELECT logo FROM gangs_data WHERE gang_name = @name', {
                    ['@name'] = xPlayer.gang.name
                }, function(logo)
                    withGangLogo((logo ~= nil and logo ~= '' and logo ~= 'defaultlogo') and logo or nil)
                end)
            else
                withGangLogo(nil)
            end
        end)
    end)
end)

ESX.RegisterServerCallback("HUD_Menu:GetCC", function(source, cb)
    local xPlayer = ESX.GetPlayerFromId(source)
    if not xPlayer then return cb(0) end

    MySQL.Async.fetchScalar('SELECT coin FROM users WHERE identifier = @identifier', {
        ['@identifier'] = xPlayer.identifier
    }, function(coin)
        cb(coin or 0)
    end)
end)

ESX.RegisterServerCallback("HUD_Menu:GetQuests", function(source, cb)
    local xPlayer = ESX.GetPlayerFromId(source)
    if not xPlayer then return cb({}) end

    MySQL.Async.fetchAll('SELECT * FROM quest WHERE identifier = @identifier', {
        ['@identifier'] = xPlayer.identifier
    }, function(result)
        if result[1] and result[1].quests then
            cb(json.decode(result[1].quests))
        else
            cb({})
        end
    end)
end)
