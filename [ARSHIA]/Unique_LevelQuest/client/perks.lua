-- Rank bar (GTA native), level-up banner, level perks (HP/armor) and weapon
-- level gate. Perks and the gate are EMPTY by default (see config.lua).
local ESX = nil
CreateThread(function()
    while ESX == nil do
        TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
        Wait(0)
    end
end)

local MyRank, MyXP = nil, 0 -- nil until the server told us (otherwise everybody would be "level 1" for the first seconds)

local function xpNeeded(rank)
    return config.Levels[rank] or config.Levels[#config.Levels] or 1
end

local function setColour(id, c)
    ReplaceHudColourWithRgba(id, c.r, c.g, c.b, c.a)
end

local function showRankBar(before, after, rank)
    if not Config.RankBar or not Config.RankBar.enabled then return end
    setColour(116, Config.RankBar.bar)
    setColour(140, Config.RankBar.circle)
    RequestHudScaleform(19)
    local t = GetGameTimer()
    while not HasHudScaleformLoaded(19) do
        if GetGameTimer() - t > 3000 then return end
        Wait(0)
    end
    BeginScaleformMovieMethodHudComponent(19, 'SET_COLOUR')
    PushScaleformMovieFunctionParameterInt(116)
    PushScaleformMovieFunctionParameterInt(140)
    EndScaleformMovieMethodReturn()
    BeginScaleformMovieMethodHudComponent(19, 'SET_RANK_SCORES')
    PushScaleformMovieFunctionParameterInt(0)
    PushScaleformMovieFunctionParameterInt(xpNeeded(rank))
    PushScaleformMovieFunctionParameterInt(before)
    PushScaleformMovieFunctionParameterInt(after)
    PushScaleformMovieFunctionParameterInt(rank)
    PushScaleformMovieFunctionParameterInt(100)
    EndScaleformMovieMethodReturn()
end

local function applyPerks(rank)
    if not rank then return end
    local perk
    for _, p in ipairs(Config.LevelPerks or {}) do
        if rank >= p.level and (not perk or p.level > perk.level) then perk = p end
    end
    if not perk then return end
    local ped = PlayerPedId()
    if perk.hp then
        SetPedMaxHealth(ped, 100 + perk.hp)
    end
    if perk.armor then SetPlayerMaxArmour(PlayerId(), perk.armor) end
end

RegisterNetEvent('Unique_LevelQuest:xpUpdate')
AddEventHandler('Unique_LevelQuest:xpUpdate', function(rank, xp, delta, oldRank)
    MyRank, MyXP = rank, xp
    applyPerks(rank)
    if delta ~= 0 then
        local before = (rank ~= oldRank) and 0 or math.max(0, xp - delta)
        showRankBar(before, xp, rank)
    end
    if rank > oldRank then
        PlaySoundFrontend(-1, 'RANK_UP', 'HUD_AWARDS', true)
        TriggerEvent('hud:achievementToast', 'LEVEL UP', 'You reached level ' .. rank)
    end
end)

-- initial state + optional bar on join
CreateThread(function()
    while ESX == nil or not ESX.IsPlayerLoaded() do Wait(500) end
    Wait(8000)
    ESX.TriggerServerCallback('XP_System:getRank', function(rank)
        local r = tonumber(rank)
        if r and r >= 1 then MyRank = r end -- the callback answers -1 for "unknown"
        applyPerks(MyRank)
        if Config.RankBar and Config.RankBar.showOnJoin then showRankBar(MyXP, MyXP, MyRank) end
    end, GetPlayerServerId(PlayerId()))
end)

AddEventHandler('playerSpawned', function() applyPerks(MyRank) end)

-- weapon gate: only runs when the table is non-empty
if next(Config.WeaponMinLevel or {}) then
    local gate = {}
    for name, lvl in pairs(Config.WeaponMinLevel) do gate[GetHashKey(name)] = lvl end
    CreateThread(function()
        while true do
            Wait(500)
            local ped = PlayerPedId()
            local weapon = GetSelectedPedWeapon(ped)
            local need = gate[weapon]
            if need and MyRank and MyRank < need then
                SetCurrentPedWeapon(ped, GetHashKey("WEAPON_UNARMED"), true)
                TriggerEvent('esx:showNotification', 'Level ' .. need .. ' required for this weapon')
            end
        end
    end)
end


-- Newbie restriction (Unique: level 1 can't attack). Runs a per-frame loop ONLY
-- while the player is actually restricted; otherwise it polls once a second.
local newbieControls = { 24, 25, 45, 47, 140, 141, 142, 143, 170, 257, 263, 264 }
local lastNewbieMsg = 0

local function isExemptJob()
    local pd = ESX and ESX.GetPlayerData and ESX.GetPlayerData()
    local name = pd and pd.job and pd.job.name
    if not name then return false end
    name = name:gsub('^off', '')
    return Config.NewbieRestriction.exemptJobs and Config.NewbieRestriction.exemptJobs[name] or false
end

CreateThread(function()
    local cfg = Config.NewbieRestriction
    if not cfg or not cfg.enabled then return end
    while true do
        if MyRank and MyRank <= (cfg.maxLevel or 1) and not isExemptJob() then
            Wait(0)
            for _, c in ipairs(newbieControls) do DisableControlAction(0, c, true) end
            if IsDisabledControlJustPressed(0, 24) or IsDisabledControlJustPressed(0, 25) then
                local now = GetGameTimer()
                if now - lastNewbieMsg > 5000 then
                    lastNewbieMsg = now
                    TriggerEvent('esx:showNotification', cfg.message or 'You cannot fight yet')
                end
            end
        else
            Wait(1000)
        end
    end
end)
