-- Pub by FleeX Team , https://discord.gg/87rGBxgCsa

Shared.weazel = {
	label = 'Weazel News'
}
Shared.weazel.config = {
	needUnit = false,
	customPlate = true,
	platePrefix = 'WZ',
	decor = 'WZ',
	objects = {
		{ label = "Light 1",				model = 'xm_prop_base_tripod_lampa',	grade = 13, 	freeze = true },
		{ label = "Light 2",				model = 'prop_studio_light_02',			grade = 13, 	freeze = true },
		{ label = "Light stand", 			model = 'xm_prop_base_tripod_lampb',	grade = 13, 	freeze = true },
		{ label = "Board",					model = 'prop_scrim_02',				grade = 13, 	freeze = true },
		{ label = "Camera Stand",			model = 'prop_tv_cam_02',				grade = 13, 	freeze = true },
		{ label = "TV Stand",				model = 'prop_tv_stand_01',				grade = 13, 	freeze = true },
		{ label = "Chair 1", 				model = 'v_ilev_chair02_ped', 			grade = 13, 	freeze = true },
		{ label = "Chair 2",	 			model = 'ex_mp_h_stn_chairstrip_01',	grade = 13, 	freeze = true },
		{ label = "Chair 4", 				model = 'vw_prop_vw_offchair_03',		grade = 13, 	freeze = true },
		{ label = "Chair 5", 				model = 'mp_b_din_chair_02',			grade = 13, 	freeze = true },
		{ label = "worklight", 				model = 'prop_worklight_01a',			grade = 13, 	freeze = true },
		{ label = "lights 3", 				model = 'prop_air_lights_04a',			grade = 13, 	freeze = true },
		{ label = "lights 4", 				model = 'prop_air_lights_05a',			grade = 13, 	freeze = true },
		{ label = "news", 					model = 'ng_proc_paper_news_quik',		grade = 13, 	freeze = true },
		{ label = "disp 1", 				model = 'prop_news_disp_03a',			grade = 13, 	freeze = true },
		{ label = "disp 2", 				model = 'prop_news_disp_01a',			grade = 13, 	freeze = true },
		{ label = "sofacorn",		 		model = 'apa_mp_h_stn_sofacorn_05',		grade = 13, 	freeze = true },
		{ label = "vstage", 				model = 'v_ilev_fos_tvstage',			grade = 13, 	freeze = true },
		{ label = "v_ilev_fos_mic", 		model = 'v_ilev_fos_mic',				grade = 13, 	freeze = true },
		{ label = "v_ilev_mm_screen", 		model = 'v_ilev_mm_screen',				grade = 13, 	freeze = true },
		{ label = "ind_prop_dlc_flag_02",	model = 'ind_prop_dlc_flag_02',			grade = 13, 	freeze = true },
		{ label = "prop_tyre_wall_05", 		model = 'prop_tyre_wall_05',			grade = 13, 	freeze = true },
		{ label = "prop_parasol_02_c", 		model = 'prop_parasol_02_c',			grade = 13, 	freeze = true },
		{ label = "prop_table_01",	 		model = 'prop_table_01',				grade = 13, 	freeze = true },
		{ label = "prop_yaught_chair_01",	model = 'prop_yaught_chair_01',			grade = 13, 	freeze = true },
		{ label = "prop_air_lights_02a",	model = 'prop_air_lights_02a',			grade = 13, 	freeze = true },
		{ label = "prop_air_conelight", 	model = 'prop_air_conelight',			grade = 13, 	freeze = true },
		{ label = "prop_mp_barrier_02", 	model = 'prop_mp_barrier_02',			grade = 13, 	freeze = true },
		{ label = "prop_premier_fence_02", 	model = 'prop_premier_fence_02',		grade = 13, 	freeze = true },
		{ label = "prop_huge_display_01", 	model = 'prop_huge_display_01',			grade = 13, 	freeze = true },
		{ label = "prop_ld_greenscreen_01", model = 'prop_ld_greenscreen_01',		grade = 13, 	freeze = true },
		{ label = "prop_satdish_3_b", 		model = 'prop_satdish_3_b',				grade = 13, 	freeze = true },
		{ label = "prop_walllight_ld_01", 	model = 'prop_walllight_ld_01',			grade = 13, 	freeze = true },
    },
}
Shared.weazel.Locale = 'weazel'

Shared.weazel.menu = {
	{label = 'Spawn Object', cb = openSpawnObject},
}

Shared.weazel.zones = {

    bossAction = {
		vector3(-573.53,-938.98,28.82),
		vector3(-815.85,-697.81,32.14),
    },

	cloakroom = {
		vector3(-584.41,-938.33,23.81),
		vector3(-812.42,-702.07,28.06),
	},

    vehicles = {
		{ -- weazel 1
			spawner    = vector3(-612.34,-927.3,23.86),
			spawnPoint = vector4(-616.26,-920.41,23.42,107.25),
		},

		{ -- weazel 2
			spawner    = vector3(-819.71,-739.65,23.78),
			spawnPoint = vector4(-829.74,-747.75,23.25,88.94),
		},

	},

	helicopters = {
		{ -- weazel 1
			spawner    = vector3(-576.04,-924.35,36.83),
			spawnPoint = vector4(-583.37,-930.53,36.83,90.92),
		},
    },

	vehicleDeleter = {
		vector3(-621.06,-931.06,22.46), -- weazel 1
		vector3(-817.43,-733.19,23.78),	-- weazel 2

		vector3(-583.24,-930.39,36.83), -- weazel 1 heli
	},
}

