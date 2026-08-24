ESX = nil

local tints = {
	["tintgreen"] =  1,
	["tintgold"] =  2,
	["tintpink"] =  3,
	["tintcream"] =  4,
	["tintblack"] =  5,
	["tintorange"] =  6,
	["tintplat"] =  7,
}

local translate = {
  ['clip_extended'] = { name = 'eclip', label = "Kheshab Ezafe" },
  ['clip_box'] = { name = 'dclip', label = "Kheshab Drum" },
  ['suppressor'] = { name = 'silencer', label = "Silencer" },
  ['flashlight'] = { name = 'flashlight', label = "Flashlight" },
  ['grip'] = { name = 'grip', label = "Grip" },
  ['clip_drum'] = { name = 'dclip', label = "Kheshab Drum"}
}

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

for k,v in pairs(tints) do
	ESX.RegisterUsableItem(k, function(source)
		local xPlayer = ESX.GetPlayerFromId(source)
		local item = xPlayer.getInventoryItem(k)

		TriggerClientEvent('esx_components:useTint', source, {color = v, name = k, label = item.label})

	end)
end

RegisterServerEvent('esx_components:remove')
AddEventHandler('esx_components:remove', function(itemName)
	local xPlayer = ESX.GetPlayerFromId(source)
	xPlayer.removeInventoryItem(itemName, 1)
end)

RegisterServerEvent('esx_components:addComponent')
AddEventHandler('esx_components:addComponent', function(component)
	local xPlayer = ESX.GetPlayerFromId(source)
	local item = xPlayer.getInventoryItem(component.item)
	if item.count > 0 then
		if xPlayer.hasWeapon(component.weapon) then
			if not xPlayer.hasWeaponComponent(component.weapon, component.id) then
				xPlayer.removeInventoryItem(component.item, 1)
				xPlayer.addWeaponComponent(component.weapon, component.id)
				TriggerClientEvent('esx:showNotification', source, "~h~Shoma ba movafaghiat ~g~1x " .. item.label .. "~w~ estefade kardid.")

			else
				TriggerClientEvent('esx:showNotification', source, "~h~Aslahe shoma dar hale hazer in component ra darad!")
			end
		else
			TriggerClientEvent('esx:showNotification', source, "~h~Shoma aslahe mored nazar ra baraye estefade kardan component nadarid!")
		end
	else
		TriggerClientEvent('esx:showNotification', source, "~h~Shoma ~g~" .. item.label .. "~w~ kafi baraye estefade kardan nadarid!")
	end
end)

RegisterServerEvent('esx_components:removeComponent')
AddEventHandler('esx_components:removeComponent', function(component, all)
	local xPlayer = ESX.GetPlayerFromId(source)

	if all then

		local weapon = xPlayer.hasWeapon(component)
		if weapon.components ~= {} then

			for k,v in pairs(weapon.components) do
				if v ~= "clip_default" then
					xPlayer.removeWeaponComponent(component, v)
					xPlayer.addInventoryItem(translate[v].name, 1)
					TriggerClientEvent('esx:showNotification', source, "~h~Shoma ba movafaghiat ~g~1x " .. translate[v].label .. "~w~ az aslahe khod joda kardid.")
				end
			end

		else
			TriggerClientEvent('esx:showNotification', source, "~h~Shoma aslahe mored nazar shoma hich componenti nadarad!")
		end

	else
		local item = xPlayer.getInventoryItem(component.item)
		if xPlayer.hasWeapon(component.weapon) then
			if xPlayer.hasWeaponComponent(component.weapon, component.id) then

				xPlayer.removeWeaponComponent(component.weapon, component.id)
				xPlayer.addInventoryItem(component.item, 1)
				TriggerClientEvent('esx:showNotification', source, "~h~Shoma ba movafaghiat ~g~1x " .. item.label .. "~w~ az aslahe khod joda kardid.")

			else
				TriggerClientEvent('esx:showNotification', source, "~h~Aslahe shoma component ~g~" .. item.label .. "~w~ ra nadarad!")
			end
		else
			TriggerClientEvent('esx:showNotification', source, "~h~Shoma aslahe mored nazar ra baraye joda kardan component nadarid!")
		end
	end

end)

ESX.RegisterUsableItem('clip', function(source)
	TriggerClientEvent('esx_components:useClipcli', source)
end)

ESX.RegisterUsableItem('eclip', function(source)
	TriggerClientEvent('esx_components:useExtendedMagazine', source)
end)

ESX.RegisterUsableItem('dclip', function(source)
	TriggerClientEvent('esx_components:useDrumMagazine', source)
end)

ESX.RegisterUsableItem('silencer', function(source)
    TriggerClientEvent('esx_components:useSilencer', source)
end)

ESX.RegisterUsableItem('flashlight', function(source)
    TriggerClientEvent('esx_components:useFlashlight', source)
end)

ESX.RegisterUsableItem('grip', function(source)
    TriggerClientEvent('esx_components:useGrip', source)
end)

ESX.RegisterUsableItem('yusuf', function(source)
    TriggerClientEvent('esx_components:useYusuf', source)
end)
