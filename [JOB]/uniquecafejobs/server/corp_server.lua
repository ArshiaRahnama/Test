--[[
	Server side for the 4 holding jobs. Each of the 17 businesses has a fixed
	owning holding (the `Holding` field on it in shared/cafes.lua). Every
	holding gets the SAME generic management toolkit over ONLY the
	businesses it owns - Portfolio Dashboard, Rank Up, Manage Staff,
	Open/Close, Rename. Blacktide/CrateCarry additionally keep their own
	special mechanic (laundering / wholesale) further down this file, which
	works across all 17 businesses regardless of who owns them.
]]

for _, holding in pairs({ Corp.Meridian, Corp.Blacktide, Corp.CrateCarry, TurfCo }) do
	TriggerEvent('esx_society:registerSociety', holding.Job, holding.Label, 'society_' .. holding.Job, 'society_' .. holding.Job, 'society_' .. holding.Job, { type = 'public' })
end

-- Persisted, identity-based holding ownership -- the actual source of
-- truth for "who owns this holding", independent of anyone's CURRENT ESX
-- job (see ownerOf() below, which only ever compares against your
-- current job -- that's fine for day-to-day business actions, but
-- ownership itself needs to survive you switching into one of your own
-- businesses).
local HoldingOwners = {} -- holding_job -> { identifier, name }

local HoldingJobSet = {
	[Corp.Meridian.Job] = true, [Corp.Blacktide.Job] = true, [Corp.CrateCarry.Job] = true, [TurfCo.Job] = true,
}

local function setHoldingOwner(job, identifier, name)
	HoldingOwners[job] = { identifier = identifier, name = name }
	MySQL.Async.execute('REPLACE INTO holding_owner (holding_job, owner_identifier, owner_name) VALUES (@job, @id, @name)', {
		['@job'] = job, ['@id'] = identifier, ['@name'] = name,
	})
end

local function rememberHoldingJobIfLeaving(target)
	if HoldingJobSet[target.job.name] then
		MySQL.Async.execute('REPLACE INTO holding_return_job (identifier, job, grade) VALUES (@id, @job, @grade)', {
			['@id'] = target.identifier, ['@job'] = target.job.name, ['@grade'] = target.job.grade,
		})
	end
end

CreateThread(function()
	local rows = MySQL.Sync.fetchAll('SELECT * FROM holding_owner', {})
	for _, row in ipairs(rows) do
		HoldingOwners[row.holding_job] = { identifier = row.owner_identifier, name = row.owner_name }
	end

	-- Also bootstrap for anyone already online when the resource
	-- (re)starts -- esx:playerLoaded only fires on fresh login.
	for _, playerId in ipairs(GetPlayers()) do
		local xPlayer = ESX.GetPlayerFromId(tonumber(playerId))
		if xPlayer and HoldingJobSet[xPlayer.job.name] and xPlayer.job.grade == 10 and not HoldingOwners[xPlayer.job.name] then
			setHoldingOwner(xPlayer.job.name, xPlayer.identifier, xPlayer.name)
		end
	end
end)

-- Bootstrap: the very first time someone loads in already holding one of
-- the 4 holding jobs at Boss grade (10) and nobody's registered as owner
-- of it yet, they become the registered owner. After that first time,
-- ownership only ever changes via Transfer Ownership below -- someone
-- simply having the job later (e.g. after a Transfer, or an admin
-- /setjob) does NOT silently overwrite a real transfer.
AddEventHandler('esx:playerLoaded', function(source, xPlayer)
	if not xPlayer then return end
	local job = xPlayer.job.name
	if HoldingJobSet[job] and xPlayer.job.grade == 10 and not HoldingOwners[job] then
		setHoldingOwner(job, xPlayer.identifier, xPlayer.name)
	end
end)

CreateThread(function()
	local rows = MySQL.Sync.fetchAll('SELECT * FROM custom_names', {})
	for _, row in ipairs(rows) do
		CustomNames[row.entity_job] = row.custom_label
	end
end)

local function saveCustomName(entityJob, label)
	CustomNames[entityJob] = label
	MySQL.Async.execute('REPLACE INTO custom_names (entity_job, custom_label) VALUES (@job, @label)', {
		['@job'] = entityJob, ['@label'] = label,
	})
end

CreateThread(function()
	local rows = MySQL.Sync.fetchAll('SELECT * FROM business_blips', {})
	for _, row in ipairs(rows) do
		CustomBlips[row.business_job] = { sprite = row.sprite, colour = row.colour }
	end
end)

local function saveCustomBlip(entityJob, sprite, colour)
	CustomBlips[entityJob] = { sprite = sprite, colour = colour }
	MySQL.Async.execute('REPLACE INTO business_blips (business_job, sprite, colour) VALUES (@job, @sprite, @colour)', {
		['@job'] = entityJob, ['@sprite'] = sprite, ['@colour'] = colour,
	})
end

RegisterNetEvent('uniquecafejobs:corp:renameHolding')
AddEventHandler('uniquecafejobs:corp:renameHolding', function(newName)
	local src = source
	local xPlayer = ESX.GetPlayerFromId(src)
	if not xPlayer then return end

	local holding = GetHoldingConfig(xPlayer.job.name)
	if not holding then return end
	if xPlayer.job.grade_name ~= 'boss' then
		TriggerClientEvent('esx:showNotification', src, 'Only the Boss can rename this holding.')
		return
	end

	newName = tostring(newName):sub(1, 30)
	if #newName < 3 then
		TriggerClientEvent('esx:showNotification', src, 'Name must be at least 3 characters.')
		return
	end

	saveCustomName(holding.Job, newName)
	TriggerClientEvent('uniquecafejobs:corp:holdingRenamed', -1, holding.Job, newName)
	TriggerClientEvent('esx:showNotification', src, ('Holding renamed to "%s".'):format(newName))
end)

RegisterNetEvent('uniquecafejobs:corp:spawnVehicle')
AddEventHandler('uniquecafejobs:corp:spawnVehicle', function(vehicleName)
	local xPlayer = ESX.GetPlayerFromId(source)
	if not xPlayer then return end
	local holding = GetHoldingConfig(xPlayer.job.name)
	if holding and vehicleName == holding.SpawnVehicle then
		TriggerClientEvent('spawnCarClientCorp', source, vehicleName)
	end
end)

-- ══════════════════════════ Generic business ownership ══════════════════════════

local BusinessState = {}
local lastCollect = {}

local function ownerOf(businessJob)
	local cafe = GetCafeForJob(businessJob)
	return cafe and cafe.Holding or nil
end

-- ── Per-holding rank ladders ──
-- HoldingRanks[holdingJob] = { {id, label, feePercent, upgradeCost, sortOrder}, ... }
-- always kept SORTED by sortOrder ascending (index 1 = lowest/starting tier).
local HoldingRanks = {}

local function sortRanks(job)
	table.sort(HoldingRanks[job], function(a, b) return a.sortOrder < b.sortOrder end)
end

local function seedDefaultRanks(job)
	HoldingRanks[job] = {}
	for i, r in ipairs(DefaultRanks) do
		local row = { id = r.id, label = r.label, feePercent = r.feePercent, upgradeCost = r.upgradeCost, sortOrder = i }
		table.insert(HoldingRanks[job], row)
		MySQL.Async.execute('REPLACE INTO holding_ranks (holding_job, rank_id, label, fee_percent, upgrade_cost, sort_order) VALUES (@job, @id, @label, @fee, @cost, @order)', {
			['@job'] = job, ['@id'] = row.id, ['@label'] = row.label, ['@fee'] = row.feePercent, ['@cost'] = row.upgradeCost, ['@order'] = row.sortOrder,
		})
	end
end

-- Every holding's ladder is fully independent - editing/adding/removing a
-- rank on one holding (via the events further below) NEVER touches
-- another holding's HoldingRanks[otherJob] entry.
local function getHoldingRanks(job)
	return HoldingRanks[job] or {}
end

local function findRank(job, rankId)
	for _, r in ipairs(getHoldingRanks(job)) do
		if r.id == rankId then return r end
	end
	-- Rank no longer exists (holding removed it since this business was
	-- last saved) - fall back to that holding's current lowest tier.
	return getHoldingRanks(job)[1]
end

local function getNextRank(job, rankId)
	local ranks = getHoldingRanks(job)
	local current = findRank(job, rankId) -- normalizes a stale/removed rank id to the current lowest tier
	if not current then return nil end
	for i, r in ipairs(ranks) do
		if r.id == current.id then return ranks[i + 1] end
	end
	return nil
end

CreateThread(function()
	local rankRows = MySQL.Sync.fetchAll('SELECT * FROM holding_ranks', {})
	for _, row in ipairs(rankRows) do
		HoldingRanks[row.holding_job] = HoldingRanks[row.holding_job] or {}
		table.insert(HoldingRanks[row.holding_job], {
			id = row.rank_id, label = row.label, feePercent = row.fee_percent,
			upgradeCost = row.upgrade_cost, sortOrder = row.sort_order,
		})
	end
	for _, holding in pairs({ Corp.Meridian, Corp.Blacktide, Corp.CrateCarry, TurfCo }) do
		if not HoldingRanks[holding.Job] or #HoldingRanks[holding.Job] == 0 then
			seedDefaultRanks(holding.Job)
		else
			sortRanks(holding.Job)
		end
	end
end)

CreateThread(function()
	local rows = MySQL.Sync.fetchAll('SELECT * FROM meridian_portfolio', {})
	for _, row in ipairs(rows) do
		BusinessState[row.business_job] = { rank = row.rank or 'bronze' }
	end
	for _, cafe in pairs(Cafes) do
		if not BusinessState[cafe.Job] then
			BusinessState[cafe.Job] = { rank = 'bronze' }
			MySQL.Async.execute('REPLACE INTO meridian_portfolio (business_job, kind, status, rank) VALUES (@job, @kind, @status, @rank)', {
				['@job'] = cafe.Job, ['@kind'] = 'portfolio', ['@status'] = 'acquired', ['@rank'] = 'bronze',
			})
		end
	end
end)

local function saveBusinessState(job)
	local s = BusinessState[job]
	MySQL.Async.execute('REPLACE INTO meridian_portfolio (business_job, kind, status, rank) VALUES (@job, @kind, @status, @rank)', {
		['@job'] = job, ['@kind'] = 'portfolio', ['@status'] = 'acquired', ['@rank'] = s.rank,
	})
end

RegisterNetEvent('uniquecafejobs:corp:requestPortfolio')
AddEventHandler('uniquecafejobs:corp:requestPortfolio', function()
	local src = source
	local xPlayer = ESX.GetPlayerFromId(src)
	local holding = xPlayer and GetHoldingConfig(xPlayer.job.name)
	if not holding then return end

	local myJobs = {}
	for _, cafe in pairs(Cafes) do
		if cafe.Holding == holding.Job then table.insert(myJobs, cafe) end
	end

	local rows = {}
	local pending = #myJobs
	if pending == 0 then
		TriggerEvent('esx_addonaccount:getSharedAccount', 'society_' .. holding.Job, function(mAccount)
			TriggerClientEvent('uniquecafejobs:corp:showPortfolio', src, rows, false, mAccount.money)
		end)
		return
	end

	local function finish()
		TriggerEvent('esx_addonaccount:getSharedAccount', 'society_' .. holding.Job, function(mAccount)
			local canCollect = (os.time() - (lastCollect[holding.Job] or 0)) >= (holding.CollectCooldownMins * 60)
			table.sort(rows, function(a, b) return a.label < b.label end)
			TriggerClientEvent('uniquecafejobs:corp:showPortfolio', src, rows, canCollect, mAccount.money)
		end)
	end

	for _, cafe in ipairs(myJobs) do
		TriggerEvent('esx_addonaccount:getSharedAccount', 'society_' .. cafe.Job, function(account)
			local state = BusinessState[cafe.Job]
			local tag = findRank(holding.Job, state.rank).label
			table.insert(rows, { label = ('%s [%s]'):format(GetDisplayLabel(cafe.Job, cafe.Label), tag), balance = account.money })
			pending = pending - 1
			if pending == 0 then finish() end
		end)
	end
end)

RegisterNetEvent('uniquecafejobs:corp:collectFranchiseFee')
AddEventHandler('uniquecafejobs:corp:collectFranchiseFee', function()
	local src = source
	local xPlayer = ESX.GetPlayerFromId(src)
	local holding = xPlayer and GetHoldingConfig(xPlayer.job.name)
	if not holding then return end

	if (os.time() - (lastCollect[holding.Job] or 0)) < (holding.CollectCooldownMins * 60) then
		TriggerClientEvent('esx:showNotification', src, 'Franchise fee already collected recently.')
		return
	end
	lastCollect[holding.Job] = os.time()

	local collectedFrom = 0
	for _, cafe in pairs(Cafes) do
		if cafe.Holding == holding.Job then
			collectedFrom = collectedFrom + 1
			local feePercent = findRank(holding.Job, BusinessState[cafe.Job].rank).feePercent
			TriggerEvent('esx_addonaccount:getSharedAccount', 'society_' .. cafe.Job, function(account)
				local fee = math.floor(account.money * feePercent / 100)
				if fee > 0 then
					account.removeMoney(fee)
					TriggerEvent('esx_addonaccount:getSharedAccount', 'society_' .. holding.Job, function(hAccount)
						hAccount.addMoney(fee)
					end)
				end
			end)
		end
	end

	TriggerClientEvent('esx:showNotification', src, ('Franchise fees collected from %d businesses.'):format(collectedFrom))
	if collectedFrom > 0 then
		TriggerEvent('quest-cafe:collectfee')
	end
end)

RegisterNetEvent('uniquecafejobs:corp:requestManagePortfolio')
AddEventHandler('uniquecafejobs:corp:requestManagePortfolio', function()
	local src = source
	local xPlayer = ESX.GetPlayerFromId(src)
	local holding = xPlayer and GetHoldingConfig(xPlayer.job.name)
	if not holding then return end

	local rows = {}
	for _, cafe in pairs(Cafes) do
		if cafe.Holding == holding.Job then
			local state = BusinessState[cafe.Job]
			local current = findRank(holding.Job, state.rank)
			local nextRank = getNextRank(holding.Job, current.id)
			table.insert(rows, {
				job = cafe.Job,
				label = GetDisplayLabel(cafe.Job, cafe.Label),
				rankLabel = current.label,
				maxed = nextRank == nil,
				nextLabel = nextRank and nextRank.label or nil,
				nextCost  = nextRank and nextRank.upgradeCost or nil,
			})
		end
	end
	table.sort(rows, function(a, b) return a.label < b.label end)
	TriggerClientEvent('uniquecafejobs:corp:showManagePortfolio', src, rows)
end)

RegisterNetEvent('uniquecafejobs:corp:upgradeBusiness')
AddEventHandler('uniquecafejobs:corp:upgradeBusiness', function(job)
	local src = source
	local xPlayer = ESX.GetPlayerFromId(src)
	if not xPlayer then return end
	if xPlayer.job.grade < 5 then
		TriggerClientEvent('esx:showNotification', src, 'Director rank or higher required.')
		return
	end
	if ownerOf(job) ~= xPlayer.job.name then return end

	local state = BusinessState[job]
	local nextRank = getNextRank(xPlayer.job.name, state.rank)
	if not nextRank then
		TriggerClientEvent('esx:showNotification', src, 'Already at the top rank.')
		return
	end

	TriggerEvent('esx_addonaccount:getSharedAccount', 'society_' .. xPlayer.job.name, function(account)
		if account.money < nextRank.upgradeCost then
			TriggerClientEvent('esx:showNotification', src, 'Not enough money in your holding account.')
			return
		end
		account.removeMoney(nextRank.upgradeCost)
		state.rank = nextRank.id
		saveBusinessState(job)
		TriggerClientEvent('esx:showNotification', src, ('Upgraded to %s rank.'):format(nextRank.label))
		TriggerEvent('quest-cafe:upgrade')
	end)
end)

-- ══════════════════════════ Manage Ranks (Owner only) ══════════════════════════
-- Each holding's Owner (grade_name == 'boss') can freely add, edit and
-- remove tiers on THEIR OWN rank ladder. This only ever reads/writes
-- HoldingRanks[xPlayer.job.name] - it is structurally impossible for one
-- holding's owner to touch another holding's ladder, since every handler
-- below keys exclusively off the caller's own job.

local function slugifyRankId(job, label)
	local base = label:lower():gsub('[^%w]+', '_'):gsub('^_+', ''):gsub('_+$', '')
	if base == '' then base = 'rank' end
	local id, n = base, 1
	while findRank(job, id) and findRank(job, id).id == id do
		n = n + 1
		id = base .. '_' .. n
	end
	return id
end

RegisterNetEvent('uniquecafejobs:corp:requestManageRanks')
AddEventHandler('uniquecafejobs:corp:requestManageRanks', function()
	local src = source
	local xPlayer = ESX.GetPlayerFromId(src)
	if not xPlayer or not GetHoldingConfig(xPlayer.job.name) then return end
	if xPlayer.job.grade_name ~= 'boss' then
		TriggerClientEvent('esx:showNotification', src, 'Only the Owner can manage ranks.')
		return
	end

	local ranks = getHoldingRanks(xPlayer.job.name)
	local rows = {}
	for _, r in ipairs(ranks) do
		local inUse = 0
		for _, cafe in pairs(Cafes) do
			if cafe.Holding == xPlayer.job.name and BusinessState[cafe.Job].rank == r.id then
				inUse = inUse + 1
			end
		end
		table.insert(rows, {
			id = r.id, label = r.label, feePercent = r.feePercent, upgradeCost = r.upgradeCost,
			businessCount = inUse, isOnly = #ranks == 1,
		})
	end
	TriggerClientEvent('uniquecafejobs:corp:showManageRanks', src, rows)
end)

RegisterNetEvent('uniquecafejobs:corp:addRank')
AddEventHandler('uniquecafejobs:corp:addRank', function(label, feePercent, upgradeCost)
	local src = source
	local xPlayer = ESX.GetPlayerFromId(src)
	if not xPlayer or not GetHoldingConfig(xPlayer.job.name) then return end
	if xPlayer.job.grade_name ~= 'boss' then return end

	local job = xPlayer.job.name
	local ranks = getHoldingRanks(job)
	if #ranks >= 10 then
		TriggerClientEvent('esx:showNotification', src, 'Max 10 ranks per holding.')
		return
	end

	label = tostring(label or ''):sub(1, 20)
	if #label < 2 then
		TriggerClientEvent('esx:showNotification', src, 'Label must be at least 2 characters.')
		return
	end

	feePercent = tonumber(feePercent)
	upgradeCost = tonumber(upgradeCost)
	if not feePercent or feePercent < 0 or feePercent > 100 then
		TriggerClientEvent('esx:showNotification', src, 'Fee % must be between 0 and 100.')
		return
	end
	if not upgradeCost or upgradeCost < 0 then
		TriggerClientEvent('esx:showNotification', src, 'Upgrade cost must be 0 or more.')
		return
	end

	-- New ranks are always appended as the new TOP tier - the natural way
	-- to grow a ladder ("what does it take to go even further than Gold?").
	local maxOrder = 0
	for _, r in ipairs(ranks) do maxOrder = math.max(maxOrder, r.sortOrder) end

	local newRank = {
		id = slugifyRankId(job, label), label = label,
		feePercent = math.floor(feePercent), upgradeCost = math.floor(upgradeCost),
		sortOrder = maxOrder + 1,
	}
	table.insert(HoldingRanks[job], newRank)

	MySQL.Async.execute('REPLACE INTO holding_ranks (holding_job, rank_id, label, fee_percent, upgrade_cost, sort_order) VALUES (@job, @id, @label, @fee, @cost, @order)', {
		['@job'] = job, ['@id'] = newRank.id, ['@label'] = newRank.label,
		['@fee'] = newRank.feePercent, ['@cost'] = newRank.upgradeCost, ['@order'] = newRank.sortOrder,
	})

	TriggerClientEvent('esx:showNotification', src, ('New rank "%s" added.'):format(newRank.label))
end)

RegisterNetEvent('uniquecafejobs:corp:editRank')
AddEventHandler('uniquecafejobs:corp:editRank', function(rankId, feePercent, upgradeCost)
	local src = source
	local xPlayer = ESX.GetPlayerFromId(src)
	if not xPlayer or not GetHoldingConfig(xPlayer.job.name) then return end
	if xPlayer.job.grade_name ~= 'boss' then return end

	local job = xPlayer.job.name
	local rank = findRank(job, rankId)
	if not rank or rank.id ~= rankId then
		TriggerClientEvent('esx:showNotification', src, 'That rank no longer exists.')
		return
	end

	feePercent = tonumber(feePercent)
	upgradeCost = tonumber(upgradeCost)
	if not feePercent or feePercent < 0 or feePercent > 100 then
		TriggerClientEvent('esx:showNotification', src, 'Fee % must be between 0 and 100.')
		return
	end
	if not upgradeCost or upgradeCost < 0 then
		TriggerClientEvent('esx:showNotification', src, 'Upgrade cost must be 0 or more.')
		return
	end

	rank.feePercent = math.floor(feePercent)
	rank.upgradeCost = math.floor(upgradeCost)

	MySQL.Async.execute('UPDATE holding_ranks SET fee_percent = @fee, upgrade_cost = @cost WHERE holding_job = @job AND rank_id = @id', {
		['@job'] = job, ['@id'] = rank.id, ['@fee'] = rank.feePercent, ['@cost'] = rank.upgradeCost,
	})

	TriggerClientEvent('esx:showNotification', src, ('"%s" updated (%d%% fee, $%d to reach).'):format(rank.label, rank.feePercent, rank.upgradeCost))
end)

RegisterNetEvent('uniquecafejobs:corp:removeRank')
AddEventHandler('uniquecafejobs:corp:removeRank', function(rankId)
	local src = source
	local xPlayer = ESX.GetPlayerFromId(src)
	if not xPlayer or not GetHoldingConfig(xPlayer.job.name) then return end
	if xPlayer.job.grade_name ~= 'boss' then return end

	local job = xPlayer.job.name
	local ranks = getHoldingRanks(job)
	if #ranks <= 1 then
		TriggerClientEvent('esx:showNotification', src, 'A holding must always keep at least 1 rank.')
		return
	end

	local removeIndex
	for i, r in ipairs(ranks) do
		if r.id == rankId then removeIndex = i break end
	end
	if not removeIndex then
		TriggerClientEvent('esx:showNotification', src, 'That rank no longer exists.')
		return
	end

	-- Any business currently sitting on the removed rank gets bumped down
	-- to the tier right below it (or, if Bronze itself is what's being
	-- removed, to the new lowest tier) - never left pointing at a rank
	-- that no longer exists.
	local removedId = ranks[removeIndex].id
	local fallback = ranks[removeIndex - 1] or ranks[removeIndex + 1]
	local reassigned = 0
	for _, cafe in pairs(Cafes) do
		if cafe.Holding == job and BusinessState[cafe.Job].rank == removedId then
			BusinessState[cafe.Job].rank = fallback.id
			saveBusinessState(cafe.Job)
			reassigned = reassigned + 1
		end
	end

	table.remove(ranks, removeIndex)
	MySQL.Async.execute('DELETE FROM holding_ranks WHERE holding_job = @job AND rank_id = @id', {
		['@job'] = job, ['@id'] = removedId,
	})

	local msg = 'Rank removed.'
	if reassigned > 0 then
		msg = ('Rank removed. %d business(es) moved to "%s".'):format(reassigned, fallback.label)
	end
	TriggerClientEvent('esx:showNotification', src, msg)
end)

RegisterNetEvent('uniquecafejobs:corp:requestOwnedBusinessList')
AddEventHandler('uniquecafejobs:corp:requestOwnedBusinessList', function()
	local src = source
	local xPlayer = ESX.GetPlayerFromId(src)
	local holding = xPlayer and GetHoldingConfig(xPlayer.job.name)
	if not holding then return end

	local rows = {}
	for _, cafe in pairs(Cafes) do
		if cafe.Holding == xPlayer.job.name then
			table.insert(rows, { job = cafe.Job, label = GetDisplayLabel(cafe.Job, cafe.Label) })
		end
	end
	table.sort(rows, function(a, b) return a.label < b.label end)
	TriggerClientEvent('uniquecafejobs:corp:showOwnedBusinessList', src, rows)
end)

RegisterNetEvent('uniquecafejobs:corp:selfAssignJob')
AddEventHandler('uniquecafejobs:corp:selfAssignJob', function(job)
	local src = source
	local xPlayer = ESX.GetPlayerFromId(src)
	if not xPlayer then return end
	if ownerOf(job) ~= xPlayer.job.name then return end

	if not (ESX.Jobs[job] and ESX.Jobs[job].grades[0]) then
		TriggerClientEvent('esx:showNotification', src, 'That business has no entry grade set up.')
		return
	end

	rememberHoldingJobIfLeaving(xPlayer)
	xPlayer.setJob(job, 0)
	TriggerClientEvent('esx:showNotification', src, 'You now work here. Visit your holding HQ pad to return to your holding rank.')
end)

RegisterNetEvent('uniquecafejobs:corp:requestManageStaffList')
AddEventHandler('uniquecafejobs:corp:requestManageStaffList', function()
	local src = source
	local xPlayer = ESX.GetPlayerFromId(src)
	local holding = xPlayer and GetHoldingConfig(xPlayer.job.name)
	if not holding then return end
	if xPlayer.job.grade < 5 then
		TriggerClientEvent('esx:showNotification', src, 'Director rank or higher required.')
		return
	end

	local rows = {}
	for _, cafe in pairs(Cafes) do
		if cafe.Holding == xPlayer.job.name then
			table.insert(rows, { job = cafe.Job, label = GetDisplayLabel(cafe.Job, cafe.Label) })
		end
	end
	table.sort(rows, function(a, b) return a.label < b.label end)
	TriggerClientEvent('uniquecafejobs:corp:showManageStaffList', src, rows)
end)

RegisterNetEvent('uniquecafejobs:corp:openBusinessBossMenuAsMeridian')
AddEventHandler('uniquecafejobs:corp:openBusinessBossMenuAsMeridian', function(job)
	local src = source
	local xPlayer = ESX.GetPlayerFromId(src)
	if not xPlayer or xPlayer.job.grade < 5 then return end
	if ownerOf(job) ~= xPlayer.job.name then return end

	exports['esx_society']:grantRemoteBossAccess(src, job)
	TriggerClientEvent('uniquecafejobs:corp:openRemoteBossMenu', src, job)
end)



RegisterNetEvent('uniquecafejobs:corp:transferOwnership')
AddEventHandler('uniquecafejobs:corp:transferOwnership', function(job, targetId)
	local src = source
	local xPlayer = ESX.GetPlayerFromId(src)
	if not xPlayer then return end
	if not HoldingJobSet[job] then return end

	-- SECURITY: ownership transfer requires being the REGISTERED owner,
	-- not just "currently grade 10" -- otherwise anyone an admin ever
	-- temporarily /setjob'd to boss grade could hijack ownership.
	local currentOwner = HoldingOwners[job]
	if not currentOwner or currentOwner.identifier ~= xPlayer.identifier then
		TriggerClientEvent('esx:showNotification', src, 'Only the current owner can transfer ownership.')
		return
	end

	local target = ESX.GetPlayerFromId(tonumber(targetId))
	if not target then
		TriggerClientEvent('esx:showNotification', src, 'Player not found (must be online).')
		return
	end
	if target.identifier == xPlayer.identifier then
		TriggerClientEvent('esx:showNotification', src, 'You already own this holding.')
		return
	end

	setHoldingOwner(job, target.identifier, target.name)
	target.setJob(job, 10)
	-- Demote the old owner off Boss grade so there's never two people
	-- holding grade 10 of the same holding at once. They keep Director
	-- (grade 5) so they're not locked out entirely.
	if xPlayer.job.name == job then
		xPlayer.setJob(job, 5)
	end

	TriggerClientEvent('esx:showNotification', src, ('Ownership transferred to %s.'):format(target.name))
	TriggerClientEvent('esx:showNotification', target.source, 'You are now the owner of this holding.')
end)

RegisterNetEvent('uniquecafejobs:corp:appointManager')
AddEventHandler('uniquecafejobs:corp:appointManager', function(job, targetId)
	local src = source
	local xPlayer = ESX.GetPlayerFromId(src)
	if not xPlayer or xPlayer.job.grade < 5 then return end
	if ownerOf(job) ~= xPlayer.job.name then return end

	local target = ESX.GetPlayerFromId(tonumber(targetId))
	if not target then
		TriggerClientEvent('esx:showNotification', src, 'Player not found (must be online).')
		return
	end

	rememberHoldingJobIfLeaving(target)
	target.setJob(job, 10)
	TriggerClientEvent('esx:showNotification', src, ('%s appointed as Manager (Boss) of that business.'):format(target.name))
	TriggerClientEvent('esx:showNotification', target.source, 'You have been appointed Manager (Boss) by your holding. Visit your holding HQ pad to return to your holding job.')
	TriggerEvent('quest-cafe:hire')
end)

RegisterNetEvent('uniquecafejobs:corp:setEmployeeJob')
AddEventHandler('uniquecafejobs:corp:setEmployeeJob', function(job, targetId, grade)
	local src = source
	local xPlayer = ESX.GetPlayerFromId(src)
	if not xPlayer or xPlayer.job.grade < 5 then return end
	if ownerOf(job) ~= xPlayer.job.name then return end

	local target = ESX.GetPlayerFromId(tonumber(targetId))
	if not target then
		TriggerClientEvent('esx:showNotification', src, 'Player not found (must be online).')
		return
	end

	grade = tonumber(grade)
	-- SECURITY: never trust a client-sent grade number blindly -- validate
	-- it's a real grade of this exact job (ESX.Jobs is essentialmode's own
	-- live job_grades data). An invalid grade would leave the target with
	-- grade_name == nil, silently breaking every grade_name == 'boss'
	-- check elsewhere in this resource (uniform, vehicle access, holding
	-- boss menus...).
	if not grade or not (ESX.Jobs[job] and ESX.Jobs[job].grades[grade]) then
		TriggerClientEvent('esx:showNotification', src, 'Invalid grade for that business.')
		return
	end

	rememberHoldingJobIfLeaving(target)
	local gradeLabel = ESX.Jobs[job].grades[grade].label
	target.setJob(job, grade)
	TriggerClientEvent('esx:showNotification', src, ('%s set to %s at that business.'):format(target.name, gradeLabel))
	TriggerClientEvent('esx:showNotification', target.source, ('You have been set to %s by your holding. Visit your holding HQ pad to return to your holding job.'):format(gradeLabel))
	TriggerEvent('quest-cafe:hire')
end)

RegisterNetEvent('uniquecafejobs:corp:backToHolding')
AddEventHandler('uniquecafejobs:corp:backToHolding', function()
	local src = source
	local xPlayer = ESX.GetPlayerFromId(src)
	if not xPlayer then return end

	-- 1) Are you the REGISTERED owner of a holding? Authoritative, works
	--    even if the temp holding_return_job record below was lost.
	for job, owner in pairs(HoldingOwners) do
		if owner.identifier == xPlayer.identifier then
			xPlayer.setJob(job, 10)
			TriggerClientEvent('esx:showNotification', src, 'Returned to your holding as owner.')
			return
		end
	end

	-- 2) Not an owner -- fall back to "last job before you switched away"
	--    (covers non-owner Directors too).
	MySQL.Async.fetchAll('SELECT * FROM holding_return_job WHERE identifier = @id', { ['@id'] = xPlayer.identifier }, function(rows)
		if not rows[1] then
			TriggerClientEvent('esx:showNotification', src, 'No saved holding job to return to.')
			return
		end

		local savedJob, savedGrade = rows[1].job, tonumber(rows[1].grade)
		-- SECURITY: re-validate against live ESX.Jobs, same as setEmployeeJob
		-- above -- the saved grade could be stale if job_grades changed since.
		if not (ESX.Jobs[savedJob] and ESX.Jobs[savedJob].grades[savedGrade]) then
			TriggerClientEvent('esx:showNotification', src, 'Your saved holding job/grade no longer exists.')
			return
		end

		xPlayer.setJob(savedJob, savedGrade)
		TriggerClientEvent('esx:showNotification', src, 'Returned to your holding job.')
	end)
end)



RegisterNetEvent('uniquecafejobs:corp:renameBusiness')
AddEventHandler('uniquecafejobs:corp:renameBusiness', function(job, newName)
	local src = source
	local xPlayer = ESX.GetPlayerFromId(src)
	if not xPlayer or xPlayer.job.grade < 5 then return end
	if ownerOf(job) ~= xPlayer.job.name then return end

	newName = tostring(newName):sub(1, 40)
	if #newName < 3 then
		TriggerClientEvent('esx:showNotification', src, 'Name must be at least 3 characters.')
		return
	end

	saveCustomName(job, newName)
	TriggerClientEvent('uniquecafejobs:corp:businessRenamed', -1, job, newName)
	TriggerClientEvent('esx:showNotification', src, ('Business renamed to "%s".'):format(newName))
end)

RegisterNetEvent('uniquecafejobs:corp:changeBlip')
AddEventHandler('uniquecafejobs:corp:changeBlip', function(job, sprite, colour)
	local src = source
	local xPlayer = ESX.GetPlayerFromId(src)
	if not xPlayer or xPlayer.job.grade < 5 then return end
	if ownerOf(job) ~= xPlayer.job.name then return end

	sprite = tonumber(sprite)
	colour = tonumber(colour)
	if not sprite or not colour or sprite < 0 or colour < 0 then
		TriggerClientEvent('esx:showNotification', src, 'Invalid sprite/colour ID.')
		return
	end

	saveCustomBlip(job, sprite, colour)
	TriggerClientEvent('uniquecafejobs:corp:businessBlipChanged', -1, job, sprite, colour)
	TriggerClientEvent('esx:showNotification', src, 'Blip updated for that business.')
end)

ActiveBusinesses = {}

CreateThread(function()
	local rows = MySQL.Sync.fetchAll('SELECT * FROM business_active', {})
	local saved = {}
	for _, row in ipairs(rows) do
		saved[row.business_job] = row.active == 1
	end
	for _, cafe in pairs(Cafes) do
		ActiveBusinesses[cafe.Job] = saved[cafe.Job]
		if ActiveBusinesses[cafe.Job] == nil then ActiveBusinesses[cafe.Job] = true end
	end
	TriggerClientEvent('uniquecafejobs:corp:syncActiveBusinesses', -1, ActiveBusinesses)
end)

RegisterNetEvent('uniquecafejobs:corp:requestActiveBusinesses')
AddEventHandler('uniquecafejobs:corp:requestActiveBusinesses', function()
	TriggerClientEvent('uniquecafejobs:corp:syncActiveBusinesses', source, ActiveBusinesses)
end)

RegisterNetEvent('uniquecafejobs:corp:requestBlipOverrides')
AddEventHandler('uniquecafejobs:corp:requestBlipOverrides', function()
	TriggerClientEvent('uniquecafejobs:corp:syncBlipOverrides', source, CustomBlips)
end)

RegisterNetEvent('uniquecafejobs:corp:requestToggleList')
AddEventHandler('uniquecafejobs:corp:requestToggleList', function()
	local src = source
	local xPlayer = ESX.GetPlayerFromId(src)
	if not xPlayer or xPlayer.job.grade < 5 then return end
	local holding = GetHoldingConfig(xPlayer.job.name)
	if not holding then return end

	local rows = {}
	for _, cafe in pairs(Cafes) do
		if cafe.Holding == xPlayer.job.name then
			table.insert(rows, {
				job = cafe.Job,
				label = GetDisplayLabel(cafe.Job, cafe.Label),
				active = ActiveBusinesses[cafe.Job] ~= false,
			})
		end
	end
	table.sort(rows, function(a, b) return a.label < b.label end)
	TriggerClientEvent('uniquecafejobs:corp:showToggleList', src, rows)
end)

RegisterNetEvent('uniquecafejobs:corp:toggleBusinessActive')
AddEventHandler('uniquecafejobs:corp:toggleBusinessActive', function(job)
	local src = source
	local xPlayer = ESX.GetPlayerFromId(src)
	if not xPlayer or xPlayer.job.grade < 5 then return end
	if ownerOf(job) ~= xPlayer.job.name then return end

	local newState = not (ActiveBusinesses[job] ~= false)
	ActiveBusinesses[job] = newState

	MySQL.Async.execute('REPLACE INTO business_active (business_job, active) VALUES (@job, @active)', {
		['@job'] = job, ['@active'] = newState and 1 or 0,
	})

	TriggerClientEvent('uniquecafejobs:corp:syncActiveBusinesses', -1, ActiveBusinesses)
	local label = GetDisplayLabel(job, GetCafeForJob(job).Label)
	TriggerClientEvent('esx:showNotification', src, ('%s is now %s.'):format(label, newState and 'OPEN' or 'CLOSED'))
end)
-- ══════════════════════════ Blacktide Logistics (laundering) ══════════════════════════

local lastWash = {} -- [identifier] = os.time()

RegisterNetEvent('uniquecafejobs:corp:launder')
AddEventHandler('uniquecafejobs:corp:launder', function(businessJob)
	local src = source
	local xPlayer = ESX.GetPlayerFromId(src)
	if not xPlayer or xPlayer.job.name ~= Corp.Blacktide.Job then return end
	if not GetCafeForJob(businessJob) then return end

	local now = os.time()
	if lastWash[xPlayer.identifier] and (now - lastWash[xPlayer.identifier]) < Corp.Blacktide.CooldownSeconds then
		local wait = Corp.Blacktide.CooldownSeconds - (now - lastWash[xPlayer.identifier])
		TriggerClientEvent('esx:showNotification', src, ('Bayad %d sanie sabr konid.'):format(wait))
		return
	end

	local dirty = xPlayer.getAccount('black_money').money
	if dirty <= 0 then
		TriggerClientEvent('esx:showNotification', src, 'Pool kasif (black_money) nadarid.')
		return
	end

	local amount = math.min(dirty, Corp.Blacktide.MaxPerWash)
	xPlayer.removeAccountMoney('black_money', amount)

	local blacktideCut = math.floor(amount * Corp.Blacktide.LaunderCutPercent / 100)
	local businessCut  = math.floor(amount * Corp.Blacktide.BusinessCutPercent / 100)

	TriggerEvent('esx_addonaccount:getSharedAccount', 'society_' .. Corp.Blacktide.Job, function(account)
		account.addMoney(blacktideCut)
	end)
	TriggerEvent('esx_addonaccount:getSharedAccount', 'society_' .. businessJob, function(account)
		account.addMoney(businessCut)
	end)

	lastWash[xPlayer.identifier] = now
	TriggerClientEvent('esx:showNotification', src, ('Shoma $%d pool kasif shostid, Blacktide $%d gereft.'):format(amount, blacktideCut))
	TriggerEvent('quest-cafe:launder')
end)

-- ══════════════════════════ Crate & Carry (wholesale + resale) ══════════════════════════

RegisterNetEvent('uniquecafejobs:corp:openWholesaleMenu')
AddEventHandler('uniquecafejobs:corp:openWholesaleMenu', function(businessJob)
	local src = source
	local xPlayer = ESX.GetPlayerFromId(src)
	if not xPlayer or xPlayer.job.name ~= Corp.CrateCarry.Job then return end
	local cafe = GetCafeForJob(businessJob)
	if not cafe then return end

	TriggerEvent('esx_addoninventory:getSharedInventory', 'society_' .. businessJob, function(inventory)
		local stock = {}
		if inventory then
			for _, v in pairs(inventory.items) do
				if v.count > 0 then
					table.insert(stock, { name = v.name, label = v.label, count = v.count })
				end
			end
		end
		TriggerClientEvent('uniquecafejobs:corp:showWholesaleMenu', src, businessJob, GetDisplayLabel(cafe.Job, cafe.Label), stock)
	end)
end)

RegisterNetEvent('uniquecafejobs:corp:buyWholesale')
AddEventHandler('uniquecafejobs:corp:buyWholesale', function(businessJob, itemName, quantity)
	local src = source
	local xPlayer = ESX.GetPlayerFromId(src)
	if not xPlayer or xPlayer.job.name ~= Corp.CrateCarry.Job then return end
	if not GetCafeForJob(businessJob) then return end

	quantity = tonumber(quantity)
	if not quantity or quantity <= 0 or quantity > Corp.CrateCarry.WholesaleBuyLimit then
		TriggerClientEvent('esx:showNotification', src, 'Meghdar motabar nist.')
		return
	end

	local cost = quantity * Corp.CrateCarry.WholesaleUnitPrice

	TriggerEvent('esx_addonaccount:getSharedAccount', 'society_' .. Corp.CrateCarry.Job, function(buyerAccount)
		if buyerAccount.money < cost then
			TriggerClientEvent('esx:showNotification', src, 'Pool sosayeti Crate & Carry kafi nist.')
			return
		end

		TriggerEvent('esx_addoninventory:getSharedInventory', 'society_' .. businessJob, function(sourceInv)
			local sourceItem = sourceInv.getItem(itemName)
			if not sourceItem or sourceItem.count < quantity then
				TriggerClientEvent('esx:showNotification', src, 'In meghdar dar anbar mojood nist.')
				return
			end

			sourceInv.removeItem(itemName, quantity)
			buyerAccount.removeMoney(cost)

			TriggerEvent('esx_addonaccount:getSharedAccount', 'society_' .. businessJob, function(businessAccount)
				businessAccount.addMoney(cost)
			end)

			TriggerEvent('esx_addoninventory:getSharedInventory', 'society_' .. Corp.CrateCarry.Job, function(myInv)
				myInv.addItem(itemName, quantity)
			end)

			TriggerClientEvent('esx:showNotification', src, ('%d x %s kharidari shod.'):format(quantity, sourceItem.label))
			TriggerEvent('quest-cafe:wholesale')
		end)
	end)
end)

RegisterNetEvent('uniquecafejobs:corp:openResaleShop')
AddEventHandler('uniquecafejobs:corp:openResaleShop', function()
	local src = source
	TriggerEvent('esx_addoninventory:getSharedInventory', 'society_' .. Corp.CrateCarry.Job, function(inventory)
		local stock = {}
		if inventory then
			for _, v in pairs(inventory.items) do
				if v.count > 0 then
					table.insert(stock, {
						name  = v.name,
						label = v.label,
						count = v.count,
						price = math.ceil(Corp.CrateCarry.WholesaleUnitPrice * Corp.CrateCarry.Markup),
					})
				end
			end
		end
		TriggerClientEvent('uniquecafejobs:corp:showResaleShop', src, stock)
	end)
end)

RegisterNetEvent('uniquecafejobs:corp:buyResale')
AddEventHandler('uniquecafejobs:corp:buyResale', function(itemName)
	local src = source
	local xPlayer = ESX.GetPlayerFromId(src)
	if not xPlayer then return end

	local price = math.ceil(Corp.CrateCarry.WholesaleUnitPrice * Corp.CrateCarry.Markup)

	if xPlayer.getMoney() < price then
		TriggerClientEvent('esx:showNotification', src, 'Pool kafi nadarid.')
		return
	end

	TriggerEvent('esx_addoninventory:getSharedInventory', 'society_' .. Corp.CrateCarry.Job, function(inventory)
		local item = inventory.getItem(itemName)
		if not item or item.count < 1 then
			TriggerClientEvent('esx:showNotification', src, 'Faroosh shode, mojood nist.')
			return
		end

		local playerItem = xPlayer.getInventoryItem(itemName)
		if playerItem.limit ~= -1 and (playerItem.count + 1) > playerItem.limit then
			TriggerClientEvent('esx:showNotification', src, 'Nemitavanid bishtar az in negah darid.')
			return
		end

		xPlayer.removeMoney(price)
		inventory.removeItem(itemName, 1)
		xPlayer.addInventoryItem(itemName, 1)

		TriggerEvent('esx_addonaccount:getSharedAccount', 'society_' .. Corp.CrateCarry.Job, function(account)
			account.addMoney(price)
		end)

		TriggerClientEvent('esx:showNotification', src, ('Shoma %s ro kharidid.'):format(item.label))
		TriggerEvent('quest-cafe:resale')
	end)
end)
