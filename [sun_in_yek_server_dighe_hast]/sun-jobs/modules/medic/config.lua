-- Pub by FleeX Team , https://discord.gg/87rGBxgCsa

Shared.ambulance = {
	label = 'EMS'
}

Shared.ambulance.config = {
	newLifeTimer = 15 * 60 * 1000,
	respawnTimer = 5 * 60 * 1000,
	extraTimeAdd = 900000,
	needUnit = false,
	customPlate = true,
	platePrefix = 'EMS',
	decor = 'MD',
	billing = {
		customReason = false,
		reason = 'Medic',
		player = true,
		maxBillAmount = 50000,
	},
    objects = {
        { label = 'Takht', 			model = 'gr_prop_gr_campbed_01', 	grade = 13,	freeze = true },
        { label = 'Tablo 1', 		model = 'prop_barrier_work04a', 	grade = 13,	freeze = true },
		{ label = 'Tablo 2', 		model = 'prop_barrier_work06b', 	grade = 13,	freeze = true },
		{ label = 'Kale ghandi', 	model = 'prop_byard_net02', 		grade = 13,	freeze = true },
		{ label = 'gazebo',			model = 'prop_gazebo_02',			grade = 13, freeze = true },
    },
	deathIgnoreWorld = {
		[96] = true,
	},
	anim = {
		injure = {
			dict = 'missfbi5ig_0',
			name = 'lyinginpain_loop_steve',
		},
		revive = {
			sender = {
				dict1 = 'mini@cpr@char_a@cpr_def',
				dict2 = 'mini@cpr@char_a@cpr_str',
				anim1 = 'cpr_intro',
				anim2 = 'cpr_pumpchest',
				anim3 = 'cpr_success',
			},
			reciver = {
				dict1 = 'mini@cpr@char_b@cpr_def',
				dict2 = 'mini@cpr@char_b@cpr_str',
				anim1 = 'cpr_intro',
				anim2 = 'cpr_pumpchest',
				anim3 = 'cpr_success',
			}
		}
	},
	respawnLocation = {
		all = {
			vec(1137.52, -1488.13, 34.84, 36.65),
			-- vec(-1866.72, -341.47, 49.42, 138.68),
			vec(-254.35, 6334.85, 32.43, 227.35),
		},
		police = {
			vec(625.1, -8.58, 82.78, 161.78)
		},
		offpolice = {
			vec(625.1, -8.58, 82.78, 161.78)
		},
		sheriff = {
			vec(470.14, -985.04, 30.69, 90.78)
		},
		offsheriff = {
			vec(470.14, -985.04, 30.69, 90.78)
		},
		mt = {
			vec(-2355.88, 3256.14, 32.81, 144.55)
		},
		offmt = {
			vec(-2355.88, 3256.14, 32.81, 144.55)
		},
		detective = {
			vec(857.97, -1308.05, 28.24, 90.88)
		},
		justice = {
			vec(-567.88, -195.96, 43.37, 210.84)
		},
		fbi = {
			vec(-567.88, -195.96, 43.37, 210.84)
		},
	},
	respawnCost = 30000,
	dropBoxModel = `prop_box_ammo06a`,
	dropBoxDeleteTimeout = 30 * 60000,
	plasticSurgery = {
		models = {
			[`v_med_bed1`] = true,
			[2117668672] = true,
		},
		params = {
			{ k = 'skin', 			price = 100000 },
			-----
			{ k = 'face_1', 		price = 20000 },
			{ k = 'face_2', 		price = 20000 },
			{ k = 'face_3', 		price = 20000 },
			{ k = 'eye_color', 		price = 10000 },
			{ k = 'eye_squint', 	price = 10000 },
			{ k = 'sun_1', 			price = 10000 },
			{ k = 'sun_2', 			price = 10000 },
			{ k = 'moles_1', 		price = 10000 },
			{ k = 'moles_2', 		price = 10000 },
			{ k = 'nose_1', 		price = 10000 },
			{ k = 'nose_2', 		price = 10000 },
			{ k = 'nose_3', 		price = 10000 },
			{ k = 'nose_4', 		price = 10000 },
			{ k = 'nose_5', 		price = 10000 },
			{ k = 'nose_6', 		price = 10000 },
			---
			{ k = 'eye_color', 		price = 10000 },
			{ k = 'eye_squint', 	price = 10000 },
			{ k = 'eyebrows_1', 	price = 10000 },
			{ k = 'eyebrows_2', 	price = 10000 },
			{ k = 'eyebrows_3', 	price = 10000 },
			{ k = 'eyebrows_4', 	price = 10000 },
			{ k = 'eyebrows_5', 	price = 10000 },
			{ k = 'eyebrows_6', 	price = 10000 },
			{ k = 'makeup_1', 		price = 10000 },
			{ k = 'makeup_2', 		price = 10000 },
			{ k = 'makeup_3', 		price = 10000 },
			{ k = 'makeup_4', 		price = 10000 },
			{ k = 'lipstick_1', 	price = 10000 },
			{ k = 'lipstick_2', 	price = 10000 },
			{ k = 'lipstick_3', 	price = 10000 },
			{ k = 'lipstick_4', 	price = 10000 },
			{ k = 'bodyb_1', 		price = 10000 },
			{ k = 'bodyb_2', 		price = 10000 },
			{ k = 'bodyb_3', 		price = 10000 },
			{ k = 'bodyb_4', 		price = 10000 },
			{ k = 'age_1', 			price = 10000 },
			{ k = 'age_2', 			price = 10000 },
			{ k = 'blemishes_1', 	price = 10000 },
			{ k = 'blemishes_2', 	price = 10000 },
			{ k = 'blush_1', 		price = 10000 },
			{ k = 'blush_2', 		price = 10000 },
			{ k = 'blush_3', 		price = 10000 },
			{ k = 'complexion_1', 	price = 10000 },
			{ k = 'complexion_2', 	price = 10000 },
			---
			{ k = 'cheeks_1', 		price = 10000 },
			{ k = 'cheeks_2', 		price = 10000 },
			{ k = 'cheeks_3', 		price = 10000 },
			{ k = 'lip_thickness', 	price = 10000 },
			{ k = 'jaw_1', 			price = 10000 },
			{ k = 'jaw_2', 			price = 10000 },
			{ k = 'chin_1', 		price = 10000 },
			{ k = 'chin_2', 		price = 10000 },
			{ k = 'chin_3', 		price = 10000 },
			{ k = 'chin_4', 		price = 10000 },
			{ k = 'neck_thickness', price = 10000 },
			{ k = 'chest_1', 		price = 10000, cameraType = 1 },
			{ k = 'chest_2', 		price = 10000, cameraType = 1 },
			{ k = 'chest_3', 		price = 10000, cameraType = 1 },
		},
	},
	plasticSurgeryLocations = {
		vec(1143.33, -1581.77, 35.38, 10),
		vec(-1866.63, -326.37, 49.25, 10),
	},
	medicBot = {
		medicNeed = 1,
		timer = 90 * 1000,
		models = {
			`s_m_m_paramedic_01`,
			`s_m_y_autopsy_01`,
			`s_m_m_scientist_01`,
		},
		spawnRadius = 50,
	}
}

Shared.ambulance.menu = {
	{label = function()
		local p = promise.new()
		ESX.TriggerServerCallback('medic:getemslist', function(data)
			p:resolve('Emergency list('.. ESX.tableLength(data) ..')')
		end)
		return Citizen.Await(p)
	end, cb = openMedicRequest},
	{label = 'EMS Menu', cb = openMedicEMS},
	{label = 'Ghabz', cb = openBilling},
	{label = 'Extra Divisions', cb = divisionsMenu},
	{label = 'Ghayegh badi', cb = function()
		exports['sunset_utils']:ghayeghBadi(true, {color1 = 44, color2 = 44})
	end},
	{ label = 'Spawn Object', cb = openSpawnObject},
	{ label = 'license', cb = openLicenseMenu },
    { label = 'Spawn Pet', cb = function ()
        if doesNearAnyStation(100) then
            exports['sunset_utils']:spawnTemporaryPet('a_c_husky_ems')
        else
            ESX.chatMessage('Baraye spawn pet bayad nazdik station bashid', 'job')
        end
    end},
}

Shared.ambulance.ReviveReward               = 7500  -- revive reward, set to 0 if you don't want it enabled
Shared.ambulance.Locale                     = 'medic'

Shared.ambulance.BleedoutTimer              = 5 * (60 * 1000) -- Time til the player bleeds out

Shared.ambulance.RespawnPoint = {
	--vec(1137.52,-1488.13,34.84,36.65),   	-- city 1
	vec(-1866.72, -341.47, 49.42, 138.68),	-- city 2
	--vector4(1836.4,3668.92,33.68,211.04),	-- sandy
	vec(-254.35,6334.85,32.43,227.35),    	-- palato
}

Shared.ambulance.zones = {

	bossAction = {
		vec(1132.54, -1573.77, 35.38),	-- medic 1
		vec(-1823.42, -352.27, 49.25),	-- medic 2
		vec(1776.08, 3656.48, 40.4),	-- Administatior
		vec(-266.78,6323.55,32.43),		-- Palato
	},
	locker = {
		vec(1141.47, -1551.08, 35.38),	-- medic 1
		vec(-1846.19, -331.78, 49.25),	-- medic 2
		vec(1771.04, 3666.43, 35.64),	-- Administatior
		vec(-259.91, 6330.15, 32.43), 	-- palato
	},
	cloakroom = {
		vec(1144.97, -1553.69, 35.38),	-- medic 1
		vec(-1851.04, -332.29, 49.25),	-- medic 2
		vec(1771.81, 3663.41, 35.64),	-- Administatior
		vec(-256.31, 6327.03, 32.43),	-- palato
	},
	vehicles = {
		{
			spawner = vec(1163.77, -1537.84, 34.85),
			spawnPoint = vec(1235.87, -1464.69, 34.69, 2.71),
		},
		{
			spawner = vec(1224.44, -1468.44, 34.84),
			spawnPoint = vec(1235.87, -1464.69, 34.69, 2.71),
		},
		{
			spawner = vec(-1879.26, -316.46, 49.36),
			spawnPoint = vec(-1822.03, -350.54, 43.36, 318),
		},
		{
			spawner = vec(-1842.87, -342.26, 43.69),
			spawnPoint = vec(-1822.03, -350.54, 43.36, 318),
		},
		{
			spawner = vec(1736.15, 3622.2, 35.13),
			spawnPoint = vec(1743.78, 3618.69, 34.99, 208.42),
		},
		{
			spawner = vec(-244.91,6332.73,32.49),
			spawnPoint = vec(-241.52,6335.76,32.19, 225),
		},
		{ -- airport custom
			spawner = vec(-1267.13, -2292.9, 13.94),
			spawnPoint = vec(-1257.6, -2289.01, 13.94, 334.01),
		},
		{ -- shekar
			spawner = vec(-550.76, 5279.63, 73.78),
			spawnPoint = vec(-549.03, 5271.45, 74.12, 162.72),
		},
	},
	vehicleDeleter = {
		vec(1151.93, -1449.36, 34.63),
		vec(1235.87, -1464.69, 34.69),
		vec(1142.24, -1518.87, 47.12),
		vec(1752.0, 3619.26, 34.94),
		vec(-1818.19, -329.63, 42.33),
		vec(-1887.53, -354.82, 48.28),
		vec(-1854.9, -381.67, 47.26),
		vec(-1899.83, -301.06, 48.21),
		vec(-1859.21, -348.84, 58.19),
		vec(1747.29, 3642.39, 41.91),
		vec(-241.52, 6335.76, 32.19),
		vec(-244.82, 6322.07, 39.43),
		vec(-1257.6, -2289.01, 13.94), -- airport custom
		vec(-549.03, 5271.45, 74.12), -- shekar
	},
	helicopters = {
		{
			spawner = vec(1134.15, -1521.65, 47.16),
			spawnPoint = vec(1142.24, -1518.87, 47.12, 269),
		},--medic1
		{
			spawner = vec(-1866.01,-352.22,58.83),   ----        
			spawnPoint = vec(-1859.21,-348.84,59.19, 140.28),
		},--medic2
		{
			spawner = vec(1735.96, 3643.26, 40.07),   ----        
			spawnPoint = vec(1747.28, 3642.39, 41.91, 306),
		}, -- Administatior
		{
			spawner = vec(-248.68,6313.88,39.54),   ----        
			spawnPoint = vec(-244.82,6322.07,39.43, 134),
		}, -- palato
	}
}

Shared.ambulance.healLocation = {
	vec(1142.65, -1538.94, 35.38, 50), 	-- md 1
	vec(-1847.68, -337.54, 49.25, 35), 	-- medic 2
	vec(-251.3, 6324.91, 32.87, 20),	-- md paleto
	vec(1757.84, 3647.03, 35.64, 40),	-- Administatior
	vec(1766.69, 2594.53, 45.73, 20),	-- prison
}

Shared.ambulance.itemShop = {
	water = {count = 20, price = 17500},
	bread = {count = 20, price = 20000},
}
