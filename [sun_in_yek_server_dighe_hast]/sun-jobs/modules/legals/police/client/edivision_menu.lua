-- Pub by FleeX Team , https://discord.gg/87rGBxgCsa

local function openAddMenu(data)
	local options = {
		{ label = '----List Divisions Mojaz----' }
	}
	local count = 0
	for i = 1, #data.allowedList do
		local divi = data.allowedList[i]
		if not data.divisions[divi] then
			options[#options + 1] = { label = divi:gsub("^%l", string.upper), args = divi }
			count = count + 1
		end
	end
	if count == 0 then
		options[#options + 1] = { label = 'Hich division jadidi baraye dadan vojood nadarad' }
	end

	lib.registerMenu({
		id = 'edivision_add',
		title = ('Add Division > %s'):format(data.targetName),
		options = options,
		onClose = function()
			lib.showMenu('edivision_main')
		end
	}, function(selected, scrollIndex, args)
		if not args then return end
		local alert = lib.alertDialog({
			header = 'Dadan Division',
			content = ('Aya az dadan division %s be %s etminan darid?'):format(args, data.targetName),
			centered = true,
			cancel = true
		})
		if alert == 'confirm' then
			TriggerServerEvent('edivision:add', data.targetId, args)
		end
	end)
	lib.showMenu('edivision_add')
end

RegisterNetEvent('edivision:openMenu', function(data)
	local options = {
		{ label = ('%s (Id: %s)'):format(data.targetName, data.targetId) },
		{ label = ('Job: %s'):format(data.jobName) },
		{ label = '+ Add Division', args = { action = 'add' } },
		{ label = '-----Divisions-----' },
	}

	local has = false
	for divi in pairs(data.divisions) do
		has = true
		options[#options + 1] = {
			label = divi:gsub("^%l", string.upper),
			args  = { action = 'remove', divi = divi }
		}
	end
	if not has then
		options[#options + 1] = { label = 'Hich division i nadarad' }
	end

	lib.registerMenu({
		id = 'edivision_main',
		title = 'Modiriat Division',
		options = options,
	}, function(selected, scrollIndex, args)
		if not args then return end
		if args.action == 'add' then
			openAddMenu(data)
		elseif args.action == 'remove' then
			local alert = lib.alertDialog({
				header = 'Hazf Division',
				content = ('Aya az hazf division %s az %s etminan darid?'):format(args.divi, data.targetName),
				centered = true,
				cancel = true
			})
			if alert == 'confirm' then
				TriggerServerEvent('edivision:remove', data.targetId, args.divi)
			end
		end
	end)
	lib.showMenu('edivision_main')
end)
