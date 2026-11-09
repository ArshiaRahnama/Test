-- Pub by FleeX Team , https://discord.gg/87rGBxgCsa

---------------------------------------------- Shop
local shopBlip = {          -- shop Blip
    sprite = 52,
    color = 2,
    scale = 0.7,
    label = 'Shop'
}
local miniJavaheriBlip = {  -- miniJavaheri Blip
    sprite = 617,
    color = 5,
    scale = 0.7,
    label = 'Mini Javaheri'
}
local shopReward = {        -- shop Reward
    blackMoney = 300000,
    tokenXP = {
        xp = 5,
        token = {
            xp = 13, xp2 = 17, cooldown = 15 * 60,
            skill = 'shop_skill', addSkill = {'shop_skill', 'use_token_shop'},
            quest = 'use_token_shop', questKey  = 'success_shop', searchQuest = 'search_token_shop',
            skill2 = 'police_skill', addSkill2 = {'police_skill', 'search_token_shop'}
        }
    }
}
local shopSalari = {        -- shop salari
    max = 2,
    amount = {
        police  = {
            [1]  = 15000,
            [2]  = 16000,
            [3]  = 17000,
            [4]  = 18000,
            [5]  = 19000,
            [6]  = 20000,
            [7]  = 21000,
            [8]  = 22000,
            [9]  = 23000,
            [10] = 24000,
            ['11:30'] = 5000
        },
        justice  = {
            [1]  = 13000,
            [2]  = 14000,
            [3]  = 15000,
            [4]  = 16000,
            [5]  = 17000,
            [6]  = 18000,
            [7]  = 19000,
            [8]  = 20000,
            [9]  = 21000,
            [10] = 22000,
            ['11:30'] = 5000
        }
    }
}
---------------------------------------------- miniBank
local miniBankBlip = {      -- miniBank Blip
    sprite = 431,
    color = 2,
    scale = 0.7,
    label = 'Mini Bank'
}
local miniBankReward = {    -- minibank Reward
    blackMoney = 700000,
    tokenXP = {
        xp = 10,
        token = {
            xp = 25, xp2 = 33, cooldown = 20 * 60,
            skill = 'minibank_skill', addSkill = {'minibank_skill', 'use_token_minibank'},
            quest = 'use_token_minibank', questKey  = 'success_minibank', searchQuest = 'search_token_minibank',
            skill2 = 'police_skill', addSkill2 = {'police_skill', 'search_token_minibank'}
        }
    }
}
local miniBankSalari = {    -- minibank Salari
    max = 4,
    amount = {
        police  = {
            [1]  = 17000,
            [2]  = 18000,
            [3]  = 19000,
            [4]  = 20000,
            [5]  = 21000,
            [6]  = 22000,
            [7]  = 23000,
            [8]  = 24000,
            [9]  = 25000,
            [10] = 26000,
            ['11:30'] = 5000,
        },
        justice  = {
            [1]  = 15000,
            [2]  = 16000,
            [3]  = 17000,
            [4]  = 18000,
            [5]  = 19000,
            [6]  = 20000,
            [7]  = 21000,
            [8]  = 22000,
            [9]  = 23000,
            [10] = 24000,
            ['11:30'] = 5000,
        }
    }
}
---------------------------------------------- hostage
local hostageBlip = {       -- hostage Blip
    sprite = 188,
    color = 27,
    scale = 1.5,
    label = 'Hostage'
}
local hostageReward = {     -- hostage Reward
    blackMoney = 500000,
    tokenXP = {
        xp = 30,
        token = {
            xp = 100, xp2 = 130, cooldown = 60 * 60,
            skill = 'hostage_skill', addSkill = {'hostage_skill', 'use_token_hostage'},
            quest = 'use_token_hostage', questKey  = 'success_hostage', searchQuest = 'search_token_hostage',
            skill2 = 'police_skill', addSkill2 = {'police_skill', 'search_token_hostage'}
        }
    }
}
local hostageSalari = {     -- hostage salari
    max = 20,
    amount = {
        sheriff  = {
            [1]  = 10000,
            [2]  = 10000,
            [3]  = 10000,
            [4]  = 10000,
            [5]  = 10000,
            [6]  = 10000,
            [7]  = 10000,
            [8]  = 10000,
            [9]  = 10000,
            [10] = 10000,
            ['11:30'] = 5000,
        }
    }
}

---------------------------------------------- Shop
config.rob2.shop_1 = {
    globalCDKey = 'shop',
    blip = shopBlip,
    cooldown = { self = 3600, global = 200 }, -- 1.35 mi
    label = 'Shop 1',
    rangeCheck = { coords = vec(-48.39, -1751.48, 29.42, 10.0) },
    startCheck = {
        robberNeed = 0,
        militaryNeed = { count = 2, jobs = { 'police' } }
    },
    steps = {
        { coords = vec(-43.87, -1749.14, 29.42), data = { passTime = 200 * 1000 } },
    },
    reward = shopReward,
    rewardNotEnough = {
        police = 0, coords = vec(-48.39, -1751.48, 29.42, 28.0),
        blackMoney = 30000, tokenXP = { xp = 5 }
    },
    policeSalary = shopSalari
}

config.rob2.shop_2 = {
    globalCDKey = 'shop',
    blip = shopBlip,
    cooldown = { self = 3600, global = 200 }, -- 1.07 mi
    label = 'Shop 2',
    rangeCheck = { coords = vec(29.06, -1342.59, 29.5, 9.5) },
    startCheck = {
        robberNeed = 0,
        militaryNeed = { count = 2, jobs = { 'police' } }
    },
    steps = {
        { coords = vec(28.85, -1339.28, 29.5), data = { passTime = 200 * 1000 } },
    },
    reward = shopReward,
    rewardNotEnough = {
        police = 0, coords = vec(34.38, -1343.03, 29.5, 28.0),
        blackMoney = 30000, tokenXP = { xp = 5 }
    },
    policeSalary = shopSalari
}

config.rob2.shop_3 = {
    globalCDKey = 'shop',
    blip = shopBlip,
    cooldown = { self = 3600, global = 200 }, -- 0.9 mi
    label = 'Shop 3',
    rangeCheck = { coords = vec(1132.96, -981.52, 46.42, 9.0) },
    startCheck = {
        robberNeed = 0,
        militaryNeed = { count = 2, jobs = { 'police' } }
    },
    steps = {
        { coords = vec(1126.81, -980.06, 45.42), data = { passTime = 200 * 1000 } },
    },
    reward = shopReward,
    rewardNotEnough = {
        police = 0, coords = vec(1132.96, -981.52, 46.42, 25.0),
        blackMoney = 30000, tokenXP = { xp = 5 }
    },
    policeSalary = shopSalari
}

config.rob2.shop_4 = {
    globalCDKey = 'shop',
    blip = shopBlip,
    cooldown = { self = 3600, global = 200 }, -- 1 mi
    label = 'Shop 4',
    rangeCheck = { coords = vec(-712.49, -906.93, 18.61, 12.5) },
    startCheck = {
        robberNeed = 0,
        militaryNeed = { count = 2, jobs = { 'police' } }
    },
    steps = {
        { coords = vec(-708.74, -904.1, 19.22), data = { passTime = 200 * 1000 } },
    },
    reward = shopReward,
    rewardNotEnough = {
        police = 0, coords = vec(-712.12, -916.89, 19.21, 28.0),
        blackMoney = 30000, tokenXP = { xp = 5 }
    },
    policeSalary = shopSalari
}

config.rob2.shop_5 = {
    globalCDKey = 'shop',
    blip = shopBlip,
    cooldown = { self = 3600, global = 230 }, -- 1.53 mi
    label = 'Shop 5',
    rangeCheck = { coords = vec(-1222.28, -909.86, 12.33, 9.5) },
    startCheck = {
        robberNeed = 0,
        militaryNeed = { count = 2, jobs = { 'police' } }
    },
    steps = {
        { coords = vec(-1220.71, -916.11, 11.33), data = { passTime = 230 * 1000 } },
    },
    reward = shopReward,
    rewardNotEnough = {
        police = 0, coords = vec(-1222.28, -909.86, 12.33, 28.0),
        blackMoney = 30000, tokenXP = { xp = 5 }
    },
    policeSalary = shopSalari
}

config.rob2.shop_6 = {
    globalCDKey = 'shop',
    blip = shopBlip,
    cooldown = { self = 3600, global = 200 }, -- 0.46 mi
    label = 'Shop 6',
    rangeCheck = { coords = vec(1158.9, -319.84, 69.21, 10.0) },
    startCheck = {
        robberNeed = 0,
        militaryNeed = { count = 2, jobs = { 'police' } }
    },
    steps = {
        { coords = vec(1159.82, -315.24, 69.21), data = { passTime = 200 * 1000 } },
    },
    reward = shopReward,
    rewardNotEnough = {
        police = 0, coords = vec(1158.9, -319.84, 69.21, 28.0),
        blackMoney = 30000, tokenXP = { xp = 5 }
    },
    policeSalary = shopSalari
}

config.rob2.shop_7 = {
    globalCDKey = 'shop',
    blip = shopBlip,
    cooldown = { self = 3600, global = 200 }, -- 0.40 mi
    label = 'Shop 7',
    rangeCheck = { coords = vec(378.19, 329.89, 103.57, 9.5) },
    startCheck = {
        robberNeed = 0,
        militaryNeed = { count = 2, jobs = { 'police' } }
    },
    steps = {
        { coords = vec(379.72, 332.15, 103.57), data = { passTime = 200 * 1000 } },
    },
    reward = shopReward,
    rewardNotEnough = {
        police = 0, coords = vec(378.36, 329.75, 103.57, 25.0),
        blackMoney = 30000, tokenXP = { xp = 5 }
    },
    policeSalary = shopSalari
}

config.rob2.shop_8 = {
    globalCDKey = 'shop',
    blip = shopBlip,
    cooldown = { self = 3600, global = 230 }, -- 1.55 mi
    label = 'Shop 8',
    rangeCheck = { coords = vec(-1484.72, -378.05, 40.16, 9.5) },
    startCheck = {
        robberNeed = 0,
        militaryNeed = { count = 2, jobs = { 'police' } }
    },
    steps = {
        { coords = vec(-1478.84, -375.41, 39.16), data = { passTime = 230 * 1000 } },
    },
    reward = shopReward,
    rewardNotEnough = {
        police = 0, coords = vec(-1484.72, -378.05, 40.16, 28.0),
        blackMoney = 30000, tokenXP = { xp = 5 }
    },
    policeSalary = shopSalari
}

config.rob2.shop_9 = {
    globalCDKey = 'shop',
    blip = shopBlip,
    cooldown = { self = 3600, global = 250 }, -- 3.16 mi
    label = 'Shop 9',
    rangeCheck = { coords = vec(2552.73, 385.6, 108.62, 9.5) },
    startCheck = {
        robberNeed = 0,
        militaryNeed = { count = 2, jobs = { 'police' } }
    },
    steps = {
        { coords = vec(2549.38, 385.52, 108.62), data = { passTime = 250 * 1000 } },
    },
    reward = shopReward,
    rewardNotEnough = {
        police = 0, coords = vec(2552.73, 385.6, 108.62, 30.0),
        blackMoney = 30000, tokenXP = { xp = 5 }
    },
    policeSalary = shopSalari
}

config.rob2.shop_10 = {
    globalCDKey = 'shop',
    blip = shopBlip,
    cooldown = { self = 3600, global = 250 }, -- 2.15 mi
    label = 'Shop 10',
    rangeCheck = { coords = vec(-1826.74, 793.4, 138.21, 10.0) },
    startCheck = {
        robberNeed = 0,
        militaryNeed = { count = 2, jobs = { 'police' } }
    },
    steps = {
        { coords = vec(-1828.37, 798.05, 138.18), data = { passTime = 250 * 1000 } },
    },
    reward = shopReward,
    rewardNotEnough = {
        police = 0, coords = vec(-1826.74, 793.4, 138.21, 28.0),
        blackMoney = 30000, tokenXP = { xp = 5 }
    },
    policeSalary = shopSalari
}

config.rob2.shop_11 = {
    globalCDKey = 'shop',
    blip = shopBlip,
    cooldown = { self = 3600, global = 250 }, -- 2.83 mi
    label = 'Shop 11',
    rangeCheck = { coords = vec(-2965.48, 389.75, 15.04, 9.5) },
    startCheck = {
        robberNeed = 0,
        militaryNeed = { count = 2, jobs = { 'police' } }
    },
    steps = {
        { coords = vec(-2959.51, 387.15, 14.04), data = { passTime = 250 * 1000 } },
    },
    reward = shopReward,
    rewardNotEnough = {
        police = 0, coords = vec(-2965.48, 389.75, 15.04, 28.0),
        blackMoney = 30000, tokenXP = { xp = 5 }
    },
    policeSalary = shopSalari
}

config.rob2.shop_12 = {
    globalCDKey = 'shop',
    blip = shopBlip,
    cooldown = { self = 3600, global = 260 }, -- 2.97 mi
    label = 'Shop 12',
    rangeCheck = { coords = vec(-3044.92, 587.55, 7.91, 9.0) },
    startCheck = {
        robberNeed = 0,
        militaryNeed = { count = 2, jobs = { 'police' } }
    },
    steps = {
        { coords = vec(-3047.79, 588.19, 7.91), data = { passTime = 260 * 1000 } },
    },
    reward = shopReward,
    rewardNotEnough = {
        police = 0, coords = vec(-3038.98, 589.43, 7.91, 28.0),
        blackMoney = 30000, tokenXP = { xp = 5 }
    },
    policeSalary = shopSalari
}

config.rob2.shop_13 = {
    globalCDKey = 'shop',
    blip = shopBlip,
    cooldown = { self = 3600, global = 260 }, -- 3.25 mi
    label = 'Shop 13',
    rangeCheck = { coords = vec(-3246.6, 1005.02, 12.83, 9.0) },
    startCheck = {
        robberNeed = 0,
        militaryNeed = { count = 2, jobs = { 'police' } }
    },
    steps = {
        { coords = vec(-3249.09, 1006.51, 12.83), data = { passTime = 260 * 1000 } },
    },
    reward = shopReward,
    rewardNotEnough = {
        police = 0, coords = vec(-3246.6, 1004.99, 12.84, 28.0),
        blackMoney = 30000, tokenXP = { xp = 5 }
    },
    policeSalary = shopSalari
}

config.rob2.shop_14 = {
    globalCDKey = 'shop',
    blip = shopBlip,
    cooldown = { self = 3600, global = 250 }, -- 2.23 mi
    label = 'Shop 14',
    rangeCheck = { coords = vec(545.09, 2666.13, 42.16, 9.0) },
    startCheck = {
        robberNeed = 0,
        militaryNeed = { count = 2, jobs = { 'police' } }
    },
    steps = {
        { coords = vec(546.41, 2662.74, 42.16), data = { passTime = 250 * 1000 } },
    },
    reward = shopReward,
    rewardNotEnough = {
        police = 0, coords = vec(545.09, 2666.13, 42.16, 25.0),
        blackMoney = 30000, tokenXP = { xp = 5 }
    },
    policeSalary = shopSalari
}

-- config.rob2.shop_15 = {
    --     globalCDKey = 'shop',
    --     blip = shopBlip,
    --     cooldown = { self = 3600, global = 250 }, -- 2.18 mi
    --     label = 'Shop 15',
    --     rangeCheck = { coords = vec(1167.11, 2712.02, 38.63, 9.5) },
    --     startCheck = {
    --         robberNeed = 0,
    --         militaryNeed = { count = 2, jobs = { 'police' } }
    --     },
    --     steps = {
    --         { coords = vec(1169.24, 2717.97, 37.16), data = { passTime = 250 * 1000 } },
    --     },
    --     reward = shopReward,
    --     rewardNotEnough = {
    --         police = 0, coords = vec(1167.11, 2712.02, 38.63, 28.0),
    --         blackMoney = 30000, tokenXP = { xp = 5 }
    --     },
    --     policeSalary = shopSalari
-- }

config.rob2.shop_16 = {
    globalCDKey = 'shop',
    blip = shopBlip,
    cooldown = { self = 3600, global = 250 }, -- 2.56 mi
    label = 'Shop 16',
    rangeCheck = { coords = vec(2676.18, 3285.78, 55.24, 9.0) },
    startCheck = {
        robberNeed = 0,
        militaryNeed = { count = 2, jobs = { 'police' } }
    },
    steps = {
        { coords = vec(2674.54, 3288.03, 55.24), data = { passTime = 250 * 1000 } },
    },
    reward = shopReward,
    rewardNotEnough = {
        police = 0, coords = vec(2674.25, 3281.34, 55.24, 30.0),
        blackMoney = 30000, tokenXP = { xp = 5 }
    },
    policeSalary = shopSalari
}

config.rob2.shop_17 = {
    globalCDKey = 'shop',
    blip = shopBlip,
    cooldown = { self = 3600, global = 200 }, -- 0.4 mi
    label = 'Shop 17',
    rangeCheck = { coords = vec(1961.68, 3746.4, 32.34, 9.5) },
    startCheck = {
        robberNeed = 0,
        militaryNeed = { count = 2, jobs = { 'police' } }
    },
    steps = {
        { coords = vec(1959.39, 3749.02, 32.34), data = { passTime = 200 * 1000 } },
    },
    reward = shopReward,
    rewardNotEnough = {
        police = 0, coords = vec(1961.68, 3746.4, 32.34, 28.0),
        blackMoney = 30000, tokenXP = { xp = 5 }
    },
    policeSalary = shopSalari
}

config.rob2.shop_18 = {
    globalCDKey = 'shop',
    blip = shopBlip,
    cooldown = { self = 3600, global = 200 }, -- 1.56 mi
    label = 'Shop 18',
    rangeCheck = { coords = vec(1704.4, 4925.15, 42.06, 10.0) },
    startCheck = {
        robberNeed = 0,
        militaryNeed = { count = 2, jobs = { 'police' } }
    },
    steps = {
        { coords = vec(1707.26, 4919.52, 42.06), data = { passTime = 200 * 1000 } },
    },
    reward = shopReward,
    rewardNotEnough = {
        police = 0, coords = vec(1699.0, 4929.36, 42.08, 28.0),
        blackMoney = 30000, tokenXP = { xp = 5 }
    },
    policeSalary = shopSalari
}

config.rob2.shop_19 = {
    globalCDKey = 'shop',
    blip = shopBlip,
    cooldown = { self = 3600, global = 240 }, -- sanie 2.5 mi
    label = 'Shop 19',
    rangeCheck = { coords = vec(1734.95, 6420.34, 35.03, 11.5) }, -- cancel rob
    startCheck = {
        robberNeed = 0, -- 0 bedune party
        militaryNeed = { count = 2, jobs = { 'police' } }
    },
    steps = {
        { coords = vec(1736.86, 6419.06, 35.04), data = { passTime = 240 * 1000 } }, -- blip
    },
    reward = shopReward,
    rewardNotEnough = {
        police = 0, coords = vec(1731.51, 6412.12, 35.04, 30.0), -- coords check police
        blackMoney = 30000, tokenXP = { xp = 5 }
    },
    policeSalary = shopSalari
}

config.rob2.shop_21 = {
    globalCDKey = 'shop',
    blip = miniJavaheriBlip,
    cooldown = { self = 3600, global = 220 }, -- 1.68 mi
    label = 'Mini Javaheri 1',
    rangeCheck = { coords = vec(-1132.06, -1357.73, 5.03, 8.5) },
    startCheck = {
        robberNeed = 0,
        militaryNeed = { count = 2, jobs = { 'police' } }
    },
    steps = {
        { coords = vec(-1127.82, -1351.98, 5.03), data = { passTime = 220 * 1000 } },
    },
    reward = shopReward,
    rewardNotEnough = {
        police = 0, coords = vec(-1132.06, -1357.73, 5.03, 28.0),
        blackMoney = 30000, tokenXP = { xp = 5 }
    },
    policeSalary = shopSalari
}

config.rob2.shop_22 = {
    globalCDKey = 'shop',
    blip = miniJavaheriBlip,
    cooldown = { self = 3600, global = 220 }, -- 1.58 mi
    label = 'Mini Javaheri 2',
    rangeCheck = { coords = vec(-1541.31, -416.6, 35.64, 8.5) },
    startCheck = {
        robberNeed = 0,
        militaryNeed = { count = 2, jobs = { 'police' } }
    },
    steps = {
        { coords = vec(-1543.1, -423.87, 35.64), data = { passTime = 220 * 1000 } },
    },
    reward = shopReward,
    rewardNotEnough = {
        police = 0, coords = vec(-1541.31, -416.6, 35.64, 28.5),
        blackMoney = 30000, tokenXP = { xp = 5 }
    },
    policeSalary = shopSalari
}

config.rob2.shop_23 = {
    globalCDKey = 'shop',
    blip = miniJavaheriBlip,
    cooldown = { self = 3600, global = 250 }, -- 2.3 mi
    label = 'Mini Javaheri 3',
    rangeCheck = { coords = vec(561.65, 2749.64, 42.21, 8.5) },
    startCheck = {
        robberNeed = 0,
        militaryNeed = { count = 2, jobs = { 'police' } }
    },
    steps = {
        { coords = vec(555.68, 2745.8, 42.2), data = { passTime = 250 * 1000 } },
    },
    reward = shopReward,
    rewardNotEnough = {
        police = 0, coords = vec(561.65, 2749.64, 42.21, 28.0),
        blackMoney = 30000, tokenXP = { xp = 5 }
    },
    policeSalary = shopSalari
}

config.rob2.shop_24 = {
    globalCDKey = 'shop',
    blip = miniJavaheriBlip,
    cooldown = { self = 3600, global = 210 }, -- 1.51 mi
    label = 'Mini Javaheri 4',
    rangeCheck = { coords = vec(1646.0, 4881.82, 42.16, 8.5) },
    startCheck = {
        robberNeed = 0,
        militaryNeed = { count = 2, jobs = { 'police' } }
    },
    steps = {
        { coords = vec(1649.31, 4875.71, 42.16), data = { passTime = 210 * 1000 } },
    },
    reward = shopReward,
    rewardNotEnough = {
        police = 0, coords = vec(1646.0, 4881.82, 42.16, 28.0),
        blackMoney = 30000, tokenXP = { xp = 5 }
    },
    policeSalary = shopSalari
}
---------------------------------------------- Mini Bank
config.rob2.minibank_1 = {
    globalCDKey = 'minibank',
    blip = miniBankBlip,
    cooldown = { self = 2700, global = 10 * 60 },
    label = 'Mini Bank 1',
    rangeCheck = { coords = vec(311.59, -282.33, 54.16, 9.0) },
    startCheck = {
        robberNeed = 4,
        militaryNeed = { count = 4, jobs = { 'police' } }
    },
    steps = {
        { coords = vec(312.76, -288.81, 54.14), data = { passTime = 240 * 1000 } },
    },
    reward = miniBankReward,
    rewardNotEnough = {
        police = 2, coords = vec(311.59, -282.33, 54.16, 29.0),
        blackMoney = 60000, tokenXP = { xp = 10 }
    },
    policeSalary = miniBankSalari
}

config.rob2.minibank_2 = {
    globalCDKey = 'minibank',
    blip = miniBankBlip,
    cooldown = { self = 2700, global = 10 * 60 },
    label = 'Mini Bank 2',
    rangeCheck = { coords = vec(-353.53, -53.09, 49.04, 9.0) },
    startCheck = {
        robberNeed = 4,
        militaryNeed = { count = 4, jobs = { 'police' } }
    },
    steps = {
        { coords = vec(-352.42, -59.58, 49.01), data = { passTime = 240 * 1000 } },
    },
    reward = miniBankReward,
    rewardNotEnough = {
        police = 2, coords = vec(-353.53, -53.09, 49.04, 29.0),
        blackMoney = 60000, tokenXP = { xp = 10 }
    },
    policeSalary = miniBankSalari
}

config.rob2.minibank_3 = {
    globalCDKey = 'minibank',
    blip = miniBankBlip,
    cooldown = { self = 2700, global = 10 * 60 },
    label = 'Mini Bank 3',
    rangeCheck = { coords = vec(-1212.12, -334.79, 37.78, 9.0) },
    startCheck = {
        robberNeed = 4,
        militaryNeed = { count = 4, jobs = { 'police' } }
    },
    steps = {
        { coords = vec(-1206.52, -338.2, 37.76), data = { passTime = 240 * 1000 } },
    },
    reward = miniBankReward,
    rewardNotEnough = {
        police = 2, coords = vec(-1212.12, -334.79, 37.78, 29.0),
        blackMoney = 60000, tokenXP = { xp = 10 }
    },
    policeSalary = miniBankSalari
}

config.rob2.minibank_4 = {
    globalCDKey = 'minibank',
    blip = miniBankBlip,
    cooldown = { self = 2700, global = 10 * 60 },
    label = 'Mini Bank 4',
    rangeCheck = { coords = vec(-2958.73, 481.36, 15.7, 9.0) },
    startCheck = {
        robberNeed = 4,
        militaryNeed = { count = 4, jobs = { 'police' } }
    },
    steps = {
        { coords = vec(-2954.29, 486.14, 15.67), data = { passTime = 300 * 1000 } },
    },
    reward = miniBankReward,
    rewardNotEnough = {
        police = 2, coords = vec(-2958.73, 481.36, 15.7, 29.0),
        blackMoney = 60000, tokenXP = { xp = 10 }
    },
    policeSalary = miniBankSalari
}

config.rob2.minibank_5 = {
    globalCDKey = 'minibank',
    blip = miniBankBlip,
    cooldown = { self = 2700, global = 10 * 60 },
    label = 'Mini Bank 5',
    rangeCheck = { coords = vec(1176.39, 2710.71, 38.09, 9.0) },
    startCheck = {
        robberNeed = 4,
        militaryNeed = { count = 4, jobs = { 'police' } }
    },
    steps = {
        { coords = vec(1172.48, 2716.18, 38.06), data = { passTime = 300 * 1000 } },
    },
    reward = miniBankReward,
    rewardNotEnough = {
        police = 2, coords = vec(1176.39, 2710.71, 38.09, 29.0),
        blackMoney = 60000, tokenXP = { xp = 10 }
    },
    policeSalary = miniBankSalari
}
-- ---------------------------------------------- Hostage Bank
config.rob2.hostage_1 = {
    globalCDKey = 'hostage',
    hostage = true,
    blip = hostageBlip,
    cooldown = { self = 10800, global = 10800 },
    label = 'Hostage 1',
    rangeCheck = { coords = vec(1648.97, 3808.57, 38.65, 50.0) },
    startCheck = {
        robberNeed = 5,
        militaryNeed = { count = 6, jobs = { 'sheriff' } }
    },
    steps = {
        {
            module = 'hack', label = 'Hack', ignoreFail = false, failPercentRemove = 1, coords = vec(1648.97, 3808.57, 38.65),
            data = { type = 'scrambler', type2 = 'alphanumeric', time = 45, mirrored = 0 , passTime = 1200 * 1000 }, -- Device Minigame
            itemNeed = { darkphone = 1 }
        }
    },
    reward = hostageReward,
    rewardNotEnough = {
        police = 5, coords = vec(1648.97, 3808.57, 38.65, 150.0),
        blackMoney = 100000,
    },
    policeSalary = hostageSalari
}

config.rob2.hostage_2 = {
    globalCDKey = 'hostage',
    hostage = true,
    blip = hostageBlip,
    cooldown = { self = 10800, global = 10800 },
    label = 'Hostage 2',
    rangeCheck = { coords = vec(-743.49, -2282.35, 13.06, 50.0) },
    startCheck = {
        robberNeed = 5,
        militaryNeed = { count = 6, jobs = { 'sheriff' } }
    },
    steps = {
        {
            module = 'hack', label = 'Hack', ignoreFail = false, failPercentRemove = 1, coords = vec(-743.49, -2282.35, 13.06),
            data = { type = 'scrambler', type2 = 'alphanumeric', time = 45, mirrored = 0 , passTime = 1200 * 1000 }, -- Device Minigame
            itemNeed = { darkphone = 1 }
        }
    },
    reward = hostageReward,
    rewardNotEnough = {
        police = 5, coords = vec(-743.49, -2282.35, 13.06, 150.0),
        blackMoney = 100000,
    },
    policeSalary = hostageSalari
}

config.rob2.hostage_3 = {
    globalCDKey = 'hostage',
    hostage = true,
    blip = hostageBlip,
    cooldown = { self = 10800, global = 10800 },
    label = 'Hostage 3',
    rangeCheck = { coords = vec(873.61, -954.18, 26.28, 50.0) },
    startCheck = {
        robberNeed = 5,
        militaryNeed = { count = 6, jobs = { 'sheriff' } }
    },
    steps = {
        {
            module = 'hack', label = 'Hack', ignoreFail = false, failPercentRemove = 1, coords = vec(873.61, -954.18, 26.28),
            data = { type = 'scrambler', type2 = 'alphanumeric', time = 45, mirrored = 0 , passTime = 1200 * 1000 }, -- Device Minigame
            itemNeed = { darkphone = 1 }
        }
    },
    reward = hostageReward,
    rewardNotEnough = {
        police = 5, coords = vec(873.61, -954.18, 26.28, 150.0),
        blackMoney = 100000,
    },
    policeSalary = hostageSalari
}

config.rob2.hostage_4 = {
    globalCDKey = 'hostage',
    hostage = true,
    blip = hostageBlip,
    cooldown = { self = 10800, global = 10800 },
    label = 'Hostage 4',
    rangeCheck = { coords = vec(-2038.93, -265.97, 23.39, 50.0) },
    startCheck = {
        robberNeed = 5,
        militaryNeed = { count = 6, jobs = { 'sheriff' } }
    },
    steps = {
        {
            module = 'hack', label = 'Hack', ignoreFail = false, failPercentRemove = 1, coords = vec(-2038.93, -265.97, 23.39),
            data = { type = 'scrambler', type2 = 'alphanumeric', time = 45, mirrored = 0 , passTime = 1200 * 1000 }, -- Device Minigame
            itemNeed = { darkphone = 1 }
        }
    },
    reward = hostageReward,
    rewardNotEnough = {
        police = 5, coords = vec(-2038.93, -265.97, 23.39, 150.0),
        blackMoney = 100000,
    },
    policeSalary = hostageSalari
}

config.rob2.hostage_5 = {
    globalCDKey = 'hostage',
    hostage = true,
    blip = hostageBlip,
    cooldown = { self = 10800, global = 10800 },
    label = 'Hostage 5',
    rangeCheck = { coords = vec(1143.02, 67.7, 80.76, 50.0) },
    startCheck = {
        robberNeed = 5,
        militaryNeed = { count = 6, jobs = { 'sheriff' } }
    },
    steps = {
        {
            module = 'hack', label = 'Hack', ignoreFail = false, failPercentRemove = 1, coords = vec(1143.02, 67.7, 80.76),
            data = { type = 'scrambler', type2 = 'alphanumeric', time = 45, mirrored = 0 , passTime = 1200 * 1000 }, -- Device Minigame
            itemNeed = { darkphone = 1 }
        }
    },
    reward = hostageReward,
    rewardNotEnough = {
        police = 5, coords = vec(1143.02, 67.7, 80.76, 200.0),
        blackMoney = 100000,
    },
    policeSalary = hostageSalari
}

config.rob2.hostage_6 = {
    globalCDKey = 'hostage',
    hostage = true,
    blip = hostageBlip,
    cooldown = { self = 10800, global = 10800 },
    label = 'Hostage 6',
    rangeCheck = { coords = vec(1743.21, -1633.48, 112.47, 50.0) },
    startCheck = {
        robberNeed = 5,
        militaryNeed = { count = 6, jobs = { 'sheriff' } }
    },
    steps = {
        {
            module = 'hack', label = 'Hack', ignoreFail = false, failPercentRemove = 1, coords = vec(1743.21, -1633.48, 112.47),
            data = { type = 'scrambler', type2 = 'alphanumeric', time = 45, mirrored = 0 , passTime = 1200 * 1000 }, -- Device Minigame
            itemNeed = { darkphone = 1 }
        }
    },
    reward = hostageReward,
    rewardNotEnough = {
        police = 5, coords = vec(1743.21, -1633.48, 112.47, 150.0),
        blackMoney = 100000,
    },
    policeSalary = hostageSalari
}
