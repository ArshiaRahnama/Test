-- Nexora RP - Help Menu System
-- discord.gg/nexora (لینک دیسکورد خودت رو بذار)

fx_version 'cerulean'
game 'gta5'

author 'Nexora RP Team'
description 'Help Menu System for Nexora RP'
version '1.0.0'

-- UI Page
ui_page 'ui/index.html'

-- Client Scripts
client_scripts {
    '@es_extended/locale.lua',
    'client/main.lua',
    'config.lua'
}

-- Server Scripts
server_scripts {
    '@es_extended/locale.lua',
    'server/server.lua'
}

-- UI Files
files {
    'ui/**',
}

-- Dependencies
dependencies {
    'es_extended'
}