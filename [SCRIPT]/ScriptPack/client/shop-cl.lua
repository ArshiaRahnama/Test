ESX = nil

Citizen.CreateThread(function()
    while ESX == nil do
        TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
    Citizen.Wait(0)
    end
end)

function OpenBuyMenuShops()
    local options = {}


    ESX.TriggerServerCallback('getitemsForSaleShops', function(itemsForSaleShops)
        for _, item in ipairs(itemsForSaleShops) do

            table.insert(options, {
                title = ("%s ($%s)"):format(item.label, item.price),
                description = 'Click to Buy',
                icon = item.image,
                image = item.image,
                onSelect = function()

                    local input = lib.inputDialog('Meghdar Baraye Kharid', {
                        {
                            type = 'number',
                            label = 'Meghdar',
                            description = 'Chand ta mikhay bekhari?',
                            min = 1,
                            required = true
                        }
                    })

                    if input and tonumber(input[1]) and tonumber(input[1]) > 0 then

                        TriggerServerEvent('shops_item:buy_shops', item.name, tonumber(input[1]), item.price)
                    else
                        lib.notify({ position = 'center-right', title = "", description = "Meghdar Na Motabar", type = 'error', duration = 5000 })
                    end
                end
            })
        end

        if #options > 0 then
            lib.registerContext({
                id = 'buy_item_shops_menu',
                title = 'Buy Item',
                options = options
            })


            lib.showContext('buy_item_shops_menu')
        else
            lib.notify({ position = 'center-right', title = "", description = "Item Baraye Kharid Mojod Nist", type = 'error', duration = 5000 })
        end
    end)
end

RegisterNetEvent('shops_openmenu')
AddEventHandler("shops_openmenu", function()
    OpenBuyMenuShops()
end)

Citizen.CreateThread(function()
    for k,v in pairs(ShopConfig.sellingLocationShops) do
        RequestModel(GetHashKey(v.pedname))
        while not HasModelLoaded(GetHashKey(v.pedname)) do
            Wait(500)
        end
        Ped = CreatePed(v.pedtype,  GetHashKey(v.pedname), v.x, v.y, v.z-1, v.h, false, false)
        SetEntityHeading(Ped, v.h)
        FreezeEntityPosition(Ped, true)
        SetEntityInvincible(Ped, true)
        SetBlockingOfNonTemporaryEvents(Ped, true)
    end

    for k,v in pairs(ShopConfig.sellingLocationShops) do
        exports.ox_target:addBoxZone({
            coords = vec3(v.x, v.y, v.z),
            size = vec3(1.5, 1.5, 1.5),
            rotation = 45,
            debug = drawZones,
            options = {
                {
                    name = 'Shop',
                    event = 'shops_openmenu',
                    icon = 'fa-solid fa-cart-shopping',
                    label = 'Shop',
                }
            }
        })
    end
end)

function OpenBuyMenuMC()
    local options = {}


    ESX.TriggerServerCallback('getitemsForSaleMC', function(itemsForSaleMC)
        for _, item in ipairs(itemsForSaleMC) do

            table.insert(options, {
                title = ("%s ($%s)"):format(item.label, item.price),
                description = 'Click to Buy',
                icon = item.image,
                image = item.image,
                onSelect = function()

                    local input = lib.inputDialog('Meghdar Baraye Kharid', {
                        {
                            type = 'number',
                            label = 'Meghdar',
                            description = 'Chand ta mikhay bekhari?',
                            min = 1,
                            required = true
                        }
                    })

                    if input and tonumber(input[1]) and tonumber(input[1]) > 0 then

                        TriggerServerEvent('mc_item:buy_mc', item.name, tonumber(input[1]), item.price)
                    else
                        lib.notify({ position = 'center-right', title = "", description = "Meghdar Na Motabar", type = 'error', duration = 5000 })
                    end
                end
            })
        end

        if #options > 0 then
            lib.registerContext({
                id = 'buy_item_mc_menu',
                title = 'Buy Item',
                options = options
            })


            lib.showContext('buy_item_mc_menu')
        else
            lib.notify({ position = 'center-right', title = "", description = "Item Baraye Kharid Mojod Nist", type = 'error', duration = 5000 })
        end
    end)
end

RegisterNetEvent('mc_openmenu')
AddEventHandler("mc_openmenu", function()
    OpenBuyMenuMC()
end)

Citizen.CreateThread(function()
    for k,v in pairs(ShopConfig.sellingLocationMC) do
        RequestModel(GetHashKey(v.pedname))
        while not HasModelLoaded(GetHashKey(v.pedname)) do
            Wait(500)
        end
        Ped = CreatePed(v.pedtype,  GetHashKey(v.pedname), v.x, v.y, v.z-1, v.h, false, false)
        SetEntityHeading(Ped, v.h)
        FreezeEntityPosition(Ped, true)
        SetEntityInvincible(Ped, true)
        SetBlockingOfNonTemporaryEvents(Ped, true)
    end

    for k,v in pairs(ShopConfig.sellingLocationMC) do
        exports.ox_target:addBoxZone({
            coords = vec3(v.x, v.y, v.z),
            size = vec3(1.5, 1.5, 1.5),
            rotation = 45,
            debug = drawZones,
            options = {
                {
                    name = 'Mechanic Shop',
                    event = 'mc_openmenu',
                    icon = 'fa-solid fa-cart-shopping',
                    label = 'Mechanic Shop',
                }
            }
        })
    end
end)

function OpenBuyMenuNarekshop()
    local options = {}


    ESX.TriggerServerCallback('getitemsForSaleNarekshop', function(itemsForSaleNarekshop)
        for _, item in ipairs(itemsForSaleNarekshop) do

            table.insert(options, {
                title = ("%s ($%s)"):format(item.label, item.price),
                description = 'Click to Buy',
                icon = item.image,
                image = item.image,
                onSelect = function()

                    local input = lib.inputDialog('Meghdar Baraye Kharid', {
                        {
                            type = 'number',
                            label = 'Meghdar',
                            description = 'Chand ta mikhay bekhari?',
                            min = 1,
                            required = true
                        }
                    })

                    if input and tonumber(input[1]) and tonumber(input[1]) > 0 then

                        TriggerServerEvent('narekshop_item:buy_narekshop', item.name, tonumber(input[1]), item.price)
                    else
                        lib.notify({ position = 'center-right', title = "", description = "Meghdar Na Motabar", type = 'error', duration = 5000 })
                    end
                end
            })
        end

        if #options > 0 then
            lib.registerContext({
                id = 'buy_item_narekshop_menu',
                title = 'Buy Item',
                options = options
            })


            lib.showContext('buy_item_narekshop_menu')
        else
            lib.notify({ position = 'center-right', title = "", description = "Item Baraye Kharid Mojod Nist", type = 'error', duration = 5000 })
        end
    end)
end

RegisterNetEvent('narekshop_openmenu')
AddEventHandler("narekshop_openmenu", function()
    OpenBuyMenuNarekshop()
end)

Citizen.CreateThread(function()
    for k,v in pairs(ShopConfig.sellingLocationNarekshop) do
        RequestModel(GetHashKey(v.pedname))
        while not HasModelLoaded(GetHashKey(v.pedname)) do
            Wait(500)
        end
        Ped = CreatePed(v.pedtype,  GetHashKey(v.pedname), v.x, v.y, v.z-1, v.h, false, false)
        SetEntityHeading(Ped, v.h)
        FreezeEntityPosition(Ped, true)
        SetEntityInvincible(Ped, true)
        SetBlockingOfNonTemporaryEvents(Ped, true)
    end

    for k,v in pairs(ShopConfig.sellingLocationNarekshop) do
        exports.ox_target:addBoxZone({
            coords = vec3(v.x, v.y, v.z),
            size = vec3(1.5, 1.5, 1.5),
            rotation = 45,
            debug = drawZones,
            options = {
                {
                    name = 'Attachment Shop',
                    event = 'narekshop_openmenu',
                    icon = 'fa-solid fa-cart-shopping',
                    label = 'Attachment Shop',
                },
                {
                    name = 'Gun Shop',
                    event = 'gunshop_openmenu',
                    icon = 'fa-solid fa-gun',
                    label = 'Gun Shop',
                },
            }
        })
    end
end)

function CreateShopBlip()
    for _, v in pairs(ShopConfig.sellingLocationNarekshop) do
        local blip = AddBlipForCoord(v.x, v.y, v.z)

        SetBlipSprite (blip, 110)
        SetBlipDisplay(blip, 4)
        SetBlipScale(blip, 0.7)
        SetBlipColour (blip, 81)
        SetBlipAsShortRange(blip, true)
        BeginTextCommandSetBlipName("STRING")
        AddTextComponentSubstringPlayerName("Gun Shop")
        EndTextCommandSetBlipName(blip)

        if v.displayBlip == true then
            SetBlipAlpha(blip, 255)
        else
            SetBlipAlpha(blip, 0)
        end
    end
end

Citizen.CreateThread(function()
    CreateShopBlip()
end)

function OpenBuyMenuGunshop()
    local options = {}


    ESX.TriggerServerCallback('getitemsForSaleGunshop', function(itemsForSaleGunshop)
        for _, item in ipairs(itemsForSaleGunshop) do

            -- Ammo entries (item.itemType == 'ammo', see
            -- ShopConfig.itemsForSaleAmmoGunshop) buy a stack of the real
            -- item via gunshop_item:buy_ammo; everything else keeps
            -- buying a weapon via gunshop_item:buy_gunshop, unchanged.
            local buyEvent = item.itemType == 'ammo' and 'gunshop_item:buy_ammo' or 'gunshop_item:buy_gunshop'
            local title = item.itemType == 'ammo'
                and ("%s x%s ($%s)"):format(item.label, item.amount, item.price)
                or ("%s ($%s)"):format(item.label, item.price)

            table.insert(options, {
                title = title,
                description = 'Click to Buy',
                icon = item.image,
                image = item.image,
                onSelect = function()

                    TriggerServerEvent(buyEvent, item.name, 1, item.price)
                end
            })
        end

        if #options > 0 then
            lib.registerContext({
                id = 'buy_item_gunshop_menu',
                title = 'Buy Item',
                options = options
            })


            lib.showContext('buy_item_gunshop_menu')
        else
            lib.notify({ position = 'center-right', title = "", description = "Item Baraye Kharid Mojod Nist", type = 'error', duration = 5000 })
        end
    end)
end

RegisterNetEvent('gunshop_openmenu')
AddEventHandler("gunshop_openmenu", function()
    OpenBuyMenuGunshop()
end)

Citizen.CreateThread(function()
    for k,v in pairs(ShopConfig.sellingLocationGunshop) do
        RequestModel(GetHashKey(v.pedname))
        while not HasModelLoaded(GetHashKey(v.pedname)) do
            Wait(500)
        end
        Ped = CreatePed(v.pedtype,  GetHashKey(v.pedname), v.x, v.y, v.z-1, v.h, false, false)
        SetEntityHeading(Ped, v.h)
        FreezeEntityPosition(Ped, true)
        SetEntityInvincible(Ped, true)
        SetBlockingOfNonTemporaryEvents(Ped, true)
    end

    for k,v in pairs(ShopConfig.sellingLocationGunshop) do
        exports.ox_target:addBoxZone({
            coords = vec3(v.x, v.y, v.z),
            size = vec3(1.5, 1.5, 1.5),
            rotation = 45,
            debug = drawZones,
            options = {
                {
                    name = 'Gun Shop',
                    event = 'gunshop_openmenu',
                    icon = 'fa-solid fa-cart-weapon',
                    label = 'Gun Shop',
                },
            }
        })
    end
end)