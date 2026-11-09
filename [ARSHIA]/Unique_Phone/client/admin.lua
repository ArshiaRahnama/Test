local L0_1, L1_1, L2_1, L3_1, L4_1, L5_1, L6_1, L7_1
L0_1 = OverlayClientHooks
if not L0_1 then
  L0_1 = {}
end
OverlayClientHooks = L0_1
L0_1 = RegisterNetEvent
L1_1 = "apex_phone:client:adminOpen"
function L2_1()
  local L0_2, L1_2, L2_2, L3_2
  L0_2 = FW
  if L0_2 then
    L0_2 = FW
    L0_2 = L0_2.IsDead
    if L0_2 then
      L0_2 = FW
      L0_2 = L0_2.IsDead
      L0_2 = L0_2()
      if L0_2 then
        return
      end
    end
  end
  L0_2 = OverlayOpen
  L1_2 = "admin"
  L2_2 = "admin:open"
  L3_2 = {}
  L0_2(L1_2, L2_2, L3_2)
end
L0_1(L1_1, L2_1)
L0_1 = RegisterNetEvent
L1_1 = "apex_phone:client:adminClose"
function L2_1()
  local L0_2, L1_2
  L0_2 = OverlayClose
  L1_2 = "admin"
  L0_2(L1_2)
end
L0_1(L1_1, L2_1)
L0_1 = exports
L1_1 = "OpenAdminPanel"
function L2_1()
  local L0_2, L1_2
  L0_2 = TriggerServerEvent
  L1_2 = "apex_phone:server:adminRequest"
  L0_2(L1_2)
end
L0_1(L1_1, L2_1)
L0_1 = nil
function L1_1()
  local L0_2, L1_2
  L0_2 = L0_1
  if L0_2 then
    L0_2 = UnregisterPedheadshot
    L1_2 = L0_1
    L0_2(L1_2)
    L0_2 = nil
    L0_1 = L0_2
  end
end
function L2_1(A0_2, A1_2, A2_2)
  local L3_2, L4_2, L5_2, L6_2, L7_2
  if A1_2 then
    L3_2 = RegisterPedheadshotTransparent
    L4_2 = A0_2
    L3_2 = L3_2(L4_2)
    if L3_2 then
      goto lbl_11
    end
  end
  L3_2 = RegisterPedheadshot
  L4_2 = A0_2
  L3_2 = L3_2(L4_2)
  ::lbl_11::
  if not L3_2 or 0 == L3_2 then
    L4_2 = nil
    return L4_2
  end
  L4_2 = GetGameTimer
  L4_2 = L4_2()
  L4_2 = L4_2 + A2_2
  while true do
    L5_2 = IsPedheadshotReady
    L6_2 = L3_2
    L5_2 = L5_2(L6_2)
    if L5_2 then
      L5_2 = IsPedheadshotValid
      L6_2 = L3_2
      L5_2 = L5_2(L6_2)
      if L5_2 then
        break
      end
    end
    L5_2 = GetGameTimer
    L5_2 = L5_2()
    if L4_2 < L5_2 then
      L5_2 = UnregisterPedheadshot
      L6_2 = L3_2
      L5_2(L6_2)
      L5_2 = nil
      return L5_2
    end
    L5_2 = Wait
    L6_2 = 50
    L5_2(L6_2)
  end
  L5_2 = GetPedheadshotTxdString
  L6_2 = L3_2
  L5_2 = L5_2(L6_2)
  if not L5_2 or "" == L5_2 then
    L6_2 = UnregisterPedheadshot
    L7_2 = L3_2
    L6_2(L7_2)
    L6_2 = nil
    return L6_2
  end
  L6_2 = L3_2
  L7_2 = L5_2
  return L6_2, L7_2
end
L3_1 = OverlayClientHooks
function L4_1()
  local L0_2, L1_2, L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2
  L0_2 = L1_1
  L0_2()
  L0_2 = PlayerPedId
  L0_2 = L0_2()
  if L0_2 and 0 ~= L0_2 then
    L1_2 = DoesEntityExist
    L2_2 = L0_2
    L1_2 = L1_2(L2_2)
    if L1_2 then
      goto lbl_18
    end
  end
  L1_2 = {}
  L1_2.ok = false
  do return L1_2 end
  ::lbl_18::
  L1_2 = pcall
  L2_2 = L2_1
  L3_2 = L0_2
  L4_2 = true
  L5_2 = 6000
  L1_2, L2_2, L3_2 = L1_2(L2_2, L3_2, L4_2, L5_2)
  if not L1_2 or not L2_2 then
    L4_2 = pcall
    L5_2 = L2_1
    L6_2 = L0_2
    L7_2 = false
    L8_2 = 4000
    L4_2, L5_2, L6_2 = L4_2(L5_2, L6_2, L7_2, L8_2)
    if not L4_2 or not L5_2 then
      L7_2 = {}
      L7_2.ok = false
      return L7_2
    end
    L7_2 = L5_2
    L3_2 = L6_2
    L2_2 = L7_2
  end
  L0_1 = L2_2
  L4_2 = {}
  L4_2.ok = true
  L5_2 = "https://nui-img/%s/%s"
  L6_2 = L5_2
  L5_2 = L5_2.format
  L7_2 = L3_2
  L8_2 = L3_2
  L5_2 = L5_2(L6_2, L7_2, L8_2)
  L4_2.url = L5_2
  return L4_2
end
L3_1["admin.me.photo"] = L4_1
L3_1 = AddEventHandler
L4_1 = "apex_phone:overlayClosed"
function L5_1(A0_2)
  local L1_2, L2_2
  if "admin" == A0_2 then
    L1_2 = TriggerServerEvent
    L2_2 = "apex_phone:server:adminClosed"
    L1_2(L2_2)
    L1_2 = L1_1
    L1_2()
  end
end
L3_1(L4_1, L5_1)
L3_1 = AddEventHandler
L4_1 = "onResourceStop"
function L5_1(A0_2)
  local L1_2
  L1_2 = GetCurrentResourceName
  L1_2 = L1_2()
  if A0_2 == L1_2 then
    L1_2 = L1_1
    L1_2()
  end
end
L3_1(L4_1, L5_1)
function L3_1(A0_2)
  local L1_2, L2_2, L3_2
  L1_2 = math
  L1_2 = L1_2.floor
  L2_2 = tonumber
  L3_2 = A0_2
  L2_2 = L2_2(L3_2)
  if not L2_2 then
    L2_2 = 0
  end
  L2_2 = L2_2 * 100
  L2_2 = L2_2 + 0.5
  L1_2 = L1_2(L2_2)
  L1_2 = L1_2 / 100
  return L1_2
end
L4_1 = OverlayClientHooks
function L5_1()
  local L0_2, L1_2, L2_2, L3_2, L4_2, L5_2
  L0_2 = PlayerPedId
  L0_2 = L0_2()
  L1_2 = GetEntityCoords
  L2_2 = L0_2
  L1_2 = L1_2(L2_2)
  L2_2 = {}
  L2_2.ok = true
  L3_2 = L3_1
  L4_2 = L1_2.x
  L3_2 = L3_2(L4_2)
  L2_2.x = L3_2
  L3_2 = L3_1
  L4_2 = L1_2.y
  L3_2 = L3_2(L4_2)
  L2_2.y = L3_2
  L3_2 = L3_1
  L4_2 = L1_2.z
  L3_2 = L3_2(L4_2)
  L2_2.z = L3_2
  L3_2 = math
  L3_2 = L3_2.floor
  L4_2 = GetEntityHeading
  L5_2 = L0_2
  L4_2 = L4_2(L5_2)
  L4_2 = L4_2 * 10
  L4_2 = L4_2 + 0.5
  L3_2 = L3_2(L4_2)
  L3_2 = L3_2 / 10
  L2_2.w = L3_2
  return L2_2
end
L4_1["admin.here"] = L5_1
function L4_1(A0_2)
  local L1_2
  L1_2 = true == A0_2 or 1 == A0_2
  return L1_2
end
L5_1 = false
L6_1 = OverlayClientHooks
function L7_1(A0_2)
  local L1_2, L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2
  L1_2 = tonumber
  L2_2 = A0_2.x
  L1_2 = L1_2(L2_2)
  L2_2 = tonumber
  L3_2 = A0_2.y
  L2_2 = L2_2(L3_2)
  L3_2 = tonumber
  L4_2 = A0_2.z
  L3_2 = L3_2(L4_2)
  if not (L1_2 and L2_2) or not L3_2 then
    L4_2 = {}
    L4_2.ok = false
    L4_2.error = "invalid"
    return L4_2
  end
  L4_2 = L5_1
  if L4_2 then
    L4_2 = {}
    L4_2.ok = false
    L4_2.error = "busy"
    return L4_2
  end
  L4_2 = tonumber
  L5_2 = A0_2.w
  L4_2 = L4_2(L5_2)
  if not L4_2 then
    L4_2 = 0.0
  end
  L5_2 = A0_2.front
  if L5_2 then
    L5_2 = math
    L5_2 = L5_2.rad
    L6_2 = L4_2
    L5_2 = L5_2(L6_2)
    L6_2 = math
    L6_2 = L6_2.sin
    L7_2 = L5_2
    L6_2 = L6_2(L7_2)
    L6_2 = L6_2 * 1.6
    L6_2 = L1_2 - L6_2
    L7_2 = math
    L7_2 = L7_2.cos
    L8_2 = L5_2
    L7_2 = L7_2(L8_2)
    L7_2 = L7_2 * 1.6
    L2_2 = L2_2 + L7_2
    L1_2 = L6_2
    L6_2 = L4_2 + 180.0
    L4_2 = L6_2 % 360.0
  end
  L5_2 = true
  L5_1 = L5_2
  L5_2 = CreateThread
  function L6_2()
    local L0_3, L1_3, L2_3, L3_3, L4_3, L5_3, L6_3, L7_3, L8_3, L9_3, L10_3, L11_3, L12_3
    L0_3 = PlayerPedId
    L0_3 = L0_3()
    L1_3 = L0_3
    L2_3 = GetVehiclePedIsIn
    L3_3 = L0_3
    L4_3 = false
    L2_3 = L2_3(L3_3, L4_3)
    if 0 ~= L2_3 then
      L3_3 = GetPedInVehicleSeat
      L4_3 = L2_3
      L5_3 = -1
      L3_3 = L3_3(L4_3, L5_3)
      if L3_3 == L0_3 then
        L1_3 = L2_3
      end
    end
    L3_3 = FreezeEntityPosition
    L4_3 = L1_3
    L5_3 = true
    L3_3(L4_3, L5_3)
    L3_3 = RequestCollisionAtCoord
    L4_3 = L1_2
    L5_3 = L2_2
    L6_3 = L3_2
    L3_3(L4_3, L5_3, L6_3)
    L3_3 = SetEntityCoordsNoOffset
    L4_3 = L1_3
    L5_3 = L1_2
    L6_3 = L2_2
    L7_3 = L3_2
    L7_3 = L7_3 + 0.5
    L8_3 = false
    L9_3 = false
    L10_3 = false
    L3_3(L4_3, L5_3, L6_3, L7_3, L8_3, L9_3, L10_3)
    L3_3 = nil
    L4_3 = GetGameTimer
    L4_3 = L4_3()
    L4_3 = L4_3 + 2000
    while true do
      L5_3 = GetGameTimer
      L5_3 = L5_3()
      if not (L4_3 > L5_3) then
        break
      end
      L5_3 = RequestCollisionAtCoord
      L6_3 = L1_2
      L7_3 = L2_2
      L8_3 = L3_2
      L5_3(L6_3, L7_3, L8_3)
      L5_3 = GetGroundZFor_3dCoord
      L6_3 = L1_2
      L7_3 = L2_2
      L8_3 = L3_2
      L8_3 = L8_3 + 2.0
      L9_3 = false
      L5_3, L6_3 = L5_3(L6_3, L7_3, L8_3, L9_3)
      L7_3 = L4_1
      L8_3 = L5_3
      L7_3 = L7_3(L8_3)
      if L7_3 and L6_3 then
        L7_3 = math
        L7_3 = L7_3.abs
        L8_3 = L3_2
        L8_3 = L6_3 - L8_3
        L7_3 = L7_3(L8_3)
        if L7_3 < 6.0 then
          L3_3 = L6_3
          break
        end
      end
      L7_3 = L4_1
      L8_3 = HasCollisionLoadedAroundEntity
      L9_3 = L1_3
      L8_3, L9_3, L10_3, L11_3, L12_3 = L8_3(L9_3)
      L7_3 = L7_3(L8_3, L9_3, L10_3, L11_3, L12_3)
      if L7_3 then
        L7_3 = GetGameTimer
        L7_3 = L7_3()
        L8_3 = L4_3 - 1200
        if L7_3 > L8_3 then
          L7_3 = GetGroundZFor_3dCoord
          L8_3 = L1_2
          L9_3 = L2_2
          L10_3 = L3_2
          L10_3 = L10_3 + 2.0
          L11_3 = false
          L7_3, L8_3 = L7_3(L8_3, L9_3, L10_3, L11_3)
          L6_3 = L8_3
          L5_3 = L7_3
          L7_3 = L4_1
          L8_3 = L5_3
          L7_3 = L7_3(L8_3)
          if L7_3 and L6_3 then
            L3_3 = L6_3
          end
          break
        end
      end
      L7_3 = Wait
      L8_3 = 50
      L7_3(L8_3)
    end
    L5_3 = SetEntityCoordsNoOffset
    L6_3 = L1_3
    L7_3 = L1_2
    L8_3 = L2_2
    L9_3 = L3_3 or L9_3
    if not L3_3 then
      L9_3 = L3_2
    end
    if L1_3 == L0_3 then
      L10_3 = 0.0
      if L10_3 then
        goto lbl_125
      end
    end
    L10_3 = 0.4
    ::lbl_125::
    L9_3 = L9_3 + L10_3
    L10_3 = false
    L11_3 = false
    L12_3 = false
    L5_3(L6_3, L7_3, L8_3, L9_3, L10_3, L11_3, L12_3)
    L5_3 = SetEntityHeading
    L6_3 = L1_3
    L7_3 = L4_2
    L7_3 = L7_3 + 0.0
    L5_3(L6_3, L7_3)
    L5_3 = FreezeEntityPosition
    L6_3 = L1_3
    L7_3 = false
    L5_3(L6_3, L7_3)
    L5_3 = false
    L5_1 = L5_3
  end
  L5_2(L6_2)
  L5_2 = {}
  L5_2.ok = true
  return L5_2
end
L6_1["admin.tp"] = L7_1
L6_1 = OverlayClientHooks
function L7_1()
  local L0_2, L1_2
  L0_2 = OverlayClose
  L1_2 = "admin"
  L0_2(L1_2)
  L0_2 = {}
  L0_2.ok = true
  return L0_2
end
L6_1["admin.close"] = L7_1
