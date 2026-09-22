fx_version 'cerulean'
game 'gta5'

author 'Arshia | arshiahub.ir | Unique RP'
description 'Unique_AllRobs - Merged: DarkPhone + PartySystem + Unique_RobSystem + Unique_OilRig, wired into esx_uniquejobs DOJ/dispatch'
version '1.2.0'

dependency 'icon_menu'
dependency 'mythic_progbar'
dependency 'ps-ui'
dependency 'ox_target'
dependency 'esx_uniquejobs'

client_scripts {
    'client.lua',
    'oilrig_client.lua',
}

server_scripts {
    'server.lua',
    'oilrig_server.lua',
}

shared_scripts {
    'config.lua',
    'oilrig_config.lua',
}
