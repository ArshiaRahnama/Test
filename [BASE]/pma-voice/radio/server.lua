local RES = GetCurrentResourceName()
local ESX = nil

local Access = nil            -- [freq] = { [jobOrGang] = true }
local Members = {}            -- [channel] = { [src] = true }
local MemberChannel = {}      -- [src] = channel
local CustomNames = {}        -- [identifier] = name
local PanicLast, GpsLast = {}, {}
local CheckRequests = {}      -- [targetSrc] = { from = src, time = ms }

---------------------------------------------------------------------------
-- helpers
---------------------------------------------------------------------------
local function now() return GetGameTimer() end

local function isOnline(src)
    return src ~= nil and GetPlayerName(src) ~= nil
end

local function sysMsg(src, text, color)
    if not isOnline(src) then return end
    TriggerClientEvent('chat:addMessage', src, {
        color = color or { 255, 0, 0 }, multiline = true, args = { '[SYSTEM]', text },
    })
end

local function sanitizeName(name)
    name = tostring(name or ''):gsub('[%c]', ''):gsub('%^%d', ''):gsub('^%s+', ''):gsub('%s+$', '')
    if #name > Config.NameMaxLength then name = name:sub(1, Config.NameMaxLength) end
    return name
end

local function identifierOf(src)
    for _, id in ipairs(GetPlayerIdentifiers(src)) do
        if id:sub(1, 8) == 'license:' then return id end
    end
    return GetPlayerIdentifier(src, 0)
end

local function getPlayer(src)
    if not ESX then return nil end
    local ok, xPlayer = pcall(ESX.GetPlayerFromId, src)
    if ok then return xPlayer end
    return nil
end

local function playerInfo(src)
    local xPlayer = getPlayer(src)
    if not xPlayer then return nil end
    local job = xPlayer.job and xPlayer.job.name or nil
    local gang = xPlayer.gang or {}
    return job, gang.name, gang.grade, xPlayer
end

local warnedInventory = false
local function hasRadioItem(src)
    if not Config.RequireItem then return true end
    local xPlayer = getPlayer(src)
    if not xPlayer then return false end
    local ok, item = pcall(xPlayer.getInventoryItem, Config.Item)
    if not ok then
        if not warnedInventory then
            warnedInventory = true
            print(('[%s] getInventoryItem failed (%s) - item check disabled until fixed'):format(RES, tostring(item)))
        end
        return true
    end
    return type(item) == 'table' and (tonumber(item.count) or 0) > 0
end

local function radioName(src)
    local id = identifierOf(src)
    if id and CustomNames[id] then return CustomNames[id] end
    local name
    local xPlayer = getPlayer(src)
    if xPlayer then
        local ok, n = pcall(xPlayer.getName)
        if ok and type(n) == 'string' and n ~= '' then name = n end
    end
    name = sanitizeName(name or GetPlayerName(src) or tostring(src))
    if name == '' then name = tostring(src) end
    return name
end

local function isAdmin(src)
    if src == 0 then return true end
    if IsPlayerAceAllowed(src, 'Unique_Radio.manage') then return true end
    local xPlayer = getPlayer(src)
    if xPlayer then
        local ok, group = pcall(xPlayer.getGroup)
        if ok and Config.AdminGroups[group] then return true end
    end
    return false
end

---------------------------------------------------------------------------
-- frequency access (persisted)
---------------------------------------------------------------------------
local function accessToJson(access)
    local out = {}
    for f, set in pairs(access) do out[tostring(f)] = set end
    return json.encode(out)
end

local function loadAccess()
    local raw = LoadResourceFile(RES, 'access.json')
    if raw and raw ~= '' then
        local ok, decoded = pcall(json.decode, raw)
        if ok and type(decoded) == 'table' then
            Access = UniqueRadio.NormalizeAccess(decoded)
            return
        end
        print(('[%s] access.json is invalid, using defaults'):format(RES))
    end
    Access = UniqueRadio.BuildDefaultAccess()
end

local function saveAccess()
    if not SaveResourceFile(RES, 'access.json', accessToJson(Access), -1) then
        print(('[%s] could not write access.json (changes last until restart)'):format(RES))
    end
end

loadAccess()

-- Returns allowed(bool), reason(string|nil)
local function evaluateJoin(src, freq)
    local f = UniqueRadio.ParseFrequency(freq)
    if not f then return false, 'range' end
    local job, gangName, gangGrade = playerInfo(src)
    if not job then return false, 'access' end
    if UniqueRadio.IsRestricted(job, gangName) then return false, 'restricted' end
    if not hasRadioItem(src) then return false, 'item' end
    if not UniqueRadio.CanAccess(Access, f, job, gangName, gangGrade) then return false, 'access' end
    return true
end

-- Called by server/module/radio.lua for player-initiated joins (same resource)
function UniqueRadioCanJoin(src, freq)
    if not Access then return true end
    local allowed, reason = evaluateJoin(src, freq)
    if not allowed then
        TriggerClientEvent('Unique_Radio:client:denied', src, reason)
    end
    return allowed
end

local function forceLeave(src, reason)
    pcall(function() exports['pma-voice']:setPlayerRadio(src, 0) end)
    if isOnline(src) then TriggerClientEvent('Unique_Radio:client:forceOff', src, reason) end
end

local function revalidate(src)
    local channel = MemberChannel[src]
    if not channel then return end
    local allowed, reason = evaluateJoin(src, channel)
    if not allowed then forceLeave(src, reason) end
end

---------------------------------------------------------------------------
-- roster tracking (fed by pma-voice server events)
---------------------------------------------------------------------------
local function leaveTracker(src)
    local channel = MemberChannel[src]
    if not channel then return end
    MemberChannel[src] = nil
    local set = Members[channel]
    if set then
        set[src] = nil
        for member in pairs(set) do
            TriggerClientEvent('Unique_Radio:client:memberLeft', member, src)
        end
        if next(set) == nil then Members[channel] = nil end
    end
    if isOnline(src) then TriggerClientEvent('Unique_Radio:client:clear', src) end
end

local function joinTracker(src, channel)
    if MemberChannel[src] then leaveTracker(src) end
    local name = radioName(src)
    local roster = {}
    Members[channel] = Members[channel] or {}
    for member in pairs(Members[channel]) do
        roster[#roster + 1] = { id = member, name = radioName(member) }
        TriggerClientEvent('Unique_Radio:client:memberJoined', member, src, name)
    end
    Members[channel][src] = true
    MemberChannel[src] = channel
    if Config.ShowSelfInList then roster[#roster + 1] = { id = src, name = name } end
    TriggerClientEvent('Unique_Radio:client:roster', src, channel, roster)
end

AddEventHandler('pma-voice:server:radioMemberAdded', function(src, channel)
    if channel and channel > 0 then joinTracker(src, channel) end
end)

AddEventHandler('pma-voice:server:radioMemberRemoved', function(src, channel)
    if channel and channel > 0 then leaveTracker(src) end
end)

AddEventHandler('playerDropped', function()
    local src = source
    local id = identifierOf(src)
    if Config.ResetCustomNameOnExit and id then CustomNames[id] = nil end
    PanicLast[src], GpsLast[src], CheckRequests[src] = nil, nil, nil
    -- pma-voice removes the player from its channel itself; this is only a safety net
    if MemberChannel[src] then leaveTracker(src) end
end)

---------------------------------------------------------------------------
-- ESX hooks: usable item, job changes
---------------------------------------------------------------------------
CreateThread(function()
    while ESX == nil do
        TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
        if ESX == nil then Wait(200) end
    end

    local function onUse(source)
        TriggerClientEvent('Unique_Radio:client:toggle', source)
    end
    local ok = pcall(ESX.RegisterUsableItem, Config.Item, onUse)
    if not ok then
        ok = pcall(function() return exports['essentialmode']:RegisterUsableItem(Config.Item, onUse) end)
    end
    if not ok then print(('[%s] could not register usable item "%s"'):format(RES, Config.Item)) end
end)

AddEventHandler('esx:setJob', function(src)
    if type(src) == 'number' then revalidate(src) end
end)

---------------------------------------------------------------------------
-- client requests
---------------------------------------------------------------------------
RegisterNetEvent('Unique_Radio:server:requestAccess', function()
    local out = {}
    for f, set in pairs(Access or {}) do out[tostring(f)] = set end
    TriggerClientEvent('Unique_Radio:client:syncAccess', source, out)
end)

-- radio must still be usable (item kept, job still allowed)
RegisterNetEvent('Unique_Radio:server:verify', function()
    local src = source
    if MemberChannel[src] then
        revalidate(src)
    elseif not hasRadioItem(src) then
        TriggerClientEvent('Unique_Radio:client:forceOff', src, 'item')
    end
end)

-- can the player open the radio (has the item)?
RegisterNetEvent('Unique_Radio:server:requestOpen', function()
    local src = source
    if hasRadioItem(src) then
        TriggerClientEvent('Unique_Radio:client:toggle', src)
    else
        TriggerClientEvent('Unique_Radio:client:denied', src, 'item')
    end
end)

RegisterNetEvent('Unique_Radio:server:panic', function()
    local src = source
    local channel = MemberChannel[src]
    if not channel or not Members[channel] then return end
    if PanicLast[src] and now() - PanicLast[src] < Config.PanicCooldown then return end
    local ped = GetPlayerPed(src)
    if not ped or ped == 0 then return end
    PanicLast[src] = now()
    local c = GetEntityCoords(ped)
    local coords = { x = c.x, y = c.y, z = c.z }
    local name = radioName(src)
    for member in pairs(Members[channel]) do
        TriggerClientEvent('Unique_Radio:client:alert', member, coords, src, name)
    end
end)

RegisterNetEvent('Unique_Radio:server:gps', function()
    local src = source
    local channel = MemberChannel[src]
    if not channel or not Members[channel] then return end
    if GpsLast[src] and now() - GpsLast[src] < Config.GPSCooldown then return end
    GpsLast[src] = now()
    local list = {}
    for member in pairs(Members[channel]) do
        if member ~= src then
            local ped = GetPlayerPed(member)
            if ped and ped ~= 0 then
                local c = GetEntityCoords(ped)
                list[#list + 1] = { id = member, name = radioName(member), x = c.x, y = c.y, z = c.z }
            end
        end
    end
    TriggerClientEvent('Unique_Radio:client:gps', src, list)
end)

-- Frequency manager -------------------------------------------------------
RegisterCommand('radiomanager', function(source)
    if source == 0 or not isAdmin(source) then return end
    local out = {}
    for f, set in pairs(Access) do out[tostring(f)] = set end
    TriggerClientEvent('Unique_Radio:client:openMenu', source, out)
end, false)

RegisterNetEvent('Unique_Radio:server:setFreq', function(freq, access)
    local src = source
    if not isAdmin(src) then return end
    local f = UniqueRadio.ParseFrequency(freq)
    if not f then return end
    if access == nil or access == false then
        Access[f] = nil
    else
        local clean = UniqueRadio.NormalizeAccess({ [f] = access })
        Access[f] = clean[f] or {}
    end
    saveAccess()
    local out = {}
    for k, set in pairs(Access) do out[tostring(k)] = set end
    TriggerClientEvent('Unique_Radio:client:syncAccess', -1, out)
    for member in pairs(Members[f] or {}) do revalidate(member) end
end)

---------------------------------------------------------------------------
-- /nameinradio
---------------------------------------------------------------------------
RegisterCommand('nameinradio', function(source, args)
    if source == 0 then return end
    local name = sanitizeName(table.concat(args, ' '))
    if name == '' then
        return sysMsg(source, '^0Estefade: /nameinradio [esm]')
    end
    local id = identifierOf(source)
    if not id then return end
    CustomNames[id] = name
    sysMsg(source, ('^0Esm shoma dar radio ^2%s^0 shod.'):format(name), { 0, 255, 0 })
    local channel = MemberChannel[source]
    if channel and Members[channel] then
        for member in pairs(Members[channel]) do
            if member ~= source then
                TriggerClientEvent('Unique_Radio:client:memberRenamed', member, source, name)
            end
        end
    end
end, false)

---------------------------------------------------------------------------
-- /checkfreq <id> , /checkfreq accept , /checkfreq decline
---------------------------------------------------------------------------
local function distanceBetween(a, b)
    local pa, pb = GetPlayerPed(a), GetPlayerPed(b)
    if not pa or pa == 0 or not pb or pb == 0 then return nil end
    return #(GetEntityCoords(pa) - GetEntityCoords(pb))
end

RegisterCommand('checkfreq', function(source, args)
    local src = source
    if src == 0 then return end
    local arg = args[1]
    if not arg then
        return sysMsg(src, '^0Estefade: /checkfreq [id] ya /checkfreq accept|decline')
    end

    if arg == 'accept' or arg == 'decline' then
        local req = CheckRequests[src]
        if not req or now() - req.time > Config.CheckFreqExpire or not isOnline(req.from) then
            CheckRequests[src] = nil
            return sysMsg(src, '^0Darkhasti baraye shoma vojud nadarad!')
        end
        CheckRequests[src] = nil
        if arg == 'decline' then
            return sysMsg(req.from, ('^0^*%s^r^0 darkhast ra rad kard!'):format(radioName(src)))
        end
        local dist = distanceBetween(src, req.from)
        if not dist or dist > Config.CheckFreqDistance then
            sysMsg(src, '^0Fasele shoma ba darkhast konande ziad ast!')
            return sysMsg(req.from, '^0Fasele shoma ba on shakhs ziad ast!')
        end
        local channel = MemberChannel[src]
        local text = channel and ('^0Frq radio ^2%s^0: ^3%d'):format(radioName(src), channel)
            or ('^0Radio ^2%s^0 khamush ast!'):format(radioName(src))
        return sysMsg(req.from, text, { 0, 255, 0 })
    end

    local target = tonumber(arg)
    if not target or target == src or not isOnline(target) then
        return sysMsg(src, '^0Player peyda nashod!')
    end
    local dist = distanceBetween(src, target)
    if not dist or dist > Config.CheckFreqDistance then
        return sysMsg(src, '^0Shoma be on shakhs nazdik nistid!')
    end
    CheckRequests[target] = { from = src, time = now() }
    sysMsg(src, '^0Darkhast ersal shod.', { 0, 255, 0 })
    sysMsg(target, ('^0^*%s^r^0 mikhahad frq radio shoma ra bebinad. ^2/checkfreq accept^0 ya ^1/checkfreq decline'):format(radioName(src)), { 255, 215, 0 })
end, false)
