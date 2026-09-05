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
-- WarMenu.Button(label) - same return value, same usage - and add a row
-- for `id` to the ButtonCatalog list at the bottom of this file so it shows
-- up in the Button Permissions settings panel (Server Tools -> Settings).
MyPermissionLevel = 0
ButtonPerms = {}

Citizen.CreateThread(function()
    while ESX == nil do Citizen.Wait(50) end
    ESX.TriggerServerCallback('Unique_AdminMenu:GetMyPermissionLevel', function(level)
        MyPermissionLevel = level or 0
    end)
    ESX.TriggerServerCallback('Unique_AdminMenu:GetButtonPerms', function(perms)
        ButtonPerms = perms or {}
    end)
end)

function AButton(id, label)
    local required = ButtonPerms[id]
    if required and MyPermissionLevel < required then
        return false
    end
    return WarMenu.Button(label)
end

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
    TriggerServerEvent('Unique_AdminMenu:LogClientAction', "dvrange", ("range: %s | deleted: %s"):format(range, deleted))
end