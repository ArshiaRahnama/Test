MarketConfig = {}
local url = 'nui://IRV-inventory/ui/images/'

list_products = {
    { label = 'Cake Bastani', name = 'cakebastani', img = url..'cakebastani.png', price_recommended = 10000, Had_AKSAR = 10000},
    { label = 'Cake Totfarangi', name = 'caketotfarangi', price = 8000, img = url..'caketotfarangi.png', price_recommended = 8000, Had_AKSAR = 8000},
    { label = 'Cupcake', name = 'cupcake', price = 3000, img = url..'cupcake.png', price_recommended = 3000, Had_AKSAR = 3000},
    { label = 'Shokolat', name = 'shokolat', price = 5000, img = url..'shokolat.png', price_recommended = 5000, Had_AKSAR = 5000},
    { label = 'Cake Bastani Vanili', name = 'cake_bastani_vanili', price = 6100, img = url..'cake_bastani_vanili.png', price_recommended = 6100, Had_AKSAR = 6100},
    { label = 'Cake Limoii', name = 'cake_limoii', price = 4800, img = url..'cake_limoii.png', price_recommended = 4800, Had_AKSAR = 4800},
    { label = 'Cupcake Shokolati', name = 'cupcake_shokolati', price = 5900, img = url..'cupcake_shokolati.png', price_recommended = 5900, Had_AKSAR = 5900},
    { label = 'Mufchocolate', name = 'mufchocolate', price = 8000, img = url..'mufchocolate.png', price_recommended = 8000, Had_AKSAR = 8000},
    { label = 'Muffin Tamshak', name = 'muffin_tamshak', price = 4175, img = url..'muffin_tamshak.png', price_recommended = 4175, Had_AKSAR = 4175},
    { label = 'Nodel', name = 'nodel', price = 5600, img = url..'nodel.png', price_recommended = 5600, Had_AKSAR = 5600},
    { label = 'Pankik', name = 'pankik', price = 3900, img = url..'pankik.png', price_recommended = 3900, Had_AKSAR = 3900},
    { label = 'Pankik Nutella', name = 'pankik_nutella', price = 5900, img = url..'pankik_nutella.png', price_recommended = 5900, Had_AKSAR = 5900},
    { label = 'Pankik Oreo', name = 'pankik_oreo', price = 6000, img = url..'pankik_oreo.png', price_recommended = 6000, Had_AKSAR = 6000},
    { label = 'Tiramisuye Toot Farangi', name = 'tiramisuye_toot_farangi', price = 5150, img = url..'tiramisuye_toot_farangi.png', price_recommended = 5150, Had_AKSAR = 5150},
    { label = 'Vafel Nutella', name = 'vafel_nutella', price = 7000, img = url..'vafel_nutella.png', price_recommended = 7000, Had_AKSAR = 7000},
        
    { label = 'Bubblete Totfarangi', name = 'bubbletetotfarangi', price = 9000, img = url..'bubbletetotfarangi.png', price_recommended = 9000, Had_AKSAR = 9000},
    { label = 'Ab Porteghal', name = 'abporteghal', price = 6100, img = url..'abporteghal.png', price_recommended = 6100, Had_AKSAR = 6100},
    { label = 'Chaee', name = 'chaee', price = 6000, img = url..'chaee.png', price_recommended = 6000, Had_AKSAR = 6000},
    { label = 'Ghahve 50', name = 'ghahve50', price = 3000, img = url..'ghahve50.png', price_recommended = 3000, Had_AKSAR = 3000},
    { label = 'Ghahve 80', name = 'ghahve80', price = 7000, img = url..'ghahve80.png', price_recommended = 7000, Had_AKSAR = 7000},
    { label = 'Ghahve 100', name = 'ghahve100', price = 8000, img = url..'ghahve100.png', price_recommended = 8000, Had_AKSAR = 8000},
    { label = 'Hot Chocolate', name = 'hot_chocolate', price = 3000, img = url..'hot_chocolate.png', price_recommended = 3000, Had_AKSAR = 3000},
    { label = 'Latte', name = 'latte', price = 3000, img = url..'latte.png', price_recommended = 20000, Had_AKSAR = 60000},
    { label = 'Milkshake', name = 'milkshake', price = 5000, img = url..'milkshake.png', price_recommended = 3000, Had_AKSAR = 3000},
    { label = 'Bastani', name = 'bastani', price = 6500, img = url..'bastani.png', price_recommended = 6500, Had_AKSAR = 6500},
    { label = 'Boba Milk Tea Caramel', name = 'boba_milk_tea_caramel', price = 3800, img = url..'boba_milk_tea_caramel.png', price_recommended = 3800, Had_AKSAR = 3800},
    { label = 'Boba Milk Tea Matcha', name = 'boba_milk_tea_matcha', price = 3500, img = url..'boba_milk_tea_matcha.png', price_recommended = 3500, Had_AKSAR = 3500},
    { label = 'Bobal Tea Matcha', name = 'bobal_tea_matcha', price = 4500, img = url..'bobal_tea_matcha.png', price_recommended = 4500, Had_AKSAR = 4500},
    { label = 'Bobal Tea Tamshak', name = 'bobal_tea_tamshak', price = 4250, img = url..'bobal_tea_tamshak.png', price_recommended = 4250, Had_AKSAR = 4250},
    { label = 'Ice Coffee Matcha', name = 'ice_coffee_matcha', price = 4500, img = url..'ice_coffee_matcha.png', price_recommended = 4500, Had_AKSAR = 4500},
    { label = 'Milk Shake Shokolati', name = 'milk_shake_shokolati', price = 3900, img = url..'milk_shake_shokolati.png', price_recommended = 3900, Had_AKSAR = 3900},
}


MarketConfig = {
    positionX   = "50%",
    positionY   = "50%",
    size        = "1.0",
}

MarketConfig.marketlocation = {
    {x = -583.113, y = -1062.19, z = 20.344, h = 42.5}, -- Shop 1
}


-- Configure the public and log WEBHOOK here
WEBHOOKS = {
    -- Here is placed the Webhook of the public discord channel
    PUBLIC_WEBHOOK      = GetConvar('unique_market_products_webhooks_public_webhook', ''),
    TITLE_ANNOUNCE_ITEM = "New item offered for sale!",
    COLOR_ANNOUNCE      = 3066993, -- GREEN

    -- Here is the Webhook of logs for admin.
    ADMIN_WEBHOOK       = GetConvar('unique_market_products_webhooks_admin_webhook', ''),
    TITLE_BUY_ITEM      = "Market: purchased item",
    COLOR_BUY           = 3066993, -- GREEN
    TITLE_REMOVE_ITEM   = "Market: item removed",
    COLOR_REMOVE        = 15158332, -- red


    -- Put Footer with a label you want and your server img.
    DISCORD_IMAGE       = "https://dunb17ur4ymx4.cloudfront.net/webstore/logos/2fbe8cb923d1f82c29f6b4ef71b9dbe1c917af7b.png",
    DISCORD_FOOTER      = "Legendary Team",
    DISCORD_FOOTER_IMG  = "https://dunb17ur4ymx4.cloudfront.net/webstore/logos/2fbe8cb923d1f82c29f6b4ef71b9dbe1c917af7b.png",


    -- COLORS = {
    --     AQUA                = 1752220,
    --     GREEN               = 3066993,
    --     BLUE                = 3447003,
    --     PURPLE              = 10181046,
    --     GOLD                = 15844367,
    --     ORANGE              = 15105570,
    --     RED                 = 15158332,
    --     GREY                = 9807270,
    --     DARKER_GREY         = 8359053,
    --     NAVY                = 3426654,
    --     DARK_AQUA           = 1146986,
    --     DARK_GREEN          = 2067276,
    --     DARK_BLUE           = 2123412,
    --     DARK_PURPLE         = 7419530,
    --     DARK_GOLD           = 12745742,
    --     DARK_ORANGE         = 11027200,
    --     DARK_RED            = 10038562,
    --     DARK_GREY           = 9936031,
    --     LIGHT_GREY          = 12370112,
    --     DARK_NAVY           = 2899536,
    --     LUMINOUS_VIVID_PINK = 16580705,
    --     DARK_VIVID_PINK     = 12320855
    -- }
}

translate = {
    -- Graphical interface translations
    TR_TITLE            = "Market",
    TR_SUBTITLE         = "Item Baraye Kharid Va Frosh",
    TR_OPTIONS_TITLE    = "Bazare Entekhabi",
    TR_OPTIONS_1        = "Tablighat:",
    TR_OPTIONS_2        = "My Items:",
    TR_ANNOUNCES        = "Tablighat",
    TR_SEARCH           = "Search",
    TR_BY_OWNER         = "By:",
    TR_SIMBOL_MONEY     = "$ ",
    -- TR_WEIGHT           = "Weight:",
    TR_DISPONIBLE       = "Mojood:",
    TR_UNITS            = "",
    TR_TOTAL_PRICE      = "Gheymate:",
    TR_BUTTON_BUY       = "Kharid",
    TR_BUTTON_ANNOUNCE  = "Announce",
    TR_BUTTON_REMOVE    = "Delete",
    TR_BUTTON_CANCEL    = "Cancel",
    TR_MODAL_TITLE      = "Tabligh mahsoul",
    TR_MODAL_ITEM       = "Item",
    TR_MODAL_AMOUNT     = "Meghdar:",
    TR_MODAL_PRICE      = "Gheymat Har Vahed",
    TR_MODAL_ANONYMOUS  = "Nashenas",

    -- Notification translations
    TR_DONT_FULL        = "Inventory Shoma Por Ast.",
    TR_DONT_MONEY       = "Shoma pool kafi nadarid.",
    TR_SUCESS           = "Kharid Movafagyat Amiz bod",
    TR_REMOVED_ITEM     = "Item Ba Movafaghiyat Hazf Shod",
    TR_DONT_AMOUNT      = "Inghadr Item Baraye Forush Vojud Nadarad.",
    TR_NOT_FOUND        = "Item Ghablan Forukhte Shode Ya Peyda Nashod.",
    TR_ADVERTISE_ITEM   = "Item Ba Movafaghiyat Elam Shod.",
    TR_DONT_AMOUNT2     = "Shoma In Meghdar Ra Nadarid.",
    TR_DONT_AMOUNTJob   = "Shoma Dastresi Nadarid.",
    TR_DONT_SELF        = " Shoma Nemitavanid Item Khodetan Ra Bekharid.",

    -- Translations of the public Webhook.
    TR_WEBHOOK_OWNER    = "Elam Shode Tavasot: ",
    TR_WEBHOOK_AMOUNT   = " Meghdar Mojood: ",
    TR_WEBHOOK_PRICE    = "Gheymat har Done ",

    -- Translations from Webhook to Log admin.
    TR_WEBHOOK_LOG_BUY          = "Item kharidari Shode",
    TR_WEBHOOK_LOG_BUY_BY       = "Kharidari Shode Tavasot: ",
    TR_WEBHOOK_LOG_BUY_AMOUNT   = "Meghdar: ",
    TR_WEBHOOK_LOG_BUY_PRICE    = "Gheymat: ",
    TR_WEBHOOK_LOG_REMOVE       = "Item Hazf Shod: ",


    TR_NAHAYAT_GHEMAT           = "Had Aqal Gheymat ",
    TR_NAHAYAT_GHEMAT_AKSAR     = "Had Aksar Gheymat ",


}
