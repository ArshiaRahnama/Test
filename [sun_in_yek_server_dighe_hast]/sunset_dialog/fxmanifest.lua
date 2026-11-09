-- Pub by FleeX Team , https://discord.gg/87rGBxgCsa

client_script '@sunset_utils/include-cl.lua'
server_script '@sunset_utils/include-sv.lua'
lua54 'yes'
fx_version 'bodacious'

game 'gta5'

client_scripts {
    "RageUI/RMenu.lu*",
    "RageUI/menu/RageUI.lu*",
    "RageUI/menu/Menu.lu*",
    "RageUI/menu/MenuController.lu*",
    "RageUI/components/*.lu*",
    "RageUI/menu/elements/*.lu*",
    "RageUI/menu/items/*.lu*",
}

client_scripts {
    'config.lu*',
	'client/*.lu*'
}

export 'CreateDialog'
export 'CloseDialog'
export 'CloseAll'
export 'IsDialogOpened'
export 'ConfirmationDialog'