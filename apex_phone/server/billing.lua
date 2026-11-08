local L0_1, L1_1, L2_1, L3_1, L4_1, L5_1, L6_1, L7_1, L8_1, L9_1, L10_1, L11_1, L12_1, L13_1, L14_1, L15_1, L16_1, L17_1, L18_1, L19_1, L20_1, L21_1, L22_1, L23_1, L24_1, L25_1, L26_1, L27_1, L28_1, L29_1, L30_1, L31_1, L32_1, L33_1
function L0_1(A0_2, A1_2, A2_2)
  local L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2
  L3_2 = MySQL
  L3_2 = L3_2.insert
  L4_2 = "INSERT INTO apex_phone_transactions (owner, description, amount, created) VALUES (?, ?, ?, ?)"
  L5_2 = {}
  L6_2 = A0_2
  L7_2 = tostring
  L8_2 = A1_2 or L8_2
  if not A1_2 then
    L8_2 = ""
  end
  L7_2 = L7_2(L8_2)
  L8_2 = L7_2
  L7_2 = L7_2.sub
  L9_2 = 1
  L10_2 = 160
  L7_2 = L7_2(L8_2, L9_2, L10_2)
  L8_2 = math
  L8_2 = L8_2.floor
  L9_2 = A2_2
  L8_2 = L8_2(L9_2)
  L9_2 = Now
  L9_2, L10_2 = L9_2()
  L5_2[1] = L6_2
  L5_2[2] = L7_2
  L5_2[3] = L8_2
  L5_2[4] = L9_2
  L5_2[5] = L10_2
  L3_2(L4_2, L5_2)
end
AddTransaction = L0_1
function L1_1(A0_2, A1_2, A2_2)
  local L3_2, L4_2, L5_2, L6_2, L7_2
  L3_2 = FW
  L3_2 = L3_2.GetPlayerByCid
  L4_2 = A0_2
  L3_2 = L3_2(L4_2)
  if L3_2 then
    L4_2 = L3_2.AddMoney
    L5_2 = "bank"
    L6_2 = A1_2
    L7_2 = A2_2 or L7_2
    if not A2_2 then
      L7_2 = "apex_phone"
    end
    return L4_2(L5_2, L6_2, L7_2)
  end
  L4_2 = FW
  L4_2 = L4_2.AddMoneyOffline
  L5_2 = A0_2
  L6_2 = "bank"
  L7_2 = A1_2
  return L4_2(L5_2, L6_2, L7_2)
end
GiveBank = L1_1
function L2_1(A0_2)
  local L1_2, L2_2, L3_2
  L1_2 = tonumber
  L2_2 = A0_2
  L1_2 = L1_2(L2_2)
  if L1_2 and L1_2 == L1_2 then
    L2_2 = math
    L2_2 = L2_2.huge
    if L1_2 ~= L2_2 then
      L2_2 = math
      L2_2 = L2_2.huge
      L2_2 = -L2_2
      if L1_2 ~= L2_2 then
        goto lbl_19
      end
    end
  end
  L2_2 = nil
  do return L2_2 end
  ::lbl_19::
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
function L3_1()
  local L0_2, L1_2, L2_2, L3_2
  L0_2 = type
  L1_2 = Config
  L1_2 = L1_2.Billing
  L0_2 = L0_2(L1_2)
  if "table" == L0_2 then
    L0_2 = Config
    L0_2 = L0_2.Billing
    if L0_2 then
      goto lbl_13
    end
  end
  L0_2 = {}
  ::lbl_13::
  L1_2 = {}
  L2_2 = L2_1
  L3_2 = L0_2.maxAmount
  L2_2 = L2_2(L3_2)
  if not L2_2 then
    L2_2 = 1000000
  end
  L1_2.maxAmount = L2_2
  L2_2 = type
  L3_2 = L0_2.societyJobs
  L2_2 = L2_2(L3_2)
  if "table" == L2_2 then
    L2_2 = L0_2.societyJobs
    if L2_2 then
      goto lbl_31
    end
  end
  L2_2 = nil
  ::lbl_31::
  L1_2.societyJobs = L2_2
  L2_2 = tonumber
  L3_2 = L0_2.minGrade
  L2_2 = L2_2(L3_2)
  if not L2_2 then
    L2_2 = 0
  end
  L1_2.minGrade = L2_2
  L2_2 = tonumber
  L3_2 = L0_2.cooldown
  L2_2 = L2_2(L3_2)
  if not L2_2 then
    L2_2 = 5
  end
  L1_2.cooldown = L2_2
  return L1_2
end
function L4_1()
  local L0_2, L1_2
  L0_2 = GetResourceState
  L1_2 = "apex_banking"
  L0_2 = L0_2(L1_2)
  L0_2 = "started" == L0_2
  return L0_2
end
function L5_1(A0_2)
  local L1_2, L2_2, L3_2, L4_2
  if A0_2 then
    L1_2 = L4_1
    L1_2 = L1_2()
    if L1_2 then
      goto lbl_9
    end
  end
  L1_2 = nil
  do return L1_2 end
  ::lbl_9::
  L1_2 = pcall
  function L2_2()
    local L0_3, L1_3, L2_3, L3_3
    L0_3 = MySQL
    L0_3 = L0_3.single
    L0_3 = L0_3.await
    L1_3 = "SELECT iban, owner_name, savings, frozen FROM apex_banking_accounts WHERE identifier = ?"
    L2_3 = {}
    L3_3 = A0_2
    L2_3[1] = L3_3
    return L0_3(L1_3, L2_3)
  end
  L1_2, L2_2 = L1_2(L2_2)
  if L1_2 then
    L3_2 = type
    L4_2 = L2_2
    L3_2 = L3_2(L4_2)
    if "table" == L3_2 then
      L3_2 = L2_2.iban
      if L3_2 then
        return L2_2
      end
    end
  end
  L3_2 = nil
  return L3_2
end
L6_1 = {}
L6_1.deposit = "Dep\195\179sito"
L6_1.withdraw = "Levantamento"
L6_1.atm_deposit = "Dep\195\179sito no ATM"
L6_1.atm_withdraw = "Levantamento no ATM"
L6_1.transfer_in = "Transfer\195\170ncia recebida"
L6_1.transfer_out = "Transfer\195\170ncia enviada"
L6_1.fee = "Taxa"
L6_1.loan_grant = "Empr\195\169stimo"
L6_1.loan_repay = "Presta\195\167\195\163o do empr\195\169stimo"
L6_1.savings_in = "Para a poupan\195\167a"
L6_1.savings_out = "Da poupan\195\167a"
L6_1.pending_credit = "Cr\195\169dito pendente"
L6_1.billing_payment = "Pagamento de fatura"
L6_1.billing_income = "Fatura recebida"
L6_1.sub_in = "Entrada na conta"
L6_1.sub_out = "Sa\195\173da da conta"
function L7_1(A0_2)
  local L1_2, L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2, L19_2, L20_2, L21_2, L22_2
  L1_2 = pcall
  function L2_2()
    local L0_3, L1_3, L2_3, L3_3, L4_3
    L0_3 = MySQL
    L0_3 = L0_3.query
    L0_3 = L0_3.await
    L1_3 = "SELECT id, kind, from_iban, to_iban, amount, fee, label, UNIX_TIMESTAMP(created_at) AS ts FROM apex_banking_transactions WHERE from_iban = ? OR to_iban = ? ORDER BY id DESC LIMIT 60"
    L2_3 = {}
    L3_3 = A0_2
    L4_3 = A0_2
    L2_3[1] = L3_3
    L2_3[2] = L4_3
    return L0_3(L1_3, L2_3)
  end
  L1_2, L2_2 = L1_2(L2_2)
  if L1_2 then
    L3_2 = type
    L4_2 = L2_2
    L3_2 = L3_2(L4_2)
    if "table" == L3_2 then
      goto lbl_14
    end
  end
  L3_2 = {}
  do return L3_2 end
  ::lbl_14::
  L3_2 = {}
  L4_2 = ipairs
  L5_2 = L2_2
  L4_2, L5_2, L6_2, L7_2 = L4_2(L5_2)
  for L8_2, L9_2 in L4_2, L5_2, L6_2, L7_2 do
    L10_2 = math
    L10_2 = L10_2.floor
    L11_2 = tonumber
    L12_2 = L9_2.amount
    L11_2 = L11_2(L12_2)
    if not L11_2 then
      L11_2 = 0
    end
    L10_2 = L10_2(L11_2)
    L11_2 = tostring
    L12_2 = L9_2.kind
    if not L12_2 then
      L12_2 = ""
    end
    L11_2 = L11_2(L12_2)
    L12_2 = true
    L13_2 = L9_2.to_iban
    L13_2 = L13_2 == A0_2
    if "transfer_out" == L11_2 then
      L14_2 = L9_2.from_iban
      L12_2 = L14_2 == A0_2
      L13_2 = false
    elseif "transfer_in" == L11_2 then
      L14_2 = L9_2.to_iban
      L12_2 = L14_2 == A0_2
      L13_2 = true
    elseif "fee" == L11_2 then
      L13_2 = false
    end
    if L12_2 and L10_2 > 0 then
      L14_2 = tostring
      L15_2 = L9_2.label
      if not L15_2 then
        L15_2 = ""
      end
      L14_2 = L14_2(L15_2)
      L15_2 = L6_1
      L15_2 = L15_2[L11_2]
      if not L15_2 then
        L15_2 = L11_2
      end
      if "" ~= L14_2 and L14_2 ~= L15_2 then
        L16_2 = L15_2
        L17_2 = " \194\183 "
        L18_2 = L14_2
        L16_2 = L16_2 .. L17_2 .. L18_2
        if L16_2 then
          goto lbl_88
        end
      end
      L16_2 = L15_2
      ::lbl_88::
      L17_2 = #L3_2
      L17_2 = L17_2 + 1
      L18_2 = {}
      L19_2 = "b"
      L20_2 = tostring
      L21_2 = L9_2.id
      L20_2 = L20_2(L21_2)
      L19_2 = L19_2 .. L20_2
      L18_2.id = L19_2
      L20_2 = L16_2
      L19_2 = L16_2.sub
      L21_2 = 1
      L22_2 = 160
      L19_2 = L19_2(L20_2, L21_2, L22_2)
      L18_2.description = L19_2
      L19_2 = L10_2 or L19_2
      if not L13_2 or not L10_2 then
        L19_2 = -L10_2
      end
      L18_2.amount = L19_2
      L19_2 = tonumber
      L20_2 = L9_2.ts
      L19_2 = L19_2(L20_2)
      if not L19_2 then
        L19_2 = 0
      end
      L19_2 = L19_2 * 1000
      L18_2.created = L19_2
      L18_2.bank = true
      L3_2[L17_2] = L18_2
    end
  end
  return L3_2
end
function L8_1(A0_2)
  local L1_2, L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2
  L1_2 = FW
  L1_2 = L1_2.GetPlayer
  L2_2 = A0_2
  L1_2 = L1_2(L2_2)
  if not L1_2 then
    L2_2 = nil
    return L2_2
  end
  L2_2 = MySQL
  L2_2 = L2_2.query
  L2_2 = L2_2.await
  L3_2 = "SELECT * FROM apex_phone_transactions WHERE owner = ? ORDER BY created DESC LIMIT 60"
  L4_2 = {}
  L5_2 = L1_2.cid
  L4_2[1] = L5_2
  L2_2 = L2_2(L3_2, L4_2)
  if not L2_2 then
    L2_2 = {}
  end
  L3_2 = {}
  L4_2 = L1_2.GetMoney
  L5_2 = "bank"
  L4_2 = L4_2(L5_2)
  L3_2.bank = L4_2
  L4_2 = L1_2.GetMoney
  L5_2 = "cash"
  L4_2 = L4_2(L5_2)
  L3_2.cash = L4_2
  L3_2.transactions = L2_2
  L4_2 = L5_1
  L5_2 = L1_2.cid
  L4_2 = L4_2(L5_2)
  if L4_2 then
    L3_2.provider = "apex_banking"
    L5_2 = L4_2.iban
    L3_2.iban = L5_2
    L5_2 = math
    L5_2 = L5_2.floor
    L6_2 = tonumber
    L7_2 = L4_2.savings
    L6_2 = L6_2(L7_2)
    if not L6_2 then
      L6_2 = 0
    end
    L5_2 = L5_2(L6_2)
    L3_2.savings = L5_2
    L5_2 = tonumber
    L6_2 = L4_2.frozen
    L5_2 = L5_2(L6_2)
    L5_2 = 1 == L5_2
    L3_2.frozen = L5_2
    L5_2 = L7_1
    L6_2 = L4_2.iban
    L5_2 = L5_2(L6_2)
    L6_2 = ipairs
    L7_2 = L2_2
    L6_2, L7_2, L8_2, L9_2 = L6_2(L7_2)
    for L10_2, L11_2 in L6_2, L7_2, L8_2, L9_2 do
      L12_2 = #L5_2
      L12_2 = L12_2 + 1
      L5_2[L12_2] = L11_2
    end
    L6_2 = table
    L6_2 = L6_2.sort
    L7_2 = L5_2
    function L8_2(A0_3, A1_3)
      local L2_3, L3_3, L4_3
      L2_3 = tonumber
      L3_3 = A0_3.created
      L2_3 = L2_3(L3_3)
      if not L2_3 then
        L2_3 = 0
      end
      L3_3 = tonumber
      L4_3 = A1_3.created
      L3_3 = L3_3(L4_3)
      if not L3_3 then
        L3_3 = 0
      end
      L2_3 = L2_3 > L3_3
      return L2_3
    end
    L6_2(L7_2, L8_2)
    while true do
      L6_2 = #L5_2
      if not (L6_2 > 80) then
        break
      end
      L6_2 = #L5_2
      L5_2[L6_2] = nil
    end
    L3_2.transactions = L5_2
  else
    L5_2 = L4_1
    L5_2 = L5_2()
    if L5_2 then
      L3_2.provider = "apex_banking"
      L3_2.noAccount = true
    end
  end
  return L3_2
end
function L9_1(A0_2, A1_2, A2_2, A3_2, A4_2)
  local L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2
  L5_2 = L5_1
  L6_2 = A1_2.cid
  L5_2 = L5_2(L6_2)
  if not L5_2 then
    L6_2 = nil
    return L6_2
  end
  L6_2 = L5_1
  L7_2 = A2_2
  L6_2 = L6_2(L7_2)
  if not L6_2 then
    L7_2 = nil
    return L7_2
  end
  L7_2 = tonumber
  L8_2 = L5_2.frozen
  L7_2 = L7_2(L8_2)
  if 1 == L7_2 then
    L7_2 = {}
    L7_2.ok = false
    L7_2.error = "frozen"
    return L7_2
  end
  L7_2 = pcall
  function L8_2()
    local L0_3, L1_3, L2_3, L3_3, L4_3, L5_3, L6_3
    L0_3 = exports
    L0_3 = L0_3.apex_banking
    L1_3 = L0_3
    L0_3 = L0_3.Transfer
    L2_3 = A0_2
    L3_3 = L6_2.iban
    L4_3 = A3_2
    L5_3 = A4_2
    if "" ~= L5_3 then
      L5_3 = "Telem\195\179vel \194\183 "
      L6_3 = A4_2
      L5_3 = L5_3 .. L6_3
      if L5_3 then
        goto lbl_16
      end
    end
    L5_3 = "Telem\195\179vel"
    ::lbl_16::
    return L0_3(L1_3, L2_3, L3_3, L4_3, L5_3)
  end
  L7_2, L8_2, L9_2 = L7_2(L8_2)
  if not L7_2 then
    L10_2 = print
    L11_2 = "^3[unique_phone]^0 apex_banking Transfer failed (%s); the transfer continues through the framework"
    L12_2 = L11_2
    L11_2 = L11_2.format
    L13_2 = tostring
    L14_2 = L8_2
    L13_2, L14_2 = L13_2(L14_2)
    L11_2, L12_2, L13_2, L14_2 = L11_2(L12_2, L13_2, L14_2)
    L10_2(L11_2, L12_2, L13_2, L14_2)
    L10_2 = nil
    return L10_2
  end
  if L8_2 then
    L10_2 = {}
    L10_2.ok = true
    L11_2 = A1_2.GetMoney
    L12_2 = "bank"
    L11_2 = L11_2(L12_2)
    L10_2.bank = L11_2
    L10_2.via = "apex_banking"
    return L10_2
  end
  L10_2 = {}
  L10_2.no_funds = "funds"
  L10_2.no_to = "target"
  L10_2.no_from = "target"
  L10_2.self = "self"
  L10_2.min = "amount"
  L10_2.max = "amount"
  L10_2.no_perm = "target"
  L10_2.no_account = "target"
  L10_2.no_id = "target"
  L10_2.bad_args = "amount"
  L11_2 = {}
  L11_2.ok = false
  L12_2 = tostring
  L13_2 = L9_2
  L12_2 = L12_2(L13_2)
  L12_2 = L10_2[L12_2]
  if not L12_2 then
    L12_2 = "target"
  end
  L11_2.error = L12_2
  L12_2 = A1_2.GetMoney
  L13_2 = "bank"
  L12_2 = L12_2(L13_2)
  L11_2.bank = L12_2
  return L11_2
end
L10_1 = type
L11_1 = Config
L11_1 = L11_1.RateLimit
L10_1 = L10_1(L11_1)
if "table" == L10_1 then
  L10_1 = Config
  L10_1 = L10_1.RateLimit
  if L10_1 then
    goto lbl_42
  end
end
L10_1 = nil
::lbl_42::
if L10_1 then
  L11_1 = type
  L12_1 = L10_1.costs
  L11_1 = L11_1(L12_1)
  if "table" == L11_1 then
    L11_1 = L10_1.costs
    if L11_1 then
      goto lbl_54
    end
  end
  L11_1 = {}
  ::lbl_54::
  L10_1.costs = L11_1
  L11_1 = L10_1.costs
  L11_1 = L11_1["bank.resolve"]
  if nil == L11_1 then
    L11_1 = L10_1.costs
    L11_1["bank.resolve"] = 2
  end
end
function L10_1(A0_2)
  local L1_2, L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2
  L1_2 = PhoneIntegrations
  L1_2 = L1_2.nameOf
  L2_2 = A0_2
  L1_2 = L1_2(L2_2)
  if L1_2 then
    return L1_2
  end
  L2_2 = FW
  L2_2 = L2_2.FindCidExists
  L3_2 = A0_2
  L2_2, L3_2 = L2_2(L3_2)
  if L2_2 and L3_2 then
    return L3_2
  end
  L4_2 = pcall
  L5_2 = MySQL
  L5_2 = L5_2.single
  L5_2 = L5_2.await
  L6_2 = "SELECT username FROM apex_phone_accounts WHERE citizenid = ? LIMIT 1"
  L7_2 = {}
  L8_2 = A0_2
  L7_2[1] = L8_2
  L4_2, L5_2 = L4_2(L5_2, L6_2, L7_2)
  if L4_2 then
    L6_2 = type
    L7_2 = L5_2
    L6_2 = L6_2(L7_2)
    if "table" == L6_2 then
      L6_2 = L5_2.username
      if L6_2 then
        L6_2 = L5_2.username
        if "" ~= L6_2 then
          L6_2 = "@"
          L7_2 = tostring
          L8_2 = L5_2.username
          L7_2 = L7_2(L8_2)
          L6_2 = L6_2 .. L7_2
          return L6_2
        end
      end
    end
  end
  L6_2 = "Jogador"
  return L6_2
end
function L11_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2
  L2_2 = type
  L3_2 = A1_2
  L2_2 = L2_2(L3_2)
  if "string" ~= L2_2 then
    L2_2 = type
    L3_2 = A1_2
    L2_2 = L2_2(L3_2)
    if "number" ~= L2_2 then
      L2_2 = nil
      L3_2 = "invalid"
      return L2_2, L3_2
    end
  end
  L2_2 = tostring
  L3_2 = A1_2
  L2_2 = L2_2(L3_2)
  L3_2 = L2_2
  L2_2 = L2_2.gsub
  L4_2 = "^%s+"
  L5_2 = ""
  L2_2 = L2_2(L3_2, L4_2, L5_2)
  L3_2 = L2_2
  L2_2 = L2_2.gsub
  L4_2 = "%s+$"
  L5_2 = ""
  L2_2 = L2_2(L3_2, L4_2, L5_2)
  A1_2 = L2_2
  if "" ~= A1_2 then
    L2_2 = #A1_2
    if not (L2_2 > 64) then
      goto lbl_34
    end
  end
  L2_2 = nil
  L3_2 = "invalid"
  do return L2_2, L3_2 end
  ::lbl_34::
  L2_2 = GetCid
  L3_2 = A0_2
  L2_2 = L2_2(L3_2)
  L3_2 = #A1_2
  if L3_2 <= 20 then
    L3_2 = GetPlayerNumber
    L4_2 = A0_2
    L3_2 = L3_2(L4_2)
    if A1_2 == L3_2 then
      L3_2 = nil
      L4_2 = "self"
      return L3_2, L4_2
    end
    L3_2 = GetCitizenIdByNumber
    L4_2 = A1_2
    L3_2 = L3_2(L4_2)
    if L3_2 then
      if L3_2 == L2_2 then
        L4_2 = nil
        L5_2 = "self"
        return L4_2, L5_2
      end
      L4_2 = CanonNumber
      if L4_2 then
        L4_2 = CanonNumber
        L5_2 = A1_2
        L4_2 = L4_2(L5_2)
        if L4_2 then
          goto lbl_67
        end
      end
      L4_2 = A1_2
      ::lbl_67::
      L5_2 = {}
      L5_2.cid = L3_2
      L5_2.number = L4_2
      L6_2 = L10_1
      L7_2 = L3_2
      L6_2 = L6_2(L7_2)
      L5_2.name = L6_2
      L5_2.kind = "number"
      return L5_2
    end
  end
  L3_2 = #A1_2
  if L3_2 <= 5 then
    L4_2 = A1_2
    L3_2 = A1_2.match
    L5_2 = "^%d+$"
    L3_2 = L3_2(L4_2, L5_2)
    if L3_2 then
      L3_2 = tonumber
      L4_2 = A1_2
      L3_2 = L3_2(L4_2)
      if L3_2 then
        L4_2 = GetPlayerName
        L5_2 = L3_2
        L4_2 = L4_2(L5_2)
        if nil ~= L4_2 then
          L4_2 = FW
          L4_2 = L4_2.GetPlayer
          L5_2 = L3_2
          L4_2 = L4_2(L5_2)
          if L4_2 then
            L5_2 = tonumber
            L6_2 = A0_2
            L5_2 = L5_2(L6_2)
            if L3_2 ~= L5_2 then
              L5_2 = L4_2.cid
              if L5_2 ~= L2_2 then
                goto lbl_112
              end
            end
            L5_2 = nil
            L6_2 = "self"
            do return L5_2, L6_2 end
            ::lbl_112::
            L5_2 = {}
            L6_2 = L4_2.cid
            L5_2.cid = L6_2
            L6_2 = GetPlayerNumber
            L7_2 = L3_2
            L6_2 = L6_2(L7_2)
            L5_2.number = L6_2
            L6_2 = L10_1
            L7_2 = L4_2.cid
            L6_2 = L6_2(L7_2)
            L5_2.name = L6_2
            L5_2.kind = "id"
            return L5_2
          end
        end
      end
      L4_2 = nil
      L5_2 = "target"
      return L4_2, L5_2
    end
  end
  if L2_2 and A1_2 == L2_2 then
    L3_2 = nil
    L4_2 = "self"
    return L3_2, L4_2
  end
  L3_2 = FW
  L3_2 = L3_2.GetPlayerByCid
  L4_2 = A1_2
  L3_2 = L3_2(L4_2)
  L4_2 = nil
  L5_2 = nil
  if L3_2 then
    L6_2 = L3_2.cid
    L7_2 = L10_1
    L8_2 = L3_2.cid
    L7_2 = L7_2(L8_2)
    L5_2 = L7_2
    L4_2 = L6_2
  else
    L6_2 = FW
    L6_2 = L6_2.FindCidExists
    L7_2 = A1_2
    L6_2, L7_2, L8_2 = L6_2(L7_2)
    if L6_2 then
      L9_2 = L8_2 or L9_2
      if not L8_2 then
        L9_2 = A1_2
      end
      L5_2 = L7_2 or L5_2
      if not L7_2 then
        L10_2 = L10_1
        L11_2 = L8_2 or L11_2
        if not L8_2 then
          L11_2 = A1_2
        end
        L10_2 = L10_2(L11_2)
        L5_2 = L10_2
      end
      L4_2 = L9_2
    end
  end
  if not L4_2 then
    L6_2 = nil
    L7_2 = "target"
    return L6_2, L7_2
  end
  if L4_2 == L2_2 then
    L6_2 = nil
    L7_2 = "self"
    return L6_2, L7_2
  end
  L6_2 = {}
  L6_2.cid = L4_2
  L7_2 = GetNumberByCitizenId
  L8_2 = L4_2
  L7_2 = L7_2(L8_2)
  L6_2.number = L7_2
  L6_2.name = L5_2
  L6_2.kind = "cid"
  return L6_2
end
ResolveTransferTarget = L11_1
function L11_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2
  L2_2 = A0_2.number
  if L2_2 then
    L2_2 = A0_2.number
    if "" ~= L2_2 then
      L2_2 = tostring
      L3_2 = A0_2.number
      return L2_2(L3_2)
    end
  end
  L2_2 = A0_2.kind
  if "id" == L2_2 then
    L2_2 = "ID "
    L3_2 = tostring
    L4_2 = A1_2
    L3_2 = L3_2(L4_2)
    L2_2 = L2_2 .. L3_2
    return L2_2
  end
  L2_2 = tostring
  L3_2 = A0_2.name
  if not L3_2 then
    L3_2 = A1_2
  end
  return L2_2(L3_2)
end
function L12_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2, L19_2, L20_2, L21_2
  L2_2 = FW
  L2_2 = L2_2.GetPlayer
  L3_2 = A0_2
  L2_2 = L2_2(L3_2)
  if not L2_2 then
    L3_2 = {}
    L3_2.ok = false
    L3_2.error = "noplayer"
    return L3_2
  end
  L3_2 = L2_1
  L4_2 = A1_2.amount
  L3_2 = L3_2(L4_2)
  if not L3_2 then
    L4_2 = {}
    L4_2.ok = false
    L4_2.error = "amount"
    return L4_2
  end
  L4_2 = ResolveTransferTarget
  L5_2 = A0_2
  L6_2 = A1_2.to
  L4_2, L5_2 = L4_2(L5_2, L6_2)
  if not L4_2 then
    L6_2 = {}
    L6_2.ok = false
    L6_2.error = L5_2
    return L6_2
  end
  L6_2 = L4_2.cid
  L7_2 = L2_2.cid
  if L6_2 == L7_2 then
    L7_2 = {}
    L7_2.ok = false
    L7_2.error = "self"
    return L7_2
  end
  L7_2 = L11_1
  L8_2 = L4_2
  L9_2 = tostring
  L10_2 = A1_2.to
  if not L10_2 then
    L10_2 = ""
  end
  L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2, L19_2, L20_2, L21_2 = L9_2(L10_2)
  L7_2 = L7_2(L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2, L19_2, L20_2, L21_2)
  L8_2 = L2_2.GetMoney
  L9_2 = "bank"
  L8_2 = L8_2(L9_2)
  if L3_2 > L8_2 then
    L8_2 = {}
    L8_2.ok = false
    L8_2.error = "funds"
    return L8_2
  end
  L8_2 = A1_2.note
  if nil ~= L8_2 then
    L8_2 = tostring
    L9_2 = A1_2.note
    L8_2 = L8_2(L9_2)
    L9_2 = L8_2
    L8_2 = L8_2.sub
    L10_2 = 1
    L11_2 = 60
    L8_2 = L8_2(L9_2, L10_2, L11_2)
    if L8_2 then
      goto lbl_74
    end
  end
  L8_2 = ""
  ::lbl_74::
  L9_2 = L9_1
  L10_2 = A0_2
  L11_2 = L2_2
  L12_2 = L6_2
  L13_2 = L3_2
  L14_2 = L8_2
  L9_2 = L9_2(L10_2, L11_2, L12_2, L13_2, L14_2)
  if L9_2 then
    L10_2 = L9_2.ok
    if L10_2 then
      L10_2 = {}
      L11_2 = L4_2.number
      L10_2.number = L11_2
      L11_2 = L4_2.name
      L10_2.name = L11_2
      L11_2 = L4_2.kind
      L10_2.kind = L11_2
      L9_2.to = L10_2
      L10_2 = FW
      L10_2 = L10_2.GetPlayerByCid
      L11_2 = L6_2
      L10_2 = L10_2(L11_2)
      if L10_2 then
        L11_2 = Push
        L12_2 = L10_2.src
        L13_2 = "bank"
        L14_2 = {}
        L14_2.title = "Transfer\195\170ncia recebida"
        L15_2 = "Recebeste %s de %s"
        L16_2 = L15_2
        L15_2 = L15_2.format
        L17_2 = FormatMoney
        L18_2 = L3_2
        L17_2 = L17_2(L18_2)
        L18_2 = L2_2.firstname
        if not L18_2 then
          L18_2 = ""
        end
        L19_2 = " "
        L20_2 = L2_2.lastname
        if not L20_2 then
          L20_2 = ""
        end
        L18_2 = L18_2 .. L19_2 .. L20_2
        L15_2 = L15_2(L16_2, L17_2, L18_2)
        L14_2.msg = L15_2
        L11_2(L12_2, L13_2, L14_2)
      end
    end
    return L9_2
  end
  L10_2 = L2_2.RemoveMoney
  L11_2 = "bank"
  L12_2 = L3_2
  L13_2 = "phone-transfer"
  L10_2 = L10_2(L11_2, L12_2, L13_2)
  if not L10_2 then
    L10_2 = {}
    L10_2.ok = false
    L10_2.error = "funds"
    return L10_2
  end
  L10_2 = L1_1
  L11_2 = L6_2
  L12_2 = L3_2
  L13_2 = "phone-transfer"
  L10_2 = L10_2(L11_2, L12_2, L13_2)
  if not L10_2 then
    L10_2 = L2_2.AddMoney
    L11_2 = "bank"
    L12_2 = L3_2
    L13_2 = "phone-transfer-reposto"
    L10_2 = L10_2(L11_2, L12_2, L13_2)
    if not L10_2 then
      L10_2 = print
      L11_2 = "^1[unique_phone]^0 bank.transfer to %s failed and could not refund %s to %s"
      L12_2 = L11_2
      L11_2 = L11_2.format
      L13_2 = tostring
      L14_2 = L7_2
      L13_2 = L13_2(L14_2)
      L14_2 = FormatMoney
      L15_2 = L3_2
      L14_2 = L14_2(L15_2)
      L15_2 = tostring
      L16_2 = L2_2.cid
      L15_2, L16_2, L17_2, L18_2, L19_2, L20_2, L21_2 = L15_2(L16_2)
      L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2, L19_2, L20_2, L21_2 = L11_2(L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2, L19_2, L20_2, L21_2)
      L10_2(L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2, L19_2, L20_2, L21_2)
      L10_2 = L0_1
      L11_2 = L2_2.cid
      L12_2 = "Transfer\195\170ncia falhada para "
      L13_2 = L7_2
      L14_2 = " \194\183 valor retido"
      L12_2 = L12_2 .. L13_2 .. L14_2
      L13_2 = -L3_2
      L10_2(L11_2, L12_2, L13_2)
    end
    L10_2 = {}
    L10_2.ok = false
    L10_2.error = "target"
    L11_2 = L2_2.GetMoney
    L12_2 = "bank"
    L11_2 = L11_2(L12_2)
    L10_2.bank = L11_2
    return L10_2
  end
  L10_2 = GetPlayerNumber
  L11_2 = A0_2
  L10_2 = L10_2(L11_2)
  L11_2 = L2_2.firstname
  if not L11_2 then
    L11_2 = ""
  end
  L12_2 = " "
  L13_2 = L2_2.lastname
  if not L13_2 then
    L13_2 = ""
  end
  L11_2 = L11_2 .. L12_2 .. L13_2
  L12_2 = A1_2.note
  if nil ~= L12_2 then
    L12_2 = tostring
    L13_2 = A1_2.note
    L12_2 = L12_2(L13_2)
    L13_2 = L12_2
    L12_2 = L12_2.sub
    L14_2 = 1
    L15_2 = 60
    L12_2 = L12_2(L13_2, L14_2, L15_2)
    if L12_2 then
      goto lbl_209
    end
  end
  L12_2 = ""
  ::lbl_209::
  L13_2 = L0_1
  L14_2 = L2_2.cid
  L15_2 = "Transfer\195\170ncia para "
  L16_2 = L7_2
  if "" ~= L12_2 then
    L17_2 = " \194\183 "
    L18_2 = L12_2
    L17_2 = L17_2 .. L18_2
    if L17_2 then
      goto lbl_221
    end
  end
  L17_2 = ""
  ::lbl_221::
  L15_2 = L15_2 .. L16_2 .. L17_2
  L16_2 = -L3_2
  L13_2(L14_2, L15_2, L16_2)
  L13_2 = L0_1
  L14_2 = L6_2
  L15_2 = "Transfer\195\170ncia de "
  L16_2 = L11_2
  L17_2 = " ("
  L18_2 = tostring
  L19_2 = L10_2
  L18_2 = L18_2(L19_2)
  L19_2 = ")"
  if "" ~= L12_2 then
    L20_2 = " \194\183 "
    L21_2 = L12_2
    L20_2 = L20_2 .. L21_2
    if L20_2 then
      goto lbl_241
    end
  end
  L20_2 = ""
  ::lbl_241::
  L15_2 = L15_2 .. L16_2 .. L17_2 .. L18_2 .. L19_2 .. L20_2
  L16_2 = L3_2
  L13_2(L14_2, L15_2, L16_2)
  L13_2 = FW
  L13_2 = L13_2.GetPlayerByCid
  L14_2 = L6_2
  L13_2 = L13_2(L14_2)
  if L13_2 then
    L14_2 = Push
    L15_2 = L13_2.src
    L16_2 = "bank"
    L17_2 = {}
    L17_2.title = "Transfer\195\170ncia recebida"
    L18_2 = "Recebeste %s de %s"
    L19_2 = L18_2
    L18_2 = L18_2.format
    L20_2 = FormatMoney
    L21_2 = L3_2
    L20_2 = L20_2(L21_2)
    L21_2 = L11_2
    L18_2 = L18_2(L19_2, L20_2, L21_2)
    L17_2.msg = L18_2
    L14_2(L15_2, L16_2, L17_2)
  end
  L14_2 = {}
  L14_2.ok = true
  L15_2 = L2_2.GetMoney
  L16_2 = "bank"
  L15_2 = L15_2(L16_2)
  L14_2.bank = L15_2
  L15_2 = {}
  L16_2 = L4_2.number
  L15_2.number = L16_2
  L16_2 = L4_2.name
  L15_2.name = L16_2
  L16_2 = L4_2.kind
  L15_2.kind = L16_2
  L14_2.to = L15_2
  return L14_2
end
L13_1 = PhoneIntegrations
L14_1 = L13_1.defineBuiltin
L15_1 = "bank"
L16_1 = {}
L16_1.label = "Framework money (+ apex_banking bridge)"
function L17_1(A0_2)
  local L1_2, L2_2, L3_2
  L1_2 = FW
  L1_2 = L1_2.GetPlayer
  L2_2 = A0_2
  L1_2 = L1_2(L2_2)
  if L1_2 then
    L2_2 = L1_2.GetMoney
    L3_2 = "bank"
    L2_2 = L2_2(L3_2)
    if L2_2 then
      goto lbl_13
    end
  end
  L2_2 = 0
  ::lbl_13::
  return L2_2
end
L16_1.balance = L17_1
L14_1(L15_1, L16_1)
L14_1 = {}
L14_1.funds = "funds"
L14_1.no_funds = "funds"
L14_1.insufficient = "funds"
L14_1.target = "target"
L14_1.no_target = "target"
L14_1.offline = "target"
L14_1.self = "self"
L14_1.amount = "amount"
L14_1.frozen = "frozen"
function L15_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2, L6_2
  L2_2 = IntegrationTry
  L3_2 = "bank"
  L4_2 = "balance"
  L5_2 = A0_2
  L6_2 = A1_2.cid
  L2_2, L3_2 = L2_2(L3_2, L4_2, L5_2, L6_2)
  if L2_2 then
    L4_2 = L13_1.num
    L5_2 = L3_2
    L4_2 = L4_2(L5_2)
    if L4_2 then
      goto lbl_15
    end
  end
  L4_2 = nil
  ::lbl_15::
  L5_2 = L4_2 or L5_2
  if not L4_2 then
    L5_2 = A1_2.GetMoney
    L6_2 = "bank"
    L5_2 = L5_2(L6_2)
  end
  return L5_2
end
function L16_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2
  L2_2 = type
  L3_2 = A0_2
  L2_2 = L2_2(L3_2)
  if "table" ~= L2_2 then
    L2_2 = nil
    return L2_2
  end
  L2_2 = L13_1.num
  L3_2 = A0_2.amount
  L2_2 = L2_2(L3_2)
  if not L2_2 or 0 == L2_2 then
    L3_2 = nil
    return L3_2
  end
  L3_2 = A0_2.description
  if not L3_2 then
    L3_2 = A0_2.label
    if not L3_2 then
      L3_2 = A0_2.title
      if not L3_2 then
        L3_2 = A0_2.reason
        if not L3_2 then
          L3_2 = ""
        end
      end
    end
  end
  if L2_2 < 0 then
    L4_2 = math
    L4_2 = L4_2.floor
    L5_2 = -L2_2
    L4_2 = L4_2(L5_2)
    L4_2 = -L4_2
    if L4_2 then
      goto lbl_44
      L2_2 = L4_2 or L2_2
    end
  end
  L4_2 = math
  L4_2 = L4_2.floor
  L5_2 = L2_2
  L4_2 = L4_2(L5_2)
  L2_2 = L4_2
  ::lbl_44::
  if 0 == L2_2 then
    L4_2 = nil
    return L4_2
  end
  L4_2 = {}
  L5_2 = "p"
  L6_2 = tostring
  L7_2 = A0_2.id
  if not L7_2 then
    L7_2 = A1_2
  end
  L6_2 = L6_2(L7_2)
  L5_2 = L5_2 .. L6_2
  L4_2.id = L5_2
  L5_2 = tostring
  L6_2 = L3_2
  L5_2 = L5_2(L6_2)
  L6_2 = L5_2
  L5_2 = L5_2.sub
  L7_2 = 1
  L8_2 = 160
  L5_2 = L5_2(L6_2, L7_2, L8_2)
  L4_2.description = L5_2
  L4_2.amount = L2_2
  L5_2 = L13_1.ms
  L6_2 = A0_2.created
  if not L6_2 then
    L6_2 = A0_2.date
    if not L6_2 then
      L6_2 = A0_2.time
    end
  end
  L5_2 = L5_2(L6_2)
  L4_2.created = L5_2
  L4_2.bank = true
  return L4_2
end
function L17_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2
  L2_2 = FW
  L2_2 = L2_2.GetPlayer
  L3_2 = A0_2
  L2_2 = L2_2(L3_2)
  if not L2_2 then
    L3_2 = nil
    return L3_2
  end
  L3_2 = MySQL
  L3_2 = L3_2.query
  L3_2 = L3_2.await
  L4_2 = "SELECT * FROM apex_phone_transactions WHERE owner = ? ORDER BY created DESC LIMIT 60"
  L5_2 = {}
  L6_2 = L2_2.cid
  L5_2[1] = L6_2
  L3_2 = L3_2(L4_2, L5_2)
  if not L3_2 then
    L3_2 = {}
  end
  L4_2 = {}
  L5_2 = L15_1
  L6_2 = A0_2
  L7_2 = L2_2
  L5_2 = L5_2(L6_2, L7_2)
  L4_2.bank = L5_2
  L5_2 = L2_2.GetMoney
  L6_2 = "cash"
  L5_2 = L5_2(L6_2)
  L4_2.cash = L5_2
  L4_2.transactions = L3_2
  L4_2.provider = A1_2
  L5_2 = IntegrationTry
  L6_2 = "bank"
  L7_2 = "info"
  L8_2 = A0_2
  L9_2 = L2_2.cid
  L5_2, L6_2 = L5_2(L6_2, L7_2, L8_2, L9_2)
  if L5_2 then
    L7_2 = type
    L8_2 = L6_2
    L7_2 = L7_2(L8_2)
    if "table" == L7_2 then
      L7_2 = L6_2.iban
      if nil ~= L7_2 then
        L7_2 = tostring
        L8_2 = L6_2.iban
        L7_2 = L7_2(L8_2)
        if "" ~= L7_2 then
          L7_2 = tostring
          L8_2 = L6_2.iban
          L7_2 = L7_2(L8_2)
          L8_2 = L7_2
          L7_2 = L7_2.sub
          L9_2 = 1
          L10_2 = 40
          L7_2 = L7_2(L8_2, L9_2, L10_2)
          L4_2.iban = L7_2
        end
      end
      L7_2 = L13_1.num
      L8_2 = L6_2.savings
      L7_2 = L7_2(L8_2)
      if L7_2 then
        L8_2 = math
        L8_2 = L8_2.floor
        L9_2 = L7_2
        L8_2 = L8_2(L9_2)
        L4_2.savings = L8_2
      end
      L8_2 = L6_2.frozen
      L8_2 = true == L8_2
      L4_2.frozen = L8_2
      L8_2 = L6_2.noAccount
      if true == L8_2 then
        L4_2.noAccount = true
      end
    end
  end
  L7_2 = IntegrationTry
  L8_2 = "bank"
  L9_2 = "history"
  L10_2 = A0_2
  L11_2 = L2_2.cid
  L7_2, L8_2 = L7_2(L8_2, L9_2, L10_2, L11_2)
  if L7_2 then
    L9_2 = type
    L10_2 = L8_2
    L9_2 = L9_2(L10_2)
    if "table" == L9_2 then
      L9_2 = {}
      L10_2 = ipairs
      L11_2 = L8_2
      L10_2, L11_2, L12_2, L13_2 = L10_2(L11_2)
      for L14_2, L15_2 in L10_2, L11_2, L12_2, L13_2 do
        L16_2 = L16_1
        L17_2 = L15_2
        L18_2 = L14_2
        L16_2 = L16_2(L17_2, L18_2)
        if L16_2 then
          L17_2 = #L9_2
          L17_2 = L17_2 + 1
          L9_2[L17_2] = L16_2
        end
      end
      L10_2 = ipairs
      L11_2 = L3_2
      L10_2, L11_2, L12_2, L13_2 = L10_2(L11_2)
      for L14_2, L15_2 in L10_2, L11_2, L12_2, L13_2 do
        L16_2 = #L9_2
        L16_2 = L16_2 + 1
        L9_2[L16_2] = L15_2
      end
      L10_2 = table
      L10_2 = L10_2.sort
      L11_2 = L9_2
      function L12_2(A0_3, A1_3)
        local L2_3, L3_3, L4_3
        L2_3 = tonumber
        L3_3 = A0_3.created
        L2_3 = L2_3(L3_3)
        if not L2_3 then
          L2_3 = 0
        end
        L3_3 = tonumber
        L4_3 = A1_3.created
        L3_3 = L3_3(L4_3)
        if not L3_3 then
          L3_3 = 0
        end
        L2_3 = L2_3 > L3_3
        return L2_3
      end
      L10_2(L11_2, L12_2)
      while true do
        L10_2 = #L9_2
        if not (L10_2 > 80) then
          break
        end
        L10_2 = #L9_2
        L9_2[L10_2] = nil
      end
      L4_2.transactions = L9_2
    end
  end
  return L4_2
end
function L18_1(A0_2, A1_2, A2_2)
  local L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2, L19_2, L20_2, L21_2, L22_2, L23_2, L24_2, L25_2, L26_2, L27_2, L28_2, L29_2, L30_2
  L3_2 = FW
  L3_2 = L3_2.GetPlayer
  L4_2 = A0_2
  L3_2 = L3_2(L4_2)
  if not L3_2 then
    L4_2 = {}
    L4_2.ok = false
    L4_2.error = "noplayer"
    return L4_2
  end
  L4_2 = L2_1
  L5_2 = A1_2.amount
  L4_2 = L4_2(L5_2)
  if not L4_2 then
    L5_2 = {}
    L5_2.ok = false
    L5_2.error = "amount"
    return L5_2
  end
  L5_2 = ResolveTransferTarget
  L6_2 = A0_2
  L7_2 = A1_2.to
  L5_2, L6_2 = L5_2(L6_2, L7_2)
  if not L5_2 then
    L7_2 = {}
    L7_2.ok = false
    L7_2.error = L6_2
    return L7_2
  end
  L7_2 = L5_2.cid
  L8_2 = L3_2.cid
  if L7_2 == L8_2 then
    L8_2 = {}
    L8_2.ok = false
    L8_2.error = "self"
    return L8_2
  end
  L8_2 = L11_1
  L9_2 = L5_2
  L10_2 = tostring
  L11_2 = A1_2.to
  if not L11_2 then
    L11_2 = ""
  end
  L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2, L19_2, L20_2, L21_2, L22_2, L23_2, L24_2, L25_2, L26_2, L27_2, L28_2, L29_2, L30_2 = L10_2(L11_2)
  L8_2 = L8_2(L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2, L19_2, L20_2, L21_2, L22_2, L23_2, L24_2, L25_2, L26_2, L27_2, L28_2, L29_2, L30_2)
  L9_2 = L15_1
  L10_2 = A0_2
  L11_2 = L3_2
  L9_2 = L9_2(L10_2, L11_2)
  if L4_2 > L9_2 then
    L9_2 = {}
    L9_2.ok = false
    L9_2.error = "funds"
    return L9_2
  end
  L9_2 = A1_2.note
  if nil ~= L9_2 then
    L9_2 = tostring
    L10_2 = A1_2.note
    L9_2 = L9_2(L10_2)
    L10_2 = L9_2
    L9_2 = L9_2.sub
    L11_2 = 1
    L12_2 = 60
    L9_2 = L9_2(L10_2, L11_2, L12_2)
    if L9_2 then
      goto lbl_75
    end
  end
  L9_2 = ""
  ::lbl_75::
  L10_2 = GetPlayerNumber
  L11_2 = A0_2
  L10_2 = L10_2(L11_2)
  L11_2 = L3_2.firstname
  if not L11_2 then
    L11_2 = ""
  end
  L12_2 = " "
  L13_2 = L3_2.lastname
  if not L13_2 then
    L13_2 = ""
  end
  L11_2 = L11_2 .. L12_2 .. L13_2
  L12_2 = IntegrationTry
  L13_2 = "bank"
  L14_2 = "transfer"
  L15_2 = A0_2
  L16_2 = L3_2.cid
  L17_2 = L7_2
  L18_2 = L4_2
  L19_2 = L9_2
  L20_2 = L5_2.number
  L12_2, L13_2, L14_2 = L12_2(L13_2, L14_2, L15_2, L16_2, L17_2, L18_2, L19_2, L20_2)
  if L12_2 and nil ~= L13_2 then
    if true ~= L13_2 then
      L15_2 = type
      L16_2 = L13_2
      L15_2 = L15_2(L16_2)
      if "table" ~= L15_2 then
        goto lbl_152
      end
      L15_2 = L13_2.ok
      if true ~= L15_2 then
        goto lbl_152
      end
    end
    L15_2 = FW
    L15_2 = L15_2.GetPlayerByCid
    L16_2 = L7_2
    L15_2 = L15_2(L16_2)
    if L15_2 then
      L16_2 = Push
      L17_2 = L15_2.src
      L18_2 = "bank"
      L19_2 = {}
      L19_2.title = "Transfer\195\170ncia recebida"
      L20_2 = "Recebeste %s de %s"
      L21_2 = L20_2
      L20_2 = L20_2.format
      L22_2 = FormatMoney
      L23_2 = L4_2
      L22_2 = L22_2(L23_2)
      L23_2 = L11_2
      L20_2 = L20_2(L21_2, L22_2, L23_2)
      L19_2.msg = L20_2
      L16_2(L17_2, L18_2, L19_2)
    end
    L16_2 = {}
    L16_2.ok = true
    L17_2 = L15_1
    L18_2 = A0_2
    L19_2 = L3_2
    L17_2 = L17_2(L18_2, L19_2)
    L16_2.bank = L17_2
    L16_2.via = A2_2
    L17_2 = {}
    L18_2 = L5_2.number
    L17_2.number = L18_2
    L18_2 = L5_2.name
    L17_2.name = L18_2
    L18_2 = L5_2.kind
    L17_2.kind = L18_2
    L16_2.to = L17_2
    do return L16_2 end
    ::lbl_152::
    L15_2 = {}
    L15_2.ok = false
    L16_2 = tostring
    L17_2 = L14_2
    L16_2 = L16_2(L17_2)
    L17_2 = L14_1
    L16_2 = L17_2[L16_2]
    if not L16_2 then
      L16_2 = "target"
    end
    L15_2.error = L16_2
    L16_2 = L15_1
    L17_2 = A0_2
    L18_2 = L3_2
    L16_2 = L16_2(L17_2, L18_2)
    L15_2.bank = L16_2
    return L15_2
  end
  L15_2 = L3_2.RemoveMoney
  L16_2 = "bank"
  L17_2 = L4_2
  L18_2 = "phone-transfer"
  L15_2 = L15_2(L16_2, L17_2, L18_2)
  if not L15_2 then
    L15_2 = {}
    L15_2.ok = false
    L15_2.error = "funds"
    return L15_2
  end
  L15_2 = L1_1
  L16_2 = L7_2
  L17_2 = L4_2
  L18_2 = "phone-transfer"
  L15_2 = L15_2(L16_2, L17_2, L18_2)
  if not L15_2 then
    L15_2 = L3_2.AddMoney
    L16_2 = "bank"
    L17_2 = L4_2
    L18_2 = "phone-transfer-reposto"
    L15_2 = L15_2(L16_2, L17_2, L18_2)
    if not L15_2 then
      L15_2 = print
      L16_2 = "^1[unique_phone]^0 bank.transfer to %s failed and could not refund %s to %s"
      L17_2 = L16_2
      L16_2 = L16_2.format
      L18_2 = tostring
      L19_2 = L8_2
      L18_2 = L18_2(L19_2)
      L19_2 = FormatMoney
      L20_2 = L4_2
      L19_2 = L19_2(L20_2)
      L20_2 = tostring
      L21_2 = L3_2.cid
      L20_2, L21_2, L22_2, L23_2, L24_2, L25_2, L26_2, L27_2, L28_2, L29_2, L30_2 = L20_2(L21_2)
      L16_2, L17_2, L18_2, L19_2, L20_2, L21_2, L22_2, L23_2, L24_2, L25_2, L26_2, L27_2, L28_2, L29_2, L30_2 = L16_2(L17_2, L18_2, L19_2, L20_2, L21_2, L22_2, L23_2, L24_2, L25_2, L26_2, L27_2, L28_2, L29_2, L30_2)
      L15_2(L16_2, L17_2, L18_2, L19_2, L20_2, L21_2, L22_2, L23_2, L24_2, L25_2, L26_2, L27_2, L28_2, L29_2, L30_2)
      L15_2 = L0_1
      L16_2 = L3_2.cid
      L17_2 = "Transfer\195\170ncia falhada para "
      L18_2 = L8_2
      L19_2 = " \194\183 valor retido"
      L17_2 = L17_2 .. L18_2 .. L19_2
      L18_2 = -L4_2
      L15_2(L16_2, L17_2, L18_2)
    end
    L15_2 = {}
    L15_2.ok = false
    L15_2.error = "target"
    L16_2 = L3_2.GetMoney
    L17_2 = "bank"
    L16_2 = L16_2(L17_2)
    L15_2.bank = L16_2
    return L15_2
  end
  L15_2 = "Transfer\195\170ncia para "
  L16_2 = L8_2
  if "" ~= L9_2 then
    L17_2 = " \194\183 "
    L18_2 = L9_2
    L17_2 = L17_2 .. L18_2
    if L17_2 then
      goto lbl_237
    end
  end
  L17_2 = ""
  ::lbl_237::
  L15_2 = L15_2 .. L16_2 .. L17_2
  L16_2 = "Transfer\195\170ncia de "
  L17_2 = L11_2
  L18_2 = " ("
  L19_2 = tostring
  L20_2 = L10_2
  L19_2 = L19_2(L20_2)
  L20_2 = ")"
  if "" ~= L9_2 then
    L21_2 = " \194\183 "
    L22_2 = L9_2
    L21_2 = L21_2 .. L22_2
    if L21_2 then
      goto lbl_253
    end
  end
  L21_2 = ""
  ::lbl_253::
  L16_2 = L16_2 .. L17_2 .. L18_2 .. L19_2 .. L20_2 .. L21_2
  L17_2 = FW
  L17_2 = L17_2.GetPlayerByCid
  L18_2 = L7_2
  L17_2 = L17_2(L18_2)
  L18_2 = IntegrationHas
  L19_2 = "bank"
  L20_2 = "history"
  L18_2 = L18_2(L19_2, L20_2)
  L19_2 = IntegrationTry
  L20_2 = "bank"
  L21_2 = "record"
  L22_2 = L3_2.cid
  L23_2 = L15_2
  L24_2 = -L4_2
  L25_2 = A0_2
  L19_2, L20_2 = L19_2(L20_2, L21_2, L22_2, L23_2, L24_2, L25_2)
  if not (L18_2 and L19_2) or false == L20_2 then
    L21_2 = L0_1
    L22_2 = L3_2.cid
    L23_2 = L15_2
    L24_2 = -L4_2
    L21_2(L22_2, L23_2, L24_2)
  end
  L21_2 = IntegrationTry
  L22_2 = "bank"
  L23_2 = "record"
  L24_2 = L7_2
  L25_2 = L16_2
  L26_2 = L4_2
  if L17_2 then
    L27_2 = L17_2.src
    if L27_2 then
      goto lbl_293
    end
  end
  L27_2 = nil
  ::lbl_293::
  L21_2, L22_2 = L21_2(L22_2, L23_2, L24_2, L25_2, L26_2, L27_2)
  if not (L18_2 and L21_2) or false == L22_2 then
    L23_2 = L0_1
    L24_2 = L7_2
    L25_2 = L16_2
    L26_2 = L4_2
    L23_2(L24_2, L25_2, L26_2)
  end
  if L17_2 then
    L23_2 = Push
    L24_2 = L17_2.src
    L25_2 = "bank"
    L26_2 = {}
    L26_2.title = "Transfer\195\170ncia recebida"
    L27_2 = "Recebeste %s de %s"
    L28_2 = L27_2
    L27_2 = L27_2.format
    L29_2 = FormatMoney
    L30_2 = L4_2
    L29_2 = L29_2(L30_2)
    L30_2 = L11_2
    L27_2 = L27_2(L28_2, L29_2, L30_2)
    L26_2.msg = L27_2
    L23_2(L24_2, L25_2, L26_2)
  end
  L23_2 = {}
  L23_2.ok = true
  L24_2 = L15_1
  L25_2 = A0_2
  L26_2 = L3_2
  L24_2 = L24_2(L25_2, L26_2)
  L23_2.bank = L24_2
  L24_2 = {}
  L25_2 = L5_2.number
  L24_2.number = L25_2
  L25_2 = L5_2.name
  L24_2.name = L25_2
  L25_2 = L5_2.kind
  L24_2.kind = L25_2
  L23_2.to = L24_2
  return L23_2
end
L19_1 = RPC
function L20_1(A0_2)
  local L1_2, L2_2, L3_2, L4_2, L5_2
  L1_2 = Integration
  L2_2 = "bank"
  L1_2, L2_2 = L1_2(L2_2)
  if "builtin" == L2_2 then
    L3_2 = L8_1
    L4_2 = A0_2
    return L3_2(L4_2)
  end
  L3_2 = L17_1
  L4_2 = A0_2
  L5_2 = L2_2
  return L3_2(L4_2, L5_2)
end
L19_1["bank.info"] = L20_1
L19_1 = RPC
function L20_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2
  L2_2 = FW
  L2_2 = L2_2.GetPlayer
  L3_2 = A0_2
  L2_2 = L2_2(L3_2)
  if not L2_2 then
    L2_2 = {}
    L2_2.ok = false
    L2_2.error = "noplayer"
    return L2_2
  end
  L2_2 = ResolveTransferTarget
  L3_2 = A0_2
  L4_2 = type
  L5_2 = A1_2
  L4_2 = L4_2(L5_2)
  if "table" == L4_2 then
    L4_2 = A1_2.to
    if L4_2 then
      goto lbl_23
    end
  end
  L4_2 = nil
  ::lbl_23::
  L2_2, L3_2 = L2_2(L3_2, L4_2)
  if not L2_2 then
    L4_2 = {}
    L4_2.ok = false
    L4_2.error = L3_2
    return L4_2
  end
  L4_2 = {}
  L4_2.ok = true
  L5_2 = L2_2.kind
  L4_2.kind = L5_2
  L5_2 = L2_2.name
  L4_2.name = L5_2
  L5_2 = L2_2.number
  L4_2.number = L5_2
  L5_2 = L2_2.kind
  if "cid" == L5_2 then
    L5_2 = L2_2.cid
    if L5_2 then
      goto lbl_47
    end
  end
  L5_2 = nil
  ::lbl_47::
  L4_2.cid = L5_2
  return L4_2
end
L19_1["bank.resolve"] = L20_1
L19_1 = RPC
function L20_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2, L6_2, L7_2
  L2_2 = Integration
  L3_2 = "bank"
  L2_2, L3_2 = L2_2(L3_2)
  if "builtin" == L3_2 then
    L4_2 = L12_1
    L5_2 = A0_2
    L6_2 = A1_2
    return L4_2(L5_2, L6_2)
  end
  L4_2 = L18_1
  L5_2 = A0_2
  L6_2 = A1_2
  L7_2 = L3_2
  return L4_2(L5_2, L6_2, L7_2)
end
L19_1["bank.transfer"] = L20_1
function L19_1(A0_2, A1_2, A2_2, A3_2, A4_2)
  local L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2, L19_2, L20_2, L21_2
  if not A4_2 then
    L5_2 = {}
    A4_2 = L5_2
  end
  L5_2 = L2_1
  L6_2 = A2_2
  L5_2 = L5_2(L6_2)
  A2_2 = L5_2
  if not A2_2 or not A0_2 then
    L5_2 = nil
    return L5_2
  end
  L5_2 = Now
  L5_2 = L5_2()
  L6_2 = tostring
  L7_2 = A1_2 or L7_2
  if not A1_2 then
    L7_2 = "Sistema"
  end
  L6_2 = L6_2(L7_2)
  L7_2 = L6_2
  L6_2 = L6_2.sub
  L8_2 = 1
  L9_2 = 64
  L6_2 = L6_2(L7_2, L8_2, L9_2)
  A1_2 = L6_2
  if nil ~= A3_2 then
    L6_2 = tostring
    L7_2 = A3_2
    L6_2 = L6_2(L7_2)
    L7_2 = L6_2
    L6_2 = L6_2.sub
    L8_2 = 1
    L9_2 = 160
    L6_2 = L6_2(L7_2, L8_2, L9_2)
    if L6_2 then
      goto lbl_40
      A3_2 = L6_2 or A3_2
    end
  end
  A3_2 = nil
  ::lbl_40::
  L6_2 = A4_2.society
  if nil ~= L6_2 then
    L6_2 = A4_2.society
    if "" ~= L6_2 then
      L6_2 = tostring
      L7_2 = A4_2.society
      L6_2 = L6_2(L7_2)
      L7_2 = L6_2
      L6_2 = L6_2.sub
      L8_2 = 1
      L9_2 = 50
      L6_2 = L6_2(L7_2, L8_2, L9_2)
      if L6_2 then
        goto lbl_56
      end
    end
  end
  L6_2 = nil
  ::lbl_56::
  L7_2 = MySQL
  L7_2 = L7_2.insert
  L7_2 = L7_2.await
  L8_2 = "INSERT INTO apex_phone_bills (owner, sender, sender_name, sender_cid, society, amount, reason, status, created) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)"
  L9_2 = {}
  L10_2 = A0_2
  L11_2 = A4_2.sender
  L12_2 = A1_2
  L13_2 = A4_2.senderCid
  L14_2 = L6_2
  L15_2 = A2_2
  L16_2 = A3_2
  L17_2 = "pending"
  L18_2 = L5_2
  L9_2[1] = L10_2
  L9_2[2] = L11_2
  L9_2[3] = L12_2
  L9_2[4] = L13_2
  L9_2[5] = L14_2
  L9_2[6] = L15_2
  L9_2[7] = L16_2
  L9_2[8] = L17_2
  L9_2[9] = L18_2
  L7_2 = L7_2(L8_2, L9_2)
  if not L7_2 then
    L8_2 = nil
    return L8_2
  end
  L8_2 = {}
  L8_2.id = L7_2
  L8_2.owner = A0_2
  L9_2 = A4_2.sender
  L8_2.sender = L9_2
  L8_2.sender_name = A1_2
  L9_2 = A4_2.senderCid
  L8_2.sender_cid = L9_2
  L8_2.society = L6_2
  L8_2.amount = A2_2
  L8_2.reason = A3_2
  L8_2.status = "pending"
  L8_2.created = L5_2
  L9_2 = FW
  L9_2 = L9_2.GetPlayerByCid
  L10_2 = A0_2
  L9_2 = L9_2(L10_2)
  if L9_2 then
    L10_2 = Push
    L11_2 = L9_2.src
    L12_2 = "bill"
    L13_2 = L8_2
    L10_2(L11_2, L12_2, L13_2)
  end
  L10_2 = Config
  L10_2 = L10_2.AutoMails
  if L10_2 then
    L10_2 = type
    L11_2 = Config
    L11_2 = L11_2.BillMail
    L10_2 = L10_2(L11_2)
    if "table" == L10_2 then
      L10_2 = Config
      L10_2 = L10_2.BillMail
      if L10_2 then
        goto lbl_118
      end
    end
    L10_2 = {}
    ::lbl_118::
    L11_2 = SendMailInternal
    L12_2 = A0_2
    L13_2 = A1_2 or L13_2
    if not A1_2 then
      L13_2 = L10_2.sender
      if not L13_2 then
        L13_2 = "Bills"
      end
    end
    L14_2 = L10_2.email
    if not L14_2 then
      L14_2 = "bills@arshiahub.ir"
    end
    L15_2 = L10_2.subject
    if not L15_2 then
      L15_2 = "New bill: %s"
    end
    L16_2 = L15_2
    L15_2 = L15_2.format
    L17_2 = tostring
    L18_2 = A3_2 or L18_2
    if not A3_2 then
      L18_2 = ""
    end
    L17_2, L18_2, L19_2, L20_2, L21_2 = L17_2(L18_2)
    L15_2 = L15_2(L16_2, L17_2, L18_2, L19_2, L20_2, L21_2)
    L16_2 = L10_2.body
    if not L16_2 then
      L16_2 = [[
You received a bill of %s from %s.

Reason: %s

You can pay it in the Bills app.]]
    end
    L17_2 = L16_2
    L16_2 = L16_2.format
    L18_2 = FormatMoney
    L19_2 = A2_2
    L18_2 = L18_2(L19_2)
    L19_2 = tostring
    L20_2 = A1_2
    L19_2 = L19_2(L20_2)
    L20_2 = tostring
    L21_2 = A3_2 or L21_2
    if not A3_2 then
      L21_2 = "-"
    end
    L20_2, L21_2 = L20_2(L21_2)
    L16_2, L17_2, L18_2, L19_2, L20_2, L21_2 = L16_2(L17_2, L18_2, L19_2, L20_2, L21_2)
    L11_2(L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2, L19_2, L20_2, L21_2)
  end
  return L8_2
end
CreateBillInternal = L19_1
function L19_1(A0_2)
  local L1_2, L2_2, L3_2, L4_2, L5_2
  L1_2 = MySQL
  L1_2 = L1_2.query
  L1_2 = L1_2.await
  L2_2 = "SELECT * FROM apex_phone_bills WHERE owner = ? ORDER BY created DESC LIMIT 100"
  L3_2 = {}
  L4_2 = GetCid
  L5_2 = A0_2
  L4_2, L5_2 = L4_2(L5_2)
  L3_2[1] = L4_2
  L3_2[2] = L5_2
  L1_2 = L1_2(L2_2, L3_2)
  if not L1_2 then
    L1_2 = {}
  end
  return L1_2
end
function L20_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2
  L2_2 = FW
  L2_2 = L2_2.GetPlayer
  L3_2 = A0_2
  L2_2 = L2_2(L3_2)
  if not L2_2 then
    L3_2 = {}
    L3_2.ok = false
    return L3_2
  end
  L3_2 = L2_2.cid
  L4_2 = L2_1
  L5_2 = A1_2.id
  L4_2 = L4_2(L5_2)
  if not L4_2 then
    L5_2 = {}
    L5_2.ok = false
    L5_2.error = "invalid"
    return L5_2
  end
  L5_2 = MySQL
  L5_2 = L5_2.single
  L5_2 = L5_2.await
  L6_2 = "SELECT * FROM apex_phone_bills WHERE id = ? AND owner = ?"
  L7_2 = {}
  L8_2 = L4_2
  L9_2 = L3_2
  L7_2[1] = L8_2
  L7_2[2] = L9_2
  L5_2 = L5_2(L6_2, L7_2)
  if L5_2 then
    L6_2 = L5_2.status
    if "pending" == L6_2 then
      goto lbl_42
    end
  end
  L6_2 = {}
  L6_2.ok = false
  L6_2.error = "invalid"
  do return L6_2 end
  ::lbl_42::
  L6_2 = L2_1
  L7_2 = L5_2.amount
  L6_2 = L6_2(L7_2)
  if not L6_2 then
    L7_2 = {}
    L7_2.ok = false
    L7_2.error = "invalid"
    return L7_2
  end
  L7_2 = L2_2.GetMoney
  L8_2 = "bank"
  L7_2 = L7_2(L8_2)
  if L6_2 > L7_2 then
    L7_2 = {}
    L7_2.ok = false
    L7_2.error = "funds"
    return L7_2
  end
  L7_2 = MySQL
  L7_2 = L7_2.update
  L7_2 = L7_2.await
  L8_2 = "UPDATE apex_phone_bills SET status = ?, paid_at = ? WHERE id = ? AND owner = ? AND status = ?"
  L9_2 = {}
  L10_2 = "paid"
  L11_2 = Now
  L11_2 = L11_2()
  L12_2 = L4_2
  L13_2 = L3_2
  L14_2 = "pending"
  L9_2[1] = L10_2
  L9_2[2] = L11_2
  L9_2[3] = L12_2
  L9_2[4] = L13_2
  L9_2[5] = L14_2
  L7_2 = L7_2(L8_2, L9_2)
  L8_2 = tonumber
  L9_2 = L7_2
  L8_2 = L8_2(L9_2)
  if not L8_2 then
    L8_2 = 0
  end
  if 1 ~= L8_2 then
    L8_2 = {}
    L8_2.ok = false
    L8_2.error = "invalid"
    return L8_2
  end
  L8_2 = L2_2.RemoveMoney
  L9_2 = "bank"
  L10_2 = L6_2
  L11_2 = "bill-"
  L12_2 = tostring
  L13_2 = L5_2.sender_name
  L12_2 = L12_2(L13_2)
  L11_2 = L11_2 .. L12_2
  L8_2 = L8_2(L9_2, L10_2, L11_2)
  if not L8_2 then
    L8_2 = MySQL
    L8_2 = L8_2.update
    L8_2 = L8_2.await
    L9_2 = "UPDATE apex_phone_bills SET status = ?, paid_at = NULL WHERE id = ? AND status = ?"
    L10_2 = {}
    L11_2 = "pending"
    L12_2 = L4_2
    L13_2 = "paid"
    L10_2[1] = L11_2
    L10_2[2] = L12_2
    L10_2[3] = L13_2
    L8_2(L9_2, L10_2)
    L8_2 = {}
    L8_2.ok = false
    L8_2.error = "funds"
    return L8_2
  end
  L5_2.status = "paid"
  L8_2 = nil
  L9_2 = L5_2.society
  if L9_2 then
    L9_2 = L5_2.society
    if "" ~= L9_2 then
      L9_2 = FW
      L9_2 = L9_2.AddSocietyMoney
      L10_2 = L5_2.society
      L11_2 = L6_2
      L12_2 = "apex_phone bill"
      L9_2 = L9_2(L10_2, L11_2, L12_2)
      if L9_2 then
        L8_2 = "society"
    end
  end
  else
    L9_2 = L5_2.sender_cid
    if L9_2 then
      L9_2 = L5_2.sender_cid
      if "" ~= L9_2 then
        L9_2 = L1_1
        L10_2 = L5_2.sender_cid
        L11_2 = L6_2
        L12_2 = "bill-paid"
        L9_2 = L9_2(L10_2, L11_2, L12_2)
        if L9_2 then
          L8_2 = "sender"
          L9_2 = L0_1
          L10_2 = L5_2.sender_cid
          L11_2 = "Fatura paga por "
          L12_2 = tostring
          L13_2 = GetPlayerNumber
          L14_2 = A0_2
          L13_2, L14_2, L15_2, L16_2, L17_2 = L13_2(L14_2)
          L12_2 = L12_2(L13_2, L14_2, L15_2, L16_2, L17_2)
          L11_2 = L11_2 .. L12_2
          L12_2 = L6_2
          L9_2(L10_2, L11_2, L12_2)
        else
          L9_2 = L2_2.AddMoney
          L10_2 = "bank"
          L11_2 = L6_2
          L12_2 = "bill-reposto"
          L9_2 = L9_2(L10_2, L11_2, L12_2)
          if L9_2 then
            L9_2 = MySQL
            L9_2 = L9_2.update
            L9_2 = L9_2.await
            L10_2 = "UPDATE apex_phone_bills SET status = ?, paid_at = NULL WHERE id = ? AND status = ?"
            L11_2 = {}
            L12_2 = "pending"
            L13_2 = L4_2
            L14_2 = "paid"
            L11_2[1] = L12_2
            L11_2[2] = L13_2
            L11_2[3] = L14_2
            L9_2(L10_2, L11_2)
            L9_2 = {}
            L9_2.ok = false
            L9_2.error = "target"
            L10_2 = L2_2.GetMoney
            L11_2 = "bank"
            L10_2 = L10_2(L11_2)
            L9_2.bank = L10_2
            return L9_2
          end
          L9_2 = print
          L10_2 = "^1[unique_phone]^0 invoice %d: the issuer %s does not exist and could not refund %s to %s; the invoice stays PAID with no recipient so it is not charged twice"
          L11_2 = L10_2
          L10_2 = L10_2.format
          L12_2 = L4_2
          L13_2 = tostring
          L14_2 = L5_2.sender_cid
          L13_2 = L13_2(L14_2)
          L14_2 = FormatMoney
          L15_2 = L6_2
          L14_2 = L14_2(L15_2)
          L15_2 = tostring
          L16_2 = L3_2
          L15_2, L16_2, L17_2 = L15_2(L16_2)
          L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2 = L10_2(L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2)
          L9_2(L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2)
        end
      end
    end
  end
  L9_2 = L0_1
  L10_2 = L3_2
  L11_2 = "Fatura: "
  L12_2 = tostring
  L13_2 = L5_2.sender_name
  L12_2 = L12_2(L13_2)
  L11_2 = L11_2 .. L12_2
  L12_2 = -L6_2
  L9_2(L10_2, L11_2, L12_2)
  L9_2 = L5_2.sender_cid
  if L9_2 then
    L9_2 = L5_2.sender_cid
    if "" ~= L9_2 then
      L9_2 = NotifyCitizen
      L10_2 = L5_2.sender_cid
      L11_2 = "billing"
      L12_2 = "Fatura paga"
      L13_2 = "%s \194\183 %s"
      L14_2 = L13_2
      L13_2 = L13_2.format
      L15_2 = FormatMoney
      L16_2 = L6_2
      L15_2 = L15_2(L16_2)
      L16_2 = tostring
      L17_2 = L5_2.reason
      if not L17_2 then
        L17_2 = ""
      end
      L16_2, L17_2 = L16_2(L17_2)
      L13_2 = L13_2(L14_2, L15_2, L16_2, L17_2)
      L14_2 = nil
      L15_2 = {}
      L15_2.throttle = false
      L9_2(L10_2, L11_2, L12_2, L13_2, L14_2, L15_2)
    end
  end
  L5_2.paid_to = L8_2
  L9_2 = TriggerEvent
  L10_2 = "apex_phone:billPaid"
  L11_2 = A0_2
  L12_2 = L5_2
  L9_2(L10_2, L11_2, L12_2)
  L9_2 = {}
  L9_2.ok = true
  L10_2 = L2_2.GetMoney
  L11_2 = "bank"
  L10_2 = L10_2(L11_2)
  L9_2.bank = L10_2
  return L9_2
end
function L21_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2
  L2_2 = L2_1
  L3_2 = A1_2.id
  L2_2 = L2_2(L3_2)
  if not L2_2 then
    L3_2 = {}
    L3_2.ok = false
    return L3_2
  end
  L3_2 = GetCid
  L4_2 = A0_2
  L3_2 = L3_2(L4_2)
  L4_2 = MySQL
  L4_2 = L4_2.single
  L4_2 = L4_2.await
  L5_2 = "SELECT * FROM apex_phone_bills WHERE id = ? AND owner = ?"
  L6_2 = {}
  L7_2 = L2_2
  L8_2 = L3_2
  L6_2[1] = L7_2
  L6_2[2] = L8_2
  L4_2 = L4_2(L5_2, L6_2)
  if L4_2 then
    L5_2 = L4_2.status
    if "pending" == L5_2 then
      goto lbl_32
    end
  end
  L5_2 = {}
  L5_2.ok = false
  do return L5_2 end
  ::lbl_32::
  L5_2 = MySQL
  L5_2 = L5_2.update
  L5_2 = L5_2.await
  L6_2 = "UPDATE apex_phone_bills SET status = ? WHERE id = ? AND owner = ? AND status = ?"
  L7_2 = {}
  L8_2 = "refused"
  L9_2 = L2_2
  L10_2 = L3_2
  L11_2 = "pending"
  L7_2[1] = L8_2
  L7_2[2] = L9_2
  L7_2[3] = L10_2
  L7_2[4] = L11_2
  L5_2 = L5_2(L6_2, L7_2)
  L6_2 = tonumber
  L7_2 = L5_2
  L6_2 = L6_2(L7_2)
  if not L6_2 then
    L6_2 = 0
  end
  if 1 ~= L6_2 then
    L6_2 = {}
    L6_2.ok = false
    return L6_2
  end
  L4_2.status = "refused"
  L6_2 = L4_2.sender_cid
  if L6_2 then
    L6_2 = NotifyCitizen
    L7_2 = L4_2.sender_cid
    L8_2 = "billing"
    L9_2 = "Fatura recusada"
    L10_2 = "%s \194\183 %s"
    L11_2 = L10_2
    L10_2 = L10_2.format
    L12_2 = FormatMoney
    L13_2 = L4_2.amount
    L12_2 = L12_2(L13_2)
    L13_2 = tostring
    L14_2 = L4_2.reason
    if not L14_2 then
      L14_2 = ""
    end
    L13_2, L14_2 = L13_2(L14_2)
    L10_2 = L10_2(L11_2, L12_2, L13_2, L14_2)
    L11_2 = nil
    L12_2 = {}
    L12_2.throttle = false
    L6_2(L7_2, L8_2, L9_2, L10_2, L11_2, L12_2)
  end
  L6_2 = TriggerEvent
  L7_2 = "apex_phone:billRefused"
  L8_2 = A0_2
  L9_2 = L4_2
  L6_2(L7_2, L8_2, L9_2)
  L6_2 = {}
  L6_2.ok = true
  return L6_2
end
L22_1 = {}
L23_1 = AddEventHandler
L24_1 = "playerDropped"
function L25_1()
  local L0_2, L1_2
  L1_2 = source
  L0_2 = L22_1
  L0_2[L1_2] = nil
end
L23_1(L24_1, L25_1)
function L23_1(A0_2, A1_2, A2_2)
  local L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2, L19_2, L20_2
  L3_2 = FW
  L3_2 = L3_2.GetPlayer
  L4_2 = A0_2
  L3_2 = L3_2(L4_2)
  if not L3_2 then
    L4_2 = {}
    L4_2.error = "noplayer"
    return L4_2
  end
  L4_2 = L3_1
  L4_2 = L4_2()
  L5_2 = L2_1
  L6_2 = A1_2.amount
  L5_2 = L5_2(L6_2)
  if L5_2 then
    L6_2 = tonumber
    L7_2 = A1_2.amount
    L6_2 = L6_2(L7_2)
    if L6_2 == L5_2 then
      goto lbl_27
    end
  end
  L6_2 = {}
  L6_2.error = "amount"
  do return L6_2 end
  ::lbl_27::
  L6_2 = L4_2.maxAmount
  if L5_2 > L6_2 then
    L6_2 = {}
    L6_2.error = "amount"
    L7_2 = L4_2.maxAmount
    L6_2.max = L7_2
    return L6_2
  end
  L6_2 = L3_2.firstname
  if not L6_2 then
    L6_2 = ""
  end
  L7_2 = " "
  L8_2 = L3_2.lastname
  if not L8_2 then
    L8_2 = ""
  end
  L6_2 = L6_2 .. L7_2 .. L8_2
  L7_2 = L6_2
  L6_2 = L6_2.gsub
  L8_2 = "%s+$"
  L9_2 = ""
  L6_2 = L6_2(L7_2, L8_2, L9_2)
  L7_2 = L3_2.job
  if not L7_2 then
    L7_2 = {}
  end
  L8_2 = nil
  L9_2 = A1_2.society
  if nil ~= L9_2 then
    L9_2 = A1_2.society
    if "" ~= L9_2 then
      L9_2 = A1_2.society
      if false ~= L9_2 then
        L9_2 = tostring
        L10_2 = A1_2.society
        L9_2 = L9_2(L10_2)
        L10_2 = L9_2
        L9_2 = L9_2.sub
        L11_2 = 1
        L12_2 = 50
        L9_2 = L9_2(L10_2, L11_2, L12_2)
        L8_2 = L9_2
        L9_2 = L7_2.name
        if L8_2 == L9_2 then
          L9_2 = L7_2.name
          if "unemployed" ~= L9_2 then
            goto lbl_83
          end
        end
        L9_2 = {}
        L9_2.error = "society"
        do return L9_2 end
        ::lbl_83::
        L9_2 = L4_2.minGrade
        L10_2 = L4_2.societyJobs
        if L10_2 then
          L10_2 = L4_2.societyJobs
          L11_2 = L7_2.name
          L9_2 = L10_2[L11_2]
          if nil == L9_2 then
            L10_2 = {}
            L10_2.error = "society"
            return L10_2
          end
          L10_2 = tonumber
          L11_2 = L9_2
          L10_2 = L10_2(L11_2)
          L9_2 = L10_2 or L9_2
          if not L10_2 then
            L9_2 = 0
          end
        end
        L10_2 = tonumber
        L11_2 = L7_2.gradeLevel
        L10_2 = L10_2(L11_2)
        if not L10_2 then
          L10_2 = 0
        end
        if L9_2 > L10_2 then
          L10_2 = {}
          L10_2.error = "grade"
          return L10_2
        end
      end
    end
  end
  if L8_2 then
    L9_2 = L7_2.label
    if not L9_2 then
      L9_2 = L8_2
    end
    L10_2 = " \194\183 "
    L11_2 = L6_2
    L9_2 = L9_2 .. L10_2 .. L11_2
    if L9_2 then
      goto lbl_126
    end
  end
  L9_2 = L6_2
  ::lbl_126::
  L10_2 = os
  L10_2 = L10_2.time
  L10_2 = L10_2()
  L11_2 = L22_1
  L11_2 = L11_2[A0_2]
  if L11_2 then
    L12_2 = L10_2 - L11_2
    L13_2 = L4_2.cooldown
    if L12_2 < L13_2 then
      L12_2 = {}
      L12_2.error = "cooldown"
      return L12_2
    end
  end
  L12_2 = L22_1
  L12_2[A0_2] = L10_2
  L12_2 = GetCitizenIdByNumber
  L13_2 = tostring
  L14_2 = A1_2.to
  if not L14_2 then
    L14_2 = ""
  end
  L13_2 = L13_2(L14_2)
  L14_2 = L13_2
  L13_2 = L13_2.sub
  L15_2 = 1
  L16_2 = 20
  L13_2, L14_2, L15_2, L16_2, L17_2, L18_2, L19_2, L20_2 = L13_2(L14_2, L15_2, L16_2)
  L12_2 = L12_2(L13_2, L14_2, L15_2, L16_2, L17_2, L18_2, L19_2, L20_2)
  if L12_2 then
    L13_2 = L3_2.cid
    if L12_2 ~= L13_2 then
      goto lbl_177
    end
  end
  L13_2 = L22_1
  L13_2 = L13_2[A0_2]
  if L13_2 == L10_2 then
    L13_2 = L22_1
    L13_2[A0_2] = L11_2
  end
  L13_2 = {}
  if L12_2 then
    L14_2 = "self"
    if L14_2 then
      goto lbl_175
    end
  end
  L14_2 = "target"
  ::lbl_175::
  L13_2.error = L14_2
  do return L13_2 end
  ::lbl_177::
  L13_2 = A2_2 or L13_2
  if not A2_2 then
    L13_2 = CreateBillInternal
  end
  L14_2 = L12_2
  L15_2 = L9_2
  L16_2 = L5_2
  L17_2 = A1_2.reason
  if nil ~= L17_2 then
    L17_2 = tostring
    L18_2 = A1_2.reason
    L17_2 = L17_2(L18_2)
    L18_2 = L17_2
    L17_2 = L17_2.sub
    L19_2 = 1
    L20_2 = 160
    L17_2 = L17_2(L18_2, L19_2, L20_2)
    if L17_2 then
      goto lbl_196
    end
  end
  L17_2 = nil
  ::lbl_196::
  L18_2 = {}
  L19_2 = L3_2.cid
  L18_2.senderCid = L19_2
  L18_2.society = L8_2
  L13_2 = L13_2(L14_2, L15_2, L16_2, L17_2, L18_2)
  L14_2 = L13_2 or L14_2
  if not L13_2 then
    L14_2 = {}
    L14_2.error = "invalid"
  end
  return L14_2
end
function L24_1(A0_2)
  local L1_2, L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2
  L1_2 = GetCid
  L2_2 = A0_2
  L1_2 = L1_2(L2_2)
  if not L1_2 then
    L2_2 = {}
    return L2_2
  end
  L2_2 = MySQL
  L2_2 = L2_2.query
  L2_2 = L2_2.await
  L3_2 = "SELECT id, owner, sender_name, society, amount, reason, status, created, paid_at FROM apex_phone_bills WHERE sender_cid = ? ORDER BY created DESC LIMIT 100"
  L4_2 = {}
  L5_2 = L1_2
  L4_2[1] = L5_2
  L2_2 = L2_2(L3_2, L4_2)
  if not L2_2 then
    L2_2 = {}
  end
  L3_2 = type
  L4_2 = OnlineCidIndex
  L3_2 = L3_2(L4_2)
  if "function" == L3_2 then
    L3_2 = OnlineCidIndex
    L3_2 = L3_2()
    if L3_2 then
      goto lbl_32
    end
  end
  L3_2 = nil
  ::lbl_32::
  L4_2 = {}
  L5_2 = {}
  L6_2 = {}
  L7_2 = ipairs
  L8_2 = L2_2
  L7_2, L8_2, L9_2, L10_2 = L7_2(L8_2)
  for L11_2, L12_2 in L7_2, L8_2, L9_2, L10_2 do
    L13_2 = L12_2.owner
    if nil ~= L13_2 then
      L14_2 = L4_2[L13_2]
      if nil == L14_2 then
        L14_2 = nil
        if nil ~= L3_2 then
          L15_2 = L3_2[L13_2]
          if nil == L15_2 then
            goto lbl_59
          end
        end
        L15_2 = FW
        L15_2 = L15_2.GetPlayerByCid
        L16_2 = L13_2
        L15_2 = L15_2(L16_2)
        L14_2 = L15_2
        ::lbl_59::
        if L14_2 then
          L15_2 = L14_2.firstname
          if not L15_2 then
            L15_2 = ""
          end
          L16_2 = " "
          L17_2 = L14_2.lastname
          if not L17_2 then
            L17_2 = ""
          end
          L15_2 = L15_2 .. L16_2 .. L17_2
          L16_2 = L15_2
          L15_2 = L15_2.gsub
          L17_2 = "^%s+"
          L18_2 = ""
          L15_2 = L15_2(L16_2, L17_2, L18_2)
          L16_2 = L15_2
          L15_2 = L15_2.gsub
          L17_2 = "%s+$"
          L18_2 = ""
          L15_2 = L15_2(L16_2, L17_2, L18_2)
          if L15_2 then
            goto lbl_82
          end
        end
        L15_2 = ""
        ::lbl_82::
        L16_2 = {}
        L17_2 = GetNumberByCitizenId
        L18_2 = L13_2
        L17_2 = L17_2(L18_2)
        L16_2.number = L17_2
        L16_2.name = L15_2
        L4_2[L13_2] = L16_2
        if "" == L15_2 then
          L16_2 = #L5_2
          L16_2 = L16_2 + 1
          L5_2[L16_2] = L13_2
          L16_2 = #L6_2
          L16_2 = L16_2 + 1
          L6_2[L16_2] = "?"
        end
      end
    end
  end
  L7_2 = #L5_2
  if L7_2 > 0 then
    L7_2 = MySQL
    L7_2 = L7_2.query
    L7_2 = L7_2.await
    L8_2 = "SELECT citizenid, username FROM apex_phone_accounts WHERE citizenid IN (%s)"
    L9_2 = L8_2
    L8_2 = L8_2.format
    L10_2 = table
    L10_2 = L10_2.concat
    L11_2 = L6_2
    L12_2 = ","
    L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2 = L10_2(L11_2, L12_2)
    L8_2 = L8_2(L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2)
    L9_2 = L5_2
    L7_2 = L7_2(L8_2, L9_2)
    if not L7_2 then
      L7_2 = {}
    end
    L8_2 = ipairs
    L9_2 = L7_2
    L8_2, L9_2, L10_2, L11_2 = L8_2(L9_2)
    for L12_2, L13_2 in L8_2, L9_2, L10_2, L11_2 do
      L14_2 = L13_2.citizenid
      L14_2 = L4_2[L14_2]
      if L14_2 then
        L15_2 = L14_2.name
        if "" == L15_2 then
          L15_2 = L13_2.username
          if L15_2 then
            L15_2 = L13_2.username
            if "" ~= L15_2 then
              L15_2 = "@"
              L16_2 = tostring
              L17_2 = L13_2.username
              L16_2 = L16_2(L17_2)
              L15_2 = L15_2 .. L16_2
              L14_2.name = L15_2
            end
          end
        end
      end
    end
  end
  L7_2 = {}
  L8_2 = ipairs
  L9_2 = L2_2
  L8_2, L9_2, L10_2, L11_2 = L8_2(L9_2)
  for L12_2, L13_2 in L8_2, L9_2, L10_2, L11_2 do
    L14_2 = L13_2.owner
    L14_2 = L4_2[L14_2]
    if not L14_2 then
      L14_2 = {}
      L14_2.name = ""
    end
    L15_2 = L14_2.name
    L16_2 = {}
    L17_2 = L13_2.id
    L16_2.id = L17_2
    L17_2 = L14_2.number
    L16_2.to = L17_2
    L17_2 = L15_2 or L17_2
    if "" == L15_2 or not L15_2 then
      L17_2 = nil
    end
    L16_2.to_name = L17_2
    L17_2 = L13_2.sender_name
    L16_2.sender_name = L17_2
    L17_2 = L13_2.society
    L16_2.society = L17_2
    L17_2 = L13_2.amount
    L16_2.amount = L17_2
    L17_2 = L13_2.reason
    L16_2.reason = L17_2
    L17_2 = L13_2.status
    L16_2.status = L17_2
    L17_2 = L13_2.created
    L16_2.created = L17_2
    L17_2 = L13_2.paid_at
    L16_2.paid_at = L17_2
    L7_2[L12_2] = L16_2
  end
  return L7_2
end
function L25_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2
  L2_2 = GetCid
  L3_2 = A0_2
  L2_2 = L2_2(L3_2)
  if not L2_2 then
    L3_2 = {}
    L3_2.ok = false
    return L3_2
  end
  L3_2 = L2_1
  L4_2 = A1_2.id
  L3_2 = L3_2(L4_2)
  if not L3_2 then
    L4_2 = {}
    L4_2.ok = false
    return L4_2
  end
  L4_2 = MySQL
  L4_2 = L4_2.single
  L4_2 = L4_2.await
  L5_2 = "SELECT * FROM apex_phone_bills WHERE id = ? AND sender_cid = ?"
  L6_2 = {}
  L7_2 = L3_2
  L8_2 = L2_2
  L6_2[1] = L7_2
  L6_2[2] = L8_2
  L4_2 = L4_2(L5_2, L6_2)
  if L4_2 then
    L5_2 = L4_2.status
    if "pending" == L5_2 then
      goto lbl_39
    end
  end
  L5_2 = {}
  L5_2.ok = false
  L5_2.error = "invalid"
  do return L5_2 end
  ::lbl_39::
  L5_2 = MySQL
  L5_2 = L5_2.update
  L5_2 = L5_2.await
  L6_2 = "UPDATE apex_phone_bills SET status = ? WHERE id = ? AND sender_cid = ? AND status = ?"
  L7_2 = {}
  L8_2 = "cancelled"
  L9_2 = L3_2
  L10_2 = L2_2
  L11_2 = "pending"
  L7_2[1] = L8_2
  L7_2[2] = L9_2
  L7_2[3] = L10_2
  L7_2[4] = L11_2
  L5_2 = L5_2(L6_2, L7_2)
  L6_2 = tonumber
  L7_2 = L5_2
  L6_2 = L6_2(L7_2)
  if not L6_2 then
    L6_2 = 0
  end
  if 1 ~= L6_2 then
    L6_2 = {}
    L6_2.ok = false
    L6_2.error = "invalid"
    return L6_2
  end
  L6_2 = NotifyCitizen
  L7_2 = L4_2.owner
  L8_2 = "billing"
  L9_2 = "Fatura anulada"
  L10_2 = "%s \194\183 %s"
  L11_2 = L10_2
  L10_2 = L10_2.format
  L12_2 = FormatMoney
  L13_2 = L4_2.amount
  L12_2 = L12_2(L13_2)
  L13_2 = tostring
  L14_2 = L4_2.sender_name
  if not L14_2 then
    L14_2 = ""
  end
  L13_2, L14_2 = L13_2(L14_2)
  L10_2 = L10_2(L11_2, L12_2, L13_2, L14_2)
  L11_2 = nil
  L12_2 = {}
  L12_2.throttle = false
  L6_2(L7_2, L8_2, L9_2, L10_2, L11_2, L12_2)
  L6_2 = FW
  L6_2 = L6_2.GetPlayerByCid
  L7_2 = L4_2.owner
  L6_2 = L6_2(L7_2)
  if L6_2 then
    L7_2 = Push
    L8_2 = L6_2.src
    L9_2 = "bill"
    L10_2 = {}
    L10_2.id = L3_2
    L10_2.status = "cancelled"
    L10_2.cancelled = true
    L11_2 = L4_2.amount
    L10_2.amount = L11_2
    L11_2 = L4_2.sender_name
    L10_2.sender_name = L11_2
    L7_2(L8_2, L9_2, L10_2)
  end
  L7_2 = {}
  L7_2.ok = true
  return L7_2
end
L26_1 = L13_1.defineBuiltin
L27_1 = "billing"
L28_1 = {}
L28_1.label = "Phone bills (apex_phone_bills)"
function L29_1(A0_2)
  local L1_2, L2_2
  L1_2 = L19_1
  L2_2 = A0_2
  return L1_2(L2_2)
end
L28_1.list = L29_1
L26_1(L27_1, L28_1)
L26_1 = {}
L26_1.pending = "pending"
L26_1.unpaid = "pending"
L26_1.open = "pending"
L26_1["0"] = "pending"
L26_1.paid = "paid"
L26_1.autopaid = "paid"
L26_1["1"] = "paid"
L26_1.refused = "refused"
L26_1.rejected = "refused"
L26_1.declined = "refused"
L26_1.cancelled = "cancelled"
L26_1.canceled = "cancelled"
L26_1.deleted = "cancelled"
function L27_1(A0_2)
  local L1_2, L2_2
  if true == A0_2 then
    L1_2 = "paid"
    return L1_2
  end
  if nil == A0_2 or false == A0_2 then
    L1_2 = "pending"
    return L1_2
  end
  L1_2 = tostring
  L2_2 = A0_2
  L1_2 = L1_2(L2_2)
  L2_2 = L1_2
  L1_2 = L1_2.lower
  L1_2 = L1_2(L2_2)
  L2_2 = L26_1
  L1_2 = L2_2[L1_2]
  if not L1_2 then
    L1_2 = "pending"
  end
  return L1_2
end
function L28_1(A0_2)
  local L1_2, L2_2, L3_2, L4_2, L5_2
  L1_2 = type
  L2_2 = A0_2
  L1_2 = L1_2(L2_2)
  if "string" ~= L1_2 then
    L1_2 = nil
    return L1_2
  end
  L2_2 = A0_2
  L1_2 = A0_2.match
  L3_2 = "^x:(.+)$"
  L1_2 = L1_2(L2_2, L3_2)
  if L1_2 then
    L3_2 = L1_2
    L2_2 = L1_2.sub
    L4_2 = 1
    L5_2 = 64
    L2_2 = L2_2(L3_2, L4_2, L5_2)
    if L2_2 then
      goto lbl_20
    end
  end
  L2_2 = nil
  ::lbl_20::
  return L2_2
end
function L29_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2
  L2_2 = tonumber
  L3_2 = A0_2.created
  L2_2 = L2_2(L3_2)
  if not L2_2 then
    L2_2 = 0
  end
  L3_2 = tonumber
  L4_2 = A1_2.created
  L3_2 = L3_2(L4_2)
  if not L3_2 then
    L3_2 = 0
  end
  L2_2 = L2_2 > L3_2
  return L2_2
end
function L30_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2, L19_2
  L2_2 = Integration
  L3_2 = "billing"
  L2_2, L3_2 = L2_2(L3_2)
  if "builtin" == L3_2 then
    L4_2 = nil
    return L4_2
  end
  L4_2 = IntegrationTry
  L5_2 = "billing"
  L6_2 = "list"
  L7_2 = A0_2
  L8_2 = A1_2
  L4_2, L5_2 = L4_2(L5_2, L6_2, L7_2, L8_2)
  if L4_2 then
    L6_2 = type
    L7_2 = L5_2
    L6_2 = L6_2(L7_2)
    if "table" == L6_2 then
      goto lbl_23
    end
  end
  L6_2 = nil
  do return L6_2 end
  ::lbl_23::
  L6_2 = {}
  L7_2 = ipairs
  L8_2 = L5_2
  L7_2, L8_2, L9_2, L10_2 = L7_2(L8_2)
  for L11_2, L12_2 in L7_2, L8_2, L9_2, L10_2 do
    L13_2 = type
    L14_2 = L12_2
    L13_2 = L13_2(L14_2)
    if "table" == L13_2 then
      L13_2 = L12_2.id
      if nil ~= L13_2 then
        L13_2 = L13_1.num
        L14_2 = L12_2.amount
        L13_2 = L13_2(L14_2)
        if L13_2 then
          goto lbl_43
        end
      end
    end
    L13_2 = nil
    ::lbl_43::
    if L13_2 then
      L14_2 = #L6_2
      L14_2 = L14_2 + 1
      L15_2 = {}
      L16_2 = "x:"
      L17_2 = tostring
      L18_2 = L12_2.id
      L17_2 = L17_2(L18_2)
      L16_2 = L16_2 .. L17_2
      L15_2.id = L16_2
      L16_2 = L12_2.sender
      L15_2.sender = L16_2
      L16_2 = tostring
      L17_2 = L12_2.sender_name
      if not L17_2 then
        L17_2 = L12_2.senderName
        if not L17_2 then
          L17_2 = L12_2.sender
          if not L17_2 then
            L17_2 = "Fatura"
          end
        end
      end
      L16_2 = L16_2(L17_2)
      L17_2 = L16_2
      L16_2 = L16_2.sub
      L18_2 = 1
      L19_2 = 64
      L16_2 = L16_2(L17_2, L18_2, L19_2)
      L15_2.sender_name = L16_2
      L16_2 = L12_2.society
      L15_2.society = L16_2
      L16_2 = math
      L16_2 = L16_2.floor
      L17_2 = L13_2
      L16_2 = L16_2(L17_2)
      L15_2.amount = L16_2
      L16_2 = L12_2.reason
      if nil ~= L16_2 then
        L16_2 = tostring
        L17_2 = L12_2.reason
        L16_2 = L16_2(L17_2)
        L17_2 = L16_2
        L16_2 = L16_2.sub
        L18_2 = 1
        L19_2 = 160
        L16_2 = L16_2(L17_2, L18_2, L19_2)
        if L16_2 then
          goto lbl_95
        end
      end
      L16_2 = nil
      ::lbl_95::
      L15_2.reason = L16_2
      L16_2 = L27_1
      L17_2 = L12_2.status
      L16_2 = L16_2(L17_2)
      L15_2.status = L16_2
      L16_2 = L13_1.ms
      L17_2 = L12_2.created
      L16_2 = L16_2(L17_2)
      L15_2.created = L16_2
      L16_2 = L12_2.paid_at
      if L16_2 then
        L16_2 = L13_1.ms
        L17_2 = L12_2.paid_at
        L16_2 = L16_2(L17_2)
        if L16_2 then
          goto lbl_113
        end
      end
      L16_2 = nil
      ::lbl_113::
      L15_2.paid_at = L16_2
      L15_2.provider = L3_2
      L6_2[L14_2] = L15_2
    end
  end
  return L6_2
end
function L31_1(A0_2, A1_2, A2_2)
  local L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2
  L3_2 = ipairs
  L4_2 = L30_1
  L5_2 = A0_2
  L6_2 = A1_2
  L4_2 = L4_2(L5_2, L6_2)
  if not L4_2 then
    L4_2 = {}
  end
  L3_2, L4_2, L5_2, L6_2 = L3_2(L4_2)
  for L7_2, L8_2 in L3_2, L4_2, L5_2, L6_2 do
    L9_2 = L8_2.id
    L10_2 = "x:"
    L11_2 = A2_2
    L10_2 = L10_2 .. L11_2
    if L9_2 == L10_2 then
      return L8_2
    end
  end
  L3_2 = nil
  return L3_2
end
L32_1 = RPC
function L33_1(A0_2)
  local L1_2, L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2
  L1_2 = L19_1
  L2_2 = A0_2
  L1_2 = L1_2(L2_2)
  L2_2 = Integration
  L3_2 = "billing"
  L2_2, L3_2 = L2_2(L3_2)
  if "builtin" == L3_2 then
    return L1_2
  end
  L4_2 = GetCid
  L5_2 = A0_2
  L4_2 = L4_2(L5_2)
  if not L4_2 then
    return L1_2
  end
  L5_2 = L30_1
  L6_2 = A0_2
  L7_2 = L4_2
  L5_2 = L5_2(L6_2, L7_2)
  if L5_2 then
    L6_2 = #L5_2
    if 0 ~= L6_2 then
      goto lbl_26
    end
  end
  do return L1_2 end
  ::lbl_26::
  L6_2 = ipairs
  L7_2 = L1_2
  L6_2, L7_2, L8_2, L9_2 = L6_2(L7_2)
  for L10_2, L11_2 in L6_2, L7_2, L8_2, L9_2 do
    L12_2 = #L5_2
    L12_2 = L12_2 + 1
    L5_2[L12_2] = L11_2
  end
  L6_2 = table
  L6_2 = L6_2.sort
  L7_2 = L5_2
  L8_2 = L29_1
  L6_2(L7_2, L8_2)
  while true do
    L6_2 = #L5_2
    L7_2 = 150
    if not (L6_2 > L7_2) then
      break
    end
    L6_2 = #L5_2
    L5_2[L6_2] = nil
  end
  return L5_2
end
L32_1["bills.list"] = L33_1
L32_1 = RPC
function L33_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2
  L2_2 = L28_1
  L3_2 = type
  L4_2 = A1_2
  L3_2 = L3_2(L4_2)
  if "table" == L3_2 then
    L3_2 = A1_2.id
    if L3_2 then
      goto lbl_11
    end
  end
  L3_2 = nil
  ::lbl_11::
  L2_2 = L2_2(L3_2)
  if not L2_2 then
    L3_2 = L20_1
    L4_2 = A0_2
    L5_2 = A1_2
    return L3_2(L4_2, L5_2)
  end
  L3_2 = FW
  L3_2 = L3_2.GetPlayer
  L4_2 = A0_2
  L3_2 = L3_2(L4_2)
  if not L3_2 then
    L4_2 = {}
    L4_2.ok = false
    return L4_2
  end
  L4_2 = L31_1
  L5_2 = A0_2
  L6_2 = L3_2.cid
  L7_2 = L2_2
  L4_2 = L4_2(L5_2, L6_2, L7_2)
  if L4_2 then
    L5_2 = L4_2.status
    if "pending" == L5_2 then
      goto lbl_44
    end
  end
  L5_2 = {}
  L5_2.ok = false
  L5_2.error = "invalid"
  do return L5_2 end
  ::lbl_44::
  L5_2 = IntegrationTry
  L6_2 = "billing"
  L7_2 = "pay"
  L8_2 = A0_2
  L9_2 = L3_2.cid
  L10_2 = L2_2
  L5_2, L6_2, L7_2 = L5_2(L6_2, L7_2, L8_2, L9_2, L10_2)
  if not L5_2 then
    L8_2 = {}
    L8_2.ok = false
    L8_2.error = "invalid"
    return L8_2
  end
  if not L6_2 then
    L8_2 = {}
    L8_2.ok = false
    if "funds" == L7_2 then
      L9_2 = "funds"
      if L9_2 then
        goto lbl_69
      end
    end
    L9_2 = "invalid"
    ::lbl_69::
    L8_2.error = L9_2
    L9_2 = L3_2.GetMoney
    L10_2 = "bank"
    L9_2 = L9_2(L10_2)
    L8_2.bank = L9_2
    return L8_2
  end
  L4_2.status = "paid"
  L8_2 = TriggerEvent
  L9_2 = "apex_phone:billPaid"
  L10_2 = A0_2
  L11_2 = L4_2
  L8_2(L9_2, L10_2, L11_2)
  L8_2 = {}
  L8_2.ok = true
  L9_2 = L3_2.GetMoney
  L10_2 = "bank"
  L9_2 = L9_2(L10_2)
  L8_2.bank = L9_2
  return L8_2
end
L32_1["bills.pay"] = L33_1
L32_1 = RPC
function L33_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2
  L2_2 = L28_1
  L3_2 = type
  L4_2 = A1_2
  L3_2 = L3_2(L4_2)
  if "table" == L3_2 then
    L3_2 = A1_2.id
    if L3_2 then
      goto lbl_11
    end
  end
  L3_2 = nil
  ::lbl_11::
  L2_2 = L2_2(L3_2)
  if not L2_2 then
    L3_2 = L21_1
    L4_2 = A0_2
    L5_2 = A1_2
    return L3_2(L4_2, L5_2)
  end
  L3_2 = GetCid
  L4_2 = A0_2
  L3_2 = L3_2(L4_2)
  if not L3_2 then
    L4_2 = {}
    L4_2.ok = false
    return L4_2
  end
  L4_2 = L31_1
  L5_2 = A0_2
  L6_2 = L3_2
  L7_2 = L2_2
  L4_2 = L4_2(L5_2, L6_2, L7_2)
  if L4_2 then
    L5_2 = L4_2.status
    if "pending" == L5_2 then
      goto lbl_42
    end
  end
  L5_2 = {}
  L5_2.ok = false
  do return L5_2 end
  ::lbl_42::
  L5_2 = IntegrationTry
  L6_2 = "billing"
  L7_2 = "refuse"
  L8_2 = A0_2
  L9_2 = L3_2
  L10_2 = L2_2
  L5_2, L6_2 = L5_2(L6_2, L7_2, L8_2, L9_2, L10_2)
  if not L5_2 or not L6_2 then
    L7_2 = {}
    L7_2.ok = false
    return L7_2
  end
  L4_2.status = "refused"
  L7_2 = TriggerEvent
  L8_2 = "apex_phone:billRefused"
  L9_2 = A0_2
  L10_2 = L4_2
  L7_2(L8_2, L9_2, L10_2)
  L7_2 = {}
  L7_2.ok = true
  return L7_2
end
L32_1["bills.refuse"] = L33_1
L32_1 = RPC
function L33_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2, L6_2, L7_2
  L2_2 = Integration
  L3_2 = "billing"
  L2_2, L3_2 = L2_2(L3_2)
  if "builtin" ~= L3_2 then
    L4_2 = IntegrationHas
    L5_2 = "billing"
    L6_2 = "create"
    L4_2 = L4_2(L5_2, L6_2)
    if L4_2 then
      goto lbl_17
    end
  end
  L4_2 = L23_1
  L5_2 = A0_2
  L6_2 = A1_2
  do return L4_2(L5_2, L6_2) end
  ::lbl_17::
  L4_2 = L23_1
  L5_2 = A0_2
  L6_2 = A1_2
  function L7_2(A0_3, A1_3, A2_3, A3_3, A4_3)
    local L5_3, L6_3, L7_3, L8_3, L9_3, L10_3, L11_3, L12_3, L13_3, L14_3, L15_3
    L5_3 = FW
    L5_3 = L5_3.GetPlayerByCid
    L6_3 = A0_3
    L5_3 = L5_3(L6_3)
    L6_3 = IntegrationTry
    L7_3 = "billing"
    L8_3 = "create"
    L9_3 = A0_2
    L10_3 = A4_3.senderCid
    L11_3 = A0_3
    L12_3 = A2_3
    L13_3 = A3_3
    L14_3 = {}
    L15_3 = A4_3.society
    L14_3.society = L15_3
    L14_3.senderName = A1_3
    if L5_3 then
      L15_3 = L5_3.src
      if L15_3 then
        goto lbl_24
      end
    end
    L15_3 = nil
    ::lbl_24::
    L14_3.toSrc = L15_3
    L6_3, L7_3, L8_3 = L6_3(L7_3, L8_3, L9_3, L10_3, L11_3, L12_3, L13_3, L14_3)
    if not L6_3 or nil == L7_3 then
      L9_3 = CreateBillInternal
      L10_3 = A0_3
      L11_3 = A1_3
      L12_3 = A2_3
      L13_3 = A3_3
      L14_3 = A4_3
      return L9_3(L10_3, L11_3, L12_3, L13_3, L14_3)
    end
    if false == L7_3 then
      L9_3 = {}
      L10_3 = type
      L11_3 = L8_3
      L10_3 = L10_3(L11_3)
      L10_3 = L8_3 or L10_3
      if "string" ~= L10_3 or not L8_3 then
        L10_3 = "invalid"
      end
      L9_3.error = L10_3
      return L9_3
    end
    if L5_3 then
      L9_3 = Push
      L10_3 = L5_3.src
      L11_3 = "bill"
      L12_3 = {}
      L12_3.id = "x:new"
      L12_3.sender_name = A1_3
      L12_3.amount = A2_3
      L12_3.reason = A3_3
      L12_3.status = "pending"
      L9_3(L10_3, L11_3, L12_3)
    end
    L9_3 = {}
    L9_3.ok = true
    L10_3 = L3_2
    L9_3.provider = L10_3
    L9_3.amount = A2_3
    L9_3.sender_name = A1_3
    L9_3.reason = A3_3
    L10_3 = A4_3.society
    L9_3.society = L10_3
    L9_3.status = "pending"
    L10_3 = Now
    L10_3 = L10_3()
    L9_3.created = L10_3
    return L9_3
  end
  return L4_2(L5_2, L6_2, L7_2)
end
L32_1["bills.create"] = L33_1
L32_1 = RPC
function L33_1(A0_2)
  local L1_2, L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2, L19_2, L20_2
  L1_2 = L24_1
  L2_2 = A0_2
  L1_2 = L1_2(L2_2)
  L2_2 = Integration
  L3_2 = "billing"
  L2_2, L3_2 = L2_2(L3_2)
  if "builtin" == L3_2 then
    return L1_2
  end
  L4_2 = GetCid
  L5_2 = A0_2
  L4_2 = L4_2(L5_2)
  if not L4_2 then
    return L1_2
  end
  L5_2 = IntegrationTry
  L6_2 = "billing"
  L7_2 = "sent"
  L8_2 = A0_2
  L9_2 = L4_2
  L5_2, L6_2 = L5_2(L6_2, L7_2, L8_2, L9_2)
  if L5_2 then
    L7_2 = type
    L8_2 = L6_2
    L7_2 = L7_2(L8_2)
    if "table" == L7_2 then
      L7_2 = #L6_2
      if 0 ~= L7_2 then
        goto lbl_33
      end
    end
  end
  do return L1_2 end
  ::lbl_33::
  L7_2 = {}
  L8_2 = ipairs
  L9_2 = L6_2
  L8_2, L9_2, L10_2, L11_2 = L8_2(L9_2)
  for L12_2, L13_2 in L8_2, L9_2, L10_2, L11_2 do
    L14_2 = type
    L15_2 = L13_2
    L14_2 = L14_2(L15_2)
    if "table" == L14_2 then
      L14_2 = L13_2.id
      if nil ~= L14_2 then
        L14_2 = L13_1.num
        L15_2 = L13_2.amount
        L14_2 = L14_2(L15_2)
        if L14_2 then
          goto lbl_53
        end
      end
    end
    L14_2 = nil
    ::lbl_53::
    if L14_2 then
      L15_2 = L13_2.toCid
      if nil ~= L15_2 then
        L15_2 = tostring
        L16_2 = L13_2.toCid
        L15_2 = L15_2(L16_2)
        if L15_2 then
          goto lbl_64
        end
      end
      L15_2 = nil
      ::lbl_64::
      L16_2 = #L7_2
      L16_2 = L16_2 + 1
      L17_2 = {}
      L18_2 = "x:"
      L19_2 = tostring
      L20_2 = L13_2.id
      L19_2 = L19_2(L20_2)
      L18_2 = L18_2 .. L19_2
      L17_2.id = L18_2
      L18_2 = L13_2.toNumber
      if not L18_2 then
        if L15_2 then
          L18_2 = GetNumberByCitizenId
          L19_2 = L15_2
          L18_2 = L18_2(L19_2)
          if L18_2 then
            goto lbl_86
          end
        end
        L18_2 = nil
      end
      ::lbl_86::
      L17_2.to = L18_2
      L18_2 = L13_2.to_name
      if not L18_2 then
        if L15_2 then
          L18_2 = L13_1.nameOf
          L19_2 = L15_2
          L18_2 = L18_2(L19_2)
          if L18_2 then
            goto lbl_98
          end
        end
        L18_2 = nil
      end
      ::lbl_98::
      L17_2.to_name = L18_2
      L18_2 = L13_2.sender_name
      L17_2.sender_name = L18_2
      L18_2 = L13_2.society
      L17_2.society = L18_2
      L18_2 = math
      L18_2 = L18_2.floor
      L19_2 = L14_2
      L18_2 = L18_2(L19_2)
      L17_2.amount = L18_2
      L18_2 = L13_2.reason
      L17_2.reason = L18_2
      L18_2 = L27_1
      L19_2 = L13_2.status
      L18_2 = L18_2(L19_2)
      L17_2.status = L18_2
      L18_2 = L13_1.ms
      L19_2 = L13_2.created
      L18_2 = L18_2(L19_2)
      L17_2.created = L18_2
      L18_2 = L13_2.paid_at
      if L18_2 then
        L18_2 = L13_1.ms
        L19_2 = L13_2.paid_at
        L18_2 = L18_2(L19_2)
        if L18_2 then
          goto lbl_127
        end
      end
      L18_2 = nil
      ::lbl_127::
      L17_2.paid_at = L18_2
      L7_2[L16_2] = L17_2
    end
  end
  L8_2 = ipairs
  L9_2 = L1_2
  L8_2, L9_2, L10_2, L11_2 = L8_2(L9_2)
  for L12_2, L13_2 in L8_2, L9_2, L10_2, L11_2 do
    L14_2 = #L7_2
    L14_2 = L14_2 + 1
    L7_2[L14_2] = L13_2
  end
  L8_2 = table
  L8_2 = L8_2.sort
  L9_2 = L7_2
  L10_2 = L29_1
  L8_2(L9_2, L10_2)
  while true do
    L8_2 = #L7_2
    L9_2 = 150
    if not (L8_2 > L9_2) then
      break
    end
    L8_2 = #L7_2
    L7_2[L8_2] = nil
  end
  return L7_2
end
L32_1["bills.sent"] = L33_1
L32_1 = RPC
function L33_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2
  L2_2 = L28_1
  L3_2 = type
  L4_2 = A1_2
  L3_2 = L3_2(L4_2)
  if "table" == L3_2 then
    L3_2 = A1_2.id
    if L3_2 then
      goto lbl_11
    end
  end
  L3_2 = nil
  ::lbl_11::
  L2_2 = L2_2(L3_2)
  if not L2_2 then
    L3_2 = L25_1
    L4_2 = A0_2
    L5_2 = A1_2
    return L3_2(L4_2, L5_2)
  end
  L3_2 = GetCid
  L4_2 = A0_2
  L3_2 = L3_2(L4_2)
  if not L3_2 then
    L4_2 = {}
    L4_2.ok = false
    return L4_2
  end
  L4_2 = IntegrationTry
  L5_2 = "billing"
  L6_2 = "sent"
  L7_2 = A0_2
  L8_2 = L3_2
  L4_2, L5_2 = L4_2(L5_2, L6_2, L7_2, L8_2)
  L6_2 = false
  L7_2 = ipairs
  if L4_2 then
    L8_2 = type
    L9_2 = L5_2
    L8_2 = L8_2(L9_2)
    if "table" == L8_2 and L5_2 then
      goto lbl_47
      L8_2 = L5_2 or L8_2
    end
  end
  L8_2 = {}
  ::lbl_47::
  L7_2, L8_2, L9_2, L10_2 = L7_2(L8_2)
  for L11_2, L12_2 in L7_2, L8_2, L9_2, L10_2 do
    L13_2 = type
    L14_2 = L12_2
    L13_2 = L13_2(L14_2)
    if "table" == L13_2 then
      L13_2 = tostring
      L14_2 = L12_2.id
      L13_2 = L13_2(L14_2)
      if L13_2 == L2_2 then
        L13_2 = L27_1
        L14_2 = L12_2.status
        L13_2 = L13_2(L14_2)
        if "pending" == L13_2 then
          L6_2 = true
          break
        end
      end
    end
  end
  if not L6_2 then
    L7_2 = {}
    L7_2.ok = false
    L7_2.error = "invalid"
    return L7_2
  end
  L7_2 = IntegrationTry
  L8_2 = "billing"
  L9_2 = "cancel"
  L10_2 = A0_2
  L11_2 = L3_2
  L12_2 = L2_2
  L7_2, L8_2 = L7_2(L8_2, L9_2, L10_2, L11_2, L12_2)
  if not L7_2 or not L8_2 then
    L9_2 = {}
    L9_2.ok = false
    L9_2.error = "invalid"
    return L9_2
  end
  L9_2 = {}
  L9_2.ok = true
  return L9_2
end
L32_1["bills.cancel"] = L33_1
