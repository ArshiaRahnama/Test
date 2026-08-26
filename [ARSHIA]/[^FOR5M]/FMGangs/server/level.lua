ESX= nil
TriggerEvent(Config.ESX, function(obj) ESX = obj end)

Config.GangLeveL[0] = 0
local GangInfo = {}
local ganglevels = {}

function Database(source, XP, gang)
    if Gangs[gang] then
        
        ganglevels[gang] = { 
            Level = tonumber(Gangs[gang].level),
            XP    = tonumber(Gangs[gang].xp) ,
            
        } 
        if ganglevels[gang].XP + XP >= Config.GangLeveL[ganglevels[gang].Level + 1] then
            ganglevels[gang].XP =  ganglevels[gang].XP + XP
            while true do 
                if ganglevels[gang].XP  >= Config.GangLeveL[ganglevels[gang].Level + 1]  then 
                    ganglevels[gang].XP = ganglevels[gang].XP  - Config.GangLeveL[ganglevels[gang].Level]
                    ganglevels[gang].Level = ganglevels[gang].Level + 1  
                    if ganglevels[gang].Level  > #Config.GangLeveL  then 
                        ganglevels[gang].Level = #Config.GangLeveL 
                        ganglevels[gang].XP    = Config.GangLeveL[#Config.GangLeveL]
                    end 
                else 
                    break 
                end 
                Wait(100)
            end 
        else 
            ganglevels[gang].XP =  ganglevels[gang].XP + XP
        end
        Gangs[gang].level = ganglevels[gang].Level
        Gangs[gang].xp = ganglevels[gang].XP
        MySQL.Async.execute('UPDATE gangs SET xp = @XP, level = @Level WHERE name = @name', 
        {
            ['@XP']    = ganglevels[gang].XP,
            ['@Level']    = ganglevels[gang].Level,
            ['@name'] = gang
        })
        ganglevels[gang] = nil
    end
end

function AddGangXP(source, meghdar)
    local xPlayer = ESX.GetPlayerFromId(source)
    UpdateXP(xPlayer.gang.name, meghdar, "System")
    Database(source, meghdar, xPlayer.gang.name)
end

RegisterNetEvent('For5M:AddXP')
AddEventHandler('For5M:AddXP', function(amount)
    AddGangXP(source, amount)
end)

RegisterNetEvent('For5M:AddGangXP')
AddEventHandler('For5M:AddGangXP', function(amount , gang )
    UpdateXP(gang , amount , "XP PACK")
    Database(0, amount ,gang )
end)

function UpdateXP(gang, Add, MT)
    local xPlayers = ESX.GetPlayers()
    for k, v in pairs(xPlayers) do
        local xPlayer = ESX.GetPlayerFromId(v)
        if xPlayer.gang.name == gang then
            TriggerClientEvent("For5M:AddXPtoGang", xPlayer.source, Add)
            TriggerClientEvent(Config.showNotification, xPlayer.source, '~g~~h~Gang Shoma ~y~~h~'..Add.." XP~g~~h~ Az ~y~~h~"..MT.." ~g~~h~Daryaft Kard.")
        end
    end
end