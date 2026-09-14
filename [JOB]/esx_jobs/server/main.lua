local PlayersWorking = {}
local vehicles = {}
local allowedJobs = {
	'fisherman',
	'tailor',
	'slaughterer',
	'lumberjack',
	'fueler',
	'miner'
}

ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

function IsAllowed(job)
	for i,v in ipairs(allowedJobs) do
		if v == job then
			return true
		end
	end

	return false
end

-- Runs one production/delivery tick for a player and, as long as they're
-- still marked as working, schedules the next one. `job` and `zoneKey` are
-- just identifiers -- the actual reward (times, item names, amounts, price)
-- is always read here from Config.Jobs, which is loaded server-side too
-- (client/jobs/*.lua is now also in the server_scripts list). The client
-- never sends the reward table itself, so there's nothing for a modified
-- client to tamper with.
local function Work(source, job, zoneKey)
	local jobData = Config.Jobs[job]
	local zone = jobData and jobData.Zones[zoneKey]

	if not zone or zone.Type ~= "work" and zone.Type ~= "delivery" or not zone.Item then
		PlayersWorking[source] = false
		return
	end

	local item = zone.Item

	SetTimeout(item[1].time, function()
		if not PlayersWorking[source] then return end

		local xPlayer = ESX.GetPlayerFromId(source)
		if not xPlayer then return end

		-- make sure the player is still actually on this job/zone before paying out again
		if xPlayer.job.name ~= job then
			PlayersWorking[source] = false
			return
		end

		for i=1, #item, 1 do
			local entry = item[i]

			local requiredQtty = 0
			if entry.requires ~= "nothing" then
				requiredQtty = xPlayer.getInventoryItem(entry.requires).count
			end

			if entry.db_name then
				-- production step: consumes "requires" (if any), produces "db_name"
				local itemQtty = xPlayer.getInventoryItem(entry.db_name).count

				if itemQtty >= entry.max then
					TriggerClientEvent('esx:showNotification', source, _U('max_limit', entry.name))
				elseif entry.requires ~= "nothing" and requiredQtty <= 0 then
					TriggerClientEvent('esx:showNotification', source, _U('not_enough', entry.requires_name))
				else
					xPlayer.addInventoryItem(entry.db_name, entry.add)
					if entry.requires ~= "nothing" then
						xPlayer.removeInventoryItem(entry.requires, entry.remove)
					end
					-- Unique_LevelQuest hook: RegisterServerEvent(quest.trigger) is
					-- set up generically by that resource for any Config.JobQuests
					-- entry with this exact trigger string. TriggerEvent (not
					-- TriggerServerEvent) is correct here -- we're already inside
					-- a server-side call chain that started from this player's
					-- 'esx_jobs:startWork', so the ambient `source` is still theirs.
					TriggerEvent('quest-' .. job .. ':produce')
				end
			else
				-- delivery step: sells "requires" for money, nothing is added to the inventory
				if entry.requires == "nothing" or requiredQtty <= 0 then
					TriggerClientEvent('esx:showNotification', source, _U('not_enough', entry.requires_name))
				else
					xPlayer.removeInventoryItem(entry.requires, entry.remove)
					if entry.price then
						xPlayer.addMoney(entry.price)
					end
					TriggerEvent('quest-' .. job .. ':deliver')
				end
			end
		end

		Work(source, job, zoneKey)
	end)
end

RegisterServerEvent('esx_jobs:startWork')
AddEventHandler('esx_jobs:startWork', function(job, zoneKey)
	local xPlayer = ESX.GetPlayerFromId(source)
	if not xPlayer then return end

	-- job/zoneKey are trusted only as *lookup keys* into the shared config,
	-- so validating them just means: is this a real job the player actually
	-- holds, and does that job actually have this zone.
	if not IsAllowed(job) then return end
	if xPlayer.job.name ~= job then return end
	if type(zoneKey) ~= "string" or not Config.Jobs[job] or not Config.Jobs[job].Zones[zoneKey] then return end

	if not PlayersWorking[source] then
		PlayersWorking[source] = true
		Work(source, job, zoneKey)
	end
end)

RegisterServerEvent('esx_jobs:stopWork')
AddEventHandler('esx_jobs:stopWork', function()
	PlayersWorking[source] = false
end)

-- ===== Job Center (merged in from esx_joblisting) =====
-- Lists every job in allowedJobs. fueler/lumberjack/slaughterer/tailor are
-- also in Config.Jobs (cloakroom + work zones); fisherman/miner are the
-- open activities merged in from esx_fishing/esx_minerjob -- they don't
-- gate on xPlayer.job.name, but holding the job title itself still matters
-- (salary, job-based perms elsewhere, etc.), so it's worth being able to
-- pick them here too.
ESX.RegisterServerCallback('esx_jobs:getJobsList', function(source, cb)
	local data = {}

	for i=1, #allowedJobs, 1 do
		local job = allowedJobs[i]
		table.insert(data, {
			job   = job,
			label = Config.JobLabels[job] or job
		})
	end

	cb(data)
end)

RegisterServerEvent('esx_jobs:setJob')
AddEventHandler('esx_jobs:setJob', function(job)
	local xPlayer = ESX.GetPlayerFromId(source)
	if not xPlayer then return end

	if type(job) ~= "string" or not IsAllowed(job) then
		print(('esx_jobs: %s attempted to set a job outside allowedJobs! (lua injector)'):format(xPlayer.identifier))
		return
	end

	-- Whitelist, not blacklist: only allow switching INTO one of our jobs
	-- if the player is currently unemployed or already holds one of our
	-- OWN jobs. Anything else (police, ambulance, mechanic, any
	-- organization job) is refused outright -- the Job Center should never
	-- be able to silently "fire" someone from a real org job.
	local currentJob = xPlayer.job.name
	if currentJob ~= 'nojob' and not IsAllowed(currentJob) then
		TriggerClientEvent('esx:showNotification', source, '~r~You need to resign from your current job first.')
		return
	end

	local wasNojob = (currentJob == 'nojob')

	xPlayer.setJob(job, 0)
	TriggerClientEvent("esx:inJob", xPlayer.source, job)
	TriggerClientEvent("startJob", xPlayer.source, job)

	-- Unique_LevelQuest hook: nojob players get a quest nudging them toward
	-- getting a job here in the first place (see Config.JobQuests["nojob"])
	if wasNojob then
		TriggerEvent('quest-nojob:getjob')
	end
end)

RegisterServerEvent('esx_jobs:addVehicle')
AddEventHandler('esx_jobs:addVehicle', function(netID)
	local identifier = GetPlayerIdentifier(source)

	if netID ~= nil then

		local vehicle = NetworkGetEntityFromNetworkId(netID)
		if DoesEntityExist(vehicle) then

			local model = GetEntityModel(vehicle)

			if model == GetHashKey("benson") then
				if not vehicles[identifier] then
					vehicles[identifier] = 0
				end

				vehicles[identifier] = netID
				TriggerClientEvent('esx_carlock:workVehicle', source, vehicles[identifier])

			end

		end

	else

		if not vehicles[identifier] then
			vehicles[identifier] = 0
		end

		vehicles[identifier] = 0
		TriggerClientEvent('esx_carlock:workVehicle', source, nil)

	end

end)

AddEventHandler('esx:playerLoaded', function(source)

	local identifier = GetPlayerIdentifier(source)
	if vehicles[identifier] ~= nil and vehicles[identifier] ~= 0 then
		TriggerClientEvent('esx_carlock:workVehicle', source, vehicles[identifier])
	end

end)

-- renamed to match client/main.lua's ESX.TriggerServerEvent('esx_jobs:cautionss', ...) calls
RegisterServerEvent('esx_jobs:cautionss')
AddEventHandler('esx_jobs:cautionss', function(cautionType, cautionAmount, spawnPoint, vehicle)
	local xPlayer = ESX.GetPlayerFromId(source)
	if not xPlayer then return end

	if cautionType == "take" then
		TriggerEvent('esx_addonaccount:getAccount', 'caution', xPlayer.identifier, function(account)

		end)

		TriggerClientEvent('esx_jobs:spawnJobVehicle', source, spawnPoint, vehicle)
	elseif cautionType == "give_back" then

		TriggerEvent('esx_addonaccount:getAccount', 'caution', xPlayer.identifier, function(account)

		end)
	end
end)

-- ===== Admin uniform editor (pads next to each cloakroom, client-side via ox_target) =====
-- Each job+gender keeps a history of saved outfits. One entry per
-- job+gender is "active" -- that's the one Config[...].work_wear[gender]
-- is set to, i.e. the one everyone actually gets from OpenMenu's "job_wear".
-- Persisted in the DB (esx_jobs_uniforms table, see esx_jobs.sql), NOT a
-- resource file -- a file inside the resource folder gets wiped out any
-- time the resource is redeployed/updated; a DB table doesn't.
local UNIFORM_FIELDS = {
	'tshirt_1','tshirt_2','torso_1','torso_2','decals_1','decals_2','arms',
	'pants_1','pants_2','shoes_1','shoes_2','helmet_1','helmet_2',
	'glasses_1','glasses_2','chain_1','chain_2','ears_1','ears_2'
}

-- the true factory defaults from config.lua, captured before anything saved
-- can overwrite Config[...].work_wear -- used as the last-resort fallback
-- if an admin deletes every history entry for a job+gender
local FactoryDefaultWorkWear = {}
for job, configKey in pairs(Config.UniformConfigKey) do
	FactoryDefaultWorkWear[job] = {
		male   = Config[configKey].work_wear.male,
		female = Config[configKey].work_wear.female
	}
end

-- UniformHistory[job][gender] = { active_id = "...", history = { {id=,label=,clothes=,savedAt=,savedBy=}, ... } }
local UniformHistory = {}

local function EnsureHistoryShape(job)
	if not UniformHistory[job] then
		UniformHistory[job] = {
			male   = {active_id = nil, previous_active_id = nil, history = {}},
			female = {active_id = nil, previous_active_id = nil, history = {}}
		}
	end
end

local function SaveUniformRow(job, gender)
	local g = UniformHistory[job][gender]
	MySQL.Async.execute([[
		INSERT INTO esx_jobs_uniforms (job, gender, active_id, previous_active_id, history)
		VALUES (@job, @gender, @active_id, @previous_active_id, @history)
		ON DUPLICATE KEY UPDATE active_id = @active_id, previous_active_id = @previous_active_id, history = @history
	]], {
		['@job'] = job,
		['@gender'] = gender,
		['@active_id'] = g.active_id,
		['@previous_active_id'] = g.previous_active_id,
		['@history'] = json.encode(g.history)
	})
end

local function ApplyActiveToConfig(job)
	local configKey = Config.UniformConfigKey[job]
	if not configKey then return end

	for _, gender in ipairs({'male', 'female'}) do
		local g = UniformHistory[job][gender]
		local activeEntry = nil
		for i=1, #g.history, 1 do
			if g.history[i].id == g.active_id then
				activeEntry = g.history[i]
				break
			end
		end
		Config[configKey].work_wear[gender] = activeEntry and activeEntry.clothes or FactoryDefaultWorkWear[job][gender]
	end
end

local function LoadSavedUniforms()
	for job in pairs(Config.UniformConfigKey) do
		EnsureHistoryShape(job)
	end

	local ok, rows = pcall(function()
		return MySQL.Sync.fetchAll('SELECT job, gender, active_id, previous_active_id, history FROM esx_jobs_uniforms', {})
	end)

	if ok and type(rows) == "table" then
		for i=1, #rows, 1 do
			local row = rows[i]
			if UniformHistory[row.job] and (row.gender == 'male' or row.gender == 'female') then
				local decodeOk, history = pcall(json.decode, row.history)
				UniformHistory[row.job][row.gender] = {
					active_id = row.active_id,
					previous_active_id = row.previous_active_id,
					history   = (decodeOk and type(history) == "table") and history or {}
				}
			end
		end
	else
		print('esx_jobs: could not load esx_jobs_uniforms from the DB (table missing? run esx_jobs.sql) -- using config.lua defaults for now')
	end

	for job in pairs(Config.UniformConfigKey) do
		ApplyActiveToConfig(job)
	end
end
LoadSavedUniforms()

local function CheckAdminPermission(xPlayer)
	if not xPlayer then return false end
	if not xPlayer.permission_level or xPlayer.permission_level < Config.UniformEditorMinPermission then
		TriggerClientEvent('esx:showNotification', xPlayer.source, ('~r~You need permission level %s+ to do this.'):format(Config.UniformEditorMinPermission))
		print(('esx_jobs: %s (permission_level=%s) tried to use the uniform editor without permission'):format(xPlayer.identifier, tostring(xPlayer.permission_level)))
		return false
	end
	return true
end

-- Matches the exact DiscordBot:ToDiscord pattern already used for the miner
-- job's sale log (server/jobs/minerjob.lua) -- 'adminmenu' is an existing
-- webhook category (see [SCRIPT]/logs/SERVER/Server.lua) for admin actions.
local function LogUniformToDiscord(action, job, gender, xPlayer, extra)
	TriggerEvent('DiscordBot:ToDiscord', 'adminmenu', 'UniformEditorLog',
		'```css\n[ Admin : ' .. GetPlayerName(xPlayer.source) .. '(' .. xPlayer.source .. ') ]\n' ..
		'[ Steam : ' .. xPlayer.identifier .. ' ]\n' ..
		'[ Action : ' .. action .. ' ]\n' ..
		'[ Job : ' .. (Config.JobLabels[job] or job) .. ' ]\n' ..
		'[ Gender : ' .. gender .. ' ]\n' ..
		(extra or '') ..
		'```', 'user', true, xPlayer.source, false)
end

-- History auto-cleanup: once a job+gender has more than this many saved
-- versions, the oldest ones (never the active or previous-active, so Undo
-- keeps working) get dropped so the DB/menu doesn't grow forever.
local MAX_HISTORY_PER_GENDER = 10

local function TrimHistory(job, gender)
	local g = UniformHistory[job][gender]
	while #g.history > MAX_HISTORY_PER_GENDER do
		local removedAny = false
		for i=1, #g.history, 1 do
			local entry = g.history[i]
			if entry.id ~= g.active_id and entry.id ~= g.previous_active_id then
				table.remove(g.history, i)
				removedAny = true
				break
			end
		end
		if not removedAny then break end -- everything left is active/previous_active, stop
	end
end

-- Save the outfit the admin just built in the esx_skin menu as a NEW
-- history entry, and make it the active one for that job+gender.
RegisterServerEvent('esx_jobs:adminSaveUniform')
AddEventHandler('esx_jobs:adminSaveUniform', function(job, skin, label)
	local xPlayer = ESX.GetPlayerFromId(source)
	if not CheckAdminPermission(xPlayer) then return end
	if not Config.UniformConfigKey[job] or type(skin) ~= "table" then return end

	EnsureHistoryShape(job)

	-- only pull the specific clothing fields we actually use into a fresh
	-- table -- never store/trust the raw client-supplied skin table as-is
	local clothes = {}
	for i=1, #UNIFORM_FIELDS, 1 do
		local field = UNIFORM_FIELDS[i]
		clothes[field] = tonumber(skin[field]) or 0
	end

	local genderKey = (skin.sex == 1) and 'female' or 'male'
	local g = UniformHistory[job][genderKey]
	label = (type(label) == "string" and label ~= "" and label) or ('Version ' .. (#g.history + 1))

	local entry = {
		id      = tostring(os.time()) .. '_' .. tostring(math.random(1000, 9999)),
		label   = label,
		clothes = clothes,
		savedAt = os.date('%Y-%m-%d %H:%M'),
		savedBy = xPlayer.identifier
	}

	table.insert(g.history, entry)
	g.previous_active_id = g.active_id
	g.active_id = entry.id
	TrimHistory(job, genderKey)

	ApplyActiveToConfig(job)
	SaveUniformRow(job, genderKey)
	LogUniformToDiscord('Saved + activated', job, genderKey, xPlayer, '[ Label : ' .. label .. ' ]\n')

	TriggerClientEvent('esx:showNotification', source, ('~g~Saved "%s" as the active %s %s uniform.'):format(label, genderKey, Config.JobLabels[job] or job))
end)

-- OpenMenu (client) calls this every time "job_wear" is picked, since the
-- admin uniform editor above only ever updates Config on the SERVER side --
-- the client has its own separate copy of config.lua that never changes,
-- so without this callback workers would always get the config.lua default
-- no matter what an admin saved/activated.
ESX.RegisterServerCallback('esx_jobs:getActiveUniform', function(source, cb, job)
	local configKey = Config.UniformConfigKey[job]
	if not configKey then cb(nil) return end
	cb(Config[configKey].work_wear)
end)

-- Lets the client check up front, before opening any menu, instead of
-- letting a non-admin build a whole outfit only to get rejected at the end
ESX.RegisterServerCallback('esx_jobs:isUniformAdmin', function(source, cb)
	local xPlayer = ESX.GetPlayerFromId(source)
	cb(xPlayer and xPlayer.permission_level and xPlayer.permission_level >= Config.UniformEditorMinPermission or false)
end)

-- Lets the client build its history-browser menu (ox_lib context)
ESX.RegisterServerCallback('esx_jobs:getUniformHistory', function(source, cb, job)
	local xPlayer = ESX.GetPlayerFromId(source)
	if not xPlayer or not xPlayer.permission_level or xPlayer.permission_level < Config.UniformEditorMinPermission then
		cb(nil)
		return
	end
	if not Config.UniformConfigKey[job] then cb(nil) return end
	EnsureHistoryShape(job)
	cb(UniformHistory[job])
end)

RegisterServerEvent('esx_jobs:adminApplyUniformHistory')
AddEventHandler('esx_jobs:adminApplyUniformHistory', function(job, gender, id)
	local xPlayer = ESX.GetPlayerFromId(source)
	if not CheckAdminPermission(xPlayer) then return end
	if not Config.UniformConfigKey[job] or (gender ~= 'male' and gender ~= 'female') then return end

	EnsureHistoryShape(job)
	local g = UniformHistory[job][gender]
	local applyEntry = nil
	for i=1, #g.history, 1 do
		if g.history[i].id == id then applyEntry = g.history[i] break end
	end
	if not applyEntry then return end

	g.previous_active_id = g.active_id
	g.active_id = id
	ApplyActiveToConfig(job)
	SaveUniformRow(job, gender)
	LogUniformToDiscord('Activated existing version', job, gender, xPlayer, '[ Label : ' .. applyEntry.label .. ' ]\n')

	TriggerClientEvent('esx:showNotification', source, ('~g~That version is now the active %s %s uniform.'):format(gender, Config.JobLabels[job] or job))
end)

-- Quick Undo: swap back to whatever was active right before the current one
RegisterServerEvent('esx_jobs:adminUndoUniform')
AddEventHandler('esx_jobs:adminUndoUniform', function(job, gender)
	local xPlayer = ESX.GetPlayerFromId(source)
	if not CheckAdminPermission(xPlayer) then return end
	if not Config.UniformConfigKey[job] or (gender ~= 'male' and gender ~= 'female') then return end

	EnsureHistoryShape(job)
	local g = UniformHistory[job][gender]
	if not g.previous_active_id then
		TriggerClientEvent('esx:showNotification', source, '~y~Nothing to undo.')
		return
	end

	local stillExists = false
	for i=1, #g.history, 1 do
		if g.history[i].id == g.previous_active_id then stillExists = true break end
	end
	if not stillExists then
		TriggerClientEvent('esx:showNotification', source, '~y~That previous version was deleted, can\'t undo to it.')
		g.previous_active_id = nil
		SaveUniformRow(job, gender)
		return
	end

	g.active_id, g.previous_active_id = g.previous_active_id, g.active_id
	ApplyActiveToConfig(job)
	SaveUniformRow(job, gender)
	LogUniformToDiscord('Undo', job, gender, xPlayer)

	TriggerClientEvent('esx:showNotification', source, ('~g~Reverted to the previous %s %s uniform.'):format(gender, Config.JobLabels[job] or job))
end)

RegisterServerEvent('esx_jobs:adminDeleteUniformHistory')
AddEventHandler('esx_jobs:adminDeleteUniformHistory', function(job, gender, id)
	local xPlayer = ESX.GetPlayerFromId(source)
	if not CheckAdminPermission(xPlayer) then return end
	if not Config.UniformConfigKey[job] or (gender ~= 'male' and gender ~= 'female') then return end

	EnsureHistoryShape(job)
	local g = UniformHistory[job][gender]
	local deletedLabel = nil
	for i=#g.history, 1, -1 do
		if g.history[i].id == id then
			deletedLabel = g.history[i].label
			table.remove(g.history, i)
		end
	end
	if not deletedLabel then return end

	-- if we just deleted the active one, fall back to the most recently
	-- saved remaining entry, or the factory default if none are left
	if g.active_id == id then
		g.active_id = (#g.history > 0) and g.history[#g.history].id or nil
	end
	if g.previous_active_id == id then
		g.previous_active_id = nil
	end

	ApplyActiveToConfig(job)
	SaveUniformRow(job, gender)
	LogUniformToDiscord('Deleted version', job, gender, xPlayer, '[ Label : ' .. deletedLabel .. ' ]\n')

	TriggerClientEvent('esx:showNotification', source, ('~y~Deleted that version from the %s %s history.'):format(gender, Config.JobLabels[job] or job))
end)

RegisterServerEvent('esx_jobs:adminRenameUniformHistory')
AddEventHandler('esx_jobs:adminRenameUniformHistory', function(job, gender, id, newLabel)
	local xPlayer = ESX.GetPlayerFromId(source)
	if not CheckAdminPermission(xPlayer) then return end
	if not Config.UniformConfigKey[job] or (gender ~= 'male' and gender ~= 'female') then return end
	if type(newLabel) ~= "string" or newLabel == "" then return end

	EnsureHistoryShape(job)
	local g = UniformHistory[job][gender]
	for i=1, #g.history, 1 do
		if g.history[i].id == id then
			local oldLabel = g.history[i].label
			g.history[i].label = newLabel
			SaveUniformRow(job, gender)
			LogUniformToDiscord('Renamed version', job, gender, xPlayer, '[ From : ' .. oldLabel .. ' ]\n[ To : ' .. newLabel .. ' ]\n')
			TriggerClientEvent('esx:showNotification', source, ('~g~Renamed to "%s".'):format(newLabel))
			return
		end
	end
end)
