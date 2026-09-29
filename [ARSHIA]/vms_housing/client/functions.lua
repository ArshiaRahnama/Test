--[[--------------------------------------------------------------------------
  Ownership helpers
----------------------------------------------------------------------------]]

---Returns true if the player is owner, renter, or has keys for this property.
---@param property table
---@return boolean
function HasOwnership(property)
  if not property then
    return false
  end

  return IsOwner(property)
    or IsRenter(property)
    or library.HasKeys(property.id)
end

---@param property table
---@return boolean
function IsOwner(property)
  if not property or not Identifier then
    return false
  end

  return property.owner ~= nil and tostring(property.owner) == tostring(Identifier)
end

---@param property table
---@return boolean
function IsRenter(property)
  if not property or not Identifier then
    return false
  end

  return property.renter ~= nil and tostring(property.renter) == tostring(Identifier)
end

--[[--------------------------------------------------------------------------
  Furniture limit (supports upgrade-based limit when configured)
----------------------------------------------------------------------------]]

---Gets max furniture limit for a property based on configured upgrade metadata.
---Falls back to Config.FurnitureLimit when upgrades are missing.
---@param upgradesOrMetadata table  -- the table that holds the upgrade metadata key
---@return number|nil
function GetFurnitureLimit(upgradesOrMetadata)
  local upgradeCfg = Config.HousingUpgrades and Config.HousingUpgrades.furniture_limit
  if not upgradeCfg then
    return Config.FurnitureLimit
  end

  -- Which metadata key holds the "furniture limit level"
  local metadataKey = upgradeCfg.metadata
  local level = upgradesOrMetadata[metadataKey]
  if not level then
    return Config.FurnitureLimit
  end

  -- Defensive checks (kept equivalent to original)
  local levels = Config.HousingUpgrades
    and Config.HousingUpgrades.furniture_limit
    and Config.HousingUpgrades.furniture_limit.levels

  if levels and levels[level] then
    return levels[level].limit
  end

  -- Original code returns nil if the level is not found
  return nil
end

--[[--------------------------------------------------------------------------
  Blips
----------------------------------------------------------------------------]]

---Removes all currently created blips and rebuilds them based on Properties state.
---Blip style depends on property type + whether player owns/rents/has keys/etc.
function RefreshBlips()
  -- Clear previous blips
  for i = 1, #Blips do
    RemoveBlip(Blips[i])
    Blips[i] = nil
  end

  for propertyId, propertyData in pairs(Properties) do
    local blipStyle = nil

    -- Decide which blip template to use
    if propertyData.type == "building" then
      blipStyle = Config.Blips.Building
    elseif propertyData.type == "motel" then
      blipStyle = Config.Blips.Motel
    elseif propertyData.owner == Identifier then
      blipStyle = Config.Blips.HouseOwner
    elseif propertyData.renter == Identifier then
      blipStyle = Config.Blips.HouseRenter
    elseif library.HasKeys(propertyId) then
      blipStyle = Config.Blips.HouseKeyHolder
    else
      -- For sale / no owner / no renter
      if not propertyData.owner and not propertyData.renter then
        blipStyle = Config.Blips.HouseForSale
      end
    end

    if blipStyle and propertyData.metadata then
      -- Motel uses zone center as blip coords
      if propertyData.type == "motel" then
        local zone = propertyData.metadata.zone
        local center = getZoneCenter(zone.points, zone.minZ, zone.maxZ)

        table.insert(Blips, library.CreateBlip({
          coords = vector3(center.x, center.y, center.z),
          sprite = blipStyle.sprite,
          display = blipStyle.display,
          scale = blipStyle.scale,
          color = blipStyle.color,
          name = blipStyle.name,
          blipCategory = propertyData.blipCategory,
        }))

      else
        -- Prefer "menu" coords, fallback to "enter"
        if propertyData.metadata.menu then
          if not propertyData.object_id then
            table.insert(Blips, library.CreateBlip({
              coords = vector3(
                propertyData.metadata.menu.x,
                propertyData.metadata.menu.y,
                propertyData.metadata.menu.z
              ),
              sprite = blipStyle.sprite,
              display = blipStyle.display,
              scale = blipStyle.scale,
              color = blipStyle.color,
              name = blipStyle.name,
              blipCategory = propertyData.blipCategory,
            }))
          end

        elseif propertyData.metadata.enter then
          if not propertyData.object_id then
            table.insert(Blips, library.CreateBlip({
              coords = vector3(
                propertyData.metadata.enter.x,
                propertyData.metadata.enter.y,
                propertyData.metadata.enter.z
              ),
              sprite = blipStyle.sprite,
              display = blipStyle.display,
              scale = blipStyle.scale,
              color = blipStyle.color,
              name = blipStyle.name,
              blipCategory = propertyData.blipCategory,
            }))
          end
        end
      end
    end
  end
end

--[[--------------------------------------------------------------------------
  Targets
----------------------------------------------------------------------------]]

local function clearTargetPoints()
  for i = 1, #TargetPoints do
    local tp = TargetPoints[i]

    -- Original behavior: entity/door uses remove-entity, everything else remove-zone
    if tp.type == "entity" or tp.type == "door" then
      CL.Target("remove-entity", tp.entity)
    else
      CL.Target("remove-zone", tp.id)
    end
  end

  TargetPoints = {}
end

---Rebuilds interaction targets depending on:
---- property type (building/motel/house/mlo)
---- whether player has permissions / keys
---- whether player is inside an interior (shell / IPL / MLO)
function RefreshTargets()
  local currentZonePropertyId = GetCurrentPropertyId()
  local currentZonePropertyData = GetCurrentPropertyData()

  -- If player is in a property zone (outside)
  if currentZonePropertyData then
    clearTargetPoints()

    --[[----------------------------
      BUILDING TARGETS
    ------------------------------]]
    if currentZonePropertyData.type == "building" then
      local apartments = Property:GetApartments(currentZonePropertyData, true)

      -- Building "view house" target
      table.insert(TargetPoints, {
        type = "zone",
        id = CL.Target("zone", {
          coords = currentZonePropertyData.metadata.enter,
          size = vec(1.0, 1.5, 2.0),
          rotation = currentZonePropertyData.metadata.exit.w,
          options = {
            {
              name = "property-offer",
              icon = "fa-solid fa-scroll",
              label = TRANSLATE("target.view_house"),
              action = function()
                Property:BuildingMenu(currentZonePropertyData, apartments)
              end,
            },
          },
        }),
      })

      -- Optional underground parking integration (vms_garagesv2)
      if Config.Garages == "vms_garagesv2"
        and currentZonePropertyData.metadata.parkingEnter
        and currentZonePropertyData.metadata.parkingSpaces
      then
        local parkingOptions = {}

        for spaceIndex, _ in pairs(currentZonePropertyData.metadata.parkingSpaces) do
          table.insert(parkingOptions, {
            name = ("property-garage-%s"):format(spaceIndex),
            icon = "fa-solid fa-warehouse",
            label = TRANSLATE("target.enter_underground_parking", spaceIndex),
            distance = 3.0,

            -- [ASYNC/SERVER-BOUND EXPORT] enters apartment parking instance
            action = function()
              exports.vms_garagesv2:enterApartmentParking(
                ("vms_housing:parking:%s:%s"):format(currentZonePropertyId, spaceIndex)
              )
            end,

            canInteract = function()
              return Property:IsHaveAnyApartment(tostring(currentZonePropertyId))
            end,
          })
        end

        table.insert(TargetPoints, {
          type = "zone",
          id = CL.Target("zone", {
            coords = vector3(
              currentZonePropertyData.metadata.parkingEnter.x,
              currentZonePropertyData.metadata.parkingEnter.y,
              currentZonePropertyData.metadata.parkingEnter.z
            ),
            size = vec(2.0, 2.0, 2.0),
            rotation = currentZonePropertyData.metadata.parkingEnter.w,
            options = parkingOptions,
          }),
        })
      end

    --[[----------------------------
      MOTEL TARGETS
    ------------------------------]]
    elseif currentZonePropertyData.type == "motel" then
      local rooms = Property:GetMotelRooms(currentZonePropertyData)

      for _, room in pairs(rooms) do
        local roomIdStr = tostring(room.id)
        local options = {}

        -- Player has some connection to the room (owner/renter)
        if room.owner or room.renter then
          -- Manage
          table.insert(options, TargetHandler.Manage(roomIdStr, function()
            return library.HasAnyPermission(roomIdStr) and not room.metadata.lockdown
          end))

          -- Furniture (MLO only, requires permission + allowFurnitureInside)
          if room.type == "mlo" and room.metadata.allowFurnitureInside then
            table.insert(options, TargetHandler.Furniture(function()
              return library.HasPermissions(roomIdStr, "furniture") and not room.metadata.lockdown
            end))
          end

          -- Toggle lock (only if keys are NOT item-based, and not MLO)
          if (not Config.UseKeysOnItem) and room.type ~= "mlo" then
            table.insert(options, TargetHandler.ToggleLock(roomIdStr, function()
              return (not room.metadata.lockdown) and library.HasKeys(roomIdStr)
            end))
          end

          -- Non-MLO: doorbell, enter, lockpick, raids
          if room.type ~= "mlo" then
            table.insert(options, TargetHandler.Doorbell(roomIdStr))

            table.insert(options, TargetHandler.Enter(
              function()
                Property:EnterProperty(room, roomIdStr)
              end,
              function()
                return (not room.metadata.lockdown) and (not room.metadata.locked)
              end
            ))

            -- Lockpick (server event)
            if Config.Lockpick and Config.Lockpick.Enable then
              local antiBurglaryDoors = room.metadata and room.metadata.upgrades and room.metadata.upgrades.antiBurglaryDoors
              local alarmUpgrade = room.metadata and room.metadata.upgrades and room.metadata.upgrades.alarm

              table.insert(options, TargetHandler.Lockpick(
                roomIdStr,
                antiBurglaryDoors,
                alarmUpgrade,
                function(result)
                  -- [SERVER CALL]
                  TriggerServerEvent("vms_housing:sv:lockpickDoors", roomIdStr, result)
                end,
                function()
                  local can = room.metadata.locked
                  if can then
                    can = room.metadata.lockdown
                    can = not can
                  end
                  return can
                end
              ))
            end
          end

          -- MLO rooms: load door entities/targets
          if room.type == "mlo" then
            Property:LoadDoors(room.metadata.doors, roomIdStr)
          end

        -- No owner/renter: can view offers + load doors read-only
        else
          local hasOffer =
            (room.sale and room.sale.active) or
            (room.rental and room.rental.active)

          if hasOffer then
            table.insert(options, TargetHandler.ViewOffer(roomIdStr))
          end

          -- Load doors in "preview" mode (args preserved)
          Property:LoadDoors(room.metadata.doors, roomIdStr, false, true)
        end

        -- Police actions (lockdown / seal / raids)
        local lockdownOption = TargetHandler.Lockdown(
          function()
            -- [SERVER CALL]
            TriggerServerEvent("vms_housing:sv:lockdown", roomIdStr)
          end,
          function()
            return not room.metadata.lockdown
          end
        )
        if lockdownOption then
          table.insert(options, lockdownOption)
        end

        local removeSealOption = TargetHandler.RemoveSeal(
          function()
            -- [SERVER CALL]
            TriggerServerEvent("vms_housing:sv:removePoliceSeal", roomIdStr)
          end,
          function()
            return room.metadata.lockdown
          end
        )
        if removeSealOption then
          table.insert(options, removeSealOption)
        end

        -- Raid / Raid lock (non-MLO only)
        if room.type ~= "mlo" then
          local raidOption = TargetHandler.Raid(
            roomIdStr,
            function(confirmed)
              if confirmed then
                -- [SERVER CALL]
                TriggerServerEvent("vms_housing:sv:raidProperty", roomIdStr)
              end
            end,
            function()
              local can = room.metadata.locked
              if can then
                can = room.isUnderRaid
                can = not can
              end
              return can
            end
          )
          if raidOption then
            table.insert(options, raidOption)
          end

          local raidLockOption = TargetHandler.RaidLock(
            function()
              Property:ToggleLock(roomIdStr, nil, true)
            end,
            function()
              return room.isUnderRaid
            end
          )
          if raidLockOption then
            table.insert(options, raidLockOption)
          end
        end

        -- Create zone target only if options exist
        if next(options) then
          local coords
          if room.type == "mlo" and room.metadata.menu then
            coords = room.metadata.menu
          else
            coords = room.metadata.enter
          end

          local rotation = (room.type == "mlo") and 0.0 or room.metadata.exit.w

          table.insert(TargetPoints, {
            type = "zone",
            id = CL.Target("zone", {
              coords = coords,
              size = vec(1.0, 1.5, 2.8),
              rotation = rotation,
              options = options,
            }),
          })
        end
      end

    --[[----------------------------
      HOUSE / GENERIC PROPERTY TARGETS (outside)
    ------------------------------]]
    else
      -- Only build outside targets when not already inside an interior AND we have a usable entry/menu
      if not CurrentShell and not CurrentIPL then
        local hasEntryOrMenu = currentZonePropertyData.metadata.enter or currentZonePropertyData.metadata.menu
        if hasEntryOrMenu then
          local options = {}

          -- Owned/rented path
          if currentZonePropertyData.owner or currentZonePropertyData.renter then
            -- Manage
            table.insert(options, TargetHandler.Manage(nil, function()
              return library.HasAnyPermission(currentZonePropertyId) and not currentZonePropertyData.metadata.lockdown
            end))

            -- Furniture outside
            if currentZonePropertyData.metadata.allowFurnitureOutside then
              table.insert(options, TargetHandler.Furniture(function()
                return library.HasPermissions(currentZonePropertyId, "furniture") and not currentZonePropertyData.metadata.lockdown
              end))
            end

            -- Toggle lock (non-MLO only, keys not item-based)
            if (not Config.UseKeysOnItem) and currentZonePropertyData.type ~= "mlo" then
              table.insert(options, TargetHandler.ToggleLock(nil, function()
                return (not currentZonePropertyData.metadata.lockdown) and library.HasKeys(currentZonePropertyId)
              end))
            end

            -- Non-MLO: doorbell + enter + lockpick
            if currentZonePropertyData.type ~= "mlo" then
              table.insert(options, TargetHandler.Doorbell(currentZonePropertyId))

              table.insert(options, TargetHandler.Enter(
                function()
                  Property:EnterProperty(currentZonePropertyData)
                end,
                function()
                  return (not currentZonePropertyData.metadata.lockdown) and (not currentZonePropertyData.metadata.locked)
                end
              ))

              if Config.Lockpick and Config.Lockpick.Enable then
                local antiBurglaryDoors = currentZonePropertyData.metadata
                  and currentZonePropertyData.metadata.upgrades
                  and currentZonePropertyData.metadata.upgrades.antiBurglaryDoors

                local alarmUpgrade = currentZonePropertyData.metadata
                  and currentZonePropertyData.metadata.upgrades
                  and currentZonePropertyData.metadata.upgrades.alarm

                table.insert(options, TargetHandler.Lockpick(
                  currentZonePropertyId,
                  antiBurglaryDoors,
                  alarmUpgrade,
                  function(result)
                    -- [SERVER CALL]
                    TriggerServerEvent("vms_housing:sv:lockpickDoors", currentZonePropertyId, result)
                  end,
                  function()
                    local can = currentZonePropertyData.metadata.locked
                    if can then
                      can = currentZonePropertyData.metadata.lockdown
                      can = not can
                    end
                    return can
                  end
                ))
            end
          end

          -- Not owned/rented: view offer if sale/rental active
          else
            local hasOffer =
              (currentZonePropertyData.sale and currentZonePropertyData.sale.active) or
              (currentZonePropertyData.rental and currentZonePropertyData.rental.active)

            if hasOffer then
              table.insert(options, TargetHandler.ViewOffer())
            end
          end

          -- Police actions (lockdown / seal / raids)
          local lockdownOption = TargetHandler.Lockdown(
            function()
              -- [SERVER CALL]
              TriggerServerEvent("vms_housing:sv:lockdown", currentZonePropertyId)
            end,
            function()
              return not currentZonePropertyData.metadata.lockdown
            end
          )
          if lockdownOption then
            table.insert(options, lockdownOption)
          end

          local removeSealOption = TargetHandler.RemoveSeal(
            function()
              -- [SERVER CALL]
              TriggerServerEvent("vms_housing:sv:removePoliceSeal", currentZonePropertyId)
            end,
            function()
              return currentZonePropertyData.metadata.lockdown
            end
          )
          if removeSealOption then
            table.insert(options, removeSealOption)
          end

          local raidOption = TargetHandler.Raid(
            nil,
            function(confirmed)
              if confirmed then
                -- [SERVER CALL]
                TriggerServerEvent("vms_housing:sv:raidProperty", currentZonePropertyId)
              end
            end,
            function()
              local can = currentZonePropertyData.metadata.locked
              if can then
                can = currentZonePropertyData.isUnderRaid
                can = not can
              end
              return can
            end
          )
          if raidOption then
            table.insert(options, raidOption)
          end

          local raidLockOption = TargetHandler.RaidLock(
            function()
              Property:ToggleLock(nil, nil, true)
            end,
            function()
              return currentZonePropertyData.isUnderRaid
            end
          )
          if raidLockOption then
            table.insert(options, raidLockOption)
          end

          -- Create zone if we have options
          if next(options) then
            local coords
            if currentZonePropertyData.type == "mlo" and currentZonePropertyData.metadata.menu then
              coords = currentZonePropertyData.metadata.menu
            else
              coords = currentZonePropertyData.metadata.enter
            end

            local size
            if currentZonePropertyData.type == "mlo" then
              size = vec(1.5, 1.5, 2.8)
            else
              size = vec(1.0, 1.5, 2.8)
            end

            local rotation = (currentZonePropertyData.type == "mlo") and 0.0 or currentZonePropertyData.metadata.exit.w

            table.insert(TargetPoints, {
              type = "zone",
              id = CL.Target("zone", {
                coords = coords,
                size = size,
                rotation = rotation,
                options = options,
              }),
            })
          end
        end
      end

      -- Garage interaction (outside only, not inside shell/ipl)
      if not CurrentShell and not CurrentIPL then
        if currentZonePropertyData.metadata.garage and library.HasPermissions(currentZonePropertyId, "garage") then
          table.insert(TargetPoints, {
            type = "zone",
            id = CL.Target("zone", {
              coords = currentZonePropertyData.metadata.garage,
              size = vec(2.5, 2.5, 2.0),
              rotation = currentZonePropertyData.metadata.garage.w,
              options = {
                {
                  name = "property-garage",
                  icon = "fa-solid fa-warehouse",
                  label = TRANSLATE("target.garage"),
                  distance = 2.5,

                  action = function()
                    if Property.EditingFurniture then
                      return CL.Notification(
                        TRANSLATE("notify.furniture:you_are_in_furniture_mode"),
                        5000,
                        "info"
                      )
                    end

                    if not OpenGarage then
                      return warn("")
                    end

                    OpenGarage(currentZonePropertyId, currentZonePropertyData)
                  end,

                  canInteract = function()
                    return not currentZonePropertyData.metadata.lockdown
                  end,
                },
              },
            }),
          })
        end
      end
    end

    --[[----------------------------
      INSIDE MLO: wardrobe/storage targets (only when inside)
    ------------------------------]]
    if CurrentPropertyData and CurrentPropertyData.type == "mlo" then
      if IsInsideMLO() then
        local wardrobe = CurrentPropertyData.metadata and CurrentPropertyData.metadata.wardrobe
        if wardrobe and wardrobe.x then
          table.insert(TargetPoints, TargetHandler.Wardrobe(
            CurrentProperty,
            wardrobe.x, wardrobe.y, wardrobe.z
          ))
        end

        local storage = CurrentPropertyData.metadata and CurrentPropertyData.metadata.storage
        if storage and storage.x then
          table.insert(TargetPoints, TargetHandler.Storage(
            CurrentProperty,
            storage.x, storage.y, storage.z,
            storage.slots,
            storage.weight
          ))
        end
      end
    end

    -- Always ensure MLO doors are loaded for the current zone property
    if currentZonePropertyData.type == "mlo" then
      -- Args preserved from original:
      -- (doors, propertyId=nil, true, ownerIsNil)
      Property:LoadDoors(
        currentZonePropertyData.metadata.doors,
        nil,
        true,
        currentZonePropertyData.owner == nil
      )
    end

  -- If player is NOT in a property zone
  else
    -- But is inside an interior (shell/IPL), keep interior interactables loaded
    if CurrentShell or CurrentIPL then
      Property:LoadInteriorInteractable()
    end
  end
end

--[[--------------------------------------------------------------------------
  Apartment menu (NUI)
----------------------------------------------------------------------------]]

---Reloads apartment menu data in NUI based on SelectedApartment
function ReloadApartmentMenu()
  local apartmentData = Properties[SelectedApartment]

  local payload = {
    isOwner = IsOwner(apartmentData),
    isRenter = IsRenter(apartmentData),
    isKeyHolder = library.HasKeys(SelectedApartment),
    apartmentData = apartmentData,
    hasPermManage = library.HasAnyPermission(SelectedApartment),

    canLockdown = false,
    canRemovePoliceSeal = false,
    canRaid = false,
    canLockAfterRaid = false,
  }

  -- [ASYNC SERVER CALLBACK (await)]
  local actions = library.CallbackAwait("vms_housing:checkApartmentActions", SelectedApartment) or {}

  local md = apartmentData.metadata or {}

  -- Lockpick (anyone, gated by item on server + property state)
  payload.canLockpick = (Config.Lockpick and Config.Lockpick.Enable)
    and md.locked
    and (not md.lockdown)
    and actions.allowedLockpick

  -- Police lockdown / seal actions
  payload.canLockdown = (not md.lockdown) and actions.allowedLockdown
  payload.canRemovePoliceSeal = md.lockdown and actions.allowedRemovePoliceSeal

  -- Police raid actions
  payload.canRaid = md.locked and (not apartmentData.isUnderRaid) and actions.allowedRaid
  payload.canLockAfterRaid = apartmentData.isUnderRaid and actions.allowedLockAfterRaid

  -- [NUI]
  SendNUIMessage({
    action = "Property",
    actionName = "ReloadApartmentMenu",
    data = payload,
  })
end

--[[--------------------------------------------------------------------------
  Spawn / restore last property
----------------------------------------------------------------------------]]

---Restores player into their last property if server reports they were inside.
---Optional callback receives true/false to indicate success.
---@param onDone fun(success:boolean)|nil
function SpawnInLastProperty(onDone)
  -- [ASYNC SERVER CALLBACK]
  library.Callback("vms_housing:checkLastProperty", function(ok, propertyData, extraPropertyData)
    if ok and propertyData then
      -- Validate shell/IPL availability before proceeding
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
      end

      -- Freeze player while we set up interior
      FreezeEntityPosition(PlayerPedId(), true)

      if onDone then onDone(true) end

      CurrentProperty = tostring(propertyData.id)

      -- Ensure Properties contains the propertyData
      if not (Properties and next(Properties) and Properties[CurrentProperty]) then
        Properties[CurrentProperty] = propertyData
      end

      -- Optionally cache extra property
      if extraPropertyData then
        local extraId = tostring(extraPropertyData.id)
        if not (Properties and next(Properties) and Properties[extraId]) then
          Properties[extraId] = extraPropertyData
        end
      end

      CurrentPropertyData = Properties[tostring(propertyData.id)]

      -- Load interior type
      if propertyData.type == "shell" then
        CurrentShell = CreateObjectNoOffset(
          joaat(propertyData.metadata.shell),
          0.0, 0.0, 500.0,
          false, false, false
        )

        -- Wait until it exists
        while not DoesEntityExist(CurrentShell) do
          Wait(1)
        end

        SetEntityHeading(CurrentShell, 0.0)
        FreezeEntityPosition(CurrentShell, true)

        -- Load static interaction points for this shell
        Property:LoadStaticInteractable(AvailableShells[propertyData.metadata.shell])

      elseif propertyData.type == "ipl" then
        CurrentIPL = propertyData.metadata.ipl

        -- Load IPL settings/theme
        IPL.LoadSettings(CurrentIPL, propertyData.metadata.iplTheme, propertyData.metadata.iplSettings)

        -- Load static interaction points for this IPL
        Property:LoadStaticInteractable(AvailableIPLS[propertyData.metadata.ipl])
      end

      -- [SERVER CALL] mark player as inside
      TriggerServerEvent("vms_housing:sv:enterHouse", CurrentProperty)

      -- Weather control thread (async)
      if ToggleWeather then
        Citizen.CreateThread(function()
          while CurrentShell or CurrentIPL do
            ToggleWeather(true, propertyData.type == "ipl")
            Citizen.Wait(30000)
          end
        end)
      end

      -- Lights state (if configured)
      if propertyData.metadata.lightState ~= nil then
        SetArtificialLightsState(not propertyData.metadata.lightState)
      end

      -- Load furniture inside (if any)
      if propertyData.furniture then
        Property:LoadFurniture("inside", propertyData.furniture, CurrentProperty)
      end

      -- Unfreeze player & load interior interactables (storage, wardrobe, etc.)
      FreezeEntityPosition(PlayerPedId(), false)
      Property:LoadInteriorInteractable()

    else
      if onDone then onDone(false) end
    end
  end)
end

--[[--------------------------------------------------------------------------
  Property getters / exports
----------------------------------------------------------------------------]]

---Returns a list of properties that the player owns or rents.
---@return table[]
function GetPlayerProperties()
  local result = {}

  for _, propertyData in pairs(Properties) do
    if propertyData.owner == Identifier or propertyData.renter == Identifier then
      table.insert(result, propertyData)
    end
  end

  return result
end

exports("GetPlayerProperties", GetPlayerProperties)

---Returns property data by id (string/number), or nil if not found.
---@param propertyId any
---@return table|nil
function GetProperty(propertyId)
  local data = Properties[tostring(propertyId)]
  if not data then
    data = nil
  end
  return data
end

exports("GetProperty", GetProperty)

---Returns (isOnZone, propertyId)
exports("IsPlayerOnPropertyZone", function()
  local propertyId = GetCurrentPropertyId()
  return propertyId ~= nil, propertyId
end)

---Returns (CurrentProperty, CurrentPropertyData)
exports("IsPlayerInsideProperty", function()
  return CurrentProperty, CurrentPropertyData
end)

---Returns Config[key]
exports("GetConfiguration", function(key)
  return Config[key]
end)
