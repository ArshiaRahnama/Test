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

-- ===================================================================== dispatch priority ===
-- Sunset-style job-level setting for the taxi/mechanic/ambulance duty queue (esx_society:toggleDispatchDuty):
--   queue    (default) : the request goes to whoever has waited longest in the queue (FIFO)
--   distance           : the request goes to the queued worker closest to the customer
-- Stored in server KVP (no SQL needed). offerNext() in main.lua reads it through GetDispatchMode().
function GetDispatchMode(job)
	return GetResourceKvpString('dispatch_mode_' .. tostring(job)) or 'queue'
end

local function isDispatchQueueJob(job)
	for _, j in ipairs(Config.DispatchQueueJobs or {}) do
		if j == job then return true end
	end
	return false
end

ESX.RegisterServerCallback('esx_society:getDispatchMode', function(source, cb, society)
	cb(GetDispatchMode(society) == 'distance')          -- true = priority by distance
end)

ESX.RegisterServerCallback('esx_society:toggleDispatchMode', function(source, cb, society)
	if not isDispatchQueueJob(society) or not isPlayerBoss(source, society) then return cb(nil) end
	local newMode = (GetDispatchMode(society) == 'distance') and 'queue' or 'distance'
	SetResourceKvp('dispatch_mode_' .. society, newMode)
	cb(newMode == 'distance')
end)

-- ======================================================================== division icon ===
-- divisions.icon (image URL, the same column migration_advanced_grades.sql adds and the classic menus show).
-- If the migration was never run, the column is created here once.
CreateThread(function()
	Wait(2000)
	pcall(function()
		MySQL.Async.fetchScalar(
			"SELECT COUNT(*) FROM information_schema.COLUMNS WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'divisions' AND COLUMN_NAME = 'icon'",
			{}, function(n)
				if tonumber(n) == 0 then
					MySQL.Async.execute('ALTER TABLE divisions ADD COLUMN icon VARCHAR(255) NULL', {})
				end
			end)
	end)
end)
