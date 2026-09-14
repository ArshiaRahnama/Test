fx_version 'bodacious'
game 'common'

-- This is the official citizenfx/screenshot-basic resource, built from
-- source and shipped as prebuilt dist/ output (client.js, server.js,
-- ui.html) so the server just runs it directly - no 'yarn'/'webpack'
-- build-system resources required at server start.

client_script 'dist/client.js'
server_script 'dist/server.js'

files {
    'dist/ui.html'
}

ui_page 'dist/ui.html'
