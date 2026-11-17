-- Boss UI (server side): the only thing the NUI needs that the classic menu didn't have.
-- Everything else (money, employees, grades, perms) reuses the existing esx_society callbacks/events.

ESX.RegisterServerCallback('esx_society:bossStats', function(source, cb, society)
	local online = 0
	for _, id in ipairs(ESX.GetPlayers()) do
		local xPlayer = ESX.GetPlayerFromId(id)
		if xPlayer and xPlayer.job and xPlayer.job.name == society then
			online = online + 1
		end
	end
	cb({ online = online })
end)
