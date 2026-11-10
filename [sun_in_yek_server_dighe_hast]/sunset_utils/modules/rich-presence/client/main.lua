-- Pub by FleeX Team , https://discord.gg/87rGBxgCsa

Citizen.CreateThread(function ()
    waitForLoad()
    Rich()
end)

function Rich()
    local name
    local ass
    Citizen.Wait(1000)
    if ESX.GetPlayerData()['admin'] == 1 then
        name = 'Staff'
        ass = "admin"
    else
        if ESX.PlayerData.job ~= nil then
            if ESX.PlayerData.job.name  == "police" then
                name = "Police"
                ass = "lspd"
            elseif ESX.PlayerData.job.name  == "taxi" then
                name = "TAXI"
                ass = "taxi"
            elseif ESX.PlayerData.job.name  == "ambulance" then
                name = "EMS"
                ass = "ems"
            elseif ESX.PlayerData.job.name == "mechanic" then
                name = "MECHANIC"
                ass = "mechanic"
            end
        end
    end
    SetDiscordAppId(824643850865213441)
    SetDiscordRichPresenceAsset('big')
    SetDiscordRichPresenceAssetText('discord.gg/sunco')
    SetDiscordRichPresenceAssetSmall(ass)
    SetDiscordRichPresenceAssetSmallText(name)
    SetDiscordRichPresenceAction(0, "Play", "fivem://connect/set.fivemcore.ir")
    SetDiscordRichPresenceAction(1, "Website", "https://sunrp.ir")
    SetTimeout(59000,Rich)
end

RegisterNetEvent('reloadrich')
AddEventHandler('reloadrich',function(pcount)
    local pId = GetPlayerServerId(PlayerId())
    local pName = GetPlayerName(PlayerId())
    local maxPlayerSlots = 'Players'
    SetRichPresence(string.format("%s | %s %s | ID: %s", pName,pcount, maxPlayerSlots, pId))
end)
