-- Pub by FleeX Team , https://discord.gg/87rGBxgCsa

ESX = exports['essentialmode']:getObject()
jobPermissions = nil

Citizen.CreateThread(function()
	while ESX.GetPlayerData().job == nil do
		Citizen.Wait(10)
	end

	ESX.PlayerData = ESX.GetPlayerData()
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
	ESX.PlayerData.job = job
	if ESX.PlayerData.job.name ~= 'nojob' then
		local p = promise.new()
		ESX.TriggerServerCallback('esx_society:getJobPerm',function(cb)
			p:resolve(cb)
		end)
		jobPermissions = Citizen.Await(p) or {}
	end
end)

local outfitComponents = {
	'tshirt_1', 'tshirt_2', 'torso_1', 'torso_2', 'decals_1', 'decals_2',
	'mask_1', 'mask_2', 'arms', 'arms_2', 'pants_1', 'pants_2',
	'bproof_1', 'bproof_2', 'shoes_1', 'shoes_2', 'chain_1', 'chain_2',
	'bags_1', 'bags_2', 'helmet_1', 'helmet_2', 'glasses_1', 'glasses_2',
	'ear_accessories', 'ear_accessories_color',
}

function DoEditJobOutfit(grade, division, sex, outfit)
	CreateThread(function()
		TriggerEvent('skinchanger:disableAC', true)
		local lastskin
		TriggerEvent('skinchanger:getSkin', function(skin)
			lastskin = ESX.CopyTable2(skin)
		end)
		local base = lastskin and ESX.CopyTable2(lastskin) or {}
		base.sex = sex
		TriggerEvent('skinchanger:loadClothes', base, outfit or {})
		Wait(1000)
		ESX.ShowNotification(sex == 0 and 'Dar hale virayesh uniform mard' or 'Dar hale virayesh uniform zan')
		local done = false
		local function finish()
			if done then return end
			done = true
			TriggerEvent('skinchanger:getSkin', function(skin)
				local out = ESX.CopyTable2(skin)
				out.sex = sex
				ESX.TriggerServerCallback('esx_society:saveskin', function()
					ESX.ShowNotification('Uniform zakhire shod')
				end, grade, out, division)
			end)
			CreateThread(function()
				Wait(500)
				TriggerEvent('skinchanger:disableAC', false)
				if lastskin then
					TriggerEvent('skinchanger:loadSkin', lastskin, function()
						TriggerEvent("esx:restoreLoadout")
					end)
				else
					TriggerEvent("esx:restoreLoadout")
				end
			end)
		end
		TriggerEvent('esx_skin:openRestrictedMenu', function(data, menu)
			finish()
		end, function(data, menu)
			finish()
			if menu then menu.close() end
		end, outfitComponents)
	end)
end

function OpenManageClotheMenu(society)

	ESX.TriggerServerCallback('esx_society:getJob', function(job)

		local elements = {}

		for i=1, #job.grades, 1 do
			local gradeLabel = (job.grades[i].label == '' and job.label or job.grades[i].label)

			table.insert(elements, {
				label = gradeLabel,
				value = job.grades[i].grade,
				skin_male = json.decode(job.grades[i].skin_male),
				skin_female = json.decode(job.grades[i].skin_female),
				division = false
			})
		end

		for i=1, #job.divisions, 1 do
			local gradeLabel = job.divisions[i].name

			table.insert(elements, {
				label = gradeLabel,
				value = gradeLabel,
				skin_male = json.decode(job.divisions[i].skin_male),
				skin_female = json.decode(job.divisions[i].skin_female),
				division = true
			})
		end

		ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'manage_clothe_' .. society, {
			title    = 'Modiriat Lebas',
			align    = 'top-left',
			elements = elements
		}, function(data, menu)
			grade = data.current.value
			division = data.current.division
			local elements2 = {}
			table.insert(elements2, {
				label = "ویرایش یونیفرم مرد 👔",
				value = "edit_male",
			})
			table.insert(elements2, {
				label = "ویرایش یونیفرم زن 👗",
				value = "edit_female",
			})
			skin_male = data.current.skin_male
			skin_female = data.current.skin_female
			ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'manage_clothe2_' .. society, {
				title    = 'Modiriat Lebas',
				align    = 'top-left',
				elements = elements2
			}, function(data2, menu2)
				if data2.current.value == "edit_male" then
					ESX.UI.Menu.CloseAll()
					DoEditJobOutfit(grade, division, 0, skin_male)
				elseif data2.current.value == "edit_female" then
					ESX.UI.Menu.CloseAll()
					DoEditJobOutfit(grade, division, 1, skin_female)
				end
			end, function(data2, menu2)
				menu2.close()
				TriggerEvent("esx:restoreLoadout")
			end)

		end, function(data, menu)
			menu.close()
			TriggerEvent("esx:restoreLoadout")
		end)

	end, society)

end

AddEventHandler('esx_society:openbossss', function(society)
	OpenJobBossMenu(society)
end)

RegisterCommand('addcarjob',function(source,args)
end, false)

RegisterNetEvent('society:addCarJob', function()
	if IsPedInAnyVehicle(PlayerPedId()) then
		local data = ESX.Game.GetVehicleProperties(GetVehiclePedIsIn(PlayerPedId()))
		local input = lib.inputDialog('Label mashin ra vared konid', {
			{type = 'input', label = 'Label', required = true},
			{type = 'checkbox', label = 'Helicopter'},
		})
		if input and input[1] then
			TriggerServerEvent('addcarjob',data, input[1], input[2] and 'heli')
		end
	else
		ESX.ShowNotification('Savar mashin nisti')
	end
end)

RegisterNetEvent('DeleteCar:Open')
AddEventHandler('DeleteCar:Open', function(data)
	local List = {}
	for k , v in pairs(data) do
		if not k:find('off') and ESX.TableLength(v.vehicles) > 0 then
			table.insert(List,{
				img = 'SS_gold.png',
				text = k,
				text2 = k,
				callBack = function()
					exports.icon_menu:ForceCloseMenu()
					OpenJobVehMenu(data,k)
			end})
		end
	end
	exports.icon_menu:OpenMenu(List)
end)

function OpenJobVehMenu(data,job)
	local List = {}
	local jobvehicle = data[job].vehicles
	for k , v in ipairs(jobvehicle) do
		table.insert(List,{
			img = 'SS_gold.png',
			text = v.label,
			text2 = v.label,
			callBack = function()
				TriggerServerEvent('esx_society:DeleteCar',job,k,v.label)
				exports.icon_menu:ForceCloseMenu()
		end})
	end
	exports.icon_menu:OpenMenu(List)
end

exports('doesHavePerm', function(key)
	if not jobPermissions then
		local p = promise.new()
		ESX.TriggerServerCallback('esx_society:getJobPerm',function(cb)
			p:resolve(cb)
		end)
		jobPermissions = Citizen.Await(p) or {}
	end
	return (jobPermissions[tostring(ESX.PlayerData.job.grade)] and jobPermissions[tostring(ESX.PlayerData.job.grade)][key]) or (jobPermissions[tostring(ESX.PlayerData.job.ext)] and jobPermissions[tostring(ESX.PlayerData.job.ext)][key])
end)

RegisterNetEvent('society:updatePermissions', function(_jobPermissions)
	jobPermissions = _jobPermissions
end)
