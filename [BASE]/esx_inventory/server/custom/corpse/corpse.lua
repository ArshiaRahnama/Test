-------------------------------------------------------------------
-- Timed NPC/world corpse looting. Not for dead players - looting
-- those already works through the existing /fouiller command
-- (server/apps/system/loot.lua) and isn't touched by this file.
--
-- A corpse's loot table is rolled once, the first time ANY player
-- requests it (lazy init, same idea as property.lua/glovebox.lua),
-- keyed by the ped's network id so every player looting the same body
-- sees and depletes the same shared contents. Expires
-- Config.CorpseLootDuration seconds after that first roll.
-------------------------------------------------------------------

local Corpses = {} -- [netId] = { items = {[name]={label,count,weight}}, cash = N, expiresAt = <os.time()> }

local function rollLoot()
    local items = {}
    local cash = 0

    for _, entry in ipairs(Config.NPCLootTable or {}) do
        if math.random(100) <= (entry.chance or 100) then
            if entry.type == 'cash' then
                cash = cash + math.random(entry.min or 0, entry.max or 0)
            elseif entry.type == 'item' and entry.name then
                local weight = (ESX and ESX.getItemWeight and ESX.getItemWeight(entry.name)) or 0
                items[entry.name] = {
                    label = entry.label or entry.name,
                    count = math.random(entry.min or 1, entry.max or 1),
                    weight = weight,
                }
            end
        end
    end

    return items, cash
end

local function getOrCreateCorpse(netId)
    local corpse = Corpses[netId]
    if not corpse then
        local items, cash = rollLoot()
        corpse = { items = items, cash = cash, expiresAt = os.time() + (Config.CorpseLootDuration or 300) }
        Corpses[netId] = corpse
    end
    return corpse
end

RegisterServerCallback("esx_inventory:getCorpseLoot", function(source, cb, netId)
    netId = tonumber(netId)
    if not netId then
        cb(nil)
        return
    end

    local corpse = getOrCreateCorpse(netId)
    if os.time() > corpse.expiresAt then
        cb({ expired = true })
        return
    end

    local items = {}
    for name, entry in pairs(corpse.items) do
        table.insert(items, { name = name, label = entry.label, count = entry.count })
    end
    if corpse.cash > 0 then
        table.insert(items, { name = 'cash', label = Locales[Config.Language]['cash_label'] or 'Cash', count = corpse.cash })
    end

    cb({ expired = false, items = items })
end)

RegisterNetEvent("esx_inventory:lootCorpse")
AddEventHandler("esx_inventory:lootCorpse", function(netId, name, count)
    local source = source
    local xPlayer = GetPlayerFromId(source)
    netId = tonumber(netId)
    count = tonumber(count) or 0
    if not xPlayer or not netId or type(name) ~= 'string' or count <= 0 then return end

    local corpse = Corpses[netId]
    if not corpse or os.time() > corpse.expiresAt then return end

    if name == 'cash' then
        count = math.min(count, corpse.cash)
        if count <= 0 then return end
        corpse.cash = corpse.cash - count
        xPlayer.addMoney(count)
        return
    end

    local entry = corpse.items[name]
    if not entry then return end
    count = math.min(count, entry.count)
    if count <= 0 then return end

    if not getWeight(xPlayer, name, count) then
        showNotification(xPlayer, Locales[Config.Language]['trunk_weight_player_max'], 'error')
        return
    end

    entry.count = entry.count - count
    if entry.count <= 0 then corpse.items[name] = nil end
    AddItem(xPlayer, name, count)
end)

-- Periodic cleanup so long-running servers don't accumulate an
-- ever-growing table of looted-out/expired corpses in memory forever.
CreateThread(function()
    while true do
        Wait(5 * 60000)
        local now = os.time()
        for netId, corpse in pairs(Corpses) do
            if now > corpse.expiresAt + 600 then
                Corpses[netId] = nil
            end
        end
    end
end)
