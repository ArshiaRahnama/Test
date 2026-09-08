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
        -------------------------------------------------------------
        -- FIX (SCRIPT ERROR: attempt to compare nil with number, at
        -- the "if ganglevels[gang].XP + XP >= Config.GangLeveL[...]"
        -- line below): Config.GangLeveL only has entries for levels
        -- 1-10. Once a gang is already AT level 10 (max) and gains
        -- more XP, the old code looked up
        -- Config.GangLeveL[10 + 1] = Config.GangLeveL[11], which
        -- doesn't exist (nil) - comparing a number against that nil
        -- crashed this entire function (and the XP grant along with
        -- it) every time a maxed-out gang earned any more XP.
        -- Now: if already at max level, XP is just added without
        -- attempting to level up further - no more out-of-bounds
        -- lookup, and a maxed gang no longer errors out just for
        -- existing.
        -------------------------------------------------------------
        local atMaxLevel = ganglevels[gang].Level >= #Config.GangLeveL
        if not atMaxLevel and ganglevels[gang].XP + XP >= Config.GangLeveL[ganglevels[gang].Level + 1] then
            ganglevels[gang].XP =  ganglevels[gang].XP + XP
            while ganglevels[gang].Level < #Config.GangLeveL do 
                if ganglevels[gang].XP  >= Config.GangLeveL[ganglevels[gang].Level + 1]  then 
                    ganglevels[gang].XP = ganglevels[gang].XP  - Config.GangLeveL[ganglevels[gang].Level]
                    ganglevels[gang].Level = ganglevels[gang].Level + 1  
                    if ganglevels[gang].Level  > #Config.GangLeveL  then 
                        ganglevels[gang].Level = #Config.GangLeveL 
                        ganglevels[gang].XP    = Config.GangLeveL[#Config.GangLeveL]
                    end 
                    -------------------------------------------------
                    -- FEATURE (Config.LevelReward existed but was
                    -- never actually paid out anywhere - confirmed by
                    -- searching the whole codebase before adding
                    -- this): pays the configured reward straight into
                    -- the gang's own bank money the moment it
                    -- actually reaches this new level. Runs once per
                    -- level gained, so a big XP grant that jumps
                    -- several levels at once pays out for each one.
                    -------------------------------------------------
                    local reward = Config.LevelReward[ganglevels[gang].Level]
                    if reward and reward > 0 then
                        UpdateOthers(gang, 'money', reward, 'add')
                        -- Direct, clear notification instead of reusing
                        -- UpdateXP (which is worded specifically around
                        -- XP amounts - passing 0 there would have told
                        -- players they "received 0 XP", which is
                        -- confusing/wrong for what's actually a money
                        -- reward).
                        local xPlayers = ESX.GetPlayers()
                        for k, v in pairs(xPlayers) do
                            local xPlayer = ESX.GetPlayerFromId(v)
                            if xPlayer and xPlayer.gang and xPlayer.gang.name == gang then
                                TriggerClientEvent(Config.showNotification, xPlayer.source, ('~g~~h~Gang reached Level %s! ~y~~h~$%s~g~~h~ added to the gang bank.'):format(ganglevels[gang].Level, reward))
                            end
                        end
                        -- NOT using For5M:SendLog here on purpose: its
                        -- handler assumes a real player source
                        -- (ESX.GetPlayerFromId(source).gang.name) - a
                        -- level-up isn't triggered by any one player,
                        -- so passing a fake source would crash inside
                        -- that handler. Sending directly to whichever
                        -- online gang member's webhook is configured
                        -- instead, same request shape SendLog uses.
                        if Gangs[gang].webhook and Gangs[gang].webhook ~= '' then
                            PerformHttpRequest(Gangs[gang].webhook, function() end, 'POST', json.encode({
                                username = 'Heta RP',
                                embeds = {{
                                    ['color'] = '65352',
                                    ['title'] = 'Gang Level Up',
                                    ['description'] = ('**Gang:** %s\n**New Level:** %s\n**Reward:** $%s'):format(gang, ganglevels[gang].Level, reward),
                                    ['footer'] = { ['text'] = gang .. ' - Logs', ['icon_url'] = Gangs[gang].logo },
                                }}
                            }), { ['Content-Type'] = 'application/json' })
                        end
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

-------------------------------------------------------------------
-- FIX (same exploit class as FMGangsBoss:server:MoneyPack in
-- server/boss.lua - unlimited XP injection): no access check, amount
-- taken straight from the client, for any gang. Now requires the same
-- admin check as everywhere else, and ignores the client-sent amount
-- entirely - uses the fixed Config.Packs['xppack'] value instead
-- (the client already happened to send this correctly, but the raw
-- event was still directly callable with any number).
-------------------------------------------------------------------
RegisterNetEvent('For5M:AddGangXP')
AddEventHandler('For5M:AddGangXP', function(amount , gang )
    local src = source
    if not IsPlayerCanOpenPanel(src) then
        print('[Unique_ALLGangs] For5M:AddGangXP: source ' .. tostring(src) .. ' is not an admin - denying')
        return
    end
    if type(Gangs) ~= 'table' or not Gangs[gang] then return end
    local xp = tonumber(Config.Packs['xppack']) or 0
    UpdateXP(gang , xp , "XP PACK")
    Database(0, xp ,gang )
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