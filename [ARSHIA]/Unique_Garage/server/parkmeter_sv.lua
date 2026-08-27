local parkedVehicles = {}

ESX.RegisterServerCallback('temporaryParking:getPlayerBucket', function(source, cb)
    local xPlayer = ESX.GetPlayerFromId(source)
    local playerBucket = GetPlayerRoutingBucket(source)
    cb(playerBucket)
end)

ESX.RegisterServerCallback('temporaryParking:getVehicleDatas', function(source, cb, Plate)
    local xPlayer = ESX.GetPlayerFromId(source)
    local Gname   = xPlayer.gang.name
    local Jname   = xPlayer.job.name
    local playerBucket = GetPlayerRoutingBucket(source)
    local ItemKey = xPlayer.getInventoryItem("CarKey|"..Plate)
    local SubPlate = string.sub(Plate, 1, 2)
    local SubPlateFBI = string.sub(Plate, 1, 3)

    if Jname == "police" and SubPlate == "PD" then
        cb(true)
        return
    elseif Jname == "mt" and SubPlate == "MT" then
        cb(true)
        return
    elseif Jname == "sheriff" and SubPlate == "SH" then
        cb(true)
        return
    elseif Jname == "fbi" and SubPlateFBI == "FBI" then
        cb(true)
        return
    elseif Jname == "ambulance" and SubPlate == "MD" then
        cb(true)
        return
    elseif Jname == "mechanic" and SubPlate == "MC" then
        cb(true)
        return
    elseif Jname == "taxi" and SubPlate == "TX" then
        cb(true)
        return
    elseif Jname == "weazel" and SubPlate == "WZ" then
        cb(true)
        return
    end
    if playerBucket ~= 0 then cb(false) return end
    -- FIX: getInventoryItem returns nil when the player doesn't have this
    -- item (or the per-plate "CarKey|<plate>" item was never registered),
    -- and .count was read straight off it -- crashing this whole callback
    -- with no cb() call, which is exactly why the client hung/did nothing
    -- when you pressed E without a key item present. Every other
    -- getInventoryItem() call in this resource already nil-checks first;
    -- this one didn't.
    if ItemKey and ItemKey.count and ItemKey.count >= 1 then cb(true) return end

    MySQL.Async.fetchAll("SELECT * FROM owned_vehicles WHERE (owner = @player OR LOWER(`owner`) = @gang) AND plate = @plate", {
        ['@player'] = xPlayer.identifier,
        ['@gang'] = string.lower(Gname or ''),
        ['@plate'] =  tostring(Plate)
    }, function(Res)
        -- FIX: this is the "Parking / Error!" bug from your screenshot.
        -- It used to only check `Res[1].owner == Gname` -- comparing the
        -- DB's `owner` column against the player's GANG name. For a normal
        -- personal vehicle, `owner` is the player's identifier (a long
        -- license string), never their short gang tag, so this check could
        -- never pass and personal cars could never be parked here. Every
        -- other ownership check in this resource (see storeVehicle in
        -- server.lua) uses `owner = player_identifier OR LOWER(owner) =
        -- gang_name` -- this one was just missing the player-identifier half.
        if Res[1] then
            cb(true)
        else
            cb(false)
        end
    end)
end)

RegisterServerEvent('temporaryParking:storeVehicle')
AddEventHandler('temporaryParking:storeVehicle', function(vehicleProps, markerIndex)
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)
    local identifier = xPlayer.identifier
    local playerBucket = GetPlayerRoutingBucket(src)
    local plate = vehicleProps.plate
    local hasKey = false

    local keyItem = "CarKey|" .. ESX.Math.Trim(plate)
    if xPlayer.getInventoryItem(keyItem) and xPlayer.getInventoryItem(keyItem).count >= 1 then
        hasKey = true
    end

    if playerBucket ~= 0 then
        TriggerClientEvent('esx:showNotification', src, 'Shoma Dar World Asli Nistid!')
        return
    end

    if not parkedVehicles[markerIndex] then
        parkedVehicles[markerIndex] = {}
    end

    parkedVehicles[markerIndex][identifier] = {
        props = vehicleProps,
        hasKey = hasKey
    }
end)

RegisterServerEvent('temporaryParking:retrieveVehicle')
AddEventHandler('temporaryParking:retrieveVehicle', function(markerIndex)
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)
    local identifier = xPlayer.identifier
    local playerBucket = GetPlayerRoutingBucket(src)

    if playerBucket ~= 0 then
        TriggerClientEvent('esx:showNotification', src, 'Shoma Dar World Asli Nistid!')
        return
    end

    if parkedVehicles[markerIndex] and parkedVehicles[markerIndex][identifier] then
        local vehicleData = parkedVehicles[markerIndex][identifier]
        parkedVehicles[markerIndex][identifier] = nil

        TriggerClientEvent('temporaryParking:spawnVehicle', src, vehicleData.props, markerIndex, vehicleData.hasKey)
    else
        TriggerClientEvent('esx:showNotification', src, 'Shoma Mashin in Dar in Parking Nadarid')
    end
end)