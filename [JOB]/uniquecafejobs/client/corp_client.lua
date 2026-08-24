--[[
	Client side for the 3 corp jobs. Reuses OpenCloakroomMenu() (from
	functions.lua) and esx_society's boss menu event - only the physical
	zones + a couple of bespoke menus (Portfolio / Launder / Wholesale) are
	new here.
]]

local function myCorpJob()
	if not PlayerData or not PlayerData.job then return nil end
	if PlayerData.job.name == Corp.Meridian.Job then return Corp.Meridian end
	if PlayerData.job.name == Corp.Blacktide.Job then return Corp.Blacktide end
	if PlayerData.job.name == Corp.CrateCarry.Job then return Corp.CrateCarry end
	return nil
end

-- ── Blips ──
local CorpBlips = {}
CreateThread(function()
	for _, corp in pairs({ Corp.Meridian, Corp.Blacktide, Corp.CrateCarry }) do
		local blip = AddBlipForCoord(corp.HQ.x, corp.HQ.y, corp.HQ.z)
		SetBlipSprite(blip, corp.Blip.Sprite)
		SetBlipColour(blip, corp.Blip.Color)
		SetBlipScale(blip, corp.Blip.Scale)
		SetBlipAsShortRange(blip, true)
		CorpBlips[corp.Job] = blip
		BeginTextCommandSetBlipName("STRING")
		AddTextComponentString(GetDisplayLabel(corp.Job, corp.Label))
		EndTextCommandSetBlipName(blip)
	end
end)

RegisterNetEvent('uniquecafejobs:corp:holdingRenamed')
AddEventHandler('uniquecafejobs:corp:holdingRenamed', function(job, newName)
	CustomNames[job] = newName
	if CorpBlips[job] then
		BeginTextCommandSetBlipName("STRING")
		AddTextComponentString(newName)
		EndTextCommandSetBlipName(CorpBlips[job])
	end
end)

RegisterNetEvent('uniquecafejobs:corp:businessRenamed')
AddEventHandler('uniquecafejobs:corp:businessRenamed', function(job, newName)
	CustomNames[job] = newName
end)

-- ── Meridian: physical Boss Action access at EVERY business it owns ──
-- Whoever holds Meridian (Director+) can walk up to any acquired/partnered
-- business's own Boss Action marker and manage it directly, on top of the
-- remote "Manage Business Staff" menu at Meridian's own HQ.
local MeridianOwnedJobs = {}

CreateThread(function()
	Citizen.Wait(2000)
	TriggerServerEvent('uniquecafejobs:corp:requestMeridianOwnedJobs')
end)

RegisterNetEvent('uniquecafejobs:corp:syncMeridianOwnedJobs')
AddEventHandler('uniquecafejobs:corp:syncMeridianOwnedJobs', function(owned)
	MeridianOwnedJobs = owned
end)

CreateThread(function()
	while true do
		Citizen.Wait(0)
		if PlayerData and PlayerData.job and PlayerData.job.name == Corp.Meridian.Job and PlayerData.job.grade >= 5 then
			local playerCoords = GetEntityCoords(PlayerPedId())

			for _, cafe in pairs(Cafes) do
				if MeridianOwnedJobs[cafe.Job] then
					local dist = #(playerCoords - vector3(cafe.BossAction.Pos.x, cafe.BossAction.Pos.y, cafe.BossAction.Pos.z))
					if dist < 10.0 then
						DrawMarker(29, cafe.BossAction.Pos.x, cafe.BossAction.Pos.y, cafe.BossAction.Pos.z - 0.9, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.6, 0.6, 0.6, 0, 255, 120, 100, false, true, 2, false, nil, nil, false)
						if dist < 1.5 then
							ESX.ShowHelpNotification(("~INPUT_CONTEXT~ Manage %s (as Meridian)"):format(GetDisplayLabel(cafe.Job, cafe.Label)))
							if IsControlJustPressed(0, 38) then
								TriggerServerEvent('uniquecafejobs:corp:openBusinessBossMenuAsMeridian', cafe.Job)
							end
						end
					end
				end
			end
		else
			Citizen.Wait(1000)
		end
	end
end)

-- ── Boss Action / Cloakroom markers (Meridian + Blacktide + CrateCarry) ──
-- Classic DrawMarker + proximity style, same convention as esx_uniquejobs
-- (police_main.lua etc.) uses for its own Boss Action / Cloakroom markers -
-- no ox_target here on purpose.
local SimpleMarkers = {
	{ pos = Corp.Meridian.BossAction.Pos,   job = Corp.Meridian.Job,   help = Corp.Meridian.BossAction.Name,   event = 'uniquecafejobs:corp:openMeridianBoss' },
	{ pos = Corp.Meridian.CloackRoom.Pos,   job = Corp.Meridian.Job,   help = Corp.Meridian.CloackRoom.Name,   event = 'uniquecafejobs:corp:openCloakroom' },
	{ pos = Corp.Blacktide.BossAction.Pos,  job = Corp.Blacktide.Job,  help = Corp.Blacktide.BossAction.Name,  event = 'uniquecafejobs:corp:openBlacktideBoss' },
	{ pos = Corp.Blacktide.CloackRoom.Pos,  job = Corp.Blacktide.Job,  help = Corp.Blacktide.CloackRoom.Name,  event = 'uniquecafejobs:corp:openCloakroom' },
	{ pos = Corp.CrateCarry.Freezer.Pos,    job = Corp.CrateCarry.Job, help = Corp.CrateCarry.Freezer.Name,    event = 'AH_uwucafejob:OpenInventory' },
	{ pos = Corp.CrateCarry.BossAction.Pos, job = Corp.CrateCarry.Job, help = Corp.CrateCarry.BossAction.Name, event = 'uniquecafejobs:corp:openCrateCarryBoss' },
	{ pos = Corp.CrateCarry.CloackRoom.Pos, job = Corp.CrateCarry.Job, help = Corp.CrateCarry.CloackRoom.Name, event = 'uniquecafejobs:corp:openCloakroom' },
}

CreateThread(function()
	while true do
		Citizen.Wait(0)
		local playerCoords = GetEntityCoords(PlayerPedId())

		for _, m in ipairs(SimpleMarkers) do
			if PlayerData and PlayerData.job and PlayerData.job.name == m.job then
				local dist = #(playerCoords - vector3(m.pos.x, m.pos.y, m.pos.z))
				if dist < 10.0 then
					DrawMarker(29, m.pos.x, m.pos.y, m.pos.z - 0.9, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.6, 0.6, 0.6, 255, 255, 255, 100, false, true, 2, false, nil, nil, false)
					if dist < 1.5 then
						ESX.ShowHelpNotification("~INPUT_CONTEXT~ " .. m.help)
						if IsControlJustPressed(0, 38) then
							TriggerEvent(m.event)
						end
					end
				end
			end
		end

		-- Resale counter - open to EVERYONE (public customers), not job gated
		local resaleDist = #(playerCoords - vector3(Corp.CrateCarry.ResaleShop.Pos.x, Corp.CrateCarry.ResaleShop.Pos.y, Corp.CrateCarry.ResaleShop.Pos.z))
		if resaleDist < 10.0 then
			DrawMarker(29, Corp.CrateCarry.ResaleShop.Pos.x, Corp.CrateCarry.ResaleShop.Pos.y, Corp.CrateCarry.ResaleShop.Pos.z - 0.9, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.6, 0.6, 0.6, 0, 200, 255, 100, false, true, 2, false, nil, nil, false)
			if resaleDist < 1.5 then
				ESX.ShowHelpNotification("~INPUT_CONTEXT~ " .. Corp.CrateCarry.ResaleShop.Name)
				if IsControlJustPressed(0, 38) then
					TriggerServerEvent('uniquecafejobs:corp:openResaleShop')
				end
			end
		end
	end
end)

RegisterNetEvent('uniquecafejobs:corp:openCloakroom')
AddEventHandler('uniquecafejobs:corp:openCloakroom', function()
	OpenCloakroomMenu()
end)

RegisterNetEvent('uniquecafejobs:corp:openMeridianBoss')
AddEventHandler('uniquecafejobs:corp:openMeridianBoss', function()
	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'meridian_boss_root', {
		title    = GetDisplayLabel(Corp.Meridian.Job, Corp.Meridian.Label),
		align    = 'top-left',
		elements = {
			{ label = 'Portfolio Dashboard', value = 'dashboard' },
			{ label = 'Manage Portfolio (Acquire / Rank Up)', value = 'portfolio' },
			{ label = 'VIP Partnerships', value = 'vip' },
			{ label = 'Manage Business Staff (Director+)', value = 'staff' },
			{ label = 'Open/Close Businesses (Director+)', value = 'toggle' },
			{ label = 'Rename Holding', value = 'rename' },
		},
	}, function(data, menu)
		menu.close()
		if data.current.value == 'dashboard' then
			TriggerServerEvent('uniquecafejobs:corp:requestPortfolio')
		elseif data.current.value == 'portfolio' then
			TriggerServerEvent('uniquecafejobs:corp:requestManagePortfolio')
		elseif data.current.value == 'vip' then
			TriggerServerEvent('uniquecafejobs:corp:requestVIPPartnerships')
		elseif data.current.value == 'staff' then
			TriggerServerEvent('uniquecafejobs:corp:requestManageStaffList')
		elseif data.current.value == 'toggle' then
			TriggerServerEvent('uniquecafejobs:corp:requestToggleList')
		elseif data.current.value == 'rename' then
			local input = lib.inputDialog('Rename Holding', {
				{ type = 'input', label = 'New name (3-30 chars)', required = true },
			})
			if input and input[1] then
				TriggerServerEvent('uniquecafejobs:corp:renameHolding', input[1])
			end
		end
	end, function(data, menu)
		menu.close()
	end)
end)

RegisterNetEvent('uniquecafejobs:corp:showPortfolio')
AddEventHandler('uniquecafejobs:corp:showPortfolio', function(rows, canCollect, meridianBalance)
	local elements = { { label = ('Meridian Balance: $%d'):format(meridianBalance), value = 'noop', disabled = true } }
	for _, row in ipairs(rows) do
		table.insert(elements, { label = ('%s: $%d'):format(row.label, row.balance), value = 'noop', disabled = true })
	end
	table.insert(elements, { label = canCollect and 'Collect Franchise Fee (' .. Corp.Meridian.FranchiseFeePercent .. '%)' or 'Franchise fee already collected recently', value = 'collect', disabled = not canCollect })

	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'meridian_portfolio', {
		title    = 'Portfolio Dashboard',
		align    = 'top-left',
		elements = elements,
	}, function(data, menu)
		if data.current.value == 'collect' then
			TriggerServerEvent('uniquecafejobs:corp:collectFranchiseFee')
		end
		menu.close()
	end, function(data, menu)
		menu.close()
	end)
end)

RegisterNetEvent('uniquecafejobs:corp:showManagePortfolio')
AddEventHandler('uniquecafejobs:corp:showManagePortfolio', function(rows)
	local elements = {}
	for _, row in ipairs(rows) do
		local label
		if row.acquired then
			local nextRankCost = nil
			for i, r in ipairs(Corp.Meridian.Ranks) do
				if r.id == row.rank and Corp.Meridian.Ranks[i + 1] then
					nextRankCost = Corp.Meridian.Ranks[i + 1].label .. ' for $' .. Corp.Meridian.Ranks[i + 1].upgradeCost
				end
			end
			label = ('%s - %s rank%s'):format(row.label, row.rank:gsub("^%l", string.upper), nextRankCost and (' (upgrade to ' .. nextRankCost .. ')') or ' (MAX)')
		else
			label = ('%s - not acquired ($%d to acquire)'):format(row.label, Corp.Meridian.AcquireCost)
		end
		table.insert(elements, { label = label, value = row.job, acquired = row.acquired, maxed = row.acquired and row.rank == 'gold' })
	end

	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'meridian_manage_portfolio', {
		title    = 'Manage Portfolio',
		align    = 'top-left',
		elements = elements,
	}, function(data, menu)
		if data.current.acquired then
			if not data.current.maxed then
				TriggerServerEvent('uniquecafejobs:corp:upgradeBusiness', data.current.value)
			end
		else
			TriggerServerEvent('uniquecafejobs:corp:acquireBusiness', data.current.value)
		end
		menu.close()
	end, function(data, menu)
		menu.close()
	end)
end)

RegisterNetEvent('uniquecafejobs:corp:showVIPPartnerships')
AddEventHandler('uniquecafejobs:corp:showVIPPartnerships', function(rows)
	local elements = {}
	for _, row in ipairs(rows) do
		local label = row.partnered
			and (row.label .. ' - VIP Partner (15% flat cut active)')
			or (row.label .. (' - not partnered ($%d to sign)'):format(Corp.Meridian.VIPPartnershipCost))
		table.insert(elements, { label = label, value = row.job, partnered = row.partnered })
	end

	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'meridian_vip_partnerships', {
		title    = 'VIP Partnerships',
		align    = 'top-left',
		elements = elements,
	}, function(data, menu)
		if not data.current.partnered then
			TriggerServerEvent('uniquecafejobs:corp:signVIPPartnership', data.current.value)
		end
		menu.close()
	end, function(data, menu)
		menu.close()
	end)
end)

RegisterNetEvent('uniquecafejobs:corp:showManageStaffList')
AddEventHandler('uniquecafejobs:corp:showManageStaffList', function(rows)
	local elements = {}
	for _, row in ipairs(rows) do
		table.insert(elements, { label = row.label, value = row.job })
	end
	if #elements == 0 then
		table.insert(elements, { label = 'No businesses acquired or partnered yet', value = 'noop', disabled = true })
	end

	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'meridian_staff_list', {
		title    = 'Manage Business Staff',
		align    = 'top-left',
		elements = elements,
	}, function(data, menu)
		if data.current.value == 'noop' then return end
		local chosenJob = data.current.value
		menu.close()

		ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'meridian_staff_actions', {
			title    = 'Manage Staff',
			align    = 'top-left',
			elements = {
				{ label = 'Open Boss Menu (hire / fire / grades)', value = 'boss' },
				{ label = 'Appoint Manager (make someone the Boss)', value = 'appoint' },
				{ label = 'Rename Business', value = 'rename' },
			},
		}, function(data2, menu2)
			menu2.close()
			if data2.current.value == 'boss' then
				TriggerServerEvent('uniquecafejobs:corp:openBusinessBossMenuAsMeridian', chosenJob)
			elseif data2.current.value == 'appoint' then
				local input = lib.inputDialog('Appoint Manager', {
					{ type = 'number', label = 'Player server ID', required = true },
				})
				if input and input[1] then
					TriggerServerEvent('uniquecafejobs:corp:appointManager', chosenJob, input[1])
				end
			elseif data2.current.value == 'rename' then
				local input = lib.inputDialog('Rename Business', {
					{ type = 'input', label = 'New name (3-40 chars)', required = true },
				})
				if input and input[1] then
					TriggerServerEvent('uniquecafejobs:corp:renameBusiness', chosenJob, input[1])
				end
			end
		end, function(data2, menu2)
			menu2.close()
		end)
	end, function(data, menu)
		menu.close()
	end)
end)

RegisterNetEvent('uniquecafejobs:corp:showToggleList')
AddEventHandler('uniquecafejobs:corp:showToggleList', function(rows)
	local elements = {}
	for _, row in ipairs(rows) do
		table.insert(elements, {
			label = ('%s %s'):format(row.active and '🟢' or '🔴', row.label),
			value = row.job,
		})
	end

	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'meridian_toggle_list', {
		title    = 'Open/Close Businesses',
		align    = 'top-left',
		elements = elements,
	}, function(data, menu)
		TriggerServerEvent('uniquecafejobs:corp:toggleBusinessActive', data.current.value)
		menu.close()
	end, function(data, menu)
		menu.close()
	end)
end)

RegisterNetEvent('uniquecafejobs:corp:openRemoteBossMenu')
AddEventHandler('uniquecafejobs:corp:openRemoteBossMenu', function(job)
	TriggerEvent('esx_society:openBosscarysMenu', job, function(data, menu) end, function(data, menu) end)
end)

local function openRenamableBossMenu(job, label)
	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'holding_boss_root_' .. job, {
		title    = GetDisplayLabel(job, label),
		align    = 'top-left',
		elements = {
			{ label = 'Open Boss Menu (hire / fire / grades)', value = 'boss' },
			{ label = 'Rename Holding', value = 'rename' },
		},
	}, function(data, menu)
		menu.close()
		if data.current.value == 'boss' then
			TriggerEvent('esx_society:openBosscarysMenu', job, function(d, m) end, function(d, m) end)
		elseif data.current.value == 'rename' then
			local input = lib.inputDialog('Rename Holding', {
				{ type = 'input', label = 'New name (3-30 chars)', required = true },
			})
			if input and input[1] then
				TriggerServerEvent('uniquecafejobs:corp:renameHolding', input[1])
			end
		end
	end, function(data, menu)
		menu.close()
	end)
end

RegisterNetEvent('uniquecafejobs:corp:openBlacktideBoss')
AddEventHandler('uniquecafejobs:corp:openBlacktideBoss', function()
	openRenamableBossMenu(Corp.Blacktide.Job, Corp.Blacktide.Label)
end)

RegisterNetEvent('uniquecafejobs:corp:openCrateCarryBoss')
AddEventHandler('uniquecafejobs:corp:openCrateCarryBoss', function()
	openRenamableBossMenu(Corp.CrateCarry.Job, Corp.CrateCarry.Label)
end)

-- ── Blacktide (launder) + CrateCarry (wholesale) markers at all 17 businesses ──
-- Same DrawMarker + proximity convention as the rest of this file.
CreateThread(function()
	while true do
		Citizen.Wait(0)
		if PlayerData and PlayerData.job and (PlayerData.job.name == Corp.Blacktide.Job or PlayerData.job.name == Corp.CrateCarry.Job) then
			local playerCoords = GetEntityCoords(PlayerPedId())

			for _, cafe in pairs(Cafes) do
				if PlayerData.job.name == Corp.Blacktide.Job then
					local dist = #(playerCoords - vector3(cafe.PedShop.Pos.x, cafe.PedShop.Pos.y, cafe.PedShop.Pos.z))
					if dist < 10.0 then
						DrawMarker(29, cafe.PedShop.Pos.x, cafe.PedShop.Pos.y, cafe.PedShop.Pos.z - 0.9, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.6, 0.6, 0.6, 40, 40, 40, 100, false, true, 2, false, nil, nil, false)
						if dist < 1.5 then
							ESX.ShowHelpNotification("~INPUT_CONTEXT~ Launder Cash Through " .. GetDisplayLabel(cafe.Job, cafe.Label))
							if IsControlJustPressed(0, 38) then
								TriggerServerEvent('uniquecafejobs:corp:launder', cafe.Job)
							end
						end
					end
				end

				if PlayerData.job.name == Corp.CrateCarry.Job then
					local dist2 = #(playerCoords - vector3(cafe.Freezer.Pos.x, cafe.Freezer.Pos.y, cafe.Freezer.Pos.z))
					if dist2 < 10.0 then
						DrawMarker(29, cafe.Freezer.Pos.x, cafe.Freezer.Pos.y, cafe.Freezer.Pos.z - 0.9, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.6, 0.6, 0.6, 255, 170, 0, 100, false, true, 2, false, nil, nil, false)
						if dist2 < 1.5 then
							ESX.ShowHelpNotification("~INPUT_CONTEXT~ Buy Wholesale From " .. GetDisplayLabel(cafe.Job, cafe.Label))
							if IsControlJustPressed(0, 38) then
								TriggerServerEvent('uniquecafejobs:corp:openWholesaleMenu', cafe.Job)
							end
						end
					end
				end
			end
		else
			Citizen.Wait(1000)
		end
	end
end)

RegisterNetEvent('uniquecafejobs:corp:showWholesaleMenu')
AddEventHandler('uniquecafejobs:corp:showWholesaleMenu', function(businessJob, businessLabel, stock)
	local elements = {}
	for _, s in ipairs(stock) do
		table.insert(elements, { label = ('%s (x%d in stock) - $%d/unit'):format(s.label, s.count, Corp.CrateCarry.WholesaleUnitPrice), value = s.name })
	end
	if #elements == 0 then
		table.insert(elements, { label = 'Nothing in stock right now', value = 'noop', disabled = true })
	end

	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'wholesale_menu', {
		title    = 'Wholesale - ' .. businessLabel,
		align    = 'top-left',
		elements = elements,
	}, function(data, menu)
		if data.current.value ~= 'noop' then
			local input = lib.inputDialog('Buy Wholesale', {
				{ type = 'number', label = 'Quantity (max ' .. Corp.CrateCarry.WholesaleBuyLimit .. ')', default = 1, min = 1, max = Corp.CrateCarry.WholesaleBuyLimit },
			})
			if input and input[1] then
				TriggerServerEvent('uniquecafejobs:corp:buyWholesale', businessJob, data.current.value, tonumber(input[1]))
			end
		end
	end, function(data, menu)
		menu.close()
	end)
end)

RegisterNetEvent('uniquecafejobs:corp:showResaleShop')
AddEventHandler('uniquecafejobs:corp:showResaleShop', function(stock)
	local elements = {}
	for _, s in ipairs(stock) do
		table.insert(elements, { label = ('%s - $%d (x%d in stock)'):format(s.label, s.price, s.count), value = s.name })
	end
	if #elements == 0 then
		table.insert(elements, { label = 'Sold out - come back later', value = 'noop', disabled = true })
	end

	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'resale_shop', {
		title    = Corp.CrateCarry.Label,
		align    = 'top-left',
		elements = elements,
	}, function(data, menu)
		if data.current.value ~= 'noop' then
			TriggerServerEvent('uniquecafejobs:corp:buyResale', data.current.value)
		end
	end, function(data, menu)
		menu.close()
	end)
end)

-- ── Vehicle spawn/delete for the 3 corp jobs (same pattern as the 17 businesses) ──
CreateThread(function()
	while true do
		Citizen.Wait(0)
		local corp = myCorpJob()
		if corp then
			local playerCoords = GetEntityCoords(PlayerPedId())
			local spawnMarker = vector3(corp.SpawnMarker.x, corp.SpawnMarker.y, corp.SpawnMarker.z)
			local deleteMarker = vector3(corp.DeleteMarker.x, corp.DeleteMarker.y, corp.DeleteMarker.z)

			if #(playerCoords - spawnMarker) < 10.0 then
				DrawMarker(36, spawnMarker.x, spawnMarker.y, spawnMarker.z - 1.0, 0, 0, 0, 0, 0, 0, 1.5, 1.5, 1.0, 0, 255, 0, 100, false, true, 2, false, nil, nil, false)
				if #(playerCoords - spawnMarker) < 2.0 then
					ESX.ShowHelpNotification("برای دریافت خودرو ~INPUT_CONTEXT~ را فشار دهید")
					if IsControlJustPressed(0, 38) then
						TriggerServerEvent('uniquecafejobs:corp:spawnVehicle', corp.SpawnVehicle)
					end
				end
			end

			if #(playerCoords - deleteMarker) < 10.0 then
				DrawMarker(24, deleteMarker.x, deleteMarker.y, deleteMarker.z - 1.0, 0, 0, 0, 0, 0, 0, 1.5, 1.5, 1.0, 255, 0, 0, 100, false, true, 2, false, nil, nil, false)
				if #(playerCoords - deleteMarker) < 2.0 then
					ESX.ShowHelpNotification("برای حذف خودرو ~INPUT_CONTEXT~ را فشار دهید")
					if IsControlJustPressed(0, 38) then
						local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
						if vehicle and vehicle ~= 0 then
							ESX.Game.DeleteVehicle(vehicle)
						end
					end
				end
			end
		else
			Citizen.Wait(1000)
		end
	end
end)

RegisterNetEvent("spawnCarClientCorp")
AddEventHandler("spawnCarClientCorp", function(vehicleName)
	local corp = myCorpJob()
	if not corp then return end
	local spawnPoint = vector4(corp.SpawnPoint.x, corp.SpawnPoint.y, corp.SpawnPoint.z, corp.SpawnPoint.w)
	ESX.Game.SpawnVehicle(vehicleName, spawnPoint, spawnPoint.w, function(vehicle)
		TaskWarpPedIntoVehicle(PlayerPedId(), vehicle, -1)
		SetEntityAsNoLongerNeeded(vehicle)
	end)
end)
