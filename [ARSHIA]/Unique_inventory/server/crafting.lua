-- ============================================================================
-- Unique_inventory | server/crafting.lua
-- Weapon crafting at a workbench. The player picks a weapon and a lifetime
-- (permanent / 30 days / 7 days); a shorter life costs fewer materials.
-- Flow (all checked here, the client only shows the menu):
--   craftBegin  -> materials + carry capacity are checked, a timer starts
--   craftFinish -> the time must really have passed; materials are taken and
--                  the weapon is created with its lifetime (UNIQUE.createWeapon)
-- ============================================================================

local CR, WL = Crafting, WeaponLife
if not CR.enabled then return end   -- the server uses Unique_Crafting; see shared/crafting.lua
local UNIQUE = UNIQUE

local pending = {}      -- [src] = { weapon, tier, at, ms }

local function register()
    local ok = pcall(function()
        for name, m in pairs(CR.materials) do
            exports['essentialmode']:RegisterItem(name, m.label, m.weight)
        end
    end)
    return ok
end

CreateThread(function()
    for _ = 1, 30 do
        if GetResourceState('essentialmode') == 'started' and register() then return end
        Wait(1000)
    end
    print('^1[Unique_inventory]^0 could not register the crafting materials (essentialmode not ready)')
end)
AddEventHandler('onResourceStart', function(res)
    if res == 'essentialmode' then SetTimeout(3000, register) end
end)

local function plainCount(xp, name)
    local c = 0
    for _, row in ipairs(xp.inventory or {}) do
        if row.name == name and not row.info then c = c + (row.count or 0) end
    end
    return c
end

local function missingFor(xp, cost)
    for mat, need in pairs(cost) do
        if plainCount(xp, mat) < need then return mat, need end
    end
    return nil
end

local function nearBench(src)
    if CR.anywhere then return true end
    local ped = GetPlayerPed(src)
    if ped == 0 then return false end
    local me = GetEntityCoords(ped)
    for _, b in ipairs(CR.benches) do
        if #(vector3(b.coords.x, b.coords.y, b.coords.z) - me) <= (CR.benchRadius + 2.0) then return true end
    end
    return false
end

RegisterNetEvent('Unique_inventory:craftBegin', function(weapon, tierId)
    local src = source
    if UNIQUE.limited(src, 'craftbegin', 800) then return end
    local xp = UNIQUE.player(src)
    local recipe = type(weapon) == 'string' and CR.weapons[weapon]
    local tier = type(tierId) == 'string' and WL.TierById(tierId)
    if not xp or not recipe or not tier then return end
    if pending[src] then return UNIQUE.notify(src, 'در حال ساخت هستید') end
    if not nearBench(src) then return UNIQUE.notify(src, 'کنار میز ساخت نیستید') end

    local cost = CR.CostFor(weapon, tier)
    local mat, need = missingFor(xp, cost)
    if mat then
        return UNIQUE.notify(src, ('مواد کافی نیست: %s (%d)'):format(CR.materials[mat] and CR.materials[mat].label or mat, need))
    end
    if not xp.canCarryItem(weapon, 1) then return UNIQUE.notify(src, 'ظرفیت حمل شما کافی نیست') end

    pending[src] = { weapon = weapon, tier = tier, at = GetGameTimer(), ms = recipe.time * 1000 }
    TriggerClientEvent('Unique_inventory:craftStart', src, recipe.time * 1000, weapon, tier.label)
end)

RegisterNetEvent('Unique_inventory:craftCancel', function()
    pending[source] = nil
end)

RegisterNetEvent('Unique_inventory:craftFinish', function()
    local src = source
    local job = pending[src]
    pending[src] = nil
    local xp = UNIQUE.player(src)
    if not job or not xp then return end
    if GetGameTimer() - job.at < job.ms * 0.9 then return UNIQUE.notify(src, 'ساخت هنوز تمام نشده') end
    if not nearBench(src) then return UNIQUE.notify(src, 'کنار میز ساخت نیستید') end

    local cost = CR.CostFor(job.weapon, job.tier)
    if missingFor(xp, cost) then return UNIQUE.notify(src, 'مواد کافی نیست') end
    if not xp.canCarryItem(job.weapon, 1) then return UNIQUE.notify(src, 'ظرفیت حمل شما کافی نیست') end

    for mat, need in pairs(cost) do xp.removeInventoryItem(mat, need) end
    local serial = UNIQUE.createWeapon(src, job.weapon, 0, job.tier.days)
    TriggerClientEvent('esx:updateInventory', src)
    UNIQUE.notify(src, ('ساخته شد: %s (%s)'):format(job.weapon:gsub('^WEAPON_', ''), job.tier.label))
    print(('^3[Unique_inventory]^0 %s crafted %s (%s) serial %s'):format(tostring(xp.identifier), job.weapon, job.tier.id, tostring(serial)))
end)

AddEventHandler('playerDropped', function() pending[source] = nil end)
