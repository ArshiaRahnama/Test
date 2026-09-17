-- ============================================================
-- Court Docket menu (feature #4)
-- Reached from /doj's main menu ("Taghvim-e Dadgah") and from a
-- case's detail menu ("Zamanbandi Jalase-ye Dadgah"). Uses the
-- same ox_lib context pattern as the rest of client/doj_menu.lua.
-- ============================================================

local dojJob = nil
local DOJ_JOBS = DojJobSet -- shared/departments.lua (was a hardcoded duplicate)

local function safeNow()
	if GetServerUnixTime then return GetServerUnixTime() end
	return 0
end

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
	dojJob = DOJ_JOBS[job.name] and job.name or nil
end)

Citizen.CreateThread(function()
	while ESX == nil do Citizen.Wait(200) end
	while ESX.GetPlayerData().job == nil do Citizen.Wait(200) end
	dojJob = DOJ_JOBS[ESX.GetPlayerData().job.name] and ESX.GetPlayerData().job.name or nil
end)

local DOCKET_STATUS_ICON = {
	scheduled = 'clock',
	held = 'circle-check',
	rescheduled = 'clock-rotate-left',
	cancelled = 'ban',
}

local VERDICT_OPTIONS = {
	{ value = 'guilty', label = 'Mojrem (Guilty)' },
	{ value = 'not_guilty', label = 'Bi-Gonah (Not Guilty)' },
	{ value = 'plea_deal', label = 'Tavafogh (Plea Deal)' },
}

-- Called from client/doj_menu.lua's case detail menu
function OpenScheduleHearingForCase(caseId)
	local input = lib.inputDialog('Zamanbandi Jalase-ye Dadgah', {
		{ type = 'number', label = 'Chand Daghighe-ye Digar?', default = 10, required = true },
	})
	if input and input[1] then
		TriggerServerEvent('esx_uniquejobs:dojScheduleHearing', caseId, input[1])
	end
end

local function openDocketRow(docket)
	local options = {
		{
			title = docket.case_title,
			description = 'Parvande #' .. docket.case_id .. ' | Vaziat: ' .. docket.statusLabel,
			icon = DOCKET_STATUS_ICON[docket.status] or 'gavel',
			disabled = true,
		},
	}

	if docket.verdict then
		options[#options + 1] = {
			title = 'Hokm: ' .. docket.verdictLabel,
			description = docket.verdict_by_name and ('Sader Shode Tavasote: ' .. docket.verdict_by_name) or nil,
			icon = 'scale-balanced',
			disabled = true,
		}
	end

	if docket.status == 'scheduled' or docket.status == 'rescheduled' then
		options[#options + 1] = {
			title = 'Taghire Zaman',
			icon = 'clock-rotate-left',
			onSelect = function()
				local input = lib.inputDialog('Taghire Zaman', { { type = 'number', label = 'Chand Daghighe-ye Digar?', default = 10, required = true } })
				if input and input[1] then
					TriggerServerEvent('esx_uniquejobs:dojRescheduleHearing', docket.id, input[1])
				end
			end,
		}
		options[#options + 1] = {
			title = 'Laghv Kardan-e Jalase',
			icon = 'ban',
			onSelect = function()
				local alert = lib.alertDialog({ header = 'Laghv-e Jalase', content = 'Motmaen Hastid?', centered = true, cancel = true })
				if alert == 'confirm' then
					TriggerServerEvent('esx_uniquejobs:dojCancelHearing', docket.id)
				end
			end,
		}

		if dojJob == 'judge' then
			local verdictOptions = {}
			for _, v in ipairs(VERDICT_OPTIONS) do
				verdictOptions[#verdictOptions + 1] = {
					title = v.label,
					icon = 'gavel',
					onSelect = function()
						local input = lib.inputDialog('Sabt-e Hokm -- ' .. v.label, { { type = 'input', label = 'Tozihat (Ekhtiari)' } })
						TriggerServerEvent('esx_uniquejobs:dojRecordVerdict', docket.id, v.value, input and input[1] or '')
					end,
				}
			end
			options[#options + 1] = {
				title = 'Sodoor-e Hokm-e Nahaee',
				icon = 'gavel',
				menu = 'docket_verdict_' .. docket.id,
			}
			lib.registerContext({ id = 'docket_verdict_' .. docket.id, title = 'Hokm-e Nahaee', menu = 'docket_row_' .. docket.id, options = verdictOptions })
		end
	end

	lib.registerContext({ id = 'docket_row_' .. docket.id, title = 'Jalase #' .. docket.id, menu = 'docket_list', options = options })
	lib.showContext('docket_row_' .. docket.id)
end

function OpenDocketMenu()
	-- BUG FIX: same stale-cache issue as client/doj_menu.lua's OpenDojMenu()
	-- -- dojJob only updated via the esx:setJob event handler above, which
	-- can miss a job change made through something else (an admin panel
	-- tool, most commonly). Re-derive it fresh from ESX.PlayerData.job here
	-- so this can never wrongly reject a player whose actual current job
	-- (what the HUD shows, what the server checks) is already correct.
	local livejob = ESX.GetPlayerData().job
	dojJob = (livejob and DOJ_JOBS[livejob.name]) and livejob.name or nil

	if not dojJob then
		ESX.ShowNotification("❌ Shoma Ozve DOJ Nistid!")
		return
	end

	ESX.TriggerServerCallback('esx_uniquejobs:dojGetDocket', function(docket)
		docket = docket or {}
		local options = {}

		if #docket == 0 then
			options[#options + 1] = { title = 'Hich Jalase-i Zamanbandi Nashode', disabled = true, icon = 'circle-info' }
		else
			for _, d in ipairs(docket) do
				local minutesLeft = math.floor((d.scheduled_at - safeNow()) / 60)
				options[#options + 1] = {
					title = d.case_title .. ' -- ' .. d.statusLabel,
					description = 'Parvande #' .. d.case_id .. (minutesLeft > 0 and (' | ' .. minutesLeft .. ' Daghighe Ta Shoroo') or ' | Zaman Resid')
						.. (d.verdict and (' | Hokm: ' .. d.verdictLabel) or ''),
					icon = DOCKET_STATUS_ICON[d.status] or 'gavel',
					onSelect = function()
						openDocketRow(d)
					end,
				}
			end
		end

		lib.registerContext({ id = 'docket_list', title = 'Taghvim-e Dadgah', menu = 'doj_main', options = options })
		lib.showContext('docket_list')
	end)
end
