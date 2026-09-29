if not Config.Shells.DCCustomz then
    return
end

local shells = {
    ['bk_apartmentone'] = {
        label = 'bk_apartmentone',
        tags = {'furnished', 'dccustomz'},
        rooms = 4,
        model = 'bk_apartmentone',
        doors = {
            x = 1.51, y = -2.87, z = 498.63, heading = 1.19
        },
        interactable = {
            {
                target = vector4(-1.73, -1.76, 499.63, -177.92),
                targetSize = vector3(0.9, 0.8, 2.0),
                options = {
                    {
                        timeUsage = 7000,
                        targetIcon = "fa-solid fa-sink",
                        type = 'sink',
                        waterUsage = 5000, -- Mililiters
                        billType = 'water',
                        coords = {
                            particles = vector3(-1.722556, -1.912796, 499.8785),
                            player = vector4(-1.73, -1.24, 498.63, 180.14),
                        },
                    },
                    {
                        timeUsage = 5000,
                        targetIcon = "fa-solid fa-glass-water-droplet",
                        type = 'sink_drink',
                        waterUsage = 300, -- Mililiters
                        billType = 'water',
                        coords = {
                            particles = vector3(-1.722556, -1.912796, 499.8785),
                            player = vector4(-1.73, -1.24, 498.63, 180.14),
                        },
                    },
                }
            },
            {
                target = vector4(6.43, 5.64, 499.97, 0.31),
                targetSize = vector3(0.9, 0.8, 2.0),
                options = {
                    {
                        timeUsage = 7000,
                        targetIcon = "fa-solid fa-sink",
                        type = 'sink',
                        waterUsage = 5000, -- Mililiters
                        billType = 'water',
                        coords = {
                            particles = vector3(6.417291, 6.155429, 499.8834),
                            player = vector4(6.42, 5.38, 498.63, 359.86),
                        },
                    },
                    {
                        timeUsage = 5000,
                        targetIcon = "fa-solid fa-glass-water-droplet",
                        type = 'sink_drink',
                        waterUsage = 300, -- Mililiters
                        billType = 'water',
                        coords = {
                            particles = vector3(6.417291, 6.155429, 499.8834),
                            player = vector4(6.42, 5.38, 498.63, 359.86),
                        },
                    },
                }
            },
            {
                target = vector4(-0.01, -1.01, 498.84, 84.44),
                targetSize = vector3(2.0, 1.1, 3.3),
                options = {
                    {
                        timeUsage = 10000,
                        targetIcon = "fa-solid fa-shower",
                        type = 'shower',
                        waterUsage = 120000, -- Mililiters
                        billType = 'water',
                        coords = {
                            particles = vector3(0.117635, -0.4039056, 500.67),
                            player = vector4(0.1, -0.79, 498.81, 7.17),
                        },
                    }
                },
            },
        },
        images = {
            'shell/bk_apartmentone-1.png',
            'shell/bk_apartmentone-2.png',
            'shell/bk_apartmentone-3.png',
            'shell/bk_apartmentone-4.png',
            'shell/bk_apartmentone-5.png',
            'shell/bk_apartmentone-6.png',
            'shell/bk_apartmentone-7.png',
        },
    },
    ['bk_apartmenttwo'] = {
        label = 'bk_apartmenttwo',
        tags = {'furnished', 'dccustomz'},
        rooms = 5,
        model = 'bk_apartmenttwo',
        doors = {
            x = -7.17, y = -0.8, z = 498.63, heading = 269.74
        },
        interactable = {
            {
                target = vector4(-5.72, 5.42, 499.54, 0.94),
                targetSize = vector3(0.9, 0.8, 2.0),
                options = {
                    {
                        timeUsage = 7000,
                        targetIcon = "fa-solid fa-sink",
                        type = 'sink',
                        waterUsage = 5000, -- Mililiters
                        billType = 'water',
                        coords = {
                            particles = vector3(-5.727364, 5.670546, 499.8259),
                            player = vector4(-5.65, 4.76, 498.63, 356.53),
                        },
                    },
                    {
                        timeUsage = 5000,
                        targetIcon = "fa-solid fa-glass-water-droplet",
                        type = 'sink_drink',
                        waterUsage = 300, -- Mililiters
                        billType = 'water',
                        coords = {
                            particles = vector3(-5.727364, 5.670546, 499.8259),
                            player = vector4(-5.65, 4.76, 498.63, 356.53),
                        },
                    },
                }
            },
            {
                target = vector4(2.92, -2.77, 499.62, -90.7),
                targetSize = vector3(0.9, 0.8, 2.0),
                options = {
                    {
                        timeUsage = 7000,
                        targetIcon = "fa-solid fa-sink",
                        type = 'sink',
                        waterUsage = 5000, -- Mililiters
                        billType = 'water',
                        coords = {
                            particles = vector3(3.076, -2.766, 499.771),
                            player = vector4(2.3, -2.75, 498.63, 270.92),
                        },
                    },
                    {
                        timeUsage = 5000,
                        targetIcon = "fa-solid fa-glass-water-droplet",
                        type = 'sink_drink',
                        waterUsage = 300, -- Mililiters
                        billType = 'water',
                        coords = {
                            particles = vector3(3.076, -2.766, 499.771),
                            player = vector4(2.3, -2.75, 498.63, 270.92),
                        },
                    },
                }
            },
            {
                target = vector4(2.03, -4.72, 499.79, 179.09),
                targetSize = vector3(2.0, 1.1, 3.3),
                options = {
                    {
                        timeUsage = 10000,
                        targetIcon = "fa-solid fa-shower",
                        type = 'shower',
                        waterUsage = 120000, -- Mililiters
                        billType = 'water',
                        coords = {
                            particles = vector3(2.62, -4.716, 500.931),
                            player = vector4(2.28, -4.73, 498.79, 268.32),
                        },
                    }
                },
            },
            {
                target = vector4(0.63, 4.49, 499.66, 91.64),
                targetSize = vector3(0.9, 0.8, 2.0),
                options = {
                    {
                        timeUsage = 7000,
                        targetIcon = "fa-solid fa-sink",
                        type = 'sink',
                        waterUsage = 5000, -- Mililiters
                        billType = 'water',
                        coords = {
                            particles = vector3(0.466, 4.488, 499.8),
                            player = vector4(1.19, 4.49, 498.63, 88.06),
                        },
                    },
                    {
                        timeUsage = 5000,
                        targetIcon = "fa-solid fa-glass-water-droplet",
                        type = 'sink_drink',
                        waterUsage = 300, -- Mililiters
                        billType = 'water',
                        coords = {
                            particles = vector3(0.466, 4.488, 499.8),
                            player = vector4(1.19, 4.49, 498.63, 88.06),
                        },
                    },
                }
            },
            {
                target = vector4(3.22, 3.23, 499.64, 267.71),
                targetSize = vector3(1.5, 1.5, 3.3),
                options = {
                    {
                        timeUsage = 10000,
                        targetIcon = "fa-solid fa-shower",
                        type = 'shower',
                        waterUsage = 120000, -- Mililiters
                        billType = 'water',
                        coords = {
                            particles = vector3(3.265, 3.504, 500.683),
                            player = vector4(3.33, 3.21, 498.64, 7.83),
                        },
                    }
                },
            },
        },
        images = {
            'shell/bk_apartmenttwo-1.png',
            'shell/bk_apartmenttwo-2.png',
            'shell/bk_apartmenttwo-3.png',
            'shell/bk_apartmenttwo-4.png',
        },
    },
    ['dc_apartmentthree'] = {
        label = 'dc_apartmentthree',
        tags = {'furnished', 'dccustomz'},
        rooms = 2,
        model = 'dc_apartmentthree',
        doors = {
            x = 1.94, y = -6.0, z = 498.63, heading = 359.93
        },
        interactable = {
            {
                target = vector4(4.39, -2.46, 499.64, -0.28),
                targetSize = vector3(0.9, 0.8, 2.0),
                options = {
                    {
                        timeUsage = 7000,
                        targetIcon = "fa-solid fa-sink",
                        type = 'sink',
                        waterUsage = 5000, -- Mililiters
                        billType = 'water',
                        coords = {
                            particles = vector3(4.396, -2.37, 499.914),
                            player = vector4(4.46, -2.98, 498.63, 2.65),
                        },
                    },
                    {
                        timeUsage = 5000,
                        targetIcon = "fa-solid fa-glass-water-droplet",
                        type = 'sink_drink',
                        waterUsage = 300, -- Mililiters
                        billType = 'water',
                        coords = {
                            particles = vector3(4.396, -2.37, 499.914),
                            player = vector4(4.46, -2.98, 498.63, 2.65),
                        },
                    },
                }
            },
            {
                target = vector4(-2.61, -3.04, 499.59, -0.51),
                targetSize = vector3(0.9, 0.8, 2.0),
                options = {
                    {
                        timeUsage = 7000,
                        targetIcon = "fa-solid fa-sink",
                        type = 'sink',
                        waterUsage = 5000, -- Mililiters
                        billType = 'water',
                        coords = {
                            particles = vector3(-2.598, -2.852, 499.729),
                            player = vector4(-2.63, -3.59, 498.63, 0.7),
                        },
                    },
                    {
                        timeUsage = 5000,
                        targetIcon = "fa-solid fa-glass-water-droplet",
                        type = 'sink_drink',
                        waterUsage = 300, -- Mililiters
                        billType = 'water',
                        coords = {
                            particles = vector3(-2.598, -2.852, 499.729),
                            player = vector4(-2.63, -3.59, 498.63, 0.7),
                        },
                    },
                }
            },
            {
                target = vector4(-3.16, -5.6, 498.8, 180.3),
                targetSize = vector3(2.0, 1.1, 3.3),
                options = {
                    {
                        timeUsage = 10000,
                        targetIcon = "fa-solid fa-shower",
                        type = 'shower',
                        waterUsage = 120000, -- Mililiters
                        billType = 'water',
                        coords = {
                            particles = vector3(-3.955, -5.646, 500.783),
                            player = vector4(-3.49, -5.64, 498.8, 88.54),
                        },
                    }
                },
            },
        },
        images = {
            'shell/dc_apartmentthree-1.png',
            'shell/dc_apartmentthree-2.png',
            'shell/dc_apartmentthree-3.png',
            'shell/dc_apartmentthree-4.png',
        },
    },
    ['dc_apartmentfour'] = {
        label = 'dc_apartmentfour',
        tags = {'furnished', 'dccustomz'},
        rooms = 3,
        model = 'dc_apartmentfour',
        doors = {
            x = -1.88, y = -6.16, z = 498.55, heading = 2.93
        },
        interactable = {
            {
                target = vector4(-3.42, 1.54, 499.52, -0.07),
                targetSize = vector3(0.9, 0.8, 2.0),
                options = {
                    {
                        timeUsage = 7000,
                        targetIcon = "fa-solid fa-sink",
                        type = 'sink',
                        waterUsage = 5000, -- Mililiters
                        billType = 'water',
                        coords = {
                            particles = vector3(-3.419, 1.799, 499.684),
                            player = vector4(-3.41, 1.08, 498.55, 358.34),
                        },
                    },
                    {
                        timeUsage = 5000,
                        targetIcon = "fa-solid fa-glass-water-droplet",
                        type = 'sink_drink',
                        waterUsage = 300, -- Mililiters
                        billType = 'water',
                        coords = {
                            particles = vector3(-3.419, 1.799, 499.684),
                            player = vector4(-3.41, 1.08, 498.55, 358.34),
                        },
                    },
                }
            },
            {
                target = vector4(-1.9, 4.47, 499.46, 178.92),
                targetSize = vector3(0.9, 0.8, 2.0),
                options = {
                    {
                        timeUsage = 7000,
                        targetIcon = "fa-solid fa-sink",
                        type = 'sink',
                        waterUsage = 5000, -- Mililiters
                        billType = 'water',
                        coords = {
                            particles = vector3(-1.892, 4.247, 499.625),
                            player = vector4(-1.91, 5.08, 498.55, 180.65),
                        },
                    },
                    {
                        timeUsage = 5000,
                        targetIcon = "fa-solid fa-glass-water-droplet",
                        type = 'sink_drink',
                        waterUsage = 300, -- Mililiters
                        billType = 'water',
                        coords = {
                            particles = vector3(-1.892, 4.247, 499.625),
                            player = vector4(-1.91, 5.08, 498.55, 180.65),
                        },
                    },
                }
            },
            {
                target = vector4(-4.12, 5.16, 498.74, 264.59),
                targetSize = vector3(2.0, 1.1, 3.3),
                options = {
                    {
                        timeUsage = 10000,
                        targetIcon = "fa-solid fa-shower",
                        type = 'shower',
                        waterUsage = 120000, -- Mililiters
                        billType = 'water',
                        coords = {
                            particles = vector3(-4.14, 4.617, 501.088),
                            player = vector4(-4.05, 4.78, 498.74, 173.55),
                        },
                    }
                },
            },
        },
        images = {
            'shell/dc_apartmentfour-1.png',
            'shell/dc_apartmentfour-2.png',
            'shell/dc_apartmentfour-3.png',
            'shell/dc_apartmentfour-4.png',
        },
    },

    ['bk_houseone'] = {
        label = 'bk_houseone',
        tags = {'furnished', 'dccustomz'},
        rooms = 9,
        model = 'bk_houseone',
        doors = {
            x = 3.43, y = -3.46, z = 496.84, heading = 2.37
        },
        interactable = {
            {
                target = vector4(5.43, 0.17, 497.68, -89.03),
                targetSize = vector3(0.9, 0.8, 2.0),
                options = {
                    {
                        timeUsage = 7000,
                        targetIcon = "fa-solid fa-sink",
                        type = 'sink',
                        waterUsage = 5000, -- Mililiters
                        billType = 'water',
                        coords = {
                            particles = vector3(5.496, 0.176, 497.989),
                            player = vector4(4.74, 0.17, 496.84, 270.92),
                        },
                    },
                    {
                        timeUsage = 5000,
                        targetIcon = "fa-solid fa-glass-water-droplet",
                        type = 'sink_drink',
                        waterUsage = 300, -- Mililiters
                        billType = 'water',
                        coords = {
                            particles = vector3(5.496, 0.176, 497.989),
                            player = vector4(4.74, 0.17, 496.84, 270.92),
                        },
                    },
                }
            },
            {
                target = vector4(6.31, 0.79, 497.84, 88.16),
                targetSize = vector3(0.9, 0.8, 2.0),
                options = {
                    {
                        timeUsage = 7000,
                        targetIcon = "fa-solid fa-sink",
                        type = 'sink',
                        waterUsage = 5000, -- Mililiters
                        billType = 'water',
                        coords = {
                            particles = vector3(6.13, 0.799, 497.988),
                            player = vector4(6.92, 0.82, 496.84, 91.52),
                        },
                    },
                    {
                        timeUsage = 5000,
                        targetIcon = "fa-solid fa-glass-water-droplet",
                        type = 'sink_drink',
                        waterUsage = 300, -- Mililiters
                        billType = 'water',
                        coords = {
                            particles = vector3(6.13, 0.799, 497.988),
                            player = vector4(6.92, 0.82, 496.84, 91.52),
                        },
                    },
                }
            },
            {
                target = vector4(8.59, -0.4, 497.65, 88.38),
                targetSize = vector3(2.0, 1.1, 3.3),
                options = {
                    {
                        timeUsage = 10000,
                        targetIcon = "fa-solid fa-shower",
                        type = 'shower',
                        waterUsage = 120000, -- Mililiters
                        billType = 'water',
                        coords = {
                            particles = vector3(8.861, -0.827, 498.883),
                            player = vector4(8.76, -0.82, 496.85, 274.26),
                        },
                    }
                },
            },
            {
                target = vector4(-5.7, 4.95, 497.81, -90.69),
                targetSize = vector3(0.9, 0.8, 2.0),
                options = {
                    {
                        timeUsage = 7000,
                        targetIcon = "fa-solid fa-sink",
                        type = 'sink',
                        waterUsage = 5000, -- Mililiters
                        billType = 'water',
                        coords = {
                            particles = vector3(-5.304, 4.964, 497.998),
                            player = vector4(-6.28, 4.96, 496.84, 268.25),
                        },
                    },
                    {
                        timeUsage = 5000,
                        targetIcon = "fa-solid fa-glass-water-droplet",
                        type = 'sink_drink',
                        waterUsage = 300, -- Mililiters
                        billType = 'water',
                        coords = {
                            particles = vector3(-5.304, 4.964, 497.998),
                            player = vector4(-6.28, 4.96, 496.84, 268.25),
                        },
                    },
                }
            },
            {
                target = vector4(-2.73, -1.44, 501.02, -91.4),
                targetSize = vector3(0.9, 0.8, 2.0),
                options = {
                    {
                        timeUsage = 7000,
                        targetIcon = "fa-solid fa-sink",
                        type = 'sink',
                        waterUsage = 5000, -- Mililiters
                        billType = 'water',
                        coords = {
                            particles = vector3(-2.682, -1.433, 501.312),
                            player = vector4(-3.4, -1.45, 500.19, 268.15),
                        },
                    },
                    {
                        timeUsage = 5000,
                        targetIcon = "fa-solid fa-glass-water-droplet",
                        type = 'sink_drink',
                        waterUsage = 300, -- Mililiters
                        billType = 'water',
                        coords = {
                            particles = vector3(-2.682, -1.433, 501.312),
                            player = vector4(-3.4, -1.45, 500.19, 268.15),
                        },
                    },
                }
            },
            {
                target = vector4(-3.51, -3.42, 500.35, 1.94),
                targetSize = vector3(2.0, 1.1, 3.3),
                options = {
                    {
                        timeUsage = 10000,
                        targetIcon = "fa-solid fa-shower",
                        type = 'shower',
                        waterUsage = 120000, -- Mililiters
                        billType = 'water',
                        coords = {
                            particles = vector3(-2.562, -3.434, 502.044),
                            player = vector4(-3.02, -3.42, 500.35, 273.42),
                        },
                    }
                },
            },
            {
                target = vector4(-8.77, 3.85, 501.02, 90.89),
                targetSize = vector3(0.9, 0.8, 2.0),
                options = {
                    {
                        timeUsage = 7000,
                        targetIcon = "fa-solid fa-sink",
                        type = 'sink',
                        waterUsage = 5000, -- Mililiters
                        billType = 'water',
                        coords = {
                            particles = vector3(-8.838, 3.846, 501.319),
                            player = vector4(-8.13, 3.85, 500.19, 86.63),
                        },
                    },
                    {
                        timeUsage = 5000,
                        targetIcon = "fa-solid fa-glass-water-droplet",
                        type = 'sink_drink',
                        waterUsage = 300, -- Mililiters
                        billType = 'water',
                        coords = {
                            particles = vector3(-8.838, 3.846, 501.319),
                            player = vector4(-8.13, 3.85, 500.19, 86.63),
                        },
                    },
                }
            },
            {
                target = vector4(-8.13, 1.91, 500.35, 0.43),
                targetSize = vector3(2.0, 1.1, 3.3),
                options = {
                    {
                        timeUsage = 10000,
                        targetIcon = "fa-solid fa-shower",
                        type = 'shower',
                        waterUsage = 120000, -- Mililiters
                        billType = 'water',
                        coords = {
                            particles = vector3(-8.95, 1.962, 502.05),
                            player = vector4(-8.46, 1.98, 500.35, 90.25),
                        },
                    }
                },
            },
        },
        images = {
            'shell/bk_houseone-1.png',
            'shell/bk_houseone-2.png',
            'shell/bk_houseone-3.png',
            'shell/bk_houseone-4.png',
            'shell/bk_houseone-5.png',
            'shell/bk_houseone-6.png',
            'shell/bk_houseone-7.png',
            'shell/bk_houseone-8.png',
        },
    },
    ['dc_housetwoshell'] = {
        label = 'dc_housetwoshell',
        tags = {'furnished', 'dccustomz'},
        rooms = 11,
        model = 'dc_housetwoshell',
        doors = {
            x = 0.94, y = -6.56, z = 497.19, heading = 5.15
        },
        interactable = {
            {
                target = vector4(5.59, 1.02, 498.24, 93.34),
                targetSize = vector3(0.9, 0.8, 2.0),
                options = {
                    {
                        timeUsage = 7000,
                        targetIcon = "fa-solid fa-sink",
                        type = 'sink',
                        waterUsage = 5000, -- Mililiters
                        billType = 'water',
                        coords = {
                            particles = vector3(5.178, 0.989, 498.419),
                            player = vector4(6.16, 1.04, 497.19, 87.95),
                        },
                    },
                    {
                        timeUsage = 5000,
                        targetIcon = "fa-solid fa-glass-water-droplet",
                        type = 'sink_drink',
                        waterUsage = 300, -- Mililiters
                        billType = 'water',
                        coords = {
                            particles = vector3(5.178, 0.989, 498.419),
                            player = vector4(6.16, 1.04, 497.19, 87.95),
                        },
                    },
                }
            },
            {
                target = vector4(-5.8, 3.93, 498.2, -1.22),
                targetSize = vector3(0.9, 0.8, 2.0),
                options = {
                    {
                        timeUsage = 7000,
                        targetIcon = "fa-solid fa-sink",
                        type = 'sink',
                        waterUsage = 5000, -- Mililiters
                        billType = 'water',
                        coords = {
                            particles = vector3(-5.801, 4.093, 498.353),
                            player = vector4(-5.77, 3.35, 497.19, 356.53),
                        },
                    },
                    {
                        timeUsage = 5000,
                        targetIcon = "fa-solid fa-glass-water-droplet",
                        type = 'sink_drink',
                        waterUsage = 300, -- Mililiters
                        billType = 'water',
                        coords = {
                            particles = vector3(-5.801, 4.093, 498.353),
                            player = vector4(-5.77, 3.35, 497.19, 356.53),
                        },
                    },
                }
            },
            {
                target = vector4(-2.58, 3.66, 497.85, 273.5),
                targetSize = vector3(1.7, 1.7, 3.3),
                options = {
                    {
                        timeUsage = 10000,
                        targetIcon = "fa-solid fa-shower",
                        type = 'shower',
                        waterUsage = 120000, -- Mililiters
                        billType = 'water',
                        coords = {
                            particles = vector3(-2.365, 3.579, 499.305),
                            player = vector4(-2.46, 3.6, 497.2, 271.15),
                        },
                    }
                },
            },
            {
                target = vector4(-1.11, 1.53, 498.19, -89.67),
                targetSize = vector3(0.9, 0.8, 2.0),
                options = {
                    {
                        timeUsage = 7000,
                        targetIcon = "fa-solid fa-sink",
                        type = 'sink',
                        waterUsage = 5000, -- Mililiters
                        billType = 'water',
                        coords = {
                            particles = vector3(-0.898, 1.535, 498.332),
                            player = vector4(-1.67, 1.54, 497.19, 270.09),
                        },
                    },
                    {
                        timeUsage = 5000,
                        targetIcon = "fa-solid fa-glass-water-droplet",
                        type = 'sink_drink',
                        waterUsage = 300, -- Mililiters
                        billType = 'water',
                        coords = {
                            particles = vector3(-0.898, 1.535, 498.332),
                            player = vector4(-1.67, 1.54, 497.19, 270.09),
                        },
                    },
                }
            },
            {
                target = vector4(1.37, -6.86, 501.15, -177.01),
                targetSize = vector3(0.9, 0.8, 2.0),
                options = {
                    {
                        timeUsage = 7000,
                        targetIcon = "fa-solid fa-sink",
                        type = 'sink',
                        waterUsage = 5000, -- Mililiters
                        billType = 'water',
                        coords = {
                            particles = vector3(1.379, -7.046, 501.303),
                            player = vector4(1.35, -6.34, 500.15, 180.09),
                        },
                    },
                    {
                        timeUsage = 5000,
                        targetIcon = "fa-solid fa-glass-water-droplet",
                        type = 'sink_drink',
                        waterUsage = 300, -- Mililiters
                        billType = 'water',
                        coords = {
                            particles = vector3(1.379, -7.046, 501.303),
                            player = vector4(1.35, -6.34, 500.15, 180.09),
                        },
                    },
                }
            },
            {
                target = vector4(-0.71, -6.36, 500.31, 271.24),
                targetSize = vector3(2.0, 1.1, 3.3),
                options = {
                    {
                        timeUsage = 10000,
                        targetIcon = "fa-solid fa-shower",
                        type = 'shower',
                        waterUsage = 120000, -- Mililiters
                        billType = 'water',
                        coords = {
                            particles = vector3(-0.721, -6.978, 502.381),
                            player = vector4(-0.75, -6.67, 500.31, 182.38),
                        },
                    }
                },
            },
            {
                target = vector4(0.18, 6.24, 501.15, 1.15),
                targetSize = vector3(0.9, 0.8, 2.0),
                options = {
                    {
                        timeUsage = 7000,
                        targetIcon = "fa-solid fa-sink",
                        type = 'sink',
                        waterUsage = 5000, -- Mililiters
                        billType = 'water',
                        coords = {
                            particles = vector3(0.172, 6.443, 501.309),
                            player = vector4(0.23, 5.71, 500.15, 358.86),
                        },
                    },
                    {
                        timeUsage = 5000,
                        targetIcon = "fa-solid fa-glass-water-droplet",
                        type = 'sink_drink',
                        waterUsage = 300, -- Mililiters
                        billType = 'water',
                        coords = {
                            particles = vector3(0.172, 6.443, 501.309),
                            player = vector4(0.23, 5.71, 500.15, 358.86),
                        },
                    },
                }
            },
            {
                target = vector4(-1.94, 5.73, 500.31, 261.68),
                targetSize = vector3(2.0, 1.1, 3.3),
                options = {
                    {
                        timeUsage = 10000,
                        targetIcon = "fa-solid fa-shower",
                        type = 'shower',
                        waterUsage = 120000, -- Mililiters
                        billType = 'water',
                        coords = {
                            particles = vector3(-1.894, 6.385, 502.385),
                            player = vector4(-1.83, 6.08, 500.31, 2.16),
                        },
                    }
                },
            },
        },
        images = {
            'shell/dc_housetwoshell-1.png',
            'shell/dc_housetwoshell-2.png',
            'shell/dc_housetwoshell-3.png',
            'shell/dc_housetwoshell-4.png',
            'shell/dc_housetwoshell-5.png',
            'shell/dc_housetwoshell-6.png',
            'shell/dc_housetwoshell-7.png',
            'shell/dc_housetwoshell-8.png',
            'shell/dc_housetwoshell-9.png',
            'shell/dc_housetwoshell-10.png',
            'shell/dc_housetwoshell-11.png',
        },
    },
    ['dc_housethree'] = {
        label = 'dc_housethree',
        tags = {'furnished', 'dccustomz'},
        rooms = 9,
        model = 'dc_housethree',
        doors = {
            x = -8.38, y = -2.36, z = 498.49, heading = 2.4
        },
        interactable = {
            {
                target = vector4(-0.63, -2.66, 499.43, -1.44),
                targetSize = vector3(0.9, 0.8, 2.0),
                options = {
                    {
                        timeUsage = 7000,
                        targetIcon = "fa-solid fa-sink",
                        type = 'sink',
                        waterUsage = 5000, -- Mililiters
                        billType = 'water',
                        coords = {
                            particles = vector3(-0.625, -2.474, 499.731),
                            player = vector4(-0.62, -3.22, 498.49, 359.57),
                        },
                    },
                    {
                        timeUsage = 5000,
                        targetIcon = "fa-solid fa-glass-water-droplet",
                        type = 'sink_drink',
                        waterUsage = 300, -- Mililiters
                        billType = 'water',
                        coords = {
                            particles = vector3(-0.625, -2.474, 499.731),
                            player = vector4(-0.62, -3.22, 498.49, 359.57),
                        },
                    },
                }
            },
            {
                target = vector4(0.81, 1.06, 499.31, 87.96),
                targetSize = vector3(0.9, 0.8, 2.0),
                options = {
                    {
                        timeUsage = 7000,
                        targetIcon = "fa-solid fa-sink",
                        type = 'sink',
                        waterUsage = 5000, -- Mililiters
                        billType = 'water',
                        coords = {
                            particles = vector3(0.664, 1.067, 499.572),
                            player = vector4(1.43, 1.12, 498.49, 89.03),
                        },
                    },
                    {
                        timeUsage = 5000,
                        targetIcon = "fa-solid fa-glass-water-droplet",
                        type = 'sink_drink',
                        waterUsage = 300, -- Mililiters
                        billType = 'water',
                        coords = {
                            particles = vector3(0.664, 1.067, 499.572),
                            player = vector4(1.43, 1.12, 498.49, 89.03),
                        },
                    },
                }
            },
            {
                target = vector4(1.69, 2.88, 498.66, 181.92),
                targetSize = vector3(2.0, 1.1, 3.3),
                options = {
                    {
                        timeUsage = 10000,
                        targetIcon = "fa-solid fa-shower",
                        type = 'shower',
                        waterUsage = 120000, -- Mililiters
                        billType = 'water',
                        coords = {
                            particles = vector3(1.279, 2.903, 500.646),
                            player = vector4(1.19, 2.83, 498.66, 90.25),
                        },
                    }
                },
            },
            {
                target = vector4(2.23, 3.78, 499.22, 179.03),
                targetSize = vector3(0.9, 0.8, 2.0),
                options = {
                    {
                        timeUsage = 7000,
                        targetIcon = "fa-solid fa-sink",
                        type = 'sink',
                        waterUsage = 5000, -- Mililiters
                        billType = 'water',
                        coords = {
                            particles = vector3(2.233, 3.671, 499.386),
                            player = vector4(2.17, 4.45, 498.49, 178.82),
                        },
                    },
                    {
                        timeUsage = 5000,
                        targetIcon = "fa-solid fa-glass-water-droplet",
                        type = 'sink_drink',
                        waterUsage = 300, -- Mililiters
                        billType = 'water',
                        coords = {
                            particles = vector3(2.233, 3.671, 499.386),
                            player = vector4(2.17, 4.45, 498.49, 178.82),
                        },
                    },
                }
            },
            {
                target = vector4(4.57, 6.44, 498.49, 270.12),
                targetSize = vector3(2.0, 1.1, 3.3),
                options = {
                    {
                        timeUsage = 10000,
                        targetIcon = "fa-solid fa-shower",
                        type = 'shower',
                        waterUsage = 120000, -- Mililiters
                        billType = 'water',
                        coords = {
                            particles = vector3(4.888, 6.488, 500.616),
                            player = vector4(4.57, 6.44, 498.49, 270.12),
                        },
                    }
                },
            },
        },
        images = {
            'shell/dc_housethree-1.png',
            'shell/dc_housethree-2.png',
            'shell/dc_housethree-3.png',
            'shell/dc_housethree-4.png',
            'shell/dc_housethree-5.png',
            'shell/dc_housethree-6.png',
            'shell/dc_housethree-7.png',
            'shell/dc_housethree-8.png',
        },
    },
    ['dc_housefour'] = {
        label = 'dc_housefour',
        tags = {'furnished', 'dccustomz'},
        rooms = 11,
        model = 'dc_housefour',
        doors = {
            x = 8.34, y = 4.6, z = 497.11, heading = 91.94
        },
        interactable = {
            {
                target = vector4(0.66, -1.63, 498.01, 179.8),
                targetSize = vector3(0.9, 0.8, 2.0),
                options = {
                    {
                        timeUsage = 7000,
                        targetIcon = "fa-solid fa-sink",
                        type = 'sink',
                        waterUsage = 5000, -- Mililiters
                        billType = 'water',
                        coords = {
                            particles = vector3(0.661, -1.7, 498.217),
                            player = vector4(0.67, -1.05, 497.11, 180.27),
                        },
                    },
                    {
                        timeUsage = 5000,
                        targetIcon = "fa-solid fa-glass-water-droplet",
                        type = 'sink_drink',
                        waterUsage = 300, -- Mililiters
                        billType = 'water',
                        coords = {
                            particles = vector3(0.661, -1.7, 498.217),
                            player = vector4(0.67, -1.05, 497.11, 180.27),
                        },
                    },
                }
            },
            {
                target = vector4(6.93, -3.2, 498.01, 3.82),
                targetSize = vector3(0.9, 0.8, 2.0),
                options = {
                    {
                        timeUsage = 7000,
                        targetIcon = "fa-solid fa-sink",
                        type = 'sink',
                        waterUsage = 5000, -- Mililiters
                        billType = 'water',
                        coords = {
                            particles = vector3(6.934, -3.091, 498.33),
                            player = vector4(6.96, -3.83, 497.11, 3.0),
                        },
                    },
                    {
                        timeUsage = 5000,
                        targetIcon = "fa-solid fa-glass-water-droplet",
                        type = 'sink_drink',
                        waterUsage = 300, -- Mililiters
                        billType = 'water',
                        coords = {
                            particles = vector3(6.934, -3.091, 498.33),
                            player = vector4(6.96, -3.83, 497.11, 3.0),
                        },
                    },
                }
            },
            {
                target = vector4(-3.03, -3.81, 501.19, 88.99),
                targetSize = vector3(0.9, 0.8, 2.0),
                options = {
                    {
                        timeUsage = 7000,
                        targetIcon = "fa-solid fa-sink",
                        type = 'sink',
                        waterUsage = 5000, -- Mililiters
                        billType = 'water',
                        coords = {
                            particles = vector3(-3.097, -3.803, 501.544),
                            player = vector4(-2.45, -3.83, 500.3, 89.85),
                        },
                    },
                    {
                        timeUsage = 5000,
                        targetIcon = "fa-solid fa-glass-water-droplet",
                        type = 'sink_drink',
                        waterUsage = 300, -- Mililiters
                        billType = 'water',
                        coords = {
                            particles = vector3(-3.097, -3.803, 501.544),
                            player = vector4(-2.45, -3.83, 500.3, 89.85),
                        },
                    },
                }
            },
            {
                target = vector4(-0.64, -3.64, 500.32, 272.59),
                targetSize = vector3(2.0, 1.1, 3.3),
                options = {
                    {
                        timeUsage = 10000,
                        targetIcon = "fa-solid fa-shower",
                        type = 'shower',
                        waterUsage = 120000, -- Mililiters
                        billType = 'water',
                        coords = {
                            particles = vector3(-0.545, -3.615, 502.651),
                            player = vector4(-0.62, -3.65, 500.32, 2.7),
                        },
                    }
                },
            },
            {
                target = vector4(5.31, -4.87, 501.53, -0.33),
                targetSize = vector3(0.9, 0.8, 2.0),
                options = {
                    {
                        timeUsage = 7000,
                        targetIcon = "fa-solid fa-sink",
                        type = 'sink',
                        waterUsage = 5000, -- Mililiters
                        billType = 'water',
                        coords = {
                            particles = vector3(5.308, -4.754, 501.837),
                            player = vector4(5.36, -5.43, 500.64, 359.48),
                        },
                    },
                    {
                        timeUsage = 5000,
                        targetIcon = "fa-solid fa-glass-water-droplet",
                        type = 'sink_drink',
                        waterUsage = 300, -- Mililiters
                        billType = 'water',
                        coords = {
                            particles = vector3(5.308, -4.754, 501.837),
                            player = vector4(5.36, -5.43, 500.64, 359.48),
                        },
                    },
                }
            },
            {
                target = vector4(7.64, -5.66, 500.8, 92.99),
                targetSize = vector3(2.0, 1.1, 3.3),
                options = {
                    {
                        timeUsage = 10000,
                        targetIcon = "fa-solid fa-shower",
                        type = 'shower',
                        waterUsage = 120000, -- Mililiters
                        billType = 'water',
                        coords = {
                            particles = vector3(7.603, -4.877, 502.877),
                            player = vector4(7.64, -5.25, 500.8, 2.18),
                        },
                    }
                },
            },
        },
        images = {
            'shell/dc_housefour-1.png',
            'shell/dc_housefour-2.png',
            'shell/dc_housefour-3.png',
            'shell/dc_housefour-4.png',
            'shell/dc_housefour-5.png',
            'shell/dc_housefour-6.png',
        },
    },
    ['dc_housefive'] = {
        label = 'dc_housefive',
        tags = {'furnished', 'dccustomz'},
        rooms = 3,
        model = 'dc_housefive',
        doors = {
            x = -3.56, y = 1.5, z = 498.67, heading = 265.95
        },
        interactable = {
            {
                target = vector4(1.29, -7.5, 499.92, 88.04),
                targetSize = vector3(0.9, 0.8, 2.0),
                options = {
                    {
                        timeUsage = 7000,
                        targetIcon = "fa-solid fa-sink",
                        type = 'sink',
                        waterUsage = 5000, -- Mililiters
                        billType = 'water',
                        coords = {
                            particles = vector3(0.997, -7.491, 500.051),
                            player = vector4(1.89, -7.48, 498.87, 90.0),
                        },
                    },
                    {
                        timeUsage = 5000,
                        targetIcon = "fa-solid fa-glass-water-droplet",
                        type = 'sink_drink',
                        waterUsage = 300, -- Mililiters
                        billType = 'water',
                        coords = {
                            particles = vector3(0.997, -7.491, 500.051),
                            player = vector4(1.89, -7.48, 498.87, 90.0),
                        },
                    },
                }
            },
            {
                target = vector4(1.93, -9.68, 499.05, 355.71),
                targetSize = vector3(2.0, 1.1, 3.3),
                options = {
                    {
                        timeUsage = 10000,
                        targetIcon = "fa-solid fa-shower",
                        type = 'shower',
                        waterUsage = 120000, -- Mililiters
                        billType = 'water',
                        coords = {
                            particles = vector3(1.521, -9.628, 501.112),
                            player = vector4(1.62, -9.7, 499.05, 94.1),
                        },
                    }
                },
            },
            {
                target = vector4(4.67, 6.69, 499.9, 0.01),
                targetSize = vector3(0.9, 0.8, 2.0),
                options = {
                    {
                        timeUsage = 7000,
                        targetIcon = "fa-solid fa-sink",
                        type = 'sink',
                        waterUsage = 5000, -- Mililiters
                        billType = 'water',
                        coords = {
                            particles = vector3(4.653, 7.104, 500.117),
                            player = vector4(4.65, 6.13, 498.87, 0.15),
                        },
                    },
                    {
                        timeUsage = 5000,
                        targetIcon = "fa-solid fa-glass-water-droplet",
                        type = 'sink_drink',
                        waterUsage = 300, -- Mililiters
                        billType = 'water',
                        coords = {
                            particles = vector3(4.653, 7.104, 500.117),
                            player = vector4(4.65, 6.13, 498.87, 0.15),
                        },
                    },
                }
            },
        },
        images = {
            'shell/dc_housefive-1.png',
            'shell/dc_housefive-2.png',
            'shell/dc_housefive-3.png',
            'shell/dc_housefive-4.png',
        },
    },
    ['dc_housesix'] = {
        label = 'dc_housesix',
        tags = {'furnished', 'dccustomz'},
        rooms = 13,
        model = 'dc_housesix',
        doors = {
            x = -4.38, y = -10.27, z = 497.14, heading = 6.92
        },
        interactable = {
            {
                target = vector4(4.44, -7.12, 497.99, 91.53),
                targetSize = vector3(0.9, 0.8, 2.0),
                options = {
                    {
                        timeUsage = 7000,
                        targetIcon = "fa-solid fa-sink",
                        type = 'sink',
                        waterUsage = 5000, -- Mililiters
                        billType = 'water',
                        coords = {
                            particles = vector3(4.458, -7.123, 498.424),
                            player = vector4(5.06, -7.11, 497.14, 91.99),
                        },
                    },
                    {
                        timeUsage = 5000,
                        targetIcon = "fa-solid fa-glass-water-droplet",
                        type = 'sink_drink',
                        waterUsage = 300, -- Mililiters
                        billType = 'water',
                        coords = {
                            particles = vector3(4.458, -7.123, 498.424),
                            player = vector4(5.06, -7.11, 497.14, 91.99),
                        },
                    },
                }
            },
            {
                target = vector4(0.12, -0.67, 498.09, 88.25),
                targetSize = vector3(0.9, 0.8, 2.0),
                options = {
                    {
                        timeUsage = 7000,
                        targetIcon = "fa-solid fa-sink",
                        type = 'sink',
                        waterUsage = 5000, -- Mililiters
                        billType = 'water',
                        coords = {
                            particles = vector3(-0.12, -0.675, 498.181),
                            player = vector4(0.72, -0.64, 497.14, 91.14),
                        },
                    },
                    {
                        timeUsage = 5000,
                        targetIcon = "fa-solid fa-glass-water-droplet",
                        type = 'sink_drink',
                        waterUsage = 300, -- Mililiters
                        billType = 'water',
                        coords = {
                            particles = vector3(-0.12, -0.675, 498.181),
                            player = vector4(0.72, -0.64, 497.14, 91.14),
                        },
                    },
                }
            },
            {
                target = vector4(-6.39, 1.2, 501.51, 178.87),
                targetSize = vector3(0.9, 0.8, 2.0),
                options = {
                    {
                        timeUsage = 7000,
                        targetIcon = "fa-solid fa-sink",
                        type = 'sink',
                        waterUsage = 5000, -- Mililiters
                        billType = 'water',
                        coords = {
                            particles = vector3(-6.398, 0.975, 501.618),
                            player = vector4(-6.42, 1.77, 500.58, 183.29),
                        },
                    },
                    {
                        timeUsage = 5000,
                        targetIcon = "fa-solid fa-glass-water-droplet",
                        type = 'sink_drink',
                        waterUsage = 300, -- Mililiters
                        billType = 'water',
                        coords = {
                            particles = vector3(-6.398, 0.975, 501.618),
                            player = vector4(-6.42, 1.77, 500.58, 183.29),
                        },
                    },
                }
            },
            {
                target = vector4(-8.48, 1.86, 500.75, 268.57),
                targetSize = vector3(2.0, 1.1, 3.3),
                options = {
                    {
                        timeUsage = 10000,
                        targetIcon = "fa-solid fa-shower",
                        type = 'shower',
                        waterUsage = 120000, -- Mililiters
                        billType = 'water',
                        coords = {
                            particles = vector3(-8.501, 0.935, 502.446),
                            player = vector4(-8.45, 1.52, 500.75, 181.92),
                        },
                    }
                },
            },
            {
                target = vector4(-0.28, -6.67, 501.57, -0.39),
                targetSize = vector3(0.9, 0.8, 2.0),
                options = {
                    {
                        timeUsage = 7000,
                        targetIcon = "fa-solid fa-sink",
                        type = 'sink',
                        waterUsage = 5000, -- Mililiters
                        billType = 'water',
                        coords = {
                            particles = vector3(-0.27, -6.449, 501.731),
                            player = vector4(-0.3, -7.27, 500.58, 358.93),
                        },
                    },
                    {
                        timeUsage = 5000,
                        targetIcon = "fa-solid fa-glass-water-droplet",
                        type = 'sink_drink',
                        waterUsage = 300, -- Mililiters
                        billType = 'water',
                        coords = {
                            particles = vector3(-0.27, -6.449, 501.731),
                            player = vector4(-0.3, -7.27, 500.58, 358.93),
                        },
                    },
                }
            },
            {
                target = vector4(1.27, -9.56, 500.59, 184.18),
                targetSize = vector3(1.7, 1.7, 3.3),
                options = {
                    {
                        timeUsage = 10000,
                        targetIcon = "fa-solid fa-shower",
                        type = 'shower',
                        waterUsage = 120000, -- Mililiters
                        billType = 'water',
                        coords = {
                            particles = vector3(1.165, -9.89, 502.629),
                            player = vector4(1.27, -9.56, 500.59, 184.18),
                        },
                    }
                },
            },
            {
                target = vector4(2.15, -0.6, 501.51, 89.21),
                targetSize = vector3(0.9, 0.8, 2.0),
                options = {
                    {
                        timeUsage = 7000,
                        targetIcon = "fa-solid fa-sink",
                        type = 'sink',
                        waterUsage = 5000, -- Mililiters
                        billType = 'water',
                        coords = {
                            particles = vector3(1.929, -0.598, 501.606),
                            player = vector4(2.68, -0.57, 500.58, 90.41),
                        },
                    },
                    {
                        timeUsage = 5000,
                        targetIcon = "fa-solid fa-glass-water-droplet",
                        type = 'sink_drink',
                        waterUsage = 300, -- Mililiters
                        billType = 'water',
                        coords = {
                            particles = vector3(1.929, -0.598, 501.606),
                            player = vector4(2.68, -0.57, 500.58, 90.41),
                        },
                    },
                }
            },
            {
                target = vector4(2.69, 1.63, 500.75, 183.44),
                targetSize = vector3(2.0, 1.1, 3.3),
                options = {
                    {
                        timeUsage = 10000,
                        targetIcon = "fa-solid fa-shower",
                        type = 'shower',
                        waterUsage = 120000, -- Mililiters
                        billType = 'water',
                        coords = {
                            particles = vector3(1.903, 1.578, 502.474),
                            player = vector4(2.49, 1.67, 500.75, 82.67),
                        },
                    }
                },
            },
        },
        images = {
            'shell/dc_housesix-1.png',
            'shell/dc_housesix-2.png',
            'shell/dc_housesix-3.png',
            'shell/dc_housesix-4.png',
            'shell/dc_housesix-5.png',
            'shell/dc_housesix-6.png',
            'shell/dc_housesix-7.png',
            'shell/dc_housesix-8.png',
            'shell/dc_housesix-9.png',
            'shell/dc_housesix-10.png',
            'shell/dc_housesix-11.png',
        },
    },
    ['dc_houseseven'] = {
        label = 'dc_houseseven',
        tags = {'furnished', 'dccustomz'},
        rooms = 10,
        model = 'dc_houseseven',
        doors = {
            x = 0.68,
            y = 1.78,
            z = 498.54,
            heading = 182.14
        },
        interactable = {
            {
                target = vector4(9.17, -3.07, 499.5, 90.23),
                targetSize = vector3(0.9, 0.8, 2.0),
                options = {
                    {
                        timeUsage = 7000,
                        targetIcon = "fa-solid fa-sink",
                        type = 'sink',
                        waterUsage = 5000, -- Mililiters
                        billType = 'water',
                        coords = {
                            particles = vector3(9.097, -3.099, 499.643),
                            player = vector4(9.71, -3.04, 498.54, 89.11),
                        },
                    },
                    {
                        timeUsage = 5000,
                        targetIcon = "fa-solid fa-glass-water-droplet",
                        type = 'sink_drink',
                        waterUsage = 300, -- Mililiters
                        billType = 'water',
                        coords = {
                            particles = vector3(9.097, -3.099, 499.643),
                            player = vector4(9.71, -3.04, 498.54, 89.11),
                        },
                    },
                }
            },
            {
                target = vector4(-8.21, 5.91, 499.48, -0.5),
                targetSize = vector3(0.9, 0.8, 2.0),
                options = {
                    {
                        timeUsage = 7000,
                        targetIcon = "fa-solid fa-sink",
                        type = 'sink',
                        waterUsage = 5000, -- Mililiters
                        billType = 'water',
                        coords = {
                            particles = vector3(-8.212, 6.085, 499.595),
                            player = vector4(-8.19, 5.28, 498.54, 356.89),
                        },
                    },
                    {
                        timeUsage = 5000,
                        targetIcon = "fa-solid fa-glass-water-droplet",
                        type = 'sink_drink',
                        waterUsage = 300, -- Mililiters
                        billType = 'water',
                        coords = {
                            particles = vector3(-8.212, 6.085, 499.595),
                            player = vector4(-8.19, 5.28, 498.54, 356.89),
                        },
                    },
                }
            },
            {
                target = vector4(-8.46, 3.85, 498.57, 357.63),
                targetSize = vector3(2.0, 1.1, 3.3),
                options = {
                    {
                        timeUsage = 10000,
                        targetIcon = "fa-solid fa-shower",
                        type = 'shower',
                        waterUsage = 120000, -- Mililiters
                        billType = 'water',
                        coords = {
                            particles = vector3(-7.821, 3.797, 500.81),
                            player = vector4(-8.15, 3.85, 498.57, 269.16),
                        },
                    }
                },
            },
            {
                target = vector4(-10.96, -6.76, 499.48, 90.14),
                targetSize = vector3(0.9, 0.8, 2.0),
                options = {
                    {
                        timeUsage = 7000,
                        targetIcon = "fa-solid fa-sink",
                        type = 'sink',
                        waterUsage = 5000, -- Mililiters
                        billType = 'water',
                        coords = {
                            particles = vector3(-11.136, -6.764, 499.576),
                            player = vector4(-10.36, -6.75, 498.54, 92.85),
                        },
                    },
                    {
                        timeUsage = 5000,
                        targetIcon = "fa-solid fa-glass-water-droplet",
                        type = 'sink_drink',
                        waterUsage = 300, -- Mililiters
                        billType = 'water',
                        coords = {
                            particles = vector3(-11.136, -6.764, 499.576),
                            player = vector4(-10.36, -6.75, 498.54, 92.85),
                        },
                    },
                }
            },
            {
                target = vector4(-8.32, -6.51, 498.56, 3.42),
                targetSize = vector3(1.7, 1.7, 3.3),
                options = {
                    {
                        timeUsage = 10000,
                        targetIcon = "fa-solid fa-shower",
                        type = 'shower',
                        waterUsage = 120000, -- Mililiters
                        billType = 'water',
                        coords = {
                            particles = vector3(-8.324, -6.593, 500.746),
                            player = vector4(-8.32, -6.51, 498.56, 3.42),
                        },
                    }
                },
            },
        },
        images = {
            'shell/dc_houseseven-1.png',
            'shell/dc_houseseven-2.png',
            'shell/dc_houseseven-3.png',
            'shell/dc_houseseven-4.png',
            'shell/dc_houseseven-5.png',
        },
    },

    ['dc_townhouseone'] = {
        label = 'dc_townhouseone',
        tags = {'furnished', 'dccustomz'},
        rooms = 6,
        model = 'dc_townhouseone',
        doors = {
            x = 1.28, y = 4.62, z = 497.02, heading = 180.73
        },
        interactable = {
            {
                target = vector4(-0.89, 5.11, 497.92, 3.68),
                targetSize = vector3(0.9, 0.8, 2.0),
                options = {
                    {
                        timeUsage = 7000,
                        targetIcon = "fa-solid fa-sink",
                        type = 'sink',
                        waterUsage = 5000, -- Mililiters
                        billType = 'water',
                        coords = {
                            particles = vector3(-0.895, 5.288, 498.156),
                            player = vector4(-0.86, 4.54, 497.02, 354.28),
                        },
                    },
                    {
                        timeUsage = 5000,
                        targetIcon = "fa-solid fa-glass-water-droplet",
                        type = 'sink_drink',
                        waterUsage = 300, -- Mililiters
                        billType = 'water',
                        coords = {
                            particles = vector3(-0.895, 5.288, 498.156),
                            player = vector4(-0.86, 4.54, 497.02, 354.28),
                        },
                    },
                }
            },
            {
                target = vector4(2.94, 0.09, 497.96, 179.59),
                targetSize = vector3(0.9, 0.8, 2.0),
                options = {
                    {
                        timeUsage = 7000,
                        targetIcon = "fa-solid fa-sink",
                        type = 'sink',
                        waterUsage = 5000, -- Mililiters
                        billType = 'water',
                        coords = {
                            particles = vector3(2.95, -0.088, 498.058),
                            player = vector4(2.94, 0.67, 497.02, 176.91),
                        },
                    },
                    {
                        timeUsage = 5000,
                        targetIcon = "fa-solid fa-glass-water-droplet",
                        type = 'sink_drink',
                        waterUsage = 300, -- Mililiters
                        billType = 'water',
                        coords = {
                            particles = vector3(2.95, -0.088, 498.058),
                            player = vector4(2.94, 0.67, 497.02, 176.91),
                        },
                    },
                }
            },
            {
                target = vector4(-1.59, -0.32, 501.06, 89.71),
                targetSize = vector3(0.9, 0.8, 2.0),
                options = {
                    {
                        timeUsage = 7000,
                        targetIcon = "fa-solid fa-sink",
                        type = 'sink',
                        waterUsage = 5000, -- Mililiters
                        billType = 'water',
                        coords = {
                            particles = vector3(-1.788, -0.32, 501.164),
                            player = vector4(-0.89, -0.28, 500.12, 88.17),
                        },
                    },
                    {
                        timeUsage = 5000,
                        targetIcon = "fa-solid fa-glass-water-droplet",
                        type = 'sink_drink',
                        waterUsage = 300, -- Mililiters
                        billType = 'water',
                        coords = {
                            particles = vector3(-1.788, -0.32, 501.164),
                            player = vector4(-0.89, -0.28, 500.12, 88.17),
                        },
                    },
                }
            },
            {
                target = vector3(-1.2, -2.82, 500.14),
                targetSize = vector3(2.0, 1.1, 3.3),
                options = {
                    {
                        timeUsage = 10000,
                        targetIcon = "fa-solid fa-shower",
                        type = 'shower',
                        waterUsage = 120000, -- Mililiters
                        billType = 'water',
                        coords = {
                            particles = vector3(-1.664, -2.804, 502.353),
                            player = vector3(-1.3, -2.82, 500.14),
                        },
                    }
                },
            },
            {
                target = vector4(3.96, -6.49, 501.06, -91.36),
                targetSize = vector3(0.9, 0.8, 2.0),
                options = {
                    {
                        timeUsage = 7000,
                        targetIcon = "fa-solid fa-sink",
                        type = 'sink',
                        waterUsage = 5000, -- Mililiters
                        billType = 'water',
                        coords = {
                            particles = vector3(4.16, -6.491, 501.15),
                            player = vector4(3.33, -6.46, 500.12, 268.72),
                        },
                    },
                    {
                        timeUsage = 5000,
                        targetIcon = "fa-solid fa-glass-water-droplet",
                        type = 'sink_drink',
                        waterUsage = 300, -- Mililiters
                        billType = 'water',
                        coords = {
                            particles = vector3(4.16, -6.491, 501.15),
                            player = vector4(3.33, -6.46, 500.12, 268.72),
                        },
                    },
                }
            },
            {
                target = vector4(3.54, -3.82, 500.14, 174.9),
                targetSize = vector3(2.0, 1.1, 3.3),
                options = {
                    {
                        timeUsage = 10000,
                        targetIcon = "fa-solid fa-shower",
                        type = 'shower',
                        waterUsage = 120000, -- Mililiters
                        billType = 'water',
                        coords = {
                            particles = vector3(4.044, -3.832, 502.373),
                            player = vector4(3.79, -3.82, 500.14, 270.92),
                        },
                    }
                },
            },
        },
        images = {
            'shell/dc_townhouseone-1.png',
            'shell/dc_townhouseone-2.png',
            'shell/dc_townhouseone-3.png',
            'shell/dc_townhouseone-4.png',
            'shell/dc_townhouseone-5.png',
            'shell/dc_townhouseone-6.png',
            'shell/dc_townhouseone-7.png',
        },
    },

    ['dc_trapshellone'] = {
        label = 'dc_trapshellone',
        tags = {'furnished', 'dccustomz'},
        rooms = 2,
        model = 'dc_trapshellone',
        doors = {
            x = 0.23, y = 3.17, z = 498.75, heading = 91.97
        },
        images = {
            'shell/dc_trapshellone-1.png',
            'shell/dc_trapshellone-2.png',
            'shell/dc_trapshellone-3.png',
            'shell/dc_trapshellone-4.png',
        },
    },
    ['dc_trapshelltwo'] = {
        label = 'dc_trapshelltwo',
        tags = {'furnished', 'dccustomz'},
        rooms = 2,
        model = 'dc_trapshelltwo',
        doors = {
            x = 1.39, y = 3.77, z = 498.72, heading = 86.17
        },
        images = {
            'shell/dc_trapshelltwo-1.png',
            'shell/dc_trapshelltwo-2.png',
            'shell/dc_trapshelltwo-3.png',
            'shell/dc_trapshelltwo-4.png',
        },
    },
    ['dc_trapshellthree'] = {
        label = 'dc_trapshellthree',
        tags = {'furnished', 'dccustomz'},
        rooms = 3,
        model = 'dc_trapshellthree',
        doors = {
            x = 0.04, y = -6.09, z = 498.15, heading = 360.0
        },
        images = {
            'shell/dc_trapshellthree-1.png',
            'shell/dc_trapshellthree-2.png',
            'shell/dc_trapshellthree-3.png',
            'shell/dc_trapshellthree-4.png',
            'shell/dc_trapshellthree-5.png',
            'shell/dc_trapshellthree-6.png',
        },
    },

    ['dchotel_shell'] = {
        label = 'dchotel_shell',
        tags = {'furnished', 'dccustomz'},
        rooms = 1,
        model = 'dchotel_shell',
        doors = {
            x = 0.0, y = 4.38, z = 498.59, heading = 180.16
        },
        interactable = {
            {
                target = vector4(-1.9, 4.25, 499.56, 0.59),
                targetSize = vector3(0.9, 0.8, 2.0),
                options = {
                    {
                        timeUsage = 7000,
                        targetIcon = "fa-solid fa-sink",
                        type = 'sink',
                        waterUsage = 5000, -- Mililiters
                        billType = 'water',
                        coords = {
                            particles = vector3(-1.899, 4.386, 499.725),
                            player = vector4(-1.9, 3.67, 498.59, 358.86),
                        },
                    },
                    {
                        timeUsage = 5000,
                        targetIcon = "fa-solid fa-glass-water-droplet",
                        type = 'sink_drink',
                        waterUsage = 300, -- Mililiters
                        billType = 'water',
                        coords = {
                            particles = vector3(-1.899, 4.386, 499.725),
                            player = vector4(-1.9, 3.67, 498.59, 358.86),
                        },
                    },
                }
            },
            {
                target = vector4(-1.97, 2.45, 498.74, 6.12),
                targetSize = vector3(2.0, 1.1, 3.3),
                options = {
                    {
                        timeUsage = 10000,
                        targetIcon = "fa-solid fa-shower",
                        type = 'shower',
                        waterUsage = 120000, -- Mililiters
                        billType = 'water',
                        coords = {
                            particles = vector3(-2.542, 2.331, 500.719),
                            player = vector4(-2.13, 2.42, 498.74, 90.4),
                        },
                    }
                },
            },
        },
        images = {
            'shell/dchotel_shell-1.png',
            'shell/dchotel_shell-2.png',
            'shell/dchotel_shell-3.png',
        },
    },
}

addShells(shells)