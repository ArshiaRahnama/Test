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

local function rankData(rankId)
	for _, r in ipairs(Ranks) do
		if r.id == rankId then return r end
	end
	return Ranks[1]
end

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
			local tag = rankData(state.rank).label
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
			local feePercent = rankData(BusinessState[cafe.Job].rank).feePercent
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
			table.insert(rows, {
				job = cafe.Job,
				label = GetDisplayLabel(cafe.Job, cafe.Label),
				rank = BusinessState[cafe.Job].rank,
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
	if ownerOf(job) ~= xPlayer.job.name then return end

	local state = BusinessState[job]
	local currentIndex
	for i, r in ipairs(Ranks) do
		if r.id == state.rank then currentIndex = i end
	end
	local nextRank = Ranks[currentIndex + 1]
	if not nextRank then
		TriggerClientEvent('esx:showNotification', src, 'Already at max rank (Gold).')
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
	end)
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

	TriggerClientEvent('uniquecafejobs:corp:openRemoteBossMenu', src, job)
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

	target.setJob(job, 10)
	TriggerClientEvent('esx:showNotification', src, ('%s appointed as Manager (Boss) of that business.'):format(target.name))
	TriggerClientEvent('esx:showNotification', target.source, 'You have been appointed Manager (Boss) by your holding.')
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
