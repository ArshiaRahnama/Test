-- Pub by FleeX Team , https://discord.gg/87rGBxgCsa

client_script '@sunset_utils/include-cl.lua'
server_script '@sunset_utils/include-sv.lua'
fx_version 'adamant'
game 'gta5'
lua54 'yes'
use_experimental_fxv2_oal 'yes'

shared_scripts {
    '@ox_lib/init.lua',
    'config.lua',
    'shared.lua'
}

server_scripts {
    "port_sv.lua",
    "races_sv.lua",
}

client_scripts {
    "races_cl.lua",
    "scaleform.lua"
}