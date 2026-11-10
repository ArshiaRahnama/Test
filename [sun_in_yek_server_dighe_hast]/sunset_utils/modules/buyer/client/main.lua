-- Pub by FleeX Team , https://discord.gg/87rGBxgCsa

local function openSellMenu(k)
    local options = {}
    for k, v in pairs(buyerConfig[k].buyItems) do
        if ESX.DoesHaveItem2(v.name, 1) then
            table.insert(options, {label = ('%s x%s $%s %s'):format(ESX.getItemLabel(v.name), ESX.getItemCount(v.name), ESX.Math.GroupDigits(v.price), (v.black and '(Black Money)' or '')), icon = ('nui://sun-inventory-hud/ui/img/items/%s.png'):format(v.name), args = v.name})
        end
    end
    if #options == 0 then
        table.insert(options, {label = 'Itemi baraye forush nadarid!'})
    end
    lib.registerMenu({
        id = 'buyerMenu1',
        title = 'Forush',
        options = options,
    }, function(selected, scrollIndex, args)
        local input = lib.inputDialog('Foroush Item', {
            {type = 'number', label = 'Tedad', icon = 'hashtag', min = 1, max = ESX.getItemCount(args), required = true},
        })
        if input and input[1] then
            if input[1] > ESX.getItemCount(args) then
                input[1] = ESX.getItemCount(args)
            end
            ESX.TriggerServerEvent('buyer:sell', k, args, input[1])
        end
    end)
    lib.showMenu('buyerMenu1')
end

local function openBuyMenu(k)
    local options = {}
    for k, v in pairs(buyerConfig[k].sellItem) do
        table.insert(options, {label = ('%s $%s'):format(ESX.getItemLabel(v.name), ESX.Math.GroupDigits(v.price)), icon = ('nui://sun-inventory-hud/ui/img/items/%s.png'):format(v.name), args = v.name})
    end
    lib.registerMenu({
        id = 'buyerMenu2',
        title = 'Kharid Item',
        options = options,
    }, function(selected, scrollIndex, args)
        local count = 1
        if not args:find('WEAPON_') then
            local input = lib.inputDialog('Kharid Item', {
                {type = 'number', label = 'Tedad', icon = 'hashtag', min = 1, required = true},
            })
            count = input[1]
        end
        if count then
            ESX.TriggerServerEvent('buyer:buy', k, args, count)
        end
    end)
    lib.showMenu('buyerMenu2')
end

CreateThread(function()
    waitForLoad()
    for k, v in pairs(buyerConfig) do
        for k2, v2 in pairs(v.coords) do
            createLocalPed(4, v.model, v2 - vec(0, 0, 1, 0), function(ped)
                SetEntityAsMissionEntity(ped)
                SetBlockingOfNonTemporaryEvents(ped, true)
                FreezeEntityPosition(ped, true)
                SetEntityInvincible(ped, true)
                local options = {}
                if v.buyItems then
                    table.insert(options, {
                        label = 'Sell💲',
                        onSelect = function()
                            if SUN.world == 0 then
                                openSellMenu(k)
                                ESX.registerExitPoint(5, function()
                                    lib.hideMenu()
                                end)
                            end
                        end,
                    })
                end
                if v.sellItem then
                    table.insert(options, {
                        label = 'Buy💲',
                        onSelect = function()
                            if SUN.world == 0 then
                                openBuyMenu(k)
                                ESX.registerExitPoint(5, function()
                                    lib.hideMenu()
                                end)
                            end
                        end,
                    })
                end
                exports['ox_target']:addLocalEntity(ped, options)
            end, function(ped)
                exports['ox_target']:removeLocalEntity(ped)
            end)
        end
    end
end)