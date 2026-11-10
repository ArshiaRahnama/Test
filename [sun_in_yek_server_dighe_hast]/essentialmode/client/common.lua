-- Pub by FleeX Team , https://discord.gg/87rGBxgCsa

local resourceList, requestSended
sec = 0
function addsec()
	sec = sec + 1
	SetTimeout(1000,addsec)
end
SetTimeout(1000,addsec)
local function getObject()
	-- local resourceName = GetInvokingResource()
	-- if not resourceList and not requestSended then
	-- 	requestSended = true
	-- 	ESX.TriggerServerCallback('core:getResourceList', function(list)
	-- 		if not resourceList then
	-- 			resourceList = list
	-- 		end
	-- 	end)
	-- end
	-- while not resourceList do Wait(500) end
	-- if not resourceList[resourceName] then
	-- 	return TriggerServerEvent("sc:adminalarm",'Trigger esx event(cheating) unknown resource name : '.. resourceName)
	-- end
	-- if sec > 100 then
	-- 	-- TriggerServerEvent("sc:adminalarm","Trigger esx event(cheating) can false positive time ".. sec .. ' resource name : '.. resourceName)
	-- end
	return ESX
end
AddEventHandler('esx:getSharedObject', function(cb)
	cb(getObject())
end)

exports('getObject', getObject)
-- function getSharedObject()
-- 	return ESX
-- end