-- Pub by FleeX Team , https://discord.gg/87rGBxgCsa

ESX = nil
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
local Status = {}
local PlayerData

function GetStatusData(minimal)
	local status = {}
	local ped = GetPlayerPed(-1)

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
	return status
end

AddEventHandler('esx_status:registerStatus', function(name, default, color, visible, tickCallback)
	local s = CreateStatus(name, default, color, visible, tickCallback)
	table.insert(Status, s)
end)

local health = 200
local armor	 = 0
local loaded,loaded2 = false, false
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
	loaded = true
	Citizen.CreateThread(function()
	  while true do

	  	for i=1, #Status, 1 do
	  		Status[i].onTick()
	  	end
		TriggerEvent('status:updateStatus', GetStatusData(true))
	    Citizen.Wait(Config.TickTime)
	  end
	end)
end)

RegisterNetEvent('loading:Loaded')
AddEventHandler('loading:Loaded', function()
	while not loaded do Citizen.Wait(3000) end
	Citizen.Wait(30000)
	local ped = GetPlayerPed(-1)
	SetEntityMaxHealth(ped,200)
	ESX.SetEntityHealth(ped, health)
	if armor > 0 then

		ESX.SetPedArmour(ped, armor)

		if not ESX.militaryJobs2[PlayerData.job.name] then
			TriggerEvent('skinchanger:getSkin', function(skin)
				if skin.sex == 0 then
					local clothesSkin = {
						['bproof_1'] = 15,  ['bproof_2'] = 2,
					}
					TriggerEvent('skinchanger:loadClothes', skin, clothesSkin)
				elseif skin.sex == 1 then
					local clothesSkin = {
						['bproof_1'] = 17,  ['bproof_2'] = 2,
					}
					TriggerEvent('skinchanger:loadClothes', skin, clothesSkin)
				end
			end)
			Wait(5000)
			TriggerEvent('gang:loadVipVest')
		else
			TriggerEvent('skinchanger:getSkin', function(skin)
				if skin.sex == 0 then
					local clothesSkin = {
						['bproof_1'] = 208,  ['bproof_2'] = 0,
					}
					TriggerEvent('skinchanger:loadClothes', skin, clothesSkin)
				elseif skin.sex == 1 then
					local clothesSkin = {
						['bproof_1'] = 184,  ['bproof_2'] = 1,
					}
					TriggerEvent('skinchanger:loadClothes', skin, clothesSkin)
				end
			end)

		end

	else

		TriggerEvent('skinchanger:getSkin', function(skin)
			local clothesSkin = {
				['bproof_1'] = 0,  ['bproof_2'] = 0,
			}
			TriggerEvent('skinchanger:loadClothes', skin, clothesSkin)
		end)

	end
	loaded2 = true
end)

RegisterNetEvent('esx_status:setss')
AddEventHandler('esx_status:setss', function(name, val)
	for i=1, #Status, 1 do
		if Status[i].name == name then
			Status[i].set(val)
			break
		end
	end
	if ESX.inRealWorld() and loaded2 then
		TriggerServerEvent('esx_status:updatess', GetStatusData(true))
	end
end)

RegisterNetEvent('esx_status:add')
AddEventHandler('esx_status:add', function(name, val)
	for i=1, #Status, 1 do
		if Status[i].name == name then
			Status[i].add(val)
			break
		end
	end

	if ESX.inRealWorld() and loaded2 then
		TriggerServerEvent('esx_status:updatess', GetStatusData(true))
	end
end)

RegisterNetEvent('esx_status:remove')
AddEventHandler('esx_status:remove', function(name, val)
	for i=1, #Status, 1 do
		if Status[i].name == name then
			Status[i].remove(val)
			break
		end
	end

	if ESX.inRealWorld() and loaded2 then
		TriggerServerEvent('esx_status:updatess', GetStatusData(true))
	end
end)

AddEventHandler('esx_status:getStatus', function(name, cb)
	for i=1, #Status, 1 do
		if Status[i].name == name then
			cb(Status[i])
			return
		end
	end
end)

-- Loaded event
Citizen.CreateThread(function()
	TriggerEvent('esx_status:loaded')
end)
local update = true
-- Update server
AddEventHandler('status:setupdate',function(state)
	update = state
end)

local lastsaved = {}
function Update()
	local inRob = exports['sun-robbery']:doesInRob()
	if update and (ESX.GetPlayerData().World == 0 or inRob) then
		local data = GetStatusData(true)
		local send = false
		local health , armor
		for k , v in pairs(data) do
			if v.name == 'armor' then
				armor = v.val
			elseif v.name == 'health' then
				health = v.val
			end
		end
		local stress = exports['sunset_utils']:getStress()
		if not lastsaved['health'] then
			send = true
			lastsaved['health'] = health
			lastsaved['armor'] = armor
			lastsaved['stress'] = stress
		elseif lastsaved['health'] ~= health or lastsaved['armor'] ~= armor or lastsaved['stress'] ~= stress then
			send = true
			lastsaved['health'] = health
			lastsaved['armor'] = armor
			lastsaved['stress'] = stress
		end
		if send and (ESX.inRealWorld() or inRob) and loaded2 then
			TriggerServerEvent('esx_status:updatess', data, exports['sunset_utils']:getStress())
		end
	end
end

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(Config.UpdateInterval)
		Update()
	end
end)