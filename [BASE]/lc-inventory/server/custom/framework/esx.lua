--[[ 
    Hi dear customer or developer, here you can fully configure your server's 
    framework or you could even duplicate this file to create your own framework.

    If you do not have much experience, we recommend you download the base version 
    of the framework that you use in its latest version and it will work perfectly.
]]

if Config.Framework ~= "esx" then
    return
end

if Config.esxVersion == 'new' then
	ESX = exports['es_extended']:getSharedObject()
elseif Config.esxVersion == 'old' then
    ESX = nil
    TriggerEvent(Config.Trigger["getSharedObject"], function(obj) ESX = obj end)
end


userColumns = 'users'

licenseTable = 'user_licenses'
idLicenseTable = 'owner'
typeLicenseTable = 'type'

vehiclesTable = 'owned_vehicles' 
idVehTable = 'owner' 
plateVehTable = 'plate' 

phoneTable = 'phone_phones'
idPhoneTable = 'id'
numberTable = 'phone_number' 

-------------------------------------------------------------------
-- FEATURE (new bug found: "essentialmode: TriggerServerCallback =>
-- [lgddddd:getPlayerInventory] does not exist" appearing AFTER
-- console already confirmed that exact callback registered
-- successfully at startup). Same root cause as the
-- RegisteredArmoryStashes bug fixed earlier in Unique_ALLGangs, just
-- one layer down: every RegisterServerCallback call here only runs
-- ONCE, at lc-inventory's own startup. If essentialmode itself ever
-- restarts on its own afterwards (crash, manual restart, or a VPS
-- freeze/lag spike forcing a restart - exactly what's in the reported
-- console log right before this error appeared), its real
-- ESX.ServerCallbacks table is wiped clean along with it. lc-inventory
-- has no reason to know that happened, so it never re-registers -
-- every custom callback (not just the stash one) breaks permanently
-- until lc-inventory itself also restarts.
-- Keeps a record of every callback ever registered through here, and
-- replays all of them the moment essentialmode reports as started
-- again - covering the very first start (the wait-loop below) AND any
-- later independent restart.
-------------------------------------------------------------------
local AllRegisteredCallbacks = {}

AddEventHandler('onResourceStart', function(resourceName)
    if resourceName ~= 'essentialmode' then return end
    -- fires on essentialmode's OWN startup too (first boot, in which
    -- case AllRegisteredCallbacks is still empty and this is a no-op),
    -- as well as any later restart of it while lc-inventory keeps running
    for name, cb in pairs(AllRegisteredCallbacks) do
        local ok, err = pcall(function() exports['essentialmode']:RegisterServerCallback(name, cb) end)
        if ok then
            print('[lc-inventory] essentialmode restarted - re-registered ' .. tostring(name))
        else
            print('[lc-inventory] essentialmode restarted - FAILED to re-register ' .. tostring(name) .. ' -> ' .. tostring(err))
        end
    end
end)

-------------------------------------------------------------------
-- FIX 3 (onResourceStart alone wasn't enough - the reported console
-- shows this breaking repeatedly alongside "Major VPS freeze/lag
-- detected" firing every few seconds, meaning this VPS is under such
-- severe, CONSTANT strain that essentialmode's callback table is
-- getting disrupted without ever producing a clean, catchable
-- resource-restart event for onResourceStart to react to - or it's
-- being missed because so many things are happening in the same
-- lag spike). Rather than depend on correctly detecting *why* or
-- *when* it breaks, this just keeps quietly re-pushing every known
-- callback on a short timer regardless - cheap (a handful of export
-- calls every few seconds), and it makes the exact cause of any
-- future disruption a non-issue: whatever knocks a registration out,
-- it's back within one interval, no console-log-reading required.
-------------------------------------------------------------------
CreateThread(function()
    while true do
        Wait(3000) -- shortened from 15s: the reported failure reappears within seconds of a fresh successful registration, so 15s left too wide a window where real inventory opens could still hit it
        if GetResourceState('essentialmode') == 'started' then
            for name, cb in pairs(AllRegisteredCallbacks) do
                pcall(function() exports['essentialmode']:RegisterServerCallback(name, cb) end)
            end
        end
    end
end)

function RegisterServerCallback(name, cb)
    -------------------------------------------------------------
    -- FIX (real root cause of the item-access-never-enforced bug,
    -- confirmed via essentialmode/server/common.lua's own diagnostic
    -- work): `ESX` right above this is a DISCONNECTED SNAPSHOT, not
    -- essentialmode's real internal object. TriggerEvent (old ESX's
    -- getSharedObject pattern) serializes its arguments across the
    -- resource boundary - it does NOT share a live table reference -
    -- so `ESX.RegisterServerCallback(name, cb)` used to write into
    -- THIS resource's own disconnected copy of ESX.ServerCallbacks,
    -- which essentialmode's real relay handler
    -- (RegisterServerEvent('esx:triggerServerCallback') in
    -- essentialmode/server/common.lua, which always reads
    -- essentialmode's OWN internal ESX.ServerCallbacks) never sees.
    -- Every custom app callback registered this way - stash.lua's
    -- 'lc-inventory:getStash' included - would silently never be
    -- found, printing "essentialmode: TriggerServerCallback =>
    -- [name] does not exist" server-side every time a client called
    -- it.
    -- essentialmode now exports a real RegisterServerCallback
    -- (server/common.lua + fxmanifest.lua's server_exports) that runs
    -- INSIDE its own resource, so it registers into the actual live
    -- ESX.ServerCallbacks table instead. FiveM's export system
    -- correctly marshals the function reference itself across the
    -- resource boundary (unlike a plain data table), so this works.
    --
    -- FIX 2 (this was still broken after the above - real reason:
    -- start-order race): every 'lc-inventory:getStash'-style
    -- registration happens ONCE, at lc-inventory's own top-level
    -- script load. If lc-inventory's resource starts even slightly
    -- before essentialmode finishes starting, GetResourceState would
    -- read something other than 'started' at that exact instant, this
    -- would silently fall through to the broken disconnected-copy
    -- path below - and since this only ever runs once, it stays
    -- broken for the resource's entire uptime regardless of anything
    -- happening later. Now actually waits (yields, does not block the
    -- server - top-level server_script code runs in its own
    -- coroutine) until essentialmode is confirmed started, with a
    -- generous timeout and a loud console warning if that timeout is
    -- ever actually hit.
    -------------------------------------------------------------
    AllRegisteredCallbacks[name] = cb -- see onResourceStart handler above

    local waited = 0
    while GetResourceState('essentialmode') ~= 'started' and waited < 30000 do
        Wait(100)
        waited = waited + 100
    end
    if GetResourceState('essentialmode') == 'started' then
        local ok, err = pcall(function() exports['essentialmode']:RegisterServerCallback(name, cb) end)
        if ok then
            print('[lc-inventory] RegisterServerCallback(' .. tostring(name) .. '): registered via essentialmode export - OK')
        else
            print('[lc-inventory] RegisterServerCallback(' .. tostring(name) .. '): exports call to essentialmode FAILED -> ' .. tostring(err) .. ' - falling back to the disconnected ESX copy (will NOT actually work, see comment above this function)')
            ESX.RegisterServerCallback(name, cb)
        end
    else
        print('[lc-inventory] RegisterServerCallback(' .. tostring(name) .. '): essentialmode never reached "started" after 30s (currently: ' .. tostring(GetResourceState('essentialmode')) .. ') - falling back to the disconnected ESX copy (will NOT actually work)')
        ESX.RegisterServerCallback(name, cb)
    end
end

function GetPlayerInventory(player)
    return player.inventory
end

function GetPlayerWeapon(player)
    return player.loadout
end

function GetPlayerMoney(player)
    return {
        { name = 'cash', money = player.money },
        { name = 'bank', money = player.bank },
        { name = 'black_money', money = player.black_money },
    }
end

function GetPlayerWeight(player)
    return player.getUsedWeight()
end

function GetPlayerMaxWeight(player)
    return player.maxWeight
end

function GetPlayerFromId(source)
    return ESX.GetPlayerFromId(source)
end

function GetJob(player)
    if player == nil then return "unemployed" end
	if ESX.GetPlayerFromId(player) == nil then 
		return "unemployed"
	else
		local tempJob = ESX.GetPlayerFromId(player).job
		tempJob.onduty = true
		return tempJob
	end
end

function GetPlayerLicense(player)
	return player.identifier
end

function math.round(num, numDecimalPlaces)
    local mult = 10 ^ (numDecimalPlaces or 0)
    return math.floor(num * mult + 0.5) / mult
end

function GetPlayers()
	return ESX.GetPlayers()
end

function GetItemLabel(name)
	return ESX.GetItemLabel(name)
end

function GetInfoIdCard(player)
	local identifier = GetPlayerLicense(player)
	result = MySQL.Sync.fetchAll('SELECT firstname, lastname, dateofbirth, sex, height  FROM `'..userColumns..'` WHERE identifier = @identifier', {
		['@identifier'] = player
	})
	if result[1] then
		return result
	end

end

-- weight

function getWeight(player, name, count)
	return player.canCarryItem(name, count)
end

-- item

function AddItem(xPlayer, item, count)
	xPlayer.addInventoryItem(item, count)
end

function RemoveItem(player, item, count)
	player.removeInventoryItem(item, count)
end

function GetItem(player, item)
	return player.getInventoryItem(item)
end

function GetItemAmount(item)
	return item.count
end

function GetWeightPlayer(player, item, count)
	return player.canCarryItem(item, count)
end

-- weapon

function addWeapon(player, item, count, serial)
	player.addWeapon(item, count, serial)
end

function removeWeapon(player, item, serial)
	player.removeWeapon(item, nil, serial)
end

function getWeapon(player, weapon, serial)
	return player.hasWeapon(weapon, serial)
end

function infoWeapon(player, weapon, serial)
	return player.getWeapon(weapon, serial)
end

function addWeaponComponent(player, itemName, component)
	return player.addWeaponComponent(itemName, component)
end


-- money 

function addMoney(player, account, count)
	player.addAccountMoney(account, count)
end

function removeMoney(player, account, count)
	player.removeAccountMoney(account, count)
end

function getAccount(player, account)
	return player.getAccount(account).money
end


function showNotification(player, msg, type)
	TriggerClientEvent('inv:Notification', player.source, msg, type)
end