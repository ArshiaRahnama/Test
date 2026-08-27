fx_version 'cerulean'
game 'gta5'
lua54 'yes'

author 'For5M (merged: FMGangs + FMGangBoss) - patched for ox_inventory + lag fix'
description 'Unique_ALLGangs - merged FMGangs + FMGangBoss, ox_inventory, fixed openpanel lag'
version '1.0.0'

-- NOTE: ox_inventory (and its own dependencies, e.g. ox_lib) must be
-- started BEFORE this resource in your server.cfg:
--   ensure ox_lib
--   ensure ox_inventory
--   ensure Unique_ALLGangs

shared_script 'Config.lua'

server_scripts {
    '@mysql-async/lib/MySQL.lua',
    'shared/config.lua',
    'server/main.lua',      -- avatar cache / admin panel / logging
    'server/level.lua',
    'server/Gangs.lua',     -- core gang data, armory -> ox_inventory stashes
    'server/boss.lua',      -- boss panel actions (was FMGangBoss/server.lua)
}

client_scripts {
    'client/lib.lua',
    'client/gps.lua',
    'client/level.lua',
    'client/load.lua',
    'client/main.lua',      -- member panel (openpanel) + boss panel bridge
    'client/boss.lua',      -- boss menu actions (was FMGangBoss/client.lua)
}

ui_page 'web/ui.html'

files {
    -- member panel (FMGangs)
    'web/ui.html',
    'web/css/style.css',
    'web/css/Audiowide.ttf',
    'web/js/script.js',
    'web/img/*.png',
    'web/img/marker/*.png',
    'web/img/object/*.png',
    'web/img/ped/*.png',
    'web/img/blip/*.png',
    'web/img/flag/*.png',

    -- boss panel (FMGangBoss) - loaded into the same NUI frame, see
    -- client/boss.lua / README for how it's invoked.
    'html/ui.html',
    'html/main.css',
    'html/js.js',
    'html/img/*.png',
    'html/img/*.jpg',
    'html/img/*.gif',
}

escrow_ignore {
    'shared/*.lua',
    'Config.lua',
}
