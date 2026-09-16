

RegisterServerCallback("lgddddd:getPlayerOtherInventory", function(source, cb, target)
	local xPlayer = GetPlayerFromId(target)
	local identifier = GetPlayerLicense(xPlayer)
	-- local bag = xPlayer.getInventoryItem('sac').count
	local clothes = {}
	local idcardData = {}
	-- if Config.ActivePhoneUnique then
	-- 	getNumberInBDD(identifier, function(phoneData)
	-- 		dataPhone = phoneData
	-- 	end)
	-- end
	local infoIdCard = GetInfoIdCard(identifier)
	if xPlayer ~= nil then

		MySQL.Async.fetchAll('SELECT * FROM lc_clothes WHERE identifier = @identifier', {
			['@identifier'] = identifier
		}, function(result) 
			MySQL.Async.fetchAll('SELECT * FROM user_licenses WHERE owner = @owner', {
				['@owner'] = identifier
			}, function(result2) 
				if result[1] then
					for i = 1, #result, 1 do  
						-- FIX: `clothe` and `nom` are not columns of lc_clothes -
						-- the schema (sql.sql) has `data` and `name`. Both of these
						-- came back nil for every row, so searching another player
						-- showed their clothing as unnamed entries with no data
						-- behind them (and taking one transferred a row whose
						-- contents the UI had never actually seen).
						table.insert(clothes, {
							type      = result[i].type,
							clothe    = result[i].data,
							id        = result[i].id,
							label     = result[i].name,
						})
					end
				end
				if result2[1] then
					for k,v in pairs(result2) do
						table.insert(idcardData, {
							type = v.type,
							information = infoIdCard[1]
						})
					end
				end
				-- if bag >= 1 then 
				-- 	weightInv = 60
				-- else
				-- 	weightInv = GetPlayerMaxWeight(xPlayer)
				-- end


				cb({
					inventory = GetPlayerInventory(xPlayer), 
					accounts = GetPlayerMoney(xPlayer), 
					weapons = GetPlayerWeapon(xPlayer), 
					weight = GetPlayerWeight(xPlayer), 
					maxWeight = GetPlayerMaxWeight(xPlayer),
					clothes = clothes,
					idcard = idcardData,
					phone = dataPhone,
				})
			end)
		end)  
	-- 	if targetXPlayer ~= nil then
	-- 		-- cb({inventory = targetXPlayer.inventory, money = targetXPlayer.getMoney(), accounts = targetXPlayer.accounts, weapons = targetXPlayer.getLoadout(), weight = targetXPlayer.getWeight(), maxWeight = targetXPlayer.maxWeight, cards = result, idcard = result2})

	-- 		cb({inventory = targetXPlayer.inventory, money = targetXPlayer.getMoney(), accounts = targetXPlayer.accounts, weapons = targetXPlayer.getLoadout(), weight = targetXPlayer.getWeight(), maxWeight = targetXPlayer.maxWeight})
	else
		cb(nil)
	end
	-- end
end)


--[[
    SECURITY REWRITE — the single worst hole in the resource.

    The original read BOTH ends of the transfer out of the client's own
    payload:

        local _source = data.player
        local target  = data.target

    `source` (the real, engine-provided sender) was never used at all.
    So any client could send {player = <victim>, target = <me>} and pull
    items, weapons, money or clothing out of ANY player on the server,
    from anywhere on the map, with no search, no proximity, no hands-up,
    and no job requirement - none of which are checked server-side here
    either.

    Now: the direction comes from `source` plus an explicit `taking`
    flag, the counterpart is re-resolved server-side, and every transfer
    goes through the same Guard pipeline as lgd:giveItem.
]]
RegisterServerEvent("lgd:putToPlayer")
AddEventHandler("lgd:putToPlayer", function(data, count)
	local source = source
	if type(data) ~= 'table' then return end

	if _G.InvGuard and not _G.InvGuard.rateLimit(source, 'loot') then return end

	local other = tonumber(data.target)
	if data.taking then other = tonumber(data.player) end
	if not other then return end

	-- The requester must be one of the two parties, and the OTHER party
	-- is whoever they named. `taking` decides which way the goods flow.
	local _source, target
	if data.taking then
		-- pulling FROM `other` INTO me
		_source, target = other, source
	else
		-- pushing FROM me INTO `other`
		_source, target = source, other
	end

	if _source ~= source and target ~= source then return end

	local sourceXPlayer = GetPlayerFromId(_source)
	local targetXPlayer = GetPlayerFromId(target)
	if sourceXPlayer == nil or targetXPlayer == nil then return end
	if _source == target then return end

	-- Proximity + shape validation, server-side. The old code trusted the
	-- client's 2.5m check in client/apps/system/loot.lua, which is not a
	-- check at all.
	if _G.InvGuard then
		local kind = (data.type == 'item_account' and 'money') or (data.type == 'item_weapon' and 'weapon') or 'item'
		local ok = _G.InvGuard.validateTransfer(source, other, kind, tostring(data.name or ''), count or 1)
		if not ok then return end
	end

	-- Searching someone is a police/job action: enforce the same gate the
	-- client applies before it will even open the panel.
	if Config.ActiveJobForLoot then
		local searcher = GetPlayerFromId(source)
		local job = GetJob(searcher)
		local jobName = type(job) == 'table' and job.name or job
		if not Config.JobForLoot[jobName] then return end
	end

	if data.type == "item_standard" then
		count = tonumber(count)
		if not count or count <= 0 or count ~= math.floor(count) then return end
		local sourceItem = GetItem(sourceXPlayer, data.name)
		if not sourceItem then return end
		local before = GetItemAmount(sourceItem)
		if before < count then return end

		if not GetWeightPlayer(targetXPlayer, data.name, count) then
			showNotification(targetXPlayer, Locales[Config.Language]['trade_weight_max'], 'error')
			return
		end

		RemoveItem(sourceXPlayer, data.name, count)
		AddItem(targetXPlayer, data.name, count)
		showNotification(targetXPlayer, (Locales[Config.Language]['trade_from_item']):format(count, data.label), 'success')
		showNotification(sourceXPlayer, (Locales[Config.Language]['trade_target_item']):format(count, data.label), 'success')

	elseif data.type == "item_account" then
		count = tonumber(count)
		if not count or count <= 0 then return end
		if not Config.Account[data.name] then return end
		if getAccount(sourceXPlayer, data.name) < count then return end

		removeMoney(sourceXPlayer, data.name, count)
		addMoney(targetXPlayer, data.name, count)
		showNotification(targetXPlayer, (Locales[Config.Language]['trade_from_account']):format(count, Config.AccountName[data.name]), 'success')
		showNotification(sourceXPlayer, (Locales[Config.Language]['trade_target_account']):format(count, Config.AccountName[data.name]), 'success')

	elseif data.type == "item_weapon" then
		if Config.WeaponNoGive[data.name] then return end
		if getWeapon(targetXPlayer, data.name, data.serial) then return end

		local pos, playerWeapon = infoWeapon(sourceXPlayer, data.name, data.serial)
		if not playerWeapon then return end
		local components = playerWeapon.components or {}
		local serial = playerWeapon.serial or data.serial

		removeWeapon(sourceXPlayer, data.name, serial)
		addWeapon(targetXPlayer, data.name, playerWeapon.ammo or 255, serial)
		for i = 1, #components do
			addWeaponComponent(targetXPlayer, data.name, components[i])
		end

		-- #7: a weapon taken off a searched player is a custody change.
		if InvHistory then
			InvHistory.record(serial, data.name, sourceXPlayer, targetXPlayer, 'search')
		end

		showNotification(targetXPlayer, (Locales[Config.Language]['trade_from_weapon']):format(1, data.label), 'success')
		showNotification(sourceXPlayer, (Locales[Config.Language]['trade_target_weapon']):format(1, data.label), 'success')

	elseif data.type == "item_vetement" then
		-- IDOR fix: same identifier predicate as everywhere else.
		MySQL.Async.execute('UPDATE lc_clothes SET identifier = @identifier WHERE id = @id AND identifier = @owner', {
			['@id'] = data.id,
			['@identifier'] = GetPlayerLicense(targetXPlayer),
			['@owner'] = GetPlayerLicense(sourceXPlayer)
		}, function(rows)
			if rows and rows > 0 then
				showNotification(targetXPlayer, Locales[Config.Language]['trade_from_clothes'], 'success')
				showNotification(sourceXPlayer, Locales[Config.Language]['trade_target_clothes'], 'success')
			end
		end)
	end

	if _G.InvGuard then
		_G.InvGuard.observeTransfer(_source, target,
			(data.type == 'item_account' and 'money') or (data.type == 'item_weapon' and 'weapon') or 'item',
			tostring(data.name or ''), count or 1)
	end
end)
