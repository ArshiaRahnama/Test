--[[
    sun-inventory — wardrobe client. Replaces every exports['sunset_clothe']
    call that used to be in client/clothe.lua (that resource doesn't exist
    anywhere on this server - see integration notes) with real logic against
    the lc_clothes table, using [SCRIPT]/skinchanger as the thing that
    actually paints/tracks components (see modules/wardrobe/common/config.lua
    for exactly why each WardrobeTypes entry is shaped the way it is).

    State: `worn[wardrobeType] = { id = rowId, snapshot = {key=oldValue,...} }`
    - snapshot is whatever the two skinchanger keys held right before this
      row was applied, so unequip is a perfect revert with no hardcoded
      "default" values to get wrong.
]]

local worn = {} -- [wardrobeType] = { id = rowId, snapshot = {...} }
local ownedCache = {} -- [wardrobeType] = { [id] = row }  (for GetClotheData lookups)

local function currentSkin()
    local skin
    TriggerEvent('skinchanger:getSkin', function(s) skin = s end)
    return skin or {}
end

local function applyPair(def, data, snapshotOut, skin)
    if def.kind == 'component' then
        local k1, k2 = def.pair[1], def.pair[2]
        if snapshotOut then snapshotOut[k1] = skin[k1]; snapshotOut[k2] = skin[k2] end
        TriggerEvent('skinchanger:change', k1, data[k1])
        TriggerEvent('skinchanger:change', k2, data[k2] or 0)
    elseif def.kind == 'prop' then
        local k1, k2 = def.pair[1], def.pair[2]
        if snapshotOut then snapshotOut[k1] = skin[k1]; snapshotOut[k2] = skin[k2] end
        TriggerEvent('skinchanger:change', k1, data[k1])
        TriggerEvent('skinchanger:change', k2, data[k2] or 0)
    end
end

local function revertPair(def, snapshot)
    local k1, k2 = def.pair[1], def.pair[2]
    TriggerEvent('skinchanger:change', k1, snapshot[k1] ~= nil and snapshot[k1] or (def.none or 0))
    TriggerEvent('skinchanger:change', k2, snapshot[k2] ~= nil and snapshot[k2] or 0)
end

local function saveSkin()
    TriggerEvent('skinchanger:getSkin', function(skin)
        TriggerServerEvent('esx_skin:save', skin)
    end)
end

-- exports['sunset_clothe']:getOwnedClotheByType(mode, true)
function GetOwnedClotheByType(wardrobeType)
    local rows = {}
    ESX.TriggerServerCallback('sun-wardrobe:getOwned', function(result)
        rows = result
    end, wardrobeType)

    ownedCache[wardrobeType] = {}
    for _, row in ipairs(rows) do
        ownedCache[wardrobeType][tostring(row.id)] = row
    end

    return rows
end
exports('getOwnedClotheByType', GetOwnedClotheByType)

-- exports['sunset_clothe']:getUsedType() -> { [wardrobeType] = true, ... }
function GetUsedType()
    local used = {}
    for wardrobeType, w in pairs(worn) do
        used[wardrobeType] = w.id
    end
    return used
end
exports('getUsedType', GetUsedType)

-- exports['sunset_clothe']:getOwnedPack()
function GetOwnedPack()
    local rows = {}
    ESX.TriggerServerCallback('sun-wardrobe:getPacks', function(result)
        rows = result
    end)
    ownedCache['outfit'] = {}
    for _, row in ipairs(rows) do
        ownedCache['outfit'][tostring(row.id)] = row
    end
    return rows
end
exports('getOwnedPack', GetOwnedPack)

-- exports['sunset_clothe']:unUseByType(mode) -- unequip whatever's worn in that slot
function UnUseByType(wardrobeType)
    local def = WardrobeTypes[wardrobeType]
    local w = worn[wardrobeType]
    if not def or not w then return end
    revertPair(def, w.snapshot)
    worn[wardrobeType] = nil
    saveSkin()
end
exports('unUseByType', UnUseByType)

-- exports['sunset_clothe']:toggleClothe(rowId) -- wear, or unwear if already worn
function ToggleClothe(rowIdStr)
    local rowId = tostring(rowIdStr)
    local row
    for wardrobeType, cache in pairs(ownedCache) do
        if cache[rowId] then row = cache[rowId]; break end
    end
    if not row then return end

    local def = WardrobeTypes[row.type]
    if not def then return end

    -- faction-lock is enforced at equip time too, not just purchase time
    local key = WardrobeValueKey(row.type, row.data)
    local lock = key and ClothShop.FactionLock[row.type] and ClothShop.FactionLock[row.type][key]
    if lock then
        local jobName = ESX.PlayerData.job and ESX.PlayerData.job.name
        local allowed = false
        for _, j in ipairs(lock) do if j == jobName then allowed = true break end end
        if not allowed then
            ESX.ShowNotification('Your job does not allow you to wear this item.')
            return
        end
    end

    if worn[row.type] and worn[row.type].id == row.id then
        -- already worn -> unwear
        UnUseByType(row.type)
        return
    end

    local skin = currentSkin()
    local snapshot = {}
    applyPair(def, row.data, snapshot, skin)
    worn[row.type] = { id = row.id, snapshot = snapshot }
    saveSkin()
end
exports('toggleClothe', ToggleClothe)

-- exports['sunset_clothe']:getClotheData(rowId) -> { type = ... } | nil
-- Returns nil for anything that isn't actually an owned wardrobe row id -
-- modules/job/client/main.lua relies on nil here to tell a clothing item
-- apart from an ordinary item when deciding whether to allow a job-stash
-- deposit.
function GetClotheData(rowIdStr)
    local rowId = tostring(rowIdStr)
    for wardrobeType, cache in pairs(ownedCache) do
        if cache[rowId] then return { type = cache[rowId].type } end
    end
    return nil
end
exports('getClotheData', GetClotheData)

-- exports['sunset_clothe']:createPack(name) -- save current full skin as a reusable outfit
function CreatePack(name)
    local skin = currentSkin()
    TriggerServerEvent('sun-wardrobe:createPack', name, skin)
end
exports('createPack', CreatePack)
