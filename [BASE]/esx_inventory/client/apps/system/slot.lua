-- ================================================================= --
-- FIX (requested): the game's own weapon wheel (hold Tab) was showing
-- every weapon the player owns, not just the ones actually placed in
-- one of the 5 hotbar slots below - because essentialmode's
-- esx:addWeapon / esx:restoreLoadout always natively GiveWeaponToPed
-- for the WHOLE loadout regardless of hotbar binding (that part is
-- still correct and necessary - a weapon has to actually be given to
-- the ped for it to fire/reload once equipped). This hooks those same
-- two events and immediately strips back out anything not currently
-- hotbar-bound, and gives/removes a weapon the instant it's dragged
-- into or out of a hotbar slot - so from here on the wheel only ever
-- lists hotbar weapons, same as keybind_1-5 already only working for
-- hotbar-bound ones.
-- ================================================================= --

-- NOTE on load order: this file lives in client/apps/system/, which the
-- fxmanifest loads BEFORE client/main.lua - and `Inv.FastWeapons` is only
-- assigned in main.lua. So at the moment this file is parsed, the global
-- `Inv` may not exist yet. Every read below therefore has to tolerate
-- `Inv` itself being nil, not just `Inv.FastWeapons` (the original
-- `Inv.FastWeapons or {}` would still throw "attempt to index a nil
-- value" if `Inv` were nil). In practice the handlers only ever run
-- after main.lua has loaded, but an early server-sent esx:addWeapon
-- during startup would have hit exactly that.
local function hotbar()
    return (Inv and Inv.FastWeapons) or {}
end

local function isWeaponInHotbar(weaponName)
    for _, name in pairs(hotbar()) do
        if name == weaponName then return true end
    end
    return false
end

-- Resolve the current loadout from whichever source is actually
-- populated. `ESX` in this resource is the object handed over by
-- essentialmode's esx:getSharedObject handler; `PlayerData` is the
-- global that client/custom/framework/esx.lua maintains from
-- esx:playerLoaded. Either can be the stale/empty one depending on
-- whether the player just connected or the resource was just restarted,
-- so try both rather than trusting one.
local function getLoadout()
    if ESX and ESX.PlayerData and ESX.PlayerData.loadout then
        return ESX.PlayerData.loadout
    end
    if PlayerData and PlayerData.loadout then
        return PlayerData.loadout
    end
    return {}
end

local function getLoadoutAmmo(weaponName)
    local loadout = getLoadout()
    for i = 1, #loadout do
        if loadout[i].name == weaponName then
            return tonumber(loadout[i].ammo) or 0
        end
    end
    -- Not found in either copy of the loadout. Returning 0 here would
    -- hand the player a weapon with no ammo (it appears in the wheel but
    -- can't fire), which is worse than the alternative: the server is the
    -- authority on ammo anyway and re-syncs it, so fall back to the same
    -- default the give/pickup paths already use.
    return 255
end

function StripNonHotbarWeapons()
    local ped = PlayerPedId()
    local loadout = getLoadout()
    for i = 1, #loadout do
        local weaponName = loadout[i].name
        local weaponHash = GetHashKey(weaponName)
        if HasPedGotWeapon(ped, weaponHash, false) and not isWeaponInHotbar(weaponName) then
            RemoveWeaponFromPed(ped, weaponHash)
        end
    end
end

-- essentialmode dispatches this on spawn/loadout-load - AddEventHandler
-- runs handlers in resource-start order, and essentialmode (the base
-- framework) starts before this resource, so its own GiveWeaponToPed
-- loop has already run by the time this fires; the Wait(0) is just
-- cheap insurance against that ordering assumption ever changing.
--
-- 'esx:restoreLoadout' is fired LOCALLY by essentialmode's own client
-- (client/main.lua: `TriggerEvent('esx:restoreLoadout')`), so a plain
-- AddEventHandler is correct and sufficient for this one.
AddEventHandler('esx:restoreLoadout', function()
    Citizen.Wait(0)
    StripNonHotbarWeapons()
end)

-------------------------------------------------------------------
-- BUG FIX (reported: "weapons that aren't in one of the 5 bottom
-- slots still show up in the TAB wheel").
--
-- Root cause: 'esx:addWeapon' and 'esx:removeWeapon' are NET events -
-- essentialmode fires them from the SERVER
-- (server/classes/player.lua: TriggerClientEvent("esx:addWeapon", ...)
-- and TriggerClientEvent("esx:removeWeapon", ...)). In FiveM,
-- RegisterNetEvent is PER RESOURCE: essentialmode registering them in
-- its own resource only lets ITS handlers receive them. This file used
-- AddEventHandler with no RegisterNetEvent, so these two handlers were
-- never invoked for a server-sent event - they only ever would have
-- fired for a local TriggerEvent, which nothing does.
--
-- Effect before the fix: the strip-on-spawn path (restoreLoadout, a
-- LOCAL event, above) worked fine, which is why this looked correct
-- right after connecting - but any weapon obtained DURING the session
-- (bought, given, looted, admin-granted) was never stripped, so it
-- stayed in the wheel even though it was never hotbar-bound. Matches
-- the reported symptom exactly.
--
-- The 'esx:removeWeapon' half had the same dead-handler problem, which
-- separately meant a slot could keep pointing at a weapon the player no
-- longer owned.
-------------------------------------------------------------------
RegisterNetEvent('esx:addWeapon')
AddEventHandler('esx:addWeapon', function(weaponName)
    Citizen.Wait(0)
    if type(weaponName) == 'string' and not isWeaponInHotbar(weaponName) then
        RemoveWeaponFromPed(PlayerPedId(), GetHashKey(weaponName))
    end
end)

-- Weapon dropped/sold/lost entirely (essentialmode always calls
-- RemoveWeaponFromPed for this event, regardless of the ammo param) -
-- clear it out of any hotbar slot too, so a slot never keeps pointing
-- at a weapon the player doesn't own anymore.
RegisterNetEvent('esx:removeWeapon')
AddEventHandler('esx:removeWeapon', function(weaponName)
    if type(weaponName) ~= 'string' then return end
    if not (Inv and Inv.FastWeapons) then return end
    local changed = false
    for slot, name in pairs(Inv.FastWeapons) do
        if name == weaponName then
            Inv.FastWeapons[slot] = nil
            changed = true
        end
    end
    if changed then
        SetFieldValueFromNameEncode('esx_inventory', {name = Inv.FastWeapons})
    end
end)

RegisterNUICallback("PutIntoFast", function(data, cb)
    if not Config.BL_SlotInv[data.item.name] then
	    if data.item.slot ~= nil then
		    Inv.FastWeapons[data.item.slot] = nil
	    end
        -- FIX (prevents the same item ending up bound to multiple
        -- hotbar slots again - see the one-time cleanup in
        -- client/main.lua for the historical case): clear any OTHER
        -- slot already holding this exact item name before binding it
        -- to the new one, so an item only ever occupies one slot.
        for existingSlot, existingName in pairs(Inv.FastWeapons) do
            if existingName == data.item.name and existingSlot ~= data.slot then
                Inv.FastWeapons[existingSlot] = nil
            end
        end
	    Inv.FastWeapons[data.slot] = data.item.name
        SetFieldValueFromNameEncode('esx_inventory', {name = Inv.FastWeapons})

        -- newly hotbar-bound weapon needs to actually be given to the ped
        -- (see the fix note at the top of this file) so it's both usable
        -- via keybind_1-5 and now shows up in the game's own weapon wheel.
        if string.sub(data.item.name, 1, 7) == 'WEAPON_' then
            GiveWeaponToPed(PlayerPedId(), GetHashKey(data.item.name), getLoadoutAmmo(data.item.name), false, false)
        end

	    loadPlayerInventory('slot', nil, true, true)
	    cb("ok")
    end
end)

RegisterNUICallback("TakeFromFast", function(data, cb)
    local removedName = Inv.FastWeapons[data.item.slot]
	Inv.FastWeapons[data.item.slot] = nil
    SetFieldValueFromNameEncode('esx_inventory', {name = Inv.FastWeapons})

    -- unbound from every slot (not just this one, in case it somehow
    -- ended up duplicated) and not in some other slot -> strip it back
    -- out of the wheel, same rule as everywhere else in this fix.
    if removedName and string.sub(removedName, 1, 7) == 'WEAPON_' and not isWeaponInHotbar(removedName) then
        RemoveWeaponFromPed(PlayerPedId(), GetHashKey(removedName))
    end

    loadPlayerInventory(currentMenu, nil, true, true)
	cb("ok")
end)

for k, v in pairs(Config.KeyBinds) do 
    RegisterKeyMapping(v.Command, v.Description, 'keyboard', v.Bind)
end



function useitem(num)
    if IsPedRagdoll(PlayerPedId())  then
        NotificationInInventory(Locales[Config.Language]['no_possible'], 'error')
        return
    end

    if not Config.BL_SlotInv[Inv.FastWeapons[num]] and not Inv.isInInventory then
        if Inv.FastWeapons[num] ~= nil then
            local prefix = string.sub(Inv.FastWeapons[num], 1, 7) -- extrait les 7 premiers caractères
            if prefix ~= 'WEAPON_' then
                TriggerServerEvent(Config.Trigger["esx:useItem"], Inv.FastWeapons[num])
            else
                local ped = PlayerPedId()

                if not weaponLock then
                    weaponLock = true
                    if  weaponEquiped ~= Inv.FastWeapons[num] then
                        weaponEquiped = Inv.FastWeapons[num]
                        SetCurrentPedWeapon(ped, Inv.FastWeapons[num], true)
                        -- SetPedCurrentWeaponVisible(ped, 0, true, 1, 0) -- Cache l'arme

                        Wait(150)
                        weaponLock = false
                    else 
                        weaponEquiped = nil
                        SetCurrentPedWeapon(ped, 'WEAPON_UNARMED', true)
                        Wait(150)
                        weaponLock = false
                    end 
                end
            end
        end
    end
end
