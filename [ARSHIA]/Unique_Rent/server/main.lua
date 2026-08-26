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
    if not xPlayer then cb(false) return end

    -- SECURITY FIX: this used to fall back to the client-supplied `amount`
    -- whenever the model wasn't found in Config.Vehicles -- same class of
    -- bug as unique_rent:pay used to have. Now it just refuses to affirm
    -- affordability for a model it doesn't recognize.
    local realPrice = getConfigRentPrice(model)
    if not realPrice then
        cb(false)
        return
    end

    if xPlayer.canAfford(realPrice) then
        cb(true)
    else
        cb(false)
        TriggerClientEvent("esx:showNotification", source, "You don't have enough money.")
    end
end)

-- SECURITY FIX: any player could call this with an arbitrary `plate` and
-- delete ANY vehicle on the server (even ones belonging to other players)
-- -- there was no check that the caller actually owns/is using that
-- vehicle. Now it only deletes a vehicle the calling player is currently
-- sitting in as the driver.
RegisterServerEvent('unique_rent:deleteveh')
AddEventHandler('unique_rent:deleteveh', function(plate)
    local _source = source
    local playerPed = GetPlayerPed(_source)
    if not playerPed or playerPed == 0 then return end

    local vehicle = GetVehiclePedIsIn(playerPed, false)
    if not vehicle or vehicle == 0 then return end

    if GetVehicleNumberPlateText(vehicle) ~= plate then return end
    if GetPedInVehicleSeat(vehicle, -1) ~= playerPed then return end

    DeleteEntity(vehicle)
end)


RegisterCommand('rentreset', function(source, args)

end)