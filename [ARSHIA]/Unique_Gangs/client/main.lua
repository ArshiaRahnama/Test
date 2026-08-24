

ESX = nil

local base64MoneyIcon = ''
local Data = {}

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(1)
	end

 	while ESX.GetPlayerData().gang == nil do
		Citizen.Wait(10)
	end

 	ESX.PlayerData = ESX.GetPlayerData()
end)

RegisterNetEvent('esx:setGang')
AddEventHandler('esx:setGang', function(gang)
	ESX.PlayerData.gang = gang
end)

RegisterNetEvent('gangs:itemac')
AddEventHandler('gangs:itemac', function(gang)
	ESX.UI.Menu.CloseAll()
	ESX.UI.Menu.Open('question', GetCurrentResourceName(), 'Aks_For_Join',
		{
			title 	 = 'Voroud Be Gang',
			align    = 'center',
			question = 'Aya Shoma Mikhahid Vared Gang ('.. gang ..') Shavid?',
			elements = {
				{label = 'Bale', value = 'yes'},
				{label = 'Kheir', value = 'no'},
			},
			}, function(data, menu)
				if data.current.value == 'yes' then
					TriggerServerEvent("gangs:acceptinv", gang, 1)
					ESX.UI.Menu.CloseAll()
				elseif data.current.value == 'no' then
					menu.close()
                    ESX.UI.Menu.CloseAll()
				end
			end
			)

end)

function OpenBossMenu(gang, close, options)
	ESX.TriggerServerCallback('gangs:getGangData', function(data)
	Data.vip = data.vip

	local isBoss = nil
	local options  = options or {}
	local elements = {}
	local gangMoney = nil

 	ESX.TriggerServerCallback('gangs:isBoss', function(result)
		isBoss = result
	end, gang)

 	while isBoss == nil do
		Citizen.Wait(100)
	end

 	if not isBoss then
		return
	end

	while gangMoney == nil do
		Citizen.Wait(1)
		ESX.TriggerServerCallback('gangs:getGangMoney', function(money)
			gangMoney = money
		end, ESX.PlayerData.gang.name)
	end

 	local defaultOptions = {
		withdraw   = true,
		deposit    = true,
		wash       = false,
		employees  = true,
		grades     = true,
		gradesname = true,
		garage     = true,
		heli     = true,
		boat     = true,
		armory     = true,
		vest       = true,
		logo       = true,
		invite     = true,
		logpower   = true,
		blip       = true,
		gps_color  = true,
		blip_color  = true
	}

 	for k,v in pairs(defaultOptions) do
		if options[k] == nil then
			options[k] = v
		end
	end

	if options.withdraw then
		local formattedMoney = _U('locale_currency', ESX.Math.GroupDigits(gangMoney))
		table.insert(elements, {label = ('%s: <span style="color:green;">%s</span>'):format("Money", formattedMoney), value = 'withdraw_society_money'})
	end

 	if options.employees and ESX.PlayerData.gang.grade >= 10 then
		table.insert(elements, {label = "Manage Gang Members", value = 'manage_employees'})
	end





if Data.vip == 1 then

	if options.gradesname and ESX.PlayerData.gang.grade >= 10 then
		table.insert(elements, {label = "Change Gredes Name", value = 'manage_gradesname'})
	end

	if options.garage and ESX.PlayerData.gang.grade >= 10 then
		table.insert(elements, {label = "Manage Access", value = 'manage_accses'})
	end


end
	if options.logpower and ESX.PlayerData.gang.grade >= 10 then
		table.insert(elements, {label = "Set Webhook Log", value = 'set_webhook'})
	end

	if options.logo and ESX.PlayerData.gang.grade >= 10 then
		table.insert(elements, {label = "Set Icon", value = 'set_logo'})
	end

	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'boss_actions_' .. gang, {
		title    = _U('boss_menu'),
		align    = 'top-left',
		elements = elements
	}, function(data, menu)

		if data.current.value == 'withdraw_society_money' then
			OpenMoneyMenu(gang)
		elseif data.current.value == 'manage_employees' then
			OpenManageEmployeesMenu(gang)
		elseif data.current.value == 'manage_gradesname' then
			ManageGrades()
		elseif data.current.value == 'manage_accses' then
			OpenManageAccess(gang, rank)


		elseif data.current.value == 'set_logo' then
			SetLogo()

		elseif data.current.value == 'set_webhook' then
			if ESX.GetPlayerData()['CanGangLog'] == 1 then
				SetWebhook()
			else
				ESX.ShowNotification("~h~Gang Shoma Ghabeliyat Log Nadarad, Jahat Kharid Be Shop Morajee Konid")
			end
		end

	end, function(data, menu)
		if close then
			close(data, menu)
		end
	end)
	end,gang)
end

function ManageGrades()
	ESX.TriggerServerCallback('gang:getGrades', function(grades)
		  local elements = {}
		  local gggrade = ESX.PlayerData.gang.grade

			for k,v in pairs(grades) do
				if k <= gggrade then

					table.insert(elements, {label = '(' .. k .. ') | ' .. v.label, grade = k})
				end

			end

		ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'show_grade_list', {
			title    = 'Gang Grades',
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

				if data2.value:match("[^%w%s]") or data2.value:match("%d") then
					ESX.ShowNotification("~h~Shoma mojaz be vared kardan ~r~Special ~o~character ~w~ya ~r~adad ~w~nistid!")
					return
				end

				if string.len(ESX.Math.Trim(data2.value)) >= 3 and string.len(ESX.Math.Trim(data2.value)) <= 15 then
					ESX.TriggerServerCallback('gangs:renameGrade', function(refresh)
						menu2.close()
						if refresh then
							menu.close()
							ManageGrades()
						end
					end, data.current.grade, data2.value)
				else
					ESX.ShowNotification("Tedad character esm grade bayad bishtar az ~g~3 ~w~0 va kamtar az ~g~11 ~o~character ~w~bashad!")
				end

            end, function (data2, menu2)
                menu2.close()
            end)

		end, function(data, menu)
			menu.close()
		end)
	end)
end

function SetWebhook()
	local elements = {}
	table.insert(elements, {label = 'Boss Action' , value = 'boss' })
	table.insert(elements, {label = 'Vehicle' , value = 'vehicle' })
	table.insert(elements, {label = 'Inventory' , value = 'inventory' })
	table.insert(elements, {label = 'Money' , value = 'money' })

	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'Gang_Log', {
		title    = 'Gang Webhook',
		align    = 'top-left',
		elements = elements
	}, function(data, menu)

		if data.current.value == 'boss' then
			WebHookData('boss', 'webhookboss')
		elseif data.current.value == 'vehicle' then
			WebHookData('vehicle', 'webhookveh')
		elseif data.current.value == 'inventory' then
			WebHookData('inventory', 'webhookinv')
		elseif data.current.value == 'money' then
			WebHookData('money', 'webhookmoney')
		end



	end, function(data, menu)

		menu.close()
	end)


end

function WebHookData(vauename, dbname)

	ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'set_log', {
		title    = "Link Web Hook Ra Vared Konid",

	}, function(data2, menu2)

		if not data2.value then
			ESX.ShowNotification("Shoma Linki Vared Nakardid!")
			return
		end
		local link = data2.value
		if link:find('https://discord.com/api/webhooks/') then
			ESX.TriggerServerCallback('gangs:sethook', function(refresh)
				menu2.close()
				ESX.ShowNotification("WebHook Ba Movafaghiat Sabt Shod!")
			end, link, dbname)
			menu2.close()
		else
			ESX.ShowNotification("Link Vared Shode Eshtebah Ast!")
			return
		end
	end, function (data2, menu2)
		menu2.close()
	end)

end

function SetLogo()

	ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'set_logo', {
		title    = "Link Axs Ra Vared Konid",

	}, function(data2, menu2)

		if not data2.value then
			ESX.ShowNotification("Shoma Chizi Vared Nakardid!")
			return
		end
		local link = data2.value
		if link:find('http') then
		ESX.TriggerServerCallback('gangs:setganglogo', function(refresh)
				menu2.close()
				ESX.ShowNotification("Link Axs Ba Movafaghiat Sabt Shod!")
		  end, link)
		menu2.close()
		 else
			ESX.ShowNotification("Link Vared Shode Eshtebah Ast!")
			return
		 end
	end, function (data2, menu2)
		menu2.close()
	end)
end

function OpenManageEmployeesMenu(gang)
	ESX.TriggerServerCallback('gangs:getEmployees', function(employees)
	ESX.TriggerServerCallback('gangs:getGangData', function(data)
	Data.slot  			= data.slot
	Data.gps   			= data.gps
	Data.lockpick   	= data.lockpick
	Data.bulletproof  	= data.bulletproof
	Data.price  		= data.price
	Data.garage_limit  	= data.garage_limit


	local tedadmember = 0
	for i=1, #employees, 1 do
		tedadmember = tedadmember + 1
	end

	local elements = {
		{label = "Members List", value = 'employee_list'},
		{label = _U('recruit'),       value = 'recruit'},
		{label = "Slot: " .. tedadmember.."/"..Data.slot,       value = 'slotsize'},
		{label = "Armor: " .. Data.bulletproof.."%",       value = 'vest'},
		{label = "Gheymat Kharid Armor: $" ..Data.price.. " Mibashad",       value = 'price'},

	}
	if Data.gps == 1 then
		table.insert(elements, {label = "GPS: Gang Shoma GPS Darad", value = 'have_gps'})
	else
		table.insert(elements, {label = "GPS: Gang Shoma GPS Nadarad", value = 'donthave_gps'})
	end

	if Data.lockpick == 1 then
		table.insert(elements, {label = "LockPick: Gang Shoma LockPick Darad", value = 'LockPick_Acced'})
	else
		table.insert(elements, {label = "LockPick: Gang Shoma LockPick Nadarad", value = 'donthave_LockPick'})
	end

 	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'manage_employees_' .. gang, {
		title    = _U('employee_management'),
		align    = 'top-left',
		elements = elements
	}, function(data, menu)


 		if data.current.value == 'employee_list' then
			OpenEmployeeList(gang)
		end

 		if data.current.value == 'recruit' then
			if tedadmember <= Data.slot then
				OpenRecruitMenu(gang)
			else
			ESX.ShowNotification('Slot Gang Shoma Poor Shode Ast, Jahat Afzayesh Be Shop Server Morajee Konid')
			end
		end

 	end, function(data, menu)
		menu.close()
	end)
	end, gang)
	end, gang)
end

function OpenManageEmployeesMenuF5(gang)
	ESX.TriggerServerCallback('gangs:getEmployees', function(employees)
	ESX.TriggerServerCallback('gangs:getGangData', function(data)
	Data.slot  = data.slot

	local tedadmember = 0
	for i=1, #employees, 1 do
		tedadmember = tedadmember + 1
	end

 	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'manage_employees_f5_' .. gang, {
		title    = _U('employee_management'),
		align    = 'top-left',
		elements = {
			{label = _U('recruit'),       value = 'recruit'},
			{label = "Slot: " .. tedadmember.."/"..Data.slot,       value = 'slotsize'}
		}
	}, function(data, menu)


 		if data.current.value == 'recruit' then
			if tedadmember <= Data.slot then
				OpenRecruitMenu(gang)
			else
			ESX.ShowNotification('Slot Gang Shoma Poor Shode Ast, Jahat Afzayesh Be Shop Server Morajee Konid')
			end
		end

 	end, function(data, menu)
		menu.close()
	end)
	end, gang)
	end, gang)
end

function OpenMoneyMenu(gang)

	local elements = {}
	table.insert(elements, {label = "Deposit Money"	,  	value = 'deposit_money'})
	if ESX.PlayerData.gang.grade >= 10 then
		table.insert(elements, {label = "Withdraw Money", 	value = 'withdraw_money'})

	end

	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'money_manage_' .. gang, {
	   title    = _U('money_management'),
	   align    = 'top-left',
	   elements = elements




   	}, function(data, menu)

		if data.current.value == 'withdraw_money' then

			ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'withdraw_society_money_amount_' .. gang, {
				title = _U('withdraw_money')
			}, function(data, menu)

 				local amount = tonumber(data.value)

 				if amount == nil then
					ESX.ShowNotification(_U('invalid_amount'))
				else
					ESX.UI.Menu.CloseAll()
					TriggerServerEvent('gangs:withdrawMoney', gang, amount)
					OpenBossMenu(gang, close, options)
				end

 			end, function(data, menu)
				menu.close()
			end)

		elseif data.current.value == 'deposit_money' then

			ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'deposit_money_amount_' .. gang, {
				title = _U('deposit_money')
			}, function(data, menu)

				 local amount = tonumber(data.value)

				 if amount == nil then
					ESX.ShowNotification(_U('invalid_amount'))
				else
					ESX.UI.Menu.CloseAll()
					TriggerServerEvent('gangs:depositMoney', gang, amount)
					OpenBossMenu(gang, close, options)
				end

			 end, function(data, menu)
				menu.close()
			end)

	   	end

	end, function(data, menu)
	   menu.close()
   end)
end

function OpenEmployeeList(gang)

 	ESX.TriggerServerCallback('gangs:getEmployees', function(employees)

		local elements = {
			head = {_U('employee'), _U('grade'), _U('actions')},
			rows = {}
		}
		local gggrade = ESX.PlayerData.gang.grade

 		for i=1, #employees, 1 do
			local gradeLabel = (employees[i].gang.grade_label == '' and employees[i].gang.label or employees[i].gang.grade_label)

			if employees[i].gang.grade > gggrade -1 then
				table.insert(elements.rows, {data = employees[i], cols = {employees[i].name, gradeLabel, 'DISABLE'}})
			else
				table.insert(elements.rows, {data = employees[i], cols = {employees[i].name, gradeLabel, '{{' .. _U('promote') .. '|promote}} {{' .. _U('fire') .. '|fire}}'}})
			end
		end

 		ESX.UI.Menu.Open('list', GetCurrentResourceName(), 'employee_list_' .. gang, elements, function(data, menu)
			local employee = data.data

 			if data.value == 'promote' then
				menu.close()
				OpenPromoteMenu(gang, employee)
			elseif data.value == 'fire' then
				ESX.ShowNotification(_U('you_have_fired', employee.name))

 				ESX.TriggerServerCallback('gangs:setGang', function()
					OpenEmployeeList(gang)
				end, employee.identifier, 'nogang', 0, 'fire')
			end
		end, function(data, menu)
			menu.close()
			OpenManageEmployeesMenu(gang)
		end)

 	end, gang)

end

function OpenRecruitMenu(gang)


 	ESX.TriggerServerCallback('gangs:getOnlinePlayers', function(players, ppcoords2)

 		local elements = {}


		for i=1, #players, 1 do

			if players[i].gang.name ~= gang then

				targetCoords = players[i].coords
				local distance = GetDistanceBetweenCoords(targetCoords.x, targetCoords.y, targetCoords.z, ppcoords2.x, ppcoords2.y, ppcoords2.z, true)

				if distance <= 15 then
					table.insert(elements, {
						label = players[i].name,
						value = players[i].source,
						name = players[i].name,
						identifier = players[i].identifier,

					})
				end

			end
		end
 		ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'recruit_' .. gang, {
			title    = _U('recruiting'),
			align    = 'top-left',
			elements = elements
		}, function(data, menu)

 			ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'recruit_confirm_' .. gang, {
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


 					ESX.TriggerServerCallback('gangs:setGang', function()
						OpenRecruitMenu(gang)
					end, data.current.identifier, gang, 1, 'hire')
				end
			end, function(data2, menu2)
				menu2.close()
			end)

 		end, function(data, menu)
			menu.close()
		end)

 	end)

end

function OpenPromoteMenu(gangname, employee)

 	ESX.TriggerServerCallback('gangs:getGang', function(gang)

 		local elements = {}
		local gggrade = ESX.PlayerData.gang.grade

 		for i=1, #gang.grades, 1 do
			local gradeLabel = (gang.grades[i].label == '' and gang.label or gang.grades[i].label)

			if gang.grades[i].grade < gggrade then
				table.insert(elements, {
					label = gradeLabel,
					value = gang.grades[i].grade,
					selected = (employee.gang.grade == gang.grades[i].grade)
				})
			end

		end

 		ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'promote_employee_' .. gangname, {
			title    = _U('promote_employee', employee.name),
			align    = 'top-left',
			elements = elements
		}, function(data, menu)
			menu.close()
 			ESX.TriggerServerCallback('gangs:setGang', function()
				OpenEmployeeList(gangname)
			end, employee.identifier, gangname, data.current.value, 'promote')
		end, function(data, menu)
			menu.close()
			OpenEmployeeList(gangname)
		end)

 	end, gangname)

end

function OpenManageGradesMenu(gangname)

 	ESX.TriggerServerCallback('gangs:getGang', function(gang)

 		local elements = {}

 		for i=1, #gang.grades, 1 do
			local gradeLabel = (gang.grades[i].label == '' and gang.label or gang.grades[i].label)

 			table.insert(elements, {
				label = ('%s - <span style="color:green;">%s</span>'):format(gradeLabel, _U('money_generic', ESX.Math.GroupDigits(gang.grades[i].salary))),
				value = gang.grades[i].grade
			})
		end

 		ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'manage_grades_' .. gang.name, {
			title    = _U('salary_management'),
			align    = 'top-left',
			elements = elements
		}, function(data, menu)

 			ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'manage_grades_amount_' .. gang.name, {
				title = _U('salary_amount')
			}, function(data2, menu2)

 				local amount = tonumber(data2.value)

 				if amount == nil then
					ESX.ShowNotification(_U('invalid_amount'))
				elseif amount > Config.MaxSalary then
					ESX.ShowNotification(_U('invalid_amount_max'))
				else
					menu2.close()

 					ESX.TriggerServerCallback('gangs:setGangSalary', function()
						OpenManageGradesMenu(gangname)
					end, gang, data.current.value, amount)
				end

 			end, function(data2, menu2)
				menu2.close()
			end)

 		end, function(data, menu)
			menu.close()
		end)

 	end, gangname)

end

function OpensetPermGarage(gang, rank)
	ESX.TriggerServerCallback('gangprop:getCars',function(vehicles)
		ESX.TriggerServerCallback('gangs:GetPermData', function(vyitems)
			ESX.TriggerServerCallback('gangs:getGangData', function(data)
				Data.vehspawn = json.decode(data.vehspawn)
				if vehicles == nil or vehicles == {} then
					TriggerEvent("chatMessage", "[SYSTEM]", {255, 0, 0}, "^0Gang Shoma Mashin Heli Nadarad!")
					return
				end

				local elements = {}
				table.insert(elements, {label = ' Esm Mashin | Access'})
				for i,v in pairs(vehicles) do
					local carname = GetDisplayNameFromVehicleModel(v.vehicle.model)
					local mmodel = v.vehicle.model
					local plate2 = v.vehicle.plate
					local classnumber = GetVehicleClassFromName(mmodel)
					local velLabel = GetLabelText(carname)
					if classnumber ~= 14 and classnumber ~= 15 and classnumber ~= 16 then
						if checktable(elements, carname) then
							if checkas(carname, 'car', vyitems, plate2) == true then
								table.insert(elements, {label = velLabel..' | '..v.vehicle.plate .." | <font color=Lime>✅</font>", VehLebel = velLabel, value = v})
							else
								table.insert(elements, {label = velLabel..' | '..v.vehicle.plate .." | <font color=red>❌</font>", VehLebel = velLabel, value = v})
							end
						end
					end
				end
				camera = CreateCam("DEFAULT_SCRIPTED_CAMERA", false)
				ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'Vehicles_list', {
					title    = 'Vehicle List',
					align    = 'top-left',
					elements = elements
				}, function(data, menu)
					if data.current.value then
						local item = GetDisplayNameFromVehicleModel(data.current.value.vehicle.model)
						local plates = data.current.value.vehicle.plate
						local vehllabel = data.current.VehLebel
						ESX.TriggerServerCallback('gangs:SetPermData', function(result)

							OpensetPermGarage(gang, rank)
						end, gang, rank, item, 'car', plates, vehllabel)
					end















































					end, function(data, menu)




						if localVeh then
						DeleteVehicle(localVeh)
						localVeh = nil
						end
						if camera then
						ClearFocus()
						RenderScriptCams(false, false, 0, true, false)
						DestroyCam(camera, false)
						camera = nil

						end
						SetopAccess(gang, 'mg')
					end)
			end, gang)
		end, gang, rank, 'car')
	end, gang)
end

function OpensetPermheli(gang, rank)
	ESX.TriggerServerCallback('gangprop:getCars',function(vehicles)
		ESX.TriggerServerCallback('gangs:GetPermData', function(vyitems)
			ESX.TriggerServerCallback('gangs:getGangData', function(data)
				Data.helispawn = json.decode(data.helispawn)
				if vehicles == nil or vehicles == {} then
					TriggerEvent("chatMessage", "[SYSTEM]", {255, 0, 0}, "^0Gang Shoma Hich Heli Nadarad!")
					return
				end

				local elements = {}
				table.insert(elements, {label = ' Esm Heli | Access'})
				for i,v in pairs(vehicles) do
					local mmodel = v.vehicle.model
					local plate2 = v.vehicle.plate
					local classnumber = GetVehicleClassFromName(mmodel)
					if classnumber == 15 then
						local carname = GetDisplayNameFromVehicleModel(v.vehicle.model)
						local velLabel = GetLabelText(carname)

						if checktable(elements, carname) then
							if checkas(carname, 'heli', vyitems, plate2) == true then
								table.insert(elements, {label = velLabel..' | '..v.vehicle.plate .." | <font color=Lime>✅</font>", VehLabel = velLabel, value = v})
							else
								table.insert(elements, {label = velLabel..' | '..v.vehicle.plate .." | <font color=red>❌</font>", VehLabel = velLabel, value = v})
							end
						end
					end
				end
				camera = CreateCam("DEFAULT_SCRIPTED_CAMERA", false)
				ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'Heli_list', {
					title    = 'Heli List',
					align    = 'top-left',
					elements = elements
				}, function(data, menu)
					if data.current.value then
						local item = GetDisplayNameFromVehicleModel(data.current.value.vehicle.model)
						local plates = data.current.value.vehicle.plate
						local vehicllabel = data.current.VehLabel
						ESX.TriggerServerCallback('gangs:SetPermData', function(result)
							OpensetPermheli(gang, rank)
						end, gang, rank, item, 'heli',plates, vehicllabel)
					end

				end, function(data, menu)

					menu.close()

				end, function(data, menu)

					if localVeh then
						DeleteVehicle(localVeh)
						localVeh = nil
					end
					if data.current.value then


						local shokol = GetClosestVehicle(Data.helispawn.x,  Data.helispawn.y,  Data.helispawn.z,  3.0,  0,  71)
						if not DoesEntityExist(shokol) then
						  SetCamCoord(camera, Data.helispawn.x + 3.0, Data.helispawn.y + 5.0, Data.helispawn.z+ 4.0)
						  SetCamActive(camera, true)
						  PointCamAtCoord(camera, Data.helispawn.x, Data.helispawn.y, Data.helispawn.z)
						  RenderScriptCams(true, true, 1000, true, false)


							ESX.TriggerServerCallback('esx_advancedgarage:GetVehiclePropsFromPlate', function(vehicle)
								local vehicle = data.current.value.vehicle
								if not localVeh then
									ESX.Game.SpawnLocalVehicle(vehicle.model, Data.helispawn, Data.helispawn.a, function(callback_vehicle)

										if localVeh then
											DeleteVehicle(callback_vehicle)
										else
											localVeh = callback_vehicle
											vehicle.plate = data.current.value.plate

											SetVehRadioStation(callback_vehicle, "OFF")

										end

									end)
								end
							end, data.current.value.plate)


						else
							ESX.ShowNotification('Mahale Spawm Mashin Por Ast!!')
						end
						end
					end, function(data, menu)




						if localVeh then
						DeleteVehicle(localVeh)
						localVeh = nil
						end
						if camera then
						ClearFocus()
						RenderScriptCams(false, false, 0, true, false)
						DestroyCam(camera, false)
						camera = nil

						end
						SetopAccess(gang, 'hl')
					end)
			end, gang)
		end, gang, rank, 'heli')
	end, gang)
end

function OpensetPermboat(gang, rank)
	ESX.TriggerServerCallback('gangprop:getCars',function(vehicles)
		ESX.TriggerServerCallback('gangs:GetPermData', function(vyitems)
			ESX.TriggerServerCallback('gangs:getGangData', function(data)
				Data.boatspawn = json.decode(data.boatspawn)
				if vehicles == nil or vehicles == {} then
					TriggerEvent("chatMessage", "[SYSTEM]", {255, 0, 0}, "^0Gang Shoma Boat Heli Nadarad!")
					return
				end

				local elements = {}
				table.insert(elements, {label = ' Esm Boat | Access'})
				for i,v in pairs(vehicles) do
					local mmodel = v.vehicle.model
					local plate2 = v.vehicle.plate
					local classnumber = GetVehicleClassFromName(mmodel)
					if classnumber == 14 then
						local carname = GetDisplayNameFromVehicleModel(v.vehicle.model)
						local velLabel = GetLabelText(carname)
						if checktable(elements, carname) then
							if checkas(carname, 'boat', vyitems, plate2) == true then
								table.insert(elements, {label = velLabel..' | '..v.vehicle.plate .." | <font color=Lime>✅</font>", VehLabel = velLabel, value = v})
							else
								table.insert(elements, {label = velLabel..' | '..v.vehicle.plate .." | <font color=red>❌</font>", VehLabel = velLabel, value = v})
							end
						end
					end
				end
				camera = CreateCam("DEFAULT_SCRIPTED_CAMERA", false)
				ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'Boat_list', {
					title    = 'Boat List',
					align    = 'top-left',
					elements = elements
				}, function(data, menu)
					if data.current.value then
						local item = GetDisplayNameFromVehicleModel(data.current.value.vehicle.model)
						local plates = data.current.value.vehicle.plate
						local VehLabbel = data.current.VehLabel
						ESX.TriggerServerCallback('gangs:SetPermData', function(result)
							OpensetPermboat(gang, rank)
						end, gang, rank, item, 'boat', plates, VehLabbel)
					end

				end, function(data, menu)

					menu.close()

				end, function(data, menu)

					if localVeh then
						DeleteVehicle(localVeh)
						localVeh = nil
					end
					if data.current.value then


						local shokol = GetClosestVehicle(Data.boatspawn.x,  Data.boatspawn.y,  Data.boatspawn.z,  3.0,  0,  71)
						if not DoesEntityExist(shokol) then
						  SetCamCoord(camera, Data.boatspawn.x + 3.0, Data.boatspawn.y + 5.0, Data.boatspawn.z+ 4.0)
						  SetCamActive(camera, true)
						  PointCamAtCoord(camera, Data.boatspawn.x, Data.boatspawn.y, Data.boatspawn.z)
						  RenderScriptCams(true, true, 1000, true, false)


							ESX.TriggerServerCallback('esx_advancedgarage:GetVehiclePropsFromPlate', function(vehicle)
								local vehicle = data.current.value.vehicle
								if not localVeh then
									ESX.Game.SpawnLocalVehicle(vehicle.model, Data.boatspawn, Data.boatspawn.a, function(callback_vehicle)

										if localVeh then
											DeleteVehicle(callback_vehicle)
										else
											localVeh = callback_vehicle
											vehicle.plate = data.current.value.plate

											SetVehRadioStation(callback_vehicle, "OFF")

										end

									end)
								end
							end, data.current.value.plate)


						else
							ESX.ShowNotification('Mahale Spawm Mashin Por Ast!!')
						end
						end
					end, function(data, menu)




						if localVeh then
						DeleteVehicle(localVeh)
						localVeh = nil
						end
						if camera then
						ClearFocus()
						RenderScriptCams(false, false, 0, true, false)
						DestroyCam(camera, false)
						camera = nil

						end
						SetopAccess(gang, 'bt')
					end)
			end, gang)
		end, gang, rank, 'boat')
	end, gang)
end

function OpensetPermitems(gang, rank)
	ESX.TriggerServerCallback("gangs:getPropertyInventory",function(inventory)
		ESX.TriggerServerCallback('gangs:GetPermData', function(vyitems)
			local elements = {}

			for k,v in pairs(inventory) do
				if k == 'items' then

					for k2,v2 in pairs(v) do
						if checktable(elements, v2.name) then
							if checkas(v2.name, 'inventorys', vyitems) == true then

								table.insert(elements, {label = v2.label.. " | <font color=Lime>✅</font>", value = v2.name, type = 'item'})
							else
								table.insert(elements, {label = v2.label.. " | <font color=red>❌</font>", value = v2.name, type = 'item'})
							end
						end
					end

				end
			end
		ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'Weapons_list', {
				title    = 'Choose one',
				align    = 'top-left',
				elements = elements
			}, function(data, menu)
				local item = data.current.value
				local itype = data.current.type
				if itype ~= 'lable' then
					ESX.TriggerServerCallback('gangs:SetPermData', function(result)
						OpensetPermitems(gang, rank)
					end, gang, rank, item, 'inventorys')
				end
			end, function(data, menu)
				menu.close()
				SetopAccess(gang, 'itmh')
			end)
		end, gang, rank, 'inventorys')
	end,gang, 'inventorys')
end

function OpensetPermguns(gang, rank)
	ESX.TriggerServerCallback("gangs:getPropertyInventory",function(inventory)
		ESX.TriggerServerCallback('gangs:GetPermData', function(vyitems)
			local elements = {}

			for k,v in pairs(inventory) do
				if k == 'weapons' then
					for k2,v2 in pairs(v) do
						if checktable(elements, v2.name) then
							if checkas(v2.name, 'inventorys', vyitems) == true then
								table.insert(elements, {label = GetModelLabel(v2.name).. " | <font color=Lime>✅</font>", value = v2.name, type = 'weapons'})
							else
								table.insert(elements, {label = GetModelLabel(v2.name).. " | <font color=red>❌</font>", value = v2.name, type = 'weapons'})
							end
						end
					end

				end
			end
		ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'Weapons_list', {
				title    = 'Weapon list',
				align    = 'top-left',
				elements = elements
			}, function(data, menu)
				local weapon = data.current.value
				local itype = data.current.type

					ESX.TriggerServerCallback('gangs:SetPermData', function(result)
						OpensetPermguns(gang, rank)
					end, gang, rank, weapon, 'inventorys')

			end, function(data, menu)
				menu.close()
				SetopAccess(gang, 'wp')
			end)
		end, gang, rank, 'inventorys')
	end,gang, 'inventorys')
end

function OpensetCrafting()
	local playerdata = ESX.GetPlayerData()
	local gname = playerdata.gang.name

	ESX.TriggerServerCallback('gang:getGrades', function(grades22)
		local elements = {}
		local gggrade = ESX.PlayerData.gang.grade
			for k,v in pairs(grades22) do
				local craftha = v.crafting
				local gangname = v.gang_name
				if k <= gggrade then
					if craftha == 1 then
						table.insert(elements, {label = '(' .. k .. ') | ' .. v.label.." | <font color=Lime>✅</font>", grade = k, gname2 = gangname, value = craftha})
					else
						table.insert(elements, {label = '(' .. k .. ') | ' .. v.label.."| <font color=red>❌</font>", grade = k, gname2 = gangname, value = craftha})
					end
				end
			end

		ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'craft', {
			title    = 'Weapon list',
			align    = 'top-left',
			elements = elements
		}, function(data, menu)
			local weapon = data.current.value
			local rank = data.current.grade
			local gname2 = data.current.gname2

				ESX.TriggerServerCallback('gangs:SetPermData', function(result)
					OpensetCrafting()
				end, gname2, rank, weapon, 'craft')

		end, function(data, menu)
			menu.close()
			OpenManageAccess(gang)
		end)
	end)

end

function SetopAccess(gang, op)
	ESX.TriggerServerCallback('gang:getGrades', function(grades)
		local elements = {}
		local gggrade = ESX.PlayerData.gang.grade

		  for k,v in pairs(grades) do
			if k <= gggrade then
				table.insert(elements, {label = '(' .. k .. ') | ' .. v.label, grade = k})
			end
		  end

	  ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'show_grade_list', {
		  title    = 'Choose one of rank',
		  align    = 'top-left',
		  elements = elements
	  }, function(data, menu)
		local grade = data.current.grade
		if op == 'itmh' then
			OpensetPermitems(gang, grade)
		elseif op == 'mg' then
			OpensetPermGarage(gang, grade)

		elseif op == 'hl' then
			OpensetPermheli(gang, grade)

		elseif op == 'bt' then
			OpensetPermboat(gang, grade)
		elseif op == 'wp' then
			OpensetPermguns(gang, grade)


		end

	  end, function(data, menu)
		  menu.close()
		  OpenManageAccess(gang)
	  end)
	end)
end

function OpenManageAccess(gang)
	local elements = {
		{label = 'Mashin Access', op = 'mg'},
		{label = 'Heli Access', op = 'hl'},
		{label = 'Boat Access', op = 'bt'},
		{label = 'Item Access', op = 'itmh'},
		{label = 'weapon Access', op = 'wp'},
		{label = 'Crafting Access', op = 'craft'},

	}

	  ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'show_gang_manage_list', {
		  title    = 'Manage your gang',
		  align    = 'top-left',
		  elements = elements
	  }, function(data, menu)
		local op = data.current.op
		if op == 'mvp' then
			SetVestp()
		elseif op == 'set_inv' then
			SetInv()
		elseif op == 'set_craft' then
			SetCraft()
		elseif op == 'craft' then
			OpensetCrafting()
		elseif op == 'manage_grades' then
			OpenManageGradesMenu(gang)
		else
			SetopAccess(gang, op)
		end
	  end, function(data, menu)
		  menu.close()
	  end)
end

function checktable(table, item)
	local can = true
	for k,v in pairs(table) do
		if v.value == item then
			can = false
		end
	end
	return can
end

function checkas(item, type, vyitems, plate2)
	if vyitems == nil or vyitems == {} then
		return false
	end
	if type == 'inventorys' then
			local found = false
			for k, v in ipairs(vyitems) do
				if string.lower(v.name) == string.lower(item) then
					if v.state == true then
						found = true
					end
					break
				end
			end
			return found
	elseif type == 'car' then
			local found = false
			for k, v in ipairs(vyitems) do
				if string.lower(v.name) == string.lower(item) and string.lower(v.plate) == string.lower(plate2) then
					if v.state == true then
						found = true
					end
					break
				end
			end
			return found

	elseif type == 'heli' then
			local found = false
			for k, v in ipairs(vyitems) do
				if string.lower(v.name) == string.lower(item) and string.lower(v.plate) == string.lower(plate2) then
					if v.state == true then
						found = true
					end
					break
				end
			end
			return found

	elseif type == 'boat' then
		local found = false
		for k, v in ipairs(vyitems) do
			if string.lower(v.name) == string.lower(item) and string.lower(v.plate) == string.lower(plate2) then
				if v.state == true then
					found = true
				end
				break
			end
		end
		return found
	end
end

function GetModelLabel(name)
	local label = string.upper(string.gsub(name, 'WEAPON_', ''))
	label = string.gsub(label, '_', '')
	return label
end

AddEventHandler('gangs:openBossMenu', function(gang, close, options)
	OpenBossMenu(gang, close, options)
end)

AddEventHandler('gangs:openInviteF5', function(gang, close, options)
	OpenManageEmployeesMenuF5(gang)
end)
