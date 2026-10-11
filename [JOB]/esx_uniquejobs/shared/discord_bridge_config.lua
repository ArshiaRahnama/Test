-- ============================================================
-- Discord bridge (Unique_Phone <-> /doj, /law, /cad)
-- Loaded as a shared script AFTER shared/departments.lua, so
-- LeJobSet / DojJobSet already exist here.
-- ============================================================

Config_discordbridge = {
	-- Name of the phone resource whose exports we call. If it is not started
	-- every Discord feature below silently does nothing (the rest of the
	-- justice system keeps working exactly as before).
	Resource = 'Unique_Phone',

	-- Who may REQUEST a search warrant (police, sheriff, mt + the agent jobs).
	RequestJobs = { police = true, sheriff = true, mt = true, cid = true, fbi = true, cia = true },
	MinGradeRequest = 0,

	-- Who may use an approved search warrant to export chats as evidence.
	-- (Judges only decide; they can still READ the exported evidence.)
	ExportJobs = { police = true, sheriff = true, mt = true, cid = true, fbi = true, cia = true, marshal = true, doa = true },

	-- An approved search warrant stays usable this long (server uptime: warrants live in memory).
	WarrantTTLMinutes = 180,
	MaxExportsPerWarrant = 2,
	ExportCooldownSeconds = 20,

	-- Court announcements go to this job's official Discord server.
	Court = { job = 'judge', channel = 'court-docket' },
	-- Extra jobs that also get the court announcements (empty = judge only).
	CourtAlsoPost = { },

	-- Each department's own channel for warrant news (created on first use).
	WarrantChannel = 'warrants',
	-- CAD feed: wanted-level changes and panic buttons are mirrored here for every LE job.
	DispatchChannel = 'dispatch',

	-- Hearing reminders (minutes before the session) and a "starting now" ping.
	ReminderMinutesBefore = 10,
	RemindStart = true,
	-- Who is told about a hearing besides the defendants: opener, lead officer, and these jobs (if online).
	HearingNotifyJobs = { 'judge' },
}
