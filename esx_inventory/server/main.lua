RegisterServerCallback("lgddddd:getPlayerInventory", function(source, cb)
	local xPlayer = GetPlayerFromId(source)
	if xPlayer ~= nil then
		local identifier = GetPlayerLicense(xPlayer)
		-- local bag = xPlayer.getInventoryItem('sac').count
		local clothes = {}
		if Config.ActivePhoneUnique then
			getNumberInBDD(identifier, function(phoneData)
				dataPhone = phoneData
			end)
		end
		if Config.ActiveIdCard then
			getCardInBDD(identifier, function(cardData)
				idcardData = cardData
			end)
		end

		MySQL.Async.fetchAll('SELECT * FROM lc_clothes WHERE identifier = @identifier', {
			['@identifier'] = identifier
		}, function(result) 

				if result[1] then
					for i = 1, #result, 1 do  
						table.insert(clothes, {      
							type      = result[i].type,  
							clothe      = result[i].data,
							id      = result[i].id,
							label      = result[i].name,
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
	-- 	if targetXPlayer ~= nil then
	-- 		-- cb({inventory = targetXPlayer.inventory, money = targetXPlayer.getMoney(), accounts = targetXPlayer.accounts, weapons = targetXPlayer.getLoadout(), weight = targetXPlayer.getWeight(), maxWeight = targetXPlayer.maxWeight, cards = result, idcard = result2})

	-- 		cb({inventory = targetXPlayer.inventory, money = targetXPlayer.getMoney(), accounts = targetXPlayer.accounts, weapons = targetXPlayer.getLoadout(), weight = targetXPlayer.getWeight(), maxWeight = targetXPlayer.maxWeight})
	else
		cb(nil)
	end
	-- end
end)






RegisterNetEvent('lgd:removeItem')
AddEventHandler('lgd:removeItem', function(info, name, count, serial)
	local source = source
	local xPlayer = GetPlayerFromId(source)

	-- SECURITY FIX #1: no nil guard at all. A stale/forged call from a
	-- client whose player object had already been unloaded indexed nil
	-- on every branch below and took the whole handler down with it.
	if xPlayer == nil then return end

	-- SECURITY FIX #2 (#18): the rate limiter written in
	-- server/custom/security/guard.lua was never actually called from
	-- here, so the dupe-loop spam it exists to stop went straight
	-- through.
	if _G.InvGuard and not _G.InvGuard.rateLimit(source, 'remove') then return end

	if info == 'item_standard' then
		local x_Item = GetItem(xPlayer, name)
		if count > 0 and GetItemAmount(x_Item) >= count then		
			RemoveItem(xPlayer, name, count)
		end
	elseif info == 'item_weapon' then
		if getWeapon(xPlayer, name, serial) then
			removeWeapon(xPlayer, name, serial)
		end
	elseif info == 'item_account' then
		if count > 0 and getAccount(xPlayer, name) >= count then
			removeMoney(xPlayer, name, count)
		end
	elseif info == 'item_vetement' then
		-- SECURITY FIX (IDOR): this deleted ANY lc_clothes row by primary
		-- key with no ownership check whatsoever. `name` here is the row
		-- id and comes straight from the client, so a modified client
		-- could walk the id space and wipe every clothing item on the
		-- server, one DELETE at a time. The identifier predicate makes the
		-- statement a no-op for a row the caller doesn't own.
		MySQL.Async.execute('DELETE FROM lc_clothes WHERE id = @id AND identifier = @identifier', {
			['@id'] = name,
			['@identifier'] = GetPlayerLicense(xPlayer)
		})
	elseif info == 'item_phone' then
		-- SECURITY FIX (IDOR): same problem, same shape - any phone number
		-- row could be deleted by anyone who knew (or guessed) the number.
		MySQL.Sync.execute('DELETE FROM '..phoneTable..' WHERE '..numberTable..' = @'..numberTable..' AND '..idPhoneTable..' = @owner', {
			['@'..numberTable] = name,
			['@owner'] = GetPlayerLicense(xPlayer)
		})
	end
	sendToDiscordWithSpecialURL(
		"🚮 Delete Item",
		-- FIX: `count` is intentionally nil for weapon deletions (the
		-- client passes nil on purpose - weapons are removed by serial,
		-- not by quantity: TriggerServerEvent('lgd:removeItem',
		-- 'item_weapon', name, nil, serial)). Concatenating a nil value
		-- straight into this string crashed this handler every single
		-- time a weapon got deleted. Falls back to '1' (a weapon
		-- deletion always removes exactly one instance) instead of
		-- crashing.
		"\n\n``🔢``ID : ``["..source.."] | "..xPlayer.getName().."``\n``💿``Licence: ``"..GetPlayerLicense(xPlayer).."``\n``💬``Action: ``delete "..name.." x"..tostring(count or 1).." ``", 
		webhooks['removeItem'].color, 
		webhooks['removeItem'].webhook
	)
end)

--[[
    SECURITY REWRITE of the give handler.

    The original had, all at once:
      * no nil check on xTarget  -> crash on a forged/stale target id
      * no distance check        -> give to anyone, anywhere on the map
      * no server-side ItemNoGive / WeaponNoGive -> those lists were
        enforced only in client/main.lua, i.e. not enforced
      * no concurrency lock      -> the classic two-events-in-one-tick
        dupe that server/custom/security/guard.lua was written for and
        was then never wired into
      * no ownership check on item_vetement -> any clothing row id could
        be reassigned to yourself
      * count concatenated into the webhook string unguarded

    Everything below funnels through Guard (rate limit -> validate ->
    lock -> mutate -> verify delta -> observe), which is exactly the
    order guard.lua documents. High-value transfers additionally go
    through the two-step confirmation (#22) instead of moving instantly.
]]
RegisterNetEvent('lgd:giveItem')
AddEventHandler('lgd:giveItem', function(target, name, count, type, label, serial)
	local source = source

	if _G.InvGuard and not _G.InvGuard.rateLimit(source, 'give') then return end

	local xPlayer = GetPlayerFromId(source)
	local xTarget = GetPlayerFromId(target)
	if xPlayer == nil or xTarget == nil then return end
	if type ~= 'item_weapon' and type ~= 'item_vetement' and type ~= 'item_phone' then
		count = tonumber(count)
		if not count or count <= 0 or count ~= math.floor(count) then return end
	end

	-- kind for the guard's own vocabulary
	local kind = (type == 'item_account' and 'money')
		or (type == 'item_weapon' and 'weapon')
		or 'item'

	if _G.InvGuard then
		local ok, reason = _G.InvGuard.validateTransfer(source, target, kind, name, count)
		if not ok then
			debugprint(('give rejected: %s'):format(tostring(reason)))
			return
		end
	end

	-- Server-side blacklist enforcement. These tables existed and were
	-- only ever checked client-side.
	if type == 'item_standard' and Config.ItemNoGive[name] then return end
	if type == 'item_weapon' and Config.WeaponNoGive[name] then return end

	local function doTransfer()
		if type == 'item_standard' then
			local x_Item = GetItem(xPlayer, name)
			if not x_Item then return end
			local before = GetItemAmount(x_Item)
			if before < count then return end

			if not getWeight(xTarget, name, count) then
				showNotification(xPlayer, Locales[Config.Language]['give_error_weight'], 'error')
				return
			end

			RemoveItem(xPlayer, name, count)

			-- #17: confirm the giver really lost exactly `count` before
			-- the receiver gains anything. If the delta is wrong we are
			-- mid-dupe and the add is simply never performed.
			if _G.InvGuard and not _G.InvGuard.verifyRemoval(source, name, before, count) then
				return
			end

			AddItem(xTarget, name, count)
			showNotification(xPlayer, (Locales[Config.Language]['give_from_item']):format(count, GetItemLabel(name)), 'success')
			showNotification(xTarget, (Locales[Config.Language]['give_target_item']):format(count, GetItemLabel(name)), 'success')

		elseif type == 'item_account' then
			if not Config.Account[name] then return end
			if getAccount(xPlayer, name) < count then
				showNotification(xPlayer, Locales[Config.Language]['give_error_account'], 'error')
				return
			end
			removeMoney(xPlayer, name, count)
			addMoney(xTarget, name, count)
			showNotification(xPlayer, (Locales[Config.Language]['give_from_account']):format(count, Config.AccountName[name]), 'success')
			showNotification(xTarget, (Locales[Config.Language]['give_target_account']):format(count, Config.AccountName[name]), 'success')

		elseif type == 'item_vetement' then
			-- SECURITY FIX (IDOR): the identifier predicate is what stops
			-- this from reassigning somebody else's clothing row to the
			-- target. affectedRows tells us whether it actually matched.
			MySQL.Async.execute('UPDATE lc_clothes SET identifier = @identifier WHERE id = @id AND identifier = @owner', {
				['@id'] = name,
				['@identifier'] = GetPlayerLicense(xTarget),
				['@owner'] = GetPlayerLicense(xPlayer)
			}, function(rows)
				if rows and rows > 0 then
					showNotification(xPlayer, Locales[Config.Language]['give_from_clothes'], 'success')
					showNotification(xTarget, Locales[Config.Language]['give_target_clothes'], 'success')
				end
			end)

		elseif type == 'item_phone' then
			MySQL.Async.execute('UPDATE '..phoneTable..' SET '..idPhoneTable..' = @newowner WHERE '..numberTable..' = @num AND '..idPhoneTable..' = @owner', {
				['@num'] = name,
				['@newowner'] = GetPlayerLicense(xTarget),
				['@owner'] = GetPlayerLicense(xPlayer)
			}, function(rows)
				if rows and rows > 0 then
					showNotification(xPlayer, (Locales[Config.Language]['give_from_phone']):format(formatPhoneNumber(name)), 'success')
					showNotification(xTarget, (Locales[Config.Language]['give_target_phone']):format(formatPhoneNumber(name)), 'success')
				end
			end)

		elseif type == 'item_weapon' then
			if not getWeapon(xPlayer, name, serial) then
				showNotification(xPlayer, Locales[Config.Language]['give_error_weapon'], 'error')
				return
			end
			removeWeapon(xPlayer, name, serial)
			addWeapon(xTarget, name, 255, serial)
			showNotification(xPlayer, (Locales[Config.Language]['give_from_weapon']):format(label or name), 'success')
			showNotification(xTarget, (Locales[Config.Language]['give_target_weapon']):format(label or name), 'success')

			-- #7: the handover is a chain-of-custody event.
			if InvHistory then
				InvHistory.record(serial, name, xPlayer, xTarget, 'give')
			end
		else
			return
		end

		if _G.InvGuard then
			_G.InvGuard.observeTransfer(source, target, kind, name, count or 1)
		end

		-- FIX: `count` is nil for weapon/clothes/phone transfers (they move
		-- by serial or row id, not by quantity) and was concatenated into
		-- this string unguarded, which errored out the whole handler
		-- AFTER the goods had already moved.
		sendToDiscordWithSpecialURL(
			"🧩 Give Item",
			"\n\n``🔢``ID : ``["..source.."] "..xPlayer.getName().." ``\n``💿``Licence: ``"..GetPlayerLicense(xPlayer).."``\n``💬``Action: ``gave "..tostring(name).." x"..tostring(count or 1).." ``\n``🎮``Receiver ``["..xTarget.source.."] "..xTarget.getName().."``",
			webhooks['giveItem'].color,
			webhooks['giveItem'].webhook
		)
	end

	-- #22 — high-value transfers are staged for two-step confirmation
	-- instead of executing immediately. This was fully implemented in
	-- guard.lua and never called from anywhere.
	if _G.InvGuard and _G.InvGuard.needsConfirmation(kind, name, count) then
		_G.InvGuard.stageConfirmation(source, target, kind, name, count or 1, label or name, doTransfer)
		return
	end

	-- #17 — the lock is the actual dupe fix. Everything above is the
	-- defence in depth around it.
	if _G.InvGuard then
		_G.InvGuard.withLock(source, doTransfer)
	else
		doTransfer()
	end
end)


--[[
    SECURITY REWRITE — 'Malette' (briefcase capacity bonus).

    As written, this was an open net event that any client could fire to
    hand itself +2000 / +3000 kg of carry capacity. There was no item
    check, no job check, no cooldown, no permission check, and no
    validation of `type` at all. Functionally it was a free
    infinite-inventory command for anyone with a Lua executor.

    Kept as a real feature (the capacity bonus clearly exists on purpose)
    but turned into something only the SERVER can grant:

      * the net event is gone entirely
      * the bonus is now an export other server resources call
      * it goes through RecalculateMaxWeight so it composes correctly
        with the level bonus and the backpack bonus instead of
        overwriting them

    If a script of yours used to TriggerServerEvent('Malette', n), change
    it to exports.esx_inventory:grantBriefcase(source, n).
]]
Config.BriefcaseBonus = Config.BriefcaseBonus or {
    [1] = 20,  -- kg  (was 2000 back when weights were in grams)
    [2] = 30,
    [3] = 0,   -- reset
}

local BriefcaseHolders = {} -- [identifier] = bonus kg

exports('grantBriefcase', function(source, tier)
    local xPlayer = GetPlayerFromId(source)
    if xPlayer == nil then return false end

    local bonus = Config.BriefcaseBonus[tonumber(tier) or 3]
    if bonus == nil then return false end

    BriefcaseHolders[GetPlayerLicense(xPlayer)] = bonus > 0 and bonus or nil

    local base = (ESX.GetConfig and ESX.GetConfig().MaxWeight) or Config.DefaultMaxWeight or 24
    xPlayer.setMaxWeight(base + bonus)

    if bonus > 0 then
        showNotification(xPlayer, ("~b~Briefcase~s~\nCarry capacity +%sKG"):format(bonus), 'success')
    end
    return true
end)

exports('getBriefcaseBonus', function(source)
    local xPlayer = GetPlayerFromId(source)
    if xPlayer == nil then return 0 end
    return BriefcaseHolders[GetPlayerLicense(xPlayer)] or 0
end)

