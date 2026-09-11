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

-- ============================================================
-- GUN SHOP -- category menu (Pistols / SMGs / Shotguns / Rifles /
-- Snipers / Heavy / Melee / Throwables / Ammo) instead of one long
-- flat list. Selecting a category opens a submenu of just those
-- items; ox_lib draws the back arrow automatically via `menu` on
-- the registered submenu.
-- ============================================================

local function buildWeaponMetadata(item)
    local metadata = {}
    local meta = item.meta

    if meta then
        if meta.class then metadata[#metadata + 1] = ('Type: %s'):format(meta.class) end
        if meta.damage then metadata[#metadata + 1] = ('Damage: %s'):format(meta.damage) end
        if meta.fireRate then metadata[#metadata + 1] = ('Fire Rate: %s'):format(meta.fireRate) end
        if meta.magazine then metadata[#metadata + 1] = ('Magazine: %s'):format(meta.magazine) end
        if meta.ammo then metadata[#metadata + 1] = ('Ammo Type: %s'):format(meta.ammo) end
    end

    metadata[#metadata + 1] = ('Price: $%s'):format(item.price)

    return metadata
end

function OpenBuyMenuGunshop()
    ESX.TriggerServerCallback('getitemsForSaleGunshop', function(itemsForSaleGunshop)
        -- Group the flat list the server sends into { [categoryId] = { item, item, ... } }
        local grouped = {}
        for _, item in ipairs(itemsForSaleGunshop) do
            grouped[item.category] = grouped[item.category] or {}
            table.insert(grouped[item.category], item)
        end

        local categoryOptions = {}

        for _, cat in ipairs(ShopConfig.GunshopCategories) do
            local items = grouped[cat.id]
            if items and #items > 0 then
                local subOptions = {}

                for _, item in ipairs(items) do
                    local isAmmo = item.itemType == 'ammo'
                    local buyEvent = isAmmo and 'gunshop_item:buy_ammo' or 'gunshop_item:buy_gunshop'
                    local title = isAmmo and ('%s (x%s per stack)'):format(item.label, item.amount) or item.label
                    local metadata = buildWeaponMetadata(item)

                    subOptions[#subOptions + 1] = {
                        title = title,
                        description = isAmmo and 'Click to choose a quantity' or 'Click to buy',
                        icon = cat.icon,
                        iconColor = cat.iconColor,
                        metadata = metadata,
                        onSelect = function()
                            if isAmmo then
                                local input = lib.inputDialog(('Buy %s'):format(item.label), {
                                    {
                                        type = 'number',
                                        label = 'Stacks',
                                        description = ('Each stack = %sx for $%s'):format(item.amount, item.price),
                                        min = 1,
                                        max = 50,
                                        default = 1,
                                        required = true
                                    }
                                })

                                if input and tonumber(input[1]) and tonumber(input[1]) > 0 then
                                    TriggerServerEvent(buyEvent, item.name, tonumber(input[1]))
                                else
                                    lib.notify({ position = 'center-right', title = "", description = "Meghdar Na Motabar", type = 'error', duration = 5000 })
                                end
                            else
                                local confirm = lib.alertDialog({
                                    header = item.label,
                                    content = table.concat(metadata, '\n\n'),
                                    centered = true,
                                    cancel = true,
                                    labels = { confirm = 'Buy', cancel = 'Cancel' }
                                })

                                if confirm == 'confirm' then
                                    TriggerServerEvent(buyEvent, item.name, 1)
                                end
                            end
                        end
                    }
                end

                lib.registerContext({
                    id = 'gunshop_category_' .. cat.id,
                    title = cat.label,
                    menu = 'buy_item_gunshop_menu',
                    options = subOptions
                })

                categoryOptions[#categoryOptions + 1] = {
                    title = cat.label,
                    description = ('%s item%s available'):format(#items, #items ~= 1 and 's' or ''),
                    icon = cat.icon,
                    iconColor = cat.iconColor,
                    arrow = true,
                    menu = 'gunshop_category_' .. cat.id,
                }
            end
        end

        if #categoryOptions > 0 then
            lib.registerContext({
                id = 'buy_item_gunshop_menu',
                title = 'Gun Shop',
                options = categoryOptions
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
                    icon = 'fa-solid fa-gun', -- was 'fa-solid fa-cart-weapon', not a real FontAwesome icon
                    label = 'Gun Shop',
                },
            }
        })

        -- Standalone gun shops (if any get added to ShopConfig.sellingLocationGunshop)
        -- now also get a map blip, matching the Narekshop gun shop locations.
        if v.displayBlip then
            local blip = AddBlipForCoord(v.x, v.y, v.z)
            SetBlipSprite(blip, 110)
            SetBlipDisplay(blip, 4)
            SetBlipScale(blip, 0.7)
            SetBlipColour(blip, 1)
            SetBlipAsShortRange(blip, true)
            BeginTextCommandSetBlipName("STRING")
            AddTextComponentSubstringPlayerName("Gun Shop")
            EndTextCommandSetBlipName(blip)
        end
    end
end)