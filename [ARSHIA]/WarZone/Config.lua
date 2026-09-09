Config = {}
Config.ESX = 'esx:getSharedObject'
--- Commend --- 
Config.StartCommend = 'startwarzone'
Config.JoinLobbeyCommend = 'wz'
Config.Startmatchcommend = "startmatch" 
--- other Commend ---
Config.exitCommend = "exitwz"
Config.closelobbey = "closelobbey"
Config.endwarzoneCommend = 'endwarzone'
--- Auto-Queue ---
Config.AutoQueue = {
    enabled = true,
    minPlayers = 4,      -- lobby auto-starts once this many players have joined
    countdown = 30,      -- seconds of countdown before auto-start
    defaultBlood = 3,
    defaultTime = 8,      -- minutes per zone shrink
    defaultMap = 'SANDY', -- 'SANDY' or 'ISLAND'
    defaultTeam = 2,      -- squad size
}
--- Discord Webhook ---
Config.DiscordWebhook = "" -- put your Discord webhook URL here (leave "" to disable)
Config.DiscordWebhookName = "WarZone"
--- Leaderboard / Season ---
Config.Leaderboard = {
    seasonRewardTop1 = 2000000, -- money paid to #1 on season reset
    top = 10,                   -- how many rows /wztop shows
}
Config.wztopCommend = 'wztop'
Config.seasonresetCommend = 'wzseasonreset' -- admin only
Config.panelCommend = 'wzpanel' -- admin only, opens the graphical admin panel
--- Admin ---
Config.permission = 16 
function IsPlayerCanStart(source) 
    local xPlayer = ESX.GetPlayerFromId(source) 
    -- Fix: xPlayer can be nil (e.g. command run from server console, or
    -- player not fully loaded yet), which used to crash with
    -- "attempt to index a nil value" instead of just denying the command.
    if xPlayer and xPlayer.permission_level and xPlayer.permission_level >= Config.permission  then  
        return true 
    else 
        return false 
    end 
end 
--- Reward ---
function Reward( src ) 
    local xPlayer = ESX.GetPlayerFromId(src) 
    if xPlayer then
        xPlayer.addMoney(500000)
    end
end 
--- Notify Function  -- 
function SendNotifyServerToPlayer(src , Notify , Tag ) -- For Server Side  -- tag = info / error / 
    -- Fix: essentialmode's client never registers a net event handler for
    -- 'esx:ShowNotification' (only a local ESX.ShowNotification function
    -- exists), so this call was silently doing nothing and players never saw
    -- these messages. Routed through our own event instead (added in
    -- client/main.lua).
    TriggerClientEvent('AWZ:ShowNotification' ,src , Notify)
end 
function SendNotifyToPlayer(Notify, Tag ) -- For Client side
    ESX.ShowNotification(Notify)
   
end 
--- other function ---
function FreezePlayer( freeze )
    TriggerEvent('es_admin:freezePlayer', freeze)
end 

function statusfull()
	TriggerEvent('esx_status:set', 'hunger', 1000000)
	TriggerEvent('esx_status:set', 'thirst', 1000000)
	TriggerEvent('esx_status:set', 'mental', 1000000)
end 
function AddWeapon( weapon , ammo )
	TriggerEvent('esx:addWeapon', weapon , ammo)
end 
function ReviveTrigger()
    TriggerEvent("esx_ambulancejob:revivex")
end 
function SetMaxHealth()
    SetEntityHealth(PlayerPedId(), GetEntityMaxHealth(PlayerPedId()))
end 	
function disableDeadEfect( disable )
	TriggerEvent("esx_paintball:inPaintBall", disable)
end 
---join lobbey 
function insertToJoinLobbey() 
    --- Everything you want happens when you join the lobby
end 
--- Notify --- 
Config.StartNotify = '^1 /wz  ^7 To Join Lobbey '
Config.StartMatchNotify = '^1 Match Started'
--- WarZone --- 
Config.FightWorld = 50
Config.LobbeyWorld = 50 
Config.Gulagworld = 50 
Config.DistanceZone = 1000.0 
Config.airplane = 'mammatus'
Config.ShowKillFeed = true 
Config.LobbeyCoord = vector3(-2131.17,3262.66,34.81)
Config.LastCoord  =  vector3(231.45, -746.1, 34.59) 
--- Gulag  --- 
Config.GulagZone = vector3(-529.5824, -1713.481, 21.28796) 
Config.GulagCoordSpwan = {
    vector3(-497.1033, -1682.756, 19.28796)	,
    vector3(-485.3407, -1731.27, 19.54065),
    vector3(-552.3165, -1684.193, 19.49011),
    vector3(-540.7516, -1691.024, 19.87769),
    vector3(-506.5846, -1689.89, 19.77661),
    vector3(-537.1517, -1701.481, 19.60803),
}
--- Sandy Zone ---
Config.SandyZone = vector3(401.42 , 2985.57 ,42.68)  
Config.SandyVehicles = {
    vector3(405.42 , 2987.57 ,42.68)  , 
}
Config.shops = {
    ['SANDY1'] = { -- SandyShopCoordsInZoneOne 
    vector3(533.84,2372.82,48.37), 
    vector3(562.16 , 2736.25 , 42.06), 
    vector3(5332.03 , 3086.49 , 40.47), 
    vector3(525.84 , 3577.49 , 32.8), 
    vector3(545.71 , 3365.43 , 99.99), 
    vector3(22.43 , 3321.2 , 38.49), 
    vector3(-133.74 , 2850.10 , 49.86), 
    vector3(-180.31 , 2390.35 , 94.06), 
    vector3(944.756, 3094.286, 41.26013)
    },
    ['SANDY2'] = {
    vector3(115.05 , 2696.94 , 52.59 ), 
	vector3(442.9 , 2996.13 , 40.66),
	vector3(687.12, 3152.63 , 42.03),
	vector3(203.02, 3253.04 , 41.7),
	vector3(587.67, 2786.67 , 42.19),
    },
    ['SANDY3'] = {
    vector3(383.21 , 2893.97 , 43.55), 
	vector3(389.19 , 2980.56 , 40.91) , 
	vector3(354.0 , 3088.44 , 48.76)
    }, 

    ['ISLAND1'] = {
        vector3(5047.97, -4880.59, 15.64) , 
        vector3(5154.15, -5131.53, 2.29),
        vector3(5587.24, -5222.88, 14.35) , 
        vector3(5262.36, -5433.44, 65.6) , 
        vector3(5319.66, -5597.26, 65.21) , 
        vector3(5484.2, -5852.13, 20.14) , 
        vector3(5012.6, -5744.08, 19.88) , 
        vector3(4887.37, -5460.19, 30.74) , 

    }, 
    ['ISLAND2'] = {
        vector3(5110.87, -5525.04, 54.24) , 
        vector3(5428.38, -5704.28, 36.82) , 
        vector3(5381.07, -5422.75, 45.81) , 
        vector3(5138.71, -5276.09, 8.35) , 
        vector3(5401.99, -5177.35, 31.45) , 

    }, 
    ['ISLAND3'] = {
        vector3(5255.68, -5442.74, 63.8) , 
        vector3(5278.21, -5296.3, 31.86) , 
        vector3(5169.35, -5358.93, 42.78) , 
    }, 

}
--- Island Zone ---
Config.IslandZone = vector3(5265.58, -5428.06, 65.6)
Config.IslandVehicles = {
    vector3(4767.455, -5589.468, 23.39929), 
    vector3(5286.198, -5107.187, 13.66003), 
    vector3(4891.029, -5737.227, 25.80884), 
    vector3(5321.13, -5250.606, 32.04321),
    vector3(5380.905, -5580.923, 52.22925),
    vector3(4938.422, -5237.117, 2.73811),
    vector3(5117.275, -5519.13, 54.1333) ,
    vector3(5330.492, -5258.479, 32.5824),
    vector3(4953.007, -5668.048, 20.88867),
    vector3(5458.681, -5229.982, 26.66809),
    vector3(4951.029, -5741.42, 19.42273),
    vector3(4962, -5722.892, 19.16992),
    vector3(5527.398, -5299.372, 11.94141),
    vector3(5529.284, -5288.545, 11.95825),
}
