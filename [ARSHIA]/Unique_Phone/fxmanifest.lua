fx_version 'adamant'

game 'gta5'

lua54 'yes'

-- EXPANSION: Security app calls exports['Unique_Login'], so make sure that
-- resource is guaranteed to start first.
dependency 'Unique_Login'
-- EXPANSION: Job Manager (Services app) calls exports['UNIQUE_AC']:isAdmin
-- for permission checks — same requirement.
dependency 'UNIQUE_AC'

client_scripts {
    '@ox_lib/init.lua',
    'client/*.lua',
    'config.lua',
}

server_scripts {
    -- FIX: pointed at '@mysql-async/lib/MySQL.lua', but mysql-async isn't
    -- installed on this server (only oxmysql is ensured) — this resource
    -- would fail to start at all. oxmysql's compatibility shim exposes the
    -- same MySQL.Async/MySQL.Sync API, so no query anywhere had to change.
    '@oxmysql/lib/MySQL.lua',
    'server/main.lua',
    'config.lua',
}

ui_page "html/index.html"

files {
    'html/*.html',
    'html/js/*.js',
    'html/img/*.png',
    'html/img/jobs/*.png',
    'html/css/*.css',
    'html/fonts/*.ttf',
    'html/fonts/*.otf',
    'html/fonts/*.woff',
    'html/img/backgrounds/*.png',
    'html/img/apps/*.png',
    'html/img/vehicle/*.png',
}

