-- Bridges Unique_AdminPanel's on-duty state to UNIQUE_AC's own admin-exemption
-- mechanism. UNIQUE_AC/configs/fire-config.lua has a dedicated
-- `UNIQUE_AC.AdminMenu` section and a `UNIQUE_AC:adminState` server event
-- built exactly for an admin menu like this one to call (see
-- UNIQUE_AC/src/fire-server.lua) - it grants a real, TIME-BOXED anti-cheat
-- exemption (max 10 min per call, so it has to be refreshed) instead of a
-- silent, indefinite one, and it BANS anyone who fires it while not
-- recognized as an admin (UNIQUE_AC.AdminMenu.MenuPunishment). Nothing in
-- this resource ever called it before this file - on-duty admins using
-- noclip/teleport/godmode/vanish were relying solely on UNIQUE_AC's
-- blanket permission-level trust check, not this per-session grace period.
--
-- This only ADDS AddEventHandler listeners for the existing OnDutyHandler /
-- OffDutyHandler / OffDutyHandlerForJail events (already fired by
-- server/aduty_functions.lua's DutyHandler) - it doesn't touch or replace
-- any of that logic.

local GRACE_DURATION_MS = 5 * 60 * 1000  -- 5 min per grant
local GRACE_REFRESH_MS  = 4 * 60 * 1000  -- refresh before it expires (UNIQUE_AC caps a single grant at 10 min)

local isOnDuty = false
local graceThreadRunning = false

local function RequestGrace()
    TriggerServerEvent("UNIQUE_AC:adminState", true, GRACE_DURATION_MS)
end

local function RevokeGrace()
    TriggerServerEvent("UNIQUE_AC:adminState", false)
end

local function StartGraceLoop()
    isOnDuty = true
    RequestGrace()
    if graceThreadRunning then return end
    graceThreadRunning = true
    CreateThread(function()
        while isOnDuty do
            Wait(GRACE_REFRESH_MS)
            if isOnDuty then RequestGrace() end
        end
        graceThreadRunning = false
    end)
end

local function StopGraceLoop()
    if not isOnDuty then return end -- already off, nothing to revoke
    isOnDuty = false
    RevokeGrace()
end

AddEventHandler('OnDutyHandler', StartGraceLoop)
AddEventHandler('OffDutyHandler', StopGraceLoop)
AddEventHandler('OffDutyHandlerForJail', StopGraceLoop)

-- Safety net: if this client disconnects/resource stops mid-duty, don't
-- leave a stale server-side thread; UNIQUE_AC's own grant already expires
-- on its own (max 10 min), this just stops the local refresh loop.
AddEventHandler('onResourceStop', function(resourceName)
    if resourceName == GetCurrentResourceName() then
        isOnDuty = false
    end
end)
