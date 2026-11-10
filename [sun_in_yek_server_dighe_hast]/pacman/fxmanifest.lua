-- Pub by FleeX Team , https://discord.gg/87rGBxgCsa

client_script '@sunset_utils/include-cl.lua'
server_script '@sunset_utils/include-sv.lua'
lua54 'yes'
fx_version 'bodacious'

game 'gta5'

client_scripts {
	'config.lu*',
    'client/main.lu*'
}


server_scripts {
	'config.lu*',
	'server/main.lu*'
}

-- specify the root page, relative to the resource
ui_page {
    'pacman/pacman.html',
}

-- every client-side file still needs to be added to the resource packfile!
files {

    -- PACMAN
    'pacman/pacman.html',
    'pacman/listener.js',
    'pacman/css/*.css',
    'pacman/css/*.png',
    'pacman/images/*.png',
    'pacman/lib/*/*.js',
    'pacman/lib/*/*.css',
    'pacman/lib/*.js',
    'pacman/sounds/*.ogg',
    'pacman/spec/*.js',
    'pacman/src/*.js',
}

