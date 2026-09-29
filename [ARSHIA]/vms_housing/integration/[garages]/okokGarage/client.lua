if Config.Garages ~= 'okokGarage' then
    return
end

function OpenGarage(propertyId, propertyData)
    local myPed = PlayerPedId()
    local myVehicle = GetVehiclePedIsIn(myPed, false)
    local isInVehicle = myVehicle and myVehicle ~= 0 and GetPedInVehicleSeat(myVehicle, -1) == myPed
    if isInVehicle then
        TriggerEvent("okokGarage:StoreVehiclePrivate")
    else
        local myCoords = GetEntityCoords(myPed)
        TriggerEvent("okokGarage:OpenPrivateGarageMenu", myCoords, myCoords)
    end
end