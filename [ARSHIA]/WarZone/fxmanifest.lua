fx_version 'bodacious'
game 'gta5'

author 'arshiahub.ir'
-- Leaderboard uses oxmysql's MySQL.Async compatibility layer (same as the
-- rest of this server); make sure it's ready before this resource starts.
dependency 'oxmysql'
shared_scripts {
	'Config.lua'	
}
server_scripts {
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
