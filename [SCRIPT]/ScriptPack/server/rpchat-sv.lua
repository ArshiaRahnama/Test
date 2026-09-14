ESX = nil
local mutedTable = {}

local Attempts = {}

Citizen.CreateThread(function()
   while ESX == nil do TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
   Citizen.Wait(50)
	end
end)

function getIdentity(source)
	local identifier = GetPlayerIdentifiers(source)[1]
	local result = MySQL.Sync.fetchAll("SELECT * FROM users WHERE identifier = @identifier", {['@identifier'] = identifier})
	if result[1] ~= nil then
		local identity = result[1]

		return {
			identifier = identity['identifier'],
			name = string.gsub(identity['playerName'], "_", " "),
			dateofbirth = identity['dateofbirth'],
		}
	else
		return nil
	end
end

RegisterCommand('serverd', function(source, args, rawCommand)
     local playerName = GetPlayerName(source)

  		local xPlayer = ESX.GetPlayerFromId(source)

		if xPlayer.permission_level >= 11 then
     local msg = rawCommand:sub(5)
     TriggerClientEvent('chat:addMessage', -1, {
         template = '<div style="padding: 0.5vw; margin: 0.5vw; background-color: rgba(0, 236, 255, 0.6); border-radius: 3px;"><i class="far fa-newspaper"></i> Server Discord:<br> https://discord.gg/rwBHcCqzJB</div>',
         args = { playerName, msg }
     })
end
end, false)

AddEventHandler('chatMessage', function(source, name, message)
		if string.sub(message, 1, string.len("/")) ~= "/" then
			CancelEvent()
			local name = getIdentity(source)
		else
			TriggerClientEvent("chatMessage", source, "[SYSTEM]", {255, 0, 0}, "^0Dastor ^3" .. string.sub(message, 1, string.find(message, " ")) .. "^0 vojod nadarad.")
		end
		CancelEvent()
	end)


	TriggerEvent('es:addCommand', 'ooc', function(source, args, user)
		local name =  GetPlayerName(source)
		local xPlayer = ESX.GetPlayerFromId(source)
		local data = {
			id = source,
			prefix =  "OOC | (" .. source .. ") " .. name,
			color = {151, 151, 151},
			message = table.concat(args, " "),
			distance = 19.999,
			coords = vector3(xPlayer.coords.x, xPlayer.coords.y, xPlayer.coords.z)
		}
		TriggerClientEvent("sendProximityMessage", -1, data)
	end)

	TriggerEvent('es:addCommand', 'oc', function(source, args, user)
		local name =  GetPlayerName(source)
		local xPlayer = ESX.GetPlayerFromId(source)
		local data = {
			id = source,
			prefix =  "OOC | (" .. source .. ") " .. name,
			color = {151, 151, 151},
			message = table.concat(args, " "),
			distance = 19.999,
			coords = vector3(xPlayer.coords.x, xPlayer.coords.y, xPlayer.coords.z)
		}
		TriggerClientEvent("sendProximityMessage", -1, data)
	end)

	TriggerEvent('es:addCommand', 's', function(source, args, user)
		local name = getIdentity(source)
		if args[1] then
			local xPlayer = ESX.GetPlayerFromId(source)
			local data = {
				id = source,
				prefix =  "(" .. source .. ") Faryad Mizanad",
				color = {255, 0, 0},
				message = table.concat(args, " "),
				distance = 30.0,
				coords = vector3(xPlayer.coords.x, xPlayer.coords.y, xPlayer.coords.z)
			}
			TriggerClientEvent("sendProximityMessage", -1, data)
		end
	end)









	RegisterCommand('mp', function(source, args, rawCommand)
		local src = source
		local xPlayer = ESX.GetPlayerFromId(src)

		if xPlayer then

			local allowedJobs = {
				police = "rgba(0, 0, 255, 0.6)",
				mt = "rgba(0, 0, 0, 0.6)",
				sheriff = "rgba(254, 255, 254, 0.6)",
				fbi = "rgba(0, 0, 0, 0.6)",
				ambulance = "rgba(255, 0, 0, 0.6)",
				mechanic = "rgba(255, 165, 0, 0.6)",

				cid = "rgba(75, 0, 130, 0.6)",
				cia = "rgba(25, 25, 25, 0.6)",
				marshal = "rgba(139, 69, 19, 0.6)",
				judge = "rgba(0, 100, 0, 0.6)",
				doa = "rgba(128, 0, 0, 0.6)"
			}

			local playerJob = xPlayer.job.name
			local jobLabel = xPlayer.job.label
			local color = allowedJobs[playerJob]

			if color then
				local message = table.concat(args, " ")
				if message and message ~= "" then
					local playerCoords = GetEntityCoords(GetPlayerPed(src))
					local players = GetPlayers()


					for _, playerId in ipairs(players) do
						local targetCoords = GetEntityCoords(GetPlayerPed(playerId))
						local distance = #(playerCoords - targetCoords)
						if distance <= 50.0 then
							TriggerClientEvent('chat:addMessage', playerId, {
								template = string.format(
									'<div style="padding: 0.5vw; margin: 0.2vw; background-color: %s; border-radius: 3px;">' ..
									'<b>Bolandgo %s [%s]:</b><br>{0}</div>',
									color, jobLabel, src
								),
								args = { message }
							})
						end
					end
				else
					TriggerClientEvent('chat:addMessage', src, {
						template = '<div style="padding: 0.5vw; margin: 0.2vw; background-color: rgba(255, 0, 0, 0.6); border-radius: 3px;">Please provide a message!</div>'
					})
				end
			else
				TriggerClientEvent('chat:addMessage', src, {
					template = '<div style="padding: 0.5vw; margin: 0.2vw; background-color: rgba(255, 0, 0, 0.6); border-radius: 3px;">Your job does not have access to this command!</div>'
				})
			end
		else
			TriggerClientEvent('chat:addMessage', src, {
				template = '<div style="padding: 0.5vw; margin: 0.2vw; background-color: rgba(255, 0, 0, 0.6); border-radius: 3px;">Could not find your job information!</div>'
			})
		end
	end, false)


	TriggerEvent('es:addCommand', 'do', function(source, args, user)
		local xPlayer = ESX.GetPlayerFromId(source)
		local data = {
			id = source,
			prefix =  "",
			color = {255, 0, 0},
			message = table.concat(args, " ").."".."  (( " .. tostring(source) .. " )) ",
			distance = 19.999,
			coords = vector3(xPlayer.coords.x, xPlayer.coords.y, xPlayer.coords.z)
		}
		TriggerClientEvent("sendProximityMessage", -1, data)
	end)

	TriggerEvent('es:addCommand', 'aooc', function(source, args, user)

		local xPlayer = ESX.GetPlayerFromId(source)

		if xPlayer.permission_level >= 1 then

				if xPlayer.get('aduty') then
					local name =  GetPlayerName(source)
					local xPlayer = ESX.GetPlayerFromId(source)
					local data = {
						id = source,
						prefix =  "^1(OOC) Admin | " .. name, "^*",
						color = {150, 150, 250},
						message = table.concat(args, " "),
						distance = 19.999,
						coords = vector3(xPlayer.coords.x, xPlayer.coords.y, xPlayer.coords.z)
					}
					TriggerClientEvent("sendProximityMessage", -1, data)

				else

					TriggerClientEvent('chatMessage', source, "[SYSTEM]", {255, 0, 0}, " ^0Shoma nemitavanid dar halat ^1OffDuty ^0az command haye admini estefade konid!")

				end

		else
			TriggerClientEvent('chatMessage', source, "[SYSTEM]", {255, 0, 0}, "Shoma admin nistid!")
		end

	end, {help = 'admin chat ooc'})

	TriggerEvent('es:addCommand', 'ab', function(source, args, user)

		local xPlayer = ESX.GetPlayerFromId(source)

		if xPlayer.permission_level >= 1 then

				if xPlayer.get('aduty') then
					if args[1] then
						local name =  GetPlayerName(source)
						local xPlayer = ESX.GetPlayerFromId(source)
						local data = {
							id = source,
							prefix =  "^1(OOC) Admin | " .. name, "^*",
							color = {150, 150, 250},
							message = table.concat(args, " "),
							distance = 19.999,
							coords = vector3(xPlayer.coords.x, xPlayer.coords.y, xPlayer.coords.z)
						}
						TriggerClientEvent("sendProximityMessage", -1, data)
					end

				else

					TriggerClientEvent('chatMessage', source, "[SYSTEM]", {255, 0, 0}, " ^0Shoma nemitavanid dar halat ^1OffDuty ^0az command haye admini estefade konid!")

				end
		else
			TriggerClientEvent('chatMessage', source, "[SYSTEM]", {255, 0, 0}, "Shoma admin nistid!")
		end

	end, {help = 'admin chat ooc'})

	TriggerEvent('es:addCommand', 'tas', function(source, args, user)
		if not args[1] then
			TriggerClientEvent('chatMessage', source, "[SYSTEM]", {255, 0, 0}, "Shoma dar ghesmat adad chizi vared nakardid!")
			return
		end

		if not tonumber(args[1]) then
			TriggerClientEvent('chatMessage', source, "[SYSTEM]", {255, 0, 0}, "Shoma dar ghesmat tedad tas faghat mitavanid adad vared konid!")
			return
		end

		local count = tonumber(args[1])
		if (count >= 5) then
			TriggerClientEvent('chatMessage', source, "[SYSTEM]", {255, 0, 0}, "Nemitavanid bishtar az 3 tas hamzaman bendazid!")
			return
		end

		local text = math.random(1,6)

		for i = 2,count do
			text = text .. ', ' .. math.random(1,6)
		end

		TriggerClientEvent("sendRollThatShit", source)
		local xPlayer = ESX.GetPlayerFromId(source)
		local data = {
			id = source,
			prefix =  "^1Tas(^3" .. tostring(source) .. "^1)",
			color = {150, 150, 250},
			message = text,
			distance = 19.999,
			coords = vector3(xPlayer.coords.x, xPlayer.coords.y, xPlayer.coords.z)
		}
		TriggerClientEvent("sendProximityMessage", -1, data)
	end)











function stringsplit(inputstr, sep)
    if sep == nil then
        sep = "%s"
    end
    local t={} ; i=1
    for str in string.gmatch(inputstr, "([^"..sep.."]+)") do
        t[i] = str
        i = i + 1
    end
    return t
end