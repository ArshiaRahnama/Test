local parkedVehicles = {}

-- FIX: shared with getVehicleDatas/storeVehicle below - same check as
-- carlock_sv.lua's FindKeySlot, so "do you have the key" means the same
-- thing everywhere in the codebase instead of two different item systems
-- disagreeing with each other.
local function HasVehicleKeyItem(xPlayer, plate)
    if not xPlayer or not xPlayer.inventory then return false end
    for i = 1, #xPlayer.inventory, 1 do
        local item = xPlayer.inventory[i]
        if item.name == 'vehicle_keys' and item.count > 0 and item.info and item.info.plate == plate then
            return true
        end
    end
    return false
end

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
    -- FIX (the actual "Parking / Error!" bug from your screenshot): this
    -- used to check for an old, dead per-plate item named
    -- "CarKey|<plate>" (a naming scheme nothing in the codebase creates
    -- anymore - everything now grants a single 'vehicle_keys' item per
    -- slot with info.plate set, see CarLock:ToggleKey/FindKeySlot in
    -- carlock_sv.lua). That old check could never pass anymore, so this
    -- always fell through to the DB ownership query - which also fails
    -- for any vehicle that was never inserted into owned_vehicles (e.g.
    -- an admin-spawned /car test vehicle). Now checks the real,
    -- current key item the same way carlock_sv.lua's FindKeySlot does.
    if HasVehicleKeyItem(xPlayer, Plate) then cb(true) return end

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

    -- FIX: same old "CarKey|<plate>" item this whole file used to check -
    -- replaced with the real, current key system (see HasVehicleKeyItem
    -- above). This value only gets forwarded to the client on retrieve;
    -- the actual re-grant on retrieve is handled server-side by
    -- CarLock:ToggleKey (parkmeter_cl.lua), so this is just kept
    -- consistent rather than left checking an item that can never exist.
    if HasVehicleKeyItem(xPlayer, ESX.Math.Trim(plate)) then
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