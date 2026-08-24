ESX = nil
local Jobs = {}
local Divisions = {}
local RegisteredSocieties = {}
local WebHook
local WebHookAdmin

TriggerEvent(Config.ESXtrigger, function(obj) ESX = obj end)

function GetSociety(name)
	for i=1, #RegisteredSocieties, 1 do
		if RegisteredSocieties[i].name == name then
			return RegisteredSocieties[i]
		end
	end
end

MySQL.ready(function()
	local result = MySQL.Sync.fetchAll('SELECT * FROM jobs', {})

	for i=tonumber(1), #result, tonumber(1) do
		Jobs[result[i].name]        = result[i]
		Jobs[result[i].name].grades = {}
	end

	local result2 = MySQL.Sync.fetchAll('SELECT * FROM job_grades', {})

	for i=tonumber(1), #result2, tonumber(1) do
		if Jobs[result2[i].job_name] then
			Jobs[result2[i].job_name].grades[tostring(result2[i].grade)] = result2[i]
		else
			print(('esx_society: skipping job_grades row with unknown job_name "%s"'):format(tostring(result2[i].job_name)))
		end
	end

end)

MySQL.ready(function()
	local result = MySQL.Sync.fetchAll('SELECT * FROM divisions', {})
	for i=tonumber(1), #result, tonumber(1) do
		Divisions[result[i].owner]        = result[i]
		Divisions[result[i].owner].names = {}
	end

	local result2 = MySQL.Sync.fetchAll('SELECT * FROM divisions', {})

	for i=tonumber(1), #result2, tonumber(1) do
		Divisions[result2[i].owner].names[result2[i].name] = result2[i]
	end

end)

function reloaddatabase()

	MySQL.ready(function()
		local result = MySQL.Sync.fetchAll('SELECT * FROM jobs', {})

		for i=tonumber(1), #result, tonumber(1) do
			Jobs[result[i].name]        = result[i]
			Jobs[result[i].name].grades = {}
		end

		local result2 = MySQL.Sync.fetchAll('SELECT * FROM job_grades', {})

		for i=tonumber(1), #result2, tonumber(1) do
			if Jobs[result2[i].job_name] then
				Jobs[result2[i].job_name].grades[tostring(result2[i].grade)] = result2[i]
			else
				print(('esx_society: skipping job_grades row with unknown job_name "%s"'):format(tostring(result2[i].job_name)))
			end
		end

	end)

	MySQL.ready(function()
		local result = MySQL.Sync.fetchAll('SELECT * FROM divisions', {})
		for i=tonumber(1), #result, tonumber(1) do
			Divisions[result[i].owner]        = result[i]
			Divisions[result[i].owner].names = {}
		end

		local result2 = MySQL.Sync.fetchAll('SELECT * FROM divisions', {})

		for i=tonumber(1), #result2, tonumber(1) do
			Divisions[result2[i].owner].names[result2[i].name] = result2[i]
		end

	end)

end

AddEventHandler('esx_society:registerSociety', function(name, label, account, datastore, inventory, data)
	local found = false

	local society = {
		name      = name,
		label     = label,
		account   = account,
		datastore = datastore,
		inventory = inventory,
		data      = data,
	}

	for i=1, #RegisteredSocieties, 1 do
		if RegisteredSocieties[i].name == name then
			found = true
			RegisteredSocieties[i] = society
			break
		end
	end

	if not found then
		table.insert(RegisteredSocieties, society)
	end
end)

AddEventHandler('esx_society:getSocieties', function(cb)
	cb(RegisteredSocieties)
end)

AddEventHandler('esx_society:getSociety', function(name, cb)
	cb(GetSociety(name))
end)

RegisterServerEvent('esx_society:withdrawMoney')
AddEventHandler('esx_society:withdrawMoney', function(society, amount)
	local xPlayer = ESX.GetPlayerFromId(source)
	local society = GetSociety(society)
	amount = ESX.Math.Round(tonumber(amount))

	if xPlayer.job.name ~= society.name or xPlayer.job.grade_name ~= 'boss' then
		print(('esx_society: %s attempted to call withdrawMoney without being boss!'):format(xPlayer.identifier))
		return
	end

	TriggerEvent('esx_addonaccount:getSharedAccount', society.account, function(account)
		if tonumber(amount) > tonumber(0) and tonumber(account.money) >= tonumber(amount) then
			account.removeMoney(tonumber(amount))
			xPlayer.addMoney(tonumber(amount))
			local Newmoney = account.money - amount


			messagess = {
				{["name"] = "👤 **Player Name**", ["value"] = xPlayer.name, ["inline"] = false},
				{["name"] = "🎮 **Steam Hex**", ["value"] = xPlayer.identifier, ["inline"] = false},
				{["name"] = "🌍 **Server ID**", ["value"] = xPlayer.source, ["inline"] = false},
				{["name"] = "💰 **Money**", ["value"] = "Old Money : **"..Newmoney+amount.." $**\nNew Money : **"..Newmoney.." $**", ["inline"] = false},
				{["name"] = "🔢 **Meghdar**", ["value"] = "**"..amount.." $**", ["inline"] = false},
			}

			JobsLog('Withdraw Money', false, society.name, 'money', messagess)

			TriggerClientEvent('esx:showNotification', xPlayer.source, _U('have_withdrawn', ESX.Math.GroupDigits(amount)))
		else
			TriggerClientEvent('esx:showNotification', xPlayer.source, _U('invalid_amount'))
		end
	end)
end)

RegisterServerEvent('esx_society:depositMoney')
AddEventHandler('esx_society:depositMoney', function(society, amount)
	local xPlayer = ESX.GetPlayerFromId(source)
	local society = GetSociety(society)
	amount = ESX.Math.Round(tonumber(amount))

	if xPlayer.job.name ~= society.name then
		print(('esx_society: %s attempted to call depositMoney!'):format(xPlayer.identifier))
		return
	end

	if amount > 0 and xPlayer.money >= amount then
		TriggerEvent('esx_addonaccount:getSharedAccount', society.account, function(account)
			xPlayer.removeMoney(tonumber(amount))
			account.addMoney(tonumber(amount))
			Wait(500)
			local Newmoney = account.money +amount

			messagess = {
				{["name"] = "👤 **Player Name**", ["value"] = xPlayer.name, ["inline"] = false},
				{["name"] = "🎮 **Steam Hex**", ["value"] = xPlayer.identifier, ["inline"] = false},
				{["name"] = "🌍 **Server ID**", ["value"] = xPlayer.source, ["inline"] = false},
				{["name"] = "💰 **Money**", ["value"] = "Old Money : **"..Newmoney-amount.." $**\nNew Money : **"..Newmoney.." $**", ["inline"] = false},
				{["name"] = "🔢 **Meghdar**", ["value"] = "**"..amount.." $**", ["inline"] = false},
			}

			JobsLog('Deposit Money', true, society.name, 'money', messagess)
		end)

		TriggerClientEvent('esx:showNotification', xPlayer.source, _U('have_deposited', ESX.Math.GroupDigits(amount)))
	else
		TriggerClientEvent('esx:showNotification', xPlayer.source, _U('invalid_amount'))
	end
end)

RegisterServerEvent('esx_society:depositMoney2')
AddEventHandler('esx_society:depositMoney2', function(xPlayer2, society, account, amount)



	if tonumber(xPlayer2) ~= tonumber(source) then
		print(('esx_society: %s attempted to call depositMoney2 for another player (%s)!'):format(source, tostring(xPlayer2)))
		return
	end

	local xPlayer = ESX.GetPlayerFromId(xPlayer2)
	local society = GetSociety(society)
	amount = ESX.Math.Round(tonumber(amount))

	if xPlayer and amount > 0 and xPlayer.money >= amount then
		TriggerEvent('esx_addonaccount:getSharedAccount', account, function(account)
			xPlayer.removeMoney(tonumber(amount))
			account.addMoney(tonumber(amount))

			JobsLog('Deposit Money', true, xPlayer.job.name, 'money', {
				{["name"] = "👤 Player", ["value"] = xPlayer.name, ["inline"] = false},
				{["name"] = "🎮 Steam Hex", ["value"] = xPlayer.identifier, ["inline"] = false},
				{["name"] = "💵 Amount", ["value"] = '$' .. amount, ["inline"] = false},
				{["name"] = "🏦 Account", ["value"] = account.name or tostring(account), ["inline"] = false},
			})
		end)
	end
end)

ESX.RegisterServerCallback('esx_society:getSocietyMoney', function(source, cb, societyName)
	local society = GetSociety(societyName)

	if society then
		TriggerEvent('esx_addonaccount:getSharedAccount', society.account, function(account)
			cb(account.money)
		end)
	else
		cb(tonumber(0))
	end
end)

ESX.RegisterServerCallback('esx_society:getEmployees', function(source, cb, society)
	if Config.EnableESXIdentity then

		MySQL.Async.fetchAll('SELECT playerName, identifier, job, job_grade, Profile_Pic FROM users WHERE job = @job ORDER BY job_grade DESC', {
			['@job'] = society
		}, function (results)
			local employees = {}

			for i=1, #results, 1 do
				if results[i].job_grade < tonumber(0) then
					results[i].job_grade = results[i].job_grade * tonumber(-1)
				end
				table.insert(employees, {
					name       = string.gsub(results[i].playerName, "_", " " ) or 'N/A',
					identifier = results[i].identifier,
					photo      = (results[i].Profile_Pic ~= nil and results[i].Profile_Pic ~= '') and results[i].Profile_Pic or Config.DefaultProfilePic,
					job = {
						name        = results[i].job,
						label       = Jobs[results[i].job].label,
						grade       = results[i].job_grade,
						grade_name  = Jobs[results[i].job].grades[tostring(results[i].job_grade)].name or 'N/A',
						grade_label = Jobs[results[i].job].grades[tostring(results[i].job_grade)].label
					}
				})
			end

			cb(employees)
		end)
	else
		MySQL.Async.fetchAll('SELECT name, identifier, job, job_grade, Profile_Pic FROM users WHERE job = @job ORDER BY job_grade DESC', {
			['@job'] = society
		}, function (result)
			local employees = {}

			for i=tonumber(1), #result, tonumber(1) do
				table.insert(employees, {
					name       = result[i].name,
					identifier = result[i].identifier,
					photo      = (result[i].Profile_Pic ~= nil and result[i].Profile_Pic ~= '') and result[i].Profile_Pic or Config.DefaultProfilePic,
					job = {
						name        = result[i].job,
						label       = Jobs[result[i].job].label,
						grade       = result[i].job_grade,
						grade_name  = Jobs[result[i].job].grades[tostring(result[i].job_grade)].name,
						grade_label = Jobs[result[i].job].grades[tostring(result[i].job_grade)].label
					}
				})
			end

			cb(employees)
		end)
	end
end)

ESX.RegisterServerCallback('esx_society:getdivision', function(source, cb, society)

	local divisionname = {}
	exports.oxmysql:execute("SELECT * FROM divisions WHERE owner = ?",{
		society

	}, function(division)

		cb(division)

	end)
end)

ESX.RegisterServerCallback('esx_society:GetDivisionsPlayer',function(source, cb, identifier)
	local xPlayer = ESX.GetPlayerFromId(source)


    local result = MySQL.Sync.fetchAll('SELECT divisions FROM users WHERE identifier = @identifier', {['@identifier'] = identifier})

    if result[1] and result[1].divisions then
        local divisions = json.decode(result[1].divisions)
      cb(divisions)
    end
end)

ESX.RegisterServerCallback('esx_society:divisionsPlayer',function(source, cb)
	local xPlayer = ESX.GetPlayerFromId(source)
	::refresh::
	if xPlayer then
		local identifier = xPlayer.identifier

		local result = MySQL.Sync.fetchAll('SELECT divisions FROM users WHERE identifier = @identifier', {['@identifier'] = identifier})

		if result[1] and result[1].divisions then
			local divisions = json.decode(result[1].divisions)
		cb(divisions)
		end
	else
		Citizen.Wait(5000)
		goto refresh

	end
end)


ESX.RegisterServerCallback('esx_society:swichdivision', function(source, cb, name)
    local xPlayer = ESX.GetPlayerFromId(source)
    local identifier = xPlayer.identifier

	local result = MySQL.Sync.fetchAll("SELECT divisions FROM users WHERE identifier = @identifier", {
		['@identifier'] = identifier
	})

	local divisions = {}
	if result[1] and result[1].divisions then
		divisions = json.decode(result[1].divisions)
	end

	local function findDivisionByName(divisions, name)
		for _, div in ipairs(divisions) do
			if div.name == name then
				return div
			end
		end
		return nil
	end

	local division = findDivisionByName(divisions, name)

	if division then

		if division.status == true then
			division.status = false
		else

			for _, div in ipairs(divisions) do
				if div.name == name then
					div.status = true
				else
					div.status = false
				end
			end
		end
	else

		table.insert(divisions, {
			label = name,
			status = true,
			job = xPlayer.job.name,
			name = name
		})
	end

	local updatedData = json.encode(divisions)
	MySQL.Sync.execute("UPDATE users SET divisions = @divisions WHERE identifier = @identifier", {
		['@divisions'] = updatedData,
		['@identifier'] = identifier
	})

	cb(true)

end)

ESX.RegisterServerCallback('esx_society:setJobDivision', function(source, cb, identifier, job, Divisvorodi, type)
	local xPlayer  = ESX.GetPlayerFromId(source)

	if not isPlayerBoss(source, job) then
		print(('esx_society: %s attempted to setJobDivision'):format(xPlayer.identifier))
		cb(false)
		return
	end

	local xTarget  = ESX.GetPlayerFromIdentifier(identifier)
	local IsOnline = "Offline"

	local resualtss = MySQL.Sync.fetchAll("SELECT playerName FROM users WHERE identifier = @identifier", {
		['@identifier'] = identifier
	})
	local pName = resualtss[1].playerName

	if type == 'hire' then


		local result = MySQL.Sync.fetchAll("SELECT divisions FROM users WHERE identifier = @identifier", {
			['@identifier'] = identifier
		})

		local divisions = {}
		if result[1] and result[1].divisions then
			divisions = json.decode(result[1].divisions)
		end


		local function isDivisvorodiExists(divisions, Divisvorodi)
			for _, existingDivisvorodi in ipairs(divisions) do
				if existingDivisvorodi.name == Divisvorodi.name and existingDivisvorodi.job == Divisvorodi.job then
					return true
				end
			end
			return false
		end


		if not isDivisvorodiExists(divisions, Divisvorodi) then
			table.insert(divisions, Divisvorodi)
			if xTarget then
				TriggerClientEvent('esx:showNotification', xTarget.source, 'Shoma Division ( ~g~'.. Divisvorodi.name.."~w~ ) Ra Daryaft Kardid")
				IsOnline = xTarget.source
			end
		end

		local updatedData = json.encode(divisions)

		MySQL.Sync.fetchAll("UPDATE users SET divisions = @divisions WHERE identifier = @identifier", {
			['@divisions'] = updatedData,
			['@identifier'] = identifier
		})



		messagess = {
			{["name"] = "👤 **Player Name**", ["value"] = xPlayer.name, ["inline"] = false},
			{["name"] = "🎮 **Steam Hex**", ["value"] = xPlayer.identifier, ["inline"] = false},
			{["name"] = "🌍 **Server ID**", ["value"] = xPlayer.source, ["inline"] = false},
			{["name"] = "👤 **Target Name**", ["value"] = pName, ["inline"] = false},
			{["name"] = "🎮 **Target Hex**", ["value"] = identifier, ["inline"] = false},
			{["name"] = "🌍 **Target ID**", ["value"] = IsOnline, ["inline"] = false},
			{["name"] = "⚙️ **Division Name**", ["value"] = Divisvorodi.name, ["inline"] = false},
		}

		JobsLog('Add Player Division ', true, xPlayer.job.name, 'divisionemploee', messagess)


	elseif type == 'fire' then
		local result = MySQL.Sync.fetchAll("SELECT divisions FROM users WHERE identifier = @identifier", {
			['@identifier'] = identifier
		})

		local divisions = {}
		if result[1] and result[1].divisions then
			divisions = json.decode(result[1].divisions)
		end


		local function removeDivisvorodi(divisions, Divisvorodi)
			for i = #divisions, 1, -1 do
				if divisions[i].name == Divisvorodi.name and divisions[i].job == Divisvorodi.job then
					table.remove(divisions, i)
					return true
				end
			end
			return false
		end


		local isRemoved = removeDivisvorodi(divisions, Divisvorodi)

		if isRemoved then
			if xTarget then
				TriggerClientEvent('esx:showNotification', xTarget.source, 'division Shoma ( ~r~'.. Divisvorodi.name.."~w~ ) Hazf Shod")
				IsOnline = xTarget.source
			end


			local updatedData = json.encode(divisions)
			MySQL.Sync.execute("UPDATE users SET divisions = @divisions WHERE identifier = @identifier", {
				['@divisions'] = updatedData,
				['@identifier'] = identifier
			})
		end

		messagess = {
			{["name"] = "👤 **Player Name**", ["value"] = xPlayer.name, ["inline"] = false},
			{["name"] = "🎮 **Steam Hex**", ["value"] = xPlayer.identifier, ["inline"] = false},
			{["name"] = "🌍 **Server ID**", ["value"] = xPlayer.source, ["inline"] = false},
			{["name"] = "👤 **Target Name**", ["value"] = pName, ["inline"] = false},
			{["name"] = "🎮 **Target Hex**", ["value"] = identifier, ["inline"] = false},
			{["name"] = "🌍 **Target ID**", ["value"] = IsOnline, ["inline"] = false},
			{["name"] = "⚙️ **Division Name**", ["value"] = Divisvorodi.name, ["inline"] = false},
		}

		JobsLog('Remove Player Division ', false, xPlayer.job.name, 'divisionemploee', messagess)

	end
end)

ESX.RegisterServerCallback('esx_society:getEmployeesDivision', function(source, cb, society)

	MySQL.Async.fetchAll('SELECT playerName, identifier, job, job_grade FROM users WHERE job = @job ORDER BY job_grade DESC', {
		['@job'] = society
	}, function (results)
		local employees = {}

		for i=1, #results, 1 do
			if results[i].job_grade < tonumber(0) then
				results[i].job_grade = results[i].job_grade * tonumber(-1)
			end
			table.insert(employees, {
				name       = string.gsub(results[i].playerName, "_", " " ),
				identifier = results[i].identifier,
				job = {
					name        = results[i].job,
					label       = Jobs[results[i].job].label,
					grade       = results[i].job_grade,
					grade_name  = Jobs[results[i].job].grades[tostring(results[i].job_grade)].name,
					grade_label = Jobs[results[i].job].grades[tostring(results[i].job_grade)].label
				}
			})
		end

		cb(employees)
	end)
end)

ESX.RegisterServerCallback('esx_society:getJob', function(source, cb, society)
	local job    = json.decode(json.encode(Jobs[society]))
	local grades = {}

	for k,v in pairs(job.grades) do
		table.insert(grades, v)
	end

	table.sort(grades, function(a, b)
		return a.grade < b.grade
	end)

	job.grades = grades

	cb(job)
end)

ESX.RegisterServerCallback('esx_society:setJob', function(source, cb, identifier, job, grade, type)
	MySQL.Async.fetchAll('SELECT * FROM users WHERE identifier = @identifier', {
		['@identifier'] = identifier
	}, function(rowsChanged2)
		local xTarget = ESX.GetPlayerFromIdentifier(identifier)
		local xPlayer = ESX.GetPlayerFromId(source)
		local grren = true
		local titele = ""
		local messagess = {}

		if xTarget then



			local isAuthorized = false
			if type == 'hire' then
				isAuthorized = isPlayerBoss(source, job)
			elseif type == 'promote' or type == 'fire' then
				isAuthorized = isPlayerBoss(source, xTarget.job.name)
			end

			if not isAuthorized then
				print(('esx_society: %s attempted to setJob (%s) without being boss'):format(xPlayer.identifier, type or 'unknown'))
				cb()
				return
			end

			LastGrade = xTarget.job.grade
			if grade < LastGrade then
				grren  = false
				titele = "Rank Down"
			elseif grade > LastGrade then
				grren  = true
				titele = "Rank Up"
			else
				grren  = false
				titele = "nul"
			end

			if type == 'hire' then
				TriggerClientEvent('esx:showNotification', xTarget.source, _U('you_have_been_hired', job))
				xTarget.setJob(job, grade)
				grren  = true
				titele = "Set Job"

				messagess = {
					{["name"] = "👤 **Player Name**", ["value"] = xTarget.name, ["inline"] = false},
					{["name"] = "🎮 **Steam Hex**", ["value"] = identifier, ["inline"] = false},
					{["name"] = "🌍 **Server ID**", ["value"] = xTarget.source, ["inline"] = false},
					{["name"] = "** Tavasote **", ["value"] = '', ["inline"] = true},
					{["name"] = "👤 **Target Name**", ["value"] = xPlayer.name, ["inline"] = false},
					{["name"] = "🎮 **Steam Hex**", ["value"] = xPlayer.identifier, ["inline"] = false},
					{["name"] = "🌍 **Server ID**", ["value"] = xPlayer.source, ["inline"] = false},
					{["name"] = "🔢 **Data**", ["value"] = 'Set Job Shod', ["inline"] = false},
				}

			elseif type == 'promote' then

				xTarget.setJob(job, grade)
				TriggerClientEvent('esx:showNotification', xTarget.source, _U('you_have_been_promoted'))

				messagess = {
					{["name"] = "👤 **Player Name**", ["value"] = xTarget.name, ["inline"] = false},
					{["name"] = "🎮 **Steam Hex**", ["value"] = identifier, ["inline"] = false},
					{["name"] = "🌍 **Server ID**", ["value"] = xTarget.source, ["inline"] = false},
					{["name"] = "** Tavasote **", ["value"] = '', ["inline"] = true},
					{["name"] = "👤 **Target Name**", ["value"] = xPlayer.name, ["inline"] = false},
					{["name"] = "🎮 **Steam Hex**", ["value"] = xPlayer.identifier, ["inline"] = false},
					{["name"] = "🌍 **Server ID**", ["value"] = xPlayer.source, ["inline"] = false},
					{["name"] = "🔢 **Data**", ["value"] = 'Az Rank '..LastGrade..' Be Rank '..grade.." Tagir dad", ["inline"] = false},
				}

			elseif type == 'fire' then
				xTarget.setJob(job, grade)
				titele = 'Fire'
				grren  = false
				MySQL.Sync.execute("UPDATE users SET divisions = @divisions WHERE identifier = @identifier", {
					['@divisions'] = '[]',
					['@identifier'] = identifier
				})
				TriggerClientEvent('esx:showNotification', xTarget.source, _U('you_have_been_fired', xTarget.job.label))

				grren  = false
				titele = "Fire"

				messagess = {
					{["name"] = "👤 **Player Name**", ["value"] = rowsChanged2[1].name, ["inline"] = false},
					{["name"] = "🎮 **Steam Hex**", ["value"] = identifier, ["inline"] = false},
					{["name"] = "🌍 **Server ID**", ["value"] = xTarget.source, ["inline"] = false},
					{["name"] = "** Tavasote **", ["value"] = '', ["inline"] = true},
					{["name"] = "👤 **Target Name**", ["value"] = xPlayer.name, ["inline"] = false},
					{["name"] = "🎮 **Steam Hex**", ["value"] = xPlayer.identifier, ["inline"] = false},
					{["name"] = "🌍 **Server ID**", ["value"] = xPlayer.source, ["inline"] = false},
					{["name"] = "🔢 **Data**", ["value"] = "Fier Shod", ["inline"] = false},

				}

			end
		else
			MySQL.Async.execute('UPDATE users SET job = @job, job_grade = @job_grade WHERE identifier = @identifier', {
				['@job']        = job,
				['@job_grade']  = grade,
				['@identifier'] = identifier
			}, function(rowsChanged)

			end)

			LastGrade = rowsChanged2[1].job_grade
			if grade < LastGrade then
				grren  = false
				titele = "Rank Down"
			elseif grade > LastGrade then
				grren  = true
				titele = "Rank Up"
			else
				grren  = false
				titele = "Null"
			end

			messagess = {
				{["name"] = "👤 **Player Name**", ["value"] = rowsChanged2[1].name, ["inline"] = false},
				{["name"] = "🎮 **Steam Hex**", ["value"] = identifier, ["inline"] = false},
				{["name"] = "🌍 **Server ID**", ["value"] = "OffLine", ["inline"] = false},
				{["name"] = "** Tavasote **", ["value"] = '', ["inline"] = true},
				{["name"] = "👤 **Target Name**", ["value"] = xPlayer.name, ["inline"] = false},
				{["name"] = "🎮 **Steam Hex**", ["value"] = xPlayer.identifier, ["inline"] = false},
				{["name"] = "🌍 **Server ID**", ["value"] = xPlayer.source, ["inline"] = false},
				{["name"] = "🔢 **Data**", ["value"] = 'Az Rank '..LastGrade..' Be Rank '..grade.." Tagir dad", ["inline"] = false},

			}

			if type == 'fire' then

				MySQL.Sync.execute("UPDATE users SET divisions = @divisions WHERE identifier = @identifier", {
					['@divisions'] = '[]',
					['@identifier'] = identifier
				})


				grren  = false
				titele = "Fire"

				messagess = {
					{["name"] = "👤 **Player Name**", ["value"] = rowsChanged2[1].name, ["inline"] = false},
					{["name"] = "🎮 **Steam Hex**", ["value"] = identifier, ["inline"] = false},
					{["name"] = "🌍 **Server ID**", ["value"] = "OffLine", ["inline"] = false},
					{["name"] = "** Tavasote **", ["value"] = '', ["inline"] = true},
					{["name"] = "👤 **Target Name**", ["value"] = xPlayer.name, ["inline"] = false},
					{["name"] = "🎮 **Steam Hex**", ["value"] = xPlayer.identifier, ["inline"] = false},
					{["name"] = "🌍 **Server ID**", ["value"] = xPlayer.source, ["inline"] = false},
					{["name"] = "🔢 **Data**", ["value"] = "Fier Shod", ["inline"] = false},

				}

			end
		end

		SetTimeout(500, function()
		JobsLog(titele, grren, xPlayer.job.name, 'manage', messagess)
		cb()
		end)
	end)
end)

RegisterServerEvent('esx_society:logAction')
AddEventHandler('esx_society:logAction', function(job, title, fields)
	JobsLog(title, true, job, 'option', fields)
end)

RegisterServerEvent('esx_society:changeBranchJob')
AddEventHandler('esx_society:changeBranchJob', function(newJob)
	local src = source
	local xPlayer = ESX.GetPlayerFromId(src)
	if not xPlayer then return end

	local currentJob = xPlayer.job.name
	local currentGrade = xPlayer.job.grade

	if currentGrade < (Config.ChangeBranchJobBossFloor or 10) then
		print(('esx_society: %s (%s) tried changeBranchJob without boss grade'):format(xPlayer.identifier, currentJob))
		return
	end

	local sameGroup = false
	for i = 1, #Config.JobGroups do
		local grp = Config.JobGroups[i]
		local hasCurrent, hasNew = false, false
		for j = 1, #grp.jobs do
			if grp.jobs[j] == currentJob then hasCurrent = true end
			if grp.jobs[j] == newJob then hasNew = true end
		end
		if hasCurrent and hasNew then
			sameGroup = true
			break
		end
	end

	if not sameGroup then
		print(('esx_society: %s tried changeBranchJob outside their branch (%s -> %s)'):format(xPlayer.identifier, currentJob, newJob))
		TriggerClientEvent('esx:showNotification', src, 'That job is not in your branch.')
		return
	end

	local floor = Config.ChangeBranchJobBossFloor or 10
	local memory = MySQL.Sync.fetchAll('SELECT * FROM branch_job_memory WHERE identifier = @identifier', {
		['@identifier'] = xPlayer.identifier
	})

	local finalGrade

	if memory[1] and memory[1].original_job == newJob then

		finalGrade = memory[1].original_grade
		MySQL.Sync.execute('DELETE FROM branch_job_memory WHERE identifier = @identifier', {
			['@identifier'] = xPlayer.identifier
		})
	else

		if not memory[1] then
			MySQL.Sync.execute('INSERT INTO branch_job_memory (identifier, original_job, original_grade) VALUES (@identifier, @job, @grade)', {
				['@identifier'] = xPlayer.identifier,
				['@job'] = currentJob,
				['@grade'] = currentGrade
			})
		end




		local maxCurrent = Config.JobMaxGrade[currentJob] or 21
		local maxNew = Config.JobMaxGrade[newJob] or 21
		local distanceFromTop = maxCurrent - currentGrade
		finalGrade = maxNew - distanceFromTop

		if finalGrade < floor then finalGrade = floor end
		if finalGrade > maxNew then finalGrade = maxNew end
	end

	xPlayer.setJob(newJob, finalGrade)
	TriggerClientEvent('esx:showNotification', src, 'Your job has been changed to: ' .. newJob)

	JobsLog('Change Branch Job', true, newJob, 'manage', {
		{["name"] = "👤 Player", ["value"] = xPlayer.name, ["inline"] = false},
		{["name"] = "🎮 Steam Hex", ["value"] = xPlayer.identifier, ["inline"] = false},
		{["name"] = "🔁 From -> To", ["value"] = currentJob .. ' (grade ' .. currentGrade .. ') -> ' .. newJob .. ' (grade ' .. finalGrade .. ')', ["inline"] = false},
	})
end)

ESX.RegisterServerCallback('esx_society:swapEmployeeJob', function(source, cb, identifier, fromJob, toJob)
	local xPlayer = ESX.GetPlayerFromId(source)
	if not xPlayer then cb(false) return end

	if not isPlayerBoss(source, fromJob) then
		print(('esx_society: %s attempted swapEmployeeJob without being boss of %s'):format(xPlayer.identifier, fromJob))
		cb(false)
		return
	end

	local xTarget = ESX.GetPlayerFromIdentifier(identifier)
	if not xTarget then
		cb(false)
		return
	end

	if xTarget.job.name ~= fromJob then
		print(('esx_society: %s attempted swapEmployeeJob on a target not in %s'):format(xPlayer.identifier, fromJob))
		cb(false)
		return
	end

	local sameGroup = false
	for i = 1, #Config.JobGroups do
		local grp = Config.JobGroups[i]
		local hasFrom, hasTo = false, false
		for j = 1, #grp.jobs do
			if grp.jobs[j] == fromJob then hasFrom = true end
			if grp.jobs[j] == toJob then hasTo = true end
		end
		if hasFrom and hasTo then
			sameGroup = true
			break
		end
	end

	if not sameGroup then
		print(('esx_society: %s attempted swapEmployeeJob outside the branch (%s -> %s)'):format(xPlayer.identifier, fromJob, toJob))
		cb(false)
		return
	end

	xTarget.setJob(toJob, 0)
	TriggerClientEvent('esx:showNotification', xTarget.source, 'You have been moved to: ' .. toJob)

	JobsLog('Swap Employee Job', true, toJob, 'manage', {
		{["name"] = "👤 Boss", ["value"] = xPlayer.name, ["inline"] = false},
		{["name"] = "🎮 Boss Steam Hex", ["value"] = xPlayer.identifier, ["inline"] = false},
		{["name"] = "👤 Employee", ["value"] = xTarget.name, ["inline"] = false},
		{["name"] = "🔁 From -> To", ["value"] = fromJob .. ' -> ' .. toJob, ["inline"] = false},
	})

	cb(true)
end)

ESX.RegisterServerCallback('esx_society:setJobSalary', function(source, cb, job, grade, salary)
	local isBoss = isPlayerBoss(source, job)
	local identifier = GetPlayerIdentifier(source, tonumber(0))

	if isBoss then
		if salary <= Config.MaxSalary then
			MySQL.Async.execute('UPDATE job_grades SET salary = @salary WHERE job_name = @job_name AND grade = @grade', {
				['@salary']   = salary,
				['@job_name'] = job,
				['@grade']    = grade
			}, function(rowsChanged)
				Jobs[job].grades[tostring(grade)].salary = salary
				local xPlayers = ESX.GetPlayers()

				for i=tonumber(1), #xPlayers, tonumber(1) do
					local xPlayer = ESX.GetPlayerFromId(xPlayers[i])

					if xPlayer.job.name == job and xPlayer.job.grade == grade then
						xPlayer.setJob(job, grade)
					end
				end

				local editor = ESX.GetPlayerFromId(source)
				if editor then
					JobsLog('Change Salary', true, job, 'manage', {
						{["name"] = "👤 Player", ["value"] = editor.name, ["inline"] = false},
						{["name"] = "🎮 Steam Hex", ["value"] = editor.identifier, ["inline"] = false},
						{["name"] = "📊 Grade", ["value"] = tostring(grade), ["inline"] = false},
						{["name"] = "💵 New Salary", ["value"] = '$' .. salary, ["inline"] = false},
					})
				end

				cb()
			end)
		else
			print(('esx_society: %s attempted to setJobSalary over config limit!'):format(identifier))
			cb()
		end
	else
		print(('esx_society: %s attempted to setJobSalary'):format(identifier))
		cb()
	end
end)

ESX.RegisterServerCallback('esx_society:getOnlinePlayers', function(source, cb)
	local xPlayers = ESX.GetPlayers()
	local players  = {}
	ppcoords = ESX.GetPlayerFromId(source).coords

	for i=tonumber(1), #xPlayers, tonumber(1) do
		local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
		table.insert(players, {
			source     = xPlayer.source,
			identifier = xPlayer.identifier,
			name       = xPlayer.name,
			job        = xPlayer.job,
			coords     = xPlayer.coords,
		})
	end

	cb(players, ppcoords)
end)

ESX.RegisterServerCallback('esx_society:getOnlinePlayersDivision', function(source, cb, society)
	MySQL.Async.fetchAll('SELECT playerName, identifier, job, job_grade FROM users WHERE job = @job ORDER BY job_grade DESC', {
		['@job'] = society
	}, function (results)
		local employees = {}

		for i=1, #results, 1 do
			if results[i].job_grade < tonumber(0) then
				results[i].job_grade = results[i].job_grade * tonumber(-1)
			end
			table.insert(employees, {
				name       = string.gsub(results[i].playerName, "_", " " ),
				identifier = results[i].identifier,
			})
		end

		cb(employees)
	end)


end)

ESX.RegisterServerCallback('esx_society:isBoss', function(source, cb, job)
	cb(isPlayerBoss(source, job))
end)

function isPlayerBoss(playerId, job)
	local xPlayer = ESX.GetPlayerFromId(playerId)

	if xPlayer.job.name == job and xPlayer.job.grade_name == 'boss' then
		return true
	else
		print(('esx_society: %s attempted open a society boss menu!'):format(xPlayer.identifier))
		return false
	end
end

ESX.RegisterServerCallback('esx_society:getGrades', function(source, cb, plate)
	local xPlayer = ESX.GetPlayerFromId(source)
	cb(ESX.GetJob(xPlayer.job.name).grades)

end)

ESX.RegisterServerCallback('esx_society:renameGrade', function(source, cb, grade, name)
	local _source, grade, name = source, grade, name
	local xPlayer = ESX.GetPlayerFromId(_source)

	if xPlayer.job.name == "nojob" then
		cb(false)
		print(('esx_society: %s "Tried to rename job label"!'):format(xPlayer.identifier))
		return
	end


		if ESX.SetJobGrade(xPlayer.job.name, grade, name) then

			local xPlayers = ESX.GetPlayers()

			for i=tonumber(1), #xPlayers, tonumber(1) do
				local Member = ESX.GetPlayerFromId(xPlayers[i])

				if Member.job.name == xPlayer.job.name and Member.job.grade == grade then


					Member.setJob(xPlayer.job.name, grade)

				end

			end

			exports.oxmysql:execute("UPDATE job_grades SET label = @label WHERE job_name = @job_name AND grade = @grade" , {
				['@label'] = name,
				['@job_name'] = 'off'..xPlayer.job.name,
				['@grade'] = grade,
			}, function(division)
			end)

			local result = MySQL.Sync.fetchAll("SELECT label FROM job_grades WHERE grade = @grade AND job_name = @job_name", {
				['@grade'] = grade,
				['@job_name'] = xPlayer.job.name
			})



			messagess = {
				{["name"] = "👤 **Player Name**", ["value"] = xPlayer.name, ["inline"] = false},
				{["name"] = "🎮 **Steam Hex**", ["value"] = xPlayer.identifier, ["inline"] = false},
				{["name"] = "🌍 **Server ID**", ["value"] = xPlayer.source, ["inline"] = false},
				{["name"] = "🔠 **Data**", ["value"] = "Rank ("..result[1].label.." {"..grade.."}) Ra Be ("..name..") Tagir Dad", ["inline"] = false},
			}

			JobsLog('Change Grade Name', true, xPlayer.job.name, 'option', messagess)



			cb(true)
			reloaddatabase()
		else
			cb(false)
			TriggerClientEvent('chatMessage', _source, "[SYSTEM]", {tonumber(255), tonumber(0), tonumber(0)}, " ^0Khatayi dar avaz kardan esm job grade shoma pish amad be developer etelaa dahid!")
		end





end)

ESX.RegisterServerCallback('esx_society:getUniforms', function(source, cb, rank, job)
	local fskin = {}
	local mskin = {}
	if tonumber(rank) ~= 0 and job ~= 'nojob' then
		local rawFemale = Jobs[job].grades[tostring(rank)].skin_female
		local rawMale   = Jobs[job].grades[tostring(rank)].skin_male

		fskin = (rawFemale and rawFemale ~= '') and json.decode(rawFemale) or {}
		mskin = (rawMale and rawMale ~= '') and json.decode(rawMale) or {}

		if type(fskin) ~= 'table' then fskin = {} end
		if type(mskin) ~= 'table' then mskin = {} end

		if next(mskin) == nil or next(fskin) == nil then
			TriggerClientEvent('esx:showNotification', source, 'Please set garades options in ~y~boss action')
		end
		cb(mskin, fskin)
	end
end)

ESX.RegisterServerCallback('esx_society:getWeapons', function(source, cb, rank, job)
	local weapon       = (Jobs[job].grades[tostring(rank)].weapons) or '{}'
	if weapon == nil or weapon == '' then
		TriggerClientEvent('esx:showNotification', source, 'Please set garades options in ~y~boss action')
	end
	cb(json.decode(weapon))
end)

ESX.RegisterServerCallback('esx_society:getWeaponsdivisions', function(source, cb, division, job)
	if division then
		local result = MySQL.Sync.fetchAll("SELECT weapons FROM divisions WHERE owner = @owner And name = @name", {
			['@owner'] = job,
			['@name'] = division
		})

		if result == nil or result == '' then
			TriggerClientEvent('esx:showNotification', source, 'Please set garades options in ~y~boss action')
		end
		weapo = json.decode(result[1].weapons)
		cb(weapo)
	else
		cb(false)
	end

end)

ESX.RegisterServerCallback('esx_society:getDivisionItems', function(source, cb, division, job)
	if division then
		local result = MySQL.Sync.fetchAll("SELECT items FROM divisions WHERE owner = @owner And name = @name", {
			['@owner'] = job,
			['@name'] = division
		})

		if result == nil or result == '' then
			TriggerClientEvent('esx:showNotification', source, 'Please set garades options in ~y~boss action')
		end
		item = json.decode(result[1].items)
		cb(item)
	else
		cb(false)
	end
end)

ESX.RegisterServerCallback('esx_society:setDivisionItemPerm', function(source, cb, job, DIVIName, items, status, choice, ItemLabel)
	local identifier = GetPlayerIdentifier(source, tonumber(0))
	local xPlayer    = ESX.GetPlayerFromId(source)

	if not isPlayerBoss(source, job) then
		print(('esx_society: %s attempted to setDivisionItemPerm'):format(identifier))
		cb()
		return
	end

	local itemtable = {}

	for _, item in ipairs(items) do
		if item.name ~= choice then
			table.insert(itemtable,{
				name = item.name,
				status = item.value
			})
		else
			table.insert(itemtable,{
				name = item.name,
				status = status
			})
		end
	end

	MySQL.Async.execute('UPDATE divisions SET items = @items WHERE owner = @owner AND name = @name', {
		['@items']   = json.encode(itemtable),
		['@owner']   = job,
		['@name']    = DIVIName
	}, function(rowsChanged)

		local green = false

		if status == true then
			IsNull = {
				Chekdad = "Dad",
				ChekAZ  = "Be"
			}
			green = true
		else
			IsNull = {
				Chekdad = "Gereft",
				ChekAZ  = "Az"
			}
			green = false
		end

		messagess = {
			{["name"] = "👤 **Player Name**", ["value"] = xPlayer.name, ["inline"] = false},
			{["name"] = "🎮 **Steam Hex**", ["value"] = xPlayer.identifier, ["inline"] = false},
			{["name"] = "🌍 **Server ID**", ["value"] = xPlayer.source, ["inline"] = false},
			{["name"] = "📦 **Item Name**", ["value"] = ItemLabel, ["inline"] = false},
			{["name"] = "🔠 **Data**", ["value"] = IsNull.ChekAZ.." Division ("..DIVIName..") "..IsNull.Chekdad, ["inline"] = false},
		}


		JobsLog('Change Item Perm ', green, xPlayer.job.name, 'divisionoption', messagess)

		cb(true)
	end)

end)

ESX.RegisterServerCallback('esx_society:getVehiclesdivision', function(source, cb, division, job)
	if division then
		local result = MySQL.Sync.fetchAll("SELECT vehicles FROM divisions WHERE owner = @owner And name = @name", {
			['@owner'] = job,
			['@name'] = division
		})

		if result == nil or result == '' then
			TriggerClientEvent('esx:showNotification', source, 'Please set garades options in ~y~boss action')
		end
		vehic = json.decode(result[1].vehicles)
		cb(vehic)
	else
		cb(false)
	end
end)

ESX.RegisterServerCallback('esx_society:getHelisdivision', function(source, cb, division, job)
	if division then
		local result = MySQL.Sync.fetchAll("SELECT helis FROM divisions WHERE owner = @owner And name = @name", {
			['@owner'] = job,
			['@name'] = division
		})

		if result == nil or result == '' then
			TriggerClientEvent('esx:showNotification', source, 'Please set garades options in ~y~boss action')
		end
		vehic = json.decode(result[1].helis)
		cb(vehic)
	else
		cb(false)
	end
end)

ESX.RegisterServerCallback('esx_society:setSocietyVehdivisionPerm', function(source, cb, job, divisioname, vehs, status, choice, VehLabels)
	local identifier = GetPlayerIdentifier(source, tonumber(0))
	local vehtable = {}
	local xPlayer = ESX.GetPlayerFromId(source)

	if not isPlayerBoss(source, job) then
		print(('esx_society: %s attempted to setSocietyVehdivisionPerm'):format(identifier))
		cb()
		return
	end


	for _, veh in ipairs(vehs) do
		if veh.model ~= choice then
			table.insert(vehtable,{
				model = veh.model,
				status = veh.value
			})
		else
			if status then
				table.insert(vehtable,{
					model = veh.model,
					status = true
				})
			else
				table.insert(vehtable,{
					model = veh.model,
					status = false
				})
			end
		end
	end

	MySQL.Async.execute('UPDATE divisions SET vehicles = @vehicles WHERE owner = @owner AND name = @name', {
		['@vehicles']   = json.encode(vehtable),
		['@owner'] = job,
		['@name']    = divisioname
	}, function(rowsChanged)

		local green = false

		if status == true then
			IsNull = {
				Chekdad = "Dad",
				ChekAZ  = "Be"
			}
			green = true
		else
			IsNull = {
				Chekdad = "Gereft",
				ChekAZ  = "Az"
			}
			green = false
		end

		messagess = {
			{["name"] = "👤 **Player Name**", ["value"] = xPlayer.name, ["inline"] = false},
			{["name"] = "🎮 **Steam Hex**", ["value"] = xPlayer.identifier, ["inline"] = false},
			{["name"] = "🌍 **Server ID**", ["value"] = xPlayer.source, ["inline"] = false},
			{["name"] = "🚗 **Vehicle Name**", ["value"] = VehLabels, ["inline"] = false},
			{["name"] = "🔠 **Data**", ["value"] = IsNull.ChekAZ.." Division ("..divisioname..") "..IsNull.Chekdad, ["inline"] = false},
		}


		JobsLog('Change Vehicle Perm ', green, xPlayer.job.name, 'divisionoption', messagess)

		cb(true)
	end)
end)

ESX.RegisterServerCallback('esx_society:setSocietyHelidivisionPerm', function(source, cb, job, divisioname, helis, status, choice, VehLabels)
	local isBoss = isPlayerBoss(source, job)
	local identifier = GetPlayerIdentifier(source, tonumber(0))
	local xPlayer    = ESX.GetPlayerFromId(source)
	local helitable = {}

	if not isBoss then
		print(('esx_society: %s attempted to setSocietyHelidivisionPerm'):format(identifier))
		cb()
		return
	end

	for _, heli in ipairs(helis) do
		if heli.model ~= choice then
			table.insert(helitable,{
				model = heli.model,
				status = heli.value
			})
		else
			if status then
				table.insert(helitable,{
					model = heli.model,
					status = true
				})
			else
				table.insert(helitable,{
					model = heli.model,
					status = false
				})
			end
		end
	end

	MySQL.Async.execute('UPDATE divisions SET helis = @helis WHERE owner = @owner AND name = @name', {
		['@helis']   = json.encode(helitable),
		['@owner'] = job,
		['@name']    = divisioname
	}, function(rowsChanged)

		local green = false

		if status == true then
			IsNull = {
				Chekdad = "Dad",
				ChekAZ  = "Be"
			}
			green = true
		else
			IsNull = {
				Chekdad = "Gereft",
				ChekAZ  = "Az"
			}
			green = false
		end

		messagess = {
			{["name"] = "👤 **Player Name**", ["value"] = xPlayer.name, ["inline"] = false},
			{["name"] = "🎮 **Steam Hex**", ["value"] = xPlayer.identifier, ["inline"] = false},
			{["name"] = "🌍 **Server ID**", ["value"] = xPlayer.source, ["inline"] = false},
			{["name"] = "🚗 **Heli Name**", ["value"] = VehLabels, ["inline"] = false},
			{["name"] = "🔠 **Data**", ["value"] = IsNull.ChekAZ.." Division ("..divisioname..") "..IsNull.Chekdad, ["inline"] = false},
		}


		JobsLog('Change Heli Perm ', green, xPlayer.job.name, 'divisionoption', messagess)

		cb(true)
	end)
end)

ESX.RegisterServerCallback('esx_society:setDivisionWeapPerm', function(source, cb, job, division, weapons, status, choice)
	local identifier = GetPlayerIdentifier(source, tonumber(0))
	local xPlayer    = ESX.GetPlayerFromId(source)

	if not isPlayerBoss(source, job) then
		print(('esx_society: %s attempted to setDivisionWeapPerm'):format(identifier))
		cb()
		return
	end

	local weapontable = {}

	for _, weapon in ipairs(weapons) do
		if weapon.model ~= choice then
			table.insert(weapontable,{
				model = weapon.model,
				status = weapon.value
			})
		else
			if status then
				table.insert(weapontable,{
					model = weapon.model,
					status = true
				})
			else
				table.insert(weapontable,{
					model = weapon.model,
					status = false
				})
			end
		end
	end

	MySQL.Async.execute('UPDATE divisions SET weapons = @weapons WHERE owner = @owner AND name = @name', {
		['@weapons']   = json.encode(weapontable),
		['@owner'] = job,
		['@name']    = division
	}, function(rowsChanged)

		local green = false

		if status == true then
			IsNull = {
				Chekdad = "Dad",
				ChekAZ  = "Be"
			}
			green = true
		else
			IsNull = {
				Chekdad = "Gereft",
				ChekAZ  = "Az"
			}
			green = false
		end

		messagess = {
			{["name"] = "👤 **Player Name**", ["value"] = xPlayer.name, ["inline"] = false},
			{["name"] = "🎮 **Steam Hex**", ["value"] = xPlayer.identifier, ["inline"] = false},
			{["name"] = "🌍 **Server ID**", ["value"] = xPlayer.source, ["inline"] = false},
			{["name"] = "🔫 **Weapon Name**", ["value"] = ESX.GetWeaponLabel(choice), ["inline"] = false},
			{["name"] = "🔠 **Data**", ["value"] = IsNull.ChekAZ.." Division ("..division..") "..IsNull.Chekdad, ["inline"] = false},
		}


		JobsLog('Change Weapon Perm ', green, xPlayer.job.name, 'divisionoption', messagess)

		cb(true)
	end)
end)

ESX.RegisterServerCallback('esx_society:getVehicles', function(source, cb, rank, job)
	local veh       = (Jobs[job].grades[tostring(rank)].vehicles) or '{}'
	if veh == nil or veh == '' then
		TriggerClientEvent('esx:showNotification', source, 'Please set garades options in ~y~boss action')
	end
	cb(json.decode(veh))
end)

ESX.RegisterServerCallback('esx_society:getHelis', function(source, cb, rank, job)
	local heli       = (Jobs[job].grades[tostring(rank)].helis) or '{}'
	if heli == nil or heli == '' then
		TriggerClientEvent('esx:showNotification', source, 'Please set garades options in ~y~boss action')
	end
	cb(json.decode(heli))
end)

ESX.RegisterServerCallback('esx_society:getItems', function(source, cb, rank, job)
	local item = (Jobs[job].grades[tostring(rank)].items) or '{}'
	if item == nil or item == '' then
		TriggerClientEvent('esx:showNotification', source, 'Please set garades options in ~y~boss action')
	end
	cb(json.decode(item))
end)

ESX.RegisterServerCallback('esx_society:getJobItems', function(source, cb, job)
	TriggerEvent('esx_addoninventory:getSharedInventory', 'society_'..job, function(inventory)

		cb(inventory.items)
	end)
end)

ESX.RegisterServerCallback('esx_society:getEmployeclothes', function(source, cb, rank, gender, job)
	local fskin = {}
	local mskin = {}
	fskin       = json.decode(Jobs[job].grades[tostring(rank)].skin_female) or '{}'
	mskin       = json.decode(Jobs[job	].grades[tostring(rank)].skin_male) or '{}'
	local xPlayers = ESX.GetPlayers()
	if tonumber(rank) ~= 0 and job ~= 'nojob' then
		for i=tonumber(1), #xPlayers, tonumber(1) do
			local xPlayer = ESX.GetPlayerFromId(xPlayers[i])

			if xPlayer.job.name == job and xPlayer.job.grade == rank then
				xPlayer.setJob(job, rank)
			end
		end

		if gender == 'male' then
			cb(mskin)
		elseif  gender == 'female' then
			cb(fskin)
		end
	end
end)

ESX.RegisterServerCallback('esx_society:getEmployeclothesdivision', function(source, cb, division, gender, job)
	local fskin = {}
	local mskin = {}
	fskin       = json.decode(Divisions[job].names[tostring(division)].skin_female)
	mskin       = json.decode(Divisions[job].names[tostring(division)].skin_male)

	if gender == 'male' then
		cb(mskin)
	elseif  gender == 'female' then
		cb(fskin)
	end

end)

ESX.RegisterServerCallback('esx_society:setSocietyItemPerm', function(source, cb, job, rank, items, status, choice, ItemLabel)
	local identifier = GetPlayerIdentifier(source, tonumber(0))
	local xPlayer = ESX.GetPlayerFromId(source)
	local isBoss = isPlayerBoss(source, job)
	local itemtable = {}
	if isBoss then
		for _, item in ipairs(items) do
			if item.name ~= choice then
				table.insert(itemtable,{
					name = item.name,
					status = item.value
				})
			else
				table.insert(itemtable,{
					name = item.name,
					status = status
				})
			end
		end
		Jobs[job].grades[tostring(rank)].items = json.encode(itemtable)
		MySQL.Async.execute('UPDATE job_grades SET items = @items WHERE job_name = @job_name AND grade = @grade', {
			['@items']   = json.encode(itemtable),
			['@job_name'] = job,
			['@grade']    = rank
		}, function(rowsChanged)

			local green = false

			local result = MySQL.Sync.fetchAll('SELECT label FROM job_grades WHERE job_name = @job_name AND grade = @grade', {
				['@job_name'] = xPlayer.job.name,
				['@grade'] = rank
			})

			if status == true then
				IsNull = {
					Chekdad = "Dad",
					ChekAZ  = "Be"
				}
				green = true
			else
				IsNull = {
					Chekdad = "Gereft",
					ChekAZ  = "Az"
				}
				green = false
			end

			messagess = {
				{["name"] = "👤 **Player Name**", ["value"] = xPlayer.name, ["inline"] = false},
				{["name"] = "🎮 **Steam Hex**", ["value"] = xPlayer.identifier, ["inline"] = false},
				{["name"] = "🌍 **Server ID**", ["value"] = xPlayer.source, ["inline"] = false},
				{["name"] = "📦 **Item Name**", ["value"] = ItemLabel, ["inline"] = false},
				{["name"] = "🔠 **Data**", ["value"] = IsNull.ChekAZ.." Rank ("..result[1].label..")-{"..rank.."} "..IsNull.Chekdad, ["inline"] = false},
			}


			JobsLog('Change Item Perm ', green, xPlayer.job.name, 'option', messagess)

			cb(true)
		end)
	else
		print(('esx_society: %s attempted to setSocietyItemPerm'):format(identifier))
		cb()
	end
end)

ESX.RegisterServerCallback('esx_society:setSocietyWeapPerm', function(source, cb, job, rank, weapons, status, choice)
	local isBoss = isPlayerBoss(source, job)
	local identifier = GetPlayerIdentifier(source, tonumber(0))
	local xPlayer    = ESX.GetPlayerFromId(source)
	local weapontable = {}
	if isBoss then
		for _, weapon in ipairs(weapons) do
			if weapon.model ~= choice then
				table.insert(weapontable,{
					model = weapon.model,
					status = weapon.value
				})
			else
				if status then
					table.insert(weapontable,{
						model = weapon.model,
						status = true
					})
				else
					table.insert(weapontable,{
						model = weapon.model,
						status = false
					})
				end
			end
		end

		Jobs[job].grades[tostring(rank)].weapons = json.encode(weapontable)
		MySQL.Async.execute('UPDATE job_grades SET weapons = @weapons WHERE job_name = @job_name AND grade = @grade', {
			['@weapons']   = json.encode(weapontable),
			['@job_name'] = job,
			['@grade']    = rank
		}, function(rowsChanged)
			local green = false

			local result = MySQL.Sync.fetchAll('SELECT label FROM job_grades WHERE job_name = @job_name AND grade = @grade', {
				['@job_name'] = xPlayer.job.name,
				['@grade'] = rank
			})

			if status == true then
				IsNull = {
					Chekdad = "Dad",
					ChekAZ  = "Be"
				}
				green = true
			else
				IsNull = {
					Chekdad = "Gereft",
					ChekAZ  = "Az"
				}
				green = false
			end

			messagess = {
				{["name"] = "👤 **Player Name**", ["value"] = xPlayer.name, ["inline"] = false},
				{["name"] = "🎮 **Steam Hex**", ["value"] = xPlayer.identifier, ["inline"] = false},
				{["name"] = "🌍 **Server ID**", ["value"] = xPlayer.source, ["inline"] = false},
				{["name"] = "🔫 **Weapon Name**", ["value"] = ESX.GetWeaponLabel(choice), ["inline"] = false},
				{["name"] = "🔠 **Data**", ["value"] = IsNull.ChekAZ.." Rank ("..result[1].label..")-{"..rank.."} "..IsNull.Chekdad, ["inline"] = false},
			}


			JobsLog('Change Weapon Perm ', green, xPlayer.job.name, 'option', messagess)

			cb(true)
		end)
	else
		print(('esx_society: %s attempted to setSocietyWeapPerm'):format(identifier))
		cb()
	end
end)

ESX.RegisterServerCallback('esx_society:setSocietyVehPerm', function(source, cb, job, rank, vehs, status, choice, vehlabel)
	local isBoss = isPlayerBoss(source, job)
	local identifier = GetPlayerIdentifier(source, tonumber(0))
	local xPlayer = ESX.GetPlayerFromId(source)
	local vehtable = {}
	if isBoss then
		for _, veh in ipairs(vehs) do
			if veh.model ~= choice then
				table.insert(vehtable,{
					model = veh.model,
					status = veh.value
				})
			else
				if status then
					table.insert(vehtable,{
						model = veh.model,
						status = true
					})
				else
					table.insert(vehtable,{
						model = veh.model,
						status = false
					})
				end
			end
		end
		Jobs[job].grades[tostring(rank)].vehicles = json.encode(vehtable)
		MySQL.Async.execute('UPDATE job_grades SET vehicles = @vehicles WHERE job_name = @job_name AND grade = @grade', {
			['@vehicles']   = json.encode(vehtable),
			['@job_name'] = job,
			['@grade']    = rank
		}, function(rowsChanged)

			local green = false

			local result = MySQL.Sync.fetchAll('SELECT label FROM job_grades WHERE job_name = @job_name AND grade = @grade', {
				['@job_name'] = xPlayer.job.name,
				['@grade'] = rank
			})

			if status == true then
				IsNull = {
					Chekdad = "Dad",
					ChekAZ  = "Be"
				}
				green = true
			else
				IsNull = {
					Chekdad = "Gereft",
					ChekAZ  = "Az"
				}
				green = false
			end

			messagess = {
				{["name"] = "👤 **Player Name**", ["value"] = xPlayer.name, ["inline"] = false},
				{["name"] = "🎮 **Steam Hex**", ["value"] = xPlayer.identifier, ["inline"] = false},
				{["name"] = "🌍 **Server ID**", ["value"] = xPlayer.source, ["inline"] = false},
				{["name"] = "🚗 **Vehicle Name**", ["value"] = vehlabel, ["inline"] = false},
				{["name"] = "🔠 **Data**", ["value"] = IsNull.ChekAZ.." Rank ("..result[1].label..")-{"..rank.."} "..IsNull.Chekdad, ["inline"] = false},
			}


			JobsLog('Change Vehicle Perm ', green, xPlayer.job.name, 'option', messagess)

			cb(true)
		end)
	else
		print(('esx_society: %s attempted to setSocietyVehPerm'):format(identifier))
		cb()
	end
end)

ESX.RegisterServerCallback('esx_society:setSocietyHeliPerm', function(source, cb, job, rank, helis, status, choice, heliLabel)
	local isBoss = isPlayerBoss(source, job)
	local identifier = GetPlayerIdentifier(source, tonumber(0))
	local xPlayer    = ESX.GetPlayerFromId(source)
	local helitable = {}
	if isBoss then
		for _, veh in ipairs(helis) do
			if veh.model ~= choice then
				table.insert(helitable,{
					model = veh.model,
					status = veh.value
				})
			else
				if status then
					table.insert(helitable,{
						model = veh.model,
						status = true
					})
				else
					table.insert(helitable,{
						model = veh.model,
						status = false
					})
				end
			end
		end
		Jobs[job].grades[tostring(rank)].helis = json.encode(helitable)
		MySQL.Async.execute('UPDATE job_grades SET helis = @helis WHERE job_name = @job_name AND grade = @grade', {
			['@helis']   = json.encode(helitable),
			['@job_name'] = job,
			['@grade']    = rank
		}, function(rowsChanged)


			local green = false

			local result = MySQL.Sync.fetchAll('SELECT label FROM job_grades WHERE job_name = @job_name AND grade = @grade', {
				['@job_name'] = xPlayer.job.name,
				['@grade'] = rank
			})

			if status == true then
				IsNull = {
					Chekdad = "Dad",
					ChekAZ  = "Be"
				}
				green = true
			else
				IsNull = {
					Chekdad = "Gereft",
					ChekAZ  = "Az"
				}
				green = false
			end

			messagess = {
				{["name"] = "👤 **Player Name**", ["value"] = xPlayer.name, ["inline"] = false},
				{["name"] = "🎮 **Steam Hex**", ["value"] = xPlayer.identifier, ["inline"] = false},
				{["name"] = "🌍 **Server ID**", ["value"] = xPlayer.source, ["inline"] = false},
				{["name"] = "🚁 **Heli Name**", ["value"] = heliLabel, ["inline"] = false},
				{["name"] = "🔠 **Data**", ["value"] = IsNull.ChekAZ.." Rank ("..result[1].label..")-{"..rank.."} "..IsNull.Chekdad, ["inline"] = false},
			}


			JobsLog('Change Heli Perm ', green, xPlayer.job.name, 'option', messagess)

			cb(true)
		end)
	else
		print(('esx_society: %s attempted to setSocietyHeliPerm'):format(identifier))
		cb()
	end
end)

ESX.RegisterServerCallback('esx_society:setUniform', function(source, cb, job, rank, gender, model)
	local identifier = GetPlayerIdentifier(source, tonumber(0))
	local xPlayer    = ESX.GetPlayerFromId(source)

	if not isPlayerBoss(source, job) then
		print(('esx_society: %s attempted to setUniform'):format(identifier))
		cb()
		return
	end

	if gender == 'male' then
		MySQL.Async.execute('UPDATE job_grades SET skin_male = @skin_male WHERE job_name = @job_name AND grade = @grade', {
			['@skin_male']   = json.encode(model),
			['@job_name'] = job,
			['@grade']    = rank
		}, function(rowsChanged)
			Jobs[job].grades[tostring(rank)].skin_male = json.encode(model)

			cb()
		end)
	elseif  gender == 'female' then
		MySQL.Async.execute('UPDATE job_grades SET skin_female = @skin_female WHERE job_name = @job_name AND grade = @grade', {
			['@skin_female']   = json.encode(model),
			['@job_name'] = job,
			['@grade']    = rank
		}, function(rowsChanged)
			Jobs[job].grades[tostring(rank)].skin_female = json.encode(model)

			cb()
		end)
	end
	local result = MySQL.Sync.fetchAll('SELECT label FROM job_grades WHERE job_name = @job_name AND grade = @grade', {
		['@job_name'] = xPlayer.job.name,
		['@grade'] = rank
	})
	messagess = {
		{["name"] = "👤 **Player Name**", ["value"] = xPlayer.name, ["inline"] = false},
		{["name"] = "🎮 **Steam Hex**", ["value"] = xPlayer.identifier, ["inline"] = false},
		{["name"] = "🌍 **Server ID**", ["value"] = xPlayer.source, ["inline"] = false},
		{["name"] = "🔠 **Data**", ["value"] = "Lebas Rank ("..result[1].label..")-{"..rank.."} Ra Taghir Dad", ["inline"] = false},
	}
	if gender == 'female' then
		names = 'Female'
	elseif gender == 'male' then
		names = 'Male'
	end

	JobsLog('Change OutFit '..names, true, xPlayer.job.name, 'option', messagess)
end)

ESX.RegisterServerCallback('esx_society:setUniformdivision', function(source, cb, job, division, gender, model)
	local identifier = GetPlayerIdentifier(source, tonumber(0))
	local sPlayer    = ESX.GetPlayerFromId(source)

	if not isPlayerBoss(source, job) then
		print(('esx_society: %s attempted to setUniformdivision'):format(identifier))
		cb()
		return
	end

	if gender == 'male' then
		MySQL.Async.execute('UPDATE divisions SET skin_male = @skin_male WHERE owner = @owner AND name = @name', {
			['@skin_male']   = json.encode(model),
			['@owner'] = job,
			['@name']    = division
		}, function(rowsChanged)
			Divisions[job].names[division].skin_male = json.encode(model)

			cb()
		end)
	elseif  gender == 'female' then
		MySQL.Async.execute('UPDATE divisions SET skin_female = @skin_female WHERE owner = @owner AND name = @name', {
			['@skin_female']   = json.encode(model),
			['@owner'] = job,
			['@name']    = division
		}, function(rowsChanged)
			Divisions[job].names[division].skin_female = json.encode(model)

			cb()
		end)
	end
	local Skins = ''
	if gender == 'female' then
		Skins = 'Female'
	elseif gender == 'male' then
		Skins = 'Male'
	end

	messagess = {
		{["name"] = "👤 **Player Name**", ["value"] = sPlayer.name, ["inline"] = false},
		{["name"] = "🎮 **Steam Hex**", ["value"] = sPlayer.identifier, ["inline"] = false},
		{["name"] = "🌍 **Server ID**", ["value"] = sPlayer.source, ["inline"] = false},
		{["name"] = "🔠 **Data**", ["value"] = "Division Name : "..division.."\nLebase ("..Skins..") Ra Taghir Dad" , ["inline"] = false},
	}
	JobsLog('Change OutFit Division ', true, sPlayer.job.name, 'divisionoption', messagess)

end)

ESX.RegisterServerCallback('esx_society:CreateDivision', function(source, cb, divisionname, divisionlabel)
	local source = source
	local sPlayer = ESX.GetPlayerFromId(source)
	local playerjname = sPlayer.job.name
	local creatediv = true

	if not isPlayerBoss(source, playerjname) then
		print(('esx_society: %s attempted to CreateDivision'):format(sPlayer.identifier))
		cb(false)
		return
	end

	exports.oxmysql:execute("SELECT * FROM divisions WHERE owner = ? ",{
		playerjname,

	}, function(newDivisionCheck)
		for i=1, #newDivisionCheck, 1 do
			if newDivisionCheck[i].name == divisionname then

				TriggerClientEvent("chatMessage",source,"[SYSTEM]",{255, 0, 0},"Division (^2" .. tostring(divisionname) .."^0) Vojod Darad ")
				cb(false)
				creatediv = false
				return

			end
		end

		if creatediv then

			exports.oxmysql:execute('INSERT INTO divisions (owner, name, label, skin_male, skin_female, vehicles, helis, weapons, items) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)', {
				playerjname,
				divisionname,
				divisionlabel,
				'[]',
				'[]',
				'[]',
				'[]',
				'[]',
				'[]',
			})
			reloaddatabase()
			TriggerClientEvent("chatMessage",source,"[SYSTEM]",{255, 0, 0},"Division Name: ^2" .. tostring(divisionname) .. " ^0Ba Label: ^2"..tostring(divisionlabel).." ^0ba movafaghiat be ^3 "..sPlayer.job.name.." ^0ezafe shod!")

			messagess = {
				{["name"] = "👤 **Player Name**", ["value"] = sPlayer.name, ["inline"] = false},
				{["name"] = "🎮 **Steam Hex**", ["value"] = sPlayer.identifier, ["inline"] = false},
				{["name"] = "🌍 **Server ID**", ["value"] = sPlayer.source, ["inline"] = false},
				{["name"] = "🔠 **Data**", ["value"] = "Division Name : "..divisionname.."\nDivision Label : "..divisionlabel, ["inline"] = false},
			}


			JobsLog('Create Division ', true, sPlayer.job.name, 'divisiondata', messagess)

			cb(true)
		end
	end)

end)

ESX.RegisterServerCallback('esx_society:RemoveDivision', function(source, cb, divisionname, divisionlabel)
    local source = source
    local sPlayer = ESX.GetPlayerFromId(source)
    local playerjname = sPlayer.job.name

    if not isPlayerBoss(source, playerjname) then
        print(('esx_society: %s attempted to RemoveDivision'):format(sPlayer.identifier))
        cb(false)
        return
    end

    local allUsers = MySQL.Sync.fetchAll('SELECT identifier, divisions FROM users')

    for _, user in ipairs(allUsers) do
        local divisions = json.decode(user.divisions)

        for i, div in ipairs(divisions) do
            if div.name == divisionname and div.label == divisionlabel then

                table.remove(divisions, i)
                break
            end
        end

        local updatedData = json.encode(divisions)
        MySQL.Sync.execute('UPDATE users SET divisions = @divisions WHERE identifier = @identifier', {
            ['@divisions'] = updatedData,
            ['@identifier'] = user.identifier
        })
    end


	exports.oxmysql:execute('DELETE FROM divisions WHERE owner = ? AND name = ? AND label = ?', {
		playerjname,
		divisionname,
		divisionlabel,
	})

	messagess = {
		{["name"] = "👤 **Player Name**", ["value"] = sPlayer.name, ["inline"] = false},
		{["name"] = "🎮 **Steam Hex**", ["value"] = sPlayer.identifier, ["inline"] = false},
		{["name"] = "🌍 **Server ID**", ["value"] = sPlayer.source, ["inline"] = false},
		{["name"] = "🔠 **Data**", ["value"] = "Division Name : "..divisionname.."\nDivision Label : "..divisionlabel, ["inline"] = false},
	}


	JobsLog('Delete Division ', false, sPlayer.job.name, 'divisiondata', messagess)

	TriggerClientEvent("chatMessage", source, "[SYSTEM]", {255, 0, 0}, "Division Name: ^2" .. tostring(divisionname) .. " ^0Ba Label: ^2" .. tostring(divisionlabel) .. " ^0ba movafaghiat Az ^3 " .. sPlayer.job.name .. " ^0Hazf shod!")
	cb(true)
end)

ESX.RegisterServerCallback('esx_society:getUniformsDivision', function(source, cb, diviname, job)
	local fskin = {}
	local mskin = {}

	exports.oxmysql:execute("SELECT * FROM divisions WHERE owner = ? AND name = ? ",{
		job,
		diviname
	}, function(division)

		local mskin = json.decode(division[1].skin_male)
		local fskin = json.decode(division[1].skin_female)


		if mskin == nil or mskin == '' or fskin == nil or fskin == '' then
			TriggerClientEvent('esx:showNotification', source, 'Please set garades options in ~y~boss action')
		end
		cb(mskin, fskin)

	end)


end)

ESX.RegisterServerCallback('esx_society:ChangeDivision', function(source, cb, society, dvisionid, NewName, typee)
    local source = source
    local sPlayer = ESX.GetPlayerFromId(source)
    local playerjname = sPlayer.job.name
    local creatediv = true

    if not isPlayerBoss(source, playerjname) then
        print(('esx_society: %s attempted to ChangeDivision'):format(sPlayer.identifier))
        cb(false)
        return
    end

    exports.oxmysql:execute("SELECT * FROM divisions WHERE owner = ? ", {
        playerjname,
    }, function(newDivisionCheck)
        for i = 1, #newDivisionCheck, 1 do
            if newDivisionCheck[i].name == NewName then
                TriggerClientEvent("chatMessage", source, "[SYSTEM]", {255, 0, 0}, "Division (^2" .. tostring(NewName) .. "^0) Vojod Darad!")
                cb(false)
                creatediv = false
                return
            end
        end

        if creatediv then
			if typee == 'name' then
				exports.oxmysql:execute("SELECT name FROM divisions WHERE id = ?", {
					dvisionid
				}, function(oldDivisionName)
					local oldName = oldDivisionName[1].name

					exports.oxmysql:execute("UPDATE divisions SET " .. typee .. " = @label WHERE id = @dvisionid", {
						['@label'] = NewName,
						['@dvisionid'] = tonumber(dvisionid),
					}, function(division)

						local allUsers = MySQL.Sync.fetchAll('SELECT identifier, divisions FROM users WHERE job = ?',{playerjname})

						for _, user in ipairs(allUsers) do
							local divisions = json.decode(user.divisions)

							for _, div in ipairs(divisions) do
								if div.name == oldName then
									div.name = NewName
								end
							end

							local updatedData = json.encode(divisions)
							MySQL.Sync.execute('UPDATE users SET divisions = @divisions WHERE identifier = @identifier', {
								['@divisions'] = updatedData,
								['@identifier'] = user.identifier
							})
						end
						reloaddatabase()
						TriggerClientEvent("chatMessage", source, "[SYSTEM]", {255, 0, 0}, typee .. " Division Be ^2" .. tostring(NewName) .. " ^0Taghir Kard!")

						messagess = {
							{["name"] = "👤 **Player Name**", ["value"] = sPlayer.name, ["inline"] = false},
							{["name"] = "🎮 **Steam Hex**", ["value"] = sPlayer.identifier, ["inline"] = false},
							{["name"] = "🌍 **Server ID**", ["value"] = sPlayer.source, ["inline"] = false},
							{["name"] = "🔠 **Data**", ["value"] = "Az : ("..oldName..") \nBe : ("..NewName..") \nTaghir Dad", ["inline"] = false},
						}
						JobsLog('Change Name Division ', true, sPlayer.job.name, 'divisiondata', messagess)

						cb(true)
					end)
				end)

			elseif typee == 'label' then

				exports.oxmysql:execute("SELECT label FROM divisions WHERE id = ?", {
					dvisionid
				}, function(oldDivisionName)
					local oldName = oldDivisionName[1].label

					exports.oxmysql:execute("UPDATE divisions SET " .. typee .. " = @label WHERE id = @dvisionid", {
						['@label'] = NewName,
						['@dvisionid'] = tonumber(dvisionid),
					}, function(division)

						local allUsers = MySQL.Sync.fetchAll('SELECT identifier, divisions FROM users WHERE job = ?',{playerjname})

						for _, user in ipairs(allUsers) do
							local divisions = json.decode(user.divisions)

							for _, div in ipairs(divisions) do
								if div.label == oldName then
									div.label = NewName
								end
							end

							local updatedData = json.encode(divisions)
							MySQL.Sync.execute('UPDATE users SET divisions = @divisions WHERE identifier = @identifier', {
								['@divisions'] = updatedData,
								['@identifier'] = user.identifier
							})
						end
						reloaddatabase()
						TriggerClientEvent("chatMessage", source, "[SYSTEM]", {255, 0, 0}, typee .. " Division Be ^2" .. tostring(NewName) .. " ^0Taghir Kard!")

						messagess = {
							{["name"] = "👤 **Player Name**", ["value"] = sPlayer.name, ["inline"] = false},
							{["name"] = "🎮 **Steam Hex**", ["value"] = sPlayer.identifier, ["inline"] = false},
							{["name"] = "🌍 **Server ID**", ["value"] = sPlayer.source, ["inline"] = false},
							{["name"] = "🔠 **Data**", ["value"] = "Az : ("..oldName..") \nBe : ("..NewName..") \nTaghir Dad", ["inline"] = false},
						}
						JobsLog('Change Label Division ', true, sPlayer.job.name, 'divisiondata', messagess)

						cb(true)
					end)
				end)
			end
		end
    end)
end)

ESX.RegisterServerCallback('esx_society:GetPermWashMoney', function(source, cb, JobName)

	exports.oxmysql:execute("SELECT washmoney FROM jobs WHERE name = ?", {
		JobName
	}, function(result)
		print(result[1].washmoney)
		cb(result[1].washmoney)

	end)
end)

RegisterNetEvent("esx_society:SetPermWash")
AddEventHandler('esx_society:SetPermWash', function(JobName, Status)
	local green = true
	local xPlayer = ESX.GetPlayerFromId(source)
	local OffOn = "Faal"

	if not isPlayerBoss(source, JobName) then
		print(('esx_society: %s attempted to SetPermWash'):format(xPlayer.identifier))
		return
	end

	if Status == "false" then
		green = false
		OffOn = 'Gheyre Faal'
	end
	exports.oxmysql:execute("UPDATE jobs SET washmoney = ? WHERE name = ?", {
		Status,
		JobName,
	})

	messagess = {
		{["name"] = "👤 **Player Name**", ["value"] = xPlayer.name, ["inline"] = false},
		{["name"] = "🎮 **Steam Hex**", ["value"] = xPlayer.identifier, ["inline"] = false},
		{["name"] = "🌍 **Server ID**", ["value"] = xPlayer.source, ["inline"] = false},
		{["name"] = "🔠 **Data**", ["value"] = "Wash Money Ra "..OffOn.." Kard", ["inline"] = false},
	}


	JobsLog('Change Wash Money', green, xPlayer.job.name, 'option', messagess)

end)

Citizen.CreateThread(function()
	while true do
		local count = 50000
		for k,v in pairs(GetPlayers()) do
			local xPlayer = ESX.GetPlayerFromId(v)
			if xPlayer then
				if xPlayer.job.name == 'police' or xPlayer.job.name == 'mt' or xPlayer.job.name == 'sheriff' then
					exports.oxmysql:execute("SELECT washmoney FROM jobs WHERE name = ?", {
						xPlayer.job.name
					}, function(result)
						if result[1].washmoney == "true" then
							TriggerEvent('esx_addoninventory:getSharedInventory', 'society_'..xPlayer.job.name, function(inventory)
								local inventoryItem = inventory.getItem('eskenas')
								if count > 0 and inventoryItem.count >= count then
									inventory.removeItem('eskenas', count)


									TriggerEvent('esx_addonaccount:getSharedAccount', 'society_law', function(account)

										account.addMoney(30000)

									end)
								end
							end)
						end
					end)
				end
			end
		end
		Citizen.Wait(30 * 60 * 1000)
	end
end)

function JobsLog(titels, grren, job, logs, messagess)
	if Config.LogSystem[job] then
		local WebHookLog = ""
		local WebHookAdmin = ""
		local jobadmin = "admin"..job
		local ganglogo
		local Porof
		if logs == "money" then
			WebHookLog   = Config.LogSystem[job].money
			WebHookAdmin = Config.LogSystem[jobadmin].money
		elseif logs == "option" then
			WebHookLog   = Config.LogSystem[job].option
			WebHookAdmin = Config.LogSystem[jobadmin].option
		elseif logs == "manage" then
			WebHookLog   = Config.LogSystem[job].manage
			WebHookAdmin = Config.LogSystem[jobadmin].manage
		elseif logs == "divisiondata" then
			WebHookLog   = Config.LogSystem[job].divisiondata
			WebHookAdmin = Config.LogSystem[jobadmin].divisiondata
		elseif logs == "divisionoption" then
			WebHookLog   = Config.LogSystem[job].divisionoption
			WebHookAdmin = Config.LogSystem[jobadmin].divisionoption
		elseif logs == "divisionemploee" then
			WebHookLog   = Config.LogSystem[job].divisionemploee
			WebHookAdmin = Config.LogSystem[jobadmin].divisionemploee
		end

		Porof = Config.LogSystem[job].img
		local colors = 0

		if grren then
			colors = 65280
		else
			colors = 16711680
		end



		local logMessage = {
			{
				["color"] = colors,
				["title"] = titels,
				["fields"] = messagess,

				["footer"] = {
					["text"] = os.date("%Y-%m-%d %H:%M:%S"),
				}
			}
		}


		PerformHttpRequest(WebHookLog, function(err, text, headers) end, "POST", json.encode({username = string.gsub(job, string.sub(job, 1, 1), string.upper(string.sub(job, 1, 1))) ..' Job', embeds = logMessage, avatar_url = tostring(Porof)}), {['Content-Type'] = 'application/json'})
		PerformHttpRequest(WebHookAdmin, function(err, text, headers) end, "POST", json.encode({username = string.gsub(job, string.sub(job, 1, 1), string.upper(string.sub(job, 1, 1))) ..' Job', embeds = logMessage, avatar_url = tostring(Porof)}), {['Content-Type'] = 'application/json'})
	end
end