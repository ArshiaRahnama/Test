-- Pub by FleeX Team , https://discord.gg/87rGBxgCsa

config.rob.centeralBank = {
    lotteryId = 1,
    fox = true,
    readyCheck = { police = 8, robbers = 8, time = 15000 },
    label = 'Bank markazi',
    successTime = 350,
    rangeCheck = { coords = vec(229.18, 213.98, 105.54, 150) },
    startCheck = {
        pointNeed = 8,
        robberNeed = 8,
        militaryNeed = { count = 9, jobs = { 'all' } }
    },
    join = {
        positions = {
            { coords = vec(257.82, 227.3, 106.29),   robber = true,  canExit = false },
            { coords = vec(219.75, 166.89, 105.39),  robber = false, canExit = true  },
            { coords = vec(288.33, 195.04, 104.37),  robber = false, canExit = true  }
        }
    },
    steps = {
        { module = 'simple1', label = 'Start', coords = vec(253.35, 221.16, 106.29), data = { passTime = 30 * 1000 } },
        {
            module = 'hack', label = 'Hack', ignoreFail = true, failPercentRemove = 1, coords = vec(241.44, 227.18, 106.29),
            data = { type = 'var', block = 5, time = 10}, -- var_simulation
            itemNeed = { raspberry = 1, redacard = 1 }
        },
        {
            module = 'hack', label = 'Hack', ignoreFail = true, failPercentRemove = 1, coords = vec(261.75, 223.15, 106.28),
            data = { type = 'thermite', block = 7, time = 15, fail = 3 }, -- thermite
            itemNeed = { raspberry = 1, orangeacard = 1 }
        },
        {
            module = 'hack', label = 'Hack', ignoreFail = true, failPercentRemove = 1, coords = vec(253.25, 228.41, 101.68),
            data = { type = 'scrambler', type2 = 'numeric', time = 45, mirrored = 0 }, -- Device Minigame [Type(alphabet, numeric, alphanumeric, greek, braille, runes)] [mirrored(0: Normal, 1: Normal + Mirrored 2: Mirrored only )]
            itemNeed = { raspberry = 1, yellowacard = 1 }
        },
        {
            module = 'hack', label = 'Hack', ignoreFail = true, failPercentRemove = 1, coords = vec(251.86, 216.91, 101.68),
            data = { type = 'scrambler', type2 = 'alphanumeric', time = 45, mirrored = 0 }, -- Device Minigame
            itemNeed = { raspberry = 1, yellowacard = 1 }
        },
        { module = 'simple1', label = 'Finish', coords = vec(265.32, 213.62, 101.68), data = { passTime = 8 * 60000 }, success = true },
    },
    reward = {
        coords = vec(264.28, 213.73, 102.53, 70.59),
        type = 2,
        data = {
            [1] = {
                [100] = {
                    blackMoney = 6000000,
                    items = {
                        redacard = { 50, 1 },
                        orangeacard = { 50, 1 },
                        yellowacard = { 50, 1 },
                        mythic1 = { 1, 1 },
                        wolfram = 100
                    }
                },
                [99] = {
                    blackMoney = 5860000,
                    items = {
                        redacard = { 50, 1 },
                        orangeacard = { 50, 1 },
                        yellowacard = { 50, 1 },
                        mythic1 = { 1, 1 },
                        wolfram = 97
                    }
                },
                [98] = {
                    blackMoney = 5700000,
                    items = {
                        redacard = { 50, 1 },
                        orangeacard = { 50, 1 },
                        yellowacard = { 50, 1 },
                        mythic1 = { 1, 1 },
                        wolfram = 95
                    }
                },
                [97] = {
                    blackMoney = 5560000,
                    items = {
                        redacard = { 50, 1 },
                        orangeacard = { 50, 1 },
                        yellowacard = { 50, 1 },
                        mythic1 = { 1, 1 },
                        wolfram = 92
                    }
                },
                [96] = {
                    blackMoney = 5400000,
                    items = {
                        redacard = { 50, 1 },
                        orangeacard = { 50, 1 },
                        yellowacard = { 50, 1 },
                        mythic1 = { 1, 1 },
                        wolfram = 90
                    }
                }
            }
        },
        tokenXP = {
            xp = 0,
            token = {
                xp = 180, xp2 = 235, cooldown = 30 * 60,
                skill = 'bankm_skill', addSkill = {'bankm_skill', 'use_token_bankm'},
                quest = 'use_token_bankm', questKey  = 'success_bankm', searchQuest = 'search_token_bankm',
                skill2 = 'mt_skill', addSkill2 = {'mt_skill', 'search_token_bankm'}
            }
        }
    },
    rewardNotEnough = {
        police = 5, type = 2, coords = vec(264.28, 213.73, 102.53, 70.59),
        data = {
            items = {
                redacard = { 50, 1 },
                orangeacard = { 50, 1 },
                yellowacard = { 50, 1 },
                raspberry = 2
            }
        }
    },
    vehicles = {
        spawner = {
            {
                models = {
                    { label = 'Maverick', model = 'polmav', livery = 5 },
                    { label = 'Buzzard', model = 'buzzp', livery = 5 },
                    { label = 'Frog', model = 'newsfrog', livery = 4 }
                },
                coords = {
                    { spawner = vec(208.97, 172.11, 105.49), spawnPoint = vec(201.78, 195.1, 105.57, 255.34) }
                },
                access = 'police'
            }
        },
        deleter = { vec(201.78, 195.1, 105.57) },
        max = { police = 3 }, list = {}, list2 = {}
    },
    policeSalary = {
        max = 9,
        amount = {
            police  = {
                [1]  = 50000,
                [2]  = 51000,
                [3]  = 52000,
                [4]  = 53000,
                [5]  = 54000,
                [6]  = 55000,
                [7]  = 56000,
                [8]  = 57000,
                [9]  = 58000,
                [10] = 59000,
                ['11:30'] = 5000,
            },
            mt  = {
                [1]  = 52000,
                [2]  = 53000,
                [3]  = 54000,
                [4]  = 55000,
                [5]  = 56000,
                [6]  = 57000,
                [7]  = 58000,
                [8]  = 59000,
                [9]  = 60000,
                [10] = 61000,
                [11] = 62000,
                [12] = 62000,
                [13] = 62000,
                ['14:30'] = 5000,
            }
        }
    }
}

config.rob.mazeBank = {
    lotteryId = 2,
    fox = true,
    readyCheck = { police = 6, robbers = 6, time = 15000 },
    label = 'Maze Bank',
    successTime = 350,
    rangeCheck = { coords = vec(-1307.75, -834.21, 17.07, 150) },
    startCheck = {
        pointNeed = 8,
        robberNeed = 6,
        militaryNeed = { count = 7, jobs = { 'all' } }
    },
    join = {
        positions = {
            { coords = vec(-1320.52, -826.41, 17.15),  robber = true,  canExit = false },
            { coords = vec(-1292.5, -847.83, 14.94),   robber = false, canExit = true  }
        }
    },
    steps = {
        { module = 'simple1', label = 'Start', coords = vec(-1328.73, -826.15, 16.96), data = { passTime = 30 * 1000 } },
        {
            module = 'hack', label = 'Hack', ignoreFail = true, failPercentRemove = 1, coords = vec(-1311.83, -823.1, 17.15),
            data = { type = 'thermite', block = 7, time = 15, fail = 3 }, -- thermite
            itemNeed = { raspberry = 1, orangeacard = 1 }
        },
        {
            module = 'hack', label = 'Hack', ignoreFail = true, failPercentRemove = 1, coords = vec(-1312.88, -821.07, 17.15),
            data = { type = 'scrambler', type2 = 'numeric', time = 45, mirrored = 0 }, -- Device Minigame
            itemNeed = { raspberry = 1, yellowacard = 1 }
        },
        { module = 'simple1', label = 'Finish', coords = vec(-1308.84, -812.55, 17.15), data = { passTime = 8 * 60000 }, success = true },
    },
    reward = {
        coords = vec(-1308.96, -811.7, 18.0, 215.85),
        type = 2,
        data = {
            [1] = {
                [100] = {
                    blackMoney = 4500000,
                    items = {
                        orangeacard = { 50, 1 },
                        greenacard = { 50, 1 },
                        blueacard = { 50, 1 },
                        purpleacard = { 50, 1 },
                        mythic1 = { 1, 1 },
                        wolfram = 75
                    }
                },
                [99] = {
                    blackMoney = 4140000,
                    items = {
                        orangeacard = { 50, 1 },
                        greenacard = { 50, 1 },
                        blueacard = { 50, 1 },
                        purpleacard = { 50, 1 },
                        mythic1 = { 1, 1 },
                        wolfram = 68
                    }
                },
                [98] = {
                    blackMoney = 3760000,
                    items = {
                        orangeacard = { 50, 1 },
                        greenacard = { 50, 1 },
                        blueacard = { 50, 1 },
                        purpleacard = { 50, 1 },
                        mythic1 = { 1, 1 },
                        wolfram = 62
                    }
                }
            }
        },
        tokenXP = {
            xp = 0,
            token = {
                xp = 85, xp2 = 110, cooldown = 30 * 60,
                skill = 'maze_skill', addSkill = {'maze_skill', 'use_token_maze'},
                quest = 'use_token_maze', questKey  = 'success_maze', searchQuest = 'search_token_maze',
                skill2 = 'mt_skill', addSkill2 = {'mt_skill', 'search_token_maze'}
            }
        },
    },
    rewardNotEnough = {
        police = 4, type = 2, coords = vec(-1308.96, -811.7, 18.0, 215.85),
        data = {
            items = {
                orangeacard = { 50, 1 },
                greenacard = { 50, 1 },
                blueacard = { 50, 1 },
                purpleacard = { 50, 1 },
                raspberry = 1
            }
        }
    },
    vehicles = {
        spawner = {
            {
                models = {
                    { label = 'Maverick', model = 'polmav', livery = 5 },
                    { label = 'Buzzard', model = 'buzzp', livery = 5 },
                    { label = 'Frog', model = 'newsfrog', livery = 4 }
                },
                coords = {
                    { spawner = vec(-1346.18, -870.56, 16.72), spawnPoint = vec(-1357.75, -862.73, 16.29, 312.0) }
                },
                access = 'police'
            }
        },
        deleter = { vec(-1357.75, -862.73, 16.29) },
        max = { police = 3 }, list = {}, list2 = {}
    },
    policeSalary = {
        max = 7,
        amount = {
            police  = {
                [1]  = 36000,
                [2]  = 37000,
                [3]  = 38000,
                [4]  = 39000,
                [5]  = 40000,
                [6]  = 41000,
                [7]  = 42000,
                [8]  = 43000,
                [9]  = 44000,
                [10] = 45000,
                ['11:30'] = 5000,
            },
            mt  = {
                [1]  = 38000,
                [2]  = 39000,
                [3]  = 40000,
                [4]  = 41000,
                [5]  = 42000,
                [6]  = 43000,
                [7]  = 44000,
                [8]  = 45000,
                [9]  = 46000,
                [10] = 47000,
                [11] = 48000,
                [12] = 48000,
                [13] = 48000,
                ['14:30'] = 5000,
            }
        }
    }
}

config.rob.paletoBank = {
    lotteryId = 3,
    fox = true,
    readyCheck = { police = 5, robbers = 5, time = 15000 },
    label = 'Paleto Bank',
    successTime = 350,
    rangeCheck = { coords = vec(-113.5, 6459.73, 31.47, 150) },
    startCheck = {
        pointNeed = 5,
        robberNeed = 5,
        militaryNeed = { count = 6, jobs = { 'all' } }
    },
    join = {
        positions = {
            { coords = vec(-102.14, 6468.53, 31.63),   robber = true,  canExit = false },
            { coords = vec(-138.89, 6473.01, 31.47),   robber = false, canExit = true  }
        }
    },
    steps = {
        { module = 'simple1', label = 'Start', coords = vec(-119.01, 6477.51, 31.57), data = { passTime = 30 * 1000 } },
        {
            module = 'hack', label = 'Hack', ignoreFail = true, failPercentRemove = 1, coords = vec(-105.67, 6470.51, 31.63),
            data = { type = 'var', block = 5, time = 10}, -- var_simulation
            itemNeed = { raspberry = 1, redacard = 1 }
        },
        {
            module = 'hack', label = 'Hack', ignoreFail = true, failPercentRemove = 1, coords = vec(-111.72, 6471.76, 31.63),
            data = { type = 'thermite', block = 7, time = 15, fail = 3 }, -- thermite
            itemNeed = { raspberry = 1, orangeacard = 1 }
        },
        { module = 'simple1', label = 'Finish', coords = vec(-103.91, 6477.59, 31.63), data = { passTime = 8 * 60000 }, success = true }
    },
    reward = {
        coords = vec(-104.54, 6477.29, 32.51, 130.91),
        type = 2,
        data = {
            [1] = {
                [100] = {
                    blackMoney = 3760000,
                    items = {
                        redacard = { 50, 1 },
                        orangeacard = { 50, 1 },
                        blueacard = { 50, 1 },
                        purpleacard = { 50, 1 },
                        mythic1 = { 1, 1 },
                        wolfram = 62
                    }
                },
                [99] = {
                    blackMoney = 3540000,
                    items = {
                        redacard = { 50, 1 },
                        orangeacard = { 50, 1 },
                        blueacard = { 50, 1 },
                        purpleacard = { 50, 1 },
                        mythic1 = { 1, 1 },
                        wolfram = 58
                    }
                },
                [98] = {
                    blackMoney = 3300000,
                    items = {
                        redacard = { 50, 1 },
                        orangeacard = { 50, 1 },
                        blueacard = { 50, 1 },
                        purpleacard = { 50, 1 },
                        mythic1 = { 1, 1 },
                        wolfram = 55
                    }
                }
            }
        },
        tokenXP = {
            xp = 0,
            token = {
                xp = 100, xp2 = 130, cooldown = 30 * 60,
                skill = 'paleto_skill', addSkill = {'paleto_skill', 'use_token_paleto'},
                quest = 'use_token_paleto', questKey  = 'success_paleto', searchQuest = 'search_token_paleto',
                skill2 = 'mt_skill', addSkill2 = {'mt_skill', 'search_token_paleto'}
            }
        },
    },
    rewardNotEnough = {
        police = 3, type = 2, coords = vec(-104.54, 6477.29, 32.51, 130.91),
        data = {
            items = {
                redacard = { 50, 1 },
                orangeacard = { 50, 1 },
                blueacard = { 50, 1 },
                purpleacard = { 50, 1 },
                raspberry = 1
            }
        }
    },
    vehicles = {
        spawner = {
            {
                models = {
                    { label = 'Maverick', model = 'polmav', livery = 5 },
                    { label = 'Buzzard', model = 'buzzp', livery = 5 },
                    { label = 'Frog', model = 'newsfrog', livery = 4 }
                },
                coords = {
                    { spawner = vec(-130.09, 6450.13, 31.56), spawnPoint = vec(-136.1, 6443.35, 31.53, 222.76) }
                },
                access = 'police'
            }
        },
        deleter = { vec(-136.1, 6443.35, 31.53) },
        max = { police = 3 }, list = {}, list2 = {}
    },
    policeSalary = {
        max = 6,
        amount = {
            police  = {
                [1]  = 45000,
                [2]  = 46000,
                [3]  = 47000,
                [4]  = 48000,
                [5]  = 49000,
                [6]  = 50000,
                [7]  = 51000,
                [8]  = 52000,
                [9]  = 53000,
                [10] = 54000,
                ['11:30'] = 5000,
            },
            mt  = {
                [1]  = 47000,
                [2]  = 48000,
                [3]  = 49000,
                [4]  = 50000,
                [5]  = 51000,
                [6]  = 52000,
                [7]  = 53000,
                [8]  = 54000,
                [9]  = 55000,
                [10] = 56000,
                [11] = 57000,
                [12] = 57000,
                [13] = 57000,
                ['14:30'] = 5000,
            }
        }
    }
}

config.rob.flatJewelry = {
    lotteryId = 1,
    fox = true,
    readyCheck = { police = 8, robbers = 8, time = 15000 },
    label = 'Flat Jewelry',
    successTime = 350,
    rangeCheck = { coords = vec(809.63, -2026.47, 29.26, 150) },
    startCheck = {
        pointNeed = 8,
        robberNeed = 8,
        militaryNeed = { count = 9, jobs = { 'all' } }
    },
    join = {
        positions = {
            { coords = vec(851.66, -2029.86, 29.85),   robber = true,  canExit = false },
            { coords = vec(806.93, -2002.42, 29.96),   robber = false, canExit = true  }
        }
    },
    steps = {
        { module = 'simple1', label = 'Start', coords = vec(803.9, -1995.78, 29.28), data = { passTime = 30 * 1000 } },
        {
            module = 'hack', label = 'Hack', ignoreFail = true, failPercentRemove = 1, coords = vec(856.43, -2014.91, 29.83),
            data = { type = 'var', block = 5, time = 10}, -- var_simulation
            itemNeed = { raspberry = 1, redacard = 1 }
        },
        {
            module = 'hack', label = 'Hack', ignoreFail = true, failPercentRemove = 1, coords = vec(854.78, -2029.52, 29.85),
            data = { type = 'thermite', block = 7, time = 15, fail = 3 }, -- thermite
            itemNeed = { raspberry = 1, orangeacard = 1 }
        },
        {
            module = 'hack', label = 'Hack', ignoreFail = true, failPercentRemove = 1, coords = vec(846.01, -2004.93, 29.79),
            data = { type = 'scrambler', type2 = 'numeric', time = 45, mirrored = 0 }, -- Device Minigame
            itemNeed = { raspberry = 1, yellowacard = 1 }
        },
        {
            module = 'hack', label = 'Hack', ignoreFail = true, failPercentRemove = 1, coords = vec(836.8, -2006.62, 29.78),
            data = { type = 'scrambler', type2 = 'alphanumeric', time = 45, mirrored = 0 }, -- Device Minigame
            itemNeed = { raspberry = 1, yellowacard = 1 }
        },
        { module = 'simple1', label = 'Finish', coords = vec(846.89, -2008.93, 29.8), data = { passTime = 8 * 60000 }, success = true }
    },
    reward = {
        coords = vec(844.75, -2004.28, 30.54, 83.77),
        type = 2,
        data = {
            [1] = {
                [100] = {
                    blackMoney = 3000000,
                    items = {
                        jewels = 2000,
                        orangeacard = { 50, 1 },
                        yellowacard = { 50, 1 },
                        greenacard = { 50, 1 },
                        blueacard = { 50, 1 },
                        mythic1 = { 1, 1 },
                        wolfram = 50
                    }
                },
                [99] = {
                    blackMoney = 2830000,
                    items = {
                        jewels = 1875,
                        orangeacard = { 50, 1 },
                        yellowacard = { 50, 1 },
                        greenacard = { 50, 1 },
                        blueacard = { 50, 1 },
                        mythic1 = { 1, 1 },
                        wolfram = 46
                    }
                },
                [98] = {
                    blackMoney = 2640000,
                    items = {
                        jewels = 1750,
                        orangeacard = { 50, 1 },
                        yellowacard = { 50, 1 },
                        greenacard = { 50, 1 },
                        blueacard = { 50, 1 },
                        mythic1 = { 1, 1 },
                        wolfram = 43
                    }
                },
                [97] = {
                    blackMoney = 2450000,
                    items = {
                        jewels = 1625,
                        orangeacard = { 50, 1 },
                        yellowacard = { 50, 1 },
                        greenacard = { 50, 1 },
                        blueacard = { 50, 1 },
                        mythic1 = { 1, 1 },
                        wolfram = 40
                    }
                },
                [96] = {
                    blackMoney = 2260000,
                    items = {
                        jewels = 1500,
                        orangeacard = { 50, 1 },
                        yellowacard = { 50, 1 },
                        greenacard = { 50, 1 },
                        blueacard = { 50, 1 },
                        mythic1 = { 1, 1 },
                        wolfram = 37
                    }
                }
            }
        },
        tokenXP = {
            xp = 0,
            token = {
                xp = 180, xp2 = 235, cooldown = 30 * 60,
                skill = 'flat_skill', addSkill = {'flat_skill', 'use_token_flat'},
                quest = 'use_token_flat', questKey  = 'success_flat', searchQuest = 'search_token_flat',
                skill2 = 'mt_skill', addSkill2 = {'mt_skill', 'search_token_flat'}
            }
        }
    },
    rewardNotEnough = {
        police = 5, type = 2, coords = vec(844.75, -2004.28, 30.54, 83.77),
        data = {
            items = {
                orangeacard = { 50, 1 },
                yellowacard = { 50, 1 },
                greenacard = { 50, 1 },
                blueacard = { 50, 1 },
                raspberry = 2
            }
        }
    },
    vehicles = {
        spawner = {
            {
                models = {
                    { label = 'Maverick', model = 'polmav', livery = 5 },
                    { label = 'Buzzard', model = 'buzzp', livery = 5 },
                    { label = 'Frog', model = 'newsfrog', livery = 4 }
                },
                coords = {
                    { spawner = vec(750.92, -2026.44, 29.29), spawnPoint = vec(787.63, -2065.31, 29.37, 353.7) }
                },
                access = 'police'
            }
        },
        deleter = { vec(787.63, -2065.31, 29.37) },
        max = { police = 3 }, list = {}, list2 = {}
    },
    policeSalary = {
        max = 9,
        amount = {
            police  = {
                [1]  = 50000,
                [2]  = 51000,
                [3]  = 52000,
                [4]  = 53000,
                [5]  = 54000,
                [6]  = 55000,
                [7]  = 56000,
                [8]  = 57000,
                [9]  = 58000,
                [10] = 59000,
                ['11:30'] = 5000,
            },
            mt  = {
                [1]  = 52000,
                [2]  = 53000,
                [3]  = 54000,
                [4]  = 55000,
                [5]  = 56000,
                [6]  = 57000,
                [7]  = 58000,
                [8]  = 59000,
                [9]  = 60000,
                [10] = 61000,
                [11] = 62000,
                [12] = 62000,
                [13] = 62000,
                ['14:30'] = 5000,
            }
        }
    }
}

config.rob.cityJewelry = {
    lotteryId = 4,
    fox = true,
    readyCheck = { police = 4, robbers = 4, time = 15000 },
    label = 'City Jewelry',
    successTime = 350,
    rangeCheck = { coords = vec(-634.25, -239.48, 38.03, 100) },
    startCheck = {
        pointNeed = 4,
        robberNeed = 4,
        militaryNeed = { count = 4, jobs = { 'all' } }
    },
    join = {
        positions = {
            { coords = vec(-618.62, -228.21, 38.06),  robber = true,  canExit = false },
            { coords = vec(-668.24, -237.55, 36.8),   robber = false, canExit = true  }
        }
    },
    steps = {
        { module = 'simple1', label = 'Start', coords = vec(-629.32, -230.77, 38.06), data = { passTime = 30 * 1000 } },
        {
            module = 'hack', label = 'Hack', ignoreFail = true, failPercentRemove = 1, coords = vec(-631.57, -230.25, 38.06),
            data = { type = 'scrambler', type2 = 'alphanumeric', time = 45, mirrored = 0 }, -- Device Minigame
            itemNeed = { raspberry = 1, yellowacard = 1 }
        },
        { module = 'simple1', label = 'Finish', coords = vec(-622.13, -230.71, 38.06), data = { passTime = 8 * 60000 }, success = true }
    },
    reward = {
        coords = vec(-622.17, -232.19, 38.06, 133.25),
        type = 2,
        data = {
            [1] = {
                [100] = {
                    items = {
                        jewels = 1300,
                        blueacard = { 50, 1 },
                        purpleacard = { 50, 1 },
                        mythic1 = { 1, 1 }
                    }
                },
                [99] = {
                    items = {
                        jewels = 1000,
                        blueacard = { 50, 1 },
                        purpleacard = { 50, 1 },
                        mythic1 = { 1, 1 }
                    }
                }
            }
        },
        tokenXP = {
            xp = 0,
            token = {
                xp = 50, xp2 = 65, cooldown = 30 * 60,
                skill = 'jewel_skill', addSkill = {'jewel_skill', 'use_token_jewel'},
                quest = 'use_token_jewel', questKey  = 'success_jewel', searchQuest = 'search_token_jewel',
                skill2 = 'mt_skill', addSkill2 = {'mt_skill', 'search_token_jewel'}
            }
        }
    },
    rewardNotEnough = {
        police = 2, type = 2, coords = vec(-622.17, -232.19, 38.06, 133.25),
        data = {
            items = {
                blueacard = { 50, 1 },
                purpleacard = { 50, 1 },
                raspberry = 1
            }
        }
    },
    policeSalary = {
        max = 4,
        amount = {
            police  = {
                [1]  = 26000,
                [2]  = 27000,
                [3]  = 28000,
                [4]  = 29000,
                [5]  = 30000,
                [6]  = 31000,
                [7]  = 32000,
                [8]  = 33000,
                [9]  = 34000,
                [10] = 35000,
                ['11:30'] = 5000,
            },
            mt  = {
                [1]  = 28000,
                [2]  = 29000,
                [3]  = 30000,
                [4]  = 31000,
                [5]  = 32000,
                [6]  = 33000,
                [7]  = 34000,
                [8]  = 35000,
                [9]  = 36000,
                [10] = 37000,
                [11] = 38000,
                [12] = 38000,
                [13] = 38000,
                ['14:30'] = 5000,
            }
        }
    }
}

config.rob.shamsJewelry = {
    lotteryId = 4,
    fox = true,
    readyCheck = { police = 4, robbers = 4, time = 15000 },
    label = 'Shams Jewelry',
    successTime = 350,
    rangeCheck = { coords = vec(2747.61, 3472.4, 55.67, 100) },
    startCheck = {
        pointNeed = 8,
        robberNeed = 4,
        militaryNeed = { count = 4, jobs = { 'all' } }
    },
    join = {
        positions = {
            { coords = vec(2728.82, 3475.81, 55.69),  robber = true,  canExit = false },
            { coords = vec(2759.47, 3493.4, 55.44),   robber = false, canExit = true  },
            { coords = vec(2741.3, 3449.55, 56.07),   robber = false, canExit = true  }
        }
    },
    steps = {
        { module = 'simple1', label = 'Start', coords = vec(2729.57, 3462.9, 56.64), data = { passTime = 30 * 1000 } },
        {
            module = 'hack', label = 'Hack', ignoreFail = true, failPercentRemove = 1, coords = vec(2733.24, 3478.92, 55.69),
            data = { type = 'scrambler', type2 = 'alphanumeric', time = 45, mirrored = 0 }, -- Device Minigame
            itemNeed = { raspberry = 1, yellowacard = 1 }
        },
        { module = 'simple1', label = 'Finish', coords = vec(2745.09, 3491.29, 56.59), data = { passTime = 8 * 60000 }, success = true }
    },
    reward = {
        coords = vec(2731.87, 3484.41, 55.69, 244.94),
        type = 2,
        data = {
            [1] = {
                [100] = {
                    items = {
                        jewels = 1000,
                        blueacard = { 50, 1 },
                        purpleacard = { 50, 1 },
                        mythic1 = { 1, 1 }
                    }
                },
                [99] = {
                    items = {
                        jewels = 800,
                        blueacard = { 50, 1 },
                        purpleacard = { 50, 1 },
                        mythic1 = { 1, 1 }
                    }
                }
            }
        },
        tokenXP = {
            xp = 0,
            token = {
                xp = 50, xp2 = 65, cooldown = 30 * 60,
                skill = 'jewel_skill', addSkill = {'jewel_skill', 'use_token_jewel'},
                quest = 'use_token_jewel', questKey  = 'success_jewel', searchQuest = 'search_token_jewel',
                skill2 = 'mt_skill', addSkill2 = {'mt_skill', 'search_token_jewel'}
            }
        }
    },
    rewardNotEnough = {
        police = 2, type = 2, coords = vec(2731.87, 3484.41, 55.69, 244.94),
        data = {
            items = {
                blueacard = { 50, 1 },
                purpleacard = { 50, 1 },
                raspberry = 1
            }
        }
    },
    policeSalary = {
        max = 4,
        amount = {
            police  = {
                [1]  = 26000,
                [2]  = 27000,
                [3]  = 28000,
                [4]  = 29000,
                [5]  = 30000,
                [6]  = 31000,
                [7]  = 32000,
                [8]  = 33000,
                [9]  = 34000,
                [10] = 35000,
                ['11:30'] = 5000,
            },
            mt  = {
                [1]  = 28000,
                [2]  = 29000,
                [3]  = 30000,
                [4]  = 31000,
                [5]  = 32000,
                [6]  = 33000,
                [7]  = 34000,
                [8]  = 35000,
                [9]  = 36000,
                [10] = 37000,
                [11] = 38000,
                [12] = 38000,
                [13] = 38000,
                ['14:30'] = 5000,
            }
        }
    }
}

config.rob.sanvitus = {
    lotteryId = 4,
    fox = true,
    readyCheck = { police = 4, robbers = 4, time = 15000 },
    label = 'SanVitus Jewelry',
    successTime = 350,
    rangeCheck = { coords = vec(-239.2, 243.98, 92.04, 100) },
    startCheck = {
        pointNeed = 4,
        robberNeed = 4,
        militaryNeed = { count = 4, jobs = { 'all' } }
    },
    join = {
        positions = {
            { coords = vec(-252.89, 221.34, 92.03),   robber = true,  canExit = false },
            { coords = vec(-269.0, 244.48, 90.42),    robber = false, canExit = true  }
        }
    },
    steps = {
        { module = 'simple1', label = 'Start', coords = vec(-244.49, 225.83, 92.03), data = { passTime = 30 * 1000 } },
        {
            module = 'hack', label = 'Hack', ignoreFail = true, failPercentRemove = 1, coords = vec(-245.92, 235.77, 92.03),
            data = { type = 'scrambler', type2 = 'numeric', time = 45, mirrored = 0 }, -- Device Minigame
            itemNeed = { raspberry = 1, yellowacard = 1 }
        },
        { module = 'simple1', label = 'Finish', coords = vec(-240.28, 230.43, 92.03), data = { passTime = 8 * 60000 }, success = true }
    },
    reward = {
        coords = vec(-249.69, 225.3, 92.03, 195.1),
        type = 2,
        data = {
            [1] = {
                [100] = {
                    items = {
                        jewels = 1500,
                        blueacard = { 50, 1 },
                        purpleacard = { 50, 1 },
                        mythic1 = { 1, 1 }
                    }
                },
                [99] = {
                    items = {
                        jewels = 1300,
                        blueacard = { 50, 1 },
                        purpleacard = { 50, 1 },
                        mythic1 = { 1, 1 }
                    }
                }
            }
        },
        tokenXP = {
            xp = 0,
            token = {
                xp = 50, xp2 = 65, cooldown = 30 * 60,
                skill = 'jewel_skill', addSkill = {'jewel_skill', 'use_token_jewel'},
                quest = 'use_token_jewel', questKey  = 'success_jewel', searchQuest = 'search_token_jewel',
                skill2 = 'mt_skill', addSkill2 = {'mt_skill', 'search_token_jewel'}
            }
        }
    },
    rewardNotEnough = {
        police = 2, type = 2, coords = vec(-249.69, 225.3, 92.03, 195.1),
        data = {
            items = {
                blueacard = { 50, 1 },
                purpleacard = { 50, 1 },
                raspberry = 1
            }
        }
    },
    policeSalary = {
        max = 4,
        amount = {
            police  = {
                [1]  = 26000,
                [2]  = 27000,
                [3]  = 28000,
                [4]  = 29000,
                [5]  = 30000,
                [6]  = 31000,
                [7]  = 32000,
                [8]  = 33000,
                [9]  = 34000,
                [10] = 35000,
                ['11:30'] = 5000,
            },
            mt  = {
                [1]  = 28000,
                [2]  = 29000,
                [3]  = 30000,
                [4]  = 31000,
                [5]  = 32000,
                [6]  = 33000,
                [7]  = 34000,
                [8]  = 35000,
                [9]  = 36000,
                [10] = 37000,
                [11] = 38000,
                [12] = 38000,
                [13] = 38000,
                ['14:30'] = 5000,
            }
        }
    }
}

config.rob.bimeh = {
    lotteryId = 3,
    fox = true,
    readyCheck = { police = 5, robbers = 5, time = 15000 },
    label = 'Bimeh',
    successTime = 350,
    rangeCheck = { coords = vec(-1084.61, -262.13, 37.77, 150) },
    startCheck = {
        pointNeed = 5,
        robberNeed = 5,
        militaryNeed = { count = 6, jobs = { 'all' } }
    },
    join = {
        positions = {
            { coords = vec(-1078.01, -254.62, 44.02),  robber = true,  canExit = false },
            { coords = vec(-1074.07, -286.97, 37.65),  robber = false, canExit = true  }
        }
    },
    steps = {
        { module = 'simple1', label = 'Start', coords = vec(-1045.57, -228.18, 39.01), data = { passTime = 30 * 1000 } },
        {
            module = 'hack', label = 'Hack', ignoreFail = true, failPercentRemove = 1, coords = vec(-1051.15, -238.11, 39.73),
            data = { type = 'var', block = 5, time = 10}, -- var_simulation
            itemNeed = { raspberry = 1, redacard = 1 }
        },
        {
            module = 'hack', label = 'Hack', ignoreFail = true, failPercentRemove = 1, coords = vec(-1056.75, -233.25, 44.02),
            data = { type = 'thermite', block = 7, time = 15, fail = 3 }, -- thermite
            itemNeed = { raspberry = 1, orangeacard = 1 }
        },
        { module = 'simple1', label = 'Finish', coords = vec(-1066.74, -243.84, 44.02), data = { passTime = 8 * 60000 }, success = true }
    },
    reward = {
        coords = vec(-1055.94, -233.08, 44.92, 204.61),
        type = 2,
        data = {
            [1] = {
                [100] = {
                    blackMoney = 3760000,
                    items = {
                        redacard = { 50, 1 },
                        orangeacard = { 50, 1 },
                        yellowacard = { 50, 1 },
                        mythic1 = { 1, 1 },
                        wolfram = 62
                    }
                },
                [99] = {
                    blackMoney = 3600000,
                    items = {
                        redacard = { 50, 1 },
                        orangeacard = { 50, 1 },
                        yellowacard = { 50, 1 },
                        mythic1 = { 1, 1 },
                        wolfram = 60
                    }
                },
                [98] = {
                    blackMoney = 3460000,
                    items = {
                        redacard = { 50, 1 },
                        orangeacard = { 50, 1 },
                        yellowacard = { 50, 1 },
                        mythic1 = { 1, 1 },
                        wolfram = 57
                    }
                },
            }
        },
        tokenXP = {
            xp = 0,
            token = {
                xp = 100, xp2 = 130, cooldown = 30 * 60,
                skill = 'bime_skill', addSkill = {'bime_skill', 'use_token_bime'},
                quest = 'use_token_bime', questKey  = 'success_bime', searchQuest = 'search_token_bime',
                skill2 = 'mt_skill', addSkill2 = {'mt_skill', 'search_token_bime'}
            }
        }
    },
    rewardNotEnough = {
        police = 3, type = 2, vec(-1055.94, -233.08, 44.92, 204.61),
        data = {
            items = {
                redacard = { 50, 1 },
                orangeacard = { 50, 1 },
                yellowacard = { 50, 1 },
                raspberry = 1
            }
        }
    },
    vehicles = {
        spawner = {
            {
                models = {
                    { label = 'Maverick', model = 'polmav', livery = 5 },
                    { label = 'Buzzard', model = 'buzzp', livery = 5 },
                    { label = 'Frog', model = 'newsfrog', livery = 4 }
                },
                coords = {
                    { spawner = vec(-1064.29, -283.27, 37.71), spawnPoint = vec(-1045.03, -273.42, 37.86, 28.41) }
                },
                access = 'police'
            }
        },
        deleter = { vec(-1045.03, -273.42, 37.86) },
        max = { police = 3 }, list = {}, list2 = {}
    },
    policeSalary = {
        max = 6,
        amount = {
            police  = {
                [1]  = 64000,
                [2]  = 65000,
                [3]  = 66000,
                [4]  = 67000,
                [5]  = 68000,
                [6]  = 69000,
                [7]  = 70000,
                [8]  = 71000,
                [9]  = 72000,
                [10] = 73000,
                ['11:30'] = 5000,
            },
            mt  = {
                [1]  = 66000,
                [2]  = 67000,
                [3]  = 68000,
                [4]  = 69000,
                [5]  = 70000,
                [6]  = 71000,
                [7]  = 72000,
                [8]  = 73000,
                [9]  = 74000,
                [10] = 75000,
                [11] = 76000,
                [12] = 76000,
                [13] = 76000,
                ['14:30'] = 5000,
            }
        }
    }
}

config.rob.cargo = {
    lotteryId = 5,
    fox = true,
    readyCheck = { police = 8, robbers = 8, time = 15000 },
    label = 'Cargo',
    successTime = 450,
    rangeCheck = { coords = vec(-658.06, 5305.17, 65.67, 800) },
    rangeCheck2 = { coords = vec(-1162.98, 4925.4, 222.89, 250) },
    startCheck = {
        pointNeed = 8,
        robberNeed = 8,
        militaryNeed = { count = 9, jobs = { 'all' } }
    },
    join = {
        positions = {
            { coords = vec(-1058.83, 4915.34, 211.82),  robber = true,  canExit = false },
            { coords = vec(-478.69, 6015.46, 31.34),    robber = false, canExit = true  },
            { coords = vec(-1036.3, 5015.63, 185.59),   robber = false, canExit = true  }
        }
    },
    steps = {
        { module = 'simple1', label = 'Start', coords = vec(-1101.48, 4940.9, 218.35), data = { passTime = 30 * 1000 } },
        {
            module = 'hack', label = 'Hack', ignoreFail = true, failPercentRemove = 1, coords = vec(-1130.27, 4953.2, 222.27),
            data = { type = 'var', block = 5, time = 10}, -- var_simulation
            itemNeed = { raspberry = 1, redacard = 1 }
        },
        {
            module = 'hack', label = 'Hack', ignoreFail = true, failPercentRemove = 1, coords = vec(-1113.43, 4903.88, 218.6),
            data = { type = 'thermite', block = 7, time = 15, fail = 3 }, -- thermite
            itemNeed = { raspberry = 1, orangeacard = 1 }
        },
        {
            module = 'hack', label = 'Hack', ignoreFail = true, failPercentRemove = 1, coords = vec(-1098.5, 4893.42, 216.07),
            data = { type = 'scrambler', type2 = 'numeric', time = 45, mirrored = 0 }, -- Device Minigame
            itemNeed = { raspberry = 1, yellowacard = 1 }
        },
        {
            module = 'hack', label = 'Hack', ignoreFail = true, failPercentRemove = 1, coords = vec(-1135.68, 4959.56, 226.24),
            data = { type = 'scrambler', type2 = 'alphanumeric', time = 45, mirrored = 0 }, -- Device Minigame
            itemNeed = { raspberry = 1, yellowacard = 1 }
        },
        { module = 'simple1', label = 'Finish', coords = vec(-1167.97, 4926.06, 223.06), data = { passTime = 8 * 60000 }, success = true }
    },
    reward = {
        coords = vec(-1170.01, 4926.32, 224.37, 260.78),
        type = 2,
        data = {
            [1] = {
                [100] = {
                    blackMoney = 6000000,
                    items = {
                        redacard = { 50, 1 },
                        orangeacard = { 50, 1 },
                        yellowacard = { 50, 1 },
                        mythic1 = { 1, 1 },
                        wolfram = 100
                    }
                },
                [99] = {
                    blackMoney = 5860000,
                    items = {
                        redacard = { 50, 1 },
                        orangeacard = { 50, 1 },
                        yellowacard = { 50, 1 },
                        mythic1 = { 1, 1 },
                        wolfram = 97
                    }
                },
                [98] = {
                    blackMoney = 5700000,
                    items = {
                        redacard = { 50, 1 },
                        orangeacard = { 50, 1 },
                        yellowacard = { 50, 1 },
                        mythic1 = { 1, 1 },
                        wolfram = 95
                    }
                },
                [97] = {
                    blackMoney = 5560000,
                    items = {
                        redacard = { 50, 1 },
                        orangeacard = { 50, 1 },
                        yellowacard = { 50, 1 },
                        mythic1 = { 1, 1 },
                        wolfram = 92
                    }
                },
                [96] = {
                    blackMoney = 5400000,
                    items = {
                        redacard = { 50, 1 },
                        orangeacard = { 50, 1 },
                        yellowacard = { 50, 1 },
                        mythic1 = { 1, 1 },
                        wolfram = 90
                    }
                }
            },
            [2] = {
                [100] = {
                    blackMoney = 3000000,
                    weapons = {
                        WEAPON_BULLPUPRIFLE = 8,
                    },
                    items = {
                        redacard = { 50, 1 },
                        orangeacard = { 50, 1 },
                        yellowacard = { 50, 1 },
                        mythic1 = { 1, 1 },
                        wolfram = 50
                    }
                },
                [99] = {
                    blackMoney = 2860000,
                    weapons = {
                        WEAPON_BULLPUPRIFLE = 8,
                    },
                    items = {
                        redacard = { 50, 1 },
                        orangeacard = { 50, 1 },
                        yellowacard = { 50, 1 },
                        mythic1 = { 1, 1 },
                        wolfram = 47
                    }
                },
                [98] = {
                    blackMoney = 2700000,
                    weapons = {
                        WEAPON_BULLPUPRIFLE = 8,
                    },
                    items = {
                        redacard = { 50, 1 },
                        orangeacard = { 50, 1 },
                        yellowacard = { 50, 1 },
                        mythic1 = { 1, 1 },
                        wolfram = 45
                    }
                },
                [97] = {
                    blackMoney = 2560000,
                    weapons = {
                        WEAPON_BULLPUPRIFLE = 8,
                    },
                    items = {
                        redacard = { 50, 1 },
                        orangeacard = { 50, 1 },
                        yellowacard = { 50, 1 },
                        mythic1 = { 1, 1 },
                        wolfram = 42
                    }
                },
                [96] = {
                    blackMoney = 2400000,
                    weapons = {
                        WEAPON_BULLPUPRIFLE = 8,
                    },
                    items = {
                        redacard = { 50, 1 },
                        orangeacard = { 50, 1 },
                        yellowacard = { 50, 1 },
                        mythic1 = { 1, 1 },
                        wolfram = 40
                    }
                }
            },
        },
        tokenXP = {
            xp = 0,
            token = {
                xp = 180, xp2 = 235, cooldown = 30 * 60,
                skill = 'cargo_skill', addSkill = {'cargo_skill', 'use_token_cargo'},
                quest = 'use_token_cargo', questKey  = 'success_cargo', searchQuest = 'search_token_cargo',
                skill2 = 'mt_skill', addSkill2 = {'mt_skill', 'search_token_cargo'}
            }
        }
    },
    rewardNotEnough = {
        police = 5, type = 2, coords = vec(-1170.01, 4926.32, 224.37, 260.78),
        data = {
            items = {
                redacard = { 50, 1 },
                orangeacard = { 50, 1 },
                yellowacard = { 50, 1 },
                raspberry = 2
            }
        }
    },
    vehicles = {
        spawner = {
            {
                models = {
                    { label = 'Maverick', model = 'polmav', livery = 5, limit = 2 },
                    { label = 'Buzzard', model = 'buzzp', livery = 5, limit = 2 },
                    { label = 'Frog', model = 'newsfrog', livery = 4, limit = 2 },
                    { label = 'Riot', model = 'riot', livery = 0, limit = 4 }

                },
                coords = {
                    { spawner = vec(-468.89, 6007.11, 31.49),   spawnPoint = vec(-475.37, 5988.73, 31.34, 220.97)   },
                    { spawner = vec(-1032.29, 4986.85, 195.34), spawnPoint = vec(-1043.98, 4995.36, 192.39, 193.01) },
                },
                access = 'police'
            },
            {
                models = {
                    { label = 'Camper',      model = 'camper',   limit = 2 },
                    { label = 'Hummer',      model = 'hummer',   limit = 2 },
                    { label = 'Van',         model = 'gburrito', limit = 2 },
                    { label = 'Brickade',    model = 'brickade', limit = 2 },
                    { label = 'Guardian',    model = 'guardian', limit = 2 },
                    { label = 'NissanTitan', model = 'n17',      limit = 2 },
                },
                coords = {
                    { spawner = vec(-1092.51, 4904.35, 214.81), spawnPoint = vec(-1091.04, 4912.86, 214.92, 250.18) }
                },
                access = 'robbers'
            },
        },
        deleter = { vec(-1043.97, 4995.36, 192.39), vec(-475.37, 5988.73, 31.34), vec(-1091.09, 4912.84, 214.93) },
        max = { police = 5 , robbers = 4 }, list = {}, list2 = {}
    },
    policeSalary = {
        max = 9,
        amount = {
            police  = {
                [1]  = 80000,
                [2]  = 80000,
                [3]  = 80000,
                [4]  = 80000,
                [5]  = 80000,
                [6]  = 80000,
                [7]  = 80000,
                [8]  = 80000,
                [9]  = 80000,
                [10] = 80000,
                ['11:30'] = 5000,
            },
            mt  = {
                [1]  = 80000,
                [2]  = 81000,
                [3]  = 82000,
                [4]  = 83000,
                [5]  = 84000,
                [6]  = 85000,
                [7]  = 86000,
                [8]  = 87000,
                [9]  = 88000,
                [10] = 89000,
                [11] = 90000,
                [12] = 90000,
                [13] = 90000,
                ['14:30'] = 5000,
            }
        }
    }
}

config.rob.airPort = {
    lotteryId = 1,
    fox = true,
    readyCheck = { police = 7, robbers = 7, time = 15000 },
    label = 'AirPort',
    successTime = 350,
    rangeCheck = { coords = vec(-1037.36, -2736.51, 20.17, 200) },
    startCheck = {
        pointNeed = 7,
        robberNeed = 7,
        militaryNeed = { count = 8, jobs = { 'all' } }
    },
    join = {
        positions = {
            { coords = vec(-1050.07, -2758.97, 21.38),  robber = true,  canExit = false },
            { coords = vec(-1026.74, -2743.82, 20.17),  robber = false, canExit = true  }
        }
    },
    steps = {
        { module = 'simple1', label = 'Start', coords = vec(-1048.77, -2756.6, 21.38), data = { passTime = 30 * 1000 } },
        {
            module = 'hack', label = 'Hack', ignoreFail = true, failPercentRemove = 1, coords = vec(-1057.61, -2767.01, 21.38),
            data = { type = 'var', block = 5, time = 10}, -- var_simulation
            itemNeed = { raspberry = 1, redacard = 1 }
        },
        {
            module = 'hack', label = 'Hack', ignoreFail = true, failPercentRemove = 1, coords = vec(-1053.34, -2769.36, 21.38),
            data = { type = 'thermite', block = 7, time = 15, fail = 3 }, -- thermite
            itemNeed = { raspberry = 1, orangeacard = 1 }
        },
        {
            module = 'hack', label = 'Hack', ignoreFail = true, failPercentRemove = 1, coords = vec(-1055.51, -2768.25, 21.38),
            data = { type = 'scrambler', type2 = 'alphanumeric', time = 45, mirrored = 0 }, -- Device Minigame
            itemNeed = { raspberry = 1, yellowacard = 1 }
        },
        { module = 'simple1', label = 'Finish', coords = vec(-1058.43, -2766.91, 21.38), data = { passTime = 8 * 60000 }, success = true }
    },
    reward = {
        coords = vec(-1058.11, -2765.25, 25.46, 329.33),
        type = 2,
        data = {
            [1] = {
                [100] = {
                    blackMoney = 5260000,
                    items = {
                        orangeacard = { 50, 1 },
                        yellowacard = { 50, 1 },
                        greenacard = { 50, 1 },
                        mythic1 = { 1, 1 },
                        wolfram = 87
                    }
                },
                [99] = {
                    blackMoney = 5100000,
                    items = {
                        orangeacard = { 50, 1 },
                        yellowacard = { 50, 1 },
                        greenacard = { 50, 1 },
                        mythic1 = { 1, 1 },
                        wolfram = 85
                    }
                },
                [98] = {
                    blackMoney = 4960000,
                    items = {
                        orangeacard = { 50, 1 },
                        yellowacard = { 50, 1 },
                        greenacard = { 50, 1 },
                        mythic1 = { 1, 1 },
                        wolfram = 82
                    }
                },
                [97] = {
                    blackMoney = 4800000,
                    items = {
                        orangeacard = { 50, 1 },
                        yellowacard = { 50, 1 },
                        greenacard = { 50, 1 },
                        mythic1 = { 1, 1 },
                        wolfram = 80
                    }
                }
            }
        },
        tokenXP = {
            xp = 0,
            token = {
                xp = 150, xp2 = 195, cooldown = 30 * 60,
                skill = 'airrob_skill', addSkill = {'airrob_skill', 'use_token_air'},
                quest = 'use_token_air', questKey  = 'success_airrob', searchQuest = 'search_token_air',
                skill2 = 'mt_skill', addSkill2 = {'mt_skill', 'search_token_air'}
            }
        }
    },
    rewardNotEnough = {
        police = 4, type = 2, coords = vec(-1058.11, -2765.25, 25.46, 329.33),
        data = {
            items = {
                orangeacard = { 50, 1 },
                yellowacard = { 50, 1 },
                greenacard = { 50, 1 },
                raspberry = 1
            }
        }
    },
    vehicles = {
        spawner = {
            {
                models = {
                    { label = 'Maverick', model = 'polmav', livery = 5 },
                    { label = 'Buzzard', model = 'buzzp', livery = 5 },
                    { label = 'Frog', model = 'newsfrog', livery = 4 }
                },
                coords = {
                    { spawner = vec(-1025.05, -2693.27, 13.98), spawnPoint = vec(-1035.97, -2702.44, 13.79, 239.2) }
                },
                access = 'police'
            }
        },
        deleter = { vec(-1035.97, -2702.44, 13.79) },
        max = { police = 3 }, list = {}, list2 = {}
    },
    policeSalary = {
        max = 8,
        amount = {
            police  = {
                [1]  = 64000,
                [2]  = 65000,
                [3]  = 66000,
                [4]  = 67000,
                [5]  = 68000,
                [6]  = 69000,
                [7]  = 70000,
                [8]  = 71000,
                [9]  = 72000,
                [10] = 73000,
                ['11:30'] = 5000,
            },
            mt  = {
                [1]  = 66000,
                [2]  = 67000,
                [3]  = 68000,
                [4]  = 69000,
                [5]  = 70000,
                [6]  = 71000,
                [7]  = 72000,
                [8]  = 73000,
                [9]  = 74000,
                [10] = 75000,
                [11] = 76000,
                [12] = 76000,
                [13] = 76000,
                ['14:30'] = 5000,
            }
        }
    }
}

config.rob.benny = {
    lotteryId = 3,
    fox = true,
    readyCheck = { police = 5, robbers = 5, time = 15000 },
    label = 'Benny Mechanic',
    successTime = 350,
    rangeCheck = { coords = vec(-211.35, -1322.57, 30.89, 100) },
    startCheck = {
        pointNeed = 5,
        robberNeed = 5,
        militaryNeed = { count = 6, jobs = { 'all' } }
    },
    join = {
        positions = {
            { coords = vec(-216.73, -1332.0, 30.89),  robber = true,  canExit = false },
            { coords = vec(-174.99, -1289.26, 31.3),  robber = false, canExit = true  }
        }
    },
    steps = {
        { module = 'simple1', label = 'Start', coords = vec(-216.37, -1318.76, 30.89), data = { passTime = 30 * 1000 } },
        {
            module = 'hack', label = 'Hack', ignoreFail = true, failPercentRemove = 1, coords = vec(-227.83, -1327.72, 30.89),
            data = { type = 'var', block = 5, time = 10}, -- var_simulation
            itemNeed = { raspberry = 1, redacard = 1 }
        },
        {
            module = 'hack', label = 'Hack', ignoreFail = true, failPercentRemove = 1, coords = vec(-218.65, -1332.46, 30.89),
            data = { type = 'thermite', block = 7, time = 15, fail = 3 }, -- thermite
            itemNeed = { raspberry = 1, orangeacard = 1 }
        },
        { module = 'simple1', label = 'Finish', coords = vec(-200.74, -1318.47, 31.09), data = { passTime = 8 * 60000 }, success = true }
    },
    reward = {
        coords = vec(-228.74, -1328.27, 31.89, 271.2),
        type = 2,
        data = {
            [1] = {
                [100] = {
                    blackMoney = 3760000,
                    items = {
                        pich = 5,
                        lockpick = { 200, 1 },
                        engine6 = { 200, 1 },
                        redacard = { 50, 1 },
                        orangeacard = { 50, 1 },
                        yellowacard = { 50, 1 },
                        mythic1 = { 1, 1 },
                        wolfram = 62
                    }
                },
                [99] = {
                    blackMoney = 3600000,
                    items = {
                        pich = 4,
                        lockpick = { 50, 1 },
                        engine6 = { 50, 1 },
                        redacard = { 50, 1 },
                        orangeacard = { 50, 1 },
                        yellowacard = { 50, 1 },
                        mythic1 = { 1, 1 },
                        wolfram = 60
                    }
                },
                [98] = {
                    blackMoney = 3460000,
                    items = {
                        pich = 3,
                        lockpick = { 10, 1 },
                        engine6 = { 10, 1 },
                        redacard = { 50, 1 },
                        orangeacard = { 50, 1 },
                        yellowacard = { 50, 1 },
                        mythic1 = { 1, 1 },
                        wolfram = 57
                    }
                },
            }
        },
        tokenXP = {
            xp = 0,
            token = {
                xp = 100, xp2 = 130, cooldown = 30 * 60,
                skill = 'benny_skill', addSkill = {'benny_skill', 'use_token_benny'},
                quest = 'use_token_benny', questKey  = 'success_benny', searchQuest = 'search_token_benny',
                skill2 = 'mt_skill', addSkill2 = {'mt_skill', 'search_token_benny'}
            }
        }
    },
    rewardNotEnough = {
        police = 3, type = 2, vec(-228.74, -1328.27, 31.89, 271.2),
        data = {
            items = {
                redacard = { 50, 1 },
                orangeacard = { 50, 1 },
                yellowacard = { 50, 1 },
                raspberry = 1
            }
        }
    },
    vehicles = {
        spawner = {
            {
                models = {
                    { label = 'Maverick', model = 'polmav',   livery = 5 },
                    { label = 'Buzzard',  model = 'buzzp',    livery = 5 },
                    { label = 'Frog',     model = 'newsfrog', livery = 4 }
                },
                coords = {
                    { spawner = vec(-192.52, -1292.56, 31.3), spawnPoint = vec(-183.49, -1299.19, 31.3, 182.33) }
                },
                access = 'police'
            }
        },
        deleter = { vec(-183.49, -1299.19, 31.3) },
        max = { police = 2 }, list = {}, list2 = {}
    },
    policeSalary = {
        max = 6,
        amount = {
            police  = {
                [1]  = 64000,
                [2]  = 65000,
                [3]  = 66000,
                [4]  = 67000,
                [5]  = 68000,
                [6]  = 69000,
                [7]  = 70000,
                [8]  = 71000,
                [9]  = 72000,
                [10] = 73000,
                ['11:30'] = 5000,
            },
            mt  = {
                [1]  = 66000,
                [2]  = 67000,
                [3]  = 68000,
                [4]  = 69000,
                [5]  = 70000,
                [6]  = 71000,
                [7]  = 72000,
                [8]  = 73000,
                [9]  = 74000,
                [10] = 75000,
                [11] = 76000,
                [12] = 76000,
                [13] = 76000,
                ['14:30'] = 5000,
            }
        }
    }
}

config.rob.gunshop = {
    lotteryId = 4,
    fox = true,
    readyCheck = { police = 3, robbers = 3, time = 15000 },
    label = 'GunShop',
    successTime = 350,
    rangeCheck = { coords = vec(814.38, -2139.66, 29.29, 50) },
    startCheck = {
        pointNeed = 3,
        robberNeed = 3,
        militaryNeed = { count = 3, jobs = { 'all' } }
    },
    join = {
        positions = {
            { coords = vec(826.73, -2160.13, 29.62),  robber = true,  canExit = false },
            { coords = vec(804.84, -2135.56, 29.41),  robber = false, canExit = true  }
        }
    },
    steps = {
        { module = 'simple1', label = 'Start', coords = vec(827.03, -2155.76, 29.62), data = { passTime = 30 * 1000 } },
        {
            module = 'hack', label = 'Hack', ignoreFail = true, failPercentRemove = 1, coords = vec(825.57, -2149.99, 29.62),
            data = { type = 'var', block = 5, time = 10}, -- var_simulation
            itemNeed = { raspberry = 1, redacard = 1 }
        },
        { module = 'simple1', label = 'Finish', coords = vec(809.61, -2157.7, 29.62), data = { passTime = 5 * 60000 }, success = true }
    },
    reward = {
        coords = vec(812.79, -2158.43, 30.61, 359.44),
        type = 2,
        data = {
            [1] = {
                [100] = {
                    blackMoney = 380000,
                    items = {
                        orangeacard = { 50, 1 },
                        yellowacard = { 50, 1 },
                        mythic1 = { 1, 1 },
                        wolfram = 6
                    }
                },
                [99] = {
                    blackMoney = 300000,
                    items = {
                        orangeacard = { 50, 1 },
                        yellowacard = { 50, 1 },
                        mythic1 = { 1, 1 },
                        wolfram = 5
                    }
                },
            },
            [2] = {
                [100] = {
                    blackMoney = 190000,
                    weapons = {
                        WEAPON_PISTOL = 3,
                    },
                    items = {
                        orangeacard = { 50, 1 },
                        yellowacard = { 50, 1 },
                        mythic1 = { 1, 1 },
                        wolfram = 3
                    }
                },
                [99] = {
                    blackMoney = 130000,
                    weapons = {
                        WEAPON_PISTOL = 3,
                    },
                    items = {
                        orangeacard = { 50, 1 },
                        yellowacard = { 50, 1 },
                        mythic1 = { 1, 1 },
                        wolfram = 1
                    }
                },
            },
        },
        tokenXP = {
            xp = 10,
            token = {
                xp = 25, xp2 = 33, cooldown = 30 * 60,
                skill = 'gunshop_skill', addSkill = {'gunshop_skill', 'use_token_gunshop'},
                quest = 'use_token_gunshop', questKey  = 'success_gunshop', searchQuest = 'search_token_gunshop',
                skill2 = 'police_skill', addSkill2 = {'police_skill', 'search_token_gunshop'}
            }
        }
    },
    rewardNotEnough = {
        police = 1, type = 2, vec(812.79, -2158.43, 30.61, 359.44),
        data = {
            items = {
                orangeacard = { 50, 1 },
                yellowacard = { 50, 1 },
                raspberry = 1
            }
        }
    },
    policeSalary = {
        max = 3,
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
            mt  = {
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
                [11] = 26000,
                [12] = 26000,
                [13] = 26000,
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
}

config.rob.mythic = { -- disabled
    lotteryId = 5,
    fox = true,
    -- readyCheck = { police = 10, robbers = 10, time = 15000 },
    mythic = true,
    disabled = true,
    trinket = {
        [1] = { [1] = true },
        -- [2] = { [1] = true, [2] = true },
        -- [3] = { [1] = true, [2] = true, [3] = true }
    },
    trinketsPerk = {
        [1] = {
            robbers = {
                disableheadbox = true, armor = 100
            },
            police = {
                disableheadbox = true, armor = 140
            }
        },
        -- [2] = {
        --     robbers = {
        --         disableheadbox = true, armor = 200
        --     },
        --     police = {
        --         disableheadbox = true, armor = 280
        --     }
        -- },
        -- [3] = {
        --     robbers = {
        --         disableheadbox = true, armor = 300
        --     },
        --     police = {
        --         disableheadbox = true, armor = 400
        --     }
        -- }
    },
    label = 'Mythic robbery',
    successTime = 300,
    rangeCheck = { coords = vec(2418.31, 4969.32, 46.13, 250) },
    startCheck = {
        pointNeed = 10,
        robberNeed = 11,
        militaryNeed = {
            count = 11,
            jobs = {
                'all'
            }
        }
    },
    join = {
        positions = {
            { coords = vec(2443.38, 4968.87, 46.81),  robber = true,  canExit = false },
            { coords = vec(1839.79, 3688.48, 33.97),  robber = false, canExit = true  },
            { coords = vec(2356.34, 4925.6, 42.41),   robber = false, canExit = true  }
        }
    },
    steps = {
        {
            module = 'simple1', label = 'Start', coords = vec(2416.27, 4993.8, 46.23),
            data = { passTime = 30 * 1000 }
        },
        {
            module = 'hack', label = 'Hack', ignoreFail = true, failPercentRemove = 1, coords = vec(2432.06, 4967.6, 46.82),
            data = { type = 'var', block = 5, time = 10}, -- var_simulation
            itemNeed = { raspberry = 1, redacard = 1 }
        },
        {
            module = 'hack', label = 'Hack', ignoreFail = true, failPercentRemove = 1, coords = vec(2449.67, 4980.87, 46.81),
            data = { type = 'thermite', block = 7, time = 15, fail = 3 }, -- thermite
            itemNeed = { raspberry = 1, redacard = 1 }
        },
        {
            module = 'hack', label = 'Hack', ignoreFail = true, failPercentRemove = 1, coords = vec(2452.91, 4983.81, 46.81),
            data = { type = 'maze', time = 120 }, -- casino_generators
            itemNeed = { raspberry = 1, redacard = 1 }
        },
        {
            module = 'hack', label = 'Hack', ignoreFail = true, failPercentRemove = 1, coords = vec(2433.05, 4960.6, 46.82),
            data = { -- Device Minigame
                type = 'scrambler', type2 = 'numeric',-- Type (alphabet, numeric, alphanumeric, greek, braille, runes)
                time = 60, mirrored = 0, --(0: Normal, 1: Normal + Mirrored 2: Mirrored only )
            },
            itemNeed = { raspberry = 1, orangeacard = 1 }
        },
        {
            module = 'simple1', label = 'Finish', coords = vec(2441.08, 4962.29, 46.81),
            data = { passTime = 20 * 60000 }, success = true
        }
    },
    reward = {
        coords = vec(2436.9, 4958.13, 46.81, 141.57),
        type = 2,
        data = {
            [1] = { -- mythic 1
                [100] = {
                    weapons = {
                        WEAPON_CARBINERIFLE = 1,
                        WEAPON_ADVANCEDRIFLE = 1,
                        WEAPON_PUMPSHOTGUN_MK2 = 1,
                        WEAPON_CARBINERIFLE_MK2 = 1,
                        WEAPON_BULLPUPRIFLE = 1,
                        WEAPON_ASSAULTSHOTGUN = 1,
                        WEAPON_SPECIALCARBINE = 1,
                        WEAPON_BULLPUPRIFLE_MK2 = 1,
                        WEAPON_PUMPSHOTGUN = 1,
                        WEAPON_BULLPUPSHOTGUN = 1,
                        WEAPON_COMPACTRIFLE = 1,
                        WEAPON_COMBATPDW = 1,
                        WEAPON_GUSENBERG = 1,
                        WEAPON_SAWNOFFSHOTGUN = 1
                    },
                    items = {
                        redacard = 3,
                        orangeacard = 2,
                        yellowacard = { 500, 2 },
                        greenacard = { 500, 2 },
                        blueacard = { 500, 2 },
                        purpleacard = { 500, 2 },
                        mythic2 = 1
                    }
                },
                [90] = {
                    weapons = {
                        WEAPON_CARBINERIFLE = 1,
                        WEAPON_ADVANCEDRIFLE = 1,
                        WEAPON_PUMPSHOTGUN_MK2 = 1,
                        WEAPON_CARBINERIFLE_MK2 = 1,
                        WEAPON_BULLPUPRIFLE = 1,
                        WEAPON_ASSAULTSHOTGUN = 1,
                        WEAPON_SPECIALCARBINE = 1,
                        WEAPON_BULLPUPRIFLE_MK2 = 1,
                        WEAPON_PUMPSHOTGUN = 1,
                        WEAPON_BULLPUPSHOTGUN = 1,
                        WEAPON_COMPACTRIFLE = 1,
                        WEAPON_COMBATPDW = 1,
                        WEAPON_GUSENBERG = 1
                    },
                    items = {
                        redacard = 3,
                        orangeacard = 2,
                        yellowacard = { 500, 2 },
                        greenacard = { 500, 2 },
                        blueacard = { 500, 2 },
                        purpleacard = { 500, 2 },
                        mythic2 = 1
                    }
                },
                [80] = {
                    weapons = {
                        WEAPON_CARBINERIFLE = 1,
                        WEAPON_ADVANCEDRIFLE = 1,
                        WEAPON_PUMPSHOTGUN_MK2 = 1,
                        WEAPON_CARBINERIFLE_MK2 = 1,
                        WEAPON_BULLPUPRIFLE = 1,
                        WEAPON_ASSAULTSHOTGUN = 1,
                        WEAPON_SPECIALCARBINE = 1,
                        WEAPON_BULLPUPRIFLE_MK2 = 1,
                        WEAPON_PUMPSHOTGUN = 1,
                        WEAPON_BULLPUPSHOTGUN = 1,
                        WEAPON_COMPACTRIFLE = 1,
                        WEAPON_COMBATPDW = 1
                    },
                    items = {
                        redacard = 3,
                        orangeacard = 2,
                        yellowacard = { 500, 2 },
                        greenacard = { 500, 2 },
                        blueacard = { 500, 2 },
                        purpleacard = { 500, 2 },
                        mythic2 = 1
                    }
                },
                [70] = {
                    weapons = {
                        WEAPON_CARBINERIFLE = 1,
                        WEAPON_ADVANCEDRIFLE = 1,
                        WEAPON_PUMPSHOTGUN_MK2 = 1,
                        WEAPON_CARBINERIFLE_MK2 = 1,
                        WEAPON_BULLPUPRIFLE = 1,
                        WEAPON_ASSAULTSHOTGUN = 1,
                        WEAPON_SPECIALCARBINE = 1,
                        WEAPON_BULLPUPRIFLE_MK2 = 1,
                        WEAPON_PUMPSHOTGUN = 1,
                        WEAPON_BULLPUPSHOTGUN = 1,
                        WEAPON_COMPACTRIFLE = 1
                    },
                    items = {
                        redacard = 3,
                        orangeacard = 2,
                        yellowacard = { 500, 2 },
                        greenacard = { 500, 2 },
                        blueacard = { 500, 2 },
                        purpleacard = { 500, 2 },
                        mythic2 = 1
                    }
                },
                [60] = {
                    weapons = {
                        WEAPON_CARBINERIFLE = 1,
                        WEAPON_ADVANCEDRIFLE = 1,
                        WEAPON_PUMPSHOTGUN_MK2 = 1,
                        WEAPON_CARBINERIFLE_MK2 = 1,
                        WEAPON_BULLPUPRIFLE = 1,
                        WEAPON_ASSAULTSHOTGUN = 1,
                        WEAPON_SPECIALCARBINE = 1,
                        WEAPON_BULLPUPRIFLE_MK2 = 1,
                        WEAPON_PUMPSHOTGUN = 1,
                        WEAPON_BULLPUPSHOTGUN = 1
                    },
                    items = {
                        redacard = 3,
                        orangeacard = 2,
                        yellowacard = { 500, 2 },
                        greenacard = { 500, 2 },
                        blueacard = { 500, 2 },
                        purpleacard = { 500, 2 },
                        mythic2 = 1
                    }
                },
            },
            -- [2] = { -- mythic 2
            --     [100] = {
            --         weapons = {
            --             WEAPON_CARBINERIFLE = 2,
            --             WEAPON_ADVANCEDRIFLE = 1,
            --             WEAPON_PUMPSHOTGUN_MK2 = 1,
            --             WEAPON_CARBINERIFLE_MK2 = 1,
            --             WEAPON_MICROSMG = 1,
            --             WEAPON_DOUBLEACTION = 1,
            --             WEAPON_BULLPUPRIFLE = 2,
            --             WEAPON_ASSAULTSHOTGUN = 2,
            --             WEAPON_SPECIALCARBINE = 2,
            --             WEAPON_BULLPUPRIFLE_MK2 = 1,
            --             WEAPON_PUMPSHOTGUN = 12,
            --             WEAPON_SPECIALCARBINE_MK2 = 1,
            --             WEAPON_BULLPUPSHOTGUN = 2,
            --             WEAPON_COMPACTRIFLE = 2,
            --             WEAPON_COMBATPDW = 2,
            --             WEAPON_ASSAULTRIFLE_MK2 = 2,
            --             WEAPON_GUSENBERG = 2,
            --             WEAPON_SAWNOFFSHOTGUN = 2
            --         },
            --         items = {
            --             redacard = 3,
            --             orangeacard = 2,
            --             yellowacard = { 500, 2 },
            --             greenacard = { 500, 2 },
            --             blueacard = { 500, 2 },
            --             purpleacard = { 500, 2 },
            --             mythic3 = 1
            --         }
            --     },
            --     [90] = {
            --         weapons = {
            --             WEAPON_CARBINERIFLE = 2,
            --             WEAPON_ADVANCEDRIFLE = 1,
            --             WEAPON_PUMPSHOTGUN_MK2 = 1,
            --             WEAPON_CARBINERIFLE_MK2 = 1,
            --             WEAPON_MICROSMG = 1,
            --             WEAPON_DOUBLEACTION = 1,
            --             WEAPON_BULLPUPRIFLE = 2,
            --             WEAPON_ASSAULTSHOTGUN = 2,
            --             WEAPON_SPECIALCARBINE = 2,
            --             WEAPON_BULLPUPRIFLE_MK2 = 1,
            --             WEAPON_PUMPSHOTGUN = 12,
            --             WEAPON_SPECIALCARBINE_MK2 = 1,
            --             WEAPON_BULLPUPSHOTGUN = 2,
            --             WEAPON_COMPACTRIFLE = 2,
            --             WEAPON_COMBATPDW = 2,
            --             WEAPON_ASSAULTRIFLE_MK2 = 2,
            --             WEAPON_GUSENBERG = 2,
            --             WEAPON_SAWNOFFSHOTGUN = 2
            --         },
            --         items = {
            --             redacard = 3,
            --             orangeacard = 2,
            --             yellowacard = { 500, 2 },
            --             greenacard = { 500, 2 },
            --             blueacard = { 500, 2 },
            --             purpleacard = { 500, 2 },
            --             mythic3 = 1
            --         }
            --     },
            --     [80] = {
            --         weapons = {
            --             WEAPON_CARBINERIFLE = 1,
            --             WEAPON_ADVANCEDRIFLE = 1,
            --             WEAPON_PUMPSHOTGUN_MK2 = 1,
            --             WEAPON_CARBINERIFLE_MK2 = 1,
            --             WEAPON_MICROSMG = 1,
            --             WEAPON_DOUBLEACTION = 1,
            --             WEAPON_BULLPUPRIFLE = 2,
            --             WEAPON_ASSAULTSHOTGUN = 2,
            --             WEAPON_SPECIALCARBINE = 2,
            --             WEAPON_BULLPUPRIFLE_MK2 = 1,
            --             WEAPON_PUMPSHOTGUN = 12,
            --             WEAPON_SPECIALCARBINE_MK2 = 1,
            --             WEAPON_BULLPUPSHOTGUN = 2,
            --             WEAPON_COMPACTRIFLE = 2,
            --             WEAPON_COMBATPDW = 2,
            --             WEAPON_ASSAULTRIFLE_MK2 = 2,
            --             WEAPON_GUSENBERG = 2,
            --             WEAPON_SAWNOFFSHOTGUN = 2
            --         },
            --         items = {
            --             redacard = 3,
            --             orangeacard = 2,
            --             yellowacard = { 500, 2 },
            --             greenacard = { 500, 2 },
            --             blueacard = { 500, 2 },
            --             purpleacard = { 500, 2 },
            --             mythic3 = 1
            --         }
            --     },
            --     [70] = {
            --         weapons = {
            --             WEAPON_CARBINERIFLE = 1,
            --             WEAPON_ADVANCEDRIFLE = 1,
            --             WEAPON_PUMPSHOTGUN_MK2 = 1,
            --             WEAPON_CARBINERIFLE_MK2 = 1,
            --             WEAPON_MICROSMG = 1,
            --             WEAPON_DOUBLEACTION = 1,
            --             WEAPON_BULLPUPRIFLE = 1,
            --             WEAPON_ASSAULTSHOTGUN = 2,
            --             WEAPON_SPECIALCARBINE = 2,
            --             WEAPON_BULLPUPRIFLE_MK2 = 1,
            --             WEAPON_PUMPSHOTGUN = 12,
            --             WEAPON_SPECIALCARBINE_MK2 = 1,
            --             WEAPON_BULLPUPSHOTGUN = 2,
            --             WEAPON_COMPACTRIFLE = 2,
            --             WEAPON_COMBATPDW = 2,
            --             WEAPON_ASSAULTRIFLE_MK2 = 2,
            --             WEAPON_GUSENBERG = 2,
            --             WEAPON_SAWNOFFSHOTGUN = 2
            --         },
            --         items = {
            --             redacard = 3,
            --             orangeacard = 2,
            --             yellowacard = { 500, 2 },
            --             greenacard = { 500, 2 },
            --             blueacard = { 500, 2 },
            --             purpleacard = { 500, 2 },
            --             mythic3 = 1
            --         }
            --     },
            --     [60] = {
            --         weapons = {
            --             WEAPON_CARBINERIFLE = 1,
            --             WEAPON_ADVANCEDRIFLE = 1,
            --             WEAPON_PUMPSHOTGUN_MK2 = 1,
            --             WEAPON_CARBINERIFLE_MK2 = 1,
            --             WEAPON_MICROSMG = 1,
            --             WEAPON_DOUBLEACTION = 1,
            --             WEAPON_BULLPUPRIFLE = 1,
            --             WEAPON_ASSAULTSHOTGUN = 1,
            --             WEAPON_SPECIALCARBINE = 2,
            --             WEAPON_BULLPUPRIFLE_MK2 = 1,
            --             WEAPON_PUMPSHOTGUN = 12,
            --             WEAPON_SPECIALCARBINE_MK2 = 1,
            --             WEAPON_BULLPUPSHOTGUN = 2,
            --             WEAPON_COMPACTRIFLE = 2,
            --             WEAPON_COMBATPDW = 2,
            --             WEAPON_ASSAULTRIFLE_MK2 = 2,
            --             WEAPON_GUSENBERG = 2,
            --             WEAPON_SAWNOFFSHOTGUN = 2
            --         },
            --         items = {
            --             redacard = 3,
            --             orangeacard = 2,
            --             yellowacard = { 500, 2 },
            --             greenacard = { 500, 2 },
            --             blueacard = { 500, 2 },
            --             purpleacard = { 500, 2 },
            --             mythic3 = 1
            --         }
            --     }
            -- },
            -- [3] = { -- mythic 3
            --     [100] = {
            --         weapons = {
            --             WEAPON_CARBINERIFLE = 3,
            --             WEAPON_ADVANCEDRIFLE = 3,
            --             WEAPON_PUMPSHOTGUN_MK2 = 2,
            --             WEAPON_CARBINERIFLE_MK2 = 2,
            --             WEAPON_MICROSMG = 2,
            --             WEAPON_DOUBLEACTION = 1,
            --             WEAPON_BULLPUPRIFLE = 3,
            --             WEAPON_ASSAULTSHOTGUN = 3,
            --             WEAPON_SPECIALCARBINE = 3,
            --             WEAPON_BULLPUPRIFLE_MK2 = 2,
            --             WEAPON_PUMPSHOTGUN = 3,
            --             WEAPON_SPECIALCARBINE_MK2 = 2,
            --             WEAPON_BULLPUPSHOTGUN = 3,
            --             WEAPON_COMPACTRIFLE = 2,
            --             WEAPON_COMBATPDW = 3,
            --             WEAPON_ASSAULTRIFLE_MK2 = 2,
            --             WEAPON_GUSENBERG = 3,
            --             WEAPON_SAWNOFFSHOTGUN = 3
            --         },
            --         items = {
            --             redacard = 3,
            --             orangeacard = 2,
            --             yellowacard = { 500, 2 },
            --             greenacard = { 500, 2 },
            --             blueacard = { 500, 2 },
            --             purpleacard = { 500, 2 }
            --         }
            --     },
            --     [90] = {
            --         weapons = {
            --             WEAPON_CARBINERIFLE = 2,
            --             WEAPON_ADVANCEDRIFLE = 3,
            --             WEAPON_PUMPSHOTGUN_MK2 = 2,
            --             WEAPON_CARBINERIFLE_MK2 = 2,
            --             WEAPON_MICROSMG = 2,
            --             WEAPON_DOUBLEACTION = 1,
            --             WEAPON_BULLPUPRIFLE = 3,
            --             WEAPON_ASSAULTSHOTGUN = 3,
            --             WEAPON_SPECIALCARBINE = 3,
            --             WEAPON_BULLPUPRIFLE_MK2 = 2,
            --             WEAPON_PUMPSHOTGUN = 3,
            --             WEAPON_SPECIALCARBINE_MK2 = 2,
            --             WEAPON_BULLPUPSHOTGUN = 3,
            --             WEAPON_COMPACTRIFLE = 2,
            --             WEAPON_COMBATPDW = 3,
            --             WEAPON_ASSAULTRIFLE_MK2 = 2,
            --             WEAPON_GUSENBERG = 3,
            --             WEAPON_SAWNOFFSHOTGUN = 3
            --         },
            --         items = {
            --             redacard = 3,
            --             orangeacard = 2,
            --             yellowacard = { 500, 2 },
            --             greenacard = { 500, 2 },
            --             blueacard = { 500, 2 },
            --             purpleacard = { 500, 2 }
            --         }
            --     },
            --     [80] = {
            --         weapons = {
            --             WEAPON_CARBINERIFLE = 2,
            --             WEAPON_ADVANCEDRIFLE = 2,
            --             WEAPON_PUMPSHOTGUN_MK2 = 2,
            --             WEAPON_CARBINERIFLE_MK2 = 2,
            --             WEAPON_MICROSMG = 2,
            --             WEAPON_DOUBLEACTION = 1,
            --             WEAPON_BULLPUPRIFLE = 3,
            --             WEAPON_ASSAULTSHOTGUN = 3,
            --             WEAPON_SPECIALCARBINE = 3,
            --             WEAPON_BULLPUPRIFLE_MK2 = 2,
            --             WEAPON_PUMPSHOTGUN = 3,
            --             WEAPON_SPECIALCARBINE_MK2 = 2,
            --             WEAPON_BULLPUPSHOTGUN = 3,
            --             WEAPON_COMPACTRIFLE = 2,
            --             WEAPON_COMBATPDW = 3,
            --             WEAPON_ASSAULTRIFLE_MK2 = 2,
            --             WEAPON_GUSENBERG = 3,
            --             WEAPON_SAWNOFFSHOTGUN = 3
            --         },
            --         items = {
            --             redacard = 3,
            --             orangeacard = 2,
            --             yellowacard = { 500, 2 },
            --             greenacard = { 500, 2 },
            --             blueacard = { 500, 2 },
            --             purpleacard = { 500, 2 }
            --         }
            --     },
            --     [70] = {
            --         weapons = {
            --             WEAPON_CARBINERIFLE = 2,
            --             WEAPON_ADVANCEDRIFLE = 2,
            --             WEAPON_PUMPSHOTGUN_MK2 = 2,
            --             WEAPON_CARBINERIFLE_MK2 = 2,
            --             WEAPON_MICROSMG = 2,
            --             WEAPON_DOUBLEACTION = 1,
            --             WEAPON_BULLPUPRIFLE = 2,
            --             WEAPON_ASSAULTSHOTGUN = 3,
            --             WEAPON_SPECIALCARBINE = 3,
            --             WEAPON_BULLPUPRIFLE_MK2 = 2,
            --             WEAPON_PUMPSHOTGUN = 3,
            --             WEAPON_SPECIALCARBINE_MK2 = 2,
            --             WEAPON_BULLPUPSHOTGUN = 3,
            --             WEAPON_COMPACTRIFLE = 2,
            --             WEAPON_COMBATPDW = 3,
            --             WEAPON_ASSAULTRIFLE_MK2 = 2,
            --             WEAPON_GUSENBERG = 3,
            --             WEAPON_SAWNOFFSHOTGUN = 3
            --         },
            --         items = {
            --             redacard = 3,
            --             orangeacard = 2,
            --             yellowacard = { 500, 2 },
            --             greenacard = { 500, 2 },
            --             blueacard = { 500, 2 },
            --             purpleacard = { 500, 2 }
            --         }
            --     },
            --     [60] = {
            --         weapons = {
            --             WEAPON_CARBINERIFLE = 2,
            --             WEAPON_ADVANCEDRIFLE = 2,
            --             WEAPON_PUMPSHOTGUN_MK2 = 2,
            --             WEAPON_CARBINERIFLE_MK2 = 2,
            --             WEAPON_MICROSMG = 2,
            --             WEAPON_DOUBLEACTION = 1,
            --             WEAPON_BULLPUPRIFLE = 2,
            --             WEAPON_ASSAULTSHOTGUN = 2,
            --             WEAPON_SPECIALCARBINE = 3,
            --             WEAPON_BULLPUPRIFLE_MK2 = 2,
            --             WEAPON_PUMPSHOTGUN = 3,
            --             WEAPON_SPECIALCARBINE_MK2 = 2,
            --             WEAPON_BULLPUPSHOTGUN = 3,
            --             WEAPON_COMPACTRIFLE = 2,
            --             WEAPON_COMBATPDW = 3,
            --             WEAPON_ASSAULTRIFLE_MK2 = 2,
            --             WEAPON_GUSENBERG = 3,
            --             WEAPON_SAWNOFFSHOTGUN = 3
            --         },
            --         items = {
            --             redacard = 3,
            --             orangeacard = 2,
            --             yellowacard = { 500, 2 },
            --             greenacard = { 500, 2 },
            --             blueacard = { 500, 2 },
            --             purpleacard = { 500, 2 }
            --         }
            --     }
            -- }
        },
        tokenXP = {
            xp = 0,
            token = {
                xp = 180, xp2 = 235, cooldown = 60 * 60,
                skill = 'mythic_skill', addSkill = {'mythic_skill', 'use_token_mythic'},
                quest = 'use_token_mythic', questKey  = 'success_mythic', searchQuest = 'search_token_mythic',
                skill2 = 'mt_skill', addSkill2 = {'mt_skill', 'search_token_mythic'}
            }
        }
    },
    rewardNotEnough = {
        police = 100, type = 2, coords = vec(2436.9, 4958.13, 46.81, 141.57),
        data = {
            blackMoney = 1
        }
    },
    vehicles = {
        spawner = {
            {
                models = {
                    { label = 'Maverick', model = 'polmav', livery = 5, limit = 2 },
                    { label = 'Buzzard', model = 'buzzp', livery = 5, limit = 2 },
                    { label = 'Frog', model = 'newsfrog', livery = 4, limit = 2 },
                    { label = 'riot', model = 'riot', limit = 3 },
                    { label = 'brickade', model = 'brickade', limit = 3 },
                },
                coords = {
                    { spawner = vec(2363.12, 4925.74, 42.41), spawnPoint = vec(2371.32, 4921.3, 42.07, 303.71) }
                },
                access = 'police'
            },
            {
                models = {
                    { label = 'brickade', model = 'brickade', limit = 3 },
                    { label = 'camper', model = 'camper', limit = 5 },
                    { label = 'gburrito2', model = 'gburrito2', limit = 3 },
                    { label = 'guradian', model = 'guradian', limit = 2 },
                    { label = 'n17', model = 'n17', limit = 3 },
                    { label = 'hummer', model = 'hummer', limit = 2 },
                    { label = 'zentorno', model = 'zentorno', limit = 2 },
                    { label = 'Buzzard', model = 'buzzard2', livery = 0, limit = 1 },
                },
                coords = {
                    { spawner = vec(2423.72, 4965.45, 46.14), spawnPoint = vec(2417.89, 4970.53, 46.14, 142.95) }
                },
                access = 'robbers'
            },
        },
        deleter = { vec(2371.32, 4921.3, 42.07), vec(2417.89, 4970.53, 46.14) },
        max = { police = 7 , robbers = 17 }, list = {}, list2 = {}
    },
    policeSalary = {
        max = 10,
        amount = {
            police  = {
                [1]  = 1,
                [2]  = 1,
                [3]  = 1,
                [4]  = 1,
                [5]  = 1,
                [6]  = 1,
                [7]  = 1,
                [8]  = 1,
                [9]  = 1,
                [10] = 1,
                ['11:30'] = 1,
            },
            mt  = {
                [1]  = 1,
                [2]  = 1,
                [3]  = 1,
                [4]  = 1,
                [5]  = 1,
                [6]  = 1,
                [7]  = 1,
                [8]  = 1,
                [9]  = 1,
                [10] = 1,
                [11] = 1,
                [12] = 1,
                ['13:30'] = 1,
            }
        }
    }
}

config.rob.test1 = { -- test
    disabled = true,
    lotteryId = 1,
    label = 'test',
    successTime = 350,
    rangeCheck = { coords = vec(-377.42, 1214.53, 325.76, 50.0) },
    startCheck = {
        pointNeed = 2000,
        robberNeed = 1,
        militaryNeed = { count = 0, jobs = { 'all' } }
    },
    join = {
        positions = {
            { coords = vec(-377.42, 1214.53, 325.76),  robber = true,  canExit = false },
            { coords = vec(-380.35, 1202.86, 325.76),  robber = false, canExit = true  }
        }
    },
    steps = {
        { module = 'simple1', label = 'Start', coords = vec(-386.6, 1222.52, 325.64), data = { passTime = 1 * 1000 } },
        { module = 'simple1', label = 'Finish', coords = vec(-390.86, 1208.18, 325.64), data = { passTime = 1 * 60000 }, success = true }
    },
    reward = {
        coords = vec(-378.03, 1225.98, 325.76, 143.07),
        type = 2,
        data = {
            [1] = {
                [100] = {
                    blackMoney = 1,
                    items = {
                        bread = { 1, 1 }
                    }
                },
            }
        },
        tokenXP = {
            xp = 0,
            token = {
                xp = 1, xp2 = 1, cooldown = 30 * 60,
                skill = 'airrob_skill2', addSkill = {'airrob_skill2', 'use_token_air2'},
                quest = 'use_token_air2', questKey  = 'success_airrob2', searchQuest = 'search_token_air2',
                skill2 = 'mt_skill2', addSkill2 = {'mt_skill2', 'search_token_air2'}
            }
        }
    },
    rewardNotEnough = {
        police = 100, type = 2, coords = vec(-1058.11, -2765.25, 25.46, 329.33),
        data = {
            items = {
                bread = { 1, 1 },
            }
        }
    },
    vehicles = {
        spawner = {
            {
                models = {
                    { label = 'faggio', model = 'faggio' },
                },
                coords = {
                    { spawner = vec(-407.47, 1209.32, 325.67), spawnPoint = vec(-402.78, 1188.71, 325.63, 144.8) }
                },
                access = 'police'
            },
            {
                models = {
                    { label = 'faggio', model = 'faggio' },
                },
                coords = {
                    { spawner = vec(-407.47, 1209.32, 325.67), spawnPoint = vec(-402.78, 1188.71, 325.63, 144.8) }
                },
                access = 'robbers'
            }
        },
        deleter = { vec(-402.78, 1188.71, 325.63) },
        max = { police = 0 , robbers = 0 }, list = {}, list2 = {}
    },
    policeSalary = {
        max = 1,
        amount = {
            police  = {
                ['1:30'] = 1,
            },
        }
    }
}


-- doorId = 3,
-- reward = {
--     type = 2, -- 1 : give to player, -- 2 : box
--     -- data = { -- example type 1
--     --     {
--     --         items = {
--     --             jewels = 500, -- for random {500, 600}
--     --         },
--     --         money = 1000,
--     --         blackMoney = 10000,
--     --     }
--     -- }
--     data = {
--         [1] = {
--             [100] = {
--                 -- items = {
--                 --     jewels = 600, -- for random {500, 600}
--                 -- },
--                 -- weapons = {
--                 --     WEAPON_PISTOL = 5,
--                 -- },
--                 -- money = 1500,
--                 blackMoney = 100000,
--             },
--             [90] = {
--                 blackMoney = 90000,
--             },
--             [80] = {
--                 blackMoney = 80000,
--             },
--             [70] = {
--                 blackMoney = 70000,
--             },
--             [60] = {
--                 blackMoney = 60000,
--             } 
--         }
--     },
-- rewardNotEnough = {
--     police = 1, -- kamtar mosavi az 5
--     type = 2, -- 1 : give to player, -- 2 : box
--     -- data = { -- example type 1
--     --     {
--     --         items = {
--     --             jewels = 500, -- for random {500, 600}
--     --         },
--     --         money = 1000,
--     --         blackMoney = 10000,
--     --     }
--     -- }
--     data = {
--         -- items = {
--         --     jewels = 100, -- for random {500, 600}
--         -- },
--         -- weapons = {
--         --     WEAPON_PISTOL = 1,
--         -- },
--         -- money = 1500,
--         blackMoney = 10000,
--     },
--     coords = vec(264.28, 213.73, 102.53, 70.59)
-- },


-- vehicles = {
--     spawner = {
--         {
--             models = {
--                 { label = 'Polmav', model = 'polmav', livery = 2 }
--             },
--             coords = {
--                 {
--                     spawner = vec(239.85, 194.74, 105.1),
--                     spawnPoint = vec(237.52, 186.39, 105.27, 121.54),
--                 }
--             },
--             access = 'robbers', --robbers
--         }
--     },
--     deleter = {
--         vec(237.48, 185.9, 105.26)
--     },
--     max = {
--         robbers = 5,
--         police = 2,
--     },
--     list = {}, list2 = {}
-- },

-- {
--     module = 'hack', label = 'Hack', ignoreFail = true, failPercentRemove = 1, coords = vec(253.25, 228.41, 101.68),
--     data = { type = 'maze', time = 120 }, -- casino_generators
--     itemNeed = { raspberry = 1, orangeacard = 1 }
-- },