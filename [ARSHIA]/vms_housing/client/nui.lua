-- ============================================================================
-- NUI callbacks (deobfuscated / cleaned)
-- Keeps original behavior; only renamed variables + formatted + commented.
-- ============================================================================

-- Some builds/resources accidentally use RegisterNuiCallback instead of RegisterNUICallback.
-- Keep compatibility without changing behavior if the alias exists.
local RegisterNuiCallbackCompat = RegisterNuiCallback or RegisterNUICallback
local RegisterNUICallbackCompat = RegisterNUICallback

-- ---------------------------------------------------------------------------
-- NUI: UI finished loading (initial bootstrap payload)
-- ---------------------------------------------------------------------------
RegisterNUICallbackCompat("loaded", function(_, _cb)
  -- Small delay to let player/framework state settle (original behavior)
  Citizen.Wait(1500)

  local payload = {
    action = "loaded",
    lang = Config.Language,

    -- data tables prepared elsewhere
    availableShells = AvailableShells,
    availableIPLS = AvailableIPLS,

    -- player info
    characterName = CharacterName,

    -- config flags used by UI
    keysOnItem = Config.UseKeysOnItem,
    keyPrice = Config.KeyPrice,
    keysLimit = Config.KeysLimit,
    lockReplacementPrice = Config.LockReplacementPrice,

    useServiceBills = Config.UseServiceBills,
    furnitureSellPercentage = Config.FurnitureSellPercentage,
    requirePurchaseFurniture = Config.RequirePurchaseFurniture,
    deliveryFurnitureType = Config.DeliveryType,

    areaUnit = Config.AreaUnit,
    rentalCycles = Config.RentalCycles,
    allowedUnpaidRentBills = Config.AllowedUnpaidRentBills,

    allowChangeStoragePosition = Config.AllowChangeStoragePosition,
    allowChangeWardrobePosition = Config.AllowChangeWardrobePosition,

    allowTransactionFromMenu = (Config.Marketplace and Config.Marketplace.AllowTransactionFromMenu) or false,
    usingVMSGarages = (Config.Garages == "vms_garagesv2"),
  }

  if Config.UseServiceBills then
    payload.allowedUnpaidBills = Config.AllowedUnpaidBills
  end

  Citizen.Wait(200)

  -- [NUI]
  SendNUIMessage(payload)
end)

-- ---------------------------------------------------------------------------
-- CloseNUI(closeNonCreatorMenus)
-- IMPORTANT: preserves original semantics:
--   - if closeNonCreatorMenus is falsy -> ONLY closes HousingCreator (if opened)
--   - if closeNonCreatorMenus is truthy -> closes other menus (offer/manage/furniture/etc)
-- ---------------------------------------------------------------------------
local function CloseNUI(closeNonCreatorMenus)
  -- Creator-only close
  if not closeNonCreatorMenus then
    if openedMenu == "HousingCreator" then
      HousingCreator:Close()
    end
    return
  end

  -- Non-creator close logic
  if openedMenu == "PropertyOffer"
    or openedMenu == "BuildingMenu"
    or openedMenu == "ApartmentMenu"
    or openedMenu == "Contract"
  then
    if openedMenu == "Contract" then
      -- [SERVER]
      TriggerServerEvent("vms_housing:sv:cancelContract")
    end

    Property:CloseOffer()
    return
  end

  if openedMenu == "PropertyManage" then
    closeManageMenu()
    return
  end

  if openedMenu == "PropertyFurniture" then
    if closeFurnitureMenu then
      closeFurnitureMenu()
    else
      -- Fallback: furniture module not loaded yet (or failed).
      SendNUIMessage({ action = "Property", actionName = "CloseFurniture" })
      SetNuiFocus(false, false)
      openedMenu = nil
    end
    return
  end

  if openedMenu == "PropertyFurniturePurchase" then
    SetNuiFocus(false, false)
    return
  end

  if openedMenu == "Safe" then
    CloseSafe()
    return
  end

  if openedMenu == "Marketplace" then
    closeMarketplace()
    return
  end
end

closeNUI = CloseNUI -- keep original global name

RegisterNUICallbackCompat("close", function(data, cb)
  -- NUI sends `{ menu: currentMenu }` (e.g. housing_creator / housing_manage / safe / marketplace).
  -- Preserve CloseNUI semantics: creator closes with no arg; everything else uses `true`.
  local menu = data and data.menu

  if menu == "housing_creator" or openedMenu == "HousingCreator" then
    closeNUI()
  else
    closeNUI(true)
  end

  if cb then
    cb("ok")
  end
end)

-- ---------------------------------------------------------------------------
-- HousingCreator: select shell / ipl (updates local config state)
-- ---------------------------------------------------------------------------
RegisterNUICallbackCompat("creator:selectShell", function(data, _cb)
  if openedMenu ~= "HousingCreator" then
    return
  end

  houseConfiguration.type = "shell"
  houseConfiguration.shell = data.shell
end)

RegisterNUICallbackCompat("creator:selectIPL", function(data, _cb)
  if openedMenu ~= "HousingCreator" then
    return
  end

  houseConfiguration.type = "ipl"
  houseConfiguration.ipl = data.ipl
end)

-- ---------------------------------------------------------------------------
-- HousingCreator: preview shell (spawns shell and shows overlay; X to go back)
-- ---------------------------------------------------------------------------
RegisterNUICallbackCompat("creator:previewShell", function(data, _cb)
  if openedMenu ~= "HousingCreator" then
    return
  end

  -- [NUI] hide creator menu
  SendNUIMessage({
    action = "HousingCreator",
    actionName = "Update",
    data = { type = "hide-menu" }
  })

  SetNuiFocus(false, false)

  HousingCreator:EnterShell(data.shell, function()
    -- [ASYNC THREAD] draw helper UI until preview exits
    Citizen.CreateThread(function()
      while CurrentShell do
        drawText2D("Selected Shell:", 0.5, 0.08, 0.4, 255, 255, 255)
        drawText2D(("~p~%s~s~"):format(data.shell), 0.5, 0.1, 0.65, 255, 255, 255)
        drawText2D("Press ~g~[X]~s~ to back", 0.5, 0.14, 0.3, 255, 255, 255)

        -- X
        if IsControlJustPressed(0, 73) then
          DeleteObject(CurrentShell)

          -- restore previous coords if saved
          if houseConfiguration.previousCoords and houseConfiguration.previousCoords.x then
            SetEntityCoords(PlayerPedId(), houseConfiguration.previousCoords.xyz)
          end

          -- [NUI] show creator menu again
          SendNUIMessage({
            action = "HousingCreator",
            actionName = "Update",
            data = { type = "show-menu" }
          })

          SetNuiFocus(true, true)

          -- original uses false sentinel
          CurrentShell = false
          break
        end

        Citizen.Wait(1)
      end
    end)
  end)
end)

-- ---------------------------------------------------------------------------
-- HousingCreator: preview IPL (loads IPL settings; E to go back)
-- ---------------------------------------------------------------------------
RegisterNUICallbackCompat("creator:previewIPL", function(data, _cb)
  if openedMenu ~= "HousingCreator" then
    return
  end

  -- [NUI] hide creator menu
  SendNUIMessage({
    action = "HousingCreator",
    actionName = "Update",
    data = { type = "hide-menu" }
  })

  SetNuiFocus(false, false)

  -- pick first theme key if available (matches original behavior)
  local firstThemeKey = nil
  local iplDef = AvailableIPLS[data.ipl]
  if iplDef and iplDef.settings and iplDef.settings.Themes then
    for k in pairs(iplDef.settings.Themes) do
      firstThemeKey = k
      break
    end
  end

  HousingCreator:EnterIPL(data.ipl, function()
    -- [ASYNC THREAD]
    Citizen.CreateThread(function()
      while CurrentIPL do
        drawText2D("Selected IPL:", 0.5, 0.08, 0.4, 255, 255, 255)
        drawText2D(("~p~%s~s~"):format(data.ipl), 0.5, 0.1, 0.65, 255, 255, 255)
        drawText2D("Press ~g~[E]~s~ to back", 0.5, 0.14, 0.3, 255, 255, 255)

        -- E
        if IsControlJustPressed(0, 38) then
          if houseConfiguration.previousCoords and houseConfiguration.previousCoords.x then
            SetEntityCoords(PlayerPedId(), houseConfiguration.previousCoords.xyz)
          end

          IPL.UnloadSettings(data.ipl)

          -- [NUI] show creator menu again
          SendNUIMessage({
            action = "HousingCreator",
            actionName = "Update",
            data = { type = "show-menu" }
          })

          SetNuiFocus(true, true)

          CurrentIPL = false
          break
        end

        Citizen.Wait(1)
      end
    end)
  end, firstThemeKey)
end)

-- ---------------------------------------------------------------------------
-- HousingCreator: main action handler (save/delete/address/region/points/doors/etc)
-- ---------------------------------------------------------------------------
RegisterNUICallbackCompat("creator:actionButton", function(data, _cb)
  if openedMenu ~= "HousingCreator" then
    return
  end

  local nuiMsg = { action = "HousingCreator" }

  local housingType = data.type
  local action = data.action

  local isHousingType =
    housingType == "shell"
    or housingType == "ipl"
    or housingType == "mlo"
    or housingType == "building"
    or housingType == "motel"

  if isHousingType then
    if action == "save" then
      HousingCreator:Save(data)
      nuiMsg.actionName = "Open"

    elseif action == "delete" then
      -- [SERVER]
      TriggerServerEvent("vms_housing:sv:deleteHouse", data.id)
      nuiMsg.actionName = "Open"

    elseif action == "address" then
      houseConfiguration.type = housingType

      local coords = GetEntityCoords(PlayerPedId())
      local streetHash = GetStreetNameAtCoord(coords.x, coords.y, coords.z)
      local streetName = GetStreetNameFromHashKey(streetHash)

      houseConfiguration.address = (streetName and streetName ~= "") and streetName or "-"

      nuiMsg.actionName = "Update"
      nuiMsg.data = {
        type = "update-input-value",
        inputName = action,
        housingType = housingType,
        value = houseConfiguration.address
      }

    elseif action == "region" then
      houseConfiguration.type = housingType

      local coords = GetEntityCoords(PlayerPedId())
      local region = library.GetCurrentRegion(coords.xyz) or "None"
      houseConfiguration.region = region

      nuiMsg.actionName = "Update"
      nuiMsg.data = {
        type = "update-input-value",
        inputName = action,
        housingType = housingType,
        value = houseConfiguration.region
      }

    else
      -- Any "point/zone/door" action
      -- Ensure creator input updates target the correct configuration section.
      houseConfiguration.type = housingType

      nuiMsg.actionName = "Update"
      nuiMsg.data = { type = "hide-menu" }

      -- Remove focus for most actions (original excludes remove_door)
      if action ~= "remove_door" then
        SetNuiFocus(false, false)
      end

      if action == "yard_zone" then
        HousingCreator:Polyzone()

      elseif action == "interior_zone" then
        HousingCreator:Polyzone(true)

      elseif action == "enter_point" then
        HousingCreator:CreateEnterPoint()

      elseif action == "exit_point" then
        HousingCreator:CreateExitPoint()

      elseif action == "emergency_exit_outside" then
        HousingCreator:CreateEmergencyExitOutsidePoint()

      elseif action == "emergency_exit_inside" then
        HousingCreator:CreateEmergencyExitInsidePoint(nil, data.houseTheme)

      elseif action == "menu_point" then
        HousingCreator:CreateMenuPoint()

      elseif action == "add_single_doors" then
        HousingCreator:CreateDoor()

      elseif action == "add_double_doors" then
        HousingCreator:CreateDoor(true)

      elseif action == "add_slide_gate" then
        HousingCreator:CreateDoor(false, true)

      elseif action == "remove_door" then
        -- Special: returns early in original
        HousingCreator:RemoveDoor(data.doorId)
        return

      elseif action == "garage_point" then
        if data.isGarage then
          HousingCreator:CreateGaragePoint()
        elseif data.isParking then
          HousingCreator:CreateParkingSpaces()
        end

      elseif action == "enter_garage_point" then
        HousingCreator:CreateEnterGaragePoint()

      elseif action == "wardrobe_point" then
        HousingCreator:CreateWardrobePoint(false, data.houseTheme)

      elseif action == "storage_point" then
        HousingCreator:CreateStoragePoint(false, data.houseTheme)

      elseif action == "delivery_coordinates" then
        HousingCreator:CreateDeliveryPoint(nil, data.isInside, nil, data.houseTheme)
      end
    end
  else
    -- Furniture creator actions
    if housingType == "furniture" then
      if action == "save" then
        if not data.model then return end
        HousingCreator:SaveFurniture(data)
        nuiMsg.actionName = "Open"

      elseif action == "delete" then
        if not data.model then return end
        -- [SERVER]
        TriggerServerEvent("vms_housing:sv:deleteFurniture", data.model)
        nuiMsg.actionName = "Open"

      elseif action == "register" then
        if data.props then
          -- [ASYNC THREAD]
          Citizen.CreateThread(function()
            RegisterFurniture(data.props)
          end)
          nuiMsg.actionName = "Close"
        end
      end
    end
  end

  Citizen.Wait(250)

  if nuiMsg.actionName == "Close" then
    SetNuiFocus(false, false)
  end

  -- [NUI]
  SendNUIMessage(nuiMsg)
end)

-- ---------------------------------------------------------------------------
-- HousingCreator: load an existing property into houseConfiguration
-- ---------------------------------------------------------------------------
RegisterNUICallbackCompat("creator:loadPropertyConfig", function(data, _cb)
  if openedMenu ~= "HousingCreator" then
    return
  end

  if not data.id then
    return
  end

  local property = Properties[tostring(data.id)]
  if not property then
    return
  end

  local meta = property.metadata

  -- base fields
  houseConfiguration.type = property.type
  houseConfiguration.address = property.address
  houseConfiguration.region = property.region

  -- interior selector
  if property.type == "shell" then
    houseConfiguration.shell = meta.shell
  elseif property.type == "ipl" then
    houseConfiguration.ipl = meta.ipl
  elseif property.type == "mlo" then
    -- deep-copies to avoid editing live data
    local interiorZone = meta and meta.interiorZone or {}
    houseConfiguration.interiorZone = {
      points = library.Deepcopy(interiorZone.points) or {},
      minZ = interiorZone.minZ or -90.0,
      maxZ = interiorZone.maxZ or 90.0,
    }

    houseConfiguration.doors = library.Deepcopy(meta.doors) or {}

    -- remove hashes (original strips hash fields for editor)
    for _, door in pairs(houseConfiguration.doors) do
      if door.left and door.left.hash then door.left.hash = nil end
      if door.right and door.right.hash then door.right.hash = nil end
      if door.hash then door.hash = nil end
    end

    houseConfiguration.menuCoords = library.Deepcopy(meta.menu) or { x = 0.0, y = 0.0, z = 0.0, w = 0.0 }
  end

  -- zones / points
  if meta and meta.zone then
    houseConfiguration.zone = {
      points = library.Deepcopy(meta.zone.points),
      minZ = meta.zone.minZ,
      maxZ = meta.zone.maxZ,
    }
  end

  if meta and meta.wardrobe then
    houseConfiguration.wardrobeCoords = { x = meta.wardrobe.x, y = meta.wardrobe.y, z = meta.wardrobe.z }
  end

  if meta and meta.storage then
    houseConfiguration.storageCoords = {
      x = meta.storage.x,
      y = meta.storage.y,
      z = meta.storage.z,
      slots = tonumber(meta.storage.slots or 1),
      weight = tonumber(meta.storage.weight or 1),
    }
  end

  if meta and meta.enter then
    houseConfiguration.enterCoords = { x = meta.enter.x, y = meta.enter.y, z = meta.enter.z }
  end

  if meta and meta.exit then
    houseConfiguration.exitCoords = { x = meta.exit.x, y = meta.exit.y, z = meta.exit.z, w = meta.exit.w }
  end

  if meta and meta.emergencyOutside then
    houseConfiguration.emergencyOutsideCoords = {
      x = meta.emergencyOutside.x, y = meta.emergencyOutside.y, z = meta.emergencyOutside.z, w = meta.emergencyOutside.w
    }
  end

  if meta and meta.emergencyInside then
    houseConfiguration.emergencyInsideCoords = { x = meta.emergencyInside.x, y = meta.emergencyInside.y, z = meta.emergencyInside.z }
  end

  if meta and meta.garage then
    houseConfiguration.garageCoords = { x = meta.garage.x, y = meta.garage.y, z = meta.garage.z, w = meta.garage.w }
  end

  if meta and meta.parking then
    houseConfiguration.parkingSpaces = library.Deepcopy(meta.parking)
  end

  if meta and meta.deliveryType then
    houseConfiguration.deliveryPoint = {
      x = meta.delivery.x, y = meta.delivery.y, z = meta.delivery.z, w = meta.delivery.w
    }
  end
end)

-- ---------------------------------------------------------------------------
-- HousingCreator: info endpoints for UI
-- ---------------------------------------------------------------------------
RegisterNUICallbackCompat("creator:getAllBuildings", function(_, cb)
  local buildings, motels = HousingCreator:GetObjects(true, true)
  cb({ buildings = buildings, motels = motels })
end)

RegisterNUICallbackCompat("creator:getBuildingParking", function(data, cb)
  local spaces = HousingCreator:GetBuildingParkingSpaces(tostring(data.id))
  cb(spaces)
end)

RegisterNUICallbackCompat("creator:getAllProperties", function(_, cb)
  -- اگه Properties کلاینت خالیه، مستقیم از سرور بگیر
  local count = 0
  for _ in pairs(Properties) do count = count + 1 end

  if count > 0 then
    cb(Properties)
  else
    -- درخواست مستقیم از سرور
    TriggerServerEvent("vms_housing:sv:getAdminProperties")
    -- منتظر جواب بمون
    local deadline = GetGameTimer() + 5000
    while count == 0 and GetGameTimer() < deadline do
      Citizen.Wait(100)
      for _ in pairs(Properties) do count = count + 1 end
    end
    print("[vms_housing] getAllProperties fallback: " .. count .. " properties")
    cb(Properties)
  end
end)

RegisterNUICallbackCompat("creator:getAllFurniture", function(_, cb)
  cb(Furniture)
end)

-- ---------------------------------------------------------------------------
-- HousingCreator: teleport helpers
-- ---------------------------------------------------------------------------
RegisterNUICallbackCompat("creator:teleportToProperty", function(data, _cb)
  if openedMenu ~= "HousingCreator" then
    return
  end

  local property = Properties[tostring(data.id)]
  if not property or not property.metadata then
    return
  end

  local meta = property.metadata

  -- Prefer menu coords if present
  if meta.menu then
    SetEntityCoords(PlayerPedId(), meta.menu.x, meta.menu.y, meta.menu.z)
    return
  end

  -- Fallback: exit coords
  if meta.exit then
    SetEntityCoords(PlayerPedId(), meta.exit.x, meta.exit.y, meta.exit.z)
    return
  end

  -- Fallback: if it's an apartment/motel room referencing a building, teleport to parent exit
  if property.object_id then
    local parent = Properties[tostring(property.object_id)]
    if parent and parent.metadata and parent.metadata.exit then
      local exit = parent.metadata.exit
      SetEntityCoords(PlayerPedId(), exit.x, exit.y, exit.z)
    end
  end
end)

RegisterNUICallbackCompat("creator:teleportToDoors", function(data, _cb)
  if openedMenu ~= "HousingCreator" then
    return
  end

  local door = houseConfiguration.doors[tonumber(data.id)]
  if not door then
    return
  end

  if door.type == "single" then
    SetEntityCoords(PlayerPedId(), door.coords.x, door.coords.y, door.coords.z)
  else
    SetEntityCoords(PlayerPedId(), door.center.x, door.center.y, door.center.z)
  end
end)

-- ---------------------------------------------------------------------------
-- HousingCreator: force remove owner/renter
-- ---------------------------------------------------------------------------
RegisterNUICallbackCompat("creator:removeOwner", function(data, _cb)
  if openedMenu ~= "HousingCreator" then
    return
  end
  -- [SERVER]
  TriggerServerEvent("vms_housing:sv:removeOwner", data.id)
end)

RegisterNUICallbackCompat("creator:removeRenter", function(data, _cb)
  if openedMenu ~= "HousingCreator" then
    return
  end
  -- [SERVER]
  TriggerServerEvent("vms_housing:sv:removeRenter", data.id)
end)

-- ---------------------------------------------------------------------------
-- Apartments: open apartment menu / view offer (building only)
-- ---------------------------------------------------------------------------
RegisterNUICallbackCompat("apartments:getInformations", function(data, _cb)
  if not data.apartmentId then
    return
  end

  local apartmentId = tostring(data.apartmentId)

  local building = GetCurrentPropertyData()
  if not building or building.type ~= "building" then
    return
  end

  local apartment = Properties[apartmentId]
  if not apartment or not apartment.object_id then
    return
  end

  SelectedApartment = apartmentId

  -- apartment must belong to current building
  if tostring(apartment.object_id) ~= tostring(building.id) then
    return
  end

  local menuData = {}

  -- if not owned/rented => open offer view
  if not apartment.owner and not apartment.renter then
    Property:ViewOffer(apartmentId)
    return
  end

  menuData.buildingData = building
  ReloadApartmentMenu()

  -- [NUI]
  SendNUIMessage({
    action = "Property",
    actionName = "ApartmentMenu",
    data = menuData
  })

  SetNuiFocus(true, true)
  openedMenu = "ApartmentMenu"
end)

-- ---------------------------------------------------------------------------
-- Apartments: actions (cooldown protected)
-- ---------------------------------------------------------------------------
local apartmentsActionCooldown = 0

RegisterNUICallbackCompat("apartments:action", function(data, _cb)
  if not data.action or not data.apartmentId then
    return
  end

  local apartmentId = tostring(data.apartmentId)

  -- cooldown (original: 3s)
  if apartmentsActionCooldown ~= 0 and (apartmentsActionCooldown + 3000) > GetGameTimer() then
    CL.Notification(TRANSLATE("notify.wait"), 4500, "error")
    return
  end

  local building = GetCurrentPropertyData()
  if not building or building.type ~= "building" then
    return
  end

  local apartment = Properties[apartmentId]
  if not apartment or not apartment.object_id then
    return
  end

  if tostring(apartment.object_id) ~= tostring(GetCurrentPropertyId()) then
    return
  end

  apartmentsActionCooldown = GetGameTimer()

  if data.action == "manage" then
    local manageTarget = TargetHandler.Manage(apartmentId)
    if not apartment.metadata.lockdown then
      manageTarget.action()
      SelectedApartment = nil

      -- [NUI]
      SendNUIMessage({
        action = "Property",
        actionName = "CloseViewOffer",
        dontRemoveCurrentMenu = true
      })
    end

  elseif data.action == "lockdown" then
    if not apartment.metadata.lockdown then
      -- [SERVER]
      TriggerServerEvent("vms_housing:sv:lockdown", apartmentId)
    end

  elseif data.action == "remove_police_seal" then
    if apartment.metadata.lockdown then
      -- [SERVER]
      TriggerServerEvent("vms_housing:sv:removePoliceSeal", apartmentId)
    end

  elseif data.action == "raid" then
    local raidTarget = TargetHandler.Raid(apartmentId, function(confirmed)
      if confirmed then
        -- [SERVER]
        TriggerServerEvent("vms_housing:sv:raidProperty", apartmentId)
      end
    end)

    Property:CloseOffer()
    raidTarget.action()

  elseif data.action == "raid_lock" then
    if apartment.isUnderRaid then
      Property:ToggleLock(apartmentId, nil, true)
    end

  elseif data.action == "enter" then
    Property:EnterProperty(apartment, apartmentId, function(entered)
      if entered then
        Property:CloseOffer()
      end
    end)

  elseif data.action == "doorbell" then
    -- [SERVER]
    TriggerServerEvent("vms_housing:sv:ringDoorbell", apartmentId)

  elseif data.action == "lock" then
    if not apartment.metadata.lockdown then
      Property:ToggleLock(apartmentId)
    end

  elseif data.action == "lockpick" then
    local antiBurglary = apartment.metadata and apartment.metadata.upgrades and apartment.metadata.upgrades.antiBurglaryDoors
    local alarm = apartment.metadata and apartment.metadata.upgrades and apartment.metadata.upgrades.alarm

    local lockpickTarget = TargetHandler.Lockpick(apartmentId, antiBurglary, alarm, function(mode)
      -- [SERVER]
      TriggerServerEvent("vms_housing:sv:lockpickDoors", apartmentId, mode)
    end)

    if apartment.metadata.locked and not apartment.metadata.lockdown then
      Property:CloseOffer()
      lockpickTarget.action()
    end
  end
end)

-- ---------------------------------------------------------------------------
-- Property offer: interior preview (shell/ipl) for offers
-- ---------------------------------------------------------------------------
RegisterNUICallbackCompat("propertyOffer:enterHouse", function(data, _cb)
  -- If called for an apartment in a building menu, use that apartment; otherwise current offer property
  local offerProperty = nil
  if data.apartmentId and Properties[data.apartmentId] then
    offerProperty = Properties[data.apartmentId]
  else
    offerProperty = GetCurrentPropertyData()
  end

  if not offerProperty then
    return
  end

  -- Doors/exit marker comes from shell/ipl definition
  if offerProperty.metadata.shell then
    local shellName = offerProperty.metadata.shell
    local shellDef = AvailableShells[shellName]
    if not shellDef then return end

    Property:CloseOffer()

    local doors = shellDef.doors
    HousingCreator:EnterShell(shellName, function()
      -- local previewExitZoneId
      local previewExitZoneId = nil

      CL.HandleAction("enterInteriorPreview")

      -- [SERVER]
      TriggerServerEvent(
        "vms_housing:sv:enterPreviewHouse",
        data.apartmentId or GetCurrentPropertyId()
      )

      -- [ASYNC THREAD] keep weather forced while preview active
      if ToggleWeather then
        Citizen.CreateThread(function()
          while CurrentShell do
            ToggleWeather(true)
            Citizen.Wait(30000)
          end
        end)
      end

      -- Create an exit target inside preview
      previewExitZoneId = CL.Target("zone", {
        coords = vector3(doors.x, doors.y, doors.z + 1.5),
        size = vec(1.5, 2.1, 2.0),
        rotation = doors.heading,
        options = {
          {
            name = "property-exit",
            icon = "fa-solid fa-door-open",
            label = TRANSLATE("target.exit"),
            action = function()
              DeleteObject(CurrentShell)

              if ToggleWeather then
                ToggleWeather(false)
              end

              -- Teleport back outside
              if offerProperty.object_id then
                local parent = Properties[tostring(offerProperty.object_id)]
                if parent and parent.metadata and parent.metadata.exit then
                  SetEntityCoords(PlayerPedId(), parent.metadata.exit.x, parent.metadata.exit.y, parent.metadata.exit.z)
                else
                  SetEntityCoords(PlayerPedId(), offerProperty.metadata.exit.x, offerProperty.metadata.exit.y, offerProperty.metadata.exit.z)
                  SetEntityHeading(PlayerPedId(), offerProperty.metadata.exit.w)
                end
              else
                SetEntityCoords(PlayerPedId(), offerProperty.metadata.exit.x, offerProperty.metadata.exit.y, offerProperty.metadata.exit.z)
                SetEntityHeading(PlayerPedId(), offerProperty.metadata.exit.w)
              end

              CL.HandleAction("exitInteriorPreview")

              -- [SERVER]
              TriggerServerEvent(
                "vms_housing:sv:exitPreviewHouse",
                data.apartmentId or GetCurrentPropertyId()
              )

              CL.Target("remove-zone", previewExitZoneId)

              CurrentShell = false
            end
          }
        }
      })
    end)

  elseif offerProperty.metadata.ipl then
    local iplName = offerProperty.metadata.ipl
    local iplDef = AvailableIPLS[iplName]
    if not iplDef then return end

    Property:CloseOffer()

    local doors = iplDef.doors
    local chosenTheme = data.iplTheme or offerProperty.metadata.iplTheme

    HousingCreator:EnterIPL(iplName, function()
      local previewExitZoneId = nil

      CL.HandleAction("enterInteriorPreview")

      -- [SERVER]
      TriggerServerEvent(
        "vms_housing:sv:enterPreviewHouse",
        data.apartmentId or GetCurrentPropertyId()
      )

      if ToggleWeather then
        Citizen.CreateThread(function()
          while CurrentIPL do
            ToggleWeather(true, true)
            Citizen.Wait(30000)
          end
        end)
      end

      previewExitZoneId = CL.Target("zone", {
        coords = vector3(doors.x, doors.y, doors.z + 1.5),
        size = vec(1.5, 2.1, 2.0),
        rotation = doors.heading,
        options = {
          {
            name = "property-exit",
            icon = "fa-solid fa-door-open",
            label = TRANSLATE("target.exit"),
            action = function()
              IPL.UnloadSettings(CurrentIPL)

              if ToggleWeather then
                ToggleWeather(false)
              end

              -- Teleport back outside
              if offerProperty.object_id then
                local parent = Properties[tostring(offerProperty.object_id)]
                if parent and parent.metadata and parent.metadata.exit then
                  SetEntityCoords(PlayerPedId(), parent.metadata.exit.x, parent.metadata.exit.y, parent.metadata.exit.z)
                else
                  SetEntityCoords(PlayerPedId(), offerProperty.metadata.exit.x, offerProperty.metadata.exit.y, offerProperty.metadata.exit.z)
                  SetEntityHeading(PlayerPedId(), offerProperty.metadata.exit.w)
                end
              else
                SetEntityCoords(PlayerPedId(), offerProperty.metadata.exit.x, offerProperty.metadata.exit.y, offerProperty.metadata.exit.z)
                SetEntityHeading(PlayerPedId(), offerProperty.metadata.exit.w)
              end

              CL.HandleAction("exitInteriorPreview")

              -- [SERVER]
              TriggerServerEvent(
                "vms_housing:sv:exitPreviewHouse",
                data.apartmentId or GetCurrentPropertyId()
              )

              CL.Target("remove-zone", previewExitZoneId)

              CurrentIPL = false
            end
          }
        }
      })
    end, chosenTheme)
  end
end)

-- ---------------------------------------------------------------------------
-- Contracts: buy/rent from offer screen
-- ---------------------------------------------------------------------------
RegisterNUICallbackCompat("propertyOffer:contractDone", function(data, _cb)
  if data.contractType == "rent" then
    if isOfferByMarketplace then
      -- [SERVER]
      TriggerServerEvent(
        "vms_housing:sv:rentPropertyMarketplace",
        marketplaceOfferId,
        data.paymentMethod,
        data.rentCycle,
        { apartmentId = data.apartmentId }
      )
    else
      -- [SERVER]
      TriggerServerEvent(
        "vms_housing:sv:rentProperty",
        GetCurrentPropertyId(),
        data.paymentMethod,
        data.rentCycle,
        { selectedTheme = data.selectedTheme, apartmentId = data.apartmentId }
      )
    end
  else
    if isOfferByMarketplace then
      -- [SERVER]
      TriggerServerEvent(
        "vms_housing:sv:purchasePropertyMarketplace",
        marketplaceOfferId,
        data.paymentMethod,
        { apartmentId = data.apartmentId }
      )
    else
      -- [SERVER]
      TriggerServerEvent(
        "vms_housing:sv:purchaseProperty",
        GetCurrentPropertyId(),
        data.paymentMethod,
        { selectedTheme = data.selectedTheme, apartmentId = data.apartmentId }
      )
    end
  end

  Property.CloseOffer()
end)

RegisterNUICallbackCompat("propertyContract:send", function(data, _cb)
  local propertyId = MotelManageId or CurrentProperty or GetCurrentPropertyId()

  -- [SERVER]
  TriggerServerEvent(
    "vms_housing:sv:sendPropertyContract",
    propertyId,
    data.contractType,
    data.player,
    data.price,
    data.paymentMethod,
    data.rentCycle
  )

  closeManageMenu()
  Property.CloseOffer()
end)

RegisterNUICallbackCompat("propertyContract:signed", function(_, _cb)
  -- [SERVER]
  TriggerServerEvent("vms_housing:sv:signedPropertyContract")
  Property.CloseOffer()
end)

-- ---------------------------------------------------------------------------
-- Theme / furniture entry points
-- ---------------------------------------------------------------------------
RegisterNUICallbackCompat("propertyTheme:edit", function(data, _cb)
  closeFurnitureMenu()
  editTheme(data.theme)
end)

RegisterNUICallbackCompat("propertyFurniture:edit", function(_, _cb)
  Property.EditingFurniture = true
  editFurniture()
  closeFurnitureMenu()
end)

RegisterNUICallbackCompat("propertyFurniture:placeNew", function(data, _cb)
  manageFurniture(false, data.model, data.id)
  closeFurnitureMenu()
end)

-- ---------------------------------------------------------------------------
-- Furniture purchase: accept/cancel
-- ---------------------------------------------------------------------------
RegisterNUICallbackCompat("propertyFurniture:purchaseAccept", function(data, _cb)
  if Property.EditingTheme then
    -- [ASYNC SERVER CALLBACK]
    library.Callback("vms_housing:buyTheme", function(success)
      if success then
        Property.EditingTheme = false

        -- [NUI]
        SendNUIMessage({ action = "Property", actionName = "CloseFurniturePurchase" })
        SetNuiFocus(false, false)
      end
    end, (CurrentProperty or GetCurrentPropertyId()), Property.EditingTheme, data.paymentMethod)
  else
    -- [ASYNC SERVER CALLBACK]
    library.Callback("vms_housing:buyFurniture", function(success)
      if success then
        Property.EditingFurniture = false

        DeleteObject(Property.EditingFurnitureObj)
        Property.EditingFurnitureObj = nil

        -- [NUI]
        SendNUIMessage({ action = "Property", actionName = "CloseFurniturePurchase" })
        SetNuiFocus(false, false)
      end
    end, (CurrentProperty or GetCurrentPropertyId()), Property.EditingFurnitureData, data.paymentMethod)
  end
end)

RegisterNUICallbackCompat("propertyFurniture:purchaseCancel", function(_, _cb)
  -- [NUI]
  SendNUIMessage({ action = "Property", actionName = "CloseFurniturePurchase" })

  -- If theme preview was active, restore current theme (IPL only)
  if Property.EditingTheme and CurrentIPL then
    local prop = CurrentPropertyData or GetCurrentPropertyData()
    if prop then
      IPL.LoadSettings(CurrentIPL, prop.metadata.iplTheme, prop.metadata.iplSettings, function()
        -- keep player coords stable (original does this)
        local coords = GetEntityCoords(PlayerPedId())
        SetEntityCoords(PlayerPedId(), coords.x, coords.y, coords.z)
      end)
    end
    Property.EditingTheme = false
  end

  -- If furniture editing object exists, restore controls menu overlay
  if Property.EditingFurnitureObj then
    SendNUIMessage({
      action = "ControlsMenu",
      toggle = true,
      controlsLabel = (furnitureMode == "gizmo") and "furniture:gizmo" or "furniture:walkmode",
      controlsName = (furnitureMode == "gizmo") and "Furniture:gizmo" or "Furniture:walkmode",
    })
  end

  SetNuiFocus(false, false)
end)

-- ---------------------------------------------------------------------------
-- Property manage actions (big switch)
-- NOTE: original used RegisterNuiCallback (typo/alias); keep compatibility.
-- ---------------------------------------------------------------------------
local function drawPlacementMarker(coords)
  if not coords or coords.x == nil or coords.y == nil or coords.z == nil then
    return
  end

  DrawMarker(
    2,
    coords.x, coords.y, coords.z + 0.15,
    0.0, 0.0, 0.0,
    0.0, 0.0, 0.0,
    0.25, 0.25, 0.25,
    159, 15, 255, 185,
    false,
    false,
    2,
    nil,
    nil,
    false
  )
end

local function startManagePointPlacement(propertyId, controlsLabel, serverEventName)
  -- Close manage menu + release focus before entering placement mode
  closeNUI(true)

  -- Show the same "ControlsMenu" overlay creator uses for point placement
  SendNUIMessage({
    action = "ControlsMenu",
    toggle = true,
    controlsLabel = controlsLabel,
    controlsName = "HousingCreator:default"
  })

  Citizen.CreateThread(function()
    local SELECT = Config.HousingCreatorControls.SELECT.controlIndex
    local CANCEL = Config.HousingCreatorControls.CANCEL.controlIndex

    while true do
      local _hit, coords = startRaycast()
      DisabledControls()
      drawPlacementMarker(coords)

      if IsControlJustPressed(0, SELECT) or IsDisabledControlJustPressed(0, SELECT) then
        if coords and coords.x then
          TriggerServerEvent(serverEventName, propertyId, { x = coords.x, y = coords.y, z = coords.z })
        end
        break
      end

      if IsControlJustPressed(0, CANCEL)
        or IsDisabledControlJustPressed(0, CANCEL)
        or IsControlJustPressed(0, 177)
        or IsDisabledControlJustPressed(0, 177)
        or IsControlJustPressed(0, 322)
        or IsDisabledControlJustPressed(0, 322)
      then
        break
      end

      Citizen.Wait(0)
    end

    SendNUIMessage({ action = "ControlsMenu", toggle = false })

    -- Return to manage menu after placement/cancel
    if propertyId then
      openManageMenu(propertyId)
    else
      openManageMenu()
    end
  end)
end

RegisterNuiCallbackCompat("propertyManage:action", function(data, _cb)
  if not data.action then
    return
  end

  local propertyId = MotelManageId or CurrentProperty or GetCurrentPropertyId()

  -- buy-key
  if data.action == "buy-key" then
    if not library.HasPermissions(propertyId, "keysManage") then return end
    if library.ActionLimiter() then return end
    -- [SERVER]
    TriggerServerEvent("vms_housing:sv:buyKey", propertyId)
    return
  end

  -- lock replacement
  if data.action == "lock-replacement" then
    if not library.HasPermissions(propertyId, "keysManage") then return end
    if library.ActionLimiter() then return end
    -- [SERVER]
    TriggerServerEvent("vms_housing:sv:lockReplacement", propertyId)
    return
  end

  -- take furniture to storage
  if data.action == "take-to-storage" then
    if not data.furnitureId then return end
    if not library.HasPermissions(propertyId, "furniture") then return end
    -- [SERVER]
    TriggerServerEvent("vms_housing:sv:takeFurnitureToStorage", propertyId, data.furnitureId)
    return
  end

  -- checkout furniture
  if data.action == "checkout-furniture" then
    if not (data.payment and data.model) then return end
    if not library.HasPermissions(propertyId, "furniture") then return end

    local prop = Properties[tostring(propertyId)]
    if prop and prop.furniture then
      local currentCount = #prop.furniture
      local limit = GetFurnitureLimit(prop.metadata.upgrades)
      if currentCount >= limit then
        CL.Notification(TRANSLATE("notify.property:reached_furniture_limit"), 6000, "error")
        return
      end
    end

    -- [SERVER]
    TriggerServerEvent("vms_housing:sv:checkoutFurniture", propertyId, data.payment, data.model)
    return
  end

  -- purchase upgrade
  if data.action == "purchase-upgrade" then
    if not data.name then return end
    if not library.HasPermissions(propertyId, "upgradesManage") then return end
    -- [SERVER]
    TriggerServerEvent("vms_housing:sv:upgrade", propertyId, data.name)
    return
  end

  -- marketplace remove/add
  if data.action == "marketplace-remove" then
    if not library.HasPermissions(propertyId, "marketplaceManage") then return end
    -- [SERVER]
    TriggerServerEvent("vms_housing:sv:marketplaceRemove", propertyId)
    return
  end

  if data.action == "marketplace-add" then
    if not library.HasPermissions(propertyId, "marketplaceManage") then return end
    if library.ActionLimiter() then return end
    -- [SERVER]
    TriggerServerEvent("vms_housing:sv:marketplaceAdd", propertyId, data)
    return
  end

  -- change wardrobe/storage positions (uses creator flow)
  if data.action == "change-wardrobe-position" then
    if not library.HasPermissions(propertyId, "furniture") then return end
    startManagePointPlacement(propertyId, "creator:wardrobe", "vms_housing:sv:changeWardrobePosition")
    return
  end

  if data.action == "change-storage-position" then
    if not library.HasPermissions(propertyId, "furniture") then return end
    startManagePointPlacement(propertyId, "creator:storage", "vms_housing:sv:changeStoragePosition")
    return
  end

  -- cameras
  if data.action == "check-cameras" then
    closeNUI(true)
    checkCameras(propertyId, function(found)
      if not found then
        CL.Notification(TRANSLATE("notify.cameras:no_cameras_installed"), 3000, "error")
        openManageMenu(propertyId)
      end
    end, data.environment)
    return
  end

  -- remove permission / key
  if data.action == "remove-permission" then
    if library.ActionLimiter() then return end
    -- [SERVER]
    TriggerServerEvent("vms_housing:sv:removePermission", propertyId, data.identifier)
    return
  end

  if data.action == "remove-key" then
    if not library.HasPermissions(propertyId, "keysManage") then return end
    -- [SERVER]
    TriggerServerEvent("vms_housing:sv:removeKey", propertyId, data.identifier)
    return
  end

  -- modal accepted sub-actions
  if data.action == "modal-accepted" then
    local modalType = data.type

    if modalType == "marketplace-sell" then
      if not library.HasPermissions(propertyId, "automaticSell") then return end
      -- [SERVER]
      TriggerServerEvent("vms_housing:sv:automaticSale", propertyId)
      return
    end

    if modalType == "pay-bill" then
      if not library.HasPermissions(propertyId, "billPayments") then return end
      -- [SERVER]
      TriggerServerEvent("vms_housing:sv:payTheBill", propertyId, data.period, data.billType)
      return
    end

    if modalType == "make-photo" then
      if not library.HasPermissions(propertyId, "marketplaceManage") then return end
      Property:MarketplacePhotoMode(propertyId, data.imageId)
      return
    end

    if modalType == "save-photo" then
      if not library.HasPermissions(propertyId, "marketplaceManage") then return end
      if not data.imageUrl or data.imageUrl == "" then return end
      -- [SERVER]
      TriggerServerEvent("vms_housing:sv:saveMarketplacePhoto", propertyId, data.imageId, data.imageUrl)
      return
    end

    if modalType == "remove-photo" then
      if not library.HasPermissions(propertyId, "marketplaceManage") then return end
      -- [SERVER]
      TriggerServerEvent("vms_housing:sv:saveMarketplacePhoto", propertyId, data.imageId, nil)
      return
    end

    if modalType == "rental-terminate-now" then
      if not library.HasPermissions(propertyId, "rentersManage") then return end
      -- [SERVER]
      TriggerServerEvent("vms_housing:sv:rentalTerminateNow", propertyId)
      return
    end

    if modalType == "rental-termination" then
      if not library.HasPermissions(propertyId, "rentersManage") then return end
      -- [SERVER]
      TriggerServerEvent("vms_housing:sv:setRentalTermination", propertyId)
      return
    end

    if modalType == "rental-cancel-termination" then
      if not library.HasPermissions(propertyId, "rentersManage") then return end
      -- [SERVER]
      TriggerServerEvent("vms_housing:sv:clearRentalTermination", propertyId)
      return
    end

    if modalType == "add-player-permission" then
      -- [SERVER]
      TriggerServerEvent("vms_housing:sv:addPermission", propertyId, data.id)
      return
    end

    if modalType == "save-permission" then
      -- [SERVER]
      TriggerServerEvent("vms_housing:sv:updatePermission", propertyId, data.identifier, {
        garage = data.garage,
        furniture = data.furniture,
        billPayments = data.billPayments,
        keysManage = data.keysManage,
        upgradesManage = data.upgradesManage,
        marketplaceManage = data.marketplaceManage,
        sell = data.sell,
        automaticSell = data.automaticSell,
        rent = data.rent,
        rentersManage = data.rentersManage,
      })
      return
    end

    if modalType == "sell-furniture" then
      if not data.furnitureId then return end
      if not library.HasPermissions(propertyId, "furniture") then return end
      -- [SERVER]
      TriggerServerEvent("vms_housing:sv:sellFurniture", propertyId, data.furnitureId, data.model)
      return
    end

    if modalType == "remove-furniture" then
      if not data.furnitureId then return end
      if not library.HasPermissions(propertyId, "furniture") then return end
      -- [SERVER]
      TriggerServerEvent("vms_housing:sv:removeFurniture", propertyId, data.furnitureId, data.model)
      return
    end

    if modalType == "give-key" then
      if not library.HasPermissions(propertyId, "keysManage") then return end
      -- [SERVER]
      TriggerServerEvent("vms_housing:sv:giveKey", propertyId, data.id)
      return
    end

    if modalType == "move-out" then
      -- [SERVER]
      TriggerServerEvent("vms_housing:sv:moveOut", propertyId)
      return
    end
  end
end)

-- ---------------------------------------------------------------------------
-- Marketplace: get property detail (only if sale/rental active)
-- ---------------------------------------------------------------------------
RegisterNuiCallbackCompat("marketplace:getProperty", function(data, cb)
  local property = Properties[tostring(data.id)]
  if not property then return end

  local saleActive = property.sale and property.sale.active == true
  local rentActive = property.rental and property.rental.active == true
  if not (saleActive or rentActive) then
    return
  end

  local result = {
    isOwner = (property.owner == Identifier),
    id = data.id,
    type = property.type,
    name = property.name,
    region = property.region,
    regionData = (Config.Regions[property.region] or Config.NoRegion),
    address = property.address,
    description = property.description,
    metadata = property.metadata,
    sale = property.sale,
    rental = property.rental,
  }

  if property.object_id then
    local parent = Properties[tostring(property.object_id)]
    if parent then
      result.building = { type = parent.type, name = parent.name }
    end
  end

  cb(result)
end)

RegisterNuiCallbackCompat("marketplace:markOnGps", function(data, _cb)
  local property = Properties[tostring(data.id)]
  if not property or not property.metadata then return end

  local function mark(x, y)
    SetNewWaypoint(x, y)
    CL.Notification(TRANSLATE("notify.marketplace:marked_on_gps"), 5000, "success")
  end

  if property.metadata.enter then
    mark(property.metadata.enter.x, property.metadata.enter.y)
    return
  end

  if property.metadata.menu then
    mark(property.metadata.menu.x, property.metadata.menu.y)
    return
  end

  if property.object_id then
    local parent = Properties[tostring(property.object_id)]
    if parent and parent.metadata and parent.metadata.enter then
      mark(parent.metadata.enter.x, parent.metadata.enter.y)
    end
  end
end)

RegisterNuiCallbackCompat("marketplace:showContract", function(data, _cb)
  local property = Properties[tostring(data.id)]
  if not property then return end

  isOfferByMarketplace = true
  marketplaceOfferId = tostring(data.id)

  local regionData = Config.Regions[property.region]
  regionData = regionData or Config.NoRegion

  local electricity = (regionData.electricity ~= nil) and regionData.electricity or Config.NoRegion.electricity
  local internet = (regionData.internet ~= nil) and regionData.internet or Config.NoRegion.internet
  local water = (regionData.water ~= nil) and regionData.water or Config.NoRegion.water

  local rentPrice = nil
  if property.rental and property.rental.active and property.rental.price then
    rentPrice = property.rental.price
  end

  local purchasePrice = nil
  if property.sale and property.sale.active and property.sale.price then
    purchasePrice = property.sale.price
  end

  -- [NUI]
  SendNUIMessage({
    action = "Property",
    actionName = "ViewOfferContract",
    data = {
      isByMarketplace = true,
      address = property.address,
      electricity = electricity,
      internet = internet,
      water = water,
      rentPrice = rentPrice,
      purchasePrice = purchasePrice,
    }
  })
end)

-- ---------------------------------------------------------------------------
-- Generic: closest players list (used in contracts/permissions UI)
-- ---------------------------------------------------------------------------
RegisterNUICallbackCompat("getClosestPlayers", function(_, _cb)
  if not openedMenu then
    return
  end

  local closest = CL.GetClosestPlayers()
  local serverIds = {}

  if closest and next(closest) then
    for _, playerId in pairs(closest) do
      if playerId ~= PlayerId() then
        serverIds[#serverIds + 1] = GetPlayerServerId(playerId)
      end
    end
  end

  -- [NUI]
  SendNUIMessage({
    action = "Property",
    actionName = "RefreshClosestPlayers",
    data = serverIds
  })
end)

-- ---------------------------------------------------------------------------
-- NUI requests a local notification
-- ---------------------------------------------------------------------------
RegisterNUICallbackCompat("sendNotification", function(data, _cb)
  CL.Notification(TRANSLATE(data.name), 5000, data.type)
end)
