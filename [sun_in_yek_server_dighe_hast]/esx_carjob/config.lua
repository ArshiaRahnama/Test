-- Pub by FleeX Team , https://discord.gg/87rGBxgCsa

Config                            = {}

Config.DrawDistance               = 100.0

Config.NPCJobEarnings             = {min = 300, max = 600}
Config.MinimumDistance            = 3000 -- Minimum NPC job destination distance from the pickup in GTA units, a higher number prevents nearby destionations.

Config.MaxInService               = -1
Config.EnablePlayerManagement     = true
Config.EnableSocietyOwnedVehicles = true

Config.Locale                     = 'en'

Config.AuthorizedVehicles = {

    {
        model = 'superd',
        label = 'Superd'
    },
    {
        model = 'taxi',
        label = 'Taxi'
    }
}

Config.Zones = {

    -- VehicleSpawner = {
    --     -- Pos   = {x = -24.42, y = -2078.46, z = 16.7},
    --     -- Size  = {x = 1.0, y = 1.0, z = 1.0},
    --     -- Color = {r = 204, g = 204, b = 0},
    --     -- Type  = 36, Rotate = true
    -- },

    -- VehicleDeleter = {
    --     -- Pos   = {x = -32.94, y = -2082.57 , z = 16.7},
    --     -- Size  = {x = 3.0, y = 3.0, z = 0.25},
    --     -- Color = {r = 255, g = 0, b = 0},
    --     -- Type  = 1, Rotate = false
    -- },

    carActions = {
        Pos   = {x = -78.75, y = -2014.42, z = 18.03},
        Size  = {x = 1.0, y = 1.0, z = 1.0},
        Color = {r = 204, g = 204, b = 0},
        Type  = 20, Rotate = true
    },

    Cloakroom = {
        Pos     = {x = -94.52, y = -2009.47, z = 18.03},
        Size    = {x = 1.0, y = 1.0, z = 1.0},
        Color   = {r = 204, g = 204, b = 0},
        Type    = 21, Rotate = true
    },
    --[[sell = {
        Pos     = {x = -28.18, y = -1103.88, z = 26.42},
        Size    = {x = 1.0, y = 1.0, z = 1.0},
        Color   = {r = 204, g = 204, b = 0},
        Type    = 21, Rotate = true
    }]]
}