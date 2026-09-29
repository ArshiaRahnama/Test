Config = {}

-- We also recommend vms_charcreator, it fits perfectly with the style!

-- Trigger event to open Clothe Store:
-- From Client Side | TriggerEvent("vms_clothestore:open", 1) -- 1 = ID of clothe store from Config.Stores
-- From Server Side | TriggerClientEvent("vms_clothestore:open", source, 1) -- 1 = ID of clothe store from Config.Stores

-- Client export to open Wardrobe is:
-- exports['vms_clothestore']:OpenWardrobe()

-- Client export to open Manage Clothes is:
-- exports['vms_clothestore']:OpenManage()

Config.Core = "ESX" -- "ESX" / "QB-Core"
Config.CoreExport = function()
    if Config.Core == "ESX" then
        -- Matches this server's convention (used across esx_billing, esx_society,
        -- vms_barber, vms_tattooshop, etc.) instead of assuming the ESX core
        -- resource is literally named "es_extended".
        local ESXObject = nil
        TriggerEvent('esx:getSharedObject', function(obj) ESXObject = obj end)
        if ESXObject then return ESXObject end

        local ok, result = pcall(function() return exports['es_extended']:getSharedObject() end)
        if ok and result then return result end

        return nil
    elseif Config.Core == "QB-Core" then
        return exports['qb-core']:GetCoreObject()
    end
end

Config.Notification = function(message, time, type)
    if type == "success" then
        -- exports["vms_notify"]:Notification("CLOTHES STORE", message, time, "#27FF09", "fa-solid fa-shirt")
        TriggerEvent('esx:showNotification', message)
        -- TriggerEvent('QBCore:Notify', message, 'success', time)
    elseif type == "error" then
        -- exports["vms_notify"]:Notification("CLOTHES STORE", message, time, "#FF0909", "fa-solid fa-shirt")
        TriggerEvent('esx:showNotification', message)
        -- TriggerEvent('QBCore:Notify', message, 'error', time)
    end
end

Config.Hud = {
    Enable = function()
        -- exports['vms_hud']:Display(true)
    end,
    Disable = function()
        -- exports['vms_hud']:Display(false)
    end
}

Config.Interact = {
    Enabled = false,
    Open = function()
        exports["interact"]:Open("E", Config.Translate['press_to_open']) -- Here you can use your TextUI or use my free one - https://github.com/vames-dev/interact
        -- exports['okokTextUI']:Open('[E] '..Config.Translate['press_to_open'], 'darkgreen', 'right')
        -- exports['qb-core']:DrawText(Config.Translate['press_to_open'], 'right')
    end,
    Close = function()
        exports["interact"]:Close() -- Here you can use your TextUI or use my free one - https://github.com/vames-dev/interact
        -- exports['okokTextUI']:Close()
        -- exports['qb-core']:HideText()
    end
}

-- @ Config.KeyOpen - https://docs.fivem.net/docs/game-references/controls/
Config.KeyOpen = 38 -- [E]

-- @ Config.SkinManager - ESX: "esx_skin" / "fivem-appearance" / "illenium-appearance"
-- @ Config.SkinManager - QB-Core: "qb-clothing" / "fivem-appearance" / "illenium-appearance"
Config.SkinManager = "esx_skin"


-- @UseQSInventory - if you use qs-inventory and clothing options
Config.UseQSInventory = false
Config.QSInventoryName = 'qs-inventory'

-- @ Config.ChangeClothes - Menu for choosing whether to buy new clothes or change into your clothes
Config.ChangeClothes = true

-- @ Config.SaveClothesMenu - Clothes saving
Config.SaveClothesMenu = true

-- @ Config.Menu for ESX: "esx_context", "esx_menu_default", "ox_lib"
-- @ Config.Menu for QB-Core: "qb-menu", "ox_lib"
Config.Menu = "ox_lib"
Config.ESXMenuDefault_Align = 'left' -- works only for esx_menu_default
Config.ESXContext_Align = 'left' -- works only for esx_context


Config.SoundsEffects = true -- if you want to sound effects by clicks set true
Config.BlurBehindPlayer = true -- to see it you need to have PostFX upper Very High or Ultra

Config.EnableHandsUpButtonUI = true -- Is there to be a button to raise hands on the UI
Config.HandsUpKey = 'x' -- Key JS (key.code) - https://www.toptal.com/developers/keycode
Config.HandsUpAnimation = {'missminuteman_1ig_2', 'handsup_enter', 50}

Config.ClothingPedAnimation = {"anim@heists@heist_corona@team_idles@male_a", "idle"} -- animation of the player during character creation

Config.DefaultCamDistance = 0.95 -- camera distance from player location (during character creation)
Config.CameraHeight = {
    ['masks'] = {z_height = 0.65, fov = 30.0},
    ['hats'] = {z_height = 0.65, fov = 30.0},
    ['torsos'] = {z_height = 0.15, fov = 75.0},
    ['bproofs'] = {z_height = 0.15, fov = 75.0},
    ['pants'] = {z_height = -0.825, fov = 75.0},
    ['shoes'] = {z_height = -0.6, fov = 75.0},
    ['chains'] = {z_height = 0.25, fov = 75.0},
    ['glasses'] = {z_height = 0.65, fov = 30.0},
    ['watches'] = {z_height = -0.025, fov = 75.0},
    ['ears'] = {z_height = 0.65, fov = 30.0},
    ['bags'] = {z_height = 0.15, fov = 75.0},
}

Config.Translate = {
    ['blip.clothesstore'] = 'Clothing Store',
    ['blip.maskstore'] = 'Mask Store',
    
    ['press_to_open'] = 'Press ~INPUT_CONTEXT~ to open the menu',

    ['you_paid'] = 'You paid $%s for the clothes',
    ['saved_clothes'] = 'You saved the outfit named %s',
    ['removed_clothes'] = 'You removed the outfit from your wardrobe.',
    ['enought_money'] = 'You do not have enough money',
    
    ['name_is_too_short'] = 'The name is too short',

    ['select_option'] = {name = 'Select an option', icon = 'fas fa-check-double'},
    ['manage_header'] = {name = 'Manage clothes', icon = 'fas fa-tshirt'}, 
    ['wardrobe_header'] = {name = 'Wardrobe', icon = 'fas fa-tshirt'}, 

    ['open_wardrobe'] = {name = 'Open Wardrobe', icon = 'fas fa-shirt'},
    ['open_manage'] = {name = 'Manage clothes', icon = 'fas fa-shirt'},
    ['open_store'] = {name = 'Open store', icon = 'fas fa-bag-shopping'},
    
    ['menu:header'] = {name = 'Do you want to save this outfit?', icon = 'fas fa-check-double'},
    ['menu:yes'] = {name = 'Yes', icon = 'fas fa-check-circle'},
    ['menu:no'] = {name = 'No', icon = 'fas fa-window-close'},
    
    ['title_remove'] = {name = 'Do you want to remove the outfit %s?', icon = 'fas fa-shirt'},
    ['remove_yes'] = {name = 'Yes', icon = 'fas fa-check'},
    ['remove_no'] = {name = 'No', icon = 'fas fa-xmark'},

    ['esx_menu_default:header'] = 'Name your outfit',
    ['esx_context:title'] = {name = 'Enter the outfit name', icon = 'fas fa-shirt'},
    ['esx_context:placeholder_title'] = 'Outfit name',
    ['esx_context:placeholder'] = 'Outfit name in wardrobe..',
    ['esx_context:confirm'] = {name = 'Confirm', icon = 'fas fa-check-circle'},

    ['qb-input:header'] = 'Name your outfit',
    ['qb-input:submitText'] = 'Save Outfit',
    ['qb-input:text'] = 'Outfit Name',
}

Config.Stores = {
    [1] = {
        coords = vector4(-1336.6649169922, -1277.701171875, 4.8739085197449 - 0.99, 89.680641174316),
        ped = 'a_m_y_indian_01',
        price = 250,
        blip = {
            sprite = 362,
            display = 4,
            scale = 0.7,
            color = 5,
            name = Config.Translate['blip.maskstore'],
        },
        marker = {
            id = 23,
            size = vec(1.85, 1.85, 0.95),
            color = {255, 205, 0, 125},
            rotate = false,
            bobUpAndDown = false
        },
        categories = {
            ['masks'] = true,
            ['hats'] = false,
            ['torsos'] = false,
            ['bproofs'] = false,
            ['pants'] = false,
            ['shoes'] = false,
            ['chains'] = false,
            ['glasses'] = false,
            ['watches'] = false,
            ['ears'] = false,
            ['bags'] = false,
        },
        -- @blockedClothes:
        --  For the clothing blockage to work correctly in the table, there must be at least two values. Only one value, for example {10}, cannot exist.
        --  To block only one value, you need to set the second value as a number that does not exist, for example {10, 100000}.
        blockedClothes = {
            ['male'] = {
                -- ['mask_1'] = {},
            },
            ['female'] = {
                -- ['mask_1'] = {},
            },
        }
    },
    [2] = {
        coords = vector4(-163.19187927246, -310.87667236328, 39.739967346191 - 0.99, 0.0),
        price = 250,
        ped = 'a_m_y_business_03',
        blip = {
            sprite = 73,
            display = 4,
            scale = 0.7,
            color = 55,
            name = Config.Translate['blip.clothesstore'],
        },
        marker = {
            id = 23,
            size = vec(1.85, 1.85, 0.95),
            color = {255, 205, 0, 125},
            rotate = false,
            bobUpAndDown = false
        },
        categories = {
            ['masks'] = false,
            ['hats'] = true,
            ['torsos'] = true,
            ['bproofs'] = true,
            ['pants'] = true,
            ['shoes'] = true,
            ['chains'] = true,
            ['glasses'] = true,
            ['watches'] = true,
            ['ears'] = true,
            ['bags'] = true,
        },
        blockedClothes = {
            ['male'] = {
                -- ['helmet_1'] = {46, 100000},
                -- ['mask_1'] = {},
                -- ['tshirt_1'] = {10, 15, 16, 17, 18, 19, 20},
                -- ['torso_1'] = {},
                -- ['arms'] = {},
                -- ['decals_1'] = {},
                -- ['bproof_1'] = {},
                -- ['pants_1'] = {},
                -- ['shoes_1'] = {},
                -- ['chain_1'] = {},
                -- ['glasses_1'] = {},
                -- ['watches_1'] = {},
                -- ['bracelets_1'] = {},
                -- ['ears_1'] = {},
                -- ['bags_1'] = {},
            },
            ['female'] = {
                -- ['helmet_1'] = {46, 100000},
                -- ['mask_1'] = {},
                -- ['tshirt_1'] = {10, 15, 16, 17, 18, 19, 20},
                -- ['torso_1'] = {},
                -- ['arms'] = {},
                -- ['decals_1'] = {},
                -- ['bproof_1'] = {},
                -- ['pants_1'] = {},
                -- ['shoes_1'] = {},
                -- ['chain_1'] = {},
                -- ['glasses_1'] = {},
                -- ['watches_1'] = {},
                -- ['bracelets_1'] = {},
                -- ['ears_1'] = {},
                -- ['bags_1'] = {},
            },
        }
    },
    [3] = {
        coords = vector4(76.320419311523, -1398.9959716797, 29.387657165527 - 0.99, 80.891174316406),
        ped = 's_m_m_lifeinvad_01',
        price = 250,
        blip = {
            sprite = 73,
            display = 4,
            scale = 0.7,
            color = 55,
            name = Config.Translate['blip.clothesstore'],
        },
        marker = {
            id = 23,
            size = vec(1.85, 1.85, 0.95),
            color = {255, 205, 0, 125},
            rotate = false,
            bobUpAndDown = false
        },
        categories = {
            ['masks'] = true,
            ['hats'] = true,
            ['torsos'] = true,
            ['bproofs'] = true,
            ['pants'] = true,
            ['shoes'] = true,
            ['chains'] = true,
            ['glasses'] = true,
            ['watches'] = true,
            ['ears'] = true,
            ['bags'] = true,
        },
        blockedClothes = {
            ['male'] = {
                -- ['helmet_1'] = {46, 100000},
                -- ['mask_1'] = {},
                -- ['tshirt_1'] = {10, 15, 16, 17, 18, 19, 20},
                -- ['torso_1'] = {},
                -- ['arms'] = {},
                -- ['decals_1'] = {},
                -- ['bproof_1'] = {},
                -- ['pants_1'] = {},
                -- ['shoes_1'] = {},
                -- ['chain_1'] = {},
                -- ['glasses_1'] = {},
                -- ['watches_1'] = {},
                -- ['bracelets_1'] = {},
                -- ['ears_1'] = {},
                -- ['bags_1'] = {},
            },
            ['female'] = {
                -- ['helmet_1'] = {46, 100000},
                -- ['mask_1'] = {},
                -- ['tshirt_1'] = {10, 15, 16, 17, 18, 19, 20},
                -- ['torso_1'] = {},
                -- ['arms'] = {},
                -- ['decals_1'] = {},
                -- ['bproof_1'] = {},
                -- ['pants_1'] = {},
                -- ['shoes_1'] = {},
                -- ['chain_1'] = {},
                -- ['glasses_1'] = {},
                -- ['watches_1'] = {},
                -- ['bracelets_1'] = {},
                -- ['ears_1'] = {},
                -- ['bags_1'] = {},
            },
        }
    },
    [4] = {
        coords = vector4(424.69879150391, -799.99993896484, 29.502624511719 - 0.99, 259.68389892578),
        ped = 's_m_m_lifeinvad_01',
        price = 250,
        blip = {
            sprite = 73,
            display = 4,
            scale = 0.7,
            color = 55,
            name = Config.Translate['blip.clothesstore'],
        },
        marker = {
            id = 23,
            size = vec(1.85, 1.85, 0.95),
            color = {255, 205, 0, 125},
            rotate = false,
            bobUpAndDown = false
        },
        categories = {
            ['masks'] = true,
            ['hats'] = true,
            ['torsos'] = true,
            ['bproofs'] = true,
            ['pants'] = true,
            ['shoes'] = true,
            ['chains'] = true,
            ['glasses'] = true,
            ['watches'] = true,
            ['ears'] = true,
            ['bags'] = true,
        },
        blockedClothes = {
            ['male'] = {
                -- ['helmet_1'] = {46, 100000},
                -- ['mask_1'] = {},
                -- ['tshirt_1'] = {10, 15, 16, 17, 18, 19, 20},
                -- ['torso_1'] = {},
                -- ['arms'] = {},
                -- ['decals_1'] = {},
                -- ['bproof_1'] = {},
                -- ['pants_1'] = {},
                -- ['shoes_1'] = {},
                -- ['chain_1'] = {},
                -- ['glasses_1'] = {},
                -- ['watches_1'] = {},
                -- ['bracelets_1'] = {},
                -- ['ears_1'] = {},
                -- ['bags_1'] = {},
            },
            ['female'] = {
                -- ['helmet_1'] = {46, 100000},
                -- ['mask_1'] = {},
                -- ['tshirt_1'] = {10, 15, 16, 17, 18, 19, 20},
                -- ['torso_1'] = {},
                -- ['arms'] = {},
                -- ['decals_1'] = {},
                -- ['bproof_1'] = {},
                -- ['pants_1'] = {},
                -- ['shoes_1'] = {},
                -- ['chain_1'] = {},
                -- ['glasses_1'] = {},
                -- ['watches_1'] = {},
                -- ['bracelets_1'] = {},
                -- ['ears_1'] = {},
                -- ['bags_1'] = {},
            },
        }
    },
    [5] = {
        coords = vector4(123.5231552124, -228.53494262695, 54.55782699585 - 0.99, 343.65396118164),
        ped = 'csb_ramp_hipster',
        price = 250,
        blip = {
            sprite = 73,
            display = 4,
            scale = 0.7,
            color = 55,
            name = Config.Translate['blip.clothesstore'],
        },
        marker = {
            id = 23,
            size = vec(1.85, 1.85, 0.95),
            color = {255, 205, 0, 125},
            rotate = false,
            bobUpAndDown = false
        },
        categories = {
            ['masks'] = true,
            ['hats'] = true,
            ['torsos'] = true,
            ['bproofs'] = true,
            ['pants'] = true,
            ['shoes'] = true,
            ['chains'] = true,
            ['glasses'] = true,
            ['watches'] = true,
            ['ears'] = true,
            ['bags'] = true,
        },
        blockedClothes = {
            ['male'] = {
                -- ['helmet_1'] = {46, 100000},
                -- ['mask_1'] = {},
                -- ['tshirt_1'] = {10, 15, 16, 17, 18, 19, 20},
                -- ['torso_1'] = {},
                -- ['arms'] = {},
                -- ['decals_1'] = {},
                -- ['bproof_1'] = {},
                -- ['pants_1'] = {},
                -- ['shoes_1'] = {},
                -- ['chain_1'] = {},
                -- ['glasses_1'] = {},
                -- ['watches_1'] = {},
                -- ['bracelets_1'] = {},
                -- ['ears_1'] = {},
                -- ['bags_1'] = {},
            },
            ['female'] = {
                -- ['helmet_1'] = {46, 100000},
                -- ['mask_1'] = {},
                -- ['tshirt_1'] = {10, 15, 16, 17, 18, 19, 20},
                -- ['torso_1'] = {},
                -- ['arms'] = {},
                -- ['decals_1'] = {},
                -- ['bproof_1'] = {},
                -- ['pants_1'] = {},
                -- ['shoes_1'] = {},
                -- ['chain_1'] = {},
                -- ['glasses_1'] = {},
                -- ['watches_1'] = {},
                -- ['bracelets_1'] = {},
                -- ['ears_1'] = {},
                -- ['bags_1'] = {},
            },
        }
    },
    [6] = {
        coords = vector4(-716.01928710938, -147.84616088867, 37.415126800537 - 0.99, 203.34492492676),
        ped = 'a_m_y_business_03',
        price = 250,
        blip = {
            sprite = 73,
            display = 4,
            scale = 0.7,
            color = 55,
            name = Config.Translate['blip.clothesstore'],
        },
        marker = {
            id = 23,
            size = vec(1.85, 1.85, 0.95),
            color = {255, 205, 0, 125},
            rotate = false,
            bobUpAndDown = false
        },
        categories = {
            ['masks'] = true,
            ['hats'] = true,
            ['torsos'] = true,
            ['bproofs'] = true,
            ['pants'] = true,
            ['shoes'] = true,
            ['chains'] = true,
            ['glasses'] = true,
            ['watches'] = true,
            ['ears'] = true,
            ['bags'] = true,
        },
        blockedClothes = {
            ['male'] = {
                -- ['helmet_1'] = {46, 100000},
                -- ['mask_1'] = {},
                -- ['tshirt_1'] = {10, 15, 16, 17, 18, 19, 20},
                -- ['torso_1'] = {},
                -- ['arms'] = {},
                -- ['decals_1'] = {},
                -- ['bproof_1'] = {},
                -- ['pants_1'] = {},
                -- ['shoes_1'] = {},
                -- ['chain_1'] = {},
                -- ['glasses_1'] = {},
                -- ['watches_1'] = {},
                -- ['bracelets_1'] = {},
                -- ['ears_1'] = {},
                -- ['bags_1'] = {},
            },
            ['female'] = {
                -- ['helmet_1'] = {46, 100000},
                -- ['mask_1'] = {},
                -- ['tshirt_1'] = {10, 15, 16, 17, 18, 19, 20},
                -- ['torso_1'] = {},
                -- ['arms'] = {},
                -- ['decals_1'] = {},
                -- ['bproof_1'] = {},
                -- ['pants_1'] = {},
                -- ['shoes_1'] = {},
                -- ['chain_1'] = {},
                -- ['glasses_1'] = {},
                -- ['watches_1'] = {},
                -- ['bracelets_1'] = {},
                -- ['ears_1'] = {},
                -- ['bags_1'] = {},
            },
        }
    },
    [7] = {
        coords = vector4(-1188.6520996094, -765.41796875, 17.319849014282 - 0.99, 122.6291809082),
        ped = 'csb_ramp_hipster',
        price = 250,
        blip = {
            sprite = 73,
            display = 4,
            scale = 0.7,
            color = 55,
            name = Config.Translate['blip.clothesstore'],
        },
        marker = {
            id = 23,
            size = vec(1.85, 1.85, 0.95),
            color = {255, 205, 0, 125},
            rotate = false,
            bobUpAndDown = false
        },
        categories = {
            ['masks'] = true,
            ['hats'] = true,
            ['torsos'] = true,
            ['bproofs'] = true,
            ['pants'] = true,
            ['shoes'] = true,
            ['chains'] = true,
            ['glasses'] = true,
            ['watches'] = true,
            ['ears'] = true,
            ['bags'] = true,
        },
        blockedClothes = {
            ['male'] = {
                -- ['helmet_1'] = {46, 100000},
                -- ['mask_1'] = {},
                -- ['tshirt_1'] = {10, 15, 16, 17, 18, 19, 20},
                -- ['torso_1'] = {},
                -- ['arms'] = {},
                -- ['decals_1'] = {},
                -- ['bproof_1'] = {},
                -- ['pants_1'] = {},
                -- ['shoes_1'] = {},
                -- ['chain_1'] = {},
                -- ['glasses_1'] = {},
                -- ['watches_1'] = {},
                -- ['bracelets_1'] = {},
                -- ['ears_1'] = {},
                -- ['bags_1'] = {},
            },
            ['female'] = {
                -- ['helmet_1'] = {46, 100000},
                -- ['mask_1'] = {},
                -- ['tshirt_1'] = {10, 15, 16, 17, 18, 19, 20},
                -- ['torso_1'] = {},
                -- ['arms'] = {},
                -- ['decals_1'] = {},
                -- ['bproof_1'] = {},
                -- ['pants_1'] = {},
                -- ['shoes_1'] = {},
                -- ['chain_1'] = {},
                -- ['glasses_1'] = {},
                -- ['watches_1'] = {},
                -- ['bracelets_1'] = {},
                -- ['ears_1'] = {},
                -- ['bags_1'] = {},
            },
        }
    },
    [8] = {
        coords = vector4(-3173.1171875, 1039.2159423828, 20.863206863403 - 0.99, 335.92993164063),
        ped = 'csb_ramp_hipster',
        price = 250,
        blip = {
            sprite = 73,
            display = 4,
            scale = 0.7,
            color = 55,
            name = Config.Translate['blip.clothesstore'],
        },
        marker = {
            id = 23,
            size = vec(1.85, 1.85, 0.95),
            color = {255, 205, 0, 125},
            rotate = false,
            bobUpAndDown = false
        },
        categories = {
            ['masks'] = true,
            ['hats'] = true,
            ['torsos'] = true,
            ['bproofs'] = true,
            ['pants'] = true,
            ['shoes'] = true,
            ['chains'] = true,
            ['glasses'] = true,
            ['watches'] = true,
            ['ears'] = true,
            ['bags'] = true,
        },
        blockedClothes = {
            ['male'] = {
                -- ['helmet_1'] = {46, 100000},
                -- ['mask_1'] = {},
                -- ['tshirt_1'] = {10, 15, 16, 17, 18, 19, 20},
                -- ['torso_1'] = {},
                -- ['arms'] = {},
                -- ['decals_1'] = {},
                -- ['bproof_1'] = {},
                -- ['pants_1'] = {},
                -- ['shoes_1'] = {},
                -- ['chain_1'] = {},
                -- ['glasses_1'] = {},
                -- ['watches_1'] = {},
                -- ['bracelets_1'] = {},
                -- ['ears_1'] = {},
                -- ['bags_1'] = {},
            },
            ['female'] = {
                -- ['helmet_1'] = {46, 100000},
                -- ['mask_1'] = {},
                -- ['tshirt_1'] = {10, 15, 16, 17, 18, 19, 20},
                -- ['torso_1'] = {},
                -- ['arms'] = {},
                -- ['decals_1'] = {},
                -- ['bproof_1'] = {},
                -- ['pants_1'] = {},
                -- ['shoes_1'] = {},
                -- ['chain_1'] = {},
                -- ['glasses_1'] = {},
                -- ['watches_1'] = {},
                -- ['bracelets_1'] = {},
                -- ['ears_1'] = {},
                -- ['bags_1'] = {},
            },
        }
    },
    [9] = {
        coords = vector4(614.36950683594, 2767.9543457031, 42.088138580322 - 0.99, 184.52507019043),
        ped = 'csb_ramp_hipster',
        price = 250,
        blip = {
            sprite = 73,
            display = 4,
            scale = 0.7,
            color = 55,
            name = Config.Translate['blip.clothesstore'],
        },
        marker = {
            id = 23,
            size = vec(1.85, 1.85, 0.95),
            color = {255, 205, 0, 125},
            rotate = false,
            bobUpAndDown = false
        },
        categories = {
            ['masks'] = true,
            ['hats'] = true,
            ['torsos'] = true,
            ['bproofs'] = true,
            ['pants'] = true,
            ['shoes'] = true,
            ['chains'] = true,
            ['glasses'] = true,
            ['watches'] = true,
            ['ears'] = true,
            ['bags'] = true,
        },
        blockedClothes = {
            ['male'] = {
                -- ['helmet_1'] = {46, 100000},
                -- ['mask_1'] = {},
                -- ['tshirt_1'] = {10, 15, 16, 17, 18, 19, 20},
                -- ['torso_1'] = {},
                -- ['arms'] = {},
                -- ['decals_1'] = {},
                -- ['bproof_1'] = {},
                -- ['pants_1'] = {},
                -- ['shoes_1'] = {},
                -- ['chain_1'] = {},
                -- ['glasses_1'] = {},
                -- ['watches_1'] = {},
                -- ['bracelets_1'] = {},
                -- ['ears_1'] = {},
                -- ['bags_1'] = {},
            },
            ['female'] = {
                -- ['helmet_1'] = {46, 100000},
                -- ['mask_1'] = {},
                -- ['tshirt_1'] = {10, 15, 16, 17, 18, 19, 20},
                -- ['torso_1'] = {},
                -- ['arms'] = {},
                -- ['decals_1'] = {},
                -- ['bproof_1'] = {},
                -- ['pants_1'] = {},
                -- ['shoes_1'] = {},
                -- ['chain_1'] = {},
                -- ['glasses_1'] = {},
                -- ['watches_1'] = {},
                -- ['bracelets_1'] = {},
                -- ['ears_1'] = {},
                -- ['bags_1'] = {},
            },
        }
    },
    [10] = {
        coords = vector4(-1104.9810791016, 2705.4755859375, 19.119348526001 - 0.99, 41.824192047119),
        ped = 's_m_m_lifeinvad_01',
        price = 250,
        blip = {
            sprite = 73,
            display = 4,
            scale = 0.7,
            color = 55,
            name = Config.Translate['blip.clothesstore'],
        },
        marker = {
            id = 23,
            size = vec(1.85, 1.85, 0.95),
            color = {255, 205, 0, 125},
            rotate = false,
            bobUpAndDown = false
        },
        categories = {
            ['masks'] = true,
            ['hats'] = true,
            ['torsos'] = true,
            ['bproofs'] = true,
            ['pants'] = true,
            ['shoes'] = true,
            ['chains'] = true,
            ['glasses'] = true,
            ['watches'] = true,
            ['ears'] = true,
            ['bags'] = true,
        },
        blockedClothes = {
            ['male'] = {
                -- ['helmet_1'] = {46, 100000},
                -- ['mask_1'] = {},
                -- ['tshirt_1'] = {10, 15, 16, 17, 18, 19, 20},
                -- ['torso_1'] = {},
                -- ['arms'] = {},
                -- ['decals_1'] = {},
                -- ['bproof_1'] = {},
                -- ['pants_1'] = {},
                -- ['shoes_1'] = {},
                -- ['chain_1'] = {},
                -- ['glasses_1'] = {},
                -- ['watches_1'] = {},
                -- ['bracelets_1'] = {},
                -- ['ears_1'] = {},
                -- ['bags_1'] = {},
            },
            ['female'] = {
                -- ['helmet_1'] = {46, 100000},
                -- ['mask_1'] = {},
                -- ['tshirt_1'] = {10, 15, 16, 17, 18, 19, 20},
                -- ['torso_1'] = {},
                -- ['arms'] = {},
                -- ['decals_1'] = {},
                -- ['bproof_1'] = {},
                -- ['pants_1'] = {},
                -- ['shoes_1'] = {},
                -- ['chain_1'] = {},
                -- ['glasses_1'] = {},
                -- ['watches_1'] = {},
                -- ['bracelets_1'] = {},
                -- ['ears_1'] = {},
                -- ['bags_1'] = {},
            },
        }
    },
    [11] = {
        coords = vector4(1190.8793457031, 2708.4548339844, 38.2340965271 - 0.99, 358.77777099609),
        ped = 's_m_m_lifeinvad_01',
        price = 250,
        blip = {
            sprite = 73,
            display = 4,
            scale = 0.7,
            color = 55,
            name = Config.Translate['blip.clothesstore'],
        },
        marker = {
            id = 23,
            size = vec(1.85, 1.85, 0.95),
            color = {255, 205, 0, 125},
            rotate = false,
            bobUpAndDown = false
        },
        categories = {
            ['masks'] = true,
            ['hats'] = true,
            ['torsos'] = true,
            ['bproofs'] = true,
            ['pants'] = true,
            ['shoes'] = true,
            ['chains'] = true,
            ['glasses'] = true,
            ['watches'] = true,
            ['ears'] = true,
            ['bags'] = true,
        },
        blockedClothes = {
            ['male'] = {
                -- ['helmet_1'] = {46, 100000},
                -- ['mask_1'] = {},
                -- ['tshirt_1'] = {10, 15, 16, 17, 18, 19, 20},
                -- ['torso_1'] = {},
                -- ['arms'] = {},
                -- ['decals_1'] = {},
                -- ['bproof_1'] = {},
                -- ['pants_1'] = {},
                -- ['shoes_1'] = {},
                -- ['chain_1'] = {},
                -- ['glasses_1'] = {},
                -- ['watches_1'] = {},
                -- ['bracelets_1'] = {},
                -- ['ears_1'] = {},
                -- ['bags_1'] = {},
            },
            ['female'] = {
                -- ['helmet_1'] = {46, 100000},
                -- ['mask_1'] = {},
                -- ['tshirt_1'] = {10, 15, 16, 17, 18, 19, 20},
                -- ['torso_1'] = {},
                -- ['arms'] = {},
                -- ['decals_1'] = {},
                -- ['bproof_1'] = {},
                -- ['pants_1'] = {},
                -- ['shoes_1'] = {},
                -- ['chain_1'] = {},
                -- ['glasses_1'] = {},
                -- ['watches_1'] = {},
                -- ['bracelets_1'] = {},
                -- ['ears_1'] = {},
                -- ['bags_1'] = {},
            },
        }
    },
    [12] = {
        coords = vector4(1691.1414794922, 4828.5263671875, 42.074584960938 - 0.99, 271.41329956055),
        ped = 's_m_m_lifeinvad_01',
        price = 250,
        blip = {
            sprite = 73,
            display = 4,
            scale = 0.7,
            color = 55,
            name = Config.Translate['blip.clothesstore'],
        },
        marker = {
            id = 23,
            size = vec(1.85, 1.85, 0.95),
            color = {255, 205, 0, 125},
            rotate = false,
            bobUpAndDown = false
        },
        categories = {
            ['masks'] = true,
            ['hats'] = true,
            ['torsos'] = true,
            ['bproofs'] = true,
            ['pants'] = true,
            ['shoes'] = true,
            ['chains'] = true,
            ['glasses'] = true,
            ['watches'] = true,
            ['ears'] = true,
            ['bags'] = true,
        },
        blockedClothes = {
            ['male'] = {
                -- ['helmet_1'] = {46, 100000},
                -- ['mask_1'] = {},
                -- ['tshirt_1'] = {10, 15, 16, 17, 18, 19, 20},
                -- ['torso_1'] = {},
                -- ['arms'] = {},
                -- ['decals_1'] = {},
                -- ['bproof_1'] = {},
                -- ['pants_1'] = {},
                -- ['shoes_1'] = {},
                -- ['chain_1'] = {},
                -- ['glasses_1'] = {},
                -- ['watches_1'] = {},
                -- ['bracelets_1'] = {},
                -- ['ears_1'] = {},
                -- ['bags_1'] = {},
            },
            ['female'] = {
                -- ['helmet_1'] = {46, 100000},
                -- ['mask_1'] = {},
                -- ['tshirt_1'] = {10, 15, 16, 17, 18, 19, 20},
                -- ['torso_1'] = {},
                -- ['arms'] = {},
                -- ['decals_1'] = {},
                -- ['bproof_1'] = {},
                -- ['pants_1'] = {},
                -- ['shoes_1'] = {},
                -- ['chain_1'] = {},
                -- ['glasses_1'] = {},
                -- ['watches_1'] = {},
                -- ['bracelets_1'] = {},
                -- ['ears_1'] = {},
                -- ['bags_1'] = {},
            },
        }
    },
    [13] = {
        coords = vector4(8.0329580307007, 6518.0517578125, 31.889364242554 - 0.99, 221.30197143555),
        ped = 's_m_m_lifeinvad_01',
        price = 250,
        blip = {
            sprite = 73,
            display = 4,
            scale = 0.7,
            color = 55,
            name = Config.Translate['blip.clothesstore'],
        },
        marker = {
            id = 23,
            size = vec(1.85, 1.85, 0.95),
            color = {255, 205, 0, 125},
            rotate = false,
            bobUpAndDown = false
        },
        categories = {
            ['masks'] = true,
            ['hats'] = true,
            ['torsos'] = true,
            ['bproofs'] = true,
            ['pants'] = true,
            ['shoes'] = true,
            ['chains'] = true,
            ['glasses'] = true,
            ['watches'] = true,
            ['ears'] = true,
            ['bags'] = true,
        },
        blockedClothes = {
            ['male'] = {
                -- ['helmet_1'] = {46, 100000},
                -- ['mask_1'] = {},
                -- ['tshirt_1'] = {2, 3, 4},
                -- ['torso_1'] = {},
                -- ['arms'] = {},
                -- ['decals_1'] = {},
                -- ['bproof_1'] = {},
                -- ['pants_1'] = {},
                -- ['shoes_1'] = {},
                -- ['chain_1'] = {},
                -- ['glasses_1'] = {},
                -- ['watches_1'] = {},
                -- ['bracelets_1'] = {},
                -- ['ears_1'] = {},
                -- ['bags_1'] = {},
            },
            ['female'] = {
                -- ['helmet_1'] = {46, 100000},
                -- ['mask_1'] = {},
                -- ['tshirt_1'] = {10, 15, 16, 17, 18, 19, 20},
                -- ['torso_1'] = {},
                -- ['arms'] = {},
                -- ['decals_1'] = {},
                -- ['bproof_1'] = {},
                -- ['pants_1'] = {},
                -- ['shoes_1'] = {},
                -- ['chain_1'] = {},
                -- ['glasses_1'] = {},
                -- ['watches_1'] = {},
                -- ['bracelets_1'] = {},
                -- ['ears_1'] = {},
                -- ['bags_1'] = {},
            },
        }
    },
    [14] = {
        coords = vector4(-826.86193847656, -1078.2614746094, 11.339618682861 - 0.99, 28.344844818115),
        ped = 's_m_m_lifeinvad_01',
        price = 250,
        blip = {
            sprite = 73,
            display = 4,
            scale = 0.7,
            color = 55,
            name = Config.Translate['blip.clothesstore'],
        },
        marker = {
            id = 23,
            size = vec(1.85, 1.85, 0.95),
            color = {255, 205, 0, 125},
            rotate = false,
            bobUpAndDown = false
        },
        categories = {
            ['masks'] = true,
            ['hats'] = true,
            ['torsos'] = true,
            ['bproofs'] = true,
            ['pants'] = true,
            ['shoes'] = true,
            ['chains'] = true,
            ['glasses'] = true,
            ['watches'] = true,
            ['ears'] = true,
            ['bags'] = true,
        },
        blockedClothes = {
            ['male'] = {
                -- ['helmet_1'] = {46, 100000},
                -- ['mask_1'] = {},
                -- ['tshirt_1'] = {2, 3, 4},
                -- ['torso_1'] = {},
                -- ['arms'] = {},
                -- ['decals_1'] = {},
                -- ['bproof_1'] = {},
                -- ['pants_1'] = {},
                -- ['shoes_1'] = {},
                -- ['chain_1'] = {},
                -- ['glasses_1'] = {},
                -- ['watches_1'] = {},
                -- ['bracelets_1'] = {},
                -- ['ears_1'] = {},
                -- ['bags_1'] = {},
            },
            ['female'] = {
                -- ['helmet_1'] = {46, 100000},
                -- ['mask_1'] = {},
                -- ['tshirt_1'] = {10, 15, 16, 17, 18, 19, 20},
                -- ['torso_1'] = {},
                -- ['arms'] = {},
                -- ['decals_1'] = {},
                -- ['bproof_1'] = {},
                -- ['pants_1'] = {},
                -- ['shoes_1'] = {},
                -- ['chain_1'] = {},
                -- ['glasses_1'] = {},
                -- ['watches_1'] = {},
                -- ['bracelets_1'] = {},
                -- ['ears_1'] = {},
                -- ['bags_1'] = {},
            },
        }
    },
}