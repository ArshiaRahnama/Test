-- Pub by FleeX Team , https://discord.gg/87rGBxgCsa

dummyThreadState = false
damageTestBot = nil
damageTestActive = false
damageTestBlip = nil
damageTestZone = nil
dummyZones = {}
local threadCache = {}
local config = {}
local killCount = 0
local killCountHS = 0
local botModel = `a_m_y_business_01`
local currentPedCoords = nil

local function cleanupMidanTir(message, color)
    dummyThreadState = false
    TriggerEvent('safezone:active', true)
    NetworkSetFriendlyFireOption(true)
    TriggerEvent('chat:addMessage', { color = color or {255, 100, 0}, multiline = true, args = {"Midan Tir", message}})
end

local function cleanupDamageTest(showMessage, message)
    damageTestActive = false
    TriggerEvent('safezone:active', true)
    NetworkSetFriendlyFireOption(true)
    if damageTestZone then
        damageTestZone:remove()
        damageTestZone = nil
    end
    if damageTestBot and DoesEntityExist(damageTestBot) then
        DeleteEntity(damageTestBot)
        damageTestBot = nil
    end
    if damageTestBlip and DoesBlipExist(damageTestBlip) then
        RemoveBlip(damageTestBlip)
        damageTestBlip = nil
    end
    if showMessage then
        TriggerEvent('chat:addMessage', { color = {255, 100, 0}, multiline = true, args = {"Damage Test", message or "Test khamoosh shod"}})
    end
end

local function createDamageTestBot(coords)
    RequestModel(botModel)
    while not HasModelLoaded(botModel) do
        Wait(100)
    end
    local ped = CreatePed(4, botModel, coords.x, coords.y, coords.z - 1.0, coords.w, false, true)
    FreezeEntityPosition(ped, true)
    SetPedCanRagdoll(ped, false)
    SetBlockingOfNonTemporaryEvents(ped, true)
    SetPedFleeAttributes(ped, 0, false)
    SetPedCombatAttributes(ped, 17, true)
    TaskSetBlockingOfNonTemporaryEvents(ped, true)
    SetPedCanBeKnockedOffVehicle(ped, 1)
    SetEntityVisible(ped, true, false)
    SetEntityAlpha(ped, 255, false)
    SetModelAsNoLongerNeeded(botModel)
    return ped
end

local function getPlayerWeapon()
    local playerPed = PlayerPedId()
    local _, weapon = GetCurrentPedWeapon(playerPed, true)
    if not weapon or weapon == 0 then
        weapon = GetSelectedPedWeapon(playerPed)
    end
    return weapon, playerPed
end

local function wasKilledByHeadshot(victimPed)
    local _, boneIndex = GetPedLastDamageBone(victimPed)
    return boneIndex == 31086
end

local function getWeaponDisplayName(hash)
    local name = ESX.GetWeaponFromHash(hash)
    return name and name.label or "Unknown"
end

local function DrawDamageText(text)
    SetTextFont(4)
    SetTextScale(0.6, 0.6)
    SetTextProportional(1)
    SetTextColour(255, 100, 100, 215)
    SetTextEntry("STRING")
    SetTextCentre(1)
    AddTextComponentString(text)
    DrawText(0.5, 0.85)
end

CreateThread(function()
    waitForLoad()
    for k, v in pairs(dummyConfig) do
        createLocalPed(4, `s_m_y_armymech_01`, v.pedCoords - vec(0, 0, 1, 0), function(ped)
            SetEntityAsMissionEntity(ped)
            SetBlockingOfNonTemporaryEvents(ped, true)
            FreezeEntityPosition(ped, true)
            SetEntityInvincible(ped, true)

            local menuOptions = {
                {label = ('%s$ Pool'):format(ESX.Math.GroupDigits(dummyPrice.money)), args = {type = 1}},
                {label = ('%s TC'):format(dummyPrice.tc), args = {type = 2}},
            }

            exports['ox_target']:addLocalEntity({ped}, {
                {
                    name = 'tir',
                    label = 'خرید بلیط میدان تیر',
                    onSelect = function()
                        if SUN.world ~= 0 then return end
                        if not dummyZones[k] then
                            dummyZones[k] = lib.zones.sphere({
                                coords = v.activeCoords.xyz,
                                radius = v.activeCoords.w,
                                onExit = function()
                                    if dummyThreadState then
                                        cleanupMidanTir("Az zone kharej shodid")
                                    end
                                end
                            })
                        end
                        lib.registerMenu({
                            id = 'dummy',
                            title = 'Az kodam ravesh hazine ra pardakht mikonid?',
                            options = menuOptions
                        }, function(_, _, args)
                            ESX.TriggerServerCallback('dummy:buy', function(result)
                                if result then
                                    if damageTestActive then
                                        cleanupDamageTest(true, "Damage test khamoosh shod")
                                    end
                                    NetworkSetFriendlyFireOption(false)
                                    ESX.TriggerServerCallback('dummy:getKillCount', function(kill, killHS)
                                        killCount, killCountHS = kill, killHS
                                        startDummyThread(k)
                                    end)
                                end
                            end, args)
                        end)
                        ESX.registerExitPoint(5)
                        lib.showMenu('dummy')
                    end,
                },
                {
                    name = 'damagetest',
                    label = 'تست دمیج گان',
                    onSelect = function()
                        if SUN.world ~= 0 then return end
                        lib.registerMenu({
                            id = 'damagetest',
                            title = 'Az kodam ravesh hazine ra pardakht mikonid?',
                            options = menuOptions
                        }, function(_, _, args)
                            ESX.TriggerServerCallback('dummy:buyDamageTest', function(result)
                                if result then
                                    if dummyThreadState then
                                        cleanupMidanTir("Midan tir khamoosh shod")
                                    end
                                    startDamageTest(k)
                                end
                            end, args)
                        end)
                        ESX.registerExitPoint(5)
                        lib.showMenu('damagetest')
                    end,
                },
                {
                    name = 'deactivate',
                    label = 'غیر فعال کردن',
                    onSelect = function()
                        if dummyThreadState then
                            cleanupMidanTir("Midan tir khamoosh shod", {255, 0, 0})
                        elseif damageTestActive then
                            cleanupDamageTest(true)
                        else
                            TriggerEvent('chat:addMessage', { color = {255, 165, 0}, multiline = true, args = {"System", "Hich kodam fa'al nist"}})
                        end
                    end,
                },
            })
        end, function(ped)
            exports['ox_target']:removeLocalEntity(ped)
        end)
    end
end)

function startDummyThread(k)
    if dummyThreadState then
        TriggerEvent('chat:addMessage', {color = {255, 165, 0}, multiline = true, args = {"Midan Tir", "Ghablan fa'al shode"}})
        return
    end

    TriggerEvent('safezone:active', false)
    dummyThreadState = true
    TriggerEvent('chat:addMessage', {color = {0, 255, 0}, multiline = true, args = {"Midan Tir", "Fa'al shod"}})

    config = dummyConfig[k]
    threadCache = {dummyList = {}, fakeList = {}}

    CreateThread(function()
        while dummyThreadState do
            Wait(100)
            if getDummyAliveCount() < config.dummyCount then
                createDummy()
            end
            for i, v in pairs(threadCache.dummyList) do
                if v.delete then
                    DeleteEntity(v.ped)
                    table.remove(threadCache.dummyList, i)
                elseif DoesEntityExist(v.ped) and IsPedDeadOrDying(v.ped) then
                    if dummyThreadState then
                        local hs = wasKilledByHeadshot(v.ped)
                        killCount += 1
                        if hs then killCountHS += 1 end
                        ESX.TriggerServerEvent('dummy:kill', hs)
                    end
                    SetTimeout(10000, function() DeleteEntity(v.ped) end)
                    table.remove(threadCache.dummyList, i)
                end
            end
            ESX.ShowMissionText(('~y~%s kill, HS %s%%'):format(killCount, killCountHS > 0 and ESX.Math.Round(killCountHS / killCount * 100, 2) or 0))
        end
        if not damageTestActive then
            TriggerEvent('safezone:active', true)
        end
        for _, v in pairs(threadCache.dummyList) do DeleteEntity(v.ped) end
        for _, v in pairs(threadCache.fakeList) do DeleteEntity(v) end
        threadCache = {}
    end)
end

function getDummyAliveCount()
    local count = 0
    if threadCache and threadCache.dummyList then
        for _, v in pairs(threadCache.dummyList) do
            if not IsPedDeadOrDying(v.ped) then count += 1 end
        end
    end
    return count
end

function createDummy()
    local model = config.models[math.random(1, #config.models)]
    local coords = config.coords[math.random(1, #config.coords)]
    local ped = ESX.Game.SpawnLocalPed(1, model, coords[1].xyz - vec(0, 0, 1), coords[1].w)
    SetBlockingOfNonTemporaryEvents(ped, true)
    if coords[2] then
        TaskGoStraightToCoord(ped, coords[2].xyz, 3.0, -1, 0.0, 0.0)
        SetTimeout((#(coords[2].xyz - coords[1].xyz) / 6.0) * 1000, function()
            if threadCache.dummyList then
                for _, v in pairs(threadCache.dummyList) do
                    if v.ped == ped then v.delete = true end
                end
            end
        end)
    end
    table.insert(threadCache.dummyList, {ped = ped, coords = coords})
end

function startDamageTest(k)
    if damageTestActive then
        TriggerEvent('chat:addMessage', {color = {255, 165, 0}, multiline = true, args = {"Damage Test", "Ghablan fa'al shode"}})
        return
    end

    damageTestActive = true
    currentPedCoords = dummyConfig[k].pedTestCoords
    local rangeCoords = dummyConfig[k].rangeTestCoords

    TriggerEvent('safezone:active', false)
    NetworkSetFriendlyFireOption(false)
    TriggerEvent('chat:addMessage', {color = {0, 255, 0}, multiline = true, args = {"Damage Test", "Fa'al shod"}})

    damageTestBot = createDamageTestBot(currentPedCoords)

    local camStart, camEnd = dummyConfig[k].camTestStart, dummyConfig[k].camTestEnd
    local cam1 = CreateCamWithParams("DEFAULT_SCRIPTED_CAMERA", camStart.x, camStart.y, camStart.z, 0.0, 0.0, camStart.w, 50.0, false, 0)
    local cam2 = CreateCamWithParams("DEFAULT_SCRIPTED_CAMERA", camEnd.x, camEnd.y, camEnd.z, 0.0, 0.0, camEnd.w, 50.0, false, 0)
    PointCamAtCoord(cam1, currentPedCoords.x, currentPedCoords.y, currentPedCoords.z)
    PointCamAtCoord(cam2, currentPedCoords.x, currentPedCoords.y, currentPedCoords.z)
    SetCamActive(cam1, true)
    RenderScriptCams(true, false, 0, true, true)
    Wait(500)
    SetCamActiveWithInterp(cam2, cam1, 3000, 1, 1)
    Wait(3500)
    RenderScriptCams(false, true, 1000, true, true)
    DestroyCam(cam1, false)
    DestroyCam(cam2, false)

    damageTestBlip = AddBlipForCoord(currentPedCoords.x, currentPedCoords.y, currentPedCoords.z)
    SetBlipSprite(damageTestBlip, 1)
    SetBlipColour(damageTestBlip, 1)
    SetBlipScale(damageTestBlip, 0.9)
    SetBlipAsShortRange(damageTestBlip, true)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString("Damage Test Bot")
    EndTextCommandSetBlipName(damageTestBlip)

    if damageTestZone then damageTestZone:remove() end
    damageTestZone = lib.zones.sphere({
        coords = rangeCoords.xyz,
        radius = rangeCoords.w,
        onExit = function()
            if damageTestActive then
                cleanupDamageTest(true, "Az zone kharej shodid")
            end
        end
    })

    local displayText, displayTime = "", 0

    CreateThread(function()
        while damageTestActive do
            Wait(0)
            if displayText ~= "" then
                DrawDamageText(displayText)
                if GetGameTimer() - displayTime > 2000 then displayText = "" end
            end
        end
    end)

    CreateThread(function()
        local lastHealth = 200
        while damageTestActive do
            Wait(50)
            if damageTestBot and DoesEntityExist(damageTestBot) then
                if IsEntityDead(damageTestBot) then
                    local weapon, playerPed = getPlayerWeapon()
                    local offset = weaponDamageOffset[weapon] or 0
                    local distance = math.floor(#(GetEntityCoords(playerPed) - GetEntityCoords(damageTestBot)) + 0.5)
                    displayText = string.format("~r~KILLED~w~ | ~y~%dm~w~\n%s | %d DMG", distance, getWeaponDisplayName(weapon), lastHealth - offset)
                    displayTime = GetGameTimer()
                    DeleteEntity(damageTestBot)
                    damageTestBot = nil
                    Wait(500)
                    if damageTestActive then
                        damageTestBot = createDamageTestBot(currentPedCoords)
                        lastHealth = 200
                    end
                else
                    local currentHealth = GetEntityHealth(damageTestBot)
                    if currentHealth < lastHealth and currentHealth > 0 then
                        local npcDamage = lastHealth - currentHealth
                        local weapon, playerPed = getPlayerWeapon()
                        local offset = weaponDamageOffset[weapon] or 0
                        local distance = math.floor(#(GetEntityCoords(playerPed) - GetEntityCoords(damageTestBot)) + 0.5)
                        displayText = string.format("~o~%d DMG~w~ | ~y~%dm~w~\n%s", npcDamage - offset, distance, getWeaponDisplayName(weapon))
                        displayTime = GetGameTimer()
                        SetEntityHealth(damageTestBot, GetEntityMaxHealth(damageTestBot))
                        lastHealth = GetEntityMaxHealth(damageTestBot)
                    else
                        lastHealth = currentHealth
                    end
                end
            end
        end
        if damageTestBot and DoesEntityExist(damageTestBot) then DeleteEntity(damageTestBot) damageTestBot = nil end
        if damageTestBlip and DoesBlipExist(damageTestBlip) then RemoveBlip(damageTestBlip) damageTestBlip = nil end
    end)
end
