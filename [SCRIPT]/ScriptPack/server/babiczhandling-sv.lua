ESX = nil
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

local BABICZ_REQUIRED_PERM = 5

local function HasHandlingPermission(source)
	local xPlayer = ESX.GetPlayerFromId(source)
	if not xPlayer then return false end
	return (xPlayer.permission_level or 0) >= BABICZ_REQUIRED_PERM
end

ESX.RegisterServerCallback('babiczhandling:checkPermission', function(source, cb)
	cb(HasHandlingPermission(source))
end)

RegisterServerEvent('babiczhandling:logOpen')
AddEventHandler('babiczhandling:logOpen', function(plate)
	local src = source
	local name = GetPlayerName(src) or ('id ' .. tostring(src))
	if not HasHandlingPermission(src) then
		print(('^1[BabiczHandlingEditor] BLOCKED^0 unauthorized open attempt by %s (server id %s) - insufficient permission_level'):format(name, src))
		return
	end
	print(('^3[BabiczHandlingEditor]^0 %s (id %s) opened the handling editor - plate: %s'):format(name, src, tostring(plate)))
end)

RegisterServerEvent('babiczhandling:logSave')
AddEventHandler('babiczhandling:logSave', function(handlingName, plate)
	local src = source
	local name = GetPlayerName(src) or ('id ' .. tostring(src))
	if not HasHandlingPermission(src) then
		print(('^1[BabiczHandlingEditor] BLOCKED^0 unauthorized save attempt by %s (server id %s)'):format(name, src))
		return
	end
	print(('^3[BabiczHandlingEditor]^0 %s (id %s) saved handling "%s" - plate: %s'):format(name, src, tostring(handlingName), tostring(plate)))
end)
