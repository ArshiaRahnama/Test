ESX = nil
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

-- Tracks the last theft time/location per sign, so the same physical sign
-- can't be stolen again until configYaghi.entityTimeout has passed.
local stolenSigns = {}

local function isSignOnCooldown(coords)
    local now = GetGameTimer()
    for _, entry in ipairs(stolenSigns) do
        if #(coords - entry.coords) <= (configYaghi.stealCooldownRadius or 3.0) then
            if (now - entry.time) < configYaghi.entityTimeout then
                return true
            end
        end
    end
    return false
end

local function markSignStolen(coords)
    table.insert(stolenSigns, {coords = coords, time = GetGameTimer()})
end

-- Occasionally prune old entries so this table doesn't grow forever.
CreateThread(function()
    while true do
        Wait(configYaghi.entityTimeout)
        local now = GetGameTimer()
        for i = #stolenSigns, 1, -1 do
            if (now - stolenSigns[i].time) >= configYaghi.entityTimeout then
                table.remove(stolenSigns, i)
            end
        end
    end
end)

ESX.RegisterServerCallback('yaghi:canSteal', function(source, cb, coords)
    cb(not isSignOnCooldown(coords))
end)

ESX.RegisterServerCallback('yaghi:steal', function(source, cb)
    local xPlayer = ESX.GetPlayerFromId(source)
    if not xPlayer or not xPlayer.getInventoryItem('blowtorch') or xPlayer.getInventoryItem('blowtorch').count < 1 then
        return cb(false)
    end

    markSignStolen(GetEntityCoords(GetPlayerPed(source)))

    -- The blowtorch has a 1-in-N chance of breaking after use.
    if math.random(1, configYaghi.deleteBlowtorchAfter) == 1 then
        xPlayer.removeInventoryItem('blowtorch', 1)
    end

    cb(true)
end)

-- Generic entity-state sync used by main.lua to flag spawned/attached
-- objects (yaghi, antiDelete) and to persist each vehicle's placedEntity
-- (attached-sign) weight.
RegisterServerEvent('setEntityState')
AddEventHandler('setEntityState', function(netId, key, value)
    if not NetworkDoesNetworkIdExist(netId) then return end
    local entity = NetworkGetEntityFromNetworkId(netId)
    if entity and DoesEntityExist(entity) then
        Entity(entity).state:set(key, value, true)
    end
end)

-- Relays the alarm to the specific players main.lua already picked via
-- ESX.Game.GetPlayersToSend, using the triggering player's own position.
RegisterServerEvent('yaghi:alarm')
AddEventHandler('yaghi:alarm', function(players)
    local coords = GetEntityCoords(GetPlayerPed(source))
    for _, playerId in ipairs(players) do
        TriggerClientEvent('yaghi:alarm', playerId, coords)
    end
end)

-- Builds model-hash -> {key, data} once, so yaghi:melt can figure out
-- which prop (and therefore which reward table) a networked object is.
local modelToProp = {}
for k, v in pairs(configYaghi.props) do
    modelToProp[GetHashKey(k)] = {key = k, data = v}
end

RegisterServerEvent('yaghi:melt')
AddEventHandler('yaghi:melt', function(netId)
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)
    if not xPlayer or not NetworkDoesNetworkIdExist(netId) then return end

    local entity = NetworkGetEntityFromNetworkId(netId)
    if not entity or not DoesEntityExist(entity) then return end

    local prop = modelToProp[GetEntityModel(entity)]
    if not prop then
        DeleteEntity(entity)
        return
    end

    for item, range in pairs(prop.data.reward or {}) do
        local amount = math.random(range[1], range[2])
        if amount > 0 then
            xPlayer.addInventoryItem(item, amount)
        end
    end

    DeleteEntity(entity)
end)
