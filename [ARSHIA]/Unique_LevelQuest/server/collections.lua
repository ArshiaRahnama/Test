-- ================================================================= --
-- Collections: vehicles + houses, both backed by real tables already
-- on this server (owned_vehicles, owned_properties + properties).
-- There is no pet system anywhere on this server, so there's no
-- 'GetPets' here — adding one would just be an empty/fake tab.
-- ================================================================= --

ESX.RegisterServerCallback("HUD_Menu:GetVehicles", function(source, cb)
    local xPlayer = ESX.GetPlayerFromId(source)
    if not xPlayer then return cb({}) end

    MySQL.Async.fetchAll('SELECT plate, vehicle, stored, fuel FROM owned_vehicles WHERE owner = @owner', {
        ['@owner'] = xPlayer.identifier
    }, function(result)
        local vehicles = {}
        for i = 1, #result do
            local ok, decoded = pcall(json.decode, result[i].vehicle)
            table.insert(vehicles, {
                plate  = result[i].plate,
                model  = ok and decoded and decoded.model or nil,
                -- Matches Unique_Garage's own semantics exactly:
                -- 0 = out in the world, 1 = stored in garage, 2 = impounded
                stored = result[i].stored,
                fuel   = result[i].fuel,
                -- Real mod data straight from ESX.Game.GetVehicleProperties'
                -- own field names — nothing invented here.
                color1          = ok and decoded and decoded.color1,
                color2          = ok and decoded and decoded.color2,
                modEngine       = ok and decoded and decoded.modEngine,
                modBrakes       = ok and decoded and decoded.modBrakes,
                modTransmission = ok and decoded and decoded.modTransmission,
                modSuspension   = ok and decoded and decoded.modSuspension,
                modArmor        = ok and decoded and decoded.modArmor,
                modTurbo        = ok and decoded and decoded.modTurbo,
                windowTint      = ok and decoded and decoded.windowTint,
            })
        end
        cb(vehicles)
    end)
end)

ESX.RegisterServerCallback("HUD_Menu:GetHouses", function(source, cb)
    local xPlayer = ESX.GetPlayerFromId(source)
    if not xPlayer then return cb({}) end

    MySQL.Async.fetchAll([[
        SELECT op.name, p.label, p.entering
        FROM owned_properties op
        LEFT JOIN properties p ON p.name = op.name
        WHERE op.owner = @owner
    ]], {
        ['@owner'] = xPlayer.identifier
    }, function(result)
        local houses = {}
        for i = 1, #result do
            local x, y = nil, nil
            if result[i].entering then
                local ok, coords = pcall(json.decode, result[i].entering)
                if ok and coords then
                    x, y = coords.x, coords.y
                end
            end
            table.insert(houses, {
                name = result[i].label or result[i].name,
                x    = x,
                y    = y,
            })
        end
        cb(houses)
    end)
end)
