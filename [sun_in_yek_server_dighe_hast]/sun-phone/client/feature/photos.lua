-- Pub by FleeX Team , https://discord.gg/87rGBxgCsa

RegisterNUICallback('get-photos', function(_, cb)
    -- Use cached data if available
    if CachedData.photos then
        return cb(CachedData.photos)
    end

    ESX.TriggerServerCallback('sun-phone:server:GetPhotos', function(result)
        if result and type(result) == 'table' then
            CachedData.photos = result
            cb(result)
        else
            cb({})
        end
    end)
end)

RegisterNUICallback('save-photos', function(body, cb)
    body.location = (GetStreetName and GetStreetName()) or ''
    ESX.TriggerServerCallback('sun-phone:server:SavePhotos', function(photos)
        if photos and type(photos) == 'table' then
            CachedData.photos = photos
            ESX.Alert('', "Successful save to gallery!", 5000, 'success')
        end
        cb(photos or {})
    end, body)
end)

RegisterNUICallback('delete-photos', function(body, cb)
    ESX.TriggerServerCallback('sun-phone:server:DeletePhotos', function(photos)
        if photos and type(photos) == 'table' then
            CachedData.photos = photos
            ESX.Alert('', "Successful delete from gallery!", 5000, 'success')
        end
        cb(photos or {})
    end, body)
end)