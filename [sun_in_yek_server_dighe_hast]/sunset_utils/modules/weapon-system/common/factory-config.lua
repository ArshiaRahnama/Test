-- Pub by FleeX Team , https://discord.gg/87rGBxgCsa

-- group = 1, skin + camo + yusuf
-- group = 2, scope
-- group = 3, muzzle
-- group = 4, silencer
-- group = 5, Barrel
-- group = 6, Tints ???

----------------- Camponent
local luxeVar = {
    key = 'yusskin', type = 2, group = 1, name = 'luxe_varmod', label = 'Luxary Skin',
    access = { skill = true, gang = { ['Admins'] = true } }, items = { ['comp_mat'] = 5 }
}
local compTor = {
    key = 'compsor', type = 2, group = 4, name = 'compensator', label = 'Compensator',
    access = { skill = true, gang = { ['Admins'] = true } }, items = { ['comp_mat'] = 10 }
}
local bossVar = {
    key = 'bosvar', type = 2, group = 1, name = 'boss_varmod', label = 'VIP Skin',
    access = { skill = true, gang = { ['Admins'] = true } }, items = { ['comp_mat'] = 5 }
}
local goonVar = {
    key = 'gonvar', type = 2, group = 1, name = 'goon_varmod', label = 'Bodyguard Skin',
    access = { skill = true, gang = { ['Admins'] = true } }, items = { ['comp_mat'] = 5 }
}
local muzl1 = {
    key = 'muzzl1', type = 2, group = 3, name = 'muzzle1', label = 'Muzzle Brake 1',
    access = { skill = true, gang = { ['Admins'] = true } }, items = { ['comp_mat'] = 10 }
}
local muzl2 = {
    key = 'muzzl2', type = 2, group = 3, name = 'muzzle2', label = 'Muzzle Brake 2',
    access = { skill = true, gang = { ['Admins'] = true } }, items = { ['comp_mat'] = 10 }
}
local muzl3 = {
    key = 'muzzl3', type = 2, group = 3, name = 'muzzle3', label = 'Muzzle Brake 3',
    access = { skill = true, gang = { ['Admins'] = true } }, items = { ['comp_mat'] = 10 }
}
local muzl4 = {
    key = 'muzzl4', type = 2, group = 3, name = 'muzzle4', label = 'Muzzle Brake 4',
    access = { skill = true, gang = { ['Admins'] = true } }, items = { ['comp_mat'] = 10 }
}
local muzl5 = {
    key = 'muzzl5', type = 2, group = 3, name = 'muzzle5', label = 'Muzzle Brake 5',
    access = { skill = true, gang = { ['Admins'] = true } }, items = { ['comp_mat'] = 10 }
}
local muzl6 = {
    key = 'muzzl6', type = 2, group = 3, name = 'muzzle6', label = 'Muzzle Brake 6',
    access = { skill = true, gang = { ['Admins'] = true } }, items = { ['comp_mat'] = 10 }
}
local muzl7 = {
    key = 'muzzl7', type = 2, group = 3, name = 'muzzle7', label = 'Muzzle Brake 7',
    access = { skill = true, gang = { ['Admins'] = true } }, items = { ['comp_mat'] = 10 }
}
local hBarrel = {
    key = 'hbarel', type = 2, group = 5, name = 'heavy_barrel', label = 'Heavy Barrel',
    access = { skill = true, gang = { ['Admins'] = true } }, items = { ['comp_mat'] = 10 }
}
----------------- scope 
local scopeD = {
    key = 'scopee', type = 2, group = 2, name = 'scope', label = 'Scope',
    access = { skill = true, gang = { ['Admins'] = true } }, items = { ['comp_mat'] = 4 }
}
local mounScope = {
    key = 'moscope', type = 2, group = 2, name = 'mounted_scope', label = 'Mounted Scope',
    access = { skill = true, gang = { ['Admins'] = true } }, items = { ['comp_mat'] = 4 }
}
local smScope = {
    key = 'sscope', type = 2, group = 2, name = 'small_scope', label = 'Small Scope',
    access = { skill = true, gang = { ['Admins'] = true } }, items = { ['comp_mat'] = 4 }
}
local medScope = {
    key = 'mscope', type = 2, group = 2, name = 'medium_scope', label = 'Medium Scope',
    access = { skill = true, gang = { ['Admins'] = true } }, items = { ['comp_mat'] = 4 }
}
local laScope = {
    key = 'lscope', type = 2, group = 2, name = 'large_scope', label = 'Large Scope',
    access = { skill = true, gang = { ['Admins'] = true } }, items = { ['comp_mat'] = 4 }
}
local zoScope = {
    key = 'zscope', type = 2, group = 2, name = 'zoom_scope', label = 'Zoom Scope',
    access = { skill = true, gang = { ['Admins'] = true } }, items = { ['comp_mat'] = 5 }
}
local advScope = {
    key = 'adscope', type = 2, group = 2, name = 'advanced_scope', label = 'Advanced Scope',
    access = { skill = true, gang = { ['Admins'] = true } }, items = { ['comp_mat'] = 5 }
}
local nvScope = {
    key = 'nvvscope', type = 2, group = 2, name = 'nv_scope', label = 'Night Vision Scope',
    access = { skill = true, gang = { ['Admins'] = true } }, items = { ['comp_mat'] = 10 }
}
local therScope = {
    key = 'termscope', type = 2, group = 2, name = 'thermal_scope', label = 'Thermal Scope',
    access = { skill = true, gang = { ['Admins'] = true } }, items = { ['comp_mat'] = 21 }
}

----------------- DefaultWeaponTints
local dTint1 = {
    key = 'deftin1', type = 1, num = 1, label = 'Green Skin',
    access = { skill = true, gang = { ['Admins'] = true } }, items = { ['comp_mat'] = 5 }
}
local dTint2 = {
    key = 'deftin2', type = 1, num = 2, label = 'Gold Skin',
    access = { skill = true, gang = { ['Admins'] = true } }, items = { ['comp_mat'] = 5 }
}
local dTint3 = {
    key = 'deftin3', type = 1, num = 3, label = 'Pink Skin',
    access = { skill = true, gang = { ['Admins'] = true } }, items = { ['comp_mat'] = 5 }
}
local dTint4 = {
    key = 'deftin4', type = 1, num = 4, label = 'Army Skin',
    access = { skill = true, gang = { ['Admins'] = true } }, items = { ['comp_mat'] = 5 }
}
local dTint5 = {
    key = 'deftin5', type = 1, num = 5, label = 'Blue Skin',
    access = { skill = true, gang = { ['Admins'] = true } }, items = { ['comp_mat'] = 5 }
}
local dTint6 = {
    key = 'deftin6', type = 1, num = 6, label = 'Orange Skin',
    access = { skill = true, gang = { ['Admins'] = true } }, items = { ['comp_mat'] = 5 }
}
local dTint7 = {
    key = 'deftin7', type = 1, num = 7, label = 'Platinum Skin',
    access = { skill = true, gang = { ['Admins'] = true } }, items = { ['comp_mat'] = 5 }
}

----------------- DefaultWeaponTintsMK2
local mkTint1 = {
    key = 'mkdeftin1', type = 1, num = 1, label = 'Gray Skin',
    access = { skill = true, gang = { ['Admins'] = true } }, items = { ['comp_mat'] = 5 }
}
local mkTint2 = {
    key = 'mkdeftin2', type = 1, num = 2, label = 'Two-Tone Skin',
    access = { skill = true, gang = { ['Admins'] = true } }, items = { ['comp_mat'] = 5 }
}
local mkTint3 = {
    key = 'mkdeftin3', type = 1, num = 3, label = 'White Skin',
    access = { skill = true, gang = { ['Admins'] = true } }, items = { ['comp_mat'] = 5 }
}
local mkTint4 = {
    key = 'mkdeftin4', type = 1, num = 4, label = 'Beige Skin',
    access = { skill = true, gang = { ['Admins'] = true } }, items = { ['comp_mat'] = 5 }
}
local mkTint5 = {
    key = 'mkdeftin5', type = 1, num = 5, label = 'Green Skin',
    access = { skill = true, gang = { ['Admins'] = true } }, items = { ['comp_mat'] = 5 }
}
local mkTint6 = {
    key = 'mkdeftin6', type = 1, num = 6, label = 'Blue Skin',
    access = { skill = true, gang = { ['Admins'] = true } }, items = { ['comp_mat'] = 5 }
}
local mkTint7 = {
    key = 'mkdeftin7', type = 1, num = 7, label = 'Earth Skin',
    access = { skill = true, gang = { ['Admins'] = true } }, items = { ['comp_mat'] = 5 }
}
local mkTint8 = {
    key = 'mkdeftin8', type = 1, num = 8, label = 'Brown & Black Skin',
    access = { skill = true, gang = { ['Admins'] = true } }, items = { ['comp_mat'] = 5 }
}
local mkTint9 = {
    key = 'mkdeftin9', type = 1, num = 9, label = 'Red Contrast Skin',
    access = { skill = true, gang = { ['Admins'] = true } }, items = { ['comp_mat'] = 5 }
}
local mkTint10 = {
    key = 'mkdeftin10', type = 1, num = 10, label = 'Blue Contrast Skin',
    access = { skill = true, gang = { ['Admins'] = true } }, items = { ['comp_mat'] = 5 }
}
local mkTint11 = {
    key = 'mkdeftin11', type = 1, num = 11, label = 'Yellow Contrast Skin',
    access = { skill = true, gang = { ['Admins'] = true } }, items = { ['comp_mat'] = 5 }
}
local mkTint12 = {
    key = 'mkdeftin12', type = 1, num = 12, label = 'Orange Contrast Skin',
    access = { skill = true, gang = { ['Admins'] = true } }, items = { ['comp_mat'] = 5 }
}
local mkTint13 = {
    key = 'mkdeftin13', type = 1, num = 13, label = 'Bold Pink Skin',
    access = { skill = true, gang = { ['Admins'] = true } }, items = { ['comp_mat'] = 5 }
}
local mkTint14 = {
    key = 'mkdeftin14', type = 1, num = 14, label = 'Bold Purple & Yellow Skin',
    access = { skill = true, gang = { ['Admins'] = true } }, items = { ['comp_mat'] = 5 }
}
local mkTint15 = {
    key = 'mkdeftin15', type = 1, num = 15, label = 'Bold Orange Skin',
    access = { skill = true, gang = { ['Admins'] = true } }, items = { ['comp_mat'] = 5 }
}
local mkTint16 = {
    key = 'mkdeftin16', type = 1, num = 16, label = 'Bold Green & Purple Skin',
    access = { skill = true, gang = { ['Admins'] = true } }, items = { ['comp_mat'] = 5 }
}
local mkTint17 = {
    key = 'mkdeftin17', type = 1, num = 17, label = 'Bold Red Features Skin',
    access = { skill = true, gang = { ['Admins'] = true } }, items = { ['comp_mat'] = 5 }
}
local mkTint18 = {
    key = 'mkdeftin18', type = 1, num = 18, label = 'Bold Green Features Skin',
    access = { skill = true, gang = { ['Admins'] = true } }, items = { ['comp_mat'] = 5 }
}
local mkTint19 = {
    key = 'mkdeftin19', type = 1, num = 19, label = 'Bold Cyan Features Skin',
    access = { skill = true, gang = { ['Admins'] = true } }, items = { ['comp_mat'] = 5 }
}
local mkTint20 = {
    key = 'mkdeftin20', type = 1, num = 20, label = 'Bold Yellow Features Skin',
    access = { skill = true, gang = { ['Admins'] = true } }, items = { ['comp_mat'] = 5 }
}
local mkTint21 = {
    key = 'mkdeftin21', type = 1, num = 21, label = 'Bold Red & White Skin',
    access = { skill = true, gang = { ['Admins'] = true } }, items = { ['comp_mat'] = 5 }
}
local mkTint22 = {
    key = 'mkdeftin22', type = 1, num = 22, label = 'Bold Blue & White Skin',
    access = { skill = true, gang = { ['Admins'] = true } }, items = { ['comp_mat'] = 5 }
}
local mkTint23 = {
    key = 'mkdeftin23', type = 1, num = 23, label = 'Metallic Gold Skin',
    access = { skill = true, gang = { ['Admins'] = true } }, items = { ['comp_mat'] = 5 }
}
local mkTint24 = {
    key = 'mkdeftin24', type = 1, num = 24, label = 'Metallic Platinum Skin',
    access = { skill = true, gang = { ['Admins'] = true } }, items = { ['comp_mat'] = 5 }
}
local mkTint25 = {
    key = 'mkdeftin25', type = 1, num = 25, label = 'Metallic Gray & Lilac Skin',
    access = { skill = true, gang = { ['Admins'] = true } }, items = { ['comp_mat'] = 5 }
}
local mkTint26 = {
    key = 'mkdeftin26', type = 1, num = 26, label = 'Metallic Purple & Lime Skin',
    access = { skill = true, gang = { ['Admins'] = true } }, items = { ['comp_mat'] = 5 }
}
local mkTint27 = {
    key = 'mkdeftin27', type = 1, num = 27, label = 'Metallic Red Skin',
    access = { skill = true, gang = { ['Admins'] = true } }, items = { ['comp_mat'] = 5 }
}
local mkTint28 = {
    key = 'mkdeftin28', type = 1, num = 28, label = 'Metallic Green Skin',
    access = { skill = true, gang = { ['Admins'] = true } }, items = { ['comp_mat'] = 5 }
}
local mkTint29 = {
    key = 'mkdeftin29', type = 1, num = 29, label = 'Metallic Blue Skin',
    access = { skill = true, gang = { ['Admins'] = true } }, items = { ['comp_mat'] = 5 }
}
local mkTint30 = {
    key = 'mkdeftin30', type = 1, num = 30, label = 'Metallic White & Aqua Skin',
    access = { skill = true, gang = { ['Admins'] = true } }, items = { ['comp_mat'] = 5 }
}
local mkTint31 = {
    key = 'mkdeftin31', type = 1, num = 31, label = 'Metallic Red & Yellow Skin',
    access = { skill = true, gang = { ['Admins'] = true } }, items = { ['comp_mat'] = 5 }
}

----------------- Camo
local camoCom1 = {
    key = 'camoo1', type = 2, group = 1, name = 'camo1', label = 'Camo 1',
    access = { skill = true, gang = { ['Admins'] = true } }, items = { ['comp_mat'] = 5 }
}
local camoCom2 = {
    key = 'camoo2', type = 2, group = 1, name = 'camo2', label = 'Camo 2',
    access = { skill = true, gang = { ['Admins'] = true } }, items = { ['comp_mat'] = 5 }
}
local camoCom3 = {
    key = 'camoo3', type = 2, group = 1, name = 'camo3', label = 'Camo 3',
    access = { skill = true, gang = { ['Admins'] = true } }, items = { ['comp_mat'] = 5 }
}
local camoCom4 = {
    key = 'camoo4', type = 2, group = 1, name = 'camo4', label = 'Camo 4',
    access = { skill = true, gang = { ['Admins'] = true } }, items = { ['comp_mat'] = 5 }
}
local camoCom5 = {
    key = 'camoo5', type = 2, group = 1, name = 'camo5', label = 'Camo 5',
    access = { skill = true, gang = { ['Admins'] = true } }, items = { ['comp_mat'] = 5 }
}
local camoCom6 = {
    key = 'camoo6', type = 2, group = 1, name = 'camo6', label = 'Camo 6',
    access = { skill = true, gang = { ['Admins'] = true } }, items = { ['comp_mat'] = 5 }
}
local camoCom7 = {
    key = 'camoo7', type = 2, group = 1, name = 'camo7', label = 'Camo 7',
    access = { skill = true, gang = { ['Admins'] = true } }, items = { ['comp_mat'] = 5 }
}
local camoCom8 = {
    key = 'camoo8', type = 2, group = 1, name = 'camo8', label = 'Camo 8',
    access = { skill = true, gang = { ['Admins'] = true } }, items = { ['comp_mat'] = 5 }
}
local camoCom9 = {
    key = 'camoo9', type = 2, group = 1, name = 'camo9', label = 'Camo 9',
    access = { skill = true, gang = { ['Admins'] = true } }, items = { ['comp_mat'] = 5 }
}
local camoCom10 = {
    key = 'camoo10', type = 2, group = 1, name = 'camo10', label = 'Camo 10',
    access = { skill = true, gang = { ['Admins'] = true } }, items = { ['comp_mat'] = 5 }
}
local camoCom11 = {
    key = 'camoo11', type = 2, group = 1, name = 'camo11', label = 'Camo 11',
    access = { skill = true, gang = { ['Admins'] = true } }, items = { ['comp_mat'] = 5 }
}
local camoCom12 = {
    key = 'camoo12', type = 2, group = 1, name = 'camo12', label = 'Camo 12',
    access = { skill = true, gang = { ['Admins'] = true } }, items = { ['comp_mat'] = 5 }
}
local camoCom13 = {
    key = 'camoo13', type = 2, group = 1, name = 'camo13', label = 'Camo 13',
    access = { skill = true, gang = { ['Admins'] = true } }, items = { ['comp_mat'] = 5 }
}
local camoCom14 = {
    key = 'camoo14', type = 2, group = 1, name = 'camo14', label = 'Camo 14',
    access = { skill = true, gang = { ['Admins'] = true } }, items = { ['comp_mat'] = 5 }
}
local camoCom15 = {
    key = 'camoo15', type = 2, group = 1, name = 'camo15', label = 'Camo 15',
    access = { skill = true, gang = { ['Admins'] = true } }, items = { ['comp_mat'] = 5 }
}
local camoCom16 = {
    key = 'camoo16', type = 2, group = 1, name = 'camo16', label = 'Camo 16',
    access = { skill = true, gang = { ['Admins'] = true } }, items = { ['comp_mat'] = 5 }
}
local camoCom17 = {
    key = 'camoo17', type = 2, group = 1, name = 'camo17', label = 'Camo 17',
    access = { skill = true, gang = { ['Admins'] = true } }, items = { ['comp_mat'] = 5 }
}
local camoCom18 = {
    key = 'camoo18', type = 2, group = 1, name = 'camo18', label = 'Camo 18',
    access = { skill = true, gang = { ['Admins'] = true } }, items = { ['comp_mat'] = 5 }
}
local camoCom19 = {
    key = 'camoo19', type = 2, group = 1, name = 'camo19', label = 'Camo 19',
    access = { skill = true, gang = { ['Admins'] = true } }, items = { ['comp_mat'] = 5 }
}
local camoCom20 = {
    key = 'camoo20', type = 2, group = 1, name = 'camo20', label = 'Camo 20',
    access = { skill = true, gang = { ['Admins'] = true } }, items = { ['comp_mat'] = 5 }
}
local camoCom21 = {
    key = 'camoo21', type = 2, group = 1, name = 'camo21', label = 'Camo 21',
    access = { skill = true, gang = { ['Admins'] = true } }, items = { ['comp_mat'] = 5 }
}
local camoCom22 = {
    key = 'camoo22', type = 2, group = 1, name = 'camo22', label = 'Camo 22',
    access = { skill = true, gang = { ['Admins'] = true } }, items = { ['comp_mat'] = 5 }
}

----------------- Chromium Weapons (skill = false)
local chrCamo1 = {
    key = 'camoo1', type = 2, group = 1, name = 'camo1', label = 'Purple Pink Chromium',
    access = { skill = false, gang = { ['Admins'] = true } }, items = { ['comp_mat'] = 5 }
}
local chrCamo2 = {
    key = 'camoo2', type = 2, group = 1, name = 'camo2', label = 'Red Chromium',
    access = { skill = false, gang = { ['Admins'] = true } }, items = { ['comp_mat'] = 5 }
}
local chrCamo3 = {
    key = 'camoo3', type = 2, group = 1, name = 'camo3', label = 'Gold',
    access = { skill = false, gang = { ['Admins'] = true } }, items = { ['comp_mat'] = 5 }
}
local chrDTint1 = {
    key = 'deftin1', type = 1, num = 1, label = 'Green Skin',
    access = { skill = false, gang = { ['Admins'] = true } }, items = { ['comp_mat'] = 5 }
}
local chrDTint2 = {
    key = 'deftin2', type = 1, num = 2, label = 'Gold Skin',
    access = { skill = false, gang = { ['Admins'] = true } }, items = { ['comp_mat'] = 5 }
}
local chrDTint3 = {
    key = 'deftin3', type = 1, num = 3, label = 'Pink Skin',
    access = { skill = false, gang = { ['Admins'] = true } }, items = { ['comp_mat'] = 5 }
}
local chrDTint4 = {
    key = 'deftin4', type = 1, num = 4, label = 'Army Skin',
    access = { skill = false, gang = { ['Admins'] = true } }, items = { ['comp_mat'] = 5 }
}
local chrDTint5 = {
    key = 'deftin5', type = 1, num = 5, label = 'Blue Skin',
    access = { skill = false, gang = { ['Admins'] = true } }, items = { ['comp_mat'] = 5 }
}
local chrDTint6 = {
    key = 'deftin6', type = 1, num = 6, label = 'Orange Skin',
    access = { skill = false, gang = { ['Admins'] = true } }, items = { ['comp_mat'] = 5 }
}
local chrDTint7 = {
    key = 'deftin7', type = 1, num = 7, label = 'Platinum Skin',
    access = { skill = false, gang = { ['Admins'] = true } }, items = { ['comp_mat'] = 5 }
}
local chrMkTint1 = {
    key = 'mkdeftin1', type = 1, num = 1, label = 'Gray Skin',
    access = { skill = false, gang = { ['Admins'] = true } }, items = { ['comp_mat'] = 5 }
}
local chrMkTint2 = {
    key = 'mkdeftin2', type = 1, num = 2, label = 'Two-Tone Skin',
    access = { skill = false, gang = { ['Admins'] = true } }, items = { ['comp_mat'] = 5 }
}
local chrMkTint3 = {
    key = 'mkdeftin3', type = 1, num = 3, label = 'White Skin',
    access = { skill = false, gang = { ['Admins'] = true } }, items = { ['comp_mat'] = 5 }
}
local chrMkTint4 = {
    key = 'mkdeftin4', type = 1, num = 4, label = 'Beige Skin',
    access = { skill = false, gang = { ['Admins'] = true } }, items = { ['comp_mat'] = 5 }
}

weaponFactoryConfig = {
    types = {
        [1] = 'Tints',
        [2] = 'Attachments',
        [3] = 'Models',
    },
    peds = {
        `s_m_y_construct_01`,
    },
    locations = {
        vec(-3169.11, 1082.44, 20.84, 339.14),
    },
    preview = {
        vec(-3173.42, 1087.03, 21.83, 339.36),
    },
    weapons = {
        ['WEAPON_SMG'] = {
            -- 'WEAPON_SMG2', --addongun
        },
    },
    list = {
        ----- Pistol Weapon
        ['WEAPON_PISTOL'] = {
            luxeVar, dTint1, dTint2, dTint3, dTint4, dTint5, dTint6, dTint7
        },
        ['WEAPON_PISTOL_MK2'] = {
            mounScope, compTor,
            camoCom1, camoCom2, camoCom3, camoCom4, camoCom5, camoCom6, camoCom7, camoCom8, camoCom9, camoCom10, camoCom11, camoCom12,
            camoCom13, camoCom14, camoCom15, camoCom16, camoCom17, camoCom18, camoCom19, camoCom20, camoCom21, camoCom22,
            mkTint1, mkTint2, mkTint3, mkTint4, mkTint5, mkTint6, mkTint7, mkTint8, mkTint9, mkTint10, mkTint11, mkTint12, mkTint13, mkTint14, mkTint15, mkTint16,
            mkTint17, mkTint18, mkTint19, mkTint20, mkTint21, mkTint22, mkTint23, mkTint24, mkTint25, mkTint26, mkTint27, mkTint28, mkTint29, mkTint30, mkTint31
        },
        ['WEAPON_COMBATPISTOL'] = {
            luxeVar, dTint1, dTint2, dTint3, dTint4, dTint5, dTint6, dTint7
        },
        ['WEAPON_APPISTOL'] = {
            luxeVar, dTint1, dTint2, dTint3, dTint4, dTint5, dTint6, dTint7
        },
        ['WEAPON_PISTOL50'] = {
            luxeVar, dTint1, dTint2, dTint3, dTint4, dTint5, dTint6, dTint7
        },
        ['WEAPON_SNSPISTOL'] = {
            luxeVar, dTint1, dTint2, dTint3, dTint4, dTint5, dTint6, dTint7
        },
        ['WEAPON_SNSPISTOL_MK2'] = {
            mounScope, compTor,
            camoCom1, camoCom2, camoCom3, camoCom4, camoCom5, camoCom6, camoCom7, camoCom8, camoCom9, camoCom10, camoCom11, camoCom12,
            camoCom13, camoCom14, camoCom15, camoCom16, camoCom17, camoCom18, camoCom19, camoCom20, camoCom21, camoCom22,
            mkTint1, mkTint2, mkTint3, mkTint4, mkTint5, mkTint6, mkTint7, mkTint8, mkTint9, mkTint10, mkTint11, mkTint12, mkTint13, mkTint14, mkTint15, mkTint16,
            mkTint17, mkTint18, mkTint19, mkTint20, mkTint21, mkTint22, mkTint23, mkTint24, mkTint25, mkTint26, mkTint27, mkTint28, mkTint29, mkTint30, mkTint31
        },
        ['WEAPON_HEAVYPISTOL'] = {
            luxeVar, dTint1, dTint2, dTint3, dTint4, dTint5, dTint6, dTint7
        },
        ['WEAPON_VINTAGEPISTOL'] = {
            dTint1, dTint2, dTint3, dTint4, dTint5, dTint6, dTint7
        },
        ['WEAPON_MARKSMANPISTOL'] = {
            dTint1, dTint2, dTint3, dTint4, dTint5, dTint6, dTint7
        },
        ['WEAPON_REVOLVER'] = {
            bossVar, goonVar, dTint1, dTint2, dTint3, dTint4, dTint5, dTint6, dTint7
        },
        ['WEAPON_REVOLVER_MK2'] = {
            smScope, compTor,
            camoCom1, camoCom2, camoCom3, camoCom4, camoCom5, camoCom6, camoCom7, camoCom8, camoCom9, camoCom10, camoCom11,
            mkTint1, mkTint2, mkTint3, mkTint4, mkTint5, mkTint6, mkTint7, mkTint8, mkTint9, mkTint10, mkTint11, mkTint12, mkTint13, mkTint14, mkTint15, mkTint16,
            mkTint17, mkTint18, mkTint19, mkTint20, mkTint21, mkTint22, mkTint23, mkTint24, mkTint25, mkTint26, mkTint27, mkTint28, mkTint29, mkTint30, mkTint31
        },
        ['WEAPON_DOUBLEACTION'] = {
            dTint1, dTint2, dTint3, dTint4, dTint5, dTint6, dTint7
        },
        ['WEAPON_CERAMICPISTOL'] = {
            dTint1, dTint2, dTint3, dTint4, dTint5, dTint6, dTint7
        },
        ['WEAPON_NAVYREVOLVER'] = {
            dTint1, dTint2, dTint3, dTint4, dTint5, dTint6, dTint7
        },
        ['WEAPON_GADGETPISTOL'] = {
            dTint1, dTint2, dTint3, dTint4, dTint5, dTint6, dTint7
        },
        ['WEAPON_PISTOLXM3'] = {
            dTint1, dTint2, dTint3, dTint4, dTint5, dTint6, dTint7
        },
        ----- SMG Weapon
        ['WEAPON_SMG'] = {
            scopeD, luxeVar, dTint1, dTint2, dTint3, dTint4, dTint5, dTint6, dTint7
        },
        ['WEAPON_SMG_MK2'] = {
            smScope, medScope, muzl1, muzl2, muzl3, muzl4, muzl5, muzl6, muzl7, hBarrel,
            camoCom1, camoCom2, camoCom3, camoCom4, camoCom5, camoCom6, camoCom7, camoCom8, camoCom9, camoCom10, camoCom11,
            mkTint1, mkTint2, mkTint3, mkTint4, mkTint5, mkTint6, mkTint7, mkTint8, mkTint9, mkTint10, mkTint11, mkTint12, mkTint13, mkTint14, mkTint15, mkTint16,
            mkTint17, mkTint18, mkTint19, mkTint20, mkTint21, mkTint22, mkTint23, mkTint24, mkTint25, mkTint26, mkTint27, mkTint28, mkTint29, mkTint30, mkTint31
        },
        ['WEAPON_ASSAULTSMG'] = {
            scopeD, luxeVar, dTint1, dTint2, dTint3, dTint4, dTint5, dTint6, dTint7
        },
        ['WEAPON_MICROSMG'] = {
            scopeD, luxeVar, dTint1, dTint2, dTint3, dTint4, dTint5, dTint6, dTint7
        },
        ['WEAPON_COMBATPDW'] = {
            scopeD, dTint1, dTint2, dTint3, dTint4, dTint5, dTint6, dTint7
        },
        ['WEAPON_MACHINEPISTOL'] = {
            dTint1, dTint2, dTint3, dTint4, dTint5, dTint6, dTint7
        },
        ['WEAPON_MINISMG'] = {
            dTint1, dTint2, dTint3, dTint4, dTint5, dTint6, dTint7
        },
        ['WEAPON_TECPISTOL'] = {
            dTint1, dTint2, dTint3, dTint4, dTint5, dTint6, dTint7
        },
        --- ShotGun Weapon
        ['WEAPON_PUMPSHOTGUN'] = {
            luxeVar, dTint1, dTint2, dTint3, dTint4, dTint5, dTint6, dTint7
        },
        ['WEAPON_PUMPSHOTGUN_MK2'] = {
            smScope, medScope, muzl1, camoCom1, camoCom2, camoCom3, camoCom4, camoCom5, camoCom6, camoCom7, camoCom8, camoCom9, camoCom10, camoCom11,
            mkTint1, mkTint2, mkTint3, mkTint4, mkTint5, mkTint6, mkTint7, mkTint8, mkTint9, mkTint10, mkTint11, mkTint12, mkTint13, mkTint14, mkTint15, mkTint16,
            mkTint17, mkTint18, mkTint19, mkTint20, mkTint21, mkTint22, mkTint23, mkTint24, mkTint25, mkTint26, mkTint27, mkTint28, mkTint29, mkTint30, mkTint31
        },
        ['WEAPON_SAWNOFFSHOTGUN'] = {
            luxeVar, dTint1, dTint2, dTint3, dTint4, dTint5, dTint6, dTint7
        },
        ['WEAPON_ASSAULTSHOTGUN'] = {
            dTint1, dTint2, dTint3, dTint4, dTint5, dTint6, dTint7
        },
        ['WEAPON_BULLPUPSHOTGUN'] = {
            dTint1, dTint2, dTint3, dTint4, dTint5, dTint6, dTint7
        },
        ['WEAPON_MUSKET'] = {
            dTint1, dTint2, dTint3, dTint4, dTint5, dTint6, dTint7
        },
        ['WEAPON_HEAVYSHOTGUN'] = {
            dTint1, dTint2, dTint3, dTint4, dTint5, dTint6, dTint7
        },
        ['WEAPON_DBSHOTGUN'] = {
            dTint1, dTint2, dTint3, dTint4, dTint5, dTint6, dTint7
        },
        ['WEAPON_AUTOSHOTGUN'] = {
            dTint1, dTint2, dTint3, dTint4, dTint5, dTint6, dTint7
        },
        ['WEAPON_COMBATSHOTGUN'] = {
            dTint1, dTint2, dTint3, dTint4, dTint5, dTint6, dTint7
        },
        --- Rifle Weapon
        ['WEAPON_ASSAULTRIFLE'] = {
            scopeD, luxeVar, dTint1, dTint2, dTint3, dTint4, dTint5, dTint6, dTint7
        },
        ['WEAPON_ASSAULTRIFLE_MK2'] = {
            smScope, laScope, muzl1, muzl2, muzl3, muzl4, muzl5, muzl6, muzl7, hBarrel,
            camoCom1, camoCom2, camoCom3, camoCom4, camoCom5, camoCom6, camoCom7, camoCom8, camoCom9, camoCom10, camoCom11,
            mkTint1, mkTint2, mkTint3, mkTint4, mkTint5, mkTint6, mkTint7, mkTint8, mkTint9, mkTint10, mkTint11, mkTint12, mkTint13, mkTint14, mkTint15, mkTint16,
            mkTint17, mkTint18, mkTint19, mkTint20, mkTint21, mkTint22, mkTint23, mkTint24, mkTint25, mkTint26, mkTint27, mkTint28, mkTint29, mkTint30, mkTint31
        },
        ['WEAPON_CARBINERIFLE'] = {
            scopeD, luxeVar, dTint1, dTint2, dTint3, dTint4, dTint5, dTint6, dTint7
        },
        ['WEAPON_CARBINERIFLE_MK2'] = {
            smScope, laScope, muzl1, muzl2, muzl3, muzl4, muzl5, muzl6, muzl7, hBarrel,
            camoCom1, camoCom2, camoCom3, camoCom4, camoCom5, camoCom6, camoCom7, camoCom8, camoCom9, camoCom10, camoCom11,
            mkTint1, mkTint2, mkTint3, mkTint4, mkTint5, mkTint6, mkTint7, mkTint8, mkTint9, mkTint10, mkTint11, mkTint12, mkTint13, mkTint14, mkTint15, mkTint16,
            mkTint17, mkTint18, mkTint19, mkTint20, mkTint21, mkTint22, mkTint23, mkTint24, mkTint25, mkTint26, mkTint27, mkTint28, mkTint29, mkTint30, mkTint31
        },
        ['WEAPON_ADVANCEDRIFLE'] = {
            scopeD, luxeVar, dTint1, dTint2, dTint3, dTint4, dTint5, dTint6, dTint7
        },
        ['WEAPON_SPECIALCARBINE'] = {
            scopeD, luxeVar, dTint1, dTint2, dTint3, dTint4, dTint5, dTint6, dTint7
        },
        ['WEAPON_SPECIALCARBINE_MK2'] = {
            smScope, laScope, muzl1, muzl2, muzl3, muzl4, muzl5, muzl6, muzl7, hBarrel,
            camoCom1, camoCom2, camoCom3, camoCom4, camoCom5, camoCom6, camoCom7, camoCom8, camoCom9, camoCom10, camoCom11,
            mkTint1, mkTint2, mkTint3, mkTint4, mkTint5, mkTint6, mkTint7, mkTint8, mkTint9, mkTint10, mkTint11, mkTint12, mkTint13, mkTint14, mkTint15, mkTint16,
            mkTint17, mkTint18, mkTint19, mkTint20, mkTint21, mkTint22, mkTint23, mkTint24, mkTint25, mkTint26, mkTint27, mkTint28, mkTint29, mkTint30, mkTint31
        },
        ['WEAPON_BULLPUPRIFLE'] = {
            scopeD, luxeVar, dTint1, dTint2, dTint3, dTint4, dTint5, dTint6, dTint7
        },
        ['WEAPON_BULLPUPRIFLE_MK2'] = {
            smScope, medScope, muzl1, muzl2, muzl3, muzl4, muzl5, muzl6, muzl7, hBarrel,
            camoCom1, camoCom2, camoCom3, camoCom4, camoCom5, camoCom6, camoCom7, camoCom8, camoCom9, camoCom10, camoCom11,
            mkTint1, mkTint2, mkTint3, mkTint4, mkTint5, mkTint6, mkTint7, mkTint8, mkTint9, mkTint10, mkTint11, mkTint12, mkTint13, mkTint14, mkTint15, mkTint16,
            mkTint17, mkTint18, mkTint19, mkTint20, mkTint21, mkTint22, mkTint23, mkTint24, mkTint25, mkTint26, mkTint27, mkTint28, mkTint29, mkTint30, mkTint31
        },
        ['WEAPON_COMPACTRIFLE'] = {
            dTint1, dTint2, dTint3, dTint4, dTint5, dTint6, dTint7
        },
        ['WEAPON_MILITARYRIFLE'] = {
            scopeD, dTint1, dTint2, dTint3, dTint4, dTint5, dTint6, dTint7
        },
        ['WEAPON_TACTICALRIFLE'] = {
            dTint1, dTint2, dTint3, dTint4, dTint5, dTint6, dTint7
        },
        ['WEAPON_HEAVYRIFLE'] = {
            scopeD, camoCom1, dTint1, dTint2, dTint3, dTint4, dTint5, dTint6, dTint7
        },
        -- MG Weapon
        ['WEAPON_MG'] = {
            scopeD, luxeVar, dTint1, dTint2, dTint3, dTint4, dTint5, dTint6, dTint7
        },
        ['WEAPON_COMBATMG'] = {
            scopeD, luxeVar, dTint1, dTint2, dTint3, dTint4, dTint5, dTint6, dTint7
        },
        ['WEAPON_COMBATMG_MK2'] = {
            medScope, laScope, muzl1, muzl2, muzl3, muzl4, muzl5, muzl6, muzl7, hBarrel,
            camoCom1, camoCom2, camoCom3, camoCom4, camoCom5, camoCom6, camoCom7, camoCom8, camoCom9, camoCom10, camoCom11,
            mkTint1, mkTint2, mkTint3, mkTint4, mkTint5, mkTint6, mkTint7, mkTint8, mkTint9, mkTint10, mkTint11, mkTint12, mkTint13, mkTint14, mkTint15, mkTint16,
            mkTint17, mkTint18, mkTint19, mkTint20, mkTint21, mkTint22, mkTint23, mkTint24, mkTint25, mkTint26, mkTint27, mkTint28, mkTint29, mkTint30, mkTint31
        },
        ['WEAPON_GUSENBERG'] = {
            dTint1, dTint2, dTint3, dTint4, dTint5, dTint6, dTint7
        },
        -- Sniper Weapon
        ['WEAPON_SNIPERRIFLE'] = {
            {    -- scopeD
                key = 'scopee', type = 2, group = 2, name = 'scope', label = 'Scope',
                access = { all = true }, items = { ['comp_mat'] = 10 }
            }, { -- advScope
                key = 'adscope', type = 2, group = 2, name = 'advanced_scope', label = 'Advanced Scope',
                access = { all = true }, items = { ['comp_mat'] = 10 }
            }, { -- luxeVar
                key = 'yusskin', type = 2, group = 1, name = 'luxe_varmod', label = 'Luxary Skin',
                access = { all = true }, items = { ['comp_mat'] = 10 }
            }, { -- dTint1
                key = 'deftin1', type = 1, num = 1, label = 'Green Skin',
                access = { all = true }, items = { ['comp_mat'] = 10 }
            }, { -- dTint2
                key = 'deftin2', type = 1, num = 2, label = 'Gold Skin',
                access = { all = true }, items = { ['comp_mat'] = 10 }
            }, { -- dTint3
                key = 'deftin3', type = 1, num = 3, label = 'Pink Skin',
                access = { all = true }, items = { ['comp_mat'] = 10 }
            }, { -- dTint4
                key = 'deftin4', type = 1, num = 4, label = 'Army Skin',
                access = { all = true }, items = { ['comp_mat'] = 10 }
            }, { -- dTint5
                key = 'deftin5', type = 1, num = 5, label = 'Blue Skin',
                access = { all = true }, items = { ['comp_mat'] = 10 }
            }, { -- dTint6
                key = 'deftin6', type = 1, num = 6, label = 'Orange Skin',
                access = { all = true }, items = { ['comp_mat'] = 10 }
            }, { -- dTint7
                key = 'deftin7', type = 1, num = 7, label = 'Platinum Skin',
                access = { all = true }, items = { ['comp_mat'] = 10 }
            }
        },
        ['WEAPON_HEAVYSNIPER'] = {
            scopeD, advScope, dTint1, dTint2, dTint3, dTint4, dTint5, dTint6, dTint7
        },
        ['WEAPON_HEAVYSNIPER_MK2'] = {
            -- { -- therScope
            --     key = 'termscope', type = 2, group = 2, name = 'thermal_scope', label = 'Thermal Scope',
            --     access = { skill = true}, items = { ['comp_mat'] = 21 }
            -- },
            { -- advScope
                key = 'adscope', type = 2, group = 2, name = 'advanced_scope', label = 'Advanced Scope',
                access = { all = true }, items = { ['comp_mat'] = 10 }
            }, { -- nvScope
                key = 'nvvscope', type = 2, group = 2, name = 'nv_scope', label = 'Night Vision Scope',
                access = { all = true }, items = { ['comp_mat'] = 10 }
            }, { -- muzl1
                key = 'muzzl1', type = 2, group = 3, name = 'muzzle1', label = 'Muzzle Brake 1',
                access = { all = true }, items = { ['comp_mat'] = 10 }
            }, { -- muzl2
                key = 'muzzl2', type = 2, group = 3, name = 'muzzle2', label = 'Muzzle Brake 2',
                access = { all = true }, items = { ['comp_mat'] = 10 }
            }, { -- hBarrel
                key = 'hbarel', type = 2, group = 5, name = 'heavy_barrel', label = 'Heavy Barrel',
                access = { all = true }, items = { ['comp_mat'] = 10 }
            }, { -- camoCom1
                key = 'camoo1', type = 2, group = 1, name = 'camo1', label = 'Camo 1',
                access = { all = true }, items = { ['comp_mat'] = 5 }
            }, { -- camoCom2
                key = 'camoo2', type = 2, group = 1, name = 'camo2', label = 'Camo 2',
                access = { all = true }, items = { ['comp_mat'] = 5 }
            }, { -- camoCom3
                key = 'camoo3', type = 2, group = 1, name = 'camo3', label = 'Camo 3',
                access = { all = true }, items = { ['comp_mat'] = 5 }
            }, { -- camoCom4
                key = 'camoo4', type = 2, group = 1, name = 'camo4', label = 'Camo 4',
                access = { all = true }, items = { ['comp_mat'] = 5 }
            }, { -- camoCom5
                key = 'camoo5', type = 2, group = 1, name = 'camo5', label = 'Camo 5',
                access = { all = true }, items = { ['comp_mat'] = 5 }
            }, { -- camoCom6
                key = 'camoo6', type = 2, group = 1, name = 'camo6', label = 'Camo 6',
                access = { all = true }, items = { ['comp_mat'] = 5 }
            }, { -- camoCom7
                key = 'camoo7', type = 2, group = 1, name = 'camo7', label = 'Camo 7',
                access = { all = true }, items = { ['comp_mat'] = 5 }
            }, { -- camoCom8
                key = 'camoo8', type = 2, group = 1, name = 'camo8', label = 'Camo 8',
                access = { all = true }, items = { ['comp_mat'] = 5 }
            }, { -- camoCom9
                key = 'camoo9', type = 2, group = 1, name = 'camo9', label = 'Camo 9',
                access = { all = true }, items = { ['comp_mat'] = 5 }
            }, { -- camoCom10
                key = 'camoo10', type = 2, group = 1, name = 'camo10', label = 'Camo 10',
                access = { all = true }, items = { ['comp_mat'] = 5 }
            }, { -- camoCom11
                key = 'camoo11', type = 2, group = 1, name = 'camo11', label = 'Camo 11',
                access = { all = true }, items = { ['comp_mat'] = 5 }
            }, { -- mkTint1
                key = 'mkdeftin1', type = 1, num = 1, label = 'Gray Skin',
                access = { all = true }, items = { ['comp_mat'] = 5 }
            }, { -- mkTint2
                key = 'mkdeftin2', type = 1, num = 2, label = 'Two-Tone Skin',
                access = { all = true }, items = { ['comp_mat'] = 5 }
            }, { -- mkTint3
                key = 'mkdeftin3', type = 1, num = 3, label = 'White Skin',
                access = { all = true }, items = { ['comp_mat'] = 5 }
            }, { -- mkTint4
                key = 'mkdeftin4', type = 1, num = 4, label = 'Beige Skin',
                access = { all = true }, items = { ['comp_mat'] = 5 }
            }, { -- mkTint5
                key = 'mkdeftin5', type = 1, num = 5, label = 'Green Skin',
                access = { all = true }, items = { ['comp_mat'] = 5 }
            }, { -- mkTint6
                key = 'mkdeftin6', type = 1, num = 6, label = 'Blue Skin',
                access = { all = true }, items = { ['comp_mat'] = 5 }
            }, { -- mkTint7
                key = 'mkdeftin7', type = 1, num = 7, label = 'Earth Skin',
                access = { all = true }, items = { ['comp_mat'] = 5 }
            }, { -- mkTint8
                key = 'mkdeftin8', type = 1, num = 8, label = 'Brown & Black Skin',
                access = { all = true }, items = { ['comp_mat'] = 5 }
            }, { -- mkTint9
                key = 'mkdeftin9', type = 1, num = 9, label = 'Red Contrast Skin',
                access = { all = true }, items = { ['comp_mat'] = 5 }
            }, { -- mkTint10
                key = 'mkdeftin10', type = 1, num = 10, label = 'Blue Contrast Skin',
                access = { all = true }, items = { ['comp_mat'] = 5 }
            }, { -- mkTint11
                key = 'mkdeftin11', type = 1, num = 11, label = 'Yellow Contrast Skin',
                access = { all = true }, items = { ['comp_mat'] = 5 }
            }, { -- mkTint12
                key = 'mkdeftin12', type = 1, num = 12, label = 'Orange Contrast Skin',
                access = { all = true }, items = { ['comp_mat'] = 5 }
            }, { -- mkTint13
                key = 'mkdeftin13', type = 1, num = 13, label = 'Bold Pink Skin',
                access = { all = true }, items = { ['comp_mat'] = 5 }
            }, { -- mkTint14
                key = 'mkdeftin14', type = 1, num = 14, label = 'Bold Purple & Yellow Skin',
                access = { all = true }, items = { ['comp_mat'] = 5 }
            }, { -- mkTint15
                key = 'mkdeftin15', type = 1, num = 15, label = 'Bold Orange Skin',
                access = { all = true }, items = { ['comp_mat'] = 5 }
            }, { -- mkTint16
                key = 'mkdeftin16', type = 1, num = 16, label = 'Bold Green & Purple Skin',
                access = { all = true }, items = { ['comp_mat'] = 5 }
            }, { -- mkTint17
                key = 'mkdeftin17', type = 1, num = 17, label = 'Bold Red Features Skin',
                access = { all = true }, items = { ['comp_mat'] = 5 }
            }, { -- mkTint18
                key = 'mkdeftin18', type = 1, num = 18, label = 'Bold Green Features Skin',
                access = { all = true }, items = { ['comp_mat'] = 5 }
            }, { -- mkTint19
                key = 'mkdeftin19', type = 1, num = 19, label = 'Bold Cyan Features Skin',
                access = { all = true }, items = { ['comp_mat'] = 5 }
            }, { -- mkTint20
                key = 'mkdeftin20', type = 1, num = 20, label = 'Bold Yellow Features Skin',
                access = { all = true }, items = { ['comp_mat'] = 5 }
            }, { -- mkTint21
                key = 'mkdeftin21', type = 1, num = 21, label = 'Bold Red & White Skin',
                access = { all = true }, items = { ['comp_mat'] = 5 }
            }, { -- mkTint22
                key = 'mkdeftin22', type = 1, num = 22, label = 'Bold Blue & White Skin',
                access = { all = true }, items = { ['comp_mat'] = 5 }
            }, { -- mkTint23
                key = 'mkdeftin23', type = 1, num = 23, label = 'Metallic Gold Skin',
                access = { all = true }, items = { ['comp_mat'] = 5 }
            }, { -- mkTint24
                key = 'mkdeftin24', type = 1, num = 24, label = 'Metallic Platinum Skin',
                access = { all = true }, items = { ['comp_mat'] = 5 }
            }, { -- mkTint25
                key = 'mkdeftin25', type = 1, num = 25, label = 'Metallic Gray & Lilac Skin',
                access = { all = true }, items = { ['comp_mat'] = 5 }
            }, { -- mkTint26
                key = 'mkdeftin26', type = 1, num = 26, label = 'Metallic Purple & Lime Skin',
                access = { all = true }, items = { ['comp_mat'] = 5 }
            }, { -- mkTint27
                key = 'mkdeftin27', type = 1, num = 27, label = 'Metallic Red Skin',
                access = { all = true }, items = { ['comp_mat'] = 5 }
            }, { -- mkTint28
                key = 'mkdeftin28', type = 1, num = 28, label = 'Metallic Green Skin',
                access = { all = true }, items = { ['comp_mat'] = 5 }
            }, { -- mkTint29
                key = 'mkdeftin29', type = 1, num = 29, label = 'Metallic Blue Skin',
                access = { all = true }, items = { ['comp_mat'] = 5 }
            }, { -- mkTint30
                key = 'mkdeftin30', type = 1, num = 30, label = 'Metallic White & Aqua Skin',
                access = { all = true }, items = { ['comp_mat'] = 5 }
            }, { -- mkTint31
                key = 'mkdeftin31', type = 1, num = 31, label = 'Metallic Red & Yellow Skin',
                access = { all = true }, items = { ['comp_mat'] = 5 }
            }
        },
        ['WEAPON_MARKSMANRIFLE'] = {
            scopeD, luxeVar, dTint1, dTint2, dTint3, dTint4, dTint5, dTint6, dTint7
        },
        ['WEAPON_MARKSMANRIFLE_MK2'] = {
            laScope, zoScope, muzl1, muzl2, muzl3, muzl4, muzl5, muzl6, muzl7, hBarrel,
            camoCom1, camoCom2, camoCom3, camoCom4, camoCom5, camoCom6, camoCom7, camoCom8, camoCom9, camoCom10, camoCom11,
            mkTint1, mkTint2, mkTint3, mkTint4, mkTint5, mkTint6, mkTint7, mkTint8, mkTint9, mkTint10, mkTint11, mkTint12, mkTint13, mkTint14, mkTint15, mkTint16,
            mkTint17, mkTint18, mkTint19, mkTint20, mkTint21, mkTint22, mkTint23, mkTint24, mkTint25, mkTint26, mkTint27, mkTint28, mkTint29, mkTint30, mkTint31
        },
        ['WEAPON_PRECISIONRIFLE'] = {
            dTint1, dTint2, dTint3, dTint4, dTint5, dTint6, dTint7
        },
        ----- Chromium Weapons (TINT_GUNRUNNING)
        ['WEAPON_AK_47_CHR'] = {
            chrCamo1, chrCamo2, chrCamo3, chrMkTint1, chrMkTint2, chrMkTint3, chrMkTint4
        },
        ['WEAPON_AR_15_CHR'] = {
            chrCamo1, chrCamo2, chrCamo3, chrMkTint1, chrMkTint2, chrMkTint3, chrMkTint4
        },
        ['WEAPON_BZ_199_CHR'] = {
            chrCamo1, chrCamo2, chrCamo3, chrMkTint1, chrMkTint2, chrMkTint3, chrMkTint4
        },
        ['WEAPON_GAU_5A_CHR'] = {
            chrCamo1, chrCamo2, chrCamo3, chrMkTint1, chrMkTint2, chrMkTint3, chrMkTint4
        },
        ['WEAPON_HOWA_T20_CHR'] = {
            chrCamo1, chrCamo2, chrCamo3, chrMkTint1, chrMkTint2, chrMkTint3, chrMkTint4
        },
        ['WEAPON_HX_15_CHR'] = {
            chrCamo1, chrCamo2, chrCamo3, chrMkTint1, chrMkTint2, chrMkTint3, chrMkTint4
        },
        ['WEAPON_M16A1_CHR'] = {
            chrCamo1, chrCamo2, chrCamo3, chrMkTint1, chrMkTint2, chrMkTint3, chrMkTint4
        },
        ['WEAPON_M4_ARCW_CHR'] = {
            chrCamo1, chrCamo2, chrCamo3, chrMkTint1, chrMkTint2, chrMkTint3, chrMkTint4
        },
        ['WEAPON_MK_PRISS_CHR'] = {
            chrCamo1, chrCamo2, chrCamo3, chrMkTint1, chrMkTint2, chrMkTint3, chrMkTint4
        },
        ['WEAPON_MODULAR_RIFLE_CHR'] = {
            chrCamo1, chrCamo2, chrCamo3, chrMkTint1, chrMkTint2, chrMkTint3, chrMkTint4
        },
        ['WEAPON_NVRIFLE_CHR'] = {
            chrCamo1, chrCamo2, chrCamo3, chrMkTint1, chrMkTint2, chrMkTint3, chrMkTint4
        },
        ['WEAPON_R90_CHR'] = {
            chrCamo1, chrCamo2, chrCamo3, chrMkTint1, chrMkTint2, chrMkTint3, chrMkTint4
        },
        ['WEAPON_SB_SD_CHR'] = {
            chrCamo1, chrCamo2, chrCamo3, chrMkTint1, chrMkTint2, chrMkTint3, chrMkTint4
        },
        ['WEAPON_SR_3M_CHR'] = {
            chrCamo1, chrCamo2, chrCamo3, chrMkTint1, chrMkTint2, chrMkTint3, chrMkTint4
        },
        ['WEAPON_VERESK_CHR'] = {
            chrCamo1, chrCamo2, chrCamo3, chrMkTint1, chrMkTint2, chrMkTint3, chrMkTint4
        },
        ----- Chromium Weapons (TINT_DEFAULT)
        ['WEAPON_BERYL_762_CHR'] = {
            chrCamo1, chrCamo2, chrCamo3, chrDTint1, chrDTint2, chrDTint3, chrDTint4, chrDTint5, chrDTint6, chrDTint7
        },
        ['WEAPON_BULLPUP_SMG_CHR'] = {
            chrCamo1, chrCamo2, chrCamo3, chrDTint1, chrDTint2, chrDTint3, chrDTint4, chrDTint5, chrDTint6, chrDTint7
        },
        ['WEAPON_COMBATHP_CHR'] = {
            chrCamo1, chrCamo2, chrCamo3, chrDTint1, chrDTint2, chrDTint3, chrDTint4, chrDTint5, chrDTint6, chrDTint7
        },
        ['WEAPON_DESERT_EAGLE_CHR'] = {
            chrCamo1, chrCamo2, chrCamo3, chrDTint1, chrDTint2, chrDTint3, chrDTint4, chrDTint5, chrDTint6, chrDTint7
        },
        ['WEAPON_DKS_101_CHR'] = {
            chrCamo1, chrCamo2, chrCamo3, chrDTint1, chrDTint2, chrDTint3, chrDTint4, chrDTint5, chrDTint6, chrDTint7
        },
        ['WEAPON_DMRSNIPER_CHR'] = {
            chrCamo1, chrCamo2, chrCamo3, chrDTint1, chrDTint2, chrDTint3, chrDTint4, chrDTint5, chrDTint6, chrDTint7
        },
        ['WEAPON_FAMAS_CHR'] = {
            chrCamo1, chrCamo2, chrCamo3, chrDTint1, chrDTint2, chrDTint3, chrDTint4, chrDTint5, chrDTint6, chrDTint7
        },
        ['WEAPON_H05117_P_CHR'] = {
            chrCamo1, chrCamo2, chrCamo3, chrDTint1, chrDTint2, chrDTint3, chrDTint4, chrDTint5, chrDTint6, chrDTint7
        },
        ['WEAPON_HK2002M_CHR'] = {
            chrCamo1, chrCamo2, chrCamo3, chrDTint1, chrDTint2, chrDTint3, chrDTint4, chrDTint5, chrDTint6, chrDTint7
        },
        ['WEAPON_HKUSP_CHR'] = {
            chrCamo1, chrCamo2, chrCamo3, chrDTint1, chrDTint2, chrDTint3, chrDTint4, chrDTint5, chrDTint6, chrDTint7
        },
        ['WEAPON_HM_PISTOL_CHR'] = {
            chrCamo1, chrCamo2, chrCamo3, chrDTint1, chrDTint2, chrDTint3, chrDTint4, chrDTint5, chrDTint6, chrDTint7
        },
        ['WEAPON_L85_CHR'] = {
            chrCamo1, chrCamo2, chrCamo3, chrDTint1, chrDTint2, chrDTint3, chrDTint4, chrDTint5, chrDTint6, chrDTint7
        },
        ['WEAPON_LSR_PISTOL_CHR'] = {
            chrCamo1, chrCamo2, chrCamo3, chrDTint1, chrDTint2, chrDTint3, chrDTint4, chrDTint5, chrDTint6, chrDTint7
        },
        ['WEAPON_M270D_CHR'] = {
            chrCamo1, chrCamo2, chrCamo3, chrDTint1, chrDTint2, chrDTint3, chrDTint4, chrDTint5, chrDTint6, chrDTint7
        },
        ['WEAPON_M27_CHR'] = {
            chrCamo1, chrCamo2, chrCamo3, chrDTint1, chrDTint2, chrDTint3, chrDTint4, chrDTint5, chrDTint6, chrDTint7
        },
        ['WEAPON_MLTM4R_CHR'] = {
            chrCamo1, chrCamo2, chrCamo3, chrDTint1, chrDTint2, chrDTint3, chrDTint4, chrDTint5, chrDTint6, chrDTint7
        },
        ['WEAPON_MP5_CHR'] = {
            chrCamo1, chrCamo2, chrCamo3, chrDTint1, chrDTint2, chrDTint3, chrDTint4, chrDTint5, chrDTint6, chrDTint7
        },
        ['WEAPON_MPH_21_SG_CHR'] = {
            chrCamo1, chrCamo2, chrCamo3, chrDTint1, chrDTint2, chrDTint3, chrDTint4, chrDTint5, chrDTint6, chrDTint7
        },
        ['WEAPON_SPS_21_SG_CHR'] = {
            chrCamo1, chrCamo2, chrCamo3, chrDTint1, chrDTint2, chrDTint3, chrDTint4, chrDTint5, chrDTint6, chrDTint7
        },
        ['WEAPON_SPX_7_CHR'] = {
            chrCamo1, chrCamo2, chrCamo3, chrDTint1, chrDTint2, chrDTint3, chrDTint4, chrDTint5, chrDTint6, chrDTint7
        },
        ['WEAPON_SYS_PISTOL_CHR'] = {
            chrCamo1, chrCamo2, chrCamo3, chrDTint1, chrDTint2, chrDTint3, chrDTint4, chrDTint5, chrDTint6, chrDTint7
        },
        ['WEAPON_TACTICAL_VECTOR_CHR'] = {
            chrCamo1, chrCamo2, chrCamo3, chrDTint1, chrDTint2, chrDTint3, chrDTint4, chrDTint5, chrDTint6, chrDTint7
        },
        ['WEAPON_UMP_CHR'] = {
            chrCamo1, chrCamo2, chrCamo3, chrDTint1, chrDTint2, chrDTint3, chrDTint4, chrDTint5, chrDTint6, chrDTint7
        },
        ['WEAPON_VECOTR_CHR'] = {
            chrCamo1, chrCamo2, chrCamo3, chrDTint1, chrDTint2, chrDTint3, chrDTint4, chrDTint5, chrDTint6, chrDTint7
        },
        ['WEAPON_VX_47_CHR'] = {
            chrCamo1, chrCamo2, chrCamo3, chrDTint1, chrDTint2, chrDTint3, chrDTint4, chrDTint5, chrDTint6, chrDTint7
        },
        ['WEAPON_VX_SCORPION_CHR'] = {
            chrCamo1, chrCamo2, chrCamo3, chrDTint1, chrDTint2, chrDTint3, chrDTint4, chrDTint5, chrDTint6, chrDTint7
        },
        ['WEAPON_XM7_CHR'] = {
            chrCamo1, chrCamo2, chrCamo3, chrDTint1, chrDTint2, chrDTint3, chrDTint4, chrDTint5, chrDTint6, chrDTint7
        },
        ['WEAPON_ZETA_19_CHR'] = {
            chrCamo1, chrCamo2, chrCamo3, chrDTint1, chrDTint2, chrDTint3, chrDTint4, chrDTint5, chrDTint6, chrDTint7
        },
        ['WEAPON_MINIGUN'] = {
            {    -- dTint1
                key = 'deftin1', type = 1, num = 1, label = 'Green Skin',
                access = { all = true }, items = { ['comp_mat'] = 10 }
            }, { -- dTint2
                key = 'deftin2', type = 1, num = 2, label = 'Gold Skin',
                access = { all = true }, items = { ['comp_mat'] = 10 }
            }, { -- dTint3
                key = 'deftin3', type = 1, num = 3, label = 'Pink Skin',
                access = { all = true }, items = { ['comp_mat'] = 10 }
            }, { -- dTint4
                key = 'deftin4', type = 1, num = 4, label = 'Army Skin',
                access = { all = true }, items = { ['comp_mat'] = 10 }
            }, { -- dTint5
                key = 'deftin5', type = 1, num = 5, label = 'Blue Skin',
                access = { all = true }, items = { ['comp_mat'] = 10 }
            }, { -- dTint6
                key = 'deftin6', type = 1, num = 6, label = 'Orange Skin',
                access = { all = true }, items = { ['comp_mat'] = 10 }
            }, { -- dTint7
                key = 'deftin7', type = 1, num = 7, label = 'Platinum Skin',
                access = { all = true }, items = { ['comp_mat'] = 10 }
            }
        },
    }
}

-- ['WEAPON_PISTOL'] = {
--     {
--         key = 'pistol1000',
--         type = 1, -- type khate 9
--         label = 'Tint Green', matne delkhah 
--         name = 'suppressor', -- name az config gun -- 'WEAPON_AKBC' age gune jadid bashe esme gun
--         num = 2, -- az 0 shoroo mishe -- faghat baraye tint
--         access = {
--             skill = true,
--             gang = {
--                 ['hamid'] = true,
--             }
--         }
--     },
-- }, 
