-- Pub by FleeX Team , https://discord.gg/87rGBxgCsa

local function openMenu(k)
    ESX.TriggerServerCallback('promo:getInfo', function(result)

        local options = {}
        table.insert(options, {label = '----- با ما در تماس باشید -----'})

        for k, v in pairs(result.phones) do
            table.insert(options, {label = ('%s %s(%s)'):format(v.label, v.phone, v.online and '🟢' or '🔴'),  args = v.phone})
        end
        table.insert(options, {label = '-----لیست قیمت ها-----'})
        for k, v in pairs(promoConfig.list[k].items) do
            if result.items[v] and tonumber(result.items[v]) > 0 then
                table.insert(options, {label = ('%s $%s'):format(ESX.getItemLabel(v), ESX.Math.GroupDigits(result.items[v])), icon = ('nui://sun-inventory-hud/ui/img/items/%s.png'):format(v), close = false})
            end
        end
        lib.registerMenu({
            id = 'promo1',
            title = 'List',
            options = options,
        }, function(selected, scrollIndex, args)
            if args then
                TriggerEvent('copyToClipboard', args)
                ESX.notification('inform', 'Dar clipboard copy shod')
            else
                ESX.notification('inform', 'Jahat kharid ya foroosh ba shomare haye bala tamas begirid')
            end
        end)
        lib.showMenu('promo1')

        ESX.registerExitPoint(5, function()
            lib.hideMenu()
        end)
    end, k)
end

local function openSetting(k)
    ESX.TriggerServerCallback('promo:getInfo', function(result)
        local options = {}
        for k, v in pairs(promoConfig.list[k].items) do
            if not result.items[v] then
                result.items[v] = 0
            end
            table.insert(options, {label = ('%s $%s'):format(ESX.getItemLabel(v), ESX.Math.GroupDigits(result.items[v])), icon = ('nui://sun-inventory-hud/ui/img/items/%s.png'):format(v), args = v})
        end
        lib.registerMenu({
            id = 'promo2',
            title = 'List',
            options = options,
        }, function(selected, scrollIndex, args)
            if args then
                local input = lib.inputDialog('Price ra vared konid', {
                    {type = 'input', label = 'Price'},
                })
                if input and input[1] then
                    local price = tonumber(input[1]) or 0
                    if price >= 0 and price < 1000000 then
                        TriggerServerEvent('promo:updatePrice', k, args, price)
                        Wait(1000)
                        openSetting(k)
                    else
                        ESX.chatMessage('Mablagh vared shode bayad zir 1M bashad', 'plarms')
                    end
                end
            end
        end)
        lib.showMenu('promo2')

        ESX.registerExitPoint(5, function()
            lib.hideMenu()
        end)
    end, k)
end


CreateThread(function()
    waitForLoad(10000)
    for k, v in pairs(promoConfig.list) do
        for k2, coords in pairs(v.coords) do
            createLocalPed(4, v.models[math.random(1, # v.models)], coords - vec(0, 0, 1, 0), function(ped)
                SetEntityAsMissionEntity(ped, true, true)
                SetBlockingOfNonTemporaryEvents(ped, true)
                FreezeEntityPosition(ped, true)
                SetEntityInvincible(ped, true)
                local options = {}
                table.insert(options, {
                    label = 'لیست💲',
                    onSelect = function()
                        if SUN.world == 0 then
                            openMenu(k)
                        end
                    end,
                })
                if ESX.TableContainsValue(v.owners, ESX.getIdentifier()) then
                    table.insert(options, {
                        label = 'تنظیمات',
                        onSelect = function()
                            if SUN.world == 0 then
                                openSetting(k)
                            end
                        end,
                    })
                end
                exports['ox_target']:addLocalEntity({ped}, options)
            end, function(ped)
                exports['ox_target']:removeLocalEntity(ped)
            end)
        end
    end
end)