function openRecycle(entity)
    if ESX.GetPlayerData().World ~= 0 then return end
    local coords = GetEntityCoords(entity)
    local recycleId = nil
    local lastCoords = nil
    for k, v in pairs(recycleCoords) do
        if not lastCoords or #(coords - v) < lastCoords then
            recycleId = k
            lastCoords = #(coords - v)
        end
    end
    if recycleId then
        openPublicInventory('recycle:'.. recycleId, 'delete', recycleId)
    end
end

exports('openRecycle', openRecycle)