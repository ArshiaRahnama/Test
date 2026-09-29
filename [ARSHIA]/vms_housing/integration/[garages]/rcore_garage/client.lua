if Config.Garages ~= 'rcore_garage' then
    return
end

function OpenGarage(propertyId, propertyData)
    local myPed = PlayerPedId()
    local myVehicle = GetVehiclePedIsIn(myPed, false)
    local isInVehicle = myVehicle and myVehicle ~= 0 and GetPedInVehicleSeat(myVehicle, -1) == myPed
    if isInVehicle then
        TriggerEvent("rcore_garage:StoreMyVehicle", "car")
    else
        TriggerEvent("rcore_garage:OpenGarageOnSpot", "car", "civ")
    end
end