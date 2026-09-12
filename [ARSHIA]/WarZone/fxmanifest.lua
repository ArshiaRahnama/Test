fx_version 'bodacious'
game 'gta5'

author 'arshiahub.ir'
-- Fix: `dependency 'oxmysql'` only guarantees load ORDER -- it does not
-- inject oxmysql's globals into this resource's own isolated Lua state
-- (each resource has its own). The leaderboard code uses the `MySQL.Async.*`
-- compatibility API (same as the rest of this server, e.g. Unique_AdminMenu),
-- which requires actually importing oxmysql's compat script as a
-- server_script, same path this server's own oxmysql resource provides it at.
dependency 'oxmysql'
-- The /warzone menu (party/stats/last match) is built on this server's
-- icon_menu resource, called via its exports.
dependency 'icon_menu'
shared_scripts {
	'Config.lua'	
}
server_scripts {
    '@oxmysql/lib/MySQL.lua',
    -- 'server/temp.lua',
    'server/main.lua',
   
    
}
client_scripts {
 
    'client/main.lua',
  

}
ui_page {
	'web/ui.html'
}
files {
	'web/css/style.css',
    'web/ui.html',
    'web/js/script.js',
    'web/sounds/*.mp3',

	'web/img/*.png',
}
