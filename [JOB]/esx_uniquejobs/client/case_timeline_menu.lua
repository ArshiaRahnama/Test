-- ============================================================
-- Case Timeline menu (feature #5)
-- Reached from a case's detail menu ("Timeline-e Parvande") in
-- client/doj_menu.lua. Read-only chronological feed.
-- ============================================================

local TIMELINE_ICON = {
	opened = 'folder-open',
	suspect_added = 'user-plus',
	note = 'note-sticky',
	evidence = 'magnifying-glass-chart',
	charge = 'scale-unbalanced',
	status = 'list-check',
	priority = 'flag',
	lead = 'user-tie',
	referred = 'share',
	docket = 'calendar',
	verdict = 'gavel',
	evidence_transfer = 'right-left',
}

-- Safety net: if client/server_time.lua somehow isn't loaded (missing
-- file, fxmanifest not updated), degrade gracefully instead of a hard
-- crash -- "X daghighe pish" just won't be accurate in that case.
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

-- Called from client/doj_menu.lua's case detail menu
function OpenCaseTimelineMenu(caseId)
	ESX.TriggerServerCallback('esx_uniquejobs:dojGetCaseTimeline', function(timeline)
		if not timeline then
			ESX.ShowNotification("~r~Timeline Peida Nashod")
			return
		end

		local options = {}
		for _, entry in ipairs(timeline) do
			options[#options + 1] = {
				title = entry.text,
				description = entry.byName .. ' -- ' .. timeAgo(entry.timestamp),
				icon = TIMELINE_ICON[entry.eventType] or 'circle-info',
				disabled = true,
			}
		end

		if #options == 0 then
			options[#options + 1] = { title = 'Hich Ettefaghi Sabt Nashode', disabled = true, icon = 'circle-info' }
		end

		lib.registerContext({ id = 'doj_case_timeline_' .. caseId, title = 'Timeline-e Parvande #' .. caseId, menu = 'doj_case_detail_' .. caseId, options = options })
		lib.showContext('doj_case_timeline_' .. caseId)
	end, caseId)
end
