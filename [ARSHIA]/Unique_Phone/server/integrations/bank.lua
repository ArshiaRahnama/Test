local L0_1, L1_1, L2_1, L3_1, L4_1, L5_1, L6_1, L7_1, L8_1, L9_1, L10_1, L11_1, L12_1, L13_1, L14_1, L15_1, L16_1
L0_1 = PhoneIntegrations
function L1_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2
  L2_2 = MySQL
  L2_2 = L2_2.query
  L2_2 = L2_2.await
  L3_2 = A0_2
  L4_2 = A1_2
  L2_2 = L2_2(L3_2, L4_2)
  L3_2 = type
  L4_2 = L2_2
  L3_2 = L3_2(L4_2)
  L3_2 = L2_2 or L3_2
  if "table" ~= L3_2 or not L2_2 then
    L3_2 = {}
  end
  return L3_2
end
function L2_1(A0_2)
  local L1_2, L2_2
  if A0_2 then
    L1_2 = FW
    L1_2 = L1_2.GetPlayer
    L2_2 = A0_2
    L1_2 = L1_2(L2_2)
    if L1_2 then
      goto lbl_10
    end
  end
  L1_2 = nil
  ::lbl_10::
  return L1_2
end
function L3_1(A0_2)
  local L1_2, L2_2, L3_2, L4_2, L5_2
  L1_2 = L2_1
  L2_2 = A0_2
  L1_2 = L1_2(L2_2)
  L2_2 = pcall
  function L3_2()
    local L0_3, L1_3
    L0_3 = L1_2.raw
    L0_3 = L0_3.PlayerData
    L0_3 = L0_3.charinfo
    L0_3 = L0_3.account
    return L0_3
  end
  L2_2, L3_2 = L2_2(L3_2)
  if L2_2 then
    L4_2 = type
    L5_2 = L3_2
    L4_2 = L4_2(L5_2)
    if "string" == L4_2 and "" ~= L3_2 then
      return L3_2
    end
  end
  L4_2 = nil
  return L4_2
end
L4_1 = L0_1.define
L5_1 = "bank"
L6_1 = "apex_banking"
L7_1 = {}
L7_1.label = "apex_banking"
L8_1 = {}
L9_1 = "apex_banking"
L8_1[1] = L9_1
L7_1.resources = L8_1
L7_1.aliasBuiltin = true
L4_1(L5_1, L6_1, L7_1)
function L4_1(A0_2)
  local L1_2, L2_2, L3_2, L4_2, L5_2, L6_2
  L1_2 = L0_1.callExport
  L2_2 = "Renewed-Banking"
  L3_2 = "getAccountTransactions"
  L4_2 = A0_2
  L1_2, L2_2 = L1_2(L2_2, L3_2, L4_2)
  if L1_2 then
    L3_2 = type
    L4_2 = L2_2
    L3_2 = L3_2(L4_2)
    if "table" == L3_2 then
      L3_2 = L2_2
      L4_2 = true
      return L3_2, L4_2
    end
  end
  L3_2 = L1_1
  L4_2 = "SELECT transactions FROM player_transactions WHERE id = ? LIMIT 1"
  L5_2 = {}
  L6_2 = A0_2
  L5_2[1] = L6_2
  L3_2 = L3_2(L4_2, L5_2)
  L3_2 = L3_2[1]
  if L3_2 then
    L4_2 = L0_1.decode
    L5_2 = L3_2.transactions
    L4_2 = L4_2(L5_2)
    if L4_2 then
      goto lbl_33
    end
  end
  L4_2 = {}
  ::lbl_33::
  L5_2 = false
  return L4_2, L5_2
end
L5_1 = L0_1.define
L6_1 = "bank"
L7_1 = "Renewed-Banking"
L8_1 = {}
L8_1.label = "Renewed-Banking"
L9_1 = {}
L10_1 = "Renewed-Banking"
L9_1[1] = L10_1
L8_1.resources = L9_1
function L9_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2
  L2_2 = L1_1
  L3_2 = "SELECT isFrozen FROM player_transactions WHERE id = ? LIMIT 1"
  L4_2 = {}
  L5_2 = A1_2
  L4_2[1] = L5_2
  L2_2 = L2_2(L3_2, L4_2)
  L2_2 = L2_2[1]
  L3_2 = {}
  L3_2.iban = A1_2
  if L2_2 then
    L4_2 = tonumber
    L5_2 = L2_2.isFrozen
    L4_2 = L4_2(L5_2)
  end
  L4_2 = 1 == L4_2 or L4_2
  L3_2.frozen = L4_2
  return L3_2
end
L8_1.info = L9_1
function L9_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2
  L2_2 = {}
  L3_2 = L4_1
  L4_2 = A1_2
  L3_2 = L3_2(L4_2)
  L4_2 = ipairs
  L5_2 = L3_2
  L4_2, L5_2, L6_2, L7_2 = L4_2(L5_2)
  for L8_2, L9_2 in L4_2, L5_2, L6_2, L7_2 do
    if L8_2 > 60 then
      break
    end
    L10_2 = L0_1.num
    L11_2 = L9_2.amount
    L10_2 = L10_2(L11_2)
    if not L10_2 then
      L10_2 = 0
    end
    L11_2 = tostring
    L12_2 = L9_2.trans_type
    if not L12_2 then
      L12_2 = ""
    end
    L11_2 = L11_2(L12_2)
    L12_2 = L11_2
    L11_2 = L11_2.lower
    L11_2 = L11_2(L12_2)
    L11_2 = "withdraw" == L11_2
    L12_2 = type
    L13_2 = L9_2.message
    L12_2 = L12_2(L13_2)
    if "string" == L12_2 then
      L12_2 = L9_2.message
      if "" ~= L12_2 then
        L12_2 = " \194\183 "
        L13_2 = L9_2.message
        L12_2 = L12_2 .. L13_2
        if L12_2 then
          goto lbl_44
        end
      end
    end
    L12_2 = ""
    ::lbl_44::
    L13_2 = #L2_2
    L13_2 = L13_2 + 1
    L14_2 = {}
    L15_2 = L9_2.trans_id
    if not L15_2 then
      L15_2 = L8_2
    end
    L14_2.id = L15_2
    L15_2 = tostring
    L16_2 = L9_2.title
    if not L16_2 then
      L16_2 = "Banco"
    end
    L15_2 = L15_2(L16_2)
    L16_2 = L12_2
    L15_2 = L15_2 .. L16_2
    L14_2.description = L15_2
    if L11_2 then
      L15_2 = math
      L15_2 = L15_2.abs
      L16_2 = L10_2
      L15_2 = L15_2(L16_2)
      L15_2 = -L15_2
      if L15_2 then
        goto lbl_76
      end
    end
    L15_2 = math
    L15_2 = L15_2.abs
    L16_2 = L10_2
    L15_2 = L15_2(L16_2)
    ::lbl_76::
    L14_2.amount = L15_2
    L15_2 = L9_2.time
    L14_2.created = L15_2
    L2_2[L13_2] = L14_2
  end
  return L2_2
end
L8_1.history = L9_1
function L9_1(A0_2, A1_2, A2_2, A3_2)
  local L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2
  if A2_2 < 0 then
    L4_2 = "withdraw"
    if L4_2 then
      goto lbl_7
    end
  end
  L4_2 = "deposit"
  ::lbl_7::
  L5_2 = L0_1.nameOf
  L6_2 = A0_2
  L5_2 = L5_2(L6_2)
  if not L5_2 then
    L5_2 = tostring
    L6_2 = A0_2
    L5_2 = L5_2(L6_2)
  end
  L6_2 = L4_1
  L7_2 = A0_2
  L6_2, L7_2 = L6_2(L7_2)
  if L7_2 then
    L8_2 = L0_1.callExport
    L9_2 = "Renewed-Banking"
    L10_2 = "handleTransaction"
    L11_2 = tostring
    L12_2 = A0_2
    L11_2 = L11_2(L12_2)
    L12_2 = "Phone"
    L13_2 = math
    L13_2 = L13_2.abs
    L14_2 = A2_2
    L13_2 = L13_2(L14_2)
    L13_2 = L13_2 + 0.0
    L14_2 = tostring
    L15_2 = A1_2
    L14_2 = L14_2(L15_2)
    L15_2 = L5_2
    L16_2 = L5_2
    L17_2 = L4_2
    L8_2 = L8_2(L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2)
    L9_2 = true == L8_2
    return L9_2
  end
  L8_2 = false
  return L8_2
end
L8_1.record = L9_1
L5_1(L6_1, L7_1, L8_1)
function L5_1()
  local L0_2, L1_2
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
L0_1.okokReal = L5_1
L5_1 = L0_1.define
L6_1 = "bank"
L7_1 = "okokBanking"
L8_1 = {}
L8_1.label = "okokBanking"
function L9_1()
  local L0_2, L1_2
  L0_2 = L0_1.okokReal
  return L0_2()
end
L8_1.detect = L9_1
L8_1.verified = false
function L9_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2, L6_2
  L2_2 = nil
  L3_2 = FW
  L3_2 = L3_2.name
  if "esx" == L3_2 then
    L3_2 = L1_1
    L4_2 = "SELECT iban FROM users WHERE identifier = ? LIMIT 1"
    L5_2 = {}
    L6_2 = A1_2
    L5_2[1] = L6_2
    L3_2 = L3_2(L4_2, L5_2)
    L3_2 = L3_2[1]
    if L3_2 then
      L4_2 = L3_2.iban
      L2_2 = L4_2 or L2_2
    end
    if not L4_2 then
      L2_2 = nil
    end
  else
    L3_2 = L3_1
    L4_2 = A0_2
    L3_2 = L3_2(L4_2)
    L2_2 = L3_2
  end
  L3_2 = {}
  L4_2 = type
  L5_2 = L2_2
  L4_2 = L4_2(L5_2)
  L4_2 = L2_2 or L4_2
  if "string" ~= L4_2 or "" == L2_2 or not L2_2 then
    L4_2 = nil
  end
  L3_2.iban = L4_2
  return L3_2
end
L8_1.info = L9_1
function L9_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2
  L2_2 = nil
  L3_2 = L0_1.callExport
  L4_2 = "okokBanking"
  L5_2 = "GetPlayerTransactions"
  L6_2 = A1_2
  L7_2 = 60
  L3_2, L4_2 = L3_2(L4_2, L5_2, L6_2, L7_2)
  if L3_2 then
    L5_2 = type
    L6_2 = L4_2
    L5_2 = L5_2(L6_2)
    if "table" == L5_2 then
      L2_2 = L4_2
  end
  else
    L5_2 = L1_1
    L6_2 = "SELECT * FROM okokbanking_transactions WHERE sender_identifier = ? OR receiver_identifier = ? ORDER BY id DESC LIMIT 60"
    L7_2 = {}
    L8_2 = A1_2
    L9_2 = A1_2
    L7_2[1] = L8_2
    L7_2[2] = L9_2
    L5_2 = L5_2(L6_2, L7_2)
    L2_2 = L5_2
  end
  L5_2 = {}
  L6_2 = ipairs
  L7_2 = L2_2
  L6_2, L7_2, L8_2, L9_2 = L6_2(L7_2)
  for L10_2, L11_2 in L6_2, L7_2, L8_2, L9_2 do
    L12_2 = math
    L12_2 = L12_2.abs
    L13_2 = L0_1.num
    L14_2 = L11_2.value
    if not L14_2 then
      L14_2 = L11_2.amount
    end
    L13_2 = L13_2(L14_2)
    if not L13_2 then
      L13_2 = 0
    end
    L12_2 = L12_2(L13_2)
    L13_2 = L11_2.receiver_identifier
    L13_2 = L13_2 == A1_2
    if L13_2 then
      L14_2 = L11_2.sender_name
      if L14_2 then
        goto lbl_61
      end
      L14_2 = L11_2.sender_identifier
      if L14_2 then
        goto lbl_61
      end
    end
    L14_2 = L11_2.receiver_name
    if not L14_2 then
      L14_2 = L11_2.receiver_identifier
    end
    ::lbl_61::
    L15_2 = tostring
    L16_2 = L11_2.reason
    if not L16_2 then
      L16_2 = L11_2.type
      if not L16_2 then
        L16_2 = "Banco"
      end
    end
    L15_2 = L15_2(L16_2)
    if nil ~= L14_2 then
      L16_2 = tostring
      L17_2 = L14_2
      L16_2 = L16_2(L17_2)
      if "" ~= L16_2 then
        L16_2 = " \194\183 "
        L17_2 = tostring
        L18_2 = L14_2
        L17_2 = L17_2(L18_2)
        L16_2 = L16_2 .. L17_2
        if L16_2 then
          goto lbl_85
        end
      end
    end
    L16_2 = ""
    ::lbl_85::
    L15_2 = L15_2 .. L16_2
    L16_2 = #L5_2
    L16_2 = L16_2 + 1
    L17_2 = {}
    L18_2 = L11_2.id
    if not L18_2 then
      L18_2 = L10_2
    end
    L17_2.id = L18_2
    L17_2.description = L15_2
    L18_2 = L12_2 or L18_2
    if not L13_2 or not L12_2 then
      L18_2 = -L12_2
    end
    L17_2.amount = L18_2
    L18_2 = L11_2.date
    if not L18_2 then
      L18_2 = L11_2.created_at
    end
    L17_2.created = L18_2
    L5_2[L16_2] = L17_2
  end
  return L5_2
end
L8_1.history = L9_1
function L9_1(A0_2, A1_2, A2_2, A3_2)
  local L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2
  L4_2 = L0_1.nameOf
  L5_2 = A0_2
  L4_2 = L4_2(L5_2)
  if not L4_2 then
    L4_2 = tostring
    L5_2 = A0_2
    L4_2 = L4_2(L5_2)
  end
  if A2_2 < 0 then
    L5_2 = {}
    L5_2.sender_identifier = A0_2
    L5_2.sender_name = L4_2
    L5_2.receiver_identifier = "phone"
    L5_2.receiver_name = "Phone"
    L6_2 = math
    L6_2 = L6_2.abs
    L7_2 = A2_2
    L6_2 = L6_2(L7_2)
    L5_2.value = L6_2
    L5_2.type = "transfer"
    L5_2.reason = A1_2
    if L5_2 then
      goto lbl_39
    end
  end
  L5_2 = {}
  L5_2.sender_identifier = "phone"
  L5_2.sender_name = "Phone"
  L5_2.receiver_identifier = A0_2
  L5_2.receiver_name = L4_2
  L6_2 = math
  L6_2 = L6_2.abs
  L7_2 = A2_2
  L6_2 = L6_2(L7_2)
  L5_2.value = L6_2
  L5_2.type = "transfer"
  L5_2.reason = A1_2
  ::lbl_39::
  L6_2 = L0_1.callExport
  L7_2 = "okokBanking"
  L8_2 = "AddTransaction"
  L9_2 = A0_2
  L10_2 = L5_2
  L11_2 = A3_2
  L6_2 = L6_2(L7_2, L8_2, L9_2, L10_2, L11_2)
  L7_2 = true == L6_2
  return L7_2
end
L8_1.record = L9_1
L5_1(L6_1, L7_1, L8_1)
function L5_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2, L6_2, L7_2
  L2_2 = nil
  L3_2 = nil
  if A0_2 then
    L4_2 = L0_1.callExport
    L5_2 = "tgg-banking"
    L6_2 = "GetPersonalAccountByPlayerId"
    L7_2 = A0_2
    L4_2, L5_2 = L4_2(L5_2, L6_2, L7_2)
    L3_2 = L5_2
    L2_2 = L4_2
  end
  if L2_2 then
    L4_2 = type
    L5_2 = L3_2
    L4_2 = L4_2(L5_2)
    if "table" == L4_2 then
      goto lbl_25
    end
  end
  L4_2 = L0_1.callExport
  L5_2 = "tgg-banking"
  L6_2 = "GetPersonalAccountByPlayerIdentifier"
  L7_2 = A1_2
  L4_2, L5_2 = L4_2(L5_2, L6_2, L7_2)
  L3_2 = L5_2
  L2_2 = L4_2
  ::lbl_25::
  if L2_2 then
    L4_2 = type
    L5_2 = L3_2
    L4_2 = L4_2(L5_2)
    if "table" == L4_2 and L3_2 then
      goto lbl_35
      L4_2 = L3_2 or L4_2
    end
  end
  L4_2 = nil
  ::lbl_35::
  return L4_2
end
L6_1 = L0_1.define
L7_1 = "bank"
L8_1 = "tgg-banking"
L9_1 = {}
L9_1.label = "tgg-banking"
L10_1 = {}
L11_1 = "tgg-banking"
L10_1[1] = L11_1
L9_1.resources = L10_1
L9_1.verified = false
function L10_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2
  L2_2 = L5_1
  L3_2 = A0_2
  L4_2 = A1_2
  L2_2 = L2_2(L3_2, L4_2)
  if L2_2 then
    L3_2 = L0_1.num
    L4_2 = L2_2.balance
    L3_2 = L3_2(L4_2)
    if L3_2 then
      goto lbl_13
    end
  end
  L3_2 = nil
  ::lbl_13::
  return L3_2
end
L9_1.balance = L10_1
function L10_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2
  L2_2 = L5_1
  L3_2 = A0_2
  L4_2 = A1_2
  L2_2 = L2_2(L3_2, L4_2)
  if not L2_2 then
    L3_2 = {}
    L3_2.noAccount = true
    return L3_2
  end
  L3_2 = {}
  L4_2 = L2_2.iban
  if nil ~= L4_2 then
    L4_2 = tostring
    L5_2 = L2_2.iban
    L4_2 = L4_2(L5_2)
    if L4_2 then
      goto lbl_22
    end
  end
  L4_2 = nil
  ::lbl_22::
  L3_2.iban = L4_2
  L4_2 = L2_2.frozen
  L4_2 = true == L4_2
  L3_2.frozen = L4_2
  return L3_2
end
L9_1.info = L10_1
function L10_1(A0_2, A1_2, A2_2, A3_2)
  local L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2
  L4_2 = L5_1
  L5_2 = A3_2
  L6_2 = A0_2
  L4_2 = L4_2(L5_2, L6_2)
  if L4_2 then
    L5_2 = L4_2.iban
    if L5_2 then
      goto lbl_12
    end
  end
  L5_2 = false
  do return L5_2 end
  ::lbl_12::
  L5_2 = nil
  L6_2 = nil
  if A2_2 < 0 then
    L7_2 = L0_1.callExport
    L8_2 = "tgg-banking"
    L9_2 = "AddTransaction"
    L10_2 = nil
    L11_2 = L4_2.iban
    L12_2 = "withdraw"
    L13_2 = math
    L13_2 = L13_2.abs
    L14_2 = A2_2
    L13_2 = L13_2(L14_2)
    L14_2 = tostring
    L15_2 = A1_2
    L14_2, L15_2 = L14_2(L15_2)
    L7_2, L8_2 = L7_2(L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2)
    L6_2 = L8_2
    L5_2 = L7_2
  else
    L7_2 = L0_1.callExport
    L8_2 = "tgg-banking"
    L9_2 = "AddTransaction"
    L10_2 = L4_2.iban
    L11_2 = nil
    L12_2 = "deposit"
    L13_2 = math
    L13_2 = L13_2.abs
    L14_2 = A2_2
    L13_2 = L13_2(L14_2)
    L14_2 = tostring
    L15_2 = A1_2
    L14_2, L15_2 = L14_2(L15_2)
    L7_2, L8_2 = L7_2(L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2)
    L6_2 = L8_2
    L5_2 = L7_2
  end
  L7_2 = true == L5_2 and nil ~= L6_2
  return L7_2
end
L9_1.record = L10_1
L6_1(L7_1, L8_1, L9_1)
L6_1 = L0_1.define
L7_1 = "bank"
L8_1 = "ps-banking"
L9_1 = {}
L9_1.label = "ps-banking"
L10_1 = {}
L11_1 = "ps-banking"
L10_1[1] = L11_1
L9_1.resources = L10_1
function L10_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2
  L2_2 = {}
  L3_2 = ipairs
  L4_2 = L1_1
  L5_2 = "SELECT id, description, type, amount, date, isIncome FROM ps_banking_transactions WHERE identifier = ? ORDER BY date DESC, id DESC LIMIT 60"
  L6_2 = {}
  L7_2 = A1_2
  L6_2[1] = L7_2
  L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2 = L4_2(L5_2, L6_2)
  L3_2, L4_2, L5_2, L6_2 = L3_2(L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2)
  for L7_2, L8_2 in L3_2, L4_2, L5_2, L6_2 do
    L9_2 = math
    L9_2 = L9_2.abs
    L10_2 = L0_1.num
    L11_2 = L8_2.amount
    L10_2 = L10_2(L11_2)
    if not L10_2 then
      L10_2 = 0
    end
    L9_2 = L9_2(L10_2)
    L10_2 = L8_2.isIncome
    L10_2 = true == L10_2
    L11_2 = #L2_2
    L11_2 = L11_2 + 1
    L12_2 = {}
    L13_2 = L8_2.id
    if not L13_2 then
      L13_2 = L7_2
    end
    L12_2.id = L13_2
    L13_2 = tostring
    L14_2 = L8_2.description
    if not L14_2 then
      L14_2 = L8_2.type
      if not L14_2 then
        L14_2 = "Banco"
      end
    end
    L13_2 = L13_2(L14_2)
    L12_2.description = L13_2
    L13_2 = L9_2 or L13_2
    if not L10_2 or not L9_2 then
      L13_2 = -L9_2
    end
    L12_2.amount = L13_2
    L13_2 = L8_2.date
    L12_2.created = L13_2
    L2_2[L11_2] = L12_2
  end
  return L2_2
end
L9_1.history = L10_1
function L10_1(A0_2, A1_2, A2_2, A3_2)
  local L4_2, L5_2
  L4_2 = FW
  L4_2 = L4_2.GetPlayerByCid
  L5_2 = A0_2
  L4_2 = L4_2(L5_2)
  if L4_2 then
    L4_2 = true
    return L4_2
  end
  L4_2 = pcall
  function L5_2()
    local L0_3, L1_3, L2_3, L3_3, L4_3, L5_3, L6_3, L7_3
    L0_3 = MySQL
    L0_3 = L0_3.insert
    L0_3 = L0_3.await
    L1_3 = "INSERT INTO ps_banking_transactions (identifier, description, type, amount, date, isIncome) VALUES (?, ?, ?, ?, NOW(), ?)"
    L2_3 = {}
    L3_3 = A0_2
    L4_3 = tostring
    L5_3 = A1_2
    L4_3 = L4_3(L5_3)
    L5_3 = L4_3
    L4_3 = L4_3.sub
    L6_3 = 1
    L7_3 = 255
    L4_3 = L4_3(L5_3, L6_3, L7_3)
    L5_3 = "bank"
    L6_3 = math
    L6_3 = L6_3.abs
    L7_3 = A2_2
    L6_3 = L6_3(L7_3)
    L7_3 = A2_2
    L7_3 = L7_3 > 0
    L2_3[1] = L3_3
    L2_3[2] = L4_3
    L2_3[3] = L5_3
    L2_3[4] = L6_3
    L2_3[5] = L7_3
    L0_3(L1_3, L2_3)
  end
  L4_2 = L4_2(L5_2)
  return L4_2
end
L9_1.record = L10_1
L6_1(L7_1, L8_1, L9_1)
L6_1 = L0_1.define
L7_1 = "bank"
L8_1 = "qb-banking"
L9_1 = {}
L9_1.label = "qb-banking 2.x"
function L10_1()
  local L0_2, L1_2, L2_2, L3_2, L4_2
  L0_2 = L0_1.started
  L1_2 = "qb-banking"
  L0_2 = L0_2(L1_2)
  if not L0_2 then
    L0_2 = false
    return L0_2
  end
  L0_2 = GetResourceMetadata
  L1_2 = "qb-banking"
  L2_2 = "version"
  L3_2 = 0
  L0_2 = L0_2(L1_2, L2_2, L3_2)
  L1_2 = type
  L2_2 = L0_2
  L1_2 = L1_2(L2_2)
  L1_2 = "string" == L1_2
  return L1_2
end
L9_1.detect = L10_1
function L10_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2
  L2_2 = {}
  L3_2 = L3_1
  L4_2 = A0_2
  L3_2 = L3_2(L4_2)
  L2_2.iban = L3_2
  return L2_2
end
L9_1.info = L10_1
function L10_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2
  L2_2 = {}
  L3_2 = ipairs
  L4_2 = L1_1
  L5_2 = "SELECT id, amount, reason, statement_type, date FROM bank_statements WHERE citizenid = ? AND account_name = 'checking' ORDER BY id DESC LIMIT 60"
  L6_2 = {}
  L7_2 = A1_2
  L6_2[1] = L7_2
  L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2 = L4_2(L5_2, L6_2)
  L3_2, L4_2, L5_2, L6_2 = L3_2(L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2)
  for L7_2, L8_2 in L3_2, L4_2, L5_2, L6_2 do
    L9_2 = math
    L9_2 = L9_2.abs
    L10_2 = L0_1.num
    L11_2 = L8_2.amount
    L10_2 = L10_2(L11_2)
    if not L10_2 then
      L10_2 = 0
    end
    L9_2 = L9_2(L10_2)
    L10_2 = #L2_2
    L10_2 = L10_2 + 1
    L11_2 = {}
    L12_2 = L8_2.id
    if not L12_2 then
      L12_2 = L7_2
    end
    L11_2.id = L12_2
    L12_2 = tostring
    L13_2 = L8_2.reason
    if not L13_2 then
      L13_2 = "Banco"
    end
    L12_2 = L12_2(L13_2)
    L11_2.description = L12_2
    L12_2 = L8_2.statement_type
    if "withdraw" == L12_2 then
      L12_2 = -L9_2
      if L12_2 then
        goto lbl_46
      end
    end
    L12_2 = L9_2
    ::lbl_46::
    L11_2.amount = L12_2
    L12_2 = L8_2.date
    L11_2.created = L12_2
    L2_2[L10_2] = L11_2
  end
  return L2_2
end
L9_1.history = L10_1
function L10_1(A0_2, A1_2, A2_2, A3_2)
  local L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2
  if A2_2 < 0 then
    L4_2 = "withdraw"
    if L4_2 then
      goto lbl_7
    end
  end
  L4_2 = "deposit"
  ::lbl_7::
  L5_2 = tostring
  L6_2 = A1_2
  L5_2 = L5_2(L6_2)
  L6_2 = L5_2
  L5_2 = L5_2.sub
  L7_2 = 1
  L8_2 = 50
  L5_2 = L5_2(L6_2, L7_2, L8_2)
  if A3_2 then
    L6_2 = FW
    L6_2 = L6_2.GetPlayer
    L7_2 = A3_2
    L6_2 = L6_2(L7_2)
    if L6_2 then
      L6_2 = L0_1.callExport
      L7_2 = "qb-banking"
      L8_2 = "CreateBankStatement"
      L9_2 = A3_2
      L10_2 = "checking"
      L11_2 = math
      L11_2 = L11_2.abs
      L12_2 = A2_2
      L11_2 = L11_2(L12_2)
      L12_2 = L5_2
      L13_2 = L4_2
      L14_2 = "player"
      L6_2, L7_2 = L6_2(L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2)
      L8_2 = L6_2 or L8_2
      L8_2 = L6_2 and false ~= L7_2
      return L8_2
    end
  end
  L6_2 = pcall
  function L7_2()
    local L0_3, L1_3, L2_3, L3_3, L4_3, L5_3, L6_3
    L0_3 = MySQL
    L0_3 = L0_3.insert
    L0_3 = L0_3.await
    L1_3 = "INSERT INTO bank_statements (citizenid, account_name, amount, reason, statement_type) VALUES (?, 'checking', ?, ?, ?)"
    L2_3 = {}
    L3_3 = A0_2
    L4_3 = math
    L4_3 = L4_3.abs
    L5_3 = A2_2
    L4_3 = L4_3(L5_3)
    L5_3 = L5_2
    L6_3 = L4_2
    L2_3[1] = L3_3
    L2_3[2] = L4_3
    L2_3[3] = L5_3
    L2_3[4] = L6_3
    L0_3(L1_3, L2_3)
  end
  L6_2 = L6_2(L7_2)
  return L6_2
end
L9_1.record = L10_1
L6_1(L7_1, L8_1, L9_1)
function L6_1(A0_2)
  local L1_2, L2_2, L3_2, L4_2
  L1_2 = L1_1
  L2_2 = "SELECT id, number, balance FROM pefcl_accounts WHERE ownerIdentifier = ? AND isDefault = 1 AND deletedAt IS NULL LIMIT 1"
  L3_2 = {}
  L4_2 = A0_2
  L3_2[1] = L4_2
  L1_2 = L1_2(L2_2, L3_2)
  L1_2 = L1_2[1]
  return L1_2
end
L7_1 = L0_1.define
L8_1 = "bank"
L9_1 = "pefcl"
L10_1 = {}
L10_1.label = "pefcl"
L11_1 = {}
L12_1 = "pefcl"
L11_1[1] = L12_1
L10_1.resources = L11_1
function L11_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2
  L2_2 = L6_1
  L3_2 = A1_2
  L2_2 = L2_2(L3_2)
  if not L2_2 then
    L3_2 = {}
    L3_2.noAccount = true
    return L3_2
  end
  L3_2 = {}
  L4_2 = L2_2.number
  if nil ~= L4_2 then
    L4_2 = tostring
    L5_2 = L2_2.number
    L4_2 = L4_2(L5_2)
    if L4_2 then
      goto lbl_21
    end
  end
  L4_2 = nil
  ::lbl_21::
  L3_2.iban = L4_2
  return L3_2
end
L10_1.info = L11_1
function L11_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2
  L2_2 = L6_1
  L3_2 = A1_2
  L2_2 = L2_2(L3_2)
  if not L2_2 then
    L3_2 = {}
    return L3_2
  end
  L3_2 = tonumber
  L4_2 = L2_2.id
  L3_2 = L3_2(L4_2)
  L4_2 = {}
  L5_2 = ipairs
  L6_2 = L1_1
  L7_2 = "SELECT id, message, amount, type, toAccountId, fromAccountId, createdAt FROM pefcl_transactions WHERE toAccountId = ? OR fromAccountId = ? ORDER BY id DESC LIMIT 60"
  L8_2 = {}
  L9_2 = L3_2
  L10_2 = L3_2
  L8_2[1] = L9_2
  L8_2[2] = L10_2
  L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2 = L6_2(L7_2, L8_2)
  L5_2, L6_2, L7_2, L8_2 = L5_2(L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2)
  for L9_2, L10_2 in L5_2, L6_2, L7_2, L8_2 do
    L11_2 = math
    L11_2 = L11_2.abs
    L12_2 = L0_1.num
    L13_2 = L10_2.amount
    L12_2 = L12_2(L13_2)
    if not L12_2 then
      L12_2 = 0
    end
    L11_2 = L11_2(L12_2)
    L12_2 = tonumber
    L13_2 = L10_2.fromAccountId
    L12_2 = L12_2(L13_2)
    L12_2 = L12_2 == L3_2
    L13_2 = #L4_2
    L13_2 = L13_2 + 1
    L14_2 = {}
    L15_2 = L10_2.id
    if not L15_2 then
      L15_2 = L9_2
    end
    L14_2.id = L15_2
    L15_2 = tostring
    L16_2 = L10_2.message
    if not L16_2 then
      L16_2 = L10_2.type
      if not L16_2 then
        L16_2 = "Banco"
      end
    end
    L15_2 = L15_2(L16_2)
    L14_2.description = L15_2
    if L12_2 then
      L15_2 = -L11_2
      if L15_2 then
        goto lbl_67
      end
    end
    L15_2 = L11_2
    ::lbl_67::
    L14_2.amount = L15_2
    L15_2 = L10_2.createdAt
    L14_2.created = L15_2
    L4_2[L13_2] = L14_2
  end
  return L4_2
end
L10_1.history = L11_1
function L11_1(A0_2, A1_2, A2_2, A3_2)
  local L4_2, L5_2
  L4_2 = FW
  L4_2 = L4_2.GetPlayerByCid
  L5_2 = A0_2
  L4_2 = L4_2(L5_2)
  L4_2 = nil ~= L4_2
  return L4_2
end
L10_1.record = L11_1
L7_1(L8_1, L9_1, L10_1)
function L7_1(A0_2, A1_2, ...)
  local L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2
  L2_2 = L0_1.callExport
  L3_2 = A0_2
  L4_2 = A1_2
  L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2 = ...
  L2_2, L3_2, L4_2 = L2_2(L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2)
  if not L2_2 then
    L5_2 = error
    L6_2 = "%s:%s failed (%s)"
    L7_2 = L6_2
    L6_2 = L6_2.format
    L8_2 = A0_2
    L9_2 = A1_2
    L10_2 = tostring
    L11_2 = L3_2
    L10_2, L11_2 = L10_2(L11_2)
    L6_2 = L6_2(L7_2, L8_2, L9_2, L10_2, L11_2)
    L7_2 = 0
    L5_2(L6_2, L7_2)
  end
  L5_2 = L3_2
  L6_2 = L4_2
  return L5_2, L6_2
end
L8_1 = L0_1.define
L9_1 = "bank"
L10_1 = "fd_banking"
L11_1 = {}
L11_1.label = "fd_banking"
L12_1 = {}
L13_1 = "fd_banking"
L12_1[1] = L13_1
L11_1.resources = L12_1
L11_1.verified = false
function L12_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2
  L2_2 = L7_1
  L3_2 = "fd_banking"
  L4_2 = "getPersonalAccount"
  L5_2 = A1_2
  L2_2 = L2_2(L3_2, L4_2, L5_2)
  L3_2 = type
  L4_2 = L2_2
  L3_2 = L3_2(L4_2)
  if "table" ~= L3_2 then
    L3_2 = {}
    L3_2.noAccount = true
    return L3_2
  end
  L3_2 = {}
  L4_2 = L2_2.iban
  if nil ~= L4_2 then
    L4_2 = tostring
    L5_2 = L2_2.iban
    L4_2 = L4_2(L5_2)
    if L4_2 then
      goto lbl_26
    end
  end
  L4_2 = nil
  ::lbl_26::
  L3_2.iban = L4_2
  L4_2 = L2_2.is_frozen
  L4_2 = true == L4_2
  L3_2.frozen = L4_2
  return L3_2
end
L11_1.info = L12_1
L8_1(L9_1, L10_1, L11_1)
L8_1 = L0_1.define
L9_1 = "bank"
L10_1 = "qs-banking"
L11_1 = {}
L11_1.label = "qs-banking"
L12_1 = {}
L13_1 = "qs-banking"
L12_1[1] = L13_1
L11_1.resources = L12_1
L11_1.verified = false
function L12_1(A0_2, A1_2, A2_2, A3_2)
  local L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2
  L4_2 = "%s%d"
  L5_2 = L4_2
  L4_2 = L4_2.format
  if A2_2 < 0 then
    L6_2 = "-"
    if L6_2 then
      goto lbl_9
    end
  end
  L6_2 = "+"
  ::lbl_9::
  L7_2 = math
  L7_2 = L7_2.abs
  L8_2 = A2_2
  L7_2, L8_2, L9_2, L10_2, L11_2, L12_2 = L7_2(L8_2)
  L4_2 = L4_2(L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2)
  L5_2 = L0_1.callExport
  L6_2 = "qs-banking"
  L7_2 = "AddTransaction"
  L8_2 = A0_2
  L9_2 = tostring
  L10_2 = A1_2
  L9_2 = L9_2(L10_2)
  L10_2 = L9_2
  L9_2 = L9_2.sub
  L11_2 = 1
  L12_2 = 60
  L9_2 = L9_2(L10_2, L11_2, L12_2)
  L10_2 = "fa-solid fa-mobile-screen"
  L11_2 = L4_2
  L5_2 = L5_2(L6_2, L7_2, L8_2, L9_2, L10_2, L11_2)
  L6_2 = true == L5_2
  return L6_2
end
L11_1.record = L12_1
L8_1(L9_1, L10_1, L11_1)
function L8_1(A0_2)
  local L1_2, L2_2, L3_2, L4_2, L5_2
  L1_2 = L7_1
  L2_2 = "kartik-banking"
  L3_2 = "GetAccountDataByOwner"
  L4_2 = A0_2
  L5_2 = "personal"
  L1_2 = L1_2(L2_2, L3_2, L4_2, L5_2)
  L2_2 = type
  L3_2 = L1_2
  L2_2 = L2_2(L3_2)
  L2_2 = L1_2 or L2_2
  if "table" ~= L2_2 or not L1_2 then
    L2_2 = nil
  end
  return L2_2
end
L9_1 = L0_1.define
L10_1 = "bank"
L11_1 = "kartik-banking"
L12_1 = {}
L12_1.label = "kartik-banking"
L13_1 = {}
L14_1 = "kartik-banking"
L13_1[1] = L14_1
L12_1.resources = L13_1
L12_1.verified = false
function L13_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2
  L2_2 = L8_1
  L3_2 = A1_2
  L2_2 = L2_2(L3_2)
  if not L2_2 then
    L3_2 = {}
    L3_2.noAccount = true
    return L3_2
  end
  L3_2 = {}
  L4_2 = L2_2.accountNumber
  if nil ~= L4_2 then
    L4_2 = tostring
    L5_2 = L2_2.accountNumber
    L4_2 = L4_2(L5_2)
    if L4_2 then
      goto lbl_21
    end
  end
  L4_2 = nil
  ::lbl_21::
  L3_2.iban = L4_2
  L4_2 = tostring
  L5_2 = L2_2.status
  if not L5_2 then
    L5_2 = ""
  end
  L4_2 = L4_2(L5_2)
  L5_2 = L4_2
  L4_2 = L4_2.lower
  L4_2 = L4_2(L5_2)
  L4_2 = "frozen" == L4_2
  L3_2.frozen = L4_2
  return L3_2
end
L12_1.info = L13_1
function L13_1(A0_2, A1_2, A2_2, A3_2)
  local L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2
  L4_2 = L8_1
  L5_2 = A0_2
  L4_2 = L4_2(L5_2)
  if L4_2 then
    L5_2 = L4_2.accountNumber
    if L5_2 then
      goto lbl_11
    end
  end
  L5_2 = false
  do return L5_2 end
  ::lbl_11::
  L5_2 = L0_1.callExport
  L6_2 = "kartik-banking"
  L7_2 = "LogBankTransaction"
  L8_2 = {}
  L9_2 = L4_2.accountNumber
  L8_2.account_number = L9_2
  if A2_2 < 0 then
    L9_2 = "withdraw"
    if L9_2 then
      goto lbl_24
    end
  end
  L9_2 = "deposit"
  ::lbl_24::
  L8_2.type = L9_2
  L9_2 = math
  L9_2 = L9_2.abs
  L10_2 = A2_2
  L9_2 = L9_2(L10_2)
  L8_2.amount = L9_2
  L9_2 = tostring
  L10_2 = A1_2
  L9_2 = L9_2(L10_2)
  L8_2.memo = L9_2
  L5_2 = L5_2(L6_2, L7_2, L8_2)
  L6_2 = true == L5_2
  return L6_2
end
L12_1.record = L13_1
L9_1(L10_1, L11_1, L12_1)
L9_1 = L0_1.define
L10_1 = "bank"
L11_1 = "wasabi_banking"
L12_1 = {}
L12_1.label = "wasabi_banking"
L13_1 = {}
L14_1 = "wasabi_banking"
L13_1[1] = L14_1
L12_1.resources = L13_1
L12_1.verified = false
function L13_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2
  L2_2 = nil
  L3_2 = L7_1
  L4_2 = "wasabi_banking"
  L5_2 = "GetAccountsByPlayer"
  L6_2 = A1_2
  L3_2 = L3_2(L4_2, L5_2, L6_2)
  L4_2 = type
  L5_2 = L3_2
  L4_2 = L4_2(L5_2)
  if "table" == L4_2 then
    L4_2 = ipairs
    L5_2 = L3_2
    L4_2, L5_2, L6_2, L7_2 = L4_2(L5_2)
    for L8_2, L9_2 in L4_2, L5_2, L6_2, L7_2 do
      L10_2 = type
      L11_2 = L9_2
      L10_2 = L10_2(L11_2)
      if "table" == L10_2 then
        L10_2 = tostring
        L11_2 = L9_2.type
        if not L11_2 then
          L11_2 = L9_2.accountType
          if not L11_2 then
            L11_2 = ""
          end
        end
        L10_2 = L10_2(L11_2)
        L11_2 = L10_2
        L10_2 = L10_2.lower
        L10_2 = L10_2(L11_2)
        if "bank" == L10_2 then
          L10_2 = L9_2.iban
          if nil ~= L10_2 then
            L10_2 = tostring
            L11_2 = L9_2.iban
            L10_2 = L10_2(L11_2)
            L2_2 = L10_2
            break
          end
        end
      end
    end
  end
  L4_2 = {}
  L4_2.iban = L2_2
  L5_2 = L7_1
  L6_2 = "wasabi_banking"
  L7_2 = "IsAccountFrozen"
  L8_2 = "bank"
  L9_2 = A1_2
  L5_2 = L5_2(L6_2, L7_2, L8_2, L9_2)
  L5_2 = true == L5_2
  L4_2.frozen = L5_2
  return L4_2
end
L12_1.info = L13_1
function L13_1(A0_2, A1_2, A2_2, A3_2)
  local L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2
  L4_2 = L0_1.callExport
  L5_2 = "wasabi_banking"
  L6_2 = "Transaction"
  L7_2 = A0_2
  L8_2 = tostring
  L9_2 = A1_2
  L8_2 = L8_2(L9_2)
  L9_2 = math
  L9_2 = L9_2.abs
  L10_2 = A2_2
  L9_2 = L9_2(L10_2)
  if A2_2 < 0 then
    L10_2 = "sent"
    if L10_2 then
      goto lbl_18
    end
  end
  L10_2 = "deposit"
  ::lbl_18::
  L11_2 = "personal"
  L4_2 = L4_2(L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2)
  L5_2 = true == L4_2
  return L5_2
end
L12_1.record = L13_1
L9_1(L10_1, L11_1, L12_1)
function L9_1(A0_2)
  local L1_2, L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2
  L1_2 = L7_1
  L2_2 = "crm-banking"
  L3_2 = "getPlayerAccounts"
  L4_2 = A0_2
  L1_2 = L1_2(L2_2, L3_2, L4_2)
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
    L9_2 = type
    L10_2 = L8_2
    L9_2 = L9_2(L10_2)
    if "table" == L9_2 then
      L9_2 = L8_2.crm_iban
      if nil ~= L9_2 then
        L9_2 = tostring
        L10_2 = L8_2.crm_type
        if not L10_2 then
          L10_2 = ""
        end
        L9_2 = L9_2(L10_2)
        L10_2 = L9_2
        L9_2 = L9_2.lower
        L9_2 = L9_2(L10_2)
        L11_2 = L9_2
        L10_2 = L9_2.find
        L12_2 = "saving"
        L13_2 = 1
        L14_2 = true
        L10_2 = L10_2(L11_2, L12_2, L13_2, L14_2)
        if nil == L10_2 then
          L11_2 = L9_2
          L10_2 = L9_2.find
          L12_2 = "shared"
          L13_2 = 1
          L14_2 = true
          L10_2 = L10_2(L11_2, L12_2, L13_2, L14_2)
          if nil == L10_2 then
            return L8_2
          end
        end
        if not L2_2 then
          L2_2 = L8_2
        end
      end
    end
  end
  return L2_2
end
L10_1 = L0_1.define
L11_1 = "bank"
L12_1 = "crm-banking"
L13_1 = {}
L13_1.label = "crm-banking"
L14_1 = {}
L15_1 = "crm-banking"
L14_1[1] = L15_1
L13_1.resources = L14_1
L13_1.verified = false
function L14_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2, L6_2, L7_2
  L2_2 = L9_1
  L3_2 = A1_2
  L2_2 = L2_2(L3_2)
  if not L2_2 then
    L3_2 = {}
    L3_2.noAccount = true
    return L3_2
  end
  L3_2 = {}
  L4_2 = tostring
  L5_2 = L2_2.crm_iban
  L4_2 = L4_2(L5_2)
  L3_2.iban = L4_2
  L4_2 = L7_1
  L5_2 = "crm-banking"
  L6_2 = "isAccountFrozen"
  L7_2 = L2_2.crm_iban
  L4_2 = L4_2(L5_2, L6_2, L7_2)
  L4_2 = true == L4_2
  L3_2.frozen = L4_2
  return L3_2
end
L13_1.info = L14_1
function L14_1(A0_2, A1_2, A2_2, A3_2)
  local L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2
  L4_2 = L9_1
  L5_2 = A0_2
  L4_2 = L4_2(L5_2)
  if not L4_2 then
    L5_2 = false
    return L5_2
  end
  L5_2 = L0_1.callExport
  L6_2 = "crm-banking"
  L7_2 = "addTransaction"
  L8_2 = {}
  if A2_2 < 0 then
    L9_2 = L4_2.crm_iban
    if L9_2 then
      goto lbl_19
    end
  end
  L9_2 = nil
  ::lbl_19::
  L8_2.crm_sender = L9_2
  if A2_2 > 0 then
    L9_2 = L4_2.crm_iban
    if L9_2 then
      goto lbl_26
    end
  end
  L9_2 = nil
  ::lbl_26::
  L8_2.crm_receiver = L9_2
  L9_2 = math
  L9_2 = L9_2.abs
  L10_2 = A2_2
  L9_2 = L9_2(L10_2)
  L8_2.crm_amount = L9_2
  if A2_2 < 0 then
    L9_2 = "crm-withdraw"
    if L9_2 then
      goto lbl_38
    end
  end
  L9_2 = "crm-deposit"
  ::lbl_38::
  L8_2.crm_type = L9_2
  L9_2 = tostring
  L10_2 = A1_2
  L9_2 = L9_2(L10_2)
  L8_2.crm_description = L9_2
  L5_2, L6_2 = L5_2(L6_2, L7_2, L8_2)
  L7_2 = true == L5_2 and false ~= L6_2
  return L7_2
end
L13_1.record = L14_1
L10_1(L11_1, L12_1, L13_1)
L10_1 = L0_1.define
L11_1 = "bank"
L12_1 = "snipe-banking"
L13_1 = {}
L13_1.label = "snipe-banking"
L14_1 = {}
L15_1 = "snipe-banking"
L14_1[1] = L15_1
L13_1.resources = L14_1
L13_1.verified = false
function L14_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2, L6_2
  L2_2 = {}
  L3_2 = L7_1
  L4_2 = "snipe-banking"
  L5_2 = "IsAccountFrozenForIdentifier"
  L6_2 = A1_2
  L3_2 = L3_2(L4_2, L5_2, L6_2)
  L3_2 = true == L3_2
  L2_2.frozen = L3_2
  return L2_2
end
L13_1.info = L14_1
function L14_1(A0_2, A1_2, A2_2, A3_2)
  local L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2
  L4_2 = L0_1.callExport
  L5_2 = "snipe-banking"
  L6_2 = "CreatePersonalTransactions"
  L7_2 = A0_2
  L8_2 = math
  L8_2 = L8_2.abs
  L9_2 = A2_2
  L8_2 = L8_2(L9_2)
  L9_2 = tostring
  L10_2 = A1_2
  L9_2 = L9_2(L10_2)
  if A2_2 < 0 then
    L10_2 = "withdraw"
    if L10_2 then
      goto lbl_18
    end
  end
  L10_2 = "deposit"
  ::lbl_18::
  L11_2 = nil
  L12_2 = false
  L4_2 = L4_2(L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2)
  L5_2 = true == L4_2
  return L5_2
end
L13_1.record = L14_1
L10_1(L11_1, L12_1, L13_1)
L10_1 = L0_1.define
L11_1 = "bank"
L12_1 = "nfs-banking"
L13_1 = {}
L13_1.label = "nfs-banking"
L14_1 = {}
L15_1 = "nfs-banking"
L14_1[1] = L15_1
L13_1.resources = L14_1
L13_1.verified = false
function L14_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2, L6_2
  L2_2 = L7_1
  L3_2 = "nfs-banking"
  L4_2 = "getPlayerMainCardIban"
  L5_2 = A1_2
  L2_2 = L2_2(L3_2, L4_2, L5_2)
  L3_2 = type
  L4_2 = L2_2
  L3_2 = L3_2(L4_2)
  if "string" ~= L3_2 or "" == L2_2 then
    L3_2 = {}
    L3_2.noAccount = true
    return L3_2
  end
  L3_2 = L7_1
  L4_2 = "nfs-banking"
  L5_2 = "getCardByIban"
  L6_2 = L2_2
  L3_2 = L3_2(L4_2, L5_2, L6_2)
  L4_2 = {}
  L4_2.iban = L2_2
  L5_2 = type
  L6_2 = L3_2
  L5_2 = L5_2(L6_2)
  L5_2 = "table" == L5_2
  L4_2.frozen = L5_2
  return L4_2
end
L13_1.info = L14_1
function L14_1(A0_2, A1_2, A2_2, A3_2)
  local L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2
  L4_2 = L7_1
  L5_2 = "nfs-banking"
  L6_2 = "getPlayerMainCardIban"
  L7_2 = A0_2
  L4_2 = L4_2(L5_2, L6_2, L7_2)
  L5_2 = type
  L6_2 = L4_2
  L5_2 = L5_2(L6_2)
  if "string" ~= L5_2 or "" == L4_2 then
    L5_2 = false
    return L5_2
  end
  L5_2 = L0_1.callExport
  L6_2 = "nfs-banking"
  L7_2 = "registerTransaction"
  L8_2 = L4_2
  L9_2 = math
  L9_2 = L9_2.abs
  L10_2 = A2_2
  L9_2 = L9_2(L10_2)
  L10_2 = tostring
  L11_2 = A1_2
  L10_2 = L10_2(L11_2)
  if A2_2 < 0 then
    L11_2 = "send"
    if L11_2 then
      goto lbl_32
    end
  end
  L11_2 = "receive"
  ::lbl_32::
  L12_2 = L0_1.nameOf
  L13_2 = A0_2
  L12_2 = L12_2(L13_2)
  if not L12_2 then
    L12_2 = tostring
    L13_2 = A0_2
    L12_2 = L12_2(L13_2)
  end
  L5_2 = L5_2(L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2)
  L6_2 = true == L5_2
  return L6_2
end
L13_1.record = L14_1
L10_1(L11_1, L12_1, L13_1)
L10_1 = {}
L10_1.DEPOSIT = true
L10_1.TRANSFER_RECEIVE = true
L10_1.PAYCHECK = true
L10_1.SALARY = true
L10_1.INCOME = true
L10_1.RECEIVE = true
L10_1.REFUND = true
function L11_1(A0_2)
  local L1_2, L2_2, L3_2, L4_2, L5_2
  L1_2 = tostring
  L2_2 = A0_2 or L2_2
  if not A0_2 then
    L2_2 = ""
  end
  L1_2 = L1_2(L2_2)
  L2_2 = L1_2
  L1_2 = L1_2.upper
  L1_2 = L1_2(L2_2)
  A0_2 = L1_2
  L1_2 = L10_1
  L1_2 = L1_2[A0_2]
  if L1_2 then
    L1_2 = true
    return L1_2
  end
  L2_2 = A0_2
  L1_2 = A0_2.find
  L3_2 = "RECEIVE"
  L4_2 = 1
  L5_2 = true
  L1_2 = L1_2(L2_2, L3_2, L4_2, L5_2)
  L1_2 = nil ~= L1_2
  return L1_2
end
L12_1 = L0_1.define
L13_1 = "bank"
L14_1 = "esx_banking"
L15_1 = {}
L15_1.label = "esx_banking"
function L16_1()
  local L0_2, L1_2, L2_2
  L0_2 = FW
  L0_2 = L0_2.name
  if "esx" == L0_2 then
    L0_2 = L0_1.started
    L1_2 = "esx_banking"
    L0_2 = L0_2(L1_2)
    if L0_2 then
      goto lbl_12
    end
  end
  L0_2 = false
  do return L0_2 end
  ::lbl_12::
  L0_2 = pcall
  function L1_2()
    local L0_3, L1_3
    L0_3 = exports
    L0_3 = L0_3.esx_banking
    L0_3 = L0_3.logTransaction
    return L0_3
  end
  L0_2, L1_2 = L0_2(L1_2)
  L2_2 = L0_2 or L2_2
  L2_2 = L0_2 and nil ~= L1_2
  return L2_2
end
L15_1.detect = L16_1
function L16_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2
  L2_2 = {}
  L3_2 = ipairs
  L4_2 = L1_1
  L5_2 = "SELECT ID, label, type, amount, time FROM banking WHERE identifier = ? ORDER BY time DESC LIMIT 60"
  L6_2 = {}
  L7_2 = A1_2
  L6_2[1] = L7_2
  L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2 = L4_2(L5_2, L6_2)
  L3_2, L4_2, L5_2, L6_2 = L3_2(L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2)
  for L7_2, L8_2 in L3_2, L4_2, L5_2, L6_2 do
    L9_2 = math
    L9_2 = L9_2.abs
    L10_2 = L0_1.num
    L11_2 = L8_2.amount
    L10_2 = L10_2(L11_2)
    if not L10_2 then
      L10_2 = 0
    end
    L9_2 = L9_2(L10_2)
    L10_2 = L8_2.label
    if nil ~= L10_2 then
      L10_2 = tostring
      L11_2 = L8_2.label
      L10_2 = L10_2(L11_2)
      if "" ~= L10_2 then
        L10_2 = tostring
        L11_2 = L8_2.label
        L10_2 = L10_2(L11_2)
        L11_2 = L10_2
        L10_2 = L10_2.upper
        L10_2 = L10_2(L11_2)
        L11_2 = tostring
        L12_2 = L8_2.type
        if not L12_2 then
          L12_2 = ""
        end
        L11_2 = L11_2(L12_2)
        L12_2 = L11_2
        L11_2 = L11_2.upper
        L11_2 = L11_2(L12_2)
        if L10_2 ~= L11_2 then
          L10_2 = tostring
          L11_2 = L8_2.label
          L10_2 = L10_2(L11_2)
          if L10_2 then
            goto lbl_56
          end
        end
      end
    end
    L10_2 = tostring
    L11_2 = L8_2.type
    if not L11_2 then
      L11_2 = "Banco"
    end
    L10_2 = L10_2(L11_2)
    ::lbl_56::
    L11_2 = #L2_2
    L11_2 = L11_2 + 1
    L12_2 = {}
    L13_2 = L8_2.ID
    if not L13_2 then
      L13_2 = L7_2
    end
    L12_2.id = L13_2
    L12_2.description = L10_2
    L13_2 = L11_1
    L14_2 = L8_2.type
    L13_2 = L13_2(L14_2)
    L13_2 = L9_2 or L13_2
    if not L13_2 or not L9_2 then
      L13_2 = -L9_2
    end
    L12_2.amount = L13_2
    L13_2 = L8_2.time
    L12_2.created = L13_2
    L2_2[L11_2] = L12_2
  end
  return L2_2
end
L15_1.history = L16_1
function L16_1(A0_2, A1_2, A2_2, A3_2)
  local L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2
  if A2_2 < 0 then
    L4_2 = "TRANSFER"
    if L4_2 then
      goto lbl_7
    end
  end
  L4_2 = "TRANSFER_RECEIVE"
  ::lbl_7::
  L5_2 = tostring
  L6_2 = A1_2
  L5_2 = L5_2(L6_2)
  L6_2 = L5_2
  L5_2 = L5_2.gsub
  L7_2 = "[%c\r\n]"
  L8_2 = " "
  L5_2 = L5_2(L6_2, L7_2, L8_2)
  L6_2 = L5_2
  L5_2 = L5_2.sub
  L7_2 = 1
  L8_2 = 80
  L5_2 = L5_2(L6_2, L7_2, L8_2)
  if A3_2 then
    L6_2 = FW
    L6_2 = L6_2.GetPlayer
    L7_2 = A3_2
    L6_2 = L6_2(L7_2)
    if L6_2 then
      goto lbl_27
    end
  end
  L6_2 = nil
  ::lbl_27::
  if L6_2 then
    L7_2 = L6_2.cid
    if L7_2 == A0_2 then
      L7_2 = L0_1.callExport
      L8_2 = "esx_banking"
      L9_2 = "logTransaction"
      L10_2 = A3_2
      L11_2 = L5_2
      L12_2 = L4_2
      L13_2 = math
      L13_2 = L13_2.abs
      L14_2 = A2_2
      L13_2, L14_2 = L13_2(L14_2)
      L7_2 = L7_2(L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2)
      L8_2 = true == L7_2
      return L8_2
    end
  end
  L7_2 = 0
  L8_2 = pcall
  function L9_2()
    local L0_3, L1_3, L2_3, L3_3, L4_3
    L0_3 = MySQL
    L0_3 = L0_3.single
    L0_3 = L0_3.await
    L1_3 = "SELECT accounts FROM users WHERE identifier = ? LIMIT 1"
    L2_3 = {}
    L3_3 = A0_2
    L2_3[1] = L3_3
    L0_3 = L0_3(L1_3, L2_3)
    L1_3 = math
    L1_3 = L1_3.floor
    L2_3 = L0_1.num
    L3_3 = L0_1.decode
    L4_3 = L0_3
    if L0_3 then
      L4_3 = L0_3.accounts
    end
    L3_3 = L3_3(L4_3)
    L3_3 = L3_3.bank
    L2_3 = L2_3(L3_3)
    if not L2_3 then
      L2_3 = 0
    end
    L1_3 = L1_3(L2_3)
    L7_2 = L1_3
  end
  L8_2(L9_2)
  L8_2 = pcall
  function L9_2()
    local L0_3, L1_3, L2_3, L3_3, L4_3, L5_3, L6_3, L7_3, L8_3
    L0_3 = MySQL
    L0_3 = L0_3.insert
    L0_3 = L0_3.await
    L1_3 = "INSERT INTO banking (identifier, label, type, amount, time, balance) VALUES (?, ?, ?, ?, ?, ?)"
    L2_3 = {}
    L3_3 = A0_2
    L4_3 = L5_2
    L5_3 = L4_2
    L6_3 = math
    L6_3 = L6_3.abs
    L7_3 = A2_2
    L6_3 = L6_3(L7_3)
    L7_3 = os
    L7_3 = L7_3.time
    L7_3 = L7_3()
    L7_3 = L7_3 * 1000
    L8_3 = L7_2
    L2_3[1] = L3_3
    L2_3[2] = L4_3
    L2_3[3] = L5_3
    L2_3[4] = L6_3
    L2_3[5] = L7_3
    L2_3[6] = L8_3
    L0_3(L1_3, L2_3)
  end
  L8_2 = L8_2(L9_2)
  return L8_2
end
L15_1.record = L16_1
L12_1(L13_1, L14_1, L15_1)
