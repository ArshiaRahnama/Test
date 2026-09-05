-- Suspicious spawn-pattern detection: rapid bursts of items or new
-- vehicles, even with no matching money decrease (a legit purchase costs
-- money; a dupe/spawn exploit usually doesn't) - a different signature
-- than server/investigation.lua's money-spike scanner, which only catches
-- wealth INCREASING too fast, not stuff just appearing for free.

local Config_SpawnPattern = {
    ItemBurstCount    = 5,      -- N item-adds...
    ItemBurstWindowMs = 30000,  -- ...within this many ms = suspicious
    VehicleBurstCount = 2,      -- +N new vehicles...
    VehicleCheckMs    = 10 * 60 * 1000, -- ...within this interval = suspicious
}

local ItemAddTimestamps = {} -- source -> { timestamps }
local DebouncedFlag = {}     -- identifier -> os.time() of last auto-flag, avoid re-flagging every check

local function AutoFlag(identifier, playerId, note)
    local now = os.time()
    if DebouncedFlag[identifier] and (now - DebouncedFlag[identifier]) < 300 then return end -- 5 min debounce
    DebouncedFlag[identifier] = now

    MySQL.Async.execute(
        "INSERT INTO `admin_player_flags` (`identifier`, `note`, `admin_name`, `created_at`) VALUES (@identifier, @note, @admin, @createdat) ON DUPLICATE KEY UPDATE `note` = @note, `admin_name` = @admin, `created_at` = @createdat",
        { ['@identifier'] = identifier, ['@note'] = note, ['@admin'] = 'SYSTEM', ['@createdat'] = os.date('%Y-%m-%d %H:%M:%S') }
    )
    for _, src in ipairs(ESX.GetPlayers()) do
        if IsOnDutyAdmin(src) then
            TriggerClientEvent('chat:addMessage', src, {
                color = { 255, 80, 80 },
                args = { "[SPAWN PATTERN]", ("%s (id:%s): %s"):format(GetPlayerName(playerId) or '?', playerId, note) },
            })
        end
    end
    print(("[Unique_AdminMenu] SYSTEM auto-flag: %s (id:%s) -> %s"):format(GetPlayerName(playerId) or '?', playerId, note))
end

-- ------------------------------------------------------- ITEM BURSTS ---
-- essentialmode's addInventoryItem fires this for every item add,
-- regardless of which resource called it (shop, admin give, exploit menu).

AddEventHandler('esx:onaddInventoryItem', function(source, item, count)
    local xPlayer = ESX.GetPlayerFromId(source)
    if not xPlayer then return end

    local now = GetGameTimer()
    local list = ItemAddTimestamps[source] or {}
    list[#list + 1] = now

    -- Drop anything outside the burst window.
    local pruned = {}
    for _, t in ipairs(list) do
        if now - t <= Config_SpawnPattern.ItemBurstWindowMs then
            pruned[#pruned + 1] = t
        end
    end
    ItemAddTimestamps[source] = pruned

    if #pruned >= Config_SpawnPattern.ItemBurstCount then
        AutoFlag(xPlayer.identifier, source, ("Auto-flag: %s items added in <%ss (possible spawn exploit)"):format(
            #pruned, math.floor(Config_SpawnPattern.ItemBurstWindowMs / 1000)))
        ItemAddTimestamps[source] = {} -- reset so it doesn't refire every single item after
    end
end)

AddEventHandler('playerDropped', function()
    ItemAddTimestamps[source] = nil
end)

-- ----------------------------------------------------- VEHICLE BURSTS ---
-- No timestamp column on owned_vehicles to hook a "just bought" event, so
-- this compares each online player's total vehicle count between checks
-- instead - a jump of +2 or more between two 10-minute checks is not
-- normal dealership-flow buying.

local LastVehicleCount = {} -- identifier -> count

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(Config_SpawnPattern.VehicleCheckMs)

        for _, playerId in ipairs(ESX.GetPlayers()) do
            local xPlayer = ESX.GetPlayerFromId(playerId)
            if xPlayer then
                MySQL.Async.fetchScalar("SELECT COUNT(*) FROM `owned_vehicles` WHERE `owner` = @id", { ['@id'] = xPlayer.identifier }, function(count)
                    count = count or 0
                    local last = LastVehicleCount[xPlayer.identifier]
                    if last and (count - last) >= Config_SpawnPattern.VehicleBurstCount then
                        AutoFlag(xPlayer.identifier, playerId, ("Auto-flag: +%s vehicles registered in <=%smin (possible spawn exploit)"):format(
                            count - last, math.floor(Config_SpawnPattern.VehicleCheckMs / 60000)))
                    end
                    LastVehicleCount[xPlayer.identifier] = count
                end)
            end
        end
    end
end)

AddEventHandler('playerDropped', function()
    local xPlayer = ESX.GetPlayerFromId(source)
    if xPlayer then LastVehicleCount[xPlayer.identifier] = nil end
end)
