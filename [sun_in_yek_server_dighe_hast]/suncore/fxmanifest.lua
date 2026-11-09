-- Pub by FleeX Team , https://discord.gg/87rGBxgCsa

client_script '@sunset_utils/include-cl.lua'
server_script '@sunset_utils/include-sv.lua'
fx_version 'adamant'
games {'gta5'}
client_script 'client/*.lua'
server_script '@litesql/lib/MySQL.lua'
server_script 'server/*.lua'

files {
    'html/index.html',
    --'html/js/*.js',
    'data/*.meta',
}
exports {
    'SetPlayerVisible',
    'Whitelist',
}
server_export 'adminmsg'




data_file 'WEAPONINFO_FILE_PATCH' 'data/weaponsnowball.meta'
lua54 'yes'