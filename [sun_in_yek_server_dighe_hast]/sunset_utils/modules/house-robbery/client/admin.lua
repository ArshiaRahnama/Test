-- Pub by FleeX Team , https://discord.gg/87rGBxgCsa

local currentHouseIdEdit = 0
local houseTemplate = {}
local tempObjects = {}
local tempPeds = {}
local tempShell = 0
local lastCoords

local function deleteTempObjects()
    DeleteEntity(tempShell)
    for k, v in pairs(tempObjects) do
        DeleteEntity(v.object)
    end
    for k, v in pairs(tempPeds) do
        DeletePed(v.ped)
    end
    tempObjects = {}
    tempPeds = {}
end


local function getHouseTemplates()
    local p = promise.new()
    ESX.TriggerServerCallback('houserob:getTemplates', function(result)
        houseTemplate = result
        p:resolve(true)
    end)
    Citizen.Await(p)
end

local function getSpecificHouseTemplate(id)
    local p = promise.new()
    ESX.TriggerServerCallback('houserob:getSpecificTemplate', function(result)
        houseTemplate[id] = result
        p:resolve(true)
    end, id)
    Citizen.Await(p)
end

local function changeOutline(state)
    for k, v in pairs(tempObjects) do
        if state then
            if houseRobbery.objectReward[v.model] then
                SetEntityDrawOutline(v.object, true)
            end
        else
            SetEntityDrawOutline(v.object, state)
        end
    end
end

AddEventHandler('onResourceStop', function(resource)
    if resource == 'sunset_utils' then
        deleteTempObjects()
    end
end)

local function spawnHouse(data, teleport)
    local shell = data.model
    local objectList = data.objects or {}
    local pedList = data.peds or {}
    if teleport then
        DoScreenFadeOut(750)
    end
    ESX.Game.SpawnLocalObject(shell, houseRobbery.houseCoords,function(obj)
        tempShell = obj
        SetEntityHeading(tempShell, 0.0)
        FreezeEntityPosition(tempShell, true)
        while not IsScreenFadedOut() and teleport do Wait(0) end
        local joinCoords = houseRobbery.shellCoords[shell].Join.xyz + houseRobbery.houseCoords
        if teleport then
            for i = 1, 25 do
                ESX.SetEntityCoords(PlayerPedId(), joinCoords)
                Wait(50)
            end
            while IsEntityWaitingForWorldCollision(PlayerPedId()) do
                ESX.SetEntityCoords(PlayerPedId(), joinCoords)
                Wait(50)
            end
            SetEntityHeading(PlayerPedId(), houseRobbery.shellCoords[shell].Join.w)
        end
        for k, v in pairs(objectList) do
            if IsModelInCdimage(joaat(v.model)) then
                ESX.Game.SpawnLocalObject(v.model, GetOffsetFromEntityInWorldCoords(tempShell, v.pos.x, v.pos.y, v.pos.z),function(object)
                    FreezeEntityPosition(object, true)
                    ESX.SetEntityCoordsNoOffset(object, GetOffsetFromEntityInWorldCoords(tempShell, v.pos.x, v.pos.y, v.pos.z))
                    if v.rot then SetEntityRotation(object, v.rot.x * 1.0, v.rot.y * 1.0, v.rot.z * 1.0, 2) end
                    SetEntityCollision(object,true,true)
                    if houseRobbery.objectReward[v.model] then
                        print(v.model)
                        SetEntityDrawOutline(object, true)
                    end
                    table.insert(tempObjects, {object = object, id = k, model = v.model})
                end)
            else
                ESX.chatMessage('Model failed '.. v.model, 'plarms')
            end
        end
        for k, v in pairs(pedList) do
            ESX.Game.SpawnLocalPedAsync(27, v.model, GetOffsetFromEntityInWorldCoords(tempShell, v.pos.x, v.pos.y, v.pos.z), 165, function(ped)
                -- FreezeEntityPosition(ped, true)
                SetBlockingOfNonTemporaryEvents(ped, true)
                FreezeEntityPosition(ped, true)
                SetEntityInvincible(ped, true)
                Wait(1000)
                local coords = GetOffsetFromEntityInWorldCoords(tempShell, v.pos.x, v.pos.y, v.pos.z)
                ESX.SetEntityCoordsNoOffset(ped, coords)
                if v.rot then SetEntityRotation(ped, v.rot.x * 1.0, v.rot.y * 1.0, v.rot.z * 1.0, 2) end
                -- TaskStartScenarioInPlace(ped, 'WORLD_HUMAN_SLEEP', 0, true)
                ESX.Streaming.RequestAnimDict('timetable@tracy@sleep@')
                TaskPlayAnim(ped, 'timetable@tracy@sleep@', 'idle_c', 2.0, 2.0, -1, 1, 0, false, false, false)
                table.insert(tempPeds, {ped = ped, id = k})
            end)
        end
        if teleport then
            DoScreenFadeIn(2500)
        end
    end)
end


local function editObjectMenu(id)
    local options = {}
    for k, v in pairs(tempObjects) do
        SetEntityDrawOutline(v.object, false)
        if #(SUN.PlayerCoords - GetEntityCoords(v.object)) < 5 then
            table.insert(options, {label = ESX.Math.Round(#(SUN.PlayerCoords - GetEntityCoords(v.object))), args = {object = v.object, id = v.id}})
        end
    end
    lib.registerMenu({
        id = 'house_rob_3',
        title = 'House robbery',
        position = 'top-left',
        options = options,
        onSelected = function(selected, secondary, args)
            changeOutline(false)
            SetEntityDrawOutline(args.object, true)
        end,
        onClose = function(keyPressed)
            changeOutline(false)
        end,
    }, function(selected, scrollIndex, args)
        local object, objectId = args.object, args.id
        local options = {
            {label = 'Change position', args = 'change'},
            {label = 'Delete', args = 'delete'}
        }
        lib.registerMenu({
            id = 'house_rob_4',
            title = 'House robbery',
            position = 'top-left',
            options = options,
        }, function(selected, scrollIndex, args)
            if args == 'change' then
                local gizmo = exports['sun-gizmo']:useGizmo(object)
                local pos = GetEntityCoords(object) - GetEntityCoords(tempShell)
                if gizmo.rotation then
                    local data = {
                        rot = vec(ESX.Math.Round(gizmo.rotation.x, 3), ESX.Math.Round(gizmo.rotation.y, 3), ESX.Math.Round(gizmo.rotation.z, 3)),
                        pos = vec(ESX.Math.Round(pos.x, 3), ESX.Math.Round(pos.y, 3), ESX.Math.Round(pos.z, 3)),
                    }
                    ESX.TriggerServerEvent('houserob:editObject', currentHouseIdEdit, objectId, data)
                    getSpecificHouseTemplate(currentHouseIdEdit)
                    deleteTempObjects()
                    spawnHouse(houseTemplate[id])
                end
            elseif args == 'delete' then
                ESX.TriggerServerEvent('houserob:deleteObjectAdmin', currentHouseIdEdit, objectId)
                getSpecificHouseTemplate(currentHouseIdEdit)
                deleteTempObjects()
                spawnHouse(houseTemplate[id])
            end
            Wait(1000)
            print(IsVehicleDoorFullyOpen)
            editObjectMenu(id)
        end)
        lib.showMenu('house_rob_4')
    end)
    lib.showMenu('house_rob_3')
end


local function openHouseMenu(id)
    local options = {
        {label = 'Teleport', args = 'teleport'}
    }
    local reward = 0
    if houseTemplate[id].objects then
        for k, v in pairs(houseTemplate[id].objects) do
            if houseRobbery.objectReward[v.model] and houseRobbery.objectReward[v.model].price then
                reward = reward + houseRobbery.objectReward[v.model].price
            end
        end
    end
    if currentHouseIdEdit == id then
        options[1] = {label = 'Exit', args = 'exit'}
        table.insert(options, {label = 'Spawn Object', args = 'spawnObject'})
        table.insert(options, {label = 'Edit Object', args = 'editObject'})
        table.insert(options, {label = 'Spawn Ped', args = 'spawnPed'})
        table.insert(options, {label = 'Edit Ped', args = 'editPed'})
        table.insert(options, {label = ('Reward $%s'):format(reward), args = ''})
    end
    lib.registerMenu({
        id = 'house_rob_2',
        title = 'House robbery',
        position = 'top-left',
        options = options,
    }, function(selected, scrollIndex, args)
        if args == 'teleport' then
            currentHouseIdEdit = id
            lastCoords = GetEntityCoords(SUN.ped)
            deleteTempObjects()
            spawnHouse(houseTemplate[id], true)
            openHouseMenu(id)
            CreateThread(function()
                while currentHouseIdEdit == id do
                    if houseTemplate[id] and houseTemplate[id].objects then
                        for k, v in pairs(houseTemplate[id].objects) do
                            local coords = GetOffsetFromEntityInWorldCoords(tempShell, v.pos.x, v.pos.y, v.pos.z)
                            local price = 0
                            if houseRobbery.objectReward[v.model] and houseRobbery.objectReward[v.model].price then
                                price = houseRobbery.objectReward[v.model].price
                            end
                            -- if price then
                            --     ESX.Game.Utils.DrawText3D(coords, ('%s $%s'):format(v.model, price))
                            -- end
                        end

                        if houseTemplate[id].peds then
                            for k, v in pairs(houseTemplate[id].peds) do
                                local coords = GetOffsetFromEntityInWorldCoords(tempShell, v.pos.x, v.pos.y, v.pos.z)
                                ESX.Game.Utils.DrawText3D(coords, ('%s'):format(k))
                            end
                        end
                    end
                    Wait(0)
                end
            end)
        elseif args == 'exit' then
            currentHouseIdEdit = 0
            ESX.SetEntityCoords(SUN.ped, lastCoords)
            deleteTempObjects()
        elseif args == 'spawnObject' then
            local input = lib.inputDialog('Model object ra vared konid', {
                {type = 'input', label = 'Model', required = true},
            })
            if input and input[1] then
                local model = input[1]
                local coords = GetOffsetFromEntityInWorldCoords(SUN.ped, 0.0, 1.0, 0.0)
                ESX.Game.SpawnLocalObject(model, coords,function(object)
                    FreezeEntityPosition(object, true)
                    local gizmo = exports['sun-gizmo']:useGizmo(object)
                    local pos = GetEntityCoords(object) - GetEntityCoords(tempShell)
                    print(pos, GetEntityCoords(object))
                    if gizmo.rotation then
                        local data = {
                            rot = vec(ESX.Math.Round(gizmo.rotation.x, 3), ESX.Math.Round(gizmo.rotation.y, 3), ESX.Math.Round(gizmo.rotation.z, 3)),
                            pos = vec(ESX.Math.Round(pos.x, 3), ESX.Math.Round(pos.y, 3), ESX.Math.Round(pos.z, 3)),
                            model = model
                        }
                        ESX.TriggerServerEvent('houserob:addObject', currentHouseIdEdit, data)
                        DeleteEntity(object)
                        getSpecificHouseTemplate(currentHouseIdEdit)
                        deleteTempObjects()
                        spawnHouse(houseTemplate[id])
                    end
                end)
            end
        elseif args == 'editObject' then
            editObjectMenu(id)
        elseif args == 'spawnPed' then
            local input = lib.inputDialog('Model ped ra vared konid', {
                {type = 'input', label = 'Model', required = true},
                {type = 'input', label = 'Weapon', required = true},
            })
            if input and input[1] and input[2] then
                local model, weapon = input[1], input[2]
                local coords = GetOffsetFromEntityInWorldCoords(SUN.ped, 0.0, 1.0, 0.0)
                ESX.Game.SpawnLocalPed(27, model, coords, 165,function(ped)
                    FreezeEntityPosition(ped, true)
                    TaskStartScenarioAtPosition(ped, 'WORLD_HUMAN_SUNBATHE_BACK', coords.x, coords.y, coords.z, 150, 0, true, false)
                    local gizmo = exports['sun-gizmo']:useGizmo(ped)
                    local pos = GetEntityCoords(ped) - GetEntityCoords(tempShell)
                    print(pos, GetEntityCoords(ped))
                    if gizmo.rotation then
                        local data = {
                            rot = vec(ESX.Math.Round(gizmo.rotation.x, 3), ESX.Math.Round(gizmo.rotation.y, 3), ESX.Math.Round(gizmo.rotation.z, 3)),
                            pos = vec(ESX.Math.Round(pos.x, 3), ESX.Math.Round(pos.y, 3), ESX.Math.Round(pos.z, 3)),
                            model = model,
                            weapon = weapon,
                        }
                        ESX.TriggerServerEvent('houserob:addPed', currentHouseIdEdit, data)
                        DeletePed(ped)
                        getSpecificHouseTemplate(currentHouseIdEdit)
                        deleteTempObjects()
                        spawnHouse(houseTemplate[id])
                    end
                end)
            end
        elseif args == 'editPed' then
            local options = {}
            for k, v in pairs(tempPeds) do
                table.insert(options, {label = k, args = {object = v.ped, id = v.id}})
            end
            lib.registerMenu({
                id = 'house_rob_5',
                title = 'House robbery',
                position = 'top-left',
                options = options,
            }, function(selected, scrollIndex, args)
                local object, objectId = args.object, args.id
                local options = {
                    {label = 'Change position', args = 'change'},
                    {label = 'Delete', args = 'delete'}
                }
                lib.registerMenu({
                    id = 'house_rob_6',
                    title = 'House robbery',
                    position = 'top-left',
                    options = options,
                }, function(selected, scrollIndex, args)
                    if args == 'change' then
                        local gizmo = exports['sun-gizmo']:useGizmo(object)
                        local pos = GetEntityCoords(object) - GetEntityCoords(tempShell)
                        if gizmo.rotation then
                            local data = {
                                rot = vec(ESX.Math.Round(gizmo.rotation.x, 3), ESX.Math.Round(gizmo.rotation.y, 3), ESX.Math.Round(gizmo.rotation.z, 3)),
                                pos = vec(ESX.Math.Round(pos.x, 3), ESX.Math.Round(pos.y, 3), ESX.Math.Round(pos.z, 3)),
                            }
                            ESX.TriggerServerEvent('houserob:editPed', currentHouseIdEdit, objectId, data)
                            getSpecificHouseTemplate(currentHouseIdEdit)
                            deleteTempObjects()
                            spawnHouse(houseTemplate[id])
                        end
                    elseif args == 'delete' then
                        ESX.TriggerServerEvent('houserob:deletePedAdmin', currentHouseIdEdit, objectId)
                        getSpecificHouseTemplate(currentHouseIdEdit)
                        deleteTempObjects()
                        spawnHouse(houseTemplate[id])
                    end
                end)
                lib.showMenu('house_rob_6')
            end)
            lib.showMenu('house_rob_5')
        end
    end)
    lib.showMenu('house_rob_2')
end

local function editMenu()
    getHouseTemplates()
    local options = {}

    local indices = {}
    for k in pairs(houseTemplate) do
        table.insert(indices, k)
    end

    table.sort(indices)

    for _, index in ipairs(indices) do
        table.insert(options, {label = index, args = index})
    end

    table.insert(options, {label = 'Add', args = 'add'})
    lib.registerMenu({
        id = 'house_rob_1',
        title = 'House robbery',
        position = 'top-left',
        options = options,
    }, function(selected, scrollIndex, args)
        if args then
            if args == 'add' then
                local input = lib.inputDialog('Model khane ra vared konid', {
                    {type = 'input', label = 'Model', required = true},
                })
                if input and input[1] then
                    ESX.TriggerServerEvent('houserob:addHouse', input[1])
                end
                Wait(1000)
                editMenu()
            elseif type(args) == 'number' then
                openHouseMenu(args)
            end
        end
    end)
    lib.showMenu('house_rob_1')
end

RegisterNetEvent('houserob:openEditMenu', function()
    editMenu()
end)