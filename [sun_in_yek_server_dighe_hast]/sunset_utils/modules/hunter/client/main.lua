-- Pub by FleeX Team , https://discord.gg/87rGBxgCsa

local inJob = false
local antiSpam = false
local areaBlip = 0
local animals = {}
local chancePet = {}
local chanceAttacker = {}
local lastWeapon = 0
local fakeAnimals = {}
local fakeAnimalCount = 100
Citizen.CreateThread(function()
	while ESX == nil do
		Citizen.Wait(0)
    end

    for k , v in pairs(ConfigHunter.animals) do
        for i = 1 , v.chance do
            if v.attacker then
                table.insert(chanceAttacker,k)
            else
                table.insert(chancePet,k)
            end
        end
    end

    ESX.AddBlipForCoord(ConfigHunter.startPos,0.8,442,51,'Mantaghe shekar')
    ESX.AddBlipForCoord(ConfigHunter.slaughterPos,0.8,463,33,'Ghasabi(Shekar)')
    -- ESX.AddBlipForCoord(ConfigHunter.sellerPos,1.5,463,33,'Forushgah(Shekar)')
    ESX.RegisterPoint(ESX.zGround(ConfigHunter.startPos),2,{
        Color = {R = 255,G = 165,B = 0,A = 255},
        DrawDistance = 20,
        Radius = 0.5,
        Type = 27
    },{
        Notification = nil,
        DrawText = 'Dokme ~INPUT_CONTEXT~ jahat baz kardan menu job(Shekarchi)',
        DrawTextRadius = 4,
        DrawTextCoords = ConfigHunter.startPos,
        Key = 'e',
        world = 0,
        CB = function()
            local gotWeapon = false
            for k,v in pairs(ConfigHunter.allowWeapons) do
                if HasPedGotWeapon(PlayerPedId(),k) and k ~= `weapon_musket` then
                    gotWeapon = true
                    lastWeapon = k
                    break
                end
            end
            if gotWeapon then
                if antiSpam then return  ESX.Alert('Error','Shoma faghat har 30 sanie yek bar mitavanid on/off duty konid!',10000,'error') end
                exports['esx_jobs']:openMenu('hunter')
            else
                ESX.Alert('Error','Baraye start job shoma niaz be knife darid!',10000,'error')
            end
        end,
    },{
        In = nil,
        Out = ESX.UI.Menu.CloseAll
    })

    ESX.RegisterPoint(ESX.zGround(ConfigHunter.slaughterPos),2,{
        Color = {R = 255,G = 165,B = 0,A = 255},
        DrawDistance = 20,
        Radius = 0.5,
        Type = 0
    },{
        Notification = nil,
        DrawText = 'Dokme ~INPUT_CONTEXT~ jahat baz kardan menu ghasabi(Shekarchi)',
        DrawTextRadius = 4,
        DrawTextCoords = ConfigHunter.slaughterPos,
        Key = 'e',
        world = 0,
        CB = function()
            local inventory = ESX.GetPlayerData().inventory
            local elements = {}
            for k,v in pairs(inventory) do
                local name = v.name:lower()
                if ConfigHunter.slaughter[name] and v.count > 0 then
                    table.insert(elements,{label = v.label,value = v.name})
                end
            end
            if #elements == 0 then return ESX.Alert('Error','Shoma itemi baraye zebh kardan nadarid!',10000,'error') end
            ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'slgh', {
                title    = 'Kodam ra zebh mikonid?',
                align    = 'top-left',
                elements = elements
            }, function(data, menu)
                menu.close()
                TriggerEvent("mythic_progbar:client:progress", {
                    name = 'slgh',
                    duration = ConfigHunter.slaughterTime * 1000,
                    label = 'Dar hale zebh kardan',
                    useWhileDead = false,
                    canCancel = true,
                    controlDisables = {
                        disableMovement = true,
                        disableCarMovement = true,
                        disableMouse = false,
                        disableCombat = true,
                    },
                    animation = {
                        animDict = "amb@prop_human_bum_bin@idle_a",
                        anim = "idle_a",
                    }
                }, function(status)
                    if not status then
                        ESX.TriggerServerEvent('hunter:slaughter',data.current.value)
                    elseif status then
                        ClearPedTasksImmediately(PlayerPedId())
                    end
                end)
            end, function(data, menu)
                menu.close()
            end)
        end,
    },{
        In = nil,
        Out = ESX.UI.Menu.CloseAll
    })

end)

local function findCoords()
    local pos = ConfigHunter.areaPos.xyz
    local radius = ConfigHunter.areaPos.w - 50
    pos = vector3(pos.x + math.random(-radius,radius),pos.y + math.random(-radius,radius),pos.z)
    return pos
end

local function teleport(ped,coord)
    local coordZ = 0
    local height = 300.0

    local foundGround = false
    repeat
        Wait(10)
        ESX.SetEntityCoords(ped, coord.x, coord.y, height)

        foundGround, z = GetGroundZFor_3dCoord(coord.x, coord.y, height)
        coordZ = z + 1
        height = height - 1.0
    until foundGround or height < -100

    if not foundGround then
        coordZ = coord.z
    end

    ESX.SetEntityCoords(ped, coord.x, coord.y, coordZ)
end

local function mainThread()
    Citizen.CreateThread(function()
        local viewRange = exports['sunset_utils']:doesSkillCompleted('hunting_skill') and 180 or 140
        while inJob do
            Citizen.Wait(1000)
            if IsPedInAnyVehicle(PlayerPedId()) then
                TaskLeaveVehicle(PlayerPedId(), GetVehiclePedIsIn(PlayerPedId()), 16)
            end
            if not HasPedGotWeapon(PlayerPedId(),`weapon_musket`) then
                TriggerEvent('esx:addWeapon','weapon_musket', 250)
            end
            local pedExist = nil
            local attackerExist = nil
            for k,v in pairs(animals) do
                if DoesEntityExist(v.ped) and not v.deadCheck then
                    if not v.attacker then
                        pedExist = v
                    else
                        attackerExist = v
                        if IsPedDeadOrDying(v.ped) then
                            v.deadCheck = true
                        end
                    end
                end
            end
            if not pedExist then
                local coords = findCoords()
                local modelKey = chancePet[math.random(1,#chancePet)]
                local modelData = ConfigHunter.animals[modelKey]
                ESX.Streaming.RequestModel(modelKey)
                local ped = ESX.Game.SpawnLocalPed(5,modelKey,coords,0.0)
                teleport(ped,coords)
                TaskWanderStandard(ped,10,10.0)
                table.insert(animals,{ped = ped,attacker = false,blip = 0})
                local spawnAttackerChance = math.random(1,100)
                if attackerExist and not DoesEntityExist(attackerExist.ped) then
                    DeleteEntity(attackerExist.ped)
                    attackerExist.deadThread = false
                    attackerExist = nil
                end
                if spawnAttackerChance <= ConfigHunter.spawnAttackerChance and not attackerExist then
                    local coords = findCoords()
                    local modelKey = chanceAttacker[math.random(1,#chanceAttacker)]
                    local modelData = ConfigHunter.animals[modelKey]
                    ESX.Streaming.RequestModel(modelKey)
                    local ped = ESX.Game.SpawnLocalPed(5,modelKey,coords,0.0)
                    teleport(ped,coords)
                    table.insert(animals,{ped = ped,attacker = true})
                    Citizen.Wait(1000)
                    SetBlockingOfNonTemporaryEvents(ped,true)
                    SetPedSeeingRange(ped,400.0)
                    TaskCombatPed(ped, PlayerPedId())
                    SetPedAccuracy(ped, 100)
                    TaskGoToEntity(ped, PlayerPedId(), 100000,4.0, 100, 0)
                end
            else
                if HasEntityClearLosToEntity(PlayerPedId(),pedExist.ped,17) and ESX.GetDistance(GetEntityCoords(PlayerPedId()),GetEntityCoords(pedExist.ped)) < viewRange then
                    if not pedExist.blip or not DoesBlipExist(pedExist.blip) then
                        pedExist.blip = AddBlipForEntity(pedExist.ped)
                        SetBlipSprite(pedExist.blip, 442)
                        ShowHeadingIndicatorOnBlip(pedExist.blip, true)
                        SetBlipNameToPlayerName(pedExist.blip, id)
                        SetBlipScale(pedExist.blip, 0.85)
                        SetBlipColour(pedExist.blip, 2)
                        SetBlipAsShortRange(pedExist.blip, true)
                        BeginTextCommandSetBlipName("STRING")
                        AddTextComponentString('Animal')
                        EndTextCommandSetBlipName(pedExist.blip)
                    end
                elseif DoesBlipExist(pedExist.blip) then
                    RemoveBlip(pedExist.blip)
                end
                if IsPedDeadOrDying(pedExist.ped) and not pedExist.deadThread then
                    local deatchCause = GetPedCauseOfDeath(pedExist.ped)
                    if ConfigHunter.allowWeapons[deatchCause] then
                        pedExist.deadThread = true
                        Citizen.CreateThread(function()
                            while DoesEntityExist(pedExist.ped) and pedExist.deadThread do
                                Citizen.Wait(0)
                                local coords = GetEntityCoords(pedExist.ped)
                                local distance = ESX.GetDistance(GetEntityCoords(PlayerPedId()),GetEntityCoords(pedExist.ped))
                                DrawLine(GetEntityCoords(PlayerPedId()),coords, 255,165,0,255)
                                if distance < 4 then
                                    ESX.Game.Utils.Draw3D(coords,'[E] jahat loot kardan')
                                    if IsControlJustReleased(0,38) then
                                        ESX.Streaming.RequestAnimDict('amb@medic@standing@kneel@base')
                                        ESX.Streaming.RequestAnimDict('anim@gangops@facility@servers@bodysearch@')
                                        SetCurrentPedWeapon(PlayerPedId(),lastWeapon,false)
                                        Citizen.Wait(2000)
                                        TaskPlayAnim(PlayerPedId(), "amb@medic@standing@kneel@base" ,"base" ,8.0, -8.0, -1, 1, 0, false, false, false )
	                                    TaskPlayAnim(PlayerPedId(), "anim@gangops@facility@servers@bodysearch@" ,"player_search" ,8.0, -8.0, -1, 48, 0, false, false, false )
                                        local next = promise.new()
                                        TriggerEvent("mythic_progbar:client:progress", {
                                            name = 'loot',
                                            duration = ConfigHunter.lootTime * 1000,
                                            label = 'Dar hale loot kardan',
                                            useWhileDead = false,
                                            canCancel = true,
                                            controlDisables = {
                                                disableMovement = true,
                                                disableCarMovement = true,
                                                disableMouse = false,
                                                disableCombat = true,
                                            },
                                        }, function(status)
                                            if not status then
                                                ESX.TriggerServerEvent('hunter:loot',GetEntityModel(pedExist.ped))
                                                ClearPedTasksImmediately(PlayerPedId())
                                                DeleteEntity(pedExist.ped)
                                                pedExist.deadThread = false
                                                next:resolve(true)
                                            elseif status then
                                                ClearPedTasksImmediately(PlayerPedId())
                                                next:resolve(false)
                                            end
                                        end)
                                        Citizen.Await(next)
                                    end
                                end
                            end
                            pedExist = nil
                        end)
                    else
                        DeleteEntity(pedExist.ped)
                        pedExist.deadThread = false
                        pedExist = nil
                    end
                end
                if attackerExist and IsPedDeadOrDying(attackerExist.ped) and not attackerExist.deadThread then
                    local deatchCause = GetPedCauseOfDeath(attackerExist.ped)
                    if ConfigHunter.allowWeapons[deatchCause] then
                        attackerExist.deadThread = true
                        Citizen.CreateThread(function()
                            while DoesEntityExist(attackerExist.ped) and attackerExist.deadThread do
                                Citizen.Wait(0)
                                local coords = GetEntityCoords(attackerExist.ped)
                                local distance = ESX.GetDistance(GetEntityCoords(PlayerPedId()),GetEntityCoords(attackerExist.ped))
                                DrawLine(GetEntityCoords(PlayerPedId()),coords, 255,165,0,255)
                                if distance < 4 then
                                    ESX.Game.Utils.Draw3D(coords,'[E] jahat loot kardan')
                                    if IsControlJustReleased(0,38) then
                                        ESX.Streaming.RequestAnimDict('amb@medic@standing@kneel@base')
                                        ESX.Streaming.RequestAnimDict('anim@gangops@facility@servers@bodysearch@')
                                        SetCurrentPedWeapon(PlayerPedId(),lastWeapon,false)
                                        Citizen.Wait(2000)
                                        TaskPlayAnim(PlayerPedId(), "amb@medic@standing@kneel@base" ,"base" ,8.0, -8.0, -1, 1, 0, false, false, false )
	                                    TaskPlayAnim(PlayerPedId(), "anim@gangops@facility@servers@bodysearch@" ,"player_search" ,8.0, -8.0, -1, 48, 0, false, false, false )
                                        local next = promise.new()
                                        TriggerEvent("mythic_progbar:client:progress", {
                                            name = 'loot',
                                            duration = ConfigHunter.lootTime * 1000,
                                            label = 'Dar hale loot kardan',
                                            useWhileDead = false,
                                            canCancel = true,
                                            controlDisables = {
                                                disableMovement = true,
                                                disableCarMovement = true,
                                                disableMouse = false,
                                                disableCombat = true,
                                            },
                                        }, function(status)
                                            if not status then
                                                ESX.TriggerServerEvent('hunter:loot',GetEntityModel(attackerExist.ped))
                                                ClearPedTasksImmediately(PlayerPedId())
                                                DeleteEntity(attackerExist.ped)
                                                attackerExist.deadThread = false
                                                next:resolve(true)
                                            elseif status then
                                                ClearPedTasksImmediately(PlayerPedId())
                                                next:resolve(false)
                                            end
                                        end)
                                        Citizen.Await(next)
                                    end
                                end
                            end
                            attackerExist = nil
                        end)
                    else
                        DeleteEntity(attackerExist.ped)
                        attackerExist.deadThread = false
                        attackerExist = nil
                    end
                end
            end
            if pedExist then
                local distance = ESX.GetDistance(ConfigHunter.areaPos.xyz,GetEntityCoords(pedExist.ped))
                if distance > ConfigHunter.areaPos.w then
                    DeleteEntity(pedExist.ped)
                    pedExist.deadThread = false
                    pedExist = nil
                end
            end
            if attackerExist then
                TaskCombatPed(attackerExist.ped, PlayerPedId())
                local distance = ESX.GetDistance(ConfigHunter.areaPos.xyz,GetEntityCoords(attackerExist.ped))
                if distance > ConfigHunter.areaPos.w then
                    DeleteEntity(attackerExist.ped)
                    attackerExist.deadThread = false
                    attackerExist = nil
                end
            end
            if #fakeAnimals < fakeAnimalCount then
                for i = 1, fakeAnimalCount do
                    local ped = ESX.Game.SpawnLocalPed(5, 'a_c_cow', findCoords(), 0.0)
                    SetEntityAlpha(ped, 0.0)
                    table.insert(fakeAnimals, ped)
                    SetEntityNoCollisionEntity(ped, PlayerPedId(), false)
                    SetEntityInvincible(ped, true)
                    SetBlockingOfNonTemporaryEvents(ped, true)
                end
            end
        end
    end)
    Citizen.CreateThread(function()
        while inJob do
            Citizen.Wait(10000)
            local distance = ESX.GetDistance(GetEntityCoords(PlayerPedId()),ConfigHunter.areaPos.xyz)
            if distance > ConfigHunter.areaPos.w or not HasPedGotWeapon(PlayerPedId(),lastWeapon) then
                TriggerEvent('esx_jobs:offMe')
            end
        end
    end)
end


RegisterNetEvent('esx:inJob')
AddEventHandler('esx:inJob', function(name)
    LocalPlayer.state.job = name
    if name == 'hunter' and not inJob then
        local distance = ESX.GetDistance(ConfigHunter.areaPos.xyz, GetEntityCoords(PlayerPedId()))
        if distance <= ConfigHunter.areaPos.w then
            inJob = true
            mainThread()
            areaBlip = AddBlipForRadius(ConfigHunter.areaPos)
            SetBlipColour(areaBlip, 51)
            SetBlipAlpha(areaBlip, 100)
            TriggerServerEvent('sunset_admin:dontcheckweapon')
            Citizen.Wait(500)
            TriggerEvent('esx:addWeapon','weapon_musket', 250)
            ESX.Alert('On duty','Shoma on duty shodid,Tavajoh konid nabayad az mantaghe ma\'alum shode dar naghshe kharej shavid!',10000,'success')
            exports['xsound']:PlayUrl("hunting", "./sounds/hunting.ogg", 0.05,true)
            TriggerEvent('safezone:active', false)
            NetworkSetFriendlyFireOption(false)
        end
	elseif inJob then
        inJob = false
        antiSpam = true
        Citizen.SetTimeout(30000,function()
            antiSpam = false
        end)
        TriggerEvent('safezone:active', true)
        Citizen.Wait(4000)
        deleteFakeAnimals()
        RemoveWeaponFromPed(PlayerPedId(),`weapon_musket`)
        Citizen.Wait(500)
        ESX.Alert('Off duty','Shoma off duty shodid(Shekar)!',10000,'error')
        exports['xsound']:Destroy("hunting")
        RemoveBlip(areaBlip)
        for k,v in pairs(animals) do
            RemoveBlip(GetBlipFromEntity(v.ped))
            DeleteEntity(v.ped)
        end
        animals = {}
        NetworkSetFriendlyFireOption(true)
        RemoveWeaponFromPed(PlayerPedId(),`weapon_musket`)
        Citizen.Wait(10000)
        TriggerServerEvent('sunset_admin:checkweapon')
    end
end)

-- RegisterCommand('testcoords',function()
--     ESX.Streaming.RequestModel(`a_c_panther`)
--     merryped2 = CreatePed(5, `a_c_panther`, GetEntityCoords(PlayerPedId()).x - 100,GetEntityCoords(PlayerPedId()).y,GetEntityCoords(PlayerPedId()).z, 360.00, true, false)
--     SetPedAsEnemy(merryped2, true)
--     SetPedRelationshipGroupHash(merryped2, 'Merryweather')
--     SetPedSeeingRange(merryped2,250.0)
--     TaskCombatPed(merryped2, GetPlayerPed(-1),0,16)
--     SetPedAccuracy(merryped2, 100)
--     AddBlipForEntity(merryped2)
-- end)


-- Citizen.CreateThread(function()
--     while true do
--         DrawLine(GetEntityCoords(PlayerPedId()),35.45, 172.66, 126.22, 255,0,0,255)
--         Wait(0)
--     end
-- end)

function deleteFakeAnimals()
    for k, v in pairs(fakeAnimals) do
        ESX.Game.DeleteEntity(v)
    end
    fakeAnimals = {}
end


AddEventHandler('esx:onPlayerDeath',function()
    for k,v in pairs(animals) do
        if DoesEntityExist(v.ped) and not v.deadCheck then
            if v.attacker then
                DeleteEntity(v.ped)
                animals[k] = nil
            end
        end
    end
end)