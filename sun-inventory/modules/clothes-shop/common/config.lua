--[[ sun-inventory — clothes shop config. Prices/locations/locks ported
     from [BASE]/esx_inventory/config/config.lua (same values, same
     locations — Binco/Suburban/Ponsonbys), retyped onto WardrobeTypes'
     key set (see modules/wardrobe/common/config.lua) instead of the old
     inventory's own category names, so shop purchases and wardrobe
     equip/unequip agree on what a "type" is. ]]

ClothShop = {}

ClothShop.AccountName = 'bank' -- which xPlayer.getAccount(...) purchases are deducted from
ClothShop.MarkerDistance = 15
ClothShop.MarkerType = 25

-- price per WardrobeTypes key (old Config.ClothPrice, remapped: 'top' split
-- across tshirt/torso/bproof/arms since those are now separate ownable
-- items instead of one bundled purchase — see integration notes)
ClothShop.Prices = {
    tshirt  = 150,
    torso   = 150,
    bproof  = 150,
    arms    = 150,
    pants   = 100,
    shoes   = 80,
    bag     = 50,
    glasses = 20,
    ears    = 10,
    helmet  = 30,
    chain   = 50,
    mask    = 30,
    decals  = 20,
}

ClothShop.Locations = {
    ['Binco'] = {
        coords = {
            vector3(-822.42, -1073.55, 10.33),
            vector3(75.34, -1393.00, 28.38),
            vector3(425.59, -806.15, 28.49),
            vector3(4.87, 6512.46, 30.88),
            vector3(1693.92, 4822.82, 41.06),
            vector3(1196.61, 2710.25, 37.22),
            vector3(-1101.48, 2710.57, 18.11),
        },
        blip = { color = 81, size = 0.7, style = 73 },
    },
    ['Suburban'] = {
        coords = {
            vector3(-1193.16, -767.98, 16.32),
            vector3(125.77, -223.9, 53.56),
            vector3(614.19, 2762.79, 41.09),
            vector3(-3170.54, 1043.68, 19.86),
        },
        blip = { color = 81, size = 0.7, style = 73 },
    },
    ['Ponsonbys'] = {
        coords = {
            vector3(-709.86, -153.1, 36.42),
            vector3(-163.37, -302.73, 38.73),
            vector3(-1450.42, -237.66, 48.81),
        },
        blip = { color = 81, size = 0.7, style = 73 },
    },
}

-- [WardrobeTypes key][drawable_texture] = true -> not purchasable, only
-- obtainable via exports.sun-inventory:grantLimitedCloth(...)
ClothShop.Limited = {
    -- ['bag'] = { ['12_3'] = true },
}

-- [WardrobeTypes key][drawable_texture] = {'job1','job2'} -> only buyable
-- (and, client-side, only wearable) by those jobs
ClothShop.FactionLock = {
    -- ['torso'] = { ['20_0'] = {'police', 'ambulance'} },
}
