-- ============================================================
-- GPS Tracker (FBI/CIA)
-- Place a tracker on a nearby vehicle from the /agent menu. Any
-- client that currently has that vehicle in range reports its
-- position back (client/tracker_manager.lua runs this check for
-- everyone, not just agents, since whoever is near the vehicle
-- might not be the agent themselves); the tracking agent gets a
-- live-updating blip.
-- ============================================================

ESX = nil
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

local AGENT_JOBS = { fbi = true, cia = true }

local function isAgent(jobname)
	return AGENT_JOBS[jobname] == true
end

local TRACKER_DURATION = 30 * 60 -- seconds

local trackers = {} -- trackers[plate] = { agentSource, expiresAt }

local function broadcastTrackedPlates()
	local plates = {}
	for plate in pairs(trackers) do
		plates[#plates + 1] = plate
	end
	TriggerClientEvent('esx_uniquejobs:trackedPlatesUpdated', -1, plates)
end

RegisterServerEvent('esx_uniquejobs:placeTracker')
AddEventHandler('esx_uniquejobs:placeTracker', function(plate)
	local source = source
	local xPlayer = ESX.GetPlayerFromId(source)
	if not xPlayer or not isAgent(xPlayer.job.name) then return end

	if not plate or plate == '' then return end
	plate = string.upper(string.gsub(plate, "%s+", ""))

	if trackers[plate] then
		TriggerClientEvent('esx:showNotification', source, "~r~In Mashin Ghablan Tracker Dare!")
		return
	end

	trackers[plate] = { agentSource = source, expiresAt = os.time() + TRACKER_DURATION }
	broadcastTrackedPlates()

	TriggerClientEvent('esx:showNotification', source, "~g~Tracker Rooye Plaque " .. plate .. " Nasb Shod (30 Daghighe)")
	TriggerEvent('DiscordBot:ToDiscord', 'adminmenu', 'TrackerLog', '```css\n[ Agent : '..GetPlayerName(source)..'(' .. source .. ') ]\n[ Job : '..xPlayer.job.name..' ]\n[ Action : PLACED GPS TRACKER ]\n[ Plate : '..tostring(plate)..' ]\n[ Duration : 30 min ]\n```', 'user', true, source, false)

	SetTimeout(TRACKER_DURATION * 1000, function()
		if trackers[plate] and trackers[plate].agentSource == source then
			trackers[plate] = nil
			broadcastTrackedPlates()
			TriggerClientEvent('esx:showNotification', source, "~r~Tracker Rooye " .. plate .. " Ghat Shod (Zaman Tamam Shod)")
		end
	end)
end)

RegisterServerEvent('esx_uniquejobs:removeTracker')
AddEventHandler('esx_uniquejobs:removeTracker', function(plate)
	local source = source
	if trackers[plate] and trackers[plate].agentSource == source then
		trackers[plate] = nil
		broadcastTrackedPlates()
		TriggerClientEvent('esx:showNotification', source, "~g~Tracker Hazf Shod")
		TriggerEvent('DiscordBot:ToDiscord', 'adminmenu', 'TrackerLog', '```css\n[ Agent : '..GetPlayerName(source)..'(' .. source .. ') ]\n[ Action : REMOVED GPS TRACKER ]\n[ Plate : '..tostring(plate)..' ]\n```', 'user', true, source, false)
	end
end)

-- Any client near a tracked vehicle reports its live position here
RegisterServerEvent('esx_uniquejobs:trackerPing')
AddEventHandler('esx_uniquejobs:trackerPing', function(plate, x, y, z)
	local tracker = trackers[plate]
	if not tracker then return end

	TriggerClientEvent('esx_uniquejobs:trackerUpdate', tracker.agentSource, plate, x, y, z)
end)

ESX.RegisterServerCallback('esx_uniquejobs:getMyTrackers', function(source, cb)
	local list = {}
	for plate, t in pairs(trackers) do
		if t.agentSource == source then
			list[#list + 1] = { plate = plate, secondsLeft = t.expiresAt - os.time() }
		end
	end
	cb(list)
end)

-- New clients (or a resource restart on the agent's end) need the full
-- current plate list once, since broadcastTrackedPlates only fires on change
RegisterServerEvent('esx_uniquejobs:requestTrackedPlates')
AddEventHandler('esx_uniquejobs:requestTrackedPlates', function()
	local source = source
	local plates = {}
	for plate in pairs(trackers) do
		plates[#plates + 1] = plate
	end
	TriggerClientEvent('esx_uniquejobs:trackedPlatesUpdated', source, plates)
end)
