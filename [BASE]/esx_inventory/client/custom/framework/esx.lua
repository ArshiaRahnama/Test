--[[ 
    Hi dear customer or developer, here you can fully configure your server's 
    framework or you could even duplicate this file to create your own framework.

    If you do not have much experience, we recommend you download the base version 
    of the framework that you use in its latest version and it will work perfectly.
]]

if Config.Framework ~= "esx" then
    return
end


-------------------------------------------------------------------
-- BUG FIX (round 13): TriggerServerCallback / GetPlayerIdentifier /
-- GetClosestPlayer / GetClosestVehicle used to be defined AFTER the
-- ESX-resolution block below. For Config.esxVersion == 'old' (this
-- server: essentialmode) that block BLOCKS this file's own execution
-- inside `while not ESX do ... Wait(500) end` until essentialmode
-- responds to the handshake - so for however long that takes, these
-- four globals simply don't exist yet anywhere in the resource.
--
-- Nothing else in the resource waits for that: client/main.lua
-- registers its `inventory` command (bound to F2) on its own
-- top-level run, independent of this file's blocking loop. A player
-- who presses that key in the first second or two after connecting -
-- or right after a `restart esx_inventory` / `restart essentialmode`
-- sequence, before the handshake has had a chance to complete - calls
-- straight into a function that hasn't been defined yet:
--   "attempt to call a nil value (global 'TriggerServerCallback')"
-- A nil-check placed INSIDE these functions wouldn't have helped - the
-- functions themselves didn't exist yet to be called into; the crash
-- happens before their own body ever runs.
--
-- Fixed by defining all four unconditionally, right here, before ESX
-- resolution even starts. Each one waits (bounded to 10s, the same
-- budget already used elsewhere in this file, e.g. the
-- onClientResourceStart re-seed thread) for ESX to be ready before
-- touching it. A call arriving during that startup window now waits
-- briefly instead of crashing; a call arriving any time after behaves
-- exactly as it always did - same functions, same bodies, just moved
-- earlier and internally patient about ESX not being ready yet.
-------------------------------------------------------------------
local function waitForESX()
    local waited = 0
    while not ESX and waited < 10000 do
        Wait(100)
        waited = waited + 100
    end
    return ESX
end

function TriggerServerCallback(name, cb, ...)
    local esx = waitForESX()
    if not esx then return end
    esx.TriggerServerCallback(name, cb, ...)
end

function GetPlayerIdentifier()
    local esx = waitForESX()
    if not esx then return nil end
    return esx.GetPlayerData().identifier
end

function GetClosestPlayer()
    local esx = waitForESX()
    if not esx then return nil end
    return esx.Game.GetClosestPlayer()
end

function GetClosestVehicle(coords)
    local esx = waitForESX()
    if not esx then return nil end
    return esx.Game.GetClosestVehicle(coords)
end


if Config.esxVersion == 'new' then
	ESX = exports['es_extended']:getSharedObject()
elseif Config.esxVersion == 'old' then
    ESX = nil
    while not ESX do
        TriggerEvent(Config.Trigger["getSharedObject"], function(obj)
            ESX = obj
        end)
        Wait(500)
    end
end


RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
    PlayerData = xPlayer
    PlayerLoaded = true
end)


RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
	-- BUG FIX: unguarded `PlayerData.job = job` crashed with
	--   "attempt to index a nil value (global 'PlayerData')"
	-- whenever esx:setJob arrived before PlayerData was set - same
	-- root cause as the onClientResourceStart fix further down this
	-- file (a `restart esx_inventory` while the player stays connected
	-- resets this local to nil, and esx:playerLoaded isn't guaranteed
	-- to fire again just because this one resource restarted). Rather
	-- than only guarding the crash, this recovers PlayerData first via
	-- the same ESX.GetPlayerData() call the restart thread below
	-- already trusts, so a job change arriving in that gap still
	-- lands instead of silently getting dropped.
	if not PlayerData and ESX and type(ESX.GetPlayerData) == 'function' then
		local ok, data = pcall(ESX.GetPlayerData)
		if ok and type(data) == 'table' and data.identifier then
			PlayerData = data
			PlayerLoaded = true
		end
	end
	if PlayerData then
		PlayerData.job = job
	end
end)



-- TriggerServerCallback / GetPlayerIdentifier / GetClosestPlayer /
-- GetClosestVehicle now live at the top of this file (round 13) - see
-- the BUG FIX comment there for why they had to move.


function SendTextMessage(msg, type)
    if type == 'inform' then 
        SetNotificationTextEntry('STRING')
        AddTextComponentString(msg)
        DrawNotification(0,1)
    end
    if type == 'error' then 
        SetNotificationTextEntry('STRING')
        AddTextComponentString(msg)
        DrawNotification(0,1)
    end
    if type == 'success' then 
        SetNotificationTextEntry('STRING')
        AddTextComponentString(msg)
        DrawNotification(0,1)
    end
end

function ShowHelpNotification(msg)
	AddTextEntry('HelpNotification', msg)
	BeginTextCommandDisplayHelp('HelpNotification')
	EndTextCommandDisplayHelp(0, false, true, -1)
end
    
function DrawText3D(x, y, z, text)
	SetTextScale(0.4, 0.4)
    SetTextFont(4)
    SetTextProportional(1)
    SetTextColour(255, 255, 255, 215)
    SetTextEntry("STRING")
    SetTextCentre(true)
    AddTextComponentString(text)
    SetDrawOrigin(x,y,z, 0)
    DrawText(0.0, 0.0)
    ClearDrawOrigin()
end

-------------------------------------------------------------------
-- BUG FIX: this used to unconditionally call
--   exports['es_extended']:getSharedObject()
-- on every resource start. This server runs `essentialmode`, not
-- `es_extended` - that resource does not exist anywhere in the pack -
-- so the export call threw, the handler aborted at that line, and
-- `PlayerData` was never assigned.
--
-- Effects that had, all of which only showed up AFTER a
-- `restart esx_inventory` (never on a fresh connect, because
-- esx:playerLoaded sets PlayerData correctly on login):
--   * the clothing faction-lock check in client/main.lua reads
--     `PlayerData.job.name` - with PlayerData nil that silently
--     evaluated to nil and the lock never applied;
--   * hotbar ammo lookup (client/apps/system/slot.lua) found no
--     loadout.
--
-- Now respects Config.esxVersion like the top of this file already
-- does, and re-requests the shared object from whichever framework is
-- actually installed instead of hardcoding one.
-------------------------------------------------------------------
AddEventHandler('onClientResourceStart', function (resourceName)
    if GetCurrentResourceName() ~= resourceName then return end

    if Config.esxVersion == 'new' then
        if GetResourceState('es_extended') == 'started' then
            ESX = exports['es_extended']:getSharedObject()
        end
    else
        -- 'old' (essentialmode): same request/reply pattern as the top
        -- of this file. Retry briefly rather than once - on a manual
        -- resource restart the framework is already up, so this
        -- normally succeeds on the first pass.
        CreateThread(function()
            local waited = 0
            while not ESX and waited < 10000 do
                TriggerEvent(Config.Trigger["getSharedObject"], function(obj) ESX = obj end)
                if ESX then break end
                Wait(250)
                waited = waited + 250
            end
        end)
    end

    -- Re-seed PlayerData after a restart. ESX.GetPlayerData() is only
    -- meaningful once the shared object resolved above, and only if the
    -- player is actually spawned - guard both so a restart at the login
    -- screen doesn't error here.
    CreateThread(function()
        local waited = 0
        while not ESX and waited < 10000 do
            Wait(250)
            waited = waited + 250
        end
        if not ESX or type(ESX.GetPlayerData) ~= 'function' then return end

        local ok, data = pcall(ESX.GetPlayerData)
        if ok and type(data) == 'table' and data.identifier then
            PlayerData = data
            PlayerLoaded = true
        end
    end)
end)