-- Pub by FleeX Team , https://discord.gg/87rGBxgCsa

--age ino mibini bedoun hich gohi nisti
--baraye yad giri lua be https://www.lua.org/pil/1.html morajee kon
--inam docs fivem https://docs.fivem.net/docs/

local eventcar = {}
local eventskin = {}
local eventped = {}
local eventweapon = {}
local eventtype = nil
local eventindex = 0
local eventBlips = {}
local eventBlipThread = false
local eventBlipThreadID = false
local eventBlipCheckPoint = false

local eventGod = {
    player = false,
    vehicle = false,
} 

function createblip(coords,type , color , text)
	blip = AddBlipForCoord(coords.x, coords.y, coords.z)
    SetBlipSprite(blip, type)
    SetBlipDisplay(blip, 4)
    SetBlipScale(blip, 1.0)
    SetBlipColour(blip, color)
    SetBlipAsShortRange(blip, true)
	BeginTextCommandSetBlipName("STRING")
    AddTextComponentString(text)
    EndTextCommandSetBlipName(blip)
	return blip
end


RegisterNetEvent("eventcar:start")
AddEventHandler("eventcar:start",function(id,coords,namec,cool,range)
	id = id
	eventcar[id] = {name = namec,cooldown = cool,range = range,coords =  vector3(coords.x,coords.y,coords.z - 1),blip = createblip(vector3(coords.x,coords.y,coords.z - 1),726,1,"Event car(".. id ..")")}
	Citizen.CreateThread(function()
		while eventcar[id] ~= nil do
			Wait(0)
			if GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()),eventcar[id].coords) < 60.0 then
				DrawMarker(1, eventcar[id].coords, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, range + 0.0, range + 0.0, (range + 0.0 / 5) , 255, 0, 0, 100, false, false, 2, false, nil, nil, false)
				Draw3DText(eventcar[id].coords.x,eventcar[id].coords.y,eventcar[id].coords.z,"Dokme E Jahat Daryaft Vehicle",4, range, range)
			end
			if GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()),eventcar[id].coords) < tonumber(range) then
				eventindex = id
				eventtype = "car"
			elseif eventtype == "car" and eventindex == id then
				eventindex = 0
				eventtype = nil
			end
		end
	end)
end)

RegisterNetEvent("eventcar:stop")
AddEventHandler("eventcar:stop",function(index)
	RemoveBlip(eventcar[index].blip)
	eventcar[index] = nil
	if eventindex == index then
		eventindex = 0
	end
	if eventtype == "car" then
		eventtype = nil
	end
end)


--event skin
RegisterNetEvent("eventskin:start")
AddEventHandler("eventskin:start",function(id,coords,skin)
	id = id
	eventskin[id] = {skin = skin , used = false,coords =  vector3(coords.x,coords.y,coords.z - 1),blip = createblip(vector3(coords.x,coords.y,coords.z - 1),73,1,"Event skin(".. id ..")")}
	Citizen.CreateThread(function()
		while eventskin[id] ~= nil do
			Wait(1)
			if GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()),eventskin[id].coords) < 30.0 then
				DrawMarker(1, eventskin[id].coords, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.5, 1.5, 1.5, 0, 255, 0, 100, false, false, 2, false, nil, nil, false)
				if not eventskin[id].used then
					Draw3DText(eventskin[id].coords.x,eventskin[id].coords.y,eventskin[id].coords.z,"Dokme E Jahat Poushidan lebas",4, 0.1, 0.1)
				else
					Draw3DText(eventskin[id].coords.x,eventskin[id].coords.y,eventskin[id].coords.z,"Dokme E Jahat Dar avordan lebas",4, 0.1, 0.1)
				end
			end
			if GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()),eventskin[id].coords) < 2.0 then
				eventindex = id
				eventtype = "skin"
			elseif eventtype == "skin" and eventindex == id then
				eventindex = 0
				eventtype = nil
			end
		end
	end)
end)

RegisterNetEvent('getskinforevent')
AddEventHandler('getskinforevent',function()
    TriggerEvent('skinchanger:getSkin', function(skin)
        TriggerServerEvent('starteventskin',skin)
    end)
end)


RegisterNetEvent("eventskin:stop")
AddEventHandler("eventskin:stop",function(index)
	RemoveBlip(eventskin[index].blip)
	if eventskin[index].used then
		ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin, jobSkin)
			TriggerEvent('skinchanger:loadSkin', skin)
		end)
	end
	eventskin[index] = nil
	if eventindex == index then
		eventindex = 0
	end
	if eventtype == "skin" then
		eventtype = nil
	end

end)

--event ped

RegisterNetEvent("eventped:start")
AddEventHandler("eventped:start",function(id,coords,ped)
    id = id
    eventped[id] = {ped = ped , used = false,coords =  vector3(coords.x,coords.y,coords.z - 1),blip = createblip(vector3(coords.x,coords.y,coords.z - 1),480,1,"Event ped(".. id ..")")}
	Citizen.CreateThread(function()
		while eventped[id] ~= nil do
			Wait(1)
			if GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()),eventped[id].coords) < 30.0 then
				DrawMarker(1, eventped[id].coords, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.5, 1.5, 1.5, 173, 32, 242, 100, false, false, 2, false, nil, nil, false)
				if not eventped[id].used then
					Draw3DText(eventped[id].coords.x,eventped[id].coords.y,eventped[id].coords.z,"Dokme E Jahat Taghir ped",4, 0.1, 0.1)
				else
					Draw3DText(eventped[id].coords.x,eventped[id].coords.y,eventped[id].coords.z,"Dokme E Jahat Taghir Be Halat Deafault",4, 0.1, 0.1)
				end
			end
			if GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()),eventped[id].coords) < 2.0 then
				eventindex = id
				eventtype = "ped"
			elseif eventtype == "ped" and eventindex == id then
				eventindex = 0
				eventtype = nil
			end
		end
	end)
end)




RegisterNetEvent("eventped:stop")
AddEventHandler("eventped:stop",function(id)
	RemoveBlip(eventped[id].blip)
	if eventped[id].used then
		ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(LastSkin, jobSkin)
			local model = nil
			if LastSkin.sex == 0 then
				model = 'mp_m_freemode_01'
			else
				model = 'mp_f_freemode_01'
			end
			TriggerEvent("resetpedHandler",model)
			Wait(1000)
			exports['sunset_clothe']:removeStuffJob()
			Citizen.Wait(1000)
			exports['sunset_clothe']:loadUsed()
			TriggerEvent("esx:restoreLoadout")
		end)
	end
	eventped[id] = nil
end)


--event weapon
RegisterNetEvent("eventweapon:start")
AddEventHandler("eventweapon:start",function(id,coords,name)
    id = id 
	eventweapon[id] = {weapon = name ,used = false,coords =  vector3(coords.x,coords.y,coords.z - 1),blip = createblip(vector3(coords.x,coords.y,coords.z - 1),567,1,"Event weapon(".. id ..")")}
	Citizen.CreateThread(function()
		while eventweapon[id] ~= nil do
			Wait(1)
			if GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()),eventweapon[id].coords) < 30.0 then
				DrawMarker(1, eventweapon[id].coords, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.5, 1.5, 1.5, 0, 0, 255, 100, false, false, 2, false, nil, nil, false)
					Draw3DText(eventweapon[id].coords.x,eventweapon[id].coords.y,eventweapon[id].coords.z,"Dokme E Jahat Daryaft Gun(".. eventweapon[id].weapon:gsub("weapon_","") ..")",4, 0.1, 0.1)
			end
			if GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()),eventweapon[id].coords) < 2.0 then
				eventindex = id
				eventtype = "weapon"
			elseif eventtype == "weapon" and eventindex == id then
				eventindex = 0
				eventtype = nil
			end
		end
	end)
end)



RegisterNetEvent("eventweapon:stop")
AddEventHandler("eventweapon:stop",function(id)
RemoveBlip(eventweapon[id].blip)
if eventweapon[id].used then
--RELOAD
RemoveAllPedWeapons(GetPlayerPed(-1), 1)
Wait(500)
TriggerServerEvent("sunset_admin:checkweapon")
Wait(500)
TriggerEvent("esx:restoreLoadout")
TriggerEvent('esx_inventoryhud:statedropweapon',true)
end
eventweapon[id] = nil
end)

local carcd = false
AddEventHandler('onKeyUP',function(key)
	if key ~= "e" then return end
	if eventtype ~= nil and eventindex ~= 0 then
		if eventtype == "car" then
			local data = eventcar[eventindex]
			if IsPedInAnyVehicle(PlayerPedId()) then return end
			if not carcd then
				local x, y, z = table.unpack(GetEntityCoords(GetPlayerPed(-1), false))
				local radius = data.range
				local xrand = math.random(1,radius)
				local yrand = math.random(1,radius)
				local randd = math.random(1,2)
				local coords = nil
				if randd == 1 then
					coords = vector3(x + xrand,y + yrand,z)
				else
					 coords = vector3(x - xrand,y - yrand,z)
				end
				local playerPed = PlayerPedId()
				ESX.Game.SpawnVehicle(data.name, coords, GetEntityHeading(playerPed), function(vehicle)
					TaskWarpPedIntoVehicle(playerPed,  vehicle, -1)
					local plate = math.random(100,999)
					ESX.SetVehicleNumberPlateText(vehicle, "EVENT".. eventindex ..plate)
					ESX.giveCarKey(vehicle,true)
					Citizen.Wait(2000)
					exports['sunset_utils']:SetFuel(vehicle, 100.0)
				end)
				carcd = true
				Citizen.SetTimeout(data.cooldown,function()
					carcd = false
				end)
			else
				ESX.ShowNotification("spam nakon :|")
			end
		elseif eventtype == "skin" then
			if eventskin[eventindex].used then
				ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin, jobSkin)
					TriggerEvent('skinchanger:loadSkin', skin)
				end)
				eventskin[eventindex].used = false
			else
				ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin, jobSkin)
					TriggerEvent('skinchanger:loadClothes', skin, eventskin[eventindex].skin)
				end)
				eventskin[eventindex].used = true
			end
		elseif eventtype == "ped" then
			if eventped[eventindex].used then
				ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(LastSkin, jobSkin)
					local model = nil
					if LastSkin.sex == 0 then
						model = 'mp_m_freemode_01'
					else
						model = 'mp_f_freemode_01'
					end
				   TriggerEvent("resetpedHandler",model)
					Wait(1000)
					exports['sunset_clothe']:removeStuffJob()
					Citizen.Wait(1000)
					exports['sunset_clothe']:loadUsed()
					TriggerEvent("esx:restoreLoadout")
			   end)
			   TriggerEvent('suncore:whiteped',true)
			   eventped[eventindex].used = false
		   else          
			   TriggerEvent('suncore:whiteped',false)
			   TriggerEvent('resetpedHandler',eventped[eventindex].ped)
			   eventped[eventindex].used = true
		   end
		elseif eventtype == "weapon" then
			TriggerServerEvent('sunset_admin:dontcheckweapon')
			RemoveAllPedWeapons(GetPlayerPed(-1), 1)
			TriggerEvent('esx_inventoryhud:statedropweapon',false)
			Wait(500)
			TriggerEvent('esx:addWeapon', eventweapon[eventindex].weapon, 250)
			eventweapon[eventindex].used = true
		end
	end

end)

--team
--team
local team = {}
RegisterCommand('createteam',function(source,args)
	ESX.TriggerServerCallback('esx_aduty:getAdminPerm', function(aperm)
		team = {}
		if aperm >= 5 then
			if not tonumber(args[1]) and not tonumber(args[2]) then return end
			local players       = ESX.Game.GetPlayers()
			local coords = GetEntityCoords(PlayerPedId())
			for i=1, #players, 1 do
				local target       = GetPlayerPed(players[i])
				local targetCoords = GetEntityCoords(target)
				local distance     = GetDistanceBetweenCoords(targetCoords, coords.x, coords.y, coords.z, true)
				if distance <= tonumber(args[1]) and players[i] ~= PlayerId() then
					table.insert(team,{id = GetPlayerServerId(players[i])})
				end
			end
			TriggerEvent("chatMessage", "[SYSTEM]", {255, 0, 0}, "^0Tedad a'azai team : ".. tablelength(team), 'alarms')
		else
			TriggerEvent('chat:addMessage', {color = { 255, 0, 0}, multiline = true ,args = {"[SYSTEM]", "^0Shoma dastresi kafi baraye estefade az in dastor ra nadarid!"}}, 'alarms')
		end

	  end)
end)

function tablelength(T)
	local count = 0
	for _ in pairs(T) do count = count + 1 end
	return count
end

RegisterCommand('reviveteam',function(source,args)
	ESX.TriggerServerCallback('esx_aduty:getAdminPerm', function(aperm)
		if aperm >= 5 then
			for k , v in ipairs(team) do
				Wait(50)
				ExecuteCommand("revive ".. v.id)
			end
		else
			TriggerEvent('chat:addMessage', {color = { 255, 0, 0}, multiline = true ,args = {"[SYSTEM]", "^0Shoma dastresi kafi baraye estefade az in dastor ra nadarid!"}}, 'alarms')
		end
	
	  end)
end)

RegisterCommand('bringteam',function(source,args)
	ESX.TriggerServerCallback('esx_aduty:getAdminPerm', function(aperm)
		if aperm >= 5 then
			for k , v in ipairs(team) do
				Wait(100)
				ExecuteCommand("bring ".. v.id)
			end
		else
			TriggerEvent('chat:addMessage', {color = { 255, 0, 0}, multiline = true ,args = {"[SYSTEM]", "^0Shoma dastresi kafi baraye estefade az in dastor ra nadarid!"}}, 'alarms')
		end
	
	  end)
end)
Citizen.CreateThread(function()
TriggerEvent('chat:addSuggestion', '/createteam', 'Create team', {
	{ name="range", help="Range" }
})

TriggerEvent('chat:addSuggestion', '/reviveteam', 'Revive team', {
})

TriggerEvent('chat:addSuggestion', '/bringteam', 'bring team', {
})

end)


--ahmad

ESX                = nil
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

local spawnedpeds = {}

RegisterNetEvent('testped:spawnPed')
AddEventHandler('testped:spawnPed', function(model,weaponname,hp)
	model           = (tonumber(model) ~= nil and tonumber(model) or GetHashKey(model))
	local pedhp = (tonumber(hp) ~= nil and tonumber(hp) or 100)
	local playerPed = PlayerPedId()
	local coords    = GetEntityCoords(playerPed)
	local forward   = GetEntityForwardVector(playerPed)
	local x, y, z   = table.unpack(coords + forward * 1.0)
    
	
	
	Citizen.CreateThread(function()
		RequestModel(model)

		while not HasModelLoaded(model) do
			Citizen.Wait(1)
		end

        local weaponHash = GetHashKey(weaponname)
		--ped = CreatePed(5, model, x, y, z, 0.0, true, false)
		ped = CreatePed('PED_TYPE_SWAT', model, x, y, z, GetEntityHeading(PlayerPedId()), true, false)
        table.insert(spawnedpeds, ped)
        GiveWeaponToPed(ped, weaponHash, 500, false, false)
		GiveWeaponToPed(ped, GetHashKey('weapon_knife'), 1, false, false)
		SetPedCanSwitchWeapon(ped,true)
		SetPedDropsWeaponsWhenDead(ped, false)
		
        SetEntityMaxHealth(ped,pedhp)
		ESX.SetEntityHealth(ped,pedhp)	
		
			SetCanAttackFriendly(ped, true, true)
			SetPedRagdollBlockingFlags(ped, 1); 
			SetPedRagdollBlockingFlags(ped, 2);
			SetPedRagdollBlockingFlags(ped, 3);
			SetPedRagdollBlockingFlags(ped, 4); 			
			SetPedCanRagdollFromPlayerImpact(ped, false)
			SetPedSuffersCriticalHits(ped, false) -- off damage head
			
			
			
			if not NetworkGetEntityIsNetworked(ped) then
				NetworkRegisterEntityAsNetworked(ped)
			end
		--SetPedCombatAbility(testped,2) -- 0 - 1 - 2
		
		--local coords = GetEntityCoords(testped)
		--RequestNetworkControl(testped)
		--SetPedCanSwitchWeapon(testped, true)
		--TaskCombatHatedTargetsInArea(testped, coords.x, coords.y, coords.z, 500)
	end)
end)

RegisterNetEvent('testpedany:spawnPed')
AddEventHandler('testpedany:spawnPed', function(model)
    if model == 'stop' then
	 -- stop fight fear
      for i=1, #spawnedpeds, 1 do
        TaskCower(spawnedpeds[i], 5000)
      end
    elseif model == 'move' then
	 -- move to my lock
    local nerbyPeds2 = GetPedNearbyPeds(GetPlayerPed(-1), -1)
      for i=1, #spawnedpeds, 1 do
        TaskGoToEntity(spawnedpeds[i], GetPlayerPed(-1), -1, 1.0, 10.0, 1073741824.0, 0)
        SetPedKeepTask(spawnedpeds[i], true)
		local coords = GetEntityCoords(spawnedpeds[i])
      end
	elseif model == 'attack' then
	 -- attack from area
	 AddRelationshipGroup("enemies")
	 for i=1, #spawnedpeds, 1 do
		local ped = spawnedpeds[i]
		local coords = GetEntityCoords(ped)
		
			SetRelationshipBetweenGroups(5, GetHashKey("enemies"), GetHashKey("PLAYER"))
            SetRelationshipBetweenGroups(5, GetHashKey("PLAYER"), GetHashKey("enemies"))
            SetRelationshipBetweenGroups(1, GetHashKey("enemies"), GetHashKey("enemies"))
			SetPedRelationshipGroupHash(ped, GetHashKey("enemies"))		
		 
	 end
	ESX.ShowNotification('Tedad'.. #spawnedpeds .. 'Amade Hamle Hastan .' )
	elseif model == 'deleteall' then
	 --delete all
	 ESX.ShowNotification('Tedad'.. #spawnedpeds .. 'Hazf Shod .') 
	 for i=1, #spawnedpeds, 1 do
	  local ped = spawnedpeds[i]
		if DoesEntityExist(ped) then
		 DeleteEntity(ped)
        end
	 end
	 spawnedpeds = {}
    end
end)


--blips
RegisterNetEvent('updateEventBlips',function(data)
	updateBlip(data)
end)

function updateBlip(data)
	local world = ESX.GetPlayerData().World
	if not data then
		local p = promise.new()
		ESX.TriggerServerCallback('event:getEventBlips',function(data)
			p:resolve(data)
		end)
		data = Citizen.Await(p)
	end
	eventBlipThread = false 
	for k,v in pairs(eventBlips) do 
		for k2,v2 in pairs(v) do 
			if v2.blip then
				RemoveBlip(v2.blip)
			end
		end
	end
	eventBlips = {}
	for k,v in pairs(data) do 
		if world == k then
			for k2,v2 in pairs(v) do 
				v2.blip = createblip(v2.coords,58,1,'Event blip('.. k ..'-'.. k2 ..')')
			end
		end
	end
	eventBlips = data
	-- if not eventBlipThread then
	-- 	eventBlipThread = true
	-- 	Citizen.CreateThread(function()
	-- 		local id = math.random(1,1000)
	-- 		eventBlipThreadID = id
	-- 		while eventBlipThread and eventBlipThreadID == id do
	-- 			Citizen.Wait(500)
	-- 			local coords = GetEntityCoords(PlayerPedId())
	-- 			for k,v in pairs(data) do 
	-- 				if world == k then
	-- 					for k2,v2 in pairs(v) do 
	-- 						local distance = ESX.GetDistance(v2.coords,coords)
	-- 						if distance <= 15 and eventBlipCheckPoint ~= k2 then
	-- 							eventBlipCheckPoint = k2
	-- 							Citizen.CreateThread(function()
	-- 								local coords = data[k][k2+1]
	-- 								if coords then
	-- 									coords = coords.coords
	-- 									while eventBlipCheckPoint == k2 do
	-- 										Citizen.Wait(100)
	-- 										SetNewWaypoint(coords.x,coords.y)
	-- 										ESX.ShowMissionText('Next point '.. ESX.Math.Round(ESX.GetDistance(coords,GetEntityCoords(PlayerPedId()))) ..'M')
	-- 									end
	-- 								end
	-- 							end)
	-- 						end
	-- 					end
	-- 				end
	-- 			end
	-- 		end
	-- 	end)
	-- end
end

RegisterNetEvent('esx:changeworld',function(world)
	updateBlip()
	if world == 95 then
		updateGod()
	else
		eventGod.player = false 
		eventGod.vehicle = false 
	end
end)


function updateGod(data)
	local world = ESX.GetPlayerData().World
	if not data then
		local p = promise.new()
		ESX.TriggerServerCallback('event:getEventGod',function(data)
			p:resolve(data)
		end)
		data = Citizen.Await(p)
	end
	eventGod = data 
	if eventGod.vehicle then 
		Citizen.CreateThread(function()
			while eventGod.vehicle do 
				Citizen.Wait(5000)
				local vehicle = ESX.isVehicleDriver()
				if vehicle then 
					ESX.SetVehicleFixed(vehicle)
				end
			end
		end)
	end
end

RegisterNetEvent('updateEventGod',function(data)
	if ESX.GetPlayerData().World == 95 then
		updateGod(data)
	end
end)

AddEventHandler('esx:onPlayerDeath',function()
	if ESX.GetPlayerData().World == 95 and eventGod.player then
		Citizen.Wait(5000)
		TriggerEvent('medic:revive')
	end
end)