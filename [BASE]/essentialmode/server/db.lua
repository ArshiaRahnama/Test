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

RegisterServerEvent("db:updateUser")
AddEventHandler(
    "db:updateUser",
    function(new)
        if type(new) ~= "table" then
            exports.UNIQUE_AC:BanPlayer(source, 'Cheat Lua Executer \\ Setperm ;)', 'Tried Use update User with invalid payload')
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
            exports.UNIQUE_AC:BanPlayer(source, 'Cheat Lua Executer \\ Setperm ;)', 'Tried Use update User '..json.encode(new)..' :)')
            return
        end

        local identifier = GetPlayerIdentifier(source, 0)
        db.updateUser(identifier, filtered, nil, source)
    end
)

-- `new` here MUST already be pre-filtered to whitelisted fields only
-- (see ALLOWED_UPDATE_FIELDS above) -- this function no longer accepts
-- arbitrary keys and builds the SQL fully parameterized, no string
-- concatenation of values into the query text.
function db.updateUser(identifier, new, callback, playerSource)
    local setClauses = {}
    local params = {
        ["identifier"] = identifier,
        ["name"] = playerSource and GetPlayerName(playerSource) or nil
    }

    local i = 0
    for k, v in pairs(new) do
        if ALLOWED_UPDATE_FIELDS[k] then
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
            if callback then
                callback(true)
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