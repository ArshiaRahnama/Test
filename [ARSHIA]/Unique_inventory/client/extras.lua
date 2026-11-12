-- ============================================================================
-- client/extras.lua - exports the other resources call on the inventory
-- ============================================================================

-- weapon of the local player by serial (nil when not carried)
exports('getWeaponBySerial', function(serial)
    for _, w in ipairs(ESX.GetPlayerData().loadout or {}) do
        if w.serial == serial or (w.metadata and w.metadata.serial == serial) then return w end
    end
    return nil
end)

-- current weight of a vehicle's trunk, in kg (asks the server)
exports('getVehicleWeight', function(vehicle)
    if not vehicle or vehicle == 0 or not DoesEntityExist(vehicle) then return 0 end
    local plate = ESX.Math.Trim(GetVehicleNumberPlateText(vehicle))
    local p = promise.new()
    ESX.TriggerServerCallback('inventory-trunk:getWeight', function(w) p:resolve(tonumber(w) or 0) end, plate)
    return Citizen.Await(p)
end)

-- Unique_Garage's lockpick (server side) and other resources ask the inventory to close with this event
RegisterNetEvent('esx_inventoryhud:closeHud', function()
    if closeInventory then pcall(closeInventory) end
end)
