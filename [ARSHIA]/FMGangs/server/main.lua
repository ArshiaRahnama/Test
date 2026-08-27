ESX = nil 
local cuffTime = {}
local uncuffTime = {}
TriggerEvent(Config.ESX, function(obj) ESX = obj end)
-------------------------
----- ADMIN CMD 
-------------------------
RegisterCommand(Config.OPENPANELCMD, function(source, args)
    if IsPlayerCanOpenPanel(source) then
        local AdminInfo = {
            Name =  GetAdminName(source) ,
            Rank =  GetAdminRank(source)  ,
            Profile = GetAvatar(source) , 
        }
        TriggerClientEvent('For5M:OpenPanel', source, AdminInfo)
    end
end)
RegisterCommand(Config.ADDXPCMD, function(source, args)
    if IsPlayerCanOpenPanel(source) then
        if args[1] and tonumber(args[2]) then 
            TriggerEvent('For5M:AddGangXP', tonumber(args[2]),args[1] ) 
        end 
    end
end)
RegisterCommand(Config.REMOVEXPCMD, function(source, args)
    if IsPlayerCanOpenPanel(source) then
        if args[1] and tonumber(args[2]) and Gangs[args[1]] then 
            TriggerEvent('For5M:AddGangXP', tonumber(args[2]) * -1 ,args[1] ) 
        end 
    end
end)
function GetAvatar(user)
    local url = ''
    local steamhex
    for _, id in ipairs(GetPlayerIdentifiers(user)) do
        if string.match(id, "steam:") then
            steamhex = id
            break
        end
    end
    if not steamhex then
        return Config.DefaultAvatar
    end
    local steamhex2 = tonumber(steamhex:gsub("steam:", ""), 16)
    local steamkey = Config.SteamWebApiKey
    local steamid = string.format("https://api.steampowered.com/ISteamUser/GetPlayerSummaries/v0002/?key=%s&steamids=%s", steamkey, tostring(steamhex2))
    steamid = GetInfoFromSteam(steamid)
    if steamid and type(steamid) == "table" and steamid.code == 200 then
        url = json.decode(steamid.data).response.players[1].avatarfull
        return url
    end
    return Config.DefaultAvatar
end

function GetInfoFromSteam(web)
    local data = nil
    local jsondata = {}
    PerformHttpRequest(web, function(errorCode, resultData, resultHeaders)
        data = { data = resultData, code = errorCode, headers = resultHeaders }
    end, "GET", #jsondata > 0 and json.encode(jsondata) or "", { ["Content-Type"] = "application/json" })
    local t = GetGameTimer()
    while data == nil and GetGameTimer() - t <= 5000 do
        Wait(10)
    end
    return data
end

RegisterServerEvent('For5M:cuff')
AddEventHandler('For5M:cuff', function(targetid, playerheading, playerCoords,  playerlocation)
    if not tonumber(targetid) or not  ESX.GetPlayerFromId(targetid) then return end 
	if #(GetEntityCoords(GetPlayerPed(source)) - GetEntityCoords(GetPlayerPed(targetid))) >= 5 then return end
	TriggerClientEvent('For5M:Actions:getarrested', targetid, playerheading, playerCoords, playerlocation, source)
	TriggerClientEvent('For5M:Actions:doarrested', source)
end)

RegisterServerEvent('For5M:uncuff')
AddEventHandler('For5M:uncuff', function(targetid, playerheading, playerCoords,  playerlocation)
    if not tonumber(targetid) or not  ESX.GetPlayerFromId(targetid) then return end 
	if #(GetEntityCoords(GetPlayerPed(source)) - GetEntityCoords(GetPlayerPed(targetid))) >= 5 then return end
	TriggerClientEvent('For5M:Actions:getuncuffed', targetid, playerheading, playerCoords, playerlocation, source)
	TriggerClientEvent('For5M:Actions:douncuffing', source)
end)

RegisterServerEvent('F5M:putInVehicle')
AddEventHandler('F5M:putInVehicle', function(target)
	local cPlayer = ESX.GetPlayerFromId(target)
	if GetPlayerName(target) or cPlayer then
		if #(GetEntityCoords(GetPlayerPed(source)) - GetEntityCoords(GetPlayerPed(tonumber(target)))) < 15.0 then
            TriggerClientEvent('F5M:putInVehicle', target)
            TriggerClientEvent("For5M:putInVehicleS", source)
		end
	end
end)

RegisterServerEvent('For5M:drag')
AddEventHandler('For5M:drag', function(target)
	TriggerClientEvent('For5M:drag', target, source)
	TriggerClientEvent('For5M:Actions:draging', source, target)
end)

RegisterServerEvent('For5M:putInVehicle')
AddEventHandler('For5M:putInVehicle', function(target, NetID)
	TriggerClientEvent('For5M:putInVehicleS', source)
	TriggerClientEvent('For5M:putInVehicle', target, NetID)
end)

RegisterServerEvent('For5M:OutVehicle')
AddEventHandler('For5M:OutVehicle', function(target)
    TriggerClientEvent('For5M:OutVehicle', target)
end)

RegisterServerEvent('For5M:SendLog')
AddEventHandler('For5M:SendLog', function(source , category , Text  )
    local identifierlist = ExtractIdentifiers(source) 
	local xPlayer = ESX.GetPlayerFromId(source)
    local data = {}
    data.playerid = source 
    data.identifier = identifierlist.steam 
    data.discord =  identifierlist.discord 
    data.category = category  
    data.Text = Text 
    data.gang = xPlayer.gang.name 
    data.IconURL = Gangs[ xPlayer.gang.name ].logo  
    data.Webhook = Gangs[ xPlayer.gang.name ].webhook   
    SendLog(data)
end)
function SendLog(data)
	local color = '65352'
	local category = data.category
    local DiscordStart = data.Webhook
    local connect = {
        {
            ["color"] = color ,
            ["title"] = category ,
            ["description"] = '**Action:** '.. data.Text  ..'\n\n**ID:** '.. data.playerid ..'\n**Identifier:** '.. data.identifier ..'\n**Discord:** '..data.discord,
	        ["footer"] = {
                ["text"] = data.gang ..' - Logs',
                ["icon_url"] = data.IconURL , 
            },
        }
    }
    PerformHttpRequest(DiscordStart, function(err, text, headers) end, 'POST', json.encode({username = "Heta RP",embeds = connect}), { ['Content-Type'] = 'application/json' })
end 




-------------------------- IDENTIFIERS

function ExtractIdentifiers(id)
    local identifiers = {
        steam = "",
        ip = "",
        discord = "",
        license = "",
        xbl = "",
        live = ""
    }

    for i = 0, GetNumPlayerIdentifiers(id) - 1 do
        local playerID = GetPlayerIdentifier(id, i)

        if string.find(playerID, "steam") then
            identifiers.steam = playerID
        elseif string.find(playerID, "ip") then
            identifiers.ip = playerID
        elseif string.find(playerID, "discord") then
            identifiers.discord = playerID
        elseif string.find(playerID, "license") then
            identifiers.license = playerID
        elseif string.find(playerID, "xbl") then
            identifiers.xbl = playerID
        elseif string.find(playerID, "live") then
            identifiers.live = playerID
        end
    end

    return identifiers
end
