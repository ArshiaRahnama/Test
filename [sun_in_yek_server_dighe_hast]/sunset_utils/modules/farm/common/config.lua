-- Pub by FleeX Team , https://discord.gg/87rGBxgCsa

farmConfig = {
    seedModel = `prop_weed_02`,
    farms = {
        ['paletofarm_1'] = { -- paleto 10 slot
            label = 'Farm',
            buySlot = 10000,
            price = 1000000,
            keySlot = 1,
            barnMaxWeight = 300,
            enterCoords = vec(413.11, 6539.92, 27.73, 347.13),
            enterTPCoords = vec(564.27, 6458.4, 30.77, 1.81),
            farmCoords = vec(570.69, 6475.77, 30.71, 50.0),
            poly = {
                vec(550.64, 6458.01, 29.61),
                vec(550.59, 6513.94, 29.61),
                vec(577.69, 6513.92, 29.61),
                vec(577.95, 6509.22, 29.61),
                vec(594.70, 6509.23, 29.61),
                vec(595.13, 6457.74, 29.61),
            },
            truck = {
                model = `tractor`,
                enter = vec(423.52, 6536.98, 27.63, 352.2),
                exit  = vec(561.53, 6452.46, 30.74, 91.68),
            },
            plantSlot = 10,
            seeds = {
                ['seed_coca'] = true,
                ['seed_ephedra'] = true,
                ['seed_cannabis'] = true,
                ['seed_poppy'] = true,
                ['seed_apple'] = true,
                ['seed_orange'] = true,
                ['seed_corn'] = true,
                ['seed_wheat'] = true,
                ['seed_grape'] = true,
                ['seed_rice'] = true,
                ['seed_mushroom'] = true,
                ['seed_caffee'] = true,
            }
        },

        ['paletofarm_2'] = { -- paleto 15 slot
            label = 'Farm',
            buySlot = 3500,
            price = 5000000,
            keySlot = 1,
            barnMaxWeight = 450,
            enterCoords = vec(126.44, 6353.36, 31.38, 302.9),
            enterTPCoords = vec(282.28, 6438.18, 32.02, 9.22),
            farmCoords = vec(251.49, 6454.25, 31.38, 60.0),
            poly = {
                vec(289.51, 6447.02, 29.79),
                vec(287.38, 6483.13, 29.79),
                vec(208.86, 6476.95, 29.79),
                vec(210.06, 6464.67, 29.79),
                vec(233.70, 6442.61, 29.79),
            },
            truck = {
                model = `tractor2`,
                enter = vec(136.55, 6345.76, 31.26, 26.34),
                exit  = vec(274.67, 6437.36, 31.91, 96.46),
            },
            plantSlot = 15,
            seeds = {
                ['seed_coca'] = true,
                ['seed_ephedra'] = true,
                ['seed_cannabis'] = true,
                ['seed_poppy'] = true,
                ['seed_apple'] = true,
                ['seed_orange'] = true,
                ['seed_corn'] = true,
                ['seed_wheat'] = true,
                ['seed_grape'] = true,
                ['seed_rice'] = true,
                ['seed_mushroom'] = true,
                ['seed_caffee'] = true,
            }
        },

        ['paletofarm_3'] = { -- paleto 20 slot
            label = 'Farm',
            buySlot = 3000,
            price = 10000000,
            keySlot = 1,
            barnMaxWeight = 600,
            enterCoords = vec(95.82, 6363.94, 31.38, 25.57),
            enterTPCoords = vec(297.13, 6630.48, 29.24, 88.61),
            farmCoords = vec(269.71, 6630.16, 29.4, 60.0),
            poly = {
                vec(294.28, 6595.91, 29.31),
                vec(294.25, 6665.70, 29.31),
                vec(244.06, 6666.32, 29.31),
                vec(243.79, 6595.49, 29.31),
            },
            truck = {
                model = `tractor2`,
                enter = vec(95.21, 6372.34, 31.23, 11.93),
                exit  = vec(300.18, 6619.9, 29.19, 182.95),
            },
            plantSlot = 20,
            seeds = {
                ['seed_coca'] = true,
                ['seed_ephedra'] = true,
                ['seed_cannabis'] = true,
                ['seed_poppy'] = true,
                ['seed_apple'] = true,
                ['seed_orange'] = true,
                ['seed_corn'] = true,
                ['seed_wheat'] = true,
                ['seed_grape'] = true,
                ['seed_rice'] = true,
                ['seed_mushroom'] = true,
                ['seed_caffee'] = true,
            }
        },

        ['sandyfarm_1'] = {  -- paleto 30 slot
            label = 'Farm',
            buySlot = 2500,
            price = 20000000,
            keySlot = 2,
            barnMaxWeight = 900,
            enterCoords = vec(1846.11, 3914.44, 33.46, 276.8),
            enterTPCoords = vec(2236.39, 5024.97, 43.97, 52.95),
            farmCoords = vec(2237.36, 5073.71, 47.22, 80.0),
            poly = {
                vec(2300.92, 5064.96, 43.35),
                vec(2261.04, 5022.80, 43.35),
                vec(2246.18, 5037.78, 43.35),
                vec(2226.02, 5019.01, 43.35),
                vec(2182.72, 5062.90, 43.35),
                vec(2192.50, 5072.62, 43.35),
                vec(2171.88, 5092.75, 43.35),
                vec(2222.88, 5142.94, 43.35),
            },
            truck = {
                model = `tractor2`,
                enter = vec(1847.99, 3923.91, 33.04, 193.26),
                exit  = vec(2245.93, 5018.21, 43.29, 134.68),
            },
            plantSlot = 30,
            seeds = {
                ['seed_coca'] = true,
                ['seed_ephedra'] = true,
                ['seed_cannabis'] = true,
                ['seed_poppy'] = true,
                ['seed_apple'] = true,
                ['seed_orange'] = true,
                ['seed_corn'] = true,
                ['seed_wheat'] = true,
                ['seed_grape'] = true,
                ['seed_rice'] = true,
                ['seed_mushroom'] = true,
                ['seed_caffee'] = true,
            }
        },

        ['sandyfarm_2'] = { -- paleto 50 slot
            label = 'Farm',
            buySlot = 2100,
            price = 50000000,
            keySlot = 3,
            barnMaxWeight = 1500,
            enterCoords = vec(1838.42, 3907.3, 33.25, 103.24),
            enterTPCoords = vec(2098.46, 4909.75, 41.06, 40.92),
            farmCoords = vec(2037.8, 4908.24, 41.72, 80.0),
            poly = {
                vec(2097.16, 4917.97, 40.96),
                vec(2032.08, 4851.93, 40.96),
                vec(1979.97, 4902.81, 40.96),
                vec(2046.36, 4968.93, 40.96),
            },
            truck = {
                model = `tractor2`,
                enter = vec(1838.77, 3899.95, 33.19, 191.75),
                exit  = vec(2097.87, 4900.7, 40.99, 310.45),
            },
            plantSlot = 50,
            seeds = {
                ['seed_coca'] = true,
                ['seed_ephedra'] = true,
                ['seed_cannabis'] = true,
                ['seed_poppy'] = true,
                ['seed_apple'] = true,
                ['seed_orange'] = true,
                ['seed_corn'] = true,
                ['seed_wheat'] = true,
                ['seed_grape'] = true,
                ['seed_rice'] = true,
                ['seed_mushroom'] = true,
                ['seed_caffee'] = true,
            }
        },

        ['sandyfarm_3'] = { -- paleto 50 slot
            label = 'Farm',
            buySlot = 2100,
            price = 50000000,
            keySlot = 3,
            barnMaxWeight = 1500,
            enterCoords = vec(1835.44, 3932.4, 33.2, 1.0),
            enterTPCoords = vec(2816.03, 4584.86, 45.62, 328.31),
            farmCoords = vec(2856.98, 4627.83, 48.92, 80.0),
            poly = {
                vec(2817.41, 4586.06, 45.70),
                vec(2802.01, 4647.61, 45.70),
                vec(2811.19, 4658.57, 45.70),
                vec(2881.37, 4676.77, 45.70),
                vec(2902.42, 4597.54, 45.70),
                vec(2884.36, 4579.87, 45.70),
                vec(2843.15, 4568.32, 45.70),
                vec(2837.33, 4590.63, 45.70),
            },
            truck = {
                model = `tractor2`,
                enter = vec(1831.79, 3940.19, 33.18, 278.45),
                exit  = vec(2813.94, 4577.6, 46.16, 141.11),
            },
            plantSlot = 50,
            seeds = {
                ['seed_coca'] = true,
                ['seed_ephedra'] = true,
                ['seed_cannabis'] = true,
                ['seed_poppy'] = true,
                ['seed_apple'] = true,
                ['seed_orange'] = true,
                ['seed_corn'] = true,
                ['seed_wheat'] = true,
                ['seed_grape'] = true,
                ['seed_rice'] = true,
                ['seed_mushroom'] = true,
                ['seed_caffee'] = true,
            }
        },

    },

    seeds = {
        ['seed_coca'] = { -- Dane Coca
            requiredItems = {
                ['seed_coca'] = 1,
            },
            givingItems = {
                ['coca'] = {7, 8}, -- {1, 3} random - 3
                ['seed_coca'] = { chance = 1000, count = {1, 2} },
            },
            label = 'Giahe Tokhme Katan',
            fruitingTime = 1800,-- zamane bardasht sanie
            waterTime = 5,
            plantTime = 3,
            pickupTime = 5,
            spoilTime = 24, --h
            deleteTime = 10, -- time delete sanie
            models = {
                list = {
                    [1] = {
                        model = `prop_bush_med_06`,
                        offset = 1,
                    },
                },
            }
        },
        ['seed_ephedra'] = { -- Dane Ephedra
            requiredItems = {
                ['seed_ephedra'] = 1,
            },
            givingItems = {
                ['ephedra'] = {5, 15}, -- {1, 3} random - 3
                ['seed_ephedra'] = { chance = 1000, count = {1, 2} },
            },
            label = 'Giahe Ephedra',
            fruitingTime = 3600,
            waterTime = 5,
            plantTime = 3,
            pickupTime = 5,
            spoilTime = 24, --h
            deleteTime = 10,
            models = {
                list = {
                    [1] = {
                        model = `prop_bush_med_07`,
                        offset = 1,
                    },
                },
            }
        },
        ['seed_cannabis'] = { -- Dane Cannabis 
            requiredItems = {
                ['seed_cannabis'] = 1,
            },
            givingItems = {
                ['cannabis'] = {10, 20}, -- {1, 3} random - 3
                ['seed_cannabis'] = { chance = 1000, count = {1, 2} },
            },
            label = 'Giahe Shahdane',
            fruitingTime = 5400,
            waterTime = 5,
            plantTime = 3,
            pickupTime = 5,
            spoilTime = 24, --h
            deleteTime = 10,
            models = {
                list = {
                    [1] = {
                        model = `prop_weed_01`,
                        offset = 1.5,
                    },
                },
            }
        },
        ['seed_poppy'] = { -- Dane KhashKhaash
            requiredItems = {
                ['seed_poppy'] = 1,
            },
            givingItems = {
                ['poppy'] = {15, 25}, -- {1, 3} random - 3
                ['seed_poppy'] = { chance = 1000, count = {1, 2} },
            },
            label = 'Giahe Zire Siah',
            fruitingTime = 2700,
            waterTime = 5,
            plantTime = 3,
            pickupTime = 5,
            spoilTime = 24, --h
            deleteTime = 10,
            models = {
                list = {
                    [1] = {
                        model = `prop_bush_med_01`,
                        offset = 1,
                    },
                },
            }
        },
        ['seed_apple'] = { -- Dane Sib
            requiredItems = {
                ['seed_apple'] = 1,
            },
            givingItems = {
                ['apple_pack'] = 30, -- {1, 3} random - 3
                ['seed_apple'] = { chance = 1000, count = {1, 2} },
            },
            label = 'Derakht Sib',
            fruitingTime = 3600,
            waterTime = 5,
            plantTime = 3,
            pickupTime = 5,
            spoilTime = 24, --h
            deleteTime = 10,
            models = {
                list = {
                    [1] = {
                        model = `h4_prop_tree_umbrella_sml_01`,
                        offset = 3.5,
                    },
                    [99] = `prop_tree_birch_05`,
                },
            }
        },
        ['seed_orange'] = { -- Dane Portaghal
            requiredItems = {
                ['seed_orange'] = 1,
            },
            givingItems = {
                ['orange_pack'] = 30, -- {1, 3} random - 3
                ['seed_orange'] = { chance = 1000, count = {1, 2} },
            },
            label = 'Derakht Portaghal',
            fruitingTime = 3600,
            waterTime = 5,
            plantTime = 3,
            pickupTime = 5,
            spoilTime = 24, --h
            deleteTime = 10,
            models = {
                list = {
                    [1] = {
                        model = `prop_tree_cedar_s_01`,
                        offset = 7.5,
                    },
                    [99] = `prop_veg_crop_orange`,
                },
            }
        },
        ['seed_corn'] = { -- Dane Zorrat
            requiredItems = {
                ['seed_corn'] = 1,
            },
            givingItems = {
                ['corn_pack'] = 30, -- {1, 3} random - 3
                ['seed_corn'] = { chance = 1000, count = {1, 2} },
            },
            label = 'Giahe Zorrat',
            fruitingTime = 3600,
            waterTime = 5,
            plantTime = 3,
            pickupTime = 5,
            spoilTime = 24, --h
            deleteTime = 10,
            models = {
                list = {
                    [1] = {
                        model = `h4_prop_tree_dracaena_sml_01`,
                        offset = 1.5,
                    },
                    [30] = {
                        model = `h4_prop_tree_dracaena_lrg_01`,
                        offset = 2.5,
                    },
                },
            }
        },
        ['seed_wheat'] = { -- Dane Gandom
            requiredItems = {
                ['seed_wheat'] = 1,
            },
            givingItems = {
                ['wheat_pack'] = 30, -- {1, 3} random - 3
                ['seed_wheat'] = { chance = 1000, count = {1, 2} },
            },
            label = 'Boote Gandom',
            fruitingTime = 3600,
            waterTime = 5,
            plantTime = 3,
            pickupTime = 5,
            spoilTime = 24, --h
            deleteTime = 10,
            models = {
                list = {
                    [1] = {
                        model = `prop_bush_med_05`,
                        offset = 0.7,
                    },
                },
            }
        },
        ['seed_grape'] = { -- Dane Angoor
            requiredItems = {
                ['seed_grape'] = 1,
            },
            givingItems = {
                ['grape_pack'] = 30, -- {1, 3} random - 3
                ['seed_grape'] = { chance = 1000, count = {1, 2} },
            },
            label = 'Derakht Angoor',
            fruitingTime = 3600,
            waterTime = 5,
            plantTime = 3,
            pickupTime = 5,
            spoilTime = 24, --h
            deleteTime = 10,
            models = {
                list = {
                    [1] = {
                        model = `h4_prop_tree_frangipani_med_01`,
                        offset = 0.75,
                    },
                    [50] = {
                        model = `h4_prop_tree_frangipani_lrg_01`,
                        offset = 4.5,
                    },
                },
            }
        },
        ['seed_rice'] = { -- Dane Berenj
            requiredItems = {
                ['seed_rice'] = 1,
            },
            givingItems = {
                ['rice_pack'] = 30, -- {1, 3} random - 3
                ['seed_rice'] = { chance = 1000, count = {1, 2} },
            },
            label = 'Boote Berenj',
            fruitingTime = 3600,
            waterTime = 5,
            plantTime = 3,
            pickupTime = 5,
            spoilTime = 24, --h
            deleteTime = 10,
            models = {
                list = {
                    [1] = {
                        model = `h4_prop_tree_palm_areca_sap_03`,
                        offset = 2,
                    },
                },
            }
        },
        ['seed_mushroom'] = { -- Bazre Gharch
            requiredItems = {
                ['seed_mushroom'] = 1,
            },
            givingItems = {
                ['mushroom'] = {20, 25}, -- {1, 3} random - 3
                ['seed_mushroom'] = { chance = 1000, count = {1, 2} },
            },
            label = 'Gharch',
            fruitingTime = 3600,
            waterTime = 5,
            plantTime = 3,
            pickupTime = 5,
            spoilTime = 24, --h
            deleteTime = 10,
            models = {
                list = {
                    [1] = {
                        model = `prop_bush_med_01`,
                        offset = 1,
                    },
                },
            }
        },
        ['seed_caffee'] = { -- Dane caffee
            requiredItems = {
                ['seed_caffee'] = 1,
            },
            givingItems = {
                ['caffee_pack'] = 30, -- {1, 3} random - 3
                ['seed_caffee'] = { chance = 1000, count = {1, 2} },
            },
            label = 'Boote Ghahve',
            fruitingTime = 3600,
            waterTime = 5,
            plantTime = 3,
            pickupTime = 5,
            spoilTime = 24, --h
            deleteTime = 10,
            models = {
                list = {
                    [1] = {
                        model = `prop_weed_01`,
                        offset = 1.0,
                    },
                    [30] = {
                        model = `h4_prop_tree_frangipani_med_01`,
                        offset = 0.5,
                    },
                    [80] = {
                        model = `h4_prop_bush_bgnvla_lrg_01`,
                        offset = 2.5,
                    },
                },
            }
        },
    }
}

-- list = {
--     [10] = `prop_fbibombplant`,
--     [30] = {
--         model = `prop_weed_01`,
--         offset = 1,
--     },
--     [70] = `prop_peyote_lowland_02`,
-- },