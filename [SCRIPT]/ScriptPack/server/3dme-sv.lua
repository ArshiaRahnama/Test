local logEnabled = false
ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

RegisterNetEvent('3dme:shareDisplay')
AddEventHandler('3dme:shareDisplay', function(text, status)
	TriggerClientEvent('3dme:triggerDisplay', -1, text, source, status)
end)

RegisterNetEvent('esx:giscaryveInventoryItem')
AddEventHandler('esx:giscaryveInventoryItem', function(target, type, itemName, itemCount)
	local _source = source

	local sourceXPlayer = ESX.GetPlayerFromId(_source)
	local targetXPlayer = ESX.GetPlayerFromId(target)

	local sourceName = GetPlayerName(_source)
	local targetName = GetPlayerName(target)

	if type == 'item_money' then

		if itemCount > 0 and sourceXPlayer.money >= itemCount then
			TriggerClientEvent('3dme:triggerDisplay', -1, sourceName .. ' be ' .. targetName .. ' meghdari pool dad' , _source, false)
		end

	elseif type == 'item_weapon' then

		local weaponLabel = ESX.GetWeaponLabel(itemName)

		TriggerClientEvent('3dme:triggerDisplay', -1, sourceName .. ' be ' .. targetName.. ' yek ' .. weaponLabel .. ' dad' , _source, false)

	end

end)

function setLog(text, source)
	local time = os.date("%d/%m/%Y %X")
	local name = GetPlayerName(source)
	local identifier = GetPlayerIdentifiers(source)
	local data = time .. ' : ' .. name .. ' - ' .. identifier[1] .. ' : ' .. text

	local content = LoadResourceFile(GetCurrentResourceName(), "log.txt")
	local newContent = content .. '\r\n' .. data
	SaveResourceFile(GetCurrentResourceName(), "log.txt", newContent, -1)
end

ESX.RegisterServerCallback('3dme:getIcName', function(source, cb)
	local _source = source
	characterName = string.gsub(exports.essentialmode:IcName(_source), "_", " ")

	cb(characterName)
end)