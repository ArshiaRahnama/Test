local L0_1, L1_1, L2_1, L3_1, L4_1, L5_1, L6_1, L7_1, L8_1, L9_1
L0_1 = false
L1_1 = 400
function L2_1()
  local L0_2, L1_2, L2_2, L3_2, L4_2
  L0_2 = PlayerPedId
  L0_2 = L0_2()
  L1_2 = GetEntityCoords
  L2_2 = L0_2
  L1_2 = L1_2(L2_2)
  L2_2 = {}
  L3_2 = L1_2.x
  L2_2.x = L3_2
  L3_2 = L1_2.y
  L2_2.y = L3_2
  L3_2 = L1_2.z
  L2_2.z = L3_2
  L3_2 = GetEntityHeading
  L4_2 = L0_2
  L3_2 = L3_2(L4_2)
  L2_2.heading = L3_2
  return L2_2
end
L3_1 = 3000
L4_1 = nil
L5_1 = 0
function L6_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2
  if not A1_2 then
    L2_2 = true
    return L2_2
  end
  L2_2 = A0_2.x
  L3_2 = A1_2.x
  L2_2 = L2_2 - L3_2
  L3_2 = A0_2.y
  L4_2 = A1_2.y
  L3_2 = L3_2 - L4_2
  L4_2 = A0_2.z
  L5_2 = A1_2.z
  L4_2 = L4_2 - L5_2
  L5_2 = L2_2 * L2_2
  L6_2 = L3_2 * L3_2
  L5_2 = L5_2 + L6_2
  L6_2 = L4_2 * L4_2
  L5_2 = L5_2 + L6_2
  L6_2 = 0.0025
  if L5_2 > L6_2 then
    L5_2 = true
    return L5_2
  end
  L5_2 = math
  L5_2 = L5_2.abs
  L6_2 = A0_2.heading
  L7_2 = A1_2.heading
  L6_2 = L6_2 - L7_2
  L5_2 = L5_2(L6_2)
  L5_2 = L5_2 % 360.0
  L6_2 = math
  L6_2 = L6_2.min
  L7_2 = L5_2
  L8_2 = 360.0
  L8_2 = L8_2 - L5_2
  L6_2 = L6_2(L7_2, L8_2)
  L6_2 = L6_2 > 1.0
  return L6_2
end
L7_1 = RegisterNUICallback
L8_1 = "startGPS"
function L9_1(A0_2, A1_2)
  local L2_2, L3_2
  L2_2 = type
  L3_2 = A0_2
  L2_2 = L2_2(L3_2)
  if "table" == L2_2 then
    L2_2 = A0_2.slow
    if true == L2_2 then
      L2_2 = 1500
      if L2_2 then
        goto lbl_13
      end
    end
  end
  L2_2 = 400
  ::lbl_13::
  L1_1 = L2_2
  L2_2 = nil
  L4_1 = L2_2
  L2_2 = L0_1
  if not L2_2 then
    L2_2 = true
    L0_1 = L2_2
    L2_2 = CreateThread
    function L3_2()
      local L0_3, L1_3, L2_3, L3_3, L4_3
      while true do
        L0_3 = L0_1
        if not L0_3 then
          break
        end
        L0_3 = PhoneOpen
        if not L0_3 then
          break
        end
        L0_3 = L2_1
        L0_3 = L0_3()
        L1_3 = GetGameTimer
        L1_3 = L1_3()
        L2_3 = L6_1
        L3_3 = L0_3
        L4_3 = L4_1
        L2_3 = L2_3(L3_3, L4_3)
        if not L2_3 then
          L2_3 = L5_1
          L2_3 = L1_3 - L2_3
          L3_3 = L3_1
          if not (L2_3 >= L3_3) then
            goto lbl_30
          end
        end
        L2_3 = L0_3
        L5_1 = L1_3
        L4_1 = L2_3
        L2_3 = Push
        L3_3 = "coords"
        L4_3 = L0_3
        L2_3(L3_3, L4_3)
        ::lbl_30::
        L2_3 = Wait
        L3_3 = L1_1
        L2_3(L3_3)
      end
      L0_3 = false
      L0_1 = L0_3
    end
    L2_2(L3_2)
  end
  L2_2 = A1_2
  L3_2 = "ok"
  L2_2(L3_2)
end
L7_1(L8_1, L9_1)
L7_1 = RegisterNUICallback
L8_1 = "stopGPS"
function L9_1(A0_2, A1_2)
  local L2_2, L3_2
  L2_2 = false
  L0_1 = L2_2
  L2_2 = A1_2
  L3_2 = "ok"
  L2_2(L3_2)
end
L7_1(L8_1, L9_1)
L7_1 = RegisterNUICallback
L8_1 = "getCoords"
function L9_1(A0_2, A1_2)
  local L2_2, L3_2
  L2_2 = A1_2
  L3_2 = L2_1
  L3_2 = L3_2()
  L2_2(L3_2)
end
L7_1(L8_1, L9_1)
L7_1 = RegisterNUICallback
L8_1 = "setWaypoint"
function L9_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2
  L2_2 = tonumber
  L3_2 = A0_2.x
  L2_2 = L2_2(L3_2)
  L3_2 = tonumber
  L4_2 = A0_2.y
  L3_2 = L3_2(L4_2)
  if L2_2 and L3_2 then
    L4_2 = SetNewWaypoint
    L5_2 = L2_2 + 0.0
    L6_2 = L3_2 + 0.0
    L4_2(L5_2, L6_2)
    L4_2 = FW
    L4_2 = L4_2.Notify
    L5_2 = A0_2.name
    if L5_2 then
      L5_2 = "Waypoint marcado: %s"
      L6_2 = L5_2
      L5_2 = L5_2.format
      L7_2 = tostring
      L8_2 = A0_2.name
      L7_2, L8_2 = L7_2(L8_2)
      L5_2 = L5_2(L6_2, L7_2, L8_2)
      if L5_2 then
        goto lbl_31
      end
    end
    L5_2 = "Waypoint marcado"
    ::lbl_31::
    L6_2 = "success"
    L4_2(L5_2, L6_2)
  end
  L4_2 = A1_2
  L5_2 = "ok"
  L4_2(L5_2)
end
L7_1(L8_1, L9_1)
L7_1 = RegisterNUICallback
L8_1 = "removeWaypoint"
function L9_1(A0_2, A1_2)
  local L2_2, L3_2
  L2_2 = DeleteWaypoint
  L2_2()
  L2_2 = A1_2
  L3_2 = "ok"
  L2_2(L3_2)
end
L7_1(L8_1, L9_1)
L7_1 = AddEventHandler
L8_1 = "apex_phone:client:closed"
function L9_1()
  local L0_2, L1_2
  L0_2 = false
  L0_1 = L0_2
end
L7_1(L8_1, L9_1)
