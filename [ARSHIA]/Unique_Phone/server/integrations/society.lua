local L0_1, L1_1, L2_1, L3_1, L4_1, L5_1, L6_1, L7_1, L8_1, L9_1, L10_1, L11_1, L12_1, L13_1, L14_1, L15_1, L16_1, L17_1, L18_1, L19_1, L20_1, L21_1, L22_1
L0_1 = PhoneIntegrations
L1_1 = L0_1.fwSociety
if not L1_1 then
  L1_1 = {}
  L2_1 = FW
  L2_1 = L2_1.GetSocietyMoney
  L1_1.get = L2_1
  L2_1 = FW
  L2_1 = L2_1.AddSocietyMoney
  L1_1.add = L2_1
end
L0_1.fwSociety = L1_1
L1_1 = L0_1.fwSociety
L2_1 = {}
L2_1.noaccount = true
L2_1.unavailable = true
function L3_1(A0_2, A1_2, ...)
  local L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2
  L2_2 = L0_1.started
  L3_2 = A0_2
  L2_2 = L2_2(L3_2)
  if not L2_2 then
    L2_2 = error
    L3_2 = "%s is not started"
    L4_2 = L3_2
    L3_2 = L3_2.format
    L5_2 = A0_2
    L3_2 = L3_2(L4_2, L5_2)
    L4_2 = 0
    L2_2(L3_2, L4_2)
  end
  L2_2 = pcall
  function L3_2()
    local L0_3, L1_3
    L0_3 = exports
    L1_3 = A0_2
    L0_3 = L0_3[L1_3]
    L1_3 = A1_2
    L0_3 = L0_3[L1_3]
    return L0_3
  end
  L2_2, L3_2 = L2_2(L3_2)
  if not L2_2 or nil == L3_2 then
    L4_2 = error
    L5_2 = "%s has no export %s"
    L6_2 = L5_2
    L5_2 = L5_2.format
    L7_2 = A0_2
    L8_2 = A1_2
    L5_2 = L5_2(L6_2, L7_2, L8_2)
    L6_2 = 0
    L4_2(L5_2, L6_2)
  end
  L4_2 = table
  L4_2 = L4_2.pack
  L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2 = ...
  L4_2 = L4_2(L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2)
  L5_2 = table
  L5_2 = L5_2.pack
  L6_2 = pcall
  function L7_2()
    local L0_3, L1_3, L2_3, L3_3, L4_3, L5_3
    L0_3 = L3_2
    L1_3 = exports
    L2_3 = A0_2
    L1_3 = L1_3[L2_3]
    L2_3 = table
    L2_3 = L2_3.unpack
    L3_3 = L4_2
    L4_3 = 1
    L5_3 = L4_2.n
    L2_3, L3_3, L4_3, L5_3 = L2_3(L3_3, L4_3, L5_3)
    return L0_3(L1_3, L2_3, L3_3, L4_3, L5_3)
  end
  L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2 = L6_2(L7_2)
  L5_2 = L5_2(L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2)
  L6_2 = L5_2[1]
  if not L6_2 then
    L6_2 = L0_1.warnOnce
    L7_2 = "soc_ex_"
    L8_2 = A0_2
    L9_2 = A1_2
    L7_2 = L7_2 .. L8_2 .. L9_2
    L8_2 = "society: %s:%s raised (%s)"
    L9_2 = L8_2
    L8_2 = L8_2.format
    L10_2 = A0_2
    L11_2 = A1_2
    L12_2 = tostring
    L13_2 = L5_2[2]
    L12_2, L13_2 = L12_2(L13_2)
    L8_2, L9_2, L10_2, L11_2, L12_2, L13_2 = L8_2(L9_2, L10_2, L11_2, L12_2, L13_2)
    L6_2(L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2)
    L6_2 = false
    L7_2 = "error"
    return L6_2, L7_2
  end
  L6_2 = true
  L7_2 = table
  L7_2 = L7_2.unpack
  L8_2 = L5_2
  L9_2 = 2
  L10_2 = L5_2.n
  L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2 = L7_2(L8_2, L9_2, L10_2)
  return L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2
end
function L4_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2
  L2_2 = L0_1.started
  L3_2 = A0_2
  L2_2 = L2_2(L3_2)
  if not L2_2 then
    L2_2 = false
    return L2_2
  end
  L2_2 = pcall
  function L3_2()
    local L0_3, L1_3
    L0_3 = exports
    L1_3 = A0_2
    L0_3 = L0_3[L1_3]
    L1_3 = A1_2
    L0_3 = L0_3[L1_3]
    return L0_3
  end
  L2_2, L3_2 = L2_2(L3_2)
  L4_2 = L2_2 or L4_2
  L4_2 = L2_2 and nil ~= L3_2
  return L4_2
end
function L5_1(A0_2)
  local L1_2, L2_2, L3_2, L4_2, L5_2
  L1_2 = GetResourceMetadata
  L2_2 = A0_2
  L3_2 = "version"
  L4_2 = 0
  L1_2 = L1_2(L2_2, L3_2, L4_2)
  L2_2 = type
  L3_2 = L1_2
  L2_2 = L2_2(L3_2)
  if "string" == L2_2 then
    L2_2 = tonumber
    L4_2 = L1_2
    L3_2 = L1_2.match
    L5_2 = "^%s*v?(%d+)"
    L3_2, L4_2, L5_2 = L3_2(L4_2, L5_2)
    L2_2 = L2_2(L3_2, L4_2, L5_2)
    if L2_2 then
      goto lbl_19
    end
  end
  L2_2 = nil
  ::lbl_19::
  return L2_2
end
function L6_1(A0_2)
  local L1_2, L2_2
  L1_2 = L0_1.num
  L2_2 = A0_2
  L1_2 = L1_2(L2_2)
  A0_2 = L1_2
  if A0_2 then
    L1_2 = math
    L1_2 = L1_2.floor
    L2_2 = A0_2
    L1_2 = L1_2(L2_2)
    if L1_2 then
      goto lbl_14
    end
  end
  L1_2 = nil
  ::lbl_14::
  return L1_2
end
L7_1 = L0_1.defineBuiltin
L8_1 = "society"
L9_1 = {}
L9_1.label = "Config.SocietyProvider (qb-banking / qb-management / Renewed-Banking / esx_addonaccount)"
function L10_1(A0_2)
  local L1_2, L2_2, L3_2
  L1_2 = L1_1.get
  if not L1_2 then
    L1_2 = 0
    return L1_2
  end
  L1_2 = L6_1
  L2_2 = L1_1.get
  L3_2 = A0_2
  L2_2, L3_2 = L2_2(L3_2)
  L1_2 = L1_2(L2_2, L3_2)
  if not L1_2 then
    L1_2 = 0
  end
  return L1_2
end
L9_1.balance = L10_1
function L10_1(A0_2, A1_2, A2_2)
  local L3_2, L4_2, L5_2, L6_2
  L3_2 = L1_1.add
  if not L3_2 then
    L3_2 = false
    L4_2 = "unavailable"
    return L3_2, L4_2
  end
  L3_2 = L1_1.add
  L4_2 = A0_2
  L5_2 = A1_2
  L6_2 = A2_2
  L3_2 = L3_2(L4_2, L5_2, L6_2)
  L3_2 = true == L3_2
  return L3_2
end
L9_1.add = L10_1
function L10_1(A0_2, A1_2, A2_2)
  local L3_2, L4_2, L5_2, L6_2
  L3_2 = L1_1.add
  if L3_2 then
    L3_2 = L1_1.get
    if L3_2 then
      goto lbl_10
    end
  end
  L3_2 = false
  L4_2 = "unavailable"
  do return L3_2, L4_2 end
  ::lbl_10::
  L3_2 = L6_1
  L4_2 = L1_1.get
  L5_2 = A0_2
  L4_2, L5_2, L6_2 = L4_2(L5_2)
  L3_2 = L3_2(L4_2, L5_2, L6_2)
  if not L3_2 then
    L3_2 = 0
  end
  if A1_2 > L3_2 then
    L3_2 = false
    L4_2 = "funds"
    return L3_2, L4_2
  end
  L3_2 = L1_1.add
  L4_2 = A0_2
  L5_2 = -A1_2
  L6_2 = A2_2
  L3_2 = L3_2(L4_2, L5_2, L6_2)
  L3_2 = true == L3_2
  return L3_2
end
L9_1.remove = L10_1
L7_1(L8_1, L9_1)
function L7_1(A0_2, A1_2, A2_2, A3_2)
  local L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2
  L4_2 = pcall
  L5_2 = L3_1
  L6_2 = "apex_bossmenu"
  L7_2 = "Log"
  L8_2 = "treasury"
  L9_2 = {}
  L9_2.job = A0_2
  L9_2.action = A1_2
  L9_2.actor = "Phone"
  L9_2.amount = A2_2
  L10_2 = {}
  L11_2 = tostring
  L12_2 = A3_2 or L12_2
  if not A3_2 then
    L12_2 = "Unique_Phone"
  end
  L11_2 = L11_2(L12_2)
  L10_2.reason = L11_2
  L10_2.via = "Unique_Phone"
  L9_2.details = L10_2
  L4_2(L5_2, L6_2, L7_2, L8_2, L9_2)
end
L8_1 = L0_1.define
L9_1 = "society"
L10_1 = "apex_bossmenu"
L11_1 = {}
L11_1.label = "apex_bossmenu (treasury)"
L12_1 = {}
L13_1 = "apex_bossmenu"
L12_1[1] = L13_1
L11_1.resources = L12_1
function L12_1(A0_2)
  local L1_2, L2_2, L3_2, L4_2
  L1_2 = L3_1
  L2_2 = "apex_bossmenu"
  L3_2 = "GetTreasury"
  L4_2 = A0_2
  L1_2, L2_2 = L1_2(L2_2, L3_2, L4_2)
  if L1_2 then
    L3_2 = L6_1
    L4_2 = L2_2
    L3_2 = L3_2(L4_2)
    if L3_2 then
      goto lbl_14
    end
  end
  L3_2 = nil
  ::lbl_14::
  return L3_2
end
L11_1.balance = L12_1
function L12_1(A0_2, A1_2, A2_2)
  local L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2
  L3_2 = L3_1
  L4_2 = "apex_bossmenu"
  L5_2 = "AddTreasury"
  L6_2 = A0_2
  L7_2 = A1_2
  L3_2, L4_2 = L3_2(L4_2, L5_2, L6_2, L7_2)
  if not L3_2 then
    L5_2 = false
    L6_2 = "error"
    return L5_2, L6_2
  end
  if false == L4_2 or nil == L4_2 then
    L5_2 = false
    L6_2 = "failed"
    return L5_2, L6_2
  end
  L5_2 = L7_1
  L6_2 = A0_2
  L7_2 = "deposit"
  L8_2 = A1_2
  L9_2 = A2_2
  L5_2(L6_2, L7_2, L8_2, L9_2)
  L5_2 = true
  return L5_2
end
L11_1.add = L12_1
function L12_1(A0_2, A1_2, A2_2)
  local L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2
  L3_2 = L3_1
  L4_2 = "apex_bossmenu"
  L5_2 = "RemoveTreasury"
  L6_2 = A0_2
  L7_2 = A1_2
  L3_2, L4_2 = L3_2(L4_2, L5_2, L6_2, L7_2)
  if not L3_2 then
    L5_2 = false
    L6_2 = "error"
    return L5_2, L6_2
  end
  if false == L4_2 or nil == L4_2 then
    L5_2 = false
    L6_2 = "funds"
    return L5_2, L6_2
  end
  L5_2 = L7_1
  L6_2 = A0_2
  L7_2 = "withdraw"
  L8_2 = A1_2
  L9_2 = A2_2
  L5_2(L6_2, L7_2, L8_2, L9_2)
  L5_2 = true
  return L5_2
end
L11_1.remove = L12_1
L8_1(L9_1, L10_1, L11_1)
function L8_1(A0_2, A1_2, A2_2, A3_2)
  local L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2
  L4_2 = pcall
  L5_2 = L3_1
  L6_2 = "Renewed-Banking"
  L7_2 = "handleTransaction"
  L8_2 = A0_2
  L9_2 = "Phone"
  L10_2 = A1_2 + 0.0
  L11_2 = tostring
  L12_2 = A2_2 or L12_2
  if not A2_2 then
    L12_2 = "Unique_Phone"
  end
  L11_2 = L11_2(L12_2)
  if "deposit" == A3_2 then
    L12_2 = "Phone"
    if L12_2 then
      goto lbl_20
    end
  end
  L12_2 = A0_2
  ::lbl_20::
  L13_2 = A0_2 or L13_2
  if "deposit" ~= A3_2 or not A0_2 then
    L13_2 = "Phone"
  end
  L14_2 = A3_2
  L4_2(L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2)
end
L9_1 = L0_1.define
L10_1 = "society"
L11_1 = "Renewed-Banking"
L12_1 = {}
L12_1.label = "Renewed-Banking (job accounts)"
L13_1 = {}
L14_1 = "Renewed-Banking"
L13_1[1] = L14_1
L12_1.resources = L13_1
function L13_1(A0_2)
  local L1_2, L2_2, L3_2, L4_2
  L1_2 = L3_1
  L2_2 = "Renewed-Banking"
  L3_2 = "getAccountMoney"
  L4_2 = A0_2
  L1_2, L2_2 = L1_2(L2_2, L3_2, L4_2)
  if not L1_2 or false == L2_2 then
    L3_2 = nil
    return L3_2
  end
  L3_2 = L6_1
  L4_2 = L2_2
  return L3_2(L4_2)
end
L12_1.balance = L13_1
function L13_1(A0_2, A1_2, A2_2)
  local L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2
  L3_2 = L3_1
  L4_2 = "Renewed-Banking"
  L5_2 = "getAccountMoney"
  L6_2 = A0_2
  L3_2, L4_2 = L3_2(L4_2, L5_2, L6_2)
  if L3_2 and false == L4_2 then
    L5_2 = false
    L6_2 = "noaccount"
    return L5_2, L6_2
  end
  L5_2 = L3_1
  L6_2 = "Renewed-Banking"
  L7_2 = "addAccountMoney"
  L8_2 = A0_2
  L9_2 = A1_2
  L5_2, L6_2 = L5_2(L6_2, L7_2, L8_2, L9_2)
  if not L5_2 then
    L7_2 = false
    L8_2 = "error"
    return L7_2, L8_2
  end
  if true ~= L6_2 then
    L7_2 = false
    L8_2 = "failed"
    return L7_2, L8_2
  end
  L7_2 = L8_1
  L8_2 = A0_2
  L9_2 = A1_2
  L10_2 = A2_2
  L11_2 = "deposit"
  L7_2(L8_2, L9_2, L10_2, L11_2)
  L7_2 = true
  return L7_2
end
L12_1.add = L13_1
function L13_1(A0_2, A1_2, A2_2)
  local L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2
  L3_2 = L3_1
  L4_2 = "Renewed-Banking"
  L5_2 = "getAccountMoney"
  L6_2 = A0_2
  L3_2, L4_2 = L3_2(L4_2, L5_2, L6_2)
  if L3_2 and false == L4_2 then
    L5_2 = false
    L6_2 = "noaccount"
    return L5_2, L6_2
  end
  if L3_2 then
    L5_2 = L6_1
    L6_2 = L4_2
    L5_2 = L5_2(L6_2)
    if not L5_2 then
      L5_2 = 0
    end
    if A1_2 > L5_2 then
      L5_2 = false
      L6_2 = "funds"
      return L5_2, L6_2
    end
  end
  L5_2 = L3_1
  L6_2 = "Renewed-Banking"
  L7_2 = "removeAccountMoney"
  L8_2 = A0_2
  L9_2 = A1_2
  L5_2, L6_2 = L5_2(L6_2, L7_2, L8_2, L9_2)
  if not L5_2 then
    L7_2 = false
    L8_2 = "error"
    return L7_2, L8_2
  end
  if true ~= L6_2 then
    L7_2 = false
    L8_2 = "funds"
    return L7_2, L8_2
  end
  L7_2 = L8_1
  L8_2 = A0_2
  L9_2 = A1_2
  L10_2 = A2_2
  L11_2 = "withdraw"
  L7_2(L8_2, L9_2, L10_2, L11_2)
  L7_2 = true
  return L7_2
end
L12_1.remove = L13_1
L9_1(L10_1, L11_1, L12_1)
function L9_1(A0_2)
  local L1_2, L2_2, L3_2, L4_2
  L1_2 = L3_1
  L2_2 = "qb-banking"
  L3_2 = "GetAccount"
  L4_2 = A0_2
  L1_2, L2_2 = L1_2(L2_2, L3_2, L4_2)
  if not L1_2 then
    L3_2 = nil
    L4_2 = "error"
    return L3_2, L4_2
  end
  L3_2 = type
  L4_2 = L2_2
  L3_2 = L3_2(L4_2)
  if "table" ~= L3_2 then
    L3_2 = nil
    L4_2 = "noaccount"
    return L3_2, L4_2
  end
  return L2_2
end
L10_1 = L0_1.define
L11_1 = "society"
L12_1 = "qb-banking"
L13_1 = {}
L13_1.label = "qb-banking 2.x (job accounts)"
function L14_1()
  local L0_2, L1_2
  L0_2 = L0_1.started
  L1_2 = "qb-banking"
  L0_2 = L0_2(L1_2)
  if L0_2 then
    L0_2 = L5_1
    L1_2 = "qb-banking"
    L0_2 = L0_2(L1_2)
    if not L0_2 then
      L0_2 = 0
    end
    L0_2 = L0_2 >= 2
  end
  return L0_2
end
L13_1.detect = L14_1
function L14_1(A0_2)
  local L1_2, L2_2, L3_2
  L1_2 = L9_1
  L2_2 = A0_2
  L1_2 = L1_2(L2_2)
  if L1_2 then
    L2_2 = L6_1
    L3_2 = L1_2.account_balance
    L2_2 = L2_2(L3_2)
    if L2_2 then
      goto lbl_12
    end
  end
  L2_2 = nil
  ::lbl_12::
  return L2_2
end
L13_1.balance = L14_1
function L14_1(A0_2, A1_2, A2_2)
  local L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2
  L3_2 = L9_1
  L4_2 = A0_2
  L3_2, L4_2 = L3_2(L4_2)
  if not L3_2 then
    L5_2 = false
    L6_2 = L4_2
    return L5_2, L6_2
  end
  L5_2 = L3_1
  L6_2 = "qb-banking"
  L7_2 = "AddMoney"
  L8_2 = A0_2
  L9_2 = A1_2
  L10_2 = tostring
  L11_2 = A2_2 or L11_2
  if not A2_2 then
    L11_2 = "Unique_Phone"
  end
  L10_2 = L10_2(L11_2)
  L11_2 = L10_2
  L10_2 = L10_2.sub
  L12_2 = 1
  L13_2 = 50
  L10_2, L11_2, L12_2, L13_2 = L10_2(L11_2, L12_2, L13_2)
  L5_2, L6_2 = L5_2(L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2)
  if not L5_2 then
    L7_2 = false
    L8_2 = "error"
    return L7_2, L8_2
  end
  if false == L6_2 or nil == L6_2 then
    L7_2 = false
    L8_2 = "failed"
    return L7_2, L8_2
  end
  L7_2 = true
  return L7_2
end
L13_1.add = L14_1
function L14_1(A0_2, A1_2, A2_2)
  local L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2
  L3_2 = L9_1
  L4_2 = A0_2
  L3_2, L4_2 = L3_2(L4_2)
  if not L3_2 then
    L5_2 = false
    L6_2 = L4_2
    return L5_2, L6_2
  end
  L5_2 = L6_1
  L6_2 = L3_2.account_balance
  L5_2 = L5_2(L6_2)
  if not L5_2 then
    L5_2 = 0
  end
  if A1_2 > L5_2 then
    L5_2 = false
    L6_2 = "funds"
    return L5_2, L6_2
  end
  L5_2 = L3_1
  L6_2 = "qb-banking"
  L7_2 = "RemoveMoney"
  L8_2 = A0_2
  L9_2 = A1_2
  L10_2 = tostring
  L11_2 = A2_2 or L11_2
  if not A2_2 then
    L11_2 = "Unique_Phone"
  end
  L10_2 = L10_2(L11_2)
  L11_2 = L10_2
  L10_2 = L10_2.sub
  L12_2 = 1
  L13_2 = 50
  L10_2, L11_2, L12_2, L13_2 = L10_2(L11_2, L12_2, L13_2)
  L5_2, L6_2 = L5_2(L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2)
  if not L5_2 then
    L7_2 = false
    L8_2 = "error"
    return L7_2, L8_2
  end
  if false == L6_2 or nil == L6_2 then
    L7_2 = false
    L8_2 = "failed"
    return L7_2, L8_2
  end
  L7_2 = true
  return L7_2
end
L13_1.remove = L14_1
L10_1(L11_1, L12_1, L13_1)
L10_1 = L0_1.define
L11_1 = "society"
L12_1 = "qb-management"
L13_1 = {}
L13_1.label = "qb-management (management_funds)"
function L14_1()
  local L0_2, L1_2, L2_2
  L0_2 = L4_1
  L1_2 = "qb-management"
  L2_2 = "GetAccount"
  L0_2 = L0_2(L1_2, L2_2)
  if L0_2 then
    L0_2 = L4_1
    L1_2 = "qb-management"
    L2_2 = "AddMoney"
    L0_2 = L0_2(L1_2, L2_2)
  end
  return L0_2
end
L13_1.detect = L14_1
function L14_1(A0_2)
  local L1_2, L2_2, L3_2, L4_2
  L1_2 = L3_1
  L2_2 = "qb-management"
  L3_2 = "GetAccount"
  L4_2 = A0_2
  L1_2, L2_2 = L1_2(L2_2, L3_2, L4_2)
  if L1_2 then
    L3_2 = L6_1
    L4_2 = L2_2
    L3_2 = L3_2(L4_2)
    if L3_2 then
      goto lbl_14
    end
  end
  L3_2 = nil
  ::lbl_14::
  return L3_2
end
L13_1.balance = L14_1
function L14_1(A0_2, A1_2, A2_2)
  local L3_2, L4_2, L5_2, L6_2, L7_2
  L3_2 = L3_1
  L4_2 = "qb-management"
  L5_2 = "AddMoney"
  L6_2 = A0_2
  L7_2 = A1_2
  L3_2, L4_2 = L3_2(L4_2, L5_2, L6_2, L7_2)
  if not L3_2 then
    L5_2 = false
    L6_2 = "error"
    return L5_2, L6_2
  end
  L5_2 = false ~= L4_2
  return L5_2
end
L13_1.add = L14_1
function L14_1(A0_2, A1_2, A2_2)
  local L3_2, L4_2, L5_2, L6_2, L7_2
  L3_2 = L3_1
  L4_2 = "qb-management"
  L5_2 = "RemoveMoney"
  L6_2 = A0_2
  L7_2 = A1_2
  L3_2, L4_2 = L3_2(L4_2, L5_2, L6_2, L7_2)
  if not L3_2 then
    L5_2 = false
    L6_2 = "error"
    return L5_2, L6_2
  end
  if true ~= L4_2 then
    L5_2 = false
    L6_2 = "funds"
    return L5_2, L6_2
  end
  L5_2 = true
  return L5_2
end
L13_1.remove = L14_1
L10_1(L11_1, L12_1, L13_1)
function L10_1(A0_2)
  local L1_2, L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2
  L1_2 = MySQL
  L1_2 = L1_2.query
  L1_2 = L1_2.await
  L2_2 = "SELECT society, value FROM okokbanking_societies WHERE society = ? OR society = ? LIMIT 2"
  L3_2 = {}
  L4_2 = A0_2
  L5_2 = "society_"
  L6_2 = A0_2
  L5_2 = L5_2 .. L6_2
  L3_2[1] = L4_2
  L3_2[2] = L5_2
  L1_2 = L1_2(L2_2, L3_2)
  L2_2 = type
  L3_2 = L1_2
  L2_2 = L2_2(L3_2)
  if "table" ~= L2_2 then
    L2_2 = nil
    return L2_2
  end
  L2_2 = nil
  L3_2 = ipairs
  L4_2 = L1_2
  L3_2, L4_2, L5_2, L6_2 = L3_2(L4_2)
  for L7_2, L8_2 in L3_2, L4_2, L5_2, L6_2 do
    L9_2 = L8_2.society
    if L9_2 == A0_2 then
      L2_2 = L8_2
      break
    end
    if not L2_2 then
      L2_2 = L8_2
    end
  end
  if L2_2 then
    L3_2 = L2_2.society
    if L3_2 then
      goto lbl_42
    end
  end
  L3_2 = nil
  ::lbl_42::
  return L3_2
end
function L11_1(A0_2)
  local L1_2, L2_2, L3_2, L4_2
  L1_2 = L3_1
  L2_2 = "okokBanking"
  L3_2 = "GetAccount"
  L4_2 = A0_2
  L1_2, L2_2 = L1_2(L2_2, L3_2, L4_2)
  if not L1_2 then
    L3_2 = nil
    return L3_2
  end
  L3_2 = type
  L4_2 = L2_2
  L3_2 = L3_2(L4_2)
  if "table" == L3_2 then
    L3_2 = L2_2.value
    L2_2 = L3_2 or L2_2
    if not L3_2 then
      L3_2 = L2_2.balance
      L2_2 = L3_2 or L2_2
      if not L3_2 then
        L2_2 = L2_2.money
      end
    end
  end
  L3_2 = L6_1
  L4_2 = L2_2
  return L3_2(L4_2)
end
L12_1 = L0_1.define
L13_1 = "society"
L14_1 = "okokBanking"
L15_1 = {}
L15_1.label = "okokBanking (okokbanking_societies)"
L15_1.verified = false
function L16_1()
  local L0_2, L1_2
  L0_2 = L0_1.okokReal
  if L0_2 then
    L0_2 = L0_1.okokReal
    return L0_2()
  end
  L0_2 = L0_1.started
  L1_2 = "okokBanking"
  L0_2 = L0_2(L1_2)
  if L0_2 then
    L0_2 = L0_1.started
    L1_2 = "wasabi_banking"
    L0_2 = L0_2(L1_2)
    L0_2 = L0_1.started
    L1_2 = "lwk_bank"
    L0_2 = L0_2(L1_2)
    L0_2 = not L0_2 and L0_2
  end
  return L0_2
end
L15_1.detect = L16_1
function L16_1(A0_2)
  local L1_2, L2_2, L3_2
  L1_2 = L10_1
  L2_2 = A0_2
  L1_2 = L1_2(L2_2)
  if L1_2 then
    L2_2 = L11_1
    L3_2 = L1_2
    L2_2 = L2_2(L3_2)
    if L2_2 then
      goto lbl_12
    end
  end
  L2_2 = nil
  ::lbl_12::
  return L2_2
end
L15_1.balance = L16_1
function L16_1(A0_2, A1_2, A2_2)
  local L3_2, L4_2, L5_2, L6_2, L7_2, L8_2
  L3_2 = L10_1
  L4_2 = A0_2
  L3_2 = L3_2(L4_2)
  if not L3_2 then
    L4_2 = false
    L5_2 = "noaccount"
    return L4_2, L5_2
  end
  L4_2 = L3_1
  L5_2 = "okokBanking"
  L6_2 = "AddMoney"
  L7_2 = L3_2
  L8_2 = A1_2
  L4_2, L5_2 = L4_2(L5_2, L6_2, L7_2, L8_2)
  if not L4_2 then
    L6_2 = false
    L7_2 = "error"
    return L6_2, L7_2
  end
  L6_2 = false ~= L5_2
  return L6_2
end
L15_1.add = L16_1
function L16_1(A0_2, A1_2, A2_2)
  local L3_2, L4_2, L5_2, L6_2, L7_2, L8_2
  L3_2 = L10_1
  L4_2 = A0_2
  L3_2 = L3_2(L4_2)
  if not L3_2 then
    L4_2 = false
    L5_2 = "noaccount"
    return L4_2, L5_2
  end
  L4_2 = L11_1
  L5_2 = L3_2
  L4_2 = L4_2(L5_2)
  if not L4_2 then
    L4_2 = 0
  end
  if A1_2 > L4_2 then
    L4_2 = false
    L5_2 = "funds"
    return L4_2, L5_2
  end
  L4_2 = L3_1
  L5_2 = "okokBanking"
  L6_2 = "RemoveMoney"
  L7_2 = L3_2
  L8_2 = A1_2
  L4_2, L5_2 = L4_2(L5_2, L6_2, L7_2, L8_2)
  if not L4_2 then
    L6_2 = false
    L7_2 = "error"
    return L6_2, L7_2
  end
  if false == L5_2 then
    L6_2 = false
    L7_2 = "funds"
    return L6_2, L7_2
  end
  L6_2 = true
  return L6_2
end
L15_1.remove = L16_1
L12_1(L13_1, L14_1, L15_1)
function L12_1(A0_2, A1_2, A2_2, A3_2)
  local L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2
  if "deposit" == A3_2 then
    L4_2 = pcall
    L5_2 = L3_1
    L6_2 = "tgg-banking"
    L7_2 = "AddTransaction"
    L8_2 = A0_2
    L9_2 = nil
    L10_2 = "deposit"
    L11_2 = A1_2
    L12_2 = tostring
    L13_2 = A2_2 or L13_2
    if not A2_2 then
      L13_2 = "Unique_Phone"
    end
    L12_2, L13_2 = L12_2(L13_2)
    L4_2(L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2)
  else
    L4_2 = pcall
    L5_2 = L3_1
    L6_2 = "tgg-banking"
    L7_2 = "AddTransaction"
    L8_2 = nil
    L9_2 = A0_2
    L10_2 = "withdraw"
    L11_2 = A1_2
    L12_2 = tostring
    L13_2 = A2_2 or L13_2
    if not A2_2 then
      L13_2 = "Unique_Phone"
    end
    L12_2, L13_2 = L12_2(L13_2)
    L4_2(L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2)
  end
end
L13_1 = L0_1.define
L14_1 = "society"
L15_1 = "tgg-banking"
L16_1 = {}
L16_1.label = "tgg-banking (society accounts)"
L17_1 = {}
L18_1 = "tgg-banking"
L17_1[1] = L18_1
L16_1.resources = L17_1
L16_1.verified = false
function L17_1(A0_2)
  local L1_2, L2_2, L3_2, L4_2
  L1_2 = L3_1
  L2_2 = "tgg-banking"
  L3_2 = "GetSocietyAccountMoney"
  L4_2 = A0_2
  L1_2, L2_2 = L1_2(L2_2, L3_2, L4_2)
  if L1_2 then
    L3_2 = L6_1
    L4_2 = L2_2
    L3_2 = L3_2(L4_2)
    if L3_2 then
      goto lbl_14
    end
  end
  L3_2 = nil
  ::lbl_14::
  return L3_2
end
L16_1.balance = L17_1
function L17_1(A0_2, A1_2, A2_2)
  local L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2
  L3_2 = L3_1
  L4_2 = "tgg-banking"
  L5_2 = "GetSocietyAccountMoney"
  L6_2 = A0_2
  L3_2, L4_2 = L3_2(L4_2, L5_2, L6_2)
  if L3_2 and nil == L4_2 then
    L5_2 = false
    L6_2 = "noaccount"
    return L5_2, L6_2
  end
  L5_2 = L3_1
  L6_2 = "tgg-banking"
  L7_2 = "AddSocietyMoney"
  L8_2 = A0_2
  L9_2 = A1_2
  L5_2, L6_2 = L5_2(L6_2, L7_2, L8_2, L9_2)
  if not L5_2 then
    L7_2 = false
    L8_2 = "error"
    return L7_2, L8_2
  end
  if true ~= L6_2 then
    L7_2 = false
    L8_2 = "failed"
    return L7_2, L8_2
  end
  L7_2 = L12_1
  L8_2 = A0_2
  L9_2 = A1_2
  L10_2 = A2_2
  L11_2 = "deposit"
  L7_2(L8_2, L9_2, L10_2, L11_2)
  L7_2 = true
  return L7_2
end
L16_1.add = L17_1
function L17_1(A0_2, A1_2, A2_2)
  local L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2
  L3_2 = L3_1
  L4_2 = "tgg-banking"
  L5_2 = "GetSocietyAccountMoney"
  L6_2 = A0_2
  L3_2, L4_2 = L3_2(L4_2, L5_2, L6_2)
  if L3_2 and nil == L4_2 then
    L5_2 = false
    L6_2 = "noaccount"
    return L5_2, L6_2
  end
  if L3_2 then
    L5_2 = L6_1
    L6_2 = L4_2
    L5_2 = L5_2(L6_2)
    if not L5_2 then
      L5_2 = 0
    end
    if A1_2 > L5_2 then
      L5_2 = false
      L6_2 = "funds"
      return L5_2, L6_2
    end
  end
  L5_2 = L3_1
  L6_2 = "tgg-banking"
  L7_2 = "RemoveSocietyMoney"
  L8_2 = A0_2
  L9_2 = A1_2
  L5_2, L6_2 = L5_2(L6_2, L7_2, L8_2, L9_2)
  if not L5_2 then
    L7_2 = false
    L8_2 = "error"
    return L7_2, L8_2
  end
  if true ~= L6_2 then
    L7_2 = false
    L8_2 = "funds"
    return L7_2, L8_2
  end
  L7_2 = L12_1
  L8_2 = A0_2
  L9_2 = A1_2
  L10_2 = A2_2
  L11_2 = "withdraw"
  L7_2(L8_2, L9_2, L10_2, L11_2)
  L7_2 = true
  return L7_2
end
L16_1.remove = L17_1
L13_1(L14_1, L15_1, L16_1)
function L13_1(A0_2, A1_2, A2_2, A3_2, A4_2, A5_2)
  local L6_2, L7_2, L8_2, L9_2, L10_2, L11_2
  L6_2 = L0_1.define
  L7_2 = "society"
  L8_2 = A0_2
  L9_2 = {}
  L9_2.label = A1_2
  L10_2 = {}
  L11_2 = A0_2
  L10_2[1] = L11_2
  L9_2.resources = L10_2
  L9_2.verified = false
  function L10_2(A0_3)
    local L1_3, L2_3, L3_3, L4_3
    L1_3 = A2_2
    L2_3 = A0_3
    L1_3, L2_3 = L1_3(L2_3)
    if not L1_3 or nil == L2_3 or false == L2_3 then
      L3_3 = nil
      return L3_3
    end
    L3_3 = type
    L4_3 = L2_3
    L3_3 = L3_3(L4_3)
    if "table" == L3_3 then
      L3_3 = L2_3.balance
      L2_3 = L3_3 or L2_3
      if not L3_3 then
        L3_3 = L2_3.amount
        L2_3 = L3_3 or L2_3
        if not L3_3 then
          L3_3 = L2_3.money
          L2_3 = L3_3 or L2_3
          if not L3_3 then
            L2_3 = L2_3.value
          end
        end
      end
    end
    L3_3 = L6_1
    L4_3 = L2_3
    return L3_3(L4_3)
  end
  L9_2.balance = L10_2
  function L10_2(A0_3, A1_3, A2_3)
    local L3_3, L4_3, L5_3, L6_3, L7_3, L8_3, L9_3, L10_3, L11_3, L12_3
    L3_3 = A2_2
    L4_3 = A0_3
    L3_3, L4_3 = L3_3(L4_3)
    if L3_3 and (nil == L4_3 or false == L4_3) then
      L5_3 = false
      L6_3 = "noaccount"
      return L5_3, L6_3
    end
    L5_3 = A3_2
    L6_3 = A0_3
    L7_3 = A1_3
    L8_3 = tostring
    L9_3 = A2_3 or L9_3
    if not A2_3 then
      L9_3 = "Unique_Phone"
    end
    L8_3, L9_3, L10_3, L11_3, L12_3 = L8_3(L9_3)
    L5_3, L6_3 = L5_3(L6_3, L7_3, L8_3, L9_3, L10_3, L11_3, L12_3)
    if not L5_3 then
      L7_3 = false
      L8_3 = "error"
      return L7_3, L8_3
    end
    if false == L6_3 then
      L7_3 = false
      L8_3 = "failed"
      return L7_3, L8_3
    end
    L7_3 = A5_2
    if L7_3 then
      L7_3 = pcall
      L8_3 = A5_2
      L9_3 = A0_3
      L10_3 = A1_3
      L11_3 = tostring
      L12_3 = A2_3 or L12_3
      if not A2_3 then
        L12_3 = "Unique_Phone"
      end
      L11_3 = L11_3(L12_3)
      L12_3 = "deposit"
      L7_3(L8_3, L9_3, L10_3, L11_3, L12_3)
    end
    L7_3 = true
    return L7_3
  end
  L9_2.add = L10_2
  function L10_2(A0_3, A1_3, A2_3)
    local L3_3, L4_3, L5_3, L6_3, L7_3, L8_3, L9_3, L10_3, L11_3, L12_3
    L3_3 = A2_2
    L4_3 = A0_3
    L3_3, L4_3 = L3_3(L4_3)
    if L3_3 and (nil == L4_3 or false == L4_3) then
      L5_3 = false
      L6_3 = "noaccount"
      return L5_3, L6_3
    end
    L5_3 = type
    L6_3 = L4_3
    L5_3 = L5_3(L6_3)
    if "table" == L5_3 then
      L5_3 = L4_3.balance
      L4_3 = L5_3 or L4_3
      if not L5_3 then
        L5_3 = L4_3.amount
        L4_3 = L5_3 or L4_3
        if not L5_3 then
          L5_3 = L4_3.money
          L4_3 = L5_3 or L4_3
          if not L5_3 then
            L4_3 = L4_3.value
          end
        end
      end
    end
    if L3_3 then
      L5_3 = L6_1
      L6_3 = L4_3
      L5_3 = L5_3(L6_3)
      if not L5_3 then
        L5_3 = 0
      end
      if not (A1_3 > L5_3) then
        goto lbl_41
      end
    end
    L5_3 = false
    L6_3 = "funds"
    do return L5_3, L6_3 end
    ::lbl_41::
    L5_3 = A4_2
    L6_3 = A0_3
    L7_3 = A1_3
    L8_3 = tostring
    L9_3 = A2_3 or L9_3
    if not A2_3 then
      L9_3 = "Unique_Phone"
    end
    L8_3, L9_3, L10_3, L11_3, L12_3 = L8_3(L9_3)
    L5_3, L6_3 = L5_3(L6_3, L7_3, L8_3, L9_3, L10_3, L11_3, L12_3)
    if not L5_3 then
      L7_3 = false
      L8_3 = "error"
      return L7_3, L8_3
    end
    if false == L6_3 then
      L7_3 = false
      L8_3 = "funds"
      return L7_3, L8_3
    end
    L7_3 = A5_2
    if L7_3 then
      L7_3 = pcall
      L8_3 = A5_2
      L9_3 = A0_3
      L10_3 = A1_3
      L11_3 = tostring
      L12_3 = A2_3 or L12_3
      if not A2_3 then
        L12_3 = "Unique_Phone"
      end
      L11_3 = L11_3(L12_3)
      L12_3 = "withdraw"
      L7_3(L8_3, L9_3, L10_3, L11_3, L12_3)
    end
    L7_3 = true
    return L7_3
  end
  L9_2.remove = L10_2
  L6_2(L7_2, L8_2, L9_2)
end
L14_1 = L13_1
L15_1 = "fd_banking"
L16_1 = "fd_banking (society accounts)"
function L17_1(A0_2)
  local L1_2, L2_2, L3_2, L4_2
  L1_2 = L3_1
  L2_2 = "fd_banking"
  L3_2 = "GetAccount"
  L4_2 = A0_2
  return L1_2(L2_2, L3_2, L4_2)
end
function L18_1(A0_2, A1_2, A2_2)
  local L3_2, L4_2, L5_2, L6_2, L7_2, L8_2
  L3_2 = L3_1
  L4_2 = "fd_banking"
  L5_2 = "AddMoney"
  L6_2 = A0_2
  L7_2 = A1_2
  L8_2 = A2_2
  return L3_2(L4_2, L5_2, L6_2, L7_2, L8_2)
end
function L19_1(A0_2, A1_2, A2_2)
  local L3_2, L4_2, L5_2, L6_2, L7_2, L8_2
  L3_2 = L3_1
  L4_2 = "fd_banking"
  L5_2 = "RemoveMoney"
  L6_2 = A0_2
  L7_2 = A1_2
  L8_2 = A2_2
  return L3_2(L4_2, L5_2, L6_2, L7_2, L8_2)
end
L14_1(L15_1, L16_1, L17_1, L18_1, L19_1)
L14_1 = L13_1
L15_1 = "qs-banking"
L16_1 = "qs-banking (society accounts)"
function L17_1(A0_2)
  local L1_2, L2_2, L3_2, L4_2
  L1_2 = L3_1
  L2_2 = "qs-banking"
  L3_2 = "GetSocietyMoney"
  L4_2 = A0_2
  return L1_2(L2_2, L3_2, L4_2)
end
function L18_1(A0_2, A1_2, A2_2)
  local L3_2, L4_2, L5_2, L6_2, L7_2, L8_2
  L3_2 = L3_1
  L4_2 = "qs-banking"
  L5_2 = "AddSocietyMoney"
  L6_2 = A0_2
  L7_2 = A1_2
  L8_2 = A2_2
  return L3_2(L4_2, L5_2, L6_2, L7_2, L8_2)
end
function L19_1(A0_2, A1_2, A2_2)
  local L3_2, L4_2, L5_2, L6_2, L7_2, L8_2
  L3_2 = L3_1
  L4_2 = "qs-banking"
  L5_2 = "RemoveSocietyMoney"
  L6_2 = A0_2
  L7_2 = A1_2
  L8_2 = A2_2
  return L3_2(L4_2, L5_2, L6_2, L7_2, L8_2)
end
L14_1(L15_1, L16_1, L17_1, L18_1, L19_1)
L14_1 = L13_1
L15_1 = "kartik-banking"
L16_1 = "kartik-banking (society accounts)"
function L17_1(A0_2)
  local L1_2, L2_2, L3_2, L4_2
  L1_2 = L3_1
  L2_2 = "kartik-banking"
  L3_2 = "GetAccountMoney"
  L4_2 = A0_2
  return L1_2(L2_2, L3_2, L4_2)
end
function L18_1(A0_2, A1_2, A2_2)
  local L3_2, L4_2, L5_2, L6_2, L7_2, L8_2
  L3_2 = L3_1
  L4_2 = "kartik-banking"
  L5_2 = "AddAccountMoney"
  L6_2 = A0_2
  L7_2 = A1_2
  L8_2 = A2_2
  return L3_2(L4_2, L5_2, L6_2, L7_2, L8_2)
end
function L19_1(A0_2, A1_2, A2_2)
  local L3_2, L4_2, L5_2, L6_2, L7_2, L8_2
  L3_2 = L3_1
  L4_2 = "kartik-banking"
  L5_2 = "RemoveAccountMoney"
  L6_2 = A0_2
  L7_2 = A1_2
  L8_2 = A2_2
  return L3_2(L4_2, L5_2, L6_2, L7_2, L8_2)
end
L14_1(L15_1, L16_1, L17_1, L18_1, L19_1)
L14_1 = L13_1
L15_1 = "wasabi_banking"
L16_1 = "wasabi_banking (society accounts)"
function L17_1(A0_2)
  local L1_2, L2_2, L3_2, L4_2, L5_2
  L1_2 = L3_1
  L2_2 = "wasabi_banking"
  L3_2 = "GetAccountBalance"
  L4_2 = A0_2
  L5_2 = "society"
  return L1_2(L2_2, L3_2, L4_2, L5_2)
end
function L18_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2, L6_2, L7_2
  L2_2 = L3_1
  L3_2 = "wasabi_banking"
  L4_2 = "AddMoney"
  L5_2 = "society"
  L6_2 = A0_2
  L7_2 = A1_2
  return L2_2(L3_2, L4_2, L5_2, L6_2, L7_2)
end
function L19_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2, L6_2, L7_2
  L2_2 = L3_1
  L3_2 = "wasabi_banking"
  L4_2 = "RemoveMoney"
  L5_2 = "society"
  L6_2 = A0_2
  L7_2 = A1_2
  return L2_2(L3_2, L4_2, L5_2, L6_2, L7_2)
end
L14_1(L15_1, L16_1, L17_1, L18_1, L19_1)
L14_1 = L13_1
L15_1 = "tgiann-bank"
L16_1 = "tgiann-bank (job accounts)"
function L17_1(A0_2)
  local L1_2, L2_2, L3_2, L4_2
  L1_2 = L3_1
  L2_2 = "tgiann-bank"
  L3_2 = "GetJobAccountBalance"
  L4_2 = A0_2
  return L1_2(L2_2, L3_2, L4_2)
end
function L18_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2, L6_2
  L2_2 = L3_1
  L3_2 = "tgiann-bank"
  L4_2 = "AddJobMoney"
  L5_2 = A0_2
  L6_2 = A1_2
  return L2_2(L3_2, L4_2, L5_2, L6_2)
end
function L19_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2, L6_2
  L2_2 = L3_1
  L3_2 = "tgiann-bank"
  L4_2 = "RemoveJobMoney"
  L5_2 = A0_2
  L6_2 = A1_2
  return L2_2(L3_2, L4_2, L5_2, L6_2)
end
L14_1(L15_1, L16_1, L17_1, L18_1, L19_1)
L14_1 = L13_1
L15_1 = "crm-banking"
L16_1 = "crm-banking (society accounts)"
function L17_1(A0_2)
  local L1_2, L2_2, L3_2, L4_2
  L1_2 = L3_1
  L2_2 = "crm-banking"
  L3_2 = "getSocietyMoney"
  L4_2 = A0_2
  return L1_2(L2_2, L3_2, L4_2)
end
function L18_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2, L6_2
  L2_2 = L3_1
  L3_2 = "crm-banking"
  L4_2 = "addSocietyMoney"
  L5_2 = A0_2
  L6_2 = A1_2
  return L2_2(L3_2, L4_2, L5_2, L6_2)
end
function L19_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2, L6_2
  L2_2 = L3_1
  L3_2 = "crm-banking"
  L4_2 = "removeSocietyMoney"
  L5_2 = A0_2
  L6_2 = A1_2
  return L2_2(L3_2, L4_2, L5_2, L6_2)
end
function L20_1(A0_2, A1_2, A2_2, A3_2)
  local L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2
  L4_2 = L3_1
  L5_2 = "crm-banking"
  L6_2 = "addSocietyTransaction"
  L7_2 = A0_2
  L8_2 = A1_2
  if "deposit" == A3_2 then
    L9_2 = "crm-deposit"
    if L9_2 then
      goto lbl_12
    end
  end
  L9_2 = "crm-withdraw"
  ::lbl_12::
  L10_2 = A2_2
  return L4_2(L5_2, L6_2, L7_2, L8_2, L9_2, L10_2)
end
L14_1(L15_1, L16_1, L17_1, L18_1, L19_1, L20_1)
L14_1 = L13_1
L15_1 = "snipe-banking"
L16_1 = "snipe-banking (job accounts)"
function L17_1(A0_2)
  local L1_2, L2_2, L3_2, L4_2
  L1_2 = L3_1
  L2_2 = "snipe-banking"
  L3_2 = "GetAccountBalance"
  L4_2 = A0_2
  return L1_2(L2_2, L3_2, L4_2)
end
function L18_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2, L6_2
  L2_2 = L3_1
  L3_2 = "snipe-banking"
  L4_2 = "AddMoneyToAccount"
  L5_2 = A0_2
  L6_2 = A1_2
  return L2_2(L3_2, L4_2, L5_2, L6_2)
end
function L19_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2, L6_2
  L2_2 = L3_1
  L3_2 = "snipe-banking"
  L4_2 = "RemoveMoneyFromAccount"
  L5_2 = A0_2
  L6_2 = A1_2
  return L2_2(L3_2, L4_2, L5_2, L6_2)
end
function L20_1(A0_2, A1_2, A2_2, A3_2)
  local L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2
  L4_2 = L3_1
  L5_2 = "snipe-banking"
  L6_2 = "CreateJobTransactions"
  L7_2 = A0_2
  L8_2 = A1_2
  L9_2 = A2_2
  L10_2 = A3_2
  L11_2 = A0_2
  L12_2 = nil
  L13_2 = true
  return L4_2(L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2)
end
L14_1(L15_1, L16_1, L17_1, L18_1, L19_1, L20_1)
function L14_1(A0_2)
  local L1_2, L2_2, L3_2, L4_2
  L1_2 = L4_1
  L2_2 = "esx_society"
  L3_2 = "GetSociety"
  L1_2 = L1_2(L2_2, L3_2)
  if L1_2 then
    L1_2 = L3_1
    L2_2 = "esx_society"
    L3_2 = "GetSociety"
    L4_2 = A0_2
    L1_2, L2_2 = L1_2(L2_2, L3_2, L4_2)
    if L1_2 then
      L3_2 = type
      L4_2 = L2_2
      L3_2 = L3_2(L4_2)
      if "table" == L3_2 then
        L3_2 = type
        L4_2 = L2_2.account
        L3_2 = L3_2(L4_2)
        if "string" == L3_2 then
          L3_2 = L2_2.account
          if "" ~= L3_2 then
            L3_2 = L2_2.account
            return L3_2
          end
        end
      end
    end
  end
  L1_2 = "society_"
  L2_2 = A0_2
  L1_2 = L1_2 .. L2_2
  return L1_2
end
function L15_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2
  L2_2 = L14_1
  L3_2 = A0_2
  L2_2 = L2_2(L3_2)
  L3_2 = false
  L4_2 = false
  L5_2 = nil
  L6_2 = TriggerEvent
  L7_2 = "esx_addonaccount:getSharedAccount"
  L8_2 = L2_2
  function L9_2(A0_3)
    local L1_3, L2_3
    L1_3 = type
    L2_3 = A0_3
    L1_3 = L1_3(L2_3)
    if "table" ~= L1_3 then
      return
    end
    L1_3 = true
    L3_2 = L1_3
    L1_3 = A1_2
    L2_3 = A0_3
    L1_3, L2_3 = L1_3(L2_3)
    L5_2 = L2_3
    L4_2 = L1_3
  end
  L6_2(L7_2, L8_2, L9_2)
  if not L3_2 then
    L6_2 = false
    L7_2 = "noaccount"
    return L6_2, L7_2
  end
  L6_2 = L4_2
  L7_2 = L5_2
  return L6_2, L7_2
end
L16_1 = L0_1.define
L17_1 = "society"
L18_1 = "esx_addonaccount"
L19_1 = {}
L19_1.label = "esx_society / esx_addonaccount (society_<job>)"
L20_1 = {}
L21_1 = "esx_addonaccount"
L20_1[1] = L21_1
L19_1.resources = L20_1
function L20_1(A0_2)
  local L1_2, L2_2, L3_2, L4_2
  L1_2 = nil
  L2_2 = L15_1
  L3_2 = A0_2
  function L4_2(A0_3)
    local L1_3, L2_3
    L1_3 = L6_1
    L2_3 = A0_3.money
    L1_3 = L1_3(L2_3)
    L1_2 = L1_3
    L1_3 = true
    return L1_3
  end
  L2_2 = L2_2(L3_2, L4_2)
  L3_2 = L1_2 or L3_2
  if not L2_2 or not L1_2 then
    L3_2 = nil
  end
  return L3_2
end
L19_1.balance = L20_1
function L20_1(A0_2, A1_2, A2_2)
  local L3_2, L4_2, L5_2
  L3_2 = L15_1
  L4_2 = A0_2
  function L5_2(A0_3)
    local L1_3, L2_3
    L1_3 = L0_1.isCallable
    L2_3 = A0_3.addMoney
    L1_3 = L1_3(L2_3)
    if not L1_3 then
      L1_3 = false
      L2_3 = "unavailable"
      return L1_3, L2_3
    end
    L1_3 = A0_3.addMoney
    L2_3 = A1_2
    L1_3(L2_3)
    L1_3 = true
    return L1_3
  end
  return L3_2(L4_2, L5_2)
end
L19_1.add = L20_1
function L20_1(A0_2, A1_2, A2_2)
  local L3_2, L4_2, L5_2
  L3_2 = L15_1
  L4_2 = A0_2
  function L5_2(A0_3)
    local L1_3, L2_3
    L1_3 = L0_1.isCallable
    L2_3 = A0_3.removeMoney
    L1_3 = L1_3(L2_3)
    if not L1_3 then
      L1_3 = false
      L2_3 = "unavailable"
      return L1_3, L2_3
    end
    L1_3 = L6_1
    L2_3 = A0_3.money
    L1_3 = L1_3(L2_3)
    if not L1_3 then
      L1_3 = 0
    end
    L2_3 = A1_2
    if L1_3 < L2_3 then
      L1_3 = false
      L2_3 = "funds"
      return L1_3, L2_3
    end
    L1_3 = A0_3.removeMoney
    L2_3 = A1_2
    L1_3(L2_3)
    L1_3 = true
    return L1_3
  end
  return L3_2(L4_2, L5_2)
end
L19_1.remove = L20_1
L16_1(L17_1, L18_1, L19_1)
L16_1 = PhoneSociety
if not L16_1 then
  L16_1 = {}
end
PhoneSociety = L16_1
L16_1 = PhoneSociety
function L17_1(A0_2)
  local L1_2, L2_2
  if nil == A0_2 then
    L1_2 = nil
    return L1_2
  end
  L1_2 = tostring
  L2_2 = A0_2
  L1_2 = L1_2(L2_2)
  A0_2 = L1_2
  if "" == A0_2 or "unemployed" == A0_2 then
    L1_2 = nil
    return L1_2
  end
  return A0_2
end
function L18_1(A0_2)
  local L1_2, L2_2, L3_2
  L1_2 = L0_1.num
  L2_2 = A0_2
  L1_2 = L1_2(L2_2)
  if not L1_2 then
    L2_2 = nil
    return L2_2
  end
  L2_2 = math
  L2_2 = L2_2.floor
  L3_2 = L1_2
  L2_2 = L2_2(L3_2)
  L1_2 = L2_2
  if L1_2 <= 0 then
    L2_2 = nil
    return L2_2
  end
  L2_2 = math
  L2_2 = L2_2.tointeger
  L3_2 = L1_2
  L2_2 = L2_2(L3_2)
  if not L2_2 then
    L2_2 = L1_2
  end
  return L2_2
end
function L19_1(A0_2, A1_2, A2_2, A3_2)
  local L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2
  L4_2 = Integration
  L5_2 = "society"
  L4_2, L5_2 = L4_2(L5_2)
  L6_2 = L0_1.builtin
  L6_2 = L6_2.society
  if "builtin" ~= L5_2 and L4_2 then
    L7_2 = L0_1.isCallable
    L8_2 = L4_2[A0_2]
    L7_2 = L7_2(L8_2)
    if L7_2 then
      L7_2 = IntegrationTry
      L8_2 = "society"
      L9_2 = A0_2
      L10_2 = A1_2
      L11_2 = A2_2
      L12_2 = A3_2
      L7_2, L8_2, L9_2 = L7_2(L8_2, L9_2, L10_2, L11_2, L12_2)
      if L7_2 then
        if "balance" == A0_2 then
          L10_2 = L0_1.num
          L11_2 = L8_2
          L10_2 = L10_2(L11_2)
          if L10_2 then
            L11_2 = math
            L11_2 = L11_2.floor
            L12_2 = L10_2
            return L11_2(L12_2)
          end
        elseif nil ~= L8_2 and false ~= L8_2 then
          L10_2 = L0_1.dbg
          L11_2 = "society %s %s %s %s -> ok"
          L12_2 = L5_2
          L13_2 = A0_2
          L14_2 = A1_2
          L15_2 = tostring
          L16_2 = A2_2
          L15_2, L16_2, L17_2 = L15_2(L16_2)
          L10_2(L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2)
          L10_2 = true
          return L10_2
        else
          L10_2 = tostring
          L11_2 = L9_2
          L10_2 = L10_2(L11_2)
          L11_2 = L2_1
          L10_2 = L11_2[L10_2]
          if not L10_2 then
            L10_2 = L0_1.dbg
            L11_2 = "society %s %s %s %s -> %s"
            L12_2 = L5_2
            L13_2 = A0_2
            L14_2 = A1_2
            L15_2 = tostring
            L16_2 = A2_2
            L15_2 = L15_2(L16_2)
            L16_2 = tostring
            L17_2 = L9_2
            L16_2, L17_2 = L16_2(L17_2)
            L10_2(L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2)
            L10_2 = false
            if nil ~= L9_2 then
              L11_2 = tostring
              L12_2 = L9_2
              L11_2 = L11_2(L12_2)
              if L11_2 then
                goto lbl_81
              end
            end
            L11_2 = "failed"
            ::lbl_81::
            return L10_2, L11_2
          else
            L10_2 = L0_1.warnOnce
            L11_2 = "soc_fb_"
            L12_2 = L5_2
            L13_2 = A0_2
            L14_2 = tostring
            L15_2 = L9_2
            L14_2 = L14_2(L15_2)
            L11_2 = L11_2 .. L12_2 .. L13_2 .. L14_2
            L12_2 = "society provider '%s' has no account for this job (%s): using the phone's built-in society behaviour for it"
            L13_2 = L12_2
            L12_2 = L12_2.format
            L14_2 = L5_2
            L15_2 = tostring
            L16_2 = L9_2
            L15_2, L16_2, L17_2 = L15_2(L16_2)
            L12_2, L13_2, L14_2, L15_2, L16_2, L17_2 = L12_2(L13_2, L14_2, L15_2, L16_2, L17_2)
            L10_2(L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2)
          end
        end
      end
    end
  end
  L7_2 = L6_2
  if L6_2 then
    L7_2 = L6_2[A0_2]
  end
  L8_2 = L0_1.isCallable
  L9_2 = L7_2
  L8_2 = L8_2(L9_2)
  if not L8_2 then
    if "balance" == A0_2 then
      L8_2 = 0
      if L8_2 then
        goto lbl_113
      end
    end
    L8_2 = false
    ::lbl_113::
    return L8_2
  end
  L8_2 = pcall
  L9_2 = L7_2
  L10_2 = A1_2
  L11_2 = A2_2
  L12_2 = A3_2
  L8_2, L9_2, L10_2 = L8_2(L9_2, L10_2, L11_2, L12_2)
  if not L8_2 then
    L11_2 = L0_1.warnOnce
    L12_2 = "soc_builtin_"
    L13_2 = A0_2
    L12_2 = L12_2 .. L13_2
    L13_2 = "society builtin failed in %s (%s)"
    L14_2 = L13_2
    L13_2 = L13_2.format
    L15_2 = A0_2
    L16_2 = tostring
    L17_2 = L9_2
    L16_2, L17_2 = L16_2(L17_2)
    L13_2, L14_2, L15_2, L16_2, L17_2 = L13_2(L14_2, L15_2, L16_2, L17_2)
    L11_2(L12_2, L13_2, L14_2, L15_2, L16_2, L17_2)
    if "balance" == A0_2 then
      L11_2 = 0
      if L11_2 then
        goto lbl_140
      end
    end
    L11_2 = false
    ::lbl_140::
    L12_2 = "error"
    return L11_2, L12_2
  end
  if "balance" == A0_2 then
    L11_2 = L6_1
    L12_2 = L9_2
    L11_2 = L11_2(L12_2)
    if not L11_2 then
      L11_2 = 0
    end
    return L11_2
  end
  if nil ~= L9_2 and false ~= L9_2 then
    L11_2 = true
    return L11_2
  end
  L11_2 = false
  L12_2 = L10_2 or L12_2
  if not L10_2 then
    L12_2 = "failed"
  end
  return L11_2, L12_2
end
function L20_1(A0_2)
  local L1_2, L2_2, L3_2
  L1_2 = L17_1
  L2_2 = A0_2
  L1_2 = L1_2(L2_2)
  A0_2 = L1_2
  if not A0_2 then
    L1_2 = 0
    return L1_2
  end
  L1_2 = L19_1
  L2_2 = "balance"
  L3_2 = A0_2
  return L1_2(L2_2, L3_2)
end
L16_1.balance = L20_1
function L20_1(A0_2, A1_2, A2_2)
  local L3_2, L4_2, L5_2, L6_2, L7_2, L8_2
  L3_2 = L17_1
  L4_2 = A0_2
  L3_2 = L3_2(L4_2)
  L4_2 = L18_1
  L5_2 = A1_2
  L4_2 = L4_2(L5_2)
  A1_2 = L4_2
  A0_2 = L3_2
  if not A0_2 or not A1_2 then
    L3_2 = false
    L4_2 = "invalid"
    return L3_2, L4_2
  end
  L3_2 = L19_1
  L4_2 = "add"
  L5_2 = A0_2
  L6_2 = A1_2
  if nil ~= A2_2 then
    L7_2 = tostring
    L8_2 = A2_2
    L7_2 = L7_2(L8_2)
    if L7_2 then
      goto lbl_28
    end
  end
  L7_2 = "Unique_Phone"
  ::lbl_28::
  return L3_2(L4_2, L5_2, L6_2, L7_2)
end
L16_1.add = L20_1
function L20_1(A0_2, A1_2, A2_2)
  local L3_2, L4_2, L5_2, L6_2, L7_2, L8_2
  L3_2 = L17_1
  L4_2 = A0_2
  L3_2 = L3_2(L4_2)
  L4_2 = L18_1
  L5_2 = A1_2
  L4_2 = L4_2(L5_2)
  A1_2 = L4_2
  A0_2 = L3_2
  if not A0_2 or not A1_2 then
    L3_2 = false
    L4_2 = "invalid"
    return L3_2, L4_2
  end
  L3_2 = L19_1
  L4_2 = "remove"
  L5_2 = A0_2
  L6_2 = A1_2
  if nil ~= A2_2 then
    L7_2 = tostring
    L8_2 = A2_2
    L7_2 = L7_2(L8_2)
    if L7_2 then
      goto lbl_28
    end
  end
  L7_2 = "Unique_Phone"
  ::lbl_28::
  return L3_2(L4_2, L5_2, L6_2, L7_2)
end
L16_1.remove = L20_1
L20_1 = FW
function L21_1(A0_2)
  local L1_2, L2_2
  L1_2 = L16_1.balance
  L2_2 = A0_2
  return L1_2(L2_2)
end
L20_1.GetSocietyMoney = L21_1
L20_1 = FW
function L21_1(A0_2, A1_2, A2_2)
  local L3_2, L4_2, L5_2, L6_2, L7_2
  L3_2 = L0_1.num
  L4_2 = A1_2
  L3_2 = L3_2(L4_2)
  if L3_2 then
    if L3_2 < 0 then
      L4_2 = math
      L4_2 = L4_2.floor
      L5_2 = -L3_2
      L4_2 = L4_2(L5_2)
      L4_2 = -L4_2
      if L4_2 then
        goto lbl_22
        L3_2 = L4_2 or L3_2
      end
    end
    L4_2 = math
    L4_2 = L4_2.floor
    L5_2 = L3_2
    L4_2 = L4_2(L5_2)
    if L4_2 then
      goto lbl_22
      L3_2 = L4_2 or L3_2
    end
  end
  L3_2 = 0
  ::lbl_22::
  if L3_2 > 0 then
    L4_2 = L16_1.add
    L5_2 = A0_2
    L6_2 = L3_2
    L7_2 = A2_2
    L4_2 = L4_2(L5_2, L6_2, L7_2)
    L4_2 = true == L4_2
    return L4_2
  end
  if L3_2 < 0 then
    L4_2 = L16_1.remove
    L5_2 = A0_2
    L6_2 = -L3_2
    L7_2 = A2_2
    L4_2 = L4_2(L5_2, L6_2, L7_2)
    L4_2 = true == L4_2
    return L4_2
  end
  L4_2 = false
  return L4_2
end
L20_1.AddSocietyMoney = L21_1
L20_1 = FW
function L21_1(A0_2, A1_2, A2_2)
  local L3_2, L4_2, L5_2, L6_2
  L3_2 = L16_1.remove
  L4_2 = A0_2
  L5_2 = A1_2
  L6_2 = A2_2
  L3_2 = L3_2(L4_2, L5_2, L6_2)
  L3_2 = true == L3_2
  return L3_2
end
L20_1.RemoveSocietyMoney = L21_1
L20_1 = rawget
L21_1 = Config
L22_1 = "SocietyProvider"
L20_1 = L20_1(L21_1, L22_1)
L21_1 = type
L22_1 = Config
L22_1 = L22_1.Integrations
L21_1 = L21_1(L22_1)
if "table" == L21_1 then
  L21_1 = type
  L22_1 = L20_1
  L21_1 = L21_1(L22_1)
  if "string" == L21_1 and "" ~= L20_1 and "auto" ~= L20_1 then
    L21_1 = Config
    L21_1 = L21_1.Integrations
    L21_1 = L21_1.society
    if nil ~= L21_1 then
      L21_1 = Config
      L21_1 = L21_1.Integrations
      L21_1 = L21_1.society
      if "auto" ~= L21_1 then
        goto lbl_272
      end
    end
    L21_1 = Config
    L21_1 = L21_1.Integrations
    L21_1.society = "builtin"
  end
end
::lbl_272::
