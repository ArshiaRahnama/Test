function tLength(t)
    local l = 0
    for k, v in pairs(t) do
        l = l + 1
    end

    return l
end
db = {}

-- SECURITY FIX: this used to accept an arbitrary table from the client and
-- blindly UPDATE every key in it (group, permission_level, money, bank, ...)
-- via raw string concatenation into the SQL query -- both an unrestricted
-- privilege-escalation vector (any client could set their own group/
-- permission_level) and a straight SQL injection (unescaped string values
-- concatenated directly into the query). Fixed by:
--   1. A hard whitelist of columns this event is allowed to touch (only
--      the fields it was actually meant for -- extend ALLOWED_UPDATE_FIELDS
--      if you need to expose more, never accept an arbitrary table again).
--   2. Fully parameterized query (no string concatenation of values at all).
local ALLOWED_UPDATE_FIELDS = {
    dateofbirth = "string",
}

-- Columns a SERVER side save may write (autosave, disconnect, shutdown, license ...).
-- A client can NOT reach this list: the db:updateUser net event below filters its payload with
-- ALLOWED_UPDATE_FIELDS (dateofbirth only) BEFORE it calls db.updateUser. Before this list existed
-- db.updateUser shared the client whitelist, so every server save of money / bank / inventory /
-- loadout / status that went through it (player disconnect, ESX.savePlayerMoney, license) was
-- silently dropped and only the 8 minute autosave ever stored anything.
local SERVER_UPDATE_FIELDS = {
    dateofbirth = true,
    license = true,
    money = true,
    bank = true,
    black_money = true,
    position = true,
    inventory = true,
    loadout = true,
    invslots = true,
    status = true,
}

-- invslots is created by the boot migration (asynchronously) and status may be missing on old
-- databases. A single unknown column makes the whole UPDATE fail and then NOTHING is saved,
-- so these are only written once we know the column exists.
local OPTIONAL_COLUMNS = { invslots = true, status = true }
local knownColumns = nil
local warnedMissing = {}

local function refreshColumns()
    local ok = pcall(function()
        exports.oxmysql:execute(
            "SELECT COLUMN_NAME AS c FROM information_schema.COLUMNS WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'users'",
            {},
            function(rows)
                if type(rows) ~= "table" or #rows == 0 then return end
                local found = {}
                for _, r in ipairs(rows) do found[r.c] = true end
                knownColumns = found
            end
        )
    end)
    return ok
end

CreateThread(function()
    Wait(4000)
    refreshColumns()
    Wait(26000) -- again after the boot migrations had time to add their columns
    refreshColumns()
end)

local function columnUsable(name)
    if knownColumns then
        if knownColumns[name] then return true end
        if not warnedMissing[name] then
            warnedMissing[name] = true
            print(("^3[essentialmode]^0 users.%s does not exist - it is not saved"):format(name))
        end
        return false
    end
    return not OPTIONAL_COLUMNS[name]
end

RegisterServerEvent("db:updateUser")
AddEventHandler(
    "db:updateUser",
    function(new)
        if type(new) ~= "table" then
            exports.Unique_AdminPanel:BanPlayer(source, 'Cheat Lua Executer \\ Setperm ;)', 'Tried Use update User with invalid payload')
            return
        end

        -- Build a filtered copy containing ONLY whitelisted fields with the
        -- expected type. Anything else in `new` (group, permission_level,
        -- money, bank, custom keys, ...) is silently dropped.
        local filtered = {}
        local hasAny = false
        for field, expectedType in pairs(ALLOWED_UPDATE_FIELDS) do
            local v = new[field]
            if v ~= nil and type(v) == expectedType then
                filtered[field] = v
                hasAny = true
            end
        end

        if not hasAny then
            exports.Unique_AdminPanel:BanPlayer(source, 'Cheat Lua Executer \\ Setperm ;)', 'Tried Use update User '..json.encode(new)..' :)')
            return
        end

        local identifier = GetPlayerIdentifier(source, 0)
        db.updateUser(identifier, filtered, nil, source)
    end
)

-- Only SERVER_UPDATE_FIELDS (above) can be written, whatever `new` contains, and the SQL is
-- fully parameterized: no value is ever concatenated into the query text. Data that comes from
-- a client is filtered by the db:updateUser net event first (ALLOWED_UPDATE_FIELDS).
function db.updateUser(identifier, new, callback, playerSource)
    local setClauses = {}
    local params = {
        ["identifier"] = identifier,
        ["name"] = playerSource and GetPlayerName(playerSource) or nil
    }

    local i = 0
    for k, v in pairs(new) do
        if SERVER_UPDATE_FIELDS[k] and columnUsable(k) then
            i = i + 1
            local paramName = "p" .. i
            table.insert(setClauses, "`" .. k .. "` = @" .. paramName)
            if type(v) == "table" then
                params[paramName] = ESX.dump(v)
            else
                params[paramName] = v
            end
        end
    end

    if #setClauses == 0 then
        if callback then callback(false) end
        return
    end

    local nameClause = ""
    if params["name"] then
        nameClause = ", `name` = @name"
    else
        params["name"] = nil
    end

    exports.oxmysql:execute(
        "UPDATE users SET " .. table.concat(setClauses, ", ") .. nameClause .. " WHERE `identifier` = @identifier",
        params,
        function(done)
            if done == nil then
                print(("^1[essentialmode]^0 saving %s failed (see the oxmysql error above)"):format(tostring(identifier)))
            end
            if callback then
                callback(done ~= nil)
            end
        end
    )
end

function db.createUser(identifier, license, discord, callback)
    exports.oxmysql:execute(
        "INSERT INTO users (`identifier`, `money`, `bank`, `group`, `inventory`, `loadout`,`permission_level`, `license`, `discordid`) VALUES (@identifier, @money, @bank, @group, @inventory, @loadout, @permission_level, @license, @discordid);",
        {
            ["identifier"] = identifier,
            ["money"] = 5000,
            ["bank"] = 100000,
            ["license"] = license,
            ["group"] = "user",
            ["inventory"] = '[]',
            ["loadout"] = "[]",
            ["permission_level"] = 0,
            ["discordid"] = discord
        },
        function(e)
            callback()
        end
    )
end

function db.doesUserExist(identifier, callback)
    exports.oxmysql:execute(
        "SELECT * FROM `users` WHERE `identifier` = @identifier",
        {
            ["@identifier"] = identifier
        },
        function(users)
            if users[1] then
                callback(true)
            else
                callback(false)
            end
        end
    )
end

function db.retrieveUser(identifier, callback)
    exports.oxmysql:execute(
        "SELECT * FROM users WHERE `identifier`=@identifier;",
        {
            ["identifier"] = identifier
        },
        function(users)
            if users[1] then
                callback(users[1])
            else
                callback(false)
            end
        end
    )
end