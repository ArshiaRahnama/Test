if Config.Garages ~= 'RxGarages' then
    return
end

function OpenGarage(propertyId, propertyData)
    local myPed = PlayerPedId()
    local myVehicle = GetVehiclePedIsIn(myPed, false)
    local isInVehicle = myVehicle and myVehicle ~= 0 and GetPedInVehicleSeat(myVehicle, -1) == myPed
    if isInVehicle then
        exports['RxGarages']:ParkVehicle(propertyData.name, 'garage', 'car')
    else
        local garageCoords = propertyData.metadata.garage
        exports['RxGarages']:OpenGarage(propertyData.name, 'garage', 'car', vector3(garageCoords.x, garageCoords.y, garageCoords.z))
    end
end