ESX = nil

Citizen.CreateThread(function()
    while ESX == nil do
        TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
        Citizen.Wait(0)
    end
end)

function OpenSellMenuTailor()
    local options = {}

    ESX.TriggerServerCallback('getInventoryWithImagesTailor', function(inventory)
        for _, item in ipairs(inventory) do
            if item.count > 0 then
                table.insert(options, {
                    title = ("%s x%s"):format(item.label, item.count),
                    description = "$" .. item.price,
                    icon = item.image,
                    image = item.image,
                    onSelect = function()
                        local input = lib.inputDialog('Meghdar Brai Froush', {
                            {
                                type = 'number',
                                label = 'Meghdar',
                                description = 'Chand ta mikhay befroushi?',
                                min = 1,
                                max = item.count,
                                required = true
                            }
                        })

                        if input and tonumber(input[1]) and tonumber(input[1]) <= item.count then
                            TriggerServerEvent('item_shop_tailor:handleSell', item.name, tonumber(input[1]))
                        else
                            lib.notify({ position = 'center-right', title = "", description = "Meghdar Na Motabar", type = 'error', duration = 5000 })
                        end
                    end
                })
            end
        end

        if #options > 0 then
            lib.registerContext({
                id = 'sell_item_tailor_menu',
                title = 'Sell Item',
                options = options
            })

            lib.showContext('sell_item_tailor_menu')
        else
            lib.notify({ position = 'center-right', title = "", description = "Shoma Hich Item Brai Froush Nadarid", type = 'error', duration = 5000 })
        end
    end)
end

RegisterNetEvent('item_shop_tailor:openSellMenu')
AddEventHandler("item_shop_tailor:openSellMenu", function()
    OpenSellMenuTailor()
end)

Citizen.CreateThread(function()
    for k,v in pairs(SellerConfig.sellingLocationTailor) do
        RequestModel(GetHashKey(v.pedname))
        while not HasModelLoaded(GetHashKey(v.pedname)) do
            Wait(500)
        end
        Ped = CreatePed(v.pedtype, GetHashKey(v.pedname), v.x, v.y, v.z-1, v.h, false, false)
        SetEntityHeading(Ped, v.h)
        FreezeEntityPosition(Ped, true)
        SetEntityInvincible(Ped, true)
        SetBlockingOfNonTemporaryEvents(Ped, true)
    end

    for k,v in pairs(SellerConfig.sellingLocationTailor) do
        exports.ox_target:addBoxZone({
            coords = vec3(v.x, v.y, v.z),
            size = vec3(1.5, 1.5, 1.5),
            rotation = 45,
            debug = drawZones,
            options = {
                {
                    name = 'Sell Item',
                    event = 'item_shop_tailor:openSellMenu',
                    icon = 'fa-solid fa-cart-shopping',
                    label = 'Sell Item',
                }
            }
        })
    end
end)

function OpenSellMenuLumberjack()
    local options = {}

    ESX.TriggerServerCallback('getInventoryWithImagesLumberjack', function(inventory)
        for _, item in ipairs(inventory) do
            if item.count > 0 then
                table.insert(options, {
                    title = ("%s x%s"):format(item.label, item.count),
                    description = "$" .. item.price,
                    icon = item.image,
                    image = item.image,
                    onSelect = function()
                        local input = lib.inputDialog('Meghdar Brai Froush', {
                            {
                                type = 'number',
                                label = 'Meghdar',
                                description = 'Chand ta mikhay befroushi?',
                                min = 1,
                                max = item.count,
                                required = true
                            }
                        })

                        if input and tonumber(input[1]) and tonumber(input[1]) <= item.count then
                            TriggerServerEvent('item_shop_lumberjack:handleSell', item.name, tonumber(input[1]))
                        else
                            lib.notify({ position = 'center-right', title = "", description = "Meghdar Na Motabar", type = 'error', duration = 5000 })
                        end
                    end
                })
            end
        end

        if #options > 0 then
            lib.registerContext({
                id = 'sell_item_lumberjack_menu',
                title = 'Sell Item',
                options = options
            })

            lib.showContext('sell_item_lumberjack_menu')
        else
            lib.notify({ position = 'center-right', title = "", description = "Shoma Hich Item Brai Froush Nadarid", type = 'error', duration = 5000 })
        end
    end)
end

RegisterNetEvent('item_shop_lumberjack:openSellMenu')
AddEventHandler("item_shop_lumberjack:openSellMenu", function()
    OpenSellMenuLumberjack()
end)

Citizen.CreateThread(function()
    for k,v in pairs(SellerConfig.sellingLocationLumberjack) do
        RequestModel(GetHashKey(v.pedname))
        while not HasModelLoaded(GetHashKey(v.pedname)) do
            Wait(500)
        end
        Ped = CreatePed(v.pedtype, GetHashKey(v.pedname), v.x, v.y, v.z-1, v.h, false, false)
        SetEntityHeading(Ped, v.h)
        FreezeEntityPosition(Ped, true)
        SetEntityInvincible(Ped, true)
        SetBlockingOfNonTemporaryEvents(Ped, true)
    end

    for k,v in pairs(SellerConfig.sellingLocationLumberjack) do
        exports.ox_target:addBoxZone({
            coords = vec3(v.x, v.y, v.z),
            size = vec3(1.5, 1.5, 1.5),
            rotation = 45,
            debug = drawZones,
            options = {
                {
                    name = 'Sell Item',
                    event = 'item_shop_lumberjack:openSellMenu',
                    icon = 'fa-solid fa-cart-shopping',
                    label = 'Sell Item',
                }
            }
        })
    end
end)

function OpenSellMenuSlaughterer()
    local options = {}

    ESX.TriggerServerCallback('getInventoryWithImagesSlaughterer', function(inventory)
        for _, item in ipairs(inventory) do
            if item.count > 0 then
                table.insert(options, {
                    title = ("%s x%s"):format(item.label, item.count),
                    description = "$" .. item.price,
                    icon = item.image,
                    image = item.image,
                    onSelect = function()
                        local input = lib.inputDialog('Meghdar Brai Froush', {
                            {
                                type = 'number',
                                label = 'Meghdar',
                                description = 'Chand ta mikhay befroushi?',
                                min = 1,
                                max = item.count,
                                required = true
                            }
                        })

                        if input and tonumber(input[1]) and tonumber(input[1]) <= item.count then
                            TriggerServerEvent('item_shop_slaughterer:handleSell', item.name, tonumber(input[1]))
                        else
                            lib.notify({ position = 'center-right', title = "", description = "Meghdar Na Motabar", type = 'error', duration = 5000 })
                        end
                    end
                })
            end
        end

        if #options > 0 then
            lib.registerContext({
                id = 'sell_item_slaughterer_menu',
                title = 'Sell Item',
                options = options
            })

            lib.showContext('sell_item_slaughterer_menu')
        else
            lib.notify({ position = 'center-right', title = "", description = "Shoma Hich Item Brai Froush Nadarid", type = 'error', duration = 5000 })
        end
    end)
end

RegisterNetEvent('item_shop_slaughterer:openSellMenu')
AddEventHandler("item_shop_slaughterer:openSellMenu", function()
    OpenSellMenuSlaughterer()
end)

Citizen.CreateThread(function()
    for k,v in pairs(SellerConfig.sellingLocationSlaughterer) do
        RequestModel(GetHashKey(v.pedname))
        while not HasModelLoaded(GetHashKey(v.pedname)) do
            Wait(500)
        end
        Ped = CreatePed(v.pedtype, GetHashKey(v.pedname), v.x, v.y, v.z-1, v.h, false, false)
        SetEntityHeading(Ped, v.h)
        FreezeEntityPosition(Ped, true)
        SetEntityInvincible(Ped, true)
        SetBlockingOfNonTemporaryEvents(Ped, true)
    end

    for k,v in pairs(SellerConfig.sellingLocationSlaughterer) do
        exports.ox_target:addBoxZone({
            coords = vec3(v.x, v.y, v.z),
            size = vec3(1.5, 1.5, 1.5),
            rotation = 45,
            debug = drawZones,
            options = {
                {
                    name = 'Sell Item',
                    event = 'item_shop_slaughterer:openSellMenu',
                    icon = 'fa-solid fa-cart-shopping',
                    label = 'Sell Item',
                }
            }
        })
    end
end)

function OpenSellMenuFueler()
    local options = {}


    ESX.TriggerServerCallback('getInventoryWithImagesFueler', function(inventory)
        for _, item in ipairs(inventory) do
            if item.count > 0 then

                table.insert(options, {
                    title = ("%s x%s"):format(item.label, item.count),
                    description = "$" .. item.price,
                    icon = item.image,
                    image = item.image,
                    onSelect = function()

                        local input = lib.inputDialog('Meghdar Brai Froush', {
                            {
                                type = 'number',
                                label = 'Meghdar',
                                description = 'Chand ta mikhay befroushi?',
                                min = 1,
                                max = item.count,
                                required = true
                            }
                        })

                        if input and tonumber(input[1]) and tonumber(input[1]) <= item.count then

                            TriggerServerEvent('item_shop_fueler:handleSell', item.name, tonumber(input[1]))
                        else
                            lib.notify({ position = 'center-right', title = "", description = "Meghdar Na Motabar", type = 'error', duration = 5000 })
                        end
                    end
                })
            end
        end

        if #options > 0 then
            lib.registerContext({
                id = 'sell_item_fueler_menu',
                title = 'Sell Item',
                options = options
            })


            lib.showContext('sell_item_fueler_menu')
        else
            lib.notify({ position = 'center-right', title = "", description = "Shoma Hich Item Brai Froush Nadarid", type = 'error', duration = 5000 })
        end
    end)
end

RegisterNetEvent('item_shop_fueler:openSellMenu')
AddEventHandler("item_shop_fueler:openSellMenu", function()
    OpenSellMenuFueler()
end)

Citizen.CreateThread(function()
    for k,v in pairs(SellerConfig.sellingLocationFueler) do
        RequestModel(GetHashKey(v.pedname))
        while not HasModelLoaded(GetHashKey(v.pedname)) do
            Wait(500)
        end
        Ped = CreatePed(v.pedtype, GetHashKey(v.pedname), v.x, v.y, v.z-1, v.h, false, false)
        SetEntityHeading(Ped, v.h)
        FreezeEntityPosition(Ped, true)
        SetEntityInvincible(Ped, true)
        SetBlockingOfNonTemporaryEvents(Ped, true)
    end

    for k,v in pairs(SellerConfig.sellingLocationFueler) do
        exports.ox_target:addBoxZone({
            coords = vec3(v.x, v.y, v.z),
            size = vec3(1.5, 1.5, 1.5),
            rotation = 45,
            debug = drawZones,
            options = {
                {
                    name = 'Sell Item',
                    event = 'item_shop_fueler:openSellMenu',
                    icon = 'fa-solid fa-cart-shopping',
                    label = 'Sell Item',
                }
            }
        })
    end
end)

function OpenSellMenuLaster()
    ESX.TriggerServerCallback('getInventoryWithImagesLaster', function(inventory)
        local elements = {}

        for _, item in ipairs(inventory) do
            if item.count > 0 then
                table.insert(elements, {
                    title = ("%s x%s"):format(item.label, item.count),
                    description = "$" .. item.price,
                    icon = item.image,
                    image = item.image,
                    onSelect = function()
                        local input = lib.inputDialog('Meghdar Brai Froush', {
                            {
                                type = 'number',
                                label = 'Meghdar',
                                description = 'Chand ta mikhay befroushi?',
                                min = 1,
                                max = item.count,
                                required = true
                            }
                        })

                        if input and tonumber(input[1]) and tonumber(input[1]) <= item.count then
                            TriggerServerEvent('item_shop_laster:handleSell', item.name, tonumber(input[1]))
                        else
                            lib.notify({ position = 'center-right', title = "", description = "Meghdar Na Motabar", type = 'error', duration = 5000 })
                        end
                    end

                })
            end
        end

        if #elements > 0 then
            lib.registerContext({
                id = 'sell_items_menu_laster',
                title = 'Sell Item',
                options = elements
            })

            lib.showContext('sell_items_menu_laster')
        else
            lib.notify({ position = 'center-right', title = "", description = "Shoma Hich Item Brai Froush Nadarid", type = 'error', duration = 5000 })
        end
    end)
end

RegisterNetEvent('item_shop_laster:openSellMenu')
AddEventHandler("item_shop_laster:openSellMenu", function()
    OpenSellMenuLaster()
end)

Citizen.CreateThread(function()
    for _, v in pairs(SellerConfig.sellingLocationLaster) do
        RequestModel(GetHashKey(v.pedname))
        while not HasModelLoaded(GetHashKey(v.pedname)) do Wait(500) end

        local ped = CreatePed(v.pedtype, GetHashKey(v.pedname), v.x, v.y, v.z-1, v.h, false, false)
        SetEntityHeading(ped, v.h)
        FreezeEntityPosition(ped, true)
        SetEntityInvincible(ped, true)
        SetBlockingOfNonTemporaryEvents(ped, true)
    end

    for _, v in pairs(SellerConfig.sellingLocationLaster) do
        exports.ox_target:addBoxZone({
            coords = vec3(v.x, v.y, v.z),
            size = vec3(1.5, 1.5, 1.5),
            rotation = 45,
            debug = drawZones,
            options = {
                {
                    name = 'sell_item_laster',
                    event = 'item_shop_laster:openSellMenu',
                    icon = 'fa-solid fa-cart-shopping',
                    label = 'Sell Item',
                }
            }
        })
    end
end)

Citizen.CreateThread(function()
    for _, location in pairs(SellerConfig.sellingLocationLaster) do
        if location.enableBlip then
            local blip = AddBlipForCoord(location.x, location.y, location.z)
            SetBlipSprite(blip, 77)
            SetBlipDisplay(blip, 4)
            SetBlipScale(blip, 0.7)
            SetBlipColour(blip, 1)
            SetBlipAsShortRange(blip, true)
            BeginTextCommandSetBlipName("STRING")
            AddTextComponentSubstringPlayerName("Lester")
            EndTextCommandSetBlipName(blip)
        end
    end
end)

function OpenSellMenuMiner()
    local options = {}


    ESX.TriggerServerCallback('getInventoryWithImagesMiner', function(inventory)
        for _, item in ipairs(inventory) do
            if item.count > 0 then

                table.insert(options, {
                    title = ("%s x%s"):format(item.label, item.count),
                    description = "$" .. item.price,
                    icon = item.image,
                    image = item.image,
                    onSelect = function()

                        local input = lib.inputDialog('Meghdar Brai Froush', {
                            {
                                type = 'number',
                                label = 'Meghdar',
                                description = 'Chand ta mikhay befroushi?',
                                min = 1,
                                max = item.count,
                                required = true
                            }
                        })

                        if input and tonumber(input[1]) and tonumber(input[1]) <= item.count then

                            TriggerServerEvent('item_miner:handleSell', item.name, tonumber(input[1]))
                        else
                            lib.notify({ position = 'center-right', title = "", description = "Meghdar Na Motabar", type = 'error', duration = 5000 })
                        end
                    end
                })
            end
        end

        if #options > 0 then
            lib.registerContext({
                id = 'sell_item_miner_menu',
                title = 'Sell Item',
                options = options
            })


            lib.showContext('sell_item_miner_menu')
        else
            lib.notify({ position = 'center-right', title = "", description = "Shoma Hich Item Brai Froush Nadarid", type = 'error', duration = 5000 })
        end
    end)
end

RegisterNetEvent('item_miner:openSellMenu')
AddEventHandler("item_miner:openSellMenu", function()
    OpenSellMenuMiner()
end)

Citizen.CreateThread(function()
    for k,v in pairs(SellerConfig.sellingLocationMiner) do
        RequestModel(GetHashKey(v.pedname))
        while not HasModelLoaded(GetHashKey(v.pedname)) do
            Wait(500)
        end
        Ped = CreatePed(v.pedtype, GetHashKey(v.pedname), v.x, v.y, v.z-1, v.h, false, false)
        SetEntityHeading(Ped, v.h)
        FreezeEntityPosition(Ped, true)
        SetEntityInvincible(Ped, true)
        SetBlockingOfNonTemporaryEvents(Ped, true)
    end

    for k,v in pairs(SellerConfig.sellingLocationMiner) do
        exports.ox_target:addBoxZone({
            coords = vec3(v.x, v.y, v.z),
            size = vec3(1.5, 1.5, 1.5),
            rotation = 45,
            debug = drawZones,
            options = {
                {
                    name = 'Miner Shop',
                    event = 'item_miner:openSellMenu',
                    icon = 'fa-solid fa-cart-shopping',
                    label = 'Miner Shop',
                }
            }
        })
    end
end)

function OpenSellMenuSeparated()
    local options = {}


    ESX.TriggerServerCallback('getInventoryWithImagesSeparated', function(inventory)
        for _, item in ipairs(inventory) do
            if item.count > 0 then

                table.insert(options, {
                    title = ("%s x%s"):format(item.label, item.count),
                    description = "$" .. item.price,
                    icon = item.image,
                    image = item.image,
                    onSelect = function()

                        local input = lib.inputDialog('Meghdar Brai Froush', {
                            {
                                type = 'number',
                                label = 'Meghdar',
                                description = 'Chand ta mikhay befroushi?',
                                min = 1,
                                max = item.count,
                                required = true
                            }
                        })

                        if input and tonumber(input[1]) and tonumber(input[1]) <= item.count then

                            TriggerServerEvent('item_shop_separated:handleSell', item.name, tonumber(input[1]))
                        else
                            lib.notify({ position = 'center-right', title = "", description = "Meghdar Na Motabar", type = 'error', duration = 5000 })
                        end
                    end
                })
            end
        end

        if #options > 0 then
            lib.registerContext({
                id = 'sell_item_separated_menu',
                title = 'Sell Item',
                options = options
            })


            lib.showContext('sell_item_separated_menu')
        else
            lib.notify({ position = 'center-right', title = "", description = "Shoma Hich Item Brai Froush Nadarid", type = 'error', duration = 5000 })
        end
    end)
end

RegisterNetEvent('item_shop_separated:openSellMenu')
AddEventHandler("item_shop_separated:openSellMenu", function()
    OpenSellMenuSeparated()
end)

Citizen.CreateThread(function()
    for k,v in pairs(SellerConfig.sellingLocationSeparated) do
        RequestModel(GetHashKey(v.pedname))
        while not HasModelLoaded(GetHashKey(v.pedname)) do
            Wait(500)
        end
        Ped = CreatePed(v.pedtype, GetHashKey(v.pedname), v.x, v.y, v.z-1, v.h, false, false)
        SetEntityHeading(Ped, v.h)
        FreezeEntityPosition(Ped, true)
        SetEntityInvincible(Ped, true)
        SetBlockingOfNonTemporaryEvents(Ped, true)
    end

    for k,v in pairs(SellerConfig.sellingLocationSeparated) do
        exports.ox_target:addBoxZone({
            coords = vec3(v.x, v.y, v.z),
            size = vec3(1.5, 1.5, 1.5),
            rotation = 45,
            debug = drawZones,
            options = {
                {
                    name = 'Sell Item',
                    event = 'item_shop_separated:openSellMenu',
                    icon = 'fa-solid fa-cart-shopping',
                    label = 'Sell Item',
                }
            }
        })
    end
end)

function OpenSellMenuDrugdealer2()
    local options = {}


    ESX.TriggerServerCallback('getInventoryWithImagesdrugdealer2', function(inventory)
        for _, item in ipairs(inventory) do
            if item.count > 0 then

                table.insert(options, {
                    title = ("%s x%s"):format(item.label, item.count),
                    description = "$" .. item.price,
                    icon = item.image,
                    image = item.image,
                    onSelect = function()

                        local input = lib.inputDialog('Meghdar Brai Froush', {
                            {
                                type = 'number',
                                label = 'Meghdar',
                                description = 'Chand ta mikhay befroushi?',
                                min = 1,
                                max = item.count,
                                required = true
                            }
                        })

                        if input and tonumber(input[1]) and tonumber(input[1]) <= item.count then

                            TriggerServerEvent('item_shop_drugdealer2:handleSell', item.name, tonumber(input[1]))
                        else
                            lib.notify({ position = 'center-right', title = "", description = "Meghdar Na Motabar", type = 'error', duration = 5000 })
                        end
                    end
                })
            end
        end

        if #options > 0 then
            lib.registerContext({
                id = 'sell_item_drugdealer2_menu',
                title = 'Sell Item',
                options = options
            })


            lib.showContext('sell_item_drugdealer2_menu')
        else
            lib.notify({ position = 'center-right', title = "", description = "Shoma Hich Item Brai Froush Nadarid", type = 'error', duration = 5000 })
        end
    end)
end

RegisterNetEvent('item_shop_drugdealer2:openSellMenu')
AddEventHandler("item_shop_drugdealer2:openSellMenu", function()
    OpenSellMenuDrugdealer2()
end)

Citizen.CreateThread(function()
    for k,v in pairs(SellerConfig.sellingLocationDrugdealer2) do
        RequestModel(GetHashKey(v.pedname))
        while not HasModelLoaded(GetHashKey(v.pedname)) do
            Wait(500)
        end
        Ped = CreatePed(v.pedtype, GetHashKey(v.pedname), v.x, v.y, v.z-1, v.h, false, false)
        SetEntityHeading(Ped, v.h)
        FreezeEntityPosition(Ped, true)
        SetEntityInvincible(Ped, true)
        SetBlockingOfNonTemporaryEvents(Ped, true)
    end

    for k,v in pairs(SellerConfig.sellingLocationDrugdealer2) do
        exports.ox_target:addBoxZone({
            coords = vec3(v.x, v.y, v.z),
            size = vec3(1.5, 1.5, 1.5),
            rotation = 45,
            debug = drawZones,
            options = {
                {
                    name = 'Drug Dealer',
                    event = 'item_shop_drugdealer2:openSellMenu',
                    icon = 'fa-solid fa-cart-shopping',
                    label = 'Drug Dealer',
                }
            }
        })
    end
end)

Citizen.CreateThread(function()
    for _, location in pairs(SellerConfig.sellingLocationDrugdealer2) do
        if location.enableBlip then
            local blip = AddBlipForCoord(location.x, location.y, location.z)
            SetBlipSprite(blip, 355)
            SetBlipDisplay(blip, 4)
            SetBlipScale(blip, 0.7)
            SetBlipColour(blip, 30)
            SetBlipAsShortRange(blip, true)
            BeginTextCommandSetBlipName("STRING")
            AddTextComponentSubstringPlayerName("Drug Dealer")
            EndTextCommandSetBlipName(blip)
        end
    end
end)