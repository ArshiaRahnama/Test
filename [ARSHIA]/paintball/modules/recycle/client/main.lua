-- This Script Dump By FleeX Team  , discord.gg/2D79ZtUjxB

deleteCoords = {
    vec(608.67, 2856.78, 40.43, 70),
    vec(2736.94, 1417.99, 24.47, 70),
    vec(718.27, -974.04, 24.91, 40),
    vec(1978.92, 5171.7, 47.64, 70),
    vec(1205.92, -1283.29, 35.23, 70),
    vec(-544.83, 5317.68, 72.88, 100),
    vec(-69.16, 6250.84, 31.09, 70),
}

function openRecycle(entity)
    if ESX.GetPlayerData().World ~= 0 and not exports['gangs']:isInGangWorld() then return end
    local coords = GetEntityCoords(entity)
    local recycleId = nil
    local lastCoords = nil
    for k, v in pairs(recycleCoords) do
        if not lastCoords or ESX.GetDistance(coords, v) < lastCoords then
            recycleId = k
            lastCoords = ESX.GetDistance(coords, v)
        end
    end
    if recycleId then
        openInventory('recycle:'.. recycleId, 'delete', recycleId)
    end
end

function getNearRecycle()
    local coords = GetEntityCoords(PlayerPedId())
    local recycleId = nil
    local lastCoords = nil
    for k, v in pairs(recycleCoords) do
        if not lastCoords or ESX.GetDistance(coords, v) < lastCoords then
            recycleId = k
            lastCoords = ESX.GetDistance(coords, v)
        end
    end
    if recycleId then
        return recycleId
    end
end

function getRandomRecycle()
    return math.random(1, #recycleCoords)
end

exports('openRecycle', openRecycle)