-- Pub by FleeX Team , https://discord.gg/87rGBxgCsa

local itemPriceAhari = {
    'object_v_res_r_figflamenco',
    'object_v_res_sculpt_decf',
    'object_prop_j_disptray_05',
    'object_v_res_tre_mixer',
    'object_prop_ld_lap_top',
    'object_ex_mp_h_acc_coffeemachine_01',
    'object_m23_1_prop_m31_laptop_01a',
    'object_vw_prop_casino_art_car_09a',
    'object_vw_prop_casino_art_console_02a',
    'object_vw_prop_casino_art_console_01a',
    'object_prop_micro_02',
    'object_ch_prop_ch_security_case_01a',
    'object_ch_prop_ch_security_case_02a',
    'object_hei_prop_heist_trevor_case',
    'object_hei_prop_heist_thermite_case',
    'object_hei_prop_hei_drug_case',
    'object_hei_prop_hei_security_case',
    'object_v_res_fh_bedsideclock',
    'object_v_res_jewelbox',
    'object_v_res_desklamp',
    'object_v_res_fh_lampa_on',
    'object_v_res_j_tablelamp1',
    'object_prop_cash_case_02',
    'object_xs_prop_trophy_presents_01a',
    'object_v_ilev_ra_doorsafe',
    'object_apa_mp_h_acc_candles_02',
    'object_prop_big_bag_01',
    'object_prop_drug_package_02',
    'object_prop_drug_bottle',
    'object_hei_prop_hei_drug_pack_01b',
    'object_vw_prop_casino_art_panther_01c',
    'object_vw_prop_casino_art_deer_01a',
    'object_prop_tv_cam_02',
    'object_hei_prop_heist_drug_tub_01',
    'object_prop_drug_package',
    'object_v_res_m_candlelrg',
    'object_sf_prop_sf_art_statue_02a',
    'object_v_serv_metro_advertmid',
    'object_hei_prop_hei_bust_01',
    'object_prop_food_bs_soda_02',
    'object_xs_prop_trophy_cup_01a',
    'object_ba_prop_battle_club_speaker_large',
    'object_prop_suitcase_01c',
    'petrol',
    'petrol_raffin',
    'essence',
    'wool',
    'fabric',
    'cutted_wood',
    'iron_piece',
    'iron',
    'gold_piece',
    'gold',
    'diamond',
    'aluminum',
    'gun_metal',
}
local itemPriceCaffe = {
    'orange_pack',
    'corn_pack',
    'wheat_pack',
    'apple_pack',
    'grape_pack',
    'rice_pack',
    'boar_meat',
    'petrol',
    'deer_meat',
    'pig_meat',
    'rabbit_meat',
    'pigeon_meat',
    'mahi_sardine',
    'mahi_sangsar',
    'mahi_ordak',
    'mahi_ghezel',
    'mahi_hamoor',
    'mahi_sorkhoo',
    'mahi_salmon',
    'mahi_shooride',
    'mahi_tilapia',
    'mahi_sefid',
    'mahi_shir',
    'mahi_meygoo',
    'slaughtered_chicken',
    'packaged_chicken',
}
local itemPriceGunShop = {
}
local itemPriceBime = {
}
local itemPriceVekalat = {
    'pl_vakil',
    'lc_vakil',
    'ja_vakil',
    'sa_vakil',
    'cs_vakil',
    'sc_vakil',
    'lcs_vakil',
}
promoConfig = {
    list = {
        -----------------------------------------------------------------------------------
        ['GroveStreet_bime1'] = { -- bime
            owners = {
                'steam:11000010b5a1f6c', -- payam
                'steam:1100001470d5f3a', -- Mehrshad_Shafaghat
                'steam:110000147278f47', -- Alii_Stresss
            },
            phones = {
                { phone = '09357615894', label = 'Fased Sorkhpost' },
                { phone = '09125977457', label = 'Tina Orides' },
                { phone = '09122053566', label = 'Rasa Jan' },
                { phone = '09396514511', label = 'Nariman' },
                { phone = '09122893315', label = 'Slayer' },
                { phone = '09123222242', label = 'ArtinWood' },
                { phone = '09127169997', label = 'Taha Hate' },
                { phone = '09128572901', label = 'Houri' },
                { phone = '09825374464', label = 'Hossein' },
                { phone = '09123777777', label = 'Mehrshad' }
            },
            coords = { vec(-826.87, -754.36, 22.6, 91.78) },
            items = itemPriceBime, models = { `ig_davenorton` },
        },
        ['D_O_J_vakil'] = { -- justice
            owners = {
                'steam:11000010b5a1f6c', -- payam
                'steam:110000154a54e3b', -- Haj_Poya
            },
            phones = {
                { phone = '09319180377', label = 'JA - Keramat Shafiee' },
                { phone = '09382685750', label = 'JA - Shahab Mz' },
                { phone = '09337290731', label = 'JA - Haj Vigo' },
                { phone = '09126768887', label = 'JA - Amuu Wizard' },
                { phone = '09127305401', label = 'JA - Master Suzuki' },
                { phone = '09364384048', label = 'JA - Hajzyrox Fesenjoni' },
                { phone = '09317132714', label = 'JA - Amir Barzi' },
                { phone = '09127068373', label = 'JA - Sina Koper' },
            },
            coords = { vec(-542.93, -197.48, 38.22, 117.96) },
            items = itemPriceVekalat, models = { `ig_davenorton` },
        },
        -----------------------------------------------------------------------------------
        ['GroveStreet_pg1'] = { -- GunShop 1
            owners = {
                'steam:1100001470d5f3a',
            },
            phones = {
                { phone = '09372226033', label = 'Sadegh HZ' },
                { phone = '09375508551', label = 'Amo Erfan' },
                { phone = '09123777777', label = 'Mehrshad' },
            },
            coords = { vec(-1308.22, -389.79, 36.7, 167.01) },
            items = itemPriceGunShop, models = { `ig_davenorton` },
        },
        ['Alghaede_pg1'] = { -- GunShop 2
            owners = {
                'steam:110000146c92c15',
                'steam:110000156461242',
            },
            phones = {
                { phone = '09308714194', label = 'Saman Sicario' },
                { phone = '09333696523', label = 'Abolfazl_Shokoohi' },
            },
            coords = { vec(17.39, -1109.01, 29.8, 245.22) },
            items = itemPriceGunShop, models = { `ig_davenorton` },
        },
        ['ErrorX_pg1'] = { -- GunShop 3
            owners = {
                'steam:11000016d2d0627',
                'steam:11000016adb7054',
                'steam:11000015f9fc3ff',
            },
            phones = {
                { phone = '09121641546', label = 'Majid Asadian' },
                { phone = '09379788353', label = 'Ehsan Ny' },
            },
            coords = { vec(250.33, -45.34, 69.94, 156.28) },
            items = itemPriceGunShop, models = { `ig_davenorton` },
        },
        ['sideA_pg1'] = { -- GunShop 4
            owners = {
                'steam:11000016cd741e1',
                'steam:11000014295b78c',
                'steam:11000014295b78c',
            },
            phones = {
                { phone = '09328484919', label = 'Amin Evoker' },
                { phone = '09369538953', label = 'Neda A' },
                { phone = '09391580255', label = 'King Vonn' },
            },
            coords = { vec(-665.99, -938.61, 21.83, 262.47) },
            items = itemPriceGunShop, models = { `ig_davenorton` },
        },
        ['Delta_Core_pg1'] = { -- GunShop 5
            owners = {
                'steam:11000014af80b34',
                'steam:11000013e85f169',
                'steam:11000012ffb3c11',
            },
            phones = {
                { phone = '09396030778', label = 'Hossein Mohamadii' },
                { phone = '09343691812', label = 'Tiger Parsa' },
                { phone = '09399822900', label = 'Abol Sh' },
            },
            coords = { vec(846.12, -1030.2, 28.19, 83.24) },
            items = itemPriceGunShop, models = { `ig_davenorton` },
        },
        ['Rifa_pg1'] = { -- GunShop 6
            owners = {
                'steam:11000013ff07f16',
                'steam:11000016d2a3518',
                'steam:11000016ebfc391',
            },
            phones = {
                { phone = '09177373652', label = 'Rifa Danial' },
                { phone = '09315610325', label = 'Rifa Mario' },
                { phone = '09333708363', label = 'Rifa Jarvis' },
            },
            coords = { vec(1693.55, 3754.74, 34.71, 315.76) },
            items = itemPriceGunShop, models = { `ig_davenorton` },
        },
        ['2poc_pg1'] = { -- GunShop 7
            owners = {
                'steam:2573c5cdbf9d4a0',
                'steam:110000147903cfa',
                'steam:2df1f6e64da2129',
            },
            phones = {
                { phone = '09308085592', label = 'Mamadi Soli' },
                { phone = '09126232428', label = 'Ali2pac Moriens' },
                { phone = '09128557434', label = 'Arya_Pahlavi' },
            },
            coords = { vec(-330.71, 6078.79, 31.45, 311.18) },
            items = itemPriceGunShop, models = { `ig_davenorton` },
        },
        ['Apachea_pg1'] = { -- GunShop 8
            owners = {
                'steam:11000015e87aad6',
                'steam:11000016e2a1c37',
                'steam:1100001702ec333',
            },
            phones = {
                { phone = '09347751866', label = 'MeHDi HiTman' },
                { phone = '09397250241', label = 'Arshiya Neo' },
                { phone = '09132562467', label = 'Alborz PK' },
            },
            coords = { vec(808.24, -2156.4, 29.62, 266.99) },
            items = itemPriceGunShop, models = { `ig_davenorton` },
        },
-----------------------------------------------------------------------------------
        ['ErrorX_pc1'] = { -- caffe 1
            owners = {
                'steam:11000016d2d0627',
                'steam:11000016adb7054',
                'steam:11000015f9fc3ff',
            },
            phones = {
                { phone = '09121641546', label = 'Majid Asadian' },
                { phone = '09379788353', label = 'Ehsan Ny' },
                { phone = '09301033101', label = 'Mehrshad Sh' },
            },
            coords = { vec(-337.77, -241.85, 34.45, 234.7) },
            items = itemPriceCaffe, models = { `ig_davenorton` },
        },
        ['YANKER_pc1'] = { -- caffe 2
            owners = {
                'steam:11000015ae3affc',
                'steam:1100001488f6ac0',
                'steam:22c1128075ebf73',
            },
            phones = {
                { phone = '09127284385', label = 'Agha Esi' },
                { phone = '09308881001', label = 'Artin' },
                { phone = '09373095643', label = 'Taha' },
            },
            coords = { vec(-224.83, -785.24, 34.09, 73.0) },
            items = itemPriceCaffe, models = { `ig_davenorton` },
        },
        ['Apachea_pc1'] = { -- caffe 3
            owners = {
                'steam:110000166aa8e8d',
                'steam:1100001729e26a2',
                'steam:1100001729a15b3',
            },
            phones = {
                { phone = '09334211718', label = 'Alireza Rbn' },
                { phone = '09332342729', label = 'Ali Sober' },
                { phone = '09381570315', label = 'Amir Itachi' },
            },
            coords = { vec(-1389.21, -592.12, 30.32, 44.66) },
            items = itemPriceCaffe, models = { `ig_davenorton` },
        },
        ['Survival_Team_pc1'] = { -- caffe 4
            owners = {
                'steam:1100001641df769',
                'steam:11000012eae58b5',
                'steam:11000014a90cdfa',
            },
            phones = {
                { phone = '09125964051', label = 'Mamad_Terror' },
                { phone = '09308460977', label = 'Negar_Jooje' },
                { phone = '09319838057', label = 'Awmiroo_Pahlavi' },
            },
            coords = { vec(341.78, -885.81, 29.34, 358.87) },
            items = itemPriceCaffe, models = { `ig_davenorton` },
        },
        ['2poc_pc1'] = { -- caffe 5
            owners = {
                'steam:11000015c32c49a',
                'steam:110000147903cfa',
                'steam:2df1f6e64da2129',
            },
            phones = {
                { phone = '09349500008', label = 'Ali Xelp' },
                { phone = '09126232428', label = 'Ali2pac_Moriens' },
                { phone = '09128557434', label = 'Arya_Pahlavi' },
            },
            coords = { vec(-127.54, 6184.34, 32.38, 51.7) },
            items = itemPriceCaffe, models = { `ig_davenorton` },
        },
        ['Vextoria_pc1'] = { -- caffe 6
            owners = {
                'steam:110000154129240',
                'steam:11000016a6909ef',
            },
            phones = {
                { phone = '09323993208', label = 'Moja K' },
                { phone = '09302366210', label = 'Ali Nouri' },
            },
            coords = { vec(742.96, -720.6, 28.07, 272.43) },
            items = itemPriceCaffe, models = { `ig_davenorton` },
        },
        ['Bleach_pc1'] = { -- caffe 7
            owners = {
                'steam:11000016bbcdee8',
                'steam:11000016f66f0cf',
                'steam:1100001716e0496',
            },
            phones = {
                { phone = '09129415656', label = 'Shab Gard' },
                { phone = '09362223391', label = 'Omid Rzz' },
                { phone = '09319344880', label = 'Mahdi Hex' },
            },
            coords = { vec(78.74, -1583.38, 29.6, 50.07) },
            items = itemPriceCaffe, models = { `ig_davenorton` },
        },
-----------------------------------------------------------------------------------
        ['Amazon_p2'] = { -- Ahangari 1
            owners = {
                'steam:11000013e89f416',
            },
            phones = {
                { phone = '09123749605', label = 'Ali Fara' },
            },
            coords = { vec(-1154.03, -1997.92, 13.18, 218.86) },
            items = itemPriceAhari, models = { `ig_davenorton` },
        },
        ['Apachea_p2'] = { -- Ahangari 2
            owners = {
                'steam:11000015e87aad6',
                'steam:2259bd31ad1a85f',
                'steam:1100001315aa746',
            },
            phones = {
                { phone = '09347751866', label = 'MeHDi HiTman' },
                { phone = '09365269966', label = 'Mahan Snail' },
                { phone = '09304100309', label = 'Hosein Silent' },
            },
            coords = { vec(737.07, -1086.08, 22.17, 90.01) },
            items = itemPriceAhari, models = { `ig_davenorton` },
        },
        ['Hyperion_p2'] = { -- Ahangari 3
            owners = {
                'steam:110000146ef4c91',
                'steam:11000015e75cac7',
                'steam:11000014046d07d',
            },
            phones = {
                { phone = '09384038950', label = 'Iman Shahlla' },
                { phone = '09337851059', label = 'Matin Paytowin' },
                { phone = '09342983700', label = 'Hossein Firoozi' },
            },
            coords = { vec(-208.03, -1329.84, 30.89, 355.79) },
            items = itemPriceAhari, models = { `ig_davenorton` },
        },
        ['ZedFM_p2'] = { -- Ahangari 4
            owners = {
                'steam:11000016e69c54c',
                'steam:11000015ca72e79',
                'steam:110000172d11369',
            },
            phones = {
                { phone = '09121614434', label = 'Kian_jamalzade' },
                { phone = '09389687764', label = 'Mamali_B' },
                { phone = '09121859235', label = 'Arshia_Zz' },
            },
            coords = { vec(1154.68, -784.77, 57.53, 86.79) },
            items = itemPriceAhari, models = { `ig_davenorton` },
        },
        ['Hydra_p2'] = { -- Ahangari 5
            owners = {
                'steam:11000014985b5dc',
                'steam:1100001452c8d47',
                'steam:11000017204f371',
            },
            phones = {
                { phone = '09311945411', label = 'Omid Mozafari' },
                { phone = '09394537268', label = 'Amir Mozafari' },
            },
            coords = { vec(146.16, -1094.02, 29.19, 83.31) },
            items = itemPriceAhari, models = { `ig_davenorton` },
        },
        ['ErrorX_p2'] = { -- Ahangari 6
            owners = {
                'steam:11000016d2d0627',
                'steam:11000016adb7054',
                'steam:11000015f9fc3ff',
            },
            phones = {
                { phone = '09121641546', label = 'Majid Asadian' },
                { phone = '09379788353', label = 'Ehsan Ny' },
            },
            coords = { vec(-345.24, -139.57, 39.01, 333.8) },
            items = itemPriceAhari, models = { `ig_davenorton` },
        },
        ['Delta_Core_p2'] = { -- Ahangari 7
            owners = {
                'steam:11000014af80b34',
                'steam:11000016dd277e0',
            },
            phones = {
                { phone = '09396030778', label = 'Hossein Mohamadii' },
                { phone = '09357825111', label = 'Amirali Rostaei' },
            },
            coords = { vec(477.83, -1317.93, 29.2, 295.25) },
            items = itemPriceAhari, models = { `ig_davenorton` },
        },
    }
}