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

	xPlayer.setJob(job, 0)
	TriggerClientEvent("esx:inJob", xPlayer.source, job)
	TriggerClientEvent("startJob", xPlayer.source, job)
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
local UNIFORM_FIELDS = {
	'tshirt_1','tshirt_2','torso_1','torso_2','decals_1','decals_2','arms',
	'pants_1','pants_2','shoes_1','shoes_2','helmet_1','helmet_2',
	'glasses_1','glasses_2','chain_1','chain_2','ears_1','ears_2'
}

-- the true factory defaults from config.lua, captured before any save file
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
			male   = {active_id = nil, history = {}},
			female = {active_id = nil, history = {}}
		}
	end
end

local function SaveUniformFile(job)
	SaveResourceFile(GetCurrentResourceName(), 'uniform_' .. job .. '.json', json.encode(UniformHistory[job]), -1)
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
		local raw = LoadResourceFile(GetCurrentResourceName(), 'uniform_' .. job .. '.json')
		if raw then
			local ok, saved = pcall(json.decode, raw)
			if ok and type(saved) == "table" and saved.male and saved.female then
				UniformHistory[job] = saved
			else
				print(('esx_jobs: failed to parse saved uniform history for %s, starting fresh'):format(job))
			end
		end
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
	label = (type(label) == "string" and label ~= "" and label) or ('Version ' .. (#UniformHistory[job][genderKey].history + 1))

	local entry = {
		id      = tostring(os.time()) .. '_' .. tostring(math.random(1000, 9999)),
		label   = label,
		clothes = clothes,
		savedAt = os.date('%Y-%m-%d %H:%M'),
		savedBy = xPlayer.identifier
	}

	table.insert(UniformHistory[job][genderKey].history, entry)
	UniformHistory[job][genderKey].active_id = entry.id

	ApplyActiveToConfig(job)
	SaveUniformFile(job)

	TriggerClientEvent('esx:showNotification', source, ('~g~Saved "%s" as the active %s %s uniform.'):format(label, genderKey, Config.JobLabels[job] or job))
end)

-- Lets the client build its history-browser menu (ox_lib context)
ESX.RegisterServerCallback('esx_jobs:getUniformHistory', function(source, cb, job)
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
	local found = false
	for i=1, #g.history, 1 do
		if g.history[i].id == id then found = true break end
	end
	if not found then return end

	g.active_id = id
	ApplyActiveToConfig(job)
	SaveUniformFile(job)

	TriggerClientEvent('esx:showNotification', source, ('~g~That version is now the active %s %s uniform.'):format(gender, Config.JobLabels[job] or job))
end)

RegisterServerEvent('esx_jobs:adminDeleteUniformHistory')
AddEventHandler('esx_jobs:adminDeleteUniformHistory', function(job, gender, id)
	local xPlayer = ESX.GetPlayerFromId(source)
	if not CheckAdminPermission(xPlayer) then return end
	if not Config.UniformConfigKey[job] or (gender ~= 'male' and gender ~= 'female') then return end

	EnsureHistoryShape(job)
	local g = UniformHistory[job][gender]
	for i=#g.history, 1, -1 do
		if g.history[i].id == id then
			table.remove(g.history, i)
		end
	end

	-- if we just deleted the active one, fall back to the most recently
	-- saved remaining entry, or the factory default if none are left
	if g.active_id == id then
		g.active_id = (#g.history > 0) and g.history[#g.history].id or nil
	end

	ApplyActiveToConfig(job)
	SaveUniformFile(job)

	TriggerClientEvent('esx:showNotification', source, ('~y~Deleted that version from the %s %s history.'):format(gender, Config.JobLabels[job] or job))
end)
