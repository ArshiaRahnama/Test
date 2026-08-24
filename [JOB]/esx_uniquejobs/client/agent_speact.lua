-- ============================================================
-- Unified Agent (FBI + CIA) Menu (client)
-- One command, /agent, opens an ox_lib menu with every FBI/CIA
-- action in one place: start/stop spectate, message a spectate
-- target, open/close/message the interrogation room, phone
-- number lookup, and a live list of online agents in your own
-- agency. /fow /fcw /fw /agentmsg /closespec still work too, for
-- anyone who prefers typing.
-- ============================================================

ESX = nil

local agentJob = nil -- 'fbi' | 'cia' | nil
local isSpectating = false
local spectatingTarget = nil
local markerCoords = vector3(124.6018, -733.215, 242.15)
local markerCoords2 = vector3(125.0708, -732.377, 242.15)
local spectateData = {}

local ALL_JOBS = {
	{ label = "Police", value = "police" },
	{ label = "Sheriff", value = "sheriff" },
	{ label = "Ambulance", value = "ambulance" },
	{ label = "Mechanic", value = "mechanic" },
	{ label = "Taxi", value = "taxi" },
	{ label = "Weazel", value = "weazel" },
	{ label = "MT", value = "mt" },
	{ label = "CID", value = "cid" },
	{ label = "CIA", value = "cia" },
	{ label = "FBI", value = "fbi" },
	{ label = "Marshal", value = "marshal" },
	{ label = "Judge", value = "judge" },
	{ label = "DOA", value = "doa" },
}

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(200)
	end

	local playerLoaded = false
	RegisterNetEvent('esx:playerLoaded')
	AddEventHandler('esx:playerLoaded', function(xPlayer)
		playerLoaded = true
	end)

	while not playerLoaded do
		Citizen.Wait(200)
	end

	CheckAgentJob()
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
	agentJob = (job.name == "fbi" or job.name == "cia") and job.name or nil
end)

function CheckAgentJob()
	if ESX.PlayerData and ESX.PlayerData.job then
		local name = ESX.PlayerData.job.name
		agentJob = (name == "fbi" or name == "cia") and name or nil
	else
		ESX.TriggerServerCallback('esx_uniquejobs:checkAgentJob', function(result)
			agentJob = result or nil
		end)
	end
end

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(1000)
		if ESX ~= nil and ESX.GetPlayerData().job ~= nil then
			CheckAgentJob()
			break
		end
	end

	while true do
		Citizen.Wait(0)

		if agentJob then
			local playerCoords = GetEntityCoords(PlayerPedId())
			local distance = #(playerCoords - markerCoords)

			if distance < 5.0 then
				DrawMarker(1, markerCoords.x, markerCoords.y, markerCoords.z - 1.0, 0, 0, 0, 0, 0, 0, 1.0, 1.0, 1.0, 255, 0, 0, 100, false, true, 2, nil, nil, false)

				if distance < 1.5 then
					ESX.ShowHelpNotification("~INPUT_CONTEXT~ Press to open the agent menu (/agent).")

					if IsControlJustReleased(0, 38) then
						OpenAgentMenu()
					end
				end
			end
		end
	end
end)

-- ============================================================
-- /agent -- the one menu that replaces typing /fow /fcw /fw
-- /agentmsg /closespec one at a time
-- ============================================================

function OpenAgentMenu()
	if not agentJob then
		ESX.ShowNotification("❌ Shoma FBI Ya CIA Nistid!")
		return
	end

	ESX.TriggerServerCallback('esx_uniquejobs:getAgentRoomState', function(roomState)
		local options = {}

		options[#options + 1] = {
			title = string.upper(agentJob) .. ' Operations',
			description = isSpectating and ('Dar Hale Nezarat Bar: ' .. (spectateData.PLName or '?')) or 'Amaliyat-e Vizhe-ye ' .. string.upper(agentJob),
			icon = agentJob == 'fbi' and 'user-secret' or 'user-shield',
			disabled = true,
		}

		options[#options + 1] = {
			title = 'Shoroo-e Nezarat (Spectate)',
			description = 'Entekhab-e Shoghl Va Bazikon Baraye Nezarat',
			icon = 'eye',
			menu = 'agent_job_select',
		}

		if isSpectating then
			options[#options + 1] = {
				title = 'Ettela\'at-e Hadaf-e Nezarat',
				icon = 'circle-info',
				onSelect = function()
					OpenSpectateInfoMenu()
				end,
			}
			options[#options + 1] = {
				title = 'Ersal-e Payam Be Hadaf',
				icon = 'comment-dots',
				onSelect = function()
					local input = lib.inputDialog('Payam Be Hadaf-e Nezarat', { { type = 'input', label = 'Matn-e Payam', required = true } })
					if input and input[1] and input[1] ~= '' then
						TriggerServerEvent('esx_uniquejobs:menuAgentMsg', input[1])
					end
					OpenAgentMenu()
				end,
			}
			options[#options + 1] = {
				title = 'Tavaghof-e Nezarat',
				icon = 'eye-slash',
				onSelect = function()
					StopSpectate_agent()
				end,
			}
		end

		if roomState then
			options[#options + 1] = {
				title = 'Otagh-e Bazjuyi Faal: ' .. roomState.targetName,
				description = 'Baraye Ersal-e Payam Ya Bastan Entekhab Konid',
				icon = 'door-open',
				disabled = true,
			}
			options[#options + 1] = {
				title = 'Ersal-e Payam Dar Otagh',
				icon = 'message',
				onSelect = function()
					local input = lib.inputDialog('Payam Dar Otagh-e Bazjuyi', { { type = 'input', label = 'Matn-e Payam', required = true } })
					if input and input[1] and input[1] ~= '' then
						TriggerServerEvent('esx_uniquejobs:menuRoomMessage', input[1])
					end
					OpenAgentMenu()
				end,
			}
			options[#options + 1] = {
				title = 'Baste Kardan-e Otagh',
				icon = 'door-closed',
				onSelect = function()
					TriggerServerEvent('esx_uniquejobs:menuCloseRoom')
				end,
			}
		else
			options[#options + 1] = {
				title = 'Baz Kardan-e Otagh-e Bazjuyi',
				description = 'Shoroo-e Yek Mokaleme-ye Khosoosi Ba Yek Bazikon',
				icon = 'door-open',
				onSelect = function()
					local input = lib.inputDialog('Baz Kardan-e Otagh-e Bazjuyi', { { type = 'number', label = 'ID Bazikon', required = true } })
					if input and input[1] then
						TriggerServerEvent('esx_uniquejobs:menuOpenRoom', input[1])
					end
				end,
			}
		end

		options[#options + 1] = {
			title = 'Jostoju-ye Shomare Telephone',
			description = 'Peyda Kardan-e Saheb-e Yek Shomare',
			icon = 'magnifying-glass',
			onSelect = function()
				local input = lib.inputDialog('Jostoju-ye Shomare', { { type = 'input', label = 'Shomare (10 Raqam)', required = true } })
				if input and input[1] then
					TriggerServerEvent('esx_uniquejobs:menuFindNumber', input[1])
				end
			end,
		}

		options[#options + 1] = {
			title = 'Afsaran-e Online',
			description = 'Hamkaran-e ' .. string.upper(agentJob) .. ' Ke Alan Online Hastand',
			icon = 'users',
			onSelect = function()
				OpenOnlineAgentsMenu()
			end,
		}

		local jobSelectOptions = {}
		for _, job in ipairs(ALL_JOBS) do
			if job.value ~= agentJob then
				jobSelectOptions[#jobSelectOptions + 1] = {
					title = job.label,
					icon = 'briefcase',
					onSelect = function()
						FetchOnlinePlayersByJob_agent(job.value)
					end,
				}
			end
		end
		lib.registerContext({ id = 'agent_job_select', title = 'Entekhab-e Shoghl', menu = 'agent_main', options = jobSelectOptions })

		lib.registerContext({ id = 'agent_main', title = string.upper(agentJob) .. ' Menu', options = options })
		lib.showContext('agent_main')
	end)
end

function OpenOnlineAgentsMenu()
	ESX.TriggerServerCallback('esx_uniquejobs:getOnlineAgents', function(agents)
		local options = {}

		if agents and #agents > 0 then
			for _, agent in ipairs(agents) do
				options[#options + 1] = {
					title = string.gsub(agent.name, "_", " "),
					description = 'ID: ' .. agent.id .. (agent.gradeLabel and (' | ' .. agent.gradeLabel) or ''),
					icon = 'user',
					disabled = true,
				}
			end
		else
			options[#options + 1] = { title = 'Hich Afsar-e Digari Online Nist', disabled = true, icon = 'circle-info' }
		end

		lib.registerContext({ id = 'agent_online', title = 'Afsaran-e Online', menu = 'agent_main', options = options })
		lib.showContext('agent_online')
	end)
end

RegisterCommand('agent', function()
	OpenAgentMenu()
end, false)

-- ============================================================
-- Spectate
-- ============================================================

function FetchOnlinePlayersByJob_agent(job)
	ESX.TriggerServerCallback('getOnlinePlayersByJob', function(players)
		local elements = {}

		for _, player in pairs(players) do
			elements[#elements + 1] = {
				title = string.gsub(player.name, "_", " "),
				description = 'ID: ' .. player.id,
				icon = 'eye',
				onSelect = function()
					SpectatePlayer_agent(player.id)
				end,
			}
		end

		if #elements == 0 then
			elements[#elements + 1] = { title = 'Hich Bazikoni Dar In Shoghl Online Nist', disabled = true, icon = 'circle-info' }
		end

		lib.registerContext({ id = 'agent_player_list', title = 'Bazikonan-e Online (' .. job .. ')', menu = 'agent_job_select', options = elements })
		lib.showContext('agent_player_list')
	end, job)
end

function SpectatePlayer_agent(targetId)
	local playerPed = PlayerPedId()
	SetEntityCoords(playerPed, markerCoords2.x, markerCoords2.y, markerCoords2.z)
	SetEntityVisible(playerPed, false, false)
	SetEntityAlpha(playerPed, 0, false)

	TriggerServerEvent('esx_uniquejobs:agentStartSpectate', targetId)
end

RegisterNetEvent('esx_uniquejobs:agentSpectate')
AddEventHandler('esx_uniquejobs:agentSpectate', function(targetId, inventory, weapons, money, PLCash, PLName, JobName, JobLabel, JobGrade, GangName, GangLabel, GangGrade)
	local playerPed = GetPlayerPed(GetPlayerFromServerId(targetId))
	if DoesEntityExist(playerPed) then
		NetworkSetInSpectatorMode(true, playerPed)
		ESX.ShowNotification("Spectating 🔍 " .. GetPlayerName(GetPlayerFromServerId(targetId)))
		isSpectating = true
		spectatingTarget = targetId

		spectateData = {
			inventory = inventory,
			weapons = weapons,
			money = money,
			PLCash = PLCash,
			PLName = PLName,
			JobName = JobName,
			JobLabel = JobLabel,
			JobGrade = JobGrade,
			GangName = GangName,
			GangLabel = GangLabel,
			GangGrade = GangGrade,
		}
	else
		ESX.ShowNotification("Player not found ❌")
	end
end)

function OpenSpectateInfoMenu()
	if not isSpectating then return end

	local options = {
		{ title = "Name: " .. spectateData.PLName, disabled = true, icon = 'id-card' },
		{ title = "Bank: $" .. spectateData.money, disabled = true, icon = 'building-columns' },
		{ title = "Cash: $" .. spectateData.PLCash, disabled = true, icon = 'money-bill' },
		{ title = "Job: " .. spectateData.JobName .. " | " .. spectateData.JobLabel .. " | " .. spectateData.JobGrade, disabled = true, icon = 'briefcase' },
		{ title = "Gang: " .. spectateData.GangName .. " | " .. spectateData.GangLabel .. " | " .. spectateData.GangGrade, disabled = true, icon = 'people-group' },
	}

	for _, item in pairs(spectateData.inventory) do
		if item.count ~= 0 then
			options[#options + 1] = { title = item.count .. "x " .. item.label, disabled = true, icon = 'box' }
		end
	end

	for _, weapon in pairs(spectateData.weapons) do
		options[#options + 1] = { title = weapon.label, disabled = true, icon = 'gun' }
	end

	lib.registerContext({ id = 'agent_spectate_info', title = 'Ettela\'at-e Hadaf', menu = 'agent_main', options = options })
	lib.showContext('agent_spectate_info')
end

function StopSpectate_agent()
	local playerPed = PlayerPedId()

	NetworkSetInSpectatorMode(false, playerPed)
	isSpectating = false
	spectatingTarget = nil

	SetEntityCoords(playerPed, markerCoords2.x, markerCoords2.y, markerCoords2.z)
	SetEntityVisible(playerPed, true, false)
	ResetEntityAlpha(playerPed)

	TriggerServerEvent('esx_uniquejobs:agentStopSpectate')
	ESX.ShowNotification("Stopped Spectating ❌")
end

RegisterCommand("closespec", function()
	if isSpectating then
		StopSpectate_agent()
	else
		ESX.ShowNotification("❌ You are not spectating anyone!")
	end
end, false)

-- ============================================================
-- Interrogation room chat display + backward-compatible typed
-- commands (/fow /fcw /fw /agentmsg still work for anyone who
-- prefers typing over the menu)
-- ============================================================

RegisterNetEvent('esx_uniquejobs:agentChatMessage')
AddEventHandler('esx_uniquejobs:agentChatMessage', function(senderName, message, isRoomBroadcast)
	if isRoomBroadcast then
		TriggerEvent('chatMessage', "[AGENT] ", {255, 0, 0}, message)
	else
		TriggerEvent('chatMessage', "[" .. (senderName or "Agent") .. "] ", {255, 0, 0}, message)
	end
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		if isSpectating and IsControlJustPressed(0, 73) then
			OpenSpectateInfoMenu()
		end

		if isSpectating and IsControlJustPressed(0, 177) then
			StopSpectate_agent()
		end
	end
end)
