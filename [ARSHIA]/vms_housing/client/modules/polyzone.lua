--[[-------------------------------------------------------------------------
  Property Zone / Interior Detection (deobfuscated)

  What this file does:
    - Tracks which property zone the player is currently in (CurrentPropertyId/Data)
    - Detects entry/exit of:
        1) the outer "property zone" (metadata.zone)
        2) the inner "interior zone" (metadata.interiorZone) used mainly for MLO interiors
    - Loads/unloads:
        - Furniture (outside/inside for MLO)
        - Door targets (and refreshes them periodically for motel + MLO)
    - Cleans up targets and any active furniture editing when leaving a property zone
    - Provides geometry helpers:
        - getZoneCenter, calculatePolygonArea, isPointInPolygon
    - Debug drawing threads for property zones and region zones

  Async / Threads:
    - EnterZone() spawns a background thread that refreshes doors every 1500ms
    - 3 CreateThread loops:
        1) Debug property zones (Config.DebugPolyZone)
        2) Debug regions + /getRegion command (Config.DebugRegionsZone)
        3) Main player zone detection loop (always running)

  Server calls:
    - None in this snippet.
---------------------------------------------------------------------------]]

-- State flags
local isInPropertyZone = false        -- was L0_1
local isInsideInteriorZone = false    -- was L1_1 (also returned by IsInsideMLO)

-- Current property context
local currentPropertyId = nil         -- was L2_1
local currentPropertyData = nil       -- was L3_1

-- Exported accessors used by other files as fallback when CurrentProperty/CurrentPropertyData aren't set
function GetCurrentPropertyId()
  return currentPropertyId
end

function GetCurrentPropertyData()
  return currentPropertyData
end

-- Naming kept for compatibility with existing code (used to represent "inside interior zone")
function IsInsideMLO()
  return isInsideInteriorZone
end

-- --------------------------------------------------------------------------
-- Enter / Exit Zone
-- --------------------------------------------------------------------------

---Called when the player enters a property's outer zone.
---NOTE: Signature kept compatible with the obfuscated original.
---@param _ any
---@param propertyId any
---@param __ any
function EnterZone(_, propertyId, __)
  currentPropertyId = propertyId

  -- Wait until the system is fully loaded after restart (matches original behavior)
  while waitingForLoadAfterRestart do
    Citizen.Wait(200)
  end

  library.Debug(("You entered the Property Zone: %s"):format(currentPropertyId))

  local prop = Properties[currentPropertyId]
  if not prop then
    return
  end

  currentPropertyData = prop
  RefreshTargets()

  -- Load furniture for this property if present
  if currentPropertyData.furniture then
    -- Outside furniture
    Property:LoadFurniture("outside", currentPropertyData.furniture, currentPropertyId)

    -- For MLO properties, load inside furniture too
    if currentPropertyData.type == "mlo" then
      Property:LoadFurniture("inside", currentPropertyData.furniture, currentPropertyId)
    end
  end

  -- ------------------------------------------------------------------------
  -- ASYNC THREAD: Periodically refresh door targets while inside this property.
  -- This runs until currentPropertyId becomes nil or the property type isn't motel/mlo.
  -- ------------------------------------------------------------------------
  Citizen.CreateThread(function()
    while true do
      if not currentPropertyId then
        break
      end

      if prop.type ~= "motel" and prop.type ~= "mlo" then
        break
      end

      if prop.type == "motel" then
        -- Motel: refresh doors for motel rooms (typically MLO rooms)
        local motelRooms = Property:GetMotelRooms(currentPropertyData)

        -- Remove existing "door" targets (iterate backwards because we remove entries)
        for i = #TargetPoints, 1, -1 do
          if TargetPoints[i].type == "door" then
            CL.Target("remove-entity", TargetPoints[i].entity)
            table.remove(TargetPoints, i)
          end
        end

        -- Load doors per room
        for _, room in pairs(motelRooms) do
          if room.type == "mlo" then
            local doors = room.metadata.doors
            local roomKey = tostring(room.id)

            -- If room has owner/renter -> normal load
            if room.owner or room.renter then
              Property:LoadDoors(doors, roomKey, false)
            else
              -- Unowned rooms get an extra flag (kept identical to original call signature)
              Property:LoadDoors(doors, roomKey, false, true)
            end
          end
        end
      else
        -- MLO property: refresh doors for this property
        local doors = currentPropertyData.metadata.doors

        -- In original: last param is (currentPropertyData.owner == nil)
        local isUnowned = (currentPropertyData.owner == nil)
        Property:LoadDoors(doors, nil, true, isUnowned)
      end

      Wait(1500)
    end
  end)
end

---Called when the player leaves the property's outer zone.
---NOTE: Signature kept compatible with the obfuscated original.
---@param _ any
---@param __ any
---@param ___ any
function ExitZone(_, __, ___)
  library.Debug(("You have left the Property Zone: %s"):format(currentPropertyId))

  -- Clear property context
  isInPropertyZone = nil
  currentPropertyId = nil
  currentPropertyData = nil

  -- Remove loaded furniture
  Property:RemoveFurniture()

  -- If player was editing furniture, clean up the preview object and state
  if Property.EditingFurnitureObj then
    if DoesEntityExist(Property.EditingFurnitureObj) then
      DeleteObject(Property.EditingFurnitureObj)
    end

    Property.EditingFurniture = false
    Property.EditingFurnitureObj = nil
    Property.EditingFurnitureData = {}
  end

  -- Close any open UI related to property (kept as in original)
  closeNUI(true)

  -- Remove all targets created in this zone
  for i = 1, #TargetPoints do
    local tp = TargetPoints[i]

    if tp.type == "entity" or tp.type == "door" then
      CL.Target("remove-entity", tp.entity)
    else
      CL.Target("remove-zone", tp.id)
    end
  end

  TargetPoints = {}
  RefreshTargets()
end

-- --------------------------------------------------------------------------
-- Geometry helpers
-- --------------------------------------------------------------------------

---Returns the geometric center of a polygon (average of points) with optional Z midpoint.
---@param points table[] array of {x=number,y=number}
---@param minZ number|nil
---@param maxZ number|nil
---@return vector3
function getZoneCenter(points, minZ, maxZ)
  local sumX, sumY = 0, 0
  local count = #points

  for i = 1, count do
    sumX = sumX + points[i].x
    sumY = sumY + points[i].y
  end

  local z = 0.0
  if minZ and maxZ then
    z = (minZ + maxZ) / 2
  end

  return vector3(sumX / count, sumY / count, z)
end

---Shoelace formula polygon area (2D).
---If Config.AreaUnit == "ft2", converts from m^2 to ft^2.
---@param points table[] array of {x=number,y=number}
---@return number integer area (floored)
function calculatePolygonArea(points)
  local sum = 0
  local j = #points

  for i = 1, #points do
    sum = sum + (points[j].x + points[i].x) * (points[j].y - points[i].y)
    j = i
  end

  local area = math.abs(sum) / 2

  if Config.AreaUnit == "ft2" then
    area = area * 10.7639
  end

  return math.floor(area)
end

---Ray-casting point-in-polygon test (2D).
---@param point {x:number,y:number}
---@param poly table[] array of {x=number,y=number}
---@return boolean
function isPointInPolygon(point, poly)
  local intersections = 0
  local n = #poly
  local px, py = point.x, point.y

  for i = 1, n do
    local j = (i % n) + 1
    local a = poly[i]
    local b = poly[j]

    local aboveA = py < a.y
    local aboveB = py < b.y

    if aboveA ~= aboveB then
      local x = (b.x - a.x) * (py - a.y) / (b.y - a.y) + a.x
      if px < x then
        intersections = intersections + 1
      end
    end
  end

  return (intersections % 2) == 1
end

-- --------------------------------------------------------------------------
-- Debug wall drawing (vertical quad rendered as triangles)
-- --------------------------------------------------------------------------

---Draws a vertical "wall" between two 2D points from minZ to maxZ.
---@param p1 {x:number,y:number}
---@param p2 {x:number,y:number}
---@param minZ number
---@param maxZ number
---@param r number
---@param g number
---@param b number
function _drawWall(p1, p2, minZ, maxZ, r, g, b)
  local a1 = vector3(p1.x, p1.y, minZ)
  local a2 = vector3(p1.x, p1.y, maxZ)
  local b1 = vector3(p2.x, p2.y, minZ)
  local b2 = vector3(p2.x, p2.y, maxZ)

  -- Same 4 DrawPoly calls as original
  DrawPoly(a1, a2, b1, r, g, b, 70)
  DrawPoly(a2, b2, b1, r, g, b, 70)
  DrawPoly(b1, b2, a2, r, g, b, 70)
  DrawPoly(b1, a2, a1, r, g, b, 70)
end

-- --------------------------------------------------------------------------
-- ASYNC THREAD: Debug draw all property zones + interior zones
-- --------------------------------------------------------------------------
Citizen.CreateThread(function()
  while waitingForLoadAfterRestart do
    Citizen.Wait(200)
  end

  while Config.DebugPolyZone do
    for _, prop in pairs(Properties) do
      local zone = prop.metadata and prop.metadata.zone
      if zone and zone.points then
        local pts = zone.points

        for i = 1, #pts do
          local p1 = pts[i]
          local p2 = (i < #pts) and pts[i + 1] or pts[1]
          _drawWall(p1, p2, zone.minZ, zone.maxZ, 76, 17, 166)
        end

        local interior = prop.metadata and prop.metadata.interiorZone
        if interior and interior.points then
          local ipts = interior.points

          for i = 1, #ipts do
            local p1 = ipts[i]
            local p2 = (i < #ipts) and ipts[i + 1] or ipts[1]
            _drawWall(p1, p2, interior.minZ, interior.maxZ, 114, 49, 212)
          end
        end
      end
    end

    Citizen.Wait(1)
  end
end)

-- --------------------------------------------------------------------------
-- ASYNC THREAD: Debug draw region zones + optional /getRegion command
-- --------------------------------------------------------------------------
Citizen.CreateThread(function()
  while waitingForLoadAfterRestart do
    Citizen.Wait(200)
  end

  if Config.DebugRegionsZone then
    RegisterCommand("getRegion", function()
      local coords = GetEntityCoords(PlayerPedId())
      local region = library.GetCurrentRegion(coords.xyz) or "None"
      print(("Region: ^3%s"):format(region))
    end)
  end

  while Config.DebugRegionsZone do
    for _, regionData in pairs(Config.Regions) do
      local zone = regionData.zone
      if zone then
        for i = 1, #zone do
          local p1 = zone[i]
          local p2 = (i < #zone) and zone[i + 1] or zone[1]

          local r = (regionData.debugColor and regionData.debugColor.x) or 76
          local g = (regionData.debugColor and regionData.debugColor.y) or 17
          local b = (regionData.debugColor and regionData.debugColor.z) or 166

          _drawWall(p1, p2, -20.0, 350.0, r, g, b)
        end
      end
    end

    Citizen.Wait(1)
  end
end)

-- --------------------------------------------------------------------------
-- ASYNC THREAD: Main player zone detection loop
-- --------------------------------------------------------------------------
Citizen.CreateThread(function()
  while waitingForLoadAfterRestart do
    Citizen.Wait(200)
  end

  local shouldSleepLong = true

  while true do
    local ped = PlayerPedId()
    local coords = GetEntityCoords(ped)
    local point2D = vec2(coords.x, coords.y)

    shouldSleepLong = true

    -- Find any property zone that contains the player
    for propertyId, prop in pairs(Properties) do
      local zone = prop.metadata and prop.metadata.zone
      if zone and zone.points then
        if isPointInPolygon(point2D, zone.points) then
          if coords.z >= zone.minZ and coords.z <= zone.maxZ then
            -- Enter outer zone once
            if not isInPropertyZone then
              isInPropertyZone = true
              EnterZone(true, propertyId)
              Citizen.Wait(150)
            end

            -- Enter interior zone (if defined) once
            local interior = prop.metadata and prop.metadata.interiorZone
            if interior and interior.points then
              if isPointInPolygon(point2D, interior.points) then
                if coords.z >= interior.minZ and coords.z <= interior.maxZ then
                  if not isInsideInteriorZone then
                    isInsideInteriorZone = true
                    Property:EnterPropertyInterior(prop)
                  end
                end
              end
            end

            shouldSleepLong = false
            break
          end
        end
      end
    end

    -- Special motel case:
    -- If we have a current property id, are not marked inside interior, and current type is motel,
    -- check for MLO room interiors that belong to this motel's object_id.
    if currentPropertyId and not isInsideInteriorZone then
      if currentPropertyData and currentPropertyData.type == "motel" then
        for _, prop in pairs(Properties) do
          if prop.type == "mlo" and prop.object_id == tonumber(currentPropertyId) then
            local interior = prop.metadata and prop.metadata.interiorZone
            if interior and interior.points then
              if isPointInPolygon(point2D, interior.points) then
                if coords.z >= interior.minZ and coords.z <= interior.maxZ then
                  isInsideInteriorZone = true
                  Property:EnterPropertyInterior(prop, prop.id)
                end
              end
            end
          end
        end
      end
    end

    -- If we think we're inside interior zone, ensure we still are.
    -- NOTE: This intentionally checks the global CurrentPropertyData variable exactly like the original.
    if isInPropertyZone and currentPropertyId and currentPropertyData and isInsideInteriorZone then
      if CurrentPropertyData and CurrentPropertyData.metadata and CurrentPropertyData.metadata.interiorZone then
        local interior = CurrentPropertyData.metadata.interiorZone

        local inside2D = isPointInPolygon(point2D, interior.points)
        local insideZ = coords.z >= interior.minZ and coords.z <= interior.maxZ

        if not (inside2D and insideZ) then
          isInsideInteriorZone = false
          Property:ExitPropertyInterior()
        end
      end
    end

    -- Ensure we still remain inside the outer property zone; otherwise exit everything.
    if isInPropertyZone and currentPropertyId and currentPropertyData then
      local zone = currentPropertyData.metadata.zone

      local inside2D = isPointInPolygon(point2D, zone.points)
      local insideZ = coords.z >= zone.minZ and coords.z <= zone.maxZ

      if not (inside2D and insideZ) then
        isInPropertyZone = false
        isInsideInteriorZone = false

        ExitZone(true, currentPropertyId)
        Citizen.Wait(150)
      end
    end

    Citizen.Wait(shouldSleepLong and 800 or 100)
  end
end)
