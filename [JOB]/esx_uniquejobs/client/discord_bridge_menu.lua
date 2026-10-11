-- ============================================================
-- Discord bridge menus (ox_lib): search warrant requests, exporting a
-- suspect's Discord chats as case evidence, and reading those exports.
-- Opened from /law (police, sheriff, mt) and from a case in /doj.
-- Server side: server/discord_bridge.lua + server/doj_manager.lua.
-- ============================================================

local ERRORS = {
	NO_ACCESS      = 'Shoma Dastresi Kafi Nadarid',
	PHONE_OFFLINE  = 'Sisitem-e Discord Dar Dastres Nist',
	COOLDOWN       = 'Lotfan Chand Saniye Sabr Konid',
	WARRANT_INVALID = 'Hokm Mo\'tabar Nist (Tayid Nashode Ya Montaghi Shode)',
	NOT_YOURS      = 'Ein Hokm Baraye Shoma Nist',
	LIMIT          = 'Sahmiye-ye Estekhraj-e In Hokm Tamam Shode',
	EXPORT_FAILED  = 'Estekhraj Ba Khata Movajeh Shod',
	CASE_INVALID   = 'Parvande Namo\'tabar Ya Baste Ast',
}

local function currentJob()
	local pd = ESX.PlayerData or (ESX.GetPlayerData and ESX.GetPlayerData()) or {}
	return pd.job and pd.job.name or nil
end

function DiscordBridgeCanRequest()
	local j = currentJob()
	return j ~= nil and Config_discordbridge.RequestJobs[j] == true
end

function DiscordBridgeCanExport()
	local j = currentJob()
	return j ~= nil and Config_discordbridge.ExportJobs[j] == true
end

-- ---------------------------------------------------------------
-- Request a search warrant (shows up for the judge under /doj -> Hokm-ha)
-- ---------------------------------------------------------------
function DiscordRequestSearchWarrant()
	local input = lib.inputDialog('Darkhast-e Hokm-e Bazresi', {
		{ type = 'input', label = 'Hadaf (ID ya Esm)', required = true },
		{ type = 'textarea', label = 'Dalil (hadeaghal 8 harf)', required = true, min = 2, max = 6 },
	})
	if not input then return end
	TriggerServerEvent('esx_uniquejobs:lawRequestSearchWarrant', input[1], input[2])
end

-- ---------------------------------------------------------------
-- Reading exported evidence
-- ---------------------------------------------------------------
function OpenDiscordEvidenceView(evidenceId, page, backMenu)
	ESX.TriggerServerCallback('esx_uniquejobs:discordGetEvidenceMessages', function(data)
		if not data then ESX.ShowNotification('~r~Dastresi Nadarid Ya Peida Nashod') return end

		local options = {
			{ title = ('Hadaf: %s'):format(data.suspect), description = ('Checksum %s | %d peyam%s'):format(data.checksum, data.total, data.truncated and ' (kotah shode)' or ''), icon = 'user', readOnly = true },
			{ title = 'Server-ha', description = #data.servers > 0 and table.concat(data.servers, ', ') or '-', icon = 'server', readOnly = true },
		}

		if #data.messages == 0 then
			options[#options + 1] = { title = 'Peyami Dar In Bazeh Nist', icon = 'circle-info', disabled = true }
		end
		for _, m in ipairs(data.messages) do
			local text = m.text or ''
			options[#options + 1] = {
				title = (#text > 70) and (text:sub(1, 67) .. '...') or text,
				description = ('%s | %s > #%s'):format(m.at, m.server, m.channel),
				icon = 'message',
				onSelect = function()
					lib.alertDialog({ header = ('%s > #%s'):format(m.server, m.channel), content = ('%s\n\n%s'):format(m.at, text), centered = true, size = 'md' })
					OpenDiscordEvidenceView(evidenceId, page, backMenu)
				end,
			}
		end

		if data.page > 1 then
			options[#options + 1] = { title = 'Safhe-ye Ghabli', icon = 'chevron-left', onSelect = function() OpenDiscordEvidenceView(evidenceId, data.page - 1, backMenu) end }
		end
		if data.page < data.pages then
			options[#options + 1] = { title = ('Safhe-ye Badi (%d/%d)'):format(data.page, data.pages), icon = 'chevron-right', onSelect = function() OpenDiscordEvidenceView(evidenceId, data.page + 1, backMenu) end }
		end

		lib.registerContext({ id = 'discord_evidence_view', title = 'Madrak-e Discord', menu = backMenu, options = options })
		lib.showContext('discord_evidence_view')
	end, evidenceId, page)
end

function OpenDiscordEvidenceList(caseId, backMenu)
	ESX.TriggerServerCallback('esx_uniquejobs:discordGetEvidenceList', function(list)
		if not list then ESX.ShowNotification('~r~Dastresi Nadarid') return end

		local options = {}
		if DiscordBridgeCanExport() then
			options[#options + 1] = {
				title = 'Estekhraj-e Chat Ba Hokm-e Bazresi',
				description = 'Niaz Be Hokm-e Bazresi-e Tayid-Shode Dare',
				icon = 'file-export',
				onSelect = function() DiscordExportFlow(caseId, backMenu) end,
			}
		end
		for _, e in ipairs(list) do
			options[#options + 1] = {
				title = ('%s -- %d peyam'):format(e.suspect_name, e.msg_count),
				description = ('Hokm #%d | %s (%s) | %s | %s'):format(e.warrant_id, e.exported_by_name, e.exported_by_job, e.exportedLabel, e.checksum),
				icon = 'comments',
				onSelect = function() OpenDiscordEvidenceView(e.id, 1, 'discord_evidence_list') end,
			}
		end
		if #list == 0 then
			options[#options + 1] = { title = 'Hanooz Madrak-e Discord-i Sabt Nashode', icon = 'circle-info', disabled = true }
		end

		lib.registerContext({ id = 'discord_evidence_list', title = 'Madarek-e Discord -- Parvande #' .. caseId, menu = backMenu, options = options })
		lib.showContext('discord_evidence_list')
	end, caseId)
end

-- ---------------------------------------------------------------
-- Export flow: pick warrant -> (pick case) -> confirm -> export
-- ---------------------------------------------------------------
local function runExport(warrant, caseId, backMenu)
	local confirm = lib.alertDialog({
		header = 'Estekhraj-e Chat-haye Discord',
		content = ('Hadaf: **%s**\nHokm #%d (%d daghighe mande)\nPeyam-haye akhir-e in shakhs be onvan madrak sabt mishavad.\n\nIn amal sabt va ghabel-e peygiri ast.'):format(
			warrant.targetName, warrant.id, warrant.minutesLeft),
		centered = true, cancel = true,
	})
	if confirm ~= 'confirm' then return end

	ESX.TriggerServerCallback('esx_uniquejobs:discordExport', function(res)
		if not res or not res.ok then
			ESX.ShowNotification('~r~' .. (ERRORS[res and res.error or 'EXPORT_FAILED'] or ERRORS.EXPORT_FAILED))
			return
		end
		if res.empty or res.total == 0 then
			ESX.ShowNotification('~y~Hich Peyami Peida Nashod (Madrak Sabt Shod)')
		else
			ESX.ShowNotification(('~g~%d Peyam Be Parvande #%d Ezafe Shod'):format(res.total, res.caseId))
		end
		OpenDiscordEvidenceList(res.caseId, backMenu)
	end, warrant.id, caseId)
end

function DiscordExportFlow(presetCaseId, backMenu)
	ESX.TriggerServerCallback('esx_uniquejobs:discordGetWarrants', function(warrants)
		if not warrants then ESX.ShowNotification('~r~Dastresi Nadarid') return end
		if #warrants == 0 then
			ESX.ShowNotification('~y~Hokm-e Bazresi-e Tayid-Shode-i Nadarid. Aval Darkhast Bedid.')
			return
		end

		local options = {}
		for _, w in ipairs(warrants) do
			options[#options + 1] = {
				title = ('Hokm #%d -- %s'):format(w.id, w.targetName),
				description = ('%s | %d daghighe | Estekhraj: %d'):format(w.reason:sub(1, 60), w.minutesLeft, w.exportCount),
				icon = 'file-signature',
				onSelect = function()
					if presetCaseId and presetCaseId > 0 then
						runExport(w, presetCaseId, backMenu)
						return
					end
					ESX.TriggerServerCallback('esx_uniquejobs:discordGetCases', function(cases)
						local caseOptions = {
							{ title = 'Parvande-ye Jadid', description = 'Yek Parvande Baraye In Shakhs Baz Mishavad', icon = 'folder-plus', onSelect = function() runExport(w, 0, backMenu) end },
						}
						for _, c in ipairs(cases or {}) do
							caseOptions[#caseOptions + 1] = { title = ('#%d -- %s'):format(c.id, c.title), icon = 'folder', onSelect = function() runExport(w, c.id, backMenu) end }
						end
						lib.registerContext({ id = 'discord_pick_case', title = 'Entekhab-e Parvande', menu = 'discord_pick_warrant', options = caseOptions })
						lib.showContext('discord_pick_case')
					end)
				end,
			}
		end
		lib.registerContext({ id = 'discord_pick_warrant', title = 'Hokm-e Bazresi', menu = backMenu, options = options })
		lib.showContext('discord_pick_warrant')
	end)
end

-- ---------------------------------------------------------------
-- /law entry
-- ---------------------------------------------------------------
function OpenDiscordLawMenu()
	local options = {}
	if DiscordBridgeCanRequest() then
		options[#options + 1] = {
			title = 'Darkhast-e Hokm-e Bazresi',
			description = 'Hokm Be Ghazi/Marshal Ersal Mishavad (Tayid Lazem Ast)',
			icon = 'file-circle-plus',
			onSelect = function() DiscordRequestSearchWarrant() end,
		}
	end
	if DiscordBridgeCanExport() then
		options[#options + 1] = {
			title = 'Estekhraj-e Chat-haye Discord',
			description = 'Ba Hokm-e Bazresi-e Tayid-Shode, Be Onvan Madrak',
			icon = 'file-export',
			onSelect = function() DiscordExportFlow(0, 'discord_law') end,
		}
		options[#options + 1] = {
			title = 'Madarek-e Discord-e Parvande',
			description = 'Moshahede-ye Chat-haye Estekhraj-Shode',
			icon = 'comments',
			onSelect = function()
				ESX.TriggerServerCallback('esx_uniquejobs:discordGetCases', function(cases)
					local caseOptions = {}
					for _, c in ipairs(cases or {}) do
						caseOptions[#caseOptions + 1] = { title = ('#%d -- %s'):format(c.id, c.title), icon = 'folder', onSelect = function() OpenDiscordEvidenceList(c.id, 'discord_law_cases') end }
					end
					if #caseOptions == 0 then caseOptions[1] = { title = 'Parvande-ye Baz Nadarid', icon = 'circle-info', disabled = true } end
					lib.registerContext({ id = 'discord_law_cases', title = 'Parvande-ha', menu = 'discord_law', options = caseOptions })
					lib.showContext('discord_law_cases')
				end)
			end,
		}
	end
	lib.registerContext({ id = 'discord_law', title = 'Hokm-e Bazresi & Discord', menu = 'law_main', options = options })
	lib.showContext('discord_law')
end
