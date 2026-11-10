-- Pub by FleeX Team , https://discord.gg/87rGBxgCsa

Cores = {
    { -- New ESX
        Name = "ESX",
        ResourceName = "essentialmode",
        GetFramework = function() return exports["essentialmode"]:getObject() end
    },
    -- { -- Old ESX
    --     Name = "ESX",
    --     ResourceName = "es_extended",
    --     GetFramework = function() ESX = nil while ESX == nil do TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end) end return ESX end
    -- },
    {
        Name = "QBCore",
        ResourceName = "qb-core",
        GetFramework = function() return exports["qb-core"]:GetCoreObject() end
    },
    {
        Name = "QBXCore",
        ResourceName = "qbx_core",
        GetFramework = function() return exports["qbx_core"]:GetCoreObject() end
    }
}