--[[
	Server side for the 3 corp jobs sitting on top of the 17 businesses.
	See shared/corp.lua for the numbers (cuts, cooldowns, markup).
]]

for _, corp in pairs({ Corp.Meridian, Corp.Blacktide, Corp.CrateCarry }) do
	TriggerEvent('esx_society:registerSociety', corp.Job, corp.Label, 'society_' .. corp.Job, 'society_' .. corp.Job, 'society_' .. corp.Job, { type = 'public' })
end

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

-- A holding's own top-grade Boss can rename their holding.
RegisterNetEvent('uniquecafejobs:corp:renameHolding')
AddEventHandler('uniquecafejobs:corp:renameHolding', function(newName)
	local src = source
	local xPlayer = ESX.GetPlayerFromId(src)
	if not xPlayer then return end

	local holding
	if xPlayer.job.name == Corp.Meridian.Job then holding = Corp.Meridian
	elseif xPlayer.job.name == Corp.Blacktide.Job then holding = Corp.Blacktide
	elseif xPlayer.job.name == Corp.CrateCarry.Job then holding = Corp.CrateCarry
	elseif xPlayer.job.name == TurfCo.Job then holding = TurfCo
	end
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
	if xPlayer.job.name == Corp.Meridian.Job and vehicleName == Corp.Meridian.SpawnVehicle then
		TriggerClientEvent('spawnCarClientCorp', source, vehicleName)
	elseif xPlayer.job.name == Corp.Blacktide.Job and vehicleName == Corp.Blacktide.SpawnVehicle then
		TriggerClientEvent('spawnCarClientCorp', source, vehicleName)
	elseif xPlayer.job.name == Corp.CrateCarry.Job and vehicleName == Corp.CrateCarry.SpawnVehicle then
		TriggerClientEvent('spawnCarClientCorp', source, vehicleName)
	end
end)

-- ══════════════════════════ Meridian Holdings ══════════════════════════

local lastFranchiseCollect = 0 -- os.time() of the last successful collection, server-wide

-- business_job -> { kind = 'portfolio'|'vip', status = 'acquired'|'partnered', rank = 'bronze'|'silver'|'gold' }
local MeridianState = {}

CreateThread(function()
	local rows = MySQL.Sync.fetchAll('SELECT * FROM meridian_portfolio', {})
	for _, row in ipairs(rows) do
		MeridianState[row.business_job] = { kind = row.kind, status = row.status, rank = row.rank }
	end

	-- Holding 1 owns all 17 businesses by default - anything not already
	-- saved (first run, or a business added after the fact) is seeded as an
	-- acquired Bronze-rank subsidiary and persisted right away.
	for _, job in ipairs(Corp.Meridian.PortfolioJobs) do
		if not MeridianState[job] then
			MeridianState[job] = { kind = 'portfolio', status = 'acquired', rank = 'bronze' }
			MySQL.Async.execute('REPLACE INTO meridian_portfolio (business_job, kind, status, rank) VALUES (@job, @kind, @status, @rank)', {
				['@job'] = job, ['@kind'] = 'portfolio', ['@status'] = 'acquired', ['@rank'] = 'bronze',
			})
		end
	end
	for _, job in ipairs(Corp.Meridian.VIPJobs) do
		if not MeridianState[job] then
			MeridianState[job] = { kind = 'vip', status = 'partnered', rank = nil }
			MySQL.Async.execute('REPLACE INTO meridian_portfolio (business_job, kind, status, rank) VALUES (@job, @kind, @status, @rank)', {
				['@job'] = job, ['@kind'] = 'vip', ['@status'] = 'partnered', ['@rank'] = nil,
			})
		end
	end

	local owned = {}
	for job, state in pairs(MeridianState) do
		if state.status == 'acquired' or state.status == 'partnered' then
			owned[job] = true
		end
	end
	TriggerClientEvent('uniquecafejobs:corp:syncMeridianOwnedJobs', -1, owned)
end)

local function saveMeridianState(job)
	local s = MeridianState[job]
	MySQL.Async.execute('REPLACE INTO meridian_portfolio (business_job, kind, status, rank) VALUES (@job, @kind, @status, @rank)', {
		['@job'] = job, ['@kind'] = s.kind, ['@status'] = s.status, ['@rank'] = s.rank,
	})
	broadcastMeridianOwnedJobs()
end

-- Lets Meridian members physically walk up to ANY owned/partnered business's
-- own Boss Action marker and use it (see the extra markers added in
-- client/corp_client.lua) - not just remotely from Meridian's own HQ.
function broadcastMeridianOwnedJobs()
	local owned = {}
	for job, state in pairs(MeridianState) do
		if state.status == 'acquired' or state.status == 'partnered' then
			owned[job] = true
		end
	end
	TriggerClientEvent('uniquecafejobs:corp:syncMeridianOwnedJobs', -1, owned)
end

RegisterNetEvent('uniquecafejobs:corp:requestMeridianOwnedJobs')
AddEventHandler('uniquecafejobs:corp:requestMeridianOwnedJobs', function()
	local owned = {}
	for job, state in pairs(MeridianState) do
		if state.status == 'acquired' or state.status == 'partnered' then
			owned[job] = true
		end
	end
	TriggerClientEvent('uniquecafejobs:corp:syncMeridianOwnedJobs', source, owned)
end)

local function rankData(rankId)
	for _, r in ipairs(Corp.Meridian.Ranks) do
		if r.id == rankId then return r end
	end
	return Corp.Meridian.Ranks[1]
end

RegisterNetEvent('uniquecafejobs:corp:requestPortfolio')
AddEventHandler('uniquecafejobs:corp:requestPortfolio', function()
	local src = source
	local xPlayer = ESX.GetPlayerFromId(src)
	if not xPlayer or xPlayer.job.name ~= Corp.Meridian.Job then return end

	local rows = {}
	local pending = 0
	for _, cafe in pairs(Cafes) do pending = pending + 1 end

	local function finish()
		TriggerEvent('esx_addonaccount:getSharedAccount', 'society_' .. Corp.Meridian.Job, function(mAccount)
			local canCollect = (os.time() - lastFranchiseCollect) >= (Corp.Meridian.CollectCooldownMins * 60)
			table.sort(rows, function(a, b) return a.label < b.label end)
			TriggerClientEvent('uniquecafejobs:corp:showPortfolio', src, rows, canCollect, mAccount.money)
		end)
	end

	for _, cafe in pairs(Cafes) do
		TriggerEvent('esx_addonaccount:getSharedAccount', 'society_' .. cafe.Job, function(account)
			local state = MeridianState[cafe.Job]
			local tag = 'Unaffiliated'
			if state and state.status == 'acquired' then
				tag = rankData(state.rank).label .. ' Portfolio'
			elseif state and state.status == 'partnered' then
				tag = 'VIP Partner'
			end
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
	if not xPlayer or xPlayer.job.name ~= Corp.Meridian.Job then return end

	if (os.time() - lastFranchiseCollect) < (Corp.Meridian.CollectCooldownMins * 60) then
		TriggerClientEvent('esx:showNotification', src, 'Franchise fee already collected recently.')
		return
	end
	lastFranchiseCollect = os.time()

	local collectedFrom = 0
	for job, state in pairs(MeridianState) do
		local feePercent = nil
		if state.status == 'acquired' then
			feePercent = rankData(state.rank).feePercent
		elseif state.status == 'partnered' then
			feePercent = Corp.Meridian.VIPFeePercent
		end

		if feePercent then
			collectedFrom = collectedFrom + 1
			TriggerEvent('esx_addonaccount:getSharedAccount', 'society_' .. job, function(account)
				local fee = math.floor(account.money * feePercent / 100)
				if fee > 0 then
					account.removeMoney(fee)
					TriggerEvent('esx_addonaccount:getSharedAccount', 'society_' .. Corp.Meridian.Job, function(mAccount)
						mAccount.addMoney(fee)
					end)
				end
			end)
		end
	end

	TriggerClientEvent('esx:showNotification', src, ('Franchise fees collected from %d affiliated businesses.'):format(collectedFrom))
	TriggerEvent('DiscordBot:ToDiscord', 'amoney', 'FranchiseFeeLog', '```css\n[ Player : '..GetPlayerName(src)..'(' .. src .. ') ]\n[ Player Steam : '..xPlayer.identifier..' ]\n[ Businesses Collected From : '..tostring(collectedFrom)..' ]\n```', 'user', true, src, false)
end)

-- ── Manage Portfolio (acquire / upgrade rank) ──

RegisterNetEvent('uniquecafejobs:corp:requestManagePortfolio')
AddEventHandler('uniquecafejobs:corp:requestManagePortfolio', function()
	local src = source
	local xPlayer = ESX.GetPlayerFromId(src)
	if not xPlayer or xPlayer.job.name ~= Corp.Meridian.Job then return end

	local rows = {}
	for _, job in ipairs(Corp.Meridian.PortfolioJobs) do
		local cafe = GetCafeForJob(job)
		local state = MeridianState[job]
		table.insert(rows, {
			job = job,
			label = cafe and GetDisplayLabel(cafe.Job, cafe.Label) or job,
			acquired = state ~= nil and state.status == 'acquired',
			rank = state and state.rank or nil,
		})
	end
	TriggerClientEvent('uniquecafejobs:corp:showManagePortfolio', src, rows)
end)

RegisterNetEvent('uniquecafejobs:corp:acquireBusiness')
AddEventHandler('uniquecafejobs:corp:acquireBusiness', function(job)
	local src = source
	local xPlayer = ESX.GetPlayerFromId(src)
	if not xPlayer or xPlayer.job.name ~= Corp.Meridian.Job then return end
	if not GetCafeForJob(job) then return end
	local isPortfolioJob = false
	for _, j in ipairs(Corp.Meridian.PortfolioJobs) do if j == job then isPortfolioJob = true end end
	if not isPortfolioJob then return end
	if MeridianState[job] and MeridianState[job].status == 'acquired' then return end

	TriggerEvent('esx_addonaccount:getSharedAccount', 'society_' .. Corp.Meridian.Job, function(account)
		if account.money < Corp.Meridian.AcquireCost then
			TriggerClientEvent('esx:showNotification', src, 'Pool sosayeti Meridian kafi nist.')
			return
		end
		account.removeMoney(Corp.Meridian.AcquireCost)
		MeridianState[job] = { kind = 'portfolio', status = 'acquired', rank = 'bronze' }
		saveMeridianState(job)
		TriggerClientEvent('esx:showNotification', src, 'Business acquired at Bronze rank.')
	end)
end)

RegisterNetEvent('uniquecafejobs:corp:upgradeBusiness')
AddEventHandler('uniquecafejobs:corp:upgradeBusiness', function(job)
	local src = source
	local xPlayer = ESX.GetPlayerFromId(src)
	if not xPlayer or xPlayer.job.name ~= Corp.Meridian.Job then return end

	local state = MeridianState[job]
	if not state or state.status ~= 'acquired' then return end

	local currentIndex
	for i, r in ipairs(Corp.Meridian.Ranks) do
		if r.id == state.rank then currentIndex = i end
	end
	local nextRank = Corp.Meridian.Ranks[currentIndex + 1]
	if not nextRank then
		TriggerClientEvent('esx:showNotification', src, 'Already at max rank (Gold).')
		return
	end

	TriggerEvent('esx_addonaccount:getSharedAccount', 'society_' .. Corp.Meridian.Job, function(account)
		if account.money < nextRank.upgradeCost then
			TriggerClientEvent('esx:showNotification', src, 'Pool sosayeti Meridian kafi nist.')
			return
		end
		account.removeMoney(nextRank.upgradeCost)
		state.rank = nextRank.id
		saveMeridianState(job)
		TriggerClientEvent('esx:showNotification', src, ('Upgraded to %s rank.'):format(nextRank.label))
	end)
end)

-- ── VIP Partnerships ──

RegisterNetEvent('uniquecafejobs:corp:requestVIPPartnerships')
AddEventHandler('uniquecafejobs:corp:requestVIPPartnerships', function()
	local src = source
	local xPlayer = ESX.GetPlayerFromId(src)
	if not xPlayer or xPlayer.job.name ~= Corp.Meridian.Job then return end

	local rows = {}
	for _, job in ipairs(Corp.Meridian.VIPJobs) do
		local cafe = GetCafeForJob(job)
		local state = MeridianState[job]
		table.insert(rows, {
			job = job,
			label = cafe and GetDisplayLabel(cafe.Job, cafe.Label) or job,
			partnered = state ~= nil and state.status == 'partnered',
		})
	end
	TriggerClientEvent('uniquecafejobs:corp:showVIPPartnerships', src, rows)
end)

RegisterNetEvent('uniquecafejobs:corp:signVIPPartnership')
AddEventHandler('uniquecafejobs:corp:signVIPPartnership', function(job)
	local src = source
	local xPlayer = ESX.GetPlayerFromId(src)
	if not xPlayer or xPlayer.job.name ~= Corp.Meridian.Job then return end
	local isVIPJob = false
	for _, j in ipairs(Corp.Meridian.VIPJobs) do if j == job then isVIPJob = true end end
	if not isVIPJob then return end
	if MeridianState[job] and MeridianState[job].status == 'partnered' then return end

	TriggerEvent('esx_addonaccount:getSharedAccount', 'society_' .. Corp.Meridian.Job, function(account)
		if account.money < Corp.Meridian.VIPPartnershipCost then
			TriggerClientEvent('esx:showNotification', src, 'Pool sosayeti Meridian kafi nist.')
			return
		end
		account.removeMoney(Corp.Meridian.VIPPartnershipCost)
		MeridianState[job] = { kind = 'vip', status = 'partnered', rank = nil }
		saveMeridianState(job)
		TriggerClientEvent('esx:showNotification', src, 'VIP partnership signed - 15% flat cut from now on.')
	end)
end)

-- ── Manage Business Staff (Director+ only, i.e. grade >= 2) ──
-- Only businesses Meridian actually owns (acquired portfolio) or has a VIP
-- partnership with show up here - unaffiliated businesses are completely
-- off limits, their own Boss keeps 100% independent control.

local function isMeridianAffiliated(job)
	local s = MeridianState[job]
	return s ~= nil and (s.status == 'acquired' or s.status == 'partnered')
end

RegisterNetEvent('uniquecafejobs:corp:requestManageStaffList')
AddEventHandler('uniquecafejobs:corp:requestManageStaffList', function()
	local src = source
	local xPlayer = ESX.GetPlayerFromId(src)
	if not xPlayer or xPlayer.job.name ~= Corp.Meridian.Job then return end
	if xPlayer.job.grade < 5 then
		TriggerClientEvent('esx:showNotification', src, 'Director rank or higher required.')
		return
	end

	local rows = {}
	for job, state in pairs(MeridianState) do
		if state.status == 'acquired' or state.status == 'partnered' then
			local cafe = GetCafeForJob(job)
			table.insert(rows, { job = job, label = cafe and GetDisplayLabel(cafe.Job, cafe.Label) or job })
		end
	end
	TriggerClientEvent('uniquecafejobs:corp:showManageStaffList', src, rows)
end)

-- Opens that business's REAL boss menu (same hire/fire/grade/uniform/vehicle
-- system its own Boss uses) - Meridian is just a second entry point into the
-- exact same esx_society data, not a separate parallel system.
RegisterNetEvent('uniquecafejobs:corp:openBusinessBossMenuAsMeridian')
AddEventHandler('uniquecafejobs:corp:openBusinessBossMenuAsMeridian', function(job)
	local src = source
	local xPlayer = ESX.GetPlayerFromId(src)
	if not xPlayer or xPlayer.job.name ~= Corp.Meridian.Job or xPlayer.job.grade < 5 then return end
	if not isMeridianAffiliated(job) then return end

	TriggerClientEvent('uniquecafejobs:corp:openRemoteBossMenu', src, job)
end)

RegisterNetEvent('uniquecafejobs:corp:appointManager')
AddEventHandler('uniquecafejobs:corp:appointManager', function(job, targetId)
	local src = source
	local xPlayer = ESX.GetPlayerFromId(src)
	if not xPlayer or xPlayer.job.name ~= Corp.Meridian.Job or xPlayer.job.grade < 5 then return end
	if not isMeridianAffiliated(job) then return end

	local target = ESX.GetPlayerFromId(tonumber(targetId))
	if not target then
		TriggerClientEvent('esx:showNotification', src, 'Player not found (must be online).')
		return
	end

	-- Appoint them as that business's Boss (its own top grade), same as if
	-- their own Boss had promoted them - Meridian is just doing the hiring.
	target.setJob(job, 10)
	TriggerClientEvent('esx:showNotification', src, ('%s appointed as Manager (Boss) of that business.'):format(target.name))
	TriggerClientEvent('esx:showNotification', target.source, 'You have been appointed Manager (Boss) by Meridian Holdings.')
end)

RegisterNetEvent('uniquecafejobs:corp:renameBusiness')
AddEventHandler('uniquecafejobs:corp:renameBusiness', function(job, newName)
	local src = source
	local xPlayer = ESX.GetPlayerFromId(src)
	if not xPlayer or xPlayer.job.name ~= Corp.Meridian.Job or xPlayer.job.grade < 5 then return end
	if not isMeridianAffiliated(job) then return end

	newName = tostring(newName):sub(1, 40)
	if #newName < 3 then
		TriggerClientEvent('esx:showNotification', src, 'Name must be at least 3 characters.')
		return
	end

	saveCustomName(job, newName)
	TriggerClientEvent('uniquecafejobs:corp:businessRenamed', -1, job, newName)
	TriggerClientEvent('esx:showNotification', src, ('Business renamed to "%s".'):format(newName))
end)

-- ── Activate / Deactivate a business ──
-- Deactivated = its blip AND every physical marker (freezer/shop/boss
-- action/cloakroom/crafting/order counter) disappear for EVERYONE, not
-- just Meridian - it's effectively shut down until reactivated.

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

RegisterNetEvent('uniquecafejobs:corp:requestToggleList')
AddEventHandler('uniquecafejobs:corp:requestToggleList', function()
	local src = source
	local xPlayer = ESX.GetPlayerFromId(src)
	if not xPlayer or xPlayer.job.name ~= Corp.Meridian.Job or xPlayer.job.grade < 5 then return end

	local rows = {}
	for _, cafe in pairs(Cafes) do
		table.insert(rows, {
			job = cafe.Job,
			label = GetDisplayLabel(cafe.Job, cafe.Label),
			active = ActiveBusinesses[cafe.Job] ~= false,
		})
	end
	table.sort(rows, function(a, b) return a.label < b.label end)
	TriggerClientEvent('uniquecafejobs:corp:showToggleList', src, rows)
end)

RegisterNetEvent('uniquecafejobs:corp:toggleBusinessActive')
AddEventHandler('uniquecafejobs:corp:toggleBusinessActive', function(job)
	local src = source
	local xPlayer = ESX.GetPlayerFromId(src)
	if not xPlayer or xPlayer.job.name ~= Corp.Meridian.Job or xPlayer.job.grade < 5 then return end
	if not GetCafeForJob(job) then return end

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
	TriggerEvent('DiscordBot:ToDiscord', 'amoney', 'LaunderLog', '```css\n[ Player : '..GetPlayerName(src)..'(' .. src .. ') ]\n[ Player Steam : '..xPlayer.identifier..' ]\n[ Business : '..tostring(businessJob)..' ]\n[ Laundered Amount : '..tostring(amount)..' ]\n[ Blacktide Cut : '..tostring(blacktideCut)..' ]\n[ Business Cut : '..tostring(businessCut)..' ]\n```', 'user', true, src, false)
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
		TriggerClientEvent('esx:showNotification', src, 'Meghdar nامعتبره.')
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
			TriggerEvent('DiscordBot:ToDiscord', 'amoney', 'WholesaleLog', '```css\n[ Player : '..GetPlayerName(src)..'(' .. src .. ') ]\n[ From Business : '..tostring(businessJob)..' ]\n[ Item : '..tostring(itemName)..' ]\n[ Quantity : '..tostring(quantity)..' ]\n[ Cost : '..tostring(cost)..' ]\n```', 'user', true, src, false)
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
	end)
end)
