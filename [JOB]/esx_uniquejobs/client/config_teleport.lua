ConfigTeleport = {}

TeleportMarkerCode = 2

-- Each entry: job = the entry's "own" job (always allowed) — optional.
--             department = 'doj' | 'le' | 'government', checked against
--             shared/departments.lua's DojJobSet / LeJobSet / GovernmentJobSet
--             at runtime, so this stays in sync automatically if Departments{}
--             in shared/departments.lua ever changes (no hardcoded job list
--             to drift out of date, same reasoning as IsDojJob/IsGovernmentJob).
ConfigTeleport.Teleports = {
    { -- Law Enforcement (was client/teleport_police.lua, main 5 points)
        positions = {
            { coords = vec3(430.7576, -992.294, 31.194), label = "[1] Mission Row" },
            { coords = vec3(1856.366, 3693.331, 34.286), label = "[2] Sandy Shores" },
            { coords = vec3(-448.109, 6018.754, 31.716), label = "[3] Paleto" },
            { coords = vec3(-2360.85, 3249.275, 32.810), label = "[4] Army" },
            { coords = vec3(624.5064, -18.6185, 82.778), label = "[5] Vinewood" },
        },
        color = { r = 0, g = 102, b = 255 },
        scale = { p1 = 0.5, p2 = 0.5, p3 = 0.5 },
        vehicle = false,
        department = 'government', -- doj + le, same as old isPlayerAllowedPolice()
        menuTitle = "LSPD Teleporter",
    },
    { -- Police heli pad (was client/teleport_police.lua, heli pair)
        positions = {
            { coords = vec3(640.8580, 12.25663, 82.791), label = "Pain" },
            { coords = vec3(565.6870, 4.959659, 103.23), label = "Bala" },
        },
        color = { r = 0, g = 102, b = 255 },
        scale = { p1 = 0.4, p2 = 0.4, p3 = 0.4 },
        vehicle = false,
        department = 'government',
        menuTitle = "LSPD Teleporter",
    },
    { -- Ambulance (was client/teleport_ambulance.lua)
        positions = {
            { coords = vec3(-801.547, -1251.81, 7.3374), label = "Station 1 Shar" },
            { coords = vec3(1835.664, 3671.769, 34.276), label = "Station 2 Sandy" },
            { coords = vec3(-256.404, 6334.413, 32.427), label = "Station 3 Paleto" },
            { coords = vec3(1736.338, 3641.375, 35.640), label = "[D]" },
        },
        color = { r = 0, g = 255, b = 0 },
        scale = { p1 = 0.5, p2 = 0.5, p3 = 0.5 },
        vehicle = false,
        job = 'ambulance',
        department = 'doj',
        menuTitle = "MD Teleporter",
    },
    { -- Mechanic (was client/teleport_mechanic.lua)
        positions = {
            { coords = vec3(-350.487, -155.310, 39.013), label = "Station 1" },
            { coords = vec3(1197.851, 2643.278, 37.835), label = "Station 2 Sandy" },
            { coords = vec3(98.72516, 6620.643, 32.435), label = "Station 3 Paleto" },
            { coords = vec3(-991.324, -2948.80, 13.945), label = "Air Custom" },
        },
        color = { r = 255, g = 140, b = 0 },
        scale = { p1 = 0.5, p2 = 0.5, p3 = 0.5 },
        vehicle = false,
        job = 'mechanic',
        department = 'doj',
        menuTitle = "MC Teleporter",
    },
    { -- Taxi (was client/teleport_taxi.lua)
        positions = {
            { coords = vec3(371.4842, -1612.67, 29.292), label = "Station 1" },
            { coords = vec3(907.1732, -161.617, 74.127), label = "Station 2" },
            { coords = vec3(-379.331, 6062.053, 31.500), label = "Station 3" },
            { coords = vec3(1735.931, 3641.736, 35.640), label = "Administatior" },
        },
        color = { r = 255, g = 255, b = 0 },
        scale = { p1 = 0.5, p2 = 0.5, p3 = 0.5 },
        vehicle = false,
        job = 'taxi',
        department = 'doj',
        menuTitle = "TX Teleporter",
    },
    { -- Weazel (was client/teleport_weazel.lua)
        positions = {
            { coords = vec3(-585.961, -934.131, 23.815), label = "Station 1" },
            { coords = vec3(-598.481, -930.876, 23.860), label = "Station 2" },
            { coords = vec3(129.4453, -800.5595, 30.28), label = "Station 3" },
            { coords = vec3(1735.931, 3641.736, 35.640), label = "Administatior" },
        },
        color = { r = 160, g = 32, b = 240 },
        scale = { p1 = 0.5, p2 = 0.5, p3 = 0.5 },
        vehicle = false,
        job = 'weazel',
        department = 'doj',
        menuTitle = "WZ Teleporter",
    },
}
