Config_Shared                        = {}

Config_Shared.Framework              = "ESX" -- QB  Soon

-->>>>>>>>>>>>>>>>Just ESX User <<<<<<<<<<<<<<<<--
Config_Shared.ESX_Version            = 1                     -- [1] : old ESX (ESS) | [2] : New ESX (ESX Legacy)
Config_Shared.ESX_EventShearedObject = "esx:getSharedObject" -- Enter name event or server use Expoert nil


if Config_Shared.ESX_Version == 1 then
    --Rank Setting
    Config_Shared.Rank = {
        [1] = 'Intern',
    [2] = 'Helper',
    [3] = 'Senior Helper',
    [4] = 'Head Helper',
    [5] = 'Admin',
    [6] = 'Senior Admin',
    [7] = 'Executive Admin',
    [8] = 'Head Admin',
    [9] = 'Moderator',
    [10] = 'Supervisor',
    [11] = 'Administrator',
    [12] = 'None',
    [14] = 'None',
    [15] = 'None',
    [16] = 'Manager',
    [17] = 'Owner',
    [18] = 'None',
    [19] = 'None',
    [20] = 'None',
    [21] = 'None',
    [100] = "DEV",


    }
    -- UI Access
    Config_Shared.accessToAdminCommand = 1
    Config_Shared.accessToDelReport = 1
    Config_Shared.accessToAcceptReport = 1
    --Admin Option Access
    Config_Shared.AccessToGiveCar = 1
    Config_Shared.AccessToSpect = 1
    Config_Shared.AccessToTeleport = 1
    Config_Shared.AccessToRevive = 1
    --admin XP Access (add , remove ,show)
    Config_Shared.AdminXPAccess = 100
end
