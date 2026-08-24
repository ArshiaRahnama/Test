

ESX = nil
local PlayedData = nil

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent("esx:getSharedObject", function(obj) ESX = obj end)
		Citizen.Wait(0)
	end

	while ESX.GetPlayerData().job == nil do
		Wait(20)
	end

	PlayedData = ESX.GetPlayerData()

	KeysandMarker()
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(josdata)
	PlayedData.job = josdata
end)

local Blips , Animals = {} , {}
local inhunt , cd = false , false
local ZoneBlip = nil
local PriveId = 0
local IsCraft = true
local blipinfo = {
    {
        Name = 'Hunt' ,

        Coord = vector3(-567.811, 5253.099, 70.47766) ,
        Color =  46,
        Sprite =  442 ,
		Scale = 0.7 ,
		BeginText = true ,

    },
	{
        Name = 'slaughterhouse' ,

        Coord = vector3(-96.81758, 6205.78, 31.01538)  ,
        Color =  1,
        Sprite =  442 ,
		Scale = 0.6 ,
		BeginText = true ,

    },











}
local Animalsbot = {
	'a_c_deer',
	'a_c_rabbit_01',
	'a_c_hen',
 	'a_c_chickenhawk',

	'a_c_chop',
	'a_c_coyote',
	'a_c_husky',
	'a_c_mtlion',
	'a_c_pig',
}

local AnimalsbotAtack = {
	'a_c_deer',
	'a_c_chop',
	'a_c_coyote',
	'a_c_husky',
	'a_c_mtlion',
}

RegisterNetEvent('HUNT:ChekCraft')
AddEventHandler('HUNT:ChekCraft', function(Chek)
	IsCraft = Chek
end)
CreateThread(function()
    while true do
        Wait(1000)

        for k, v in pairs(Animals) do
            if DoesEntityExist(v.Animal) then
                local animalModel = GetEntityModel(v.Animal)
                local playerPed = PlayerPedId()
                local playerCoords = GetEntityCoords(playerPed)
                local animalCoords = GetEntityCoords(v.Animal)
                local distance = #(playerCoords - animalCoords)


                local attackedOrShot = distance <= 30.0 or HasEntityBeenDamagedByEntity(v.Animal, playerPed, true)

                for _, model in pairs(AnimalsbotAtack) do
                    if animalModel == GetHashKey(model) and attackedOrShot then

                        ClearEntityLastDamageEntity(v.Animal)

                        SetPedFleeAttributes(v.Animal, 0, false)
                        SetPedCombatAttributes(v.Animal, 46, true)
                        SetPedCombatAttributes(v.Animal, 5, true)
                        SetPedCombatAbility(v.Animal, 2)
                        SetPedRelationshipGroupHash(v.Animal, GetHashKey("HATES_PLAYER"))
                        SetBlockingOfNonTemporaryEvents(v.Animal, true)

                        if not IsPedInCombat(v.Animal, playerPed) then
                            TaskCombatPed(v.Animal, playerPed, 0, 16)
                        end

                        CreateThread(function()
                            while DoesEntityExist(v.Animal) and not IsPedRagdoll(playerPed) do
                                Wait(1500)
                                if #(GetEntityCoords(v.Animal) - GetEntityCoords(playerPed)) <= 2.0 and GetEntityHealth(v.Animal) ~= 0 then

                                    SetPedToRagdoll(playerPed, 5000, 5000, 0, false, false, false)

                                    Wait(3000)
                                    TaskSmartFleePed(v.Animal, playerPed, 100.0, -1, false, false)
                                    SetPedCombatAttributes(v.Animal, 46, false)
                                    SetPedRelationshipGroupHash(v.Animal, GetHashKey("NEUTRAL"))
                                    ClearPedTasks(v.Animal)
                                    SetEntityAsNoLongerNeeded(v.Animal)
                                    break
                                end
                            end
                        end)
                        break
                    end
                end
            end
        end
    end
end)

CreateThread(function()
	for k, v in pairs(blipinfo) do
	local blip = AddBlipForCoord(v.Coord)
	SetBlipSprite (blip,v.Sprite)
	SetBlipDisplay(blip, 2)
	SetBlipScale  (blip,v.Scale)
	SetBlipColour (blip,v.Color)
	SetBlipAsShortRange(blip, true)
	BeginTextCommandSetBlipName("STRING")
	AddTextComponentString(v.Name)
	EndTextCommandSetBlipName(blip)
end
end)
CreateThread(function()
	while true do
		Wait(700)
		if inhunt then
			for k,v in pairs(Animals) do
				if DoesEntityExist(v.Animal) then
					local AnimalCoords = GetEntityCoords(v.Animal)
					local PlyToAnimal = GetDistanceBetweenCoords(vector3(-624.9231, 5085.086, 131.7267), AnimalCoords, true)
					if PlyToAnimal > 250.0 then
						DeleteEntity(v.Animal)
						RemoveBlip(v.Blip)
						table.remove(Animals , k,v )
					end
					if v.Dead == false then
						if IsEntityDead(v.Animal) then
							v.Dead = true
							if GetSelectedPedWeapon(PlayerPedId()) ~= GetHashKey('WEAPON_MUSKET') then
								v.CanLoot = false
							end
						end
					end
				end
			end

			if GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()),vector3(-624.9231, 5085.086, 131.7267)  , true ) > 250.0 then
				ExitHunt()
			end
		else
			Wait(5000)
		end
	end
end)

function ShowZone()
CreateThread(function()
	local blip = AddBlipForRadius(vector3(-624.9231, 5085.086, 131.7267),250.0)
	SetBlipHighDetail(blip, true)
	SetBlipColour(blip, 73)
	SetBlipAlpha (blip, 128)
	SetBlipFade(blip, 40, 40)
	SetBlipAsShortRange(blip, true)
	ZoneBlip = blip
end)
AddEventHandler('onKeyDown',function(key)
	if key == 'e' then
		if GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()),vector3(-624.9231, 5085.086, 131.7267)  , true ) <= 250.0 then
			if not cd  then
				ESX.TriggerServerCallback('HUNT:GetInventoryKnife', function(hasweapon)
					for k,v in pairs(Animals) do
						if DoesEntityExist(v.Animal) then
							local AnimalCoords = GetEntityCoords(v.Animal)
							local PlyCoords = GetEntityCoords(PlayerPedId())
							local AnimalHealth = GetEntityHealth(v.Animal)
							local PlyToAnimal = GetDistanceBetweenCoords(PlyCoords, AnimalCoords, true)

							if PlyToAnimal < 2.0 then
								if AnimalHealth <= 0 then
									if v.CanLoot  then

										if hasweapon then
											RemoveBlip(v.Blip)
											PickUP(v.Animal, v.Name)
											table.remove( Animals , k,v )


											break
										else
											lib.notify({ position = 'center-right', title = '', description = 'شما چاقو ندارید!', type = 'error', duration = 3000 })
										end

									else
										RemoveBlip(v.Blip)
										DeleteEntity(v.Animal)
										table.remove( Animals , k,v )

										lib.notify({ position = 'center-right', title = '', description = 'این حیوان با اسلحه شکار کشته نشده و گوشت آن قابل استفاده نیست!', type = 'error', duration = 3000 })
									end
								end
							end
						end
					end
				end)
			end
		end
	end
end)
end

function PickUP(Animal,Name )
	if DoesEntityExist(Animal) then
		SetCurrentPedWeapon(PlayerPedId(), GetHashKey('WEAPON_KNIFE'), true)
		Wait(50)
		SetEntityCoords(PlayerPedId() , GetEntityCoords(Animal))
		TaskPlayAnim(PlayerPedId(), "amb@medic@standing@kneel@base" ,"base" ,8.0, -8.0, -1, 1, 0, false, false, false )
    	TaskPlayAnim(PlayerPedId(), "anim@gangops@facility@servers@bodysearch@" ,"player_search" ,8.0, -8.0, -1, 48, 0, false, false, false )
		TriggerEvent("mythic_progbar:client:progress", {name = "Hunt",duration = 10000,label = 'Dar Hal Loot Kardan ',useWhileDead = true,canCancel = false,controlDisables = {disableMovement = true,disableCarMovement = true,disableMouse = false,disableCombat = true,}})
		SetTimeout(10000,function()
			ClearPedTasksImmediately(PlayerPedId())
			TriggerServerEvent('Hunt:killed', Name)
			DeleteEntity(Animal)
			cd  = false
			Wait(1000)
			SetCurrentPedWeapon(PlayerPedId(), GetHashKey('WEAPON_MUSKET'), true)
		end)
	end
end

function RemoveBlips()
	CreateThread(function()
    RemoveBlip(ZoneBlip)
end)

end
function starthunt()
	ESX.TriggerServerCallback('HUNT:GetInventoryKnife&Musket', function(Knife)



			if Knife then
				for k,v in pairs(Animalsbot) do
				LoadModel(v)
				end
				LoadAnimDict('amb@medic@standing@kneel@base')
				LoadAnimDict('anim@gangops@facility@servers@bodysearch@')
				inhunt = true
				ShowZone()
				createAnimal()

				GiveWeaponToPed(PlayerPedId(), "WEAPON_MUSKET", 250, false, true)
				NotVehicle(true)
			else
				lib.notify({ position = 'center-right', title = '', description = 'شما برای ان دیوتی کردن باید چاقو داشته باشید', type = 'error', duration = 3000 })
			end

	end)
end
function createAnimal()
	CreateThread(function()
		while inhunt do
			local random = math.random(1, 2)
			if not inhunt then break  end
			PriveId = PriveId + 1


			for k,v in pairs(Animalsbot) do

				local waypointCoords = vector2(-624.9231 + math.random(-180,180) , 5085.086 + math.random(-180,180))
				for height = 1, 10000 do
					local foundGround, zPos = GetGroundZFor_3dCoord(waypointCoords["x"], waypointCoords["y"], height + 0.0)
					if foundGround then
						if (#Animals) < random and inhunt then
							local Animal = CreatePed(5, GetHashKey(v), waypointCoords["x"], waypointCoords["y"], height + 0.0, 0.0, false, false)
							TaskWanderStandard(Animal, true, true)
							SetEntityAsMissionEntity(Animal, true, true)
							local AnimalBlip = AddBlipForEntity(Animal)
							SetBlipSprite (AnimalBlip,442)
							SetBlipDisplay(AnimalBlip, 2)
							SetBlipScale(AnimalBlip, 0.7)
							SetBlipColour (AnimalBlip,1)
							SetBlipAsShortRange(AnimalBlip, false)
							BeginTextCommandSetBlipName("STRING")
							AddTextComponentString('Animal')
							EndTextCommandSetBlipName(AnimalBlip)

							table.insert(Animals,{ Animal = Animal , Name = v , Blip = AnimalBlip , CanLoot = true , Dead = false   })

							break
						end
					end
					Citizen.Wait(3)
				end
				Wait(math.random(50, 120) * 1000)
				if not inhunt then break  end
			end

		Wait(5000)
		if not inhunt then break  end
		end
	end)
end
function ExitHunt()
	inhunt = false
	RemoveWeaponFromPed(PlayerPedId(), GetHashKey("WEAPON_MUSKET"))
	for k,v in pairs(Animals) do
	   if DoesEntityExist(v.Animal) then
			DeleteEntity(v.Animal)
			DeletePed(v.Animal)
	   end
	   RemoveBlip(v.Blip)
	end
	Animals = {}
	RemoveBlips()
	NotVehicle(false)
end

local Coldown = 0
function  KeysandMarker()
	AddEventHandler('onKeyDown',function(key)
		if key == 'e' then
			if GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()),vector3(-567.811, 5253.099, 70.47766)  , true ) <= 2.0 then
				if Coldown >= GetGameTimer() then return end
				OpenHuntMenu()
				Coldown = GetGameTimer() + 3000
			elseif GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()),vector3(-96.81758, 6205.78, 31.01538)  , true ) <= 2.0 then
				if IsCraft then
					OpenSeMenu()
				end


			 end
		end
	end)
	CreateThread(function()
		while true do
			Wait(5)
			local Sleep = true
			if GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()),vector3(-567.811, 5253.099, 70.47766)  , true ) <= 15.0 then
				Sleep = false
				DrawMarker(31, vector3(-567.811, 5253.099, 70.47766), 0, 0, 0, 0, 0, 0, 0.6, 0.6, 0.6, 255, 128, 0, 100, 0, 0, 1, 1, 0, 0, 0)
			elseif  GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()),vector3(-96.81758, 6205.78, 31.01538)  , true ) <= 15.0 then
				Sleep = false
				DrawMarker(31, vector3(-96.81758, 6205.78, 31.01538), 0, 0, 0, 0, 0, 0, 0.6, 0.6, 0.6, 255, 128, 0, 100, 0, 0, 1, 1, 0, 0, 0)



			 end
			if Sleep then Wait(2000) end
		end
	end)
end

function OpenHuntMenu()
	local elements = {}

		if inhunt then
		table.insert(elements, {label = (" End "), value = 'end'})
		table.insert(elements, {label = ("Hunt :  ✔️ "), value = nil})
	    else
		table.insert(elements, {label = (" Start "), value = 'start'})
		table.insert(elements, {label = ("Hunt :  ❌ "), value = nil})
		end


	ESX.UI.Menu.CloseAll()
	ESX.UI.Menu.Open(
	'default', GetCurrentResourceName(), 'BattelPass',
	{
		title    = "Hunter",
		align    = 'top-right',
		elements = elements
	}, function(data, menu)
		local action = data.current.value
		menu.close()
		if action == 'end' then
			ExitHunt()
		elseif  action == 'start' then
			starthunt()

	    end
	end, function(data, menu)
      menu.close()
    end)
end

function OpenSellMenu()
	local elements = {}

	table.insert(elements, {label = ("Morgh"), value = 'morgh'})
	table.insert(elements, {label = ("Khargush"), value = 'khargush'})
	table.insert(elements, {label = ("Gavazn"), value = 'Aho'})
	table.insert(elements, {label = ("Oghab"), value = 'Oghab'})


ESX.UI.Menu.CloseAll()
ESX.UI.Menu.Open(
'default', GetCurrentResourceName(), 'BattelPass',
{
	title    = "Kodam Ra Miforoshid ?",
	align    = 'top-right',
	elements = elements
}, function(data, menu)
	local action = data.current.value
	menu.close()
	TriggerServerEvent("Hunt:Sellmeat",action)
end, function(data, menu)
  menu.close()
end)

end
function OpenSeMenu()

	ESX.TriggerServerCallback('HUNT:GetInventory', function(inventorys)
		local elements = {}
		if inventorys then
			for k,v in pairs(inventorys) do

				for i=1, #Config_HUNT.ItemsLashe do
					if v.name == Config_HUNT.ItemsLashe[i] and v.count >= 1 then

						table.insert(elements, {label = v.label.." | X "..v.count, value = v.name})
					end
				end
			end
		end

		ESX.UI.Menu.CloseAll()
		ESX.UI.Menu.Open(
		'default', GetCurrentResourceName(), 'BattelPass',
		{
			title    = "Kodam Ra Zebeh Mikonid ?",
			align    = 'top-right',
			elements = elements
		}, function(data, menu)
			local action = data.current.value
			menu.close()
			TriggerServerEvent("Hunt:slaughterhouse",action)

		end, function(data, menu)
		menu.close()
		end)
	end)

end
function LoadModel(model)
    while not HasModelLoaded(model) do
          RequestModel(model)
          Citizen.Wait(10)
    end
end
function LoadAnimDict(dict)
    while (not HasAnimDictLoaded(dict)) do
        RequestAnimDict(dict)
        Citizen.Wait(10)
    end
end

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
	RemoveWeaponFromPed(PlayerPedId(), GetHashKey("WEAPON_MUSKET"))
end)

function NotVehicle(Chek)
	while Chek do
		Wait(500)
		if inhunt then
			if GetVehiclePedIsIn(PlayerPedId(), false) ~= 0 then
				TaskLeaveAnyVehicle(PlayerPedId(), 16, 0)
			end
		else
			return
		end
	end
end

ESX = nil

local holdingMega = false
local prop = nil

Citizen.CreateThread(function()
    while ESX == nil do
        TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
        Citizen.Wait(1)
    end
end)

local function DisableSubmix()
    if IsEntityPlayingAnim(PlayerPedId(), "molly@megaphone", "megaphone_clip", 3) then
        ExecuteCommand('e c')
    end
    TriggerServerEvent('megaphone:applySubmix', false)
end

local usingMegaphone = false

RegisterNetEvent('megaphone:use')
AddEventHandler('megaphone:use', function()
    if usingMegaphone then
        DisableSubmix()
        exports["pma-voice"]:clearProximityOverride()
    end
    usingMegaphone = not usingMegaphone
    CreateThread(function()
        if usingMegaphone then
            TriggerServerEvent('megaphone:applySubmix', true)
            exports["pma-voice"]:overrideProximityRange(150.0, true)
        end
        while usingMegaphone do



            Wait(100)
        end
    end)
end)

Citizen.CreateThread(function()
    DecorRegister("megafan_active", 2)
    local wasActive = false

    while true do
        Citizen.Wait(0)
        if IsControlPressed(0, 210) then
            local notified = false

            while IsControlPressed(0, 210) do
                local PlayerData = ESX.GetPlayerData()
                local JobName    = PlayerData.job.name
                local vehicleped = GetVehiclePedIsIn(PlayerPedId(), false)
                local checkveh   = tonumber(vehicleped)

                if JobName == 'police' or JobName == 'sheriff' or JobName == 'fbi' or JobName == 'mt' then
                    if checkveh ~= 0 then
                        local vehplate = GetVehicleNumberPlateText(vehicleped)
                        local platetexttest = string.sub(tostring(vehplate), 1, 2)
                        local platetexttestFBi = string.sub(tostring(vehplate), 1, 3)

                        if platetexttest == "PD" or platetexttest == "SH" or platetexttestFBi == "FBI" or platetexttest == "MT" then
                            if not wasActive then
                                DecorSetBool(PlayerPedId(), "megafan_active", true)
                                exports["pma-voice"]:overrideProximityRange(50.0, true)
                                TriggerServerEvent('megaphone:applySubmix', true)

                                lib.notify({ position = 'center-right', title = "Megaphone:", description = "Speaker Activated!", type = 'success', duration = 5000 })
                                wasActive = true
                            end
                        end
                    end
                end
                Citizen.Wait(0)
            end

            if wasActive then
                Wait(20)
                DecorSetBool(PlayerPedId(), "megafan_active", false)
                DisableSubmix()
                exports["pma-voice"]:clearProximityOverride()

                lib.notify({ position = 'center-right', title = "Megaphone:", description = "Speaker Deactivated!", type = 'error', duration = 5000 })
                wasActive = false
            end
        end
    end
end)

local function loadAnimDict(dict)
    while (not HasAnimDictLoaded(dict)) do
        RequestAnimDict(dict)
        Citizen.Wait(1)
    end
end

local function LoadPropDict(model)
    while not HasModelLoaded(GetHashKey(model)) do
        RequestModel(GetHashKey(model))
        Wait(10)
    end
end

function AddPropToPlayerAndAnim(prop1, bone, off1, off2, off3, rot1, rot2, rot3)
    loadAnimDict("amb@world_human_mobile_film_shocking@female@base")
    local Player = PlayerPedId()
    local x,y,z = table.unpack(GetEntityCoords(Player))
    if not HasModelLoaded(prop1) then
        LoadPropDict(prop1)
    end
    prop = CreateObject(GetHashKey(prop1), x, y, z+0.2,  true,  true, true)
    AttachEntityToEntity(prop, Player, GetPedBoneIndex(Player, bone), off1, off2, off3, rot1, rot2, rot3, true, true, false, true, 1, true)
    SetModelAsNoLongerNeeded(prop1)
    TaskPlayAnim(Player, "amb@world_human_mobile_film_shocking@female@base", "base", 8.0, 1.0, -1, 49, 0, 0, 0, 0)
end

RegisterNetEvent('Megaphone:UseCommand')
AddEventHandler('Megaphone:UseCommand', function()
    local ped = PlayerPedId()

    if not DecorGetBool(ped, 'megafan_active') then
        CreateThread(function()
            while DecorGetBool(ped, 'megafan_active') do
                Wait(400)
                if not IsEntityPlayingAnim(ped, "amb@world_human_mobile_film_shocking@female@base", "base", 3) then
                    DeleteEntity(prop)
                    AddPropToPlayerAndAnim("prop_megaphone_01", 28422, 0.0, 0.0, 0.0, 0.0, 0.0, 80.0)
                end
            end
        end)

        AddPropToPlayerAndAnim("prop_megaphone_01", 28422, 0.0, 0.0, 0.0, 0.0, 0.0, 80.0)
        DecorSetBool(ped, "megafan_active", true)
        exports["pma-voice"]:overrideProximityRange(50.0, true)
        TriggerServerEvent('megaphone:applySubmix', true)

        lib.notify({ position = 'center-right', title = "Megaphone:", description = "Speaker Activated!", type = 'success', duration = 5000 })
    else

        DecorSetBool(ped, "megafan_active", false)
        Wait(500)

        ClearPedTasks(ped)
        DeleteEntity(prop)
        prop = nil

        DisableSubmix()
        Wait(20)
        exports["pma-voice"]:clearProximityOverride()

        lib.notify({ position = 'center-right', title = "Megaphone:", description = "Speaker Deactivated!", type = 'error', duration = 5000 })
    end
end)

local data = {
    ['default'] = 0,
    ['freq_low'] = 0.0,
    ['freq_hi'] = 10000.0,
    ['rm_mod_freq'] = 300.0,
    ['rm_mix'] = 0.2,
    ['fudge'] = 0.0,
    ['o_freq_lo'] = 200.0,
    ['o_freq_hi'] = 5000.0,
}

local filter

CreateThread(function()
    filter = CreateAudioSubmix("Megaphone")
    SetAudioSubmixEffectRadioFx(filter, 0)
    for hash, value in pairs(data) do
        SetAudioSubmixEffectParamInt(filter, 0, hash, 1)
    end
    AddAudioSubmixOutput(filter, 0)
end)

RegisterNetEvent('megaphone:updateSubmixStatus', function(state, source)
    if state then
        MumbleSetSubmixForServerId(source, filter)
    else
        MumbleSetSubmixForServerId(source, -1)
    end
end)

do
ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

local vehicle = nil
local isDriver = false
local fTractionLossMult = nil
local isModed = false
local class = nil
local isBlacklisted = false
local serverspeed = 75.0
local limite = 13.89

local dirtSurfaces = {4, 5, 10}
local noSpeedLimitSurfaces = {7, 8, 1, 4, 181, 15, 3, 13, 68, 0}

local blackListed = {
    788045382,
    -1453280962,
    1753414259,
    2035069708,
    86520421,
    909518807,
    1221510024,
    1047274985,
    898224721,
    449889667,
    -1915558610,
    -1299229688 ,
    -888725296,
    353883353,
    1067067984,
    241076232,
    353883353,
    497572160,
    -2066403776,
    -2107990196,
    -1990430753,
    -1941254156,
    164236479,
    -1960756985,
    1543134283,
    1981688531,
    630371791,
    2071877360,
    353883353,
    -980573366,
    745926877,

}

local classMod = {
    [0] = limite,
    [1] = limite,
    [2] = limite,
    [3] = limite,
    [4] = limite,
    [5] = limite,
    [6] = limite,
    [7] = limite,
    [8] = serverspeed,
    [9] = 47.22,
    [10] = limite,
    [11] = limite,
    [12] = limite,
    [13] = 0,
    [14] = 0,
    [15] = serverspeed,
    [16] = 0,
    [17] = 0,
    [18] = limite,
    [19] = 0,
    [20] = limite,
    [21] = 0,
}

function isModelBlacklisted_Antipg(model)
    for _, blacklisted2 in ipairs(blackListed) do

        if blacklisted2 == model then
            return true
        end
    end
    return false
end

Citizen.CreateThread(function()
    while true do
        local ped = PlayerPedId()
        if IsPedInAnyVehicle(ped, false) then
            if vehicle == nil then
                vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
                if GetPedInVehicleSeat(vehicle, -1) == ped then
                    isDriver = true
                    if DecorExistOn(vehicle, 'fTractionLossMult') then
                        fTractionLossMult = DecorGetFloat(vehicle, 'fTractionLossMult')
                    else
                        fTractionLossMult = GetVehicleHandlingFloat(vehicle, 'CHandlingData', 'fTractionLossMult')
                        DecorRegister('fTractionLossMult', 1)
                        DecorSetFloat(vehicle, 'fTractionLossMult', fTractionLossMult)
                    end
                    class = GetVehicleClass(vehicle)
                    isBlacklisted = isModelBlacklisted_Antipg(GetEntityModel(vehicle))
                end
            end
        else
            if vehicle ~= nil then

                Wait(1000)
                if DoesEntityExist(vehicle) then

                    setTractionLost_Antipg(fTractionLossMult)

                end
                vehicle = nil
                isDriver = false
                fTractionLossMult = nil
                isModed = false
                class = nil
                isBlacklisted = false
            end
        end
        Citizen.Wait(100)
    end
end)

Citizen.CreateThread(function()
    while true do
        if not isBlacklisted then
            if vehicle and isDriver then
                local speed = GetEntitySpeed(vehicle)
                local surfaceType = GetVehicleWheelSurfaceMaterial(vehicle, 0)

                if isDirtOrGrassSurface_Antipg(surfaceType) then
                    if not isModed and speed >= 8.5 then
                        isModed = true
                        SetVehicleMaxSpeed(vehicle, classMod[class] or limite)
                    end
                else
                    if isModed then
                        isModed = false
                    end
                    lllimit_Antipg(vehicle, limite, speed)
                end

                if isNoSpeedLimitSurface_Antipg(surfaceType) then
                    SetVehicleMaxSpeed(vehicle, serverspeed)
                end
            end
        else

                SetVehicleMaxSpeed(vehicle, serverspeed)

        end
        Citizen.Wait(100)
    end
end)

local llmitsss = {
    69.44,
    66.67,
    63.89,
    61.11,
    58.33,
    55.56,
    52.78,
    50.00,
    47.22,
    44.44,
    41.67,
    38.89,
    36.11,
    33.33,
    30.56,
    27.78,
    25.00,
    22.22,
    19.44,
    16.67,
    13.89,
}

local speed = GetEntitySpeed(vehicle)
function lllimit_Antipg(vehicle, limite)
    for i=1, tostring(#llmitsss), 1 do

        if i <= 21 then

            if not isNoSpeedLimitSurface_Antipg(GetVehicleWheelSurfaceMaterial(vehicle, 0)) then
                if GetEntitySpeed(vehicle) >= llmitsss[1] then
                    SetVehicleMaxSpeed(vehicle, llmitsss[1])
                    Wait(100)
                end
            else
                SetVehicleMaxSpeed(vehicle, serverspeed)

            end

            if not isNoSpeedLimitSurface_Antipg(GetVehicleWheelSurfaceMaterial(vehicle, 0)) then
                if GetEntitySpeed(vehicle) >= llmitsss[2] then
                    SetVehicleMaxSpeed(vehicle, llmitsss[2])
                    Wait(100)
                end
            else
                SetVehicleMaxSpeed(vehicle, serverspeed)

            end

            if not isNoSpeedLimitSurface_Antipg(GetVehicleWheelSurfaceMaterial(vehicle, 0)) then
                if GetEntitySpeed(vehicle) >= llmitsss[3] then
                    SetVehicleMaxSpeed(vehicle, llmitsss[3])
                    Wait(100)
                end
            else
                SetVehicleMaxSpeed(vehicle, serverspeed)

            end

            if not isNoSpeedLimitSurface_Antipg(GetVehicleWheelSurfaceMaterial(vehicle, 0)) then
                if GetEntitySpeed(vehicle) >= llmitsss[4] then
                    SetVehicleMaxSpeed(vehicle, llmitsss[4])
                    Wait(100)
                end
            else
                SetVehicleMaxSpeed(vehicle, serverspeed)

            end

            if not isNoSpeedLimitSurface_Antipg(GetVehicleWheelSurfaceMaterial(vehicle, 0)) then
                if GetEntitySpeed(vehicle) >= llmitsss[5] then
                    SetVehicleMaxSpeed(vehicle, llmitsss[5])
                    Wait(100)
                end
            else
                SetVehicleMaxSpeed(vehicle, serverspeed)

            end

            if not isNoSpeedLimitSurface_Antipg(GetVehicleWheelSurfaceMaterial(vehicle, 0)) then
                if GetEntitySpeed(vehicle) >= llmitsss[6] then
                    SetVehicleMaxSpeed(vehicle, llmitsss[6])
                    Wait(100)
                end
            else
                SetVehicleMaxSpeed(vehicle, serverspeed)

            end

            if not isNoSpeedLimitSurface_Antipg(GetVehicleWheelSurfaceMaterial(vehicle, 0)) then
                if GetEntitySpeed(vehicle) >= llmitsss[7] then
                    SetVehicleMaxSpeed(vehicle, llmitsss[7])
                    Wait(100)
                end
            else
                SetVehicleMaxSpeed(vehicle, serverspeed)

            end

            if not isNoSpeedLimitSurface_Antipg(GetVehicleWheelSurfaceMaterial(vehicle, 0)) then
                if GetEntitySpeed(vehicle) >= llmitsss[8] then
                    SetVehicleMaxSpeed(vehicle, llmitsss[8])
                    Wait(100)
                end
            else
                SetVehicleMaxSpeed(vehicle, serverspeed)

            end

            if not isNoSpeedLimitSurface_Antipg(GetVehicleWheelSurfaceMaterial(vehicle, 0)) then
                if GetEntitySpeed(vehicle) >= llmitsss[9] then
                    SetVehicleMaxSpeed(vehicle, llmitsss[9])
                    Wait(100)
                end
            else
                SetVehicleMaxSpeed(vehicle, serverspeed)

            end

            if not isNoSpeedLimitSurface_Antipg(GetVehicleWheelSurfaceMaterial(vehicle, 0)) then
                if GetEntitySpeed(vehicle) >= llmitsss[10] then
                    SetVehicleMaxSpeed(vehicle, llmitsss[10])
                    Wait(100)
                end
            else
                SetVehicleMaxSpeed(vehicle, serverspeed)

            end

            if not isNoSpeedLimitSurface_Antipg(GetVehicleWheelSurfaceMaterial(vehicle, 0)) then
                if GetEntitySpeed(vehicle) >= llmitsss[11] then
                    SetVehicleMaxSpeed(vehicle, llmitsss[11])
                    Wait(100)
                end
            else
                SetVehicleMaxSpeed(vehicle, serverspeed)

            end

            if not isNoSpeedLimitSurface_Antipg(GetVehicleWheelSurfaceMaterial(vehicle, 0)) then
                if GetEntitySpeed(vehicle) >= llmitsss[12] then
                    SetVehicleMaxSpeed(vehicle, llmitsss[12])
                    Wait(100)
                end
            else
                SetVehicleMaxSpeed(vehicle, serverspeed)

            end

            if not isNoSpeedLimitSurface_Antipg(GetVehicleWheelSurfaceMaterial(vehicle, 0)) then
                if GetEntitySpeed(vehicle) >= llmitsss[13] then
                    SetVehicleMaxSpeed(vehicle, llmitsss[13])
                    Wait(100)
                end
            else
                SetVehicleMaxSpeed(vehicle, serverspeed)

            end

            if not isNoSpeedLimitSurface_Antipg(GetVehicleWheelSurfaceMaterial(vehicle, 0)) then
                if GetEntitySpeed(vehicle) >= llmitsss[14] then
                    SetVehicleMaxSpeed(vehicle, llmitsss[14])
                    Wait(100)
                end
            else
                SetVehicleMaxSpeed(vehicle, serverspeed)

            end

            if not isNoSpeedLimitSurface_Antipg(GetVehicleWheelSurfaceMaterial(vehicle, 0)) then
                if GetEntitySpeed(vehicle) >= llmitsss[15] then
                    SetVehicleMaxSpeed(vehicle, llmitsss[15])
                    Wait(100)
                end
            else
                SetVehicleMaxSpeed(vehicle, serverspeed)

            end

            if not isNoSpeedLimitSurface_Antipg(GetVehicleWheelSurfaceMaterial(vehicle, 0)) then
                if GetEntitySpeed(vehicle) >= llmitsss[16] then
                    SetVehicleMaxSpeed(vehicle, llmitsss[16])
                    Wait(100)
                end
            else
                SetVehicleMaxSpeed(vehicle, serverspeed)

            end

            if not isNoSpeedLimitSurface_Antipg(GetVehicleWheelSurfaceMaterial(vehicle, 0)) then
                if GetEntitySpeed(vehicle) >= llmitsss[17] then
                    SetVehicleMaxSpeed(vehicle, llmitsss[17])
                    Wait(100)
                end
            else
                SetVehicleMaxSpeed(vehicle, serverspeed)

            end

            if not isNoSpeedLimitSurface_Antipg(GetVehicleWheelSurfaceMaterial(vehicle, 0)) then
                if GetEntitySpeed(vehicle) >= llmitsss[18] then
                    SetVehicleMaxSpeed(vehicle, llmitsss[18])
                    Wait(100)
                end
            else
                SetVehicleMaxSpeed(vehicle, serverspeed)

            end

            if not isNoSpeedLimitSurface_Antipg(GetVehicleWheelSurfaceMaterial(vehicle, 0)) then
                if GetEntitySpeed(vehicle) >= llmitsss[19] then
                    SetVehicleMaxSpeed(vehicle, llmitsss[19])
                    Wait(100)
                end
            else
                SetVehicleMaxSpeed(vehicle, serverspeed)

            end

            if not isNoSpeedLimitSurface_Antipg(GetVehicleWheelSurfaceMaterial(vehicle, 0)) then
                if GetEntitySpeed(vehicle) >= llmitsss[20] then
                    SetVehicleMaxSpeed(vehicle, llmitsss[20])
                    Wait(100)
                end
            else
                SetVehicleMaxSpeed(vehicle, serverspeed)

            end

            if not isNoSpeedLimitSurface_Antipg(GetVehicleWheelSurfaceMaterial(vehicle, 0)) then
                if GetEntitySpeed(vehicle) >= llmitsss[21] then
                    SetVehicleMaxSpeed(vehicle, llmitsss[21])
                    Wait(100)
                    return
                end
            else
                SetVehicleMaxSpeed(vehicle, serverspeed)

            end

        end
    end
end

function isDirtOrGrassSurface_Antipg(surfaceType)
    for _, dirt in ipairs(dirtSurfaces) do
        if surfaceType == dirt then
            return true
        end
    end
    return false
end

function isNoSpeedLimitSurface_Antipg(surfaceType)
    for _, noLimit in ipairs(noSpeedLimitSurfaces) do
        if surfaceType == noLimit then
            return true
        end
    end
    return false
end

function setTractionLost_Antipg(value)
    if not isBlacklisted and vehicle and value then
        SetVehicleHandlingFloat(vehicle, 'CHandlingData', 'fTractionLossMult', value)
    end
end

 RegisterCommand('surface', function()
     local ped = PlayerPedId()
     if IsPedInAnyVehicle(ped, false) then
         local vehicle = GetVehiclePedIsIn(ped, false)
         if vehicle then

             local frontSurface = GetVehicleWheelSurfaceMaterial(vehicle, 0)
             local rearSurface = GetVehicleWheelSurfaceMaterial(vehicle, 1)


             TriggerEvent('chat:addMessage', {
                 color = {255, 0, 0},
                 multiline = true,
                 args = {"System", "Front Surface: " .. frontSurface .. ", Rear Surface: " .. rearSurface}
             })
         else
             TriggerEvent('chat:addMessage', { args = {"System", "You are not in a vehicle!"}})
         end
     else
         TriggerEvent('chat:addMessage', { args = {"System", "You are not in a vehicle!"} })
     end
end, false)

local function debugPrint(msg)
    if Config_Antipg.Debug then
        print("[EngineSystem-Client] " .. msg)
    end
end

local isProcessing = false

RegisterNetEvent('engine:createEngineItemClient')
AddEventHandler('engine:createEngineItemClient', function()
    createEngineItem()
end)

local function createEngineItem()
    local dropPos = Config_Antipg.Marker.Position

    ESX.Game.SpawnObject(Config_Antipg.Items.Engine.Prop, dropPos, function(object)
        SetEntityAsMissionEntity(object, true, true)
        PlaceObjectOnGroundProperly(object)
        FreezeEntityPosition(object, true)

        exports.ox_target:addLocalEntity(object, {
            {
                label = 'برداشتن انجین',
                icon = 'fas fa-tools',
                onSelect = function()
                    if DoesEntityExist(object) then
                        DeleteEntity(object)
                        TriggerServerEvent('engine:giveEngineItemToPlayer')
                        lib.notify({ position = 'center-right', title = '', description = 'شما انجین را برداشتید!', type = 'success', duration = 3000 })
                    end
                end
            }
        })

        SetTimeout(600000, function()
            if DoesEntityExist(object) then
                DeleteEntity(object)
            end
        end)
    end)
end

local function showEngineInstallMenu(vehicle, plate)
    local options = {
        {
            title = "Repair Vehicle ($15,000)",
            description = "Tamir kardan mashin",
            event = "engine:tryRepairVehicle",
            args = { vehicle = vehicle }
        }
    }

    ESX.TriggerServerCallback('engine:checkVehicleOwnership', function(isOwned)
        if not isOwned then
            lib.registerContext({
                id = 'engine_install_menu',
                title = 'Vehicle Options',
                options = options
            })
            lib.showContext('engine_install_menu')
            return
        end

        ESX.TriggerServerCallback('engine:checkEngineStatus', function(hasEngine)
            if not hasEngine then
                table.insert(options, 1, {
                    title = "Install Engine ($100,000 - $500,000)",
                    description = "Nasb engine baraye mashin",
                    event = "engine:tryInstallEngine",
                    args = { plate = plate }
                })
            end

            lib.registerContext({
                id = 'engine_install_menu',
                title = 'Vehicle Options',
                options = options
            })
            lib.showContext('engine_install_menu')
        end, plate)
    end, plate)
end

RegisterNetEvent('engine:tryRepairVehicle')
AddEventHandler('engine:tryRepairVehicle', function(data)
    ESX.TriggerServerCallback('engine:checkMoney', function(hasMoney)
        if not hasMoney then
            lib.notify({ position = 'center-right', title = '', description = 'شما پول کافی ندارید ($15,000)!', type = 'error', duration = 3000 })
            return
        end

        if lib.progressCircle({
            duration = 8000,
            position = 'bottom',
            useWhileDead = false,
            canCancel = true,
            disable = { car = true },
            anim = {
                dict = 'mini@repair',
                clip = ''
            },
        }) then
            TriggerServerEvent('engine:payForRepair')
            TriggerEvent("esx_mechanicjob:Repaire")
            SetVehicleFixed(vehicle)
            SetVehicleDeformationFixed(vehicle)
            SetVehicleUndriveable(vehicle, false)
            SetVehicleEngineOn(vehicle, true, true)
            lib.notify({ position = 'center-right', title = '', description = 'ماشین با موفقیت تعمیر شد!', type = 'success', duration = 3000 })
        else
            lib.notify({ position = 'center-right', title = '', description = 'تعمیر ماشین لغو شد!', type = 'error', duration = 3000 })
        end
    end, 15000)
end)

RegisterNetEvent('engine:tryInstallEngine')
AddEventHandler('engine:tryInstallEngine', function(data)
    local plate = data.plate
    local playerPed = PlayerPedId()

    if not IsPedInAnyVehicle(playerPed, false) then
        lib.notify({ position = 'center-right', title = '', description = 'شما باید سوار ماشین باشید!', type = 'error', duration = 3000 })
        return
    end

    ESX.TriggerServerCallback('engine:checkEngineItem', function(hasEngineItem, tier, price)
        if not hasEngineItem then
            lib.notify({ position = 'center-right', title = '', description = 'شما انجین ندارید!', type = 'error', duration = 3000 })
            return
        end

        ESX.TriggerServerCallback('engine:checkMoney', function(hasMoney)
            if not hasMoney then
                lib.notify({ position = 'center-right', title = '', description = 'شما پول کافی ندارید ($' .. price .. ')!', type = 'error', duration = 3000 })
                return
            end

            ESX.TriggerServerCallback('engine:checkEngineStatus', function(hasEngine)
                if lib.progressCircle({
                    duration = 8000,
                    position = 'bottom',
                    useWhileDead = false,
                    canCancel = true,
                    disable = { car = true },
                    anim = {
                        dict = 'mini@repair',
                        clip = ''
                    },
                }) then
                    TriggerServerEvent('engine:installEngine', plate, tier)
                    TriggerServerEvent('engine:payForEngine', tier)

                    local vehicle = GetVehiclePedIsIn(playerPed, false)
                    if DoesEntityExist(vehicle) then
                        SetEntityMaxSpeed(vehicle, GetVehicleModelMaxSpeed(GetEntityModel(vehicle)))
                    end

                    lib.notify({ position = 'center-right', title = '', description = 'انجین با موفقیت نصب شد!', type = 'success', duration = 3000 })
                else
                    lib.notify({ position = 'center-right', title = '', description = 'نصب انجین لغو شد!', type = 'error', duration = 3000 })
                end
            end, plate)
        end, tier)
    end)
end)

local isProcessing = false

CreateThread(function()
    while true do
        local playerPed = PlayerPedId()
        local playerCoords = GetEntityCoords(playerPed)







        local nearChopShop = Config_Antipg.ChopShopEnabled
            and (#(playerCoords - Config_Antipg.Marker.Position) < 20)
        local nearInstall = #(playerCoords - Config_Antipg.InstallLocation) < 20

        if nearChopShop or nearInstall then
            Wait(0)
        else
            Wait(500)
            goto continue_pack_loop
        end


        if Config_Antipg.ChopShopEnabled then
        local chopShopDistance = #(playerCoords - Config_Antipg.Marker.Position)
        if chopShopDistance < 20 then
            DrawMarker(
                36,
                Config_Antipg.Marker.Position.x, Config_Antipg.Marker.Position.y, Config_Antipg.Marker.Position.z,
                0.0, 0.0, 0.0,
                0.0, 0.0, 0.0,
                1.0, 1.0, 1.0,
                Config_Antipg.Marker.Color.r, Config_Antipg.Marker.Color.g, Config_Antipg.Marker.Color.b, Config_Antipg.Marker.Color.a,
                false, true, 2, nil, nil, false
            )
            DrawMarker(
                1,
                Config_Antipg.Marker.Position.x, Config_Antipg.Marker.Position.y, Config_Antipg.Marker.Position.z - 0.9,
                0.0, 0.0, 0.0,
                0.0, 0.0, 0.0,
                2.5, 2.5, 1.5,
                Config_Antipg.Marker.Color.r, Config_Antipg.Marker.Color.g, Config_Antipg.Marker.Color.b, Config_Antipg.Marker.Color.a,
                false, true, 2, nil, nil, false
            )


            if chopShopDistance < 3 and not isProcessing then
                local vehicle = GetVehiclePedIsIn(playerPed, false)

                if vehicle and vehicle ~= 0 then
                    local vehCoords = GetEntityCoords(vehicle)
                    local vehDistanceToMarker = #(vehCoords - Config_Antipg.Marker.Position)
                    local vehSpeed = GetEntitySpeed(vehicle)


                    if vehDistanceToMarker < 3.0 and vehSpeed < 0.3 then
                        ESX.ShowHelpNotification("~INPUT_CONTEXT~ برای چاپ‌شاپ زدن ماشین")

                        if IsControlJustReleased(0, 38) then
                            local plate = GetVehicleNumberPlateText(vehicle)

                            if not plate or string.len(plate) < 2 then return end

                            isProcessing = true

                            ESX.TriggerServerCallback('engine:checkVehicleOwnership', function(isOwner)
                                if isOwner then
                                    lib.notify({ position = 'center-right', title = '', description = 'شما نمی‌توانید ماشین خود یا گنگ خود را چاپ‌شاپ کنید!', type = 'error', duration = 3000 })
                                    isProcessing = false
                                    return
                                end

                                ESX.TriggerServerCallback('engine:checkEngineStatus', function(hasEngine)
                                    if not hasEngine then
                                        lib.notify({ position = 'center-right', title = '', description = 'این ماشین قبلاً چاپ‌شاپ شده است!', type = 'error', duration = 3000 })
                                        isProcessing = false
                                        return
                                    end

                                    local result = lib.alertDialog({
                                        header = 'تأیید چاپ‌شاپ',
                                        content = 'آیا مطمئن هستید که می‌خواهید این ماشین را چاپ‌شاپ کنید؟',
                                        centered = true,
                                        cancel = true,
                                        labels = {
                                            confirm = 'بله، ادامه بده',
                                            cancel = 'لغو'
                                        }
                                    })

                                    if result == 'confirm' then
                                        TriggerEvent('engine:startChopshopProcess', vehicle, plate)
                                    else
                                        lib.notify({ position = 'center-right', title = '', description = 'عملیات چاپ‌شاپ لغو شد.', type = 'info', duration = 3000 })
                                        isProcessing = false
                                    end

                                end, plate)
                            end, plate)
                        end
                    else
                        ESX.ShowHelpNotification("Braye ChopShop Bayad Mashin ra Roye Marker Park Konid")
                    end
                end
            end
        end
        end


        local installDistance = #(playerCoords - Config_Antipg.InstallLocation)
        if installDistance < 20 then
            DrawMarker(
                32,
                Config_Antipg.InstallLocation.x, Config_Antipg.InstallLocation.y, Config_Antipg.InstallLocation.z - 0.98,
                0.0, 0.0, 0.0,
                0.0, 0.0, 0.0,
                2.5, 2.5, 1.5,
                0, 255, 0, 100,
                false, true, 2, nil, nil, false
            )

            if installDistance < 3 then
                ESX.ShowHelpNotification("~INPUT_CONTEXT~ برای نصب یا تعمیر انجین")

                if IsControlJustReleased(0, 38) then
                    ESX.TriggerServerCallback('engine:isMechanicOnline', function(mechanicOnline)
                        if mechanicOnline then
                            lib.notify({ position = 'center-right', title = '', description = 'مکانیک در شهر است، لطفاً با مکانیک تماس بگیرید!', type = 'info', duration = 3000 })
                            return
                        end

                        if IsPedInAnyVehicle(playerPed, false) then
                            local vehicle = GetVehiclePedIsIn(playerPed, false)
                            local plate = GetVehicleNumberPlateText(vehicle)

                            if plate and string.len(plate) >= 2 then
                                showEngineInstallMenu(vehicle, plate)
                            end
                        else
                            lib.notify({ position = 'center-right', title = '', description = 'شما باید سوار ماشین باشید!', type = 'error', duration = 3000 })
                        end
                    end)
                end
            end
        end

        ::continue_pack_loop::
    end
end)

RegisterNetEvent('engine:startChopshopProcess', function(vehicle, plate)
    local playerPed = PlayerPedId()

    TaskLeaveVehicle(playerPed, vehicle, 0)
    FreezeEntityPosition(vehicle, true)
    SetVehicleDoorsLocked(vehicle, 4)
    SetVehicleDoorsLockedForAllPlayers(vehicle, true)
    SetEntityInvincible(vehicle, true)
    SetVehicleBodyHealth(vehicle, -10000.0)
    SetVehiclePetrolTankHealth(vehicle, -10000.0)
    SetDisableVehiclePetrolTankDamage(vehicle, true)
    SetDisableVehiclePetrolTankFires(vehicle, true)

    local timer = 50
    local vehCoords = GetEntityCoords(vehicle)


    local ChekSkills = 0
    if GetResourceState('Unique_Skills') == 'started' then
        local ok, result = pcall(function() return exports['Unique_Skills']:CheckSkill('ChopShop') end)
        if ok then ChekSkills = result end
    end
    if ChekSkills == 100 then
        timer = math.floor(timer / 2)
    end

    CreateThread(function()
        local localTimer = timer
        while localTimer > 0 do
            Wait(1000)
            localTimer = localTimer - 1
        end

        if DoesEntityExist(vehicle) then
            SetEntityAsMissionEntity(vehicle, true, true)
            DeleteVehicle(vehicle)
            DeleteEntity(vehicle)
        end

        local coords = GetEntityCoords(playerPed)
        createEngineItem(coords)
        TriggerServerEvent('engine:removeEngine', plate)
        isProcessing = false
    end)

    CreateThread(function()
        while timer > 0 do
            Wait(0)

            local playerPed = PlayerPedId()
            local playerCoords = GetEntityCoords(playerPed)
            local distance = #(playerCoords - vehCoords)

            if distance < 20.0 then
                Draw3DText_Antipg(vehCoords.x, vehCoords.y, vehCoords.z + 1.0, "Chop Shop In: " .. timer .. "s")
            end
        end
    end)


    CreateThread(function()
        local doorsRemoved = false
        local tiresPopped = false

        while timer > 0 do
            Wait(1000)

            timer = timer - 1

            if timer == 20 and not doorsRemoved then
                for i = 0, 5 do
                    if DoesVehicleHaveDoor(vehicle, i) then

                        SetVehicleDoorBroken(vehicle, i, true)

                    end
                end

                doorsRemoved = true
            end

            if timer == 10 and not tiresPopped then
                for i = 0, 5 do
                    SetVehicleTyreBurst(vehicle, i, true, 1000.0)
                end
                tiresPopped = true
            end
        end
    end)
end)

function Draw3DText_Antipg(x, y, z, text)
    SetTextScale(0.50, 0.50)
    SetTextFont(4)
    SetTextProportional(1)
    SetTextColour(255, 255, 255, 215)
    SetTextEntry("STRING")
    SetTextCentre(true)
    AddTextComponentString(text)
    SetDrawOrigin(x, y, z, 0)
    DrawText(0.0, 0.0)
    ClearDrawOrigin()
end

if Config_Antipg.ChopShopEnabled then
CreateThread(function()
    local blip = AddBlipForCoord(Config_Antipg.Marker.Position.x, Config_Antipg.Marker.Position.y, Config_Antipg.Marker.Position.z)

    SetBlipSprite(blip, 225)
    SetBlipDisplay(blip, 4)
    SetBlipScale(blip, 0.7)
    SetBlipColour(blip, 3)
    SetBlipAsShortRange(blip, true)

    BeginTextCommandSetBlipName("STRING")
    AddTextComponentSubstringPlayerName("Chop Shop")
    EndTextCommandSetBlipName(blip)
end)
end

local currentVehicle = nil
local lastPlateChecked = ""
local lastNotifiedPlate = ""

CreateThread(function()
    while true do
        Wait(1000)
        local playerPed = PlayerPedId()

        if IsPedInAnyVehicle(playerPed, false) then
            local vehicle = GetVehiclePedIsIn(playerPed, false)
            local seat = GetPedInVehicleSeat(vehicle, -1)

            if seat == playerPed then
                local plate = GetVehicleNumberPlateText(vehicle)

                ESX.TriggerServerCallback('engine:checkEngineStatus', function(hasEngine)

                    if hasEngine == nil then
                        return
                    end

                    if hasEngine == false then
                        if plate ~= lastNotifiedPlate then
                            lib.notify({ position = 'center-right', title = '', description = 'این ماشین انجین ندارد!', type = 'error', duration = 3000 })
                            lastNotifiedPlate = plate
                        end

                        if DoesEntityExist(vehicle) then
                            SetEntityMaxSpeed(vehicle, 13.0)
                        end
                    else
                        if DoesEntityExist(vehicle) then
                            SetEntityMaxSpeed(vehicle, GetVehicleModelMaxSpeed(GetEntityModel(vehicle)))
                        end

                        lastNotifiedPlate = ""
                    end
                end, plate)

                currentVehicle = vehicle
                lastPlateChecked = plate
            end
        else
            currentVehicle = nil
            lastPlateChecked = ""
            lastNotifiedPlate = ""
        end
    end
end)end

ESX = nil
local PlayerData = {}

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end
end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
	PlayerData = xPlayer
end)

local particleDict = "scr_indep_fireworks"
local AnimationDict = "anim@mp_fireworks"

RegisterNetEvent('fireworks:box')
AddEventHandler('fireworks:box', function()
	local ply = PlayerPedId()
	local x,y,z = table.unpack(GetOffsetFromEntityInWorldCoords(ply, 0.0, 0.5, -1.02))

	RequestAnimDict('anim@mp_fireworks')
	while not HasAnimDictLoaded('anim@mp_fireworks') do
		Wait(1)
	end
	TaskPlayAnim(ply, 'anim@mp_fireworks', 'place_firework_3_box', 8.0, -1, -1, 0, 0, 0, 0, 0)

	Wait(1250)
	ClearPedSecondaryTask(ply)

	local objectName = GetHashKey("ind_prop_firework_03")
	local prop = CreateObject(objectName, x, y, z, true, false, true)
	SetEntityHeading(prop, GetEntityHeading(ply))
	PlaceObjectOnGroundProperly(prop)

	lib.notify({ position = 'center-right', title = '', description = 'فیوز روشن است، لطفاً فاصله بگیرید ~r~(9 ثانیه)', type = 'warning', duration = 3000 })

	Wait(9000)
	TriggerServerEvent("syncbad4", x, y, z)

	Wait(18000)
	DeleteObject(prop)
end)
RegisterNetEvent("syncbad_cl4")
AddEventHandler("syncbad_cl4", function(x, y, z)
    RequestNamedPtfxAsset(particleDict)
    while not HasNamedPtfxAssetLoaded(particleDict) do
        Wait(1)
	end

	UseParticleFxAssetNextCall(particleDict)
	local particle = StartNetworkedParticleFxNonLoopedAtCoord("scr_indep_firework_trailburst", x, y, z, 0.0, 0.0, 0.0, math.random() * 0.5 + 0.8, false, false, false, false)
	Wait(1500)
	UseParticleFxAssetNextCall(particleDict)
	local particle2 = StartNetworkedParticleFxNonLoopedAtCoord("scr_indep_firework_trailburst", x, y, z, 0.0, 0.0, 0.0, math.random() * 0.5 + 0.8, false, false, false, false)
	Wait(1500)
	UseParticleFxAssetNextCall(particleDict)
	local particle3 = StartNetworkedParticleFxNonLoopedAtCoord("scr_indep_firework_trailburst", x, y, z, 0.0, 0.0, 0.0, math.random() * 0.5 + 0.8, false, false, false, false)
	Wait(1500)
	UseParticleFxAssetNextCall(particleDict)
	local particle4 = StartNetworkedParticleFxNonLoopedAtCoord("scr_indep_firework_trailburst", x, y, z, 0.0, 0.0, 0.0, math.random() * 0.5 + 0.8, false, false, false, false)
	Wait(1500)
	UseParticleFxAssetNextCall(particleDict)
	local particle5 = StartNetworkedParticleFxNonLoopedAtCoord("scr_indep_firework_trailburst", x, y, z, 0.0, 0.0, 0.0, math.random() * 0.5 + 0.8, false, false, false, false)
	Wait(1500)
	UseParticleFxAssetNextCall(particleDict)
	local particle6 = StartNetworkedParticleFxNonLoopedAtCoord("scr_indep_firework_trailburst", x, y, z, 0.0, 0.0, 0.0, math.random() * 0.5 + 0.8, false, false, false, false)
	Wait(1500)
	UseParticleFxAssetNextCall(particleDict)
	local particle7 = StartNetworkedParticleFxNonLoopedAtCoord("scr_indep_firework_trailburst", x, y, z, 0.0, 0.0, 0.0, math.random() * 0.5 + 0.8, false, false, false, false)
	Wait(1500)
	UseParticleFxAssetNextCall(particleDict)
	local particle8 = StartNetworkedParticleFxNonLoopedAtCoord("scr_indep_firework_trailburst", x, y, z, 0.0, 0.0, 0.0, math.random() * 0.5 + 0.8, false, false, false, false)
	Wait(4000)
	UseParticleFxAssetNextCall(particleDict)
	local particle9 = StartNetworkedParticleFxNonLoopedAtCoord("scr_indep_firework_trailburst", x, y, z, 0.0, 0.0, 0.0, math.random() * 0.5 + 1.8, false, false, false, false)
end)

RegisterNetEvent('fireworks:cone')
AddEventHandler('fireworks:cone', function()
	local ply = PlayerPedId()
	local x,y,z = table.unpack(GetOffsetFromEntityInWorldCoords(ply, 0.0, 0.5, -1.02))

	RequestAnimDict('anim@mp_fireworks')
	while not HasAnimDictLoaded('anim@mp_fireworks') do
		Wait(1)
	end
	TaskPlayAnim(ply, 'anim@mp_fireworks', 'place_firework_4_cone', 8.0, -1, -1, 0, 0, 0, 0, 0)

	Wait(1250)
	ClearPedSecondaryTask(ply)

	local objectName = GetHashKey("ind_prop_firework_04")
	local prop = CreateObject(objectName, x, y, z, true, false, true)
	SetEntityHeading(prop, GetEntityHeading(ply))
	PlaceObjectOnGroundProperly(prop)

	lib.notify({ position = 'center-right', title = '', description = 'فیوز روشن است، لطفا فاصله بگیرید ~r~(9 ثانیه)', type = 'warning', duration = 3000 })

	Wait(9000)
	TriggerServerEvent("syncbad3", x, y, z)

	Wait(18000)
	DeleteObject(prop)
end)
RegisterNetEvent("syncbad_cl3")
AddEventHandler("syncbad_cl3", function(x, y, z)
    RequestNamedPtfxAsset(particleDict)
    while not HasNamedPtfxAssetLoaded(particleDict) do
        Wait(1)
	end

	UseParticleFxAssetNextCall(particleDict)
	local particle = StartNetworkedParticleFxNonLoopedAtCoord("scr_indep_firework_fountain", x, y, z, 0.0, 0.0, 0.0, math.random() * 0.5 + 0.8, false, false, false, false)
	Wait(1500)
	UseParticleFxAssetNextCall(particleDict)
	local particle2 = StartNetworkedParticleFxNonLoopedAtCoord("scr_indep_firework_fountain", x, y, z, 0.0, 0.0, 0.0, math.random() * 0.5 + 0.8, false, false, false, false)
	Wait(1500)
	UseParticleFxAssetNextCall(particleDict)
	local particle3 = StartNetworkedParticleFxNonLoopedAtCoord("scr_indep_firework_fountain", x, y, z, 0.0, 0.0, 0.0, math.random() * 0.5 + 0.8, false, false, false, false)
	Wait(1500)
	UseParticleFxAssetNextCall(particleDict)
	local particle4 = StartNetworkedParticleFxNonLoopedAtCoord("scr_indep_firework_fountain", x, y, z, 0.0, 0.0, 0.0, math.random() * 0.5 + 0.8, false, false, false, false)
	Wait(1500)
	UseParticleFxAssetNextCall(particleDict)
	local particle5 = StartNetworkedParticleFxNonLoopedAtCoord("scr_indep_firework_fountain", x, y, z, 0.0, 0.0, 0.0, math.random() * 0.5 + 0.8, false, false, false, false)
	Wait(2500)
	UseParticleFxAssetNextCall(particleDict)
	local particle6 = StartNetworkedParticleFxNonLoopedAtCoord("scr_indep_firework_fountain", x, y, z, 0.0, 0.0, 0.0, math.random() * 1.5 + 1.8, false, false, false, false)
end)

RegisterNetEvent('fireworks:cylinder')
AddEventHandler('fireworks:cylinder', function()
	local ply = PlayerPedId()
	local x,y,z = table.unpack(GetOffsetFromEntityInWorldCoords(ply, 0.0, 0.5, -1.02))

	RequestAnimDict('anim@mp_fireworks')
	while not HasAnimDictLoaded('anim@mp_fireworks') do
		Wait(1)
	end
	TaskPlayAnim(ply, 'anim@mp_fireworks', 'place_firework_2_cylinder', 8.0, -1, -1, 0, 0, 0, 0, 0)

	Wait(1250)
	ClearPedSecondaryTask(ply)

	local objectName = GetHashKey("ind_prop_firework_02")
	local prop = CreateObject(objectName, x, y, z, true, false, true)
	SetEntityHeading(prop, GetEntityHeading(ply))
	PlaceObjectOnGroundProperly(prop)

	lib.notify({ position = 'center-right', title = '', description = 'فیوز روشن است، لطفا فاصله بگیرید ~r~(9 ثانیه)', type = 'warning', duration = 3000 })

	Wait(9000)
	TriggerServerEvent("syncbad2", x, y, z)

	Wait(18000)
	DeleteObject(prop)
end)
RegisterNetEvent("syncbad_cl2")
AddEventHandler("syncbad_cl2", function(x, y, z)
    RequestNamedPtfxAsset(particleDict)
    while not HasNamedPtfxAssetLoaded(particleDict) do
        Wait(1)
	end

	UseParticleFxAssetNextCall(particleDict)
	local particle = StartNetworkedParticleFxNonLoopedAtCoord("scr_indep_firework_shotburst", x, y, z, 0.0, 0.0, 0.0, math.random() * 0.5 + 0.8, false, false, false, false)
	Wait(1500)
	UseParticleFxAssetNextCall(particleDict)
	local particle2 = StartNetworkedParticleFxNonLoopedAtCoord("scr_indep_firework_shotburst", x, y, z, 0.0, 0.0, 0.0, math.random() * 0.5 + 0.8, false, false, false, false)
	Wait(1500)
	UseParticleFxAssetNextCall(particleDict)
	local particle3 = StartNetworkedParticleFxNonLoopedAtCoord("scr_indep_firework_shotburst", x, y, z, 0.0, 0.0, 0.0, math.random() * 0.5 + 0.8, false, false, false, false)
	Wait(1500)
	UseParticleFxAssetNextCall(particleDict)
	local particle4 = StartNetworkedParticleFxNonLoopedAtCoord("scr_indep_firework_shotburst", x, y, z, 0.0, 0.0, 0.0, math.random() * 0.5 + 0.8, false, false, false, false)
	Wait(1500)
	UseParticleFxAssetNextCall(particleDict)
	local particle5 = StartNetworkedParticleFxNonLoopedAtCoord("scr_indep_firework_shotburst", x, y, z, 0.0, 0.0, 0.0, math.random() * 0.5 + 0.8, false, false, false, false)
	Wait(2500)
	UseParticleFxAssetNextCall(particleDict)
	local particle6 = StartNetworkedParticleFxNonLoopedAtCoord("scr_indep_firework_shotburst", x, y, z, 0.0, 0.0, 0.0, math.random() * 1.5 + 1.8, false, false, false, false)
	Wait(2500)
	UseParticleFxAssetNextCall(particleDict)
	local particle7 = StartNetworkedParticleFxNonLoopedAtCoord("scr_indep_firework_shotburst", x, y, z, 0.0, 0.0, 0.0, math.random() * 1.5 + 1.8, false, false, false, false)
	Wait(2500)
	UseParticleFxAssetNextCall(particleDict)
	local particle8 = StartNetworkedParticleFxNonLoopedAtCoord("scr_indep_firework_shotburst", x, y, z, 0.0, 0.0, 0.0, math.random() * 1.5 + 1.8, false, false, false, false)
end)

RegisterNetEvent('fireworks:rocket')
AddEventHandler('fireworks:rocket', function()
	local ply = PlayerPedId()
	local x,y,z = table.unpack(GetOffsetFromEntityInWorldCoords(ply, 0.0, 0.5, -1.02))

	RequestAnimDict('anim@mp_fireworks')
	while not HasAnimDictLoaded('anim@mp_fireworks') do
		Wait(1)
	end
	TaskPlayAnim(ply, 'anim@mp_fireworks', 'place_firework_1_rocket', 8.0, -1, -1, 0, 0, 0, 0, 0)

	Wait(1250)
	ClearPedSecondaryTask(ply)

	local objectName = GetHashKey("ind_prop_firework_01")
	local prop = CreateObject(objectName, x, y, z, true, false, true)
	SetEntityHeading(prop, GetEntityHeading(ply))
	PlaceObjectOnGroundProperly(prop)

	lib.notify({ position = 'center-right', title = '', description = 'فیوز روشن است، لطفا فاصله بگیرید ~r~(9 ثانیه)', type = 'warning', duration = 3000 })

	Wait(9000)
	TriggerServerEvent("syncbad1", x, y, z)

	local veh = GetClosestVehicle(x,y,z, 100.0, 0, 70)
	SetVehicleAlarm(veh, true)
	SetVehicleAlarmTimeLeft(veh, 8000)

	Wait(8500)
	DeleteObject(prop)
end)
RegisterNetEvent("syncbad_cl1")
AddEventHandler("syncbad_cl1", function(x, y, z)
    RequestNamedPtfxAsset(particleDict)
    while not HasNamedPtfxAssetLoaded(particleDict) do
        Wait(1)
    end
    UseParticleFxAssetNextCall(particleDict)
    StartParticleFxNonLoopedAtCoord("scr_indep_firework_starburst", x, y, z, 0.0, 0.0, 0.0, 2.5, false, false, false, false)
end)

ESX = nil

CreateThread(function()
	while ESX == nil do
		TriggerEvent("esx:getSharedObject", function(obj) ESX = obj end)
	Wait(0)
	end
end)

local FightBan = false
function SetFightBan()
	CreateThread(function()
		while true do
			SetCurrentPedWeapon(PlayerPedId()  , GetHashKey("WEAPON_UNARMED"), true)
			Wait(5)
		end
	end)
end

RegisterNetEvent('Unique_Scripts_FightBan:Notif')
AddEventHandler('Unique_Scripts_FightBan:Notif', function(FightBan,time)
	FightBan = FightBan
	if FightBan == true then
		SetFightBan()
	else
		lib.notify({ position = 'center-right', title = '', description = 'شما از فایت‌بن حذف شدید', type = 'success', duration = 3000 })
	end
end)

ESX = nil

Citizen.CreateThread(function()
    while ESX == nil do
        TriggerEvent("esx:getSharedObject",function(obj)
            ESX = obj
        end)
      Citizen.Wait(0)
    end
end)

local blipss = true
local blips = {
    {title="Gang House", colour=3, id=439, x = -610.041, y = -1607.78, z = 26.218},
    {title="Gang House", colour=3, id=439, x = -1344.26, y = 60.38825, z = 54.718},
    {title="Gang House", colour=3, id=439, x = -1549.16, y = -90.6019, z = 54.929},
    {title="Gang House", colour=3, id=439, x = -1579.89, y = -37.1502, z = 57.565},
    {title="Gang House", colour=3, id=439, x = -1465.53, y = -28.9578, z = 60.655},
    {title="Gang House", colour=3, id=439, x = -1474.91, y = 31.36794, z = 54.738},
    {title="Gang House", colour=3, id=439, x = -1525.07, y = 25.73238, z = 56.820},
    {title="Gang House", colour=3, id=439, x = -1573.88, y = 23.92082, z = 59.553},
    {title="Gang House", colour=3, id=439, x = -1629.99, y = 36.38449, z = 62.936},
    {title="Gang House", colour=3, id=439, x = -114.968, y = 985.1345, z = 235.75},
    {title="Gang House", colour=3, id=439, x = -137.434, y = 901.5281, z = 235.65},
    {title="Gang House", colour=3, id=439, x = -88.9001, y = 834.8658, z = 235.72},
    {title="Gang House", colour=3, id=439, x = -1523.55, y = 93.98070, z = 56.581},
    {title="Gang House", colour=3, id=439, x = -1896.65, y = 133.8671, z = 81.341},
    {title="Gang House", colour=3, id=439, x = -1934.81, y = 171.9342, z = 84.128},
    {title="Gang House", colour=3, id=439, x = -1957.24, y = 211.6411, z = 85.861},
    {title="Gang House", colour=3, id=439, x = -1994.85, y = 299.6876, z = 91.430},
    {title="Gang House", colour=3, id=439, x = -2006.47, y = 367.0712, z = 94.109},
    {title="Gang House", colour=3, id=439, x = -2013.51, y = 499.0139, z = 106.64},
    {title="Gang House", colour=3, id=439, x = -1902.53, y = 244.1328, z = 85.727},
    {title="Gang House", colour=3, id=439, x = -1925.26, y = 293.7859, z = 88.549},
    {title="Gang House", colour=3, id=439, x = -1932.95, y = 361.8100, z = 93.322},
    {title="Gang House", colour=3, id=439, x = -1923.93, y = 404.8488, z = 95.768},
    {title="Gang House", colour=3, id=439, x = -1946.07, y = 448.8351, z = 101.88},
    {title="Gang House", colour=3, id=439, x = -1805.82, y = 443.0056, z = 127.98},
    {title="Gang House", colour=3, id=439, x = -1744.79, y = 360.0841, z = 88.208},
    {title="Gang House", colour=3, id=439, x = -1994.38, y = 590.4156, z = 117.38},
    {title="Gang House", colour=3, id=439, x = -1516.13, y = 857.3681, z = 181.32},
    {title="Gang House", colour=3, id=439, x = 1389.557, y = 1141.670, z = 113.84},
    {title="Gang House", colour=3, id=439, x = 956.9511, y = -2111.02, z = 30.027},
    {title="Gang House", colour=3, id=439, x = -887.667, y = 364.9273, z = 84.503},
    {title="Gang House", colour=3, id=439, x = -872.152, y = 303.6246, z = 83.445},
    {title="Gang House", colour=3, id=439, x = -819.085, y = 175.1279, z = 71.082},
    {title="Gang House", colour=3, id=439, x = -833.915, y = 110.2987, z = 54.484},
    {title="Gang House", colour=3, id=439, x = -915.374, y = 108.5353, z = 54.872},
    {title="Gang House", colour=3, id=439, x = -969.440, y = 122.6983, z = 56.370},
    {title="Gang House", colour=3, id=439, x = -949.739, y = 195.4086, z = 66.863},
    {title="Gang House", colour=3, id=439, x = -907.443, y = 184.7529, z = 68.900},
    {title="Gang House", colour=3, id=439, x = -1038.83, y = 222.0313, z = 63.861},
    {title="Gang House", colour=3, id=439, x = -930.312, y = 17.27251, z = 47.315},
    {title="Gang House", colour=3, id=439, x = -887.050, y = 42.26352, z = 48.391},
    {title="Gang House", colour=3, id=439, x = -896.073, y = -4.25307, z = 43.274},
    {title="Gang House", colour=3, id=439, x = -841.242, y = -25.0033, z = 39.878},
    {title="Gang House", colour=3, id=439, x = -1025.51, y = 359.9050, z = 70.834},
    {title="Gang House", colour=3, id=439, x = -1037.99, y = 313.1803, z = 66.632},
    {title="Gang House", colour=3, id=439, x = -1135.18, y = 376.0628, z = 70.772},
    {title="Gang House", colour=3, id=439, x = -1187.95, y = 289.6623, z = 68.972},
    {title="Gang House", colour=3, id=439, x = -1116.89, y = 302.0663, z = 65.878},
    {title="Gang House", colour=3, id=439, x = 983.5957, y = -106.560, z = 73.824},
    {title="Gang House", colour=3, id=439, x = -1888.38, y = 2050.208, z = 140.46},
    {title="Gang House", colour=3, id=439, x = -1272.64, y = 498.6752, z = 96.854},
    {title="Gang House", colour=3, id=439, x = -1375.20, y = 445.9198, z = 105.15},
    {title="Gang House", colour=3, id=439, x = -1351.89, y = 487.0406, z = 103.36},
    {title="Gang House", colour=3, id=439, x = -705.905, y = 655.8836, z = 154.65},
    {title="Gang House", colour=3, id=439, x = 226.3785, y = 767.1604, z = 204.18},
    {title="Gang House", colour=3, id=439, x = 1991.558, y = 3055.350, z = 47.214},
    {title="Gang House", colour=3, id=439, x = 134.8656, y = -2191.30, z = 6.0115},
    {title="Gang House", colour=3, id=439, x = -2586.91, y = 1911.900, z = 167.49},
    {title="Gang House", colour=3, id=439, x = -3070.14, y = 1555.822, z = 37.279},
    {title="Gang House", colour=3, id=439, x = 1228.260, y = -404.884, z = 68.861},
    {title="Gang House", colour=3, id=439, x = 1005.621, y = -2520.35, z = 28.305},
    {title="Gang House", colour=3, id=439, x = -76.3443, y = 6497.659, z = 31.490},
    {title="Gang House", colour=3, id=439, x = -1495.35, y = -199.028, z = 50.398},
    {title="Gang House", colour=3, id=439, x = -2185.69, y = -388.846, z = 13.351},
    {title="Gang House", colour=3, id=439, x = -2196.86, y = 4256.846, z = 47.967},
    {title="Gang House", colour=3, id=439, x = 1957.215, y = 3840.905, z = 32.020},
    {title="Gang House", colour=3, id=439, x = -1173.58, y = -1178.06, z = 5.6234},
    {title="Gang House", colour=3, id=439, x = -420.471, y = 271.1380, z = 82.996},
}

RegisterCommand('gangs', function()
    blipp(blipss)
end)

function blipp(blipss2)
    if blipss2 == true then
        for k,v in pairs(blips) do
            v.blip = AddBlipForCoord(v.x, v.y, v.z)
            SetBlipSprite(v.blip, v.id)
            SetBlipDisplay(v.blip, 4)
            SetBlipScale(v.blip, 0.7)
            SetBlipColour(v.blip, v.colour)
            SetBlipAsShortRange(v.blip, true)
            BeginTextCommandSetBlipName("STRING")
            AddTextComponentString(v.title)
            EndTextCommandSetBlipName(v.blip)

        end
        blipss = false
    else
        for k,v in pairs(blips) do
            RemoveBlip(v.blip)
        end
        blipss = true
    end
end

ESX = nil

Citizen.CreateThread(function()
    while ESX == nil do
        TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
        Citizen.Wait(0)
    end
end)

RegisterNetEvent('ArSa:showJobMenu')
AddEventHandler('ArSa:showJobMenu', function(jobs)
    local elements = {}
    for jobName, jobList in pairs(jobs) do
        if #jobList > 0 then
            table.insert(elements, {label = '--- ' .. jobName .. ' ---', value = nil})

            for _, player in ipairs(jobList) do
                table.insert(elements, {label = player.name .. ' ['..player.id..'] | Grade : ' .. player.grade, value = player.id})
            end

        end
    end

    ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'job_list_menu', {
        title    = 'Job List',
        align    = 'top-left',
        elements = elements
    }, function(data, menu)
        if data.current.value then
            menu.close()
            TriggerServerEvent("ArSa:GoToSp",tonumber(data.current.value))
        end
    end, function(data, menu)
        menu.close()
    end)
end)

TriggerEvent('chat:addSuggestion', '/rsrecord', 'Recording options', {
    { name = "type", help = "start/stop/discard" }
})

RegisterCommand('rsrecord', function(source, args, rawCommand)
	local type = args[1]
	if type == 'start' then StartRecording(1) end
	if type == 'stop' then StopRecordingAndSaveClip() end
	if type == 'discard' then StopRecordingAndDiscardClip() end
end)

Citizen.CreateThread(function()
    while ESX == nil do
        TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
        Citizen.Wait(0)
    end
end)

function OpenPedShop()
    ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin, t)
        local elements = {}
        local playerPed = PlayerPedId()
        local availablePeds = {}

        if skin.sex == 0 then
            availablePeds = Config_PedShop.AvailablePedsMale
        else
            availablePeds = Config_PedShop.AvailablePedsFemale
        end

        for _, ped in ipairs(availablePeds) do
            table.insert(elements, {label = ped.label .. " (Expire: " .. ped.expire .. " Day) - Price: " .. ped.price .. " $", value = ped.model})
        end

        ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'ped_shop', {
            title = "PED Shop",
            align = "top-left",
            elements = elements
        }, function(data, menu)
            TriggerServerEvent('pedshop:buyPed', data.current.value)
            menu.close()
        end, function(data, menu)
            menu.close()
        end)
    end)
end

function OpenChangePedMenu()
    TriggerServerEvent('pedshop:getOwnedPeds', GetPlayerServerId(PlayerId()))
end

RegisterNetEvent('pedshop:showOwnedPeds')
AddEventHandler('pedshop:showOwnedPeds', function(peds)
    local elements = {}

    table.insert(elements, {label = "Reset Ped", value = "resetped"})


    for _, ped in ipairs(peds) do
        table.insert(elements, {label = ped.model, value = ped.model})
    end

    ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'change_ped', {
        title = "PED Menu",
        align = "top-left",
        elements = elements
    }, function(data, menu)
        if data.current.value == "resetped" then
            TriggerEvent("resetpedHandler")
        else
            TriggerEvent('pedshop:applyPed', data.current.value)
        end
        menu.close()
    end, function(data, menu)
        menu.close()
    end)
end)

RegisterNetEvent('pedshop:applyPed')
AddEventHandler('pedshop:applyPed', function(pedModel)
    local playerPed = PlayerPedId()
    RequestModel(pedModel)

    while not HasModelLoaded(pedModel) do
        Citizen.Wait(100)
    end

    SetPlayerModel(PlayerId(), pedModel)
    SetModelAsNoLongerNeeded(pedModel)
end)

Citizen.CreateThread(function()
    while true do
        local sleep = 1000
        local playerCoords = GetEntityCoords(PlayerPedId())

        for name, location in pairs(Config_PedShop.Locations) do
            local distance = #(playerCoords - location)

            if distance < 10.0 then
                sleep = 0
                DrawMarker(1, location.x, location.y, location.z - 1.0, 0, 0, 0, 0, 0, 0, 1.5, 1.5, 1.0, 0, 255, 0, 100, false, false, 2, false, nil, nil, false)

                if distance < 1.5 then
                    if name == "PedShop" then
                        ESX.ShowHelpNotification("~INPUT_CONTEXT~ Braye Baz Kardane Menu Ped Shop")
                        if IsControlJustReleased(0, 38) then
                            OpenPedShop()
                        end
                    elseif name == "PedChange" then
                        ESX.ShowHelpNotification("~INPUT_CONTEXT~ Menu PED")
                        if IsControlJustReleased(0, 38) then
                            OpenChangePedMenu()
                        end
                    end
                end
            end
        end

        Citizen.Wait(sleep)
    end
end)

local doctorCoordsList = {
    {x = 318.5803, y = -587.662, z = 42.284, h = 156.17},
    {x = -246.573, y = 6314.123, z = 31.427, h = 44.77},
}
local healCost = 15000
local isHealing = false
local ped = {}

Citizen.CreateThread(function()
    while ESX == nil do
        TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
        Citizen.Wait(0)
    end
end)

function ShowInfo(text, state)
    SetTextComponentFormat("STRING")
    AddTextComponentString(text)
    DisplayHelpTextFromStringLabel(0, state, 0, -1)
end

function DrawBlackScreen(duration)
    local startTime = GetGameTimer()
    while GetGameTimer() - startTime < duration do
        Citizen.Wait(0)

        DrawRect(0.5, 0.5, 1.0, 1.0, 0, 0, 0, 255)
    end
end

Citizen.CreateThread(function()
    local hash = GetHashKey("s_m_m_doctor_01")
    while not HasModelLoaded(hash) do
        RequestModel(hash)
        Wait(100)
    end


    for _, coords in ipairs(doctorCoordsList) do
        local pedInstance = CreatePed("PED_TYPE_CIVFEMALE", hash, coords.x, coords.y, coords.z, coords.h, false, true)
        SetBlockingOfNonTemporaryEvents(pedInstance, true)
        FreezeEntityPosition(pedInstance, true)
        SetEntityInvincible(pedInstance, true)


        table.insert(ped, pedInstance)


        exports['ox_target']:addLocalEntity(pedInstance, {
            {
                name = "revive_player",
                icon = "fas fa-user-md",
                label = "درمان",
                onSelect = function()
                    local playerPed = GetPlayerPed(-1)
                    local isPlayerDown = GetEntityHealth(playerPed) <= 100 and GetEntityHealth(playerPed) > 0
                    local players = ESX.Game.GetPlayers()
                    ESX.TriggerServerCallback('Unique_Scripts_NPC_Doctor:chekmedic', function(ismedec)


                        if ismedec then
                            if isPlayerDown then

                                isHealing = true
                                Citizen.CreateThread(function()
                                    DrawBlackScreen(10000)
                                    isHealing = false
                                end)

                                TriggerEvent("esx_ambulancejob:revivex", GetPlayerServerId(PlayerId()))

                                Wait(10000)
                                TriggerServerEvent("pase:addXP", GetPlayerServerId(PlayerId()), 100)
                                lib.notify({ position = 'center-right', title = "", description = "Shoma Darman Shodid", type = 'success', duration = 5000 })
                                lib.notify({ position = 'center-right', title = "", description = "Az Shoma 15k kam shod be dalil Darman", type = 'info', duration = 5000 })
                            else

                                ESX.TriggerServerCallback('esx:getPlayerData', function(playerData)
                                    local bank = playerData.bank

                                    if bank then
                                        if bank >= healCost then

                                            TriggerServerEvent("esx:removeBank", healCost)


                                            isHealing = true
                                            Citizen.CreateThread(function()
                                                DrawBlackScreen(10000)
                                                isHealing = false
                                            end)

                                            TriggerEvent("esx_ambulancejob:revivex", GetPlayerServerId(PlayerId()))
                                            TriggerEvent("mythic_progbar:client:progress", {
                                                name = "heal",
                                                duration = 10000,
                                                label = "",
                                                useWhileDead = false,
                                                canCancel = false,
                                                controlDisables = {
                                                    disableMovement = true,
                                                    disableCarMovement = true,
                                                    disableMouse = false,
                                                    disableCombat = true,
                                                },
                                            }, function(status)

                                            end)

                                            Wait(10000)

                                            TriggerServerEvent("pase:addXP", GetPlayerServerId(PlayerId()), 100)
                                            lib.notify({ position = 'center-right', title = "", description = "Shoma Darman Shodid", type = 'success', duration = 5000 })
                                            lib.notify({ position = 'center-right', title = "", description = "Az Shoma 15k kam shod be dalil Darman", type = 'info', duration = 5000 })
                                        else
                                            lib.notify({ position = 'center-right', title = "", description = "Shoma Poul Kafi Nadarid", type = 'error', duration = 5000 })
                                        end
                                    else
                                        lib.notify({ position = 'center-right', title = "", description = "خطا در دریافت موجودی!", type = 'error', duration = 5000 })
                                    end
                                end)
                            end
                        else
                            lib.notify({ position = 'center-right', title = "", description = "Medik Dar Shahr Hast", type = 'error', duration = 5000 })
                        end
                    end)
                end
            }
        })
    end
end)

local pddoctorCoordsList = {
    {x = 441.3534, y = -974.723, z = 24.699, h = 180.44},
    {x = 613.8029, y = 12.60721, z = 86.817, h = 250.47},
    {x = 1836.779, y = 3672.764, z = 33.326, h = 296.03},

}

local ped = 0

Citizen.CreateThread(function()
    local hash = GetHashKey("s_m_m_doctor_01")
    while not HasModelLoaded(hash) do
        RequestModel(hash)
        Wait(100)
    end


    for _, coords in ipairs(pddoctorCoordsList) do
        local pedInstance = CreatePed("PED_TYPE_CIVFEMALE", hash, coords.x, coords.y, coords.z, coords.h, false, true)
        SetBlockingOfNonTemporaryEvents(pedInstance, true)
        FreezeEntityPosition(pedInstance, true)
        SetEntityInvincible(pedInstance, true)


        exports['ox_target']:addSphereZone({
            coords = vector3(coords.x, coords.y, coords.z),
            radius = 2.0,
            debug = drawZones,
            options = {
                {
                    name = 'heal_pd',
                    icon = 'fa-solid fa-heart',
                    label = 'درمان',
                    onSelect = function()
                        local playerData = ESX.GetPlayerData()
                        if playerData.job.name == 'police' or playerData.job.name == 'sheriff' or playerData.job.name == 'fbi' or playerData.job.name == 'mt' then
                            TriggerEvent("esx_ambulancejob:revivex", GetPlayerServerId(PlayerId()))
                            TriggerEvent("mythic_progbar:client:progress", {
                                name = "pdheal",
                                duration = 10000,
                                label = "",
                                useWhileDead = false,
                                canCancel = false,
                                controlDisables = {
                                    disableMovement = true,
                                    disableCarMovement = true,
                                    disableMouse = false,
                                    disableCombat = true,
                                },
                            }, function(status)

                            end)
                            Wait(10000)
                            TriggerServerEvent("pase:addXP", GetPlayerServerId(PlayerId()), 100)
                            lib.notify({ position = 'center-right', title = "", description = "Shoma Heal Shodid!", type = 'success', duration = 5000 })
                        else
                            lib.notify({ position = 'center-right', title = "", description = "Shoma nemitavanid az in ja estefade konid", type = 'error', duration = 5000 })
                        end
                    end,
                },
            },
        })
    end
end)

ESX = nil
local menuOpen = false
local allowedRadius = 75.0

local allowedPositions = {
    vector3(135.3890, -763.786, 45.752),
    vector3(120.1900, -759.605, 242.15),
}

Citizen.CreateThread(function()
    while ESX == nil do
        TriggerEvent('esx:getSharedObject', function(obj)
            ESX = obj
        end)
        Citizen.Wait(200)
    end
end)

function IsPlayerInAllowedArea()
    local playerPed = PlayerPedId()
    local playerCoords = GetEntityCoords(playerPed)

    for _, position in ipairs(allowedPositions) do
        local distance = #(playerCoords - position)
        if distance <= allowedRadius then
            return true
        end
    end

    return false
end

function OpenJobMenu(jobs)
    if menuOpen then return end

    if not jobs or #jobs == 0 then
        return
    end

    menuOpen = true
    local elements = {}


    ESX.TriggerServerCallback('jobmenu:getPlayerJob', function(currentJob)
        for _, job in ipairs(jobs) do
            if job.name ~= currentJob.name then
                table.insert(elements, {
                    label = ('%s - Rank: %s'):format(job.label, job.grade),
                    value = job.name,
                    job = job.name,
                    grade = job.grade,
                    label = job.label
                })
            end
        end

        if #elements == 0 then
            menuOpen = false
            return
        end

        ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'job_menu', {
            title = 'ChnageJob Menu',
            align = 'right',
            elements = elements
        }, function(data, menu)
            TriggerServerEvent('jobmenu:setJob', {
                name = data.current.job,
                grade = data.current.grade,
                label = data.current.label
            })
            menu.close()
            menuOpen = false
        end, function(data, menu)
            menu.close()
            menuOpen = false
        end)
    end)
end

RegisterNetEvent('jobmenu:openMenu')
AddEventHandler('jobmenu:openMenu', function(jobs)
    if IsPlayerInAllowedArea() then
        OpenJobMenu(jobs)
    else
        ESX.ShowNotification('Shoma Bayad Nazid Sakhteman FBI Bashid!')
    end
end)

RegisterCommand(Config_Switchjob.MenuCommand, function()
    if IsPlayerInAllowedArea() then
        TriggerServerEvent('jobmenu:checkPermission')
    else
        ESX.ShowNotification('Shoma Bayad Nazid Sakhteman FBI Bashid!')
    end
end, false)

Citizen.CreateThread(function()
    while true do



        N_0x4757f00bc6323cfe(GetHashKey("WEAPON_SNIPERRIFLE"), 0.0)
    	Wait(0)

        N_0x4757f00bc6323cfe(GetHashKey("WEAPON_MINIGUN"), 0.0)
    	Wait(0)

        N_0x4757f00bc6323cfe(GetHashKey("WEAPON_RPG"), 0.0)
    	Wait(0)

        N_0x4757f00bc6323cfe(GetHashKey("WEAPON_FIREWORK"), 0.0)
    	Wait(0)
    end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)

        koni(100416529)
        koni(-1312131151)
        koni(1119849093)
	local ped = PlayerPedId()
        if IsPedArmed(ped, 6) then
	       DisableControlAction(1, 140, true)
       	   DisableControlAction(1, 141, true)
           DisableControlAction(1, 142, true)
        end

    end
end)

function koni(hashgun)

    if GetSelectedPedWeapon(PlayerPedId()) == hashgun then
        local ped = PlayerPedId()
        DisableControlAction(1, 140, true)
        DisableControlAction(1, 141, true)
        DisableControlAction(1, 142, true)
        DisablePlayerFiring(PlayerId(), true)
    end
end

ESX = nil

Citizen.CreateThread(function()
    while ESX == nil do
        TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
        Citizen.Wait(0)
    end
end)

local vehicleDamage = 100
local display = false

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(6000)

        local playerPed = PlayerPedId()
        local vehicle = GetVehiclePedIsIn(playerPed, false)

        if vehicle and vehicle ~= 0 then
            local driver = GetPedInVehicleSeat(vehicle, -1)

            if driver == playerPed then
                local plate = GetVehicleNumberPlateText(vehicle)

                ESX.TriggerServerCallback('vehicle:getVehicleDamage', function(damage)
                    vehicleDamage = tonumber(damage) or 100

                    local currentEngineHealth = GetVehicleEngineHealth(vehicle)
                    local maxEngineHealth = 1000
                    local calculatedDamage = math.floor((currentEngineHealth / maxEngineHealth) * 100)

                    if calculatedDamage < vehicleDamage then
                        vehicleDamage = calculatedDamage
                        TriggerServerEvent('vehicle:saveVehicleDamage', plate, vehicleDamage)
                    end

                    display = true
                end, plate)
            else
                display = false
            end
        else
            display = false
        end
    end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)

        if display and type(vehicleDamage) == "number" then
            DrawVehicleDamageIndicator(vehicleDamage)
        end
    end
end)

function DrawVehicleDamageIndicator(damage)
    local screenX, screenY = 0.96, 0.3

    local color = {0, 255, 0}
    if damage < 50 then
        color = {255, 0, 0}
    elseif damage < 75 then
        color = {255, 255, 0}
    end

    DrawTextOnScreen("🚗", screenX, screenY - 0.01)
    DrawTextOnScreen(tostring(damage) .. "%", screenX, screenY + 0.05)
end

function DrawTextOnScreen(text, x, y)
    SetTextFont(4)
    SetTextProportional(1)
    SetTextScale(0.2, 0.5)
    SetTextColour(255, 255, 255, 255)
    SetTextEntry("STRING")
    AddTextComponentString(text)
    DrawText(x, y)
end

ESX = nil
local isWashing = false
local washLocations = {
    {x = 1337.829, y = 4391.652, z = 44.343},
}

local policeBlips = {}
local playerBlips = {}

Citizen.CreateThread(function()
    while ESX == nil do
        TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
        Citizen.Wait(0)
    end
    ESX.PlayerData = ESX.GetPlayerData()
end)

Citizen.CreateThread(function()
    while true do
        local playerPed = PlayerPedId()
        local coords = GetEntityCoords(playerPed)

        for _, location in pairs(washLocations) do
            DrawMarker(5, location.x, location.y, location.z, 0.0, 0.0, 0.0, 0, 0.0, 0.0, 1.0, 1.0, 1.0, 0, 200, 0, 100, false, true, 2, false, nil, nil, false)

            local distance = GetDistanceBetweenCoords(coords, location.x, location.y, location.z, true)

            if distance < 50.0 then
                if not playerBlips[location] then
                    local blip = AddBlipForCoord(location.x, location.y, location.z)
                    SetBlipSprite(blip, 500)
                    SetBlipScale(blip, 0.7)
                    SetBlipColour(blip, 1)
                    SetBlipAsShortRange(blip, true)
                    BeginTextCommandSetBlipName("STRING")
                    AddTextComponentSubstringPlayerName("Money Wash")
                    EndTextCommandSetBlipName(blip)
                    playerBlips[location] = blip
                end
            else
                if playerBlips[location] then
                    RemoveBlip(playerBlips[location])
                    playerBlips[location] = nil
                end
            end

            if distance < 1.0 then
                ESX.ShowHelpNotification('Press ~INPUT_CONTEXT~ to Wash Money')

                if IsControlJustPressed(0, 38) then
                    ESX.TriggerServerCallback('checkEskenasAmount', function(hasEnoughMoney)
                        if hasEnoughMoney then

                            ESX.TriggerServerCallback('checkJobAndBucket', function(isAllowed)
                                if isAllowed then
                                    if not isWashing then
                                        isWashing = true
                                        TriggerServerEvent('notifyPolice', location)

                                        TriggerEvent("mythic_progbar:client:progress", {
                                            name = "process_moneywash",
                                            duration = 10000,
                                            label = "Washing Money...",
                                            useWhileDead = false,
                                            canCancel = false,
                                            controlDisables = {
                                                disableMovement = true,
                                                disableCarMovement = true,
                                                disableMouse = false,
                                                disableCombat = true,
                                            },
                                            animation = {
                                                animDict = "amb@prop_human_bum_bin@idle_a",
                                                anim = "idle_a",
                                            }
                                        }, function(status)
                                            if not status then
                                                TriggerServerEvent('poolkasif', 50000)
                                            end
                                            isWashing = false
                                            TriggerServerEvent('removePoliceBlip', location)
                                            TriggerEvent('TaskSystem:WashMoney', 50000)
                                        end)
                                    end
                                else
                                    ESX.ShowNotification("⛔ شما اجازه پول‌شویی ندارید!")
                                end
                            end)
                        else
                            ESX.ShowNotification("⛔ شما 50,000 پول کثیف ندارید!")
                        end
                    end)
                end
            end
        end
        Wait(0)
    end
end)

RegisterNetEvent('createPoliceBlip')
AddEventHandler('createPoliceBlip', function(x, y, z)
    local blip = AddBlipForCoord(x, y, z)
    SetBlipSprite(blip, 161)
    SetBlipScale(blip, 0.7)
    SetBlipColour(blip, 1)
    SetBlipAlpha(blip, 250)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentSubstringPlayerName("Money Laundering in Progress")
    EndTextCommandSetBlipName(blip)

    table.insert(policeBlips, blip)

    Citizen.Wait(30000)
    if DoesBlipExist(blip) then
        RemoveBlip(blip)
    end
end)

RegisterNetEvent('removePoliceBlip')
AddEventHandler('removePoliceBlip', function()
    for _, blip in pairs(policeBlips) do
        if DoesBlipExist(blip) then
            RemoveBlip(blip)
        end
    end
    policeBlips = {}
end)

ESX = nil

local propModel = nil
local propSpawned = nil
local vestval = 75
local minval = 0
local maxval = 100

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end

	while ESX.GetPlayerData().job == nil do
		Citizen.Wait(10)
	end

	ESX.PlayerData = ESX.GetPlayerData()
end)

RegisterNetEvent('Unique_Scripts_item_mc:Use')
AddEventHandler('Unique_Scripts_item_mc:Use', function()
	local ad = "anim@heists@box_carry@"
	loadAnimDict( ad )
	TaskPlayAnim( PlayerPedId(), ad, "idle", 3.0, -8, -1, 63, 0, 0, 0, 0 )

	local x,y,z = table.unpack(GetEntityCoords(PlayerPedId()))
	propModel = 'prop_wheel_tyre'
	propSpawned = CreateObject(GetHashKey(propModel), x, y, z + 0.2, true, true, true)
	AttachEntityToEntity(propSpawned, PlayerPedId(), GetPedBoneIndex(PlayerPedId(), 60309), 0.10, 0.26, 0.32, 90.0, 110.0, 0.0, true, true, false, true, 1, true)
	Citizen.Wait(10000)
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(1)
		if propSpawned then
			if not IsPedInAnyVehicle(GetPlayerPed(-1)) then
				local x, y, z = table.unpack(GetEntityCoords(PlayerPedId()))
				Draw3DText_ItemMC(x, y, z, "~r~[G] ~w~Canncel")
				local vehicle = ESX.Game.GetClosestVehicle()
				if vehicle ~= nil then
					local tire = GetClosestVehicleTire(vehicle)
					if tire ~= nil then
						Draw3DText_ItemMC(tire.bonePos.x, tire.bonePos.y, tire.bonePos.z, "~g~[E] ~w~Nasb Charkh")

						if IsControlJustPressed(1, 38) then
							TriggerServerEvent('Unique_Scripts_item_mc:Used')
							ClearPedSecondaryTask(PlayerPedId())
							TaskStartScenarioInPlace(PlayerPedId(), 'CODE_HUMAN_MEDIC_TEND_TO_DEAD', 0, false)
							FreezeEntityPosition(PlayerPedId(), true)
							Citizen.Wait(5000)
							SetVehicleTyreFixed(vehicle, tire.tireIndex, 0, 1)
							deleteProp()
						end
					end
				end

				if IsControlJustPressed(1, 47) then
					deleteProp()
				end
			end
		end
	end
end)

RegisterCommand('tirefix', function()
	deleteProp()
end)

function deleteProp()
	DetachEntity(propSpawned, 1, 1)
	DeleteObject(propSpawned)
	ClearPedSecondaryTask(PlayerPedId())
	ClearPedTasks(PlayerPedId())
	FreezeEntityPosition(PlayerPedId(), false)
	propSpawned = nil
end

function GetClosestVehicleTire(vehicle)
	local tireBones = {"wheel_lf", "wheel_rf", "wheel_lm1", "wheel_rm1", "wheel_lm2", "wheel_rm2", "wheel_lm3", "wheel_rm3", "wheel_lr", "wheel_rr"}
	local tireIndex = {
		["wheel_lf"] = 0,
		["wheel_rf"] = 1,
		["wheel_lm1"] = 2,
		["wheel_rm1"] = 3,
		["wheel_lm2"] = 45,
		["wheel_rm2"] = 47,
		["wheel_lm3"] = 46,
		["wheel_rm3"] = 48,
		["wheel_lr"] = 4,
		["wheel_rr"] = 5,
	}
	local player = PlayerId()
	local plyPed = GetPlayerPed(player)
	local plyPos = GetEntityCoords(plyPed, false)
	local minDistance = 1.0
	local closestTire = nil

	for a = 1, #tireBones do
		local bonePos = GetWorldPositionOfEntityBone(vehicle, GetEntityBoneIndexByName(vehicle, tireBones[a]))
		local distance = Vdist(plyPos.x, plyPos.y, plyPos.z, bonePos.x, bonePos.y, bonePos.z)

		if closestTire == nil then
			if distance <= minDistance then
				closestTire = {bone = tireBones[a], boneDist = distance, bonePos = bonePos, tireIndex = tireIndex[tireBones[a]]}
			end
		else
			if distance < closestTire.boneDist then
				closestTire = {bone = tireBones[a], boneDist = distance, bonePos = bonePos, tireIndex = tireIndex[tireBones[a]]}
			end
		end
	end

	return closestTire
end

function Draw3DText_ItemMC(x, y, z, text)
    local onScreen,_x,_y=World3dToScreen2d(x,y,z)
    local px,py,pz=table.unpack(GetGameplayCamCoords())
    local dist = GetDistanceBetweenCoords(px,py,pz, x,y,z, 1)

    local scale = (1/dist)
    local fov = (1/GetGameplayCamFov())*100
    local scale = scale*fov

    if onScreen then
        SetTextScale(0.0*scale, 0.75*scale)
        SetTextFont(4)
        SetTextProportional(1)

        SetTextColour(255, 255, 255, 255)
        SetTextDropshadow(0, 0, 0, 0, 255)
        SetTextEdge(2, 0, 0, 0, 150)
        SetTextDropShadow()
        SetTextOutline()
        SetTextEntry("STRING")
        SetTextCentre(1)
        AddTextComponentString(text)
        DrawText(_x,_y)
    end
end

RegisterNetEvent('Unique_Scripts_item_mc:flipp')
AddEventHandler('Unique_Scripts_item_mc:flipp', function()
    local playerPed = PlayerPedId()
    local vehicle = ESX.Game.GetVehicleInDirection(4)

    if vehicle ~= 0 then
        TriggerServerEvent('Unique_Scripts_item_mc:removeitemss', 1)
        TriggerEvent("mythic_progbar:client:progress", {
            name = "process_marijuana",
            duration = 10000,
            label = "Dar Hale Flip Kardan Mashin",
            useWhileDead = false,
            canCancel = false,
            controlDisables = {
                disableMovement = true,
                disableCarMovement = true,
                disableMouse = false,
                disableCombat = true,
            },
            TaskStartScenarioInPlace(PlayerPedId(), 'CODE_HUMAN_MEDIC_TEND_TO_DEAD', 0, false)
        }, function(status)
            if not status then
                NetworkRequestControlOfEntity(vehicle)
                SetVehicleOnGroundProperly(vehicle)
                Citizen.Wait(200)
                NetworkRequestControlOfEntity(vehicle)
                SetVehicleOnGroundProperly(vehicle)
            end
        end)
    else
        TriggerEvent('chat:addMessage', {
            color = {200, 0, 0},
            multiline = true,
            args = {"[ System ] :", "^0 Shoma Bayad Nazdike Mashin Bashid !"}
        })
    end
end)

RegisterNetEvent('Unique_Scripts_item_mc:cleann')
AddEventHandler('Unique_Scripts_item_mc:cleann', function()
	local playerPed = GetPlayerPed(-1)
	local beforeval = GetPedArmour(playerPed)
    local coords = GetEntityCoords(playerPed)
    local vehicle = ESX.Game.GetVehicleInDirection(4)
    if vehicle ~= 0 then
		TriggerServerEvent('Unique_Scripts_item_mc:removeitemssclean', 1)
        exports['mythic_progbar']:Progress({
            name = "firstaid_action",
            duration = 10000,
            label = "Dar Hale Tamiz Kardan",
            useWhileDead = false,
            canCancel = false,
            controlDisables = {
                disableMovement = true,
                disableCarMovement = false,
                disableMouse = false,
                disableCombat = true,
			},
			TaskStartScenarioInPlace(playerPed, 'WORLD_HUMAN_MAID_CLEAN', 0, true)

		}, function(status)
			if not status then
				local id = NetworkGetNetworkIdFromEntity(vehicle)
				WashDecalsFromVehicle(vehicle, playerPed, 1.0)
				SetVehicleDirtLevel(vehicle, 0.1)
				ClearPedTasksImmediately(playerPed)
				NetworkFadeInEntity(vehicle, true, true)
				SetNetworkIdCanMigrate(id, true)
				SetNetworkIdExistsOnAllMachines(id, true)
				SetVehicleHasBeenOwnedByPlayer(vehicle, true)
				SetEntityAsMissionEntity(vehicle, true, true)
			end
    	end)
	else
		TriggerEvent('chat:addMessage', {
            color = {200, 0, 0},
            multiline = true,
            args = {"[ System ] :", "^0 Shoma Bayad Nazdike Mashin Bashid !"}
        })
	end
end)

do
ESX = nil
local PlayerData = nil
Citizen.CreateThread(function()
    while ESX == nil do
        TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
        Citizen.Wait(0)
    end
    while ESX.GetPlayerData().job == nil do Wait(20) end
    PlayerData = ESX.GetPlayerData()
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(Job)
    PlayerData.job = Job
end)

RegisterNetEvent('esx:setGang')
AddEventHandler('esx:setGang', function(Gang)
    PlayerData.gang = Gang
end)

local OnBaked = false
local SETTINGS = {
    back_bone = 24816,
    x = 0.065,
    y = -0.16,
    z = -0.00,
    x_rotation = 0.0,
    y_rotation = 390.0,
    z_rotation = 0.0,
    compatable_weapon_hashes = {
        ["w_mg_minigun"] = GetHashKey("WEAPON_MINIGUN"),
        ["w_ar_carbinerifle"] = -2084633992,
        ["w_ar_carbineriflemk2"] = GetHashKey("WEAPON_CARBINERIFLE_MK2"),
        ["w_ar_assaultrifle"] = -1074790547,
        ["w_ar_specialcarbine"] = -1063057011,
        ["w_ar_bullpuprifle"] = 2132975508,
        ["w_ar_advancedrifle"] = -1357824103,
        ["w_sb_microsmg"] = 324215364,
        ["w_sb_assaultsmg"] = -270015777,
        ["w_sb_smg"] = 736523883,
        ["w_sb_smgmk2"] = GetHashKey("WEAPON_SMGMK2"),
        ["w_sb_gusenberg"] = 1627465347,
        ["w_sr_sniperrifle"] = 100416529,
        ["w_sg_assaultshotgun"] = -494615257,
        ["w_sg_bullpupshotgun"] = -1654528753,
        ["w_sg_pumpshotgun"] = 487013001,
        ["w_sg_heavyshotgun"] = GetHashKey("WEAPON_HEAVYSHOTGUN"),
        ["w_ar_m4"] = GetHashKey("WEAPON_M4"),

        ["w_pi_pistol"] = GetHashKey("WEAPON_PISTOL"),
        ["w_pi_pistol50"] = GetHashKey("WEAPON_PISTOL50"),

    }
}

local CHEST_WEAPONS = {
    ["w_sb_microsmg"]  = true,
    ["w_sb_assaultsmg"] = true,
    ["w_sb_smg"]        = true,
    ["w_sb_smgmk2"]     = true,
    ["w_sb_gusenberg"]  = true,
}

local WAIST_WEAPONS = {
    ["w_pi_pistol"]   = true,
    ["w_pi_pistol50"] = true,
}

local POSITIONS = {
    back = {
        bone = 24816,
        x = 0.065, y = -0.16, z = -0.00,
        x_rotation = 0.0, y_rotation = 390.0, z_rotation = 0.0,
    },
    chest = {
        bone = 24818,
        x = 0.023, y = 0.216, z = -0.034,
        x_rotation = 167.5, y_rotation = 147.5, z_rotation = 0.0,
    },

    waist = {
        bone = 11816,
        x = 0.045, y = -0.159, z = -0.011,
        x_rotation = 0.0, y_rotation = -57.5, z_rotation = 0.0,
    },

}

function GetSlotForWeapon(wep_name)
    if CHEST_WEAPONS[wep_name] then
        return "chest"
    elseif WAIST_WEAPONS[wep_name] then
        return "waist"
    else
        return "back"
    end
end

function SlotLabel(slot)
    if slot == "chest" then return "Sine"
    elseif slot == "waist" then return "Posht-Basan"
    else return "Posht" end
end

local WornWeapons     = { back = nil, chest = nil, waist = nil }
local AttachedObjects = { back = nil, chest = nil, waist = nil }
local SuppressAutoReattach = false

function AnyWorn()
    return WornWeapons.back ~= nil or WornWeapons.chest ~= nil or WornWeapons.waist ~= nil
end

function SaveWornWeapons()
    local toSave = {
        back  = WornWeapons.back and WornWeapons.back.hash or nil,
        chest = WornWeapons.chest and WornWeapons.chest.hash or nil,
        waist = WornWeapons.waist and WornWeapons.waist.hash or nil,
    }
    TriggerServerEvent('Weapon_On_back:SaveData', PlayerData.identifier, toSave)
end

RegisterCommand("weapback", function()
    if Config_WeaponsOnBack.mahdod then
        ESX.TriggerServerCallback('Weapon_On_Back:GetBossGang', function(Call)
            if type(Call) == "table" then
                local Pcoords = GetEntityCoords(PlayerPedId())

                local Distance = GetDistanceBetweenCoords(Call.x, Call.y, Call.z, Pcoords.x, Pcoords.y, Pcoords.z, true)

                if Distance <= 50 then
                    OpenWeaponBackMenu()
                else
                    lib.notify({ position = 'center-right', title = "", description = "Shoma Baraye Estefade Az In Cmd Bayad Nazdik Bays Gangetan Bashid!", type = 'error', duration = 8000 })
                end
            elseif Call == true then
                OpenWeaponBackMenu()
            else
                lib.notify({ position = 'center-right', title = "", description = "Shoma Baraye Estefade Az In Cmd Bayad Ozv Gang Ya Organ Nezami Bashid!", type = 'error', duration = 8000 })
            end
        end, PlayerData.gang.name, PlayerData.job.name)
    else
        OpenWeaponBackMenu()
    end
end)

function OpenWeaponBackMenu()
    local elements = {}
    local playerPed = PlayerPedId()

    if AnyWorn() then
        table.insert(elements, { label = "Off Hame", value = "off_all" })
    end
    if WornWeapons.back then
        table.insert(elements, { label = "Off Posht ("..(ESX.GetWeaponLabel(WornWeapons.back.hash) or "?")..")", value = "off_back" })
    end
    if WornWeapons.chest then
        table.insert(elements, { label = "Off Sine ("..(ESX.GetWeaponLabel(WornWeapons.chest.hash) or "?")..")", value = "off_chest" })
    end
    if WornWeapons.waist then
        table.insert(elements, { label = "Off Posht-Basan ("..(ESX.GetWeaponLabel(WornWeapons.waist.hash) or "?")..")", value = "off_waist" })
    end

    for wep_name, wep_hash in pairs(SETTINGS.compatable_weapon_hashes) do
        if HasPedGotWeapon(playerPed, wep_hash, false) then
            local weaponLabel = ESX.GetWeaponLabel(wep_hash)
            if not weaponLabel then
                weaponLabel = wep_name:gsub("w_%a+_", "")
            end
            local slot = GetSlotForWeapon(wep_name)
            table.insert(elements, { label = weaponLabel .. " -> " .. SlotLabel(slot), value = wep_hash })
        end
    end

    if #elements == 0 then
        lib.notify({ position = 'center-right', title = "", description = "Shoma Hich Aslahei Dar Jib Nadari!", type = 'error', duration = 5000 })
        return
    end

    ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'weapon_back_menu', {
        title    = "Entekhab Aslahe (Posht / Sine / Posht-Basan)",
        align    = 'top-left',
        elements = elements
    }, function(data, menu)
        local val = data.current.value

        if val == "off_all" then
            DetachSlot("back", true)
            DetachSlot("chest", true)
            DetachSlot("waist", true)
            lib.notify({ position = 'center-right', title = "", description = "Hame Aslahe Ha Bardashte Shod!", type = 'info', duration = 4000 })
        elseif val == "off_back" then
            DetachSlot("back", true)
            lib.notify({ position = 'center-right', title = "", description = "Aslahe Az Posht Bardashte Shod!", type = 'info', duration = 4000 })
        elseif val == "off_chest" then
            DetachSlot("chest", true)
            lib.notify({ position = 'center-right', title = "", description = "Aslahe Az Sine Bardashte Shod!", type = 'info', duration = 4000 })
        elseif val == "off_waist" then
            DetachSlot("waist", true)
            lib.notify({ position = 'center-right', title = "", description = "Aslahe Az Posht-Basan Bardashte Shod!", type = 'info', duration = 4000 })
        else
            local selectedWeaponHash = val
            local wepModel = GetWeaponModelByHash(selectedWeaponHash)
            if wepModel then
                local slot = GetSlotForWeapon(wepModel)
                DetachSlot(slot, false)
                WornWeapons[slot] = { hash = selectedWeaponHash, model = wepModel }
                AttachToSlot(slot)
                lib.notify({ position = 'center-right', title = "", description = (ESX.GetWeaponLabel(selectedWeaponHash) or "Aslahe") .. " Rooye " .. SlotLabel(slot) .. " Gozashte Shod!", type = 'success', duration = 4000 })
            else
                lib.notify({ position = 'center-right', title = "", description = "Nemitoonam In Aslahe Ro Bezaram!", type = 'error', duration = 5000 })
            end
        end

        SaveWornWeapons()
        SuppressAutoReattach = false
        OnBaked = AnyWorn()
        Citizen.CreateThread(function()
            Wait(50)
            StartGeter()
        end)

        menu.close()
    end, function(data, menu)
        menu.close()
    end)
end

function GetWeaponModelByHash(weaponHash)
    for wep_name, wep_hash in pairs(SETTINGS.compatable_weapon_hashes) do
        if wep_hash == weaponHash then
            return wep_name
        end
    end
    return nil
end

function GetWeaponNameFromHash(weaponHash)
    for k,v in pairs(Config_WeaponsOnBack.WeaponComponents) do
        if k == weaponHash then
            return k
        end
    end
    return nil
end

function AttachToSlot(slot, playSound)
    local worn = WornWeapons[slot]
    if not worn then return end

    local playerPed = PlayerPedId()
    local profile = POSITIONS[slot]
    local bone = GetPedBoneIndex(playerPed, profile.bone)

    local handle = CreateWeaponObject(worn.hash, 0, 0, 0, 0, true, 1.0, 0)





    if not NetworkGetEntityIsNetworked(handle) then
        NetworkRegisterEntityAsNetworked(handle)
    end
    local netId = NetworkGetNetworkIdFromEntity(handle)
    SetNetworkIdCanMigrate(netId, true)
    SetNetworkIdExistsOnAllMachines(netId, true)

    AttachedObjects[slot] = { handle = handle }


    if playSound ~= false then
        PlaySoundFrontend(-1, "SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET", true)
    end


    local thisHandle = handle

    ESX.TriggerServerCallback('Weapon_On_Back:GetWeaponComponent', function(Back)
        if not thisHandle or not DoesEntityExist(thisHandle) then
            return
        end

        local WeaponCompo = Back or {}

        for i = 1, #WeaponCompo do
            local GCom = Config_WeaponsOnBack.WeaponComponents[worn.hash] and Config_WeaponsOnBack.WeaponComponents[worn.hash][WeaponCompo[i]]
            if GCom then
                GiveWeaponComponentToWeaponObject(thisHandle, GCom)
                Citizen.Wait(50)
            end
        end

        AttachEntityToEntity(thisHandle, playerPed, bone, profile.x, profile.y, profile.z, profile.x_rotation, profile.y_rotation, profile.z_rotation, 1, 1, 0, 0, 2, 1)
    end, GetWeaponForHashK(worn.hash))
end

function DetachSlot(slot, clearWorn, playSound)
    if AttachedObjects[slot] then
        DeleteObject(AttachedObjects[slot].handle)
        AttachedObjects[slot] = nil
        if playSound ~= false then
            PlaySoundFrontend(-1, "BACK", "HUD_FRONTEND_DEFAULT_SOUNDSET", true)
        end
    end
    if clearWorn then
        WornWeapons[slot] = nil
    end
end

function GetWeaponForHashK(Hash)
    for k,v in pairs(ESX.GetWeaponList()) do

        if GetHashKey(v.name) == Hash then
            return v.name
        end
    end
end

function isMeleeWeapon(wep_name)
    return wep_name == "prop_golf_iron_01" or wep_name == "w_me_bat" or wep_name == "prop_ld_jerrycan_01"
end

function StartGeter()
    while OnBaked do
        local newWeapon = GetSelectedPedWeapon(PlayerPedId())

        for slot, worn in pairs(WornWeapons) do
            if worn then
                if AttachedObjects[slot] and newWeapon == worn.hash then
                    DetachSlot(slot, false)
                elseif (not AttachedObjects[slot]) and newWeapon == GetHashKey("WEAPON_UNARMED") and not SuppressAutoReattach then
                    AttachToSlot(slot)
                end
            end
        end

        Citizen.Wait(1200)
    end
end

RegisterNetEvent('esx:removeWeapon')
AddEventHandler('esx:removeWeapon', function(name , ammo)
    local hash = GetHashKey(name)
    local touched = false

    for slot, worn in pairs(WornWeapons) do
        if worn and worn.hash == hash then
            DetachSlot(slot, true)
            touched = true
        end
    end

    if touched then
        SaveWornWeapons()
        OnBaked = AnyWorn()
    end
end)

RegisterNetEvent("Weapon_On_back:PlayerSpawned")
AddEventHandler('Weapon_On_back:PlayerSpawned', function(SavedSlots)
    if not SavedSlots then return end



    if type(SavedSlots) ~= "table" then
        SavedSlots = { back = SavedSlots }
    end

    for _, slot in ipairs({"back", "chest", "waist"}) do
        local hash = SavedSlots[slot]
        if hash then
            local wepModel = GetWeaponModelByHash(hash)
            if wepModel then
                WornWeapons[slot] = { hash = hash, model = wepModel }
                AttachToSlot(slot)
            end
        end
    end

    OnBaked = AnyWorn()
    Citizen.CreateThread(function()
        Wait(500)
        SuppressAutoReattach = false
        Wait(50)
        StartGeter()
    end)
end)

AddEventHandler('playerSpawned', function(prr)
   TriggerServerEvent("WeaponPlayerLoaded", GetPlayerServerId(PlayerId()))
end)

Citizen.CreateThread(function()
    local wasInVehicle = false
    local hiddenForVehicle = false
    local previousSuppress = false

    while true do
        Citizen.Wait(300)
        local playerPed = PlayerPedId()
        local inVehicle = IsPedInAnyVehicle(playerPed, false)

        if inVehicle and not wasInVehicle then
            if AnyWorn() then
                DetachSlot("back", false, false)
                DetachSlot("chest", false, false)
                DetachSlot("waist", false, false)
                hiddenForVehicle = true
                previousSuppress = SuppressAutoReattach
                SuppressAutoReattach = true
            end
        elseif not inVehicle and wasInVehicle then
            if hiddenForVehicle then
                SuppressAutoReattach = previousSuppress
                for _, slot in ipairs({"back", "chest", "waist"}) do
                    if WornWeapons[slot] and not AttachedObjects[slot] then
                        AttachToSlot(slot)
                    end
                end
            end
            hiddenForVehicle = false
        end

        wasInVehicle = inVehicle
    end
end)
end

ESX = nil
local markerPos = vector3(-426.296, 1137.764, 326.90)
local zoneCoords = vector3(-420.973, 1139.818, 326.82)
local winnerText = nil
local showWinnerUntil = 0
local Chek = false

Citizen.CreateThread(function()
    while ESX == nil do
        TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
        Citizen.Wait(0)
    end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        local playerCoords = GetEntityCoords(PlayerPedId())
        local dist = #(playerCoords - markerPos)
        if dist < 10.0 then
            DrawMarker(4, markerPos.x, markerPos.y, markerPos.z - 1.0, 0, 0, 0, 0, 0, 0, 1.0, 1.0, 1.0, 255, 0, 0, 100, false, true, 2, nil, nil, false)
            if dist < 1.5 then
                ESX.ShowHelpNotification("~INPUT_CONTEXT~ Jahat Shoroe Mosabeghe")
                if IsControlJustReleased(0, 38) then
                    OpenBoxingMenu()
                end
            end
        else


            Citizen.Wait(500)
        end
    end
end)

function OpenBoxingMenu()
    local elements = {
        {label = "📌 تیم 1", value = "team1"},
        {label = "📌 تیم 2", value = "team2"}
    }

    ESX.TriggerServerCallback('boxing:getTeams', function(t1, t2)
        if #t1 > 0 and #t2 > 0 then
            table.insert(elements, {label = "🚀 شروع مبارزه", value = "start"})
        end

        ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'boxing_menu', {
            title    = 'بوکس دو تیمه',
            align    = 'top-left',
            elements = elements
        }, function(data, menu)
            if data.current.value == 'team1' then
                OpenTeamMenu(1)
            elseif data.current.value == 'team2' then
                OpenTeamMenu(2)
            elseif data.current.value == 'start' then
                TriggerServerEvent('boxing:startFight')

            end
        end, function(data, menu)
            menu.close()
        end)
    end)
end

function OpenTeamMenu(team)
    ESX.TriggerServerCallback('boxing:getTeams', function(t1, t2)
        local elements = {
            {label = "➕ دعوت بازیکن", value = "invite"}
        }

        local currentTeam = team == 1 and t1 or t2
        for i=1, #currentTeam do
            table.insert(elements, {label = "👤 بازیکن: " .. currentTeam[i].name .. " | ID: " .. currentTeam[i].id, value = "member"})
        end

        ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'team_menu', {
            title = 'تیم ' .. team,
            align = 'top-left',
            elements = elements
        }, function(data, menu)
            if data.current.value == "invite" then
                InviteNearbyPlayers(team, t1, t2)
            end
        end, function(data, menu)
            menu.close()
        end)
    end)
end

function InviteNearbyPlayers(team, t1, t2)
    local players = GetActivePlayers()
    local elements = {}
    local excluded = {}

    for _, p in pairs(t1) do excluded[p.id] = true end
    for _, p in pairs(t2) do excluded[p.id] = true end

    for i=1, #players do
        local pid = GetPlayerServerId(players[i])
        local name = GetPlayerName(players[i])
        if not excluded[pid] then
            local dist = #(GetEntityCoords(PlayerPedId()) - GetEntityCoords(GetPlayerPed(players[i])))
            if dist < 10.0 then
                table.insert(elements, {label = name .. " | ID: " .. pid, value = pid})
            end
        end
    end

    if #elements == 0 then
        ESX.ShowNotification("هیچ بازیکنی برای دعوت در دسترس نیست.")
        return
    end

    ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'invite_menu', {
        title    = 'انتخاب بازیکن برای تیم ' .. team,
        align    = 'top-left',
        elements = elements
    }, function(data, menu)
        TriggerServerEvent('boxing:invitePlayer', data.current.value, team)
    end, function(data, menu)
        menu.close()
    end)
end

RegisterNetEvent('boxing:receiveInvite')
AddEventHandler('boxing:receiveInvite', function(inviterId, team)
    local alert = lib.alertDialog({
        header = 'دعوت به تیم بوکس',
        content = 'آیا می‌خواهید به تیم ' .. team .. ' بپیوندید؟',
        centered = true,
        cancel = true,
        labels = {
            confirm = 'بله',
            cancel = 'خیر'
        }
    })

    if alert == 'confirm' then
        TriggerServerEvent('boxing:acceptInvite', inviterId, team)
    end
end)

RegisterNetEvent('boxing:teleportToZone')
AddEventHandler('boxing:teleportToZone', function()
    local offset = math.random(-2, 2)
    SetEntityCoords(PlayerPedId(), zoneCoords.x + offset, zoneCoords.y + offset, zoneCoords.z)
    Chek = true
end)

RegisterNetEvent('boxing:returnToMarker')
AddEventHandler('boxing:returnToMarker', function()
    TriggerEvent("esx_ambulancejob:revivex", GetPlayerServerId(PlayerId()))
    SetEntityCoords(PlayerPedId(), markerPos.x, markerPos.y, markerPos.z)
end)

RegisterNetEvent('boxing:announceWinner')
AddEventHandler('boxing:announceWinner', function(winnerName)

end)

RegisterNetEvent('boxing:displayWinnerText')
AddEventHandler('boxing:displayWinnerText', function(name)
    winnerText = "🏆 Winner: " .. name
    showWinnerUntil = GetGameTimer() + 50000
end)

local boxingGloves = {}

function GiveBoxingGloves()
    local playerPed = PlayerPedId()


    RemoveBoxingGloves()


    local gloveModel = 'prop_boxing_glove_01'


    RequestModel(gloveModel)
    while not HasModelLoaded(gloveModel) do
        Citizen.Wait(10)
    end


    local rightGlove = CreateObject(gloveModel, 0, 0, 0, true, true, true)
    AttachEntityToEntity(rightGlove, playerPed, GetPedBoneIndex(playerPed, 28422), 0.0, 0.0, 0.0, 0.0, 90.0, 90.0, true, true, false, true, 1, true)


    local leftGlove = CreateObject(gloveModel, 0, 0, 0, true, true, true)
    AttachEntityToEntity(leftGlove, playerPed, GetPedBoneIndex(playerPed, 60309), 0.0, 0.0, 0.0, 0.0, 90.0, -90.0, true, true, false, true, 1, true)


    boxingGloves = {right = rightGlove, left = leftGlove}
end

function RemoveBoxingGloves()
    if boxingGloves.right and DoesEntityExist(boxingGloves.right) then
        DeleteObject(boxingGloves.right)
    end
    if boxingGloves.left and DoesEntityExist(boxingGloves.left) then
        DeleteObject(boxingGloves.left)
    end
    boxingGloves = {}
end

RegisterNetEvent('boxing:startFightClient')
AddEventHandler('boxing:startFightClient', function()
    GiveBoxingGloves()
end)

RegisterNetEvent('boxing:matchEnded')
AddEventHandler('boxing:matchEnded', function()
    RemoveBoxingGloves()
    ESX.UI.Menu.CloseAll()

end)

AddEventHandler("esx:onPlayerDeath",function(KillData)
    local ped = PlayerPedId()
    local isAlive = not IsEntityDead(ped)
    local pCoords = GetEntityCoords(ped)
    local Distance = GetDistanceBetweenCoords(zoneCoords.x, zoneCoords.y, zoneCoords.z, pCoords.x, pCoords.y, pCoords.z, true)
    if Distance <= 6.5 then
        TriggerServerEvent('Unique_Boxing:ended')
    end
end)

RegisterNetEvent('boxing:checkAlive')
AddEventHandler('boxing:checkAlive', function()
    local ped = PlayerPedId()
    local isAlive = not IsEntityDead(ped)
    TriggerServerEvent('boxing:checkAliveResult', isAlive)
end)

Citizen.CreateThread(function()
    while true do
        if winnerText and GetGameTimer() < showWinnerUntil then
            Citizen.Wait(0)
            DrawText3D(zoneCoords.x, zoneCoords.y, zoneCoords.z + 1.5, winnerText)
        else

            Citizen.Wait(500)
        end
    end
end)

function DrawText3D(x, y, z, text)
    local onScreen,_x,_y = World3dToScreen2d(x,y,z)
    local p = GetGameplayCamCoords()
    local dist = #(vector3(x, y, z) - p)
    local scale = (1 / dist) * 2
    local fov = (1 / GetGameplayCamFov()) * 100
    scale = scale * fov

    if onScreen then
        SetTextScale(1.2 * scale, 1.2 * scale)
        SetTextFont(4)
        SetTextProportional(1)
        SetTextColour(255, 255, 255, 215)
        SetTextEntry("STRING")
        SetTextCentre(true)
        AddTextComponentString(text)
        DrawText(_x, _y)
    end
end

