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
-------------------------------------------------------------------
-- FIX (openpanel lag): the old GetAvatar() did a *synchronous* Steam
-- API call (PerformHttpRequest + a busy `while data == nil do Wait(10) end`
-- loop, up to 5000ms) EVERY time a panel/callback needed an avatar.
-- GetPanelData() called this once per ONLINE gang member, so opening
-- the panel with e.g. 10 online members could block the callback for
-- several seconds (or up to 10x5s if Steam was slow/unreachable).
--
-- Fix: fetch avatars asynchronously in the background, cache them per
-- identifier, and refresh the cache on connect/spawn. GetAvatar(source)
-- now just reads the cache and returns instantly - no more blocking,
-- no more repeated HTTP calls on every panel open.
-------------------------------------------------------------------
local AvatarCache = {} -- [identifierHex] = avatarUrl

local function FetchAvatarAsync(identifierHex, cb)
    if not identifierHex or identifierHex == '' then
        if cb then cb(Config.DefaultAvatar) end
        return
    end

    local steamhex2 = tonumber(identifierHex:gsub("steam:", ""), 16)
    local steamkey = Config.SteamWebApiKey
    local url = string.format("https://api.steampowered.com/ISteamUser/GetPlayerSummaries/v0002/?key=%s&steamids=%s", steamkey, tostring(steamhex2))

    PerformHttpRequest(url, function(errorCode, resultData, resultHeaders)
        local avatar = Config.DefaultAvatar
        if errorCode == 200 and resultData then
            local ok, decoded = pcall(json.decode, resultData)
            if ok and decoded and decoded.response and decoded.response.players and decoded.response.players[1] then
                avatar = decoded.response.players[1].avatarfull or Config.DefaultAvatar
            end
        end
        AvatarCache[identifierHex] = avatar
        if cb then cb(avatar) end
    end, "GET", "", { ["Content-Type"] = "application/json" })
end

-- Kicks off (or refreshes) a background fetch for this player and caches
-- it. Non-blocking - does not return the avatar, just warms the cache.
function PrefetchAvatar(source)
    local steamhex
    for _, id in ipairs(GetPlayerIdentifiers(source)) do
        if string.match(id, "steam:") then
            steamhex = id
            break
        end
    end
    if not steamhex then return end
    FetchAvatarAsync(steamhex)
end

-- Instant, non-blocking read. Returns the cached avatar if we have one,
-- otherwise the default avatar - and kicks off a background fetch so the
-- NEXT call already has it cached. Never blocks the calling thread.
function GetAvatar(user)
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
    if AvatarCache[steamhex] then
        return AvatarCache[steamhex]
    end
    -- Not cached yet (e.g. very first call before onPlayerJoin ran) -
    -- warm the cache for next time, but don't block this call on it.
    FetchAvatarAsync(steamhex)
    return Config.DefaultAvatar
end

-- Warm the cache as soon as possible after connect, well before anyone
-- opens a panel, so panel opens never wait on Steam at all.
AddEventHandler('playerConnecting', function()
    local src = source
    CreateThread(function()
        Wait(1500) -- allow identifiers to populate
        PrefetchAvatar(src)
    end)
end)

RegisterNetEvent(Config.DefaultEvents['playerLoaded'])
AddEventHandler(Config.DefaultEvents['playerLoaded'], function()
    PrefetchAvatar(source)
end)

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
    if DiscordStart and DiscordStart ~= '' then
        PerformHttpRequest(DiscordStart, function(err, text, headers) end, 'POST', json.encode({username = "Heta RP",embeds = connect}), { ['Content-Type'] = 'application/json' })
    end

    -- همون لاگ عیناً به سایت خودمون هم فرستاده میشه تا هیچی گم نشه
    local ok = pcall(function() exports['logs']:SendToSite('gang_' .. tostring(data.gang), category, data.Text, data.playerid) end)
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
