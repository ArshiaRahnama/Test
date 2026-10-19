UCConfig = UCConfig or {}
-- FIX: ox_inventory isn't installed on this server (only Unique_inventory
-- is). Pointed at Unique_inventory's real, existing html/img/items/ icon
-- folder - see shared/market_products.lua for which product PNGs still need
-- to be added there by hand.
UCConfig.itemIconsPath = "nui://Unique_inventory/html/img/items/"

-- Shared product catalog / shop stock - identical menu at every cafe.

UCConfig.UwUMenu_Cake_Item = {
    { title = 'Cake Bastani', value = 'cakebastani', price = 10000, image = UCConfig.itemIconsPath..'cakebastani.png' },
    { title = 'Cake Totfarangi', value = 'caketotfarangi', price = 8000, image = UCConfig.itemIconsPath..'caketotfarangi.png' },
    { title = 'Cupcake', value = 'cupcake', price = 3000, image = UCConfig.itemIconsPath..'cupcake.png' },
    { title = 'Shokolat', value = 'shokolat', price = 5000, image = UCConfig.itemIconsPath..'shokolat.png' },
    { title = 'Cake Bastani Vanili', value = 'cake_bastani_vanili', price = 6100, image = UCConfig.itemIconsPath..'cake_bastani_vanili.png' },
    { title = 'Cake Limoii', value = 'cake_limoii', price = 4800, image = UCConfig.itemIconsPath..'cake_limoii.png' },
    { title = 'Cupcake Shokolati', value = 'cupcake_shokolati', price = 5900, image = UCConfig.itemIconsPath..'cupcake_shokolati.png' },
    { title = 'Mufchocolate', value = 'mufchocolate', price = 8000, image = UCConfig.itemIconsPath..'mufchocolate.png' },
    { title = 'Muffin Tamshak', value = 'muffin_tamshak', price = 4175, image = UCConfig.itemIconsPath..'muffin_tamshak.png' },
    { title = 'Nodel', value = 'nodel', price = 5600, image = UCConfig.itemIconsPath..'nodel.png' },
    { title = 'Pankik', value = 'pankik', price = 3900, image = UCConfig.itemIconsPath..'pankik.png' },
    { title = 'Pankik Nutella', value = 'pankik_nutella', price = 5900, image = UCConfig.itemIconsPath..'pankik_nutella.png' },
    { title = 'Pankik Oreo', value = 'pankik_oreo', price = 6000, image = UCConfig.itemIconsPath..'pankik_oreo.png' },
    { title = 'Tiramisuye Toot Farangi', value = 'tiramisuye_toot_farangi', price = 5150, image = UCConfig.itemIconsPath..'tiramisuye_toot_farangi.png' },
    { title = 'Vafel Nutella', value = 'vafel_nutella', price = 7000, image = UCConfig.itemIconsPath..'vafel_nutella.png' },
}

UCConfig.UwUMenu_Noshidani_Item = {
    { title = 'Bubblete Totfarangi', value = 'bubbletetotfarangi', price = 9000, image = UCConfig.itemIconsPath..'bubbletetotfarangi.png' },
    { title = 'Ab Porteghal', value = 'abporteghal', price = 6100, image = UCConfig.itemIconsPath..'abporteghal.png' },
    { title = 'Chaee', value = 'chaee', price = 6000, image = UCConfig.itemIconsPath..'chaee.png' },
    { title = 'Ghahve 50', value = 'ghahve50', price = 3000, image = UCConfig.itemIconsPath..'ghahve50.png' },
    { title = 'Ghahve 80', value = 'ghahve80', price = 7000, image = UCConfig.itemIconsPath..'ghahve80.png' },
    { title = 'Ghahve 100', value = 'ghahve100', price = 8000, image = UCConfig.itemIconsPath..'ghahve100.png' },
    { title = 'Hot Chocolate', value = 'hot_chocolate', price = 3000, image = UCConfig.itemIconsPath..'hot_chocolate.png' },
    { title = 'Latte', value = 'latte', price = 3000, image = UCConfig.itemIconsPath..'latte.png' },
    { title = 'Milkshake', value = 'milkshake', price = 5000, image = UCConfig.itemIconsPath..'milkshake.png' },
    { title = 'Bastani', value = 'bastani', price = 6500, image = UCConfig.itemIconsPath..'bastani.png' },
    { title = 'Boba Milk Tea Caramel', value = 'boba_milk_tea_caramel', price = 3800, image = UCConfig.itemIconsPath..'boba_milk_tea_caramel.png' },
    { title = 'Boba Milk Tea Matcha', value = 'boba_milk_tea_matcha', price = 3500, image = UCConfig.itemIconsPath..'boba_milk_tea_matcha.png' },
    { title = 'Bobal Tea Matcha', value = 'bobal_tea_matcha', price = 4500, image = UCConfig.itemIconsPath..'bobal_tea_matcha.png' },
    { title = 'Bobal Tea Tamshak', value = 'bobal_tea_tamshak', price = 4250, image = UCConfig.itemIconsPath..'bobal_tea_tamshak.png' },
    { title = 'Ice Coffee Matcha', value = 'ice_coffee_matcha', price = 4500, image = UCConfig.itemIconsPath..'ice_coffee_matcha.png' },
    { title = 'Milk Shake Shokolati', value = 'milk_shake_shokolati', price = 3900, image = UCConfig.itemIconsPath..'milk_shake_shokolati.png' },
}

UCConfig.UwUItems = {
    -- items masrafi --
    'bubbletetotfarangi', 'cakebastani', 'cakebastanivanili', 'caketotfarangi', 
	'chaee', 'cupcake', 'ghahve50', 'ghahve80', 'ghahve100', 'hot_chocolate','latte', 'milkshake', 
    'shokolat','suop',
    -- New items masrafi --
    'bastani', 'boba_milk_tea_caramel', 'boba_milk_tea_matcha', 'bobal_tea_matcha', 'bobal_tea_tamshak',
	'cake_bastani_vanili', 'cake_limoii', 'cupcake_shokolati', 'ice_coffee_matcha', 'milk_shake_shokolati',
	'mufchocolate', 'muffin_tamshak', 'nodel', 'pankik', 'pankik_nutella', 'pankik_oreo',
    'tiramisuye_toot_farangi', 'vafel_nutella',
    
    -- item avalie --
	'aard', 'bakingpowder', 'daneghahve','egg', 'fenjon', 'fenjonkasif', 'kare', 'kase', 
    'kasekasif', 'limo', 'podrcacao','shekar', 'shir', 'totfarangi','yakh', 'water',
    'bread', "abporteghal", 'nutela',
    -- New item avalie --
	'vanil', 'tamshak', 'powdr_matcha', 'oreo', 'nodel_kham', 'khame',
}


UCConfig.UwUShopItem = {
    {label = 'Aard', icon = UCConfig.itemIconsPath .. 'aard.png', price = 100, args = 'aard'},
    {label = 'Ab Porteghal', icon = UCConfig.itemIconsPath .. 'abporteghal.png', price = 5000, args = 'abporteghal'},
    -- {label = 'Boba Milk Tea Matcha', icon = UCConfig.itemIconsPath .. 'boba_milk_tea_matcha.png', price = 4000, args = 'boba_milk_tea_matcha'},
    -- {label = 'Boba Milk Tea Caramel', icon = UCConfig.itemIconsPath .. 'boba_milk_tea_caramel.png', price = 4100, args = 'boba_milk_tea_caramel'},
    {label = 'Ice Coffee Matcha', icon = UCConfig.itemIconsPath .. 'ice_coffee_matcha.png', price = 4500, args = 'ice_coffee_matcha'},
    {label = 'Bastani', icon = UCConfig.itemIconsPath .. 'bastani.png', price = 5000, args = 'bastani'},
    {label = 'Nutela', icon = UCConfig.itemIconsPath .. 'nutela.png', price = 200, args = 'nutela'},
    {label = 'Chaee', icon = UCConfig.itemIconsPath .. 'chaee.png', price = 5000, args = 'chaee'},
    {label = 'Baking Powder', icon = UCConfig.itemIconsPath .. 'bakingpowder.png', price = 200, args = 'bakingpowder'},
    {label = 'Dane Ghahve', icon = UCConfig.itemIconsPath .. 'daneghahve.png', price = 200, args = 'daneghahve'},
    {label = 'Tokhm Morgh', icon = UCConfig.itemIconsPath .. 'egg.png', price = 100, args = 'egg'},
    {label = 'Fenjon', icon = UCConfig.itemIconsPath .. 'fenjon.png', price = 100, args = 'fenjon'},
    {label = 'Kare', icon = UCConfig.itemIconsPath .. 'kare.png', price = 200, args = 'kare'},
    {label = 'Kase', icon = UCConfig.itemIconsPath .. 'kase.png', price = 100, args = 'kase'},
    {label = 'Limo', icon = UCConfig.itemIconsPath .. 'limo.png', price = 100, args = 'limo'},
    {label = 'Podr Cacao', icon = UCConfig.itemIconsPath .. 'podrcacao.png', price = 200, args = 'podrcacao'},
    {label = 'Shekar', icon = UCConfig.itemIconsPath .. 'shekar.png', price = 100, args = 'shekar'},
    {label = 'Shir', icon = UCConfig.itemIconsPath .. 'shir.png', price = 200, args = 'shir'},
    {label = 'Tot Farangi', icon = UCConfig.itemIconsPath .. 'totfarangi.png', price = 200, args = 'totfarangi'},
    {label = 'Yakh', icon = UCConfig.itemIconsPath .. 'yakh.png', price = 100, args = 'yakh'},
    {label = 'Water', icon = UCConfig.itemIconsPath .. 'water.png', price = 100, args = 'water'},
    {label = 'Bread', icon = UCConfig.itemIconsPath .. 'bread.png', price = 100, args = 'bread'},
  
    {label = 'Vanil', icon = UCConfig.itemIconsPath .. 'vanil.png', price = 200, args = 'vanil'},
    {label = 'Tamshak', icon = UCConfig.itemIconsPath .. 'tamshak.png', price = 175, args = 'tamshak'},
    {label = 'Powdr Matcha', icon = UCConfig.itemIconsPath .. 'powdr_matcha.png', price = 200, args = 'powdr_matcha'},
    {label = 'Oreo', icon = UCConfig.itemIconsPath .. 'oreo.png', price = 100, args = 'oreo'},
    {label = 'Nodel Kham', icon = UCConfig.itemIconsPath .. 'nodel_kham.png', price = 300, args = 'nodel_kham'},
    {label = 'Khame', icon = UCConfig.itemIconsPath .. 'khame.png', price = 150, args = 'khame'},

    -- BUG FIX: the bakery/bar/pizza/icecream/sushi/carwash recipes in
    -- shared/configcrafting.lua all reference raw ingredients (khamir_pizza,
    -- berenj_sushi, soap_foam, etc.) that were registered as valid items in
    -- uniquecafejobs_COMPLETE.sql but were never actually FOR SALE anywhere -
    -- not here, not in Corp.Meridian.SupplyPrices. Every one of those
    -- 6 business types' crafting stations was unusable in practice (no way
    -- to ever obtain the ingredients). Added below, plus the new restaurant
    -- raw ingredients for Ember/Anchor/Crimson.
    {label = 'Khamir Shirini', icon = UCConfig.itemIconsPath .. 'khamir_shirini.png', price = 200, args = 'khamir_shirini'},
    {label = 'Mive Mix', icon = UCConfig.itemIconsPath .. 'mive_mix.png', price = 200, args = 'mive_mix'},
    {label = 'Khamir Pizza', icon = UCConfig.itemIconsPath .. 'khamir_pizza.png', price = 200, args = 'khamir_pizza'},
    {label = 'Sos Gojeh', icon = UCConfig.itemIconsPath .. 'sos_gojeh.png', price = 150, args = 'sos_gojeh'},
    {label = 'Panir Pizza', icon = UCConfig.itemIconsPath .. 'panir_pizza.png', price = 200, args = 'panir_pizza'},
    {label = 'Khame Yakhi', icon = UCConfig.itemIconsPath .. 'khame_yakhi.png', price = 200, args = 'khame_yakhi'},
    {label = 'Berenj Sushi', icon = UCConfig.itemIconsPath .. 'berenj_sushi.png', price = 200, args = 'berenj_sushi'},
    {label = 'Maahi Khaam', icon = UCConfig.itemIconsPath .. 'maahi_khaam.png', price = 300, args = 'maahi_khaam'},
    {label = 'Nori', icon = UCConfig.itemIconsPath .. 'nori.png', price = 150, args = 'nori'},
    {label = 'Soap Foam', icon = UCConfig.itemIconsPath .. 'soap_foam.png', price = 150, args = 'soap_foam'},
    {label = 'Microfiber Cloth', icon = UCConfig.itemIconsPath .. 'microfiber_cloth.png', price = 150, args = 'microfiber_cloth'},
    {label = 'Steak Raw', icon = UCConfig.itemIconsPath .. 'steak_raw.png', price = 400, args = 'steak_raw'},
    {label = 'Pasta Dry', icon = UCConfig.itemIconsPath .. 'pasta_dry.png', price = 150, args = 'pasta_dry'},
    {label = 'Seafood Mix', icon = UCConfig.itemIconsPath .. 'seafood_mix.png', price = 400, args = 'seafood_mix'},
    {label = 'Truffle', icon = UCConfig.itemIconsPath .. 'truffle.png', price = 600, args = 'truffle'},

}



-- ── Per-business menus ──────────────────────────────────────────────────────
-- Cafes sell drinks + cakes. Restaurants sell food + a few drinks.
-- The server only accepts items listed here (see server/shop_server.lua).
local function pick(list, values)
    local out = {}
    for _, v in ipairs(values) do
        for _, item in ipairs(list) do
            if item.value == v then out[#out + 1] = item end
        end
    end
    return out
end

local function concat(a, b)
    local out = {}
    for _, v in ipairs(a) do out[#out + 1] = v end
    for _, v in ipairs(b) do out[#out + 1] = v end
    return out
end

UCConfig.MenuByGroup = {
    cafe = {
        drinks   = UCConfig.UwUMenu_Noshidani_Item,
        desserts = UCConfig.UwUMenu_Cake_Item,
    },
    restaurant = {
        drinks   = pick(UCConfig.UwUMenu_Noshidani_Item, { 'abporteghal', 'chaee', 'milkshake', 'bastani' }),
        desserts = concat(pick(UCConfig.UwUMenu_Cake_Item, { 'nodel', 'vafel_nutella', 'pankik_oreo' }), {
            { title = 'Suop', value = 'suop', price = 4500, image = UCConfig.itemIconsPath .. 'suop.png' },
        }),
    },
}
