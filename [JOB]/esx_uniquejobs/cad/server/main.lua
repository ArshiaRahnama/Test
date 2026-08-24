

ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

ESX.RegisterServerCallback('DuckMdt:GetAllWanteds', function(src, cb)
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
    local object = {}
    local text = "%"..Text.."%"

    MySQL.Async.fetchAll('SELECT `playerName`, `phone`, `WantedLevel`, `identifier` FROM users WHERE `playerName` LIKE @name', {['@name'] = text}, function(result)
        object.Citizens = result
    end)
    Wait(500)
    cb(object)
end)

ESX.RegisterServerCallback('DuckMdt:SearchCars', function(src, cb, Text)
    local object = {}
    local text = "%"..Text.."%"

    MySQL.Async.fetchAll('SELECT `plate`, `owner`, `stored`, `WantedLevel` FROM owned_vehicles WHERE `plate` LIKE @plate', {['@plate'] = text}, function(result)
        object.Cars = result
    end)
    Wait(500)
    cb(object)
end)

ESX.RegisterServerCallback('DuckMdt:CitizenProfile', function(src, cb, Steam)
    local object = {}

    MySQL.Async.fetchAll('SELECT `playerName`, `bank`, `sex`, `job`, `job_grade`, `jail`, `phone`, `WantedLevel`, `identifier`, `Profile_Pic` FROM users WHERE `identifier` =  @identifier', {['@identifier'] = Steam}, function(result)
        object.CitizenProfile = result
        MySQL.Async.fetchAll('SELECT `plate`, `owner`, `stored`, `WantedLevel` FROM owned_vehicles WHERE `owner` =  @owner', {['@owner'] = Steam}, function(result)
            object.CitizenCars = result
            MySQL.Async.fetchAll('SELECT `id`, `steam`, `reason`, `date`, `author` FROM duckcad_data WHERE `deleted` = 0 AND `steam` = @steam', {['@steam'] = Steam}, function(result)
                object.Data = result
            end)
        end)
    end)
    Wait(500)
    cb(object)
end)

ESX.RegisterServerCallback('DuckMdt:CarProfile', function(src, cb, Plate)
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
    local object = {}
    MySQL.Async.fetchAll('INSERT INTO duckcad_data (`steam`, `reason`, `author`) VALUES (@steam, @reason, @author)', {['@steam'] = steam, ['@reason'] = reason, ['@author'] = name}, function(result)
        MySQL.Async.fetchAll('SELECT `id`, `steam`, `reason`, `date`, `author` FROM duckcad_data WHERE `deleted` = 0 AND `steam` = @steam', {['@steam'] = steam}, function(result)
            object.result = result
        end)
    end)
    Wait(500)
    cb(object)
end)

ESX.RegisterServerCallback('DuckMdt:DeleteData', function(src, cb, id, steam)
    local object = {}
    MySQL.Async.fetchAll('DELETE FROM duckcad_data WHERE `id` = @id', {['@id'] = id}, function(result)
        MySQL.Async.fetchAll('SELECT `id`, `steam`, `reason`, `date`, `author` FROM duckcad_data WHERE `deleted` = 0 AND `steam` = @steam', {['@steam'] = steam}, function(result)
            object.result = result
        end)
    end)
    Wait(500)
    cb(object)
end)

RegisterNetEvent('DuckMdt:UpdateCharacterStatus')
AddEventHandler('DuckMdt:UpdateCharacterStatus', function(NewStatus, steam)
    MySQL.Async.fetchAll('UPDATE users SET `WantedLevel` = @NewStatus WHERE `identifier` = @steam', {['@NewStatus'] = NewStatus, ['@steam'] = steam}, function(result)
    end)
end)

RegisterNetEvent('DuckMdt:UpdateCarStatus')
AddEventHandler('DuckMdt:UpdateCarStatus', function(NewStatus, plate)
    MySQL.Async.fetchAll('UPDATE owned_vehicles SET `WantedLevel` = @NewStatus WHERE `plate` = @plate', {['@NewStatus'] = NewStatus, ['@plate'] = plate}, function(result)
    end)
end)

RegisterNetEvent('DuckMdt:UpdateProfilePicCharacter')
AddEventHandler('DuckMdt:UpdateProfilePicCharacter', function(Profile_Pic, steam)
    MySQL.Async.fetchAll('UPDATE users SET `Profile_Pic` = @Profile_Pic WHERE `identifier` = @steam', {['@Profile_Pic'] = Profile_Pic, ['@steam'] = steam}, function(result)
    end)
end)

RegisterNetEvent('DuckMdt:UpdateProfilePicCar')
AddEventHandler('DuckMdt:UpdateProfilePicCar', function(Profile_Pic, plate)
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
end)
