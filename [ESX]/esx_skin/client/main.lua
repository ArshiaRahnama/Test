ESX                  = nil
local FirstSpawn     = true
local LastSkin       = nil
local PlayerLoaded   = false
local cam            = nil
local isCameraActive = false
local zoomOffset     = 0.0
local camOffset      = 0.0
local heading        = 90.0
local zoomTarget      = 0.6
local camTarget       = 0.65
local rotateDir       = 0
local menuOpen        = false
local menuSubmit      = nil
local menuCancel      = nil
local menuShop        = false
local menuElements    = {}
local elementsByName  = {}
local texChild        = {}
local camPoints       = {}
local focusedName     = nil
local menuColors      = (Config and Config.MenuColors) or { primary = '#b91c1c', secondary = '#ef4444' }
local PlayerData

Citizen.CreateThread(function()
  while ESX == nil do
    TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
    Citizen.Wait(0)
  end

  while ESX.GetPlayerData().job == nil do
    Citizen.Wait(20)
  end

  PlayerData = ESX.GetPlayerData()

end)

-- ===== Unique NUI skin menu =====
-- Server-specific rules kept from the previous menu: Config.whitelist hides
-- certain values for admins (perm >= 100) and for nojob/uwucafe.

local function copyFlat(t)
  local c = {}
  for k, v in pairs(t or {}) do c[k] = v end
  return c
end

local function clampNumber(value, minValue, maxValue)
  if value < minValue then return minValue end
  if value > maxValue then return maxValue end
  return value
end

local function getHiddenList()
  if not Config.whitelist or not PlayerData then return nil end
  local perm = tonumber(PlayerData.perm) or 0 -- old code crashed when perm was nil
  if perm >= 100 then
    return Config.whitelist['admins']
  elseif PlayerData.job and (PlayerData.job.name == 'nojob' or PlayerData.job.name == 'uwucafe') then
    return Config.whitelist['jobs']
  end
  return nil
end

local function isHidden(list, name, value)
  if not list then return false end
  for _, vv in ipairs(list) do
    if vv.name == name and vv.value == value then return true end
  end
  return false
end

-- Skip hidden values in the direction the player is moving (the old code always
-- added +1, so a hidden value could never be crossed going down).
local function adjustValue(name, value, previous, minValue, maxValue)
  local list = getHiddenList()
  if not list or not isHidden(list, name, value) then return value end
  local step = (value < previous) and -1 or 1
  local v, guard = value, 0
  while isHidden(list, name, v) and guard < 50 do
    v = v + step
    guard = guard + 1
  end
  if isHidden(list, name, v) or (minValue and v < minValue) or (maxValue and v > maxValue) then
    return previous
  end
  return v
end

function CloseSkinMenu()
  if not menuOpen then return end
  menuOpen = false
  menuShop = false
  rotateDir = 0
  menuSubmit, menuCancel = nil, nil
  SetNuiFocus(false, false)
  SendNUIMessage({ type = 'hide' })
  DeleteSkinCam()
end

local function makeMenuHandle()
  return { close = function() CloseSkinMenu() end }
end

function OpenMenu(submitCb, cancelCb, restrict, shop)

  if menuOpen then CloseSkinMenu() end

  local playerPed = PlayerPedId()

  TriggerEvent('skinchanger:getSkin', function(skin)
    LastSkin = copyFlat(skin)
  end)

  TriggerEvent('skinchanger:getData', function(components, maxVals)

    local _components = {}

    if restrict == nil then
      for i = 1, #components, 1 do
        _components[i] = components[i]
      end
    else
      for i = 1, #components, 1 do
        local found = false
        for j = 1, #restrict, 1 do
          if components[i].name == restrict[j] then found = true end
        end
        if found then table.insert(_components, components[i]) end
      end
    end

    if #_components == 0 then return end

    menuElements, elementsByName, texChild, camPoints = {}, {}, {}, {}

    for i = 1, #_components, 1 do
      local value       = _components[i].value
      local componentId = _components[i].componentId

      if componentId == 0 then
        value = GetPedPropIndex(playerPed, _components[i].componentId)
      end

      local data = {
        label     = _components[i].label,
        name      = _components[i].name,
        value     = value,
        min       = _components[i].min,
        textureof = _components[i].textureof
      }

      if data.name == 'arms_2' and data.textureof == nil then
        data.textureof = 'arms'
      end

      for k, v in pairs(maxVals) do
        if k == _components[i].name then data.max = v end
      end

      table.insert(menuElements, data)
      elementsByName[data.name] = data
      camPoints[data.name] = { zoom = _components[i].zoomOffset, cam = _components[i].camOffset }

      if data.textureof ~= nil then
        texChild[data.textureof] = data.name
      end
    end

    menuSubmit = submitCb
    menuCancel = cancelCb
    menuShop = shop and true or false
    focusedName = menuElements[1].name
    zoomTarget = camPoints[focusedName].zoom
    camTarget = camPoints[focusedName].cam
    zoomOffset = zoomTarget
    camOffset = camTarget
    heading = 90.0
    rotateDir = 0

    CreateSkinCam()

    menuOpen = true
    SetNuiFocus(true, true)
    SendNUIMessage({
      type     = 'show',
      title    = _U('skin_menu'),
      mode     = restrict ~= nil and 'outfit' or 'full',
      elements = menuElements,
      colors   = menuColors
    })
  end)
end

-- optional live theme (push per-player colors through this event)
AddEventHandler('unique_menu:settings', function(s)
  if type(s) ~= 'table' then return end
  local c = type(s.skin) == 'table' and s.skin or {}
  local secondary = c.color or s.default
  local primary = c.colorPrimary or secondary
  if secondary == nil then return end
  menuColors = { primary = primary, secondary = secondary }
  if menuOpen then SendNUIMessage({ type = 'colors', colors = menuColors }) end
end)

RegisterNUICallback('skin_change', function(data, cb)
  if not menuOpen or type(data) ~= 'table' then cb({ ok = false }) return end
  local element = elementsByName[data.name]
  if element == nil then cb({ ok = false }) return end

  local previous = element.value or 0
  local value = math.floor(tonumber(data.value) or 0)
  if element.min and value < element.min then value = element.min end
  if element.max and value > element.max then value = element.max end

  -- shop mode: per-sex blacklist (Config.ShopBlacklist)
  if menuShop and Config.ShopBlacklist then
    local skinSex
    TriggerEvent('skinchanger:getSkin', function(skin) skinSex = skin and skin.sex end)
    local bySex = skinSex ~= nil and Config.ShopBlacklist[skinSex] or nil
    if bySex and bySex[element.name] and bySex[element.name][value] then
      cb({ ok = false, blocked = true })
      return
    end
  end

  local adjusted = adjustValue(element.name, value, previous, element.min, element.max)
  if adjusted == previous and adjusted ~= value then
    cb({ ok = false, blocked = true })
    return
  end
  value = adjusted

  element.value = value
  focusedName = element.name
  if camPoints[element.name] ~= nil then
    zoomTarget = camPoints[element.name].zoom
    camTarget = camPoints[element.name].cam
  end

  TriggerEvent('skinchanger:change', element.name, value)
  local child = texChild[element.name]
  if child ~= nil then
    TriggerEvent('skinchanger:change', child, 0)
    if elementsByName[child] ~= nil then elementsByName[child].value = 0 end
  end
  cb({ ok = true, value = value })
end)

RegisterNUICallback('skin_refresh', function(data, cb)
  if not menuOpen then cb({}) return end
  TriggerEvent('skinchanger:getData', function(components, maxVals)
    local ped = PlayerPedId()
    local values, maxes = {}, {}
    for i = 1, #components, 1 do
      local c = components[i]
      local element = elementsByName[c.name]
      if element ~= nil then
        local value = c.value
        if c.componentId == 0 then value = GetPedPropIndex(ped, c.componentId) end
        element.value = value
        element.max = maxVals[c.name]
        values[c.name] = value
        maxes[c.name] = maxVals[c.name]
      end
    end
    cb({ values = values, max = maxes })
  end)
end)

RegisterNUICallback('skin_focus', function(data, cb)
  if menuOpen and type(data) == 'table' and camPoints[data.name] ~= nil then
    focusedName = data.name
    zoomTarget = camPoints[data.name].zoom
    camTarget = camPoints[data.name].cam
  end
  cb('ok')
end)

RegisterNUICallback('skin_camera', function(data, cb)
  cb('ok')
  if not menuOpen or type(data) ~= 'table' then return end
  local action = data.action
  if action == 'rotateStart' then
    rotateDir = tonumber(data.dir) or 0
  elseif action == 'rotateStop' then
    rotateDir = 0
  elseif action == 'rotateBy' then
    heading = (heading + (tonumber(data.delta) or 0)) % 360.0
  elseif action == 'zoom' then
    zoomTarget = clampNumber(zoomTarget + (tonumber(data.delta) or 0), 0.35, 2.5)
  elseif action == 'height' then
    camTarget = clampNumber(camTarget + (tonumber(data.delta) or 0), -1.2, 0.9)
  elseif action == 'reset' then
    heading = 90.0
    rotateDir = 0
    local point = focusedName ~= nil and camPoints[focusedName] or nil
    zoomTarget = point ~= nil and point.zoom or 0.6
    camTarget = point ~= nil and point.cam or 0.65
  end
end)

RegisterNUICallback('skin_submit', function(data, cb)
  cb('ok')
  if not menuOpen then return end
  local submitCb = menuSubmit
  local current = elementsByName[focusedName] or menuElements[1]
  TriggerEvent('skinchanger:getSkin', function(skin)
    LastSkin = copyFlat(skin)
  end)
  if submitCb ~= nil then
    submitCb({ current = current }, makeMenuHandle())
  end
  CloseSkinMenu()
end)

RegisterNUICallback('skin_cancel', function(data, cb)
  cb('ok')
  if not menuOpen then return end
  local cancelCb = menuCancel
  local current = elementsByName[focusedName] or menuElements[1]
  CloseSkinMenu()
  if LastSkin ~= nil then
    TriggerEvent('skinchanger:loadSkin', LastSkin)
  end
  if cancelCb ~= nil then
    cancelCb({ current = current }, makeMenuHandle())
  end
end)

AddEventHandler('onResourceStop', function(resource)
  if resource == GetCurrentResourceName() and menuOpen then
    SetNuiFocus(false, false)
    RenderScriptCams(false, false, 0, true, true)
  end
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
  PlayerData.job = job

end)

function CreateSkinCam()
  if not cam or not DoesCamExist(cam) then
    cam = CreateCam('DEFAULT_SCRIPTED_CAMERA', true)
  end
  SetCamActive(cam, true)
  RenderScriptCams(true, true, 500, true, true)
  isCameraActive = true
  SetCamRot(cam, 0.0, 0.0, 270.0, true)
  SetEntityHeading(PlayerPedId(), 90.0) -- old code used an undefined `playerPed` here
end

-- safe to call more than once (menu.close() + submit both call it)
function DeleteSkinCam()
  isCameraActive = false
  if cam and DoesCamExist(cam) then
    SetCamActive(cam, false)
    RenderScriptCams(false, true, 500, true, true)
  end
  cam = nil
end

Citizen.CreateThread(function()
  while true do
    Citizen.Wait(5)
    if isCameraActive and cam then
      DisableControlAction(2, 30, true)
      DisableControlAction(2, 31, true)
      DisableControlAction(2, 32, true)
      DisableControlAction(2, 33, true)
      DisableControlAction(2, 34, true)
      DisableControlAction(2, 35, true)
      DisableControlAction(0, 25, true)
      DisableControlAction(0, 24, true)

      if rotateDir ~= 0 then
        heading = (heading + rotateDir * 0.45) % 360.0
      end

      zoomOffset = zoomOffset + (zoomTarget - zoomOffset) * 0.08
      camOffset = camOffset + (camTarget - camOffset) * 0.08

      local playerPed = PlayerPedId()
      local coords    = GetEntityCoords(playerPed)

      local angle = heading * math.pi / 180.0
      local pos = {
        x = coords.x + (zoomOffset * math.cos(angle)),
        y = coords.y + (zoomOffset * math.sin(angle)),
      }

      local angleToLook = heading - 140.0
      if angleToLook > 360 then
        angleToLook = angleToLook - 360
      elseif angleToLook < 0 then
        angleToLook = angleToLook + 360
      end
      angleToLook = angleToLook * math.pi / 180.0
      local posToLook = {
        x = coords.x + (zoomOffset * math.cos(angleToLook)),
        y = coords.y + (zoomOffset * math.sin(angleToLook)),
      }

      SetCamCoord(cam, pos.x, pos.y, coords.z + camOffset)
      PointCamAtCoord(cam, posToLook.x, posToLook.y, coords.z + camOffset)
    else
      Citizen.Wait(500)
    end
  end
end)

function OpenSaveableMenu(submitCb, cancelCb, restrict, shop)

  TriggerEvent('skinchanger:getSkin', function(skin)
    LastSkin = skin
  end)

  OpenMenu(function(data, menu)

    menu.close()

    DeleteSkinCam()

    TriggerEvent('skinchanger:getSkin', function(skin)



      if submitCb ~= nil then
        submitCb(data, menu)
      end

    end)

  end, cancelCb, restrict, shop)

end

AddEventHandler('playerSpawned', function()

  Citizen.CreateThread(function()

    while not PlayerLoaded do
      Citizen.Wait(0)
    end

    if FirstSpawn then

      ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin, jobSkin)

        if skin == nil then
          TriggerEvent('skinchanger:loadSkin', {sex = 0})
           TriggerServerEvent("bms:tattoo:activateTattooShop2")
        else
          TriggerEvent('skinchanger:loadSkin', skin)
           TriggerServerEvent("bms:tattoo:activateTattooShop2")
        end

      end)

      FirstSpawn = false

    end

  end)

end)

RegisterNetEvent('esx_skin:reloadMe')
AddEventHandler('esx_skin:reloadMe', function()
  ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin, jobSkin)

    if skin == nil then
      TriggerEvent('skinchanger:loadSkin', {sex = 0})
    else
      TriggerEvent('skinchanger:loadSkin', skin)
    end

  end)
end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
  PlayerLoaded = true
end)

AddEventHandler('esx_skin:getLastSkin', function(cb)
  cb(LastSkin)
end)

AddEventHandler('esx_skin:setLastSkin', function(skin)
  LastSkin = skin
end)

RegisterNetEvent('esx_skin:openMenu')
AddEventHandler('esx_skin:openMenu', function(submitCb, cancelCb)
  OpenMenu(submitCb, cancelCb, nil)
end)

RegisterNetEvent('esx_skin:openRestrictedMenu')
AddEventHandler('esx_skin:openRestrictedMenu', function(submitCb, cancelCb, restrict, shop)
  -- NOTE: stays OpenMenu (no auto-save). Routing this to OpenSaveableMenu would
  -- let esx_accessories save a skin before payment.
  OpenMenu(submitCb, cancelCb, restrict, shop)
end)

RegisterNetEvent('esx_skin:openSaveableMenu')
AddEventHandler('esx_skin:openSaveableMenu', function(submitCb, cancelCb)
  OpenSaveableMenu(submitCb, cancelCb, nil)
end)

RegisterNetEvent('esx_skin:openSaveableRestrictedMenu')
AddEventHandler('esx_skin:openSaveableRestrictedMenu', function(submitCb, cancelCb, restrict, shop)
  OpenSaveableMenu(submitCb, cancelCb, restrict, shop)
end)

RegisterNetEvent('esx_skin:requestSaveSkin')
AddEventHandler('esx_skin:requestSaveSkin', function()
  TriggerEvent('skinchanger:getSkin', function(skin)
    TriggerServerEvent('esx_skin:responseSaveSkin', skin)
  end)
end)

RegisterNetEvent('esx_skin:changeVest')
AddEventHandler('esx_skin:changeVest', function(value1, value2)


  TriggerEvent('skinchanger:getSkin', function(skin)


         local clothesSkin = {
         ['bproof_1'] = value1,  ['bproof_2'] = value2
         }
         TriggerEvent('skinchanger:loadClothes', skin, clothesSkin)

    end)

end)

Citizen.CreateThread(function()
  while true do



    Citizen.Wait(250)

    local playerPed = GetPlayerPed(-1)

    if IsEntityDead(playerPed) then
      HasLoadedModel = false
    end

  end
end)
