ESX = nil
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

-- SECURITY FIX: `amount` was accepted verbatim from the client with no
-- check that it actually matches the real price of the model they rented --
-- the server now recomputes the price itself from Config.Vehicles by
-- model, so the client-sent amount can no longer be lowered (or the pay
-- event fired standalone with an arbitrary amount).
local function getConfigRentPrice(model)
    if type(model) ~= "string" then return nil end
    for _, veh in pairs(Config.Vehicles) do
        if veh.model == model then
            return veh.price
        end
    end
    return nil
end

RegisterServerEvent("unique_rent:pay")
AddEventHandler("unique_rent:pay", function(amount, model)
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)
    if not xPlayer then return end

    local realPrice = getConfigRentPrice(model)
    if not realPrice then
        return
    end

    if xPlayer.canAfford(realPrice) then
        xPlayer.payAny(realPrice)
        TriggerClientEvent("esx:showNotification", source, "You paid ~g~" .. realPrice .. "~w~$ to rent the vehicle.")
    else
        TriggerClientEvent("esx:showNotification", source, "You don't have enough money.")
    end
end)

ESX.RegisterServerCallback("unique_rent:check", function(source, cb, amount, model)
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)
    local realPrice = getConfigRentPrice(model) or amount
    if xPlayer.canAfford(realPrice) then
        cb(true)
    else
        cb(false)
        TriggerClientEvent("esx:showNotification", source, "You don't have enough money.")
    end
end)

RegisterServerEvent('unique_rent:deleteveh')
AddEventHandler('unique_rent:deleteveh', function(plate)
    local allVehicles = GetGamePool('CVehicle')

    for _, vehicle in ipairs(allVehicles) do
        local vehiclePlate = GetVehicleNumberPlateText(vehicle)
        if vehiclePlate == plate then
            DeleteEntity(vehicle)
            return vehicle
        end
    end
    return nil
end)


RegisterCommand('rentreset', function(source, args)

end)