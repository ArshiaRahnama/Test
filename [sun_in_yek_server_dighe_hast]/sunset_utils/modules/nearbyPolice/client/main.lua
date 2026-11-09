-- Pub by FleeX Team , https://discord.gg/87rGBxgCsa

Citizen.CreateThread(function()
    waitForLoad()
    ESX.RegisterClientCallback('sunset_utils:getNearbyPolice',function(cb,coords,radius)
        local players = ESX.Game.GetPlayersInArea(vec(coords.x, coords.y, coords.z), radius) 
        local count = 0
        local list = {}
        for k , v in pairs(players) do
            local job = ESX.GetPlayerState(GetPlayerServerId(v),'job')
            if (job == 'police' or job == 'sheriff' or job == 'mt' or job == 'fbi' or job == 'justice' or job == 'detective') and IsEntityVisible(GetPlayerPed(v)) then
                count = count + 1
                list[GetPlayerServerId(v)] = job
            end
        end
        cb(count, list)
    end)
end)