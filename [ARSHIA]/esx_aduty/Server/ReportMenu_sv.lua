ESX                = nil
local reports = {}
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
local rcount = 0

local Cowldown = {}

RegisterCommand('report', function(source, args)
    for k,v in pairs(reports) do
        if v.owner.identifier == identifier then
            TriggerClientEvent("esx:showNotification", source, "Shoma Report Darid!")
            return
        end
    end

	if Cowldown[source] ~= nil then
		if Cowldown[source] <= os.time() then
			TriggerClientEvent('sr_reportsystem:openMenu', source)
			Cowldown[source] = nil
		else
			TriggerClientEvent('chatMessage', source, "[System] ", {255, 0, 0}, "Shoma Be Tazegi Report Dadid ^2"..(Cowldown[source] - os.time()).." s^0 Sabr Konid")
		end
	else
		TriggerClientEvent('sr_reportsystem:openMenu', source)
	end
end)

RegisterCommand('reports', function(source, args)
    for k,v in pairs(reports) do
        TriggerClientEvent('esx_Report:ManageReports', source, reports)
    end
end)

RegisterCommand('ar', function(source, args)

	local xPlayer = ESX.GetPlayerFromId(source)

	if xPlayer.permission_level >= 2 then
		if xPlayer.get('aduty') then

			if not args[1] then
				TriggerClientEvent('chatMessage', source, "[ Report ] : ", {255, 0, 0}, "Shoma Dar Ghesmat ID Chizi Vared Nakardid!")
				return
			end

			if not tonumber(args[1]) then
				TriggerClientEvent('chatMessage', source, "[ Report ] : ", {255, 0, 0}, "Shoma Dar Ghesmat ID Faghat Adad Mitavanid Vared Konid!")
				return
			end

			local identifier = GetPlayerIdentifier(source)

			if not canRespond(identifier) then
				TriggerClientEvent('chatMessage', source, "[ Report ] : ", {255, 0, 0}, "Shoma Nemitavanid Be Report Digari Javab Dahid Aval Report Ghablie Khod Ra Bebandid!")
				return
			end
			local Targetid = tonumber(reports[args[1]].owner.id)
			local Target = ESX.GetPlayerFromId(Targetid)
			if Target and Target.coords and xPlayer.coords then






				local dx = Target.coords.x - xPlayer.coords.x
				local dy = Target.coords.y - xPlayer.coords.y
				local dz = Target.coords.z - xPlayer.coords.z
				local Distance = math.sqrt(dx * dx + dy * dy + dz * dz)
				if Distance <= 10 then
					TriggerClientEvent('chatMessage', source, "[ Report ] : ", {255, 0, 0}, "Shoma Bayad Spect Bashid Ta Betavanid Accept Konid!")
					return
				end
			end


			if reports[args[1]] then

				if reports[args[1]].status == "open" then

					local report = reports[args[1]]
					local ridentifier = report.owner.identifier
					local name = GetPlayerName(source)
					report.status = "pending"
					report.respond.name = name
					report.respond.identifier = identifier

					TriggerClientEvent('chatMessage', source, "[ Report ] : ", {255, 0, 0}, " ^0Report [ ^3" .. args[1] .. "^0 ] Tavasot  ^2Shoma ^0  Ghabol Shod Jahat Takmil Kardan Report /cr^2 "..args[1])

					local xPlayers = ESX.GetPlayers()
					for i=1, #xPlayers do
						xPlayer = ESX.GetPlayerFromId(xPlayers[i])
						if xPlayer.permission_level >= 2 and xPlayer.get('aduty') and xPlayer.source ~= source then
							TriggerClientEvent('chatMessage', xPlayer.source, "[ Report ] : ", {255, 0, 0}, " ^0Report [ ^3" .. args[1] .. "^0 ] Tavasot [ ^2" .. name .. "^0 ] Ghabol Shod!")
							TriggerEvent('DiscordBot:ToDiscord', 'acreports', xPlayer.name, "```cs\n Report : [" .. args[1] .. "]\n Tavasot : [" .. name .. "] Ghabol Shod!\n```",'user', true, _source, false)
						end
					end
				else
					TriggerClientEvent('chatMessage', source, "[ Report ] : ", {255, 0, 0}, "In Report Ghablan Tavasot Kasi Javab Dade Shode Ast!")
				end
			else
				TriggerClientEvent('chatMessage', source, "[ Report ] : ", {255, 0, 0}, "Report Mored Nazar Vojod Nadarad!")
			end
		else
			TriggerClientEvent('chatMessage', source, "[ Report ] : ", {255, 0, 0}, " ^0Shoma Nemitavanid Dar Halat ^1OffDuty ^0Az Command Haye adutyi Estefade Konid!")
		end
	else
		TriggerClientEvent('chatMessage', source, "[ Report ] : ", {255, 0, 0}, " ^0Shoma Dastresi Kafi Baraye Estefade Az In Dastor Ra Nadarid")
	end

end, false)

RegisterCommand('cr', function(source, args)

	local xPlayer = ESX.GetPlayerFromId(source)

	if xPlayer.permission_level >= 2 then
		if xPlayer.get('aduty') then

			if not args[1] then
				TriggerClientEvent('chatMessage', source, "[ Report ] : ", {255, 0, 0}, "Shoma Dar Ghesmat ID Chizi Vared Nakardid!")
				return
			end

			if not tonumber(args[1]) then
				TriggerClientEvent('chatMessage', source, "[ Report ] : ", {255, 0, 0}, "Shoma Dar Ghesmat ID Faghat Adad Mitavanid Vared Konid")
				return
			end

			if reports[args[1]] then

				local report = reports[args[1]]
				local identifier = GetPlayerIdentifier(source)
				local ridentifier = report.owner.identifier
				local closer = GetPlayerName(source)
				if reports[args[1]].status == "pending" or xPlayer.permission_level >= 9 then
					TriggerClientEvent('chatMessage', xPlayer.source, "[ Report ] : ", {255, 0, 0}, "Shoma Report ^2" .. report.owner.name .. "^0 [^3" .. report.owner.id .. "^0] Ra Bastid!")

					xPlayer = report.owner.id
					if xPlayer then
						TriggerClientEvent('chatMessage', xPlayer, "[ Report ] : ", {255, 0, 0}, "Report Shoma Tavasot [ ^2" .. closer .. "^0 ] Ghabol Shod!")
					end

					-- EXPANSION: lets Unique_AdminMenu ask the reporter for a
					-- satisfaction rating right after their report closes.
					-- Doesn't touch anything below - report.owner.id is the
					-- reporter's server id at report time, same one used
					-- for the notification two lines up. report.time (set
					-- when the report was created, a few lines up in
					-- esx_Report:CreateReport) lets Unique_AdminMenu compute
					-- a per-admin average response time.
					TriggerEvent('Unique_AdminMenu:ReportClosed', report.owner.id, args[1], closer, report.time)

					reports[args[1]] = nil
				else
					TriggerClientEvent('chatMessage', source, "[ Report ] : ", {255, 0, 0}, "Shoma Aval Bayad Report Ra Ba^1 /ar ^0bebandid!")
				end
			else
				TriggerClientEvent('chatMessage', source, "[ Report ] : ", {255, 0, 0}, "Report Mored Nazar Vojod Nadarad!")
			end
		else
			TriggerClientEvent('chatMessage', source, "[ Report ] : ", {255, 0, 0}, " ^0Shoma Nemitavanid Dar Halat ^1OffDuty ^0Az Command Haye adutyi Estefade Konid!")
		end
	else
		TriggerClientEvent('chatMessage', source, "[ Report ] : ", {255, 0, 0}, " ^0Shoma Dastresi Kafi Baraye Estefade Az In Dastor Ra Nadarid")
	end
end, false)

RegisterServerEvent('esx_Report:Pending', function(v,ped)
    local xPlayer = ESX.GetPlayerFromId(source)
    local report = reports[v]
    local id = source
    local name = GetPlayerName(id)
    if report.owner.id == source then
        TriggerClientEvent('chatMessage', source, "[ Report ] : ", {255, 0, 0}, "Shoma Nemitavanid Be Report Khod Javab Dahid")
        TriggerClientEvent('esx_Report:closemenu', source)
    else
    reports[v].status = "pending"
    TriggerClientEvent('chatMessage', xPlayer.source, "[ Report ] : ", {255, 0, 0}, "Shoma Report ^2" .. report.owner.name .. "^0 [^3" .. report.owner.id .. "^0] Ra Ghabol Kardid!")
    xPlayer = report.owner.id
    TriggerClientEvent('chatMessage', xPlayer, "[ Report ] : ", {255, 0, 0}, "Report Shoma Tavasot [ ^2" .. name .. "^0 ] Ghabol Shod!")
    TriggerClientEvent('esx_Report:spectate', id, xPlayer)

    local xPlayers = ESX.GetPlayers()
    for i=1, #xPlayers do
    xPlayer = ESX.GetPlayerFromId(xPlayers[i])
    if xPlayer.permission_level >= 2 and xPlayer.get('aduty') then
    TriggerClientEvent('chatMessage', xPlayer.source, "[ Report ] : ", {255, 0, 0}, " ^0Report [ ^3" .. v .. "^0 ] Tavasot [ ^2" .. name .. "^0 ] Ghabol Shod!")
    end
end
end
end)

RegisterServerEvent('esx_Report:CreateReport', function(typee,text)
    local id = source
    local name = GetPlayerName(id)
    rcount = source

    reports[tostring(rcount)] = {
        owner = {
        identifier = identifier,
        name = name,
        id = source,
    },

    respond = {
        name = "none",
        identifier = "none"
    },

        category = typee,
        ID = source,
        Detail = text,
        reason = reason,
        status = "open",
        time = os.time()
    }
	Cowldown[source] = os.time() + 300
    local xPlayers = ESX.GetPlayers()
    for i=1, #xPlayers do
        local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
        if typee ~= 'More' then
			if xPlayer.permission_level >= 2 and xPlayer.get('aduty') then
				TriggerClientEvent('chat:addMessage', source, {
					args = {"^1[System]: ^0New Report: ^2" .. name .. "^0(^3" .. id .. "^0) : ^0(^1" ..typee.."^0)"}
				})
			end
		else
			TriggerClientEvent('chat:addMessage', source, {
				args = {"^1[System]: ^0New Report: ^2 ".. name .. "^0(^3" .. id .. "^0) : ^0(^1" ..text.."^0)"}
			})
        end
    end
end)

function canRespond(identifier)
	for k,v in pairs(reports) do
		if v.respond.identifier == identifier then
			return false
		end
	end

	return true
end

exports('GetReports', function()
	return reports
end)