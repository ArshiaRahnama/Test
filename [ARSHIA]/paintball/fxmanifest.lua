

fx_version 'adamant'
game 'gta5'

author 'Arshia - arshiahub.ir'
ui_page "html/index.html"
files {
	'html/index.html',
	'html/assets/css/style.css',
	'html/assets/imgs/*.png',
	'html/assets/imgs/*.jpg',
	'html/assets/js/script.js',
	'html/assets/weapons/advancedrifle.png',
	'html/assets/weapons/appistol.png',
    'html/assets/weapons/assaultrifle.png',
	'html/assets/weapons/assaultrifle_mk2.png',
    'html/assets/weapons/assaultshotgun.png',
	'html/assets/weapons/assaultsmg.png',
    'html/assets/weapons/autoshotgun.png',
	'html/assets/weapons/bullpuprifle.png',
    'html/assets/weapons/bullpuprifle_mk2.png',
	'html/assets/weapons/bullpupshotgun.png',
    'html/assets/weapons/carbinerifle.png',
	'html/assets/weapons/carbinerifle_mk2.png',
    'html/assets/weapons/combatmg.png',
	'html/assets/weapons/combatmg_mk2.png',
    'html/assets/weapons/combatpdw.png',
	'html/assets/weapons/combatpistol.png',
    'html/assets/weapons/compactrifle.png',
	'html/assets/weapons/dbshotgun.png',
    'html/assets/weapons/doubleaction.png',
	'html/assets/weapons/gusenberg.png',
    'html/assets/weapons/heavypistol.png',
	'html/assets/weapons/heavyshotgun.png',
    'html/assets/weapons/heavysniper.png',
	'html/assets/weapons/heavysniper_mk2.png',
    'html/assets/weapons/machinepistol.png',
	'html/assets/weapons/marksmanpistol.png',
    'html/assets/weapons/marksmanrifle.png',
	'html/assets/weapons/marksmanrifle_mk2.png',
    'html/assets/weapons/mg.png',
	'html/assets/weapons/microsmg.png',
    'html/assets/weapons/minigun.png',
	'html/assets/weapons/minismg.png',
    'html/assets/weapons/musket.png',
	'html/assets/weapons/pistol.png',
    'html/assets/weapons/pistol50.png',
	'html/assets/weapons/pistol_mk2.png',
    'html/assets/weapons/pumpshotgun.png',
	'html/assets/weapons/pumpshotgun_mk2.png',
    'html/assets/weapons/revolver.png',
	'html/assets/weapons/revolver_mk2.png',
    'html/assets/weapons/sawnoffshotgun.png',
	'html/assets/weapons/smg.png',
    'html/assets/weapons/smg_mk2.png',
	'html/assets/weapons/snspistol.png',
    'html/assets/weapons/snspistol_mk2.png',
	'html/assets/weapons/specialcarbine.png',
    'html/assets/weapons/specialcarbine_mk2.png',
	'html/assets/weapons/vintagepistol.png',
	'html/assets/weapons/*.png',
	'html/assets/imgs/*.jpg',
	'html/assets/imgs/*.png'
}

client_scripts {
	"@ox_lib/init.lua",
	"settings/*.lua",
    'client/*.lua'
}

server_scripts {
	"settings/*.lua",
	'@mysql-async/lib/MySQL.lua',
    'server/*.lua'
}

