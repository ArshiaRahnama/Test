-- Pub by FleeX Team , https://discord.gg/87rGBxgCsa

jobConfig, currentZone = nil
local drawList = {}
local threadActive = false
local function mainThread()
	if not threadActive then
		threadActive = true
		CreateThread(function()
			while threadActive do
				for k, v in pairs(drawList) do
					DrawMarker(v.markerData.type, v.coords.x, v.coords.y, v.coords.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, v.markerData.size[1], v.markerData.size[2], v.markerData.size[3], v.markerData.color[1], v.markerData.color[2], v.markerData.color[3], v.markerData.color[4], v.markerData.upDown, false, 2, true, nil, nil, false)
				end
				if currentZone and currentZone.label then
					if not IsHelpMessageOnScreen() then
						BeginTextCommandDisplayHelp('STRING')
						AddTextComponentSubstringWebsite(currentZone.label)
						EndTextCommandDisplayHelp(0, false, false, -1)
					end
				end
				Wait(0)
			end
		end)
		CreateThread(function()
			while threadActive do
				local coords = GetEntityCoords(PlayerPedId())
				for k, v in pairs(jobConfig.zones) do
					for k2, v2 in pairs(v) do
						local distance = #(coords - (v2.x and v2.xyz or v2.spawner.xyz))
						if distance < Shared.drawDistance then
							local markerData = jobConfig.markers?[k] or Shared.markers[k]
							drawList[k..k2] = {
								markerData = markerData,
								coords = (v2.x and v2 or v2.spawner),
							}
							if markerData.range and distance < markerData.range then
								currentZone = {label = markerData.label, type = k, k = k2, key = k..k2}
							elseif currentZone and currentZone.key == k..k2 then
								currentZone = nil
								ESX.closeAll()
							end
						elseif drawList[k..k2] or currentZone and currentZone.key == k..k2 then
							drawList[k..k2] = nil
							currentZone = nil
							ESX.closeAll()
						end
					end
				end
				Wait(200)
			end
		end)
	end
end

local function openLocker()
	local station = 1
	local elements = {
		{label = 'Anbar 🎒', value = 'locker'},
	}
	ESX.UI.Menu.CloseAll()
	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'locker_menu', {
		title    = 'Locker',
		align    = 'top-left',
		elements = elements
	}, function(data, menu)
		menu.close()
		if data.current.value == 'locker' then
		 	exports['sun-inventory-hud']:openJobInventory(station)
		end
	end, function(data, menu)
		menu.close()
	end)
end

exports('getJobLockerCount', function(job)
	local cfg = Shared and Shared[job]
	if cfg and cfg.zones and cfg.zones.locker then
		return ESX.tableLength(cfg.zones.locker)
	end
	return 0
end)

local function openCloakroom()
	ESX.UI.Menu.CloseAll()
	local elements = {
		{ label = 'Lebas shakhsi 👖', value = 'wear_citizen'},
		{ label = 'Lebas kar 💼',    value = 'wear_work'}
	}
	local playerSkin, jobSkin, divisionSkin = getPlayerSkin()
	if divisionSkin then
		table.insert(elements, {label = 'Lebas division', value = 'division'})
	end
	if jobConfig.uniforms?.bullet_wear then
		table.insert(elements, {label = 'Jelighe zed golule', value = 'vest'})
	end
	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'cloakroom', {
		title    = 'Komod lebas',
		align    = 'top-left',
		elements = elements
	}, function(data, menu)
		local ped = PlayerPedId()
		ESX.SetPedArmour(ped, 0)
		ClearPedBloodDamage(ped)
		ResetPedVisibleDamage(ped)
		ClearPedLastWeaponDamage(ped)
		ResetPedMovementClipset(ped, 0)
		if data.current.value == 'wear_citizen' then
			exports['sunset_clothe']:removeStuffJob()
			Citizen.Wait(1000)
			exports['sunset_clothe']:loadUsed()
			saveClothe()
		elseif data.current.value == 'wear_work' then
			if playerSkin.sex == 0 then
				TriggerEvent('skinchanger:loadClothes', playerSkin, jobSkin.skin_male)
			else
				TriggerEvent('skinchanger:loadClothes', playerSkin, jobSkin.skin_female)
			end
			saveClothe(ESX.PlayerData.job.name)
		elseif data.current.value == 'division' then
			if playerSkin.sex == 0 then
				TriggerEvent('skinchanger:loadClothes', playerSkin, divisionSkin?.skin_male)
			else
				TriggerEvent('skinchanger:loadClothes', playerSkin, divisionSkin?.skin_female)
			end
			saveClothe(ESX.PlayerData.job.name, 'division')
		elseif data.current.value == 'vest' then
			ESX.SetPedArmour(ped, ESX.GetPlayerData().MaxArmour or 100)
			if ESX.militaryJobs2[ESX.PlayerData.job.name] then
				ESX.TriggerServerEvent('police:setSCState', true)
			end
			-- TriggerEvent('skinchanger:getSkin', function(skin)
			-- 	if playerSkin.sex == 0 then
			-- 		TriggerEvent('skinchanger:loadClothes', skin, jobConfig.uniforms?.bullet_wear.male)
			-- 	else
			-- 		TriggerEvent('skinchanger:loadClothes', skin, jobConfig.uniforms?.bullet_wear.female)
			-- 	end
			-- end)
		end
	end, function(data, menu)
		menu.close()
	end)
end

local function openItemShop()
	local elements = {}

	for k, v in pairs(jobConfig.itemShop) do
		table.insert(elements, {label = 'x'.. v.count ..' '.. ESX.getItemLabel(k) ..' $' .. v.price, value = k})
	end
	local cd = false
	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'buy_item',
	{
		title    = 'Kharid item',
		align    = 'top-left',
		elements = elements,
	}, function(data, menu)
		if cd then return end
		cd = true
		SetTimeout(1000, function()
			cd = false
		end)
		ESX.TriggerServerEvent('jobs:buyItem', data.current.value)
	end,function(data, menu)
		menu.close()
	end)
end

local function openWeaponShop()
	local elements = {}

	for k, v in pairs(jobConfig.weaponShop) do
		table.insert(elements, {label = ESX.getItemLabel(k) ..' $' .. v.price, value = k})
	end
	local cd = false
	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'buy_item',
	{
		title    = 'Kharid item',
		align    = 'top-left',
		elements = elements,
	}, function(data, menu)
		if cd then return end
		cd = true
		SetTimeout(1000, function()
			cd = false
		end)
		ESX.TriggerServerEvent('jobs:buyWeapon', data.current.value)
	end,function(data, menu)
		menu.close()
	end)
end

local function openBoss()
	local elements = {
		{label = 'Boss Action 💼', value = 'boss_action'},
	}
	if jobConfig.itemShop and exports['sun-society']:doesHavePerm('buyItem') then
		table.insert(elements, {label = 'Kharid Item 💸', value = 'buy_item'})
	end
	if jobConfig.weaponShop and exports['sun-society']:doesHavePerm('buyWeapon') then
		table.insert(elements, {label = 'Kharid Weapon 💸', value = 'buy_weapon'})
	end
	ESX.UI.Menu.CloseAll()
	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'locker_menu', {
		title    = 'Locker',
		align    = 'top-left',
		elements = elements
	}, function(data, menu)
		menu.close()
		if data.current.value == 'boss_action' then
			TriggerEvent('esx_society:openbossss', ESX.PlayerData.job.name, function(data, menu)
				menu.close()
			end)
		elseif data.current.value == 'buy_item' then
			openItemShop()
		elseif data.current.value == 'buy_weapon' then
			openWeaponShop()
			
		end
	end, function(data, menu)
		menu.close()
	end)
end

local function openVehicleSpawner(zone)
	if jobConfig.config.needUnit and not doesHaveUnit() then return ESX.ShowNotification('Shoma bayad dar yek unit bashid') end
    local spawnPoint = jobConfig.zones.vehicles[zone.k].spawnPoint
    ESX.UI.Menu.CloseAll()

    local elements = {}

    local authorizedVehicles = GetAuthorizedJobVehicles(1)
	for k, v in pairs(authorizedVehicles) do
		table.insert(elements, {label = v.label, data = json.decode(v.data)})
	end

    ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'vehicle_spawner', {
		title    = 'Garage',
		align    = 'top-left',
		elements = elements
	}, function(data, menu)
		menu.close()

		if ESX.Game.IsSpawnPointClear(spawnPoint.xyz, 5.0) then
			local plate = nil
			if jobConfig.config.customPlate then
				local p = promise.new()
				ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'get_plate', {
			        title = 'Pelak mashin ra vared konid'
			    }, function(data,menu)
					if data.value then
						menu.close()
						if ESX.isAlphaNumeric(data.value) then
							plate = jobConfig.config.platePrefix .. data.value
						else
							ESX.notification('error', 'Pelak bayad english bashad!')
						end
						p:resolve(data.value)
					end
				end, function(data,menu)
				    menu.close()
					p:resolve()
				end)
				Citizen.Await(p)
			else
				plate = jobConfig.config.platePrefix .. (jobConfig.config.needUnit and ESX.Math.Trim(getUnit()):gsub('-','') or generateRandomVehiclePlate(8))
			end
			if not plate then return end
			ESX.TriggerServerCallback('jobs:getSavedVehicle', function(vehicle, haveDriver)
				if vehicle and haveDriver then
					local alert = lib.alertDialog({
						header = 'In pelak vojud darad',
						content = 'Yek mashin ba in pelak va daraye ranande vojud darad  \n Aya mayel be pak kardan in mashin hastid?',
						centered = true,
						cancel = true
					})
					if alert == 'cancel' then return end
				end
				ESX.Game.SpawnVehicle(data.current.data.model, spawnPoint.xyz, spawnPoint.w, function(vehicle)
					exports['esx_vehiclecontrol']:SetDecor(vehicle, jobConfig.config.decor, true)
					TaskWarpPedIntoVehicle(PlayerPedId(), vehicle, -1)
					ESX.Game.SetVehicleProperties(vehicle, data.current.data)
					if data.current.data.model == `Kcamozesh` then
						plate = ESX.GetRandomString(8)
					end
					setVehicleMaxMods(vehicle, plate)
					SetTimeout(2000, function()
						ESX.setVehicleFuel(vehicle, 100.0)
					end)
					SUN.log(('job_%s_spawncar'):format(ESX.PlayerData.job.name), 'Spawn car', ESX.PlayerData.name .." ( ".. ESX.PlayerData.job.name .." ) (".. GetPlayerServerId(PlayerId()) ..") ".. data.current.label .. " ba pelak ".. plate .. " spawn kard")
					-- if jobConfig.config.customPlate then
						TriggerServerEvent('jobs:saveVehicle', plate:upper(), NetworkGetNetworkIdFromEntity(vehicle))
					-- end
					if data.current.data.model == `Kcamozesh` then
						ESX.giveCarKey(vehicle)
					end
				end)
			end, plate:upper())
		else
			ESX.ShowNotification('Be dalil por budan location spawn emkan spawn vojud nadarad')
		end
	end, function(data, menu)
		menu.close()
	end)
end

local function openHelicopterSpawner(zone)
	if jobConfig.config.needUnit and not doesHaveUnit() then return ESX.ShowNotification('Shoma bayad dar yek unit bashid') end
    local spawnPoint = jobConfig.zones.helicopters[zone.k].spawnPoint
    ESX.UI.Menu.CloseAll()

    local elements = {}

	local authorizedVehicles = GetAuthorizedJobVehicles(2)
	for k, v in pairs(authorizedVehicles) do
		table.insert(elements, {label = v.label, data = json.decode(v.data)})
	end

    ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'helicopter_spawner', {
		title    = 'Garage',
		align    = 'top-left',
		elements = elements
	}, function(data, menu)
		menu.close()

		if ESX.Game.IsSpawnPointClear(spawnPoint.xyz, 5.0) then
			local plate = nil
			if jobConfig.config.customPlate then
				local p = promise.new()
				ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'get_plate', {
			        title = 'Pelak helicopter ra vared konid'
			    }, function(data,menu)
					if data.value then
						menu.close()
						plate = jobConfig.config.platePrefix .. data.value
						p:resolve(data.value)
					end
				end, function(data,menu)
				    menu.close()
					p:resolve()
				end)
				Citizen.Await(p)
			else
				plate = jobConfig.config.platePrefix .. (jobConfig.config.needUnit and ESX.Math.Trim(getUnit()):gsub('-','') or generateRandomVehiclePlate(8))
			end
			if not plate then return end
			ESX.Game.SpawnVehicle(data.current.data.model, spawnPoint.xyz, spawnPoint.w, function(vehicle)
				exports['esx_vehiclecontrol']:SetDecor(vehicle, jobConfig.config.decor, true)
				TaskWarpPedIntoVehicle(PlayerPedId(), vehicle, -1)
				ESX.Game.SetVehicleProperties(vehicle, data.current.data)
				setVehicleMaxMods(vehicle, plate, nil, data.current.colors)
				SetTimeout(2000, function()
					ESX.setVehicleFuel(vehicle, 100.0)
				end)
				SUN.log(('job_%s_spawncar'):format(ESX.PlayerData.job.name), 'Spawn HELI', ESX.PlayerData.name .." ( ".. ESX.PlayerData.job.name .." ) (".. GetPlayerServerId(PlayerId()) ..") ".. data.current.label .. " ba pelak ".. plate .. " spawn kard")
			end)
		else
			ESX.ShowNotification('Be dalil por budan location spawn emkan spawn vojud nadarad')
		end
	end, function(data, menu)
		menu.close()
	end)
end

Citizen.CreateThread(function()
	repeat Wait(50) until ESX and playerLoaded

	if Shared[ESX.PlayerData.job.name] then
		jobConfig = Shared[ESX.PlayerData.job.name]
		mainThread()
	end
end)

RegisterNetEvent('esx:setJob', function(job)
    local oldJob = ESX.PlayerData.job.name
    ESX.PlayerData.job = job
	if Shared[ESX.PlayerData.job.name] then
		mainThread()
	else
		threadActive = false
	end
	jobConfig = Shared[ESX.PlayerData.job.name]
end)

RegisterNetEvent('esx:changeworld', function(world)
	ESX.PlayerData.World = world
end)

AddEventHandler('KeyDown:e', function()
	if currentZone and ESX.PlayerData.World == 0 then
		if currentZone.type == 'bossAction' then
			openBoss()
		elseif currentZone.type == 'cloakroom' then
			openCloakroom()
		elseif currentZone.type == 'locker' then
			openLocker()
		elseif currentZone.type == 'vehicles' then
			openVehicleSpawner(currentZone)
		elseif currentZone.type == 'helicopters' then
			openHelicopterSpawner(currentZone)
		elseif currentZone.type == 'vehicleDeleter' then
			deleteVehicle()
		elseif currentZone.type == 'startTaxiJob' then
			TriggerEvent('taxi:AccessToStartJob')
		elseif currentZone.type == 'stopTaxiJob' then
			stopTaxiJob()
		elseif currentZone.type == 'vehicleDeleterImpound' then
			mechanicDeleteVehicleImpound()
		end
	end
end)

AddEventHandler('KeyDown:f6', function()
	if ESX.UI.Menu.IsOpen('default', GetCurrentResourceName(), 'f6') then
		ESX.UI.Menu.CloseAll()
		return
	end
	if threadActive and not ESX.isDead() then
		if jobConfig.menu then
			local elements = {}
			for k, v in pairs(jobConfig.menu) do
				local label = type(v.label) == 'string' and v.label or v.label()
				if label then
					table.insert(elements, {label = label, k = k})
				end
			end
			ESX.UI.Menu.CloseAll()
			ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'f6', {
				title    = 'Menu Job',
				align    = 'top-left',
				posKey   = 'f6',
				elements = elements
			}, function(data, menu)
				jobConfig.menu[data.current.k].cb()
			end, function(data, menu)
				menu.close()
			end)
		end
	end
end)

RegisterNetEvent('job:toToBoss', function()
	if jobConfig and jobConfig.zones then
		ESX.Game.Teleport(PlayerPedId(), jobConfig.zones.bossAction[1])
	end
end)

function doesNearAnyStation(range)
	if jobConfig and jobConfig.zones then
		local coords = GetEntityCoords(PlayerPedId())
		for k, v in pairs(jobConfig.zones.bossAction) do
			if #(coords - v) < range then
				return true
			end
		end
	end
end