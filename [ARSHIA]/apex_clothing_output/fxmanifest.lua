--[[
    Apex Scriptz — apex_clothing_output
    Live-export container for Apex Clothing Studio. The studio
    writes PNGs + manifest entries here and restarts this tiny
    resource; every design in data.json is then retextured onto
    the original game drawables at runtime, server-wide.

    You never edit this resource by hand — apex_clothing manages
    data.json and textures/ for you. Just keep it ensured.
]]

fx_version 'cerulean'
game 'gta5'
lua54 'yes'

author      'Apex Scriptz'
description 'Apex Clothing Studio — live export container (runtime retextures)'
version     '1.0.0'

client_script 'client.lua'

files {
    'data.json',
    'textures/*.png',
}
