--[[ sun-inventory — clothes shop client. Markers/blips at the same
     Binco/Suburban/Ponsonbys locations as the old inventory's shop, using
     ESX's own list menu (ESX.UI.Menu.Open('default', ...)) instead of
     porting the old lgdUI/RageUI-based nested menu tree — simpler, and
     doesn't drag a whole extra UI library into this resource. Trade-off:
     no live drawable/texture scrubbing preview before paying; selecting an
     option previews-and-buys in one step, same as every other ESX shop in
     this base (ped shop, vehicle shop). ]]

local nearShop = false

CreateThread(function()
    for _, shopData in pairs(ClothShop.Locations) do
        for _, coords in ipairs(shopData.coords) do
            local blip = AddBlipForCoord(coords.x, coords.y, coords.z)
            SetBlipSprite(blip, shopData.blip.style)
            SetBlipDisplay(blip, 4)
            SetBlipScale(blip, shopData.blip.size)
            SetBlipColour(blip, shopData.blip.color)
            SetBlipAsShortRange(blip, true)
        end
    end
end)

local function nearestShopCoords()
    local pCoords = GetEntityCoords(PlayerPedId())
    for _, shopData in pairs(ClothShop.Locations) do
        for _, coords in ipairs(shopData.coords) do
            if #(pCoords - coords) < 3.0 then return coords end
        end
    end
    return nil
end

CreateThread(function()
    while true do
        local sleep = 750
        local pCoords = GetEntityCoords(PlayerPedId())
        local closest = nil
        local closestDist = ClothShop.MarkerDistance

        for _, shopData in pairs(ClothShop.Locations) do
            for _, coords in ipairs(shopData.coords) do
                local dist = #(pCoords - coords)
                if dist < ClothShop.MarkerDistance then
                    sleep = 0
                    if dist < closestDist then closest = coords; closestDist = dist end
                end
            end
        end

        if closest then
            DrawMarker(ClothShop.MarkerType, closest.x, closest.y, closest.z, 0.0, 0.0, 0.0, 0, 0.0, 0.0,
                0.75, 0.75, 0.75, 20, 100, 200, 230, false, true, false, false, false, false, false, false)
        end

        Wait(sleep)
    end
end)

CreateThread(function()
    while true do
        Wait(0)
        local coords = nearestShopCoords()
        if coords then
            if not nearShop then
                nearShop = true
                BeginTextCommandDisplayHelp('STRING')
                AddTextComponentSubstringPlayerName('Press ~INPUT_CONTEXT~ to open the clothes shop')
                EndTextCommandDisplayHelp(0, false, true, -1)
            end
            if IsControlJustPressed(0, 38) then -- INPUT_CONTEXT (E)
                OpenClothShopCategoryMenu()
            end
        else
            nearShop = false
            Wait(500)
        end
    end
end)

local function buildSkinchangerMaxVals()
    local maxVals
    TriggerEvent('skinchanger:getData', function(_, mv) maxVals = mv end)
    return maxVals
end

local function previewAndConfirm(wardrobeType, drawable, texture)
    local def = WardrobeTypes[wardrobeType]
    if not def then return end

    -- live-preview it on the ped before charging money
    if wardrobeType == 'arms' then
        TriggerEvent('skinchanger:change', 'arms', drawable)
        TriggerEvent('skinchanger:change', 'arms_2', texture)
    else
        TriggerEvent('skinchanger:change', def.pair[1], drawable)
        TriggerEvent('skinchanger:change', def.pair[2], texture)
    end

    ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'sun_clothes_confirm', {
        title = ('Buy for $%d?'):format(ClothShop.Prices[wardrobeType] or 0),
        align = 'top-left',
        elements = {
            { label = 'Confirm purchase', value = 'buy' },
            { label = 'Cancel', value = 'cancel' },
        },
    }, function(data, menu)
        menu.close()
        if data.current.value == 'buy' then
            TriggerServerEvent('sun-clothes:buy', wardrobeType, wardrobeType .. ' ' .. drawable .. '_' .. texture, drawable, texture)
            TriggerEvent('skinchanger:getSkin', function(skin)
                TriggerServerEvent('esx_skin:save', skin)
            end)
        end
    end, function(data, menu)
        menu.close()
    end)
end

local function openVariationMenu(wardrobeType, drawable, maxTexture)
    local elements = {}
    for t = 0, maxTexture, 1 do
        elements[#elements + 1] = { label = 'Variation ' .. t, value = t }
    end
    ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'sun_clothes_variation', {
        title = 'Choose variation', align = 'top-left', elements = elements,
    }, function(data, menu)
        menu.close()
        previewAndConfirm(wardrobeType, drawable, data.current.value)
    end, function(data, menu)
        menu.close()
    end)
end

local function openDrawableMenu(wardrobeType)
    local maxVals = buildSkinchangerMaxVals()
    if not maxVals then return end

    local def = WardrobeTypes[wardrobeType]
    local drawKey = (wardrobeType == 'arms') and 'arms' or def.pair[1]
    local texKey = (wardrobeType == 'arms') and 'arms_2' or def.pair[2]
    local maxDrawable = maxVals[drawKey] or 0
    local maxTexture = maxVals[texKey] or 0

    local elements = {}
    for d = 0, maxDrawable, 1 do
        elements[#elements + 1] = { label = 'Style ' .. d, value = d }
    end

    ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'sun_clothes_drawable', {
        title = ('%s — $%d'):format(wardrobeType, ClothShop.Prices[wardrobeType] or 0),
        align = 'top-left',
        elements = elements,
    }, function(data, menu)
        menu.close()
        openVariationMenu(wardrobeType, data.current.value, maxTexture)
    end, function(data, menu)
        menu.close()
    end)
end

function OpenClothShopCategoryMenu()
    local elements = {}
    for wardrobeType, price in pairs(ClothShop.Prices) do
        elements[#elements + 1] = { label = ('%s — $%d'):format(wardrobeType, price), value = wardrobeType }
    end
    table.sort(elements, function(a, b) return a.label < b.label end)

    ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'sun_clothes_category', {
        title = 'Clothes Shop', align = 'top-left', elements = elements,
    }, function(data, menu)
        menu.close()
        openDrawableMenu(data.current.value)
    end, function(data, menu)
        menu.close()
    end)
end
