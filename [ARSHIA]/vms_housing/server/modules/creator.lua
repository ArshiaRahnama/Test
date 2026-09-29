--[[
  vms_housing (server) - deobfuscated/cleaned

  Notes:
  - This file registers several server-side network events used by the housing creator/admin UI.
  - External globals expected to exist (as in the original):
      SV, library, Properties, Furniture, Config, MySQL, json, Citizen, exports, GetProperty,
      RegisterGarage (optional), SaveFurniture, WebhookText
  - All logic is preserved; the code is reorganized into helpers and named variables for clarity.
  - Asynchronous/DB operations are clearly marked.
]]

local EVENT_CREATE_HOUSE     = "vms_housing:sv:createNewHouse"
local EVENT_DELETE_HOUSE     = "vms_housing:sv:deleteHouse"
local EVENT_ADD_FURNITURE    = "vms_housing:sv:addFurniture"
local EVENT_MODIFY_FURNITURE = "vms_housing:sv:modifyFurniture"
local EVENT_DELETE_FURNITURE = "vms_housing:sv:deleteFurniture"

-- ------------------------------------------------------------
-- Helpers
-- ------------------------------------------------------------

--- Returns player + identifier if the caller has creator permissions, otherwise nil.
local function getCreatorContext(src)
  local player = SV.GetPlayer(src)
  local identifier = SV.GetIdentifier(player)

  if not library.HasCreatorPermissions(player) then
    return nil
  end

  return {
    src = src,
    player = player,
    identifier = identifier,
    playerName = GetPlayerName(src),
  }
end

--- Format "sale/rental status" strings the same way as the original code.
local function formatSaleStatus(property)
  if property.sale and property.sale.active then
    return ("✅ $%s"):format(property.sale.price)
  end
  return "❌ No"
end

local function formatRentalStatus(property)
  if property.rental and property.rental.active then
    return ("✅ $%s"):format(property.rental.price)
  end
  return "❌ No"
end

--- Registers storage for a house if storage data exists.
--- (Original: on create checks storage.x, on edit registers if storage exists and wasn't registered before.)
local function registerHouseStorageIfNeeded(houseId, storageData)
  if not storageData then return end

  library.RegisterStorage({
    id = ("house_storage-%s"):format(houseId),
    slots = tonumber(storageData.slots),
    weight = tonumber(storageData.weight),
  })
end

--- Sync (re)register building parking floors with vms_garagesv2.
--- IMPORTANT: This uses exports.vms_garagesv2 just like the original, and assumes it's available when called.
local function reregisterBuildingParkingFloors(buildingId, buildingProperty)
  if not (buildingProperty and buildingProperty.metadata and buildingProperty.metadata.parkingSpaces) then
    return
  end

  for floor, floorSpaces in pairs(buildingProperty.metadata.parkingSpaces) do
    exports.vms_garagesv2:registerBuildingParking(
      buildingId,
      floor,
      buildingProperty.name,
      {
        enterOnFoot = buildingProperty.metadata.exit,
        enterWithVehicle = buildingProperty.metadata.parkingEnter,
      },
      floorSpaces
    )

    Citizen.Wait(100) -- matches original pacing
  end
end

--- Persist building metadata and refresh it for clients.
local function persistAndRefreshBuilding(buildingId, buildingProperty)
  -- [DB] async update
  MySQL.update("UPDATE houses SET metadata = ? WHERE id = ?", {
    json.encode(buildingProperty.metadata),
    tonumber(buildingId),
  })

  -- [NET] broadcast "createdHouse" so clients refresh the building entry
  TriggerClientEvent("vms_housing:cl:createdHouse", -1, tostring(buildingId), buildingProperty)
end

--- Update a parent building's parkingSpaces metadata:
--- - optionally remove all references to removeHouseId
--- - optionally assign new parking spots to houseId from newSpacesByFloor
--- - re-register floors, persist to DB, and refresh clients
local function updateParentBuildingParking(buildingId, houseId, newSpacesByFloor, removeHouseId)
  if not buildingId then return end

  local buildingProperty = Properties[tostring(buildingId)]
  if not (buildingProperty and buildingProperty.metadata and buildingProperty.metadata.parkingSpaces) then
    return
  end

  -- Remove old references (used on edit/delete)
  if removeHouseId then
    for _, floorSpaces in pairs(buildingProperty.metadata.parkingSpaces) do
      for spotKey, assignedHouseId in pairs(floorSpaces) do
        if tonumber(assignedHouseId) == tonumber(removeHouseId) then
          floorSpaces[tostring(spotKey)] = nil
        end
      end
    end
  end

  -- Assign new reserved spaces (used on create/edit)
  if newSpacesByFloor and houseId then
    for floor, spotList in pairs(newSpacesByFloor) do
      local floorKey = tostring(floor)
      local floorSpaces = buildingProperty.metadata.parkingSpaces[floorKey]

      if floorSpaces then
        for _, spotId in ipairs(spotList) do
          floorSpaces[tostring(spotId)] = tonumber(houseId)
        end
      end
    end
  end

  -- Re-register floors in garages
  reregisterBuildingParkingFloors(buildingId, buildingProperty)

  -- Persist + refresh for clients
  persistAndRefreshBuilding(buildingId, buildingProperty)
end

-- ------------------------------------------------------------
-- EVENT: Create New House / Edit Existing House
-- ------------------------------------------------------------
RegisterNetEvent(EVENT_CREATE_HOUSE, function(houseType, houseData, existingHouseId)
  local ctx = getCreatorContext(source)
  if not ctx then return end

  local houseId = nil

  -- ----------------------------------------------------------
  -- CREATE
  -- ----------------------------------------------------------
  if not existingHouseId then
    -- Decode incoming JSON blobs
    local metadata = json.decode(houseData.metadata)
    local saleData = json.decode(houseData.sale)
    local rentalData = json.decode(houseData.rental)

    -- Reset runtime values from defaults (matches original)
    saleData.price = saleData.defaultPrice
    saleData.active = saleData.defaultActive
    local saleJson = json.encode(saleData)

    rentalData.price = rentalData.defaultPrice
    rentalData.active = rentalData.defaultActive
    local rentalJson = json.encode(rentalData)

    -- If this is a building with apartment parking and using vms_garagesv2,
    -- pre-create empty floors in metadata.parkingSpaces (matches original).
    if Config.Garages == "vms_garagesv2" and houseType == "building" then
      if houseData.apartmentParking then
        metadata.parkingSpaces = {}
        for floor = 1, houseData.parkingFloors do
          metadata.parkingSpaces[tostring(floor)] = {}
        end
      end
    end

    local objectId = houseData.building or houseData.motel

    -- [DB][await] insert new house (async await)
    houseId = MySQL.insert.await(
      "INSERT INTO `houses` (`type`, `object_id`, `name`, `region`, `address`, `metadata`, `sale`, `rental`, `description`, `creator`) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)",
      {
        houseType,
        objectId,
        houseData.name,
        houseData.region,
        houseData.address,
        json.encode(metadata),
        saleJson,
        rentalJson,
        houseData.description,
        ctx.identifier,
      }
    )

    -- Register storage if the storage position exists (original checks storage.x on creation)
    if metadata and metadata.storage and metadata.storage.x then
      registerHouseStorageIfNeeded(houseId, metadata.storage)
    end

    -- Build in-memory property entry (matches original structure)
    local numericObjectId = tonumber(houseData.building) or tonumber(houseData.motel)

    Properties[tostring(houseId)] = {
      id = houseId,
      object_id = numericObjectId,
      type = houseType,
      name = houseData.name,
      region = houseData.region,
      address = houseData.address,
      furniture = {},
      bills = {},
      unpaidBills = 0,
      keys = json.encode({}),
      permissions = {},
      metadata = metadata,
      sale = json.decode(saleJson),
      rental = json.decode(rentalJson),
      description = houseData.description,
      last_enter = 0,
      creator = ctx.identifier,
    }

    -- Webhook (CreatedProperty)
    do
      local objectLabel = ""
      if houseData.building then
        objectLabel = "Building"
      elseif houseData.motel then
        objectLabel = "Motel"
      end

      local objectLabelId = houseData.building or houseData.motel or "-"

      local createdProperty = Properties[tostring(houseId)]
      SV.Webhook(
        "CreatedProperty",
        WebhookText["TITLE.CreatedProperty"],
        WebhookText["DESCRIPTION.CreatedProperty"]:format(
          ctx.playerName,
          ctx.src,
          houseType,
          houseId,
          houseData.name,
          houseData.description,
          houseData.region,
          houseData.address,
          objectLabel,
          objectLabelId,
          formatSaleStatus(createdProperty),
          formatRentalStatus(createdProperty)
        ),
        0,
        ctx.identifier
      )
    end

    -- Optional garage integration (original: only if metadata.garage and RegisterGarage exists)
    if metadata and metadata.garage and RegisterGarage then
      RegisterGarage(tostring(houseId), Properties[tostring(houseId)], true)
    end

    -- vms_garagesv2 integrations (create)
    if Config.Garages == "vms_garagesv2" then
      -- Property parking
      if metadata and metadata.parking then
        exports.vms_garagesv2:registerPropertyParking(
          tostring(houseId),
          ("Property %s"):format(houseData.name),
          metadata.zone,
          metadata.parking
        )
      end

      -- Building floors (if this *property itself* is a building with apartmentParking)
      if houseType == "building" and houseData.apartmentParking then
        for floor = 1, houseData.parkingFloors do
          exports.vms_garagesv2:registerBuildingParking(
            houseId,
            floor,
            houseData.name,
            {
              enterOnFoot = metadata.exit,
              enterWithVehicle = metadata.parkingEnter,
            }
          )
        end
      end

      -- If this property belongs to a building and requests reserved parking spots,
      -- update the parent building metadata + re-register floors (matches original block).
      if houseData.building and houseData.parkingSpaces then
        updateParentBuildingParking(tonumber(houseData.building), houseId, houseData.parkingSpaces, nil)
      end
    end

  -- ----------------------------------------------------------
  -- EDIT
  -- ----------------------------------------------------------
  else
    houseId = existingHouseId

    local property = GetProperty(tostring(houseId))
    if not property then return end

    -- Decode incoming JSON blobs
    houseData.metadata = json.decode(houseData.metadata)
    houseData.sale = json.decode(houseData.sale)
    houseData.rental = json.decode(houseData.rental)

    -- --------------------------------------------------------
    -- Type-specific metadata updates
    -- --------------------------------------------------------
    if property.type == "shell" then
      property.metadata.shell = houseData.metadata.shell
      property.metadata.allowFurnitureOutside = houseData.metadata.allowFurnitureOutside
      property.metadata.allowFurnitureInside = houseData.metadata.allowFurnitureInside
      property.metadata.enter = houseData.metadata.enter
      property.metadata.exit = houseData.metadata.exit
      property.metadata.garage = houseData.metadata.garage
      property.metadata.parking = houseData.metadata.parking
      property.metadata.wardrobe = houseData.metadata.wardrobe

      -- Storage registration (original: only registers if it previously didn't exist)
      if not property.metadata.storage and houseData.metadata.storage then
        registerHouseStorageIfNeeded(houseId, houseData.metadata.storage)
      end
      property.metadata.storage = houseData.metadata.storage

      -- If this shell is tied to a building and the UI submitted reserved parking spaces,
      -- update parent building parkingSpaces (original helper L7_2 behavior).
      if houseData.parkingSpaces then
        updateParentBuildingParking(property.object_id, houseId, houseData.parkingSpaces, houseId)
      end

    elseif property.type == "ipl" then
      property.metadata.ipl = houseData.metadata.ipl
      property.metadata.iplTheme = houseData.metadata.iplTheme
      property.metadata.allowFurnitureOutside = houseData.metadata.allowFurnitureOutside
      property.metadata.allowFurnitureInside = houseData.metadata.allowFurnitureInside
      property.metadata.allowChangeTheme = houseData.metadata.allowChangeTheme
      property.metadata.allowChangeThemePurchased = houseData.metadata.allowChangeThemePurchased
      property.metadata.enter = houseData.metadata.enter
      property.metadata.exit = houseData.metadata.exit
      property.metadata.garage = houseData.metadata.garage
      property.metadata.parking = houseData.metadata.parking
      property.metadata.wardrobe = houseData.metadata.wardrobe

      -- Storage registration (original: only registers if it previously didn't exist)
      if not property.metadata.storage and houseData.metadata.storage then
        registerHouseStorageIfNeeded(houseId, houseData.metadata.storage)
      end
      property.metadata.storage = houseData.metadata.storage

      -- Update parent building parkingSpaces if submitted
      if houseData.parkingSpaces then
        updateParentBuildingParking(property.object_id, houseId, houseData.parkingSpaces, houseId)
      end

    elseif property.type == "mlo" then
      property.metadata.allowFurnitureOutside = houseData.metadata.allowFurnitureOutside
      property.metadata.allowFurnitureInside = houseData.metadata.allowFurnitureInside
      property.metadata.interiorZone = houseData.metadata.interiorZone
      property.metadata.menu = houseData.metadata.menu
      property.metadata.garage = houseData.metadata.garage
      property.metadata.parking = houseData.metadata.parking
      property.metadata.doors = houseData.metadata.doors
      property.metadata.wardrobe = houseData.metadata.wardrobe

      -- Storage registration (original: only registers if it previously didn't exist)
      if not property.metadata.storage and houseData.metadata.storage then
        registerHouseStorageIfNeeded(houseId, houseData.metadata.storage)
      end
      property.metadata.storage = houseData.metadata.storage

    elseif property.type == "building" then
      property.metadata.enter = houseData.metadata.enter
      property.metadata.exit = houseData.metadata.exit

      -- Apartment parking enabled for the building?
      if houseData.apartmentParking then
        property.metadata.parkingEnter = houseData.metadata.parkingEnter

        -- Build/keep parkingSpaces by floors; preserve existing floors if present
        local mergedParkingSpaces = {}

        for floor = 1, houseData.parkingFloors do
          local floorKey = tostring(floor)

          if property.metadata.parkingSpaces then
            mergedParkingSpaces[floorKey] = property.metadata.parkingSpaces[floorKey] or {}
          else
            mergedParkingSpaces[floorKey] = {}
          end

          -- NOTE: Original code passes the entire mergedParkingSpaces table each iteration.
          exports.vms_garagesv2:registerBuildingParking(
            houseId,
            floor,
            houseData.name,
            {
              enterOnFoot = property.metadata.exit,
              enterWithVehicle = property.metadata.parkingEnter,
            },
            mergedParkingSpaces
          )

          Citizen.Wait(100)
        end

        property.metadata.parkingSpaces = mergedParkingSpaces
      else
        -- Disabled apartment parking: clear building parking data
        property.metadata.parkingEnter = nil
        property.metadata.parkingSpaces = nil
      end
    end

    -- --------------------------------------------------------
    -- Common metadata updates
    -- --------------------------------------------------------
    property.metadata.zone = houseData.metadata.zone

    -- Optional limits
    if houseData.metadata.keysLimit then
      property.metadata.keysLimit = houseData.metadata.keysLimit
    else
      property.metadata.keysLimit = nil
    end

    if houseData.metadata.permissionsLimit then
      property.metadata.permissionsLimit = houseData.metadata.permissionsLimit
    else
      property.metadata.permissionsLimit = nil
    end

    -- Delivery settings
    if houseData.metadata.deliveryType then
      property.metadata.deliveryType = houseData.metadata.deliveryType
      property.metadata.delivery = houseData.metadata.delivery
    else
      property.metadata.deliveryType = nil
      property.metadata.delivery = nil
    end

    -- Ensure outgoing data uses the updated property metadata (matches original)
    houseData.metadata = property.metadata

    -- --------------------------------------------------------
    -- Sale update rules (preserved)
    -- --------------------------------------------------------
    if houseData.sale and property.sale then
      if houseData.sale.defaultPrice then
        if houseData.sale.defaultPrice > 0 then
          property.sale.defaultPrice = houseData.sale.defaultPrice

          -- If not owned, sync current price to default
          if not property.owner then
            property.sale.price = property.sale.defaultPrice
          end
        end
      else
        property.sale.price = property.sale.defaultPrice or 0
      end

      -- Only update active flags if not owned AND not rented
      if not property.owner and not property.renter then
        property.sale.defaultActive = houseData.sale.defaultActive
        property.sale.active = houseData.sale.defaultActive
      end

      houseData.sale = property.sale
    end

    -- --------------------------------------------------------
    -- Rental update rules (preserved)
    -- --------------------------------------------------------
    if houseData.rental and property.rental then
      if houseData.rental.defaultPrice then
        if houseData.rental.defaultPrice > 0 then
          property.rental.defaultPrice = houseData.rental.defaultPrice

          -- If not owned, sync current price to default
          if not property.owner then
            property.rental.price = property.rental.defaultPrice
          end
        end
      else
        property.rental.price = property.rental.defaultPrice or 0
      end

      -- Only update active flags if not owned AND not rented
      if not property.owner and not property.renter then
        property.rental.defaultActive = houseData.rental.defaultActive
        property.rental.active = houseData.rental.defaultActive
      end

      houseData.rental = property.rental
    end

    -- [DB] async update
    MySQL.update(
      "UPDATE houses SET name = ?, region = ?, address = ?, metadata = ?, sale = ?, rental = ?, description = ? WHERE id = ?",
      {
        houseData.name,
        houseData.region,
        houseData.address,
        json.encode(houseData.metadata),
        json.encode(houseData.sale),
        json.encode(houseData.rental),
        houseData.description,
        houseId,
      }
    )

    -- Update in-memory object (preserved)
    property.name = houseData.name
    property.description = houseData.description
    property.region = houseData.region
    property.address = houseData.address
    property.metadata = houseData.metadata
    property.sale = houseData.sale
    property.rental = houseData.rental

    -- Optional garage re-registration (original: third arg false on edit)
    if houseData.metadata.garage and RegisterGarage then
      RegisterGarage(tostring(houseId), property, false)
    end

    -- Property parking re-registration (original does not gate this by Config.Garages)
    if houseData.metadata.parking then
      exports.vms_garagesv2:registerPropertyParking(
        tostring(houseId),
        ("Property %s"):format(houseData.name),
        houseData.metadata.zone,
        houseData.metadata.parking
      )
    end

    -- Webhook (EditedProperty)
    do
      local objectLabel = ""
      if houseData.building then
        objectLabel = "Building"
      elseif houseData.motel then
        objectLabel = "Motel"
      end

      local objectLabelId = houseData.building or houseData.motel or "-"

      SV.Webhook(
        "EditedProperty",
        WebhookText["TITLE.EditedProperty"],
        WebhookText["DESCRIPTION.EditedProperty"]:format(
          ctx.playerName,
          ctx.src,
          property.type,
          houseId,
          houseData.name,
          houseData.description,
          houseData.region,
          houseData.address,
          objectLabel,
          objectLabelId,
          formatSaleStatus(property),
          formatRentalStatus(property)
        ),
        0,
        ctx.identifier
      )
    end
  end

  -- [NET] broadcast: (re)send the created/edited property to all clients
  TriggerClientEvent("vms_housing:cl:createdHouse", -1, tostring(houseId), Properties[tostring(houseId)])
end)

-- ------------------------------------------------------------
-- EVENT: Delete House
-- ------------------------------------------------------------
RegisterNetEvent(EVENT_DELETE_HOUSE, function(houseId)
  local ctx = getCreatorContext(source)
  if not ctx then return end

  local property = GetProperty(tostring(houseId))

  -- [DB] async query with callback (original uses callback style)
  MySQL.query("DELETE FROM `houses` WHERE id = ?", { houseId }, function(_result)
    -- If this property belonged to a building, remove its reserved parking references in the parent building
    if property and property.object_id then
      updateParentBuildingParking(property.object_id, nil, nil, houseId)
    end

    -- Remove from in-memory cache
    Properties[tostring(houseId)] = nil

    -- Webhook (original uses "EditedProperty" as the webhook type key for deletions)
    SV.Webhook(
      "EditedProperty",
      WebhookText["TITLE.DeletedProperty"],
      WebhookText["DESCRIPTION.DeletedProperty"]:format(ctx.playerName, ctx.src, houseId),
      0,
      ctx.identifier
    )

    -- [NET] broadcast removal
    TriggerClientEvent("vms_housing:cl:removedHouse", -1, tostring(houseId))
  end)
end)

-- ------------------------------------------------------------
-- EVENT: Add Furniture (bulk)
-- ------------------------------------------------------------
RegisterNetEvent(EVENT_ADD_FURNITURE, function(furnitureBatch)
  local ctx = getCreatorContext(source)
  if not ctx then return end

  local newFurnitureKeys = {}
  local addedListForWebhook = ""

  for modelName, data in pairs(furnitureBatch) do
    if not Furniture[modelName] then
      table.insert(newFurnitureKeys, modelName)

      Furniture[modelName] = {
        label = "",
        price = 0,
        deliverySize = data.deliverySize or 1,
        tag = "",
        isOutdoor = true,
        isIndoor = true,
      }

      -- Keep the same general webhook formatting intent as original
      addedListForWebhook = addedListForWebhook
        .. ("\n                %s,\n            "):format(modelName)
    end
  end

  -- Webhook (CreatedFurniture)
  SV.Webhook(
    "CreatedFurniture",
    WebhookText["TITLE.CreatedFurniture"],
    WebhookText["DESCRIPTION.CreatedFurniture"]:format(ctx.playerName, ctx.src, addedListForWebhook),
    0,
    ctx.identifier
  )

  -- Persist new furniture rows
  SaveFurniture("insert", newFurnitureKeys)

  -- [NET] broadcast updated furniture list to all clients
  TriggerClientEvent("vms_housing:cl:reloadFurnitureList", -1, json.encode(Furniture))
end)

-- ------------------------------------------------------------
-- EVENT: Modify Furniture
-- ------------------------------------------------------------
RegisterNetEvent(EVENT_MODIFY_FURNITURE, function(modelName, formData)
  local ctx = getCreatorContext(source)
  if not ctx then return end

  if not Furniture[modelName] then return end

  -- Delivery size selection logic (preserved)
  local deliverySize = nil
  if formData.isSmallDelivery then
    deliverySize = 1
  elseif formData.isMediumDelivery then
    deliverySize = 2
  elseif formData.isBigDelivery then
    deliverySize = 3
  end

  Furniture[modelName] = {
    label = formData.label,
    price = formData.price,
    deliverySize = deliverySize,
    tag = formData.tag or "",
    isOutdoor = formData.isFurnitureOutside,
    isIndoor = formData.isFurnitureInside,
    interactableName = formData.interactableName,
    metadata = formData.metadata,
  }

  -- Webhook (EditedFurniture)
  local outsideIcon = formData.isFurnitureOutside and "✅" or "❌"
  local insideIcon = formData.isFurnitureInside and "✅" or "❌"
  local dumpedMetadata = library.Dump(formData.metadata)

  SV.Webhook(
    "EditedFurniture",
    WebhookText["TITLE.EditedFurniture"],
    WebhookText["DESCRIPTION.EditedFurniture"]:format(
      ctx.playerName,
      ctx.src,
      formData.label,
      formData.price,
      deliverySize,
      formData.tag or "",
      outsideIcon,
      insideIcon,
      formData.interactableName,
      dumpedMetadata
    ),
    0,
    ctx.identifier
  )

  -- Persist update
  SaveFurniture("update", modelName)

  -- [NET] broadcast updated furniture entry
  TriggerClientEvent("vms_housing:cl:reloadFurniture", -1, modelName, Furniture[modelName])
end)

-- ------------------------------------------------------------
-- EVENT: Delete Furniture
-- ------------------------------------------------------------
RegisterNetEvent(EVENT_DELETE_FURNITURE, function(modelName)
  local ctx = getCreatorContext(source)
  if not ctx then return end

  if not Furniture[modelName] then return end

  Furniture[modelName] = nil

  -- Webhook (DeletedFurniture)
  SV.Webhook(
    "DeletedFurniture",
    WebhookText["TITLE.DeletedFurniture"],
    WebhookText["DESCRIPTION.DeletedFurniture"]:format(ctx.playerName, ctx.src, modelName),
    0,
    ctx.identifier
  )

  -- Persist delete
  SaveFurniture("delete", modelName)

  -- [NET] broadcast removal
  TriggerClientEvent("vms_housing:cl:reloadFurniture", -1, modelName)
end)