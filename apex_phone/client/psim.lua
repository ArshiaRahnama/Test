local L0_1, L1_1, L2_1, L3_1, L4_1, L5_1, L6_1, L7_1, L8_1
L0_1 = type
L1_1 = Config
L1_1 = L1_1.PhysicalSim
L0_1 = L0_1(L1_1)
if "table" == L0_1 then
  L0_1 = Config
  L0_1 = L0_1.PhysicalSim
  if L0_1 then
    goto lbl_13
  end
end
L0_1 = nil
::lbl_13::
if not L0_1 then
  return
end
L1_1 = false
function L2_1()
  local L0_2, L1_2
  L0_2 = L1_1
  if L0_2 then
    return
  end
  L0_2 = true
  L1_1 = L0_2
  L0_2 = DeviceOwnerActivate
  if L0_2 then
    L0_2 = DeviceOwnerActivate
    L1_2 = "psim"
    L0_2(L1_2)
  end
end
function L3_1(A0_2)
  local L1_2, L2_2
  L1_2 = type
  L2_2 = A0_2
  L1_2 = L1_2(L2_2)
  if "table" == L1_2 then
    L1_2 = A0_2.on
    if true == L1_2 then
      L1_2 = L2_1
      L1_2()
    end
  end
end
L4_1 = L3_1
L5_1 = GlobalState
L5_1 = L5_1["apex_phone:psim"]
L4_1(L5_1)
L4_1 = AddStateBagChangeHandler
L5_1 = "apex_phone:psim"
L6_1 = "global"
function L7_1(A0_2, A1_2, A2_2)
  local L3_2, L4_2
  L3_2 = L3_1
  L4_2 = A2_2
  L3_2(L4_2)
end
L4_1(L5_1, L6_1, L7_1)
L4_1 = 0
function L5_1(A0_2)
  local L1_2, L2_2, L3_2, L4_2, L5_2, L6_2
  L1_2 = L1_1
  if not L1_2 then
    L1_2 = FW
    L1_2 = L1_2.Notify
    L2_2 = "Os cart\195\181es SIM n\195\163o est\195\163o ativos neste servidor."
    L3_2 = "error"
    L1_2(L2_2, L3_2)
    return
  end
  L1_2 = GetGameTimer
  L1_2 = L1_2()
  L2_2 = L4_1
  L2_2 = L1_2 - L2_2
  L3_2 = 800
  if L2_2 < L3_2 then
    return
  end
  L4_1 = L1_2
  L2_2 = TriggerServerEvent
  L3_2 = "apex_phone:server:psimUse"
  L4_2 = math
  L4_2 = L4_2.tointeger
  L5_2 = tonumber
  L6_2 = A0_2
  L5_2, L6_2 = L5_2(L6_2)
  L4_2, L5_2, L6_2 = L4_2(L5_2, L6_2)
  L2_2(L3_2, L4_2, L5_2, L6_2)
end
L6_1 = exports
L7_1 = "useSimCard"
function L8_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2
  L2_2 = type
  L3_2 = A1_2
  L2_2 = L2_2(L3_2)
  if "table" == L2_2 then
    L2_2 = A1_2.slot
    if L2_2 then
      goto lbl_18
    end
  end
  L2_2 = type
  L3_2 = A0_2
  L2_2 = L2_2(L3_2)
  if "table" == L2_2 then
    L2_2 = A0_2.slot
    if L2_2 then
      goto lbl_18
    end
  end
  L2_2 = nil
  ::lbl_18::
  L3_2 = L5_1
  L4_2 = L2_2
  L3_2(L4_2)
end
L6_1(L7_1, L8_1)
L6_1 = exports
L7_1 = "ejectSim"
function L8_1(A0_2)
  local L1_2, L2_2, L3_2, L4_2, L5_2, L6_2, L7_2
  L1_2 = L1_1
  if not L1_2 then
    L1_2 = FW
    L1_2 = L1_2.Notify
    L2_2 = "Os cart\195\181es SIM n\195\163o est\195\163o ativos neste servidor."
    L3_2 = "error"
    L1_2(L2_2, L3_2)
    return
  end
  L1_2 = GetGameTimer
  L1_2 = L1_2()
  L2_2 = L4_1
  L2_2 = L1_2 - L2_2
  L3_2 = 800
  if L2_2 < L3_2 then
    return
  end
  L4_1 = L1_2
  L2_2 = TriggerServerEvent
  L3_2 = "apex_phone:server:psimEject"
  L4_2 = math
  L4_2 = L4_2.tointeger
  L5_2 = tonumber
  L6_2 = type
  L7_2 = A0_2
  L6_2 = L6_2(L7_2)
  if "table" == L6_2 then
    L6_2 = A0_2.slot
    if L6_2 then
      goto lbl_34
    end
  end
  L6_2 = A0_2
  ::lbl_34::
  L5_2, L6_2, L7_2 = L5_2(L6_2)
  L4_2, L5_2, L6_2, L7_2 = L4_2(L5_2, L6_2, L7_2)
  L2_2(L3_2, L4_2, L5_2, L6_2, L7_2)
end
L6_1(L7_1, L8_1)
L6_1 = exports
L7_1 = "IsPhysicalSimOn"
function L8_1()
  local L0_2, L1_2
  L0_2 = L1_1
  return L0_2
end
L6_1(L7_1, L8_1)
