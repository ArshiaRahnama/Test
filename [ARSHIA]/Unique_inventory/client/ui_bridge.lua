-- This Script Dump By FleeX Team  , discord.gg/2D79ZtUjxB

local function isClotheItem(name)
    local ok, data = pcall(function()
        return exports['sunset_clothe']:getClotheData(name)
    end)
    return ok and data ~= nil
end

local function isTradeBlocked(name, isClothe)
    if isClothe then return true end
    if type(name) ~= 'string' then return false end
    if name:find('key_') or name:find('pack_') then return true end
    if ESX.doesBlockedItem(name) and name ~= 'persuit_1' then return true end
    local job = ESX.GetPlayerData().job
    if job and ESX.doesBlockedItemJob(name, job.name) then return true end
    return false
end

local function resolveLabel(v, isWeapon)
    if v.label and v.label ~= '' then
        return v.label
    end
    if v.data and v.data.label then
        return v.data.label
    end
    if isWeapon then
        local ok, lbl = pcall(function() return ESX.GetWeaponLabel(v.name) end)
        if ok and lbl then return lbl end
    else
        local ok, item = pcall(function() return ESX.getItem(v.name) end)
        if ok and item and item.label then return item.label end
    end
    return v.name
end

local function weaponLabel(name)
    local ok, lbl = pcall(function() return ESX.GetWeaponLabel(name) end)
    if ok and lbl then return lbl end
    return name
end

local function weaponDifficulty(name)
    local ok, w = pcall(function() return ESX.GetWeapon(name) end)
    if ok and w and w.difficulty then return w.difficulty end
    return 1
end

local function readWeaponSlot()
    local ok, slot = pcall(function() return exports['Unique_inventory']:getWeaponSlot() end)
    if ok and type(slot) == 'table' then return slot end
    return {}
end

local function readMaketSlot()
    local ok, slot = pcall(function() return exports['Unique_inventory']:getMaketSlot() end)
    if ok and type(slot) == 'table' then return slot end
    return {}
end

local function buildSlots(slotTable, size, bySerial)
    local out = {}
    for i = 1, size do
        local v = slotTable[i] or slotTable[tostring(i)]
        if type(v) == 'table' and v.name then
            local extra = (v.serial and bySerial and bySerial[v.serial]) or {}
            out[i] = {
                name       = v.name,
                label      = weaponLabel(v.name),
                iconUrl    = getImage(v.name),
                serial     = v.serial,
                difficulty = weaponDifficulty(v.name),
                weapon     = true,
                ammo       = extra.ammo,
                metadata   = extra.metadata,
                components = extra.components,
                info       = extra.info,
            }
        else
            out[i] = false
        end
    end
    return out
end

local function slottedSerials(weaponSlot, maketSlot)
    local set = {}
    for _, v in pairs(weaponSlot) do
        if type(v) == 'table' and v.serial then set[v.serial] = true end
    end
    for _, v in pairs(maketSlot) do
        if type(v) == 'table' and v.serial then set[v.serial] = true end
    end
    return set
end

local function resolveWeaponConfig(name)
    local ok, a, b = pcall(function() return ESX.GetWeapon(string.upper(name)) end)
    return (ok and type(a) == 'table' and a) or (ok and type(b) == 'table' and b) or nil
end

local function buildItemDetail(name, isWeapon, v)
    local d = {}
    if isWeapon then
        local cfg = resolveWeaponConfig(name)
        d.weight = cfg and cfg.weight
        if v then
            local maxShots = cfg and cfg.maxShots
            local shots = (v.metadata and v.metadata.shots) or 0
            if maxShots then
                local h = ESX.Math.Round(100 - shots * 100 / maxShots, 1)
                if h < 0 then h = 0 end
                d.health = h
            else
                d.health = 100
            end
            d.ammo = v.ammo or v.count
            d.expireTS = v.metadata and v.metadata.expireTS
            local tintIndex = v.tint or v.tintIndex or (v.metadata and (v.metadata.tint or v.metadata.tintIndex)) or 0
            if tintIndex and tintIndex > 0 and tintLabel and tintLabel[tintIndex] then
                d.tint = tintLabel[tintIndex]
            end
            local atts = {}
            local comps = v.components or (v.metadata and v.metadata.components) or {}
            for _, c in pairs(comps) do
                local ok, comp = pcall(function() return ESX.GetWeaponComponent(name, c) end)
                if ok and type(comp) == 'table' and comp.label then
                    atts[#atts + 1] = comp.label
                end
            end
            d.attachments = atts
        end
    else
        local ok, it = pcall(function() return ESX.getItem(name) end)
        if ok and type(it) == 'table' then
            d.description = it.description
            d.weight = it.weight
            d.limit = it.limit
        end
    end
    d.noDelete = (config and config.NoDelete and config.NoDelete[name]) or nil
    return d
end

function SendUIInventory(playerItems, usedClotheWeight, maxWeight)
    local filled = fillItems(playerItems)

    local weaponSlot = readWeaponSlot()
    local maketSlot = readMaketSlot()
    local inSlot = slottedSerials(weaponSlot, maketSlot)

    local flat = {}
    local bySerial = {}
    local totalWeight = tonumber(usedClotheWeight) or 0

    for _, v in pairs(filled) do
        if type(v) == 'table' and v.name and v.name ~= 'empty' and v.name ~= 'locked' then
            local isWeapon = getItemType(v.name) == 'item_weapon'
            local serial = v.metadata and v.metadata.serial
            local inSlotWeapon = isWeapon and serial and inSlot[serial]

            local isClothe = isClotheItem(v.name)
            local count = tonumber(v.count) or 1
            local weight = tonumber(v.weight) or 0

            if isWeapon then
                totalWeight = totalWeight + weight * (tonumber(v.realCount) or 1)
                if serial then
                    bySerial[serial] = {
                        ammo = tonumber(v.ammo) or count,
                        metadata = v.metadata,
                        components = v.components or (v.metadata and v.metadata.components),
                        info = buildItemDetail(v.name, true, v),
                    }
                end
            else
                totalWeight = totalWeight + weight * count
            end

            if not inSlotWeapon then
                flat[#flat + 1] = {
                    name       = v.name,
                    label      = resolveLabel(v, isWeapon),
                    count      = count,
                    iconUrl    = v.image,
                    weapon     = isWeapon or nil,
                    clothe     = isClothe or nil,
                    difficulty = tonumber(v.difficulty) or 1,
                    serial     = isWeapon and serial or nil,
                    isMaket    = (isWeapon and IsMaketWeapon(v.name)) or nil,
                    ammo       = isWeapon and (tonumber(v.ammo) or count) or nil,
                    metadata   = v.metadata,
                    components = isWeapon and (v.components or (v.metadata and v.metadata.components)) or nil,
                    info       = buildItemDetail(v.name, isWeapon, v),
                    tradeBlocked = isTradeBlocked(v.name, isClothe) or nil,
                    attachment = (config and config.attachments and config.attachments[v.name]) or nil,
                }
            end
        end
    end

    maxWeight = tonumber(maxWeight) or 50
    local playerName = ''
    local ok, n = pcall(function() return ESX.GetPlayerData().name2 end)
    if ok and n then playerName = n end
    local job = ESX.GetPlayerData().job

    local serverTime = 0
    local okT, st = pcall(function() return exports['sunset_utils']:GetServerOSTime() end)
    if okT and tonumber(st) then serverTime = tonumber(st) end

    SendNUIMessage({
        action = 'showInventory',
        items  = flat,
        serverTime = serverTime,
        weaponSlots = buildSlots(weaponSlot, 3, bySerial),
        maketSlots = buildSlots(maketSlot, 2, bySerial),
        shortcuts = InvShortcuts or {},
        player = {
            name      = playerName,
            weight    = math.floor(totalWeight * 10 + 0.5) / 10,
            maxWeight = maxWeight,
            military  = (job and ESX.militaryJobs[job.name]) and true or false,
        },
    })
end

function getSecondLazy(key, mode, weaponName, location)
    local p = promise.new()
    ESX.TriggerServerCallback('sunset_inventory:getSecond', function(data)
        p:resolve(data)
    end, key, mode, weaponName, location)
    return Citizen.Await(p)
end
exports('getSecondLazy', getSecondLazy)

local lastSecondSig = nil

function SendUISecondView(raw, mode, tab, openWeapon, label, maxWeight, kind, canSearch, force, tabCounts)
    local flat = {}
    local weight = nil

    if type(raw) == 'table' then
        weight = raw.weight
        raw.weight = nil
        if tabCounts == nil then tabCounts = raw.tabCounts end
        raw.tabCounts = nil
    end

    if mode == 'groups' then
        for _, g in ipairs(raw or {}) do
            local name = g.name
            flat[#flat + 1] = {
                name       = name,
                label      = weaponLabel(name),
                iconUrl    = getImage(name),
                difficulty = weaponDifficulty(name),
                count      = tonumber(g.count) or 0,
                weapon     = true,
                group      = true,
                info       = buildItemDetail(name, true, nil),
                locked     = g.locked or nil,
                locked2    = g.locked2 or nil,
            }
        end
    else
        local list
        if mode == 'flat' then
            list = raw or {}
        elseif mode == 'items' then
            list = (raw and raw.items) or {}
            fillItems(list)
        else
            list = raw or {}
            fillItems(list)
        end

        for _, v in ipairs(list) do
            if type(v) == 'table' and v.name and v.name ~= 'empty' and v.name ~= 'locked' then
                local isWeapon = getItemType(v.name) == 'item_weapon'
                local serial = v.metadata and v.metadata.serial
                local count
                if isWeapon then
                    count = tonumber(v.count) or tonumber(v.ammo) or 0
                else
                    count = tonumber(v.count) or 1
                end
                flat[#flat + 1] = {
                    name       = v.name,
                    label      = v.label or resolveLabel(v, isWeapon),
                    count      = count,
                    iconUrl    = v.image or getImage(v.name),
                    weapon     = isWeapon or nil,
                    clothe     = (not isWeapon and isClotheItem(v.name)) or nil,
                    difficulty = tonumber(v.difficulty) or (isWeapon and weaponDifficulty(v.name)) or 1,
                    serial     = isWeapon and serial or nil,
                    isMaket    = (isWeapon and IsMaketWeapon(v.name)) or nil,
                    ammo       = tonumber(v.ammo) or (isWeapon and count) or nil,
                    weight     = tonumber(v.weight) or 0,
                    metadata   = v.metadata,
                    components = isWeapon and (v.components or (v.metadata and v.metadata.components)) or nil,
                    info       = buildItemDetail(v.name, isWeapon, v),
                    locked     = v.locked or nil,
                    locked2    = v.locked2 or nil,
                }
            end
        end
    end

    local msg = {
        action     = 'updateSecondInventory',
        view       = mode,
        items      = flat,
        tab        = tab,
        openWeapon = openWeapon,
        label      = label,
        maxWeight  = maxWeight,
        weight     = weight,
        kind       = kind,
        canSearch  = canSearch,
        tabCounts  = tabCounts,
    }
    local sig = json.encode(msg)
    if not force and sig == lastSecondSig then return end
    lastSecondSig = sig
    SendNUIMessage(msg)
end

RegisterNUICallback('useItem', function(data, cb)
    if data and data.name then
        local rule = config.UseConfirm and config.UseConfirm[data.name]
        if rule then
            SendNUIMessage({
                action = 'confirmUse',
                name = data.name,
                label = data.label or data.name,
                message = (type(rule) == 'string') and rule or nil,
            })
        else
            ESX.TriggerServerEvent('esx:useItem', data.name)
        end
    end
    cb({ ok = true })
end)

RegisterNUICallback('useItemConfirmed', function(data, cb)
    if data and data.name then
        ESX.TriggerServerEvent('esx:useItem', data.name)
    end
    cb({ ok = true })
end)

