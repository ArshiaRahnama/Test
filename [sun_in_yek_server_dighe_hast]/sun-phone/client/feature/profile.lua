-- Pub by FleeX Team , https://discord.gg/87rGBxgCsa

RegisterNUICallback('get-profile', function(_, cb)
    ESX.TriggerServerCallback('sun-phone:server:GetProfile', function(profile)
        cb(profile)
    end)
end)

RegisterNUICallback('update-profile', function(body, cb)
    ESX.TriggerServerCallback('sun-phone:server:UpdateProfile', function(isOk)
        if isOk then
            ESX.TriggerServerCallback('sun-phone:server:GetProfile', function(profile)
                Profile = profile
                cb(profile)
            end)
        end
    end, body)
end)