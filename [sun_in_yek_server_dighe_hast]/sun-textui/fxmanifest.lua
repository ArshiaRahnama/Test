-- Pub by FleeX Team , https://discord.gg/87rGBxgCsa

fx_version 'cerulean'
game 'gta5'
lua54 'yes'
escrow_ignore {
	'shared/*.lua',
	'client/*.lua'
}
shared_scripts {
    'shared/*.lua'
}
client_scripts {
	'client/*.lua'
}
ui_page 'html/index.html'
files {
	'html/**',
	'assets/**/*.png'
}
lua54 'yes'
exports {
    'displayTextUI',
    'hideTextUI',
	'changeText',
	'create3DTextUI',
	'update3DTextUI',
	'create3DTextUIOnPlayers',
	'delete3DTextUIOnPlayers',
	'delete3DTextUI',
	'create3DTextUIOnEntity'
}