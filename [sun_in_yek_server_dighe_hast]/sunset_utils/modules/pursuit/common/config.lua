-- Pub by FleeX Team , https://discord.gg/87rGBxgCsa

persuitConfig = {
    itemName = 'persuit_1',
    limit = 1,
    deadLine = {
        hack = 5 * 60 * 1000, --10 min forsat dare hack kone
        finish = 10 * 60 * 1000,
    },
    cars = { `stockade` },
    alarm = { 'sheriff' },
    finishCastTime = 10 * 1000,
    policeCheck = { needed = 2, jobs = { 'sheriff' }, range = 150 },
    coords = {
        {
            locations = {
                vec(-1058.14, -511.7, 36.04, 295.71),
                vec(963.81, -1039.66, 40.83),
            },
            reward = {
                { name = 'chests_1', count = {1, 1} }
            },
            reward2 = {
                { name = 'chests_2', count = {1, 1} }
            },
            rewardNotEnough = {
                { name = 'chests_3', count = {1, 1} }
            }
        },
        {
            locations = {
                vec(-1047.43, -2651.7, 13.83, 160.75),
                vec(-58.33, 159.34, 81.35),
            },
            reward = {
                { name = 'chests_1', count = {1, 1} }
            },
            reward2 = {
                { name = 'chests_2', count = {1, 1} }
            },
            rewardNotEnough = {
                { name = 'chests_3', count = {1, 1} }
            }
        },
        {
            locations = {
                vec(880.39, -2194.63, 30.52, 354.94),
                vec(-1139.08, -1255.89, 6.88),
            },
            reward = {
                { name = 'chests_1', count = {1, 1} }
            },
            reward2 = {
                { name = 'chests_2', count = {1, 1} }
            },
            rewardNotEnough = {
                { name = 'chests_3', count = {1, 1} }
            }
        },
        {
            locations = {
                vec(-610.64, -1009.07, 21.78, 92.03),
                vec(769.79, -3194.88, 5.9),
            },
            reward = {
                { name = 'chests_1', count = {1, 1} }
            },
            reward2 = {
                { name = 'chests_2', count = {1, 1} }
            },
            rewardNotEnough = {
                { name = 'chests_3', count = {1, 1} }
            }
        },
        {
            locations = {
                vec(-9.51, -1510.35, 29.94, 235.38),
                vec(-1541.35, -583.14, 33.84),
            },
            reward = {
                { name = 'chests_1', count = {1, 1} }
            },
            reward2 = {
                { name = 'chests_2', count = {1, 1} }
            },
            rewardNotEnough = {
                { name = 'chests_3', count = {1, 1} }
            }
        },
        {
            locations = {
                vec(-358.39, 29.98, 47.79, 74.75),
                vec(-803.47, -2115.51, 8.81),
            },
            reward = {
                { name = 'chests_1', count = {1, 1} }
            },
            reward2 = {
                { name = 'chests_2', count = {1, 1} }
            },
            rewardNotEnough = {
                { name = 'chests_3', count = {1, 1} }
            }
        },
        {
            locations = {
                vec(-830.48, -431.39, 36.64, 111.86),
                vec(1119.78, -480.71, 65.97),
            },
            reward = {
                { name = 'chests_1', count = {1, 1} }
            },
            reward2 = {
                { name = 'chests_2', count = {1, 1} }
            },
            rewardNotEnough = {
                { name = 'chests_3', count = {1, 1} }
            }
        },
    },
    policeSalary = {
        max = 4,
        amount = {
            sheriff  = {
                [1]  = 5000,
                [2]  = 5000,
                [3]  = 5000,
                [4]  = 5000,
                [5]  = 5000,
                [6]  = 5000,
                [7]  = 5000,
                [8]  = 5000,
                [9]  = 5000,
                [10] = 5000,
                ['11:30'] = 5000,
            },
        }
    }
}