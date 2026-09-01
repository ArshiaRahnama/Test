local ekhtarcool = false
local dakhelheli = false
local Keys = {
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

local PlayerData              = {}
local HasAlreadyEnteredMarker = false
local LastStation             = nil
local LastPart                = nil
local LastPartNum             = nil
local LastEntity              = nil
local CurrentAction           = nil
local CurrentActionMsg        = ''
local CurrentActionData       = {}
local IsHandcuffed            = false
local HandcuffTimer           = {}
local FrontHandCuffed 		  = false
local DragStatus              = {}
DragStatus.IsDragged          = false
local hasAlreadyJoined        = false
local isDead                  = false
local CurrentTask             = {}
local playerInService         = false
local Busy = false
local BackupX = nil
local BackupY = nil
local showit = false
local ASTimer = 0
local callsign = nil
local Draging 				  = false
local dragiss                 = false

ESX                           = nil

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end

	while ESX.GetPlayerData().job == nil do
		Citizen.Wait(10)
	end

	PlayerData = ESX.GetPlayerData()
	if PlayerData.job and PlayerData.job.name == "police" then
        mainThreads_police()
    end

end)
-- Vehicles added live via esx_society's /addcarjob command (job = police) get merged
-- into the static AuthorizedVehicles catalog, and their livery (captured at add-time)
-- is always re-applied on spawn so it never changes.
local CustomVehicleLiveries  = {}
local InjectedVehicleEntries = {}
local InjectedHeliEntries    = {}

local function removeInjected_police(list, injected)
	for _, entry in ipairs(injected) do
		for i = #list, 1, -1 do
			if list[i] == entry then
				table.remove(list, i)
			end
		end
	end
end

Citizen.CreateThread(function()
	while ESX == nil do Citizen.Wait(10) end

	local function mergeCustomVehicles()
		ESX.TriggerServerCallback('esx_society:getCustomVehicles', function(list)
			removeInjected_police(Config_police.AuthorizedVehicles.Shared, InjectedVehicleEntries)
			removeInjected_police(Config_police.AuthorizedVehicles.Sharedheli, InjectedHeliEntries)
			InjectedVehicleEntries = {}
			InjectedHeliEntries    = {}
			CustomVehicleLiveries  = {}

			local custom = list and list['police']
			if not custom then return end

			for _, v in ipairs(custom) do
				local entry = {label = v.label, model = v.model}

				if v.is_heli == 1 then
					table.insert(Config_police.AuthorizedVehicles.Sharedheli, entry)
					table.insert(InjectedHeliEntries, entry)
				else
					table.insert(Config_police.AuthorizedVehicles.Shared, entry)
					table.insert(InjectedVehicleEntries, entry)
				end

				CustomVehicleLiveries[v.model] = tonumber(v.livery) or 0
			end
		end)
	end

	mergeCustomVehicles()

	RegisterNetEvent('society:customVehiclesUpdated')
	AddEventHandler('society:customVehiclesUpdated', mergeCustomVehicles)
end)


carry = {
	Requested = false,
	InProgress = false,
	targetSrc = -1,
	type = "",
	personCarrying = {
		animDict = "missfinale_c2mcs_1",
		anim = "fin_c2_mcs_1_camman",
		flag = 49,
	},
	personCarried = {
		animDict = "nm",
		anim = "firemans_carry",
		attachX = 0.27,
		attachY = 0.15,
		attachZ = 0.63,
		flag = 33,
	}
}

function SetVehicleMaxMods_police(vehicle)
	local props = {
		modEngine       = 5,
		modBrakes		= 5,
		windowTint		= 2,
		modArmor		= 5,
		modTransmission = 2,
		modSuspension   = 4,
		plateIndex      = 1,
		modTurbo        = true,
	}

	ESX.Game.SetVehicleProperties(vehicle, props)
	SetVehicleDirtLevel(vehicle, 0.0)
end

function SetVehicleMaxMods2_police(vehicle)
	local props = {
		modEngine       = 5,
		modBrakes		= 5,
		windowTint		= 0,
		modArmor		= 5,
		modTransmission = 2,
		modSuspension   = 4,
		plateIndex      = 1,
		modTurbo        = true,
	}

	ESX.Game.SetVehicleProperties(vehicle, props)
	SetVehicleDirtLevel(vehicle, 0.0)
end

function SetVehicleMaxMods3_police(vehicle)
	local props = {
		modEngine       = 5,
		modBrakes		= 5,
		windowTint		= 1,
		modArmor		= 5,
		modTransmission = 2,
		color1 			= 0,
		color2		 	= 0,
		pearlescentColor = 0,
		modSuspension   = 4,
		modTurbo        = true,
	}


	ESX.Game.SetVehicleProperties(vehicle, props)
	SetVehicleDirtLevel(vehicle, 0.0)
end

function SetVehicleMaxMods4_police(vehicle)
	local props = {
		modEngine       =   3,
		modBrakes       =   2,
		windowTint      =  -1,
		modArmor        =   4,
		modTransmission =   2,
		modSuspension   =   -1,
		modTurbo        =   true,
	}


	ESX.Game.SetVehicleProperties(vehicle, props)
	SetVehicleDirtLevel(vehicle, 0.0)
end

function SetVehicleMaxMods5_police(vehicle)
    local props = {
        modEngine       = 3,
        modBrakes		= 4,
        windowTint		=-1,
        modArmor		= 4,
        modTransmission = 2,
        modSuspension   = 3,
        modTurbo        = true,
    }

    ESX.Game.SetVehicleProperties(vehicle, props)
    SetVehicleDirtLevel(vehicle, 0.0)
end

function SetVehicleMaxMods6_police(vehicle)
    local props = {
        modEngine       = 3,
        modBrakes		= 4,
        windowTint		=-1,
        modArmor		= 4,
		modTransmission = 2,
		color1 			= 111,
		color2 			= 111,
		pearlescentColo = 111,
        modSuspension   = 3,
        modTurbo        = true,
    }

    ESX.Game.SetVehicleProperties(vehicle, props)
    SetVehicleDirtLevel(vehicle, 0.0)
end

function cleanPlayer_police(playerPed)
	SetPedArmour(playerPed, 0)
	ClearPedBloodDamage(playerPed)
	ResetPedVisibleDamage(playerPed)
	ClearPedLastWeaponDamage(playerPed)
	ResetPedMovementClipset(playerPed, 0)
end

function setUniform_police(job, playerPed)

	TriggerEvent('skinchanger:getSkin', function(skin)
	if tonumber(skin.sex) == 0 then

			if Config_police.Uniforms[job].male ~= nil then
				TriggerEvent('skinchanger:loadClothes', skin, Config_police.Uniforms[job].male)
			else
				ESX.ShowNotification(_U('no_outfit'))
			end

	elseif tonumber(skin.sex) == 1 then

			if Config_police.Uniforms[job].female ~= nil then
				TriggerEvent('skinchanger:loadClothes', skin, Config_police.Uniforms[job].female)
			else
				ESX.ShowNotification(_U('no_outfit'))
			end

		end

	end)
end

function setvest_police(uniform, playerPed)
    TriggerEvent('skinchanger:getSkin', function(skin)
        if skin.sex == 0 then
			if uniform == '1' then
				un = {bproof_1 = 12,bproof_2 = 0}
			elseif uniform == '2' then
				un = {bproof_1 = 18,bproof_2 = 0}
			elseif uniform == '3' then
				un = {bproof_1 = 15,bproof_2 = 2}
			end
        else
			if uniform == '1' then
				un = {bproof_1 = 7,bproof_2 = 0}
			elseif uniform == '2' then
				un = {bproof_1 = 37,bproof_2 = 0}
			elseif uniform == '3' then
				un = {bproof_1 = 42,bproof_2 = 0}
			end
        end
		TriggerEvent('skinchanger:loadClothes', skin, un)
        SetPedArmour(playerPed, 100)
    end)
end

AddEventHandler('esx_policejob:hasExitedEntityZone', function(entity)
	if CurrentAction == 'remove_entity' then
		CurrentAction = nil
	end
end)

function OpenCloakroomMenu_police()

	ESX.TriggerServerCallback('esx_society:divisionsPlayer', function(check)
        local elements = {}
		local nname = {}
		local playerPed = PlayerPedId()
		local grade = PlayerData.job.grade_name
		local dvisname
		local elements = {
			{label = "Lebas Kar", value = 'work_wear'},
			{ label = _U('citizen_wear'), value = 'citizen_wear' },

			{label = 'Vest', value = 'wmenu'}
		}

        for k, v in pairs(check) do

            if v.status == true then
                table.insert(elements, {
                    label = 'Lebas Division',
					diviname = v.name,
					value = 'division_lebas',

                })
            end

        end


		ESX.UI.Menu.CloseAll()

		ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'cloakroom',
		{
			title    = _U('cloakroom'),
			align    = 'left',
			elements = elements
		}, function(data, menu)

			cleanPlayer_police(playerPed)

			if data.current.value == 'citizen_wear' then

				ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin)
					TriggerEvent('skinchanger:loadSkin', skin)
				end)
			end

			if data.current.value == 'work_wear' then
				local job =  PlayerData.job.name
				local gradenum =  PlayerData.job.grade




				ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin)
					ESX.TriggerServerCallback('esx_society:getUniforms', function(SkinMale, SkinFemale)

						if skin.sex == 0 then
							TriggerEvent('skinchanger:loadClothes', skin, SkinMale)
						else
							TriggerEvent('skinchanger:loadClothes', skin, SkinFemale)
						end

					end,gradenum, job)

				end)


			end
			if data.current.value == 'wmenu' then

				SetPedArmour(playerPed, 100)



















			end

			if data.current.value == 'division_lebas' then

				ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin)
					local job =  PlayerData.job.name
					ESX.TriggerServerCallback('esx_society:getUniformsDivision', function(SkinMale, SkinFemale)
						if skin.sex == 0 then
							TriggerEvent('skinchanger:loadClothes', skin, SkinMale)
						else
							TriggerEvent('skinchanger:loadClothes', skin, SkinFemale)
						end
					end, data.current.diviname, job)

				end)
			end

		end, function(data, menu)
			menu.close()

			CurrentAction     = 'menu_cloakroom'
			CurrentActionMsg  = _U('open_cloackroom')
			CurrentActionData = {}
		end)
	end)
end

function OpenArmoryMenu_police(station)

	local elements = {
		{label = _U('get_weapon'),     value = 'get_weapon'},
		{label = _U('put_weapon'),     value = 'put_weapon'},
		{label = _U('remove_object'),  value = 'get_stock'},
		{label = _U('deposit_object'), value = 'put_stock'}
	}

	if PlayerData.job.grade >= 16 then
		table.insert(elements, {label = _U('buy_weapons'), value = 'buy_weapons'})
		table.insert(elements, {label = _U('buy_items'), value = 'buy_items'})
	end

	ESX.UI.Menu.CloseAll()

	ESX.UI.Menu.Open(
	'default', GetCurrentResourceName(), 'armory',
	{
		title    = _U('armory'),
		align    = 'left',
		elements = elements,
	},
	function(data, menu)

		if data.current.value == 'get_weapon' then
			OpenGetWeaponMenu_police()
		end

		if data.current.value == 'put_weapon' then
			OpenPutWeaponMenu_police()
		end

		if data.current.value == 'buy_weapons' then
			OpenBuyWeaponsMenu_police(station)
		end

		if data.current.value == 'buy_items' then
			OpenBuyItemsMenu_police(station)
		end

		if data.current.value == 'put_stock' then
			OpenPutStocksMenu_police()
		end

		if data.current.value == 'get_stock' then
			OpenGetStocksMenu_police()
		end

	end,
	function(data, menu)

		menu.close()

		CurrentAction     = 'menu_armory'
		CurrentActionMsg  = _U('open_armory')
		CurrentActionData = {station = station}
	end
	)
end

function OpenBuyItemsMenu_police(station)

	ESX.TriggerServerCallback('esx_policejob:getStockItems', function(weapons)

		local elements = {}

		for i=1, #Config_police.PoliceStations[station].AuthorizedItems, 1 do

		local weapon = Config_police.PoliceStations[station].AuthorizedItems[i]
		local count  = 0

		for i=1, #weapons, 1 do
			if weapons[i].name == weapon.name then
			count = weapons[i].count
			break
			end
		end

		table.insert(elements, {label = 'x' .. count .. ' ' .. weapon.label .. ' $' .. weapon.price, value = weapon.name, price = weapon.price})

		end

		ESX.UI.Menu.Open(
		'default', GetCurrentResourceName(), 'armory_buy_weapons',
		{
			title    = _U('buy_item_menu'),
			align    = 'left',
			elements = elements,
		},
		function(data, menu)
			local tedad = lib.inputDialog('Enter Buy Weapon', {'Tedad Weapon (1 , 99)'}, {max = 2})
			if not tedad then return end
			cuntt = json.encode(tedad)
			ESX.TriggerServerCallback('esx_policejob:buy', function(hasEnoughMoney)

				if hasEnoughMoney then
					ESX.TriggerServerCallback('esx_policejob:buyArmoryItem', function()
						OpenBuyItemsMenu_police(station)

						local steamHex = ESX.GetPlayerData().identifier

						TriggerServerEvent('logpdBuyItem', ESX.GetPlayerData().name, GetPlayerServerId(PlayerId()), steamHex, data.current.label, math.floor(tonumber(tedad[1])), data.current.price * math.floor(tonumber(tedad[1])))
					end, data.current.value, false, math.floor(tonumber(tedad[1])))

				end

			end, data.current.price *  math.floor(tonumber(tedad[1])))

		end,
		function(data, menu)
			menu.close()

		end
		)

	end)
end

function OpenVehicleSpawnerMenu_police(station, partNum)
	local vehicles = Config_police.PoliceStations[station].Vehicles
	ESX.UI.Menu.CloseAll()

	local elements = {}
	local elements2 = {}

	local grade = ESX.GetPlayerData().job.grade
	local job = ESX.GetPlayerData().job.name
	local steamhex = ESX.GetPlayerData().identifier
	ESX.TriggerServerCallback('esx_society:getVehicles', function(authorizedVehicle)

		ESX.TriggerServerCallback('esx_society:GetDivisionsPlayer', function(getdivision)
			dvisionName = nil

			for k,v in pairs(getdivision) do
				if v.status and v.job == job then


					dvisionName = v.name
				end
			end
			ESX.TriggerServerCallback('esx_society:getVehiclesdivision', function(authorizedVehicledivision)


				local found = false

				if authorizedVehicle ~= nil then
					local Vehicles = Config_police.AuthorizedVehicles.Shared
					for i = 1, #Vehicles, 1 do
					local found = false


					if authorizedVehicle ~= nil then
						for _,sharedVeh in ipairs(authorizedVehicle) do
							if found then break end
								if sharedVeh.model == Vehicles[i].model and sharedVeh.status == true then
									table.insert(elements, {label = Vehicles[i].label, model = Vehicles[i].model})
									found = true


								end
							end

						end
					end

				end

				if authorizedVehicledivision then
					table.insert(elements, {label = '------ Division ------', model = nil})
					local nnname = nil
					local Vehicles2 = Config_police.AuthorizedVehicles.Shared
					for i = 1, #Vehicles2, 1 do
						nnname = nil
						for t,vehs in pairs(authorizedVehicledivision) do
							for k,v in pairs(elements) do
								if vehs.status and Vehicles2[i].model == vehs.model then
									if v.model == vehs.model then
										nnname = nil
										break
									else
										nnname = vehs.model
									end
								end
							end
							if nnname then

								table.insert(elements, {label = Vehicles2[i].label, model = Vehicles2[i].model})
								break
							end
						end
					end
				end
				while elements == nil do Wait(1) end
				ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'vehicle_spawner',
				{
					title    = _U('vehicle_menu'),
					align    = 'left',
					elements = elements
				}, function(data, menu)
					menu.close()

					local model   = data.current.model

					if model then
						if not DoesEntityExist(vehicle) then

							local playerPed = PlayerPedId()

							local function requestPlate()
								local plate = lib.inputDialog('Enter Vehicle Plate', {'Plate (6 characters)'}, {max = 6})
								if plate and plate[1] then
									plate[1] = string.upper(plate[1])

									ESX.TriggerServerCallback('checkPlateInServer', function(plateExists)
										if plateExists then

											local alert = lib.alertDialog({
												header = 'Az In Plake Qablan Estefadeh Shode',
												content = 'Aya Mikhahid Hazf Shavad?',
												centered = true,
												cancel = true
											})
											if alert == 'confirm' then
												ESX.TriggerServerCallback('deletevehiclejob', function(plate)
													TriggerEvent('chat:addMessage', {
														args = {'^1SYSTEM', 'Mashin be moafaghiat hazf shod'}
													})
												end, "PD" .. plate[1])
												menu.close()

												Wait(1000)
												spawnvehicles_police(data, plate, vehicle, station, partNum)

											else
												TriggerEvent('chat:addMessage', {
													args = {'^1SYSTEM', 'Cancel Shod'}
												})

											end
										else
											if #plate[1] == 6 then
												menu.close()

												spawnvehicles_police(data, plate, vehicle, station, partNum)
											else
												TriggerEvent('chat:addMessage', {
													args = {'^1SYSTEM', 'Plake Mashin Bayad 6 Character Bashad'}
												})
												requestPlate()
											end
										end
									end, "PD" .. plate[1])
								end
							end
							requestPlate()
						else
							ESX.ShowNotification(_U('vehicle_out'))
						end
					end

				end, function(data, menu)
					menu.close()

					CurrentAction     = 'menu_vehicle_spawner'
					CurrentActionMsg  = _U('vehicle_spawner')
					CurrentActionData = {station = station, partNum = partNum}

				end)
			end, dvisionName, job)
		end, steamhex)
	end, grade, job)
end

function OpenGetWeaponMenu_police()
	local PlayerData = ESX.GetPlayerData()
    local grade = PlayerData.job.grade
    local job = PlayerData.job.name

    ESX.TriggerServerCallback('esx_policejob:getArmoryWeapons', function(weapons)

        ESX.TriggerServerCallback('esx_society:GetDivisionsPlayer', function(getdivision)

            ESX.TriggerServerCallback('esx_society:getWeapons', function(authorizedWeapons)

                local dvisionName = GetDivisionName_police(getdivision, job)

                ESX.TriggerServerCallback('esx_society:getWeaponsdivisions', function(authorizedweaponsdivision)
                    local elements = {}
                    local playerid = PlayerPedId()

                    for _, weapon in ipairs(authorizedWeapons) do
                        if weapon.model and weapon.status then
                            for _, armoryWeapon in ipairs(weapons) do
                                if armoryWeapon.name == weapon.model and armoryWeapon.count >= 1 then
                                    local weaponHash = GetHashKey(weapon.model)
                                    if not HasPedGotWeapon(playerid, weaponHash, false) then
                                        local wname = ESX.GetWeaponLabel(weapon.model)
                                        table.insert(elements, {label = wname .. " [ " .. armoryWeapon.count .. " ]", value = weapon.model})
                                    end
                                end
                            end
                        end
                    end

					if authorizedweaponsdivision then
						table.insert(elements, {label = '------ Division ------', model = nil})
						for _, divisionWeapon in ipairs(authorizedweaponsdivision) do
							local weaponHash = GetHashKey(divisionWeapon.model)
							if not HasPedGotWeapon(playerid, weaponHash, false) then
								local alreadyAdded = false
								for _, element in ipairs(elements) do
									if element.value == divisionWeapon.model then
										alreadyAdded = true
										break
									end
								end
								if not alreadyAdded then

									local weaponCount = 0
									for _, armoryWeapon in ipairs(weapons) do
										if armoryWeapon.name == divisionWeapon.model then
											weaponCount = armoryWeapon.count
											break
										end
									end

									local wname = ESX.GetWeaponLabel(divisionWeapon.model)

									table.insert(elements, {label = wname .. " [ " .. weaponCount .. " ]", value = divisionWeapon.model})
								end
							end
						end
					end


                    ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'armory_get_weapon', {
                        title = _U('get_weapon_menu'),
                        align = 'left',
                        elements = elements
                    }, function(data, menu)
                        menu.close()

                        local playerPed = PlayerPedId()
                        local weaponHash = GetHashKey(data.current.value)

                        if HasPedGotWeapon(playerPed, weaponHash, false) then
                            ESX.ShowNotification('~r~Shoma In Gan Ro Darid!')
                            OpenGetWeaponMenu_police()
                        else
                            ESX.TriggerServerCallback('esx_policejob:removeArmoryWeapon', function()

								local steamHex = ESX.GetPlayerData().identifier
								local weaponModel = data.current.value
								local weaponLabel = ESX.GetWeaponLabel(weaponModel)

								local playerPed = PlayerPedId()
								local ammoCount = GetAmmoInPedWeapon(playerPed, GetHashKey(weaponModel))

								TriggerServerEvent('logpdGetWeapon', ESX.GetPlayerData().name, GetPlayerServerId(PlayerId()), steamHex, weaponLabel, ammoCount)

                                OpenGetWeaponMenu_police()
                            end, data.current.value)
                        end
                    end, function(data, menu)
                        menu.close()

                    end)
                end, dvisionName, job)
            end, grade, job)
        end, PlayerData.identifier)
    end)
end

function GetDivisionName_police(getdivision, job)
    for _, division in ipairs(getdivision) do
        if division.status and division.job == job then
            return division.name
        end
    end
    return nil
end

function OpenheliSpawnerMenu_police(station, partNum)
	local vehicles = Config_police.PoliceStations[station].Helicopters
	ESX.UI.Menu.CloseAll()

	local elements = {}
	local elements2 = {}

	local grade = PlayerData.job.grade
	local job = PlayerData.job.name
	ESX.TriggerServerCallback('esx_society:getHelis', function(authorizedVehicle)
		ESX.TriggerServerCallback('esx_society:GetDivisionsPlayer', function(getdivision)
			dvisionName = nil
			for k,v in pairs(getdivision) do
				if v.status and v.job == job then


					dvisionName = v.name
				end
			end
			ESX.TriggerServerCallback('esx_society:getHelisdivision', function(authorizedVehicledivision)


				local found = false

				if authorizedVehicle ~= nil then
					local Vehicles = Config_police.AuthorizedVehicles.Sharedheli
					for i = 1, #Vehicles, 1 do
					local found = false


					if authorizedVehicle ~= nil then
						for _,sharedVeh in ipairs(authorizedVehicle) do
							if found then break end
								if sharedVeh.model == Vehicles[i].model and sharedVeh.status == true then
									table.insert(elements, {label = Vehicles[i].label, model = Vehicles[i].model})
									found = true


								end
							end

						end
					end

				end

				if authorizedVehicledivision then
					table.insert(elements, {label = '------ Division ------', model = nil})
					local nnname = nil
					local Vehicles2 = Config_police.AuthorizedVehicles.Sharedheli
					for i = 1, #Vehicles2, 1 do
						nnname = nil
						for t,vehs in pairs(authorizedVehicledivision) do
							for k,v in pairs(elements) do
								if vehs.status and Vehicles2[i].model == vehs.model then
									if v.model == vehs.model then
										nnname = nil
										break
									else
										nnname = vehs.model
									end
								end
							end
							if nnname then

								table.insert(elements, {label = Vehicles2[i].label, model = Vehicles2[i].model})
								break
							end
						end
					end
				end
				while elements == nil do Wait(1) end
				ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'vehicle_spawner',
				{
					title    = 'heli menu',
					align    = 'left',
					elements = elements
				}, function(data, menu)
					menu.close()

					local model   = data.current.model

					if model then
						if not DoesEntityExist(vehicle) then

							local playerPed = PlayerPedId()

							local function requestPlate()
								local plate = lib.inputDialog('Enter Heli Plate', {'Plate (6 characters)'}, {max = 6})
								if plate and plate[1] then
									plate[1] = string.upper(plate[1])

									ESX.TriggerServerCallback('checkPlateInServer', function(plateExists)
										if plateExists then

											local alert = lib.alertDialog({
												header = 'Az In Plake Qablan Estefadeh Shode',
												content = 'Aya Mikhahid Hazf Shavad?',
												centered = true,
												cancel = true
											})
											if alert == 'confirm' then
												ESX.TriggerServerCallback('deletevehiclejob', function(plate)
													TriggerEvent('chat:addMessage', {
														args = {'^1SYSTEM', 'Heli be moafaghiat hazf shod'}
													})
												end, "PD" .. plate[1])
												menu.close()

												Wait(1000)
												spawnheliss_police(data, plate, vehicle, station, partNum)

											else
												TriggerEvent('chat:addMessage', {
													args = {'^1SYSTEM', 'Cancel Shod'}
												})

											end
										else
											if #plate[1] == 6 then
												menu.close()

												spawnheliss_police(data, plate, vehicle, station, partNum)
											else
												TriggerEvent('chat:addMessage', {
													args = {'^1SYSTEM', 'Plake Heli Bayad 6 Character Bashad'}
												})
												requestPlate()
											end
										end
									end, "PD" .. plate[1])
								end
							end

							requestPlate()
						else
							ESX.ShowNotification(_U('heli_out'))
						end
					end

				end, function(data, menu)
					menu.close()

					CurrentAction     = 'menu_heli_spawner'
					CurrentActionMsg  = _U('heli_spawner')
					CurrentActionData = {station = station, partNum = partNum}

				end)
			end, dvisionName, job)
		end, PlayerData.identifier)
	end, grade, job)
end

function spawnheliss_police(data, plate, vehicle, station, partNum)
	plate[1] = string.upper(plate[1])
	local vehicles = Config_police.PoliceStations[station].Helicopters
	local vehicle = GetClosestVehicle(vehicles[partNum].SpawnPoint.x, vehicles[partNum].SpawnPoint.y, vehicles[partNum].SpawnPoint.z, 3.0, 0, 71)
	ESX.Game.SpawnVehicleJobs(data.current.model, vehicles[partNum].SpawnPoint, vehicles[partNum].Heading, function(vehicle)
		if vehicle then

			local playerPed = PlayerPedId()
			if data.current.model == "insurgent2" or data.current.model == "riot2" or data.current.model == "riot" or data.current.model == "fbi2" or data.current.model == "fbi" then
				SetVehicleMaxMods2_police(vehicle)
			elseif data.current.model == "polschafter3" then
				SetVehicleMaxMods_police(vehicle, 1)
			elseif data.current.model == "polchar" or data.current.model == "poltah" or data.current.model == "poltaurus" or data.current.model == "polvic" then
				SetVehicleMaxMods_police(vehicle, 1)
				SetVehicleLivery(vehicle, 1)
			elseif data.current.model == "polraptor" then
				SetVehicleMaxMods_police(vehicle, 1)
				SetVehicleLivery(vehicle, 2)
			else
				SetVehicleMaxMods_police(vehicle, callsign, -1)
			end

			local Vehicles2 = Config_police.AuthorizedVehicles.Shared
			for _, vehicle2 in ipairs(Vehicles2) do
				if vehicle2.Extra and vehicle2.model == data.current.model then
					for extraName, extraValue in pairs(vehicle2.Extra) do
						SetVehicleExtra(vehicle, tonumber(extraName), tonumber(extraValue))
					end
				end
			end



			SetVehicleLivery(vehicle, 0)
			Citizen.Wait(500)
			SetVehicleLivery(vehicle, 0)
			if CustomVehicleLiveries[data.current.model] then
				SetVehicleLivery(vehicle, CustomVehicleLiveries[data.current.model])
			end

			TaskWarpPedIntoVehicle(playerPed, vehicle, -1)
			Citizen.Wait(500)
			SetVehicleFuelLevel(vehicle, 100.0)
			SetVehicleMaxMods_police(vehicle)
			SetVehicleNumberPlateText(vehicle, "PD" ..plate[1] )

			local playerIdentifier = ESX.GetPlayerData().identifier
			local vehicleModel = GetEntityModel(CurrentActionData.vehicle)
			local vehicleLabel = GetLabelText(GetDisplayNameFromVehicleModel(vehicleModel))
			local playerPed = PlayerPedId()
			local xPlayer = ESX.GetPlayerData()

            TriggerServerEvent('logpdVehicleSpawn', xPlayer.name, GetPlayerServerId(PlayerId()), playerIdentifier, vehicleLabel, "PD" .. plate[1], true)



			TriggerEvent('chat:addMessage', {
				args = {'^1SYSTEM', 'Heli Ba Plake^2 PD'..plate[1]..' ^0Spawn Shod'}
			})
		else
			TriggerEvent('chat:addMessage', {
				args = {'^1SYSTEM', 'Spawn Heli Na Movafaq'}
			})

		end
	end)

end

function spawnvehicles_police(data, plate, vehicle, station, partNum)
	plate[1] = string.upper(plate[1])
	local vehicles = Config_police.PoliceStations[station].Vehicles
	local vehicle = GetClosestVehicle(vehicles[partNum].SpawnPoint.x, vehicles[partNum].SpawnPoint.y, vehicles[partNum].SpawnPoint.z, 3.0, 0, 71)
	ESX.Game.SpawnVehicleJobs(data.current.model, vehicles[partNum].SpawnPoint, vehicles[partNum].Heading, function(vehicle)
		if vehicle then

			local playerPed = PlayerPedId()
			if data.current.model == "insurgent2" or data.current.model == "riot2" or data.current.model == "riot" or data.current.model == "fbi2" or data.current.model == "fbi" then
				SetVehicleMaxMods2_police(vehicle)
			elseif data.current.model == "polschafter3" then
				SetVehicleMaxMods_police(vehicle, 1)
			elseif data.current.model == "polchar" or data.current.model == "poltah" or data.current.model == "poltaurus" or data.current.model == "polvic" then
				SetVehicleMaxMods_police(vehicle, 1)
				SetVehicleLivery(vehicle, 1)
			elseif data.current.model == "polraptor" then
				SetVehicleMaxMods_police(vehicle, 1)
				SetVehicleLivery(vehicle, 2)
			else
				SetVehicleMaxMods_police(vehicle, callsign, -1)
			end

			local Vehicles2 = Config_police.AuthorizedVehicles.Shared
			for _, vehicle2 in ipairs(Vehicles2) do
				if vehicle2.Extra and vehicle2.model == data.current.model then
					for extraName, extraValue in pairs(vehicle2.Extra) do
						SetVehicleExtra(vehicle, tonumber(extraName), tonumber(extraValue))
					end
				end
			end

			if data.current.label == "Police Charger2" or data.current.label == "Police Tau2" then
				SetVehicleLivery(vehicle, 7)
				Citizen.Wait(500)
				SetVehicleLivery(vehicle, 7)
				SetVehicleMaxMods2_police(vehicle)
			else
				SetVehicleLivery(vehicle, 0)
				Citizen.Wait(500)
				SetVehicleLivery(vehicle, 0)
				SetVehicleMaxMods_police(vehicle)
			end


			if CustomVehicleLiveries[data.current.model] then
				SetVehicleLivery(vehicle, CustomVehicleLiveries[data.current.model])
			end

			TaskWarpPedIntoVehicle(playerPed, vehicle, -1)
			Citizen.Wait(500)
			SetVehicleRadioEnabled(vehicle, false)
			SetVehicleFuelLevel(vehicle, 100.0)

			SetVehicleNumberPlateText(vehicle, "PD" ..plate[1] )

			local playerIdentifier = ESX.GetPlayerData().identifier
			local vehicleModel = GetEntityModel(CurrentActionData.vehicle)
			local vehicleLabel = GetLabelText(GetDisplayNameFromVehicleModel(vehicleModel))
			local playerPed = PlayerPedId()
			local xPlayer = ESX.GetPlayerData()

            TriggerServerEvent('logpdVehicleSpawn', xPlayer.name, GetPlayerServerId(PlayerId()), playerIdentifier, vehicleLabel, "PD" .. plate[1], true)



			TriggerEvent('chat:addMessage', {
				args = {'^1SYSTEM', 'Mashin Ba Plake^2 PD'..plate[1]..' ^0Spawn Shod'}
			})
		else
			TriggerEvent('chat:addMessage', {
				args = {'^1SYSTEM', 'Spawn Mashin Na Movafaq'}
			})

		end
	end)

end

AddEventHandler('esx_policejob:hasEnteredEntityZone', function(entity)
	local playerPed = PlayerPedId()

	if PlayerData.job ~= nil and PlayerData.job.name == 'police' and IsPedOnFoot(playerPed) then
		CurrentAction     = 'remove_entity'
		CurrentActionMsg  = _U('remove_prop')
		CurrentActionData = {entity = entity}
	end

	if GetEntityModel(entity) == GetHashKey('p_ld_stinger_s') then
		local playerPed = PlayerPedId()
		local coords    = GetEntityCoords(playerPed)

		if IsPedInAnyVehicle(playerPed, false) then
			local vehicle = GetVehiclePedIsIn(playerPed)

			for i=0, 7, 1 do
				SetVehicleTyreBurst(vehicle, i, true, 1000)
			end
		end
	end
end)

function OpenPoliceActionsMenu_police()
	ESX.UI.Menu.CloseAll()
	ESX.TriggerServerCallback('esx_society:divisionsPlayer', function(check)
		local elements ={}
		local isdivision = false
		local playerjob =  ESX.GetPlayerData().job.name
		for k, v in pairs(check) do
			if v.job == playerjob then
				if #check >= 1 then

					isdivision = true
					break
				end
			end
		end

		elements = {
			{label = _U('citizen_interaction'),	value = 'citizen_interaction'},


			{label = _U('vehicle_interaction'),	value = 'vehicle_interaction'},
			{label = _U('object_spawner'),		value = 'object_spawner'},
		}

		if isdivision then
			table.insert(elements, {label = _U('extra_division'), value = 'extra_division'})
		end

		local inVehicle = IsPedInAnyVehicle(PlayerPedId(), false)
		ESX.UI.Menu.Open(
		'default', GetCurrentResourceName(), 'police_actions',
		{
			title    = 'Police',
			align    = 'left',
			elements = elements

		}, function(data, menu)

			if not inVehicle then

			if data.current.value == 'citizen_interaction' then
				local elements = {
					{label = _U('id_card'),			value = 'identity_card'},
					{label = _U('search'),			value = 'body_search'},
					{label = _U('handcuff'),		value = 'handcuff'},
					{label = _U('uncuff'),			value = 'uncuff'},
					{label = _U('drag'),			value = 'drag'},
					{label = _U('put_in_vehicle'),	value = 'put_in_vehicle'},
					{label = _U('out_the_vehicle'),	value = 'out_the_vehicle'},
					{label = 'Jarime Kardan',			value = 'finev2'},
					{label = _U('unpaid_bills'),	value = 'unpaid_bills'},
					{label = _U('license_check'), 	value = 'license' },
					{label = _U('jail_menu'), 	value = 'jail_menu' }
				}

				ESX.UI.Menu.Open(
				'default', GetCurrentResourceName(), 'citizen_interaction',
				{
					title    = _U('citizen_interaction'),
					align    = 'left',
					elements = elements
				}, function(data2, menu2)
					local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
					if closestPlayer ~= -1 and closestDistance <= 3.0 then
						local action = data2.current.value
						if action == 'identity_card' then
							if GetGameTimer() - ASTimer > 650 then
								TriggerServerEvent('3dme:shareDisplay', "ID Card fard ro barresi mikone", true)
								OpenIdentityCardMenu_police(closestPlayer)
							else
								ESX.ShowNotification('~h~~r~Lotfan Spam Nakonid!')
							end
							ASTimer = GetGameTimer()
						elseif action == 'body_search' then

							PlayerSerchenu_police()

						elseif action == 'handcuff' then
							local target, distance = ESX.Game.GetClosestPlayer()
							if distance <= 2.0 then
								PlayerCuffMenu_police()
							else
								ESX.ShowNotification('Shakhsi nazdik shoma nist')
							end


						elseif action == 'uncuff' then

							local target, distance = ESX.Game.GetClosestPlayer()

							if distance <= 2.0 then
								PlayerUNCuffMenu_police()

							else
								ESX.ShowNotification('Shakhsi nazdik shoma nist')
							end

						elseif action == 'drag' then
							local target, distance = ESX.Game.GetClosestPlayer()
							if distance <= 2.0 then
								TriggerServerEvent('esx_policejob:drag', GetPlayerServerId(closestPlayer))
							else
								ESX.ShowNotification('Shakhsi nazdik shoma nist')
							end
						elseif action == 'put_in_vehicle' then
							if dragiss then
								TriggerServerEvent('esx_policejob:putInVehicle', GetPlayerServerId(closestPlayer))
							elseif IsEntityPlayingAnim(PlayerPedId(), carry.personCarrying.animDict, carry.personCarrying.anim, 3) then

								local targetSrc = GetPlayerServerId(closestPlayer)
								TriggerServerEvent('carry:respone',false)
								TriggerServerEvent('citizen:stopcarry', targetSrc)
								TriggerEvent('carry:cascel', false)

								ClearPedSecondaryTask(PlayerPedId())

								DetachEntity(PlayerPedId(), true, false)
								TriggerServerEvent('policejob:putInVehiclecarry', GetPlayerServerId(closestPlayer))
							else

								ESX.ShowNotification('~h~~r~Playeri Scort Nakardin!')
							end

						elseif action == 'out_the_vehicle' then

							PlayeroutVehMenu_police()

						elseif action == 'jail_menu' then
							local ppcoords = GetEntityCoords(GetPlayerPed(PlayerId()))
							local distance = GetDistanceBetweenCoords(ppcoords.x, ppcoords.y, ppcoords.z, 481.9067, -1009.20, 26.273, false)
							local distanceWIN = GetDistanceBetweenCoords(ppcoords.x, ppcoords.y, ppcoords.z, 608.3761, -7.29537, 82.781, false)
							local distanceSH = GetDistanceBetweenCoords(ppcoords.x, ppcoords.y, ppcoords.z, 1848.710, 3683.398, 34.286, false)
							if GetGameTimer() - ASTimer > 650 and distance <= 10 or  distanceWIN <= 10 or  distanceSH <= 10 then
								OpenJailMenu_police()
							else
								ESX.ShowNotification('~h~~r~Lotfan Spam Nakonid!')
							end
							ASTimer = GetGameTimer()
						elseif action == 'fine' then
							PlayerBillingMenu_police()
						elseif action == 'finev2' then
							if GetGameTimer() - ASTimer > 650 then
								PlayerBillingMenu_police()
							else
								ESX.ShowNotification('~h~~r~Lotfan Spam Nakonid!')
							end
							ASTimer = GetGameTimer()
						elseif action == 'license' then
							if GetGameTimer() - ASTimer > 650 then
								ShowPlayerLicense_police(closestPlayer)
							else
								ESX.ShowNotification('~h~~r~Lotfan Spam Nakonid!')
							end
							ASTimer = GetGameTimer()
						elseif action == 'unpaid_bills' then
							if GetGameTimer() - ASTimer > 650 then
								OpenUnpaidBillsMenu_police(closestPlayer)
							else
								ESX.ShowNotification('~h~~r~Lotfan Spam Nakonid!')
							end
							ASTimer = GetGameTimer()
						end

					else
						ESX.ShowNotification(_U('no_players_nearby'))
					end
				end, function(data2, menu2)
					menu2.close()
				end)
			end
			end


			if data.current.value == 'warn_interaction' then
				local elements  = {}
					table.insert(elements, {label = 'Ekhtar 1',	value = 'warn1'})
					table.insert(elements, {label = 'Ekhtar 2',	value = 'warn2'})
					table.insert(elements, {label = 'Ekhtar 3',		value = 'warn3'})
					table.insert(elements, {label = 'Hokmetir',		value = 'warnhokm'})
					table.insert(elements, {label = 'Bezan Baghal',		value = 'warnbzn'})
				ESX.UI.Menu.Open(
				'default', GetCurrentResourceName(), 'warn_interaction',
				{
					title    = 'List Ekhtarha',
					align    = 'left',
					elements = elements
				}, function(data2, menu2)
					action  = data2.current.value
					if action == 'warn1' then
						if not ekhtarcool then
							ExecuteCommand("police Sohbat Mikone Shomaro Mohasere Karde , Taslim Shid Ekhtare 1")
							ekhtarcool = true
							Wait(5000)
							ekhtarcool = false
						else
							ESX.ShowNotification("spam nakon :|")
						end
					end
					if action == 'warn2' then
						if not ekhtarcool then
							ExecuteCommand("police Sohbat Mikone Shomaro Mohasere Karde , Taslim Shid Ekhtare 2")
							ekhtarcool = true
							Wait(5000)
							ekhtarcool = false
						else
							ESX.ShowNotification("spam nakon :|")
						end
					end
					if action == 'warn3' then
						if not ekhtarcool then
							ExecuteCommand("police Sohbat Mikone Shomaro Mohasere Karde , Taslim Shid Ekhtare Akhar , Darsurate Taslim Nashodan Mojazat Shoma 2 Barabar Mishavad")
							ekhtarcool = true
							Wait(5000)
							ekhtarcool = false
						else
							ESX.ShowNotification("spam nakon :|")
						end
					end
					if action == 'warnhokm' then
						if not ekhtarcool then
							ExecuteCommand("police Hokme Tir Be Dalile Adame Hamkari Sader Shod")
							ekhtarcool = true
							Wait(5000)
							ekhtarcool = false
						else
							ESX.ShowNotification("spam nakon :|")
						end
					end
					if action == 'warnbzn' then
						if not ekhtarcool then
							ExecuteCommand("police Mashineto Motevaghef Kon Va Azash Piade Sho")
							ekhtarcool = true
							Wait(5000)
							ekhtarcool = false
						else
							ESX.ShowNotification("spam nakon :|")
						end
					end

				end, function(data2, menu2)
					menu2.close()
				end
				)
			end
			if not inVehicle then
			if data.current.value == 'Self_menu' then
				local elements = {
					{label = "Camera",	            	value = 'camenu'},
					{label = "Radar",	            	    value = 'radar'},
				}
				if ESX.GetPlayerData().job.ext == 'swat' then
					table.insert(elements, {label = "Shield", value = 'shield1'})
				end
				local issheild = false
				ESX.UI.Menu.Open(
				'default', GetCurrentResourceName(), 'citizen_interaction',
				{
					title    = "Self",
					align    = 'left',
					elements = elements
				}, function(data2, menu2)
					local shieldActive = false
					local shieldEntity = nil
					local action = data2.current.value
					if action == 'shield1' then
						TriggerEvent('shield:ToggleSwatShield')
					elseif action == 'radar' then
						TriggerEvent('police:POLICE_radar')
					elseif action == 'camenu' then
						local elements  = {}

						local elements = {
							{label = 'Jewelry store', value = 'cam24'},
							{label = 'Paleto Bank', value = 'cam25'},
							{label = 'Main bank', value = 'cam26'},
							{label = 'Store 1', value = 'cam4'},
							{label = 'Store 2', value = 'cam5'},
							{label = 'Store 3', value = 'cam6'},
							{label = 'Store 4', value = 'cam7'},
							{label = 'Store 5', value = 'cam8'},
							{label = 'Store 6', value = 'cam9'},
							{label = 'Store 7', value = 'cam10'},
							{label = 'Store 8', value = 'cam11'},
							{label = 'Store 9', value = 'cam12'},
							{label = 'Store 10', value = 'cam13'},
							{label = 'Store 11', value = 'cam14'},
							{label = 'Store 12', value = 'cam15'},
							{label = 'Store 13', value = 'cam16'},
							{label = 'Store 14', value = 'cam17'},
							{label = 'Store 15', value = 'cam18'},
							{label = 'Store 16', value = 'cam19'},
							{label = 'Store 17', value = 'cam20'},
							{label = 'Store 18', value = 'cam21'},
							{label = 'Jail 1', value = 'cam22'},
							{label = 'Jail 2', value = 'cam23'},



						}

						ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'camenu', {
							css      = 'police',
							title    = '🎥 Menu Camera',
							align    = 'left',
							elements = elements
						}, function(data3, menu3)
							local action = data3.current.value

							if action == 'cam1' then
								TriggerEvent('cctv:camera', 25)
							elseif action == 'cam2' then
								TriggerEvent('cctv:camera', 26)
							elseif action == 'cam3' then
								TriggerEvent('cctv:camera', 27)
							elseif action == 'cam4' then
								TriggerEvent('cctv:camera', 1)
							elseif action == 'cam5' then
								TriggerEvent('cctv:camera', 2)
							elseif action == 'cam6' then
								TriggerEvent('cctv:camera', 3)
							elseif action == 'cam7' then
								TriggerEvent('cctv:camera', 4)
							elseif action == 'cam8' then
								TriggerEvent('cctv:camera', 5)
							elseif action == 'cam9' then
								TriggerEvent('cctv:camera', 6)
							elseif action == 'cam10' then
								TriggerEvent('cctv:camera', 7)
							elseif action == 'cam11' then
								TriggerEvent('cctv:camera', 8)
							elseif action == 'cam12' then
								TriggerEvent('cctv:camera', 9)
							elseif action == 'cam13' then
								TriggerEvent('cctv:camera', 10)
							elseif action == 'cam14' then
								TriggerEvent('cctv:camera', 11)
							elseif action == 'cam15' then
								TriggerEvent('cctv:camera', 12)
							elseif action == 'cam16' then
								TriggerEvent('cctv:camera', 13)
							elseif action == 'cam17' then
								TriggerEvent('cctv:camera', 14)
							elseif action == 'cam18' then
								TriggerEvent('cctv:camera', 15)
							elseif action == 'cam19' then
								TriggerEvent('cctv:camera', 16)
							elseif action == 'cam20' then
								TriggerEvent('cctv:camera', 17)
							elseif action == 'cam21' then
								TriggerEvent('cctv:camera', 18)
							elseif action == 'cam22' then
								TriggerEvent('cctv:camera', 20)
							elseif action == 'cam23' then
								TriggerEvent('cctv:camera', 21)
							elseif action == 'cam24' then
								TriggerEvent('cctv:camera', 22)
							elseif action == 'cam25' then
								TriggerEvent('cctv:camera', 23)
							elseif action == 'cam26' then
								TriggerEvent('cctv:camera', 24)
							elseif action ==  'exit' then
								menu.close()

							end
						end, function(data3, menu3)
							menu3.close()
						end)
					end
				end, function(data2, menu2)
					menu2.close()
				end)
			end
			end
			if not inVehicle then
			if data.current.value == 'vehicle_interaction' then
				local elements  = {}
				local playerPed = PlayerPedId()
				local coords    = GetEntityCoords(playerPed)
				local vehicle   = ESX.Game.GetVehicleInDirection()

				if DoesEntityExist(vehicle) then
					table.insert(elements, {label = _U('vehicle_info'),	value = 'vehicle_infos'})
					table.insert(elements, {label = _U('pick_lock'),	value = 'hijack_vehicle'})
					table.insert(elements, {label = _U('impound'),		value = 'impound'})
				end

				table.insert(elements, {label = _U('search_database'), value = 'search_database'})

				ESX.UI.Menu.Open(
				'default', GetCurrentResourceName(), 'vehicle_interaction',
				{
					title    = _U('vehicle_interaction'),
					align    = 'left',
					elements = elements
				}, function(data2, menu2)
					coords  = GetEntityCoords(playerPed)
					vehicle = ESX.Game.GetVehicleInDirection()
					action  = data2.current.value

					if action == 'search_database' then
						LookupVehicle_police()
					elseif DoesEntityExist(vehicle) then
						local vehicleData = ESX.Game.GetVehicleProperties(vehicle)
						if action == 'vehicle_infos' then
							OpenVehicleInfosMenu_police(vehicleData)

						elseif action == 'hijack_vehicle' then

						if CurrentTask.Busy then
							return
						end

							if IsAnyVehicleNearPoint(coords.x, coords.y, coords.z, 3.0) then
								TaskStartScenarioInPlace(playerPed, "WORLD_HUMAN_WELDING", 0, true)
								CurrentTask.Busy = true
								TriggerEvent('esx_customItems:checkVehicleDistance', vehicle)
								TriggerEvent("mythic_progbar:client:progress", {
								name = "hijack_vehicle2",
								duration = 30000,
								label = "LockPick kardan mashin",
								useWhileDead = false,
								canCancel = true,
								controlDisables = {
									disableMovement = true,
									disableCarMovement = true,
									disableMouse = false,
									disableCombat = true,
								},
							}, function(status)
								if not status then

									ClearPedTasksImediately(playerPed)
									SetVehiceleDoorsLocked(vehicle, 1)
									SetVehicleDoorsLockedForAllPlayers(vehicle, false)
									ESX.ShowNotification(_U('vehicle_unlocked'))
									CurrentTask.Busy = false
									TriggerEvent('esx_customItems:checkVehicleStatus', false)

								elseif status then
									ClearPedTasksImediately(playerPed)
									CurrentTask.Busy = false
									TriggerEvent('esx_customItems:checkVehicleStatus', false)
								end
							end)

							end
						elseif action == 'impound' then


							if CurrentTask.Busy then
								return
							end

							CurrentTask.Busy = true
							TaskStartScenarioInPlace(playerPed, 'CODE_HUMAN_MEDIC_TEND_TO_DEAD', 0, true)

							TriggerEvent('esx_customItems:checkVehicleDistance', vehicle)
							TriggerEvent("mythic_progbar:client:progress", {
							name = "impound_vehicle",
							duration = 10000,
							label = "Toghif kardan mashin",
							useWhileDead = false,
							canCancel = true,
							controlDisables = {
								disableMovement = true,
								disableCarMovement = true,
								disableMouse = false,
								disableCombat = true,
							},
						}, function(status)
							if not status then

								ClearPedTasks(playerPed)
								ImpoundVehicle_police(vehicle)
								CurrentTask.Busy = false
								TriggerEvent('esx_customItems:checkVehicleStatus', false)

							elseif status then
								ClearPedTasks(playerPed)
								CurrentTask.Busy = false
								TriggerEvent('esx_customItems:checkVehicleStatus', false)
							end
						end)

						end
					else
						ESX.ShowNotification(_U('no_vehicles_nearby'))
					end

				end, function(data2, menu2)
					menu2.close()
				end
				)
			end
			end
			if not inVehicle then

			if data.current.value == 'object_spawner' then
				ESX.UI.Menu.Open(
					'default', GetCurrentResourceName(), 'citizen_interaction',
					{
						title    = _U('traffic_interaction'),
						align    = 'left',
						elements = {
						{label = _U('cone'),        value = 'prop_mp_cone_02'},
						{label = _U('barrier'),        value = 'prop_mp_barrier_02b'},
						{label = _U('barrier1'),        value = 'prop_barrier_work05'},
						{label = _U('barrier2'),        value = 'prop_mp_arrow_barrier_01'},



						}
					}, function(data2, menu2)
						local model     = data2.current.value
						local playerPed = PlayerPedId()
						local coords    = GetEntityCoords(playerPed)
						local forward   = GetEntityForwardVector(playerPed)
						local x, y, z   = table.unpack(coords + forward * 1.0)

						if model == 'prop_mp_cone_02' then
							z = z - 2.0
						end

						ESX.Game.SpawnObject(model, {
							x = x,
							y = y,
							z = z
						}, function(obj)
							SetEntityHeading(obj, GetEntityHeading(playerPed))
							PlaceObjectOnGroundProperly(obj)
						end)

					end, function(data2, menu2)
						menu2.close()
				end)
			end

			if data.current.value == 'extra_division' then

				OpendivisionsMenu_police()

			end

		end
		end, function(data, menu)
			menu.close()

		end)
	end)

end

function PlayerSerchenu_police()
	ESX.UI.Menu.CloseAll()
	dataplayer = {}
	local elements = {}
	local nearbyPlayers = getNearbyPlayers_police(3)
	local elements = {}
	table.insert(elements, {label = "ID"  , value = " " })
	local playerId22 = GetPlayerServerId(PlayerId())
	local names = nil

	for _, player in ipairs(nearbyPlayers) do
		local playerPed = GetPlayerPed(GetPlayerFromServerId(player.id))
		local health = GetEntityHealth(playerPed)
		if player.id ~= playerId22 and health ~= 0 then
			table.insert(elements, { label = "Player ID : " .. " [" .. player.id .. "]", value = player.id })
		end
	end

	Citizen.Wait(500)

	ESX.UI.Menu.Open(
		'default', GetCurrentResourceName(), 'serch_player_pd',
		{
			title = "Serch Player ID",
			align = 'center-left',
			elements = elements
		}, function(data, menu)

			if data.current.value ~= " " then

				local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()

				if closestPlayer == -1 or closestDistance > 2.0 then
					ESX.ShowNotification("No players nearby!")
				else

					local playerid = data.current.value

					if IsPedSittingInAnyVehicle(GetPlayerPed(GetPlayerFromServerId(playerid))) and IsPedSittingInAnyVehicle(GetPlayerPed(-1)) then
						local text = 'Shoro Be Gashtane Fard Mikone '
						TriggerServerEvent('3dme:shareDisplay', text, true)
						OpenBodySearchMenu_police(GetPlayerFromServerId(playerid))
					elseif not IsPedSittingInAnyVehicle(GetPlayerPed(GetPlayerFromServerId(playerid))) and not IsPedSittingInAnyVehicle(GetPlayerPed(-1)) then
						ESX.TriggerServerCallback("PD_CuffStatus:GetPedHandsUpStatus", function(Cuff, IsInjure, IsDead)

							local text = 'Shoro Be Gashtane Fard Mikone '
							TriggerServerEvent('3dme:shareDisplay', text, true)
							OpenBodySearchMenu_police(GetPlayerFromServerId(playerid))

						end, playerid)
					else
						ESX.ShowNotification('Shoma Ejaze Search Nadarid!')
					end

					stopActiveMarker_police()

				end


		end

		end, function(data, menu)
			menu.close()


		end, function(data, menu)
			local tttrp = true
			stopActiveMarker_police()
			Wait(5)

			local targetPlayer = GetPlayerPed(GetPlayerFromServerId(data.current.value))
			activeMarkerThread = true

			local playerId22 = GetPlayerServerId(PlayerId())

			while activeMarkerThread and tttrp do
				if DoesEntityExist(targetPlayer) then
					local coords = GetEntityCoords(targetPlayer)
					if data.current.value ~= " " then


						DrawMarker(23, coords.x, coords.y, coords.z-0.8, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.7, 0.7, 0.7, 0, 255, 0, 100, false, true, 2, nil, nil, false)

						if IsControlJustPressed(0, 177) or IsControlJustPressed(0, 322) then
							tttrp = false
						end
					else

					end
				else
					stopActiveMarker_police()
				end
				Wait(0)
			end

		end,function()
			OpenPoliceActionsMenu_police()
		end
	)
end

function PlayerBillingMenu_police()
	ESX.UI.Menu.CloseAll()
	dataplayer = {}
	local elements = {}
	local nearbyPlayers = getNearbyPlayers_police(3)
	local elements = {}
	table.insert(elements, {label = "ID"  , value = " " })
	local playerId22 = GetPlayerServerId(PlayerId())
	local names = nil

	for _, player in ipairs(nearbyPlayers) do
		local playerPed = GetPlayerPed(GetPlayerFromServerId(player.id))
		local health = GetEntityHealth(playerPed)
		if player.id ~= playerId22 and health ~= 0 then
			table.insert(elements, { label = "Player ID : " .. " [" .. player.id .. "]", value = player.id })
		end
	end

	Citizen.Wait(500)

	ESX.UI.Menu.Open(
		'default', GetCurrentResourceName(), 'ghabz_player_pd',
		{
			title = "Ghabz Player ID",
			align = 'center-left',
			elements = elements
		}, function(data, menu)

			if data.current.value ~= " " then

				local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()

				if closestPlayer == -1 or closestDistance > 2.0 then
					ESX.ShowNotification("No players nearby!")
				else

					local playerid = data.current.value

					OpenFinev2Menu_police(playerid)

					stopActiveMarker_police()

				end


		end



		end, function(data, menu)
			menu.close()


		end, function(data, menu)
			local tttrp = true
			stopActiveMarker_police()
			Wait(5)

			local targetPlayer = GetPlayerPed(GetPlayerFromServerId(data.current.value))
			activeMarkerThread = true

			local playerId22 = GetPlayerServerId(PlayerId())

			while activeMarkerThread and tttrp do
				if DoesEntityExist(targetPlayer) then
					local coords = GetEntityCoords(targetPlayer)
					if data.current.value ~= " " then


						DrawMarker(23, coords.x, coords.y, coords.z-0.8, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.7, 0.7, 0.7, 0, 255, 0, 100, false, true, 2, nil, nil, false)

						if IsControlJustPressed(0, 177) or IsControlJustPressed(0, 322) then
							tttrp = false
						end
					else

					end
				else
					stopActiveMarker_police()
				end
				Wait(0)
			end

		end,function()
			OpenPoliceActionsMenu_police()
		end
	)
end

function PlayeroutVehMenu_police()
	ESX.UI.Menu.CloseAll()
	dataplayer = {}
	local elements = {}
	local nearbyPlayers = getNearbyPlayers_police(3)
	local elements = {}
	table.insert(elements, {label = "ID"  , value = " " })
	local playerId22 = GetPlayerServerId(PlayerId())
	local names = nil

	for _, player in ipairs(nearbyPlayers) do
		local playerPed = GetPlayerPed(GetPlayerFromServerId(player.id))
		local health = GetEntityHealth(playerPed)
		if player.id ~= playerId22 and health ~= 0 then


			table.insert(elements, { label = "Player ID : " .. " [" .. player.id .. "]", value = player.id })


		end
	end

	Citizen.Wait(500)

	ESX.UI.Menu.Open(
		'default', GetCurrentResourceName(), 'OutVeh_player_pd',
		{
			title = "Out Veh Player ID",
			align = 'center-left',
			elements = elements
		}, function(data, menu)

			if data.current.value ~= " " then

				local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()

				if closestPlayer == -1 or closestDistance > 2.0 then
					ESX.ShowNotification("No players nearby!")
				else

					local playerid = data.current.value

					local target, distance = ESX.Game.GetClosestPlayer()
					ESX.TriggerServerCallback("PD_CuffStatus:GetPedHandsUpStatus", function(Cuff, IsInjure, IsDead)
						if Cuff then
							TriggerServerEvent('esx_policejob:OutVehicle', playerid)
						elseif IsDead then
							TriggerServerEvent('policejob:OutVehiclecarry', playerid)
						end
					end, playerid)

					stopActiveMarker_police()
					ESX.UI.Menu.CloseAll()
					OpenPoliceActionsMenu_police()


				end


		end



		end, function(data, menu)
			menu.close()


		end, function(data, menu)
			local tttrp = true
			stopActiveMarker_police()
			Wait(5)

			local targetPlayer = GetPlayerPed(GetPlayerFromServerId(data.current.value))
			activeMarkerThread = true

			local playerId22 = GetPlayerServerId(PlayerId())

			while activeMarkerThread and tttrp do
				if DoesEntityExist(targetPlayer) then
					local coords = GetEntityCoords(targetPlayer)
					if data.current.value ~= " " then




						if IsControlJustPressed(0, 177) or IsControlJustPressed(0, 322) then
							tttrp = false
						end
					else

					end
				else
					stopActiveMarker_police()
				end
				Wait(0)
			end

		end,function()
			OpenPoliceActionsMenu_police()
		end
	)
end

function PlayerUNCuffMenu_police()
	ESX.UI.Menu.CloseAll()
	dataplayer = {}
	local elements = {}
	local nearbyPlayers = getNearbyPlayers_police(3)
	local elements = {}
	table.insert(elements, {label = "ID"  , value = " " })
	local playerId22 = GetPlayerServerId(PlayerId())
	local names = nil

	for _, player in ipairs(nearbyPlayers) do
		local playerPed = GetPlayerPed(GetPlayerFromServerId(player.id))
		local health = GetEntityHealth(playerPed)
		if player.id ~= playerId22 and health ~= 0 then

			table.insert(elements, { label = "Player ID : " .. " [" .. player.id .. "]", value = player.id })
		end
	end

	Citizen.Wait(500)

	ESX.UI.Menu.Open(
		'default', GetCurrentResourceName(), 'uncuff_player_pd',
		{
			title = "Un Cuff Player ID",
			align = 'center-left',
			elements = elements
		}, function(data, menu)

			if data.current.value ~= " " then

				local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()

				if closestPlayer == -1 or closestDistance > 2.0 then
					ESX.ShowNotification("No players nearby!")
				else

					local playerid = data.current.value


					playerPed = PlayerPedId()
					SetCurrentPedWeapon(playerPed, GetHashKey('WEAPON_UNARMED'), true)
					local target, distance = ESX.Game.GetClosestPlayer()
					playerheading = GetEntityHeading(PlayerPedId())
					playerlocation = GetEntityForwardVector(PlayerPedId())
					playerCoords = GetEntityCoords(PlayerPedId())

					if distance <= 2.0 then
						TriggerServerEvent('esx_policejob:requestrelease', playerid, playerheading, playerCoords, playerlocation)

					else
						ESX.ShowNotification('Player nazdik shoma nist')
					end

					stopActiveMarker_police()
					ESX.UI.Menu.CloseAll()
					OpenPoliceActionsMenu_police()


				end


		end



		end, function(data, menu)
			menu.close()


		end, function(data, menu)
			local tttrp = true
			stopActiveMarker_police()
			Wait(5)

			local targetPlayer = GetPlayerPed(GetPlayerFromServerId(data.current.value))
			activeMarkerThread = true

			local playerId22 = GetPlayerServerId(PlayerId())

			while activeMarkerThread and tttrp do
				if DoesEntityExist(targetPlayer) then
					local coords = GetEntityCoords(targetPlayer)
					if data.current.value ~= " " then

						DrawMarker(23, coords.x, coords.y, coords.z-0.8, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.7, 0.7, 0.7, 0, 255, 0, 100, false, true, 2, nil, nil, false)

						if IsControlJustPressed(0, 177) or IsControlJustPressed(0, 322) then
							tttrp = false
						end
					else

					end
				else
					stopActiveMarker_police()
				end
				Wait(0)
			end

		end,function()
			OpenPoliceActionsMenu_police()
		end
	)
end

function PlayerCuffMenu_police()
	ESX.UI.Menu.CloseAll()
	dataplayer = {}
	local elements = {}
	local nearbyPlayers = getNearbyPlayers_police(3)
	local elements = {}
	table.insert(elements, {label = "ID"  , value = " " })
	local playerId22 = GetPlayerServerId(PlayerId())
	local names = nil

	for _, player in ipairs(nearbyPlayers) do
		local playerPed = GetPlayerPed(GetPlayerFromServerId(player.id))
		local health = GetEntityHealth(playerPed)
		if player.id ~= playerId22 and health ~= 0 then
			table.insert(elements, { label = "Player ID : " .. " [" .. player.id .. "]", value = player.id })
		end
	end

	Citizen.Wait(500)

	ESX.UI.Menu.Open(
		'default', GetCurrentResourceName(), 'Cuff_player_pd',
		{
			title = "Cuff Player ID",
			align = 'center-left',
			elements = elements
		}, function(data, menu)

			if data.current.value ~= " " then

				local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()

				if closestPlayer == -1 or closestDistance > 2.0 then
					ESX.ShowNotification("No players nearby!")
				else

					local playerid = data.current.value

					playerPed = PlayerPedId()
					SetCurrentPedWeapon(playerPed, GetHashKey('WEAPON_UNARMED'), true)
					local target, distance = ESX.Game.GetClosestPlayer()
					playerheading = GetEntityHeading(PlayerPedId())
					playerlocation = GetEntityForwardVector(PlayerPedId())
					playerCoords = GetEntityCoords(PlayerPedId())
					local target_id = GetPlayerServerId(target)
					if distance <= 2.0 then

						if not IsPedSittingInAnyVehicle(GetPlayerPed(target)) and not IsPedSittingInAnyVehicle(PlayerPedId()) then
							ESX.TriggerServerCallback("PD_CuffStatus:GetPedHandsUpStatus", function(Cuff, IsInjure, IsDead)
								if not Cuff then

									if not IsInjure or not IsDead then
										TriggerServerEvent('esx:requestarrestpd', playerid, playerheading, playerCoords, playerlocation, false)


									else
										ESX.ShowNotification("~y~Shoma Nemitavanid Player Zakhmi Ra Cuff Konid")
									end
								else
									ESX.ShowNotification("~y~Shoma Nemitavanid Kasi Ra Ke Cuff Boode Ast Cuff Konid")
								end
							end, GetPlayerServerId(target))
						else
							ESX.ShowNotification('~r~Shoma Nemitavanid Kasi Ke Dar Mashin Ast Ra Cuff Konid!')
						end
					else
						ESX.ShowNotification('Shakhsi nazdik shoma nist')
					end

					stopActiveMarker_police()
					ESX.UI.Menu.CloseAll()
					OpenPoliceActionsMenu_police()


				end


		end



		end, function(data, menu)
			menu.close()


		end, function(data, menu)
			local tttrp = true
			stopActiveMarker_police()
			Wait(5)

			local targetPlayer = GetPlayerPed(GetPlayerFromServerId(data.current.value))
			activeMarkerThread = true

			local playerId22 = GetPlayerServerId(PlayerId())

			while activeMarkerThread and tttrp do
				if DoesEntityExist(targetPlayer) then
					local coords = GetEntityCoords(targetPlayer)
					if data.current.value ~= " " then


						DrawMarker(23, coords.x, coords.y, coords.z-0.8, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.7, 0.7, 0.7, 0, 255, 0, 100, false, true, 2, nil, nil, false)

						if IsControlJustPressed(0, 177) or IsControlJustPressed(0, 322) then
							tttrp = false
						end
					else

					end
				else
					stopActiveMarker_police()
				end
				Wait(0)
			end

		end,function()
			OpenPoliceActionsMenu_police()
		end
	)
end

function OpenJailMenu_police()

	ESX.UI.Menu.CloseAll()
	dataplayer = {}
	local elements = {}
	local nearbyPlayers = getNearbyPlayers_police(5)
	local elements = {}
	table.insert(elements, {label = "ID"  , value = " " })
	local playerId22 = GetPlayerServerId(PlayerId())
	local names = nil

	for _, player in ipairs(nearbyPlayers) do
		if player.id ~= playerId22 then
			table.insert(elements, { label = "Player ID : " .. " [" .. player.id .. "]", value = player.id })
		end
	end

	ESX.UI.Menu.Open(
		'default', GetCurrentResourceName(), 'jail_choose_player_menu',
		{
			title = "Jail Player ID",
			align = 'center-left',
			elements = elements
		}, function(data, menu)

			if data.current.value ~= " " then
				local playerid = data.current.value
				menu.close()
				ESX.UI.Menu.CloseAll()
				stopActiveMarker_police()



				TriggerEvent('arshia_jail:factionjail', playerid)
			end

		end, function(data, menu)
			menu.close()


		end, function(data, menu)
			local tttrp = true
			stopActiveMarker_police()
			Wait(5)

			local targetPlayer = GetPlayerPed(GetPlayerFromServerId(data.current.value))
			activeMarkerThread = true

			local playerId22 = GetPlayerServerId(PlayerId())

			while activeMarkerThread and tttrp do
				if DoesEntityExist(targetPlayer) then
					local coords = GetEntityCoords(targetPlayer)
					if data.current.value ~= " " then


						DrawMarker(23, coords.x, coords.y, coords.z-0.8, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.7, 0.7, 0.7, 0, 255, 0, 100, false, true, 2, nil, nil, false)

						if IsControlJustPressed(0, 177) or IsControlJustPressed(0, 322) then
							tttrp = false
						end
					else

					end
				else
					stopActiveMarker_police()
				end
				Wait(0)
			end

		end,function()

		end
	)
end

local activeMarkerTarget = nil
function stopActiveMarker_police()
    if activeMarkerThread then
        activeMarkerThread = nil
    end
end

function getNearbyPlayers_police(radius)
    local players = {}
    local playerPed = PlayerPedId()
    local playerCoords = GetEntityCoords(playerPed)

    for _, playerId in ipairs(GetActivePlayers()) do
        local targetPed = GetPlayerPed(playerId)
        local targetCoords = GetEntityCoords(targetPed)
        local distance = #(playerCoords - targetCoords)

        if distance <= radius then
            table.insert(players, {
                id = GetPlayerServerId(playerId),
                name = GetPlayerName(playerId)
            })
        end
    end

    return players
end

function OpenIdentityCardMenu_police(player)

	ESX.TriggerServerCallback('esx:getOtherPlayerDataCard', function(data)

		local elements    = {}
		local nameLabel   = _U('name', data.name)
		local jobLabel    = nil
		local sexLabel    = nil
		local dobLabel    = nil
		local idLabel     = nil

		if data.job.grade_label ~= nil and  data.job.grade_label ~= '' then
			jobLabel = _U('job', data.job.label .. ' - ' .. data.job.grade_label)
		else
			jobLabel = _U('job', data.job.label)
		end

		if Config_police.EnableESXIdentity then

			nameLabel = _U('name', data.name)
			TriggerEvent('skinchanger:getSkin', function(skin)
				if skin.sex ~= nil then
					if skin.sex == 0 then
						sexLabel = "sex : female"
					else
						sexLabel = "sex : male"
					end
				else
					sexLabel = _U('sex', _U('unknown'))
				end
			end)


			if data.dob ~= nil then
				dobLabel = _U('dob', data.dob)
			else
				dobLabel = _U('dob', _U('unknown'))
			end

			if data.name ~= nil then
				idLabel = _U('id', data.name)
			else
				idLabel = _U('id', _U('unknown'))
			end

		end

		local elements = {
			{label = nameLabel, value = nil},
			{label = jobLabel,  value = nil},
		}

		if Config_police.EnableESXIdentity then
			table.insert(elements, {label = sexLabel, value = nil})
			table.insert(elements, {label = dobLabel, value = nil})
			table.insert(elements, {label = idLabel, value = nil})
		end

		if data.drunk ~= nil then
			table.insert(elements, {label = _U('bac', data.drunk), value = nil})
		end

		if data.licenses ~= nil then

			table.insert(elements, {label = _U('license_label'), value = nil})

			for i=1, #data.licenses, 1 do
				table.insert(elements, {label = data.licenses[i].label, value = nil})
			end

		end

		ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'citizen_interaction',
		{
			title    = _U('citizen_interaction'),
			align    = 'left',
			elements = elements,
		}, function(data, menu)

		end, function(data, menu)
			menu.close()

		end)

	end, GetPlayerServerId(player))

end

function OpenBodySearchMenu_police(player)

	ESX.TriggerServerCallback('esx:getOtherPlayerDataCard', function(data)

		local elements = {}
		table.insert(elements, {label = '--- Money ---', value = nil})
    	table.insert(elements, {
      		label = 'Pol: $' .. ESX.Math.GroupDigits(data.money),

      		value = nil,
      		itemType = 'item_money',
      		amount = data.money
    	})

		table.insert(elements, {label = _U('guns_label'), value = nil})
		for i = 1, #data.weapons, 1 do
			local pdsearchweapon = data.weapons[i].name
			if pdsearchweapon ~= "WEAPON_MINIGUN" and pdsearchweapon ~= "WEAPON_SNIPERRIFLE"then
				table.insert(elements, {
					label    = _U('confiscate_weapon', ESX.GetWeaponLabel(pdsearchweapon), data.weapons[i].ammo),
					value    = pdsearchweapon,
					itemType = 'item_weapon',
					amount   = data.weapons[i].ammo
				})
			end
		end

		table.insert(elements, {label = _U('inventory_label'), value = nil})
		for i = 1, #data.inventory, 1 do
			local pdsearchitem = data.inventory[i].name
			if data.inventory[i].count > 0 and pdsearchitem ~= "hifi" and pdsearchitem ~= "customcoupon" then
				table.insert(elements, {
					label    = _U('confiscate_inv', data.inventory[i].count, data.inventory[i].label),
					value    = pdsearchitem,
					itemType = 'item_standard',
					amount   = data.inventory[i].count
				})
			end
		end

		ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'body_search',
		{
			title    = _U('search'),
			align    = 'left',
			elements = elements,
		},
		function(data, menu)

			local itemType = data.current.itemType
			local itemName = data.current.value
			local amount   = data.current.amount

			if data.current.value ~= nil then
				TriggerServerEvent('esx:confiscatePlayerItem', GetPlayerServerId(player), itemType, itemName, amount)
				OpenBodySearchMenu_police(player)
			end

		end, function(data, menu)
			menu.close()

		end)

	end, GetPlayerServerId(player))

end

function OpenFinev2Menu_police(Playerid)

			ESX.UI.Menu.Open(
          		'dialog', GetCurrentResourceName(), 'new_fine',
          		{
            		title = "Dalil Jarime Ra Vared Konid"
          		},
          	function(data2, menu2)

            	local dalilfine = tostring(data2.value)

            	if dalilfine == nil then
              		ESX.ShowNotification("~r~Dalile Jarime Nabayad Khali Bashad.")
				else
              		menu2.close()

              		local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()

              		if closestPlayer == -1 or closestDistance > 3.0 then
                		ESX.ShowNotification("~r~ Kasi Baraye Jarime Nazdike Shoma Nist.")
					else
						ESX.UI.Menu.Open(
							'dialog', GetCurrentResourceName(), 'new_fine_setamount',
							{
							  title = "Mablaghe Jarime Be $"
							},
						function(data3, menu3)

						  	local mablaghejarime = tonumber(data3.value)

						  	if mablaghejarime == nil then
								ESX.ShowNotification("~r~Mablaghe Jarime Nabayad Khali Bashad.")
						  	else
								if mablaghejarime < 149999 then
									menu3.close()

									local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()

									if closestPlayer == -1 or closestDistance > 3.0 then
										ESX.ShowNotification("~r~ Kasi Baraye Jarime Nazdike Shoma Nist.")
									else

										TriggerServerEvent('esx_billing:send2Bill', Playerid, 'society_police', 'Jarime: '..dalilfine, mablaghejarime)
										TriggerServerEvent("PdBillingWebhook", Playerid, mablaghejarime, dalilfine)
										if mablaghejarime >= 100 then
											TriggerEvent("Quest-System:Billing")
										end

									end
								else
									ESX.ShowNotification("~r~Hade Aksare Mablaghe Jarime ~g~150,000$ ~r~Ast.")
								end
						  	end

						end, function(data3, menu3)
							menu3.close()
						end)
					  end

				end

          	end, function(data2, menu2)
				menu2.close()
			end)

end

function LookupVehicle_police()
	ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'lookup_vehicle',
	{
		title = _U('search_database_title'),
	}, function(data, menu)
		local length = string.len(data.value)
		if data.value == nil or length < 2 or length > 13 then
			ESX.ShowNotification(_U('search_database_error_invalid'))
		else
			ESX.TriggerServerCallback('esx_policejob:getVehicleFromPlate', function(owner, found)
				if found then
					ESX.ShowNotification(_U('search_database_found', owner))
				else
					ESX.ShowNotification(_U('search_database_error_not_found'))
				end
			end, data.value)
			menu.close()

		end
	end, function(data, menu)
		menu.close()

	end)
end

function ShowPlayerLicense_police(player)
	local elements = {}
	local targetName
	ESX.TriggerServerCallback('esx:getOtherPlayerDataCard', function(data)
		if data.licenses ~= nil then
			for i=1, #data.licenses, 1 do
				if data.licenses[i].label ~= nil and data.licenses[i].type ~= nil then
					table.insert(elements, {label = data.licenses[i].label, value = data.licenses[i].type})
				end
			end
		end

		if Config_police.EnableESXIdentity then
			targetName = data.name
		end

		ESX.UI.Menu.Open(
		'default', GetCurrentResourceName(), 'manage_license',
		{
			title    = _U('license_revoke'),
			align    = 'left',
			elements = elements,
		},
		function(data, menu)
			ESX.ShowNotification(_U('licence_you_revoked', data.current.label, targetName))
			TriggerServerEvent('esx_policejob:message', GetPlayerServerId(player), _U('license_revoked', data.current.label))

			TriggerServerEvent('esx_license:removeLicense', GetPlayerServerId(player), data.current.value)


			ESX.SetTimeout(300, function()
				ShowPlayerLicense_police(player)
			end)

			Citizen.Wait(1000)
			TriggerServerEvent('esx_dmvschool:updateLicense', GetPlayerServerId(player))

		end,
		function(data, menu)
			menu.close()

		end
		)

	end, GetPlayerServerId(player))
end

RegisterNetEvent('policejob:OutVehiclecarry')
AddEventHandler('policejob:OutVehiclecarry', function()
	local playerPed = PlayerPedId()
	if not IsPedSittingInAnyVehicle(playerPed) then
		return
	end
	if ESX.GetPlayerData().IsDead then
		local vehicle = GetVehiclePedIsIn(playerPed, false)
		TaskLeaveVehicle(playerPed, vehicle, 16)
	end
end)

RegisterNetEvent('policejob:putInVehiclecarry')
AddEventHandler('policejob:putInVehiclecarry', function()
	local playerPed = PlayerPedId()
	local coords    = GetEntityCoords(playerPed)

	if IsAnyVehicleNearPoint(coords, 5.0) then
		local vehicle = GetClosestVehicle(coords, 5.0, 0, 71)
		if DoesEntityExist(vehicle) then
			local maxSeats, freeSeat = GetVehicleMaxNumberOfPassengers(vehicle)
			for i=maxSeats - 1, 0, -1 do
				if IsVehicleSeatFree(vehicle, i) then
					freeSeat = i
					break
				end
			end
			if freeSeat then
				TaskWarpPedIntoVehicle(playerPed, vehicle, freeSeat)

				TriggerEvent("Unique_Scripts_HuD:changeStatus", true)


			end
		end
	end

end)

function OpenUnpaidBillsMenu_police(player)

	local elements = {}

	ESX.TriggerServerCallback('esx_billing:getTargetBills', function(bills)
		for i=1, #bills, 1 do
			table.insert(elements, {label = bills[i].label .. ' - <span style="color: red;">$' .. bills[i].amount .. '</span>', value = bills[i].id})
		end

		ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'billing',
		{
			title    = _U('unpaid_bills'),
			align    = 'left',
			elements = elements
		}, function(data, menu)

		end, function(data, menu)
			menu.close()

		end)
	end, GetPlayerServerId(player))
end

function OpenVehicleInfosMenu_police(vehicleData)

	ESX.TriggerServerCallback('esx_policejob:getVehicleInfos', function(retrivedInfo)

		local elements = {}

		table.insert(elements, {label = _U('plate', retrivedInfo.plate), value = nil})

		if retrivedInfo.owner == nil then
			table.insert(elements, {label = _U('owner_unknown'), value = nil})
		else
			table.insert(elements, {label = _U('owner', retrivedInfo.owner), value = nil})
		end

		ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'vehicle_infos',
		{
			title    = _U('vehicle_info'),
			align    = 'left',
			elements = elements
		}, nil, function(data, menu)
			menu.close()

		end)

	end, vehicleData.plate)

end

function OpenPutWeaponMenu_police()

	local elements   = {}
	local playerPed  = PlayerPedId()
	local weaponList = ESX.GetWeaponList()

	for i=1, #weaponList, 1 do

		local weaponHash = GetHashKey(weaponList[i].name)

		if HasPedGotWeapon(playerPed,  weaponHash,  false) and weaponList[i].name ~= 'WEAPON_UNARMED' then
			table.insert(elements, {label = weaponList[i].label, value = weaponList[i].name})
		end

	end

	ESX.UI.Menu.Open(
		'default', GetCurrentResourceName(), 'armory_put_weapon',
		{
		title    = _U('put_weapon_menu'),
		align    = 'left',
		elements = elements
		},
		function(data, menu)

		menu.close()

		ESX.TriggerServerCallback('esx_policejob:addArmoryWeapon', function()

			local steamHex = ESX.GetPlayerData().identifier
			local weaponModel = data.current.value
			local weaponLabel = ESX.GetWeaponLabel(weaponModel)

			local playerPed = PlayerPedId()
			local ammoCount = GetAmmoInPedWeapon(playerPed, GetHashKey(weaponModel))

			TriggerServerEvent('logpdPutWeapon', ESX.GetPlayerData().name, GetPlayerServerId(PlayerId()), steamHex, weaponLabel, ammoCount)


			OpenPutWeaponMenu_police()


		end, data.current.value, true)

		end,
		function(data, menu)
		menu.close()

		end
	)

end

function OpenBuyWeaponsMenu_police(station)

	ESX.TriggerServerCallback('esx_policejob:getArmoryWeapons', function(weapons)

		local elements = {}

		for i=1, #Config_police.PoliceStations[station].AuthorizedWeapons, 1 do

		local weapon = Config_police.PoliceStations[station].AuthorizedWeapons[i]
		local count  = 0

		for i=1, #weapons, 1 do
			if weapons[i].name == weapon.name then
			count = weapons[i].count
			break
			end
		end

		table.insert(elements, {label = 'x' .. count .. ' ' .. ESX.GetWeaponLabel(weapon.name) .. ' $' .. weapon.price, value = weapon.name, price = weapon.price})

		end

ESX.UI.Menu.Open(
    'default', GetCurrentResourceName(), 'armory_buy_weapons',
    {
        title    = _U('buy_weapon_menu'),
        align    = 'left',
        elements = elements,
    },
    function(data, menu)
        local tedad = lib.inputDialog('Enter Buy Weapon', {'Tedad Weapon (1 , 99)'}, {max = 2})
        if not tedad then return end

        local weaponModel = data.current.value
        local weaponLabel = ESX.GetWeaponLabel(weaponModel)
        local buyCount = math.floor(tonumber(tedad[1]))
        local totalPrice = data.current.price * buyCount
        local steamHex = ESX.GetPlayerData().identifier


        TriggerServerEvent('logpdBuyWeapon', ESX.GetPlayerData().name, GetPlayerServerId(PlayerId()), steamHex, weaponLabel, buyCount, totalPrice)


        ESX.TriggerServerCallback('esx_policejob:buy', function(hasEnoughMoney)
            if hasEnoughMoney then
                ESX.TriggerServerCallback('esx_policejob:buyArmoryWeapon', function()
                    OpenBuyWeaponsMenu_police(station)
                end, weaponModel, false, buyCount)
            end
        end, totalPrice)
    end,
    function(data, menu)
        menu.close()
    end
)

	end)
end

function OpenGetStocksMenu_police()
    local grade = PlayerData.job.grade
    local job = PlayerData.job.name

    ESX.TriggerServerCallback("esx_policejob:getStockItems", function(items)
        ESX.TriggerServerCallback('esx_society:GetDivisionsPlayer', function(getdivision)
            local dvisionName = GetDivisionName_police(getdivision, job)

            ESX.TriggerServerCallback('esx_society:getDivisionItems', function(authorizedItems)

                if type(authorizedItems) ~= "table" then
                    authorizedItems = {}
                end

                ESX.TriggerServerCallback('esx_society:getItems', function(jobGradeItems)
                    local elements = {}

                    for _, item in ipairs(items) do
                        for _, sharedItem in ipairs(jobGradeItems) do
                            if sharedItem.name == item.name and sharedItem.status == true then
                                table.insert(elements, {label = "x" .. item.count .. " " .. item.label, value = item.name})
                                break
                            end
                        end
                    end

                    for _, item in ipairs(items) do
                        for _, divisionItem in ipairs(authorizedItems) do
                            if divisionItem.name == item.name and divisionItem.status == true then

                                local alreadyAdded = false
                                for _, element in ipairs(elements) do
                                    if element.value == item.name then
                                        alreadyAdded = true
                                        break
                                    end
                                end

                                if not alreadyAdded then
                                    table.insert(elements, {label = "x" .. item.count .. " " .. item.label, value = item.name})
                                end
                                break
                            end
                        end
                    end

                    if #elements == 0 then
                        table.insert(elements, {label = "Not Items", value = nil})
                    end

                    ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'stocks_menu', {
                        title = _U('police_stock'),
                        align = 'left',
                        elements = elements
                    }, function(data, menu)
                        if data.current.value == nil then
                            return
                        end

                        local itemName = data.current.value

                        ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'stocks_menu_get_item_count', {
                            title = _U('quantity')
                        }, function(data2, menu2)
                            local count = tonumber(data2.value)

                            if count == nil then
                                ESX.ShowNotification(_U('quantity_invalid'))
                            else
                                menu2.close()
                                menu.close()

                                TriggerServerEvent('esx_policejob:getStockItem', itemName, count)

								local steamHex = ESX.GetPlayerData().identifier


								TriggerServerEvent('logpdGetItem', ESX.GetPlayerData().name, GetPlayerServerId(PlayerId()), steamHex, data.current.label, count)

                                Citizen.Wait(300)
                                OpenGetStocksMenu_police()
                            end
                        end, function(data2, menu2)
                            menu2.close()
                        end)
                    end, function(data, menu)
                        menu.close()

                    end)
                end, grade, job)
            end, dvisionName, job)
        end, PlayerData.identifier)
    end)
end

function OpenPutStocksMenu_police()

	ESX.TriggerServerCallback('esx_policejob:getPlayerInventory', function(inventory)

		local elements = {}

		for i=1, #inventory.items, 1 do

		local item = inventory.items[i]

		if item.count > 0 then
			table.insert(elements, {label = item.label .. ' x' .. item.count, type = 'item_standard', value = item.name})
		end

		end

		ESX.UI.Menu.Open(
		'default', GetCurrentResourceName(), 'stocks_menu',
		{
			title    = _U('inventory'),
			align    = 'left',
			elements = elements
		},
		function(data, menu)

			local itemName = data.current.value

			ESX.UI.Menu.Open(
			'dialog', GetCurrentResourceName(), 'stocks_menu_put_item_count',
			{
				title = _U('quantity')
			},
			function(data2, menu2)

				local count = tonumber(data2.value)

				if count == nil then
				ESX.ShowNotification(_U('quantity_invalid'))
				else
				menu2.close()
				menu.close()

				TriggerServerEvent('esx_policejob:putStockItems', itemName, count)

				local steamHex = ESX.GetPlayerData().identifier


				TriggerServerEvent('logpdPutItem', ESX.GetPlayerData().name, GetPlayerServerId(PlayerId()), steamHex, data.current.label, count)

				Citizen.Wait(300)
				OpenPutStocksMenu_police()
				end

			end,
			function(data2, menu2)
				menu2.close()
			end
			)

		end,
		function(data, menu)
			menu.close()

		end
		)

	end)

end

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
	local lastjob = PlayerData.job.name
    PlayerData.job = job

    if (PlayerData.job.name == "police") and lastjob ~= PlayerData.job.name then
        mainThreads_police()
    end
end)

RegisterNetEvent('esx_phone:loaded')
AddEventHandler('esx_phone:loaded', function(phoneNumber, contacts)
	local specialContact = {
		name       = _U('phone_police'),
		number     = 'police',
		base64Icon = 'data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAACAAAAAgCAYAAABzenr0AAAAGXRFWHRTb2Z0d2FyZQBBZG9iZSBJbWFnZVJlYWR5ccllPAAAAyJpVFh0WE1MOmNvbS5hZG9iZS54bXAAAAAAADw/eHBhY2tldCBiZWdpbj0i77u/IiBpZD0iVzVNME1wQ2VoaUh6cmVTek5UY3prYzlkIj8+IDx4OnhtcG1ldGEgeG1sbnM6eD0iYWRvYmU6bnM6bWV0YS8iIHg6eG1wdGs9IkFkb2JlIFhNUCBDb3JlIDUuMy1jMDExIDY2LjE0NTY2MSwgMjAxMi8wMi8wNi0xNDo1NjoyNyAgICAgICAgIj4gPHJkZjpSREYgeG1sbnM6cmRmPSJodHRwOi8vd3d3LnczLm9yZy8xOTk5LzAyLzIyLXJkZi1zeW50YXgtbnMjIj4gPHJkZjpEZXNjcmlwdGlvbiByZGY6YWJvdXQ9IiIgeG1sbnM6eG1wPSJodHRwOi8vbnMuYWRvYmUuY29tL3hhcC8xLjAvIiB4bWxuczp4bXBNTT0iaHR0cDovL25zLmFkb2JlLmNvbS94YXAvMS4wL21tLyIgeG1sbnM6c3RSZWY9Imh0dHA6Ly9ucy5hZG9iZS5jb20veGFwLzEuMC9zVHlwZS9SZXNvdXJjZVJlZiMiIHhtcDpDcmVhdG9yVG9vbD0iQWRvYmUgUGhvdG9zaG9wIENTNiAoV2luZG93cykiIHhtcE1NOkluc3RhbmNlSUQ9InhtcC5paWQ6NDFGQTJDRkI0QUJCMTFFN0JBNkQ5OENBMUI4QUEzM0YiIHhtcE1NOkRvY3VtZW50SUQ9InhtcC5kaWQ6NDFGQTJDRkM0QUJCMTFFN0JBNkQ5OENBMUI4QUEzM0YiPiA8eG1wTU06RGVyaXZlZEZyb20gc3RSZWY6aW5zdGFuY2VJRD0ieG1wLmlpZDo0MUZBMkNGOTRBQkIxMUU3QkE2RDk4Q0ExQjhBQTMzRiIgc3RSZWY6ZG9jdW1lbnRJRD0ieG1wLmRpZDo0MUZBMkNGQTRBQkIxMUU3QkE2RDk4Q0ExQjhBQTMzRiIvPiA8L3JkZjpEZXNjcmlwdGlvbj4gPC9yZGY6UkRGPiA8L3g6eG1wbWV0YT4gPD94cGFja2V0IGVuZD0iciI/PoW66EYAAAjGSURBVHjapJcLcFTVGcd/u3cfSXaTLEk2j80TCI8ECI9ABCyoiBqhBVQqVG2ppVKBQqUVgUl5OU7HKqNOHUHU0oHamZZWoGkVS6cWAR2JPJuAQBPy2ISEvLN57+v2u2E33e4k6Ngz85+9d++95/zP9/h/39GpqsqiRYsIGz8QZAq28/8PRfC+4HT4fMXFxeiH+GC54NeCbYLLATLpYe/ECx4VnBTsF0wWhM6lXY8VbBE0Ch4IzLcpfDFD2P1TgrdC7nMCZLRxQ9AkiAkQCn77DcH3BC2COoFRkCSIG2JzLwqiQi0RSmCD4JXbmNKh0+kc/X19tLtc9Ll9sk9ZS1yoU71YIk3xsbEx8QaDEc2ttxmaJSKC1ggSKBK8MKwTFQVXRzs3WzpJGjmZgvxcMpMtWIwqsjztvSrlzjYul56jp+46qSmJmMwR+P3+4aZ8TtCprRkk0DvUW7JjmV6lsqoKW/pU1q9YQOE4Nxkx4ladE7zd8ivuVmJQfXZKW5dx5EwPRw4fxNx2g5SUVLw+33AkzoRaQDP9SkFu6OKqz0uF8yaz7vsOL6ycQVLkcSg/BlWNsjuFoKE1knqDSl5aNnmPLmThrE0UvXqQqvJPyMrMGorEHwQfEha57/3P7mXS684GFjy8kreLppPUuBXfyd/ibeoS2kb0mWPANhJdYjb61AxUvx5PdT3+4y+Tb3mTd19ZSebE+VTXVGNQlHAC7w4VhH8TbA36vKq6ilnzlvPSunHw6Trc7XpZ14AyfgYeyz18crGN1Alz6e3qwNNQSv4dZox1h/BW9+O7eIaEsVv41Y4XeHJDG83Nl4mLTwzGhJYtx0PzNTjOB9KMTlc7Nkcem39YAGU7cbeBKVLMPGMVf296nMd2VbBq1wmizHoqqm/wrS1/Zf0+N19YN2PIu1fcIda4Vk66Zx/rVi+jo9eIX9wZGGcFXUMR6BHUa76/2ezioYcXMtpyAl91DSaTfDxlJbtLprHm2ecpObqPuTPzSNV9yKz4a4zJSuLo71/j8Q17ON69EmXiPIlNMe6FoyzOqWPW/MU03Lw5EFcyKghTrNDh7+/vw545mcJcWbTiGKpRdGPMXbx90sGmDaux6sXk+kimjU+BjnMkx3kYP34cXrFuZ+3nrHi6iDMt92JITcPjk3R3naRwZhpuNSqoD93DKaFVU7j2dhcF8+YzNlpErbIBTVh8toVccbaysPB+4pMcuPw25kwSsau7BIlmHpy3guaOPtISYyi/UkaJM5Lpc5agq5Xkcl6gIHkmqaMn0dtylcjIyPThCNyhaXyfR2W0I1our0v6qBii07ih5rDtGSOxNVdk1y4R2SR8jR/g7hQD9l1jUeY/WLJB5m39AlZN4GZyIQ1fFJNsEgt0duBIc5GRkcZF53mNwIzhXPDgQPoZIkiMkbTxtstDMVnmFA4cOsbz2/aKjSQjev4Mp9ZAg+hIpFhB3EH5Yal16+X+Kq3dGfxkzRY+KauBjBzREvGN0kNCTARu94AejBLMHorAQ7cEQMGs2cXvkWshYLDi6e9l728O8P1XW6hKeB2yv42q18tjj+iFTGoSi+X9jJM9RTxS9E+OHT0krhNiZqlbqraoT7RAU5bBGrEknEBhgJks7KXbLS8qERI0ErVqF/Y4K6NHZfLZB+/wzJvncacvFd91oXO3o/O40MfZKJOKu/rne+mRQByXM4lYreb1tUnkizVVA/0SpfpbWaCNBeEE5gb/UH19NLqEgDF+oNDQWcn41Cj0EXFEWqzkOIyYekslFkThsvMxpIyE2hIc6lXGZ6cPyK7Nnk5OipixRdxgUESAYmhq68VsGgy5CYKCUAJTg0+izApXne3CJFmUTwg4L3FProFxU+6krqmXu3MskkhSD2av41jLdzlnfFrSdCZxyqfMnppN6ZUa7pwt0h3fiK9DCt4IO9e7YqisvI7VYgmNv7mhBKKD/9psNi5dOMv5ZjukjsLdr0ffWsyTi6eSlfcA+dmiVyOXs+/sHNZu3M6PdxzgVO9GmDSHsSNqmTz/R6y6Xxqma4fwaS5Mn85n1ZE0Vl3CHBER3lUNEhiURpPJRFdTOcVnpUJnPIhR7cZXfoH5UYc5+E4RzRH3sfSnl9m2dSMjE+Tz9msse+o5dr7UwcQ5T3HwlWUkNuzG3dKFSTbsNs7m/Y8vExOlC29UWkMJlAxKoRQMR3IC7x85zOn6fHS50+U/2Untx2R1voinu5no+DQmz7yPXmMKZnsu0wrm0Oe3YhOVHdm8A09dBQYhTv4T7C+xUPrZh8Qn2MMr4qcDSRfoirWgKAvtgOpv1JI8Zi77X15G7L+fxeOUOiUFxZiULD5fSlNzNM62W+k1yq5gjajGX/ZHvOIyxd+Fkj+P092rWP/si0Qr7VisMaEWuCiYonXFwbAUTWWPYLV245NITnGkUXnpI9butLJn2y6iba+hlp7C09qBcvoN7FYL9mhxo1/y/LoEXK8Pv6qIC8WbBY/xr9YlPLf9dZT+OqKTUwfmDBm/GOw7ws4FWpuUP2gJEZvKqmocuXPZuWYJMzKuSsH+SNwh3bo0p6hao6HeEqwYEZ2M6aKWd3PwTCy7du/D0F1DsmzE6/WGLr5LsDF4LggnYBacCOboQLHQ3FFfR58SR+HCR1iQH8ukhA5s5o5AYZMwUqOp74nl8xvRHDlRTsnxYpJsUjtsceHt2C8Fm0MPJrphTkZvBc4It9RKLOFx91Pf0Igu0k7W2MmkOewS2QYJUJVWVz9VNbXUVVwkyuAmKTFJayrDo/4Jwe/CT0aGYTrWVYEeUfsgXssMRcpyenraQJa0VX9O3ZU+Ma1fax4xGxUsUVFkOUbcama1hf+7+LmA9juHWshwmwOE1iMmCFYEzg1jtIm1BaxW6wCGGoFdewPfvyE4ertTiv4rHC73B855dwp2a23bbd4tC1hvhOCbX7b4VyUQKhxrtSOaYKngasizvwi0RmOS4O1QZf2yYfiaR+73AvhTQEVf+rpn9/8IMAChKDrDzfsdIQAAAABJRU5ErkJggg=='
	}

	TriggerEvent('esx_phone:addSpecialContact', specialContact.name, specialContact.number, specialContact.base64Icon)
end)

AddEventHandler('esx_phone:cancelMessage', function(dispatchNumber)

	if type(PlayerData.job.name) == 'string' and PlayerData.job.name == 'police' and PlayerData.job.grade >= 0 and PlayerData.job.name == dispatchNumber then

		if Config_police.MaxInService ~= -1 and not playerInService then
			CancelEvent()
		end
	end
end)

RegisterNetEvent('esx_policejob:sendbackuptext')
AddEventHandler('esx_policejob:sendbackuptext', function(txt)
	TriggerServerEvent('3dme:shareDisplay', txt, false)
end)

AddEventHandler('esx_policejob:hasEnteredMarker', function(station, part, partNum)

	if part == 'Cloakroom' then
		CurrentAction     = 'menu_cloakroom'
		CurrentActionMsg  = _U('open_cloackroom')
		CurrentActionData = {}
	end

	if part == 'Armory' then
		CurrentAction     = 'menu_armory'
		CurrentActionMsg  = _U('open_armory')
		CurrentActionData = {station = station}
	end

	if part == 'VehicleSpawner' then
		CurrentAction     = 'menu_vehicle_spawner'
		CurrentActionMsg  = _U('vehicle_spawner')
		CurrentActionData = {station = station, partNum = partNum}
	end

	if part == 'HelicopterSpawner' then
		CurrentAction     = 'menu_heli_spawner'
		CurrentActionMsg  = _U('heli_spawner')
		CurrentActionData = {station = station, partNum = partNum}
	else
		dakhelheli = false
	end

	if part == 'VehicleDeleter' then

		local playerPed = PlayerPedId()
		local coords    = GetEntityCoords(playerPed)

		if IsPedInAnyVehicle(playerPed,  false) then

		local vehicle = GetVehiclePedIsIn(playerPed, false)

		if DoesEntityExist(vehicle) then
			CurrentAction     = 'delete_vehicle'
			CurrentActionMsg  = _U('store_vehicle')
			CurrentActionData = {vehicle = vehicle}
		end

		end

	end

	if part == 'BossActions' then
		CurrentAction     = 'boss_actions'
		CurrentActionMsg  = _U('open_bossmenu')
		CurrentActionData = {}
	end

end)

AddEventHandler('esx_policejob:hasExitedMarker', function(station, part, partNum)
	ESX.UI.Menu.CloseAll()
	CurrentAction = nil
end)

RegisterNetEvent('esx_policejob:removeHandcuff')
AddEventHandler('esx_policejob:removeHandcuff', function()
	IsHandcuffed = false
end)

RegisterNetEvent('esx_policejob:removeHandcuffFull')
AddEventHandler('esx_policejob:removeHandcuffFull', function()

	local playerPed = PlayerPedId()

	IsHandcuffed = false
	TriggerServerEvent('esx_policejob:SetCuffStatus', false)

	if Config_police.EnableHandcuffTimer and HandcuffTimer.Active then
		ESX.ClearTimeout(HandcuffTimer.Task)
	end
	ClearPedSecondaryTask(playerPed)
	SetEnableHandcuffs(playerPed, false)
	DisablePlayerFiring(playerPed, false)
	SetPedCanPlayGestureAnims(playerPed, true)
	TriggerEvent("esx_policejob:removeHandcuff")
end)

RegisterNetEvent('esx_policejob:unrestrain')
AddEventHandler('esx_policejob:unrestrain', function()
	if IsHandcuffed then
		local playerPed = PlayerPedId()

		IsHandcuffed = false

		TriggerServerEvent('esx_policejob:SetCuffStatus', false)
		ClearPedSecondaryTask(playerPed)
		SetEnableHandcuffs(playerPed, false)
		DisablePlayerFiring(playerPed, false)
		SetPedCanPlayGestureAnims(playerPed, true)


		if Config_police.EnableHandcuffTimer and HandcuffTimer.Active then
			ESX.ClearTimeout(HandcuffTimer.Task)
		end
	end
end)

RegisterNetEvent('esx_policejob:drag')
AddEventHandler('esx_policejob:drag', function(copID)
	if not IsHandcuffed then
		return
	end
	if DragStatus.CopId then
		TriggerServerEvent('esx_policejob:lastDragger', DragStatus.CopId)
	end
	DragStatus.IsDragged = not DragStatus.IsDragged
	DragStatus.CopId     = tonumber(copID)


end)

RegisterNetEvent('esx_policejob:lastDragger')
AddEventHandler('esx_policejob:lastDragger', function()
	Draging = false
end)

RegisterNetEvent('esx_policejob:draging')
AddEventHandler('esx_policejob:draging', function(copID)
	Draging = not Draging
	if Draging then
		loadanimdict_police('switch@trevor@escorted_out')
		TaskPlayAnim(PlayerPedId(), 'switch@trevor@escorted_out', '001215_02_trvs_12_escorted_out_idle_guard2', 8.0, 1.0, -1, 49, 0, 0, 0, 0)
		Citizen.CreateThread(function()
			while Draging do
				Wait(0)
				DisableControlAction(2, Keys['LEFTSHIFT'], true)
				DisableControlAction(2, Keys['SPACE'], true)
				DisableControlAction(0, Keys['LEFTSHIFT'], true)
				DisableControlAction(0, Keys['SPACE'], true)
				DisableControlAction(0, Keys['K'], true)
				DisableControlAction(0, Keys['x'], true)
				if IsEntityPlayingAnim(PlayerPedId(), 'switch@trevor@escorted_out', '001215_02_trvs_12_escorted_out_idle_guard2', 3) then

				else
					TaskPlayAnim(PlayerPedId(), 'switch@trevor@escorted_out', '001215_02_trvs_12_escorted_out_idle_guard2', 8.0, 1.0, -1, 49, 0, 0, 0, 0)
				end
			end
		end)
		dragiss = true
		TriggerEvent('police:gargbygang', true)
	else
		Wait(300)
		ClearPedTasks(PlayerPedId())
		TriggerEvent('police:gargbygang', false)
	end
end)

Citizen.CreateThread(function()
	local trackedEntities = {
		'prop_mp_cone_02',
		'prop_mp_barrier_02b',
		'prop_barrier_work05',
		'prop_mp_arrow_barrier_01'
	}

	while true do
		Citizen.Wait(500)

		local playerPed = PlayerPedId()
		local coords    = GetEntityCoords(playerPed)

		local closestDistance = -1
		local closestEntity   = nil

		for i=1, #trackedEntities, 1 do
			local object = GetClosestObjectOfType(coords.x, coords.y, coords.z, 3.0, GetHashKey(trackedEntities[i]), false, false, false)

			if DoesEntityExist(object) then
				local objCoords = GetEntityCoords(object)
				local distance  = GetDistanceBetweenCoords(coords, objCoords, true)

				if closestDistance == -1 or closestDistance > distance then
					closestDistance = distance
					closestEntity   = object
				end
			end
		end

		if closestDistance ~= -1 and closestDistance <= 3.0 then
			if LastEntity ~= closestEntity then
				TriggerEvent('esx_policejob:hasEnteredEntityZone', closestEntity)
				LastEntity = closestEntity
			end
		else
			if LastEntity ~= nil then
				TriggerEvent('esx_policejob:hasExitedEntityZone', LastEntity)
				LastEntity = nil
			end
		end
	end
end)

RegisterNetEvent('esx_policejob:putInVehicle')
AddEventHandler('esx_policejob:putInVehicle', function()
	local playerPed = PlayerPedId()
	local coords    = GetEntityCoords(playerPed)

	if not IsHandcuffed then

		return
	end

	if IsAnyVehicleNearPoint(coords.x, coords.y, coords.z, 5.0) then
		local vehicle = ESX.Game.GetClosestVehicle(coords)
		if DoesEntityExist(vehicle) then

			local maxSeats = GetVehicleMaxNumberOfPassengers(vehicle)
			local freeSeat = nil

			for i=maxSeats - 1, 0, -1 do
				if IsVehicleSeatFree(vehicle, i) then
					freeSeat = i
					break
				end
			end

			if freeSeat ~= nil then
				TaskWarpPedIntoVehicle(playerPed, vehicle, freeSeat)
				TriggerEvent("Unique_Scripts_HuD:changeStatus", true)
				TriggerEvent('autobelt')
				DragStatus.IsDragged = false
			end

		end

	end
end)

RegisterNetEvent('esx_policejob:OutVehicle')
AddEventHandler('esx_policejob:OutVehicle', function()
	local playerPed = PlayerPedId()

	if not (IsPedSittingInAnyVehicle(playerPed) and IsHandcuffed) then
		return
	end

	local vehicle = GetVehiclePedIsIn(playerPed, false)
	TaskLeaveVehicle(playerPed, vehicle, 16)
	SetTimeout(1000, function()
		if FrontHandCuffed then
			loadanimdict_police('anim@move_m@prisoner_cuffed')
			TaskPlayAnim(PlayerPedId(), 'anim@move_m@prisoner_cuffed', 'idle', 8.0, -8, -1, 49, 0.0, false, false, false)
		else
			loadanimdict_police('mp_arresting')
			TaskPlayAnim(PlayerPedId(), 'mp_arresting', 'idle', 8.0, -8, -1, 49, 0.0, false, false, false)
		end
	end)
end)

RegisterNetEvent('esx_policejob:getarrested')
AddEventHandler('esx_policejob:getarrested', function(playerheading, playercoords, playerlocation, faction, front)
	playerPed = PlayerPedId()
	SetCurrentPedWeapon(playerPed, GetHashKey('WEAPON_UNARMED'), true)
	ESX.UI.Menu.CloseAll()
    ESX.SetPlayerData('isSentenced', true)
	local x, y, z   = table.unpack(playercoords + playerlocation * 1.0)
	TriggerServerEvent('esx_uniquejobs:AntiCheatExempt', 5000, { teleport = true, speed = true })
	SetEntityCoords(PlayerPedId(), x, y, z)
	if front then
		FrontHandCuffed = true
		SetEntityHeading(PlayerPedId(), playerheading - 180.0)
	else
		SetEntityHeading(PlayerPedId(), playerheading)
	end
	Citizen.Wait(250)
	if not front then
		loadanimdict_police('mp_arrest_paired')
		TaskPlayAnim(PlayerPedId(), 'mp_arrest_paired', 'crook_p2_back_right', 8.0, -8, 3750 , 2, 0, 0, 0, 0)
		TriggerEvent('disableXDuringAnimation_police')
		TriggerEvent('esx_policejob:incuffhas', true)
		TriggerEvent('Unique_Scripts_HuD:offandOnL', true)

	else
		loadanimdict_police('anim@move_m@prisoner_cuffed')
		TaskPlayAnim(PlayerPedId(), 'anim@move_m@prisoner_cuffed', 'idle', 8.0, -8, 6000 , 2, 0, 0, 0, 0)
	end
	if not front then
		Citizen.Wait(3760)
	else
		Citizen.Wait(6000)
		loadanimdict_police('anim@move_m@prisoner_cuffed')
		TaskPlayAnim(PlayerPedId(), 'anim@move_m@prisoner_cuffed', 'idle', 8.0, -8, -1, 49, 0.0, false, false, false)
	end
	IsHandcuffed = true
	TriggerCuffCitizen_police()
	TriggerServerEvent('esx_policejob:SetCuffStatus', faction)

	if not front then

		loadanimdict_police('mp_arresting')
		TaskPlayAnim(PlayerPedId(), 'mp_arresting', 'idle', 8.0, -8, -1, 49, 0.0, false, false, false)

	end
	TriggerEvent('skinchanger:getSkin', function(skin)
		if tonumber(skin.sex) == 0 then
			SetPedComponentVariation(playerPed,7,47,0,0)
		else
			SetPedComponentVariation(playerPed,7,25,0,0)
		end
	end)
	ESX.UI.Menu.CloseAll()
end)

RegisterNetEvent('disableXDuringAnimation_police')
AddEventHandler('disableXDuringAnimation_police', function()
	Citizen.CreateThread(function()

		local startTime = GetGameTimer()
		while (GetGameTimer() - startTime) < 5000 do
			Citizen.Wait(0)

			DisableControlAction(0, 73, true)
		end
	end)

end)

RegisterNetEvent('esx_policejob:doarrested')
AddEventHandler('esx_policejob:doarrested', function(front)
	ClearPedTasks(PlayerPedId())
	local Idies = ESX.Game.GetPlayersServerIdInArea(GetEntityCoords(PlayerPedId()), 5.0)
	TriggerServerEvent('InteractSound_SV:PlayWithinDistance', 2.0, 'cuff', 1.0)
	local function DisableControl()
		SetTimeout(0, function()
			DisableAllControlActions(0)
			DisableControl()
		end)
	end
	DisableControl()
	Citizen.Wait(250)
	if not front then
		loadanimdict_police('mp_arrest_paired')
		TaskPlayAnim(PlayerPedId(), 'mp_arrest_paired', 'cop_p2_back_right', 8.0, -8,3750, 2, 0, 0, 0, 0)
	else
		loadanimdict_police('mp_arresting')
		TaskPlayAnim(PlayerPedId(), 'mp_arresting', 'a_uncuff', 8.0, -8,6000, 2, 0, 0, 0, 0)
	end
	Citizen.Wait(3000)


	DisableControl = function() return nil end


end)

RegisterNetEvent('esx_policejob:douncuffing')
AddEventHandler('esx_policejob:douncuffing', function()
	ClearPedTasks(PlayerPedId())
	local Idies = ESX.Game.GetPlayersServerIdInArea(GetEntityCoords(PlayerPedId()), 5.0)
	TriggerServerEvent('InteractSound_SV:PlayWithinDistance', 2.0, 'uncuff', 1.0)
	local function DisableControl()
		SetTimeout(0, function()
			DisableAllControlActions(0)
			DisableControl()
		end)
	end
	DisableControl()
	SetCurrentPedWeapon(PlayerPedId(), GetHashKey('WEAPON_UNARMED'), true)
	Citizen.Wait(250)
	loadanimdict_police('mp_arresting')
	TaskPlayAnim(PlayerPedId(), 'mp_arresting', 'a_uncuff', 8.0, -8,-1, 2, 0, 0, 0, 0)
	Citizen.Wait(5500)
	ClearPedTasks(PlayerPedId())
	Draging = false

	DisableControl = function() return nil end
end)

RegisterNetEvent('esx_policejob:getuncuffed')
AddEventHandler('esx_policejob:getuncuffed', function(playerheading, playercoords, playerlocation)
	local x, y, z   = table.unpack(playercoords + playerlocation * 1.0)
	TriggerEvent('esx_policejob:incuffhas', false)
	TriggerEvent('Unique_Scripts_HuD:offandOnL', false)
	TriggerServerEvent('esx_uniquejobs:AntiCheatExempt', 5000, { teleport = true, speed = true })
	SetEntityCoords(PlayerPedId(), x, y, z)
	if not FrontHandCuffed then
		SetEntityHeading(PlayerPedId(), playerheading)

	else
		SetEntityHeading(PlayerPedId(), playerheading - 180.0)

	end
	Citizen.Wait(250)
	if not FrontHandCuffed then
		loadanimdict_police('mp_arresting')
		TaskPlayAnim(PlayerPedId(), 'mp_arresting', 'b_uncuff', 8.0, -8,-1, 2, 0, 0, 0, 0)
		IsHandcuffed = false

	else
		loadanimdict_police('anim@move_m@prisoner_cuffed')
		TaskPlayAnim(PlayerPedId(), 'anim@move_m@prisoner_cuffed', 'idle', 8.0, -8,-1, 2, 0, 0, 0, 0)
		IsHandcuffed = false

	end
	Citizen.Wait(5500)
	IsHandcuffed = false

	DragStatus.IsDragged = false
	DetachEntity(playerPed, true, false)
	TriggerServerEvent('esx_policejob:SetCuffStatus', false)
	IsHandcuffed = false
	ClearPedTasks(PlayerPedId())
	SetPedComponentVariation(PlayerPedId(),7,0,0,0)
	ESX.SetPlayerData('isSentenced', false)


end)

AddEventHandler('playerSpawned', function(spawn)
	isDead = false
	TriggerEvent('esx_policejob:unrestrain')
end)

AddEventHandler('esx:onPlayerDeath', function(data)
	isDead = true
end)

function StartHandcuffTimer_police()
	if Config_police.EnableHandcuffTimer and HandcuffTimer.Active then
		ESX.ClearTimeout(HandcuffTimer.Task)
	end

	HandcuffTimer.Active = true

	HandcuffTimer.Task = ESX.SetTimeout(Config_police.HandcuffTimer, function()
		ESX.ShowNotification(_U('unrestrained_timer'))
		TriggerEvent('esx_policejob:unrestrain')
		HandcuffTimer.Active = false
	end)
end

function ImpoundVehicle_police(vehicle)
	ESX.Game.DeleteVehicle(vehicle)
	ESX.ShowNotification(_U('impound_successful'))
	CurrentTask.Busy = false
end

local function has_value (tab, val)
	for index, value in ipairs(tab) do
		if value == val then
			return true
		end
	end

	return false
end

function ToggleVehicleLock_police()
	local xPlayer = ESX.GetPlayerData()
	if has_value("police", xPlayer.job.name) then

	end
	local playerPed = PlayerPedId()
	local coords = GetEntityCoords(playerPed)
	local vehicle

	if IsPedInAnyVehicle(playerPed, false) then
		vehicle = GetVehiclePedIsIn(playerPed, false)
	else
		vehicle = GetClosestVehicle(coords, 8.0, 0, 70)
	end
	local plate = GetVehicleNumberPlateText(vehicle)
	plate = string.gsub(plate, " ", "")
	if not DoesEntityExist(vehicle) then
		return
	end

	if myPlate ~= nil then
		for i=1, #myPlate, 1 do
			if myPlate[i] == plate then

				local lockStatus = GetVehicleDoorLockStatus(vehicle)

				if lockStatus == 1 then
					SetVehicleDoorsLocked(vehicle, 2)
					PlayVehicleDoorCloseSound(vehicle, 1)

					TriggerEvent('chat:addMessage', { args = { _U('message_title'), _U('message_locked') } })
				elseif lockStatus == 2 then
					SetVehicleDoorsLocked(vehicle, 1)
					PlayVehicleDoorOpenSound(vehicle, 0)

					TriggerEvent('chat:addMessage', { args = { _U('message_title'), _U('message_unlocked') } })
				end
			end
		end
	end
end

RegisterNetEvent("esx_policejob:stopAnim")
AddEventHandler("esx_policejob:stopAnim", function(player)
    Citizen.CreateThread(function()
        Citizen.Wait(1)
        ClearPedTasks(PlayerPedId())
    end)
end)

RegisterNetEvent("esx_policejob:stopAnim")
AddEventHandler("esx_policejob:stopAnim", function(player)
    Citizen.CreateThread(function()
        Citizen.Wait(1)
        ClearPedTasks(PlayerPedId())
    end)
end)

function EnableActions_police(ped)
	EnableControlAction(1, 140, true)
	DisableControlAction(0, Keys['x'], true)
	EnableControlAction(1, 141, true)
	EnableControlAction(1, 142, true)
	EnableControlAction(1, 37, true)
	DisablePlayerFiring(ped, false)
end

function DisableActions_police(ped)
	DisableControlAction(1, 140, true)
	DisableControlAction(1, 141, true)
	DisableControlAction(1, 142, true)
	DisableControlAction(0, Keys['K'], true)
	DisableControlAction(2, Keys['x'], true)
	DisableControlAction(1, 37, true)
	DisablePlayerFiring(ped, true)
end

function loadanimdict_police(dictname)
	if not HasAnimDictLoaded(dictname) then
		RequestAnimDict(dictname)
		while not HasAnimDictLoaded(dictname) do
			Citizen.Wait(1)
		end
	end
end

function TriggerCuffCitizen_police()
	Citizen.CreateThread(function()
		while IsHandcuffed do
			Citizen.Wait(1)
			local playerPed = PlayerPedId()

			if DragStatus.IsDragged then
				local targetPed = GetPlayerPed(GetPlayerFromServerId(DragStatus.CopId))


				if not IsPedSittingInAnyVehicle(targetPed) then

					AttachEntityToEntity(playerPed, targetPed, 11816, -0.06, 0.65, 0.0, 0.0, 0.0, 0.0, false, false, false, false, 2, true)
				else
					DragStatus.IsDragged = false
					DetachEntity(playerPed, true, false)
				end

			else
				DetachEntity(playerPed, true, false)
			end
		end
	end)


	Citizen.CreateThread(function()
		while IsHandcuffed do
			Citizen.Wait(2)

			DisableControlAction(2, Keys['~'], true)
			DisableControlAction(2, Keys['X'], true)
			DisableControlAction(2, Keys['ESC'], true)
			DisableControlAction(2, Keys['F6'], true)
			DisableControlAction(2, Keys['F2'], true)
			DisableControlAction(2, Keys['ENTER'], true)
			DisableControlAction(2, Keys['LEFTSHIFT'], true)
			DisableControlAction(2, Keys['R'], true)
			DisableControlAction(2, Keys['TOP'], true)
			DisableControlAction(2, Keys['TAB'], true)
			DisableControlAction(2, Keys['SPACE'], true)
			DisableControlAction(2, Keys['Q'], true)
			DisableControlAction(0, Keys['E'], true)
			DisableControlAction(0, Keys['PAGEUP'], true)
			DisableControlAction(0, Keys['K'], true)
			DisableControlAction(2, Keys['TAB'], true)
			DisableControlAction(2, Keys['F'], true)
			DisableControlAction(0, Keys['F1'], true)
			DisableControlAction(2, Keys['F2'], true)
			DisableControlAction(2, Keys['F3'], true)
			DisableControlAction(2, Keys['F5'], true)
			DisableControlAction(2, Keys['F8'], true)
			DisableControlAction(2, Keys['H'], true)
			DisableControlAction(2, Keys['M'], true)
			DisableControlAction(2, Keys['V'], true)
			DisableControlAction(2, Keys['P'], true)
			DisableControlAction(2, Keys['L'], true)
			DisableControlAction(2, 59, true)
			DisableControlAction(2, Keys['LEFTCTRL'], true)
			DisableControlAction(2, 24, true)
			DisableControlAction(2, 257, true)
			DisableControlAction(2, 25, true)
			DisableControlAction(2, 263, true)
			DisableControlAction(2, 59, true)
			DisableControlAction(0, 47, true)
			DisableControlAction(0, 264, true)
			DisableControlAction(0, 257, true)
			DisableControlAction(0, 140, true)
			DisableControlAction(0, 141, true)
			DisableControlAction(0, 142, true)
			DisableControlAction(0, 143, true)
			DisableControlAction(0, 75, true)
			DisableControlAction(27, 75, true)
			DisableControlAction(0, 107, true)
			DisableControlAction(0, 108, true)
			DisableControlAction(0, 109, true)
			DisableControlAction(0, 110, true)
			DisableControlAction(0, 111, true)
			DisableControlAction(0, 112, true)
			if IsPedInAnyVehicle(PlayerPedId(), false) then
				SetCurrentPedWeapon(PlayerPedId(), GetHashKey("weapon_unarmed"), true)
			end
			if IsEntityPlayingAnim(PlayerPedId(), 'mp_arresting', 'idle', 3) then
			else
				loadanimdict_police('mp_arresting')
				TaskPlayAnim(playerPed, 'mp_arresting', 'idle', 8.0, -8, -1, 49, 0.0, false, false, false)
			end
		end
	end)

end

Citizen.CreateThread(function()

	for k,v in pairs(Config_police.PoliceStations) do

		local blip = AddBlipForCoord(v.Blip.Pos.x, v.Blip.Pos.y, v.Blip.Pos.z)

		SetBlipSprite (blip, v.Blip.Sprite)
		SetBlipDisplay(blip, v.Blip.Display)
		SetBlipScale  (blip, v.Blip.Scale)
		SetBlipColour (blip, v.Blip.Colour)
		SetBlipAsShortRange(blip, true)

		BeginTextCommandSetBlipName("STRING")
		AddTextComponentString(_U('map_blip'))
		EndTextCommandSetBlipName(blip)

	end
end)

Citizen.CreateThread(function()

	for k,v in pairs(Config_police.PoliceStations) do

		local blip = AddBlipForCoord(v.Blip2.Pos.x, v.Blip2.Pos.y, v.Blip2.Pos.z)

		SetBlipSprite (blip, v.Blip2.Sprite)
		SetBlipDisplay(blip, v.Blip2.Display)
		SetBlipScale  (blip, v.Blip2.Scale)
		SetBlipColour (blip, v.Blip2.Colour)
		SetBlipAsShortRange(blip, true)

		BeginTextCommandSetBlipName("STRING")
		AddTextComponentString(_U('map_blip'))
		EndTextCommandSetBlipName(blip)

	end
end)

function mainThreads_police()

	Citizen.CreateThread(function()
		while PlayerData.job and PlayerData.job.name == 'police' do

			Citizen.Wait(3)

			if PlayerData.job ~= nil and PlayerData.job.name == 'police' and PlayerData.job.grade >= 0 then

			local canSleep  = true
			local playerPed = PlayerPedId()
			local coords    = GetEntityCoords(playerPed)

			for k,v in pairs(Config_police.PoliceStations) do

				for i=1, #v.Cloakrooms, 1 do
					if GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()),  v.Cloakrooms[i].x,  v.Cloakrooms[i].y,  v.Cloakrooms[i].z,  true) < 5 then
						canSleep = false
						DrawMarker(22, v.Cloakrooms[i].x, v.Cloakrooms[i].y, v.Cloakrooms[i].z, 0.0, 0.0, 0.0, 0, 0.0, 0.0, 1.0, 1.0, 1.0, Config_police.MarkerColor.r, Config_police.MarkerColor.g, Config_police.MarkerColor.b, 100, false, true, 2, false, false, false, false)
					end
				end

				for i=1, #v.Armories, 1 do
					if GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()),  v.Armories[i].x,  v.Armories[i].y,  v.Armories[i].z,  true) < 5 then
					canSleep = false
						DrawMarker(22, v.Armories[i].x, v.Armories[i].y, v.Armories[i].z, 0.0, 0.0, 0.0, 0, 0.0, 0.0,  1.0, 1.0, 1.0, Config_police.MarkerColor.r, Config_police.MarkerColor.g, Config_police.MarkerColor.b, 100, false, true, 2, false, false, false, false)
					end
				end

				for i=1, #v.Vehicles, 1 do
				canSleep = false
					if GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()),  v.Vehicles[i].Spawner.x,  v.Vehicles[i].Spawner.y,  v.Vehicles[i].Spawner.z,  true) < 5 then
						DrawMarker(36, v.Vehicles[i].Spawner.x, v.Vehicles[i].Spawner.y, v.Vehicles[i].Spawner.z, 0.0, 0.0, 0.0, 0, 0.0, 0.0,  1.0, 1.0, 1.0, 0, 255, 0, 100, false, true, 2, false, false, false, false)
					end
				end

				for i=1, #v.Helicopters, 1 do
					canSleep = false
						if GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()),  v.Helicopters[i].Spawner.x,  v.Helicopters[i].Spawner.y,  v.Helicopters[i].Spawner.z,  true) < 5 then
							DrawMarker(34, v.Helicopters[i].Spawner.x, v.Helicopters[i].Spawner.y, v.Helicopters[i].Spawner.z, 0.0, 0.0, 0.0, 0, 0.0, 0.0,  1.0, 1.0, 1.0, Config_police.MarkerColor.r, Config_police.MarkerColor.g, Config_police.MarkerColor.b, 100, false, true, 2, false, false, false, false)
						end
					end

				for i=1, #v.VehicleDeleters, 1 do
				canSleep = false
					if GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()),  v.VehicleDeleters[i].x,  v.VehicleDeleters[i].y,  v.VehicleDeleters[i].z,  true) < 5 then
						DrawMarker(24, v.VehicleDeleters[i].x, v.VehicleDeleters[i].y, v.VehicleDeleters[i].z, 0.0, 0.0, 0.0, 0, 0.0, 0.0, 1.0, 1.0, 1.0, 255, 0, 0, 100, false, true, 2, false, false, false, false)
					end
				end

				if Config_police.EnablePlayerManagement and PlayerData.job ~= nil and PlayerData.job.name == 'police' then

					for i=1, #v.BossActions, 1 do
						if not v.BossActions[i].disabled and GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()),  v.BossActions[i].x,  v.BossActions[i].y,  v.BossActions[i].z,  true) < 5 then
						DrawMarker(29, v.BossActions[i].x, v.BossActions[i].y, v.BossActions[i].z, 0.0, 0.0, 0.0, 0, 0.0, 0.0, 1.0, 1.0, 1.0, 255, 255, 255, 100, false, true, 2, false, false, false, false)
						end
					end

				end

			end
			if canSleep then
				Citizen.Wait(500)
				end
			end

		end
	end)


	Citizen.CreateThread(function()

	while PlayerData.job and PlayerData.job.name == 'police' do

		Citizen.Wait(1000)

		if PlayerData.job ~= nil and PlayerData.job.name == 'police' and PlayerData.job.grade >= 0 then

		local playerPed      = PlayerPedId()
		local coords         = GetEntityCoords(playerPed)
		local isInMarker     = false
		local currentStation = nil
		local currentPart    = nil
		local currentPartNum = nil

		for k,v in pairs(Config_police.PoliceStations) do

			for i=1, #v.Cloakrooms, 1 do
			if GetDistanceBetweenCoords(coords,  v.Cloakrooms[i].x,  v.Cloakrooms[i].y,  v.Cloakrooms[i].z,  true) < Config_police.MarkerSize.x then
				isInMarker     = true
				currentStation = k
				currentPart    = 'Cloakroom'
				currentPartNum = i
			end
			end

			for i=1, #v.Armories, 1 do
			if GetDistanceBetweenCoords(coords,  v.Armories[i].x,  v.Armories[i].y,  v.Armories[i].z,  true) < Config_police.MarkerSize.x then
				isInMarker     = true
				currentStation = k
				currentPart    = 'Armory'
				currentPartNum = i
			end
			end

			for i=1, #v.Vehicles, 1 do

			if GetDistanceBetweenCoords(coords,  v.Vehicles[i].Spawner.x,  v.Vehicles[i].Spawner.y,  v.Vehicles[i].Spawner.z,  true) < Config_police.MarkerSize.x then
				isInMarker     = true
				currentStation = k
				currentPart    = 'VehicleSpawner'
				currentPartNum = i
			end

			if GetDistanceBetweenCoords(coords,  v.Vehicles[i].SpawnPoint.x,  v.Vehicles[i].SpawnPoint.y,  v.Vehicles[i].SpawnPoint.z,  true) < Config_police.MarkerSize.x then
				isInMarker     = true
				currentStation = k
				currentPart    = 'VehicleSpawnPoint'
				currentPartNum = i
			end

			end

			for i=1, #v.Helicopters, 1 do

			if GetDistanceBetweenCoords(coords,  v.Helicopters[i].Spawner.x,  v.Helicopters[i].Spawner.y,  v.Helicopters[i].Spawner.z,  true) < Config_police.MarkerSize.x then
				isInMarker     = true
				currentStation = k
				currentPart    = 'HelicopterSpawner'
				currentPartNum = i
			end

			if GetDistanceBetweenCoords(coords,  v.Helicopters[i].SpawnPoint.x,  v.Helicopters[i].SpawnPoint.y,  v.Helicopters[i].SpawnPoint.z,  true) < Config_police.MarkerSize.x then
				isInMarker     = true
				currentStation = k
				currentPart    = 'HelicopterSpawnPoint'
				currentPartNum = i
			end

			end

			for i=1, #v.VehicleDeleters, 1 do
			if GetDistanceBetweenCoords(coords,  v.VehicleDeleters[i].x,  v.VehicleDeleters[i].y,  v.VehicleDeleters[i].z,  true) < Config_police.MarkerSize.x then
				isInMarker     = true
				currentStation = k
				currentPart    = 'VehicleDeleter'
				currentPartNum = i
			end
			end

			if Config_police.EnablePlayerManagement and PlayerData.job ~= nil and PlayerData.job.name == 'police' then

			for i=1, #v.BossActions, 1 do
				if GetDistanceBetweenCoords(coords,  v.BossActions[i].x,  v.BossActions[i].y,  v.BossActions[i].z,  true) < Config_police.MarkerSize.x then
				isInMarker     = true
				currentStation = k
				currentPart    = 'BossActions'
				currentPartNum = i
				end
			end

			end
		end

		local hasExited = false

		if isInMarker and not HasAlreadyEnteredMarker or (isInMarker and (LastStation ~= currentStation or LastPart ~= currentPart or LastPartNum ~= currentPartNum) ) then

			if
			(LastStation ~= nil and LastPart ~= nil and LastPartNum ~= nil) and
			(LastStation ~= currentStation or LastPart ~= currentPart or LastPartNum ~= currentPartNum)
			then
			TriggerEvent('esx_policejob:hasExitedMarker', LastStation, LastPart, LastPartNum)
			hasExited = true
			end

			HasAlreadyEnteredMarker = true
			LastStation             = currentStation
			LastPart                = currentPart
			LastPartNum             = currentPartNum

			TriggerEvent('esx_policejob:hasEnteredMarker', currentStation, currentPart, currentPartNum)
		end

		if not hasExited and not isInMarker and HasAlreadyEnteredMarker then

			HasAlreadyEnteredMarker = false

			TriggerEvent('esx_policejob:hasExitedMarker', LastStation, LastPart, LastPartNum)
		end
		else
		Citizen.Wait(1500)
		end

	end
	end)


	Citizen.CreateThread(function()
		while PlayerData.job and PlayerData.job.name == 'police' do

			Citizen.Wait(1)

			if CurrentAction ~= nil then
				SetTextComponentFormat('STRING')
				AddTextComponentString(CurrentActionMsg)
				DisplayHelpTextFromStringLabel(0, 0, 1, -1)

				if IsControlJustReleased(0, Keys['E']) and PlayerData.job ~= nil and PlayerData.job.name == 'police' and PlayerData.job.grade >= 0 then

					if CurrentAction == 'menu_cloakroom' then
						OpenCloakroomMenu_police()
					elseif CurrentAction == 'menu_armory' then
						if Config_police.MaxInService == -1 then
							OpenArmoryMenu_police(CurrentActionData.station)
						elseif playerInService then
							OpenArmoryMenu_police(CurrentActionData.station)
						else
							ESX.ShowNotification(_U('service_not'))
						end
					elseif CurrentAction == 'menu_vehicle_spawner' then
						OpenVehicleSpawnerMenu_police(CurrentActionData.station, CurrentActionData.partNum)
					elseif CurrentAction == 'menu_heli_spawner' then
						OpenheliSpawnerMenu_police(CurrentActionData.station, CurrentActionData.partNum)
					elseif CurrentAction == 'delete_vehicle' then
						if Config_police.EnableSocietyOwnedVehicles then

							local vehicleProps = ESX.Game.GetVehicleProperties(CurrentActionData.vehicle)
							TriggerServerEvent('esx_society:putVehicleInGarage', 'police', vehicleProps)

						end
						local vehicleModel = GetEntityModel(CurrentActionData.vehicle)
						local vehicleLabel = GetLabelText(GetDisplayNameFromVehicleModel(vehicleModel))
						local plate = GetVehicleNumberPlateText(CurrentActionData.vehicle)
						local playerIdentifier = ESX.GetPlayerData().identifier
						local playerPed = PlayerPedId()
						local xPlayer = ESX.GetPlayerData()
						ESX.Game.DeleteVehicle(CurrentActionData.vehicle)

					TriggerServerEvent('logpdVehicleSpawn', xPlayer.name, GetPlayerServerId(PlayerId()), playerIdentifier, vehicleLabel, plate, false)
					elseif CurrentAction == 'boss_actions' then
						ESX.UI.Menu.CloseAll()
						TriggerEvent('esx_society:openBosscarysMenu', 'police', function(data, menu)
							menu.close()

							CurrentAction     = 'boss_actions'
							CurrentActionMsg  = _U('open_bossmenu')
							CurrentActionData = {}
						end, { wash = false })

					elseif CurrentAction == 'remove_entity' then
						DeleteEntity(CurrentActionData.entity)
					end

					CurrentAction = nil
				end
			end

			if IsControlJustReleased(0, Keys['F6']) and not isDead and PlayerData.job ~= nil and PlayerData.job.name == 'police' and PlayerData.job.grade >= 0 and not ESX.UI.Menu.IsOpen('default', GetCurrentResourceName(), 'police_actions') then
				if Config_police.MaxInService == -1 then
					OpenPoliceActionsMenu_police()
				elseif playerInService then
					OpenPoliceActionsMenu_police()
				else
					ESX.ShowNotification(_U('service_not'))
				end
			end

			if IsControlJustReleased(0, Keys['E']) then

			if CurrentTask.Busy then

				ESX.ShowNotification(_U('impound_canceled'))
				ESX.ClearTimeout(CurrentTask.Task)
				ClearPedTasks(PlayerPedId())

				CurrentTask.Busy = false

			end

			if BackupX ~= nil and BackupY ~= nil then

				SetNewWaypoint(BackupX, BackupY)
				BackupX = nil
				BackupY = nil
				showit = false

			end

			end



		end



	end)

end

local playerPed = PlayerPedId()

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		if IsPedInAnyVehicle(PlayerPedId(), false) then
			local veh = GetVehiclePedIsIn(PlayerPedId(), false)
			if IsVehicleSeatFree(veh, -1) then
				if not notified then
					if GetPedInVehicleSeat(veh, 0) == PlayerPedId() then
						notified = true
						ESX.ShowHelpNotification('~INPUT_CONTEXT~ Neshastan Poshte Farmon')
						ActivateTask()
					else
						notified = false
					end
				end
				if IsControlJustReleased(0, 38) and GetPedInVehicleSeat(veh, 0) == PlayerPedId() and not IsHandcuffed then
					notified = false
					Citizen.Wait(5000)
				end
				if IsControlJustReleased(0, 23) and not IsHandcuffed then
					ClearPedTasks(PlayerPedId())
				end
			end
		else
			Citizen.Wait(500)
			notified = false
		end
	end
end)

AddEventHandler('playerSpawned', function(spawn)
	isDead = false
	TriggerEvent('esx_policejob:unrestrain')

	if not hasAlreadyJoined then
		TriggerServerEvent('esx_policejob:spawned')
	end
	hasAlreadyJoined = true
end)

AddEventHandler('esx:onPlayerDeath', function(data)
	isDead = true
end)

AddEventHandler('onResourceStop', function(resource)
	if resource == GetCurrentResourceName() then
		TriggerEvent('esx_policejob:unrestrain')
		TriggerEvent('esx_phone:removeSpecialContact', 'police')

		if Config_police.MaxInService ~= -1 then
			TriggerServerEvent('esx_service:disableService', 'police')
		end

		if Config_police.EnableHandcuffTimer and HandcuffTimer.Active then
			ESX.ClearTimeout(HandcuffTimer.Task)
		end
	end
end)



RegisterNetEvent('esx_policejob:setwaypoint')
AddEventHandler('esx_policejob:setwaypoint', function(x, y)
	SetNewWaypoint(x, y)
end)

function loadanimdict_police(dictname)
	if not HasAnimDictLoaded(dictname) then
		RequestAnimDict(dictname)
		while not HasAnimDictLoaded(dictname) do
			Citizen.Wait(1)
		end
	end
end

function contains_police(table, val)
	for i = 1, #table do
		if table[i].name == val then
			return true
		end
	end
	return false
end

local inPaintBall = false
local inCapture = false

AddEventHandler('esx_paintball:inPaintBall', function(state) inPaintBall = state end)
AddEventHandler('capture:inCapture', function(bool) inCapture = bool end)

local send = true
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(10)
        local ped = PlayerPedId()
        if IsPedShooting(ped) and not IsPedCurrentWeaponSilenced(ped) and not inPaintBall and not inCapture and send then
            local playerCoords = GetEntityCoords(ped)
		    local streetName = GetStreetNameAtCoord(playerCoords.x, playerCoords.y, playerCoords.z)
		    local streetName2 = GetStreetNameFromHashKey(streetName)
            TriggerServerEvent("Police:ShotsAlarm", playerCoords.x, playerCoords.y, playerCoords.z, streetName2)
            send = false
            Citizen.Wait(10000)
            send = true
        end
    end
end)

RegisterNetEvent("Police:ShotsAlarm")
AddEventHandler("Police:ShotsAlarm", function(x, y, z, street)
    if ESX == nil then return end
    if PlayerData == nil or PlayerData.job == nil then return end
	if #( vector3( x,y,z) - GetEntityCoords(PlayerPedId()) ) > 310.0 then return end
    if PlayerData.job.name ~= nil and (PlayerData.job.name == "police" or PlayerData.job.name == "sheriff" or PlayerData.job.name == "fbi" or PlayerData.job.name == "mt" or PlayerData.job.name == "cid" or PlayerData.job.name == "cia" or PlayerData.job.name == "marshal" or PlayerData.job.name == "judge" or PlayerData.job.name == "doa") then
        SendNotif_police("~r~Tir Andazi ~w~Dar ~y~"..street)
        local alpha = 250
        local gunshotBlip = AddBlipForRadius(x, y, z, 50.0)
        SetBlipHighDetail(gunshotBlip, true)
        SetBlipColour(gunshotBlip, 1)
        SetBlipAlpha(gunshotBlip, alpha)
        SetBlipAsShortRange(gunshotBlip, true)
        while alpha ~= 0 do
            Citizen.Wait(7 * 4)
            alpha = alpha - 1
            SetBlipAlpha(gunshotBlip, alpha)
            if alpha == 0 then
                RemoveBlip(gunshotBlip)
                return
            end
        end
    end
end)

function SendNotif_police(msg)
	SetNotificationTextEntry('STRING')
	AddTextComponentString(msg)
	DrawNotification(0,1)
end

RegisterNetEvent('esx_policejob:notifyp')
  AddEventHandler('esx_policejob:notifyp', function(message, passedJob)

	  if PlayerData.job.name == "police" or PlayerData.job.name == "sheriff" or PlayerData.job.name == "mt" or PlayerData.job.name == "fbi" or PlayerData.job.name == "cid" or PlayerData.job.name == "cia" or PlayerData.job.name == "marshal" or PlayerData.job.name == "judge" or PlayerData.job.name == "doa" then
		TriggerEvent('chat:addMessage', { color = {0, 95, 254}, multiline = true, args = {"[ Dispatch] ("..passedJob..") : ", message}})
	  end





end)

RegisterNetEvent('esx:setcallsign')
  AddEventHandler('esx:setcallsign', function(sign)
	if PlayerData.job.name == "police" then
		callsign = sign
	end
end)

function OpendivisionsMenu_police()
    ESX.TriggerServerCallback('esx_society:divisionsPlayer', function(check)
        local elements = {}

        for k, v in pairs(check) do
            if v.status then
                table.insert(elements, {
                    name = v.name,
                    label = v.label.." | [<font color=Lime>✅</font>]",
                    status = v.status,
                })
			else
				table.insert(elements, {
                    name = v.name,
                    label = v.label.. " | [<font color=red>❌</font>]",
                    status = v.status,
                })
            end
        end

        ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'Divisions', {
            title = 'Divisions',
            align = 'left',
            elements = elements
        }, function(data, menu)

            local selectedDivision = data.current.name
            local dvisionlabel = data.current.label

            ESX.TriggerServerCallback('esx_society:swichdivision', function(success)
				OpendivisionsMenu_police()
			end, selectedDivision)

        end, function(data, menu)
            menu.close()
			OpenPoliceActionsMenu_police()
        end)
    end)
end

