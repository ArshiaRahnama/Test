-- unique_character / server
--
-- Server half of the character registration (name check, name save, state check).
--
-- Why this exists instead of reusing es:newName + db:updateUser:
--   * es:newName only does Users[src].set('name', ...) which is RAM only, and
--     db:updateUser only whitelists `dateofbirth` -> playerName was never saved.
--   * es:newName trusted any client with any string (no format/uniqueness check).
--   * nameAvalibity (check) and the save were two separate steps -> two players
--     could take the same name.
-- Here validation, uniqueness and the write happen on the server, in one guarded
-- UPDATE, and a request is rejected if the player already has a character.

local ESX = nil
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

local busy      = {}  -- [source] = true while a register request is running
local claimed   = {}  -- [lower(name)] = source  (closes the check->write race)
local lastCheck = {}  -- [source] = GetGameTimer() of last state check

---------------------------------------------------------------------------
-- helpers
---------------------------------------------------------------------------

local function trim(s)
    return (s:gsub('^%s+', ''):gsub('%s+$', ''))
end

-- Returns a normalized "Abc" or nil. Letters A-Z only (never %a: it is locale
-- dependent), length from Config.Name, first letter upper / rest lower exactly
-- like the register form does.
local function normalizeName(s)
    if type(s) ~= 'string' then return nil end
    s = trim(s)
    if #s < Config.Name.Min or #s > Config.Name.Max then return nil end
    if not s:match('^[A-Za-z]+$') then return nil end
    return s:sub(1, 1):upper() .. s:sub(2):lower()
end

local function getPlayer(src)
    if ESX and ESX.GetPlayerFromId then
        local xPlayer = ESX.GetPlayerFromId(src)
        if xPlayer and xPlayer.identifier then return xPlayer end
    end
    local found
    TriggerEvent('es:getPlayerFromId', src, function(u) found = u end)
    if found and found.identifier then return found end
    return nil
end

local function isEmpty(v)
    return v == nil or v == '' or v == false
end

-- true when this row still needs a character
local function needsRegister(row)
    return (not row) or isEmpty(row.playerName) or isEmpty(row.dateofbirth)
end

local function fetchRow(identifier, cb)
    exports.oxmysql:execute(
        'SELECT `playerName`, `dateofbirth` FROM `users` WHERE `identifier` = @id LIMIT 1',
        { ['@id'] = identifier },
        function(rows) cb(rows and rows[1] or nil) end
    )
end

-- oxmysql returns a number or a table depending on version/call -> accept both
local function affectedRows(res)
    if type(res) == 'table' then return tonumber(res.affectedRows) or 0 end
    return tonumber(res) or 0
end

---------------------------------------------------------------------------
-- register (called by the NUI form through the client)
-- cb(code, fullName)   code: ok | already | invalid | taken | busy | error
---------------------------------------------------------------------------

ESX.RegisterServerCallback('unique_character:register', function(source, cb, firstname, lastname)
    local src = source
    local claimKey

    local function finish(code, name)
        busy[src] = nil
        if claimKey and claimed[claimKey] == src then claimed[claimKey] = nil end
        cb(code, name)
    end

    if busy[src] then return cb('busy') end

    local first, last = normalizeName(firstname), normalizeName(lastname)
    if not first or not last then return cb('invalid') end

    local player = getPlayer(src)
    if not player then return cb('error') end

    busy[src] = true
    local identifier = player.identifier
    local fullName   = first .. '_' .. last
    claimKey         = fullName:lower()

    if claimed[claimKey] and claimed[claimKey] ~= src then
        return finish('taken')
    end
    claimed[claimKey] = src

    fetchRow(identifier, function(row)
        if not row then return finish('error') end
        if not needsRegister(row) then return finish('already') end

        exports.oxmysql:execute(
            'SELECT 1 FROM `users` WHERE LOWER(`playerName`) = @n AND `identifier` <> @id LIMIT 1',
            { ['@n'] = claimKey, ['@id'] = identifier },
            function(taken)
                if taken and taken[1] then return finish('taken') end

                -- Guarded write: only succeeds while the character is still
                -- incomplete, so a second request can never overwrite a name.
                exports.oxmysql:update(
                    'UPDATE `users` SET `playerName` = @n, `dateofbirth` = @dob ' ..
                    'WHERE `identifier` = @id AND ' ..
                    '(`playerName` IS NULL OR `playerName` = \'\' OR `dateofbirth` IS NULL OR `dateofbirth` = \'\')',
                    { ['@n'] = fullName, ['@dob'] = Config.DefaultDateOfBirth, ['@id'] = identifier },
                    function(res)
                        if affectedRows(res) < 1 then return finish('error') end

                        -- keep the live player object + client in sync (what es:newName
                        -- tried to do, minus the missing DB write)
                        if player.setName then
                            player.setName(fullName)
                        else
                            player.name = fullName
                            TriggerClientEvent('nameUpdate', src, fullName)
                        end
                        player.dateofbirth = Config.DefaultDateOfBirth

                        print(('[unique_character] %s registered as %s'):format(identifier, fullName))
                        finish('ok', fullName)
                    end
                )
            end
        )
    end)
end)

---------------------------------------------------------------------------
-- fallback state check
-- essentialmode already pushes `registerForm` on login; this covers the case
-- where that event was missed. Rate limited so it cannot be used to spam SQL.
---------------------------------------------------------------------------

RegisterNetEvent('unique_character:check')
AddEventHandler('unique_character:check', function()
    local src = source
    local now = GetGameTimer()
    if lastCheck[src] and (now - lastCheck[src]) < 5000 then return end
    lastCheck[src] = now

    local player = getPlayer(src)
    if not player then return end -- not loaded yet, client retries

    fetchRow(player.identifier, function(row)
        if not row then return end
        TriggerClientEvent('unique_character:state', src, needsRegister(row))
    end)
end)

AddEventHandler('playerDropped', function()
    local src = source
    busy[src] = nil
    lastCheck[src] = nil
    for k, v in pairs(claimed) do
        if v == src then claimed[k] = nil end
    end
end)

-- exports for other resources (clothing system, admin panel, ...)
exports('NormalizeName', normalizeName)


---------------------------------------------------------------------------
-- conflicting loaders (see Config.ConflictingResources)
---------------------------------------------------------------------------

local function stopConflicts(reason)
    if not Config.StopConflicting then return end
    for _, name in ipairs(Config.ConflictingResources or {}) do
        if name ~= GetCurrentResourceName() then
            local state = GetResourceState(name)
            if state == 'started' or state == 'starting' then
                print(('[unique_character] stopping conflicting loader "%s" (%s)'):format(name, reason))
                StopResource(name)
            end
        end
    end
end

CreateThread(function()
    Wait(0)
    stopConflicts('unique_character started')
end)

AddEventHandler('onResourceStart', function(resource)
    for _, name in ipairs(Config.ConflictingResources or {}) do
        if name == resource then
            -- let it finish starting, then stop it again
            SetTimeout(500, function() stopConflicts('"' .. resource .. '" was (re)started') end)
        end
    end
end)
