--[[
    Client-side half of the es_extended bridge. essentialmode fires the same
    classic "esx:getSharedObject" event client-side as it does server-side —
    this just re-exposes it as `exports.es_extended:getSharedObject()` so
    ox_inventory's client bridge (which needs its own client-side copy of
    this export, separate from the server-side one) can find it.
]]

local ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

if ESX then
    print('^2[es_extended bridge] Client-side ready.^0')
else
    print('^1[es_extended bridge] Client-side ERROR: essentialmode did not answer esx:getSharedObject.^0')
end

exports('getSharedObject', function()
    if not ESX then
        TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
    end
    return ESX
end)
