Config = {}

------------------------------ █▀ █▀▄ ▄▀▄ █▄ ▄█ ██▀ █   █ ▄▀▄ █▀▄ █▄▀ ------------------------------
------------------------------ █▀ █▀▄ █▀█ █ ▀ █ █▄▄ ▀▄▀▄▀ ▀▄▀ █▀▄ █ █ ------------------------------
local frameworkAutoFind = function()
    if GetResourceState('es_extended') ~= 'missing' then
        return "ESX"
    elseif GetResourceState('qb-core') ~= 'missing' then
        return "QB-Core"
    end

    -- Fallback: some servers run ESX under a renamed/forked core resource,
    -- so GetResourceState('es_extended') alone can miss it even though ESX
    -- is genuinely running (confirmed working via this event on this server).
    local ESXObject = nil
    TriggerEvent('esx:getSharedObject', function(obj) ESXObject = obj end)
    if ESXObject then return "ESX" end

    local QBObject = nil
    TriggerEvent('QBCore:GetObject', function(obj) QBObject = obj end)
    if QBObject then return "QB-Core" end
end

Config.Core = frameworkAutoFind()
Config.CoreExport = function()
    if Config.Core == "ESX" then
        -- Matches this server's convention (used across esx_billing, esx_society, etc.)
        local ESXObject = nil
        TriggerEvent('esx:getSharedObject', function(obj) ESXObject = obj end)
        if ESXObject then return ESXObject end

        -- Fallback for newer es_extended builds that only expose the export
        local ok, result = pcall(function() return exports['es_extended']:getSharedObject() end)
        if ok and result then return result end

        return nil
    elseif Config.Core == "QB-Core" then
        return exports['qb-core']:GetCoreObject()
    end
end

---@field PlayerLoaded string: ESX: "esx:playerLoaded" / QB-Core: "QBCore:Client:OnPlayerLoaded"
Config.PlayerLoaded = Config.Core == "ESX" and "esx:playerLoaded" or "QBCore:Client:OnPlayerLoaded"  

---@field JobUpdated string: ESX: "esx:setJob" / QB-Core: "QBCore:Client:OnJobUpdate"
Config.JobUpdated = Config.Core == "ESX" and "esx:setJob" or "QBCore:Client:OnJobUpdate"


-------------------------- ▄▀▀ █▄▀ █ █▄ █ █▄ ▄█ ▄▀▄ █▄ █ ▄▀▄ ▄▀  ██▀ █▀▄ ---------------------------
-------------------------- ▄██ █ █ █ █ ▀█ █ ▀ █ █▀█ █ ▀█ █▀█ ▀▄█ █▄▄ █▀▄ ---------------------------
local skinmanagerAutoFind = function()
    if GetResourceState('esx_skin') == 'started' then
        return "esx_skin"
    elseif GetResourceState('qb-clothing') == 'started' then
        return "qb-clothing"
    elseif GetResourceState('fivem-appearance') == 'started' then
        return "fivem-appearance"
    elseif GetResourceState('illenium-appearance') == 'started' then
        return "illenium-appearance"
    end
end

---@field SkinManager string: "esx_skin", "fivem-appearance", "illenium-appearance", "qb-clothing"
Config.SkinManager = skinmanagerAutoFind()


------ █▄ ▄█ ▄▀▄ █ █▄ █   ▄▀▀ ██▀ ▀█▀ ▀█▀ █ █▄ █ ▄▀  ▄▀▀
------ █ ▀ █ █▀█ █ █ ▀█   ▄██ █▄▄  █   █  █ █ ▀█ ▀▄█ ▄██
---@field AutoExecuteQuery boolean: Automatic execution of the creation of the vms_business table in database
Config.AutoExecuteQuery = true

---@field UseTarget boolean: Do you want to use target system
Config.UseTarget = true
Config.TargetResource = 'ox_target' -- Prepared for 'ox_target', 'qb-target', 'qtarget' (config.client.lua - CL.Target)


---@field UseQSInventory boolean: if you use qs-inventory and clothing options
Config.QSInventoryName = 'qs-inventory'
Config.UseQSInventory = GetResourceState(Config.QSInventoryName) == 'started'


---@field UseVMSTattooshop boolean: 
Config.VMSTattooshopName = 'vms_tattooshop'
Config.UseVMSTattooshop = GetResourceState(Config.VMSTattooshopName) == 'started'
-- Your installed vms_tattooshop build doesn't export GetHairFadesList /
-- reloadPlayerTattoosByBarber (only reloadPlayerTattoos exists), so this
-- feature can't work yet. Set to true once vms_tattooshop actually adds
-- those two exports.
Config.UseHairFadeInBarber = false


Config.DistanceView = 8
Config.DistanceAccess = 1.1

Config.AnimDict = "misshair_shop@barbers"
Config.Anim = "keeper_idle_b"

Config.CanMakeup = true -- if you want a player can buy makeup's set true


Config.ChairSittingAnim = {'switch@michael@sitting', 'idle'}


---@field UseHairClipperRequired: You can use this if you want a player to have an item in inventory to be able to cut a players hairstyle 
Config.UseHairClipperRequired = false
Config.HairClipperItem = 'hair_clipper'


Config.Blip = {
    ["Sprite"] = 71,
    ["Scale"] = 0.6,
    ["Color"] = 3,
    ["Display"] = 4
}

Config.Markers = {
	['BossMenu'] = {
		id = 29,
		color = {95, 255, 95, 125}, -- rgba
		size = vec(0.33, 0.33, 0.33),
		bobUpAndDown = false,
        rotate = true,
        distanceToSee = 8.0,
        distanceToAccess = 1.0
	},
	['FreeSeat'] = {
		id = 21,
		size = vec(0.25, 0.25, 0.25),
		bobUpAndDown = false,
        rotate = true,
        distanceToSee = 8.0,
        distanceToAccess = 1.0
	},
	['TakenSeat'] = {
		id = 21,
		size = vec(0.25, 0.25, 0.25),
		bobUpAndDown = false,
        rotate = true,
        distanceToSee = 8.0,
        distanceToAccess = 1.0
	},
}

Config.CustomNames = {
    ["hair_1"] = {
        [0] = "Bald",
        [14] = "Dreadlocks",
        [16] = "Afro curls",
        [79] = "Curls",
    },
}

Config.Barbers = {
    ['HS_Barber_1'] = { -- HOT SHAVE | Carson Ave - Davis
        business = false, -- If you want the player to be a barber shop employee set true
        ownerJob = "barber1", -- If business is on true, here you must specify the work that has in this salon to manage
        society_name = "society_barber1", -- Used only with Config.UseBuildInCompanyBalance = false
        grades_access = {'recruit', 'employee', 'manager', 'boss'}, -- nil for every user with job, string: 'name', table: {'name', 'name2'}
        manager_grades = 'manager', -- string: 'name', table: {'name', 'name2'}
        boss_grades = 'boss', -- string: 'name', table: {'name', 'name2'}
        cityhall_grades = { -- Grades for sections from vms_cityhall
            ['resumes'] = {'manager', 'boss'}, -- string: 'name', table: {'name', 'name2'}
            ['taxes'] = {'manager', 'boss'}, -- string: 'name', table: {'name', 'name2'}
        },

        barber = "s_f_m_fembarber", -- If business is on false you can add a ped who will take care of the customer (for attractiveness and realism). If you set nil, the ped will not be.
        position = vector3(136.66, -1708.4, 28.29), -- Blip coordinates
        barberSpawnPos = vector4(141.45, -1705.82, 28.29, 141.47), -- If you have set barber here are the coords in which the ped spawns and goes to the player

        jobGradesToSet = {
            {grade = 0, label = 'Recruit'},
            {grade = 1, label = 'Employee'},
            {grade = 2, label = 'Manager', needToBeBoss = true}, -- needToBeBoss means that only the boss can give this grade, the manager will not be able to do so
            {grade = 3, label = 'Boss', needToBeBoss = true}, -- needToBeBoss means that only the boss can give this grade, the manager will not be able to do so
        },
        
        bossMenu = {
            coords = vector4(134.34, -1708.53, 28.7, 141.0),
            targetSize = vec(1.4, 1.0, 2.0),
        },
        takeSitMarker = {
            FreeColor = {255, 9, 106, 125}, -- RGBA color, if the seat is free
            TakenColor = {128, 0, 31, 110}, -- RGBA color, if the seat is taken
        },
        Chairs = {
            [1] = {
                position = vector3(136.8, -1709.88, 28.3), -- Marker coordinate to take a seat
                barberPos = vector4(137.68, -1709.84, 28.3, 224.61), -- Coordinates of the ped or employee in which he will stand to tattoo the customer
                chairCoord = vector4(137.81, -1710.77, 28.64, 229.93), -- Seat coordinates
                targetSize = vec(0.8, 2.3, 2.2),
                taken = false, -- DO NOT CHANGE IT
            },
            [2] = {
                position = vector3(137.79, -1708.71, 28.3),
                barberPos = vector4(138.59, -1708.64, 28.3, 230.57),
                chairCoord = vector4(138.72, -1709.58, 28.64, 232.26),
                targetSize = vec(0.8, 2.3, 2.2),
                taken = false,
            },
            [3] = {
                position = vector3(138.7, -1707.5, 28.3),
                barberPos = vector4(139.35, -1707.5, 28.3, 223.69),
                chairCoord = vector4(139.66, -1708.47, 28.64, 222.14),
                targetSize = vec(0.8, 2.3, 2.2),
                taken = false,
            },
        },
        prices = {
            ['hair_1'] = {price = 80},
            ['hair_2'] = {price = 20},
            ['hair_color_1'] = {price = 120},
            ['hair_color_2'] = {price = 100},
            ['hair_fade'] = {price = 90}, -- [[ Only if you are using vms_tattooshop ]]
            ['beard_1'] = {price = 90},
            ['beard_2'] = {price = 50},
            ['beard_3'] = {price = 80},
            ['eye_color'] = {price = 300},
            ['eyebrows_1'] = {price = 70},
            ['eyebrows_2'] = {price = 50},
            ['eyebrows_3'] = {price = 65},
            ['makeup_1'] = {price = 220},
            ['makeup_2'] = {price = 70},
            ['makeup_3'] = {price = 100},
            ['makeup_4'] = {price = 90},
            ['lipstick_1'] = {price = 70},
            ['lipstick_2'] = {price = 20},
            ['lipstick_3'] = {price = 50},
            ['blush_1'] = {price = 55},
            ['blush_2'] = {price = 45},
            ['blush_3'] = {price = 50}
        }
    },
    ['HS_Barber_2'] = { -- HAIR ON HAWICK | Hawick Ave - Havick
        business = false,
        ownerJob = "barber2",
        society_name = "society_barber2", -- Used only with Config.UseBuildInCompanyBalance = false
        grades_access = {'recruit', 'employee', 'manager', 'boss'}, -- nil for every user with job, string: 'name', table: {'name', 'name2'}
        manager_grades = 'manager', -- string: 'name', table: {'name', 'name2'}
        boss_grades = 'boss', -- string: 'name', table: {'name', 'name2'}
        cityhall_grades = { -- Grades for sections from vms_cityhall
            ['resumes'] = {'manager', 'boss'}, -- string: 'name', table: {'name', 'name2'}
            ['taxes'] = {'manager', 'boss'}, -- string: 'name', table: {'name', 'name2'}
        },

        barber = "s_f_m_fembarber",
        position = vector3(-32.15, -151.21, 56.08),
        barberSpawnPos = vector4(-36.58, -156.26, 56.08, 335.87),
        
        jobGradesToSet = {
            {grade = 0, label = 'Recruit'},
            {grade = 1, label = 'Employee'},
            {grade = 2, label = 'Manager', needToBeBoss = true}, -- needToBeBoss means that only the boss can give this grade, the manager will not be able to do so
            {grade = 3, label = 'Boss', needToBeBoss = true}, -- needToBeBoss means that only the boss can give this grade, the manager will not be able to do so
        },

        bossMenu = {
            coords = vector4(-30.55, -151.1, 56.5, 340.54),
            targetSize = vec(1.4, 1.0, 2.0),
        },
        takeSitMarker = {
            FreeColor = {255, 9, 106, 125},
            TakenColor = {128, 0, 31, 110},
        },
        Chairs = {
            [1] = {
                position = vector3(-33.49, -150.64, 56.09),
                barberPos = vector4(-34.35, -151.05, 56.09, 70.17),
                chairCoord = vector4(-34.67, -150.17, 56.44, 70.0),
                targetSize = vec(0.8, 2.3, 2.2),
                taken = false,
            },
            [2] = {
                position = vector3(-33.92, -152.11, 56.09),
                barberPos = vector4(-34.92, -152.49, 56.09, 65.57),
                chairCoord = vector4(-35.18, -151.61, 56.43, 70.81),
                targetSize = vec(0.8, 2.3, 2.2),
                taken = false,
            },
            [3] = {
                position = vector3(-34.41, -153.43, 56.09),
                barberPos = vector4(-35.35, -153.95, 56.09, 62.71),
                chairCoord = vector4(-35.7, -152.98, 56.42, 64.49),
                targetSize = vec(0.8, 2.3, 2.2),
                taken = false,
            },
        },
        prices = {
            ['hair_1'] = {price = 80},
            ['hair_2'] = {price = 20},
            ['hair_color_1'] = {price = 120},
            ['hair_color_2'] = {price = 100},
            ['hair_fade'] = {price = 90}, -- [[ Only if you are using vms_tattooshop ]]
            ['beard_1'] = {price = 90},
            ['beard_2'] = {price = 50},
            ['beard_3'] = {price = 80},
            ['eye_color'] = {price = 300},
            ['eyebrows_1'] = {price = 70},
            ['eyebrows_2'] = {price = 50},
            ['eyebrows_3'] = {price = 65},
            ['makeup_1'] = {price = 220},
            ['makeup_2'] = {price = 70},
            ['makeup_3'] = {price = 100},
            ['makeup_4'] = {price = 90},
            ['lipstick_1'] = {price = 70},
            ['lipstick_2'] = {price = 20},
            ['lipstick_3'] = {price = 50},
            ['blush_1'] = {price = 55},
            ['blush_2'] = {price = 45},
            ['blush_3'] = {price = 50}
        }
    },
    ['HS_Barber_3'] = { -- HOT SHAVE | Magellan Ave - Conquistador St, Vespucci
        business = false,
        ownerJob = "barber3",
        society_name = "society_barber3", -- Used only with Config.UseBuildInCompanyBalance = false
        grades_access = {'recruit', 'employee', 'manager', 'boss'}, -- nil for every user with job, string: 'name', table: {'name', 'name2'}
        manager_grades = 'manager', -- string: 'name', table: {'name', 'name2'}
        boss_grades = 'boss', -- string: 'name', table: {'name', 'name2'}
        cityhall_grades = { -- Grades for sections from vms_cityhall
            ['resumes'] = {'manager', 'boss'}, -- string: 'name', table: {'name', 'name2'}
            ['taxes'] = {'manager', 'boss'}, -- string: 'name', table: {'name', 'name2'}
        },

        barber = "s_f_m_fembarber",
        position = vector3(-1282.39, -1117.32, 5.99),
        barberSpawnPos = vector4(-1278.26, -1119.28, 5.99, 84.21),
        
        jobGradesToSet = {
            {grade = 0, label = 'Recruit'},
            {grade = 1, label = 'Employee'},
            {grade = 2, label = 'Manager', needToBeBoss = true}, -- needToBeBoss means that only the boss can give this grade, the manager will not be able to do so
            {grade = 3, label = 'Boss', needToBeBoss = true}, -- needToBeBoss means that only the boss can give this grade, the manager will not be able to do so
        },

        bossMenu = {
            coords = vector4(-1284.86, -1115.34, 6.5, 92),
            targetSize = vec(1.4, 1.0, 2.0),
        },
        takeSitMarker = {
            FreeColor = {255, 9, 106, 125},
            TakenColor = {128, 0, 31, 110},
        },
        Chairs = {
            [1] = {
                position = vector3(-1284.23, -1118.27, 6.0),
                barberPos = vector4(-1283.68, -1118.88, 6.0, 173.31),
                chairCoord = vector4(-1284.29, -1119.58, 6.32, 181.58),
                targetSize = vec(0.8, 2.3, 2.2),
                taken = false,
            },
            [2] = {
                position = vector3(-1282.81, -1118.26, 6.0),
                barberPos = vector4(-1282.18, -1119.05, 6.0, 168.95),
                chairCoord = vector4(-1282.83, -1119.58, 6.3, 181.58),
                targetSize = vec(0.9, 2.3, 2.2),
                taken = false,
            },
            [3] = {
                position = vector3(-1281.26, -1118.21, 6.0),
                barberPos = vector4(-1280.64, -1118.99, 6.0, 173.96),
                chairCoord = vector4(-1281.32, -1119.56, 6.34, 176.48),
                targetSize = vec(0.8, 2.3, 2.2),
                taken = false,
            },
        },
        prices = {
            ['hair_1'] = {price = 80},
            ['hair_2'] = {price = 20},
            ['hair_color_1'] = {price = 120},
            ['hair_color_2'] = {price = 100},
            ['hair_fade'] = {price = 90}, -- [[ Only if you are using vms_tattooshop ]]
            ['beard_1'] = {price = 90},
            ['beard_2'] = {price = 50},
            ['beard_3'] = {price = 80},
            ['eye_color'] = {price = 300},
            ['eyebrows_1'] = {price = 70},
            ['eyebrows_2'] = {price = 50},
            ['eyebrows_3'] = {price = 65},
            ['makeup_1'] = {price = 220},
            ['makeup_2'] = {price = 70},
            ['makeup_3'] = {price = 100},
            ['makeup_4'] = {price = 90},
            ['lipstick_1'] = {price = 70},
            ['lipstick_2'] = {price = 20},
            ['lipstick_3'] = {price = 50},
            ['blush_1'] = {price = 55},
            ['blush_2'] = {price = 45},
            ['blush_3'] = {price = 50}
        }
    },
    ['HS_Barber_4'] = { -- HOT SHAVE | Mirror Park Blvd - Park Mirror
        business = false,
        ownerJob = "barber4",
        society_name = "society_barber4", -- Used only with Config.UseBuildInCompanyBalance = false
        grades_access = {'recruit', 'employee', 'manager', 'boss'}, -- nil for every user with job, string: 'name', table: {'name', 'name2'}
        manager_grades = 'manager', -- string: 'name', table: {'name', 'name2'}
        boss_grades = 'boss', -- string: 'name', table: {'name', 'name2'}
        cityhall_grades = { -- Grades for sections from vms_cityhall
            ['resumes'] = {'manager', 'boss'}, -- string: 'name', table: {'name', 'name2'}
            ['taxes'] = {'manager', 'boss'}, -- string: 'name', table: {'name', 'name2'}
        },

        barber = "s_f_m_fembarber",
        position = vector3(1213.42, -472.78, 65.21),
        barberSpawnPos = vector4(1216.58, -476.0, 65.21, 73.17),
        
        jobGradesToSet = {
            {grade = 0, label = 'Recruit'},
            {grade = 1, label = 'Employee'},
            {grade = 2, label = 'Manager', needToBeBoss = true}, -- needToBeBoss means that only the boss can give this grade, the manager will not be able to do so
            {grade = 3, label = 'Boss', needToBeBoss = true}, -- needToBeBoss means that only the boss can give this grade, the manager will not be able to do so
        },

        bossMenu = {
            coords = vector4(1210.81, -470.37, 66.1, 73.69),
            targetSize = vec(1.45, 1.0, 2.0),
        },
        takeSitMarker = {
            FreeColor = {255, 9, 106, 125},
            TakenColor = {128, 0, 31, 110},
        },
        Chairs = {
            [1] = {
                position = vector3(1210.66, -473.39, 65.22),
                barberPos = vector4(1211.07, -474.24, 65.22, 161.51),
                chairCoord = vector4(1210.33, -474.67, 65.53, 163.11),
                targetSize = vec(0.8, 2.3, 2.2),
                taken = false,
            },
            [2] = {
                position = vector3(1212.04, -473.8, 65.22),
                barberPos = vector4(1212.56, -474.56, 65.22, 157.56),
                chairCoord = vector4(1211.72, -475.02, 65.55, 162.0),
                targetSize = vec(0.85, 2.3, 2.2),
                taken = false,
            },
            [3] = {
                position = vector3(1213.64, -474.13, 65.22),
                barberPos = vector4(1213.97, -475.06, 65.22, 162.07),
                chairCoord = vector4(1213.18, -475.46, 65.55, 160.01),
                targetSize = vec(0.8, 2.3, 2.2),
                taken = false,
            },
        },
        prices = {
            ['hair_1'] = {price = 80},
            ['hair_2'] = {price = 20},
            ['hair_color_1'] = {price = 120},
            ['hair_color_2'] = {price = 100},
            ['hair_fade'] = {price = 90}, -- [[ Only if you are using vms_tattooshop ]]
            ['beard_1'] = {price = 90},
            ['beard_2'] = {price = 50},
            ['beard_3'] = {price = 80},
            ['eye_color'] = {price = 300},
            ['eyebrows_1'] = {price = 70},
            ['eyebrows_2'] = {price = 50},
            ['eyebrows_3'] = {price = 65},
            ['makeup_1'] = {price = 220},
            ['makeup_2'] = {price = 70},
            ['makeup_3'] = {price = 100},
            ['makeup_4'] = {price = 90},
            ['lipstick_1'] = {price = 70},
            ['lipstick_2'] = {price = 20},
            ['lipstick_3'] = {price = 50},
            ['blush_1'] = {price = 55},
            ['blush_2'] = {price = 45},
            ['blush_3'] = {price = 50}
        }
    },
    ['HS_Barber_5'] = { -- HOT SHAVE | Paleto Blvd - Duluoz Ave, Paleto Bay
        business = false,
        ownerJob = "barber5",
        society_name = "society_barber5", -- Used only with Config.UseBuildInCompanyBalance = false
        grades_access = {'recruit', 'employee', 'manager', 'boss'}, -- nil for every user with job, string: 'name', table: {'name', 'name2'}
        manager_grades = 'manager', -- string: 'name', table: {'name', 'name2'}
        boss_grades = 'boss', -- string: 'name', table: {'name', 'name2'}
        cityhall_grades = { -- Grades for sections from vms_cityhall
            ['resumes'] = {'manager', 'boss'}, -- string: 'name', table: {'name', 'name2'}
            ['taxes'] = {'manager', 'boss'}, -- string: 'name', table: {'name', 'name2'}
        },

        barber = "s_f_m_fembarber",
        position = vector3(-277.79, 6227.79, 30.7),
        barberSpawnPos = vector4(-276.25, 6223.28, 30.7, 44.09),
        
        jobGradesToSet = {
            {grade = 0, label = 'Recruit'},
            {grade = 1, label = 'Employee'},
            {grade = 2, label = 'Manager', needToBeBoss = true}, -- needToBeBoss means that only the boss can give this grade, the manager will not be able to do so
            {grade = 3, label = 'Boss', needToBeBoss = true}, -- needToBeBoss means that only the boss can give this grade, the manager will not be able to do so
        },

        bossMenu = {
            coords = vector4(-278.46, 6230.97, 31.15, 43.64),
            targetSize = vec(1.4, 1.0, 2.0),
        },
        takeSitMarker = {
            FreeColor = {255, 9, 106, 125},
            TakenColor = {128, 0, 31, 110},
        },
        Chairs = {
            [1] = {
                position = vector3(-280.02, 6228.49, 30.71),
                barberPos = vector4(-280.08, 6227.54, 30.71, 130.38),
                chairCoord = vector4(-280.99, 6227.58, 31.02, 133.88),
                targetSize = vec(0.8, 2.3, 2.2),
                taken = false,
            },
            [2] = {
                position = vector3(-278.98, 6227.4, 30.71),
                barberPos = vector4(-279.01, 6226.51, 30.71, 134.92),
                chairCoord = vector4(-279.91, 6226.51, 31.01, 137.31),
                targetSize = vec(0.85, 2.3, 2.2),
                taken = false,
            },
            [3] = {
                position = vector3(-277.87, 6226.38, 30.71),
                barberPos = vector4(-277.97, 6225.36, 30.71, 128.69),
                chairCoord = vector4(-278.88, 6225.48, 31.01, 131.52),
                targetSize = vec(0.85, 2.3, 2.2),
                taken = false,
            },
        },
        prices = {
            ['hair_1'] = {price = 80},
            ['hair_2'] = {price = 20},
            ['hair_color_1'] = {price = 120},
            ['hair_color_2'] = {price = 100},
            ['hair_fade'] = {price = 90}, -- [[ Only if you are using vms_tattooshop ]]
            ['beard_1'] = {price = 90},
            ['beard_2'] = {price = 50},
            ['beard_3'] = {price = 80},
            ['eye_color'] = {price = 300},
            ['eyebrows_1'] = {price = 70},
            ['eyebrows_2'] = {price = 50},
            ['eyebrows_3'] = {price = 65},
            ['makeup_1'] = {price = 220},
            ['makeup_2'] = {price = 70},
            ['makeup_3'] = {price = 100},
            ['makeup_4'] = {price = 90},
            ['lipstick_1'] = {price = 70},
            ['lipstick_2'] = {price = 20},
            ['lipstick_3'] = {price = 50},
            ['blush_1'] = {price = 55},
            ['blush_2'] = {price = 45},
            ['blush_3'] = {price = 50}
        }
    },
    ['HS_Barber_6'] = { -- HOT SHAVE | Alhambra Dr - Niland Ave, Sandy Shores
        business = false,
        ownerJob = "barber6",
        society_name = "society_barber6", -- Used only with Config.UseBuildInCompanyBalance = false
        grades_access = {'recruit', 'employee', 'manager', 'boss'}, -- nil for every user with job, string: 'name', table: {'name', 'name2'}
        manager_grades = 'manager', -- string: 'name', table: {'name', 'name2'}
        boss_grades = 'boss', -- string: 'name', table: {'name', 'name2'}
        cityhall_grades = { -- Grades for sections from vms_cityhall
            ['resumes'] = {'manager', 'boss'}, -- string: 'name', table: {'name', 'name2'}
            ['taxes'] = {'manager', 'boss'}, -- string: 'name', table: {'name', 'name2'}
        },

        barber = "s_f_m_fembarber",
        position = vector3(1931.31, 3730.76, 31.84),
        barberSpawnPos = vector4(1930.96, 3735.47, 31.84, 206.07),
        
        jobGradesToSet = {
            {grade = 0, label = 'Recruit'},
            {grade = 1, label = 'Employee'},
            {grade = 2, label = 'Manager', needToBeBoss = true}, -- needToBeBoss means that only the boss can give this grade, the manager will not be able to do so
            {grade = 3, label = 'Boss', needToBeBoss = true}, -- needToBeBoss means that only the boss can give this grade, the manager will not be able to do so
        },

        bossMenu = {
            coords = vector4(1931.06, 3727.56, 32.23, 206.5),
            targetSize = vec(1.45, 1.0, 2.0),
        },
        takeSitMarker = {
            FreeColor = {255, 9, 106, 125},
            TakenColor = {128, 0, 31, 110},
        },
        Chairs = {
            [1] = {
                position = vector3(1933.38, 3729.52, 31.85),
                barberPos = vector4(1933.68, 3730.4, 31.85, 290.18),
                chairCoord = vector4(1934.5, 3730.15, 32.17, 300.59),
                targetSize = vec(0.8, 2.3, 2.2),
                taken = false,
            },
            [2] = {
                position = vector3(1932.58, 3730.84, 31.85),
                barberPos = vector4(1932.93, 3731.7, 31.85, 286.74),
                chairCoord = vector4(1933.72, 3731.43, 32.17, 299.43),
                targetSize = vec(0.8, 2.3, 2.2),
                taken = false,
            },
            [3] = {
                position = vector3(1931.87, 3732.11, 31.85),
                barberPos = vector4(1932.19, 3733.02, 31.85, 287.76),
                chairCoord = vector4(1933.02, 3732.7, 32.17, 295.57),
                targetSize = vec(0.8, 2.3, 2.2),
                taken = false,
            },
        },
        prices = {
            ['hair_1'] = {price = 80},
            ['hair_2'] = {price = 20},
            ['hair_color_1'] = {price = 120},
            ['hair_color_2'] = {price = 100},
            ['hair_fade'] = {price = 90}, -- [[ Only if you are using vms_tattooshop ]]
            ['beard_1'] = {price = 90},
            ['beard_2'] = {price = 50},
            ['beard_3'] = {price = 80},
            ['eye_color'] = {price = 300},
            ['eyebrows_1'] = {price = 70},
            ['eyebrows_2'] = {price = 50},
            ['eyebrows_3'] = {price = 65},
            ['makeup_1'] = {price = 220},
            ['makeup_2'] = {price = 70},
            ['makeup_3'] = {price = 100},
            ['makeup_4'] = {price = 90},
            ['lipstick_1'] = {price = 70},
            ['lipstick_2'] = {price = 20},
            ['lipstick_3'] = {price = 50},
            ['blush_1'] = {price = 55},
            ['blush_2'] = {price = 45},
            ['blush_3'] = {price = 50}
        }
    },
    ['HS_Barber_7'] = { -- BOB MULET | Mad Wayne Thunder Dr - Rockford Hills
        business = true,
        ownerJob = 'barber7',
        society_name = "society_barber7", -- Used only with Config.UseBuildInCompanyBalance = false
        grades_access = {'recruit', 'employee', 'manager', 'boss'}, -- nil for every user with job, string: 'name', table: {'name', 'name2'}
        manager_grades = 'manager', -- string: 'name', table: {'name', 'name2'}
        boss_grades = 'boss', -- string: 'name', table: {'name', 'name2'}
        cityhall_grades = { -- Grades for sections from vms_cityhall
            ['resumes'] = {'manager', 'boss'}, -- string: 'name', table: {'name', 'name2'}
            ['taxes'] = {'manager', 'boss'}, -- string: 'name', table: {'name', 'name2'}
        },

        barber = "s_f_m_fembarber",
        position = vector3(-814.58, -184.39, 36.57),
        barberSpawnPos = vector4(-808.27, -179.79, 36.57, 124.26),
        
        jobGradesToSet = {
            {grade = 0, label = 'Recruit'},
            {grade = 1, label = 'Employee'},
            {grade = 2, label = 'Manager', needToBeBoss = true}, -- needToBeBoss means that only the boss can give this grade, the manager will not be able to do so
            {grade = 3, label = 'Boss', needToBeBoss = true}, -- needToBeBoss means that only the boss can give this grade, the manager will not be able to do so
        },
        
        bossMenu = {
            coords = vector4(-822.47, -184.34, 36.57, 210.07),
            targetSize = vec(3.35, 0.65, 3.0),
        },
        takeSitMarker = {
            FreeColor = {255, 9, 106, 125},
            TakenColor = {128, 0, 31, 110},
        },
        Chairs = {
            [1] = {
                position = vector3(-817.68, -184.44, 36.57),
                barberPos = vector4(-818.15, -184.76, 36.57, 344.45),
                chairCoord = vector4(-818.24, -183.42, 36.8, 30.3),
                targetSize = vec(0.9, 2.0, 2.2),
                taken = false,
            },
            [2] = {
                position = vector3(-815.9, -183.45, 36.57),
                barberPos = vector4(-816.43, -183.68, 36.57, 351.06),
                chairCoord = vector4(-816.56, -182.41, 36.8, 30.3),
                targetSize = vec(0.9, 2.0, 2.2),
                taken = false,
            },
            [3] = {
                position = vector3(-814.16, -182.53, 36.57),
                barberPos = vector4(-814.65, -182.68, 36.57, 355.75),
                chairCoord = vector4(-814.76, -181.46, 36.8, 30.3),
                targetSize = vec(0.9, 2.0, 2.2),
                taken = false,
            },
            [4] = {
                position = vector3(-812.44, -181.54, 36.57),
                barberPos = vector4(-813.22, -181.52, 36.57, 25.87),
                chairCoord = vector4(-813.05, -180.45, 36.8, 30.3),
                targetSize = vec(0.9, 2.0, 2.2),
                taken = false,
            },
        },
        prices = {
            ['hair_1'] = {price = 80},
            ['hair_2'] = {price = 20},
            ['hair_color_1'] = {price = 120},
            ['hair_color_2'] = {price = 100},
            ['hair_fade'] = {price = 90}, -- [[ Only if you are using vms_tattooshop ]]
            ['beard_1'] = {price = 90},
            ['beard_2'] = {price = 50},
            ['beard_3'] = {price = 80},
            ['eye_color'] = {price = 300},
            ['eyebrows_1'] = {price = 70},
            ['eyebrows_2'] = {price = 50},
            ['eyebrows_3'] = {price = 65},
            ['makeup_1'] = {price = 220},
            ['makeup_2'] = {price = 70},
            ['makeup_3'] = {price = 100},
            ['makeup_4'] = {price = 90},
            ['lipstick_1'] = {price = 70},
            ['lipstick_2'] = {price = 20},
            ['lipstick_3'] = {price = 50},
            ['blush_1'] = {price = 55},
            ['blush_2'] = {price = 45},
            ['blush_3'] = {price = 50}
        }
    },
}