ESX = nil
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

ESX.RegisterServerCallback('esx_joblisting:getJobsList', function(source, cb)
	MySQL.Async.fetchAll('SELECT * FROM jobs WHERE whitelisted = @whitelisted', {
		['@whitelisted'] = false
	}, function(result)
		local data = {}

		for i=1, #result, 1 do
			table.insert(data, {
				job   = result[i].name,
				label = result[i].label
			})
		end

		cb(data)
	end)
end)

RegisterServerEvent('esx_joblisting:setJob')
AddEventHandler('esx_joblisting:setJob', function(job)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	if not xPlayer then return end

	MySQL.Async.fetchAll('SELECT whitelisted FROM jobs WHERE name = @name', {
		['@name'] = job,
	}, function(result)
		if result[1] and not result[1].whitelisted then
			-- this was commented out in the original file, meaning the menu
			-- only *looked* like it changed your job (waypoint/blips updated
			-- client-side) without ever touching the real ESX job record.
			xPlayer.setJob(job, 0)
			TriggerClientEvent("esx:inJob", xPlayer.source, job)
			TriggerClientEvent("startJob", xPlayer.source, job)
		else
			print(('esx_joblisting: %s attempted to set a whitelisted/unknown job! (lua injector)'):format(xPlayer.identifier))
		end
	end)

end)
