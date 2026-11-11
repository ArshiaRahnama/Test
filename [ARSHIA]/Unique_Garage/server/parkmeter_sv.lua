-- =====================================================================
--  Unique_Garage  |  Unique ParkMeter (server)
--  One vehicle per meter, state persisted in `unique_parkmeter`, synced
--  to every client so everybody sees the semi-transparent parked car.
-- =====================================================================

local meters = {}   -- [key] = { plate, owner, props, damages, hasKey, job, t }

local function trim(s) return (tostring(s or ''):gsub('^%s*(.-)%s*$', '%1')) end

local PlatePrefixJob = {
    PD = 'police', MT = 'mt', SH = 'sheriff', FBI = 'fbi', MD = 'ambulance',
    MC = 'mechanic', TX = 'taxi', WZ = 'weazel',
}

local function HasVehicleKeyItem(xPlayer, plate)
    if not xPlayer or not xPlayer.inventory then return false end
    for i = 1, #xPlayer.inventory, 1 do
        local item = xPlayer.inventory[i]
        if item.name == 'vehicle_keys' and item.count > 0 and item.info and trim(item.info.plate) == plate then
            return true
        end
    end
    return false
end

-- may this player put this plate in a meter?  owner / gang / org fleet / key item / matching job plate
local function CanParkPlate(xPlayer, plate, cb)
    plate = trim(plate)
    if HasVehicleKeyItem(xPlayer, plate) then cb(true) return end
    local gang = xPlayer.gang and xPlayer.gang.name and string.lower(xPlayer.gang.name) or ''
    local jobn = xPlayer.job and xPlayer.job.name and string.lower(xPlayer.job.name) or ''
    for prefix, job in pairs(PlatePrefixJob) do
        if plate:sub(1, #prefix) == prefix and jobn == job then cb(true) return end
    end
    MySQL.Async.fetchAll([[SELECT plate FROM owned_vehicles WHERE plate = @p
        AND (owner = @id OR LOWER(owner) = @gang OR LOWER(owner) = @job)]], {
        ['@p'] = plate, ['@id'] = xPlayer.identifier, ['@gang'] = gang, ['@job'] = jobn
    }, function(r) cb(r and r[1] ~= nil) end)
end

local function Broadcast(key)
    local m = meters[key]
    TriggerClientEvent('ParkMeter:Sync', -1, key, m and { plate = m.plate, prop = m.props, damages = m.damages } or nil)
end

local function Persist(key)
    local m = meters[key]
    if m then
        MySQL.Async.execute([[REPLACE INTO unique_parkmeter (meter, plate, owner, props, damages, has_key, job, created_at)
            VALUES (?, ?, ?, ?, ?, ?, ?, ?)]], { key, m.plate, m.owner, json.encode(m.props), m.damages or '', m.hasKey and 1 or 0, m.job or '', m.t })
    else
        MySQL.Async.execute('DELETE FROM unique_parkmeter WHERE meter = ?', { key })
    end
end

CreateThread(function()
    Wait(1500)
    MySQL.Async.fetchAll('SELECT * FROM unique_parkmeter', {}, function(rows)
        for _, r in ipairs(rows or {}) do
            local ok, props = pcall(json.decode, r.props)
            if ok and props and Customize.ParkMeter[r.meter] then
                meters[r.meter] = { plate = trim(r.plate), owner = r.owner, props = props, damages = r.damages ~= '' and r.damages or nil,
                    hasKey = r.has_key == 1 or r.has_key == true, job = r.job ~= '' and r.job or nil, t = r.created_at }
            end
        end
    end)
end)

ESX.RegisterServerCallback('ParkMeter:GetAll', function(source, cb)
    local out = {}
    for k, m in pairs(meters) do out[k] = { plate = m.plate, prop = m.props, damages = m.damages } end
    cb(out)
end)

ESX.RegisterServerCallback('ParkMeter:CanPark', function(source, cb, plate)
    local xPlayer = ESX.GetPlayerFromId(source)
    if not xPlayer then cb(false) return end
    CanParkPlate(xPlayer, plate, cb)
end)

ESX.RegisterServerCallback('ParkMeter:CheckUsed', function(source, cb, key)
    local xPlayer = ESX.GetPlayerFromId(source)
    key = tonumber(key)
    local m = key and meters[key]
    if not xPlayer or not m then cb(false) return end
    cb({
        plate = m.plate, prop = m.props, damages = m.damages, doesHaveKey = m.hasKey, job = m.job,
    }, xPlayer.identifier == m.owner)
end)

-- park (shared by the event and the callback; the callback tells the client BEFORE it deletes the car)
local function Place(src, key, plate, prop, damages, doesHaveKey, job, cb)
    local xPlayer = ESX.GetPlayerFromId(src)
    key = tonumber(key)
    if not xPlayer or not key or not Customize.ParkMeter[key] then cb(false, 'Parkmeter na-motabar') return end
    plate = trim(plate)
    if meters[key] then cb(false, '~r~In parkmeter por ast') return end
    if type(prop) ~= 'table' or not prop.model then cb(false, 'Etelaate mashin na-motabar') return end
    for _, other in pairs(meters) do
        if other.plate == plate then cb(false, 'In mashin ghablan dar yek parkmeter park shode') return end
    end
    CanParkPlate(xPlayer, plate, function(ok)
        if not ok then cb(false, 'Shoma nemitavanid in mashin ra park konid!') return end
        if meters[key] then cb(false, 'In parkmeter por ast') return end
        meters[key] = {
            plate = plate, owner = xPlayer.identifier, props = prop,
            damages = type(damages) == 'string' and damages or (damages and json.encode(damages) or nil),
            hasKey = doesHaveKey and true or false, job = job, t = os.time(),
        }
        Persist(key)
        Broadcast(key)
        cb(true)
    end)
end

ESX.RegisterServerCallback('ParkMeter:Place', function(source, cb, key, plate, prop, damages, doesHaveKey, job)
    Place(source, key, plate, prop, damages, doesHaveKey, job, cb)
end)

RegisterNetEvent('ParkMeter:Set', function(key, plate, prop, damages, metaData, doesHaveKey, job)
    local src = source
    key = tonumber(key)
    plate = trim(plate)
    if prop == nil then
        -- legacy "release" path (kept so nothing breaks); real retrieval goes through ParkMeter:Take
        local m = key and meters[key]
        if m and m.plate == plate then meters[key] = nil Persist(key) Broadcast(key) end
        return
    end
    Place(src, key, plate, prop, damages, doesHaveKey, job, function(ok, reason)
        if not ok and reason then TriggerClientEvent('Unique_Garage:Notify', src, reason) end
    end)
end)

-- retrieve (atomic: first caller gets it, everybody after gets false)
ESX.RegisterServerCallback('ParkMeter:Take', function(source, cb, key)
    local xPlayer = ESX.GetPlayerFromId(source)
    key = tonumber(key)
    local m = key and meters[key]
    if not xPlayer or not m then cb(false) return end
    meters[key] = nil
    Persist(key)
    Broadcast(key)
    MySQL.Async.execute('UPDATE owned_vehicles SET stored = 0 WHERE plate = ?', { m.plate })
    cb({
        plate = m.plate, prop = m.props, damages = m.damages, job = m.job,
        -- a key is only handed back to the person who parked it (everybody else has to lockpick / hotwire)
        giveKey = m.hasKey and xPlayer.identifier == m.owner,
        doesHaveKey = m.hasKey,
    })
end)

-- pound / admin tools can free a plate that is sitting in a meter
AddEventHandler('Unique_Garage:ParkMeterClearPlate', function(plate)
    plate = trim(plate)
    for key, m in pairs(meters) do
        if m.plate == plate then meters[key] = nil Persist(key) Broadcast(key) end
    end
end)
