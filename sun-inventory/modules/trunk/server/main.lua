--[[
    sun-inventory — vehicle trunk / glovebox storage.

    SECURITY FIX (IDOR): the events below (`inventory-trunk:put`/`:get`)
    take a bare `plate` string straight from the client with no ownership
    check at all. As shipped, ANY player who typed/guessed a plate could
    dump items into — or pull items out of — that vehicle's trunk, whether
    it was theirs, parked in someone's garage, or across the map. The
    client (modules/trunk/client/main.lua) only calls `CarLock:haskey`
    before OPENING the UI — that's a client-side gate a modified client
    trivially skips, and even the stock client doesn't re-check it on the
    put/get events themselves.

    hasVehicleAccess() below mirrors the exact same access rule
    Unique_Garage's own CarLock:haskey uses (server/carlock_sv.lua):
    DB-registered ownership (or gang ownership), a carried `vehicle_keys`
    item for that plate, or job-plate-prefix access — so trunk access here
    can never be more permissive than the key system already governing the
    vehicle.
]]

local JOB_PLATE_ACCESS = {
    cid       = "CID", cia = "CIA", marshal = "MS", fbi = "FBI",
    judge     = "JD",  doa = "DOA", police  = "PD", sheriff = "SH",
    mt        = "MT",  taxi = "TX", mechanic = "MC", ambulance = "MD",
    weazel    = "WZ",
}

local function hasJobPlateAccess(xPlayer, plate)
    local jobName = xPlayer.job and xPlayer.job.name
    if not jobName then return false end
    local requiredPrefix = JOB_PLATE_ACCESS[jobName]
    if not requiredPrefix then return false end
    return string.upper(string.sub(plate, 1, #requiredPrefix)) == requiredPrefix
end

local function hasKeyItem(xPlayer, plate)
    for i = 1, #xPlayer.inventory, 1 do
        local item = xPlayer.inventory[i]
        if item.name == 'vehicle_keys' and item.count > 0 and item.info and item.info.plate == plate then
            return true
        end
    end
    return false
end

-- Synchronous DB check to keep the event handlers simple; trunk put/get are
-- not hot-path enough for this to matter, and it reuses the same query
-- carlock_sv.lua's CheckDbOwnership already runs.
local function hasDbOwnership(xPlayer, plate)
    local owner = MySQL.Sync.fetchScalar('SELECT owner FROM owned_vehicles WHERE plate = @plate', {
        ['@plate'] = plate
    })
    if owner == nil then return false end
    if owner == xPlayer.identifier then return true end
    local gangName = xPlayer.gang and xPlayer.gang.name
    if gangName and owner == gangName then return true end
    return false
end

local function hasVehicleAccess(xPlayer, plate)
    plate = ESX.Math and ESX.Math.Trim and ESX.Math.Trim(plate) or plate
    return hasJobPlateAccess(xPlayer, plate)
        or hasKeyItem(xPlayer, plate)
        or hasDbOwnership(xPlayer, plate)
end

local function trunkKey(plate, gloveBox)
    plate = ESX.Math and ESX.Math.Trim and ESX.Math.Trim(plate) or plate
    return 'trunk_' .. tostring(plate) .. (gloveBox and '_glove' or '')
end

ESX.RegisterServerCallback('inventory-trunk:getVehicleTrunk', function(source, cb, plate, gloveBox)
    local xPlayer = ESX.GetPlayerFromId(source)
    if not xPlayer or not hasVehicleAccess(xPlayer, plate) then return cb({ items = {}, weapons = {} }) end
    cb(Inventory.Get(trunkKey(plate, gloveBox)))
end)

RegisterServerEvent('inventory-trunk:updateSlot')
AddEventHandler('inventory-trunk:updateSlot', function(plate, data)
    local xPlayer = ESX.GetPlayerFromId(source)
    if not xPlayer or not hasVehicleAccess(xPlayer, plate) then return end
    -- Reordering only; nothing authoritative to change with a flat items[] model.
end)

-- Player -> trunk
RegisterServerEvent('inventory-trunk:put')
AddEventHandler('inventory-trunk:put', function(plate, data)
    local source = source
    local xPlayer = ESX.GetPlayerFromId(source)
    if not xPlayer or not hasVehicleAccess(xPlayer, plate) then return end

    Inventory.withLock(source, function()
        local count = tonumber(data.realCount or data.count) or 1
        if count <= 0 then return end
        local playerItem = xPlayer.getInventoryItem(data.name)
        if not playerItem or playerItem.count < count then return end

        local trunk = Inventory.Get(trunkKey(plate, data.gloveBox))
        xPlayer.removeInventoryItem(data.name, count)
        local found = false
        for _, v in ipairs(trunk.items) do
            if v.name == data.name then
                v.count = v.count + count
                found = true
                break
            end
        end
        if not found then
            trunk.items[#trunk.items + 1] = { name = data.name, count = count }
        end
        Inventory.Save(trunkKey(plate, data.gloveBox), trunk)
    end)
end)

-- Trunk -> player
RegisterServerEvent('inventory-trunk:get')
AddEventHandler('inventory-trunk:get', function(plate, data)
    local source = source
    local xPlayer = ESX.GetPlayerFromId(source)
    if not xPlayer or not hasVehicleAccess(xPlayer, plate) then return end

    Inventory.withLock(source, function()
        local count = tonumber(data.count) or 1
        if count <= 0 then return end

        local trunk = Inventory.Get(trunkKey(plate, data.gloveBox))
        for i, v in ipairs(trunk.items) do
            if v.name == data.name and v.count >= count then
                if not xPlayer.canCarryItem(data.name, count) then
                    xPlayer.showNotification('You cannot carry that much weight.')
                    return
                end
                v.count = v.count - count
                if v.count <= 0 then table.remove(trunk.items, i) end
                xPlayer.addInventoryItem(data.name, count)
                Inventory.Save(trunkKey(plate, data.gloveBox), trunk)
                return
            end
        end
    end)
end)
