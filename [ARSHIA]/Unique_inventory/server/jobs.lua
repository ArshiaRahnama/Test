-- ============================================================================
-- Unique_inventory | server/jobs.lua
-- Job lockers (armory = weapons, storage = items) and the gang armory chest on the new
-- inventory. They keep using the SAME stores as before, so nothing stored is lost and the
-- boss panels / gang resources keep working:
--   job  : esx_datastore  'society_<job>' -> weapons list   +  esx_addoninventory 'society_<job>' -> items
--   gang : esx_datastore  'gang_<name>'   -> weapons list   +  esx_addoninventory 'gang_<name>'   -> items
-- Rules ported from the old inventory:
--   * a weapon is open for a rank only when it is ticked in the boss panel (job_grades.weapons)
--   * items follow Config.JobStockMinGrade and the ticks in job_grades.items
--   * gangs: item locks and the putitem / takeitem rank flags come from Unique_ALLGangs
--   * BlockedWeapons are never listed or handed out
-- New rules (because weapons now have a lifetime):
--   * only a PERMANENT weapon can be put into an armory (a 7/30-day weapon would come out
--     as a never-expiring armory weapon); taking one out gives a DOJ- (job) / GANG- (gang) serial
-- ============================================================================

local UNIQUE = UNIQUE

local BlockedWeapons = { WEAPON_SNIPERRIFLE = true, WEAPON_HEAVYSNIPER = true }
local TAKE_AMMO = 250

local function getInventory(name)
    local inv
    TriggerEvent('esx_addoninventory:getSharedInventory', name, function(i) inv = i end)
    return inv
end
local function getStore(name)
    local st
    TriggerEvent('esx_datastore:getSharedDataStore', name, function(s) st = s end)
    return st
end

local function itemLabel(name)
    local it = ESX and ESX.Items and ESX.Items[name]
    return (it and it.label) or name
end

local function isPermanent(serial)
    local m = UNIQUE.weaponMeta and UNIQUE.weaponMeta(serial)
    return m ~= nil and m.expireTS == nil
end

-- weapons: { { name, count, locked } }   items: { { name, count, locked } }
local function weaponRows(store, isLocked)
    local out = {}
    for _, w in ipairs((store and store.get('weapons')) or {}) do
        local name = w and w.name
        local count = tonumber(w and (w.count or w.ammo)) or 1
        if name and count > 0 and not BlockedWeapons[string.upper(name)] then
            out[#out + 1] = { name = name, count = count, locked = isLocked(name) or nil }
        end
    end
    return out
end

local function itemRows(inventory, isLocked)
    local out = {}
    for _, it in ipairs((inventory and inventory.items) or {}) do
        local count = tonumber(it and it.count) or 0
        if it and it.name and count > 0 then
            out[#out + 1] = { name = it.name, count = count, locked = isLocked(it.name) or nil }
        end
    end
    return out
end

local function plainItem(xp, name)
    for _, row in ipairs(xp.inventory or {}) do
        if row.name == name and not row.info then return row end
    end
end
local function hasInfoRows(xp, name)
    for _, row in ipairs(xp.inventory or {}) do
        if row.name == name and row.info then return true end
    end
    return false
end

-- take one weapon out of a counted weapons list
local function takeFromWeaponList(store, upper)
    local weapons = store.get('weapons') or {}
    for i = 1, #weapons do
        if string.upper(weapons[i].name) == upper then
            local left = (tonumber(weapons[i].count or weapons[i].ammo) or 1) - 1
            if left <= 0 then table.remove(weapons, i) else weapons[i].count = left weapons[i].ammo = nil end
            store.set('weapons', weapons)
            return true
        end
    end
    return false
end

local function addToWeaponList(store, upper)
    local weapons = store.get('weapons') or {}
    for i = 1, #weapons do
        if string.upper(weapons[i].name) == upper then
            weapons[i].count = (tonumber(weapons[i].count or weapons[i].ammo) or 0) + 1
            weapons[i].ammo = nil
            store.set('weapons', weapons)
            return
        end
    end
    weapons[#weapons + 1] = { name = upper, count = 1 }
    store.set('weapons', weapons)
end

-- is this weapon ticked for the rank?  (no row at all = fail-open)
local function weaponAuthorized(job, grade, name)
    local list, found = GetJobGradePerm(job, grade, 'weapons')
    if not found then return true end
    local wname = string.lower(name)
    for _, shared in ipairs(list) do
        local model = shared.model or shared.name
        if model and string.lower(model) == wname and shared.status == true then return true end
    end
    return false
end

-- --------------------------------------------------------------------------
-- common move logic (job and gang differ only in stores, locks and serial prefix)
-- --------------------------------------------------------------------------
local function takeWeapon(src, xp, store, name, serialPrefix, locked)
    local upper = string.upper(tostring(name or ''))
    if upper == '' or BlockedWeapons[upper] then return false end
    if locked then UNIQUE.notify(src, 'این سلاح برای رتبه‌ی شما قفل است') return false end
    if xp.hasWeapon(upper) then UNIQUE.notify(src, 'این سلاح را از قبل دارید') return false end
    if not xp.canCarryItem(upper, 1) then UNIQUE.notify(src, 'ظرفیت حمل شما کافی نیست') return false end
    if not store or not takeFromWeaponList(store, upper) then return false end
    local serial = ESX.GenerateWeaponSerial and ESX.GenerateWeaponSerial(serialPrefix) or nil
    xp.addWeapon(upper, TAKE_AMMO, serial)
    return true
end

local function putWeapon(src, xp, store, data)
    local meta = type(data.metadata) == 'table' and data.metadata or {}
    local w = UNIQUE.findWeapon(xp, meta.serial, data.name)
    if not w or not store then return false end
    local upper = string.upper(w.name)
    if BlockedWeapons[upper] then return false end
    if not isPermanent(w.serial) then
        UNIQUE.notify(src, 'سلاح موقت (۷/۳۰ روزه) قابل ذخیره در آرموری نیست')
        return false
    end
    xp.removeWeapon(w.name, tonumber(w.ammo) or 0, w.serial)
    TriggerClientEvent('core:removeWeapon', src, w.name, w.serial)
    UNIQUE.forgetSerial(UNIQUE.loadSlots(xp), w.serial)
    UNIQUE.markDirty(xp)
    addToWeaponList(store, upper)
    return true
end

local function takeItem(src, xp, inventory, data, locked)
    local name = string.lower(tostring(data.name or ''))
    local count = UNIQUE.validCount(data.count)
    if name == '' or not count or not inventory then return false end
    if locked then UNIQUE.notify(src, 'این آیتم برای رتبه‌ی شما قفل است') return false end
    local stock = inventory.getItem(name)
    if not stock or (stock.count or 0) < count then return false end
    if not xp.canCarryItem(name, count) then UNIQUE.notify(src, 'ظرفیت حمل شما کافی نیست') return false end
    local mine = xp.getInventoryItem(name)
    if mine and mine.limit and mine.limit ~= -1 and (mine.count or 0) + count > mine.limit then return false end
    inventory.removeItem(name, count)
    xp.addInventoryItem(name, count)
    return true
end

local function putItem(src, xp, inventory, data)
    local name = string.lower(tostring(data.name or ''))
    local mine = name ~= '' and plainItem(xp, name)
    local count = mine and UNIQUE.validCount(data.count, mine.count)
    if not count or not inventory then return false end
    if mine.canRemove == false then return false end
    if hasInfoRows(xp, name) then
        UNIQUE.notify(src, 'این آیتم (مثل کلید ماشین) قابل ذخیره نیست')
        return false
    end
    xp.removeInventoryItem(name, count)
    inventory.addItem(name, count)
    return true
end

local function finish(src, key)
    TriggerClientEvent('esx:updateInventory', src)
    UNIQUE.saveSoon(src)
    UniqueStash.broadcast(key)
end

-- --------------------------------------------------------------------------
-- JOB:  key = 'job:<jobName>'
-- --------------------------------------------------------------------------
local function jobOf(xp, key)
    local job = type(key) == 'string' and key:match('^job:(.+)$')
    if xp and xp.job and job and xp.job.name == job and job ~= 'unemployed' then return job end
end

local function jobStores(job)
    return getInventory('society_' .. job), getStore('society_' .. job)
end

UniqueStash.register('job:', {
    authorize = function(src, key) return jobOf(UNIQUE.player(src), key) ~= nil end,
    view = function(src, key)
        local xp = UNIQUE.player(src)
        local job = jobOf(xp, key)
        if not job then return { items = {}, weapons = {} } end
        local inventory, store = jobStores(job)
        return {
            weapons = weaponRows(store, function(n) return not weaponAuthorized(job, xp.job.grade, n) end),
            items = itemRows(inventory, function(n) return IsJobItemLocked(xp, n) end),
        }
    end,
})

local function jobMove(kind, src, jobName, data)
    if UNIQUE.limited(src, 'job' .. kind, 300) then return end
    local xp = UNIQUE.player(src)
    local key = 'job:' .. tostring(jobName)
    local job = jobOf(xp, key)
    if not job or type(data) ~= 'table' or type(data.name) ~= 'string' then return end
    local inventory, store = jobStores(job)
    local isWeapon = UNIQUE.isWeaponName(data.name)
    local ok
    if kind == 'get' then
        if isWeapon then
            ok = takeWeapon(src, xp, store, data.name, 'DOJ', not weaponAuthorized(job, xp.job.grade, data.name))
        else
            ok = takeItem(src, xp, inventory, data, IsJobItemLocked(xp, string.lower(data.name)))
        end
    else
        ok = isWeapon and putWeapon(src, xp, store, data) or (not isWeapon and putItem(src, xp, inventory, data))
    end
    if ok then
        print(('^3[Unique_inventory]^0 job %s: %s %s %s x%s (%s)'):format(job, kind, isWeapon and 'weapon' or 'item', data.name, tostring(data.count or 1), tostring(xp.identifier)))
        finish(src, key)
    end
end

RegisterNetEvent('inventory-job:put', function(jobName, data) jobMove('put', source, jobName, data) end)
RegisterNetEvent('inventory-job:get', function(jobName, data) jobMove('get', source, jobName, data) end)
RegisterNetEvent('inventory-job:updateSlot', function() end)   -- the lockers are counted lists, no slot layout

-- (kept for the job module's getJobInventory)
RegisterServerCallbackSafe('inventory-job:getInventory', function(source, cb, jobName)
    local key = 'job:' .. tostring(jobName)
    local provider = UniqueStash.providerFor(key)
    if not provider or not provider.authorize(source, key) then return cb({ items = {}, weapons = {}, slots = {} }) end
    local v = provider.view(source, key)
    cb({ items = v.items, weapons = v.weapons, slots = {} })
end)

-- --------------------------------------------------------------------------
-- GANG:  key = 'gang:<armoryKey>'   (armoryKey empty = the gang's first armory)
-- --------------------------------------------------------------------------
local function armoryKeyOf(key)
    local k = type(key) == 'string' and key:match('^gang:(.*)$')
    if k == nil then return nil, false end
    if k == '' then return nil, true end
    return tonumber(k) or k, true
end

local function gangFlag(src, gangName, flag)
    local ok, answered = true, false
    TriggerEvent('Unique_ALLGangs:checkGangFlag', src, gangName, flag, function(v) answered = true ok = v and true or false end)
    if not answered then return true end
    return ok
end

local function gangStores(xp, armoryKey)
    local storeName = ResolveGangStoreName(xp, armoryKey)
    if not storeName then return nil end
    return EnsureGangStores(xp.gang.name, storeName)
end

local function gangOf(xp)
    return xp and xp.gang and xp.gang.name and xp.gang.name ~= 'nogang' and xp.gang.name or nil
end

UniqueStash.register('gang:', {
    authorize = function(src, key)
        local xp = UNIQUE.player(src)
        local armoryKey, ok = armoryKeyOf(key)
        if not ok or not gangOf(xp) then return false end
        return ResolveGangStoreName(xp, armoryKey) ~= nil
    end,
    view = function(src, key)
        local xp = UNIQUE.player(src)
        local armoryKey = armoryKeyOf(key)
        if not gangOf(xp) then return { items = {}, weapons = {} } end
        local inventory, store = gangStores(xp, armoryKey)
        local function locked(n) return IsGangItemLocked(xp, n, armoryKey) end
        return { weapons = weaponRows(store, locked), items = itemRows(inventory, locked) }
    end,
})

local function gangMove(kind, src, armoryKeyRaw, data)
    if UNIQUE.limited(src, 'gang' .. kind, 300) then return end
    local xp = UNIQUE.player(src)
    if not gangOf(xp) or type(data) ~= 'table' or type(data.name) ~= 'string' then return end
    local armoryKey = tonumber(armoryKeyRaw) or armoryKeyRaw
    if armoryKey == '' then armoryKey = nil end
    local key = 'gang:' .. tostring(armoryKey or '')
    local flag = kind == 'get' and 'takeitem' or 'putitem'
    if not gangFlag(src, xp.gang.name, flag) then
        UNIQUE.notify(src, kind == 'get' and 'رتبه‌ی شما نمی‌تواند از صندوق گنگ بردارد' or 'رتبه‌ی شما نمی‌تواند به صندوق گنگ بگذارد')
        return
    end
    local inventory, store = gangStores(xp, armoryKey)
    if not inventory and not store then
        UNIQUE.notify(src, 'این آرموری در دسترس نیست (دوباره باز کنید)')
        return
    end
    local isWeapon = UNIQUE.isWeaponName(data.name)
    local ok
    if kind == 'get' then
        local locked = IsGangItemLocked(xp, isWeapon and data.name or string.lower(data.name), armoryKey)
        if isWeapon then ok = takeWeapon(src, xp, store, data.name, 'GANG', locked)
        else ok = takeItem(src, xp, inventory, data, locked) end
    else
        ok = isWeapon and putWeapon(src, xp, store, data) or (not isWeapon and putItem(src, xp, inventory, data))
    end
    if ok then
        print(('^3[Unique_inventory]^0 gang %s: %s %s %s x%s (%s)'):format(xp.gang.name, kind, isWeapon and 'weapon' or 'item', data.name, tostring(data.count or 1), tostring(xp.identifier)))
        finish(src, key)
    end
end

RegisterNetEvent('inventory-gang:put', function(armoryKey, data) gangMove('put', source, armoryKey, data) end)
RegisterNetEvent('inventory-gang:get', function(armoryKey, data) gangMove('get', source, armoryKey, data) end)
RegisterNetEvent('inventory-gang:updateSlot', function() end)

-- title of the chest: "Gang Armory & Storage" (+ " - Armory N" when the gang has several)
RegisterServerCallbackSafe('Unique_inventory:getGangArmoryTitle', function(source, cb, armoryKey)
    local xp = UNIQUE.player(source)
    local title = 'Gang Armory & Storage'
    if xp and xp.gang then
        TriggerEvent('Unique_ALLGangs:getArmoryNumber', source, xp.gang.name, armoryKey, function(pos, total)
            if (tonumber(total) or 0) > 1 then title = title .. ' - Armory ' .. tostring(pos) end
        end)
    end
    cb(title)
end)
