-- Pub by FleeX Team , https://discord.gg/87rGBxgCsa


local Garages = {
    [1] = { name = "Garage 1", x = -300.55, y = -905.57 },
    [2] = { name = "Garage 2", x = 122.96, y = -1068.51 },
    [3] = { name = "Garage 3", x = 373.0, y = 281.15 },
    [4] = { name = "Garage 4", x = 216.85, y = -810.03 },
    [5] = { name = "Garage 5", x = 1730.04, y = 3719.86 },
    [6] = { name = "Garage 6", x = 130.05, y = 6606.26 },
    [7] = { name = "Garage 7", x = -1620.85, y = 5123.33 },
    [8] = { name = "Garage 8", x = 1196.37, y = -1382.36 },
    [9] = { name = "Garage 9", x = 610.24, y = 95.89 },
    [10] = { name = "Garage 10", x = -2036.26, y = -471.74 },
    [11] = { name = "Garage 11", x = 540.35, y = -3044.67 },
}

local function ResolveGarage(g)
    local n = tonumber(g)
    if n and Garages[n] then return Garages[n] end
    if type(g) == 'string' then
        local target = string.lower(g)
        for _, data in pairs(Garages) do
            if string.lower(data.name) == target then return data end
        end
    end
    return nil
end

local function ResolveGarageName(g)
    local data = ResolveGarage(g)
    if data then return data.name end
    return g
end


local function UnwrapImageUrl(raw)
    if not raw or raw == '' then return nil end
    local ok, dec = pcall(json.decode, raw)
    if ok and type(dec) == 'table' and dec[1] then
        return dec[1]
    elseif ok and type(dec) == 'string' and dec ~= '' then
        return dec
    end
    return raw
end

local function Derive180pxUrl(url)
    if not url or url == '' then return nil end
    if url:sub(1, 2) == './' then return nil end
    local base, file = url:match('^(.*)/([^/]+)$')
    if not base or not file then return nil end
    if base:find('/180px$') then return nil end
    return base .. '/180px/180px-' .. file
end

local VehiclesCache = nil
local VehiclesCacheTime = 0
local VEHICLES_CACHE_TTL = 30

local function FormatVehicles(vehicles)
    local VehiclesFormatted = {}
    for k, v in pairs(vehicles) do
        local vehicleData = type(v.vehicle) == "string" and json.decode(v.vehicle) or v.vehicle
        local modelHash = vehicleData and vehicleData.model or 0
        local modelName = GetDisplayNameFromVehicleModel(modelHash)
        local VehicleData = Config.Vehicles[modelName] or {}

        local stateNum = (v.state == 'In') and 1 or 3

        local imageUrl = "./images/noimage.jpg"
        local imageUrl180 = nil
        local garageVeh = exports['sun-garage']:getSpecificVehicle(modelHash)
        if garageVeh then
            imageUrl180 = UnwrapImageUrl(garageVeh.imgurl180px)
            local primary = UnwrapImageUrl(garageVeh.imgurl)
            if primary then
                imageUrl = primary
            elseif imageUrl180 then
                imageUrl = imageUrl180
                imageUrl180 = nil
            end
        end
        if imageUrl == "./images/noimage.jpg" and v.image and v.image ~= '' then
            imageUrl = v.image
            imageUrl180 = v.image180
        end
        if imageUrl ~= "./images/noimage.jpg" and not imageUrl180 then
            imageUrl180 = Derive180pxUrl(imageUrl)
        end

        VehiclesFormatted[#VehiclesFormatted + 1] = {
            name = VehicleData['name'] or modelName or 'Unknown Vehicle',
            image = imageUrl,
            image180 = imageUrl180,
            brand = VehicleData['brand'] or '',
            model = VehicleData['model'] or modelName or '',
            type = VehicleData['type'] or '',
            category = VehicleData['category'] or '',
            plate = v.plate,
            garage = ResolveGarageName(v.garage) or 'Unknown',
            garage_raw = v.garage,
            state = stateNum,
            fuel = tostring(v.fuel),
            engine = tostring(v.engine),
            body = tostring(v.body),
            created_at = v.created_at,
        }
    end
    return VehiclesFormatted
end

RegisterNUICallback('get-garages', function(_, cb)
    local currentTime = GetGameTimer()

    if VehiclesCache and (currentTime - VehiclesCacheTime) < (VEHICLES_CACHE_TTL * 1000) then
        return cb(VehiclesCache)
    end
    
    ESX.TriggerServerCallback('sun-phone:server:GetVehicles', function(vehicles)
        if vehicles then
            VehiclesCache = FormatVehicles(vehicles)
            VehiclesCacheTime = currentTime
            cb(VehiclesCache)
        else
            cb({})
        end
    end)
end)

function InvalidateVehiclesCache()
    VehiclesCache = nil
    VehiclesCacheTime = 0
end

exports('InvalidateVehiclesCache', InvalidateVehiclesCache)

RegisterNUICallback('garage-direction', function(body, cb)
    local data = ResolveGarage(body.garage)
    if data then
        SetNewWaypoint(data.x, data.y)
        ESX.Alert('', 'GPS has been set to garage location!', 5000, 'success')
    else
        ESX.Alert('', 'Could not find garage location!', 5000, 'error')
    end

    cb("ok")
end)

RegisterNUICallback('garage-waypoint', function(body, cb)
    local data = ResolveGarage(body.garage)
    if data then
        SetNewWaypoint(data.x, data.y)
        ESX.Alert('', 'GPS has been set to the garage location!', 5000, 'success')
    else
        ESX.Alert('', 'Could not find garage location!', 5000, 'error')
    end
    cb("ok")
end)

RegisterNUICallback('vehicle-outside-notify', function(body, cb)
    ESX.Alert('', 'Your ' .. body.name .. ' is currently outside!', 5000, 'info')
    cb("ok")
end)
