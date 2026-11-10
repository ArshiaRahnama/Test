-- Pub by FleeX Team , https://discord.gg/87rGBxgCsa

client_script '@sunset_utils/include-cl.lua'
fx_version 'bodacious'
game 'gta5'
lua54 'yes'

server_scripts {
	'@litesql/lib/MySQL.lua',
	'@redis/lib/redis.lua',
	'@sunset_utils/include-sv.lua',
	'locale.lua',
	'locales/fr.lua',
	'locales/en.lua',

	'config.lua',
	'config.weapons.lua',

	'server/modules/util.lua',
	'server/modules/items.lua',
	'server/common.lua',
	'server/functions.lua',
	'server/modules/http.lua',
	'server/modules/paycheck.lua',
	'server/modules/tccheck.lua',
	'server/main.lua',
	'server/modules/db.lua',
	'server/classes/player.lua',
	'server/classes/groups.lua',
	'server/player/login.lua',
	'server/modules/commands.lua',

	'shared/modules/math.lua',
	'shared/functions.lua',
	'shared/config.lua',
	'server/modules/object.lua',
	'server/load/kit.lua',
	'server/modules/work-query.lua',
	'server/modules/commands-perm.lua',
}

client_scripts {
	'@ox_lib/init.lua',
	'locale.lua',
	'locales/fr.lua',
	'locales/en.lua',

	'config.lua',
	'config.weapons.lua',
	'client/security.lua',
	'client/common.lua',
	'client/entityiter.lua',
	'client/functions.lua',
	'client/kit.lua',
	'client/wrapper.lua',
	'client/main.lua',
	'client/suggestions.lua',
	'client/modules/death.lua',
	'client/modules/scaleform.lua',
	'client/modules/streaming.lua',
	'client/modules/keymanager.lua',
	'shared/modules/math.lua',
	'shared/functions.lua',
	'shared/config.lua',
	'shared/config_sticker.lua',
	'server/modules/commands-perm.lua',
}

ui_page {
	'html/ui.html'
}

files {
	'data.json',
	'shared/data/vehicle_names.json',
	'locale.js',
	'html/ui.html',

	'html/css/app.css',

	'html/js/mustache.min.js',
	'html/js/wrapper.js',
	'html/js/app.js',

	'html/fonts/pdown.ttf',
	'html/fonts/bankgothic.ttf',

	'html/img/accounts/bank.png',
	'html/img/accounts/black_money.png'
}

server_exports {
	'addAdminCommand',
	'addCommand',
	'addGroupCommand',
	'addACECommand',
	'canGroupTarget',
	'log',
	'debugMsg',
	'IcName',
	'GetPlayerICName',
	'deleteobj',
}

escrow_ignore {
	'locale.lua',
	'security-open.lua',
	'locales/fr.lua',
	'locales/en.lua',

	'config.lua',
	'config.weapons.lua',
	'client/common.lua',
	'client/entityiter.lua',
	'client/functions.lua',
	'client/kit.lua',
	'client/wrapper.lua',
	'client/main.lua',
	'client/suggestions.lua',
	'client/modules/death.lua',
	'client/modules/scaleform.lua',
	'client/modules/streaming.lua',
	'client/modules/keymanager.lua',
	'shared/modules/math.lua',
	'shared/functions.lua',
	'shared/config.lua',
	--server
	'locale.lua',
	'locales/fr.lua',
	'locales/en.lua',

	'config.lua',
	'config.weapons.lua',

	'server/modules/util.lua',
	'server/modules/items.lua',
	'server/common.lua',
	'server/functions.lua',
	'server/modules/http.lua',
	'server/modules/paycheck.lua',
	'server/modules/tccheck.lua',
	'server/main.lua',
	'server/modules/db.lua',
	'server/classes/player.lua',
	'server/classes/groups.lua',
	'server/player/login.lua',
	'server/player/wrappers.lua',
	'server/modules/commands.lua',

	'shared/modules/math.lua',
	'shared/functions.lua',
	'shared/config.lua',
	'server/modules/object.lua',
	'server/load/kit.lua',
	'server/modules/work-query.lua',
}