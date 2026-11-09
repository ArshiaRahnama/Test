local L0_1, L1_1, L2_1, L3_1, L4_1, L5_1, L6_1, L7_1, L8_1, L9_1, L10_1, L11_1, L12_1, L13_1, L14_1, L15_1, L16_1, L17_1, L18_1, L19_1, L20_1, L21_1, L22_1, L23_1, L24_1, L25_1, L26_1, L27_1, L28_1, L29_1, L30_1, L31_1, L32_1, L33_1, L34_1, L35_1, L36_1, L37_1, L38_1, L39_1, L40_1
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
function L2_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2
  L2_2 = pcall
  function L3_2()
    local L0_3, L1_3, L2_3
    L0_3 = MySQL
    L0_3 = L0_3.update
    L0_3 = L0_3.await
    L1_3 = A0_2
    L2_3 = A1_2
    return L0_3(L1_3, L2_3)
  end
  L2_2, L3_2 = L2_2(L3_2)
  if L2_2 then
    L4_2 = tonumber
    L5_2 = L3_2
    L4_2 = L4_2(L5_2)
    if L4_2 then
      goto lbl_15
    end
    L4_2 = 0
    if L4_2 then
      goto lbl_15
    end
  end
  L4_2 = 0
  ::lbl_15::
  return L4_2
end
function L3_1(A0_2)
  local L1_2, L2_2, L3_2, L4_2
  L1_2 = tostring
  L2_2 = A0_2 or L2_2
  if not A0_2 then
    L2_2 = ""
  end
  L1_2 = L1_2(L2_2)
  A0_2 = L1_2
  if "" == A0_2 then
    L1_2 = "Empresa"
    return L1_2
  end
  L2_2 = A0_2
  L1_2 = A0_2.gsub
  L3_2 = "^%l"
  L4_2 = string
  L4_2 = L4_2.upper
  L1_2 = L1_2(L2_2, L3_2, L4_2)
  return L1_2
end
function L4_1(A0_2, A1_2, A2_2, A3_2)
  local L4_2, L5_2, L6_2, L7_2
  if A0_2 and "" ~= A0_2 then
    L4_2 = FW
    L4_2 = L4_2.AddSocietyMoney
    L5_2 = A0_2
    L6_2 = A2_2
    L7_2 = A3_2 or L7_2
    if not A3_2 then
      L7_2 = "Unique_Phone bill"
    end
    L4_2 = L4_2(L5_2, L6_2, L7_2)
    if L4_2 then
      L4_2 = true
      return L4_2
    end
  end
  if A1_2 and "" ~= A1_2 then
    L4_2 = GiveBank
    L5_2 = A1_2
    L6_2 = A2_2
    L7_2 = A3_2 or L7_2
    if not A3_2 then
      L7_2 = "bill-paid"
    end
    L4_2 = L4_2(L5_2, L6_2, L7_2)
    L4_2 = true == L4_2
    return L4_2
  end
  L4_2 = false
  return L4_2
end
function L5_1(A0_2, A1_2, A2_2, A3_2, A4_2, A5_2, A6_2, A7_2, A8_2)
  local L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2
  L9_2 = FW
  L9_2 = L9_2.GetPlayer
  L10_2 = A0_2
  L9_2 = L9_2(L10_2)
  if not L9_2 then
    L10_2 = false
    L11_2 = "invalid"
    return L10_2, L11_2
  end
  L10_2 = math
  L10_2 = L10_2.floor
  L11_2 = tonumber
  L12_2 = A1_2
  L11_2 = L11_2(L12_2)
  if not L11_2 then
    L11_2 = 0
  end
  L10_2 = L10_2(L11_2)
  A1_2 = L10_2
  if A1_2 <= 0 then
    L10_2 = false
    L11_2 = "invalid"
    return L10_2, L11_2
  end
  L10_2 = L9_2.GetMoney
  L11_2 = "bank"
  L10_2 = L10_2(L11_2)
  if A1_2 > L10_2 then
    L10_2 = false
    L11_2 = "funds"
    return L10_2, L11_2
  end
  L10_2 = L2_1
  L11_2 = A2_2
  L12_2 = A3_2
  L10_2 = L10_2(L11_2, L12_2)
  if 1 ~= L10_2 then
    L10_2 = false
    L11_2 = "invalid"
    return L10_2, L11_2
  end
  L10_2 = L9_2.RemoveMoney
  L11_2 = "bank"
  L12_2 = A1_2
  L13_2 = "bill-"
  L14_2 = tostring
  L15_2 = A8_2 or L15_2
  if not A8_2 then
    L15_2 = "bill"
  end
  L14_2 = L14_2(L15_2)
  L13_2 = L13_2 .. L14_2
  L10_2 = L10_2(L11_2, L12_2, L13_2)
  if not L10_2 then
    if A4_2 then
      L10_2 = pcall
      function L11_2()
        local L0_3, L1_3, L2_3
        L0_3 = MySQL
        L0_3 = L0_3.query
        L0_3 = L0_3.await
        L1_3 = A4_2
        L2_3 = A5_2
        L0_3(L1_3, L2_3)
      end
      L10_2(L11_2)
    end
    L10_2 = false
    L11_2 = "funds"
    return L10_2, L11_2
  end
  L10_2 = L4_1
  L11_2 = A6_2
  L12_2 = A7_2
  L13_2 = A1_2
  L14_2 = "bill-paid"
  L10_2 = L10_2(L11_2, L12_2, L13_2, L14_2)
  if not L10_2 and (A6_2 and "" ~= A6_2 or A7_2 and "" ~= A7_2) then
    L10_2 = print
    L11_2 = "^3[unique_phone]^0 integrations: bill of %d paid by %s but neither the society (%s) nor the sender (%s) could receive it"
    L12_2 = L11_2
    L11_2 = L11_2.format
    L13_2 = A1_2
    L14_2 = tostring
    L15_2 = L9_2.cid
    L14_2 = L14_2(L15_2)
    L15_2 = tostring
    L16_2 = A6_2
    L15_2 = L15_2(L16_2)
    L16_2 = tostring
    L17_2 = A7_2
    L16_2, L17_2 = L16_2(L17_2)
    L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2 = L11_2(L12_2, L13_2, L14_2, L15_2, L16_2, L17_2)
    L10_2(L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2)
  end
  L10_2 = AddTransaction
  if L10_2 then
    L10_2 = AddTransaction
    L11_2 = L9_2.cid
    L12_2 = "Fatura: "
    L13_2 = tostring
    L14_2 = A8_2 or L14_2
    if not A8_2 then
      L14_2 = ""
    end
    L13_2 = L13_2(L14_2)
    L12_2 = L12_2 .. L13_2
    L13_2 = -A1_2
    L10_2(L11_2, L12_2, L13_2)
  end
  L10_2 = true
  return L10_2
end
L6_1 = L0_1.define
L7_1 = "billing"
L8_1 = "esx_billing"
L9_1 = {}
L9_1.label = "esx_billing"
function L10_1()
  local L0_2, L1_2
  L0_2 = L0_1.started
  L1_2 = "esx_billing"
  L0_2 = L0_2(L1_2)
  if L0_2 then
    L0_2 = L0_1.started
    L1_2 = "billing_ui"
    L0_2 = L0_2(L1_2)
    L0_2 = not L0_2
  end
  return L0_2
end
L9_1.detect = L10_1
function L10_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2
  L2_2 = {}
  L3_2 = ipairs
  L4_2 = L1_1
  L5_2 = "SELECT id, sender, target_type, target, label, amount FROM billing WHERE identifier = ? ORDER BY id DESC LIMIT 100"
  L6_2 = {}
  L7_2 = A1_2
  L6_2[1] = L7_2
  L4_2 = L4_2(L5_2, L6_2)
  if not L4_2 then
    L4_2 = {}
  end
  L3_2, L4_2, L5_2, L6_2 = L3_2(L4_2)
  for L7_2, L8_2 in L3_2, L4_2, L5_2, L6_2 do
    L9_2 = L8_2.target_type
    if "society" == L9_2 then
      L9_2 = tostring
      L10_2 = L8_2.target
      if not L10_2 then
        L10_2 = ""
      end
      L9_2 = L9_2(L10_2)
      L10_2 = L9_2
      L9_2 = L9_2.gsub
      L11_2 = "^society_"
      L12_2 = ""
      L9_2 = L9_2(L10_2, L11_2, L12_2)
      if L9_2 then
        goto lbl_33
      end
    end
    L9_2 = nil
    ::lbl_33::
    L10_2 = #L2_2
    L10_2 = L10_2 + 1
    L11_2 = {}
    L12_2 = L8_2.id
    L11_2.id = L12_2
    L12_2 = L8_2.sender
    L11_2.sender = L12_2
    if L9_2 then
      L12_2 = L3_1
      L13_2 = L9_2
      L12_2 = L12_2(L13_2)
      if L12_2 then
        goto lbl_55
      end
    end
    L12_2 = L0_1.nameOf
    L13_2 = L8_2.sender
    L12_2 = L12_2(L13_2)
    if not L12_2 then
      L12_2 = "Fatura"
    end
    ::lbl_55::
    L11_2.sender_name = L12_2
    L11_2.society = L9_2
    L12_2 = L8_2.amount
    L11_2.amount = L12_2
    L12_2 = L8_2.label
    L11_2.reason = L12_2
    L11_2.status = "pending"
    L2_2[L10_2] = L11_2
  end
  return L2_2
end
L9_1.list = L10_1
function L10_1(A0_2, A1_2, A2_2)
  local L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2
  L3_2 = L1_1
  L4_2 = "SELECT * FROM billing WHERE id = ? AND identifier = ? LIMIT 1"
  L5_2 = {}
  L6_2 = A2_2
  L7_2 = A1_2
  L5_2[1] = L6_2
  L5_2[2] = L7_2
  L3_2 = L3_2(L4_2, L5_2)
  if not L3_2 then
    L3_2 = {}
  end
  L3_2 = L3_2[1]
  if not L3_2 then
    L4_2 = false
    L5_2 = "invalid"
    return L4_2, L5_2
  end
  L4_2 = L3_2.target_type
  if "society" == L4_2 then
    L4_2 = tostring
    L5_2 = L3_2.target
    if not L5_2 then
      L5_2 = ""
    end
    L4_2 = L4_2(L5_2)
    L5_2 = L4_2
    L4_2 = L4_2.gsub
    L6_2 = "^society_"
    L7_2 = ""
    L4_2 = L4_2(L5_2, L6_2, L7_2)
    if L4_2 then
      goto lbl_35
    end
  end
  L4_2 = nil
  ::lbl_35::
  L5_2 = L5_1
  L6_2 = A0_2
  L7_2 = L3_2.amount
  L8_2 = "DELETE FROM billing WHERE id = ? AND identifier = ?"
  L9_2 = {}
  L10_2 = L3_2.id
  L11_2 = A1_2
  L9_2[1] = L10_2
  L9_2[2] = L11_2
  L10_2 = "INSERT INTO billing (id, identifier, sender, target_type, target, label, amount) VALUES (?, ?, ?, ?, ?, ?, ?)"
  L11_2 = {}
  L12_2 = L3_2.id
  L13_2 = L3_2.identifier
  L14_2 = L3_2.sender
  L15_2 = L3_2.target_type
  L16_2 = L3_2.target
  L17_2 = L3_2.label
  L18_2 = L3_2.amount
  L11_2[1] = L12_2
  L11_2[2] = L13_2
  L11_2[3] = L14_2
  L11_2[4] = L15_2
  L11_2[5] = L16_2
  L11_2[6] = L17_2
  L11_2[7] = L18_2
  L12_2 = L4_2
  L13_2 = L3_2.sender
  if "server" ~= L13_2 then
    L13_2 = L3_2.sender
    if L13_2 then
      goto lbl_63
    end
  end
  L13_2 = nil
  ::lbl_63::
  L14_2 = L3_2.label
  L5_2, L6_2 = L5_2(L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2)
  if L5_2 then
    L7_2 = TriggerEvent
    L8_2 = "esx_billing:paidBill"
    L9_2 = A0_2
    L10_2 = L3_2.id
    L7_2(L8_2, L9_2, L10_2)
  end
  L7_2 = L5_2
  L8_2 = L6_2
  return L7_2, L8_2
end
L9_1.pay = L10_1
function L10_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2
  L2_2 = {}
  L3_2 = ipairs
  L4_2 = L1_1
  L5_2 = "SELECT id, identifier, target_type, target, label, amount FROM billing WHERE sender = ? ORDER BY id DESC LIMIT 100"
  L6_2 = {}
  L7_2 = A1_2
  L6_2[1] = L7_2
  L4_2 = L4_2(L5_2, L6_2)
  if not L4_2 then
    L4_2 = {}
  end
  L3_2, L4_2, L5_2, L6_2 = L3_2(L4_2)
  for L7_2, L8_2 in L3_2, L4_2, L5_2, L6_2 do
    L9_2 = #L2_2
    L9_2 = L9_2 + 1
    L10_2 = {}
    L11_2 = L8_2.id
    L10_2.id = L11_2
    L11_2 = L8_2.identifier
    L10_2.toCid = L11_2
    L11_2 = L8_2.amount
    L10_2.amount = L11_2
    L11_2 = L8_2.label
    L10_2.reason = L11_2
    L10_2.status = "pending"
    L11_2 = L8_2.target_type
    if "society" == L11_2 then
      L11_2 = tostring
      L12_2 = L8_2.target
      if not L12_2 then
        L12_2 = ""
      end
      L11_2 = L11_2(L12_2)
      L12_2 = L11_2
      L11_2 = L11_2.gsub
      L13_2 = "^society_"
      L14_2 = ""
      L11_2 = L11_2(L12_2, L13_2, L14_2)
      if L11_2 then
        goto lbl_47
      end
    end
    L11_2 = nil
    ::lbl_47::
    L10_2.society = L11_2
    L2_2[L9_2] = L10_2
  end
  return L2_2
end
L9_1.sent = L10_1
function L10_1(A0_2, A1_2, A2_2)
  local L3_2, L4_2, L5_2, L6_2, L7_2
  L3_2 = L2_1
  L4_2 = "DELETE FROM billing WHERE id = ? AND sender = ?"
  L5_2 = {}
  L6_2 = A2_2
  L7_2 = A1_2
  L5_2[1] = L6_2
  L5_2[2] = L7_2
  L3_2 = L3_2(L4_2, L5_2)
  L3_2 = 1 == L3_2
  return L3_2
end
L9_1.cancel = L10_1
L6_1(L7_1, L8_1, L9_1)
L6_1 = {}
L6_1.at = 0
L6_1.ok = false
function L7_1()
  local L0_2, L1_2
  L0_2 = os
  L0_2 = L0_2.time
  L0_2 = L0_2()
  L1_2 = L6_1.at
  L0_2 = L0_2 - L1_2
  L1_2 = 600
  if L0_2 < L1_2 then
    L0_2 = L6_1.ok
    return L0_2
  end
  L0_2 = os
  L0_2 = L0_2.time
  L0_2 = L0_2()
  L6_1.at = L0_2
  L0_2 = L1_1
  L1_2 = "SHOW TABLES LIKE 'phone_invoices'"
  L0_2 = L0_2(L1_2)
  L1_2 = nil ~= L0_2
  L6_1.ok = L1_2
  L1_2 = L6_1.ok
  return L1_2
end
L8_1 = {}
function L9_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2
  L2_2 = {}
  L3_2 = ipairs
  L4_2 = L1_1
  L5_2 = "SELECT * FROM phone_invoices WHERE citizenid = ? ORDER BY id DESC LIMIT 100"
  L6_2 = {}
  L7_2 = A1_2
  L6_2[1] = L7_2
  L4_2 = L4_2(L5_2, L6_2)
  if not L4_2 then
    L4_2 = {}
  end
  L3_2, L4_2, L5_2, L6_2 = L3_2(L4_2)
  for L7_2, L8_2 in L3_2, L4_2, L5_2, L6_2 do
    L9_2 = type
    L10_2 = L8_2.society
    L9_2 = L9_2(L10_2)
    if "string" == L9_2 then
      L9_2 = L8_2.society
      if "" ~= L9_2 then
        L9_2 = L8_2.society
        if L9_2 then
          goto lbl_29
        end
      end
    end
    L9_2 = nil
    ::lbl_29::
    L10_2 = #L2_2
    L10_2 = L10_2 + 1
    L11_2 = {}
    L12_2 = L8_2.id
    L11_2.id = L12_2
    L12_2 = L8_2.sendercitizenid
    L11_2.sender = L12_2
    L12_2 = L8_2.sender
    if not L12_2 then
      if L9_2 then
        L12_2 = L3_1
        L13_2 = L9_2
        L12_2 = L12_2(L13_2)
        if L12_2 then
          goto lbl_49
        end
      end
      L12_2 = "Fatura"
    end
    ::lbl_49::
    L11_2.sender_name = L12_2
    L11_2.society = L9_2
    L12_2 = L8_2.amount
    L11_2.amount = L12_2
    L12_2 = L8_2.reason
    L11_2.reason = L12_2
    L11_2.status = "pending"
    L2_2[L10_2] = L11_2
  end
  return L2_2
end
L8_1.list = L9_1
function L9_1(A0_2, A1_2, A2_2)
  local L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2
  L3_2 = L1_1
  L4_2 = "SELECT * FROM phone_invoices WHERE id = ? AND citizenid = ? LIMIT 1"
  L5_2 = {}
  L6_2 = A2_2
  L7_2 = A1_2
  L5_2[1] = L6_2
  L5_2[2] = L7_2
  L3_2 = L3_2(L4_2, L5_2)
  if not L3_2 then
    L3_2 = {}
  end
  L3_2 = L3_2[1]
  if not L3_2 then
    L4_2 = false
    L5_2 = "invalid"
    return L4_2, L5_2
  end
  L4_2 = type
  L5_2 = L3_2.society
  L4_2 = L4_2(L5_2)
  if "string" == L4_2 then
    L4_2 = L3_2.society
    if "" ~= L4_2 then
      L4_2 = L3_2.society
      if L4_2 then
        goto lbl_31
      end
    end
  end
  L4_2 = nil
  ::lbl_31::
  L5_2 = L5_1
  L6_2 = A0_2
  L7_2 = L3_2.amount
  L8_2 = "DELETE FROM phone_invoices WHERE id = ? AND citizenid = ?"
  L9_2 = {}
  L10_2 = L3_2.id
  L11_2 = A1_2
  L9_2[1] = L10_2
  L9_2[2] = L11_2
  L10_2 = "INSERT INTO phone_invoices (id, citizenid, amount, society, sender, sendercitizenid, candecline) VALUES (?, ?, ?, ?, ?, ?, ?)"
  L11_2 = {}
  L12_2 = L3_2.id
  L13_2 = L3_2.citizenid
  L14_2 = L3_2.amount
  L15_2 = L3_2.society
  L16_2 = L3_2.sender
  L17_2 = L3_2.sendercitizenid
  L18_2 = L3_2.candecline
  if not L18_2 then
    L18_2 = 1
  end
  L11_2[1] = L12_2
  L11_2[2] = L13_2
  L11_2[3] = L14_2
  L11_2[4] = L15_2
  L11_2[5] = L16_2
  L11_2[6] = L17_2
  L11_2[7] = L18_2
  L12_2 = L4_2
  L13_2 = L3_2.sendercitizenid
  L14_2 = L3_2.sender
  L5_2, L6_2 = L5_2(L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2)
  if L5_2 then
    L7_2 = TriggerEvent
    L8_2 = "qb-phone:server:paidInvoice"
    L9_2 = A0_2
    L10_2 = L3_2.id
    L7_2(L8_2, L9_2, L10_2)
  end
  L7_2 = L5_2
  L8_2 = L6_2
  return L7_2, L8_2
end
L8_1.pay = L9_1
function L9_1(A0_2, A1_2, A2_2)
  local L3_2, L4_2, L5_2, L6_2, L7_2
  L3_2 = L2_1
  L4_2 = "DELETE FROM phone_invoices WHERE id = ? AND citizenid = ? AND candecline = 1"
  L5_2 = {}
  L6_2 = A2_2
  L7_2 = A1_2
  L5_2[1] = L6_2
  L5_2[2] = L7_2
  L3_2 = L3_2(L4_2, L5_2)
  if 1 ~= L3_2 then
    L3_2 = false
    return L3_2
  end
  L3_2 = TriggerEvent
  L4_2 = "qb-phone:server:declinedInvoice"
  L5_2 = A0_2
  L6_2 = A2_2
  L3_2(L4_2, L5_2, L6_2)
  L3_2 = true
  return L3_2
end
L8_1.refuse = L9_1
function L9_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2
  L2_2 = {}
  L3_2 = ipairs
  L4_2 = L1_1
  L5_2 = "SELECT * FROM phone_invoices WHERE sendercitizenid = ? ORDER BY id DESC LIMIT 100"
  L6_2 = {}
  L7_2 = A1_2
  L6_2[1] = L7_2
  L4_2 = L4_2(L5_2, L6_2)
  if not L4_2 then
    L4_2 = {}
  end
  L3_2, L4_2, L5_2, L6_2 = L3_2(L4_2)
  for L7_2, L8_2 in L3_2, L4_2, L5_2, L6_2 do
    L9_2 = #L2_2
    L9_2 = L9_2 + 1
    L10_2 = {}
    L11_2 = L8_2.id
    L10_2.id = L11_2
    L11_2 = L8_2.citizenid
    L10_2.toCid = L11_2
    L11_2 = L8_2.amount
    L10_2.amount = L11_2
    L11_2 = L8_2.reason
    L10_2.reason = L11_2
    L10_2.status = "pending"
    L11_2 = L8_2.society
    L10_2.society = L11_2
    L11_2 = L8_2.sender
    L10_2.sender_name = L11_2
    L2_2[L9_2] = L10_2
  end
  return L2_2
end
L8_1.sent = L9_1
function L9_1(A0_2, A1_2, A2_2)
  local L3_2, L4_2, L5_2, L6_2, L7_2
  L3_2 = L2_1
  L4_2 = "DELETE FROM phone_invoices WHERE id = ? AND sendercitizenid = ?"
  L5_2 = {}
  L6_2 = A2_2
  L7_2 = A1_2
  L5_2[1] = L6_2
  L5_2[2] = L7_2
  L3_2 = L3_2(L4_2, L5_2)
  L3_2 = 1 == L3_2
  return L3_2
end
L8_1.cancel = L9_1
function L9_1(A0_2)
  local L1_2, L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2
  L1_2 = {}
  L2_2 = pairs
  L3_2 = L8_1
  L2_2, L3_2, L4_2, L5_2 = L2_2(L3_2)
  for L6_2, L7_2 in L2_2, L3_2, L4_2, L5_2 do
    L1_2[L6_2] = L7_2
  end
  L2_2 = pairs
  L3_2 = A0_2
  L2_2, L3_2, L4_2, L5_2 = L2_2(L3_2)
  for L6_2, L7_2 in L2_2, L3_2, L4_2, L5_2 do
    L1_2[L6_2] = L7_2
  end
  return L1_2
end
L10_1 = L0_1.define
L11_1 = "billing"
L12_1 = "jim-payments"
L13_1 = L9_1
L14_1 = {}
L14_1.label = "jim-payments (phone_invoices)"
function L15_1()
  local L0_2, L1_2
  L0_2 = L0_1.started
  L1_2 = "jim-payments"
  L0_2 = L0_2(L1_2)
  if L0_2 then
    L0_2 = L7_1
    L0_2 = L0_2()
  end
  return L0_2
end
L14_1.detect = L15_1
L13_1, L14_1, L15_1, L16_1, L17_1, L18_1, L19_1, L20_1, L21_1, L22_1, L23_1, L24_1, L25_1, L26_1, L27_1, L28_1, L29_1, L30_1, L31_1, L32_1, L33_1, L34_1, L35_1, L36_1, L37_1, L38_1, L39_1, L40_1 = L13_1(L14_1)
L10_1(L11_1, L12_1, L13_1, L14_1, L15_1, L16_1, L17_1, L18_1, L19_1, L20_1, L21_1, L22_1, L23_1, L24_1, L25_1, L26_1, L27_1, L28_1, L29_1, L30_1, L31_1, L32_1, L33_1, L34_1, L35_1, L36_1, L37_1, L38_1, L39_1, L40_1)
L10_1 = L0_1.define
L11_1 = "billing"
L12_1 = "qb-phone"
L13_1 = L9_1
L14_1 = {}
L14_1.label = "qb-phone invoices (phone_invoices)"
function L15_1()
  local L0_2, L1_2
  L0_2 = L0_1.started
  L1_2 = "qb-phone"
  L0_2 = L0_2(L1_2)
  if L0_2 then
    L0_2 = true
    return L0_2
  end
  L0_2 = FW
  L0_2 = L0_2.name
  if "qb" ~= L0_2 then
    L0_2 = FW
    L0_2 = L0_2.name
  end
  L0_2 = L7_1
  L0_2 = "qbx" == L0_2 and L0_2
  return L0_2
end
L14_1.detect = L15_1
L13_1, L14_1, L15_1, L16_1, L17_1, L18_1, L19_1, L20_1, L21_1, L22_1, L23_1, L24_1, L25_1, L26_1, L27_1, L28_1, L29_1, L30_1, L31_1, L32_1, L33_1, L34_1, L35_1, L36_1, L37_1, L38_1, L39_1, L40_1 = L13_1(L14_1)
L10_1(L11_1, L12_1, L13_1, L14_1, L15_1, L16_1, L17_1, L18_1, L19_1, L20_1, L21_1, L22_1, L23_1, L24_1, L25_1, L26_1, L27_1, L28_1, L29_1, L30_1, L31_1, L32_1, L33_1, L34_1, L35_1, L36_1, L37_1, L38_1, L39_1, L40_1)
L10_1 = {}
L10_1.unpaid = "pending"
L10_1.paid = "paid"
L10_1.autopaid = "paid"
L10_1.cancelled = "cancelled"
function L11_1(A0_2)
  local L1_2, L2_2, L3_2, L4_2
  L1_2 = type
  L2_2 = A0_2
  L1_2 = L1_2(L2_2)
  if "string" ~= L1_2 or "" == A0_2 then
    L1_2 = nil
    return L1_2
  end
  L2_2 = A0_2
  L1_2 = A0_2.gsub
  L3_2 = "^society_"
  L4_2 = ""
  L1_2 = L1_2(L2_2, L3_2, L4_2)
  return L1_2
end
L12_1 = L0_1.define
L13_1 = "billing"
L14_1 = "okokBilling"
L15_1 = {}
L15_1.label = "okokBilling"
L16_1 = {}
L17_1 = "okokBilling"
L16_1[1] = L17_1
L15_1.resources = L16_1
L15_1.verified = false
function L16_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2
  L2_2 = {}
  L3_2 = ipairs
  L4_2 = L1_1
  L5_2 = "SELECT * FROM okokbilling WHERE receiver_identifier = ? ORDER BY id DESC LIMIT 100"
  L6_2 = {}
  L7_2 = A1_2
  L6_2[1] = L7_2
  L4_2 = L4_2(L5_2, L6_2)
  if not L4_2 then
    L4_2 = {}
  end
  L3_2, L4_2, L5_2, L6_2 = L3_2(L4_2)
  for L7_2, L8_2 in L3_2, L4_2, L5_2, L6_2 do
    L9_2 = tonumber
    L10_2 = L8_2.invoice_value
    L9_2 = L9_2(L10_2)
    if not L9_2 then
      L9_2 = 0
    end
    L10_2 = tonumber
    L11_2 = L8_2.fees_amount
    L10_2 = L10_2(L11_2)
    if not L10_2 then
      L10_2 = 0
    end
    L9_2 = L9_2 + L10_2
    L10_2 = #L2_2
    L10_2 = L10_2 + 1
    L11_2 = {}
    L12_2 = L8_2.id
    L11_2.id = L12_2
    L12_2 = L8_2.author_identifier
    L11_2.sender = L12_2
    L12_2 = L8_2.society_name
    if not L12_2 then
      L12_2 = L8_2.author_name
      if not L12_2 then
        L12_2 = "Fatura"
      end
    end
    L11_2.sender_name = L12_2
    L12_2 = L11_1
    L13_2 = L8_2.society
    L12_2 = L12_2(L13_2)
    L11_2.society = L12_2
    L11_2.amount = L9_2
    L12_2 = L8_2.item
    if not L12_2 then
      L12_2 = L8_2.notes
    end
    L11_2.reason = L12_2
    L12_2 = tostring
    L13_2 = L8_2.status
    if not L13_2 then
      L13_2 = ""
    end
    L12_2 = L12_2(L13_2)
    L13_2 = L12_2
    L12_2 = L12_2.lower
    L12_2 = L12_2(L13_2)
    L13_2 = L10_1
    L12_2 = L13_2[L12_2]
    if not L12_2 then
      L12_2 = "pending"
    end
    L11_2.status = L12_2
    L12_2 = L8_2.sent_date
    L11_2.created = L12_2
    L12_2 = L8_2.paid_date
    L11_2.paid_at = L12_2
    L2_2[L10_2] = L11_2
  end
  return L2_2
end
L15_1.list = L16_1
function L16_1(A0_2, A1_2, A2_2)
  local L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2
  L3_2 = L1_1
  L4_2 = "SELECT * FROM okokbilling WHERE id = ? AND receiver_identifier = ? AND status = 'unpaid' LIMIT 1"
  L5_2 = {}
  L6_2 = A2_2
  L7_2 = A1_2
  L5_2[1] = L6_2
  L5_2[2] = L7_2
  L3_2 = L3_2(L4_2, L5_2)
  if not L3_2 then
    L3_2 = {}
  end
  L3_2 = L3_2[1]
  if not L3_2 then
    L4_2 = false
    L5_2 = "invalid"
    return L4_2, L5_2
  end
  L4_2 = tonumber
  L5_2 = L3_2.invoice_value
  L4_2 = L4_2(L5_2)
  if not L4_2 then
    L4_2 = 0
  end
  L5_2 = tonumber
  L6_2 = L3_2.fees_amount
  L5_2 = L5_2(L6_2)
  if not L5_2 then
    L5_2 = 0
  end
  L4_2 = L4_2 + L5_2
  L5_2 = L5_1
  L6_2 = A0_2
  L7_2 = L4_2
  L8_2 = "UPDATE okokbilling SET status = 'paid', paid_date = ? WHERE id = ? AND receiver_identifier = ? AND status = 'unpaid'"
  L9_2 = {}
  L10_2 = os
  L10_2 = L10_2.date
  L11_2 = "%Y-%m-%d %H:%M:%S"
  L10_2 = L10_2(L11_2)
  L11_2 = L3_2.id
  L12_2 = A1_2
  L9_2[1] = L10_2
  L9_2[2] = L11_2
  L9_2[3] = L12_2
  L10_2 = "UPDATE okokbilling SET status = 'unpaid', paid_date = NULL WHERE id = ?"
  L11_2 = {}
  L12_2 = L3_2.id
  L11_2[1] = L12_2
  L12_2 = L11_1
  L13_2 = L3_2.society
  L12_2 = L12_2(L13_2)
  L13_2 = L3_2.author_identifier
  L14_2 = L3_2.society_name
  if not L14_2 then
    L14_2 = L3_2.author_name
  end
  return L5_2(L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2)
end
L15_1.pay = L16_1
function L16_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2
  L2_2 = {}
  L3_2 = ipairs
  L4_2 = L1_1
  L5_2 = "SELECT * FROM okokbilling WHERE author_identifier = ? ORDER BY id DESC LIMIT 100"
  L6_2 = {}
  L7_2 = A1_2
  L6_2[1] = L7_2
  L4_2 = L4_2(L5_2, L6_2)
  if not L4_2 then
    L4_2 = {}
  end
  L3_2, L4_2, L5_2, L6_2 = L3_2(L4_2)
  for L7_2, L8_2 in L3_2, L4_2, L5_2, L6_2 do
    L9_2 = #L2_2
    L9_2 = L9_2 + 1
    L10_2 = {}
    L11_2 = L8_2.id
    L10_2.id = L11_2
    L11_2 = L8_2.receiver_identifier
    L10_2.toCid = L11_2
    L11_2 = L8_2.receiver_name
    L10_2.to_name = L11_2
    L11_2 = tonumber
    L12_2 = L8_2.invoice_value
    L11_2 = L11_2(L12_2)
    if not L11_2 then
      L11_2 = 0
    end
    L12_2 = tonumber
    L13_2 = L8_2.fees_amount
    L12_2 = L12_2(L13_2)
    if not L12_2 then
      L12_2 = 0
    end
    L11_2 = L11_2 + L12_2
    L10_2.amount = L11_2
    L11_2 = L8_2.item
    if not L11_2 then
      L11_2 = L8_2.notes
    end
    L10_2.reason = L11_2
    L11_2 = tostring
    L12_2 = L8_2.status
    if not L12_2 then
      L12_2 = ""
    end
    L11_2 = L11_2(L12_2)
    L12_2 = L11_2
    L11_2 = L11_2.lower
    L11_2 = L11_2(L12_2)
    L12_2 = L10_1
    L11_2 = L12_2[L11_2]
    if not L11_2 then
      L11_2 = "pending"
    end
    L10_2.status = L11_2
    L11_2 = L11_1
    L12_2 = L8_2.society
    L11_2 = L11_2(L12_2)
    L10_2.society = L11_2
    L11_2 = L8_2.sent_date
    L10_2.created = L11_2
    L11_2 = L8_2.paid_date
    L10_2.paid_at = L11_2
    L2_2[L9_2] = L10_2
  end
  return L2_2
end
L15_1.sent = L16_1
function L16_1(A0_2, A1_2, A2_2)
  local L3_2, L4_2, L5_2, L6_2, L7_2
  L3_2 = L2_1
  L4_2 = "UPDATE okokbilling SET status = 'cancelled' WHERE id = ? AND author_identifier = ? AND status = 'unpaid'"
  L5_2 = {}
  L6_2 = A2_2
  L7_2 = A1_2
  L5_2[1] = L6_2
  L5_2[2] = L7_2
  L3_2 = L3_2(L4_2, L5_2)
  L3_2 = 1 == L3_2
  return L3_2
end
L15_1.cancel = L16_1
L12_1(L13_1, L14_1, L15_1)
L12_1 = {}
function L13_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2, L6_2
  L2_2 = L12_1
  L2_2 = L2_2[A0_2]
  if L2_2 then
    L2_2 = false
    L3_2 = "invalid"
    return L2_2, L3_2
  end
  L2_2 = L12_1
  L2_2[A0_2] = true
  L2_2 = table
  L2_2 = L2_2.pack
  L3_2 = pcall
  L4_2 = A1_2
  L3_2, L4_2, L5_2, L6_2 = L3_2(L4_2)
  L2_2 = L2_2(L3_2, L4_2, L5_2, L6_2)
  L3_2 = L12_1
  L3_2[A0_2] = nil
  L3_2 = L2_2[1]
  if not L3_2 then
    L3_2 = error
    L4_2 = L2_2[2]
    L5_2 = 0
    L3_2(L4_2, L5_2)
  end
  L3_2 = table
  L3_2 = L3_2.unpack
  L4_2 = L2_2
  L5_2 = 2
  L6_2 = L2_2.n
  return L3_2(L4_2, L5_2, L6_2)
end
function L14_1(A0_2, A1_2, ...)
  local L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2
  L2_2 = table
  L2_2 = L2_2.pack
  L3_2 = L0_1.callExport
  L4_2 = A0_2
  L5_2 = A1_2
  L6_2, L7_2, L8_2, L9_2 = ...
  L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2 = L3_2(L4_2, L5_2, L6_2, L7_2, L8_2, L9_2)
  L2_2 = L2_2(L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2)
  L3_2 = L2_2[1]
  if not L3_2 then
    L3_2 = error
    L4_2 = "%s:%s %s"
    L5_2 = L4_2
    L4_2 = L4_2.format
    L6_2 = A0_2
    L7_2 = A1_2
    L8_2 = tostring
    L9_2 = L2_2[2]
    L8_2, L9_2 = L8_2(L9_2)
    L4_2 = L4_2(L5_2, L6_2, L7_2, L8_2, L9_2)
    L5_2 = 0
    L3_2(L4_2, L5_2)
  end
  L3_2 = table
  L3_2 = L3_2.unpack
  L4_2 = L2_2
  L5_2 = 2
  L6_2 = L2_2.n
  return L3_2(L4_2, L5_2, L6_2)
end
function L15_1(A0_2)
  local L1_2, L2_2, L3_2, L4_2
  L1_2 = FW
  L1_2 = L1_2.GetPlayer
  L2_2 = A0_2
  L1_2 = L1_2(L2_2)
  L2_2 = L1_2
  if L1_2 then
    L3_2 = L1_2.GetMoney
    L4_2 = "bank"
    L3_2 = L3_2(L4_2)
    if L3_2 then
      goto lbl_14
    end
  end
  L3_2 = 0
  ::lbl_14::
  return L2_2, L3_2
end
function L16_1(A0_2, A1_2, A2_2)
  local L3_2, L4_2, L5_2, L6_2, L7_2
  L3_2 = AddTransaction
  if L3_2 then
    L3_2 = L0_1.started
    L4_2 = "apex_banking"
    L3_2 = L3_2(L4_2)
    if not L3_2 then
      L3_2 = AddTransaction
      L4_2 = A0_2
      L5_2 = "Fatura: "
      L6_2 = tostring
      L7_2 = A1_2 or L7_2
      if not A1_2 then
        L7_2 = ""
      end
      L6_2 = L6_2(L7_2)
      L5_2 = L5_2 .. L6_2
      L6_2 = math
      L6_2 = L6_2.floor
      L7_2 = A2_2
      L6_2 = L6_2(L7_2)
      L6_2 = -L6_2
      L3_2(L4_2, L5_2, L6_2)
    end
  end
end
L17_1 = {}
L17_1.no_funds = true
L17_1.insufficient_funds = true
L17_1["insufficient funds"] = true
L17_1.funds = true
L17_1.no_money = true
L18_1 = {}
L18_1.sent = "pending"
L18_1.paid = "paid"
L18_1.declined = "refused"
L18_1.cancelled = "cancelled"
L18_1.expired = "cancelled"
function L19_1(A0_2)
  local L1_2, L2_2, L3_2, L4_2, L5_2
  L1_2 = A0_2
  L2_2 = "_invoices"
  L1_2 = L1_2 .. L2_2
  function L2_2(A0_3)
    local L1_3, L2_3, L3_3, L4_3, L5_3
    L1_3 = tostring
    L2_3 = A0_3.status
    if not L2_3 then
      L2_3 = ""
    end
    L1_3 = L1_3(L2_3)
    L2_3 = L18_1
    L1_3 = L2_3[L1_3]
    if not L1_3 then
      L2_3 = nil
      return L2_3
    end
    L2_3 = tonumber
    L3_3 = A0_3.paid_at
    L2_3 = L2_3(L3_3)
    L3_3 = {}
    L4_3 = A0_3.id
    L3_3.id = L4_3
    L4_3 = A0_3.issued_by_id
    L3_3.sender = L4_3
    L4_3 = A0_3.issuer_name
    if not L4_3 then
      L4_3 = "Fatura"
    end
    L3_3.sender_name = L4_3
    L4_3 = A0_3.issuer_type
    if "society" == L4_3 then
      L4_3 = A0_3.issuer_job
      if L4_3 then
        goto lbl_34
      end
    end
    L4_3 = nil
    ::lbl_34::
    L3_3.society = L4_3
    L4_3 = tonumber
    L5_3 = A0_3.total
    L4_3 = L4_3(L5_3)
    if not L4_3 then
      L4_3 = 0
    end
    L3_3.amount = L4_3
    L4_3 = A0_3.title
    L3_3.reason = L4_3
    L3_3.status = L1_3
    L4_3 = A0_3.created_at
    L3_3.created = L4_3
    L4_3 = L2_3 or L4_3
    if not (L2_3 and L2_3 > 0) or not L2_3 then
      L4_3 = nil
    end
    L3_3.paid_at = L4_3
    L4_3 = A0_3.recipient_id
    L3_3.toCid = L4_3
    L4_3 = A0_3.recipient_name
    L3_3.to_name = L4_3
    return L3_3
  end
  L3_2 = {}
  L3_2.label = A0_2
  L4_2 = {}
  L5_2 = A0_2
  L4_2[1] = L5_2
  L3_2.resources = L4_2
  function L4_2(A0_3, A1_3)
    local L2_3, L3_3, L4_3, L5_3, L6_3, L7_3, L8_3, L9_3, L10_3
    L2_3 = {}
    L3_3 = ipairs
    L4_3 = L14_1
    L5_3 = A0_2
    L6_3 = "ListReceivedFor"
    L7_3 = A0_3
    L4_3 = L4_3(L5_3, L6_3, L7_3)
    if not L4_3 then
      L4_3 = {}
    end
    L3_3, L4_3, L5_3, L6_3 = L3_3(L4_3)
    for L7_3, L8_3 in L3_3, L4_3, L5_3, L6_3 do
      L9_3 = type
      L10_3 = L8_3
      L9_3 = L9_3(L10_3)
      if "table" == L9_3 then
        L9_3 = L8_3.recipient_type
        if "society" ~= L9_3 then
          L9_3 = L2_2
          L10_3 = L8_3
          L9_3 = L9_3(L10_3)
          if L9_3 then
            L10_3 = #L2_3
            L10_3 = L10_3 + 1
            L2_3[L10_3] = L9_3
          end
        end
      end
    end
    return L2_3
  end
  L3_2.list = L4_2
  function L4_2(A0_3, A1_3, A2_3)
    local L3_3, L4_3, L5_3
    L3_3 = tonumber
    L4_3 = A2_3
    L3_3 = L3_3(L4_3)
    A2_3 = L3_3
    if not A2_3 then
      L3_3 = false
      L4_3 = "invalid"
      return L3_3, L4_3
    end
    L3_3 = L13_1
    L4_3 = A0_2
    L5_3 = A2_3
    L4_3 = L4_3 .. L5_3
    function L5_3()
      local L0_4, L1_4, L2_4, L3_4, L4_4, L5_4, L6_4, L7_4, L8_4, L9_4
      L0_4 = L14_1
      L1_4 = A0_2
      L2_4 = "GetInvoice"
      L3_4 = A2_3
      L0_4 = L0_4(L1_4, L2_4, L3_4)
      L1_4 = type
      L2_4 = L0_4
      L1_4 = L1_4(L2_4)
      if "table" == L1_4 then
        L1_4 = L0_4.status
        if "sent" == L1_4 then
          L1_4 = L0_4.recipient_type
          if "society" ~= L1_4 then
            L1_4 = tostring
            L2_4 = L0_4.recipient_id
            L1_4 = L1_4(L2_4)
            L2_4 = tostring
            L3_4 = A1_3
            L2_4 = L2_4(L3_4)
            if L1_4 == L2_4 then
              goto lbl_28
            end
          end
        end
      end
      L1_4 = false
      L2_4 = "invalid"
      do return L1_4, L2_4 end
      ::lbl_28::
      L1_4 = tonumber
      L2_4 = L0_4.total
      L1_4 = L1_4(L2_4)
      if not L1_4 then
        L1_4 = 0
      end
      L2_4 = L15_1
      L3_4 = A0_3
      L2_4, L3_4 = L2_4(L3_4)
      if not L2_4 then
        L4_4 = false
        L5_4 = "invalid"
        return L4_4, L5_4
      end
      if L1_4 > L3_4 then
        L4_4 = false
        L5_4 = "funds"
        return L4_4, L5_4
      end
      L4_4 = L14_1
      L5_4 = A0_2
      L6_4 = "PayInvoice"
      L7_4 = A0_3
      L8_4 = A2_3
      L9_4 = "bank"
      L4_4, L5_4 = L4_4(L5_4, L6_4, L7_4, L8_4, L9_4)
      if not L4_4 then
        L6_4 = false
        L7_4 = tostring
        L8_4 = L5_4
        L7_4 = L7_4(L8_4)
        L8_4 = L17_1
        L7_4 = L8_4[L7_4]
        if L7_4 then
          L7_4 = "funds"
          if L7_4 then
            goto lbl_68
          end
        end
        L7_4 = "invalid"
        ::lbl_68::
        return L6_4, L7_4
      end
      L6_4 = L16_1
      L7_4 = A1_3
      L8_4 = L0_4.issuer_name
      if not L8_4 then
        L8_4 = L0_4.title
      end
      L9_4 = L1_4
      L6_4(L7_4, L8_4, L9_4)
      L6_4 = true
      return L6_4
    end
    return L3_3(L4_3, L5_3)
  end
  L3_2.pay = L4_2
  function L4_2(A0_3, A1_3, A2_3)
    local L3_3, L4_3, L5_3, L6_3, L7_3
    L3_3 = tonumber
    L4_3 = A2_3
    L3_3 = L3_3(L4_3)
    A2_3 = L3_3
    if not A2_3 then
      L3_3 = false
      return L3_3
    end
    L3_3 = L14_1
    L4_3 = A0_2
    L5_3 = "DeclineInvoice"
    L6_3 = A0_3
    L7_3 = A2_3
    L3_3 = L3_3(L4_3, L5_3, L6_3, L7_3)
    L3_3 = true == L3_3
    return L3_3
  end
  L3_2.refuse = L4_2
  function L4_2(A0_3, A1_3)
    local L2_3, L3_3, L4_3, L5_3, L6_3, L7_3, L8_3, L9_3, L10_3
    L2_3 = {}
    L3_3 = ipairs
    L4_3 = L1_1
    L5_3 = "SELECT * FROM %s WHERE issued_by_id = ? ORDER BY id DESC LIMIT 100"
    L6_3 = L5_3
    L5_3 = L5_3.format
    L7_3 = L1_2
    L5_3 = L5_3(L6_3, L7_3)
    L6_3 = {}
    L7_3 = A1_3
    L6_3[1] = L7_3
    L4_3, L5_3, L6_3, L7_3, L8_3, L9_3, L10_3 = L4_3(L5_3, L6_3)
    L3_3, L4_3, L5_3, L6_3 = L3_3(L4_3, L5_3, L6_3, L7_3, L8_3, L9_3, L10_3)
    for L7_3, L8_3 in L3_3, L4_3, L5_3, L6_3 do
      L9_3 = L2_2
      L10_3 = L8_3
      L9_3 = L9_3(L10_3)
      if L9_3 then
        L10_3 = L8_3.recipient_type
        if "society" ~= L10_3 then
          L10_3 = #L2_3
          L10_3 = L10_3 + 1
          L2_3[L10_3] = L9_3
        end
      end
    end
    return L2_3
  end
  L3_2.sent = L4_2
  function L4_2(A0_3, A1_3, A2_3)
    local L3_3, L4_3, L5_3, L6_3, L7_3
    L3_3 = tonumber
    L4_3 = A2_3
    L3_3 = L3_3(L4_3)
    A2_3 = L3_3
    if not A2_3 then
      L3_3 = false
      return L3_3
    end
    L3_3 = L14_1
    L4_3 = A0_2
    L5_3 = "CancelInvoice"
    L6_3 = A0_3
    L7_3 = A2_3
    L3_3 = L3_3(L4_3, L5_3, L6_3, L7_3)
    L3_3 = true == L3_3
    return L3_3
  end
  L3_2.cancel = L4_2
  return L3_2
end
L20_1 = L0_1.define
L21_1 = "billing"
L22_1 = "apex_billing"
L23_1 = L19_1
L24_1 = "apex_billing"
L23_1, L24_1, L25_1, L26_1, L27_1, L28_1, L29_1, L30_1, L31_1, L32_1, L33_1, L34_1, L35_1, L36_1, L37_1, L38_1, L39_1, L40_1 = L23_1(L24_1)
L20_1(L21_1, L22_1, L23_1, L24_1, L25_1, L26_1, L27_1, L28_1, L29_1, L30_1, L31_1, L32_1, L33_1, L34_1, L35_1, L36_1, L37_1, L38_1, L39_1, L40_1)
L20_1 = L0_1.define
L21_1 = "billing"
L22_1 = "elevate_billing"
L23_1 = L19_1
L24_1 = "elevate_billing"
L23_1, L24_1, L25_1, L26_1, L27_1, L28_1, L29_1, L30_1, L31_1, L32_1, L33_1, L34_1, L35_1, L36_1, L37_1, L38_1, L39_1, L40_1 = L23_1(L24_1)
L20_1(L21_1, L22_1, L23_1, L24_1, L25_1, L26_1, L27_1, L28_1, L29_1, L30_1, L31_1, L32_1, L33_1, L34_1, L35_1, L36_1, L37_1, L38_1, L39_1, L40_1)
L20_1 = {}
L20_1.unpaid = "pending"
L20_1.overdue = "pending"
L20_1.paid = "paid"
L20_1.cancelled = "cancelled"
function L21_1(A0_2)
  local L1_2, L2_2, L3_2
  L1_2 = {}
  L2_2 = A0_2.reference_id
  L1_2.id = L2_2
  L2_2 = A0_2.author_identifier
  L1_2.sender = L2_2
  L2_2 = A0_2.author_name
  if not L2_2 then
    L2_2 = "Fatura"
  end
  L1_2.sender_name = L2_2
  L2_2 = tonumber
  L3_2 = A0_2.total_amount
  L2_2 = L2_2(L3_2)
  if not L2_2 then
    L2_2 = tonumber
    L3_2 = A0_2.amount
    L2_2 = L2_2(L3_2)
    if not L2_2 then
      L2_2 = 0
    end
  end
  L1_2.amount = L2_2
  L2_2 = A0_2.reason
  L1_2.reason = L2_2
  L2_2 = tostring
  L3_2 = A0_2.status
  if not L3_2 then
    L3_2 = ""
  end
  L2_2 = L2_2(L3_2)
  L3_2 = L2_2
  L2_2 = L2_2.lower
  L2_2 = L2_2(L3_2)
  L3_2 = L20_1
  L2_2 = L3_2[L2_2]
  if not L2_2 then
    L2_2 = "pending"
  end
  L1_2.status = L2_2
  L2_2 = A0_2.sent_date
  L1_2.created = L2_2
  L2_2 = A0_2.paid_date
  L1_2.paid_at = L2_2
  L2_2 = A0_2.receiver_identifier
  L1_2.toCid = L2_2
  L2_2 = A0_2.receiver_name
  L1_2.to_name = L2_2
  return L1_2
end
L22_1 = L0_1.define
L23_1 = "billing"
L24_1 = "wasabi_billing"
L25_1 = {}
L25_1.label = "wasabi_billing"
L26_1 = {}
L27_1 = "wasabi_billing"
L26_1[1] = L27_1
L25_1.resources = L26_1
L25_1.verified = false
function L26_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2
  L2_2 = {}
  L3_2 = ipairs
  L4_2 = L14_1
  L5_2 = "wasabi_billing"
  L6_2 = "GetInvoicesByIdentifier"
  L7_2 = A1_2
  L4_2 = L4_2(L5_2, L6_2, L7_2)
  if not L4_2 then
    L4_2 = {}
  end
  L3_2, L4_2, L5_2, L6_2 = L3_2(L4_2)
  for L7_2, L8_2 in L3_2, L4_2, L5_2, L6_2 do
    L9_2 = type
    L10_2 = L8_2
    L9_2 = L9_2(L10_2)
    if "table" == L9_2 then
      L9_2 = L8_2.reference_id
      if L9_2 then
        L9_2 = tostring
        L10_2 = L8_2.receiver_identifier
        L9_2 = L9_2(L10_2)
        L10_2 = tostring
        L11_2 = A1_2
        L10_2 = L10_2(L11_2)
        if L9_2 == L10_2 then
          L9_2 = #L2_2
          L9_2 = L9_2 + 1
          L10_2 = L21_1
          L11_2 = L8_2
          L10_2 = L10_2(L11_2)
          L2_2[L9_2] = L10_2
        end
      end
    end
  end
  return L2_2
end
L25_1.list = L26_1
function L26_1(A0_2, A1_2, A2_2)
  local L3_2, L4_2, L5_2
  L3_2 = tostring
  L4_2 = A2_2 or L4_2
  if not A2_2 then
    L4_2 = ""
  end
  L3_2 = L3_2(L4_2)
  A2_2 = L3_2
  L3_2 = L13_1
  L4_2 = "wasabi"
  L5_2 = A2_2
  L4_2 = L4_2 .. L5_2
  function L5_2()
    local L0_3, L1_3, L2_3, L3_3, L4_3, L5_3, L6_3, L7_3, L8_3, L9_3, L10_3
    L0_3 = L14_1
    L1_3 = "wasabi_billing"
    L2_3 = "GetInvoice"
    L3_3 = A2_2
    L0_3 = L0_3(L1_3, L2_3, L3_3)
    L1_3 = type
    L2_3 = L0_3
    L1_3 = L1_3(L2_3)
    if "table" == L1_3 then
      L1_3 = tostring
      L2_3 = L0_3.receiver_identifier
      L1_3 = L1_3(L2_3)
      L2_3 = tostring
      L3_3 = A1_2
      L2_3 = L2_3(L3_3)
      if L1_3 == L2_3 then
        goto lbl_22
      end
    end
    L1_3 = false
    L2_3 = "invalid"
    do return L1_3, L2_3 end
    ::lbl_22::
    L1_3 = tostring
    L2_3 = L0_3.status
    if not L2_3 then
      L2_3 = ""
    end
    L1_3 = L1_3(L2_3)
    L2_3 = L1_3
    L1_3 = L1_3.lower
    L1_3 = L1_3(L2_3)
    if "unpaid" ~= L1_3 and "overdue" ~= L1_3 then
      L2_3 = false
      L3_3 = "invalid"
      return L2_3, L3_3
    end
    L2_3 = tonumber
    L3_3 = L0_3.total_amount
    L2_3 = L2_3(L3_3)
    if not L2_3 then
      L2_3 = tonumber
      L3_3 = L0_3.amount
      L2_3 = L2_3(L3_3)
      if not L2_3 then
        L2_3 = 0
      end
    end
    L3_3 = L15_1
    L4_3 = A0_2
    L3_3, L4_3 = L3_3(L4_3)
    if not L3_3 then
      L5_3 = false
      L6_3 = "invalid"
      return L5_3, L6_3
    end
    if L2_3 > L4_3 then
      L5_3 = false
      L6_3 = "funds"
      return L5_3, L6_3
    end
    L5_3 = L14_1
    L6_3 = "wasabi_billing"
    L7_3 = "PayInvoiceByReference"
    L8_3 = A0_2
    L9_3 = A2_2
    L10_3 = "bank"
    L5_3 = L5_3(L6_3, L7_3, L8_3, L9_3, L10_3)
    if true ~= L5_3 then
      L5_3 = false
      L6_3 = "invalid"
      return L5_3, L6_3
    end
    L5_3 = L16_1
    L6_3 = A1_2
    L7_3 = L0_3.author_name
    if not L7_3 then
      L7_3 = L0_3.reason
    end
    L8_3 = L2_3
    L5_3(L6_3, L7_3, L8_3)
    L5_3 = true
    return L5_3
  end
  return L3_2(L4_2, L5_2)
end
L25_1.pay = L26_1
function L26_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2
  L2_2 = {}
  L3_2 = ipairs
  L4_2 = L14_1
  L5_2 = "wasabi_billing"
  L6_2 = "GetInvoicesByIdentifier"
  L7_2 = A1_2
  L4_2 = L4_2(L5_2, L6_2, L7_2)
  if not L4_2 then
    L4_2 = {}
  end
  L3_2, L4_2, L5_2, L6_2 = L3_2(L4_2)
  for L7_2, L8_2 in L3_2, L4_2, L5_2, L6_2 do
    L9_2 = type
    L10_2 = L8_2
    L9_2 = L9_2(L10_2)
    if "table" == L9_2 then
      L9_2 = L8_2.reference_id
      if L9_2 then
        L9_2 = tostring
        L10_2 = L8_2.receiver_identifier
        L9_2 = L9_2(L10_2)
        L10_2 = tostring
        L11_2 = A1_2
        L10_2 = L10_2(L11_2)
        if L9_2 ~= L10_2 then
          L9_2 = tostring
          L10_2 = L8_2.author_identifier
          L9_2 = L9_2(L10_2)
          L10_2 = tostring
          L11_2 = A1_2
          L10_2 = L10_2(L11_2)
          if L9_2 ~= L10_2 then
            L9_2 = tostring
            L10_2 = L8_2.invoicer_identifier
            L9_2 = L9_2(L10_2)
            L10_2 = tostring
            L11_2 = A1_2
            L10_2 = L10_2(L11_2)
            if L9_2 ~= L10_2 then
              goto lbl_54
            end
          end
          L9_2 = #L2_2
          L9_2 = L9_2 + 1
          L10_2 = L21_1
          L11_2 = L8_2
          L10_2 = L10_2(L11_2)
          L2_2[L9_2] = L10_2
        end
      end
    end
    ::lbl_54::
  end
  return L2_2
end
L25_1.sent = L26_1
function L26_1(A0_2, A1_2, A2_2)
  local L3_2, L4_2, L5_2, L6_2, L7_2, L8_2
  L3_2 = L14_1
  L4_2 = "wasabi_billing"
  L5_2 = "CancelInvoice"
  L6_2 = A0_2
  L7_2 = tostring
  L8_2 = A2_2 or L8_2
  if not A2_2 then
    L8_2 = ""
  end
  L7_2, L8_2 = L7_2(L8_2)
  L3_2 = L3_2(L4_2, L5_2, L6_2, L7_2, L8_2)
  L3_2 = true == L3_2
  return L3_2
end
L25_1.cancel = L26_1
L22_1(L23_1, L24_1, L25_1)
L22_1 = {}
L22_1.outstanding = "pending"
L22_1.paid = "paid"
L22_1.cancelled = "cancelled"
function L23_1(A0_2)
  local L1_2, L2_2
  L1_2 = type
  L2_2 = A0_2
  L1_2 = L1_2(L2_2)
  if "table" == L1_2 then
    L1_2 = A0_2.success
    if true == L1_2 then
      goto lbl_11
    end
  end
  L1_2 = nil
  do return L1_2 end
  ::lbl_11::
  L1_2 = A0_2.data
  return L1_2
end
function L24_1(A0_2)
  local L1_2, L2_2, L3_2
  L1_2 = {}
  L2_2 = A0_2.id
  L1_2.id = L2_2
  L2_2 = A0_2.issuer_id
  L1_2.sender = L2_2
  L2_2 = A0_2.issuer_name_snapshot
  if not L2_2 then
    L2_2 = "Fatura"
  end
  L1_2.sender_name = L2_2
  L2_2 = A0_2.issuer_type
  if "business" == L2_2 then
    L2_2 = A0_2.issuer_job
    if L2_2 then
      goto lbl_19
    end
  end
  L2_2 = nil
  ::lbl_19::
  L1_2.society = L2_2
  L2_2 = tonumber
  L3_2 = A0_2.amount
  L2_2 = L2_2(L3_2)
  if not L2_2 then
    L2_2 = 0
  end
  L1_2.amount = L2_2
  L2_2 = A0_2.reason
  L1_2.reason = L2_2
  L2_2 = tostring
  L3_2 = A0_2.status
  if not L3_2 then
    L3_2 = ""
  end
  L2_2 = L2_2(L3_2)
  L3_2 = L22_1
  L2_2 = L3_2[L2_2]
  if not L2_2 then
    L2_2 = "pending"
  end
  L1_2.status = L2_2
  L2_2 = A0_2.created_at
  L1_2.created = L2_2
  L2_2 = A0_2.paid_at
  L1_2.paid_at = L2_2
  L2_2 = A0_2.recipient_id
  L1_2.toCid = L2_2
  L2_2 = A0_2.recipient_name_snapshot
  L1_2.to_name = L2_2
  return L1_2
end
L25_1 = L0_1.define
L26_1 = "billing"
L27_1 = "bs_billing"
L28_1 = {}
L28_1.label = "bs_billing"
L29_1 = {}
L30_1 = "bs_billing"
L29_1[1] = L30_1
L28_1.resources = L29_1
function L29_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2
  L2_2 = {}
  L3_2 = ipairs
  L4_2 = L23_1
  L5_2 = L14_1
  L6_2 = "bs_billing"
  L7_2 = "GetBillHistoryBySource"
  L8_2 = A0_2
  L9_2 = 100
  L10_2 = 0
  L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2 = L5_2(L6_2, L7_2, L8_2, L9_2, L10_2)
  L4_2 = L4_2(L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2)
  if not L4_2 then
    L4_2 = {}
  end
  L3_2, L4_2, L5_2, L6_2 = L3_2(L4_2)
  for L7_2, L8_2 in L3_2, L4_2, L5_2, L6_2 do
    L9_2 = type
    L10_2 = L8_2
    L9_2 = L9_2(L10_2)
    if "table" == L9_2 then
      L9_2 = L8_2.id
      if L9_2 then
        L9_2 = #L2_2
        L9_2 = L9_2 + 1
        L10_2 = L24_1
        L11_2 = L8_2
        L10_2 = L10_2(L11_2)
        L2_2[L9_2] = L10_2
      end
    end
  end
  return L2_2
end
L28_1.list = L29_1
function L29_1(A0_2, A1_2, A2_2)
  local L3_2, L4_2, L5_2
  L3_2 = tonumber
  L4_2 = A2_2
  L3_2 = L3_2(L4_2)
  A2_2 = L3_2
  if not A2_2 then
    L3_2 = false
    L4_2 = "invalid"
    return L3_2, L4_2
  end
  L3_2 = L13_1
  L4_2 = "bs"
  L5_2 = A2_2
  L4_2 = L4_2 .. L5_2
  function L5_2()
    local L0_3, L1_3, L2_3, L3_3, L4_3, L5_3, L6_3
    L0_3 = L23_1
    L1_3 = L14_1
    L2_3 = "bs_billing"
    L3_3 = "GetBillById"
    L4_3 = A2_2
    L1_3, L2_3, L3_3, L4_3, L5_3, L6_3 = L1_3(L2_3, L3_3, L4_3)
    L0_3 = L0_3(L1_3, L2_3, L3_3, L4_3, L5_3, L6_3)
    L1_3 = type
    L2_3 = L0_3
    L1_3 = L1_3(L2_3)
    if "table" == L1_3 then
      L1_3 = L0_3.status
      if "outstanding" == L1_3 then
        L1_3 = tostring
        L2_3 = L0_3.recipient_id
        L1_3 = L1_3(L2_3)
        L2_3 = tostring
        L3_3 = A1_2
        L2_3 = L2_3(L3_3)
        if L1_3 == L2_3 then
          goto lbl_27
        end
      end
    end
    L1_3 = false
    L2_3 = "invalid"
    do return L1_3, L2_3 end
    ::lbl_27::
    L1_3 = L14_1
    L2_3 = "bs_billing"
    L3_3 = "PayBill"
    L4_3 = A0_2
    L5_3 = A2_2
    L1_3 = L1_3(L2_3, L3_3, L4_3, L5_3)
    L2_3 = type
    L3_3 = L1_3
    L2_3 = L2_3(L3_3)
    if "table" == L2_3 then
      L2_3 = L1_3.success
      if true == L2_3 then
        goto lbl_59
      end
    end
    L2_3 = false
    L3_3 = type
    L4_3 = L1_3
    L3_3 = L3_3(L4_3)
    if "table" == L3_3 then
      L3_3 = tostring
      L4_3 = L1_3.error
      L3_3 = L3_3(L4_3)
      L4_3 = L17_1
      L3_3 = L4_3[L3_3]
      if L3_3 then
        L3_3 = "funds"
        if L3_3 then
          goto lbl_58
        end
      end
    end
    L3_3 = "invalid"
    ::lbl_58::
    do return L2_3, L3_3 end
    ::lbl_59::
    L2_3 = L16_1
    L3_3 = A1_2
    L4_3 = L0_3.issuer_name_snapshot
    if not L4_3 then
      L4_3 = L0_3.reason
    end
    L5_3 = tonumber
    L6_3 = L0_3.amount
    L5_3 = L5_3(L6_3)
    if not L5_3 then
      L5_3 = 0
    end
    L2_3(L3_3, L4_3, L5_3)
    L2_3 = true
    return L2_3
  end
  return L3_2(L4_2, L5_2)
end
L28_1.pay = L29_1
function L29_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2
  L2_2 = {}
  L3_2 = ipairs
  L4_2 = L23_1
  L5_2 = L14_1
  L6_2 = "bs_billing"
  L7_2 = "GetIssuedBillHistoryBySource"
  L8_2 = A0_2
  L9_2 = 100
  L10_2 = 0
  L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2 = L5_2(L6_2, L7_2, L8_2, L9_2, L10_2)
  L4_2 = L4_2(L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2)
  if not L4_2 then
    L4_2 = {}
  end
  L3_2, L4_2, L5_2, L6_2 = L3_2(L4_2)
  for L7_2, L8_2 in L3_2, L4_2, L5_2, L6_2 do
    L9_2 = type
    L10_2 = L8_2
    L9_2 = L9_2(L10_2)
    if "table" == L9_2 then
      L9_2 = L8_2.id
      if L9_2 then
        L9_2 = #L2_2
        L9_2 = L9_2 + 1
        L10_2 = L24_1
        L11_2 = L8_2
        L10_2 = L10_2(L11_2)
        L2_2[L9_2] = L10_2
      end
    end
  end
  return L2_2
end
L28_1.sent = L29_1
function L29_1(A0_2, A1_2, A2_2)
  local L3_2, L4_2, L5_2, L6_2, L7_2
  L3_2 = tonumber
  L4_2 = A2_2
  L3_2 = L3_2(L4_2)
  A2_2 = L3_2
  if not A2_2 then
    L3_2 = false
    return L3_2
  end
  L3_2 = L14_1
  L4_2 = "bs_billing"
  L5_2 = "CancelBill"
  L6_2 = A2_2
  L7_2 = A0_2
  L3_2 = L3_2(L4_2, L5_2, L6_2, L7_2)
  L4_2 = type
  L5_2 = L3_2
  L4_2 = L4_2(L5_2)
  L4_2 = "table" == L4_2
  return L4_2
end
L28_1.cancel = L29_1
L25_1(L26_1, L27_1, L28_1)
L25_1 = {}
L25_1.unpaid = "pending"
L25_1.paid = "paid"
L25_1.refunded = "cancelled"
L25_1.cancelled = "cancelled"
function L26_1(A0_2)
  local L1_2, L2_2, L3_2
  L1_2 = {}
  L2_2 = A0_2.id
  L1_2.id = L2_2
  L2_2 = A0_2.issuer_cid
  L1_2.sender = L2_2
  L2_2 = A0_2.issuer_name
  if not L2_2 then
    L2_2 = "Fatura"
  end
  L1_2.sender_name = L2_2
  L2_2 = A0_2.job
  L1_2.society = L2_2
  L2_2 = tonumber
  L3_2 = A0_2.amount
  L2_2 = L2_2(L3_2)
  if not L2_2 then
    L2_2 = 0
  end
  L1_2.amount = L2_2
  L2_2 = A0_2.description
  L1_2.reason = L2_2
  L2_2 = tostring
  L3_2 = A0_2.status
  if not L3_2 then
    L3_2 = ""
  end
  L2_2 = L2_2(L3_2)
  L3_2 = L25_1
  L2_2 = L3_2[L2_2]
  if not L2_2 then
    L2_2 = "pending"
  end
  L1_2.status = L2_2
  L2_2 = A0_2.created_at
  L1_2.created = L2_2
  L2_2 = A0_2.paid_at
  L1_2.paid_at = L2_2
  L2_2 = A0_2.cid
  L1_2.toCid = L2_2
  L2_2 = A0_2.receiver_name
  L1_2.to_name = L2_2
  return L1_2
end
L27_1 = L0_1.define
L28_1 = "billing"
L29_1 = "peleg-billing"
L30_1 = {}
L30_1.label = "peleg-billing"
L31_1 = {}
L32_1 = "peleg-billing"
L31_1[1] = L32_1
L30_1.resources = L31_1
function L31_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2
  L2_2 = {}
  L3_2 = ipairs
  L4_2 = L14_1
  L5_2 = "peleg-billing"
  L6_2 = "GetBillsByCid"
  L7_2 = A1_2
  L8_2 = 100
  L4_2 = L4_2(L5_2, L6_2, L7_2, L8_2)
  if not L4_2 then
    L4_2 = {}
  end
  L3_2, L4_2, L5_2, L6_2 = L3_2(L4_2)
  for L7_2, L8_2 in L3_2, L4_2, L5_2, L6_2 do
    L9_2 = type
    L10_2 = L8_2
    L9_2 = L9_2(L10_2)
    if "table" == L9_2 then
      L9_2 = L8_2.id
      if L9_2 then
        L9_2 = #L2_2
        L9_2 = L9_2 + 1
        L10_2 = L26_1
        L11_2 = L8_2
        L10_2 = L10_2(L11_2)
        L2_2[L9_2] = L10_2
      end
    end
  end
  return L2_2
end
L30_1.list = L31_1
function L31_1(A0_2, A1_2, A2_2)
  local L3_2, L4_2, L5_2
  L3_2 = tonumber
  L4_2 = A2_2
  L3_2 = L3_2(L4_2)
  A2_2 = L3_2
  if not A2_2 then
    L3_2 = false
    L4_2 = "invalid"
    return L3_2, L4_2
  end
  L3_2 = L13_1
  L4_2 = "peleg"
  L5_2 = A2_2
  L4_2 = L4_2 .. L5_2
  function L5_2()
    local L0_3, L1_3, L2_3, L3_3, L4_3, L5_3, L6_3, L7_3, L8_3
    L0_3 = L1_1
    L1_3 = "SELECT * FROM billing_bills WHERE id = ? AND cid = ? AND status = 'unpaid' LIMIT 1"
    L2_3 = {}
    L3_3 = A2_2
    L4_3 = A1_2
    L2_3[1] = L3_3
    L2_3[2] = L4_3
    L0_3 = L0_3(L1_3, L2_3)
    L0_3 = L0_3[1]
    if not L0_3 then
      L1_3 = false
      L2_3 = "invalid"
      return L1_3, L2_3
    end
    L1_3 = tonumber
    L2_3 = L0_3.amount
    L1_3 = L1_3(L2_3)
    if not L1_3 then
      L1_3 = 0
    end
    L2_3 = FW
    L2_3 = L2_3.GetPlayer
    L3_3 = A0_2
    L2_3 = L2_3(L3_3)
    if not L2_3 then
      L3_3 = false
      L4_3 = "invalid"
      return L3_3, L4_3
    end
    L3_3 = L2_3.GetMoney
    L4_3 = L0_3.account
    if "cash" == L4_3 then
      L4_3 = "cash"
      if L4_3 then
        goto lbl_38
      end
    end
    L4_3 = "bank"
    ::lbl_38::
    L3_3 = L3_3(L4_3)
    if L1_3 > L3_3 then
      L3_3 = false
      L4_3 = "funds"
      return L3_3, L4_3
    end
    L3_3 = L14_1
    L4_3 = "peleg-billing"
    L5_3 = "PayBill"
    L6_3 = A2_2
    L7_3 = A0_2
    L3_3, L4_3 = L3_3(L4_3, L5_3, L6_3, L7_3)
    if not L3_3 then
      L5_3 = false
      L6_3 = tostring
      L7_3 = L4_3
      L6_3 = L6_3(L7_3)
      L7_3 = L17_1
      L6_3 = L7_3[L6_3]
      if L6_3 then
        L6_3 = "funds"
        if L6_3 then
          goto lbl_64
        end
      end
      L6_3 = "invalid"
      ::lbl_64::
      return L5_3, L6_3
    end
    L5_3 = L0_3.account
    if "cash" ~= L5_3 then
      L5_3 = L16_1
      L6_3 = A1_2
      L7_3 = L0_3.issuer_name
      if not L7_3 then
        L7_3 = L0_3.description
      end
      L8_3 = L1_3
      L5_3(L6_3, L7_3, L8_3)
    end
    L5_3 = true
    return L5_3
  end
  return L3_2(L4_2, L5_2)
end
L30_1.pay = L31_1
function L31_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2
  L2_2 = {}
  L3_2 = ipairs
  L4_2 = L1_1
  L5_2 = "SELECT * FROM billing_bills WHERE issuer_cid = ? ORDER BY created_at DESC LIMIT 100"
  L6_2 = {}
  L7_2 = A1_2
  L6_2[1] = L7_2
  L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2 = L4_2(L5_2, L6_2)
  L3_2, L4_2, L5_2, L6_2 = L3_2(L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2)
  for L7_2, L8_2 in L3_2, L4_2, L5_2, L6_2 do
    L9_2 = #L2_2
    L9_2 = L9_2 + 1
    L10_2 = L26_1
    L11_2 = L8_2
    L10_2 = L10_2(L11_2)
    L2_2[L9_2] = L10_2
  end
  return L2_2
end
L30_1.sent = L31_1
L27_1(L28_1, L29_1, L30_1)
L27_1 = {}
L27_1.unpaid = "pending"
L27_1.paid = "paid"
L27_1.autopaid = "paid"
L27_1.cancelled = "cancelled"
function L28_1(A0_2)
  local L1_2, L2_2, L3_2, L4_2
  L1_2 = {}
  L2_2 = A0_2.id
  L1_2.id = L2_2
  L2_2 = A0_2.author_identifier
  L1_2.sender = L2_2
  L2_2 = A0_2.society_name
  if not L2_2 then
    L2_2 = A0_2.author_name
    if not L2_2 then
      L2_2 = "Fatura"
    end
  end
  L1_2.sender_name = L2_2
  L2_2 = L11_1
  L3_2 = A0_2.society
  L2_2 = L2_2(L3_2)
  L1_2.society = L2_2
  L2_2 = tonumber
  L3_2 = A0_2.invoice_value
  L2_2 = L2_2(L3_2)
  if not L2_2 then
    L2_2 = 0
  end
  L3_2 = tonumber
  L4_2 = A0_2.fees_amount
  L3_2 = L3_2(L4_2)
  if not L3_2 then
    L3_2 = 0
  end
  L2_2 = L2_2 + L3_2
  L1_2.amount = L2_2
  L2_2 = A0_2.item
  if not L2_2 then
    L2_2 = A0_2.notes
  end
  L1_2.reason = L2_2
  L2_2 = tostring
  L3_2 = A0_2.status
  if not L3_2 then
    L3_2 = ""
  end
  L2_2 = L2_2(L3_2)
  L3_2 = L2_2
  L2_2 = L2_2.lower
  L2_2 = L2_2(L3_2)
  L3_2 = L27_1
  L2_2 = L3_2[L2_2]
  if not L2_2 then
    L2_2 = "pending"
  end
  L1_2.status = L2_2
  L2_2 = A0_2.sent_date
  L1_2.created = L2_2
  L2_2 = A0_2.paid_date
  L1_2.paid_at = L2_2
  L2_2 = A0_2.receiver_identifier
  L1_2.toCid = L2_2
  L2_2 = A0_2.receiver_name
  L1_2.to_name = L2_2
  return L1_2
end
L29_1 = L0_1.define
L30_1 = "billing"
L31_1 = "qs-billing"
L32_1 = {}
L32_1.label = "qs-billing (qs_billing table)"
L32_1.verified = false
function L33_1()
  local L0_2, L1_2
  L0_2 = L0_1.started
  L1_2 = "qs-billing"
  L0_2 = L0_2(L1_2)
  if not L0_2 then
    L0_2 = L0_1.started
    L1_2 = "qs_billing"
    L0_2 = L0_2(L1_2)
  end
  return L0_2
end
L32_1.detect = L33_1
function L33_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2
  L2_2 = {}
  L3_2 = ipairs
  L4_2 = L1_1
  L5_2 = "SELECT * FROM qs_billing WHERE receiver_identifier = ? ORDER BY id DESC LIMIT 100"
  L6_2 = {}
  L7_2 = A1_2
  L6_2[1] = L7_2
  L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2 = L4_2(L5_2, L6_2)
  L3_2, L4_2, L5_2, L6_2 = L3_2(L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2)
  for L7_2, L8_2 in L3_2, L4_2, L5_2, L6_2 do
    L9_2 = #L2_2
    L9_2 = L9_2 + 1
    L10_2 = L28_1
    L11_2 = L8_2
    L10_2 = L10_2(L11_2)
    L2_2[L9_2] = L10_2
  end
  return L2_2
end
L32_1.list = L33_1
function L33_1(A0_2, A1_2, A2_2)
  local L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2
  L3_2 = L1_1
  L4_2 = "SELECT * FROM qs_billing WHERE id = ? AND receiver_identifier = ? AND status = 'unpaid' LIMIT 1"
  L5_2 = {}
  L6_2 = A2_2
  L7_2 = A1_2
  L5_2[1] = L6_2
  L5_2[2] = L7_2
  L3_2 = L3_2(L4_2, L5_2)
  L3_2 = L3_2[1]
  if not L3_2 then
    L4_2 = false
    L5_2 = "invalid"
    return L4_2, L5_2
  end
  L4_2 = tonumber
  L5_2 = L3_2.invoice_value
  L4_2 = L4_2(L5_2)
  if not L4_2 then
    L4_2 = 0
  end
  L5_2 = tonumber
  L6_2 = L3_2.fees_amount
  L5_2 = L5_2(L6_2)
  if not L5_2 then
    L5_2 = 0
  end
  L4_2 = L4_2 + L5_2
  L5_2 = L5_1
  L6_2 = A0_2
  L7_2 = L4_2
  L8_2 = "UPDATE qs_billing SET status = 'paid', paid_date = ? WHERE id = ? AND receiver_identifier = ? AND status = 'unpaid'"
  L9_2 = {}
  L10_2 = os
  L10_2 = L10_2.date
  L11_2 = "%Y-%m-%d %H:%M:%S"
  L10_2 = L10_2(L11_2)
  L11_2 = L3_2.id
  L12_2 = A1_2
  L9_2[1] = L10_2
  L9_2[2] = L11_2
  L9_2[3] = L12_2
  L10_2 = "UPDATE qs_billing SET status = 'unpaid', paid_date = NULL WHERE id = ?"
  L11_2 = {}
  L12_2 = L3_2.id
  L11_2[1] = L12_2
  L12_2 = L11_1
  L13_2 = L3_2.society
  L12_2 = L12_2(L13_2)
  L13_2 = L3_2.author_identifier
  L14_2 = L3_2.society_name
  if not L14_2 then
    L14_2 = L3_2.author_name
  end
  return L5_2(L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2)
end
L32_1.pay = L33_1
function L33_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2
  L2_2 = {}
  L3_2 = ipairs
  L4_2 = L1_1
  L5_2 = "SELECT * FROM qs_billing WHERE author_identifier = ? ORDER BY id DESC LIMIT 100"
  L6_2 = {}
  L7_2 = A1_2
  L6_2[1] = L7_2
  L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2 = L4_2(L5_2, L6_2)
  L3_2, L4_2, L5_2, L6_2 = L3_2(L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2)
  for L7_2, L8_2 in L3_2, L4_2, L5_2, L6_2 do
    L9_2 = #L2_2
    L9_2 = L9_2 + 1
    L10_2 = L28_1
    L11_2 = L8_2
    L10_2 = L10_2(L11_2)
    L2_2[L9_2] = L10_2
  end
  return L2_2
end
L32_1.sent = L33_1
function L33_1(A0_2, A1_2, A2_2)
  local L3_2, L4_2, L5_2, L6_2, L7_2
  L3_2 = L2_1
  L4_2 = "UPDATE qs_billing SET status = 'cancelled' WHERE id = ? AND author_identifier = ? AND status = 'unpaid'"
  L5_2 = {}
  L6_2 = A2_2
  L7_2 = A1_2
  L5_2[1] = L6_2
  L5_2[2] = L7_2
  L3_2 = L3_2(L4_2, L5_2)
  L3_2 = 1 == L3_2
  return L3_2
end
L32_1.cancel = L33_1
L29_1(L30_1, L31_1, L32_1)
L29_1 = L0_1.order
L30_1 = {}
L31_1 = "wasabi_billing"
L32_1 = "apex_billing"
L33_1 = "elevate_billing"
L34_1 = "bs_billing"
L35_1 = "peleg-billing"
L36_1 = "okokBilling"
L37_1 = "qs-billing"
L38_1 = "esx_billing"
L39_1 = "jim-payments"
L40_1 = "qb-phone"
L30_1[1] = L31_1
L30_1[2] = L32_1
L30_1[3] = L33_1
L30_1[4] = L34_1
L30_1[5] = L35_1
L30_1[6] = L36_1
L30_1[7] = L37_1
L30_1[8] = L38_1
L30_1[9] = L39_1
L30_1[10] = L40_1
L29_1.billing = L30_1
