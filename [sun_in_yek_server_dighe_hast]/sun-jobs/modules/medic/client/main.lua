-- Pub by FleeX Team , https://discord.gg/87rGBxgCsa

inEvent, isInjure, isDead, extraTimeUsed, signalSended, canCancelSignal, dontDraw, timer, deathId, isAnimPlayed, isCarry = false, false, false, false, false, false, false, nil, 0, false, false
isCrawling = false
medicPauseAnim = false
crawlWorldBlackList = {
    [96] = true,
}
RegisterNetEvent('event', function(bool)
    inEvent = bool
end)

AddEventHandler('capture:inCapture', function(bool)
    inEvent = bool
end)

AddEventHandler('animthread',function(state, disableCrawl)
    isCarry = not state
    medicPauseAnim = not state
    if disableCrawl then
        if exports['sunset_utils']:IsPlayerProne() then
            isCrawling = false
            exports['sunset_utils']:toggleCrawl(true)
        end
    end
end)

CreateThread(function()
    SetPlayerHealthRechargeMultiplier(PlayerId(), 0.0)
    while playerLoaded do Wait(100) end
    -- exports['sunset_target']:AddTargetModel({Shared.ambulance.config.dropBoxModel}, {
    --     options = {
    --         {
    --             icon = 'fas fa-chair',
    --             label = 'باز کردن صندوق',
    --             doesShow = function(entity)
    --                 return Entity(entity).state.inventoryName
    --             end,
    --             cb = function(entity)
	-- 				exports['sun-inventory-hud']:openInventory(Entity(entity).state.inventoryName)
    --             end,
    --         },
    --     },
    --     job = {"all"},
    --     distance = 3.5
    -- })
    ESX.RegisterClientCallback('core:isAlive', function(cb)
        if ESX.GetPlayerData().IsDead or ESX.GetPlayerData().IsInjure or ESX.GetPlayerData().HandCuffed == 1 or LocalPlayer.state.adrenaline then
            return cb(false)
        else
            return cb(true)
        end
    end)
end)

local function disableControlActionThread()
    CreateThread(function()
        while isInjure or isDead do
            Wait(0)
            if isInjure then
                if not isCrawling then
                    disableAction()
                end
                if not dontDraw then
                    if not signalSended then
                        ESX.Game.Utils.DrawText2D('~g~[G](/mg)~s~ Jahat ersal signal ~r~EMS~s~', 0.5, 0.8, 0.4)
                    else
                        if canCancelSignal then
                            ESX.Game.Utils.DrawText2D('~r~[G](/mg)~s~ Jahat cancel signal ~r~EMS~s~', 0.5, 0.8, 0.4)
                        else
                            ESX.Game.Utils.DrawText2D('~g~Medic~s~ dar rah ast', 0.5, 0.8, 0.4)
                        end
                    end
                end
                if isCrawling then
                    ESX.Game.Utils.DrawText2D('~g~[H]~s~ Jahat ~g~khabidan~s~', 0.5, 0.76, 0.4)
                -- else
                --     ESX.Game.Utils.DrawText2D('~g~[H]~s~ Jahat ~o~sine khiz~s~', 0.5, 0.76, 0.4)
                end
            elseif isDead then
                DisableAllControlActions(0)
                EnableControlAction(0, Keys['G'], true)
                EnableControlAction(0, Keys['T'], true)
                EnableControlAction(0, Keys['E'], true)
                ESX.Game.Utils.DrawText2D(('~r~[H]~s~ Force Respawn(~g~$%s~s~)'):format(Shared.ambulance.config.respawnCost), 0.5, 0.8, 0.4)
            end
            if timer and ESX.Math.Round((timer.time - GetGameTimer()) / 1000) > 0 then
                ESX.Game.Utils.DrawText2D(('~o~%s~s~ s ta %s'):format(ESX.Math.Round((timer.time - GetGameTimer()) / 1000), timer.type == 1 and '~r~marg~s~' or '~g~respawn~s~'), 0.5, 0.84, 0.4)
            end
        end
    end)
end

local function startDeathAnimThread()
    local ped = PlayerPedId()
    local coords, heading = GetEntityCoords(ped), GetEntityHeading(ped)

    for k, v in pairs(deadLocaion) do
        local find = false
        for k2, v2 in pairs(v.from) do
            if #(v2.xyz - coords) < v2.w then
                find = true
                if v.to.public then
                    if deadLocaionJob[ESX.PlayerData.job.name] then
                        coords = ESX.getRandomCoordInRadius(v.to.jobs[math.random(1, #v.to.jobs)])
                    else
                        coords = ESX.getRandomCoordInRadius(v.to.public[math.random(1, #v.to.public)])
                    end
                else
                    coords = ESX.getRandomCoordInRadius(v.to[math.random(1, #v.to)])
                end
            end
        end
        if find then break end
    end

    ESX.SetEntityCoordsNoOffset(ped, coords, false, false, false, true)
    NetworkResurrectLocalPlayer(coords.x, coords.y, coords.z, heading, true, false)
    ESX.SetEntityHealth(ped, 149)
    SetPlayerInvincible(ped, false)
    SetPlayerHealthRechargeMultiplier(PlayerId(), 0.0)
    CreateThread(function()
        ESX.Streaming.RequestAnimDict(Shared.ambulance.config.anim.injure.dict, function()
            while isInjure do
                if  not medicPauseAnim then
                    isAnimPlayed = true
                    TaskPlayAnim(ped, Shared.ambulance.config.anim.injure.dict, Shared.ambulance.config.anim.injure.name, 8.0, 0, -1, 1, 1.0, false, false, false)
                elseif medicPauseAnim and isAnimPlayed then
                    isAnimPlayed = false
                    ClearPedTasksImmediately(ped)
                end
                Wait(10)
            end
            ClearPedTasks(ped)
        end)
    end)
end

local function updateStates(dontUpdateState)
    ESX.SetPlayerData('IsInjure', isInjure)
    ESX.SetPlayerData('IsDead', isDead)
    ESX.SetPlayerState('isInjure', isInjure)
    ESX.SetPlayerState('isDead', isDead)
    if not dontUpdateState then
        TriggerServerEvent('medic:setDeathState', isInjure, isDead)
    end
end

local function respawn(coords, fullHP, fullFood, dontUpdateState, byMedic)
    TriggerEvent('antiNonRP:stopReviveThread')
    ESX.SetPlayerState('disableCollision', nil)
    if not dontUpdateState then
        medicResetADR()
    end
    DoScreenFadeOut(500)
    if exports['sunset_utils']:IsPlayerProne() then
        isCrawling = false
        exports['sunset_utils']:toggleCrawl(true)
        Wait(2000)
    end
    ESX.TriggerServerEvent('police:setSCState', false)
    TriggerServerEvent('medic:signalsend', false)
    TriggerServerEvent('medic:removeems2')
    Wait(700)
    local ped = PlayerPedId()
    if not coords then
        coords, heading = GetEntityCoords(ped), GetEntityHeading(ped)
    end
    isDead = false
    isInjure = false
    deathId = nil
    updateStates(dontUpdateState)
    ESX.emoteMenu(true)
    exports['essentialmode']:disablecontrol('x')
    ESX.SetPedArmour(ped, 0)
    ESX.SetEntityCoordsNoOffset(ped, coords, false, false, false, true)
    NetworkResurrectLocalPlayer(coords.x, coords.y, coords.z, coords.w or heading, true, false)
    SetPlayerInvincible(ped, false)
    ClearPedBloodDamage(ped)
    SetPedDiesInWater(ped, true)
    if not fullHP then
        ESX.SetEntityHealth(ped, 149)
    else
        ESX.SetEntityHealth(ped, GetEntityMaxHealth(ped))
    end
    if fullFood then
        TriggerEvent('esx_status:setss', 'hunger', 1000000)
        TriggerEvent('esx_status:setss', 'thirst', 1000000)
    end
    TriggerEvent('core:applyScreenEffect', 'BulletTimeDark', 0)
    DoScreenFadeIn(500)
    if byMedic then
        TriggerEvent('antiNonRP:startReviveThread')
        lib.progressCircle({
            duration = 5000,
            position = 'bottom',
            useWhileDead = false,
            canCancel = false,
            disable = {
                car = true,
                move = true,
                combat = true,
            },
        })
    end
    blockCancelEMS = false
end

local function removeItem()
    if isDead then
        TriggerEvent('antiNonRP:startNewLifeThread')
        ESX.TriggerServerCallback('medic:removeItem', function()
            CreateThread(function()
                for i = 1, 5 do
                    Wait(1000)
                    ESX.TriggerServerCallback('medic:removeItem',nil,true)
                end
            end)
            if exports['sun-robbery']:doesInRob() then
                ESX.TriggerServerEvent('rob:exitRobbery', 'New life')
                Wait(7000)
            end
            local respawnLocation = nil
            for k, v in pairs(Shared.ambulance.config.respawnLocation[ESX.PlayerData.job.name] or Shared.ambulance.config.respawnLocation.all) do
                local distance = #(GetEntityCoords(PlayerPedId()) - v.xyz)
                if not respawnLocation or distance < respawnLocation.distance then
                    respawnLocation = {distance = distance, v = v}
                end
            end
            respawn(respawnLocation.v)
        end)
    end
end

local function deathThread(data, kill, forceDead)
    ESX.UI.Menu.CloseAll()
    if IsPauseMenuActive() then
        SetPauseMenuActive(false)
    end
    medicResetADR()
    TriggerServerEvent('dispatch:setDuty', false)
    isCarry = false
    ESX.SetPlayerState('disableCollision', true)
    if not isInjure and not isDead then
        exports['xsound']:PlayUrl('uwrea', './sounds/death.mp3', 0.05)
        if ESX.GetPlayerData().World == 0 or exports['gangs']:isInGangWorld() then
            TriggerEvent('antiNonRP:setNewLifeData')
        end
        extraTimeUsed, signalSended, canCancelSignal, dontDraw = false, false, false, false
        isInjure = true
        ESX.SetPedArmour(PlayerPedId(), 0)
        exports['sunset_clothe']:unUseByType('bproof')
        TriggerEvent('skinchanger:loadStuff', {bproof_1 = 0, bproof_2 = 0})
        deathId = data.deathId
        ESX.emoteMenu(false)
        exports['essentialmode']:disablecontrol('x', true)
        TriggerEvent('core:applyScreenEffect', 'BulletTimeDark', 0.8, 10)
        SetPedDiesInWater(PlayerPedId(), false)
        if exports['sun-jobs']:notBlackListCoords() and not crawlWorldBlackList[ESX.GetPlayerData().World] and not ESX.militaryJobs2[ESX.PlayerData.job.name] then
            medicPauseAnim, isCrawling = true, true
        end
        disableControlActionThread()
        startDeathAnimThread()
        if not exports['sunset_utils']:IsPlayerProne() and exports['sun-jobs']:notBlackListCoords() and not crawlWorldBlackList[ESX.GetPlayerData().World] and not ESX.militaryJobs2[ESX.PlayerData.job.name] then
            -- Wait(2000)
            exports['sunset_utils']:toggleCrawl(true)
        end
        timer = {
            type = 1,
            time = GetGameTimer() + Shared.ambulance.config.newLifeTimer,
        }
        SetTimeout(Shared.ambulance.config.newLifeTimer, function()
            if isInjure and deathId == data.deathId then
                if extraTimeUsed then
                    SetTimeout(Shared.ambulance.config.extraTimeAdd, function()
                        if isInjure and deathId == data.deathId then
                            deathThread(data, true, true)
                        end
                    end)
                else
                    deathThread(data, true, true)
                end
            end
        end)
    elseif isInjure and not isDead and isCrawling and not forceDead and not crawlWorldBlackList[ESX.GetPlayerData().World] then
        isCrawling = false
        exports['sunset_utils']:toggleCrawl(true)
        medicPauseAnim = false
        local ped = PlayerPedId()
        local coords, heading = GetEntityCoords(ped), GetEntityHeading(ped)
        ESX.SetEntityCoordsNoOffset(ped, coords, false, false, false, true)
        NetworkResurrectLocalPlayer(coords.x, coords.y, coords.z, heading, true, false)
        ESX.SetEntityHealth(ped, 149)
        SetPlayerInvincible(ped, false)
        SetPlayerHealthRechargeMultiplier(PlayerId(), 0.0)
    elseif not isDead then
        if isCrawling then
            isCrawling = false
            exports['sunset_utils']:toggleCrawl(true)
        end
        if ESX.GetPlayerData().World == 97 then
            TriggerEvent('gangprop:addKill', data)
            TriggerEvent('gangprop:pvpNewStuff')
            TriggerServerEvent('gangprop:DropAllItem')
            Wait(3000)
            TriggerEvent('gangprop:tptogang')
            Wait(3000)
            TriggerEvent('medic:revive')
            Wait(1000)
            TriggerEvent('gangprop:pvpNew')
            return
        else
            if data then
                deathId = data.deathId
            end
            isDead = true
            if kill then
                SetEntityHealth(PlayerPedId(), 0)
            end
            isInjure = false
            extraTimeUsed, signalSended, canCancelSignal, dontDraw, isCrawling = false, false, false, false, false
            timer = {
                type = 2,
                time = GetGameTimer() + Shared.ambulance.config.respawnTimer,
            }
            TriggerServerEvent('medic:removeems2')
            SetTimeout(Shared.ambulance.config.respawnTimer, function()
                if isDead and deathId == data.deathId then
                    TriggerEvent('skinchanger:getSkin', function(data)
                        DoScreenFadeOut(1000)
                        Wait(1000)
                        ESX.TriggerServerEvent('medic:copyped', data, ESX.Game.GetPlayersToSend(400))
                        Wait(2000)
                        removeItem()
                    end)
                end
            end)
        end
        if ESX.GetPlayerData().isInIslandZone then
            Wait(3000)
            ExecuteCommand('die')
        end
    end
    updateStates()
end

local function createDropBox()
    local p = promise.new()
    ESX.TriggerServerCallback('medic:createDropBox', function(id)
        p:resolve(id)
    end)
    return Citizen.Await(p)
end

AddEventHandler('esx:onPlayerDeath', function(data)
    if not inEvent and not Shared.ambulance.config.deathIgnoreWorld[ESX.GetPlayerData().World] then
        Wait(1500)
        deathThread(data)
    end
end)

blockCancelEMS = false
RegisterNetEvent('medic:forceEMSRequest', function()
    if ESX.GetPlayerData().isInIslandZone then
        return ESX.chatMessage('Shoma nemitavanid dar jazire darkhast medic bedid', 'plarms')
    end
    blockCancelEMS = true
    signalSended = true
    ESX.ShowNotification('signal ~r~emergency~s~ ersal shod')
    TriggerServerEvent('medic:signalsend', true)
    TriggerServerEvent('medic:sendems', not exports['sun-jobs']:notBlackListCoords())
    exports['sun-phone']:SendLocationEMS()
    SetTimeout(20000, function()
        if isInjure and signalSended then
            canCancelSignal = true
        end
    end)
end)

AddEventHandler('KeyDown:g', function()
    if carry and carry.InProgress then
        return ESX.chatMessage('Shoma nemitavanid dar zaman carry darkhast medic bedid', 'plarms')
    end
    if ESX.GetPlayerData().isInIslandZone then
        return ESX.chatMessage('Shoma nemitavanid dar jazire darkhast medic bedid', 'plarms')
    end
    if isInjure and not signalSended and not ESX.GetPlayerData().isInIslandZone then
        if ESX.GetPlayerData().World == 0 or exports['sun-robbery']:doesInRob() then
            signalSended = true
            ESX.ShowNotification('signal ~r~emergency~s~ ersal shod')
            TriggerServerEvent('medic:signalsend', true)
            TriggerServerEvent('medic:sendems', not exports['sun-jobs']:notBlackListCoords())
            exports['sun-phone']:SendLocationEMS()
            SetTimeout(20000, function()
                if isInjure and signalSended then
                    canCancelSignal = true
                end
            end)
        end
    elseif isInjure and canCancelSignal and not blockCancelEMS then
        ESX.TriggerServerCallback('medic:removeems',function(changed)
            if changed then
                ESX.ShowNotification('Darkhast EMS ~r~cancel~s~ shod')
                dontDraw = true
                canCancelSignal = false
                SetTimeout(20000, function()
                    dontDraw = false
                    signalSended = false
                    TriggerServerEvent('medic:signalsend', false)
                end)
            else
                ESX.ShowNotification('Yek vahed medic darkhast shoma ra accept karde ast')
            end
        end)
    end
end)

RegisterCommand('mg', function()
    TriggerEvent('KeyDown:g')
end)

local crawlCD = false
AddEventHandler('KeyDown:h', function()
    if crawlCD then return end
    SetTimeout(10000, function()
        crawlCD = false
    end)
    crawlCD = true
    if isInjure then
        if isCrawling then
            medicPauseAnim, isCrawling = false, false
            Wait(1000)
            exports['sunset_utils']:toggleCrawl(true)
        end
    elseif isDead then
        if ESX.GetPlayerData().isInIslandZone then
            Wait(3000)
            ExecuteCommand('die')
        else
            if exports['sun-robbery']:doesInRob() or (ESX.GetPlayerData().World == 0 and exports['sun-jobs']:notBlackListCoords()) then
                if timer and ESX.Math.Round((timer.time - GetGameTimer()) / 1000) > 30 then
                    ESX.TriggerServerCallback('medic:removeForceRespawnMoney', function()
                        local boxId = createDropBox()
                        Wait(3000)
                        TriggerEvent('skinchanger:getSkin', function(data)
                            DoScreenFadeOut(1000)
                            Wait(1000)
                            ESX.TriggerServerEvent('medic:copyped', data, ESX.Game.GetPlayersToSend(400), boxId)
                            Wait(2000)
                            removeItem()
                        end)
                    end)
                end
            end
        end
    end
end)

RegisterNetEvent('medic:revive', function(force, ...)
    if isInjure or isDead or force then
        respawn(...)
    end
end)

RegisterNetEvent('medic:revive2', function(...)
    if ESX.GetPlayerData().World ~= 0 then
        TriggerEvent('medic:revive', ...)
    end
end)

RegisterNetEvent('medic:forceNewLife', function()
    if isDead then
        removeItem()
    end
end)

RegisterCommand('extratime', function()
    if isInjure and not extraTimeUsed then
        extraTimeUsed = true
        timer.time = timer.time + Shared.ambulance.config.extraTimeAdd
    end
end, false)

RegisterNetEvent('medic:killMe', function()
    ESX.SetEntityHealth(PlayerPedId(), 99)
    Wait(5000)
    ESX.SetEntityHealth(PlayerPedId(), 99)
    Wait(5000)
    ESX.SetEntityHealth(PlayerPedId(), 99)
end)

RegisterNetEvent('medic:reviveRange', function(src, range)
    if src and range then
        if ESX.Game.doesPlayerExist(src) then
            local distance = #(GetEntityCoords(PlayerPedId()) - GetEntityCoords(GetPlayerPed(GetPlayerFromServerId(src))))
            if distance < range then
                TriggerEvent('medic:revive')
            end
        end
    end
end)

RegisterNetEvent('medic:heal', function(healType, quiet)
	TriggerEvent('antiNonRP:stopReviveThread')
	local playerPed = PlayerPedId()
	local maxHealth = GetEntityMaxHealth(playerPed)

	if healType == 'small' then
		ESX.SetEntityHealth(playerPed, maxHealth)
	elseif healType == 'big' then
		ESX.SetEntityHealth(playerPed, maxHealth)
	end
	-- medicResetADR()
	if not quiet then
		ESX.ShowNotification('Shoma heal shodid')
	end
end)

AddEventHandler('crawl:forceEnd', function()
    if isCrawling then
        medicPauseAnim, isCrawling = false, false
        Wait(1000)
        exports['sunset_utils']:toggleCrawl(true)
    end
end)


RegisterNetEvent('medic:useItem', function(itemName)
    ESX.UI.Menu.CloseAll()

    if itemName == 'medikit' then
        local lib, anim = 'anim@heists@narcotics@funding@gang_idle', 'gang_chatting_idle01' -- TODO better animations
        local playerPed = PlayerPedId()

        ESX.Streaming.RequestAnimDict(lib, function()
            TaskPlayAnim(playerPed, lib, anim, 8.0, -8.0, -1, 0, 0, false, false, false)

            Citizen.Wait(500)
            while IsEntityPlayingAnim(playerPed, lib, anim, 3) do
                Citizen.Wait(0)
                DisableAllControlActions(0)
            end

            TriggerEvent('medic:heal', 'big', true)
        end)

    elseif itemName == 'bandage' then
        local lib, anim = 'anim@heists@narcotics@funding@gang_idle', 'gang_chatting_idle01' -- TODO better animations
        local playerPed = PlayerPedId()

        ESX.Streaming.RequestAnimDict(lib, function()
            TaskPlayAnim(playerPed, lib, anim, 8.0, -8.0, -1, 0, 0, false, false, false)

            Citizen.Wait(500)
            while IsEntityPlayingAnim(playerPed, lib, anim, 3) do
                Citizen.Wait(0)
                DisableAllControlActions(0)
            end

            TriggerEvent('medic:heal', 'small', true)
        end)
    end
end)