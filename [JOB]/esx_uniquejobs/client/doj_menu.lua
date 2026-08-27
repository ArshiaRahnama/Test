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
-- Law codebook -- static reference data. Edit this table to
-- match your server's actual penal code; these are placeholder
-- examples so the feature works out of the box.
-- ============================================================

local LAW_CODEBOOK = {
	{ code = '§1', title = 'Sor\'at-e Gheir-e Mojaz', fine = 500, jail = 0 },
	{ code = '§2', title = 'Ranandegi-e Khatarnak', fine = 1000, jail = 5 },
	{ code = '§3', title = 'Farar Az Police', fine = 2500, jail = 15 },
	{ code = '§4', title = 'Moghavemat Dar Barabar-e Dastgiri', fine = 1500, jail = 10 },
	{ code = '§5', title = 'Hamle-ye Sadeh', fine = 2000, jail = 10 },
	{ code = '§6', title = 'Hamle-ye Mosallahane', fine = 5000, jail = 30 },
	{ code = '§7', title = 'Sereghat', fine = 3000, jail = 15 },
	{ code = '§8', title = 'Sereghat-e Mosallahane', fine = 7500, jail = 45 },
	{ code = '§9', title = 'Hamle-ye Dozdi (Grand Theft Auto)', fine = 6000, jail = 30 },
	{ code = '§10', title = 'Negah-dari-e Mavad-e Mokhader', fine = 4000, jail = 20 },
	{ code = '§11', title = 'Ghachagh-e Mavad-e Mokhader', fine = 10000, jail = 60 },
	{ code = '§12', title = 'Negah-dari-e Salah-e Gheir-e Mojaz', fine = 5000, jail = 25 },
}

function OpenCodebookMenu()
	local options = {}
	for _, law in ipairs(LAW_CODEBOOK) do
		options[#options + 1] = {
			title = law.code .. ' -- ' .. law.title,
			description = 'Jarime: $' .. law.fine .. (law.jail > 0 and (' | Zendan: ' .. law.jail .. ' Daghighe') or ' | Bedoon-e Zendan'),
			icon = 'gavel',
			disabled = true,
		}
	end

	lib.registerContext({ id = 'doj_codebook', title = 'Ghanoon-name', menu = 'doj_main', options = options })
	lib.showContext('doj_codebook')
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
		description = 'Jarayem Va Jarime/Zendan-e Marboote',
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
-- Case files
-- ============================================================

function OpenCasesMenu(evidenceMode)
	ESX.TriggerServerCallback('esx_uniquejobs:dojGetCases', function(cases)
		local options = {
			{
				title = 'Parvande-ye Jadid',
				icon = 'plus',
				onSelect = function()
					local input = lib.inputDialog('Parvande-ye Jadid', {
						{ type = 'input', label = 'Onvan-e Parvande', required = true },
						{ type = 'input', label = 'ID Ya Esm-e Mozanne (Ekhtiari)' },
					})
					if input and input[1] then
						TriggerServerEvent('esx_uniquejobs:dojOpenCase', input[1], input[2])
					end
				end,
			},
		}

		for _, case in ipairs(cases or {}) do
			options[#options + 1] = {
				title = '#' .. case.id .. ' -- ' .. case.title,
				description = 'Mozanne: ' .. (case.suspectName or 'Na Moshakhas') .. ' | ' .. case.noteCount .. ' Yaddasht'
					.. (case.referredTo and (' | Erja Shode Be ' .. case.referredTo) or ''),
				icon = 'folder',
				onSelect = function()
					OpenCaseDetailMenu(case.id, evidenceMode)
				end,
			}
		end

		lib.registerContext({ id = 'doj_cases', title = evidenceMode and 'Entekhab-e Parvande' or 'Parvande-ha', menu = 'doj_main', options = options })
		lib.showContext('doj_cases')
	end)
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
				description = 'Mozanne: ' .. (case.suspectName or 'Na Moshakhas') .. ' | Baz Konande: ' .. case.openedByName,
				icon = 'folder-open',
				disabled = true,
			},
		}

		options[#options + 1] = {
			title = evidenceMode and 'Ezafe Kardan-e Madrak' or 'Ezafe Kardan-e Yaddasht',
			icon = 'pen',
			onSelect = function()
				local input = lib.inputDialog(evidenceMode and 'Madrak-e Jadid' or 'Yaddasht-e Jadid', { { type = 'input', label = 'Matn', required = true } })
				if input and input[1] then
					local text = evidenceMode and ('[MADRAK] ' .. input[1]) or input[1]
					TriggerServerEvent('esx_uniquejobs:dojAddCaseNote', caseId, text)
				end
			end,
		}

		if #case.notes == 0 then
			options[#options + 1] = { title = 'Hich Yaddashti Sabt Nashode', disabled = true, icon = 'circle-info' }
		else
			for _, note in ipairs(case.notes) do
				options[#options + 1] = {
					title = note.text,
					description = 'Sabt Shode Tavasote: ' .. note.byName,
					icon = 'note-sticky',
					disabled = true,
				}
			end
		end

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
				lib.registerContext({ id = 'doj_case_refer', title = 'Erja Be', menu = 'doj_main', options = referOptions })
				lib.showContext('doj_case_refer')
			end,
		}

		options[#options + 1] = {
			title = 'Baste Kardan-e Parvande',
			icon = 'box-archive',
			onSelect = function()
				TriggerServerEvent('esx_uniquejobs:dojCloseCase', caseId)
			end,
		}

		lib.registerContext({ id = 'doj_case_detail', title = 'Parvande #' .. caseId, menu = 'doj_cases', options = options })
		lib.showContext('doj_case_detail')
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
