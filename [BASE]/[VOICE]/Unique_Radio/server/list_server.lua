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
				local currentRadioChannel = Player(_source).state.currentRadioChannel or 0
				if currentRadioChannel > 0 then
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