local L0_1, L1_1, L2_1
L0_1 = RegisterNetEvent
L1_1 = "lb-phone:customApp"
function L2_1(A0_2)
  local L1_2, L2_2, L3_2, L4_2
  L1_2 = source
  L2_2 = Config
  L2_2 = L2_2.CustomApps
  L2_2 = L2_2[A0_2]
  L3_2 = L2_2
  if L3_2 then
    L3_2 = L3_2.onServerUse
  end
  if L3_2 then
    L3_2 = L2_2.onServerUse
    L4_2 = L1_2
    L3_2(L4_2)
  end
end
L0_1(L1_1, L2_1)
