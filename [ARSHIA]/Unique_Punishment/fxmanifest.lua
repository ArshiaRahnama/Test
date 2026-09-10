fx_version 'bodacious'
game 'gta5'

description 'Unique Punishment (Jail + Community Service)'
author 'Arshia'

shared_scripts {
	'@essentialmode/locale.lua',
	'locales/en.lua',
	'config.lua'
}

client_scripts {
	'client/utils.lua',
	'client/jail.lua',
	'client/cs.lua'
}

server_scripts {
	'@oxmysql/lib/MySQL.lua',
	'server/migrations.lua',
	'server/jail.lua',
	'server/cs.lua'
}

-- FIX: without an explicit dependency on essentialmode, FXServer
-- doesn't guarantee this resource starts AFTER essentialmode has
-- fully started. jail.lua and cs.lua both register their admin
-- commands (/cs, /ajail, /aunjail, etc.) via a top-level, un-delayed
-- `TriggerEvent('es:addAdminCommand', ...)` — a LOCAL event that only
-- reaches whatever handler is registered at that exact instant. If
-- this resource's scripts run before essentialmode's own
-- AddEventHandler("es:addAdminCommand", ...) (server/main.lua) has
-- executed, that TriggerEvent fires into nothing: no error, no
-- message, and the command silently never gets registered at all —
-- which matches exactly "I type /cs and literally nothing happens".
-- Declaring the dependency here guarantees essentialmode has already
-- started (and therefore already registered that handler) before any
-- of this resource's own server scripts run.
dependencies {
	'essentialmode',
	'oxmysql'
}
