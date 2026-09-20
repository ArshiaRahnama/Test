fx_version 'adamant'
game 'gta5'

description 'ESX Inventory HUD'
version '1.1'

ui_page 'html/ui.html'

-- FIX: dependency was 'es_extended' semantics via '@essentialmode' path (correct),
-- but the DB import pointed at '@mysql-async/lib/MySQL.lua' - no resource named
-- 'mysql-async' exists on this server (only 'oxmysql', which does provide the
-- 'mysql-async' name for `dependency` checks, but NOT for '@resource/path'
-- script imports - those resolve by literal resource name). Fixed to '@oxmysql'.
-- The manifest also had a second, malformed 'server_scripts { ... }' block
-- appended after 'files' with no newline - removed (dead duplicate).
dependency 'essentialmode'
dependency 'oxmysql'

client_scripts {
  '@essentialmode/locale.lua',
  'client/main.lua',
  'config.lua'
}

server_scripts {
  '@essentialmode/locale.lua',
  '@oxmysql/lib/MySQL.lua',
  'server/main.lua',
  'config.lua'
}

files {
    'html/ui.html',
    'html/css/materialize.css',
    'html/css/ui.css',
    'html/css/jquery-ui.css',
    'html/js/jquery.min.js',
    'html/js/inventory.js',
    'html/js/config.js',
    'html/js/materialize.min.js',
    -- JS LOCALES
    'html/locales/cs.js',
    'html/locales/en.js',
    'html/locales/fr.js',
    -- IMAGES
    'html/img/bullet.png',
    -- ICONS
    'html/img/items/*.png'
}
