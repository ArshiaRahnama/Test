-- Pub by FleeX Team , https://discord.gg/87rGBxgCsa

local PlayerData = {}
local colorIndex = {["police"] = 38, ["ambulance"] = 49,["weazel"] = 49, ["taxi"] = 73, ["mechanic"] = 25, ["sheriff"] = 2, ["mt"] = 85, ["justice"] = 27, ["detective"] = 83}
local jobaccess = {
	["police"] = {
		["police"] = true,
		["sheriff"] = true,
		["mt"] = true,
		["ambulance"] = true,
		["justice"] = true,
		["detective"] = true,
	},
	["sheriff"] = {
		["police"] = true,
		["sheriff"] = true,
		["mt"] = true,
		["ambulance"] = true,
		["justice"] = true,
		["detective"] = true,
	},
	["mt"] = {
		["police"] = true,
		["sheriff"] = true,
		["mt"] = true,
		["ambulance"] = true,
		["justice"] = true,
		["detective"] = true,
	},
	["detective"] = {
		["police"] = true,
		["sheriff"] = true,
		["mt"] = true,
		["ambulance"] = true,
		["justice"] = true,
		["detective"] = true,
	},
	["justice"] = {
		["police"] = true,
		["sheriff"] = true,
		["mt"] = true,
		["ambulance"] = true,
		["justice"] = true,
		["detective"] = true,
	},
	["fbi"] = {
		["police"] = true,
		["sheriff"] = true,
		["ambulance"] = true,
		["weazel"] = true,
		["taxi"] = true,
		["mechanic"] = true,
		["mt"] = true,
		["justice"] = true,
		["detective"] = true,
	},
}
local jobList = {
	['police'] = true,
	['sheriff'] = true,
	['mt'] = true,
	['fbi'] = true,
	['taxi'] = true,
	['weazel'] = true,
	['mechanic'] = true,
	['ambulance'] = true,
	['justice'] = true,
	['detective'] = true,
}
local jobdata = {}
local CreatedBlips = {}
local nearThread = false
local nearBlips = {}
Citizen.CreateThread(function()
	TriggerEvent('chat:addSuggestion', '/gs', 'GPS', {})
	waitForLoad()

	while ESX.GetPlayerData().job == nil do
		Wait(10)
	end

	if jobList[ESX.PlayerData.job.name] then
		if not nearThread then
			nearThread = true
			nearStuff()
		end
	else
		nearThread = false
		for k , v in pairs(nearBlips) do
			RemoveBlip(v.blip)
			nearBlips[k] = nil
		end
	end
end)

local adminchange = false

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
	DeleteAll()
	Wait(2000)
	if jobList[job.name] then
		if not nearThread then
			nearThread = true
			nearStuff()
		end
	else
		nearThread = false
		for k , v in pairs(nearBlips) do
			RemoveBlip(v.blip)
			nearBlips[k] = nil
		end
	end
end)


local svid = GetPlayerServerId(PlayerId())

function nearStuff()
	Citizen.CreateThread(function()
		while nearThread do
			for k , v in pairs(nearBlips) do
				v.check = false
			end
			for k , v in pairs(GetActivePlayers()) do
				if v ~= PlayerId() then
					local id = GetPlayerServerId(v)
					local playerJob = ESX.GetPlayerState(id,'job')
					if playerJob and playerJob ~= 'nojob' then
						if playerJob == ESX.PlayerData.job.name or (jobaccess[ESX.PlayerData.job.name] and jobaccess[ESX.PlayerData.job.name][playerJob]) then
							if not nearBlips[id] then
								local ped = GetPlayerPed(v)
								local blip = AddBlipForEntity(ped)
								SetBlipAlpha(blip, 180)
								SetBlipSprite(blip, 1)
								SetBlipScale(blip, 0.8)
								SetBlipShrink(blip, 1)
								SetBlipCategory(blip, 7)
								SetBlipDisplay(blip, 6)
								SetBlipColour(blip, colorIndex[playerJob])
								BeginTextCommandSetBlipName("STRING")
								AddTextComponentString(GetPlayerName(v))
								EndTextCommandSetBlipName(blip)
								nearBlips[id] = {}
								nearBlips[id].blip = blip
								nearBlips[id].entity = true
								nearBlips[id].check = true
							elseif DoesBlipExist(nearBlips[id].blip) then
								SetBlipColour(nearBlips[id].blip, colorIndex[playerJob])
								nearBlips[id].check = true
							end
						end
					end
				end
			end
			for k , v in pairs(nearBlips) do
				if v.blip and not v.check then
					RemoveBlip(v.blip)
					nearBlips[k] = nil
				end
			end
			Wait(5000)
		end
	end)
end

RegisterNetEvent('fetchgps')
AddEventHandler('fetchgps', function(data)
	if ESX.GetPlayerData().admin == 1 then
		ESX.PlayerData.job.name = 'fbi'
		adminchange = true
	elseif adminchange then
		adminchange = false
		ESX.PlayerData.job = ESX.GetPlayerData().job
	end
	CheckFalse()
	Wait(100)
	jobdata = data
	if PlayerData then
		if jobaccess[ESX.PlayerData.job.name] then
			for k ,v in pairs(jobaccess[ESX.PlayerData.job.name]) do
				for k2 , v2 in pairs(jobdata[k]) do
					if k2 ~= svid then
						local ped = GetPlayerPed(GetPlayerFromServerId(k2))
						if CreatedBlips[k2] and DoesBlipExist(CreatedBlips[k2].blip) and CreatedBlips[k2].entity == false then
							if DoesEntityExist(ped) and ped ~= PlayerPedId() then
								RemoveBlip(CreatedBlips[k2].blip)
							else
								if v2.coords and v2.coords.x then
									SetBlipCoords(CreatedBlips[k2].blip,v2.coords.x, v2.coords.y, v2.coords.z)
									CreatedBlips[k2].check = true
								end
							end
						else
							local next = true
							if CreatedBlips[k2] and CreatedBlips[k2].entity == true then
								if DoesEntityExist(ped) and ped ~= PlayerPedId() then
									next = false
									CreatedBlips[k2].check = true
								end
							end
							if next then
								if CreatedBlips[k2] then
									RemoveBlip(CreatedBlips[k2].blip)
								end
								if DoesEntityExist(ped) and ped ~= PlayerPedId() then

								else
									if v2.coords and v2.coords.x then
										local blip = AddBlipForCoord(v2.coords.x, v2.coords.y, v2.coords.z)
										SetBlipAlpha(blip, 180)
										SetBlipSprite(blip, 1)
										SetBlipScale(blip, 0.8)
										SetBlipShrink(blip, 1)
										SetBlipCategory(blip, 7)
										SetBlipDisplay(blip, 6)
										SetBlipColour(blip, colorIndex[k])
										BeginTextCommandSetBlipName("STRING")
										AddTextComponentString(v2.name)
										EndTextCommandSetBlipName(blip)
										CreatedBlips[k2] = {}
										CreatedBlips[k2].blip = blip
										CreatedBlips[k2].name = name
										CreatedBlips[k2].check = true
										CreatedBlips[k2].entity = false
									end
								end
							end
						end
					end
					------
				end
			end
		else
			if jobdata[ESX.PlayerData.job.name] then
				for k , v in pairs(jobdata[ESX.PlayerData.job.name]) do
					if k ~= svid then
						local ped = GetPlayerPed(GetPlayerFromServerId(k))
						if CreatedBlips[k] and DoesBlipExist(CreatedBlips[k].blip) and CreatedBlips[k].entity == false then
							---------
							if DoesEntityExist(ped) and ped ~= PlayerPedId() then
								RemoveBlip(CreatedBlips[k].blip)
							else
								if v.coords and v.coords.x then
									SetBlipCoords(CreatedBlips[k].blip,v.coords.x, v.coords.y, v.coords.z)
									CreatedBlips[k].check = true
								end
							end
						else
							local next = true
							if CreatedBlips[k] and CreatedBlips[k].entity == true then
								if DoesEntityExist(ped) and ped ~= PlayerPedId() then
									next = false
									CreatedBlips[k].check = true
								end
							end
							if next then
								if CreatedBlips[k] then
									RemoveBlip(CreatedBlips[k].blip)
								end
								if DoesEntityExist(ped) and ped ~= PlayerPedId() then
									--
								else
									if v.coords and v.coords.x then
										local blip = AddBlipForCoord(v.coords.x, v.coords.y, v.coords.z)
										SetBlipAlpha(blip, 180)
										SetBlipSprite(blip, 1)
										SetBlipScale(blip, 0.8)
										SetBlipShrink(blip, 1)
										SetBlipCategory(blip, 7)
										SetBlipDisplay(blip, 6)
										SetBlipColour(blip, colorIndex[ESX.PlayerData.job.name])
										BeginTextCommandSetBlipName("STRING")
										AddTextComponentString(v.name)
										EndTextCommandSetBlipName(blip)
										CreatedBlips[k] = {}
										CreatedBlips[k].blip = blip
										CreatedBlips[k].check = true
										CreatedBlips[k].entity = false
									end
								end
							end
						end
					end
				end
			end
		end
	end
	Wait(1000)
	DeleteFalse()
end)

function DeleteFalse()
	for k, v in pairs(CreatedBlips) do
		if v.blip and v.check == false then
			RemoveBlip(v.blip)
			CreatedBlips[k] = nil
		end
	end
	--CreatedBlips = {}
end

function DeleteAll()
	for k, v in pairs(CreatedBlips) do
		if v.blip then
			RemoveBlip(v.blip)
		end
		CreatedBlips[k] = nil
	end
	--CreatedBlips = {}
end

function CheckFalse()
	for k, v in pairs(CreatedBlips) do
		CreatedBlips[k].check = false
	end
end

local cd = false
local Timeout = 0
RegisterCommand('gs',function()
	if cd then return ESX.Alert('Spam','Spam nakonid!',5000,'warning') end
	cd = true
	ESX.ClearTimeout(Timeout)
	Timeout = ESX.SetTimeout(19000,function()
		DeleteAll()
		cd = false
	end)
	ESX.SetTimeout(20000,function()
		cd = false
	end)
	if (ESX.PlayerData.job.name ~= 'nojob' and not ESX.basicJobs[ESX.PlayerData.job.name] and not ESX.PlayerData.job.name:find('off')) or ESX.GetPlayerData().admin == 1 then
		DeleteAll()
		ESX.TriggerServerCallback('gps:getdata',function(data)
			if data then
				TriggerEvent('fetchgps',data)
			end
		end)
	else
		TriggerEvent('radio:ShowGPS')
		--ESX.Alert('Access denied','Shoma dastresi be in cmd nadarid!',5000,'error')
	end
end, false)