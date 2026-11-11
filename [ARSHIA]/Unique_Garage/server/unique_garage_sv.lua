-- =====================================================================
--  Unique_Garage  |  Unique personal garage / pound / transfer
--  (server side of what the reference garage client expects; the original server
--   files were not available, so this is written for essentialmode ESX
--   + oxmysql and the owned_vehicles schema used by Unique_Garage)
-- =====================================================================

local function trim(s) return (tostring(s or ''):gsub('^%s*(.-)%s*$', '%1')) end
local function now() return os.time() end

local function vehTypeOf(row)
    -- owned_vehicles.type is 'car' / 'heli' / 'boat' / 'aircraft' on most ESX forks.
    local t = row.type
    if t == 'plane' then t = 'aircraft' end
    return t or 'car'
end

local function isAirType(t) return t == 'heli' or t == 'aircraft' end

local function typeMatches(zoneType, rowType)
    if zoneType == rowType then return true end
    if zoneType == 'heli' and isAirType(rowType) then return true end
    if zoneType == 'car' and (rowType == nil or rowType == 'car' or rowType == '') then return true end
    return false
end

-- ---------------------------------------------------------------- bans
ESX.RegisterServerCallback('garage:checkBan', function(source, cb)
    local xPlayer = ESX.GetPlayerFromId(source)
    if not xPlayer then cb(false) return end
    MySQL.Async.fetchAll('SELECT reason FROM unique_garage_bans WHERE identifier = ?', { xPlayer.identifier }, function(r)
        if r and r[1] then cb(r[1].reason ~= '' and r[1].reason or 'Ban') else cb(false) end
    end)
end)

-- the client builds thumbnails itself; this only exists so the client's loaded flag flips
RegisterNetEvent('garage:getVehiclesInfo', function()
    TriggerClientEvent('garage:getVehiclesInfo:cb', source, {})
end)

-- ---------------------------------------------------------------- listing
local function finishTransfers()
    MySQL.Async.execute([[UPDATE owned_vehicles
        SET location = transfer_to, transfer_to = NULL, transfer_until = NULL
        WHERE transfer_until IS NOT NULL AND transfer_until <= ?]], { now() })
end

CreateThread(function()
    while true do
        Wait(30000)
        finishTransfers()
    end
end)

ESX.RegisterServerCallback('garage:getOwnedVehicles', function(source, cb, zoneType, zoneIndex)
    local xPlayer = ESX.GetPlayerFromId(source)
    if not xPlayer then cb({}, {}) return end
    finishTransfers()
    local gang = xPlayer.gang and xPlayer.gang.name and string.lower(xPlayer.gang.name) or 'nogang'
    MySQL.Async.fetchAll([[SELECT * FROM owned_vehicles
        WHERE owner = @id AND stored <> 2]], {
        ['@id'] = xPlayer.identifier
    }, function(rows)
        local out, perms = {}, {}
        for _, r in ipairs(rows or {}) do
            if typeMatches(zoneType, vehTypeOf(r)) and (r.job == nil or r.job == '' or r.job == 'civ') then
                local ok, props = pcall(json.decode, r.vehicle or '{}')
                if ok and type(props) == 'table' and props.model then
                    local stored = r.stored
                    if type(stored) == 'boolean' then stored = stored and 1 or 0 end
                    -- old cars without a garage: the first garage that lists them becomes their home
                    if zoneIndex and r.location == nil and tonumber(stored) == 1 then
                        r.location = tonumber(zoneIndex)
                        MySQL.Async.execute('UPDATE owned_vehicles SET location = ? WHERE plate = ? AND location IS NULL', { tonumber(zoneIndex), r.plate })
                    end
                    local transferring = r.transfer_until and tonumber(r.transfer_until) and tonumber(r.transfer_until) > now()
                    out[#out + 1] = {
                        plate    = trim(r.plate),
                        owner    = r.owner,
                        vehicle  = props,
                        type     = vehTypeOf(r),
                        stored   = (tonumber(stored) == 1) and not transferring,
                        location = { location = tonumber(r.location) },
                        damage   = r.damages,
                        metaData = { fuel = tonumber(r.fuel) or 100.0, engine = tonumber(r.engine) or 1000.0, body = tonumber(r.body) or 1000.0 },
                        gang2    = (string.lower(tostring(r.owner)) == gang and gang ~= 'nogang') and gang or '',
                        transferring = transferring and true or false,
                    }
                    if string.lower(tostring(r.owner)) == gang and gang ~= 'nogang' then
                        perms[trim(r.plate)] = true
                    end
                end
            end
        end
        cb(out, perms)
    end)
end)

ESX.RegisterServerCallback('garage:getOwnedVehiclesJustSelf', function(source, cb, zoneType)
    local xPlayer = ESX.GetPlayerFromId(source)
    if not xPlayer then cb({}) return end
    MySQL.Async.fetchAll('SELECT plate, type FROM owned_vehicles WHERE owner = ?', { xPlayer.identifier }, function(rows)
        local out = {}
        for _, r in ipairs(rows or {}) do
            if not zoneType or typeMatches(zoneType, vehTypeOf(r)) then out[#out + 1] = { plate = trim(r.plate) } end
        end
        cb(out)
    end)
end)

-- ---------------------------------------------------------------- park / take out
local function ownsPlate(xPlayer, plate, cb)
    local gang = xPlayer.gang and xPlayer.gang.name and string.lower(xPlayer.gang.name) or 'nogang'
    MySQL.Async.fetchAll('SELECT plate, owner, job FROM owned_vehicles WHERE plate = @p AND (owner = @id OR LOWER(owner) = @gang)', {
        ['@p'] = plate, ['@id'] = xPlayer.identifier, ['@gang'] = gang
    }, function(r) cb(r and r[1] ~= nil, r and r[1]) end)
end

-- park: client already deleted the car; this stores state/location/props atomically
RegisterNetEvent('garage:parkVehicle', function(plate, zoneIndex, state)
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)
    if not xPlayer or type(state) ~= 'table' then return end
    plate = trim(plate)
    ownsPlate(xPlayer, plate, function(owns)
        if not owns then return end
        local sets = 'stored = 1, location = @loc, fuel = @fuel, engine = @engine, body = @body, transfer_to = NULL, transfer_until = NULL'
        local params = {
            ['@loc'] = tonumber(zoneIndex), ['@fuel'] = tonumber(state.fuel) or 100.0,
            ['@engine'] = tonumber(state.engine) or 1000.0, ['@body'] = tonumber(state.body) or 1000.0, ['@p'] = plate
        }
        if state.damages then sets = sets .. ', damages = @dmg'; params['@dmg'] = json.encode(state.damages) end
        if state.props and type(state.props) == 'table' and state.props.model then
            sets = sets .. ', vehicle = @props'; params['@props'] = json.encode(state.props)
        end
        MySQL.Async.execute('UPDATE owned_vehicles SET ' .. sets .. ' WHERE plate = @p', params)
        TriggerClientEvent('Unique_Garage:Notify', src, '~g~Mashin ba movafaghiat park shod')
    end)
end)

ESX.RegisterServerCallback('gangprop:carAvalible', function(source, cb, plate)
    -- a vehicle can be taken out only if it is really stored and no transfer is running
    plate = trim(plate)
    MySQL.Async.fetchAll('SELECT stored, transfer_until FROM owned_vehicles WHERE plate = ?', { plate }, function(r)
        if not r or not r[1] then cb(false) return end
        local stored = r[1].stored
        if type(stored) == 'boolean' then stored = stored and 1 or 0 end
        if tonumber(stored) ~= 1 then cb(false) return end
        if r[1].transfer_until and tonumber(r[1].transfer_until) and tonumber(r[1].transfer_until) > now() then cb(false) return end
        cb(true)
    end)
end)

RegisterNetEvent('garage:setVehicleState', function(plate, stored, damages)
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)
    if not xPlayer then return end
    plate = trim(plate)
    ownsPlate(xPlayer, plate, function(owns)
        if not owns then return end
        if damages and type(damages) == 'string' and damages ~= '' then
            MySQL.Async.execute('UPDATE owned_vehicles SET stored = ?, damages = ? WHERE plate = ?', { stored and 1 or 0, damages, plate })
        else
            MySQL.Async.execute('UPDATE owned_vehicles SET stored = ? WHERE plate = ?', { stored and 1 or 0, plate })
        end
    end)
end)

RegisterNetEvent('garage:setvehiclelocation', function(plate, index)
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)
    if not xPlayer then return end
    plate = trim(plate)
    ownsPlate(xPlayer, plate, function(owns)
        if owns then MySQL.Async.execute('UPDATE owned_vehicles SET location = ? WHERE plate = ?', { tonumber(index), plate }) end
    end)
end)

-- ---------------------------------------------------------------- money
ESX.RegisterServerCallback('garage:checkRepairCost', function(source, cb, cost)
    local xPlayer = ESX.GetPlayerFromId(source)
    cost = math.floor(tonumber(cost) or 0)
    if not xPlayer or cost < 0 then cb(false) return end
    cb(xPlayer.canAfford(cost))
end)

RegisterNetEvent('garage:pay', function(cost)
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)
    cost = math.floor(tonumber(cost) or 0)
    if not xPlayer or cost <= 0 or cost > 5000000 then return end
    if not xPlayer.canAfford(cost) then return end
    xPlayer.payAny(cost)
    TriggerEvent('DiscordBot:ToDiscord', 'amoney', 'AMoneyLog', '```css\n[ Player : ' .. GetPlayerName(src) .. '(' .. src .. ') ]\n[ Player Steam : ' .. xPlayer.identifier .. ' ]\n[ Paid For : Garage Repair ]\n[ Amount : ' .. tostring(cost) .. ' ]\n```', 'user', true, src, false)
end)

-- ---------------------------------------------------------------- transfer between garages
RegisterNetEvent('garage:changeGarage', function(plate, zoneIndex, minutes)
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)
    if not xPlayer then return end
    plate, zoneIndex, minutes = trim(plate), tonumber(zoneIndex), tonumber(minutes)
    local opt
    for _, o in ipairs(Customize.TransferOptions) do if o.minutes == minutes then opt = o end end
    if not opt or not zoneIndex then return end
    ownsPlate(xPlayer, plate, function(owns)
        if not owns then return end
        MySQL.Async.fetchAll('SELECT stored, location FROM owned_vehicles WHERE plate = ?', { plate }, function(r)
            local row = r and r[1]
            if not row then return end
            local stored = row.stored
            if type(stored) == 'boolean' then stored = stored and 1 or 0 end
            if tonumber(stored) ~= 1 then
                TriggerClientEvent('Unique_Garage:Notify', src, '~r~In mashin dar garage nist!') return
            end
            if tonumber(row.location) == zoneIndex then
                TriggerClientEvent('Unique_Garage:Notify', src, '~r~In mashin hamin alan inja ast!') return
            end
            if not xPlayer.canAfford(opt.price) then
                TriggerClientEvent('Unique_Garage:Notify', src, '~r~Poul kafi nadarid') return
            end
            xPlayer.payAny(opt.price)
            MySQL.Async.execute('UPDATE owned_vehicles SET transfer_to = ?, transfer_until = ? WHERE plate = ?',
                { zoneIndex, now() + opt.minutes * 60, plate })
            TriggerClientEvent('Unique_Garage:Notify', src, ('~g~Mashin ~y~%s~g~ ba movafaghiat dar ~y~%d~g~ daghighe be in garage montaghel mishavad'):format(plate, opt.minutes))
        end)
    end)
end)

-- ---------------------------------------------------------------- pound (out / impounded vehicles)
ESX.RegisterServerCallback('garage:getOutVehicles', function(source, cb, zoneType)
    local xPlayer = ESX.GetPlayerFromId(source)
    if not xPlayer then cb({}) return end
    local gang = xPlayer.gang and xPlayer.gang.name and string.lower(xPlayer.gang.name) or 'nogang'
    MySQL.Async.fetchAll('SELECT * FROM owned_vehicles WHERE (owner = @id OR LOWER(owner) = @gang) AND stored <> 1', {
        ['@id'] = xPlayer.identifier, ['@gang'] = gang }, function(rows)
        local out = {}
        for _, r in ipairs(rows or {}) do
            if typeMatches(zoneType, vehTypeOf(r)) and (r.job == nil or r.job == '' or r.job == 'civ') then
                local ok, props = pcall(json.decode, r.vehicle or '{}')
                if ok and type(props) == 'table' and props.model then
                    out[#out + 1] = { plate = trim(r.plate), model = props.model, fine = tonumber(r.fine) or 0 }
                end
            end
        end
        cb(out)
    end)
end)

RegisterNetEvent('garage:payFine', function(plate)
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)
    if not xPlayer then return end
    plate = trim(plate)
    ownsPlate(xPlayer, plate, function(owns)
        if not owns then return end
        MySQL.Async.fetchAll('SELECT fine FROM owned_vehicles WHERE plate = ?', { plate }, function(r)
            local fine = r and r[1] and tonumber(r[1].fine) or 0
            if fine <= 0 then return end
            if not xPlayer.canAfford(fine) then
                TriggerClientEvent('Unique_Garage:Notify', src, '~r~Poul kafi nadarid') return
            end
            xPlayer.payAny(fine)
            MySQL.Async.execute('UPDATE owned_vehicles SET fine = 0 WHERE plate = ?', { plate })
            TriggerClientEvent('Unique_Garage:Notify', src, '~g~Jarime pardakht shod, hala mitavanid mashin ra azad konid')
        end)
    end)
end)

local pendingFind = {}  -- plate -> { src, cost, zoneType, timeout }

RegisterNetEvent('garage:StartFindingVehicle', function(args)
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)
    if not xPlayer or type(args) ~= 'table' then return end
    local plate = trim(args.plate)
    local ztype = args.type
    local cost = ztype == 'car' and Customize.CarPoundPrice
        or (ztype == 'heli' or ztype == 'aircraft') and Customize.AircraftPoundPrice
        or ztype == 'boat' and Customize.BoatPoundPrice
    if not cost then return end
    ownsPlate(xPlayer, plate, function(owns)
        if not owns then return end
        MySQL.Async.fetchAll('SELECT stored, fine FROM owned_vehicles WHERE plate = ?', { plate }, function(r)
            local row = r and r[1]
            if not row then return end
            if (tonumber(row.fine) or 0) > 0 then
                TriggerClientEvent('Unique_Garage:Notify', src, '~r~Aval bayad jarime ra pardakht konid') return
            end
            if not xPlayer.canAfford(cost) then
                TriggerClientEvent('Unique_Garage:Notify', src, '~r~Poul kafi nadarid') return
            end
            xPlayer.payAny(cost)
            pendingFind[plate] = { src = src, ztype = ztype }
            -- every client looks for the entity; the one that has it deletes it and answers with the nearest garage
            TriggerClientEvent('garage:FindVehicle', -1, plate, ztype)
            SetTimeout(4000, function()
                local p = pendingFind[plate]
                if not p then return end
                pendingFind[plate] = nil
                -- nobody found it in the world (already despawned / parked in a meter): put it in the first garage
                MySQL.Async.execute('UPDATE owned_vehicles SET stored = 1, location = 1 WHERE plate = ?', { plate })
                TriggerEvent('Unique_Garage:ParkMeterClearPlate', plate)
                TriggerClientEvent('Unique_Garage:Notify', src, ('~g~Mashin ~y~%s~g~ be garage 1 montaghel shod'):format(plate))
            end)
        end)
    end)
end)

RegisterNetEvent('garage:ResponseFindVehicle', function(found, plate, location)
    plate = trim(plate)
    local p = pendingFind[plate]
    if not p or not found then return end
    pendingFind[plate] = nil
    MySQL.Async.execute('UPDATE owned_vehicles SET stored = 1, location = ? WHERE plate = ?', { tonumber(location) or 1, plate })
    TriggerClientEvent('Unique_Garage:Notify', p.src, ('~g~Mashin ~y~%s~g~ be garage montaghel shod'):format(plate))
end)

-- police impound hook: other resources can set a fine + stored = 2
RegisterNetEvent('garage:setFine', function(plate, fine)
    local xPlayer = ESX.GetPlayerFromId(source)
    if not xPlayer or (xPlayer.job and xPlayer.job.name ~= 'police' and (tonumber(xPlayer.permission_level) or 0) < 5) then return end
    MySQL.Async.execute('UPDATE owned_vehicles SET stored = 2, fine = ? WHERE plate = ?', { math.max(0, math.floor(tonumber(fine) or 0)), trim(plate) })
end)

-- number of players online with a given job (mechanics online -> no automatic repair offer when parking)
ESX.RegisterServerCallback('garage:getJobCount', function(source, cb, job)
    local count = 0
    for _, id in ipairs(ESX.GetPlayers()) do
        local x = ESX.GetPlayerFromId(id)
        if x and x.job and x.job.name == job then count = count + 1 end
    end
    cb(count)
end)
