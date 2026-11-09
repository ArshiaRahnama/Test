-- Pub by FleeX Team , https://discord.gg/87rGBxgCsa

animConfig = {
    ['animDrink'] = {
        disableMove = false,
        anim = {
            dict = 'amb@world_human_drinking@coffee@male@idle_a',
            name = 'idle_c',
            duration = -1,
            flag = 1,
        },
        objects = {
            {
                model = `prop_ecola_can`,
                bone = 28422,
                pos = vec(0.0, 0.0, 0.0),
                rot = vec(0.0, 0.0, 130.0),
            }
        },
        duration = 10000,
    },
    ['whiskyDrink'] = {
        disableMove = false,
        anim = {
            dict = 'amb@world_human_drinking@coffee@male@idle_a',
            name = 'idle_c',
            duration = -1,
            flag = 1,
        },
        objects = {
            {
                model = `prop_drink_whisky`,
                bone = 28422,
                pos = vec(0.01, -0.01, -0.06),
                rot = vec(0.0, 0.0, 0.0),
            }
        },
        duration = 10000,
    },
    ['cupDrink'] = {
        disableMove = false,
        anim = {
            dict = 'amb@world_human_drinking@coffee@male@idle_a',
            name = 'idle_c',
            duration = -1,
            flag = 1,
        },
        objects = {
            {
                model = `prop_plastic_cup_02`,
                bone = 28422,
                pos = vec(0.0, 0.0, 0.0),
                rot = vec(0.0, 0.0, 0.0),
            }
        },
        duration = 10000,
    },
    ['beerDrink'] = {
        disableMove = false,
        anim = {
            dict = 'amb@world_human_drinking@coffee@male@idle_a',
            name = 'idle_c',
            duration = -1,
            flag = 1,
        },
        objects = {
            {
                model = `prop_amb_beer_bottle`,
                bone = 28422,
                pos = vec(0.0, 0.0, 0.0),
                rot = vec(0.0, 0.0, 0.0),
            }
        },
        duration = 10000,
    },
    ['wineDrink'] = {
        disableMove = false,
        anim = {
            dict = 'amb@world_human_drinking@coffee@male@idle_a',
            name = 'idle_c',
            duration = -1,
            flag = 1,
        },
        objects = {
            {
                model = `prop_drink_redwine`,
                bone = 28422,
                pos = vec(0.0, 0.0, -0.07),
                rot = vec(0.0, 0.0, 0.0),
            }
        },
        duration = 10000,
    },
    ['soupEat'] = {
        disableMove = false,
        anim = {
            dict = 'anim@scripted@island@special_peds@pavel@hs4_pavel_ig5_caviar_p1',
            name = 'base_idle',
            duration = -1,
            flag = 1,
        },
        objects = {
            {
                model = `h4_prop_h4_caviar_tin_01a`,
                bone = 60309,
                pos = vec(0.0, 0.03, 0.01),
                rot = vec(0.0, 0.0, 0.0),
            },
            {
                model = `h4_prop_h4_caviar_spoon_01a`,
                bone = 28422,
                pos = vec(0.0, 0.0, 0.0),
                rot = vec(0.0, 0.0, 0.0),
            },
        },
        duration = 10000,
    },
    ['sandwichEat'] = {
        disableMove = false,
        anim = {
            dict = 'mp_player_inteat@burger',
            name = 'mp_player_int_eat_burger',
            duration = -1,
            flag = 1,
        },
        objects = {
            {
                model = `prop_sandwich_01`,
                bone = 18905,
                pos = vec(0.13, 0.05, 0.02),
                rot = vec(-50.0, 16.0, 60.0),
            }
        },
        duration = 10000,
    },
    ['burgerEat'] = {
        disableMove = false,
        anim = {
            dict = 'mp_player_inteat@burger',
            name = 'mp_player_int_eat_burger',
            duration = -1,
            flag = 1,
        },
        objects = {
            {
                model = `prop_cs_burger_01`,
                bone = 18905,
                pos = vec(0.13, 0.05, 0.02),
                rot = vec(-50.0, 16.0, 60.0),
            }
        },
        duration = 10000,
    },
    ['breadEat'] = {
        disableMove = false,
        anim = {
            dict = 'mp_player_inteat@burger',
            name = 'mp_player_int_eat_burger',
            duration = -1,
            flag = 1,
        },
        objects = {
            {
                model = `v_res_fa_bread03`,
                bone = 18905,
                pos = vec(0.15, 0.039, 0.02),
                rot = vec(22.19, -33.59, 124.49),
            }
        },
        duration = 10000,
    },
    ['waterEat'] = {
        disableMove = false,
        anim = {
            dict = 'amb@world_human_drinking@coffee@male@idle_a',
            name = 'idle_c',
            duration = -1,
            flag = 1,
        },
        objects = {
            {
                model = `h4_prop_club_water_bottle`,
                bone = 28422,
                pos = vec(-0.00, 0.00, -0.1),
                rot = vec(-109.9, 118.59, 82.30),
            }
        },
        duration = 10000,
    },
    ['doodiEat'] = {
        disableMove = false,
        anim = {
            dict = 'mp_player_inteat@burger',
            name = 'mp_player_int_eat_burger',
            duration = -1,
            flag = 1,
        },
        objects = {
            {
                model = `prop_cs_burger_01`,
                bone = 18905,
                pos = vec(0.13, 0.05, 0.02),
                rot = vec(-50.0, 16.0, 60.0),
            }
        },
        duration = 10000,
    },
    ['vomit'] = {
        disableMove = false,
        disableVehicle = true,
        anim = {
            dict = 'missfam5_blackout',
            name = 'vomit',
            duration = -1,
            flag = 1,
        },
        duration = 15000,
    },
    ['tanbaku'] = {
        disableMove = true,
        disableVehicle = true,
        anim = {
            dict = 'mini@repair',
            name = 'fixing_a_ped',
            duration = -1,
            flag = 1,
        },
        duration = 10000,
    },
    ['abyari'] = {
        disableMove = true,
        disableVehicle = true,
        disableProgress = true,
        anim = {
            dict = 'amb@world_human_gardener_leaf_blower@base',
            name = 'base',
            duration = -1,
            flag = 1,
        },
        objects = {
            {
                model = `prop_wateringcan`,
                bone = 57005,
                pos = vec(0.338, -0.147, -0.065),
                rot = vec(-65.9, -2.9, 1.8),
            }
        },
        duration = 5000,
    },
    ['smokingDrug'] = {
        disableMove = true,
        disableVehicle = true,
        disableProgress = true,
        anim = {
            dict = 'amb@world_human_aa_smoke@male@idle_a',
            name = 'idle_c',
            duration = -1,
            flag = 1,
        },
        objects = {
            {
                model = `ng_proc_cigarette01a`,
                bone = 64096,
                pos = vec(-0.01, 0.01, -0.01),
                rot = vec(-50.8, -7.0, 93.0),
            }
        },
        duration = 5000,
    }
}
