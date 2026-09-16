RegisterNUICallback('scanWeapon', function(data, cb)
    if data and data.item then
        TriggerServerEvent('esx_inventory:scanWeapon', data.item)
    end
    if cb then cb('ok') end
end)
