--[[
    server/licensemenu-sv.lua

    Backend for client/license-cl.lua. Shares the SAME `user_licenses` table
    that server/license-sv.lua and server/givelisence-sv.lua already use, just
    with a few extra nullable columns (expire, description, granted_by,
    created_at) added by install_license_menu.sql. That migration is additive
    and doesn't touch the type/owner columns, so /givelicense, /removelicense
    and the esx_license:* events keep working exactly as before.

    Permission model: matches your existing givelicense-sv.lua style — plain
    xPlayer.job.name checks, using the addAccess/viewAccess/removeAccess
    tables already defined per license type in license_config.lua. No external
    permission resource required (there is no 'sun-society' on this server;
    esx_society is unrelated and is not used here).
]]

ESX = nil
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

-------------------------------------------------------
-- helpers
-------------------------------------------------------

-- e.g. 93650 -> "1d 2h", 300 -> "5m". Used instead of the nonexistent
-- ESX.displayTime (that function isn't defined anywhere in this framework -
-- it was in the file you originally uploaded and got carried over without
-- being checked; this replaces it).
local function FormatDuration(seconds)
    if seconds < 60 then
        return ('%ds'):format(seconds)
    end

    local days = math.floor(seconds / 86400)
    local hours = math.floor((seconds % 86400) / 3600)
    local minutes = math.floor((seconds % 3600) / 60)

    if days > 0 then
        return ('%dd %dh'):format(days, hours)
    elseif hours > 0 then
        return ('%dh %dm'):format(hours, minutes)
    else
        return ('%dm'):format(minutes)
    end
end

local function BuildLicenseTable(rows)
    local licenses = {}
    local now = os.time()

    for i = 1, #rows do
        local row = rows[i]
        local expire = row.expire or 0
        local expired = expire > 0 and now > expire

        licenses[row.type] = {
            expired         = expired and true or false,
            remainingString = (expire > 0 and not expired) and FormatDuration(expire - now) or 'Permanent',
            from            = row.granted_by,
            description     = row.description,
            startString     = row.created_at and row.created_at > 0 and os.date('%Y-%m-%d %H:%M', row.created_at) or 'N/A',
            expireString    = expire > 0 and os.date('%Y-%m-%d %H:%M', expire) or 'Permanent',
        }
    end

    return licenses
end

local function GetPlayerLicenses(target, cb)
    local identifier = GetPlayerIdentifier(target, 0)

    MySQL.Async.fetchAll('SELECT * FROM user_licenses WHERE owner = @owner', {
        ['@owner'] = identifier
    }, function(rows)
        cb(BuildLicenseTable(rows))
    end)
end

local function PushLicenseUpdate(target)
    GetPlayerLicenses(target, function(licenses)
        TriggerClientEvent('license:update', target, licenses)
    end)
end

-- true if this player's job has add/view/remove access to at least one license type
-- (used to gate staff looking up someone else's licenses)
local function IsLicenseStaff(xPlayer)
    for _, config in pairs(licenseConfig.licenses) do
        if config.addAccess[xPlayer.job.name] or config.viewAccess[xPlayer.job.name] or config.removeAccess[xPlayer.job.name]
        or config.addAccess.all or config.viewAccess.all or config.removeAccess.all then
            return true
        end
    end
    return false
end

-------------------------------------------------------
-- callback: own licenses (no target) or a target's licenses (staff only).
-- When a target is given, also sends back GetPlayerName(target) - that has
-- to happen server-side; on the client GetPlayerName expects a local player
-- index, not a server id (checked how the rest of this pack calls it -
-- combat_vdm_client.lua, vehiclecontrol-cl.lua - always with PlayerId()/a
-- local index, never a server id).
-------------------------------------------------------
ESX.RegisterServerCallback('license:getData', function(source, cb, target)
    if not target or target == source then
        GetPlayerLicenses(source, cb)
        return
    end

    local xPlayer = ESX.GetPlayerFromId(source)
    if not xPlayer or not IsLicenseStaff(xPlayer) then
        cb({})
        return
    end

    local targetName = GetPlayerName(target)
    if not targetName then
        cb({})
        return
    end

    GetPlayerLicenses(target, function(licenses)
        cb(licenses, targetName)
    end)
end)

-------------------------------------------------------
-- add a license to `target`
-- time: -1 for permanent, otherwise a number of days
-------------------------------------------------------
RegisterServerEvent('license:add')
AddEventHandler('license:add', function(target, licenseType, time, description)
    local src = source
    local config = licenseConfig.licenses[licenseType]
    if not config then return end

    local xPlayer = ESX.GetPlayerFromId(src)
    if not xPlayer then return end

    if not (config.addAccess.all or config.addAccess[xPlayer.job.name]) then
        print(('[license] %s (%s) tried to add "%s" without permission'):format(GetPlayerName(src), src, licenseType))
        return
    end

    if not GetPlayerName(target) then return end

    local identifier = GetPlayerIdentifier(target, 0)
    local expire = 0
    if time and time ~= -1 then
        expire = os.time() + (tonumber(time) * 86400)
    end

    -- overwrite any existing license of this type for this player
    MySQL.Async.execute('DELETE FROM user_licenses WHERE type = @type AND owner = @owner', {
        ['@type']  = licenseType,
        ['@owner'] = identifier
    }, function()
        MySQL.Async.execute('INSERT INTO user_licenses (owner, type, expire, granted_by, description, created_at) VALUES (@owner, @type, @expire, @granted_by, @description, @created_at)', {
            ['@owner']       = identifier,
            ['@type']        = licenseType,
            ['@expire']      = expire,
            ['@granted_by']  = GetPlayerName(src),
            ['@description'] = description,
            ['@created_at']  = os.time()
        }, function(rowsChanged)
            if rowsChanged and rowsChanged > 0 then
                PushLicenseUpdate(target)
                xPlayer.showNotification(('~g~License added: ~y~%s'):format(config.label))
                local xTarget = ESX.GetPlayerFromId(target)
                if xTarget then
                    xTarget.showNotification(('~g~You received the license: ~y~%s'):format(config.label))
                end
            end
        end)
    end)
end)

-------------------------------------------------------
-- remove a license from `target`
-------------------------------------------------------
RegisterServerEvent('license:remove')
AddEventHandler('license:remove', function(target, licenseType)
    local src = source
    local config = licenseConfig.licenses[licenseType]
    if not config then return end

    local xPlayer = ESX.GetPlayerFromId(src)
    if not xPlayer then return end

    if not (config.removeAccess.all or config.removeAccess[xPlayer.job.name]) then
        print(('[license] %s (%s) tried to remove "%s" without permission'):format(GetPlayerName(src), src, licenseType))
        return
    end

    local identifier = GetPlayerIdentifier(target, 0)

    MySQL.Async.execute('DELETE FROM user_licenses WHERE type = @type AND owner = @owner', {
        ['@type']  = licenseType,
        ['@owner'] = identifier
    }, function(rowsChanged)
        if rowsChanged and rowsChanged > 0 then
            PushLicenseUpdate(target)
            xPlayer.showNotification(('~g~License removed: ~y~%s'):format(config.label))
        end
    end)
end)
