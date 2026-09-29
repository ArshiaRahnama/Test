if Config.Garages ~= 'vms_garagesv2' then
    return
end

---@param isNew - If the property is newly created, you will get true, if the property is edited, it will be false
function RegisterGarage(propertyId, propertyData, isNew)
    exports['vms_garagesv2']:registerHousingGarage(
        'vms_housing.garage.' .. propertyId,                                                                                                        --[[ File name - Garage ID will always be as "HouseGarage:vms_housing.garage-ID" ]]
        propertyData.name,                                                                                                                          --[[ Garage Label ]]
        propertyId,                                                                                                                                 --[[ Housing ID ]]
        vector4(propertyData.metadata.garage.x, propertyData.metadata.garage.y, propertyData.metadata.garage.z, propertyData.metadata.garage.w),    --[[ Coordinates ]]
        1                                                                                                                                           --[[ Garage Interior ID (Config.ParkingCreator.HouseGarageInteriors) ]]
    )
end