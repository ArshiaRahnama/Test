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
	'crimescene/config.lua',
}

client_scripts {

	'client/unit_manager.lua',
	'client/rob_manager.lua',
	'client/panic_manager.lua',

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



	'client/config_police.lua',
	'client/police_main.lua',

	'client/config_sheriff.lua',
	'client/sheriff_main.lua',

	'client/config_mt.lua',
	'client/mt_main.lua',

	'client/teleport_police.lua',



	'client/config_mechanic.lua',
	'client/mechanic_main.lua',

	'client/config_taxi.lua',
	'client/taxi_main.lua',

	'client/config_weazel.lua',
	'client/weazel_main.lua',
	'client/weazel_cam_client.lua',

	'client/teleport_ambulance.lua',
	'client/teleport_mechanic.lua',
	'client/teleport_taxi.lua',
	'client/teleport_weazel.lua',

	'client/config_ambulance.lua',
	'client/ambulance_main.lua',
	'client/ambulance_job.lua',

	'bodydamage/client/*.lua',


	'shared/department_chat_client.lua',


	'cad/client/main.lua',
	'crimescene/client/main.lua',
}

server_scripts {
	'@mysql-async/lib/MySQL.lua',

	'server/unit_manager.lua',
	'server/rob_manager.lua',
	'server/panic_manager.lua',
	'server/findnumber_manager.lua',
	'server/agent_speact.lua',

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
	'crimescene/server/main.lua',
}

ui_page 'ui.html'

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
	'cad/html/style.css',
	'cad/html/img/*',
	'cad/html/fonts/*',
	'cad/html/sounds/*',
}

dependencies {
	'essentialmode',
	'esx_society',
	'mysql-async',
	'ox_lib',
	'ox_target',
}
