ShopConfig = {}

-- General Store -- categorized + FontAwesome icons like every other
-- shop below, instead of the old flat list with broken image paths.
ShopConfig.ShopsCategories = {
    {id = 'food',        label = '🍔 Food & Drinks', icon = 'fa-solid fa-utensils',      iconColor = '#22c55e'},
    {id = 'electronics', label = '📱 Electronics',   icon = 'fa-solid fa-mobile-screen', iconColor = '#38bdf8'},
    {id = 'smoking',     label = '🚬 Smoking',       icon = 'fa-solid fa-smoking',       iconColor = '#a8a29e'},
}

ShopConfig.itemsForSaleShops = {
    phone    = {price = 5000, category = 'electronics'},
    bread    = {price = 2000, category = 'food'},
    water    = {price = 2000, category = 'food'},
    cigarett = {price = 20,   category = 'smoking'},
    lighter  = {price = 2000, category = 'smoking'},
}

ShopConfig.sellingLocationShops = {
    {x = 24.50556, y = -1347.96, z = 29.497, h = 271.95, pedname = "mp_m_shopkeep_01", pedtype = 4},
    {x = -47.3809, y = -1758.62, z = 29.421, h = 49.5, pedname = "mp_m_shopkeep_01", pedtype = 4},
    {x = -1221.44, y = -907.928, z = 12.326, h = 30.24, pedname = "mp_m_shopkeep_01", pedtype = 4},
    {x = -1486.75, y = -377.568, z = 40.163, h = 139.27, pedname = "mp_m_shopkeep_01", pedtype = 4},
    {x = -706.092, y = -914.551, z = 19.215, h = 93.42, pedname = "mp_m_shopkeep_01", pedtype = 4},
    {x = 1134.307, y = -983.127, z = 46.415, h = 276.22, pedname = "mp_m_shopkeep_01", pedtype = 4},
    {x = 372.4199, y = 325.7742, z = 103.56, h = 259.57, pedname = "mp_m_shopkeep_01", pedtype = 4},
    {x = 1164.845, y = -323.692, z = 69.205, h = 97.65, pedname = "mp_m_shopkeep_01", pedtype = 4},
    {x = 2557.895, y = 380.8162, z = 108.62, h = 356.73, pedname = "mp_m_shopkeep_01", pedtype = 4},
    {x = -3038.28, y = 584.7843, z = 7.9089, h = 21.98, pedname = "mp_m_shopkeep_01", pedtype = 4},
    {x = -3241.60, y = 999.9526, z = 12.830, h = 351.25, pedname = "mp_m_shopkeep_01", pedtype = 4},
    {x = -2966.40, y = 391.5312, z = 15.043, h = 81.57, pedname = "mp_m_shopkeep_01", pedtype = 4},
    {x = -1819.53, y = 793.5176, z = 138.08, h = 127.25, pedname = "mp_m_shopkeep_01", pedtype = 4},
    {x = 548.9373, y = 2672.049, z = 42.156, h = 91.76, pedname = "mp_m_shopkeep_01", pedtype = 4},
    {x = 1165.320, y = 2710.780, z = 38.157, h = 173.39, pedname = "mp_m_shopkeep_01", pedtype = 4},
    {x = 2678.758, y = 3279.046, z = 55.241, h = 325.35, pedname = "mp_m_shopkeep_01", pedtype = 4},
    {x = 1960.501, y = 3739.355, z = 32.343, h = 296.97, pedname = "mp_m_shopkeep_01", pedtype = 4},
    {x = 1697.311, y = 4923.486, z = 42.063, h = 330.69, pedname = "mp_m_shopkeep_01", pedtype = 4},
    {x = 1727.544, y = 6414.502, z = 35.037, h = 241.32, pedname = "mp_m_shopkeep_01", pedtype = 4},
}

-- Attachment Shop (Narekshop) -- categorized the same way as the Gun
-- Shop below: weapon attachments vs. tools/equipment, rendered with
-- FontAwesome icons instead of the broken lc-inventory image paths.
ShopConfig.NarekshopCategories = {
    {id = 'attachments', label = '🔭 Weapon Attachments', icon = 'fa-solid fa-crosshairs', iconColor = '#38bdf8'},
    {id = 'tools',       label = '🧰 Tools & Equipment',  icon = 'fa-solid fa-toolbox',    iconColor = '#eab308'},
}

ShopConfig.itemsForSaleNarekshop = {
    -- Weapon Attachments
    silencer   = {price = 15000, category = 'attachments'},
    clip       = {price = 2000,  category = 'attachments'},
    grip       = {price = 5000,  category = 'attachments'},
    flashlight = {price = 15000, category = 'attachments'},

    -- Tools & Equipment
    radio      = {price = 10000, category = 'tools'},
    laptophack = {price = 30000, category = 'tools'},
    blowtorch  = {price = 20000, category = 'tools'},
    thermite   = {price = 20000, category = 'tools'},
    fishingrod = {price = 10000, category = 'tools'},
}

ShopConfig.sellingLocationNarekshop = {
        {x = -662.032, y = -933.282, z = 21.829, h = 179.46, pedname = "s_m_y_blackops_01", pedtype = 4, displayBlip = true},
        {x = 810.0014, y = -2159.29, z = 29.618, h = 1.01, pedname = "s_m_y_blackops_01", pedtype = 4, displayBlip = true},
        {x = 1692.010, y = 3761.218, z = 34.705, h = 227.3, pedname = "s_m_y_blackops_01", pedtype = 4, displayBlip = true},
        {x = -331.817, y = 6085.330, z = 31.454, h = 224.41, pedname = "s_m_y_blackops_01", pedtype = 4, displayBlip = true},
        {x = 22.64237, y = -1105.52, z = 29.797, h = 155.67, pedname = "s_m_y_blackops_01", pedtype = 4, displayBlip = true},
        {x = 254.2361, y = -50.8322, z = 69.941, h = 68.55, pedname = "s_m_y_blackops_01", pedtype = 4, displayBlip = true},
        {x = 2567.780, y = 292.3516, z = 108.73, h = 359.1, pedname = "s_m_y_blackops_01", pedtype = 4, displayBlip = true},
        {x = -1119.17, y = 2700.183, z = 18.554, h = 221.09, pedname = "s_m_y_blackops_01", pedtype = 4, displayBlip = true},
        {x = 842.2095, y = -1035.74, z = 28.194, h = 359.0, pedname = "s_m_y_blackops_01", pedtype = 4, displayBlip = true},
        {x = -1303.87, y = -394.859, z = 36.695, h = 75.33, pedname = "s_m_y_blackops_01", pedtype = 4, displayBlip = true},
        {x = -3173.88, y = 1088.727, z = 20.838, h = 246.18, pedname = "s_m_y_blackops_01", pedtype = 4, displayBlip = true},
}

-- ============================================================
-- GUN SHOP -- same 3 weapons as before, just organized + FontAwesome
-- icons instead of the broken lc-inventory image paths.
-- ============================================================
-- The old list pointed every entry at an `image` inside lc-inventory's
-- asset folder (nui://lc-inventory/...) that doesn't actually contain
-- weapon icons -- that's the "Missing img" placeholder seen in the buy
-- menu in-game. The client now renders these with FontAwesome
-- `icon`/`iconColor` instead (always renders, no missing-asset risk).

ShopConfig.GunshopCategories = {
    {id = 'pistols', label = '🔫 Pistols',    icon = 'fa-solid fa-gun',       iconColor = '#fbbf24'},
    {id = 'melee',   label = '🔪 Melee',      icon = 'fa-solid fa-hand-fist', iconColor = '#a8a29e'},
    {id = 'ammo',    label = '📦 Ammunition', icon = 'fa-solid fa-box',       iconColor = '#22c55e'},
}

ShopConfig.itemsForSaleGunshop = {
    weapon_pistol       = {price = 90000,  category = 'pistols'},
    weapon_combatpistol = {price = 120000, category = 'pistols'},
    weapon_knife        = {price = 60000,  category = 'melee'},
}

-- Flavour metadata shown under each weapon in the menu (damage / fire
-- rate / magazine / ammo type it takes). Purely cosmetic -- doesn't
-- affect real weapon stats -- but tells the player what they're buying
-- before they spend the money.
ShopConfig.GunshopMeta = {
    weapon_pistol       = {damage = 'Low', fireRate = 'Medium', magazine = 12, ammo = 'Pistol Ammo'},
    weapon_combatpistol = {damage = 'Low', fireRate = 'Fast',   magazine = 12, ammo = 'Pistol Ammo'},
    weapon_knife        = {damage = 'Medium', class = 'Melee'},
}

-- Ammo (added so the ammo_* items essentialmode's weapon-in-inventory
-- reload system needs -- see essentialmode/server/functions.lua and
-- database.sql -- are actually purchasable somewhere). Sold from the
-- same Gunshop peds/locations as the weapons above, just a separate
-- config list since these are regular items (xPlayer.addInventoryItem),
-- not weapons (xPlayer.addWeapon) -- see server/shop-sv.lua's
-- gunshop_item:buy_ammo handler.
ShopConfig.itemsForSaleAmmoGunshop = {
    ammo_pistol  = {price = 30,  amount = 30, category = 'ammo'},
    ammo_smg     = {price = 25,  amount = 30, category = 'ammo'},
    ammo_shotgun = {price = 40,  amount = 12, category = 'ammo'},
    ammo_rifle   = {price = 20,  amount = 30, category = 'ammo'},
    ammo_sniper  = {price = 60,  amount = 10, category = 'ammo'},
    ammo_mg      = {price = 15,  amount = 50, category = 'ammo'},
    ammo_heavy   = {price = 200, amount = 5,  category = 'ammo'},
}

-- Deliberately empty: every Ammu-Nation-style location below is already
-- covered by ShopConfig.sellingLocationNarekshop's ped, which offers
-- both "Attachment Shop" and "Gun Shop" as target options on the same
-- ped. Adding entries here too would spawn a second, overlapping ped
-- at the same coords. Only add locations here if you want *additional*
-- standalone gun shops somewhere Narekshop doesn't already cover, e.g.:
-- {x = 1000.0, y = 1000.0, z = 50.0, h = 0.0, pedname = "s_m_y_ammucity_01", pedtype = 4, displayBlip = true},
ShopConfig.sellingLocationGunshop = {

}

-- Mechanic Shop -- categorized + FontAwesome icons like every other
-- shop above, instead of the old flat list with broken image paths.
ShopConfig.MCCategories = {
    {id = 'tools', label = '🔧 Tools', icon = 'fa-solid fa-screwdriver-wrench', iconColor = '#f97316'},
    {id = 'parts', label = '🚗 Parts', icon = 'fa-solid fa-car-side',          iconColor = '#ef4444'},
}

ShopConfig.itemsForSaleMC = {
    hotwire = {price = 2000, category = 'tools'},
    carjack = {price = 5000, category = 'tools'},
    cleaner = {price = 5000, category = 'tools'},
    tires   = {price = 7000, category = 'parts'},
    engin   = {price = 5000, category = 'parts'},
}

ShopConfig.sellingLocationMC = {
    {x = -352.561, y = -129.197, z = 39.021, h = 251.2, pedname = "s_m_m_gaffer_01", pedtype = 2, displayBlip = false}
  }