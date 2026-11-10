-- Pub by FleeX Team , https://discord.gg/87rGBxgCsa

fx_version "cerulean"
game "gta5"
lua54 "yes"
author "Sunset development team"
description "iPhone 15"
version "1.0.0"

ui_page "html/index.html"

client_scripts {
	"client/core/esx.lua",
	"client/main.lua",
	"client/animation.lua",
	"client/zones.lua",
	"client/feature/*.lua"
}

server_scripts {
  	"@litesql/lib/MySQL.lua",
	"@redis/lib/redis.lua",
	"server/core/esx.lua",
	"server/core/cache.lua",
	"server/main.lua",
	"server/feature/*.lua"
}

shared_scripts {
  	"@ox_lib/init.lua",
	"config/**"
}

files {
  	"html/index.html",
	"html/**/*.png",
	"html/**/*.svg",
	"html/**/*.json",
	"html/**/*.jpg",
	"html/**/*.woff2",
	-- Audio (ringtones, notification sounds). Required so both the React UI
	-- (useSound) AND client-side xsound (nui://sun-phone/html/sounds/...)
	-- can load them. Without these the nearby-ringtone playback is silent.
	"html/**/*.mp3",
	"html/**/*.ogg",
	-- Embedded games (e.g. the Pacman app at html/games/pacman): their JS/CSS/
	-- HTML must be packfiled so the in-phone iframe can load them. The broad
	-- ** globs are kept, but FiveM only reliably serves these when each folder
	-- is listed EXPLICITLY (same pattern as the original pacman resource), so
	-- they're enumerated below too.
	"html/**/*.js",
	"html/**/*.css",
	"html/**/*.html",
	"html/games/pacman/pacman.html",
	"html/games/pacman/listener.js",
	"html/games/pacman/css/*.css",
	"html/games/pacman/css/*.png",
	"html/games/pacman/images/*.png",
	"html/games/pacman/lib/*.js",
	"html/games/pacman/src/*.js",
	"html/games/pacman/sounds/*.ogg",
	"html/sounds/*",
	"html/assets/*.css",
	"html/assets/*.js",
}