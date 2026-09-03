ESX = nil
skin = nil
Dressing = {}

MoneyData = {
    ["money"] = {name = "Liquide"},
    ["black_money"] = {name = "Argent Sale"},
    ["bank"] = {name = "Argent en banque"},
}

Citizen.CreateThread(function()
    while not ESX and not skin do
        Wait(0)
        TriggerEvent("esx:getSharedObject", function(obj) ESX = obj end)
		ESX.TriggerServerCallback("esx_skin:getPlayerSkin", function(skins)
			skin = skins
		end)
    end
end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(playerData)
    while not ESX do 
        Wait(5)
    end
	ESX.PlayerLoaded = true
	ESX.PlayerData = playerData
end)

RegisterNetEvent('esx:addInventoryItem')
AddEventHandler('esx:addInventoryItem', function(item, count)
	for k,v in ipairs(ESX.PlayerData.inventory) do
		if v.name == item then
			ESX.PlayerData.inventory[k].count = count
			break
		end
	end
	RefreshInventoryContent("all")
end)

RegisterNetEvent('esx:removeInventoryItem')
AddEventHandler('esx:removeInventoryItem', function(item, count, showNotification)
	for k,v in ipairs(ESX.PlayerData.inventory) do
		if v.name == item then
			ESX.PlayerData.inventory[k].count = count
			break
		end
	end
	RefreshInventoryContent("all")
end)

RegisterNetEvent('esx:setAccountMoney')
AddEventHandler('esx:setAccountMoney', function(account)
	for i = 1, #ESX.PlayerData.accounts, 1 do
		if ESX.PlayerData.accounts[i].name == account.name then
			ESX.PlayerData.accounts[i] = account
			break
		end
	end
	RefreshInventoryContent("all")
end)

RegisterNetEvent('esx:setMaxWeight')
AddEventHandler('esx:setMaxWeight', function(newMaxWeight) 
	ESX.PlayerData.maxWeight = newMaxWeight
	RefreshInventoryContent("all")
end)

-- Loadout

RegisterNetEvent('esx:addWeapon')
AddEventHandler('esx:addWeapon', function(weaponName, ammo, isPerm)
	local permanent = false
	if isPerm and isPerm == true then
		permanent = true
	else
		permanent = false
	end
	table.insert(ESX.PlayerData.loadout, {
		name = weaponName,
		ammo = ammo,
		label = ESX.GetWeaponLabel(weaponName) or "UNKNOWN NAME",
		components = {},
		tintIndex = 0,
		permanent = permanent
	})
	RefreshInventoryContent("all")
end)

RegisterNetEvent('esx:setWeaponAmmo')
AddEventHandler('esx:setWeaponAmmo', function(weaponName, weaponAmmo)
	for k, v in pairs(ESX.PlayerData.loadout) do 
		if string.lower(v.name) == string.lower(weaponName) then
			v.ammo = weaponAmmo
			break
		end
	end
	RefreshInventoryContent("all")
end)

RegisterNetEvent('esx:removeWeapon')
AddEventHandler('esx:removeWeapon', function(weaponName)
	for k, v in pairs(ESX.PlayerData.loadout) do 
		if v and tostring(v.name) then
		if string.lower(v.name) == string.lower(weaponName) then
			table.remove(ESX.PlayerData.loadout, k)
			break
		end
	    end
	end
	RefreshInventoryContent("all")
end)

RegisterNetEvent("inventory:syncOufits")
AddEventHandler('inventory:syncOufits', function(dressing)
	Dressing = dressing

end)
