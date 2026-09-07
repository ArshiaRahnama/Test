ESX = {}
ESX.Players = {}
ESX.UsableItemsCallbacks = {}
ESX.Items = {}
ESX.ServerCallbacks = {}
ESX.TimeoutCount = -1
ESX.CancelledTimeouts = {}
ESX.LastPlayerData = {}
ESX.Pickups = {}
ESX.PickupId = 0
ESX.Jobs = {}

ESX.Gangs = {}

-- see comment in this diff / chat for why these exist
ESX.getItemWeight = function(name)
    return 0
end

ESX.getWeaponWeight = function(name)
    return 0
end

-- Lets other resources register a brand-new item at runtime (e.g.
-- unique_clothestore creating one item per drawable/texture combo the
-- first time it's purchased) in a way that actually reaches essentialmode's
-- real internal state. A copy of ESX obtained via esx:getSharedObject in
-- another resource is a one-time snapshot (events serialize their
-- arguments across the resource boundary, they don't share live table
-- references) - mutating that copy's ESX.Items never affects the real one
-- essentialmode itself uses, which is why that approach silently did
-- nothing. This export runs inside essentialmode's own VM instead.
function RegisterItem(name, label)
    if type(name) ~= 'string' or name == '' then return false end
    if not ESX.Items[name] then
        ESX.Items[name] = { name = name, label = label or name, limit = -1, rare = false, canRemove = true }
        MySQL.Async.execute('INSERT IGNORE INTO items (name, label, `limit`, rare, can_remove) VALUES (?, ?, -1, 0, 1)', { name, label or name })
    end
    return true
end

-- Same reasoning as RegisterItem above, but for wiring up a usable-item
-- handler (e.g. wearing/unwearing a clothing item) from another resource.
-- FiveM's exports system does correctly marshal a function reference
-- across the resource boundary (unlike a plain data table), so the
-- callback itself works fine - it just needs to land in essentialmode's
-- REAL ESX.UsableItemsCallbacks, which only ESX.RegisterUsableItem (called
-- from in here) can do.
function RegisterUsableItem(name, callback)
    if type(name) ~= 'string' or type(callback) ~= 'function' then return false end
    ESX.RegisterUsableItem(name, callback)
    return true
end

-- Categorized weapon serials: LAW- (default/regular sources), DOJ- (police
-- armory), GANG- (gang armory) - see server/classes/player.lua's addWeapon
-- (uses this as the default when no serial is given) and the DOJ-/GANG-
-- call sites in esx_uniquejobs/server/police_main.lua and
-- Unique_ALLGangs/server/apps/system/stash.lua (lc-inventory).
local weaponSerialCounter = 0
ESX.GenerateWeaponSerial = function(prefix)
    prefix = prefix or 'LAW'
    weaponSerialCounter = weaponSerialCounter + 1
    return ('%s-%05d-%04d'):format(prefix, os.time() % 100000, weaponSerialCounter % 10000)
end

AddEventHandler(
    "esx:getSharedObject",
    function(cb)
        cb(ESX)
    end
)

function getSharedObject()
    return ESX
end

MySQL.ready(
    function()
        exports.oxmysql:execute(
            "SELECT * FROM items",
            {},
            function(result)
                for i = 1, #result, 1 do
                    ESX.Items[result[i].name] = {
                        label = result[i].label,
                        limit = result[i].limit,
                        rare = (result[i].rare == 1 and true or false),
                        canRemove = (result[i].can_remove == 1 and true or false)
                    }
                end
            end
        )

        local result = MySQL.Sync.fetchAll("SELECT * FROM jobs", {})

        for i = 1, #result do
            ESX.Jobs[result[i].name] = result[i]
            ESX.Jobs[result[i].name].grades = {}

        end

        local result2 = MySQL.Sync.fetchAll("SELECT * FROM job_grades", {})

        for i = 1, #result2 do
            if ESX.Jobs[result2[i].job_name] then
                ESX.Jobs[result2[i].job_name].grades[tonumber(result2[i].grade)] = result2[i]
            else
                print(('essentialmode: invalid job "%s" from table job_grades ignored!'):format(result2[i].job_name))
            end
        end

        for k, v in pairs(ESX.Jobs) do
            if next(v.grades) == nil then
                ESX.Jobs[v.name] = nil
                print(('essentialmode: ignoring job "%s" due to missing job grades!'):format(v.name))
            end
        end

        local gang = MySQL.Sync.fetchAll("SELECT * FROM gangs", {})

        for i = 1, #gang do
            ESX.Gangs[gang[i].name] = gang[i]
            ESX.Gangs[gang[i].name].grades = {}
        end

        local gang2 = MySQL.Sync.fetchAll("SELECT * FROM gang_grades", {})

        for i = 1, #gang2 do
            if ESX.Gangs[gang2[i].gang_name] then
                ESX.Gangs[gang2[i].gang_name].grades[tonumber(gang2[i].grade)] = gang2[i]
            else
                print(('essentialmode: invalid gang "%s" from table gang_grades ignored!'):format(gang2[i].gang_name))
            end
        end

        for k, v in pairs(ESX.Gangs) do
            if next(v.grades) == nil then
                ESX.Gangs[v.name] = nil
                print(('essentialmode: ignoring gang "%s" due to missing gang grades!'):format(v.name))
            end
        end



























    end
)

AddEventHandler(
    "playerLoaded",
    function(source, player)
        local items = {}
        local playerItems = player.inventory

        for i = 1, #playerItems, 1 do
            items[playerItems[i].name] = playerItems[i].count
        end
    end
)

RegisterServerEvent("esx:triggerServerCallback")
AddEventHandler(
    "esx:triggerServerCallback",
    function(name, requestId, ...)
        local _source = source
        ESX.TriggerServerCallback(
            name,
            requestID,
            _source,
            function(...)
                TriggerClientEvent("esx:serverCallback", _source, requestId, ...)
            end,
            ...
        )
    end
)

RegisterServerEvent("essentialmode:addGang")
AddEventHandler("essentialmode:addGang", function(name, ranks)
    local ranks = {'Rank1','Rank2','Rank3','Rank4','Rank5','Rank6','Rank7','Rank8','Rank9','Rank10','Rank11','Rank12','Rank13'}
        ESX.Gangs[name] = {name = name, label = "gang"}
        ESX.Gangs[name].grades = {}
        for i = 1, #ranks, 1 do
            ESX.Gangs[name].grades[tonumber(i)] = {
                gang_name = name,
                grade = i,
                name = "Rank" .. i,
                label = "Rank" .. i,
                salary = 1000 * i,
                skin_male = "{}",
                skin_female = "{}"
            }
        end
    end
)

RegisterServerEvent('esx:CreateItem')
AddEventHandler('esx:CreateItem', function(name, label, limit, rare, can_remove)

    if ESX.Items[name] == nil then

      ESX.Items[name] = {
        label     = label,
        limit     = limit,
        rare      = rare,
        canRemove = can_remove,
      }

    end
end)
