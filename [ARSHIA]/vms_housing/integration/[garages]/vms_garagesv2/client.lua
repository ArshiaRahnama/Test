if Config.Garages ~= 'vms_garagesv2' then
    return
end

function OpenGarage(propertyId, propertyData)
    exports['vms_garagesv2']:enterHouseGarage()
end