--[[-------------------------------------------------------------------------
  Furniture Photo Registration / Screenshot Tool (deobfuscated)

  What this file does:
    - Teleports the player to an isolated staging area (500, 500, 350)
    - Spawns 3 large cinema screens to act as a clean backdrop
    - Iterates through a list of prop model names:
        - Spawns each prop as a preview
        - Sets up a camera framing the prop
        - Shows a short countdown overlay (with controls to adjust view/prop)
        - Takes a screenshot using screenshot-basic (ASYNC)
        - Sends the image to NUI for processing
        - Stores metadata (deliverySize) for each prop
    - Restores player position and cleans up camera/entities
    - Sends the collected furniture data to the server (SERVER)

  ASYNC:
    - takeScreenshot() -> exports["screenshot-basic"]:requestScreenshot(callback)

  SERVER:
    - TriggerServerEvent("vms_housing:sv:addFurniture", resultsTable)
---------------------------------------------------------------------------]]

-- State / configuration
local propsToRegister = {}                      -- was L0_1 (reused as the list passed into RegisterFurniture)
local CINEMA_SCREEN_MODEL = "prop_big_cin_screen" -- was L1_1
local currentIndex = 1                          -- was L2_1

-- Spawned entities
local previewPropEntity = nil                   -- was L3_1
local screenTopEntity = nil                     -- was L4_1
local screenMidEntity = nil                     -- was L5_1
local screenBottomEntity = nil                  -- was L6_1
local previewCam = nil                          -- was L7_1

-- Player position backup
local playerOriginalCoords = nil                -- was L8_1

-- Staging location (isolated coordinates)
local STAGING_POS = vector3(500.0, 500.0, 350.0) -- was L9_1

-- Countdown overlay state
local countdownActive = false                   -- was L10_1
local countdownMs = 3000                        -- was L11_1
local countdownPaused = false                   -- was L12_1

-- Result payload to be sent to server
local registeredFurnitureData = {}              -- was L13_1

-- --------------------------------------------------------------------------
-- Helper: Determine delivery size based on model dimensions (min/max vectors)
-- Returns: 1, 2, or 3 depending on volume thresholds
-- --------------------------------------------------------------------------
local function getDeliverySizeFromDimensions(minDim, maxDim)
  local size = vector3(
    math.abs(maxDim.x - minDim.x),
    math.abs(maxDim.y - minDim.y),
    math.abs(maxDim.z - minDim.z)
  )

  local volume = size.x * size.y * size.z

  if volume <= 0.3 then
    return 1
  elseif volume <= 1.0 then
    return 2
  else
    return 3
  end
end

-- --------------------------------------------------------------------------
-- 2D Text drawing helper (kept identical behavior)
-- --------------------------------------------------------------------------
function drawText2D(text, x, y, scale, r, g, b)
  SetTextFont(4)
  SetTextProportional(1)
  SetTextScale(0.0, scale)
  SetTextColour(r, g, b, 255)

  SetTextDropshadow(0, 0, 0, 0, 205)
  SetTextEdge(1, 0, 0, 0, 150)
  SetTextDropshadow()
  SetTextOutline()
  SetTextCentre(1)

  BeginTextCommandDisplayText("STRING")
  AddTextComponentSubstringPlayerName(text)
  EndTextCommandDisplayText(x, y)
end

-- --------------------------------------------------------------------------
-- Countdown overlay + controls
-- Controls:
--   SPACE  : pause/resume timer
--   SCROLL : adjust camera FOV
--   LMB/RMB: move preview prop up/down
--   ARROWS : rotate preview prop
-- --------------------------------------------------------------------------
function startCountdown()
  countdownActive = true
  countdownMs = 3000
  countdownPaused = false

  while countdownActive do
    Citizen.Wait(0)

    if not countdownPaused then
      countdownMs = countdownMs - 10

      drawText2D(tostring(countdownMs) .. "ms", 0.5, 0.5, 0.8, 200, 0, 0)
      drawText2D("Press SPACE to hold timer", 0.5, 0.54, 0.3, 210, 210, 210)
    else
      drawText2D(tostring(countdownMs) .. "ms", 0.5, 0.5, 0.8, 200, 200, 0)
      drawText2D("Press SPACE to resume timer", 0.5, 0.54, 0.3, 210, 210, 210)
    end

    -- Help text
    drawText2D("Change FOV using SCROLL", 0.5, 0.70, 0.4, 240, 240, 240)
    drawText2D("Change HEIGHT using LMB/RMB", 0.5, 0.73, 0.4, 240, 240, 240)
    drawText2D("Change ROTATION using ARROWS", 0.5, 0.76, 0.4, 240, 240, 240)

    -- SPACE (22) toggles pause
    if IsControlJustPressed(0, 22) then
      countdownPaused = not countdownPaused
    end

    -- LMB (24) -> move prop up
    if IsControlPressed(0, 24) then
      local coords = GetEntityCoords(previewPropEntity)
      SetEntityCoords(previewPropEntity, coords.x, coords.y, coords.z + 0.01)
    end

    -- RMB (70) -> move prop down
    if IsControlPressed(0, 70) then
      local coords = GetEntityCoords(previewPropEntity)
      SetEntityCoords(previewPropEntity, coords.x, coords.y, coords.z - 0.01)
    end

    -- Arrow left (174) -> rotate +
    if IsControlPressed(0, 174) then
      local heading = (GetEntityHeading(previewPropEntity) + 1.0) % 360
      SetEntityHeading(previewPropEntity, heading)
    end

    -- Arrow right (175) -> rotate -
    if IsControlPressed(0, 175) then
      local heading = (GetEntityHeading(previewPropEntity) - 1.0) % 360
      if heading < 0 then
        heading = heading + 360
      end
      SetEntityHeading(previewPropEntity, heading)
    end

    -- Scroll up (180) -> FOV +
    if IsControlPressed(0, 180) then
      SetCamFov(previewCam, GetCamFov(previewCam) + 2.0)
    end

    -- Scroll down (181) -> FOV -
    if IsControlPressed(0, 181) then
      SetCamFov(previewCam, GetCamFov(previewCam) - 2.0)
    end

    if countdownMs <= 0 then
      countdownActive = false
    end
  end

  Citizen.Wait(1250)
end

-- --------------------------------------------------------------------------
-- Camera setup to frame the preview prop
-- --------------------------------------------------------------------------
function setupCamera(entity)
  -- Cleanup any previous camera
  if previewCam then
    DestroyCam(previewCam, false)
    SetCamActive(previewCam, false)
  end

  previewCam = CreateCam("DEFAULT_SCRIPTED_CAMERA", true)

  local coords = GetEntityCoords(entity)
  local minDim, maxDim = GetModelDimensions(GetEntityModel(entity))
  local size = (maxDim - minDim)

  local sizeX = size.x
  local sizeY = size.y
  local sizeZ = size.z

  local maxXY = math.max(sizeX, sizeY)
  local camDistance = math.max(2.5, maxXY * 1.4)

  -- Position camera slightly behind the prop (Y - distance) and above (Z + height factor)
  SetCamCoord(previewCam, coords.x, coords.y - camDistance, coords.z + (sizeZ * 1.2))

  -- Look at the middle-ish of the prop
  PointCamAtCoord(previewCam, coords.x, coords.y, coords.z + (sizeZ * 0.5))

  -- Choose FOV based on size, clamped
  local computedFov = math.max(40.0, math.min(70.0, 65.0 - (maxXY * 3.0)))
  SetCamFov(previewCam, computedFov)

  SetCamActive(previewCam, true)
  RenderScriptCams(true, true, 500, true, true)
end

-- --------------------------------------------------------------------------
-- ASYNC: Screenshot capture via screenshot-basic
-- Sends base64 image to NUI for processing
-- --------------------------------------------------------------------------
function takeScreenshot(fileName, onDone)
  exports["screenshot-basic"]:requestScreenshot(function(imageData)
    SendNUIMessage({
      action = "ProcessImage",
      fileName = fileName,
      image = imageData
    })

    -- Callback to signal completion (kept behavior)
    onDone(true)
  end)
end

-- --------------------------------------------------------------------------
-- Spawns the next prop in the list and captures its screenshot + metadata
-- --------------------------------------------------------------------------
function spawnNextProp()
  -- Delete previous preview prop if it exists
  if previewPropEntity then
    DeleteEntity(previewPropEntity)
  end

  local modelName = propsToRegister[currentIndex]

  -- Spawn preview prop at staging location
  previewPropEntity = library.SpawnProp(
    GetHashKey(modelName),
    vector3(STAGING_POS.x, STAGING_POS.y, STAGING_POS.z + 10.0),
    false
  )

  -- If spawned, freeze + set heading and begin capture flow
  if DoesEntityExist(previewPropEntity) then
    FreezeEntityPosition(previewPropEntity, true)
    SetEntityHeading(previewPropEntity, 25.0)

    setupCamera(previewPropEntity)

    Citizen.Wait(500)
    startCountdown()

    -- [ASYNC] Take screenshot, then store delivery size metadata
    takeScreenshot(modelName, function()
      if DoesEntityExist(previewPropEntity) then
        local minDim, maxDim = GetModelDimensions(modelName) -- kept as original (string argument)
        registeredFurnitureData[modelName] = {
          deliverySize = getDeliverySizeFromDimensions(minDim, maxDim)
        }
      else
        print('Entity "' .. tostring(modelName) .. '" does not exist')
      end

      -- Advance index (wrap to 0 to signal completion)
      currentIndex = currentIndex + 1
      if currentIndex > #propsToRegister then
        currentIndex = 0
      end
    end)
  else
    -- Spawn failed: report and still advance
    print('Entity "' .. tostring(modelName) .. '" does not exist')

    currentIndex = currentIndex + 1
    if currentIndex > #propsToRegister then
      currentIndex = 0
    end
  end
end

-- --------------------------------------------------------------------------
-- Main entry: RegisterFurniture(listOfModelNames)
-- Teleports player, sets up backdrop, loops through props, restores state,
-- then sends results to server.
-- --------------------------------------------------------------------------
function RegisterFurniture(modelList)
  if not OBJECTS_PHOTOS_TOOL_WEBHOOK then
    return library.Debug(
      "Nie możesz korzystać z tej opcji. Nie ma skonfigurowanego webhooka.",
      "warn"
    )
  end

  propsToRegister = modelList
  registeredFurnitureData = {}
  currentIndex = 1

  -- Save player coords and move them to staging area
  playerOriginalCoords = GetEntityCoords(PlayerPedId())
  Citizen.Wait(100)

  local ped = PlayerPedId()
  SetEntityCoords(
    ped,
    STAGING_POS.x, STAGING_POS.y, STAGING_POS.z + 15.0,
    false, false, false, true
  )
  FreezeEntityPosition(ped, true)

  -- Spawn backdrop screens (top/mid/bottom) and freeze them
  screenTopEntity = library.SpawnProp(
    GetHashKey(CINEMA_SCREEN_MODEL),
    vector3(STAGING_POS.x, STAGING_POS.y, STAGING_POS.z + 15.0),
    false
  )
  FreezeEntityPosition(screenTopEntity, true)

  screenMidEntity = library.SpawnProp(
    GetHashKey(CINEMA_SCREEN_MODEL),
    vector3(STAGING_POS.x, STAGING_POS.y, STAGING_POS.z),
    false
  )
  FreezeEntityPosition(screenMidEntity, true)

  screenBottomEntity = library.SpawnProp(
    GetHashKey(CINEMA_SCREEN_MODEL),
    vector3(STAGING_POS.x, STAGING_POS.y, STAGING_POS.z - 15.0),
    false
  )
  FreezeEntityPosition(screenBottomEntity, true)

  -- Hide HUD during capture sequence
  CL.Hud.Disable()
  Wait(1000)

  -- Process each prop until currentIndex becomes 0
  while currentIndex ~= 0 do
    spawnNextProp()
    Citizen.Wait(1000)
  end

  Citizen.Wait(750)

  -- Cleanup spawned entities
  if previewPropEntity then DeleteEntity(previewPropEntity) end
  if screenTopEntity then DeleteEntity(screenTopEntity) end
  if screenMidEntity then DeleteEntity(screenMidEntity) end
  if screenBottomEntity then DeleteEntity(screenBottomEntity) end

  -- Restore HUD + player position
  CL.Hud.Enable()
  FreezeEntityPosition(PlayerPedId(), false)

  if playerOriginalCoords and playerOriginalCoords.x then
    SetEntityCoords(PlayerPedId(), playerOriginalCoords.x, playerOriginalCoords.y, playerOriginalCoords.z)
  end

  -- Cleanup camera + rendering
  DestroyCam(previewCam, false)
  SetCamActive(previewCam, false)
  RenderScriptCams(false, true, 500, true, true)

  -- [SERVER] Send collected furniture metadata to server
  TriggerServerEvent("vms_housing:sv:addFurniture", registeredFurnitureData)
end