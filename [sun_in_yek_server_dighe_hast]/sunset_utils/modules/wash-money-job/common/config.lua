-- Pub by FleeX Team , https://discord.gg/87rGBxgCsa

configWashJob = {
    jobName = 'wash',
    positions = {
        bossAction = {
            coords = {
                vec(966.32, 47.55, 71.7),
                vec(-1555.03, -115.75, 54.52),
            },
            label = 'Boss action',
            cb = function()
                TriggerEvent('esx_society:openbossss', 'wash', function(data, menu)
                    menu.close()
                end, { wash = false })
            end
        },
    },
    wash = {
        miner            = { 50000, 35000 },
        packaged_chicken = { 250,   175   },
        clothe           = { 1667,  1167  },
        essence          = { 250,   175   },
        packaged_plank   = { 1250,  875   },
        husky_body       = { 10000, 7000  },
        retriever_body   = { 10000, 7000  },
        rottweiler_body  = { 10000, 7000  },
        shepherd_body    = { 10000, 7000  },
        panther_body     = { 10000, 7000  },
        boar_body        = { 10000, 7000  },
        pig_body         = { 10000, 7000  },
        rabbit_body      = { 10000, 7000  },
        pigeon_body      = { 10000, 7000  },
        ganj             = { 10000, 7000  },
        scooter          = { 8750,  6125  },
        van              = { 17500, 12250 },
        truck            = { 17500, 12250 },
    }
} 
