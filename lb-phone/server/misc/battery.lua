local L0_1, L1_1, L2_1, L3_1, L4_1
L0_1 = {}
L1_1 = RegisterNetEvent
L2_1 = "phone:battery:setBattery"
function L3_1(A0_2)
  local L1_2, L2_2, L3_2
  L1_2 = source
  L2_2 = Config
  L2_2 = L2_2.Battery
  L2_2 = L2_2.Enabled
  if L2_2 then
    L2_2 = type
    L3_2 = A0_2
    L2_2 = L2_2(L3_2)
    if not ("number" ~= L2_2 or A0_2 < 0 or A0_2 > 100) then
      goto lbl_20
    end
  end
  L2_2 = debugprint
  L3_2 = "setBattery: invalid battery"
  do return L2_2(L3_2) end
  ::lbl_20::
  L2_2 = GetEquippedPhoneNumber
  L3_2 = L1_2
  L2_2 = L2_2(L3_2)
  if not L2_2 then
    return
  end
  L3_2 = L0_1
  L3_2[L2_2] = A0_2
end
L1_1(L2_1, L3_1)
function L1_1(A0_2)
  local L1_2
  L1_2 = Config
  L1_2 = L1_2.Battery
  L1_2 = L1_2.Enabled
  if not L1_2 then
    L1_2 = false
    return L1_2
  end
  L1_2 = L0_1
  L1_2 = L1_2[A0_2]
  L1_2 = 0 == L1_2
  return L1_2
end
IsPhoneDead = L1_1
L1_1 = exports
L2_1 = "IsPhoneDead"
L3_1 = IsPhoneDead
L1_1(L2_1, L3_1)
function L1_1(A0_2)
  local L1_2, L2_2, L3_2, L4_2, L5_2, L6_2
  L1_2 = GetEquippedPhoneNumber
  L2_2 = A0_2
  L1_2 = L1_2(L2_2)
  if L1_2 then
    L2_2 = L0_1
    L2_2 = L2_2[L1_2]
    if L2_2 then
      goto lbl_11
    end
  end
  do return end
  ::lbl_11::
  L2_2 = debugprint
  L3_2 = "saving battery level (%s) for %s"
  L4_2 = L3_2
  L3_2 = L3_2.format
  L5_2 = L0_1
  L5_2 = L5_2[L1_2]
  L6_2 = L1_2
  L3_2, L4_2, L5_2, L6_2 = L3_2(L4_2, L5_2, L6_2)
  L2_2(L3_2, L4_2, L5_2, L6_2)
  L2_2 = MySQL
  L2_2 = L2_2.update
  L3_2 = "UPDATE phone_phones SET battery = ? WHERE phone_number = ?"
  L4_2 = {}
  L5_2 = L0_1
  L5_2 = L5_2[L1_2]
  L6_2 = L1_2
  L4_2[1] = L5_2
  L4_2[2] = L6_2
  function L5_2()
    local L0_3, L1_3
    L1_3 = L1_2
    L0_3 = L0_1
    L0_3[L1_3] = nil
  end
  L2_2(L3_2, L4_2, L5_2)
end
SaveBattery = L1_1
L1_1 = exports
L2_1 = "SaveBattery"
L3_1 = SaveBattery
L1_1(L2_1, L3_1)
function L1_1()
  local L0_2, L1_2, L2_2, L3_2, L4_2, L5_2, L6_2
  L0_2 = debugprint
  L1_2 = "saving all battery levels"
  L0_2(L1_2)
  L0_2 = GetPlayers
  L0_2 = L0_2()
  L1_2 = 1
  L2_2 = #L0_2
  L3_2 = 1
  for L4_2 = L1_2, L2_2, L3_2 do
    L5_2 = SaveBattery
    L6_2 = L0_2[L4_2]
    L5_2(L6_2)
  end
end
L2_1 = exports
L3_1 = "SaveAllBatteries"
L4_1 = L1_1
L2_1(L3_1, L4_1)
L2_1 = AddEventHandler
L3_1 = "playerDropped"
function L4_1()
  local L0_2, L1_2
  L0_2 = SaveBattery
  L1_2 = source
  L0_2(L1_2)
end
L2_1(L3_1, L4_1)
L2_1 = AddEventHandler
L3_1 = "txAdmin:events:scheduledRestart"
function L4_1(A0_2)
  local L1_2
  L1_2 = A0_2.secondsRemaining
  if 60 == L1_2 then
    L1_2 = L1_1
    L1_2()
  end
end
L2_1(L3_1, L4_1)
L2_1 = AddEventHandler
L3_1 = "txAdmin:events:serverShuttingDown"
L4_1 = L1_1
L2_1(L3_1, L4_1)
L2_1 = AddEventHandler
L3_1 = "onResourceStop"
function L4_1(A0_2)
  local L1_2
  L1_2 = GetCurrentResourceName
  L1_2 = L1_2()
  if A0_2 == L1_2 then
    L1_2 = L1_1
    L1_2()
  end
end
L2_1(L3_1, L4_1)
