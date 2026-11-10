-- Pub by FleeX Team , https://discord.gg/87rGBxgCsa

local openState = false
local lotteryConfig = {
	[1] = 'Robbery A',
	[2] = 'Robbery B',
	[3] = 'Robbery C',
	[4] = 'Robbery D',
	[5] = 'Robbery E'
}
local drawEndCD = 0
function buyTicket(id)
	if not openState then
		openState = true
		Citizen.CreateThread(function()
			while openState do
				Wait(5000)
				if not ESX.UI.Menu.IsOpen('default', GetCurrentResourceName(), 'ssss3') then
					openState = false
					break
				end
				buyTicket(id)
			end
		end)
	end
	local elements = {
		{label = 'قرعه کشی هنوز شروع نشده'},
	}
	local robConfig = exports['sun-robbery']:getConfig()
	
	ESX.TriggerServerCallback('rob:getLotteryData', function(planCount, ticketLottery, nextLotteryTime, lotteryWinner, gangPoint)
		if ticketLottery.canBuy and (ticketLottery.endTime - exports['sunset_utils']:GetServerOSTime()) > 20 then
			-- if not rob.ghoreKeshiList[ESX.PlayerData.gang.name] then
			-- 	elements[1] = {label = 'کدام رابری را قصد سرقت دارید؟',value = 'sherkat'}
			-- else
			-- 	-- if ESX.serverNum ~= 2 then
			-- 	-- 	elements[1] = {label = 'افزایش شانس قرعه کشی',value = 'sherkat'}
			-- 	-- end
			-- end
            elements[1] = {label = 'Afzayesh shans ghore keshi',value = 'sherkat'}
		else
			table.remove(elements,1)
		end
		if ticketLottery.canBuy then
			elements[2] = {label = ('%ss ta shoroe ghore keshi'):format(ticketLottery.endTime - exports['sunset_utils']:GetServerOSTime()),value = 'sherkat'}
		else
			ESX.chatMessage('Tedad plan ha : '.. planCount, 'gang')
			ESX.chatMessage('Tedad robbery point : '.. gangPoint, 'gang')
		end
		table.insert(elements, {label = 'Tedad plan ha : '.. planCount})
		table.insert(elements, {label = 'Tedad robbery point : '.. gangPoint})
		for k, v in pairs(robConfig) do
			if not v.disabled and v.lotteryId == id then
				table.insert(elements, {label = v.label .. '('.. v.startCheck.pointNeed ..' Point)', value = k, config = v})
			end
		end
		if ticketLottery.canBuy then
			local jobs = {}
			local p = promise:new()
			ESX.TriggerServerCallback('rob:getJobsCount',function(count)
				p:resolve(count)
			end)
			jobs = Citizen.Await(p)

			for k, v in pairs(elements) do
				if v.config then
					local militaryCount = 0
					if v.config.startCheck.militaryNeed.jobs[1] == 'all' then
						militaryCount = jobs.all
					else
						for k, v in pairs(v.config.startCheck.militaryNeed.jobs) do
							militaryCount += jobs[v]
						end
					end
					v.canBuy = militaryCount >= v.config.startCheck.militaryNeed.count
					v.label = v.label .. ' : ' .. (v.canBuy and '✔️' or '❌')
				end
			end
			if ticketLottery.list then
				for k, v in pairs(ticketLottery.list) do
					table.insert(elements,{label = k .. ' - x'.. v.count})
				end
			end
			ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'ssss3', {
				title    = 'Ticket',
				align    = 'top-right',
				elements = elements
			}, function(data, menu)
				if data.current.value == 'sherkat' and ticketLottery.canBuy and not ESX.jobsGang[ESX.PlayerData.gang.name] then
					keyboard, count = exports["input"]:Keyboard({
						header = 'Che tedad plan ro mizarid?',
						rows = {'Tedad'}
					})
					if keyboard then
						local count = tonumber(count) or 1
						if tonumber(count) then
							if ESX.doesHaveGangPerm('ghoreKeshi') and count > 0 then
								ESX.TriggerServerEvent('rob:registerLottery', id, tonumber(count))
								buyTicket(id)
							else
								ESX.Alert('', 'Shoma dastresi be sherkat dar ghore keshi nadarid.', 7000, 'error')
							end
						end
					end
				end
			end, function(data, menu)
				menu.close()
			end)
		else
			ESX.UI.Menu.CloseAll()
			drawEndCD = id
			local timer = nextLotteryTime - exports['sunset_utils']:GetServerOSTime()
			Citizen.CreateThread(function()
				while drawEndCD == id and timer > 0 do
					timer = timer - 10
					if timer > 0 then
						if lotteryWinner.name then
							ESX.chatMessage(timer .. 's ta ghore keshi jadid(Last winner '.. lotteryWinner.name ..')!', 'gang')
						else
							ESX.chatMessage(timer .. 's ta ghore keshi jadid!', 'gang')
						end
					end
					Citizen.Wait(10000)
				end
				drawEndCD = 0
			end)
			ESX.ShowNotification('Ghore keshi hanoz shoroe nashode ast', 3000)
		end
	end, id)
end
exports('buyTicket', function()
	local elements = {}
	for k, v in pairs(lotteryConfig) do
		table.insert(elements, {label = v, id = k})
	end
	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'ssss2', {
		title    = 'Ticket',
		align    = 'top-right',
		elements = elements
	}, function(data, menu)
		buyTicket(data.current.id)
	end, function(data, menu)
		menu.close()
	end)
end)

exports('getLotteryConfig', function()
	return lotteryConfig
end)

function checkRobberyAvailable(k)
	local config = config.rob[k]
	local jobs = {}
	local p = promise:new()
	ESX.TriggerServerCallback('rob:getJobsCount',function(count)
		p:resolve(count)
	end)
	jobs = Citizen.Await(p)
	local militaryCount = 0
	if config.startCheck.militaryNeed.jobs[1] == 'all' then
		militaryCount = jobs.all or 0
	else
		for k, v in pairs(config.startCheck.militaryNeed.jobs) do
			militaryCount += jobs[v] or 0
		end
	end
	return militaryCount >= config.startCheck.militaryNeed.count
end

RegisterNetEvent('lottery:win', function(time)
	local thread = true
	SetTimeout(time * 1000, function()
		thread = false
	end)
	Citizen.CreateThread(function()
		while thread do
			Wait(1000)
			time = time - 1
			ESX.ShowMissionText(time .. 's forsat darid ta robbery ra start konid!')
		end
	end)
end)

exports('getLotteryRobbery', function(id)
	local returnData = {}
	local robConfig = exports['sun-robbery']:getConfig()
	for k, v in pairs(robConfig) do
		if not v.disabled and v.lotteryId == id then
			table.insert(returnData, v.label .. '('.. v.startCheck.pointNeed ..' Point)')
		end
	end

	return returnData
end)