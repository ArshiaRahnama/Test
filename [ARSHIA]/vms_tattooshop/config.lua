Config = {}
Config.DistanceView = 8 -- Distance the marker will be visible
Config.DistanceAccess = 1.1 -- The distance in which it will be possible to take a seat by pressing the E key


-- █▀ █▀▄ ▄▀▄ █▄ ▄█ ██▀ █   █ ▄▀▄ █▀▄ █▄▀
-- █▀ █▀▄ █▀█ █ ▀ █ █▄▄ ▀▄▀▄▀ ▀▄▀ █▀▄ █ █

Config.Core = "ESX" -- "ESX" or "QBCore"
Config.CoreDefine = "esx:getSharedObject" -- matches this server's ESX init convention (used across all other resources)
-- @Config.CoreDefine - If you are using old ESX which is defined by the esx:getSharedObject trigger, enter it here but if you are using ESX Legacy or QB-Core, leave the "" and the script will complete the export itself to define the core
Config.CoreExport = function()
	return exports['es_extended']:getSharedObject()
	-- return exports['qb-core']:GetCoreObject()
end

Config.PlayerLoaded = 'esx:playerLoaded' -- its a trigger to load players tattoos
	-- ESX: "esx:playerLoaded"
	-- QBCore: "QBCore:Client:OnPlayerLoaded"

Config.PlayerLogout = 'esx:onPlayerLogout' -- its a trigger to unload players tattoos
	-- ESX: "esx:onPlayerLogout"
	-- QBCore: "QBCore:Client:OnPlayerUnload"

Config.JobUpdated = 'esx:setJob' -- its a trigger to check players job
	-- ESX: "esx:setJob"
	-- QBCore: "QBCore:Client:OnJobUpdate"


-- @ Config.SkinMenu = "" -- you don't need to fill anything if you use esx_skin or fivem-appearance for ESX
-- @ Config.SkinMenu = "qb-clothes" -- if you use qb-clothes
-- @ Config.SkinMenu = "fivem-appearance" -- if you use fivem-appearance on qb-core
Config.SkinMenu = ""

Config.LiesAnims = {
    frontAnimDict = "amb@world_human_sunbathe@male@front@base",
    frontAnim = "base",
    backAnimDict = "switch@trevor@annoys_sunbathers",
    backAnim = "trev_annoys_sunbathers_loop_girl",
}

Config.StartingCam = {vec(.0, -.2, 0.4), vec(.0, -.205, -0.6)}

Config.Notification = function(message, time, type)
    -- vms_notify isn't installed on this server; use this server's existing notification systems instead
    if Config.Core == "ESX" then
        ESX.ShowNotification(message)
    elseif Config.Core == "QBCore" then
        QBCore.Functions.Notify(message, type or "primary", time)
    end
end

Config.TextUI_Enabled = false
Config.TextUI_Open = function(msg)
    lib.showTextUI(msg) -- this server uses ox_lib for TextUI
end
Config.TextUI_Close = function()
    lib.hideTextUI() -- this server uses ox_lib for TextUI
end

Config.Blip = {
    ["Sprite"] = 75,
    ["Scale"] = 0.6,
    ["Color"] = 1,
    ["Display"] = 4
}

Config.Tattooshops = {
    { -- Innocence Blvd | El Burro Heights
        business = false, -- If you want the player to be a tattoo shop employee set true
		ownerJob = "", -- If business is on true, here you must specify the work that has in this salon to manage
        pedModel = nil, -- If business is on false you can add a ped who will take care of the customer (only stands, for attractiveness and realism). If you set nil, the peda will not be.
        pedHeadingToChair = 197.46, -- Heading a player who will lie on his stomach
		pedHeadingToChairBack = 22.31, -- Heading a player who will be lying on his back
        position = vector3(1323.27, -1652.07, 51.28), -- Blip coordinates
        tattooPedSpawnPos = vector4(1327.66, -1654.03, 51.28, 42.35), -- If you have set pedModel here are the coords in which the ped spawns and goes to the player
        takeSitMarker = {
            FreeColor = {126, 0, 0, 255}, -- RGBA color, if the seat is free
            BusyColor = {126, 0, 0, 255}, -- RGBA color, if the seat is busy
        },
        Chairs = {
            [1] = {
                position = vector3(1320.64, -1653.94, 51.28), -- Marker coordinate to take a seat
                tattooerPos = vector4(1321.84, -1654.83, 51.28, 143.44), -- Coordinates of the ped or employee in which he will stand to tattoo the customer
                chair_coord = vector4(1321.13, -1655.12, 51.9, 22.31), -- Seat coordinates
                busy = false, -- DO NOT CHANGE IT
            },
        }
    },
    { -- Vinewood Blvd | Downtown Vinewood
        business = false,
		ownerJob = "",
        pedModel = nil,
        pedHeadingToChair = 328.24,
		pedHeadingToChairBack = 142.55,
        position = vector3(321.61, 182.82, 102.59),
        tattooPedSpawnPos = vector4(321.22, 184.9, 102.59, 166.42),
        takeSitMarker = {
            FreeColor = {126, 0, 0, 255},
            BusyColor = {126, 0, 0, 255},
        },
        Chairs = {
            [1] = {
                position = vector3(324.74, 179.39, 102.59),
                tattooerPos = vector4(324.97, 179.58, 102.59, 320.43),
                chair_coord = vector4(325.83, 180.63, 103.21, 142.55),
                busy = false,
            },
        }
    },
    { -- Great Ocean Hwy | Chumash
        business = false,
		ownerJob = "",
        pedModel = nil,
        pedHeadingToChair = 47.38,
		pedHeadingToChairBack = 227.38,
        position = vector3(-3169.77, 1076.14, 19.83), -- coords of blip
        tattooPedSpawnPos = vector4(-3174.33, 1074.58, 19.83, 251.8),
        takeSitMarker = {
            FreeColor = {126, 0, 0, 255},
            BusyColor = {126, 0, 0, 255},
        },
        Chairs = {
            [1] = {
                position = vector3(-3168.68, 1077.88, 19.83),
                tattooerPos = vector4(-3168.82, 1078.09, 19.83, 52.15),
                chair_coord = vector4(-3169.75, 1078.94, 20.46, 227.38),
                busy = false,
            },
        }
    },
    { -- Aguja St | Bay City Ave, Vespucci Canals
        business = false,
		ownerJob = "",
        pedModel = nil,
        pedHeadingToChair = 192.95,
		pedHeadingToChairBack = 16.03,
        position = vector3(-1154.23, -1426.1, 3.95), -- coords of blip
        tattooPedSpawnPos = vector4(-1149.71, -1427.26, 3.95, 39.5),
        takeSitMarker = {
            FreeColor = {126, 0, 0, 255},
            BusyColor = {126, 0, 0, 255},
        },
        Chairs = {
            [1] = {
                position = vector3(-1156.21, -1427.18, 3.95),
                tattooerPos = vector4(-1156.22, -1427.28, 3.95, 187.62),
                chair_coord = vector4(-1155.87, -1428.75, 4.58, 16.03),
                busy = false,
            },
        }
    },
}

Config.ClothesOff = {
	-- [[ FOR ESX Clothes ]]
	["male"] = {
		sex 	 = 0,
    	arms     = 15,
    	tshirt_1 = 15, 	tshirt_2 = 0,
    	torso_1  = 91, 	torso_2  = 0,
    	pants_1  = 14, 	pants_2  = 0,
    	shoes_1  = 34, 	shoes_2  = 0,
	},
	["female"] = {
		sex 	 = 1,
    	arms     = 15,
    	tshirt_1 = 34, 	tshirt_2 = 0,
    	torso_1  = 101, torso_2  = 1,
    	pants_1  = 16, 	pants_2  = 0,
    	shoes_1  = 0, 	shoes_2  = 0,
	},
	-- [[ FOR QBCore Clothes ]]
	-- ["male"] = {
	-- 	outfitData = {
	-- 		['t-shirt'] = {item = 15, texture = 0},
	-- 		['torso2'] = {item = 15, texture = 0},
	-- 		['arms'] = {item = 15, texture = 0},
	-- 		['pants'] = {item = 14, texture = 1},
	-- 		['shoes'] = {item = 34, texture = 0},
	-- 		['hat'] = {item = -1, texture = -1},
	-- 		['glass'] = {item = 0, texture = 0},
	-- 		['mask'] = {item = 0, texture = 0}
	-- 	}
	-- },
	-- ["female"] = {
	-- 	outfitData ={
	-- 		['t-shirt'] = {item = 34, texture = 0},
	-- 		['torso2'] = {item = 101, texture = 1},
	-- 		['arms'] = {item = 0, texture = 0},
	-- 		['pants'] = {item = 16, texture = 0},
	-- 		['shoes'] = {item = 1, texture = 0},
	-- 		['hat'] = {item = -1, texture = -1},
	-- 		['glass'] = {item = 0, texture = 0},
	-- 		['mask'] = {item = 0, texture = 0}
	-- 	}
	-- }
}

Config.Lang = "EN"
Config.Translate = {
    ["EN"] = {
        ["tattoo_blip"] = "Tattoo Shop",
        ["take_a_sit"] = "Press ~INPUT_CONTEXT~ to take a seat",
        ["get_up"] = "Press ~INPUT_VEH_DUCK~ to get up",
        ["open_tattooshop"] = "Press ~INPUT_CONTEXT~ to tend to the customer",
        ["paid"] = "You paid $%s for the tattoo.",
        ["nomoney"] = "You don't have enough money.",
        ["started_tattooing"] = "The tattoo artist has started tattooing you.",
		["removing_tattooing"] = "The tattoo has been removed from your skin.",
    },
    ["PL"] = {
        ["tattoo_blip"] = "Salon tatuaży",
        ["take_a_sit"] = "Połóż się", -- if textui is disabled then you will use ESX.ShowHelpNotification, set this:      "Press ~INPUT_CONTEXT~ to take a sit"
        ["get_up"] = "Naciśnij ~INPUT_VEH_DUCK~ aby wstać",
        ["open_tattooshop"] = "Klient", -- if textui is disabled then you will use ESX.ShowHelpNotification, set this:      "Press ~INPUT_CONTEXT~ to open menu"
        ["paid"] = "Zapłacono %s$ za tatuaż.",
        ["nomoney"] = "Nie posiadasz wystarczająco pieniędzy.",
		["started_tattooing"] = "Tatuażysta wytatuował Ci nowy wzór.",
		["removing_tattooing"] = "Tatuażysta usunął tatuaż z Twojej skóry.",
    },
}

if not IsDuplicityVersion() then
Config.TattooList = {
	mpbusiness_overlays = { -- 1
  		{label = GetLabelText("TAT_BUS_005"), nameHash = 'MP_Buis_M_Neck_000', price = 500, removePrice = 750, anim = "BACK", camera = {vec(.1, -0.55, -0.35), vec(.1, -0.555, -0.6)}},
		{label = GetLabelText("TAT_BUS_006"), nameHash = 'MP_Buis_M_Neck_001', price = 500, removePrice = 750, anim = "BACK", camera = {vec(.15, -0.58, -0.43), vec(.1, -0.585, -0.6)}},
		{label = GetLabelText("TAT_BUS_007"), nameHash = 'MP_Buis_M_Neck_002', price = 500, removePrice = 750, anim = "FRONT", camera = {vec(-.25, 0.725, -0.43), vec(-.05, 0.61, -0.6)}},
		{label = GetLabelText("TAT_BUS_008"), nameHash = 'MP_Buis_M_Neck_003', price = 500, removePrice = 750, anim = "FRONT", camera = {vec(-.05, 0.6, -0.3), vec(-.05, 0.61, -0.6)}},
		{label = GetLabelText("TAT_BUS_003"), nameHash = 'MP_Buis_M_LeftArm_000', price = 500, removePrice = 750, anim = "FRONT", camera = {vec(-.12, 0.6, -0.68), vec(-.12, 0.65, -0.725)}},
		{label = GetLabelText("TAT_BUS_004"), nameHash = 'MP_Buis_M_LeftArm_001', price = 500, removePrice = 750, anim = "BACK", camera = {vec(-0.7, -0.4, -0.88), vec(-0.2, -0.21, -0.8)}},
		{label = GetLabelText("TAT_BUS_009"), nameHash = 'MP_Buis_M_RightArm_000', price = 500, removePrice = 750, anim = "FRONT", camera = {vec(0.55, 0.78, -0.7), vec(0.2, 0.21, -0.6)}},
		{label = GetLabelText("TAT_BUS_010"), nameHash = 'MP_Buis_M_RightArm_001', price = 500, removePrice = 750, anim = "FRONT", camera = {vec(.035, 0.6, -0.625), vec(.075, 0.61, -0.75)}},
		{label = GetLabelText("TAT_BUS_011"), nameHash = 'MP_Buis_M_Stomach_000', price = 500, removePrice = 750, anim = "BACK", camera = {vec(.1, -.4, -0.1), vec(.1, -.41, -0.6)}},
		{label = GetLabelText("TAT_BUS_001"), nameHash = 'MP_Buis_M_Chest_000', price = 500, removePrice = 750, anim = "BACK", camera = {vec(.1, -.4, -0.1), vec(.1, -.41, -0.6)}},
		{label = GetLabelText("TAT_BUS_002"), nameHash = 'MP_Buis_M_Chest_001', price = 500, removePrice = 750, anim = "BACK", camera = {vec(.1, -.4, -0.1), vec(.1, -.41, -0.6)}},
		{label = GetLabelText("TAT_BUS_000"), nameHash = 'MP_Buis_M_Back_000', price = 500, removePrice = 750, anim = "FRONT", camera = {vec(-.05, 0.4, -0.1), vec(-.05, 0.41, -0.6)}},
		{label = GetLabelText("TAT_BUS_F_002"), nameHash = 'MP_Buis_F_Chest_000', price = 500, removePrice = 750, anim = "BACK", camera = {vec(.1, -.4, -0.1), vec(.1, -.41, -0.6)}},
		{label = GetLabelText("TAT_BUS_F_003"), nameHash = 'MP_Buis_F_Chest_001', price = 500, removePrice = 750, anim = "BACK", camera = {vec(.1, -.4, -0.1), vec(.1, -.41, -0.6)}},
		{label = GetLabelText("TAT_BUS_F_004"), nameHash = 'MP_Buis_F_Chest_002', price = 500, removePrice = 750, anim = "BACK", camera = {vec(.1, -.4, -0.1), vec(.1, -.41, -0.6)}},
		{label = GetLabelText("TAT_BUS_F_011"), nameHash = 'MP_Buis_F_Stom_000', price = 500, removePrice = 750, anim = "BACK", camera = {vec(.1, -.4, -0.1), vec(.1, -.41, -0.6)}},
		{label = GetLabelText("TAT_BUS_F_012"), nameHash = 'MP_Buis_F_Stom_001', price = 500, removePrice = 750, anim = "BACK", camera = {vec(.1, -.4, -0.1), vec(.1, -.41, -0.6)}},
		{label = GetLabelText("TAT_BUS_F_013"), nameHash = 'MP_Buis_F_Stom_002', price = 500, removePrice = 750, anim = "BACK", camera = {vec(.1, -.4, -0.1), vec(.1, -.41, -0.6)}},
		{label = GetLabelText("TAT_BUS_F_000"), nameHash = 'MP_Buis_F_Back_000', price = 500, removePrice = 750, anim = "FRONT", camera = {vec(-.05, 0.4, -0.1), vec(-.05, 0.41, -0.6)}},
		{label = GetLabelText("TAT_BUS_F_001"), nameHash = 'MP_Buis_F_Back_001', price = 500, removePrice = 750, anim = "FRONT", camera = {vec(-.05, 0.4, -0.1), vec(-.05, 0.41, -0.6)}},
		{label = GetLabelText("TAT_BUS_F_007"), nameHash = 'MP_Buis_F_Neck_000', price = 500, removePrice = 750, anim = "BACK", camera = {vec(.35, -0.75, -0.785), vec(.05, -0.68, -0.785)}},
		{label = GetLabelText("TAT_BUS_F_008"), nameHash = 'MP_Buis_F_Neck_001', price = 500, removePrice = 750, anim = "BACK", camera = {vec(-.35, -0.6, -0.785), vec(.05, -0.5, -0.785)}},
		{label = GetLabelText("TAT_BUS_F_009"), nameHash = 'MP_Buis_F_RArm_000', price = 500, removePrice = 750, anim = "FRONT", camera = {vec(.035, 0.6, -0.625), vec(.075, 0.61, -0.75)}},
		{label = GetLabelText("TAT_BUS_F_005"), nameHash = 'MP_Buis_F_LArm_000', price = 500, removePrice = 750, anim = "FRONT", camera = {vec(-.12, 0.6, -0.68), vec(-.12, 0.65, -0.725)}},
		{label = GetLabelText("TAT_BUS_F_006"), nameHash = 'MP_Buis_F_LLeg_000', price = 500, removePrice = 750, anim = "FRONT", camera = {vec(-.05, -0.55, -0.25), vec(-.05, -0.525, -0.6)}},
		{label = GetLabelText("TAT_BUS_F_010"), nameHash = 'MP_Buis_F_RLeg_000', price = 500, removePrice = 750, anim = "FRONT", camera = {vec(-.05, -0.55, -0.25), vec(-.05, -0.525, -0.6)}},
	},
	mphipster_overlays = { -- 2
		{label = GetLabelText("TAT_HP_000"), nameHash = 'FM_Hip_M_Tat_000', price = 500, removePrice = 750, anim = "FRONT", camera = {vec(-.05, 0.4, -0.1), vec(-.05, 0.41, -0.6)}},
		{label = GetLabelText("TAT_HP_001"), nameHash = 'FM_Hip_M_Tat_001', price = 500, removePrice = 750, anim = "FRONT", camera = {vec(0.7, 0.48, -0.83), vec(0.2, 0.47, -0.68)}},
		{label = GetLabelText("TAT_HP_002"), nameHash = 'FM_Hip_M_Tat_002', price = 500, removePrice = 750, anim = "BACK", camera = {vec(-.1, -.5, -0.32), vec(-.1, -.505, -0.6)}},
		{label = GetLabelText("TAT_HP_003"), nameHash = 'FM_Hip_M_Tat_003', price = 500, removePrice = 750, anim = "BACK", camera = {vec(-0.9, -0.1, -0.8), vec(-0.2, -0.3, -0.69)}},
		{label = GetLabelText("TAT_HP_004"), nameHash = 'FM_Hip_M_Tat_004', price = 500, removePrice = 750, anim = "FRONT", camera = {vec(.035, 0.6, -0.625), vec(.075, 0.61, -0.75)}},
		{label = GetLabelText("TAT_HP_005"), nameHash = 'FM_Hip_M_Tat_005', price = 500, removePrice = 750, anim = "BACK", camera = {vec(-.35, -0.67, -0.765), vec(-.05, -0.51, -0.785)}},
		{label = GetLabelText("TAT_HP_006"), nameHash = 'FM_Hip_M_Tat_006', price = 500, removePrice = 750, anim = "BACK", camera = {vec(0.7, -.38, -0.76), vec(0.2, -.39, -0.6)}},
		{label = GetLabelText("TAT_HP_007"), nameHash = 'FM_Hip_M_Tat_007', price = 500, removePrice = 750, anim = "BACK", camera = {vec(-.225, -0.28, -0.35), vec(-.15, -0.285, -0.6)}},
		{label = GetLabelText("TAT_HP_008"), nameHash = 'FM_Hip_M_Tat_008', price = 500, removePrice = 750, anim = "FRONT", camera = {vec(0.485, 0.88, -0.7), vec(0.2, 0.21, -0.6)}},
		{label = GetLabelText("TAT_HP_009"), nameHash = 'FM_Hip_M_Tat_009', price = 500, removePrice = 750, anim = "FRONT", camera = {vec(-.05, -0.55, -0.25), vec(-.05, -0.525, -0.6)}},
		{label = GetLabelText("TAT_HP_010"), nameHash = 'FM_Hip_M_Tat_010', price = 500, removePrice = 750, anim = "BACK", camera = {vec(.225, -0.28, -0.35), vec(.15, -0.285, -0.6)}},
		{label = GetLabelText("TAT_HP_011"), nameHash = 'FM_Hip_M_Tat_011', price = 500, removePrice = 750, anim = "FRONT", camera = {vec(-.08, 0.5, -0.4), vec(-.08, 0.51, -0.6)}},
		{label = GetLabelText("TAT_HP_012"), nameHash = 'FM_Hip_M_Tat_012', price = 500, removePrice = 750, anim = "FRONT", camera = {vec(-.08, 0.5, -0.3), vec(-.08, 0.51, -0.6)}},
		{label = GetLabelText("TAT_HP_013"), nameHash = 'FM_Hip_M_Tat_013', price = 500, removePrice = 750, anim = "BACK", camera = {vec(.1, -.4, -0.1), vec(.1, -.41, -0.6)}},
		{label = GetLabelText("TAT_HP_014"), nameHash = 'FM_Hip_M_Tat_014', price = 500, removePrice = 750, anim = "BACK", camera = {vec(.4, -.4, -0.18), vec(.2, -.41, -0.6)}},
		{label = GetLabelText("TAT_HP_015"), nameHash = 'FM_Hip_M_Tat_015', price = 500, removePrice = 750, anim = "FRONT", camera = {vec(.05, 0.5, -1.0), vec(-.3, 0.66, -0.7)}},
		{label = GetLabelText("TAT_HP_016"), nameHash = 'FM_Hip_M_Tat_016', price = 500, removePrice = 750, anim = "FRONT", camera = {vec(-.12, 0.6, -0.68), vec(-.12, 0.65, -0.725)}},
		{label = GetLabelText("TAT_HP_019"), nameHash = 'FM_Hip_M_Tat_019', price = 500, removePrice = 750, anim = "FRONT", camera = {vec(-.05, -0.55, -0.25), vec(-.05, -0.525, -0.6)}},
		{label = GetLabelText("TAT_HP_021"), nameHash = 'FM_Hip_M_Tat_021', price = 500, removePrice = 750, anim = "BACK", camera = {vec(.15, -0.58, -0.43), vec(.1, -0.585, -0.6)}},
		{label = GetLabelText("TAT_HP_023"), nameHash = 'FM_Hip_M_Tat_023', price = 500, removePrice = 750, anim = "BACK", camera = {vec(.225, -0.28, -0.35), vec(.15, -0.285, -0.6)}},
		{label = GetLabelText("TAT_HP_024"), nameHash = 'FM_Hip_M_Tat_024', price = 500, removePrice = 750, anim = "FRONT", camera = {vec(.05, 0.5, -0.2), vec(.05, 0.51, -0.6)}},
		{label = GetLabelText("TAT_HP_025"), nameHash = 'FM_Hip_M_Tat_025', price = 500, removePrice = 750, anim = "FRONT", camera = {vec(-.1, 0.5, -0.2), vec(-.1, 0.51, -0.6)}},
		{label = GetLabelText("TAT_HP_026"), nameHash = 'FM_Hip_M_Tat_026', price = 500, removePrice = 750, anim = "FRONT", camera = {vec(-0.4, 0.88, -0.78), vec(-0.2, 0.21, -0.65)}},
		{label = GetLabelText("TAT_HP_028"), nameHash = 'FM_Hip_M_Tat_028', price = 500, removePrice = 750, anim = "BACK", camera = {vec(-0.75, .0, -0.944), vec(-0.2, -0.451, -0.6)}},
		{label = GetLabelText("TAT_HP_029"), nameHash = 'FM_Hip_M_Tat_029', price = 500, removePrice = 750, anim = "BACK", camera = {vec(-.17, -0.25, -0.435), vec(-.17, -0.255, -0.6)}},
		{label = GetLabelText("TAT_HP_030"), nameHash = 'FM_Hip_M_Tat_030', price = 500, removePrice = 750, anim = "FRONT", camera = {vec(-.08, 0.2, -0.45), vec(-.08, 0.21, -0.6)}},
		{label = GetLabelText("TAT_HP_031"), nameHash = 'FM_Hip_M_Tat_031', price = 500, removePrice = 750, anim = "FRONT", camera = {vec(-.08, 0.5, -0.4), vec(-.08, 0.51, -0.6)}},
		{label = GetLabelText("TAT_HP_032"), nameHash = 'FM_Hip_M_Tat_032', price = 500, removePrice = 750, anim = "FRONT", camera = {vec(-.01, 0.5, -0.3), vec(-.01, 0.51, -0.6)}},
		{label = GetLabelText("TAT_HP_033"), nameHash = 'FM_Hip_M_Tat_033', price = 500, removePrice = 750, anim = "BACK", camera = {vec(.1, -.4, -0.1), vec(.1, -.41, -0.6)}},
		{label = GetLabelText("TAT_HP_034"), nameHash = 'FM_Hip_M_Tat_034', price = 500, removePrice = 750, anim = "BACK", camera = {vec(-.12, -0.25, -0.35), vec(-.12, -0.255, -0.6)}},
		{label = GetLabelText("TAT_HP_035"), nameHash = 'FM_Hip_M_Tat_035', price = 500, removePrice = 750, anim = "BACK", camera = {vec(-.12, -0.25, -0.35), vec(-.12, -0.255, -0.6)}},
		{label = GetLabelText("TAT_HP_036"), nameHash = 'FM_Hip_M_Tat_036', price = 500, removePrice = 750, anim = "FRONT", camera = {vec(0.4, 0.88, -0.78), vec(0.2, 0.21, -0.65)}},
		{label = GetLabelText("TAT_HP_037"), nameHash = 'FM_Hip_M_Tat_037', price = 500, removePrice = 750, anim = "FRONT", camera = {vec(-0.4, 0.88, -0.78), vec(-0.2, 0.21, -0.65)}},
		{label = GetLabelText("TAT_HP_038"), nameHash = 'FM_Hip_M_Tat_038', price = 500, removePrice = 750, anim = "FRONT", camera = {vec(.55, -0.65, -0.65), vec(-.05, -0.625, -0.65)}},
		{label = GetLabelText("TAT_HP_039"), nameHash = 'FM_Hip_M_Tat_039', price = 500, removePrice = 750, anim = "BACK", camera = {vec(-0.86, -0.35, -0.5), vec(-0.2, -0.36, -0.7)}},
		{label = GetLabelText("TAT_HP_040"), nameHash = 'FM_Hip_M_Tat_040', price = 500, removePrice = 750, anim = "FRONT", camera = {vec(-.05, -0.55, -0.25), vec(-.05, -0.525, -0.6)}},
		{label = GetLabelText("TAT_HP_041"), nameHash = 'FM_Hip_M_Tat_041', price = 500, removePrice = 750, anim = "FRONT", camera = {vec(-.12, 0.25, -0.35), vec(-.12, 0.255, -0.6)}},
		{label = GetLabelText("TAT_HP_042"), nameHash = 'FM_Hip_M_Tat_042', price = 500, removePrice = 750, anim = "FRONT", camera = {vec(-.25, -0.55, -0.25), vec(.0, -0.525, -0.6)}},
		{label = GetLabelText("TAT_HP_043"), nameHash = 'FM_Hip_M_Tat_043', price = 500, removePrice = 750, anim = "FRONT", camera =  {vec(-0.4, 0.88, -0.78), vec(-0.2, 0.21, -0.65)}},
		{label = GetLabelText("TAT_HP_044"), nameHash = 'FM_Hip_M_Tat_044', price = 500, removePrice = 750, anim = "FRONT", camera = {vec(0.4, 0.88, -0.78), vec(0.2, 0.21, -0.65)}},
		{label = GetLabelText("TAT_HP_045"), nameHash = 'FM_Hip_M_Tat_045', price = 500, removePrice = 750, anim = "BACK", camera = {vec(.3, -.46, -0.4), vec(.3, -.5, -0.6)}},
		{label = GetLabelText("TAT_HP_046"), nameHash = 'FM_Hip_M_Tat_046', price = 500, removePrice = 750, anim = "FRONT", camera = {vec(-.08, 0.5, -0.4), vec(-.08, 0.51, -0.6)}},
		{label = GetLabelText("TAT_HP_047"), nameHash = 'FM_Hip_M_Tat_047', price = 500, removePrice = 750, anim = "BACK", camera = {vec(.1, -.4, -0.1), vec(.1, -.41, -0.6)}},
		{label = GetLabelText("TAT_HP_048"), nameHash = 'FM_Hip_M_Tat_048', price = 500, removePrice = 750, anim = "BACK", camera = {vec(-.12, -0.25, -0.35), vec(-.12, -0.255, -0.6)}},
	},
	mpbiker_overlays = { -- 3
		{label = GetLabelText("TAT_BI_000"), nameHash = 'MP_MP_Biker_Tat_000_M', price = 500, removePrice = 750, anim = "BACK", camera = {vec(.11, -0.48, -0.35), vec(.11, -0.49, -0.6)}},
		{label = GetLabelText("TAT_BI_001"), nameHash = 'MP_MP_Biker_Tat_001_M', price = 500, removePrice = 750, anim = "BACK", camera = {vec(.0, -0.48, -0.35), vec(.0, -0.49, -0.6)}},
		{label = GetLabelText("TAT_BI_002"), nameHash = 'MP_MP_Biker_Tat_002_M', price = 500, removePrice = 750, anim = "BACK", camera = {vec(-.1, 0.41, 0.2), vec(-.1, 0.4, -0.6)}},
		{label = GetLabelText("TAT_BI_003"), nameHash = 'MP_MP_Biker_Tat_003_M', price = 500, removePrice = 750, anim = "BACK", camera = {vec(.1, -.4, -0.1), vec(.1, -.41, -0.6)}},
		{label = GetLabelText("TAT_BI_004"), nameHash = 'MP_MP_Biker_Tat_004_M', price = 500, removePrice = 750, anim = "BACK", camera = {vec(.17, 0.55, 0.12), vec(.17, 0.54, -0.6)}},
		{label = GetLabelText("TAT_BI_005"), nameHash = 'MP_MP_Biker_Tat_005_M', price = 500, removePrice = 750, anim = "BACK", camera = {vec(.0, -0.48, -0.35), vec(.0, -0.49, -0.6)}},
		{label = GetLabelText("TAT_BI_006"), nameHash = 'MP_MP_Biker_Tat_006_M', price = 500, removePrice = 750, anim = "FRONT", camera = {vec(-.05, 0.2, -0.3), vec(-.05, 0.21, -0.6)}},
		{label = GetLabelText("TAT_BI_007"), nameHash = 'MP_MP_Biker_Tat_007_M', price = 500, removePrice = 750, anim = "FRONT", camera = {vec(0.4, 0.88, -0.78), vec(0.2, 0.21, -0.65)}},
		{label = GetLabelText("TAT_BI_008"), nameHash = 'MP_MP_Biker_Tat_008_M', price = 500, removePrice = 750, anim = "FRONT", camera = {vec(-.05, 0.215, -0.15), vec(-.05, 0.365, -0.6)}},
		{label = GetLabelText("TAT_BI_009"), nameHash = 'MP_MP_Biker_Tat_009_M', price = 500, removePrice = 750, anim = "BACK", camera = {vec(-0.5, -0.65, -0.88), vec(-0.2, -0.645, -0.78)}},
		{label = GetLabelText("TAT_BI_010"), nameHash = 'MP_MP_Biker_Tat_010_M', price = 500, removePrice = 750, anim = "BACK", camera = {vec(.0, -0.28, -0.42), vec(.0, -0.285, -0.6)}},
		{label = GetLabelText("TAT_BI_011"), nameHash = 'MP_MP_Biker_Tat_011_M', price = 500, removePrice = 750, anim = "FRONT", camera = {vec(-.05, 0.215, -0.15), vec(-.05, 0.365, -0.6)}},
		{label = GetLabelText("TAT_BI_012"), nameHash = 'MP_MP_Biker_Tat_012_M', price = 500, removePrice = 750, anim = "BACK", camera = {vec(-.2, -0.25, -0.35), vec(-.2, -0.255, -0.6)}},
		{label = GetLabelText("TAT_BI_013"), nameHash = 'MP_MP_Biker_Tat_013_M', price = 500, removePrice = 750, anim = "BACK", camera = {vec(.0, -0.48, -0.35), vec(.0, -0.49, -0.6)}},
		{label = GetLabelText("TAT_BI_014"), nameHash = 'MP_MP_Biker_Tat_014_M', price = 500, removePrice = 750, anim = "FRONT", camera = {vec(0.4, 0.88, -0.78), vec(0.2, 0.21, -0.65)}},
		{label = GetLabelText("TAT_BI_015"), nameHash = 'MP_MP_Biker_Tat_015_M', price = 500, removePrice = 750, anim = "FRONT", camera = {vec(-.05, -0.55, -0.25), vec(-.05, -0.525, -0.6)}},
		{label = GetLabelText("TAT_BI_016"), nameHash = 'MP_MP_Biker_Tat_016_M', price = 500, removePrice = 750, anim = "FRONT", camera = {vec(-.415, 0.95, -0.63), vec(-.36, 0.56, -0.65)}},
		{label = GetLabelText("TAT_BI_017"), nameHash = 'MP_MP_Biker_Tat_017_M', price = 500, removePrice = 750, anim = "FRONT", camera = {vec(-.05, 0.215, -0.15), vec(-.05, 0.365, -0.6)}},
		{label = GetLabelText("TAT_BI_018"), nameHash = 'MP_MP_Biker_Tat_018_M', price = 500, removePrice = 750, anim = "BACK", camera = {vec(.0, -0.55, -0.35), vec(.0, -0.555, -0.6)}},
		{label = GetLabelText("TAT_BI_019"), nameHash = 'MP_MP_Biker_Tat_019_M', price = 500, removePrice = 750, anim = "BACK", camera = {vec(.0, -0.55, -0.35), vec(.0, -0.555, -0.6)}},
		{label = GetLabelText("TAT_BI_020"), nameHash = 'MP_MP_Biker_Tat_020_M', price = 500, removePrice = 750, anim = "FRONT", camera = {vec(-.415, 0.95, -0.63), vec(-.36, 0.56, -0.65)}},
		{label = GetLabelText("TAT_BI_021"), nameHash = 'MP_MP_Biker_Tat_021_M', price = 500, removePrice = 750, anim = "FRONT", camera = {vec(-.05, 0.215, -0.15), vec(-.05, 0.365, -0.6)}},
		{label = GetLabelText("TAT_BI_022"), nameHash = 'MP_MP_Biker_Tat_022_M', price = 500, removePrice = 750, anim = "FRONT", camera = {vec(-.05, -0.55, -0.25), vec(-.05, -0.525, -0.6)}},
		{label = GetLabelText("TAT_BI_023"), nameHash = 'MP_MP_Biker_Tat_023_M', price = 500, removePrice = 750, anim = "BACK", camera = {vec(.0, -0.48, -0.35), vec(.0, -0.49, -0.6)}},
		{label = GetLabelText("TAT_BI_024"), nameHash = 'MP_MP_Biker_Tat_024_M', price = 500, removePrice = 750, anim = "BACK", camera = {vec(-.7, -.4, -0.18), vec(-.2, -.41, -0.6)}},
		{label = GetLabelText("TAT_BI_025"), nameHash = 'MP_MP_Biker_Tat_025_M', price = 500, removePrice = 750, anim = "BACK", camera = {vec(-.7, -.4, -0.18), vec(-.2, -.41, -0.6)}},
		{label = GetLabelText("TAT_BI_026"), nameHash = 'MP_MP_Biker_Tat_026_M', price = 500, removePrice = 750, anim = "BACK", camera = {vec(.0, -0.48, -0.35), vec(.0, -0.49, -0.6)}},
		{label = GetLabelText("TAT_BI_027"), nameHash = 'MP_MP_Biker_Tat_027_M', price = 500, removePrice = 750, anim = "FRONT", camera = {vec(-.45, -0.55, -0.375), vec(-.05, -0.525, -0.6)}},
		{label = GetLabelText("TAT_BI_028"), nameHash = 'MP_MP_Biker_Tat_028_M', price = 500, removePrice = 750, anim = "FRONT", camera = {vec(.58, -0.5, -0.375), vec(.05, -0.525, -0.6)}},
		{label = GetLabelText("TAT_BI_029"), nameHash = 'MP_MP_Biker_Tat_029_M', price = 500, removePrice = 750, anim = "BACK", camera = {vec(.1, -0.55, -0.35), vec(.1, -0.555, -0.6)}},
		{label = GetLabelText("TAT_BI_030"), nameHash = 'MP_MP_Biker_Tat_030_M', price = 500, removePrice = 750, anim = "FRONT", camera = {vec(-.05, 0.215, -0.15), vec(-.05, 0.365, -0.6)}},
		{label = GetLabelText("TAT_BI_031"), nameHash = 'MP_MP_Biker_Tat_031_M', price = 500, removePrice = 750, anim = "BACK", camera = {vec(.1, -.4, -0.1), vec(.1, -.41, -0.6)}},
		{label = GetLabelText("TAT_BI_032"), nameHash = 'MP_MP_Biker_Tat_032_M', price = 500, removePrice = 750, anim = "BACK", camera = {vec(.0, -0.48, -0.35), vec(.0, -0.49, -0.6)}},
		{label = GetLabelText("TAT_BI_033"), nameHash = 'MP_MP_Biker_Tat_033_M', price = 500, removePrice = 750, anim = "FRONT", camera = {vec(0.485, 0.88, -0.7), vec(0.2, 0.21, -0.6)}},
		{label = GetLabelText("TAT_BI_034"), nameHash = 'MP_MP_Biker_Tat_034_M', price = 500, removePrice = 750, anim = "BACK", camera = {vec(-.1, -0.48, -0.35), vec(-.1, -0.49, -0.6)}},
		{label = GetLabelText("TAT_BI_035"), nameHash = 'MP_MP_Biker_Tat_035_M', price = 500, removePrice = 750, anim = "FRONT", camera = {vec(-0.435, 0.88, -0.7), vec(-0.2, 0.21, -0.6)}},
		{label = GetLabelText("TAT_BI_036"), nameHash = 'MP_MP_Biker_Tat_036_M', price = 500, removePrice = 750, anim = "FRONT", camera = {vec(-.05, -0.55, -0.25), vec(-.05, -0.525, -0.6)}},
		{label = GetLabelText("TAT_BI_037"), nameHash = 'MP_MP_Biker_Tat_037_M', price = 500, removePrice = 750, anim = "BACK", camera = {vec(-.1, 0.41, 0.2), vec(-.1, 0.4, -0.6)}},
		{label = GetLabelText("TAT_BI_038"), nameHash = 'MP_MP_Biker_Tat_038_M', price = 500, removePrice = 750, anim = "FRONT", camera = {vec(-.25, 0.725, -0.58), vec(-.05, 0.61, -0.6)}},
		{label = GetLabelText("TAT_BI_039"), nameHash = 'MP_MP_Biker_Tat_039_M', price = 500, removePrice = 750, anim = "BACK", camera = {vec(.1, -.4, -0.1), vec(.1, -.41, -0.6)}},
		{label = GetLabelText("TAT_BI_040"), nameHash = 'MP_MP_Biker_Tat_040_M', price = 500, removePrice = 750, anim = "BACK", camera = {vec(.15, 0.45, 0.32), vec(.15, 0.44, -0.6)}},
		{label = GetLabelText("TAT_BI_041"), nameHash = 'MP_MP_Biker_Tat_041_M', price = 500, removePrice = 750, anim = "BACK", camera = {vec(.0, -0.48, -0.35), vec(.0, -0.49, -0.6)}},
		{label = GetLabelText("TAT_BI_042"), nameHash = 'MP_MP_Biker_Tat_042_M', price = 500, removePrice = 750, anim = "BACK", camera = {vec(.7, -.4, -0.18), vec(.2, -.41, -0.6)}},
		{label = GetLabelText("TAT_BI_043"), nameHash = 'MP_MP_Biker_Tat_043_M', price = 500, removePrice = 750, anim = "FRONT", camera = {vec(-.05, 0.2, -0.3), vec(-.05, 0.21, -0.6)}},
		{label = GetLabelText("TAT_BI_044"), nameHash = 'MP_MP_Biker_Tat_044_M', price = 500, removePrice = 750, anim = "BACK", camera = {vec(-.1, 0.41, 0.2), vec(-.1, 0.4, -0.6)}},
		{label = GetLabelText("TAT_BI_045"), nameHash = 'MP_MP_Biker_Tat_045_M', price = 500, removePrice = 750, anim = "BACK", camera = {vec(-.7, -.4, -0.18), vec(-.2, -.41, -0.6)}},
		{label = GetLabelText("TAT_BI_046"), nameHash = 'MP_MP_Biker_Tat_046_M', price = 500, removePrice = 750, anim = "FRONT", camera = {vec(0.4, 0.88, -0.38), vec(0.2, 0.21, -0.65)}},
		{label = GetLabelText("TAT_BI_047"), nameHash = 'MP_MP_Biker_Tat_047_M', price = 500, removePrice = 750, anim = "BACK", camera = {vec(.7, -.4, -0.18), vec(.2, -.41, -0.6)}},
		{label = GetLabelText("TAT_BI_048"), nameHash = 'MP_MP_Biker_Tat_048_M', price = 500, removePrice = 750, anim = "FRONT", camera = {vec(.72, -0.49, -0.45), vec(-.05, -0.485, -0.6)}},
		{label = GetLabelText("TAT_BI_049"), nameHash = 'MP_MP_Biker_Tat_049_M', price = 500, removePrice = 750, anim = "FRONT", camera = {vec(0.4, 0.88, -0.78), vec(0.2, 0.21, -0.65)}},
		{label = GetLabelText("TAT_BI_050"), nameHash = 'MP_MP_Biker_Tat_050_M', price = 500, removePrice = 750, anim = "BACK", camera = {vec(.0, -0.48, -0.35), vec(.0, -0.49, -0.6)}},
		{label = GetLabelText("TAT_BI_051"), nameHash = 'MP_MP_Biker_Tat_051_M', price = 500, removePrice = 750, anim = "BACK", camera = {vec(.15, -0.58, -0.43), vec(.1, -0.585, -0.6)}},
		{label = GetLabelText("TAT_BI_052"), nameHash = 'MP_MP_Biker_Tat_052_M', price = 500, removePrice = 750, anim = "BACK", camera = {vec(.1, -.4, -0.1), vec(.1, -.41, -0.6)}},
		{label = GetLabelText("TAT_BI_053"), nameHash = 'MP_MP_Biker_Tat_053_M', price = 500, removePrice = 750, anim = "BACK", camera = {vec(-.2, -0.25, -0.35), vec(-.2, -0.255, -0.6)}},
		{label = GetLabelText("TAT_BI_054"), nameHash = 'MP_MP_Biker_Tat_054_M', price = 500, removePrice = 750, anim = "FRONT", camera = {vec(0.4, 0.88, -0.78), vec(0.2, 0.21, -0.65)}},
		{label = GetLabelText("TAT_BI_055"), nameHash = 'MP_MP_Biker_Tat_055_M', price = 500, removePrice = 750, anim = "FRONT", camera = {vec(-0.4, 0.88, -0.78), vec(-0.2, 0.21, -0.65)}},
		{label = GetLabelText("TAT_BI_056"), nameHash = 'MP_MP_Biker_Tat_056_M', price = 500, removePrice = 750, anim = "BACK", camera = {vec(-.1, 0.41, 0.2), vec(-.1, 0.4, -0.6)}},
		{label = GetLabelText("TAT_BI_057"), nameHash = 'MP_MP_Biker_Tat_057_M', price = 500, removePrice = 750, anim = "BACK", camera = {vec(-.1, 0.41, 0.2), vec(-.1, 0.4, -0.6)}},
		{label = GetLabelText("TAT_BI_058"), nameHash = 'MP_MP_Biker_Tat_058_M', price = 500, removePrice = 750, anim = "BACK", camera = {vec(-.1, -0.48, -0.35), vec(-.1, -0.49, -0.6)}},
		{label = GetLabelText("TAT_BI_059"), nameHash = 'MP_MP_Biker_Tat_059_M', price = 500, removePrice = 750, anim = "BACK", camera = {vec(-.1, -0.48, -0.35), vec(-.1, -0.49, -0.6)}},
		{label = GetLabelText("TAT_BI_060"), nameHash = 'MP_MP_Biker_Tat_060_M', price = 500, removePrice = 750, anim = "BACK", camera = {vec(.1, -0.48, -0.35), vec(.1, -0.49, -0.6)}},
	},
	mpairraces_overlays = { -- 4
		{label = GetLabelText("TAT_AR_000"), nameHash = 'MP_Airraces_Tattoo_000_M', price = 500, removePrice = 750, anim = "BACK", camera = {vec(-.11, -0.48, -0.35), vec(-.11, -0.49, -0.6)}},
		{label = GetLabelText("TAT_AR_001"), nameHash = 'MP_Airraces_Tattoo_001_M', price = 500, removePrice = 750, anim = "FRONT", camera = {vec(-.05, 0.215, -0.15), vec(-.05, 0.365, -0.6)}},
		{label = GetLabelText("TAT_AR_002"), nameHash = 'MP_Airraces_Tattoo_002_M', price = 500, removePrice = 750, anim = "FRONT", camera = {vec(-.05, 0.215, -0.15), vec(-.05, 0.365, -0.6)}},
		{label = GetLabelText("TAT_AR_003"), nameHash = 'MP_Airraces_Tattoo_003_M', price = 500, removePrice = 750, anim = "BACK", camera = {vec(-.7, -.4, -0.18), vec(-.2, -.41, -0.6)}},
		{label = GetLabelText("TAT_AR_004"), nameHash = 'MP_Airraces_Tattoo_004_M', price = 500, removePrice = 750, anim = "FRONT", camera = {vec(-.05, 0.215, -0.15), vec(-.05, 0.365, -0.6)}},
		{label = GetLabelText("TAT_AR_005"), nameHash = 'MP_Airraces_Tattoo_005_M', price = 500, removePrice = 750, anim = "FRONT", camera = {vec(-.05, 0.215, -0.15), vec(-.05, 0.365, -0.6)}},
		{label = GetLabelText("TAT_AR_006"), nameHash = 'MP_Airraces_Tattoo_006_M', price = 500, removePrice = 750, anim = "BACK", camera = {vec(.0, -0.25, -0.3), vec(.0, -0.255, -0.6)}},
		{label = GetLabelText("TAT_AR_007"), nameHash = 'MP_Airraces_Tattoo_007_M', price = 500, removePrice = 750, anim = "FRONT", camera = {vec(-.05, 0.215, -0.15), vec(-.05, 0.365, -0.6)}},
	},
	mpbeach_overlays = { -- 5
		{label = GetLabelText("TAT_BB_018"), nameHash = 'MP_Bea_M_Back_000', price = 500, removePrice = 750, anim = "FRONT", camera = {vec(-.05, 0.215, -0.15), vec(-.05, 0.365, -0.6)}},
		{label = GetLabelText("TAT_BB_019"), nameHash = 'MP_Bea_M_Chest_000', price = 500, removePrice = 750, anim = "BACK", camera = {vec(-.11, -0.48, -0.35), vec(-.11, -0.49, -0.6)}},
		{label = GetLabelText("TAT_BB_020"), nameHash = 'MP_Bea_M_Chest_001', price = 500, removePrice = 750, anim = "BACK", camera = {vec(.11, -0.48, -0.35), vec(.11, -0.49, -0.6)}},
		{label = GetLabelText("TAT_BB_021"), nameHash = 'MP_Bea_M_Head_000', price = 500, removePrice = 750, anim = "BACK", camera = {vec(.0, -0.75, -0.35), vec(.0, -0.755, -0.6)}},
		{label = GetLabelText("TAT_BB_027"), nameHash = 'MP_Bea_M_Lleg_000', price = 500, removePrice = 750, anim = "FRONT", camera = {vec(-.05, -0.55, -0.25), vec(-.05, -0.525, -0.6)}},
		{label = GetLabelText("TAT_BB_025"), nameHash = 'MP_Bea_M_Rleg_000', price = 500, removePrice = 750, anim = "FRONT", camera = {vec(-.25, -0.55, -0.25), vec(.0, -0.525, -0.6)}},
		{label = GetLabelText("TAT_BB_026"), nameHash = 'MP_Bea_M_RArm_000', price = 500, removePrice = 750, anim = "FRONT", camera = {vec(0.485, 0.88, -0.7), vec(0.2, 0.21, -0.6)}},
		{label = GetLabelText("TAT_BB_024"), nameHash = 'MP_Bea_M_LArm_000', price = 500, removePrice = 750, anim = "FRONT", camera = {vec(-0.4, 0.88, -0.7), vec(-0.2, 0.21, -0.6)}},
		{label = GetLabelText("TAT_BB_017"), nameHash = 'MP_Bea_M_LArm_001', price = 500, removePrice = 750, anim = "FRONT", camera = {vec(-0.4, 0.88, -0.7), vec(-0.2, 0.21, -0.6)}},
		{label = GetLabelText("TAT_BB_029"), nameHash = 'MP_Bea_M_Neck_001', price = 500, removePrice = 750, anim = "BACK", camera = {vec(.35, -0.67, -0.685), vec(.05, -0.69, -0.785)}},
		{label = GetLabelText("TAT_BB_030"), nameHash = 'MP_Bea_M_RArm_001', price = 500, removePrice = 750, anim = "FRONT", camera = {vec(0.485, 0.88, -0.7), vec(0.2, 0.21, -0.6)}},
		{label = GetLabelText("TAT_BB_023"), nameHash = 'MP_Bea_M_Stom_000', price = 500, removePrice = 750, anim = "BACK", camera = {vec(-.12, -0.25, -0.35), vec(-.12, -0.255, -0.6)}},
		{label = GetLabelText("TAT_BB_032"), nameHash = 'MP_Bea_M_Stom_001', price = 500, removePrice = 750, anim = "BACK", camera = {vec(.0, -0.25, -0.3), vec(.0, -0.255, -0.6)}},
	},
	mpchristmas2_overlays = { -- 6
		{label = GetLabelText("TAT_X2_000"), nameHash = 'MP_Xmas2_M_Tat_000', price = 500, removePrice = 750, anim = "FRONT", camera = {vec(-.12, 0.6, -0.68), vec(-.12, 0.65, -0.725)}},
		{label = GetLabelText("TAT_X2_001"), nameHash = 'MP_Xmas2_M_Tat_001', price = 500, removePrice = 750, anim = "FRONT", camera = {vec(-.05, -0.55, -0.25), vec(-.05, -0.525, -0.6)}},
		{label = GetLabelText("TAT_X2_003"), nameHash = 'MP_Xmas2_M_Tat_003', price = 500, removePrice = 750, anim = "FRONT", camera = {vec(0.65, 0.78, -0.78), vec(0.2, 0.21, -0.6)}},
		{label = GetLabelText("TAT_X2_004"), nameHash = 'MP_Xmas2_M_Tat_004', price = 500, removePrice = 750, anim = "FRONT", camera = {vec(0.65, 0.78, -0.78), vec(0.2, 0.21, -0.6)}},
		{label = GetLabelText("TAT_X2_005"), nameHash = 'MP_Xmas2_M_Tat_005', price = 500, removePrice = 750, anim = "FRONT", camera = {vec(-.05, 0.215, -0.15), vec(-.05, 0.365, -0.6)}},
		{label = GetLabelText("TAT_X2_006"), nameHash = 'MP_Xmas2_M_Tat_006', price = 500, removePrice = 750, anim = "FRONT", camera = {vec(-.05, 0.215, -0.15), vec(-.05, 0.365, -0.6)}},
		{label = GetLabelText("TAT_X2_007"), nameHash = 'MP_Xmas2_M_Tat_007', price = 500, removePrice = 750, anim = "BACK", camera = {vec(-.35, -0.6, -0.785), vec(.05, -0.5, -0.785)}},
		{label = GetLabelText("TAT_X2_008"), nameHash = 'MP_Xmas2_M_Tat_008', price = 500, removePrice = 750, anim = "FRONT", camera = {vec(.035, 0.6, -0.625), vec(.075, 0.61, -0.75)}},
		{label = GetLabelText("TAT_X2_009"), nameHash = 'MP_Xmas2_M_Tat_009', price = 500, removePrice = 750, anim = "BACK", camera = {vec(-.12, -0.55, -0.35), vec(-.12, -0.555, -0.6)}},
		{label = GetLabelText("TAT_X2_010"), nameHash = 'MP_Xmas2_M_Tat_010', price = 500, removePrice = 750, anim = "FRONT", camera = {vec(-.12, 0.6, -0.68), vec(-.12, 0.65, -0.725)}},
		{label = GetLabelText("TAT_X2_011"), nameHash = 'MP_Xmas2_M_Tat_011', price = 500, removePrice = 750, anim = "FRONT", camera = {vec(-.05, 0.5, -0.2), vec(-.05, 0.51, -0.6)}},
		{label = GetLabelText("TAT_X2_012"), nameHash = 'MP_Xmas2_M_Tat_012', price = 500, removePrice = 750, anim = "BACK", camera = {vec(-0.85, -0.45, -0.8), vec(-0.4, -0.375, -0.7)}},
		{label = GetLabelText("TAT_X2_013"), nameHash = 'MP_Xmas2_M_Tat_013', price = 500, removePrice = 750, anim = "FRONT", camera = {vec(0.7, 0.25, -0.84), vec(0.2, 0.255, -0.6)}},
		{label = GetLabelText("TAT_X2_014"), nameHash = 'MP_Xmas2_M_Tat_014', price = 500, removePrice = 750, anim = "BACK", camera = {vec(0.5, 0.55, -0.5), vec(0.2, 0.495, -0.8)}},
		{label = GetLabelText("TAT_X2_015"), nameHash = 'MP_Xmas2_M_Tat_015', price = 500, removePrice = 750, anim = "FRONT", camera = {vec(-.05, 0.215, -0.15), vec(-.05, 0.365, -0.6)}},
		{label = GetLabelText("TAT_X2_016"), nameHash = 'MP_Xmas2_M_Tat_016', price = 500, removePrice = 750, anim = "BACK", camera = {vec(.11, -0.48, -0.35), vec(.11, -0.49, -0.6)}},
		{label = GetLabelText("TAT_X2_017"), nameHash = 'MP_Xmas2_M_Tat_017', price = 500, removePrice = 750, anim = "BACK", camera = {vec(.11, -0.48, -0.35), vec(.11, -0.49, -0.6)}},
		{label = GetLabelText("TAT_X2_018"), nameHash = 'MP_Xmas2_M_Tat_018', price = 500, removePrice = 750, anim = "BACK", camera = {vec(.1, -.4, -0.1), vec(.1, -.41, -0.6)}},
		{label = GetLabelText("TAT_X2_019"), nameHash = 'MP_Xmas2_M_Tat_019', price = 500, removePrice = 750, anim = "BACK", camera = {vec(.1, -.4, -0.1), vec(.1, -.41, -0.6)}},
		{label = GetLabelText("TAT_X2_022"), nameHash = 'MP_Xmas2_M_Tat_022', price = 500, removePrice = 750, anim = "BACK", camera = {vec(0.75, .0, -0.944), vec(0.2, -0.451, -0.6)}},
		{label = GetLabelText("TAT_X2_023"), nameHash = 'MP_Xmas2_M_Tat_023', price = 500, removePrice = 750, anim = "BACK", camera = {vec(0.75, .0, -0.944), vec(0.2, -0.451, -0.6)}},
		{label = GetLabelText("TAT_X2_024"), nameHash = 'MP_Xmas2_M_Tat_024', price = 500, removePrice = 750, anim = "BACK", camera = {vec(.38, -0.7, -0.785), vec(-.05, -0.5, -0.785)}},
		{label = GetLabelText("TAT_X2_025"), nameHash = 'MP_Xmas2_M_Tat_025', price = 500, removePrice = 750, anim = "BACK", camera = {vec(.38, -0.7, -0.785), vec(-.05, -0.5, -0.785)}},
		{label = GetLabelText("TAT_X2_026"), nameHash = 'MP_Xmas2_M_Tat_026', price = 500, removePrice = 750, anim = "BACK", camera = {vec(.225, -0.28, -0.35), vec(.15, -0.285, -0.6)}},
		{label = GetLabelText("TAT_X2_027"), nameHash = 'MP_Xmas2_M_Tat_027', price = 500, removePrice = 750, anim = "BACK", camera = {vec(.225, -0.28, -0.35), vec(.15, -0.285, -0.6)}},
		{label = GetLabelText("TAT_X2_028"), nameHash = 'MP_Xmas2_M_Tat_028', price = 500, removePrice = 750, anim = "BACK", camera = {vec(-.12, -0.25, -0.35), vec(-.12, -0.255, -0.6)}},
		{label = GetLabelText("TAT_X2_029"), nameHash = 'MP_Xmas2_M_Tat_029', price = 500, removePrice = 750, anim = "BACK", camera = {vec(-.35, -0.6, -0.785), vec(.05, -0.5, -0.785)}},
	},
	mpgunrunning_overlays = { -- 7
		{label = GetLabelText("TAT_GR_000"), nameHash = 'MP_Gunrunning_Tattoo_000_M', price = 500, removePrice = 750, anim = "FRONT", camera = {vec(-.05, 0.215, -0.15), vec(-.05, 0.365, -0.6)}},
		{label = GetLabelText("TAT_GR_001"), nameHash = 'MP_Gunrunning_Tattoo_001_M', price = 500, removePrice = 750, anim = "FRONT", camera = {vec(-.05, 0.215, -0.15), vec(-.05, 0.216, -0.6)}},
		{label = GetLabelText("TAT_GR_002"), nameHash = 'MP_Gunrunning_Tattoo_002_M', price = 500, removePrice = 750, anim = "BACK", camera = {vec(.225, -0.28, -0.35), vec(.15, -0.285, -0.6)}},
		{label = GetLabelText("TAT_GR_003"), nameHash = 'MP_Gunrunning_Tattoo_003_M', price = 500, removePrice = 750, anim = "BACK", camera = {vec(.35, -0.75, -0.785), vec(.05, -0.68, -0.785)}},
		{label = GetLabelText("TAT_GR_004"), nameHash = 'MP_Gunrunning_Tattoo_004_M', price = 500, removePrice = 750, anim = "BACK", camera = {vec(-.225, -0.28, -0.35), vec(-.15, -0.285, -0.6)}},
		{label = GetLabelText("TAT_GR_005"), nameHash = 'MP_Gunrunning_Tattoo_005_M', price = 500, removePrice = 750, anim = "FRONT", camera = {vec(-.05, -0.55, -0.25), vec(-.05, -0.525, -0.6)}},
		{label = GetLabelText("TAT_GR_006"), nameHash = 'MP_Gunrunning_Tattoo_006_M', price = 500, removePrice = 750, anim = "FRONT", camera = {vec(-.05, -0.55, -0.25), vec(-.05, -0.525, -0.6)}},
		{label = GetLabelText("TAT_GR_007"), nameHash = 'MP_Gunrunning_Tattoo_007_M', price = 500, removePrice = 750, anim = "BACK", camera = {vec(-.105, 0.1, -0.245), vec(-.165, 0.35, -0.6)}},
		{label = GetLabelText("TAT_GR_008"), nameHash = 'MP_Gunrunning_Tattoo_008_M', price = 500, removePrice = 750, anim = "BACK", camera = {vec(-.1, -.4, -0.28), vec(-.1, -.41, -0.6)}},
		{label = GetLabelText("TAT_GR_009"), nameHash = 'MP_Gunrunning_Tattoo_009_M', price = 500, removePrice = 750, anim = "FRONT", camera = {vec(-.05, 0.215, -0.15), vec(-.05, 0.365, -0.6)}},
		{label = GetLabelText("TAT_GR_010"), nameHash = 'MP_Gunrunning_Tattoo_010_M', price = 500, removePrice = 750, anim = "BACK", camera = {vec(.1, -.3, -0.2), vec(.1, -.31, -0.6)}},
		{label = GetLabelText("TAT_GR_011"), nameHash = 'MP_Gunrunning_Tattoo_011_M', price = 500, removePrice = 750, anim = "FRONT", camera = {vec(-.05, -0.55, -0.25), vec(-.05, -0.525, -0.6)}},
		{label = GetLabelText("TAT_GR_012"), nameHash = 'MP_Gunrunning_Tattoo_012_M', price = 500, removePrice = 750, anim = "BACK", camera = {vec(-.11, -0.48, -0.35), vec(-.11, -0.49, -0.6)}},
		{label = GetLabelText("TAT_GR_013"), nameHash = 'MP_Gunrunning_Tattoo_013_M', price = 500, removePrice = 750, anim = "FRONT", camera = {vec(-.05, 0.215, -0.15), vec(-.05, 0.365, -0.6)}},
		{label = GetLabelText("TAT_GR_014"), nameHash = 'MP_Gunrunning_Tattoo_014_M', price = 500, removePrice = 750, anim = "FRONT", camera = {vec(-.05, 0.215, -0.15), vec(-.05, 0.365, -0.6)}},
		{label = GetLabelText("TAT_GR_015"), nameHash = 'MP_Gunrunning_Tattoo_015_M', price = 500, removePrice = 750, anim = "BACK", camera = {vec(-.7, -.4, -0.18), vec(-.2, -.41, -0.6)}},
		{label = GetLabelText("TAT_GR_016"), nameHash = 'MP_Gunrunning_Tattoo_016_M', price = 500, removePrice = 750, anim = "FRONT", camera = {vec(-.385, 0.75, -0.435), vec(-.3, 0.66, -0.55)}},
		{label = GetLabelText("TAT_GR_017"), nameHash = 'MP_Gunrunning_Tattoo_017_M', price = 500, removePrice = 750, anim = "BACK", camera = {vec(.1, -.45, -0.1), vec(.1, -.46, -0.6)}},
		{label = GetLabelText("TAT_GR_018"), nameHash = 'MP_Gunrunning_Tattoo_018_M', price = 500, removePrice = 750, anim = "FRONT", camera = {vec(-.05, 0.2, -0.3), vec(-.05, 0.21, -0.6)}},
		{label = GetLabelText("TAT_GR_019"), nameHash = 'MP_Gunrunning_Tattoo_019_M', price = 500, removePrice = 750, anim = "FRONT", camera = {vec(.0, 0.4, -0.1), vec(.0, 0.41, -0.6)}},
		{label = GetLabelText("TAT_GR_020"), nameHash = 'MP_Gunrunning_Tattoo_020_M', price = 500, removePrice = 750, anim = "BACK", camera = {vec(.1, -.4, -0.1), vec(.1, -.41, -0.6)}},
		{label = GetLabelText("TAT_GR_021"), nameHash = 'MP_Gunrunning_Tattoo_021_M', price = 500, removePrice = 750, anim = "FRONT", camera = {vec(0.48, 0.8, -0.7), vec(0.2, 0.21, -0.6)}},
		{label = GetLabelText("TAT_GR_022"), nameHash = 'MP_Gunrunning_Tattoo_022_M', price = 500, removePrice = 750, anim = "FRONT", camera = {vec(-.15, 0.4, -0.1), vec(-.15, 0.41, -0.6)}},
		{label = GetLabelText("TAT_GR_023"), nameHash = 'MP_Gunrunning_Tattoo_023_M', price = 500, removePrice = 750, anim = "FRONT", camera = {vec(-.05, -0.55, -0.25), vec(-.05, -0.525, -0.6)}},
		{label = GetLabelText("TAT_GR_024"), nameHash = 'MP_Gunrunning_Tattoo_024_M', price = 500, removePrice = 750, anim = "BACK", camera = {vec(.75, -.35, -0.25), vec(.35, -0.36, -0.6)}},
		{label = GetLabelText("TAT_GR_025"), nameHash = 'MP_Gunrunning_Tattoo_025_M', price = 500, removePrice = 750, anim = "BACK", camera = {vec(-.7, -.35, -0.25), vec(-.2, -.36, -0.6)}},
		{label = GetLabelText("TAT_GR_026"), nameHash = 'MP_Gunrunning_Tattoo_026_M', price = 500, removePrice = 750, anim = "FRONT", camera = {vec(-.05, -0.55, -0.25), vec(-.05, -0.525, -0.6)}},
		{label = GetLabelText("TAT_GR_027"), nameHash = 'MP_Gunrunning_Tattoo_027_M', price = 500, removePrice = 750, anim = "FRONT", camera = {vec(-0.6, 0.875, -0.65), vec(-0.3, 0.65, -0.7)}},
		{label = GetLabelText("TAT_GR_028"), nameHash = 'MP_Gunrunning_Tattoo_028_M', price = 500, removePrice = 750, anim = "BACK", camera = {vec(.05, -.4, -0.2), vec(.05, -.41, -0.6)}},
		{label = GetLabelText("TAT_GR_029"), nameHash = 'MP_Gunrunning_Tattoo_029_M', price = 500, removePrice = 750, anim = "BACK", camera = {vec(.05, -.3, -0.2), vec(.05, -.31, -0.6)}},
		{label = GetLabelText("TAT_GR_030"), nameHash = 'MP_Gunrunning_Tattoo_030_M', price = 500, removePrice = 750, anim = "FRONT", camera = {vec(.15, -0.45, -0.25), vec(.15, -0.425, -0.6)}},
	},
	mpimportexport_overlays = { -- 8
		{label = GetLabelText("TAT_IE_000"), nameHash = 'MP_MP_ImportExport_Tat_000_M', price = 500, removePrice = 750, anim = "FRONT", camera = {vec(-.05, 0.215, -0.15), vec(-.05, 0.365, -0.6)}},
		{label = GetLabelText("TAT_IE_001"), nameHash = 'MP_MP_ImportExport_Tat_001_M', price = 500, removePrice = 750, anim = "FRONT", camera = {vec(-.05, 0.215, -0.15), vec(-.05, 0.365, -0.6)}},
		{label = GetLabelText("TAT_IE_002"), nameHash = 'MP_MP_ImportExport_Tat_002_M', price = 500, removePrice = 750, anim = "FRONT", camera = {vec(-.05, 0.215, -0.15), vec(-.05, 0.365, -0.6)}},
		{label = GetLabelText("TAT_IE_003"), nameHash = 'MP_MP_ImportExport_Tat_003_M', price = 500, removePrice = 750, anim = "BACK", camera = {vec(.7, -.4, -0.18), vec(.2, -.41, -0.6)}},
		{label = GetLabelText("TAT_IE_004"), nameHash = 'MP_MP_ImportExport_Tat_004_M', price = 500, removePrice = 750, anim = "BACK", camera = {vec(-.7, -.4, -0.18), vec(-.2, -.41, -0.6)}},
		{label = GetLabelText("TAT_IE_005"), nameHash = 'MP_MP_ImportExport_Tat_005_M', price = 500, removePrice = 750, anim = "BACK", camera = {vec(.7, -.4, -0.18), vec(.2, -.41, -0.6)}},
		{label = GetLabelText("TAT_IE_006"), nameHash = 'MP_MP_ImportExport_Tat_006_M', price = 500, removePrice = 750, anim = "BACK", camera = {vec(.7, -.4, -0.18), vec(.2, -.41, -0.6)}},
		{label = GetLabelText("TAT_IE_007"), nameHash = 'MP_MP_ImportExport_Tat_007_M', price = 500, removePrice = 750, anim = "BACK", camera = {vec(.7, -.4, -0.18), vec(.2, -.41, -0.6)}},
		{label = GetLabelText("TAT_IE_008"), nameHash = 'MP_MP_ImportExport_Tat_008_M', price = 500, removePrice = 750, anim = "BACK", camera = {vec(-.7, -.4, -0.18), vec(-.2, -.41, -0.6)}},
		{label = GetLabelText("TAT_IE_009"), nameHash = 'MP_MP_ImportExport_Tat_009_M', price = 500, removePrice = 750, anim = "FRONT", camera = {vec(-.05, 0.215, -0.15), vec(-.05, 0.365, -0.6)}},
		{label = GetLabelText("TAT_IE_010"), nameHash = 'MP_MP_ImportExport_Tat_010_M', price = 500, removePrice = 750, anim = "FRONT", camera = {vec(-.05, 0.215, -0.15), vec(-.05, 0.365, -0.6)}},
		{label = GetLabelText("TAT_IE_011"), nameHash = 'MP_MP_ImportExport_Tat_011_M', price = 500, removePrice = 750, anim = "FRONT", camera = {vec(-.05, 0.215, -0.15), vec(-.05, 0.365, -0.6)}},
	},
	mplowrider2_overlays = { -- 9
		{label = GetLabelText("TAT_S2_000"), nameHash = 'MP_LR_Tat_000_M', price = 500, removePrice = 750, anim = "FRONT", camera = {vec(-.05, 0.215, -0.15), vec(-.05, 0.365, -0.6)}},
		{label = GetLabelText("TAT_S2_003"), nameHash = 'MP_LR_Tat_003_M', price = 500, removePrice = 750, anim = "FRONT", camera = {vec(.035, 0.6, -0.625), vec(.075, 0.61, -0.75)}},
		{label = GetLabelText("TAT_S2_006"), nameHash = 'MP_LR_Tat_006_M', price = 500, removePrice = 750, anim = "FRONT", camera = {vec(-.38, 0.65, -0.45), vec(-.3, 0.66, -0.6)}},
		{label = GetLabelText("TAT_S2_008"), nameHash = 'MP_LR_Tat_008_M', price = 500, removePrice = 750, anim = "FRONT", camera = {vec(-.05, 0.4, -0.1), vec(-.05, 0.41, -0.6)}},
		{label = GetLabelText("TAT_S2_011"), nameHash = 'MP_LR_Tat_011_M', price = 500, removePrice = 750, anim = "FRONT", camera = {vec(0.7, 0.2, -0.7), vec(0.2, 0.21, -0.6)}},
		{label = GetLabelText("TAT_S2_012"), nameHash = 'MP_LR_Tat_012_M', price = 500, removePrice = 750, anim = "BACK", camera = {vec(.15, -0.5, -0.35), vec(.15, -0.505, -0.6)}},
		{label = GetLabelText("TAT_S2_016"), nameHash = 'MP_LR_Tat_016_M', price = 500, removePrice = 750, anim = "BACK", camera = {vec(.1, -.4, -0.1), vec(.1, -.41, -0.6)}},
		{label = GetLabelText("TAT_S2_018"), nameHash = 'MP_LR_Tat_018_M', price = 500, removePrice = 750, anim = "BACK", camera = {vec(-.73, -.4, -0.35), vec(-.3, -.41, -0.6)}},
		{label = GetLabelText("TAT_S2_019"), nameHash = 'MP_LR_Tat_019_M', price = 500, removePrice = 750, anim = "BACK", camera = {vec(-.18, -0.55, -0.35), vec(-.18, -0.555, -0.6)}},
		{label = GetLabelText("TAT_S2_022"), nameHash = 'MP_LR_Tat_022_M', price = 500, removePrice = 750, anim = "BACK", camera = {vec(-.28, -0.35, -0.35), vec(-.28, -0.355, -0.6)}},
		{label = GetLabelText("TAT_S2_028"), nameHash = 'MP_LR_Tat_028_M', price = 500, removePrice = 750, anim = "BACK", camera = {vec(.28, -0.35, -0.35), vec(.28, -0.355, -0.6)}},
		{label = GetLabelText("TAT_S2_029"), nameHash = 'MP_LR_Tat_029_M', price = 500, removePrice = 750, anim = "FRONT", camera = {vec(-.05, -0.55, -0.25), vec(-.05, -0.525, -0.6)}},
		{label = GetLabelText("TAT_S2_030"), nameHash = 'MP_LR_Tat_030_M', price = 500, removePrice = 750, anim = "FRONT", camera = {vec(-.05, -0.55, -0.25), vec(-.05, -0.525, -0.6)}},
		{label = GetLabelText("TAT_S2_031"), nameHash = 'MP_LR_Tat_031_M', price = 500, removePrice = 750, anim = "FRONT", camera = {vec(-.05, 0.215, -0.15), vec(-.05, 0.365, -0.6)}},
		{label = GetLabelText("TAT_S2_032"), nameHash = 'MP_LR_Tat_032_M', price = 500, removePrice = 750, anim = "FRONT", camera = {vec(-.05, 0.215, -0.15), vec(-.05, 0.365, -0.6)}},
		{label = GetLabelText("TAT_S2_035"), nameHash = 'MP_LR_Tat_035_M', price = 500, removePrice = 750, anim = "FRONT", camera = {vec(.035, 0.6, -0.625), vec(.075, 0.61, -0.75)}},
	},
	mplowrider_overlays = { -- 10
		{label = GetLabelText("TAT_S1_001"), nameHash = 'MP_LR_Tat_001_M', price = 500, removePrice = 750, anim = "BACK", camera = {vec(.1, -.4, -0.1), vec(.1, -.41, -0.6)}},
		{label = GetLabelText("TAT_S1_002"), nameHash = 'MP_LR_Tat_002_M', price = 500, removePrice = 750, anim = "BACK", camera = {vec(.1, -.4, -0.1), vec(.1, -.41, -0.6)}},
		{label = GetLabelText("TAT_S1_004"), nameHash = 'MP_LR_Tat_004_M', price = 500, removePrice = 750, anim = "FRONT", camera = {vec(0.7, 0.29, -0.7), vec(0.2, 0.3, -0.6)}},
		{label = GetLabelText("TAT_S1_005"), nameHash = 'MP_LR_Tat_005_M', price = 500, removePrice = 750, anim = "BACK", camera = {vec(-.2, -.4, -0.275), vec(-.2, -.41, -0.6)}},
		{label = GetLabelText("TAT_S1_007"), nameHash = 'MP_LR_Tat_007_M', price = 500, removePrice = 750, anim = "FRONT", camera = {vec(-.05, -0.55, -0.25), vec(-.05, -0.525, -0.6)}},
		{label = GetLabelText("TAT_S1_009"), nameHash = 'MP_LR_Tat_009_M', price = 500, removePrice = 750, anim = "FRONT", camera = {vec(-.1, 0.4, -0.3), vec(-.1, 0.41, -0.6)}},
		{label = GetLabelText("TAT_S1_010"), nameHash = 'MP_LR_Tat_010_M', price = 500, removePrice = 750, anim = "FRONT", camera = {vec(-.05, 0.4, -0.1), vec(-.05, 0.41, -0.6)}},
		{label = GetLabelText("TAT_S1_013"), nameHash = 'MP_LR_Tat_013_M', price = 500, removePrice = 750, anim = "BACK", camera = {vec(-.15, -0.48, -0.35), vec(-.15, -0.49, -0.6)}},
		{label = GetLabelText("TAT_S1_014"), nameHash = 'MP_LR_Tat_014_M', price = 500, removePrice = 750, anim = "FRONT", camera = {vec(-.05, 0.4, -0.1), vec(-.05, 0.41, -0.6)}},
		{label = GetLabelText("TAT_S1_015"), nameHash = 'MP_LR_Tat_015_M', price = 500, removePrice = 750, anim = "FRONT", camera = {vec(.035, 0.6, -0.625), vec(.075, 0.61, -0.75)}},
		{label = GetLabelText("TAT_S1_017"), nameHash = 'MP_LR_Tat_017_M', price = 500, removePrice = 750, anim = "FRONT", camera = {vec(-.05, -0.55, -0.25), vec(-.05, -0.525, -0.6)}},
		{label = GetLabelText("TAT_S1_020"), nameHash = 'MP_LR_Tat_020_M', price = 500, removePrice = 750, anim = "BACK", camera = {vec(-.1, 0.69, -0.42), vec(-.1, 0.54, -0.6)}},
		{label = GetLabelText("TAT_S1_021"), nameHash = 'MP_LR_Tat_021_M', price = 500, removePrice = 750, anim = "FRONT", camera = {vec(-.05, 0.4, -0.1), vec(-.05, 0.41, -0.6)}},
		{label = GetLabelText("TAT_S1_023"), nameHash = 'MP_LR_Tat_023_M', price = 500, removePrice = 750, anim = "FRONT", camera = {vec(-.05, -0.55, -0.25), vec(-.05, -0.525, -0.6)}},
		{label = GetLabelText("TAT_S1_026"), nameHash = 'MP_LR_Tat_026_M', price = 500, removePrice = 750, anim = "BACK", camera = {vec(-.15, -0.48, -0.35), vec(-.15, -0.49, -0.6)}},
		{label = GetLabelText("TAT_S1_027"), nameHash = 'MP_LR_Tat_027_M', price = 500, removePrice = 750, anim = "BACK", camera = {vec(-.345, -.4, -0.3), vec(-.24, -.42, -0.6)}},
		{label = GetLabelText("TAT_S1_033"), nameHash = 'MP_LR_Tat_033_M', price = 500, removePrice = 750, anim = "BACK", camera = {vec(-.345, -.4, -0.3), vec(-.24, -.42, -0.6)}},
	},
	vms_overlays = { -- 11
		{label = "XX Emoji", nameHash = 'MP_VMS_FACE_000', price = 500, removePrice = 750, anim = "BACK", camera = {vec(.0, -0.75, -0.35), vec(.0, -0.755, -0.6)}},
		{label = "Libery", nameHash = 'MP_VMS_FACE_001', price = 500, removePrice = 750, anim = "BACK", camera = {vec(-.15, -0.75, -0.45), vec(-.15, -0.755, -0.6)}},
		{label = "R.I.P. XXX", nameHash = 'MP_VMS_FACE_002', price = 500, removePrice = 750, anim = "BACK", camera = {vec(.0, -0.75, -0.35), vec(.0, -0.755, -0.6)}},
		{label = "XX Emoji 2", nameHash = 'MP_VMS_FACE_003', price = 500, removePrice = 750, anim = "BACK", camera = {vec(-.15, -0.75, -0.45), vec(-.15, -0.755, -0.6)}},
		{label = "Broken Heart", nameHash = 'MP_VMS_FACE_004', price = 500, removePrice = 750, anim = "BACK", camera = {vec(-.15, -0.75, -0.45), vec(-.15, -0.755, -0.6)}},
		{label = "666", nameHash = 'MP_VMS_FACE_005', price = 500, removePrice = 750, anim = "BACK", camera = {vec(.05, -0.75, -0.35), vec(.05, -0.755, -0.6)}},
		{label = "Lover", nameHash = 'MP_VMS_FACE_006', price = 500, removePrice = 750, anim = "BACK", camera = {vec(-.05, -0.75, -0.35), vec(-.05, -0.755, -0.6)}},
		{label = "Kiss", nameHash = 'MP_VMS_FACE_007', price = 500, removePrice = 750, anim = "BACK", camera = {vec(-.15, -0.75, -0.45), vec(-.15, -0.755, -0.6)}},
		{label = "Playboy", nameHash = 'MP_VMS_FACE_008', price = 500, removePrice = 750, anim = "BACK", camera = {vec(-.15, -0.75, -0.45), vec(-.15, -0.755, -0.6)}},
		{label = "Sparkles", nameHash = 'MP_VMS_FACE_009', price = 500, removePrice = 750, anim = "BACK", camera = {vec(-.15, -0.75, -0.45), vec(-.15, -0.755, -0.6)}},
		{label = "V-ictory", nameHash = 'MP_VMS_FACE_010', price = 500, removePrice = 750, anim = "BACK", camera = {vec(.0, -0.75, -0.35), vec(.0, -0.755, -0.6)}},
		{label = "Beast", nameHash = 'MP_VMS_FACE_011', price = 500, removePrice = 750, anim = "BACK", camera = {vec(.0, -0.75, -0.35), vec(.0, -0.755, -0.6)}},
		{label = "Gun", nameHash = 'MP_VMS_FACE_012', price = 500, removePrice = 750, anim = "BACK", camera = {vec(.0, -0.75, -0.35), vec(.0, -0.755, -0.6)}},
		{label = "Cross", nameHash = 'MP_VMS_FACE_013', price = 500, removePrice = 750, anim = "BACK", camera = {vec(.0, -0.75, -0.35), vec(.0, -0.755, -0.6)}},
		{label = "Dagger on Eye", nameHash = 'MP_VMS_FACE_014', price = 500, removePrice = 750, anim = "BACK", camera = {vec(.0, -0.75, -0.35), vec(.0, -0.755, -0.6)}},
		{label = "Dagger at Right", nameHash = 'MP_VMS_FACE_015', price = 500, removePrice = 750, anim = "BACK", camera = {vec(.0, -0.75, -0.35), vec(.0, -0.755, -0.6)}},
		{label = "Spider", nameHash = 'MP_VMS_FACE_016', price = 500, removePrice = 750, anim = "BACK", camera = {vec(.0, -0.75, -0.35), vec(.0, -0.755, -0.6)}},
		{label = "Heart Outline", nameHash = 'MP_VMS_FACE_017', price = 500, removePrice = 750, anim = "BACK", camera = {vec(.0, -0.75, -0.35), vec(.0, -0.755, -0.6)}},
		{label = "Tear", nameHash = 'MP_VMS_FACE_018', price = 500, removePrice = 750, anim = "BACK", camera = {vec(.0, -0.75, -0.35), vec(.0, -0.755, -0.6)}},
		{label = 'Wings', nameHash = 'MP_VMS_NECK_001', price = 500, removePrice = 750, anim = "FRONT", camera = {vec(-.05, 0.6, -0.3), vec(-.05, 0.61, -0.6)}},
	},
	multiplayer_overlays = { -- 12
		{label = "Hair", nameHash = "FM_M_Hair_001_a", price = 500, removePrice = 750, anim = "FRONT", camera = {vec(-.05, 0.4, -0.38), vec(-.05, 0.61, -0.6)}},
		{label = "Hair", nameHash = "FM_M_Hair_001_b", price = 500, removePrice = 750, anim = "FRONT", camera = {vec(-.05, 0.4, -0.38), vec(-.05, 0.61, -0.6)}},
		{label = "Hair", nameHash = "FM_M_Hair_001_c", price = 500, removePrice = 750, anim = "FRONT", camera = {vec(-.05, 0.4, -0.38), vec(-.05, 0.61, -0.6)}},
		{label = "Hair", nameHash = "FM_M_Hair_001_d", price = 500, removePrice = 750, anim = "FRONT", camera = {vec(-.05, 0.4, -0.38), vec(-.05, 0.61, -0.6)}},
		{label = "Hair", nameHash = "FM_M_Hair_001_e", price = 500, removePrice = 750, anim = "FRONT", camera = {vec(-.05, 0.4, -0.38), vec(-.05, 0.61, -0.6)}},
		{label = "Hair", nameHash = "FM_M_Hair_003_a", price = 500, removePrice = 750, anim = "FRONT", camera = {vec(-.05, 0.4, -0.38), vec(-.05, 0.61, -0.6)}},
		{label = "Hair", nameHash = "FM_M_Hair_003_b", price = 500, removePrice = 750, anim = "FRONT", camera = {vec(-.05, 0.4, -0.38), vec(-.05, 0.61, -0.6)}},
		{label = "Hair", nameHash = "FM_M_Hair_003_c", price = 500, removePrice = 750, anim = "FRONT", camera = {vec(-.05, 0.4, -0.38), vec(-.05, 0.61, -0.6)}},
		{label = "Hair", nameHash = "FM_M_Hair_003_d", price = 500, removePrice = 750, anim = "FRONT", camera = {vec(-.05, 0.4, -0.38), vec(-.05, 0.61, -0.6)}},
		{label = "Hair", nameHash = "FM_M_Hair_003_e", price = 500, removePrice = 750, anim = "FRONT", camera = {vec(-.05, 0.4, -0.38), vec(-.05, 0.61, -0.6)}},
		{label = "Hair", nameHash = "FM_M_Hair_006_a", price = 500, removePrice = 750, anim = "FRONT", camera = {vec(-.05, 0.4, -0.38), vec(-.05, 0.61, -0.6)}},
		{label = "Hair", nameHash = "FM_M_Hair_006_b", price = 500, removePrice = 750, anim = "FRONT", camera = {vec(-.05, 0.4, -0.38), vec(-.05, 0.61, -0.6)}},
		{label = "Hair", nameHash = "FM_M_Hair_006_c", price = 500, removePrice = 750, anim = "FRONT", camera = {vec(-.05, 0.4, -0.38), vec(-.05, 0.61, -0.6)}},
		{label = "Hair", nameHash = "FM_M_Hair_006_d", price = 500, removePrice = 750, anim = "FRONT", camera = {vec(-.05, 0.4, -0.38), vec(-.05, 0.61, -0.6)}},
		{label = "Hair", nameHash = "FM_M_Hair_006_e", price = 500, removePrice = 750, anim = "FRONT", camera = {vec(-.05, 0.4, -0.38), vec(-.05, 0.61, -0.6)}},
		{label = "Hair", nameHash = "FM_M_Hair_008_a", price = 500, removePrice = 750, anim = "FRONT", camera = {vec(-.05, 0.4, -0.38), vec(-.05, 0.61, -0.6)}},
		{label = "Hair", nameHash = "FM_M_Hair_008_b", price = 500, removePrice = 750, anim = "FRONT", camera = {vec(-.05, 0.4, -0.38), vec(-.05, 0.61, -0.6)}},
		{label = "Hair", nameHash = "FM_M_Hair_008_c", price = 500, removePrice = 750, anim = "FRONT", camera = {vec(-.05, 0.4, -0.38), vec(-.05, 0.61, -0.6)}},
		{label = "Hair", nameHash = "FM_M_Hair_008_d", price = 500, removePrice = 750, anim = "FRONT", camera = {vec(-.05, 0.4, -0.38), vec(-.05, 0.61, -0.6)}},
		{label = "Hair", nameHash = "FM_M_Hair_008_e", price = 500, removePrice = 750, anim = "FRONT", camera = {vec(-.05, 0.4, -0.38), vec(-.05, 0.61, -0.6)}},
		{label = "Hair", nameHash = "FM_M_Hair_long_a", price = 500, removePrice = 750, anim = "FRONT", camera = {vec(-.05, 0.4, -0.38), vec(-.05, 0.61, -0.6)}},
		{label = "Hair", nameHash = "FM_M_Hair_long_b", price = 500, removePrice = 750, anim = "FRONT", camera = {vec(-.05, 0.4, -0.38), vec(-.05, 0.61, -0.6)}},
		{label = "Hair", nameHash = "FM_M_Hair_long_c", price = 500, removePrice = 750, anim = "FRONT", camera = {vec(-.05, 0.4, -0.38), vec(-.05, 0.61, -0.6)}},
		{label = "Hair", nameHash = "FM_M_Hair_long_d", price = 500, removePrice = 750, anim = "FRONT", camera = {vec(-.05, 0.4, -0.38), vec(-.05, 0.61, -0.6)}},
		{label = "Hair", nameHash = "FM_M_Hair_long_e", price = 500, removePrice = 750, anim = "FRONT", camera = {vec(-.05, 0.4, -0.38), vec(-.05, 0.61, -0.6)}},
		{label = "Hair", nameHash = "NG_M_Hair_001", price = 500, removePrice = 750, anim = "FRONT", camera = {vec(-.05, 0.4, -0.38), vec(-.05, 0.61, -0.6)}},
		{label = "Hair", nameHash = "NG_M_Hair_002", price = 500, removePrice = 750, anim = "FRONT", camera = {vec(-.05, 0.4, -0.38), vec(-.05, 0.61, -0.6)}},
		{label = "Hair", nameHash = "NG_M_Hair_003", price = 500, removePrice = 750, anim = "FRONT", camera = {vec(-.05, 0.4, -0.38), vec(-.05, 0.61, -0.6)}},
		{label = "Hair", nameHash = "NG_M_Hair_004", price = 500, removePrice = 750, anim = "FRONT", camera = {vec(-.05, 0.4, -0.38), vec(-.05, 0.61, -0.6)}},
		{label = "Hair", nameHash = "NG_M_Hair_005", price = 500, removePrice = 750, anim = "FRONT", camera = {vec(-.05, 0.4, -0.38), vec(-.05, 0.61, -0.6)}},
		{label = "Hair", nameHash = "NG_M_Hair_006", price = 500, removePrice = 750, anim = "FRONT", camera = {vec(-.05, 0.4, -0.38), vec(-.05, 0.61, -0.6)}},
		{label = "Hair", nameHash = "NG_M_Hair_007", price = 500, removePrice = 750, anim = "FRONT", camera = {vec(-.05, 0.4, -0.38), vec(-.05, 0.61, -0.6)}},
		{label = "Hair", nameHash = "NG_M_Hair_008", price = 500, removePrice = 750, anim = "FRONT", camera = {vec(-.05, 0.4, -0.38), vec(-.05, 0.61, -0.6)}},
		{label = "Hair", nameHash = "NG_M_Hair_009", price = 500, removePrice = 750, anim = "FRONT", camera = {vec(-.05, 0.4, -0.38), vec(-.05, 0.61, -0.6)}},
		{label = "Hair", nameHash = "NG_M_Hair_010", price = 500, removePrice = 750, anim = "FRONT", camera = {vec(-.05, 0.4, -0.38), vec(-.05, 0.61, -0.6)}},
		{label = "Hair", nameHash = "NG_M_Hair_011", price = 500, removePrice = 750, anim = "FRONT", camera = {vec(-.05, 0.4, -0.38), vec(-.05, 0.61, -0.6)}},
		{label = "Hair", nameHash = "NG_M_Hair_012", price = 500, removePrice = 750, anim = "FRONT", camera = {vec(-.05, 0.4, -0.38), vec(-.05, 0.61, -0.6)}},
		{label = "Hair", nameHash = "NG_M_Hair_013", price = 500, removePrice = 750, anim = "FRONT", camera = {vec(-.05, 0.4, -0.38), vec(-.05, 0.61, -0.6)}},
		{label = "Hair", nameHash = "NG_M_Hair_014", price = 500, removePrice = 750, anim = "FRONT", camera = {vec(-.05, 0.4, -0.38), vec(-.05, 0.61, -0.6)}},
		{label = "Hair", nameHash = "NG_M_Hair_015", price = 500, removePrice = 750, anim = "FRONT", camera = {vec(-.05, 0.4, -0.38), vec(-.05, 0.61, -0.6)}},
		{label = "Hair", nameHash = "NGBea_M_Hair_000", price = 500, removePrice = 750, anim = "FRONT", camera = {vec(-.05, 0.4, -0.38), vec(-.05, 0.61, -0.6)}},
		{label = "Hair", nameHash = "NGBea_M_Hair_001", price = 500, removePrice = 750, anim = "FRONT", camera = {vec(-.05, 0.4, -0.38), vec(-.05, 0.61, -0.6)}},
		{label = "Hair", nameHash = "NGBus_M_Hair_000", price = 500, removePrice = 750, anim = "FRONT", camera = {vec(-.05, 0.4, -0.38), vec(-.05, 0.61, -0.6)}},
		{label = "Hair", nameHash = "NGBus_M_Hair_001", price = 500, removePrice = 750, anim = "FRONT", camera = {vec(-.05, 0.4, -0.38), vec(-.05, 0.61, -0.6)}},
		{label = "Hair", nameHash = "NGHip_M_Hair_000", price = 500, removePrice = 750, anim = "FRONT", camera = {vec(-.05, 0.4, -0.38), vec(-.05, 0.61, -0.6)}},
		{label = "Hair", nameHash = "NGHip_M_Hair_001", price = 500, removePrice = 750, anim = "FRONT", camera = {vec(-.05, 0.4, -0.38), vec(-.05, 0.61, -0.6)}},
		{label = "Hair", nameHash = "NGInd_M_Hair_000", price = 500, removePrice = 750, anim = "FRONT", camera = {vec(-.05, 0.4, -0.38), vec(-.05, 0.61, -0.6)}},
	},
}
end