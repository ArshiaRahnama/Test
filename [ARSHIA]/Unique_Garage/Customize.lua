
Customize = {}

Customize.ESX = "ESX"

Customize.Mysql = "oxmysql"

Customize.GetVehFuel = function(Veh)
    return exports['LegacyFuel']:GetFuel(Veh)
end
Customize.SetVehFuel = function(Veh, Fuel)
    return exports['LegacyFuel']:SetFuel(Veh, Fuel)
end

Customize.GaragesPrice = 0
Customize.ImpoundGaragesPrice = 600
Customize.JobGaragesPrice = 1

Customize.UseDamageMult = true
Customize.DamageMult    = 8

Customize.BoatPoundPrice     = 50000
Customize.AircraftPoundPrice = 100000

-- =====================================================================
--  Unique garage settings (ported from the reference garage config)
-- =====================================================================
Customize.CarPoundPrice      = 5000      -- Car pound price (also used as repair base price)
Customize.AircraftPoundPrice = 100000
Customize.BoatPoundPrice     = 50000
Customize.UseDamageMult      = true
Customize.DamageMult         = 8         -- higher = repair on park costs more

-- Garage transfer (move a vehicle to another garage): minutes -> price
Customize.TransferOptions = {
    { minutes = 5,  price = 20000, label = '20K(5 Minutes)'  },
    { minutes = 10, price = 10000, label = '10K(10 Minutes)' },
    { minutes = 20, price = 5000,  label = '5K(15 Minutes)'  },
}

-- Vehicle thumbnails shown in the garage UI (docs.fivem.net hosts every GTA vehicle)
Customize.VehicleImageUrl    = 'https://docs.fivem.net/vehicles/%s.webp'

-- Parking meter behaviour (same values as the reference garage)
Customize.ParkMeterBlockedModels = { `stockade` }
Customize.ParkMeterMaxSpeed      = 10      -- km/h, must be slower than this to park
Customize.ParkMeterAutoParkDelay = 15      -- seconds after walking >5m away from the vehicle
Customize.ParkMeterStreamIn      = 120.0   -- preview vehicles of other players are shown within this range
Customize.ParkMeterStreamOut     = 160.0
-- Optional trunk hook for vehicles parked in a meter (e.g. open your inventory trunk). nil = no trunk option.
Customize.OpenTrunk = nil -- function(vehicle, plate) exports['ox_inventory']:openInventory('trunk', {id = 'trunk'..plate}) end

Customize.Zones = {
    spawnCar = {
        label = '[E]',
        icon = 'fa-solid fa-square-parking fa-beat',
        type = 'car',
        label2 = 'Mashin',
        coords = {
			{ -- garag 4 => 1
                garagePoint = vec(-300.55, -905.57, 31.6, 30.0),
                spawnPoints = {
					{ coords = vec(-296.29, -886.75, 31.08, 167.32) },
					{ coords = vec(-303.63, -885.18, 31.08, 167.68) },
					{ coords = vec(-311.05, -882.21, 31.08, 172.74) },
					{ coords = vec(-309.42, -897.34, 31.08, 346.40) },
					{ coords = vec(-316.66, -894.55, 31.08, 348.19) },
					{ coords = vec(-323.87, -894.85, 31.08, 352.24) },
                },
				blip = vec(-300.55, -905.57, 31.61),
            },
            { -- garag 2
                garagePoint = vec(119.34, -1068.67, 29.37, 22.0),
                spawnPoints = {
                    { coords = vec(107.55, -1063.97, 28.80, 244.74) },
                    { coords = vec(108.65, -1060.05, 28.80, 244.60) },
                    { coords = vec(110.00, -1056.76, 28.81, 245.52) },
                    { coords = vec(107.96, -1079.91, 29.19, 348.24) },
                    { coords = vec(111.65, -1081.35, 29.19, 338.46) },
                    { coords = vec(117.63, -1082.73, 29.19, 357.2)  },
                },
				blip = vec(122.96, -1068.51, 29.19),
            },
			{ -- garag 3
                garagePoint = vec(373.0, 281.15, 103.37, 23.0),
                spawnPoints = {
					{ coords = vec(370.91, 284.20, 102.91, 340.21) },
					{ coords = vec(374.62, 283.26, 102.84, 339.46) },
					{ coords = vec(378.83, 282.10, 102.76, 337.78) },
					{ coords = vec(375.70, 273.62, 102.72, 160.62) },
					{ coords = vec(371.89, 275.29, 102.78, 160.69) },
					{ coords = vec(368.27, 276.88, 102.84, 158.64) },
                },
				blip = vec(373.0, 281.15, 103.37),
            },
			{ -- garag 1 => 4
                garagePoint = vec(240.77, -792.27, 30.48, 35.0),
                spawnPoints = {
                    { coords = vec(229.72, -806.15, 30.51, 160.0) },
                    { coords = vec(232.32, -798.26, 30.55, 160.0) },
                    { coords = vec(235.02, -791.21, 30.57, 160.0) },
                    { coords = vec(237.81, -784.33, 30.61, 160.0) },
                    { coords = vec(240.43, -776.32, 30.68, 160.0) },
                },
                blip = vec(216.85, -810.03, 30.71),
            },
			{ -- garag 5
                garagePoint = vec(1730.04, 3719.86, 34.07, 12.0),
                spawnPoints = {
					{ coords = vec(1737.84, 3719.28, 33.04, 21.22) },
                },
				blip = vec(1730.04, 3719.86, 34.07),
            },
			{ -- garag 6
                garagePoint = vec(130.05, 6606.26, 31.85, 23.0),
                spawnPoints = {
					{ coords = vec(128.78, 6622.99, 30.78, 315.01) },
                },
				blip = vec(130.05, 6606.26, 31.85),
            },
			{ -- garag 7 paintball 
				garagePoint = vec(-1620.85, 5123.33, 19.79, 18.0),
				spawnPoints = {
					{ coords = vec(-1632.97, 5115.16, 19.79, 300.47) },
					{ coords = vec(-1636.50, 5121.26, 19.79, 297.85) },
					{ coords = vec(-1625.99, 5133.77, 19.79, 210.43) },
				},
				blip = vec(-1620.85, 5123.33, 19.79),
			},
			{ -- garag 8 bimarestan
				garagePoint = vec(1196.37, -1382.36, 35.22, 15.0),
				spawnPoints = {
					{ coords = vec(1198.35, -1402.86, 35.22, 180.96) },
				},
				blip = vec(1196.37, -1382.36, 35.22),
			},
			{ -- garag 9 PD2
				garagePoint = vec(610.24, 95.89, 92.54, 20.0),
				spawnPoints = {
					{ coords = vec(600.2 , 97.82, 92.33, 246.48) },
				},
				blip = vec(610.24, 95.89, 92.54),
			},
			{ -- garag 10 saheli
				garagePoint = vec(-2036.26, -471.74, 11.42, 25.0),
				spawnPoints = {
					{ coords = vec(-2024.47 , -472.47, 11.4, 319.31) },
				},
				blip = vec(-2036.26, -471.74, 11.42),
			},
			{ -- garag 11 Island tp
				garagePoint = vec(540.35, -3044.67, 6.07, 15.0),
				spawnPoints = {
					{ coords = vec(542.86 , -3051.0, 6.07, 2.47) },
				},
				blip = vec(540.35, -3044.67, 6.07),
			},
		},
    },
	spawnHeli = {
        label = '[E]',
        icon = 'fa-solid fa-square-parking fa-beat',
        type = 'heli',
        label2 = 'Forodgah',
        coords = {
            { -- foroodgah payin
				garagePoint = vec(-1653.2, -3145.96, 14.0, 35.0),
				spawnPoints = {
					{ coords = vec(-1653.1, -3144.63, 13.99, 327.71) }
				},
				blip = vec(-1653.2, -3145.96, 14.0),
			},
            { -- foroodgah sandy
				garagePoint = vec(1731.46, 3311.55, 41.22, 15.0),
				spawnPoints = {
					{ coords = vec(1712.9, 3252.9, 41.07, 106.75) }
				},
				blip = vec(1731.78, 3312.25, 41.22),
			},
            { -- foroodgah sandy mythic
				garagePoint = vec(2123.97, 4801.5, 41.03, 30.0),
				spawnPoints = {
					{ coords = vec(2123.97, 4801.5, 41.03, 112.62) }
				},
				blip = vec(2123.97, 4801.5, 41.03),
			},
            { -- paintball 1 
				garagePoint = vec(-1619.75, 5153.14, 21.52, 8.0),
				spawnPoints = {
					{ coords = vec(-1619.75, 5153.14, 21.52, 90.0) }
				},
				blip = vec(-1619.75, 5153.14, 21.52),
			},
            { -- paintball 2 
				garagePoint = vec(-1645.35, 5138.98, 21.52, 8.0),
				spawnPoints = {
					{ coords = vec(-1645.35, 5138.98, 21.52, 120.0) }
				},
				blip = vec(-1645.35, 5138.98, 21.52),
			},
        },
    },
	spawnboat = {
        label = '[E]',
        icon = 'fa-solid fa-square-parking fa-beat',
        type = 'boat',
        label2 = 'Eskele',
        coords = {
            { -- boat 1
				garagePoint = vec(-719.19, -1332.64, -0.51, 15.0),
				spawnPoints = {
					{ coords = vec(-717.4, -1335.54, -0.05, 137.21) }
				},
				blip = vec(-718.71, -1326.65, 1.6),
			},
            { -- boat 2
				garagePoint = vec(1334.78, 4264.06, 29.59, 10.0),
				spawnPoints = {
					{ coords = vec(1334.24, 4263.36, 30.24, 253.88) }
				},
				blip = vec(1333.87, 4269.66, 31.5),
			},
            { -- boat 3
				garagePoint = vec(-291.56, 6616.12, -0.24, 25.0),
				spawnPoints = {
					{ coords = vec(-291.56, 6616.71, -0.22, 39.18) }
				},
				blip = vec(-282.15, 6626.02, 7.25),
			},
            { -- boat 4
				garagePoint = vec(-1600.48, 5262.57, 0.31, 15.0),
				spawnPoints = {
					{ coords = vec(-1600.48, 5262.57, 0.31, 17.67) }
				},
				blip = vec(-1608.06, 5263.9, 3.97),
			},
			{ -- boat 5
				garagePoint = vec(-1425.99, -1612.04, 1.16, 20.0),
				spawnPoints = {
					{ coords = vec(-1438.92, -1631.62, -0.08, 26.94) }
				},
				blip = vec(-1431.97, -1616.13, 5.63),
			},
			{ -- boat 6
				garagePoint = vec(-1886.41, -862.61, 0.68, 10.0),
				spawnPoints = {
					{ coords = vec(-1886.41, -862.61, 0.68, 127.66) }
				},
				blip = vec(-1886.41, -862.61, 0.68),
			},
			{ -- boat 7
				garagePoint = vec(-2012.26, -1043.71, 0.53, 15.0),
				spawnPoints = {
					{ coords = vec(-2012.26, -1043.71, 0.53, 322.3) }
				},
				blip = vec(-2017.88, -1039.86, 2.45),
			},
			{ -- boat 8
				garagePoint = vec(1527.8, 3898.48, 31.63, 25.0),
				spawnPoints = {
					{ coords = vec(1517.46, 3891.59, 30.28, 78.42) }
				},
				blip = vec(1532.59, 3913.9, 31.64),
			},
			{ -- boat 9
				garagePoint = vec(631.74, -3114.03, 0.66, 10.0),
				spawnPoints = {
					{ coords = vec(631.59, -3114.05, 0.59, 190.46) }
				},
				blip = vec(622.86, -3119.54, 6.06),
			},
        },
    },
}


Customize.Pounds = {
	vec(432.47, -986.26, 30.71, 359.08),-- pd1
	vec(636.68, -2.66, 82.79, 241.89),-- pd2
	vec(1778.29, 3644.71, 35.63, 209.23),-- sandy
	vec(-445.72, 6023.11, 31.49, 305.85),-- paleto
	vec(-1113.03, -839.84, 19.32, 131.78),-- pd5
}


Customize.PoundPed = {
	`s_f_y_cop_01`
}


Customize.ParkMeter = {

--- aparteman
	-- aparteman dakhele shahr
    { coords = vec(753.63, -1753.43, 29.22, 86.24),		range = 12 },	-- Aparteman 1
	{ coords = vec(789.65, -1757.98, 29.39, 261.24),	range = 25 },	-- Aparteman 1
    { coords = vec(961.21, -201.38, 73.11, 326.73),		range = 20 },	-- Aparteman 5
    { coords = vec(-796.13, 300.93, 85.71, 179.04),		range = 22 },	-- Aparteman 1
	{ coords = vec(-752.94, 305.31, 85.69, 89.38),		range = 21 },	-- Aparteman 1
	{ coords = vec(-1277.8, 280.59, 64.87, 198.4),		range = 30 },	-- Aparteman 4
    { coords = vec(-1412.04, -529.98, 31.53, 214.0),	range = 25 },	-- Aparteman 7
    { coords = vec(-821.09, -1203.87, 6.93, 60.29),		range = 16 },	-- Aparteman 3
	{ coords = vec(-840.77, -1229.28, 6.93, 47.5),		range = 16 },	-- Aparteman 3
    { coords = vec(-885.1, -2108.43, 8.86, 312.76),		range = 20 },	-- Aparteman 6
	-- aparteman birun shahr
	{ coords = vec(1121.57, 2652.13, 38.0, 0.59),		range = 20 },	-- Aparteman 2 kenare mechanicki sandy
	{ coords = vec(1594.39, 3620.69, 35.15, 31.72),		range = 27 },	-- Aparteman 9 kenare sheriff sandy
	{ coords = vec(-84.64, 6345.09, 31.49, 138.36),		range = 23 },	-- kenare banke paleto

-- Robs
    { coords = vec(-1309.24, -853.54, 15.82, 34.25),	range = 5  },	-- maze bank
    { coords = vec(254.79, 189.37, 104.84, 66.72), 		range = 5  },	-- Center Bank
	{ coords = vec(220.69, 175.92, 105.28, 250.24),		range = 5  },	-- Center Bank2
    { coords = vec(-125.96, 6478.01, 31.47, 134.92),	range = 5  },	-- Bank Sheriff
    { coords = vec(-2955.91, 492.85, 15.31, 84.07),		range = 5  },	-- Bank Sahel
    { coords = vec(-1100.78, -259.02, 37.69, 197.54),	range = 3  },	-- Bimeh
    { coords = vec(-669.54, -225.84, 37.18, 136.25),	range = 20 },	-- javaheri
    { coords = vec(2781.25, 3460.39, 55.47, 160.11),	range = 30 },	-- javaheri Shams
    { coords = vec(298.17, -268.35, 54.02, 339.93),		range = 10 },	-- mini bank 1
    { coords = vec(-349.56, -33.56, 47.44, 71.76), 		range = 10 },	-- mini bank 2
    { coords = vec(-1193.0, -318.24, 37.71, 31.8), 		range = 10 },	-- mini bank 3
    { coords = vec(1192.75, 2695.76, 37.93, 99.34),		range = 10 },	-- mini bank 4
    { coords = vec(2415.85, 4967.97, 46.12, 133.79),	range = 10 },	-- MyThic
    { coords = vec(-1028.74, 4923.29, 204.23, 333.43),	range = 5  },	-- Cargo
	{ coords = vec(820.35, -2052.61, 29.41, 82.66),		range = 10 },	-- jawaheri flat
	{ coords = vec(822.61, -1973.25, 29.18, 358.03),	range = 10 },	-- jawaheri flat
	{ coords = vec(-1030.73, -2726.92, 20.21, 251.1),	range = 30 },	-- airport
	{ coords = vec(822.45, -2141.07, 28.97, 356.17),	range = 20 },	-- GunShop robbery
	{ coords = vec(-223.0, -1304.91, 31.34, 272.53), 	range = 10 },	-- benny

-- Jobs
	{ coords = vec(855.07, -1586.73, 31.25, 7.55), 		range = 15 },	-- minery start
    { coords = vec(846.22, -1558.94, 29.82, 22.56),		range = 15 },	-- minery start
	{ coords = vec(898.71, -1572.15, 30.85, 90.44),		range = 20 },	-- minery start
    { coords = vec(1063.59, -1963.97, 31.01, 1.32),		range = 30 },	-- minery zob
    { coords = vec(2953.62, 2789.0, 41.53, 201.26),		range = 130,    -- minery sang
		outputCoords = {
			vec(2906.3, 2857.43, 64.12, 102.91),
			vec(2900.99, 2721.26, 72.06, 37.12),
			vec(2972.53, 2888.29, 59.15, 127.61),
			vec(2920.01, 2719.65, 63.36, 25.83),
			vec(2871.86, 2753.93, 67.74, 43.2),
			vec(2890.21, 2758.93, 60.89, 39.47),
			vec(2943.87, 2861.33, 57.41, 112.4)
		}
	},
	{ coords = vec(128.18, -1452.31, 29.29, 51.6), 		range = 15 },	-- barbari
    { coords = vec(-1057.8, -2019.48, 13.16, 136.13),	range = 7  },	-- ghasab
	{ coords = vec(-59.87, 6286.81, 36.05, 323.43),		range = 8  },	-- ghasab farm
	{ coords = vec(-82.22, 6277.8, 31.33, 129.44),		range = 14 },	-- ghasab farm
    { coords = vec(1205.69, -1266.3, 35.23, 172.99),	range = 15 },	-- choob bor

    { coords = vec(745.93, -982.02, 24.75, 273.03),		range = 30 },	-- khayat 1
	{ coords = vec(691.67, -985.9, 23.68, 264.66),		range = 26 },	-- khayat 2

    { coords = vec(1968.83, 5179.96, 47.89, 140.8),		range = 50 },	-- khayat 3

    { coords = vec(550.75, -2307.61, 5.88, 263.27),		range = 15 },	-- sherkat naft 
	{ coords = vec(609.95, 2876.33, 39.41, 71.43),		range = 20 },	-- sherkat naft 2
    { coords = vec(596.57, 2839.14, 39.98, 359.7),		range = 25 },	-- sherkat naft 2
	{ coords = vec(628.03, 2857.23, 38.77, 16.87),		range = 8 },	-- sherkat naft 2

    { coords = vec(627.86, 2841.59, 43.9, 52.16),		range = 9 },	-- sherkat naft heli
    { coords = vec(285.46, -2989.04, 10.36, 90.83),		range = 9 },	-- sherkat naft heli essence
	{ coords = vec(3606.44, 3776.98, 33.27, 195.92),	range = 9 },	-- opum

	{ coords = vec(-576.12, 5251.35, 70.47, 336.33), 	range = 10 },	-- shekar
	{ coords = vec(-592.14, 5259.6, 71.24, 335.28),  	range = 7  },	-- shekar heli

	{ coords = vec(-507.74, 5268.54, 80.61, 155.37), 	range = 10 }, -- Baste Alvar
	{ coords = vec(-580.44, 5314.62, 70.21, 154.63), 	range = 10 }, -- Alvar
	{ coords = vec(-546.48, 5377.82, 70.55, 78.01), 	range = 10 }, -- Choob
	{ coords = vec(2727.93, 1418.23, 24.47, 187.42), 	range = 10 }, -- Rafin 1
	{ coords = vec(2740.61, 1407.35, 24.51, 93.38), 	range = 10 }, -- Rafin 2
	{ coords = vec(264.41, -3027.58, 5.74, 179.44), 	range = 10 }, -- Asans 1
	{ coords = vec(264.52, -2999.23, 5.74, 356.94), 	range = 10 }, -- Asans 2
	{ coords = vec(137.68, -3189.33, 5.86, 176.0), 		range = 10 }, -- extra
	{ coords = vec(137.67, -3210.38, 5.86, 353.69), 	range = 10 }, -- extra


	{ coords = vec(2305.59, 2588.64, 50.94, 266.61), 	range = 8 }, -- marijuana heli
	{ coords = vec(101.45, -3200.03, 10.37, 268.83), 	range = 8 }, -- extra heli
	{ coords = vec(-259.75, 6361.71, 37.05, 133.12), 	range = 8 }, -- medic paleto heli


-- job dolati
    -- taxi
    { coords = vec(388.12, -1633.16, 29.29, 323.56),	range = 5  },
	{ coords = vec(355.59, -1574.2, 29.3, 322.86), 		range = 10 },
	{ coords = vec(413.64, -1561.0, 29.14, 137.33),		range = 10 }, -- taxi event
	{ coords = vec(396.13, -1489.64, 29.28, 24.31), 	range = 10 }, -- taxi event
    -- medic
    { coords = vec(-233.88, 6307.11, 31.33, 140.02),	range = 10 },
	-- MC tune
	{ coords = vec(168.6, -3048.44, 5.84, 266.12),		range = 10 },
	-- Roberoye Bimarestan 1
	{ coords = vec(1171.79, -1422.88, 34.57, 87.72),	range = 12 },
	{ coords = vec(1116.01, -1443.88, 35.96, 268.71),	range = 12 },
	{ coords = vec(1185.17, -1446.76, 34.85, 268.48),	range = 12 },
	{ coords = vec(1160.73, -1446.76, 34.61, 267.2),	range = 12 },
	{ coords = vec(1138.27, -1445.97, 34.6, 270.32),	range = 10 },
    -- Roberoye Bimarestan 2
	{ coords = vec(-1855.9, -401.26, 46.2, 56.34),		range = 21 },
	{ coords = vec(-1886.75, -374.47, 48.76, 48.59),	range = 20 },
	-- FBI NEW
	{ coords = vec(56.31, -744.78, 44.14, 347.33),		range = 10 },	-- FBI 1
	{ coords = vec(2541.64, -384.07, 92.99, 262.93),	range = 30 },	-- fbi 2
    -- mechanic
    { coords = vec(1360.75, -715.31, 66.39, 76.15),		range = 10 },
	{ coords = vec(658.46, 630.69, 128.91, 254.27),		range = 10 },
	-- police
	{ coords = vec(-1100.84, -793.02, 18.75, 308.55),	range = 10 },	-- PD 5
	{ coords = vec(832.19, -1265.07, 26.28, 91.88),		range = 15 },	-- detective
	{ coords = vec(1855.45, 3671.11, 33.88, 188.96),	range = 10 },	-- sheriff sandy
	-- fbi
	{ coords = vec(-487.57, -254.19, 35.65, 229.2),		range = 6  },	-- justic
	{ coords = vec(-498.36, -258.75, 35.52, 226.71),	range = 6  },	-- justic
	{ coords = vec(-520.48, -267.61, 35.31, 233.01),	range = 6  },	-- justic
	{ coords = vec(-531.49, -271.92, 35.21, 234.82),	range = 6  },	-- justic
	{ coords = vec(-576.4, -169.12, 37.93, 293.96),		range = 6  },	-- justic
	{ coords = vec(-565.21, -164.29, 38.08, 294.25),	range = 6  },	-- justic
	{ coords = vec(248.27, -372.37, 44.41, 257.3),	    range = 15 },	-- justic2
	{ coords = vec(-2055.94, 3322.61, 33.0, 61.72),		range = 7  },	-- army dummy
	{ coords = vec(-2043.26, 3315.23, 33.01, 61.93),	range = 7  },	-- army dummy
	{ coords = vec(-2000.79, 3347.93, 36.87, 36.84),	range = 8  },	-- army dummy hellipad
	{ coords = vec(-2014.31, 3336.44, 36.95, 39.83),	range = 8  },	-- army dummy hellipad
	-- { coords = vec(-503.16, -231.67, 37.6, 67.27),		range = 5  },	-- justic heli movaghat
	-- { coords = vec(-541.93, -253.1, 37.26, 179.09),		range = 5  },	-- justic heli movaghat
	-- administatior 
	{ coords = vec(1779.28, 3628.55, 34.71, 120.01), 	range = 15 },	-- administatior
	-- weazel carbimeh
	{ coords = vec(-840.64, -696.89, 27.35, 92.33), 	range= 13 },

-- parking
    { coords = vec(-1607.31, 172.32, 59.58, 205.93),	range = 20 },	-- resturan          
    { coords = vec(371.29, -951.33, 29.36, 88.38), 		range = 10 },	-- parking kenare pd
	{ coords = vec(202.9, -843.48, 30.57, 246.63), 		range = 20 },	-- parking markazi
	{ coords = vec(240.01, -856.82, 29.64, 253.02),		range = 20 },	-- parking markazi

-- jazire
	{ coords = vec(618.31, -3023.41, 6.03, 92.16), 		range = 20 },	-- teleporter
	{ coords = vec(586.21, -3040.52, 6.07, 91.38), 		range = 20 },	-- teleporter
	{ coords = vec(4480.33, -4455.71, 4.19, 202.55), 	range = 20 },
	{ coords = vec(4063.38, -4684.66, 4.18, 19.45), 	range = 20 },

-- Air & Boots
    { coords = vec(-1614.69, -3124.42, 13.94, 328.19), 	range = 10 },
    { coords = vec(1737.29, 3286.85, 41.13, 180.14),	range = 10 },
    { coords = vec(1312.11, 4318.87, 38.13, 357.77),	range = 10 },
    { coords = vec(-195.24, 6553.95, 11.07, 132.45),	range = 10 },
	{ coords = vec(-745.41, -1309.73, 5.0, 57.23), 		range = 10 },

-- sahele coca
	{ coords = vec(-1801.66, -951.94, 2.42, 291.05),	range = 20 },
	{ coords = vec(-1821.24, -911.46, 2.46, 285.21),	range = 20 },
	{ coords = vec(-1842.74, -872.03, 2.97, 305.34), 	range = 20 },
	{ coords = vec(-1878.41, -826.49, 2.98, 323.3), 	range = 30 },
	{ coords = vec(-1923.04, -769.08, 2.97, 318.01), 	range = 30 },
	{ coords = vec(-1961.13, -723.6, 2.97, 318.59), 	range = 30 },

-- lebas forooshi
	{ coords = vec(93.3, -1401.26, 29.18, 43.58), 		range = 15 },
	{ coords = vec(-732.04, -144.56, 37.17, 31.89), 	range = 15 },
	{ coords = vec(-146.35, -306.46, 38.86, 165.0), 	range = 15 },
	{ coords = vec(410.56, -810.25, 29.21, 2.52), 		range = 15 },
	{ coords = vec(-817.92, -1090.47, 10.97, 297.07), 	range = 15 },
	{ coords = vec(-1458.96, -225.95, 49.14, 318.98), 	range = 15 },
	{ coords = vec(-4.88, 6520.65, 31.29, 315.92), 		range = 15 },
	{ coords = vec(134.0, -200.37, 54.34, 251.27), 		range = 15 },
	{ coords = vec(1678.56, 4817.67, 42.01, 10.51), 	range = 15 },
	{ coords = vec(591.86, 2732.42, 42.06, 183.72), 	range = 35 },
	{ coords = vec(-1209.58, -787.92, 16.86, 40.49), 	range = 15 },
	{ coords = vec(-3153.96, 1079.4, 20.69, 256.67), 	range = 15 },
	{ coords = vec(-1101.0, 2694.94, 18.92, 139.72), 	range = 15 },

-- arayeshgah
	{ coords = vec(-829.94, -193.28, 37.38, 33.62), 	range = 15 },
	{ coords = vec(129.42, -1718.19, 29.05, 53.21), 	range = 15 },
	{ coords = vec(-1278.88, -1150.64, 6.19, 18.1), 	range = 15 },
	{ coords = vec(1939.24, 3736.46, 32.3, 212.58), 	range = 15 },
	{ coords = vec(1196.18, -469.56, 66.15, 345.77),	range = 15 },
	{ coords = vec(-29.08, -136.92, 57.0, 247.3), 		range = 15 },
	{ coords = vec(-289.07, 6238.94, 31.36, 315.38), 	range = 15 },

-- shop
	{ coords = vec(-60.33, -1741.23, 29.31, 46.26),     range = 15 },
	{ coords = vec(15.34, -1343.16, 29.29, 180.9), 		range = 15 },
	{ coords = vec(1133.65, -974.33, 46.57, 277.01), 	range = 15 },
	{ coords = vec(1155.18, -337.54, 68.16, 177.28), 	range = 15 },
	{ coords = vec(367.9, 340.54, 103.23, 165.49), 		range = 15 },
	{ coords = vec(-1468.8, -393.15, 38.56, 128.09), 	range = 10 },
	{ coords = vec(-1249.57, -914.58, 11.46, 300.63), 	range = 15 },
	{ coords = vec(-729.0, -911.89, 19.01, 178.38), 	range = 15 },
	{ coords = vec(-1820.9, 808.46, 138.78, 220.86), 	range = 15 },
	{ coords = vec(-2962.81, 370.95, 14.77, 75.35), 	range = 15 },
	{ coords = vec(-3050.99, 603.42, 7.26, 289.93), 	range = 15 },
	{ coords = vec(-3250.83, 987.53, 12.49, 277.6), 	range = 15 },
	{ coords = vec(566.05, 2668.39, 42.07, 6.02), 		range = 15 },
	{ coords = vec(2566.47, 405.66, 108.46, 184.57), 	range = 15 },
	{ coords = vec(2659.2, 3260.97, 55.24, 241.14), 	range = 15 },
	{ coords = vec(1978.65, 3748.37, 32.18, 206.93), 	range = 15 },
	{ coords = vec(1689.1, 4914.11, 42.08, 53.09), 		range = 15 },
	{ coords = vec(1720.54, 6425.48, 33.38, 153.83), 	range = 15 },
	{ coords = vec(1661.6, 4859.7, 41.95, 186.15), 		range = 15 },	-- mini javahery
	{ coords = vec(-1131.78, -1340.33, 5.02, 113.14),	range = 15 },	-- mini javahery
	{ coords = vec(-1532.96, -435.11, 35.44, 221.78),	range = 15 },	-- mini javahery

-- house robbery
	{ coords = vec(1281.34, -1732.72, 52.63, 113.42),	range = 10 },	-- house buy
	{ coords = vec(-1671.15, -451.33, 39.32, 227.68),	range = 10 },	-- house 1
	{ coords = vec(-381.32, 348.58, 109.13, 6.41),		range = 10 },	-- house 2
	{ coords = vec(-506.9, 420.61, 97.56, 135.62),		range = 10 },	-- house 3
	{ coords = vec(-680.35, -1100.58, 14.53, 32.36),	range = 10 },	-- house 4
	{ coords = vec(-54.66, -407.26, 37.93, 255.7),		range = 10 },	-- house 5
	{ coords = vec(-172.18, 5.14, 57.13, 66.19),		range = 10 },	-- house 6
	{ coords = vec(-1220.59, -183.75, 39.18, 154.81),	range = 10 },	-- house 7
	{ coords = vec(-1254.04, -1321.28, 3.87, 202.88),	range = 10 },	-- house 8
	{ coords = vec(259.72, 31.07, 84.09, 250.86),		range = 10 },	-- house 9
	{ coords = vec(148.64, -125.27, 54.83, 68.56),		range = 10 },	-- house 10
	{ coords = vec(98.66, 64.69, 73.42, 68.52),			range = 10 },	-- house 11
	{ coords = vec(-940.67, -370.48, 38.96, 26.02),		range = 10 },	-- house 12
	{ coords = vec(1239.55, -1614.19, 52.3, 117.71),	range = 10 },	-- house 13
	{ coords = vec(-605.97, 176.24, 64.91, 91.66),		range = 10 },	-- house 14
	{ coords = vec(-68.35, -1461.28, 32.04, 287.11),	range = 10 },	-- house 15
	{ coords = vec(-1139.4, -1175.73, 2.43, 205.38),	range = 10 },	-- house 16
	{ coords = vec(-58.96, 382.25, 112.43, 66.99),		range = 10 },	-- house 17
	{ coords = vec(-462.46, -51.76, 44.52, 86.99),		range = 10 },	-- house 18
	{ coords = vec(-1155.58, -943.77, 2.57, 122.07),	range = 10 },	-- house 19
	-- { coords = vec(1009.63, -562.76, 60.2, 255.7),		range = 10 },	-- house 20
	{ coords = vec(268.78, -1746.0, 29.53, 229.07),		range = 10 },	-- house 21
	{ coords = vec(1246.07, -585.43, 69.2, 271.44),		range = 10 },	-- house 22
	{ coords = vec(318.19, -204.73, 54.09, 248.74),		range = 10 },	-- house 23
	{ coords = vec(-616.28, -778.36, 25.21, 0.16),		range = 10 },	-- house 24
	{ coords = vec(382.99, -331.92, 46.83, 159.64),		range = 10 },	-- house 25
	{ coords = vec(-789.27, -403.87, 35.93, 68.43),		range = 10 },	-- house 26
	{ coords = vec(-1098.05, -1504.59, 4.72, 128.28),	range = 10 },	-- house 27
	{ coords = vec(-1280.56, -435.95, 34.47, 214.77),	range = 10 },	-- house 28
	{ coords = vec(241.26, -1354.54, 30.55, 49.74),		range = 10 },	-- house 29
	{ coords = vec(149.05, -1336.95, 29.2, 318.51),		range = 10 },	-- house 30
	{ coords = vec(-160.9, 175.5, 81.5, 69.59),			range = 10 },	-- house 31
	{ coords = vec(-772.75, -210.24, 37.28, 27.05),		range = 10 },	-- house 32
	{ coords = vec(-1218.43, -703.49, 22.47, 40.02),	range = 10 },	-- house 33
	{ coords = vec(165.66, -283.41, 46.15, 158.08),		range = 10 },	-- house 34
	{ coords = vec(-1448.1, -684.89, 26.31, 308.82),	range = 10 },	-- house 35
	{ coords = vec(478.89, -1517.64, 29.29, 284.46),	range = 10 },	-- house 36
	{ coords = vec(-1142.22, -452.52, 35.24, 296.57),	range = 10 },	-- house 37
	{ coords = vec(-573.88, -450.89, 34.25, 92.06),		range = 10 },	-- house 38
	{ coords = vec(944.69, -256.57, 67.48, 149.22),		range = 10 },	-- house 39
	{ coords = vec(-403.36, 206.18, 83.12, 358.52),		range = 10 },	-- house 40
	{ coords = vec(-874.46, -216.88, 39.27, 28.19),		range = 10 },	-- house 41
	{ coords = vec(-0.69, -209.63, 52.74, 64.7),		range = 10 },	-- house 42
	{ coords = vec(62.79, 156.92, 104.7, 247.04),		range = 10 },	-- house 43
	{ coords = vec(-351.81, 112.15, 66.56, 266.48),		range = 10 },	-- house 44
	{ coords = vec(-309.22, -610.98, 33.56, 177.08),	range = 10 },	-- house 45
	{ coords = vec(-591.99, -902.12, 25.67, 82.31),		range = 10 },	-- house 46
	{ coords = vec(-31.49, -1679.97, 29.44, 139.44),	range = 10 },	-- house 47
	{ coords = vec(45.48, -100.62, 56.25, 70.8),		range = 10 },	-- house 48
	{ coords = vec(-694.87, -139.18, 37.64, 28.68),		range = 10 },	-- house 49
	{ coords = vec(-1090.8, -538.15, 35.49, 205.89),	range = 10 },	-- house 50
-- motofareghe
	{ coords = vec(-64.77, -1994.41, 18.02, 78.89), 	range = 5  },	-- CarDelaer
	{ coords = vec(-175.63, -2149.06, 16.71, 202.07), 	range = 5  },	-- CarDelaer
	{ coords = vec(-54.46, -1110.23, 26.44, 70.88), 	range = 15 },	-- car shop
	{ coords = vec(-198.05, -2003.87, 27.62, 259.56), 	range = 30 },	-- game net
	{ coords = vec(-1574.04, 5094.54, 26.67, 163.68), 	range = 20 },	-- Paintball
	{ coords = vec(216.36, 1236.93, 225.46, 189.46), 	range = 30 },	-- mozayede

	{ coords = vec(-1013.06, -2114.55, 12.33, 228.57), 	range = 15 },	-- AH
	{ coords = vec(119.22, -1572.22, 29.6, 323.72),		range = 14 },	-- AH
	{ coords = vec(142.07, 6638.76, 32.65, 135.13), 	range = 5  }, 	-- paleto AH
	{ coords = vec(148.45, 6625.48, 31.75, 134.64), 	range = 10 }, 	-- paleto AH
	{ coords = vec(171.69, 6622.42, 31.78, 135.81), 	range = 14 }, 	-- paleto AH

	{ coords = vec(1717.49, 3693.44, 34.53, 21.09), 	range = 14 }, 	-- sandy AH
	{ coords = vec(1736.64, 3686.51, 38.6, 107.04), 	range = 9  }, 	-- sandy heli AH

	{ coords = vec(476.25, 6591.99, 30.94, 172.25), 	range = 8  }, 	-- paleto heli AH
	{ coords = vec(454.42, 6595.33, 31.0, 178.08), 	    range = 8  }, 	-- paleto heli AH
	--drug
	{ coords = vec(-1075.81, -1663.59, 4.4, 37.46), 	range = 15 },	-- ephedrine
	{ coords = vec(3616.71, 3738.05, 28.69, 320.91), 	range = 20 },	-- opum
	{ coords = vec(2318.48, 2577.26, 46.67, 349.05), 	range = 20 },	-- marijuana 
	{ coords = vec(1977.99, 3804.7, 32.16, 303.73), 	range = 20 },	-- meth

	{ coords = vec(1695.75, 3833.56, 34.99, 226.41),	range = 12 },	-- shishe
	{ coords = vec(1724.79, 3833.65, 34.94, 121.1),		range = 15 },	-- shishe

	{ coords = vec(341.53, -867.81, 29.16, 277.31),		range = 10 },	-- kfc 
	{ coords = vec(-307.63, -232.77, 35.7, 265.88),		range = 15 },	-- caffe 1
	{ coords = vec(-301.98, -271.34, 31.65, 275.73),	range = 15 },	-- caffe 1
	{ coords = vec(-251.63, -771.19, 32.6, 161.06),		range = 15 },	-- caffe 2
	{ coords = vec(766.23, -724.86, 27.86, 182.44),		range = 15 },	-- caffe 3
	{ coords = vec(54.87, -1566.66, 29.44, 50.96), 		range = 15 },	-- caffe 4
	{ coords = vec(-1400.03, -583.41, 30.32, 299.99),   range = 30 },	-- caffe 5
	{ coords = vec(-143.58, 6203.31, 31.25, 320.06),	range = 15 },	-- caffe 6
	-- farm
	{ coords = vec(437.22, 6539.41, 27.99, 89.1), 		range = 30 },
	{ coords = vec(130.08, 6365.18, 31.3, 29.19), 		range = 10 },
	{ coords = vec(88.62, 6375.27, 31.23, 300.23), 		range = 20 },
	{ coords = vec(1832.47, 3945.3, 33.2, 273.47), 		range = 20 },
	{ coords = vec(1863.68, 3917.54, 33.08, 190.56), 	range = 20 },
	{ coords = vec(1842.02, 3892.16, 33.39, 109.63), 	range = 14 },
	{ coords = vec(1824.29, 3922.85, 40.9, 279.15), 	range = 9  },  -- sandy heli

	-- ahangari
	{ coords = vec(-365.13, -125.84, 38.7, 82.67),   	range = 5 }, -- ahangari 1
	{ coords = vec(716.33, -1080.06, 22.28, 1.77),   	range = 5 }, -- ahangari 2
	{ coords = vec(1149.13, -767.05, 57.52, 274.37), 	range = 5 }, -- ahangari 4
	{ coords = vec(490.95, -1332.23, 29.34, 294.79), 	range = 5 }, -- ahangari 5
	{ coords = vec(-1134.37, -1992.39, 13.17, 302.54), 	range = 5 }, -- ahangari 6
	{ coords = vec(133.01, -1102.02, 29.19, 2.69), 		range = 5 }, -- ahangari 7

	-- gym
	{ coords = vec(-1209.11, -1548.5, 4.37, 302.69), 	range = 30 },
	-- car mitting
	{ coords = vec(970.38, -1770.34, 21.03, 87.43), 	range = 5 },

-- ekhtesasi
	-- public
    { coords = vec(-409.75, 1185.28, 325.53, 252.63), 	range = 20 },	-- Admins
    { coords = vec(96.54, -1933.34, 20.8, 51.15), 		range = 30 },	-- mahale grove
	-- shakhsi
	{ coords = vec(-981.32, 777.68, 174.0, 39.52), 		range = 5  },	-- amirali
	{ coords = vec(-585.84, 527.54, 107.64, 210.95), 	range = 5  },	-- Mahdavi
	{ coords = vec(-294.39, 240.34, 88.71, 15.21), 		range = 5  },	-- armin zx
	{ coords = vec(-249.14, 607.85, 185.92, 79.48), 	range = 5  },	-- ashkan janfaza
	{ coords = vec(-956.32, 455.58, 79.7, 16.46), 		range = 5  },	-- SE
	{ coords = vec(-1343.59, 594.4, 133.69, 11.23), 	range = 5  },	-- silent
	{ coords = vec(-1047.89, 742.01, 166.64, 283.94), 	range = 5  },	-- khune shakhsi
	{ coords = vec(-523.14, 647.71, 138.3, 333.17), 	range = 5  },	-- khune shakhsi
	{ coords = vec(-1197.68, 552.02, 98.53, 101.89), 	range = 5  },	-- khune shakhsi
	{ coords = vec(-309.26, 440.22, 108.14, 279.85), 	range = 5  },	-- khune shakhsi
	{ coords = vec(-1147.48, 471.41, 83.75, 96.84), 	range = 5  },	-- khune shakhsi
	{ coords = vec(-3102.41, 254.16, 11.83, 289.71), 	range = 5  },	-- khune shakhsi
	{ coords = vec(-439.96, 545.49, 121.58, 266.48), 	range = 5  },	-- khune shakhsi
	{ coords = vec(-543.83, 492.45, 103.9, 68.17), 	    range = 5  },	-- khune shakhsi
	{ coords = vec(-362.41, 668.86, 168.0, 60.93), 	    range = 5  },	-- khune shakhsi
	{ coords = vec(1270.29, -451.66, 69.68, 187.78),    range = 5  },	-- khune shakhsi
	{ coords = vec(886.71, -553.3, 57.8, 116.56), 	    range = 5  },	-- khune shakhsi
	{ coords = vec(-480.46, 553.23, 119.81, 234.5),	    range = 5  },	-- khune shakhsi
	-- Gang
	{ coords = vec(780.39, -2510.27, 20.23, 350.07), 	range = 5  }, 	-- G_01
	{ coords = vec(1022.8, -2493.94, 28.5, 160.04),   	range = 5  },	-- G_02
	{ coords = vec(1100.86, -2251.92, 30.25, 175.2),   	range = 5  },	-- G_03
	{ coords = vec(1407.38, -2056.09, 52.0, 113.79), 	range = 5  },	-- G_05
	{ coords = vec(98.89, -2189.14, 5.97, 267.11), 		range = 5  },	-- G_07
	{ coords = vec(-21.82, -2199.13, 7.81, 359.93), 	range = 5  },	-- G_08
	{ coords = vec(-427.23, -1692.72, 19.03, 159.06), 	range = 5  },	-- G_09	
	{ coords = vec(-597.49, -1587.66, 26.75, 81.79), 	range = 5  },  	-- G_10
	{ coords = vec(952.5, -124.52, 74.35, 219.78),   	range = 5  },	-- G_11
	{ coords = vec(1361.04, 1165.19, 113.57, 180.37), 	range = 5  },	-- G_12
	{ coords = vec(-149.44, 918.6, 235.66, 222.72), 	range = 5  },	-- G_16
	{ coords = vec(-115.67, 973.17, 235.79, 15.55), 	range = 5  },	-- G_18
	{ coords = vec(-576.3, 315.5, 84.64, 270.48), 		range = 5  },	-- G_19
	{ coords = vec(-814.34, 160.04, 71.27, 117.64), 	range = 5  },	-- G_27
	{ coords = vec(-1110.4, 371.85, 69.42, 259.37), 	range = 5  },	-- G_31
	{ coords = vec(-1360.74, 165.61, 57.82, 184.61), 	range = 5  },	-- G_34
	{ coords = vec(-1148.73, 18.53, 50.01, 59.76), 		range = 5  },	-- G_34
	{ coords = vec(-1522.42, 98.85, 56.71, 224.74), 	range = 5  },	-- G_35
	{ coords = vec(-1572.55, -78.65, 54.13, 274.62), 	range = 5  },  	-- G_37
	{ coords = vec(-1944.11, 546.64, 114.61, 70.8), 	range = 5  },	-- G_42
	{ coords = vec(-1792.92, 458.12, 128.31, 100.02), 	range = 5  },	-- G_43
	{ coords = vec(-1752.75, 364.45, 89.64, 113.15), 	range = 5  },	-- G_44
	{ coords = vec(-1536.53, 427.62, 109.43, 283.43), 	range = 5  },	-- G_45
	{ coords = vec(-2665.88, 1309.63, 147.12, 261.59), 	range = 5  },	-- G_52
	{ coords = vec(-2596.22, 1678.93, 141.87, 195.78), 	range = 5  },	-- G_53
 	{ coords = vec(-1887.92, 2031.96, 140.73, 160.52), 	range = 5  },	-- G_55
	{ coords = vec(-1576.25, -277.96, 48.28, 225.42), 	range = 5  },	-- G_61
	{ coords = vec(-348.08, -2762.37, 6.04, 38.94), 	range = 5  },	-- G_61
	{ coords = vec(-1461.97, -40.25, 54.67, 317.64), 	range = 5  },	-- G_65
	{ coords = vec(210.64, -2016.5, 18.58, 319.47), 	range = 5  },	-- G_67
	{ coords = vec(-992.4, 309.39, 69.13, 354.79), 		range = 5  },	-- G_70
	{ coords = vec(-51.89, -1849.42, 26.27, 318.72), 	range = 5  },	-- G_72
	{ coords = vec(-656.07, -2401.38, 13.96, 64.0), 	range = 5  },	-- G_74	
	{ coords = vec(279.76, -2558.39, 5.7, 296.39), 		range = 5  },	-- G_78
	{ coords = vec(-740.57, -1469.33, 5.0, 313.94), 	range = 5  },	-- G_84
	{ coords = vec(-750.11, -1503.8, 5.01, 302.59), 	range = 5  },	-- G_84-2
	{ coords = vec(-611.67, -2345.84, 13.83, 47.3), 	range = 5  },	-- G_86
	{ coords = vec(-367.01, -2278.38, 7.67, 357.02), 	range = 5  },	-- G_87
	{ coords = vec(2192.53, 3326.67, 45.99, 271.79), 	range = 5  },	-- G_94
	{ coords = vec(838.34, -2797.33, 7.45, 1.14), 		range = 5  },	-- G_95
	{ coords = vec(26.78, 659.3, 207.87, 107.23), 	    range = 5  },	-- G_100
	{ coords = vec(1006.29, -2345.74, 30.59, 82.8), 	range = 5  },	-- G_102
	{ coords = vec(-2176.83, -374.76, 13.13, 170.78),	range = 5  },	-- G_104
	{ coords = vec(1886.58, 3098.21, 49.31, 238.33),	range = 5  },	-- G_105
	{ coords = vec(-1610.63, -812.47, 10.05, 134.45),	range = 5  },	-- G_109
	{ coords = vec(-1655.34, -782.55, 10.34, 228.42),	range = 5  },	-- G_110
	{ coords = vec(-1718.05, -732.53, 10.34, 44.22),	range = 5  },	-- G_111
	{ coords = vec(-1500.99, -192.6, 50.4, 128.78),		range = 5  },	-- G_112
	{ coords = vec(-449.16, 293.2, 83.23, 266.4),	    range = 5  },	-- G_113
	{ coords = vec(1354.18, -2637.2, 49.23, 291.25),	range = 5  },	-- G_114
	{ coords = vec(-297.58, -2696.83, 6.0, 42.1),    	range = 5  },	-- G_115
	{ coords = vec(-1485.61, -171.38, 48.83, 219.65),   range = 5  },	-- G_116
	{ coords = vec(619.89, -2919.9, 6.09, 179.2),       range = 5  },	-- G_117
	{ coords = vec(-979.27, -2062.31, 9.41, 214.24),    range = 5  },	-- G_118
	{ coords = vec(-907.89, -2072.41, 9.3, 41.84),      range = 5  },	-- G_119
	{ coords = vec(909.41, -2476.7, 28.29, 259.73),     range = 5  },	-- G_120
	{ coords = vec(301.53, -2787.09, 6.11, 80.02),      range = 5  },	-- G_121
	{ coords = vec(1594.14, -2605.85, 53.21, 68.5),     range = 5  },	-- G_122
	{ coords = vec(-1078.76, -2178.34, 13.29, 42.55),   range = 5  },	-- G_123
	{ coords = vec(-1195.02, -2169.77, 13.2, 239.14),   range = 5  },	-- G_124
	{ coords = vec(-1022.96, -2218.33, 8.98, 224.17),   range = 5  },	-- G_125
	{ coords = vec(-833.95, -2744.13, 13.95, 150.61),   range = 5  },	-- G_126
	{ coords = vec(-1016.62, -1977.13, 5.35, 50.58),    range = 5  },	-- G_127
	{ coords = vec(-1181.85, -1165.12, 5.57, 198.53),   range = 5  },	-- G_128
	{ coords = vec(-839.06, -2669.87, 13.81, 241.26),   range = 5  },	-- G_129
	{ coords = vec(-197.99, -2659.06, 6.0, 89.26),   	range = 5  },	-- G_130

	{ coords = vec(-1600.28, -2772.08, 13.94, 147.09),	range = 10 },	-- G_200
	{ coords = vec(-1589.17, -2754.1, 13.94, 280.81),	range = 10 },	-- G_200
	{ coords = vec(-1622.51, -2725.2, 13.94, 332.14), 	range = 20 },	-- G_200
	{ coords = vec(-1635.77, -2747.86, 13.94, 328.47), 	range = 20 },	-- G_200
}


Customize.Hotkey = "U"
Customize.SwitchDistance = 3
Customize.HotwireItem = 'hotwire'
Customize.TargetDistance = 5.0
