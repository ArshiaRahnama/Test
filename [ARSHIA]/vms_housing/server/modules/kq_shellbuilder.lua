--[[-------------------------------------------------------------------------
  KuzQuality (kq_shellbuilder) integration
  - Waits for the "kq_shellbuilder" resource to start
  - Pulls shell definitions from the export
  - Normalizes them into this housing system's expected format
  - Registers/updates shells via addShells(...)
  - Listens for "kq_shellbuilder:update" to refresh shells dynamically

  NOTE: Logic/flow is preserved exactly (including timing/retry behavior).
---------------------------------------------------------------------------]]

-- Feature toggle (keep original early-exit behavior)
if not Config.Shells.KuzQuality then
  return
end

-- Wait up to 10 seconds for the shell builder resource to start
local startDeadline = GetGameTimer() + 10000

while true do
  local state = GetResourceState("kq_shellbuilder")
  if state == "started" then
    break
  end

  if GetGameTimer() > startDeadline then
    startDeadline = -1
    break
  end

  Citizen.Wait(100)
end

-- If resource did not start in time, warn and stop (same behavior as original)
if startDeadline == -1 then
  return warn("KuzQuality Shell Creator is not started, please check the resource state.")
end

--[[-------------------------------------------------------------------------
  refreshKuzQualityShells()
  ASYNC FLOW NOTE:
    - This function is called from:
        1) A background thread (Citizen.CreateThread) on startup
        2) A network event handler ("kq_shellbuilder:update")
    - It performs a direct export call (exports.kq_shellbuilder:GetShells())
      and then calls addShells(...) to register/refresh shells.
---------------------------------------------------------------------------]]
local function refreshKuzQualityShells()
  -- SERVER/STATE SYNC:
  -- Store raw shells in GlobalState so other resources/clients can read them.
  GlobalState.vms_housing_kq_shells = exports.kq_shellbuilder:GetShells()

  -- Build the housing-compatible shell registry table
  local shellRegistry = {}

  local shells = GlobalState.vms_housing_kq_shells
  if shells and next(shells) then
    for _, shell in pairs(shells) do
      -- Keep exact naming convention used by the original code
      local shellModel = ("kq_sbx_shell_%s"):format(shell.id)

      shellRegistry[shellModel] = {
        label = shell.title,
        tags = { "kuzquality" },
        rooms = 1,

        -- Model name matches the registry key (same as original)
        model = shellModel,

        -- "doors" holds the spawn point data in this housing script
        doors = {
          x = shell.spawnPoint.x,
          y = shell.spawnPoint.y,
          -- Preserve exact Z math: (z * 1.5) + 500.0
          z = 500.0 + (shell.spawnPoint.z * 1.5),
          heading = shell.spawnPoint.w,
        },
      }
    end

    -- SERVER CALL / INTEGRATION POINT:
    -- Registers these shells into the housing shell system.
    addShells(shellRegistry)
  end
end

--[[-------------------------------------------------------------------------
  Startup thread:
  ASYNC NOTE:
    Runs in the background once, pulls shells, then checks if any were loaded.
    If none were loaded, it retries after 2.5 seconds (same as original).
---------------------------------------------------------------------------]]
Citizen.CreateThread(function()
  refreshKuzQualityShells()

  -- Small delay before checking results (same timing)
  Citizen.Wait(500)

  local count = #GlobalState.vms_housing_kq_shells
  if count <= 0 then
    -- Retry once after a longer delay (same timing)
    Citizen.Wait(2500)
    refreshKuzQualityShells()
  end
end)

--[[-------------------------------------------------------------------------
  Network event:
  ASYNC NOTE:
    "kq_shellbuilder" triggers this when its shell list changes.
    We refresh our registry immediately on receiving the event.
---------------------------------------------------------------------------]]
RegisterNetEvent("kq_shellbuilder:update")
AddEventHandler("kq_shellbuilder:update", function()
  refreshKuzQualityShells()
end)