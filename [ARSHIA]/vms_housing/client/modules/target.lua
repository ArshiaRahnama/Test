--==============================================================
-- TargetHandler
-- Deobfuscated + cleaned for readability (logic preserved).
--
-- This module builds "target options" (likely for qb-target/ox_target style)
-- for interacting with properties: entering, viewing offers, furniture mode,
-- doorbell, lockpick, lockdown, raids, storage, wardrobe, management, locking.
--==============================================================

TargetHandler = TargetHandler or {}

--==============================================================
-- Helper: common "blocked while editing" check
-- Many actions are disabled while editing furniture/theme.
-- This function preserves the exact behavior: show the same notification and exit.
--==============================================================
local function blockIfInEditMode()
  if Property.EditingFurniture or Property.EditingTheme then
    CL.Notification(
      TRANSLATE("notify.furniture:you_are_in_furniture_mode"),
      5000,
      "info"
    )
    return true
  end
  return false
end

--==============================================================
-- ViewOffer
-- Builds a target option to view a property offer.
--==============================================================
function TargetHandler.ViewOffer(propertyId)
  return {
    name = "property-offer",
    icon = "fa-solid fa-scroll",
    label = TRANSLATE("target.view_house"),

    -- Action callback (invokes Property:ViewOffer(propertyId))
    action = function(_targetContext)
      Property:ViewOffer(propertyId)
    end,
  }
end

--==============================================================
-- Enter
-- Builds a target option to enter a property.
-- The caller provides:
--   - onEnter: function (executed on interaction)
--   - canInteract: function/boolean (target system decides if interactable)
--==============================================================
function TargetHandler.Enter(onEnter, canInteract)
  return {
    name = "property-enter",
    icon = "fa-solid fa-door-open",
    label = TRANSLATE("target.enter"),
    action = onEnter,
    canInteract = canInteract,
  }
end

--==============================================================
-- Furniture
-- Opens furniture menu unless currently in furniture/theme edit mode.
--==============================================================
function TargetHandler.Furniture(canInteract)
  return {
    name = "property-furniture",
    icon = "fa-solid fa-chair",
    label = TRANSLATE("target.furniture"),

    action = function()
      if blockIfInEditMode() then return end
      openFurnitureMenu()
    end,

    canInteract = canInteract,
  }
end

--==============================================================
-- Doorbell
-- SERVER CALL: vms_housing:sv:ringDoorbell(propertyId)
--==============================================================
function TargetHandler.Doorbell(propertyId)
  return {
    name = "property-doorbell",
    icon = "fa-solid fa-bell",
    label = TRANSLATE("target.doorbell"),

    action = function()
      -- SERVER EVENT
      TriggerServerEvent("vms_housing:sv:ringDoorbell", propertyId)
    end,
  }
end

--==============================================================
-- Lockpick
-- Starts lockpick minigame and notifies server/police (optional).
--
-- Params:
--   propertyId               (A0_2)
--   antiBurglaryDoors        (A1_2)  -> passed into minigame config
--   hasAntiBurglaryUpgrade   (A2_2)  -> used for conditional police alerts
--   onFinished(success)      (A3_2)  -> callback invoked after minigame ends
--   canInteract              (A4_2)
--
-- SERVER CALL: vms_housing:sv:startedLockpickDoors(propertyId)
--
-- ASYNC: CL.Minigame("lockpick", function(success) ... end, { antiBurglaryDoors = ... })
--==============================================================
function TargetHandler.Lockpick(propertyId, antiBurglaryDoors, hasAntiBurglaryUpgrade, onFinished, canInteract)
  local option = {
    name = "property-lockpick",
    icon = "fa-solid fa-unlock-keyhole",
    label = TRANSLATE("target.lockpick"),
  }

  local baseCanInteract = canInteract
  option.canInteract = function(...)
    if type(baseCanInteract) == "function" then
      if not baseCanInteract(...) then
        return false
      end
    end

    if Config.Lockpick and Config.Lockpick.Item and Config.Lockpick.Item.Required then
      local itemName = Config.Lockpick.Item.Name
      local itemCount = Config.Lockpick.Item.Count or 1
      return itemName and itemName ~= "" and library.HasItem(itemName, itemCount)
    end

    return true
  end

  option.action = function()
    -- Optional police alert on start
    if DispatchAlertClient and Config.Alarm and Config.Alarm.AlertPoliceOnLockpickStart then
      -- If "only with upgrade" is enabled, require the upgrade flag
      if not Config.Alarm.AlertPoliceOnlyWithUpgrade or hasAntiBurglaryUpgrade then
        DispatchAlertClient(Properties[tostring(propertyId)], "start")
      end
    end

    -- SERVER EVENT: mark that lockpick started
    TriggerServerEvent("vms_housing:sv:startedLockpickDoors", propertyId)

    -- ASYNC MINIGAME
    CL.Minigame("lockpick", function(success)
      if success then
        -- Optional police alert on success
        if DispatchAlertClient and Config.Alarm and Config.Alarm.AlertPoliceOnLockpickSuccess then
          if Config.Alarm.AlertPoliceOnlyWithUpgrade then
            if hasAntiBurglaryUpgrade then
              DispatchAlertClient(Properties[tostring(propertyId)], "success")
            end
          end
        end
      else
        -- Optional police alert on fail
        if DispatchAlertClient and Config.Alarm and Config.Alarm.AlertPoliceOnLockpickFail then
          if not Config.Alarm.AlertPoliceOnlyWithUpgrade or hasAntiBurglaryUpgrade then
            DispatchAlertClient(Properties[tostring(propertyId)], "failed")
          end
        end
      end

      -- Callback to caller with result
      onFinished(success)
    end, {
      antiBurglaryDoors = antiBurglaryDoors,
    })
  end

  -- Required item configuration (kept logically identical)
  if Config.Lockpick and Config.Lockpick.Item and Config.Lockpick.Item.Required then
    if Config.Lockpick.Item.Name then
      option.requiredItem = Config.Lockpick.Item.Name
    end
  end

  return option
end

--==============================================================
-- Lockdown
-- Enabled only if Config.PropertyLockdown.Enable is true.
-- Adds optional job restrictions and optional required item.
--==============================================================
function TargetHandler.Lockdown(action, canInteract)
  if not (Config.PropertyLockdown and Config.PropertyLockdown.Enable) then
    return nil
  end

  local option = {
    name = "property-lockdown",
    icon = "fa-solid fa-road-barrier",
    label = TRANSLATE("target.lockdown"),
    action = action,
    canInteract = canInteract,
  }

  -- Optional job restriction list
  if Config.PropertyLockdown.Jobs and next(Config.PropertyLockdown.Jobs) then
    option.jobs = Config.PropertyLockdown.Jobs
  end

  -- Optional required item
  if Config.PropertyLockdown.Item and Config.PropertyLockdown.Item.Required then
    option.requiredItem = Config.PropertyLockdown.Item.Name
  end

  return option
end

--==============================================================
-- RemoveSeal
-- Enabled only if Config.PropertyLockdown.Enable is true.
-- Adds optional job restrictions (no item requirement here in original).
--==============================================================
function TargetHandler.RemoveSeal(action, canInteract)
  if not (Config.PropertyLockdown and Config.PropertyLockdown.Enable) then
    return nil
  end

  local option = {
    name = "property-removeseal",
    icon = "fa-solid fa-lock-open",
    label = TRANSLATE("target.removeseal"),
    action = action,
    canInteract = canInteract,
  }

  if Config.PropertyLockdown.Jobs and next(Config.PropertyLockdown.Jobs) then
    option.jobs = Config.PropertyLockdown.Jobs
  end

  return option
end

--==============================================================
-- Raid
-- Enabled only if Config.PropertyRaids.Enable is true.
--
-- Params:
--   propertyId (optional; if nil uses GetCurrentPropertyId())
--   onFinished(success) callback
--   canInteract
--
-- SERVER CALLBACK (awaited):
--   library.CallbackAwait("vms_housing:isAllowedToRaid", propertyId)
--
-- ASYNC:
--   - plays animation
--   - runs CL.Minigame("police_raid", cb, { antiBurglaryDoors = ... })
--   - stops animation after minigame
--==============================================================
function TargetHandler.Raid(propertyId, onFinished, canInteract)
  if not (Config.PropertyRaids and Config.PropertyRaids.Enable) then
    return nil
  end

  local option = {
    name = "property-raid",
    icon = "fa-solid fa-person-walking-arrow-right",
    label = TRANSLATE("target.raid"),
    canInteract = canInteract,
  }

  option.action = function()
    -- SERVER CALLBACK (await):
    -- returns (isAllowed, reason/extra) (second return preserved but unused here)
    local raidPropertyId = propertyId or GetCurrentPropertyId()
    local isAllowed = library.CallbackAwait("vms_housing:isAllowedToRaid", raidPropertyId)
    if not isAllowed then
      return
    end

    local ped = PlayerPedId()

    -- Determine property data:
    -- If propertyId provided and exists in Properties[] use it, else fallback to GetCurrentPropertyData()
    local propertyData
    if propertyId and Properties[propertyId] then
      propertyData = Properties[propertyId]
    else
      propertyData = GetCurrentPropertyData()
    end

    -- Start raid animation
    library.PlayAnimation(
      ped,
      "missheistfbi3b_ig7",
      "lift_fibagent_loop",
      8.0,
      8.0,
      -1,
      1
    )

    -- ASYNC MINIGAME
    CL.Minigame("police_raid", function(success)
      library.StopAnimation(ped)
      onFinished(success)
    end, {
      antiBurglaryDoors = propertyData.metadata
        and propertyData.metadata.upgrades
        and propertyData.metadata.upgrades.antiBurglaryDoors,
    })
  end

  -- Optional job restriction list
  if Config.PropertyRaids.Jobs and next(Config.PropertyRaids.Jobs) then
    option.jobs = Config.PropertyRaids.Jobs
  end

  -- Optional required item
  if Config.PropertyRaids.Item and Config.PropertyRaids.Item.Required then
    option.requiredItem = Config.PropertyRaids.Item.Name
  end

  return option
end

--==============================================================
-- RaidLock (Complete Raid)
-- Enabled only if Config.PropertyRaids.Enable is true.
-- Adds optional job restrictions.
--==============================================================
function TargetHandler.RaidLock(action, canInteract)
  if not (Config.PropertyRaids and Config.PropertyRaids.Enable) then
    return nil
  end

  local option = {
    name = "property-complete_raid",
    icon = "fa-solid fa-door-closed",
    label = TRANSLATE("target.complete_raid"),
    action = action,
    canInteract = canInteract,
  }

  if Config.PropertyRaids.Jobs and next(Config.PropertyRaids.Jobs) then
    option.jobs = Config.PropertyRaids.Jobs
  end

  return option
end

--==============================================================
-- Storage
-- Creates a target zone entry for storage + returns a descriptor:
--   { type = "storage", id = <zoneId> }
--
-- Params:
--   permissionKey (A0_2)  -> used for permissions checks (library.HasAnyPermission / HasPermissions)
--   x,y,z (A1_2,A2_2,A3_2) -> zone coordinates
--   slots (A4_2), weight (A5_2)
--
-- ASYNC-like behavior: the action opens inventory UI; also blocks in edit mode.
--==============================================================
function TargetHandler.Storage(permissionKey, x, y, z, slots, weight)
  local option = {
    name = "property-storage",
    icon = "fa-solid fa-boxes-stacked",
    label = TRANSLATE("target.storage"),
  }

  option.action = function()
    if blockIfInEditMode() then return end

    OpenStorage({
      id = "house_storage-" .. permissionKey,
      slots = slots,
      weight = weight,
    })
  end

  -- Access control based on Config.StaticInteractionAccess
  if Config.StaticInteractionAccess == 2 then
    option.canInteract = function()
      return library.HasAnyPermission(permissionKey)
    end
  elseif Config.StaticInteractionAccess == 3 then
    option.canInteract = function()
      return library.HasPermissions(permissionKey, "furniture")
    end
  end

  -- Create the target zone
  local zoneId = CL.Target("zone", {
    coords = vector3(x, y, z),
    size = vec(1.5, 1.5, 2.0),
    rotation = 0.0,
    options = { option },
  })

  return {
    type = "storage",
    id = zoneId,
  }
end

--==============================================================
-- Wardrobe
-- Creates a target zone entry for wardrobe + returns:
--   { type = "wardrobe", id = <zoneId> }
--
-- Params:
--   permissionKey (A0_2)
--   x,y,z (A1_2,A2_2,A3_2)
--==============================================================
function TargetHandler.Wardrobe(permissionKey, x, y, z)
  local option = {
    name = "property-wardrobe",
    icon = "fa-solid fa-shirt",
    label = TRANSLATE("target.wardrobe"),
  }

  option.action = function()
    if blockIfInEditMode() then return end
    if not OpenWardrobe then
      return
    end
    OpenWardrobe()
  end

  if Config.StaticInteractionAccess == 2 then
    option.canInteract = function()
      return library.HasAnyPermission(permissionKey)
    end
  elseif Config.StaticInteractionAccess == 3 then
    option.canInteract = function()
      return library.HasPermissions(permissionKey, "furniture")
    end
  end

  local zoneId = CL.Target("zone", {
    coords = vector3(x, y, z),
    size = vec(1.5, 1.5, 2.0),
    rotation = 0.0,
    options = { option },
  })

  return {
    type = "wardrobe",
    id = zoneId,
  }
end

--==============================================================
-- Manage
-- Opens management menu for a property unless blocked by edit mode.
--==============================================================
function TargetHandler.Manage(propertyId, canInteract)
  return {
    name = "property-manage",
    icon = "fa-solid fa-gear",
    label = TRANSLATE("target.manage"),

    action = function()
      if blockIfInEditMode() then return end
      openManageMenu(propertyId)
    end,

    canInteract = canInteract,
  }
end

--==============================================================
-- ToggleLock
-- Toggles property lock state via Property:ToggleLock(propertyId)
--==============================================================
function TargetHandler.ToggleLock(propertyId, canInteract)
  return {
    name = "property-lock",
    icon = "fa-solid fa-key",
    label = TRANSLATE("target.toggle_lock"),

    action = function()
      Property:ToggleLock(propertyId)
    end,

    canInteract = canInteract,
  }
end
