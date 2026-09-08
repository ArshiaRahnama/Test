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
    -------------------------------------------------------------
    if GetResourceState('essentialmode') == 'started' then
        exports['essentialmode']:RegisterServerCallback(name, cb)
    else
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