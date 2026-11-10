-- Pub by FleeX Team , https://discord.gg/87rGBxgCsa

local currentSociety = nil
local currentGradeCount = 0
local uiOpen = false
local menuColors = { primary = '#b91c1c', secondary = '#ef4444' }

AddEventHandler('sun_menu:settings', function(s)
	if type(s) == 'table' and s.boss then
		menuColors = {
			primary = s.boss.colorPrimary or s.boss.color or menuColors.primary,
			secondary = s.boss.color or menuColors.secondary,
		}
		if uiOpen then
			SendNUIMessage({ type = 'colors', colors = menuColors })
		end
	end
end)

local function hideUI()
	uiOpen = false
	SetNuiFocus(false, false)
	SendNUIMessage({ type = 'hide' })
end

function OpenJobBossMenu(soc)
	if not soc then return end
	if ESX.PlayerData == nil or ESX.PlayerData.job == nil then return end
	if ESX.PlayerData.job.name:find('off') then
		ESX.ShowNotification('Shoma nemitavanid dar halat off duty be menu boss dastresi dashte bashid')
		return
	end

	currentSociety = soc
	local data
	local p = promise.new()
	ESX.TriggerServerCallback('esx_society:getBossData', function(res)
		data = res
		p:resolve()
	end, soc)
	Citizen.Await(p)

	if not data or not data.ok then return end

	currentGradeCount = data.grades and #data.grades or 0
	data.type = 'show'
	data.colors = menuColors
	SetNuiFocus(true, true)
	SendNUIMessage(data)
	uiOpen = true
end

local function buildRankPerms(soc, gradeId, isDivision, perms, gradeName)
	local list = {}
	local g = tostring(gradeId)
	local function add(key, label, kind)
		local state = perms[g] and perms[g][key] and true or false
		list[#list + 1] = { key = key, label = label, state = state, kind = kind or 'var' }
	end

	if not isDivision then
		list[#list + 1] = { key = '__boss', label = 'باس (Boss)', state = gradeName == 'boss', kind = 'boss' }
	end
	add('employeeManagement', 'مدیریت اعضا', 'employee')
	add('fire', 'اخراج عضو')
	add('depCmd', 'دستور dep/')

	if soc == 'mechanic' then
		add('vehicleCustom', 'کاستوم خودرو', 'custom')
	elseif soc == 'police' or soc == 'sheriff' or soc == 'mt' or soc == 'detective' then
		add('vacium', 'وکیوم')
		add('checkBullet', 'بررسی گلوله')
		add('teleporter', 'تله‌پورتر')
		add('changejob', 'دستور changejob/')
		add('resetplan', 'دستور resetplan/')
		add('redCode', 'کد قرمز (rr/)')
		add('checkMedic', 'بررسی درخواست EMS')
	elseif soc == 'resturan' then
		add('craftWithLocker', 'استفاده از لاکر (کرفت)')
		add('craftedItemLocker', 'آیتم کرفت‌شده به لاکر برود')
		local ok, cfg = pcall(function() return exports['sunset_utils']:getResturanConfig() end)
		if ok and cfg and cfg.craft and cfg.craft.items then
			for _, v in pairs(cfg.craft.items) do
				add(v.label, 'کرفت ' .. v.label)
			end
		end
	elseif soc == 'fbi' then
		add('findPlate', 'دستور findplate/')
		add('findNumber', 'دستور findnumber/')
		add('banBank', 'دستور banbank/')
		add('banPlate', 'دستور banplate/')
		add('acall2', 'دستور acall2/')
		add('fbiWarn', 'دستور fwarn/')
		add('banParking', 'دستور banparking/')
		add('checkacc', 'دستور checkacc/')
	elseif soc == 'weazel' or soc == 'taxi' then
		add('adApprove', 'تایید تبلیغ')
		add('adDelete', 'حذف تبلیغ')
		add('tweetApprove', 'تایید و رد توییت')
		add('tweetDelete', 'حذف توییت')
		add('newsApprove', 'ثبت و تایید خبر')
		add('newsDelete', 'حذف خبر')
		add('news', 'دستور news/')
	end

	if soc == 'fbi' or soc == 'justice' then add('regfbi', 'دستور regfbi/') end
	if soc == 'justice' then
		add('setjwarn', 'دستور setjwarn/')
		add('docCreate', 'سند: ساخت و ویرایش')
		add('docTemplate', 'سند: ساخت الگوی کلی')
		add('docPublicTemplate', 'سند: ساخت الگوی عمومی')
		add('docSeal', 'سند: زدن مهر دادگستری')
		add('docDelete', 'سند: حذف')
		add('docArchive', 'سند: بایگانی و باطل کردن')
	end
	if soc == 'sheriff' then add('viewjwarn', 'دستور viewjwarn/') end

	if ESX.militaryJobs2 and ESX.militaryJobs2[soc] then
		add('openCAD', 'باز کردن CAD')
		add('addDataCAD', 'افزودن دیتا (CAD)')
		add('removeDataCAD', 'حذف دیتا (CAD)')
		add('buyWeapon', 'خرید سلاح')
	end

	if soc ~= 'wash' and soc ~= 'carbimeh' then
		add('edivision', 'دیویژن اضافه (edivision/)')
	end
	add('updateSlot', 'تغییر اسلات اینونتوری')
	if soc == 'resturan' or soc == 'taxi' then add('delivery', 'پست (Delivery)') end
	if soc == 'taxi' then add('peyk', 'پیک') end
	if soc == 'ambulance' then add('plasticSurgery', 'جراحی پلاستیک') end
	add('spawnPet', 'اسپاون پت')
	add('buyItem', 'خرید آیتم')

	local ok, lcfg = pcall(function() return exports['sunset_utils']:getLicenseConfig() end)
	if ok and lcfg and lcfg.licenses then
		for k, v in pairs(lcfg.licenses) do
			if v.viewAccess and (v.viewAccess.all or v.viewAccess[soc]) then
				add('view_license_' .. k, ('مشاهده مدرک %s'):format(v.label))
			end
			if v.addAccess and (v.addAccess.all or v.addAccess[soc]) then
				add('add_license_' .. k, ('افزودن مدرک %s'):format(v.label))
			end
			if v.removeAccess and (v.removeAccess.all or v.removeAccess[soc]) then
				add('remove_license_' .. k, ('حذف مدرک %s'):format(v.label))
			end
		end
	end

	return list
end

local function buildLogList(job)
	local function key(feature) return ('job_%s_%s'):format(job, feature) end
	local logs = {
		{ name = 'اسپاون ماشین', index = key('spawncar') },
		{ name = 'لاکر', index = key('locker') },
		{ name = 'باس اکشن', index = key('boss') },
		{ name = 'قبض', index = key('invoice') },
		{ name = 'کمد', index = key('closet') },
		{ name = 'دیوتی', index = key('duty') },
		{ name = 'مدیریت مدرک', index = key('license') },
		{ name = 'پول', index = key('money') },
		{ name = 'کاستوم شاپ', index = key('customshop') },
	}
	if ESX.militaryJobs2 and ESX.militaryJobs2[job] then
		logs[#logs + 1] = { name = 'زندان', index = key('jail') }
		logs[#logs + 1] = { name = 'هایجک', index = key('hijack') }
		logs[#logs + 1] = { name = 'پارکینگ', index = key('impound') }
		logs[#logs + 1] = { name = 'سرقت حقوق', index = 'job_rob_salary' }
	end
	if job == 'police' then
		logs[#logs + 1] = { name = 'پارکینگ ۲', index = key('impound2') }
	end
	if job == 'mechanic' then
		logs[#logs + 1] = { name = 'کاستوم', index = key('custom') }
		logs[#logs + 1] = { name = 'تعمیر', index = key('repair') }
		logs[#logs + 1] = { name = 'پارکینگ', index = key('impound') }
		logs[#logs + 1] = { name = 'پارکینگ ۲', index = key('impound2') }
		logs[#logs + 1] = { name = 'لیست درخواست', index = key('list') }
		logs[#logs + 1] = { name = 'نصب موتور', index = key('installengine') }
	end
	if job == 'fbi' then
		logs[#logs + 1] = { name = 'تغییر نام', index = key('changename') }
		logs[#logs + 1] = { name = 'بن بانک', index = key('banbank') }
		logs[#logs + 1] = { name = 'بن پلاک', index = key('banplate') }
		logs[#logs + 1] = { name = 'بن پارکینگ', index = key('banparking') }
		logs[#logs + 1] = { name = 'ثبت FBI', index = key('reg') }
		logs[#logs + 1] = { name = 'سلاح CAD', index = key('weaponcad') }
	end
	if job == 'ambulance' then
		logs[#logs + 1] = { name = 'احیا', index = key('revive') }
		logs[#logs + 1] = { name = 'لیست درخواست', index = key('list') }
	end
	if job == 'taxi' then
		logs[#logs + 1] = { name = 'پیک', index = key('peyk') }
		logs[#logs + 1] = { name = 'تحویل پیک', index = key('tahvilpeyk') }
		logs[#logs + 1] = { name = 'لیست درخواست', index = key('list') }
		logs[#logs + 1] = { name = 'سفر', index = key('trip') }
		logs[#logs + 1] = { name = 'ویزل', index = 'job_weazel_ad' }
	end
	if job == 'carbimeh' then
		logs[#logs + 1] = { name = 'خرید بیمه', index = 'job_bimeh_buy' }
	end
	if job == 'ambulance' or job == 'mechanic' then
		logs[#logs + 1] = { name = 'کرفت', index = key('craft') }
	end
	if job == 'car' then
		logs[#logs + 1] = { name = 'فروش خودرو', index = 'job_car_sellcar' }
		logs[#logs + 1] = { name = 'خرید خودرو', index = 'job_car_buycar' }
	end
	return logs
end

RegisterNUICallback('close', function(_, cb)
	hideUI()
	cb('ok')
end)

RegisterNUICallback('refresh', function(_, cb)
	ESX.TriggerServerCallback('esx_society:getBossData', function(res)
		cb(res)
	end, currentSociety)
end)

RegisterNUICallback('deposit', function(data, cb)
	local amount = ESX.Math.Round(tonumber(data.amount) or 0)
	if amount and amount > 0 then
		ESX.TriggerServerEvent('esx_society:depositMoney', currentSociety, amount)
	end
	cb('ok')
end)

RegisterNUICallback('withdraw', function(data, cb)
	local amount = ESX.Math.Round(tonumber(data.amount) or 0)
	if amount and amount > 0 then
		ESX.TriggerServerEvent('esx_society:withdrawMoney', currentSociety, amount)
	end
	cb('ok')
end)

RegisterNUICallback('getMembers', function(data, cb)
	local soc = data.off and ('off' .. currentSociety) or currentSociety
	ESX.TriggerServerCallback('esx_society:getEmployees', function(employees)
		local myGrade = ESX.PlayerData.job.grade
		local myId = ESX.PlayerData.identifier
		local list = {}
		for _, v in ipairs(employees or {}) do
			local canManage = v.job.grade < myGrade and v.identifier ~= myId
			local canSwapMember = v.job.grade <= myGrade
			list[#list + 1] = {
				name = v.name,
				identifier = v.identifier,
				job = v.job.name,
				grade = v.job.grade,
				gradeName = v.job.grade_name,
				gradeLabel = (v.job.grade_label and v.job.grade_label ~= '' and v.job.grade_label) or v.job.label,
				profileUrl = v.headshot or v.profilePicture,
				canPromote = canManage,
				canFire = canManage,
				canSwap = canSwapMember,
			}
		end
		cb(list)
	end, soc)
end)

RegisterNUICallback('hire', function(_, cb)
	cb('ok')
	hideUI()
	ESX.selectPlayerMenu(function(src)
		ESX.TriggerServerCallback('esx_society:setJob', function()
			Wait(500)
			OpenJobBossMenu(currentSociety)
		end, src, currentSociety, 1, 'hire')
	end, 20, function(src)
		return ESX.GetPlayerState(src, 'job') == nil
	end)
end)

RegisterNUICallback('fire', function(data, cb)
	ESX.TriggerServerCallback('esx_society:setJob', function()
		cb('ok')
	end, data.identifier, 'nojob', 0, 'fire')
end)

RegisterNUICallback('promote', function(data, cb)
	local job = data.job or currentSociety
	ESX.TriggerServerCallback('esx_society:setJob', function()
		cb('ok')
	end, data.identifier, job, tonumber(data.grade), 'promote')
end)

RegisterNUICallback('swap', function(data, cb)
	ESX.TriggerServerCallback('esx_society:setJob', function()
		cb('ok')
	end, data.identifier, currentSociety, tonumber(data.grade), 'promote', data.toJob)
end)

RegisterNUICallback('getSwapGrades', function(data, cb)
	ESX.TriggerServerCallback('esx_society:getJob', function(job)
		local list = {}
		for _, g in ipairs(job.grades) do
			list[#list + 1] = { grade = g.grade, label = (g.label ~= '' and g.label) or job.label }
		end
		if #list ~= currentGradeCount then
			ESX.ShowNotification('Tedad rank haye in do job barabar nist, swap emkan pazir nist')
			return cb({})
		end
		cb(list)
	end, data.job)
end)

RegisterNUICallback('getSalaries', function(_, cb)
	ESX.TriggerServerCallback('esx_society:getJob', function(job)
		local list = {}
		for _, g in ipairs(job.grades) do
			list[#list + 1] = { grade = g.grade, label = (g.label ~= '' and g.label) or job.label, salary = g.salary }
		end
		cb(list)
	end, currentSociety)
end)

RegisterNUICallback('setSalary', function(data, cb)
	ESX.TriggerServerCallback('esx_society:setJobSalary', function()
		cb('ok')
	end, currentSociety, data.grade, tonumber(data.salary))
end)

RegisterNUICallback('getRanks', function(_, cb)
	ESX.TriggerServerCallback('esx_society:getJob', function(job)
		local grades = {}
		for _, g in ipairs(job.grades) do
			grades[#grades + 1] = { grade = g.grade, name = g.name, label = (g.label ~= '' and g.label) or job.label, isBoss = g.name == 'boss' }
		end
		local divs = {}
		for _, d in ipairs(job.divisions) do divs[#divs + 1] = { name = d.name } end
		cb({ grades = grades, divisions = divs, maxGrade = #job.grades })
	end, currentSociety)
end)

RegisterNUICallback('getRankPermissions', function(data, cb)
	ESX.TriggerServerCallback('esx_society:getJob', function(job, perms)
		perms = perms or {}
		local gradeId = data.grade
		local isDivision = type(gradeId) == 'string'
		local gradeName
		if not isDivision then
			for _, g in ipairs(job.grades) do
				if g.grade == gradeId then gradeName = g.name break end
			end
		end
		cb({ grade = gradeId, permissions = buildRankPerms(currentSociety, gradeId, isDivision, perms, gradeName) })
	end, currentSociety)
end)

RegisterNUICallback('setRankPerm', function(data, cb)
	local kind = data.kind
	local state = data.state and true or false
	if kind == 'boss' then
		ESX.TriggerServerEvent('esx_society:toggleBoss', tonumber(data.grade), state)
	elseif kind == 'employee' then
		ESX.TriggerServerEvent('esx_society:toggleEmployee', tostring(data.grade), state)
	elseif kind == 'custom' then
		ESX.TriggerServerEvent('esx_society:toggleCustom', tostring(data.grade), state)
	else
		ESX.TriggerServerEvent('esx_society:toggleVar', tostring(data.grade), data.key, state)
	end
	cb('ok')
end)

RegisterNUICallback('addGrade', function(_, cb)
	ESX.TriggerServerEvent('esx_society:newGrade')
	cb('ok')
end)

RegisterNUICallback('deleteGrade', function(data, cb)
	ESX.TriggerServerEvent('esx_society:deleteGrade', tonumber(data.grade))
	cb('ok')
end)

RegisterNUICallback('upgradeGrade', function(data, cb)
	ESX.TriggerServerEvent('esx_society:upgrade', tonumber(data.grade))
	cb('ok')
end)

RegisterNUICallback('downgradeGrade', function(data, cb)
	ESX.TriggerServerEvent('esx_society:downgrade', tonumber(data.grade))
	cb('ok')
end)

RegisterNUICallback('renameGrade', function(data, cb)
	ESX.TriggerServerCallback('esx_society:savename', function()
		cb('ok')
	end, tonumber(data.grade), tostring(data.name))
end)

RegisterNUICallback('getInventoryPerms', function(data, cb)
	local gradeId = data.grade
	local isDivision = data.division and true or false
	local kind = data.kind
	ESX.TriggerServerCallback('esx_society:getJob', function(job)
		local permStr = '{}'
		if isDivision then
			for _, d in ipairs(job.divisions) do
				if d.name == gradeId then
					permStr = (kind == 'weapon' and d.armoryperm or d.inventoryperm) or '{}'
					break
				end
			end
		else
			for _, g in ipairs(job.grades) do
				if g.grade == gradeId then
					permStr = (kind == 'weapon' and g.armoryperm or g.inventoryperm) or '{}'
					break
				end
			end
		end
		local perm = json.decode(permStr) or {}
		if type(perm['1']) == 'table' then
			perm = perm['1']
		end
		ESX.TriggerServerCallback('inventory-job:getInventory', function(inv)
			local list = {}
			local added = {}
			local src = (kind == 'weapon') and (inv and inv.weapons) or (inv and inv.items)
			for _, v in pairs(src or {}) do
				if v.name and not added[v.name] then
					added[v.name] = true
					local label = (kind == 'weapon') and ESX.GetWeaponLabel(v.name) or ESX.getItemLabel(v.name)
					if label then
						list[#list + 1] = { name = v.name, label = label, state = perm[string.lower(v.name)] and true or false }
					end
				end
			end
			cb({ grade = gradeId, division = isDivision, kind = kind, list = list })
		end, currentSociety)
	end, currentSociety)
end)

RegisterNUICallback('setInventoryPerm', function(data, cb)
	local event = (data.kind == 'weapon') and 'esx_society:setgunstate' or 'esx_society:setitemstate'
	TriggerServerEvent(event, data.name, data.grade, data.state and true or false, data.division or nil)
	cb('ok')
end)

local function hasLockerPerm(perm, name)
	return (perm[name] or perm[string.lower(name)]) and true or false
end

local function lockerLimit(limitMap, name)
	if not limitMap then return nil end
	return limitMap[name] or 0
end

local function buildLockerList(perm, limitMap, cb)
	ESX.TriggerServerCallback('inventory-job:getInventory', function(inv)
		local list = {}
		local temp = {}
		list[#list + 1] = { label = '⭐ دسترسی به تمام سلاح‌ها ⭐', key = 'allweapon', state = hasLockerPerm(perm, 'allweapon'), weapon = true, clothe = false }
		list[#list + 1] = { label = '⭐ دسترسی به تمام اقلام ⭐', key = 'allitem', state = hasLockerPerm(perm, 'allitem'), weapon = false, clothe = false }
		for _, v in ipairs((inv and inv.weapons) or {}) do
			if v.name and not temp[v.name] then
				temp[v.name] = true
				list[#list + 1] = { label = ESX.GetWeaponLabel(v.name) or v.name, key = v.name, state = hasLockerPerm(perm, v.name), weapon = true, clothe = false, limit = lockerLimit(limitMap, v.name) }
			end
		end
		for _, v in ipairs((inv and inv.items) or {}) do
			if v.name and not temp[v.name] and not exports['sunset_clothe']:getClotheData(v.name) then
				temp[v.name] = true
				list[#list + 1] = { label = (ESX.getItem(v.name) and ESX.getItem(v.name).label) or v.name, key = v.name, state = hasLockerPerm(perm, v.name), weapon = false, clothe = false, limit = lockerLimit(limitMap, v.name) }
			end
		end
		for _, v in ipairs((inv and inv.items) or {}) do
			if v.name and not temp[v.name] and exports['sunset_clothe']:getClotheData(v.name) then
				temp[v.name] = true
				list[#list + 1] = { label = (ESX.getItem(v.name) and ESX.getItem(v.name).label) or v.name, key = v.name, state = hasLockerPerm(perm, v.name), weapon = false, clothe = true, limit = lockerLimit(limitMap, v.name) }
			end
		end
		cb({ permissions = list })
	end, currentSociety)
end

RegisterNUICallback('getLockerPermissions', function(data, cb)
	local rankId = data.rankId
	local division = data.division and true or false
	ESX.TriggerServerCallback('esx_society:getJobLockerAccess', function(perm)
		if division then
			buildLockerList(perm, nil, cb)
		else
			ESX.TriggerServerCallback('inventory-job:getLockerLimit', function(limitMap)
				buildLockerList(perm, limitMap or {}, cb)
			end, rankId)
		end
	end, rankId, division)
end)

RegisterNUICallback('setLockerPermissions', function(data, cb)
	local rankId = data.rankId
	local division = data.division and true or false
	local armoryMap, invMap, limitMap = {}, {}, {}
	local allWeaponOn, allItemOn = false, false
	for _, v in ipairs(data.permissions or {}) do
		if v.key == 'allweapon' then
			allWeaponOn = v.state and true or false
		elseif v.key == 'allitem' then
			allItemOn = v.state and true or false
		end
	end
	for _, v in ipairs(data.permissions or {}) do
		local state = v.state and true or false
		local star = v.key == 'allweapon' or v.key == 'allitem'
		local covered = not star and ((v.weapon and allWeaponOn) or (not v.weapon and allItemOn))
		if not covered then
			if v.weapon then
				armoryMap[v.key] = state
			else
				invMap[v.key] = state
			end
		end
		if not division then
			local lim = tonumber(v.limit)
			if lim and lim > 0 and (state or covered) then
				limitMap[v.key] = lim
			end
		end
	end
	ESX.TriggerServerEvent('esx_society:setJobLockerAccess', rankId, division, armoryMap, invMap)
	if not division then
		ESX.TriggerServerEvent('inventory-job:setLockerLimit', rankId, limitMap)
	end
	cb('ok')
end)

RegisterNUICallback('setDivisionIcon', function(data, cb)
	local icon = tostring(data.icon or '')
	if icon:find('http') then
		TriggerServerEvent('society:setDivisionIcon', tostring(data.name), icon)
	end
	cb('ok')
end)

RegisterNUICallback('getVehiclePerms', function(data, cb)
	local gradeId = data.grade
	ESX.TriggerServerCallback('esx_society:getJobvehicle', function(vehicles)
		local list = {}
		for _, v in ipairs(vehicles or {}) do
			local perm = json.decode(v.perm) or {}
			list[#list + 1] = { label = v.label, state = perm[tostring(gradeId)] == 'true' }
		end
		cb({ grade = gradeId, vehicles = list })
	end)
end)

RegisterNUICallback('setVehiclePerm', function(data, cb)
	TriggerServerEvent('esx_society:setvehstate', data.label, data.grade, data.state and true or false)
	cb('ok')
end)

RegisterNUICallback('getLogs', function(_, cb)
	local logs = buildLogList(currentSociety)
	ESX.TriggerServerCallback('esx_society:getJob', function(job)
		local grades = {}
		for _, g in ipairs(job.grades) do
			grades[#grades + 1] = { grade = g.grade, label = (g.label ~= '' and g.label) or job.label }
		end
		cb({ logs = logs, grades = grades })
	end, currentSociety)
end)

RegisterNUICallback('getLogAccess', function(data, cb)
	ESX.TriggerServerCallback('job:getLogPermission', function(accessList)
		cb({ index = data.index, access = accessList or {} })
	end, data.index)
end)

RegisterNUICallback('setLogAccess', function(data, cb)
	TriggerServerEvent('job:updateLogPermission', data.index, data.access or {})
	cb('ok')
end)

RegisterNUICallback('getRankLogs', function(data, cb)
	local rankId = tostring(data.rankId)
	ESX.TriggerServerCallback('job:getAllLogPermission', function(access)
		access = access or {}
		local logs = buildLogList(currentSociety)
		for _, l in ipairs(logs) do
			l.state = access[l.index] and access[l.index][rankId] and true or false
		end
		cb({ logs = logs })
	end)
end)

RegisterNUICallback('setRankLog', function(data, cb)
	ESX.TriggerServerCallback('job:getLogPermission', function(accessList)
		accessList = accessList or {}
		if data.state then
			accessList[tostring(data.rankId)] = true
		else
			accessList[tostring(data.rankId)] = nil
		end
		TriggerServerEvent('job:updateLogPermission', data.index, accessList)
		cb('ok')
	end, data.index)
end)

RegisterNUICallback('getDivisions', function(_, cb)
	ESX.TriggerServerCallback('esx_society:getJob', function(job)
		local list = {}
		for _, d in ipairs(job.divisions) do list[#list + 1] = { name = d.name } end
		cb(list)
	end, currentSociety)
end)

RegisterNUICallback('addDivision', function(data, cb)
	TriggerServerEvent('esx_society:adddivision', ESX.Math.Trim(tostring(data.name)))
	cb('ok')
end)

RegisterNUICallback('delDivision', function(data, cb)
	TriggerServerEvent('esx_society:deldivision', tostring(data.name))
	cb('ok')
end)

RegisterNUICallback('toggleMili', function(data, cb)
	ESX.TriggerServerEvent('esx_society:toggle_mili', tonumber(data.type))
	cb('ok')
end)

RegisterNUICallback('toggleDispatch', function(_, cb)
	TriggerServerEvent('esx_society:toggleDispatch')
	cb('ok')
end)

RegisterNUICallback('manageOutfit', function(_, cb)
	cb('ok')
	hideUI()
	OpenManageClotheMenu(currentSociety)
end)
