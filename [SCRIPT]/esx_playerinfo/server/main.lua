ESX = nil
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

local JStructure = {
	police = {},
	ambulance = {},
	mt = {},
	taxi = {},
	sheriff = {},
	coffee = {},
	fbi = {},
	nightclub = {},
	mechanic = {}
}

local players = {}
local admins = {}

local counts = {
	players = 0,
	admins = '❌',
	police = 0,
	ambulance = 0,
	fbi = 0,
	nightclub = 0,
	mt = 0,
	taxi = 0,
	sheriff = 0,
	coffee = 0,
	mechanic = 0,
	game = true,
	website = false,
	discord = true,

}

ESX.RegisterServerCallback('esx_playerinfo:getInfo', function(source, cb)
	cb(counts)
end)

AddEventHandler('esx:setJob', function(source, njob, ljob)
	local identifier = GetPlayerIdentifier(source)
	local newjob, lastjob = njob.name, ljob.name

	if newjob ~= lastjob then
		players[identifier] = newjob

		if JStructure[newjob] and JStructure[lastjob] then
			JStructure[lastjob][source] = nil
			JStructure[newjob][source] = identifier
			UpdateCounts(false, {lastjob, newjob})
		elseif JStructure[newjob] then
			JStructure[newjob][source] = identifier
			UpdateCounts(false, {newjob})
		elseif JStructure[lastjob] then
			JStructure[lastjob][source] = nil
			UpdateCounts(false, {lastjob})
		end

	end
end)

AddEventHandler('esx:playerLoaded', function(source, xPlayer)
	local job = xPlayer.job.name
	players[xPlayer.identifier] = job
	if JStructure[job] then
	   JStructure[job][xPlayer.source] = xPlayer.identifier
	   UpdateCounts(true, {job})
	else
	   UpdateCounts(true, false)
	end

	if xPlayer.permission_level > 0 then addAdmin(xPlayer) end
end)

AddEventHandler('esx:playerDropped', function(source)
	local _source = source
	if _source then
		local identifier = GetPlayerIdentifier(_source)
		if players[identifier] then
			local job = players[identifier]
			if JStructure[job] then
				JStructure[job][_source] = nil
				players[identifier] = nil
				UpdateCounts(true, {job})
			else
				players[identifier] = nil
				UpdateCounts(true , false)
			end
		end

		if admins[identifier] then
			admins[identifier] =  nil
			counts.admins = counts.admins
		end
	end
end)

function UpdatePing()
	Citizen.CreateThread(function()
		for _, id in pairs(GetPlayers()) do
			local ping = GetPlayerPing(id)
			TriggerClientEvent('status:updatePing', id, ping)
		end

		SetTimeout(5000, UpdatePing)
	end)
end
UpdatePing()

function GetCounts(job)
	if counts[job] then
		return counts[job]
	else
		return 0
	end
end

function GetJob(job)
	if JStructure[job] then
		return JStructure[job]
	else
		return 0
	end
end

function GetAdmins()
	return admins
end

function CountTable(table)
	local count = 0
	for _ in pairs(table) do count = count + 1 end
	return count
end

function UpdateCounts(update, jobs)
	if update then
		counts.players = CountTable(players)
	end

	if jobs then
		for i,v in ipairs(jobs) do
			counts[v] = CountTable(JStructure[v])
		end
	end

end

function addAdmin(xPlayer)
	admins[xPlayer.identifier] = {perm = xPlayer.permission_level, id = xPlayer.source}
	counts.admins = '✅'
end