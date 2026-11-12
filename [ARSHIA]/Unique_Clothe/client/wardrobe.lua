-- Unique_clothe / client / wardrobe
-- Exports used by Unique_inventory (the clothing tab): getClotheData, getUsed,
-- getUsedType, getOwnedClotheByType, getOwnedPack, toggleClothe, unUseByType.
-- Clothes are inventory items; what is worn is tracked here and validated/saved
-- by the server.

ESX = nil
Wardrobe = {}

local usedMap = {}          -- itemName -> true (currently worn)
local loaded = false
local sendTimer = 0
local graceUntil = {}       -- itemName -> time until which "not in inventory yet" is tolerated
local strikes = {}

CreateThread(function()
    while ESX == nil do
        TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
        Wait(100)
    end
end)

-- ───────────── helpers ─────────────
local function inventory()
    local data = ESX and ESX.GetPlayerData and ESX.GetPlayerData() or nil
    return data and data.inventory or {}
end

local function ownedCount(name)
    for _, it in ipairs(inventory()) do
        if it.name == name then return it.count or 0 end
    end
    return 0
end

local function mySex()
    local sex = 0
    TriggerEvent('skinchanger:getSkin', function(skin) sex = (skin and skin.sex == 1) and 1 or 0 end)
    return sex
end

local function applyKeys(keys)
    if keys and next(keys) then TriggerEvent('skinchanger:loadStuff', keys) end
end

local function copyMap(m)
    local c = {}
    for k, v in pairs(m) do c[k] = v end
    return c
end

-- debounce: several quick toggles (packs, take-off-all) become one server update
local function scheduleSend()
    sendTimer = sendTimer + 1
    local mine = sendTimer
    SetTimeout(250, function()
        if mine == sendTimer then
            TriggerServerEvent('Unique_Clothe:setUsed', copyMap(usedMap))
        end
    end)
end

local function wornNameOfType(ctype)
    for name in pairs(usedMap) do
        local it = Clothes.byName[name]
        if it and it.type == ctype then return name end
    end
    return nil
end

-- ───────────── core ─────────────
-- Put an item on (no toggle). Returns true if applied.
function Wardrobe.wear(name, force)
    local item = Clothes.byName[name]
    if not item then return false end
    if not force and ownedCount(name) < 1 then return false end
    if item.sex ~= mySex() then return false end

    local previous = wornNameOfType(item.type)
    if previous then usedMap[previous] = nil end
    usedMap[name] = true
    graceUntil[name] = GetGameTimer() + 10000
    applyKeys(item.num)
    scheduleSend()
    return true
end

function Wardrobe.unUseType(ctype)
    local name = wornNameOfType(ctype)
    if name then usedMap[name] = nil end
    local defaults = Config.Defaults[mySex()][ctype]
    applyKeys(defaults)
    if name then scheduleSend() end
end

-- ───────────── exports ─────────────
exports('getClotheData', function(name)
    local item = Clothes.byName[name]
    if not item then return nil end
    return { name = item.name, type = item.type, label = item.label, sex = item.sex, num = item.num, price = item.price, antiSearch = false }
end)

exports('getUsed', function()
    return copyMap(usedMap)
end)

exports('getUsedType', function()
    local t = {}
    for name in pairs(usedMap) do
        local it = Clothes.byName[name]
        if it then t[it.type] = true end
    end
    return t
end)

exports('getOwnedClotheByType', function(mode, sexCheck)
    local list = {}
    local sex = sexCheck and mySex() or nil
    for _, inv in ipairs(inventory()) do
        local item = (inv.count or 0) > 0 and Clothes.byName[inv.name] or nil
        if item and item.type == mode and (sex == nil or item.sex == sex) then
            list[#list + 1] = {
                name = item.name, label = inv.label or item.label, type = item.type,
                count = inv.count, used = usedMap[item.name] == true,
            }
        end
    end
    table.sort(list, function(a, b) return a.name < b.name end)
    return list
end)

exports('getOwnedPack', function()
    local list = {}
    for _, inv in ipairs(inventory()) do
        if (inv.count or 0) > 0 and type(inv.name) == 'string' and inv.name:find('^pack_%d+$') then
            list[#list + 1] = { name = inv.name, label = inv.label or inv.name, count = inv.count }
        end
    end
    return list
end)

-- toggleClothe(name, silent, force): wear it, or take it off if it is already worn.
local function toggleClothe(name, silent, force)
    local item = Clothes.byName[name]
    if not item then return false end
    if usedMap[name] then
        Wardrobe.unUseType(item.type)
        return true
    end
    local ok = Wardrobe.wear(name, force)
    if not ok and not silent and ESX and ESX.ShowNotification then
        ESX.ShowNotification(item.sex ~= mySex() and Config.Strings.wrong_sex or Config.Strings.invalid)
    end
    return ok
end
exports('toggleClothe', toggleClothe)

-- the server sends this when a clothing item is "used" from the inventory
RegisterNetEvent('Unique_Clothe:toggle')
AddEventHandler('Unique_Clothe:toggle', function(name)
    if type(name) == 'string' then toggleClothe(name) end
end)

exports('unUseByType', function(ctype)
    Wardrobe.unUseType(ctype)
end)

-- ───────────── sync with the server ─────────────
CreateThread(function()
    while not loaded do
        Wait(2000)
        if ESX and ESX.TriggerServerCallback then
            ESX.TriggerServerCallback('Unique_Clothe:getUsed', function(map)
                if type(map) == 'table' then
                    usedMap = {}
                    for name, v in pairs(map) do
                        if v == true and Clothes.byName[name] then usedMap[name] = true end
                    end
                    loaded = true
                    -- tell unique_character the clothing system is ready (it waits for this)
                    TriggerEvent('unique_character:clothesReady')
                end
            end)
        end
    end
end)

-- If a worn item leaves the inventory (dropped, traded, stored) take it off visually.
-- Three misses in a row are required so a slow inventory sync can never strip a player.
CreateThread(function()
    while true do
        Wait(3000)
        if loaded and next(usedMap) then
            local now = GetGameTimer()
            for name in pairs(copyMap(usedMap)) do
                if ownedCount(name) < 1 and now > (graceUntil[name] or 0) then
                    strikes[name] = (strikes[name] or 0) + 1
                    if strikes[name] >= 3 then
                        strikes[name] = nil
                        local item = Clothes.byName[name]
                        if item then Wardrobe.unUseType(item.type) end
                    end
                else
                    strikes[name] = nil
                end
            end
        end
    end
end)
