fx_version 'cerulean'
game 'gta5'

author 'Arshia'
description 'Unique_AdminPanel - merged from Admin_Menu + esx_aduty + UNIQUE_AC anti-cheat'
version '3.0.0'

-- Loaded on BOTH client and server, before client_scripts/server_scripts below
-- (migrated from UNIQUE_AC/configs/fire-config.lua and UNIQUE_AC/tables/*.lua -
-- ac_core.lua/ac_client.lua/ac_menu.lua/ac_webhook.lua all read from the
-- `UNIQUE_AC` table this creates, so it must load first)
shared_scripts {
	'shared/ac_config.lua',
	'shared/tables/*.lua',
	-- migrated from esx_aduty's Config.lua, which the original esx_aduty
	-- fxmanifest loaded on BOTH server_scripts and client_scripts (client
	-- needs Config_RPS.ReportCats for the report menu; server needs
	-- AdutyConfig.Locations for the /az teleport-location command). This
	-- was server-only for a while after the merge, which is what caused
	-- "attempt to index a nil value (global 'Config_RPS')" on the client.
	'shared/aduty_config.lua',
	-- migrated from Unique_Punishment - defines the global `Locales`
	-- table + `_()` translation helper; must load before locales/punish_en.lua
	-- below, which populates Locales['en']
	'@essentialmode/locale.lua',
	'locales/punish_en.lua',
	'shared/punish_config.lua',
	-- Report System (merged from standalone PNG_ReportSystem) - Config_Shared
	-- is read by both server/report_main.lua and client/report_main.lua
	'shared/report_shared_config.lua',
}

client_scripts {
	'@ox_lib/init.lua',
	-- migrated from esx_aduty (see server/aduty_* for server-side counterparts)
	'client/aduty_reportmenu_lib.lua',
	'client/aduty_client.lua',
	'client/aduty_spectate.lua',
	'client/aduty_carp.lua',
	-- original Unique_AdminPanel
	'client/warmenu.lua',
	'client/general_utils.lua',
	'client/admin_area.lua',
	'client/spectate_teleport_noclip.lua',
	'client/menu_ui.lua',
	'client/player_toggles.lua',
	'client/admin_tools_menu.lua',
	'client/nui_panel.lua',
	'client/expansion.lua',
	'client/admin_tag.lua',
	'client/kick_scene.lua',
	'client/ban_scene.lua',
	-- UNIQUE_AC integration bridge (additive listeners only, see file header)
	'client/uniqueac_bridge.lua',
	-- migrated from UNIQUE_AC
	'client/ac_client.lua',
	'client/ac_menu.lua',
	-- migrated from Unique_Punishment
	'client/punish_utils.lua',
	'client/punish_jail.lua',
	'client/punish_cs.lua',
	-- Report System (merged from standalone PNG_ReportSystem, replaces the
	-- old JayMenu-based esx_Report:* system that used to live in
	-- client/aduty_reports.lua / server/aduty_reports.lua)
	'shared/report_client_config.lua',
	'client/report_main.lua',
}

server_scripts {
	-- resolved via oxmysql's `provide 'mysql-async'`
	"@mysql-async/lib/MySQL.lua",
	-- MUST load before every other server file: they all call
	-- RegisterServerCallbackSafe() at load time. essentialmode IS this
	-- server's ESX core (there is no es_extended), and
	-- ESX.RegisterServerCallback on a copy of the shared object silently
	-- no-ops - this bridge routes them through essentialmode's relay.
	'server/esm_callback_bridge.lua',
	-- migrated from esx_aduty (loaded first: later files depend on AdutyConfig / AdutyTableLength)
	'server/aduty_functions.lua',
	'server/aduty_core.lua',
	'server/aduty_commands.lua',
	'server/aduty_spectate.lua',
	'server/aduty_carp.lua',
	-- Report System (merged from standalone PNG_ReportSystem - replaces the
	-- old esx_Report:* system that used to be here as server/aduty_reports.lua).
	-- Keeps firing 'Unique_AdminPanel:ReportClosed' and exports('GetReports', ...)
	-- so server/investigation.lua, server/admin_tools.lua, server/reports_extra.lua
	-- and client/nui_panel.lua's F12 report queue all keep working unmodified.
	'shared/report_server_config.lua',
	'shared/report_lan.lua',
	'server/report_function.lua',
	'server/report_main.lua',
	-- original Unique_AdminPanel
	'server/admin_area.lua',
	'server/main.lua',
	'server/admin_tools.lua',
	'server/expansion.lua',
	'server/admin_tag.lua',
	'server/duty_log.lua',
	'server/settings.lua',
	'server/reports_extra.lua',
	'server/investigation.lua',
	'server/appeals.lua',
	'server/transfer.lua',
	'server/faction_audit.lua',
	'server/spawn_pattern.lua',
	-- destructive-command confirmation, economy rate-limit alerts, combined
	-- risk score, collusion detection (placed last: risk_score.lua registers
	-- an ESX.RegisterServerCallback at load time, so it needs the global ESX
	-- to already be set, which happens in server/main.lua above)
	'server/destructive_confirm.lua',
	'server/economy_ratelimit.lua',
	'server/risk_score.lua',
	'server/collusion_detection.lua',
	-- migrated from UNIQUE_AC
	'server/ac_webhook.lua',
	'server/ac_core.lua',
	-- migrated from Unique_Punishment
	'server/punish_migrations.lua',
	'server/punish_jail.lua',
	'server/punish_cs.lua',
}

exports {
	-- migrated from UNIQUE_AC (client/shared-callable)
	'UNIQUE_AC_CHANGE_TEMP_WHITELIST',
	'UNIQUE_AC_CHANGE_TEMP_WHHITELIST',
	'UNIQUE_AC_CHECK_TEMP_WHITELIST',
	'UNIQUE_AC_ACTION',
}

server_exports {
	-- migrated from esx_aduty
	'DutyHandler',
	'DutyHandlerForJail',
	'CK',
	'AddUserMoney',
	'GetUserInfo',
	'AddUserBank',
	'SetJob',
	'SetGang',
	'SetMoney',
	'SetBank',
	'GetReports',
	-- migrated from UNIQUE_AC
	'UNIQUE_AC_CHANGE_TEMP_WHITELIST',
	'UNIQUE_AC_CHANGE_TEMP_WHHITELIST',
	'UNIQUE_AC_CHECK_TEMP_WHITELIST',
	'UNIQUE_AC_ACTION',
	'UNIQUE_AC_BAN_PLAYER',
	'BanPlayer',
	'UNIQUE_AC_UNBAN_PLAYER',
	'UnbanPlayer',
	'isAdmin',
	'ExemptPlayer',
}

-- One ui_page for the whole resource (FiveM only allows one). html/index.html
-- is a small shell that hosts the AdminMenu panel (html/adminmenu.html), the
-- UNIQUE_AC panel (ui/index.html), and now the Report System panel
-- (ui/report/index.html) in separate iframes - see that file's header
-- comment for why, and how click-focus is kept from leaking between them.
-- Neither original app's own HTML/CSS/JS was modified.
ui_page('html/index.html')
files {
	'html/index.html',
	'html/adminmenu.html',
	'html/style.css',
	'html/app.js',
	'ui/*.html',
	'ui/css/*.css',
	'ui/js/*.js',
	'ui/assists/**/*.*',
	-- Report System UI (merged from standalone PNG_ReportSystem, kept under
	-- its own ui/report/ subfolder so it doesn't collide with ui/index.html
	-- above, which is the UNIQUE_AC panel)
	'ui/report/*.html',
	'ui/report/css/*.css',
	'ui/report/js/*.js',
	'ui/report/font/*.*',
	'ui/report/img/*.*',
}

-- FIX: server/aduty_commands.lua (migrated from esx_aduty) registers ~36 of its
-- commands (tp, setjob, setmoney, noclip, slay, fix, ...) via a top-level,
-- un-delayed `TriggerEvent('es:addAdminCommand', ...)` — a LOCAL event that only
-- reaches whatever handler is registered at that exact instant. If this resource's
-- server scripts run before essentialmode's own AddEventHandler("es:addAdminCommand", ...)
-- (server/main.lua) has executed, that TriggerEvent fires into nothing and those
-- commands silently never get registered (same failure mode already documented and
-- fixed in Unique_Punishment/fxmanifest.lua). Declaring explicit dependencies here
-- guarantees essentialmode (and oxmysql, for the "@mysql-async/..." import above,
-- provided by oxmysql) have already started before any of this resource's own
-- server scripts run. 'Unique_Login' is needed by the UNIQUE_AC code now merged
-- in (its player-profile "Security" tab calls exports['Unique_Login']).
-- Same reasoning applies to server/punish_jail.lua / server/punish_cs.lua
-- (migrated from Unique_Punishment), which register /ajail, /aunjail,
-- /cs, /uncs etc. the exact same way - Unique_Punishment's own fxmanifest
-- already documented this identical bug/fix before it was merged in.
dependencies {
	-- NOTE: this server has NO es_extended. essentialmode is the ESX core
	-- (see [BASE]/essentialmode/server/common.lua, which registers
	-- esx:getSharedObject). Listing es_extended here would make the whole
	-- resource refuse to start.
	'essentialmode',
	'oxmysql',
	'Unique_Login',
}
-- NOTE: esx_aduty, UNIQUE_AC, AND Unique_Punishment have all been fully
-- merged into this resource (see server/aduty_* + client/aduty_*,
-- server/ac_* + client/ac_* + shared/ac_*, and server/punish_* +
-- client/punish_* + shared/punish_config.lua respectively) and no longer
-- need to be started separately.
-- Remove "start esx_aduty" / "ensure esx_aduty", "start UNIQUE_AC" /
-- "ensure UNIQUE_AC", and "start Unique_Punishment" / "ensure
-- Unique_Punishment" from server.cfg once this is deployed, and keep all
-- three resources' SQL tables (audit, reports, uniqueac_banlist,
-- jail-related columns on `users`, etc.) - this resource still uses all
-- of them under their original table/column names.
