--[[
    kq_detective — client functions, cleaned up + fixed for this server.

    Fixes vs. the original file:
      1) CanInvestigate() was bugged: it read Config.whitelist.enabled into a
         local, then immediately overwrote that local with `playerJob` before
         ever using it. The final returned expression was `(not X) or X`,
         which is a tautology — ALWAYS true. In practice the job whitelist
         never did anything; any job could investigate. Fixed below.
      2) IsDead() / StartInvestigatePed() only recognised a player as
         "dead" when Config.qbSettings.enabled was true. Since this server
         runs ESX (essentialmode bridge), that branch never ran, so
         detectives could never investigate a downed/dead PLAYER — only
         dead NPC peds. Both functions now use `deadPlayers` regardless of
         framework, since server.lua now populates it for ESX too.
]]

RegisterNUICallback('UILoaded', function(data, cb)
    SendNUIMessage({
        event = 'set-locale',
        timeOfDeath = L('Time of death'),
        causeOfDeath = L('Cause of death'),
        area = L('Area of impact'),
        weaponType = L('Weapon type used'),
        weaponModel = L('Weapon model used'),
        vehicle = L('Vehicle class'),
        minute = L('minute ago'),
        minutes = L('minutes ago'),
        murder = L('Murder/Unknown'),
    })
    cb(true)
end)

RegisterNUICallback('CloseNotepad', function(data, cb)
    if not changing then
        CloseNotepad()
    end
    cb(true)
end)

RegisterNetEvent('kq_detective:investigate')
AddEventHandler('kq_detective:investigate', function(data)
    StartInvestigatePed(data.entity)
end)

function CloseNotepad()
    SendNUIMessage({ event = 'show', state = false })
    menuOpen = false
    SetNuiFocus(false, false)
    ClearPedTasks(PlayerPedId())
end

function OpenNotepad(time, cause, isWeapon, weaponType, weaponName, vehicleClass, area, boneTop, boneLeft, samePed)
    SendNUIMessage({
        event = 'show',
        state = true,
        time = time,
        cause = cause,
        isWeapon = isWeapon,
        weaponType = weaponType,
        weaponName = weaponName,
        vehicleClass = vehicleClass,
        area = area,
        boneTop = boneTop,
        boneLeft = boneLeft,
        samePed = samePed,
    })

    menuOpen = true

    if Config.animation.enabled then
        PlayAnim(Config.animation.dict, Config.animation.anim, 1)
    end

    SetNuiFocus(true, true)
end

-- Returns the server id of `ped` if it's a networked player ped, else nil.
-- (Global on purpose — client/forensics.lua reuses this for the evidence
-- collection events.)
function GetPlayerServerIdFromPed(ped)
    if not IsPedAPlayer(ped) then return nil end

    local activePlayers = GetActivePlayers()
    for i = 1, #activePlayers do
        local playerId = activePlayers[i]
        if GetPlayerPed(playerId) == ped then
            return GetPlayerServerId(playerId)
        end
    end

    return nil
end

function StartInvestigatePed(ped)
    if not CanInvestigate() then return end

    local serverId = GetPlayerServerIdFromPed(ped)
    if serverId then
        -- Dead/downed player: ask the server for the death info it recorded
        -- (populated by server.lua's ESX/QB branches via savePlayerInfo).
        TriggerServerEvent('kq_detective:getPlayerInfo', serverId, ped)
        return
    end

    -- Dead NPC ped: everything is available locally via game natives.
    local sinceDeath = GetGameTimer() - GetPedTimeOfDeath(ped)
    local killerEntity = GetPedSourceOfDeath(ped)
    local weaponHash = GetPedCauseOfDeath(ped)
    local _, bone = GetPedLastDamageBone(ped)

    InvestigatePed(ped, sinceDeath, killerEntity, weaponHash, bone)
end

function InvestigatePed(ped, sinceDeath, killerEntity, weaponHash, bone)
    if not CanInvestigate() then return end

    local myPed = PlayerPedId()
    local pedCoords = GetEntityCoords(ped)
    local myCoords = GetEntityCoords(myPed)

    local heading = GetHeadingFromVector_2d(myCoords.x - pedCoords.x, myCoords.y - pedCoords.y) + 180
    SetEntityHeading(myPed, heading)

    local minutesSinceDeath = math.floor((sinceDeath / 1000) / 60)

    local isWeapon = GetWeapontypeSlot(weaponHash) ~= 0 and GetWeapontypeSlot(weaponHash) ~= nil
    local weaponType = L('Unknown')
    local weaponName = isWeapon and GetWeaponName(weaponHash) or nil

    local vehicleClass = false
    local cause = GetCauseOfDeath(killerEntity, weaponHash)

    if isWeapon then
        weaponType = GetWeaponType(weaponHash)
    end

    if cause == L('Vehicular') or weaponHash == settings.causes[-1553120962] then
        isWeapon = false
        if killerEntity and killerEntity ~= 0 and IsEntityAVehicle(killerEntity) then
            vehicleClass = GetVehicleClass(GetEntityModel(killerEntity))
        end
    end

    local damagedArea = GetDamagedArea(bone)

    OpenNotepad(
        minutesSinceDeath,
        cause,
        isWeapon,
        weaponType,
        weaponName,
        vehicleClass,
        damagedArea.name,
        damagedArea.top,
        damagedArea.left,
        lastPed == ped
    )

    lastPed = ped
    lastTime = GetPedTimeOfDeath(ped)
end

function GetCauseOfDeath(killerEntity, weaponHash)
    if settings.causes[weaponHash] then
        return settings.causes[weaponHash]
    end

    if IsEntityAnObject(killerEntity) then
        return L('Unknown')
    end

    if IsEntityAVehicle(killerEntity) then
        return L('Vehicular')
    end

    if IsEntityAPed(killerEntity) then
        return L('Murder/Unknown')
    end

    return L('Unknown')
end

function GetWeaponName(weaponHash)
    local weapon = settings.weapons[weaponHash]
    if not weapon then return L('Unknown') end
    return weapon.name
end

function GetWeaponType(weaponHash)
    local weapon = settings.weapons[weaponHash]
    if not weapon then return L('Unknown') end

    local weaponType = settings.types[weapon.type]
    return weaponType or L('Unknown')
end

function GetVehicleClass(model)
    return GetLabelText('VEH_CLASS_' .. GetVehicleClassFromName(model))
end

function GetDamagedArea(bone)
    local areaKey = settings.bones[bone]
    local area = areaKey and settings.areas[areaKey]

    if not area then
        return { name = L('Unknown'), top = 0, left = 0 }
    end

    return area
end

-- Synced from the server (works for both ESX and QB now — see server.lua).
deadPlayers = {}

RegisterNetEvent('kq_detective:syncDeadPlayers')
AddEventHandler('kq_detective:syncDeadPlayers', function(data)
    deadPlayers = data
end)

function IsDead(ped)
    if IsEntityDead(ped, 1) then
        return true
    end

    local serverId = GetPlayerServerIdFromPed(ped)
    if serverId then
        return Contains(deadPlayers, serverId)
    end

    return false
end

function PlayAnim(dict, anim, flag)
    RequestAnimDict(dict)
    while not HasAnimDictLoaded(dict) do
        Citizen.Wait(100)
    end

    TaskPlayAnim(PlayerPedId(), dict, anim, 4.0, 8.0, 5.0, flag or 1, 1, false, false, false)
    RemoveAnimDict(dict)
end

-- Fixed: previously always returned true regardless of Config.whitelist
-- (see file header). Now actually enforces the job whitelist.
function CanInvestigate()
    if not Config.whitelist.enabled then
        return true
    end

    return Contains(Config.whitelist.jobs, playerJob)
end

function Contains(list, value)
    for _, item in ipairs(list) do
        if item == value then
            return true
        end
    end
    return false
end

function L(key)
    if Locale and Locale[key] then
        return Locale[key]
    end
    return key
end
