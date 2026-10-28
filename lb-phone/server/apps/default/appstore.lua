local L0_1, L1_1, L2_1
L0_1 = RegisterLegacyCallback
L1_1 = "appstore:buyApp"
function L2_1(A0_2, A1_2, A2_2)
  local L3_2, L4_2, L5_2, L6_2, L7_2
  L3_2 = GetEquippedPhoneNumber
  L4_2 = A0_2
  L3_2 = L3_2(L4_2)
  if not L3_2 then
    L4_2 = A1_2
    L5_2 = false
    return L4_2(L5_2)
  end
  L4_2 = A1_2
  L5_2 = RemoveMoney
  L6_2 = A0_2
  L7_2 = A2_2
  L5_2, L6_2, L7_2 = L5_2(L6_2, L7_2)
  L4_2(L5_2, L6_2, L7_2)
end
L0_1(L1_1, L2_1)
