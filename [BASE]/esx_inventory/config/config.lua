Config = Config or {}
--[[ 
    Welcome to the inventory configuration!
    https://lcode.gitbook.io/documentation/inventory/
]]

--╔════════════════════════════════════════════════════════════════════════════════╗

--  ██████╗ ███████╗███╗   ██╗███████╗██████╗  █████╗ ██╗     
-- ██╔════╝ ██╔════╝████╗  ██║██╔════╝██╔══██╗██╔══██╗██║     
-- ██║  ███╗█████╗  ██╔██╗ ██║█████╗  ██████╔╝███████║██║     
-- ██║   ██║██╔══╝  ██║╚██╗██║██╔══╝  ██╔══██╗██╔══██║██║     
-- ╚██████╔╝███████╗██║ ╚████║███████╗██║  ██║██║  ██║███████╗
--  ╚═════╝ ╚══════╝╚═╝  ╚═══╝╚══════╝╚═╝  ╚═╝╚═╝  ╚═╝╚══════╝
                                                           

Config.Language = "en" -- Set your lang in locales folder (fr, en, es, ...)
Config.Framework = "esx" -- esx or qb

-- Max weight (kg) a property (house) chest can hold. Was previously
-- unused because the whole property storage backend was a stub - see
-- server/custom/property/property.lua for the fix. 250kg matches the
-- example data shape already documented in that file.
Config.DefaultPropertyMaxWeight = 250

-- Max weight (kg) a vehicle's glovebox can hold - a small, separate
-- items-only container from the trunk (Config.WeightVehicle). Opened
-- with the "glovebox" keybind (Config.KeyBinds) while seated in a
-- vehicle. See server/custom/glovebox/glovebox.lua.
Config.DefaultGloveboxMaxWeight = 5

-- Timed corpse looting (server/custom/corpse/corpse.lua): how long, in
-- seconds, a dead NPC's body stays lootable after death. Only applies
-- to non-player peds (NPCs/world) - looting a dead PLAYER already works
-- through the existing /fouiller command (server/apps/system/loot.lua)
-- and isn't affected by this.
Config.CorpseLootDuration = 300

-- What a looted NPC corpse can contain. Each entry has an independent
-- chance to roll (not weighted against the others). type = 'cash' rolls
-- a random amount of pocket money; type = 'item' rolls a random count
-- of a real item - ONLY add item names that actually exist in your
-- `items` table (server/apps/system/loot.lua-style item-only pickups
-- otherwise silently give nothing, same as any other invalid item name
-- would).
Config.NPCLootTable = {
    {type = 'cash', chance = 80, min = 5, max = 120},
    -- example - uncomment and rename once you've picked real items:
    -- {type = 'item', name = 'bread', label = 'Bread', chance = 20, min = 1, max = 1},
}

Config.Debug = true 
Config.UseNPC = false
--[[                                    
    'old' (Esx 1.1).
    'new' (Esx 1.2, v1 final, legacy or extendedmode).
]]
Config.esxVersion = 'old' 

Config.Trigger = {
    ['useItem'] = 'esx:useItem', -- for QBCore is : 'QBCore:Server:UseItem'
    ['getSharedObject'] = 'esx:getSharedObject',
    ['getStatus'] = 'esx_status:getStatus',
    ['saveSkin'] = 'esx_skin:save',
}


Config.KeyBinds = {
    -- Find keybinds here: https://docs.fivem.net/docs/game-references/input-mapper-parameter-ids/keyboard/
    {Command = "inventory", Bind = "F2", Description = "Open inventory"},-- toggle the inventaire
    {Command = "keybind_1", Bind = "1", Description = "Slot weapon 1"},-- 
    {Command = "keybind_2", Bind = "2", Description = "Slot weapon 2"},-- 
    {Command = "keybind_3", Bind = "3", Description = "Slot weapon 3"},-- 
    {Command = "keybind_4", Bind = "4", Description = "Slot weapon 4"},-- 
    {Command = "keybind_5", Bind = "5", Description = "Slot weapon 5"},-- 
    {Command = "trunk", Bind = "K", Description = "Open trunk vehicle"},-- 
    {Command = "glovebox", Bind = "G", Description = "Open vehicle glovebox"},-- 
    {Command = "lootbody", Bind = "E", Description = "Loot nearby corpse"},-- 
}

-- false : If you want use your custom notification in inventory (client/custom/framework/esx.lua)
Config.UseNotificationInventory = true

-- Name of the item when used will close the UI
Config.CloseUI = {
    ['water'] = true,
    ['bread'] = true,
    ['phone'] = true,
    ['boombox'] = true,
}

-- Names of weapons impossible to give
Config.WeaponNoGive = {
    ["WEAPON_PISTOL_MK2"] = true,
}

-- Names of item impossible to give
Config.ItemNoGive = {
    ["boombox"] = true,
}

-- Name of the item that cannot be placed in slots
Config.BL_SlotInv = {
    ["phone"] = true,
    ["radio"] = true,
    ['boombox'] = true,
}

--╔════════════════════════════════════════════════════════════════════════════════╗

--  ██████╗██╗      ██████╗ ████████╗██╗  ██╗███████╗███████╗
-- ██╔════╝██║     ██╔═══██╗╚══██╔══╝██║  ██║██╔════╝██╔════╝
-- ██║     ██║     ██║   ██║   ██║   ███████║█████╗  ███████╗
-- ██║     ██║     ██║   ██║   ██║   ██╔══██║██╔══╝  ╚════██║
-- ╚██████╗███████╗╚██████╔╝   ██║   ██║  ██║███████╗███████║
--  ╚═════╝╚══════╝ ╚═════╝    ╚═╝   ╚═╝  ╚═╝╚══════╝╚══════╝
                 

-- For interaction in the middle of the inventory
Config.Clothes = {
    ['helmet'] = {
        [0] = {['helmet_1'] = 0 --[[ type ]], ["helmet_2"] = 0--[[ color ]]}, -- men 
        [1] = {['helmet_1'] = 0 --[[ type ]], ["helmet_2"] = 0--[[ color ]]}  -- women
    },
    ['chain'] = {
        [0] = {['chain_1'] = 0, ["chain_2"] = 0}, -- //
        [1] = {['chain_1'] = 0, ["chain_2"] = 0}  -- //
    },
    ['torso'] = {
        [0] = {['torso_1'] = 0, ["torso_2"] = 0},
        [0] = {['torso_1'] = 0, ["torso_2"] = 0},
    },
    ['tshirt'] = {
        [0] = {['tshirt_1'] = 15, ["tshirt_2"] = 0},
        [1] = {['tshirt_1'] = 0, ["tshirt_2"] = 0},
    },
    ['arms'] = {
        [0] = {['arms_1'] = 0, ["arms_2"] = 0},
        [1] = {['arms_1'] = 0, ["arms_2"] = 0},
    },
    ['pants'] = {
        [0] = {['pants_1'] = 0, ["pants_2"] = 0},
        [1] = {['pants_1'] = 0, ["pants_2"] = 0}
    },
    ['shoes'] = {
        [0] = {['shoes_1'] = 0, ["shoes_2"] = 0},
        [1] = {['shoes_1'] = 0, ["shoes_2"] = 0}
    },
    ['bags'] = {
        [0] = {['bags_1'] = 0, ["bags_2"] = 0},
        [1] = {['bags_1'] = 0, ["bags_2"] = 0}
    },
    ['mask'] = {
        [0] = {['mask_1'] = 0, ["mask_2"] = 0},
        [1] = {['mask_1'] = 0, ["mask_2"] = 0}
    },
    ['glasses'] = {
        [0] = {['glasses_1'] = 0, ["glasses_2"] = 0},
        [1] = {['glasses_1'] = 0, ["glasses_2"] = 0}
    },
    ['ears'] = {
        [0] = {['ears_1'] = 0, ["ears_2"] = 0},
        [1] = {['ears_1'] = 0, ["ears_2"] = 0}
    },
    ['bracelets'] = {
        [0] = {['bracelets_1'] = 0, ["bracelets_2"] = 0},
        [1] = {['bracelets_1'] = 0, ["bracelets_2"] = 0}
    },
    ['watches'] = {
        [0] = {['watches_1'] = 0, ["watches_2"] = 0},
        [1] = {['watches_1'] = 0, ["watches_2"] = 0}
    },
    ['bproof'] = {
        [0] = {['bproof_1'] = 0, ["bproof_2"] = 0},
        [1] = {['bproof_1'] = 0, ["bproof_2"] = 0}
    },
}

--╚════════════════════════════════════════════════════════════════════════════════╝
--╔════════════════════════════════════════════════════════════════════════════════╗

--  ██████╗██╗      ██████╗ ████████╗██╗  ██╗██╗███╗   ██╗ ██████╗     ███████╗████████╗ ██████╗ ██████╗ ███████╗
-- ██╔════╝██║     ██╔═══██╗╚══██╔══╝██║  ██║██║████╗  ██║██╔════╝     ██╔════╝╚══██╔══╝██╔═══██╗██╔══██╗██╔════╝
-- ██║     ██║     ██║   ██║   ██║   ███████║██║██╔██╗ ██║██║  ███╗    ███████╗   ██║   ██║   ██║██████╔╝█████╗  
-- ██║     ██║     ██║   ██║   ██║   ██╔══██║██║██║╚██╗██║██║   ██║    ╚════██║   ██║   ██║   ██║██╔══██╗██╔══╝  
-- ╚██████╗███████╗╚██████╔╝   ██║   ██║  ██║██║██║ ╚████║╚██████╔╝    ███████║   ██║   ╚██████╔╝██║  ██║███████╗
--  ╚═════╝╚══════╝ ╚═════╝    ╚═╝   ╚═╝  ╚═╝╚═╝╚═╝  ╚═══╝ ╚═════╝     ╚══════╝   ╚═╝    ╚═════╝ ╚═╝  ╚═╝╚══════╝
        
Config.ActiveClothShop = true -- esx_inventory's own clothing store (unique_clothestore removed - see client/apps/system/clothes.lua)

Config.ClothMarkerDistance = 15
Config.ClothMarkerType = 25
Config.ClothActiveText = true
Config.ClothMarkerText = '👕'

Config.ClothTypeMoney = 'bank'
Config.ClothPriceSave = 100
Config.ClothPriceRegister = 250
Config.ClothPrice = {
    ["top"] = 150,
    ["pants"] = 100,
    ["shoes"] = 80,
    ["bags"] = 50,
    ["glasses"] = 20,
    ["ears"] = 10,
    ["helmet"] = 30,
    ["bracelets"] = 15,
    ["watches"] = 30,
    ["chain"] = 50,
    ["mask"] = 30,
}

Config.PosClotheShop = {
    ['Binco'] = {
        menu = 'shopui_title_lowendfashion2',
        type = 'clothes', -- or mask
        coords = {
            vector3(-822.42, -1073.55, 10.33),
            vector3(75.34, -1393.00, 28.38),
            vector3(425.59, -806.15, 28.49),
            vector3(4.87, 6512.46, 30.88),
            vector3(1693.92, 4822.82, 41.06),
            vector3(1196.61, 2710.25, 37.22),
            vector3(-1101.48, 2710.57, 18.11),
        },
        blip = {
            color = 81,
            size = 0.7,
            style = 73
        }
    },
    ['Suburban'] = {
        menu = 'shopui_title_midfashion',
        type = 'clothes', -- or mask
        coords = {
            vector3(-1193.16, -767.98, 16.32),
            vector3(125.77, -223.9, 53.56),
            vector3(614.19, 2762.79, 41.09),
            vector3(-3170.54, 1043.68, 19.86)
        },
        blip = {
            color = 81,
            size = 0.7,
            style = 73
        }
    },
    ['Ponsonbys'] = {
        menu = 'shopui_title_highendfashion',
        type = 'clothes', -- or mask
        coords = {
            vector3(-709.86, -153.1, 36.42),
            vector3(-163.37, -302.73, 38.73),
            vector3(-1450.42, -237.66, 48.81)
        },
        blip = {
            color = 81,
            size = 0.7,
            style = 73
        }
    },
}


--╚════════════════════════════════════════════════════════════════════════════════╝
--╔════════════════════════════════════════════════════════════════════════════════╗

--  █████╗  ██████╗ ██████╗ ██████╗ ██╗   ██╗███╗   ██╗████████╗
-- ██╔══██╗██╔════╝██╔════╝██╔═══██╗██║   ██║████╗  ██║╚══██╔══╝
-- ███████║██║     ██║     ██║   ██║██║   ██║██╔██╗ ██║   ██║   
-- ██╔══██║██║     ██║     ██║   ██║██║   ██║██║╚██╗██║   ██║   
-- ██║  ██║╚██████╗╚██████╗╚██████╔╝╚██████╔╝██║ ╚████║   ██║   
-- ╚═╝  ╚═╝ ╚═════╝ ╚═════╝ ╚═════╝  ╚═════╝ ╚═╝  ╚═══╝   ╚═╝   
                                                             

-- Display accounts in inventory
Config.ActiveAccount = true
Config.Account = {["bank"] = true, ["cash"] = true, ["black_money"] = true} 
Config.AccountName = {
    ["bank"] = 'Bank', 
    ["cash"] = 'Money',
    ["black_money"] = 'Dirty Money'
}

--╚════════════════════════════════════════════════════════════════════════════════╝
--╔════════════════════════════════════════════════════════════════════════════════╗

-- ██╗██████╗      ██████╗ █████╗ ██████╗ ██████╗ 
-- ██║██╔══██╗    ██╔════╝██╔══██╗██╔══██╗██╔══██╗
-- ██║██║  ██║    ██║     ███████║██████╔╝██║  ██║
-- ██║██║  ██║    ██║     ██╔══██║██╔══██╗██║  ██║
-- ██║██████╔╝    ╚██████╗██║  ██║██║  ██║██████╔╝
-- ╚═╝╚═════╝      ╚═════╝╚═╝  ╚═╝╚═╝  ╚═╝╚═════╝ 
    

-- Display id card in inventory
Config.ActiveIdCard = true -- just for ESX
Config.ActiveMugShot = true -- requires the 'MugShotBase64' resource (https://github.com/BaziForYou/MugShotBase64) to be installed & started; client/apps/other/idcard.lua falls back to Config.PictureIdCard automatically if it isn't.
Config.PictureIdCard = 'https://cdn.discordapp.com/attachments/979486375218937946/1135635765397823488/47848.png'  -- if ActiveMugShot == false
Config.IdCardName = {
    ["id"] = {
        name = 'Identity card', 
        icon = 'assets/icons/icon.png',
        color = '#FFF'
    },
    ["drive"] = {
        name = 'Driver\'s license', 
        icon = 'assets/icons/permis.png',
        color = '#e2bab3'
    },
    ["weapon"] = {
        name = 'Weapon license', 
        icon = 'https://cdn.discordapp.com/attachments/979486375218937946/1135638696289382400/gun-4-xxl.png',
        color = '#cc352a'
    },
    ["police"] = { 
        name = 'Badge LSPD',
        icon = 'assets/icons/police.png', 
        color = '#05224d'
    }
}
Config.GenreIdCard = {
    ["f"] = 'Women', 
    ["m"] = 'Men', 
}

--╚════════════════════════════════════════════════════════════════════════════════╝
--╔════════════════════════════════════════════════════════════════════════════════╗

-- ██╗     ██████╗     ██████╗ ██╗  ██╗ ██████╗ ███╗   ██╗███████╗
-- ██║     ██╔══██╗    ██╔══██╗██║  ██║██╔═══██╗████╗  ██║██╔════╝
-- ██║     ██████╔╝    ██████╔╝███████║██║   ██║██╔██╗ ██║█████╗  
-- ██║     ██╔══██╗    ██╔═══╝ ██╔══██║██║   ██║██║╚██╗██║██╔══╝  
-- ███████╗██████╔╝    ██║     ██║  ██║╚██████╔╝██║ ╚████║███████╗
-- ╚══════╝╚═════╝     ╚═╝     ╚═╝  ╚═╝ ╚═════╝ ╚═╝  ╚═══╝╚══════╝
                                                               
-- LB Phone is unique with inventory
Config.ActivePhoneUnique = false
Config.ItemPhoneName = 'phone'

--╚════════════════════════════════════════════════════════════════════════════════╝
--╔════════════════════════════════════════════════════════════════════════════════╗

-- ██████╗  ██████╗  ██████╗ ███╗   ███╗██████╗  ██████╗ ██╗  ██╗
-- ██╔══██╗██╔═══██╗██╔═══██╗████╗ ████║██╔══██╗██╔═══██╗╚██╗██╔╝
-- ██████╔╝██║   ██║██║   ██║██╔████╔██║██████╔╝██║   ██║ ╚███╔╝ 
-- ██╔══██╗██║   ██║██║   ██║██║╚██╔╝██║██╔══██╗██║   ██║ ██╔██╗ 
-- ██████╔╝╚██████╔╝╚██████╔╝██║ ╚═╝ ██║██████╔╝╚██████╔╝██╔╝ ██╗
-- ╚═════╝  ╚═════╝  ╚═════╝ ╚═╝     ╚═╝╚═════╝  ╚═════╝ ╚═╝  ╚═╝
                                                              
-- Boombox with inventory
Config.ActiveBoombox = true
Config.BoomboxItem = 'boombox'

Config.MaxDistance = 40
Config.MinDistance = 0

Config.MaxVolume = 100
Config.MinVolume = 0

function UseBoombox(source)
    return true -- use condition for vip (exemple)
end

--╔════════════════════════════════════════════════════════════════════════════════╗

-- ██╗      ██████╗  ██████╗ ████████╗
-- ██║     ██╔═══██╗██╔═══██╗╚══██╔══╝
-- ██║     ██║   ██║██║   ██║   ██║   
-- ██║     ██║   ██║██║   ██║   ██║   
-- ███████╗╚██████╔╝╚██████╔╝   ██║   
-- ╚══════╝ ╚═════╝  ╚═════╝    ╚═╝   
                      
Config.HandsupForLoot = false
Config.ActiveJobForLoot = true
Config.JobForLoot = {
    ['police'] = true,
    ['fbi'] = true,
}

--╚════════════════════════════════════════════════════════════════════════════════╝
--╔════════════════════════════════════════════════════════════════════════════════╗

-- ████████╗██████╗ ██╗   ██╗███╗   ██╗██╗  ██╗
-- ╚══██╔══╝██╔══██╗██║   ██║████╗  ██║██║ ██╔╝
--    ██║   ██████╔╝██║   ██║██╔██╗ ██║█████╔╝ 
--    ██║   ██╔══██╗██║   ██║██║╚██╗██║██╔═██╗ 
--    ██║   ██║  ██║╚██████╔╝██║ ╚████║██║  ██╗
--    ╚═╝   ╚═╝  ╚═╝ ╚═════╝ ╚═╝  ╚═══╝╚═╝  ╚═╝


Config.JustOwnerVehicle = false        

Config.saveTrunkCommand = 'saveTrunk'
Config.savingTimer = 5 -- minutes

Config.AutoDeleteTrunk = true -- remove all trunk with not owner
Config.CommandDeleteTrunk = 'deleteTrunk'

Config.AccountTrunkName = {
    ["cash"] = 'Money',
    ["bank"] = 'Bank', 
    ["black_money"] = 'Dirty Money',
}

Config.WeightVehicle = {
    [0] = 50, -- Compacts  
    [1] = 30, -- Sedans
    [2] = 40, -- SUVs
    [3] = 50, -- Coupes 
    [4] = 60, -- Muscle  
    [5] = 70, -- Sports Classics  
    [6] = 50, -- Sports  
    [7] = 50, -- Super  
    [8] = 10, -- Motorcycles  
    [9] = 50, -- Off-road 
    [10] = 500, -- Industrial  
    [11] = 130, -- Utility  
    [12] = 140, -- Vans  
    [13] = 5, -- Cycles  
    [14] = 10, -- Boats  
    [15] = 170, -- Helicopters  
    [16] = 250, -- Planes  
    [17] = 190, -- Service  
    [18] = 200, -- Emergency  
    [19] = 210, -- Military  
    [20] = 220, -- Commercial  
    [21] = 230, -- Trains  
    [22] = 150, -- Open Wheel
}

Config.WeaponDefaultWeight = 5
Config.WeaponWeight = {
    ["WEAPON_NIGHTSTICK"] = 1,
    ["WEAPON_STUNGUN"] = 1,
    ["WEAPON_FLASHLIGHT"] = 1,
    ["WEAPON_ASSAULTRIFLE"] = 5,
    ["WEAPON_SMG"] = 3,
}

Config.ClothesWeight = {
    ["top"] = 0.8,
    ["pants"] = 0.5,
    ["outfit"] = 2,
    ["shoes"] = 0.5,
    ["bags"] = 1.5,
    ["glasses"] = 0.2,
    ["ears"] = 0.2,
    ["helmet"] = 0.4,
    ["bracelets"] = 0.1,
    ["watches"] = 0.1,
    ["chain"] = 0.1,
    ["mask"] = 0.4,
}

--╔════════════════════════════════════════════════════════════════════════════════╗
--  ██████╗ ██████╗  ██████╗ ██████╗
--  ██╔══██╗██╔══██╗██╔═══██╗██╔══██╗
--  ██║  ██║██████╔╝██║   ██║██████╔╝
--  ██║  ██║██╔══██╗██║   ██║██╔═══╝
--  ██████╔╝██║  ██║╚██████╔╝██║
--  ╚═════╝ ╚═╝  ╚═╝ ╚═════╝ ╚═╝
-- Drop-on-ground system (see client/custom/drop & server/custom/drop).
Config.Drop = {
    enabled = true,
    prop = 'prop_paper_bag01',       -- world prop used to represent a dropped stack
    pickupDistance = 1.6,            -- meters, checked both client-side (for the prompt) and server-side (anti-cheat)
    despawnTime = 5 * 60 * 1000,     -- ms a drop stays on the ground before auto-despawning (5 min)
    maxStacksOnGround = 200,         -- hard ceiling so a griefer can't spam-drop and crash everyone's client
}

--╔════════════════════════════════════════════════════════════════════════════════╗
--  ██████╗  █████╗ ███╗   ██╗██╗  ██╗
--  ██╔══██╗██╔══██╗████╗  ██║██║ ██╔╝
--  ██████╔╝███████║██╔██╗ ██║█████╔╝
--  ██╔══██╗██╔══██║██║╚██╗██║██╔═██╗
--  ██║  ██║██║  ██║██║ ╚████║██║  ██╗
--  ╚═╝  ╚═╝╚═╝  ╚═╝╚═╝  ╚═══╝╚═╝  ╚═╝
-- Item rank/quality (colored glow in the NUI). Anything not listed here
-- falls back to Config.DefaultItemRank. Ranks are purely cosmetic - they
-- don't change weight, price or usability, only the border/glow color
-- and the sort order used by the "Sort by rank" button in the UI.
-- Valid ranks (in ascending order): common, uncommon, rare, epic, legendary
Config.DefaultItemRank = 'common'
Config.ItemRanks = {
    -- example real entries - rename to match your own `items` table:
    -- ['lockpick']        = 'uncommon',
    -- ['diamond']         = 'epic',
    -- ['golden_watch']    = 'legendary',
    ['WEAPON_PISTOL']      = 'uncommon',
    ['WEAPON_COMBATPISTOL']= 'rare',
    ['WEAPON_ASSAULTRIFLE']= 'epic',
    ['WEAPON_RPG']         = 'legendary',
}

-- Ordering used by the "Sort by rank" button (low -> high). Also used to
-- resolve the CSS class + color applied to an item's border/glow.
Config.RankOrder = {'common', 'uncommon', 'rare', 'epic', 'legendary'}

-- Free-standing helper, safe to call from anywhere `config/*.lua` has
-- already loaded (shared_scripts, so it exists client AND server side).
function Config.GetItemRank(name)
    if not name then return Config.DefaultItemRank end
    return Config.ItemRanks[name] or Config.DefaultItemRank
end

--╚════════════════════════════════════════════════════════════════════════════════╝


--╔════════════════════════════════════════════════════════════════════════════════╗
--  ██╗    ██╗███████╗ █████╗ ██████╗  ██████╗ ███╗   ██╗
--  ██║    ██║██╔════╝██╔══██╗██╔══██╗██╔═══██╗████╗  ██║
--  ██║ █╗ ██║█████╗  ███████║██████╔╝██║   ██║██╔██╗ ██║
--  ██║███╗██║██╔══╝  ██╔══██║██╔═══╝ ██║   ██║██║╚██╗██║
--  ╚███╔███╔╝███████╗██║  ██║██║     ╚██████╔╝██║ ╚████║
--   ╚══╝╚══╝ ╚══════╝╚═╝  ╚═╝╚═╝      ╚═════╝ ╚═╝  ╚═══╝
-- Jobs allowed to run a "Scan Serial" check on a weapon (see the new
-- 'esx_inventory:scanWeapon' event / the context-menu "Scan" action).
Config.PoliceJobs = {'police', 'sheriff'}

-- Per-weapon legality. Anything not listed defaults to
-- Config.WeaponLegalDefault. Purely informational (shown to police on
-- scan) - doesn't stop the player from carrying/using it.
Config.WeaponLegalDefault = true
Config.WeaponLegality = {
    ['WEAPON_PISTOL']       = true,
    ['WEAPON_KNIFE']        = true,
    ['WEAPON_COMBATPISTOL'] = false,
    ['WEAPON_ASSAULTRIFLE'] = false,
    ['WEAPON_RPG']          = false,
}

-- Sound played when equipping/holstering a weapon, grouped by class so you
-- don't have to list every single weapon name. Uses PlaySoundFrontend with
-- GTA's built-in sound sets, so no extra audio files are required. Swap
-- these for your own {name, set} pairs if you want a different feel per
-- class - an invalid name/set simply plays nothing, it never errors.
Config.WeaponClasses = {
    ['WEAPON_KNIFE'] = 'melee', ['WEAPON_BAT'] = 'melee', ['WEAPON_HAMMER'] = 'melee',
    ['WEAPON_PISTOL'] = 'pistol', ['WEAPON_PISTOL_MK2'] = 'pistol', ['WEAPON_COMBATPISTOL'] = 'pistol',
    ['WEAPON_MICROSMG'] = 'smg', ['WEAPON_SMG'] = 'smg',
    ['WEAPON_ASSAULTRIFLE'] = 'rifle', ['WEAPON_CARBINERIFLE'] = 'rifle',
    ['WEAPON_PUMPSHOTGUN'] = 'shotgun', ['WEAPON_SAWNOFFSHOTGUN'] = 'shotgun',
    ['WEAPON_RPG'] = 'heavy', ['WEAPON_GRENADE'] = 'heavy',
}
Config.WeaponDefaultClass = 'pistol'
Config.WeaponSounds = {
    ['melee']    = { equip = {name = 'Bag_Impact',      set = 'GTAO_FM_Events_Soundset'},     holster = {name = 'Weapon_Bag_Empty', set = 'GTAO_FM_Events_Soundset'} },
    ['pistol']   = { equip = {name = 'WEAPON_PURCHASE', set = 'HUD_AMMO_SHOP_SOUNDSET'},       holster = {name = 'SELECT',           set = 'HUD_FRONTEND_DEFAULT_SOUNDSET'} },
    ['smg']      = { equip = {name = 'WEAPON_PURCHASE', set = 'HUD_AMMO_SHOP_SOUNDSET'},       holster = {name = 'SELECT',           set = 'HUD_FRONTEND_DEFAULT_SOUNDSET'} },
    ['rifle']    = { equip = {name = 'WEAPON_PURCHASE', set = 'HUD_AMMO_SHOP_SOUNDSET'},       holster = {name = 'BACK',             set = 'HUD_FRONTEND_DEFAULT_SOUNDSET'} },
    ['shotgun']  = { equip = {name = 'WEAPON_PURCHASE', set = 'HUD_AMMO_SHOP_SOUNDSET'},       holster = {name = 'BACK',             set = 'HUD_FRONTEND_DEFAULT_SOUNDSET'} },
    ['heavy']    = { equip = {name = 'WEAPON_PURCHASE', set = 'HUD_AMMO_SHOP_SOUNDSET'},       holster = {name = 'BACK',             set = 'HUD_FRONTEND_DEFAULT_SOUNDSET'} },
}

function Config.GetWeaponClass(name)
    return (name and Config.WeaponClasses[name]) or Config.WeaponDefaultClass
end

--╚════════════════════════════════════════════════════════════════════════════════╝

--╔════════════════════════════════════════════════════════════════════════════════╗
-- Extra metadata for OWNED clothing items (item_vetement), keyed by
-- [componentType][key] where `key` is built by Config.ClotheValueKey()
-- below from the item's stored data table (dataInv.clothes2.value, shape
-- {[type..'_1']=drawableId, [type..'_2']=textureId}, per Config.Clothes
-- above) - e.g. tshirt drawable 15 / texture 0 -> key "15_0". Component
-- types match Config.Clothes above ('tshirt', 'torso', 'pants', ...).
-- Everything here is opt-in: an item with no entry just behaves like
-- before (common rank, not limited, not faction-locked, not "new").

-- `value` can be the raw data table already decoded from the DB, OR a
-- JSON string (some code paths hand this off before decoding) - this
-- normalizes both, and returns nil if it can't make sense of it (in
-- which case every Is/Get helper below just treats the item as unlocked/
-- common/not-new, same as an item with no config entry at all).
function Config.ClotheValueKey(componentType, value)
    if type(value) == 'string' then
        local ok, decoded = pcall(json.decode, value)
        if not ok or type(decoded) ~= 'table' then return nil end
        value = decoded
    end
    if type(value) ~= 'table' then return nil end
    local d, t = value[componentType .. '_1'], value[componentType .. '_2']
    if d == nil or t == nil then return nil end
    return tostring(d) .. '_' .. tostring(t)
end

-- Luxury/brand rank -> reuses the exact same rank/glow system as
-- Config.ItemRanks (see the rank block further up), just keyed
-- differently since a clothing "item" is a component+variant, not a
-- unique name.
Config.ClothesRanks = {
    -- ['torso'] = { ['5_0'] = 'legendary' }, -- torso, drawable 5, texture 0
}

-- Limited Edition: NOT purchasable through the normal in-game shop -
-- server/apps/system/clothes.lua blocks the buy request. The only way to
-- get one onto a player is the new
-- `exports.esx_inventory:grantLimitedCloth(source, type, drawable, texture, label)`
-- export, meant to be called by your event/seasonal-reward script.
Config.LimitedClothes = {
    -- ['bags'] = { ['12_3'] = true }, -- bags, drawable 12, texture 3
}

-- Faction-locked: only players whose job is in this list can BUY or WEAR
-- the item. Checked both at purchase time (server) and at equip time
-- (client, using the job the resource already knows about).
Config.ClothesFactionLock = {
    -- ['torso'] = { ['20_0'] = {'police', 'ambulance'} },
}

-- "New" tag: shown as a small badge in the shop listing and inventory for
-- N days after being added (Config.NewClothesDays), OR permanently if set
-- to `true` instead of a date. Stamp new items with os.time() when you add
-- them to your shop config.
Config.NewClothesDays = 7
Config.NewClothes = {
    -- ['pants'] = { ['44_0'] = os.time() },
}

function Config.GetClotheRank(componentType, value)
    local key = Config.ClotheValueKey(componentType, value)
    if key and Config.ClothesRanks[componentType] and Config.ClothesRanks[componentType][key] then
        return Config.ClothesRanks[componentType][key]
    end
    return Config.DefaultItemRank
end

function Config.IsClotheLimited(componentType, value)
    local key = Config.ClotheValueKey(componentType, value)
    return key ~= nil and Config.LimitedClothes[componentType] ~= nil and Config.LimitedClothes[componentType][key] == true
end

function Config.GetClotheFactionLock(componentType, value)
    local key = Config.ClotheValueKey(componentType, value)
    if key and Config.ClothesFactionLock[componentType] then
        return Config.ClothesFactionLock[componentType][key]
    end
    return nil
end

function Config.IsClotheNew(componentType, value)
    local key = Config.ClotheValueKey(componentType, value)
    if not key then return false end
    local stamp = Config.NewClothes[componentType] and Config.NewClothes[componentType][key]
    if stamp == nil then return false end
    if stamp == true then return true end
    return (os.time() - stamp) <= (Config.NewClothesDays * 86400)
end

--╚════════════════════════════════════════════════════════════════════════════════╝

--╚════════════════════════════════════════════════════════════════════════════════╝
