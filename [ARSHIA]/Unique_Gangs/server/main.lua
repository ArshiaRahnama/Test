

ESX = nil
local Gangs = {}
local RegisteredGangs = {}
local TempGangs = {}
local cooldown = {}

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

function GetGang(gang)
	for i=1, #RegisteredGangs, 1 do
		if RegisteredGangs[i] == gang then
			local gn = {}
			gn.name = gang
			gn.account = 'gang_' .. string.lower(gn.name)
			return gn
		end
	end
end

Send_log = function(source, msg)
	if msg == nil then return end
	local identifier
	local discord   = ""
	local playerip
    for k,v in ipairs(GetPlayerIdentifiers(source))do
		if string.sub(v, 1, string.len("steam:")) == "steam:" then
			identifier = v
		elseif string.sub(v, 1, string.len("discord:")) == "discord:" then
			discord = v
		elseif string.sub(v, 1, string.len("ip:")) == "ip:" then
			playerip = v
		end
    end
    discord = discord:gsub('discord:','')
    identifier = identifier:gsub('steam:','')
	TriggerEvent('DiscordBot:ToDiscord', 'gangs', GetPlayerName(source), msg .. "Discord : <@!"..discord..">",'user', true, source, false)
end

AddEventHandler('playerDropped', function()

    _source = source

    if cooldown[_source] then
      cooldown[_source] = nil
    end

end)

MySQL.ready(function()
	local result = MySQL.Sync.fetchAll('SELECT * FROM gangs', {})

	for i=1, #result, 1 do
		print('Gang '.. result[i].name .. ' Load Shod')
		Gangs[result[i].name]        	= result[i]
		Gangs[result[i].name].grades 	= {}
		RegisteredGangs[i] 				= result[i].name
		Gangs[result[i].name].vehicles 	= {}
		exports.oxmysql:execute('SELECT * FROM owned_vehicles WHERE owner = @owner',{
			['@owner'] = result[i].name
		}, function(vehResult)
			for j=1, #vehResult do
				Gangs[result[i].name].vehicles[j] = json.decode(vehResult[j].vehicle)
			end
		end)
	end

 	local result2 = MySQL.Sync.fetchAll('SELECT * FROM gang_grades', {})

 	for i=1, #result2, 1 do
		Gangs[result2[i].gang_name].grades[tonumber(result2[i].grade)] = result2[i]
	end

	local data = MySQL.Sync.fetchAll('SELECT * FROM gangs_data', {})
	for i=1, #data, 1 do
		Gangs[data[i].gang_name].webhookboss = data[i].webhookboss
		Gangs[data[i].gang_name].webhookveh  = data[i].webhookveh
		Gangs[data[i].gang_name].webhookinv = data[i].webhookinv
		Gangs[data[i].gang_name].webhookmoney = data[i].webhookmoney
		Gangs[data[i].gang_name].logo = data[i].logo
		Gangs[data[i].gang_name].slot = data[i].slot
		Gangs[data[i].gang_name].bulletproof = data[i].bulletproof
		Gangs[data[i].gang_name].price = data[i].price
		Gangs[data[i].gang_name].lockpick = data[i].lockpick
		Gangs[data[i].gang_name].logpower = data[i].logpower
		Gangs[data[i].gang_name].armory_access = data[i].armory_access
		Gangs[data[i].gang_name].invite_access = data[i].invite_access
		Gangs[data[i].gang_name].garage_access = data[i].garage_access
		Gangs[data[i].gang_name].heli_access = data[i].heli_access
		Gangs[data[i].gang_name].boat_access = data[i].boat_access
		Gangs[data[i].gang_name].vest_access = data[i].vest_access
		Gangs[data[i].gang_name].blip_sprite = data[i].blip_sprite
		Gangs[data[i].gang_name].gps_color = data[i].gps_color
		Gangs[data[i].gang_name].vip = data[i].vip
	end
end)

RegisterServerEvent('gangs:acceptinv')
AddEventHandler('gangs:acceptinv', function(gang, grade)
	local xPlayer = ESX.GetPlayerFromId(source)
	xPlayer.setGang(gang, grade)

end)

RegisterServerEvent('gangs:registerGang')
AddEventHandler('gangs:registerGang', function(name, expire)

	local xPlayer = ESX.GetPlayerFromId(source)
	if xPlayer.permission_level >= 10 then

		local found = false

		local gangName = ESX.FirstToUpper(name)

		for i=1, #RegisteredGangs, 1 do
			if RegisteredGangs[i] == gangName then
				found = true
				break
			end
		end

		if not found then
			table.insert(TempGangs, {gang = gangName, expire = expire})
			TriggerClientEvent('esx:showNotification', source, '~h~~b~Gang : ~y~' ..gangName.. ' ~b~Add Shod!\nHala ~y~/savegangs~b~ Ra Bezanid')
		else
			TriggerClientEvent('esx:showNotification', source, '~r~~h~Yek Gang Ba Esme ~y~' ..gangName.. '~r~ Vojood Darad!')
		end

	else

	end

end)

AddEventHandler('gangs:IsGangRegistered', function(gang, cb)
	cb(IsGangRegistered(gang))
end)

function IsGangRegistered(gang)
	for i=1, #RegisteredGangs, 1 do
		if string.lower(RegisteredGangs[i]) == string.lower(gang) then
			return true
		end
	end
	return false
end

RegisterServerEvent('gangs:saveGangs')
AddEventHandler('gangs:saveGangs', function()
	local xPlayer = ESX.GetPlayerFromId(source)
	if xPlayer.permission_level >= 10 then

	for j=1, #TempGangs, 1 do
		table.insert(RegisteredGangs, TempGangs[j].gang)

		Gangs[TempGangs[j].gang] 			= {}
		Gangs[TempGangs[j].gang].label      = 'gang'
		Gangs[TempGangs[j].gang].name      	= TempGangs[j].gang
		Gangs[TempGangs[j].gang].grades 	= {}
		Gangs[TempGangs[j].gang].vehicles 	= {}
		Gangs[TempGangs[j].gang].price 	= 9000
		Gangs[TempGangs[j].gang].invite_access = 12
        Gangs[TempGangs[j].gang].armory_access = 2
		Gangs[TempGangs[j].gang].garage_access = 1
		Gangs[TempGangs[j].gang].heli_access = 3
		Gangs[TempGangs[j].gang].boat_access = 2
		Gangs[TempGangs[j].gang].vest_access = 1
		Gangs[TempGangs[j].gang].blip_sprite = 378
		Gangs[TempGangs[j].gang].gps_color = 1
		Gangs[TempGangs[j].gang].vip = 0

		TriggerEvent('esx_addoninventory:addGang', 	GetGang(TempGangs[j].gang).account)
		TriggerEvent('esx_datastore:addGang', 		GetGang(TempGangs[j].gang).account)

		local ranks = {'Rank1','Rank2','Rank3','Rank4','Rank5','Rank6','Rank7','Rank8','Rank9','Rank10','Rank11','Rank12','Rank13'}

		TriggerEvent('essentialmode:addGang', TempGangs[j].gang, ranks)
		TriggerEvent('gangaccount:addGang', TempGangs[j].gang)

		MySQL.Async.execute('INSERT INTO `gangs` (`name`, `label`) VALUES (@name, @label)', {
			['@name'] 		= TempGangs[j].gang,
			['@label']    = 'gang',
		}, function(e)

		end)
		for i=1, 13, 1 do
			Gangs[TempGangs[j].gang].grades[i] 				= {}
			Gangs[TempGangs[j].gang].grades[i].gang_name 	= TempGangs[j].gang
			Gangs[TempGangs[j].gang].grades[i].grade 		= i
			Gangs[TempGangs[j].gang].grades[i].name 		= 'Rank' .. i
			Gangs[TempGangs[j].gang].grades[i].label 		= ranks[i]
			Gangs[TempGangs[j].gang].grades[i].salary 		= 400 * i
			Gangs[TempGangs[j].gang].grades[i].skin_male 	= '[]'
			Gangs[TempGangs[j].gang].grades[i].skin_female 	= '[]'
			Gangs[TempGangs[j].gang].grades[i].inventorys 	= '[]'
			Gangs[TempGangs[j].gang].grades[i].boats 	    = '[]'
			Gangs[TempGangs[j].gang].grades[i].helis    	= '[]'
			Gangs[TempGangs[j].gang].grades[i].vehicles 	= '[]'
			Gangs[TempGangs[j].gang].grades[i].crafting 	= 0

			MySQL.Async.execute('INSERT INTO `gang_grades` (`gang_name`, `grade`, `name`, `label`, `salary`, `skin_male`, `skin_female`, `inventorys`, `boats`, `helis`, `vehicles`, `crafting`) VALUES (@gang_name, @grade, @name, @label, @salary, @skin_male, @skin_female, @inventorys, @boats, @helis, @vehicles, @crafting)', {
				['@gang_name'] 	 = TempGangs[j].gang,
				['@grade']    	 = i,
				['@name'] 		 = 'Rank '..i,
				['@label']       = ranks[i],
				['@salary'] 	 = 400 * i,
				['@skin_male']   = '[]',
				['@skin_female'] = '[]',
				['@inventorys']  = '[]',
				['@boats']       = '[]',
				['@helis']       = '[]',
				['@vehicles']    = '[]',
				['@crafting']    = 0,
			}, function(e)

			end)
		end

		MySQL.Async.execute('INSERT INTO `gang_account` (`name`, `label`, `shared`) VALUES (@name, @label, @shared)', {
			['@name'] 	  = 'gang_'..string.lower(TempGangs[j].gang),
			['@label']    = 'gang',
			['@shared']   = 1,
		}, function(e)

		end)
		MySQL.Async.execute('INSERT INTO `gang_account_data` (`gang_name`, `money`, `dirty_money`, `owner`) VALUES (@gang_name, @money, @dirty_money, @owner)', {
			['@gang_name'] 	 = 'gang_'..string.lower(TempGangs[j].gang),
			['@money']    	 = 0,
			['@dirty_money'] = 0,
			['@owner']   	 = nil,
		}, function(e)

		end)
		MySQL.Async.execute('INSERT INTO `datastore_data` (`name`, `owner`, `data`) VALUES (@name, @owner, @data)', {
			['@name'] 		= 'gang_'..string.lower(TempGangs[j].gang),
			['@owner']   	= nil,
			['@data'] 		= '[]'
		}, function(e)

		end)
		MySQL.Async.execute('INSERT INTO `datastore` (`name`, `label`, `shared`) VALUES (@name, @label, @shared)', {
			['@name'] 		= 'gang_'..string.lower(TempGangs[j].gang),
			['@label']    	= 'gang',
			['@shared']   	= 1
		}, function(e)

		end)
		MySQL.Async.execute('INSERT INTO `addon_inventory` (`name`, `label`, `shared`) VALUES (@name, @label, @shared)', {
			['@name'] 		= 'gang_'..string.lower(TempGangs[j].gang),
			['@label']    	= 'gang',
			['@shared']   	= 1
		}, function(e)

		end)
		MySQL.Async.execute('INSERT INTO `gangs_data` (`gang_name`, `vehicles`, `vehprop`, `expire_time`) VALUES (@gang_name, @vehicles, @vehprop, (NOW() + INTERVAL @time DAY))', {
			['@gang_name'] 		= TempGangs[j].gang,
			['@vehicles']		= '[]',
			['@vehprop']		= '[]',
			['@time']			= TempGangs[j].expire
		}, function(e)

		end)

		TriggerClientEvent('esx:showNotification', source, '~h~~b~Gang ~y~' .. TempGangs[j].gang .. '~b~ Save Shod!')
	end
	TempGangs = {}
		else

	end
end)

RegisterServerEvent('gangs:changeGangData')
AddEventHandler('gangs:changeGangData', function(name, data, pos)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(source)
	if xPlayer.permission_level >= 10 then

	local gang = name
	local data = data


	if data == 'blip' then
		blip(name,pos,function(callback)
			if callback then
				TriggerClientEvent('esx:showNotification', _source, 'Shoma Mahal '..data..' Gange '..gang..' Set Kardid!')
				msg = "```css\n[ Name : " ..GetPlayerName(_source).. " | ID : " .. _source .. "]\n[ Change Gang Blip ]\n[ Gangname : " .. gang .. " ]\n[ Pos : " .. json.encode(pos) .. " ]\n```"
				Send_log(_source, msg)
			end
		end)
	elseif data == 'armory' then
		armory(name,pos,function(callback)
			if callback then
				TriggerClientEvent('esx:showNotification', _source, 'Shoma Mahal '..data..' Gange '..gang..' Set Kardid!')
				msg = "```css\n[ Name : " ..GetPlayerName(_source).. " | ID : " .. _source .. "]\n[ Change Gang armory ]\n[ Gangname : " .. gang .. " ]\n[ Pos : " .. json.encode(pos) .. " ]\n```"
				Send_log(_source, msg)
			end
		end)
	elseif data == 'locker' then
		locker(name,pos,function(callback)
			if callback then
				TriggerClientEvent('esx:showNotification', _source, 'Shoma Mahal '..data..' Gange '..gang..' Set Kardid!')
				msg = "```css\n[ Name : " ..GetPlayerName(_source).. " | ID : " .. _source .. "]\n[ Change Gang locker ]\n[ Gangname : " .. gang .. " ]\n[ Pos : " .. json.encode(pos) .. " ]\n```"
				Send_log(_source, msg)
			end
		end)
	elseif data == 'boss' then
		boss(name,pos,function(callback)
			if callback then
				TriggerClientEvent('esx:showNotification', _source, 'Shoma Mahal '..data..' Gange '..gang..' Set Kardid!')
				msg = "```css\n[ Name : " ..GetPlayerName(_source).. " | ID : " .. _source .. "]\n[ Change Gang boss ]\n[ Gangname : " .. gang .. " ]\n[ Pos : " .. json.encode(pos) .. " ]\n```"
				Send_log(_source, msg)
			end
		end)
	elseif data == 'veh' then
		veh(name,pos,function(callback)
			if callback then
				TriggerClientEvent('esx:showNotification', _source, 'Shoma Mahal '..data..' Gange '..gang..' Set Kardid!')
				msg = "```css\n[ Name : " ..GetPlayerName(_source).. " | ID : " .. _source .. "]\n[ Change Gang veh ]\n[ Gangname : " .. gang .. " ]\n[ Pos : " .. json.encode(pos) .. " ]\n```"
				Send_log(_source, msg)
			end
		end)
	elseif data == 'vehdel' then
		vehdel(name,pos,function(callback)
			if callback then
				TriggerClientEvent('esx:showNotification', _source, 'Shoma Mahal '..data..' Gange '..gang..' Set Kardid!')
				msg = "```css\n[ Name : " ..GetPlayerName(_source).. " | ID : " .. _source .. "]\n[ Change Gang vehdel ]\n[ Gangname : " .. gang .. " ]\n[ Pos : " .. json.encode(pos) .. " ]\n```"
				Send_log(_source, msg)
			end
		end)
	elseif data == 'vehspawn' then
		vehspawn(name,pos,function(callback)
			if callback then
				TriggerClientEvent('esx:showNotification', _source, 'Shoma Mahal '..data..' Gange '..gang..' Set Kardid!')
				msg = "```css\n[ Name : " ..GetPlayerName(_source).. " | ID : " .. _source .. "]\n[ Change Gang vehspawn ]\n[ Gangname : " .. gang .. " ]\n[ Pos : " .. json.encode(pos) .. " ]\n```"
				Send_log(_source, msg)
			end
		end)
	elseif data == 'boat' then
		boat(name,pos,function(callback)
			if callback then
				TriggerClientEvent('esx:showNotification', _source, 'Shoma Mahal '..data..' Gange '..gang..' Set Kardid!')
				msg = "```css\n[ Name : " ..GetPlayerName(_source).. " | ID : " .. _source .. "]\n[ Change Gang boat ]\n[ Gangname : " .. gang .. " ]\n[ Pos : " .. json.encode(pos) .. " ]\n```"
				Send_log(_source, msg)
			end
		end)
	elseif data == 'boatdel' then
		boatdel(name,pos,function(callback)
			if callback then
				TriggerClientEvent('esx:showNotification', _source, 'Shoma Mahal '..data..' Gange '..gang..' Set Kardid!')
				msg = "```css\n[ Name : " ..GetPlayerName(_source).. " | ID : " .. _source .. "]\n[ Change Gang boatdel ]\n[ Gangname : " .. gang .. " ]\n[ Pos : " .. json.encode(pos) .. " ]\n```"
				Send_log(_source, msg)
			end
		end)
	elseif data == 'boatspawn' then
		boatspawn(name,pos,function(callback)
			if callback then
				TriggerClientEvent('esx:showNotification', _source, 'Shoma Mahal '..data..' Gange '..gang..' Set Kardid!')
				msg = "```css\n[ Name : " ..GetPlayerName(_source).. " | ID : " .. _source .. "]\n[ Change Gang boatspawn ]\n[ Gangname : " .. gang .. " ]\n[ Pos : " .. json.encode(pos) .. " ]\n```"
				Send_log(_source, msg)
			end
		end)
	elseif data == 'heli' then
		heli(name,pos,function(callback)
			if callback then
				TriggerClientEvent('esx:showNotification', _source, 'Shoma Mahal '..data..' Gange '..gang..' Set Kardid!')
				msg = "```css\n[ Name : " ..GetPlayerName(_source).. " | ID : " .. _source .. "]\n[ Change Gang heli ]\n[ Gangname : " .. gang .. " ]\n[ heli : " .. json.encode(pos) .. " ]\n```"
				Send_log(_source, msg)
			end
		end)
	elseif data == 'helidel' then
		helidel(name,pos,function(callback)
			if callback then
				TriggerClientEvent('esx:showNotification', _source, 'Shoma Mahal '..data..' Gange '..gang..' Gang!')
				msg = "```css\n[ Name : " ..GetPlayerName(_source).. " | ID : " .. _source .. "]\n[ Change Gang helidel ]\n[ Gangname : " .. gang .. " ]\n[ Pos : " .. json.encode(pos) .. " ]\n```"
				Send_log(_source, msg)
			end
		end)
	elseif data == 'helimodel' then
		helimodel(name,pos,function(callback)
			if callback then
				TriggerClientEvent('esx:showNotification', _source, 'Shoma '..data..' Gange '..gang..' Change Kardid Be '..callback.. '!')
				msg = "```css\n[ Name : " ..GetPlayerName(_source).. " | ID : " .. _source .. "]\n[ Change Gang helimodel ]\n[ Gangname : " .. gang .. " ]\n[ helimodel : " .. callback .. " ]\n```"
				Send_log(_source, msg)
			end
		end)
	elseif data == 'helispawn' then
		helispawn(name,pos,function(callback)
			if callback then
				TriggerClientEvent('esx:showNotification', _source, 'Shoma Mahal '..data..' Gange '..gang..' Set Kardid!')
				msg = "```css\n[ Name : " ..GetPlayerName(_source).. " | ID : " .. _source .. "]\n[ Change Gang helispawn ]\n[ Gangname : " .. gang .. " ]\n[ Pos : " .. json.encode(pos) .. " ]\n```"
				Send_log(_source, msg)
			end
		end)
	elseif data == 'expire' then
		expire(name,pos,function(callback)
			if callback then
				TriggerClientEvent('esx:showNotification', _source, 'Shoma Zaman '..data..' Gange '..gang..' Ra Set Kardid Be '..tonumber(pos).. ' Rooz!')
				msg = "```css\n[ Name : " ..GetPlayerName(_source).. " | ID : " .. _source .. "]\n[ Change Gang expire ]\n[ Gangname : " .. gang .. " ]\n[ expire : " .. tonumber(pos) .. " ]\n```"
				Send_log(_source, msg)
			end
		end)
	elseif data == 'search' then
		search(name,function(callback)
			if callback then
				TriggerClientEvent('esx:showNotification', _source, 'Shoma Dastresi Search Ra Baraye Gang '..gang..' Be Halat '.. callback .. ' Dar Avardid')
				msg = "```css\n[ Name : " ..GetPlayerName(_source).. " | ID : " .. _source .. "]\n[ Change Gang search ]\n[ Gangname : " .. gang .. " ]\n[ search : " .. callback .. " ]\n```"
				Send_log(_source, msg)
			end
		end)
	elseif data == 'lockpick' then
		lockpick(name,function(callback)
			if callback then
				TriggerClientEvent('esx:showNotification', _source, 'Shoma Dastresi LockPick Ra Baraye Gang '..gang..' Be Halat '.. callback .. ' Dar Avardid')
				msg = "```css\n[ Name : " ..GetPlayerName(_source).. " | ID : " .. _source .. "]\n[ Change Gang lockpick ]\n[ Gangname : " .. gang .. " ]\n[ lockpick : " .. callback .. " ]\n```"
				Send_log(_source, msg)
			end
		end)
	elseif data == 'bulletproof' then
		bulletproof(name,pos,function(callback)
			if callback then
				TriggerClientEvent('esx:showNotification', _source, 'Shoma Meghdar Armor Gang '..gang..' Ra Be Halat %'.. callback .. ' Dar Avardid')
				msg = "```css\n[ Name : " ..GetPlayerName(_source).. " | ID : " .. _source .. "]\n[ Change Gang Bulletproof ]\n[ Gangname : " .. gang .. " ]\n[ Armor : %" .. callback .. " ]\n```"
				Send_log(_source, msg)
			end
		end)
	elseif data == 'price' then
		price(name,pos,function(callback)
			if callback then
				TriggerClientEvent('esx:showNotification', _source, 'Shoma Gheymat Armor Gang '..gang..' Ra Be ~g~$'.. callback .. '~w~ Dar Avardid')
				msg = "```css\n[ Name : " ..GetPlayerName(_source).. " | ID : " .. _source .. "]\n[ Change Gang Price Armor ]\n[ Gangname : " .. gang .. " ]\n[ Price :" .. callback .. " ]\n```"
				Send_log(_source, msg)
			end
		end)
	elseif data == 'gps' then
		gps(name,function(callback)
		if callback then
			TriggerClientEvent('esx:showNotification', _source, 'Shoma GPS Ra Baraye Gang '..gang..' Be Halat '.. callback .. ' Dar Avardid')
			msg = "```css\n[ Name : " ..GetPlayerName(_source).. " | ID : " .. _source .. "]\n[ Change Gang GPS ]\n[ Gangname : " .. gang .. " ]\n[ GPS : " .. callback .. " ]\n```"
			Send_log(_source, msg)
			end
	    end)
	elseif data == 'log' then
		tlog(name,function(callback)
			if callback then
				TriggerClientEvent('esx:showNotification', _source, 'Shoma Dastresi Gozashtan Log Ra Baraye Gang '..gang..' Be Halat '.. callback .. ' Dar Avardid')
				msg = "```css\n[ Name : " ..GetPlayerName(_source).. " | ID : " .. _source .. "]\n[ Change Gang Log ]\n[ Gangname : " .. gang .. " ]\n[ Log : " .. callback .. " ]\n```"
				Send_log(_source, msg)
			end
		end)
	elseif data == 'vip' then
		vip(name,function(callback)
			if callback then
				TriggerClientEvent('esx:showNotification', _source, 'Shoma Dastresi Haye VIP Baraye Gang '..gang..' Be Halat '.. callback .. ' Dar Avardid')
				msg = "```css\n[ Name : " ..GetPlayerName(_source).. " | ID : " .. _source .. "]\n[ Change Gang VIP ]\n[ Gangname : " .. gang .. " ]\n[ Log : " .. callback .. " ]\n```"
				Send_log(_source, msg)
			end
		end)
	elseif data == 'slot' then
		slot(name,pos,function(callback)
			if callback then
				TriggerClientEvent('esx:showNotification', _source, 'Shoma Slot Gange '.. gang .. ' Ra Be '..callback..' Nafare Dar Avardid!')
				msg = "```css\n[ Name : " ..GetPlayerName(_source).. " | ID : " .. _source .. "]\n[ Change Gang Slot ]\n[ Gangname : " .. gang .. " ]\n[ Slot :" .. callback .. " ]\n```"
				Send_log(_source, msg)
			end
		end)
	end

	else

	end

end)

function heli(gang, pos, callback)
	MySQL.Async.execute('UPDATE gangs_data SET heli = @pos WHERE gang_name = @gang_name', {
		['@gang_name']      = gang,
		['@pos']  			= json.encode(pos)
	}, function(rowsChanged)
		if callback then
			callback(true)
		end
	end)
end

function helidel(gang, pos, callback)
	MySQL.Async.execute('UPDATE gangs_data SET helidel = @pos WHERE gang_name = @gang_name', {
		['@gang_name']      = gang,
		['@pos']  			= json.encode(pos)
	}, function(rowsChanged)
		if callback then
			callback(true)
		end
	end)
end

function helimodel(gang, helimodel, cb)
	exports.oxmysql:execute("UPDATE gangs_data SET helimodel = @helimodel WHERE gang_name = @gang_name",{
		["@gang_name"]	= gang,
		["@helimodel"]= helimodel
	})
	cb(helimodel)
end

function helispawn(gang, pos, callback)
	MySQL.Async.execute('UPDATE gangs_data SET helispawn = @pos WHERE gang_name = @gang_name', {
		['@gang_name']      = gang,
		['@pos']  			= json.encode(pos)
	}, function(rowsChanged)
		if callback then
			callback(true)
		end
	end)
end

function blip(gang, pos, callback)
	MySQL.Async.execute('UPDATE gangs_data SET blip = @pos WHERE gang_name = @gang_name', {
		['@gang_name']      = gang,
		['@pos']  			= json.encode(pos)
	}, function(rowsChanged)
		if callback then
			callback(true)
		end
	end)
end

function armory(gang, pos, callback)
	MySQL.Async.execute('UPDATE gangs_data SET armory = @pos WHERE gang_name = @gang_name', {
		['@gang_name']      = gang,
		['@pos']  			= json.encode(pos)
	}, function(rowsChanged)
		if callback then
			callback(true)
		end
	end)
end

function locker(gang, pos, callback)
	MySQL.Async.execute('UPDATE gangs_data SET locker = @pos WHERE gang_name = @gang_name', {
		['@gang_name']      = gang,
		['@pos']  			= json.encode(pos)
	}, function(rowsChanged)
		if callback then
			callback(true)
		end
	end)
end

function boss(gang, pos, callback)
	MySQL.Async.execute('UPDATE gangs_data SET boss = @pos WHERE gang_name = @gang_name', {
		['@gang_name']      = gang,
		['@pos']  			= json.encode(pos)
	}, function(rowsChanged)
		if callback then
			callback(true)
		end
	end)
end

function veh(gang, pos, callback)
	MySQL.Async.execute('UPDATE gangs_data SET veh = @pos WHERE gang_name = @gang_name', {
		['@gang_name']      = gang,
		['@pos']  			= json.encode(pos)
	}, function(rowsChanged)
		if callback then
			callback(true)
		end
	end)
end

function vehdel(gang, pos, callback)
	MySQL.Async.execute('UPDATE gangs_data SET vehdel = @pos WHERE gang_name = @gang_name', {
		['@gang_name']      = gang,
		['@pos']  			= json.encode(pos)
	}, function(rowsChanged)
		if callback then
			callback(true)
		end
	end)
end

function vehspawn(gang, pos, callback)
	MySQL.Async.execute('UPDATE gangs_data SET vehspawn = @pos WHERE gang_name = @gang_name', {
		['@gang_name']      = gang,
		['@pos']  			= json.encode(pos)
	}, function(rowsChanged)
		if callback then
			callback(true)
		end
	end)
end

function boat(gang, pos, callback)
	MySQL.Async.execute('UPDATE gangs_data SET boat = @pos WHERE gang_name = @gang_name', {
		['@gang_name']      = gang,
		['@pos']  			= json.encode(pos)
	}, function(rowsChanged)
		if callback then
			callback(true)
		end
	end)
end

function boatdel(gang, pos, callback)
	MySQL.Async.execute('UPDATE gangs_data SET boatdel = @pos WHERE gang_name = @gang_name', {
		['@gang_name']      = gang,
		['@pos']  			= json.encode(pos)
	}, function(rowsChanged)
		if callback then
			callback(true)
		end
	end)
end

function boatspawn(gang, pos, callback)
	MySQL.Async.execute('UPDATE gangs_data SET boatspawn = @pos WHERE gang_name = @gang_name', {
		['@gang_name']      = gang,
		['@pos']  			= json.encode(pos)
	}, function(rowsChanged)
		if callback then
			callback(true)
		end
	end)
end

function expire(gang, time, callback)
	MySQL.Async.execute('UPDATE gangs_data SET expire_time = (NOW() + INTERVAL @time DAY) WHERE gang_name = @gang_name', {
		['@gang_name']      = gang,
		['@time']			= time
	}, function(rowsChanged)
		if callback then
			callback(true)
		end
	end)
end

function search(gang, cb)
	exports.oxmysql:scalar("SELECT search FROM gangs_data WHERE gang_name = @gang_name",{
		["gang_name"] = gang
	}, function(ok
	)
		if result then
			exports.oxmysql:execute("UPDATE gangs_data SET search = FALSE WHERE gang_name = @gang_name",{
				["@gang_name"]	= gang
			})
			cb("~r~Gheyre Faal~w~")
		else
			exports.oxmysql:execute("UPDATE gangs_data SET search = TRUE WHERE gang_name = @gang_name",{
				["@gang_name"]	= gang
			})
			cb("~g~Faal~w~")
		end
	end)
end

function lockpick(gang, cb)
	exports.oxmysql:scalar("SELECT lockpick FROM gangs_data WHERE gang_name = @gang_name",{
		["gang_name"] = gang
	}, function(result)
		if tonumber(result) == 1 then
			exports.oxmysql:execute("UPDATE gangs_data SET lockpick = 0 WHERE gang_name = @gang_name",{
				["@gang_name"]	= gang
			})
			Gangs[gang].lockpick = 0
		cb("~r~Gheyre Faal~w~")
		else
			exports.oxmysql:execute("UPDATE gangs_data SET lockpick = 1 WHERE gang_name = @gang_name",{
				["@gang_name"]	= gang
			})
			Gangs[gang].lockpick = 1
		cb("~g~Faal~w~")
		end
	end)
end

function tlog(gang, cb)
	exports.oxmysql:scalar("SELECT logpower FROM gangs_data WHERE gang_name = @gang_name",{
		["gang_name"] = gang
	}, function(result)
		if tonumber(result) == 1 then
			exports.oxmysql:execute("UPDATE gangs_data SET logpower = 0 WHERE gang_name = @gang_name",{
				["@gang_name"]	= gang
			})
			Gangs[gang].logpower = 0
		cb("~r~Gheyre Faal~w~")
		else
			exports.oxmysql:execute("UPDATE gangs_data SET logpower = 1 WHERE gang_name = @gang_name",{
				["@gang_name"]	= gang
			})
			Gangs[gang].logpower = 1
		cb("~g~Faal~w~")
		end
	end)
end

function gps(gang, cb)
	exports.oxmysql:scalar("SELECT gps FROM gangs_data WHERE gang_name = @gang_name",{
		["gang_name"] = gang
	}, function(result)
		if tonumber(result) == 1 then
			exports.oxmysql:execute("UPDATE gangs_data SET gps = 0 WHERE gang_name = @gang_name",{
				["@gang_name"]	= gang
			})
			Gangs[gang].gps = 0
		cb("~r~Gheyre Faal~w~")
		else
			exports.oxmysql:execute("UPDATE gangs_data SET gps = 1 WHERE gang_name = @gang_name",{
				["@gang_name"]	= gang
			})
			Gangs[gang].gps = 1
		cb("~g~Faal~w~")
		end
	end)
end

function vip(gang, cb)
	exports.oxmysql:scalar("SELECT vip FROM gangs_data WHERE gang_name = @gang_name",{
		["gang_name"] = gang
	}, function(result)
		if tonumber(result) == 1 then
			exports.oxmysql:execute("UPDATE gangs_data SET vip = 0 WHERE gang_name = @gang_name",{
				["@gang_name"]	= gang
			})
			Gangs[gang].vip = 0
		cb("~r~Gheyre Faal~w~")
		else
			exports.oxmysql:execute("UPDATE gangs_data SET vip = 1 WHERE gang_name = @gang_name",{
				["@gang_name"]	= gang
			})
			Gangs[gang].vip = 1
		cb("~g~Faal~w~")
		end
	end)
end

function slot(gang, slot, cb)
	exports.oxmysql:execute("UPDATE gangs_data SET slot = @slot WHERE gang_name = @gang_name",{
		["@gang_name"]	= gang,
		["@slot"]= slot
	})
	cb(slot)
end

function bulletproof(gang, bulletproof, cb)
	exports.oxmysql:execute("UPDATE gangs_data SET bulletproof = @bulletproof WHERE gang_name = @gang_name",{
		["@gang_name"]	= gang,
		["@bulletproof"]= bulletproof
	})
	cb(bulletproof)
end

function price(gang, price, cb)
	exports.oxmysql:execute("UPDATE gangs_data SET price = @price WHERE gang_name = @gang_name",{
		["@gang_name"]	= gang,
		["@price"]= price
	})
	cb(price)
end

AddEventHandler('gangs:getGangs', function(cb)
	cb(RegisteredSocieties)
end)

AddEventHandler('gangs:getGang', function(name, cb)
	cb(GetGang(name))
end)

RegisterServerEvent('gangs:withdrawMoney')
AddEventHandler('gangs:withdrawMoney', function(gangName, amount)
	local xPlayer = ESX.GetPlayerFromId(source)
	local gang = GetGang(gangName)
	amount = ESX.Math.Round(tonumber(amount))

 	if xPlayer.gang.name ~= gang.name then
		print(('gangs: %s attempted to call withdrawMoney!'):format(xPlayer.identifier))
		return
	end

 	TriggerEvent('gangaccount:getGangAccount', gang.account, function(account)
		if amount > 0 and account.money >= amount then
			account.removeMoney(amount)
			xPlayer.addMoney(amount)
			TriggerClientEvent('esx:showNotification', xPlayer.source, _U('have_withdrawn', ESX.Math.GroupDigits(amount)))

			bardashtArray = {
					{
						["color"] = "5020550",
						["title"] = "Bardasht Bodje",
						["description"] = "Player: **"..xPlayer.name.."**\nZaman: **"..os.date('%Y-%m-%d %H:%M:%S').."**",
						["fields"] = {
							{
								["name"] = "Meghdar: ",
								["value"] = "**"..ESX.Math.GroupDigits(amount).."$**"
							},
							{
								["name"] = "Gang: ",
								["value"] = "**"..gangName.."**"
							}
						},
						["footer"] = {
						["text"] = "Log System",
						["icon_url"] = "https://cdn.discordapp.com/attachments/801538325600403466/802826232797331456/discordicon.png",
						}
					}
				}
			TriggerEvent('DiscordBot:ToDiscord', 'gangs', gangName, bardashtArray, 'system', source, false, false)

			if Gangs[xPlayer.gang.name].logpower ~= 0 then
				sendtodiscord(source, Gangs[xPlayer.gang.name].webhookmoney,'Log '..gangName..' Logger','> Bardasht Bodje','Meghdar : '.. ESX.Math.GroupDigits(amount) .. '$\nEsm IC Player : '..xPlayer.name .. '\nEsm OOC Player : '.. GetPlayerName(xPlayer.source))
			end
		else
			TriggerClientEvent('esx:showNotification', xPlayer.source, _U('invalid_amount'))
		end
	end)
end)

RegisterServerEvent('gangs:depositMoney')
AddEventHandler('gangs:depositMoney', function(gang, amount)
	local xPlayer = ESX.GetPlayerFromId(source)
	local gang = GetGang(gang)
	amount = ESX.Math.Round(tonumber(amount))

 	if xPlayer.gang.name ~= gang.name then
		print(('gangs: %s attempted to call depositMoney!'):format(xPlayer.identifier))
		return
	end

 	if amount > 0 and xPlayer.money >= amount then
		TriggerEvent('gangaccount:getGangAccount', gang.account, function(account)
			xPlayer.removeMoney(amount)
			account.addMoney(amount)
		end)
 		TriggerClientEvent('esx:showNotification', xPlayer.source, _U('have_deposited', ESX.Math.GroupDigits(amount)))

		gozashtanArray = {
					{
						["color"] = "5020550",
						["title"] = "Gozashtan Bodje",
						["description"] = "Player: **"..xPlayer.name.."**\nZaman: **"..os.date('%Y-%m-%d %H:%M:%S').."**",
						["fields"] = {
							{
								["name"] = "Meghdar: ",
								["value"] = "**"..ESX.Math.GroupDigits(amount).."$**"
							},
							{
								["name"] = "Gang: ",
								["value"] = "**"..gang.name.."**"
							}
						},
						["footer"] = {
						["text"] = "Log System",
						["icon_url"] = "https://cdn.discordapp.com/attachments/801538325600403466/802826232797331456/discordicon.png",
						}
					}
				}
		TriggerEvent('DiscordBot:ToDiscord', 'gangs', gang.name, gozashtanArray, 'system', source, false, false)

		if Gangs[xPlayer.gang.name].logpower ~= 0 then
				sendtodiscord(source, Gangs[xPlayer.gang.name].webhookmoney,'log '..gang.name..' Logger','> Gozashtan Bodje','Meghdar : '.. ESX.Math.GroupDigits(amount) .. '$\nEsm IC Player : '..xPlayer.name .. '\nEsm OOC Player : '.. GetPlayerName(xPlayer.source), true)
			end
	else
		TriggerClientEvent('esx:showNotification', xPlayer.source, _U('invalid_amount'))
	end
end)

RegisterServerEvent('gangs:saveOutfit')
AddEventHandler('gangs:saveOutfit', function(grade, skin)
	local xPlayer = ESX.GetPlayerFromId(source)
	local xPlayers = ESX.GetPlayers()
	for i=1, #xPlayers, 1 do
		local gangMember = ESX.GetPlayerFromId(xPlayers[i])

		if gangMember.gang.name == xPlayer.gang.name and gangMember.gang.grade_label == grade then
			gangMember.changeGangSkin(skin)
		end
	end

	if skin.sex == 0 then
		MySQL.Async.execute('UPDATE gang_grades SET skin_male = @skin WHERE (gang_name = @gang AND label = @grade)',{
			['skin']  = json.encode(skin),
			['gang']  = xPlayer.gang.name,
			['grade'] = grade
		})
		TriggerEvent('ChangeGangSkin', xPlayer.gang.name, grade, true, skin)
	else
		MySQL.Async.execute('UPDATE gang_grades SET skin_female = @skin WHERE (gang_name = @gang AND label = @grade)',{
			['skin']  = json.encode(skin),
			['gang']  = xPlayer.gang.name,
			['grade'] = grade
		})
		TriggerEvent('ChangeGangSkin', xPlayer.gang.name, grade, false, skin)

	end
end)

RegisterServerEvent('gangs:getFromInventory')
AddEventHandler('gangs:getFromInventory', function(type2, item, count)
	local _source      = source
	local xPlayer      = ESX.GetPlayerFromId(_source)
	local gangaccount  = GetGang(xPlayer.gang.name)

	if type2 == 'item_standard' then

		local sourceItem = xPlayer.getInventoryItem(item)

		TriggerEvent('esx_addoninventory:getSharedInventory', gangaccount.account, function(inventory)
			local inventoryItem = inventory.getItem(item)


			if count > 0 and inventoryItem.count >= count then


				if sourceItem.limit ~= -1 and (sourceItem.count + count) > sourceItem.limit then
					TriggerClientEvent('esx:showNotification', _source, _U('player_cannot_hold'))
				else
					inventory.removeItem(item, count)
					xPlayer.addInventoryItem(item, count)

			if Gangs[xPlayer.gang.name].logpower ~= 0 then
				sendtodiscord(source, Gangs[xPlayer.gang.name].webhookinv,'log '..xPlayer.gang.name..' Logger','> Bardasht Item','Item Name : '.. inventoryItem.label .. '\nTedad : '..count..'\nEsm IC Player : '..xPlayer.name .. '\nEsm OOC Player : '.. GetPlayerName(xPlayer.source))
			end

				local details = {source = source, icname = xPlayer.name, gang = xPlayer.gang.name, type = "Bardasht", name = item, count = count}
				exports.ScriptPack:GangLog(details)
					TriggerClientEvent('esx:showNotification', _source, 'Shoma '..count..' '..inventoryItem.label..' Az Gang Bardashtid')
				end
			else
				TriggerClientEvent('esx:showNotification', _source, _U('not_enough_in_property'))
			end
		end)

	elseif type2 == 'item_weapon' then
		local weapon = xPlayer.hasWeapon(item)

		if not weapon then
			TriggerEvent('esx_datastore:getSharedDataStore', gangaccount.account, function(store)
				local storeWeapons = store.get('weapons') or {}
				local weaponName   = nil
				local ammo         = nil
				local components   = {}

				for i=1, #storeWeapons, 1 do
					if storeWeapons[i].name == item then
						weaponName = storeWeapons[i].name
						ammo       = storeWeapons[i].ammo
						components = storeWeapons[i].components
						table.remove(storeWeapons, i)
						break
					end
				end

				store.set('weapons', storeWeapons)
				xPlayer.addWeapon(weaponName, ammo)

				if type(components) == 'table' then
					for k,v in pairs(components) do
						xPlayer.addWeaponComponent(weaponName, v)

					end
				else
					xPlayer.addWeaponComponent(weaponName, components)
				end
			if Gangs[xPlayer.gang.name].logpower ~= 0 then
				sendtodiscord(source, Gangs[xPlayer.gang.name].webhookinv,'log '..xPlayer.gang.name..' Logger','> Bardasht Weapon','Weapon Name : '.. ESX.GetWeaponLabel(weaponName) .. '\nTedad Tir: '..ammo..'\nEsm IC Player : '..xPlayer.name .. '\nEsm OOC Player : '.. GetPlayerName(xPlayer.source))
			end

				local details = {source = source, icname = xPlayer.name, gang = xPlayer.gang.name, type = "Bardasht", name = weaponName, count = ammo}
				exports.ScriptPack:GangLog(details)
			end)
		else
			TriggerClientEvent('esx:showNotification', _source, 'Shoma Dar hale Hazer in Aslahe ro darid')
		end

	end

end)

RegisterServerEvent('gangs:addToInventory')
AddEventHandler('gangs:addToInventory', function(type, item, count)
	local _source      = source

	if cooldown[_source] then
		if os.time() - cooldown[_source] <= 2 then
		  TriggerClientEvent('esx:showNotification', source, '~h~Lotfan spam nakonid!')
		  return
		else
		  cooldown[_source] = os.time()
		end
	else
	cooldown[_source] = os.time()
	end

	local xPlayer      = ESX.GetPlayerFromId(_source)
	local gangaccount  = GetGang(xPlayer.gang.name)

	if type == 'item_standard' then
		local playerItem = xPlayer.getInventoryItem(item)
		local playerItemCount = playerItem.count
		local isvorod = false
		if string.sub(playerItem.name, 1, 7) == "CarKey|" and playerItemCount ~= 0 then
			isvorod = false
		else
			isvorod = true
		end

		if isvorod then
			if playerItemCount >= count and count > 0 then
				TriggerEvent('esx_addoninventory:getSharedInventory', gangaccount.account, function(inventory)
					xPlayer.removeInventoryItem(item, count)
					inventory.addItem(item, count)
					if Gangs[xPlayer.gang.name].logpower ~= 0 then
					sendtodiscord(source, Gangs[xPlayer.gang.name].webhookinv,'log '..xPlayer.gang.name..' Logger','> Gozashtan Item','Item Name : '.. playerItem.label .. '\nTedad : '..count..'\nEsm IC Player : '..xPlayer.name .. '\nEsm OOC Player : '.. GetPlayerName(xPlayer.source), true)
				end

					local details = {source = source, icname = xPlayer.name, gang = xPlayer.gang.name, type = "Gozasht", name = item, count = count}
					exports.ScriptPack:GangLog(details)
					TriggerClientEvent('esx:showNotification', _source, 'Shoma '..count..' ta '.. inventory.getItem(item).label .. ' Dakhel Gang Gozashtid')
				end)
			else
				TriggerClientEvent('esx:showNotification', _source, _U('invalid_quantity'))
			end
		end

	elseif type == 'item_weapon' then
		local weapon = xPlayer. hasWeapon(item)

		if weapon then
			TriggerEvent('esx_datastore:getSharedDataStore', gangaccount.account, function(store)
				local storeWeapons = store.get('weapons') or {}


				table.insert(storeWeapons, {
					name = item,
					ammo = weapon.ammo,
					components = weapon.components
				})

				store.set('weapons', storeWeapons)
				xPlayer.removeWeapon(item)

				if Gangs[xPlayer.gang.name].logpower ~= 0 then
					sendtodiscord(source, Gangs[xPlayer.gang.name].webhookinv,'log '..xPlayer.gang.name..' Logger','> Gozashtan Weapon','Weapon Name : '.. ESX.GetWeaponLabel(item) .. '\nTedad Tir: '..weapon.ammo..'\nEsm IC Player : '..xPlayer.name .. '\nEsm OOC Player : '.. GetPlayerName(xPlayer.source), true)
				end

				local details = {source = source, icname = xPlayer.name, gang = xPlayer.gang.name, type = "Gozasht", name = item, count = weapon.ammo}
				exports.ScriptPack:GangLog(details)
			end)
		else


		end
	end
end)

ESX.RegisterServerCallback('gangs:removeArmoryWeapon', function(source, cb, weaponName, station)
	local gang = GetGang(station)
	local xPlayer = ESX.GetPlayerFromId(source)
	if xPlayer.gang.name ~= gang.name then
		print(('gangs: %s attempted to removeArmoryWeapon!'):format(xPlayer.identifier))
		return
	end

	if not xPlayer.hasWeapon(weaponName) then
		xPlayer.addWeapon(weaponName, 250)
		TriggerEvent('esx_datastore:getSharedDataStore', gang.account, function(store)

			local weapons = store.get('weapons')

			if weapons == nil then
				weapons = {}
			end

			local foundWeapon = false

			for i=1, #weapons, 1 do
				if weapons[i].name == weaponName then
					weapons[i].count = (weapons[i].count > 0 and weapons[i].count - 1 or 0)
					foundWeapon = true
				end
			end

			if not foundWeapon then
				table.insert(weapons, {
					name  = weaponName,
					count = 0
				})
			end

			store.set('weapons', weapons)

			if Gangs[xPlayer.gang.name].logpower ~= 0 then
				sendtodiscord(source, Gangs[xPlayer.gang.name].webhookinv,'log '..xPlayer.gang.name..' Logger','> Bardasht Weapon','Weapon Name : '..ESX.GetWeaponLabel(weaponName).. '\nTedad Tir: '..count..'\nEsm IC Player : '..xPlayer.name .. '\nEsm OOC Player : '.. GetPlayerName(xPlayer.source))
			end

			local details = {source = source, icname = xPlayer.name, gang = xPlayer.gang.name, type = "Bardasht", name = weaponName, count = "1"}
			exports.ScriptPack:GangLog(details)


			cb()

		end)
	else
		TriggerClientEvent('esx:showNotification', xPlayer.source, '~r~Shoma in Aslahe ro Darid!')
	end

end)

ESX.RegisterServerCallback('gangs:getGangData', function(source, cb, gang)
	if ESX.DoesGangExist(gang,13) then
		MySQL.Async.fetchAll('SELECT * FROM gangs_data WHERE gang_name = @gang_name AND `expire_time` > NOW()', {
			['@gang_name'] = gang
		}, function(data)
			cb(data[1])
		end)
	else
		cb(nil)
	end
end)

ESX.RegisterServerCallback('gangs:getGangMoney', function(source, cb, gang)
	local gang = GetGang(gang)

 	if gang then
		TriggerEvent('gangaccount:getGangAccount', gang.account, function(account)
			cb(account.money)
		end)
	else
		cb(0)
	end
end)

ESX.RegisterServerCallback('gangs:getPropertyInventory', function(source, cb, station)
	local xPlayer    = ESX.GetPlayerFromId(source)
	local dirty_money = 0
	local items      = {}
	local weapons    = {}
	local account    = {}
	local gang 		 = GetGang(station)
	local nameg = xPlayer.gang.name
	local gradeg = xPlayer.gang.grade
	if xPlayer.gang.name ~= gang.name then
		print(('gangs: %s attempted to call getStock without permission!'):format(xPlayer.identifier))
		return
	end

	local itemgang       = (Gangs[nameg].grades[tonumber(gradeg)].inventorys)


	TriggerEvent('esx_addoninventory:getSharedInventory', gang.account, function(inventory)

		items = inventory.items

	end)

	TriggerEvent('esx_datastore:getSharedDataStore', gang.account, function(store)
		weapons = store.get('weapons') or {}

	end)

	cb({
		dirty_money = dirty_money,
		items      = items,
		weapons    = weapons
	})
end)

ESX.RegisterServerCallback('gangs:getPropertyInventory2', function(source, cb, station)
	local xPlayer    = ESX.GetPlayerFromId(source)
	local dirty_money = 0
	local items      = {}
	local weapons    = {}
	local account    = {}
	local gang2 		 = GetGang(xPlayer.gang.name)
	local nameg = xPlayer.gang.name
	local gradeg = xPlayer.gang.grade

	if nameg ~= gang2.name then
		print(('gangs: %s attempted to call getStock without permission!'):format(xPlayer.identifier))
		return
	end

	local itemgang       = (Gangs[nameg].grades[tonumber(gradeg)].inventorys)
	local item = {}
	local weapons = {}

	TriggerEvent('esx_addoninventory:getSharedInventory', gang2.account, function(inventory)

		if inventory then
			for k,v in pairs(inventory.items) do
				local invitem = v.name
				local testd   = v.count
				local itlab   = v.label
				for t,item in pairs(json.decode(itemgang)) do
					if item.name == invitem and item.state then
						table.insert(items, {
							count = testd,
							name = invitem,
							label = itlab
						})
					end
				end
			end
		end
	end)

	TriggerEvent('esx_datastore:getSharedDataStore', gang2.account, function(store)
		weapons2 = store.get('weapons')

		if weapons2 then
			for k,v in pairs(weapons2) do
				local invitem = v
				for t,weapon in pairs(json.decode(itemgang)) do
					if weapon.name == invitem.name and weapon.state then
						table.insert(weapons, {
							name = invitem.name,
							ammo = invitem.ammo,
						})
					end
				end
			end
		end
	end)

	cb({
		dirty_money = dirty_money,
		items      = items,
		weapons    = weapons
	})
end)

RegisterNetEvent('gangs:buy')
AddEventHandler('gangs:buy', function(weaponName, station)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	local gang = GetGang(station)
	local price = Config.SellableWeapon[weaponName]
	if xPlayer.gang.name ~= gang.name then
		print(('gangs: %s attempted to buy!'):format(xPlayer.identifier))
		return
	end

	if not xPlayer.canAfford(price) then
		TriggerClientEvent('esx:showNotification', xPlayer.source, '~r~Be andaze Kafi Pool nadarid!')
		return
	end

	xPlayer.payAny(price)

	TriggerEvent('esx_datastore:getSharedDataStore', gang.account, function(store)
		local storeWeapons = store.get('weapons') or {}

		table.insert(storeWeapons, {
			name = weaponName,
			ammo = 255
		})

		store.set('weapons', storeWeapons)
		TriggerClientEvent('esx:showNotification', xPlayer.source, '~g~Aslahe Ba movafaqiyat be Armory Gang Ezafe shod.')

	end)

end)

ESX.RegisterServerCallback('gangs:sethook', function(source, cb, webhook, dbname)
	local _source, hook = source, webhook
	local xPlayer = ESX.GetPlayerFromId(_source)
	databasename = dbname
	if xPlayer.gang.name == "nogang" then
		cb(false)

		return
	end

	if xPlayer.gang.grade >= 12 then
    MySQL.Async.execute('UPDATE gangs_data SET '..databasename..' = @hook WHERE gang_name = @gang_name', {
		['@gang_name']      = xPlayer.gang.name,
		['@hook']  			= hook
	}, function(rowsChanged)
		if databasename == 'webhookboss' then
			Gangs[xPlayer.gang.name].webhookboss = hook
			sendtodiscord(source, hook,'Log '..xPlayer.gang.name ..' Logger','Web Hook Boss Action Gang Set Shod','Enjoy :)')
		elseif databasename == 'webhookveh' then
			Gangs[xPlayer.gang.name].webhookveh = hook
			sendtodiscord(source, hook,'Log '..xPlayer.gang.name ..' Logger','Web Hook Mashin Ha Set Shod','Enjoy :)')
		elseif databasename == 'webhookinv' then
			Gangs[xPlayer.gang.name].webhookinv = hook
			sendtodiscord(source, hook,'Log '..xPlayer.gang.name ..' Logger','Web Hook Inventory Gang Set Shod','Enjoy :)')
		elseif databasename == 'webhookmoney' then
			Gangs[xPlayer.gang.name].webhookmoney = hook
			sendtodiscord(source, hook,'Log '..xPlayer.gang.name ..' Logger','Web Hook Pool Gang Set Shod','Enjoy :)')
		end


	end)

	cb(true)
	else
		cb(false)

	end

end)

ESX.RegisterServerCallback('gangs:setinvperm', function(source, cb, perm)
	local _source, perm = source, perm
	local xPlayer = ESX.GetPlayerFromId(_source)

	if xPlayer.gang.name == "nogang" then
		cb(false)

		return
	end

	if xPlayer.gang.grade >= 12 then
    MySQL.Async.execute('UPDATE gangs_data SET invite_access = @perm WHERE gang_name = @gang_name', {
		['@gang_name']      = xPlayer.gang.name,
		['@perm']  			= perm
	}, function(rowsChanged)
		Gangs[xPlayer.gang.name].invite_access = perm
		local aPlayers = ESX.GetPlayers()
			for i=1, #aPlayers, 1 do
				local GangMember = ESX.GetPlayerFromId(aPlayers[i])

				if GangMember.gang.name == xPlayer.gang.name then
					GangMember.setGang(xPlayer.gang.name, GangMember.gang.grade)
				end

			end
	end)
	if Gangs[xPlayer.gang.name].logpower ~= 0 then
		sendtodiscord(source, Gangs[xPlayer.gang.name].webhookboss,'Log '..xPlayer.gang.name..' Logger','Permission Invite Be '..tostring(perm)..' Taghir Kard','Enjoy :)')
	end
	cb(true)
	else
		cb(false)


	end

end)

ESX.RegisterServerCallback('gangs:setganglogo', function(source, cb, logo)
	local _source, logo = source, logo
	local xPlayer = ESX.GetPlayerFromId(_source)

	if xPlayer.gang.grade >= 12 then
		MySQL.Async.execute('UPDATE gangs_data SET logo = @logo WHERE gang_name = @gang_name', {
			['@gang_name']      = xPlayer.gang.name,
			['@logo']  			= logo
		}, function(rowsChanged)
			Gangs[xPlayer.gang.name].logo = logo
				local aPlayers = ESX.GetPlayers()
				for i=1, #aPlayers, 1 do
					local GangMember = ESX.GetPlayerFromId(aPlayers[i])

					if GangMember.gang.name == xPlayer.gang.name then
						GangMember.setGang(xPlayer.gang.name, GangMember.gang.grade)
					end

				end

		end)
		TriggerClientEvent('gangs:UpdateHudIcon', source)
		sendtodiscord(source, Gangs[xPlayer.gang.name].webhookboss,'Log Gang Logger','Axs Gang Be '..tostring(logo)..' Taghir Kard','Enjoy :)')
		cb(true)
    end

end)

ESX.RegisterServerCallback('gangs:GetGangIcon', function(source, cb)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	local logo = MySQL.Sync.fetchAll('SELECT `logo` FROM `gangs_data` WHERE gang_name = @gang_name', {
		['@gang_name']  = xPlayer.gang.name
	})
	logo = logo[1].logo
	cb(logo)
end)

ESX.RegisterServerCallback('gangs:getEmployees', function(source, cb, gang)

	MySQL.Async.fetchAll('SELECT playerName, identifier, gang, gang_grade FROM users WHERE gang = @gang ORDER BY gang_grade DESC', {
		['@gang'] = gang
	}, function (result)
		local employees = {}

		for i=1, #result, 1 do
			table.insert(employees, {
				name       = result[i].playerName,
				identifier = result[i].identifier,
				gang = {
					name        = result[i].gang,
					label       = Gangs[result[i].gang].label,
					grade       = result[i].gang_grade,
					grade_name  = Gangs[result[i].gang].grades[tonumber(result[i].gang_grade)].name,
					grade_label = Gangs[result[i].gang].grades[tonumber(result[i].gang_grade)].label
				}
			})
		end

		cb(employees)
	end)
end)

ESX.RegisterServerCallback('gangs:getGang', function(source, cb, gang)
	local gang    = json.decode(json.encode(Gangs[gang]))
	local grades = {}

 	for k,v in pairs(gang.grades) do
		table.insert(grades, v)
	end

 	table.sort(grades, function(a, b)
		return a.grade < b.grade
	end)

	gang.grades = grades

 	cb(gang)
end)

ESX.RegisterServerCallback('gangs:setGang', function(source, cb, identifier, gang, grade, type)
	local xPlayer = ESX.GetPlayerFromId(source)

	local isBoss = xPlayer.gang.grade >= Gangs[xPlayer.gang.name].invite_access

 	if xPlayer.gang.grade >= 10 then
		local xTarget = ESX.GetPlayerFromIdentifier(identifier)

 		if xTarget then


 			if type == 'hire' then

				TriggerClientEvent('gangs:itemac',xTarget.source,gang)
			elseif type == 'promote' then
				if grade ~= 13 then

					TriggerClientEvent('esx:showNotification', xTarget.source, _U('you_have_been_promoted'))
					xTarget.setGang(gang, grade)
				else
					TriggerClientEvent('chatMessage', source, "[SYSTEM]", {tonumber(255), tonumber(0), tonumber(0)}, " ^0Shoma Nemitavanid Rank Boss Dahid")
				end

			elseif type == 'fire' then
				xTarget.setGang(gang, grade)
				TriggerClientEvent('esx:showNotification', xTarget.source, _U('you_have_been_fired', xTarget.gang.label))
			end

 			cb()
		else
			MySQL.Async.execute('UPDATE users SET gang = @gang, gang_grade = @gang_grade WHERE identifier = @identifier', {
				['@gang']        = gang,
				['@gang_grade']  = grade,
				['@identifier'] 	 = identifier
			}, function(rowsChanged)
				cb()
			end)
		end
	else
		print(('gangs: %s attempted to setGang'):format(xPlayer.identifier))
		cb()
	end
end)

ESX.RegisterServerCallback('gangs:setGangSalary', function(source, cb, gang, grade, salary)
	local isBoss = isPlayerBoss(source, gang)
	local identifier = GetPlayerIdentifier(source, 0)

 	if isBoss then
		if salary <= Config.MaxSalary then
			MySQL.Async.execute('UPDATE gang_grades SET salary = @salary WHERE gang_name = @gang_name AND grade = @grade', {
				['@salary']   = salary,
				['@gang_name'] = gang.name,
				['@grade']    = grade
			}, function(rowsChanged)
				Gangs[gang.name].grades[tonumber(grade)].salary = salary
				local xPlayers = ESX.GetPlayers()

 				for i=1, #xPlayers, 1 do
					local xPlayer = ESX.GetPlayerFromId(xPlayers[i])

 					if xPlayer.gang.name == gang.name and xPlayer.gang.grade == grade then
						xPlayer.setGang(gang, grade)
					end
				end

 				cb()
			end)
		else
			print(('gangs: %s attempted to setGangSalary Log config limit!'):format(identifier))
			cb()
		end
	else
		print(('gangs: %s Talash Kard Ta Hoghogh Gang Ra Taghir Dahad'):format(identifier))
		cb()
	end
end)

ESX.RegisterServerCallback('gangs:renameGrade', function(source, cb, grade, name)
	local _source, grade, name = source, grade, name
	local xPlayer = ESX.GetPlayerFromId(_source)

	if xPlayer.gang.grade >= 10 then
		if ESX.SetGangGrade(xPlayer.gang.name, grade, name) then
			if Gangs[xPlayer.gang.name] then Gangs[xPlayer.gang.name].grades[grade].label = name end

			local xPlayers = ESX.GetPlayers()

			for i=1, #xPlayers, 1 do
				local GangMember = ESX.GetPlayerFromId(xPlayers[i])

				if GangMember.gang.name == xPlayer.gang.name and GangMember.gang.grade == grade then
					GangMember.setGang(xPlayer.gang.name, grade)
				end

			end

			cb(true)
		else
			cb(false)
			TriggerClientEvent('chatMessage', -1, "[SYSTEM]", {255, 0, 0}, " ^0Khatayi dar avaz kardan esm gang grade shoma pish amad be developer etelaa dahid!")
		end
	end

end)

ESX.RegisterServerCallback('gangs:setGangVehiclePerm', function(source, cb, gangname, rank, model, status)
    local xPlayer = ESX.GetPlayerFromId(source)
    local identifier = GetPlayerIdentifier(source, 0)
	local vehicles2 = {}
    if isPlayerBoss(source, gangname) then
        MySQL.Async.fetchAll('SELECT vehicles FROM gang_grades WHERE gang_name = @gang_name AND grade = @grade', {
            ['@gang_name'] = gangname,
            ['@grade'] = rank
        }, function(result)
            if result[1] then
                local vehicles = json.decode(result[1].vehicles) or {}
                local found = false

                for i, veh in ipairs(vehicles) do
                    if veh.model == model then
                        veh.status = status



                        found = true
                        break
                    end
                end
				if not found then
					table.insert(vehicles, {model = model, status = status})
				end
                MySQL.Async.execute('UPDATE gang_grades SET vehicles = @vehicles WHERE gang_name = @gang_name AND grade = @grade', {
                    ['@vehicles'] = json.encode(vehicles),
                    ['@gang_name'] = gangname,
                    ['@grade'] = rank
                }, function(rowsChanged)
                    if rowsChanged > 0 then
                        cb(true)
                    else
                        cb(false)
                    end
                end)
            else
                cb(false)
            end
        end)
    else
        print(('gangs:setGangVehiclePerm: %s attempted to change vehicle permissions without permission!'):format(identifier))
        cb(false)
    end
end)

ESX.RegisterServerCallback('gangs:setGangGarageAccess', function(source, cb, gang, garage_access)
	local isBoss = isPlayerBoss(source, gang)
	local identifier = GetPlayerIdentifier(source, 0)
	local xPlayer = ESX.GetPlayerFromId(source)

 	if isBoss then
		MySQL.Async.execute('UPDATE gangs_data SET garage_access = @garage_access WHERE gang_name = @gang_name', {
			['@garage_access']   = garage_access,
			['@gang_name'] = gang.name
		}, function(rowsChanged)
			if Gangs[xPlayer.gang.name].logpower ~= 0 then
				sendtodiscord(source, Gangs[xPlayer.gang.name].webhookboss,'Log '..gang.name..' Logger','Permission Garage Be '..tostring(garage_access)..' Taghir Kard','Enjoy :)')
			end
 			cb()
		end)
	else
		print(('gangs: %s Talash Kard Ta Rank Access Garage Ra Taghir Dahad'):format(identifier))
		cb()
	end
end)

ESX.RegisterServerCallback('gangs:setGangHeliAccess', function(source, cb, gang, heli_access)
	local isBoss = isPlayerBoss(source, gang)
	local identifier = GetPlayerIdentifier(source, 0)
	local xPlayer = ESX.GetPlayerFromId(source)

 	if isBoss then
		MySQL.Async.execute('UPDATE gangs_data SET heli_access = @heli_access WHERE gang_name = @gang_name', {
			['@heli_access']   = heli_access,
			['@gang_name'] = gang.name
		}, function(rowsChanged)
			if Gangs[xPlayer.gang.name].logpower ~= 0 then
				sendtodiscord(source, Gangs[xPlayer.gang.name].webhookboss,'Log '..gang.name..' Logger','Permission Heli Be '..tostring(heli_access)..' Taghir Kard','Enjoy :)')
			end
 			cb()
		end)
	else
		print(('gangs: %s Talash Kard Ta Rank Access Heli Ra Taghir Dahad'):format(identifier))
		cb()
	end
end)

ESX.RegisterServerCallback('gangs:setGangBoatAccess', function(source, cb, gang, boat_access)
	local isBoss = isPlayerBoss(source, gang)
	local identifier = GetPlayerIdentifier(source, 0)
	local xPlayer = ESX.GetPlayerFromId(source)

 	if isBoss then
		MySQL.Async.execute('UPDATE gangs_data SET boat_access = @boat_access WHERE gang_name = @gang_name', {
			['@boat_access']   = boat_access,
			['@gang_name'] = gang.name
		}, function(rowsChanged)
			if Gangs[xPlayer.gang.name].logpower ~= 0 then
				sendtodiscord(source, Gangs[xPlayer.gang.name].webhookboss,'Log '..gang.name..' Logger','Permission Boat Be '..tostring(boat_access)..' Taghir Kard','Enjoy :)')
			end
 			cb()
		end)
	else
		print(('gangs: %s Talash Kard Ta Rank Access Boat Ra Taghir Dahad'):format(identifier))
		cb()
	end
end)

ESX.RegisterServerCallback('gangs:setBlip', function(source, cb, gang, blip_sprite)
	local isBoss = isPlayerBoss(source, gang)
	local identifier = GetPlayerIdentifier(source, 0)
	local xPlayer = ESX.GetPlayerFromId(source)

 	if isBoss then
		MySQL.Async.execute('UPDATE gangs_data SET blip_sprite = @blip_sprite WHERE gang_name = @gang_name', {
			['@blip_sprite']   = blip_sprite,
			['@gang_name'] = gang.name
		}, function(rowsChanged)

			local aPlayers = ESX.GetPlayers()
				for i=1, #aPlayers, 1 do
					local GangMember = ESX.GetPlayerFromId(aPlayers[i])

					if GangMember.gang.name == xPlayer.gang.name then
						GangMember.setGang(xPlayer.gang.name, GangMember.gang.grade)
					end

				end

			if Gangs[xPlayer.gang.name].logpower ~= 0 then
				sendtodiscord(source, Gangs[xPlayer.gang.name].webhookboss,'Log '..gang.name..' Logger','Icon Roye Map Gang Be '..tostring(blip_sprite)..' Taghir Kard','Enjoy :)')
			end
 			cb()
		end)
	end
end)

ESX.RegisterServerCallback('gangs:setBlipColor', function(source, cb, gang, blip_color)
	local isBoss = isPlayerBoss(source, gang)
	local identifier = GetPlayerIdentifier(source, 0)
	local xPlayer = ESX.GetPlayerFromId(source)

 	if isBoss then
		MySQL.Async.execute('UPDATE gangs_data SET blip_color = @blip_color WHERE gang_name = @gang_name', {
			['@blip_color']   = blip_color,
			['@gang_name'] = gang.name
		}, function(rowsChanged)

			local aPlayers = ESX.GetPlayers()
				for i=1, #aPlayers, 1 do
					local GangMember = ESX.GetPlayerFromId(aPlayers[i])

					if GangMember.gang.name == xPlayer.gang.name then
						GangMember.setGang(xPlayer.gang.name, GangMember.gang.grade)
					end

				end

			if Gangs[xPlayer.gang.name].logpower ~= 0 then
				sendtodiscord(source, Gangs[xPlayer.gang.name].webhookboss,'Log '..gang.name..' Logger','Rang Icon Roye Map Gang Be '..tostring(blip_color)..' Taghir Kard','Enjoy :)')
			end
 			cb()
		end)
	end
end)

ESX.RegisterServerCallback('gangs:setGpsColor', function(source, cb, gang, gps_color)
	local isBoss = isPlayerBoss(source, gang)
	local identifier = GetPlayerIdentifier(source, 0)
	local xPlayer = ESX.GetPlayerFromId(source)

 	if isBoss then
		MySQL.Async.execute('UPDATE gangs_data SET gps_color = @gps_color WHERE gang_name = @gang_name', {
			['@gps_color']   = gps_color,
			['@gang_name'] = gang.name
		}, function(rowsChanged)

			local aPlayers = ESX.GetPlayers()
				for i=1, #aPlayers, 1 do
					local GangMember = ESX.GetPlayerFromId(aPlayers[i])

					if GangMember.gang.name == xPlayer.gang.name then
						GangMember.setGang(xPlayer.gang.name, GangMember.gang.grade)
					end

				end
			if Gangs[xPlayer.gang.name].logpower ~= 0 then
				sendtodiscord(source, Gangs[xPlayer.gang.name].webhookboss,'Log '..gang.name..' Logger','Rang GPS Be '..tostring(gps_color)..' Taghir Kard','Enjoy :)')
			end
 			cb()
		end)
	end
end)

ESX.RegisterServerCallback('gangs:setGangArmoryAccess', function(source, cb, gang, armory_access)
	local isBoss = isPlayerBoss(source, gang)
	local identifier = GetPlayerIdentifier(source, 0)
	local xPlayer = ESX.GetPlayerFromId(source)

 	if isBoss then
		MySQL.Async.execute('UPDATE gangs_data SET armory_access = @armory_access WHERE gang_name = @gang_name', {
			['@armory_access']   = armory_access,
			['@gang_name'] = gang.name
		}, function(rowsChanged)

			if Gangs[xPlayer.gang.name].logpower ~= 0 then
				sendtodiscord(source, Gangs[xPlayer.gang.name].webhookboss,'Log '..gang.name..' Logger','Permission Armory Be '..tostring(armory_access)..' Taghir Kard','Enjoy :)')
			end
			cb()
		end)
	else
		print(('gangs: %s Talash Kard Ta Rank Access Armory Ra Taghir Dahad'):format(identifier))
		cb()
	end
end)

ESX.RegisterServerCallback('gangs:setGangVestAccess', function(source, cb, gang, vest_access)
	local isBoss = isPlayerBoss(source, gang)
	local identifier = GetPlayerIdentifier(source, 0)
	local xPlayer = ESX.GetPlayerFromId(source)

 	if isBoss then
		MySQL.Async.execute('UPDATE gangs_data SET vest_access = @vest_access WHERE gang_name = @gang_name', {
			['@vest_access']   = vest_access,
			['@gang_name'] = gang.name
		}, function(rowsChanged)


			if Gangs[xPlayer.gang.name].logpower ~= 0 then
				sendtodiscord(source, Gangs[xPlayer.gang.name].webhookboss,'Log '..gang.name..' Logger','Permission Vest Be '..tostring(vest_access)..' Taghir Kard','Enjoy :)')
			end
			cb()
		end)
	else
		print(('gangs: %s Talash Kard Ta Rank Access Vest Ra Taghir Dahad'):format(identifier))
		cb()
	end
end)

ESX.RegisterServerCallback('gangs:getOnlinePlayers', function(source, cb)
	local xPlayers = ESX.GetPlayers()
	local players  = {}
	ppcoords = ESX.GetPlayerFromId(source).coords

 	for i=1, #xPlayers, 1 do
		local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
		table.insert(players, {
			source     = xPlayer.source,
			identifier = xPlayer.identifier,
			name       = xPlayer.name,
			gang       = xPlayer.gang,
			coords     = xPlayer.coords,

		})
	end

 	cb(players, ppcoords)
end)

ESX.RegisterServerCallback('gangs:getVehiclesInGarage', function(source, cb, gangName)
	cb(Gangs[gangName].vehicles)
end)

ESX.RegisterServerCallback('gangs:isBoss', function(source, cb, gang)
	cb(isPlayerBoss(source, gang))
end)

ESX.RegisterServerCallback('gang:getGrades', function(source, cb, plate)
	local xPlayer = ESX.GetPlayerFromId(source)
	  cb(Gangs[xPlayer.gang.name].grades)
end)

function isPlayerBoss(playerId, gang)
	local xPlayer = ESX.GetPlayerFromId(playerId)

 	if xPlayer.gang.label == 'gang' then
		return true
	else
		print(('gangs: %s attempted open a gang boss menu!'):format(xPlayer.identifier))
		return false
	end
end

function sendtodiscord(source, hook,footer1,footer2,text, green)
	local source = source
	local gname
	local xPlayer = ESX.GetPlayerFromId(source)
	local embed = {}
	local ganglogo
	local colordis = 0
	gname = xPlayer.gang.name

	local chekganglogo =  Gangs[gname].logo

	if chekganglogo ~= 'defaultlogo' then
		ganglogo = chekganglogo
	else
		ganglogo = 'https://s8.uupload.ir/files/newlogo_185.png'
	end
	if green then
		colordis = 65280
	else
		colordis = 15548997
	end
    embed = {
        {
            ["color"] = colordis,
            ["title"] = footer2,
			["fields"] = {
					{
						["name"] = "Etelaat: ",
						["value"] = text
					}
				},
            ["footer"] = {
                ["text"] = "Log System",
				["icon_url"] = "https://s8.uupload.ir/files/newlogo_185.png",
            },

        }
    }

    PerformHttpRequest(hook,
    function(err, text, headers) end, 'POST', json.encode({username = "Gang Log", embeds = embed, avatar_url = ganglogo}), { ['Content-Type'] = 'application/json' })
end

function ban(source, Reason, Reason2)

end

ESX.RegisterServerCallback('gangs:vehicles', function(source, cb, vehicle)
	exports.oxmysql:execute('SELECT * FROM owned_vehicles WHERE owner = @owner',{
		['@owner'] = result[i].name
	}, function(vehResult)
		for j=1, #vehResult do
			cb(name.vehicles)
		end
	end)
end)

ESX.RegisterServerCallback('gangs:SetPermData',function(source, cb, gang, grade, sitem, il, plate2, vehllabel)
	local xp = ESX.GetPlayerFromId(source)
	local source = source
	local acctrue
	if xp.gang.name ~= gang or xp.gang.grade < 10 then

		cb()
		return
	end
	if il == 'inventorys' then
		local status = true
		local gitems = json.decode(Gangs[gang].grades[tonumber(grade)].inventorys)
		local found = false
		if gitems ~= nil then
			for i, item in ipairs(gitems) do
				if string.lower(item.name) == string.lower(sitem) then
					if item.state == false then
						table.insert(gitems,{
							name = item.name,
							state = true

						})
						table.remove(gitems, i)
						found = true
						acctrue = true
						break
					else
						table.insert(gitems,{
							name = item.name,
							state = false

						})
						table.remove(gitems, i)
						found = true
						acctrue = false
						break
					end
				end
			end
		else
			gitems = {}
		end
		if found == false then
			table.insert(gitems,{
				name = sitem,
				state = true
			})
			acctrue = true
		end
		Gangs[gang].grades[tonumber(grade)].inventorys = json.encode(gitems)
		MySQL.update('UPDATE gang_grades SET inventorys = @items WHERE gang_name = @gang_name AND grade = @grade ', {
			['@items']   = json.encode(gitems),
			['@gang_name'] = gang,
			['@grade']    = grade
		}, function(rowsChanged)
			cb(true)
			local chekdastresi
			local green
			if Gangs[xp.gang.name].logpower ~= 0 then
				if acctrue == true then
					if string.sub(sitem, 1, string.len("WEAPON_")) == "WEAPON_" then
						chekdastresi = "IC Name: "..xp.name..'\nOOC Name: '..GetPlayerName(xp.source)..'\nID: '..xp.source..'\nDastrresi Weapon: **'..ESX.GetWeaponLabel(sitem)..'**\n Ra Be Rank: ('..grade..') Baz Kard'
						green = true
					else
						chekdastresi = "IC Name: "..xp.name..'\nOOC Name: '..GetPlayerName(xp.source)..'\nID: '..xp.source..'\nDastrresi Item: **'..ESX.GetItemLabel(sitem)..'**\n Ra Be Rank: ('..grade..') Baz Kard'
						green = true
					end
				else
					if string.sub(sitem, 1, string.len("WEAPON_")) == "WEAPON_" then
						chekdastresi = "IC Name: "..xp.name..'\nOOC Name: '..GetPlayerName(xp.source)..'\nID: '..xp.source..'\nDastrresi Weapon: **'..ESX.GetWeaponLabel(sitem)..'**\n Ra Be Rank: ('..grade..') Bast'
						green = false
					else
						chekdastresi = "IC Name: "..xp.name..'\nOOC Name: '..GetPlayerName(xp.source)..'\nID: '..xp.source..'\nDastrresi Item: **'..ESX.GetItemLabel(sitem)..'**\n Ra Be Rank: ('..grade..') Bast'
						green = false
					end
				end
				sendtodiscord(source, Gangs[gang].webhookboss,'Log'..gang..' Logger','Permission Inventory', chekdastresi, green)
			end
		end)
	elseif il == 'car' then
		local status = true
		local gitems = json.decode(Gangs[gang].grades[tonumber(grade)].vehicles)
		local found = false
		local carsdastresi = 0
		if gitems ~= nil then
			for i, item in ipairs(gitems) do

				if string.lower(item.name) == string.lower(sitem) and string.lower(item.plate) == string.lower(plate2) then
					if item.state == false then
						table.insert(gitems,{
							name = item.name,
							state = true,
							plate = plate2
						})
						table.remove(gitems, i)
						found = true
						carsdastresi = 1
						break
					else
						table.insert(gitems,{
							name = item.name,
							state = false,
							plate = plate2
						})
						table.remove(gitems, i)
						found = true
						carsdastresi = 0
						break
					end
				end
			end
		else
			gitems = {}
		end
		if found == false then
			table.insert(gitems,{
				name = sitem,
				state = true,
				plate = plate2
			})
			carsdastresi = 1
		end
		Gangs[gang].grades[tonumber(grade)].vehicles = json.encode(gitems)
		MySQL.update('UPDATE gang_grades SET vehicles = @vehicles WHERE gang_name = @gang_name AND grade = @grade', {
			['@vehicles']   = json.encode(gitems),
			['@gang_name'] = gang,
			['@grade']    = grade
		}, function(rowsChanged)
			cb(true)

			if Gangs[xp.gang.name].logpower ~= 0 then
				if carsdastresi == 1 then
					chekdastresi = "IC Name: " .. xp.name ..
								"\nOOC Name: " .. GetPlayerName(xp.source) ..
								"\nID: " .. xp.source ..
								"\nMashin: " .. vehllabel ..
								"\nPlate: " .. plate2 ..
								"\nRa Braye Ranke (" .. grade .. ") Baz Kard!"
					green = true
				else
					chekdastresi = "IC Name: " .. xp.name ..
								"\nOOC Name: " .. GetPlayerName(xp.source) ..
								"\nID: " .. xp.source ..
								"\nMashin: " .. vehllabel ..
								"\nPlate: " .. plate2 ..
								"\nRa Braye Ranke (" .. grade .. ") Bast!"
					green = false
				end
				sendtodiscord(source, Gangs[gang].webhookboss, 'Log reven' .. gang .. ' Logger', 'Permission Vehicles', chekdastresi, green)
			end




		end)

	elseif il == 'heli' then
		local status = true
		local helidastresi = 0
		local gitems2 = json.decode(Gangs[gang].grades[tonumber(grade)].helis)
		local found = false
		if gitems2 ~= nil then
			for i, item in ipairs(gitems2) do
				if string.lower(item.name) == string.lower(sitem) and string.lower(item.plate) == string.lower(plate2) then
					if item.state == false then
						table.insert(gitems2,{
							name = item.name,
							state = true,
							plate = plate2
						})
						table.remove(gitems2, i)
						found = true
						helidastresi = 1
						break
					else
						table.insert(gitems2,{
							name = item.name,
							state = false,
							plate = plate2
						})
						table.remove(gitems2, i)
						found = true
						helidastresi = 0
						break
					end
				end
			end
		else
			gitems2 = {}
		end
		if found == false then
			table.insert(gitems2,{
				name = sitem,
				state = true,
				plate = plate2

			})
			helidastresi = 1
		end
		Gangs[gang].grades[tonumber(grade)].helis = json.encode(gitems2)
		MySQL.update('UPDATE gang_grades SET helis = @helis WHERE gang_name = @gang_name AND grade = @grade', {
			['@helis']   = json.encode(gitems2),
			['@gang_name'] = gang,
			['@grade']    = grade
		}, function(rowsChanged)
			cb(true)

			if Gangs[xp.gang.name].logpower ~= 0 then
				if helidastresi == 1 then
					chekdastresi = "IC Name: " .. xp.name ..
								   "\nOOC Name: " .. GetPlayerName(xp.source) ..
								   "\nID: " .. xp.source ..
								   "\nHelicopter: " .. vehllabel ..
								   "\nPlate: " .. plate2 ..
								   "\nRa Braye Ranke (" .. grade .. ") Baz Kard!"
					green = true
				else
					chekdastresi = "IC Name: " .. xp.name ..
								   "\nOOC Name: " .. GetPlayerName(xp.source) ..
								   "\nID: " .. xp.source ..
								   "\nHelicopter: " .. vehllabel ..
								   "\nPlate: " .. plate2 ..
								   "\nRa Braye Ranke (" .. grade .. ") Bast!"
					green = false
				end
				sendtodiscord(source, Gangs[gang].webhookboss, 'Log reven' .. gang .. ' Logger', 'Permission Helis', chekdastresi, green)
			end

		end)

	elseif il == 'boat' then
		local status = true
		local boatdastresi = 0
		local gitems2 = json.decode(Gangs[gang].grades[tonumber(grade)].boats)
		local found = false
		if gitems2 ~= nil then
			for i, item in ipairs(gitems2) do
				if string.lower(item.name) == string.lower(sitem) and string.lower(item.plate) == string.lower(plate2) then
					if item.state == false then
						table.insert(gitems2,{
							name = item.name,
							state = true,
							plate = plate2
						})
						table.remove(gitems2, i)
						found = true
						boatdastresi = 1
						break
					else
						table.insert(gitems2,{
							name = item.name,
							state = false,
							plate = plate2
						})
						table.remove(gitems2, i)
						found = true
						boatdastresi = 0
						break
					end
				end
			end
		else
			gitems2 = {}
		end
		if found == false then
			table.insert(gitems2,{
				name = sitem,
				state = true,
				plate = plate2

			})
			boatdastresi = 1
		end
		Gangs[gang].grades[tonumber(grade)].boats = json.encode(gitems2)
		MySQL.update('UPDATE gang_grades SET boats = @boats WHERE gang_name = @gang_name AND grade = @grade', {
			['@boats']   = json.encode(gitems2),
			['@gang_name'] = gang,
			['@grade']    = grade
		}, function(rowsChanged)
			cb(true)

			if Gangs[xp.gang.name].logpower ~= 0 then
				if boatdastresi == 1 then
					chekdastresi = "IC Name: " .. xp.name ..
								   "\nOOC Name: " .. GetPlayerName(xp.source) ..
								   "\nID: " .. xp.source ..
								   "\nBoat: " .. vehllabel ..
								   "\nPlate: " .. plate2 ..
								   "\nRa Braye Ranke (" .. grade .. ") Baz Kard!"
					green = true
				else
					chekdastresi = "IC Name: " .. xp.name ..
								   "\nOOC Name: " .. GetPlayerName(xp.source) ..
								   "\nID: " .. xp.source ..
								   "\nBoat: " .. vehllabel ..
								   "\nPlate: " .. plate2 ..
								   "\nRa Braye Ranke (" .. grade .. ") Bast!"
					green = false
				end
				sendtodiscord(source, Gangs[gang].webhookboss, 'Log reven' .. gang .. ' Logger', 'Permission Boat', chekdastresi, green)
			end


		end)
	elseif il == 'craft' then
		local dastresi = nil
		local craft = json.decode(Gangs[gang].grades[tonumber(grade)].crafting)
		local found = false
		if craft ~= nil then


			if craft == 0 then
				dastresi = 1
				found = true
			else
				dastresi = 0
				found = true
			end


		else
			found = false
		end

		if found == false then
			dastresi = 1
		end
		Gangs[gang].grades[tonumber(grade)].crafting = dastresi
		MySQL.update('UPDATE gang_grades SET crafting = @crafting WHERE gang_name = @gang_name AND grade = @grade', {
			['@crafting']   = dastresi,
			['@gang_name'] = gang,
			['@grade']    = grade
		}, function(rowsChanged)
			cb(true)
			local chekdastresi
			local green
			if Gangs[xp.gang.name].logpower ~= 0 then
				if dastresi == 1 then
					chekdastresi = "IC Name: "..xp.name..'\nOOC Name: '..GetPlayerName(xp.source)..'\nID: '..xp.source..'\n Be Rank: ('..grade..') Dast Resi Dad'
					green = true
				else
					chekdastresi = "IC Name: "..xp.name..'\nOOC Name: '..GetPlayerName(xp.source)..'\nID: '..xp.source..'\nDast Resi Rank: ('..grade..') Ra Gereft'
					green = false
				end
				sendtodiscord(source, Gangs[gang].webhookboss,'Log reven'..gang..' Logger','Permission Crafting', chekdastresi, green)
			end
		end)

	end
end)

ESX.RegisterServerCallback('gangs:GetPermData', function(source, cb, gang, grade, type, plate2)
	local xPlayer = ESX.GetPlayerFromId(source)
	if type == 'inventorys' then
		local items       = (Gangs[gang].grades[tonumber(grade)].inventorys) or "{}"
		if items ~= nil or items ~= {}  then
			cb(json.decode(items))
		end

	elseif type == 'car' then
		local vehicles       = (Gangs[gang].grades[tonumber(grade)].vehicles)
		if vehicles ~= nil or vehicles ~= {}  then
			cb(json.decode(vehicles))
		end

	elseif type == 'heli' then
		local helis  = (Gangs[gang].grades[tonumber(grade)].helis)
		if helis ~= nil or helis ~= {}  then
			cb(json.decode(helis))
		end

	elseif type == 'boat' then
		local boats  = (Gangs[gang].grades[tonumber(grade)].boats)
		if boats ~= nil or boats ~= {}  then
			cb(json.decode(boats))
		end

	elseif type == 'craft' then
		local crt  = (Gangs[gang].grades[tonumber(grade)].crafting)

		cb(crt)
	end
end)

ESX.RegisterServerCallback('gangs:GetPermDataCrafting', function(source, cb, gang, grade, type, plate2)
	local xPlayer = ESX.GetPlayerFromId(source)
	if type == 'inventorys' then
		local items       = (Gangs[gang].grades[tonumber(grade)].inventorys) or "{}"
		cb(json.decode(items))

	elseif type == 'car' then
		local vehicles       = (Gangs[gang].grades[tonumber(grade)].vehicles) or "{}"
		cb(json.decode(vehicles))

	elseif type == 'heli' then
		local helis  = (Gangs[gang].grades[tonumber(grade)].helis) or "{}"
		cb(json.decode(helis))

	elseif type == 'boat' then
		local boats  = (Gangs[gang].grades[tonumber(grade)].boats) or "{}"
		cb(json.decode(boats))

	elseif type == 'craft' then
		local crt  = (Gangs[gang].grades[tonumber(xPlayer.gang.grade)].crafting) or 0
		cb(crt)
	end
end)

RegisterServerEvent('gangs:vehlogs')
AddEventHandler('gangs:vehlogs', function(nameveh, plateveh, modele, status, healthPercent, Engine)
	local source = source
	local xPlayer = ESX.GetPlayerFromId(source)
	local gangName = xPlayer.gang.name
	local Engini = ""
	if Engine then
		Engini = "Darad"
	else
		Engini = "Nadarad"
	end

	if status == 'spawn' then
		local roundedHealth = healthPercent and math.floor(healthPercent) or "namoshakhas"

		if modele == 'veh' then
			sendtodiscord(source, Gangs[gangName].webhookveh, 'Log '..gangName..' Logger', '> Bardashte Mashin',
				'Esme Mashin : '..nameveh..'\n'..
				'Plake Mashin : '..plateveh..'\n'..
				'Salamate Engine : '..roundedHealth..'%\n'..
				'Engine : '..Engini..'\n'..
				'Esm IC Player : '..xPlayer.name..'\n'..
				'Esm OOC Player : '..GetPlayerName(xPlayer.source)..'\n'..
				'ID : '..xPlayer.source)

		elseif modele == 'heli' then
			sendtodiscord(source, Gangs[gangName].webhookveh, 'Log '..gangName..' Logger', '> Bardashte Heli',
				'Esme Heli : '..nameveh..'\n'..
				'Plake Heli : '..plateveh..'\n'..
				'Salamate Engine : '..roundedHealth..'%\n'..
				'Engine : '..Engini..'\n'..
				'Esm IC Player : '..xPlayer.name..'\n'..
				'Esm OOC Player : '..GetPlayerName(xPlayer.source)..'\n'..
				'ID : '..xPlayer.source)

		elseif modele == 'boat' then
			sendtodiscord(source, Gangs[gangName].webhookveh, 'Log '..gangName..' Logger', '> Bardashte Boat',
				'Esme Boat : '..nameveh..'\n'..
				'Plake Boat : '..plateveh..'\n'..
				'Salamate Engine : '..roundedHealth..'%\n'..
				'Engine : '..Engini..'\n'..
				'Esm IC Player : '..xPlayer.name..'\n'..
				'Esm OOC Player : '..GetPlayerName(xPlayer.source)..'\n'..
				'ID : '..xPlayer.source)
		end
	elseif status == 'delete' then
		local roundedHealth = healthPercent and math.floor(healthPercent) or "namoshakhas"
		if modele == 'veh' then
			sendtodiscord(source, Gangs[gangName].webhookveh, 'Log '..gangName..' Logger', '> Gozashte Mashin',
				'Esme Mashin : '..nameveh..'\n'..
				'Plake Mashin : '..plateveh..'\n'..
				'Salamate Engine : '..roundedHealth..'%\n'..
				'Engine : '..Engini..'\n'..
				'Esm IC Player : '..xPlayer.name..'\n'..
				'Esm OOC Player : '..GetPlayerName(xPlayer.source)..'\n'..
				'ID : '..xPlayer.source, true)
		end
	end

end)

