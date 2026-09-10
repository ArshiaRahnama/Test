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
-- FIX (definitively confirmed via two-sided diagnostic logging: the
-- callback function, once it crosses the `exports` boundary from this
-- resource into essentialmode, arrives there as type "table", not
-- "function" - a genuine FXServer limitation, not a bug in either
-- resource's own logic). Passing the real callback through exports at
-- all was the wrong approach from the start. This keeps the real
-- callback function 100% local to lc-inventory (it never crosses any
-- boundary) and instead relays only plain, serializable data
-- (name/requestId/source/args) to essentialmode and back - the exact
-- same request/reply-by-ID shape ESX's own client<->server
-- TriggerServerCallback already uses, just one hop further out. See
-- essentialmode/server/common.lua's matching half of this.
--
-- Also still resilient to essentialmode restarting independently
-- (VPS freeze/lag repeatedly forcing that, per the reported console
-- log) - re-establishes every relay registration on essentialmode's
-- onResourceStart AND on a short recurring timer, since neither alone
-- proved fast/reliable enough on its own.
-------------------------------------------------------------------
local LocalCallbacks = {} -- [name] = the REAL callback function - never leaves this resource

AddEventHandler('essentialmode:relayServerCallback:lc-inventory', function(name, requestId, source, ...)
    local cb = LocalCallbacks[name]
    if not cb then return end
    cb(source, function(...)
        TriggerEvent('essentialmode:relayServerCallbackReply', requestId, ...)
    end, ...)
end)

local function pushRegistration(name)
    local ok, result = pcall(function() return exports['essentialmode']:RegisterServerCallback(name) end)
    return ok and result == true
end

AddEventHandler('onResourceStart', function(resourceName)
    if resourceName ~= 'essentialmode' then return end
    -- fires on essentialmode's OWN startup too (first boot, in which
    -- case LocalCallbacks is still empty and this is a no-op), as well
    -- as any later restart of it while lc-inventory keeps running
    for name in pairs(LocalCallbacks) do
        print('[lc-inventory] essentialmode (re)started - re-registered ' .. tostring(name) .. ': ' .. tostring(pushRegistration(name)))
    end
end)

-- Belt-and-suspenders: onResourceStart alone didn't prove fast/reliable
-- enough against a VPS this unstable, so also just keep quietly
-- re-pushing every known registration on a short timer regardless of
-- whether a clean restart event was ever actually observed.
CreateThread(function()
    while true do
        Wait(3000)
        if GetResourceState('essentialmode') == 'started' then
            for name in pairs(LocalCallbacks) do
                pushRegistration(name)
            end
        end
    end
end)

function RegisterServerCallback(name, cb)
    LocalCallbacks[name] = cb

    local waited = 0
    while GetResourceState('essentialmode') ~= 'started' and waited < 30000 do
        Wait(100)
        waited = waited + 100
    end
    if GetResourceState('essentialmode') == 'started' then
        if pushRegistration(name) then
            print('[lc-inventory] RegisterServerCallback(' .. tostring(name) .. '): relay registered with essentialmode - OK')
        else
            print('[lc-inventory] RegisterServerCallback(' .. tostring(name) .. '): essentialmode rejected the relay registration - will keep retrying on the recurring timer')
        end
    else
        print('[lc-inventory] RegisterServerCallback(' .. tostring(name) .. '): essentialmode never reached "started" after 30s (currently: ' .. tostring(GetResourceState('essentialmode')) .. ') - will keep retrying on the recurring timer')
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