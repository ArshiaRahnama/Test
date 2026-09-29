--[[-------------------------------------------------------------------------
  Property Management Menu (deobfuscated)

  Responsibilities:
    - Resolve which property to manage (explicit id, current property, etc.)
    - Permission-gate access to management UI
    - Detect inside/outside state (shell / ipl / mlo)
    - Fetch/manage cached "bills" info via async server callback
    - Build and send NUI payload: Property -> OpenManage
    - Register exports + optional command/keybind to open menu
    - Provide a close function for the NUI menu

  Highlights:
    - [ASYNC SERVER CALLBACK] library.Callback("vms_housing:openManageMenu", ...)
      uses promise + Citizen.Await.
---------------------------------------------------------------------------]]

local ManageMenu = {} -- (kept like original; not used directly but harmless)

-- Cache: avoid spamming the callback if the same property is reopened quickly
local lastManageFetchPropertyId = nil      -- was L0_1
local manageFetchCacheExpiresAt = nil      -- was L1_1 (stores GetGameTimer()+60000)

---@param propertyId string|number|nil
---@param isDevice boolean|nil  -- if opened from a device/tablet etc.
function openManageMenu(propertyId, isDevice)
  -- Preserve original side-effect: store motel manage id if provided
  if propertyId then
    MotelManageId = propertyId
  end

  -- Resolve property id if not explicitly provided
  local resolvedPropertyId = propertyId
  if not resolvedPropertyId then
    resolvedPropertyId = CurrentProperty
    if not resolvedPropertyId then
      resolvedPropertyId = GetCurrentPropertyId()
    end
  end

  if not resolvedPropertyId then
    return
  end

  -- Prefer the fully synced Properties table if available; otherwise fallback to current property data getter
  local propertyData = nil
  if resolvedPropertyId and Properties[resolvedPropertyId] then
    propertyData = Properties[resolvedPropertyId]
  else
    propertyData = CurrentPropertyData
    if not propertyData then
      propertyData = GetCurrentPropertyData()
    end
  end

  -- Permission gate (any permission)
  if not library.HasAnyPermission(resolvedPropertyId) then
    return
  end

  -- Determine whether player is currently inside the property
  local isInside = false
  local isOutside = false -- (calculated in original; not used later but kept)

  if propertyData.type == "shell" then
    if CurrentShell then
      isInside = true
    else
      isOutside = true
    end
  elseif propertyData.type == "ipl" then
    if CurrentIPL then
      isInside = true
    else
      isOutside = true
    end
  elseif propertyData.type == "mlo" then
    isInside = IsInsideMLO()
    isOutside = not isInside
  end

  -- Region utility prices/labels (fallback to NoRegion)
  local regionData = Config.Regions[propertyData.region]
  if not regionData then
    regionData = Config.NoRegion
  end

  -- Refresh bills/rent bills/unpaid bills using cached async callback
  local manageServerData = nil

  local cacheValid = false
  if manageFetchCacheExpiresAt then
    local now = GetGameTimer()
    if not (now > manageFetchCacheExpiresAt) and lastManageFetchPropertyId == resolvedPropertyId then
      cacheValid = true
    end
  end

  if not cacheValid then
    -- [ASYNC SERVER CALLBACK] Fetch manage menu data (bills, unpaid, etc.)
    local p = promise.new()

    library.Callback("vms_housing:openManageMenu", function(serverData)
      -- set cache expiry for 60 seconds
      manageFetchCacheExpiresAt = GetGameTimer() + 60000
      p:resolve(serverData)
    end, resolvedPropertyId)

    lastManageFetchPropertyId = resolvedPropertyId
    manageServerData = Citizen.Await(p)

    -- Persist returned financial info into Properties table (matches original behavior)
    Properties[resolvedPropertyId].bills = manageServerData.bills
    Properties[resolvedPropertyId].unpaidRentBills = manageServerData.unpaidRentBills
    Properties[resolvedPropertyId].unpaidBills = manageServerData.unpaidBills
  end

  -- Ownership / rental checks against current player identifier
  local isOwner = false
  if propertyData.owner then
    isOwner = (propertyData.owner == Identifier)
  end

  local isRenter = false
  if propertyData.renter then
    isRenter = (propertyData.renter == Identifier)
  end

  -- Build NUI payload
  local payload = {
    action = "Property",
    actionName = "OpenManage",
    data = {}
  }

  local myPerms = propertyData.permissions and propertyData.permissions[Identifier] or {}
  local decodedKeys = json.decode(propertyData.keys)

  -- Core data
  payload.data.type = propertyData.type
  payload.data.isObject = (propertyData.object_id ~= nil)
  payload.data.isDevice = isDevice
  payload.data.isOwner = isOwner
  payload.data.isRenter = isRenter
  payload.data.renter = propertyData.renter
  payload.data.renterName = propertyData.renter_name
  payload.data.myPermissions = myPerms

  payload.data.bills = propertyData.bills
  payload.data.unpaidBills = propertyData.unpaidBills
  payload.data.unpaidRentBills = propertyData.unpaidRentBills

  payload.data.keys = decodedKeys
  payload.data.deliveries = Config.Deliveries

  payload.data.name = propertyData.name
  payload.data.description = propertyData.description
  payload.data.address = propertyData.address
  payload.data.region = propertyData.region

  payload.data.electricity = regionData and regionData.electricity or nil
  payload.data.internet = regionData and regionData.internet or nil
  payload.data.water = regionData and regionData.water or nil

  payload.data.isInside = isInside
  payload.data.lastEnter = propertyData.last_enter

  -- Garage / parking info
  payload.data.garage = (propertyData.metadata and propertyData.metadata.garage ~= nil) or false
  if propertyData.metadata and propertyData.metadata.parking then
    payload.data.parking = #propertyData.metadata.parking
  else
    payload.data.parking = false
  end

  -- Sale / rental info
  payload.data.sale = propertyData.sale
  payload.data.rental = propertyData.rental
  payload.data.keysLimit = propertyData.metadata and propertyData.metadata.keysLimit or nil

  -- Furniture limit derived from upgrades
  payload.data.furnitureLimit = GetFurnitureLimit(propertyData.metadata and propertyData.metadata.upgrades)

  -- Auto-sell price (kept identical to the original logic, even though it looks odd)
  local autoSellPrice = nil
  autoSellPrice = propertyData.sale and propertyData.sale.defaultPrice
  if autoSellPrice then
    local defaultPrice = propertyData.sale.defaultPrice
    local _unusedMultiplier = (Config.AutomaticSell / 100) -- computed in original but not actually used
    autoSellPrice = (defaultPrice >= 1 and defaultPrice) -- becomes false if < 1
  end
  payload.data.autoSellPrice = autoSellPrice

  -- If owner/renter, include full permission table
  if isOwner or isRenter then
    payload.data.permissions = propertyData.permissions
  end

  -- Furniture-related extras, only if user has "furniture" permission
  if library.HasPermissions(resolvedPropertyId, "furniture") then
    payload.data.furniture = propertyData.furniture
    payload.data.allowedInside = propertyData.metadata and propertyData.metadata.allowFurnitureInside
    payload.data.allowedOutside = propertyData.metadata and propertyData.metadata.allowFurnitureOutside

    -- Wardrobe / Storage presence checks
    payload.data.hasWardrobe = (propertyData.metadata and propertyData.metadata.wardrobe and propertyData.metadata.wardrobe.x ~= nil) or false
    payload.data.hasStorage = (propertyData.metadata and propertyData.metadata.storage and propertyData.metadata.storage.x ~= nil) or false
  end

  -- Upgrades manage data, only if user has "upgradesManage" permission
  if library.HasPermissions(resolvedPropertyId, "upgradesManage") then
    payload.data.upgrades = Config.HousingUpgrades
    payload.data.ownUpgrades = {}

    for _, upgradeDef in pairs(Config.HousingUpgrades) do
      if propertyData.metadata and propertyData.metadata.upgrades then
        local upgradeKey = upgradeDef.metadata
        local ownedValue = propertyData.metadata.upgrades[upgradeKey]
        if ownedValue then
          payload.data.ownUpgrades[upgradeKey] = ownedValue
        end
      end
    end
  end

  -- Marketplace manage data, only if user has "marketplaceManage" permission
  if library.HasPermissions(resolvedPropertyId, "marketplaceManage") then
    payload.data.furnished = propertyData.metadata and propertyData.metadata.furnished
    payload.data.contact_number = propertyData.metadata and propertyData.metadata.contact_number
    payload.data.images = propertyData.metadata and propertyData.metadata.images
  end

  -- Open NUI
  SetNuiFocus(true, true)
  SendNUIMessage(payload)
  openedMenu = "PropertyManage"
end

-- Export for other resources
exports("OpenManageMenu", openManageMenu)

-- Close menu (NUI)
function closeManageMenu()
  SendNUIMessage({
    action = "Property",
    actionName = "CloseManage"
  })

  SetNuiFocus(false, false)
  openedMenu = nil

  -- Reset motel manage state (original behavior)
  MotelManageId = nil
end

-- Optional command + key mapping
if Config.HousingManagement and Config.HousingManagement.Command then
  RegisterCommand(Config.HousingManagement.Command, function()
    openManageMenu()
  end)

  if Config.HousingManagement.Key then
    RegisterKeyMapping(
      Config.HousingManagement.Command,
      Config.HousingManagement.Description or "",
      "keyboard",
      Config.HousingManagement.Key
    )
  end
end