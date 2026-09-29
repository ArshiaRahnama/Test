if Config.Garages ~= 'loaf_garage' then
    return
end

function OpenGarage(propertyId, propertyData)
    local myPed = PlayerPedId()
    local myVehicle = GetVehiclePedIsIn(myPed, false)
    local isInVehicle = myVehicle and myVehicle ~= 0 and GetPedInVehicleSeat(myVehicle, -1) == myPed
    if isInVehicle then
        exports['loaf_garage']:StoreVehicle('property_' .. propertyId, myVehicle)
        DeleteVehicle(myVehicle)
    else
        local myCoords = GetEntityCoords(myPed)
        local myHeading = GetEntityHeading(myPed)
        exports['loaf_garage']:BrowseVehicles('property_' .. propertyId, vector4(myCoords.x, myCoords.y, myCoords.z, myHeading))
    end
end