ESX= nil
TriggerEvent(Config.ESX, function(obj) ESX = obj end)

Config.GangLeveL[0] = 0

-------------------------------------------------------------------
-- ONE level-up formula for the whole resource.
--   Config.GangLeveL[n] = XP needed to go from level n-1 to level n.
--   `xp` is the progress inside the CURRENT level, so on every level
--   gained the threshold of the level just reached is subtracted
--   (this is also what client/level.lua's bar animation assumes).
-- The old code subtracted the OLD level's threshold here and the NEW
-- one in server/Gangs.lua:UpdateXPAndLeveL, so leftover XP was wrong.
-- Handles max level (no out-of-range lookup), negative amounts (admin
-- /removexp - clamped at 0, levels are never taken away) and pays
-- Config.LevelReward once per level gained.
-------------------------------------------------------------------
function Database(source, XP, gang)
    local g = Gangs and Gangs[gang]
    if not g then return end
    XP = tonumber(XP) or 0

    local maxLevel = #Config.GangLeveL
    local level = tonumber(g.level) or 0
    local xp    = (tonumber(g.xp) or 0) + XP
    if xp < 0 then xp = 0 end

    local gained = {}
    while level < maxLevel and xp >= Config.GangLeveL[level + 1] do
        xp = xp - Config.GangLeveL[level + 1]
        level = level + 1
        gained[#gained + 1] = level
    end
    if level >= maxLevel then
        xp = math.min(xp, Config.GangLeveL[maxLevel] or xp) -- maxed gangs don't pile up XP forever
    end

    g.level = level
    g.xp = xp
    MySQL.Async.execute('UPDATE gangs SET xp = @XP, level = @Level WHERE name = @name', {
        ['@XP'] = xp, ['@Level'] = level, ['@name'] = gang,
    })

    for _, lvl in ipairs(gained) do
        local reward = Config.LevelReward and Config.LevelReward[lvl]
        if reward and reward > 0 then
            UpdateOthers(gang, 'money', reward, 'add')
        end
        for _, playerId in ipairs(ESX.GetPlayers()) do
            local xPlayer = ESX.GetPlayerFromId(playerId)
            if xPlayer and xPlayer.gang and xPlayer.gang.name == gang then
                TriggerClientEvent(Config.showNotification, xPlayer.source,
                    ('~g~~h~Gang reached Level %s!%s'):format(lvl, (reward and reward > 0) and (' ~y~~h~$' .. reward .. '~g~~h~ added to the gang bank.') or ''))
            end
        end
        if g.webhook and g.webhook ~= '' then
            local url = GetCategoryWebhook and GetCategoryWebhook(gang, 'Boss Action') or g.webhook
            if url and url ~= '' then
                PerformHttpRequest(url, function() end, 'POST', json.encode({
                    username = 'Heta RP',
                    embeds = {{
                        ['color'] = '65352',
                        ['title'] = 'Gang Level Up',
                        ['description'] = ('**Gang:** %s\n**New Level:** %s\n**Reward:** $%s'):format(gang, lvl, reward or 0),
                        ['footer'] = { ['text'] = gang .. ' - Logs', ['icon_url'] = g.logo },
                    }}
                }), { ['Content-Type'] = 'application/json' })
            end
        end
    end
end

-------------------------------------------------------------------
-- SECURITY FIX: `For5M:AddXP` used to be a RegisterNetEvent that took
-- the amount straight from the client - any gang member could send
-- any number. It is now a plain server-side event: the server (or
-- another server script via TriggerEvent) can still fire it, a
-- client cannot ("not safe for net").
-------------------------------------------------------------------
function AddGangXP(source, meghdar)
    local xPlayer = ESX.GetPlayerFromId(source)
    if not xPlayer or not xPlayer.gang or xPlayer.gang.name == 'nogang' then return end
    GrantGangXP(xPlayer.gang.name, meghdar, 'System')
end

AddEventHandler('For5M:AddXP', function(amount)
    -- NOT a net event any more (no RegisterNetEvent): only server code
    -- can fire it. `source` is the gang member the XP is credited to.
    AddGangXP(source, amount)
end)

-------------------------------------------------------------------
-- Admin / pack XP (no daily cap) - unchanged behaviour, still gated by
-- IsPlayerCanOpenPanel and ignores the client-sent amount.
-------------------------------------------------------------------
RegisterNetEvent('For5M:AddGangXP')
AddEventHandler('For5M:AddGangXP', function(amount , gang )
    local src = source
    -- client-reachable (XP pack button in the admin panel): admin only,
    -- and the client-sent amount is ignored - the fixed pack value is used.
    if not IsPlayerCanOpenPanel(src) then
        print('[Unique_ALLGangs] For5M:AddGangXP: source ' .. tostring(src) .. ' is not an admin - denying')
        return
    end
    if type(Gangs) ~= 'table' or not Gangs[gang] then return end
    local xp = tonumber(Config.Packs['xppack']) or 0
    UpdateXP(gang , xp , "XP PACK")
    Database(0, xp ,gang )
end)

-------------------------------------------------------------------
-- Server-only admin XP (/addxp, /removexp in server/main.lua). Not a
-- net event, so a client can never fire it. The commands check admin
-- rights themselves. This also restores real /addxp <gang> <amount>
-- and /removexp amounts: both used to go through the net event above,
-- which ignores the amount (always the pack value, and never negative).
-------------------------------------------------------------------
AddEventHandler('Unique_ALLGangs:AdminXP', function(amount, gang)
    if type(Gangs) ~= 'table' or not Gangs[gang] then return end
    amount = tonumber(amount) or 0
    if amount == 0 then return end
    if amount > 0 then UpdateXP(gang, amount, 'Admin') end
    Database(0, amount, gang)
end)

-------------------------------------------------------------------
-- GAMEPLAY XP with a per-gang daily cap (Config.GangXP).
-- Returns the amount actually granted (0 if capped/disabled).
-------------------------------------------------------------------
local DailyXP = {} -- DailyXP[gang] = { day = 'YYYY-MM-DD', xp = n }

function GrantGangXP(gang, amount, reason)
    if not Config.GangXP or not Config.GangXP.Enabled then return 0 end
    if not gang or gang == 'nogang' or not (Gangs and Gangs[gang]) then return 0 end
    amount = math.floor(tonumber(amount) or 0)
    if amount <= 0 then return 0 end

    local today = os.date('%Y-%m-%d')
    local rec = DailyXP[gang]
    if not rec or rec.day ~= today then
        rec = { day = today, xp = 0 }
        DailyXP[gang] = rec
    end
    local cap = tonumber(Config.GangXP.DailyCap) or 0
    if cap > 0 then
        amount = math.min(amount, cap - rec.xp)
    end
    if amount <= 0 then return 0 end

    rec.xp = rec.xp + amount
    UpdateXP(gang, amount, reason or 'Gang Activity')
    Database(0, amount, gang)
    return amount
end

-- How much of today's cap this gang has left (used by the war/XP UI).
function GetGangXPCapLeft(gang)
    local cap = tonumber(Config.GangXP and Config.GangXP.DailyCap) or 0
    if cap <= 0 then return math.huge end
    local rec = DailyXP[gang]
    if not rec or rec.day ~= os.date('%Y-%m-%d') then return cap end
    return math.max(0, cap - rec.xp)
end

-------------------------------------------------------------------
-- Level perks (Config.GangPerks): cumulative - the value comes from
-- the highest listed level <= the gang's level, per key.
-------------------------------------------------------------------
function GetGangPerk(gang, key, default)
    local level = Gangs and Gangs[gang] and tonumber(Gangs[gang].level) or 0
    for l = level, 0, -1 do
        local p = Config.GangPerks and Config.GangPerks[l]
        if p and p[key] ~= nil then return p[key] end
    end
    return default
end

function UpdateXP(gang, Add, MT)
    local xPlayers = ESX.GetPlayers()
    for k, v in pairs(xPlayers) do
        local xPlayer = ESX.GetPlayerFromId(v)
        if xPlayer and xPlayer.gang and xPlayer.gang.name == gang then
            TriggerClientEvent("For5M:AddXPtoGang", xPlayer.source, Add)
            TriggerClientEvent(Config.showNotification, xPlayer.source, '~g~~h~Gang Shoma ~y~~h~'..Add.." XP~g~~h~ Az ~y~~h~"..MT.." ~g~~h~Daryaft Kard.")
        end
    end
end