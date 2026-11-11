-- =====================================================================
--  Unique_Garage  |  Unique ParkMeter (client)
--  * [E] on the blue ring: park (driver, slower than 10 km/h) / retrieve (on foot)
--  * leave a car near a meter -> walk >5 m away -> auto parks after 15 s
--  * parked car stays in the world as a frozen, semi-transparent vehicle
--    that every nearby player sees (server broadcasts `ParkMeter:Sync`)
--  * one vehicle per meter, anyone can take it, only the parker gets the key back
-- =====================================================================

local occupied  = {}     -- [key] = { plate, prop, damages }
local previews  = {}     -- [key] = entity
local creating  = {}     -- [key] = true while the local vehicle is being created
local trunkZone = {}     -- [key] = ox_target zone id
local lastUse   = {}

local COLOR_FREE = { r = 0,   g = 255, b = 0   }
local COLOR_USED = { r = 255, g = 0,   b = 0   }

local function notify(kind, msg)
    lib.notify({ title = 'Park Meter', description = msg, type = kind or 'inform', position = 'center-right' })
end

local function cooldown(name, ms)
    local t = GetGameTimer()
    if lastUse[name] and t - lastUse[name] < ms then return false end
    lastUse[name] = t
    return true
end

local blocked = {}
for _, m in ipairs(Customize.ParkMeterBlockedModels or {}) do blocked[m] = true end

-- ------------------------------------------------------------ blips
CreateThread(function()
    while not ESX do Wait(50) end
    for k, v in ipairs(Customize.ParkMeter) do
        local blip = AddBlipForCoord(v.coords.x, v.coords.y, v.coords.z)
        SetBlipSprite(blip, 267)
        SetBlipDisplay(blip, 5)
        SetBlipScale(blip, 0.3)
        SetBlipColour(blip, 74)
        SetBlipAsShortRange(blip, true)
        BeginTextCommandSetBlipName('STRING')
        AddTextComponentString('Park meter')
        EndTextCommandSetBlipName(blip)
        if k % 20 == 0 then Wait(10) end
    end
end)

-- ------------------------------------------------------------ preview vehicles (local, frozen, 80% alpha)
local function GetVehicleGroundCorners(vehicle)
    local minDim, maxDim = GetModelDimensions(GetEntityModel(vehicle))
    local offsets = {
        vector3(minDim.x, minDim.y, 0.0), vector3(maxDim.x, minDim.y, 0.0),
        vector3(maxDim.x, maxDim.y, 0.0), vector3(minDim.x, maxDim.y, 0.0),
    }
    local corners = {}
    for _, o in ipairs(offsets) do
        local w = GetOffsetFromEntityInWorldCoords(vehicle, o.x, o.y, o.z)
        local found, gz = GetGroundZFor_3dCoord(w.x, w.y, w.z, false)
        corners[#corners + 1] = found and vector3(w.x, w.y, gz) or w
    end
    return corners
end

local function removePreview(key)
    local v = previews[key]
    if v then
        if DoesEntityExist(v) then
            SetEntityAsMissionEntity(v, true, true)
            DeleteVehicle(v)           -- NOT ESX.Game.DeleteVehicle: that would also drop the owner's key
        end
        previews[key] = nil
    end
    if trunkZone[key] then
        exports.ox_target:removeZone(trunkZone[key])
        trunkZone[key] = nil
    end
end

local function createPreview(key)
    local data = occupied[key]
    local meter = Customize.ParkMeter[key]
    if not data or not meter or previews[key] or creating[key] then return end
    creating[key] = true
    local plate = data.plate
    ESX.Game.SpawnLocalVehicle(data.prop.model, meter.coords.xyz, meter.coords.w, function(vehicle)
        creating[key] = nil
        if not occupied[key] or occupied[key].plate ~= plate then
            SetEntityAsMissionEntity(vehicle, true, true) DeleteVehicle(vehicle)
            return
        end
        ESX.Game.SetVehicleProperties(vehicle, data.prop)
        SetVehicleNumberPlateText(vehicle, data.prop.plate or plate)
        setVehicleDamages(vehicle, data.damages)
        SetEntityAlpha(vehicle, 204, true)
        SetVehicleEngineOn(vehicle, false, true, true)
        SetVehicleDoorsLocked(vehicle, 2)
        FreezeEntityPosition(vehicle, true)
        SetEntityCollision(vehicle, false, true)
        previews[key] = vehicle

        if Customize.OpenTrunk then
            CreateThread(function()
                trunkZone[key] = exports.ox_target:addPolyZone({
                    points = GetVehicleGroundCorners(vehicle), thickness = 8, debug = false,
                    options = { {
                        label = '🚙باز کردن صندوق عقب', icon = 'fa-solid fa-car-rear', distance = 3.0,
                        onSelect = function() Customize.OpenTrunk(vehicle, plate) end,
                    } }
                })
            end)
        end
    end)
end

function DeleteParkMeterPreview(plate)
    for key, d in pairs(occupied) do
        if d.plate == plate then occupied[key] = nil removePreview(key) end
    end
end

RegisterNetEvent('ParkMeter:Sync', function(key, data)
    removePreview(key)
    occupied[key] = data
    creating[key] = nil
end)

-- stream previews in / out by distance and keep them non-solid
CreateThread(function()
    while not ESX do Wait(50) end
    Wait(2500)
    ESX.TriggerServerCallback('ParkMeter:GetAll', function(all)
        for key, d in pairs(all or {}) do occupied[tonumber(key)] = d end
    end)
    while true do
        local pc = GetEntityCoords(PlayerPedId())
        for key, d in pairs(occupied) do
            local m = Customize.ParkMeter[key]
            if m then
                local dist = #(pc - m.coords.xyz)
                if dist < Customize.ParkMeterStreamIn and not previews[key] then
                    createPreview(key)
                elseif dist > Customize.ParkMeterStreamOut and previews[key] then
                    removePreview(key)
                elseif previews[key] and DoesEntityExist(previews[key]) then
                    SetEntityCollision(previews[key], false, true)
                end
            end
        end
        Wait(1500)
    end
end)

AddEventHandler('onResourceStop', function(res)
    if res ~= GetCurrentResourceName() then return end
    for key in pairs(previews) do removePreview(key) end
end)

-- ------------------------------------------------------------ park
local function shuffled(list)
    local t = {}
    for _, c in ipairs(list) do t[#t + 1] = c end
    for i = #t, 2, -1 do
        local j = math.random(1, i)
        t[i], t[j] = t[j], t[i]
    end
    return t
end

function parkVehicleMeter(key, vehicle, silent)
    if not DoesEntityExist(vehicle) or not NetworkGetEntityIsNetworked(vehicle) then return end
    local plate = GetPlate(vehicle)
    if blocked[GetEntityModel(vehicle)] then
        if not silent then notify('error', 'شما نمی‌توانید این وسیله نقلیه را در پارک متر پارک کنید!') end
        return
    end
    ESX.TriggerServerCallback('ParkMeter:CanPark', function(allowed)
        if not allowed then
            if not silent then notify('error', 'Shoma nemitavanid in mashin ra park konid!') end
            return
        end
        ESX.TriggerServerCallback('ParkMeter:CheckUsed', function(used)
            if used then
                if not silent then notify('error', 'Shoma yek mashin dar in garage gozashtid!') end
                return
            end
            if not silent then payFixVehicle(vehicle) end
            if not DoesEntityExist(vehicle) then return end
            local props   = ESX.Game.GetVehicleProperties(vehicle)
            local damages = json.encode(getVehicleDamages(vehicle))
            ESX.TriggerServerCallback('CarLock:haskey', function(hasKey)
                ESX.TriggerServerCallback('ParkMeter:Place', function(ok, reason)
                    if not ok then
                        notify('error', reason or 'In parkmeter por ast')
                        return
                    end
                    TriggerServerEvent('garage:setVehicleState', plate, false, damages)
                    RemoveOwnCarBlip(vehicle)
                    for i = -1, 5 do
                        local ped = GetPedInVehicleSeat(vehicle, i)
                        if ped ~= 0 then TaskLeaveVehicle(ped, vehicle, 16) end
                    end
                    Wait(300)
                    ESX.Game.DeleteVehicle(vehicle)
                    if not silent then notify('success', 'Mashin ba movafaghiat park shod') end
                end, key, plate, props, damages, hasKey and true or false, nil)
            end, plate)
        end, key)
    end, plate)
end

-- ------------------------------------------------------------ retrieve
local function retrieve(key, meter)
    if IsEntityDead(PlayerPedId()) then return end
    ESX.TriggerServerCallback('ParkMeter:CheckUsed', function(used)
        if not used then
            notify('error', 'Shoma mashini dar in garage nazashtid!')
            return
        end
        local done = lib.progressBar({ duration = math.random(1000, 4000), label = 'Dar hale bardashtan...', position = 'bottom', canCancel = false,
            disable = { move = true, car = true, combat = true } })
        if not done then return end

        -- the parked car's own preview sits exactly on the meter and would block the spawn check -> remove it first
        -- (if the spot turns out to be blocked anyway, the streaming loop recreates it within 1.5 s)
        removePreview(key)
        Wait(200)
        local spawnCoord
        if meter.outputCoords and #meter.outputCoords > 0 then
            for _, c in ipairs(shuffled(meter.outputCoords)) do
                if ESX.Game.IsSpawnPointClear(c.xyz, 2) then spawnCoord = c break end
            end
        elseif ESX.Game.IsSpawnPointClear(meter.coords.xyz, 2) then
            spawnCoord = meter.coords
        end
        if not spawnCoord then
            notify('error', 'In makan jahat spawn mashin por ast!')
            return
        end
        Wait(1000)
        ESX.TriggerServerCallback('ParkMeter:Take', function(res)
            if not res then
                notify('error', 'Mashin dige inja nist!')
                return
            end
            removePreview(key)
            occupied[key] = nil
            Wait(300)
            HZSpawnVehicle(res.prop.model, function(vehicle)
                ESX.Game.SetVehicleProperties(vehicle, res.prop)
                SetVehicleNumberPlateText(vehicle, res.prop.plate or res.plate)
                SetVehRadioStation(vehicle, 'OFF')
                setVehicleDamages(vehicle, res.damages)
                SetEntityAsMissionEntity(vehicle, true, true)
                if #(GetEntityCoords(PlayerPedId()) - GetEntityCoords(vehicle)) > 120.0 then
                    DeleteEntity(vehicle)
                    notify('warning', 'Fasele shoma az mashin ziad ast, lotfan nazdik bashid')
                    -- put it back so it is not lost
                    TriggerServerEvent('ParkMeter:Set', key, res.plate, res.prop, res.damages, nil, res.doesHaveKey, res.job)
                    return
                end
                ClearPedTasksImmediately(PlayerPedId())
                TaskWarpPedIntoVehicle(PlayerPedId(), vehicle, -1)
                local t = GetGameTimer() + 3000
                while GetVehiclePedIsIn(PlayerPedId()) ~= vehicle and GetGameTimer() < t do Wait(0) end
                AttachOwnCarBlip(vehicle)
                Wait(100)
                if res.giveKey then
                    TriggerServerEvent('CarLock:ToggleKey', true, res.plate)
                end
            end, spawnCoord, true)
        end, key)
    end, key)
end

-- ------------------------------------------------------------ E interaction (no ground marker)
CreateThread(function()
    while not ESX do Wait(50) end
    for key, meter in ipairs(Customize.ParkMeter) do
        lib.points.new({
            coords = meter.coords.xyz,
            distance = 10.0,
            nearby = function(self)
                -- same marker pair as the old Unique parkmeter (green = free, red = occupied)
                local c = occupied[key] and COLOR_USED or COLOR_FREE
                DrawMarker(36, meter.coords.x, meter.coords.y, meter.coords.z, 0.0, 0.0, 0.0, 0, 0.0, 0.0, 1.0, 1.0, 1.0, c.r, c.g, c.b, 100, false, true, 2, false, false, false, false)
                DrawMarker(6, meter.coords.x, meter.coords.y, meter.coords.z, 0.0, 0.0, 0.0, 0, 0.0, 0.0, 1.5, 1.5, 1.5, c.r, c.g, c.b, 100, false, true, 2, false, false, false, false)
                if self.currentDistance <= 4.0 then
                    ShowHelpNotification('Dokme ~INPUT_CONTEXT~ jahat estefade az park')
                end
                if self.currentDistance <= 3.0 and IsControlJustReleased(0, 38) then
                    if not cooldown('parkMeterGlobal', 600) then return end
                    CreateThread(function() OnMeterPress(key, meter) end)
                end
            end,
        })
    end
end)

function OnMeterPress(key, meter)
    local ped = PlayerPedId()
    if IsEntityDead(ped) then return end
    local vehicle = GetVehiclePedIsIn(ped, false)
    if vehicle ~= 0 then
        if GetEntitySpeed(vehicle) * 3.6 > Customize.ParkMeterMaxSpeed then
            return notify('warning', 'برای پارک ابتدا ماشین را متوقف کنید')
        end
        if GetPedInVehicleSeat(vehicle, -1) ~= ped then
            return notify('error', 'Shoma ranande mashin nistid!')
        end
        if not cooldown('parkMeter', 6000) then return notify('error', 'Spam nakonid') end
        local plate = GetPlate(vehicle)
        ESX.TriggerServerCallback('ParkMeter:CanPark', function(allowed)
            if not allowed then return notify('error', 'Shoma nemitavanid in mashin ra park konid!') end
            local done = lib.progressBar({ duration = 3000, label = 'Dar hale park kardan...', position = 'bottom', useWhileDead = false, canCancel = false,
                disable = { move = true, car = true, combat = true } })
            if done then parkVehicleMeter(key, vehicle, false) end
        end, plate)
    else
        if not cooldown('parkMeter', 6000) then return notify('error', 'Spam nakonid') end
        local busy = IsPedRagdoll(ped) or IsEntityAttached(ped)
        if busy then return notify('error', 'Dar in halat nemitavanid az parking estefade konid') end
        retrieve(key, meter)
    end
end

-- ------------------------------------------------------------ auto park after leaving the car near a meter
function OnLeaveVehicleNearMeter(vehicle)
    local coords = GetEntityCoords(PlayerPedId())
    local nearest, nearestDist
    for k, v in ipairs(Customize.ParkMeter) do
        local d = #(coords - v.coords.xyz)
        if v.range and d < v.range and (not nearestDist or d < nearestDist) then
            nearest, nearestDist = k, d
        end
    end
    if not nearest then return end
    ESX.TriggerServerCallback('ParkMeter:CheckUsed', function(used)
        if used then return end
        CreateThread(function()
            local active, timer = true, Customize.ParkMeterAutoParkDelay
            CreateThread(function()
                while active do
                    Wait(1000)
                    if not DoesEntityExist(vehicle) or GetPedInVehicleSeat(vehicle, -1) ~= 0 then active = false break end
                    if #(GetEntityCoords(PlayerPedId()) - GetEntityCoords(vehicle)) > 5.0 then
                        timer = timer - 1
                        if timer <= 0 then
                            active = false
                            parkVehicleMeter(nearest, vehicle, true)
                        end
                    end
                end
            end)
            while DoesEntityExist(vehicle) and not GetIsVehicleEngineRunning(vehicle) and active do
                ESX.Game.Utils.DrawText3D(GetEntityCoords(vehicle) + vec(0, 0, 1), tostring(timer), 3)
                Wait(0)
            end
            active = false
        end)
    end, nearest)
end
