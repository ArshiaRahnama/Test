-- Pub by FleeX Team , https://discord.gg/87rGBxgCsa

buyerConfig = {
    ['farm'] = {
        model = `a_f_o_salton_01`,
        coords = {
            vec(153.18, 6645.32, 31.58, 142.21),
            vec(1726.25, 3685.62, 34.71, 103.39)
        },
        buyItems = { -- foroosh player be bot
            ['seed_coca']     = { name = 'seed_coca',     price = 25  },
            ['seed_ephedra']  = { name = 'seed_ephedra',  price = 25  },
            ['seed_cannabis'] = { name = 'seed_cannabis', price = 25  },
            ['seed_poppy']    = { name = 'seed_poppy',    price = 25  },
            ['seed_apple']    = { name = 'seed_apple',    price = 25  },
            ['seed_orange']   = { name = 'seed_orange',   price = 25  },
            ['seed_corn']     = { name = 'seed_corn',     price = 25  },
            ['seed_wheat']    = { name = 'seed_wheat',    price = 25  },
            ['seed_grape']    = { name = 'seed_grape',    price = 25  },
            ['seed_rice']     = { name = 'seed_rice',     price = 25  },
            ['seed_mushroom'] = { name = 'seed_mushroom', price = 25  },
            ['seed_caffee']   = { name = 'seed_caffee',   price = 25  },
            ['wheat_pack']    = { name = 'wheat_pack',    price = 75  },
            ['grape_pack']    = { name = 'grape_pack',    price = 75  },
            ['corn_pack']     = { name = 'corn_pack',     price = 75  },
            ['apple_pack']    = { name = 'apple_pack',    price = 75  },
            ['orange_pack']   = { name = 'orange_pack',   price = 75  },
            ['rice_pack']     = { name = 'rice_pack',     price = 75  },
            ['caffee_pack']   = { name = 'caffee_pack',   price = 75  },
        },
        sellItem = { -- foroosh be player
            ['seed_coca']     = { name = 'seed_coca',     price = 350 },
            ['seed_ephedra']  = { name = 'seed_ephedra',  price = 350 },
            ['seed_cannabis'] = { name = 'seed_cannabis', price = 350 },
            ['seed_poppy']    = { name = 'seed_poppy',    price = 350 },
            ['seed_apple']    = { name = 'seed_apple',    price = 350 },
            ['seed_orange']   = { name = 'seed_orange',   price = 350 },
            ['seed_corn']     = { name = 'seed_corn',     price = 350 },
            ['seed_wheat']    = { name = 'seed_wheat',    price = 350 },
            ['seed_grape']    = { name = 'seed_grape',    price = 350 },
            ['seed_rice']     = { name = 'seed_rice',     price = 350 },
            ['seed_mushroom'] = { name = 'seed_mushroom', price = 350 },
            ['seed_caffee']   = { name = 'seed_caffee',   price = 350 },
        }
    },
    ['drug'] = {
        model = `a_m_o_acult_02`,
        coords = {
            vec(-1224.24, -1491.26, 4.34, 120.71),
        },
        buyItems = { -- foroosh player be bot
            ['marijuana']       = { name = 'marijuana',       price = 350,  black = true }, -- old: 370   new: 262.500
            ['extra_marijuana'] = { name = 'extra_marijuana', price = 2600, black = true }, -- old: 3030  new: 390.000
            ['cocaine']         = { name = 'cocaine',         price = 3000, black = true }, -- old: 2750  new: 180.000
            ['crack']           = { name = 'crack',           price = 2000, black = true }, -- old: 1750  new: 240.000
            ['extra_crack']     = { name = 'extra_crack',     price = 2800, black = true }, -- old: 3300  new: 336.000
            ['heroine']         = { name = 'heroine',         price = 6500, black = true }, -- old: 5600  new: 260.000
            ['extra_heroine']   = { name = 'extra_heroine',   price = 4150, black = true }, -- old: 4750  new: 332.000
            ['meth']            = { name = 'meth',            price = 6600, black = true }, -- old: 6650  new: 264.000
            ['extra_meth']      = { name = 'extra_meth',      price = 4200, black = true }, -- old: 6650  new: 336.000
        },
    },
    ['hunter'] = {
        model = `a_f_o_salton_01`,
        coords = {
            vec(-1649.48, 150.59, 62.17, 206.51),
        },
        buyItems = { -- foroosh player be bot
            -- hunting
            ['husky_skin']      = { name = 'husky_skin',        price = 21000 },
            ['retriever_skin']  = { name = 'retriever_skin',    price = 21000 },
            ['rottweiler_skin'] = { name = 'rottweiler_skin',   price = 21000 },
            ['shepherd_skin']   = { name = 'shepherd_skin',     price = 21000 },
            ['panther_skin']    = { name = 'panther_skin',      price = 47000 },
            ['pig_skin']        = { name = 'pig_skin',          price = 10900 },
            ['deer_skin']       = { name = 'deer_skin',         price = 4700  },
            ['boar_skin']       = { name = 'boar_skin',         price = 7200  },
            ['boar_meat']       = { name = 'boar_meat',         price = 5200  },
            ['deer_meat']       = { name = 'deer_meat',         price = 3900  },
            ['pig_meat']        = { name = 'pig_meat',          price = 3200  },
            ['rabbit_meat']     = { name = 'rabbit_meat',       price = 8000  },
            ['pigeon_meat']     = { name = 'pigeon_meat',       price = 8000  },
            -- fishing
            ['mahi_sardine']    = { name = 'mahi_sardine',      price = 435,   fish = true },
            ['mahi_sangsar']    = { name = 'mahi_sangsar',      price = 560,   fish = true },
            ['mahi_ordak']      = { name = 'mahi_ordak',        price = 570,   fish = true },
            ['mahi_ghezel']     = { name = 'mahi_ghezel',       price = 585,   fish = true },
            ['mahi_hamoor']     = { name = 'mahi_hamoor',       price = 600,   fish = true },
            ['mahi_sorkhoo']    = { name = 'mahi_sorkhoo',      price = 610,   fish = true },
            ['mahi_salmon']     = { name = 'mahi_salmon',       price = 625,   fish = true },
            ['mahi_shooride']   = { name = 'mahi_shooride',     price = 640,   fish = true },
            ['mahi_tilapia']    = { name = 'mahi_tilapia',      price = 660,   fish = true },
            ['mahi_sefid']      = { name = 'mahi_sefid',        price = 680,   fish = true },
            ['mahi_shir']       = { name = 'mahi_shir',         price = 700,   fish = true },
            ['mahi_meygoo']     = { name = 'mahi_meygoo',       price = 720,   fish = true },
            ['jolbak']          = { name = 'jolbak',            price = 100,   fish = true }
        }
    },
    ['lester'] = {
        model = `ig_lestercrest_2`,
        coords = {
            vec(705.55, -963.91, 30.4, 220.18),
        },
        buyItems = { -- foroosh player be bot
            ['jewels'] = { name = 'jewels', price = 2000, black = true }
        }
    },
    ['market'] = {
        model = `s_m_m_cntrybar_01`,
        coords = {
            vec(1728.16, 6415.75, 35.04, 246.79),   -- shop 1
            vec(-706.15, -913.7, 19.22, 82.54),     -- shop 2
            vec(-3242.84, 1000.03, 12.83, 352.41),  -- shop 3
            vec(2677.6, 3279.69, 55.24, 326.35),    -- shop 4
            vec(1698.08, 4922.95, 42.06, 329.06),   -- shop 5
            vec(-3039.51, 584.37, 7.91, 13.38),     -- shop 6
            vec(372.69, 326.95, 103.57, 254.89),    -- shop 7
            vec(-1820.14, 794.17, 138.09, 128.98),  -- shop 8
            vec(24.48, -1346.75, 29.5, 272.17),     -- shop 9
            vec(549.12, 2670.77, 42.16, 99.83),     -- shop 10
            vec(-46.84, -1758.0, 29.42, 50.86),     -- shop 11
            vec(1164.67, -322.8, 69.21, 100.86),    -- shop 12
            vec(2556.68, 380.87, 108.62, 359.46),   -- shop 13
            vec(1959.86, 3740.44, 32.34, 304.24),   -- shop 14
            vec(1134.44, -984.06, 46.42, 276.2),    -- shop 15
            vec(-1220.66, -907.45, 12.33, 33.09),   -- shop 16
            vec(-1487.58, -376.69, 40.16, 130.33),  -- shop 17
            vec(-2966.32, 392.38, 15.04, 91.1),     -- shop 18
            vec(1164.37, 2710.78, 38.16, 177.86),   -- shop 19
            vec(1136.67, -1483.02, 34.84, 269.53),  -- MD 1
            vec(-1850.62, -334.58, 49.25, 142.27),  -- MD 2
            vec(-249.62, 6335.03, 32.43, 139.57),   -- MD paleto
            vec(615.08, -3058.38, 6.07, 358.65),    -- Jazire out
            vec(3900.35, -4720.62, 4.46, 299.24),   -- jazire safe 1
            vec(5597.39, -5213.21, 14.35, 119.2),   -- jazire safe 2
            vec(4897.28, -5744.64, 26.35, 66.73),   -- jazire safe 3
            vec(5497.87, -5850.33, 19.22, 98.61),   -- jazire safe 4
            vec(5019.35, -5718.19, 17.71, 230.78),  -- jazire safe 5
            vec(421.5, -1625.47, 29.29, 324.43),    -- taxi 1
        },
        sellItem = { -- foroosh be player
            ['water']       = { name = 'water',     price = 350   },
            ['bread']       = { name = 'bread',     price = 400   },
            ['titopgold']   = { name = 'titopgold', price = 50000 },
            ['phone']       = { name = 'phone',     price = 3500  },
            ['cigar']       = { name = 'cigar',     price = 100   }
        }
    },
    ['gunshop'] = {
        model = `u_m_y_gunvend_01`,
        coords = {
            vec(-660.09, -936.7, 21.83, 141.31),   -- gunShop 1
            vec(810.35, -2159.0, 29.62, 354.87),   -- gunShop 2
            vec(1696.1, 3760.46, 34.71, 177.69),   -- gunShop 3
            vec(-327.85, 6084.32, 31.45, 182.88),  -- gunShop 4
            vec(250.12, -51.52, 69.94, 23.13),     -- gunShop 5
            vec(22.94, -1105.68, 29.8, 156.51),    -- gunShop 6
            vec(2565.77, 295.69, 108.73, 323.44),  -- gunShop 7
            vec(-1115.21, 2698.9, 18.55, 180.49),  -- gunShop 8
            vec(840.21, -1032.19, 28.19, 316.27),  -- gunShop 9
            vec(-1307.75, -396.07, 36.7, 25.13),   -- gunShop 10
            vec(-3169.77, 1089.15, 20.84, 201.05), -- gunShop 11
            vec(-1982.9, 3299.5, 32.96, 61.4),     -- dummy army public
            vec(-2344.61, 3337.93, 32.97, 243.34)  -- dummy army police
        },
        sellItem = { -- foroosh be player
            ['clip']         = { name = 'clip',         price = 5000    },
            ['radio']        = { name = 'radio',        price = 15000   },
            ['compass']      = { name = 'compass',      price = 15000   },
            ['armor50']      = { name = 'armor50',      price = 60000   },
            ['armor100']     = { name = 'armor100',     price = 100000  },
            ['kingkey']      = { name = 'kingkey',      price = 80000   },
            ['camera']       = { name = 'camera',       price = 60000   },
            ['uav']          = { name = 'uav',          price = 150000  },
            ['armoredhat']   = { name = 'armoredhat',   price = 50000   },
            ['blowtorch']    = { name = 'blowtorch',    price = 40000   },
            ['raspberry']    = { name = 'raspberry',    price = 60000   },
            ['racelaptop']   = { name = 'racelaptop',   price = 30000   },
            ['silencer']     = { name = 'silencer',     price = 40000   },
            ['grip']         = { name = 'grip',         price = 40000   },
            ['flashlight']   = { name = 'flashlight',   price = 15000   },
            ['gholab']       = { name = 'gholab',       price = 10000   },
            ['ghayegh_badi'] = { name = 'ghayegh_badi', price = 30000   },
            ['mask_ghavasi'] = { name = 'mask_ghavasi', price = 50000   },
            ['uwfinder']     = { name = 'uwfinder',     price = 30000   },
            ['dyslisence']   = { name = 'dyslisence',   price = 200000, dys = 60  },
            ['wolfram']      = { name = 'wolfram',      price = 20000, black = true },
            ['WEAPON_BALL']       = { name = 'WEAPON_BALL',       price = 10000   },
            ['WEAPON_FLASHLIGHT'] = { name = 'WEAPON_FLASHLIGHT', price = 20000   },
            ['WEAPON_BAT']        = { name = 'WEAPON_BAT',        price = 200000  },
        }
    },
    ['fueler'] = {
        model = `s_m_m_ccrew_01`,
        coords = {
            vec(554.96, -2323.61, 5.82, 302.15),
            vec(482.67, -2166.42, 5.92, 332.66)
        },
        buyItems = { -- foroosh player be bot
            ['essence'] = { name = 'essence', price = 300 }
        }
    },
    ['tailor'] = {
        model = `a_m_y_bevhills_02`,
        coords = {
            vec(428.09, -809.5, 29.5, 93.19),
            vec(722.37, -976.72, 24.13, 185.59)
        },
        buyItems = { -- foroosh player be bot
            ['clothe'] = { name = 'clothe', price = 2100 }
        }
    },
    ['lumberjack'] = {
        model = `s_m_y_dockwork_01`,
        coords = {
            vec(1209.15, -1281.9, 35.23, 83.87)
        },
        buyItems = { -- foroosh player be bot
            ['packaged_plank'] = { name = 'packaged_plank', price = 1425 }
        }
    },
    ['slaughter'] = {
        model = `s_m_y_dockwork_01`,
        coords = {
            vec(-591.45, -892.64, 25.94, 94.93),
            vec(-1067.24, -2006.65, 14.47, 136.21)
        },
        buyItems = { -- foroosh player be bot
            ['packaged_chicken'] = { name = 'packaged_chicken', price = 250 }
        }
    },
    ['miner'] = {
        model = `s_m_y_dockwork_01`,
        coords = {
            vec(2673.08, 3504.74, 52.71, 347.69),
            vec(926.9, -1567.54, 30.61, 95.79),
            vec(2482.11, 1566.42, 32.72, 178.0),
            vec(2471.71, 1487.98, 36.2, 359.82)
        },
        buyItems = { -- foroosh player be bot
            ['gold']     = { name = 'gold',     price = 20000  },
            ['diamond']  = { name = 'diamond',  price = 5000   },
            ['iron']     = { name = 'iron',     price = 12500  },
            ['aluminum'] = { name = 'aluminum', price = 3000   },
            ['ajor']     = { name = 'ajor',     price = 800    },
        }
    },
    ['chopshop'] = {
        model = `ig_lestercrest_2`,
        coords = {
            vec(607.05, 634.15, 128.95, 164.99)
        },
        buyItems = { -- foroosh player be bot
            ['engine1'] = { name = 'engine1', price = 10000  },
            ['engine2'] = { name = 'engine2', price = 20000  },
            ['engine3'] = { name = 'engine3', price = 40000  },
            ['engine4'] = { name = 'engine4', price = 60000  },
            ['engine5'] = { name = 'engine5', price = 80000  },
            ['engine6'] = { name = 'engine6', price = 100000 },
        },
        -- sellItem = { -- foroosh be player
        --     ['engine1'] = { name = 'engine1', price = 60000  },
        --     ['engine2'] = { name = 'engine2', price = 80000  },
        --     ['engine3'] = { name = 'engine3', price = 100000 },
        --     ['engine4'] = { name = 'engine4', price = 120000 },
        --     ['engine5'] = { name = 'engine5', price = 140000 },
        --     ['engine6'] = { name = 'engine6', price = 160000 },
        --     ['pich']    = { name = 'pich',    price = 5000   },
        -- }
    },
    ['houserob'] = {
        model = `ig_lestercrest_2`,
        coords = {
            vec(1271.86, -1712.26, 54.77, 295.32),
        },
        buyItems = { -- foroosh player be bot
            ['object_v_res_r_figflamenco']               = { name = 'object_v_res_r_figflamenco',               price = 9500  },
            ['object_v_res_sculpt_decf']                 = { name = 'object_v_res_sculpt_decf',                 price = 7000  },
            ['object_prop_j_disptray_05']                = { name = 'object_prop_j_disptray_05',                price = 9200  },
            ['object_v_res_tre_mixer']                   = { name = 'object_v_res_tre_mixer',                   price = 7500  },
            ['object_prop_ld_lap_top']                   = { name = 'object_prop_ld_lap_top',                   price = 11250 },
            ['object_ex_mp_h_acc_coffeemachine_01']      = { name = 'object_ex_mp_h_acc_coffeemachine_01',      price = 7750  },
            ['object_m23_1_prop_m31_laptop_01a']         = { name = 'object_m23_1_prop_m31_laptop_01a',         price = 7000  },
            ['object_vw_prop_casino_art_car_09a']        = { name = 'object_vw_prop_casino_art_car_09a',        price = 7500  },
            ['object_vw_prop_casino_art_console_02a']    = { name = 'object_vw_prop_casino_art_console_02a',    price = 8500  },
            ['object_vw_prop_casino_art_console_01a']    = { name = 'object_vw_prop_casino_art_console_01a',    price = 7500  },
            ['object_prop_micro_02']                     = { name = 'object_prop_micro_02',                     price = 7000  },
            ['object_ch_prop_ch_security_case_01a']      = { name = 'object_ch_prop_ch_security_case_01a',      price = 10000 },
            ['object_ch_prop_ch_security_case_02a']      = { name = 'object_ch_prop_ch_security_case_02a',      price = 10000 },
            ['object_hei_prop_heist_trevor_case']        = { name = 'object_hei_prop_heist_trevor_case',        price = 14000 },
            ['object_hei_prop_heist_thermite_case']      = { name = 'object_hei_prop_heist_thermite_case',      price = 9000  },
            ['object_hei_prop_hei_drug_case']            = { name = 'object_hei_prop_hei_drug_case',            price = 16000 },
            ['object_hei_prop_hei_security_case']        = { name = 'object_hei_prop_hei_security_case',        price = 9000  },
            ['object_v_res_fh_bedsideclock']             = { name = 'object_v_res_fh_bedsideclock',             price = 7500  },
            ['object_v_res_jewelbox']                    = { name = 'object_v_res_jewelbox',                    price = 10000 },
            ['object_v_res_desklamp']                    = { name = 'object_v_res_desklamp',                    price = 9250  },
            ['object_v_res_fh_lampa_on']                 = { name = 'object_v_res_fh_lampa_on',                 price = 11250 },
            ['object_v_res_j_tablelamp1']                = { name = 'object_v_res_j_tablelamp1',                price = 12750 },
            ['object_prop_cash_case_02']                 = { name = 'object_prop_cash_case_02',                 price = 14000 },
            ['object_xs_prop_trophy_presents_01a']       = { name = 'object_xs_prop_trophy_presents_01a',       price = 11250 },
            ['object_v_ilev_ra_doorsafe']                = { name = 'object_v_ilev_ra_doorsafe',                price = 12000 },
            ['object_apa_mp_h_acc_candles_02']           = { name = 'object_apa_mp_h_acc_candles_02',           price = 9375  },
            ['object_prop_big_bag_01']                   = { name = 'object_prop_big_bag_01',                   price = 9000  },
            ['object_prop_drug_package_02']              = { name = 'object_prop_drug_package_02',              price = 8000  },
            ['object_prop_drug_bottle']                  = { name = 'object_prop_drug_bottle',                  price = 7500  },
            ['object_hei_prop_hei_drug_pack_01b']        = { name = 'object_hei_prop_hei_drug_pack_01b',        price = 4000  },
            ['object_vw_prop_casino_art_panther_01c']    = { name = 'object_vw_prop_casino_art_panther_01c',    price = 10875 },
            ['object_vw_prop_casino_art_deer_01a']       = { name = 'object_vw_prop_casino_art_deer_01a',       price = 10500 },
            ['object_prop_tv_cam_02']                    = { name = 'object_prop_tv_cam_02',                    price = 14750 },
            ['object_hei_prop_heist_drug_tub_01']        = { name = 'object_hei_prop_heist_drug_tub_01',        price = 9000  },
            ['object_prop_drug_package']                 = { name = 'object_prop_drug_package',                 price = 8000  },
            ['object_v_res_m_candlelrg']                 = { name = 'object_v_res_m_candlelrg',                 price = 10000 },
            ['object_sf_prop_sf_art_statue_02a']         = { name = 'object_sf_prop_sf_art_statue_02a',         price = 10500 },
            ['object_v_serv_metro_advertmid']            = { name = 'object_v_serv_metro_advertmid',            price = 10000 },
            ['object_hei_prop_hei_bust_01']              = { name = 'object_hei_prop_hei_bust_01',              price = 11000 },
            ['object_prop_food_bs_soda_02']              = { name = 'object_prop_food_bs_soda_02',              price = 10125 },
            ['object_xs_prop_trophy_cup_01a']            = { name = 'object_xs_prop_trophy_cup_01a',            price = 11500 },
            ['object_ba_prop_battle_club_speaker_large'] = { name = 'object_ba_prop_battle_club_speaker_large', price = 8750  },
            ['object_prop_suitcase_01c']                 = { name = 'object_prop_suitcase_01c',                 price = 9000  },
        },
        sellItem = { -- foroosh be player
            ['robhouse1']     = { name = 'robhouse1',     price = 50000 },
            -- ['robcar1']       = { name = 'robcar1',       price = 50000 },
        }
    },
}