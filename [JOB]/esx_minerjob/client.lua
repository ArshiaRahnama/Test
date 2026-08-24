ESX = nil
local amir = true
local golds = 0
local irons = 0
local SpawnedRockes = 0
local Rocks = {}
local duty = false
local OnDuty = false
local mining = false
local InMarker = false
local isInMarker = false
local menuOpen = false
local spawned = false
local price = {}
local washcoord = vector3(1109.82,-2008.06,31.05)
local RocksObject = {
    'prop_rock_1_a',
    'prop_rock_1_e',
    'prop_rock_1_c'
}

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(1)
	end

	while ESX.GetPlayerData().job == nil do
		Citizen.Wait(10)
	end

	PlayerData = ESX.GetPlayerData()
	blips()


end)

Citizen.CreateThread(function()
    Wait(45000)
    ESX.TriggerServerCallback('Miner:SetDuty', function(Duty)
        if Duty  == true  then
            ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin, jobSkin)
                if skin.sex == 0 then
                    TriggerEvent('skinchanger:loadClothes', skin, Config.Uniforms['work_wear'].male)
                    if true then
                        for _, info in pairs(Config.Blips) do
                        info.blip = AddBlipForCoord(info.x, info.y, info.z)
                        SetBlipSprite  (info.blip, 318)
                        SetBlipDisplay (info.blip, 4)
                        SetBlipScale(info.blip, 0.7)
                        SetBlipCategory(info.blip, 3)
                        SetBlipColour  (info.blip, 5)
                        SetBlipAsShortRange(info.blip, true)
                        BeginTextCommandSetBlipName("STRING")
                        AddTextComponentString(info.title)
                        EndTextCommandSetBlipName(info.blip)
                        end
                        amir = false
                    end
                    TriggerEvent('skinchanger:loadClothes', skin, Config.Uniforms['work_wear'].male)
                else
                    TriggerEvent('skinchanger:loadClothes', skin, Config.Uniforms['work_wear'].female)
                    if  true then
                        for _, info in pairs(Config.Blips) do
                        info.blip = AddBlipForCoord(info.x, info.y, info.z)
                        SetBlipSprite  (info.blip, 318)
                        SetBlipDisplay (info.blip, 4)
                        SetBlipScale(info.blip, 0.7)
                        SetBlipCategory(info.blip, 3)
                        SetBlipColour  (info.blip, 5)
                        SetBlipAsShortRange(info.blip, true)
                        BeginTextCommandSetBlipName("STRING")
                        AddTextComponentString(info.title)
                        EndTextCommandSetBlipName(info.blip)
                        end
                        amir = false
                    end
                    TriggerEvent('skinchanger:loadClothes', skin, Config.Uniforms['work_wear'].female)
                end
                duty = true
                OnDuty = true
                blips()
            end)
        end
    end)
end)

RegisterNetEvent('esx_miner:getPrice')
AddEventHandler('esx_miner:getPrice', function(data)
    price = data
end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
	PlayerData = xPlayer
    blips()


end)

local blipsx = {}
local blip = false
function blips()



















	if blip == false then
		blipsx = AddBlipForCoord(Config.ClackLoc.x, Config.ClackLoc.y, Config.ClackLoc.z)
		SetBlipSprite  (blipsx, 318)
		SetBlipDisplay (blipsx, 4)
		SetBlipScale(blipsx, 0.7)
		SetBlipCategory(blipsx, 3)
		SetBlipColour  (blipsx, 5)
		SetBlipAsShortRange(blipsx, true)
		BeginTextCommandSetBlipName("STRING")
		AddTextComponentString("Vasayele Mining")
		EndTextCommandSetBlipName(blipsx)
		blip = true
	end

end

function SpawRocks()
    repeat
        GenerateRockCoords(function(rockCoords)
            ESX.Game.SpawnLocalObject(RocksObject[math.random(1,3)], rockCoords, function(obj)
                PlaceObjectOnGroundProperly(obj)
                FreezeEntityPosition(obj, true)
                table.insert(Rocks, {object = obj, health = 100})
                SpawnedRockes = SpawnedRockes + 1
            end)
        end)
    until SpawnedRockes > 9
end

function GenerateRockCoords(cb)
    local coord
    repeat
		Citizen.Wait(1)

		local rockCoordX, rockCoordY

		math.randomseed(GetGameTimer())
		local modX = math.random(-35, 35)

		Citizen.Wait(100)

		math.randomseed(GetGameTimer())
		local modY = math.random(-35, 35)

		rockCoordX = Config.Rock.x + modX
		rockCoordY = Config.Rock.y + modY


		local coordZ = GetCoordZ(rockCoordX, rockCoordY)
		coord = vector3(rockCoordX, rockCoordY, coordZ)

	until ValidateRockCoord(coord)
    cb(coord)
end

function GetCoordZ(x, y)
	local groundCheckHeights = { 35.0, 36.0, 37.0, 38.0, 39.0, 40.0, 41.0, 42.0, 43.0, 44.0, 45.0, 46.0, 47.0, 48.0, 49.0, 50.0, 51.0, 52.0, 53.0, 54.0 ,55.0, 56.0, 57.0 }

	for i, height in ipairs(groundCheckHeights) do
		local foundGround, z = GetGroundZFor_3dCoord(x, y, height)

		if foundGround then
			return z
		end
	end
	return 45.0
end

function HitReward()
    local ped = GetPlayerPed(-1)
    local vehicle = GetVehiclePedIsIn(ped, true)
    local kamy = GetHashKey('rubble')
    local isVehicleKamy = IsVehicleModel(vehicle, kamy)

    if isVehicleKamy and DoesEntityExist(vehicle) then
        if GetDistanceBetweenCoords(GetEntityCoords(ped), GetEntityCoords(vehicle), true) < 60 then
            local plate = ESX.Math.Trim(GetVehicleNumberPlateText(vehicle))
            local minerSkill = exports['Unique_Skills']:CheckSkill('Miner') or 0
            TriggerServerEvent('mining:PutStoneInVehicle', plate, minerSkill)
        else
            ESX.ShowNotification('Lotfan Mashine Khodeton Ro Nazdik Tar Biyarid')
        end
    else
        ESX.ShowNotification('Shoma Ba Khodeton Kamion Nayavordid')
    end
end

function ValidateRockCoord(rockCoord)
	if SpawnedRockes > 0 then
		local validate = true

		for k, v in pairs(Rocks) do
			if GetDistanceBetweenCoords(rockCoord, GetEntityCoords(v.object), true) < 6 then
				validate = false
			end
		end

		if GetDistanceBetweenCoords(rockCoord, Config.Rock.xyz, false) > 70 then
			validate = false
		end

		return validate
	else
		return true
	end
end

function loadModel(model)
    while not HasModelLoaded(model) do Wait(1) RequestModel(model) end
    return model
end

function loadDict(dict, anim)
    while not HasAnimDictLoaded(dict) do Wait(1) RequestAnimDict(dict) end
    return dict
end

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(1)
		if OnDuty == true then
			local playerPed = PlayerPedId()
			local coords = GetEntityCoords(playerPed)
			local nearbyObject, nearbyID

			if GetDistanceBetweenCoords(coords, Config.Rock.xyz, true) < 70 and SpawnedRockes < 10 and not IsPlayerSwitchInProgress() then
				SpawRocks()
				Citizen.Wait(500)
			end

			for i=1, #Rocks, 1 do
				if GetDistanceBetweenCoords(coords, GetEntityCoords(Rocks[i].object), false) < 3 then
					nearbyObject, nearbyID = Rocks[i].object, i
				end
			end

			if nearbyObject and IsPedOnFoot(playerPed) and not IsPedUsingAnyScenario(playerPed) then
				ESX.ShowHelpNotification('Press ~INPUT_CONTEXT~ to start mine.')
				if IsControlJustReleased(0, 38) then
					mining = true
					TaskTurnPedToFaceEntity(PlayerPedId(), nearbyObject, 0.5)
					FreezeEntityPosition(PlayerPedId(), true)



					while mining do
						Wait(1)
						SetCurrentPedWeapon(PlayerPedId(), GetHashKey('WEAPON_UNARMED'))
						ESX.ShowHelpNotification('Press ~INPUT_ATTACK~ to chop, ~INPUT_FRONTEND_RRIGHT~ to stop.')
						DisableControlAction(0, 24, true)
						DisableControlAction(0, 73, true)
						DisableControlAction(0, 288, true)
						DisableControlAction(0, 289, true)
						DisableControlAction(0, 170, true)
						if IsDisabledControlJustReleased(0, 24) then
							local dict = loadDict('melee@hatchet@streamed_core')
							TaskPlayAnim(PlayerPedId(), dict, 'plyr_rear_takedown_b', 8.0, -8.0, -1, 2, 0, false, false, false)
							Wait(1000)
							Rocks[nearbyID].health = Rocks[nearbyID].health - 10
							ClearPedTasks(PlayerPedId())
							TaskTurnPedToFaceEntity(PlayerPedId(), nearbyObject, 0.5)
							Wait(1000)
							FreezeEntityPosition(PlayerPedId(), true)
							HitReward()
							if Rocks[nearbyID].health <= 0 then
								SpawnedRockes = SpawnedRockes - 1

								SetEntityAsMissionEntity(Rocks[nearbyID].object, false, true)
								DeleteObject(Rocks[nearbyID].object)
								table.remove(Rocks, nearbyID)
								break
							end
						elseif IsControlJustReleased(0, 194) then
							break
						end
					end
					ClearPedTasks(PlayerPedId())
					FreezeEntityPosition(PlayerPedId(), false)
					mining = false
					ESX.Game.DeleteObject(axe)
				end
			end


            local markerActive = true
            local isProcessing = false

            if GetDistanceBetweenCoords(coords, Config.MeltingField[1].coords, true) < 70 then
                for k,v in pairs(Config.MeltingField) do
                    if markerActive and not isProcessing then
                        DrawMarker(1, v.coords, 0.0, 0.0, 0.0, 0, 0.0, 0.0, 1.5, 1.5, 1.0, 255, 255, 0, 100, false, true, 2, false, false, false, false)
                    end

                    if GetDistanceBetweenCoords(coords, v.coords, true) < 1.5 and markerActive and not isProcessing then
                        ESX.ShowHelpNotification('~INPUT_CONTEXT~ Baraye Baz Kardan Menu E Ra Bezanid')
                        if IsControlJustReleased(0, 38) then
                            local PlayerData = ESX.GetPlayerData()
                            local irons = 0
                            local golds = 0

                            for i=1, #PlayerData.inventory do
                                if PlayerData.inventory[i].name == 'gold_piece' then
                                    golds = PlayerData.inventory[i].count
                                elseif PlayerData.inventory[i].name == 'iron_piece' then
                                    irons = PlayerData.inventory[i].count
                                end
                            end

                            local elements = {
                                {label = "Sakhte Shemshe Ahan", value = "iron"},
                                {label = "Sakhte Shemshe Tala", value = "gold"}
                            }

                            ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'melting_menu', {
                                title = "Zoob Ahan va Tala",
                                align = 'top-left',
                                elements = elements
                            }, function(data, menu)
                                menu.close()
                                if isProcessing then
                                    return
                                end
                                isProcessing = true
                                markerActive = false

                                Citizen.CreateThread(function()
                                    while isProcessing do
                                        Citizen.Wait(0)
                                        DisableControlAction(0, 38, true)
                                        DisableControlAction(0, 38, true)
                                        DisableControlAction(0, 37, true)
                                        DisableControlAction(0, 24, true)
                                        DisableControlAction(0, 25, true)
                                        DisableControlAction(0, 140, true)
                                        DisableControlAction(0, 263, true)
                                    end
                                end)

                                if (data.current.value == "iron" and irons >= 20) or (data.current.value == "gold" and golds >= 20) then
                                    TaskGoStraightToCoord(GetPlayerPed(-1), v.task.c, 1.0, 5000, 140.01, 0)
                                    Wait(100)
                                    TaskAchieveHeading(GetPlayerPed(-1), v.task.h, 1000)
                                    Wait(1000)
                                    FreezeEntityPosition(GetPlayerPed(-1), true)

                                    local dict = "random@mugging4"
                                    RequestAnimDict(dict)
                                    while not HasAnimDictLoaded(dict) do
                                        Wait(10)
                                    end
                                    TaskPlayAnim(GetPlayerPed(-1), dict, "struggle_loop_b_thief", 8.0, -8.0, -1, 2, 0, false, false, false)

                                    Wait(10000)
                                    if data.current.value == "iron" then
                                        TriggerServerEvent('mining:MeltItems', 'iron_piece', 20)
                                        TriggerEvent('TaskSystem:SakhteShemshAhan')
                                        ESX.ShowNotification("Shoma 20x Khorde Ahan Zoob Kardid va 1x Ahan Daryaft Kardid!")
                                    elseif data.current.value == "gold" then
                                        TriggerServerEvent('mining:MeltItems', 'gold_piece', 20)
                                        TriggerEvent('TaskSystem:SakhteShemshTala')
                                        ESX.ShowNotification("Shoma 20x Khorde Tala Zoob Kardid va 1x Tala Daryaft Kardid!")
                                    end

                                    FreezeEntityPosition(GetPlayerPed(-1), false)
                                    ClearPedTasksImmediately(GetPlayerPed(-1))
                                    Wait(1000)
                                    markerActive = true
                                    isProcessing = false
                                else
                                    ESX.ShowNotification("Shoma Be Tedade Kafi Az In Item Nadarid!")
                                    markerActive = true
                                    isProcessing = false
                                end
                            end, function(data, menu)
                                menu.close()
                            end)
                        end
                    end
                end
            end



			if GetDistanceBetweenCoords(coords, Config.SSell.coords, true) < 15 then
				DrawMarker(1, Config.SSell.coords, 0.0, 0.0, 0.0, 0, 0.0, 0.0, 3.0, 3.0, 2.0, 255, 255, 0, 100, false, true, 2, false, false, false, false)

				if GetDistanceBetweenCoords(coords, Config.SSell.coords, true) < 3 then
					local vehicle = GetVehiclePedIsIn(GetPlayerPed(-1), false)
					if DoesEntityExist(vehicle) then
						ESX.ShowHelpNotification('~INPUT_CONTEXT~ Menu Forosh ')
						if IsControlJustReleased(0, 38) then
							local plate = ESX.Math.Trim(GetVehicleNumberPlateText(vehicle))
							TriggerServerEvent('mining:SellStone', plate)
						end
					end
				end
			end


            if GetDistanceBetweenCoords(coords, Config.DGSell.coords, true) < 70 then
				DrawMarker(1, Config.DGSell.coords, 0.0, 0.0, 0.0, 0, 0.0, 0.0, 1.5, 1.5, 1.0, 255, 255, 0, 100, false, true, 2, false, false, false, false)
				if GetDistanceBetweenCoords(coords, Config.DGSell.coords, true) < 1.5 then
					ESX.ShowHelpNotification('~INPUT_CONTEXT~ Menu Forosh ')
					if IsControlJustReleased(0, 38) then
						OpenShop({'gold','diamond'})
					end
				end
			end
			if GetDistanceBetweenCoords(coords, Config.WashField[1].coords, true) < 70 then
                    for k,v in pairs(Config.WashField) do
                        DrawMarker(1, v.coords, 0.0, 0.0, 0.0, 0, 0.0, 0.0, 3.0, 3.0, 1.0, 255, 255, 0, 100, false, true, 2, false, false, false, false)
                        if GetDistanceBetweenCoords(coords, v.coords, true) < 3.0 then
                            local vehicle = GetVehiclePedIsIn(GetPlayerPed(-1), false)
                            local kamy = GetHashKey('rubble')
                            local isVehicleKamy = IsVehicleModel(vehicle, kamy)
                            if isVehicleKamy and DoesEntityExist(vehicle) then
                                ESX.ShowHelpNotification('Press ~INPUT_CONTEXT~ to start wash.')
                                if IsControlJustReleased(0, 38) then
                                    local plate = ESX.Math.Trim(GetVehicleNumberPlateText(vehicle))

                                    TriggerServerEvent('mining:WashStonePieces', plate)


                                end
                            end
                        end
                    end
				end
		else
			Wait(500)
		end
	end
end)

RegisterNetEvent('mining:WashStonePieces_cl')
AddEventHandler('mining:WashStonePieces_cl', function()
    local vehicle = GetVehiclePedIsIn(GetPlayerPed(-1), false)
    local plate = ESX.Math.Trim(GetVehicleNumberPlateText(vehicle))

    for k,v in pairs(Config.WashField) do
        if GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()), v.coords, true) < 3.0 then
            SetEntityHeading(vehicle, v.h)
            TaskLeaveVehicle(GetPlayerPed(-1), vehicle, 0)
            SetVehicleDoorsLocked(vehicle, 2)
            FreezeEntityPosition(vehicle, true)
            ESX.ShowNotification('Lotfan Chand Daqiqe Baraye Gharbale Sangha Sabr konid')

            SetTimeout(math.random(10000, 20000) , function()
                SetVehicleDoorsLocked(vehicle, 1)
                FreezeEntityPosition(vehicle, false)
                ESX.ShowNotification('Shoma Aknon mitavanid Mashine Khodeton Ro Bardarid')

            end)

        end
    end
end)

function OpenShop()
	menuOpen = true
	ESX.UI.Menu.CloseAll()
	local elements = {}
	menuOpen = true
    for k, v in pairs(ESX.GetPlayerData().inventory) do
        for c,d in ipairs(price) do
            if v.name == d.name then
                if d.price and v.count > 0 then
                    table.insert(elements, {
                        label = (v.name..' - <span style="color:green;">'..ESX.Math.GroupDigits(d.price)..'</span>'),
                        name = v.name,
                        price = d.price,

                        type = 'slider',
                        value = 1,
                        min = 1,
                        max = v.count
                    })
                end
            end
        end
	end
	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'fish_shop', {
		title    = "Kharidar Ahan Va Tala",
		align    = 'top-left',
		elements = elements
	}, function(data, menu)
        TriggerServerEvent('mining:sell', data.current.name, data.current.value, data.current.price)
		ESX.UI.Menu.CloseAll()
        OpenShop()
	end, function(data, menu)
		menu.close()
		menuOpen = false
    end, function()
    end,
    function()
        menuOpen = false
		ESX.UI.Menu.CloseAll()
    end)
end

Citizen.CreateThread(function()
    while ESX.GetPlayerData().job == nil do Wait(1) end
    while true do
        Citizen.Wait(1)
		local coords = GetEntityCoords(PlayerPedId())
		local distance = #(coords - Config.ClackLoc)
		if distance < 20 then
			DrawMarker(1, Config.ClackLoc, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.5, 1.5, 1.5, 255, 255, 255, 100, false, true, nil, false)
			if distance < 2.0 then
				TriggerEvent('esx:showHelpNotification', 'Dokme ~INPUT_CONTEXT~ jahat dastresi be ~r~Rakhtkan~s~')
				if IsControlJustReleased(1, 38) then
					OpenRakhtkanMenu()
				end
			end
		else
			Citizen.Wait(500)
		end
    end
end)

Citizen.CreateThread(function()
    while ESX.GetPlayerData().job == nil do Wait(1) end
    while true do
        Citizen.Wait(1)
        if OnDuty == true then
            if duty then
                local coords = GetEntityCoords(PlayerPedId())
                local distance = #(coords - Config.VehLoc)
                if distance < 20 then
                    DrawMarker(36, Config.VehLoc, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.8, 0.8, 0.8, 255, 255, 255, 100, true, false, nil, true)
                    if distance < 2.0 then
                        TriggerEvent('esx:showHelpNotification', 'Dokme ~INPUT_CONTEXT~ jahat dastresi be ~b~Garage~s~')
                        if IsControlJustReleased(1, 38) then
                            if not spawned then
                                OpenGarageMenu()
                            else
                                ESX.ShowNotification("Shoma ~r~Mashin ~w~Darid!")
                            end
                        end
                    end
                else
                    Citizen.Wait(2000)
                end
            else
                Citizen.Wait(2000)
            end
        else
            Citizen.Wait(2000)
        end
    end
end)

Citizen.CreateThread(function()
    while ESX.GetPlayerData().job == nil do Wait(1) end
    while true do
        Citizen.Wait(1)
        if OnDuty == true then
            if duty then
                local coords = GetEntityCoords(PlayerPedId())
                local distance = #(coords - Config.VehDelLoc)
                if distance < 20  then
                    DrawMarker(1, Config.VehDelLoc, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 2.5, 2.5, 1.0, 255, 0, 0, 100, false, true, nil, false)
                    if distance < 2.0 and IsPedInAnyVehicle(PlayerPedId(), false) then
                        TriggerEvent('esx:showHelpNotification', 'Dokme ~INPUT_CONTEXT~ jahat ~r~park kardan~s~')
                        if IsControlJustReleased(1, 38) then
                            local veh = GetVehiclePedIsIn(PlayerPedId())

							ESX.Game.DeleteVehicle(veh)
                            spawned = false
                        end
                    end
                else
                    Citizen.Wait(2000)
                end
            else
                Citizen.Wait(2000)
            end
        else
            Citizen.Wait(2000)
        end
    end
end)

function OpenRakhtkanMenu()
    ped = PlayerPedId()
    local elements = {
        {label = 'Lebas Shakhsi', value = 'citizen_wear'},
        {label = 'Lebas Kar', value = 'work_wear'}
    }
    ESX.UI.Menu.CloseAll()
    ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'rakhtkan_menu', {
        title = 'Rakhtkan',
        align = 'top-left',
        elements = elements
    }, function(data, menu)
            if data.current.value == 'citizen_wear' then
                ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin)
                    TriggerEvent('skinchanger:loadSkin', skin)
                end)
                duty = false
				OnDuty = false
                TriggerServerEvent('Miner:SetDuty', false )
				blips()

                if amir == false then
                    for _, info in pairs(Config.Blips) do
                        RemoveBlip(info.blip)
                    end
                    amir = true
                end

                menu.close()
            elseif data.current.value == 'work_wear' then
                ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin, jobSkin)
					if skin.sex == 0 then
						TriggerEvent('skinchanger:loadClothes', skin, Config.Uniforms['work_wear'].male)

                        if amir == true then
                            for _, info in pairs(Config.Blips) do
                            info.blip = AddBlipForCoord(info.x, info.y, info.z)
                            SetBlipSprite  (info.blip, 318)
                            SetBlipDisplay (info.blip, 4)
                            SetBlipScale(info.blip, 0.7)
                            SetBlipCategory(info.blip, 3)
                            SetBlipColour  (info.blip, 5)
                            SetBlipAsShortRange(info.blip, true)
                            BeginTextCommandSetBlipName("STRING")
                            AddTextComponentString(info.title)
                            EndTextCommandSetBlipName(info.blip)
                            end
                            amir = false
                        end

					else
						TriggerEvent('skinchanger:loadClothes', skin, Config.Uniforms['work_wear'].female)

                        if amir == true then
                            for _, info in pairs(Config.Blips) do
                            info.blip = AddBlipForCoord(info.x, info.y, info.z)
                            SetBlipSprite  (info.blip, 318)
                            SetBlipDisplay (info.blip, 4)
                            SetBlipScale(info.blip, 0.7)
                            SetBlipCategory(info.blip, 3)
                            SetBlipColour  (info.blip, 5)
                            SetBlipAsShortRange(info.blip, true)
                            BeginTextCommandSetBlipName("STRING")
                            AddTextComponentString(info.title)
                            EndTextCommandSetBlipName(info.blip)
                            end
                            amir = false
                        end

					end
                    TriggerServerEvent('Miner:SetDuty', true )
					duty = true
					OnDuty = true
					blips()


					menu.close()
				end)
            end
        end,
    function(data, menu)
        menu.close()
    end)
end

function OpenGarageMenu()
    local elements = {
        {label = 'Spawn Mashin', value = 'spawn_vehicle'}
    }
    ESX.UI.Menu.CloseAll()
    ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'garage_menu', {
        title = 'Garage',
        align = 'top-left',
        elements = elements
    }, function(data, menu)
            if data.current.value == 'spawn_vehicle' then
                ESX.Game.SpawnVehicle('rubble', Config.VehSpawn, 92.3, function(vehicle)
                    spawned = true
                    SetPedIntoVehicle(PlayerPedId(), vehicle, -1)
                end)
                menu.close()
            end
        end,
    function(data, menu)
        menu.close()
    end)
end

loadModel = function(model)
    while not HasModelLoaded(model) do Wait(1) RequestModel(model) end
    return model
end

loadDict = function(dict, anim)
    while not HasAnimDictLoaded(dict) do Wait(1) RequestAnimDict(dict) end
    return dict
end

helpText = function(msg)
    BeginTextCommandDisplayHelp('STRING')
    AddTextComponentSubstringPlayerName(msg)
    EndTextCommandDisplayHelp(0, false, true, -1)
end

function DrawTexet3D(x,y,z, text)
    local onScreen,_x,_y=World3dToScreen2d(x,y,z)
    local px,py,pz=table.unpack(GetGameplayCamCoords())
    SetTextScale(0.35, 0.35)
    SetTextFont(4)
    SetTextProportional(1)
    SetTextColour(255, 255, 255, 215)
    SetTextEntry("STRING")
    SetTextCentre(1)
    AddTextComponentString(text)
    DrawTexet(_x,_y)
    local factor = (string.len(text)) / 370
    DrawRecet(_x,_y+0.0125, 0.015+ factor, 0.03, 41, 11, 41, 68)
end

