--[[
    Change World System - Final Merged Version (client)
    Pairs with changeworld-sv.lua
]]

-- NOTE: old ESX build (on essentialmode) - must use the event, not exports.
local ESX = nil
CreateThread(function()
    while ESX == nil do
        TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
        Wait(0)
    end
end)

-- ============================================================
-- BASIC EVENT HANDLERS
-- ============================================================

RegisterNetEvent('cw:notify')
AddEventHandler('cw:notify', function(message)
    ESX.ShowNotification(message)
end)

RegisterNetEvent('cw:teleport')
AddEventHandler('cw:teleport', function(x, y, z)
    local ped = PlayerPedId()
    SetEntityCoords(ped, x, y, z, false, false, false, true)
end)

RegisterNetEvent('cw:setArmor')
AddEventHandler('cw:setArmor', function(amount)
    local ped = PlayerPedId()
    TriggerEvent('esx_status:set', 'armor', amount)
    AddArmourToPed(ped, amount)
    ESX.ShowNotification("Armor Shoma Por Shod!")
end)

RegisterNetEvent('cw:setMaxAmmo')
AddEventHandler('cw:setMaxAmmo', function(amount)
    local ped = PlayerPedId()
    local weaponHash = GetSelectedPedWeapon(ped)
    if weaponHash ~= `WEAPON_UNARMED` then
        AddAmmoToPed(ped, weaponHash, amount)
        ESX.ShowNotification("Tedad Tir Be Maximom Afzayesh Yaft!")
    else
        ESX.ShowNotification("Shoma Hich Aslahe Darid!")
    end
end)

RegisterNetEvent('cw:doSpawnVehicle')
AddEventHandler('cw:doSpawnVehicle', function(vehicleName)
    local ped = PlayerPedId()
    local coords = GetEntityCoords(ped)
    ESX.Game.SpawnVehicle(vehicleName, coords, GetEntityHeading(ped), function(vehicle)
        TaskWarpPedIntoVehicle(ped, vehicle, -1)
    end)
end)

RegisterNetEvent('cw:doDeleteVehicle')
AddEventHandler('cw:doDeleteVehicle', function()
    local ped = PlayerPedId()
    local vehicle = GetVehiclePedIsIn(ped, false)
    if vehicle ~= 0 then
        ESX.Game.DeleteVehicle(vehicle)
    else
        ESX.ShowNotification("Shoma Dar Hich Mashini Nistid.")
    end
end)

RegisterNetEvent('cw:doTpWaypoint')
AddEventHandler('cw:doTpWaypoint', function()
    local ped = PlayerPedId()
    if IsPedInAnyVehicle(ped, false) then
        ped = GetVehiclePedIsUsing(ped)
    end

    local waypoint = GetFirstBlipInfoId(8)
    if not DoesBlipExist(waypoint) then
        ESX.ShowNotification("Markeri Baraye Teleport Shodan Vojoud Nadarad!")
        return
    end

    local target = GetBlipInfoIdCoord(waypoint)
    for height = 1, 1000 do
        SetPedCoordsKeepVehicle(ped, target.x, target.y, height + 0.0)
        local found, z = GetGroundZFor_3dCoord(target.x, target.y, height + 0.0)
        if found then
            SetPedCoordsKeepVehicle(ped, target.x, target.y, z)
            break
        end
        Wait(1)
    end
    ESX.ShowNotification("Shoma Be Marker Rooye Map Teleport Shodid!")
end)

-- ---- Self: extra options ----

RegisterNetEvent('cw:doHeal')
AddEventHandler('cw:doHeal', function()
    SetEntityHealth(PlayerPedId(), GetEntityMaxHealth(PlayerPedId()))
end)

local invisibleOn = false
RegisterNetEvent('cw:setInvisible')
AddEventHandler('cw:setInvisible', function(state)
    invisibleOn = state
    SetEntityVisible(PlayerPedId(), not state, false)
end)

local godModeOn = false
RegisterNetEvent('cw:setGodMode')
AddEventHandler('cw:setGodMode', function(state)
    godModeOn = state
    SetEntityInvincible(PlayerPedId(), state)
end)

-- ---- Vehicle: extra options ----

RegisterNetEvent('cw:doRepairVehicle')
AddEventHandler('cw:doRepairVehicle', function()
    local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
    if vehicle == 0 then
        ESX.ShowNotification("Shoma Dar Hich Mashini Nistid.")
        return
    end
    SetVehicleFixed(vehicle)
    SetVehicleDeformationFixed(vehicle)
    SetVehicleUndriveable(vehicle, false)
    SetVehicleEngineHealth(vehicle, 1000.0)
    ESX.ShowNotification("Mashin Tamir Shod!")
end)

RegisterNetEvent('cw:doFlipVehicle')
AddEventHandler('cw:doFlipVehicle', function()
    local ped = PlayerPedId()
    local vehicle = GetVehiclePedIsIn(ped, false)
    if vehicle == 0 then
        ESX.ShowNotification("Shoma Dar Hich Mashini Nistid.")
        return
    end
    local coords = GetEntityCoords(vehicle)
    local heading = GetEntityHeading(vehicle)
    SetEntityRotation(vehicle, 0.0, 0.0, heading, 2, true)
    SetEntityCoords(vehicle, coords.x, coords.y, coords.z + 0.5, false, false, false, true)
    SetVehicleOnGroundProperly(vehicle)
    ESX.ShowNotification("Mashin Sagh Shod!")
end)

local vehGodModeOn = false
RegisterNetEvent('cw:setVehGodMode')
AddEventHandler('cw:setVehGodMode', function(state)
    vehGodModeOn = state
end)

CreateThread(function()
    while true do
        Wait(500)
        if vehGodModeOn then
            local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
            if vehicle ~= 0 then
                SetEntityInvincible(vehicle, true)
                SetVehicleTyresCanBurst(vehicle, false)
                SetVehicleFixed(vehicle)
            end
        end
    end
end)

-- ---- World: time & weather ----

RegisterNetEvent('cw:doSetWeather')
AddEventHandler('cw:doSetWeather', function(weatherName)
    SetWeatherTypeNowPersist(weatherName)
    ESX.ShowNotification(("Weather: %s"):format(weatherName))
end)

RegisterNetEvent('cw:doSetTime')
AddEventHandler('cw:doSetTime', function(hour)
    NetworkOverrideClockTime(hour, 0, 0)
    ESX.ShowNotification(("Saat: %s"):format(hour))
end)

local freezeTimeOn = false
RegisterNetEvent('cw:setFreezeTime')
AddEventHandler('cw:setFreezeTime', function(state)
    freezeTimeOn = state
    PauseClock(state)
end)

-- ============================================================
-- E-KEY LOCK (prevents vehicle entry / interactions while in a world)
-- ============================================================

local eKeyDisabled = false
local originalModel = nil
local originalSkin = nil

-- Exported so OTHER client scripts (ATM, shops, job points, etc.) can
-- check "is this player currently inside a Change World" and refuse to
-- open/interact while true - routing buckets don't stop world objects
-- (they're static map props, not networked entities), so those scripts
-- need to opt in to this check themselves.
exports('IsInChangeWorldClient', function()
    return eKeyDisabled
end)

RegisterNetEvent('cw:disableEKey')
AddEventHandler('cw:disableEKey', function()
    eKeyDisabled = true
    -- remember what we looked like before any appearance changes in-world
    originalModel = GetEntityModel(PlayerPedId())
    local ok, skin = pcall(function() return exports['skinchanger']:getSkin() end)
    originalSkin = ok and skin or nil
end)

RegisterNetEvent('cw:enableEKey')
AddEventHandler('cw:enableEKey', function()
    eKeyDisabled = false
end)

CreateThread(function()
    while true do
        Wait(0)
        if eKeyDisabled then
            DisableControlAction(0, 38, true)  -- E
            DisableControlAction(0, 289, true) -- vehicle enter/exit alt
        end
    end
end)

-- ============================================================
-- NOCLIP
-- ============================================================

local noclipOn = false

RegisterNetEvent('cw:setNoclip')
AddEventHandler('cw:setNoclip', function(state)
    noclipOn = state
    local ped = PlayerPedId()
    SetEntityVisible(ped, not state, false)
    SetEntityCollision(ped, not state, not state)
    SetEntityInvincible(ped, state or godModeOn)
    FreezeEntityPosition(ped, state)
end)

CreateThread(function()
    while true do
        local waitTime = 250
        if noclipOn then
            waitTime = 0
            local ped = PlayerPedId()
            local coords = GetEntityCoords(ped)
            local speed = IsControlPressed(0, 21) and 1.2 or 0.4 -- Sprint = faster

            local rot = GetGameplayCamRot(2)
            local radHeading = math.rad(rot.z)
            local radPitch = math.rad(rot.x)
            local forward = vector3(-math.sin(radHeading) * math.cos(radPitch), math.cos(radHeading) * math.cos(radPitch), math.sin(radPitch))
            local right = vector3(math.cos(radHeading), math.sin(radHeading), 0.0)

            local move = vector3(0.0, 0.0, 0.0)
            if IsControlPressed(0, 32) then move = move + forward end -- W
            if IsControlPressed(0, 33) then move = move - forward end -- S
            if IsControlPressed(0, 34) then move = move - right end   -- A
            if IsControlPressed(0, 35) then move = move + right end   -- D
            if IsControlPressed(0, 22) then move = move + vector3(0.0, 0.0, 1.0) end -- Space (up)
            if IsControlPressed(0, 36) then move = move - vector3(0.0, 0.0, 1.0) end -- Ctrl (down)

            local len = #move
            if len > 0.0 then
                move = move / len
                coords = coords + (move * speed)
                SetEntityCoordsNoOffset(ped, coords.x, coords.y, coords.z, false, false, false)
            end
        end
        Wait(waitTime)
    end
end)

-- ============================================================
-- MENU-GIVEN WEAPONS
-- ============================================================

local CWMenuWeapons = {
    { label = "Pistol",          name = "WEAPON_PISTOL" },
    { label = "Pistol .50",      name = "WEAPON_PISTOL50" },
    { label = "Combat Pistol",   name = "WEAPON_COMBATPISTOL" },
    { label = "AP Pistol",       name = "WEAPON_APPISTOL" },
    { label = "Micro SMG",       name = "WEAPON_MICROSMG" },
    { label = "SMG",             name = "WEAPON_SMG" },
    { label = "Assault SMG",     name = "WEAPON_ASSAULTSMG" },
    { label = "Assault Rifle",   name = "WEAPON_ASSAULTRIFLE" },
    { label = "Carbine Rifle",   name = "WEAPON_CARBINERIFLE" },
    { label = "Bullpup Rifle",   name = "WEAPON_BULLPUPRIFLE" },
    { label = "Pump Shotgun",    name = "WEAPON_PUMPSHOTGUN" },
    { label = "Sawed-Off",       name = "WEAPON_SAWNOFFSHOTGUN" },
    { label = "Sniper Rifle",    name = "WEAPON_SNIPERRIFLE" },
    { label = "Heavy Sniper",    name = "WEAPON_HEAVYSNIPER" },
    { label = "Knife",           name = "WEAPON_KNIFE" },
    { label = "Bat",             name = "WEAPON_BAT" },
    { label = "Nightstick",      name = "WEAPON_NIGHTSTICK" },
    { label = "Grenade",         name = "WEAPON_GRENADE" },
    { label = "Sticky Bomb",     name = "WEAPON_STICKYBOMB" },
    { label = "Smoke Grenade",   name = "WEAPON_SMOKEGRENADE" },
}
local givenWeapons = {}

RegisterNetEvent('cw:doGiveWeapon')
AddEventHandler('cw:doGiveWeapon', function(weaponName)
    local ped = PlayerPedId()
    local hash = GetHashKey(weaponName)
    GiveWeaponToPed(ped, hash, 250, false, true)
    SetPedAmmo(ped, hash, 250)
    givenWeapons[weaponName] = true
    ESX.ShowNotification(("Aslahe Dadeh Shod: %s"):format(weaponName))
end)

-- ============================================================
-- MENU APPEARANCE (cosmetic only, auto-reset on exit)
-- ============================================================

local CWMenuAppearances = {
    { label = "SWAT",           model = "s_m_y_swat_01" },
    { label = "Police Officer", model = "s_m_y_cop_01" },
    { label = "FIB Agent",      model = "csb_agent" },
    { label = "Firefighter",    model = "s_m_y_fireman_01" },
    { label = "Paramedic",      model = "s_m_m_paramedic_01" },
    { label = "Pilot",          model = "s_m_y_pilot_01" },
    { label = "Business Man",   model = "a_m_y_business_01" },
    { label = "Business Woman", model = "a_f_y_business_02" },
    { label = "Farmer",         model = "a_m_m_farmer_01" },
}
local appearanceChanged = false

RegisterNetEvent('cw:doSetAppearance')
AddEventHandler('cw:doSetAppearance', function(model)
    local hash = GetHashKey(model)
    RequestModel(hash)
    local tries = 0
    while not HasModelLoaded(hash) and tries < 200 do Wait(10); tries = tries + 1 end
    if not HasModelLoaded(hash) then
        ESX.ShowNotification("Model Load Nashod!")
        return
    end
    SetPlayerModel(PlayerId(), hash)
    SetModelAsNoLongerNeeded(hash)
    appearanceChanged = true
    ESX.ShowNotification("Zaher Shoma Taghir Kard!")
end)

local function ResetAppearance()
    if not appearanceChanged or not originalModel then return end
    RequestModel(originalModel)
    local tries = 0
    while not HasModelLoaded(originalModel) and tries < 200 do Wait(10); tries = tries + 1 end
    if HasModelLoaded(originalModel) then
        SetPlayerModel(PlayerId(), originalModel)
        SetModelAsNoLongerNeeded(originalModel)
        if originalSkin then
            TriggerEvent('skinchanger:loadSkin', originalSkin)
        end
    end
    appearanceChanged = false
end

-- ============================================================
-- FULL STATE RESET (called by the server whenever you leave a world, no
-- matter how - /bw, ox_target, or an admin force)
-- ============================================================

RegisterNetEvent('cw:resetWorldState')
AddEventHandler('cw:resetWorldState', function()
    local ped = PlayerPedId()

    if noclipOn then
        noclipOn = false
        SetEntityVisible(ped, true, false)
        SetEntityCollision(ped, true, true)
        FreezeEntityPosition(ped, false)
    end
    if invisibleOn then
        invisibleOn = false
        SetEntityVisible(ped, true, false)
    end
    if godModeOn then
        godModeOn = false
    end
    SetEntityInvincible(ped, false)
    vehGodModeOn = false
    freezeTimeOn = false
    PauseClock(false)

    for weaponName in pairs(givenWeapons) do
        RemoveWeaponFromPed(ped, GetHashKey(weaponName))
    end
    givenWeapons = {}

    ResetAppearance()
end)

-- ============================================================
-- IN-WORLD MENU (F11)
-- ============================================================

local function openSelfOptions()
    ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'cw_self', {
        title = "Self Options",
        align = 'top-left',
        elements = {
            { label = "Revive",             value = 'revive' },
            { label = "Full Health",        value = 'heal' },
            { label = "Full Armor",         value = 'armor' },
            { label = "Max Ammo",           value = 'ammo' },
            { label = "Refill Hunger/Thirst", value = 'needs' },
            { label = invisibleOn and "Invisible: ON" or "Invisible: OFF", value = 'invisible' },
            { label = godModeOn and "God Mode: ON" or "God Mode: OFF",     value = 'godmode' },
            { label = noclipOn and "NoClip: ON" or "NoClip: OFF",          value = 'noclip' },
        }
    }, function(data, menu)
        local v = data.current.value
        if v == 'revive' then
            TriggerServerEvent('cw:revive')
        elseif v == 'heal' then
            TriggerServerEvent('cw:heal')
        elseif v == 'armor' then
            TriggerServerEvent('cw:armor')
        elseif v == 'ammo' then
            TriggerServerEvent('cw:maxAmmo')
        elseif v == 'needs' then
            TriggerServerEvent('cw:refillNeeds')
        elseif v == 'invisible' then
            TriggerServerEvent('cw:toggleInvisible')
            menu.close()
            Wait(100)
            openSelfOptions()
        elseif v == 'godmode' then
            TriggerServerEvent('cw:toggleGodMode')
            menu.close()
            Wait(100)
            openSelfOptions()
        elseif v == 'noclip' then
            TriggerServerEvent('cw:toggleNoclip')
            menu.close()
            Wait(100)
            openSelfOptions()
        end
    end, function(data, menu)
        menu.close()
    end)
end

local function openWeaponOptions()
    local elements = {}
    for _, w in ipairs(CWMenuWeapons) do
        table.insert(elements, { label = w.label, value = w.name })
    end
    ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'cw_weapons', {
        title = "Weapon Options",
        align = 'top-left',
        elements = elements,
    }, function(data, menu)
        TriggerServerEvent('cw:giveWeapon', data.current.value)
    end, function(data, menu)
        menu.close()
    end)
end

local function openAppearanceOptions()
    local elements = { { label = "~y~Reset To My Skin~s~", value = 'reset' } }
    for _, a in ipairs(CWMenuAppearances) do
        table.insert(elements, { label = a.label, value = a.model })
    end
    ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'cw_appearance', {
        title = "Appearance Options",
        align = 'top-left',
        elements = elements,
    }, function(data, menu)
        if data.current.value == 'reset' then
            ResetAppearance()
        else
            TriggerServerEvent('cw:setAppearance', data.current.value)
        end
    end, function(data, menu)
        menu.close()
    end)
end

local function openVehicleOptions()
    ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'cw_vehicle', {
        title = "Vehicle Options",
        align = 'top-left',
        elements = {
            { label = "Spawn Vehicle",  value = 'spawn' },
            { label = "Delete Vehicle", value = 'delete' },
            { label = "Repair Vehicle", value = 'repair' },
            { label = "Flip Vehicle Upright", value = 'flip' },
            { label = vehGodModeOn and "Vehicle God Mode: ON" or "Vehicle God Mode: OFF", value = 'vehgod' },
        }
    }, function(data, menu)
        local v = data.current.value
        if v == 'spawn' then
            ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'cw_vehicle_name', {
                title = "Enter Vehicle Name"
            }, function(data2, menu2)
                TriggerServerEvent('cw:spawnVehicle', data2.value)
                menu2.close()
            end, function(data2, menu2)
                menu2.close()
            end)
        elseif v == 'delete' then
            TriggerServerEvent('cw:deleteVehicle')
        elseif v == 'repair' then
            TriggerServerEvent('cw:repairVehicle')
        elseif v == 'flip' then
            TriggerServerEvent('cw:flipVehicle')
        elseif v == 'vehgod' then
            TriggerServerEvent('cw:toggleVehGodMode')
            menu.close()
            Wait(100)
            openVehicleOptions()
        end
    end, function(data, menu)
        menu.close()
    end)
end

local function openWorldOptions()
    ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'cw_world', {
        title = "World Options",
        align = 'top-left',
        elements = {
            { label = "Weather: Clear",     value = { type = 'weather', name = 'EXTRASUNNY' } },
            { label = "Weather: Rain",      value = { type = 'weather', name = 'RAIN' } },
            { label = "Weather: Thunder",   value = { type = 'weather', name = 'THUNDER' } },
            { label = "Weather: Fog",       value = { type = 'weather', name = 'FOGGY' } },
            { label = "Weather: Snow",      value = { type = 'weather', name = 'XMAS' } },
            { label = "Time: Set Hour",     value = { type = 'settime' } },
            { label = freezeTimeOn and "Freeze Time: ON" or "Freeze Time: OFF", value = { type = 'freezetime' } },
        }
    }, function(data, menu)
        local v = data.current.value
        if v.type == 'weather' then
            TriggerServerEvent('cw:setWeather', v.name)
        elseif v.type == 'settime' then
            ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'cw_set_time', {
                title = "Enter Hour (0-23)"
            }, function(data2, menu2)
                TriggerServerEvent('cw:setTime', data2.value)
                menu2.close()
            end, function(data2, menu2)
                menu2.close()
            end)
        elseif v.type == 'freezetime' then
            TriggerServerEvent('cw:toggleFreezeTime')
            menu.close()
            Wait(100)
            openWorldOptions()
        end
    end, function(data, menu)
        menu.close()
    end)
end

local function openTeleportOptions()
    ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'cw_teleport', {
        title = "Teleport Options",
        align = 'top-left',
        elements = {
            { label = "Teleport To Waypoint",   value = 'waypoint' },
            { label = "Save Current Position",  value = 'save' },
            { label = "Teleport To Saved Position", value = 'load' },
        }
    }, function(data, menu)
        local v = data.current.value
        if v == 'waypoint' then
            TriggerServerEvent('cw:tpWaypoint')
        elseif v == 'save' then
            TriggerServerEvent('cw:savePos')
        elseif v == 'load' then
            TriggerServerEvent('cw:tpSavedPos')
        end
    end, function(data, menu)
        menu.close()
    end)
end

local function openMainMenu()
    ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'cw_main', {
        title = "Change World Menu",
        align = 'top-left',
        elements = {
            { label = "Self Options",       value = 'self' },
            { label = "Weapon Options",     value = 'weapons' },
            { label = "Appearance Options", value = 'appearance' },
            { label = "Vehicle Options",    value = 'vehicle' },
            { label = "World Options",      value = 'world' },
            { label = "Teleport Options",   value = 'teleport' },
        }
    }, function(data, menu)
        if data.current.value == 'self' then
            openSelfOptions()
        elseif data.current.value == 'weapons' then
            openWeaponOptions()
        elseif data.current.value == 'appearance' then
            openAppearanceOptions()
        elseif data.current.value == 'vehicle' then
            openVehicleOptions()
        elseif data.current.value == 'world' then
            openWorldOptions()
        elseif data.current.value == 'teleport' then
            openTeleportOptions()
        end
    end, function(data, menu)
        menu.close()
    end)
end

CreateThread(function()
    while true do
        Wait(0)
        if IsControlJustPressed(0, 56) then -- F11
            ESX.TriggerServerCallback('cw:menuAccess', function(hasAccess)
                if hasAccess then
                    openMainMenu()
                end
            end)
        end
    end
end)

-- ============================================================
-- OX_TARGET GATE PED (walk up + target, instead of typing /cw or /bw)
-- ============================================================

local gatePed = nil
local gateWorld = nil

local function RemoveGatePed()
    if gatePed and DoesEntityExist(gatePed) then
        exports.ox_target:removeLocalEntity(gatePed)
        DeleteEntity(gatePed)
    end
    gatePed = nil
    gateWorld = nil
end

local function SpawnGatePed(coords, world)
    local model = `a_m_m_business_01`
    RequestModel(model)
    while not HasModelLoaded(model) do Wait(10) end

    gatePed = CreatePed(4, model, coords.x, coords.y, coords.z - 1.0, 0.0, false, false)
    SetEntityInvincible(gatePed, true)
    FreezeEntityPosition(gatePed, true)
    SetBlockingOfNonTemporaryEvents(gatePed, true)
    TaskStartScenarioInPlace(gatePed, "WORLD_HUMAN_STAND_IMPATIENT", 0, true)
    gateWorld = world

    exports.ox_target:addLocalEntity(gatePed, {
        {
            name = 'cw_gate_enter',
            icon = 'fas fa-door-open',
            label = 'Vorod Be Change World',
            distance = 2.5,
            canInteract = function() return not eKeyDisabled end,
            onSelect = function()
                TriggerServerEvent('cw:targetEnter')
            end,
        },
        {
            name = 'cw_gate_exit',
            icon = 'fas fa-door-closed',
            label = 'Khorooj Az Change World',
            distance = 2.5,
            canInteract = function() return eKeyDisabled end,
            onSelect = function()
                TriggerServerEvent('cw:targetExit')
            end,
        },
    })
end

-- Refresh the gate ped for this player's own world every so often (covers
-- gang changes, boss action moves, joining/leaving a gang, etc.)
CreateThread(function()
    while true do
        Wait(30000)
        ESX.TriggerServerCallback('cw:getGateInfo', function(info)
            if not info then
                RemoveGatePed()
                return
            end
            if gateWorld ~= info.world or not gatePed or not DoesEntityExist(gatePed) then
                RemoveGatePed()
                SpawnGatePed(info.coords, info.world)
            end
        end)
    end
end)

AddEventHandler('onResourceStop', function(resourceName)
    if resourceName == GetCurrentResourceName() then
        RemoveGatePed()
    end
end)

-- ============================================================
-- ADMIN PANEL (F9): who's in which world, Goto, Return
-- ============================================================

local function openAdminPlayerMenu(entry)
    ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'cw_admin_player', {
        title = ("%s (ID %s) - %s"):format(entry.name, entry.id, entry.label),
        align = 'top-left',
        elements = {
            { label = "Goto",              value = 'goto' },
            { label = "Bargasht Be Mokan Ghabli", value = 'return' },
        }
    }, function(data, menu)
        if data.current.value == 'goto' then
            TriggerServerEvent('cw:adminGoto', entry.id)
            menu.close()
        elseif data.current.value == 'return' then
            TriggerServerEvent('cw:adminReturn')
            menu.close()
        end
    end, function(data, menu)
        menu.close()
    end)
end

local function openAdminPanel(list)
    local elements = {
        { label = "~y~Bargasht Be Mokan Ghabli~s~", value = { type = 'return' } },
    }
    for _, entry in ipairs(list) do
        table.insert(elements, {
            label = ("ID %s | %s | World: %s (%s)"):format(entry.id, entry.name, entry.world, entry.label),
            value = { type = 'player', entry = entry },
        })
    end
    if #list == 0 then
        table.insert(elements, { label = "~r~Hich Kasi Dar Change World Nist~s~", value = { type = 'none' } })
    end

    ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'cw_admin_main', {
        title = "Change World - Admin Panel",
        align = 'top-left',
        elements = elements,
    }, function(data, menu)
        local v = data.current.value
        if v.type == 'player' then
            openAdminPlayerMenu(v.entry)
        elseif v.type == 'return' then
            TriggerServerEvent('cw:adminReturn')
        end
    end, function(data, menu)
        menu.close()
    end)
end

RegisterNetEvent('cw:openAdminPanel')
AddEventHandler('cw:openAdminPanel', function()
    ESX.TriggerServerCallback('cw:adminListPlayers', function(list)
        if not list then
            ESX.ShowNotification("Dastresi Nadarid.")
            return
        end
        openAdminPanel(list)
    end)
end)

RegisterKeyMapping('cwadmin', 'Baz Kardan Panel Admin Change World', 'keyboard', 'F9')
RegisterCommand('cwadmin', function()
    TriggerServerEvent('cw:requestAdminPanel')
end, false)