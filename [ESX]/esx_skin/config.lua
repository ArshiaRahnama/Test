Config = {}
Config.Locale = 'en'

-- Skin menu theme (default red). Can also be pushed live via TriggerEvent('unique_menu:settings', {...}).
Config.MenuColors = { primary = '#b91c1c', secondary = '#ef4444' }

Config.whitelist = {
    jobs = {
        {name = "torso_1", value = 31},
        {name = "torso_1", value = 40},


    },

    admins = {
        {name = "torso_1", value = 44},
    },
}

-- Values hidden in SHOP mode only (esx_skin:openRestrictedMenu with a 4th arg `shop = true`).
-- Structure: [sex] = { [component] = { [value] = true } }   (0 = male, 1 = female)
-- NOTE: these ids were made for a different clothing pack
-- (e.g. PD uniforms, oxygen mask). Check/replace them for your own drawables.
Config.ShopBlacklist = {
    -- MALE
      [0] = {
    
      -- Lebas Zir 1
        ["tshirt_1"] = { 
          [123] = true, -- mask oxygen
          [184] = true, -- pd clothe
          [185] = true, -- pd clothe
          [188] = true, -- pd clothe
          [189] = true, -- pd clothe
          [190] = true, -- pd clothe
          [191] = true, -- pd clothe
          [192] = true, -- pd clothe
          [193] = true, -- pd clothe
          [194] = true, -- pd clothe
          [195] = true, -- pd clothe
          [196] = true, -- pd clothe
          [197] = true, -- pd clothe
          [198] = true, -- pd clothe
          [199] = true, -- pd clothe
          [200] = true, -- pd clothe
          [201] = true, -- pd clothe
          [202] = true, -- pd clothe
          [203] = true, -- pd clothe
          [204] = true, -- pd clothe
          [205] = true, -- pd clothe
          [206] = true, -- pd clothe
          [207] = true, -- pd clothe
          [208] = true, -- pd clothe
          [209] = true, -- pd clothe
          [210] = true, -- pd clothe
          [211] = true, -- pd clothe
          [212] = true, -- pd clothe
          [213] = true, -- pd clothe
          [214] = true, -- pd clothe
          [215] = true, -- pd clothe
          [216] = true, -- pd clothe
          [217] = true, -- pd clothe
          [218] = true, -- pd clothe
          [219] = true, -- pd clothe
          [220] = true, -- pd clothe
          [221] = true, -- pd clothe
          [222] = true, -- pd clothe
          [223] = true, -- pd clothe
          [224] = true, -- pd clothe
          [225] = true, -- pd clothe
          [226] = true, -- pd clothe
        },
    
      -- Lebas Ro 1
        ["torso_1"] = {
            [421] = true, -- PD Clothes
            [422] = true, -- PD Clothes
            [423] = true, -- PD Clothes
            [424] = true, -- PD Clothes
            [425] = true, -- PD Clothes
            [426] = true, -- PD Clothes
            [427] = true, -- PD Clothes
            [428] = true, -- PD Clothes
            [429] = true, -- PD Clothes
            [430] = true, -- PD Clothes
            [431] = true, -- PD Clothes
            [432] = true, -- PD Clothes
            [433] = true, -- PD Clothes
            [434] = true, -- PD Clothes
            [435] = true, -- PD Clothes
            [436] = true, -- PD Clothes
            [437] = true, -- PD Clothes
            [438] = true, -- PD Clothes
            [439] = true, -- PD Clothes
            [440] = true, -- PD Clothes
            [441] = true, -- PD Clothes
            [442] = true, -- PD Clothes
            [443] = true, -- PD Clothes
            [444] = true, -- PD Clothes
            [445] = true, -- PD Clothes
            [446] = true, -- ADMINS
            [447] = true, -- ya hossein
            [449] = true, -- PD Clothes
            [450] = true, -- PD Clothes
            [451] = true, -- PD Clothes
            [452] = true, -- PD Clothes
            [453] = true, -- PD Clothes
            [454] = true, -- PD Clothes
            [455] = true, -- PD Clothes
            [456] = true, -- PD Clothes
            [457] = true, -- PD Clothes
            [458] = true, -- PD Clothes
            [459] = true, -- PD Clothes
            [460] = true, -- PD Clothes
        },
    
      -- Shalvar 1
        ["pants_1"] = {
            [1000] = true, -- adam fazayi
        },
    
      -- Kolah 1
        ["helmet_1"] = {
            [116] = true, -- PD
            [117] = true, -- PD
            [118] = true, -- PD
            [119] = true, -- PD
            [122] = true, -- MD
        },
    
      -- Gardan 1  
        ["chain_1"] = {
          [125] = true, -- IAA
          [126] = true, -- MD
          [127] = true, -- MD
          [128] = true, -- IAA
          [148] = true, -- PD
          [196] = true, -- PD
          [197] = true, -- PD
          [198] = true, -- PD
          [199] = true, -- PD
          [200] = true, -- PD
          [201] = true, -- PD
          [202] = true, -- PD
          [203] = true, -- PD
          [204] = true, -- PD
          [205] = true, -- PD
          [206] = true, -- PD
          [207] = true, -- PD
          [208] = true, -- PD
          [209] = true, -- PD
          [210] = true, -- PD
          [211] = true, -- PD
          [212] = true, -- PD
          [213] = true, -- PD
          [214] = true, -- PD
          [215] = true, -- PD
          [216] = true, -- PD
          [217] = true, -- PD
          [218] = true, -- PD
          [219] = true, -- PD
          [220] = true, -- PD
          [221] = true, -- PD
          [222] = true, -- PD
          [223] = true, -- PD
          [224] = true, -- PD
          [225] = true, -- PD
          [226] = true, -- PD
          [227] = true, -- PD
          [228] = true, -- PD
          [229] = true, -- PD
          [230] = true, -- PD
          [231] = true, -- PD
          [232] = true, -- PD
          [233] = true, -- PD
        },
    
      -- Kif 1
        ["bags_1"] = {
          [1000] = true, -- kiff police
        },
      
      -- Khalkoobi 1
      ["decals_1"] = {
        [70] = true, -- noose
        [72] = true, -- police
        [77] = true, -- police
        [120] = true, -- police
        [121] = true, -- police
        [122] = true, -- police
        [123] = true, -- police
        [124] = true, -- police
        [125] = true, -- police
        [126] = true, -- police
        [127] = true, -- police
        [128] = true, -- police
        [129] = true, -- police
        [130] = true, -- police
        [131] = true, -- police
        [132] = true, -- police
        [133] = true, -- police
        [134] = true, -- police
        [135] = true, -- police
        [136] = true, -- police
        [137] = true, -- police
        [138] = true, -- police
        [139] = true, -- police
        [140] = true, -- police
        [141] = true, -- police
        [142] = true, -- police
        [143] = true, -- police
        [144] = true, -- police
        [145] = true, -- police
        [146] = true, -- police
        [147] = true, -- police
        [148] = true, -- police
        [149] = true, -- police
        [150] = true, -- police
        [151] = true, -- police
        [152] = true, -- police
        [153] = true, -- police
        [154] = true, -- police
        [155] = true, -- police
        [156] = true, -- police
        [157] = true, -- police
        [158] = true, -- police
        [159] = true, -- police
        [160] = true, -- police
        [161] = true, -- police
        [162] = true, -- police
        [163] = true, -- police
        [164] = true, -- police
        [165] = true, -- police
        [166] = true, -- police
        [167] = true, -- police
        [168] = true, -- police
        [169] = true, -- police
        [170] = true, -- police
        [171] = true, -- police
        [172] = true, -- police
        [173] = true, -- police
        [174] = true, -- police
        [175] = true, -- police
        [176] = true, -- police
      },
    
      },
    
    -- Female
      [1] = { 
    
      -- Lebas Zir 1
        ["tshirt_1"] = { 
          [35] = true, -- tazer
          [105] = true, -- bomb
          [105] = true, -- tazer
          [153] = true, -- oxygen
          [159] = true, -- pd
          [160] = true, -- pd
          [189] = true, -- pd
          [190] = true, -- pd
          [222] = true, -- pd
        },
    
      -- Lebas Ro 1
        ["torso_1"] = {
            [1000] = true, -- PD Clothes
        },
    
      -- Shalvar 1
        ["pants_1"] = {
            [1000] = true, -- adam fazayi
        },
    
        ["helmet_1"] = {
          [115] = true, -- PD
          [116] = true, -- PD
          [117] = true, -- PD
          [118] = true, -- PD
          [121] = true, -- MD
        },
    
      -- Gardan 1  
        ["chain_1"] = {
          [1000] = true, -- iaa
        },
        
      -- Khalkoobi 1
      ["decals_1"] = {
        [65] = true, -- para medic
        [66] = true, -- para medic
        [79] = true, -- noose
        [81] = true, -- police
        [86] = true, -- police
        [128] = true, -- police
        [129] = true, -- police
        [130] = true, -- police
        [131] = true, -- police
        [132] = true, -- police
        [133] = true, -- police
        [134] = true, -- police
        [135] = true, -- police
        [136] = true, -- police
        [137] = true, -- police
        [138] = true, -- police
        [139] = true, -- police
        [140] = true, -- police
        [141] = true, -- police
        [142] = true, -- police
        [143] = true, -- police
        [144] = true, -- police
        [145] = true, -- police
        [146] = true, -- police
        [147] = true, -- police
        [148] = true, -- police
        [149] = true, -- police
        [150] = true, -- police
        [151] = true, -- police
        [152] = true, -- police
        [153] = true, -- police
        [154] = true, -- police
        [155] = true, -- police
        [156] = true, -- police
        [157] = true, -- police
        [158] = true, -- police
        [159] = true, -- police
        [160] = true, -- police
        [161] = true, -- police
        [162] = true, -- police
        [163] = true, -- police
        [164] = true, -- police
        [165] = true, -- police
        [166] = true, -- police
        [167] = true, -- police
        [168] = true, -- police
        [169] = true, -- police
        [170] = true, -- police
        [171] = true, -- police
        [172] = true, -- police
        [173] = true, -- police
        [174] = true, -- police
        [175] = true, -- police
      },
    
      }
}
