Config = Config or {}

-- ───────────── General ─────────────
Config.Key             = 38        -- E
Config.PriceMultiplier = 1.0       -- 1.0 = prices exactly as in data/clothes.lua
Config.MoneyAccount    = 'money'   -- cash account name
Config.BankAccount     = 'bank'    -- bank account name
Config.UseBankFallback = true      -- if cash is not enough, take the rest from bank
Config.OpenCooldown    = 3500      -- ms between closing and re-opening
Config.TryoutEmote     = 'adjusttie' -- emote played on "try on" (nil = disabled)
Config.WearAfterBuy    = true      -- wear what you just bought (items also go to the inventory)
Config.ClotheWeight    = 0.2       -- inventory weight of one clothing item
Config.PackWeight      = 0.5       -- inventory weight of one outfit pack
Config.MaxPackNameLen  = 30

-- Where item pictures come from (shop UI + inventory). The file path is always
--   <ImageServer>/clothes/<category>/<item_name>.png      e.g. .../clothes/tshirt/tshirt_m_12_3.png
-- Sunset's CDN (default) - NOTE: that is someone else's server, it can block or drop the images:
Config.ImageServer     = 'https://cdn.sunrp.ir'
-- To serve them from this resource instead, put the PNGs in ui/items/clothes/<category>/ and use:
-- Config.ImageServer  = 'https://cfx-nui-Unique_Clothe/ui/items'

-- Items handed to a brand-new character right after the character creator
-- (event Unique_Clothe:giveStarter). Item names look like tshirt_m_12_3. Empty = nothing.
-- Default = the cheapest basic piece of each category (valid names, edit freely).
Config.StarterClothes = {
    [0] = { 'tshirt_m_2_0', 'torso_m_0_1', 'pants_m_2_11', 'shoes_m_94_0' },
    [1] = { 'tshirt_f_0_0', 'torso_f_9_0',  'pants_f_15_0', 'shoes_f_5_0' },
}

Config.Marker = {
    Type = 27, DrawDistance = 8.0, OpenDistance = 1.3,
    Size = vector3(0.9, 0.9, 0.9), Color = { r = 102, g = 255, b = 204, a = 160 },
}
Config.Blip = {
    Shop = { sprite = 73,  colour = 53, scale = 0.7, label = 'Clothing Shop' },
    Mask = { sprite = 543, colour = 75, scale = 0.7, label = 'Mask Shop' },
}

Config.Strings = {
    help_open     = 'Press ~INPUT_CONTEXT~ to open the clothing shop',
    wait          = 'لطفا چند لحظه صبر کنید...',
    not_enough    = 'پول کافی ندارید',
    bought        = 'خرید با موفقیت انجام شد ($%s) - لباس‌ها در کیف شما هستند',
    invalid       = 'خرید نامعتبر است',
    wrong_sex     = 'این لباس برای جنسیت شما نیست',
    already_owned = 'این لباس را قبلا خریده‌اید',
    no_space      = 'ظرفیت کیف شما کافی نیست',
    slow_down     = 'لطفا کمی صبر کنید',
    give_failed   = 'خطا در تحویل لباس، پول برگشت داده شد',
}

-- Names used for items / grid cards
Config.TypeLabels = {
    tshirt = 'تی‌شرت', torso = 'لباس', pants = 'شلوار', shoes = 'کفش', mask = 'ماسک',
    bproof = 'جلیقه', chain = 'گردنبند', helmet = 'کلاه', glasses = 'عینک',
    watches = 'ساعت', bracelets = 'دستبند', bag = 'کیف', ears = 'گوشواره', arms = 'دستکش',
    decals = 'طرح',
}

-- "Take off" values per sex (used by the shop toggle buttons AND the wardrobe)
Config.Defaults = {
    [0] = {
        tshirt = { tshirt_1 = 15, tshirt_2 = 0 }, torso = { torso_1 = 15, torso_2 = 0 },
        pants = { pants_1 = 61, pants_2 = 4 }, shoes = { shoes_1 = 34, shoes_2 = 0 },
        mask = { mask_1 = 0, mask_2 = 0 }, bproof = { bproof_1 = 0, bproof_2 = 0 },
        chain = { chain_1 = 0, chain_2 = 0 }, helmet = { helmet_1 = -1, helmet_2 = -1 },
        glasses = { glasses_1 = -1, glasses_2 = -1 }, watches = { watches_1 = -1, watches_2 = -1 },
        bracelets = { bracelets_1 = -1, bracelets_2 = 0 }, bag = { bags_1 = 0, bags_2 = 0 },
        ears = { ears_1 = -1, ears_2 = -1 }, arms = { arms = 15, arms_2 = 0 },
        decals = { decals_1 = 0, decals_2 = 0 },
    },
    [1] = {
        tshirt = { tshirt_1 = 14, tshirt_2 = 0 }, torso = { torso_1 = 15, torso_2 = 0 },
        pants = { pants_1 = 15, pants_2 = 0 }, shoes = { shoes_1 = 35, shoes_2 = 0 },
        mask = { mask_1 = 0, mask_2 = 0 }, bproof = { bproof_1 = 0, bproof_2 = 0 },
        chain = { chain_1 = 0, chain_2 = 0 }, helmet = { helmet_1 = -1, helmet_2 = -1 },
        glasses = { glasses_1 = -1, glasses_2 = -1 }, watches = { watches_1 = -1, watches_2 = -1 },
        bracelets = { bracelets_1 = -1, bracelets_2 = 0 }, bag = { bags_1 = 0, bags_2 = 0 },
        ears = { ears_1 = -1, ears_2 = -1 }, arms = { arms = 15, arms_2 = 0 },
        decals = { decals_1 = 0, decals_2 = 0 },
    },
}

-- Shops. Add/remove freely.
-- categories = tabs shown in that shop. mask = true -> mask blip/label.
Config.Shops = {
    { -- 1: Javaheri (Barbari)
        blip = vector3(72.254, -1399.102, 28.376),
        categories = { 'arms', 'tshirt', 'torso', 'shoes', 'pants', 'glasses', 'helmet', 'bag', 'chain', 'watches', 'ears', 'bracelets' },
        points = {
            vector3(72.254, -1399.102, 28.376),
            vector3(75.36, -1391.29, 28.38),
            vector3(81.43, -1397.26, 28.38),
            vector3(79.82, -1389.4, 28.38),
        },
    },
    { -- 2: Javaheri (Shik)
        blip = vector3(-703.776, -152.258, 36.415),
        categories = { 'arms', 'tshirt', 'torso', 'shoes', 'pants', 'glasses', 'helmet', 'bag', 'chain', 'watches', 'ears', 'bracelets' },
        points = {
            vector3(-703.776, -152.258, 36.415),
            vector3(-710.03, -152.77, 36.42),
            vector3(-715.54, -146.81, 36.42),
            vector3(-705.95, -159.12, 36.42),
        },
    },
    { -- 3: Khune FBI
        blip = vector3(-167.863, -298.969, 38.733),
        categories = { 'arms', 'tshirt', 'torso', 'shoes', 'pants', 'glasses', 'helmet', 'bag', 'chain', 'watches', 'ears', 'bracelets' },
        points = {
            vector3(-167.863, -298.969, 38.733),
            vector3(-163.54, -303.36, 38.73),
            vector3(-164.76, -311.28, 38.73),
            vector3(-161.35, -295.62, 38.73),
        },
    },
    { -- 4: PD
        blip = vector3(428.694, -800.106, 28.491),
        categories = { 'arms', 'tshirt', 'torso', 'shoes', 'pants', 'glasses', 'helmet', 'bag', 'chain', 'watches', 'ears', 'bracelets' },
        points = {
            vector3(428.694, -800.106, 28.491),
            vector3(425.39, -807.2, 28.49),
            vector3(419.74, -801.97, 28.49),
            vector3(420.88, -809.73, 28.49),
        },
    },
    { -- 5: Weazel
        blip = vector3(-829.413, -1073.71, 10.328),
        categories = { 'arms', 'tshirt', 'torso', 'shoes', 'pants', 'glasses', 'helmet', 'bag', 'chain', 'watches', 'ears', 'bracelets' },
        points = {
            vector3(-829.413, -1073.71, 10.328),
            vector3(-821.74, -1073.35, 10.33),
            vector3(-823.08, -1080.62, 10.33),
            vector3(-817.31, -1075.54, 10.33),
        },
    },
    { -- 6: Chape Bime
        blip = vector3(-1447.797, -242.461, 48.82),
        categories = { 'arms', 'tshirt', 'torso', 'shoes', 'pants', 'glasses', 'helmet', 'bag', 'chain', 'watches', 'ears', 'bracelets' },
        points = {
            vector3(-1447.797, -242.461, 48.82),
            vector3(-1450.2, -237.2, 48.81),
            vector3(-1446.37, -230.17, 48.81),
            vector3(-1455.05, -243.38, 48.81),
        },
    },
    { -- 7: Bank Sheriff
        blip = vector3(11.632, 6514.224, 30.877),
        categories = { 'arms', 'tshirt', 'torso', 'shoes', 'pants', 'glasses', 'helmet', 'bag', 'chain', 'watches', 'ears', 'bracelets' },
        points = {
            vector3(11.632, 6514.224, 30.877),
            vector3(4.21, 6512, 30.88),
            vector3(4.02, 6519.5, 30.88),
            vector3(-0.4, 6513.44, 30.88),
        },
    },
    { -- 8: Minibank
        blip = vector3(123.646, -219.44, 53.557),
        categories = { 'arms', 'tshirt', 'torso', 'shoes', 'pants', 'glasses', 'helmet', 'bag', 'chain', 'watches', 'ears', 'bracelets' },
        points = {
            vector3(123.646, -219.44, 53.557),
            vector3(123.45, -228.09, 53.56),
            vector3(123.63, -209.22, 53.56),
            vector3(131.33, -211.77, 53.56),
        },
    },
    { -- 9: Coca
        blip = vector3(1696.291, 4829.312, 41.063),
        categories = { 'arms', 'tshirt', 'torso', 'shoes', 'pants', 'glasses', 'helmet', 'bag', 'chain', 'watches', 'ears', 'bracelets' },
        points = {
            vector3(1696.291, 4829.312, 41.063),
            vector3(1693.95, 4822.23, 41.06),
            vector3(1687.75, 4826.25, 41.06),
            vector3(1689.54, 4818.79, 41.06),
        },
    },
    { -- 10: AH Mechanicki Bala
        blip = vector3(618.093, 2759.629, 41.088),
        categories = { 'arms', 'tshirt', 'torso', 'shoes', 'pants', 'glasses', 'helmet', 'bag', 'chain', 'watches', 'ears', 'bracelets' },
        points = {
            vector3(618.093, 2759.629, 41.088),
            vector3(614.32, 2767.44, 41.09),
            vector3(613.93, 2749.81, 41.09),
            vector3(622.33, 2750.04, 41.09),
        },
    },
    { -- 11: Mechanicki Bala
        blip = vector3(1190.55, 2713.441, 37.222),
        categories = { 'arms', 'tshirt', 'torso', 'shoes', 'pants', 'glasses', 'helmet', 'bag', 'chain', 'watches', 'ears', 'bracelets' },
        points = {
            vector3(1190.55, 2713.441, 37.222),
            vector3(1197.39, 2710.24, 37.22),
            vector3(1192.47, 2704.62, 37.22),
            vector3(1200.11, 2705.56, 37.22),
        },
    },
    { -- 12: Maze Bank
        blip = vector3(-1193.429, -772.262, 16.324),
        categories = { 'arms', 'tshirt', 'torso', 'shoes', 'pants', 'glasses', 'helmet', 'bag', 'chain', 'watches', 'ears', 'bracelets' },
        points = {
            vector3(-1193.429, -772.262, 16.324),
            vector3(-1189.21, -765.94, 16.32),
            vector3(-1204.58, -775, 16.32),
            vector3(-1199.64, -781.73, 16.33),
        },
    },
    { -- 13: Bank Sahel
        blip = vector3(-3172.496, 1048.133, 19.863),
        categories = { 'arms', 'tshirt', 'torso', 'shoes', 'pants', 'glasses', 'helmet', 'bag', 'chain', 'watches', 'ears', 'bracelets' },
        points = {
            vector3(-3172.496, 1048.133, 19.863),
            vector3(-3172.87, 1039.98, 19.86),
            vector3(-3164.38, 1055.27, 19.86),
            vector3(-3171.52, 1058.72, 19.86),
        },
    },
    { -- 14: Roodkhune Khashkhash
        blip = vector3(-1108.441, 2708.923, 18.107),
        categories = { 'arms', 'tshirt', 'torso', 'shoes', 'pants', 'glasses', 'helmet', 'bag', 'chain', 'watches', 'ears', 'bracelets' },
        points = {
            vector3(-1108.441, 2708.923, 18.107),
            vector3(-1100.84, 2710.89, 18.11),
            vector3(-1100.81, 2703.55, 18.11),
            vector3(-1095.79, 2709.41, 18.11),
        },
    },
    { -- 15: Mask Foroushi
        blip = vector3(-1338.13, -1278.21, 3.87),
        mask = true,
        categories = { 'mask' },
        points = {
            vector3(-1338.13, -1278.21, 3.87),
        },
    },
}
