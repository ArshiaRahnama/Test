

local PMA = exports['pma-voice']
local Framework = nil
local Core = nil

if Config.UseRPName then
	if GetResourceState('es_extended') ~= 'missing' then
		Framework = 'ESX'
		Core = exports['es_extended']:getSharedObject()
	elseif GetResourceState('qb-core') ~= 'missing' then
		Framework = 'QB'
		Core = exports['qb-core']:GetCoreObject()
	elseif GetResourceState('JLRP-Framework') ~= 'missing' then
		Framework = 'JLRP'
		Core = exports['JLRP-Framework']:getSharedObject()
	end
end

local CustomNames = {}
local PlayersInCurrentRadioChannel = {}
local CurrentResourceName = GetCurrentResourceName()

AddEventHandler("playerDropped", function()
	local src = source

	local currentRadioChannel = Player(src).state.currentRadioChannel or 0

	local playersInCurrentRadioChannel = CreateFullRadioListOfChannel(currentRadioChannel)
	for _, player in pairs(playersInCurrentRadioChannel) do

			TriggerClientEvent("Brave-RadioList:Client:SyncRadioChannelPlayers", player.Source, src, 0, playersInCurrentRadioChannel)

	end
	playersInCurrentRadioChannel = {}

	if Config.LetPlayersSetTheirOwnNameInRadio and Config.ResetPlayersCustomizedNameOnExit then
		local playerIdentifier = GetIdentifier(src)
		if CustomNames[playerIdentifier] and CustomNames[playerIdentifier] ~= nil then
			CustomNames[playerIdentifier] = nil
		end
	end
end)

RegisterNetEvent('pma-voice:setPlayerRadio')
AddEventHandler('pma-voice:setPlayerRadio', function(channelToJoin)
	local src = source
	local radioChannelToJoin = tonumber(channelToJoin)
	if not radioChannelToJoin then print(('radioChannelToJoin was not a number. Got: %s Expected: Number'):format(type(channelToJoin))) return end
	local currentRadioChannel = Player(src).state.currentRadioChannel or 0
	Player(src).state:set('currentRadioChannel', radioChannelToJoin, false)
	if radioChannelToJoin == 0 then
		Disconnect(src, currentRadioChannel)
	else
		Connect(src, currentRadioChannel, radioChannelToJoin)
	end
end)

function Connect(src, currentRadioChannel, radioChannelToJoin)
	if currentRadioChannel > 0 then
		Disconnect(src, currentRadioChannel)
	end
	Wait(1000)

	local playersInCurrentRadioChannel = CreateFullRadioListOfChannel(radioChannelToJoin)
	for _, player in pairs(playersInCurrentRadioChannel) do
		TriggerClientEvent("Brave-RadioList:Client:SyncRadioChannelPlayers", player.Source, src, radioChannelToJoin, playersInCurrentRadioChannel)
	end
	playersInCurrentRadioChannel = {}
end

function Disconnect(src, currentRadioChannel)
	local playersInCurrentRadioChannel = CreateFullRadioListOfChannel(currentRadioChannel)
	TriggerClientEvent("Brave-RadioList:Client:SyncRadioChannelPlayers", src, src, 0, playersInCurrentRadioChannel)
	for _, player in pairs(playersInCurrentRadioChannel) do
		TriggerClientEvent("Brave-RadioList:Client:SyncRadioChannelPlayers", player.Source, src, 0, playersInCurrentRadioChannel)
	end
	playersInCurrentRadioChannel = {}
end

function CreateFullRadioListOfChannel(RadioChannel)
	local playersInRadio = PMA:getPlayersInRadioChannel(RadioChannel)
	for player, isTalking in pairs(playersInRadio) do
		playersInRadio[player] = {}
		playersInRadio[player].Source = player
		playersInRadio[player].Name = GetPlayerNameForRadio(player)
	end

	return playersInRadio
end

function GetPlayerNameForRadio(source)
	if Config.LetPlayersSetTheirOwnNameInRadio then
		local playerIdentifier = GetIdentifier(source)
		if CustomNames[playerIdentifier] and CustomNames[playerIdentifier] ~= nil then
			return CustomNames[playerIdentifier]
		end
	end

	if Config.UseRPName then
		local name = nil
		if Framework == 'ESX' then
			local xPlayer = Core.GetPlayerFromId(source)
			if xPlayer then
				name = xPlayer.getName()
			end
		elseif Framework == 'QB' then
			local xPlayer = Core.Functions.GetPlayer(source)
			if xPlayer then
				name = xPlayer.PlayerData.charinfo.firstname..' '..xPlayer.PlayerData.charinfo.lastname
			end
		elseif Framework == nil then

			local candidates = GetAllIdentifierCandidates(source)
			if #candidates > 0 and GetResourceState('oxmysql') ~= 'missing' then
				local query = 'SELECT playerName FROM users WHERE identifier = ?'

				for _, candidate in ipairs(candidates) do
					if name ~= nil then break end

					local ok, result = pcall(function()
						return MySQL.scalar.await(query, { candidate })
					end)
					if ok and result and result ~= "" then
						name = result
					end
				end
			end
		end
		if name == nil then
			name = GetPlayerName(source)
		end
		name = name:gsub("_", " ")
		return name
	else
		local name = GetPlayerName(source)
		return name:gsub("_", " ")
	end
end

if Config.LetPlayersSetTheirOwnNameInRadio then
	local commandLength = string.len(Config.RadioListChangeNameCommand)
	local argumentStartIndex = commandLength + 2
	RegisterCommand(Config.RadioListChangeNameCommand, function(source, args, rawCommand)
		local _source = source
		if _source > 0 then
			local customizedName = rawCommand:sub(argumentStartIndex)
			if customizedName ~= "" and customizedName ~= " " and customizedName ~= nil then
				CustomNames[GetIdentifier(_source)] = customizedName
				local currentRadioChannel = Player(_source).state.currentRadioChannel
				if currentRadioChannel and currentRadioChannel > 0 then
					Connect(_source, currentRadioChannel, currentRadioChannel)
				end
			end
		end
	end)
end

function GetIdentifier(source)
	for _, v in ipairs(GetPlayerIdentifiers(source)) do
		if string.match(v, 'license:') then
			local identifier = string.gsub(v, 'license:', '')
			return identifier
		end
	end
end

function GetIdentifierWithPrefix(source)
	for _, v in ipairs(GetPlayerIdentifiers(source)) do
		if string.match(v, 'license:') then
			return v
		end
	end
end

function GetAllIdentifierCandidates(source)
	local candidates = {}
	for _, v in ipairs(GetPlayerIdentifiers(source)) do
		table.insert(candidates, v)
		local stripped = string.match(v, '^[%a%d]+:(.+)$')
		if stripped then
			table.insert(candidates, stripped)
		end
	end
	return candidates
end

ESX = nil

TriggerEvent("esx:getSharedObject", function(obj) ESX = obj end)

ESX.RegisterUsableItem("radio", function(source)
    TriggerClientEvent("radio", source)
end)

ESX.RegisterServerCallback("CheckRadio", function(source, cb)
    local xPlayer = ESX.GetPlayerFromId(source)
    if xPlayer.getInventoryItem("radio").count > 0 then
        cb(true)
    else
        cb(false)
    end
end)

local requests = {}

RegisterCommand('checkfreq', function(source, args)
	local xPlayer = ESX.GetPlayerFromId(source)

	if not args[1] then
		TriggerClientEvent('chatMessage', source, "[SYSTEM] ", {255, 0, 0}, "^0Shoma dar argument aval chizi vared nakardid")
		return
	end

	if not tonumber(args[1]) then
		local input = string.lower(args[1])
		if input == "accept" then
			local identifier = GetPlayerIdentifier(source)
			if requests[identifier] then
				local request = requests[identifier]
				local zPlayer = ESX.GetPlayerFromIdentifier(request.target)
				if zPlayer then
					requests[identifier] = nil
					TriggerClientEvent('chatMessage', source, "[SYSTEM] ", {255, 0, 0}, "^0Darkhast freq check ba movafaghgiat ghabol shod!")
					TriggerClientEvent('chatMessage', zPlayer.source, "[SYSTEM] ", {255, 0, 0}, "^0Radio freqans ^2" .. GetPlayerName(source) .. "^0 ebarat ast az: ^3" .. exports["pma-voice"]:GetRadioChannel(source))
				else
					TriggerClientEvent('chatMessage', source, "[SYSTEM] ", {255, 0, 0}, "^0Kasi ke baraye shoma darkhast freq check ferestade shahr ra tark karde ast!")
				end
			else
				TriggerClientEvent('chatMessage', source, "[SYSTEM] ", {255, 0, 0}, "^0Shoma hich requeste freq checki nadarid!")
			end
		elseif input == "decline" then
			local identifier = GetPlayerIdentifier(source)
			if requests[identifier] then
				requests[identifier] = nil
				TriggerClientEvent('chatMessage', source, "[SYSTEM] ", {255, 0, 0}, "^0Darkhast freq check shoma ba movafaghiat baste shod!")
			else
				TriggerClientEvent('chatMessage', source, "[SYSTEM] ", {255, 0, 0}, "^0Shoma hich requeste freq checki nadarid!")
			end
		else
			TriggerClientEvent('chatMessage', source, "[SYSTEM] ", {255, 0, 0}, "^0Syntax vared shode eshtebah ast!")
			return
		end
		return
	end

	local target = tonumber(args[1])

	if target == source then
		TriggerClientEvent('chatMessage', source, "[SYSTEM] ", {255, 0, 0}, "^0Shoma nemitavanid be khodetan darkhast freq check befrestid!")
		return
	end

	local name = GetPlayerName(target)

	if not name then
		TriggerClientEvent('chatMessage', source, "[SYSTEM] ", {255, 0, 0}, "^0ID vared shode eshtebah ast!")
		return
	end
	local identifier = GetPlayerIdentifier(target)

	if requests[identifier] then
		TriggerClientEvent('chatMessage', source, "[SYSTEM] ", {255, 0, 0}, "^0In player yek darkhast check freq darad!")
		return
	end

	local coords = GetEntityCoords(GetPlayerPed(source))
	local tcoords = GetEntityCoords(GetPlayerPed(target))
	local distance = getDistance(coords, tcoords)
	if distance < 1 then
		requests[identifier] = {time = os.time(), target = GetPlayerIdentifier(source)}
		TriggerClientEvent('chatMessage', source, "[SYSTEM] ", {255, 0, 0}, "^0Darkhast freq check ba ^2movafaghiat ^0 be ^3" .. name  .. "^0 ferestade shod!")
		TriggerClientEvent('chatMessage', target, "[SYSTEM] ", {255, 0, 0}, "^0Shoma yek darkhast freq check az ^2" .. GetPlayerName(source) .. "^0 daryaft kardid! (checkfreq accept)")
	else
		TriggerClientEvent('chatMessage', source, "[SYSTEM] ", {255, 0, 0}, "^0Fasele shoma az player mored niaz ziad ast!")
	end
end, false)

function getDistance(objA, objB)
    local xDist = objB.x - objA.x
    local yDist = objB.y - objA.y

    return math.sqrt( (xDist ^ 2) + (yDist ^ 2) )
end

function requestCheck()
	for k,v in pairs(requests) do
		if os.time() - v.time >= 120 then
			local xPlayer = ESX.GetPlayerFromIdentifier(k)
			if xPlayer then TriggerClientEvent('chatMessage', xPlayer.source, "[SYSTEM] ", {255, 0, 0}, "^0Darkhast ^2freq check ^0shoma ^1monghazi^0 shod!") end
			requests[k] = nil
		end
	end
	SetTimeout(15000, requestCheck)
end
requestCheck()