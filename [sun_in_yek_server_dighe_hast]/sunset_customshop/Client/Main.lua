-- Pub by FleeX Team , https://discord.gg/87rGBxgCsa

ESX = exports['essentialmode']:getObject()
local key = nil
local dutyThread = false
local currentMarket, currentMarketOwner
local countList = nil
local postBox = false

local function isSuperOwner(identifier)
    if not identifier or not Config.superOwners then return false end
    return Config.superOwners[identifier] == true
end

local function isShopOwner(shop, identifier)
    if not identifier or not shop then return false end
    if isSuperOwner(identifier) then return true end
    if shop.owner and shop.owner[identifier] then return true end
    if shop.owner and ESX.tableFind(shop.owner, identifier) then return true end
    return false
end
Citizen.CreateThread(function()
	while ESX == nil do
		Wait(1000)
	end
    -- for k , v in pairs(coords) do
    --     local blip = AddBlipForCoord(v.coords)
    --     SetBlipSprite  (blip, 304)
    --     SetBlipDisplay (blip, 4)
    --     SetBlipScale   (blip, 1.0)
    --     SetBlipCategory(blip, 3)
    --     SetBlipColour  (blip, 2)
    --     SetBlipAsShortRange(blip, true)
    --     BeginTextCommandSetBlipName("STRING")
    --     AddTextComponentString("Auction House")
    --     EndTextCommandSetBlipName(blip)
    -- end
    Wait(5000)
    ESX.TriggerServerCallback('customshop:getBlips', function(blipsColor)
        for k , v in pairs(Config.location) do
            if v.items then
                for k2 , v2 in pairs(v.items) do
                    table.insert(list_products, v2)
                end
            end
        end
        Wait(5000)
        SendNUIMessage({
            config = Config,
            translate = translate,
            NameResource = GetCurrentResourceName()
        })
        for k , v in pairs(Config.location) do
            if v.eye then
                for k2 , v2 in pairs(v.coords) do
                    exports['ox_target']:addSphereZone({
                        coords = v2,
                        radius = v.eyeRange,
                        options = {
                            {
                                label = "📕باز کردن منو",
                                onSelect = function()
                                    if v.ownerCheck then
                                        if ownerCheck(v.ownerCheck) then
                                            return ESX.chatMessage('Persenel in shop dar nazdiki shoma ast', 'plarms')
                                        end
                                    end
                                    key = k
                                    openMarket(k)
                                    dutyCheck(k, v)
                                end,
                            },
                        }
                    })
                end
            else
                for k2 , v2 in pairs(v.coords) do
                    ESX.RegisterPoint(v2,v.range or 3,{
                        Color = v.color or {R = 0,G = 0,B = 0,A = 255},
                        DrawDistance = v.drawDistance or 10,
                        Radius = v.radius or 1.0,
                        Type = v.type or 54,
                        worldCheck = false,
                    },{
                        Notification = nil,
                        DrawText = v.hideLabel and nil or 'Dokme ~INPUT_CONTEXT~ jahat baz kardan ['.. v.label ..']',
                        DrawTextRadius = v.drawTextRadius or 1.0,
                        DrawTextCoords = v2,
                        Key = 'e',
                        CB = function()
                            if ESX.GetPlayerData().World == 0 or exports['gangs']:isInGangWorld() then
                                if v.ownerCheck then
                                    if ownerCheck(v.ownerCheck) then
                                        return ESX.chatMessage('Persenel in shop dar nazdiki shoma ast', 'plarms')
                                    end
                                end
                                key = k
                                openMarket(k)
                                TriggerServerEvent('customShop:open', false, k)
                                dutyCheck(k, v)
                            end
                        end,
                    },{
                        In = nil,
                        Out = ESX.UI.Menu.CloseAll
                    })
                end
            end
            if v.blip and v.blipCoords then
                v.blips = {}
                local blipConfig = v.blipConfig or Config.blip
                for k2, v2 in pairs(v.blipCoords) do
                    local blip = ESX.AddBlipForCoord(v2.xyz, blipConfig.scale, blipConfig.type, 1, v.blip)
                    if blipsColor[v.db] then
                        ESX.SetBlipColour(blip, blipsColor[v.db] == 1 and 1 or blipsColor[v.db] == 2 and 27 or blipsColor[v.db] == 3 and 2)
                    end
                    table.insert(v.blips, blip)
                end
            end
        end
    end)
end)

function isNear()
    local coords = ESX.getCoords()
    for k , v in pairs(Config.location) do
        for k2 , v2 in pairs(v.coords) do
            if #(v2 - coords) < 10 or postBox then
                return true
            end
        end
    end
end

function hasAccess(key)
    local data = Config.location[key].access
    if data[ESX.GetPlayerData().identifier] or data[ESX.GetPlayerData().job.name] or data[ESX.GetPlayerData().gang.name] then
        return true
    end
    return false
end

RegisterCommand('shophook', function()
    local hex = ESX.GetPlayerData().identifier
    local elements = {}
    for k, v in pairs(Config.location) do
        if isShopOwner(v, hex) then
            table.insert(elements, {label = v.label, key = k})
        end
    end
    if #elements > 0 then
        ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'webhook', {
            title    = 'Kodam shop ro avaz mikonid?',
            align    = 'top-left',
            elements = elements
        }, function(data, menu)
            menu.close()
            ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'get_count', {
                title = "Tedad forush ra vared konid"
            },
            function(data1,menu1)
                menu1.close()
                if data1.value then
                    local hook = data1.value
                    ESX.TriggerServerEvent('customshop:setWebhook', data.current.key, hook)
                else
                    ESX.chatMessage('Chizi vared nakardid!', 'plarms')
                end
            end, function(data1,menu1)
                menu1.close()
            end)
        end, function(data, menu)
            menu.close()
        end)
    else
        ESX.chatMessage('Shoma shopi nadarid!', 'plarms')
    end
end, false)

function ownerCheck(data)
    ESX.PlayerData = ESX.GetPlayerData()
    local count = 0
    for k , v in ipairs(GetActivePlayers()) do
        if v ~= PlayerId() and ESX.GetDistance(GetEntityCoords(GetPlayerPed(v)),GetEntityCoords(PlayerPedId())) < data.radius then
            local src = GetPlayerServerId(v)
            local playerJob = ESX.GetPlayerState(GetPlayerServerId(v), 'job')
            local playerGang = ESX.GetPlayerState(GetPlayerServerId(v), 'gang')
            if (data.job and data.job == playerJob) or (data.gang and data.gang == playerGang) then
                local job = data.job
                local add = false
                if data.gradeType then
                    local grade = nil
                    local p = promise.new()
                    ESX.TriggerServerCallback('esx:getOtherPlayerData', function(playerData)
                        if playerData then
                            p:resolve(job and playerData.job.grade or playerData.gang.grade)
                        end
                    end, src)
                    grade = Citizen.Await(p)
                    if grade then
                        if data.gradeType == 1 then
                            add = grade == data.grade
                        elseif data.gradeType == 2 then
                            add = grade <= data.grade
                        elseif data.gradeType == 3 then
                            add = grade >= data.grade
                        elseif data.gradeType == 4 then
                            add = grade >= data.grade and grade <= data.grade2
                        end
                    end
                else
                    add = true
                end
                if add then
                    count = count + 1
                end
            end
        end
    end
    return count >= data.count and ESX.PlayerData.job.name ~= data.job and ESX.PlayerData.gang.name ~= data.gang
end

RegisterNetEvent('customshop:updateBlip', function(owner, color)
    for k, v in pairs(Config.location) do
        if v.blip and v.blips and v.db == owner then
            for k2, v2 in pairs(v.blips) do
                ESX.SetBlipColour(v2, color == 1 and 1 or color == 2 and 27 or color == 3 and 2)
            end
        end
    end
end)

function dutyCheck(k, v)
    if hasAccess(k) and v.blipCoords then
        local coords = GetEntityCoords(PlayerPedId())
        for k2, v2 in pairs(v.blipCoords) do
            if #(v2.xyz - coords) < v2.w then
                if not dutyThread then
                    dutyThread = true
                    TriggerServerEvent('customshop:setDuty', v.db, true)
                    CreateThread(function()
                        while dutyThread do
                            if #(GetEntityCoords(PlayerPedId()) - v2.xyz) > v2.w then
                                TriggerServerEvent('customshop:setDuty', v.db, false)
                                dutyThread = false
                                break
                            end
                            Wait(10000)
                        end
                    end)
                end
                break
            end
        end
    end
end

function openMarket(marketName, check)
    countList = nil
    currentMarket = marketName
    currentMarketOwner = Config.location[marketName].db
    openMarketHandler(true, check)
    postBox = check
end

function openMarketHandler(state, check)
    SendNUIMessage({
        app = 'sunset_customshop',
        method = 'open',
        data = {
            name = Config.location[currentMarket].label,
            state = state
        }
    })
    SetNuiFocus(state, state)
    currentState = state
    -- if state and not check then
    --     CreateThread(function()
    --         while currentState do
    --             Wait(2000)
    --             if not doesNear() then
    --                 openAH(false)
    --             end
    --         end
    --     end)
    -- end
end

RegisterNetEvent('customShop:open', function(marketName, check)
    openMarket(marketName, check)
end)

RegisterNUICallback('close', function(data, cb)
    SetNuiFocus(false, false)
    TriggerEvent('ah:onClose')
    cb()
end)

RegisterNUICallback('getCategories', function(data, cb)
    if not currentMarket then
        return cb(json.encode({}))
    end
    if countList == nil and currentMarketOwner then
        local p = promise.new()
        ESX.TriggerServerCallback('customMarket:getProductsCount', function(result)
            countList = result or {}
            p:resolve()
        end, currentMarketOwner)
        Citizen.Await(p)
    end
    local categories = {}
    local items = Config.location[currentMarket].items or {}
    for _, v in pairs(items) do
        local entry = {
            name = v.name,
            price_recommended = v.price_recommended,
            minLimit = v.minLimit,
            label = ('%s(%s)'):format(ESX.getItemLabel(v.name), countList and countList[v.name] or 0),
            img = v.img or ESX.getItemImage(v.name),
        }
        categories[#categories+1] = entry
    end
    cb(json.encode(categories))
end)

RegisterNUICallback('getPlayerItem', function(data, cb)
    local inventory = ESX.GetPlayerData().inventory
    local filtered = {}
    if hasAccess(currentMarket) then
        for k, v in pairs(inventory) do
            if v.count > 0 then
                for k2, v2 in pairs(Config.location[currentMarket].items) do
                    if v2.name == v.name then
                        v.price_recommended = v2.price_recommended
                        v.minLimit = v2.minLimit
                        table.insert(filtered, v)
                        break
                    end
                end
            end
        end
        for k, v in pairs(ESX.GetPlayerData().loadout) do
            if not v.metadata.expireTS then
                for k2, v2 in pairs(Config.location[currentMarket].items) do
                    if v2.name == v.name then
                        v.price_recommended = v2.price_recommended
                        v.count = v.ammo
                        if v.metadata.serial then
                            v.label = ('%s %s'):format(v.label, v.metadata.serial)
                        end
                        table.insert(filtered, v)
                        break
                    end
                end
            end
        end
    end
    cb(json.encode(filtered))
end)

local function decorateProduct(v, label, image)
    v.count = v.amount
    v.label = label or ESX.getItemLabel(v.name)
    v.img = image or ESX.getItemImage(v.name)
    v.blackmoney = v.black == 1
    if v.data then
        local meta = json.decode(v.data)
        if meta and meta.ammo then
            v.count = 1
        end
        if meta and meta.serial then
            v.label = ('%s %s'):format(v.label, meta.serial)
        end
    end
    return v
end

RegisterNUICallback('getProducts', function(data, cb)
    local page = tonumber(data.page) or 1
    local sort = data.sort == 'expensive' and 'expensive' or 'cheap'
    ESX.TriggerServerCallback('customMarket:getProductsByName', function(result)
        result = result or { rows = {}, total = 0, page = 1, totalPages = 0 }
        local label = ESX.getItemLabel(data.category.name)
        local image = ESX.getItemImage(data.category.name)
        local rows = {}
        for _, v in pairs(result.rows or {}) do
            table.insert(rows, decorateProduct(v, label, image))
        end
        cb(json.encode({
            rows = rows,
            total = result.total or 0,
            page = result.page or page,
            totalPages = result.totalPages or 0,
        }))
    end, currentMarketOwner, data.category.name, page, sort)
end)

RegisterNUICallback('getMyItemNames', function(data, cb)
    ESX.TriggerServerCallback('customMarket:getMyItemNames', function(result)
        local list = {}
        if result then
            for _, v in pairs(result) do
                table.insert(list, {
                    name = v.name,
                    label = ESX.getItemLabel(v.name),
                    img = ESX.getItemImage(v.name),
                    count = v.count,
                })
            end
        end
        cb(json.encode(list))
    end, currentMarketOwner, currentMarket)
end)

RegisterNUICallback('getMyProductsByName', function(data, cb)
    local page = tonumber(data.page) or 1
    local sort = data.sort == 'expensive' and 'expensive' or 'cheap'
    local name = data.name
    ESX.TriggerServerCallback('customMarket:getMyProductsByName', function(result)
        result = result or { rows = {}, total = 0, page = 1, totalPages = 0 }
        local label = ESX.getItemLabel(name)
        local image = ESX.getItemImage(name)
        local rows = {}
        for _, v in pairs(result.rows or {}) do
            table.insert(rows, decorateProduct(v, label, image))
        end
        cb(json.encode({
            rows = rows,
            total = result.total or 0,
            page = result.page or page,
            totalPages = result.totalPages or 0,
        }))
    end, currentMarketOwner, currentMarket, name, page, sort)
end)

RegisterNUICallback('buy', function(data, cb)
    if isNear() then
        ESX.TriggerServerEvent('customMarket:buyItem', data)
    end
    Wait(6000)
    countList = nil
    cb("ok")
end)

RegisterNUICallback('delete', function(data, cb)
    if isNear() then
        ESX.TriggerServerEvent('customMarket:removeItem', data)
    end
    Wait(3000)
    countList = nil
    cb("ok")
end)

RegisterNUICallback('add', function(data, cb)
    data.key = currentMarket
    for k, v in pairs(ESX.GetPlayerData().loadout) do
        if v.metadata.serial == data.name then
            data.serial = data.name
            data.name = v.name
        end
    end
    if isNear() then
        local minLimit
        for k, v in pairs(Config.location[currentMarket].items) do
            if v.name == data.name then
                minLimit = v.minLimit
            end
        end

        if minLimit and tonumber(data.count) < minLimit then
            cb("ok")
            return ESX.chatMessage(('Shoma bayad hadeaghal %sx bezarid'):format(minLimit), 'plarms')
        end

        ESX.TriggerServerEvent('customMarket:advertiseItem', data)
    end
    Wait(5000)
    countList = nil
    cb("ok")
end)



RegisterNUICallback('checkBlackMoney', function(data, cb)
    cb(true)
end)
