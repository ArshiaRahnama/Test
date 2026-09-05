-- Faction/society treasury audit (addon_account_data - the standard ESX
-- society account table, e.g. society_police, society_ambulance).
-- Snapshots every account's balance periodically for the history view and
-- spike detection; adding money is a separate, higher-permission action
-- from just viewing.

local FACTION_ADD_MIN_LEVEL = 4 -- hard floor for adding money, regardless of btn_faction's configured level

local Config_FactionSnapshot = {
    IntervalMs = 15 * 60 * 1000, -- every 15 minutes
    SpikeThreshold = 200000,     -- flag if a treasury jumps more than this in one interval
}

local LastFactionBalance = {}

local function SnapshotFactionAccounts()
    MySQL.Async.fetchAll("SELECT `account_name`, `money` FROM `addon_account_data` WHERE `account_name` LIKE 'society_%'", {}, function(rows)
        for _, r in ipairs(rows or {}) do
            MySQL.Async.execute(
                "INSERT INTO `admin_faction_snapshots` (`account_name`, `balance`, `taken_at`) VALUES (@name, @balance, @at)",
                { ['@name'] = r.account_name, ['@balance'] = r.money, ['@at'] = os.time() }
            )

            local last = LastFactionBalance[r.account_name]
            if last and (r.money - last) > Config_FactionSnapshot.SpikeThreshold then
                local note = ("%s treasury jumped +%s in <=15min"):format(r.account_name, r.money - last)
                for _, src in ipairs(ESX.GetPlayers()) do
                    if IsOnDutyAdmin(src) then
                        TriggerClientEvent('chat:addMessage', src, {
                            color = { 255, 120, 60 },
                            args = { "[FACTION SPIKE]", note },
                        })
                    end
                end
                print("[Unique_AdminMenu] " .. note)
            end
            LastFactionBalance[r.account_name] = r.money
        end
    end)
end

Citizen.CreateThread(function()
    Citizen.Wait(90000) -- let DB/ESX settle after a fresh restart
    SnapshotFactionAccounts()
    while true do
        Citizen.Wait(Config_FactionSnapshot.IntervalMs)
        SnapshotFactionAccounts()
    end
end)

ESX.RegisterServerCallback('Unique_AdminMenu:GetFactionAccounts', function(source, cb)
    if not IsOnDutyAdminFor(source, 'btn_faction') then cb({}) return end
    MySQL.Async.fetchAll(
        "SELECT `account_name`, `money` FROM `addon_account_data` WHERE `account_name` LIKE 'society_%' ORDER BY `account_name` ASC",
        {}, function(rows) cb(rows or {}) end
    )
end)

ESX.RegisterServerCallback('Unique_AdminMenu:GetFactionHistory', function(source, cb, accountName)
    if not IsOnDutyAdminFor(source, 'btn_faction') then cb({}) return end
    MySQL.Async.fetchAll(
        "SELECT `balance`, `taken_at` FROM `admin_faction_snapshots` WHERE `account_name` = @name ORDER BY `taken_at` ASC LIMIT 200",
        { ['@name'] = accountName }, function(rows) cb(rows or {}) end
    )
end)

RegisterServerEvent('Unique_AdminMenu:AddFactionMoney')
AddEventHandler('Unique_AdminMenu:AddFactionMoney', function(accountName, amount, reason)
    local source = source
    local xPlayer = ESX.GetPlayerFromId(source)
    if not xPlayer or not xPlayer.permission_level or xPlayer.permission_level < FACTION_ADD_MIN_LEVEL
        or not IsOnDutyAdminFor(source, 'btn_faction') then
        DenyButtonAccess(source, 'btn_faction')
        return
    end

    accountName = tostring(accountName or ''):sub(1, 100)
    amount = tonumber(amount)
    if accountName == '' or not amount or amount == 0 then return end
    reason = (type(reason) == 'string' and reason ~= '') and reason or 'No reason specified'

    MySQL.Async.execute(
        "UPDATE `addon_account_data` SET `money` = `money` + @amount WHERE `account_name` = @name",
        { ['@amount'] = amount, ['@name'] = accountName },
        function(rowsAffected)
            if rowsAffected and rowsAffected > 0 then
                LogAdminAction(source, "faction-add-money", ("account: %s | amount: %s | reason: %s"):format(accountName, amount, reason))
                TriggerClientEvent('esx:showNotification', source, ("~g~%s added to %s"):format(amount, accountName))
            else
                TriggerClientEvent('esx:showNotification', source, "~r~Account not found.")
            end
        end
    )
end)
