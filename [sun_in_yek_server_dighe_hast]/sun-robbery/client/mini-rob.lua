-- Pub by FleeX Team , https://discord.gg/87rGBxgCsa

local threadActive = nil

CreateThread(function()
    while not ESX do Wait(10000) end
    Wait(10000)
    local job = ESX.GetPlayerData().job.name
    ESX.TriggerServerCallback('mrob:getCDs', function(cooldown, gCooldown, activeRob)
        for k, v in pairs(config.rob2) do
            if not v.disabled then
                if v.blip and (not v.hostage or ESX.militaryJobs[job]) then
                    v.blipId = ESX.AddBlipForCoord(v.steps[1].coords.xyz, v.blip.scale, v.blip.sprite, cooldown[k] and 1 or v.blip.color, v.blip.label or v.label)
                    if activeRob[k] and ESX.militaryJobs2[ESX.PlayerData.job.name] then
                        v.pulseId = AddBlipForCoord(v.steps[1].coords.x, v.steps[1].coords.y, v.steps[1].coords.z)
                        SetBlipSprite(v.pulseId, 161)
                        SetBlipScale(v.pulseId, 1.0)
                        SetBlipColour(v.pulseId, 51)
                        PulseBlip(v.pulseId)
                    end
                end
                ESX.RegisterPoint(v.steps[1].coords, 2, {
                    Color = {R = 0,G = 255,B = 0,A = 150},
                    DrawDistance = 5,
                    Radius = {0.5, 0.5, 0.5},
                    Type = 42,
                },{
                    Notification = ('~INPUT_CONTEXT~ Robbery %s'):format(v.label),
                    Key = 'e',
                    world = 0,
                    CB = function()
                        Wait(math.random(10, 50))
                        if ESX.checkCooldown('miniRob', 10000) then
                            if not IsPedInAnyVehicle(PlayerPedId(), false) and not ESX.isDead() and ESX.GetPlayerData().HandCuffed ~= 1  and not ESX.militaryJobs[ESX.PlayerData.job.name] then
                                if exports['gangs']:checkSanction() then
                                    return ESX.chatMessage('Gang shoma nemitavanad rob start konad', 'plarms')
                                end
                                startMiniRobbery(k)
                            end
                        else
                            ESX.chatMessage('In action dar cooldown ast, sabur bashid.', 'plarms')
                        end
                    end,
                },{
                    Out = ESX.UI.Menu.CloseAll
                })
            end
        end
    end)
end)

function startMiniRobbery(k)
    local config = config.rob2[k]
    local partOk = true
    if config.startCheck.robberNeed > 0 then
        local p = promise.new()
        ESX.TriggerServerCallback('Party:GetParty', function(index,data)
            if index[ESX.src] then
                local ind = index[ESX.src]
                local partydata = data[ind]
                local nearParty = 0
                local coords = GetEntityCoords(PlayerPedId())
                for k , v in pairs(partydata) do
                    if ESX.Game.PlayerExist(k) then
                        local distance = #(coords - GetEntityCoords(GetPlayerPed(GetPlayerFromServerId(k))))
                        if distance <= 100 then
                            nearParty += 1
                        end
                    end
                end
                if nearParty >= config.startCheck.robberNeed then
                    partOk = true
                else
                    ESX.chatMessage(('Shoma be %sx party dar nazdiki khod niaz darid'):format(config.startCheck.robberNeed), 'plarms')
                    partOk = false
                end
            else
                partOk = false
                ESX.Alert('Error','Shoma baraye start in robbery bayad dar party bashid',7000,'warning')
            end
            p:resolve()
        end)
        Citizen.Await(p)
    else
        partOk = true
    end
    if not partOk then return end
    ESX.TriggerServerCallback('mrob:getCD', function(cooldown, gCooldown)
        local ts = exports['sunset_utils']:GetServerOSTime()
        if cooldown and cooldown - ts > 0 then
            return ESX.chatMessage(('In robbery ta %s digar cooldown ast'):format(ESX.displayTimeS(cooldown - ts)), 'plarms')
        elseif gCooldown and gCooldown - ts > 0 then
            return ESX.chatMessage(('In robbery ta %s digar global cooldown ast'):format(ESX.displayTimeS(gCooldown - ts)), 'plarms')
        end
        ESX.TriggerServerEvent('mrob:start', k)
    end, k)
end

RegisterNetEvent('mrob:started', function(k, force)
    if ESX.PlayerData.job.name == 'police' or ESX.PlayerData.job.name == 'sheriff' or ESX.PlayerData.job.name == 'mt' or force then
        if config.rob2[k].startCheck.militaryNeed.jobs[1] == 'all' or ESX.tableFind(config.rob2[k].startCheck.militaryNeed.jobs, ESX.PlayerData.job.name) or force then
            if config.rob2[k].pulseId then
                ESX.removeBlip(config.rob2[k].pulseId)
            end
            config.rob2[k].pulseId = AddBlipForCoord(config.rob2[k].steps[1].coords.x, config.rob2[k].steps[1].coords.y, config.rob2[k].steps[1].coords.z)
            SetBlipSprite(config.rob2[k].pulseId, 161)
            SetBlipScale(config.rob2[k].pulseId, 1.0)
            SetBlipColour(config.rob2[k].pulseId, 51)
            PulseBlip(config.rob2[k].pulseId)
        end
    end
    ESX.SetBlipColour(config.rob2[k].blipId, 1)
end)


RegisterNetEvent('mrob:ended', function(k)
    if config.rob2[k].pulseId then
        ESX.removeBlip(config.rob2[k].pulseId)
        config.rob2[k].pulseId = nil
    end
    if ESX.militaryJobs2[ESX.PlayerData.job.name] then
        if #(GetEntityCoords(PlayerPedId()) - config.rob2[k].rangeCheck.coords.xyz) < config.rob2[k].rangeCheck.coords.w then
            ESX.chatMessage(('Robbery %s be payan resid'):format(config.rob2[k].label), 'plarms')
        end
    end
    if threadActive == k then
        threadActive = nil
        if lib.progressActive() then
            lib.cancelProgress()
        end
    end
end)


RegisterNetEvent('mrob:startThread', function(k)
    if not threadActive then
        CreateThread(function()
            threadActive = k
            CreateThread(function()
                lib.progressCircle({
                    duration = config.rob2[k].steps[1].data.passTime,
                    position = 'bottom',
                    -- useWhileDead = false,
                    canCancel = false,
                    allowRagdoll = true,
                    allowFalling = true,
                    disable = {
                    },
                })
            end)
            while threadActive do
                local coords = GetEntityCoords(PlayerPedId())
                local distance = #(coords - config.rob2[k].rangeCheck.coords.xyz)
                if distance > config.rob2[k].rangeCheck.coords.w then
                    ESX.TriggerServerEvent('mrob:cancelRob', k)
                    break
                end
                Wait(1000)
            end
        end)
    end
end)

RegisterNetEvent('mrob:cooldownEnd', function(k)
    ESX.SetBlipColour(config.rob2[k].blipId, 2)
end)

local blipCreated = false
RegisterNetEvent('mrob:show', function()
    if not blipCreated then
        blipCreated = true
        ESX.TriggerServerCallback('mrob:getCDs', function(cooldown, gCooldown, activeRob)
            for k, v in pairs(config.rob2) do
                if not v.disabled then
                    if v.blip and v.hostage then
                        if v.blipId then
                            ESX.removeBlip(v.blipId)
                        end
                        v.blipId = ESX.AddBlipForCoord(v.steps[1].coords.xyz, v.blip.scale, v.blip.sprite, cooldown[k] and 1 or v.blip.color, v.blip.label or v.label)
                        if activeRob[k] and ESX.militaryJobs2[ESX.PlayerData.job.name] then
                            v.pulseId = AddBlipForCoord(v.steps[1].coords.x, v.steps[1].coords.y, v.steps[1].coords.z)
                            SetBlipSprite(v.pulseId, 161)
                            SetBlipScale(v.pulseId, 1.0)
                            SetBlipColour(v.pulseId, 51)
                            PulseBlip(v.pulseId)
                        end
                    end
                end
            end
        end)
    else
        -- blipCreated = false

    end
end)


RegisterNetEvent('mrob:beforeStart', function(k)
    local success = false
    local step = config.rob2[k].steps[1]
    if step.module == 'hack' then
        local p = promise.new()
        if step.data.type == 'var' then
            exports['ps-ui']:VarHack(function(success)
                p:resolve(success)
            end, step.data.block, step.data.time)
        elseif step.data.type == 'thermite' then
            exports['ps-ui']:Thermite(function(success)
                p:resolve(success)
            end, step.data.time, step.data.block, step.data.fail)
        elseif step.data.type == 'maze' then
            exports['ps-ui']:Maze(function(success)
                p:resolve(success)
            end, step.data.time)
        elseif step.data.type == 'scrambler' then
            exports['ps-ui']:Scrambler(function(success)
                p:resolve(success)
            end, step.data.type2, step.data.time, step.data.mirrored)
        end
        success = Citizen.Await(p)
        if not success and not step.ignoreFail then
            return ESX.chatMessage('Hack failed shod.', 'plarms')
        end
    end
    ESX.TriggerServerEvent('mrob:start', k, true)
end)
