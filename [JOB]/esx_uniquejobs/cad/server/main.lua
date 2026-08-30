

ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

-- SECURITY: every DuckMdt:* handler below used to have NO server-side job
-- check at all -- only the client-side CheckPerm_cad() gate (which is
-- trivially bypassable, same class of bug already fixed on
-- getStockItem/putStockItems/giveWeapon elsewhere in this codebase). Any
-- connected player, regardless of job, could TriggerServerEvent/trigger
-- these callbacks directly and: pull full citizen profiles (bank balance,
-- phone, criminal records) and vehicle info for anyone, set/clear ANY
-- citizen's or vehicle's WantedLevel, and inject or delete arbitrary MDT
-- incident log entries. Every handler now re-checks the same job list the
-- client uses.
local ALLOWED_CAD_JOBS = { police = true, sheriff = true, fbi = true, mt = true, cid = true, cia = true, marshal = true, judge = true, doa = true }

local function IsAllowedCadJob(source)
    local xPlayer = ESX.GetPlayerFromId(source)
    return xPlayer and ALLOWED_CAD_JOBS[xPlayer.job.name] == true
end

ESX.RegisterServerCallback('DuckMdt:GetAllWanteds', function(src, cb)
    if not IsAllowedCadJob(src) then cb({ cars = {}, peoples = {} }) return end

    local object = {}
    MySQL.Async.fetchAll('SELECT `plate` FROM owned_vehicles WHERE WantedLevel <> "standard"', {}, function(result)
        object.cars = result
        MySQL.Async.fetchAll('SELECT `playerName`, `phone`, `identifier` FROM users WHERE WantedLevel <> "standard"', {}, function(result2)
            object.peoples = result2
        end)
    end)
    Wait(500)
    cb(object)
end)

ESX.RegisterServerCallback('DuckMdt:SearchCitizen', function(src, cb, Text)
    if not IsAllowedCadJob(src) then cb({ Citizens = {} }) return end

    local object = {}
    local text = "%"..Text.."%"

    MySQL.Async.fetchAll('SELECT `playerName`, `phone`, `WantedLevel`, `identifier` FROM users WHERE `playerName` LIKE @name', {['@name'] = text}, function(result)
        object.Citizens = result
    end)
    Wait(500)
    cb(object)
end)

ESX.RegisterServerCallback('DuckMdt:SearchCars', function(src, cb, Text)
    if not IsAllowedCadJob(src) then cb({ Cars = {} }) return end

    local object = {}
    local text = "%"..Text.."%"

    MySQL.Async.fetchAll('SELECT `plate`, `owner`, `stored`, `WantedLevel` FROM owned_vehicles WHERE `plate` LIKE @plate', {['@plate'] = text}, function(result)
        object.Cars = result
    end)
    Wait(500)
    cb(object)
end)

ESX.RegisterServerCallback('DuckMdt:CitizenProfile', function(src, cb, Steam)
    if not IsAllowedCadJob(src) then cb({ CitizenProfile = {}, CitizenCars = {}, Data = {}, CriminalRecords = {} }) return end

    local object = {}

    MySQL.Async.fetchAll('SELECT `playerName`, `bank`, `sex`, `job`, `job_grade`, `jail`, `phone`, `WantedLevel`, `identifier`, `Profile_Pic` FROM users WHERE `identifier` =  @identifier', {['@identifier'] = Steam}, function(result)
        object.CitizenProfile = result
        MySQL.Async.fetchAll('SELECT `plate`, `owner`, `stored`, `WantedLevel` FROM owned_vehicles WHERE `owner` =  @owner', {['@owner'] = Steam}, function(result)
            object.CitizenCars = result
            MySQL.Async.fetchAll('SELECT `id`, `steam`, `reason`, `date`, `author` FROM duckcad_data WHERE `deleted` = 0 AND `steam` = @steam', {['@steam'] = Steam}, function(result)
                object.Data = result
                -- Criminal record (cad/server/crimescene.lua, this same resource) for this
                -- citizen, shown right under their profile instead of
                -- needing to jump to the separate Records tab.
                MySQL.Async.fetchAll('SELECT `suspect_name`, `charges`, `fine`, `jail_minutes`, `booked_by_name`, `created_at` FROM doj_criminal_records WHERE `suspect_identifier` = @identifier ORDER BY `created_at` DESC LIMIT 20', {['@identifier'] = Steam}, function(result)
                    object.CriminalRecords = result
                end)
            end)
        end)
    end)
    Wait(500)
    cb(object)
end)

ESX.RegisterServerCallback('DuckMdt:CarProfile', function(src, cb, Plate)
    if not IsAllowedCadJob(src) then cb({ CarInfo = {}, OwnerInfo = {} }) return end

    local object = {}

    MySQL.Async.fetchAll('SELECT `owner`, `WantedLevel`, `plate`, `Profile_Pic`  FROM owned_vehicles WHERE `plate` =  @plate', {['@plate'] = Plate}, function(result)
        object.CarInfo = result
        if result[1] then
            MySQL.Async.fetchAll('SELECT `playerName`, `phone` FROM users WHERE `identifier` =  @identifier', {['@identifier'] = result[1]['owner']}, function(result2)
                object.OwnerInfo = result2
            end)
        else
            object.OwnerInfo = {}
        end
    end)
    Wait(500)
    cb(object)
end)

ESX.RegisterServerCallback('DuckMdt:SaveNewData', function(src, cb, reason, name, steam)
    if not IsAllowedCadJob(src) then cb({ result = {} }) return end

    local object = {}
    MySQL.Async.fetchAll('INSERT INTO duckcad_data (`steam`, `reason`, `author`) VALUES (@steam, @reason, @author)', {['@steam'] = steam, ['@reason'] = reason, ['@author'] = name}, function(result)
        MySQL.Async.fetchAll('SELECT `id`, `steam`, `reason`, `date`, `author` FROM duckcad_data WHERE `deleted` = 0 AND `steam` = @steam', {['@steam'] = steam}, function(result)
            object.result = result
        end)
    end)
    Wait(500)
    TriggerEvent('DiscordBot:ToDiscord', 'adminmenu', 'CADLog', '```css\n[ Officer : '..GetPlayerName(src)..'(' .. src .. ') ]\n[ Action : ADDED Criminal Record ]\n[ Target Steam : '..tostring(steam)..' ]\n[ Reason : '..tostring(reason)..' ]\n```', 'user', true, src, false)
    cb(object)
end)

ESX.RegisterServerCallback('DuckMdt:DeleteData', function(src, cb, id, steam)
    if not IsAllowedCadJob(src) then cb({ result = {} }) return end

    local object = {}
    MySQL.Async.fetchAll('DELETE FROM duckcad_data WHERE `id` = @id', {['@id'] = id}, function(result)
        MySQL.Async.fetchAll('SELECT `id`, `steam`, `reason`, `date`, `author` FROM duckcad_data WHERE `deleted` = 0 AND `steam` = @steam', {['@steam'] = steam}, function(result)
            object.result = result
        end)
    end)
    Wait(500)
    TriggerEvent('DiscordBot:ToDiscord', 'adminmenu', 'CADLog', '```css\n[ Officer : '..GetPlayerName(src)..'(' .. src .. ') ]\n[ Action : DELETED Criminal Record ]\n[ Record ID : '..tostring(id)..' ]\n[ Target Steam : '..tostring(steam)..' ]\n```', 'user', true, src, false)
    cb(object)
end)

RegisterNetEvent('DuckMdt:UpdateCharacterStatus')
AddEventHandler('DuckMdt:UpdateCharacterStatus', function(NewStatus, steam)
    if not IsAllowedCadJob(source) then return end
    MySQL.Async.fetchAll('UPDATE users SET `WantedLevel` = @NewStatus WHERE `identifier` = @steam', {['@NewStatus'] = NewStatus, ['@steam'] = steam}, function(result)
    end)
    TriggerEvent('DiscordBot:ToDiscord', 'adminmenu', 'CADLog', '```css\n[ Officer : '..GetPlayerName(source)..'(' .. source .. ') ]\n[ Action : Set Wanted Level ]\n[ Target Steam : '..tostring(steam)..' ]\n[ New Status : '..tostring(NewStatus)..' ]\n```', 'user', true, source, false)
end)

RegisterNetEvent('DuckMdt:UpdateCarStatus')
AddEventHandler('DuckMdt:UpdateCarStatus', function(NewStatus, plate)
    if not IsAllowedCadJob(source) then return end
    MySQL.Async.fetchAll('UPDATE owned_vehicles SET `WantedLevel` = @NewStatus WHERE `plate` = @plate', {['@NewStatus'] = NewStatus, ['@plate'] = plate}, function(result)
    end)
end)

RegisterNetEvent('DuckMdt:UpdateProfilePicCharacter')
AddEventHandler('DuckMdt:UpdateProfilePicCharacter', function(Profile_Pic, steam)
    if not IsAllowedCadJob(source) then return end
    MySQL.Async.fetchAll('UPDATE users SET `Profile_Pic` = @Profile_Pic WHERE `identifier` = @steam', {['@Profile_Pic'] = Profile_Pic, ['@steam'] = steam}, function(result)
    end)
end)

RegisterNetEvent('DuckMdt:UpdateProfilePicCar')
AddEventHandler('DuckMdt:UpdateProfilePicCar', function(Profile_Pic, plate)
    if not IsAllowedCadJob(source) then return end
    MySQL.Async.fetchAll('UPDATE owned_vehicles SET `Profile_Pic` = @Profile_Pic WHERE `plate` = @plate', {['@Profile_Pic'] = Profile_Pic, ['@plate'] = plate}, function(result)
    end)
end)

RegisterNetEvent('DuckMdt:PrintLog')
AddEventHandler('DuckMdt:PrintLog', function()
    local source = source
    print(DuckMdt.AnnouneText..source)
end)

RegisterNetEvent('DuckMdt:Announce')
AddEventHandler('DuckMdt:Announce', function()
    local source = source
    local xPlayers = ESX.GetPlayers()
    for i=1, #xPlayers, 1 do
        local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
        if xPlayer.permission_level >= DuckMdt.AnnouncePerm then
            print('Announced')
            TriggerClientEvent('chat:addMessage', -1, {
                color = { 255, 0, 0},
                multiline = true,
                args = {"[Unique_Cad]", "^1 " ..DuckMdt.AnnouneText..source}
            })
        end
    end
    TriggerEvent('DiscordBot:ToDiscord', 'adminmenu', 'CADLog', '```css\n[ Officer : '..GetPlayerName(source)..'(' .. source .. ') ]\n[ Action : Server-wide CAD Announcement ]\n[ Text : '..tostring(DuckMdt.AnnouneText)..' ]\n```', 'user', true, source, false)
end)
