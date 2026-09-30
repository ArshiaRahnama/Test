-- Webhooks (filled by server later)
OBJECTS_PHOTOS_TOOL_WEBHOOK = nil
MARKETPLACE_PHOTOS_WEBHOOK  = nil

-- Used to avoid actions until server data arrives after restart
waitingForLoadAfterRestart = true

-- Runtime state containers
AlarmBlips    = {}
Blips         = {}
TargetPoints  = {}
Properties    = {}
Furniture     = {}

-- Current “session” state
CurrentShell        = nil
CurrentIPL          = nil
CurrentProperty     = nil
CurrentPropertyData = nil
SelectedApartment   = nil
openedMenu          = nil

-- Player state
PlayerData     = {}
Identifier     = nil
CharacterName  = ""

-- Core bridge (ESX / QB)
if Config.Core == "ESX" then
  ESX = Config.CoreExport()
elseif Config.Core == "QB-Core" then
  QBCore = Config.CoreExport()
end

--[[
  initializeHousing(isResourceRestart, playerData)

  Starts housing initialization on a separate thread:
  - Stores player data & identifiers
  - Spawns player in last property if needed
  - Fires local init event
  - Notifies NUI the client is loaded (after optional delay)
  - Requests server-side data
]]
local function initializeHousing(isResourceRestart, playerData)
  Citizen.CreateThread(function()
    -- Cache player data / identifiers
    PlayerData = (type(playerData) == "table") and playerData or {}

    -- Some frameworks/inventories can populate identifier a moment after the player-loaded event.
    -- If we don't wait, permission-gated targets (e.g. "Manage") may never appear until resource restart.
    local function refreshPlayerData()
      local data = CL.GetPlayerData and CL.GetPlayerData() or nil
      if type(data) == "table" then
        PlayerData = data
      end
    end

    refreshPlayerData()

    Identifier = CL.GetPlayerIdentifier()
    if not Identifier or Identifier == "" then
      local deadline = GetGameTimer() + 10000
      while (not Identifier or Identifier == "") and GetGameTimer() < deadline do
        Citizen.Wait(200)
        refreshPlayerData()
        Identifier = CL.GetPlayerIdentifier()
      end
    end

    CharacterName = CL.GetPlayerCharacterName() or ""

    -- Restore last property if applicable
    SpawnInLastProperty()

    -- Local init hook for other scripts
    TriggerEvent("vms_housing:init")

    -- Original behavior: wait 5s only when called from resource restart path
    Citizen.Wait(isResourceRestart and 5000 or 0)

    -- [NUI] Inform UI that client finished loading and pass character name
    SendNUIMessage({
      action = "loaded2",
      characterName = CharacterName,
    })

    -- [SERVER CALL] Ask server to send housing data (properties, furniture, webhooks, etc.)
    TriggerServerEvent("vms_housing:sv:fetchData")
  end)
end

-- Network notification passthrough
RegisterNetEvent("vms_housing:notification", CL.Notification)

-- Direct admin properties response (fallback when client cache is empty)
RegisterNetEvent("vms_housing:cl:adminProperties")
AddEventHandler("vms_housing:cl:adminProperties", function(propertiesJson)
  if not propertiesJson or propertiesJson == "" then return end
  local ok, decoded = pcall(json.decode, propertiesJson)
  if ok and decoded then
    -- merge into Properties without overwriting full data
    for id, prop in pairs(decoded) do
      if not Properties[id] then
        Properties[id] = prop
      end
    end
    local count = 0
    for _ in pairs(Properties) do count = count + 1 end
    print("[vms_housing] cl:adminProperties merged -> " .. count .. " total")
  end
end)

-- Resource start: ensure framework object exists, then init if player is already loaded
AddEventHandler("onResourceStart", function(resourceName)
  if resourceName ~= GetCurrentResourceName() then
    return
  end

  -- Wait until the framework object is ready
  if Config.Core == "ESX" then
    while not ESX do
      Citizen.Wait(200)
    end
  else
    while not QBCore do
      Citizen.Wait(200)
    end
  end

  -- If player already loaded, initialize (restart path = true)
  if CL.IsPlayerLoaded() then
    initializeHousing(true, CL.GetPlayerData())
  end
end)

-- Resource stop cleanup: exit house, reset weather, delete shell, remove furniture, delete marketplace ped
AddEventHandler("onResourceStop", function(resourceName)
  if resourceName ~= GetCurrentResourceName() then
    return
  end

  if CurrentProperty then
    -- [SERVER CALL] ensure server-side state is cleaned up
    TriggerServerEvent("vms_housing:sv:exitHouse", CurrentProperty)

    -- Restore weather if the script toggled it
    if ToggleWeather then
      ToggleWeather(false)
    end

    -- Remove shell entity if spawned
    if CurrentShell then
      DeleteObject(CurrentShell)
    end
  end

  -- Remove spawned furniture (local cleanup)
  Property:RemoveFurniture()

  -- Remove marketplace ped if spawned
  if Config.Marketplace.__ped then
    DeleteEntity(Config.Marketplace.__ped)
  end
end)

-- Player loaded event (framework-specific name is stored in Config.PlayerLoaded)
RegisterNetEvent(Config.PlayerLoaded, function(coreNameOrNil)
  -- Original logic preserved exactly:
  -- - Always calls initializeHousing(false, something)
  -- - The "something" depends on the condition below.
  local initPlayerData = coreNameOrNil or Config.Core

  -- NOTE: This condition is odd but kept identical to the original.
  -- If it runs, initPlayerData becomes CL.GetPlayerData().
  if initPlayerData ~= "ESX" or not coreNameOrNil then
    initPlayerData = CL.GetPlayerData()
  end

  initializeHousing(false, initPlayerData)
end)

-- Job update event (framework-specific name is stored in Config.PlayerSetJob)
RegisterNetEvent(Config.PlayerSetJob, function(jobData)
  PlayerData.job = jobData
end)

--[[
  Loads properties list sent by server.
  Also registers door data for MLO properties that contain metadata.doors.
]]
RegisterNetEvent("vms_housing:cl:loadProperties", function(propertiesJson)
  if not propertiesJson or propertiesJson == "" then
    print("[vms_housing] cl:loadProperties received nil/empty payload!")
    Properties = {}
    return
  end
  local ok, decoded = pcall(json.decode, propertiesJson)
  if not ok or not decoded then
    print("[vms_housing] cl:loadProperties json.decode FAILED: " .. tostring(decoded))
    Properties = {}
    return
  end
  Properties = decoded
  local count = 0
  for _ in pairs(Properties) do count = count + 1 end
  print("[vms_housing] cl:loadProperties OK - " .. count .. " properties loaded on client")

  -- Update cached CurrentPropertyData if we're already inside a property
  if CurrentProperty then
    CurrentPropertyData = Properties[tostring(CurrentProperty)]
  end

  -- Register MLO doors (if provided)
  for propertyId, propertyData in pairs(Properties) do
    if propertyData.type == "mlo"
      and propertyData.metadata
      and propertyData.metadata.doors
    then
      -- NOTE: This "forceLock" computation is preserved exactly from the obfuscated code.
      -- It ends up always being false/nil due to overwritten assignment, but we keep it as-is.
      local forceLockValue = propertyData.owner
      forceLockValue = propertyData.renter
      forceLockValue = (not forceLockValue) and forceLockValue

      Property:RegisterDoors({
        propertyId = propertyId,
        forceLock  = forceLockValue,
        doors      = propertyData.metadata.doors,
      })
    end
  end
end)

--[NUI] Loads available furniture list into the UI
RegisterNetEvent("vms_housing:cl:loadFurniture", function(furnitureJson)
  Furniture = json.decode(furnitureJson)

  SendNUIMessage({
    action = "Property",
    actionName = "ReloadAvailableFurniture",
    data = Furniture,
  })
end)

-- Server confirms data fetch + provides webhooks, then refreshes blips
RegisterNetEvent("vms_housing:cl:fetchedData", function(objectsPhotosWebhook, marketplacePhotosWebhook)
  waitingForLoadAfterRestart = false

  OBJECTS_PHOTOS_TOOL_WEBHOOK = objectsPhotosWebhook
  MARKETPLACE_PHOTOS_WEBHOOK  = marketplacePhotosWebhook

  -- [NUI] Provide webhook to UI tool
  SendNUIMessage({
    action = "LoadWebhook",
    webhook = OBJECTS_PHOTOS_TOOL_WEBHOOK,
  })

  -- Debug counts (async)
  if Config.Debug then
    Citizen.CreateThread(function()
      local propertiesCount = 0
      for _ in pairs(Properties) do
        propertiesCount = propertiesCount + 1
      end

      library.Debug(("^4[Loaded]^7 Loaded %s Properties!"):format(propertiesCount))

      local furnitureCount = 0
      for _ in pairs(Furniture) do
        furnitureCount = furnitureCount + 1
      end

      library.Debug(("^4[Loaded]^7 Loaded %s Furniture!"):format(furnitureCount))
    end)
  end

  -- Refresh map markers after data is loaded
  RefreshBlips()
end)

--[[
  setupMarketplace()

  Spawns marketplace NPC + blip (if enabled) and registers a target zone to open the marketplace UI.
]]
local function setupMarketplace()
  local marketplaceCfg = Config.Marketplace
  if not marketplaceCfg.Enabled then
    return
  end

  -- Spawn marketplace ped
  if marketplaceCfg.Ped and marketplaceCfg.Ped.Model and marketplaceCfg.Ped.Coords then
    marketplaceCfg.__ped = library.SpawnPed({
      model = marketplaceCfg.Ped.Model,
      coords = marketplaceCfg.Ped.Coords,
      animation = marketplaceCfg.Ped.Animation,
    })
  end

  -- Create marketplace blip
  if marketplaceCfg.Blip and marketplaceCfg.BlipCoords then
    marketplaceCfg.__blip = library.CreateBlip({
      coords = marketplaceCfg.BlipCoords,
      sprite = marketplaceCfg.Blip.sprite,
      display = marketplaceCfg.Blip.display,
      scale = marketplaceCfg.Blip.scale,
      color = marketplaceCfg.Blip.color,
      name = marketplaceCfg.Blip.name,
    })
  end

  -- Target interaction zone
  CL.Target("zone", {
    coords = marketplaceCfg.TargetCoords.xyz,
    rotation = marketplaceCfg.TargetCoords.w,
    size = marketplaceCfg.TargetSize,
    options = {
      {
        name = "marketplace",
        icon = "fa-solid fa-building",
        label = TRANSLATE("target.marketplace"),
        action = function()
          openMarketplace()
        end,
      },
    },
  })
end

-- Compatibility info + marketplace init (async boot thread)
Citizen.CreateThread(function()
  Citizen.Wait(2000)

  -- Print compatibility status for optional integrations (kept logically identical)
  if Config.Weather then
    library.Debug(("^2[Compatibility]^7 Found Compatible Weather: ^3%s^7"):format(Config.Weather))
  else
    library.Debug("^1[Compatibility]^7 No compatible weather found!")
  end

  if Config.Clothing then
    library.Debug(("^2[Compatibility]^7 Found Compatible Clothing: ^3%s^7"):format(Config.Clothing))
  else
    library.Debug("^1[Compatibility]^7 No compatible clothing found!")
  end

  if Config.Garages then
    library.Debug(("^2[Compatibility]^7 Found Compatible Garage: ^3%s^7"):format(Config.Garages))
  else
    library.Debug("^1[Compatibility]^7 No compatible garage found!")
  end

  if Config.Inventory then
    library.Debug(("^2[Compatibility]^7 Found Compatible Inventory: ^3%s^7"):format(Config.Inventory))
  else
    library.Debug("^1[Compatibility]^7 No compatible inventory found!")
  end

  -- Initialize marketplace features
  setupMarketplace()
end)
