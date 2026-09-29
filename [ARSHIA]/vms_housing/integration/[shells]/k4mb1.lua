if not Config.Shells.K4MB1 then
    return
end

local shells = {
    ['standardmotel_shell'] = {
        label = 'Standard Motel',

        tags = {'furnished', 'k4mb1'},
        rooms = 1,

        model = 'standardmotel_shell',

        doors = {
            x = -0.34,
            y = -2.46,
            z = 498.44,
            heading = 273.05
        },

        interactable = {
            {
                target = vector4(-3.05, 1.9, 499.18, 89.42),
                targetSize = vector3(0.9, 0.8, 2.0),
                options = {
                    {
                        timeUsage = 7000,
                        targetIcon = "fa-solid fa-sink",
                        type = 'sink',
                        waterUsage = 5000, -- Mililiters
                        billType = 'water',
                        coords = {
                            particles = vector3(-3.181917, 1.890949, 499.4141),
                            player = vector4(-2.36, 1.91, 498.45, 91.9),
                        },
                    },
                    {
                        timeUsage = 5000,
                        targetIcon = "fa-solid fa-glass-water-droplet",
                        type = 'sink_drink',
                        waterUsage = 300, -- Mililiters
                        billType = 'water',
                        coords = {
                            particles = vector3(-3.181917, 1.890949, 499.4141),
                            player = vector4(-2.36, 1.91, 498.45, 91.9),
                        },
                    },
                }
            },
            {
                target = vector4(-2.47, 0.68, 499.52, 173.06),
                targetSize = vector3(2.0, 1.1, 3.3),
                options = {
                    {
                        timeUsage = 10000,
                        targetIcon = "fa-solid fa-shower",
                        type = 'shower',
                        waterUsage = 120000, -- Mililiters
                        billType = 'water',
                        coords = {
                            particles = vector3(-2.808648, 0.9071249, 500.7754),
                            player = vector4(-2.61, 0.7, 498.52, 86.88),
                        },
                    }
                },
            },
        },
        
        images = {
            'shell/standardmotel_shell-1.png',
            'shell/standardmotel_shell-2.png',
        },
    },
    
    ['modernhotel_shell'] = {
        label = 'Modern Hotel',

        tags = {'furnished', 'k4mb1'},
        rooms = 1,

        model = 'modernhotel_shell',

        doors = {
            x = 4.93,
            y = 4.13,
            z = 498.18,
            heading = 180.57,
        },
        images = {
            'shell/modernhotel_shell-1.png',
        },
    },

    ['shell_v16low'] = {
        label = 'Apartment Low',

        tags = {'empty', 'k4mb1'},
        rooms = 1,

        model = 'shell_v16low',

        doors = {
            x = 4.7,
            y = -6.5,
            z = 497.35,
            heading = 5.42,
        },

        interactable = {
            {
                target = vector4(4.09, 6.22, 500.31, -2.14),
                targetSize = vector3(0.9, 0.8, 2.0),
                options = {
                    {
                        timeUsage = 7000,
                        targetIcon = "fa-solid fa-sink",
                        type = 'sink',
                        waterUsage = 5000, -- Mililiters
                        billType = 'water',
                        coords = {
                            particles = vector3(4.187847, 6.333992, 500.5624),
                            player = vector4(4.25, 5.54, 499.35, 359.04),
                        },
                    },
                    {
                        timeUsage = 5000,
                        targetIcon = "fa-solid fa-glass-water-droplet",
                        type = 'sink_drink',
                        waterUsage = 300, -- Mililiters
                        billType = 'water',
                        coords = {
                            particles = vector3(4.187847, 6.333992, 500.5624),
                            player = vector4(4.25, 5.54, 499.35, 359.04),
                        },
                    },
                }
            },
        },

        images = {
            'shell/shell_v16low-1.png',
            'shell/shell_v16low-2.png',
            'shell/shell_v16low-3.png',
        },
    },

    ['shell_v16mid'] = {
        label = 'Apartment Mid',

        tags = {'empty', 'k4mb1'},
        rooms = 2,

        model = 'shell_v16mid',

        doors = {
            x = 1.42,
            y = -14.06,
            z = 498.51,
            heading = 352.43,
        },

        interactable = {
            {
                target = vector4(1.77, 4.58, 499.5, 89.4),
                targetSize = vector3(0.9, 0.8, 2.0),
                options = {
                    {
                        timeUsage = 7000,
                        targetIcon = "fa-solid fa-sink",
                        type = 'sink',
                        waterUsage = 5000, -- Mililiters
                        billType = 'water',
                        coords = {
                            particles = vector3(1.490127, 4.577723, 499.4692),
                            player = vector4(2.13, 4.6, 498.51, 91.81),
                        },
                    },
                    {
                        timeUsage = 5000,
                        targetIcon = "fa-solid fa-glass-water-droplet",
                        type = 'sink_drink',
                        waterUsage = 300, -- Mililiters
                        billType = 'water',
                        coords = {
                            particles = vector3(1.490127, 4.577723, 499.4692),
                            player = vector4(2.13, 4.6, 498.51, 91.81),
                        },
                    },
                }
            },
            {
                target = vector4(2.18, 3.31, 499.55, 174.5),
                targetSize = vector3(2.0, 1.1, 3.3),
                options = {
                    {
                        timeUsage = 10000,
                        targetIcon = "fa-solid fa-shower",
                        type = 'shower',
                        waterUsage = 120000, -- Mililiters
                        billType = 'water',
                        coords = {
                            particles = vector3(1.83032, 3.569566, 500.8185),
                            player = vector4(2.05, 3.45, 498.55, 93.26),
                        },
                    }
                },
            },
        },
        
        images = {
            'shell/shell_v16mid-1.png',
            'shell/shell_v16mid-2.png',
            'shell/shell_v16mid-3.png',
            'shell/shell_v16mid-4.png',
            'shell/shell_v16mid-5.png',
            'shell/shell_v16mid-6.png',
        },
    },

    ['shell_frankaunt'] = {
        label = 'Franklin Home',

        tags = {'empty', 'k4mb1'},
        rooms = 4,

        model = 'shell_frankaunt',

        doors = {
            x = -0.34,
            y = -5.64,
            z = 498.43,
            heading = 3.4,
        },
        
        interactable = {
            {
                target = vector4(-3.26, -2.72, 499.26, -173.82),
                targetSize = vector3(0.9, 0.8, 2.0),
                options = {
                    {
                        timeUsage = 7000,
                        targetIcon = "fa-solid fa-sink",
                        type = 'sink',
                        waterUsage = 5000, -- Mililiters
                        billType = 'water',
                        coords = {
                            particles = vector3(-3.058464, -2.782931, 499.4339),
                            player = vector4(-3.24, -1.97, 498.43, 178.36),
                        },
                    },
                    {
                        timeUsage = 5000,
                        targetIcon = "fa-solid fa-glass-water-droplet",
                        type = 'sink_drink',
                        waterUsage = 300, -- Mililiters
                        billType = 'water',
                        coords = {
                            particles = vector3(-3.058464, -2.782931, 499.4339),
                            player = vector4(-3.24, -1.97, 498.43, 178.36),
                        },
                    },
                }
            },
            {
                target = vector4(-5.15, -1.92, 498.56, 88.45),
                targetSize = vector3(2.0, 1.1, 3.3),
                options = {
                    {
                        timeUsage = 10000,
                        targetIcon = "fa-solid fa-shower",
                        type = 'shower',
                        waterUsage = 120000, -- Mililiters
                        billType = 'water',
                        coords = {
                            particles = vector3(-5.021169, -2.469955, 500.576),
                            player = vector4(-5.12, -2.2, 498.55, 180.31),
                        },
                    }
                },
            },
        },

        images = {
            'shell/shell_frankaunt-1.png',
            'shell/shell_frankaunt-2.png',
            'shell/shell_frankaunt-3.png',
            'shell/shell_frankaunt-4.png',
            'shell/shell_frankaunt-5.png',
            'shell/shell_frankaunt-6.png',
            'shell/shell_frankaunt-7.png',
            'shell/shell_frankaunt-8.png',
            'shell/shell_frankaunt-9.png',
        },
    },

    ['shell_michael'] = {
        label = 'Michael Home',

        tags = {'empty', 'k4mb1'},
        rooms = 6,

        model = 'shell_michael',

        doors = {
            x = -9.33,
            y = 5.68,
            z = 494.94,
            heading = 271.62,
        },

        images = {
            'shell/shell_michael-1.png',
            'shell/shell_michael-2.png',
            'shell/shell_michael-3.png',
            'shell/shell_michael-4.png',
            'shell/shell_michael-5.png',
            'shell/shell_michael-6.png',
            'shell/shell_michael-7.png',
            'shell/shell_michael-8.png',
            'shell/shell_michael-9.png',
        },
    },
    
    ['shell_trevor'] = {
        label = 'Trevor Home',

        tags = {'empty', 'k4mb1'},
        rooms = 3,

        model = 'shell_trevor',

        doors = {
            x = 0.18,
            y = -3.63,
            z = 498.59,
            heading = 0.21,
        },

        interactable = {
            {
                target = vector4(3.24, -3.77, 499.3, 180.43),
                targetSize = vector3(0.9, 0.8, 2.0),
                options = {
                    {
                        timeUsage = 7000,
                        targetIcon = "fa-solid fa-sink",
                        type = 'sink',
                        waterUsage = 5000, -- Mililiters
                        billType = 'water',
                        coords = {
                            particles = vector3(3.180808, -3.843895, 499.55),
                            player = vector4(3.2, -3.16, 498.6, 179.47),
                        },
                    },
                    {
                        timeUsage = 5000,
                        targetIcon = "fa-solid fa-glass-water-droplet",
                        type = 'sink_drink',
                        waterUsage = 300, -- Mililiters
                        billType = 'water',
                        coords = {
                            particles = vector3(3.180808, -3.843895, 499.55),
                            player = vector4(3.2, -3.16, 498.6, 179.47),
                        },
                    },
                }
            },
            {
                target = vector4(4.16, -3.07, 499.6, 269.61),
                targetSize = vector3(2.0, 1.1, 3.3),
                options = {
                    {
                        timeUsage = 10000,
                        targetIcon = "fa-solid fa-shower",
                        type = 'shower',
                        waterUsage = 120000, -- Mililiters
                        billType = 'water',
                        coords = {
                            particles = vector3(3.989548, -3.665935, 500.6445),
                            player = vector4(4.14, -3.62, 498.45, 167.56),
                        },
                    }
                },
            },
        },
        
        images = {
            'shell/shell_trevor-1.png',
            'shell/shell_trevor-2.png',
            'shell/shell_trevor-3.png',
            'shell/shell_trevor-4.png',
            'shell/shell_trevor-5.png',
            'shell/shell_trevor-6.png',
        },
    },
    
    ['shell_trailer'] = {
        label = 'Trailer',

        tags = {'empty', 'k4mb1'},
        rooms = 2,

        model = 'shell_trailer',

        doors = {
            x = -1.37,
            y = -1.95,
            z = 498.52,
            heading = 2.67,
        },
        
        interactable = {
            {
                target = vector4(-1.88, 2.15, 499.46, 0.21),
                targetSize = vector3(0.9, 0.8, 2.0),
                options = {
                    {
                        timeUsage = 7000,
                        targetIcon = "fa-solid fa-sink",
                        type = 'sink',
                        waterUsage = 5000, -- Mililiters
                        billType = 'water',
                        coords = {
                            particles = vector3(-1.816921, 2.166766, 499.499),
                            player = vector4(-1.89, 1.49, 498.52, 359.35),
                        },
                    },
                    {
                        timeUsage = 5000,
                        targetIcon = "fa-solid fa-glass-water-droplet",
                        type = 'sink_drink',
                        waterUsage = 300, -- Mililiters
                        billType = 'water',
                        coords = {
                            particles = vector3(-1.816921, 2.166766, 499.499),
                            player = vector4(-1.89, 1.49, 498.52, 359.35),
                        },
                    },
                }
            },
            {
                -- marker = vector3(-2.92, 1.7, 499.4),
                target = vector4(-2.92, 1.7, 499.4, 2.7),
                targetSize = vector3(2.0, 1.1, 3.3),
                options = {
                    {
                        timeUsage = 10000,
                        targetIcon = "fa-solid fa-shower",
                        type = 'shower',
                        waterUsage = 120000, -- Mililiters
                        billType = 'water',
                        coords = {
                            particles = vector3(-2.978536, 1.983136, 500.724),
                            player = vector4(-2.92, 1.7, 498.55, 2.7),
                        },
                    }
                },
            },
        },

        images = {
            'shell/shell_trailer-1.png',
            'shell/shell_trailer-2.png',
            'shell/shell_trailer-3.png',
        },
    },
    
    ['shell_garagem'] = {
        label = 'Garage',

        tags = {'empty', 'k4mb1'},
        rooms = 1,

        model = 'shell_garagem',

        doors = {
            x = 3.64,
            y = -7.03,
            z = 498.25,
            heading = 0.43,
        },
        
        images = {
            'shell/shell_garagem-1.png',
            'shell/shell_garagem-2.png',
        },
    },

    ['shell_warehouse1'] = {
        label = 'Warehouse',

        tags = {'empty', 'k4mb1'},
        rooms = 1,

        model = 'shell_warehouse1',
        
        doors = {
            x = 8.48,
            y = 0.12,
            z = 498.05,
            heading = 88.87,
        },
        
        images = {
            'shell/shell_warehouse1-1.png',
            'shell/shell_warehouse1-2.png',
        },
    },
    
    ['container_shell'] = {
        label = 'Container',

        tags = {'empty', 'k4mb1'},
        rooms = 1,

        model = 'container_shell',

        doors = {
            x = -0.02,
            y = -5.54,
            z = 498.79,
            heading = 2.64,
        },
        
        images = {
            'shell/container_shell-1.png',
            'shell/container_shell-2.png',
        },
    },
}

addShells(shells)