

ESX = nil
gangs = {}
local Gangs = {}

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

AddEventHandler('onResourceStart', function(resourceName)
  if (GetCurrentResourceName() == resourceName) then
     Wait(2000)
     local xPlayers = ESX.GetPlayers()
       for i=1, #xPlayers, 1 do
         local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
           if xPlayer then
            xPlayer.setGang(xPlayer.gang.name, xPlayer.gang.grade)
			TriggerClientEvent('gangprop:updateBlip', -1)
           end
       end
   end
end)

RegisterNetEvent('gangprop:forceBlip')
AddEventHandler('gangprop:forceBlip', function()
	TriggerClientEvent('gangprop:updateBlip', -1)
end)

ESX.RegisterServerCallback('gangprop:getOnlinePlayers', function(source, cb)
	local xPlayers = ESX.GetPlayers()
	local players  = {}

	for i=1, #xPlayers, 1 do
		local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
		table.insert(players, {
			source     = xPlayer.source,
			identifier = xPlayer.identifier,
			name       = xPlayer.name,
			gang       = xPlayer.gang
		})
	end

	cb(players)
end)

RegisterServerEvent('gangprop:giveWeapon')
AddEventHandler('gangprop:giveWeapon', function(weapon, ammo)
    local xPlayer = ESX.GetPlayerFromId(source)
    xPlayer.addWeapon(weapon, ammo)
end)

RegisterServerEvent("gangprop:setArmor")
AddEventHandler("gangprop:setArmor", function()
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)

	MySQL.Async.fetchAll('SELECT price FROM gangs_data WHERE gang_name = @gang', {
        ['@gang'] = xPlayer.gang.name,
    }, function(result)
        if #result then
        local price = tonumber(result[1]["price"])


			if xPlayer.canAfford(price) then
				xPlayer.payAny(price)
				TriggerClientEvent('setArmorHandler', _source)
				TriggerClientEvent('chatMessage', _source, "[SYSTEM]", {255, 0, 0}, " ^0Shoma ba movafaghiat armor poshidid!")

			else
				TriggerClientEvent('chatMessage', _source, "[SYSTEM]", {255, 0, 0}, " ^0Shoma pol kafi baraye kharid jelighe zed golule nadarid gheymat jelighe ^2$" ..price.. " ^0ast!")
			end
		end
	end)
end)

RegisterServerEvent("gangprop:setArmorMakhfi")
AddEventHandler("gangprop:setArmorMakhfi", function()
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)

	MySQL.Async.fetchAll('SELECT price FROM gangs_data WHERE gang_name = @gang', {
        ['@gang'] = xPlayer.gang.name,
    }, function(result)
        if #result then
        local price = tonumber(result[1]["price"])


			if xPlayer.canAfford(price+2000) then
				xPlayer.payAny(price)
				TriggerClientEvent('setArmorHandlerMakhfi', _source)
				TriggerClientEvent('chatMessage', _source, "[SYSTEM]", {255, 0, 0}, " ^0Shoma ba movafaghiat armor poshidid!")

			else
				TriggerClientEvent('chatMessage', _source, "[SYSTEM]", {255, 0, 0}, " ^0Shoma pol kafi baraye kharid jelighe zed golule nadarid gheymat jelighe ^2$" ..price.. " ^0ast!")
			end
		end
	end)
end)

ESX.RegisterServerCallback('gangprop:carAvalible', function(source, cb, plate)
	Citizen.Wait(math.random(10,1500))
  exports.oxmysql:scalar('SELECT `stored` FROM `owned_vehicles` WHERE plate = @plate', {
    ['@plate']  = plate
  }, function(stored)
    if tonumber(stored) == 1 then
      cb(true)
    else
      cb()
    end
  end)
end)

ESX.RegisterServerCallback('gangprop:getCars', function(source, cb)
	local ownedCars = {}
  local xPlayer = ESX.GetPlayerFromId(source)

  MySQL.Async.fetchAll('SELECT * FROM `owned_vehicles` WHERE LOWER(owner) = @gang AND type = \'car\' AND @stored = @stored', {
    ['@player']  = xPlayer.identifier,
    ['@gang']    = string.lower(xPlayer.gang.name),
    ['@stored']  = true
  }, function(data)
    for _,v in pairs(data) do
      local vehicle = json.decode(v.vehicle)

      if tonumber(v.stored) == 1 then
        table.insert(ownedCars, {vehicle = vehicle, stored = true  , plate = v.plate, damage = v.damage, engine = v.engine})
      else
        table.insert(ownedCars, {vehicle = vehicle, stored = false , plate = v.plate, damage = v.damage, engine = v.engine})
      end
    end
    cb(ownedCars)
  end)
end)

ESX.RegisterServerCallback('gangprop:getOwnedAircrafts', function(source, cb)
	local ownedCars = {}
  local xPlayer = ESX.GetPlayerFromId(source)

  MySQL.Async.fetchAll('SELECT * FROM `owned_vehicles` WHERE LOWER(owner) = @gang AND type = \'heli\' AND @stored = @stored', {
    ['@player']  = xPlayer.identifier,
    ['@gang']    = string.lower(xPlayer.gang.name),
    ['@stored']  = true
  }, function(data)
    for _,v in pairs(data) do
      local vehicle = json.decode(v.vehicle)
      if tonumber(v.stored) == 1 then
        table.insert(ownedCars, {vehicle = vehicle, stored = true  , plate = v.plate, damage = v.damage})
      else
        table.insert(ownedCars, {vehicle = vehicle, stored = false , plate = v.plate, damage = v.damage})
      end
    end
    cb(ownedCars)
  end)
end)

ESX.RegisterServerCallback('gangprop:getOwnedBoats', function(source, cb)
	local ownedCars = {}
  local xPlayer = ESX.GetPlayerFromId(source)

  MySQL.Async.fetchAll('SELECT * FROM `owned_vehicles` WHERE LOWER(owner) = @gang AND type = \'boat\' AND @stored = @stored', {
    ['@player']  = xPlayer.identifier,
    ['@gang']    = string.lower(xPlayer.gang.name),
    ['@stored']  = true
  }, function(data)
    for _,v in pairs(data) do
      local vehicle = json.decode(v.vehicle)
      if tonumber(v.stored) == 1 then
        table.insert(ownedCars, {vehicle = vehicle, stored = true  , plate = v.plate, damage = v.damage})
      else
        table.insert(ownedCars, {vehicle = vehicle, stored = false , plate = v.plate, damage = v.damage})
      end
    end
    cb(ownedCars)
  end)
end)

RegisterServerEvent('gangprop:messagex')
AddEventHandler('gangprop:messagex', function(target, msg)
	TriggerClientEvent('esx:showNotification', target, msg)
end)

ESX.RegisterServerCallback('gangprop:getPlayerInventory', function(source, cb)

        local xPlayer = ESX.GetPlayerFromId(source)
        local items   = xPlayer.inventory

         cb({
            items = items,
            dirty_money = xPlayer.dirty_money
        })

 end)

RegisterCommand("g", function(source, args)
	local xPlayers = ESX.GetPlayers()
	for i=1, #xPlayers, 1 do
		local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
		local zPlayer = ESX.GetPlayerFromId(source)
		local message = table.concat(args, " ")
		if args[1] then
			if xPlayer then
				if zPlayer.gang.name ~= "nogang" then
					if xPlayer.gang.name == zPlayer.gang.name then
						TriggerClientEvent("chatMessage", xPlayer.source,"^4[^1Gang Chat^4]",{255, 0, 0},"^3( " .. xPlayer.gang.name .. " | " .. zPlayer.name .. " )^0: ^0^*" .. message .. "^4")
					end
				else
					TriggerClientEvent("chatMessage", source, "[SYSTEM]", {255, 0, 0}, " ^0Shoma nemitavanid az in command estefade konid!")
				end
			end
		else
			TriggerClientEvent("chatMessage", source, "[SYSTEM]", {255, 0, 0}, " ^0Shoma Nemitavanid Matn Khali Ersal Konid!")
		end
	end
end)

ESX.RegisterServerCallback('esx_best:getBlips', function(source, cb)
	MySQL.Async.fetchAll('SELECT blip, expire_time FROM `gangs_data` WHERE blip IS NOT NULL AND `expire_time` > NOW()', {}, function(data)
    cb(data)
  end)
end)

ESX.RegisterServerCallback("gangprop:GetPedHandsUpStatus", function(source, cb, ID)
	local Dead = true
	local Injure = true
	local IsCuffed = true
	local xPlayer = ESX.GetPlayerFromId(tonumber(ID))
	if xPlayer.get("Injure") == nil then Injure = false end
	if xPlayer.get("Injure") == false then Injure = false end
	if xPlayer.get("Injure") ~= false then Injure = true end
	if xPlayer.get("IsDead") == nil then Dead = false end
	if xPlayer.get("IsDead") == false then Dead = false end
	if xPlayer.get("IsDead") ~= false then Dead = true end
	if xPlayer.get("Cuff") == nil then IsCuffed = false end
	if xPlayer.get("Cuff") == false then IsCuffed = false end
	cb(IsCuffed, Injure, Dead)
end)

RegisterServerEvent('gangprop:requestarrest')
AddEventHandler('gangprop:requestarrest', function(targetid, playerheading, playerCoords, playerlocation, front)
	local source = source
	local xPlayer = ESX.GetPlayerFromId(source)
	local cPlayer = ESX.GetPlayerFromId(targetid)
	if not GetPlayerName(targetid) or not cPlayer then
		return
	end
	if xPlayer.gang.name ~= "nogang" then
		if #(GetEntityCoords(GetPlayerPed(source)) - GetEntityCoords(GetPlayerPed(tonumber(targetid)))) < 15.0 then
			if not cPlayer.get("Cuff") then
				TriggerClientEvent("gangprop:getarrested", targetid, playerheading, playerCoords, playerlocation, true, front)
				TriggerClientEvent("gangprop:doarrested", source, front)
			else
				TriggerClientEvent('esx:showNotification', source, '~y~In Player Az Ghabl Dastband Khorde Ast.')
			end
		else

		end
	else

	end
end)

RegisterServerEvent('gangprop:SetCuffStatus')
AddEventHandler('gangprop:SetCuffStatus', function(status)
	local source = source
	local xPlayer = ESX.GetPlayerFromId(source)
	xPlayer.set('Cuff', status)
end)

RegisterServerEvent('gangprop:requestrelease')
AddEventHandler('gangprop:requestrelease', function(targetid, playerheading, playerCoords, playerlocation)
	local source = source
	local xPlayer = ESX.GetPlayerFromId(source)
	local cPlayer = ESX.GetPlayerFromId(targetid)
	if not GetPlayerName(targetid) or not cPlayer then
		return
	end
	if xPlayer.job.name == "police" or xPlayer.job.name == "sheriff" or xPlayer.job.name == "fbi" or xPlayer.job.name == "mt" or xPlayer.job.name == "forces" or xPlayer.job.name == "cid" or xPlayer.job.name == "cia" or xPlayer.job.name == "marshal" or xPlayer.job.name == "judge" or xPlayer.job.name == "doa" or xPlayer.gang.name ~= "nogang" then
		if #(GetEntityCoords(GetPlayerPed(source)) - GetEntityCoords(GetPlayerPed(tonumber(targetid)))) < 15.0 then
			if cPlayer.get("Cuff") then

				TriggerClientEvent("gangprop:getuncuffed", targetid, playerheading, playerCoords, playerlocation)
				TriggerClientEvent("gangprop:douncuffing", source)

			else
				TriggerClientEvent('esx:showNotification', source, '~y~In Player Dastband Nakhorde Ast')
			end
		else
			exports.Mid_BanSystem:BanThis(source, "Tried To Cuff Players With Cheat", 500)
		end
	else
		exports.Mid_BanSystem:BanThis(source, "Tried To Cuff Players With Cheat", 500)
	end
end)

RegisterServerEvent('gangprop:drag')
AddEventHandler('gangprop:drag', function(target)
	local cPlayer = ESX.GetPlayerFromId(target)
	if GetPlayerName(target) or cPlayer then
		if #(GetEntityCoords(GetPlayerPed(source)) - GetEntityCoords(GetPlayerPed(tonumber(target)))) < 20.0 then
			if cPlayer.get("Cuff") then


				TriggerClientEvent('gangprop:drag', target, source)
				TriggerClientEvent('gangprop:draging', source)
			else
				TriggerClientEvent('esx:showNotification', source, '~y~Fard Mored Nazar Baraye Drag Kardan Dastband Nakhorde Ast.')
			end
		else
		end
	end
end)

RegisterServerEvent('gangprop:putInVehicle')
AddEventHandler('gangprop:putInVehicle', function(target)
	local cPlayer = ESX.GetPlayerFromId(target)

	local playerPed = GetPlayerPed(source)
    local playerCoords = GetEntityCoords(playerPed)
    local vehicles = GetGamePool('CVehicle')
    local closestVehicle = nil
    local closestDistance = nil

	if GetPlayerName(target) or cPlayer then
		if #(GetEntityCoords(GetPlayerPed(source)) - GetEntityCoords(GetPlayerPed(tonumber(target)))) < 15.0 then
			if cPlayer.get("Cuff") then

				for _, vehicle in ipairs(vehicles) do
					local vehicleCoords = GetEntityCoords(vehicle)
					local distance = #(playerCoords - vehicleCoords)

					if closestDistance == nil or distance < closestDistance then
						closestDistance = distance
						if distance < 3 then

							TriggerClientEvent('gangprop:putInVehicle', target)
							TriggerClientEvent("gangprop:draging", source)
							return
						else
							TriggerClientEvent('esx:showNotification', source, '~y~Mashini Nazdik Shoma Nist.')
						end
					end
				end

			else
				TriggerClientEvent('esx:showNotification', source, '~y~Fard Mored Nazar Baraye Vared Kardan Dar Mashin Dastband Nakhorde Ast.')
			end
		else
		end
	end
end)

RegisterServerEvent('gangprop:OutVehicle')
AddEventHandler('gangprop:OutVehicle', function(target)
	local cPlayer = ESX.GetPlayerFromId(target)
	if GetPlayerName(target) or not cPlayer then
		if #(GetEntityCoords(GetPlayerPed(source)) - GetEntityCoords(GetPlayerPed(tonumber(target)))) < 15.0 then
			if cPlayer.get("Cuff") then

				TriggerClientEvent('gangprop:OutVehicle', target)
			else
				TriggerClientEvent('esx:showNotification', source, '~y~Fard Mored Nazar Baraye Kharej Kardan Az Mashin Dastband Nakhorde Ast.')
			end
		else

		end
	end
end)