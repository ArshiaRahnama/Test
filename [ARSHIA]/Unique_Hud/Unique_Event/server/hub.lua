--[[
    Unique_Event - server hub
    * data for the /uevent menu (status of every event + the player's stats)
    * router for every hub button (UE.Actions[event][action])
    * admin spectate (works over any running event)
]]

-- ============================================================
-- Hub data
-- ============================================================
UE.Callback('ue:hub:get', function(src, cb)
    local xPlayer = UE.GetPlayer(src)
    local data = {
        me = {
            id = src,
            name = UE.Name(src),
            gang = UE.Gang(src),
            inEvent = UE.InEvent[src],
            inEventLabel = UE.InEvent[src] and UE.Label[UE.InEvent[src]] or nil,
            admin = {
                capture = UE.CanAdmin(src, 'capture'),
                gungame = UE.CanAdmin(src, 'gungame'),
                warzone = UE.CanAdmin(src, 'warzone'),
                spectate = Config.Spectate.Enabled and UE.CanAdmin(src, 'spectate'),
            },
            brand = Config.UI.Brand,
            hasCharacter = xPlayer ~= nil,
        },
        events = {},
        stats = {},
    }

    local tasks = {}
    for _, name in ipairs(UE.EventList) do
        local mod = UE.Modules[name]
        if mod and UE.IsEnabled(name) then
            local ok, status = pcall(mod.Status, src)
            status = (ok and type(status) == 'table') and status or {}
            status.enabled = true
            data.events[name] = status
            if mod.Stats then
                tasks[name] = function(done) mod.Stats(src, done) end
            end
        else
            data.events[name] = { enabled = false }
        end
    end

    UE.Parallel(tasks, function(results)
        data.stats = results
        cb(data)
    end)
end)

UE.Callback('ue:hub:leaderboards', function(src, cb)
    local tasks = {}
    for _, name in ipairs(UE.EventList) do
        local mod = UE.Modules[name]
        if mod and mod.Leaderboard and UE.IsEnabled(name) then
            tasks[name] = function(done) mod.Leaderboard(done) end
        end
    end
    UE.Parallel(tasks, function(results) cb(results) end)
end)

UE.Callback('ue:hub:page', function(src, cb, eventName)
    local mod = UE.Modules[eventName]
    if not mod or not mod.Page or not UE.IsEnabled(eventName) then return cb({}) end
    local ok = pcall(mod.Page, src, cb)
    if not ok then cb({}) end
end)

-- ============================================================
-- Action router (every hub button ends up here)
-- ============================================================
RegisterNetEvent('ue:hub:action')
AddEventHandler('ue:hub:action', function(eventName, action, data)
    local src = source
    if type(eventName) ~= 'string' or type(action) ~= 'string' then return end
    if UE.RateLimit(src, 'hubaction', 0.4) then return end
    if not UE.IsEnabled(eventName) and eventName ~= 'spectate' then return end

    local group = UE.Actions[eventName]
    local fn = group and group[action]
    if not fn then
        return UE.Notify(src, 'Unknown action.', 'error')
    end
    if type(data) ~= 'table' then data = {} end
    local ok, err = pcall(fn, src, data)
    if not ok then
        print(('^1[Unique_Event] action %s.%s failed: %s^7'):format(eventName, action, tostring(err)))
        UE.Notify(src, 'Something went wrong, please try again.', 'error')
    end
end)

-- ============================================================
-- Admin spectate
-- ============================================================
local Spectators = {}

local function spectateTargets(admin)
    local list = {}
    for _, id in ipairs(GetPlayers()) do
        local src = tonumber(id)
        local ev = UE.InEvent[src]
        if src ~= admin and not Spectators[src] and ev and ev ~= 'spectate' then
            list[#list + 1] = {
                source = src,
                name = UE.Name(src),
                event = ev,
                label = UE.Label[ev] or ev,
                gang = UE.Gang(src),
            }
        end
    end
    table.sort(list, function(a, b)
        if a.event ~= b.event then return a.event < b.event end
        return a.name < b.name
    end)
    return list
end

local function leaveSpectate(src, silent)
    if not Spectators[src] then return end
    Spectators[src] = nil
    UE.ResetBucket(src)
    UE.Exit(src, 'spectate')
    if not silent then TriggerClientEvent('ue:spec:forceLeave', src) end
end

if Config.Spectate.Enabled then
    UE.Command(Config.Spectate.Commands.Enter, function(src)
        if src == 0 then return end
        if not UE.CanAdmin(src, 'spectate') then
            return UE.Notify(src, "You don't have permission to spectate.", 'error')
        end
        if Spectators[src] then return UE.Notify(src, 'You are already spectating.', 'error') end
        if #spectateTargets(src) == 0 then
            return UE.Notify(src, 'Nobody is playing an event right now.', 'error')
        end
        local ok, why = UE.Enter(src, 'spectate')
        if not ok then return UE.Notify(src, 'You are already in ' .. tostring(why) .. '.', 'error') end
        Spectators[src] = true
        TriggerClientEvent('ue:spec:start', src)
    end)

    UE.Callback('ue:spec:targets', function(src, cb)
        if not Spectators[src] then return cb({}) end
        cb(spectateTargets(src))
    end)

    RegisterNetEvent('ue:spec:select')
    AddEventHandler('ue:spec:select', function(target)
        local src = source
        target = tonumber(target)
        if not Spectators[src] or not target then return end
        local ev = UE.InEvent[target]
        if not ev or ev == 'spectate' then
            return UE.Notify(src, 'That player is no longer in an event.', 'error')
        end
        -- move the spectator into the same world as the target so the ped streams in
        UE.SetBucket(src, GetPlayerRoutingBucket(target))
        TriggerClientEvent('ue:spec:locked', src, target)
    end)

    RegisterNetEvent('ue:spec:leave')
    AddEventHandler('ue:spec:leave', function()
        leaveSpectate(source, true)
    end)

    -- Nobody left to watch? Drop the spectators back to the normal world.
    CreateThread(function()
        while true do
            Wait(5000)
            for src in pairs(Spectators) do
                if #spectateTargets(src) == 0 then
                    UE.Notify(src, 'The event ended - leaving spectator mode.', 'info')
                    leaveSpectate(src, false)
                end
            end
        end
    end)

    UE.OnDrop(function(src) Spectators[src] = nil end)

    AddEventHandler('onResourceStop', function(res)
        if res ~= UE.Resource then return end
        for src in pairs(Spectators) do
            UE.ResetBucket(src)
        end
    end)
end
