--[[

  Property Camera Mode (deobfuscated / cleaned)

  What this does:
  - Builds (and caches) a list of placed camera furniture for a property
  - Enters a “camera view” using a scripted cam pointed at the selected camera prop
  - Allows cycling cameras with LEFT/RIGHT and exiting with BACKSPACE
  - Handles “inside/outside” environments by syncing with the server and loading/unloading shells/IPLs
  - Shows a small HUD overlay (property address + current date/time) while viewing cameras
  - Shows/updates an NUI “ControlsMenu” hint while camera mode is active

  Notes:
  - The camera list is intentionally cached like the original: it only rebuilds when empty.
    (This matches original behavior exactly, even though it means it doesn’t auto-refresh per property/environment.)

--]]

-- Persistent state (original: L0_1, L1_1, L2_1, L3_1, L4_1)
local isCameraModeActive = false          -- L0_1
local currentCameraIndex = nil            -- L1_1
local activeScriptCam = nil              -- L2_1
local currentCameraPropEntity = nil       -- L3_1
local cameraFurnitureCache = {}           -- L4_1

-- Forward declaration (original: L5_1 then checkCameras = L5_1)
local function checkCameras(propertyId, resultCallback, environment)
  local propertyData = (Properties and propertyId and Properties[propertyId]) or nil

  -- Permission check (original: library.HasAnyPermission(propertyId))
  if not (library and library.HasAnyPermission and library.HasAnyPermission(propertyId)) then
    if resultCallback then
      resultCallback(false)
    end
    return
  end

  if not propertyData or not propertyData.furniture then
    if resultCallback then
      resultCallback(false)
    end
    return
  end

  -- Build camera list only if cache is empty (matches original behavior)
  if not (cameraFurnitureCache and next(cameraFurnitureCache)) then
    cameraFurnitureCache = {}

    for _, furnitureItem in pairs(propertyData.furniture) do
      local isCameraModel = Config.Cameras[furnitureItem.model] ~= nil
      local hasPosition = furnitureItem.position ~= nil
      local isNotStored = (furnitureItem.stored == 0)

      if isCameraModel and hasPosition and isNotStored then
        if environment then
          if furnitureItem.position.environment == environment then
            table.insert(cameraFurnitureCache, furnitureItem)
          end
        else
          table.insert(cameraFurnitureCache, furnitureItem)
        end
      end
    end
  end

  -- No cameras available
  if not next(cameraFurnitureCache) then
    if resultCallback then
      resultCallback(false)
    end
    return
  end

  -- Cameras exist
  if resultCallback then
    resultCallback(true)
  end

  -- Fade out to hide transitions
  DoScreenFadeOut(300)
  Wait(300)

  --[[ ------------------------------------------------------------------
        First-time entry: prepare the correct environment (inside/outside)
        (original: only runs when isCameraModeActive == false)
  ------------------------------------------------------------------- ]]
  if not isCameraModeActive then
    if environment then
      -- If we are currently in a property and we want "outside" cameras, exit the house first
      if CurrentProperty then
        if environment == "outside" then
          -- [SERVER] Leaving house so we can view exterior cameras
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
        end

      -- If we are NOT in a property and we want "inside" cameras, spawn/load the interior context
      elseif environment == "inside" then
        -- [SERVER] Enter camera mode in a different environment (inside)
        TriggerServerEvent("vms_housing:sv:enterCameraModeDifferentEnvironment", propertyId, environment)

        if propertyData.type == "shell" then
          -- Remove any existing furniture objects first (matches original)
          Property:RemoveFurniture()

          -- Spawn shell high above the map
          CurrentShell = CreateObjectNoOffset(
            joaat(propertyData.metadata.shell),
            0.0, 0.0, 500.0,
            false, false, false
          )

          -- Wait for shell to exist
          while not DoesEntityExist(CurrentShell) do
            Wait(1)
          end

          SetEntityHeading(CurrentShell, 0.0)
          FreezeEntityPosition(CurrentShell, true)

          -- Keep weather “forced” while shell exists (original spawns a thread)
          if ToggleWeather then
            Citizen.CreateThread(function()
              while true do
                if not CurrentShell then
                  break
                end

                if CurrentShell then
                  ToggleWeather(true)
                end

                Citizen.Wait(30000)
              end
            end)
          end

        elseif propertyData.type == "ipl" then
          CurrentIPL = propertyData.metadata.ipl
          IPL.LoadSettings(CurrentIPL, propertyData.metadata.iplTheme, propertyData.metadata.iplSettings)
        end

        -- Allow IPL/shell to settle
        Wait(1500)

        -- Optional lighting override
        if propertyData.metadata.lightState ~= nil then
          SetArtificialLightsState(not propertyData.metadata.lightState)
        end

        -- Load property furniture into the spawned interior
        if propertyData and propertyData.furniture then
          Property:LoadFurniture("inside", propertyData.furniture, propertyId)
        end
      end
    end

    -- Initialize camera mode
    currentCameraIndex = 1
    isCameraModeActive = true
  end

  --[[ ------------------------------------------------------------------
        If already in camera mode, tear down previous cam instance
        (original always runs this block once isCameraModeActive is true)
  ------------------------------------------------------------------- ]]
  if isCameraModeActive then
    if currentCameraPropEntity then
      SetEntityVisible(currentCameraPropEntity, true)
    end

    RenderScriptCams(false, false, 0, true, false)
    DestroyCam(activeScriptCam, false)  -- original does not guard nil/false
    activeScriptCam = false
  end

  -- Player context
  local playerPed = PlayerPedId()
  local _playerCoords = GetEntityCoords(playerPed) -- kept for parity (original reads it)

  -- Current camera furniture item
  local cameraItem = cameraFurnitureCache[currentCameraIndex]
  ClearFocus()

  --[[ ------------------------------------------------------------------
        Safety/edge branch (original: if not cameraItem.position then exit)
        This path fully exits camera mode and returns control to the player.
  ------------------------------------------------------------------- ]]
  if not (cameraItem and cameraItem.position) then
    DoScreenFadeOut(400)
    isCameraModeActive = false
    Wait(400)

    ClearFocus()
    ClearTimecycleModifier()
    ClearExtraTimecycleModifier()

    RenderScriptCams(false, false, 0, true, false)

    SetFocusEntity(playerPed)
    SetEntityCollision(playerPed, true, true)
    SetEntityVisible(playerPed, true)

    Wait(300)

    -- Restore environment / open menus (mirrors original branching)
    if environment then
      if CurrentProperty then
        if environment == "outside" then
          -- [ASYNC] EnterProperty has a callback; original opens manage menu after delay if success.
          Property:EnterProperty(propertyData, propertyId, function(success)
            if success then
              Citizen.CreateThread(function()
                Citizen.Wait(3000)
                openManageMenu(propertyId)
              end)
            end
          end, true)
        else
          FreezeEntityPosition(playerPed, false)
          DoScreenFadeIn(400)
        end

      elseif environment == "inside" then
        -- [SERVER] Exiting camera mode (inside)
        TriggerServerEvent("vms_housing:sv:exitCameraMode", propertyId, environment)

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

        openManageMenu(propertyId)
        Property:RemoveFurniture()

        FreezeEntityPosition(playerPed, false)
        DoScreenFadeIn(400)
      else
        FreezeEntityPosition(playerPed, false)
        DoScreenFadeIn(400)
      end
    else
      openManageMenu(propertyId)
      FreezeEntityPosition(playerPed, false)
      DoScreenFadeIn(400)
    end

    -- Reset cache (matches original)
    cameraFurnitureCache = {}

    -- Hide NUI controls hint
    SendNUIMessage({ action = "ControlsMenu", toggle = false })
    return
  end

  --[[ ------------------------------------------------------------------
        Create the scripted camera and lock player controls
  ------------------------------------------------------------------- ]]
  activeScriptCam = CreateCamWithParams(
    "DEFAULT_SCRIPTED_CAMERA",
    vector3(cameraItem.position.x, cameraItem.position.y, cameraItem.position.z),
    0, 0, 0,
    50.0
  )

  -- Find the physical camera prop entity near the stored position
  currentCameraPropEntity = GetClosestObjectOfType(
    cameraItem.position.x, cameraItem.position.y, cameraItem.position.z,
    0.5,
    GetHashKey(cameraItem.model),
    false, false, false
  )

  -- Wait (up to ~3 seconds) for the entity to exist (matches original)
  local timeoutAt = GetGameTimer() + 3000
  while timeoutAt > GetGameTimer() do
    if DoesEntityExist(currentCameraPropEntity) then
      break
    end

    Wait(1)

    currentCameraPropEntity = GetClosestObjectOfType(
      cameraItem.position.x, cameraItem.position.y, cameraItem.position.z,
      0.5,
      GetHashKey(cameraItem.model),
      false, false, false
    )
  end

  -- Orient the camera to face the prop (original math preserved)
  local propRot = GetEntityRotation(currentCameraPropEntity)
  local camPitch = propRot.x - 18.0
  local camYaw = (propRot.z + 180.0) % 360.0

  SetCamRot(activeScriptCam, camPitch, propRot.y, camYaw, 2)
  SetCamActive(activeScriptCam, true)

  -- Visual effects / control lock
  SetTimecycleModifier("scanline_cam_cheap")
  DisableAllControlActions(0)

  FreezeEntityPosition(playerPed, true)
  SetEntityCollision(playerPed, false, true)
  SetEntityVisible(playerPed, false)

  -- Hide the prop itself while “viewing through it”
  SetEntityVisible(currentCameraPropEntity, false)

  SetTimecycleModifierStrength(2.0)
  SetFocusArea(cameraItem.position.x, cameraItem.position.y, cameraItem.position.z, 0.0, 0.0, 0.0)

  -- Point the camera at the prop position
  PointCamAtCoord(activeScriptCam, vector3(cameraItem.position.x, cameraItem.position.y, cameraItem.position.z))

  RenderScriptCams(true, false, 1, true, false)

  Wait(1000)
  DoScreenFadeIn(500)

  -- Audio banks used for hint cam sounds (original calls preserved)
  RequestAmbientAudioBank("Phone_Soundset_Franklin", 0, 0)
  RequestAmbientAudioBank("HintCamSounds", 0, 0)

  -- Show NUI controls hint
  SendNUIMessage({
    action = "ControlsMenu",
    toggle = true,
    controlsLabel = "property:camera",
    controlsName = "Property:camera"
  })

  --[[ ------------------------------------------------------------------
        Camera loop: HUD suppression, camera cycling, and exit handling
  ------------------------------------------------------------------- ]]
  while IsCamActive(activeScriptCam) do
    Citizen.Wait(2)

    DisableAllControlActions(0)

    -- Hide HUD/Radar elements while in camera mode
    HideHudComponentThisFrame(7)
    HideHudComponentThisFrame(8)
    HideHudComponentThisFrame(9)
    HideHudComponentThisFrame(6)
    HideHudComponentThisFrame(19)
    HideHudAndRadarThisFrame()

    -- Ensure the prop stays invisible locally
    SetEntityLocallyInvisible(currentCameraPropEntity)

    -- Cycle LEFT (174)
    if IsDisabledControlPressed(0, 174) then
      local prevIndex = currentCameraIndex - 1
      if cameraFurnitureCache[prevIndex] then
        currentCameraIndex = prevIndex
        -- [ASYNC-LIKE FLOW] Recursively rebuild camera view (original behavior)
        checkCameras(propertyId, nil, environment)
      else
        -- Wrap to end if not already there
        if currentCameraIndex ~= #cameraFurnitureCache then
          currentCameraIndex = #cameraFurnitureCache
          checkCameras(propertyId, nil, environment)
        end
      end
    end

    -- Cycle RIGHT (175)
    if IsDisabledControlPressed(0, 175) then
      local nextIndex = currentCameraIndex + 1
      if cameraFurnitureCache[nextIndex] then
        currentCameraIndex = nextIndex
        -- [ASYNC-LIKE FLOW] Recursively rebuild camera view (original behavior)
        checkCameras(propertyId, nil, environment)
      else
        -- Wrap to start if not already there
        if currentCameraIndex ~= 1 then
          currentCameraIndex = 1
          checkCameras(propertyId, nil, environment)
        end
      end
    end

    -- Draw: "Address - Cam X/Y"
    SetTextFont(4)
    SetTextScale(0.8, 0.8)
    SetTextColour(255, 255, 255, 255)
    SetTextDropshadow(0.1, 3, 27, 27, 255)
    BeginTextCommandDisplayText("STRING")
    AddTextComponentSubstringPlayerName(
      propertyData.address .. " - Cam " .. currentCameraIndex .. "/" .. #cameraFurnitureCache
    )
    EndTextCommandDisplayText(0.01, 0.01)

    -- Draw: Current date/time (POSIX time)
    SetTextFont(4)
    SetTextScale(0.7, 0.7)
    SetTextColour(255, 255, 255, 255)
    SetTextDropshadow(0.1, 3, 27, 27, 255)
    BeginTextCommandDisplayText("STRING")

    local year, month, day, hour, minute, second = GetPosixTime()
    AddTextComponentSubstringPlayerName(
      day .. "/" .. month .. "/" .. year .. " " .. hour .. ":" .. minute .. ":" .. second
    )
    EndTextCommandDisplayText(0.01, 0.055)

    -- Exit camera mode (BACKSPACE: 194)
    if IsDisabledControlPressed(1, 194) then
      DoScreenFadeOut(400)
      isCameraModeActive = false
      Wait(400)

      ClearFocus()
      ClearTimecycleModifier()
      ClearExtraTimecycleModifier()

      RenderScriptCams(false, false, 0, true, false)
      SetCamActive(activeScriptCam, false)
      DestroyCam(activeScriptCam, false)

      SetFocusEntity(playerPed)
      SetEntityCollision(playerPed, true, true)
      SetEntityVisible(playerPed, true)

      Wait(300)

      -- Restore environment / open menus (mirrors original branching)
      if environment then
        if CurrentProperty then
          if environment == "outside" then
            -- [ASYNC] EnterProperty callback; openManageMenu after 3s if success
            Property:EnterProperty(propertyData, propertyId, function(success)
                if success then
                  Citizen.CreateThread(function()
                    Citizen.Wait(3000)
                    openManageMenu(propertyId)
                  end)
                end
              end, true)
          else
            FreezeEntityPosition(playerPed, false)
            DoScreenFadeIn(400)
          end

        elseif environment == "inside" then
          -- [SERVER] Exiting camera mode (inside)
          TriggerServerEvent("vms_housing:sv:exitCameraMode", propertyId, environment)

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

          openManageMenu(propertyId)
          Property:RemoveFurniture()

          FreezeEntityPosition(playerPed, false)
          DoScreenFadeIn(400)
        else
          FreezeEntityPosition(playerPed, false)
          DoScreenFadeIn(400)
        end
      else
        openManageMenu(propertyId)
        FreezeEntityPosition(playerPed, false)
        DoScreenFadeIn(400)
      end

      -- Make prop visible again (original does this here)
      SetEntityVisible(currentCameraPropEntity, true)

      -- Reset cache (matches original)
      cameraFurnitureCache = {}
      break
    end
  end

  -- Hide NUI controls hint
  SendNUIMessage({ action = "ControlsMenu", toggle = false })

  -- Make prop visible again (original also does this after loop)
  SetEntityVisible(currentCameraPropEntity, true)
end

-- Keep original external API name
_G.checkCameras = checkCameras
