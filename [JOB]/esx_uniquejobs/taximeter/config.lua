Config = {}

Config.lang = "fa"

-- MP = MILLES, KM = KILOMETERS
Config.distanceMeasurement = "KM" 

-- es-ES = EUROPEAN, en-US = AMERICAN,   zh-Hans-CN-u-nu-hanidec = CHINESE NUMBERS,    ar-EG = Arabic numbers,   ru-RU = RUSSIAN
-- EXAMPLE: 87445.54     EUROPEAN = 87.445,54    AMERICAN = 87,445.54
Config.formatMoney = "en-US" 

Config.debug = false

-- DEFAULT KEYS FOR CONFIGURATION
Config.taximeterDefaultKey = "F7"
Config.taximeterBtnDefaultKey = "LCONTROL"

-- IF YOU HAVE BASEEVENTS, I RECOMMENDED TURN TRUE
Config.baseevents = false

-- Vehicles to working taximeter
-- Synced with [JOB]/esx_uniquejobs/client/config_taxi.lua (Config_taxi.AuthorizedVehicles + AuthorizedHelis)
Config.AuthorizedVehicles = {
    'taxi',           -- default GTA taxi (kept in case it's spawned manually)
    'b219tahoe',
    'b218tau',
    'b216explorer',
    'b214charger',
    'b212caprice',
    'b211vic',
    'b218charger',
    'fibm5',
    'swat_dirtbike',
    'bus',
    'tx_heli',
    'polmav'
}

-- ONLY CAN ADD 6. 6 Rates for 6 buttons
Config.Rates = {
    
	[1] = {
		base = 5000.00, -- Base of money
		inMotion = 3000, -- Money in motion, price in 1 KM/MP
		onStop = 0.0 -- Money when you stand still, for second.
	},
	[2] = {
		base = 6000.00, -- Base of money
		inMotion = 3000, -- Money in motion, price in 1 KM/MP
		onStop = 0.0 -- Money when you stand still, for second.
	},
	[3] = {
		base = 7000.00, -- Base of money
		inMotion = 3000, -- Money in motion, price in 1 KM/MP
		onStop = 0.0 -- Money when you stand still, for second.
	},
	[4] = {
		base = 8000.00, -- Base of money
		inMotion = 3000, -- Money in motion, price in 1 KM/MP
		onStop = 0.0 -- Money when you stand still, for second.
	},
	[5] = {
		base = 9000.00, -- Base of money
		inMotion = 3000, -- Money in motion, price in 1 KM/MP
		onStop = 0.0 -- Money when you stand still, for second.
	},
	[6] = {
		base = 10000.00, -- Base of money
		inMotion = 3000, -- Money in motio, price in 1 KM/MP
		onStop = 0.0 -- Money when you stand still, for second.
	}
}
