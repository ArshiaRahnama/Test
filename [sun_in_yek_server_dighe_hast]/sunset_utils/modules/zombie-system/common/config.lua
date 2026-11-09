-- Pub by FleeX Team , https://discord.gg/87rGBxgCsa

zombieSysConfig = {
    [101] = { -- capture
        id = 101,
        maxZombie = 2, -- tedad zombie haee ke spawn she dar lahze
        spawnCooldown = 60, -- cooldown spawn zombie
        spawnRadius = 40, -- zombie ha to range chand metri spawn shan -- 1-40
        maxRadius = 75, -- zombie ha moghe bishat shodan fasele az in had pak shan
        peds = {
            {
                model = `u_m_y_zombie_01`, -- model zombie ` `
                model2 = 'u_m_y_zombie_01', -- model zombie ' '
                chance = 10, -- chance spawn
                fireChance = 10, -- % spawn ba fire
                bombChance = 0, -- % spawn ba bomb
                speed = {5, 10}, -- run speed 1 ta 10
                damage = {3, 5}, -- damage random az 5, 50
            },
            {
                model = `a_m_m_tranvest_01`,
                model2 = 'a_m_m_tranvest_01',
                chance = 10,
                fireChance = 10,
                bombChance = 1,
                speed = {3, 10},
                damage = {3, 5},
            },
            {
                model = `csb_stripper_02`,
                model2 = 'csb_stripper_02',
                chance = 10,
                fireChance = 10,
                bombChance = 0,
                speed = {3, 10},
                damage = {3, 5},
            },
            {
                model = `mp_f_cocaine_01`,
                model2 = 'mp_f_cocaine_01',
                chance = 10,
                fireChance = 10,
                bombChance = 1,
                speed = {3, 10},
                damage = {3, 5},
            },
            {
                model = `s_f_y_stripper_02`,
                model2 = 's_f_y_stripper_02',
                chance = 10,
                fireChance = 10,
                bombChance = 0,
                speed = {3, 10},
                damage = {3, 5},
            },
            {
                model = `s_f_y_stripperlite`,
                model2 = 's_f_y_stripperlite',
                chance = 10,
                fireChance = 10,
                bombChance = 1,
                speed = {3, 10},
                damage = {3, 5},
            },
            {
                model = `u_f_y_corpse_01`,
                model2 = 'u_f_y_corpse_01',
                chance = 10,
                fireChance = 10,
                bombChance = 0,
                speed = {3, 10},
                damage = {3, 5},
            },
            {
                model = `u_m_y_corpse_01`,
                model2 = 'u_m_y_corpse_01',
                chance = 10,
                fireChance = 10,
                bombChance = 1,
                speed = {3, 10},
                damage = {3, 5},
            },
            {
                model = `a_c_chop`,
                model2 = 'a_c_chop',
                chance = 10,
                fireChance = 10,
                bombChance = 0,
                speed = {1, 5},
                damage = {1, 2},
            },
        }
    }
}

zombieDefaultZone = {
    -- {
    --     coords = vec(2549.89, 3051.1, 43.85, 500.0),
    --     world = 2,
    --     configId = 101,
    -- }
}