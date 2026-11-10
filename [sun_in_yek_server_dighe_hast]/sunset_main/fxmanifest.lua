-- Pub by FleeX Team , https://discord.gg/87rGBxgCsa

client_script '@sunset_utils/include-cl.lua'
server_script '@sunset_utils/include-sv.lua'
fx_version 'cerulean'
games {'gta5'}

description 'SunSet main script'


client_scripts {
    'vSync/vs_client.lua',
    'doorsensor/door_sensor_client.lua',
    'vehcontrol/vehcontrol_client.lua',
    'vote/vote_client.lua',
    'autopilot/autopilot_client.lua',
    'mining/mining_client.lua'
}

server_script {
    'vSync/vs_server.lua',
    'main_server.lua'
}

ui_page "vehcontrol/html/vehui.html"

files {
  "vehcontrol/html/vehui.html",
  "vehcontrol/html/style.css",
  "vehcontrol/html/img/doorFrontLeft.png",
  "vehcontrol/html/img/doorFrontRight.png",
  "vehcontrol/html/img/doorRearLeft.png",
  "vehcontrol/html/img/doorRearRight.png",
  "vehcontrol/html/img/frontHood.png",
  "vehcontrol/html/img/ignition.png",
  "vehcontrol/html/img/rearHood.png",
  "vehcontrol/html/img/rearHood2.png",
  "vehcontrol/html/img/seatFrontLeft.png",
  "vehcontrol/html/img/windowFrontLeft.png",
  "vehcontrol/html/img/windowFrontRight.png",
  "vehcontrol/html/img/windowRearLeft.png",
  "vehcontrol/html/img/windowRearRight.png",
  "vehcontrol/html/img/interiorLight.png"
}
