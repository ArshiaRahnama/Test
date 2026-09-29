if Config.Garages ~= 'jg-advancedgarages' then
    return
end

function OpenGarage(propertyId, propertyData)
    local myPed = PlayerPedId()
    local myVehicle = GetVehiclePedIsIn(myPed, false)
    local isInVehicle = myVehicle and myVehicle ~= 0 and GetPedInVehicleSeat(myVehicle, -1) == myPed
    if isInVehicle then
        TriggerEvent("jg-advancedgarages:client:store-vehicle", 'property_' .. propertyId, 'car')
    else
        local garageCoords = propertyData.metadata.garage
        TriggerEvent("jg-advancedgarages:client:open-garage", 'property_' .. propertyId, 'car', vector4(garageCoords.x, garageCoords.y, garageCoords.z, garageCoords.w))
    end
end