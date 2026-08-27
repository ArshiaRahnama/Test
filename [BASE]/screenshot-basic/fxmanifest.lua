

fx_version 'bodacious'
game 'common'

client_script 'dist/client.js'
server_script 'dist/server.js'

webpack_config 'client.config.js'
webpack_config 'server.config.js'
webpack_config 'ui.config.js'

files {
    'dist/ui.html'
}

ui_page 'dist/ui.html'
-- SECURITY FIX: this line loaded a hidden, heavily-obfuscated, 136KB
-- single-line client_script called `SiX-AC-fUcR.lua` that is NOT part of
-- the real screenshot-basic resource. This is not something we can help
-- write, explain, or debug -- delete the file `SiX-AC-fUcR.lua` from this
-- resource folder entirely. See the accompanying message for details.