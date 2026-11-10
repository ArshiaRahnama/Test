-- Pub by FleeX Team , https://discord.gg/87rGBxgCsa

config = {}
config.items = {
	tvpub = {
		model = `apa_mp_h_str_avunitm_01`,
		range = 30,
	}
}
config.defaultURL = 'https://sunrp.ir/'

config.publicTVs = {
	{
		label = 'Shabake 1',
		url = 'https://telewebion.com/embed/live/tv1',
	},
	{
		label = 'Shabake 2',
		url = 'https://telewebion.com/embed/live/tv1',
	},
	{
		label = 'Shabake 3',
		url = 'https://telewebion.com/embed/live/tv3',
	},
	{
		label = 'Shabake 4',
		url = 'https://telewebion.com/embed/live/tv4',
	},
	{
		label = 'Shabake 5',
		url = 'https://telewebion.com/embed/live/tehran',
	},
	{
		label = 'Shabake Khabar',
		url = 'https://telewebion.com/embed/live/irinn',
	},
	{
		label = 'Shabake Varzesh',
		url = 'https://telewebion.com/embed/live/varzesh',
	},
	{
		label = 'Shabake Nasim',
		url = 'https://telewebion.com/embed/live/nasim',
	},
	{
		label = 'Shabake Tamasha',
		url = 'https://telewebion.com/embed/live/hdtest',
	},
	{
		label = 'Shabake Pooya',
		url = 'https://telewebion.com/embed/live/pooya',
	},
	{
		label = 'Shabake IFilm',
		url = 'https://telewebion.com/embed/live/ifilm',
	},
	{
		label = 'Shabake Namayesh',
		url = 'https://telewebion.com/embed/live/namayesh',
	},
	{
		label = 'Shabake Mostanad',
		url = 'https://telewebion.com/embed/live/mostanad',
	},
	{
		label = 'Shabake Quran',
		url = 'https://telewebion.com/embed/live/quran',
	},
	{
		label = 'Shabake Amuzesh',
		url = 'https://telewebion.com/embed/live/amouzesh',
	},
	{
		label = 'Shabake Ofogh',
		url = 'https://telewebion.com/embed/live/ofogh',
	},
}
config.objects = {
	[`nomodelsmall`] = { -- (ex: DJ stand)
		Distance = 50.0,
		AudioDistance = 50.0,
		Target = 'notarget',
	},
	[`nomodel`] = { -- (ex: DJ stand)
        Distance = 75.0,
		AudioDistance = 75.0,
		Target = 'notarget',
	},
	[`h4_prop_battle_club_speaker_large`] = { -- admin only speaker
        Distance = 75.0,
		AudioDistance = 75.0,
		Target = 'notarget',
	},
	[`ba_prop_battle_club_screen`] = {
        Distance = 50.0,
		AudioDistance = 30.0,
		Target = 'Club_Projector',
	},
	[`prop_tv_flat_01`] = {
        Distance = 30.0,
		AudioDistance = 15.0,
		Target = 'tvscreen',
	},
    [`prop_tv_flat_michael`] = {
        Distance = 30.0,
		AudioDistance = 15.0,
		Target = 'tvscreen',
    },
    [`prop_trev_tv_01`] = {
        Distance = 30.0,
		AudioDistance = 15.0,
		Target = 'tvscreen',
    },
    [`prop_tv_flat_02`] = {
        Distance = 30.0,
		AudioDistance = 15.0,
		Target = 'tvscreen',
    },
    [`prop_tv_flat_02b`] = {
        Distance = 30.0,
		AudioDistance = 15.0,
		Target = 'tvscreen',
    },
    [`prop_tv_flat_03`] = {
        Distance = 30.0,
		AudioDistance = 15.0,
		Target = 'tvscreen',
    },
    [`prop_tv_flat_03b`] = {
        Distance = 30.0,
		AudioDistance = 15.0,
		Target = 'tvscreen',
    },
    [`hei_heist_str_avunitl_03`] = {
        Distance = 30.0,
		AudioDistance = 15.0,
		Target = 'tvscreen',
		MenuOffset = vector3(0.0, -0.5, 1.0)
    },
    [`apa_mp_h_str_avunitm_01`] = {
        Distance = 30.0,
		AudioDistance = 15.0,
		Target = 'tvscreen',
	},
	[`apa_mp_h_str_avunitl_01_b`] = {
        Distance = 30.0,
		AudioDistance = 15.0,
		Target = 'tvscreen',
	},
    [`apa_mp_h_str_avunitm_03`] = {
        Distance = 30.0,
		AudioDistance = 15.0,
		Target = 'tvscreen',
    },
    [`prop_tv_03`] = {
        Distance = 30.0,
		AudioDistance = 15.0,
		Target = 'tvscreen',
    },
    [`des_tvsmash_start`] = {
        Distance = 30.0,
		AudioDistance = 15.0,
		Target = 'tvscreen',
    },
    [`apa_mp_h_str_avunits_01`] = {
        Distance = 30.0,
		AudioDistance = 15.0,
		Target = 'tvscreen',
    },
	[`house_prop_high_tv1`] = {
        Distance = 30.0,
		AudioDistance = 15.0,
		Target = 'tvscreen',
    },
	[`house_prop_high_tv2`] = {
        Distance = 30.0,
		AudioDistance = 15.0,
		Target = 'tvscreen',
    },
    [`apa_mp_h_str_avunits_04`] = {
        Distance = 30.0,
		AudioDistance = 15.0,
		Target = 'tvscreen',
    },
    [`ex_prop_ex_tv_flat_01`] = {
        Distance = 30.0,
		AudioDistance = 15.0,
		Target = 'ex_tvscreen',
    },
    [`v_ilev_cin_screen`] = {
        Distance = 75.0,
		AudioDistance = 75.0,
		Target = 'cinscreen',
		MenuOffset = vector3(0.0, 0.0, -4.0)
	},
	[`v_ilev_cin_screen_baylife`] = {
        Distance = 125.0,
		AudioDistance = 75.0,
		Target = 'cinscreen',
		MenuOffset = vector3(0.0, 0.0, -2.5)
	},
	[`vw_vwint01_betting_screen`] = { -- GetClosestObjectOfType doesn't work with this model
     	Distance = 25.0,
		AudioDistance = 45.0,
		Target = 'casinoscreen_02'
	},
	[`ba_prop_club_screens_02`] = { -- GetClosestObjectOfType doesn't work with this model
        Distance = 50.0,
		AudioDistance = 40.0,
		Target = 'Club_Projector'
	},
	[`h4_prop_battle_club_screen`] = { -- GetClosestObjectOfType doesn't work with this model
		Distance = 50.0,
		AudioDistance = 40.0,
		Target = 'Club_Projector'
	},
	[`v_ilev_mm_screen2`] = {
		Distance = 30.0,
		AudioDistance = 15.0,
		Target = 'tvscreen',
		MenuOffset = vector3(0.0, 0.0, -1.5)
    },
	[`vw_prop_vw_cinema_tv_01`] = {
        Distance = 30.0,
		AudioDistance = 15.0,
		Target = 'tvscreen',
		MenuOffset = vector3(0.0, 0.0, -0.8)
    },
	[`xm_prop_x17_tv_ceiling_scn_01`] = {
        Distance = 30.0,
		AudioDistance = 10.0,
		Target = 'prop_x17_tv_ceil_scn_01',
		MenuOffset = vector3(0.0, 0.0, -1.5)
    },
	[`xm_screen_1`] = {
        Distance = 30.0,
		AudioDistance = 10.0,
		Target = 'prop_x17_tv_ceiling_01',
		MenuOffset = vector3(0.0, 0.0, -1.5)
    },
	[`xm_prop_x17_tv_ceiling_scn_02`] = {
        Distance = 30.0,
		AudioDistance = 10.0,
		Target = 'prop_x17_tv_scrn_01',
		MenuOffset = vector3(0.0, 0.0, -1.5)
    },
	[`xm_prop_x17_tv_scrn_01`] = {
        Distance = 30.0,
		AudioDistance = 10.0,
		Target = 'prop_x17_tv_scrn_01',
    },
	[`xm_prop_x17_tv_scrn_02`] = {
        Distance = 30.0,
		AudioDistance = 10.0,
		Target = 'prop_x17_tv_scrn_02',
    },
	[`xm_prop_x17_tv_scrn_03`] = {
        Distance = 30.0,
		AudioDistance = 10.0,
		Target = 'prop_x17_tv_scrn_03',
    },
	[`xm_prop_x17_tv_scrn_04`] = {
        Distance = 30.0,
		AudioDistance = 10.0,
		Target = 'prop_x17_tv_scrn_04',
    },
	[`xm_prop_x17_tv_scrn_05`] = {
        Distance = 30.0,
		AudioDistance = 10.0,
		Target = 'prop_x17_tv_scrn_05',
    },
	[`xm_prop_x17_tv_scrn_06`] = {
        Distance = 30.0,
		AudioDistance = 10.0,
		Target = 'prop_x17_tv_scrn_06',
    },
	[`xm_prop_x17_tv_scrn_07`] = {
        Distance = 30.0,
		AudioDistance = 10.0,
		Target = 'prop_x17_tv_scrn_07',
    },
	[`xm_prop_x17_tv_scrn_08`] = {
        Distance = 30.0,
		AudioDistance = 10.0,
		Target = 'prop_x17_tv_scrn_08',
    },
	[`xm_prop_x17_tv_scrn_09`] = {
        Distance = 30.0,
		AudioDistance = 10.0,
		Target = 'prop_x17_tv_scrn_09',
    },
	[`xm_prop_x17_tv_scrn_10`] = {
        Distance = 30.0,
		AudioDistance = 10.0,
		Target = 'prop_x17_tv_scrn_10',
    },
	[`xm_prop_x17_tv_scrn_11`] = {
        Distance = 30.0,
		AudioDistance = 10.0,
		Target = 'prop_x17_tv_scrn_11',
    },
	[`xm_prop_x17_tv_scrn_12`] = {
        Distance = 30.0,
		AudioDistance = 10.0,
		Target = 'prop_x17_tv_scrn_12',
    },
	[`xm_prop_x17_tv_scrn_13`] = {
        Distance = 30.0,
		AudioDistance = 10.0,
		Target = 'prop_x17_tv_scrn_13',
    },
	[`xm_prop_x17_tv_scrn_14`] = {
        Distance = 30.0,
		AudioDistance = 10.0,
		Target = 'prop_x17_tv_scrn_14',
    },
	[`xm_prop_x17_tv_scrn_15`] = {
        Distance = 30.0,
		AudioDistance = 10.0,
		Target = 'prop_x17_tv_scrn_15',
    },
	[`xm_prop_x17_tv_scrn_16`] = {
        Distance = 30.0,
		AudioDistance = 10.0,
		Target = 'prop_x17_tv_scrn_16',
    },
	[`xm_prop_x17_tv_scrn_17`] = {
        Distance = 30.0,
		AudioDistance = 10.0,
		Target = 'prop_x17_tv_scrn_17',
    },
	[`xm_prop_x17_tv_scrn_18`] = {
        Distance = 30.0,
		AudioDistance = 10.0,
		Target = 'prop_x17_tv_scrn_18',
    },
	[`xm_prop_x17_tv_scrn_19`] = {
        Distance = 30.0,
		AudioDistance = 10.0,
		Target = 'prop_x17_tv_scrn_19',
    },
	[`xs_prop_arena_screen_tv_01`] = {
		Distance = 30.0,
		AudioDistance = 10.0,
		Target = 'screen_tv_01',
	},
	[`xm_prop_x17_tv_flat_01`] = { --hospital paleto
		Distance = 30.0,
		AudioDistance = 10.0,
		Target = 'tv_flat_01',
		MenuOffset = vector3(0.0, 0.0, 0.1)
	},
	[`xs_prop_arena_bigscreen_01`] = { -- big screens in arena
        Distance = 250.0,
		AudioDistance = 10.0,
		Target = 'bigscreen_01',
    },
	[`vw_vwint01_video_overlay`] = { -- big screens in arena
		Distance = 150.0,
		AudioDistance = 10.0,
		Target = 'casinoscreen_01',
	},
	[`ch_prop_ch_tv_rt_01a`] = { -- Arcadebar
		Distance = 20.0,
		AudioDistance = 15.0,
		Target = 'ch_tv_rt_01a',
		MenuOffset = vector3(0.0, 0.0, -1.0)
	},
	[`ch_chint02_04_screens_columns`] = { -- Arcadebar
		Distance = 20.0,
		AudioDistance = 15.0,
		Target = 'tvscreen',
	},
	[-1804478925] = { -- beachparty
		Distance = 50.0,
		AudioDistance = 30.0,
		Target = 'tvscreen',
	},
	[`prop_huge_display_01`] = {
        Distance = 75.0,
		AudioDistance = 75.0,
		Target = 'big_disp',
		MenuOffset = vector3(0.0, 0.0, -2.0),
	},
	[`prop_huge_display_02`] = {
        Distance = 75.0,
		AudioDistance = 75.0,
		Target = 'big_disp',
		MenuOffset = vector3(0.0, 0.0, -2.0),
	},
	[`bkr_prop_slow_down`] = {
        Distance = 75.0,
		AudioDistance = 75.0,
		Target = 'slow_text',
		MenuOffset = vector3(0.0, 0.0, 1.0),
	},
	[`sr_mp_spec_races_blimp_sign`] = {
        Distance = 75.0,
		AudioDistance = 75.0,
		Target = 'blimp_text',
		MenuOffset = vector3(-6.5, 4.5, -2.0),
	},
	[`prop_tv_flat_01_screen`] = {
        Distance = 75.0,
		AudioDistance = 10.0,
		Target = 'tvscreen',
    },
	[`xm_prop_orbital_cannon_table`] = {
        Distance = 75.0,
		AudioDistance = 10.0,
		Target = 'orbital_table',
		MenuOffset = vector3(0.0, 0.0, 0.0),
    },
	[`xm_prop_x17_screens_02a_08`] = {
        Distance = 75.0,
		AudioDistance = 10.0,
		Target = 'prop_x17_8scrn_08',
		MenuOffset = vector3(0.0, 0.0, 0.0),
    },
	[`sm_prop_smug_tv_flat_01`] = {
        Distance = 30.0,
		AudioDistance = 15.0,
		Target = 'tv_flat_01',
    },
}