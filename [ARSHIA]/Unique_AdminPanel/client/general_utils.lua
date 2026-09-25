function drawNotification(string)
  SetNotificationTextEntry("STRING")
  AddTextComponentString(string)
  DrawNotification(true, false)
end

function LoadAnimDict( dict )
    while ( not HasAnimDictLoaded( dict ) ) do
        RequestAnimDict( dict )
        Citizen.Wait( 5 )
    end
end

function getEntity(player)
	local result, entity = GetEntityPlayerIsFreeAimingAt(player)
	return entity
end

function bulletCoords()
  local result, coord = GetPedLastWeaponImpactCoord(PlayerPedId())
  return coord
end

function getGroundZ(x, y, z)
		local result, groundZ = GetGroundZFor_3dCoord(x + 0.0, y + 0.0, z + 0.0, Citizen.ReturnResultAnyway())
		return groundZ
end

function GetUserInput(windowTitle, defaultText, maxLength)
    defaultText = defaultText or ""
    maxLength = maxLength or 40
    DisplayOnscreenKeyboard(1, "FMMC_MPM_NA", "", defaultText, "", "", "", maxLength)
    while true do
        Citizen.Wait(0)
        local status = UpdateOnscreenKeyboard()
        if status == 1 then
            return GetOnscreenKeyboardResult()
        elseif status == 2 or status == 3 then
            return nil
        end
    end
end

-- Vehicle model hashes from owned_vehicles aren't human-readable outside the
-- game engine, so resolve them to display names here (client-side, natives
-- only) before handing the Inspect data to the NUI.
function ResolveInspectVehicleLabels(data)
    if data and data.vehicles then
        for _, v in ipairs(data.vehicles) do
            if v.model then
                local ok, hash = pcall(tonumber, v.model)
                hash = ok and hash or v.model
                local internalName = GetDisplayNameFromVehicleModel(hash)
                local label = GetLabelText(internalName)
                v.modelLabel = (label ~= 'NULL' and label ~= '') and label or internalName
            else
                v.modelLabel = 'Unknown'
            end
        end
    end
    return data
end

-- ---------------------------------------------------- BUTTON PERMISSIONS ---
-- Per-button minimum permission_level, so different admin ranks can see
-- different buttons (not just the single Config.MinPermissionLevel gate
-- every server-side action still enforces). Missing entries just fall back
-- to Config.MinPermissionLevel. This is a VISIBILITY gate, client-side -
-- the server-side event each button calls still does its own
-- IsOnDutyAdmin check regardless, so hiding a button here is a UX
-- convenience, not the only line of defense.
--
-- To gate a new button: wrap it with AButton(id, label) instead of
-- ButtonAllowed(id) inside the MenuV builder (client/menuv_ui.lua) and add a row
-- for `id` to the ButtonCatalog list at the bottom of this file so it shows
-- up in the Button Permissions settings panel (Server Tools -> Settings).
MyPermissionLevel = 0
ButtonPerms = {}

-- BUG FIX: the level and the button permissions used to be fetched ONCE when the resource
-- started - usually before the character had loaded (level 0) and before going on duty
-- (button perms come back empty when off duty). Every button with a level floor
-- (Bring, Freeze, Kill, Clear New Life ...) then stayed hidden until the next restart.
-- They are now refreshed every time the menu opens and when duty changes.
local refreshing = false
function RefreshPermissions(cb)
    if ESX == nil then if cb then cb() end return end
    local pending, finished = 2, false
    local function done()
        pending = pending - 1
        if pending <= 0 and not finished then finished = true if cb then cb() end end
    end
    ESX.TriggerServerCallback('Unique_AdminPanel:GetMyPermissionLevel', function(level)
        MyPermissionLevel = tonumber(level) or 0
        done()
    end)
    ESX.TriggerServerCallback('Unique_AdminPanel:GetButtonPerms', function(perms)
        ButtonPerms = perms or {}
        done()
    end)
    -- never leave the caller hanging if the server doesn't answer
    SetTimeout(2000, function() if not finished then finished = true if cb then cb() end end end)
end

Citizen.CreateThread(function()
    while ESX == nil do Citizen.Wait(50) end
    Citizen.Wait(8000)
    RefreshPermissions()
end)

-- MenuV version: the menu is built declaratively (see client/menuv_ui.lua),
-- so instead of "draw the button and return whether it was clicked" this now
-- just answers "is this button visible to me?" and the builder skips it if not.
function ButtonAllowed(id)
    local required = ButtonPerms[id]
    return not (required and MyPermissionLevel < required)
end
AButton = ButtonAllowed -- kept so any old call site doesn't hit a nil global

-- id -> { label, category } - shown in the Button Permissions settings
-- panel. Add an entry here whenever you gate a new button with AButton().
ButtonCatalog = {
    { id = 'btn_ban',        label = 'Ban (minutes)',              category = 'Punishment' },
    { id = 'btn_ban_preset', label = 'Ban (Common Reason)',         category = 'Punishment' },
    { id = 'btn_unban',      label = 'Ban History Search / Unban',  category = 'Punishment' },
    { id = 'btn_kick',       label = 'Kick',                        category = 'Punishment' },
    { id = 'btn_jail',       label = 'Send to Jail',                category = 'Punishment' },
    { id = 'btn_cs',         label = 'Send to Community Service',   category = 'Punishment' },
    { id = 'btn_godmode',    label = 'Toggle God Mode (Target)',    category = 'Player Control' },
    { id = 'btn_givemoney',  label = 'Give Money',                  category = 'Economy' },
    { id = 'btn_setmoney',   label = 'Remove Money',                category = 'Economy' },
    { id = 'btn_clearinv',   label = 'Clear Inventory',             category = 'Player Control' },
    { id = 'btn_spawnveh',   label = 'Spawn Vehicle',                category = 'Vehicle' },
    { id = 'btn_weather',    label = 'Set Weather',                  category = 'World' },
    { id = 'btn_time',       label = 'Set Time',                     category = 'World' },
    { id = 'btn_impound',    label = 'Impound Vehicle',              category = 'Vehicle' },
    { id = 'btn_impound_yard', label = 'Impound Yard (Search / Release)', category = 'Vehicle' },
    { id = 'btn_restart',    label = 'Restart Resource',             category = 'Server' },
    { id = 'btn_bulk',       label = 'Bulk Actions (All Players)',   category = 'Server' },
    { id = 'btn_dutyhist',   label = 'Duty History Search',          category = 'Server' },
    { id = 'btn_appeals',    label = 'Review Ban Appeals',           category = 'Punishment' },
    { id = 'btn_transfer',   label = 'Character Transfer (Support)', category = 'Server' },
    { id = 'btn_faction',    label = 'Faction Treasury Audit',        category = 'Economy' },
}

local function EnumerateNearbyVehicles()
    return coroutine.wrap(function()
        local handle, vehicle = FindFirstVehicle()
        local finished = false
        repeat
            coroutine.yield(vehicle)
            finished, vehicle = FindNextVehicle(handle)
        until finished
        EndFindVehicle(handle)
    end)
end

-- Ported from esx_aduty's dvrange: deletes every vehicle within `range`
-- meters of the ADMIN (not a target), so it works even on empty/unowned
-- vehicles with no driver.
function DeleteVehiclesInRange(range)
    local playerCoords = GetEntityCoords(PlayerPedId())
    local deleted = 0

    for vehicle in EnumerateNearbyVehicles() do
        if DoesEntityExist(vehicle) then
            local vehicleCoords = GetEntityCoords(vehicle)
            if #(playerCoords - vehicleCoords) <= range then
                NetworkRequestControlOfEntity(vehicle)
                Citizen.Wait(0)
                ESX.Game.DeleteVehicle(vehicle)
                deleted = deleted + 1
            end
        end
    end

    if deleted > 0 then
        drawNotification(("~g~Deleted %s vehicle(s) within %sm"):format(deleted, range))
    else
        drawNotification("~y~No vehicles found in that range")
    end
    TriggerServerEvent('Unique_AdminPanel:LogClientAction', "dvrange", ("range: %s | deleted: %s"):format(range, deleted))
end

-- ---------------------------------------------------------------------------
-- Revive that works with the server's ambulance script.
-- The panel used to only call NetworkResurrectLocalPlayer: the ped got up, but the ambulance
-- script (death screen / "isDead" state / bleed-out timer) never learned about it, so F4 > Revive
-- looked broken while the F7 menu (which triggers the ambulance events) worked.
-- Order: revivexIfDead -> revivex -> raw resurrect, each tried only if the player is still dead.
function FullRevive()
    TriggerEvent('esx_ambulancejob:revivexIfDead')
    CreateThread(function()
        Wait(1500)
        if IsEntityDead(PlayerPedId()) then TriggerEvent('esx_ambulancejob:revivex') end
        Wait(1500)
        local ped = PlayerPedId()
        if IsEntityDead(ped) then
            NetworkResurrectLocalPlayer(GetEntityCoords(ped), GetEntityHeading(ped), true, false)
            SetEntityHealth(ped, GetEntityMaxHealth(ped))
            ClearPedBloodDamage(ped)
            ClearPedTasksImmediately(ped)
        end
    end)
end
