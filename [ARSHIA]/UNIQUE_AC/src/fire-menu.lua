

local isAdmin = false
local pendingAdminMenuOpen = false
local playerLocations = { coords = nil, heading = nil }

local cam = nil
local InSpectatorMode = false
local TargetSpectate = nil
local targetPed = nil
local currentVoiceChannel = nil
local health, maxhealth, armor = nil, nil, nil
local radius = -1
local polarAngleDeg, azimuthAngleDeg = 0, 0

local adminModes = {
    godmode = false,
    invisible = false,
    night = false,
    thermal = false,
    spectate = false,
    weaponKit = false,
    noclip = false,
    superjump = false,
    fastrun = false,
    playerBlips = false,
    infiniteStamina = false,
    noRagdoll = false,
}

local function hasPersistentAdminMode()
    for _, enabled in pairs(adminModes) do
        if enabled then return true end
    end
    return false
end

local function grantAdminGrace(duration)
    if not isAdmin then return false end
    duration = math.max(1000, math.min(tonumber(duration) or 15000, 600000))
    TriggerServerEvent("UNIQUE_AC:adminState", true, duration)
    TriggerEvent("UNIQUE_AC:clientGrace", duration)
    return true
end

local function refreshPersistentAdminState()
    if not isAdmin then return false end
    if hasPersistentAdminMode() then
        TriggerServerEvent("UNIQUE_AC:adminState", true, 90000)
        TriggerEvent("UNIQUE_AC:clientGrace", 90000)
    else
        TriggerServerEvent("UNIQUE_AC:adminState", false, 0)
        TriggerEvent("UNIQUE_AC:clientGrace", 5000)
    end
    return true
end

CreateThread(function()
    while true do
        Wait(30000)
        if isAdmin and hasPersistentAdminMode() then
            refreshPersistentAdminState()
        end
    end
end)

RegisterNetEvent("UNIQUE_AC:allowToOpen")
AddEventHandler("UNIQUE_AC:allowToOpen", function(allowed)
    isAdmin = allowed == true

    if isAdmin then
        if pendingAdminMenuOpen then
            pendingAdminMenuOpen = false
            CreateThread(function()
                Wait(0)
                if not IsPauseMenuActive() and not IsNuiFocused() then
                    openAdminMenu()
                end
            end)
        end
        return
    end

    pendingAdminMenuOpen = false
    if InSpectatorMode then exitSpectate() end
    for mode in pairs(adminModes) do adminModes[mode] = false end
    SetEntityInvincible(PlayerPedId(), false)
    SetEntityVisible(PlayerPedId(), true, false)
    SetNightvision(false)
    SetSeethrough(false)
    SetNuiFocus(false, false)
    SendNUIMessage({ action = "forceClose" })
end)

RegisterNetEvent("UNIQUE_AC:sendAllPlayerData")
AddEventHandler("UNIQUE_AC:sendAllPlayerData", function(playerList)
    if not isAdmin then return end
    updatePlayerList(playerList)
end)

RegisterNetEvent("UNIQUE_AC:openPlayerData")
AddEventHandler("UNIQUE_AC:openPlayerData", function(data)
    if not isAdmin then return end
    openPlayerAction(data)
end)

RegisterNetEvent("UNIQUE_AC:spectatePlayer")
AddEventHandler("UNIQUE_AC:spectatePlayer", function(target, coords)
    if not isAdmin then return end
    if target and coords then
        spectatePlayer(target, coords)
    end
end)

RegisterNetEvent("UNIQUE_AC:updateBanListData")
AddEventHandler("UNIQUE_AC:updateBanListData", function(banList, meta)
    if not isAdmin then return end
    updateBanListData(banList, meta)
end)

RegisterNetEvent("UNIQUE_AC:updateAdminData")
AddEventHandler("UNIQUE_AC:updateAdminData", function(adminList, meta)
    if not isAdmin then return end
    updateAdminData(adminList, meta)
end)

RegisterNetEvent("UNIQUE_AC:updateUnbanAccess")
AddEventHandler("UNIQUE_AC:updateUnbanAccess", function(unbanList, meta)
    if not isAdmin then return end
    updateUnbanAccess(unbanList, meta)
end)

RegisterNetEvent("UNIQUE_AC:updateWhiteList")
AddEventHandler("UNIQUE_AC:updateWhiteList", function(whiteList, meta)
    if not isAdmin then return end
    updateWhiteList(whiteList, meta)
end)

RegisterNetEvent("UNIQUE_AC:updateQuarantineList")
AddEventHandler("UNIQUE_AC:updateQuarantineList", function(list)
    if not isAdmin then return end
    updateQuarantineList(list)
end)

RegisterNetEvent("UNIQUE_AC:updatePlayerProfile")
AddEventHandler("UNIQUE_AC:updatePlayerProfile", function(profile)
    if not isAdmin then return end
    SendNUIMessage({ action = "updatePlayerProfile", profile = profile or {} })
end)

RegisterNetEvent("UNIQUE_AC:updateAdminLog")
AddEventHandler("UNIQUE_AC:updateAdminLog", function(log)
    if not isAdmin then return end
    SendNUIMessage({ action = "updateAdminLog", log = log or {} })
end)

RegisterNetEvent("UNIQUE_AC:updateAppeals")
AddEventHandler("UNIQUE_AC:updateAppeals", function(appeals)
    if not isAdmin then return end
    SendNUIMessage({ action = "updateAppeals", appeals = appeals or {} })
end)

RegisterNetEvent("UNIQUE_AC:updateChangelog")
AddEventHandler("UNIQUE_AC:updateChangelog", function(content)
    if not isAdmin then return end
    SendNUIMessage({ action = "updateChangelog", content = content or "" })
end)

RegisterNetEvent("UNIQUE_AC:updateBranding")
AddEventHandler("UNIQUE_AC:updateBranding", function(branding)
    SendNUIMessage({ action = "updateBranding", branding = branding or {} })
end)

RegisterNetEvent("UNIQUE_AC:updateAccessOnlinePlayers")
AddEventHandler("UNIQUE_AC:updateAccessOnlinePlayers", function(scope, players)
    if not isAdmin then return end
    SendNUIMessage({
        action = "updateAccessPlayers",
        scope = scope,
        players = players or {}
    })
end)

RegisterNetEvent("UNIQUE_AC:updateDashboardStats")
AddEventHandler("UNIQUE_AC:updateDashboardStats", function(stats)
    if not isAdmin then return end
    SendNUIMessage({
        action = "updateDashboardStats",
        stats = stats or {}
    })
end)

local function requestAdminMenuOpen()
    if UNIQUE_AC.AdminMenu.Enable ~= true then return end
    if IsPauseMenuActive() or IsNuiFocused() then return end

    if isAdmin then
        if IsPauseMenuActive() or IsNuiFocused() then return end
        openAdminMenu()
        return
    end

    pendingAdminMenuOpen = true
    TriggerServerEvent("UNIQUE_AC:checkIsAdmin")

    SetTimeout(1500, function()
        pendingAdminMenuOpen = false
    end)
end

RegisterCommand("uniqueacmenu", function()
    requestAdminMenuOpen()
end, false)

RegisterCommand("uniqueac", function()
    requestAdminMenuOpen()
end, false)

local function requireAdmin(cb)
    if isAdmin then return true end
    if cb then cb("forbidden") end
    return false
end

RegisterNUICallback("onCloseMenu", function(data, cb)
    SetNuiFocus(false, false)
    cb("ok")
end)

RegisterNUICallback("getAdminStatus", function(data, cb)
    if not requireAdmin(cb) then return end
    updateAdminStatus()
    cb("ok")
end)

RegisterNUICallback("godmode", function(data, cb)
    if not requireAdmin(cb) then return end
    local playerPed = PlayerPedId()
    adminModes.godmode = not GetPlayerInvincible(PlayerId())
    SetEntityInvincible(playerPed, adminModes.godmode)
    refreshPersistentAdminState()
    cb("ok")
end)

RegisterNUICallback("invisible", function(data, cb)
    if not requireAdmin(cb) then return end
    local playerPed = PlayerPedId()
    adminModes.invisible = IsEntityVisible(playerPed)
    SetEntityVisible(playerPed, not adminModes.invisible, false)
    refreshPersistentAdminState()
    cb("ok")
end)

RegisterNUICallback("suicide", function(data, cb)
    if not grantAdminGrace(15000) then cb("forbidden") return end
    SetEntityHealth(PlayerPedId(), 0)
    cb("ok")
end)

RegisterNUICallback("heal", function(data, cb)
    if not grantAdminGrace(10000) then cb("forbidden") return end
    local playerPed = PlayerPedId()
    SetEntityHealth(playerPed, GetPedMaxHealth(playerPed))
    SetPedArmour(playerPed, math.min(GetPedArmour(playerPed), tonumber(UNIQUE_AC.MaxArmor) or 100))
    cb("ok")
end)

RegisterNUICallback("giveAllWeapon", function(data, cb)
    local weapons = { 'WEAPON_UNARMED', 'WEAPON_KNIFE', 'WEAPON_KNUCKLE', 'WEAPON_NIGHTSTICK', 'WEAPON_HAMMER',
        'WEAPON_BAT',
        'WEAPON_GOLFCLUB', 'WEAPON_CROWBAR', 'WEAPON_BOTTLE', 'WEAPON_DAGGER', 'WEAPON_HATCHET', 'WEAPON_MACHETE',
        'WEAPON_FLASHLIGHT', 'WEAPON_SWITCHBLADE', 'WEAPON_PISTOL', 'WEAPON_PISTOL_MK2', 'WEAPON_COMBATPISTOL',
        'WEAPON_APPISTOL', 'WEAPON_PISTOL50', 'WEAPON_SNSPISTOL', 'WEAPON_HEAVYPISTOL', 'WEAPON_VINTAGEPISTOL',
        'WEAPON_STUNGUN', 'WEAPON_FLAREGUN', 'WEAPON_MARKSMANPISTOL', 'WEAPON_REVOLVER', 'WEAPON_MICROSMG', 'WEAPON_SMG',
        'WEAPON_MINISMG', 'WEAPON_SMG_MK2', 'WEAPON_ASSAULTSMG', 'WEAPON_MG', 'WEAPON_COMBATMG', 'WEAPON_COMBATMG_MK2',
        'WEAPON_COMBATPDW', 'WEAPON_GUSENBERG', 'WEAPON_RAYPISTOL', 'WEAPON_MACHINEPISTOL', 'WEAPON_ASSAULTRIFLE',
        'WEAPON_ASSAULTRIFLE_MK2', 'WEAPON_CARBINERIFLE', 'WEAPON_CARBINERIFLE_MK2', 'WEAPON_ADVANCEDRIFLE',
        'WEAPON_SPECIALCARBINE', 'WEAPON_BULLPUPRIFLE', 'WEAPON_COMPACTRIFLE', 'WEAPON_PUMPSHOTGUN',
        'WEAPON_SAWNOFFSHOTGUN',
        'WEAPON_BULLPUPSHOTGUN', 'WEAPON_ASSAULTSHOTGUN', 'WEAPON_MUSKET', 'WEAPON_HEAVYSHOTGUN', 'WEAPON_DBSHOTGUN',
        'WEAPON_SNIPERRIFLE', 'WEAPON_HEAVYSNIPER', 'WEAPON_HEAVYSNIPER_MK2', 'WEAPON_MARKSMANRIFLE',
        'WEAPON_GRENADELAUNCHER', 'WEAPON_GRENADELAUNCHER_SMOKE', 'WEAPON_RPG', 'WEAPON_STINGER', 'WEAPON_FIREWORK',
        'WEAPON_HOMINGLAUNCHER', 'WEAPON_GRENADE', 'WEAPON_STICKYBOMB', 'WEAPON_PROXMINE', 'WEAPON_MINIGUN',
        'WEAPON_RAILGUN', 'WEAPON_POOLCUE', 'WEAPON_BZGAS', 'WEAPON_SMOKEGRENADE', 'WEAPON_MOLOTOV',
        'WEAPON_FIREEXTINGUISHER', 'WEAPON_PETROLCAN', 'WEAPON_SNOWBALL', 'WEAPON_FLARE', 'WEAPON_BALL' }
    if not requireAdmin(cb) then return end
    for _, weapon in ipairs(weapons) do
        GiveWeaponToPed(PlayerPedId(), GetHashKey(weapon), 3000, false, false)
    end
    adminModes.weaponKit = true
    refreshPersistentAdminState()
    cb("ok")
end)

local noclipSpeeds = { 0.6, 1.5, 3.0, 6.0, 12.0 }
local noclipSpeedIndex = 2
local function noclipTick(entity)
    FreezeEntityPosition(entity, true)
    SetEntityInvincible(entity, true)
    SetEntityCollision(entity, false, false)
    SetEntityAlpha(entity, 200, false)
    DisableControlAction(0, 32, true)
    DisableControlAction(0, 33, true)
    DisableControlAction(0, 34, true)
    DisableControlAction(0, 35, true)
    DisableControlAction(0, 22, true)
    DisableControlAction(0, 36, true)

    if IsControlJustPressed(0, 21) then
        noclipSpeedIndex = (noclipSpeedIndex % #noclipSpeeds) + 1
    end

    local moveY, zOff = 0.0, 0.0
    if IsControlPressed(0, 32) then moveY = 1.0 end
    if IsControlPressed(0, 33) then moveY = -1.0 end
    if IsControlPressed(0, 22) then zOff = 1.0 end
    if IsControlPressed(0, 36) then zOff = -1.0 end
    if IsControlPressed(0, 34) then SetEntityHeading(entity, GetEntityHeading(entity) + 2.4) end
    if IsControlPressed(0, 35) then SetEntityHeading(entity, GetEntityHeading(entity) - 2.4) end

    local speed = noclipSpeeds[noclipSpeedIndex]
    if moveY ~= 0.0 or zOff ~= 0.0 then
        local newPos = GetOffsetFromEntityInWorldCoords(entity, 0.0, moveY * speed, zOff * speed)
        SetEntityVelocity(entity, 0.0, 0.0, 0.0)
        SetEntityCoordsNoOffset(entity, newPos.x, newPos.y, newPos.z, true, true, true)
    end
end

RegisterNUICallback("noclip", function(data, cb)
    if not requireAdmin(cb) then return end
    adminModes.noclip = not adminModes.noclip
    if adminModes.noclip then
        CreateThread(function()
            while adminModes.noclip do
                local ped = PlayerPedId()
                local entity = IsPedInAnyVehicle(ped, false) and GetVehiclePedIsIn(ped, false) or ped
                noclipTick(entity)
                Wait(0)
            end
            local ped = PlayerPedId()
            local entity = IsPedInAnyVehicle(ped, false) and GetVehiclePedIsIn(ped, false) or ped
            FreezeEntityPosition(entity, false)
            SetEntityInvincible(entity, adminModes.godmode)
            SetEntityCollision(entity, true, true)
            SetEntityAlpha(entity, 255, false)
        end)
    end
    refreshPersistentAdminState()
    cb("ok")
end)

RegisterNUICallback("superjump", function(data, cb)
    if not requireAdmin(cb) then return end
    adminModes.superjump = not adminModes.superjump
    if adminModes.superjump then
        CreateThread(function()
            while adminModes.superjump do
                Wait(0)
                SetSuperJumpThisFrame(PlayerId())
            end
        end)
    end
    refreshPersistentAdminState()
    cb("ok")
end)

RegisterNUICallback("infiniteStamina", function(data, cb)
    if not requireAdmin(cb) then return end
    adminModes.infiniteStamina = not adminModes.infiniteStamina
    if adminModes.infiniteStamina then
        CreateThread(function()
            while adminModes.infiniteStamina do
                Wait(0)
                RestorePlayerStamina(PlayerPedId(), 1.0)
            end
        end)
    end
    refreshPersistentAdminState()
    cb("ok")
end)

RegisterNUICallback("noRagdoll", function(data, cb)
    if not requireAdmin(cb) then return end
    adminModes.noRagdoll = not adminModes.noRagdoll
    SetPedCanRagdoll(PlayerPedId(), not adminModes.noRagdoll)
    refreshPersistentAdminState()
    cb("ok")
end)

RegisterNUICallback("fastrun", function(data, cb)
    if not requireAdmin(cb) then return end
    adminModes.fastrun = not adminModes.fastrun
    SetRunSprintMultiplierForPlayer(PlayerId(), adminModes.fastrun and 1.6 or 1.0)
    refreshPersistentAdminState()
    cb("ok")
end)

local playerBlipHandles = {}
local function clearPlayerBlips()
    for _, blip in pairs(playerBlipHandles) do
        if DoesBlipExist(blip) then RemoveBlip(blip) end
    end
    playerBlipHandles = {}
end

RegisterNUICallback("playerBlips", function(data, cb)
    if not requireAdmin(cb) then return end
    adminModes.playerBlips = not adminModes.playerBlips
    TriggerServerEvent("UNIQUE_AC:setPlayerBlips", adminModes.playerBlips)
    if not adminModes.playerBlips then clearPlayerBlips() end
    refreshPersistentAdminState()
    cb("ok")
end)

RegisterNetEvent("UNIQUE_AC:updatePlayerBlips")
AddEventHandler("UNIQUE_AC:updatePlayerBlips", function(players)
    if not adminModes.playerBlips then return end
    clearPlayerBlips()
    for _, p in ipairs(players or {}) do
        if p.id ~= GetPlayerServerId(PlayerId()) then
            local blip = AddBlipForCoord(p.x, p.y, p.z)
            SetBlipSprite(blip, 1)
            SetBlipColour(blip, 3)
            SetBlipScale(blip, 0.7)
            SetBlipAsShortRange(blip, true)
            BeginTextCommandSetBlipName("STRING")
            AddTextComponentString(("%s [%s]"):format(p.name or "?", p.id))
            EndTextCommandSetBlipName(blip)
            playerBlipHandles[#playerBlipHandles + 1] = blip
        end
    end
end)

RegisterNUICallback("removeAllWeapon", function(data, cb)
    if not requireAdmin(cb) then return end
    RemoveAllPedWeapons(PlayerPedId(), true)
    adminModes.weaponKit = false
    refreshPersistentAdminState()
    cb("ok")
end)

RegisterNUICallback("getPlayerCoords", function(data, cb)
    if not requireAdmin(cb) then return end
    local playerCoord = GetEntityCoords(PlayerPedId())
    local headingCoord = GetEntityHeading(PlayerPedId())

    playerLocations.coords = playerCoord
    playerLocations.heading = headingCoord

    updatePlayerCoords()

    cb("ok")
end)

RegisterNUICallback("getDashboardStats", function(data, cb)
    if not requireAdmin(cb) then return end
    TriggerServerEvent("UNIQUE_AC:getDashboardStats")
    cb("ok")
end)

RegisterNUICallback("getAllPlayersData", function(data, cb)
    if not requireAdmin(cb) then return end
    TriggerServerEvent("UNIQUE_AC:getAllPlayerData")
    cb("ok")
end)

RegisterNUICallback("getPlayerData", function(data, cb)
    if not requireAdmin(cb) then return end
    TriggerServerEvent("UNIQUE_AC:getPlayerData", tonumber(data and data.playerId))
    cb("ok")
end)

RegisterNUICallback("spectate", function(data, cb)
    if not requireAdmin(cb) then return end
    if InSpectatorMode then
        exitSpectate()
    else
        adminModes.spectate = true
        refreshPersistentAdminState()
        TriggerServerEvent('UNIQUE_AC:requestSpectate', tonumber(data and data.playerId))
    end
    cb("ok")
end)

RegisterNUICallback("ban", function(data, cb)
    if not requireAdmin(cb) then return end
    TriggerServerEvent("UNIQUE_AC:banPlayerByAdmin", tonumber(data and data.playerId),
        tostring(data and data.reason or "Banned by UNIQUE_AC admin menu"),
        tostring(data and data.confirmName or ""))
    cb("ok")
end)

RegisterNUICallback("gotoPlayer", function(data, cb)
    if not grantAdminGrace(90000) then cb("forbidden") return end
    TriggerServerEvent("UNIQUE_AC:TeleportToPlayer", tonumber(data and data.playerId))
    cb("ok")
end)

RegisterNUICallback("bringPlayer", function(data, cb)
    if not grantAdminGrace(120000) then cb("forbidden") return end
    TriggerServerEvent("UNIQUE_AC:BringPlayerToAdmin", tonumber(data and data.playerId))
    cb("ok")
end)

RegisterNUICallback("slapPlayer", function(data, cb)
    if not requireAdmin(cb) then return end
    TriggerServerEvent("UNIQUE_AC:SlapPlayer", tonumber(data and data.playerId))
    cb("ok")
end)

RegisterNUICallback("createRpZone", function(data, cb)
    if not requireAdmin(cb) then return end
    TriggerServerEvent("UNIQUE_AC:createRpZone", tonumber(data and data.radius))
    cb("ok")
end)

RegisterNUICallback("clearMyRpZones", function(data, cb)
    if not requireAdmin(cb) then return end
    TriggerServerEvent("UNIQUE_AC:clearMyRpZones")
    cb("ok")
end)

RegisterNUICallback("kickPlayer", function(data, cb)
    if not requireAdmin(cb) then return end
    TriggerServerEvent("UNIQUE_AC:KickPlayerByAdmin", tonumber(data and data.playerId), tostring(data and data.reason or "Kicked by admin menu"))
    cb("ok")
end)

RegisterNUICallback("addToAdmin", function(data, cb)
    if not requireAdmin(cb) then return end
    TriggerServerEvent("UNIQUE_AC:addPlayerAsAdmin", tonumber(data and data.playerId))
    cb("ok")
end)

RegisterNUICallback("addToWhiteList", function(data, cb)
    if not requireAdmin(cb) then return end
    TriggerServerEvent("UNIQUE_AC:addPlayerAsWhiteList", tonumber(data and data.playerId))
    cb("ok")
end)

RegisterNUICallback("addToUnban", function(data, cb)
    if not requireAdmin(cb) then return end
    TriggerServerEvent("UNIQUE_AC:addPlayerUnbanAccess", tonumber(data and data.playerId))
    cb("ok")
end)

RegisterNUICallback("delete_vehicles", function(data, cb)
    if not requireAdmin(cb) then return end
    TriggerServerEvent("UNIQUE_AC:deleteEntitys", "vehicles")
    cb("ok")
end)

RegisterNUICallback("delete_objects", function(data, cb)
    if not requireAdmin(cb) then return end
    TriggerServerEvent("UNIQUE_AC:deleteEntitys", "props")
    cb("ok")
end)

RegisterNUICallback("delete_peds", function(data, cb)
    if not requireAdmin(cb) then return end
    TriggerServerEvent("UNIQUE_AC:deleteEntitys", "peds")
    cb("ok")
end)

RegisterNUICallback("delete_all_entity", function(data, cb)
    if not requireAdmin(cb) then return end
    TriggerServerEvent("UNIQUE_AC:deleteEntitys", "vehicles")
    TriggerServerEvent("UNIQUE_AC:deleteEntitys", "props")
    TriggerServerEvent("UNIQUE_AC:deleteEntitys", "peds")
    cb("ok")
end)

RegisterNUICallback("teleportToWaypoint", function(data, cb)
    if not grantAdminGrace(15000) then cb("forbidden") return end
    local waypoint = GetFirstBlipInfoId(8)
    if DoesBlipExist(waypoint) then
        local coords = GetBlipInfoIdCoord(waypoint)
        SetEntityCoords(PlayerPedId(), coords.x, coords.y, coords.z, false, false, false, false)
    end
    cb("ok")
end)

RegisterNUICallback("teleportToCoords", function(data, cb)
    if not grantAdminGrace(15000) then cb("forbidden") return end
    local x, y, z = tonumber(data and data.x), tonumber(data and data.y), tonumber(data and data.z)
    if x and y and z and math.abs(x) < 20000 and math.abs(y) < 20000 and math.abs(z) < 5000 then
        SetEntityCoords(PlayerPedId(), x, y, z, false, false, false, false)
    end
    cb("ok")
end)

RegisterNUICallback("night", function(data, cb)
    if not requireAdmin(cb) then return end
    adminModes.night = not GetUsingnightvision()
    SetNightvision(adminModes.night)
    refreshPersistentAdminState()
    cb("ok")
end)

RegisterNUICallback("thermal", function(data, cb)
    if not requireAdmin(cb) then return end
    adminModes.thermal = not GetUsingseethrough()
    SetSeethrough(adminModes.thermal)
    refreshPersistentAdminState()
    cb("ok")
end)

RegisterNUICallback("spawnVehicleForSelf", function(data, cb)
    if not grantAdminGrace(45000) then cb("forbidden") return end
    TriggerServerEvent("UNIQUE_AC:spawnVehicle", data)
    cb("ok")
end)

RegisterNUICallback("spawnVehicleOthers", function(data, cb)
    if not grantAdminGrace(45000) then cb("forbidden") return end
    TriggerServerEvent("UNIQUE_AC:spawnVehicle", data)
    cb("ok")
end)

RegisterNUICallback("repairVehicle", function(data, cb)
    if not grantAdminGrace(30000) then cb("forbidden") return end
    local ped = PlayerPedId()
    local vehicle = GetVehiclePedIsIn(ped, false)
    if vehicle ~= 0 then
        SetVehicleFixed(vehicle)
        SetVehicleDeformationFixed(vehicle)
        SetVehicleDirtLevel(vehicle, 0.0)
    end
    cb("ok")
end)

RegisterNUICallback("cleanVehicle", function(data, cb)
    if not grantAdminGrace(30000) then cb("forbidden") return end
    local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
    if vehicle ~= 0 then SetVehicleDirtLevel(vehicle, 0.0) end
    cb("ok")
end)

RegisterNUICallback("deleteCurrentVehicle", function(data, cb)
    if not grantAdminGrace(30000) then cb("forbidden") return end
    local ped = PlayerPedId()
    local vehicle = GetVehiclePedIsIn(ped, false)
    if vehicle ~= 0 and DoesEntityExist(vehicle) then
        SetEntityAsMissionEntity(vehicle, true, true)
        DeleteVehicle(vehicle)
    end
    cb("ok")
end)

RegisterNUICallback("setVehicleColor", function(data, cb)
    if not grantAdminGrace(30000) then cb("forbidden") return end
    local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
    if vehicle ~= 0 and DoesEntityExist(vehicle) then
        local r = math.max(0, math.min(255, tonumber(data and data.r) or 255))
        local g = math.max(0, math.min(255, tonumber(data and data.g) or 120))
        local b = math.max(0, math.min(255, tonumber(data and data.b) or 24))
        SetVehicleCustomPrimaryColour(vehicle, r, g, b)
        SetVehicleCustomSecondaryColour(vehicle, r, g, b)
    end
    cb("ok")
end)

RegisterNUICallback("maxVehicleMods", function(data, cb)
    if not grantAdminGrace(45000) then cb("forbidden") return end
    local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
    if vehicle ~= 0 and DoesEntityExist(vehicle) then
        SetVehicleModKit(vehicle, 0)
        for modType = 0, 49 do
            local count = GetNumVehicleMods(vehicle, modType)
            if count and count > 0 then
                SetVehicleMod(vehicle, modType, count - 1, false)
            end
        end
        ToggleVehicleMod(vehicle, 18, true)
        SetVehicleFixed(vehicle)
        SetVehicleDirtLevel(vehicle, 0.0)
    end
    cb("ok")
end)

RegisterNUICallback("getBanListData", function(data, cb)
    if not requireAdmin(cb) then return end
    TriggerServerEvent("UNIQUE_AC:getBanListData", data or {})
    cb("ok")
end)

RegisterNUICallback("unbanSelectedPlayer", function(data, cb)
    if not requireAdmin(cb) then return end
    TriggerServerEvent("UNIQUE_AC:unbanSelectedPlayer", tonumber(data and data.banID))
    cb("ok")
end)

RegisterNUICallback("getAdminListData", function(data, cb)
    if not requireAdmin(cb) then return end
    TriggerServerEvent("UNIQUE_AC:getAdminListData", data or {})
    cb("ok")
end)

RegisterNUICallback("removeSelectedAdmin", function(data, cb)
    if not requireAdmin(cb) then return end
    TriggerServerEvent("UNIQUE_AC:removeSelectedAdmin", tonumber(data and data.id))
    cb("ok")
end)

RegisterNUICallback("getUnbanAccessData", function(data, cb)
    if not requireAdmin(cb) then return end
    TriggerServerEvent("UNIQUE_AC:getUnbanAccessData", data or {})
    cb("ok")
end)

RegisterNUICallback("removeUnbanAccess", function(data, cb)
    if not requireAdmin(cb) then return end
    TriggerServerEvent("UNIQUE_AC:removeUnbanAccess", tonumber(data and data.id))
    cb("ok")
end)

RegisterNUICallback("getWhitelistData", function(data, cb)
    if not requireAdmin(cb) then return end
    TriggerServerEvent("UNIQUE_AC:getWhitelistData", data or {})
    cb("ok")
end)

RegisterNUICallback("getAccessOnlinePlayers", function(data, cb)
    if not requireAdmin(cb) then return end
    local scope = tostring(data and data.scope or "")
    if scope == "admins" or scope == "whitelist" then
        TriggerServerEvent("UNIQUE_AC:getAccessOnlinePlayers", scope)
    end
    cb("ok")
end)

RegisterNUICallback("removeWhitelistUser", function(data, cb)
    if not requireAdmin(cb) then return end
    TriggerServerEvent("UNIQUE_AC:removeWhitelistUser", tonumber(data and data.id))
    cb("ok")
end)

RegisterNUICallback("getQuarantineList", function(data, cb)
    if not requireAdmin(cb) then return end
    TriggerServerEvent("UNIQUE_AC:getQuarantineList")
    cb("ok")
end)

RegisterNUICallback("getPlayerProfile", function(data, cb)
    if not requireAdmin(cb) then return end
    TriggerServerEvent("UNIQUE_AC:getPlayerProfile", tonumber(data and data.playerId))
    cb("ok")
end)

RegisterNUICallback("addPlayerNote", function(data, cb)
    if not requireAdmin(cb) then return end
    TriggerServerEvent("UNIQUE_AC:addPlayerNote", tonumber(data and data.playerId), tostring(data and data.note or ""))
    cb("ok")
end)

-- EXPANSION: manual override for the Unique_Login suspicious-device lock.
RegisterNUICallback("clearSecurityHold", function(data, cb)
    if not requireAdmin(cb) then return end
    TriggerServerEvent("UNIQUE_AC:clearSecurityHold", tonumber(data and data.playerId))
    cb("ok")
end)

RegisterNUICallback("getAdminLog", function(data, cb)
    if not requireAdmin(cb) then return end
    TriggerServerEvent("UNIQUE_AC:getAdminLog")
    cb("ok")
end)

RegisterNUICallback("getAppeals", function(data, cb)
    if not requireAdmin(cb) then return end
    TriggerServerEvent("UNIQUE_AC:getAppeals")
    cb("ok")
end)

RegisterNUICallback("getChangelog", function(data, cb)
    if not requireAdmin(cb) then return end
    TriggerServerEvent("UNIQUE_AC:getChangelog")
    cb("ok")
end)

RegisterNUICallback("reviewAppeal", function(data, cb)
    if not requireAdmin(cb) then return end
    TriggerServerEvent("UNIQUE_AC:reviewAppeal", tonumber(data and data.appealId), data and data.approve == true)
    cb("ok")
end)

RegisterNUICallback("quarantineApprove", function(data, cb)
    if not requireAdmin(cb) then return end
    TriggerServerEvent("UNIQUE_AC:quarantineApprove", tonumber(data and data.id))
    cb("ok")
end)

RegisterNUICallback("quarantineRelease", function(data, cb)
    if not requireAdmin(cb) then return end
    TriggerServerEvent("UNIQUE_AC:quarantineRelease", tonumber(data and data.id))
    cb("ok")
end)

function openAdminMenu()
    if not isAdmin then return end
    TriggerServerEvent("UNIQUE_AC:checkIsAdmin")
    TriggerServerEvent("UNIQUE_AC:getBranding")
    SendNUIMessage({
        action = "openUI",
    })
    SetNuiFocus(true, true)
end

function openPlayerAction(data)
    SendNUIMessage({
        action = "openPlayerActionMenu",
        data = data
    })
end

function updateAdminStatus()
    local vision = "Normal"
    if GetUsingseethrough() then
        vision = "Thermal"
    elseif GetUsingnightvision() then
        vision = "Night"
    end
    SendNUIMessage({
        action = "updateAdminStatus",
        godmode = GetPlayerInvincible(PlayerId()),
        visible = IsEntityVisible(PlayerPedId()),
        vision = vision,
        spectate = InSpectatorMode == true,
        noclip = adminModes.noclip == true,
        superjump = adminModes.superjump == true,
        fastrun = adminModes.fastrun == true,
        playerBlips = adminModes.playerBlips == true,
        infiniteStamina = adminModes.infiniteStamina == true,
        noRagdoll = adminModes.noRagdoll == true
    })
end

function updatePlayerCoords()
    SendNUIMessage({
        action = "updatePlayerCoords",
        location = vector4(playerLocations.coords.x, playerLocations.coords.y, playerLocations.coords.z,
            playerLocations.heading),
    })
end

function updatePlayerList(playerList)
    SendNUIMessage({
        action = "updatePlayerList",
        playerList = playerList,
    })
end

function updateBanListData(banList, meta)
    SendNUIMessage({
        action = "updateBanList",
        banList = banList,
        meta = meta or {}
    })
end

function updateAdminData(adminList, meta)
    SendNUIMessage({
        action = "updateAdminData",
        adminList = adminList,
        meta = meta or {}
    })
end

function updateUnbanAccess(unbanList, meta)
    SendNUIMessage({
        action = "updateUnbanAccess",
        unbanList = unbanList,
        meta = meta or {}
    })
end

function updateWhiteList(whiteList, meta)
    SendNUIMessage({
        action = "updateWhiteList",
        whiteList = whiteList,
        meta = meta or {}
    })
end

function updateQuarantineList(list)
    SendNUIMessage({
        action = "updateQuarantineList",
        quarantineList = list or {}
    })
end

function spectatePlayer(target, coords)
    if not isAdmin or type(coords) ~= "vector3" and type(coords) ~= "table" then return end
    local player = GetPlayerFromServerId(tonumber(target) or -1)
    if player == -1 then
        adminModes.spectate = false
        refreshPersistentAdminState()
        return
    end
    local ped = GetPlayerPed(player)
    if ped == 0 or not DoesEntityExist(ped) then
        adminModes.spectate = false
        refreshPersistentAdminState()
        return
    end

    cam = cam or CreateCam('DEFAULT_SCRIPTED_CAMERA', true)
    SetCamCoord(cam, tonumber(coords.x) or 0.0, tonumber(coords.y) or 0.0, tonumber(coords.z) or 0.0)
    SetCamActive(cam, true)
    RenderScriptCams(true, false, 0, true, true)
    Wait(250)

    adminModes.spectate = true
    refreshPersistentAdminState()
    NetworkSetInSpectatorMode(true, ped)
    InSpectatorMode = true
    TargetSpectate = target
    handelSpectate(player, ped)
end

function updateTargetChecks()
    Citizen.CreateThread(function()
        while InSpectatorMode do
            Citizen.Wait(1000)
            if targetPed and targetPed ~= 0 and DoesEntityExist(targetPed) then
                health, maxhealth, armor = GetEntityHealth(targetPed), GetEntityMaxHealth(targetPed), GetPedArmour(targetPed)
                handleVoiceChannel(TargetSpectate)
            end
        end
    end)
end

function handleVoiceChannel(target)
    local channel = tonumber(MumbleGetVoiceChannelFromServerId(target))
    if not channel or channel < 0 or currentVoiceChannel == channel then return end
    if currentVoiceChannel then MumbleRemoveVoiceChannelListen(currentVoiceChannel) end
    currentVoiceChannel = channel
    MumbleAddVoiceChannelListen(channel)
end

function handelSpectate(player, ped)
    Citizen.CreateThread(function()
        targetPed = GetPlayerPed(player)
        updateTargetChecks()

        while InSpectatorMode do
            Citizen.Wait(5)
            local currentPlayer = GetPlayerFromServerId(TargetSpectate or -1)
            if currentPlayer == -1 then
                exitSpectate()
                break
            end
            targetPed = GetPlayerPed(currentPlayer)
            if targetPed == 0 or not DoesEntityExist(targetPed) then
                exitSpectate()
                break
            end
            local coords = GetEntityCoords(targetPed)

            DisableControlAction(2, 37, true)

            if IsControlPressed(2, 241) then
                radius = radius + 2.0
            end

            if IsControlPressed(2, 242) then
                radius = radius - 2.0
            end

            radius = math.max(radius, -1)

            local xMagnitude, yMagnitude = GetDisabledControlNormal(0, 1), GetDisabledControlNormal(0, 2)
            polarAngleDeg, azimuthAngleDeg = polarAngleDeg + xMagnitude * 10, azimuthAngleDeg + yMagnitude * 10

            polarAngleDeg = (polarAngleDeg >= 360) and 0 or polarAngleDeg
            azimuthAngleDeg = (azimuthAngleDeg >= 360) and 0 or azimuthAngleDeg

            local nextCamLocation = polar3DToWorld3D(coords, radius, polarAngleDeg, azimuthAngleDeg)

            SetCamCoord(cam, nextCamLocation.x, nextCamLocation.y, nextCamLocation.z)
            PointCamAtEntity(cam, targetPed)

            if health and maxhealth and armor then
                Draw({
                    'Health' .. ': ~g~' .. health .. '/' .. maxhealth,
                    'Armor' .. ': ~b~' .. armor,
                    "To ~r~ exit ~s~ press spectate button again"
                })
            end
        end
    end)
end

function polar3DToWorld3D(entityPosition, radius, polarAngleDeg, azimuthAngleDeg)
    local polarAngleRad, azimuthAngleRad = polarAngleDeg * math.pi / 180.0, azimuthAngleDeg * math.pi / 180.0

    local pos = {
        x = entityPosition.x + radius * (math.sin(azimuthAngleRad) * math.cos(polarAngleRad)),
        y = entityPosition.y - radius * (math.sin(azimuthAngleRad) * math.sin(polarAngleRad)),
        z = entityPosition.z - radius * math.cos(azimuthAngleRad)
    }

    return pos
end

function Draw(text)
    for i, theText in pairs(text) do
        SetTextFont(0)
        SetTextProportional(1)
        SetTextScale(0.0, 0.30)
        SetTextDropshadow(0, 0, 0, 0, 255)
        SetTextEdge(1, 0, 0, 0, 255)
        SetTextDropShadow()
        SetTextOutline()
        SetTextEntry("STRING")
        AddTextComponentString(theText)
        EndTextCommandDisplayText(0.3, 0.7 + (i / 30))
    end
end

function exitSpectate()
    if not InSpectatorMode then return end
    InSpectatorMode, TargetSpectate, targetPed = false, nil, nil
    adminModes.spectate = false
    NetworkSetInSpectatorMode(false, PlayerPedId())
    RenderScriptCams(false, false, 0, true, true)
    if cam and DoesCamExist(cam) then
        SetCamActive(cam, false)
        DestroyCam(cam, false)
        cam = nil
    end
    if currentVoiceChannel then
        MumbleRemoveVoiceChannelListen(currentVoiceChannel)
        currentVoiceChannel = nil
    end
    refreshPersistentAdminState()
end

Citizen.CreateThread(function()
    while not NetworkIsPlayerActive(PlayerId()) do Wait(500) end
    TriggerServerEvent("UNIQUE_AC:checkIsAdmin")
end)

AddEventHandler("onClientResourceStop", function(resourceName)
    if resourceName ~= GetCurrentResourceName() then return end
    if InSpectatorMode then exitSpectate() end
    SetEntityInvincible(PlayerPedId(), false)
    SetEntityVisible(PlayerPedId(), true, false)
    SetNightvision(false)
    SetSeethrough(false)
    SetNuiFocus(false, false)
end)
