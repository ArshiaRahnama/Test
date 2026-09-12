ESX = nil

Citizen.CreateThread(function()
    while ESX == nil do
        TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
    Citizen.Wait(0)
    end
end)

-- ============================================================
-- SHARED HELPERS -- every shop below (General Store, Mechanic Shop,
-- Attachment Shop, Gun Shop) uses the same category -> submenu ->
-- item pattern, so it's built once here instead of four times.
-- ============================================================

-- Groups a flat item list (as returned by the server callbacks) into
-- { [categoryId] = { item, item, ... } }
local function groupByCategory(items)
    local grouped = {}
    for _, item in ipairs(items) do
        grouped[item.category] = grouped[item.category] or {}
        table.insert(grouped[item.category], item)
    end
    return grouped
end

-- Builds & shows a two-level ox_lib context menu: a top level of
-- categories (with item counts) and, per category, a submenu of items
-- built by `itemOptionBuilder(item, cat)`. Categories with no items
-- for the current shop are simply skipped, so an empty category never
-- shows up as a dead end. Returns true if anything was shown.
local function showCategorizedShopMenu(menuId, menuTitle, categories, items, itemOptionBuilder)
    local grouped = groupByCategory(items)
    local categoryOptions = {}

    for _, cat in ipairs(categories) do
        local catItems = grouped[cat.id]
        if catItems and #catItems > 0 then
            local subOptions = {}
            for _, item in ipairs(catItems) do
                subOptions[#subOptions + 1] = itemOptionBuilder(item, cat)
            end

            local subMenuId = menuId .. '_cat_' .. cat.id
            lib.registerContext({
                id = subMenuId,
                title = cat.label,
                menu = menuId,
                options = subOptions
            })

            categoryOptions[#categoryOptions + 1] = {
                title = cat.label,
                description = ('%s item%s available'):format(#catItems, #catItems ~= 1 and 's' or ''),
                icon = cat.icon,
                iconColor = cat.iconColor,
                arrow = true,
                menu = subMenuId,
            }
        end
    end

    if #categoryOptions == 0 then
        lib.notify({ position = 'center-right', title = "", description = "Item Baraye Kharid Mojod Nist", type = 'error', duration = 5000 })
        return false
    end

    lib.registerContext({
        id = menuId,
        title = menuTitle,
        options = categoryOptions
    })
    lib.showContext(menuId)
    return true
end

-- Standard "how many do you want?" prompt used by every shop that
-- buys plain stackable items (General Store, Mechanic Shop,
-- Attachment Shop, Gun Shop ammo).
local function promptQuantityAndBuy(item, buyEvent, maxAmount)
    local input = lib.inputDialog(('Buy %s'):format(item.label), {
        {
            type = 'number',
            label = 'Meghdar',
            description = 'Chand ta mikhay bekhari?',
            min = 1,
            max = maxAmount,
            default = 1,
            required = true
        }
    })

    if input and tonumber(input[1]) and tonumber(input[1]) > 0 then
        TriggerServerEvent(buyEvent, item.name, tonumber(input[1]))
    else
        lib.notify({ position = 'center-right', title = "", description = "Meghdar Na Motabar", type = 'error', duration = 5000 })
    end
end

-- Spawns the peds for a shop's selling locations and gives each one
-- an ox_target zone with the given target options. Every shop below
-- used to repeat this ped-spawn + zone-add loop; now it's one call.
local function spawnShopPeds(locations, targetOptions)
    for _, v in pairs(locations) do
        RequestModel(GetHashKey(v.pedname))
        while not HasModelLoaded(GetHashKey(v.pedname)) do
            Wait(500)
        end
        local ped = CreatePed(v.pedtype, GetHashKey(v.pedname), v.x, v.y, v.z - 1, v.h, false, false)
        SetEntityHeading(ped, v.h)
        FreezeEntityPosition(ped, true)
        SetEntityInvincible(ped, true)
        SetBlockingOfNonTemporaryEvents(ped, true)
    end

    for _, v in pairs(locations) do
        exports.ox_target:addBoxZone({
            coords = vec3(v.x, v.y, v.z),
            size = vec3(1.5, 1.5, 1.5),
            rotation = 45,
            debug = drawZones,
            options = targetOptions
        })
    end
end

-- Drops a map blip (sprite 110, the Ammu-Nation gun icon) at every
-- location in `locations` whose `displayBlip` flag is true.
local function spawnShopBlips(locations, label, colour)
    for _, v in pairs(locations) do
        if v.displayBlip then
            local blip = AddBlipForCoord(v.x, v.y, v.z)
            SetBlipSprite(blip, 110)
            SetBlipDisplay(blip, 4)
            SetBlipScale(blip, 0.7)
            SetBlipColour(blip, colour or 1)
            SetBlipAsShortRange(blip, true)
            BeginTextCommandSetBlipName("STRING")
            AddTextComponentSubstringPlayerName(label)
            EndTextCommandSetBlipName(blip)
        end
    end
end

-- ============================================================
-- GENERAL STORE -- 🍔 Food & Drinks / 📱 Electronics / 🚬 Smoking
-- ============================================================
function OpenBuyMenuShops()
    ESX.TriggerServerCallback('getitemsForSaleShops', function(itemsForSaleShops)
        showCategorizedShopMenu('buy_item_shops_menu', '🛒 General Store', ShopConfig.ShopsCategories, itemsForSaleShops, function(item, cat)
            return {
                title = item.label,
                description = ('$%s -- click to choose a quantity'):format(item.price),
                icon = cat.icon,
                iconColor = cat.iconColor,
                metadata = { ('Price: $%s'):format(item.price) },
                onSelect = function()
                    promptQuantityAndBuy(item, 'shops_item:buy_shops')
                end
            }
        end)
    end)
end

RegisterNetEvent('shops_openmenu')
AddEventHandler("shops_openmenu", function()
    OpenBuyMenuShops()
end)

Citizen.CreateThread(function()
    spawnShopPeds(ShopConfig.sellingLocationShops, {
        {
            name = 'Shop',
            event = 'shops_openmenu',
            icon = 'fa-solid fa-cart-shopping',
            label = 'Shop',
        }
    })
end)

-- ============================================================
-- MECHANIC SHOP -- 🔧 Tools / 🚗 Parts
-- ============================================================
function OpenBuyMenuMC()
    ESX.TriggerServerCallback('getitemsForSaleMC', function(itemsForSaleMC)
        showCategorizedShopMenu('buy_item_mc_menu', '🔧 Mechanic Shop', ShopConfig.MCCategories, itemsForSaleMC, function(item, cat)
            return {
                title = item.label,
                description = ('$%s -- click to choose a quantity'):format(item.price),
                icon = cat.icon,
                iconColor = cat.iconColor,
                metadata = { ('Price: $%s'):format(item.price) },
                onSelect = function()
                    promptQuantityAndBuy(item, 'mc_item:buy_mc')
                end
            }
        end)
    end)
end

RegisterNetEvent('mc_openmenu')
AddEventHandler("mc_openmenu", function()
    OpenBuyMenuMC()
end)

Citizen.CreateThread(function()
    spawnShopPeds(ShopConfig.sellingLocationMC, {
        {
            name = 'Mechanic Shop',
            event = 'mc_openmenu',
            icon = 'fa-solid fa-cart-shopping',
            label = 'Mechanic Shop',
        }
    })
end)

-- ============================================================
-- ATTACHMENT SHOP (Narekshop) -- 🔭 Weapon Attachments / 🧰 Tools & Equipment
-- ============================================================
function OpenBuyMenuNarekshop()
    ESX.TriggerServerCallback('getitemsForSaleNarekshop', function(itemsForSaleNarekshop)
        showCategorizedShopMenu('buy_item_narekshop_menu', '🔭 Attachment Shop', ShopConfig.NarekshopCategories, itemsForSaleNarekshop, function(item, cat)
            return {
                title = item.label,
                description = ('$%s -- click to choose a quantity'):format(item.price),
                icon = cat.icon,
                iconColor = cat.iconColor,
                metadata = { ('Price: $%s'):format(item.price) },
                onSelect = function()
                    promptQuantityAndBuy(item, 'narekshop_item:buy_narekshop')
                end
            }
        end)
    end)
end

RegisterNetEvent('narekshop_openmenu')
AddEventHandler("narekshop_openmenu", function()
    OpenBuyMenuNarekshop()
end)

Citizen.CreateThread(function()
    spawnShopPeds(ShopConfig.sellingLocationNarekshop, {
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
    })
    spawnShopBlips(ShopConfig.sellingLocationNarekshop, 'Gun Shop', 81)
end)

-- ============================================================
-- GUN SHOP -- 🔫 Pistols / 🔪 Melee / 📦 Ammunition. Weapons show a
-- confirm dialog with damage/fire-rate/magazine metadata before
-- buying; ammo asks for a quantity of stacks instead.
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
        showCategorizedShopMenu('buy_item_gunshop_menu', '🔫 Gun Shop', ShopConfig.GunshopCategories, itemsForSaleGunshop, function(item, cat)
            local isAmmo = item.itemType == 'ammo'
            local buyEvent = isAmmo and 'gunshop_item:buy_ammo' or 'gunshop_item:buy_gunshop'
            local title = isAmmo and ('%s (x%s per stack)'):format(item.label, item.amount) or item.label
            local metadata = buildWeaponMetadata(item)

            return {
                title = title,
                description = isAmmo and 'Click to choose a quantity' or 'Click to buy',
                icon = cat.icon,
                iconColor = cat.iconColor,
                metadata = metadata,
                onSelect = function()
                    if isAmmo then
                        promptQuantityAndBuy(item, buyEvent, 50)
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
        end)
    end)
end

RegisterNetEvent('gunshop_openmenu')
AddEventHandler("gunshop_openmenu", function()
    OpenBuyMenuGunshop()
end)

Citizen.CreateThread(function()
    spawnShopPeds(ShopConfig.sellingLocationGunshop, {
        {
            name = 'Gun Shop',
            event = 'gunshop_openmenu',
            icon = 'fa-solid fa-gun',
            label = 'Gun Shop',
        },
    })
    -- Standalone gun shops (if any get added to ShopConfig.sellingLocationGunshop)
    -- get a map blip too, same as the Attachment Shop locations above.
    spawnShopBlips(ShopConfig.sellingLocationGunshop, 'Gun Shop', 1)
end)
