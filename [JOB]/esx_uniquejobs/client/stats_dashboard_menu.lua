-- ============================================================
-- Statistics Dashboard menu (feature #6)
-- Reached from /doj's main menu ("Dashboard-e Amari"). Renders
-- simple unicode bar-charts inside ox_lib option descriptions --
-- no extra NUI/HTML needed, works everywhere the rest of /doj
-- already works.
-- ============================================================

local BAR_CHARS = '▏▎▍▌▋▊▉█'

local function bar(value, maxValue, width)
	width = width or 20
	if maxValue <= 0 then maxValue = 1 end
	local filled = math.floor((value / maxValue) * width)
	if filled < 0 then filled = 0 end
	if filled > width then filled = width end
	return string.rep('█', filled) .. string.rep('░', width - filled)
end

local function dayLabel(unixDay)
	return os.date('%m/%d', unixDay)
end

function OpenStatsDashboardMenu()
	ESX.TriggerServerCallback('esx_uniquejobs:dojGetStats', function(stats)
		if not stats then
			ESX.ShowNotification("~r~Dastresi Nadarid")
			return
		end

		local options = {
			{
				title = 'Jarayem Bar Asas-e No (Top 10)',
				icon = 'chart-column',
				disabled = true,
			},
		}

		local maxType = 0
		for _, row in ipairs(stats.crimesByType) do
			if row.count > maxType then maxType = row.count end
		end
		if #stats.crimesByType == 0 then
			options[#options + 1] = { title = 'Dadei Vojood Nadarad', disabled = true, icon = 'circle-info' }
		else
			for _, row in ipairs(stats.crimesByType) do
				options[#options + 1] = {
					title = row.label,
					description = bar(row.count, maxType) .. '  ' .. row.count,
					icon = 'gavel',
					disabled = true,
				}
			end
		end

		options[#options + 1] = { title = 'Rond-e Dastgiri-ha (14 Rooz-e Akhar)', icon = 'chart-line', disabled = true }
		local maxDay = 0
		for _, row in ipairs(stats.arrestsByDay) do
			if row.count > maxDay then maxDay = row.count end
		end
		if #stats.arrestsByDay == 0 then
			options[#options + 1] = { title = 'Dadei Vojood Nadarad', disabled = true, icon = 'circle-info' }
		else
			for _, row in ipairs(stats.arrestsByDay) do
				options[#options + 1] = {
					title = dayLabel(row.day),
					description = bar(row.count, maxDay) .. '  ' .. row.count,
					icon = 'handcuffs',
					disabled = true,
				}
			end
		end

		options[#options + 1] = { title = 'Faal-tarin Afsaran', icon = 'ranking-star', disabled = true }
		local maxOfficer = 0
		for _, row in ipairs(stats.topOfficers) do
			if row.count > maxOfficer then maxOfficer = row.count end
		end
		if #stats.topOfficers == 0 then
			options[#options + 1] = { title = 'Dadei Vojood Nadarad', disabled = true, icon = 'circle-info' }
		else
			for i, row in ipairs(stats.topOfficers) do
				options[#options + 1] = {
					title = '#' .. i .. ' ' .. row.label,
					description = bar(row.count, maxOfficer) .. '  ' .. row.count .. ' Dastgiri',
					icon = 'user-shield',
					disabled = true,
				}
			end
		end

		lib.registerContext({ id = 'doj_stats_dashboard', title = 'Dashboard-e Amari', menu = 'doj_main', options = options })
		lib.showContext('doj_stats_dashboard')
	end)
end
