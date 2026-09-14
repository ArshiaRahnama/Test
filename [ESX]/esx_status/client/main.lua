ESX = nil
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
local Status = {}
local armors = {
	police = {
		[0] = {['bproof_1'] = 12,  ['bproof_2'] = 3},
		[1] = {['bproof_1'] = 11,  ['bproof_2'] = 3}
	},

	doc = {
		[0] = {['bproof_1'] = 11,  ['bproof_2'] = 0},
		[1] = {['bproof_1'] = 10,  ['bproof_2'] = 0}
	},

	none = {
		[0] = {['bproof_1'] = 43,  ['bproof_2'] = 1},
		[1] = {['bproof_1'] = 37,  ['bproof_2'] = 1}
	}
}
local PlayerData

local Number = { stress = 0, coin = 0 }

function GetStatusData(minimal)
	local status = {}
	local ped = GetPlayerPed(-1)




	ESX.TriggerServerCallback("Coin-System:GetTimerCoin", function(timer)
		Number.coin = timer
	end)

	for i=1, #Status, 1 do

		if minimal then

			table.insert(status, {
				name    = Status[i].name,
				val     = Status[i].val,
				percent = (Status[i].val / Config.StatusMax) * 100,
			})

		else

			table.insert(status, {
				name    = Status[i].name,
				val     = Status[i].val,
				color   = Status[i].color,
				visible = Status[i].visible(Status[i]),
				max     = Status[i].max,
				percent = (Status[i].val / Config.StatusMax) * 100,
			})

		end

	end

	local pedhealth = GetEntityHealth(ped)

	if pedhealth < 100 then
	  pedhealth = 0
	else
	  pedhealth = pedhealth - 100
	end

	table.insert(status, {
		name	= 'health',
		val		= pedhealth,
		percent	= pedhealth
	})

	local armor = GetPedArmour(ped)

	table.insert(status, {
		name	= 'armor',
		val		= armor ,
		percent	= armor
	})

	local stress = Number.stress

	table.insert(status, {
		name	= 'stress',
		val		= stress ,
		percent	= stress
	})

	local timer = Number.coin

	table.insert(status, {
		name	= 'timer',
		val		= timer ,
		percent	= timer
	})

	return status
end

AddEventHandler('esx_status:registerStatus', function(name, default, color, visible, tickCallback)
	local s = CreateStatus(name, default, color, visible, tickCallback)
	table.insert(Status, s)
end)

local health = 200
local armor	 = 0

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
	PlayerData = xPlayer
	for i=1, #Status, 1 do
		for j=1, #PlayerData.status, 1 do
			if Status[i].name == PlayerData.status[j].name then
				Status[i].set(PlayerData.status[j].val)
			elseif PlayerData.status[j].name == 'health' then
				health = tonumber(PlayerData.status[j].val) + 100
			elseif PlayerData.status[j].name == 'armor' then
				armor = tonumber(PlayerData.status[j].val)
			end
		end
	end

	Citizen.CreateThread(function()
	  while true do

	  	for i=1, #Status, 1 do
	  		Status[i].onTick()
	  	end

		TriggerEvent('esx_customui:updateStatus', GetStatusData(true))
	    Citizen.Wait(Config.TickTime)
	  end
	end)
end)

RegisterNetEvent('esx_status:setxLastStats')
AddEventHandler('esx_status:setxLastStats', function()
	local ped = GetPlayerPed(-1)
	SetEntityHealth(ped, health)
	if armor > 0 then
		SetPedArmour(ped, armor)

		TriggerEvent('skinchanger:getSkin', function(skin)
			if armors[PlayerData.job.name] then
				TriggerEvent('skinchanger:loadClothes', skin, armors[PlayerData.job.name][skin.sex])
			else
				TriggerEvent('skinchanger:loadClothes', skin, armors["none"][skin.sex])
			end
		end)

	else

		TriggerEvent('skinchanger:getSkin', function(skin)
			local clothesSkin = {
				['bproof_1'] = 0,  ['bproof_2'] = 0,
			}
			TriggerEvent('skinchanger:loadClothes', skin, clothesSkin)
		end)

	end
end)

RegisterNetEvent('esx_status:setx')
AddEventHandler('esx_status:setx', function(name, val)
	for i=1, #Status, 1 do
		if Status[i].name == name then
			Status[i].set(val)
			break
		end
	end

	TriggerServerEvent('esx_status:update', GetStatusData(true))
end)

RegisterNetEvent('esx_status:add')
AddEventHandler('esx_status:add', function(name, val)
	for i=1, #Status, 1 do
		if Status[i].name == name then
			Status[i].add(val)
			break
		end
	end

	TriggerServerEvent('esx_status:update', GetStatusData(true))
end)

RegisterNetEvent('esx_status:remove')
AddEventHandler('esx_status:remove', function(name, val)
	for i=1, #Status, 1 do
		if Status[i].name == name then
			Status[i].remove(val)
			break
		end
	end

	TriggerServerEvent('esx_status:update', GetStatusData(true))
end)

AddEventHandler('esx_status:getStatus', function(name, cb)
	for i=1, #Status, 1 do
		if Status[i].name == name then
			cb(Status[i])
			return
		end
	end
end)

Citizen.CreateThread(function()
	TriggerEvent('esx_status:loaded')
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(Config.UpdateInterval)
		TriggerServerEvent('esx_status:update', GetStatusData(true))
	end
end)