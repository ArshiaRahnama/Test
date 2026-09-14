local ESX = nil
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

local carrying = {}

local carried = {}

local respone
RegisterServerEvent("carry:respone")
AddEventHandler("carry:respone", function(toggle)
	respone = toggle
end)

RegisterServerEvent("citizen:sync")
AddEventHandler("citizen:sync", function(targetSrc)
	local source = source
	local sourcePed = GetPlayerPed(source)
   	local sourceCoords = GetEntityCoords(sourcePed)
	local targetPed = GetPlayerPed(targetSrc)
    local targetCoords = GetEntityCoords(targetPed)
	if #(sourceCoords - targetCoords) <= 3.0 then
		TriggerClientEvent("citizen:syncTarget", source, targetSrc)
		TriggerClientEvent("carry:sync1", targetSrc, targetSrc)
		carrying[targetSrc] = source
		carried[source] = targetSrc
		TriggerClientEvent("carry:showcancel", targetSrc)
		TriggerClientEvent("carry:showdrop", source)
	end
end)

RegisterServerEvent("citizen:syncjob")
AddEventHandler("citizen:syncjob", function(targetSrc)
	local source = source
	local sourcePed = GetPlayerPed(source)
   	local sourceCoords = GetEntityCoords(sourcePed)
	local targetPed = GetPlayerPed(targetSrc)
    local targetCoords = GetEntityCoords(targetPed)
	if #(sourceCoords - targetCoords) <= 50.0 then
		TriggerClientEvent("citizen:syncTarget", targetSrc, source)
		TriggerClientEvent("carry:sync1", source, targetSrc)
		carrying[targetSrc] = source
		carried[source] = targetSrc

		TriggerClientEvent("carry:showdrop", source)
	end
end)

RegisterServerEvent("carry:send")
AddEventHandler("carry:send", function(targetSrc)
	local source = source
	TriggerClientEvent("carry:sendtocl", targetSrc, source)
end)

RegisterServerEvent("carry:sendjob")
AddEventHandler("carry:sendjob", function(targetSrc)
	local source = source
	TriggerClientEvent("carry:sendtocljob", source, targetSrc)
end)

RegisterServerEvent("citizen:stopcarry")
AddEventHandler("citizen:stopcarry", function(targetSrc)
	local source = source
	if carrying[source] then
		TriggerClientEvent("citizen:cl_stop", targetSrc)
		carrying[source] = nil
		carried[targetSrc] = nil
	elseif carried[source] then
		TriggerClientEvent("citizen:cl_stop", carried[source])
		carrying[carried[source]] = nil
		carried[source] = nil
	end
end)

AddEventHandler('playerDropped', function(reason)
	local source = source

	if carrying[source] then
		TriggerClientEvent("citizen:cl_stop", carrying[source])
		carried[carrying[source]] = nil
		carrying[source] = nil
	end

	if carried[source] then
		TriggerClientEvent("citizen:cl_stop", carried[source])
		carrying[carried[source]] = nil
		carried[source] = nil
	end
end)

