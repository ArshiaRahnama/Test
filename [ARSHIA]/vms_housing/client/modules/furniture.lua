--[[-------------------------------------------------------------------------
  Furniture / Theme editor (deobfuscated)
  - Keeps original behavior intact
  - Renamed obfuscated locals to meaningful names
  - Added comments for NUI, server calls, async waits, and callbacks
---------------------------------------------------------------------------]]

local isCursorModeEnabled = false

-- NOTE: The original code sets this to false initially and later uses strings:
--       furnitureMode = "gizmo" or "normal"
furnitureMode = false

-- Toggle/force cursor mode (center cursor + enter/leave cursor mode)
local function toggleCursorMode(forceState)
  if forceState ~= nil then
    isCursorModeEnabled = forceState
  else
    isCursorModeEnabled = not isCursorModeEnabled
  end

  if isCursorModeEnabled then
    SetCursorLocation(0.5, 0.5)
    EnterCursorMode()
  else
    LeaveCursorMode()
  end
end

--[[-------------------------------------------------------------------------
  manageFurniture(isEditingExisting, model, furnitureId)

  isEditingExisting:
    - true  => find existing furniture entity by furnitureId and edit it
    - false => spawn the model and place it

  model:
    - furniture model string/key used by library.SpawnProp

  furnitureId:
    - id for the existing furniture piece (when editing)
---------------------------------------------------------------------------]]
local function manageFurniture(isEditingExisting, furnitureModel, furnitureId)
  local propertyId = CurrentProperty
  if not propertyId then
    propertyId = GetCurrentPropertyId()
  end

  local propertyData = CurrentPropertyData
  if not propertyData then
    propertyData = GetCurrentPropertyData()
  end

  local heightOffset = 0.0
  local isInside = false

  -- Determine if player is inside (special handling for MLO)
  if propertyData.type == "mlo" then
    isInside = IsInsideMLO()
  else
    if CurrentProperty then
      isInside = true
    end
  end

  -- [NUI] Enter furniture placement UI state
  SendNUIMessage({
    action = "Property",
    actionName = "FurniturePlace",
  })

  -- Ensure gameplay focus while placing
  SetNuiFocus(false, false)

  -- Clean up any previous edit object
  if Property.EditingFurnitureObj then
    DeleteEntity(Property.EditingFurnitureObj)
    Property.EditingFurnitureObj = nil
    Property.EditingFurnitureData = {}
  end

  -- Kept from original (unused in this snippet, but preserved for parity)
  local function getGameplayCameraDirection()
    local camRot = GetGameplayCamRot() * (math.pi / 180)
    return vector3(
      -math.sin(camRot.z),
      math.cos(camRot.z),
      math.sin(camRot.x)
    )
  end

  -- Load existing furniture entity to edit
  if isEditingExisting then
    for _, furniture in pairs(Property.LoadedFurnitures) do
      if furniture.furnitureId == furnitureId then
        Property.EditingFurnitureObj = furniture.entity
      end
    end

  -- Spawn a new prop to place
  elseif furnitureModel then
    Property.EditingFurnitureObj = library.SpawnProp(
      furnitureModel,
      GetEntityCoords(PlayerPedId()),
      false,
      nil,
      true
    )

    -- [ASYNC WAIT] Wait up to 5s for entity to exist
    local timeoutAt = GetGameTimer() + 5000
    local timedOut = false

    while true do
      if DoesEntityExist(Property.EditingFurnitureObj) then
        break
      end

      if GetGameTimer() > timeoutAt then
        timedOut = true
        break
      end

      Citizen.Wait(5)
    end

    if timedOut then
      return library.Debug("Unable to load object...")
    end
  end

  -- Prepare entity for editing/placement (no collision, frozen, invulnerable)
  PlaceObjectOnGroundProperly(Property.EditingFurnitureObj)

  SetEntityAsMissionEntity(Property.EditingFurnitureObj, true, true)
  SetEntityCollision(Property.EditingFurnitureObj, false, false)

  SetEntityNoCollisionEntity(PlayerPedId(), Property.EditingFurnitureObj, false)
  SetEntityNoCollisionEntity(Property.EditingFurnitureObj, PlayerPedId(), false)

  FreezeEntityPosition(Property.EditingFurnitureObj, true)
  SetEntityDynamic(Property.EditingFurnitureObj, false)

  SetEntityProofs(
    Property.EditingFurnitureObj,
    true, true, true, true, true, true, true, true
  )
  SetEntityCanBeDamaged(Property.EditingFurnitureObj, false)

  -- Placement mode starts in gizmo mode
  local lastModeSwitchAt = 0
  furnitureMode = "gizmo"

  -- Create placement camera and enable cursor mode
  HousingCreator:CreateCamera(true)
  toggleCursorMode()

  -- [NUI] Show controls overlay for current mode
  SendNUIMessage({
    action = "ControlsMenu",
    toggle = true,
    controlsLabel = (furnitureMode == "gizmo") and "furniture:gizmo" or "furniture:walkmode",
    controlsName  = (furnitureMode == "gizmo") and "Furniture:gizmo"  or "Furniture:walkmode",
  })

  -- Main placement loop
  while true do
    if not Property.EditingFurnitureObj then
      break
    end

    local ped = PlayerPedId()
    local pedCoords = GetEntityCoords(ped)

    HudForceWeaponWheel(false)
    HideHudComponentThisFrame(19)
    HideHudComponentThisFrame(20)

    local objCoords = GetEntityCoords(Property.EditingFurnitureObj)
    local objHeading = GetEntityHeading(Property.EditingFurnitureObj) -- kept for parity
    local objRotation = GetEntityRotation(Property.EditingFurnitureObj, 2) -- kept for parity

    -- Outline the currently edited object
    SetEntityDrawOutline(Property.EditingFurnitureObj, true)
    SetEntityDrawOutlineColor(159, 15, 255, 200)
    SetEntityDrawOutlineShader(1)

    DisabledControls()
    Wait(0)

    if furnitureMode == "gizmo" then
      -- Gizmo uses an entity matrix editor native
      local entityMatrix = makeEntityMatrix(Property.EditingFurnitureObj)

      -- Original pattern preserved: pass ReturnResultAnyway() varargs into InvokeNative
      local rr1, rr2, rr3, rr4, rr5, rr6, rr7, rr8 = Citizen.ReturnResultAnyway()
      local didMove = Citizen.InvokeNative(
        3945716898,
        entityMatrix:Buffer(entityMatrix),
        "Editor1",
        rr1, rr2, rr3, rr4, rr5, rr6, rr7, rr8
      )

      if didMove then
        applyEntityMatrix(Property.EditingFurnitureObj, entityMatrix)
      end

      -- Allow enabling/disabling cursor while in gizmo
      EnableControlAction(0, Config.FurnitureControls.ENABLE_CURSOR.controlIndex, true)
      if IsControlJustPressed(0, Config.FurnitureControls.ENABLE_CURSOR.controlIndex) then
        toggleCursorMode()
      end

      rotateCamInputs()
      moveCamInputs(true)

    else
      -- Normal mode: raycast to move object + manual height/rotation controls
      local hit, hitCoords = RayCastGamePlayCamera(nil, 150.0)
      if hit then
        DrawLine(
          pedCoords.x, pedCoords.y, pedCoords.z,
          hitCoords.x, hitCoords.y, hitCoords.z,
          159, 15, 255, 250
        )

        if Property.EditingFurnitureObj then
          SetEntityCoords(
            Property.EditingFurnitureObj,
            hitCoords.x, hitCoords.y, hitCoords.z + heightOffset
          )
        end
      end

      -- Height UP
      if IsControlPressed(0, Config.FurnitureControls.UP.controlIndex) then
        if IsControlReleased(0, Config.FurnitureControls.SPEED_DOWN.controlIndex) then
          heightOffset = heightOffset + Config.FurnitureSettings.HeightSpeed
        else
          heightOffset = heightOffset + Config.FurnitureSettings.HeightSpeedSlow
        end
      end

      -- Height DOWN
      if IsControlPressed(0, Config.FurnitureControls.DOWN.controlIndex) then
        if IsControlReleased(0, Config.FurnitureControls.SPEED_DOWN.controlIndex) then
          heightOffset = heightOffset - Config.FurnitureSettings.HeightSpeed
        else
          heightOffset = heightOffset - Config.FurnitureSettings.HeightSpeedSlow
        end
      end

      -- Manual rotation around Z
      local zRotation = 0 -- original behavior: starts at 0 for this session
      if IsControlPressed(0, Config.FurnitureControls.ROTATE_LEFT.controlIndex) then
        if IsControlReleased(0, Config.FurnitureControls.SPEED_DOWN.controlIndex) then
          zRotation = zRotation + Config.FurnitureSettings.RotateSpeed
        else
          zRotation = zRotation + Config.FurnitureSettings.RotateSpeedSlow
        end

        SetEntityRotation(Property.EditingFurnitureObj, 0, 0, zRotation, 1, true)
      end

      if IsControlPressed(0, Config.FurnitureControls.ROTATE_RIGHT.controlIndex) then
        if IsControlReleased(0, Config.FurnitureControls.SPEED_DOWN.controlIndex) then
          zRotation = zRotation - Config.FurnitureSettings.RotateSpeed
        else
          zRotation = zRotation - Config.FurnitureSettings.RotateSpeedSlow
        end

        SetEntityRotation(Property.EditingFurnitureObj, 0, 0, zRotation, 1, true)
      end
    end

    -- Change placement mode (cooldown 3 seconds)
    EnableControlAction(0, Config.FurnitureControls.CHANGE_MODE.controlIndex, true)
    if IsControlJustPressed(0, Config.FurnitureControls.CHANGE_MODE.controlIndex) then
      local now = GetGameTimer()
      if now >= (lastModeSwitchAt + 3000) then
        lastModeSwitchAt = now

        if furnitureMode == "gizmo" then
          furnitureMode = "normal"

          if isCursorModeEnabled then
            toggleCursorMode(false)
          end

          HousingCreator:DeleteCamera()
          FreezeEntityPosition(PlayerPedId(), false)
        else
          furnitureMode = "gizmo"
          toggleCursorMode(true)
          HousingCreator:CreateCamera(true)
        end

        -- [NUI] Update controls overlay when switching mode
        SendNUIMessage({
          action = "ControlsMenu",
          toggle = true,
          controlsLabel = (furnitureMode == "gizmo") and "furniture:gizmo" or "furniture:walkmode",
          controlsName  = (furnitureMode == "gizmo") and "Furniture:gizmo"  or "Furniture:walkmode",
        })
      else
        CL.Notification(
          TRANSLATE("notify.furniture:mode_cooldown"),
          4000,
          "error"
        )
      end
    end

    -- Snap to ground
    EnableControlAction(0, Config.FurnitureControls.SNAP_TO_GROUND.controlIndex, true)
    if IsControlJustPressed(0, Config.FurnitureControls.SNAP_TO_GROUND.controlIndex) then
      PlaceObjectOnGroundProperly_2(Property.EditingFurnitureObj)
    end

    -- If entity disappeared, stop editing
    if not DoesEntityExist(Property.EditingFurnitureObj) then
      Property.EditingFurniture = false
      DeleteObject(Property.EditingFurnitureObj)
      Property.EditingFurnitureObj = nil
    end

    -- CLOSE key: delete/remove furniture
    if IsControlJustPressed(0, Config.FurnitureControls.CLOSE.controlIndex) then
      Property.EditingFurniture = false
      DeleteObject(Property.EditingFurnitureObj)
      Property.EditingFurnitureObj = nil

      -- [ASYNC CALLBACK] Remove furniture then reload list
      Property:RemoveFurniture(nil, function()
        -- Reload furniture for inside/outside based on current state
        Property:LoadFurniture(
          (CurrentProperty and "inside" or "outside"),
          propertyData.furniture,
          CurrentProperty
        )

        -- For MLO, also load the opposite side list
        if propertyData.type == "mlo" then
          Property:LoadFurniture(
            (CurrentProperty and "outside" or "inside"),
            propertyData.furniture,
            CurrentProperty
          )
        end
      end)
    end

    -- ACCEPT key: validate placement + save (or open purchase UI)
    EnableControlAction(0, Config.FurnitureControls.ACCEPT.controlIndex, true)
    if IsControlJustPressed(0, Config.FurnitureControls.ACCEPT.controlIndex) then
      local placedCoords = GetEntityCoords(Property.EditingFurnitureObj)

      -- If outside, ensure within allowed polygon zone (when present)
      local isWithinOutsideZone = nil
      if propertyData.metadata.zone then
        isWithinOutsideZone = isPointInPolygon(placedCoords, propertyData.metadata.zone.points)
      end

      if isInside or (not isInside and isWithinOutsideZone) then
        local isPlacementAllowed = true

        -- MLO placement rules: indoor/outdoor restrictions + metadata flags
        if propertyData.type == "mlo" then
          local isInInterior = isPointInPolygon(
            placedCoords,
            propertyData.metadata.interiorZone.points
          )

          local isFurnitureIndoor  = (Furniture[furnitureModel].isIndoor == 1)
          local isFurnitureOutdoor = (Furniture[furnitureModel].isOutdoor == 1)

          local allowInside  = (propertyData.metadata and propertyData.metadata.allowFurnitureInside)  ~= false
          local allowOutside = (propertyData.metadata and propertyData.metadata.allowFurnitureOutside) ~= false

          if isInInterior then
            if not isFurnitureIndoor then
              isPlacementAllowed = false
              CL.Notification(TRANSLATE("notify.furniture:cannot_place_inside"), 4000, "error")
            elseif not allowInside then
              isPlacementAllowed = false
              CL.Notification(TRANSLATE("notify.furniture:inside_disabled"), 4000, "error")
            end
          else
            if not isFurnitureOutdoor then
              isPlacementAllowed = false
              CL.Notification(TRANSLATE("notify.furniture:cannot_place_outside"), 4000, "error")
            elseif not allowOutside then
              isPlacementAllowed = false
              CL.Notification(TRANSLATE("notify.furniture:outside_disabled"), 4000, "error")
            end

            -- Outdoor area requirement (original behavior)
            if propertyData.object_id then
              isPlacementAllowed = false
              CL.Notification(TRANSLATE("notify.furniture:no_outdoor_area"), 4000, "error")
            end
          end
        end

        if isPlacementAllowed then
          -- Build placement payload
          Property.EditingFurnitureData = {
            id = furnitureId,
            model = furnitureModel,
            coords = placedCoords,
            rotation = GetEntityRotation(Property.EditingFurnitureObj),
            isInside = isInside,
            isExisting = isEditingExisting,
          }

          if Config.RequirePurchaseFurniture or isEditingExisting then
            -- [SERVER EVENT] Save placement immediately
            TriggerServerEvent("vms_housing:sv:placeFurniture", propertyId, Property.EditingFurnitureData)

            Property.EditingFurniture = false
            DeleteObject(Property.EditingFurnitureObj)
            Property.EditingFurnitureObj = nil
            break
          else
            -- [NUI] Open purchase UI
            SendNUIMessage({
              action = "Property",
              actionName = "OpenFurniturePurchase",
              data = {
                label = Furniture[furnitureModel].label,
                price = Furniture[furnitureModel].price,
              }
            })

            openedMenu = "PropertyFurniturePurchase"
            SetNuiFocus(true, true)
          end
        end
      else
        CL.Notification(TRANSLATE("notify.furniture:outside_zone"), 4000, "error")
      end
    end
  end

  -- Cleanup after placement session ends
  if isCursorModeEnabled then
    toggleCursorMode(false)
  end

  HousingCreator:DeleteCamera()
  FreezeEntityPosition(PlayerPedId(), false)

  -- [NUI] Hide controls overlay
  SendNUIMessage({ action = "ControlsMenu", toggle = false })

  Property.EditingFurniture = false
  Property.EditingFurnitureData = {}

  -- Return to main furniture menu
  openFurnitureMenu()
end

  -- Preserve original globals
  _G.manageFurniture = manageFurniture
  _ENV.manageFurniture = manageFurniture

--[[-------------------------------------------------------------------------
  editFurniture()

  Enters a selection mode:
  - raycast to highlight an existing furniture entity
  - ACCEPT => open manageFurniture(true, model, furnitureId) for that entity
  - CLOSE  => exit selection mode
---------------------------------------------------------------------------]]
local function editFurniture()
  -- [ASYNC THREAD] runs while Property.EditingFurniture is true
  Citizen.CreateThread(function()
    local highlighted = {}        -- [entity] = furnitureData
    local lastEntity = nil

    while true do
      if not Property.EditingFurniture then
        break
      end

      local ped = PlayerPedId()
      local pedCoords = GetEntityCoords(ped)

      HudForceWeaponWheel(false)
      HideHudComponentThisFrame(19)
      HideHudComponentThisFrame(20)
      DisabledControls()

      local hit, hitCoords, hitEntity = RayCastGamePlayCamera(nil, 80.0)

      if hit then
        DrawLine(
          pedCoords.x, pedCoords.y, pedCoords.z,
          hitCoords.x, hitCoords.y, hitCoords.z,
          159, 15, 255, 250
        )

        if hitEntity then
          if lastEntity ~= hitEntity then
            -- remove outline from previous entity
            if lastEntity and highlighted[lastEntity] then
              SetEntityDrawOutline(lastEntity, false)
              highlighted[lastEntity] = nil
            end

            -- apply outline to newly targeted entity if it's one of our furnitures
            if not highlighted[hitEntity] then
              for _, furniture in pairs(Property.LoadedFurnitures) do
                if furniture.entity == hitEntity then
                  lastEntity = hitEntity
                  highlighted[hitEntity] = furniture

                  SetEntityDrawOutline(hitEntity, true)
                  SetEntityDrawOutlineColor(159, 15, 255, 200)
                  SetEntityDrawOutlineShader(0)
                end
              end
            end
          end

          -- ACCEPT => edit selected furniture
          if IsControlJustPressed(0, Config.FurnitureControls.ACCEPT.controlIndex) then
            -- clear outlines
            for entity in pairs(highlighted) do
              SetEntityDrawOutline(entity, false)
            end

            if highlighted[hitEntity] then
              manageFurniture(true, highlighted[hitEntity].model, highlighted[hitEntity].furnitureId)
            end

            Property.EditingFurniture = false
            break
          end
        end
      else
        -- No hit: clear any outlines
        if next(highlighted) then
          for entity in pairs(highlighted) do
            SetEntityDrawOutline(entity, false)
          end
          highlighted = {}
        end
      end

      -- CLOSE => exit selection mode
      if IsControlJustPressed(0, Config.FurnitureControls.CLOSE.controlIndex) then
        if next(highlighted) then
          for entity in pairs(highlighted) do
            SetEntityDrawOutline(entity, false)
          end
          highlighted = {}
        end

        Property.EditingFurniture = false
        break
      end

      Citizen.Wait(1)
    end
  end)
end

_G.editFurniture = editFurniture
_ENV.editFurniture = editFurniture

--[[-------------------------------------------------------------------------
  editTheme(themeIndex)

  Previews an IPL theme and then:
  - CLOSE  => revert to original theme
  - ACCEPT => open purchase UI
---------------------------------------------------------------------------]]
local function editTheme(themeIndex)
  Property.EditingTheme = themeIndex

  local propertyId = CurrentProperty
  if not propertyId then
    propertyId = GetCurrentPropertyId()
  end

  local propertyData = CurrentPropertyData
  if not propertyData then
    propertyData = GetCurrentPropertyData()
  end

  -- Only relevant if we are in an IPL property
  if CurrentIPL then
    local iplConfig = AvailableIPLS[propertyData.metadata.ipl]
    local themeConfig = iplConfig.settings.Themes[Property.EditingTheme]

    if themeConfig then
      -- Small teleport “refresh” callback, preserved (used twice in original)
      local function refreshPlayerCoords()
        local coords = GetEntityCoords(PlayerPedId())
        SetEntityCoords(PlayerPedId(), coords.x, coords.y, coords.z)
      end

      -- [ASYNC CALLBACK] Load preview theme
      IPL.LoadSettings(CurrentIPL, Property.EditingTheme, propertyData.metadata.iplSettings, refreshPlayerCoords)

      while true do
        if not Property.EditingTheme then
          break
        end

        -- CLOSE => revert to original theme
        if IsControlJustPressed(0, Config.FurnitureControls.CLOSE.controlIndex) then
          IPL.LoadSettings(CurrentIPL, propertyData.metadata.iplTheme, propertyData.metadata.iplSettings, refreshPlayerCoords)
          Property.EditingTheme = nil
        end

        -- ACCEPT => open purchase UI
        if IsControlJustPressed(0, Config.FurnitureControls.ACCEPT.controlIndex) then
          SendNUIMessage({
            action = "Property",
            actionName = "OpenFurniturePurchase",
            data = {
              label = themeConfig.label,
              price = themeConfig.price,
            }
          })
          SetNuiFocus(true, true)
          openedMenu = "PropertyFurniturePurchase"
        end

        Citizen.Wait(1)
      end
    end
  end

  Property.EditingTheme = nil
end

_G.editTheme = editTheme
_ENV.editTheme = editTheme

--[[-------------------------------------------------------------------------
  openFurnitureMenu()

  Opens the furniture UI with context:
  - inside/outside state
  - allowed placement flags
  - current IPL reference (when inside)
---------------------------------------------------------------------------]]
local function openFurnitureMenu()
  local propertyId = CurrentProperty
  if not propertyId then
    propertyId = GetCurrentPropertyId()
  end

  local propertyData = CurrentPropertyData
  if not propertyData then
    propertyData = GetCurrentPropertyData()
  end

  if waitingForLoadAfterRestart then
    return
  end

  if not propertyData then
    return
  end

  -- Don’t open while editing furniture/theme
  if Property.EditingFurniture or Property.EditingTheme then
    return
  end

  -- Permission check
  if not library.HasPermissions(propertyId, "furniture") then
    return
  end

  -- Determine inside/outside based on property type + loaded interior
  local isInside = false
  if propertyData.type == "shell" then
    if CurrentShell then isInside = true end
  elseif propertyData.type == "ipl" then
    if CurrentIPL then isInside = true end
  elseif propertyData.type == "mlo" then
    isInside = IsInsideMLO()
  end

  local isOutside = not isInside

  -- [NUI] Open furniture menu with placement rules
  SendNUIMessage({
    action = "Property",
    actionName = "OpenFurniture",
    data = {
      propertyFurniture = propertyData.furniture,
      ipl = (isInside and CurrentIPL) or propertyData.furniture, -- preserves original odd fallback behavior
      allowChangeThemePurchased = propertyData.metadata.allowChangeThemePurchased,
      isInside = isInside,
      isOutside = isOutside,
      allowedInside = propertyData.metadata.allowFurnitureInside,
      allowedOutside = propertyData.metadata.allowFurnitureOutside,
    }
  })

  SetNuiFocus(true, true)
  openedMenu = "PropertyFurniture"
end

_G.openFurnitureMenu = openFurnitureMenu
_ENV.openFurnitureMenu = openFurnitureMenu

-- Export stays the same
exports("OpenFurnitureMenu", openFurnitureMenu)

-- Close furniture menu
local function closeFurnitureMenu()
  SendNUIMessage({
    action = "Property",
    actionName = "CloseFurniture",
  })
  SetNuiFocus(false, false)
  openedMenu = nil
end

_G.closeFurnitureMenu = closeFurnitureMenu
_ENV.closeFurnitureMenu = closeFurnitureMenu

-- Optional command + key mapping from config
if Config.HousingFurniture.Command then
  RegisterCommand(Config.HousingFurniture.Command, function()
    openFurnitureMenu()
  end)

  if Config.HousingFurniture.Key then
    RegisterKeyMapping(
      Config.HousingFurniture.Command,
      Config.HousingFurniture.Description or "",
      "keyboard",
      Config.HousingFurniture.Key
    )
  end
end
