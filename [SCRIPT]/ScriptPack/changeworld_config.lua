-- ScriptPack / change world settings (loaded by both client and server)
CWConfig = {}

-- Minimum users.permission_level that may open the world manager and enter ANY world.
CWConfig.AdminPermission = 8

-- Allowed world ids for created worlds. 0 is always the real world.
CWConfig.MinWorldId = 1
CWConfig.MaxWorldId = 99999

-- Where a player is put back if their return position was lost (e.g. world set by another script).
CWConfig.ReturnFallback = { x = 632.23, y = -10.65, z = 82.78, h = 0.0 }

-- Keep ambient peds/traffic off inside worlds.
CWConfig.PopulationInWorlds = false

-- Key that opens the in-world tools menu (players can rebind it in GTA settings).
CWConfig.MenuKey = 'F9'

-- Tools available in a world unless the admin overrides them per world in the manager.
CWConfig.DefaultFlags = {
    menu    = true, -- in-world tools menu
    vehicle = true, -- spawn / delete vehicle
    tp      = true, -- teleport to waypoint
    revive  = true, -- self revive
    weapon  = true, -- refill ammo of the held weapon
    armor   = true, -- full armor
    peds    = true, -- change ped model
    skins   = true, -- saved outfits of the world (/worldskin)
    extras  = false, -- "Fun" tab: god mode, infinite stamina, super run/jump, invisible, time and weather, emotes (event worlds)
    host    = true,  -- "Host" tab: revive / heal / freeze / bring / kick, announcements, countdown. Only for admins, the
                     -- owner of a rented world, and (streamer world) the streamer group - the switch can turn it off per world.
}

-- Ped preview pictures shown in the "Change ped" menu (%s = model name).
CWConfig.PedImageUrl = 'https://docs.fivem.net/peds/%s.webp'

-- Short commands that work inside a world (same tools as the F9 menu).
-- /spawn <model>  /dveh  /revme  /ctp  /armorme  /cgetmaxammo  /openmenu
CWConfig.LegacyCommands = true

-- Streamer entrance: players whose users.`group` matches may use /cw [id] near the hub to
-- move themselves (or another player) into the streamer world, and /bw to come back.
CWConfig.Streamer = {
    enabled = true,
    group   = 'streamer',
    world   = 90,
    radius  = 20.0,
    hub     = { x = 632.2348, y = -10.6546, z = 82.779, h = 0.0 },
}

-- Max vehicles one player can have spawned through the menu at once.
CWConfig.MaxSpawnedVehicles = 3

-- Ped models offered by "Change ped" (GTA V ped asset names). Labels are the model names.
-- A world from CWConfig.StaticWorlds can bring its own `peds` table instead of this one.
local function expand(models)
    local out = {}
    for i = 1, #models do out[i] = { label = models[i], model = models[i] } end
    return out
end

local MALE = {
        'a_m_m_afriamer_01', 'a_m_m_beach_01', 'a_m_m_beach_02', 'a_m_m_bevhills_01', 'a_m_m_bevhills_02',
        'a_m_m_business_01', 'a_m_m_eastsa_01', 'a_m_m_eastsa_02', 'a_m_m_farmer_01', 'a_m_m_fatlatin_01',
        'a_m_m_genfat_01', 'a_m_m_genfat_02', 'a_m_m_golfer_01', 'a_m_m_hasjew_01', 'a_m_m_hillbilly_01',
        'a_m_m_hillbilly_02', 'a_m_m_indian_01', 'a_m_m_ktown_01', 'a_m_m_malibu_01', 'a_m_m_mexcntry_01',
        'a_m_m_mexlabor_01', 'a_m_m_og_boss_01', 'a_m_m_paparazzi_01', 'a_m_m_polynesian_01',
        'a_m_m_prolhost_01', 'a_m_m_rurmeth_01', 'a_m_m_salton_01', 'a_m_m_salton_02', 'a_m_m_salton_03',
        'a_m_m_salton_04', 'a_m_m_skater_01', 'a_m_m_skidrow_01', 'a_m_m_socenlat_01', 'a_m_m_soucent_01',
        'a_m_m_soucent_02', 'a_m_m_soucent_03', 'a_m_m_soucent_04', 'a_m_m_stlat_02', 'a_m_m_tennis_01',
        'a_m_m_tourist_01', 's_m_m_prisguard_01', 'u_m_y_ushi', 'a_m_m_trampbeac_01', 'a_m_o_genstreet_01',
        'a_m_o_ktown_01', 'a_m_o_salton_01', 'a_m_o_soucent_01', 'a_m_o_soucent_02', 'a_m_o_soucent_03',
        'a_m_o_tramp_01', 'a_m_y_beach_01', 'a_m_y_beach_02', 'a_m_y_beach_03', 'a_m_y_beachvesp_01',
        'a_m_y_beachvesp_02', 'a_m_y_bevhills_01', 'a_m_y_bevhills_02', 'a_m_y_breakdance_01',
        'a_m_y_busicas_01', 'a_m_y_business_01', 'a_m_y_business_02', 'a_m_y_business_03',
        'a_m_y_clubcust_01', 'a_m_y_cyclist_01', 'a_m_y_dhill_01', 'a_m_y_downtown_01', 'a_m_y_eastsa_01',
        'a_m_y_eastsa_02', 'a_m_y_epsilon_01', 'a_m_y_epsilon_02', 'a_m_y_gay_01', 'a_m_y_gay_02',
        'a_m_y_genstreet_01', 'a_m_y_genstreet_02', 'a_m_y_golfer_01', 'a_m_y_hasjew_01', 'a_m_y_hiker_01',
        'a_m_y_hippy_01', 'a_m_y_hipster_01', 'a_m_y_hipster_02', 'a_m_y_hipster_03', 'a_m_y_indian_01',
        'a_m_y_jetski_01', 'a_m_y_juggalo_01', 'a_m_y_ktown_01', 'a_m_y_ktown_02', 'a_m_y_latino_01',
        'a_m_y_methhead_01', 'a_m_y_mexthug_01', 'a_m_y_motox_01', 'a_m_y_motox_02', 'a_m_y_musclbeac_01',
        'a_m_y_musclbeac_02', 'a_m_y_polynesian_01', 'a_m_y_roadcyc_01', 'a_m_y_runner_01',
        'a_m_y_runner_02', 'a_m_y_salton_01', 'a_m_y_skater_01', 'a_m_y_skater_02', 'a_m_y_soucent_01',
        'a_m_y_soucent_02', 'a_m_y_soucent_03', 'a_m_y_soucent_04', 'a_m_y_stbla_01', 'a_m_y_stbla_02',
        'a_m_y_stlat_01', 'a_m_y_stwhi_01', 'a_m_y_stwhi_02', 'a_m_y_sunbathe_01', 'a_m_y_surfer_01',
        'a_m_y_vindouche_01', 'a_m_y_vinewood_01', 'a_m_y_vinewood_02', 'a_m_y_vinewood_03',
        'a_m_y_vinewood_04', 'a_m_y_yoga_01', 'a_m_m_mlcrisis_01', 'a_m_y_gencaspat_01',
        'a_m_y_smartcaspat_01', 'cs_andreas', 'cs_bankman', 'cs_barry', 'cs_beverly', 'cs_brad',
        'cs_carbuyer', 'cs_casey', 'cs_chengsr', 'cs_chrisformage', 'cs_clay', 'cs_dale', 'cs_davenorton',
        'cs_devin', 'cs_dom', 'cs_dreyfuss', 'cs_drfriedlander', 'cs_fabien', 'cs_fbisuit_01', 'cs_floyd',
        'cs_hunter', 'cs_jimmyboston', 'cs_jimmydisanto', 'cs_joeminuteman', 'cs_johnnyklebitz', 'cs_josef',
        'cs_josh', 'cs_karen_daniels', 'cs_lamardavis', 'cs_lazlow', 'cs_lazlow_2', 'cs_lestercrest',
        'cs_lifeinvad_01', 'cs_manuel', 'cs_martinmadrazo', 'cs_milton', 'cs_movpremmale', 'cs_mrk',
        'cs_nervousron', 'cs_nigel', 'cs_old_man1a', 'cs_old_man2', 'cs_omega', 'cs_paper', 'cs_priest',
        'cs_prolsec_02', 'cs_russiandrunk', 'cs_siemonyetarian', 'cs_solomon', 'cs_stevehains', 'cs_stretch',
        'cs_tanisha', 'cs_taocheng', 'cs_taostranslator', 'cs_tenniscoach', 'cs_terry', 'cs_tom',
        'cs_tomepsilon', 'cs_tracydisanto', 'cs_wade', 'cs_zimbor', 'csb_abigail', 'csb_agent', 'csb_alan',
        'csb_anton', 'csb_avon', 'csb_ballasog', 'csb_bogdan', 'csb_burgerdrug', 'csb_car3guy1',
        'csb_car3guy2', 'csb_chef', 'csb_chef2', 'csb_chin_goon', 'csb_cletus', 'csb_cop', 'csb_customer',
        'csb_dix', 'csb_englishdave', 'csb_fos_rep', 'csb_g', 'csb_groom', 'csb_grove_str_dlr', 'csb_hao',
        'csb_hugh', 'csb_imran', 'csb_jackhowitzer', 'csb_janitor', 'csb_money', 'csb_mp_agent14',
        'csb_mweather', 'csb_ortega', 'csb_oscar', 'csb_paige', 'csb_popov', 'csb_porndudes',
        'csb_prologuedriver', 'csb_prolsec', 'csb_ramp_gang', 'csb_ramp_hic', 'csb_ramp_hipster',
        'csb_ramp_marine', 'csb_ramp_mex', 'csb_rashcosvki', 'csb_reporter', 'csb_roccopelosi', 'csb_sol',
        'csb_talcc', 'csb_talmm', 'csb_tonyprince', 'csb_trafficwarden', 'csb_undercover', 'csb_vagspeak',
        'csb_avery', 'csb_brucie2', 'csb_tomcasino', 'csb_vincent', 'g_m_importexport_01',
        'g_m_m_armboss_01', 'g_m_m_armgoon_01', 'g_m_m_armlieut_01', 'g_m_m_chemwork_01', 'g_m_m_chiboss_01',
        'g_m_m_chicold_01', 'g_m_m_chigoon_01', 'g_m_m_chigoon_02', 'g_m_m_korboss_01', 'g_m_m_mexboss_01',
        'g_m_m_mexboss_02', 'g_m_y_armgoon_02', 'g_m_y_azteca_01', 'g_m_y_ballaeast_01',
        'g_m_y_ballaorig_01', 'g_m_y_ballasout_01', 'g_m_y_famca_01', 'g_m_y_famdnf_01', 'g_m_y_famfor_01',
        'g_m_y_korean_01', 'g_m_y_korean_02', 'g_m_y_korlieut_01', 'g_m_y_lost_01', 'g_m_y_lost_02',
        'g_m_y_lost_03', 'g_m_y_mexgang_01', 'g_m_y_mexgoon_01', 'g_m_y_mexgoon_02', 'g_m_y_mexgoon_03',
        'g_m_y_pologoon_01', 'g_m_y_pologoon_02', 'g_m_y_salvaboss_01', 'g_m_y_salvagoon_01',
        'g_m_y_salvagoon_02', 'g_m_y_salvagoon_03', 'g_m_y_strpunk_01', 'g_m_y_strpunk_02', 'g_m_m_casrn_01',
        'mp_g_m_pros_01', 'mp_m_avongoon', 'mp_m_boatstaff_01', 'mp_m_bogdangoon', 'mp_m_counterfeit_01',
        'mp_m_exarmy_01', 'mp_m_execpa_01', 'mp_m_famdd_01', 'mp_m_fibsec_01', 'mp_m_forgery_01',
        'mp_m_g_vagfun_01', 'mp_m_meth_01', 'mp_m_securoguard_01', 'mp_m_shopkeep_01', 'mp_m_waremech_01',
        'mp_m_weapexp_01', 'mp_m_weapwork_01', 'mp_m_weed_01', 'mp_s_m_armoured_01', 's_m_m_ammucountry',
        's_m_m_armoured_01', 's_m_m_armoured_02', 's_m_m_autoshop_01', 's_m_m_autoshop_02',
        's_m_m_bouncer_01', 's_m_m_ccrew_01', 's_m_m_chemsec_01', 's_m_m_ciasec_01', 's_m_m_cntrybar_01',
        's_m_m_dockwork_01', 's_m_m_doctor_01', 's_m_m_fiboffice_01', 's_m_m_fiboffice_02',
        's_m_m_fibsec_01', 's_m_m_gaffer_01', 's_m_m_gardener_01', 's_m_m_gentransport',
        's_m_m_hairdress_01', 's_m_m_highsec_01', 's_m_m_highsec_02', 's_m_m_janitor', 's_m_m_lathandy_01',
        's_m_m_lifeinvad_01', 's_m_m_linecook', 's_m_m_lsmetro_01', 's_m_m_mariachi_01', 's_m_m_marine_01',
        's_m_m_marine_02', 's_m_m_migrant_01', 's_m_m_movprem_01', 's_m_m_movspace_01', 's_m_m_paramedic_01',
        's_m_m_pilot_01', 's_m_m_pilot_02', 's_m_m_postal_01', 's_m_m_postal_02', 's_m_m_scientist_01',
        's_m_m_security_01', 's_m_m_snowcop_01', 's_m_m_strperf_01', 's_m_m_strpreach_01',
        's_m_m_strvend_01', 's_m_m_trucker_01', 's_m_m_ups_01', 's_m_m_ups_02', 's_m_o_busker_01',
        's_m_y_airworker', 's_m_y_ammucity_01', 's_m_y_armymech_01', 's_m_y_autopsy_01', 's_m_y_barman_01',
        's_m_y_baywatch_01', 's_m_y_blackops_01', 's_m_y_blackops_02', 's_m_y_blackops_03',
        's_m_y_busboy_01', 's_m_y_chef_01', 's_m_y_clown_01', 's_m_y_clubbar_01', 's_m_y_construct_01',
        's_m_y_construct_02', 's_m_y_cop_01', 's_m_y_dealer_01', 's_m_y_devinsec_01', 's_m_y_dockwork_01',
        's_m_y_doorman_01', 's_m_y_dwservice_01', 's_m_y_dwservice_02', 's_m_y_factory_01',
        's_m_y_fireman_01', 's_m_y_garbage', 's_m_y_grip_01', 's_m_y_hwaycop_01', 's_m_y_marine_01',
        's_m_y_marine_02', 's_m_y_marine_03', 's_m_y_mime', 's_m_y_pestcont_01', 's_m_y_pilot_01',
        's_m_y_prismuscl_01', 's_m_y_prisoner_01', 's_m_y_ranger_01', 's_m_y_robber_01', 's_m_y_sheriff_01',
        's_m_y_shop_mask', 's_m_y_strvend_01', 's_m_y_swat_01', 's_m_y_uscg_01', 's_m_y_valet_01',
        's_m_y_waiter_01', 's_m_y_waretech_01', 's_m_y_winclean_01', 's_m_y_xmech_01', 's_m_y_xmech_02',
        's_m_y_casino_01', 's_m_y_westsec_01', 'hc_driver', 'hc_gunman', 'hc_hacker', 'u_m_m_aldinapoli',
        'u_m_m_bankman', 'u_m_m_bikehire_01', 'u_m_m_doa_01', 'u_m_m_edtoh', 'u_m_m_fibarchitect',
        'u_m_m_filmdirector', 'u_m_m_glenstank_01', 'u_m_m_griff_01', 'u_m_m_jesus_01', 'u_m_m_jewelsec_01',
        'u_m_m_jewelthief', 'u_m_m_markfost', 'u_m_m_partytarget', 'u_m_m_prolsec_01', 'u_m_m_promourn_01',
        'u_m_m_rivalpap', 'u_m_m_spyactor', 'u_m_m_streetart_01', 'u_m_m_willyfist', 'u_m_o_filmnoir',
        'u_m_o_finguru_01', 'u_m_o_taphillbilly', 'u_m_o_tramp_01', 'u_m_y_abner', 'u_m_y_antonb',
        'u_m_y_babyd', 'u_m_y_baygor', 'u_m_y_burgerdrug_01', 'u_m_y_chip', 'u_m_y_cyclist_01',
        'u_m_y_danceburl_01', 'u_m_y_dancelthr_01', 'u_m_y_dancerave_01', 'u_m_y_fibmugger_01',
        'u_m_y_guido_01', 'u_m_y_gunvend_01', 'u_m_y_hippie_01', 'u_m_y_imporage', 'u_m_y_mani',
        'u_m_y_militarybum', 'u_m_y_paparazzi', 'u_m_y_party_01', 'u_m_y_prisoner_01', 'u_m_y_proldriver_01',
        'u_m_y_sbike', 'u_m_y_smugmech_01', 'u_m_y_tattoo_01', 'u_m_m_blane', 'u_m_m_curtis', 'u_m_m_vince',
        'u_m_o_dean', 'u_m_y_caleb', 'u_m_y_croupthief_01', 'u_m_y_gabriel',
}

local FEMALE = {
        'a_f_m_bevhills_01', 'a_f_m_bevhills_02', 'a_f_m_business_02', 'a_f_m_downtown_01',
        'a_f_m_eastsa_01', 'a_f_m_eastsa_02', 'a_f_m_fatbla_01', 'a_f_m_fatwhite_01', 'a_f_m_ktown_01',
        'a_f_m_ktown_02', 'a_f_m_prolhost_01', 'a_f_m_salton_01', 'a_f_m_skidrow_01', 'a_f_m_soucent_01',
        'a_f_m_soucent_02', 'a_f_m_soucentmc_01', 'a_f_m_tourist_01', 'a_f_m_tramp_01', 'a_f_m_trampbeac_01',
        'a_f_o_genstreet_01', 'a_f_o_indian_01', 'a_f_o_ktown_01', 'a_f_o_salton_01', 'a_f_o_soucent_01',
        'a_f_o_soucent_02', 'a_f_y_bevhills_01', 'a_f_y_bevhills_02', 'a_f_y_bevhills_03',
        'a_f_y_bevhills_04', 'a_f_y_business_01', 'a_f_y_business_02', 'a_f_y_business_03',
        'a_f_y_business_04', 'a_f_y_clubcust_01', 'a_f_y_clubcust_02', 'a_f_y_clubcust_03',
        'a_f_y_eastsa_01', 'a_f_y_eastsa_02', 'a_f_y_eastsa_03', 'a_f_y_epsilon_01', 'a_f_y_femaleagent',
        'a_f_y_fitness_01', 'a_f_y_fitness_02', 'a_f_y_genhot_01', 'a_f_y_golfer_01', 'a_f_y_hiker_01',
        'a_f_y_hippie_01', 'a_f_y_hipster_01', 'a_f_y_hipster_02', 'a_f_y_hipster_03', 'a_f_y_hipster_04',
        'a_f_y_indian_01', 'a_f_y_runner_01', 'a_f_y_rurmeth_01', 'a_f_y_scdressy_01', 'a_f_y_skater_01',
        'a_f_y_soucent_01', 'a_f_y_soucent_02', 'a_f_y_soucent_03', 'a_f_y_tennis_01', 'a_f_y_tourist_01',
        'a_f_y_tourist_02', 'a_f_y_vinewood_01', 'a_f_y_vinewood_02', 'a_f_y_vinewood_03',
        'a_f_y_vinewood_04', 'a_f_y_yoga_01', 'a_f_y_gencaspat_01', 'a_f_y_smartcaspat_01',
        'cs_amandatownley', 'cs_ashley', 'cs_debra', 'cs_denise', 'cs_guadalope', 'cs_gurk', 'cs_janet',
        'cs_jewelass', 'cs_karen_daniels', 'cs_magenta', 'cs_marnie', 'cs_maryann', 'cs_michelle',
        'cs_molly', 'cs_movpremf_01', 'cs_mrs_thornhill', 'cs_mrsphillips', 'cs_natalia', 'cs_patricia',
        'cs_tanisha', 'cs_tracydisanto', 'csb_abigail', 'csb_anita', 'csb_bride', 'csb_bryony',
        'csb_denise_friend', 'csb_djblamadon', 'csb_maude', 'csb_mrs_r', 'csb_screen_writer', 'csb_tonya',
        'csb_agatha', 'g_f_importexport_01', 'g_f_y_ballas_01', 'g_f_y_families_01', 'g_f_y_lost_01',
        'g_f_y_vagos_01', 'mp_f_bennymech_01', 'mp_f_boatstaff_01', 'mp_f_cardesign_01', 'mp_f_chbar_01',
        'mp_f_counterfeit_01', 'mp_f_deadhooker', 'mp_f_execpa_01', 'mp_f_execpa_02', 'mp_f_forgery_01',
        'mp_f_helistaff_01', 'mp_f_meth_01', 'mp_f_weed_01', 's_f_m_fembarber', 's_f_m_maid_01',
        's_f_m_shop_high', 's_f_m_sweatshop_01', 's_f_y_airhostess_01', 's_f_y_bartender_01',
        's_f_y_clubbar_01', 's_f_y_cop_01', 's_f_y_factory_01', 's_f_y_hooker_01', 's_f_y_hooker_02',
        's_f_y_hooker_03', 's_f_y_migrant_01', 's_f_y_movprem_01', 's_f_y_ranger_01', 's_f_y_scrubs_01',
        's_f_y_sheriff_01', 's_f_y_shop_low', 's_f_y_shop_mid', 's_f_y_sweatshop_01', 's_f_y_casino_01',
        'ig_denise', 'ig_djtalaurelia', 'u_f_m_miranda', 'u_f_m_miranda_02', 'u_f_m_promourn_01',
        'u_f_o_moviestar', 'u_f_o_prolhost_01', 'u_f_y_bikerchic', 'u_f_y_comjane', 'u_f_y_dancerave_01',
        'u_f_y_dancelthr_01', 'u_f_y_hotposh_01', 'u_f_y_jewelass_01', 'u_f_y_mistress', 'u_f_y_poppymich',
        'u_f_y_poppymich_02', 'u_f_y_princess', 'u_f_y_spyactress', 'u_f_m_casinocash_01',
        'u_f_m_casinoshop_01', 'u_f_m_debbie_01', 'u_f_o_carol', 'u_f_o_eileen', 'u_f_y_beth',
        'u_f_y_lauren',
}

local ANIMAL = {
        'a_c_boar', 'a_c_cat_01', 'a_c_chickenhawk', 'a_c_chimp', 'a_c_chop', 'a_c_cormorant', 'a_c_cow',
        'a_c_coyote', 'a_c_crow', 'a_c_deer', 'a_c_dolphin', 'a_c_fish', 'a_c_hen', 'a_c_humpback',
        'a_c_husky', 'a_c_killerwhale', 'a_c_mtlion', 'a_c_pig', 'a_c_pigeon', 'a_c_poodle', 'a_c_pug',
        'a_c_rabbit_01', 'a_c_rat', 'a_c_retriever', 'a_c_rhesus', 'a_c_rottweiler', 'a_c_seagull',
        'a_c_sharkhammer', 'a_c_sharktiger', 'a_c_shepherd', 'a_c_stingray', 'a_c_westy',
}

CWConfig.Peds = {
    { label = 'Male',   list = expand(MALE) },
    { label = 'Female', list = expand(FEMALE) },
    { label = 'Animal', list = expand(ANIMAL) },
}

-- Optional Discord webhook for join/leave/admin logs. Prefer the convar so the secret stays out of git:
--   set unique_changeworld_webhook "https://discord.com/api/webhooks/..."

-- Worlds that exist only in this file (no database row). They give an id its own tools, label, outfits,
-- ped list, spawn point and - optionally - a fixed access list, like worlds written into a config file.
--   label    = shown in menus
--   flags    = tools of that world (menu, vehicle, tp, revive, weapon, armor, peds, skins, extras, host)
--   access   = { identifiers = { 'steam:...' }, gangs = { 'ballas' } }  who may /joinworld it (admins always can)
--   entrance = { x, y, z, radius }  /joinworld only works near that point (admins ignore it), or
--              { gangBoss = true, radius = 40.0 }  near the boss point of the player's own gang (gangs_data.boss)
--   spawn    = { x, y, z, h }  where players are put when they enter
--   peds     = replaces CWConfig.Peds for this world
--   skins    = { name = 'Label' }  nicer names for outfits saved with /saveworldskin <name> inside the world
CWConfig.StaticWorlds = {
    [90] = {   -- streamer world, entered with /cw
        label = 'Streamer world',
        flags = { menu = true, vehicle = true, tp = true, revive = true, weapon = true, extras = true },
    },
    -- [101] = {
    --     label = 'Police academy',
    --     flags = { menu = true, vehicle = true, tp = true, revive = true, weapon = true },
    --     access = { identifiers = { 'steam:11000010xxxxxxx' }, gangs = { 'police' } },
    --     skins = { police_man = 'Police (man)', police_woman = 'Police (woman)' },
    -- },
}

-- /changeworldrange <range> <world>  (alias /cwr): move everyone within range (+10 m) of you into a world, 0 = back to
-- the main world. Allowed for admins (AdminPermission) and for users.`group` values listed here, e.g. { 'eventteam' }.
CWConfig.Range = {
    maxRange = 100.0,
    groups   = {},
}

-- Inside a world the normal-world things (garage, parking, ATM / bank, houses, shops ...) must not be usable.
-- The garage, parking, bank and property scripts already refuse to work in a world (client and server).
-- These two switches cover every other script that works with E or with ox_target:
--   DisableControlsInWorlds : GTA control ids disabled while inside a world, { 38 } = the E key.
--                             A config world can set its own `disableControls = { ... }` ({} = nothing disabled).
--   BlockTargetInWorlds     : turns ox_target (the "eye" interactions) off while inside a world.
-- Script authors can ask `LocalPlayer.state.world` (0 = main world) or exports.ScriptPack:IsInWorld().
CWConfig.DisableControlsInWorlds = { 38 }
CWConfig.BlockTargetInWorlds = true

-- /wweapon gives weapons only inside a world and takes them away when the player leaves it.
CWConfig.DefaultWeaponAmmo = 250
CWConfig.MaxWeaponAmmo = 1000

-- World shop: a spot on the map where a player presses E to rent a private world for some days.
-- The buyer owns the world: they can name it, add/remove players, set its spawn point and renew it.
-- Price is taken from cash first, then from the bank.
CWConfig.Shop = {
    enabled     = true,
    coords      = { x = 195.17, y = -933.77, z = 30.69 }, -- Legion Square. Move it wherever you like.
    radius      = 2.0,
    blip        = { enabled = true, sprite = 40, colour = 3, label = 'World shop' },
    pricePerDay = 50000,   -- !! set your own price
    minDays     = 1,
    maxDays     = 30,      -- also the longest a world can be renewed to (counted from now)
    maxOwned    = 1,       -- worlds one player may own at the same time
    maxPlayers  = 30,      -- people an owner can whitelist in one world
    idMin       = 1000,    -- bought worlds get the first free id in this range
    idMax       = 9999,
}

-- ---------------------------------------------------------------- menu (F9)
-- 'modern'  = the new NUI menu (tabs, search, ped pictures, quick vehicles / weapons ...)
-- 'classic' = the old ESX.UI.Menu "default" look (Main Menu -> Self / Vehicle / Weapon / Teleport)
CWConfig.MenuStyle = 'modern'
CWConfig.Accent = '#5b8cff'     -- colour of the menu and of the world badge
CWConfig.ShowBadge = true       -- small "WORLD 90" pill at the top of the screen while inside a world

-- Quick lists in the modern menu (one click spawn / give).
CWConfig.QuickVehicles = { 'sultan', 'kuruma', 'elegy2', 'zentorno', 'adder', 'bati', 'sanchez', 'buzzard2', 'dinghy' }
CWConfig.QuickWeapons  = { 'WEAPON_PISTOL', 'WEAPON_COMBATPISTOL', 'WEAPON_SMG', 'WEAPON_CARBINERIFLE', 'WEAPON_PUMPSHOTGUN', 'WEAPON_SNIPERRIFLE' }

-- Teleport tab: places everybody can jump to (a config world can bring its own `teleports = { ... }`).
CWConfig.Teleports = {
    { label = 'Legion Square',     x = 195.17,  y = -933.77,  z = 30.69 },
    { label = 'Los Santos Airport', x = -1037.0, y = -2737.0,  z = 20.2 },
    { label = 'Maze Bank roof',    x = -75.0,   y = -818.0,   z = 326.2 },
    { label = 'Vinewood sign',     x = 711.4,   y = 1198.1,   z = 348.5 },
    { label = 'Sandy Shores',      x = 1852.0,  y = 3687.0,   z = 34.2 },
    { label = 'Mount Chiliad',     x = 450.7,   y = 5566.6,   z = 806.2 },
    { label = 'Paleto Bay',        x = -140.0,  y = 6204.0,   z = 31.2 },
}
CWConfig.MaxSavedSpots = 12     -- personal bookmarks ("Save this spot"), kept on the player's PC

-- Vehicle tab: paint and neon colours.
CWConfig.VehicleColors = {
    { label = 'Black',  color = '#0b0b0d' }, { label = 'White',  color = '#f2f2f2' },
    { label = 'Red',    color = '#d42b2b' }, { label = 'Orange', color = '#ff7a1a' },
    { label = 'Yellow', color = '#f4d00c' }, { label = 'Green',  color = '#22b85a' },
    { label = 'Cyan',   color = '#19c3e6' }, { label = 'Blue',   color = '#2a62ff' },
    { label = 'Purple', color = '#8a3ffc' }, { label = 'Pink',   color = '#ff4fa3' },
}

-- Weapons tab: one click packs (every weapon of the pack is given with DefaultWeaponAmmo).
CWConfig.WeaponPacks = {
    { label = 'Pistols',  weapons = { 'WEAPON_PISTOL', 'WEAPON_COMBATPISTOL', 'WEAPON_APPISTOL', 'WEAPON_PISTOL50' } },
    { label = 'Assault',  weapons = { 'WEAPON_CARBINERIFLE', 'WEAPON_ASSAULTRIFLE', 'WEAPON_SPECIALCARBINE', 'WEAPON_ADVANCEDRIFLE' } },
    { label = 'Heavy',    weapons = { 'WEAPON_PUMPSHOTGUN', 'WEAPON_SNIPERRIFLE', 'WEAPON_COMBATMG', 'WEAPON_SMG' } },
    { label = 'Melee',    weapons = { 'WEAPON_BAT', 'WEAPON_KNIFE', 'WEAPON_CROWBAR', 'WEAPON_MACHETE' } },
    { label = 'Utility',  weapons = { 'GADGET_PARACHUTE', 'WEAPON_FLARE', 'WEAPON_FIREEXTINGUISHER', 'WEAPON_FLASHLIGHT' } },
}

-- Vehicle tab: window tint and headlight colours (the number is what GTA expects).
CWConfig.WindowTints = { { 'None', 0 }, { 'Pure black', 1 }, { 'Dark smoke', 2 }, { 'Light smoke', 3 }, { 'Limo', 5 }, { 'Green', 6 } }
CWConfig.HeadlightColors = { { 'White', 0 }, { 'Blue', 1 }, { 'Electric blue', 2 }, { 'Mint green', 3 }, { 'Lime green', 4 }, { 'Yellow', 5 }, { 'Golden', 6 }, { 'Orange', 7 }, { 'Red', 8 }, { 'Pony pink', 9 }, { 'Hot pink', 10 }, { 'Purple', 11 }, { 'Blacklight', 12 } }

-- Fun tab: emotes (GTA scenario names).
CWConfig.Emotes = {
    { 'Smoke', 'WORLD_HUMAN_SMOKING' }, { 'Hang out', 'WORLD_HUMAN_HANG_OUT_STREET' }, { 'Cheer', 'WORLD_HUMAN_CHEERING' },
    { 'Phone', 'WORLD_HUMAN_STAND_MOBILE' }, { 'Push ups', 'WORLD_HUMAN_PUSH_UPS' }, { 'Yoga', 'WORLD_HUMAN_YOGA' },
    { 'Flex', 'WORLD_HUMAN_MUSCLE_FLEX' }, { 'Sunbathe', 'WORLD_HUMAN_SUNBATHE_BACK' }, { 'Party', 'WORLD_HUMAN_PARTYING' },
    { 'Jog on the spot', 'WORLD_HUMAN_JOG_STANDING' },
}

-- Fun tab (needs the `extras` tool): time of day and weather are changed for the player only.
CWConfig.TimePresets = { { label = 'Morning', hour = 8 }, { label = 'Noon', hour = 12 }, { label = 'Evening', hour = 19 }, { label = 'Night', hour = 0 } }
CWConfig.WeatherTypes = {
    { label = 'Extra sunny', type = 'EXTRASUNNY' }, { label = 'Clear', type = 'CLEAR' }, { label = 'Clouds', type = 'CLOUDS' },
    { label = 'Overcast', type = 'OVERCAST' }, { label = 'Rain', type = 'RAIN' }, { label = 'Thunder', type = 'THUNDER' },
    { label = 'Fog', type = 'FOGGY' }, { label = 'Snow', type = 'XMAS' },
}

-- ---------------------------------------------------------------- who may enter a world, and from where
-- Applies to /joinworld and to every Enter button (join screen, My worlds, shop). Admins ignore it, and so do
-- the admin tools (/changeworld, /changeworldrange, /cw ...), which move people on purpose.
CWConfig.Entrance = {
    enabled = true,

    -- WHO: only these people may use the command. Every list that is filled counts; all lists empty = anybody
    -- who has access to the world.   groups = users.`group` values.
    allowed = { identifiers = {}, gangs = {}, groups = {} },

    -- WHERE (1): next to the boss point of the player's own gang (gangs_data.boss). Players without a gang cannot enter.
    nearGang = true,
    gangRadius = 40.0,

    -- WHERE (2): one single place for everybody, e.g. { x = 195.17, y = -933.77, z = 30.69, radius = 15.0 }. nil = anywhere.
    place = nil,

    -- Owners of a rented (shop) world: true = they may enter from anywhere.
    ownersExempt = false,
}
