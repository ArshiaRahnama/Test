-- Auction House config (merged into uniquecafejobs). Global: Config_ah
Config_ah = {}

Config_ah.ValidItems = {
    ['ambulance'] = {
    },
    ['police'] = {
    },
    ['cafe'] = {
        'applejuice',
    },
    ['resturan'] = {
    },
    ['Admins'] = {
        'clip',
        'silencer',
        'WEAPON_PISTOL',
        'WEAPON_COMBATPISTOL',
        'WEAPON_PISTOL50',
        'WEAPON_SMG',
        'WEAPON_ASSAULTSMG',
        'WEAPON_MICROSMG',
        'WEAPON_COMBATPDW',
        'WEAPON_ASSAULTRIFLE',
        'WEAPON_CARBINERIFLE',
        'WEAPON_ADVANCEDRIFLE',
        'WEAPON_BULLPUPRIFLE',
        'WEAPON_GUSENBERG'
    },
    ['Mafia'] = {
        'clip',
        'silencer',
        'WEAPON_PISTOL',
        'WEAPON_COMBATPISTOL',
        'WEAPON_PISTOL50',
        'WEAPON_SMG',
        'WEAPON_ASSAULTSMG',
        'WEAPON_MICROSMG',
        'WEAPON_COMBATPDW',
        'WEAPON_ASSAULTRIFLE',
        'WEAPON_CARBINERIFLE',
        'WEAPON_ADVANCEDRIFLE',
        'WEAPON_BULLPUPRIFLE',
        'WEAPON_GUSENBERG'
    },
}

Config_ah.UseCommand = false

Config_ah.Shop = {
    -- Markers are the gun shops (see GetShops in server.lua). Only owned shops are shown.
    marker = {
        type2 = 29,
        type = 6,
        color = {r = 0, g = 213, b = 255, a = 255},
    },
}

Config_ah.Webhook = GetConvar('uniquecafe_ah_webhook', '')
Config_ah.Icon = ''