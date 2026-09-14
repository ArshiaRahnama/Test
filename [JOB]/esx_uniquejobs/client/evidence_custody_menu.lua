-- ============================================================
-- Evidence Chain of Custody menu (extension of feature #5)
-- Reached from a case's detail menu ("Zanjire-ye Negahdari-ye
-- Madarek"). Browse a case's evidence items, see who has held each
-- one, and log a hand-off to another DOJ member/department.
-- ============================================================

local TRANSFER_TARGET_JOBS = {
	{ value = 'marshal', label = 'Marshal' },
	{ value = 'judge', label = 'Judge' },
	{ value = 'cia', label = 'CIA' },
	{ value = 'cid', label = 'CID' },
	{ value = 'fbi', label = 'FBI' },
	{ value = 'doa', label = 'DOA' },
}

local function safeNow()
	if GetServerUnixTime then return GetServerUnixTime() end
	return 0
end

local function timeAgo(ts)
	local mins = math.floor((safeNow() - ts) / 60)
	if mins < 1 then return 'Hamin Alan' end
	if mins < 60 then return mins .. ' Daghighe Pish' end
	local hours = math.floor(mins / 60)
	if hours < 24 then return hours .. ' Saat Pish' end
	return math.floor(hours / 24) .. ' Rooz Pish'
end

local function openEvidenceCustody(noteId, caseId, evidenceText)
	ESX.TriggerServerCallback('esx_uniquejobs:dojGetEvidenceCustody', function(result)
		if not result then
			ESX.ShowNotification("~r~Peida Nashod")
			return
		end

		local options = {
			{ title = result.note.text, description = 'Zanjire-ye Negahdari', icon = 'boxes-stacked', disabled = true },
		}

		for _, link in ipairs(result.chain) do
			options[#options + 1] = {
				title = link.text,
				description = timeAgo(link.timestamp),
				icon = 'right-left',
				disabled = true,
			}
		end

		options[#options + 1] = {
			title = 'Enteghal-e Madrak (Taghir-e Tahvildar)',
			icon = 'hand-holding',
			onSelect = function()
				local input = lib.inputDialog('Enteghal-e Madrak', {
					{ type = 'input', label = 'Esm-e Gerande', required = true },
					{ type = 'input', label = 'Dalil (Ekhtiari)' },
				})
				if not input or not input[1] then return end

				local jobOptions = {}
				for _, j in ipairs(TRANSFER_TARGET_JOBS) do
					jobOptions[#jobOptions + 1] = {
						title = j.label,
						icon = 'building-shield',
						onSelect = function()
							TriggerServerEvent('esx_uniquejobs:dojTransferEvidence', noteId, input[1], j.value, input[2])
						end,
					}
				end
				lib.registerContext({ id = 'evidence_transfer_job_' .. noteId, title = 'Department-e Gerande', menu = 'evidence_custody_' .. noteId, options = jobOptions })
				lib.showContext('evidence_transfer_job_' .. noteId)
			end,
		}

		lib.registerContext({ id = 'evidence_custody_' .. noteId, title = 'Zanjire-ye Madrak', menu = 'evidence_locker_' .. caseId, options = options })
		lib.showContext('evidence_custody_' .. noteId)
	end, noteId)
end

-- Called from client/doj_menu.lua's case detail menu
function OpenEvidenceLockerMenu(caseId)
	ESX.TriggerServerCallback('esx_uniquejobs:dojGetCaseEvidence', function(evidence)
		evidence = evidence or {}
		local options = {}

		if #evidence == 0 then
			options[#options + 1] = { title = 'Hich Madraki Sabt Nashode', disabled = true, icon = 'circle-info' }
		else
			for _, e in ipairs(evidence) do
				options[#options + 1] = {
					title = e.text,
					description = 'Jam-avari: ' .. e.by_name .. ' -- ' .. timeAgo(e.timestamp),
					icon = 'magnifying-glass-chart',
					onSelect = function()
						openEvidenceCustody(e.id, caseId, e.text)
					end,
				}
			end
		end

		lib.registerContext({ id = 'evidence_locker_' .. caseId, title = 'Zanjire-ye Negahdari-ye Madarek', menu = 'doj_case_detail_' .. caseId, options = options })
		lib.showContext('evidence_locker_' .. caseId)
	end, caseId)
end
