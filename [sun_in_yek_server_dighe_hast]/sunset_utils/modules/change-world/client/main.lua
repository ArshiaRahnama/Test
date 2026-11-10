-- Pub by FleeX Team , https://discord.gg/87rGBxgCsa

local inChangeWorld, pedChanged = false, false
local cwLegit = false

RegisterNetEvent('cw:setLegit', function(state)
    cwLegit = state
end)
local duiObj = nil
local duiTxd = "dynamicdui"
local duiTxn = "dynamicdui_txn"

local function drawImage()
    while duiObj do
        Wait(0)
        if duiObj then
            DrawSprite(duiTxd, duiTxn, 0.85, 0.5, 0.25, 0.4, 0.0, 255, 255, 255, 255)
        end
    end
end

local function destoryDui()
    if duiObj then
        DestroyDui(duiObj)
        duiObj = nil
    end
end

local function ShowImageOnScreen(imageUrl)
    destoryDui()
    Wait(10)

    duiObj = CreateDui(imageUrl, 512, 512)
    local duiHandle = GetDuiHandle(duiObj)

    local txd = CreateRuntimeTxd(duiTxd)
    CreateRuntimeTextureFromDuiHandle(txd, duiTxn, duiHandle)
    drawImage()
end

RegisterCommand('saveworldskin', function(src, args)
    local name = args[1]
    if name and ESX.GetPlayerData().permission_level >= 8 then
        local skin = exports['skinchanger']:getSkin()
        TriggerServerEvent('change-world:saveSkin', name, skin)
    end
end, false)

RegisterCommand('worldskin', function()
    if not cwLegit then return end
    local world = ESX.GetPlayerData().World
    if changeWorldConfig.worlds[world] and changeWorldConfig.worlds[world].skins then
        local options = {}
        for k, v in pairs(changeWorldConfig.worlds[world].skins) do
            table.insert(options, {label = v, args = k})
        end
        table.insert(options, {label = 'Default', args = 'def'})
        lib.registerMenu({
            id = 'changeWorldSkin',
            title = 'Skin',
            options = options
        }, function(selected, scrollIndex, args)
            if args then
                if args == 'def' then
                    TriggerEvent('change-world:loadUsedClothe')
                else
                    ESX.TriggerServerCallback('changeworld:getSkin', function(clothe)
                        if clothe then
                            TriggerEvent('skinchanger:getSkin', function(skin)
                                TriggerEvent('skinchanger:loadClothes', skin, clothe)
                            end)
                        end
                    end, args)
                end
            end
        end)
        lib.showMenu('changeWorldSkin')
    end
end, false)

RegisterNetEvent('change-world:loadUsedClothe', function()
    exports['sunset_clothe']:removeStuffJob()
    Wait(1000)
    exports['sunset_clothe']:loadUsed()
    SetPedSuffersCriticalHits(SUN.ped, true)
    Wait(5000)
    exports['sunset_utils']:deactiveArmoredHelmet()
    SetPedSuffersCriticalHits(SUN.ped, true)
end)

CreateThread(function()
    waitForLoad()
    ESX.RegisterCommand('cped', function()
        if not cwLegit then return end
        ESX.TriggerServerCallback('cw:getSpecificConfig', function(worldConfig)
            if (changeWorldConfig.worlds[SUN.world] and changeWorldConfig.worlds[SUN.world].peds and #changeWorldConfig.worlds[SUN.world].peds > 0) or (worldConfig) then
                local options = {}
                if worldConfig then
                    changeWorldConfig.worlds[SUN.world] = defaultCWConfig
                end
                for k, v in pairs(changeWorldConfig.worlds[SUN.world].peds) do
                    table.insert(options, {label = v.label, args = v.list})
                end
    
                lib.registerMenu({
                    id = 'cw1',
                    title = 'Change ped',
                    options = options
                }, function(selected, scrollIndex, args)
                    local options = {
                        {label = 'Default', args = 'default'}
                    }
                    for k, v in pairs(args) do
                        table.insert(options, {label = v.label, args = {model = v.model}, close = false, icon = ('https://cdn.sunrp.ir/img/jornal/%s.png'):format(v.model)})
                    end
    
                    lib.registerMenu({
                        id = 'cw2',
                        title = 'Change ped',
                        options = options,
                        onSelected = function(selected, scrollIndex, args)
                            ShowImageOnScreen(('https://cdn.sunrp.ir/img/jornal/%s.png'):format(args.model))
                        end,
                        onClose = function()
                            destoryDui()
                        end
                    }, function(selected, scrollIndex, args)
                        if args and changeWorldConfig.worlds[SUN.world] then
                            local default = args == 'default'
                            pedChanged = true
                            if default then
                                exports['skinchanger']:loadPedAndClothe()
                            else
                                args = joaat(args.model)
                                ESX.Streaming.RequestModel(args)
                                SetPlayerModel(PlayerId(), args)
                                SetPedComponentVariation(GetPlayerPed(-1), 0, 0, 0, 2)
                                if default then
                                    exports['sunset_clothe']:loadUsed()
                                end
                            end
                        end
                    end)
    
                    lib.showMenu('cw2')
                end)
                lib.showMenu('cw1')
            end
        end, SUN.world)
    end, {help = 'change ped'})
end)

local function loadDefaultPed()
    pedChanged = false
    exports['skinchanger']:loadPedAndClothe()
end

RegisterNetEvent('cw:loadDefaultPed', function(world)
    if pedChanged then
        loadDefaultPed()
    end
end)

RegisterNetEvent('esx:changeworld', function(world)
    if world == 0 and pedChanged then
        loadDefaultPed()
    end
end)

local lastConfig = {}

local function openSetting(world)
    ESX.TriggerServerCallback('cw:getSpecificConfig', function(data)
        lastConfig[world] = data
        local options = {
            {label = '---لیست دسترسی---', args = 'none', close = false}
        }
        if lastConfig[world] then
            table.insert(options, {label = ('دسترسی گنگ : %s'):format(lastConfig[world].access.gang and '✔️' or '❌'), args = {type = 'gang'}})
            table.insert(options, {label = '---گنگ ها---', close = false})
            for k, v in pairs(lastConfig[world].access.gangList or {}) do
                table.insert(options, {label = k, args = {
                    type = 'removeGang',
                    gang = k
                }})
            end

            table.insert(options, {label = 'گنگ جدید', args = {
                type = 'newGang',
            }})

            table.insert(options, {label = '---افراد---', close = false})

            for k, v in pairs(lastConfig[world].access.list or {}) do
                table.insert(options, {label = k, args = {
                    type = 'removePlayer',
                    identifier = k
                }})
            end

            table.insert(options, {label = 'فرد جدید', args = {
                type = 'newPlayer',
            }})

            local endTime = data.expire - GetServerOSTime()
            table.insert(options, {label = ('Expire : %s'):format(endTime < 0 and 'expired' or ESX.displayTime(endTime)), args = {
                type = 'expire',
            }})

            table.insert(options, {label = 'حذف ورلد', args = {
                type = 'delete',
            }})

            lib.registerMenu({
                id = 'cw4',
                title = 'Manage',
                options = options
            }, function(selected, scrollIndex, args)
                if args and args ~= 'none' then
                    if args.type == 'gang' then
                        lastConfig[world].access.gang = not lastConfig[world].access.gang
                        ESX.TriggerServerEvent('cw:toggleGang', world, lastConfig[world].access.gang)
                        Wait(1000)
                        openSetting(world)
                    elseif args.type == 'newGang' then
                        local input = lib.inputDialog('Enter gang', {
                            {type = 'input', label = 'Gang'},
                        })
                        if input and input[1] then
                            ESX.TriggerServerEvent('cw:toggleGangName', world, input[1], true)
                            Wait(1000)
                            openSetting(world)
                        end
                    elseif args.type == 'removeGang' then
                        ESX.TriggerServerEvent('cw:toggleGangName', world, args.gang, nil)
                        Wait(1000)
                        openSetting(world)
                    elseif args.type == 'newPlayer' then
                        local input = lib.inputDialog('Enter steam hex', {
                            {type = 'input', label = 'steam hex'},
                        })
                        if input and input[1] then
                            ESX.TriggerServerEvent('cw:togglePlayer', world, input[1], true)
                            Wait(1000)
                            openSetting(world)
                        end
                    elseif args.type == 'removePlayer' then
                        ESX.TriggerServerEvent('cw:togglePlayer', world, args.identifier, nil)
                        Wait(1000)
                        openSetting(world)
                    elseif args.type == 'expire' then
                        local input = lib.inputDialog('Tedad rooz ra vared konid', {
                            {type = 'number', label = 'Day'},
                        })
                        if input and input[1] then
                            ESX.TriggerServerEvent('cw:setExpireTS', world, input[1], true)
                            Wait(1000)
                            openSetting(world)
                        end
                    elseif args.type == 'delete' then
                        ESX.TriggerServerEvent('cw:delete', world, true)
                        Wait(1000)
                        TriggerEvent('cw:openManageMenu')
                    end
                end
            end)

            lib.showMenu('cw4')
        end
    end, world)
end

local function openManageMenu()
    ESX.TriggerServerCallback('cw:getConfig', function(config)
        lastConfig = config
        local options = {
            {label = 'جدید', args = 'new'}
        }

        local indices = {}
        for k in pairs(config) do
            table.insert(indices, k)
        end

        table.sort(indices)

        for _, index in ipairs(indices) do
            table.insert(options, {label = ('%s'):format(index), args = index})
        end

        lib.registerMenu({
            id = 'cw3',
            title = 'Manage',
            options = options
        }, function(selected, scrollIndex, args)
            if args == 'new' then
                local input = lib.inputDialog('Enter world', {
                    {type = 'number', label = 'World'},
                })
                if input and input[1] then
                    if config[input[1]] then
                        return ESX.chatMessage('In world vojood darad', 'alarms')
                    else
                        ESX.TriggerServerEvent('cw:addNew', tonumber(input[1]))
                        Wait(1000)
                        openManageMenu()
                    end
                end
            else
                openSetting(args)
            end
        end)
        lib.showMenu('cw3')
    end)
end

RegisterNetEvent('cw:openManageMenu', function()
    openManageMenu()
end)

RegisterNetEvent('cw:teleport', function(coords)
    CreateThread(function()
        local check = 0
        while check < 15 do
            check = check + 1

            TriggerEvent('es_admin:teleportUser', coords)
            TriggerEvent('event', false)
            TriggerEvent('DisableE',false)

            Wait(1000)
        end
    end)
    ESX.fadeScreen(15000)
end)