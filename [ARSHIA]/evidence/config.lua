Config = {
	--UPDATE V4
	-- Adds /evidencetest for trying the whole flow solo: sets your job to fbi grade 6,
	-- gives you a UV Light, and spawns a blood + bullet-shell evidence pair at your feet.
	-- Turn this OFF before the resource goes live on a real server.
	Debug = true,
	--

	-- IMPORTANT! To configure report text navigate to /html/script.js and find the text you want to replace

	-- FIXED for this server's `users` table (see [BASE]/database.sql): the original
	-- columns (playerName, is_male) don't exist here and would throw a SQL error on
	-- every report. This server's real columns are firstname, lastname, job, sex.
	-- UPDATE V8: added `identifier` -- needed internally to link a suspect into the
	-- esx_uniquejobs DOJ case system (see DojIntegration below). script.js filters
	-- this field out of what's actually shown on screen, so it never leaks into the
	-- visible report.
	EvidenceReportInformationBullet = "firstname, lastname, job, sex, identifier",      -- The information displayd from users table in mysql in the evidence report (ONLY CHANGE IF YOU KNOW WHAT ARE YOU DOING)
	EvidenceReportInformationFingerprint = "firstname, lastname, job, sex, identifier", -- The information displayd from users table in mysql in the evidence report (ONLY CHANGE IF YOU KNOW WHAT ARE YOU DOING)
	EvidenceReportInformationBlood = "firstname, lastname, job, sex, identifier",       -- The information displayd from users table in mysql in the evidence report (ONLY CHANGE IF YOU KNOW WHAT ARE YOU DOING)

	ShowBloodSplatsOnGround = true,                                       -- Show blood on the ground when player is shot
	PlayClipboardAnimation = true,                                        -- Play clipboard animation when reading report

	JobRequired = 'fbi',                                               -- The job needed to use evidence system
	JobGradeRequired = 6,                                                 -- The MINIMUM job grade required to use evidence system (If you use 0 all job grades can use the system)

	CloseReportKey = 'BACKSPACE',                                         -- The key used to close the report
	CloseReportKeyAlt = 'ESC',                                            -- Second key that also closes the report (ESC's default pause menu is blocked while the report is open)
	PickupEvidenceKey = 'E',                                              -- The key used to pick up evidence

	EvidenceAlanysisLocation = vector3(-420.08, 1122.67, 325.90),         -- The place where the evidence will be analyzed and report generated
	TimeToAnalyze = 10000,                                                -- Time in miliseconds to analyze the given evidence
	TimeToFindFingerprints = 3000,                                        -- Time in miliseconds to find fingerprints in a car

	--UPDATE V2
	RainRemovesEvidence = true,                              -- Removes evidence when it starts raining!
	TimeBeforeCrimsCanDestory = 300,                         -- Seconds before Criminals can destroy evidence (300 is the time when evidence coolsdown and shows up as WARM)
	EvidenceStorageLocation = vector3(-424.50, 1124.76, 325.85), -- The place where all evidence are being archived! You can view old evidence or delete it
	--

	--UPDATE V3
	-- Zones where bullets NEVER create shell-casing evidence (shooting ranges, firing
	-- academies, etc). Checked automatically every tick client-side; add as many as you want.
	-- Coords below are the vanilla Vespucci Beach shooting range — replace with wherever
	-- your server's range/academy actually is.
	NoEvidenceZones = {
		{label = 'Shooting Range', coords = vector3(19.6, -1113.32, 28.8), radius = 40.0},
	},

	-- Other resources can also toggle this per-player at runtime, e.g. from a shooting
	-- range / training script:
	--   exports['evidence']:SetIgnoreBullets(targetServerId, true)   -- server-side export
	-- or for the local player only, from another client script:
	--   exports['evidence']:SetIgnoreBullets(true)                  -- client-side export
	--

	--UPDATE V8
	-- Full integration with esx_uniquejobs' DOJ case system
	-- ([JOB]/esx_uniquejobs/server/doj_cases.lua). Every report filed at the
	-- Analysis Desk now ALSO opens a real DOJ case (visible in their own /doj menu,
	-- on top of staying in this resource's own archive) with every identified
	-- suspect attached, and bumps each suspect's CAD wanted level.
	DojIntegration = {
		enabled = true,

		-- exports['esx_uniquejobs']:CreateExternalCase's `priority` -- 'low' | 'medium' | 'high'.
		casePriority = 'medium',

		-- Also push each suspect's CAD WantedLevel, same as
		-- Config_detective.dojIntegration.pushCadStatus / cadWantedLevel in
		-- esx_uniquejobs/detective/config.lua. Must match one of Config_cs.CadWantedLevels.
		pushCadWanted = true,
		cadWantedLevel = 'wanted',
	},
	--

	Text = {

		--UPDATE V2
		['not_in_vehicle'] = 'To use this you need to be in a vehicle!',
		['remove_evidence'] = 'Destroy evidence [~r~E~w~]',
		['cooldown_before_pickup'] = 'The evidence is too fresh/hot to destroy',
		['evidence_removed'] = 'Evidence destroyed!',
		['open_evidence_archive'] = 'View Evidence Archive',
		['evidence_archive'] = 'Evidence Archive',
		['view'] = 'View',
		['delete'] = 'Delete',
		['report_list'] = 'Report #',
		['evidence_deleted_from_archive'] = 'Evidence deleted from archive!',
		--

		['evidence_colleted'] = 'Evidence #{number} collected!',
		['no_more_space'] = 'Not enough space for evidence 3/3!',
		['analyze_evidence'] = 'Analyze Evidence',
		['evidence_being_analyzed'] = 'The evience is being alanyzed by forensics! Please Wait',
		['evidence_being_analyzed_hologram'] = '~b~The evidence is being analyzed',
		['read_evidence_report'] = 'Read Evidence Report',
		['analyzing_car'] = 'The car is being analyzed! Please wait',
		['pick_up_evidence_text'] = 'Take evidence [~r~E~w~]',
		['no_fingerprints_found'] = 'No fingerprints found!',
		['no_evidence_to_analyze'] = "No evidence to analyze!",
		['shell_hologram'] = '~b~ {guncategory} ~w~ bullet shell',
		['blood_hologram'] = '~r~Blood Splat',

		['blood_after_0_minutes'] = 'Status: ~r~FRESH',
		['blood_after_5_minutes'] = 'Status: ~y~AGED',
		['blood_after_10_minutes'] = 'Status: ~b~OLD',

		['shell_after_0_minutes'] = 'Status: ~r~HOT',
		['shell_after_5_minutes'] = 'Status: ~y~WARM',
		['shell_after_10_minutes'] = 'Status: ~b~COLD',


		--UPDATE V3
		['case_file'] = 'CASE FILE',
		['analyzed_by'] = 'Analyzed by',
		['date'] = 'Date',
		['evidence_count'] = 'Items of evidence',
		['close_hint'] = 'Press BACKSPACE or ESC to close',
		--

		--UPDATE V8
		['doj_case_linked'] = 'Linked DOJ case #{caseid} -- suspects flagged wanted.',
		['doj_case_failed'] = 'Report saved, but the DOJ case could not be opened (is esx_uniquejobs running?).',
		--

		['submachine_category'] = 'Submachine',
		['unknown_category'] = 'Unknown Weapon',
		['pistol_category'] = 'Pistol',
		['shotgun_category'] = 'Shotgun',
		['assault_category'] = 'Assault Rifle',
		['lightmachine_category'] = 'Light Machine Gun',
		['sniper_category'] = 'Sniper',
		['heavy_category'] = 'Heavy Weapon'


	}


}

-- Only change if you know what are you doing!
-- UPDATE V3: routed through ESX.ShowNotification (this server's real notify function,
-- see [BASE]/essentialmode/client/functions.lua -- it uses ox_lib's toast under the
-- hood) instead of the old native corner text, to match how every other script on
-- this server notifies the player. Falls back to the native text if ESX isn't ready yet.
function SendTextMessage(msg)
	if ESX and ESX.ShowNotification then
		ESX.ShowNotification(msg)
	else
		SetNotificationTextEntry('STRING')
		AddTextComponentString(msg)
		DrawNotification(0, 1)
	end
end
