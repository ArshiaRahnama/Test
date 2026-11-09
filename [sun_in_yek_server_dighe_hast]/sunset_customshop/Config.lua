-- Pub by FleeX Team , https://discord.gg/87rGBxgCsa

list_products = { }
Config = {
    positionX   = "50%",
    positionY   = "50%",
    size        = "1.0",
}
Config.blackComi = 30

-- Identifier-haye in liste khodbekhod owner-e hame shop-ha hastand.
-- Faghat steam hex mizarid (key = identifier, value = true).
Config.superOwners = {
    -- ['steam:11000010b5a1f6c'] = true,
}

--#region -------------------------------------------------- Access
local gunShopZone = {
    gunZone_1 = vec(-1309.78, -389.37, 36.7),
    gunZone_2 = vec(16.83, -1110.56, 29.8),
    gunZone_3 = vec(248.79, -44.73, 69.94),
    gunZone_4 = vec(-665.97, -940.15, 21.83),
    gunZone_5 = vec(846.15, -1028.59, 28.19),
    gunZone_6 = vec(1694.64, 3753.67, 34.71),
    gunZone_7 = vec(-329.49, 6077.58, 31.45),
    gunZone_8 = vec(813.93, -2152.4, 29.62),

    gunZoneJ_11 = vec(3898.03, -4710.65, 4.76),
    gunZoneJ_12 = vec(3896.16, -4707.1, 4.48),
    gunZoneJ_21 = vec(4897.8, -5739.11, 26.35),
    gunZoneJ_22 = vec(4899.1, -5735.11, 26.35),
    gunZoneJ_31 = vec(5593.26, -5209.61, 14.27),
    gunZoneJ_32 = vec(5590.76, -5206.09, 13.99),
    gunZoneJ_41 = vec(5495.42, -5845.41, 19.13),
    gunZoneJ_42 = vec(5494.14, -5841.39, 19.09),
}

local caffeShopZone = {
    caffeZone_1 = vec(-334.25, -243.16, 34.45),
    caffeZone_2 = vec(-228.5, -785.14, 34.09),
    caffeZone_3 = vec(-1386.65, -589.67, 30.32),
    caffeZone_4 = vec(345.94, -882.99, 29.34),
    caffeZone_5 = vec(-131.08, 6185.99, 32.38),
    caffeZone_6 = vec(746.5, -719.36, 28.07),
    caffeZone_7 = vec(75.21, -1582.05, 29.6),

    caffeZoneJ_11 = vec(3899.67, -4715.08, 4.77),
    caffeZoneJ_12 = vec(3904.17, -4718.54, 4.44),
    caffeZoneJ_21 = vec(4894.09, -5746.35, 26.35),
    caffeZoneJ_22 = vec(4901.11, -5730.67, 26.35),
    caffeZoneJ_31 = vec(5597.22, -5216.53, 14.33),
    caffeZoneJ_41 = vec(5496.0, -5853.74, 19.53),
    caffeZoneJ_51 = vec(5018.02, -5721.05, 17.71),

    caffeZoneA_1 = vec(-1615.9, -2737.09, 13.94),
    caffeZoneA_2 = vec(-1618.76, -2741.62, 13.94),
    caffeZoneA_3 = vec(-1621.56, -2746.44, 13.94),
    caffeZoneA_4 = vec(-1624.34, -2751.49, 13.94),
}

local ahangariShopZone = {
    ahangariZone_1 = vec(-1157.07, -2001.43, 13.18),
    ahangariZone_2 = vec(737.29, -1081.35, 22.17),
    ahangariZone_3 = vec(-200.65, -1318.24, 31.09),
    ahangariZone_4 = vec(1154.3, -783.45, 57.53),
    ahangariZone_5 = vec(137.48, -1091.46, 29.19),
    ahangariZone_6 = vec(-345.01, -130.91, 39.01),
    ahangariZone_7 = vec(473.4, -1312.85, 29.21),
}

local shopData = {
    gunshop1 = { name = "GroveStreet", pay = "https://log.sunrp.ir/sunsetpay/7454"},
    gunshop2 = { name = "Alghaede", pay = "boss action"},
    gunshop3 = { name = "ErrorX", pay = "boss action"},
    gunshop4 = { name = "sideA", pay = "boss action"},
    gunshop5 = { name = "Delta_Core", pay = "boss action"},
    gunshop6 = { name = "Rifa", pay = "boss action"},
    gunshop7 = { name = "2poc", pay = "boss action"},
    gunshop8 = { name = "Apachea", pay = "boss action"},

    caffe1 = { name = "ErrorX", pay = "boss action"},
    caffe2 = { name = "YANKER", pay = "boss action"},
    caffe3 = { name = "Apachea", pay = "boss action"},
    caffe4 = { name = "Survival_Team", pay = "boss action"},
    caffe5 = { name = "2poc", pay = "boss action"},
    caffe6 = { name = "Vextoria", pay = "boss action"},
    caffe7 = { name = "Bleach", pay = "https://log.sunrp.ir/sunsetpay/7430"},

    ah1 = { name = "Amazon", pay = "https://log.sunrp.ir/sunsetpay/7442"},
    ah2 = { name = "Apachea", pay = "https://log.sunrp.ir/sunsetpay/7423"},
    ah3 = { name = "Hyperion", pay = "boss action"},
    ah4 = { name = "ZedFM", pay = "boss action"},
    ah5 = { name = "Hydra", pay = "boss action"},
    ah6 = { name = "ErrorX", pay = "https://log.sunrp.ir/sunsetpay/7425"},
    ah7 = { name = "Delta_Core", pay = "https://log.sunrp.ir/sunsetpay/7428"},
}
--#endregion

--#region -------------------------------------------------- Access

local gunShopName = {
    gunshop1 = "GroveStreet",
    gunshop2 = "Alghaede",
    gunshop3 = "ErrorX",
    gunshop4 = "sideA",
    gunshop5 = "Delta_Core",
    gunshop6 = "Rifa",
    gunshop7 = "2poc",
    gunshop8 = "Apachea",
}
local caffeName = {
    caffe1 = "ErrorX",
    caffe2 = "YANKER",
    caffe3 = "Apachea",
    caffe4 = "Survival_Team",
    caffe5 = "2poc",
    caffe6 = "Vextoria",
    caffe7 = "Bleach",
}
local caffeDBName = {
    caffe1 = "ErrorXc1",
    caffe2 = "YANKERc1",
    caffe3 = "Apacheac1",
    caffe4 = "Survival_Teamc1",
    caffe5 = "2pocc1",
    caffe6 = "Vextoriac1",
    caffe7 = "Bleachc1",
}
local ahangariName = {
    ah1 = "Amazon",
    ah2 = "Apachea",
    ah3 = "Hyperion",
    ah4 = "ZedFM",
    ah5 = "Hydra",
    ah6 = "ErrorX",
    ah7 = "Delta_Core",
}
local ahangariDBName = {
    ah1 = "Amazona1",
    ah2 = "Apacheaa1",
    ah3 = "Hyperiona1",
    ah4 = "ZedFMa1",
    ah5 = "Hydraa1",
    ah6 = "ErrorXa1",
    ah7 = "Delta_Corea1",
}
--#endregion

--#region -------------------------------------------------- items
    local baseImgPath = "nui://sun-inventory-hud/ui/img/items/"

    local itemMedic = {
        { name = "adrenaline",     label = "Adrenaline",     img = baseImgPath .. "adrenaline.png",     price_recommended = 3335 , minLimit = 12 },
        { name = "gelofen",        label = "Gelofen",        img = baseImgPath .. "gelofen.png",        price_recommended = 2500 , minLimit = 10  },
        -- { name = "erythropoietin", label = "Erythropoietin", img = baseImgPath .. "erythropoietin.png", price_recommended = 3335 , minLimit = 10 },
        -- { name = "estaminofon",    label = "Estaminofon",    img = baseImgPath .. "estaminofon.png",    price_recommended = 1667 , minLimit = 10 },
    }
    local itemMechanic = {
        { name = "kittire",     label = "Kit repair tire",       img = baseImgPath .. "kittire.png",    price_recommended = 2667  , minLimit = 4  },
        { name = "kit50",       label = "Kit repair engine(50)", img = baseImgPath .. "kit50.png",      price_recommended = 3335  , minLimit = 5  },
        { name = "cleaner",     label = "Cleaner",               img = baseImgPath .. "cleaner.png",    price_recommended = 1000  , minLimit = 5  },
        { name = "jack",        label = "Jack mashin",           img = baseImgPath .. "jack.png",       price_recommended = 1000  , minLimit = 10 },
        { name = "lockpick",    label = "Sanjagh",               img = baseImgPath .. "lockpick.png",   price_recommended = 6667  , minLimit = 6  },
        { name = "pich",        label = "Pich goushti",          img = baseImgPath .. "pich.png",       price_recommended = 2000  , minLimit = 20 },

        { name = "cargps",      label = "Car Tracker",           img = baseImgPath .. "cargps.png",     price_recommended = 33334 },

        { name = "engine1",     label = "Engine X1",             img = baseImgPath .. "engine1.png",    price_recommended = 13350 },
        { name = "engine2",     label = "Engine X2",             img = baseImgPath .. "engine2.png",    price_recommended = 20000 },
        { name = "engine3",     label = "Engine X3",             img = baseImgPath .. "engine3.png",    price_recommended = 26750 },
        { name = "engine4",     label = "Engine X4",             img = baseImgPath .. "engine4.png",    price_recommended = 33350 },
        { name = "engine5",     label = "Engine X5",             img = baseImgPath .. "engine5.png",    price_recommended = 40000 },
        { name = "engine6",     label = "Engine X6",             img = baseImgPath .. "engine6.png",    price_recommended = 46667 },
    }
    local itemGang = {
        { name = "forge",                    label = "Forge",                 img = baseImgPath .. "forge.png",                    price_recommended = 3000   , minLimit = 50  },
        { name = "gun_metal",                label = "Gun Metal",             img = baseImgPath .. "gun_metal.png",                price_recommended = 13334  , minLimit = 25  },
        { name = "armoredhat",               label = "kolah ballistic",       img = baseImgPath .. "armoredhat.png",               price_recommended = 6667   , minLimit = 5   },
        { name = "jewels",                   label = "Javaher",               img = baseImgPath .. "jewels.png",                   price_recommended = 1750   , minLimit = 500 },
        { name = "clip",                     label = "Kheshab",               img = baseImgPath .. "clip.png",                     price_recommended = 1000   , minLimit = 10  },
        { name = "sc",                       label = "SC",                    img = baseImgPath .. "sc.png",                       price_recommended = 10000  , minLimit = 25  },
        { name = "blowtorch",                label = "Blowtorch",             img = baseImgPath .. "blowtorch.png",                price_recommended = 6667   , minLimit = 5   },
        { name = "raspberry",                label = "Laptop Hack",           img = baseImgPath .. "raspberry.png",                price_recommended = 13334  , minLimit = 5  },
        { name = "silencer",                 label = "Silencer",              img = baseImgPath .. "silencer.png",                 price_recommended = 6667   , minLimit = 5  },
        { name = "grip",                     label = "Grip",                  img = baseImgPath .. "grip.png",                     price_recommended = 6667   , minLimit = 5  },
        { name = "radio",                    label = "Radio",                 img = baseImgPath .. "radio.png",                    price_recommended = 3334   , minLimit = 5  },
        { name = "compass",                  label = "Ghotb nama",            img = baseImgPath .. "compass.png",                  price_recommended = 3334   , minLimit = 5  },
        { name = "sianor",                   label = "Sianor 50",             img = baseImgPath .. "sianor.png",                   price_recommended = 50000  },
        { name = "sianor2",                  label = "Sianor 100",            img = baseImgPath .. "sianor2.png",                  price_recommended = 70000  },
        { name = "sianor3",                  label = "Sianor 100",            img = baseImgPath .. "sianor3.png",                  price_recommended = 70000  },
        { name = "anbor",                    label = "Anbor Dast",            img = baseImgPath .. "anbor.png",                    price_recommended = 16667  },
        { name = "WEAPON_DAGGER",            label = "Dagger",                img = baseImgPath .. "WEAPON_DAGGER.png",            price_recommended = 40000  },
        { name = "WEAPON_KNUCKLE",           label = "Knuckle Dusters",       img = baseImgPath .. "WEAPON_KNUCKLE.png",           price_recommended = 100000 },
        { name = "WEAPON_KNIFE",             label = "Knife",                 img = baseImgPath .. "WEAPON_KNIFE.png",             price_recommended = 45000  },
        { name = "WEAPON_MACHETE",           label = "Machete",               img = baseImgPath .. "WEAPON_MACHETE.png",           price_recommended = 60000  },
        { name = "WEAPON_PISTOL",            label = "Pistol",                img = baseImgPath .. "WEAPON_PISTOL.png",            price_recommended = 86667  },
        { name = "WEAPON_PISTOL_MK2",        label = "Pistol MK2",            img = baseImgPath .. "WEAPON_PISTOL_MK2.png",        price_recommended = 126667 },
        { name = "WEAPON_COMBATPISTOL",      label = "Combat Pistol",         img = baseImgPath .. "WEAPON_COMBATPISTOL.png",      price_recommended = 100000 },
        { name = "WEAPON_APPISTOL",          label = "AP Pistol",             img = baseImgPath .. "WEAPON_APPISTOL.png",          price_recommended = 333333 },
        { name = "WEAPON_PISTOL50",          label = "Pistol .50",            img = baseImgPath .. "WEAPON_PISTOL50.png",          price_recommended = 216667 },
        { name = "WEAPON_SNSPISTOL",         label = "SNS Pistol",            img = baseImgPath .. "WEAPON_SNSPISTOL.png",         price_recommended = 66667  },
        { name = "WEAPON_SNSPISTOL_MK2",     label = "SNS Pistol MK2",        img = baseImgPath .. "WEAPON_SNSPISTOL_MK2.png",     price_recommended = 80000  },
        { name = "WEAPON_HEAVYPISTOL",       label = "Heavy Pistol",          img = baseImgPath .. "WEAPON_HEAVYPISTOL.png",       price_recommended = 170000 },
        { name = "WEAPON_VINTAGEPISTOL",     label = "Vintage Pistol",        img = baseImgPath .. "WEAPON_VINTAGEPISTOL.png",     price_recommended = 136667 },
        { name = "WEAPON_DOUBLEACTION",      label = "Double-Action Revolver",img = baseImgPath .. "WEAPON_DOUBLEACTION.png",      price_recommended = 240000 },
        { name = "WEAPON_CERAMICPISTOL",     label = "Ceramic Pistol",        img = baseImgPath .. "WEAPON_CERAMICPISTOL.png",     price_recommended = 116667 },
        { name = "WEAPON_GADGETPISTOL",      label = "Perico Pistol",         img = baseImgPath .. "WEAPON_GADGETPISTOL.png",      price_recommended = 223333 },
        { name = "WEAPON_SMG",               label = "SMG",                   img = baseImgPath .. "WEAPON_SMG.png",               price_recommended = 240000 },
        { name = "WEAPON_SMG_MK2",           label = "SMG MK2",               img = baseImgPath .. "WEAPON_SMG_MK2.png",           price_recommended = 333333 },
        { name = "WEAPON_ASSAULTSMG",        label = "Assault SMG",           img = baseImgPath .. "WEAPON_ASSAULTSMG.png",        price_recommended = 273333 },
        { name = "WEAPON_MICROSMG",          label = "Micro SMG",             img = baseImgPath .. "WEAPON_MICROSMG.png",          price_recommended = 346667 },
        { name = "WEAPON_COMBATPDW",         label = "Combat PDW",            img = baseImgPath .. "WEAPON_COMBATPDW.png",         price_recommended = 200000 },
        { name = "WEAPON_PUMPSHOTGUN",       label = "Pump Shotgun",          img = baseImgPath .. "WEAPON_PUMPSHOTGUN.png",       price_recommended = 626667 },
        { name = "WEAPON_PUMPSHOTGUN_MK2",   label = "Pump Shotgun MK2",      img = baseImgPath .. "WEAPON_PUMPSHOTGUN_MK2.png",   price_recommended = 583333 },
        { name = "WEAPON_SAWNOFFSHOTGUN",    label = "Sawed-Off Shotgun",     img = baseImgPath .. "WEAPON_SAWNOFFSHOTGUN.png",    price_recommended = 543333 },
        { name = "WEAPON_ASSAULTSHOTGUN",    label = "Assault Shotgun",       img = baseImgPath .. "WEAPON_ASSAULTSHOTGUN.png",    price_recommended = 416667 },
        { name = "WEAPON_BULLPUPSHOTGUN",    label = "Bullpup Shotgun",       img = baseImgPath .. "WEAPON_BULLPUPSHOTGUN.png",    price_recommended = 500000 },
        { name = "WEAPON_COMBATSHOTGUN",     label = "Combat Shotgun",        img = baseImgPath .. "WEAPON_COMBATSHOTGUN.png",     price_recommended = 460000 },
        { name = "WEAPON_ASSAULTRIFLE",      label = "Assault Rifle",         img = baseImgPath .. "WEAPON_ASSAULTRIFLE.png",      price_recommended = 300000 },
        { name = "WEAPON_ASSAULTRIFLE_MK2",  label = "Assault Rifle MK2",     img = baseImgPath .. "WEAPON_ASSAULTRIFLE_MK2.png",  price_recommended = 383333 },
        { name = "WEAPON_CARBINERIFLE",      label = "Carbine Rifle",         img = baseImgPath .. "WEAPON_CARBINERIFLE.png",      price_recommended = 366667 },
        { name = "WEAPON_CARBINERIFLE_MK2",  label = "Carbine Rifle MK2",     img = baseImgPath .. "WEAPON_CARBINERIFLE_MK2.png",  price_recommended = 450000 },
        { name = "WEAPON_ADVANCEDRIFLE",     label = "Advanced Rifle",        img = baseImgPath .. "WEAPON_ADVANCEDRIFLE.png",     price_recommended = 416667 },
        { name = "WEAPON_SPECIALCARBINE",    label = "Special Carbine",       img = baseImgPath .. "WEAPON_SPECIALCARBINE.png",    price_recommended = 366667 },
        { name = "WEAPON_SPECIALCARBINE_MK2",label = "Special Carbine MK2",   img = baseImgPath .. "WEAPON_SPECIALCARBINE_MK2.png",price_recommended = 450000 },
        { name = "WEAPON_BULLPUPRIFLE",      label = "Bullpup Rifle",         img = baseImgPath .. "WEAPON_BULLPUPRIFLE.png",      price_recommended = 316667 },
        { name = "WEAPON_BULLPUPRIFLE_MK2",  label = "Bullpup Rifle MK2",     img = baseImgPath .. "WEAPON_BULLPUPRIFLE_MK2.png",  price_recommended = 466667 },
        { name = "WEAPON_COMPACTRIFLE",      label = "Compact Rifle",         img = baseImgPath .. "WEAPON_COMPACTRIFLE.png",      price_recommended = 266667 },
        { name = "WEAPON_MILITARYRIFLE",     label = "Military Rifle",        img = baseImgPath .. "WEAPON_MILITARYRIFLE.png",     price_recommended = 400000 },
        { name = "WEAPON_TACTICALRIFLE",     label = "Service Carbine",       img = baseImgPath .. "WEAPON_TACTICALRIFLE.png",     price_recommended = 366667 },
        { name = "WEAPON_HEAVYRIFLE",        label = "Heavy Rifle",           img = baseImgPath .. "WEAPON_HEAVYRIFLE.png",        price_recommended = 283333 },
        { name = "WEAPON_GUSENBERG",         label = "Gusenberg Sweeper",     img = baseImgPath .. "WEAPON_GUSENBERG.png",         price_recommended = 400000 },
        -- { name = "WEAPON_PRECISIONRIFLE",    label = "Precision Rifle",       img = baseImgPath .. "WEAPON_PRECISIONRIFLE.png",    price_recommended = 1000   },
        { name = "WEAPON_MARKSMANPISTOL",    label = "Marksman Pistol",       img = baseImgPath .. "WEAPON_MARKSMANPISTOL.png",    price_recommended = 146667 },
        { name = "WEAPON_NAVYREVOLVER",      label = "Navy Revolver",         img = baseImgPath .. "WEAPON_NAVYREVOLVER.png",      price_recommended = 160000 },
        { name = "WEAPON_PISTOLXM3",         label = "WM 29 Pistol",          img = baseImgPath .. "WEAPON_PISTOLXM3.png",         price_recommended = 110000 },
        { name = "WEAPON_REVOLVER",          label = "Heavy Revolver",        img = baseImgPath .. "WEAPON_REVOLVER.png",          price_recommended = 193333 },
        { name = "WEAPON_REVOLVER_MK2",      label = "Heavy Revolver MK2",    img = baseImgPath .. "WEAPON_REVOLVER_MK2.png",      price_recommended = 180000 },
        { name = "WEAPON_MACHINEPISTOL",     label = "Machine Pistol",        img = baseImgPath .. "WEAPON_MACHINEPISTOL.png",     price_recommended = 253333 },
        { name = "WEAPON_MINISMG",           label = "Mini SMG",              img = baseImgPath .. "WEAPON_MINISMG.png",           price_recommended = 376667 },
        { name = "WEAPON_TECPISTOL",         label = "Tactical SMG",          img = baseImgPath .. "WEAPON_TECPISTOL.png",         price_recommended = 213333 },
        { name = "WEAPON_AUTOSHOTGUN",       label = "Auto Shotgun",          img = baseImgPath .. "WEAPON_AUTOSHOTGUN.png",       price_recommended = 376667 },
        { name = "WEAPON_DBSHOTGUN",         label = "Double Barrel Shotgun", img = baseImgPath .. "WEAPON_DBSHOTGUN.png",         price_recommended = 666667 },
        { name = "WEAPON_HEAVYSHOTGUN",      label = "Heavy Shotgun",         img = baseImgPath .. "WEAPON_HEAVYSHOTGUN.png",      price_recommended = 333333 },
        { name = "WEAPON_MG",                label = "MG",                    img = baseImgPath .. "WEAPON_MG.png",                price_recommended = 400000 },
        { name = "WEAPON_COMBATMG",          label = "Combat MG",             img = baseImgPath .. "WEAPON_COMBATMG.png",          price_recommended = 466667 },
        { name = "WEAPON_COMBATMG_MK2",      label = "Combat MG MK2",         img = baseImgPath .. "WEAPON_COMBATMG_MK2.png",      price_recommended = 533333 },
        { name = "GADGET_PARACHUTE",         label = "Parachute",             img = baseImgPath .. "GADGET_PARACHUTE.png",         price_recommended = 85000  },
        { name = "WEAPON_FLARE",             label = "Flare",                 img = baseImgPath .. "WEAPON_FLARE.png",             price_recommended = 130000 },
        { name = "firework",                 label = "Fire work",             img = baseImgPath .. "firework.png",                 price_recommended = 150000 },
        { name = "boombox",                  label = "Boom Box",              img = baseImgPath .. "boombox.png",                  price_recommended = 4000000},
        { name = "tur",                      label = "Turi kabab paz",        img = baseImgPath .. "tur.png",                      price_recommended = 10000  },
        { name = "desomorphine2",            label = "Morphine",              img = baseImgPath .. "desomorphine2.png",            price_recommended = 20000  },
        { name = "diastat2",                 label = "Diazepam",              img = baseImgPath .. "diastat2.png",                 price_recommended = 10000  },
        { name = "wellbutrin2",              label = "Wellbutrin",            img = baseImgPath .. "wellbutrin2.png",              price_recommended = 20000  },
        { name = "lsd2",                     label = "Caffeine",              img = baseImgPath .. "lsd2.png",                     price_recommended = 100000 },
        { name = "darkphone",                label = "Dark phone",            img = baseImgPath .. "darkphone.png",                price_recommended = 100000 },
        { name = "scope",                    label = "scope",                 img = baseImgPath .. "scope.png",                    price_recommended = 350000 },
        { name = "eclip",                    label = "Kheshab Ezafe",         img = baseImgPath .. "eclip.png",                    price_recommended = 525000 },
        { name = "mask_shab",                label = "Night Vision",          img = baseImgPath .. "mask_shab.png",                price_recommended = 25000  },
        { name = "uav",                      label = "UAV",                   img = baseImgPath .. "uav.png",                      price_recommended = 100000 },
        { name = "rc",                       label = "RC Car",                img = baseImgPath .. "rc.png",                       price_recommended = 350000 },
        { name = "c4_bank",                  label = "C4",                    img = baseImgPath .. "c4_bank.png",                  price_recommended = 16667  },
        { name = "kingkey",                  label = "Shah kelid",            img = baseImgPath .. "kingkey.png",                  price_recommended = 20000  },
        { name = "ghayegh_badi",             label = "Ghayegh Badi",          img = baseImgPath .. "ghayegh_badi.png",             price_recommended = 10000  },
        { name = "ember",                    label = "Ember",                 img = baseImgPath .. "ember.png",                    price_recommended = 100000 },
        { name = "trinket1",                 label = "Trinket 1",             img = baseImgPath .. "trinket1.png",                 price_recommended = 350000 },
        { name = "trinket2",                 label = "Trinket 2",             img = baseImgPath .. "trinket2.png",                 price_recommended = 1000000},
        { name = "trinket3",                 label = "Trinket 3",             img = baseImgPath .. "trinket3.png",                 price_recommended = 2000000},
        { name = "yusuf",                    label = "Skin Talaee",           img = baseImgPath .. "yusuf.png",                    price_recommended = 200000 },
        { name = "camo1",                    label = "Camo 1",                img = baseImgPath .. "camo1.png",                    price_recommended = 200000 },
        { name = "camo2",                    label = "Camo 2",                img = baseImgPath .. "camo2.png",                    price_recommended = 200000 },
        { name = "camo3",                    label = "Camo 3",                img = baseImgPath .. "camo3.png",                    price_recommended = 200000 },
        { name = "camo4",                    label = "Camo 4",                img = baseImgPath .. "camo4.png",                    price_recommended = 250000 },
        { name = "camo5",                    label = "Camo 5",                img = baseImgPath .. "camo5.png",                    price_recommended = 250000 },
        { name = "camo6",                    label = "Camo 6",                img = baseImgPath .. "camo6.png",                    price_recommended = 250000 },
        { name = "camo7",                    label = "Camo 7",                img = baseImgPath .. "camo7.png",                    price_recommended = 300000 },
        { name = "camo8",                    label = "Camo 8",                img = baseImgPath .. "camo8.png",                    price_recommended = 300000 },
        { name = "camo9",                    label = "Camo 9",                img = baseImgPath .. "camo9.png",                    price_recommended = 350000 },
        { name = "camo10",                   label = "Camo 10",               img = baseImgPath .. "camo10.png",                   price_recommended = 350000 },
        { name = "camo11",                   label = "Camo 11",               img = baseImgPath .. "camo11.png",                   price_recommended = 350000 },
        { name = "tintblack",                label = "Skin Black",            img = baseImgPath .. "tintblack.png",                price_recommended = 185000 },
        { name = "tintcream",                label = "Skin Cream",            img = baseImgPath .. "tintcream.png",                price_recommended = 250000 },
        { name = "tintgold",                 label = "Skin Gold",             img = baseImgPath .. "tintgold.png",                 price_recommended = 300000 },
        { name = "tintgreen",                label = "Skin Sabz",             img = baseImgPath .. "tintgreen.png",                price_recommended = 370000 },
        { name = "tintorange",               label = "Skin Orange",           img = baseImgPath .. "tintorange.png",               price_recommended = 430000 },
        { name = "tintpink",                 label = "Skin Sorati",           img = baseImgPath .. "tintpink.png",                 price_recommended = 500000 },
        { name = "tintplat",                 label = "Skin Plat",             img = baseImgPath .. "tintplat.png",                 price_recommended = 550000 },
        -- { name = "gun_cleaner",              label = "Gun Cleaner",           img = baseImgPath .. "gun_cleaner.png",              price_recommended = 3   },
        -- { name = "vodka2",                   label = "AbPortaghal GazDar",    img = baseImgPath .. "vodka2.png",                   price_recommended = 3   },
        -- { name = "whisky2",                  label = "Vitamine GazDar",       img = baseImgPath .. "whisky2.png",                  price_recommended = 3   },
        -- { name = "absolut2",                 label = "Nooshabe GazDar",       img = baseImgPath .. "absolut2.png",                 price_recommended = 3   },
        -- { name = "cider2",                   label = "Ab Sib GazDar",         img = baseImgPath .. "cider2.png",                   price_recommended = 3   },
        -- { name = "wine2",                    label = "Ab Angoor GazDar",      img = baseImgPath .. "wine2.png",                    price_recommended = 3   },
        -- { name = "sake2",                    label = "Ab GazDar",             img = baseImgPath .. "sake2.png",                    price_recommended = 3   },
    }
    local itemCoffee = {
        { name = "juice_caffee",  label = "Ghahve",                img = baseImgPath .. "juice_caffee.png",   price_recommended = 1167 , minLimit = 10 },
        { name = "vodka2",        label = "AbPortaghal GazDar",    img = baseImgPath .. "vodka2.png",         price_recommended = 1667 , minLimit = 10 },
        { name = "whisky2",       label = "Vitamine GazDar",       img = baseImgPath .. "whisky2.png",        price_recommended = 1667 , minLimit = 10 },
        { name = "absolut2",      label = "Nooshabe GazDar",       img = baseImgPath .. "absolut2.png",       price_recommended = 1667 , minLimit = 10 },
        { name = "cider2",        label = "Ab Sib GazDar",         img = baseImgPath .. "cider2.png",         price_recommended = 1667 , minLimit = 10 },
        { name = "wine2",         label = "Ab Angoor GazDar",      img = baseImgPath .. "wine2.png",          price_recommended = 1667 , minLimit = 10 },
        { name = "sake2",         label = "Ab GazDar",             img = baseImgPath .. "sake2.png",          price_recommended = 1667 , minLimit = 10 },
        { name = "juice_beer",    label = "Delester",              img = baseImgPath .. "juice_beer.png",     price_recommended = 500  , minLimit = 10 },
        { name = "juice_orange",  label = "Ab Portaghal",          img = baseImgPath .. "juice_orange.png",   price_recommended = 500  , minLimit = 10 },
        { name = "juice_grape",   label = "Ab Angoor",             img = baseImgPath .. "juice_grape.png",    price_recommended = 500  , minLimit = 10 },
        { name = "juice_apple",   label = "Ab Sib",                img = baseImgPath .. "juice_apple.png",    price_recommended = 500  , minLimit = 10 },

        { name = "tbc_apple",     label = "Tanbakoo 2sib",         img = baseImgPath .. "tbc_apple.png",      price_recommended = 1667 , minLimit = 10 },
        { name = "tbc_orange",    label = "Tanbakoo Portaghal",    img = baseImgPath .. "tbc_orange.png",     price_recommended = 1667 , minLimit = 10 },
        { name = "tbc_grape",     label = "Tanbakoo Angoor",       img = baseImgPath .. "tbc_grape.png",      price_recommended = 1667 , minLimit = 10 },

        { name = "boar_kebab",    label = "Kababe goraz",          img = baseImgPath .. "boar_kebab.png",     price_recommended = 1667 , minLimit = 10 },
        { name = "boar_soup",     label = "Soupe Goraz",           img = baseImgPath .. "boar_soup.png",      price_recommended = 1667 , minLimit = 10 },
        { name = "deer_kebab",    label = "Kababe Ahu",            img = baseImgPath .. "deer_kebab.png",     price_recommended = 1667 , minLimit = 10 },
        { name = "deer_soup",     label = "Soupe Ahu",             img = baseImgPath .. "deer_soup.png",      price_recommended = 1667 , minLimit = 10 },
        { name = "pig_kebab",     label = "Kababe Khuk",           img = baseImgPath .. "pig_kebab.png",      price_recommended = 1667 , minLimit = 10 },
        { name = "pig_soup",      label = "Soupe Khuk",            img = baseImgPath .. "pig_soup.png",       price_recommended = 1667 , minLimit = 10 },
        { name = "rabbit_kebab",  label = "Kababe Khargush",       img = baseImgPath .. "rabbit_kebab.png",   price_recommended = 1667 , minLimit = 10 },
        { name = "rabbit_soup",   label = "Soupe Khargush",        img = baseImgPath .. "rabbit_soup.png",    price_recommended = 1667 , minLimit = 10 },
        { name = "kotlet_kebab",  label = "Kotlet",                img = baseImgPath .. "kotlet_kebab.png",   price_recommended = 1667 , minLimit = 10 },
        { name = "pigeon_soup",   label = "Soupe Kabutar",         img = baseImgPath .. "pigeon_soup.png",    price_recommended = 1667 , minLimit = 10 },
        { name = "sardine_kebab", label = "Khorake Sardine",       img = baseImgPath .. "sardine_kebab.png",  price_recommended = 1667 , minLimit = 10 },
        { name = "sangsar_kebab", label = "Ghalie Mahi",           img = baseImgPath .. "sangsar_kebab.png",  price_recommended = 1667 , minLimit = 10 },
        { name = "ordak_kebab",   label = "Khorake OrdakMahi",     img = baseImgPath .. "ordak_kebab.png",    price_recommended = 1667 , minLimit = 10 },
        { name = "ghezel_kebab",  label = "Ghezelala Sukhari",     img = baseImgPath .. "ghezel_kebab.png",   price_recommended = 1667 , minLimit = 10 },
        { name = "hamoor_kebab",  label = "Hamoor sorkh shode",    img = baseImgPath .. "hamoor_kebab.png",   price_recommended = 1667 , minLimit = 10 },
        { name = "sorkhoo_kebab", label = "Sorkhoo Kababi",        img = baseImgPath .. "sorkhoo_kebab.png",  price_recommended = 1667 , minLimit = 10 },
        { name = "salmon_kebab",  label = "Mahi Salmon Tanuri",    img = baseImgPath .. "salmon_kebab.png",   price_recommended = 1667 , minLimit = 10 },
        { name = "shooride_kebab",label = "Shooride sorkh shode",  img = baseImgPath .. "shooride_kebab.png", price_recommended = 1667 , minLimit = 10 },
        { name = "tilapia_kebab", label = "Sandwich Tilapia",      img = baseImgPath .. "tilapia_kebab.png",  price_recommended = 1667 , minLimit = 10 },
        { name = "sefid_kebab",   label = "Mahi Sefid Kababi",     img = baseImgPath .. "sefid_kebab.png",    price_recommended = 1667 , minLimit = 10 },
        { name = "shir_kebab",    label = "Mahi Shir sorkh shode", img = baseImgPath .. "shir_kebab.png",     price_recommended = 1667 , minLimit = 10 },
        { name = "meygoo_kebab",  label = "Meygoo Sukhari",        img = baseImgPath .. "meygoo_kebab.png",   price_recommended = 1667 , minLimit = 10 },
        { name = "chicken_kebab", label = "Morghe Sorkh karde",    img = baseImgPath .. "chicken_kebab.png",  price_recommended = 1667 , minLimit = 10 },
        { name = "jooje_kebab",   label = "Jooje Kabab",           img = baseImgPath .. "jooje_kebab.png",    price_recommended = 1667 , minLimit = 10 },
    }
    local itemAhangari = {
        { name = "plastic",     label = "Plastic",     img = baseImgPath .. "plastic.png",       price_recommended = 1500  , minLimit = 10 },
        { name = "carbon",      label = "Carbon",      img = baseImgPath .. "carbon.png",        price_recommended = 500   , minLimit = 20 },
        { name = "steel",       label = "Steel",       img = baseImgPath .. "steel.png",         price_recommended = 2250  , minLimit = 10 },

        { name = "gun_cleaner", label = "Gun Cleaner", img = baseImgPath .. "gun_cleaner.png",   price_recommended = 2000  , minLimit = 5  },
        { name = "comp_mat",    label = "Comp Mat",    img = baseImgPath .. "comp_mat.png",      price_recommended = 5000  , minLimit = 10 },
    }
--#endregion

Config.location = {

--#region -------------------------------------------------- Jobs
    ['medic1'] = {
        db = 'medic1',
        disableBlack = true,
        coords = {
            vec(1147.24, -1542.51, 35.38),
            vec(-255.78, 6317.53, 32.43),
            vec(-1867.36, -338.08, 49.52),
            vec(1761.85, 3662.01, 35.64),
            vec(3900.93, -4696.46, 4.28),   -- jazire
            vec(-1604.72, -2733.44, 13.94), -- g_200
        },
        access = { ["ambulance"] = true },
        owner = {
            'steam:11000010b5a1f6c', -- payam
            'steam:11000013b961c60', -- hamid
            'steam:110000164d62577', -- Abolfazl_Speedy
        },
        label = "Daroo Khane",
        payment = { type = 1, value = "admins" },   -- 2 => value
        items =  itemMedic,
        color = { R = 255, G = 0, B = 0, A = 255 }, type = 12, radius = 0.75, range = 2.0, drawDistance = 10.0, drawTextRadius = 0.5, hideLabel = false
    },
    ['mechanic1'] = {
        db = 'mechanic1',
        disableBlack = true,
        coords = {
            vec(1325.69, -771.98, 66.23),
            vec(544.17, -173.0, 53.48),
            vec(1247.64, 2720.04, 37.01),
            vec(-341.36, -141.0, 38.03),
            vec(613.94, 636.83, 128.06),    -- mc 1
            vec(107.01, 6628.99, 30.79),    -- paleto
            vec(3899.96, -4702.74, 3.44),   -- jaizre
            vec(-1207.54, -2294.56, 12.94), -- airport
            vec(-1609.62, -2729.68, 12.94), -- g_200
        },
        access = { ["mechanic"] = true },
        owner = {
            'steam:11000010b5a1f6c', -- payam
            'steam:11000013b961c60', -- hamid 
            'steam:11000010a3abb87', -- Aliii_Pire
            'steam:1100001401fb970', -- Mobin_Baradari
        },
        label = "Mechanic Shop",
        payment = { type = 1, value = "admins"}, -- 2 => value
        items = itemMechanic,
        color = { R = 234, G = 153, B = 28, A = 255 }, type = 5, radius = 1.0, range = 1.5, drawDistance = 10.0, drawTextRadius = 0.5, hideLabel = false
    },
--#endregion

--#region -------------------------------------------------- GunShop

    ['Gangs01'] = {
        coords = {
            vec(-1345.02, 140.89, 56.25),  -- base gang
            vec(-1309.78, -389.37, 36.7),  -- gunZone_1
            vec(5590.76, -5206.09, 13.99),  -- gunZoneJ_32
        },
        owner = {
            'steam:1100001470d5f3a',
        },
        payment = { type = 2, value = gunShopName.gunshop1, value2 = gunShopName.gunshop1 }, db = gunShopName.gunshop1, access = { [gunShopName.gunshop1] = true }, label = gunShopName.gunshop1,
        ownerCheck = { radius = 15, count = 1, gang = gunShopName.gunshop1, grade = 16, gradeType = 3 },
        color = { R = 11, G = 55, B = 123, A = 255 }, type = 13, radius = 0.5, range = 2.0, drawDistance = 10.0, drawTextRadius = 0.5, hideLabel = false, items = itemGang
    },

    ['Gangs02'] = {
        coords = {
            vec(-625.52, -1632.03, 33.05),  -- base gang
            vec(16.83, -1110.56, 29.8),  -- gunZone_2
            vec(4899.1, -5735.11, 26.35),  -- gunZoneJ_22
        },
        owner = {
            'steam:110000146c92c15',
            'steam:110000156461242',
        },
        payment = { type = 2, value = gunShopName.gunshop2, value2 = gunShopName.gunshop2 }, db = gunShopName.gunshop2, access = { [gunShopName.gunshop2] = true }, label = gunShopName.gunshop2,
        ownerCheck = { radius = 15, count = 1, gang = gunShopName.gunshop2, grade = 15, gradeType = 3 },
        color = { R = 11, G = 55, B = 123, A = 255 }, type = 13, radius = 0.5, range = 2.0, drawDistance = 10.0, drawTextRadius = 0.5, hideLabel = false, items = itemGang,
    },

    ['Gangs03'] = {
        coords = {
            vec(-1556.08, 18.21, 58.78),  -- base gang
            vec(248.79, -44.73, 69.94),  -- gunZone_3
            vec(4897.8, -5739.11, 26.35),  -- gunZoneJ_21
        },
        owner = {
            'steam:11000016d2d0627',
            'steam:11000016adb7054',
            'steam:11000015f9fc3ff',
        },
        payment = { type = 2, value = gunShopName.gunshop3, value2 = gunShopName.gunshop3 }, db = gunShopName.gunshop3, access = { [gunShopName.gunshop3] = true }, label = gunShopName.gunshop3,
        ownerCheck = { radius = 15, count = 1, gang = gunShopName.gunshop3, grade = 12, gradeType = 3 },
        color = { R = 11, G = 55, B = 123, A = 255 }, type = 13, radius = 0.5, range = 2.0, drawDistance = 10.0, drawTextRadius = 0.5, hideLabel = false, items = itemGang,
    },

    ['Gangs04'] = {
        coords = {
            vec(1224.11, -424.73, 67.76),  -- base gang
            vec(-665.97, -940.15, 21.83),  -- gunZone_4
            vec(5494.14, -5841.39, 19.09),  -- gunZoneJ_42
        },
        owner = {
            'steam:11000016cd741e1',
            'steam:11000014295b78c',
            'steam:11000014295b78c',
        },
        payment = { type = 2, value = gunShopName.gunshop4, value2 = gunShopName.gunshop4 }, db = gunShopName.gunshop4, access = { [gunShopName.gunshop4] = true }, label = gunShopName.gunshop4,
        ownerCheck = { radius = 15, count = 1, gang = gunShopName.gunshop4, grade = 12, gradeType = 3 },
        color = { R = 11, G = 55, B = 123, A = 255 }, type = 13, radius = 0.5, range = 2.0, drawDistance = 10.0, drawTextRadius = 0.5, hideLabel = false, items = itemGang,
    },

    ['Gangs05'] = {
        coords = {
            vec(-859.11, -2755.13, 13.95),  -- base gang
            vec(846.15, -1028.59, 28.19),  -- gunZone_5
            vec(3898.03, -4710.65, 4.76),  -- gunZoneJ_11
        },
        owner = {
            'steam:11000014af80b34',
            'steam:11000013e85f169',
            'steam:11000012ffb3c11',
        },
        payment = { type = 2, value = gunShopName.gunshop5, value2 = gunShopName.gunshop5 }, db = gunShopName.gunshop5, access = { [gunShopName.gunshop5] = true }, label = gunShopName.gunshop5,
        ownerCheck = { radius = 15, count = 1, gang = gunShopName.gunshop5, grade = 18, gradeType = 3 },
        color = { R = 11, G = 55, B = 123, A = 255 }, type = 13, radius = 0.5, range = 2.0, drawDistance = 10.0, drawTextRadius = 0.5, hideLabel = false, items = itemGang,
    },

    ['Gangs06'] = {
        coords = {
            vec(-451.07, -1675.66, 19.03),  -- base gang
            vec(1694.64, 3753.67, 34.71),  -- gunZone_6
            vec(3896.16, -4707.1, 4.48),  -- gunZoneJ_12
        },
        owner = {
            'steam:11000013ff07f16',
            'steam:11000016d2a3518',
            'steam:11000016ebfc391',
        },
        payment = { type = 2, value = gunShopName.gunshop6, value2 = gunShopName.gunshop6 }, db = gunShopName.gunshop6, access = { [gunShopName.gunshop6] = true }, label = gunShopName.gunshop6,
        -- ownerCheck = { radius = 15, count = 1, gang = gunShopName.gunshop6, grade = 0, gradeType = 3 },
        color = { R = 11, G = 55, B = 123, A = 255 }, type = 13, radius = 0.5, range = 2.0, drawDistance = 10.0, drawTextRadius = 0.5, hideLabel = false, items = itemGang,
    },

    ['Gangs07'] = {
        coords = {
            vec(-1142.39, -2098.68, 9.52),  -- base gang
            vec(-329.49, 6077.58, 31.45),  -- gunZone_7
            vec(5593.26, -5209.61, 14.27),  -- gunZoneJ_31
        },
        owner = {
            'steam:2573c5cdbf9d4a0',
            'steam:110000147903cfa',
            'steam:2df1f6e64da2129',
        },
        payment = { type = 1, value = gunShopName.gunshop7, value2 = gunShopName.gunshop7 }, db = gunShopName.gunshop7, access = { [gunShopName.gunshop7] = true }, label = gunShopName.gunshop7,
        ownerCheck = { radius = 15, count = 1, gang = gunShopName.gunshop7, grade = 15, gradeType = 3 },
        color = { R = 11, G = 55, B = 123, A = 255 }, type = 13, radius = 0.5, range = 2.0, drawDistance = 10.0, drawTextRadius = 0.5, hideLabel = false, items = itemGang,
    },

    ['Gangs08'] = {
        coords = {
            vec(-98.71, -1821.62, 26.91),  -- base gang
            vec(813.93, -2152.4, 29.62),  -- gunZone_8
            vec(5495.42, -5845.41, 19.13),  -- gunZoneJ_41
        },
        owner = {
            'steam:11000015e87aad6',
            'steam:11000016e2a1c37',
            'steam:1100001702ec333',
        },
        payment = { type = 2, value = gunShopName.gunshop8, value2 = gunShopName.gunshop8 }, db = gunShopName.gunshop8, access = { [gunShopName.gunshop8] = true }, label = gunShopName.gunshop8,
        ownerCheck = { radius = 15, count = 1, gang = gunShopName.gunshop8, grade = 14, gradeType = 3 },
        color = { R = 11, G = 55, B = 123, A = 255 }, type = 13, radius = 0.5, range = 2.0, drawDistance = 10.0, drawTextRadius = 0.5, hideLabel = false, items = itemGang,
    },

--#endregion

--#region -------------------------------------------------- Caffe

    ['cafe01'] = {
        coords = {
            vec(-334.25, -243.16, 34.45),  -- caffe 1
            vec(3904.17, -4718.54, 4.44),  -- caffeZoneJ_12
            vec(-1621.56, -2746.44, 13.94),  -- caffeZoneA_3
        },
        owner = {
            'steam:11000016d2d0627',
            'steam:11000016adb7054',
            'steam:11000015f9fc3ff',
        },
        payment = { type = 2, value = caffeName.caffe1 }, db = caffeDBName.caffe1, access = { [caffeName.caffe1] = true }, label = caffeName.caffe1,
        ownerCheck = { radius = 20, count = 1, gang = caffeName.caffe1, grade = 10, gradeType = 3 },
        color = { R = 241, G = 101, B = 34, A = 255 }, type = 12, radius = 0.5, range = 1.5, drawDistance = 10.0, drawTextRadius = 0.5, hideLabel = false, disableBlack = true, items =  itemCoffee,
    },

    ['cafe02'] = {
        coords = {
            vec(-228.5, -785.14, 34.09),  -- caffe 2
            vec(3899.67, -4715.08, 4.77),  -- caffeZoneJ_11
        },
        owner = {
            'steam:11000015ae3affc',
            'steam:1100001488f6ac0',
            'steam:22c1128075ebf73',
        },
        payment = { type = 2, value = caffeName.caffe2 }, db = caffeDBName.caffe2, access = { [caffeName.caffe2] = true }, label = caffeName.caffe2,
        ownerCheck = { radius = 20, count = 1, gang = caffeName.caffe2, grade = 12, gradeType = 3 },
        color = { R = 241, G = 101, B = 34, A = 255 }, type = 12, radius = 0.5, range = 1.5, drawDistance = 10.0, drawTextRadius = 0.5, hideLabel = false, disableBlack = true, items =  itemCoffee,
    },

    ['cafe03'] = {
        coords = {
            vec(-1386.65, -589.67, 30.32),  -- caffe 3
            vec(5018.02, -5721.05, 17.71),  -- caffeZoneJ_51
            vec(-1615.9, -2737.09, 13.94),  -- caffeZoneA_1
        },
        owner = {
            'steam:110000166aa8e8d',
            'steam:1100001729e26a2',
            'steam:1100001729a15b3',
        },
        payment = { type = 1, value = caffeName.caffe3 }, db = caffeDBName.caffe3, access = { [caffeName.caffe3] = true }, label = caffeName.caffe3,
        ownerCheck = { radius = 20, count = 1, gang = caffeName.caffe3, grade = 11, gradeType = 3 },
        color = { R = 241, G = 101, B = 34, A = 255 }, type = 12, radius = 0.5, range = 1.5, drawDistance = 10.0, drawTextRadius = 0.5, hideLabel = false, disableBlack = true, items =  itemCoffee,
    },

    ['cafe04'] = {
        coords = {
            vec(345.94, -882.99, 29.34),  -- caffe 4
            vec(4901.11, -5730.67, 26.35),  -- caffeZoneJ_22
            vec(-1618.76, -2741.62, 13.94),  -- caffeZoneA_2
        },
        owner = {
            'steam:1100001641df769',
            'steam:11000012eae58b5',
            'steam:11000014a90cdfa',
        },
        payment = { type = 2, value = caffeName.caffe4 }, db = caffeDBName.caffe4, access = { [caffeName.caffe4] = true }, label = caffeName.caffe4,
        ownerCheck = { radius = 20, count = 1, gang = caffeName.caffe4, grade = 16, gradeType = 3 },
        color = { R = 241, G = 101, B = 34, A = 255 }, type = 12, radius = 0.5, range = 1.5, drawDistance = 10.0, drawTextRadius = 0.5, hideLabel = false, disableBlack = true, items =  itemCoffee,
    },

    ['cafe05'] = {
        coords = {
            vec(-131.08, 6185.99, 32.38),  -- caffe 5
            vec(5597.22, -5216.53, 14.33),  -- caffeZoneJ_31
            vec(-1624.34, -2751.49, 13.94),  -- caffeZoneA_4
        },
        owner = {
            'steam:11000015c32c49a',
            'steam:110000147903cfa',
            'steam:2df1f6e64da2129',
        },
        payment = { type = 2, value = caffeName.caffe5 }, db = caffeDBName.caffe5, access = { [caffeName.caffe5] = true }, label = caffeName.caffe5,
        ownerCheck = { radius = 20, count = 1, gang = caffeName.caffe5, grade = 15, gradeType = 3 },
        color = { R = 241, G = 101, B = 34, A = 255 }, type = 12, radius = 0.5, range = 1.5, drawDistance = 10.0, drawTextRadius = 0.5, hideLabel = false, disableBlack = true, items =  itemCoffee,
    },

    ['cafe06'] = {
        coords = {
            vec(746.5, -719.36, 28.07),  -- caffe 6
            vec(5496.0, -5853.74, 19.53),  -- caffeZoneJ_41
        },
        owner = {
            'steam:110000154129240',
            'steam:11000016a6909ef',
        },
        payment = { type = 2, value = caffeName.caffe6 }, db = caffeDBName.caffe6, access = { [caffeName.caffe6] = true }, label = caffeName.caffe6,
        ownerCheck = { radius = 20, count = 1, gang = caffeName.caffe6, grade = 12, gradeType = 3 },
        color = { R = 241, G = 101, B = 34, A = 255 }, type = 12, radius = 0.5, range = 1.5, drawDistance = 10.0, drawTextRadius = 0.5, hideLabel = false, disableBlack = true, items =  itemCoffee,
    },

    ['cafe07'] = {
        coords = {
            vec(75.21, -1582.05, 29.6),  -- caffe 7
            vec(4894.09, -5746.35, 26.35),  -- caffeZoneJ_21
        },
        owner = {
            'steam:11000016bbcdee8',
            'steam:11000016f66f0cf',
            'steam:1100001716e0496',
        },
        payment = { type = 2, value = caffeName.caffe7 }, db = caffeDBName.caffe7, access = { [caffeName.caffe7] = true }, label = caffeName.caffe7,
        ownerCheck = { radius = 20, count = 1, gang = caffeName.caffe7, grade = 9, gradeType = 3 },
        color = { R = 241, G = 101, B = 34, A = 255 }, type = 12, radius = 0.5, range = 1.5, drawDistance = 10.0, drawTextRadius = 0.5, hideLabel = false, disableBlack = true, items =  itemCoffee,
    },

--#endregion

--#region -------------------------------------------------- Ahangari

    ['ahangari1'] = {
        coords = { vec(-1157.07, -2001.43, 13.18) },
        owner = {
            'steam:11000013e89f416',
        },
        payment = { type = 2, value = ahangariName.ah1 }, db = ahangariDBName.ah1, access = { [ahangariName.ah1] = true }, label = ahangariName.ah1,
        -- ownerCheck = { radius = 20, count = 1, gang = ahangariName.ah1, grade = 0, gradeType = 3 },
        color = { R = 29, G = 100, B = 153, A = 255 }, type = 14, radius = 0.5, range = 1.5, drawDistance = 10.0, drawTextRadius = 0.5, hideLabel = false, disableBlack = true, items =  itemAhangari,
    },

    ['ahangari2'] = {
        coords = { vec(737.29, -1081.35, 22.17) },
        owner = {
            'steam:11000015e87aad6',
            'steam:2259bd31ad1a85f',
            'steam:1100001315aa746',
        },
        payment = { type = 2, value = ahangariName.ah2 }, db = ahangariDBName.ah2, access = { [ahangariName.ah2] = true }, label = ahangariName.ah2,
        ownerCheck = { radius = 20, count = 1, gang = ahangariName.ah2, grade = 14, gradeType = 3 },
        color = { R = 29, G = 100, B = 153, A = 255 }, type = 14, radius = 0.5, range = 1.5, drawDistance = 10.0, drawTextRadius = 0.5, hideLabel = false, disableBlack = true, items =  itemAhangari,
    },

    ['ahangari3'] = {
        coords = { vec(-200.65, -1318.24, 31.09) },
        owner = {
            'steam:110000146ef4c91',
            'steam:11000015e75cac7',
            'steam:11000014046d07d',
        },
        payment = { type = 2, value = ahangariName.ah3 }, db = ahangariDBName.ah3, access = { [ahangariName.ah3] = true }, label = ahangariName.ah3,
        ownerCheck = { radius = 20, count = 1, gang = ahangariName.ah3, grade = 9, gradeType = 3 },
        color = { R = 29, G = 100, B = 153, A = 255 }, type = 14, radius = 0.5, range = 1.5, drawDistance = 10.0, drawTextRadius = 0.5, hideLabel = false, disableBlack = true, items =  itemAhangari,
    },

    ['ahangari4'] = {
        coords = { vec(1154.3, -783.45, 57.53) },
        owner = {
            'steam:11000016e69c54c',
            'steam:11000015ca72e79',
            'steam:110000172d11369',
        },
        payment = { type = 2, value = ahangariName.ah4 }, db = ahangariDBName.ah4, access = { [ahangariName.ah4] = true }, label = ahangariName.ah4,
        ownerCheck = { radius = 20, count = 1, gang = ahangariName.ah4, grade = 11, gradeType = 3 },
        color = { R = 29, G = 100, B = 153, A = 255 }, type = 14, radius = 0.5, range = 1.5, drawDistance = 10.0, drawTextRadius = 0.5, hideLabel = false, disableBlack = true, items =  itemAhangari,
    },

    ['ahangari5'] = {
        coords = { vec(137.48, -1091.46, 29.19) },
        owner = {
            'steam:11000014985b5dc',
            'steam:1100001452c8d47',
            'steam:11000017204f371',
        },
        payment = { type = 2, value = ahangariName.ah5 }, db = ahangariDBName.ah5, access = { [ahangariName.ah5] = true }, label = ahangariName.ah5,
        ownerCheck = { radius = 20, count = 1, gang = ahangariName.ah5, grade = 11, gradeType = 3 },
        color = { R = 29, G = 100, B = 153, A = 255 }, type = 14, radius = 0.5, range = 1.5, drawDistance = 10.0, drawTextRadius = 0.5, hideLabel = false, disableBlack = true, items =  itemAhangari,
    },

    ['ahangari6'] = {
        coords = { vec(-345.01, -130.91, 39.01) },
        owner = {
            'steam:11000016d2d0627',
            'steam:11000016adb7054',
            'steam:11000015f9fc3ff',
        },
        payment = { type = 2, value = ahangariName.ah6 }, db = ahangariDBName.ah6, access = { [ahangariName.ah6] = true }, label = ahangariName.ah6,
        ownerCheck = { radius = 20, count = 1, gang = ahangariName.ah6, grade = 10, gradeType = 3 },
        color = { R = 29, G = 100, B = 153, A = 255 }, type = 14, radius = 0.5, range = 1.5, drawDistance = 10.0, drawTextRadius = 0.5, hideLabel = false, disableBlack = true, items =  itemAhangari,
    },

    ['ahangari7'] = {
        coords = { vec(473.4, -1312.85, 29.21) },
        owner = {
            'steam:11000014af80b34',
            'steam:11000016dd277e0',
        },
        payment = { type = 2, value = ahangariName.ah7 }, db = ahangariDBName.ah7, access = { [ahangariName.ah7] = true }, label = ahangariName.ah7,
        ownerCheck = { radius = 20, count = 1, gang = ahangariName.ah7, grade = 18, gradeType = 3 },
        color = { R = 29, G = 100, B = 153, A = 255 }, type = 14, radius = 0.5, range = 1.5, drawDistance = 10.0, drawTextRadius = 0.5, hideLabel = false, disableBlack = true, items =  itemAhangari,
    },

--#endregion
}

translate = {
    -- Graphical interface translations
    TR_TITLE            = "Shop",
    TR_SUBTITLE         = "Put or buy something for sale",
    TR_OPTIONS_TITLE    = "OPTIONS A.H",
    TR_OPTIONS_1        = "Products :",
    TR_OPTIONS_2        = "My Products:",
    TR_ANNOUNCES        = "products",
    TR_SEARCH           = "Search for a product",
    TR_BY_OWNER         = "By:",
    TR_SIMBOL_MONEY     = "$ ",
    TR_WEIGHT           = "Weight:",
    TR_DISPONIBLE       = "Available:",
    TR_UNITS            = "pcs",
    TR_TOTAL_PRICE      = "Total price:",
    TR_BUTTON_BUY       = "Buy",
    TR_BUTTON_ANNOUNCE  = "Add",
    TR_BUTTON_REMOVE    = "Remove",
    TR_BUTTON_CANCEL    = "Cancel",
    TR_MODAL_TITLE      = "Add Product",
    TR_MODAL_ITEM       = "Item",
    TR_MODAL_AMOUNT     = "Amount:",
    TR_MODAL_PRICE      = "Price per unit",
    TR_MODAL_ANONYMOUS  = "Black money",

    -- Notification translations
    TR_DONT_FULL        = "Your inventory is too full.",
    TR_DONT_MONEY       = "You don't have enough money.",
    TR_SUCESS           = "Purchase successful",
    TR_REMOVED_ITEM     = "Item successfully removed",
    TR_DONT_AMOUNT      = "There aren't that many items for sale.",
    TR_NOT_FOUND        = "Item already sold or not found.",
    TR_ADVERTISE_ITEM   = "Successfully advertised item.",
    TR_DONT_AMOUNT2     = "You don't have that amount.",
    TR_DONT_SELF        = "You cannot buy your own item.",

    -- Translations of the public Webhook.
    TR_WEBHOOK_OWNER    = "Announced by: ",
    TR_WEBHOOK_AMOUNT   = "Available amount: ",
    TR_WEBHOOK_PRICE    = "Price per unit: ",

    -- Translations from Webhook to Log admin.
    TR_WEBHOOK_LOG_BUY          = "Purchased item",
    TR_WEBHOOK_LOG_BUY_BY       = "Purchased by: ",
    TR_WEBHOOK_LOG_BUY_AMOUNT   = "Amount : ",
    TR_WEBHOOK_LOG_BUY_PRICE    = "Price : ",
    TR_WEBHOOK_LOG_REMOVE       = "Item removed : ",
}
buyLimit = {
    -- adrenaline = 20,
    gelofen = 20,
    -- erythropoietin = 20,
    -- kit50 = 10,
    kittire = 20,
    -- lockpick = 20,
    -- jack = 20,
    -- engine1 = 20,
    -- engine2 = 20,
    -- engine3 = 20,
    -- engine4 = 20,
    -- engine5 = 20,
    -- engine6 = 20,
    -- pich = 40,
    -- vodka2 = 20,
    -- whisky2 = 20,
    -- absolut2 = 20,
    -- cider2 = 20,
    -- wine2 = 20,
    -- sake2 = 20,
    -- juice_beer = 20,
    -- juice_orange = 20,
    -- juice_grape = 20,
    -- juice_apple = 20,
    -- tbc_apple = 20,
    -- tbc_orange = 20,
    -- tbc_grape = 20,
}

--#region -------------- template
-- resturan
    -- ['resturan1000'] = {  -- Shop Share
    --     db = 'resturan1000', disableBlack = true, --eye = true, eyeRange = 1.5,
    --     coords = {

    --     },
    --     access = {
    --         ["resturan"] = true,
    --     },
    --     owner = {
    --         ["steam:11000010b5a1f6c"] = true, -- payam
    --     },
    --     label = "Restaurant Shop",
    --     payment = { -- 2 => value
    --         type = 3, value = "resturan",
    --     },
    --     items =  itemResturan,
    --     ownerCheck = {
    --         radius = 20,
    --         job = 'resturan', -- gang , job
    --         count = 1,
    --         grade = 5,
    --         -- grade2 = 3,
    --         gradeType = 2,
    --     },
    --     color = { R = 12 , G = 123 , B = 86 , A = 255 }, -- a = opasity
    --     type = 13,            -- model
    --     radius = 0.5,         -- andaze blip
    --     range = 1.0,          -- range E
    --     drawDistance = 10.0,   -- az chand metri bebine
    --     drawTextRadius = 0.5, -- range neveshtan text
    --     hideLabel = false     -- true label hide mishe
    -- },
--#endregion
