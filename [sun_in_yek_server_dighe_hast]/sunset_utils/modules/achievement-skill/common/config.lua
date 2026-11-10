-- Pub by FleeX Team , https://discord.gg/87rGBxgCsa

skillsConfig = {

    skills = {
        --#region ------------------------------ Free job
        ['miner_skill'] = {
            label = 'Miner', img = 'miner_skill.png',
            addType = {
                ['wash_stone'] = 1.12,
            },
        },
        ['ghasab_skill'] = {
            label = 'Ghasab', img = 'ghasab_skill.png',
            addType = {
                --['farm_alive_chicken'] = 0.0046,
                ['farm_slaughtered_chicken'] = 0.05,
                ['farm_packaged_chicken'] = 0.05,
            },
            time = {
                ['farm_alive_chicken'] = {50000, 30000},
                ['farm_slaughtered_chicken'] = {50000, 30000},
                ['farm_packaged_chicken'] = {50000, 30000},
            }
        },
        ['clothe_skill'] = {
            label = 'Clothe', img = 'clothe_skill.png',
            addType = {
                -- ['farm_wool'] = 0.0018,
                ['farm_fabric'] = 0.05,
                ['farm_clothe'] = 0.025,
            },
            time = {
                ['farm_wool'] = {40000, 30000},
                ['farm_fabric'] = {50000, 30000},
                ['farm_clothe'] = {25000, 15000},
            }
        },
        ['palayeshgah_skill'] = {
            label = 'Palayeshgah', img = 'palayeshgah_skill.png',
            addType = {
                --['farm_petrol'] = 0.0028,
                ['farm_petrol_raffin'] = 0.015,
                ['farm_essence'] = 0.03,
            },
            time = {
                ['farm_petrol'] = {15000, 10000},
                ['farm_petrol_raffin'] = {15000, 10000},
                ['farm_essence'] = {30000, 20000},
            }
        },
        ['chobbori_skill'] = {
            label = 'Chob Bori', img = 'chobbori_skill.png',
            addType = {
                --['farm_wood'] = 0.0037,
                ['farm_cutted_wood'] = 0.04,
                ['farm_packaged_plank'] = 0.05,
            },
            time = {
                ['farm_wood'] = {16000, 10000},
                ['farm_cutted_wood'] = {40000, 24000},
                ['farm_packaged_plank'] = {50000, 30000},
            }
        },
        ['fishing_skill'] = {
            label = 'Fishing', img = 'fishing_skill.png',
            addType = {
                ['grab_fish'] = 0.005,
            },
            time = {
                ['grab_fish'] = {{10000, 25000}, {10000, 15000}},
            }
        },
        ['hunting_skill'] = {
            label = 'Hunting', img = 'hunting_skill.png',
            addType = {
                ['grab_hunt'] = 0.1111,
            },
        },
        ['yaghi_skill'] = {
            label = 'Yaghi', img = 'yaghi_skill.png',
            addType = {
                ['farm_yaghi'] = 0.185,
            },
            time = {
                ['farm_yaghi'] = {90, 45},
            }
        },
        ['treasure_skill'] = {
            label = 'Ganj', img = 'treasure_skill.png',
            addType = {
                ['farm_treasure'] = 0.37,
            },
        },
        ['barbari_skill'] = {
            label = 'BarBari', img = 'barbari_skill.png',
            addType = {
                ['farm_motor'] = 0.08,
                ['farm_van'] = 0.0952,
                ['farm_truck'] = 0.1176,
            },
        },
        ['marijuana_skill'] = {
            label = 'Sigare Barg', img = 'marijuana_skill.png',
            addType = {
                ['farm_marijuana'] = 0.037,
                -- ['farm_extra_marijuana'] = 0.037,
            },
            time = {
                ['farm_marijuana'] = {35000, 20000},
                ['farm_extra_marijuana'] = {15000, 15000},
            }
        },
        ['crack_skill'] = {
            label = 'Roghane Katan', img = 'crack_skill.png',
            addType = {
                ['farm_cocaine'] = 0.052,
                ['farm_crack'] = 0.052,
                -- ['farm_extra_crack'] = 0.052,
            },
            time = {
                ['farm_cocaine'] = {20000, 12500},
                ['farm_crack'] = {20000, 12500},
                ['farm_extra_crack'] = {25000, 25000},
            }
        },
        ['heroine_skill'] = {
            label = 'Capsule Zire', img = 'heroine_skill.png',
            addType = {
                ['farm_opium'] = 0.0755,
                ['farm_heroine'] = 0.0555,
                -- ['farm_extra_heroine'] = 0.0555,
            },
            time = {
                ['farm_opium'] = {25000, 12500},
                ['farm_heroine'] = {50000, 35000},
                ['farm_extra_heroine'] = {25000, 25000},
            }
        },
        ['meth_skill'] = {
            label = 'Ghorse Ephedrine', img = 'meth_skill.png',
            addType = {
                ['farm_ephedrine'] = 0.0415,
                ['farm_meth'] = 0.625,
                -- ['farm_extra_meth'] = 0.625,
            },
            time = {
                ['farm_ephedrine'] = {40000, 30000},
                ['farm_meth'] = {50000, 35000},
                ['farm_extra_meth'] = {25000, 25000},
            }
        },
        ['farm_skill'] = {          -- farm mazrae
            label = 'Farm', img = 'farm_skill.png',
            addType = {
                ['farm_m_seed_coca'] = 0.01,
                ['farm_m_seed_ephedra'] = 0.02,
                ['farm_m_seed_cannabis'] = 0.03,
                ['farm_m_seed_mushroom'] = 0.02,
                ['farm_m_seed_poppy'] = 0.015,
                ['farm_m_seed_apple'] = 0.02,
                ['farm_m_seed_orange'] = 0.02,
                ['farm_m_seed_corn'] = 0.02,
                ['farm_m_seed_wheat'] = 0.02,
                ['farm_m_seed_grape'] = 0.02,
                ['farm_m_seed_rice'] = 0.02,
                ['farm_m_seed_caffee'] = 0.02,
            },
            time = {
                ['seed_coca'] = {1800, 1350},
                ['seed_ephedra'] = {3600, 2700},
                ['seed_cannabis'] = {5400, 4050},
                ['seed_mushroom'] = {3600, 2700},
                ['seed_poppy'] = {2700, 2025},
                ['seed_apple'] = {3600, 2700},
                ['seed_orange'] = {3600, 2700},
                ['seed_corn'] = {3600, 2700},
                ['seed_wheat'] = {3600, 2700},
                ['seed_grape'] = {3600, 2700},
                ['seed_rice'] = {3600, 2700},
                ['seed_caffee'] = {3600, 2700},
            }
        },
        --#endregion

        --#region ------------------------------ Robbery
        ['shop_skill'] = {
            label = 'Shop', img = 'shop_skill.png',
            addType = {
                ['use_token_shop'] = 0.7,
            },
        },
        ['minibank_skill'] = {
            label = 'MiniBank', img = 'minibank_skill.png',
            addType = {
                ['use_token_minibank'] = 1.7,
            },
        },
        ['jewel_skill'] = {
            label = 'Jewelry', img = 'jewel_skill.png',
            addType = {
                ['use_token_jewel'] = 1.7,
            },
        },
        ['cargo_skill'] = {
            label = 'Cargo', img = 'cargo_skill.png',
            addType = {
                ['use_token_cargo'] = 25.0,
            },
        },
        ['maze_skill'] = {
            label = 'Bank Maze', img = 'maze_skill.png',
            addType = {
                ['use_token_maze'] = 6.25,
            },
        },
        ['paleto_skill'] = {
            label = 'Bank Paleto', img = 'paleto_skill.png',
            addType = {
                ['use_token_paleto'] = 8.4,
            },
        },
        ['bankm_skill'] = {
            label = 'Bank Markazi', img = 'bankm_skill.png',
            addType = {
                ['use_token_bankm'] = 20.0,
            },
        },
        ['flat_skill'] = {
            label = 'Flat', img = 'flat_skill.png',
            addType = {
                ['use_token_flat'] = 20.0,
            },
        },
        ['bime_skill'] = {
            label = 'Bime', img = 'bime_skill.png',
            addType = {
                ['use_token_bime'] = 14.3,
            },
        },
        ['airrob_skill'] = {
            label = 'AirPort', img = 'airrob_skill.png',
            addType = {
                ['use_token_air'] = 14.29,
            },
        },
        ['benny_skill'] = {
            label = 'Benny Mechanic', img = 'benny_skill.png',
            addType = {
                ['use_token_benny'] = 14.3,
            },
        },
        ['gunshop_skill'] = {
            label = 'Gun Shop Robbery', img = 'gunshop_skill.png',
            addType = {
                ['use_token_gunshop'] = 1.7,
            },
        },
        ['mythic_skill'] = {
            label = 'Mythic', img = 'mythic_skill.png',
            addType = {
                ['use_token_mythic'] = 1.0,
            },
        },
        ['persuit_skill'] = {
            label = 'Persuit Robbery', img = 'persuit_skill.png',
            addType = {
                ['finish_persuit'] = 0.5,
            }
        },
        ['houserob_skill'] = {
            label = 'House Robbery', img = 'houserob_skill.png',
            addType = {
                ['houserob_safe'] = 0.5,
            }
        },
        --#endregion

        --#region ------------------------------ Job Dolati
        ['police_skill'] = {
            label = 'Police', img = 'police_skill.png',
            addType = {
                ['search_token_shop'] = 0.02,
                ['search_token_gunshop'] = 0.1,
                ['search_token_minibank'] = 0.15,
                ['police_ghabz'] = 0.1,
                ['police_jail'] = 0.1
            }
        },
        ['sheriff_skill'] = {
            label = 'Sheriff', img = 'sheriff_skill.png',
            addType = {
                ['police_ghabz'] = 0.1,
                ['police_jail'] = 0.1
            }
        },
        ['mt_skill'] = {
            label = 'MT', img = 'mt_skill.png',
            addType = {
                ['search_token_bankm']  = 0.7,
                ['search_token_maze']   = 0.2,
                ['search_token_paleto'] = 1.3,
                ['search_token_flat']   = 0.7,
                ['search_token_jewel']  = 0.1,
                ['search_token_bime']   = 1.3,
                ['search_token_cargo']  = 3.0,
                ['search_token_mythic'] = 5.0,
                ['search_token_air']    = 1.3,
                ['search_token_benny']  = 1.3,
                ['police_jail']         = 0.1,
                ['police_ghabz']        = 0.1,
            }
        },
        ['detective_skill'] = {
            label = 'CID', img = 'detective_skill.png',
            addType = {
                ['police_ghabz'] = 0.1,
                ['police_jail'] = 0.1
            }
        },
        ['justic_skill'] = {
            label = 'Justic', img = 'justic_skill.png',
            addType = {
                ['police_ghabz'] = 0.1,
                ['police_jail'] = 0.1
            }
        },
        ['revive_skill'] = {
            label = 'Medic', img = 'revive_skill.png',
            addType = {
                ['success_revive'] = 0.0667,
            },
            time = {
                ['success_revive'] = {7, 0}, -- if chance <= 7 then
            }
        },
        ['taxi_skill'] = {
            label = 'Taxi', img = 'taxi_skill.png',
            addType = {
                ['finish_req_taxi'] = 0.0667,
            },
            time = {
                ['finish_req_taxi'] = {2.5, 3.5},
            }
        },
        ['peyk_skill'] = {
            label = 'Payk', img = 'peyk_skill.png',
            addType = {
                ['finish_peyk_taxi'] = 0.0667,
            },
            time = {
                ['finish_peyk_taxi'] = {2.5, 3.5},
            }
        },
        ['repair_skill'] = {
            label = 'Mechanic', img = 'repair_skill.png',
            addType = {
                ['success_repair'] = 0.0667,
                -- ['success_custom'] = 3.0,
            },
            time = {
                ['success_repair'] = {5000, 10000},
            }
        },
        --#endregion

        --#region ------------------------------ Other
        ['sport_skill'] = {         -- varzesh
            label = 'Varzesh', img = 'sport_skill.png',
            addType = {
                ['sport_boxing'] = 2,
                ['sport_gym'] = 0.1,
            },
            removeType = {
                ['sport_boxing'] = 0.5,
            },
            time = {
                ['stress_systems'] = {1, 0.5},
            }
        },
        ['drift_skill'] = {         -- Drift
            label = 'Drift', img = 'drift_skill.png',
            addType = {
                ['drift_skillpoint'] = 0.01,
            }
        },
        --#endregion

        --#region ------------------------------ Weapon
        ['pistol_skill'] = {
            label = 'Pistol', img = 'pistol_skill.png', weapon = true,
            addType = {
                ['dummy_kill'] = 0.01,
                ['capture_kill'] = 0.1,
                ['robbery_kill'] = 0.2,
            }
        },
        ['pistol_mk2_skill'] = {
            label = 'Pistol Mk2', img = 'pistol_mk2_skill.png', weapon = true,
            addType = {
                ['dummy_kill'] = 0.01,
                ['capture_kill'] = 0.1,
                ['robbery_kill'] = 0.2,
            }
        },
        ['combatpistol_skill'] = {
            label = 'Combat Pistol', img = 'combatpistol_skill.png', weapon = true,
            addType = {
                ['dummy_kill'] = 0.01,
                ['capture_kill'] = 0.1,
                ['robbery_kill'] = 0.2,
            }
        },
        ['appistol_skill'] = {
            label = 'Ap Pistol', img = 'appistol_skill.png', weapon = true,
            addType = {
                ['dummy_kill'] = 0.01,
                ['capture_kill'] = 0.1,
                ['robbery_kill'] = 0.2,
            }
        },
        ['pistol50_skill'] = {
            label = 'Pistol.50', img = 'pistol50_skill.png', weapon = true,
            addType = {
                ['dummy_kill'] = 0.01,
                ['capture_kill'] = 0.1,
                ['robbery_kill'] = 0.2,
            }
        },
        ['snspistol_mk2_skill'] = {
            label = 'Sns Pistol Mk2', img = 'snspistol_mk2_skill.png', weapon = true,
            addType = {
                ['dummy_kill'] = 0.01,
                ['capture_kill'] = 0.1,
                ['robbery_kill'] = 0.2,
            }
        },
        ['heavypistol_skill'] = {
            label = 'Heavy Pistol', img = 'heavypistol_skill.png', weapon = true,
            addType = {
                ['dummy_kill'] = 0.01,
                ['capture_kill'] = 0.1,
                ['robbery_kill'] = 0.2,
            }
        },
        ['vintagepistol_skill'] = {
            label = 'Vintage Pistol', img = 'vintagepistol_skill.png', weapon = true,
            addType = {
                ['dummy_kill'] = 0.01,
                ['capture_kill'] = 0.1,
                ['robbery_kill'] = 0.2,
            }
        },
        ['doubleaction_skill'] = {
            label = 'Doubleaction', img = 'doubleaction_skill.png', weapon = true,
            addType = {
                ['dummy_kill'] = 0.01,
                ['capture_kill'] = 0.1,
                ['robbery_kill'] = 0.2,
            }
        },
        ['ceramicpistol_skill'] = {
            label = 'Ceramic Pistol', img = 'ceramicpistol_skill.png', weapon = true,
            addType = {
                ['dummy_kill'] = 0.01,
                ['capture_kill'] = 0.1,
                ['robbery_kill'] = 0.2,
            }
        },
        ['gadgetpistol_skill'] = {
            label = 'Gadget Pistol', img = 'gadgetpistol_skill.png', weapon = true,
            addType = {
                ['dummy_kill'] = 0.01,
                ['capture_kill'] = 0.1,
                ['robbery_kill'] = 0.2,
            }
        },
        ['smg_skill'] = {
            label = 'Smg', img = 'smg_skill.png', weapon = true,
            addType = {
                ['dummy_kill'] = 0.01,
                ['capture_kill'] = 0.1,
                ['robbery_kill'] = 0.2,
            }
        },
        ['smg_mk2_skill'] = {
            label = 'Smg Mk2', img = 'smg_mk2_skill.png', weapon = true,
            addType = {
                ['dummy_kill'] = 0.01,
                ['capture_kill'] = 0.1,
                ['robbery_kill'] = 0.2,
            }
        },
        ['assaultsmg_skill'] = {
            label = 'Assault Smg', img = 'assaultsmg_skill.png', weapon = true,
            addType = {
                ['dummy_kill'] = 0.01,
                ['capture_kill'] = 0.1,
                ['robbery_kill'] = 0.2,
            }
        },
        ['microsmg_skill'] = {
            label = 'Micro Smg', img = 'microsmg_skill.png', weapon = true,
            addType = {
                ['dummy_kill'] = 0.01,
                ['capture_kill'] = 0.1,
                ['robbery_kill'] = 0.2,
            }
        },
        ['combatpdw_skill'] = {
            label = 'CombatPDW', img = 'combatpdw_skill.png', weapon = true,
            addType = {
                ['dummy_kill'] = 0.01,
                ['capture_kill'] = 0.1,
                ['robbery_kill'] = 0.2,
            }
        },
        ['pumpshotgun_skill'] = {
            label = 'Pump Shotgun', img = 'pumpshotgun_skill.png', weapon = true,
            addType = {
                ['dummy_kill'] = 0.01,
                ['capture_kill'] = 0.1,
                ['robbery_kill'] = 0.2,
            }
        },
        ['pumpshotgun_mk2_skill'] = {
            label = 'Pump Shotgun Mk2', img = 'pumpshotgun_mk2_skill.png', weapon = true,
            addType = {
                ['dummy_kill'] = 0.01,
                ['capture_kill'] = 0.1,
                ['robbery_kill'] = 0.2,
            }
        },
        ['sawnoffshotgun_skill'] = {
            label = 'SawnOff Shotgun', img = 'sawnoffshotgun_skill.png', weapon = true,
            addType = {
                ['dummy_kill'] = 0.01,
                ['capture_kill'] = 0.1,
                ['robbery_kill'] = 0.2,
            }
        },
        ['assaultshotgun_skill'] = {
            label = 'Assault Shotgun', img = 'assaultshotgun_skill.png', weapon = true,
            addType = {
                ['dummy_kill'] = 0.01,
                ['capture_kill'] = 0.1,
                ['robbery_kill'] = 0.2,
            }
        },
        ['bullpupshotgun_skill'] = {
            label = 'Bullpup Shotgun', img = 'bullpupshotgun_skill.png', weapon = true,
            addType = {
                ['dummy_kill'] = 0.01,
                ['capture_kill'] = 0.1,
                ['robbery_kill'] = 0.2,
            }
        },
        ['combatshotgun_skill'] = {
            label = 'Combat Shotgun', img = 'combatshotgun_skill.png', weapon = true,
            addType = {
                ['dummy_kill'] = 0.01,
                ['capture_kill'] = 0.1,
                ['robbery_kill'] = 0.2,
            }
        },
        ['assaultrifle_skill'] = {
            label = 'Assault Rifle', img = 'assaultrifle_skill.png', weapon = true,
            addType = {
                ['dummy_kill'] = 0.01,
                ['capture_kill'] = 0.1,
                ['robbery_kill'] = 0.2,
            }
        },
        ['assaultrifle_mk2_skill'] = {
            label = 'Assault Rifle Mk2', img = 'assaultrifle_mk2_skill.png', weapon = true,
            addType = {
                ['dummy_kill'] = 0.01,
                ['capture_kill'] = 0.1,
                ['robbery_kill'] = 0.2,
            }
        },
        ['carbinerifle_skill'] = {
            label = 'Carbine Rifle', img = 'carbinerifle_skill.png', weapon = true,
            addType = {
                ['dummy_kill'] = 0.01,
                ['capture_kill'] = 0.1,
                ['robbery_kill'] = 0.2,
            }
        },
        ['carbinerifle_mk2_skill'] = {
            label = 'Carbine Rifle Mk2', img = 'carbinerifle_mk2_skill.png', weapon = true,
            addType = {
                ['dummy_kill'] = 0.01,
                ['capture_kill'] = 0.1,
                ['robbery_kill'] = 0.2,
            }
        },
        ['advancedrifle_skill'] = {
            label = 'Advanced Rifle', img = 'advancedrifle_skill.png', weapon = true,
            addType = {
                ['dummy_kill'] = 0.01,
                ['capture_kill'] = 0.1,
                ['robbery_kill'] = 0.2,
            }
        },
        ['specialcarbine_skill'] = {
            label = 'Special Carbine', img = 'specialcarbine_skill.png', weapon = true,
            addType = {
                ['dummy_kill'] = 0.01,
                ['capture_kill'] = 0.1,
                ['robbery_kill'] = 0.2,
            }
        },
        ['specialcarbine_mk2_skill'] = {
            label = 'Special Carbine Mk2', img = 'specialcarbine_mk2_skill.png', weapon = true,
            addType = {
                ['dummy_kill'] = 0.01,
                ['capture_kill'] = 0.1,
                ['robbery_kill'] = 0.2,
            }
        },
        ['bullpuprifle_skill'] = {
            label = 'Bullpup Rifle', img = 'bullpuprifle_skill.png', weapon = true,
            addType = {
                ['dummy_kill'] = 0.01,
                ['capture_kill'] = 0.1,
                ['robbery_kill'] = 0.2,
            }
        },
        ['bullpuprifle_mk2_skill'] = {
            label = 'Bullpup Rifle Mk2', img = 'bullpuprifle_mk2_skill.png', weapon = true,
            addType = {
                ['dummy_kill'] = 0.01,
                ['capture_kill'] = 0.1,
                ['robbery_kill'] = 0.2,
            }
        },
        ['compactrifle_skill'] = {
            label = 'Compact Rifle', img = 'compactrifle_skill.png', weapon = true,
            addType = {
                ['dummy_kill'] = 0.01,
                ['capture_kill'] = 0.1,
                ['robbery_kill'] = 0.2,
            }
        },
        ['militaryrifle_skill'] = {
            label = 'Military Rifle', img = 'militaryrifle_skill.png', weapon = true,
            addType = {
                ['dummy_kill'] = 0.01,
                ['capture_kill'] = 0.1,
                ['robbery_kill'] = 0.2,
            }
        },
        ['tacticalrifle_skill'] = {
            label = 'Tactical Rifle', img = 'tacticalrifle_skill.png', weapon = true,
            addType = {
                ['dummy_kill'] = 0.01,
                ['capture_kill'] = 0.1,
                ['robbery_kill'] = 0.2,
            }
        },
        ['heavyrifle_skill'] = {
            label = 'Heavy Rifle', img = 'heavyrifle_skill.png', weapon = true,
            addType = {
                ['dummy_kill'] = 0.01,
                ['capture_kill'] = 0.1,
                ['robbery_kill'] = 0.2,
            }
        },
        ['gusenberg_skill'] = {
            label = 'GusenBerg', img = 'gusenberg_skill.png', weapon = true,
            addType = {
                ['dummy_kill'] = 0.01,
                ['capture_kill'] = 0.1,
                ['robbery_kill'] = 0.2,
            }
        },
        ['combatmg_skill'] = {
            label = 'Combat MG', img = 'combatmg_skill.png', weapon = true,
            addType = {
                ['dummy_kill'] = 0.01,
                ['capture_kill'] = 0.1,
                ['robbery_kill'] = 0.2,
            }
        },
        ['combatmg_mk2_skill'] = {
            label = 'Combat MG Mk2', img = 'combatmg_mk2_skill.png', weapon = true,
            addType = {
                ['dummy_kill'] = 0.01,
                ['capture_kill'] = 0.1,
                ['robbery_kill'] = 0.2,
            }
        },
        ['mg_skill'] = {
            label = 'MG', img = 'mg_skill.png', weapon = true,
            addType = {
                ['dummy_kill'] = 0.01,
                ['capture_kill'] = 0.1,
                ['robbery_kill'] = 0.2,
            }
        },
        ['marksmanpistol_skill'] = {
            label = 'Marksman Pistol', img = 'marksmanpistol_skill.png', weapon = true,
            addType = {
                ['dummy_kill'] = 0.01,
                ['capture_kill'] = 0.1,
                ['robbery_kill'] = 0.2,
            }
        },
        ['navyrevolver_skill'] = {
            label = 'Navy Revolver', img = 'navyrevolver_skill.png', weapon = true,
            addType = {
                ['dummy_kill'] = 0.01,
                ['capture_kill'] = 0.1,
                ['robbery_kill'] = 0.2,
            }
        },
        ['pistolxm3_skill'] = {
            label = 'Pistol XM3', img = 'pistolxm3_skill.png', weapon = true,
            addType = {
                ['dummy_kill'] = 0.01,
                ['capture_kill'] = 0.1,
                ['robbery_kill'] = 0.2,
            }
        },
        ['revolver_skill'] = {
            label = 'Revolver', img = 'revolver_skill.png', weapon = true,
            addType = {
                ['dummy_kill'] = 0.01,
                ['capture_kill'] = 0.1,
                ['robbery_kill'] = 0.2,
            }
        },
        ['revolver_mk2_skill'] = {
            label = 'Revolver Mk2', img = 'revolver_mk2_skill.png', weapon = true,
            addType = {
                ['dummy_kill'] = 0.01,
                ['capture_kill'] = 0.1,
                ['robbery_kill'] = 0.2,
            }
        },
        ['autoshotgun_skill'] = {
            label = 'Auto Shotgun', img = 'autoshotgun_skill.png', weapon = true,
            addType = {
                ['dummy_kill'] = 0.01,
                ['capture_kill'] = 0.1,
                ['robbery_kill'] = 0.2,
            }
        },
        ['dbshotgun_skill'] = {
            label = 'DB Shotgun', img = 'dbshotgun_skill.png', weapon = true,
            addType = {
                ['dummy_kill'] = 0.01,
                ['capture_kill'] = 0.1,
                ['robbery_kill'] = 0.2,
            }
        },
        ['heavyshotgun_skill'] = {
            label = 'Heavy Shotgun', img = 'heavyshotgun_skill.png', weapon = true,
            addType = {
                ['dummy_kill'] = 0.01,
                ['capture_kill'] = 0.1,
                ['robbery_kill'] = 0.2,
            }
        },
        ['machinepistol_skill'] = {
            label = 'Machine Pistol', img = 'machinepistol_skill.png', weapon = true,
            addType = {
                ['dummy_kill'] = 0.01,
                ['capture_kill'] = 0.1,
                ['robbery_kill'] = 0.2,
            }
        },
        ['minismg_skill'] = {
            label = 'Mini SMG', img = 'minismg_skill.png', weapon = true,
            addType = {
                ['dummy_kill'] = 0.01,
                ['capture_kill'] = 0.1,
                ['robbery_kill'] = 0.2,
            }
        },
        ['tecpistol_skill'] = {
            label = 'Tactical SMG', img = 'tecpistol_skill.png', weapon = true,
            addType = {
                ['dummy_kill'] = 0.01,
                ['capture_kill'] = 0.1,
                ['robbery_kill'] = 0.2,
            }
        },
        --#endregion
    },

    achievements = {
        --#region ------------------------------ Free job
        ['mining_skillup'] = {
            point = 20,
            label = 'Mining Connoisseur', img = 'mining_skillup.png',
            description = 'برای دریافت این دستاورد، مهارت شغل ماینری را بالا ببرید',
            tasks = { ['skill:miner_skill'] = { max = 1 } }
        },
        ['first_mining_skillup'] = {
            point = 0, hidden = true,
            label = 'First Mining Connoisseur', img = 'first_mining_skillup.png',
            description = 'این نشان، مخصوص اولین نفری است که دستاورد ماینری را بدست آورده',
            tasks = { ['skill:first_miner_skill'] = { max = 1 } }
        },
        ['ghasab_skillup'] = {
            point = 20,
            label = 'Chop Chop Champion', img = 'ghasab_skillup.png',
            description = 'برای دریافت این دستاورد، مهارت شغل قصابی را بالا ببرید',
            tasks = { ['skill:ghasab_skill'] = { max = 1 } }
        },
        ['first_ghasab_skillup'] = {
            point = 0, hidden = true,
            label = 'First Chop Chop Champion', img = 'first_ghasab_skillup.png',
            description = 'این نشان، مخصوص اولین نفری است که دستاورد شغل قصابی را بدست آورده',
            tasks = { ['skill:first_ghasab_skill'] = { max = 1 } }
        },
        ['clothe_skillup'] = {
            point = 20,
            label = 'Tailoring Specialist', img = 'clothe_skillup.png',
            description = 'برای دریافت این دستاورد، مهارت شغل خیاطی را بالا ببرید',
            tasks = { ['skill:clothe_skill'] = { max = 1 } }
        },
        ['first_clothe_skillup'] = {
            point = 0, hidden = true,
            label = 'First Tailoring Specialist', img = 'first_clothe_skillup.png',
            description = 'این نشان، مخصوص اولین نفری است که دستاورد شغل خیاطی را بدست آورده',
            tasks = { ['skill:first_clothe_skill'] = { max = 1 } }
        },
        ['fueler_skillup'] = {
            point = 20,
            label = 'Refinery Expert', img = 'fueler_skillup.png',
            description = 'برای دریافت این دستاورد، مهارت شغل پالایشگاه را بالا ببرید',
            tasks = { ['skill:palayeshgah_skill'] = { max = 1 } }
        },
        ['first_fueler_skillup'] = {
            point = 0, hidden = true,
            label = 'First Refinery Expert', img = 'first_fueler_skillup.png',
            description = 'این نشان، مخصوص اولین نفری است که دستاورد شغل پالایشگاه را بدست آورده',
            tasks = { ['skill:first_palayeshgah_skill'] = { max = 1 } }
        },
        ['lumberjack_skillup'] = {
            point = 20,
            label = 'Professional Carpenter', img = 'lumberjack_skillup.png',
            description = 'برای دریافت این دستاورد، مهارت شغل نجاری را بالا ببرید',
            tasks = { ['skill:chobbori_skill'] = { max = 1 } }
        },
        ['first_lumberjack_skillup'] = {
            point = 0, hidden = true,
            label = 'First Professional Carpenter', img = 'first_lumberjack_skillup.png',
            description = 'این نشان، مخصوص اولین نفری است که دستاورد شغل تجاری را بدست آورده',
            tasks = { ['skill:first_chobbori_skill'] = { max = 1 } }
        },
        ['fishing_skillup'] = {
            point = 20, hidden = true,
            label = 'Fisherman', img = 'fishing_skillup.png',
            description = 'برای دریافت این دستاورد، مهارت ماهیگیری را بالا ببرید',
            tasks = { ['skill:fishing_skill'] = { max = 1 } }
        },
        ['first_fishing_skillup'] = {
            point = 0, hidden = true,
            label = 'First Fisherman', img = 'first_fishing_skillup.png',
            description = 'این نشان، مخصوص اولین نفری است که دستاورد ماهیگیری را بدست آورده',
            tasks = { ['skill:first_fishing_skill'] = { max = 1 } }
        },
        ['hunting_skillup'] = {
            point = 20,
            label = 'Poacher', img = 'hunting_skillup.png',
            description = 'برای دریافت این دستاورد، مهارت شکار را بالا ببرید',
            tasks = { ['skill:hunting_skill'] = { max = 1 } }
        },
        ['first_hunting_skillup'] = {
            point = 0, hidden = true,
            label = 'First Poacher', img = 'first_hunting_skillup.png',
            description = 'این نشان، مخصوص اولین نفری است که دستاورد شکار را بدست آورده',
            tasks = { ['skill:first_hunting_skill'] = { max = 1 } }
        },
        ['yaghi_skillup'] = {
            point = 20,
            label = 'Yaghi', img = 'yaghi_skillup.png',
            description = 'برای دریافت این دستاورد، مهارت یاغی را بالا ببرید',
            tasks = { ['skill:yaghi_skill'] = { max = 1 } }
        },
        ['first_yaghi_skillup'] = {
            point = 0, hidden = true,
            label = 'First Yaghi', img = 'first_yaghi_skillup.png',
            description = 'این نشان، مخصوص اولین نفری است که دستاورد یاغی را بدست آورده',
            tasks = { ['skill:first_yaghi_skill'] = { max = 1 } }
        },
        ['treasure_skillup'] = {
            point = 20,
            label = 'Treasure Hunter', img = 'treasure_skillup.png',
            description = 'برای دریافت این دستاورد، مهارت گنج یابی را بالا ببرید',
            tasks = { ['skill:treasure_skill'] = { max = 1 } }
        },
        ['first_treasure_skillup'] = {
            point = 0, hidden = true,
            label = 'First Treasure Hunter', img = 'first_treasure_skillup.png',
            description = 'این نشان، مخصوص اولین نفری است که دستاورد گنج یابی را بدست آورده',
            tasks = { ['skill:first_treasure_skill'] = { max = 1 } }
        },
        ['barbari_skillup'] = {
            point = 20,
            label = 'Transport Manager', img = 'barbari_skillup.png',
            description = 'برای دریافت این دستاورد، مهارت شغل باربری را بالا ببرید',
            tasks = { ['skill:barbari_skill'] = { max = 1 } }
        },
        ['first_barbari_skillup'] = {
            point = 0, hidden = true,
            label = 'First Transport Manager', img = 'first_barbari_skillup.png',
            description = 'این نشان، مخصوص اولین نفری است که دستاورد شغل باربری را بدست آورده',
            tasks = { ['skill:first_barbari_skill'] = { max = 1 } }
        },
        ['farm_skillup'] = {
            point = 20,
            label = 'Gardener', img = 'farm_skillup.png',
            description = 'برای دریافت این دستاورد، مهارت باغبانی را بالا ببرید',
            tasks = { ['skill:farm_skill'] = { max = 1 } }
        },
        ['first_farm_skillup'] = {
            point = 0, hidden = true,
            label = 'First Gardener', img = 'first_farm_skillup.png',
            description = 'این نشان، مخصوص اولین نفری است که دستاورد باغبانی را بدست آورده',
            tasks = { ['skill:first_farm_skill'] = { max = 1 } }
        },
        ['marijuana_skillup'] = {
            point = 20,
            label = 'Sigare Barg', img = 'marijuana_skillup.png',
            description = 'برای دریافت این دستاورد، مهارت ساخت سیگار برگ را بالا ببرید',
            tasks = { ['skill:marijuana_skill'] = { max = 1 } }
        },
        ['first_marijuana_skillup'] = {
            point = 0, hidden = true,
            label = 'First Sigare Barg', img = 'first_marijuana_skillup.png',
            description = 'این نشان، مخصوص اولین نفری است که دستاورد ساخت سیگار برگ را بدست آورده',
            tasks = { ['skill:first_marijuana_skill'] = { max = 1 } }
        },
        ['crack_skillup'] = {
            point = 20,
            label = 'Roghane Katan', img = 'crack_skillup.png',
            description = 'برای دریافت این دستاورد، مهارت ساخت روغن کتان را بالا ببرید',
            tasks = { ['skill:crack_skill'] = { max = 1 } }
        },
        ['first_crack_skillup'] = {
            point = 0, hidden = true,
            label = 'First Roghane Katan', img = 'first_crack_skillup.png',
            description = 'این نشان، مخصوص اولین نفری است که دستاورد ساخت روغن کتان را بدست آورده',
            tasks = { ['skill:first_crack_skill'] = { max = 1 } }
        },
        ['heroine_skillup'] = {
            point = 20,
            label = 'Capsule Zire', img = 'heroine_skillup.png',
            description = 'برای دریافت این دستاورد، مهارت ساخت کپسول زیره را بالا ببرید',
            tasks = { ['skill:heroine_skill'] = { max = 1 } }
        },
        ['first_heroine_skillup'] = {
            point = 0, hidden = true,
            label = 'First Capsule Zire', img = 'first_heroine_skillup.png',
            description = 'این نشان، مخصوص اولین نفری است که دستاورد ساخت کپسول زیره را بدست آورده',
            tasks = { ['skill:first_heroine_skill'] = { max = 1 } }
        },
        ['meth_skillup'] = {
            point = 20,
            label = 'Ghorse Ephedrine', img = 'meth_skillup.png',
            description = 'برای دریافت این دستاورد، مهارت ساخت قرص افدراین را بالا ببرید',
            tasks = { ['skill:meth_skill'] = { max = 1 } }
        },
        ['first_meth_skillup'] = {
            point = 0, hidden = true,
            label = 'First Ghorse Ephedrine', img = 'first_meth_skillup.png',
            description = 'این نشان، مخصوص اولین نفری است که دستاورد ساخت قرص افدراین را بدست آورده',
            tasks = { ['skill:first_meth_skill'] = { max = 1 } }
        },
        ['alldrug_achievement2'] = {
            point = 50,
            label = 'Cartel', img = 'alldrug_achievement.png',
            description = 'برای دریافت این نشان، دستاوردهای ساخت مواد دارویی را بدست آورید',
            tasks = {
                ['achievement:marijuana_skillup'] = { max = 1 },
                ['achievement:crack_skillup'] = { max = 1 },
                ['achievement:heroine_skillup'] = { max = 1 },
                ['achievement:meth_skillup'] = { max = 1 },
            }
        },
        ['first_alldrug_achievement'] = {
            point = 0, hidden = true,
            label = 'first Cartel', img = 'first_alldrug_achievement.png',
            description = 'این نشان، مخصوص اولین نفری است که دستاورد ساخت همه موادها را بدست آورده',
            tasks = { ['achievement:first_alldrug_achievementup'] = { max = 1 } }
        },
        --#endregion

        --#region ------------------------------ Robbery
        ['shop_skillup'] = {
            point = 20,
            label = 'ShopLifter', img = 'shop_skillup.png',
            description = 'برای دریافت این دستاورد، مهارت دزدی از شاپ را بالا ببرید',
            tasks = { ['skill:shop_skill'] = { max = 1 } }
        },
        ['first_shop_skillup'] = {
            point = 0, hidden = true,
            label = 'First ShopLifter', img = 'first_shop_skillup.png',
            description = 'این نشان، مخصوص اولین نفری است که دستاورد دزدی از شاپ را بدست آورده',
            tasks = { ['skill:first_shop_skill'] = { max = 1 } }
        },
        ['minibank_skillup'] = {
            point = 20,
            label = 'MiniBank Lifter', img = 'minibank_skillup.png',
            description = 'برای دریافت این دستاورد، مهارت دزدی از مینی بانک را بالا ببرید',
            tasks = { ['skill:minibank_skill'] = { max = 1 } }
        },
        ['first_minibank_skillup'] = {
            point = 0, hidden = true,
            label = 'First MiniBank Lifter', img = 'first_minibank_skillup.png',
            description = 'این نشان، مخصوص اولین نفری است که دستاورد دزدی از مینی بانک را بدست آورده',
            tasks = { ['skill:first_minibank_skill'] = { max = 1 } }
        },
        ['jewel_skillup'] = {
            point = 20,
            label = 'Jewel Thief', img = 'jewel_skillup.png',
            description = 'برای دریافت این دستاورد، مهارت دزدی از جواهری را بالا ببرید',
            tasks = { ['skill:jewel_skill'] = { max = 1 } }
        },
        ['first_jewel_skillup'] = {
            point = 0, hidden = true,
            label = 'First Jewel Thief', img = 'first_jewel_skillup.png',
            description = 'این نشان، مخصوص اولین نفری است که دستاورد دزدی از جواهری را بدست آورده',
            tasks = { ['skill:first_jewel_skill'] = { max = 1 } }
        },
        ['cargo_skillup'] = {
            point = 20,
            label = 'cargo Thief', img = 'cargo_skillup.png',
            description = 'برای دریافت این دستاورد، مهارت دزدی از کارگو را بالا ببرید',
            tasks = { ['skill:cargo_skill'] = { max = 1 } }
        },
        ['first_cargo_skillup'] = {
            point = 0, hidden = true,
            label = 'First cargo Thief', img = 'first_cargo_skillup.png',
            description = 'این نشان، مخصوص اولین نفری است که دستاورد دزدی از کارگو را بدست آورده',
            tasks = { ['skill:first_cargo_skill'] = { max = 1 } }
        },
        ['maze_skillup'] = {
            point = 20,
            label = 'Maze Thief', img = 'maze_skillup.png',
            description = 'برای دریافت این دستاورد، مهارت دزدی از میزبانک را بالا ببرید',
            tasks = { ['skill:maze_skill'] = { max = 1 } }
        },
        ['first_maze_skillup'] = {
            point = 0, hidden = true,
            label = 'First Maze Thief', img = 'first_maze_skillup.png',
            description = 'این نشان، مخصوص اولین نفری است که دستاورد دزدی از میزبانک را بدست آورده',
            tasks = { ['skill:first_maze_skill'] = { max = 1 } }
        },
        ['paleto_skillup'] = {
            point = 20,
            label = 'Paleto Thief', img = 'paleto_skillup.png',
            description = 'برای دریافت این دستاورد، مهارت دزدی از بانک پلتو را بالا ببرید',
            tasks = { ['skill:paleto_skill'] = { max = 1 } }
        },
        ['first_paleto_skillup'] = {
            point = 0, hidden = true,
            label = 'First Paleto Thief', img = 'first_paleto_skillup.png',
            description = 'این نشان، مخصوص اولین نفری است که دستاورد دزدی از بانک پلتو را بدست آورده',
            tasks = { ['skill:first_paleto_skill'] = { max = 1 } }
        },
        ['bankm_skillup'] = {
            point = 20,
            label = 'CBank Thief', img = 'bankm_skillup.png',
            description = 'برای دریافت این دستاورد، مهارت دزدی از بانک مرکزی را بالا ببرید',
            tasks = { ['skill:bankm_skill'] = { max = 1 } }
        },
        ['first_bankm_skillup'] = {
            point = 0, hidden = true,
            label = 'First CBank Thief', img = 'first_bankm_skillup.png',
            description = 'این نشان، مخصوص اولین نفری است که دستاورد دزدی از بانک مرکزی را بدست آورده',
            tasks = { ['skill:first_bankm_skill'] = { max = 1 } }
        },
        ['flat_skillup'] = {
            point = 20,
            label = 'Flat Thief', img = 'flat_skillup.png',
            description = 'برای دریافت این دستاورد، مهارت دزدی از بانک فلت را بالا ببرید',
            tasks = { ['skill:flat_skill'] = { max = 1 } }
        },
        ['first_flat_skillup'] = {
            point = 0, hidden = true,
            label = 'First Flat Thief', img = 'first_flat_skillup.png',
            description = 'این نشان، مخصوص اولین نفری است که دستاورد دزدی از جواهری فلت را بدست آورده',
            tasks = { ['skill:first_flat_skill'] = { max = 1 } }
        },
        ['bime_skillup'] = {
            point = 20,
            label = 'Bime Thief', img = 'bime_skillup.png',
            description = 'برای دریافت این دستاورد، مهارت دزدی از بیمه را بالا ببرید',
            tasks = { ['skill:bime_skill'] = { max = 1 } }
        },
        ['first_bime_skillup'] = {
            point = 0, hidden = true,
            label = 'First Bime Thief', img = 'first_bime_skillup.png',
            description = 'این نشان، مخصوص اولین نفری است که دستاورد دزدی از بیمه را بدست آورده',
            tasks = { ['skill:first_bime_skill'] = { max = 1 } }
        },
        ['airrob_skillup'] = {
            point = 20,
            label = 'AirPort Thief', img = 'airrob_skillup.png',
            description = 'برای دریافت این دستاورد، مهارت دزدی از رابری فرودگاه را بالا ببرید',
            tasks = { ['skill:airrob_skill'] = { max = 1 } }
        },
        ['first_airrob_skillup'] = {
            point = 0, hidden = true,
            label = 'First AirPort Thief', img = 'first_airrob_skillup.png',
            description = 'این نشان، مخصوص اولین نفری است که دستاورد دزدی از رابری فرودگاه را بدست آورده',
            tasks = { ['skill:first_airrob_skill'] = { max = 1 } }
        },
        ['mythic_skillup'] = {
            point = 20,
            label = 'Mythic Thief', img = 'mythic_skillup.png',
            description = 'برای دریافت این دستاورد، مهارت دزدی از رابری میثیک را بالا ببرید',
            tasks = { ['skill:mythic_skill'] = { max = 1 } }
        },
        ['first_mythic_skillup'] = {
            point = 0, hidden = true,
            label = 'First Mythic Thief', img = 'first_mythic_skillup.png',
            description = 'این نشان، مخصوص اولین نفری است که دستاورد دزدی از میثیک را بدست آورده',
            tasks = { ['skill:first_mythic_skill'] = { max = 1 } }
        },
        ['benny_skillup'] = {
            point = 20,
            label = 'Benny Thief', img = 'benny_skillup.png',
            description = 'برای دریافت این دستاورد، مهارت دزدی از رابری بنی را بالا ببرید',
            tasks = { ['skill:benny_skill'] = { max = 1 } }
        },
        ['first_benny_skillup'] = {
            point = 0, hidden = true,
            label = 'First Benny Thief', img = 'first_benny_skillup.png',
            description = 'این نشان، مخصوص اولین نفری است که دستاورد دزدی از بنی را بدست آورده',
            tasks = { ['skill:first_benny_skill'] = { max = 1 } }
        },
        ['gunshop_skillup'] = {
            point = 20,
            label = 'GunShp Thief', img = 'gunshop_skillup.png',
            description = 'برای دریافت این دستاورد، مهارت دزدی از رابری گان شاپ را بالا ببرید',
            tasks = { ['skill:gunshop_skill'] = { max = 1 } }
        },
        ['first_gunshop_skillup'] = {
            point = 0, hidden = true,
            label = 'First GunShp Thief', img = 'first_gunshop_skillup.png',
            description = 'این نشان، مخصوص اولین نفری است که دستاورد دزدی از گان شاپ را بدست آورده',
            tasks = { ['skill:first_gunshop_skill'] = { max = 1 } }
        },
        ['allrob_achievement2'] = {
            point = 100,
            label = 'Gladiator', img = 'allrob_achievement.png',
            description = 'برای دریافت این نشان، دستاوردهای رابری را بدست آورید',
            tasks = {
                ['achievement:shop_skillup'] = { max = 1 },
                ['achievement:minibank_skillup'] = { max = 1 },
                ['achievement:jewel_skillup'] = { max = 1 },
                ['achievement:cargo_skillup'] = { max = 1 },
                ['achievement:maze_skillup'] = { max = 1 },
                ['achievement:paleto_skillup'] = { max = 1 },
                ['achievement:bankm_skillup'] = { max = 1 },
                ['achievement:flat_skillup'] = { max = 1 },
                ['achievement:bime_skillup'] = { max = 1 },
                ['achievement:mythic_skillup'] = { max = 1 },
                ['achievement:airrob_skillup'] = { max = 1 },
                ['achievement:benny_skillup'] = { max = 1 },
                ['achievement:gunshop_skillup'] = { max = 1 },
            }
        },
        ['first_allrob_achievement'] = {
            point = 0, hidden = true,
            label = 'First Gladiator', img = 'first_allrob_achievement.png',
            description = 'این نشان، مخصوص اولین نفری است که دستاوردهای دزدی را بدست آورده',
            tasks = { ['achievement:first_allrob_achievement'] = { max = 1 } }
        },
                ['persuit_skillup'] = {
            point = 20,
            label = 'Persuit', img = 'persuit_skillup.png',
            description = 'برای دریافت این دستاورد، مهارت پرسوت را به دست آورید',
            tasks = { ['skill:persuit_skill'] = { max = 1 } }
        },
        ['first_persuit_skillup'] = {
            point = 0, hidden = true,
            label = 'First Persuit', img = 'first_persuit_skillup.png',
            description = 'این نشان، مخصوص اولین نفری است که دستاورد پرسوت را بدست آورده',
            tasks = { ['skill:first_persuit_skill'] = { max = 1 } }
        },
        ['houserob_skillup'] = {
            point = 20,
            label = 'House Robbery', img = 'houserob_skillup.png',
            description = 'برای دریافت این دستاورد، مهارت دزدی از خانه را به دست آورید',
            tasks = { ['skill:houserob_skill'] = { max = 1 } }
        },
        ['first_houserob_skillup'] = {
            point = 0, hidden = true,
            label = 'First Persuit', img = 'first_houserob_skillup.png',
            description = 'این نشان، مخصوص اولین نفری است که دستاورد دزدی از خانه را بدست آورده',
            tasks = { ['skill:first_houserob_skill'] = { max = 1 } }
        },
        --#endregion

        --#region ------------------------------ Job Folati
        ['police_skillup'] = {
            point = 20,
            label = 'Police', img = 'police_skillup.png',
            description = 'برای دریافت این دستاورد، در شغل پلیس مهارت خود را بالا ببرید',
            tasks = { ['skill:police_skill'] = { max = 1 } }
        },
        ['first_police_skillup'] = {
            point = 0, hidden = true,
            label = 'First Police', img = 'first_police_skillup.png',
            description = 'این نشان، مخصوص اولین نفری است که دستاورد پلیس را بدست آورده',
            tasks = { ['skill:first_police_skill'] = { max = 1 } }
        },
        ['sheriff_skillup'] = {
            point = 20,
            label = 'Sheriff', img = 'sheriff_skillup.png',
            description = 'برای دریافت این دستاورد، در شغل شریف مهارت خود را بالا ببرید',
            tasks = { ['skill:sheriff_skill'] = { max = 1 } }
        },
        ['first_sheriff_skillup'] = {
            point = 0, hidden = true,
            label = 'First Sheriff', img = 'first_sheriff_skillup.png',
            description = 'این نشان، مخصوص اولین نفری است که دستاورد شریف را بدست آورده',
            tasks = { ['skill:first_sheriff_skill'] = { max = 1 } }
        },
        ['mt_skillup'] = {
            point = 20,
            label = 'Swat', img = 'mt_skillup.png',
            description = 'برای دریافت این دستاورد، در شغل ام تی مهارت خود را بالا ببرید',
            tasks = { ['skill:mt_skill'] = { max = 1 } }
        },
        ['first_mt_skillup'] = {
            point = 0, hidden = true,
            label = 'First Swat', img = 'first_mt_skillup.png',
            description = 'این نشان، مخصوص اولین نفری است که دستاورد ام تی را بدست آورده',
            tasks = { ['skill:first_mt_skill'] = { max = 1 } }
        },
        ['detective_skillup'] = {
            point = 20,
            label = 'CID', img = 'detective_skillup.png',
            description = 'برای دریافت این دستاورد، در شغل سی آی دی مهارت خود را بالا ببرید',
            tasks = { ['skill:detective_skill'] = { max = 1 } }
        },
        ['first_detective_skillup'] = {
            point = 0, hidden = true,
            label = 'First CID', img = 'first_detective_skillup.png',
            description = 'این نشان، مخصوص اولین نفری است که دستاورد سی آی دی را بدست آورده',
            tasks = { ['skill:first_detective_skill'] = { max = 1 } }
        },
        ['law_achievement'] = {
            point = 50,
            label = 'Law Enforcement', img = 'law_achievement.png',
            description = 'برای دریافت این نشان، دستاوردهای پلیس، شریف، ام تی و سی آی دی را بدست آورید',
            tasks = {
                ['achievement:police_skillup'] = { max = 1 },
                ['achievement:sheriff_skillup'] = { max = 1 },
                ['achievement:mt_skillup'] = { max = 1 },
                ['achievement:detective_skillup'] = { max = 1 },
            }
        },
        ['first_law_achievement'] = {
            point = 0, hidden = true,
            label = 'First Law Enforcement', img = 'first_law_achievement.png',
            description = 'این نشان، مخصوص اولین نفری است که دستاوردهای پلیس،شریف،ام تی را بدست آورده',
            tasks = { ['achievement:first_law_achievement'] = { max = 1 } }
        },
        ['justic_skillup'] = {
            point = 20,
            label = 'Marshal', img = 'justic_skillup.png',
            description = 'برای دریافت این دستاورد، در شغل دادگستری مهارت خود را بالا ببرید',
            tasks = { ['skill:justic_skill'] = { max = 1 } }
        },
        ['first_justic_skillup'] = {
            point = 0, hidden = true,
            label = 'First Marshal', img = 'first_justic_skillup.png',
            description = 'این نشان، مخصوص اولین نفری است که دستاورد جاب جاستیس را بدست آورده',
            tasks = { ['skill:first_justic_skill'] = { max = 1 } }
        },
        ['revive_skillup'] = {
            point = 20,
            label = 'Doctor', img = 'revive_skillup.png',
            description = 'برای دریافت این دستاورد، در شغل مدیک مهارت خود را بالا ببرید',
            tasks = { ['skill:revive_skill'] = { max = 1 } }
        },
        ['first_revive_skillup'] = {
            point = 0, hidden = true,
            label = 'First Doctor', img = 'first_revive_skillup.png',
            description = 'این نشان، مخصوص اولین نفری است که دستاورد جاب مدیک را بدست آورده',
            tasks = { ['skill:first_revive_skill'] = { max = 1 } }
        },
        ['taxi_skillup'] = {
            point = 20,
            label = 'Transportation Driver', img = 'taxi_skillup.png',
            description = 'برای دریافت این دستاورد، در شغل تاکسی مهارت خود را بالا ببرید',
            tasks = { ['skill:taxi_skill'] = { max = 1 } }
        },
        ['first_taxi_skillup'] = {
            point = 0, hidden = true,
            label = 'First Taxi Driver', img = 'first_taxi_skillup.png',
            description = 'این نشان، مخصوص اولین نفری است که دستاورد جاب تاکسی را بدست آورده',
            tasks = { ['skill:first_taxi_skill'] = { max = 1 } }
        },
        ['Peyk_skillup'] = {
            point = 20,
            label = 'Peyk Driver', img = 'Peyk_skillup.png',
            description = 'برای دریافت این دستاورد، در شغل تاکسی مهارت رساندن بسته را بالا ببرید',
            tasks = { ['skill:peyk_skill'] = { max = 1 } }
        },
        ['first_peyk_skillup'] = {
            point = 0, hidden = true,
            label = 'First Peyk Driver', img = 'first_peyk_skillup.png',
            description = 'این نشان، مخصوص اولین نفری است که دستاورد رساندن بسته در جاب تاکسی را بدست آورده',
            tasks = { ['skill:first_peyk_skill'] = { max = 1 } }
        },
        ['repair_skillup'] = {
            point = 20,
            label = 'Professional Mechanic', img = 'repair_skillup.png',
            description = 'برای دریافت این دستاورد، در شغل مکانیک مهارت خود را بالا ببرید',
            tasks = { ['skill:repair_skill'] = { max = 1 } }
        },
        ['first_repair_skillup'] = {
            point = 0, hidden = true,
            label = 'First Professional Mechanic', img = 'first_repair_skillup.png',
            description = 'این نشان، مخصوص اولین نفری است که دستاورد جاب مکانیک را بدست آورده',
            tasks = { ['skill:first_repair_skill'] = { max = 1 } }
        },
        --#endregion

        --#region ------------------------------ Other
        ['sport_skillup'] = {
            point = 20,
            label = 'Champion', img = 'sport_skillup.png',
            description = 'برای دریافت این دستاورد، مهارت ورزش را بالا ببرید',
            tasks = { ['skill:sport_skill'] = { max = 1 } }
        },
        ['first_sport_skillup'] = {
            point = 0, hidden = true,
            label = 'First Champion', img = 'first_sport_skillup.png',
            description = 'این نشان، مخصوص اولین نفری است که دستاورد ورزش را بدست آورده',
            tasks = { ['skill:first_sport_skill'] = { max = 1 } }
        },
        ['drift_skillup'] = {
            point = 20,
            label = 'Drift', img = 'drift_skillup.png',
            description = 'برای دریافت این دستاورد، مهارت رانندگی خود را بالا ببرید',
            tasks = { ['skill:drift_skill'] = { max = 1 } }
        },
        ['lvl50_skillup'] = {
            point = 100,
            label = 'level 50', img = 'lvl50_skillup.png',
            description = 'برای دریافت این دستاورد، لول شخصی خود را به 50 برسانید',
            tasks = { ['level_reach_50'] = { max = 1 } }
        },
        ['first_lvl50_skillup'] = {
            point = 0, hidden = true,
            label = 'First level 50', img = 'first_lvl50_skillup.png',
            description = 'این نشان، مخصوص اولین نفری است که به لول 50 رسیده است',
            tasks = { ['skill:first_level_reach_50'] = { max = 1 } }
        },
        ['raygiri_14011'] = {
            point = 0, hidden = true,
            label = 'Entekhabat Shora', img = 'raygiri14011.png',
            description = 'این نشان را جهت شرکت در دور اول انتخابات 1404 بدست آوردید',
            tasks = { ['quest:questshora150'] = { max = 1 } }
        },
        ['raygiri_1405'] = {
            point = 0, hidden = true,
            label = 'Entekhabat Shora', img = 'raygiri_1405.png',
            description = 'این نشان را جهت شرکت در دور اول انتخابات 1405 بدست آوردید',
            tasks = { ['quest:shora1405'] = { max = 1 } }
        },
        --#endregion

        --#region ------------------------------ Quest
        ['quest_10_up2'] = {
            point = 5,
            label = '10 Quest', img = 'quest_10_up.png',
            description = 'برای دریافت این دستاورد، 10 مأموریت روزانه انجام بده',
            tasks = { ['daily_quest'] = { max = 10 } }
        },
        ['quest_100_up2'] = {
            point = 50,
            label = '100 Quest', img = 'quest_100_up.png',
            description = 'برای دریافت این دستاورد، 100 مأموریت روزانه انجام بده',
            tasks = { ['daily_quest'] = { max = 100 } }
        },
        ['quest_500_up2'] = {
            point = 100,
            label = '500 Quest', img = 'quest_500_up.png',
            description = 'برای دریافت این دستاورد، 500 مأموریت روزانه انجام بده',
            tasks = { ['daily_quest'] = { max = 500 } }
        },
        ['quest_5000_up2'] = {
            point = 300, hidden = true,
            label = '5000 Quest', img = 'quest_5000_up2.png',
            description = 'این نشان را جهت انجام 5000 مأموریت روزانه دریافت کردید',
            tasks = { ['daily_quest'] = { max = 5000 } }
        },
        ['quest_pacman1'] = {
            point = 20, hidden = true,
            label = 'Pac-Man', img = 'quest_pacman1.png',
            description = 'این نشان با انجام کوئست پک من به دست می آید',
            tasks = { ['quest:qw2pac_01'] = { max = 10 } }
        },
        ['fightban_skillup'] = {
            point = -100, hidden = true,
            label = 'Fightban', img = 'fightban_skillup.png',
            description = 'در صورتی که به دلیل مشکوک بودن به چیت سه بار فایت بن شوید، 100 پوینت از شما کسر می شود',
            tasks = { ['fightban_skillup'] = { max = 3 } }
        },
        ['qetime_luci11'] = {
            point = 20,
            label = 'LUCILLE', img = 'qetime_luci11.png',
            description = 'برای دریافت این نشان کوئست لوسیل را انجام دهید',
            tasks = { ['quest:qetime_luci1'] = { max = 1 } }
        },
        ['qetime_kt12'] = {
            point = 40,
            label = 'KATANA', img = 'qetime_kt12.png',
            description = 'برای دریافت این نشان کوئست کاتانا 1 و 2 را انجام دهید',
            tasks = {
                ['quest:qetime_kt1'] = { max = 1 },
                ['quest:qetime_kt2'] = { max = 1 },
            }
        },
        ['qetimkif011'] = {
            point = 10,
            label = 'CharmSaz', img = 'qetimkif011.png',
            description = 'برای دریافت این نشان کوئست ساخت کیف را انجام دهید',
            tasks = { ['quest:qetimkif01'] = { max = 1 } }
        },
        ['bimemashin0'] = {
            point = 20, hidden = true,
            label = 'Bime Mashin', img = 'bimemashin0.png',
            description = 'این نشان را به خاطر بیمه کردن 100 ماشین دریافت کرده‌اید',
            tasks = { ['carbimeh_ach'] = { max = 100 } }
        },
        ['vote1000player'] = {
            point = 0, hidden = true,
            label = '+1000 Players', img = 'vote1000player.png',
            description = 'این نشان را به خاطر حضور در اولین ( 1000+ پلیر ) دریافت کرده‌اید',
            tasks = { ['quest:vote1000p'] = { max = 1 } }
        },
        --#endregion

        --#region ------------------------------ Weapon
        ['pistol_skillup'] = {
            point = 20, hidden = true,
            label = 'Pistol Skill', img = 'pistol_skillup.png',
            description = 'شما دستاورد مهارت استفاده از این اسلحه را به دست آوردید',
            tasks = { ['skill:pistol_skill'] = { max = 1 } }
        },
        ['pistol_mk2_skillup'] = {
            point = 20, hidden = true,
            label = 'Pistol Mk2 Skill', img = 'pistol_mk2_skillup.png',
            description = 'شما دستاورد مهارت استفاده از این اسلحه را به دست آوردید',
            tasks = { ['skill:pistol_mk2_skill'] = { max = 1 } }
        },
        ['combatpistol_skillup'] = {
            point = 20, hidden = true,
            label = 'Combat Pistol Skill', img = 'combatpistol_skillup.png',
            description = 'شما دستاورد مهارت استفاده از این اسلحه را به دست آوردید',
            tasks = { ['skill:combatpistol_skill'] = { max = 1 } }
        },
        ['appistol_skillup'] = {
            point = 20, hidden = true,
            label = 'Ap Pistol Skill', img = 'appistol_skillup.png',
            description = 'شما دستاورد مهارت استفاده از این اسلحه را به دست آوردید',
            tasks = { ['skill:appistol_skill'] = { max = 1 } }
        },
        ['pistol50_skillup'] = {
            point = 20, hidden = true,
            label = 'Pistol.50 Skill', img = 'pistol50_skillup.png',
            description = 'شما دستاورد مهارت استفاده از این اسلحه را به دست آوردید',
            tasks = { ['skill:pistol50_skill'] = { max = 1 } }
        },
        ['snspistol_mk2_skillup'] = {
            point = 20, hidden = true,
            label = 'Sns Pistol Mk2 Skill', img = 'snspistol_mk2_skillup.png',
            description = 'شما دستاورد مهارت استفاده از این اسلحه را به دست آوردید',
            tasks = { ['skill:snspistol_mk2_skill'] = { max = 1 } }
        },
        ['heavypistol_skillup'] = {
            point = 20, hidden = true,
            label = 'Heavy Pistol Skill', img = 'heavypistol_skillup.png',
            description = 'شما دستاورد مهارت استفاده از این اسلحه را به دست آوردید',
            tasks = { ['skill:heavypistol_skill'] = { max = 1 } }
        },
        ['vintagepistol_skillup'] = {
            point = 20, hidden = true,
            label = 'Vintage Pistol Skill', img = 'vintagepistol_skillup.png',
            description = 'شما دستاورد مهارت استفاده از این اسلحه را به دست آوردید',
            tasks = { ['skill:vintagepistol_skill'] = { max = 1 } }
        },
        ['doubleaction_skillup'] = {
            point = 20, hidden = true,
            label = 'Doubleaction Skill', img = 'doubleaction_skillup.png',
            description = 'شما دستاورد مهارت استفاده از این اسلحه را به دست آوردید',
            tasks = { ['skill:doubleaction_skill'] = { max = 1 } }
        },
        ['ceramicpistol_skillup'] = {
            point = 20, hidden = true,
            label = 'Ceramic Pistol Skill', img = 'ceramicpistol_skillup.png',
            description = 'شما دستاورد مهارت استفاده از این اسلحه را به دست آوردید',
            tasks = { ['skill:ceramicpistol_skill'] = { max = 1 } }
        },
        ['gadgetpistol_skillup'] = {
            point = 20, hidden = true,
            label = 'Gadget Pistol Skill', img = 'gadgetpistol_skillup.png',
            description = 'شما دستاورد مهارت استفاده از این اسلحه را به دست آوردید',
            tasks = { ['skill:gadgetpistol_skill'] = { max = 1 } }
        },
        ['smg_skillup'] = {
            point = 20, hidden = true,
            label = 'Smg Skill', img = 'smg_skillup.png',
            description = 'شما دستاورد مهارت استفاده از این اسلحه را به دست آوردید',
            tasks = { ['skill:smg_skill'] = { max = 1 } }
        },
        ['smg_mk2_skillup'] = {
            point = 20, hidden = true,
            label = 'Smg Mk2 Skill', img = 'smg_mk2_skillup.png',
            description = 'شما دستاورد مهارت استفاده از این اسلحه را به دست آوردید',
            tasks = { ['skill:smg_mk2_skill'] = { max = 1 } }
        },
        ['assaultsmg_skillup'] = {
            point = 20, hidden = true,
            label = 'Assault Smg Skill', img = 'assaultsmg_skillup.png',
            description = 'شما دستاورد مهارت استفاده از این اسلحه را به دست آوردید',
            tasks = { ['skill:assaultsmg_skill'] = { max = 1 } }
        },
        ['microsmg_skillup'] = {
            point = 20, hidden = true,
            label = 'Micro Smg Skill', img = 'microsmg_skillup.png',
            description = 'شما دستاورد مهارت استفاده از این اسلحه را به دست آوردید',
            tasks = { ['skill:microsmg_skill'] = { max = 1 } }
        },
        ['combatpdw_skillup'] = {
            point = 20, hidden = true,
            label = 'CombatPDW Skill', img = 'combatpdw_skillup.png',
            description = 'شما دستاورد مهارت استفاده از این اسلحه را به دست آوردید',
            tasks = { ['skill:combatpdw_skill'] = { max = 1 } }
        },
        ['pumpshotgun_skillup'] = {
            point = 20, hidden = true,
            label = 'Pump Shotgun Skill', img = 'pumpshotgun_skillup.png',
            description = 'شما دستاورد مهارت استفاده از این اسلحه را به دست آوردید',
            tasks = { ['skill:pumpshotgun_skill'] = { max = 1 } }
        },
        ['pumpshotgun_mk2_skillup'] = {
            point = 20, hidden = true,
            label = 'Pump Shotgun Mk2 Skill', img = 'pumpshotgun_mk2_skillup.png',
            description = 'شما دستاورد مهارت استفاده از این اسلحه را به دست آوردید',
            tasks = { ['skill:pumpshotgun_mk2_skill'] = { max = 1 } }
        },
        ['sawnoffshotgun_skillup'] = {
            point = 20, hidden = true,
            label = 'SawnOff Shotgun Skill', img = 'sawnoffshotgun_skillup.png',
            description = 'شما دستاورد مهارت استفاده از این اسلحه را به دست آوردید',
            tasks = { ['skill:sawnoffshotgun_skill'] = { max = 1 } }
        },
        ['assaultshotgun_skillup'] = {
            point = 20, hidden = true,
            label = 'Assault Shotgun Skill', img = 'assaultshotgun_skillup.png',
            description = 'شما دستاورد مهارت استفاده از این اسلحه را به دست آوردید',
            tasks = { ['skill:assaultshotgun_skill'] = { max = 1 } }
        },
        ['bullpupshotgun_skillup'] = {
            point = 20, hidden = true,
            label = 'Bullpup Shotgun Skill', img = 'bullpupshotgun_skillup.png',
            description = 'شما دستاورد مهارت استفاده از این اسلحه را به دست آوردید',
            tasks = { ['skill:bullpupshotgun_skill'] = { max = 1 } }
        },
        ['combatshotgun_skillup'] = {
            point = 20, hidden = true,
            label = 'Combat Shotgun Skill', img = 'combatshotgun_skillup.png',
            description = 'شما دستاورد مهارت استفاده از این اسلحه را به دست آوردید',
            tasks = { ['skill:combatshotgun_skill'] = { max = 1 } }
        },
        ['assaultrifle_skillup'] = {
            point = 20, hidden = true,
            label = 'Assault Rifle Skill', img = 'assaultrifle_skillup.png',
            description = 'شما دستاورد مهارت استفاده از این اسلحه را به دست آوردید',
            tasks = { ['skill:assaultrifle_skill'] = { max = 1 } }
        },
        ['assaultrifle_mk2_skillup'] = {
            point = 20, hidden = true,
            label = 'Assault Rifle Mk2 Skill', img = 'assaultrifle_mk2_skillup.png',
            description = 'شما دستاورد مهارت استفاده از این اسلحه را به دست آوردید',
            tasks = { ['skill:assaultrifle_mk2_skill'] = { max = 1 } }
        },
        ['carbinerifle_skillup'] = {
            point = 20, hidden = true,
            label = 'Carbine Rifle Skill', img = 'carbinerifle_skillup.png',
            description = 'شما دستاورد مهارت استفاده از این اسلحه را به دست آوردید',
            tasks = { ['skill:carbinerifle_skill'] = { max = 1 } }
        },
        ['carbinerifle_mk2_skillup'] = {
            point = 20, hidden = true,
            label = 'Carbine Rifle Mk2 Skill', img = 'carbinerifle_mk2_skillup.png',
            description = 'شما دستاورد مهارت استفاده از این اسلحه را به دست آوردید',
            tasks = { ['skill:carbinerifle_mk2_skill'] = { max = 1 } }
        },
        ['advancedrifle_skillup'] = {
            point = 20, hidden = true,
            label = 'Advanced Rifle', img = 'advancedrifle_skillup.png',
            description = 'شما دستاورد مهارت استفاده از این اسلحه را به دست آوردید',
            tasks = { ['skill:advancedrifle_skill'] = { max = 1 } }
        },
        ['specialcarbine_skillup'] = {
            point = 20, hidden = true,
            label = 'Special Carbine Skill', img = 'specialcarbine_skillup.png',
            description = 'شما دستاورد مهارت استفاده از این اسلحه را به دست آوردید',
            tasks = { ['skill:specialcarbine_skill'] = { max = 1 } }
        },
        ['specialcarbine_mk2_skillup'] = {
            point = 20, hidden = true,
            label = 'Special Carbine Mk2 Skill', img = 'specialcarbine_mk2_skillup.png',
            description = 'شما دستاورد مهارت استفاده از این اسلحه را به دست آوردید',
            tasks = { ['skill:specialcarbine_mk2_skill'] = { max = 1 } }
        },
        ['bullpuprifle_skillup'] = {
            point = 20, hidden = true,
            label = 'Bullpup Rifle Skill', img = 'bullpuprifle_skillup.png',
            description = 'شما دستاورد مهارت استفاده از این اسلحه را به دست آوردید',
            tasks = { ['skill:bullpuprifle_skill'] = { max = 1 } }
        },
        ['bullpuprifle_mk2_skillup'] = {
            point = 20, hidden = true,
            label = 'Bullpup Rifle Mk2 Skill', img = 'bullpuprifle_mk2_skillup.png',
            description = 'شما دستاورد مهارت استفاده از این اسلحه را به دست آوردید',
            tasks = { ['skill:bullpuprifle_mk2_skill'] = { max = 1 } }
        },
        ['compactrifle_skillup'] = {
            point = 20, hidden = true,
            label = 'Compact Rifle Skill', img = 'compactrifle_skillup.png',
            description = 'شما دستاورد مهارت استفاده از این اسلحه را به دست آوردید',
            tasks = { ['skill:compactrifle_skill'] = { max = 1 } }
        },
        ['militaryrifle_skillup'] = {
            point = 20, hidden = true,
            label = 'Military Rifle Skill', img = 'militaryrifle_skillup.png',
            description = 'شما دستاورد مهارت استفاده از این اسلحه را به دست آوردید',
            tasks = { ['skill:militaryrifle_skill'] = { max = 1 } }
        },
        ['tacticalrifle_skillup'] = {
            point = 20, hidden = true,
            label = 'Tactical Rifle Skill', img = 'tacticalrifle_skillup.png',
            description = 'شما دستاورد مهارت استفاده از این اسلحه را به دست آوردید',
            tasks = { ['skill:tacticalrifle_skill'] = { max = 1 } }
        },
        ['heavyrifle_skillup'] = {
            point = 20, hidden = true,
            label = 'Heavy Rifle Skill', img = 'heavyrifle_skillup.png',
            description = 'شما دستاورد مهارت استفاده از این اسلحه را به دست آوردید',
            tasks = { ['skill:heavyrifle_skill'] = { max = 1 } }
        },
        ['gusenberg_skillup'] = {
            point = 20, hidden = true,
            label = 'GusenBerg Skill', img = 'gusenberg_skillup.png',
            description = 'شما دستاورد مهارت استفاده از این اسلحه را به دست آوردید',
            tasks = { ['skill:gusenberg_skill'] = { max = 1 } }
        },
        ['combatmg_skillup'] = {
            point = 20, hidden = true,
            label = 'Combat MG Skill', img = 'combatmg_skillup.png',
            description = 'شما دستاورد مهارت استفاده از این اسلحه را به دست آوردید',
            tasks = { ['skill:combatmg_skill'] = { max = 1 } }
        },
        ['combatmg_mk2_skillup'] = {
            point = 20, hidden = true,
            label = 'Combat MG Mk2 Skill', img = 'combatmg_mk2_skillup.png',
            description = 'شما دستاورد مهارت استفاده از این اسلحه را به دست آوردید',
            tasks = { ['skill:combatmg_mk2_skill'] = { max = 1 } }
        },
        ['mg_skillup'] = {
            point = 20, hidden = true,
            label = 'MG Skill', img = 'mg_skillup.png',
            description = 'شما دستاورد مهارت استفاده از این اسلحه را به دست آوردید',
            tasks = { ['skill:mg_skill'] = { max = 1 } }
        },
        ['marksmanpistol_skillup'] = {
            point = 20, hidden = true,
            label = 'Marksman Pistol Skill', img = 'marksmanpistol_skillup.png',
            description = 'شما دستاورد مهارت استفاده از این اسلحه را به دست آوردید',
            tasks = { ['skill:marksmanpistol_skill'] = { max = 1 } }
        },
        ['navyrevolver_skillup'] = {
            point = 20, hidden = true,
            label = 'Navy Revolver Skill', img = 'navyrevolver_skillup.png',
            description = 'شما دستاورد مهارت استفاده از این اسلحه را به دست آوردید',
            tasks = { ['skill:navyrevolver_skill'] = { max = 1 } }
        },
        ['pistolxm3_skillup'] = {
            point = 20, hidden = true,
            label = 'Pistol XM3 Skill', img = 'pistolxm3_skillup.png',
            description = 'شما دستاورد مهارت استفاده از این اسلحه را به دست آوردید',
            tasks = { ['skill:pistolxm3_skill'] = { max = 1 } }
        },
        ['revolver_skillup'] = {
            point = 20, hidden = true,
            label = 'Revolver Skill', img = 'revolver_skillup.png',
            description = 'شما دستاورد مهارت استفاده از این اسلحه را به دست آوردید',
            tasks = { ['skill:revolver_skill'] = { max = 1 } }
        },
        ['revolver_mk2_skillup'] = {
            point = 20, hidden = true,
            label = 'Revolver Mk2 Skill', img = 'revolver_mk2_skillup.png',
            description = 'شما دستاورد مهارت استفاده از این اسلحه را به دست آوردید',
            tasks = { ['skill:revolver_mk2_skill'] = { max = 1 } }
        },
        ['autoshotgun_skillup'] = {
            point = 20, hidden = true,
            label = 'Auto Shotgun Skill', img = 'autoshotgun_skillup.png',
            description = 'شما دستاورد مهارت استفاده از این اسلحه را به دست آوردید',
            tasks = { ['skill:autoshotgun_skill'] = { max = 1 } }
        },
        ['dbshotgun_skillup'] = {
            point = 20, hidden = true,
            label = 'DB Shotgun Skill', img = 'dbshotgun_skillup.png',
            description = 'شما دستاورد مهارت استفاده از این اسلحه را به دست آوردید',
            tasks = { ['skill:dbshotgun_skill'] = { max = 1 } }
        },
        ['heavyshotgun_skillup'] = {
            point = 20, hidden = true,
            label = 'Heavy Shotgun Skill', img = 'heavyshotgun_skillup.png',
            description = 'شما دستاورد مهارت استفاده از این اسلحه را به دست آوردید',
            tasks = { ['skill:heavyshotgun_skill'] = { max = 1 } }
        },
        ['machinepistol_skillup'] = {
            point = 20, hidden = true,
            label = 'Machine Pistol Skill', img = 'machinepistol_skillup.png',
            description = 'شما دستاورد مهارت استفاده از این اسلحه را به دست آوردید',
            tasks = { ['skill:machinepistol_skill'] = { max = 1 } }
        },
        ['minismg_skillup'] = {
            point = 20, hidden = true,
            label = 'Mini SMG Skill', img = 'minismg_skillup.png',
            description = 'شما دستاورد مهارت استفاده از این اسلحه را به دست آوردید',
            tasks = { ['skill:minismg_skill'] = { max = 1 } }
        },
        ['tecpistol_skillup'] = {
            point = 20, hidden = true,
            label = 'Tactical SMG Skill', img = 'tecpistol_skillup.png',
            description = 'شما دستاورد مهارت استفاده از این اسلحه را به دست آوردید',
            tasks = { ['skill:tecpistol_skill'] = { max = 1 } }
        },
        --#endregion
    }
}


-- addType = {
--     ['dummy_kill'] = 0.01,
--     ['capture_kill'] = 0.1,
--     ['robbery_kill'] = 0.5,
-- }