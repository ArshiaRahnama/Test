-- Unique_Crafting (server). Config: crafting/config.lua (CraftConfig).
-- Two kinds of workbench:
--   PUBLIC   (config): anyone, only the listed recipes, ingredients from the player's own bag.
--   GUN SHOP (one per owned gun shop, from GunShopBenches): only the owner gang, only members
--            with grade >= craftRank, all recipes, ingredients taken from the GANG ARMORY.
-- The crafted item always goes to the player who pressed craft.

if not ESX then TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end) end

local PendingCrafts = {}   -- [src] = { item, count, readyAt, expiresAt, armoryGang }

local function num(v) return tonumber(v) or 0 end
local function notify(src, msg) TriggerClientEvent('Unique_Crafting:sendMessage', src, msg) end

local function gangOf(x)
    if not x or not x.gang or x.gang.name == 'nogang' then return nil end
    return x.gang.name
end

local function gangLevel(gang)
    local g = gang and Gangs and Gangs[gang]
    return g and num(g.level) or 0
end

-- every workbench: the public ones from config + one per owned gun shop
local function allBenches()
    local list = {}
    for _, b in ipairs(CraftConfig.Workbenches) do list[#list + 1] = b end
    for _, b in ipairs(GunShopBenches()) do list[#list + 1] = b end
    return list
end

local function benchNear(src)
    local ped = GetPlayerPed(src)
    if not ped or ped == 0 then return nil end
    local p = GetEntityCoords(ped)
    for _, b in ipairs(allBenches()) do
        if #(p - b.coords) <= (b.radius or 3.0) + 2.0 then return b end
    end
    return nil
end

-- the gun shop behind a shop bench (nil for public benches)
local function shopOf(bench)
    if bench.public or not bench.shopId then return nil end
    return Shops[bench.shopId]
end

local function recipeAllowed(bench, item)
    if not CraftConfig.Recipes[item] then return false end
    local list = bench.recipes or {}
    if bench.public then
        for _, n in ipairs(list) do if n == item then return true end end
        return false
    end
    if #list == 0 then return true end
    for _, n in ipairs(list) do if n == item then return true end end
    return false
end

-- may this player use this bench at all?
-- Manage Rank Access -> "Crafting Access" (or Full Boss Access) on the player's rank
local function hasCraftAccess(x)
    local gang = gangOf(x)
    local g = gang and Gangs and Gangs[gang]
    local grade = g and g.grades and g.grades[tonumber(x.gang.grade)]
    local a = grade and grade.access or {}
    return a.crafting == true or a.bossaction == true
end

local function canUse(x, bench)
    if bench.public then return true end
    local shop = shopOf(bench)
    local gang = gangOf(x)
    if not shop or not gang or shop.owner ~= gang then return false, 'Faghat gang-e sahebe in gunshop mitoone craft kone' end
    if not hasCraftAccess(x) then return false, 'Dastresi-ye Crafting baraye rank-e shoma faal nist' end
    return true
end

-- how much of an ingredient is available for this craft
local function available(x, bench, item)
    if bench.public then
        local it = x.getInventoryItem(item)
        return it and num(it.count) or 0
    end
    local ok, n = pcall(function() return exports['Unique_inventory']:GetGangArmoryItemCount(gangOf(x), item) end)
    return ok and num(n) or 0
end

local function hasIngredients(x, bench, r)
    for k, v in pairs(r.Ingredients) do
        if available(x, bench, k) < num(v) then return false, k end
    end
    return true
end

-- take the ingredients (permanent ones are required but never used up)
local function takeIngredients(x, bench, r)
    for k, v in pairs(r.Ingredients) do
        if not CraftConfig.PermanentItems[k] then
            if bench.public then
                x.removeInventoryItem(k, num(v))
            else
                exports['Unique_inventory']:RemoveGangArmoryItem(gangOf(x), k, num(v))
            end
        end
    end
end

-- ───────── open ─────────
ESX.RegisterServerCallback('Unique_Crafting:open', function(source, cb)
    local x = ESX.GetPlayerFromId(source)
    local bench = benchNear(source)
    if not x or not bench then return cb({ ok = false, reason = 'Nazdik-e workbench nistid' }) end
    local ok, reason = canUse(x, bench)
    if not ok then return cb({ ok = false, reason = reason }) end

    local recipes, stock = {}, {}
    for name, r in pairs(CraftConfig.Recipes) do
        if recipeAllowed(bench, name) and (not r.Business or GangOwnsBusiness(gangOf(x), r.Business)) then
            recipes[name] = r
            for k in pairs(r.Ingredients) do stock[k] = available(x, bench, k) end
        end
    end
    local rank = bench.public and 9999 or gangLevel(gangOf(x))
    cb({ ok = true, recipes = recipes, rank = rank, public = bench.public,
         categories = CraftConfig.Categories, inventory = (not bench.public) and stock or nil })
end)

-- every workbench the client should draw (public + owned gun shops)
ESX.RegisterServerCallback('Unique_Crafting:benches', function(source, cb)
    local out = {}
    for _, b in ipairs(allBenches()) do
        out[#out + 1] = { coords = { x = b.coords.x, y = b.coords.y, z = b.coords.z }, radius = b.radius or 3.0, public = b.public }
    end
    cb(out)
end)

ESX.RegisterServerCallback('Unique_Crafting:getItemNames', function(source, cb)
    MySQL.Async.fetchAll('SELECT name, label FROM items', {}, function(rows)
        local names = {}
        for _, v in ipairs(rows or {}) do names[v.name] = v.label end
        cb(names)
    end)
end)

-- ───────── craft: start ─────────
RegisterServerEvent('Unique_Crafting:craft')
AddEventHandler('Unique_Crafting:craft', function(item)
    local src = source
    local x = ESX.GetPlayerFromId(src)
    if not x or type(item) ~= 'string' then return end

    local bench = benchNear(src)
    if not bench then return notify(src, 'Nazdik-e workbench nistid') end
    if PendingCrafts[src] then return notify(src, 'Ye craft dar hal-e anjam ast') end

    local r = CraftConfig.Recipes[item]
    if not r or not recipeAllowed(bench, item) then return notify(src, 'In craft dar in makan mojaz nist') end
    local ok, reason = canUse(x, bench)
    if not ok then return notify(src, reason) end

    if not bench.public and gangLevel(gangOf(x)) < num(r.Level) then
        return notify(src, 'Level-e gang kafi nist')
    end
    if r.Business and not GangOwnsBusiness(gangOf(x), r.Business) then
        return notify(src, 'In recipe faghat baraye gang-e sahebe in kasb-o-kar ast.')
    end

    local has, missing = hasIngredients(x, bench, r)
    if not has then
        return notify(src, ('Mavad-e kafi nadarid (%s)%s'):format(tostring(missing),
            bench.public and '' or ' - dar armory-e gang nist'))
    end

    if CraftConfig.UseLimitSystem then
        local xItem = x.getInventoryItem(item)
        if xItem and xItem.limit ~= -1 and xItem.count + num(r.Amount) > xItem.limit then
            return notify(src, 'Shoma nemitavanid in item ro bardarid')
        end
    end

    takeIngredients(x, bench, r)

    local now = os.time()
    local time = num(r.Time)
    PendingCrafts[src] = {
        item = item, count = num(r.Amount), readyAt = now + time, expiresAt = now + time + 120,
        armoryGang = (not bench.public) and gangOf(x) or nil,
    }
    TriggerClientEvent('Unique_Crafting:craftStart', src, item, time)
end)

-- ───────── craft: finish ─────────
RegisterServerEvent('Unique_Crafting:itemCrafted')
AddEventHandler('Unique_Crafting:itemCrafted', function(item)
    local src = source
    local p = PendingCrafts[src]
    if not p or p.item ~= item then return end
    local now = os.time()
    if now > p.expiresAt then PendingCrafts[src] = nil return end
    if now < p.readyAt - 1 then return end
    PendingCrafts[src] = nil

    local x = ESX.GetPlayerFromId(src)
    if not x then return end
    local r = CraftConfig.Recipes[item]
    if not r then return end
    local gang = gangOf(x)

    if math.random(1, 100) > num(r.SuccessRate) then
        GangLog(gang, 'Crafting', ('Failed to craft %s'):format(item), src)
        return notify(src, 'Craft shekast khord')
    end

    if r.isGun then
        x.addWeapon(item, p.count)
    else
        if CraftConfig.UseLimitSystem then
            local xItem = x.getInventoryItem(item)
            if xItem and xItem.limit ~= -1 and xItem.count + p.count > xItem.limit then
                return notify(src, 'Limit')
            end
        end
        x.addInventoryItem(item, p.count)
    end
    notify(src, 'Item Craft Shod')
    GangLog(gang, 'Crafting', ('Crafted %s x%d'):format(item, p.count), src)

    if gang and num(CraftConfig.ExperiancePerCraft) > 0 and GrantGangXP then
        GrantGangXP(gang, num(CraftConfig.ExperiancePerCraft), 'Crafting')
    end
end)

AddEventHandler('playerDropped', function()
    PendingCrafts[source] = nil
end)
