if Config.Garages ~= 'cd_garage' then
    return
end

function OpenGarage(propertyId, propertyData)
    local myPed = PlayerPedId()
    local myVehicle = GetVehiclePedIsIn(myPed, false)
    local isInVehicle = myVehicle and myVehicle ~= 0 and GetPedInVehicleSeat(myVehicle, -1) == myPed
    if isInVehicle then
        TriggerEvent('cd_garage:StoreVehicle_Main', 1, false)
    else
        TriggerEvent('cd_garage:PropertyGarage', 'quick', nil)
    end
end