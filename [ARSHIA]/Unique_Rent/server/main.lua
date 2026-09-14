ESX = nil
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

-- SECURITY: price is never trusted from the client. It's always
-- recomputed here from Config.Vehicles (base price for the model) ×
-- Config.Durations (multiplier for the chosen duration tier's id), so
-- the client can't lower it by sending an arbitrary amount, model, or
-- duration id.
local function getConfigRentQuote(model, durationId)
    if type(model) ~= "string" then return nil end

    local vehicleCfg = nil
    for _, veh in pairs(Config.Vehicles) do
        if veh.model == model then
            vehicleCfg = veh
            break
        end
    end
    if not vehicleCfg then return nil end

    local durationCfg = Config.Durations[tonumber(durationId)]
    if not durationCfg then return nil end

    local price = math.floor((vehicleCfg.price * durationCfg.multiplier) + 0.5)
    return { price = price, seconds = durationCfg.seconds, label = durationCfg.label }
end

RegisterServerEvent("unique_rent:pay")
AddEventHandler("unique_rent:pay", function(model, durationId)
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)
    if not xPlayer then return end

    local quote = getConfigRentQuote(model, durationId)
    if not quote then
        return
    end

    if xPlayer.canAfford(quote.price) then
        xPlayer.payAny(quote.price)
        TriggerClientEvent("unique_rent:notify", source, { title = 'Unique Rent', description = ('You paid $%s to rent the vehicle.'):format(quote.price), type = 'success' })
    else
        TriggerClientEvent("unique_rent:notify", source, { title = 'Unique Rent', description = "You don't have enough money.", type = 'error' })
    end
end)

ESX.RegisterServerCallback("unique_rent:check", function(source, cb, model, durationId)
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)
    if not xPlayer then cb(false) return end

    -- SECURITY FIX: this used to fall back to the client-supplied `amount`
    -- whenever the model wasn't found in Config.Vehicles -- same class of
    -- bug as unique_rent:pay used to have. Now it just refuses to affirm
    -- affordability for a model/duration it doesn't recognize.
    local quote = getConfigRentQuote(model, durationId)
    if not quote then
        cb(false)
        return
    end

    if xPlayer.canAfford(quote.price) then
        cb(true)
    else
        cb(false)
        TriggerClientEvent("unique_rent:notify", source, { title = 'Unique Rent', description = "You don't have enough money.", type = 'error' })
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


-- Force-clears a player's rental lock. The "currently renting" flag
-- (Options.have_rented) lives entirely client-side; if their rented
-- vehicle is lost some other way (falls in water, gets blown up,
-- despawns, deleted by an admin, etc.) return_vehicle() can never run
-- because it requires the player to be sitting in that exact vehicle,
-- so they'd otherwise be locked out of renting again until they
-- reconnect. This tells their client to reset that state directly.
RegisterCommand('rentreset', function(source, args)
    local xPlayer = ESX.GetPlayerFromId(source)
    if source ~= 0 and (not xPlayer or xPlayer.permission_level < 2) then
        TriggerClientEvent('chat:addMessage', source, {args = {'^1SYSTEM', 'Insufficient permissions.'}})
        return
    end

    local targetId = tonumber(args[1])
    if not targetId then
        TriggerClientEvent('chat:addMessage', source, {args = {'^1SYSTEM', 'Usage: /rentreset [id]'}})
        return
    end

    local xTarget = ESX.GetPlayerFromId(targetId)
    if not xTarget then
        TriggerClientEvent('chat:addMessage', source, {args = {'^1SYSTEM', 'Player not online / invalid ID.'}})
        return
    end

    TriggerClientEvent('unique_rent:forceReset', targetId)
    if source ~= 0 then
        TriggerClientEvent('chat:addMessage', source, {args = {'^2SYSTEM', 'Rental state reset for ' .. GetPlayerName(targetId) .. '.'}})
    end
end, false)