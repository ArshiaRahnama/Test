-- Pub by FleeX Team , https://discord.gg/87rGBxgCsa

PB = PB or {}
PB.state = PB.state or {inMatch = false, mode = nil, map = nil, spectator = false}
PB.HUD = PB.HUD or 'paintball-hud'
PB.coopState = {zombies = {}, lastSpawn = 0, currentMap = nil, shopBlips = {}}

local function clearZombies()
    for _, z in ipairs(PB.coopState.zombies) do
        if z.entity and DoesEntityExist(z.entity) then DeleteEntity(z.entity) end
    end
    PB.coopState.zombies = {}
end

local function clearShopBlips()
    for _, b in ipairs(PB.coopState.shopBlips) do
        if DoesBlipExist(b) then RemoveBlip(b) end
    end
    PB.coopState.shopBlips = {}
end

local function isCoopMode(mode)
    return mode == 'coop' or mode == 'wavedefense' or mode == 'survival'
end

local function spawnBossPed(map, cfg, hp, speed)
    local bossModel = cfg.bossModel or 'u_m_y_juggernaut_01'
    local hash = GetHashKey(bossModel)
    if not IsModelInCdimage(hash) then hash = GetHashKey('s_m_y_blackops_01') end
    ESX.Streaming.RequestModel(hash)
    local spawn = map.zombieSpawns[math.random(#map.zombieSpawns)]
    local ped = CreatePed(4, hash, spawn.x, spawn.y, spawn.z, math.random(0, 359) + 0.0, true, true)
    SetPedRelationshipGroupHash(ped, GetHashKey('AMBIENT_GANG_HILLBILLY'))
    SetEntityMaxHealth(ped, hp)
    SetEntityHealth(ped, hp)
    SetPedArmour(ped, 500)
    SetPedCombatAttributes(ped, 46, true)
    SetPedCombatAttributes(ped, 5, true)
    SetPedCombatAttributes(ped, 1, true)
    SetPedCombatAbility(ped, 100)
    SetPedCombatRange(ped, 3)
    SetPedAccuracy(ped, 50)
    SetPedFleeAttributes(ped, 0, false)
    SetPedAsEnemy(ped, true)
    SetPedConfigFlag(ped, 281, true)
    SetPedMoveRateOverride(ped, speed * 0.7)
    SetPedCanRagdoll(ped, false)
    SetPedSuffersCriticalHits(ped, false)
    GiveWeaponToPed(ped, GetHashKey('WEAPON_MUSKET'), 999, true, true)
    SetPedInfiniteAmmo(ped, true, GetHashKey('WEAPON_MUSKET'))
    TaskCombatHatedTargetsAroundPed(ped, 300.0, 0)
    SetModelAsNoLongerNeeded(hash)
    local blip = AddBlipForEntity(ped)
    SetBlipSprite(blip, 303)
    SetBlipColour(blip, 1)
    SetBlipScale(blip, 1.4)
    SetBlipAsShortRange(blip, false)
    BeginTextCommandSetBlipName('STRING')
    AddTextComponentString('BOSS')
    EndTextCommandSetBlipName(blip)
    return {entity = ped, hp = hp, blip = blip, isBoss = true}
end

RegisterNetEvent('paintball:coopWaveStart', function(payload)
    if not PB.state.inMatch or not isCoopMode(PB.state.mode) then return end
    PB.state.coopWave = payload.wave
    SUN.SendUIData(PB.HUD, {type = 'coopWave', payload = payload})
    local map = paintballConfig.coopMaps[PB.state.map]
    if not map then return end
    local cfg = paintballConfig.gameModes[PB.state.mode]
    if not payload.isHost then return end
    local count = payload.count
    local speed = payload.speed
    local hp = payload.hp
    local zombieModels = cfg.zombieModels
    if payload.boss then
        local entry = spawnBossPed(map, cfg, payload.bossHp or hp * 4, speed)
        if entry then
            PB.coopState.zombies[#PB.coopState.zombies + 1] = entry
            SUN.SendUIData(PB.HUD, {type = 'killstreakBanner', payload = {label = '⚠ BOSS WAVE ⚠', duration = 5}})
        end
    end
    for i = 1, count do
        local model = zombieModels[math.random(#zombieModels)]
        local hash = GetHashKey(model)
        ESX.Streaming.RequestModel(hash)
        local spawn = map.zombieSpawns[math.random(#map.zombieSpawns)]
        local ped = CreatePed(4, hash, spawn.x + math.random(-5, 5), spawn.y + math.random(-5, 5), spawn.z, math.random(0, 359) + 0.0, true, true)
        SetPedRelationshipGroupHash(ped, GetHashKey('AMBIENT_GANG_HILLBILLY'))
        SetEntityMaxHealth(ped, hp)
        SetEntityHealth(ped, hp)
        SetPedCombatAttributes(ped, 46, true)
        SetPedCombatAbility(ped, 100)
        SetPedCombatRange(ped, 2)
        SetPedAccuracy(ped, 5)
        SetPedFleeAttributes(ped, 0, false)
        SetPedAsEnemy(ped, true)
        SetPedConfigFlag(ped, 281, true)
        SetPedMoveRateOverride(ped, speed)
        TaskCombatHatedTargetsAroundPed(ped, 200.0, 0)
        PB.coopState.zombies[#PB.coopState.zombies + 1] = {entity = ped, hp = hp}
        SetModelAsNoLongerNeeded(hash)
        Wait(80)
    end
end)

RegisterNetEvent('paintball:coopWaveEnd', function()
    clearZombies()
    SUN.SendUIData(PB.HUD, {type = 'coopWaveEnd'})
end)

RegisterNetEvent('paintball:coopState', function(state)
    PB.state.coopMoney = state.money or 0
    PB.state.coopWave = state.wave or 0
    SUN.SendUIData(PB.HUD, {type = 'coopState', payload = state})
end)

RegisterNetEvent('paintball:coopRevived', function()
    ESX.notification('success', 'revive shodi')
end)

RegisterNetEvent('paintball:coopShopGrant', function(item)
    if item.type == 'weapon' then
        GiveWeaponToPed(SUN.ped, GetHashKey(item.key), item.ammo or 250, false, false)
        SetCurrentPedWeapon(SUN.ped, GetHashKey(item.key), true)
        PB.state.weapon = item.key
    elseif item.type == 'ammo' then
        local weapon = GetSelectedPedWeapon(SUN.ped)
        AddAmmoToPed(SUN.ped, weapon, item.amount or 60)
    elseif item.type == 'armor' then
        ESX.SetPedArmour(SUN.ped, math.min(100, GetPedArmour(SUN.ped) + (item.amount or 100)))
    elseif item.type == 'health' then
        ESX.SetEntityHealth(SUN.ped, math.min(GetEntityMaxHealth(SUN.ped), GetEntityHealth(SUN.ped) + (item.amount or 100)))
    end
    ESX.notification('success', 'kharidi: '..(item.label or item.key))
end)

local nearShop = nil
local coopRunning = false
local function startCoop()
    if coopRunning then return end
    if not isCoopMode(PB.state.mode) then return end
    coopRunning = true
    CreateThread(function()
        local lastZombieCheck = 0
        local lastBlipCheck = 0
        local lastShopCheck = 0
        while PB.state.inMatch do
            local now = GetGameTimer()
            if PB.state.inMatch and isCoopMode(PB.state.mode) then
                if now - lastZombieCheck > 500 then
                    lastZombieCheck = now
                    for i = #PB.coopState.zombies, 1, -1 do
                        local z = PB.coopState.zombies[i]
                        if not DoesEntityExist(z.entity) or IsPedDeadOrDying(z.entity, true) then
                            if not z.reported then
                                z.reported = true
                                local headshot = IsPedHeadshot(z.entity)
                                TriggerServerEvent('paintball:coopZombieKilled', headshot)
                            end
                            if not DoesEntityExist(z.entity) or (IsPedDeadOrDying(z.entity, true) and z.removeAt and z.removeAt < now) then
                                if z.blip and DoesBlipExist(z.blip) then RemoveBlip(z.blip) end
                                if DoesEntityExist(z.entity) then DeleteEntity(z.entity) end
                                table.remove(PB.coopState.zombies, i)
                            elseif not z.removeAt then
                                z.removeAt = now + 8000
                            end
                        end
                    end
                end

                if now - lastBlipCheck > 2000 then
                    lastBlipCheck = now
                    if PB.coopState.currentMap ~= PB.state.map then
                        clearShopBlips()
                        local map = paintballConfig.coopMaps[PB.state.map]
                        if map and map.shops then
                            for i, shop in ipairs(map.shops) do
                                local blip = AddBlipForCoord(shop.coords.x, shop.coords.y, shop.coords.z)
                                SetBlipSprite(blip, 605)
                                SetBlipDisplay(blip, 4)
                                SetBlipScale(blip, 0.7)
                                SetBlipColour(blip, 17)
                                SetBlipAsShortRange(blip, true)
                                BeginTextCommandSetBlipName('STRING')
                                AddTextComponentString('Shop: '..shop.label)
                                EndTextCommandSetBlipName(blip)
                                PB.coopState.shopBlips[#PB.coopState.shopBlips + 1] = blip
                            end
                        end
                        PB.coopState.currentMap = PB.state.map
                    end
                end

                if now - lastShopCheck > 400 then
                    lastShopCheck = now
                    local map = paintballConfig.coopMaps[PB.state.map]
                    local found = nil
                    if map and map.shops then
                        for i, shop in ipairs(map.shops) do
                            local d = #(SUN.PlayerCoords - shop.coords)
                            if d < 3.0 then found = i break end
                        end
                    end
                    if found ~= nearShop then
                        nearShop = found
                        if found then
                            SUN.SendUIData(PB.HUD, {type = 'coopShopNearby', payload = {shopIndex = found, items = map.shops[found]}})
                        else
                            SUN.SendUIData(PB.HUD, {type = 'coopShopNearby', payload = nil})
                        end
                    end
                end

                Wait(200)
            else
                if #PB.coopState.shopBlips > 0 then
                    clearShopBlips()
                    PB.coopState.currentMap = nil
                end
                nearShop = nil
                Wait(2000)
            end
        end
        coopRunning = false
    end)
end
AddEventHandler('paintball:matchThreads', startCoop)

local function pbCoopExitCleanup()
    if #PB.coopState.shopBlips > 0 then clearShopBlips() end
    PB.coopState.currentMap = nil
    nearShop = nil
end
AddEventHandler('paintball:cleanup', pbCoopExitCleanup)
RegisterNetEvent('paintball:matchEnd', pbCoopExitCleanup)

local lastCoopBuyAt = 0
local COOP_BUY_COOLDOWN = 400

local function tryCoopBuy(shopIndex, itemIndex)
    local now = GetGameTimer()
    if now - lastCoopBuyAt < COOP_BUY_COOLDOWN then return end
    lastCoopBuyAt = now
    TriggerServerEvent('paintball:coopBuy', shopIndex, itemIndex)
end

AddEventHandler('paintball:hud:requestCoopBuy', function(shopIndex, itemIndex)
    tryCoopBuy(shopIndex, itemIndex)
end)

AddEventHandler('sunset_utils:uiCallback:'..PB.HUD, function(action, data)
    if action == 'coopBuy' then
        if data and data.shopIndex and data.itemIndex then
            tryCoopBuy(data.shopIndex, data.itemIndex)
        end
    end
end)

AddEventHandler('onResourceStop', function(resourceName)
    if GetCurrentResourceName() == resourceName then
        clearZombies()
        clearShopBlips()
    end
end)
