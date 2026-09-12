--MMMMMMMM               MMMMMMMMIIIIIIIIII   SSSSSSSSSSSSSSS TTTTTTTTTTTTTTTTTTTTTTT
--M:::::::M             M:::::::MI::::::::I SS:::::::::::::::ST:::::::::::::::::::::T
--M::::::::M           M::::::::MI::::::::IS:::::SSSSSS::::::ST:::::::::::::::::::::T
--M:::::::::M         M:::::::::MII::::::IIS:::::S     SSSSSSST:::::TT:::::::TT:::::T
--M::::::::::M       M::::::::::M  I::::I  S:::::S            TTTTTT  T:::::T  TTTTTT
--M:::::::::::M     M:::::::::::M  I::::I  S:::::S                    T:::::T        
--M:::::::M::::M   M::::M:::::::M  I::::I   S::::SSSS                 T:::::T        
--M::::::M M::::M M::::M M::::::M  I::::I    SS::::::SSSSS            T:::::T        
--M::::::M  M::::M::::M  M::::::M  I::::I      SSS::::::::SS          T:::::T        
--M::::::M   M:::::::M   M::::::M  I::::I         SSSSSS::::S         T:::::T        
--M::::::M    M:::::M    M::::::M  I::::I              S:::::S        T:::::T        
--M::::::M     MMMMM     M::::::M  I::::I              S:::::S        T:::::T        
--M::::::M               M::::::MII::::::IISSSSSSS     S:::::S      TT:::::::TT      
--M::::::M               M::::::MI::::::::IS::::::SSSSSS:::::S      T:::::::::T      
--M::::::M               M::::::MI::::::::IS:::::::::::::::SS       T:::::::::T      
--MMMMMMMM               MMMMMMMMIIIIIIIIII SSSSSSSSSSSSSSS         TTTTTTTTTTT 


fx_version 'cerulean'
games      { 'gta5' }
lua54 'yes'

author 'KuzQuality | Kuzkay'
description 'Detective tools by KuzQuality'
version '1.2.1'

ui_page 'html/index.html'

--
-- Files
--

files {
    'html/js/jquery.js',
    'html/js/jquery-ui.js',
    'html/fonts/pen.otf',
    'html/img/*.png',
    'html/index.html',
}


--
-- Server
--

server_scripts {
    'config.lua',
    'locale/locale.lua',
    '@oxmysql/lib/MySQL.lua',
    'server/server.lua',
    'server/forensics.lua',
    'server/cleanup.lua',
}

--
-- Client
--

client_scripts {
    'config.lua',
    'locale/locale.lua',
    'client/editable/settings.lua',
    'client/client.lua',
    'client/functions.lua',
    'client/forensics.lua',
    'client/cleanup.lua',
    'client/editable/editable.lua',
    'client/editable/target.lua',
    'client/editable/esx.lua',
    'client/editable/qb.lua',
}

dependencies {
    'oxmysql',
}
