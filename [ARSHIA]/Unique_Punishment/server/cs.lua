ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

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
			MySQL.Async.execute('UPDATE communityservice SET actions_remaining = actions_remaining - 1 WHERE identifier = @identifier', {
				['@identifier'] = identifier
			})
		else

		end
	end)
end)

RegisterServerEvent('esx_communityGGservice:extendService')
AddEventHandler('esx_communityGGservice:extendService', function()

	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	if not xPlayer then return end
	local identifier = xPlayer.identifier

	MySQL.Async.fetchAll('SELECT * FROM communityservice WHERE identifier = @identifier', {
		['@identifier'] = identifier
	}, function(result)

		if result[1] then
			MySQL.Async.execute('UPDATE communityservice SET actions_remaining = actions_remaining + @extension_value WHERE identifier = @identifier', {
				['@identifier'] = identifier,
				['@extension_value'] = Config.ServiceExtensionOnEscape
			})
		else

		end
	end)
end)

RegisterServerEvent('esx_communityGGservice:sendToCommunityService')
AddEventHandler('esx_communityGGservice:sendToCommunityService', function(target, actions_count, reason)

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
	TriggerClientEvent('esx_communityGGservice:inCommunityService', target, actions_count)
	TriggerClientEvent('esx_communityGGservice:inCommunityService_reason', target, reason)
end)

local playerNameVariable

RegisterServerEvent('esx_communityGGservice:sendToCommunityServiceoffline')
AddEventHandler('esx_communityGGservice:sendToCommunityServiceoffline', function(steamhex, actions_count, reason)

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

RegisterServerEvent('esx_communityGGservice:checkIfSentenced')
AddEventHandler('esx_communityGGservice:checkIfSentenced', function()
	local Players = ESX.GetPlayers()
	for i=1, #Players do

		local _source = Players[i]
		local xPlayer = ESX.GetPlayerFromId(_source)
		if xPlayer then
			local identifier = xPlayer.identifier

			MySQL.Async.fetchAll('SELECT * FROM communityservice WHERE identifier = @identifier', {
				['@identifier'] = identifier
			}, function(result)
				if result[1] ~= nil and result[1].actions_remaining > 0 then
					TriggerClientEvent('esx_communityGGservice:inCommunityService', _source, tonumber(result[1].actions_remaining))
					TriggerClientEvent('esx_communityGGservice:inCommunityService_reason', _source, result[1].reason)

					local currentJob = xPlayer.job.name
					if currentJob ~= "nojob"  then

						xPlayer.setJob("off"..currentJob, xPlayer.job.grade)
						TriggerClientEvent('esx:showNotification', _source, "Shoma Off Duty Shodid")
					end
				end
			end)
		end
		Wait(20)
	end
end)

function releaseFromCommunityService(target)

	local xTarget = ESX.GetPlayerFromId(target)
	if not xTarget then return end
	local identifier = xTarget.identifier
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
end

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
					TriggerClientEvent('esx_dpemote:DisableEmotes', xPlayer.source, true)
					TriggerClientEvent('esx_policejob:unrestrain', xPlayer.source)
					TriggerClientEvent('esx_communityGGservice:inCommunityService', xPlayer.source, tonumber(Ras[1].actions_remaining))
					TriggerClientEvent('esx_communityGGservice:inCommunityService_reason', xPlayer.source, Ras[1].reason)
				end
			end)
		end
	end
end)

