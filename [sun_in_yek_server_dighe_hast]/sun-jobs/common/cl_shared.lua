-- Pub by FleeX Team , https://discord.gg/87rGBxgCsa

ESX = nil
Keys = {
	["ESC"] = 322, ["F1"] = 288, ["F2"] = 289, ["F3"] = 170, ["F5"] = 166, ["F6"] = 167, ["F7"] = 168, ["F8"] = 169, ["F9"] = 56, ["F10"] = 57,
    ["~"] = 243, ["1"] = 157, ["2"] = 158, ["3"] = 160, ["4"] = 164, ["5"] = 165, ["6"] = 159, ["7"] = 161, ["8"] = 162, ["9"] = 163, ["-"] = 84, ["="] = 83, ["BACKSPACE"] = 177,
    ["TAB"] = 37, ["Q"] = 44, ["W"] = 32, ["E"] = 38, ["R"] = 45, ["T"] = 245, ["Y"] = 246, ["U"] = 303, ["P"] = 199, ["["] = 39, ["]"] = 40, ["ENTER"] = 18,
    ["CAPS"] = 137, ["A"] = 34, ["S"] = 8, ["D"] = 9, ["F"] = 23, ["G"] = 47, ["H"] = 74, ["K"] = 311, ["L"] = 182,
    ["LEFTSHIFT"] = 21, ["Z"] = 20, ["X"] = 73, ["C"] = 26, ["V"] = 0, ["B"] = 29, ["N"] = 249, ["M"] = 244, [","] = 82, ["."] = 81,
    ["LEFTCTRL"] = 36, ["LEFTALT"] = 19, ["SPACE"] = 22, ["RIGHTCTRL"] = 70,
    ["HOME"] = 213, ["PAGEUP"] = 10, ["PAGEDOWN"] = 11, ["DELETE"] = 178,
    ["LEFT"] = 174, ["RIGHT"] = 175, ["TOP"] = 27, ["DOWN"] = 173,
    ["NENTER"] = 201, ["N4"] = 108, ["N5"] = 60, ["N6"] = 107, ["N+"] = 96, ["N-"] = 97, ["N7"] = 117, ["N8"] = 61, ["N9"] = 118
}
playerLoaded = false
local spawnedObject = {}

Citizen.CreateThread(function()
	TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
	repeat Wait(0) until ESX ~= nil
	repeat Wait(0) until ESX.GetPlayerData().job ~= nil
	ESX.PlayerData = ESX.GetPlayerData()
	playerLoaded = true
	while not lib do Wait(100) end
    lib.registerMenu({
        id = 'spawnObject',
        title = 'Spawn Object',
        options = {},
        disableInput = false,
		onSideScroll = function(selected, scrollIndex, args)
			if not IsPedInAnyVehicle(PlayerPedId(), true) then
				if scrollIndex ~= 0 then
					if RayCast.isPlacing then
						RayCast.changeModel(joaat(args[scrollIndex].model), args[scrollIndex])
					else
						local coords, args = RayCast.RpPut(joaat(args[scrollIndex].model), 15, args[scrollIndex])
						if coords and args then
							local model = args.model
							if #spawnedObject > 10 then ESX.Game.DeleteEntity(spawnedObject[1]) table.remove(spawnedObject, 1) end
							ESX.Game.SpawnObject(model, vec(coords.x, coords.y, coords.z), function(entity)
								table.insert(spawnedObject, entity)
								SetEntityHeading(entity, coords.w)
								SetEntityCollision(entity, true, true)
								FreezeEntityPosition(entity, args.freeze)
								ESX.TriggerServerEvent('setEntityState', NetworkGetNetworkIdFromEntity(entity), 'spawnJob', ESX.PlayerData.job.name)
								lib.hideMenu(true)
								openSpawnObject()
								SetTimeout(1000, function()
									SetEntityCoords(entity, coords.x, coords.y, coords.z)
								end)
							end)
						end
					end
				end
			else
				lib.hideMenu(true)
			end
		end,
		onClose = function()
			RayCast.Cancel()
		end
    })
end)

function IsAllowedVehicle(table, val)
    for i = 1, #table do
        if table[i] == val then
            return true
        end
    end
    return false
end

function loadAnimDict(dictname)
	if not HasAnimDictLoaded(dictname) then
		RequestAnimDict(dictname)
		while not HasAnimDictLoaded(dictname) do
			Citizen.Wait(1)
		end
	end
end

function ensureAnimDict(animDict)
    if not HasAnimDictLoaded(animDict) then
        RequestAnimDict(animDict)
        while not HasAnimDictLoaded(animDict) do
            Wait(0)
        end
    end
    return animDict
end

function setVehicleMaxMods(vehicle, plate, window, colors)
    local plate = plate:gsub('-', '')
	local props = {
		modEngine       =   3,
		modBrakes       =   2,
		windowTint      =   window,
		modArmor        =   4,
		modTransmission =   2,
		modSuspension   =   GetNumVehicleMods(vehicle, 15) - 1,
		modTurbo        =   true,
		plate           =   plate,
		color1 = colors?.a,
		color2 = colors?.b,
		pearlescentColor = colors?.c,
	}

    ESX.Game.SetVehicleProperties(vehicle, props)
    SetVehicleDirtLevel(vehicle, 0.0)
end

function VehicleHandler(vehicle, extras, nonextras, livery)
	local vehicle = vehicle
	local livery = livery
	local extras = extras
	local nonextras = nonextras

	if extras then
		for i,v in ipairs(extras) do
			SetVehicleExtra(vehicle, v, 0)
		end

		if nonextras then
			for i,v in ipairs(nonextras) do
				SetVehicleExtra(vehicle, v, 1)
			end
		end

		ESX.SetVehicleFixed(vehicle)
	end

	if livery then
		SetVehicleLivery(vehicle, livery)
	end

	Citizen.Wait(2000)
	ESX.setVehicleFuel(vehicle, 100.0)
end

function DrawSub(msg, time)
	ClearPrints()
	BeginTextCommandPrint('STRING')
	AddTextComponentSubstringPlayerName(msg)
	EndTextCommandPrint(time, true)
end

function ShowLoadingPromt(msg, time, type)
	Citizen.CreateThread(function()
		Citizen.Wait(0)

		BeginTextCommandBusyspinnerOn('STRING')
		AddTextComponentSubstringPlayerName(msg)
		EndTextCommandBusyspinnerOn(type)
		Citizen.Wait(time)

		BusyspinnerOff()
	end)
end

function cleanPlayer(playerPed)
	ESX.SetPedArmour(playerPed, 0)
	ClearPedBloodDamage(playerPed)
	ResetPedVisibleDamage(playerPed)
	ClearPedLastWeaponDamage(playerPed)
	ResetPedMovementClipset(playerPed, 0)
end

function GetAuthorizedJobVehicles(type)
	local p = promise.new()
	ESX.TriggerServerCallback('esx_society:getJobvehicle2', function(vehicles)
		_vehicles = {}
		for k, v in pairs(vehicles) do
			if v.type == type then
				table.insert(_vehicles, v)
			end
		end
        p:resolve(_vehicles)
    end)
	return Citizen.Await(p)
end

function getPlayerSkin()
	local p = promise.new()
	ESX.TriggerServerCallback('esx_society:getPlayerSkin', function(skin, jobSkin, divisionCloth)
		p:resolve({skin = skin, jobSkin = jobSkin, divisionCloth = divisionCloth})
	end)
	local data = Citizen.Await(p)

	return data.skin, data.jobSkin, next(data.divisionCloth) and data.divisionCloth or nil
end

function setUniform(job, ped, jobSkin, setArmor)
	TriggerEvent('skinchanger:getSkin', function(skin)
        if setArmor then
            ESX.SetPedArmour(ped, ESX.GetPlayerData().MaxArmour or 100)
            ESX.TriggerServerEvent('policejob:setSCState',true)
            TriggerEvent('skinchanger:loadClothes', skin, Shared?[job]?.uniforms?["bullet_wear"]?.male)
        end

		if skin.sex == 0 then
			TriggerEvent('skinchanger:loadClothes', skin, jobSkin.skin_male)
		else
			TriggerEvent('skinchanger:loadClothes', skin, jobSkin.skin_female)
		end
	end)
end

function deleteVehicle()
	if ESX.isVehicleDriver() then
		ESX.Game.DeleteVehicle(ESX.isVehicleDriver())
	else
		ESX.ShowNotification('Savar mashini nistid')
	end
end

function openBilling()
		exports['sun-billing']:openGhabzMenu(ESX.PlayerData.job.name)
end

function saveClothe(job, job2)
    SetResourceKvp('savedJobClothe_'.. ESX.serverNum, job or '')
    SetResourceKvp('savedJobClothe2_'.. ESX.serverNum, job2 or '')
end
exports('saveClothe', saveClothe)

AddEventHandler('sun:clotheLoaded', function()
    Wait(5000)
    while not playerLoaded do Wait(1000) end
    local job = GetResourceKvpString('savedJobClothe_'.. ESX.serverNum)
    local job2 = GetResourceKvpString('savedJobClothe2_'.. ESX.serverNum)
    if job ~= '' then
        if job2 == '' then
            job2 = nil
        end
        if ESX.PlayerData.job.name == job then
            TriggerEvent('job:loadClothe', job, job2)
        end
    end
end)

RegisterNetEvent('job:loadClothe', function(job, job2)
    ESX.TriggerServerCallback('esx_society:getPlayerSkin', function(skin, jobSkin, divisionSkin)
        -- if job == 'taxi' or job == 'mechanic' or job == 'ambulance' then
            if job2 and job2 ~= 'police_wear' then
                if skin.sex == 0 then
					TriggerEvent('skinchanger:loadClothes', skin, divisionSkin.skin_male)
				else
					TriggerEvent('skinchanger:loadClothes', skin, divisionSkin.skin_female)
				end
                if ESX.militaryJobs2[job] then
                    if job:lower():find('swat') then
                        TriggerEvent(job .. ':setSwatState', true)
                    end
                end
            else
                if skin.sex == 0 then
					TriggerEvent('skinchanger:loadClothes', skin, jobSkin.skin_male)
				else
					TriggerEvent('skinchanger:loadClothes', skin, jobSkin.skin_female)
				end
            end
        -- elseif job == 'police' or job == 'sheriff' or job == 'fbi' or job == 'mt' then

        -- end
    end)
end)

function divisionsMenu()
    ESX.TriggerServerCallback('job:getDivision',function(cb)
        elements = {}
        table.insert(elements,{label = '----List Division haye shoma----'})
        for k , v in pairs(cb) do
            table.insert(elements,{label = k:gsub("^%l", string.upper),value = k})
        end

        ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'unit_work',
        {
            title    = 'Division',
            align    = 'top-left',
            elements = elements
        }, function(data2, menu2)
            if data2.current.value then
                TriggerServerEvent('job:setDivision', data2.current.value)
            end
        end, function(data2, menu2)
            menu2.close()
        end)
    end)
end
exports('divisionsMenu', divisionsMenu)

function openSpawnSubMenu(boatColor, petModel)
	local elements = {
		{label = 'Ghayegh badi', value = 'boat'},
		{label = 'Mask Ghavasi', value = 'mask'},
		{label = 'Spawn Object', value = 'object'},
	}
	if petModel then
		table.insert(elements, {label = 'Spawn Pet', value = 'pet'})
	end
	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'spawn_sub', {
		title = 'Utilities',
		align = 'top-left',
		elements = elements,
	}, function(data, menu)
		local v = data.current.value
		menu.close()
		if v == 'boat' then
			exports['sunset_utils']:ghayeghBadi(true, boatColor)
		elseif v == 'mask' then
			local coords = GetEntityCoords(PlayerPedId())
			local inwater = GetWaterHeight(ESX.Math.Round(coords.x, 1), ESX.Math.Round(coords.y, 1), ESX.Math.Round(coords.z, 1))
			if inwater ~= 1 then
				ESX.Alert('Error', 'Shoma dar nazdiki ab nistid!', 5000, 'error')
				return
			end
			local darsad = LocalPlayer.state.oxygenMaskDarsad or 0
			if darsad > 10 then
				ESX.Alert('Error', ('Hanooz oxygen mask feali darid (%s%%)'):format(darsad), 5000, 'error')
				return
			end
			exports['sunset_utils']:oxygenMask()
		elseif v == 'object' then
			openSpawnObject()
		elseif v == 'pet' then
			if doesNearAnyStation(100) then
				exports['sunset_utils']:spawnTemporaryPet(petModel)
			else
				ESX.chatMessage('Baraye spawn pet bayad nazdik station bashid', 'job')
			end
		end
	end, function(data, menu)
		menu.close()
	end)
end

function openSpawnObject()
	ESX.UI.Menu.CloseAll()
	if jobConfig.config.objects then
		local options = {'None'}
		local args = {'None'}
		for k, v in pairs(jobConfig.config.objects) do
			if not v.grade or ESX.PlayerData.job.grade >= v.grade then
				table.insert(options, v.label)
				table.insert(args, v)
			end
		end
		lib.setMenuOptions('spawnObject', {
			{label = 'Object :', values = options, args = args}
		})
    	lib.showMenu('spawnObject')
	end
end

AddStateBagChangeHandler('spawnJob', nil, function(bagName, k, v)
    local entity = GetEntityFromStateBagName(bagName)
    if entity ~= 0 then
		if v == ESX.PlayerData.job.name then
			exports['ox_target']:addLocalEntity({entity},{
                {
					label = 'برداشتن',
					onSelect = function(entity)
						entity = entity.entity
						ESX.Game.DeleteEntity(entity)
					end,
				},
            })
		end
	end
end)

function dpemtoes(state)
	LocalPlayer.state:set('noAnim', not state, false)
	TriggerEvent('dpemote:enable', state)
end

RegisterCommand('delobjectjob', function()
	if ESX.PlayerData.job.name ~= 'nojob' then
		local objects, entity, distance = ESX.Game.GetObjects()
		local coords = GetEntityCoords(PlayerPedId())
		for k, v in pairs(objects) do
			if Entity(v).state.spawnJob == ESX.PlayerData.job.name then
				if not distance or distance > #(coords - GetEntityCoords(v)) then
					distance = #(coords - GetEntityCoords(v))
					entity = v
				end
			end
		end
		if entity then
			ESX.Game.DeleteEntity(entity)
			ESX.chatMessage(('^2%s^0 delete shod'):format(entity), 'plarms')
		else
			ESX.chatMessage('Objecti yaft nashod!', 'plarms')
		end
	end
end, false)

function openLicenseMenu()
	exports['sunset_utils']:openLicenseMenu()
end