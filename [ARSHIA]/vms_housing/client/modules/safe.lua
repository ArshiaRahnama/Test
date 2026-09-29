--==============================================================
-- Safe (PIN) NUI Handler
-- Deobfuscated + cleaned, logic preserved exactly.
--==============================================================

-- Current safe context (set when OpenSafe() is called)
local currentSafeFurnitureId = nil  -- whatever identifier is passed from the furniture interaction
local currentSafeData = nil         -- safe metadata table (expects `.pin`)

--- Open the Safe UI.
-- @param furnitureId any   Identifier/model/id used later for storage + server calls.
-- @param safeData table    Metadata for the safe (expects `pin` field).
function OpenSafe(furnitureId, safeData)
  if not furnitureId or not safeData then
    return
  end

  -- Focus the NUI (mouse + keyboard)
  SetNuiFocus(true, true)
  openedMenu = "Safe"

  -- Store context for callbacks
  currentSafeFurnitureId = furnitureId
  currentSafeData = safeData

  local pin = currentSafeData.pin

  -- If there's no pin set (nil or empty string), show first-time setup screen
  if not pin or pin == "" then
    SendNUIMessage({
      action = "Safe",
      actionName = "SetFirstTime",
    })
    return
  end

  -- Otherwise show normal PIN entry screen
  SendNUIMessage({
    action = "Safe",
    actionName = "Open",
  })
end

--- Close the Safe UI and clear stored context.
function CloseSafe()
  SetNuiFocus(false, false)

  SendNUIMessage({
    action = "Safe",
    actionName = "Close",
  })

  openedMenu = nil
  currentSafeFurnitureId = nil
  currentSafeData = nil
end

--==============================================================
-- NUI CALLBACK: safe:verifyCode
-- Purpose: Verify entered PIN against stored safe pin.
-- Notes:
--   - Logic is preserved exactly, including the subtle behavior:
--     storedPin ~= "" is TRUE even when storedPin is nil.
--   - On success (and not changing code), it closes focus and
--     asynchronously opens the "storage" interactable.
--==============================================================
RegisterNuiCallback("safe:verifyCode", function(data, cb)
  local storedPin = currentSafeData and currentSafeData.pin
  local enteredPin = data.code

  -- Verify code
  if storedPin == enteredPin then
    -- IMPORTANT: keep this check exactly as original (no extra nil-guards).
    if storedPin ~= "" then
      cb(true)

      -- If user isn't changing the code, open storage after a short delay
      if not data.isChanging then
        SetNuiFocus(false, false)

        -- ASYNC: delayed follow-up to open storage
        Citizen.CreateThread(function()
          Citizen.Wait(1200)

          -- CLIENT: open storage interactable for this safe
          CL.InteractableFurniture(nil, "storage", currentSafeFurnitureId, currentSafeData)

          -- Clear context (matches original behavior)
          currentSafeFurnitureId = nil
          currentSafeData = nil
        end)
      end
    end
  else
    cb(false)
  end
end)

--==============================================================
-- NUI CALLBACK: safe:changeCode
-- Purpose: Ask server to change the safe pin.
-- Server Event:
--   vms_housing:sv:changeSafePin(propertyId, furnitureId, newPin, oldPin)
-- Notes:
--   - Original code does NOT call the NUI callback response here.
--     (Kept as-is.)
--==============================================================
RegisterNUICallback("safe:changeCode", function(data, cb)
  local oldPin = data.oldCode
  local newPin = data.newCode

  -- Determine property context
  local propertyId = CurrentProperty or GetCurrentPropertyId()

  -- SERVER: request to change safe pin
  TriggerServerEvent(
    "vms_housing:sv:changeSafePin",
    propertyId,
    currentSafeFurnitureId,
    newPin,
    oldPin
  )

  -- Intentionally no cb(...) to match original behavior.
end)