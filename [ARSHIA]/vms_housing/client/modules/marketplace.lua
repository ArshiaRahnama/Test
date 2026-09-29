--[[-------------------------------------------------------------------------
  Marketplace UI (deobfuscated)

  Responsibilities:
    - Build a list of properties currently for sale or rent (active listings)
    - Optionally filter to "secondary market only" (see Config.Marketplace.ShowSecondaryMarketOnly)
    - For each listed property, attach:
        - address + region display name
        - first available image (slots "1".."5")
        - garage / parking / zone area
        - sale & rental data
        - optional building info if the property is an "object" with an associated building property
    - Open / Close NUI Marketplace menu
    - Export OpenMarketplace for other resources

  Notes:
    - No server calls / network events in this snippet.
    - NUI: SendNUIMessage + SetNuiFocus
---------------------------------------------------------------------------]]

-- Global state used elsewhere in the resource
isOfferByMarketplace = false
marketplaceOfferId = nil

---@return string|nil First available image from metadata.images["1".."5"]
local function getFirstMarketplaceImage(propertyData)
  if not propertyData.metadata or not propertyData.metadata.images then
    return nil
  end

  for i = 1, 5 do
    local key = tostring(i)
    local img = propertyData.metadata.images[key]
    if img then
      return img
    end
  end

  return nil
end

---@return boolean True if property is listed (sale active OR rental active) and passes secondary-market filter
local function isPropertyListedForMarketplace(propertyData)
  local saleActive = propertyData.sale and propertyData.sale.active == true
  local rentalActive = propertyData.rental and propertyData.rental.active == true

  if not (saleActive or rentalActive) then
    return false
  end

  -- If "secondary market only" is enabled, require owner to be present.
  -- (Matches original behavior: when owner is missing and the flag is true, do NOT list it)
  if not propertyData.owner and Config.Marketplace.ShowSecondaryMarketOnly then
    return false
  end

  return true
end

---@param propertyData table
---@return string Address string, optionally "address, region" if region exists in Config.Regions
local function buildDisplayAddress(propertyData)
  local display = propertyData.address
  if Config.Regions[propertyData.region] then
    display = display .. ", " .. propertyData.region
  end
  return display
end

---@param propertyKey any
---@param propertyData table
---@return table Marketplace item entry
local function buildMarketplaceEntry(propertyKey, propertyData)
  local image = getFirstMarketplaceImage(propertyData)
  local displayAddress = buildDisplayAddress(propertyData)

  local hasGarage = (propertyData.metadata and propertyData.metadata.garage ~= nil) or false
  local parking = propertyData.metadata and propertyData.metadata.parking or nil

  local area = nil
  if propertyData.metadata and propertyData.metadata.zone and propertyData.metadata.zone.area then
    area = propertyData.metadata.zone.area
  end

  local entry = {
    name = displayAddress,
    parking = parking,
    garage = hasGarage,
    image = image,
    area = area,
    sale = propertyData.sale,
    rental = propertyData.rental,
  }

  -- If this property is an "object property", attach its building info if present in Properties table.
  if propertyData.object_id then
    local buildingKey = tostring(propertyData.object_id)
    local buildingData = Properties[buildingKey]
    if buildingData then
      entry.building = {
        type = buildingData.type,
        name = buildingData.name,
        parkingSpaces = buildingData.metadata and buildingData.metadata.parkingSpaces or nil,
      }
    end
  end

  return entry
end

function openMarketplace()
  -- Reset offer tracking (used by other marketplace flows)
  isOfferByMarketplace = false
  marketplaceOfferId = nil

  -- Build listing map keyed by property id/key from Properties table
  local listedProperties = {}

  for propertyKey, propertyData in pairs(Properties) do
    if isPropertyListedForMarketplace(propertyData) then
      listedProperties[propertyKey] = buildMarketplaceEntry(propertyKey, propertyData)
    end
  end

  -- NUI payload
  local payload = {
    action = "Marketplace",
    actionName = "Open",
    data = {
      propertiesList = listedProperties,
      noRegion = Config.NoRegion,
      regions = Config.Regions,
    }
  }

  -- Open NUI
  SetNuiFocus(true, true)
  SendNUIMessage(payload)
  openedMenu = "Marketplace"
end

function closeMarketplace()
  SendNUIMessage({
    action = "Marketplace",
    actionName = "Close",
  })

  SetNuiFocus(false, false)
  openedMenu = nil

  -- Reset offer tracking
  isOfferByMarketplace = false
  marketplaceOfferId = nil
end

-- Export for other resources
exports("OpenMarketplace", openMarketplace)