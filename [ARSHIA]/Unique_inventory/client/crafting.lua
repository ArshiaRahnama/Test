-- ============================================================================
-- Unique_inventory | client/crafting.lua
-- Workbench menu (ox_lib context menu): group -> weapon -> lifetime (permanent / 30 / 7 days).
-- Open it with /craft (while Crafting.anywhere = true), at a bench from shared/crafting.lua,
-- or from your own code:  exports['Unique_inventory']:OpenCrafting()
-- ============================================================================

local CR, WL = Crafting, WeaponLife
if not CR.enabled then return end   -- the server uses Unique_Crafting; see shared/crafting.lua

local function notify(msg)
    if ESX and ESX.ShowNotification then ESX.ShowNotification(msg) end
end

local function weaponLabel(name)
    local ok, label = pcall(function() return ESX.GetWeaponLabel(name) end)
    return (ok and label and label ~= '') and label or (name:gsub('^WEAPON_', ''))
end

local function have(mat)
    local total = 0
    for _, row in ipairs(ESX.GetPlayerData().inventory or {}) do
        if row.name == mat and not row.info then total = total + (row.count or 0) end
    end
    return total
end

local function costText(cost)
    local parts = {}
    for _, mat in ipairs(CR.materialOrder) do
        if cost[mat] then
            parts[#parts + 1] = ('%s %d/%d'):format(CR.materials[mat].label, have(mat), cost[mat])
        end
    end
    return table.concat(parts, '  •  ')
end

local function affordable(cost)
    for mat, need in pairs(cost) do
        if have(mat) < need then return false end
    end
    return true
end

local function nearBench()
    if CR.anywhere then return true end
    local me = GetEntityCoords(PlayerPedId())
    for _, b in ipairs(CR.benches) do
        if #(vector3(b.coords.x, b.coords.y, b.coords.z) - me) <= CR.benchRadius + 1.0 then return true end
    end
    return false
end

local function openWeapon(weapon, backId)
    local options = {}
    for _, tier in ipairs(WL.tiers) do
        local cost = CR.CostFor(weapon, tier)
        options[#options + 1] = {
            title = tier.label,
            description = costText(cost),
            icon = tier.days and 'clock' or 'infinity',
            disabled = not affordable(cost),
            onSelect = function() TriggerServerEvent('Unique_inventory:craftBegin', weapon, tier.id) end,
        }
    end
    lib.registerContext({ id = 'unique_craft_weapon', title = weaponLabel(weapon), menu = backId, options = options })
    lib.showContext('unique_craft_weapon')
end

local function openGroup(group)
    local list = {}
    for name, r in pairs(CR.weapons) do
        if WL.GroupOf(name) == group.id then list[#list + 1] = { name = name, forge = r.forge or 0 } end
    end
    table.sort(list, function(a, b)
        if a.forge ~= b.forge then return a.forge < b.forge end
        return a.name < b.name
    end)
    local options = {}
    for _, w in ipairs(list) do
        local permanent = CR.CostFor(w.name, WL.tiers[1])
        options[#options + 1] = {
            title = weaponLabel(w.name),
            description = costText(permanent) .. '  (دائمی)',
            icon = 'gun',
            onSelect = function() openWeapon(w.name, 'unique_craft_group') end,
        }
    end
    lib.registerContext({ id = 'unique_craft_group', title = group.label, menu = 'unique_craft', options = options })
    lib.showContext('unique_craft_group')
end

function OpenCrafting()
    if not nearBench() then return notify('کنار میز ساخت نیستید') end
    local counts = {}
    for _, g in ipairs(CR.groups) do
        local n = 0
        for name in pairs(CR.weapons) do if WL.GroupOf(name) == g.id then n = n + 1 end end
        counts[g.id] = n
    end
    local options = {}
    for _, g in ipairs(CR.groups) do
        if counts[g.id] > 0 then
            options[#options + 1] = {
                title = g.label,
                description = ('%d اسلحه'):format(counts[g.id]),
                icon = 'hammer',
                onSelect = function() openGroup(g) end,
            }
        end
    end
    lib.registerContext({ id = 'unique_craft', title = 'میز ساخت اسلحه', options = options })
    lib.showContext('unique_craft')
end
exports('OpenCrafting', OpenCrafting)

if CR.command and CR.command ~= '' then
    RegisterCommand(CR.command, function() OpenCrafting() end, false)
end

-- benches: an ox_target sphere zone for each one
CreateThread(function()
    if #CR.benches == 0 or GetResourceState('ox_target') ~= 'started' then return end
    for i, b in ipairs(CR.benches) do
        pcall(function()
            exports.ox_target:addSphereZone({
                coords = vector3(b.coords.x, b.coords.y, b.coords.z), radius = CR.benchRadius, debug = false,
                options = { { name = 'unique_craft_' .. i, icon = 'fa-solid fa-hammer', label = b.label or 'میز ساخت', onSelect = OpenCrafting } },
            })
        end)
    end
end)

RegisterNetEvent('Unique_inventory:craftStart', function(ms, weapon, tierLabel)
    local done = lib.progressCircle({
        duration = ms, position = 'bottom', canCancel = true,
        label = ('ساخت %s (%s)'):format(weaponLabel(weapon), tierLabel),
        disable = { move = true, car = true, combat = true },
        anim = { dict = 'mini@repair', clip = 'fixing_a_ped' },
    })
    if done then TriggerServerEvent('Unique_inventory:craftFinish') else TriggerServerEvent('Unique_inventory:craftCancel') end
end)
