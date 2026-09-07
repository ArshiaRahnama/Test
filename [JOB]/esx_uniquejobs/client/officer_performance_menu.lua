-- ============================================================
-- Officer Performance Review menu (feature #7)
-- Reached from /doj's main menu ("Barresi Amalkard Afsar").
-- Combines arrest/charge counts, leaderboard rank, and Internal
-- Affairs history into one profile.
-- ============================================================

function OpenOfficerProfileMenu()
	local input = lib.inputDialog('Barresi Amalkard Afsar', { { type = 'input', label = 'ID Ya Esm-e Afsar', required = true } })
	if not input or not input[1] then return end

	ESX.TriggerServerCallback('esx_uniquejobs:dojGetOfficerProfile', function(profile)
		if not profile then
			ESX.ShowNotification("~r~Afsar Peida Nashod")
			return
		end

		local options = {
			{
				title = profile.name,
				description = 'Rotbe: #' .. profile.rank .. ' Az ' .. profile.totalOfficers .. ' Afsar (Bar Asas-e Dastgiri)',
				icon = 'user-shield',
				disabled = true,
			},
			{
				title = profile.arrests .. ' Dastgiri | ' .. profile.charges .. ' Etteham',
				description = 'Majmoo-e Sabt-e Sabeghe',
				icon = 'handcuffs',
				disabled = true,
			},
			{
				title = 'Sabeghe-ye IA: ' .. profile.iaCounts.open .. ' Baz, ' .. profile.iaCounts.reviewing .. ' Dar Hale Barresi, '
					.. profile.iaCounts.cleared .. ' Takhie, ' .. profile.iaCounts.disciplined .. ' Tanbih',
				icon = 'user-shield',
				disabled = true,
			},
		}

		if #profile.iaHistory == 0 then
			options[#options + 1] = { title = 'Hich Gozaresh-e IA-i Sabt Nashode', disabled = true, icon = 'circle-info' }
		else
			for _, report in ipairs(profile.iaHistory) do
				options[#options + 1] = {
					title = '[' .. report.statusLabel .. '] ' .. report.category,
					description = report.description,
					icon = 'file-shield',
					disabled = true,
				}
			end
		end

		lib.registerContext({ id = 'doj_officer_profile', title = 'Amalkard-e Afsar', menu = 'doj_main', options = options })
		lib.showContext('doj_officer_profile')
	end, input[1])
end
