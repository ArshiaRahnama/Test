function LoadUser(identifier, source, licenseNotRequired)
    local Source = source
    db.retrieveUser(
        identifier,
        function(user, isJson)
            if user then
                if isJson then
                    user = json.decode(user)
                end
                user.protectedInventory = {}
                if user.inventory then
                    user.inventory = json.decode(user.inventory)
                else
                    user.inventory = {}
                end


                for i = 1, #user.inventory do
                    local item = ESX.Items[user.inventory[i].item]
                    if item then
                        table.insert(
                            user.protectedInventory,
                            {
                                name = user.inventory[i].item,
                                count = user.inventory[i].count,
                                label = item.label,
                                limit = item.limit,
                                usable = ESX.UsableItemsCallbacks[user.inventory[i].item] ~= nil,
                                rare = item.rare,
                                canRemove = item.canRemove,
                                -- FIX: items loaded from a saved inventory never got a
                                -- weight field either (same root cause as the stubs in
                                -- player.lua) - without this, every item a player
                                -- already owned before this fix crashed the trunk
                                -- deposit flow the same way freshly-picked-up ones did.
                                weight = item.weight or ESX.getItemWeight(user.inventory[i].item)
                            }
                        )
                    else
                        print(('essentialmode: invalid item "%s" ignored!'):format(user.inventory[i].item))

                    end
                end
































                if user.license or licenseNotRequired then
                    Users[source] =
                        CreatePlayer(
                        Source,
                        user.permission_level,
                        user.money,
                        user.bank,
                        user.identifier,
                        user.license,
                        user.group,
                        user.roles or "",
                        user.protectedInventory,
                        user.job,
                        user.job_grade,
                        user.gang,
                        user.gang_grade,
                        user.loadout,
                        user.playerName,
                        user.position,
                        user.status,

                        user.starterpack,
                        user.discordid,
                        user.level,
                        user.R,
                        user.black_money,
                        -- #1/#2/#15: grid placement map. Column may not
                        -- exist yet (migration runs async on boot) and may
                        -- hold NULL for every player who predates this
                        -- feature - both cases resolve to nil, which makes
                        -- InitInventorySlots auto-place the whole inventory
                        -- exactly as if it were a fresh grid.
                        (function()
                            if not user.invslots or user.invslots == '' then return nil end
                            local ok, decoded = pcall(json.decode, user.invslots)
                            return (ok and type(decoded) == 'table') and decoded or nil
                        end)()
                    )
                    Identifiers[user.identifier] = source

                    -- #15: size the dedicated backpack band from the same
                    -- `equipped_backpack` column RecalculateMaxWeight reads
                    -- just below, so capacity and slot count can never
                    -- disagree about which pack is on.
                    if Users[Source].setBackpackSlots then
                        Users[Source].setBackpackSlots(user.equipped_backpack)
                    end

                    -- Level + backpack based inventory capacity: base
                    -- Config.DefaultMaxWeight + Config.WeightPerLevel kg per
                    -- level above 1 (Unique_LevelQuest's `rank` column) +
                    -- Config.BackpackWeight[equipped_backpack] if any. Both
                    -- columns are read straight off this same `users` row so
                    -- the correct cap is in place the moment the player
                    -- object exists - no race with either resource's own
                    -- startup order. Changing either afterwards (leveling up,
                    -- equipping/removing a backpack) is handled live by
                    -- RecalculateMaxWeight (server/main.lua).
                    RecalculateMaxWeight(Users[Source], user.rank, user.equipped_backpack)

                    TriggerClientEvent(
                        "esx:playerLoaded",
                        Source,
                        {
                            identifier = Users[Source].identifier,
                            inventory = Users[Source].inventory,
                            job = Users[Source].job,

                            StarterPack = Users[Source].StarterPack,
                            DiscordId = Users[Source].DiscordId,
                            gang = Users[Source].gang,
                            loadout = Users[Source].loadout,
                            lastPosition = Users[Source].coords,
                            money = Users[Source].money,
                            status = Users[Source].status,
                            name = Users[Source].name,
                            dead = user.is_dead,
                            level = Users[Source].level,
                            respect = Users[Source].respect,
                            respectcount = Users[Source].RespectCount,
                            perm = user.permission_level,
                        }
                    )

                    TriggerEvent("esx:playerLoaded", Source, Users[Source])

                    local new = "."
                    if not user.playerName or not user.dateofbirth then
                        TriggerClientEvent("registerForm", Source, true)
                        new = ", and he/she is new player!"
                    else
                        TriggerClientEvent("registerForm", Source, false)
                    end

                    local discord
                    for k, v in ipairs(GetPlayerIdentifiers(Source)) do
                        if string.sub(v, 1, string.len("discord:")) == "discord:" then
                            discord = string.gsub(v, "discord:", "")
                            discord = "<@" .. discord .. ">"
                        else
                            discord = "N/A"
                        end
                    end

                    TriggerEvent(
                        "DiscordBot:ToDiscord",
                        "co",
                        "[LogSystem]",
                        "```css\n User: (" ..
                            Source ..
                                "), Identifier: (" ..
                                    Users[Source].identifier ..
                                        "), Name: (" ..
                                            Users[Source].name ..
                                                "), SteamName: (" ..
                                                    GetPlayerName(Source) ..
                                                        "), money: (" ..
                                                            Users[Source].money ..
                                                                "), Bank: (" ..
                                                                    Users[Source].bank ..
                                                                        "), Inventory: (" ..
                                                                            ESX.dump(Users[Source].inventory) ..
                                                                                "), Loadout: (" ..
                                                                                    ESX.dump(Users[Source].loadout) ..
                                                                                        ") Permission: (" ..
                                                                                            Users[Source].permission_level ..
                                                                                                ")" ..
                                                                                                    new ..
                                                                                                        "```\n <@!" ..
                                                                                                            discord ..
                                                                                                                ">",
                        "user",
                        Source,
                        true,
                        false
                    )

                    for k, v in pairs(commandSuggestions) do
                        TriggerClientEvent(
                            "chat:addSuggestion",
                            Source,
                            settings.defaultSettings.commandDelimeter .. k,
                            v.help,
                            v.params
                        )
                    end
                else
                    local license

                    for k, v in ipairs(GetPlayerIdentifiers(Source)) do
                        if string.sub(v, 1, string.len("license:")) == "license:" then
                            license = v
                            break
                        end
                    end

                    local discord
                    for k, v in ipairs(GetPlayerIdentifiers(Source)) do
                        if string.sub(v, 1, string.len("discord:")) == "discord:" then
                            discord = string.gsub(v, "discord:", "")
                            discord = "<@" .. discord .. ">"
                        else
                            discord = "N/A"
                        end
                    end
                    if license then
                        db.updateUser(
                            user.identifier,
                            {license = license},
                            function()
                                LoadUser(user.identifier, Source, false)
                            end
                        )
                    else
                        LoadUser(user.identifier, Source, false, true)
                    end
                end
            else
                local license
                for k, v in ipairs(GetPlayerIdentifiers(Source)) do
                    if string.sub(v, 1, string.len("license:")) == "license:" then
                        license = v
                        break
                    end
                end
                local discord
                for k, v in ipairs(GetPlayerIdentifiers(Source)) do
                    if string.sub(v, 1, string.len("discord:")) == "discord:" then
                        discord = string.gsub(v, "discord:", "")
                        discord = "<@" .. discord .. ">"
                    else
                        discord = "N/A"
                    end
                end
                db.createUser(
                    identifier,
                    license,
                    discord,
                    function()
                        LoadUser(identifier, Source, true)
                    end
                )
            end
        end
    )
end

ESX.getPlayerFromId = function(id)
    return Users[tonumber(id)]
end

AddEventHandler(
    "es:getPlayers",
    function(cb)
        cb(Users)
    end
)

AddEventHandler(
    "es:setPlayerDataId",
    function(user, k, v, cb)
        db.updateUser(
            user,
            {[k] = v},
            function(d)
                cb(true)
            end
        )
    end
)

RegisterNetEvent("es:newName")
AddEventHandler("es:newName", function(newName)
	Users[source].set("name", newName)
end)

AddEventHandler(
    "es:getPlayerFromId",
    function(user, cb)
        if (Users) then
            if (Users[user]) then
                cb(Users[user])
            else
                cb(nil)
            end
        else
            cb(nil)
        end
    end
)

AddEventHandler(
    "es:getPlayerFromIdentifier",
    function(identifier, cb)
        db.retrieveUser(
            identifier,
            function(user)
                cb(user)
            end
        )
    end
)

-- FIX (pre-existing, found while adding the slot map): this periodic save
-- passed `inventory = v.inventory` -- the RICH runtime table
-- ({name,count,label,limit,usable,rare,canRemove,weight}) -- straight into
-- the query as a Lua table, while LoadUser reads that column back with
-- json.decode and expects the compact {item=,count=} shape that
-- playerDropped writes. So every periodic autosave wrote either a failed
-- parameter or a structure the loader couldn't read, and the only save
-- that actually round-tripped was the one on disconnect. Now encodes the
-- same shape playerDropped does. Also persists `invslots` (#1/#2/#15).
ESX.savePlayerMoney = function()
    for k, v in pairs(Users) do
        if Users[k] ~= nil then
            local invent = {}
            for _, entry in ipairs(v.inventory or {}) do
                table.insert(invent, {item = entry.name, count = entry.count})
            end

            db.updateUser(
                v.get("identifier"),
                {
                    money = v.money,
                    bank = v.bank,
                    position = v.lastPosition,
                    inventory = json.encode(invent),
                    invslots = json.encode(v.getSlots and v.getSlots() or {}),
                    loadout = json.encode(v.loadout or {})
                }
            )
        end
        Wait(300)
    end
end
