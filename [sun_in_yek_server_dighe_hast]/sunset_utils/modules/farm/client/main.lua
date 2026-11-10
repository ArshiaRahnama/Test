-- Pub by FleeX Team , https://discord.gg/87rGBxgCsa

local farm, ownedFarms, ownedKeys, currentFarmConfig, canPlant, nearPlant, dontCheckDistance = nil, nil, {}, {}, false, false, false
local armor = 0
local cooldown = false
local function fetchOwnedFarm()
    local p = promise.new()
    ESX.TriggerServerCallback('farm:getOwnedFarms', function(result, keys)
        ownedKeys = keys or {}
        p:resolve(result)
    end)
    ownedFarms = Citizen.Await(p)
end

local function playEnterAnimation(type)
    local config = farmConfig.farms[type]
    ESX.Game.SpawnLocalVehicle(config.truck.model, config.truck.enter.xyz - vec(0, 0, 1), config.truck.enter.w, function(vehicle)
        TriggerEvent('hotwire:add', vehicle)
        local anim = true
        CreateThread(function()
            while anim do
                DisableAllControlActions(0)
                Wait(0)
            end
        end)
        TaskEnterVehicle(SUN.ped, vehicle, 10000, -1, 1.0, 1)
        local timeout = 10000
        while GetVehiclePedIsIn(SUN.ped, false) ~= vehicle and timeout > 0 do Wait(100) timeout -= 100 end
        TaskWarpPedIntoVehicle(PlayerPedId(), vehicle, -1)
        TaskVehicleDriveToCoordLongrange(SUN.ped, vehicle, 677.78, 6514.62, 28.03, 200, 0, 20.0)
        Wait(10000)
        ESX.fadeScreen(1000, function()
            DeleteEntity(vehicle)
            ESX.Game.Teleport(SUN.ped, config.enterTPCoords)
            anim = false
            dontCheckDistance = false
        end)
    end)
end

local function manageKeyMenu(farmId, type)
    ESX.TriggerServerCallback('farm:getFarmData', function(data)
        local keys = data.data.keys or {}
        local options = {
            {label = 'Key list', icon = 'hand-point-down', close = false}
        }
        for k, v in pairs(keys) do
            table.insert(options, {label = v.name, args = {type = 'remove', identifier = v.identifier, name = v.name}, icon = 'person'})
        end
        if ESX.tableLength(keys) < farmConfig.farms[type].keySlot then
            table.insert(options, {label = 'Add key', args = {type = 'add'}, icon = 'plus'})
        end
        lib.registerMenu({
            id = 'farmMenu3',
            title = 'Key',
            position = 'top-left',
            options = options
        }, function(selected, scrollIndex, args)
            if args then
                if args.type == 'add' then
                    ESX.selectPlayerMenu(function(src)
                        ESX.TriggerServerCallback('core:getName', function(name)
                            local alert = lib.alertDialog({
                                header = 'Give key',
                                content = ('Aya mayel be dadan kelid be %s hastid?'):format(name),
                                centered = true,
                                cancel = true
                            })
                            if alert == 'confirm' then
                                ESX.TriggerServerEvent('farm:giveKey', farmId, src)
                            end
                        end, src)
                    end, 7)
                elseif args.type == 'remove' then
                    local alert = lib.alertDialog({
                        header = 'Remove key',
                        content = ('Aya mayel be gereftan kelid az %s hastid?'):format(args.name),
                        centered = true,
                        cancel = true
                    })
                    if alert == 'confirm' then
                        ESX.TriggerServerEvent('farm:removeKey', farmId, args.identifier, args.name)
                    end
                end
            end
        end)
        lib.showMenu('farmMenu3')
    end, farmId)
end

RegisterNetEvent('farm:updateOwned', function(owned)
    ownedFarms = owned
end)

RegisterNetEvent('farm:updateKey', function(keys)
    ownedKeys = keys
end)

CreateThread(function()
    waitForLoad()
    Wait(2000)
    while not lib do Wait(100) end
    for k, v in pairs(farmConfig.farms) do
        ESX.AddBlipForCoord(v.enterCoords.xyz, 0.8, 88, 2, v.label)
        ESX.RegisterPoint(v.enterCoords.xyz - vec(0, 0, 1), 3, {
            Color = {R = 255, G = 0, B = 0, A = 255},
            DrawDistance = 10,
            Radius = 1.5,
            Type = 47,
            world = 0,
        }, {
            textUI = {text = '[E] Farm', icon = 'farm'},
            Key = 'e',
            CB = function()
                lib.hideMenu()
                if not ownedFarms then
                    fetchOwnedFarm()
                end
                ESX.TriggerServerCallback('farm:getFarmsId', function(farmsId)
                    local options = {}
                    local ownedId, ownedIndex, ownedKeyId, ownedKeyIndex = false, nil, nil, nil
                    for k2, v2 in pairs(ownedFarms) do
                        if v2.type == k then
                            ownedId = k2
                            ownedIndex = v2.index
                        end
                    end
                    for k2, v2 in pairs(ownedKeys) do
                        if v2.type == k then
                            ownedKeyId = v2.id
                            ownedKeyIndex = v2.index
                        end
                    end
                    if ownedId then
                        table.insert(options, {label = ('Enter(%s)'):format(ownedIndex), icon = 'right-to-bracket', args = {type = 'enter', id = ownedId}})
                        table.insert(options, {label = ('Manage key(%s)'):format(ownedIndex), icon = 'key', args = {type = 'manageKey', id = ownedId}})
                        table.insert(options, {label = ('Open barn(%s)'):format(ownedIndex), icon = 'key', args = {type = 'openBarn', id = ownedId}})
                    else
                        table.insert(options, {label = ('Buy($%s)'):format(ESX.Math.GroupDigits(v.price)), icon = 'money-bill', args = {type = 'buy'}})
                    end
                    if ownedKeyId then
                        table.insert(options, {label = ('Enter key(%s)'):format(ownedKeyIndex), icon = 'right-to-bracket', args = {type = 'enter', id = ownedKeyId}})
                        table.insert(options, {label = ('Open barn(%s)'):format(ownedKeyIndex), icon = 'key', args = {type = 'openBarn', id = ownedKeyId}})
                    end
                    table.insert(options, {label = ('%s/%s Purchased'):format(farmsId[k] or 0, v.buySlot), icon = 'shop', close = false})
                    lib.registerMenu({
                        id = 'farmMenu1',
                        title = 'Farm',
                        position = 'top-left',
                        options = options
                    }, function(selected, scrollIndex, args)
                        if args.type == 'buy' then
                            local alert = lib.alertDialog({
                                header = 'Kharid',
                                content = ('Aya mayel be kharid in mazrae ba mablagh(%s)?'):format(ESX.Math.GroupDigits(v.price)),
                                centered = true,
                                cancel = true
                            })
                            if alert == 'confirm' then
                                ESX.TriggerServerEvent('farm:buy', k)
                            end
                        elseif args.type == 'enter' then
                            -- if lib.progressCircle({
                            --     duration = 10000,
                            --     position = 'bottom',
                            --     useWhileDead = false,
                            --     canCancel = true,
                            --     disable = {
                            --         car = true,
                            --         move = true,
                            --     },
                            -- }) then
                            if not ESX.jobs2[ESX.PlayerData.job.name] then
                                if ESX.isDead() or SUN.isPlayerInVehicle then return end
                                dontCheckDistance = true
                                armor = GetPedArmour(SUN.ped)
                                ESX.TriggerServerEvent('farm:enter', args.id)
                                playEnterAnimation(k)
                            else
                                ESX.chatMessage('Baraye vorud be mazrae ebteda off-duty konid!', 'plarms')
                            end
                            -- end
                        elseif args.type == 'manageKey' then
                            manageKeyMenu(ownedId, k)
                        elseif args.type == 'openBarn' then
                            exports['sun-inventory-hud']:openInventory('farm-barn:'.. args.id)
                        end
                    end)
                    lib.showMenu('farmMenu1')
                end)
            end,
        },{
            In = nil,
            Out = function()
                lib.hideMenu(true)
            end
        })
    end
    for k, v in pairs(farmConfig.seeds) do
        v.key = k
    end
    ESX.RegisterClientCallback('farm:askKey', function(cb, name)
        ESX.closeAll()
        local alert = lib.alertDialog({
            header = 'Give key',
            content = ('Aya mayel be daryaft kelid farm az %s hastid?\nTavajoh konid kelid haye ghabli shoma dar in mazrae az beyn khahad raft'):format(name),
            centered = true,
            cancel = true
        })
        cb(alert == 'confirm')
    end)
end)

local function exitFarm()
    if farm then
        ESX.TriggerServerEvent('farm:exit')
        ESX.fadeScreen(1000, function()
            if farm.exitVehicle then
                DeleteEntity(farm.exitVehicle)
            end
            if farm.poly then
                farm.poly:remove()
            end
            for k, v in pairs(farm.data.plants or {}) do
                if v.entity then
                    DeleteEntity(v.entity)
                end
            end
            ESX.Game.Teleport(SUN.ped, farmConfig.farms[farm.type].enterCoords)
            farm = nil
            ESX.SetPedArmour(SUN.ped, armor)
        end)
    end
end

RegisterNetEvent('farm:exit', function()
    exitFarm()
end)

RegisterNetEvent('farm:enterFarm', function(id, data)
    if farm then return end
    farm = data
    CreateThread(function()
        local config = farmConfig.farms[data.type]
        currentFarmConfig = config
        if not farm.exitVehicle then
            ESX.Game.SpawnLocalVehicle(config.truck.model, config.truck.exit.xyz - vec(0, 0, 1), config.truck.exit.w, function(vehicle)
                TriggerEvent('hotwire:add', vehicle)
                farm.exitVehicle = vehicle
            end)
        end
        if farm.data.plants then
            for k, v in pairs(farm.data.plants) do
                local plantConfig = farmConfig.seeds[v.name]
                if plantConfig.spoilTime and GetServerOSTime() - v.plantTime > (plantConfig.spoilTime * 3600) then
                    ESX.TriggerServerEvent('farm:removePlant', v.plantId)
                end
            end
        end
        farm.poly = lib.zones.poly({
            points = config.poly,
            thickness = 5,
            onEnter = function()
                lib.showTextUI('[E] Kesht', {
                    icon = 'plant-wilt',
                    position = 'left-center',
                    style = {
                        borderRadius = 5,
                        backgroundColor = '#FFA500',
                        color = 'black',
                    }
                })
                canPlant = true
            end,
            onExit = function()
                lib.hideTextUI()
                lib.hideMenu(true)
                canPlant = false
            end
        })
        while farm do
            local ts = GetServerOSTime()
            local distance1 = #(SUN.PlayerCoords - config.farmCoords.xyz)
            if distance1 > config.farmCoords.w and not dontCheckDistance then
                ESX.Game.Teleport(PlayerPedId(), config.enterTPCoords)
            end
            if farm.exitVehicle then
                ESX.Game.Utils.DrawText3D(config.truck.exit.xyz + vec(0, 0, 1), '~o~Exit', 3.0)
                if SUN.vehiclePlayerIsIn == farm.exitVehicle then
                    Wait(1000)
                    TaskVehicleDriveToCoordLongrange(SUN.ped, farm.exitVehicle, 677.78, 6514.62, 28.03, 200, 0, 20.0)
                    CreateThread(function()
                        while farm do
                            DisableAllControlActions(0)
                            Wait(0)
                        end
                    end)
                    Wait(10000)
                    exitFarm()
                    break
                end
            end
            if farm.data.plants then
                local near = false
                for k, v in pairs(farm.data.plants) do
                    local plantConfig = farmConfig.seeds[v.name]
                    if type(v.coords) ~= 'vector3' then
                        v.coords = vec(v.coords.x, v.coords.y, v.coords.z)
                    end
                    local distance = #(SUN.PlayerCoords - v.coords)
                    if not v.entity then
                        if not v.irrigated then
                            v.entity = ESX.Game.SpawnLocalObject(farmConfig.seedModel, v.coords - vec(0, 0, 0.7), nil, true)
                            v.entityType = 1
                            -- PlaceObjectOnGroundProperly(v.entity)
                            FreezeEntityPosition(v.entity, true)
                        end
                    end
                    local percent
                    if v.irrigatedTime then
                        local _ts = (ts - v.irrigatedTime)
                        local fruitingTime = getSkillTime('farm_skill', v.name)
                        percent = ESX.Math.Round(100 - (((fruitingTime - _ts) / fruitingTime) * 100))
                        if percent > 100 then
                            percent = 100
                        end
                        local model = nil
                        if plantConfig.models then
                            -- if plantConfig.models.type == 1 and plantConfig.models.list then
                            --     local _percent = 0
                            --     for k, v in pairs(plantConfig.models.list) do
                            --         if percent > k and k > _percent then
                            --             _percent = k
                            --             model = v
                            --         end
                            --     end
                            -- elseif plantConfig.models.type == 2 and plantConfig.models.model then
                            --     model = plantConfig.models.model
                            --     if GetEntityModel(v.entity) == plantConfig.models.model then
                            --         local coords = v.coords - vec(0, 0, plantConfig.models.offset - ((plantConfig.models.offset / 100) * percent))
                            --         SetEntityCoords(v.entity, coords.x, coords.y, coords.z)
                            --     end
                            -- end
                            local _percent = 0
                            for k2, v2 in pairs(plantConfig.models.list) do
                                if type(v2) == 'number' then
                                    if percent > k2 and k2 > _percent then
                                        _percent = k2
                                        model = v2
                                    end
                                else
                                    if percent > k2 and k2 > _percent then
                                        _percent = k2
                                        model = v2.model
                                        if GetEntityModel(v.entity) == v2.model then
                                            local coords = v.coords - vec(0, 0, v2.offset - ((v2.offset / 100) * percent))
                                            SetEntityCoords(v.entity, coords.x, coords.y, coords.z)
                                        end
                                    end
                                end
                            end
                        end
                        if model and GetEntityModel(v.entity) ~= model then
                            DeleteEntity(v.entity)
                            v.entity = ESX.Game.SpawnLocalObject(model, v.coords, nil, true)
                            v.entityType = 2
                            PlaceObjectOnGroundProperly(v.entity)
                            FreezeEntityPosition(v.entity, true)
                        end
                    end
                    if distance < 4 then
                        if not v.irrigated then
                            ESX.Game.Utils.DrawText3D((v.coords + vec(0, 0, 1)), plantConfig.label .. (distance <= 1.5 and '\n~g~[E] Abyari💦' or ''), 0.5)
                        else
                            if percent >= 100 then
                                ESX.Game.Utils.DrawText3D((v.coords + vec(0, 0, 1.08)), '~g~[E] Bardasht mahsul', 0.5)
                            end
                            ESX.Game.Utils.DrawText3D((v.coords + vec(0, 0, 1)), plantConfig.label .. ' ~g~' .. percent .. '%\n~o~[G] Kandan Giah', 0.5)
                        end
                    end
                    if distance <= 1.5 then
                        if IsControlPressed(0, 38) and not cooldown then
                            cooldown = true
                            if not v.irrigated then
                                ESX.entityFaceEntity(SUN.ped, v.entity)
                                TriggerEvent('anim:play', 'abyari')
                                if lib.progressCircle({
                                    duration = plantConfig.waterTime * 1000,
                                    position = 'bottom',
                                    useWhileDead = false,
                                    canCancel = true,
                                    allowRagdoll = true,
                                    allowFalling = true,
                                    disable = {
                                        car = true,
                                        move = true,
                                    },
                                }) then
                                    ESX.TriggerServerEvent('farm:irrigated', v.plantId)
                                end
                            elseif percent >= 100 then
                                ESX.entityFaceEntity(SUN.ped, v.entity)
                                ESX.disableKey('x', true)
                                TaskStartScenarioInPlace(SUN.ped, 'WORLD_HUMAN_GARDENER_PLANT', 0, false)
                                if lib.progressCircle({
                                    duration = plantConfig.waterTime * 1000,
                                    position = 'bottom',
                                    useWhileDead = false,
                                    canCancel = true,
                                    allowRagdoll = true,
                                    allowFalling = true,
                                    disable = {
                                        car = true,
                                        move = true,
                                    },
                                }) then
                                    ESX.TriggerServerEvent('farm:pickup', v.plantId)
                                end
                                ESX.disableKey('x', false)
                                ClearPedTasksImmediately(SUN.ped)
                            end
                            Wait(2000)
                            cooldown = false
                        elseif IsControlJustPressed(0, 47) then
                            ESX.entityFaceEntity(SUN.ped, v.entity)
                            ESX.disableKey('x', true)
                            TaskStartScenarioInPlace(SUN.ped, 'WORLD_HUMAN_GARDENER_PLANT', 0, false)
                            if lib.progressCircle({
                                duration = plantConfig.deleteTime * 1000,
                                position = 'bottom',
                                useWhileDead = false,
                                canCancel = true,
                                allowRagdoll = true,
                                allowFalling = true,
                                disable = {
                                    car = true,
                                    move = true,
                                },
                            }) then
                                ESX.TriggerServerEvent('farm:removePlant', v.plantId)
                            end
                            ESX.disableKey('x', false)
                            ClearPedTasksImmediately(SUN.ped)
                            Wait(2000)
                            cooldown = false
                        end
                        near = true
                    end
                end
                nearPlant = near
            end
            Wait(0)
        end
    end)
end)

AddEventHandler('KeyDown:e', function()
    if canPlant and not nearPlant then
        lib.hideMenu(true)
        local options = {}
        local usedSlot = ESX.tableLength(farm.data.plants or {})
        local scroll = {}
        if usedSlot < currentFarmConfig.plantSlot then
            local values = {}
            for k, v in pairs(farmConfig.seeds) do
                if currentFarmConfig.seeds[k] then
                    local doesHaveItems = true
                    for k2, v2 in pairs(v.requiredItems) do
                        if not ESX.DoesHaveItem2(k2, v2) then
                            doesHaveItems = false
                        end
                    end
                    if doesHaveItems then
                        table.insert(values, v.label)
                        scroll[#values] = k
                    end
                end
            end
            if #values > 0 then
                table.insert(options, {label = 'Kesht', values = values, args = 'planting', icon = 'plant-wilt'})
            else
                table.insert(options, {label = 'Shoma bazri baraye kesh nadaraid', icon = 'plant-wilt', close = false})
            end
        end
        table.insert(options, {label = ('%s/%s Slot'):format(usedSlot, currentFarmConfig.plantSlot), close = false})
        lib.registerMenu({
            id = 'farmMenu2',
            title = 'Kesht',
            options = options
        }, function(selected, scrollIndex, args)
            if args == 'planting' then
                local config = farmConfig.seeds[scroll[scrollIndex]]
                if not lib.progressActive() then
                    local coords = GetOffsetFromEntityInWorldCoords(SUN.ped, 0.0, 0.7, 0.0)
                    local doesLocationFree = true
                    for k, v in pairs(farm.data.plants or {}) do
                        if #(coords - vec(v.coords.x, v.coords.y, v.coords.z)) < 1.5 then
                            doesLocationFree = false
                        end
                    end
                    if doesLocationFree then
                        ESX.disableKey('x', true)
                        TaskStartScenarioInPlace(SUN.ped, 'WORLD_HUMAN_GARDENER_PLANT', 0, false)
                        if lib.progressCircle({
                            duration = config.plantTime * 1000,
                            position = 'bottom',
                            useWhileDead = false,
                            canCancel = true,
                            allowRagdoll = true,
                            allowFalling = true,
                            disable = {
                                car = true,
                                move = true,
                            },
                        }) then
                            ESX.TriggerServerEvent('farm:plant', config.key, {x = ESX.Math.Round(coords.x, 2), y = ESX.Math.Round(coords.y, 2), z = ESX.Math.Round(coords.z - 1, 2)})
                        end
                        ClearPedTasksImmediately(SUN.ped)
                        ESX.disableKey('x', false)
                    else
                        ESX.chatMessage('Yek giah dar inja kashte shode, jaye khod ra ^2avaz konid^0', 'plarms')
                    end
                end
            end
        end)
        lib.showMenu('farmMenu2')
    end
end)

RegisterNetEvent('farm:addPlant', function(data)
    if farm then
        if not farm.data.plants then
            farm.data.plants = {}
        end
        table.insert(farm.data.plants, data)
    end
end)

RegisterNetEvent('farm:updatePlant', function(data)
    if farm then
        for k, v in pairs(farm.data.plants) do
            if v.plantId == data.plantId then
                data.entity = v.entity
                data.entityType = v.entityType
                farm.data.plants[k] = data
            end
        end
    end
end)

RegisterNetEvent('farm:removePlant', function(plantId)
    if farm then
        for k, v in pairs(farm.data.plants) do
            if v.plantId == plantId then
                DeleteEntity(v.entity)
                farm.data.plants[k] = nil
            end
        end
    end
end)