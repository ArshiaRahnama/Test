-- ============================================================
-- /doj -- one command for every DOJ job (marshal/judge/cia/cid/
-- fbi/doa). Shared tools at the top (criminal record check,
-- phone lookup, online roster, case files, law codebook), then
-- a section specific to whichever job the player currently has:
--   marshal/judge -> warrant requests + approval
--   fbi/cia       -> reuses the existing /agent menu wholesale
--                    (spectate, interrogation room, wiretap, tracker)
--   cid           -> log evidence to a case, refer a case
--   doa           -> seizure log, informant management
-- ============================================================

ESX = nil

local dojJob = nil -- 'marshal' | 'judge' | 'cia' | 'cid' | 'fbi' | 'doa' | nil
local DOJ_JOBS = { marshal = true, judge = true, cia = true, cid = true, fbi = true, doa = true }

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

	CheckDojJob()
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
	dojJob = DOJ_JOBS[job.name] and job.name or nil
end)

function CheckDojJob()
	if ESX.PlayerData and ESX.PlayerData.job then
		local name = ESX.PlayerData.job.name
		dojJob = DOJ_JOBS[name] and name or nil
	end
end

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(1000)
		if ESX ~= nil and ESX.GetPlayerData().job ~= nil then
			CheckDojJob()
			break
		end
	end
end)

-- ============================================================
-- Law codebook -- persistent, judge-editable, categorized
-- (server/law_codebook.lua). Judges get Add/Edit/Delete/Recategorize;
-- everyone else sees a read-only, grouped, searchable list with an
-- "Issue Ticket" action, same as /law for police/sheriff/mt.
-- ============================================================

local CODEBOOK_CATEGORIES = {
	traffic = { label = 'Ranandegi', icon = 'car' },
	property = { label = 'Amval', icon = 'house' },
	violent = { label = 'Khoshoonat', icon = 'hand-fist' },
	drug = { label = 'Mavad-e Mokhader', icon = 'pills' },
	weapons = { label = 'Salah', icon = 'gun' },
	other = { label = 'Sayer', icon = 'file-lines' },
}

local function lawLine(law)
	return 'Jarime: $' .. law.fine .. (law.jail_minutes > 0 and (' | Zendan: ' .. law.jail_minutes .. ' Daghighe') or ' | Bedoon-e Zendan')
end

function OpenLawRowMenu(law, canEdit, backMenuId)
	local rowOptions = {
		{
			title = 'Sodoor Jarime',
			icon = 'money-bill',
			onSelect = function()
				local input = lib.inputDialog('Sodoor Jarime -- ' .. law.title, { { type = 'number', label = 'ID Bazikon', required = true } })
				if input and input[1] then
					TriggerServerEvent('esx_uniquejobs:issueTicketFromLaw', law.id, input[1])
				end
			end,
		},
	}

	if canEdit then
		rowOptions[#rowOptions + 1] = {
			title = 'Virayesh',
			icon = 'pen',
			onSelect = function()
				local input = lib.inputDialog('Virayesh-e Ghanoon', {
					{ type = 'input', label = 'Onvan', default = law.title, required = true },
					{ type = 'number', label = 'Jarime ($)', default = law.fine, required = true },
					{ type = 'number', label = 'Zendan (Daghighe)', default = law.jail_minutes },
				})
				if input and input[1] then
					TriggerServerEvent('esx_uniquejobs:judgeEditLaw', law.id, input[1], input[2], input[3])
					OpenCodebookMenu()
				end
			end,
		}

		local categoryOptions = {}
		for key, cat in pairs(CODEBOOK_CATEGORIES) do
			categoryOptions[#categoryOptions + 1] = {
				title = cat.label,
				icon = key == law.category and 'check' or cat.icon,
				onSelect = function()
					TriggerServerEvent('esx_uniquejobs:judgeSetLawCategory', law.id, key)
					OpenCodebookMenu()
				end,
			}
		end
		rowOptions[#rowOptions + 1] = {
			title = 'Taghire Dastebandi',
			icon = 'tags',
			menu = 'doj_law_recat_' .. law.id,
		}
		lib.registerContext({ id = 'doj_law_recat_' .. law.id, title = 'Dastebandi', menu = 'doj_law_row_' .. law.id, options = categoryOptions })

		rowOptions[#rowOptions + 1] = {
			title = 'Hazf',
			icon = 'trash',
			onSelect = function()
				local alert = lib.alertDialog({ header = 'Hazf-e Ghanoon', content = 'Motmaen Hastid?', centered = true, cancel = true })
				if alert == 'confirm' then
					TriggerServerEvent('esx_uniquejobs:judgeDeleteLaw', law.id)
					OpenCodebookMenu()
				end
			end,
		}
	end

	lib.registerContext({ id = 'doj_law_row_' .. law.id, title = law.code .. ' -- ' .. law.title, menu = backMenuId, options = rowOptions })
	lib.showContext('doj_law_row_' .. law.id)
end

function OpenCodebookMenu()
	ESX.TriggerServerCallback('esx_uniquejobs:getCodebook', function(laws, canEdit)
		laws = laws or {}
		local options = {}

		if canEdit then
			options[#options + 1] = {
				title = 'Ezafe Kardan-e Ghanoon-e Jadid',
				icon = 'plus',
				onSelect = function()
					local categorySelect = {}
					for key, cat in pairs(CODEBOOK_CATEGORIES) do
						categorySelect[#categorySelect + 1] = { value = key, label = cat.label }
					end
					local input = lib.inputDialog('Ghanoon-e Jadid', {
						{ type = 'input', label = 'Code (masalan §13)', required = true },
						{ type = 'input', label = 'Onvan', required = true },
						{ type = 'select', label = 'Dastebandi', options = categorySelect, required = true },
						{ type = 'number', label = 'Jarime ($)', required = true },
						{ type = 'number', label = 'Zendan (Daghighe, 0 Agar Nadarad)', default = 0 },
					})
					if input and input[1] then
						TriggerServerEvent('esx_uniquejobs:judgeAddLaw', input[1], input[2], input[3], input[4], input[5])
						OpenCodebookMenu()
					end
				end,
			}
		end

		options[#options + 1] = {
			title = 'Jostoju Dar Ghanoon-name',
			icon = 'magnifying-glass',
			onSelect = function()
				local input = lib.inputDialog('Jostoju', { { type = 'input', label = 'Code Ya Onvan', required = true } })
				if input and input[1] then
					local query = string.lower(input[1])
					local results = {}
					for _, law in ipairs(laws) do
						if string.find(string.lower(law.title), query, 1, true) or string.find(string.lower(law.code), query, 1, true) then
							results[#results + 1] = {
								title = law.code .. ' -- ' .. law.title,
								description = lawLine(law),
								icon = 'gavel',
								onSelect = function()
									OpenLawRowMenu(law, canEdit, 'doj_codebook')
								end,
							}
						end
					end
					if #results == 0 then
						results[#results + 1] = { title = 'Chizi Peida Nashod', disabled = true, icon = 'circle-info' }
					end
					lib.registerContext({ id = 'doj_law_search', title = 'Natije-ye Jostoju', menu = 'doj_codebook', options = results })
					lib.showContext('doj_law_search')
				end
			end,
		}

		for key, cat in pairs(CODEBOOK_CATEGORIES) do
			local count = 0
			for _, law in ipairs(laws) do
				if law.category == key then count = count + 1 end
			end

			options[#options + 1] = {
				title = cat.label .. ' (' .. count .. ')',
				icon = cat.icon,
				menu = 'doj_codebook_cat_' .. key,
			}

			local catOptions = {}
			for _, law in ipairs(laws) do
				if law.category == key then
					catOptions[#catOptions + 1] = {
						title = law.code .. ' -- ' .. law.title,
						description = lawLine(law),
						icon = 'gavel',
						onSelect = function()
							OpenLawRowMenu(law, canEdit, 'doj_codebook_cat_' .. key)
						end,
					}
				end
			end
			if #catOptions == 0 then
				catOptions[#catOptions + 1] = { title = 'Khali Ast', disabled = true, icon = 'circle-info' }
			end
			lib.registerContext({ id = 'doj_codebook_cat_' .. key, title = cat.label, menu = 'doj_codebook', options = catOptions })
		end

		lib.registerContext({ id = 'doj_codebook', title = 'Ghanoon-name', menu = 'doj_main', options = options })
		lib.showContext('doj_codebook')
	end)
end

-- ============================================================
-- Main menu
-- ============================================================

function OpenDojMenu()
	if not dojJob then
		ESX.ShowNotification("❌ Shoma Ozve DOJ Nistid!")
		return
	end

	local options = {}

	options[#options + 1] = {
		title = 'DOJ Operations',
		description = 'Shoghl-e Feli: ' .. string.upper(dojJob),
		icon = 'scale-balanced',
		disabled = true,
	}

	-- Shared, all DOJ jobs
	options[#options + 1] = {
		title = 'Sabeghe-ye Kayfari (Background Check)',
		description = 'Dastgiri-ha, Etteham-ha Va Jarayem-e Pardakht-Nashode',
		icon = 'file-shield',
		onSelect = function()
			local input = lib.inputDialog('Sabeghe-ye Kayfari', { { type = 'input', label = 'ID Ya Esm-e Bazikon', required = true } })
			if input and input[1] then
				RecordSearchReturnMenu = 'doj_main'
				TriggerServerEvent('esx_uniquejobs:menuGetCriminalRecord', input[1])
			end
		end,
	}

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
		title = 'Parvande-ha (Cases)',
		description = 'Baz Kardan, Yaddasht Ezafe Kardan, Erja Dadan',
		icon = 'folder-open',
		onSelect = function()
			OpenCasesMenu()
		end,
	}

	options[#options + 1] = {
		title = 'Ghanoon-name (Codebook)',
		description = dojJob == 'judge'
			and 'Jarayem Va Jarime/Zendan -- Shoma Mitavanid Virayesh Konid'
			or 'Jarayem Va Jarime/Zendan-e Marboote',
		icon = 'book',
		onSelect = function()
			OpenCodebookMenu()
		end,
	}

	options[#options + 1] = {
		title = 'Afsaran-e Online DOJ',
		description = 'Hamkaran-e DOJ Ke Alan Online Hastand',
		icon = 'users',
		onSelect = function()
			OpenDojRosterMenu()
		end,
	}

	-- Job-specific
	if dojJob == 'marshal' or dojJob == 'judge' then
		options[#options + 1] = {
			title = 'Hokm-ha (Warrants)',
			description = 'Darkhast-e Hokm-e Jadid Ya Barresi-e Darkhast-ha',
			icon = 'gavel',
			onSelect = function()
				OpenWarrantsMenu()
			end,
		}
	end

	if dojJob == 'fbi' or dojJob == 'cia' then
		options[#options + 1] = {
			title = 'Amaliyat-e Vizhe (' .. string.upper(dojJob) .. ')',
			description = 'Nezarat, Otagh-e Bazjuyi, Shenood, Tracker',
			icon = dojJob == 'fbi' and 'user-secret' or 'user-shield',
			onSelect = function()
				OpenAgentMenu()
			end,
		}
	end

	if dojJob == 'cid' then
		options[#options + 1] = {
			title = 'Sabt-e Madrak Dar Parvande',
			description = 'Ezafe Kardan-e Madrak Be Yek Parvande-ye Baz',
			icon = 'magnifying-glass-chart',
			onSelect = function()
				OpenCasesMenu(true)
			end,
		}
	end

	if dojJob == 'doa' then
		options[#options + 1] = {
			title = 'Sabt-e Zabti (Seizure Log)',
			icon = 'box-archive',
			onSelect = function()
				local nameInput = lib.inputDialog('Sabt-e Zabti', {
					{ type = 'input', label = 'Esm-e Zabti', required = true },
					{ type = 'number', label = 'Tedad', default = 1, required = true },
					{ type = 'number', label = 'Arzesh-e Takhmini ($)', required = true },
					{ type = 'input', label = 'ID Ya Esm-e Mozanne (Ekhtiari)' },
				})
				if nameInput and nameInput[1] then
					TriggerServerEvent('esx_uniquejobs:doaLogSeizure', nameInput[1], nameInput[2], nameInput[3], nameInput[4])
				end
			end,
		}

		options[#options + 1] = {
			title = 'Sabeghe-ye Zabti-ha',
			icon = 'boxes-stacked',
			onSelect = function()
				OpenSeizuresMenu()
			end,
		}

		options[#options + 1] = {
			title = 'Modiriyat-e Khabarchin (Informants)',
			icon = 'user-secret',
			onSelect = function()
				OpenInformantsMenu()
			end,
		}
	end

	lib.registerContext({ id = 'doj_main', title = 'DOJ Menu', options = options })
	lib.showContext('doj_main')
end

RegisterCommand('doj', function()
	OpenDojMenu()
end, false)

-- ============================================================
-- Online DOJ roster
-- ============================================================

function OpenDojRosterMenu()
	ESX.TriggerServerCallback('esx_uniquejobs:dojGetRoster', function(roster)
		local options = {}

		if roster and #roster > 0 then
			for _, member in ipairs(roster) do
				options[#options + 1] = {
					title = string.gsub(member.name, "_", " "),
					description = member.job .. (member.gradeLabel and (' | ' .. member.gradeLabel) or '') .. ' | ID: ' .. member.id,
					icon = 'user',
					disabled = true,
				}
			end
		else
			options[#options + 1] = { title = 'Hich Kasi Digari Online Nist', disabled = true, icon = 'circle-info' }
		end

		lib.registerContext({ id = 'doj_roster', title = 'Afsaran-e Online DOJ', menu = 'doj_main', options = options })
		lib.showContext('doj_roster')
	end)
end

-- ============================================================
-- Case files (expanded: multiple suspects, charges from the
-- codebook, richer status, separate notes/evidence)
-- ============================================================

local CASE_STATUS_OPTIONS = {
	{ value = 'open', label = 'Baz' },
	{ value = 'investigating', label = 'Dar Hale Tahghigh' },
	{ value = 'trial', label = 'Dar Hale Mohakeme' },
	{ value = 'closed', label = 'Baste Shode' },
	{ value = 'dismissed', label = 'Rad Shode' },
}

local CASE_PRIORITY_OPTIONS = {
	{ value = 'low', label = 'Paeen', icon = 'arrow-down' },
	{ value = 'medium', label = 'Motevaset', icon = 'minus' },
	{ value = 'high', label = 'Bala', icon = 'arrow-up' },
}

local function priorityIcon(priority)
	for _, p in ipairs(CASE_PRIORITY_OPTIONS) do
		if p.value == priority then return p.icon end
	end
	return 'minus'
end

local function statusLabelFor(status)
	for _, s in ipairs(CASE_STATUS_OPTIONS) do
		if s.value == status then return s.label end
	end
	return status
end

function OpenCasesMenu(evidenceMode, filterStatus, searchSuspect)
	ESX.TriggerServerCallback('esx_uniquejobs:dojGetCases', function(cases)
		local options = {
			{
				title = 'Parvande-ye Jadid',
				icon = 'plus',
				onSelect = function()
					local priorityInput = {}
					for _, p in ipairs(CASE_PRIORITY_OPTIONS) do
						priorityInput[#priorityInput + 1] = { value = p.value, label = p.label }
					end
					local input = lib.inputDialog('Parvande-ye Jadid', {
						{ type = 'input', label = 'Onvan-e Parvande', required = true },
						{ type = 'select', label = 'Ahamiyat', options = priorityInput, default = 'medium', required = true },
						{ type = 'input', label = 'ID Ya Esm-e Mozanne-ye Avval (Ekhtiari)' },
					})
					if input and input[1] then
						TriggerServerEvent('esx_uniquejobs:dojOpenCase', input[1], input[2], input[3])
					end
				end,
			},
			{
				title = 'Jostoju Bar Asas-e Mozanne',
				icon = 'magnifying-glass',
				onSelect = function()
					local input = lib.inputDialog('Jostoju', { { type = 'input', label = 'Esm-e Mozanne', required = true } })
					if input and input[1] then
						OpenCasesMenu(evidenceMode, nil, input[1])
					end
				end,
			},
			{
				title = 'Filter Bar Asas-e Vaziat',
				icon = 'filter',
				menu = 'doj_cases_filter',
			},
		}

		local filterOptions = { { title = 'Hame', icon = 'list', onSelect = function() OpenCasesMenu(evidenceMode) end } }
		for _, s in ipairs(CASE_STATUS_OPTIONS) do
			filterOptions[#filterOptions + 1] = {
				title = s.label,
				icon = s.value == filterStatus and 'check' or 'circle',
				onSelect = function()
					OpenCasesMenu(evidenceMode, s.value)
				end,
			}
		end
		lib.registerContext({ id = 'doj_cases_filter', title = 'Filter', menu = 'doj_cases', options = filterOptions })

		for _, case in ipairs(cases or {}) do
			local ageMinutes = math.floor((os.time() - case.created_at) / 60)
			options[#options + 1] = {
				title = '#' .. case.id .. ' -- ' .. case.title,
				description = 'Vaziat: ' .. statusLabelFor(case.status) .. ' | Massol: ' .. case.lead_officer_name
					.. ' | ' .. ageMinutes .. ' Daghighe Pish'
					.. (case.referred_to and (' | Erja Shode Be ' .. case.referred_to) or ''),
				icon = priorityIcon(case.priority),
				onSelect = function()
					OpenCaseDetailMenu(case.id, evidenceMode)
				end,
			}
		end

		if #cases == 0 then
			options[#options + 1] = { title = 'Hich Parvande-i Peida Nashod', disabled = true, icon = 'circle-info' }
		end

		lib.registerContext({ id = 'doj_cases', title = evidenceMode and 'Entekhab-e Parvande' or 'Parvande-ha', menu = 'doj_main', options = options })
		lib.showContext('doj_cases')
	end, filterStatus, searchSuspect)
end

function OpenCaseDetailMenu(caseId, evidenceMode)
	ESX.TriggerServerCallback('esx_uniquejobs:dojGetCaseDetail', function(case)
		if not case then
			ESX.ShowNotification("~r~Parvande Peida Nashod")
			return
		end

		local options = {
			{
				title = case.title,
				description = 'Vaziat: ' .. case.statusLabel .. ' | Massol: ' .. case.leadOfficerName .. ' | Baz Konande: ' .. case.openedByName
					.. ' | ' .. case.ageMinutes .. ' Daghighe Pish',
				icon = priorityIcon(case.priority),
				disabled = true,
			},
			{
				title = 'Massol Shodan-e In Parvande',
				description = 'Feli: ' .. case.leadOfficerName,
				icon = 'user-tie',
				onSelect = function()
					TriggerServerEvent('esx_uniquejobs:dojAssignLead', caseId)
					OpenCaseDetailMenu(caseId, evidenceMode)
				end,
			},
		}

		local priorityRowOptions = {}
		for _, p in ipairs(CASE_PRIORITY_OPTIONS) do
			priorityRowOptions[#priorityRowOptions + 1] = {
				title = p.label,
				icon = p.value == case.priority and 'check' or p.icon,
				onSelect = function()
					TriggerServerEvent('esx_uniquejobs:dojSetCasePriority', caseId, p.value)
				end,
			}
		end
		options[#options + 1] = {
			title = 'Taghire Ahamiyat (Feli: ' .. (case.priority and case.priority:sub(1,1):upper() .. case.priority:sub(2) or 'Motevaset') .. ')',
			icon = 'flag',
			menu = 'doj_case_priority_' .. caseId,
		}
		lib.registerContext({ id = 'doj_case_priority_' .. caseId, title = 'Ahamiyat', menu = 'doj_case_detail_' .. caseId, options = priorityRowOptions })

		-- Suspects
		local suspectNames = {}
		for _, s in ipairs(case.suspects) do
			suspectNames[#suspectNames + 1] = s.name
		end
		options[#options + 1] = {
			title = 'Mozannin: ' .. (#suspectNames > 0 and table.concat(suspectNames, ', ') or 'Hich Kas'),
			description = 'Baraye Ezafe Kardan-e Mozanne-ye Jadid Bezanid',
			icon = 'user-group',
			onSelect = function()
				local input = lib.inputDialog('Ezafe Kardan-e Mozanne', { { type = 'input', label = 'ID Ya Esm', required = true } })
				if input and input[1] then
					TriggerServerEvent('esx_uniquejobs:dojAddSuspect', caseId, input[1])
				end
				OpenCaseDetailMenu(caseId, evidenceMode)
			end,
		}

		-- Charges
		options[#options + 1] = {
			title = 'Etteham-ha (' .. #case.charges .. ')',
			description = #case.charges > 0 and ('Majmoo-e Jarime: $' .. case.totalFine .. ' | Majmoo-e Zendan: ' .. case.totalJail .. ' Daghighe') or 'Hich Ettehami Sabt Nashode',
			icon = 'scale-unbalanced',
			menu = 'doj_case_charges_' .. caseId,
		}

		local chargeOptions = {
			{
				title = 'Ezafe Kardan-e Etteham Az Ghanoon-name',
				icon = 'plus',
				onSelect = function()
					ESX.TriggerServerCallback('esx_uniquejobs:getCodebook', function(laws)
						local lawOptions = {}
						for _, law in ipairs(laws or {}) do
							lawOptions[#lawOptions + 1] = {
								title = law.code .. ' -- ' .. law.title,
								description = 'Jarime: $' .. law.fine,
								icon = 'gavel',
								onSelect = function()
									TriggerServerEvent('esx_uniquejobs:dojAddCharge', caseId, law.id)
								end,
							}
						end
						lib.registerContext({ id = 'doj_case_charge_pick_' .. caseId, title = 'Entekhab-e Ghanoon', menu = 'doj_case_charges_' .. caseId, options = lawOptions })
						lib.showContext('doj_case_charge_pick_' .. caseId)
					end)
				end,
			},
		}
		for _, charge in ipairs(case.charges) do
			chargeOptions[#chargeOptions + 1] = {
				title = charge.law_code .. ' -- ' .. charge.law_title,
				description = 'Jarime: $' .. charge.fine .. (charge.jail_minutes > 0 and (' | Zendan: ' .. charge.jail_minutes .. ' Daghighe') or ''),
				icon = 'gavel',
				disabled = true,
			}
		end
		lib.registerContext({ id = 'doj_case_charges_' .. caseId, title = 'Etteham-ha', menu = 'doj_case_detail_' .. caseId, options = chargeOptions })

		-- Notes / evidence
		options[#options + 1] = {
			title = 'Ezafe Kardan-e Yaddasht',
			icon = 'pen',
			onSelect = function()
				local input = lib.inputDialog('Yaddasht-e Jadid', { { type = 'input', label = 'Matn', required = true } })
				if input and input[1] then
					TriggerServerEvent('esx_uniquejobs:dojAddCaseNote', caseId, 'note', input[1])
				end
				OpenCaseDetailMenu(caseId, evidenceMode)
			end,
		}
		options[#options + 1] = {
			title = 'Ezafe Kardan-e Madrak',
			icon = 'magnifying-glass-chart',
			onSelect = function()
				local input = lib.inputDialog('Madrak-e Jadid', { { type = 'input', label = 'Matn', required = true } })
				if input and input[1] then
					TriggerServerEvent('esx_uniquejobs:dojAddCaseNote', caseId, 'evidence', input[1])
				end
				OpenCaseDetailMenu(caseId, evidenceMode)
			end,
		}

		if #case.notes == 0 then
			options[#options + 1] = { title = 'Hich Yaddasht/Madraki Sabt Nashode', disabled = true, icon = 'circle-info' }
		else
			for _, note in ipairs(case.notes) do
				options[#options + 1] = {
					title = (note.note_type == 'evidence' and '[MADRAK] ' or '[YADDASHT] ') .. note.text,
					description = 'Sabt Shode Tavasote: ' .. note.by_name,
					icon = note.note_type == 'evidence' and 'magnifying-glass-chart' or 'note-sticky',
					disabled = true,
				}
			end
		end

		-- Status
		local statusOptions = {}
		for _, s in ipairs(CASE_STATUS_OPTIONS) do
			statusOptions[#statusOptions + 1] = {
				title = s.label,
				icon = s.value == case.status and 'check' or 'circle',
				onSelect = function()
					TriggerServerEvent('esx_uniquejobs:dojSetCaseStatus', caseId, s.value)
				end,
			}
		end
		options[#options + 1] = {
			title = 'Taghire Vaziat (Feli: ' .. case.statusLabel .. ')',
			icon = 'list-check',
			menu = 'doj_case_status_' .. caseId,
		}
		lib.registerContext({ id = 'doj_case_status_' .. caseId, title = 'Taghire Vaziat', menu = 'doj_case_detail_' .. caseId, options = statusOptions })

		-- Refer
		options[#options + 1] = {
			title = 'Erja-e Parvande Be Departmani Digar',
			icon = 'share',
			onSelect = function()
				local jobOptions = { 'marshal', 'judge', 'cia', 'cid', 'fbi', 'doa' }
				local referOptions = {}
				for _, j in ipairs(jobOptions) do
					if j ~= dojJob then
						referOptions[#referOptions + 1] = {
							title = string.upper(j),
							icon = 'right-to-bracket',
							onSelect = function()
								TriggerServerEvent('esx_uniquejobs:dojReferCase', caseId, j)
							end,
						}
					end
				end
				lib.registerContext({ id = 'doj_case_refer_' .. caseId, title = 'Erja Be', menu = 'doj_case_detail_' .. caseId, options = referOptions })
				lib.showContext('doj_case_refer_' .. caseId)
			end,
		}

		lib.registerContext({ id = 'doj_case_detail_' .. caseId, title = 'Parvande #' .. caseId, menu = 'doj_cases', options = options })
		lib.showContext('doj_case_detail_' .. caseId)
	end, caseId)
end

-- ============================================================
-- Warrants (marshal/judge)
-- ============================================================

function OpenWarrantsMenu()
	ESX.TriggerServerCallback('esx_uniquejobs:dojGetWarrants', function(data)
		if not data then return end

		local options = {
			{
				title = 'Darkhast-e Hokm-e Jadid',
				icon = 'plus',
				onSelect = function()
					local input = lib.inputDialog('Darkhast-e Hokm', {
						{ type = 'select', label = 'Noe Hokm', options = { { value = 'arrest', label = 'Dastgiri' }, { value = 'search', label = 'Bazresi' } }, required = true },
						{ type = 'input', label = 'ID Ya Esm-e Hadaf', required = true },
						{ type = 'input', label = 'Dalil', required = true },
					})
					if input and input[1] then
						TriggerServerEvent('esx_uniquejobs:dojRequestWarrant', input[1], input[2], input[3])
					end
				end,
			},
		}

		if data.canApprove and #data.pending > 0 then
			options[#options + 1] = { title = 'Darkhast-haye Dar Entezar', disabled = true, icon = 'hourglass-half' }
			for _, w in ipairs(data.pending) do
				options[#options + 1] = {
					title = '#' .. w.id .. ' -- ' .. w.targetName .. ' (' .. w.warrantType .. ')',
					description = 'Dalil: ' .. w.reason .. ' | Az: ' .. w.requestedByName,
					icon = 'hourglass-half',
					menu = 'doj_warrant_decide_' .. w.id,
				}
				lib.registerContext({
					id = 'doj_warrant_decide_' .. w.id,
					title = 'Hokm #' .. w.id,
					menu = 'doj_warrants',
					options = {
						{
							title = 'Tayid (Approve)',
							icon = 'check',
							onSelect = function()
								TriggerServerEvent('esx_uniquejobs:dojDecideWarrant', w.id, 'approve')
							end,
						},
						{
							title = 'Rad (Deny)',
							icon = 'xmark',
							onSelect = function()
								TriggerServerEvent('esx_uniquejobs:dojDecideWarrant', w.id, 'deny')
							end,
						},
					},
				})
			end
		end

		if #data.active > 0 then
			options[#options + 1] = { title = 'Hokm-haye Faal', disabled = true, icon = 'circle-check' }
			for _, w in ipairs(data.active) do
				options[#options + 1] = {
					title = '#' .. w.id .. ' -- ' .. w.targetName .. ' (' .. w.warrantType .. ')',
					description = 'Dalil: ' .. w.reason,
					icon = 'file-shield',
					onSelect = data.canApprove and function()
						local alert = lib.alertDialog({ header = 'Bateel Kardan-e Hokm', content = 'Motmaen Hastid?', centered = true, cancel = true })
						if alert == 'confirm' then
							TriggerServerEvent('esx_uniquejobs:dojRevokeWarrant', w.id)
						end
					end or nil,
					disabled = not data.canApprove,
				}
			end
		end

		lib.registerContext({ id = 'doj_warrants', title = 'Hokm-ha', menu = 'doj_main', options = options })
		lib.showContext('doj_warrants')
	end)
end

-- ============================================================
-- DOA: Seizures
-- ============================================================

function OpenSeizuresMenu()
	ESX.TriggerServerCallback('esx_uniquejobs:doaGetSeizures', function(rows)
		local options = {}

		if rows and #rows > 0 then
			for _, s in ipairs(rows) do
				options[#options + 1] = {
					title = s.quantity .. 'x ' .. s.item_label .. ' ($' .. s.est_value .. ')',
					description = 'Az: ' .. (s.suspect_name or 'Na Moshakhas') .. ' | Afsar: ' .. s.officer_name,
					icon = 'box',
					disabled = true,
				}
			end
		else
			options[#options + 1] = { title = 'Hich Zabti Sabt Nashode', disabled = true, icon = 'circle-info' }
		end

		lib.registerContext({ id = 'doj_seizures', title = 'Sabeghe-ye Zabti-ha', menu = 'doj_main', options = options })
		lib.showContext('doj_seizures')
	end)
end

-- ============================================================
-- DOA: Informants
-- ============================================================

function OpenInformantsMenu()
	ESX.TriggerServerCallback('esx_uniquejobs:doaGetInformants', function(informants)
		local options = {
			{
				title = 'Sabt-e Khabarchin-e Jadid',
				icon = 'plus',
				onSelect = function()
					local input = lib.inputDialog('Khabarchin-e Jadid', {
						{ type = 'input', label = 'ID Ya Esm', required = true },
						{ type = 'input', label = 'Codename', required = true },
					})
					if input and input[1] then
						TriggerServerEvent('esx_uniquejobs:doaRegisterInformant', input[1], input[2])
					end
				end,
			},
		}

		for _, inf in ipairs(informants or {}) do
			options[#options + 1] = {
				title = inf.codename,
				description = 'Sabt Shode Tavasote: ' .. inf.registered_by .. ' | Majmoo-e Pardakhti: $' .. inf.total_paid,
				icon = 'user-secret',
				onSelect = function()
					OpenInformantDetailMenu(inf.id, inf.codename)
				end,
			}
		end

		lib.registerContext({ id = 'doj_informants', title = 'Khabarchin-ha', menu = 'doj_main', options = options })
		lib.showContext('doj_informants')
	end)
end

function OpenInformantDetailMenu(informantId, codename)
	ESX.TriggerServerCallback('esx_uniquejobs:doaGetTips', function(tips)
		local options = {
			{
				title = 'Sabt-e Tip-e Jadid',
				icon = 'plus',
				onSelect = function()
					local input = lib.inputDialog('Tip-e Jadid', { { type = 'input', label = 'Matn-e Tip', required = true } })
					if input and input[1] then
						TriggerServerEvent('esx_uniquejobs:doaSubmitTip', informantId, input[1])
					end
				end,
			},
			{
				title = 'Pardakht Be Khabarchin',
				icon = 'money-bill',
				onSelect = function()
					local input = lib.inputDialog('Pardakht', { { type = 'number', label = 'Mablagh ($)', required = true } })
					if input and input[1] then
						TriggerServerEvent('esx_uniquejobs:doaPayInformant', informantId, input[1])
					end
				end,
			},
		}

		if tips and #tips > 0 then
			for _, tip in ipairs(tips) do
				options[#options + 1] = {
					title = tip.tip_text,
					description = 'Sabt Shode Tavasote: ' .. tip.logged_by,
					icon = 'note-sticky',
					disabled = true,
				}
			end
		else
			options[#options + 1] = { title = 'Hich Tip-i Sabt Nashode', disabled = true, icon = 'circle-info' }
		end

		lib.registerContext({ id = 'doj_informant_detail', title = codename, menu = 'doj_informants', options = options })
		lib.showContext('doj_informant_detail')
	end, informantId)
end
