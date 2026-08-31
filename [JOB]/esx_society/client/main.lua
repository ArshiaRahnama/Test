ESX = nil
local InBossMenu	= false
local LastPosition		= nil
local jobPermissions   = {}
local CustomVehicles   = {}

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent(Config.ESXtrigger, function(obj) ESX = obj end)
		Citizen.Wait(tonumber(0))
	end

	while ESX.GetPlayerData().job == nil do
		Citizen.Wait(10)
	end

	ESX.PlayerData = ESX.GetPlayerData()

	ESX.TriggerServerCallback('esx_society:getJobPerm', function(perms)
		jobPermissions = perms or {}
	end)

	ESX.TriggerServerCallback('esx_society:getCustomVehicles', function(list)
		CustomVehicles = list or {}
	end)
end)

exports('doesHavePerm', function(key)
	return jobPermissions[key] == true
end)

RegisterNetEvent('society:updatePermissions')
AddEventHandler('society:updatePermissions', function(perms)
	jobPermissions = perms or {}
end)

RegisterNetEvent('society:customVehiclesUpdated')
AddEventHandler('society:customVehiclesUpdated', function(list)
	CustomVehicles = list or {}
end)

-- Merges the static Config.Garage list for a job with any vehicles added live via /addcarjob.
function GetMergedGarage(job)
	local merged = {}

	for _, v in ipairs(Config.Garage[job] or {}) do
		table.insert(merged, v)
	end

	for _, v in ipairs(CustomVehicles[job] or {}) do
		table.insert(merged, {name = v.model, label = v.label})
	end

	return merged
end

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
	ESX.PlayerData.job = job

	ESX.TriggerServerCallback('esx_society:getJobPerm', function(perms)
		jobPermissions = perms or {}
	end)
end)

function OpenBossMenu(society, close, options)
	local isBoss = nil
	local options  = options or {}
	local elements = {}













	local defaultOptions = {
		withdraw  = true,
		deposit   = true,
		wash      = false,
		employees = true,
		job    = true,
	}

	for k,v in pairs(defaultOptions) do
		if options[k] == nil then
			options[k] = v
		end
	end

	local wait = true
	ESX.TriggerServerCallback('esx_society:getSocietyMoney', function(money)
		if ESX.PlayerData.job.grade >= 10 then
			if ESX.PlayerData.job.name == 'police' or ESX.PlayerData.job.name == 'sheriff' or ESX.PlayerData.job.name == 'mt' then
				if ESX.PlayerData.job.grade >= 16 then
					table.insert(elements ,{label = 'Society Money: <span style="color:green;">$'.. money .. '</span>', value = nil})
				end
			else
				table.insert(elements ,{label = 'Society Money: <span style="color:green;">$'.. money .. '</span>', value = nil})
			end
		elseif ESX.PlayerData.job.name == 'uwucafe' and ESX.PlayerData.job.grade_name == 'boss' then
			table.insert(elements ,{label = 'Society Money: <span style="color:green;">$'.. money .. '</span>', value = nil})
		end
		wait = false
	end, ESX.PlayerData.job.name)

	while wait do
		Citizen.Wait(tonumber(5))
	end

	if options.withdraw and ESX.PlayerData.job.grade >= 10 then
		if ESX.PlayerData.perm >= 15 then
			if ESX.PlayerData.job.name == 'police' or ESX.PlayerData.job.name == 'sheriff' or ESX.PlayerData.job.name == 'mt' then
				if ESX.PlayerData.job.grade >= 16 then
					table.insert(elements, {label = _U('withdraw_society_money'), value = 'withdraw_society_money'})
				end


			else
				table.insert(elements, {label = _U('withdraw_society_money'), value = 'withdraw_society_money'})
			end
		end
	end

	if options.deposit then
		table.insert(elements, {label = _U('deposit_society_money'), value = 'deposit_money'})
	end

	if options.employees and ESX.PlayerData.job.grade >= 10 then
		if ESX.PlayerData.job.name == 'police' or ESX.PlayerData.job.name == 'sheriff' or ESX.PlayerData.job.name == 'mt' then
			if ESX.PlayerData.job.grade >= 16 then
				table.insert(elements, {label = _U('employee_management'), value = 'manage_employees'})
			end
		else
			table.insert(elements, {label = _U('employee_management'), value = 'manage_employees'})
		end
	end

	if options.job and ESX.PlayerData.job.grade >= 10 then
		if ESX.PlayerData.job.name == 'police' or ESX.PlayerData.job.name == 'sheriff' or ESX.PlayerData.job.name == 'mt' then
			if ESX.PlayerData.job.grade >= 16 then
				table.insert(elements, {label = _U('manage_job'), value = 'manage_job'})
				table.insert(elements, {label = _U('manage_job_division'), value = 'manage_job_division'})
			end
		else
			table.insert(elements, {label = _U('manage_job'), value = 'manage_job'})
			table.insert(elements, {label = _U('manage_job_division'), value = 'manage_job_division'})
		end
	end

	if ESX.PlayerData.job.name == 'uwucafe' and ESX.PlayerData.job.grade_name == 'boss' then
		table.insert(elements, {label = _U('withdraw_society_money'), value = 'withdraw_society_money'})
		table.insert(elements, {label = _U('employee_management'), value = 'manage_employees'})
		table.insert(elements, {label = _U('manage_job'), value = 'manage_job'})

	end


	if ESX.PlayerData.job.grade >= 10 then
		local siblings = GetBranchSiblings(ESX.PlayerData.job.name)
		if siblings and #siblings > 0 then
			table.insert(elements, {label = 'Change Job (Branch)', value = 'change_branch_job'})
		end
	end

	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'boss_actions_' .. society, {
		title    = _U('boss_menu'),
		align    = 'top-left',
		elements = elements
	}, function(data, menu)

		if data.current.value == 'withdraw_society_money' then
			if Config.Withdraw == true then

				ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'withdraw_society_money_amount_' .. society, {
					title = _U('withdraw_amount')
				}, function(data, menu)

					local amount = tonumber(data.value)

					if amount == nil then
						ESX.ShowNotification(_U('invalid_amount'))
					else
						menu.close()
						TriggerServerEvent('esx_society:withdrawMoney', society, amount)

					end

				end, function(data, menu)
					menu.close()
				end)
			else
				ESX.ShowNotification(Config.WithdrawMsg)
			end
		elseif data.current.value == 'deposit_money' then
			OpenDepositMoney(society, close, options)
		elseif data.current.value == 'manage_employees' then
			OpenManageEmployeesMenu(society)
		elseif data.current.value == 'manage_job' then
			OpenManageJobMenu(society)
		elseif data.current.value == 'manage_job_division' then
			OpenManagedivisionMenu(society)
		elseif data.current.value == 'change_branch_job' then
			OpenChangeBranchJobMenu(society, close, options)
		end

	end, function(data, menu)
		menu.close(data, menu)



	end)

end

function GetBranchSiblings(jobName)
	for i = 1, #Config.JobGroups do
		local grp = Config.JobGroups[i]
		for j = 1, #grp.jobs do
			if grp.jobs[j] == jobName then
				local out = {}
				for k = 1, #grp.jobs do
					if grp.jobs[k] ~= jobName then
						table.insert(out, grp.jobs[k])
					end
				end
				return out, grp.id
			end
		end
	end
	return nil, nil
end

function OpenChangeBranchJobMenu(society, close, options)
	local siblings = GetBranchSiblings(ESX.PlayerData.job.name)
	if not siblings then
		ESX.ShowNotification('Your job is not part of a branch group.')
		return
	end

	local elements = {}
	for i = 1, #siblings do
		local niceLabel = (Config.JobDisplayLabels and Config.JobDisplayLabels[siblings[i]]) or siblings[i]
		table.insert(elements, {label = 'Change to ' .. niceLabel, value = siblings[i]})
	end

	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'change_branch_job_' .. society, {
		title    = 'Change Job',
		align    = 'top-left',
		elements = elements
	}, function(data, menu)
		menu.close()
		TriggerServerEvent('esx_society:changeBranchJob', data.current.value)
	end, function(data, menu)
		menu.close()
		OpenBossMenu(society, close, options)
	end)
end

function OpenManagedivisionMenu(society)
	if not InBossMenu then
		LastPosition = GetEntityCoords(PlayerPedId())
	end

	local elements = {

		{label = 'Taghir Data Division', value = 'division_change_data'},
		{label = _U('manage_division_option'), value = 'manage_division_option'},
		{label = _U('divisionmember_management'), value = 'divisionmember_management'},

	}

	ESX.UI.Menu.CloseAll()
	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'manage_job_division' .. society, {
		title    = _U('manage_job_division'),
		align    = 'top-left',
		elements = elements
	}, function(data, menu)

		if data.current.value == 'manage_division_option' then
			OpenMenuDivisionOption(society)
		end

		if data.current.value == 'division_change_data' then
			OpenMenuDivisionChangeData(society)
		end

		if data.current.value == 'divisionmember_management' then
			OpenManageDivisionMemberMenu(society)
		end

	end, function(data, menu)
		menu.close()
		OpenBossMenu(society, close, options)
	end)
end

function OpenMenuDivisionOption(society)

	if not InBossMenu then
		LastPosition = GetEntityCoords(PlayerPedId())
	end

	local elements = {
		{label = _U('manage_division_outfit'), value = 'manage_division_outfit'},
		{label = _U('manage_division_vehicle'), value = 'manage_division_vehicle'},
		{label = _U('manage_division_heli'), value = 'manage_division_heli'},
		{label = _U('manage_division_weapon'), value = 'manage_division_weapon'},
		{label = _U('manage_division_item'), value = 'manage_division_item'},
	}

	ESX.UI.Menu.CloseAll()
	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'manage_division_option' .. society, {
		title    = _U('manage_division_option'),
		align    = 'top-left',
		elements = elements
	}, function(data, menu)

		if data.current.value == 'manage_division_outfit' then
			OpenSetOutfitdivisionMenu(society)
		end

		if data.current.value == 'manage_division_vehicle' then
			OpenDivisionVehiclesManagment(society)
		end

		if data.current.value == 'manage_division_heli' then
			OpenDivisionHelissManagment(society)
		end

		if data.current.value == 'manage_division_weapon' then
			OpenDivisionweaponsManagment(society)
		end

		if data.current.value == 'manage_division_item' then
			OpenDivisionItemsManagment(society)
		end
	end, function(data, menu)
		menu.close()
		OpenManagedivisionMenu(society)
	end)
end

function OpenDivisionItemsManagment(society)
	ESX.TriggerServerCallback('esx_society:getdivision', function(DVilist)

		local elements = {}

		for i = 1, #DVilist, 1 do

			table.insert(elements, {label = '('..DVilist[i].name..')  | '..DVilist[i].label, value = DVilist[i].name})


		end

		ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'manage_grades_' .. society .. '_new', {
			title = "Manage Division",
			align = 'top-left',
			elements = elements
		}, function(data, menu)
			local diviname = data.current.value
			ChangeItemDivisionPerm(society,diviname)
		end, function(data, menu)
			menu.close()
			OpenMenuDivisionOption(society)
		end)

	end, society)
end

function ChangeItemDivisionPerm(society,DIVName)
	ESX.TriggerServerCallback('esx_society:getJobItems', function(authorizedItems)
		if authorizedItems then
			ESX.TriggerServerCallback('esx_society:getDivisionItems', function(items)
				local rows = {}

				for k, society_items in ipairs(authorizedItems) do
					local found = false

					if items then

						for k2, item_state in ipairs(items) do
							if string.lower(society_items.name) == string.lower(item_state.name) then
								if item_state.status == true then
									table.insert(rows, { label = society_items.label .. " | [<font color=Lime>✅</font>]", name = item_state.name, Itemslabel = society_items.label, value = item_state.status })
								elseif item_state.status == false then
									table.insert(rows, { label = society_items.label .. " | [<font color=red>❌</font>]", name = item_state.name, Itemslabel = society_items.label, value = item_state.status })
								end

								found = true
								break
							end
						end
					end

					if not found then
						table.insert(rows, { label = society_items.label .. " | [<font color=red>❌</font>]", name = society_items.name, Itemslabel = society_items.label, value = false })
					end
				end
				ESX.UI.Menu.CloseAll()
				ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'manage_grades_Items_' .. society .. '', {
					title = "Manage Inventory",
					align = 'top-left',
					elements = rows
				}, function(data, menu)
					local state = data.current.value
					local name = data.current.name
					if state then
						ESX.TriggerServerCallback('esx_society:setDivisionItemPerm', function(result)

							ChangeItemDivisionPerm(society,DIVName)

						end, society, DIVName, rows, false, name, data.current.Itemslabel)
					else
						ESX.TriggerServerCallback('esx_society:setDivisionItemPerm', function(result)

							ChangeItemDivisionPerm(society,DIVName)

						end, society, DIVName, rows, true, name, data.current.Itemslabel)
					end

				end, function(data, menu)
					menu.close()
					OpenDivisionItemsManagment(society)
				end)

			end, DIVName, society)
		else
			ESX.ShowNotification("Error loading Items !")
		end
	end, society)
end

function OpenDivisionweaponsManagment(society)
	ESX.TriggerServerCallback('esx_society:getdivision', function(DVilist)

		local elements = {}

		for i = 1, #DVilist, 1 do

			table.insert(elements, {label = '('..DVilist[i].name..')  | '..DVilist[i].label, value = DVilist[i].name})

		end

		ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'manage_grades_' .. society .. '_new', {
			title = "Manage Division",
			align = 'top-left',
			elements = elements
		}, function(data, menu)
			local diviname = data.current.value
			ChangeWeaponDivisionPerm(society,diviname)
		end, function(data, menu)
			menu.close()
			OpenMenuDivisionOption(society)
		end)

	end, society)
end

function ChangeWeaponDivisionPerm(society,DivisionName)

	local authorizedWeapons = Config.Armory[society]
	if authorizedWeapons then
		ESX.TriggerServerCallback('esx_society:getWeaponsdivisions', function(weapons)
			local rows = {}

			for k, society_weapons in ipairs(authorizedWeapons) do

				local found = false

				if weapons then

					for k2, weapon_state in ipairs(weapons) do
						if string.lower(society_weapons) == string.lower(weapon_state.model) then
							if weapon_state.status == true then
								table.insert(rows, { label = GetModelLabel(weapon_state.model) .. " | [<font color=Lime>✅</font>]", model = weapon_state.model, value = weapon_state.status })
							elseif weapon_state.status == false then
								table.insert(rows, { label = GetModelLabel(weapon_state.model) .. " | [<font color=red>❌</font>]", model = weapon_state.model, value = weapon_state.status })
							end

							found = true
							break
						end
					end
				end

				if not found then
					table.insert(rows, { label = GetModelLabel(society_weapons) .. " | [<font color=red>❌</font>]", model = society_weapons, value = false })
				end
			end
			ESX.UI.Menu.CloseAll()
			ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'manage_grades_weapons_' .. society .. '', {
				title = "Manage Weapons",
				align = 'top-left',
				elements = rows
			}, function(data, menu)
				local state = data.current.value
				local model = data.current.model
				if state then
					ESX.TriggerServerCallback('esx_society:setDivisionWeapPerm', function(result)

						ChangeWeaponDivisionPerm(society,DivisionName)


					end, society, DivisionName, rows, false, model)
				else
					ESX.TriggerServerCallback('esx_society:setDivisionWeapPerm', function(result)

						ChangeWeaponDivisionPerm(society,DivisionName)

					end, society, DivisionName, rows, true, model)
				end

			end, function(data, menu)
				OpenDivisionweaponsManagment(society)
				menu.close()

			end)

		end, DivisionName, society)
	else
		ESX.ShowNotification("Error loading Weapons !")
	end

end

function OpenDivisionHelissManagment(society)
	ESX.TriggerServerCallback('esx_society:getdivision', function(DVilist)

		local elements = {}

		for i = 1, #DVilist, 1 do

			table.insert(elements, {label = '('..DVilist[i].name..')  | '..DVilist[i].label, value = DVilist[i].name})


		end

		ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'manage_grades_' .. society .. '_new', {
			title = "Manage Division",
			align = 'top-left',
			elements = elements
		}, function(data, menu)
			local diviname = data.current.value
			ChangeHelidivisionPerm(society,diviname)
		end, function(data, menu)
			menu.close()
			OpenMenuDivisionOption(society)
		end)

	end, society)
end

function ChangeHelidivisionPerm(society,DivisionName)
	local authorizedHelis = Config.Heli[society]
	if authorizedHelis then
		ESX.TriggerServerCallback('esx_society:getHelisdivision', function(helis)

			local rows = {}

			for k, society_Helis in ipairs(authorizedHelis) do
				local found = false

				if helis then

					for k2, Heli_state in ipairs(helis) do

						if string.lower(society_Helis.name) == string.lower(Heli_state.model) then
							if GetDisplayNameFromVehicleModel(GetHashKey(Heli_state.model)) then
								if Heli_state.status == true then
									table.insert(rows, { label = society_Helis.label .. " | [<font color=Lime>✅</font>]", model = Heli_state.model, Helilabel = society_Helis.label, value = Heli_state.status })
								elseif Heli_state.status == false then
									table.insert(rows, { label = society_Helis.label .. " | [<font color=red>❌</font>]", model = Heli_state.model, Helilabel = society_Helis.label, value = Heli_state.status })
								end
							else
								table.insert(rows, { label = society_Helis.label .. " | [<font color=yellow>Unknown</font>]", model = Heli_state.model, Helilabel = society_Helis.label, value = Heli_state.status })
							end

							found = true
							break
						end

					end
				end

				if not found then
					table.insert(rows, { label = society_Helis.label .. " | [<font color=red>❌</font>]", model = society_Helis.name, Helilabel = society_Helis.label, value = false })
				end
			end
			ESX.UI.Menu.CloseAll()
			ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'manage_grades_Helis_' .. society .. '', {
				title = "Manage Helis Division",
				align = 'top-left',
				elements = rows
			}, function(data, menu)
				local state = data.current.value
				local model = data.current.model
				if state then
					ESX.TriggerServerCallback('esx_society:setSocietyHelidivisionPerm', function(result)

						ChangeHelidivisionPerm(society,DivisionName)

					end, society, DivisionName, rows, false, model, data.current.Helilabel)
				else
					ESX.TriggerServerCallback('esx_society:setSocietyHelidivisionPerm', function(result)

						ChangeHelidivisionPerm(society,DivisionName)

					end, society, DivisionName, rows, true, model, data.current.Helilabel)
				end

			end, function(data, menu)
				menu.close()
				OpenDivisionHelissManagment(society)
			end)
		end, DivisionName, society)
	else
		ESX.ShowNotification("Error loading helis !")
	end
end

function OpenDivisionVehiclesManagment(society)
	ESX.TriggerServerCallback('esx_society:getdivision', function(DVilist)

		local elements = {}

		for i = 1, #DVilist, 1 do

			table.insert(elements, {label = '('..DVilist[i].name..')  | '..DVilist[i].label, value = DVilist[i].name})


		end

		ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'manage_grades_' .. society .. '_new', {
			title = "Manage Division",
			align = 'top-left',
			elements = elements
		}, function(data, menu)
			local diviname = data.current.value
			ChangeVehicledivisionPerm(society,diviname)
		end, function(data, menu)
			menu.close()
			OpenMenuDivisionOption(society)
		end)

	end, society)
end

function ChangeVehicledivisionPerm(society,DivisionName)
	local authorizedVehicles = GetMergedGarage(society)
	if authorizedVehicles then
		ESX.TriggerServerCallback('esx_society:getVehiclesdivision', function(vehs)

			local rows = {}

			for k, society_vehicles in ipairs(authorizedVehicles) do
				local found = false

				if vehs then

					for k2, vehicle_state in ipairs(vehs) do
						if string.lower(society_vehicles.name) == string.lower(vehicle_state.model) then
							if GetDisplayNameFromVehicleModel(GetHashKey(vehicle_state.model)) then
								if vehicle_state.status == true then
									table.insert(rows, { label = society_vehicles.label .. " | [<font color=Lime>✅</font>]", model = vehicle_state.model, Vehiclelabel = society_vehicles.label, value = vehicle_state.status })
								elseif vehicle_state.status == false then
									table.insert(rows, { label = society_vehicles.label .. " | [<font color=red>❌</font>]", model = vehicle_state.model, Vehiclelabel = society_vehicles.label, value = vehicle_state.status })
								end
							else
								table.insert(rows, { label = vehicle_state.model .. " | [<font color=yellow>Unknown</font>]", model = vehicle_state.model, Vehiclelabel = society_vehicles.label, value = vehicle_state.status })
							end

							found = true
							break
						end

					end
				end

				if not found then
					table.insert(rows, { label = society_vehicles.label .. " | [<font color=red>❌</font>]", model = society_vehicles.name, Vehiclelabel = society_vehicles.label, value = false })
				end
			end
			ESX.UI.Menu.CloseAll()
			ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'manage_grades_vehicles_' .. society .. '', {
				title = "Manage Vehicles Division",
				align = 'top-left',
				elements = rows
			}, function(data, menu)
				local state = data.current.value
				local model = data.current.model
				if state then
					ESX.TriggerServerCallback('esx_society:setSocietyVehdivisionPerm', function(result)

						ChangeVehicledivisionPerm(society,DivisionName)

					end, society, DivisionName, rows, false, model, data.current.Vehiclelabel)
				else
					ESX.TriggerServerCallback('esx_society:setSocietyVehdivisionPerm', function(result)

						ChangeVehicledivisionPerm(society,DivisionName)

					end, society, DivisionName, rows, true, model, data.current.Vehiclelabel)
				end

			end, function(data, menu)
				menu.close()
				OpenDivisionVehiclesManagment(society)
			end)
		end, DivisionName, society)
	else
		ESX.ShowNotification("Error loading Vehicles !")
	end
end

function OpenManageDivisionMemberMenu(society)

	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'divisionmember_management' .. society, {
		title    = 'Modiriat A\'aza Division',
		align    = 'top-left',
		elements = {


			{label = 'Set Kardan A\'za Division', value = 'set_division'},
			{label = 'Hazf A\'za Division', value = 'remove_division'}
		}
	}, function(data, menu)









		if data.current.value == 'set_division' then
			OpenSetDivisionMemberMenu(society)
		end

		if data.current.value == 'remove_division' then
			OpenRemoveDivisionMemberMenu(society)
		end

	end, function(data, menu)
		menu.close()
		OpenManagedivisionMenu(society)
	end)
end

function RemoveplayerDivision(society, identifier)
	local dvelement = {}
	local elementsender = {}
	ESX.UI.Menu.CloseAll()
	ESX.TriggerServerCallback('esx_society:getdivision', function(DVilist)
		ESX.TriggerServerCallback('esx_society:GetDivisionsPlayer', function(checks)

			local checkss = checks or {}
			table.insert(dvelement, {label = "Name | Label", division = nil})
			for i = 1, #DVilist, 1 do
				local isDuplicate = true


				for k, check in pairs(checkss) do
					if check.name == DVilist[i].name then
						isDuplicate = false
						break
					end
				end


				if not isDuplicate then

					table.insert(dvelement, {
						label = '(' .. DVilist[i].name .. ')  | ' .. DVilist[i].label,
						division = DVilist[i].name,
						dvlabel = DVilist[i].label,
						identifier = identifier,
					})
				end
			end




			ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'manage_division_option' .. society, {
				title    = _U('manage_division_option'),
				align    = 'top-left',
				elements = dvelement
			}, function(data, menu)
				elementsender = {
					job = society,
					name = data.current.division,
					status = false

				}
				if data.current.division ~= nil then


					ESX.TriggerServerCallback('esx_society:setJobDivision', function(cakk)

					end, data.current.identifier, society, elementsender, 'fire')
					RemoveplayerDivision(society, data.current.identifier)
				end
			end, function(data, menu)
				menu.close()
				OpenRemoveDivisionMemberMenu(society)
			end)
		end, identifier)

	end, society)
end

function OpenRemoveDivisionMemberMenu(society)

	ESX.TriggerServerCallback('esx_society:getOnlinePlayersDivision', function(players)

		local elements = {}

		for i=1, #players, 1 do


				table.insert(elements, {
					label = string.gsub(players[i].name,"_", " "),
					value = players[i].source,
					name = players[i].name,
					identifier = players[i].identifier
				})

		end

		ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'recruit_confirm_' .. society, {
			title    = _U('division_remove'),
			align    = 'top-left',
			elements = elements
		}, function(data, menu)

			RemoveplayerDivision(society, data.current.identifier)

		end, function(data, menu)
			menu.close()
			OpenManageDivisionMemberMenu(society)
		end)

	end, society)
end

function OpenSetDivisionMemberMenu(society)

	ESX.TriggerServerCallback('esx_society:getOnlinePlayersDivision', function(players)

		local elements = {}

		for i=1, #players, 1 do


				table.insert(elements, {
					label = string.gsub(players[i].name,"_", " "),
					value = players[i].source,
					name = players[i].name,
					identifier = players[i].identifier
				})

		end

		ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'recruit_confirm_' .. society, {
			title    = _U('division_set'),
			align    = 'top-left',
			elements = elements
		}, function(data, menu)

			SetplayerDivision(society, data.current.identifier)

		end, function(data, menu)
			menu.close()
			OpenManageDivisionMemberMenu(society)
		end)

	end, society)
end

function SetplayerDivision(society, identifier)
	local dvelement = {}
	local elementsender = {}
	ESX.UI.Menu.CloseAll()
	ESX.TriggerServerCallback('esx_society:getdivision', function(DVilist)
		ESX.TriggerServerCallback('esx_society:GetDivisionsPlayer', function(checks)

			local checkss = checks or {}
			table.insert(dvelement, {label = "Name | Label", division = nil})
			for i = 1, #DVilist, 1 do
				local isDuplicate = false


				for k, check in pairs(checkss) do
					if check.name == DVilist[i].name then
						isDuplicate = true
						break
					end
				end


				if not isDuplicate then

					table.insert(dvelement, {
						label = '(' .. DVilist[i].name .. ')  | ' .. DVilist[i].label,
						division = DVilist[i].name,
						dvlabel = DVilist[i].label,
						identifier = identifier,
					})
				end
			end




			ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'manage_division_option' .. society, {
				title    = _U('manage_division_option'),
				align    = 'top-left',
				elements = dvelement
			}, function(data, menu)
				elementsender = {
					job = society,
					name = data.current.division,
					label = data.current.dvlabel,
					status = false

				}
				if data.current.division ~= nil then


					ESX.TriggerServerCallback('esx_society:setJobDivision', function(cakk)

					end, data.current.identifier, society, elementsender, 'hire')
					SetplayerDivision(society, data.current.identifier)
				end
			end, function(data, menu)
				menu.close()
				OpenSetDivisionMemberMenu(society)
			end)
		end, identifier)

	end, society)
end

function OpenMenuDivisionChangeData(society)

	if not InBossMenu then
		LastPosition = GetEntityCoords(PlayerPedId())
	end

	local elements = {
		{label = 'Ezafe Kardan Division', value = 'crate_division'},
		{label = 'Hazf Kardan Division', value = 'remove_division'},
		{label = 'Taghir Esm Division', value = 'manage_division_edit'},
	}

	ESX.UI.Menu.CloseAll()
	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'division_change_data' .. society, {
		title    = _U('edit_division'),
		align    = 'top-left',
		elements = elements
	}, function(data, menu)

		if data.current.value == 'crate_division' then
			OpenMenuCreateDivision(society)
		end

		if data.current.value == 'remove_division' then
			OpenMenuRemoveDivision(society)
		end

		if data.current.value == 'manage_division_edit' then
			OpenMenuEditDivision(society)
		end



	end, function(data, menu)
		menu.close()
		OpenManagedivisionMenu(society)
	end)

end

function OpenMenuEditDivision(society)

	ESX.TriggerServerCallback('esx_society:getdivision', function(division)
		local elements = {}

		for i=tonumber(1), #division, tonumber(1) do
			local divisionLabel = (division[i].label == '' and division.label or division[i].label)
			table.insert(elements, {label = '('..division[i].name..')  | '..divisionLabel, division = division[i].name, dvlabel = divisionLabel, dvid = division[i].id})
		end
		  ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'manage_division_edit', {
			title    = _U('manage_division_edit'),
			align    = 'top-left',
			elements = elements
		}, function(data, menu)

			lib.registerContext({
				id = 'change_menu',
				title = 'Taghir Option',
				options = {
					{
						title = 'Taghir Esm',
						onSelect = function()
							local newName = lib.inputDialog('Enter New Name', {'New Name'})
							local newName1 = newName[1]
							if newName1 ~= ""  then

								if newName[1] == "" then
									TriggerEvent('chat:addMessage', {args = {'^1SYSTEM', 'Tedad Vorodi Bayad Bishtar Az ^21^0 Character Bashad'}})
									lib.showContext('change_menu')
									return
								elseif #newName[1] > 12 then
									lib.showContext('change_menu')
									TriggerEvent('chat:addMessage', {args = {'^1SYSTEM', 'Tedad Vorodi Bayad Kamtar az ^212^0 Character Bashad'}})
									return
								elseif checkinputuper(newName[1]) then
									newName1 = newName[1]:sub(1, 1):lower()..newName[1]:sub(2)

								end

								ESX.TriggerServerCallback('esx_society:ChangeDivision', function(caalback)

									OpenMenuEditDivision(society)

								end,society, data.current.dvid, newName1, 'name')

							else
								lib.showContext('change_menu')
							end
						end



					},
					{
						title = 'Taghir Label',
						onSelect = function()
							local inputLabel = lib.inputDialog('Enter New Label', {'New Label'})
							local newLabel = inputLabel[1]
							if newLabel ~= "" then
								if newLabel == "" then
									TriggerEvent('chat:addMessage', {args = {'^1SYSTEM', 'Tedad Vorodi Bayad Bishtar Az ^21^0 Character Bashad'}})
									lib.showContext('change_menu')
									return

								elseif #newLabel > 12 then
									lib.showContext('change_menu')
									TriggerEvent('chat:addMessage', {args = {'^1SYSTEM', 'Tedad Vorodi Bayad Kamtar az ^212^0 Character Bashad'}})
									return
								elseif not checkinputuper(newLabel) then
									newLabel = newLabel:sub(1, 1):upper()..newLabel:sub(2)

								end

								ESX.TriggerServerCallback('esx_society:ChangeDivision', function(caalback)

									OpenMenuEditDivision(society)

								end,society, data.current.dvid, newLabel, 'label')
							else
								lib.showContext('change_menu')
							end
						end
					}

				}
			})
			lib.showContext('change_menu')

		end, function(data, menu)
			menu.close()
		  end)
	end, society)
end

function OpenMenuRemoveDivision(society)

	ESX.TriggerServerCallback('esx_society:getdivision', function(division)
		local elements = {}

		for i=tonumber(1), #division, tonumber(1) do
			local divisionLabel = (division[i].label == '' and division.label or division[i].label)
			table.insert(elements, {label = '('..division[i].name..')  | '..divisionLabel, division = division[i].name, dvlabel = divisionLabel})
		end
		  ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'remove_division', {
			title    = 'Hazf Kardan Division',
			align    = 'top-left',
			elements = elements
		}, function(data, menu)
			local messages ='Aya Mikhahid Division  \n  ( '..data.current.division..' )  \n  Ra Hazf Konid ?'
			local alert = lib.alertDialog({
				header = 'Remove Division',
				content = messages,
				centered = true,
				cancel = true,
			})
				if alert == 'confirm' then

					ESX.TriggerServerCallback('esx_society:RemoveDivision', function(caalback)

						OpenMenuRemoveDivision(society)
					end, data.current.division, data.current.dvlabel)

				else
					TriggerEvent('chat:addMessage', {
						args = {'^1SYSTEM', 'Cancel Shod'}
					})
				end
		end, function(data, menu)
			menu.close()
		  end)
	end, society)
end

function checkinputuper(str)
    if str and #str > 0 then
        local firstChar = str:sub(1, 1)
        return firstChar:match("%u") ~= nil
    end
    return false
end

function OpenMenuCreateDivision(society)
	local input = lib.inputDialog('Esm Division Ra Vared Konid', {'Esm Division', 'Label Division'})
	local input1 = input[1]
	local input2 = input[2]
	if input[1] == "" then
		TriggerEvent('chat:addMessage', {args = {'^1SYSTEM', 'Tedad Vorodi Bayad Bishtar Az ^21^0 Character Bashad'}})
		OpenMenuCreateDivision(society)
		return
	elseif input[2] == "" then
		TriggerEvent('chat:addMessage', {args = {'^1SYSTEM', 'Tedad Vorodi Bayad Bishtar Az ^21^0 Character Bashad'}})
		OpenMenuCreateDivision(society)
		return
	elseif #input[1] > 12 or #input[2] > 12 then
		TriggerEvent('chat:addMessage', {args = {'^1SYSTEM', 'Tedad Vorodi Bayad Kamtar az ^212^0 Character Bashad'}})
		return
	elseif not checkinputuper(input[2]) then
		input2 = input2:sub(1, 1):upper()..input2:sub(2)
	elseif checkinputuper(input[1]) then
		input1 = string.lower(input1)

	end

	ESX.TriggerServerCallback('esx_society:CreateDivision', function(ccalback)

		ccalback = ccalback

	end, input1, input2)
end

function OpenManageJobMenu(society)
	local elements = {}

	ESX.TriggerServerCallback('esx_society:GetPermWashMoney', function(Wash)
		if not InBossMenu then
			LastPosition = GetEntityCoords(PlayerPedId())
		end

		if ESX.PlayerData.perm >= 9 then
			table.insert(elements, {label = _U('salary_management'), value = 'manage_grades'})
		end

		table.insert(elements, {label = _U('manage_grades_name'), value = 'manage_grades_name'})
		table.insert(elements, {label = 'Modiriat Grade (Advanced)', value = 'manage_grades_advanced'})
		table.insert(elements, {label = _U('manage_grades_outfit'), value = 'manage_grades_outfit'})

		if ESX.PlayerData.job.name ~= 'uwucafe' then
			table.insert(elements, {label = _U('manage_weapons'), value = 'manage_weapons'})
			table.insert(elements, {label = _U('manage_vehicles'), value = 'manage_vehicles'})
			table.insert(elements, {label = _U('manage_helis'), value = 'manage_helis'})
		end

		table.insert(elements, {label = _U('manage_inventory'), value = 'manage_inventory'})

		if ESX.PlayerData.job.grade >= 16 then

			if Wash == "true" then
				table.insert(elements, { label = 'wash money' .. " | [<font color=Lime>✅</font>]", isonoff = false, value = 'wash_money' })
			else
				table.insert(elements, { label = 'wash money' .. " | [<font color=red>❌</font>]", isonoff = true, value = 'wash_money' })
			end


		end

		ESX.UI.Menu.CloseAll()
		ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'manage_job' .. society, {
			title    = _U('manage_job'),
			align    = 'top-left',
			elements = elements
		}, function(data, menu)

			if data.current.value == 'manage_grades' then
				OpenManageGradesMenu(society)
			end

			if data.current.value == 'manage_grades_name' then
				OpenGradeNames(society)
			end

			if data.current.value == 'manage_grades_advanced' then
				OpenAdvancedGradeMenu(society)
			end

			if data.current.value == 'manage_grades_outfit' then
				OpenSetOutfitMenu(society)
			end

			if data.current.value == 'manage_weapons' then

				OpenWeaponsManagment(society)

			end

			if data.current.value == 'manage_vehicles' then

				OpenVehiclesManagment(society)

			end

			if data.current.value == 'manage_helis' then

				OpenHelisManagment(society)

			end

			if data.current.value == 'manage_inventory' then

				OpenInventoryManagment(society)

			end

			if data.current.value == 'wash_money' then

				TriggerServerEvent('esx_society:SetPermWash', ESX.PlayerData.job.name, tostring(data.current.isonoff))
				Citizen.Wait(300)
				OpenManageJobMenu(society)
			end

		end, function(data, menu)
			OpenBossMenu(society, close, options)
			menu.close()
		end)
	end, ESX.PlayerData.job.name)
end

function OpenInventoryManagment(society)
	ESX.TriggerServerCallback('esx_society:getJob', function(job)
		local elements = {}
		for i=tonumber(1), #job.grades, tonumber(1) do
			local gradeLabel = (job.grades[i].label == '' and job.label or job.grades[i].label)
			if job.grades[i].grade <= ESX.PlayerData.job.grade then
				table.insert(elements, {label = '('..job.grades[i].grade..')  | '..gradeLabel, grade = job.grades[i].grade})
			end
		end
        ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'manage_grades_' .. society .. '_new', {
            title = "Manage Grades",
            align = 'top-left',
            elements = elements
        }, function(data, menu)
            local gradeNumber = tonumber(data.current.grade)
				ChangeInventoryPerm(society,gradeNumber)
		end, function(data, menu)
			OpenManageJobMenu(society)
			menu.close()
		end)
	end, society)
end

function ChangeInventoryPerm(society,rank)

	ESX.TriggerServerCallback('esx_society:getJobItems', function(authorizedItems)
		if authorizedItems then
			ESX.TriggerServerCallback('esx_society:getItems', function(items)
				local rows = {}

				for k, society_items in ipairs(authorizedItems) do
					local found = false

					if items then

						for k2, item_state in ipairs(items) do
							if string.lower(society_items.name) == string.lower(item_state.name) then
								if item_state.status == true then
									table.insert(rows, { label = society_items.label .. " | [<font color=Lime>✅</font>]", name = item_state.name, Itemlabel = society_items.label, value = item_state.status })
								elseif item_state.status == false then
									table.insert(rows, { label = society_items.label .. " | [<font color=red>❌</font>]", name = item_state.name, Itemlabel = society_items.label, value = item_state.status })
								end

								found = true
								break
							end
						end
					end

					if not found then
						table.insert(rows, { label = society_items.label .. " | [<font color=red>❌</font>]", name = society_items.name, Itemlabel = society_items.label, value = false })
					end
				end
				ESX.UI.Menu.CloseAll()
				ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'manage_grades_Items_' .. society .. '', {
					title = "Manage Inventory",
					align = 'top-left',
					elements = rows
				}, function(data, menu)
					local state = data.current.value
					local name = data.current.name
					if state then
						ESX.TriggerServerCallback('esx_society:setSocietyItemPerm', function(result)

							ChangeInventoryPerm(society,rank)

						end, society, rank, rows, false, name, data.current.Itemlabel)
					else
						ESX.TriggerServerCallback('esx_society:setSocietyItemPerm', function(result)

							ChangeInventoryPerm(society,rank)

						end, society, rank, rows, true, name, data.current.Itemlabel)
					end

				end, function(data, menu)
					menu.close()
					OpenInventoryManagment(society)
				end)

			end, rank, society)
		else
			ESX.ShowNotification("Error loading Items !")
		end
	end, society)
end

function OpenVehiclesManagment(society)
	ESX.TriggerServerCallback('esx_society:getJob', function(job)
		local elements = {}
		Wait(100)
		for i=tonumber(1), #job.grades, tonumber(1) do
			local gradeLabel = (job.grades[i].label == '' and job.label or job.grades[i].label)
			if job.grades[i].grade <= ESX.PlayerData.job.grade then
				table.insert(elements, {label = '('..job.grades[i].grade..')  | '..gradeLabel, grade = job.grades[i].grade})
			end
		end
        ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'manage_grades_' .. society .. '_new', {
            title = "Manage Grades",
            align = 'top-left',
            elements = elements
        }, function(data, menu)
            local gradeNumber = tonumber(data.current.grade)
				ChangeVehiclePerm(society,gradeNumber)
		end, function(data, menu)
			menu.close()
			OpenManageJobMenu(society)
		end)
	end, society)
end

function OpenHelisManagment(society)
	ESX.TriggerServerCallback('esx_society:getJob', function(job)
		local elements = {}
		for i=tonumber(1), #job.grades, tonumber(1) do
			local gradeLabel = (job.grades[i].label == '' and job.label or job.grades[i].label)
			if job.grades[i].grade <= ESX.PlayerData.job.grade then
				table.insert(elements, {label = '('..job.grades[i].grade..')  | '..gradeLabel, grade = job.grades[i].grade})
			end
		end
        ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'manage_grades_' .. society .. '_new', {
            title = "Manage Grades",
            align = 'top-left',
            elements = elements
        }, function(data, menu)
            local gradeNumber = tonumber(data.current.grade)
			ChangeHeliPerm(society,gradeNumber)
		end, function(data, menu)
			menu.close()

		end)
	end, society)
end

function ChangeVehiclePerm(society,rank)

	local authorizedVehicles = GetMergedGarage(society)
	if authorizedVehicles then

		if authorizedVehicles then
			ESX.TriggerServerCallback('esx_society:getVehicles', function(vehs)
				local rows = {}

				for k, society_vehicles in ipairs(authorizedVehicles) do
					local found = false

					if vehs then

						for k2, vehicle_state in ipairs(vehs) do
							if string.lower(society_vehicles.name) == string.lower(vehicle_state.model) then
								if GetDisplayNameFromVehicleModel(GetHashKey(vehicle_state.model)) then
									if vehicle_state.status == true then
										table.insert(rows, { label = society_vehicles.label .. " | [<font color=Lime>✅</font>]", model = vehicle_state.model, labelVeh = society_vehicles.label , value = vehicle_state.status })
									elseif vehicle_state.status == false then
										table.insert(rows, { label = society_vehicles.label .. " | [<font color=red>❌</font>]", model = vehicle_state.model, labelVeh = society_vehicles.label , value = vehicle_state.status })
									end
								else
									table.insert(rows, { label = society_vehicles.label .. " | [<font color=yellow>Unknown</font>]", model = vehicle_state.model, labelVeh = society_vehicles.label , value = vehicle_state.status })
								end

								found = true
								break
							end
						end
					end

					if not found then
						table.insert(rows, { label = society_vehicles.label .. " | [<font color=red>❌</font>]", model = society_vehicles.name, labelVeh = society_vehicles.label, value = false })
					end
				end
				ESX.UI.Menu.CloseAll()
				ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'manage_grades_vehicles_' .. society .. '', {
					title = "Manage Vehicles",
					align = 'top-left',
					elements = rows
				}, function(data, menu)
					local state = data.current.value
					local model = data.current.model
					if state then
						ESX.TriggerServerCallback('esx_society:setSocietyVehPerm', function(result)

							ChangeVehiclePerm(society,rank)

						end, society, rank, rows, false, model, data.current.labelVeh)
					else
						ESX.TriggerServerCallback('esx_society:setSocietyVehPerm', function(result)

							ChangeVehiclePerm(society,rank)

						end, society, rank, rows, true, model, data.current.labelVeh)
					end

				end, function(data, menu)
					menu.close()
					OpenVehiclesManagment(society)
				end)
			end, rank, society)
		end
	end
end

function ChangeHeliPerm(society,rank)

		local authorizedHelis = Config.Heli[society]

	if authorizedHelis then
		ESX.TriggerServerCallback('esx_society:getHelis', function(helis)
			local rows = {}

			for k, society_helis in ipairs(authorizedHelis) do
				local found = false

				if helis then

					for k2, heli_state in ipairs(helis) do

						if string.lower(society_helis.name) == string.lower(heli_state.model) then
							if GetDisplayNameFromVehicleModel(GetHashKey(heli_state.model)) then
								if heli_state.status == true then
									table.insert(rows, { label = society_helis.label .. " | [<font color=Lime>✅</font>]", model = heli_state.model, helimodel = society_helis.label , value = heli_state.status })
								elseif heli_state.status == false then
									table.insert(rows, { label = society_helis.label .. " | [<font color=red>❌</font>]", model = heli_state.model, helimodel = society_helis.label , value = heli_state.status })
								end
							else
								table.insert(rows, { label = society_helis.label .. " | [<font color=yellow>Unknown</font>]", model = heli_state.model, helimodel = society_helis.label , value = heli_state.status })
							end

							found = true
							break
						end
					end
				end

				if not found then
					table.insert(rows, { label = society_helis.name .. " | [<font color=red>❌</font>]", model = society_helis.name, helimodel = society_helis.label , value = false })
				end

			end
			ESX.UI.Menu.CloseAll()
			ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'manage_grades_Helis_' .. society .. '', {
				title = "Manage Helis",
				align = 'top-left',
				elements = rows
			}, function(data, menu)
				local state = data.current.value
				local model = data.current.model
				if state and model then
					ESX.TriggerServerCallback('esx_society:setSocietyHeliPerm', function(result)

						ChangeHeliPerm(society,rank)

					end, society, rank, rows, false, model, data.current.helimodel)
				else
					ESX.TriggerServerCallback('esx_society:setSocietyHeliPerm', function(result)

						ChangeHeliPerm(society,rank)

					end, society, rank, rows, true, model, data.current.helimodel)
				end

			end, function(data, menu)
				OpenHelisManagment(society)
				menu.close()

			end)

		end, rank, society)
	end
end

function OpenWeaponsManagment(society)
	ESX.TriggerServerCallback('esx_society:getJob', function(job)
		local elements = {}
	    for i=tonumber(1), #job.grades, tonumber(1) do
			local gradeLabel = (job.grades[i].label == '' and job.label or job.grades[i].label)
			if job.grades[i].grade <= ESX.PlayerData.job.grade then
				table.insert(elements, {label = '('..job.grades[i].grade..')  | '..gradeLabel, grade = job.grades[i].grade})
			end
		end

        ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'manage_grades_' .. society .. '_new', {
            title = "Manage Grades",
            align = 'top-left',
            elements = elements
        }, function(data, menu)
            local gradeNumber = tonumber(data.current.grade)
				ChangeWeaponPerm(society,gradeNumber)
		end, function(data, menu)
			menu.close()
		end)
	end, society)
end

function ChangeWeaponPerm(society,rank)

	local authorizedWeapons = Config.Armory[society]
	if authorizedWeapons then
		ESX.TriggerServerCallback('esx_society:getWeapons', function(weapons)
			local rows = {}

			for k, society_weapons in ipairs(authorizedWeapons) do

				local found = false

				if weapons then

					for k2, weapon_state in ipairs(weapons) do
						if string.lower(society_weapons) == string.lower(weapon_state.model) then
							if weapon_state.status == true then
								table.insert(rows, { label = GetModelLabel(weapon_state.model) .. " | [<font color=Lime>✅</font>]", model = weapon_state.model, value = weapon_state.status })
							elseif weapon_state.status == false then
								table.insert(rows, { label = GetModelLabel(weapon_state.model) .. " | [<font color=red>❌</font>]", model = weapon_state.model, value = weapon_state.status })
							end

							found = true
							break
						end
					end
				end

				if not found then
					table.insert(rows, { label = GetModelLabel(society_weapons) .. " | [<font color=red>❌</font>]", model = society_weapons, value = false })
				end
			end
			ESX.UI.Menu.CloseAll()
			ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'manage_grades_weapons_' .. society .. '', {
				title = "Manage Weapons",
				align = 'top-left',
				elements = rows
			}, function(data, menu)
				local state = data.current.value
				local model = data.current.model
				if state then
					ESX.TriggerServerCallback('esx_society:setSocietyWeapPerm', function(result)

						ChangeWeaponPerm(society,rank)


					end, society, rank, rows, false, model)
				else
					ESX.TriggerServerCallback('esx_society:setSocietyWeapPerm', function(result)

						ChangeWeaponPerm(society,rank)

					end, society, rank, rows, true, model)
				end

			end, function(data, menu)
				OpenWeaponsManagment(society)
				menu.close()

			end)

		end, rank, society)
	else
		ESX.ShowNotification("Error loading Weapons !")
	end

end

function OpenGradeNames(society)
	ESX.TriggerServerCallback('esx_society:getJob', function(job)
		  local elements = {}

		for i=tonumber(1), #job.grades, tonumber(1) do
			local gradeLabel = (job.grades[i].label == '' and job.label or job.grades[i].label)
			if job.grades[i].grade <= ESX.PlayerData.job.grade then
				table.insert(elements, {label = '('..job.grades[i].grade..')  | '..gradeLabel, grade = job.grades[i].grade})
			end
		end

		ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'manage_grades_name', {
			title    = _U('manage_grades_name'),
			align    = 'top-left',
			elements = elements
		}, function(data, menu)

			ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'rename_grade', {
                title    = "Esm jadid rank ra vared konid",

			}, function(data2, menu2)

				if not data2.value then
					ESX.ShowNotification("Shoma dar ghesmat esm jadid chizi vared nakardid!")
					return
				end






				if string.len(ESX.Math.Trim(data2.value)) >= 3 and string.len(ESX.Math.Trim(data2.value)) <= 25 then
					menu2.close()
					menu.close()
					ESX.TriggerServerCallback('esx_society:renameGrade', function(refresh)
					end, tonumber(data.current.grade), data2.value)
					Citizen.Wait(500)
					OpenGradeNames(society)
					ESX.ShowNotification("~w~Changed to ~y~" .. data2.value)
				else
					ESX.ShowNotification("Tedad character esm grade bayad bishtar az ~g~3 ~w~0 va kamtar az ~g~25 ~o~character ~w~bashad!")
				end

            end, function (data2, menu2)
                menu2.close()
            end)

		end, function(data, menu)

			menu.close()
		end)
	end, society)
end

function OpenAdvancedGradeMenu(society)
	ESX.TriggerServerCallback('esx_society:getJob', function(job)
		local elements = {}

		for i=1, #job.grades, 1 do
			local gradeLabel = (job.grades[i].label == '' and job.label or job.grades[i].label)
			table.insert(elements, {
				label = ('(%s) %s'):format(job.grades[i].grade, gradeLabel) .. (job.grades[i].name == 'boss' and ' 👑' or ''),
				grade = job.grades[i].grade,
				name  = job.grades[i].name,
				perm_employee_management = job.grades[i].perm_employee_management,
				perm_vehicle_custom      = job.grades[i].perm_vehicle_custom,
				permsTable               = job.grades[i].permsTable or {},
			})
		end

		table.insert(elements, {label = 'Ezafe Kardan Grade', value = 'add_grade'})

		ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'manage_grades_advanced_' .. society, {
			title    = 'Modiriat Grade (Advanced)',
			align    = 'top-left',
			elements = elements
		}, function(data, menu)

			if data.current.value == 'add_grade' then
				menu.close()
				ESX.TriggerServerCallback('esx_society:newGrade', function(ok)
					if ok then
						ESX.ShowNotification('Grade Ezafe Shod')
					else
						ESX.ShowNotification('Khata dar Ezafe Kardan Grade')
					end
					OpenAdvancedGradeMenu(society)
				end, society)
				return
			end

			local grade = data.current.grade
			local isBoss = data.current.name == 'boss'

			local subElements = {
				{label = 'Upgrade🔼', value = 'upgrade'},
				{label = 'Downgrade🔽', value = 'downgrade'},
				{label = 'Boss : ' .. (isBoss and '✅' or '❌'), value = 'toggle_boss'},
				{label = 'Employee Management : ' .. (data.current.perm_employee_management == 1 and '✅' or '❌'), value = 'toggle_employee'},
				{label = 'Vehicle Custom : ' .. (data.current.perm_vehicle_custom == 1 and '✅' or '❌'), value = 'toggle_custom'},
				{label = 'Modiriat Dastresi Vizhe', value = 'manage_perms'},
				{label = 'Hazf Grade', value = 'delete_grade'},
			}

			ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'manage_grades_advanced_actions_' .. society, {
				title    = ('Grade %s'):format(grade),
				align    = 'top-left',
				elements = subElements
			}, function(data2, menu2)

				if data2.current.value == 'upgrade' then
					menu2.close()
					menu.close()
					TriggerServerEvent('esx_society:upgradeGrade', grade)
					Citizen.Wait(300)
					OpenAdvancedGradeMenu(society)
				elseif data2.current.value == 'downgrade' then
					menu2.close()
					menu.close()
					TriggerServerEvent('esx_society:downgradeGrade', grade)
					Citizen.Wait(300)
					OpenAdvancedGradeMenu(society)
				elseif data2.current.value == 'toggle_boss' then
					local alert = lib.alertDialog({
						header = 'Boss',
						content = isBoss and 'Aya mikhahid boss ra az in grade bardarid?' or 'Aya mikhahid in grade boss she? (boss ghabli demote mishe)',
						centered = true,
						cancel = true
					})
					if alert == 'confirm' then
						menu2.close()
						menu.close()
						TriggerServerEvent('esx_society:toggleBoss', grade, not isBoss)
						Citizen.Wait(300)
						OpenAdvancedGradeMenu(society)
					end
				elseif data2.current.value == 'toggle_employee' then
					menu2.close()
					menu.close()
					TriggerServerEvent('esx_society:toggleEmployeeManagementPerm', grade, not (data.current.perm_employee_management == 1))
					Citizen.Wait(300)
					OpenAdvancedGradeMenu(society)
				elseif data2.current.value == 'toggle_custom' then
					menu2.close()
					menu.close()
					TriggerServerEvent('esx_society:toggleVehicleCustomPerm', grade, not (data.current.perm_vehicle_custom == 1))
					Citizen.Wait(300)
					OpenAdvancedGradeMenu(society)
				elseif data2.current.value == 'manage_perms' then
					menu2.close()
					menu.close()
					OpenGradePermissionsMenu(society, grade, data.current.permsTable)
				elseif data2.current.value == 'delete_grade' then
					local alert = lib.alertDialog({
						header = 'Hazf Grade',
						content = ('Aya mayel be hazf grade %s hastid?'):format(grade),
						centered = true,
						cancel = true
					})
					if alert == 'confirm' then
						menu2.close()
						menu.close()
						TriggerServerEvent('esx_society:deleteGrade', grade)
						Citizen.Wait(300)
						OpenAdvancedGradeMenu(society)
					end
				end

			end, function(data2, menu2)
				menu2.close()
			end)

		end, function(data, menu)
			menu.close()
			OpenManageJobMenu(society)
		end)
	end, society)
end

function OpenGradePermissionsMenu(society, grade, permsTable)
	permsTable = permsTable or {}

	local allowedKeys = Config.PermissionGroups[society]
	local elements = {}

	if allowedKeys then
		for _, key in ipairs(allowedKeys) do
			if Config.PermissionKeys[key] then
				table.insert(elements, {
					label = Config.PermissionKeys[key] .. ' : ' .. (permsTable[key] and '✅' or '❌'),
					key   = key,
				})
			end
		end
	else
		for key, label in pairs(Config.PermissionKeys) do
			table.insert(elements, {
				label = label .. ' : ' .. (permsTable[key] and '✅' or '❌'),
				key   = key,
			})
		end
	end

	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'manage_grade_perms_' .. society, {
		title    = 'Modiriat Dastresi Vizhe',
		align    = 'top-left',
		elements = elements
	}, function(data, menu)
		local key = data.current.key
		local newState = not permsTable[key]

		TriggerServerEvent('esx_society:togglePermKey', grade, key, newState)
		permsTable[key] = newState and true or nil

		menu.close()
		OpenGradePermissionsMenu(society, grade, permsTable)
	end, function(data, menu)
		menu.close()
		OpenAdvancedGradeMenu(society)
	end)
end

function OpenSetOutfitMenu(society)
	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'manage_grades_outfit' .. society, {
		title    = _U('manage_grades_outfit'),
		align    = 'top-left',
		elements = {
			{label = 'Men', value = 'employee_man'},
			{label = 'Women', value = 'employee_woman'}
		}
	}, function(data, menu)

		if data.current.value == 'employee_man' then
			OpenOutfitM(society)
		end

		if data.current.value == 'employee_woman' then
			OpenOutfitF(society)
		end

	end, function(data, menu)
		menu.close()
	end)
end

function OpenSetOutfitdivisionMenu(society)
	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'manage_division_outfit' .. society, {
		title    = _U('manage_division_outfit'),
		align    = 'top-left',
		elements = {
			{label = 'Men', value = 'employee_man_Division'},
			{label = 'Women', value = 'employee_woman_Division'}
		}
	}, function(data, menu)

		if data.current.value == 'employee_man_Division' then
			OpenOutfitMdivision(society)
		end

		if data.current.value == 'employee_woman_Division' then
			OpenOutfitFdivision(society)
		end

	end, function(data, menu)
		menu.close()
	end)
end

function OpenOutfitM(society)

	ESX.TriggerServerCallback('esx_society:getJob', function(job)
		local elements = {}

		for i=tonumber(1), #job.grades, tonumber(1) do
			local gradeLabel = (job.grades[i].label == '' and job.label or job.grades[i].label)
			if job.grades[i].grade <= ESX.PlayerData.job.grade then
				table.insert(elements, {label = '('..job.grades[i].grade..')  | '..gradeLabel, grade = job.grades[i].grade})
			end
		end
		  ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'manage_grades_name', {
			title    = _U('manage_grades_outfit'),
			align    = 'top-left',
			elements = elements
		}, function(data, menu)
			Wait(500)

			Wait(500)
			ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(myskin)
				ESX.TriggerServerCallback('esx_society:getEmployeclothes', function (skinjob)

					if skinjob ~= nil then
						TriggerEvent('skinchanger:loadClothes', Config.MaleDefault, skinjob)
					else
						TriggerEvent('skinchanger:loadSkin', Config.MaleDefault)
					end
					Citizen.Wait(tonumber(100))
					TriggerEvent(tostring(Config.MenuSkintrigger), source)
					local WaitForSave = true
					while WaitForSave do
						if ESX.UI.Menu.IsOpen('default', 'esx_skin', 'skin') then
							Citizen.Wait(tonumber(1000))
						else
							TriggerEvent('skinchanger:getSkin', function(skin)
								ESX.TriggerServerCallback('esx_society:setUniform', function ()
								end, society, tonumber(data.current.grade), 'male', skin)
							end)
							WaitForSave = false

							TriggerEvent('skinchanger:loadSkin', myskin)
							Citizen.Wait(tonumber(100))
							TriggerServerEvent('esx_skin:save', myskin)
						end
						Citizen.Wait(tonumber(1000))
					end
			end, tonumber(data.current.grade), 'male', society)
		end)

		  end, function(data, menu)
			menu.close()
		  end)
	end, society)

end

function OpenOutfitF(society)

	ESX.TriggerServerCallback('esx_society:getJob', function(job)
		local elements = {}


		for i=tonumber(1), #job.grades, tonumber(1) do
			local gradeLabel = (job.grades[i].label == '' and job.label or job.grades[i].label)
			if job.grades[i].grade <= ESX.PlayerData.job.grade then
				table.insert(elements, {label = '('..job.grades[i].grade..')  | '..gradeLabel, grade = job.grades[i].grade})
			end
		end
		  ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'manage_grades_name', {
			title    = _U('manage_grades_outfit'),
			align    = 'top-left',
			elements = elements
		}, function(data, menu)
			Wait(500)

			Wait(500)
			ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(myskin)
				ESX.TriggerServerCallback('esx_society:getEmployeclothes', function (skinjob)

					if skinjob ~= nil then
						TriggerEvent('skinchanger:loadClothes', Config.FemaleDefault, skinjob)
					else
						TriggerEvent('skinchanger:loadSkin', Config.FemaleDefault)
					end
					Citizen.Wait(tonumber(100))
					TriggerEvent(tostring(Config.MenuSkintrigger), source)
					local WaitForSave = true
					while WaitForSave do
						if ESX.UI.Menu.IsOpen('default', 'esx_skin', 'skin') then
							Citizen.Wait(tonumber(1000))
						else
							TriggerEvent('skinchanger:getSkin', function(skin)
								ESX.TriggerServerCallback('esx_society:setUniform', function ()
								end, society, tonumber(data.current.grade),'female', skin)
							end)
							WaitForSave = false

							TriggerEvent('skinchanger:loadSkin', myskin)
							Citizen.Wait(tonumber(100))
							TriggerServerEvent('esx_skin:save', myskin)
						end
						Citizen.Wait(tonumber(1000))
					end
			end, tonumber(data.current.grade), 'female', society)
		end)

		  end, function(data, menu)
			menu.close()
		  end)
	end, society)

end

function OpenOutfitMdivision(society)

	ESX.TriggerServerCallback('esx_society:getdivision', function(division)
		local elements = {}

		for i=tonumber(1), #division, tonumber(1) do
			local divisionLabel = (division[i].label == '' and division.label or division[i].label)

			table.insert(elements, {label = '('..division[i].name..')  | '..divisionLabel, division = division[i].name})

		end
		  ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'manage_division_outfit', {
			title    = _U('manage_division_outfit'),
			align    = 'top-left',
			elements = elements
		}, function(data, menu)
			Wait(500)

			Wait(500)
			ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(myskin)
				ESX.TriggerServerCallback('esx_society:getEmployeclothesdivision', function (skinjob)

					if skinjob ~= nil then
						TriggerEvent('skinchanger:loadClothes', Config.MaleDefault, skinjob)
					else
						TriggerEvent('skinchanger:loadSkin', Config.MaleDefault)
					end
					Citizen.Wait(tonumber(100))
					TriggerEvent(tostring(Config.MenuSkintrigger), source)
					local WaitForSave = true
					while WaitForSave do
						if ESX.UI.Menu.IsOpen('default', 'esx_skin', 'skin') then
							Citizen.Wait(tonumber(1000))
						else
							TriggerEvent('skinchanger:getSkin', function(skin)
								ESX.TriggerServerCallback('esx_society:setUniformdivision', function ()
								end, society, data.current.division, 'male', skin)
							end)
							WaitForSave = false

							TriggerEvent('skinchanger:loadSkin', myskin)
							Citizen.Wait(tonumber(100))
							TriggerServerEvent('esx_skin:save', myskin)
						end
						Citizen.Wait(tonumber(1000))
					end
			end, data.current.division, 'male', society)
		end)

		  end, function(data, menu)
			menu.close()
		  end)
	end, society)

end

function OpenOutfitFdivision(society)

	ESX.TriggerServerCallback('esx_society:getdivision', function(division)
		local elements = {}

		for i=tonumber(1), #division, tonumber(1) do
			local divisionLabel = (division[i].label == '' and division.label or division[i].label)

			table.insert(elements, {label = '('..division[i].name..')  | '..divisionLabel, division = division[i].name})

		end
		  ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'manage_division_outfit', {
			title    = _U('manage_division_outfit'),
			align    = 'top-left',
			elements = elements
		}, function(data, menu)
			Wait(500)

			Wait(500)
			ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(myskin)
				ESX.TriggerServerCallback('esx_society:getEmployeclothesdivision', function (skinjob)






					Citizen.Wait(tonumber(100))
					TriggerEvent(tostring(Config.MenuSkintrigger), source)
					local WaitForSave = true
					while WaitForSave do
						if ESX.UI.Menu.IsOpen('default', 'esx_skin', 'skin') then
							Citizen.Wait(tonumber(1000))
						else
							TriggerEvent('skinchanger:getSkin', function(skin)
								ESX.TriggerServerCallback('esx_society:setUniformdivision', function ()
								end, society, data.current.division,'female', skin)
							end)
							WaitForSave = false

							TriggerEvent('skinchanger:loadSkin', myskin)
							Citizen.Wait(tonumber(100))
							TriggerServerEvent('esx_skin:save', myskin)
						end
						Citizen.Wait(tonumber(1000))
					end
			end, data.current.division, 'female', society)
		end)

		  end, function(data, menu)
			menu.close()
		  end)
	end, society)

end

function OpenDepositMoney(society, close, options)
	ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'deposit_money_amount_' .. society, {
		title = _U('deposit_amount')
	}, function(data, menu)

		local amount = tonumber(data.value)

		if amount == nil then
			ESX.ShowNotification(_U('invalid_amount'))
		else
			menu.close()
			TriggerServerEvent('esx_society:depositMoney', society, amount)
			OpenBossMenu(society, close, options)
		end

	end, function(data, menu)
		menu.close()
	end)
end

function OpenManageEmployeesMenu(society)

	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'manage_employees_' .. society, {
		title    = _U('employee_management'),
		align    = 'top-left',
		elements = {
			{label = 'List A\'aza', value = 'employee_list'},
			{label = 'List A\'aza(Off Duty)', value = 'employee_listoff'},
			{label = 'Estekhdam',       value = 'recruit'}
		}
	}, function(data, menu)

		if data.current.value == 'employee_list' then
			OpenEmployeeList(society)
		end

		if data.current.value == 'employee_listoff' then
			OpenEmployeeList('off' .. society)
		end

		if data.current.value == 'recruit' then
			OpenRecruitMenu(society)
		end

	end, function(data, menu)
		menu.close()
	end)
end

function OpenEmployeeList(society)

	ESX.TriggerServerCallback('esx_society:getEmployees', function(employees)

		local editIcon = '<svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M12 20h9"></path><path d="M16.5 3.5a2.121 2.121 0 0 1 3 3L7 19l-4 1 1-4Z"></path></svg>'
		local kickIcon = '<svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M16 21v-2a4 4 0 0 0-4-4H6a4 4 0 0 0-4 4v2"></path><circle cx="9" cy="7" r="4"></circle><line x1="17" y1="11" x2="23" y2="11"></line></svg>'

		local siblings = GetBranchSiblings(society)

		local elements = {
			head = {_U('employee'), _U('grade'), _U('actions')},
			rows = {}
		}

		for i=1, #employees, 1 do
			local gradeLabel = (employees[i].job.grade_label == '' and employees[i].job.label or employees[i].job.grade_label)
			local photoHtml  = '<img src="' .. employees[i].photo .. '">'

			if employees[i].job.grade >= ESX.PlayerData.job.grade then

				table.insert(elements.rows, {data = employees[i], cols = {photoHtml, employees[i].name, gradeLabel, 'DISABLE'}})
			else
				local actions = '{{' .. editIcon .. '|promote}} {{' .. kickIcon .. '|fire}}'
				if siblings then
					actions = actions .. ' {{Swap|swap}}'
				end
				table.insert(elements.rows, {data = employees[i], cols = {photoHtml, employees[i].name, gradeLabel, actions}})
			end
		end

		ESX.UI.Menu.Open('list', GetCurrentResourceName(), 'employee_list_' .. society, elements, function(data, menu)
			local employee = data.data

			if data.value == 'promote' then
				menu.close()
				OpenPromoteMenu(society, employee)
			elseif data.value == 'fire' then
				ESX.ShowNotification(_U('you_have_fired', employee.name))

				ESX.TriggerServerCallback('esx_society:setJob', function()
					OpenEmployeeList(society)
				end, employee.identifier, 'nojob', tonumber(0), 'fire')
			elseif data.value == 'swap' then
				menu.close()
				OpenSwapEmployeeMenu(society, employee, siblings)
			end
		end, function(data, menu)
			menu.close()

		end)

	end, society)

end

function OpenSwapEmployeeMenu(society, employee, siblings)
	local elements = {}
	for i = 1, #siblings do
		local niceLabel = (Config.JobDisplayLabels and Config.JobDisplayLabels[siblings[i]]) or siblings[i]
		table.insert(elements, {label = 'Swap to ' .. niceLabel, value = siblings[i]})
	end

	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'swap_employee_' .. society, {
		title    = 'Swap ' .. employee.name .. ' to...',
		align    = 'top-left',
		elements = elements
	}, function(data, menu)
		menu.close()
		ESX.TriggerServerCallback('esx_society:swapEmployeeJob', function(ok)
			if ok then
				ESX.ShowNotification(employee.name .. ' moved to ' .. data.current.value)
			end
			OpenEmployeeList(society)
		end, employee.identifier, society, data.current.value)
	end, function(data, menu)
		menu.close()
		OpenEmployeeList(society)
	end)
end

function OpenRecruitMenu(society)

	ESX.TriggerServerCallback('esx_society:getOnlinePlayers', function(players, ppcoords2)

		local elements = {}

		for i=1, #players, 1 do
			targetCoords = players[i].coords
			local distance = GetDistanceBetweenCoords(targetCoords.x, targetCoords.y, targetCoords.z, ppcoords2.x, ppcoords2.y, ppcoords2.z, true)
			if distance <= 15 then
				if players[i].job.name ~= society and players[i].job.name == "nojob" then
					table.insert(elements, {
						label = players[i].name,
						value = players[i].source,
						name = players[i].name,
						identifier = players[i].identifier
					})
				end
			end
		end

		ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'recruit_' .. society, {
			title    = _U('recruiting'),
			align    = 'top-left',
			elements = elements
		}, function(data, menu)

			ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'recruit_confirm_' .. society, {
				title    = _U('do_you_want_to_recruit', data.current.name),
				align    = 'top-left',
				elements = {
					{label = _U('no'),  value = 'no'},
					{label = _U('yes'), value = 'yes'}
				}
			}, function(data2, menu2)
				menu2.close()

				if data2.current.value == 'yes' then
					ESX.ShowNotification(_U('you_have_hired', data.current.name))

					ESX.TriggerServerCallback('esx_society:setJob', function()
						OpenRecruitMenu(society)
					end, data.current.identifier, society, tonumber(1), 'hire')
				end
			end, function(data2, menu2)
				menu2.close()
			end)

		end, function(data, menu)
			menu.close()
		end)

	end)

end

function OpenPromoteMenu(society, employee)

	ESX.TriggerServerCallback('esx_society:getJob', function(job)

		local elements = {}

		for i=tonumber(1), #job.grades, tonumber(1) do

			local gradeLabel = (job.grades[i].label == '' and job.label or job.grades[i].label)
			if job.grades[i].grade < ESX.PlayerData.job.grade then
				table.insert(elements, {
					label = gradeLabel,
					value = job.grades[i].grade,
					selected = (employee.job.grade == job.grades[i].grade)
				})
			end
		end

		ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'promote_employee_' .. society, {
			title    = _U('promote_employee', employee.name),
			align    = 'top-left',
			elements = elements
		}, function(data, menu)
			menu.close()
			ESX.ShowNotification(_U('you_have_promoted', employee.name, data.current.label))

			ESX.TriggerServerCallback('esx_society:setJob', function()
				OpenEmployeeList(society)
			end, employee.identifier, society, data.current.value, 'promote')
		end, function(data, menu)
			menu.close()
			OpenEmployeeList(society)
		end)

	end, society)

end

function OpenManageGradesMenu(society)
	ESX.TriggerServerCallback('esx_society:getJob', function(job)

		local elements = {}

		for i=tonumber(1), #job.grades, tonumber(1) do
			local gradeLabel = (job.grades[i].label == '' and job.label or job.grades[i].label)

			table.insert(elements, {
				label = ('%s - <span style="color:green;">%s</span>'):format(gradeLabel, _U('money_generic', ESX.Math.GroupDigits(job.grades[i].salary))),
				value = job.grades[i].grade
			})
		end

		ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'manage_grades_' .. society, {
			title    = _U('salary_management'),
			align    = 'top-left',
			elements = elements
		}, function(data, menu)

			ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'manage_grades_amount_' .. society, {
				title = _U('salary_amount')
			}, function(data2, menu2)

				local amount = tonumber(data2.value)

				if amount == nil then
					ESX.ShowNotification(_U('invalid_amount'))
				elseif amount > Config.MaxSalary then
					ESX.ShowNotification(_U('invalid_amount_max'))
				else
					menu2.close()

					ESX.TriggerServerCallback('esx_society:setJobSalary', function()
						OpenManageGradesMenu(society)
					end, society, data.current.value, amount)
				end

			end, function(data2, menu2)
				menu2.close()
			end)

		end, function(data, menu)
			menu.close()
		end)

	end, society)

end

AddEventHandler(Config.OpenBossMenu, function(society, close, options)
	OpenBossMenu(society, close, options)
end)

RegisterNetEvent('esx_society:openBosscarysMenu')
AddEventHandler('esx_society:openBosscarysMenu', function(society, cb)
	OpenBossMenu(society, cb)
end)

local invis = false
function FastTravel(coords, heading)

	local playerPed = PlayerPedId()


	DoScreenFadeOut(tonumber(800))

	while not IsScreenFadedOut() do

		Citizen.Wait(tonumber(500))

	end

	ESX.Game.Teleport(playerPed, coords, function()
		local otherPlayerPed = GetPlayerPed(GetPlayerFromServerId(serverId))
		DoScreenFadeIn(tonumber(800))

		if heading then

			SetEntityHeading(playerPed, tonumber(heading))

		end

			  if not invis then
				FreezeEntityPosition(playerPed, true)
				NetworkSetEntityInvisibleToNetwork(playerPed, true)
				SetEntityNoCollisionEntity(otherPlayerPed, playerPed, true)
				invis = true
			  else
				FreezeEntityPosition(playerPed, false)
				NetworkSetEntityInvisibleToNetwork(playerPed, false)
				SetEntityNoCollisionEntity(otherPlayerPed, playerPed, false)
			  end

	end)

end

function GetModelLabel(name)
	local label = string.upper(string.gsub(name, 'WEAPON_', ''))
	label = string.gsub(label, '_', '')
	return label
end

function DoesHaveArmory(job)
    local access = false
	if Config.Armory[job] then
		access = true
	end
    return access
end

function DoesHaveGarage(job)
	local access = false
		if Config.Garage[job] or (CustomVehicles[job] and #CustomVehicles[job] > 0) then
			access = true
		end
    return access
end

function DoesHaveHelis(job)
	local access = false
		if Config.Heli[job] then
			access = true
		end
    return access
end

function DoesHaveInventory(job)
	local access = false
	for i,v in ipairs(Config.Inventory) do
		if v == job then
			access = true
			break
		end
	end
	return access
end

function DoesHaveOffDuty(job)
	local access = false
	for i,v in ipairs(Config.Offjobs) do
		if v == job then
			access = true
			break
		end
	end
	return access
end

Citizen.CreateThread(function()

	while ESX.GetPlayerData().job == nil do
		Citizen.Wait(10)

	end
	Citizen.Wait(500)

	while true do


		local kolah = GetPedPropIndex(PlayerPedId(), 0)

		Wait(1)
		if kolah == 119 or kolah == 120 or kolah == 121 or kolah == 122 or kolah == 123 then
			if (ESX.PlayerData.job.name == 'police' or ESX.PlayerData.job.name == 'sheriff' or ESX.PlayerData.job.name == 'mt' or ESX.PlayerData.job.name == 'fbi') and not ESX.GetPlayerData().IsDead then
				SetPedConfigFlag(PlayerPedId(), 149, false)
				SetPedConfigFlag(PlayerPedId(), 438, false)

			else
				SetPedConfigFlag(PlayerPedId(), 149, true)
				SetPedConfigFlag(PlayerPedId(), 438, true)
				Citizen.Wait(5000)
			end
		else
			SetPedConfigFlag(PlayerPedId(), 149, true)
			SetPedConfigFlag(PlayerPedId(), 438, true)
			Citizen.Wait(5000)
		end


	end

end)
-- ===== /addcarjob and DeleteCar menu =====
-- Admin must be on-duty (aduty) with permission_level, sitting in the vehicle to add.
RegisterCommand('addcarjob', function(source, args)
	if not IsPedInAnyVehicle(PlayerPedId(), false) then
		ESX.ShowNotification('Savar Mashin Nisti')
		return
	end

	if not args[1] then
		ESX.ShowNotification('Estefade: /addcarjob [jobname]')
		return
	end

	local veh   = GetVehiclePedIsIn(PlayerPedId(), false)
	local model = GetEntityModel(veh)
	local modelName = GetDisplayNameFromVehicleModel(model)

	local input = lib.inputDialog('Label Mashin Ra Vared Konid', {
		{type = 'input', label = 'Label', required = true},
		{type = 'checkbox', label = 'Helicopter'},
	})

	if not input or not input[1] or input[1] == '' then
		return
	end

	TriggerServerEvent('esx_society:addCarJob', args[1], modelName, input[1], input[2] and true or false)
end, false)

RegisterNetEvent('DeleteCar:Open')
AddEventHandler('DeleteCar:Open', function(data)
	local List = {}

	for job, vehicles in pairs(data) do
		if not string.find(job, 'off') and #vehicles > 0 then
			table.insert(List, {
				img      = 'SS_gold.png',
				text     = job,
				text2    = job,
				callBack = function()
					exports.icon_menu:ForceCloseMenu()
					OpenJobVehMenu(data, job)
				end
			})
		end
	end

	exports.icon_menu:OpenMenu(List)
end)

function OpenJobVehMenu(data, job)
	local List = {}
	local jobVehicles = data[job]

	for _, v in ipairs(jobVehicles) do
		table.insert(List, {
			img      = 'SS_gold.png',
			text     = v.label,
			text2    = v.model,
			callBack = function()
				TriggerServerEvent('esx_society:deleteCustomCarJob', v.id, job)
				exports.icon_menu:ForceCloseMenu()
			end
		})
	end

	exports.icon_menu:OpenMenu(List)
end

RegisterCommand('deletecarjob', function()
	TriggerEvent('DeleteCar:Open', CustomVehicles)
end, false)

-- ===== /dduty and /dlist =====
-- All jobs in Config.DispatchQueueJobs (taxi/mechanic/ambulance) share the same
-- real server-side FIFO queue. /dduty joins/leaves it. /dlist ONLY reports your
-- position — it does NOT open the F6 menu. New requests get auto-accepted for
-- whoever's been waiting longest (handled entirely server-side in esx_uniquejobs).
local function isInList(list, value)
	for _, v in ipairs(list) do
		if v == value then return true end
	end
	return false
end

RegisterCommand('dduty', function()
	local job = ESX.PlayerData.job and ESX.PlayerData.job.name

	if not job or not isInList(Config.DispatchQueueJobs, job) then
		ESX.ShowNotification('Job Shoma Dispatch Duty Nadarad')
		return
	end

	TriggerServerEvent('esx_society:toggleDispatchDuty')
end, false)

RegisterKeyMapping('dduty', 'Toggle Duty', 'keyboard', '')

RegisterCommand('dlist', function()
	local job = ESX.PlayerData.job and ESX.PlayerData.job.name

	if not job or not isInList(Config.DispatchQueueJobs, job) then
		ESX.ShowNotification('Job Shoma Dispatch Duty Nadarad')
		return
	end

	ESX.TriggerServerCallback('esx_society:getDispatchList', function(info)
		if not info then return end

		if info.myPosition then
			ESX.ShowNotification(('Jaygah Shoma Dar Saf: ~y~%s~s~ | Majmoo Saf: ~y~%s~s~'):format(info.myPosition, info.queueCount))
		else
			ESX.ShowNotification(('Shoma Dar Saf Dduty Nistid | Majmoo Saf: ~y~%s~s~'):format(info.queueCount))
		end
	end)
end, false)

RegisterKeyMapping('dlist', 'Show Dispatch Queue Position', 'keyboard', '')

-- Fired when this player reaches the front of the queue and a request is
-- offered to them. Same dialog regardless of job — the actual accept logic
-- lives in esx_uniquejobs and runs server-side via export.
RegisterNetEvent('esx_society:dispatchOffer')
AddEventHandler('esx_society:dispatchOffer', function(job)
	local alert = lib.alertDialog({
		header   = 'Darkhast Jadid',
		content  = 'Yek Darkhast Baraye Shoma Ersal Shod. Ghabul Mikonid?',
		centered = true,
		cancel   = true,
		labels   = {
			confirm = 'Bale',
			cancel  = 'Kheir',
		}
	})

	TriggerServerEvent('esx_society:dispatchOfferRespond', job, alert == 'confirm')
end)
