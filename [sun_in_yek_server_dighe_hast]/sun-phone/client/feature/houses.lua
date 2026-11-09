-- Pub by FleeX Team , https://discord.gg/87rGBxgCsa


-- local HousesCache = nil
-- local HousesCacheTime = 0
-- local HOUSES_CACHE_TTL = 60

-- RegisterNUICallback('get-houses', function(_, cb)
--     local currentTime = GetGameTimer()
    
--     if HousesCache and (currentTime - HousesCacheTime) < (HOUSES_CACHE_TTL * 1000) then
--         return cb(HousesCache)
--     end
    
--     ESX.TriggerServerCallback('sun-phone:server:GetHouses', function(houses)
--         if houses then
--             for i, v in pairs(houses) do
--                 houses[i].image = "https://raw.githubusercontent.com/alfaben12/kmrp-assets/main/houses/".. v.id ..".jpg"
--             end
--             HousesCache = houses
--             HousesCacheTime = currentTime
--             cb(houses)
--         else
--             cb({})
--         end
--     end)
-- end)

-- RegisterNUICallback('house-direction', function(body, cb)
--     if body.coords and body.coords.x and body.coords.y then
--         SetNewWaypoint(body.coords.x, body.coords.y)
--         ESX.Alert('', 'GPS has been set to ' .. (body.name or 'house') .. '!', 5000, 'success')
--     else
--         ESX.Alert('', 'Invalid house coordinates!', 5000, 'error')
--         print('Invalid coords received:', json.encode(body))
--     end
--     cb("ok")
-- end)

-- function InvalidateHousesCache()
--     HousesCache = nil
--     HousesCacheTime = 0
-- end

-- exports('InvalidateHousesCache', InvalidateHousesCache)