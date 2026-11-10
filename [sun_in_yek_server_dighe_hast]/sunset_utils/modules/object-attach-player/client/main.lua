-- Pub by FleeX Team , https://discord.gg/87rGBxgCsa

local filledPositions, spawnedItems = {}, {}

local function openMenu()
    local options = {}
    for k, v in pairs(objectAttachPlayer.items) do
        if ESX.DoesHaveItem2(k, 1) then
            table.insert(options, {label = ('%s %s'):format(v.label, spawnedItems[k] and '✔️' or '❌'), args = k})
        end
    end
    if #options == 0 then
        return ESX.notification('errpr', 'شیئی جهت اتچ ندارید')
    end
    lib.registerMenu({
        id = 'objectat1',
        title = 'Item',
        options = options,
    }, function (selected, scrollIndex, args, checked)
        local itemName = args
        local config = objectAttachPlayer.items[itemName]
        local options = {}
        for k, v in pairs(config.positions) do
            table.insert(options, {label = objectAttachPlayer.labels[k], args = k})
        end
        if spawnedItems[itemName] then
            table.insert(options, {label = objectAttachPlayer.labels['delete'], args = 'delete'})
        end
        print(ESX.dump(options))
        lib.registerMenu({
            id = 'objectat2',
            title = 'Item',
            options = options,
        }, function (selected, scrollIndex, args, checked)
            local position = args
            if args == 'delete' then
                if spawnedItems[itemName] then
                    ESX.Game.DeleteEntity(filledPositions[spawnedItems[itemName].position].object)
                    filledPositions[spawnedItems[itemName].position] = nil
                    spawnedItems[itemName] = nil
                end
            else
                if filledPositions[args] then
                    spawnedItems[filledPositions[args].itemName] = nil
                    ESX.Game.DeleteEntity(filledPositions[args].object)
                end
                if spawnedItems[itemName] then
                    ESX.Game.DeleteEntity(filledPositions[spawnedItems[itemName].position].object)
                    filledPositions[spawnedItems[itemName].position] = nil
                    spawnedItems[itemName] = nil
                end
                spawnedItems[itemName] = {
                    position = args,
                }

                local object = ESX.Game.SpawnObject(config.model, SUN.PlayerCoords, nil, true)
                AttachEntityToEntity(object, SUN.ped, GetPedBoneIndex(SUN.ped, config.positions[position].bone), config.positions[position].pos, config.positions[position].rot, true, true, false, false, 1, true)

                filledPositions[args] = {
                    object = object,
                    itemName = itemName,
                }
            end
            openMenu()
        end)
        lib.showMenu('objectat2')
    end)
    lib.showMenu('objectat1')
end

CreateThread(function()
    waitForLoad(1000)
    ESX.RegisterCommand('attachitem', function()
        openMenu()
    end)
end)

AddEventHandler('onResourceStop', function()
    for k, v in pairs(filledPositions) do
        ESX.Game.DeleteEntity(v.object)
    end
end)