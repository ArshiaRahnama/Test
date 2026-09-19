fx_version 'cerulean'
game 'gta5'
lua54 'yes'

author 'Arshia | arshiahub.ir | Unique RP'
description 'ESX Unique Jobs - Department Of Justice + Law Enforcement + Organ Services, all 13 jobs, one resource'
version '1.0.0'

shared_scripts {
	'@essentialmode/locale.lua',
	'@ox_lib/init.lua',
	'locales/*.lua',
	'shared/departments.lua',
	'cad/config_cad.lua',
	'cad/config_crimescene.lua',

	-- radar (Wraith ARS 2X) -- shared because sv_plate_lookup.lua checks
	-- CONFIG.jobs server-side too.
	'radar/config.lua',

	-- taximeter
	'taximeter/config.lua',
	'taximeter/shared/utils.lua',
	'taximeter/shared/locales/*.lua',

	-- K9 (merged in from the standalone k9 resource)
	'shared/k9_config.lua',
}

client_scripts {

	'client/unit_manager.lua',
	'client/rob_manager.lua',
	'client/panic_manager.lua',
	'client/tracker_manager.lua',

	'client/config_marshal.lua',
	'client/marshal_main.lua',

	'client/config_judge.lua',
	'client/judge_main.lua',

	'client/config_doa.lua',
	'client/doa_main.lua',

	'client/config_cid.lua',
	'client/cid_main.lua',

	'client/config_cia.lua',
	'client/cia_main.lua',

	'client/config_fbi.lua',
	'client/fbi_main.lua',

	'client/agent_speact.lua',
	'client/doj_menu.lua',
	'client/law_menu.lua',

	'client/server_time.lua',
	'client/court_docket_menu.lua',
	'client/case_timeline_menu.lua',
	'client/stats_dashboard_menu.lua',
	'client/officer_performance_menu.lua',
	'client/traffic_stop_menu.lua',
	'client/evidence_custody_menu.lua',
	'client/mugshot_menu.lua',



	'client/config_police.lua',
	'client/police_main.lua',

	'client/config_sheriff.lua',
	'client/sheriff_main.lua',

	'client/config_mt.lua',
	'client/mt_main.lua',

	'client/config_teleport.lua',
	'client/teleport_manager.lua',



	'client/config_mechanic.lua',
	'client/mechanic_main.lua',

	'client/config_taxi.lua',
	'client/taxi_main.lua',

	'client/config_weazel.lua',
	'client/weazel_main.lua',
	'client/weazel_cam_client.lua',

	'client/config_ambulance.lua',
	'client/ambulance_main.lua',
	'client/ambulance_job.lua',

	'bodydamage/client/*.lua',


	'shared/department_chat_client.lua',


	'cad/client/main.lua',
	'cad/client/crimescene.lua',

	-- radar (Wraith ARS 2X)
	'radar/cl_utils.lua',
	'radar/cl_player.lua',
	'radar/cl_radar.lua',
	'radar/cl_plate_reader.lua',
	'radar/cl_plate_lookup.lua',
	'radar/cl_sync.lua',

	-- taximeter
	'taximeter/client/client.lua',
	'taximeter/client/vehicleInteraction.lua',

	-- K9 (merged in from the standalone k9 resource)
	'client/k9/client_editable.lua',
	'client/k9/scaleforms.lua',
	'client/k9/functions.lua',
	'client/k9/client.lua',
	'client/k9/target.lua',
	'client/k9/camera.lua',
	'client/k9/esx_menu.lua',

	-- evidence (merged in from the standalone `evidence` resource)
	'evidence/config.lua',
	'evidence/client/main.lua',

	-- duty (merged in from the standalone esx_duty resource)
	'duty/config.lua',
	'duty/client/main.lua',

	-- lscustom (merged in from the standalone esx_lscustom resource)
	'lscustom/config.lua',
	'lscustom/locales/en.lua',
	'lscustom/client/main.lua',
	'lscustom/client/colorPicker.lua',
}

server_scripts {
	'@oxmysql/lib/MySQL.lua',
	'server/db_migrations.lua',

	'server/unit_manager.lua',
	'server/rob_manager.lua',
	'server/panic_manager.lua',
	'server/findnumber_manager.lua',
	'server/agent_speact.lua',
	'server/records_manager.lua',
	'server/tracker_manager.lua',
	'server/wiretap_manager.lua',
	'server/doj_manager.lua',
	'server/doj_cases.lua',
	'server/law_codebook.lua',

	'server/server_time.lua',
	'server/case_timeline.lua',
	'server/court_docket.lua',
	'server/stats_dashboard.lua',
	'server/officer_performance.lua',
	'server/traffic_stop_manager.lua',
	'server/evidence_custody.lua',
	'server/mugshot_manager.lua',
	'server/doa_manager.lua',

	'client/config_marshal.lua',
	'server/marshal_main.lua',
	'client/config_judge.lua',
	'server/judge_main.lua',
	'client/config_doa.lua',
	'server/doa_main.lua',
	'client/config_cid.lua',
	'server/cid_main.lua',
	'client/config_cia.lua',
	'server/cia_main.lua',
	'client/config_fbi.lua',
	'server/fbi_main.lua',


	'client/config_police.lua',
	'server/police_main.lua',
	'client/config_sheriff.lua',
	'server/sheriff_main.lua',
	'client/config_mt.lua',
	'server/mt_main.lua',


	'client/config_mechanic.lua',
	'server/mechanic_main.lua',
	'client/config_taxi.lua',
	'server/taxi_main.lua',
	'client/config_weazel.lua',
	'server/weazel_main.lua',
	'server/weazel_cam_server.lua',
	'client/config_ambulance.lua',
	'server/ambulance_main.lua',


	'shared/department_chat_server.lua',


	'cad/server/main.lua',
	'cad/server/crimescene.lua',

	-- radar (Wraith ARS 2X)
	'radar/sv_version_check.lua',
	'radar/sv_exports.lua',
	'radar/sv_sync.lua',
	'radar/sv_plate_lookup.lua',

	-- taximeter
	'taximeter/server/taxi.lua',
	'taximeter/server/server.lua',

	-- K9 (merged in from the standalone k9 resource)
	'server/k9/server_editable.lua',
	'server/k9/server.lua',

	-- evidence (merged in from the standalone `evidence` resource). Loaded after
	-- server/doj_cases.lua above, since its DOJ integration calls that file's
	-- CreateExternalCase directly as a plain global function now.
	'evidence/config.lua',
	'evidence/server/main.lua',

	-- duty (merged in from the standalone esx_duty resource)
	'duty/config.lua',
	'duty/server/main.lua',

	-- lscustom (merged in from the standalone esx_lscustom resource)
	'lscustom/config.lua',
	'lscustom/locales/en.lua',
	'lscustom/server/main.lua',
}

ui_page 'ui.html'

server_exports {
	'AcceptRequest_taxi',
	'AcceptRequest_mechanic',
	'AcceptRequest_ambulance',
	'TogglePlateLock',
}

files {
	'ui.html',

	'bodydamage/html/index.html',
	'bodydamage/html/css/*.css',
	'bodydamage/html/js/*.js',

	'bodydamage/html/img/*.png',

	'bodydamage/html/img/f/*.png',
	'bodydamage/html/img/f/bruises/*.png',
	'bodydamage/html/img/f/cuts/*.png',
	'bodydamage/html/img/f/punchs/*.png',
	'bodydamage/html/img/f/shots/*.png',

	'bodydamage/html/img/m/*.png',
	'bodydamage/html/img/m/bruises/*.png',
	'bodydamage/html/img/m/cuts/*.png',
	'bodydamage/html/img/m/punchs/*.png',
	'bodydamage/html/img/m/shots/*.png',

	'cad/html/index.html',
	'cad/html/app.js',
	'cad/html/jquery.min.js',
	'cad/html/style.css',
	'cad/html/img/*',
	'cad/html/fonts/*',
	'cad/html/sounds/*',

	-- radar (Wraith ARS 2X)
	'radar/nui/radar.html',
	'radar/nui/radar.css',
	'radar/nui/radar.js',
	'radar/nui/images/*.png',
	'radar/nui/images/plates/*.png',
	'radar/nui/fonts/*.ttf',
	'radar/nui/fonts/Segment7Standard.otf',
	'radar/nui/sounds/*.ogg',

	-- taximeter
	'taximeter/client/ui/*',
	'taximeter/client/ui/**/*',

	-- evidence (merged in from the standalone `evidence` resource)
	'evidence/html/form.html',
	'evidence/html/css.css',
	'evidence/html/script.js',
	'evidence/html/jquery-3.4.1.min.js',
	'evidence/html/img/logo.png',
	'evidence/html/img/report.jpg',

	-- lscustom (merged in from the standalone esx_lscustom resource)
	'lscustom/html/index.html',
	'lscustom/html/style.css',
	'lscustom/html/colorpicker.js',
}

dependencies {
	'essentialmode',
	'esx_society',
	'oxmysql',
	'ox_lib',
	'ox_target',
}
