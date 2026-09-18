fx_version 'bodacious'
game 'gta5'

name 'sun-inventory'
author 'sun-inventory (integrated for arshiahub.ir base)'
description 'sun-inventory UI/logic wired to essentialmode (ESX legacy) + oxmysql'
version '1.0.0'

-- Built on ESX legacy (ESX.* used throughout). `dependency` matches on the
-- actual resource NAME that's running, not on what API it happens to
-- expose — your core is folder-named "essentialmode" and has no
-- `provide 'es_extended'` line, so `dependency 'es_extended'` would just
-- never resolve and this resource would refuse to start. Use the real name.
dependency 'essentialmode'

-- FIX: original manifest pointed at '@litesql/lib/MySQL.lua', a resource
-- that does not exist anywhere in this server. Your server actually runs
-- oxmysql (see [BASE]/oxmysql), which ships the same MySQL.Async/MySQL.Sync
-- compatibility API at this path (and also `provide`s 'mysql-async').
dependency 'oxmysql'

server_scripts {
    '@oxmysql/lib/MySQL.lua',
    'server/**.lua',
    'modules/**/server/**.lua'
}
client_scripts {
    'client/**.lua',
    'modules/**/client/**.lua'
}

shared_script {
    'modules/**/common/**.lua'
}

ui_page 'ui/index.html'

files {
    'ui/**',
}
