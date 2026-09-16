--[[ 
    Hi dear customer or developer, here you can fully configure your server's 
    framework or you could even duplicate this file to create your own framework.

    If you do not have much experience, we recommend you download the base version 
    of the framework that you use in its latest version and it will work perfectly.
]]

if Config.Framework ~= "esx" then
    return
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
	PlayerData.job = job
end)



function TriggerServerCallback(name, cb, ...)
    ESX.TriggerServerCallback(name, cb, ...)
end

function GetPlayerIdentifier()
	return ESX.GetPlayerData().identifier
end

function GetClosestPlayer()
	return ESX.Game.GetClosestPlayer()
end

function GetClosestVehicle(coords)
	return ESX.Game.GetClosestVehicle(coords)
end

 

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