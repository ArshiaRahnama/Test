Drop your own .ogg/.mp3 files in this folder, then reference them in
Config.Sounds in config.lua, e.g.:

    Config.Sounds = {
        Kill = 'sounds/kill.ogg',
        MatchStart = 'sounds/start.ogg',
        MatchWin = 'sounds/win.ogg',
    }

Leave any of them nil (the default) to skip that sound entirely - none are
required for the script to work.
