-- Unique_Clothe / client / shop (essentialmode + skinchanger). ESX comes from wardrobe.lua.

local shopOpen, currentShop, originalSkin, cam
local currentType
local lastClose = 0
local buying = false

-- ───────────── helpers ─────────────
local function notify(msg)
    if ESX and ESX.ShowNotification then ESX.ShowNotification(msg) end
end

local function deepCopy(t) return json.decode(json.encode(t)) end

-- skinchanger:getSkin hands out the live `Character` table, so always copy it
-- (otherwise "restore" would restore nothing).
local function getSkin()
    local result
    TriggerEvent('skinchanger:getSkin', function(s) result = deepCopy(s) end)
    local t = GetGameTimer()
    while not result and GetGameTimer() - t < 2000 do Wait(0) end
    return result
end

local allowedKeys = {}
for _, keys in pairs(Clothes.keys) do
    allowedKeys[keys[1]] = true
    allowedKeys[keys[2]] = true
end

local function applyStuff(num)
    local clean = {}
    for k, v in pairs(num) do
        if allowedKeys[k] and type(v) == 'number' then clean[k] = v end
    end
    if next(clean) then TriggerEvent('skinchanger:loadStuff', clean) end
end

local function currentSex()
    return (originalSkin and originalSkin.sex == 1) and 1 or 0
end

local function categoryAllowed(ctype)
    if not currentShop or type(ctype) ~= 'string' then return false end
    for _, c in ipairs(currentShop.categories) do
        if c == ctype then return true end
    end
    return false
end

-- ───────────── camera ─────────────
local function createCam()
    if cam then return end
    local ped = PlayerPedId()
    local c = GetOffsetFromEntityInWorldCoords(ped, 0.0, 1.5, 0.65)
    local p = GetEntityCoords(ped)
    cam = CreateCam('DEFAULT_SCRIPTED_CAMERA', true)
    SetCamCoord(cam, c.x, c.y, c.z)
    PointCamAtCoord(cam, p.x, p.y, p.z)
    SetCamActive(cam, true)
    RenderScriptCams(true, true, 500, true, true)
end

local function destroyCam()
    if not cam then return end
    RenderScriptCams(false, true, 500, true, false)
    DestroyCam(cam, false)
    cam = nil
end

-- ───────────── open / close ─────────────
local function openShop(index)
    if shopOpen then return end
    if GetGameTimer() - lastClose < Config.OpenCooldown then return notify(Config.Strings.wait) end
    local shop = Config.Shops[index]
    if not shop then return end

    local skin = getSkin()
    if not skin then return end

    originalSkin, currentShop, currentType = skin, shop, nil
    shopOpen = true

    FreezeEntityPosition(PlayerPedId(), true)
    createCam()

    local categories = {}
    for _, c in ipairs(shop.categories) do
        categories[#categories + 1] = { name = c, label = Config.TypeLabels[c] or c }
    end
    SendNUIMessage({ display = true, category = categories, imageServer = Config.ImageServer })
    SetNuiFocus(true, true)
    if ESX and ESX.UI and ESX.UI.Menu then ESX.UI.Menu.CloseAll() end
end

local function closeShop()
    if not shopOpen then return end
    shopOpen = false
    SetNuiFocus(false, false)
    destroyCam()
    local ped = PlayerPedId()
    FreezeEntityPosition(ped, false)
    ClearPedTasks(ped)
    lastClose = GetGameTimer()
    if originalSkin then TriggerEvent('skinchanger:loadSkin', originalSkin) end
end

AddEventHandler('onResourceStop', function(resource)
    if resource ~= GetCurrentResourceName() then return end
    if shopOpen then
        closeShop()
        SendNUIMessage({ hide = true })
    end
end)

-- ───────────── zones, markers, blips ─────────────
local points = {}
for shopIndex, shop in ipairs(Config.Shops) do
    for _, coords in ipairs(shop.points) do
        points[#points + 1] = { coords = coords, shop = shopIndex }
    end
end

CreateThread(function()
    local m = Config.Marker
    while true do
        local sleep = 1000
        if not shopOpen and ESX then
            local ped = PlayerPedId()
            local pc = GetEntityCoords(ped)
            for _, p in ipairs(points) do
                local d = #(pc - p.coords)
                if d < m.DrawDistance then
                    sleep = 0
                    DrawMarker(m.Type, p.coords.x, p.coords.y, p.coords.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0,
                        m.Size.x, m.Size.y, m.Size.z, m.Color.r, m.Color.g, m.Color.b, m.Color.a,
                        false, false, 2, false, nil, nil, false)
                    if d < m.OpenDistance then
                        ESX.ShowHelpNotification(Config.Strings.help_open)
                        if IsControlJustReleased(0, Config.Key) and not IsNuiFocused()
                            and not IsEntityDead(ped) and not IsPedCuffed(ped) and not IsPedInAnyVehicle(ped, false) then
                            openShop(p.shop)
                        end
                    end
                end
            end
        end
        Wait(sleep)
    end
end)

CreateThread(function()
    for _, shop in ipairs(Config.Shops) do
        if shop.blip then
            local cfg = shop.mask and Config.Blip.Mask or Config.Blip.Shop
            local blip = AddBlipForCoord(shop.blip.x, shop.blip.y, shop.blip.z)
            SetBlipSprite(blip, cfg.sprite)
            SetBlipDisplay(blip, 4)
            SetBlipScale(blip, cfg.scale)
            SetBlipColour(blip, cfg.colour)
            SetBlipAsShortRange(blip, true)
            BeginTextCommandSetBlipName('STRING')
            AddTextComponentString(cfg.label)
            EndTextCommandSetBlipName(blip)
        end
    end
end)

-- ───────────── NUI callbacks ─────────────
RegisterNUICallback('close', function(_, cb)
    closeShop()
    cb('ok')
end)

RegisterNUICallback('loadClothe', function(data, cb)
    cb('ok')
    local ctype = type(data) == 'table' and data.name or nil
    if not shopOpen or not categoryAllowed(ctype) then return end
    currentType = ctype

    local groups = Clothes.groups[ctype] and Clothes.groups[ctype][currentSex()] or {}
    local list = {}
    for _, g in ipairs(groups) do
        local first = g.variants[1]
        list[#list + 1] = { id = g.id, name = first.name, label = first.groupLabel, price = first.price, num = first.num }
    end
    SendNUIMessage({ loadClothe = { type = ctype, data = list } })
end)

RegisterNUICallback('loadColor', function(data, cb)
    cb('ok')
    local id = tonumber(data)
    if not shopOpen or not currentType or not id then return end

    local groups = Clothes.groups[currentType] and Clothes.groups[currentType][currentSex()] or {}
    local colors = {}
    for _, g in ipairs(groups) do
        if g.id == id then
            for _, v in ipairs(g.variants) do
                colors[#colors + 1] = { id = g.id, name = v.name, label = v.groupLabel, price = v.price, num = v.num }
            end
            break
        end
    end
    SendNUIMessage({ loadColor = colors })
end)

RegisterNUICallback('preview', function(data, cb)
    cb('ok')
    if shopOpen and type(data) == 'table' and type(data.num) == 'table' then applyStuff(data.num) end
end)

RegisterNUICallback('undress', function(data, cb)
    cb('ok')
    if not shopOpen or type(data) ~= 'table' then return end
    local def = Config.Defaults[currentSex()][data.category]
    if def then applyStuff(def) end
end)

RegisterNUICallback('restoreClothing', function(data, cb)
    cb('ok')
    if not shopOpen or type(data) ~= 'table' or not originalSkin then return end
    local keys = Clothes.keys[data.category]
    if not keys then return end
    local restore = {}
    for _, k in ipairs(keys) do restore[k] = originalSkin[k] end
    applyStuff(restore)
end)

RegisterNUICallback('rotation', function(direction, cb)
    cb('ok')
    if not shopOpen then return end
    local ped = PlayerPedId()
    if direction == 1 then
        SetEntityHeading(ped, GetEntityHeading(ped) - 4.0)
    else
        SetEntityHeading(ped, GetEntityHeading(ped) + 4.0)
    end
end)

RegisterNUICallback('resetCamera', function(_, cb)
    cb('ok')
    if not shopOpen then return end
    destroyCam()
    Wait(100)
    createCam()
end)

RegisterNUICallback('tryout', function(data, cb)
    cb('ok')
    if not shopOpen or type(data) ~= 'table' or not originalSkin then return end
    TriggerEvent('skinchanger:loadSkin', originalSkin)
    Wait(100)
    for _, entry in ipairs(data) do
        local item = type(entry) == 'table' and Clothes.byName[entry.name] or nil
        if item and categoryAllowed(item.type) then applyStuff(item.num) end
    end
    destroyCam()
    Wait(100)
    createCam()
    if Config.TryoutEmote then ExecuteCommand('e ' .. Config.TryoutEmote) end
end)

RegisterNUICallback('buy', function(data, cb)
    cb('ok')
    if not shopOpen or buying or type(data) ~= 'table' or not ESX then return end

    local names = {}
    for _, entry in ipairs(data) do
        if type(entry) == 'table' and type(entry.name) == 'string' then names[#names + 1] = entry.name end
    end
    if #names == 0 then return end

    buying = true
    ESX.TriggerServerCallback('Unique_Clothe:buy', function(result)
        buying = false
        if type(result) ~= 'table' then
            return SendNUIMessage({ notification = { type = 'error', message = Config.Strings.invalid } })
        end
        if not result.success then
            return SendNUIMessage({ notification = { type = 'error', message = result.message } })
        end

        -- The items are now in the inventory. Optionally wear them right away and make
        -- that the base skin so closing the shop does not revert it.
        local purchased = {}
        for name in pairs(result.purchased or {}) do
            if Clothes.byName[name] then purchased[name] = true end
        end

        if Config.WearAfterBuy then
            local newSkin = deepCopy(originalSkin)
            for name in pairs(purchased) do
                for k, v in pairs(Clothes.byName[name].num) do newSkin[k] = v end
            end
            originalSkin = newSkin
            TriggerEvent('skinchanger:loadSkin', newSkin)
            for name in pairs(purchased) do Wardrobe.wear(name, true) end
        end

        SendNUIMessage({
            notification = { type = result.type or 'success', message = result.message },
            purchasedItems = purchased,
        })
    end, names)
end)
