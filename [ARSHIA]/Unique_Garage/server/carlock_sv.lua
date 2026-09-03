

local JOB_PLATE_ACCESS = {

    cid       = "CID",
    cia       = "CIA",
    marshal   = "MS",
    fbi       = "FBI",
    judge     = "JD",
    doa       = "DOA",

    police    = "PD",
    sheriff   = "SH",
    mt        = "MT",

    taxi      = "TX",
    mechanic  = "MC",
    ambulance = "MD",
    weazel    = "WZ",
}

local RESTRICTED_HOTWIRE_PREFIXES = {}
for _, prefix in pairs(JOB_PLATE_ACCESS) do
    RESTRICTED_HOTWIRE_PREFIXES[prefix] = true
end

local function IsStaff(xPlayer)
    return xPlayer ~= nil and xPlayer.permission_level ~= nil and xPlayer.permission_level >= 1
end

local function HasJobPlateAccess(xPlayer, plate)
    local jobName = xPlayer.job and xPlayer.job.name
    if not jobName then return false end

    local requiredPrefix = JOB_PLATE_ACCESS[jobName]
    if not requiredPrefix then return false end

    local prefix = string.upper(string.sub(plate, 1, #requiredPrefix))
    return prefix == requiredPrefix
end

local function MatchesRestrictedPrefix(plate)
    for prefix in pairs(RESTRICTED_HOTWIRE_PREFIXES) do
        if string.upper(string.sub(plate, 1, #prefix)) == prefix then
            return true
        end
    end
    return false
end

local function CheckDbOwnership(xPlayer, plate, cb)
    local gangName = xPlayer.gang and xPlayer.gang.name or nil
    MySQL.Async.fetchScalar('SELECT owner FROM owned_vehicles WHERE plate = @plate', {
        ['@plate'] = plate
    }, function(owner)
        if owner == nil then
            cb(false, false)
            return
        end
        if owner == xPlayer.identifier then
            cb(true, true)
        elseif gangName and owner == gangName then
            cb(true, true)
        else
            cb(false, true)
        end
    end)
end

-- IRV-inventory replacement for ox_inventory's `Search(src, 'count', item,
-- {plate=plate})`: essentialmode/IRV-inventory items don't support querying
-- by metadata directly, so we scan the player's own inventory slots for a
-- 'vehicle_keys' entry whose `.info.plate` matches. Returns the slot (item,
-- index) or nil.
local function FindKeySlot(xPlayer, plate)
    if not xPlayer or not xPlayer.inventory then return nil end
    for i = 1, #xPlayer.inventory, 1 do
        local item = xPlayer.inventory[i]
        if item.name == 'vehicle_keys' and item.count > 0 and item.info and item.info.plate == plate then
            return item, i
        end
    end
    return nil
end

ESX.RegisterServerCallback('CarLock:haskey', function(source, cb, plate)
    local xPlayer = ESX.GetPlayerFromId(source)
    if not xPlayer or not plate then cb(false) return end

    plate = ESX.Math.Trim(plate)

    if HasJobPlateAccess(xPlayer, plate) then
        cb(true)
        return
    end

    if FindKeySlot(xPlayer, plate) then
        cb(true)
        return
    end



    CheckDbOwnership(xPlayer, plate, function(isOwner)
        cb(isOwner)
    end)
end)

RegisterCommand('givekey', function(source, args)
    local xPlayer = ESX.GetPlayerFromId(source)
    if not IsStaff(xPlayer) then return end

    local targetId = tonumber(args[1])
    if not targetId or not ESX.GetPlayerFromId(targetId) then
        print('Id Eshtbah Ast')
        return
    end

    if #(GetEntityCoords(GetPlayerPed(source)) - GetEntityCoords(GetPlayerPed(targetId))) <= 15 then
        TriggerClientEvent('givekey_Cl', targetId, targetId)
    else
        print('Fasle Shoma Ba Player Mored Nazar Zeyad Ast')
    end
end)

RegisterNetEvent("CarLock:CheckKeys")
AddEventHandler("CarLock:CheckKeys", function(KEYS)
    local xPlayer = ESX.GetPlayerFromId(source)
    if not xPlayer or #KEYS <= 0 then return end

    local liveKeys = {}
    for i = 1, #KEYS do
        liveKeys[KEYS[i]] = true
    end

    for i = 1, #xPlayer.inventory do
        local invItem = xPlayer.inventory[i]
        if invItem and invItem.name and string.find(invItem.name, "CarKey") and invItem.count > 0 then
            if not liveKeys[invItem.name] then
                xPlayer.removeInventoryItem(invItem.name, invItem.count)
            end
        end
    end
end)

function EnumerateVehicles()
    return coroutine.wrap(function()
        local handle, vehicle = FindFirstVehicle()
        if not vehicle then
            return
        end
        local finished = false
        repeat
            coroutine.yield(vehicle)
            finished, vehicle = FindNextVehicle(handle)
        until not finished
        EndFindVehicle(handle)
    end)
end

RegisterNetEvent("CarLock:ToggleKey")
AddEventHandler("CarLock:ToggleKey", function(op, plate)
    local src = source
    if not plate then return end

    local xPlayer = ESX.GetPlayerFromId(src)
    if not xPlayer then return end

    plate = ESX.Math.Trim(plate)
    if plate == "" or #plate > 12 then return end

    -- IRV-inventory (like ox_inventory before it) has no per-vehicle dynamic
    -- item creation (unlike essentialmode's old "CarKey|<plate>" trick, one
    -- unique item name per plate -- that's unbounded and can't be
    -- pre-registered). Every set of keys is instead the SAME item,
    -- distinguished by its own slot-level `info.plate` (see the
    -- addInventoryItem/getInventoryItem `info`/index support patched into
    -- essentialmode's player class for this).
    local KEY_ITEM = "vehicle_keys"

    local function applyGrant()
        if not FindKeySlot(xPlayer, plate) then
            xPlayer.addInventoryItem(KEY_ITEM, 1, nil, { plate = plate, label = 'Keys: ' .. plate })
        end
    end

    local function applyRevoke()
        local sources = ESX.GetPlayers()
        for i = 1, #sources, 1 do
            local otherPlayer = ESX.GetPlayerFromId(sources[i])
            if otherPlayer then
                local item, idx = FindKeySlot(otherPlayer, plate)
                if item then
                    otherPlayer.removeInventoryItem(KEY_ITEM, item.count, idx)
                end
            end
        end
    end

    if op then
        if IsStaff(xPlayer) then
            applyGrant()
            return
        end

        CheckDbOwnership(xPlayer, plate, function(isOwner, rowExists)
            if isOwner then
                applyGrant()
                return
            end

            if rowExists then

                print(("[CarLock] Blocked suspicious key grant: player %s (%s) requested CarKey for plate '%s' which is DB-owned by someone else.")
                    :format(GetPlayerName(src) or "?", xPlayer.identifier or "?", plate))
                TriggerEvent('DiscordBot:ToDiscord', 'lockpick', 'SuspiciousKeyGrantLog', '```css\n[ Player : '..(GetPlayerName(src) or "?")..'(' .. src .. ') ]\n[ Player Steam : '..(xPlayer.identifier or "?")..' ]\n[ Plate : '..tostring(plate)..' ]\n[ Reason : Requested key for a plate DB-owned by someone else ]\n```', 'user', true, src, false)
                return
            end

            local granted = false
            for attempt = 1, 15 do
                local ped = GetPlayerPed(src)
                local vehicle = ped and ped ~= 0 and GetVehiclePedIsIn(ped, false) or 0
                if vehicle ~= 0 and ESX.Math.Trim(GetVehicleNumberPlateText(vehicle)) == plate then
                    applyGrant()
                    granted = true
                    break
                end
                Wait(100)
            end
            if not granted then
                print(("[CarLock] Blocked suspicious key grant: player %s (%s) requested CarKey for plate '%s' with no ownership and not in that vehicle.")
                    :format(GetPlayerName(src) or "?", xPlayer.identifier or "?", plate))
                TriggerEvent('DiscordBot:ToDiscord', 'lockpick', 'SuspiciousKeyGrantLog', '```css\n[ Player : '..(GetPlayerName(src) or "?")..'(' .. src .. ') ]\n[ Player Steam : '..(xPlayer.identifier or "?")..' ]\n[ Plate : '..tostring(plate)..' ]\n[ Reason : No ownership and not in that vehicle ]\n```', 'user', true, src, false)
            end
        end)
    else

        if IsStaff(xPlayer) or FindKeySlot(xPlayer, plate) ~= nil then
            applyRevoke()
        else
            CheckDbOwnership(xPlayer, plate, function(isOwner)
                if isOwner then applyRevoke() end
            end)
        end
    end
end)

RegisterNetEvent("CarLock:ToggleKey2")
AddEventHandler("CarLock:ToggleKey2", function(op, plate, targetId)
    local src = source
    if not plate then return end

    local xPlayer = ESX.GetPlayerFromId(src)
    if not xPlayer then return end

    targetId = tonumber(targetId)
    local xTarget = targetId and ESX.GetPlayerFromId(targetId)
    if not xTarget then return end

    local targetPed = GetPlayerPed(targetId)
    local senderPed = GetPlayerPed(src)
    if not targetPed or targetPed == 0 or not senderPed or senderPed == 0 then return end
    if #(GetEntityCoords(senderPed) - GetEntityCoords(targetPed)) > 20.0 then
        print(("[CarLock] Blocked ToggleKey2: %s tried to give a key to a player %s far away.")
            :format(GetPlayerName(src) or "?", GetPlayerName(targetId) or "?"))
        return
    end

    plate = ESX.Math.Trim(plate)

    local function senderHasAccess(cb)
        if IsStaff(xPlayer) then cb(true) return end
        if FindKeySlot(xPlayer, plate) then cb(true) return end
        CheckDbOwnership(xPlayer, plate, function(isOwner) cb(isOwner) end)
    end

    senderHasAccess(function(allowed)
        if not allowed then
            print(("[CarLock] Blocked ToggleKey2: %s (%s) has no access to plate '%s' and tried to hand out a key for it.")
                :format(GetPlayerName(src) or "?", xPlayer.identifier or "?", plate))
            return
        end

        local targetItem, targetIdx = FindKeySlot(xTarget, plate)

        if op then
            if not targetItem then
                xTarget.addInventoryItem('vehicle_keys', 1, nil, { plate = plate, label = 'Keys: ' .. plate })
            end
        else
            if targetItem then
                xTarget.removeInventoryItem('vehicle_keys', targetItem.count, targetIdx)
            end
        end
    end)
end)

ESX.RegisterServerCallback('CarLock:hasHotwireItem', function(source, cb)
    local xPlayer = ESX.GetPlayerFromId(source)
    local hotwireItem = xPlayer.getInventoryItem(Customize.HotwireItem)
    cb(hotwireItem ~= nil and hotwireItem.count >= 1)
end)

RegisterNetEvent('CarLock:useHotwireKit')
AddEventHandler('CarLock:useHotwireKit', function(plate)
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)
    if not xPlayer or not plate then return end

    plate = ESX.Math.Trim(plate)

    local ped = GetPlayerPed(src)
    local vehicle = ped and ped ~= 0 and GetVehiclePedIsIn(ped, false) or 0
    if vehicle == 0 or ESX.Math.Trim(GetVehicleNumberPlateText(vehicle)) ~= plate then
        return
    end

    if MatchesRestrictedPrefix(plate) then
        print(("[CarLock] Blocked hotwire attempt: %s (%s) tried to hotwire restricted plate '%s'.")
            :format(GetPlayerName(src) or "?", xPlayer.identifier or "?", plate))
        TriggerEvent('DiscordBot:ToDiscord', 'lockpick', 'BlockedHotwireLog', '```css\n[ Player : '..(GetPlayerName(src) or "?")..'(' .. src .. ') ]\n[ Player Steam : '..(xPlayer.identifier or "?")..' ]\n[ Plate : '..tostring(plate)..' ]\n[ Reason : Restricted (job/emergency) vehicle plate ]\n```', 'user', true, src, false)
        return
    end

    local hotwireItem = xPlayer.getInventoryItem(Customize.HotwireItem)
    if hotwireItem and hotwireItem.count >= 1 then
        xPlayer.removeInventoryItem(Customize.HotwireItem, 1)
        TriggerClientEvent('CarLock:enableVehicleTemporarily', src)
        TriggerEvent('DiscordBot:ToDiscord', 'lockpick', 'VehicleLockpickLog', '```css\n[ Player : '..GetPlayerName(src)..'(' .. src .. ') ]\n[ Player Steam : '..xPlayer.identifier..' ]\n[ Plate : '..tostring(plate)..' ]\n[ Method : Hotwire Kit ]\n```', 'user', true, src, false)
    end
end)

ESX.RegisterServerCallback('CarLock:canHotwire', function(source, cb, plate)
    local xPlayer = ESX.GetPlayerFromId(source)
    if not xPlayer or not plate then cb(false) return end

    plate = ESX.Math.Trim(plate)
    local hasKey = FindKeySlot(xPlayer, plate) ~= nil

    if hasKey then
        cb(false)
        return
    end

    CheckDbOwnership(xPlayer, plate, function(isOwner)
        cb(not isOwner)
    end)
end)
