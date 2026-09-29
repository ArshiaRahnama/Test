if not Config.Shells.ENVI then
    return
end

local shells = {
    ['envi_shell_01_empty'] = {
        label = 'Apartment 1',

        tags = {'empty', 'envi'},
        rooms = 5,

        model = 'envi_shell_01_empty',

        doors = {
            x = 0.62,
            y = 0.6,
            z = 498.86,
            heading = 1.26
        },
        
        interactable = {
            {
                target = vector4(-1.15, 9.77, 499.48, 88.59),
                targetSize = vector3(0.9, 0.8, 2.0),
                options = {
                    {
                        timeUsage = 7000,
                        targetIcon = "fa-solid fa-sink",
                        type = 'sink',
                        waterUsage = 5000, -- Mililiters
                        billType = 'water',
                        coords = {
                            particles = vector3(-1.175646, 9.782219, 499.701),
                            player = vector4(-0.57, 9.84, 498.86, 92.5),
                        },
                    },
                    {
                        timeUsage = 5000,
                        targetIcon = "fa-solid fa-glass-water-droplet",
                        type = 'sink_drink',
                        waterUsage = 300, -- Mililiters
                        billType = 'water',
                        coords = {
                            particles = vector3(-1.175646, 9.782219, 499.701),
                            player = vector4(-0.57, 9.84, 498.86, 92.5),
                        },
                    },
                }
            },
        },

        images = {
            'shell/envi_shell_01_empty-1.png',
            'shell/envi_shell_01_empty-2.png',
            'shell/envi_shell_01_empty-3.png',
            'shell/envi_shell_01_empty-4.png',
            'shell/envi_shell_01_empty-5.png',
            'shell/envi_shell_01_empty-6.png',
        },
    },

    ['envi_shell_02_empty'] = {
        label = 'Apartment 2',

        tags = {'empty', 'envi'},
        rooms = 2,

        model = 'envi_shell_02_empty',

        doors = {
            x = 0.12,
            y = -10.56,
            z = 500.03,
            heading = 0.87
        },
        
        interactable = {
            {
                target = vector4(1.63, -10.56, 500.77, 179.07),
                targetSize = vector3(0.9, 0.8, 2.0),
                options = {
                    {
                        timeUsage = 7000,
                        targetIcon = "fa-solid fa-sink",
                        type = 'sink',
                        waterUsage = 5000, -- Mililiters
                        billType = 'water',
                        coords = {
                            particles = vector3(1.617762, -10.70347, 500.8697),
                            player = vector4(1.6, -9.9, 500.03, 180.8),
                        },
                    },
                    {
                        timeUsage = 5000,
                        targetIcon = "fa-solid fa-glass-water-droplet",
                        type = 'sink_drink',
                        waterUsage = 300, -- Mililiters
                        billType = 'water',
                        coords = {
                            particles = vector3(1.617762, -10.70347, 500.8697),
                            player = vector4(1.6, -9.9, 500.03, 180.8),
                        },
                    },
                }
            },
        },

        images = {
            'shell/envi_shell_02_empty-1.png',
            'shell/envi_shell_02_empty-2.png',
            'shell/envi_shell_02_empty-3.png',
        },
    },

    ['envi_shell_03_empty'] = {
        label = 'Apartment 3',

        tags = {'empty', 'envi'},
        rooms = 5,

        model = 'envi_shell_03_empty',

        doors = {
            x = 4.75,
            y = -6.9,
            z = 500.18,
            heading = 91.4
        },
        
        interactable = {
            {
                target = vector4(5.04, -4.11, 501.07, -91.17),
                targetSize = vector3(0.9, 0.8, 2.0),
                options = {
                    {
                        timeUsage = 7000,
                        targetIcon = "fa-solid fa-sink",
                        type = 'sink',
                        waterUsage = 5000, -- Mililiters
                        billType = 'water',
                        coords = {
                            particles = vector3(5.113714, -4.125794, 501.2996),
                            player = vector4(4.59, -4.09, 500.18, 267.75),
                        },
                    },
                    {
                        timeUsage = 5000,
                        targetIcon = "fa-solid fa-glass-water-droplet",
                        type = 'sink_drink',
                        waterUsage = 300, -- Mililiters
                        billType = 'water',
                        coords = {
                            particles = vector3(5.113714, -4.125794, 501.2996),
                            player = vector4(4.59, -4.09, 500.18, 267.75),
                        },
                    },
                }
            },
            {
                target = vector4(2.32, -4.13, 500.64, 80.6),
                targetSize = vector3(2.0, 1.1, 3.3),
                options = {
                    {
                        timeUsage = 10000,
                        targetIcon = "fa-solid fa-shower",
                        type = 'shower',
                        waterUsage = 120000, -- Mililiters
                        billType = 'water',
                        coords = {
                            particles = vector3(2.175174, -4.920722, 501.7407),
                            player = vector4(2.14, -4.47, 500.24, 179.55),
                        },
                    }
                },
            },
        },

        images = {
            'shell/envi_shell_03_empty-1.png',
            'shell/envi_shell_03_empty-2.png',
            'shell/envi_shell_03_empty-3.png',
        },
    },
}

addShells(shells)