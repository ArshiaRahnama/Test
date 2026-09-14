CFG = {}

CFG.FRAMEWORK = 'ESXOLD' -- 'QBCore', 'QBX', 'ESX', 'ESXOLD' or false to disable it
CFG.INVENTORY = 'esx_inventory' -- 'qb-inventory', 'ox-inventory', 'qs-inventory', 'esx_inventory' or false to disable it
-- NOTE: 'esx_inventory' support added specifically for this server. It reads trunk
-- contents through a new export in esx_inventory/server/apps/system/trunk.lua
-- (see the patch provided alongside this script). esx_inventory has no glovebox
-- system, so k9searchcar will only ever detect items in the trunk, never the glovebox.
CFG.TARGET = 'ox_target' -- 'qb-target', 'qtarget', 'ox_target' or false to disable it
CFG.DATABASE = 'oxmysql' -- 'oxmysql', 'mysql-async' or false to disable
CFG.NOTIFY = 'ox' -- 'ox', 'qb', 'esx', 'native' or false

-- menu system is esx_menu_default now (client/k9/esx_menu.lua), same as
-- every other department menu in this resource - CFG.MENU / menuv / ox_lib
-- context menu are no longer used at all.

-- RESTRICTION OPTIONS --
CFG.RESTRICTIONS = {
	
	USE_ACE_PERMS = false, -- true / false

	
	JOBS = {
		-- job name, grade numbers allowed to use k9 (added: all military/medic depts wired to esx_uniquejobs F6 > Spawn Pet)
		['police'] = {0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23},
		['ambulance'] = {0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15},
		['sheriff'] = {0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30},
		['fbi'] = {0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30},
		['cia'] = {0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30},
		['doa'] = {0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30},
		['cid'] = {0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30},
		['marshal'] = {0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30},
		['mt'] = {0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30},
	}
}

CFG.CONTROLS = {
	-- AIM AND HIT THE KEY
	aim = {
		attack = 38, -- E
		go = 47 -- G
	},
	cam = { -- camera keys
		up =  172,
		down = 173,
		cancel = 177, -- ESC, BACKSPACE, RIGHT CLICK
		zoomUp = 241, -- scroll up
		zoomDown = 242 -- scroll down
	}
}

CFG.LVL_SYSTEM = {
	DISABLE = false, -- Leave this alone thankss
	XP_PER_ACTION = {from = 40, to = 100}, 

	LVLS = {

	
		[1] = { XP = 0, Fail = 70, tracking_speed = 1.0, tackle_chance = 10 },
		[2] = { XP = 300, Fail = 60, tracking_speed = 2.0, tackle_chance = 20 },
		[3] = { XP = 600, Fail = 55, tracking_speed = 3.0, tackle_chance = 30 },
		[4] = { XP = 1600, Fail = 50, tracking_speed = 4.0, tackle_chance = 30 },
		[5] = { XP = 3500, Fail = 45, tracking_speed = 5.0, tackle_chance = 30 },
		[6] = { XP = 4100, Fail = 40, tracking_speed = 5.0, tackle_chance = 30 },
		[7] = { XP = 4200, Fail = 39, tracking_speed = 5.0, tackle_chance = 30 },
		[8] = { XP = 4600, Fail = 38, tracking_speed = 5.0, tackle_chance = 30 },
		[9] = { XP = 4900, Fail = 37, tracking_speed = 5.0, tackle_chance = 30 },
		[10] = { XP = 5000, Fail = 36, tracking_speed = 5.0, tackle_chance = 30 },
		[11] = { XP = 5200, Fail = 35, tracking_speed = 5.0, tackle_chance = 30 },
		[12] = { XP = 5300, Fail = 30, tracking_speed = 5.0, tackle_chance = 30 },
		[13] = { XP = 5900, Fail = 29, tracking_speed = 5.0, tackle_chance = 30 },
		[14] = { XP = 6000, Fail = 28, tracking_speed = 5.0, tackle_chance = 30 },
		[15] = { XP = 6200, Fail = 27, tracking_speed = 5.0, tackle_chance = 30 },
		[16] = { XP = 6800, Fail = 26, tracking_speed = 5.0, tackle_chance = 30 },
		[17] = { XP = 7000, Fail = 25, tracking_speed = 5.0, tackle_chance = 30 },
		[18] = { XP = 7500, Fail = 20, tracking_speed = 5.0, tackle_chance = 30 },
		[19] = { XP = 8000, Fail = 19, tracking_speed = 5.0, tackle_chance = 30 },
		[20] = { XP = 8500, Fail = 18, tracking_speed = 5.0, tackle_chance = 30 },
		[21] = { XP = 9600, Fail = 17, tracking_speed = 5.0, tackle_chance = 30 },
		[22] = { XP = 9900, Fail = 16, tracking_speed = 5.0, tackle_chance = 30 },
		[23] = { XP = 10100, Fail = 15, tracking_speed = 5.0, tackle_chance = 30 },
		[24] = { XP = 10600, Fail = 14, tracking_speed = 5.0, tackle_chance = 30 },
		[25] = { XP = 11000, Fail = 13, tracking_speed = 5.0, tackle_chance = 30 },
		[26] = { XP = 11100, Fail = 12, tracking_speed = 5.0, tackle_chance = 30 },
		[27] = { XP = 11500, Fail = 11, tracking_speed = 5.0, tackle_chance = 30 },
		[28] = { XP = 12200, Fail = 10, tracking_speed = 5.0, tackle_chance = 30 },
		[29] = { XP = 12600, Fail = 7, tracking_speed = 5.0, tackle_chance = 30 },
		[30] = { XP = 13000, Fail = 3, tracking_speed = 5.0, tackle_chance = 30 },
		[31] = { XP = 20000000, Fail = 0, tracking_speed = 5.0, tackle_chance = 30 },
	}
}

CFG.SETTINGS = {
	
	
	INSTA_HEADSHOT = true, 

	MAX_DOGS = 1, -- 
	BLIP = true, 

	TACKLE = {
		enable = true, 
		chance = 30, 
		type = 1 -- 1 = animation, 2 = ragdoll
	},

	DELETE_DOG = { -- delete dog if
		dog_dead = false, -- if u want to use this option, then disable saving of health and armor below
		owner_dead = false 
	},

	VEHICLE_ENTERING = {
		-- If you set it to true it will let the dog enter the vehicles with more realistic animations
		-- This feature is still in BETA phase, 
		new = true,
	
		vans = { -- this is not useable yet
			[`rumpo`] = true, [`rumpo2`] = true,
			[`speedo`] = true, [`speedo2`] = true,
			[`speedo3`] = true, [`policet`] = true,
			[`EMSf550ambo`] = true, [`EMSf550ambo2`] = true,
			[`20ramambo`] = true

		}
	},

	CAMERA = {
		disable = false, -- why the tf would you want to change this 

	
		item = false, -- 'k9_camera' 

		-- new options coming soon... sooon.... soooon... Maybe ask daddy byrd
	},

	TRACKING = {
		radius = 150.0, 
		speed = 1.0, 
		cooldown = 5 
	},
	
	SEARCH = {
		AllWeapons = false, 
		items = { 
			['coke_box'] = true,
			['coke_raw'] = true,
			['coke_pure'] = true,
			['coke_figure'] = true,
			['meth_amoniak'] = true,
			['heroin_syringe'] = true,
			['meth_syringe'] = true,
			['meth_sacid'] = true,
			['crack'] = true,
			['heroin'] = true,
			['xanaxpill'] = true,
			['xanaxplate'] = true,
			['xanaxpack'] = true,
			['lsd5'] = true,
			['lsd4'] = true,
			['lsd3'] = true,
			['lsd2'] = true,
			['lsd1'] = true,
			['ecstasy5'] = true,
			['ecstasy4'] = true,
			['ecstasy3'] = true,
			['ecstasy2'] = true,
			['ecstasy1'] = true,
			['weed_package'] = true,
			['meth_bag'] = true,
			['meth_sharp'] = true,
			['meth_glass'] = true,
			['crack_pipe'] = true,
			['meth_pipe'] = true,
			['coke_brick'] = true,
			['drug_ecstasy'] = true,
			['drug_lean'] = true,
			['drug_lsd'] = true,
			['drug_meth '] = true,
			['cannabis '] = true,
			['cocaine'] = true,
			['weed_white-widow'] = true,
			['weed_skunk'] = true,
			['weed_purple-haze'] = true,
			['weed_og-kush'] = true,
			['weed_amnesia'] = true,
			['weed_ak47'] = true,
			['weed_og-kush_crop'] = true,
			['weed_skunk_crop'] = true,
			['weed_white-widow_crop'] = true,
			['weed_ak47_crop '] = true,
			['weed_purple-haze_crop'] = true,
			['weed_galeto_crop'] = true,
			['weed_zkittlez_crop'] = true,
			['weed_zkittlez_joint'] = true,
			['weed_gelato_joint'] = true,
			['weed_purple-haze_joint'] = true,
			['weed_amnesia_joint'] = true,
			['coke_small_brick'] = true,
			['weed_brick'] = true,
			['oxy'] = true,
			['meth'] = true,
			['joint'] = true,
			['cokebaggy'] = true,
			['crack_baggy'] = true,
			['xtcbaggy'] = true,
		},
	
		open_doors = false, 
		search_player_time = 4, 
	
		
		onSuccess = 'sit',
	
		
		advanced = true,
	},

	STATUS = {
		-- new registered dog spawns automatically with maxHealth
		-- fyi if dog has 100 hp or lower, he always get killed after one shot... that's how the game works xd
		-- u can set any max values
		maxHealth = 200,
		maxArmor = 200,
	
		--[[ 
			true = it will don't save these values into database, 
			so players are able to respawn his dog through menu without reviving option
		]]
		disable_hp_and_armor_saving = false, 
	
		heal = {
			revive_timer = 20, -- reviving dog
	
			timer = 5, -- applying bandage
			amount = {from = 10, to = 25}, -- how much hp will be added to dog
			item = 'bandage',
		},
		armor = {
			timer = 10,
			amount = {from = 10, to = 25}, -- how much armor will be added to dog
			item = 'armor', 'heavy_armor',
		},
	
		feed = {
			prop = `v_res_mbowl`, -- object
	
			item = 'water_bottle', -- item that is required
	
			-- thirst and hunger gets decreased every 10 seconds
			-- min 0.0, max 1.0
			thirst = { from = 0.1, to = 0.1},
			hunger = { from = 0.1, to = 0.1 },
	
			warning = 10, -- warns player if thirst/hunger is under x %
			get_damaged = true, -- true/false - if dog is hungry/thirsty it will slowly decrease health
		
			-- extra featchers  
			-- lol
			peeing = false, pooping = false
		}
	}
}

-- DOGS FOR REGISTRATION --
CFG.DOGS = {
	-- Only these dog models i found can attack
	-- label and spawn name
	['SASP/BCSO Belgian malinois'] = `a_c_shepherd`,
}

CFG.COMMANDS = {

	BINDING_SYSTEM = { -- fivem keybinding system
		enable = false, -- true/false
		commands = {
			--[[ 
				- three parameters -
					command is name of command from the list below
					key is primary key for triggering
					label is showed in FiveM keybinds as description for bind

				- list of usable keys
				https://docs.fivem.net/docs/game-references/input-mapper-parameter-ids/keyboard/
			]]

			--[1] = { command = 'k9', key = 'K', label = 'Open K9 Menu' }, -- binding command k9 to K key (example)
			-- [2] = { command = 'k9animations', key = 'L', label = 'Open K9 Animations' },
		},
	},


	--[[
		LIST OF COMMANDS
		- code_name and name of command
		- change only name of command if you need to!
	]]
	disable = true, -- all K9 chat commands disabled: menu is only reachable via F6 > Spawn Pet now

	-- main
	['register_dog'] = 'k9register',
	['reselect'] = 'k9reselect',
	['main_menu'] = 'k9',
	['save_dog'] = 'k9save',
	['check_dog'] = 'k9check',
	['spawn'] = 'k9spawn',
	['animations'] = 'k9animations',

	-- actions
	['follow'] = 'k9follow',
	['vehicle'] = 'k9vehicle',
	['ball'] = 'k9ball',
	['fetch'] = 'k9fetch',
	['search_player'] = 'k9searchped',
	['search_car'] = 'k9searchcar',
	['feed'] = 'k9feed',
	['heal'] = 'k9heal',
	['armor'] = 'k9armor',
	['carry'] = 'k9carry',
	['track'] = 'k9trackall',
	['track_player'] = 'k9trackplayer',

	-- camera
	['toggle_camera'] = 'k9camera',
	['mount_camera'] = 'k9mount',

	-- anim commands
	['sit'] = 'k9sit',
	['laydown'] = 'k9laydown',
	['bark'] = 'k9bark',
	['Sniff'] = 'k9Sniff',
	['Beg'] = 'k9beg',
	['Gimme Paw'] = 'k9gimme',
	['petting'] = 'k9pet',
	['Scratch'] = 'k9Scrat',
}

-- ANIMATIONS --
-- u can add more
CFG.DOG_ANIMATIONS = {
	--[[
		FLAGS:
		1 = repeat animation
		2 = stop on last frame of animation
		0 = normal
	]]

	[1] = {
		name = "Sit",
		dict = "creatures@rottweiler@tricks@", anim = "sit_enter", flags = 2,
	},
	[2] = {
		name = "Lay Down / Get Up",
		dict = "creatures@rottweiler@amb@sleep_in_kennel@", anim = "sleep_in_kennel", flags = 2,
	},
	[3] = {
		name = "Bark",
		dict = "creatures@rottweiler@amb@world_dog_barking@idle_a", anim = "idle_a", flags = 1,
	},
	[4] = {
		name = "Indication",
		dict = "creatures@rottweiler@indication@", anim = "indicate_high", flags = 2,
	},
	[5] = {
		name = "Sniff",
		dict = "creatures@rottweiler@indication@", anim = "indicate_low", flags = 2,
	},
	[6] = {
		name = "Beg",
		dict = "creatures@rottweiler@tricks@", anim = "beg_enter", flags = 2,
	},
	[7] = {
		name = "Gimme Paw",
		dict = "creatures@rottweiler@tricks@", anim = "paw_right_enter", flags = 2,
	},
	[8] = {
		name = "Petting",
		dict = "creatures@rottweiler@tricks@", anim = "petting_chop", flags = 2,
	},	
	[9] = {
		name = "Scratch",
		dict = "creatures@rottweiler@amb@world_dog_sitting@idle_a", anim = "Itch (big dog)", flags = 2,
	},	
}

-- LANG --
CFG.LANG = {
	ox_notify_header = 'K9 ALERT',

	register_header = 'REGISTER YOUR DOG',
	breed = 'Choose breed of the dog',
	name_dog = 'Name Your K9',
	register_dog = 'Register K9',
	name = 'Name',

	select_dog = 'SELECT YOUR DOG',
	k9_menu = 'K9 MENU',

	spawn = 'Spawn | Remove K9',
	spawn_desc = 'Call your dog',

	follow = 'Follow',
	stop = 'Stop',
	follow_desc = 'Have your dog follow you',

	get_in = 'Get In',
	get_out = 'Get Out',
	get_desc = 'Send your in or out of a Vehicle',

	search_ped = 'Search Player',
	search_veh = 'Search Vehicle',
	search_desc = 'Search Options',

	track = 'Tracking',
	track_player = 'Track Player',
	find_tracks = 'Find Tracks',
	insert_id = 'Insert player id',

	animations = 'Animations',
	anim_desc = 'Play dog animations',

	reselect = 'Reselect Dog',
	reselect_desc = 'Open selection menu',

	other = 'Other Options',
	other_desc = 'Some cool features hiding there',

	main_actions = 'Care about your dog',

	check_dog = 'Check Status',
	check_desc = 'Make sure your dog is okay',

	carry = 'Carry',
	carry_desc = 'Carry your dog',
	stop_carry = 'Press ~INPUT_DETONATE~ to ~r~stop ~w~carrying.',

	feed_dog = 'Feed',
	feed_desc = 'Give him some good meal',

	ball = 'Ball',
	fetch = 'Fetch',
	play_desc = 'Play fetch or throw ball!',

	spawn_house = 'Place House',
	go_into_house = 'Go | Leave - House',
	house_desc = 'Build a house or send your dog into house', 
	house_desc2 = 'House Options', 
	missing_house = "House doesn't exist",

	mount_camera = 'Mount | Remove',
	open_camera = 'Check Camera',
	camera_desc = 'Camera Options',

	heal_dog = 'Revive | Heal',
	armor_dog = 'Armor',
	heal_desc = 'Help your dog',

	appearance = 'Appearance',
	dog_style = 'Random Style',
	change_appearance = 'Appearance Menu',
	
	attack = 'Attack!',
	go = 'Go!',

	get_up = 'Press ~INPUT_PICKUP~ to get up.',

	camera_mounted = 'You mounted camera on your dog.',
	camera_removed = 'You removed camera from your dog.',
	mount_first = 'You need to mount camera on the dog first.',

	feeded = 'Dog Belly Full.',
	starving = "Your dog is starving... FEED HIM",
	thirsty = "Your dog is thirsty...",

	dog_died = 'Your dog died and got removed.', 

	missing_item = "You missing required item (%s)",

	status = "Health: %s, Armor: %s, Hunger: %s, Thirst: %s - LVL: %s (MAX %s), XP: %s",

	max_limit = "You can't register more dogs... (limit %i)",

	search = 'Searching...',
	search_found = '%s found something...',
	search_not_found = "%s didn't find anything...",
	nobody_close = 'Nobody close.',

	dog_not_close = 'You must be close to your dog.',

	ball_not_found = "Couldn't find the ball.",
	ball_lost = 'Ball got lost...',
	ball_not_close = 'You are not close to the ball.',

	lvl_up = 'Your dog ranked up to lvl %i!',
	fail_command = "%s didn't follow your command...",

	required_job = "You don't have required job.",

	all_seats_occupied = "All seats are occupied...",
	veh_no_found = "Vehicle not found.",
	no_vehicle = "Couldn't find vehicle, make sure you looking on one.",
	no_plate = "Couldn't find vehicle with plate.",
	veh_no_supported = "This vehicle model isn't supported.",
 
	saved = 'Dog was saved.',
	not_loaded = "Your dog isn't loaded.",

	throw_ball = 'Press ~INPUT_PICKUP~ to throw the ball.',
	call_dog = 'Press ~INPUT_PICKUP~ to call him back.\nPress ~INPUT_DETONATE~ to ~r~stop ~w~activity.',
	stop_activity = 'Press ~INPUT_DETONATE~ to ~r~stop ~w~activity',
	pickup_ball = 'Press ~INPUT_PICKUP~ to pickup ball.\nPress ~INPUT_DETONATE~ to ~r~stop ~w~activity',

	track_player_action = 'Press ~INPUT_PICKUP~ to follow track\nPress ~INPUT_DETONATE~ to ~r~cancel ~w~tracking',
	track_action = 'Change track ~INPUT_CELLPHONE_LEFT~ ~INPUT_CELLPHONE_RIGHT~\nFollow track ~INPUT_PICKUP~',
	track_hint = 'Track #%i - Direction %s - Track is long approx. %i meters',
	dog_found_tracks = 'Dog found %i track/s.',
	dog_nothing_found = "Dog didn't find any track/s...",
	tracking_cooldown = "Your dog is tired.",
}
