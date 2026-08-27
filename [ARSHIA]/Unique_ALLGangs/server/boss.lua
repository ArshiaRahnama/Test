
-------------------------------------------------------------------
-- MERGE NOTE: this file used to be FMGangBoss/server.lua, a SEPARATE
-- resource that reached into FMGangs via exports.FMGangs:... Now both
-- live in the same Unique_ALLGangs resource, so we call the global
-- functions from server/Gangs.lua directly - no exports/cross-resource
-- hop needed (and no risk of it breaking if someone renames the
-- resource, which is exactly what broke when it was first merged).
-------------------------------------------------------------------
local Accounts = {}
function GetAccount(account)
	return GetMoneyOfGang(account)
end

function AddMoney(account, amount)
	AddGangMoney(account, amount)
end
function RemoveMoney(account, amount)
	if tonumber(amount) and tonumber(amount) > 0 then
		return RemoveGangMoney(account, amount)
	end
end

RegisterNetEvent("FMGangsBoss:server:withdrawMoney", function(amount)
	local src = source
	local Player = ESX.GetPlayerFromId(src)
	local job = Player.gang.name
	if RemoveMoney(job, amount) then
		TriggerEvent('For5M:SendLog', src , 'Boss Action' , 'withdraw Money | -$' ..amount   )
		Player.addMoney(tonumber(amount))
		TriggerClientEvent(Config.showNotification, src, "You have withdgangn: $" ..tonumber(amount), "success")
	else
		TriggerClientEvent(Config.showNotification, src, "You dont have enough money in the account!", "error")
	end
end)
RegisterNetEvent("FMGangsBoss:server:MoneyPack", function(gang,  amount)
	AddMoney(gang, tonumber(amount))
end)

RegisterNetEvent("FMGangsBoss:server:depositMoney", function(amount)
	local src = source
	local Player = ESX.GetPlayerFromId(src)
	if tonumber(amount) and Player.money >= tonumber(amount)  then
		local job = Player.gang.name
		Player.removeMoney(amount)
		TriggerEvent('For5M:SendLog', src , 'Boss Action' , 'deposit Money | +$' ..amount   )
		AddMoney(job, amount)
		TriggerClientEvent(Config.showNotification, src, "You have deposited: $" ..amount)
	else
		TriggerClientEvent(Config.showNotification, src, "You dont have enough money to add!", "error")
	end
end)

ESX.RegisterServerCallback('FMGangsBoss:getmoney', function(source , cb)
	local gangname = ESX.GetPlayerFromId(source).gang.name
	local result = GetAccount(gangname)
	cb(result)
end)

RegisterNetEvent('FMGangsBoss:server:GradeUpdate', function(data)
	local src = source
	local Player = ESX.GetPlayerFromId(src)
	local Employee = ESX.GetPlayerFromIdentifier(data.cid)

	if data.grade <= 0 then
		
		TriggerEvent("FMGangsBoss:server:FireEmployee",source, data)

	else
		print( data.grade)
		print( Player.gang.grade )
		if data.grade > Player.gang.grade then
			TriggerClientEvent(Config.showNotification, src, "You cannot raise your own rank.", "error") 
		else
			if Employee then
				TriggerEvent('For5M:SendLog', src , 'Boss Action' , 'Player Rank Updated | '.. Employee.name .. '|' .. data.grade   )
				Employee.setGang(Employee.gang.name, tonumber(data.grade)) 
				TriggerClientEvent(Config.showNotification, src, 'Player Rank Updated | '.. Employee.name .. '|' .. data.grade   , "success")
			else
				TriggerClientEvent(Config.showNotification, src, "Civilian not in city.", "error")
			end 
		end
	end
end)

-- Fire Employee
RegisterNetEvent('FMGangsBoss:server:FireEmployee', function(source,target)
	local src = source
	local Player = ESX.GetPlayerFromId(src)
	local xPlayer = ESX.GetPlayerFromId(src)
	local Employee = ESX.GetPlayerFromIdentifier(target.cid)
	if Employee then
		if true then
			TriggerEvent('For5M:SendLog', src , 'Boss Action' , 'Employee fired | '.. Employee.name    )
			Employee.setGang("nogang", 0)
			TriggerClientEvent(Config.showNotification, src, "Employee fired!", "success")
		else
			TriggerClientEvent(Config.showNotification, src, "You can\'t fire yourself", "error")
		end
	else
		MySQL.Async.execute('UPDATE users SET gang = @gang, grade = @grade WHERE identifier = @identifier', 
		{
			['@gang'] =  'nogang',
			['@grade'] = 0,
			['@identifier'] = target.cid
		}, function(result)
		end)
		TriggerEvent('For5M:SendLog', src , 'Boss Action' , 'Employee fired | Hex : '.. target.cid    )
		TriggerClientEvent(Config.showNotification, src, "Employee fired!", "success")
	end
end)

ESX.RegisterServerCallback('FMGangBoss:getname', function(source, cb)
	local src = source
	local Player = ESX.GetPlayerFromId(src)
	cb(Player.name ,Player.gang.name )
end)

-- Recruit Player
RegisterNetEvent('FMGangsBoss:server:HireEmployee', function(recruit)
	local src = source
	local Player = ESX.GetPlayerFromId(src)
	local Target = ESX.GetPlayerFromId(recruit)
    if Player then
		if Target then
			TriggerEvent('For5M:SendLog', src , 'Boss Action' , 'Employee hired | +'..  Target.name    )
			Target.setGang(Player.gang.name, data.grade-1)
			TriggerClientEvent(Config.showNotification, src, "You hired " .. (Target.PlayerData.charinfo.firstname .. ' ' .. Target.PlayerData.charinfo.lastname) .. " come " .. Player.PlayerData.job.label .. "", "success")
			TriggerClientEvent(Config.showNotification, Target.PlayerData.source , "You were hired as " .. Player.PlayerData.job.label .. "", "success")
		end
	end

end)

RegisterNetEvent('FMGangBoss:SetGang', function(id)
	local src = source
	local Employee = ESX.GetPlayerFromId(id)
	local Player = ESX.GetPlayerFromId(src)
	if Employee then
		TriggerEvent('For5M:SendLog', src , 'Boss Action' , 'Employee hired | +'..  Employee.name    )
		Employee.setGang(Player.gang.name,1)
		TriggerClientEvent(Config.showNotification, src, "Employee hired!", "success")
	else
		TriggerClientEvent(Config.showNotification, src, "Civilian not in city.", "error")
	end
end)

