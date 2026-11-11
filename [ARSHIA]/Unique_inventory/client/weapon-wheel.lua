-- ============================================================================
-- Unique_inventory | client/weapon-wheel.lua
-- Replacement for the original server's 'core:client:giveWeapon' /
-- 'core:client:removeWeapon' handlers (they lived in its essentialmode).
--
-- Rule: a weapon sits in the player's inventory; only weapons placed in
-- a weapon slot / maket slot are given to the ped, so only those show up in the
-- GTA weapon wheel. Slot order = give order (slot 1 first, then 2, 3, then the
-- maket slots).
--
-- Only weapons the inventory manages (names present in the player's loadout) are
-- ever touched. Weapons given by other scripts (paintball, parachute, ...) are
-- left alone. Set `set unique_inv_wheel_sync 0` in server.cfg to turn this off.
--
-- GTA decides the wheel's category order itself (pistols at the top, ...); what
-- this controls is WHICH weapons are in the wheel and the order inside a category.
-- ============================================================================

local ammoCache = {}      -- [WEAPON_NAME] = ammo left on the ped when it was taken off
local lastKey = nil       -- last applied slot layout, so unrelated refreshes do nothing

local function enabled() return GetConvarInt('unique_inv_wheel_sync', GetConvarInt('sun_inv_wheel_sync', 1)) == 1 end

local function managedWeapons()
    local set = {}
    for _, w in ipairs(ESX.GetPlayerData().loadout or {}) do
        if w.name then set[tostring(w.name):upper()] = w end
    end
    return set
end

-- ordered list of weapon names that sit in slots: normal 1..3 first, then maket
local function slottedNames()
    local slots = exports[GetCurrentResourceName()]:getWeaponSlot() or {}
    local keys = {}
    for k in pairs(slots) do keys[#keys + 1] = tonumber(k) end
    table.sort(keys)
    local list, want = {}, {}
    for _, k in ipairs(keys) do
        local v = slots[k] or slots[tostring(k)]
        if type(v) == 'table' and v.name then
            local n = tostring(v.name):upper()
            if not want[n] then
                want[n] = true
                list[#list + 1] = n
            end
        end
    end
    return list, want
end

local function takeOff(ped, name)
    local hash = GetHashKey(name)
    if HasPedGotWeapon(ped, hash, false) then
        ammoCache[name] = GetAmmoInPedWeapon(ped, hash)
        RemoveWeaponFromPed(ped, hash)
    end
end

local function giveTo(ped, name, w)
    local hash = GetHashKey(name)
    local ammo = ammoCache[name]
    if ammo == nil then ammo = tonumber(w.ammo) or 0 end
    if ammo < 0 then ammo = 0 end
    GiveWeaponToPed(ped, hash, ammo, false, false)
    SetPedWeaponTintIndex(ped, hash, tonumber(w.tintIndex) or 0)
    for _, comp in ipairs(w.components or {}) do
        local c = ESX.GetWeaponComponent(name, comp)
        if c and c.hash then GiveWeaponComponentToPed(ped, hash, c.hash) end
    end
end

function UniqueSyncWeaponWheel(force)
    if not enabled() or not ESX then return end
    local managed = managedWeapons()
    local list, want = slottedNames()

    local parts = {}
    for _, n in ipairs(list) do parts[#parts + 1] = n end
    local key = table.concat(parts, ',')
    if not force and key == lastKey then return end
    lastKey = key

    local ped = PlayerPedId()
    local _, selected = GetCurrentPedWeapon(ped, true)

    -- 1) weapons of the inventory that are not in a slot leave the wheel
    for name in pairs(managed) do
        if not want[name] then takeOff(ped, name) end
    end
    -- 2) slotted weapons are (re)given in slot order, so slot 1 comes first
    for _, name in ipairs(list) do
        local w = managed[name]
        if w then
            takeOff(ped, name)
            giveTo(ped, name, w)
        end
    end
    -- keep whatever the player was holding, if it is still there
    if selected and selected ~= 0 and HasPedGotWeapon(ped, selected, false) then
        SetCurrentPedWeapon(ped, selected, true)
    end
end

-- the inventory raises these when a weapon is put into / taken out of a slot
AddEventHandler('core:client:giveWeapon', function() UniqueSyncWeaponWheel() end)
AddEventHandler('core:client:removeWeapon', function() UniqueSyncWeaponWheel() end)

-- the server just added a weapon: essentialmode hands it to the ped at once,
-- but it only belongs in the wheel once it sits in a slot
RegisterNetEvent('esx:addWeapon', function()
    SetTimeout(600, function() UniqueSyncWeaponWheel(true) end)
end)
RegisterNetEvent('esx:removeWeapon', function()
    SetTimeout(600, function() UniqueSyncWeaponWheel(true) end)
end)

-- after login / respawn: wait for the slots, then apply the layout once
local function initialSync()
    CreateThread(function()
        Wait(4000)
        lastKey = nil
        UniqueSyncWeaponWheel(true)
    end)
end
RegisterNetEvent('esx:playerLoaded', initialSync)
AddEventHandler('playerSpawned', initialSync)
CreateThread(function()
    Wait(6000)
    lastKey = nil
    UniqueSyncWeaponWheel(true)
end)

RegisterCommand('uniquewheel', function()
    lastKey = nil
    UniqueSyncWeaponWheel(true)
    local list = slottedNames()
    print(('[%s] weapon wheel synced: %s'):format(GetCurrentResourceName(), #list > 0 and table.concat(list, ', ') or '(no weapon in any slot)'))
end, false)
