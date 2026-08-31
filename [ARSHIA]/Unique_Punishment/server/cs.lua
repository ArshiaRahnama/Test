ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

-- Tracks who's currently serving CS (source -> true) so the containment
-- watchdog below only checks players who are actually supposed to be at
-- Config.ServiceLocation. Populated when a sentence starts/resumes, cleared
-- on release or disconnect.
ActiveCS = {}

TriggerEvent('es:addAdminCommand', 'cs', 1, function(source, args, user)
    if args[1] and GetPlayerName(args[1]) ~= nil and tonumber(args[2]) then
        local targetId = tonumber(args[1])
        local count = tonumber(args[2])
        local reason = table.concat(args, " ", 3)


        local xAdmin = ESX.GetPlayerFromId(source)
        local adminSteamHex = xAdmin and xAdmin.identifier
        local adminSteamName = GetPlayerName(source)
        local adminPlayerName = xAdmin and xAdmin.get('name')
        local adminID = source


        local xTarget = ESX.GetPlayerFromId(targetId)
        local targetSteamHex = xTarget and xTarget.identifier
        local targetSteamName = GetPlayerName(targetId)
        local targetPlayerName = xTarget and xTarget.get('name')
        local targetID = targetId


        local currentTimestamp = os.date("%Y-%m-%d %H:%M:%S")
        local unixTimestamp = os.time()


        TriggerEvent('esx_communityGGservice:sendToCommunityService', targetId, count, reason)


        local webhook = "PUT_YOUR_DISCORD_WEBHOOK_URL_HERE"
        local message = {
            embeds = {{
                title = "Community Service Log",
                description = string.format("**Admin Information:**\n- **Name:** %s\n- **Steam Name:** %s\n- **Steam Hex:** %s\n- **ID:** %d\n\n**Player Information:**\n- **Name:** %s\n- **Steam Name:** %s\n- **Steam Hex:** %s\n- **ID:** %d\n\n**Details:**\n- **Count:** %d\n- **Reason:** %s\n\n**Timestamp:** %s\n**Unix Time:** %d",
                    adminPlayerName, adminSteamName, adminSteamHex, adminID,
                    targetPlayerName, targetSteamName, targetSteamHex, targetID,
                    count, reason, currentTimestamp, unixTimestamp),
                color = 16711680,
                footer = {
                    text = "Community Service Log",
                    icon_url = "https://your-footer-icon-url.com/icon.png"
                },
                timestamp = os.date('!%Y-%m-%dT%H:%M:%SZ')
            }}
        }

        PerformHttpRequest(webhook, function(err, text, headers) end, 'POST', json.encode(message), { ['Content-Type'] = 'application/json' })
    elseif not tonumber(args[1]) and args[2] and table.concat(args, " ", 3) then
        TriggerEvent('esx_communityGGservice:sendToCommunityServiceoffline', args[1], tonumber(args[2]), table.concat(args, " ", 3))
    else
        TriggerClientEvent('chat:addMessage', source, { args = { "System", "Id Vared Shode Ys Steam Hex Eshtebah Ast Ya Tedad Vared nakardid!" } })
    end
end, function(source, args, user)
    TriggerClientEvent('chat:addMessage', source, { args = { _U('system_msn'), _U('insufficient_permissions') } })
end, {help = "Comserv Zadan Player", params = {{name = "id/hex", help = "ID Ya SteamHex"}, {name = "count", help = "Tedad"}, {name = "Reason", help = "Dalil"}}})

TriggerEvent('es:addAdminCommand', 'uncs', 8, function(source, args, user)
    if args[1] then
        if GetPlayerName(args[1]) ~= nil then
            local targetId = tonumber(args[1])


            local xAdmin = ESX.GetPlayerFromId(source)
            local adminSteamHex = xAdmin and xAdmin.identifier
            local adminSteamName = GetPlayerName(source)
            local adminPlayerName = xAdmin and xAdmin.get('name')
            local adminID = source


            local xTarget = ESX.GetPlayerFromId(targetId)
            local targetSteamHex = xTarget and xTarget.identifier
            local targetSteamName = GetPlayerName(targetId)
            local targetPlayerName = xTarget and xTarget.get('name')
            local targetID = targetId


            local currentTimestamp = os.date("%Y-%m-%d %H:%M:%S")
            local unixTimestamp = os.time()


            TriggerEvent('esx_communityGGservice:endCommunityServiceCommand', targetId)
			TriggerClientEvent('esx_dpemote:DisableEmotes', target, false)

            local webhook = "PUT_YOUR_DISCORD_WEBHOOK_URL_HERE"
            local message = {
                embeds = {{
                    title = "Community Service End Log",
                    description = string.format("**Admin Information:**\n- **Name:** %s\n- **Steam Name:** %s\n- **Steam Hex:** %s\n- **ID:** %d\n\n**Player Information:**\n- **Name:** %s\n- **Steam Name:** %s\n- **Steam Hex:** %s\n- **ID:** %d\n\n**Details:**\n- **Timestamp:** %s\n- **Unix Time:** %d",
                        adminPlayerName, adminSteamName, adminSteamHex, adminID,
                        targetPlayerName, targetSteamName, targetSteamHex, targetID,
                        currentTimestamp, unixTimestamp),
                    color = 65280,
                    footer = {
                        text = "Community Service Log",
                        icon_url = "https://your-footer-icon-url.com/icon.png"
                    },
                    timestamp = os.date('!%Y-%m-%dT%H:%M:%SZ')
                }}
            }

            PerformHttpRequest(webhook, function(err, text, headers) end, 'POST', json.encode(message), { ['Content-Type'] = 'application/json' })
        else
            TriggerClientEvent('chat:addMessage', source, { args = { "System", "In Player Dar Server Nist" } })
        end
    else
        TriggerEvent('esx_communityGGservice:endCommunityServiceCommand', source)
    end
end, function(source, args, user)
    TriggerClientEvent('chat:addMessage', source, { args = { "System", "Dastresi Nadarid" } })
end, {help = "Payan Dadan Be Comserv", params = {{name = "id", help = "ID"}}})

RegisterServerEvent('esx_communityGGservice:endCommunityServiceCommand')
AddEventHandler('esx_communityGGservice:endCommunityServiceCommand', function(source)
	if source ~= nil then
		releaseFromCommunityService(source)
	end
end)

RegisterServerEvent('esx_communityGGservice:finishCommunityService')
AddEventHandler('esx_communityGGservice:finishCommunityService', function()
	releaseFromCommunityService(source)
end)

RegisterServerEvent('esx_communityGGservice:completeService')
AddEventHandler('esx_communityGGservice:completeService', function()

	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	if not xPlayer then return end
	local identifier = xPlayer.identifier

	MySQL.Async.fetchAll('SELECT * FROM communityservice WHERE identifier = @identifier', {
		['@identifier'] = identifier
	}, function(result)

		if result[1] then
			local remaining = (result[1].actions_remaining or 0) - 1
			MySQL.Async.execute('UPDATE communityservice SET actions_remaining = @remaining WHERE identifier = @identifier', {
				['@identifier'] = identifier,
				['@remaining'] = remaining,
			})

			-- SERVER decides when CS is actually finished, instead of trusting
			-- the client's own local actionsRemaining count to fire
			-- finishCommunityService itself (that was a free "instant complete"
			-- for anyone willing to trigger the event directly).
			if remaining <= 0 then
				releaseFromCommunityService(_source)
			end
		else

		end
	end)
end)

-- (esx_communityGGservice:extendService is now handled further down,
-- alongside the server-side containment watchdog - see PenalizeEscape.)

-- SECURITY FIX: neither of these two events checked WHO was calling them --
-- any connected player could TriggerServerEvent this directly with any
-- `target`/`steamhex` and sentence (or un-restrain) anyone, with no police/
-- judge job requirement at all. Mirrors the IsJobAllowed pattern jail.lua
-- already uses for the same class of action.
local function IsJobAllowed(jobname)
	for _, job in pairs(Config.AllowedJobs) do
		if jobname == job.name then
			return true
		end
	end
	return false
end

-- EXPANSION: allow on-duty admins (ESX permission_level, e.g. from
-- Unique_AdminMenu) to sentence players to community service too, not just
-- the police/judge jobs above -- mirrors jail.lua's 'admin' vs 'faction'
-- distinction for the exact same class of action. Config.AdminPermissionLevel
-- defaults to 2 if not set.
local function IsAllowedToSentence(xSender)
	if not xSender then return false end
	if IsJobAllowed(xSender.job.name) then return true end
	local minLevel = Config.AdminPermissionLevel or 2
	return xSender.permission_level ~= nil and xSender.permission_level >= minLevel
end

RegisterServerEvent('esx_communityGGservice:sendToCommunityService')
AddEventHandler('esx_communityGGservice:sendToCommunityService', function(target, actions_count, reason)
	local _source = source
	local xSender = ESX.GetPlayerFromId(_source)
	if not IsAllowedToSentence(xSender) then
		if exports.UNIQUE_AC then
			exports.UNIQUE_AC:BanPlayer(_source, 'Cheat Lua Executer', 'Tried esx_communityGGservice:sendToCommunityService without permission')
		end
		return
	end

	actions_count = tonumber(actions_count)
	if not actions_count or actions_count <= 0 then return end

	local xTarget = ESX.GetPlayerFromId(target)
	if not xTarget then return end
	local identifier = xTarget.identifier

	MySQL.Async.fetchAll('SELECT * FROM communityservice WHERE identifier = @identifier', {
		['@identifier'] = identifier,

	}, function(result)
		if result[1] then
			MySQL.Async.execute('UPDATE communityservice SET actions_remaining = @actions_remaining, reason = @reason WHERE identifier = @identifier', {
				['@identifier'] = identifier,
				['@actions_remaining'] = actions_count,
				['@reason'] = reason
			})
		else
			MySQL.Async.execute('INSERT INTO communityservice (identifier, actions_remaining, reason) VALUES (@identifier, @actions_remaining, @reason)', {
				['@identifier'] = identifier,
				['@actions_remaining'] = actions_count,
				['@reason'] = reason
			})
		end
	end)

	MySQL.Async.fetchAll('SELECT playerName FROM users WHERE identifier = @identifier',  {
		['@identifier'] = identifier
	}, function(result2)

		TriggerClientEvent('chat:addMessage', -1, {
			template = '<div style="padding: 0.5vw; margin: 0.5vw; background-color: rgba(255, 131, 0, 0.4); border-radius: 3px;"><i class="fas fa-exclamation-triangle"></i> Comserv<br>  {1}</div>',
			args = { _U('judge'), "^2"..(result2[1] and result2[1].playerName or xTarget.getName()).."^0 Be Elate ^2" ..reason.."^0 Be Anjam Tedad ^1"..actions_count.."^0 Community Service Mahkum Shod" }
		})

	end)



	TriggerClientEvent('esx_policejob:unrestrain', target)
	ActiveCS[target] = true
	TriggerClientEvent('esx_communityGGservice:inCommunityService', target, actions_count)
	TriggerClientEvent('esx_communityGGservice:inCommunityService_reason', target, reason)
end)

local playerNameVariable

RegisterServerEvent('esx_communityGGservice:sendToCommunityServiceoffline')
AddEventHandler('esx_communityGGservice:sendToCommunityServiceoffline', function(steamhex, actions_count, reason)
	local _source = source
	local xSender = ESX.GetPlayerFromId(_source)
	if not IsAllowedToSentence(xSender) then
		if exports.UNIQUE_AC then
			exports.UNIQUE_AC:BanPlayer(_source, 'Cheat Lua Executer', 'Tried esx_communityGGservice:sendToCommunityServiceoffline without permission')
		end
		return
	end

	actions_count = tonumber(actions_count)
	if not actions_count or actions_count <= 0 then return end

	MySQL.Async.fetchAll('SELECT * FROM communityservice WHERE identifier = @identifier', {
		['@identifier'] = steamhex,

	}, function(result)
		if result[1] then
			MySQL.Async.execute('UPDATE communityservice SET actions_remaining = @actions_remaining, reason = @reason WHERE identifier = @identifier', {
				['@identifier'] = steamhex,
				['@actions_remaining'] = actions_count,
				['@reason'] = reason
			})
		else
			MySQL.Async.execute('INSERT INTO communityservice (identifier, actions_remaining, reason) VALUES (@identifier, @actions_remaining, @reason)', {
				['@identifier'] = steamhex,
				['@actions_remaining'] = actions_count,
				['@reason'] = reason
			})
		end
	end)

	MySQL.Async.fetchAll('SELECT playerName FROM users WHERE identifier = @identifier',  {
		['@identifier'] = steamhex
	}, function(result2)

		TriggerClientEvent('chat:addMessage', -1, {
			template = '<div style="padding: 0.5vw; margin: 0.5vw; background-color: rgba(255, 131, 0, 0.4); border-radius: 3px;"><i class="fas fa-exclamation-triangle"></i> Comserv<br>  {1}</div>',
			args = { _U('judge'), "^2"..result2[1].playerName.."^0 Be Elate ^2" ..reason.."^0 Be Anjam Tedad ^1"..actions_count.."^0 Community Service Mahkum Shod" }
		})

	end)






end)

-- BUG FIX: this used to ignore `source` and loop over EVERY online player
-- every single time ANY player fired 'loading:Loaded' - meaning every new
-- connection re-sent inCommunityService to every player already serving CS,
-- interrupting their current action/animation and re-teleporting them for
-- no reason. Now it only ever checks the player who actually just loaded.
RegisterServerEvent('esx_communityGGservice:checkIfSentenced')
AddEventHandler('esx_communityGGservice:checkIfSentenced', function()
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	if not xPlayer then return end
	local identifier = xPlayer.identifier

	MySQL.Async.fetchAll('SELECT * FROM communityservice WHERE identifier = @identifier', {
		['@identifier'] = identifier
	}, function(result)
		if result[1] ~= nil and result[1].actions_remaining > 0 then
			ActiveCS[_source] = true
			TriggerClientEvent('esx_communityGGservice:inCommunityService', _source, tonumber(result[1].actions_remaining))
			TriggerClientEvent('esx_communityGGservice:inCommunityService_reason', _source, result[1].reason)

			local currentJob = xPlayer.job.name
			if currentJob ~= "nojob"  then
				xPlayer.setJob("off"..currentJob, xPlayer.job.grade)
				TriggerClientEvent('esx:showNotification', _source, "Shoma Off Duty Shodid")
			end
		end
	end)
end)

function releaseFromCommunityService(target)

	local xTarget = ESX.GetPlayerFromId(target)
	if not xTarget then return end
	local identifier = xTarget.identifier
	ActiveCS[target] = nil

	MySQL.Async.fetchAll('SELECT * FROM communityservice WHERE identifier = @identifier', {
		['@identifier'] = identifier
	}, function(result)
		if result[1] then
			MySQL.Async.execute('DELETE from communityservice WHERE identifier = @identifier', {
				['@identifier'] = identifier
			})
		end
	end)
	TriggerClientEvent('esx_dpemote:DisableEmotes', target, false)
	TriggerClientEvent('esx_communityGGservice:finishCommunityService', target)

	-- Never-bug guarantee: confirm the client actually landed at
	-- Config.ReleaseLocation. If Unique_Punishment:CS_ReleaseAck hasn't come
	-- back in 4s (dropped event, client hiccup, resource restart mid-release,
	-- etc.), resend the release up to 3 times so nobody gets stuck.
	local attempt = 0
	local function confirmRelease()
		attempt = attempt + 1
		Citizen.SetTimeout(4000, function()
			if ReleaseAcked[target] then
				ReleaseAcked[target] = nil
				return
			end
			if attempt >= 3 then return end
			if GetPlayerName(target) == nil then return end -- disconnected, nothing to do
			TriggerClientEvent('esx_dpemote:DisableEmotes', target, false)
			TriggerClientEvent('esx_communityGGservice:finishCommunityService', target)
			confirmRelease()
		end)
	end
	confirmRelease()
end

ReleaseAcked = {}
RegisterServerEvent('Unique_Punishment:CS_ReleaseAck')
AddEventHandler('Unique_Punishment:CS_ReleaseAck', function()
	ReleaseAcked[source] = true
end)

-- Escape containment. The client already teleports itself back the instant
-- it notices it's too far (see client/cs.lua, checked several times a
-- second) - this event is just how it reports that back so the server can
-- apply the existing Config.ServiceExtensionOnEscape penalty and log it.
-- Also backed by a server-side watchdog below that doesn't depend on the
-- client cooperating at all (kills threads, mod menu, disconnect, etc. all
-- still get caught).
local LastEscapePenalty = {}
local function PenalizeEscape(targetSource, identifier, detectedBy)
	-- Debounce: don't stack a penalty more than once every 10s for the same
	-- player, in case client+server both report the same escape.
	local now = os.time()
	if LastEscapePenalty[targetSource] and (now - LastEscapePenalty[targetSource]) < 10 then return end
	LastEscapePenalty[targetSource] = now

	MySQL.Async.execute('UPDATE communityservice SET actions_remaining = actions_remaining + @extension_value WHERE identifier = @identifier', {
		['@identifier'] = identifier,
		['@extension_value'] = Config.ServiceExtensionOnEscape,
	})
	TriggerClientEvent('esx:showNotification', targetSource, ("~r~Escape attempt detected - +%s actions added to your sentence."):format(Config.ServiceExtensionOnEscape))
	if LogAdminAction then
		LogAdminAction(targetSource, "cs-escape-attempt", ("detected by: %s | +%s actions"):format(detectedBy, Config.ServiceExtensionOnEscape))
	else
		print(("[Unique_Punishment] CS escape attempt: %s (id:%s) detected by %s, +%s actions"):format(GetPlayerName(targetSource) or '?', targetSource, detectedBy, Config.ServiceExtensionOnEscape))
	end
end

RegisterServerEvent('esx_communityGGservice:extendService')
AddEventHandler('esx_communityGGservice:extendService', function()
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	if not xPlayer or not ActiveCS[_source] then return end
	PenalizeEscape(_source, xPlayer.identifier, 'client')
end)

-- Server-side containment watchdog: authoritative, doesn't trust the client
-- at all. Runs independently of whatever the client-side loop is (or isn't)
-- doing, so a killed thread / mod menu / lagged-out client can't be used to
-- just walk (or drive) away from CS.
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(2000)
		for src in pairs(ActiveCS) do
			local ped = GetPlayerPed(src)
			if ped and ped ~= 0 then
				local coords = GetEntityCoords(ped)
				local dist = #(vector3(coords.x, coords.y, coords.z) - Config.ServiceLocation)
				if dist > Config.DistanceExtension then
					local xPlayer = ESX.GetPlayerFromId(src)
					TriggerClientEvent('Unique_Punishment:CS_ForceReturn', src)
					if xPlayer then
						PenalizeEscape(src, xPlayer.identifier, 'server-watchdog')
					end
				end
			else
				ActiveCS[src] = nil -- disconnected or ped not streamed in; drop it, playerDropped also clears this
			end
		end
	end
end)

AddEventHandler('playerDropped', function()
	ActiveCS[source] = nil
	ReleaseAcked[source] = nil
	LastEscapePenalty[source] = nil
end)

RegisterServerEvent("checkCommunityService")
AddEventHandler("checkCommunityService", function()
    local src = source
	local xPlayer = ESX.GetPlayerFromId(src)
	if xPlayer then
		local steamhex = xPlayer.identifier

		if steamhex then
			MySQL.Async.fetchAll("SELECT * FROM communityservice WHERE identifier = @identifier", {
				['@identifier'] = steamhex
			}, function(Ras)
				if #Ras and Ras[1] then
					ActiveCS[xPlayer.source] = true
					TriggerClientEvent('esx_dpemote:DisableEmotes', xPlayer.source, true)
					TriggerClientEvent('esx_policejob:unrestrain', xPlayer.source)
					TriggerClientEvent('esx_communityGGservice:inCommunityService', xPlayer.source, tonumber(Ras[1].actions_remaining))
					TriggerClientEvent('esx_communityGGservice:inCommunityService_reason', xPlayer.source, Ras[1].reason)
				end
			end)
		end
	end
end)

