-- ============================================================
-- Phone Wiretap (FBI/CIA)
-- Tap a phone number from the /agent menu; calls and texts
-- to/from that number get relayed live to the tapping agent.
--
-- This does NOT modify Unique_Phone at all -- it just adds a
-- second AddEventHandler for two events Unique_Phone already
-- registers as network events (Unique_Phone:server:CallContact
-- and Unique_Phone:server:UpdateMessages), so it's a pure
-- observer with zero risk to the phone script itself.
-- ============================================================

ESX = nil
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

local AGENT_JOBS = { fbi = true, cia = true }

local function isAgent(jobname)
	return AGENT_JOBS[jobname] == true
end

local WIRETAP_DURATION = 30 * 60 -- seconds

local wiretaps = {} -- wiretaps[phoneNumber] = { agentSource, expiresAt }

RegisterServerEvent('esx_uniquejobs:placeWiretap')
AddEventHandler('esx_uniquejobs:placeWiretap', function(number)
	local source = source
	local xPlayer = ESX.GetPlayerFromId(source)
	if not xPlayer or not isAgent(xPlayer.job.name) then return end

	if not number or number == '' then return end

	if wiretaps[number] then
		TriggerClientEvent('esx:showNotification', source, "~r~In Shomare Ghablan Shenood Dare!")
		return
	end

	wiretaps[number] = { agentSource = source, expiresAt = os.time() + WIRETAP_DURATION }
	TriggerClientEvent('esx:showNotification', source, "~g~Shenood Rooye Shomare " .. number .. " Faal Shod (30 Daghighe)")

	SetTimeout(WIRETAP_DURATION * 1000, function()
		if wiretaps[number] and wiretaps[number].agentSource == source then
			wiretaps[number] = nil
			TriggerClientEvent('esx:showNotification', source, "~r~Shenood Rooye " .. number .. " Tamam Shod")
		end
	end)
end)

RegisterServerEvent('esx_uniquejobs:removeWiretap')
AddEventHandler('esx_uniquejobs:removeWiretap', function(number)
	local source = source
	if wiretaps[number] and wiretaps[number].agentSource == source then
		wiretaps[number] = nil
		TriggerClientEvent('esx:showNotification', source, "~g~Shenood Hazf Shod")
	end
end)

ESX.RegisterServerCallback('esx_uniquejobs:getMyWiretaps', function(source, cb)
	local list = {}
	for number, w in pairs(wiretaps) do
		if w.agentSource == source then
			list[#list + 1] = { number = number, secondsLeft = w.expiresAt - os.time() }
		end
	end
	cb(list)
end)

local function relayToWiretap(number, kind, fromName, text)
	local tap = wiretaps[number]
	if not tap then return end

	TriggerClientEvent('chatMessage', tap.agentSource, "[ WIRETAP: " .. number .. " ]", {150, 0, 200},
		"^7" .. kind .. " Az ^3" .. fromName .. "^7: " .. (text or 'Na Moshakhas'))
end

local function getPhoneNumberFor(identifier)
	return MySQL.Sync.fetchScalar('SELECT phone FROM users WHERE identifier = @id', { ['@id'] = identifier })
end

-- Second listener on Unique_Phone's own call event -- taps whichever
-- side (caller or callee) is being wiretapped
AddEventHandler('Unique_Phone:server:CallContact', function(TargetData, CallId, AnonymousCall, Acall)
	local source = source
	local xPlayer = ESX.GetPlayerFromId(source)
	if not xPlayer or not TargetData then return end

	local callerNumber = getPhoneNumberFor(xPlayer.identifier)
	local targetNumber = TargetData.number

	if callerNumber and wiretaps[callerNumber] then
		relayToWiretap(callerNumber, "Tamas (Sader Shode)", xPlayer.name, "Be Shomare " .. tostring(targetNumber))
	end

	if targetNumber and wiretaps[targetNumber] then
		relayToWiretap(targetNumber, "Tamas (Dar Hale Daryaft)", xPlayer.name, "Az Shomare " .. tostring(callerNumber))
	end
end)

-- Best-effort: pulls the most recent message across the sender's chat
-- history that was just resent with this update (every entry carries a
-- displayable `.message` label regardless of type -- text, photo, or
-- shared location -- so this works for all message kinds)
local function extractLatestMessage(chatMessages)
	local latest = nil
	for _, group in pairs(chatMessages or {}) do
		if group and group.messages then
			for _, msg in ipairs(group.messages) do
				if not latest or (msg.time and msg.time > (latest.time or "")) then
					latest = msg
				end
			end
		end
	end
	return latest
end

-- Second listener on Unique_Phone's own message-update event
AddEventHandler('Unique_Phone:server:UpdateMessages', function(ChatMessages, ChatNumber, New)
	local source = source
	local xPlayer = ESX.GetPlayerFromId(source)
	if not xPlayer or not wiretaps[ChatNumber] then return end

	local latest = extractLatestMessage(ChatMessages)
	relayToWiretap(ChatNumber, "Payamak", xPlayer.name, latest and latest.message or nil)
end)
