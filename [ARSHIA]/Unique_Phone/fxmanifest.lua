fx_version 'adamant'

game 'gta5'

lua54 'yes'

-- EXPANSION: Security app calls exports['Unique_Login'], so make sure that
-- resource is guaranteed to start first.
dependency 'Unique_Login'
-- EXPANSION: Job Manager (Services app) calls exports['Unique_AdminPanel']:isAdmin
-- for permission checks — same requirement.
dependency 'Unique_AdminPanel'

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
    'server/discord_ext.lua', -- Discord v7 (after config.lua so Config.DiscordExt exists)
    'server/discord_ext2.lua', -- Discord v8 (roles, invites, stage, templates ...)
    'server/discord_ext3.lua', -- Discord v9 (exports used by esx_uniquejobs: court / warrants / CAD)
    'server/discord_ext4.lua', -- Discord v11 (avatars, friends, DMs, uploaded emoji)
    'server/discord_v14.lua', -- Discord v14 (order, follows, health, appeals, staff notes)
    'server/discord_v15.lua', -- Discord v15 (profile banner)
    'server/discord_v16.lua', -- Discord v16 (channel templates, featured messages)
    'server/discord_v17.lua', -- Discord v17 (bulk delete)
    'server/discord_v18.lua', -- Discord v18 (audit log; wraps admin callbacks)
    'server/discord_v19.lua', -- Discord v19 (reply pings, join alerts)
    'server/discord_v20.lua', -- Discord v20 (search filters)
    'server/discord_v21.lua', -- Discord v21 (edit history, server bans)
    'server/discord_v22.lua', -- Discord v22 (server tags, role icons)
    'server/discord_v23.lua', -- Discord v23 (pin limit)
    'server/discord_v24.lua', -- Discord v24 (DM seen)
    'server/discord_v25.lua', -- Discord v25 (avatar effects)
    'server/discord_v26.lua', -- Discord v26 (message requests)
    'server/discord_v27.lua', -- Discord v27 (private channels, super reactions)
    'server/discord_v28.lua', -- Discord v28 (creators only)
    'server/discord_v30.lua', -- Discord v30 (rank roles for job servers)
    'server/discord_v35.lua', -- Discord v35 (ID chosen at sign-up)
    'server/discord_v41.lua', -- Discord v41 (mutual servers; LAST)
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
    'html/fonts/discord/*.woff2',
    'html/img/backgrounds/*.png',
    'html/img/apps/*.png',
    'html/img/vehicle/*.png',
}

