-- ============================================================
-- Traffic Stop Log menu (feature #9) -- now wired straight into
-- CAD's BOLO system (cad/server/crimescene.lua): every plate you
-- enter during a stop is auto-checked against active BOLOs using
-- CAD's own event/callback (CrimeScene:checkPlate /
-- CrimeScene:getActiveBOLOs) -- no new tables, no duplicated logic,
-- a hit clears the BOLO for everyone exactly like it does from the
-- /cad panel. A BOLO hit anywhere (this menu, /cad, another officer)
-- now also pops a loud native alert here, not just a chat line.
-- ============================================================

local OUTCOME_OPTIONS = {
	{ value = 'warning', label = 'Ekhtar' },
	{ value = 'citation', label = 'Jarime' },
	{ value = 'search', label = 'Bazresi' },
	{ value = 'escalated', label = 'Ershad Be Dastgiri' },
}

local function safeNow()
	if GetServerUnixTime then return GetServerUnixTime() end
	return 0
end

-- ============================================================
-- BOLO hit alert -- upgrades CAD's existing chat-only notify with
-- a native popup + sound. Fires for ANY plate check on this client
-- (whether triggered from here or from the /cad panel itself), so
-- everyone checking plates gets the louder alert for free.
-- ============================================================

RegisterNetEvent('CrimeScene:plateCheckResult')
AddEventHandler('CrimeScene:plateCheckResult', function(isHit, plate, caseId)
	if isHit then
		PlaySoundFrontend(-1, 'Text_Arrive_Tone', 'Phone_SoundSet_Default', true)
		lib.alertDialog({
			header = '🚨 BOLO HIT',
			content = 'Pelake **' .. plate .. '** Marbut Be Parvande-ye CAD #' .. caseId .. ' Ast!\nEhtiat Konid Va Az Backup Comak Bekhahid.',
			centered = true,
		})
	else
		ESX.ShowNotification("~g~Hich BOLO-i Baraye Pelake " .. plate .. " Sabt Nashode")
	end
end)

local function checkPlateForBolo(plate)
	if not plate or plate == '' then return end
	TriggerServerEvent('CrimeScene:checkPlate', plate)
end

-- ============================================================
-- Log a new stop
-- ============================================================

function OpenTrafficStopMenu()
	local options = {
		{
			title = 'Sabt-e Tavaghof-e Jadid',
			icon = 'car-burst',
			onSelect = function()
				local input = lib.inputDialog('Sabt-e Tavaghof', {
					{ type = 'input', label = 'ID Ya Esm-e Shahrvand (Ekhtiari)' },
					{ type = 'input', label = 'Dalil-e Tavaghof', required = true },
					{ type = 'input', label = 'Pelak (Ekhtiari -- Baraye Check-e BOLO)' },
					{ type = 'input', label = 'Tozihat-e Ezafi (Ekhtiari)' },
				})
				if not input then return end

				-- Fire the BOLO check right away, in parallel -- doesn't
				-- block picking the outcome below, the alert (if any)
				-- shows up on its own via the listener above.
				if input[3] and input[3] ~= '' then
					checkPlateForBolo(input[3])
				end

				local outcomeOptions = {}
				for _, o in ipairs(OUTCOME_OPTIONS) do
					outcomeOptions[#outcomeOptions + 1] = {
						title = o.label,
						icon = 'clipboard-check',
						onSelect = function()
							local coords = GetEntityCoords(PlayerPedId())
							local streetHash = GetStreetNameAtCoord(coords.x, coords.y, coords.z)
							local location = GetStreetNameFromHashKey(streetHash)
							TriggerServerEvent('esx_uniquejobs:logTrafficStop', input[1], input[2], o.value, input[4], location, input[3])
						end,
					}
				end
				lib.registerContext({ id = 'traffic_stop_outcome', title = 'Natije-ye Tavaghof', menu = 'law_main', options = outcomeOptions })
				lib.showContext('traffic_stop_outcome')
			end,
		},
		{
			title = 'Barresi Pelak (BOLO)',
			description = 'Check-e Sari-e Yek Pelak Bedone Sabt-e Tavaghof',
			icon = 'magnifying-glass',
			onSelect = function()
				OpenBoloCheckMenu()
			end,
		},
		{
			title = 'BOLO-haye Active',
			description = 'Fehrest-e Hame-ye BOLO-haye In Lahze (Az /cad)',
			icon = 'triangle-exclamation',
			onSelect = function()
				OpenActiveBolosMenu()
			end,
		},
		{
			title = 'Tarikhche-ye Tavaghof-ha',
			icon = 'clock-rotate-left',
			onSelect = function()
				OpenTrafficStopHistory()
			end,
		},
	}

	lib.registerContext({ id = 'traffic_stop_main', title = 'Sabt-e Tavaghof', menu = 'law_main', options = options })
	lib.showContext('traffic_stop_main')
end

-- ============================================================
-- CAD BOLO helpers (reused directly by /law's main menu too)
-- ============================================================

function OpenBoloCheckMenu()
	local input = lib.inputDialog('Barresi Pelak (BOLO)', { { type = 'input', label = 'Pelak', required = true } })
	if input and input[1] then
		checkPlateForBolo(input[1])
	end
end

function OpenActiveBolosMenu()
	ESX.TriggerServerCallback('CrimeScene:getActiveBOLOs', function(bolos)
		bolos = bolos or {}
		local options = {}

		if #bolos == 0 then
			options[#options + 1] = { title = 'Hich BOLO-ye Active-i Nist', disabled = true, icon = 'circle-info' }
		else
			for _, b in ipairs(bolos) do
				local minutesAgo = math.floor((safeNow() - b.issuedAt) / 60)
				options[#options + 1] = {
					title = 'Pelak: ' .. b.plate,
					description = 'Parvande CAD #' .. b.caseId .. ' | Sader Konande: ' .. b.issuedBy .. ' | ' .. minutesAgo .. ' Daghighe Pish',
					icon = 'car-side',
					disabled = true,
				}
			end
		end

		lib.registerContext({ id = 'law_active_bolos', title = 'BOLO-haye Active', menu = 'traffic_stop_main', options = options })
		lib.showContext('law_active_bolos')
	end)
end

-- ============================================================
-- History
-- ============================================================

function OpenTrafficStopHistory()
	ESX.TriggerServerCallback('esx_uniquejobs:getTrafficStops', function(stops)
		stops = stops or {}
		local options = {}

		if #stops == 0 then
			options[#options + 1] = { title = 'Hich Tavaghofi Sabt Nashode', disabled = true, icon = 'circle-info' }
		else
			for _, s in ipairs(stops) do
				options[#options + 1] = {
					title = s.citizen_name .. ' -- ' .. s.outcomeLabel,
					description = s.reason .. (s.plate and s.plate ~= '' and (' | Pelak: ' .. s.plate) or '') .. ' | Afsar: ' .. s.officer_name .. (s.location and (' | ' .. s.location) or '') .. (s.notes and s.notes ~= '' and (' | ' .. s.notes) or ''),
					icon = 'car-burst',
					disabled = true,
				}
			end
		end

		lib.registerContext({ id = 'traffic_stop_history', title = 'Tarikhche-ye Tavaghof-ha', menu = 'traffic_stop_main', options = options })
		lib.showContext('traffic_stop_history')
	end, false)
end
