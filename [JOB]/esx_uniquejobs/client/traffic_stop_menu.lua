-- ============================================================
-- Traffic Stop Log menu (feature #9)
-- Reached from /law's main menu ("Sabt-e Tavaghof"). Lightweight
-- log for routine stops that don't need a full Booking.
-- ============================================================

local OUTCOME_OPTIONS = {
	{ value = 'warning', label = 'Ekhtar' },
	{ value = 'citation', label = 'Jarime' },
	{ value = 'search', label = 'Bazresi' },
	{ value = 'escalated', label = 'Ershad Be Dastgiri' },
}

function OpenTrafficStopMenu()
	local options = {
		{
			title = 'Sabt-e Tavaghof-e Jadid',
			icon = 'car-burst',
			onSelect = function()
				local input = lib.inputDialog('Sabt-e Tavaghof', {
					{ type = 'input', label = 'ID Ya Esm-e Shahrvand (Ekhtiari)' },
					{ type = 'input', label = 'Dalil-e Tavaghof', required = true },
				})
				if not input then return end

				local outcomeOptions = {}
				for _, o in ipairs(OUTCOME_OPTIONS) do
					outcomeOptions[#outcomeOptions + 1] = {
						title = o.label,
						icon = 'clipboard-check',
						onSelect = function()
							local coords = GetEntityCoords(PlayerPedId())
							local streetHash = GetStreetNameAtCoord(coords.x, coords.y, coords.z)
							local location = GetStreetNameFromHashKey(streetHash)
							TriggerServerEvent('esx_uniquejobs:logTrafficStop', input[1], input[2], o.value, nil, location)
						end,
					}
				end
				lib.registerContext({ id = 'traffic_stop_outcome', title = 'Natije-ye Tavaghof', menu = 'law_main', options = outcomeOptions })
				lib.showContext('traffic_stop_outcome')
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
					description = s.reason .. ' | Afsar: ' .. s.officer_name .. (s.location and (' | ' .. s.location) or ''),
					icon = 'car-burst',
					disabled = true,
				}
			end
		end

		lib.registerContext({ id = 'traffic_stop_history', title = 'Tarikhche-ye Tavaghof-ha', menu = 'traffic_stop_main', options = options })
		lib.showContext('traffic_stop_history')
	end, false)
end
