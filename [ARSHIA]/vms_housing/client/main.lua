--[[--------------------------------------------------------------------------
  EVENT: vms_housing:cl:playerDropped
  Client-side cleanup when the server notifies that the player “dropped”.
  (Same cleanup as resource stop: weather, shell, furniture, marketplace ped)
----------------------------------------------------------------------------]]
RegisterNetEvent("vms_housing:cl:playerDropped", function()
  if ToggleWeather then
    ToggleWeather(false)
  end

  if CurrentShell then
    DeleteObject(CurrentShell)
  end

  Property:RemoveFurniture()

  if Config.Marketplace.__ped then
    DeleteEntity(Config.Marketplace.__ped)
  end
end)

--[[--------------------------------------------------------------------------
  Helpers for MLO door system reset/remove
----------------------------------------------------------------------------]]
local function resetMloDoorSystemStates(doors, alsoRemoveFromDoorSystem)
  if not doors then return end

  for _, door in pairs(doors) do
    -- Double doors: reset left & right hashes if present
    if door.type == "double" then
      if door.left and door.left.hash then
        DoorSystemSetDoorState(door.left.hash, 4, false, false)
        DoorSystemSetDoorState(door.left.hash, 0, false, false)
        if alsoRemoveFromDoorSystem then
          RemoveDoorFromSystem(door.left.hash)
        end
      end

      if door.right and door.right.hash then
        DoorSystemSetDoorState(door.right.hash, 4, false, false)
        DoorSystemSetDoorState(door.right.hash, 0, false, false)
        if alsoRemoveFromDoorSystem then
          RemoveDoorFromSystem(door.right.hash)
        end
      end
    end

    -- Single hash doors
    if door.hash then
      DoorSystemSetDoorState(door.hash, 4, false, false)
      DoorSystemSetDoorState(door.hash, 0, false, false)
      if alsoRemoveFromDoorSystem then
        RemoveDoorFromSystem(door.hash)
      end
    end
  end
end

--[[--------------------------------------------------------------------------
  EVENT: vms_housing:cl:createdHouse
  Fired when a property is created/updated with fresh data from server.

  Behavior:
  - If old version existed and was MLO, “reset” its door system states.
  - Replace Properties[propertyId] with newPropertyData.
  - If new version is MLO with doors, register doors.
  - Refresh blips.
  - If player currently is in that zone (or object zone mapping), exit zone to force refresh.
----------------------------------------------------------------------------]]
RegisterNetEvent("vms_housing:cl:createdHouse", function(propertyId, newPropertyData)
  local existing = Properties[propertyId]

  -- If we had an old MLO property with doors, reset door states (no removal)
  if existing and existing.type == "mlo" then
    local oldDoors = existing.metadata and existing.metadata.doors
    resetMloDoorSystemStates(oldDoors, false)
  end

  -- Store the new property data
  Properties[propertyId] = newPropertyData

  -- If new is MLO, register doors if available
  local updated = Properties[propertyId]
  if updated and updated.type == "mlo" then
    local doors = updated.metadata and updated.metadata.doors
    if doors then
      -- NOTE: this forceLock computation matches the original obfuscated logic
      -- (it always resolves to nil/false, but we keep it identical).
      local renter = Properties[propertyId].renter
      local forceLock = (not renter) and renter

      Property:RegisterDoors({
        propertyId = propertyId,
        forceLock = forceLock,
        doors = doors,
      })
    end
  end

  RefreshBlips()

  -- Refresh All Properties list in Housing Creator NUI (if open)
  SendNUIMessage({
    action = "HousingCreator",
    actionName = "RefreshProperties"
  })

  -- If player is on this zone (or the object_id points to the zone), force zone exit
  local currentZoneId = GetCurrentPropertyId()
  local shouldExitZone = false

  if currentZoneId == propertyId then
    shouldExitZone = true
  else
    local objectId = Properties[propertyId] and Properties[propertyId].object_id
    if objectId then
      local currentStr = tostring(GetCurrentPropertyId())
      local objectStr = tostring(objectId)
      if currentStr == objectStr then
        shouldExitZone = true
      end
    end
  end

  if shouldExitZone then
    ExitZone()
  end
end)

--[[--------------------------------------------------------------------------
  EVENT: vms_housing:cl:removedHouse
  Fired when a property is removed from server.

  Behavior:
  - If it was an MLO with doors, reset + remove those doors from GTA door system.
  - Remove property from Properties.
  - Refresh blips.
  - If player is currently in that zone, exit zone.
----------------------------------------------------------------------------]]
RegisterNetEvent("vms_housing:cl:removedHouse", function(propertyId)
  local existing = Properties[propertyId]

  if existing and existing.type == "mlo" then
    local doors = existing.metadata and existing.metadata.doors
    resetMloDoorSystemStates(doors, true)
  end

  Properties[propertyId] = nil
  RefreshBlips()

  if GetCurrentPropertyId() == propertyId then
    ExitZone()
  end
end)

--[[--------------------------------------------------------------------------
  EVENT: vms_housing:cl:enterHouse
  Admin-only “force enter” (server validated).

  Flow:
  - Validate property exists & not currently inside a shell/IPL
  - Await permission from server callback
  - Validate shell/IPL definition exists
  - Fade out, freeze player, spawn shell/IPL, load static interactables
  - [SERVER CALL] vms_housing:sv:enterHouse
  - Weather loop thread (if enabled)
  - Light state, fade in, load furniture, unfreeze, refresh targets
----------------------------------------------------------------------------]]
RegisterNetEvent("vms_housing:cl:enterHouse", function(propertyId)
  local propertyData = GetProperty(propertyId)
  if not propertyData then return end
  if CurrentShell or CurrentIPL then return end

  -- [ASYNC SERVER CALLBACK (await)]
  local allowed = library.CallbackAwait("vms_housing:isAllowedToUseAdmin")
  if not allowed then return end

  -- Validate interior definition exists
  if propertyData.type == "shell" then
    if not AvailableShells[propertyData.metadata.shell] then
      return warn(('Could not find shell "%s"!'):format(propertyData.metadata.shell))
    end

    if not library.RequestEntity(propertyData.metadata.shell) then
      return warn(('Failed to load shell "%s" - make sure it is running!'):format(propertyData.metadata.shell))
    end

  elseif propertyData.type == "ipl" then
    if not AvailableIPLS[propertyData.metadata.ipl] then
      return warn(('Could not find ipl "%s"!'):format(propertyData.metadata.ipl))
    end
  else
    return
  end

  -- Clear any previously spawned furniture (world state)
  Property:RemoveFurniture()

  DoScreenFadeOut(1500)
  Wait(1500)

  FreezeEntityPosition(PlayerPedId(), true)

  CurrentProperty = tostring(propertyId)
  CurrentPropertyData = propertyData

  -- Load shell / IPL
  if propertyData.type == "shell" then
    CurrentShell = CreateObjectNoOffset(
      joaat(propertyData.metadata.shell),
      0.0, 0.0, 500.0,
      false, false, false
    )

    while not DoesEntityExist(CurrentShell) do
      Wait(1)
    end

    SetEntityHeading(CurrentShell, 0.0)
    FreezeEntityPosition(CurrentShell, true)

    Property:LoadStaticInteractable(AvailableShells[propertyData.metadata.shell])

  elseif propertyData.type == "ipl" then
    CurrentIPL = propertyData.metadata.ipl

    IPL.LoadSettings(CurrentIPL, propertyData.metadata.iplTheme, propertyData.metadata.iplSettings)
    Property:LoadStaticInteractable(AvailableIPLS[propertyData.metadata.ipl])
  end

  -- [SERVER CALL] mark player as inside
  TriggerServerEvent("vms_housing:sv:enterHouse", CurrentProperty)

  -- Weather loop (async thread)
  if ToggleWeather then
    Citizen.CreateThread(function()
      while CurrentShell or CurrentIPL do
        ToggleWeather(true, propertyData.type == "ipl")
        Citizen.Wait(30000)
      end
    end)
  end

  Wait(1500)

  -- Apply interior light state (if present)
  if CurrentPropertyData.metadata.lightState ~= nil then
    SetArtificialLightsState(not CurrentPropertyData.metadata.lightState)
  end

  DoScreenFadeIn(1500)

  -- Load furniture inside
  if propertyData.furniture then
    Property:LoadFurniture("inside", propertyData.furniture, CurrentProperty)
  end

  FreezeEntityPosition(PlayerPedId(), false)
  RefreshTargets()
end)

--[[--------------------------------------------------------------------------
  EVENT: vms_housing:cl:usedKeyItem
  Triggered when a player uses a “key item”.

  Behavior (kept identical):
  - If player is on the property zone (or its object-zone mapping), toggle MLO door lock near the player,
    OR toggle non-MLO lock if close to enter point.
  - Otherwise, if player is inside that property (shell/IPL), toggle lock if close to the interior door marker coords.
----------------------------------------------------------------------------]]
RegisterNetEvent("vms_housing:cl:usedKeyItem", function(propertyId, keyItemData)
  local ped = PlayerPedId()
  local coords = GetEntityCoords(ped)

  local propertyData = Properties[propertyId]
  if not propertyData then return end

  -- Some properties use `object_id` to map a zone id differently
  local isOnObjectZone = false
  if propertyData.object_id then
    local currentStr = tostring(GetCurrentPropertyId())
    local objectStr = tostring(propertyData.object_id)
    isOnObjectZone = (currentStr == objectStr)
  end

  local currentZoneId = GetCurrentPropertyId()

  -- OUTSIDE: on zone or object zone
  if currentZoneId == propertyId or isOnObjectZone then
    -- MLO: pick nearest door and toggle via server
    if propertyData.type == "mlo" then
      local doors = propertyData.metadata and propertyData.metadata.doors
      if not doors then
        return
      end

      -- Find nearest door index depending on door type
      local nearestDoorIndex = nil

      for doorIndex, door in pairs(doors) do
        if door.type == "slide_gate" then
          local dist = #(coords.xyz - vector3(door.coords.x, door.coords.y, door.coords.z))
          local maxDist = door.distance or 8.5
          if dist < maxDist then
            nearestDoorIndex = doorIndex -- does NOT break (same as original)
          end

        elseif door.type == "double" then
          local dist = #(coords.xyz - vector3(door.center.x, door.center.y, door.center.z))
          local maxDist = door.distance or 1.5
          if dist < maxDist then
            nearestDoorIndex = doorIndex
            break
          end

        elseif door.type == "single" then
          local dist = #(coords.xyz - vector3(door.coords.x, door.coords.y, door.coords.z))
          local maxDist = door.distance or 1.5
          if dist < maxDist then
            nearestDoorIndex = doorIndex
            break
          end
        end
      end

      if not nearestDoorIndex then
        return
      end

      -- Cooldown handling (identical behavior)
      local canUse = true
      if Property.LastLockedDoors then
        local now = GetGameTimer()
        if not (now > Property.LastLockedDoors) then
          canUse = false
        end
      end

      if canUse then
        -- [SERVER CALL] toggle a specific door lock by index
        TriggerServerEvent(
          "vms_housing:sv:toggleDoorlock",
          propertyId,
          nearestDoorIndex,
          nil,
          false,
          false
        )
        Property.LastLockedDoors = GetGameTimer() + 2000
      else
        CL.Notification(TRANSLATE("notify.doors:wait"), 3500, "info")
      end

    -- NON-MLO: toggle lock only if close to enter point
    else
      if propertyData.metadata and propertyData.metadata.enter then
        local enter = propertyData.metadata.enter
        local dist = #(coords.xyz - vector3(enter.x, enter.y, enter.z))
        if dist > 1.5 then
          return
        end

        Property:ToggleLock(propertyId, keyItemData)
      end
    end

    return
  end

  -- INSIDE: must match CurrentProperty
  if CurrentProperty ~= propertyId then
    return
  end

  -- Inside shell: use shell door marker from shell definition
  if CurrentShell then
    local shellDef = AvailableShells[propertyData.metadata.shell]
    if not (shellDef and shellDef.doors) then return end

    local doorPos = shellDef.doors
    local dist = #(coords.xyz - vector3(doorPos.x, doorPos.y, doorPos.z))
    if dist > 1.5 then return end

    Property:ToggleLock(propertyId, keyItemData)
    return
  end

  -- Inside IPL: use IPL door marker from IPL definition
  if CurrentIPL then
    local iplDef = AvailableIPLS[propertyData.metadata.ipl]
    if not (iplDef and iplDef.doors) then return end

    local doorPos = iplDef.doors
    local dist = #(coords.xyz - vector3(doorPos.x, doorPos.y, doorPos.z))
    if dist > 1.5 then return end

    Property:ToggleLock(propertyId, keyItemData)
    return
  end
end)

--[[--------------------------------------------------------------------------
  EVENT: vms_housing:cl:updateProperty
  Massive “state sync” event. This updates Properties and triggers:
  - blip refresh
  - target refresh
  - furniture reload in world
  - IPL theme reload
  - NUI updates (manage menu, modals, etc.)
  - menu closes when permissions are lost
----------------------------------------------------------------------------]]

local function myServerId()
  return GetPlayerServerId(PlayerId())
end

local function isFromMe(sourceId)
  return sourceId ~= nil and sourceId == myServerId()
end

local function buildManageUpdateBase(updateType)
  return {
    action = "Property",
    actionName = "UpdateManage",
    type = updateType,
    forcedUpdate = true,
  }
end

RegisterNetEvent("vms_housing:cl:updateProperty", function(action, propertyIdRaw, data, sourceId)
  local propertyId = tostring(propertyIdRaw)

  local refreshBlips = false
  local sendUiUpdate = nil
  local reloadWorldFurniture = false
  local reloadIplTheme = false
  local registerMloDoors = false

  -- This flag is used later to refresh “targets” and similar.
  local refreshTargets = false

  -- Some buildings use `object_id` indirection (e.g. rooms/apartments)
  local objectIdStr = nil
  local objectIdIsBuilding = false

  if Properties[propertyId] and Properties[propertyId].object_id then
    objectIdStr = tostring(Properties[propertyId].object_id)
    local obj = Properties[objectIdStr]
    if obj then
      objectIdIsBuilding = (obj.type == "building")
    end
  end

  -- If property doesn't exist and this isn't deliveredFurniture, do nothing
  if not Properties[propertyId] and action ~= "deliveredFurniture" then
    return
  end

  -- =======================================================================
  -- Action handlers
  -- =======================================================================

  if action == "newOwner" then
    -- Unlock doors when new owner is set
    Property:UnlockDoors(Properties[propertyId].metadata and Properties[propertyId].metadata.doors)

    Properties[propertyId].owner = data.owner
    Properties[propertyId].owner_name = data.owner_name
    Properties[propertyId].renter = data.renter
    Properties[propertyId].renter_name = data.renter_name
    Properties[propertyId].sale = data.sale
    Properties[propertyId].rental = data.rental

    if data.permissions then Properties[propertyId].permissions = data.permissions end
    if data.keys then Properties[propertyId].keys = data.keys end
    if data.bills then Properties[propertyId].bills = data.bills end
    if data.iplTheme then
      Properties[propertyId].metadata.iplTheme = data.iplTheme
    end

    if SelectedApartment and SelectedApartment == propertyId then
      ReloadApartmentMenu()
    end

    refreshBlips = true

  elseif action == "newRenter" then
    Property:UnlockDoors(Properties[propertyId].metadata and Properties[propertyId].metadata.doors)

    Properties[propertyId].renter = data.renter
    Properties[propertyId].renter_name = data.renter_name
    Properties[propertyId].permissions = data.permissions
    Properties[propertyId].sale = data.sale
    Properties[propertyId].rental = data.rental
    if data.keys then Properties[propertyId].keys = data.keys end
    Properties[propertyId].bills = data.bills

    if data and data.iplTheme then
      Properties[propertyId].metadata.iplTheme = data.iplTheme
    end

    if SelectedApartment and SelectedApartment == propertyId then
      ReloadApartmentMenu()
    end

    refreshBlips = true

  elseif action == "forceRemovedOwner" then
    -- If no renter, lock doors
    if not Properties[propertyId].renter then
      Property:LockDoors(Properties[propertyId].metadata and Properties[propertyId].metadata.doors)
    end

    Properties[propertyId].owner = nil
    Properties[propertyId].owner_name = nil

    if data.completelyRemoved then
      Properties[propertyId].keys = data.keys
      Properties[propertyId].permissions = data.permissions
      Properties[propertyId].metadata = data.metadata
      Properties[propertyId].sale = data.sale
      Properties[propertyId].rental = data.rental
    end

    if SelectedApartment and SelectedApartment == propertyId then
      ReloadApartmentMenu()
    end

    if openedMenu == "HousingCreator" then
      SendNUIMessage({ action = "HousingCreator", actionName = "RefreshPropertiesMenu" })
    end

    refreshBlips = true
    reloadWorldFurniture = true
    registerMloDoors = true

  elseif action == "forceRemovedRenter" then
    -- If no owner, lock doors
    if not Properties[propertyId].owner then
      Property:LockDoors(Properties[propertyId].metadata and Properties[propertyId].metadata.doors)
    end

    Properties[propertyId].renter = nil
    Properties[propertyId].renter_name = nil
    Properties[propertyId].keys = data.keys
    Properties[propertyId].permissions = data.permissions

    if data.completelyRemoved then
      Properties[propertyId].metadata = data.metadata
      Properties[propertyId].sale = data.sale
      Properties[propertyId].rental = data.rental
    end

    if SelectedApartment and SelectedApartment == propertyId then
      ReloadApartmentMenu()
    end

    if openedMenu == "HousingCreator" then
      SendNUIMessage({ action = "HousingCreator", actionName = "RefreshPropertiesMenu" })
    end

    refreshBlips = true
    reloadWorldFurniture = true

  elseif action == "autoSellProperty" then
    Property:LockDoors(Properties[propertyId].metadata and Properties[propertyId].metadata.doors)

    Properties[propertyId].owner = nil
    Properties[propertyId].owner_name = nil
    Properties[propertyId].renter = nil
    Properties[propertyId].renter_name = nil
    Properties[propertyId].keys = data.keys
    Properties[propertyId].permissions = {}
    Properties[propertyId].metadata = data.metadata
    Properties[propertyId].sale = data.sale
    Properties[propertyId].rental = data.rental
    Properties[propertyId].furniture = {}

    refreshBlips = true
    reloadWorldFurniture = true
    registerMloDoors = true

    if SelectedApartment and SelectedApartment == propertyId then
      ReloadApartmentMenu()
    end

    -- If update is meant for the source player, close manage menu
    if isFromMe(sourceId) then
      closeManageMenu()
    end

  elseif action == "toggleLight" then
    Properties[propertyId].metadata.lightState = data.lightState

    if CurrentProperty and CurrentProperty == propertyId then
      SetArtificialLightsState(not Properties[propertyId].metadata.lightState)
    end

    if isFromMe(sourceId) then
      library.PlayAnimation(
        PlayerPedId(),
        "mini@sprunk@first_person",
        "PLYR_BUY_DRINK_PT1",
        8.0, 8.0, 1800, 1
      )

      Citizen.CreateThread(function()
        Citizen.Wait(650)
        library.PlayAudio("lightSwitch")
      end)
    end

  elseif action == "toggleLock" then
    Properties[propertyId].metadata.locked = data.locked
    Properties[propertyId].isUnderRaid = data.isUnderRaid

    if SelectedApartment and SelectedApartment == propertyId then
      ReloadApartmentMenu()
    end

    if isFromMe(sourceId) then
      library.PlayAnimation(
        PlayerPedId(),
        "veh@std@habanero@ps@enter_exit",
        "d_locked",
        8.0, 8.0, 890, 1
      )

      Citizen.CreateThread(function()
        Citizen.Wait(400)
        if data.locked == true then
          library.PlayAudio("lockDoors")
        else
          library.PlayAudio("openDoors")
        end
      end)
    end

    refreshBlips = true

  elseif action == "toggleDoorlock" then
    -- Update door state in cached property data
    local doorId = data.doorId
    Properties[propertyId].metadata.doors[doorId].locked = data.locked
    Properties[propertyId].metadata.upgrades.antiBurglaryDoors = data.antiBurglaryDoors
    Properties[propertyId].isUnderRaid = data.isUnderRaid

    -- Apply door state to GTA door system
    local doorDef = Properties[propertyId].metadata.doors[doorId]
    local desiredState = (data.locked == true) and 1 or 0

    if doorDef.type == "double" then
      DoorSystemSetDoorState(doorDef.left.hash, desiredState, false, false)
      DoorSystemSetDoorState(doorDef.right.hash, desiredState, false, false)
    else
      DoorSystemSetDoorState(doorDef.hash, desiredState, false, false)
    end

    if isFromMe(sourceId) then
      -- Only play animation if not in a vehicle (matches original)
      if not IsPedInAnyVehicle(PlayerPedId(), false) then
        library.PlayAnimation(
          PlayerPedId(),
          "veh@std@habanero@ps@enter_exit",
          "d_locked",
          8.0, 8.0, 890, 1
        )
      end

      Citizen.CreateThread(function()
        Citizen.Wait(400)
        if data.locked == true then
          library.PlayAudio("lockDoors")
        else
          library.PlayAudio("openDoors")
        end
      end)
    end

    refreshBlips = true

  elseif action == "lockdown" then
    Properties[propertyId].metadata.lockdown = data.lockdown
    reloadWorldFurniture = true

    if SelectedApartment and SelectedApartment == propertyId then
      ReloadApartmentMenu()
    end

  elseif action == "raided" then
    Properties[propertyId].isUnderRaid = true
    Properties[propertyId].metadata.locked = false
    Properties[propertyId].metadata.upgrades.antiBurglaryDoors = data.antiBurglaryDoors

    refreshBlips = true

    if SelectedApartment and SelectedApartment == propertyId then
      ReloadApartmentMenu()
    end

  elseif action == "upgrade" then
    -- Ensure upgrades table exists
    if not Properties[propertyId].metadata.upgrades then
      Properties[propertyId].metadata.upgrades = {}
    end

    -- Update upgrade metadata
    Properties[propertyId].metadata.upgrades[data.metadataName] = data[data.metadataName]

    refreshBlips = true

    -- Build NUI update
    local ui = buildManageUpdateBase("upgrades")
    ui.forcedUpdate = true
    ui.ownUpgrades = {}
    ui.furnitureLimit = GetFurnitureLimit(Properties[propertyId].metadata.upgrades)
    sendUiUpdate = ui

    -- Fill ownUpgrades based on Config.HousingUpgrades
    for _, upgradeCfg in pairs(Config.HousingUpgrades) do
      local val = Properties[propertyId].metadata.upgrades[upgradeCfg.metadata]
      if val then
        sendUiUpdate.ownUpgrades[upgradeCfg.metadata] = val
      end
    end

  elseif action == "keys" then
    Properties[propertyId].keys = data.keys

    local ui = buildManageUpdateBase("keys")
    ui.keys = json.decode(Properties[propertyId].keys)
    sendUiUpdate = ui

    if SelectedApartment and SelectedApartment == propertyId then
      ReloadApartmentMenu()
    end

    if sourceId and isFromMe(sourceId) then
      SendNUIMessage({ action = "Property", actionName = "CloseModal" })
    end

  elseif action == "marketplace" then
    if data.description then
      Properties[propertyId].description = data.description
    end

    Properties[propertyId].sale = data.sale
    Properties[propertyId].rental = data.rental
    Properties[propertyId].metadata.contact_number = data.contact_number
    Properties[propertyId].metadata.furnished = data.furnished

    local ui = buildManageUpdateBase("marketplace")
    ui.description = Properties[propertyId].description
    ui.sale = Properties[propertyId].sale
    ui.rental = Properties[propertyId].rental
    ui.images = Properties[propertyId].metadata.images
    ui.contact_number = Properties[propertyId].metadata.contact_number
    ui.furnished = Properties[propertyId].metadata.furnished
    sendUiUpdate = ui

  elseif action == "marketplaceImage" then
    if not Properties[propertyId].metadata.images then
      Properties[propertyId].metadata.images = {}
    end

    Properties[propertyId].metadata.images[data.imageId] = data.imageURL

    local ui = buildManageUpdateBase("marketplace")
    ui.onlyPhotos = true
    ui.images = Properties[propertyId].metadata.images
    sendUiUpdate = ui

    if isFromMe(sourceId) then
      sendUiUpdate.closeModal = true
    end

  elseif action == "unpackedDelivery" then
    -- Remove "delivered" flags from all furniture metadata
    local furn = Properties[propertyId].furniture
    if not furn then return end

    for _, f in pairs(furn) do
      if f.metadata and f.metadata.delivered then
        f.metadata.delivered = nil
      end
    end

  elseif action == "storeFurniture" then
    if not data.furnitureId then return end

    for idx, f in pairs(Properties[propertyId].furniture) do
      if f.id == data.furnitureId then
        -- If it was placed in the world, remove entity from world when on relevant environment
        if f.position then
          if f.position.environment == "inside" then
            if CurrentProperty == propertyId then
              -- fallthrough to removal
            else
              goto continue_store
            end
          end

          if f.position.environment == "outside" then
            local zoneId = GetCurrentPropertyId()
            if zoneId ~= propertyId then
              goto continue_store
            end
          end

          Property:RemoveFurniture(data.furnitureId)
        end

        ::continue_store::
        Properties[propertyId].furniture[idx].stored = 1
        Properties[propertyId].furniture[idx].position = nil
        break
      end
    end

    local ui = buildManageUpdateBase("furniture")
    ui.furniture = Properties[propertyId].furniture
    sendUiUpdate = ui

  elseif action == "orderedFurniture" then
    if not Properties[propertyId].furniture then
      Properties[propertyId].furniture = {}
    end

    table.insert(Properties[propertyId].furniture, data.furniture)

    local ui = buildManageUpdateBase("ordered-furniture")
    ui.furniture = Properties[propertyId].furniture
    sendUiUpdate = ui

    if isFromMe(sourceId) then
      sendUiUpdate.forcedClose = true
    end

  elseif action == "deliveredFurniture" then
    -- This action payload is keyed by propertyId -> furnitureIds delivered.
    local anyDeliveredFlag = false
    local resolvedPropertyId = nil

    for deliveredPropertyId, deliveredList in pairs(data) do
      deliveredPropertyId = tostring(deliveredPropertyId)

      -- Track property id if player is inside/on-zone for that property
      local zoneId = GetCurrentPropertyId()
      if zoneId == deliveredPropertyId or CurrentProperty == deliveredPropertyId then
        propertyId = deliveredPropertyId
        resolvedPropertyId = deliveredPropertyId
      end

      for _, furnitureId in pairs(deliveredList) do
        if not Properties[deliveredPropertyId].furniture then
          Properties[deliveredPropertyId].furniture = {}
        end

        for _, f in pairs(Properties[deliveredPropertyId].furniture) do
          if f.id == furnitureId then
            if f.metadata then
              f.metadata.deliveryTime = nil

              -- DeliveryType == 3 special case (preserved)
              if Config.DeliveryType == 3 then
                local meta = Properties[deliveredPropertyId].metadata
                if meta and meta.deliveryType and meta.delivery then
                  f.metadata.delivered = true
                  anyDeliveredFlag = true
                end
              end
            end
            break
          end
        end
      end
    end

    -- If we have delivered furniture and player is in relevant property, load delivery marker furniture
    if anyDeliveredFlag and resolvedPropertyId and resolvedPropertyId ~= "nil" then
      local alreadyLoadedDelivery = false

      if next(Property.LoadedFurnitures) then
        for _, loaded in pairs(Property.LoadedFurnitures) do
          if loaded.furnitureId == "delivery" then
            alreadyLoadedDelivery = true
            break
          end
        end
      end

      if not alreadyLoadedDelivery then
        -- Load a fake “delivery” furniture entry (same as original)
        Property:LoadFurniture(
          Properties[resolvedPropertyId].metadata.deliveryType,
          {
            {
              stored = 1,
              metadata = { delivered = true },
            },
          },
          resolvedPropertyId
        )
      end
    end

  elseif action == "soldFurniture" or action == "removedFurniture" then
    if not data.furnitureId then return end

    for idx, f in pairs(Properties[propertyId].furniture) do
      if f.id == data.furnitureId then
        table.remove(Properties[propertyId].furniture, idx)
        break
      end
    end

    local ui = buildManageUpdateBase("furniture")
    ui.furniture = Properties[propertyId].furniture
    sendUiUpdate = ui

    if isFromMe(sourceId) then
      SendNUIMessage({ action = "Property", actionName = "CloseModal" })
    end

  elseif action == "placedFurniture" then
    for _, f in pairs(Properties[propertyId].furniture) do
      if f.id == data.furnitureId then
        f.position = data.position
        f.stored = 0
      end
    end

    reloadWorldFurniture = true

    if isFromMe(sourceId) then
      sendUiUpdate = { action = "Property", actionName = "CloseFurniture" }
    end

  elseif action == "addedFurniture" then
    if not Properties[propertyId].furniture then
      Properties[propertyId].furniture = {}
    end
    table.insert(Properties[propertyId].furniture, data.furniture)
    reloadWorldFurniture = true

  elseif action == "modifiedFurniture" then
    Properties[propertyId].furniture[data.furnitureId] = data.furniture
    reloadWorldFurniture = true

  elseif action == "modifiedTheme" then
    Properties[propertyId].metadata.iplTheme = data.iplTheme
    reloadIplTheme = true

  elseif action == "changedSafePin" then
    if not data.furnitureId then return end

    for idx, f in pairs(Properties[propertyId].furniture) do
      if f.id == data.furnitureId then
        Properties[propertyId].furniture[idx].metadata.pin = data.newPin
        break
      end
    end

    reloadWorldFurniture = true

    if isFromMe(sourceId) then
      sendUiUpdate = { action = "Safe", actionName = "ChangedPIN", success = true }

      SetNuiFocus(false, false)

      Citizen.CreateThread(function()
        Wait(1200)
        CloseSafe()
      end)
    end

  elseif action == "ringDoorbell" then
    if sourceId then
      if isFromMe(sourceId) then
        library.PlayAnimation(
          PlayerPedId(),
          "mp_doorbell",
          "open_door",
          8.0, 8.0, 2130, 1
        )

        Citizen.CreateThread(function()
          Wait(1200)
          library.PlayAudio("doorbell")
        end)
      end
    else
      if CurrentProperty == propertyId then
        library.PlayAudio("doorbellInside")
      end
    end

  elseif action == "paidBill" then
    if Properties[propertyId].bills and next(Properties[propertyId].bills) then
      for _, bill in pairs(Properties[propertyId].bills) do
        if bill.period == data.period and bill.type == data.type then
          bill.paid = 1
          break
        end
      end
    end

    Properties[propertyId].unpaidBills = data.unpaidBills
    Properties[propertyId].unpaidRentBills = data.unpaidRentBills

    local ui = buildManageUpdateBase("bills")
    ui.bills = Properties[propertyId].bills
    ui.unpaidBills = Properties[propertyId].unpaidBills
    ui.unpaidRentBills = Properties[propertyId].unpaidRentBills
    sendUiUpdate = ui

    if isFromMe(sourceId) then
      SendNUIMessage({ action = "Property", actionName = "CloseModal" })
    end

  elseif action == "changedWardrobePosition" then
    Properties[propertyId].metadata.wardrobe = data.wardrobe

    -- If player is inside this property, rebuild only wardrobe target
    if CurrentProperty and CurrentProperty == propertyId then
      for i = 1, #TargetPoints do
        if TargetPoints[i].type == "wardrobe" then
          CL.Target("remove-zone", TargetPoints[i].id)
          table.remove(TargetPoints, i)
          break
        end
      end

      local inside = CurrentShell or CurrentIPL or IsInsideMLO()
      if inside then
        table.insert(TargetPoints, TargetHandler.Wardrobe(
          CurrentProperty,
          CurrentPropertyData.metadata.wardrobe.x,
          CurrentPropertyData.metadata.wardrobe.y,
          CurrentPropertyData.metadata.wardrobe.z
        ))
      end
    end

  elseif action == "changedStoragePosition" then
    Properties[propertyId].metadata.storage = data.storage

    -- If player is inside this property, rebuild only storage target
    if CurrentProperty and CurrentProperty == propertyId then
      for i = 1, #TargetPoints do
        if TargetPoints[i].type == "storage" then
          CL.Target("remove-zone", TargetPoints[i].id)
          table.remove(TargetPoints, i)
          break
        end
      end

      local inside = CurrentShell or CurrentIPL or IsInsideMLO()
      if inside then
        table.insert(TargetPoints, TargetHandler.Storage(
          CurrentProperty,
          CurrentPropertyData.metadata.storage.x,
          CurrentPropertyData.metadata.storage.y,
          CurrentPropertyData.metadata.storage.z,
          CurrentPropertyData.metadata.storage.slots,
          CurrentPropertyData.metadata.storage.weight
        ))
      end
    end

  elseif action == "rentalTerminated" then
    Property:LockDoors(Properties[propertyId].metadata and Properties[propertyId].metadata.doors)

    Properties[propertyId].renter = nil
    Properties[propertyId].renter_name = nil
    Properties[propertyId].unpaidRentBills = nil
    Properties[propertyId].keys = data.keys
    Properties[propertyId].permissions = data.permissions
    Properties[propertyId].metadata = data.metadata
    Properties[propertyId].rental = data.rental
    Properties[propertyId].bills = data.bills

    local ui = buildManageUpdateBase("rental-termination")
    ui.keys = json.decode(Properties[propertyId].keys)
    ui.metadata = Properties[propertyId].metadata
    ui.permissions = Properties[propertyId].permissions
    ui.rental = Properties[propertyId].rental
    ui.bills = Properties[propertyId].bills
    sendUiUpdate = ui

    refreshBlips = true
    registerMloDoors = true

    if SelectedApartment and SelectedApartment == propertyId then
      ReloadApartmentMenu()
    end

    if isFromMe(sourceId) then
      SendNUIMessage({ action = "Property", actionName = "CloseModal" })
    end

  elseif action == "rentalTermination" or action == "clearRentalTermination" then
    Properties[propertyId].rental = data.rental

    local ui = buildManageUpdateBase("rental-termination")
    ui.rental = Properties[propertyId].rental
    sendUiUpdate = ui

    if isFromMe(sourceId) then
      SendNUIMessage({ action = "Property", actionName = "CloseModal" })
    end

  elseif action == "updatedPermissions" then
    Properties[propertyId].permissions = data.permissions

    refreshBlips = true

    local ui = buildManageUpdateBase("permissions")
    ui.permissions = Properties[propertyId].permissions
    sendUiUpdate = ui

    if SelectedApartment and SelectedApartment == propertyId then
      ReloadApartmentMenu()
    end

    if isFromMe(sourceId) then
      SendNUIMessage({ action = "Property", actionName = "CloseModal" })
    end

  elseif action == "movedOut" then
    -- If no owner, lock doors
    if not Properties[propertyId].owner then
      Property:LockDoors(Properties[propertyId].metadata and Properties[propertyId].metadata.doors)
    end

    Properties[propertyId].renter = nil
    Properties[propertyId].renter_name = nil
    Properties[propertyId].unpaidRentBills = nil

    Properties[propertyId].keys = data.keys
    Properties[propertyId].permissions = data.permissions
    Properties[propertyId].metadata = data.metadata
    Properties[propertyId].sale = data.sale
    Properties[propertyId].rental = data.rental
    Properties[propertyId].bills = data.bills

    local ui = buildManageUpdateBase("rental-termination")
    ui.keys = json.decode(Properties[propertyId].keys)
    ui.metadata = Properties[propertyId].metadata
    ui.permissions = Properties[propertyId].permissions
    ui.rental = Properties[propertyId].rental
    ui.bills = Properties[propertyId].bills
    sendUiUpdate = ui

    refreshBlips = true
    registerMloDoors = true

    if SelectedApartment and SelectedApartment == propertyId then
      ReloadApartmentMenu()
    end

    if isFromMe(sourceId) then
      closeManageMenu()
    end
  end

  -- =======================================================================
  -- Post-actions: blips, door registration, menu/permissions, targets/furniture/theme
  -- =======================================================================

  if refreshBlips then
    RefreshBlips()
  end

  -- Re-register MLO doors when requested (logic preserved)
  if registerMloDoors then
    if Properties[propertyId] and Properties[propertyId].type == "mlo" then
      local renter = Properties[propertyId].renter
      local forceLock = (not renter) and renter

      Property:RegisterDoors({
        propertyId = propertyId,
        forceLock = forceLock,
        doors = Properties[propertyId].metadata.doors,
      })
    end
  end

  -- If player is on this property zone or inside this property, enforce permission-based menu closes + UI updates
  local inRelevantContext = (GetCurrentPropertyId() == propertyId) or (CurrentProperty == propertyId)

  if inRelevantContext then
    local hasManagePerm = library.HasAnyPermission(propertyId)

    if not hasManagePerm then
      if openedMenu == "PropertyManage" then
        closeManageMenu()
      elseif openedMenu == "PropertyFurniture" or openedMenu == "PropertyFurniturePurchase" then
        closeFurnitureMenu()
      end
    end

    -- Only send manage UI updates while in manage/safe menus (same behavior)
    if sendUiUpdate then
      if openedMenu == "PropertyManage" or openedMenu == "Safe" then
        SendNUIMessage(sendUiUpdate)
      end
    end

    if refreshBlips then
      RefreshTargets()
    end
  else
    -- Special-case: if this property uses object_id and player is on object zone (e.g. building)
    if objectIdStr and GetCurrentPropertyId() == objectIdStr then
      -- Keep the original behavior for building menus:
      if sendUiUpdate and objectIdIsBuilding then
        if openedMenu == "BuildingMenu" or openedMenu == "ApartmentMenu" then
          SendNUIMessage(sendUiUpdate)
        end
      end

      if sendUiUpdate and (not objectIdIsBuilding) then
        if openedMenu == "PropertyManage" then
          SendNUIMessage(sendUiUpdate)
        end
      end

      if sendUiUpdate and objectIdIsBuilding then
        if MotelManageId and MotelManageId == propertyId and openedMenu == "PropertyManage" then
          SendNUIMessage(sendUiUpdate)
        end
      end

      if (not objectIdIsBuilding) and refreshBlips then
        RefreshBlips()
        RefreshTargets()
      end
    end
  end

  -- Reload world furniture when needed (async callback style preserved)
  if reloadWorldFurniture then
    Property:RemoveFurniture(nil, function()
      Property:LoadFurniture(
        (CurrentProperty and "inside") or "outside",
        Properties[propertyId].furniture,
        propertyId
      )

      -- Original extra reload for MLO without object_id: load opposite environment too
      if Properties[propertyId].type == "mlo" and not Properties[propertyId].object_id then
        Property:LoadFurniture(
          (CurrentProperty and "outside") or "inside",
          Properties[propertyId].furniture,
          propertyId
        )
      end
    end)
  end

  -- Apply IPL theme reload (preserved reposition callback)
  if reloadIplTheme then
    if CurrentIPL then
      IPL.LoadSettings(
        CurrentIPL,
        Properties[propertyId].metadata.iplTheme,
        Properties[propertyId].metadata.iplSettings,
        function()
          local p = GetEntityCoords(PlayerPedId())
          SetEntityCoords(PlayerPedId(), p.x, p.y, p.z)
        end
      )
    end
  end

  -- Special cleanups for specific actions (preserved)
  if action == "unpackedDelivery" then
    Property:RemoveFurniture("delivery")
  end

  if action == "autoSellProperty" then
    if CurrentProperty == propertyId then
      Property:ExitProperty()
    end
  end

  if action == "movedOut" then
    if CurrentProperty == propertyId then
      if CurrentPropertyData.owner then
        -- If owner exists and action didn't come from me, skip exit (preserved)
        if not isFromMe(sourceId) then
          return
        end
      end
      Property:ExitProperty()
    end
  end
end)

--[[--------------------------------------------------------------------------
  EVENT: vms_housing:cl:sendPropertyContract
  Shows contract UI (NUI) for a given propertyId and fills in region utilities.
----------------------------------------------------------------------------]]
RegisterNetEvent("vms_housing:cl:sendPropertyContract", function(contractData)
  local property = Properties[contractData.propertyId]
  if not property then return end

  contractData.address = property.address
  contractData.characterName = CharacterName

  local regionCfg = nil
  if property.region and Config.Regions[property.region] then
    regionCfg = Config.Regions[property.region]
  else
    regionCfg = Config.NoRegion
  end

  contractData.electricity = regionCfg.electricity
  contractData.water = regionCfg.water
  contractData.internet = regionCfg.internet

  -- [NUI]
  SendNUIMessage({
    action = "Property",
    actionName = "ShowContract",
    data = contractData,
  })

  SetNuiFocus(true, true)
  openedMenu = "Contract"
end)

--[[--------------------------------------------------------------------------
  EVENT: vms_housing:cl:reloadFurnitureList
  Receives full furniture list JSON and reloads NUI.
----------------------------------------------------------------------------]]
RegisterNetEvent("vms_housing:cl:reloadFurnitureList", function(furnitureJson)
  Furniture = json.decode(furnitureJson)

  -- [NUI]
  SendNUIMessage({
    action = "Property",
    actionName = "ReloadAvailableFurniture",
    data = Furniture,
  })
end)

--[[--------------------------------------------------------------------------
  EVENT: vms_housing:cl:reloadFurniture
  Updates one furniture entry if it exists, then reloads NUI list.
----------------------------------------------------------------------------]]
RegisterNetEvent("vms_housing:cl:reloadFurniture", function(furnitureId, updatedFurniture)
  if Furniture[furnitureId] then
    Furniture[furnitureId] = updatedFurniture

    -- [NUI]
    SendNUIMessage({
      action = "Property",
      actionName = "ReloadAvailableFurniture",
      data = Furniture,
    })
  end
end)