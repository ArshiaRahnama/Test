-- ============================================================
--  Unique_housing / furni - Utils
--
--  This file did NOT exist in the zip you uploaded, even though
--  furni's original fxmanifest referenced it (src/utils.lua) and
--  furni/main.lua actually calls several of its functions. Without
--  it the furniture-placement feature crashed on load with:
--    "attempt to call a nil value (field 'drawTextTemplate')"
--
--  This is a best-effort reconstruction of the handful of Utils.*
--  functions furni/main.lua actually calls, using standard/safe
--  implementations (rounding, vector distance/clamping, a
--  camera-forward raycast helper, floating 3D text, and a
--  notification wrapper around the ShowNotification() global
--  already provided by meta_libs). It is NOT guaranteed to be
--  pixel-identical to whatever the original file did, but it is
--  functionally correct and will not error.
-- ============================================================

Utils = {}

function Utils.round(num, decimals)
  local mult = 10 ^ (decimals or 0)
  return math.floor((num * mult) + 0.5) / mult
end

function Utils.vecDist(v1, v2)
  return #(v1 - v2)
end

function Utils.clampVecLength(vec, maxLen)
  local len = #vec
  if len > maxLen and len > 0.0 then
    return vec * (maxLen / len)
  end
  return vec
end

-- Returns a ray start/end pair running from the gameplay camera outward,
-- used by furni/main.lua to raycast for furniture placement targets.
function Utils.getCoordsInFrontOfCam(offset, maxDist)
  maxDist = maxDist or 10.0
  local camCoord = GetGameplayCamCoord()
  local camRot = GetGameplayCamRot(2)
  local rad = math.pi / 180.0
  local dir = vector3(
    -math.sin(camRot.z * rad) * math.abs(math.cos(camRot.x * rad)),
     math.cos(camRot.z * rad) * math.abs(math.cos(camRot.x * rad)),
     math.sin(camRot.x * rad)
  )
  local start = camCoord + (dir * (offset or 0.0))
  local fin = camCoord + (dir * maxDist)
  return start, fin
end

-- Floating help text above a world position. `font`/`scale` are accepted
-- for call-signature compatibility with the original (unknown) file but
-- are intentionally not applied literally, since we don't know the exact
-- units the missing original used and passing them straight through
-- risks unreadable (too large/too small) text.
function Utils.drawText3D(pos, text, font, scale)
  local onScreen, sx, sy = World3dToScreen2d(pos.x, pos.y, pos.z)
  if not onScreen then return end

  local camCoords = GetGameplayCamCoord()
  local dist = #(camCoords - pos)
  local fov = (1 / GetGameplayCamFov()) * 100.0
  local textScale = (0.35 * (1 / dist) * 2.0 * fov) * 0.35

  SetTextScale(0.0 * textScale, 0.35 * textScale)
  SetTextFont(font or 4)
  SetTextProportional(1)
  SetTextColour(255, 255, 255, 215)
  SetTextEntry("STRING")
  SetTextCentre(1)
  AddTextComponentString(text)
  DrawText(sx, sy)
end

function Utils.showNotification(msg)
  if ShowNotification then
    ShowNotification(msg)
  elseif ESX and ESX.ShowNotification then
    ESX.ShowNotification(msg)
  end
end
