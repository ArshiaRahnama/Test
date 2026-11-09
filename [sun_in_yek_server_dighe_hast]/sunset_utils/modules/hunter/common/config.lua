-- Pub by FleeX Team , https://discord.gg/87rGBxgCsa

ConfigHunter = {
    startPos = vector3(-567.95,5253.27,70.49),
    areaPos = vector4(-626.14,5083.66,131.8,250),
    slaughterPos = vector3(-95.9,6206.93,31.03),
    sellerPos = vector3(-1671.98,173.98,61.76),
    animals = {
        ------------------------------- attacker
        [`a_c_husky`] = {
            name = 'a_c_husky',
            attacker = true,
            chance = 22,
            loot = {
                { name = 'husky_body', count = 1 },
                { name = 'plan', count = {0,1} },
            }
        },
        [`a_c_retriever`] = {
            name = 'a_c_retriever',
            attacker = true,
            chance = 22,
            loot = {
                { name = 'retriever_body', count = 1 },
                { name = 'plan', count = {0,1} },
            }
        },
        [`a_c_rottweiler`] = {
            name = 'a_c_rottweiler',
            attacker = true,
            chance = 22,
            loot = {
                { name = 'rottweiler_body', count = 1 },
                { name = 'plan', count = {0,1} },
            }
        },
        [`a_c_shepherd`] = {
            name = 'a_c_shepherd',
            attacker = true,
            chance = 22,
            loot = {
                { name = 'shepherd_body', count = 1 },
                { name = 'plan', count = {0,1} },
            }
        },
        [`a_c_panther`] = {
            name = 'a_c_panther',
            attacker = true,
            chance = 12,
            loot = {
                { name = 'panther_body', count = 1 },
                { name = 'plan', count = {0,1} },
            }
        },
------------------------------- farm
        [`a_c_boar`] = {
            name = 'a_c_boar',
            attacker = false,
            chance = 20,
            loot = {
                { name = 'boar_body', count = 1 }
            }
        },
        [`a_c_deer`] = {
            name = 'a_c_deer',
            attacker = false,
            chance = 20,
            loot = {
                { name = 'deer_body', count = 1 }
            }
        },
        [`a_c_pig`] = {
            name = 'a_c_pig',
            attacker = false,
            chance = 20,
            loot = {
                { name = 'pig_body', count = 1 }
            }
        },
        [`a_c_rabbit_01`] = {
            name = 'a_c_rabbit_01',
            attacker = false,
            chance = 20,
            loot = {
                { name = 'rabbit_body', count = 1 }
            }
        },
        [`a_c_pigeon`] = {
            name = 'a_c_pigeon',
            attacker = false,
            chance = 10,
            loot = {
                { name = 'pigeon_body', count = 1 }
            }
        },
        [`a_c_hen`] = {
            name = 'a_c_hen',
            attacker = false,
            chance = 10,
            loot = {
                { name = 'slaughtered_chicken', count = 1 }
            }
        },
    },
    spawnAttackerChance = 35,
    allowWeapons = {
        [`weapon_musket`] = true,
        [`weapon_knife`] = true,
        [`weapon_dagger`] = true,
        [`weapon_machete`] = true,
        [`weapon_switchblade`] = true,
    },
    lootTime = 20,
    slaughterTime = 10,
    slaughter = {
        ['husky_body'] = {
            { name = 'husky_skin', count = {1,2} }
        },
        ['retriever_body'] = {
            { name = 'retriever_skin', count = {1,2} }
        },
        ['rottweiler_body'] = {
            { name = 'rottweiler_skin', count = {1,2} }
        },
        ['shepherd_body'] = {
            { name = 'shepherd_skin', count = {1,2} }
        },
        ['panther_body'] = {
            { name = 'panther_skin', count = {1,2} }
        },
        ['boar_body'] = {
            { name = 'boar_meat', count = {1,2} },
            { name = 'boar_skin', count = {1,2} }
        },
        ['deer_body'] = {
            { name = 'deer_meat', count = {1,3} },
            { name = 'deer_skin', count = {1,2} }
        },
        ['pig_body'] = {
            { name = 'pig_meat', count = {1,3} },
            { name = 'pig_skin', count = {1,2} }
        },
        ['rabbit_body'] = {
            { name = 'rabbit_meat', count = 1 }
        },
        ['pigeon_body'] = {
            { name = 'pigeon_meat', count = 1 }
        },
    },
    sellPrice = {
        ['husky_skin'] = {20000,22500},
        ['retriever_skin'] = {20000,22500},
        ['rottweiler_skin'] = {20000,22500},
        ['shepherd_skin'] = {20000,22500},
        ['panther_skin'] = {45000,50000},
        ['boar_meat'] = {5000,5500},
        ['boar_skin'] = {7000,7500},
        ['deer_meat'] = {3500,4500},
        ['deer_skin'] = {4500,5000},
        ['pig_meat'] = {3000,3500},
        ['pig_skin'] = {10000,12000},
        ['rabbit_meat'] = {7000,10000},
        ['pigeon_meat'] = {7000,10000},
    }
}