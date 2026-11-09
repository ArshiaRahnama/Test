local L0_1, L1_1, L2_1, L3_1, L4_1, L5_1, L6_1, L7_1
L0_1 = "apex_phone:capps"
L1_1 = nil
function L2_1(A0_2)
  local L1_2, L2_2, L3_2
  if not A0_2 then
    L1_2 = GlobalState
    L2_2 = L0_1
    A0_2 = L1_2[L2_2]
  end
  L1_2 = type
  L2_2 = A0_2
  L1_2 = L1_2(L2_2)
  if "table" ~= L1_2 then
    return
  end
  L1_2 = A0_2.rev
  L1_1 = L1_2
  L1_2 = Push
  L2_2 = "capps:defs"
  L3_2 = A0_2
  L1_2(L2_2, L3_2)
end
L3_1 = AddStateBagChangeHandler
L4_1 = L0_1
L5_1 = "global"
function L6_1(A0_2, A1_2, A2_2)
  local L3_2, L4_2
  L3_2 = type
  L4_2 = A2_2
  L3_2 = L3_2(L4_2)
  if "table" == L3_2 then
    L3_2 = A2_2.rev
    L4_2 = L1_1
    if L3_2 ~= L4_2 then
      goto lbl_11
    end
  end
  do return end
  ::lbl_11::
  L3_2 = L2_1
  L4_2 = A2_2
  L3_2(L4_2)
end
L3_1(L4_1, L5_1, L6_1)
L3_1 = RegisterNUICallback
L4_1 = "capps:get"
function L5_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2
  L2_2 = GlobalState
  L3_2 = L0_1
  L2_2 = L2_2[L3_2]
  L3_2 = A1_2
  L4_2 = type
  L5_2 = L2_2
  L4_2 = L4_2(L5_2)
  L4_2 = L2_2 or L4_2
  if "table" ~= L4_2 or not L2_2 then
    L4_2 = false
  end
  L3_2(L4_2)
end
L3_1(L4_1, L5_1)
L3_1 = RegisterNUICallback
L4_1 = "capps:nearby"
function L5_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2
  L2_2 = {}
  L3_2 = PlayerPedId
  L3_2 = L3_2()
  L4_2 = GetEntityCoords
  L5_2 = L3_2
  L4_2 = L4_2(L5_2)
  L5_2 = ipairs
  L6_2 = GetActivePlayers
  L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2 = L6_2()
  L5_2, L6_2, L7_2, L8_2 = L5_2(L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2)
  for L9_2, L10_2 in L5_2, L6_2, L7_2, L8_2 do
    L11_2 = PlayerId
    L11_2 = L11_2()
    if L10_2 ~= L11_2 then
      L11_2 = GetPlayerPed
      L12_2 = L10_2
      L11_2 = L11_2(L12_2)
      if 0 ~= L11_2 then
        L12_2 = DoesEntityExist
        L13_2 = L11_2
        L12_2 = L12_2(L13_2)
        if L12_2 then
          L12_2 = GetEntityCoords
          L13_2 = L11_2
          L12_2 = L12_2(L13_2)
          L12_2 = L12_2 - L4_2
          L12_2 = #L12_2
          if L12_2 <= 10.0 then
            L12_2 = #L2_2
            L12_2 = L12_2 + 1
            L13_2 = GetPlayerServerId
            L14_2 = L10_2
            L13_2 = L13_2(L14_2)
            L2_2[L12_2] = L13_2
            L12_2 = #L2_2
            if L12_2 >= 16 then
              break
            end
          end
        end
      end
    end
  end
  L5_2 = A1_2
  L6_2 = {}
  L6_2.ids = L2_2
  L5_2(L6_2)
end
L3_1(L4_1, L5_1)
L3_1 = 0
function L4_1(A0_2)
  local L1_2, L2_2, L3_2, L4_2, L5_2
  L1_2 = GetGameTimer
  L1_2 = L1_2()
  L2_2 = L3_1
  L2_2 = L1_2 - L2_2
  L3_2 = 250
  if L2_2 < L3_2 then
    return
  end
  L3_1 = L1_2
  L2_2 = Push
  L3_2 = "capps:duty"
  L4_2 = {}
  L5_2 = true == A0_2
  L4_2.onduty = L5_2
  L2_2(L3_2, L4_2)
end
L5_1 = RegisterNetEvent
L6_1 = "QBCore:Client:SetDuty"
function L7_1(A0_2)
  local L1_2, L2_2
  L1_2 = L4_1
  L2_2 = A0_2
  L1_2(L2_2)
end
L5_1(L6_1, L7_1)
L5_1 = CreateThread
function L6_1()
  local L0_2, L1_2
  L0_2 = Wait
  L1_2 = 2500
  L0_2(L1_2)
  L0_2 = L2_1
  L0_2()
end
L5_1(L6_1)
