-- =====================================================================
--  Unique_Garage  |  Sunset-style personal garage / pound (client)
--  zones [E] -> park / open menu, preview vehicle + orbit camera,
--  garage transfer, pound peds (ox_target), repair-on-park, auto park
-- =====================================================================

local currentZone                    -- { k = 'spawnCar', type = 'car', index = n }
local doesBan = false
local camera, previewVehicle
local inMenu = false
local busy = false
local currentVehicleType

local function notify(kind, msg)
    lib.notify({ title = 'Garage', description = msg, type = kind or 'inform', position = 'center-right' })
end

local function isPlayerBusy()
    local ped = PlayerPedId()
    if IsPedRagdoll(ped) or IsEntityAttached(ped) then
        notify('error', 'Dar in halat nemitavanid az parking estefade konid')
        return true
    end
    return false
end

local function clearPlayerState()
    local ped = PlayerPedId()
    ClearPedTasksImmediately(ped)
    DetachEntity(ped, true, false)
end

local function vehicleTypeOf(vehicle, ped)
    ped = ped or PlayerPedId()
    if IsThisModelABoat(GetEntityModel(vehicle)) or IsThisModelASubmersible(GetEntityModel(vehicle)) then return 'boat' end
    if IsThisModelAPlane(GetEntityModel(vehicle)) then return 'aircraft' end
    if IsThisModelAHeli(GetEntityModel(vehicle)) then return 'heli' end
    return 'car'
end

local function labelOf(model)
    local disp = GetDisplayNameFromVehicleModel(model)
    local label = GetLabelText(disp)
    if label == 'NULL' or label == '' then label = disp end
    return label, disp
end

-- ------------------------------------------------------------ damages
function getVehicleDamages(vehicle)
    local damages = { damaged_windows = {}, burst_tires = {}, broken_doors = {},
        body_health = GetVehicleBodyHealth(vehicle), engine_health = GetVehicleEngineHealth(vehicle) }
    for i = 0, GetVehicleNumberOfWheels(vehicle) do
        if IsVehicleTyreBurst(vehicle, i, false) then table.insert(damages.burst_tires, i) end
    end
    for i = 0, 7 do
        if not IsVehicleWindowIntact(vehicle, i) then table.insert(damages.damaged_windows, i) end
    end
    for i = 0, GetNumberOfVehicleDoors(vehicle) do
        if IsVehicleDoorDamaged(vehicle, i) then table.insert(damages.broken_doors, i) end
    end
    return damages
end
exports('getVehicleDamages', getVehicleDamages)

-- accepts the json string stored in the db or an already decoded table
function setVehicleDamages(car, damages)
    if type(damages) == 'string' then
        local ok, d = pcall(json.decode, damages)
        damages = ok and d or nil
    end
    if type(damages) ~= 'table' then return end
    for _, i in pairs(damages.burst_tires or {}) do SetVehicleTyreBurst(car, i, true, 1000.0) end
    for _, i in pairs(damages.damaged_windows or {}) do SmashVehicleWindow(car, i) end
    for _, i in pairs(damages.broken_doors or {}) do SetVehicleDoorBroken(car, i, true) end
    -- FiveM quirk: whole numbers must be sent as floats (+ 0.0) or they get re-interpreted
    if damages.body_health then SetVehicleBodyHealth(car, (tonumber(damages.body_health) or 1000.0) + 0.0) end
    if damages.engine_health then SetVehicleEngineHealth(car, (tonumber(damages.engine_health) or 1000.0) + 0.0) end
end

-- ------------------------------------------------------------ repair offer on park (Sunset formula)
function payFixVehicle(vehicle)
    local engineHealth = GetVehicleEngineHealth(vehicle)
    if engineHealth >= 990 then return true end
    local p = promise.new()
    ESX.TriggerServerCallback('garage:getJobCount', function(count)
        if count and count > 0 then
            -- mechanics are online -> they get the job, no auto repair
            p:resolve(true)
            return
        end
        local cost = math.floor((1000 - engineHealth) / 1000 * Customize.CarPoundPrice * Customize.DamageMult)
        local alert = lib.alertDialog({
            header = 'Repair',
            content = ('Mayel be repair mashin ba mablagh $%s hastid?'):format(cost),
            centered = true, cancel = true
        })
        if alert == 'confirm' then
            ESX.TriggerServerCallback('garage:checkRepairCost', function(ok)
                if ok then
                    TriggerServerEvent('garage:pay', cost)
                    SetVehicleFixed(vehicle)
                    SetVehicleDeformationFixed(vehicle)
                    SetVehicleEngineHealth(vehicle, 1000.0)
                    SetVehicleBodyHealth(vehicle, 1000.0)
                    Wait(500)
                else
                    notify('error', 'Poul kafi nadarid')
                end
                p:resolve(true)
            end, cost)
        else
            p:resolve(true)
        end
    end, 'mechanic')
    return Citizen.Await(p)
end

-- ------------------------------------------------------------ park
function parkVehicle(vehicle, zoneIndex)
    local plate = GetPlate(vehicle)
    local state = {
        fuel    = Customize.GetVehFuel(vehicle),
        engine  = math.ceil(GetVehicleEngineHealth(vehicle)),
        body    = math.ceil(GetVehicleBodyHealth(vehicle)),
        damages = getVehicleDamages(vehicle),
        props   = ESX.Game.GetVehicleProperties(vehicle),
    }
    TriggerServerEvent('garage:parkVehicle', plate, zoneIndex, state)
    for i = -1, 5 do
        local seat = GetPedInVehicleSeat(vehicle, i)
        if seat ~= 0 then TaskLeaveVehicle(seat, vehicle, 0) end
    end
    SetVehicleDoorsLocked(vehicle, 2)
    Wait(2000)
    HZDeleteVehicle(vehicle)
end

local function tryPark(vehicle, askDialog)
    if busy then return end
    busy = true
    local zone = currentZone
    local ok, err = pcall(function()
        if not zone then return end
        local vtype = vehicleTypeOf(vehicle)
        if not (zone.type == vtype or (zone.type == 'heli' and vtype == 'aircraft')) then
            notify('error', 'In vasile naghlie ghabeliat park dar inja ra nadarad!')
            return
        end
        if GetVehicleNumberOfPassengers(vehicle) > 0 then
            notify('error', 'Aval hame ra piade konid')
            return
        end
        if askDialog then
            local alert = lib.alertDialog({ header = 'Park', content = 'Aya mayel be park mashin hastid?', centered = true, cancel = true })
            if alert ~= 'confirm' then return end
        end
        local plate = GetPlate(vehicle)
        local p = promise.new()
        ESX.TriggerServerCallback('IsVehOwned', function(owned) p:resolve(owned) end, plate, '')
        if not Citizen.Await(p) then
            notify('error', 'In mashin motaalegh be shoma nist!')
            return
        end
        if askDialog then payFixVehicle(vehicle) end
        parkVehicle(vehicle, zone.index)
    end)
    if not ok then print('^1[Unique_Garage] park error: ' .. tostring(err) .. '^0') end
    busy = false
end

-- ------------------------------------------------------------ spawn points / camera
local function getAvailableSpawnPoint(zoneKey, index)
    local list = Customize.Zones[zoneKey].coords[index].spawnPoints
    for _, v in pairs(list) do
        if ESX.Game.IsSpawnPointClear(v.coords.xyz, 2.0) then return v end
    end
end

local function createCamera()
    camera = CreateCam('DEFAULT_SCRIPTED_CAMERA', false)
    SetCamActive(camera, true)
    RenderScriptCams(true, true, 1000, true, false)
end

local function stopCamera()
    if camera then
        ClearFocus()
        RenderScriptCams(false, false, 0, true, false)
        DestroyCam(camera, false)
        camera = nil
    end
end

local function closeMenu()
    SendNUIMessage({ action = 'Close' })
end

-- ------------------------------------------------------------ open menu
function openSpawnMenu(kind, zone)
    if isPlayerBusy() then return end
    if doesBan then
        notify('error', ('Shoma be dalile %s dastresi estefade az parking ra nadarid!'):format(tostring(doesBan)))
        return
    end
    MenuContext = { kind = 'self', zone = { k = zone.k, type = zone.type, index = zone.index } }
    ESX.TriggerServerCallback('garage:getOwnedVehicles', function(owned)
        if #owned == 0 then
            notify('error', 'Shoma mashini nadarid!')
            return
        end
        local list, inGarage, uniq, uniqCount = {}, 0, {}, 0
        for _, v in ipairs(owned) do
            local label, disp = labelOf(v.vehicle.model)
            local loc = v.location and v.location.location
            v.VehModel = ('%s - %s'):format(label, v.plate)
            v.VehText  = label .. '(' .. (loc and tostring(loc) or '') .. ')' .. (v.transferring and ' Transfer...' or '')
            v.image    = Customize.VehicleImageUrl:format(disp:lower())
            v.image2   = v.image
            v.state    = 0
            if v.stored and (not loc or loc == zone.index) then
                v.state = 1
                inGarage = inGarage + 1
            end
            if not uniq[v.vehicle.model] then uniq[v.vehicle.model] = true uniqCount = uniqCount + 1 end
            list[#list + 1] = v
        end
        SetNuiFocus(true, true)
        inMenu = true
        SendNUIMessage({ action = 'setOpen', data = {
            setVeh = list, setName = Customize.Zones[zone.k].label2 or 'Garage', inGarage = inGarage, Price = 0,
            allVehicleCount = #GetAllVehicleModels(), ownedVehicleCount = #list, ownedVehicleCountUniq = uniqCount } })
    end, zone.type, zone.index)
end
exports('openSpawnMenu', openSpawnMenu)

-- ------------------------------------------------------------ NUI callbacks (shared by self / gang / job-fleet menus)
local function cleanupMenu()
    SetNuiFocus(false, false)
    inMenu = false
    if previewVehicle and DoesEntityExist(previewVehicle) then DeleteEntity(previewVehicle) end
    previewVehicle = nil
    if currentVeh and DoesEntityExist(currentVeh) then DeleteEntity(currentVeh) end
    currentVeh = nil
    stopCamera()
    DestroyAllCams(true)
    RenderScriptCams(false, true, 1700, true, false)
    ClearFocus()
    LastCamera = nil
end

RegisterNUICallback('Close', function(_, cb)
    cb('ok')
    cleanupMenu()
end)

RegisterNUICallback('BackPage', function(_, cb)
    cb('ok')
    if previewVehicle and DoesEntityExist(previewVehicle) then DeleteEntity(previewVehicle) end
    if currentVeh and DoesEntityExist(currentVeh) then DeleteEntity(currentVeh) end
    previewVehicle, currentVeh = nil, nil
end)

RegisterNUICallback('rotateright', function(_, cb)
    cb('ok')
    local v = previewVehicle or currentVeh
    if v and DoesEntityExist(v) then SetEntityHeading(v, GetEntityHeading(v) - 2) end
end)
RegisterNUICallback('rotateleft', function(_, cb)
    cb('ok')
    local v = previewVehicle or currentVeh
    if v and DoesEntityExist(v) then SetEntityHeading(v, GetEntityHeading(v) + 2) end
end)

local function applyPreviewStats(vehicle, row)
    local meta = row.metaData or {}
    ESX.Game.SetVehicleProperties(vehicle, row.vehicle)
    Customize.SetVehFuel(vehicle, (tonumber(meta.fuel or row.fuel) or 100.0) + 0.0)
    SetVehicleEngineHealth(vehicle, (tonumber(meta.engine or row.engine) or 1000.0) + 0.0)
    SetVehicleBodyHealth(vehicle, (tonumber(meta.body or row.body) or 1000.0) + 0.0)
    if row.damage then setVehicleDamages(vehicle, row.damage) end
end

RegisterNUICallback('VehicleInfo', function(data, cb)
    local row = data.data
    if type(row.vehicle) == 'string' then row.vehicle = json.decode(row.vehicle) end
    if previewVehicle and DoesEntityExist(previewVehicle) then DeleteEntity(previewVehicle) previewVehicle = nil end
    if currentVeh and DoesEntityExist(currentVeh) then DeleteEntity(currentVeh) currentVeh = nil end

    if MenuContext and MenuContext.kind == 'self' then
        local spawnPoint = getAvailableSpawnPoint(MenuContext.zone.k, MenuContext.zone.index)
        if not spawnPoint then cb({}) return end
        ESX.Game.SpawnLocalVehicle(row.vehicle.model, spawnPoint.coords.xyz, spawnPoint.coords.w, function(vehicle)
            previewVehicle = vehicle
            currentVeh = vehicle -- vehiclehud_cl.lua draws fuel/engine/body above it
            SetVehicleEngineOn(vehicle, true, true, false)
            FreezeEntityPosition(vehicle, true)
            applyPreviewStats(vehicle, row)
            if not camera then createCamera() end
            SetCamActive(camera, true)
            local camCoords   = GetOffsetFromEntityInWorldCoords(vehicle, 2.0, 5.0, 2.0)
            local pointCoords = GetOffsetFromEntityInWorldCoords(vehicle, 2.0, 0.0, 0.0)
            PointCamAtCoord(camera, pointCoords.x, pointCoords.y, pointCoords.z)
            SetCamCoord(camera, camCoords.x, camCoords.y, camCoords.z)
            cb({
                Fuel = math.floor((tonumber((row.metaData or {}).fuel) or 100) + 0.5),
                Speed = GetVehicleEstimatedMaxSpeed(vehicle) * 3.6,
                Traction = GetVehicleMaxTraction(vehicle),
                Acceleration = GetVehicleAcceleration(vehicle),
            })
        end)
    else
        -- gang / organisation fleet: preview at the fleet marker with the fixed camera
        local model = row.vehicle.model
        RequestModel(model)
        while not HasModelLoaded(model) do Wait(7) end
        local v = LastCamera.vehSpawn
        currentVeh = CreateVehicle(model, v.x, v.y, v.z, v.w, false, true)
        previewVehicle = currentVeh
        SetVehicleEngineOn(currentVeh, true, true, false)
        applyPreviewStats(currentVeh, row)
        cb({
            Fuel = math.floor(Customize.GetVehFuel(currentVeh) + 0.5),
            Speed = GetVehicleEstimatedMaxSpeed(currentVeh) * 3.6,
            Traction = GetVehicleMaxTraction(currentVeh),
            Acceleration = GetVehicleAcceleration(currentVeh),
        })
    end
end)

-- shared "vehicle came out" finishing touches
local function finishSpawn(vehicle, row, spawnCoords)
    SetNetworkIdAlwaysExistsForPlayer(NetworkGetNetworkIdFromEntity(vehicle), PlayerPedId(), true)
    ESX.Game.SetVehicleProperties(vehicle, row.vehicle)
    SetVehicleNumberPlateText(vehicle, row.plate)
    SetEntityHeading(vehicle, spawnCoords.w)
    local meta = row.metaData or {}
    Customize.SetVehFuel(vehicle, (tonumber(meta.fuel or row.fuel) or 100.0) + 0.0)
    SetVehicleEngineHealth(vehicle, (tonumber(meta.engine or row.engine) or 1000.0) + 0.0)
    SetVehicleBodyHealth(vehicle, (tonumber(meta.body or row.body) or 1000.0) + 0.0)
    if row.damage then setVehicleDamages(vehicle, row.damage) end
    SetVehRadioStation(vehicle, 'OFF')
    SetEntityAsMissionEntity(vehicle, true, true)
    clearPlayerState()
    TaskWarpPedIntoVehicle(PlayerPedId(), vehicle, -1)
    local t = GetGameTimer() + 3000
    while GetVehiclePedIsIn(PlayerPedId()) ~= vehicle and GetGameTimer() < t do Wait(0) end
    SetVehicleEngineOn(vehicle, true, true)
    AttachOwnCarBlip(vehicle)
    Wait(100)
    TriggerServerEvent('CarLock:ToggleKey', true, row.plate)
end

RegisterNUICallback('SpawnVehicle', function(data, cb)
    cb('ok')
    local row = data and data.Table
    if not row then return end
    if type(row.vehicle) == 'string' then
        local ok, d = pcall(json.decode, row.vehicle)
        row.vehicle = ok and d or nil
    end
    if not row.vehicle or not row.vehicle.model then
        SafeNotify('~r~Khataye Spawn: Etelaate Mashin Kharab Ast.')
        return
    end
    closeMenu()
    if previewVehicle and DoesEntityExist(previewVehicle) then DeleteEntity(previewVehicle) previewVehicle = nil end
    if currentVeh and DoesEntityExist(currentVeh) then DeleteEntity(currentVeh) currentVeh = nil end
    stopCamera()
    SetNuiFocus(false, false)
    DestroyAllCams(true)
    RenderScriptCams(false, true, 1000, true, false)

    local ctx = MenuContext or { kind = 'self' }
    if ctx.kind == 'self' then
        if row.state ~= 1 then
            notify('error', 'In mashin dar in garage nist')
            return
        end
        local spawnPoint = getAvailableSpawnPoint(ctx.zone.k, ctx.zone.index)
        if not spawnPoint then
            notify('error', 'Mahale spawn por ast!')
            return
        end
        Wait(math.random(100, 1500))
        ESX.TriggerServerCallback('gangprop:carAvalible', function(available)
            if not available then return notify('error', 'In mashin dar dastres nist') end
            if isPlayerBusy() then return end
            TriggerServerEvent('garage:setVehicleState', row.plate, false)
            HZSpawnVehicle(row.vehicle.model, function(vehicle)
                if #(GetEntityCoords(PlayerPedId()) - GetEntityCoords(vehicle)) > 120.0 then
                    DeleteEntity(vehicle)
                    TriggerServerEvent('garage:setVehicleState', row.plate, true)
                    notify('warning', 'Fasele shoma az mashin ziad ast, lotfan nazdik bashid')
                    return
                end
                finishSpawn(vehicle, row, spawnPoint.coords)
            end, spawnPoint.coords, true)
        end, row.plate)
    else
        -- gang / organisation fleet (spawn at the marker, rank access re-checked)
        local function spawnNow()
            HZSpawnVehicle(row.vehicle.model, function(vehicle)
                finishSpawn(vehicle, row, LastSpawnPos)
                TriggerServerEvent('SetVehState0', 0, row.plate)
            end, LastSpawnPos, true)
        end
        if LastGangJob then
            local key = (string.gsub(GetDisplayNameFromVehicleModel(row.vehicle.model), '%s+', '')):lower()
            ESX.TriggerServerCallback('FMGangs:GetRankAccess', function(access)
                local va = access and access.vehicleAccess
                if va and va[key] == false then
                    SafeNotify('~r~Your rank does not have access to this vehicle')
                    return
                end
                spawnNow()
            end, LastGangJob)
        else
            spawnNow()
        end
    end
end)

-- transfer to another garage (Sunset: pay more = faster)
local transferPlate
RegisterNUICallback('backVehicle', function(data, cb)
    cb('ok')
    -- the Sunset UI posts the vehicle row itself (not wrapped in .data)
    local row = data and (data.plate and data or data.data)
    if not row or not row.plate or (MenuContext and MenuContext.kind ~= 'self') then return end
    closeMenu()
    cleanupMenu()
    local plate = row.plate
    local alert = lib.alertDialog({ header = 'Enteghal Mashin', content = 'Aya mayel be enteghal mashin in be in garage hastid?', centered = true, cancel = true })
    if alert ~= 'confirm' then return end
    transferPlate = plate
    local options = {}
    for _, o in ipairs(Customize.TransferOptions) do
        options[#options + 1] = { label = o.label, args = { value = o.minutes, plate = plate } }
    end
    lib.setMenuOptions('garageBack', options)
    lib.showMenu('garageBack')
end)

lib.registerMenu({
    id = 'garageBack', title = 'Enteghal Mashin', position = 'top-right', options = {}
}, function(selected, scrollIndex, args)
    if currentZone then
        TriggerServerEvent('garage:changeGarage', args.plate, currentZone.index, args.value)
    end
end)

-- ------------------------------------------------------------ zones / blips / pounds
CreateThread(function()
    while not ESX or not ESX.GetPlayerData or not ESX.GetPlayerData().job do Wait(500) end
    Wait(3000)
    ESX.TriggerServerCallback('garage:checkBan', function(state) doesBan = state end)
    TriggerServerEvent('garage:getVehiclesInfo')

    for k, v in pairs(Customize.Zones) do
        for k2, v2 in pairs(v.coords) do
            if v2.blip then
                local blip = AddBlipForCoord(v2.blip.x, v2.blip.y, v2.blip.z)
                SetBlipSprite(blip, v.type == 'car' and 357 or v.type == 'heli' and 64 or 410)
                SetBlipDisplay(blip, 4)
                SetBlipScale(blip, 0.5)
                SetBlipColour(blip, 81)
                SetBlipAsShortRange(blip, true)
                BeginTextCommandSetBlipName('STRING')
                AddTextComponentString(('Garage %s'):format(v.label2))
                EndTextCommandSetBlipName(blip)
            end
            lib.zones.sphere({
                coords = v2.garagePoint.xyz,
                radius = v2.garagePoint.w,
                onEnter = function()
                    currentZone = { k = k, type = v.type, index = k2 }
                    lib.showTextUI(v.label, { position = 'left-center', icon = v.icon,
                        style = { borderRadius = 5, backgroundColor = '#FFA500', color = 'black' } })
                end,
                onExit = function()
                    if currentZone and currentZone.k == k and currentZone.index == k2 then currentZone = nil end
                    lib.hideTextUI()
                    if inMenu then
                        SendNUIMessage({ action = 'Close' })
                        cleanupMenu()
                    end
                end,
                inside = function()
                    if IsControlJustReleased(0, 38) and currentZone and not inMenu and not busy and not lib.getOpenMenu() then
                        local ped = PlayerPedId()
                        local veh = GetVehiclePedIsIn(ped, false)
                        if veh ~= 0 and GetPedInVehicleSeat(veh, -1) == ped then
                            CreateThread(function() tryPark(veh, true) end)
                        elseif veh == 0 then
                            CreateThread(function() openSpawnMenu('self', currentZone) end)
                        end
                    end
                end,
            })
        end
    end

    for _, pos in pairs(Customize.Pounds) do
        local model = Customize.PoundPed[math.random(1, #Customize.PoundPed)]
        RequestModel(model)
        while not HasModelLoaded(model) do Wait(10) end
        local ped = CreatePed(4, model, pos.x, pos.y, pos.z - 1.0, pos.w, false, true)
        SetEntityAsMissionEntity(ped, true, true)
        SetBlockingOfNonTemporaryEvents(ped, true)
        FreezeEntityPosition(ped, true)
        SetEntityInvincible(ped, true)
        exports.ox_target:addLocalEntity({ ped }, {
            { label = 'ترخیص وسیله نقیله', icon = 'fa-solid fa-car', distance = 3.0, onSelect = function() openImpoundMenu() end }
        })
    end
end)

-- ------------------------------------------------------------ pound
lib.registerMenu({ id = 'garageImpound2', title = 'Impound', position = 'top-right', options = {} }, function(selected, scrollIndex, args)
    if args.fine > 0 then
        local alert = lib.alertDialog({
            header = 'Pardakht jarime',
            content = ('Shoma aval bayad jarime mashin ra jahat khorouj az impound pardakht konid \n Mablagh jarime $%s'):format(ESX.Math.GroupDigits(args.fine)),
            centered = true, cancel = true })
        if alert == 'confirm' then TriggerServerEvent('garage:payFine', args.plate) end
    else
        local cost = args.type == 'car' and Customize.CarPoundPrice
            or (args.type == 'heli' or args.type == 'aircraft') and Customize.AircraftPoundPrice
            or args.type == 'boat' and Customize.BoatPoundPrice
        ESX.TriggerServerCallback('garage:checkRepairCost', function(ok)
            if ok then
                args.cost = cost
                TriggerServerEvent('garage:StartFindingVehicle', args)
            else
                notify('error', 'Poul kafi nadarid')
            end
        end, cost)
    end
end)

lib.registerMenu({
    id = 'garageImpound', title = 'Impound', position = 'top-right',
    options = {
        { label = ('Mashin($%s)'):format(Customize.CarPoundPrice), args = 'car' },
        { label = ('Helicopter($%s)'):format(Customize.AircraftPoundPrice), args = 'heli' },
        { label = ('Havapeyma($%s)'):format(Customize.AircraftPoundPrice), args = 'aircraft' },
        { label = ('Ghayegh($%s)'):format(Customize.BoatPoundPrice), args = 'boat' },
    }
}, function(selected, scrollIndex, args)
    ESX.TriggerServerCallback('garage:getOutVehicles', function(list)
        if #list == 0 then return notify('error', 'Vasile naghliee dar impound nadarid!') end
        local options = {}
        for _, v in ipairs(list) do
            local label = labelOf(v.model)
            options[#options + 1] = {
                label = ('%s - %s(Fine $%s)'):format(label, v.plate, ESX.Math.GroupDigits(v.fine)),
                args = { type = args, plate = v.plate, fine = v.fine } }
        end
        lib.setMenuOptions('garageImpound2', options)
        lib.showMenu('garageImpound2')
    end, args)
end)

function openImpoundMenu()
    lib.showMenu('garageImpound')
end

-- server asks every client to look for a plate; whoever has it deletes it and answers with the nearest garage
RegisterNetEvent('garage:FindVehicle', function(plate, ztype)
    for _, v in ipairs(GetGamePool('CVehicle')) do
        if Trim(GetVehicleNumberPlateText(v)) == plate then
            local entity = v
            NetworkRequestControlOfEntity(entity)
            local t = 2000
            while t > 0 and not NetworkHasControlOfEntity(entity) do Wait(100) t = t - 100 end
            if IsVehicleSeatFree(entity, -1) then
                local coords = GetEntityCoords(entity)
                local best, bestDist = 1, 1e9
                local zk = (ztype == 'car' and 'spawnCar') or (ztype == 'boat' and 'spawnboat') or 'spawnHeli'
                for idx, z in pairs(Customize.Zones[zk].coords) do
                    local d = #(coords - z.garagePoint.xyz)
                    if d < bestDist then best, bestDist = idx, d end
                end
                SetEntityAsMissionEntity(entity, true, true)
                DeleteEntity(entity)
                TriggerServerEvent('garage:ResponseFindVehicle', true, plate, best)
            else
                TriggerServerEvent('garage:ResponseFindVehicle', false, plate)
            end
            return
        end
    end
end)

-- parking-meter preview of a vehicle that got released by the pound
RegisterNetEvent('garage:deletePreviewVehicle', function(plate)
    if DeleteParkMeterPreview then DeleteParkMeterPreview(plate) end
end)

-- ------------------------------------------------------------ auto park (leave the car in a garage zone, engine off -> 20 s)
lib.onCache('vehicle', function(value, oldValue)
    if value then
        currentVehicleType = vehicleTypeOf(value)
        return
    end
    local vehicle = oldValue
    if not vehicle or vehicle == 0 or not DoesEntityExist(vehicle) then return end
    if GetPedInVehicleSeat(vehicle, -1) ~= 0 then return end -- somebody else drives it now
    if not (currentZone and (currentZone.type == currentVehicleType or (currentZone.type == 'heli' and currentVehicleType == 'aircraft'))) then
        if OnLeaveVehicleNearMeter then OnLeaveVehicleNearMeter(vehicle) end
        return
    end
    CreateThread(function()
        local timer = 20
        local active = true
        CreateThread(function()
            while active do
                Wait(1000)
                timer = timer - 1
                if timer <= 0 then
                    active = false
                    if DoesEntityExist(vehicle) and GetPedInVehicleSeat(vehicle, -1) == 0 then tryPark(vehicle, false) end
                end
            end
        end)
        while DoesEntityExist(vehicle) and not GetIsVehicleEngineRunning(vehicle) and active do
            ESX.Game.Utils.DrawText3D(GetEntityCoords(vehicle) + vec(0, 0, 1), tostring(timer), 3)
            Wait(0)
        end
        active = false
    end)
end)
