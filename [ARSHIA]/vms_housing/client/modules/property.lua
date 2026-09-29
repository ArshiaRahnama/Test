-- ============================================================================
--  Deobfuscated / Refactored Client Module: Property
--  Notes:
--   - Logic is preserved 1:1 with the obfuscated version.
--   - Server interactions are marked with:  -- [SERVER]
--   - Async callbacks are marked with:      -- [ASYNC]
--   - NUI messages/focus are marked with:   -- [NUI]
-- ============================================================================

local Property = {
  -- Furniture editing state
  EditingFurniture = false,
  EditingFurnitureObj = nil,
  EditingFurnitureData = {},

  -- IPL theme editing state
  EditingTheme = false,

  -- Spawned entities we manage
  LoadedFurnitures = {},       -- { { entity=entity, model=model, furnitureId=id, metadata=table }, ... }
  StaticInteractable = {},     -- { { type=string, coords=?, id=zoneId }, ... }

  -- Rate-limit for door lock toggles
  LastLockedDoors = nil,
}

-- Small helper used many times in the original
local function isInEditMode(self)
  return self.EditingFurniture or self.EditingTheme
end

local function notifyFurnitureModeBlocked()
  CL.Notification(TRANSLATE("notify.furniture:you_are_in_furniture_mode"), 5000, "info")
end

-- ============================================================================
--  View Offer UI
-- ============================================================================

function Property.ViewOffer(self, propertyId)
  -- These were present in the obfuscated code (unused afterwards), kept for parity.
  local isBuilding = false
  local isMotel = false

  local propertyData = GetCurrentPropertyData()
  if propertyId then
    if propertyData then
      if propertyData.type == "building" then
        isBuilding = true
      elseif propertyData.type == "motel" then
        isMotel = true
      end
    end

    -- If a specific propertyId is provided, it is looked up in Properties table.
    propertyData = Properties[tostring(propertyId)]
  else
    propertyId = GetCurrentPropertyId()
  end

  if not propertyData then
    return
  end

  -- Rooms list + IPL info (only for shell/ipl types)
  local rooms = nil
  local iplName = nil
  local allowChangeTheme = false

  if propertyData.type == "shell" then
    local shellDef = AvailableShells[propertyData.metadata.shell]
    if shellDef and shellDef.rooms then
      rooms = shellDef.rooms
    end
  elseif propertyData.type == "ipl" then
    local iplDef = AvailableIPLS[propertyData.metadata.ipl]
    if iplDef and iplDef.rooms then
      rooms = iplDef.rooms
    end

    iplName = propertyData.metadata.ipl
    allowChangeTheme = propertyData.metadata.allowChangeTheme
  end

  local hasGarage = propertyData.metadata and propertyData.metadata.garage ~= nil
  local parking = propertyData.metadata and propertyData.metadata.parking or nil

  -- Building parking spaces are stored on the building object (object_id property)
  local parkingSpaces = nil
  if propertyData.object_id then
    local buildingData = Properties[tostring(propertyData.object_id)]
    if buildingData and buildingData.metadata then
      parkingSpaces = buildingData.metadata.parkingSpaces
    end
  end

  -- Sale / rental prices (only when active and price present)
  local purchasePrice = nil
  if propertyData.sale and propertyData.sale.active and propertyData.sale.price then
    purchasePrice = propertyData.sale.price
  end

  local rentPrice = nil
  if propertyData.rental and propertyData.rental.active and propertyData.rental.price then
    rentPrice = propertyData.rental.price
  end

  -- Region-based utilities fallback
  local electricity = (Config.Regions[propertyData.region] and Config.Regions[propertyData.region].electricity)
    or Config.NoRegion.electricity

  local internet = (Config.Regions[propertyData.region] and Config.Regions[propertyData.region].internet)
    or Config.NoRegion.internet

  local water = (Config.Regions[propertyData.region] and Config.Regions[propertyData.region].water)
    or Config.NoRegion.water

  local area = nil
  if propertyData.metadata and propertyData.metadata.zone and propertyData.metadata.zone.area then
    area = propertyData.metadata.zone.area
  end

  -- [NUI] Open offer view
  SendNUIMessage({
    action = "Property",
    actionName = "OpenViewOffer",
    data = {
      id = propertyId,
      type = propertyData.type,
      address = propertyData.address,
      region = propertyData.region,
      name = propertyData.name,
      description = propertyData.description,

      purchasePrice = purchasePrice,
      rentPrice = rentPrice,

      electricity = electricity,
      internet = internet,
      water = water,

      area = area,
      rooms = rooms,

      garage = hasGarage,
      parking = parking,
      parkingSpaces = parkingSpaces,

      ipl = iplName,
      allowChangeTheme = allowChangeTheme,
    },
  })

  -- [NUI]
  SetNuiFocus(true, true)
  openedMenu = "PropertyOffer"
end

function Property.CloseOffer(self)
  -- [NUI] Close offer view
  SendNUIMessage({ action = "Property", actionName = "CloseViewOffer" })
  SetNuiFocus(false, false)

  openedMenu = nil
  marketplaceOfferId = nil
  isOfferByMarketplace = false
  SelectedApartment = nil
end

-- ============================================================================
--  Enter / Exit Property
-- ============================================================================

function Property.EnterProperty(self, propertyData, propertyIdOverride, onDone, bypassChecks)
  -- If not bypassing, block entering while editing furniture/theme (original behavior)
  if not bypassChecks and isInEditMode(self) then
    return
  end

  -- Client-side permission gating (original behavior)
  if not bypassChecks then
    if not CL.CanEnterHouse() then
      if onDone then onDone(false) end
      return
    end
  end

  -- [ASYNC] Server callback permission check
  library.Callback("vms_housing:canEnterHouse", function(canEnter)
    -- If not bypassing and server denies, abort
    if (not bypassChecks) and (not canEnter) then
      if onDone then onDone(false) end
      return
    end

    -- Prevent entering while already in another interior type
    if CurrentShell then
      if onDone then onDone(false) end
      return warn("You are already in shell!")
    end
    if CurrentIPL then
      if onDone then onDone(false) end
      return warn("You are already in IPL!")
    end

    -- Validate/load shell or IPL definitions before fading (original checks)
    if propertyData.type == "shell" then
      if not AvailableShells[propertyData.metadata.shell] then
        if onDone then onDone(false) end
        return warn(('Could not find shell "%s"!'):format(propertyData.metadata.shell))
      end

      local ok = library.RequestEntity(propertyData.metadata.shell)
      if not ok then
        if onDone then onDone(false) end
        return warn(('Failed to load shell "%s" - make sure it is running!'):format(propertyData.metadata.shell))
      end
    elseif propertyData.type == "ipl" then
      if not AvailableIPLS[propertyData.metadata.ipl] then
        if onDone then onDone(false) end
        return warn(('Could not find ipl "%s"!'):format(propertyData.metadata.ipl))
      end
    end

    -- Remove any previously spawned furniture before swapping interiors
    self:RemoveFurniture()

    if onDone then onDone(true) end

    DoScreenFadeOut(1500)
    Wait(750)

    if not bypassChecks then
      library.PlayAudio("enterHouse")
    end

    Wait(750)

    FreezeEntityPosition(PlayerPedId(), true)

    -- CurrentProperty is set to tostring(override) when override is provided (original behavior)
    local resolvedPropertyId
    if propertyIdOverride then
      resolvedPropertyId = tostring(propertyIdOverride)
    else
      resolvedPropertyId = GetCurrentPropertyId()
    end
    CurrentProperty = resolvedPropertyId

    -- CurrentPropertyData is pulled from Properties when override is provided (original behavior)
    local resolvedPropertyData
    if propertyIdOverride and Properties[tostring(propertyIdOverride)] then
      resolvedPropertyData = Properties[tostring(propertyIdOverride)]
    else
      resolvedPropertyData = GetCurrentPropertyData()
    end
    CurrentPropertyData = resolvedPropertyData

    -- Spawn/load the actual interior
    if propertyData.type == "shell" then
      CurrentShell = CreateObjectNoOffset(joaat(propertyData.metadata.shell), 0.0, 0.0, 500.0, false, false, false)

      while not DoesEntityExist(CurrentShell) do
        Wait(1)
      end

      SetEntityHeading(CurrentShell, 0.0)
      FreezeEntityPosition(CurrentShell, true)

      self:LoadStaticInteractable(AvailableShells[propertyData.metadata.shell])
    elseif propertyData.type == "ipl" then
      CurrentIPL = propertyData.metadata.ipl
      IPL.LoadSettings(CurrentIPL, propertyData.metadata.iplTheme, propertyData.metadata.iplSettings)

      self:LoadStaticInteractable(AvailableIPLS[propertyData.metadata.ipl])
    end

    -- [SERVER]
    TriggerServerEvent("vms_housing:sv:enterHouse", CurrentProperty)

    -- Optional weather toggling thread
    if ToggleWeather then
      Citizen.CreateThread(function()
        while CurrentShell or CurrentIPL do
          if CurrentShell or CurrentIPL then
            ToggleWeather(true, propertyData.type == "ipl")
          end
          Citizen.Wait(30000)
        end
      end)
    end

    Wait(1500)

    -- Restore light state if stored
    if CurrentPropertyData.metadata.lightState ~= nil then
      SetArtificialLightsState(not CurrentPropertyData.metadata.lightState)
    end

    DoScreenFadeIn(1500)

    -- Load furniture for inside environment (if provided)
    if propertyData and propertyData.furniture then
      self:LoadFurniture("inside", propertyData.furniture, CurrentProperty)
    end

    FreezeEntityPosition(PlayerPedId(), false)
  end)
end

function Property.ExitProperty(self, onDone, skipRefreshTargets, skipServerLeave, bypassAudio)
  DoScreenFadeOut(1500)
  Wait(750)

  if not bypassAudio then
    library.PlayAudio("exitHouse")
  end

  Wait(750)

  FreezeEntityPosition(PlayerPedId(), true)

  -- [SERVER]
  TriggerServerEvent("vms_housing:sv:exitHouse", CurrentProperty, skipRefreshTargets, skipServerLeave, bypassAudio)

  if ToggleWeather then
    ToggleWeather(false)
  end

  SetArtificialLightsState(false)

  if CurrentShell then
    DeleteObject(CurrentShell)
    CurrentShell = nil
  end

  if CurrentIPL then
    IPL.UnloadSettings(CurrentIPL)
    CurrentIPL = nil
  end

  self:RemoveFurniture()
  self:RemoveStaticInteractable()

  CurrentProperty = nil
  CurrentPropertyData = nil

  Wait(1500)

  RefreshTargets()

  FreezeEntityPosition(PlayerPedId(), false)

  DoScreenFadeIn(1500)

  if onDone then onDone(true) end
end

-- ============================================================================
--  Interior-only enter/exit (used for MLO / motel transitions)
-- ============================================================================

function Property.EnterPropertyInterior(self, _unusedPropertyData, propertyIdOverride, _unusedCb)
  local resolvedPropertyId
  if propertyIdOverride then
    resolvedPropertyId = tostring(propertyIdOverride)
  else
    resolvedPropertyId = GetCurrentPropertyId()
  end
  CurrentProperty = resolvedPropertyId

  local resolvedPropertyData
  if propertyIdOverride and Properties[tostring(propertyIdOverride)] then
    resolvedPropertyData = Properties[tostring(propertyIdOverride)]
  else
    resolvedPropertyData = GetCurrentPropertyData()
  end
  CurrentPropertyData = resolvedPropertyData

  if propertyIdOverride then
    self:LoadFurniture("inside", CurrentPropertyData.furniture, CurrentProperty)
  end

  RefreshTargets()
end

function Property.ExitPropertyInterior(self, _unusedCb)
  -- Original special-case: if currently in "mlo" but current property is motel, do not remove furniture
  if CurrentPropertyData and CurrentPropertyData.type == "mlo" then
    local cur = GetCurrentPropertyData()
    if cur and cur.type ~= "motel" then
      self:RemoveFurniture()
    end
  else
    self:RemoveFurniture()
  end

  CurrentProperty = nil
  CurrentPropertyData = nil
  RefreshTargets()
end

-- ============================================================================
--  Furniture spawning / removal
-- ============================================================================

function Property.LoadFurniture(self, environment, furnitureList, permissionContext)
  local spawnedDelivery = false

  for _, furnitureData in pairs(furnitureList) do
    -- Spawn placed furniture (stored == 0) for the requested environment
    if furnitureData.stored == 0 then
      if furnitureData.position and furnitureData.position.environment == environment then
        local entity = library.SpawnProp(
          furnitureData.model,
          vector3(furnitureData.position.x, furnitureData.position.y, furnitureData.position.z),
          false
        )

        while not DoesEntityExist(entity) do
          Citizen.Wait(5)
        end

        SetEntityCoordsNoOffset(entity, furnitureData.position.x, furnitureData.position.y, furnitureData.position.z)
        SetEntityRotation(entity, furnitureData.position.pitch, furnitureData.position.roll, furnitureData.position.yaw, 0, false)
        SetEntityAsMissionEntity(entity, true, true)
        FreezeEntityPosition(entity, true)

        -- Add target interaction if furniture has interactable metadata
        if next(furnitureData.metadata) and furnitureData.metadata.interactableName then
          local interactableName = furnitureData.metadata.interactableName

          -- Original special-case for "device" with RequirePurchaseFurniture
          if interactableName == "device" and Config.RequirePurchaseFurniture then
            -- (kept exactly as original gating: it falls through to "device" ~= check below)
          end

          if interactableName ~= "device" then
            local option = {
              interactableName = furnitureData.metadata.interactableName,
              name = ("furniture-%s"):format(furnitureData.id),
              label = TRANSLATE("target.interactable:" .. furnitureData.metadata.interactableName)
                or furnitureData.metadata.interactableName,
              action = function()
                -- NOTE: This closure intentionally references the loop variable (same semantics as obfuscated code).
                CL.InteractableFurniture(furnitureData.model, furnitureData.metadata.interactableName, furnitureData.id, furnitureData.metadata)
              end,
            }

            if Config.FurnitureInteractionAccess == 2 then
              option.canInteract = function()
                return library.HasAnyPermission(permissionContext)
              end
            elseif Config.FurnitureInteractionAccess == 3 then
              option.canInteract = function()
                return library.HasPermissions(permissionContext, "furniture")
              end
            end

            CL.Target("entity", {
              entity = entity,
              options = { option },
            })
          end
        end

        table.insert(self.LoadedFurnitures, {
          entity = entity,
          model = furnitureData.model,
          furnitureId = furnitureData.id,
          metadata = furnitureData.metadata,
        })
      end

    -- Delivery object spawn logic (RequirePurchaseFurniture + DeliveryType == 3)
    else
      if Config.RequirePurchaseFurniture and Config.DeliveryType == 3 and not spawnedDelivery then
        if furnitureData.stored == 1 and furnitureData.metadata and furnitureData.metadata.delivered then
          local cur = CurrentPropertyData or GetCurrentPropertyData()
          if cur and cur.metadata and cur.metadata.deliveryType and cur.metadata.deliveryType == environment and cur.metadata.delivery then
            spawnedDelivery = true

            local deliveryEntity = library.SpawnProp(
              Config.DeliveryObject,
              vector3(cur.metadata.delivery.x, cur.metadata.delivery.y, cur.metadata.delivery.z),
              false
            )

            while not DoesEntityExist(deliveryEntity) do
              Citizen.Wait(5)
            end

            SetEntityCoordsNoOffset(deliveryEntity, cur.metadata.delivery.x, cur.metadata.delivery.y, cur.metadata.delivery.z)
            SetEntityHeading(deliveryEntity, cur.metadata.delivery.w)
            SetEntityAsMissionEntity(deliveryEntity, true, true)
            FreezeEntityPosition(deliveryEntity, true)

            CL.Target("entity", {
              entity = deliveryEntity,
              options = {
                {
                  interactableName = "delivery",
                  name = "furniture-delivery",
                  label = TRANSLATE("target.interactable:delivery"),
                  action = function()
                    self:UnpackDelivery(deliveryEntity)
                  end,
                  canInteract = function()
                    return library.HasAnyPermission(permissionContext)
                  end,
                },
              },
            })

            table.insert(self.LoadedFurnitures, {
              entity = deliveryEntity,
              furnitureId = "delivery",
            })
          end
        end
      end
    end
  end

  -- Outside lockdown object (visual prop at door), only in certain cases
  if environment == "outside" and (Config.PropertyLockdown and Config.PropertyLockdown.Enable) then
    local propData = nil
    if permissionContext ~= nil then
      propData = Properties[tostring(permissionContext)]
    end
    propData = propData or GetCurrentPropertyData()

    if propData and propData.metadata and propData.metadata.lockdown then
      local isBuildingProperty = false
      if propData.object_id then
        local buildingData = Properties[tostring(propData.object_id)]
        if buildingData and buildingData.type == "building" then
          isBuildingProperty = true
        end
      end

      if not isBuildingProperty then
        -- "outsidePoint" = where the player interacts with the property from the outside
        local outsidePoint = nil
        if propData.metadata.enter and propData.metadata.enter.x and propData.metadata.enter.y and propData.metadata.enter.z then
          outsidePoint = propData.metadata.enter
        elseif propData.metadata.menu and propData.metadata.menu.x and propData.metadata.menu.y and propData.metadata.menu.z then
          outsidePoint = propData.metadata.menu
        else
          outsidePoint = propData.metadata.exit
        end

        if outsidePoint and outsidePoint.x and outsidePoint.y and outsidePoint.z then
          -- Door anchor (best-effort): for MLO properties use the closest configured door, otherwise fallback to outside point.
          local doorHeadingSource = nil
          local fallbackHeading = nil
          if propData.metadata.exit and propData.metadata.exit.w ~= nil then
            fallbackHeading = propData.metadata.exit.w
            doorHeadingSource = "exit"
          elseif outsidePoint.w ~= nil then
            fallbackHeading = outsidePoint.w
            doorHeadingSource = "outside"
          else
            fallbackHeading = 0.0
          end

          local doorPoint = {
            x = outsidePoint.x,
            y = outsidePoint.y,
            z = outsidePoint.z,
            w = fallbackHeading,
          }

          if propData.metadata.doors and type(propData.metadata.doors) == "table" then
            local outsideVec = vector3(outsidePoint.x, outsidePoint.y, outsidePoint.z)
            local nearestDoor = nil
            local nearestDist = nil

            for _, doorDef in pairs(propData.metadata.doors) do
              local center = nil
              if doorDef.type == "double" and doorDef.center then
                center = doorDef.center
              elseif doorDef.center then
                center = doorDef.center
              elseif doorDef.coords then
                center = doorDef.coords
              end

              if center and center.x and center.y and center.z then
                local dist = #(outsideVec - vector3(center.x, center.y, center.z))
                if (not nearestDist) or dist < nearestDist then
                  nearestDist = dist
                  nearestDoor = doorDef
                end
              end
            end

            if nearestDoor then
              local doorEntity = 0

              if nearestDoor.type == "double" then
                if nearestDoor.left and nearestDoor.left.coords and nearestDoor.left.model then
                  local c = nearestDoor.left.coords
                  doorEntity = GetClosestObjectOfType(c.x, c.y, c.z, 1.25, nearestDoor.left.model, false, false, false)
                end
                if (not doorEntity or doorEntity == 0) and nearestDoor.right and nearestDoor.right.coords and nearestDoor.right.model then
                  local c = nearestDoor.right.coords
                  doorEntity = GetClosestObjectOfType(c.x, c.y, c.z, 1.25, nearestDoor.right.model, false, false, false)
                end
              else
                if nearestDoor.coords and nearestDoor.model then
                  local c = nearestDoor.coords
                  doorEntity = GetClosestObjectOfType(c.x, c.y, c.z, 1.25, nearestDoor.model, false, false, false)
                end
              end

              if doorEntity and doorEntity ~= 0 and DoesEntityExist(doorEntity) then
                local c = GetEntityCoords(doorEntity)
                doorPoint.x, doorPoint.y, doorPoint.z = c.x, c.y, c.z
                doorPoint.w = GetEntityHeading(doorEntity)
                doorHeadingSource = "entity"
              else
                local c = nearestDoor.center or nearestDoor.coords
                if c and c.x and c.y and c.z then
                  doorPoint.x, doorPoint.y, doorPoint.z = c.x, c.y, c.z
                end
              end
            end
          end

          local dirX = outsidePoint.x - doorPoint.x
          local dirY = outsidePoint.y - doorPoint.y
          local len = math.sqrt((dirX * dirX) + (dirY * dirY))

          -- If the outside interaction point is basically on top of the door point (common for shells/IPLs),
          -- use the configured exit point as a better "outside direction" reference.
          if len < 0.001 and propData.metadata.exit and propData.metadata.exit.x and propData.metadata.exit.y and propData.metadata.exit.z then
            dirX = propData.metadata.exit.x - doorPoint.x
            dirY = propData.metadata.exit.y - doorPoint.y
            len = math.sqrt((dirX * dirX) + (dirY * dirY))
          end

          if len < 0.001 then
            local r = math.rad(doorPoint.w or 0.0)
            dirX = math.sin(r)
            dirY = math.cos(r)
            len = 1.0
          end

          dirX = dirX / len
          dirY = dirY / len

          local placement = Config.PropertyLockdown.Placement or {}
          local clearance = placement.Clearance or 0.25
          local rightDist = placement.RightOffset or placement.Right or 0.0
          local zExtra = placement.ZOffset or placement.Z or 0.0
          local headingExtra = placement.HeadingOffset or placement.Heading or 0.0

          local model = Config.PropertyLockdown.ObjectModel
          local modelHash = (type(model) == "number" and model) or tonumber(model) or GetHashKey(model)

          library.RequestEntity(modelHash)

          local minDim, maxDim = GetModelDimensions(modelHash)
          local centerX = (minDim.x + maxDim.x) / 2.0
          local centerY = (minDim.y + maxDim.y) / 2.0
          local sizeX = (maxDim.x - minDim.x)
          local sizeY = (maxDim.y - minDim.y)
          local depthUsesX = (sizeX < sizeY)
          local halfDepth = depthUsesX and (sizeX / 2.0) or (sizeY / 2.0)
          local autoHeadingOffset = depthUsesX and -90.0 or 0.0

          local forwardDist = placement.ForwardOffset
            or placement.Forward
            or (halfDepth + clearance)

          local rightX = dirY
          local rightY = -dirX

          local desiredX = doorPoint.x + (dirX * forwardDist) + (rightX * rightDist)
          local desiredY = doorPoint.y + (dirY * forwardDist) + (rightY * rightDist)

          local baseZ = doorPoint.z
          local ok, groundZ = GetGroundZFor_3dCoord(desiredX, desiredY, baseZ + 1.0, 0)
          if ok then
            baseZ = groundZ
          end

          local outsideHeading = GetHeadingFromVector_2d(dirX, dirY)

          local baseHeading = outsideHeading
          if (not depthUsesX) and doorHeadingSource ~= nil and doorPoint.w ~= nil then
            local tr = math.rad(doorPoint.w)
            local tx = math.sin(tr)
            local ty = math.cos(tr)
            local dot = (tx * dirX) + (ty * dirY)

            -- Only trust a stored heading if it's roughly pointing "out" (or "in") relative to the outside direction.
            -- This avoids cases where exit/menu heading was placed sideways.
            if math.abs(dot) >= 0.25 then
              baseHeading = doorPoint.w
              if dot < 0.0 then
                baseHeading = (baseHeading + 180.0) % 360.0
              end
            end
          end

          local barrierHeading = (baseHeading + autoHeadingOffset + headingExtra) % 360.0

          local hr = math.rad(barrierHeading)
          local cosH = math.cos(hr)
          local sinH = math.sin(hr)

          local rotatedCenterX = (cosH * centerX) + (sinH * centerY)
          local rotatedCenterY = (-sinH * centerX) + (cosH * centerY)

          local spawnX = desiredX - rotatedCenterX
          local spawnY = desiredY - rotatedCenterY
          local spawnZ = (baseZ - minDim.z) + zExtra

          local lockdownEntity = library.SpawnProp(
            modelHash,
            vector3(spawnX, spawnY, spawnZ),
            barrierHeading
          )

          while not DoesEntityExist(lockdownEntity) do
            Citizen.Wait(5)
          end

          SetEntityCoordsNoOffset(lockdownEntity, spawnX, spawnY, spawnZ)
          SetEntityHeading(lockdownEntity, barrierHeading)
          SetEntityAsMissionEntity(lockdownEntity, true, true)
          FreezeEntityPosition(lockdownEntity, true)

          table.insert(self.LoadedFurnitures, {
            entity = lockdownEntity,
            furnitureId = "lockdown",
          })
        end
      end
    end
  end
end

function Property.RemoveFurniture(self, furnitureId, onDone)
  if not next(self.LoadedFurnitures) then
    if onDone then onDone() end
    return
  end

  if furnitureId then
    for i, entry in ipairs(self.LoadedFurnitures) do
      if entry.furnitureId == furnitureId and entry.entity then
        CL.Target("remove-entity", entry.entity)
        DeleteObject(entry.entity)
        table.remove(self.LoadedFurnitures, i)
        break
      end
    end
  else
    for _, entry in ipairs(self.LoadedFurnitures) do
      if entry.entity then
        CL.Target("remove-entity", entry.entity)
        DeleteObject(entry.entity)
      end
    end
    self.LoadedFurnitures = {}
  end

  if onDone then onDone() end
end

-- ============================================================================
--  Lights / locks / deliveries
-- ============================================================================

function Property.ToggleLight()
  -- [SERVER]
  TriggerServerEvent("vms_housing:sv:toggleLight", CurrentProperty)
end

function Property.ToggleLock(self, propertyId, extra1, extra2)
  -- Rate-limit (same as obfuscated)
  if self.LastLockedDoors then
    if not self.LastLockedDoors or not (GetGameTimer() > self.LastLockedDoors) then
      CL.Notification(TRANSLATE("notify.doors:wait"), 3500, "info")
      return
    end
  end

  local resolvedId = propertyId
  if not resolvedId then
    resolvedId = GetCurrentPropertyId()
    if not resolvedId then
      resolvedId = CurrentProperty
    end
  end

  -- [SERVER]
  TriggerServerEvent("vms_housing:sv:toggleLock", resolvedId, extra1, extra2)

  self.LastLockedDoors = GetGameTimer() + 2000
end

function Property.UnpackDelivery(self, deliveryEntity)
  CL.Target("remove-entity", deliveryEntity)

  library.PlayAnimation(
    PlayerPedId(),
    "anim@scripted@ulp_missions@empty_crate@male@",
    "action",
    8.0,
    1.0,
    3800,
    1
  )

  Citizen.Wait(3650)

  local propertyId = CurrentProperty or GetCurrentPropertyId()

  -- [SERVER]
  TriggerServerEvent("vms_housing:sv:unpackDelivery", propertyId)
end

-- ============================================================================
--  Interior interactables (targets inside property)
-- ============================================================================

function Property.LoadInteriorInteractable(self, _unused, buildingData, _unused, permissionContext)
  -- Reset zones from TargetPoints
  if TargetPoints then
    for i = 1, #TargetPoints do
      if TargetPoints[i].type == "zone" then
        CL.Target("remove-zone", TargetPoints[i].id)
      end
    end
  end
  TargetPoints = {}

  -- Creator/preview shells can set CurrentShell without setting a property context.
  -- In that case, interior interactables should not load (and must not error).
  local propertyId = permissionContext or CurrentProperty
  if propertyId ~= nil then
    propertyId = tostring(propertyId)
  end
  if not CurrentProperty and propertyId then
    CurrentProperty = propertyId
  end
  if not CurrentPropertyData and propertyId then
    CurrentPropertyData = Properties[propertyId] or Properties[tostring(propertyId)]
  end
  if not CurrentPropertyData then
    return
  end
  if not CurrentProperty and CurrentPropertyData.id then
    CurrentProperty = tostring(CurrentPropertyData.id)
  end

  local doorZoneOptions = {}

  -- Manage (any permission)
  table.insert(doorZoneOptions, TargetHandler.Manage(nil, function()
    return library.HasAnyPermission(CurrentProperty) and not CurrentPropertyData.metadata.lockdown
  end))

  -- Furniture placement permissions
  if CurrentPropertyData.metadata.allowFurnitureInside then
    table.insert(doorZoneOptions, TargetHandler.Furniture(function()
      return library.HasPermissions(CurrentProperty, "furniture") and not CurrentPropertyData.metadata.lockdown
    end))
  end

  -- Wardrobe
  if CurrentPropertyData.metadata and CurrentPropertyData.metadata.wardrobe and CurrentPropertyData.metadata.wardrobe.x then
    table.insert(TargetPoints, TargetHandler.Wardrobe(
      CurrentProperty,
      CurrentPropertyData.metadata.wardrobe.x,
      CurrentPropertyData.metadata.wardrobe.y,
      CurrentPropertyData.metadata.wardrobe.z
    ))
  end

  -- Storage
  if CurrentPropertyData.metadata and CurrentPropertyData.metadata.storage and CurrentPropertyData.metadata.storage.x then
    table.insert(TargetPoints, TargetHandler.Storage(
      CurrentProperty,
      CurrentPropertyData.metadata.storage.x,
      CurrentPropertyData.metadata.storage.y,
      CurrentPropertyData.metadata.storage.z,
      CurrentPropertyData.metadata.storage.slots,
      CurrentPropertyData.metadata.storage.weight
    ))
  end

  -- Emergency inside exit zone
  if CurrentPropertyData.metadata and CurrentPropertyData.metadata.emergencyInside and CurrentPropertyData.metadata.emergencyInside.x then
    table.insert(TargetPoints, {
      type = "emergency_exit",
      id = CL.Target("zone", {
        coords = vector3(
          CurrentPropertyData.metadata.emergencyInside.x,
          CurrentPropertyData.metadata.emergencyInside.y,
          CurrentPropertyData.metadata.emergencyInside.z
        ),
        size = vec(1.5, 1.5, 2.0),
        rotation = 0.0,
        options = {
          {
            name = "property-emergency-exit",
            icon = "fa-solid fa-person-through-window",
            label = TRANSLATE("target.emergency_exit"),
            action = function()
              if isInEditMode(self) then
                notifyFurnitureModeBlocked()
                return
              end
              self:ExitProperty(nil, false, false, true)
            end,
          },
        },
      }),
    })
  end

  -- Peephole option
  table.insert(doorZoneOptions, {
    name = "property-door-peephole",
    icon = "fa-solid fa-video",
    label = TRANSLATE("target.door_peephole"),
    action = function()
      if isInEditMode(self) then
        notifyFurnitureModeBlocked()
        return
      end
      self:OpenDoorPeephole()
    end,
  })

  -- Toggle light option (with bills check)
  table.insert(doorZoneOptions, {
    name = "property-light",
    icon = "fa-solid fa-lightbulb",
    label = TRANSLATE("target.toggle_light"),
    action = function()
      if isInEditMode(self) then
        notifyFurnitureModeBlocked()
        return
      end

      if Config.UseServiceBills then
        if CurrentPropertyData.unpaidBills >= Config.AllowedUnpaidBills then
          CL.Notification(TRANSLATE("notify.property:no_electricity"), 4000, "info")
          return
        end
      end

      Property.ToggleLight()
    end,
  })

  -- Toggle lock option (handler)
  table.insert(doorZoneOptions, TargetHandler.ToggleLock(nil, function()
    return not CurrentPropertyData.metadata.lockdown
  end))

  -- Exit option (guarded by door lock + server callback)
  table.insert(doorZoneOptions, {
    name = "property-exit",
    icon = "fa-solid fa-door-open",
    label = TRANSLATE("target.exit"),
    action = function()
      if isInEditMode(self) then
        notifyFurnitureModeBlocked()
        return
      end

      if not CL.CanExitHouse() then
        return
      end

      -- [ASYNC] server callback check before exit
      library.Callback("vms_housing:canExitHouse", function(ok)
        if not ok then return end
        self:ExitProperty()
      end)
    end,
    canInteract = function()
      return not CurrentPropertyData.metadata.locked
    end,
  })

  -- Optional underground parking options (vms_garagesv2)
  if Config.Garages == "vms_garagesv2" and buildingData then
    if buildingData.metadata and buildingData.metadata.parkingEnter and buildingData.metadata.parkingSpaces then
      for idx, _space in pairs(buildingData.metadata.parkingSpaces) do
        table.insert(doorZoneOptions, {
          name = ("property-garage-%s"):format(idx),
          icon = "fa-solid fa-warehouse",
          label = TRANSLATE("target.enter_underground_parking", idx),
          action = function()
            if isInEditMode(self) then
              notifyFurnitureModeBlocked()
              return
            end
            if not CL.CanExitHouse() then
              return
            end

            -- [ASYNC] canExit -> exit -> enter parking
            library.Callback("vms_housing:canExitHouse", function(ok)
              if not ok then return end
              self:ExitProperty(function()
                exports.vms_garagesv2:enterApartmentParking(("vms_housing:parking:%s:%s"):format(buildingData.id, idx))
              end, false, true)
            end)
          end,
          canInteract = function()
            return not CurrentPropertyData.metadata.locked
          end,
        })
      end
    end
  end

  -- Create the door interaction zone depending on interior type
  if CurrentPropertyData.type == "shell" then
    table.insert(TargetPoints, {
      type = "zone",
      id = CL.Target("zone", {
        coords = vector3(
          AvailableShells[CurrentPropertyData.metadata.shell].doors.x,
          AvailableShells[CurrentPropertyData.metadata.shell].doors.y,
          AvailableShells[CurrentPropertyData.metadata.shell].doors.z + 1.5
        ),
        size = vec(1.5, 2.1, 2.0),
        rotation = AvailableShells[CurrentPropertyData.metadata.shell].doors.heading,
        options = doorZoneOptions,
      }),
    })
  elseif CurrentPropertyData.type == "ipl" then
    table.insert(TargetPoints, {
      type = "zone",
      id = CL.Target("zone", {
        coords = vector3(
          AvailableIPLS[CurrentPropertyData.metadata.ipl].doors.x,
          AvailableIPLS[CurrentPropertyData.metadata.ipl].doors.y,
          AvailableIPLS[CurrentPropertyData.metadata.ipl].doors.z + 1.5
        ),
        size = vec(1.5, 2.1, 2.0),
        rotation = AvailableIPLS[CurrentPropertyData.metadata.ipl].doors.heading,
        options = doorZoneOptions,
      }),
    })
  end
end

-- ============================================================================
--  Static interactables (from shell / IPL definitions)
-- ============================================================================

function Property.LoadStaticInteractable(self, interiorDef)
  if not interiorDef.interactable then
    return
  end

  for interactableId, interactableDef in pairs(interiorDef.interactable) do
    local options = {}

    for _, optionDef in pairs(interactableDef.options) do
      local opt = {
        name = optionDef.type,
        icon = optionDef.targetIcon,
        label = TRANSLATE("target.interactable:" .. optionDef.type),
        distance = 1.0,
        action = function()
          -- [ASYNC] Server callback to validate usage + handle bills/usage
          library.Callback("vms_housing:useStaticInteractable", function(ok)
            if not ok then return end
            CL.InteractableFurniture(nil, optionDef.type, nil, {
              data = interactableDef,
              option = optionDef,
            })
          end, CurrentProperty, interactableId, optionDef.timeUsage, optionDef.waterUsage, optionDef.billType)
        end,
      }

      if Config.StaticInteractionAccess == 2 then
        opt.canInteract = function()
          return library.HasAnyPermission(CurrentProperty)
        end
      elseif Config.StaticInteractionAccess == 3 then
        opt.canInteract = function()
          return library.HasPermissions(CurrentProperty, "furniture")
        end
      end

      table.insert(options, opt)
    end

    table.insert(self.StaticInteractable, {
      type = interactableDef.type,
      coords = interactableDef.coords,
      id = CL.Target("zone", {
        coords = interactableDef.target,
        rotation = interactableDef.target.w,
        size = interactableDef.targetSize,
        options = options,
      }),
    })
  end
end

function Property.RemoveStaticInteractable(self)
  if self.StaticInteractable and next(self.StaticInteractable) then
    for _, zoneData in pairs(self.StaticInteractable) do
      CL.Target("remove-zone", zoneData.id)
    end
  end
  self.StaticInteractable = {}
end

-- ============================================================================
--  Door registration + lock/unlock helpers
-- ============================================================================

function Property.RegisterDoors(self, doorsConfig)
  for doorIndex, doorDef in pairs(doorsConfig.doors) do
    if doorDef.type == "slide_gate" then
      doorDef.hash = joaat(("vms_housing_%s_%s"):format(doorsConfig.propertyId, doorIndex))
      AddDoorToSystem(doorDef.hash, doorDef.model, doorDef.coords.x, doorDef.coords.y, doorDef.coords.z, false, false, false)
      DoorSystemSetDoorState(doorDef.hash, 4, false, false)

      local state = (doorsConfig.forceLock or doorDef.locked == true) and 1 or 0
      DoorSystemSetDoorState(doorDef.hash, state, false, false)
      DoorSystemSetAutomaticRate(doorDef.hash, 5.0, false, false)

    elseif doorDef.type == "single" then
      doorDef.hash = joaat(("vms_housing_%s_%s"):format(doorsConfig.propertyId, doorIndex))
      AddDoorToSystem(doorDef.hash, doorDef.model, doorDef.coords.x, doorDef.coords.y, doorDef.coords.z, false, false, false)
      DoorSystemSetDoorState(doorDef.hash, 4, false, false)

      local state = (doorsConfig.forceLock or doorDef.locked == true) and 1 or 0
      DoorSystemSetDoorState(doorDef.hash, state, false, false)
      DoorSystemSetAutomaticRate(doorDef.hash, 10.0, false, false)

    elseif doorDef.type == "double" then
      if doorDef.left then
        doorDef.left.hash = joaat(("vms_housing_%s_%s_left"):format(doorsConfig.propertyId, doorIndex))
        AddDoorToSystem(doorDef.left.hash, doorDef.left.model, doorDef.left.coords.x, doorDef.left.coords.y, doorDef.left.coords.z, false, false, false)
        DoorSystemSetDoorState(doorDef.left.hash, 4, false, false)

        local state = (doorsConfig.forceLock or doorDef.locked == true) and 1 or 0
        DoorSystemSetDoorState(doorDef.left.hash, state, false, false)
        DoorSystemSetAutomaticRate(doorDef.left.hash, 10.0, false, false)
      end

      if doorDef.right then
        doorDef.right.hash = joaat(("vms_housing_%s_%s_right"):format(doorsConfig.propertyId, doorIndex))
        AddDoorToSystem(doorDef.right.hash, doorDef.right.model, doorDef.right.coords.x, doorDef.right.coords.y, doorDef.right.coords.z, false, false, false)
        DoorSystemSetDoorState(doorDef.right.hash, 4, false, false)

        local state = (doorsConfig.forceLock or doorDef.locked == true) and 1 or 0
        DoorSystemSetDoorState(doorDef.right.hash, state, false, false)
        DoorSystemSetAutomaticRate(doorDef.right.hash, 10.0, false, false)
      end
    end
  end
end

function Property.LockDoors(self, doors)
  if not doors then return end
  for _, doorDef in pairs(doors) do
    if doorDef.type == "double" then
      DoorSystemSetDoorState(doorDef.left.hash, 1, false, false)
      DoorSystemSetDoorState(doorDef.right.hash, 1, false, false)
    elseif doorDef.type == "slide_gate" or doorDef.type == "single" then
      DoorSystemSetDoorState(doorDef.hash, 1, false, false)
    end
  end
end

function Property.UnlockDoors(self, doors)
  if not doors then return end
  for _, doorDef in pairs(doors) do
    if doorDef.type == "double" then
      DoorSystemSetDoorState(doorDef.left.hash, 0, false, false)
      DoorSystemSetDoorState(doorDef.right.hash, 0, false, false)
    elseif doorDef.type == "slide_gate" or doorDef.type == "single" then
      DoorSystemSetDoorState(doorDef.hash, 0, false, false)
    end
  end
end

-- ============================================================================
--  Door targets (lockpick/raid/toggle door lock)
-- ============================================================================

function Property.LoadDoors(self, doors, propertyIdOverride, removeExistingDoorTargets, skipWorldSearch)
  -- Remove existing door targets (type == "door")
  if removeExistingDoorTargets then
    for i = #TargetPoints, 1, -1 do
      if TargetPoints[i].type == "door" then
        CL.Target("remove-entity", TargetPoints[i].entity)
        table.remove(TargetPoints, i)
      end
    end
  end

  -- Attach options to a specific door entity
  local function attachDoorTarget(doorEntity, doorIndex, interactionDistance)
    local propertyId = propertyIdOverride or GetCurrentPropertyId()

    local propertyData
    if propertyIdOverride and Properties[tostring(propertyIdOverride)] then
      propertyData = Properties[tostring(propertyIdOverride)]
    else
      propertyData = GetCurrentPropertyData()
    end

    local options = {}

    -- Optional direct toggle (only when not using keys-on-item)
    if not Config.UseKeysOnItem then
      table.insert(options, {
        interactableName = "door",
        name = ("door-left-%s"):format(doorIndex),
        label = TRANSLATE("target.toggle_lock_door"),
        distance = interactionDistance or 1.2,
        action = function()
          -- Rate-limit (same behavior)
          if self.LastLockedDoors then
            if not self.LastLockedDoors or not (GetGameTimer() > self.LastLockedDoors) then
              CL.Notification(TRANSLATE("notify.doors:wait"), 3500, "info")
              return
            end
          end

          -- [SERVER]
          TriggerServerEvent("vms_housing:sv:toggleDoorlock", propertyId, doorIndex, nil, false, false)
          self.LastLockedDoors = GetGameTimer() + 2000
        end,
        canInteract = function()
          return HasOwnership(propertyData)
        end,
      })
    end

    -- Lockpick handler
    table.insert(options, TargetHandler.Lockpick(
      propertyId,
      propertyData.metadata and propertyData.metadata.upgrades and propertyData.metadata.upgrades.antiBurglaryDoors,
      propertyData.metadata and propertyData.metadata.upgrades and propertyData.metadata.upgrades.alarm,
      function(minigameResult)
        -- [SERVER]
        TriggerServerEvent("vms_housing:sv:toggleDoorlock", propertyId, doorIndex, nil, true, false, minigameResult)
      end,
      function()
        local locked = propertyData.metadata.doors[doorIndex].locked
        if locked then
          return not propertyData.metadata.lockdown
        end
        return locked
      end
    ))

    -- Raid handler(s)
    local raidOption = TargetHandler.Raid(propertyId,
      function(success)
        if success then
          -- [SERVER]
          TriggerServerEvent("vms_housing:sv:toggleDoorlock", propertyId, doorIndex, nil, false, true)
        end
      end,
      function()
        local locked = propertyData.metadata.doors[doorIndex].locked
        if locked then
          return not propertyData.isUnderRaid
        end
        return locked
      end
    )
    if raidOption then
      table.insert(options, raidOption)
    end

    local raidLockOption = TargetHandler.RaidLock(
      function(success)
        if success then
          -- [SERVER]
          TriggerServerEvent("vms_housing:sv:toggleDoorlock", propertyId, doorIndex, nil, false, true)
        end
      end,
      function()
        return propertyData.isUnderRaid
      end
    )
    if raidLockOption then
      table.insert(options, raidLockOption)
    end

    -- Attach entity target
    CL.Target("entity", { entity = doorEntity, options = options })

    table.insert(TargetPoints, { type = "door", entity = doorEntity })
  end

  -- World search for door objects (unless caller requests to skip)
  if doors and not skipWorldSearch then
    for doorIndex, doorDef in pairs(doors) do
      if doorDef.type == "double" then
        local leftEntity = GetClosestObjectOfType(
          doorDef.left.coords.x, doorDef.left.coords.y, doorDef.left.coords.z,
          1.0, doorDef.left.model, false, false, false
        )
        local rightEntity = GetClosestObjectOfType(
          doorDef.right.coords.x, doorDef.right.coords.y, doorDef.right.coords.z,
          1.0, doorDef.right.model, false, false, false
        )

        if leftEntity and leftEntity ~= 0 then
          attachDoorTarget(leftEntity, doorIndex, doorDef.distance)
        end
        if rightEntity and rightEntity ~= 0 then
          attachDoorTarget(rightEntity, doorIndex, doorDef.distance)
        end

      elseif doorDef.type == "slide_gate" or doorDef.type == "single" then
        local radius = (doorDef.type == "slide_gate") and 15.0 or 1.0
        local entity = GetClosestObjectOfType(
          doorDef.coords.x, doorDef.coords.y, doorDef.coords.z,
          radius, doorDef.model, false, false, false
        )

        if entity and entity ~= 0 then
          attachDoorTarget(entity, doorIndex, doorDef.distance)
        end
      end
    end
  end
end

-- ============================================================================
--  Utility: apartments/buildings/motels
-- ============================================================================

function Property.IsHaveAnyApartment(self, buildingObjectId)
  local hasAny = false

  for _, prop in pairs(Properties) do
    if prop.object_id then
      if tostring(prop.object_id) == tostring(buildingObjectId) then
        if library.HasAnyPermission(prop.id) then
          hasAny = true
          break
        end
      end
    end
  end

  return hasAny
end

function Property.GetApartments(self, buildingData, shortList)
  local apartments = {}
  local buildingId = buildingData.id

  for _, prop in pairs(Properties) do
    if prop.object_id == buildingId then
      if shortList then
        table.insert(apartments, { id = prop.id, name = prop.name })
      else
        table.insert(apartments, prop)
      end
    end
  end

  return apartments, true
end

function Property.BuildingMenu(self, buildingData, apartments)
  -- [NUI]
  SendNUIMessage({
    action = "Property",
    actionName = "BuildingMenu",
    data = {
      buildingData = buildingData,
      apartments = apartments,
    },
  })

  SetNuiFocus(true, true)
  openedMenu = "BuildingMenu"
end

function Property.GetMotelRooms(self, motelData)
  local rooms = {}
  if not motelData or motelData.id == nil then
    return rooms
  end

  local motelId = motelData.id

  for _, prop in pairs(Properties) do
    if prop.object_id == motelId then
      table.insert(rooms, prop)
    end
  end

  return rooms
end

-- ============================================================================
--  Door peephole camera mode
-- ============================================================================

function Property.OpenDoorPeephole(self)
  DoScreenFadeOut(1500)
  Wait(1500)

  FreezeEntityPosition(PlayerPedId(), true)

  -- [SERVER] Exit house but keep in special peephole mode (original uses true param)
  TriggerServerEvent("vms_housing:sv:exitHouse", CurrentProperty, true)

  if ToggleWeather then
    ToggleWeather(false)
  end

  if CurrentShell then
    DeleteObject(CurrentShell)
    CurrentShell = nil
  end

  if CurrentIPL then
    IPL.UnloadSettings(CurrentIPL)
    CurrentIPL = nil
  end

  self:RemoveFurniture(nil, function() end)

  -- [NUI] Show peephole controls
  SendNUIMessage({
    action = "ControlsMenu",
    toggle = true,
    controlsLabel = "property:peephole",
    controlsName = "Property:peephole",
  })

  local hasSmartPeephole = false
  if CurrentPropertyData.metadata and CurrentPropertyData.metadata.upgrades and CurrentPropertyData.metadata.upgrades.smartPeephole then
    hasSmartPeephole = true
  end

  if hasSmartPeephole then
    ClearFocus()
    SetTimecycleModifier("CAMERA_secuirity")
    SetTimecycleModifierStrength(0.8)
  else
    -- [NUI]
    SendNUIMessage({ action = "Property", actionName = "OpenDoorPeephole" })
  end

  Wait(1500)
  DoScreenFadeIn(1500)

  SetEntityVisible(PlayerPedId(), false, 0)

  -- Camera positioning math (original kept)
  local behindDist = 0.2
  local heightOffset = 1.56

  -- If this is an apartment inside a building, use building exit heading for camera calculations
  local buildingData = nil
  if CurrentPropertyData.object_id then
    local maybe = Properties[tostring(CurrentPropertyData.object_id)]
    if maybe and maybe.type == "building" then
      buildingData = maybe
    end
  end

  local headingRad
  if buildingData then
    headingRad = math.rad(buildingData.metadata.exit.w + 90.0)
  else
    headingRad = math.rad(CurrentPropertyData.metadata.exit.w + 90.0)
  end

  local exitX = (buildingData and buildingData.metadata.exit.x or CurrentPropertyData.metadata.exit.x) - (math.cos(headingRad) * behindDist)
  local exitY = (buildingData and buildingData.metadata.exit.y or CurrentPropertyData.metadata.exit.y) - (math.sin(headingRad) * behindDist)
  local exitZ = (buildingData and buildingData.metadata.exit.z or CurrentPropertyData.metadata.exit.z) + heightOffset

  local lookX = (buildingData and buildingData.metadata.exit.x or CurrentPropertyData.metadata.exit.x) + (math.cos(headingRad) * 2.0)
  local lookY = (buildingData and buildingData.metadata.exit.y or CurrentPropertyData.metadata.exit.y) + (math.sin(headingRad) * 2.0)
  local lookZ = (buildingData and buildingData.metadata.exit.z or CurrentPropertyData.metadata.exit.z) + heightOffset

  local cam = CreateCam("DEFAULT_SCRIPTED_CAMERA", true)
  SetCamCoord(cam, exitX, exitY, exitZ)
  PointCamAtCoord(cam, lookX, lookY, lookZ)

  SetCamFov(cam, hasSmartPeephole and 110.0 or 160.0)

  SetCamActive(cam, true)
  RenderScriptCams(true, true, 1, true, true)

  -- Wait for BACK (194) to exit peephole camera
  while true do
    DisableAllControlActions(0)
    EnableControlAction(0, 194, true)

    if IsControlJustPressed(0, 194) then
      break
    end

    Citizen.Wait(1)
  end

  -- [NUI] Hide controls
  SendNUIMessage({ action = "ControlsMenu", toggle = false })

  -- Re-enter the property silently; on success, cleanup camera and restore visuals
  self:EnterProperty(CurrentPropertyData, CurrentProperty, function(entered)
    if not entered then return end

    Citizen.CreateThread(function()
      Citizen.Wait(2500)

      SetEntityVisible(PlayerPedId(), true, 0)

      RenderScriptCams(false, true, 500, true, true)
      DestroyCam(cam, false)

      ClearFocus()
      ClearTimecycleModifier()
      ClearExtraTimecycleModifier()

      -- [NUI] Close peephole UI (if used)
      SendNUIMessage({ action = "Property", actionName = "CloseDoorPeephole" })
    end)
  end, true)
end

-- ============================================================================
--  Raid
-- ============================================================================

function Property.Raid(self, propertyId)
  -- [ASYNC] Await server permission + reason code
  local allowed, reason = library.CallbackAwait("vms_housing:isAllowedToRaid", propertyId or GetCurrentPropertyId())
  if not allowed then
    CL.Notification(TRANSLATE("notify.raid:" .. reason), 5500, "error")
    return
  end

  local ped = PlayerPedId()
  local propData = GetCurrentPropertyData()

  library.PlayAnimation(ped, "missheistfbi3b_ig7", "lift_fibagent_loop", 8.0, 8.0, -1, 1)

  CL.Minigame("police_raid", function(success)
    library.StopAnimation(ped)
    if success then
      -- [SERVER]
      TriggerServerEvent("vms_housing:sv:raidProperty", propertyId or GetCurrentPropertyId())
    end
  end, {
    antiBurglaryDoors = propData.metadata and propData.metadata.upgrades and propData.metadata.upgrades.antiBurglaryDoors,
  })
end

-- ============================================================================
--  Marketplace Photo Mode
-- ============================================================================

function Property.MarketplacePhotoMode(self, propertyId, offerId)
  if not MARKETPLACE_PHOTOS_WEBHOOK then
    return library.Debug("Nie możesz korzystać z tej opcji. Nie ma skonfigurowanego webhooka.", "warn")
  end

  local running = true
  local photoModeEnabled = false
  local busyTakingShot = false

  closeManageMenu()

  local function togglePhotoMode()
    photoModeEnabled = not photoModeEnabled

    if photoModeEnabled then
      CreateMobilePhone(0)
      CellCamActivate(true, true)

      -- [NUI]
      SendNUIMessage({
        action = "ControlsMenu",
        toggle = true,
        controlsLabel = "property:photomode",
        controlsName = "Property:photomode_on",
      })

      CL.Notification(TRANSLATE("notify.property:marketplace_photomode_on"), 4000, "info")
    else
      DestroyMobilePhone()
      CellCamActivate(false, false)

      -- [NUI]
      SendNUIMessage({
        action = "ControlsMenu",
        toggle = true,
        controlsLabel = "property:photomode",
        controlsName = "Property:photomode_off",
      })

      CL.Notification(TRANSLATE("notify.property:marketplace_photomode_off"), 4000, "info")
    end
  end

  CL.Hud:Disable()

  -- [NUI]
  SendNUIMessage({
    action = "ControlsMenu",
    toggle = true,
    controlsLabel = "property:photomode",
    controlsName = "Property:photomode_off",
  })

  while running do
    DisabledControls()

    if not busyTakingShot then
      -- ENTER (191) => take screenshot (only when photomode enabled)
      if photoModeEnabled and IsControlJustPressed(0, 191) then
        busyTakingShot = true

        -- [NUI]
        SendNUIMessage({ action = "ControlsMenu", toggle = false })

        Citizen.Wait(100)

        -- [ASYNC] Upload screenshot
        exports["screenshot-basic"]:requestScreenshotUpload("", "files[]", function(resp)
          local decoded = json.decode(resp)

          if decoded and decoded.attachments and decoded.attachments[1] and decoded.attachments[1].url then
            -- [SERVER]
            TriggerServerEvent("vms_housing:sv:saveMarketplacePhoto", propertyId, offerId, decoded.attachments[1].url)
            running = false
          else
            busyTakingShot = false
          end
        end)
      end

      -- E (38) => toggle photomode
      if IsControlJustPressed(0, 38) then
        togglePhotoMode()
      end

      -- BACKSPACE / ESC (202) => exit photomode flow
      if IsControlJustPressed(0, 202) then
        running = false
      end
    end

    Citizen.Wait(1)
  end

  DestroyMobilePhone()
  CellCamActivate(false, false)

  CL.Hud:Enable()

  -- [NUI]
  SendNUIMessage({ action = "ControlsMenu", toggle = false })
end

-- ============================================================================
--  Export(s)
-- ============================================================================

_G.Property = Property
exports("IsHaveAnyApartment", function(buildingObjectId)
  return Property:IsHaveAnyApartment(buildingObjectId)
end)
