-- Pub by FleeX Team , https://discord.gg/87rGBxgCsa

local currentAddSession, lastJobItems, currentVehicle, currentPostalVehicle = {addedItem = {}}, {}

local function openMenu()
    local options = {
        {label = 'List item haye bar zade shode', icon = 'basket-shopping', close = false}
    }
    if ESX.tableLength(currentAddSession.addedItem) > 0 then
        table.insert(options, {label = 'Taeed', icon = 'clipboard-check', iconColor = 'green', args = {confirm = true}})
    end
    for k, v in pairs(currentAddSession.addedItem) do
        table.insert(options, {label = ('%s x%s'):format(v.label, v.count), icon = ('nui://sun-inventory-hud/ui/img/items/%s.png'):format(v.name), close = false})
    end
    table.insert(options, {label = 'List item haye ghabel bar zadan', icon = 'cart-plus', iconColor = 'orange', close = false})
    lastJobItems = exports['sun-inventory-hud']:getJobInventory('resturan')
    for k, v in pairs(lastJobItems.items) do
        if not v.locked then
            table.insert(options, {label = ('%s x%s'):format(v.data.label, v.count), icon = ('nui://sun-inventory-hud/ui/img/items/%s.png'):format(v.name), args = v})
        end
    end
    lib.setMenuOptions('deliverySet', options)
    lib.showMenu('deliverySet')
end

local function createZones()
    for k, v in pairs(Shared.taxi.delivery.startLocations) do
        if ESX.PlayerData.job.name == 'taxi' or (v.access[ESX.PlayerData.job.name] and ESX.PlayerData.job.grade >= v.access[ESX.PlayerData.job.name]) then
            if not v.created then
                v.created = true
                v.blip = ESX.AddBlipForCoord(v.coords, 0.7, 750, 5, 'Barbari', 4)
                ESX.RegisterPoint(v.coords, 3,{
                    Color = {R = 255,G = 255,B = 0,A = 255},
                    DrawDistance = 5,
                    Radius = 2.5,
                    Type = 21
                },{
                    textUI = {text = '[E] Bar zadan mashin', data = {icon = 'envelopes-bulk', style = {}}},
                    Key = 'e',
                    CB = function()
                        if ESX.PlayerData.job.name == 'taxi' or (v.access[ESX.PlayerData.job.name] and ESX.PlayerData.job.grade >= v.access[ESX.PlayerData.job.name]) then
                            local vehicle = ESX.isVehicleDriver()
                            if vehicle then
                                if Shared.taxi.delivery.vehicleModels[GetEntityModel(vehicle)]  then
                                    if (v.access[ESX.PlayerData.job.name] and ESX.PlayerData.job.grade >= v.access[ESX.PlayerData.job.name]) and exports['sun-society']:doesHavePerm('delivery') then
                                        if not Entity(vehicle).state.deliveryData then
                                            local alert = lib.alertDialog({
                                                header = '',
                                                content = 'Aya mayel be bar zadan in mashin hastid?',
                                                centered = true,
                                                cancel = true,
                                                labels = {
                                                    confirm = 'Bale',
                                                    cancel = 'Kheir',
                                                },
                                            })
                                            if alert == 'confirm' then
                                                currentAddSession, currentVehicle = {addedItem = {}, zoneData = v}, vehicle
                                                openMenu()
                                            end
                                        else
                                            ESX.chatMessage('In mashin dar hale hazer bar darad', 'plarms')
                                        end
                                    else
                                        ESX.chatMessage('Shoma dastresi bar zadan ra nadarid', 'plarms')
                                    end
                                else
                                    ESX.chatMessage('Nemitavanid ba in mashin bar bari konid', 'plarms')
                                end
                            else
                                ESX.chatMessage('Bayad savar mashin bashid', 'plarms')
                            end
                        end
                    end,
                },{
                    In = nil,
                    Out = function()
                        ESX.UI.Menu.CloseAll()
                    end
                })
            end
        end
    end
end

RegisterNetEvent('esx:setJob', function(job)
    Wait(1000)
    createZones()
end)


-- RegisterCommand('testmenu', function()
--     openMenu()
-- end, false)

CreateThread(function()
    repeat Wait(100) until playerLoaded
    createZones()
    while not lib do Wait(100) end
    lib.registerMenu({
        id = 'deliverySet',
        title = 'Bar zadan jens',
        options = {},
        disableInput = true,
    }, function(selected, scrollIndex, args)
        if args.confirm then
            ::back::
            local input = lib.inputDialog('Code posti maghsad ra vared konid', {{type = 'number', label = 'Code', required = true}})
            if input and input[1] then
                local code = input[1]
                if Shared.taxi.delivery.endLocations[code] then
                    local alert = lib.alertDialog({
                        header = '',
                        content = ('Maghsad [%s] ast, Aya taeed mikonid?'):format(Shared.taxi.delivery.endLocations[code].label),
                        centered = true,
                        cancel = true,
                        labels = {
                            confirm = 'Bale',
                            cancel = 'Kheir',
                        },
                    })
                    if alert == 'confirm' then
                        ESX.TriggerServerEvent('taxi:delivery:register', currentAddSession.zoneData, currentAddSession.addedItem, code, NetworkGetNetworkIdFromEntity(currentVehicle))
                        lib.notify({
                            title = 'OK',
                            description = 'Mashin ba movafaghiat bar zade shod',
                            type = 'success',
                            position = 'center-right',
                            duration = 10000,
                        })
                    else
                        goto back
                    end
                else
                    lib.notify({
                        title = 'Code posti',
                        description = 'Code posti vared shode na motabar ast',
                        type = 'error',
                        position = 'center-right',
                        duration = 10000,
                    })
                    goto back
                end
            end
        else
            if not currentAddSession.addedItem[args.name] or currentAddSession.addedItem[args.name].count < args.count then
                local input = lib.inputDialog('Tedad mored nazar ra vared konid', {{type = 'number', label = 'Tedad', min = 0, max = args.count, required = true}})
                if input and input[1] > 0 then
                    currentAddSession.addedItem[args.name] = {name = args.name, label = args.data.label, count = (currentAddSession.addedItem[args.name] and currentAddSession.addedItem[args.name].count or 0) + input[1]}
                    if currentAddSession.addedItem[args.name].count > args.count then
                        currentAddSession.addedItem[args.name].count = args.count
                    end
                end
            else
                lib.notify({
                    title = 'Limit',
                    description = 'Shoma had aksar tedad momken ra gozashtid',
                    type = 'error',
                    position = 'center-right',
                    duration = 10000,
                })
            end
            openMenu()
        end
    end)
end)

AddEventHandler('enterVehicle', function(vehicle, isDriver)
    if isDriver and ESX.PlayerData.job.name == 'taxi' then
        if Entity(vehicle).state.deliveryData and exports['sun-society']:doesHavePerm('delivery') then
            local data = Entity(vehicle).state.deliveryData
            currentPostalVehicle = vehicle
            local endPointData = Shared.taxi.delivery.endLocations[data.postalCode]
            local blip = AddBlipForCoord(endPointData.coords.x, endPointData.coords.y, endPointData.coords.z)
            SetBlipSprite(blip, 652)
            SetBlipColour(blip, 5)
            SetBlipScale(blip, 1.0)
            SetBlipDisplay(blip, 6)
            SetBlipRoute(blip, true)
            SetBlipRouteColour(blip, 5)
            CreateThread(function()
                local textUI = false
                while currentPostalVehicle == vehicle do
                    local distance = #(GetEntityCoords(PlayerPedId()) - endPointData.coords)
                    if distance < 100 then
                        DrawMarker(24, endPointData.coords.x, endPointData.coords.y, endPointData.coords.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 3.5, 3.5, 2.5, 255, 255, 0, 150, true, true)
                        if distance < 5 then
                            SetVehicleForwardSpeed(vehicle, 0)
                            if lib.progressCircle({
                                duration = 25000,
                                position = 'middle',
                                useWhileDead = false,
                                canCancel = false,
                                allowRagdoll = true,
                                allowFalling = true,
                                disable = {
                                    car = true,
                                    move = true,
                                    combat = true,
                                },
                            }) then
                                ESX.TriggerServerEvent('taxi:delivery:finish', data.id)
                                break
                            end
                        end
                    end
                    Wait(0)
                end
                RemoveBlip(blip)
            end)
        end
    end
end)

AddEventHandler('exitVehicle', function()
    currentPostalVehicle = nil
end)