-- ================================================================= --
-- GUN SHOPS + ZONE WORKSHOP (crafting from materials)
-- Loaded as a shared script. Everything here is editable.
-- ================================================================= --
GunShopCfg = {}

-- Materials: the raw items a zone workshop uses. Anything here that does not exist as an
-- item on the server is still a valid MATERIAL (kept in the zone's workshop, not in
-- inventories). Typos from the original recipe list are already corrected.
GunShopCfg.Materials = {
    iron = true, gold = true, gold_piece = true, iron_piece = true, petrol = true,
    petrol_raffin = true, essence = true, fabric = true, cutted_wood = true, diamond = true,
    mushroom = true, marijuana = true,
}

-- Weapon recipes (materials + seconds to craft). Typo fixes: gold_pieece/gold_Piece -> gold_piece,
-- esssence/essnece/esssence -> essence.
GunShopCfg.Recipes = {
    WEAPON_KNIFE            = { level = 1, time = 15, ingr = { diamond = 1, gold_piece = 1, iron_piece = 5, essence = 5, petrol_raffin = 10, fabric = 4 } },
    WEAPON_DAGGER           = { level = 1, time = 15, ingr = { fabric = 4, diamond = 1, cutted_wood = 5, gold_piece = 1, petrol_raffin = 5, petrol = 5 } },
    WEAPON_MACHETE          = { level = 1, time = 15, ingr = { essence = 5, diamond = 2, cutted_wood = 5, gold_piece = 5, iron_piece = 5, petrol_raffin = 5, petrol = 5 } },
    WEAPON_KNUCKLE          = { level = 8, time = 15, ingr = { iron = 1, fabric = 10, diamond = 2, essence = 5, iron_piece = 10, gold_piece = 10, petrol_raffin = 10, petrol = 10 } },

    WEAPON_PISTOL           = { level = 1, time = 15, ingr = { petrol = 10, iron_piece = 5, essence = 10, petrol_raffin = 10 } },
    WEAPON_SNSPISTOL        = { level = 1, time = 15, ingr = { essence = 15, cutted_wood = 10, gold_piece = 5, iron_piece = 5, petrol_raffin = 15 } },
    WEAPON_VINTAGEPISTOL    = { level = 1, time = 15, ingr = { fabric = 5, essence = 30, cutted_wood = 20, gold_piece = 5, iron_piece = 10, petrol = 10 } },
    WEAPON_COMBATPISTOL     = { level = 2, time = 15, ingr = { fabric = 5, essence = 15, cutted_wood = 10, gold_piece = 5, iron_piece = 10, petrol_raffin = 15, petrol = 10 } },
    WEAPON_HEAVYPISTOL      = { level = 2, time = 20, ingr = { fabric = 5, essence = 10, gold_piece = 5, iron_piece = 10, petrol_raffin = 15, petrol = 10 } },
    WEAPON_PISTOL50         = { level = 3, time = 15, ingr = { iron = 1, essence = 30, cutted_wood = 20, gold_piece = 5, petrol_raffin = 25, petrol = 10 } },
    WEAPON_SNSPISTOL_MK2    = { level = 3, time = 20, ingr = { iron = 1, fabric = 10, diamond = 5, essence = 20, gold_piece = 5, iron_piece = 5, petrol_raffin = 20, petrol = 15 } },
    WEAPON_PISTOL_MK2       = { level = 8, time = 20, ingr = { iron = 1, fabric = 10, diamond = 5, essence = 30, gold_piece = 10, iron_piece = 10, petrol_raffin = 20, petrol = 15 } },
    WEAPON_CERAMICPISTOL    = { level = 9, time = 20, ingr = { iron = 2, fabric = 10, diamond = 3, cutted_wood = 15, gold_piece = 5, iron_piece = 5, essence = 30, petrol_raffin = 20 } },
    WEAPON_DOUBLEACTION     = { level = 11, time = 20, ingr = { iron = 15, fabric = 20, diamond = 20, gold = 2, essence = 50, cutted_wood = 50, petrol = 25, iron_piece = 40, petrol_raffin = 25 } },

    WEAPON_SMG              = { level = 3, time = 25, ingr = { iron = 1, fabric = 5, essence = 30, cutted_wood = 20, petrol = 10 } },
    WEAPON_ASSAULTSMG       = { level = 4, time = 25, ingr = { iron = 2, essence = 30, cutted_wood = 20, gold_piece = 5, petrol_raffin = 25, petrol = 15 } },
    WEAPON_GUSENBERG        = { level = 8, time = 25, ingr = { iron = 4, fabric = 10, essence = 50, gold_piece = 10, petrol_raffin = 25, petrol = 15 } },
    WEAPON_SMG_MK2          = { level = 11, time = 25, ingr = { iron = 7, fabric = 20, essence = 50, cutted_wood = 50, petrol = 25, petrol_raffin = 25, gold = 2 } },

    WEAPON_CARBINERIFLE     = { level = 4, time = 30, ingr = { iron = 3, fabric = 10, essence = 40, gold_piece = 10, petrol_raffin = 25, petrol = 15 } },
    WEAPON_ASSAULTRIFLE     = { level = 5, time = 30, ingr = { iron = 3, fabric = 10, cutted_wood = 30, gold_piece = 10, petrol_raffin = 25, petrol = 20 } },
    WEAPON_ADVANCEDRIFLE    = { level = 5, time = 30, ingr = { iron = 3, fabric = 10, essence = 40, cutted_wood = 30, gold_piece = 10, petrol_raffin = 25 } },
    WEAPON_COMBATPDW        = { level = 6, time = 30, ingr = { iron = 3, fabric = 10, essence = 30, cutted_wood = 30, gold_piece = 10, petrol = 15 } },
    WEAPON_BULLPUPRIFLE     = { level = 6, time = 30, ingr = { iron = 4, essence = 50, cutted_wood = 30, petrol = 20, petrol_raffin = 25, gold = 1 } },
    WEAPON_SPECIALCARBINE   = { level = 9, time = 30, ingr = { iron = 4, fabric = 10, essence = 50, petrol = 25, petrol_raffin = 25, gold = 1 } },
    WEAPON_BULLPUPRIFLE_MK2 = { level = 10, time = 30, ingr = { iron = 7, fabric = 15, essence = 50, petrol = 25, petrol_raffin = 25, gold = 2 } },
    WEAPON_COMPACTRIFLE     = { level = 11, time = 30, ingr = { iron = 7, fabric = 20, essence = 50, cutted_wood = 50, petrol = 25, petrol_raffin = 25, gold = 1 } },
    WEAPON_SPECIALCARBINE_MK2 = { level = 12, time = 30, ingr = { iron = 8, fabric = 20, diamond = 10, gold = 2, essence = 50, cutted_wood = 50, petrol = 25, iron_piece = 10, petrol_raffin = 25 } },
}

-- Gun shops (coords from the auction-house config). Each one is leased to a gang.
GunShopCfg.Shops = {
    { id = 1,  label = 'Gun Shop 15', coords = vector3(244.4979, -49.28821, 69.9411), craft = vector3(247.7, -51.1, 69.94) },
    { id = 2,  label = 'Gun Shop 12', coords = vector3(812.3232, -2157.465, 29.61901), craft = vector3(808.74, -2153.67, 29.62) },
    { id = 3,  label = 'Gun Shop 20', coords = vector3(-1304.985, -392.2997, 36.69576), craft = vector3(-1310.01, -395.96, 36.7) },
    { id = 4,  label = 'Gun Shop 17', coords = vector3(2569.96, 293.9241, 108.7349), craft = vector3(2565.17, 298.27, 108.73) },
    { id = 5,  label = 'Gun Shop 19', coords = vector3(844.4964, -1033.521, 28.19487), craft = vector3(839.7, -1029.91, 28.19) },
    { id = 6,  label = 'Gun Shop 13', coords = vector3(1692.012, 3758.525, 34.70531), craft = vector3(1697.96, 3759.36, 34.71) },
    { id = 7,  label = 'Gun Shop 14', coords = vector3(-331.8116, 6082.549, 31.45479), craft = vector3(-325.85, 6083.09, 31.45) },
    { id = 8,  label = 'Gun Shop 11', coords = vector3(-664.2788, -935.0397, 21.82923) },
    { id = 9,  label = 'Gun Shop 16', coords = vector3(19.99039, -1106.301, 29.79703), craft = vector3(22.39, -1110.88, 29.8) },
}

GunShopCfg.LeaseDays   = 30          -- a lease lasts this many days
GunShopCfg.BasePrice   = 5000000     -- price of a FREE shop, per lease (buy now)
GunShopCfg.MinBid      = 5000000     -- the lowest bid that is accepted on an owned shop
GunShopCfg.BidStep     = 1000000     -- each new bid must be at least this much above the highest bid
GunShopCfg.Blip        = { sprite = 110, colorFree = 4, colorOwned = 1, scale = 0.8 }

-- Shop catalog: weapons an owner gang can buy from its shop (paid from gang money).
GunShopCfg.Catalog = {
    { weapon = 'WEAPON_PISTOL', price = 150000 },
    { weapon = 'WEAPON_COMBATPISTOL', price = 300000 },
    { weapon = 'WEAPON_SMG', price = 600000 },
    { weapon = 'WEAPON_CARBINERIFLE', price = 1200000 },
}

-- Zone workshop
GunShopCfg.Workshop = {
    MaxQueue = 3,     -- crafts a zone can run at once
    -- the zone's workshop is keyed by zone: access follows the zone owner
}
