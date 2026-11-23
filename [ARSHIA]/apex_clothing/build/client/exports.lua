local L0_1, L1_1, L2_1
L0_1 = RegisterNetEvent
L1_1 = "apex_clothing:open"
function L2_1()
  local L0_2, L1_2
  L0_2 = ApexMain
  if L0_2 then
    L0_2 = ApexMain
    L0_2 = L0_2.Open
    if L0_2 then
      L0_2 = ApexMain
      L0_2 = L0_2.Open
      L0_2()
    end
  end
end
L0_1(L1_1, L2_1)
L0_1 = exports
L1_1 = "Open"
function L2_1()
  local L0_2, L1_2
  L0_2 = ApexMain
  if L0_2 then
    L0_2 = ApexMain
    L0_2 = L0_2.Open
    if L0_2 then
      L0_2 = ApexMain
      L0_2 = L0_2.Open
      L0_2()
    end
  end
end
L0_1(L1_1, L2_1)
L0_1 = exports
L1_1 = "Close"
function L2_1()
  local L0_2, L1_2
  L0_2 = ApexMain
  if L0_2 then
    L0_2 = ApexMain
    L0_2 = L0_2.Close
    if L0_2 then
      L0_2 = ApexMain
      L0_2 = L0_2.Close
      L0_2()
    end
  end
end
L0_1(L1_1, L2_1)
L0_1 = exports
L1_1 = "IsOpen"
function L2_1()
  local L0_2, L1_2
  L0_2 = ApexMain
  if L0_2 then
    L0_2 = ApexMain
    L0_2 = L0_2.IsOpen
    if L0_2 then
      L0_2 = ApexMain
      L0_2 = L0_2.IsOpen
      L0_2 = L0_2()
      if L0_2 then
        goto lbl_14
      end
    end
  end
  L0_2 = false
  ::lbl_14::
  return L0_2
end
L0_1(L1_1, L2_1)
