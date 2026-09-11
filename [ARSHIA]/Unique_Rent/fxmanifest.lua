fx_version 'adamant'
game 'gta5'

author 'Arshia | arshiahub.ir'
description 'Unique_Rent - Premium Vehicle Rental'
version '1.4'

lua54 'yes'

ui_page {'html/index.html'}

client_script {'client/main.lua','functions/main.lua','functions/events.lua'}
server_script {'server/main.lua'}

shared_scripts {'config.lua'}

files {'html/index.html','html/js/*.js','html/css/*.css', 'html/assets/*.png', 'html/assets/*.jpg'}

-- FIX: this resource's own client/main.lua and server/main.lua already do
-- `TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)` to
-- fetch ESX manually, so it never needed `@es_extended/imports.lua` (an
-- auto-import file that doesn't exist on this base anyway -- this base's
-- framework resource is named `essentialmode`, not `es_extended`; see
-- essentialmode/fxmanifest.lua and server/common.lua's
-- AddEventHandler("esx:getSharedObject", ...)). The old `dependency
-- 'es_extended'` line pointed FXServer at a resource that plain doesn't
-- exist here, which made it refuse to start this resource at all
-- ("Could not find dependency es_extended for resource Unique_Rent").
-- Declaring the real framework name below both fixes that and guarantees
-- essentialmode has fully started before this resource's scripts run.
dependencies {
	'essentialmode'
}

