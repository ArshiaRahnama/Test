-- Global registries (as in the original)
AvailableShells = {}
AvailableIPLS   = {}

--[[
  addShells(shells)
  Merges a table of shell definitions into AvailableShells.

  - Skips if the input table is empty (same behavior via next()).
  - If a shell key already exists, it warns and does NOT overwrite it.
]]
function addShells(shells)
  -- Same logic as: if not next(A0_2) then return end
  if not next(shells) then
    return
  end

  for shellName, shellData in pairs(shells) do
    if AvailableShells[shellName] == nil then
      AvailableShells[shellName] = shellData
    else
      -- Keep original warning wording/behavior
      warn(("Duplicated shell %s! (CANCELED ACTION)"):format(shellName))
    end
  end
end

--[[
  reloadShells()
  Sends the current list of shells to the NUI so the UI can refresh.

  NUI interaction:
  - SendNUIMessage is an async bridge to the browser UI.
  - action = "Reload" tells the UI what to do.
]]
function reloadShells()
  SendNUIMessage({
    action = "Reload",
    availableShells = AvailableShells,
  })
end

--[[
  addIPLS(ipls)
  Merges a table of IPL definitions into AvailableIPLS.

  - Skips if input table is empty.
  - Prevents duplicates (warns + does not overwrite).
]]
function addIPLS(ipls)
  if not next(ipls) then
    return
  end

  for iplName, iplData in pairs(ipls) do
    if AvailableIPLS[iplName] == nil then
      AvailableIPLS[iplName] = iplData
    else
      warn(("Duplicated IPL %s! (CANCELED ACTION)"):format(iplName))
    end
  end
end