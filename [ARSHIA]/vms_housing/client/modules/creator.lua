--[[-----------------------------------------------------------------------------
  VMS Housing - Housing Creator (cleaned / deobfuscated)
  - Renamed obfuscated locals to meaningful names
  - Removed massive repetition with small helper functions (same behavior)
  - Added comments and "ASYNC"/"SERVER EVENT" markers
  - Kept logic intact for all code included in the provided snippet

  NOTE:
  Your paste ends mid-function at: `function L23_1(A0_2) ...`
  Everything below is the cleaned equivalent of everything you provided up to that cut.
-----------------------------------------------------------------------------]]--

-- ============================================================================
-- Creator runtime flags (were L0_1 .. L17_1)
-- ============================================================================

local isDrawingPolyzone = false           -- was L0_1
local isDrawingInteriorZone = false       -- was L1_1

local isPlacingEnterPoint = false         -- was L2_1
local isPlacingExitPoint = false          -- was L3_1
local isPlacingEmergencyInside = false    -- was L4_1
local isPlacingEmergencyOutside = false   -- was L5_1
local isPlacingMenuPoint = false          -- was L6_1

local isPlacingDoors = false              -- was L7_1
local isDoubleDoorMode = false            -- was L8_1 (used by keyControls in the original script)
local isLongDoorDistanceMode = false      -- was L9_1 (sets doorsDistance to 8.5)

local isPlacingDeliveryPoint = false      -- was L10_1
local isPlacingGaragePoint = false        -- was L11_1
local isPlacingEnterGaragePoint = false   -- was L12_1
local isPlacingParkingSpaces = false      -- was L13_1

local isPlacingWardrobe = false           -- was L14_1
local isPlacingStorage = false            -- was L15_1

local skipEnterForWardrobe = false        -- was L16_1 (when true: don’t EnterShell/EnterIPL)
local skipEnterForStorage = false         -- was L17_1 (when true: don’t EnterShell/EnterIPL)

-- These existed in the original header but aren’t fully shown/used in the pasted portion
-- NOTE: global on purpose (shared with raycast helpers / door selection)
lastRaycastHitEntity = nil               -- was L18_1 (best-effort name)
local currentDoorIndex = nil              -- was L19_1
local currentParkingIndex = nil           -- was L20_1

-- ============================================================================
-- House creation config template (was L21_1 “houseConfiguration” setup)
-- ============================================================================

local function newHouseCreationConfig()
  return {
    previousCoords = nil,

    -- type: "shell" | "ipl" | "mlo" | "building" | "motel"
    type = nil,
    shell = nil,
    ipl = nil,

    address = nil,
    region = nil,

    zone = { points = {}, minZ = -90.0, maxZ = 90.0 },
    interiorZone = { points = {}, minZ = -90.0, maxZ = 90.0 },

    doors = {},
    doorsDistance = 2.0,

    enterGarageCoords = { x = 0.0, y = 0.0, z = 0.0, w = 0.0 },
    enterCoords       = { x = 0.0, y = 0.0, z = 0.0 },
    exitCoords        = { x = 0.0, y = 0.0, z = 0.0, w = 0.0 },

    emergencyInsideCoords  = { x = 0.0, y = 0.0, z = 0.0 },
    emergencyOutsideCoords = { x = 0.0, y = 0.0, z = 0.0, w = 0.0 },

    menuCoords = { x = 0.0, y = 0.0, z = 0.0, w = 0.0 },

    __garageVehicleObj = nil,
    garageCoords = { x = 0.0, y = 0.0, z = 0.0, w = 0.0 },
    parkingSpaces = {},

    wardrobeCoords = { x = 0.0, y = 0.0, z = 0.0 },
    storageCoords  = { x = 0.0, y = 0.0, z = 0.0 },

    __deliveryObj = nil,
    deliveryPoint = { x = 0.0, y = 0.0, z = 0.0, w = 0.0 },
  }
end

houseConfiguration = newHouseCreationConfig()

function resetHouseCreationTable()
  houseConfiguration = newHouseCreationConfig()
end

-- ============================================================================
-- Small helpers (reduce repetition, keep same behavior)
-- ============================================================================

local function showControlsMenu(toggle, label, name)
  -- NUI Controls overlay
  local payload = { action = "ControlsMenu", toggle = toggle }
  if toggle then
    payload.controlsLabel = label
    payload.controlsName = name
  end
  SendNUIMessage(payload)
end

local function showCreatorMenu()
  if openedMenu ~= "HousingCreator" then
    return
  end

  SendNUIMessage({
    action = "HousingCreator",
    actionName = "Update",
    data = { type = "show-menu" }
  })
  SetNuiFocus(true, true)
end

local function drawZoneWalls(zone)
  -- Draws the same vertical lines + “walls” as the original repeated loops.
  local points = zone.points
  if #points < 1 then return end

  for i = 1, #points do
    local p1 = points[i]
    DrawLine(p1.x, p1.y, zone.minZ, p1.x, p1.y, zone.maxZ, 178, 128, 255, 230)

    local p2 = points[i + 1] or points[1]
    _drawWall(p1, p2, zone.minZ, zone.maxZ, 114, 49, 212)
  end
end

local function cleanupShellAndReturnToPreviousCoords()
  if CurrentShell then
    DeleteObject(CurrentShell)
    CurrentShell = false
  end

  if houseConfiguration.previousCoords then
    SetEntityCoords(PlayerPedId(), houseConfiguration.previousCoords.xyz)
  end

  CurrentIPL = nil
end

local function cleanupIPLReturn()
  -- IPL doesn’t create an object here; we just return to previous coords (same as original)
  if houseConfiguration.previousCoords then
    SetEntityCoords(PlayerPedId(), houseConfiguration.previousCoords.xyz)
  end
  CurrentIPL = nil
end

-- ============================================================================
-- Open creator UI
-- ============================================================================

function OpenHousingCreator()
  -- Optional job restriction
  if Config.HousingCreator.RequiredJob then
    local jobName = CL.GetPlayerJob("name")
    if jobName ~= Config.HousingCreator.RequiredJob then
      return
    end
  end

  if openedMenu == "HousingCreator" then
    return
  end

  resetHouseCreationTable()

  -- NUI: Open creator
  SendNUIMessage({ action = "HousingCreator", actionName = "Open" })
  SetNuiFocus(true, true)
  openedMenu = "HousingCreator"
end

-- Command / Key mapping
if Config.HousingCreator.Command then
  RegisterCommand(Config.HousingCreator.Command, function()
    OpenHousingCreator()
  end)

  if Config.HousingCreator.Key then
    RegisterKeyMapping(
      Config.HousingCreator.Command,
      Config.HousingCreator.Description or "",
      "keyboard",
      Config.HousingCreator.Key
    )
  end
end

-- ============================================================================
-- HousingCreator “class” (was L21_1 table)
-- ============================================================================

HousingCreator = { camera = nil }

function HousingCreator:CreateCamera(raiseCamera, onCreated)
  local camPos = GetGameplayCamCoord()
  local camRot = GetGameplayCamRot(2)
  local camFov = GetGameplayCamFov()

  self.camera = CreateCam("DEFAULT_SCRIPTED_CAMERA", true)

  -- Original behavior:
  -- If NOT raiseCamera -> add +20.0 to Z, else add -1.0 to Z (kept exactly)
  local zOffset = (raiseCamera and -1.0) or 20.0
  SetCamCoord(self.camera, camPos.x, camPos.y, camPos.z + zOffset)
  SetCamRot(self.camera, camRot.x, camRot.y, camRot.z, 2)
  SetCamFov(self.camera, camFov)

  RenderScriptCams(true, true, 500, true, true)
  FreezeEntityPosition(PlayerPedId(), true)

  if onCreated then
    onCreated(self.camera)
  end
end

function HousingCreator:DeleteCamera()
  if not self.camera then return end

  RenderScriptCams(false, true, 500, true, true)
  SetCamActive(self.camera, false)
  DetachCam(self.camera)
  DestroyCam(self.camera, true)

  self.camera = nil
end

-- ============================================================================
-- Polyzone drawing (outside zone / interior zone)
-- ============================================================================

function HousingCreator:Polyzone(isInteriorZone)
  if isInteriorZone then
    isDrawingInteriorZone = true
    -- Snapshot for cancel/restore
    houseConfiguration.__interiorZoneSnapshot = library.Deepcopy(houseConfiguration.interiorZone)
  else
    -- Snapshot for cancel/restore
    houseConfiguration.__zoneSnapshot = library.Deepcopy(houseConfiguration.zone)
  end

  isDrawingPolyzone = true

  self:CreateCamera()

  showControlsMenu(
    true,
    isInteriorZone and "creator:interiorzone" or "creator:polyzone",
    "HousingCreator:polyzone"
  )

  -- [ASYNC] Drawing loop while the user is placing polygon points via raycast + keyControls (elsewhere)
  Citizen.CreateThread(function()
    while isDrawingPolyzone do
      startRaycast(self.camera)

      rotateCamInputs()
      moveCamInputs()
      DisabledControls()
      keyControls()

      if isDrawingInteriorZone then
        drawZoneWalls(houseConfiguration.interiorZone)
      else
        drawZoneWalls(houseConfiguration.zone)
      end

      Citizen.Wait(0)
    end

    showControlsMenu(false)
    FreezeEntityPosition(PlayerPedId(), false)
    self:DeleteCamera()
    showCreatorMenu()
  end)
end

-- ============================================================================
-- Point placement helpers (enter/exit/menu/emergency/garage/etc.)
-- ============================================================================

function HousingCreator:CreateEnterPoint()
  isPlacingEnterPoint = true

  showControlsMenu(true, "creator:enter", "HousingCreator:default")

  -- [ASYNC] Placement loop (raycast + keyControls handled elsewhere)
  Citizen.CreateThread(function()
    while isPlacingEnterPoint do
      startRaycast()
      DisabledControls()
      keyControls()
      drawZoneWalls(houseConfiguration.zone)
      Citizen.Wait(0)
    end

    showControlsMenu(false)
    showCreatorMenu()
  end)
end

function HousingCreator:CreateExitPoint()
  isPlacingExitPoint = true

  showControlsMenu(true, "creator:exit", "HousingCreator:default")

  -- [ASYNC] Placement loop: shows a marker at the player and passes coords to keyControls()
  Citizen.CreateThread(function()
    while isPlacingExitPoint do
      local ped = PlayerPedId()
      local coords = GetEntityCoords(ped)
      local heading = GetEntityHeading(ped)

      DrawMarker(
        26,
        coords.x, coords.y, coords.z - 0.9,
        0.0, 0.0, 0.0,
        0.0, 0.0, heading,
        1.0, 1.0, 1.0,
        159, 15, 255, 145
      )

      DisabledControls()
      keyControls(coords)

      drawZoneWalls(houseConfiguration.zone)
      Citizen.Wait(0)
    end

    showControlsMenu(false)
    showCreatorMenu()
  end)
end

function HousingCreator:CreateEmergencyExitOutsidePoint()
  isPlacingEmergencyOutside = true

  showControlsMenu(true, "creator:emergency_exit", "HousingCreator:default")

  -- [ASYNC] Placement loop (marker + keyControls)
  Citizen.CreateThread(function()
    while isPlacingEmergencyOutside do
      local ped = PlayerPedId()
      local coords = GetEntityCoords(ped)
      local heading = GetEntityHeading(ped)

      DrawMarker(
        26,
        coords.x, coords.y, coords.z - 0.9,
        0.0, 0.0, 0.0,
        0.0, 0.0, heading,
        1.0, 1.0, 1.0,
        159, 15, 255, 145
      )

      DisabledControls()
      keyControls(coords)

      drawZoneWalls(houseConfiguration.zone)
      Citizen.Wait(0)
    end

    showControlsMenu(false)
    showCreatorMenu()
  end)
end

function HousingCreator:CreateEmergencyExitInsidePoint(_unused, iplTheme)
  isPlacingEmergencyInside = true

  showControlsMenu(true, "creator:emergency_exit", "HousingCreator:default")

  -- [ASYNC] Enters interior first (shell or IPL), then placement loop, then cleanup/return
  Citizen.CreateThread(function()
    if houseConfiguration.shell then
      HousingCreator:EnterShell(houseConfiguration.shell)
    elseif houseConfiguration.ipl then
      HousingCreator:EnterIPL(houseConfiguration.ipl, nil, iplTheme)
    end

    while isPlacingEmergencyInside do
      startRaycast()
      DisabledControls()
      keyControls()
      drawZoneWalls(houseConfiguration.zone)
      Citizen.Wait(0)
    end

    showControlsMenu(false)

    -- Cleanup & return
    if CurrentShell then
      DeleteObject(CurrentShell)
      CurrentShell = false
    end

    if houseConfiguration.previousCoords then
      SetEntityCoords(PlayerPedId(), houseConfiguration.previousCoords.xyz)
    end

    CurrentIPL = nil
    showCreatorMenu()
  end)
end

function HousingCreator:CreateMenuPoint()
  isPlacingMenuPoint = true

  showControlsMenu(true, "creator:menu", "HousingCreator:default")

  -- [ASYNC] Placement loop
  Citizen.CreateThread(function()
    while isPlacingMenuPoint do
      startRaycast()
      DisabledControls()
      keyControls()
      drawZoneWalls(houseConfiguration.zone)
      Citizen.Wait(0)
    end

    showControlsMenu(false)
    showCreatorMenu()
  end)
end

-- ============================================================================
-- Garage placement (spawns a preview vehicle and moves it via keyControls elsewhere)
-- ============================================================================

local function deletePreviewGarageVehicle()
  if houseConfiguration.__garageVehicleObj ~= nil and DoesEntityExist(houseConfiguration.__garageVehicleObj) then
    DeleteVehicle(houseConfiguration.__garageVehicleObj)
  end
  houseConfiguration.__garageVehicleObj = nil
end

local function spawnPreviewGarageVehicle(modelName)
  deletePreviewGarageVehicle()

  library.RequestEntity(modelName)

  local ped = PlayerPedId()
  local coords = GetEntityCoords(ped)
  local heading = GetEntityHeading(ped)

  houseConfiguration.__garageVehicleObj = CreateVehicle(joaat(modelName), coords, heading, false, true)
  SetEntityCollision(houseConfiguration.__garageVehicleObj, false, true)
end

function HousingCreator:CreateGaragePoint()
  isPlacingGaragePoint = true
  houseConfiguration.garageCoords.w = GetEntityHeading(PlayerPedId())

  showControlsMenu(true, "creator:garage", "HousingCreator:garage")

  -- [ASYNC] Spawn preview vehicle, then placement loop, then cleanup
  Citizen.CreateThread(function()
    spawnPreviewGarageVehicle("baller7")

    while isPlacingGaragePoint do
      startRaycast()
      DisabledControls()
      keyControls()
      drawZoneWalls(houseConfiguration.zone)
      Citizen.Wait(0)
    end

    showControlsMenu(false)
    deletePreviewGarageVehicle()
    showCreatorMenu()
  end)
end

function HousingCreator:CreateEnterGaragePoint()
  isPlacingEnterGaragePoint = true
  houseConfiguration.enterGarageCoords.w = GetEntityHeading(PlayerPedId())

  showControlsMenu(true, "creator:enter_garage", "HousingCreator:enter_garage")

  -- [ASYNC] Spawn preview vehicle, then placement loop, then cleanup
  Citizen.CreateThread(function()
    spawnPreviewGarageVehicle("baller7")

    while isPlacingEnterGaragePoint do
      startRaycast()
      DisabledControls()
      keyControls()
      drawZoneWalls(houseConfiguration.zone)
      Citizen.Wait(0)
    end

    showControlsMenu(false)
    deletePreviewGarageVehicle()
    showCreatorMenu()
  end)
end

-- ============================================================================
-- Parking spaces (camera mode + spawns preview cars for existing spaces)
-- ============================================================================

function HousingCreator:CreateParkingSpaces()
  isPlacingParkingSpaces = true

  self:CreateCamera()

  showControlsMenu(true, "creator:parking", "HousingCreator:parking")

  -- Spawn preview vehicles for existing parking entries (same behavior)
  if #houseConfiguration.parkingSpaces >= 1 then
    library.RequestEntity("baller3")

    for _, space in pairs(houseConfiguration.parkingSpaces) do
      if space.coords then
        local veh = CreateVehicle(
          GetHashKey("baller3"),
          space.coords.x, space.coords.y, space.coords.z, space.coords.w,
          false, true
        )
        space.vehicle = veh
        SetEntityCollision(space.vehicle, false, true)

        Citizen.Wait(5)

        local ok, groundZ = GetGroundZFor_3dCoord(space.coords.x, space.coords.y, space.coords.z, 0)
        if ok then
          SetEntityCoords(space.vehicle, space.coords.x, space.coords.y, groundZ)
          local rot = GetEntityRotation(space.vehicle, 2)
          SetEntityHeading(space.vehicle, space.coords.w)
          SetEntityRotation(space.vehicle, rot.x, rot.y, space.coords.w, 2, true)
        else
          SetEntityCoords(space.vehicle, space.coords.x, space.coords.y, space.coords.z)
          SetEntityHeading(space.vehicle, space.coords.w)
        end

        Citizen.Wait(5)
        FreezeEntityPosition(space.vehicle, true)
      end
    end

    Citizen.Wait(100)

    -- Add a new parking slot entry
    currentParkingIndex = #houseConfiguration.parkingSpaces + 1
    houseConfiguration.parkingSpaces[currentParkingIndex] = { coords = { x = 0.0, y = 0.0, z = 0.0, w = 0.0 } }
    houseConfiguration.parkingSpaces[currentParkingIndex].coords.w = GetEntityHeading(PlayerPedId())

    -- NOTE: original uses global x/y/z variables here (likely set by raycast logic)
    houseConfiguration.parkingSpaces[currentParkingIndex].vehicle = CreateVehicle(
      GetHashKey("baller3"),
      x, y, z,
      houseConfiguration.parkingSpaces[currentParkingIndex].coords.w,
      false, true
    )
    SetEntityCollision(houseConfiguration.parkingSpaces[currentParkingIndex].vehicle, false, true)
    FreezeEntityPosition(houseConfiguration.parkingSpaces[currentParkingIndex].vehicle, true)
  else
    -- First parking slot
    currentParkingIndex = 1
    houseConfiguration.parkingSpaces[currentParkingIndex] = {}

    library.RequestEntity("baller3")

    houseConfiguration.parkingSpaces[currentParkingIndex].coords = { x = 0.0, y = 0.0, z = 0.0, w = 0.0 }
    houseConfiguration.parkingSpaces[currentParkingIndex].coords.w = GetEntityHeading(PlayerPedId())

    -- NOTE: original uses global x/y/z variables here (likely set by raycast logic)
    houseConfiguration.parkingSpaces[currentParkingIndex].vehicle = CreateVehicle(
      GetHashKey("baller3"),
      x, y, z,
      houseConfiguration.parkingSpaces[currentParkingIndex].coords.w,
      false, true
    )
    SetEntityCollision(houseConfiguration.parkingSpaces[currentParkingIndex].vehicle, false, true)
    FreezeEntityPosition(houseConfiguration.parkingSpaces[currentParkingIndex].vehicle, true)
  end

  -- [ASYNC] Camera-driven placement loop
  Citizen.CreateThread(function()
    while isPlacingParkingSpaces do
      startRaycast(self.camera)

      rotateCamInputs()
      moveCamInputs()
      DisabledControls()
      keyControls()

      drawZoneWalls(houseConfiguration.zone)

      Citizen.Wait(0)
    end

    showControlsMenu(false)

    if houseConfiguration.parkingSpaces and #houseConfiguration.parkingSpaces >= 1 then
      for _, space in pairs(houseConfiguration.parkingSpaces) do
        if space.vehicle and DoesEntityExist(space.vehicle) then
          DeleteVehicle(space.vehicle)
        end
        space.vehicle = nil
      end
    end

    FreezeEntityPosition(PlayerPedId(), false)
    self:DeleteCamera()
    showCreatorMenu()
  end)
end

-- ============================================================================
-- Wardrobe / Storage (optionally enters interior first)
-- ============================================================================

local function enterInteriorIfNeeded(iplTheme)
  if houseConfiguration.shell then
    HousingCreator:EnterShell(houseConfiguration.shell)
  elseif houseConfiguration.ipl then
    HousingCreator:EnterIPL(houseConfiguration.ipl, nil, iplTheme)
  end
end

function HousingCreator:CreateWardrobePoint(alreadyInside, iplTheme)
  if alreadyInside then
    skipEnterForWardrobe = true
  end

  isPlacingWardrobe = true

  showControlsMenu(true, "creator:wardrobe", "HousingCreator:default")

  -- [ASYNC] Optionally enter interior, then placement loop, then cleanup
  Citizen.CreateThread(function()
    if not skipEnterForWardrobe then
      enterInteriorIfNeeded(iplTheme)
    end

    while isPlacingWardrobe do
      startRaycast()
      DisabledControls()
      keyControls()

      -- If not in shell/ipl, and not mlo, it draws interiorZone lines (same checks as original)
      if not houseConfiguration.shell and not houseConfiguration.ipl then
        drawZoneWalls(houseConfiguration.interiorZone)
      end

      Citizen.Wait(0)
    end

    showControlsMenu(false)

    if not skipEnterForWardrobe then
      cleanupShellAndReturnToPreviousCoords()
    end

    -- Reset the “already inside” flag (matches original)
    skipEnterForWardrobe = false
    showCreatorMenu()
  end)
end

function HousingCreator:CreateStoragePoint(alreadyInside, iplTheme)
  if alreadyInside then
    skipEnterForStorage = true
  end

  isPlacingStorage = true

  showControlsMenu(true, "creator:storage", "HousingCreator:default")

  -- [ASYNC] Optionally enter interior, then placement loop, then cleanup
  Citizen.CreateThread(function()
    if not skipEnterForStorage then
      enterInteriorIfNeeded(iplTheme)
    end

    while isPlacingStorage do
      startRaycast()
      DisabledControls()
      keyControls()

      if not houseConfiguration.shell and not houseConfiguration.ipl then
        drawZoneWalls(houseConfiguration.interiorZone)
      end

      Citizen.Wait(0)
    end

    showControlsMenu(false)

    if not skipEnterForStorage then
      cleanupShellAndReturnToPreviousCoords()
    end

    skipEnterForStorage = false
    showCreatorMenu()
  end)
end

-- ============================================================================
-- Delivery point (spawns preview prop; can be inside or outside)
-- ============================================================================

local function deleteDeliveryPreview()
  if houseConfiguration.__deliveryObj ~= nil and DoesEntityExist(houseConfiguration.__deliveryObj) then
    DeleteObject(houseConfiguration.__deliveryObj)
    -- Original also toggled collision after delete attempt (kept)
    SetEntityCollision(houseConfiguration.__deliveryObj, false, true)
  end
  houseConfiguration.__deliveryObj = nil
end

function HousingCreator:CreateDeliveryPoint(_unusedA0, shouldEnterInterior, _unusedA2, iplTheme)
  isPlacingDeliveryPoint = true
  houseConfiguration.deliveryPoint.w = GetEntityHeading(PlayerPedId())

  showControlsMenu(true, "creator:delivery", "HousingCreator:delivery")

  -- [ASYNC] Optionally enter interior, spawn preview prop, then placement loop, then cleanup
  Citizen.CreateThread(function()
    if shouldEnterInterior then
      enterInteriorIfNeeded(iplTheme)
    end

    deleteDeliveryPreview()

    -- Spawn preview prop at player coords
    houseConfiguration.__deliveryObj = library.SpawnProp(
      joaat("prop_boxpile_01a"),
      GetEntityCoords(PlayerPedId()),
      false,
      nil,
      true
    )

    while isPlacingDeliveryPoint do
      startRaycast()
      DisabledControls()
      keyControls()

      -- Drawing logic mirrors the original nested branches:
      if houseConfiguration.shell or houseConfiguration.ipl then
        -- When inside shell/ipl, the original draws nothing here
      else
        if shouldEnterInterior then
          -- inside placement for MLO-like interior polygon
          drawZoneWalls(houseConfiguration.interiorZone)
        else
          -- outside placement uses outside zone
          drawZoneWalls(houseConfiguration.zone)
        end
      end

      Citizen.Wait(0)
    end

    showControlsMenu(false)

    if shouldEnterInterior then
      cleanupShellAndReturnToPreviousCoords()
    end

    CurrentIPL = nil

    DeleteObject(houseConfiguration.__deliveryObj)
    houseConfiguration.__deliveryObj = nil
    showCreatorMenu()
  end)
end

-- ============================================================================
-- Doors (distance + mode flags affect how keyControls behaves elsewhere)
-- ============================================================================

function HousingCreator:CreateDoor(doubleDoor, longDistanceMode)
  -- Snapshot so BACKSPACE can restore previous list without mutating in-place.
  houseConfiguration.__doorsSnapshot = library.Deepcopy(houseConfiguration.doors or {})

  isPlacingDoors = true
  houseConfiguration.doorsDistance = 1.5

  if doubleDoor then
    isDoubleDoorMode = true
  end

  if longDistanceMode then
    isLongDoorDistanceMode = true
    houseConfiguration.doorsDistance = 8.5
  end

  showControlsMenu(true, "creator:doors", "HousingCreator:doors")

  -- [ASYNC] Placement loop (raycast + keyControls elsewhere) while drawing outer zone
  Citizen.CreateThread(function()
    if not houseConfiguration.doors then
      houseConfiguration.doors = {}
    end

    currentDoorIndex = #houseConfiguration.doors + 1

    while isPlacingDoors do
      startRaycast()
      DisabledControls()
      keyControls()
      drawZoneWalls(houseConfiguration.zone)
      Citizen.Wait(0)
    end

    showControlsMenu(false)
    houseConfiguration.__doorsSnapshot = nil
    showCreatorMenu()
  end)
end

function HousingCreator:RemoveDoor(index)
  if houseConfiguration.doors[index] then
    table.remove(houseConfiguration.doors, index)
  end

  -- NUI: update doors list
  SendNUIMessage({
    action = "HousingCreator",
    actionName = "Update",
    data = {
      type = "update-doors-list",
      value = houseConfiguration.doors
    }
  })
end

-- ============================================================================
-- Save house / furniture (SERVER EVENTS)
-- ============================================================================

function HousingCreator:Save(uiData)
  local address = houseConfiguration.address
  local region = houseConfiguration.region

  -- Name depends on type (building/motel/house)
  local name
  if houseConfiguration.type == "building" and uiData.buildingName then
    name = uiData.buildingName
  elseif houseConfiguration.type == "motel" and uiData.motelName then
    name = uiData.motelName
  else
    name = uiData.houseName
  end

  local description = uiData.houseDescription or ""

  -- Metadata tables built exactly like the original logic
  local metadata = {}
  local sale = { defaultActive = false, defaultPrice = 0 }
  local rental = { defaultActive = false, defaultPrice = 0 }

  -- For shell/ipl/mlo, the original initializes these metadata defaults
  if houseConfiguration.type == "shell" or houseConfiguration.type == "ipl" or houseConfiguration.type == "mlo" then
    metadata.upgrades = {}
    metadata.lightState = false
    metadata.locked = false

    if not uiData.building and not uiData.motel then
      -- Outside zone only for non-building/motel
      metadata.zone = houseConfiguration.zone
      metadata.zone.area = calculatePolygonArea(houseConfiguration.zone.points)
      metadata.allowFurnitureOutside = uiData.allowFurnitureOutside
    end

    -- Enter/exit are only set for shell/ipl in this block (matches original’s checks)
    if houseConfiguration.type == "shell" or houseConfiguration.type == "ipl" then
      metadata.enter = houseConfiguration.enterCoords
      metadata.exit = houseConfiguration.exitCoords
    end
  end

  -- Wardrobe
  if uiData.isWardrobe then
    metadata.wardrobe = houseConfiguration.wardrobeCoords
  end

  -- Storage
  if uiData.isStorage then
    metadata.storage = houseConfiguration.storageCoords
    metadata.storage.slots = tonumber(uiData.storageSlots)
    metadata.storage.weight = tonumber(uiData.storageWeight)
  end

  -- Keys limit (keeps original semantics: store string if numeric >= 0)
  if uiData.isKeysLimit and uiData.keysLimit and tonumber(uiData.keysLimit) and tonumber(uiData.keysLimit) >= 0 then
    metadata.keysLimit = uiData.keysLimit
  else
    metadata.keysLimit = nil
  end

  -- Permissions limit (same semantics)
  if uiData.isPermissionsLimit and uiData.permissionsLimit and tonumber(uiData.permissionsLimit) and tonumber(uiData.permissionsLimit) >= 0 then
    metadata.permissionsLimit = uiData.permissionsLimit
  else
    metadata.permissionsLimit = nil
  end

  metadata.allowFurnitureInside = uiData.allowFurnitureInside

  -- Type-specific payloads
  if houseConfiguration.type == "shell" then
    metadata.shell = houseConfiguration.shell

    if uiData.isEmergencyExit then
      metadata.emergencyInside = houseConfiguration.emergencyInsideCoords
      metadata.emergencyOutside = houseConfiguration.emergencyOutsideCoords
    else
      metadata.emergencyInside = nil
      metadata.emergencyOutside = nil
    end
  elseif houseConfiguration.type == "ipl" then
    metadata.ipl = houseConfiguration.ipl

    -- Theme validation logic (same behavior)
    local iplEntry = AvailableIPLS[houseConfiguration.ipl]
    if iplEntry and iplEntry.settings and iplEntry.settings.Themes then
      if iplEntry.settings.Themes[uiData.houseTheme] then
        metadata.iplTheme = uiData.houseTheme
      else
        for firstTheme in pairs(iplEntry.settings.Themes) do
          metadata.iplTheme = firstTheme
          break
        end
      end

      metadata.allowChangeTheme = uiData.allowChangeTheme
      metadata.allowChangeThemePurchased = uiData.allowChangeThemePurchased
    end

    metadata.iplSettings = {}

    if uiData.isEmergencyExit then
      metadata.emergencyInside = houseConfiguration.emergencyInsideCoords
      metadata.emergencyOutside = houseConfiguration.emergencyOutsideCoords
    else
      metadata.emergencyInside = nil
      metadata.emergencyOutside = nil
    end
  elseif houseConfiguration.type == "mlo" then
    metadata.interiorZone = houseConfiguration.interiorZone
    metadata.interiorZone.area = calculatePolygonArea(houseConfiguration.interiorZone.points)

    metadata.menu = houseConfiguration.menuCoords

    -- Copy doors and clear entity references (same behavior)
    if houseConfiguration.doors and next(houseConfiguration.doors) then
      local sanitizedDoors = {}
      for _, doorData in pairs(houseConfiguration.doors) do
        if doorData.type == "double" then
          doorData.left.entity = nil
          doorData.right.entity = nil
        else
          doorData.entity = nil
        end
        table.insert(sanitizedDoors, doorData)
      end
      metadata.doors = sanitizedDoors
    end
  elseif houseConfiguration.type == "building" then
    metadata.zone = houseConfiguration.zone
    metadata.enter = houseConfiguration.enterCoords
    metadata.exit = houseConfiguration.exitCoords

    -- Apartment parking
    local apartmentParking = uiData.apartmentParking
    local parkingFloors = nil

    if apartmentParking then
      metadata.parkingEnter = houseConfiguration.enterGarageCoords
      parkingFloors = uiData.parkingFloors
    end

    -- Preserve original flow variables in the server payload below:
    -- (apartmentParking, parkingFloors)
    uiData.__apartmentParking = apartmentParking
    uiData.__parkingFloors = parkingFloors
  elseif houseConfiguration.type == "motel" then
    metadata.zone = houseConfiguration.zone
  end

  -- Garage
  if uiData.isGarage then
    metadata.garage = houseConfiguration.garageCoords
  end

  -- Parking spaces
  if uiData.isParking then
    metadata.parking = houseConfiguration.parkingSpaces
    if #metadata.parking >= 1 then
      for _, space in pairs(metadata.parking) do
        space.vehicle = nil
      end
    end
  end

  -- Delivery
  if uiData.isDeliveryInside then
    metadata.deliveryType = "inside"
    metadata.delivery = houseConfiguration.deliveryPoint
  elseif uiData.isDeliveryOutside then
    metadata.deliveryType = "outside"
    metadata.delivery = houseConfiguration.deliveryPoint
  else
    metadata.deliveryType = nil
    metadata.delivery = nil
  end

  -- Sale / rental
  if uiData.isPurchase then
    sale.defaultActive = true
    sale.defaultPrice = tonumber(uiData.purchasePrice)
  end

  if uiData.isRent then
    rental.defaultActive = true
    rental.defaultPrice = tonumber(uiData.rentPrice)
  end

  -- Prepare server payload (same fields / encodings)
  local apartmentParking = uiData.__apartmentParking
  local parkingFloors = uiData.__parkingFloors

  local payload = {
    building = uiData.building,
    motel = uiData.motel,
    parkingSpaces = uiData.parkingSpaces,
    apartmentParking = apartmentParking,
    parkingFloors = (apartmentParking and parkingFloors) or uiData.parkingSpaces,

    address = address,
    region = region,
    name = name,
    description = description,

    metadata = json.encode(metadata),
    sale = json.encode(sale),
    rental = json.encode(rental),
  }

  -- [SERVER EVENT] create/modify house
  TriggerServerEvent(
    "vms_housing:sv:createNewHouse",
    houseConfiguration.type,
    payload,
    uiData.isModifying
  )

  resetHouseCreationTable()
end

function HousingCreator:SaveFurniture(uiData)
  -- [SERVER EVENT] modify furniture
  TriggerServerEvent("vms_housing:sv:modifyFurniture", uiData.model, uiData)
end

-- ============================================================================
-- Close creator UI
-- ============================================================================

function HousingCreator:Close()
  SendNUIMessage({ action = "HousingCreator", actionName = "Close" })
  SetNuiFocus(false, false)
  openedMenu = nil
end

-- ============================================================================
-- Enter shell / IPL (teleport preview for placing interior points)
-- ============================================================================

function HousingCreator:EnterShell(shellName, cb)
  if CurrentShell then
    return warn("You are already in shell!")
  end

  if not shellName then
    SendNUIMessage({ action = "HousingCreator", actionName = "Update", data = { type = "show-menu" } })
    SetNuiFocus(true, true)
    return
  end

  if not AvailableShells[shellName] then
    SendNUIMessage({ action = "HousingCreator", actionName = "Update", data = { type = "show-menu" } })
    SetNuiFocus(true, true)
    return warn(("Could not find shell \"%s\"!"):format(shellName))
  end

  local loaded = library.RequestEntity(shellName)
  if not loaded then
    SendNUIMessage({ action = "HousingCreator", actionName = "Update", data = { type = "show-menu" } })
    SetNuiFocus(true, true)
    return warn(("Failed to load shell \"%s\" - make sure it is running!"):format(shellName))
  end

  -- Save previous coords
  houseConfiguration.previousCoords = GetEntityCoords(PlayerPedId())

  FreezeEntityPosition(PlayerPedId(), true)

  DoScreenFadeOut(1500)
  Wait(1500)

  -- Create shell object far above map
  CurrentShell = CreateObjectNoOffset(joaat(shellName), 0.0, 0.0, 500.0, false, false, false)

  while not DoesEntityExist(CurrentShell) do
    Wait(1)
  end

  SetEntityHeading(CurrentShell, 0.0)
  FreezeEntityPosition(CurrentShell, true)

  -- Teleport player to shell doors coords
  local doors = AvailableShells[shellName].doors
  SetEntityCoords(PlayerPedId(), vector3(doors.x, doors.y, doors.z))
  SetEntityHeading(PlayerPedId(), doors.heading)

  Wait(1500)
  DoScreenFadeIn(1500)

  FreezeEntityPosition(PlayerPedId(), false)

  if cb then cb() end
end

function HousingCreator:EnterIPL(iplName, cb, theme)
  if CurrentIPL then
    return warn("You are already in IPL!")
  end

  if not iplName then
    SendNUIMessage({ action = "HousingCreator", actionName = "Update", data = { type = "show-menu" } })
    SetNuiFocus(true, true)
    return
  end

  if not AvailableIPLS[iplName] then
    SendNUIMessage({ action = "HousingCreator", actionName = "Update", data = { type = "show-menu" } })
    SetNuiFocus(true, true)
    return warn(("Could not find shell \"%s\"!"):format(iplName))
  end

  houseConfiguration.previousCoords = GetEntityCoords(PlayerPedId())

  FreezeEntityPosition(PlayerPedId(), true)

  DoScreenFadeOut(1500)
  Wait(1500)

  CurrentIPL = iplName

  -- Apply theme settings if valid
  if theme then
    local entry = AvailableIPLS[iplName]
    if entry and entry.settings and entry.settings.Themes and entry.settings.Themes[theme] then
      IPL.LoadSettings(CurrentIPL, theme)
    end
  end

  local doors = AvailableIPLS[iplName].doors
  SetEntityCoords(PlayerPedId(), vector3(doors.x, doors.y, doors.z))
  SetEntityHeading(PlayerPedId(), doors.heading)

  Wait(1500)
  DoScreenFadeIn(1500)

  FreezeEntityPosition(PlayerPedId(), false)

  if cb then cb() end
end

-- ============================================================================
-- Misc data getters
-- ============================================================================

function HousingCreator:GetObjects(includeBuildings, includeMotels)
  local buildings = {}
  local motels = {}

  for _, property in pairs(Properties) do
    if property.type == "building" and includeBuildings then
      table.insert(buildings, {
        id = property.id,
        label = property.name,
        parkingSpaces = property.metadata and property.metadata.parkingSpaces,
        isMenuBuilding = true
      })
    elseif property.type == "motel" and includeMotels then
      table.insert(motels, {
        id = property.id,
        label = property.name
      })
    end
  end

  return buildings, motels
end

function HousingCreator:GetBuildingParkingSpaces(propertyId)
  local prop = Properties[propertyId]
  if not prop then return nil end
  if prop.metadata and prop.metadata.parkingSpaces then
    return prop.metadata.parkingSpaces
  end
  return nil
end

-- ============================================================================
-- Camera movement / rotation / control disabling
-- ============================================================================

local CAMERA_MAX_DISTANCE = 1580
local CAMERA_MOVE_STEP = 0.18

function moveCamInputs()
  local camPos = GetCamCoord(HousingCreator.camera)
  local camRot = GetCamRot(HousingCreator.camera, 2)

  local moveSpeed = CAMERA_MOVE_STEP

  -- Speed modifiers (same controls as original)
  if IsControlPressed(0, 60) then
    moveSpeed = CAMERA_MOVE_STEP / 2
  elseif IsControlPressed(0, 21) then
    moveSpeed = CAMERA_MOVE_STEP * 2
  end

  -- Same trig math as original
  local forwardX = math.sin((-camRot.z) * math.pi / 180) * moveSpeed
  local forwardY = math.cos((-camRot.z) * math.pi / 180) * moveSpeed
  local forwardZ = math.tan((camRot.x) * math.pi / 180) * moveSpeed

  local rightX = math.sin((math.floor(camRot.z + 90.0) % 360 * -1.0) * math.pi / 180) * moveSpeed
  local rightY = math.cos((math.floor(camRot.z + 90.0) % 360 * -1.0) * math.pi / 180) * moveSpeed

  local x, y, z = camPos.x, camPos.y, camPos.z

  if IsControlPressed(0, 32) then -- W
    x = x + forwardX
    y = y + forwardY
  end
  if IsControlPressed(0, 33) then -- S
    x = x - forwardX
    y = y - forwardY
  end
  if IsControlPressed(0, 35) then -- D
    x = x - rightX
    y = y - rightY
  end
  if IsControlPressed(0, 34) then -- A
    x = x + rightX
    y = y + rightY
  end
  if IsControlPressed(0, 46) then -- E
    z = z + moveSpeed
  end
  if IsControlPressed(0, 52) then -- Q
    z = z - moveSpeed
  end

  -- Keep camera within max distance to player (same check)
  local ped = PlayerPedId()
  local pedCoords = GetEntityCoords(ped)
  local dist = #(pedCoords - vector3(x, y, z))

  if dist <= CAMERA_MAX_DISTANCE then
    SetCamCoord(HousingCreator.camera, x, y, z)
  end
end

function rotateCamInputs()
  local mouseX = GetControlNormal(0, 220)
  local mouseY = GetControlNormal(0, 221)

  local rot = GetCamRot(HousingCreator.camera, 2)

  local deltaPitch = mouseY * 5
  local newYaw = rot.z + (mouseX * -10)
  local newPitch = rot.x - deltaPitch

  -- Clamp pitch (same as original)
  local clampedPitch = nil
  if newPitch > -85.0 and newPitch < 45.0 then
    clampedPitch = newPitch
  end

  if clampedPitch and newYaw then
    SetCamRot(HousingCreator.camera, vector3(clampedPitch, rot.y, newYaw), 2)
  end
end

function DisabledControls()
  if HousingCreator.camera then
    DisableAllControlActions(0)

    -- Enable camera movement keys (same set)
    EnableControlAction(0, 60, true)
    EnableControlAction(0, 21, true)
    EnableControlAction(0, 32, true)
    EnableControlAction(0, 33, true)
    EnableControlAction(0, 34, true)
    EnableControlAction(0, 35, true)
    EnableControlAction(0, 46, true)
    EnableControlAction(0, 52, true)
    EnableControlAction(0, 220, true)
    EnableControlAction(0, 221, true)
  else
    -- Disable combat controls while placing points (same as original)
    DisableControlAction(0, 322, true) -- prevent pause menu during placement
    DisableControlAction(0, 24, true)
    DisableControlAction(0, 25, true)
    DisableControlAction(0, 140, true)
    DisableControlAction(0, 141, true)
    DisableControlAction(0, 142, true)
  end

  -- Always enabled in both paths (same)
  EnableControlAction(0, 55, true)

  -- Creator binds from config (kept)
  EnableControlAction(0, Config.HousingCreatorControls.LEFT_CTRL.controlIndex, true)
  EnableControlAction(0, Config.HousingCreatorControls.SELECT.controlIndex, true)
  EnableControlAction(0, Config.HousingCreatorControls.BACK.controlIndex, true)
  EnableControlAction(0, Config.HousingCreatorControls.SCROLL_DOWN.controlIndex, true)
  EnableControlAction(0, Config.HousingCreatorControls.SCROLL_UP.controlIndex, true)
  EnableControlAction(0, Config.HousingCreatorControls.ENTER.controlIndex, true)
  EnableControlAction(0, Config.HousingCreatorControls.CANCEL.controlIndex, true)
end

-- ============================================================================
-- The pasted snippet ends here mid-function:
-- `function L23_1(A0_2) ...`

-- ============================================================================
-- Creator input handler (restored)
-- ============================================================================
-- The original script handled creator controls (LMB/RMB/SCROLL/ENTER/BACKSPACE)
-- in a shared helper. The deobfuscated snippet you have ends before that logic,
-- which caused "can't add points" and "backspace doesn't work" issues.
--
-- This function is intentionally global because some loops already call it as a
-- global (keyControls(coords)). It closes over the locals above.

-- Pending state for "double door" selection flow
local pendingDoubleDoor = nil

local function nuiUpdateCreatorInput(inputName, value)
  if not inputName then return end
  if value == nil then return end

  local encoded = value
  if type(value) == "table" then
    encoded = json.encode(value)
  elseif type(value) ~= "string" then
    encoded = tostring(value)
  end

  SendNUIMessage({
    action = "HousingCreator",
    actionName = "Update",
    data = {
      type = "update-input-value",
      inputName = inputName,
      housingType = houseConfiguration.type,
      value = encoded,
    }
  })
end

local function nuiUpdateDoorsList()
  SendNUIMessage({
    action = "HousingCreator",
    actionName = "Update",
    data = {
      type = "update-doors-list",
      value = houseConfiguration.doors or {},
    }
  })
end

local function clampHeading(heading)
  if not heading then return 0.0 end
  heading = heading % 360.0
  if heading < 0.0 then heading = heading + 360.0 end
  return heading
end

local function getScrollStepDegrees()
  -- LEFT CTRL = slow mode for rotations (matches UI label)
  local ctrl = Config.HousingCreatorControls.LEFT_CTRL.controlIndex
  if IsControlPressed(0, ctrl) or IsDisabledControlPressed(0, ctrl) then
    return 0.5
  end
  return 2.5
end

local function getPolyzoneStepZ()
  -- Small step for minZ/maxZ editing
  return 0.25
end

local function getActiveZone()
  if isDrawingInteriorZone then
    return houseConfiguration.interiorZone, "interior_zone"
  end
  return houseConfiguration.zone, "yard_zone"
end

local function restoreZoneSnapshotIfPresent(isInterior)
  if isInterior then
    if houseConfiguration.__interiorZoneSnapshot then
      houseConfiguration.interiorZone = houseConfiguration.__interiorZoneSnapshot
      houseConfiguration.__interiorZoneSnapshot = nil
    end
  else
    if houseConfiguration.__zoneSnapshot then
      houseConfiguration.zone = houseConfiguration.__zoneSnapshot
      houseConfiguration.__zoneSnapshot = nil
    end
  end
end

local function drawCreatorPlacementMarker(coords)
  if not coords or type(coords.x) ~= "number" or type(coords.y) ~= "number" or type(coords.z) ~= "number" then
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

local function stopAllCreatorPlacements()
  isDrawingPolyzone = false
  isDrawingInteriorZone = false

  isPlacingEnterPoint = false
  isPlacingExitPoint = false
  isPlacingEmergencyInside = false
  isPlacingEmergencyOutside = false
  isPlacingMenuPoint = false

  isPlacingDoors = false
  isDoubleDoorMode = false
  isLongDoorDistanceMode = false
  pendingDoubleDoor = nil
  currentDoorIndex = nil

  isPlacingDeliveryPoint = false
  isPlacingGaragePoint = false
  isPlacingEnterGaragePoint = false
  isPlacingParkingSpaces = false

  isPlacingWardrobe = false
  isPlacingStorage = false

  currentParkingIndex = nil
end

function keyControls(coordsOverride)
  -- Defensive: if creator is not open, ignore inputs
  if openedMenu ~= "HousingCreator" then
    return
  end

  local SELECT = Config.HousingCreatorControls.SELECT.controlIndex
  local BACK = Config.HousingCreatorControls.BACK.controlIndex
  local SCROLL_DOWN = Config.HousingCreatorControls.SCROLL_DOWN.controlIndex
  local SCROLL_UP = Config.HousingCreatorControls.SCROLL_UP.controlIndex
  local ENTER = Config.HousingCreatorControls.ENTER.controlIndex
  local CANCEL = Config.HousingCreatorControls.CANCEL.controlIndex

  local function justPressed(control)
    return IsControlJustPressed(0, control) or IsDisabledControlJustPressed(0, control)
  end

  local function isPressed(control)
    return IsControlPressed(0, control) or IsDisabledControlPressed(0, control)
  end

  -- Helper: choose coords (override or raycast globals)
  local function getChosenCoords()
    if coordsOverride and coordsOverride.x and coordsOverride.y and coordsOverride.z then
      return coordsOverride
    end
    return vector3(x or 0.0, y or 0.0, z or 0.0)
  end

  -- Always allow cancel to exit the current placement mode
  -- 202 is common cancel, but some setups map BACKSPACE/ESC differently (177/322).
  if justPressed(CANCEL) or justPressed(177) or justPressed(322) then
    -- Parking is multi-point and uses BACKSPACE to finish the session.
    -- Remove the "next preview" slot so it doesn't get saved.
    if isPlacingParkingSpaces and currentParkingIndex and houseConfiguration.parkingSpaces[currentParkingIndex] then
      local preview = houseConfiguration.parkingSpaces[currentParkingIndex]

      if preview.vehicle and DoesEntityExist(preview.vehicle) then
        DeleteVehicle(preview.vehicle)
      end

      table.remove(houseConfiguration.parkingSpaces, currentParkingIndex)
      currentParkingIndex = nil

      local sanitized = library.Deepcopy(houseConfiguration.parkingSpaces)
      if sanitized and #sanitized >= 1 then
        for _, space in ipairs(sanitized) do
          space.vehicle = nil
        end
      end
      nuiUpdateCreatorInput("garage_point", sanitized)
    end

    if isDrawingPolyzone then
      restoreZoneSnapshotIfPresent(isDrawingInteriorZone)
    end

    -- Cancel doors: restore snapshot if we captured one
    if isPlacingDoors and houseConfiguration.__doorsSnapshot then
      houseConfiguration.doors = houseConfiguration.__doorsSnapshot
      houseConfiguration.__doorsSnapshot = nil
      nuiUpdateDoorsList()
    end

    stopAllCreatorPlacements()
    showControlsMenu(false)
    showCreatorMenu()
    return
  end

  -- =============================================================
  -- Polyzone editing (yard / interior)
  -- =============================================================
  if isDrawingPolyzone then
    local zone, inputName = getActiveZone()
    zone.points = zone.points or {}

    drawCreatorPlacementMarker(getChosenCoords())

    -- LMB: add point
    if justPressed(SELECT) then
      if type(x) == "number" and type(y) == "number" then
        table.insert(zone.points, { x = x, y = y })
      end
    end

    -- RMB: remove last point
    if justPressed(BACK) then
      if #zone.points >= 1 then
        table.remove(zone.points, #zone.points)
      end
    end

    -- SCROLL: adjust zone height (maxZ by default; minZ with LEFT CTRL held)
    local zStep = getPolyzoneStepZ()
    if justPressed(SCROLL_UP) then
      if isPressed(Config.HousingCreatorControls.LEFT_CTRL.controlIndex) then
        zone.minZ = (zone.minZ or 0.0) + zStep
      else
        zone.maxZ = (zone.maxZ or 0.0) + zStep
      end
    elseif justPressed(SCROLL_DOWN) then
      if isPressed(Config.HousingCreatorControls.LEFT_CTRL.controlIndex) then
        zone.minZ = (zone.minZ or 0.0) - zStep
      else
        zone.maxZ = (zone.maxZ or 0.0) - zStep
      end
    end

    -- Keep sane ordering (minZ <= maxZ)
    if zone.minZ and zone.maxZ and zone.minZ > zone.maxZ then
      local tmp = zone.minZ
      zone.minZ = zone.maxZ
      zone.maxZ = tmp
    end

    -- ENTER: save and exit
    if justPressed(ENTER) then
      if #zone.points < 3 then
        CL.Notification("You need at least 3 points.", 3500, "error")
        return
      end

      nuiUpdateCreatorInput(inputName, zone)

      -- Clear snapshots on successful save
      houseConfiguration.__zoneSnapshot = nil
      houseConfiguration.__interiorZoneSnapshot = nil

      isDrawingPolyzone = false
      isDrawingInteriorZone = false
    end

    return
  end

  local chosenCoords = getChosenCoords()

  -- Visual feedback while placing raycast-based points
  if not coordsOverride and (
    isPlacingEnterPoint
    or isPlacingMenuPoint
    or isPlacingEmergencyInside
    or isPlacingGaragePoint
    or isPlacingEnterGaragePoint
    or isPlacingParkingSpaces
    or isPlacingWardrobe
    or isPlacingStorage
    or isPlacingDeliveryPoint
  ) then
    drawCreatorPlacementMarker(chosenCoords)
  end

  -- Preview: garage vehicle follows raycast while placing
  if (isPlacingGaragePoint or isPlacingEnterGaragePoint)
    and houseConfiguration.__garageVehicleObj
    and DoesEntityExist(houseConfiguration.__garageVehicleObj)
  then
    local ok, groundZ = GetGroundZFor_3dCoord(chosenCoords.x, chosenCoords.y, chosenCoords.z, 0)
    local targetZ = ok and groundZ or chosenCoords.z

    SetEntityCoordsNoOffset(houseConfiguration.__garageVehicleObj, chosenCoords.x, chosenCoords.y, targetZ, false, false, false)

    local heading = isPlacingGaragePoint and (houseConfiguration.garageCoords.w or 0.0) or (houseConfiguration.enterGarageCoords.w or 0.0)
    SetEntityHeading(houseConfiguration.__garageVehicleObj, heading)
  end

  -- Preview: delivery prop follows raycast while placing
  if isPlacingDeliveryPoint and houseConfiguration.__deliveryObj and DoesEntityExist(houseConfiguration.__deliveryObj) then
    local ok, groundZ = GetGroundZFor_3dCoord(chosenCoords.x, chosenCoords.y, chosenCoords.z, 0)
    local targetZ = ok and groundZ or chosenCoords.z

    SetEntityCoordsNoOffset(houseConfiguration.__deliveryObj, chosenCoords.x, chosenCoords.y, targetZ, false, false, false)
    SetEntityHeading(houseConfiguration.__deliveryObj, houseConfiguration.deliveryPoint.w or 0.0)
  end

  -- =============================================================
  -- Simple point placement (default)
  -- =============================================================
  if isPlacingEnterPoint and justPressed(SELECT) then
    local c = chosenCoords
    houseConfiguration.enterCoords = { x = c.x, y = c.y, z = c.z }
    nuiUpdateCreatorInput("enter_point", houseConfiguration.enterCoords)
    isPlacingEnterPoint = false
    return
  end

  if isPlacingExitPoint and justPressed(SELECT) then
    local c = chosenCoords
    local heading = GetEntityHeading(PlayerPedId())
    houseConfiguration.exitCoords = { x = c.x, y = c.y, z = c.z, w = heading }
    nuiUpdateCreatorInput("exit_point", houseConfiguration.exitCoords)
    isPlacingExitPoint = false
    return
  end

  if isPlacingMenuPoint and justPressed(SELECT) then
    local c = chosenCoords
    local heading = GetEntityHeading(PlayerPedId())
    houseConfiguration.menuCoords = { x = c.x, y = c.y, z = c.z, w = heading }
    nuiUpdateCreatorInput("menu_point", houseConfiguration.menuCoords)
    isPlacingMenuPoint = false
    return
  end

  if isPlacingEmergencyOutside and justPressed(SELECT) then
    local c = chosenCoords
    local heading = GetEntityHeading(PlayerPedId())
    houseConfiguration.emergencyOutsideCoords = { x = c.x, y = c.y, z = c.z, w = heading }
    nuiUpdateCreatorInput("emergency_exit_outside", houseConfiguration.emergencyOutsideCoords)
    isPlacingEmergencyOutside = false
    return
  end

  if isPlacingEmergencyInside and justPressed(SELECT) then
    local c = chosenCoords
    houseConfiguration.emergencyInsideCoords = { x = c.x, y = c.y, z = c.z }
    nuiUpdateCreatorInput("emergency_exit_inside", houseConfiguration.emergencyInsideCoords)
    isPlacingEmergencyInside = false
    return
  end

  -- =============================================================
  -- Parking spaces (multi-point)
  -- =============================================================
  if isPlacingParkingSpaces and currentParkingIndex and houseConfiguration.parkingSpaces[currentParkingIndex] then
    local currentSpace = houseConfiguration.parkingSpaces[currentParkingIndex]
    currentSpace.coords = currentSpace.coords or {
      x = chosenCoords.x,
      y = chosenCoords.y,
      z = chosenCoords.z,
      w = GetEntityHeading(PlayerPedId()),
    }

    local step = getScrollStepDegrees()
    if justPressed(SCROLL_UP) then
      currentSpace.coords.w = clampHeading((currentSpace.coords.w or 0.0) + step)
    elseif justPressed(SCROLL_DOWN) then
      currentSpace.coords.w = clampHeading((currentSpace.coords.w or 0.0) - step)
    end

    if currentSpace.vehicle and DoesEntityExist(currentSpace.vehicle) then
      local ok, groundZ = GetGroundZFor_3dCoord(chosenCoords.x, chosenCoords.y, chosenCoords.z, 0)
      local targetZ = ok and groundZ or chosenCoords.z

      SetEntityCoordsNoOffset(currentSpace.vehicle, chosenCoords.x, chosenCoords.y, targetZ, false, false, false)
      SetEntityHeading(currentSpace.vehicle, currentSpace.coords.w or 0.0)

      currentSpace.coords.x = chosenCoords.x
      currentSpace.coords.y = chosenCoords.y
      currentSpace.coords.z = targetZ
    end

    -- RMB: remove closest confirmed parking space
    if justPressed(BACK) then
      local closestIndex = nil
      local closestDistance = nil

      for idx, space in ipairs(houseConfiguration.parkingSpaces) do
        if idx ~= currentParkingIndex and space.coords and space.coords.x then
          local d = #(vector3(space.coords.x, space.coords.y, space.coords.z) - chosenCoords)
          if not closestDistance or d < closestDistance then
            closestDistance = d
            closestIndex = idx
          end
        end
      end

      if closestIndex then
        local veh = houseConfiguration.parkingSpaces[closestIndex].vehicle
        if veh and DoesEntityExist(veh) then
          DeleteVehicle(veh)
        end

        table.remove(houseConfiguration.parkingSpaces, closestIndex)
        if closestIndex < currentParkingIndex then
          currentParkingIndex = currentParkingIndex - 1
        end
      end

      return
    end

    -- LMB: confirm current and create next preview slot
    if justPressed(SELECT) then
      local coords = currentSpace.coords

      local nextSpace = {
        coords = { x = coords.x, y = coords.y, z = coords.z, w = coords.w },
      }

      nextSpace.vehicle = CreateVehicle(GetHashKey("baller3"), coords.x, coords.y, coords.z, coords.w, false, true)
      SetEntityCollision(nextSpace.vehicle, false, true)
      FreezeEntityPosition(nextSpace.vehicle, true)

      table.insert(houseConfiguration.parkingSpaces, nextSpace)
      currentParkingIndex = #houseConfiguration.parkingSpaces
      return
    end

    return
  end

  -- =============================================================
  -- Garage / delivery points (rotation via scroll)
  -- =============================================================
  if isPlacingGaragePoint then
    local step = getScrollStepDegrees()

    if justPressed(SCROLL_UP) then
      houseConfiguration.garageCoords.w = clampHeading((houseConfiguration.garageCoords.w or 0.0) + step)
    elseif justPressed(SCROLL_DOWN) then
      houseConfiguration.garageCoords.w = clampHeading((houseConfiguration.garageCoords.w or 0.0) - step)
    end

    if justPressed(SELECT) then
      local c = chosenCoords
      local ok, groundZ = GetGroundZFor_3dCoord(c.x, c.y, c.z, 0)
      local targetZ = ok and groundZ or c.z

      houseConfiguration.garageCoords.x = c.x
      houseConfiguration.garageCoords.y = c.y
      houseConfiguration.garageCoords.z = targetZ
      houseConfiguration.garageCoords.w = clampHeading(houseConfiguration.garageCoords.w or GetEntityHeading(PlayerPedId()))

      nuiUpdateCreatorInput("garage_point", houseConfiguration.garageCoords)
      isPlacingGaragePoint = false
    end

    return
  end

  if isPlacingEnterGaragePoint then
    local step = getScrollStepDegrees()

    if justPressed(SCROLL_UP) then
      houseConfiguration.enterGarageCoords.w = clampHeading((houseConfiguration.enterGarageCoords.w or 0.0) + step)
    elseif justPressed(SCROLL_DOWN) then
      houseConfiguration.enterGarageCoords.w = clampHeading((houseConfiguration.enterGarageCoords.w or 0.0) - step)
    end

    if justPressed(SELECT) then
      local c = chosenCoords
      local ok, groundZ = GetGroundZFor_3dCoord(c.x, c.y, c.z, 0)
      local targetZ = ok and groundZ or c.z

      houseConfiguration.enterGarageCoords.x = c.x
      houseConfiguration.enterGarageCoords.y = c.y
      houseConfiguration.enterGarageCoords.z = targetZ
      houseConfiguration.enterGarageCoords.w = clampHeading(houseConfiguration.enterGarageCoords.w or GetEntityHeading(PlayerPedId()))

      nuiUpdateCreatorInput("enter_garage_point", houseConfiguration.enterGarageCoords)
      isPlacingEnterGaragePoint = false
    end

    return
  end

  if isPlacingDeliveryPoint then
    local step = getScrollStepDegrees()

    if justPressed(SCROLL_UP) then
      houseConfiguration.deliveryPoint.w = clampHeading((houseConfiguration.deliveryPoint.w or 0.0) + step)
    elseif justPressed(SCROLL_DOWN) then
      houseConfiguration.deliveryPoint.w = clampHeading((houseConfiguration.deliveryPoint.w or 0.0) - step)
    end

    if justPressed(SELECT) then
      local c = chosenCoords
      local ok, groundZ = GetGroundZFor_3dCoord(c.x, c.y, c.z, 0)
      local targetZ = ok and groundZ or c.z

      houseConfiguration.deliveryPoint.x = c.x
      houseConfiguration.deliveryPoint.y = c.y
      houseConfiguration.deliveryPoint.z = targetZ
      houseConfiguration.deliveryPoint.w = clampHeading(houseConfiguration.deliveryPoint.w or GetEntityHeading(PlayerPedId()))

      nuiUpdateCreatorInput("delivery_coordinates", houseConfiguration.deliveryPoint)
      isPlacingDeliveryPoint = false
    end

    return
  end

  -- =============================================================
  -- Wardrobe / storage points
  -- =============================================================
  if isPlacingWardrobe and justPressed(SELECT) then
    local c = chosenCoords
    houseConfiguration.wardrobeCoords = { x = c.x, y = c.y, z = c.z }
    nuiUpdateCreatorInput("wardrobe_point", houseConfiguration.wardrobeCoords)
    isPlacingWardrobe = false
    return
  end

  if isPlacingStorage and justPressed(SELECT) then
    local c = chosenCoords
    houseConfiguration.storageCoords = { x = c.x, y = c.y, z = c.z }
    nuiUpdateCreatorInput("storage_point", houseConfiguration.storageCoords)
    isPlacingStorage = false
    return
  end

  -- =============================================================
  -- Doors placement (single/double/slide gate)
  -- =============================================================
  if isPlacingDoors then
    -- SCROLL: adjust access distance (updates controls overlay)
    if justPressed(SCROLL_UP) then
      houseConfiguration.doorsDistance = (houseConfiguration.doorsDistance or 1.5) + 0.25
      SendNUIMessage({ action = "ControlsMenu", doorsDistance = houseConfiguration.doorsDistance })
    elseif justPressed(SCROLL_DOWN) then
      houseConfiguration.doorsDistance = math.max(0.25, (houseConfiguration.doorsDistance or 1.5) - 0.25)
      SendNUIMessage({ action = "ControlsMenu", doorsDistance = houseConfiguration.doorsDistance })
    end

    -- ENTER: finish placement mode
    if justPressed(ENTER) then
      pendingDoubleDoor = nil
      isPlacingDoors = false
      isDoubleDoorMode = false
      isLongDoorDistanceMode = false
      currentDoorIndex = nil
      return
    end

    -- LMB: select door object
    if justPressed(SELECT) then
      local entity = lastRaycastHitEntity
      if not entity or entity == 0 then
        return
      end

      if GetEntityType(entity) ~= 3 then
        return
      end

      local model = GetEntityModel(entity)
      if not model or model == 0 then
        return
      end

      local c = GetEntityCoords(entity)

      houseConfiguration.doors = houseConfiguration.doors or {}

      -- Default locked state for new door configs
      local lockedDefault = Config.DefaultDoorsLocked

      if isDoubleDoorMode then
        if not pendingDoubleDoor then
          pendingDoubleDoor = {
            left = { entity = entity, model = model, coords = { x = c.x, y = c.y, z = c.z } }
          }
          return
        end

        local left = pendingDoubleDoor.left
        local right = { entity = entity, model = model, coords = { x = c.x, y = c.y, z = c.z } }

        local center = {
          x = (left.coords.x + right.coords.x) / 2,
          y = (left.coords.y + right.coords.y) / 2,
          z = (left.coords.z + right.coords.z) / 2,
        }

        table.insert(houseConfiguration.doors, {
          type = "double",
          left = left,
          right = right,
          center = center,
          locked = lockedDefault,
          distance = houseConfiguration.doorsDistance,
        })

        pendingDoubleDoor = nil
        currentDoorIndex = #houseConfiguration.doors + 1
        nuiUpdateDoorsList()
        return
      end

      local doorType = isLongDoorDistanceMode and "slide_gate" or "single"

      table.insert(houseConfiguration.doors, {
        type = doorType,
        entity = entity,
        model = model,
        coords = { x = c.x, y = c.y, z = c.z },
        center = { x = c.x, y = c.y, z = c.z },
        locked = lockedDefault,
        distance = houseConfiguration.doorsDistance,
      })

      currentDoorIndex = #houseConfiguration.doors + 1
      nuiUpdateDoorsList()
      return
    end

    return
  end
end
-- Paste the remainder and I’ll continue the same cleanup for the rest.
-- ============================================================================
