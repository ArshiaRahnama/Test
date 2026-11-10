-- Pub by FleeX Team , https://discord.gg/87rGBxgCsa

Config = {}

-- Race States don't touch
Config.RaceStates = {
    NONE = 0,
    RACING  = 1,
}

-- Check point types for creating checkpoints (Highly recommend to don't change)
Config.CheckPoints = {
    Normal = 0,
    Finish = 4,
}

-- Privacy list don't touch
Config.PrivacyList = {
    'Public',
    'Party'
}

-- Highly adviced to don't change because it store them based on index
Config.RaceClasses = {
  'None',
  'Compacts',
  'Sedans',
  'SUVs',
  'Coupes',
  'Muscle',
  'Sports Classics',
  'Sports',
  'Super',
  'Motorcycles',
  'Off-road',
}

-- Min, Max and default values for race settings
Config.DefaultValues = {
    maxPlayers  = {min = 2, max = 10, default = 5},
    fee = {min = 1000, max = 100000, default = 5000},
    title = {min = 4, max = 8, default = 'Race'},
    privacy = {default = Config.PrivacyList[1]}
}

-- Number of max checkpoints player can set for a race
Config.MaxCheckPoints = 300

-- Pre defined routes by server
Config.PreDefinedRoutes = {
    -- Be aware route index define their priority
    {
        title = 'Ghasem Abad',
        path =  {
            vector3(-1486.0, -457.5, 34.625),
            vector3(-1383.25, -391.25, 35.6875),
            vector3(-1235.75, -320.75, 36.40625),
            vector3(-1088.75, -216.25, 36.875)
        }
    },
    {
        title = 'Chalghoz Abad',
        path = {
            vector3(-1641.0, -563.75, 32.34375),
            vector3(-1801.75, -455.25, 40.8125),
            vector3(-1938.25, -331.0, 45.21875),
            vector3(-2131.5, -227.75, 16.40625)
        }
    },
    {
        title = 'Baqbaqoo',
        path = {
            vec3(-1486.000000, -457.500000, 34.625000),
            vec3(-1383.250000, -391.250000, 35.687500),
            vec3(-1235.750000, -320.750000, 36.406250),
            vec3(-1088.750000, -216.250000, 36.875000)
        }
    }
}

Config.options = {
    drawDistance = 60, -- Proximity to draw join race
    hudPosition = vec(0.015, 0.685), -- Screen position to draw racing HUD (EX: CheckPoints, TimeElapsed)
}

Config.Blips = {
    checkpoint = { -- Checkpoint blips
        color = 5,
    },
    listen = { -- Listen blips
        sprite = 38,
        color = 46,
    }
}

-- Markers for drawing listerns and creating checkPoints
Config.Markers = {
    listner = {
        type = 1,
        color = {r = 0, g = 128, b = 255, a = 50},
        size = {x = 7, y = 7, z = 2}

    },
    checkpoint = {
        diameter = 10.0,
        color = {r = 247, g = 198, b = 104, a = 100},
        cylinderHeight = vector3(5.0, 5.0, 10.0),
        -- Second icon inside the checkpoint
        iconHeight = 0.4,
        color2 = {r = 9, g = 152, b = 235, a = 120}
    }
}

-- Collision Alpha set for vehicles when race collision is disabled
Config.collisionAlpha = 200
-- Outline color for drawing vehicles in race
Config.outLineColor = {r = 18, g = 146, b = 35, a = 150}
-- Defaoult outline color after race finish
Config.defaultOutLineColor = {r = 255, g = 215, b = 0, a = 255}

Config.RaceExpire = {
    -- Define after how many seconds expire the race
    time = 600,
    -- Define after how many seconds warn the race master about exire (it should be less than expire time)
    notify = 60
}

-- Setting about legal notify
Config.legalNotify = {
    -- Which job should be notified
    job = 'sheriff',
    -- chance or that legal job to get notified
    chance = 20,
    -- Clear the pulse blip after x milisecond
    clearNotify = 60000
}