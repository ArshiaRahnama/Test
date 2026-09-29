-- ============================================================================
--  Shared Utility Library (deobfuscated)
--  Keeps original behavior/logic, but rewritten for readability.
-- ============================================================================

library = library or {}

-- Internal state used by some helpers
library.WaitGameTimer   = nil   -- cooldown limiter timestamp (ms)
library.IsHaveProp      = nil   -- prop handle spawned by PlayAnimation (slot #1)
library.IsHaveProp2     = nil   -- prop handle spawned by PlayAnimation (slot #2)
library.IsPlayingAnimation = false

--[[--------------------------------------------------------------------------
  ActionLimiter(delayMs?)
  Simple anti-spam limiter using GetGameTimer().

  Returns:
    true  -> action is BLOCKED (still in cooldown, also shows notify.wait)
    false -> action is ALLOWED (and cooldown is updated)
----------------------------------------------------------------------------]]
function library.ActionLimiter(delayMs)
  local now = GetGameTimer()

  if library.WaitGameTimer and now <= library.WaitGameTimer then
    CL.Notification(TRANSLATE("notify.wait"), 4500, "info")
    return true
  end

  local cooldown = delayMs or 1500
  library.WaitGameTimer = now + cooldown
  return false
end

--[[--------------------------------------------------------------------------
  Debug(message, level?)
  Only prints when Config.Debug is true.
  level: "error" | "warn" | nil -> print
----------------------------------------------------------------------------]]
function library.Debug(message, level)
  if not Config.Debug then
    return
  end

  if level == "error" then
    error(message)
  elseif level == "warn" then
    warn(message)
  else
    print(message)
  end
end

--[[--------------------------------------------------------------------------
  Dump(value)
  JSON pretty-print helper (indent = true)
----------------------------------------------------------------------------]]
function library.Dump(value)
  return json.encode(value, { indent = true })
end

--[[--------------------------------------------------------------------------
  Deepcopy(value)
  Deep-copies tables recursively (including metatable), otherwise returns value.
----------------------------------------------------------------------------]]
function library.Deepcopy(value)
  if type(value) ~= "table" then
    return value
  end

  local copy = {}

  for k, v in next, value do
    copy[library.Deepcopy(k)] = library.Deepcopy(v)
  end

  -- Preserve metatable (original logic does deepcopy of getmetatable())
  return setmetatable(copy, library.Deepcopy(getmetatable(value)))
end

--[[--------------------------------------------------------------------------
  Callback(name, cb, ...)
  Framework wrapper:
    ESX -> ESX.TriggerServerCallback
    QB  -> QBCore.Functions.TriggerCallback
----------------------------------------------------------------------------]]
function library.Callback(callbackName, callbackFn, ...)
  if Config.Core == "ESX" then
    ESX.TriggerServerCallback(callbackName, callbackFn, ...)
  else
    QBCore.Functions.TriggerCallback(callbackName, callbackFn, ...)
  end
end

--[[--------------------------------------------------------------------------
  CallbackAwait(name, ...)
  Awaitable callback wrapper (uses promise + Citizen.Await).

  Returns whatever the server callback returns.
  [ASYNC] This yields until server responds.
----------------------------------------------------------------------------]]
function library.CallbackAwait(callbackName, ...)
  local p = promise.new()

  if Config.Core == "ESX" then
    ESX.TriggerServerCallback(callbackName, function(...)
      p:resolve(...)
    end, ...)
  else
    QBCore.Functions.TriggerCallback(callbackName, function(...)
      p:resolve(...)
    end, ...)
  end

  return Citizen.Await(p)
end

--[[--------------------------------------------------------------------------
  CreateBlip(data)
  data = {
    coords = vector3(...),
    sprite, display, scale, color, name,
    blipCategory? (optional)
  }
----------------------------------------------------------------------------]]
function library.CreateBlip(data)
  local blip = AddBlipForCoord(data.coords)

  SetBlipSprite(blip, data.sprite)
  SetBlipDisplay(blip, data.display)
  SetBlipScale(blip, data.scale)
  SetBlipColour(blip, data.color)
  SetBlipAsShortRange(blip, true)

  BeginTextCommandSetBlipName("STRING")
  AddTextComponentString(data.name)
  EndTextCommandSetBlipName(blip)

  if data.blipCategory ~= nil then
    SetBlipCategory(blip, data.blipCategory)
  end

  return blip
end

--[[--------------------------------------------------------------------------
  DeleteBlip(blip)
----------------------------------------------------------------------------]]
function library.DeleteBlip(blip)
  if blip then
    RemoveBlip(blip)
    return nil
  end
end

--[[--------------------------------------------------------------------------
  RequestEntity(model)
  Requests a model and waits until it loads or timeout (5s).

  Returns:
    true  -> model loaded
    false -> timed out
----------------------------------------------------------------------------]]
function library.RequestEntity(model)
  local ok = true
  local timeoutAt = GetGameTimer() + 5000

  -- Keep original "string or number" handling exactly:
  local modelHash = tonumber(model)
  modelHash = model or modelHash
  if (not modelHash) or (not model) then
    modelHash = GetHashKey(model)
  end

  RequestModel(modelHash)

  while true do
    if HasModelLoaded(modelHash) then
      break
    end

    RequestModel(modelHash)

    if GetGameTimer() > timeoutAt then
      ok = false
      break
    end

    Wait(1)
  end

  return ok
end

--[[--------------------------------------------------------------------------
  SpawnPed(opts)
  opts = {
    model = <hash or model name>,
    coords = vector4/coords (x,y,z,w optional),
    animation = { dict, name } optional
  }

  Returns ped entity id.
----------------------------------------------------------------------------]]
function library.SpawnPed(opts)
  library.RequestEntity(opts.model)

  local heading = (opts.coords.w ~= nil) and opts.coords.w or 0.0
  local ped = CreatePed(
    4,
    opts.model,
    opts.coords.x,
    opts.coords.y,
    opts.coords.z,
    heading,
    false,
    true
  )

  FreezeEntityPosition(ped, true)
  SetEntityInvincible(ped, true)
  TaskSetBlockingOfNonTemporaryEvents(ped, true)

  if opts.animation then
    library.PlayAnimation(
      ped,
      opts.animation[1],
      opts.animation[2],
      8.0,
      8.0,
      -1,
      1
    )
  end

  return ped
end

--[[--------------------------------------------------------------------------
  SpawnProp(model, coords?, heading?, attachData?, disableCollision?, dynamic?)
  This function keeps the original parameter behavior exactly.

  model: string/hash
  coords: vec3-like {x,y,z} (optional; defaults to player coords)
  heading: number
  attachData: { attachTo, boneIndex, placement={x,y,z,rx,ry,rz} } optional
  disableCollision: boolean (if true -> no collision)
  dynamic: boolean passed into CreateObject as last arg (defaults false)

  Returns object entity id.
----------------------------------------------------------------------------]]
function library.SpawnProp(model, coords, heading, attachData, disableCollision, dynamic)
  local playerPed = PlayerPedId()

  -- Keep original "string or number" handling exactly:
  local modelHash = tonumber(model)
  modelHash = model or modelHash
  if (not modelHash) or (not model) then
    modelHash = GetHashKey(model)
  end

  local spawnCoords
  if coords then
    spawnCoords = vec(coords.x, coords.y, coords.z)
  else
    spawnCoords = GetEntityCoords(playerPed)
  end

  library.RequestEntity(modelHash)

  local obj = CreateObject(
    modelHash,
    spawnCoords.xyz,
    heading,
    false,
    true,
    dynamic or false
  )

  if attachData then
    AttachEntityToEntity(
      obj,
      attachData.attachTo,
      attachData.boneIndex,
      attachData.placement[1],
      attachData.placement[2],
      attachData.placement[3],
      attachData.placement[4],
      attachData.placement[5],
      attachData.placement[6],
      true,
      true,
      false,
      true,
      1,
      true
    )
  end

  if disableCollision then
    SetEntityCollision(obj, false, true)
  end

  return obj
end

--[[--------------------------------------------------------------------------
  LoadDict(dict)
  Requests an anim dict with a ~5s timeout (same behavior as obfuscated code).
----------------------------------------------------------------------------]]
function library.LoadDict(dict)
  local timedOut = false

  SetTimeout(5000, function()
    timedOut = true
  end)

  repeat
    RequestAnimDict(dict)
    Wait(50)
  until HasAnimDictLoaded(dict) or timedOut
end

--[[--------------------------------------------------------------------------
  PlayAnimation(ped, dict, anim, blendIn?, blendOut?, duration, flags, prop1?, prop2?)
  Spawns optional props while playing an animation:
    prop1/prop2 format: { modelName, coords?, heading?, attachData?, disableCollision? }

  NOTE: This function sets:
    library.IsHaveProp / library.IsHaveProp2
    library.IsPlayingAnimation = true
----------------------------------------------------------------------------]]
function library.PlayAnimation(ped, dict, anim, blendIn, blendOut, duration, flags, prop1, prop2)
  library.LoadDict(dict)

  -- Optional prop #1
  if prop1 then
    library.IsHaveProp = library.SpawnProp(
      GetHashKey(prop1[1]),
      prop1[2],
      prop1[3],
      prop1[4],
      prop1[5]
    )
  end

  -- Optional prop #2
  if prop2 then
    library.IsHaveProp2 = library.SpawnProp(
      GetHashKey(prop2[1]),
      prop2[2],
      prop2[3],
      prop2[4],
      prop2[5]
    )
  end

  library.IsPlayingAnimation = true

  TaskPlayAnim(
    ped,
    dict,
    anim,
    blendIn or 8.0,
    blendOut or 8.0,
    duration,
    flags,
    0,
    false,
    false,
    false
  )
end

--[[--------------------------------------------------------------------------
  StopAnimation(ped)
  Deletes spawned props and clears ped tasks if an animation was considered active.
----------------------------------------------------------------------------]]
function library.StopAnimation(ped)
  if library.IsHaveProp then
    DeleteEntity(library.IsHaveProp)
    library.IsHaveProp = nil
  end

  if library.IsHaveProp2 then
    DeleteEntity(library.IsHaveProp2)
    library.IsHaveProp2 = nil
  end

  if library.IsPlayingAnimation then
    ClearPedTasks(ped)
  end

  library.IsPlayingAnimation = false
end

--[[--------------------------------------------------------------------------
  StartParticles(assetName, fxName, coords, rot, scale, colorData?)
  colorData = { r, g, b, alpha? } (strings/numbers)
----------------------------------------------------------------------------]]
function library.StartParticles(assetName, fxName, coords, rot, scale, colorData)
  RequestNamedPtfxAsset(assetName)
  while not HasNamedPtfxAssetLoaded(assetName) do
    Citizen.Wait(10)
  end

  UseParticleFxAssetNextCall(assetName)

  local fxHandle = StartParticleFxLoopedAtCoord(
    fxName,
    coords.x, coords.y, coords.z,
    rot.x, rot.y, rot.z,
    scale,
    0.0, 0.0, 0.0,
    0
  )

  if colorData and colorData[1] then
    SetParticleFxLoopedColour(
      fxHandle,
      tonumber(colorData[1]) + 0.0,
      tonumber(colorData[2]) + 0.0,
      tonumber(colorData[3]) + 0.0,
      false
    )

    if colorData[4] then
      SetParticleFxLoopedAlpha(fxHandle, tonumber(colorData[4]) + 0.0)
    end
  end

  return fxHandle
end

--[[--------------------------------------------------------------------------
  StopParticles(handle)
----------------------------------------------------------------------------]]
function library.StopParticles(handle)
  if DoesParticleFxLoopedExist(handle) then
    RemoveParticleFx(handle, false)
  end
end

--[[--------------------------------------------------------------------------
  PlayAudio(key)
  Plays a UI audio file via NUI:
    SendNUIMessage({ action="PlayAudio", file=..., volume=... })
----------------------------------------------------------------------------]]
function library.PlayAudio(key)
  local file = ""
  local volume = 0

  if key == "enterHouse" then
    file, volume = "enter_house", 0.1
  elseif key == "exitHouse" then
    file, volume = "exit_house", 0.1
  elseif key == "openDoors" then
    file, volume = "open_doors", 0.1
  elseif key == "lockDoors" then
    file, volume = "lock_doors", 0.05
  elseif key == "doorbell" then
    file, volume = "doorbell", 0.005
  elseif key == "doorbellInside" then
    file, volume = "doorbell", 0.1
  elseif key == "lightSwitch" then
    file, volume = "light_switch", 0.12
  end

  if file == "" then
    return
  end

  -- [NUI]
  SendNUIMessage({
    action = "PlayAudio",
    file = file,
    volume = volume,
  })
end

--[[--------------------------------------------------------------------------
  GetCurrentRegion(point)
  Returns region key where point is inside Config.Regions[region].zone polygon.
----------------------------------------------------------------------------]]
function library.GetCurrentRegion(point)
  for regionKey, regionData in pairs(Config.Regions) do
    if regionData.zone then
      if isPointInPolygon(point, regionData.zone) then
        return regionKey
      end
    end
  end

  return nil
end

--[[--------------------------------------------------------------------------
  HasKeys(propertyId)
  NOTE:
    - If Config.UseKeysOnItem is false -> checks owner/renter/keys string
    - If Config.UseKeysOnItem is true  -> client can't reliably inspect inventory metadata across
      all supported inventories, so this returns true only for owner/renter as UI gating.
      (Server-side checks are always the source of truth.)
----------------------------------------------------------------------------]]
function library.HasKeys(propertyId)
  if not propertyId then
    return false
  end

  local property = Properties[propertyId] or Properties[tostring(propertyId)]
  if not property then
    return false
  end

  if not Config.UseKeysOnItem then
    if Identifier and property.owner == Identifier then
      return true
    end

    if Identifier and property.renter == Identifier then
      return true
    end

    if Identifier and property.keys then
      if string.find(tostring(property.keys), tostring(Identifier), 1, true) then
        return true
      end
    end

    return false
  end

  -- Keys are inventory items in this mode. Client can't reliably inspect all inventories here,
  -- so only treat owner/renter as key-holders for UI gating (server still enforces real key checks).
  if Identifier and (property.owner == Identifier or property.renter == Identifier) then
    return true
  end

  return false
end
 
--[[--------------------------------------------------------------------------
  Permissions helpers (client-side mirror of server/lib.lua)
  Used by target refresh logic and management UI gating.
----------------------------------------------------------------------------]]
function library.HasPermissions(propertyId, permissionKey)
  if not propertyId or not permissionKey then
    return false
  end

  local property = Properties[propertyId] or Properties[tostring(propertyId)]
  if not property then
    return false
  end
 
  if property.owner and property.owner == Identifier then
    return true
  end
 
  local perms = property.permissions
  if perms and perms[Identifier] and perms[Identifier][permissionKey] then
    return true
  end
 
  return false
end
 
function library.HasAnyPermission(propertyId)
  if not propertyId then
    return false
  end

  local property = Properties[propertyId] or Properties[tostring(propertyId)]
  if not property then
    return false
  end
 
  if property.owner and property.owner == Identifier then
    return true
  end
 
  -- Backwards-compatible: allow renter even if permissions table wasn't populated
  if property.renter and property.renter == Identifier then
    return true
  end
 
  local perms = property.permissions
  if perms and perms[Identifier] then
    return true
  end
 
  return false
end

--[[--------------------------------------------------------------------------
  Inventory helpers (client-side)
  Used for target/UI gating only (server still enforces real checks).
----------------------------------------------------------------------------]]
function library.GetItemCount(itemName)
  if not itemName or itemName == "" then
    return 0
  end

  local searchName = tostring(itemName)

  -- Prefer ox_inventory when it's the active inventory.
  if Config.Inventory == "ox_inventory" and GetResourceState("ox_inventory") == "started" then
    local ok, result = pcall(function()
      return exports.ox_inventory:Search("count", searchName)
    end)

    if ok and type(result) == "number" then
      return result
    end
  end

  -- QB inventory items
  if Config.Core == "QB-Core" then
    local items = nil

    if PlayerData and type(PlayerData) == "table" and type(PlayerData.items) == "table" then
      items = PlayerData.items
    elseif QBCore and QBCore.Functions and QBCore.Functions.GetPlayerData then
      local pd = QBCore.Functions.GetPlayerData()
      if pd and type(pd.items) == "table" then
        items = pd.items
      end
    end

    if items then
      for _, item in pairs(items) do
        if item and item.name == searchName then
          local amount = tonumber(item.amount or item.count or item.quantity) or 0
          return amount
        end
      end
    end
  end

  -- ESX inventory items
  if Config.Core == "ESX" then
    local inv = nil

    if PlayerData and type(PlayerData) == "table" and type(PlayerData.inventory) == "table" then
      inv = PlayerData.inventory
    elseif ESX and ESX.GetPlayerData then
      local pd = ESX.GetPlayerData()
      if pd and type(pd.inventory) == "table" then
        inv = pd.inventory
      end
    end

    if inv then
      for _, item in pairs(inv) do
        if item and item.name == searchName then
          local count = tonumber(item.count or item.amount or item.quantity) or 0
          return count
        end
      end
    end
  end

  return 0
end

function library.HasItem(itemName, count)
  local needed = tonumber(count) or 1
  if needed < 1 then
    needed = 1
  end

  return library.GetItemCount(itemName) >= needed
end

-- NOTE:
-- Your snippet ends at: `function L1_1(A0_2, A1_2) ...`
-- If you paste the continuation, I’ll continue deobfuscating the rest in the same style.
