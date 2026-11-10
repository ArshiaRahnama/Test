-- Pub by FleeX Team , https://discord.gg/87rGBxgCsa

configAsghar = {
    Price = 15000,
    ReviveTime = 15, -- seconds until you are revived
    Hospitals = {

        { -- MD 1
            Bed = { coords = vec(255.84, -1352.3, 25.52), heading = 317.0, occupied = false },
            Peds = { pedHash = -730659924, doctor = { coords = vec(255.2, -1351.74, 23.55), heading = 232.59 },
                reception = { coords = vec(1122.7, -1539.66, 34.87), heading = 12.99 },
            },
            Access = {
                ['all'] = true,
            }
        },

        { -- MD 2
            Bed = { coords = vec(255.84, -1352.3, 25.52), heading = 317.0, occupied = false }, -- hospitall new 2
            Peds = { pedHash = -730659924, doctor = { coords = vec(255.2, -1351.74, 23.55), heading = 232.59 },
                reception = { coords = vec(-1873.46, -321.98, 49.25), heading = 234.91 },
            },
            Access = {
                ['all'] = true,
            }
        },

        { -- MD palato
            Bed = { coords = vec(255.84, -1352.3, 25.52), heading = 317.0, occupied = false }, -- hospitall new
            Peds = { pedHash = -730659924, doctor = { coords = vec(255.2, -1351.74, 23.55), heading = 232.59 },
                reception = { coords = vec(-247.19, 6314.1, 32.43), heading = 45.36},
            },
            Access = {
                ['all'] = true,
            }
        },

        { -- justic
            Bed = { coords = vec(255.84, -1352.3, 25.52), heading = 317.0, occupied = false },
            Peds = { pedHash = -730659924, doctor = { coords = vec(255.2, -1351.74, 23.55), heading = 232.59 },
                reception = { coords = vec(-527.35, -167.54, 38.22), heading = 125.83},
            },
            Access = {
                ['all'] = false,
                ['fbi'] = true,
                ['justice'] = true,
            }
        },

        { -- justic 2
            Bed = { coords = vec(212.19, -432.12, 47.98), heading = 247.08, occupied = false },
            Peds = { pedHash = -730659924, doctor = { coords = vec(255.2, -1351.74, 23.55), heading = 232.59 },
                reception = { coords = vec(212.3, -432.04, 47.98), heading = 238.82},
            },
            Access = {
                ['all'] = false,
                ['fbi'] = true,
                ['justice'] = true,
            }
        },

        { -- PD 1
            Bed = { coords = vec(255.84, -1352.3, 25.52), heading = 317.0, occupied = false },
            Peds = { pedHash = -730659924, doctor = { coords = vec(255.2, -1351.74, 23.55), heading = 232.59 },
                reception = { coords = vec(471.73, -1013.71, 26.39), heading = 356.58 },
            },
            Access = {
                ['all'] = false,
                ['police'] = true,
                ['sheriff'] = true,
                ['mt'] = true,
                ['detective'] = true,
            }
        },

        { -- PD 2
            Bed = { coords = vec(255.84, -1352.3, 25.52), heading = 317.0, occupied = false },
            Peds = { pedHash = -730659924, doctor = { coords = vec(255.2, -1351.74, 23.55), heading = 232.59 },
                reception = { coords = vec(613.71, 11.71, 87.82), heading = 250.65},
            },
            Access = {
                ['all'] = false,
                ['police'] = true,
                ['sheriff'] = true,
                ['mt'] = true,
                ['detective'] = true,
            }
        },

        { -- PD 3
            Bed = { coords = vec(255.84, -1352.3, 25.52), heading = 317.0, occupied = false },
            Peds = { pedHash = -730659924, doctor = { coords = vec(255.2, -1351.74, 23.55), heading = 232.59 },
                reception = { coords = vec(-64.79, -2517.69, 7.39), heading = 330.19},
            },
            Access = {
                ['all'] = false,
                ['police'] = true,
                ['sheriff'] = true,
                ['mt'] = true,
                ['detective'] = true,
            }
        },

        { -- PD 4 ist Bazresi
            Bed = { coords = vec(255.84, -1352.3, 25.52), heading = 317.0, occupied = false },
            Peds = { pedHash = -730659924, doctor = { coords = vec(255.2, -1351.74, 23.55), heading = 232.59 },
                reception = { coords = vec(1543.3, 824.76, 82.13), heading = 235.49},
            },
            Access = {
                ['all'] = false,
                ['police'] = true,
                ['sheriff'] = true,
                ['mt'] = true,
                ['detective'] = true,
            }
        },

        { -- PD 5
            Bed = { coords = vec(255.84, -1352.3, 25.52), heading = 317.0, occupied = false },
            Peds = { pedHash = -730659924, doctor = { coords = vec(255.2, -1351.74, 23.55), heading = 232.59 },
                reception = { coords = vec(-1079.38, -836.91, 4.88), heading = 213.19},
            },
            Access = {
                ['all'] = false,
                ['police'] = true,
                ['sheriff'] = true,
                ['mt'] = true,
                ['detective'] = true,
            }
        },

        { -- PD 6 Army
            Bed = { coords = vec(255.84, -1352.3, 25.52), heading = 317.0, occupied = false },
            Peds = { pedHash = -730659924, doctor = { coords = vec(255.2, -1351.74, 23.55), heading = 232.59 },
                reception = { coords = vec(-2355.75, 3252.01, 32.81), heading = 67.34},
            },
            Access = {
                ['all'] = false,
                ['police'] = true,
                ['sheriff'] = true,
                ['mt'] = true,
                ['detective'] = true,
            }
        },

        { -- PD 7 Detective
            Bed = { coords = vec(255.84, -1352.3, 25.52), heading = 317.0, occupied = false },
            Peds = { pedHash = -730659924, doctor = { coords = vec(255.2, -1351.74, 23.55), heading = 232.59 },
                reception = { coords = vec(847.09, -1279.6, 28.25), heading = 179.06},
            },
            Access = {
                ['all'] = false,
                ['police'] = true,
                ['sheriff'] = true,
                ['mt'] = true,
                ['detective'] = true,
            }
        },

        { -- SH Sandy
            Bed = { coords = vec(255.84, -1352.3, 25.52), heading = 317.0, occupied = false },
            Peds = { pedHash = -730659924, doctor = { coords = vec(255.2, -1351.74, 23.55), heading = 232.59 },
                reception = { coords = vec(1837.29, 3672.94, 34.33), heading = 299.04},
            },
            Access = {
                ['all'] = false,
                ['police'] = true,
                ['sheriff'] = true,
                ['mt'] = true,
                ['detective'] = true,
            }
        },

        { -- SH Paleto
            Bed = { coords = vec(255.84, -1352.3, 25.52), heading = 317.0, occupied = false },
            Peds = { pedHash = -730659924, doctor = { coords = vec(255.2, -1351.74, 23.55), heading = 232.59 },
                reception = { coords = vec(-440.0, 5992.02, 31.72), heading = 222.41},
            },
            Access = {
                ['all'] = false,
                ['police'] = true,
                ['sheriff'] = true,
                ['mt'] = true,
                ['detective'] = true,
            }
        },

    },
}

asgharStrings = {
    ['get_help'] = [[Press %s to get help for ~g~$%s]],
    ['not_enough'] = [[You don't have enough money!]],
    ['getting_help'] = [[You are getting help, %s seconds left!]],
    ['occupied'] = [[The bed is occupied! Come back later]]
}