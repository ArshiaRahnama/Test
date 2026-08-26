frameworkObject = nil

Citizen.CreateThread(function()
	frameworkObject = GetFrameworkObject()
end)

function ExecuteSql(query)
	local IsBusy = true
	local result = nil
	if GarageData.SQL == "oxmysql" then
	    if MySQL == nil then
	        exports.oxmysql:execute(query, function(data)
		  result = data
		  IsBusy = false
	        end)
	    else
	        MySQL.query(query, {}, function(data)
		  result = data
		  IsBusy = false
	        end)
	    end
      
	elseif GarageData.SQL == "ghmattimysql" then
	    exports.ghmattimysql:execute(query, {}, function(data)
	        result = data
	        IsBusy = false
	    end)
	elseif GarageData.SQL == "mysql-async" then   
	    MySQL.Async.fetchAll(query, {}, function(data)
	        result = data
	        IsBusy = false
	    end)
	end
	while IsBusy do
	    Citizen.Wait(0)
	end
	return result
end

Citizen.CreateThread(function()
    frameworkObject = GetFrameworkObject()
    if GarageData.Framework == "esx" then
        frameworkObject.RegisterServerCallback('For5mG-garage:getvehicles2', function(source, cb, gangs, types)
            local src      = source
            local xPlayer  = frameworkObject.GetPlayerFromId(src)
            local gang = xPlayer.gang.name 
            local vehicles = ExecuteSql("SELECT * FROM owned_vehicles WHERE `owner` ='"..gang.."' AND `type` = '"..types.."'")	
            local ownedCars = {}
            for _,v in pairs(vehicles) do   		    
                local vehicle = json.decode(v.vehicle)
                table.insert(ownedCars, {
                    vehicle = vehicle,
                    stored = v.stored, 
                    favorite = v.favorite,
                    garage = 0
                })            
             
            end       
            cb(ownedCars)  
        end)     
    end
end)
Citizen.CreateThread(function()
    frameworkObject = GetFrameworkObject()
    if GarageData.Framework == "esx" then
        frameworkObject.RegisterServerCallback('For5mG-garage:getvehiclebyplate', function(source, cb, plate)
            local src      = source
            local xPlayer  = frameworkObject.GetPlayerFromId(src)
            local gang = xPlayer.gang.name 
            local vehicle = ExecuteSql("SELECT `vehicle` FROM `owned_vehicles` WHERE `plate` = '".. plate .."' AND `owner` = '".. gang .."'")
       
             if vehicle[1] then 
                cb(true) 
             else 
                cb(false)
             end  
        end)     
    end
end)
Citizen.CreateThread(function()
    frameworkObject = GetFrameworkObject()
    if GarageData.Framework == "esx" then
        frameworkObject.RegisterServerCallback('For5mG-garage:getvehicles', function(source, cb, gangs, types)
            local src      = source
            local xPlayer  = frameworkObject.GetPlayerFromId(src)
            local gang = xPlayer.gang.name 
                local result = ExecuteSql("SELECT * FROM owned_vehicles WHERE `owner` = '"..gang.."' AND `type` = '"..types.."'")
                if result[1] then
                    cb(true)
                else
                    cb(false)
                end
        end)        
    end
end)

Citizen.CreateThread(function()
    frameworkObject = GetFrameworkObject()
    if GarageData.Framework == "esx" then
        frameworkObject.RegisterServerCallback('For5mG-garage:vehicleOwned', function(source, cb, plate)
            local src      = source
            local xPlayer = frameworkObject.GetPlayerFromId(src)	
            local vehicle = ExecuteSql("SELECT `vehicle` FROM `owned_vehicles` WHERE `plate` = '"..plate.."' AND `owner` = '"..xPlayer.identifier.."'")
            if next(vehicle) then
                cb(true)
            else
                cb(false)
            end
        end)

    else
        frameworkObject.Functions.CreateCallback('For5mG-garage:vehicleOwned', function(source, cb, plate)
            local src      = source
            local xPlayer =  frameworkObject.Functions.GetPlayer(src)	
            local vehicle = ExecuteSql("SELECT `mods` FROM `player_vehicles` WHERE `plate` = '"..plate.."' AND `citizenid` = '"..xPlayer.PlayerData.citizenid.."'")
            if next(vehicle) then
                cb(true)
            else
                cb(false)
            end
        end)
    end
end)

local vehiclepricetables = {}

Citizen.CreateThread(function()
    Wait(500)
    if GarageData.Framework == "esx" then
        local cars = ExecuteSql("SELECT * FROM vehicles ")
        if cars then 			
            for k,v in pairs(cars) do
                v.hash = GetHashKey(v.model)		
            end
            vehiclepricetables = cars
        end 
    end
end)

Citizen.CreateThread(function()
    if GarageData.Framework == "esx" then
        frameworkObject = GetFrameworkObject()
        frameworkObject.RegisterServerCallback('For5mG-garage:vehicleprice', function(source, cb)	
            cb(vehiclepricetables)
        end)
    end
end)

RegisterServerEvent('For5mG-garage:favorite')
AddEventHandler('For5mG-garage:favorite', function(plate,bool)
    if GarageData.Framework == "esx" then
        ExecuteSql("UPDATE  `owned_vehicles` SET `favorite` = '" .. bool .. "' WHERE `plate` ='"..plate.."'")    
    else
        ExecuteSql("UPDATE  `player_vehicles` SET `favorite` = '" .. bool .. "' WHERE `plate` ='"..plate.."'")    
    end
end)

RegisterServerEvent('For5mG-garage:sell')
AddEventHandler('For5mG-garage:sell', function(plate,price)
    if GarageData.Framework == "esx" then
        if GarageData.Sell then
            local src = source
            local xPlayer = frameworkObject.GetPlayerFromId(src)
            if plate ~= nil then
                local deleted = ExecuteSql("DELETE FROM `owned_vehicles` WHERE `plate` = '"..plate.."' AND `owner` = '"..xPlayer.identifier.."'")
                if deleted then
                    xPlayer.addMoney(price)
                end
            end
        end
    else
        if GarageData.Sell then
            local src = source
            local xPlayer  = frameworkObject.Functions.GetPlayer(source)
            if plate ~= nil then
                local deleted = ExecuteSql("DELETE FROM `player_vehicles` WHERE `plate` = '"..plate.."' AND `citizenid` = '"..xPlayer.PlayerData.citizenid.."'")
                if deleted then
                    xPlayer.Functions.AddMoney('cash', price)
                end
            end
        end
    end
end)

-- Props

RegisterNetEvent('For5mG-garage:saveProps')
AddEventHandler('For5mG-garage:saveProps', function(plate, props)
    local xProps = json.encode(props)
    if GarageData.Framework == "esx" then
        ExecuteSql("UPDATE  `owned_vehicles` SET `vehicle` = '" .. xProps .. "' WHERE `plate` ='"..plate.."'")    
    else
        ExecuteSql("UPDATE  `player_vehicles` SET `mods` = '" .. xProps .. "' WHERE `plate` ='"..plate.."'")    
    end
end)

RegisterNetEvent('For5mG-garage:stored')
AddEventHandler('For5mG-garage:stored', function(plate, state,garage)
    if GarageData.Framework == 'esx' then
   
        ExecuteSql("UPDATE  `owned_vehicles` SET `stored` = '" .. state .. "' WHERE `plate` ='"..plate.."'")   
    else 
        ExecuteSql("UPDATE  `player_vehicles` SET `state` = '" ..state.. "' WHERE `plate` ='"..plate.."'")    
    end
end)

RegisterNetEvent('For5mG-garage:parking')
AddEventHandler('For5mG-garage:parking', function(plate, garage)
    local src = source
    if GarageData.Framework == 'esx' then
        ExecuteSql("UPDATE  `owned_vehicles` SET `parking` = '" ..garage.. "' WHERE `plate` ='"..plate.."'")    
        GarageData.Notification(GarageData.Notifications["parkingsuccesful"].message,GarageData.Notifications["parkingsuccesful"].type, true, src)
    else  
        ExecuteSql("UPDATE  `player_vehicles` SET `parking` = '" ..garage.. "' WHERE `plate` ='"..plate.."'")    
        GarageData.Notification(GarageData.Notifications["parkingsuccesful"].message,GarageData.Notifications["parkingsuccesful"].type, true, src)
    end
end)

RegisterNetEvent('For5mG-garage:fuel')
AddEventHandler('For5mG-garage:fuel', function(plate, fuel)
    if GarageData.Framework == 'esx' then
    
    else 
        ExecuteSql("UPDATE  `player_vehicles` SET `fuel` = '" .. fuel .. "' WHERE `plate` ='"..plate.."'")    
    end
end)

Citizen.CreateThread(function()
    frameworkObject = GetFrameworkObject()
    if GarageData.Framework == "esx" then
        frameworkObject.RegisterServerCallback('For5mG-garage:props', function(source,cb,plate)
            local cars = ExecuteSql("SELECT * FROM owned_vehicles WHERE `plate` ='"..plate.."'")	
            cb(cars)
        end)
    else
        frameworkObject.Functions.CreateCallback('For5mG-garage:props', function(source,cb,plate)
            if plate ~= nil then
                local cars = ExecuteSql("SELECT * FROM player_vehicles WHERE `plate` ='"..plate.."'")	
                cb(cars)
            end
        end)
    end
end)    

Citizen.CreateThread(function()
	frameworkObject = GetFrameworkObject()
	if GarageData.Framework == 'esx' then
        frameworkObject.RegisterServerCallback('For5mGangs-garage:checkMoneyCars', function(source, cb,moneytype)
    		local xPlayer = frameworkObject.GetPlayerFromId(source)
            if moneytype == 'vale' then
                if xPlayer.money >= GarageData.ValePrice then
                    cb(true)
                else
                    cb(false)
                end    
            elseif moneytype == 'repair' then
                if xPlayer.money >= GarageData.RepairPrice then
                    cb(true)
                else
                    cb(false)
                end    
            end
        end)
	else	
		frameworkObject.Functions.CreateCallback('For5mGangs-garage:checkMoneyCars', function(source, cb,moneytype)
			local Player = frameworkObject.Functions.GetPlayer(source)
			local Balance = Player.PlayerData.money[GarageData.ValeMoneyType]
            local Balance2 = Player.PlayerData.money[GarageData.RepairMoneyType]

            if moneytype == 'vale' then
                if Balance >= GarageData.ValePrice then
                    cb(true)
                else
                    cb(false)
                end    
            elseif moneytype == 'repair' then
                if Balance2 >= GarageData.RepairPrice then
                    cb(true)
                else
                    cb(false)
                end    
            end
		end)
	end
end)


local storedsql = 1

AddEventHandler('onResourceStart', function(resource)
    if resource == GetCurrentResourceName() then
        Wait(100)
        if GarageData.Framework == 'esx' then
                ExecuteSql("UPDATE  owned_vehicles SET stored = '" ..storedsql.. "'") 
        else
             ExecuteSql("UPDATE  player_vehicles SET state = '" ..storedsql.. "'")     
        end
    end
end)


RegisterServerEvent('For5mGangs-garage:pay')
AddEventHandler('For5mGangs-garage:pay', function(moneytype)
	if GarageData.Framework == 'esx' then
		local identifier = frameworkObject.GetPlayerFromId(source)
        if moneytype == 'vale' then
            identifier.removeMoney( GarageData.ValePrice)
        elseif moneytype == "repair" then
            identifier.removeMoney( GarageData.RepairPrice)
        end
	else
        local identifier = frameworkObject.Functions.GetPlayer(source)
        if moneytype == 'vale' then
            identifier.Functions.RemoveMoney(GarageData.ValeMoneyType, GarageData.ValePrice)
        elseif moneytype == 'repair' then
            identifier.Functions.RemoveMoney(GarageData.RepairMoneyType, GarageData.RepairPrice)
        end
	end
end)

-- Transfer

RegisterServerEvent('For5mG-garage:transfervehicle')
AddEventHandler('For5mG-garage:transfervehicle', function(id,plate)
	local src = source
    if GarageData.Framework == "esx" then
        if plate ~= nil then
            local xPlayer = frameworkObject.GetPlayerFromId(source)
            local xTarget = frameworkObject.GetPlayerFromId(id)
            if xTarget ~= nil then		
                if id ~= src then
                    local givecar = ExecuteSql("SELECT `vehicle` FROM `owned_vehicles` WHERE `plate` = '"..plate.."' AND `owner` = '"..xPlayer.identifier.."'")
                    if givecar then
                        ExecuteSql("UPDATE  `owned_vehicles` SET `owner` = '" .. xTarget.identifier .. "' WHERE `plate` ='"..plate.."'")    
                        GarageData.Notification(GarageData.Notifications["transfer"].message,GarageData.Notifications["transfer"].type, true, src)
                    else
                        GarageData.Notification(GarageData.Notifications["transfererror"].message,GarageData.Notifications["transfererror"].type, true, src)
                    end
                else
                    GarageData.Notification(GarageData.Notifications["transfererror"].message,GarageData.Notifications["transfererror"].type, true, src)
                end
            else
                GarageData.Notification(GarageData.Notifications["transfererror"].message,GarageData.Notifications["transfererror"].type, true, src)
            end
        end
    else
        if plate ~= nil then
            local xPlayer = frameworkObject.Functions.GetPlayer(source)
            local xTarget = frameworkObject.Functions.GetPlayer(id)
            if xTarget ~= nil then		
                if id ~= src then
                    local givecar = ExecuteSql("SELECT `mods` FROM `player_vehicles` WHERE `plate` = '"..plate.."' AND `citizenid` = '"..xPlayer.PlayerData.citizenid.."'")
                    if givecar then
                        ExecuteSql("UPDATE  `player_vehicles` SET `citizenid` = '" .. xTarget.PlayerData.citizenid .. "' WHERE `plate` ='"..plate.."'")    
                        GarageData.Notification(GarageData.Notifications["transfer"].message,GarageData.Notifications["transfer"].type, true, src)
                    else
                        GarageData.Notification(GarageData.Notifications["transfererror"].message,GarageData.Notifications["transfererror"].type, true, src)
                    end
                else
                    GarageData.Notification(GarageData.Notifications["transfererror"].message,GarageData.Notifications["transfererror"].type, true, src)
                end
            else
                GarageData.Notification(GarageData.Notifications["transfererror"].message,GarageData.Notifications["transfererror"].type, true, src)
            end
        end
    end
end)

Citizen.CreateThread(function()
	frameworkObject = GetFrameworkObject()
    if GarageData.Framework == "esx" then
	    frameworkObject.RegisterServerCallback('For5mGangs-garage:changedCars', function(source, cb, plate)
      
	        local vehicles = GetAllVehicles()
	        plate = frameworkObject.Math.Trim(plate)
	        local found = false
	        for i = 1, #vehicles do                    
		       if frameworkObject.Math.Trim(GetVehicleNumberPlateText(vehicles[i])) == plate:upper() then    

                found = true
                break
		       end
	        end
	        cb(found)
      
	    end)
      
      
	
	end

end)

-- Discord avatar and name

RegisterServerEvent("For5mG-garage:server:getName")
AddEventHandler("For5mG-garage:server:getName", function(src,identifier)
    local src      = source
    if GarageData.Framework == "esx" then
        local xPlayer  = frameworkObject.GetPlayerFromId(src)
        local fullname = xPlayer.name 
        local avatar   = GetDiscordAvatar(src)
        TriggerClientEvent("For5mG-garage:client:getNameAvatar", src ,fullname, avatar)
    else
        local xPlayer  = frameworkObject.Functions.GetPlayer(src)	
        local fullname = xPlayer.PlayerData.charinfo.firstname.. ' '..xPlayer.PlayerData.charinfo.lastname
        local avatar   = GetDiscordAvatar(src)
        TriggerClientEvent("For5mG-garage:client:getNameAvatar", src ,fullname, avatar)
    end
end)

local Caches = {
    Avatars = {}
}

local FormattedToken = "Bot "..GarageData.BotToken

function DiscordRequest(method, endpoint, jsondata)
    local data = nil

    PerformHttpRequest("https://discordapp.com/api/"..endpoint, function(errorCode, resultData, resultHeaders)
        data = {data=resultData, code=errorCode, headers=resultHeaders}
    end, method, #jsondata > 0 and json.encode(jsondata) or "", {["Content-Type"] = "application/json", ["Authorization"] = FormattedToken})

    while data == nil do
        Citizen.Wait(0)
    end

    return data
end

function GetDiscordAvatar(user) 
    local discordId = nil
    local imgURL = nil;

    for _, id in ipairs(GetPlayerIdentifiers(user)) do
        if string.match(id, "discord:") then
            discordId = string.gsub(id, "discord:", "")
            break
        end
    end

    if discordId then 
        if Caches.Avatars[discordId] == nil then 
            local endpoint = ("users/%s"):format(discordId)
            local member = DiscordRequest("GET", endpoint, {})
            if member.code == 200 then
                local data = json.decode(member.data)
                if data ~= nil and data.avatar ~= nil then 
                  
                    if (data.avatar:sub(1, 1) and data.avatar:sub(2, 2) == "_") then 
                     
                        imgURL = "https://cdn.discordapp.com/avatars/" .. discordId .. "/" .. data.avatar .. ".gif";
                    else 
                        imgURL = "https://cdn.discordapp.com/avatars/" .. discordId .. "/" .. data.avatar .. ".png"
                    end
                end
            else 
      --          print("Set it yourself in GarageData line 5")
            end
            Caches.Avatars[discordId] = imgURL;
        else 
            imgURL = Caches.Avatars[discordId];
        end 
    else 
      --  print("[Codem STORE] ERROR: Discord ID was not found...")
    end

    return imgURL;
end