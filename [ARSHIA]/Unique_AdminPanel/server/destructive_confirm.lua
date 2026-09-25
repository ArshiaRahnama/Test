-- Two-step confirmation for irreversible commands (CK / resetaccount and
-- anything else worth gating later). No NUI popup involved - this reuses
-- the same "type the target's name again" idea from a chat command
-- context: the admin must re-run the EXACT SAME command with the EXACT
-- SAME target label within CONFIRM_TIMEOUT_SECONDS, or it's treated as a
-- fresh (unconfirmed) attempt.
--
-- Usage inside a command handler, right before the destructive action:
--
--   if not RequestDestructiveConfirm(source, 'resetaccount', name) then
--       return -- first call: warning was sent, action was NOT performed
--   end
--   -- second call within the window: returns true, proceed as normal

local PendingConfirmations = {} -- "source:actionKey" -> { target = <label>, time = <os.time()> }
local CONFIRM_TIMEOUT_SECONDS = 20

function RequestDestructiveConfirm(source, actionKey, targetLabel)
    local key = tostring(source) .. ':' .. actionKey
    local pending = PendingConfirmations[key]
    local now = os.time()

    if pending and pending.target == targetLabel and (now - pending.time) <= CONFIRM_TIMEOUT_SECONDS then
        PendingConfirmations[key] = nil
        return true
    end

    PendingConfirmations[key] = { target = targetLabel, time = now }

    TriggerClientEvent('chatMessage', source, '[HOSHDAR]', { 255, 140, 0 },
        ('^1In amaliat GHEIR QABEL BAZGASHTe: ettela\'ate "%s" hazf/reset khahad shod.'):format(tostring(targetLabel)))
    TriggerClientEvent('chatMessage', source, '[HOSHDAR]', { 255, 140, 0 },
        ('^0Baraye tayid, hamin dastoor ra DOBARE ba hamin nam ejra konid (ta %s sanie).'):format(CONFIRM_TIMEOUT_SECONDS))

    return false
end

-- Clear a pending confirmation without waiting for it to expire (e.g. if a
-- command wants to cancel instead of letting it time out).
function CancelDestructiveConfirm(source, actionKey)
    PendingConfirmations[tostring(source) .. ':' .. actionKey] = nil
end

AddEventHandler('playerDropped', function()
    local prefix = tostring(source) .. ':'
    for key in pairs(PendingConfirmations) do
        if key:sub(1, #prefix) == prefix then
            PendingConfirmations[key] = nil
        end
    end
end)

-- Sweep expired entries periodically so this table can't grow unbounded on
-- a busy server (admins who start a destructive command and never confirm).
CreateThread(function()
    while true do
        Wait(30000)
        local now = os.time()
        for key, data in pairs(PendingConfirmations) do
            if (now - data.time) > CONFIRM_TIMEOUT_SECONDS then
                PendingConfirmations[key] = nil
            end
        end
    end
end)
