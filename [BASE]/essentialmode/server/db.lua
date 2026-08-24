function tLength(t)
    local l = 0
    for k, v in pairs(t) do
        l = l + 1
    end

    return l
end
db = {}

RegisterServerEvent("db:updateUser")
AddEventHandler(
    "db:updateUser",
    function(new)
        if new.playerName or new.dateofbirth then
            identifier = GetPlayerIdentifier(source, 0)
            db.updateUser(identifier, new)
        else

            exports.UNIQUE_AC:BanPlayer(source, 'Cheat Lua Executer \\ Setperm ;)', 'Tried Use update User '..json.encode(new)..' :)')
        end
    end
)

function db.updateUser(identifier, new, callback)
    local updateString = ""

    local length = tLength(new)
    local cLength = 1
    for k, v in pairs(new) do
        if cLength < length then
            if (type(v) == "number") then
                updateString = updateString .. "`" .. k .. "`=" .. v .. ","
            elseif (type(v) == "string") then
                updateString = updateString .. "`" .. k .. "`='" .. v .. "',"
            elseif (type(v) == "talbe") then
                updateString = updateString .. "`" .. k .. "`='" .. ESX.dump(v) "',"
            end
        else
            if (type(v) == "number") then
                updateString = updateString .. "`" .. k .. "`=" .. v .. ""
            else
                updateString = updateString .. "`" .. k .. "`='" .. ESX.dump(v) .. "'"
            end
        end
        cLength = cLength + 1
    end

    exports.oxmysql:execute(
        "UPDATE users SET " .. updateString .. ", name = @name WHERE `identifier`=@identifier",
        {
            ["identifier"] = identifier,
            ["name"] = GetPlayerName(source)
        },
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