-- Flags player PAIRS that repeatedly send bank money back and forth via
-- Unique_Phone's banking app, especially when both accounts are new/rarely
-- seen - a common "money mule" pattern (dupe funds get laundered through a
-- throwaway alt, or two alts split money one of them exploited).
--
-- SCOPE NOTE: this only watches Unique_Phone:server:TransferMoney (the one
-- confirmed player-to-player money-transfer path in this codebase). It
-- adds its own, SEPARATE `AddEventHandler` for that event - it does not
-- modify Unique_Phone/server/main.lua at all, never blocks/delays/changes
-- the transfer, and only reads data (never writes to `users`/bank
-- balances) - so it cannot break Unique_Phone's own transfer logic.
-- Vehicle-to-vehicle gifting isn't covered: no player-to-player vehicle
-- transfer event was found in this codebase to safely hook (vehicle
-- ownership changes appear to go through a dealership resource writing
-- `owned_vehicles` directly, not a broadcastable event) - wire it up the
-- same way once that resource/event is identified.

local Config_Collusion = {
    WindowMs            = 60 * 60 * 1000, -- 1 hour rolling window
    MinTransfers        = 4,              -- >= this many transfers total between the SAME pair (both directions combined)
    NewAccountAuditRows  = 3,             -- <= this many `audit` type='Enter' rows counts as "new/rarely-seen"
    DebounceSec         = 30 * 60,        -- don't re-flag the same pair more than once per 30 min
}

local PairTransfers = {} -- "idA|idB" (sorted) -> { {from=identifier, t=GetGameTimer()}, ... }
local LastPairFlag = {}  -- "idA|idB" -> os.time()

local function PairKey(a, b)
    if a < b then return a .. '|' .. b else return b .. '|' .. a end
end

local function IsNewAccount(identifier, cb)
    MySQL.Async.fetchScalar(
        "SELECT COUNT(*) FROM `audit` WHERE `identifier` = @id AND `type` = 'Enter'",
        { ['@id'] = identifier },
        function(count)
            count = tonumber(count) or 0
            cb(count > 0 and count <= Config_Collusion.NewAccountAuditRows)
        end
    )
end

-- Mirrors Unique_Phone/server/main.lua's own receiver-resolution order:
-- first try it as an online player's source id, then fall back to the
-- `iban` column on `users` for offline receivers.
local function ResolveIdentifierByIban(iban, cb)
    local onlinePlayer = ESX.GetPlayerFromId(tonumber(iban))
    if onlinePlayer then
        cb(onlinePlayer.identifier)
        return
    end
    MySQL.Async.fetchScalar(
        "SELECT `identifier` FROM `users` WHERE `iban` = @iban",
        { ['@iban'] = iban },
        function(identifier) cb(identifier) end
    )
end

local function CheckCollusion(fromIdentifier, toIdentifier)
    if not fromIdentifier or not toIdentifier or fromIdentifier == toIdentifier then return end

    local key = PairKey(fromIdentifier, toIdentifier)
    local now = GetGameTimer()
    local list = PairTransfers[key] or {}
    list[#list + 1] = { from = fromIdentifier, t = now }

    local pruned = {}
    for _, entry in ipairs(list) do
        if now - entry.t <= Config_Collusion.WindowMs then
            pruned[#pruned + 1] = entry
        end
    end
    PairTransfers[key] = pruned

    if #pruned < Config_Collusion.MinTransfers then return end

    local sawFromA, sawFromB = false, false
    for _, entry in ipairs(pruned) do
        if entry.from == fromIdentifier then sawFromA = true else sawFromB = true end
    end
    if not (sawFromA and sawFromB) then return end -- one-directional gifting only isn't the pattern we're after

    local lastFlag = LastPairFlag[key]
    local realNow = os.time()
    if lastFlag and (realNow - lastFlag) < Config_Collusion.DebounceSec then return end

    IsNewAccount(fromIdentifier, function(fromIsNew)
        IsNewAccount(toIdentifier, function(toIsNew)
            if not (fromIsNew and toIsNew) then return end -- both must be new/rarely-seen accounts

            LastPairFlag[key] = realNow
            local note = ('Auto-flag: possible collusion - %s back-and-forth bank transfer(s) with %s in <=%smin, both accounts new'):format(
                #pruned, toIdentifier, math.floor(Config_Collusion.WindowMs / 60000))

            for _, id in ipairs({ fromIdentifier, toIdentifier }) do
                MySQL.Async.execute(
                    "INSERT INTO `admin_player_flags` (`identifier`, `note`, `admin_name`, `created_at`) VALUES (@identifier, @note, @admin, @createdat) ON DUPLICATE KEY UPDATE `note` = @note, `admin_name` = @admin, `created_at` = @createdat",
                    { ['@identifier'] = id, ['@note'] = note, ['@admin'] = 'SYSTEM', ['@createdat'] = os.date('%Y-%m-%d %H:%M:%S') }
                )
            end

            for _, src in ipairs(ESX.GetPlayers()) do
                if IsOnDutyAdmin(src) then
                    TriggerClientEvent('chat:addMessage', src, {
                        color = { 255, 80, 80 },
                        args = { '[COLLUSION]', note },
                    })
                end
            end
            print('[Unique_AdminPanel] SYSTEM auto-flag (collusion): ' .. note)
        end)
    end)
end

-- Independent, additive listener - Unique_Phone keeps its own handler and
-- behaves exactly as before; this one only observes.
AddEventHandler('Unique_Phone:server:TransferMoney', function(iban, amount)
    local fromSource = source
    local fromPlayer = ESX.GetPlayerFromId(fromSource)
    if not fromPlayer then return end

    ResolveIdentifierByIban(iban, function(toIdentifier)
        if not toIdentifier then return end
        CheckCollusion(fromPlayer.identifier, toIdentifier)
    end)
end)
