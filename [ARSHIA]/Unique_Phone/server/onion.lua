local L0_1, L1_1, L2_1, L3_1, L4_1, L5_1, L6_1, L7_1, L8_1, L9_1, L10_1, L11_1, L12_1, L13_1, L14_1, L15_1, L16_1, L17_1, L18_1, L19_1, L20_1, L21_1, L22_1, L23_1, L24_1, L25_1, L26_1, L27_1, L28_1, L29_1, L30_1, L31_1, L32_1, L33_1, L34_1, L35_1, L36_1, L37_1, L38_1, L39_1, L40_1, L41_1, L42_1, L43_1
L0_1 = {}
L1_1 = "silent"
L2_1 = "grey"
L3_1 = "hollow"
L4_1 = "iron"
L5_1 = "pale"
L6_1 = "zero"
L7_1 = "north"
L8_1 = "blind"
L9_1 = "amber"
L10_1 = "still"
L0_1[1] = L1_1
L0_1[2] = L2_1
L0_1[3] = L3_1
L0_1[4] = L4_1
L0_1[5] = L5_1
L0_1[6] = L6_1
L0_1[7] = L7_1
L0_1[8] = L8_1
L0_1[9] = L9_1
L0_1[10] = L10_1
L1_1 = {}
L2_1 = "fox"
L3_1 = "wire"
L4_1 = "crow"
L5_1 = "echo"
L6_1 = "vault"
L7_1 = "moth"
L8_1 = "harbor"
L9_1 = "signal"
L10_1 = "ember"
L11_1 = "switch"
L1_1[1] = L2_1
L1_1[2] = L3_1
L1_1[3] = L4_1
L1_1[4] = L5_1
L1_1[5] = L6_1
L1_1[6] = L7_1
L1_1[7] = L8_1
L1_1[8] = L9_1
L1_1[9] = L10_1
L1_1[10] = L11_1
function L2_1()
  local L0_2, L1_2, L2_2, L3_2, L4_2
  L0_2 = math
  L0_2 = L0_2.random
  L1_2 = L0_1
  L1_2 = #L1_2
  L0_2 = L0_2(L1_2)
  L1_2 = L0_1
  L0_2 = L1_2[L0_2]
  L1_2 = math
  L1_2 = L1_2.random
  L2_2 = L1_1
  L2_2 = #L2_2
  L1_2 = L1_2(L2_2)
  L2_2 = L1_1
  L1_2 = L2_2[L1_2]
  L2_2 = math
  L2_2 = L2_2.random
  L3_2 = 10
  L4_2 = 99
  L2_2 = L2_2(L3_2, L4_2)
  L0_2 = L0_2 .. L1_2 .. L2_2
  return L0_2
end
function L3_1()
  local L0_2, L1_2, L2_2, L3_2, L4_2
  L0_2 = type
  L1_2 = Config
  L1_2 = L1_2.Onion
  L0_2 = L0_2(L1_2)
  if "table" == L0_2 then
    L0_2 = Config
    L0_2 = L0_2.Onion
    if L0_2 then
      goto lbl_13
    end
  end
  L0_2 = {}
  ::lbl_13::
  L1_2 = {}
  L2_2 = tonumber
  L3_2 = L0_2.maxPrice
  L2_2 = L2_2(L3_2)
  if not L2_2 then
    L2_2 = 1000
  end
  L1_2.maxPrice = L2_2
  L2_2 = math
  L2_2 = L2_2.floor
  L3_2 = tonumber
  L4_2 = L0_2.maxStock
  L3_2 = L3_2(L4_2)
  if not L3_2 then
    L3_2 = 1000
  end
  L2_2 = L2_2(L3_2)
  L1_2.maxStock = L2_2
  return L1_2
end
function L4_1(A0_2, A1_2, A2_2)
  local L3_2, L4_2, L5_2, L6_2
  L3_2 = tonumber
  L4_2 = A0_2
  L3_2 = L3_2(L4_2)
  if L3_2 and L3_2 == L3_2 then
    L4_2 = math
    L4_2 = L4_2.huge
    if L3_2 ~= L4_2 then
      L4_2 = math
      L4_2 = L4_2.huge
      L4_2 = -L4_2
      if L3_2 ~= L4_2 then
        goto lbl_19
      end
    end
  end
  L4_2 = nil
  do return L4_2 end
  ::lbl_19::
  L4_2 = A2_2 or L4_2
  if not A2_2 then
    L4_2 = 8
  end
  L5_2 = 10
  L4_2 = L5_2 ^ L4_2
  L5_2 = math
  L5_2 = L5_2.floor
  L6_2 = L3_2 * L4_2
  L6_2 = L6_2 + 0.5
  L5_2 = L5_2(L6_2)
  L3_2 = L5_2 / L4_2
  if L3_2 == L3_2 then
    L5_2 = math
    L5_2 = L5_2.huge
    if L3_2 ~= L5_2 then
      L5_2 = math
      L5_2 = L5_2.huge
      L5_2 = -L5_2
      if L3_2 ~= L5_2 then
        goto lbl_47
      end
    end
  end
  L5_2 = nil
  do return L5_2 end
  ::lbl_47::
  if L3_2 <= 0 or A1_2 and A1_2 < L3_2 then
    L5_2 = nil
    return L5_2
  end
  return L3_2
end
function L5_1(A0_2, A1_2, A2_2)
  local L3_2, L4_2, L5_2
  L3_2 = tonumber
  L4_2 = A0_2
  L3_2 = L3_2(L4_2)
  if L3_2 and L3_2 == L3_2 then
    L4_2 = math
    L4_2 = L4_2.huge
    if L3_2 ~= L4_2 then
      L4_2 = math
      L4_2 = L4_2.huge
      L4_2 = -L4_2
      if L3_2 ~= L4_2 then
        goto lbl_19
      end
    end
  end
  L4_2 = nil
  do return L4_2 end
  ::lbl_19::
  L4_2 = math
  L4_2 = L4_2.floor
  L5_2 = L3_2
  L4_2 = L4_2(L5_2)
  L3_2 = L4_2
  if A1_2 > L3_2 or A2_2 < L3_2 then
    L4_2 = nil
    return L4_2
  end
  L4_2 = math
  L4_2 = L4_2.tointeger
  L5_2 = L3_2
  L4_2 = L4_2(L5_2)
  if not L4_2 then
    L4_2 = L3_2
  end
  return L4_2
end
function L6_1()
  local L0_2, L1_2
  L0_2 = tonumber
  L1_2 = Config
  L1_2 = L1_2.PhotoMaxBytes
  L0_2 = L0_2(L1_2)
  if not L0_2 then
    L0_2 = 260000
  end
  return L0_2
end
function L7_1(A0_2)
  local L1_2, L2_2, L3_2
  if nil == A0_2 or false == A0_2 or "" == A0_2 then
    L1_2 = nil
    L2_2 = true
    return L1_2, L2_2
  end
  L1_2 = tostring
  L2_2 = A0_2
  L1_2 = L1_2(L2_2)
  L2_2 = #L1_2
  L3_2 = L6_1
  L3_2 = L3_2()
  if L2_2 > L3_2 then
    L2_2 = nil
    L3_2 = false
    return L2_2, L3_2
  end
  L2_2 = L1_2
  L3_2 = true
  return L2_2, L3_2
end
function L8_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2
  L2_2 = type
  L3_2 = FW
  L3_2 = L3_2.HasItem
  L2_2 = L2_2(L3_2)
  if "function" ~= L2_2 then
    L2_2 = nil
    return L2_2
  end
  L2_2 = pcall
  L3_2 = FW
  L3_2 = L3_2.HasItem
  L4_2 = A0_2
  L5_2 = A1_2
  L2_2, L3_2 = L2_2(L3_2, L4_2, L5_2)
  if not L2_2 then
    L4_2 = nil
    return L4_2
  end
  L4_2 = tonumber
  L5_2 = L3_2
  return L4_2(L5_2)
end
function L9_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2
  if nil == A1_2 or "" == A1_2 then
    L2_2 = nil
    L3_2 = "noitem"
    return L2_2, L3_2
  end
  L2_2 = tostring
  L3_2 = A1_2
  L2_2 = L2_2(L3_2)
  L3_2 = L2_2
  L2_2 = L2_2.sub
  L4_2 = 1
  L5_2 = 64
  L2_2 = L2_2(L3_2, L4_2, L5_2)
  L4_2 = L2_2
  L3_2 = L2_2.match
  L5_2 = "^[%w_%-%.]+$"
  L3_2 = L3_2(L4_2, L5_2)
  if not L3_2 then
    L3_2 = nil
    L4_2 = "noitem"
    return L3_2, L4_2
  end
  L3_2 = L8_1
  L4_2 = A0_2
  L5_2 = L2_2
  L3_2 = L3_2(L4_2, L5_2)
  if nil == L3_2 then
    L4_2 = nil
    L5_2 = "noinv"
    return L4_2, L5_2
  end
  if L3_2 <= 0 then
    L4_2 = nil
    L5_2 = "noitem"
    return L4_2, L5_2
  end
  return L2_2
end
function L10_1()
  local L0_2, L1_2
  L0_2 = ItemEscrow
  L0_2 = ItemEscrow
  L0_2 = L0_2.enabled
  L1_2 = "onion"
  L0_2 = nil ~= L0_2 and L0_2
  return L0_2
end
function L11_1(A0_2)
  local L1_2, L2_2, L3_2
  L1_2 = ItemEscrow
  if L1_2 then
    L1_2 = ItemEscrow
    L1_2 = L1_2.key
    if L1_2 then
      L1_2 = "onion:"
      L2_2 = ItemEscrow
      L2_2 = L2_2.key
      L3_2 = A0_2
      L2_2 = L2_2(L3_2)
      L1_2 = L1_2 .. L2_2
      return L1_2
    end
  end
  L1_2 = "onion:"
  L2_2 = tostring
  L3_2 = A0_2
  L2_2 = L2_2(L3_2)
  L1_2 = L1_2 .. L2_2
  return L1_2
end
function L12_1(A0_2, A1_2, ...)
  local L2_2, L3_2, L4_2, L5_2
  L2_2 = ItemEscrow
  if L2_2 then
    L2_2 = ItemEscrow
    L2_2 = L2_2.withLock
    if L2_2 then
      L2_2 = ItemEscrow
      L2_2 = L2_2.withLock
      L3_2 = A0_2
      L4_2 = A1_2
      L5_2 = ...
      return L2_2(L3_2, L4_2, L5_2)
    end
  end
  L2_2 = A1_2
  L3_2, L4_2, L5_2 = ...
  return L2_2(L3_2, L4_2, L5_2)
end
function L13_1(A0_2)
  local L1_2, L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2
  L1_2 = MySQL
  L1_2 = L1_2.single
  L1_2 = L1_2.await
  L2_2 = "SELECT * FROM apex_phone_onion_id WHERE citizenid = ?"
  L3_2 = {}
  L4_2 = A0_2
  L3_2[1] = L4_2
  L1_2 = L1_2(L2_2, L3_2)
  if L1_2 then
    return L1_2
  end
  L2_2 = L2_1
  L2_2 = L2_2()
  L3_2 = Now
  L3_2 = L3_2()
  L4_2 = MySQL
  L4_2 = L4_2.insert
  L4_2 = L4_2.await
  L5_2 = "INSERT INTO apex_phone_onion_id (citizenid, handle, rep, votes, sales, since) VALUES (?, ?, 0, 0, 0, ?)"
  L6_2 = {}
  L7_2 = A0_2
  L8_2 = L2_2
  L9_2 = L3_2
  L6_2[1] = L7_2
  L6_2[2] = L8_2
  L6_2[3] = L9_2
  L4_2(L5_2, L6_2)
  L4_2 = {}
  L4_2.citizenid = A0_2
  L4_2.handle = L2_2
  L4_2.rep = 0
  L4_2.votes = 0
  L4_2.sales = 0
  L4_2.since = L3_2
  return L4_2
end
function L14_1(A0_2)
  local L1_2, L2_2, L3_2
  L1_2 = tonumber
  L2_2 = A0_2.votes
  L1_2 = L1_2(L2_2)
  if not L1_2 then
    L1_2 = 0
  end
  if L1_2 > 0 then
    L2_2 = tonumber
    L3_2 = A0_2.rep
    L2_2 = L2_2(L3_2)
    if not L2_2 then
      L2_2 = 0
    end
    L2_2 = L2_2 / L1_2
    if L2_2 then
      goto lbl_20
    end
  end
  L2_2 = 0
  ::lbl_20::
  return L2_2
end
function L15_1(A0_2)
  local L1_2, L2_2, L3_2
  L1_2 = {}
  L2_2 = A0_2.handle
  L1_2.handle = L2_2
  L2_2 = L14_1
  L3_2 = A0_2
  L2_2 = L2_2(L3_2)
  L1_2.rep = L2_2
  L2_2 = tonumber
  L3_2 = A0_2.sales
  L2_2 = L2_2(L3_2)
  if not L2_2 then
    L2_2 = 0
  end
  L1_2.sales = L2_2
  L2_2 = tonumber
  L3_2 = A0_2.since
  L2_2 = L2_2(L3_2)
  if not L2_2 then
    L2_2 = 0
  end
  L1_2.since = L2_2
  return L1_2
end
function L16_1(A0_2)
  local L1_2, L2_2, L3_2, L4_2, L5_2
  L1_2 = MySQL
  L1_2 = L1_2.single
  L1_2 = L1_2.await
  L2_2 = "SELECT bal FROM apex_phone_crypto WHERE citizenid = ?"
  L3_2 = {}
  L4_2 = A0_2
  L3_2[1] = L4_2
  L1_2 = L1_2(L2_2, L3_2)
  if L1_2 then
    L2_2 = tonumber
    L3_2 = L1_2.bal
    L2_2 = L2_2(L3_2)
    if not L2_2 then
      L2_2 = 0
    end
    return L2_2
  end
  L2_2 = MySQL
  L2_2 = L2_2.insert
  L2_2 = L2_2.await
  L3_2 = "INSERT IGNORE INTO apex_phone_crypto (citizenid, bal) VALUES (?, 0)"
  L4_2 = {}
  L5_2 = A0_2
  L4_2[1] = L5_2
  L2_2(L3_2, L4_2)
  L2_2 = 0
  return L2_2
end
function L17_1(A0_2, A1_2, A2_2)
  local L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2
  L3_2 = MySQL
  L3_2 = L3_2.insert
  L3_2 = L3_2.await
  L4_2 = "INSERT INTO apex_phone_crypto_hist (owner, label, amount, created) VALUES (?, ?, ?, ?)"
  L5_2 = {}
  L6_2 = A0_2
  L7_2 = tostring
  L8_2 = A1_2
  L7_2 = L7_2(L8_2)
  L8_2 = L7_2
  L7_2 = L7_2.sub
  L9_2 = 1
  L10_2 = 80
  L7_2 = L7_2(L8_2, L9_2, L10_2)
  L8_2 = A2_2
  L9_2 = Now
  L9_2, L10_2 = L9_2()
  L5_2[1] = L6_2
  L5_2[2] = L7_2
  L5_2[3] = L8_2
  L5_2[4] = L9_2
  L5_2[5] = L10_2
  L3_2(L4_2, L5_2)
end
function L18_1(A0_2, A1_2, A2_2)
  local L3_2, L4_2, L5_2, L6_2, L7_2, L8_2
  if not (A0_2 and A1_2) or A1_2 <= 0 then
    L3_2 = false
    return L3_2
  end
  L3_2 = MySQL
  L3_2 = L3_2.update
  L3_2 = L3_2.await
  L4_2 = "UPDATE apex_phone_crypto SET bal = bal - ? WHERE citizenid = ? AND bal >= ?"
  L5_2 = {}
  L6_2 = A1_2
  L7_2 = A0_2
  L8_2 = A1_2
  L5_2[1] = L6_2
  L5_2[2] = L7_2
  L5_2[3] = L8_2
  L3_2 = L3_2(L4_2, L5_2)
  L4_2 = tonumber
  L5_2 = L3_2
  L4_2 = L4_2(L5_2)
  if not L4_2 then
    L4_2 = 0
  end
  if 1 ~= L4_2 then
    L4_2 = false
    return L4_2
  end
  if A2_2 then
    L4_2 = L17_1
    L5_2 = A0_2
    L6_2 = A2_2
    L7_2 = -A1_2
    L4_2(L5_2, L6_2, L7_2)
  end
  L4_2 = true
  return L4_2
end
function L19_1(A0_2, A1_2, A2_2)
  local L3_2, L4_2, L5_2, L6_2, L7_2, L8_2
  if not (A0_2 and A1_2) or A1_2 <= 0 then
    L3_2 = false
    return L3_2
  end
  L3_2 = MySQL
  L3_2 = L3_2.update
  L3_2 = L3_2.await
  L4_2 = "INSERT INTO apex_phone_crypto (citizenid, bal) VALUES (?, ?) ON DUPLICATE KEY UPDATE bal = bal + ?"
  L5_2 = {}
  L6_2 = A0_2
  L7_2 = A1_2
  L8_2 = A1_2
  L5_2[1] = L6_2
  L5_2[2] = L7_2
  L5_2[3] = L8_2
  L3_2(L4_2, L5_2)
  if A2_2 then
    L3_2 = L17_1
    L4_2 = A0_2
    L5_2 = A2_2
    L6_2 = A1_2
    L3_2(L4_2, L5_2, L6_2)
  end
  L3_2 = true
  return L3_2
end
function L20_1()
  local L0_2, L1_2, L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2, L19_2, L20_2, L21_2
  L0_2 = type
  L1_2 = Config
  L1_2 = L1_2.Crypto
  L0_2 = L0_2(L1_2)
  if "table" == L0_2 then
    L0_2 = Config
    L0_2 = L0_2.Crypto
    if L0_2 then
      goto lbl_13
    end
  end
  L0_2 = {}
  ::lbl_13::
  function L1_2(A0_3, A1_3, A2_3, A3_3)
    local L4_3, L5_3
    L4_3 = tonumber
    L5_3 = A0_3
    L4_3 = L4_3(L5_3)
    if L4_3 and L4_3 == L4_3 then
      L5_3 = math
      L5_3 = L5_3.huge
      if L4_3 ~= L5_3 then
        L5_3 = math
        L5_3 = L5_3.huge
        L5_3 = -L5_3
        if L4_3 ~= L5_3 then
          goto lbl_18
        end
      end
    end
    L4_3 = A1_3
    ::lbl_18::
    if A2_3 and A2_3 > L4_3 then
      L4_3 = A2_3
    end
    if A3_3 and A3_3 < L4_3 then
      L4_3 = A3_3
    end
    return L4_3
  end
  L2_2 = L1_2
  L3_2 = L0_2.min
  L4_2 = 26460
  L5_2 = 1
  L2_2 = L2_2(L3_2, L4_2, L5_2)
  L3_2 = L1_2
  L4_2 = L0_2.max
  L5_2 = 27540
  L6_2 = L2_2
  L3_2 = L3_2(L4_2, L5_2, L6_2)
  L4_2 = L1_2
  L5_2 = L0_2.feeBuyPct
  L6_2 = 1.5
  L7_2 = 0
  L8_2 = 90
  L4_2 = L4_2(L5_2, L6_2, L7_2, L8_2)
  L4_2 = L4_2 / 100
  L5_2 = L1_2
  L6_2 = L0_2.feeSellPct
  L7_2 = 1.5
  L8_2 = 0
  L9_2 = 90
  L5_2 = L5_2(L6_2, L7_2, L8_2, L9_2)
  L5_2 = L5_2 / 100
  L6_2 = L2_2 + L3_2
  L6_2 = L6_2 / 2
  L7_2 = 1 + L4_2
  L8_2 = 1
  L8_2 = L8_2 - L5_2
  L7_2 = L7_2 / L8_2
  L8_2 = L2_2 > 0
  L9_2 = L8_2 or L9_2
  if L8_2 then
    L9_2 = L0_2.enforceBand
    L9_2 = false ~= L9_2
  end
  L10_2 = L2_2
  L11_2 = L3_2
  if L9_2 then
    L12_2 = L6_2 / L7_2
    L12_2 = L6_2 - L12_2
    L12_2 = L12_2 * 0.6666666666666666
    L12_2 = L6_2 - L12_2
    L13_2 = L12_2
    L14_2 = L6_2 * 2
    L3_2 = L14_2 - L12_2
    L2_2 = L13_2
  end
  L12_2 = L1_2
  L13_2 = L0_2.step
  L14_2 = 110
  L15_2 = 0
  L12_2 = L12_2(L13_2, L14_2, L15_2)
  L13_2 = L3_2 - L2_2
  L13_2 = L13_2 / 8
  L14_2 = L12_2
  L15_2 = false
  if L12_2 > L13_2 then
    L16_2 = L13_2
    L15_2 = true
    L12_2 = L16_2
  end
  L16_2 = {}
  L16_2.min = L2_2
  L16_2.max = L3_2
  L16_2.cfgMin = L10_2
  L16_2.cfgMax = L11_2
  L16_2.wide = L8_2
  L16_2.enforced = L9_2
  L16_2.centre = L6_2
  L16_2.safe = L7_2
  L16_2.step = L12_2
  L16_2.cfgStep = L14_2
  L16_2.stepCut = L15_2
  L16_2.stepMax = L13_2
  L17_2 = L1_2
  L18_2 = L0_2.revert
  L19_2 = 0.01
  L20_2 = 0
  L21_2 = 1
  L17_2 = L17_2(L18_2, L19_2, L20_2, L21_2)
  L16_2.revert = L17_2
  L17_2 = math
  L17_2 = L17_2.floor
  L18_2 = L1_2
  L19_2 = L0_2.tick
  L20_2 = 30
  L21_2 = 5
  L18_2, L19_2, L20_2, L21_2 = L18_2(L19_2, L20_2, L21_2)
  L17_2 = L17_2(L18_2, L19_2, L20_2, L21_2)
  L16_2.tick = L17_2
  L16_2.buyFee = L4_2
  L16_2.sellFee = L5_2
  L17_2 = L0_2.persist
  L17_2 = false ~= L17_2
  L16_2.persist = L17_2
  return L16_2
end
function L21_1(A0_2)
  local L1_2, L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2
  L1_2 = A0_2.stepCut
  if L1_2 then
    L1_2 = print
    L2_2 = "^3[unique_phone]^0 Config.Crypto: step = %.0f is too large for the %.0f-%.0f band (width %.0f) \226\128\148 with a step that size the quote jumps from one limit to the other within minutes, and buying at the floor to sell at the ceiling yields %+.2f%% per round trip, several times a day (measured: +36875/day per 100000 of capital). USING step = %.0f (width/8), which is the maximum that closes that arbitrage. For a larger step, widen the band in the same proportion."
    L3_2 = L2_2
    L2_2 = L2_2.format
    L4_2 = A0_2.cfgStep
    L5_2 = A0_2.min
    L6_2 = A0_2.max
    L7_2 = A0_2.max
    L8_2 = A0_2.min
    L7_2 = L7_2 - L8_2
    L8_2 = A0_2.max
    L9_2 = A0_2.min
    L8_2 = L8_2 / L9_2
    L9_2 = A0_2.sellFee
    L10_2 = 1
    L9_2 = L10_2 - L9_2
    L8_2 = L8_2 * L9_2
    L9_2 = A0_2.buyFee
    L9_2 = 1 + L9_2
    L8_2 = L8_2 / L9_2
    L8_2 = L8_2 - 1
    L8_2 = L8_2 * 100
    L9_2 = A0_2.stepMax
    L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2 = L2_2(L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2)
    L1_2(L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2)
  end
  L1_2 = A0_2.wide
  if not L1_2 then
    return
  end
  L1_2 = A0_2.centre
  L2_2 = A0_2.cfgMin
  L1_2 = L1_2 / L2_2
  L2_2 = A0_2.sellFee
  L3_2 = 1
  L2_2 = L3_2 - L2_2
  L2_2 = L1_2 * L2_2
  L3_2 = A0_2.buyFee
  L3_2 = 1 + L3_2
  L2_2 = L2_2 / L3_2
  L2_2 = L2_2 - 1
  L2_2 = L2_2 * 100
  L3_2 = A0_2.enforced
  if L3_2 then
    L3_2 = print
    L4_2 = "^3[unique_phone]^0 Config.Crypto: the %.0f-%.0f band does not pay for itself with the %.2f%%/%.2f%% fee (centre/floor = %.4f, and someone who buys at the floor and just waits only stops profiting at %.4f) \226\128\148 buying at the floor would yield %+.1f%%, i.e. printing money. USING %.0f-%.0f (same centre). To widen the band, raise feeBuyPct/feeSellPct to %.2f%%; to keep it anyway, set enforceBand = false."
    L5_2 = L4_2
    L4_2 = L4_2.format
    L6_2 = A0_2.cfgMin
    L7_2 = A0_2.cfgMax
    L8_2 = A0_2.buyFee
    L8_2 = L8_2 * 100
    L9_2 = A0_2.sellFee
    L9_2 = L9_2 * 100
    L10_2 = L1_2
    L11_2 = A0_2.safe
    L12_2 = L2_2
    L13_2 = A0_2.min
    L14_2 = A0_2.max
    L15_2 = L1_2 - 1
    L16_2 = L1_2 + 1
    L15_2 = L15_2 / L16_2
    L15_2 = L15_2 * 100
    L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2 = L4_2(L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2)
    L3_2(L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2)
    L3_2 = print
    L4_2 = "^3[unique_phone]^0 Config.Crypto: even in the narrowed %.0f-%.0f band, buying at the floor and selling at the ceiling earns %+.2f%% per round trip (the band without that arbitrage would be %.0f-%.0f). With the step at its maximum of %.0f the round trip is rare: measured -361/day for the best possible player per 100000 of capital."
    L5_2 = L4_2
    L4_2 = L4_2.format
    L6_2 = A0_2.min
    L7_2 = A0_2.max
    L8_2 = A0_2.max
    L9_2 = A0_2.min
    L8_2 = L8_2 / L9_2
    L9_2 = A0_2.sellFee
    L10_2 = 1
    L9_2 = L10_2 - L9_2
    L8_2 = L8_2 * L9_2
    L9_2 = A0_2.buyFee
    L9_2 = 1 + L9_2
    L8_2 = L8_2 / L9_2
    L8_2 = L8_2 - 1
    L8_2 = L8_2 * 100
    L9_2 = A0_2.centre
    L10_2 = A0_2.centre
    L11_2 = A0_2.safe
    L11_2 = L11_2 - 1
    L10_2 = L10_2 * L11_2
    L11_2 = A0_2.safe
    L11_2 = L11_2 + 1
    L10_2 = L10_2 / L11_2
    L9_2 = L9_2 - L10_2
    L10_2 = A0_2.centre
    L11_2 = A0_2.centre
    L12_2 = A0_2.safe
    L12_2 = L12_2 - 1
    L11_2 = L11_2 * L12_2
    L12_2 = A0_2.safe
    L12_2 = L12_2 + 1
    L11_2 = L11_2 / L12_2
    L10_2 = L10_2 + L11_2
    L11_2 = A0_2.stepMax
    L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2 = L4_2(L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2)
    L3_2(L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2)
  else
    L3_2 = print
    L4_2 = "^3[unique_phone]^0 Config.Crypto: enforceBand = false with the %.0f-%.0f band and the %.2f%%/%.2f%% fee \226\128\148 buying crypto at the floor quote and waiting yields on average %+.1f%% (money printer), and buying at the floor to sell at the ceiling yields %+.2f%% per round trip. This was your choice; the fee that would close the first case is %.2f%% on each side."
    L5_2 = L4_2
    L4_2 = L4_2.format
    L6_2 = A0_2.cfgMin
    L7_2 = A0_2.cfgMax
    L8_2 = A0_2.buyFee
    L8_2 = L8_2 * 100
    L9_2 = A0_2.sellFee
    L9_2 = L9_2 * 100
    L10_2 = L2_2
    L11_2 = A0_2.cfgMax
    L12_2 = A0_2.cfgMin
    L11_2 = L11_2 / L12_2
    L12_2 = A0_2.sellFee
    L13_2 = 1
    L12_2 = L13_2 - L12_2
    L11_2 = L11_2 * L12_2
    L12_2 = A0_2.buyFee
    L12_2 = 1 + L12_2
    L11_2 = L11_2 / L12_2
    L11_2 = L11_2 - 1
    L11_2 = L11_2 * 100
    L12_2 = L1_2 - 1
    L13_2 = L1_2 + 1
    L12_2 = L12_2 / L13_2
    L12_2 = L12_2 * 100
    L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2 = L4_2(L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2)
    L3_2(L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2)
  end
end
function L22_1(A0_2)
  local L1_2, L2_2
  L1_2 = math
  L1_2 = L1_2.floor
  L2_2 = A0_2 * 100
  L2_2 = L2_2 + 0.5
  L1_2 = L1_2(L2_2)
  L1_2 = L1_2 / 100
  return L1_2
end
function L23_1(A0_2)
  local L1_2, L2_2
  L1_2 = math
  L1_2 = L1_2.ceil
  L2_2 = A0_2 * 100
  L2_2 = L2_2 - 1.0E-9
  L1_2 = L1_2(L2_2)
  L1_2 = L1_2 / 100
  return L1_2
end
function L24_1(A0_2)
  local L1_2, L2_2
  L1_2 = math
  L1_2 = L1_2.floor
  L2_2 = A0_2 * 100
  L2_2 = L2_2 + 1.0E-9
  L1_2 = L1_2(L2_2)
  L1_2 = L1_2 / 100
  return L1_2
end
function L25_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2
  L2_2 = L22_1
  L3_2 = A1_2.centre
  L3_2 = L3_2 - A0_2
  L4_2 = A1_2.revert
  L3_2 = L3_2 * L4_2
  L3_2 = A0_2 + L3_2
  L4_2 = math
  L4_2 = L4_2.random
  L4_2 = L4_2()
  L4_2 = L4_2 - 0.5
  L5_2 = A1_2.step
  L4_2 = L4_2 * L5_2
  L3_2 = L3_2 + L4_2
  L2_2 = L2_2(L3_2)
  A0_2 = L2_2
  L2_2 = A1_2.min
  if A0_2 < L2_2 then
    A0_2 = A1_2.min
  else
    L2_2 = A1_2.max
    if A0_2 > L2_2 then
      A0_2 = A1_2.max
    end
  end
  return A0_2
end
L26_1 = 40
L27_1 = {}
L28_1 = 0
function L29_1()
  local L0_2, L1_2, L2_2
  L0_2 = L23_1
  L1_2 = L28_1
  L2_2 = L20_1
  L2_2 = L2_2()
  L2_2 = L2_2.buyFee
  L2_2 = 1 + L2_2
  L1_2 = L1_2 * L2_2
  return L0_2(L1_2)
end
function L30_1()
  local L0_2, L1_2, L2_2, L3_2
  L0_2 = L24_1
  L1_2 = L28_1
  L2_2 = L20_1
  L2_2 = L2_2()
  L2_2 = L2_2.sellFee
  L3_2 = 1
  L2_2 = L3_2 - L2_2
  L1_2 = L1_2 * L2_2
  return L0_2(L1_2)
end
L31_1 = [[
CREATE TABLE IF NOT EXISTS `apex_phone_crypto_state` (
    `k` VARCHAR(16) NOT NULL PRIMARY KEY, `price` DECIMAL(20,8) NOT NULL DEFAULT 0,
    `series` TEXT NULL, `updated` BIGINT NOT NULL DEFAULT 0) DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci]]
L32_1 = false
function L33_1()
  local L0_2, L1_2
  L0_2 = L32_1
  if not L0_2 then
    return
  end
  L0_2 = pcall
  function L1_2()
    local L0_3, L1_3, L2_3, L3_3, L4_3, L5_3, L6_3
    L0_3 = MySQL
    L0_3 = L0_3.update
    L0_3 = L0_3.await
    L1_3 = [[
INSERT INTO apex_phone_crypto_state (k, price, series, updated) VALUES (?, ?, ?, ?)
            ON DUPLICATE KEY UPDATE price = VALUES(price), series = VALUES(series), updated = VALUES(updated)]]
    L2_3 = {}
    L3_3 = "btc"
    L4_3 = L28_1
    L5_3 = json
    L5_3 = L5_3.encode
    L6_3 = L27_1
    L5_3 = L5_3(L6_3)
    L6_3 = Now
    L6_3 = L6_3()
    L2_3[1] = L3_3
    L2_3[2] = L4_3
    L2_3[3] = L5_3
    L2_3[4] = L6_3
    L0_3(L1_3, L2_3)
  end
  L0_2(L1_2)
end
function L34_1(A0_2)
  local L1_2, L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2
  L1_2 = L32_1
  if not L1_2 then
    L1_2 = false
    return L1_2
  end
  L1_2 = pcall
  L2_2 = MySQL
  L2_2 = L2_2.single
  L2_2 = L2_2.await
  L3_2 = "SELECT price, series FROM apex_phone_crypto_state WHERE k = ?"
  L4_2 = {}
  L5_2 = "btc"
  L4_2[1] = L5_2
  L1_2, L2_2 = L1_2(L2_2, L3_2, L4_2)
  if not L1_2 or not L2_2 then
    L3_2 = false
    return L3_2
  end
  L3_2 = tonumber
  L4_2 = L2_2.price
  L3_2 = L3_2(L4_2)
  if not L3_2 or L3_2 ~= L3_2 or L3_2 <= 0 then
    L4_2 = false
    return L4_2
  end
  function L4_2(A0_3)
    local L1_3, L2_3, L3_3, L4_3, L5_3, L6_3
    L1_3 = math
    L1_3 = L1_3.min
    L2_3 = A0_2.max
    L3_3 = math
    L3_3 = L3_3.max
    L4_3 = A0_2.min
    L5_3 = L22_1
    L6_3 = A0_3
    L5_3 = L5_3(L6_3)
    L3_3 = L3_3(L4_3, L5_3)
    return L1_3(L2_3, L3_3)
  end
  L5_2 = A0_2.min
  if not (L3_2 < L5_2) then
    L5_2 = A0_2.max
    if not (L3_2 > L5_2) then
      goto lbl_64
    end
  end
  L5_2 = print
  L6_2 = "^3[unique_phone]^0 saved crypto quote (%s) is outside the %.0f-%.0f band of Config.Crypto: it enters at %s (%+.1f%%). Anyone holding a B balance sees its money value change in that proportion, once only."
  L7_2 = L6_2
  L6_2 = L6_2.format
  L8_2 = FormatMoney
  L9_2 = L3_2
  L8_2 = L8_2(L9_2)
  L9_2 = A0_2.min
  L10_2 = A0_2.max
  L11_2 = FormatMoney
  L12_2 = L4_2
  L13_2 = L3_2
  L12_2, L13_2, L14_2, L15_2, L16_2, L17_2 = L12_2(L13_2)
  L11_2 = L11_2(L12_2, L13_2, L14_2, L15_2, L16_2, L17_2)
  L12_2 = L4_2
  L13_2 = L3_2
  L12_2 = L12_2(L13_2)
  L12_2 = L12_2 / L3_2
  L12_2 = L12_2 - 1
  L12_2 = L12_2 * 100
  L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2 = L6_2(L7_2, L8_2, L9_2, L10_2, L11_2, L12_2)
  L5_2(L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2)
  ::lbl_64::
  L5_2 = pcall
  L6_2 = json
  L6_2 = L6_2.decode
  L7_2 = L2_2.series
  if not L7_2 then
    L7_2 = "[]"
  end
  L5_2, L6_2 = L5_2(L6_2, L7_2)
  L7_2 = {}
  L27_1 = L7_2
  if L5_2 then
    L7_2 = type
    L8_2 = L6_2
    L7_2 = L7_2(L8_2)
    if "table" == L7_2 then
      L7_2 = ipairs
      L8_2 = L6_2
      L7_2, L8_2, L9_2, L10_2 = L7_2(L8_2)
      for L11_2, L12_2 in L7_2, L8_2, L9_2, L10_2 do
        L13_2 = tonumber
        L14_2 = L12_2
        L13_2 = L13_2(L14_2)
        if L13_2 and L13_2 == L13_2 then
          L14_2 = math
          L14_2 = L14_2.huge
          if L13_2 ~= L14_2 then
            L14_2 = math
            L14_2 = L14_2.huge
            L14_2 = -L14_2
            if L13_2 ~= L14_2 then
              L14_2 = L27_1
              L14_2 = #L14_2
              L15_2 = L14_2 + 1
              L14_2 = L27_1
              L16_2 = L4_2
              L17_2 = L13_2
              L16_2 = L16_2(L17_2)
              L14_2[L15_2] = L16_2
            end
          end
        end
      end
    end
  end
  L7_2 = L4_2
  L8_2 = L3_2
  L7_2 = L7_2(L8_2)
  L28_1 = L7_2
  while true do
    L7_2 = L27_1
    L7_2 = #L7_2
    L8_2 = L26_1
    if not (L7_2 > L8_2) then
      break
    end
    L7_2 = table
    L7_2 = L7_2.remove
    L8_2 = L27_1
    L9_2 = 1
    L7_2(L8_2, L9_2)
  end
  L7_2 = L27_1
  L7_2 = #L7_2
  if L7_2 < 2 then
    L7_2 = {}
    L8_2 = L28_1
    L9_2 = L28_1
    L7_2[1] = L8_2
    L7_2[2] = L9_2
    L27_1 = L7_2
  end
  L7_2 = true
  return L7_2
end
L35_1 = CreateThread
function L36_1()
  local L0_2, L1_2, L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2
  L0_2 = L20_1
  L0_2 = L0_2()
  L1_2 = DBReady
  if nil == L1_2 then
    L1_2 = Wait
    L2_2 = 3000
    L1_2(L2_2)
  else
    while true do
      L1_2 = DBReady
      if L1_2 then
        break
      end
      L1_2 = Wait
      L2_2 = 500
      L1_2(L2_2)
    end
  end
  L1_2 = pcall
  function L2_2()
    local L0_3, L1_3
    L0_3 = MySQL
    L0_3 = L0_3.query
    L0_3 = L0_3.await
    L1_3 = L31_1
    L0_3(L1_3)
  end
  L1_2, L2_2 = L1_2(L2_2)
  if L1_2 then
    L3_2 = true
    L32_1 = L3_2
    L3_2 = pcall
    L4_2 = MigrateTable
    L5_2 = L31_1
    L3_2(L4_2, L5_2)
  else
    L3_2 = print
    L4_2 = "^3[unique_phone]^0 could not create apex_phone_crypto_state (%s): the crypto quote is re-rolled on every restart"
    L5_2 = L4_2
    L4_2 = L4_2.format
    L6_2 = tostring
    L7_2 = L2_2
    L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2 = L6_2(L7_2)
    L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2 = L4_2(L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2)
    L3_2(L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2)
  end
  L3_2 = L21_1
  L4_2 = L0_2
  L3_2(L4_2)
  L3_2 = L0_2.persist
  if L3_2 then
    L3_2 = L34_1
    L4_2 = L0_2
    L3_2 = L3_2(L4_2)
    if L3_2 then
      goto lbl_86
    end
  end
  L3_2 = L22_1
  L4_2 = L0_2.min
  L5_2 = math
  L5_2 = L5_2.random
  L5_2 = L5_2()
  L6_2 = L0_2.max
  L7_2 = L0_2.min
  L6_2 = L6_2 - L7_2
  L5_2 = L5_2 * L6_2
  L4_2 = L4_2 + L5_2
  L3_2 = L3_2(L4_2)
  L4_2 = {}
  L27_1 = L4_2
  L4_2 = 1
  L5_2 = L26_1
  L6_2 = 1
  for L7_2 = L4_2, L5_2, L6_2 do
    L8_2 = L25_1
    L9_2 = L3_2
    L10_2 = L0_2
    L8_2 = L8_2(L9_2, L10_2)
    L3_2 = L8_2
    L8_2 = L27_1
    L8_2 = #L8_2
    L9_2 = L8_2 + 1
    L8_2 = L27_1
    L8_2[L9_2] = L3_2
  end
  L4_2 = L27_1
  L5_2 = #L4_2
  L4_2 = L27_1
  L4_2 = L4_2[L5_2]
  L28_1 = L4_2
  ::lbl_86::
  L3_2 = L0_2.persist
  if L3_2 then
    L3_2 = L33_1
    L3_2()
  end
  L3_2 = Dbg
  L4_2 = "onion"
  L5_2 = "quote 1 B = %.2f (buy %.2f / sell %.2f), band %.0f-%.0f (centre %.0f, reversion %.3f/step), saved=%s"
  L6_2 = L28_1
  L7_2 = L29_1
  L7_2 = L7_2()
  L8_2 = L30_1
  L8_2 = L8_2()
  L9_2 = L0_2.min
  L10_2 = L0_2.max
  L11_2 = L0_2.centre
  L12_2 = L0_2.revert
  L13_2 = tostring
  L14_2 = L32_1
  if L14_2 then
    L14_2 = L0_2.persist
  end
  L13_2, L14_2 = L13_2(L14_2)
  L3_2(L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2)
  while true do
    L3_2 = Wait
    L4_2 = L0_2.tick
    L4_2 = L4_2 * 1000
    L3_2(L4_2)
    L3_2 = L20_1
    L3_2 = L3_2()
    L0_2 = L3_2
    L3_2 = L25_1
    L4_2 = L28_1
    L5_2 = L0_2
    L3_2 = L3_2(L4_2, L5_2)
    L4_2 = L27_1
    L4_2 = #L4_2
    L5_2 = L4_2 + 1
    L4_2 = L27_1
    L4_2[L5_2] = L3_2
    while true do
      L4_2 = L27_1
      L4_2 = #L4_2
      L5_2 = L26_1
      if not (L4_2 > L5_2) then
        break
      end
      L4_2 = table
      L4_2 = L4_2.remove
      L5_2 = L27_1
      L6_2 = 1
      L4_2(L5_2, L6_2)
    end
    L28_1 = L3_2
    L4_2 = L0_2.persist
    if L4_2 then
      L4_2 = L33_1
      L4_2()
    end
  end
end
L35_1(L36_1)
L35_1 = RPC
function L36_1(A0_2)
  local L1_2, L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2
  L1_2 = GetCid
  L2_2 = A0_2
  L1_2 = L1_2(L2_2)
  L2_2 = MySQL
  L2_2 = L2_2.query
  L2_2 = L2_2.await
  L3_2 = "SELECT label, amount, created FROM apex_phone_crypto_hist WHERE owner = ? ORDER BY created DESC LIMIT 40"
  L4_2 = {}
  L5_2 = L1_2
  L4_2[1] = L5_2
  L2_2 = L2_2(L3_2, L4_2)
  if not L2_2 then
    L2_2 = {}
  end
  L3_2 = ipairs
  L4_2 = L2_2
  L3_2, L4_2, L5_2, L6_2 = L3_2(L4_2)
  for L7_2, L8_2 in L3_2, L4_2, L5_2, L6_2 do
    L9_2 = tonumber
    L10_2 = L8_2.amount
    L9_2 = L9_2(L10_2)
    if not L9_2 then
      L9_2 = 0
    end
    L8_2.amount = L9_2
  end
  L3_2 = L20_1
  L3_2 = L3_2()
  L4_2 = {}
  L5_2 = L16_1
  L6_2 = L1_2
  L5_2 = L5_2(L6_2)
  L4_2.bal = L5_2
  L5_2 = L28_1
  L4_2.price = L5_2
  L5_2 = L29_1
  L5_2 = L5_2()
  L4_2.buy = L5_2
  L5_2 = L30_1
  L5_2 = L5_2()
  L4_2.sell = L5_2
  L5_2 = L3_2.buyFee
  L5_2 = L5_2 * 100
  L4_2.feeBuyPct = L5_2
  L5_2 = L3_2.sellFee
  L5_2 = L5_2 * 100
  L4_2.feeSellPct = L5_2
  L5_2 = L27_1
  L4_2.series = L5_2
  L4_2.history = L2_2
  return L4_2
end
L35_1["crypto.state"] = L36_1
L35_1 = RPC
function L36_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2
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
  L3_2 = L2_2.cid
  if L3_2 then
    L3_2 = L2_2.cid
    if "" ~= L3_2 then
      goto lbl_23
    end
  end
  L3_2 = {}
  L3_2.ok = false
  L3_2.error = "noplayer"
  do return L3_2 end
  ::lbl_23::
  L3_2 = L5_1
  L4_2 = A1_2.amount
  L5_2 = 1
  L6_2 = 1.0E12
  L3_2 = L3_2(L4_2, L5_2, L6_2)
  if not L3_2 then
    L4_2 = {}
    L4_2.ok = false
    L4_2.error = "invalid"
    return L4_2
  end
  L4_2 = L29_1
  L4_2 = L4_2()
  L5_2 = L28_1
  if L5_2 <= 0 or L4_2 <= 0 then
    L5_2 = {}
    L5_2.ok = false
    L5_2.error = "invalid"
    return L5_2
  end
  L5_2 = math
  L5_2 = L5_2.floor
  L6_2 = L3_2 / L4_2
  L6_2 = L6_2 * 1.0E8
  L5_2 = L5_2(L6_2)
  L5_2 = L5_2 / 1.0E8
  if L5_2 <= 0 then
    L6_2 = {}
    L6_2.ok = false
    L6_2.error = "invalid"
    return L6_2
  end
  L6_2 = L2_2.GetMoney
  L7_2 = "cash"
  L6_2 = L6_2(L7_2)
  if L3_2 > L6_2 then
    L6_2 = {}
    L6_2.ok = false
    L6_2.error = "funds"
    return L6_2
  end
  L6_2 = L2_2.RemoveMoney
  L7_2 = "cash"
  L8_2 = L3_2
  L9_2 = "Unique_Phone crypto"
  L6_2 = L6_2(L7_2, L8_2, L9_2)
  if not L6_2 then
    L6_2 = {}
    L6_2.ok = false
    L6_2.error = "funds"
    return L6_2
  end
  L6_2 = L19_1
  L7_2 = L2_2.cid
  L8_2 = L5_2
  L9_2 = "Compra de cripto"
  L6_2 = L6_2(L7_2, L8_2, L9_2)
  if not L6_2 then
    L6_2 = L2_2.AddMoney
    L7_2 = "cash"
    L8_2 = L3_2
    L9_2 = "Unique_Phone crypto (reposicao)"
    L6_2 = L6_2(L7_2, L8_2, L9_2)
    if not L6_2 then
      L6_2 = print
      L7_2 = "^1[unique_phone]^0 crypto.buy: %s paid %s, the crypto was not credited and the refund also failed"
      L8_2 = L7_2
      L7_2 = L7_2.format
      L9_2 = tostring
      L10_2 = L2_2.cid
      L9_2 = L9_2(L10_2)
      L10_2 = FormatMoney
      L11_2 = L3_2
      L10_2, L11_2 = L10_2(L11_2)
      L7_2, L8_2, L9_2, L10_2, L11_2 = L7_2(L8_2, L9_2, L10_2, L11_2)
      L6_2(L7_2, L8_2, L9_2, L10_2, L11_2)
    end
    L6_2 = {}
    L6_2.ok = false
    L6_2.error = "internal"
    return L6_2
  end
  L6_2 = {}
  L6_2.ok = true
  L7_2 = L16_1
  L8_2 = L2_2.cid
  L7_2 = L7_2(L8_2)
  L6_2.bal = L7_2
  L6_2.price = L4_2
  L6_2.got = L5_2
  return L6_2
end
L35_1["crypto.buy"] = L36_1
L35_1 = RPC
function L36_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2
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
  L3_2 = L4_1
  L4_2 = A1_2.amount
  L5_2 = nil
  L6_2 = 8
  L3_2 = L3_2(L4_2, L5_2, L6_2)
  if not L3_2 then
    L4_2 = {}
    L4_2.ok = false
    L4_2.error = "invalid"
    return L4_2
  end
  L4_2 = L30_1
  L4_2 = L4_2()
  L5_2 = L28_1
  if L5_2 <= 0 or L4_2 <= 0 then
    L5_2 = {}
    L5_2.ok = false
    L5_2.error = "invalid"
    return L5_2
  end
  L5_2 = math
  L5_2 = L5_2.floor
  L6_2 = L3_2 * L4_2
  L5_2 = L5_2(L6_2)
  L6_2 = math
  L6_2 = L6_2.tointeger
  L7_2 = L5_2
  L6_2 = L6_2(L7_2)
  L5_2 = L6_2 or L5_2
  if not L6_2 then
  end
  if L5_2 <= 0 then
    L6_2 = {}
    L6_2.ok = false
    L6_2.error = "invalid"
    return L6_2
  end
  L6_2 = L18_1
  L7_2 = L2_2.cid
  L8_2 = L3_2
  L9_2 = "Venda de cripto"
  L6_2 = L6_2(L7_2, L8_2, L9_2)
  if not L6_2 then
    L6_2 = {}
    L6_2.ok = false
    L6_2.error = "funds"
    return L6_2
  end
  L6_2 = L2_2.AddMoney
  L7_2 = "cash"
  L8_2 = L5_2
  L9_2 = "Unique_Phone crypto"
  L6_2 = L6_2(L7_2, L8_2, L9_2)
  if not L6_2 then
    L6_2 = L19_1
    L7_2 = L2_2.cid
    L8_2 = L3_2
    L9_2 = "Venda anulada"
    L6_2(L7_2, L8_2, L9_2)
    L6_2 = {}
    L6_2.ok = false
    L6_2.error = "internal"
    return L6_2
  end
  L6_2 = {}
  L6_2.ok = true
  L7_2 = L16_1
  L8_2 = L2_2.cid
  L7_2 = L7_2(L8_2)
  L6_2.bal = L7_2
  L6_2.price = L4_2
  L6_2.cash = L5_2
  return L6_2
end
L35_1["crypto.sell"] = L36_1
L35_1 = RPC
function L36_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2
  L2_2 = GetCid
  L3_2 = A0_2
  L2_2 = L2_2(L3_2)
  if not L2_2 then
    L3_2 = {}
    L3_2.ok = false
    L3_2.error = "noplayer"
    return L3_2
  end
  L3_2 = L4_1
  L4_2 = A1_2.amount
  L5_2 = nil
  L6_2 = 8
  L3_2 = L3_2(L4_2, L5_2, L6_2)
  if not L3_2 then
    L4_2 = {}
    L4_2.ok = false
    L4_2.error = "invalid"
    return L4_2
  end
  L4_2 = tostring
  L5_2 = A1_2.to
  if not L5_2 then
    L5_2 = ""
  end
  L4_2 = L4_2(L5_2)
  L5_2 = L4_2
  L4_2 = L4_2.sub
  L6_2 = 1
  L7_2 = 32
  L4_2 = L4_2(L5_2, L6_2, L7_2)
  if "" == L4_2 then
    L5_2 = {}
    L5_2.ok = false
    L5_2.error = "nouser"
    return L5_2
  end
  L5_2 = MySQL
  L5_2 = L5_2.scalar
  L5_2 = L5_2.await
  L6_2 = "SELECT citizenid FROM apex_phone_onion_id WHERE handle = ?"
  L7_2 = {}
  L8_2 = L4_2
  L7_2[1] = L8_2
  L5_2 = L5_2(L6_2, L7_2)
  if not L5_2 then
    L6_2 = MySQL
    L6_2 = L6_2.scalar
    L6_2 = L6_2.await
    L7_2 = "SELECT citizenid FROM apex_phone_accounts WHERE phone = ?"
    L8_2 = {}
    L9_2 = L4_2
    L8_2[1] = L9_2
    L6_2 = L6_2(L7_2, L8_2)
    L5_2 = L6_2
  end
  if not L5_2 or L5_2 == L2_2 then
    L6_2 = {}
    L6_2.ok = false
    L6_2.error = "nouser"
    return L6_2
  end
  L6_2 = L18_1
  L7_2 = L2_2
  L8_2 = L3_2
  L9_2 = "Enviado para "
  L10_2 = L4_2
  L9_2 = L9_2 .. L10_2
  L6_2 = L6_2(L7_2, L8_2, L9_2)
  if not L6_2 then
    L6_2 = {}
    L6_2.ok = false
    L6_2.error = "funds"
    return L6_2
  end
  L6_2 = L19_1
  L7_2 = L5_2
  L8_2 = L3_2
  L9_2 = "Recebido"
  L6_2(L7_2, L8_2, L9_2)
  L6_2 = NotifyCitizen
  L7_2 = L5_2
  L8_2 = "crypto"
  L9_2 = "Cripto recebida"
  L10_2 = string
  L10_2 = L10_2.format
  L11_2 = "%.4f \226\130\191"
  L12_2 = L3_2
  L10_2 = L10_2(L11_2, L12_2)
  L11_2 = nil
  L12_2 = {}
  L12_2.throttle = false
  L6_2(L7_2, L8_2, L9_2, L10_2, L11_2, L12_2)
  L6_2 = {}
  L6_2.ok = true
  L7_2 = L16_1
  L8_2 = L2_2
  L7_2 = L7_2(L8_2)
  L6_2.bal = L7_2
  return L6_2
end
L35_1["crypto.send"] = L36_1
function L35_1(A0_2)
  local L1_2, L2_2
  L1_2 = tonumber
  L2_2 = A0_2.price
  L1_2 = L1_2(L2_2)
  if not L1_2 then
    L1_2 = 0
  end
  A0_2.price = L1_2
  L1_2 = tonumber
  L2_2 = A0_2.stock
  L1_2 = L1_2(L2_2)
  if not L1_2 then
    L1_2 = 0
  end
  A0_2.stock = L1_2
  L1_2 = A0_2.image
  if L1_2 then
    L1_2 = tonumber
    L2_2 = A0_2.image
    L1_2 = L1_2(L2_2)
    if L1_2 then
      L1_2 = tonumber
      L2_2 = A0_2.image
      L1_2 = L1_2(L2_2)
      A0_2.image = L1_2
    end
  end
  L1_2 = A0_2.escrow
  if nil ~= L1_2 then
    L1_2 = tonumber
    L2_2 = A0_2.escrow
    L1_2 = L1_2(L2_2)
    L1_2 = 1 == L1_2
    A0_2.escrow = L1_2
  end
  L1_2 = A0_2.custody
  if nil ~= L1_2 then
    L1_2 = tonumber
    L2_2 = A0_2.custody
    L1_2 = L1_2(L2_2)
    L1_2 = 1 == L1_2
    A0_2.custody = L1_2
  end
  return A0_2
end
L36_1 = ", EXISTS(SELECT 1 FROM apex_phone_item_escrow e WHERE e.`source` = 'onion' AND e.ref_id = l.id AND e.target IS NULL AND e.status = 'held' AND e.`count` > 0) AS escrow"
L37_1 = ", EXISTS(SELECT 1 FROM apex_phone_item_escrow e2 WHERE e2.`source` = 'onion' AND e2.ref_id = l.id AND e2.target IS NULL) AS custody"
function L38_1()
  local L0_2, L1_2
  L0_2 = ItemEscrow
  L0_2 = ItemEscrow
  L0_2 = nil ~= L0_2 and L0_2
  return L0_2
end
L39_1 = RPC
function L40_1(A0_2)
  local L1_2, L2_2, L3_2, L4_2
  L1_2 = L15_1
  L2_2 = L13_1
  L3_2 = GetCid
  L4_2 = A0_2
  L3_2, L4_2 = L3_2(L4_2)
  L2_2, L3_2, L4_2 = L2_2(L3_2, L4_2)
  return L1_2(L2_2, L3_2, L4_2)
end
L39_1["onion.identity"] = L40_1
L39_1 = RPC
function L40_1(A0_2)
  local L1_2, L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2
  L1_2 = GetCid
  L2_2 = A0_2
  L1_2 = L1_2(L2_2)
  if L1_2 then
    L2_2 = MySQL
    L2_2 = L2_2.query
    L2_2 = L2_2.await
    L3_2 = "SELECT id FROM apex_phone_onion WHERE owner = ?"
    L4_2 = {}
    L5_2 = L1_2
    L4_2[1] = L5_2
    L2_2 = L2_2(L3_2, L4_2)
    if L2_2 then
      goto lbl_19
    end
  end
  L2_2 = {}
  ::lbl_19::
  L3_2 = ipairs
  L4_2 = L2_2
  L3_2, L4_2, L5_2, L6_2 = L3_2(L4_2)
  for L7_2, L8_2 in L3_2, L4_2, L5_2, L6_2 do
    L9_2 = L12_1
    L10_2 = L11_1
    L11_2 = L8_2.id
    L10_2 = L10_2(L11_2)
    function L11_2()
      local L0_3, L1_3, L2_3, L3_3, L4_3
      L0_3 = MySQL
      L0_3 = L0_3.update
      L0_3 = L0_3.await
      L1_3 = "DELETE FROM apex_phone_onion WHERE id = ? AND owner = ?"
      L2_3 = {}
      L3_3 = L8_2.id
      L4_3 = L1_2
      L2_3[1] = L3_3
      L2_3[2] = L4_3
      L0_3 = L0_3(L1_3, L2_3)
      L1_3 = tonumber
      L2_3 = L0_3
      L1_3 = L1_3(L2_3)
      if not L1_3 then
        L1_3 = 0
      end
      if 1 == L1_3 then
        L1_3 = L38_1
        L1_3 = L1_3()
        if L1_3 then
          L1_3 = ItemEscrow
          L1_3 = L1_3.returnRows
          L2_3 = ItemEscrow
          L2_3 = L2_3.heldRows
          L3_3 = "onion"
          L4_3 = L8_2.id
          L2_3, L3_3, L4_3 = L2_3(L3_3, L4_3)
          L1_3(L2_3, L3_3, L4_3)
        end
      end
    end
    L9_2(L10_2, L11_2)
  end
  L3_2 = MySQL
  L3_2 = L3_2.query
  L3_2 = L3_2.await
  L4_2 = "DELETE FROM apex_phone_onion WHERE owner = ?"
  L5_2 = {}
  L6_2 = L1_2
  L5_2[1] = L6_2
  L3_2(L4_2, L5_2)
  L3_2 = MySQL
  L3_2 = L3_2.query
  L3_2 = L3_2.await
  L4_2 = "DELETE FROM apex_phone_onion_id WHERE citizenid = ?"
  L5_2 = {}
  L6_2 = L1_2
  L5_2[1] = L6_2
  L3_2(L4_2, L5_2)
  L3_2 = L15_1
  L4_2 = L13_1
  L5_2 = L1_2
  L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2 = L4_2(L5_2)
  return L3_2(L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2)
end
L39_1["onion.newIdentity"] = L40_1
L39_1 = RPC
function L40_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2
  L2_2 = "WHERE 1=1"
  L3_2 = {}
  L4_2 = L6_1
  L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2 = L4_2()
  L3_2[1] = L4_2
  L3_2[2] = L5_2
  L3_2[3] = L6_2
  L3_2[4] = L7_2
  L3_2[5] = L8_2
  L3_2[6] = L9_2
  L3_2[7] = L10_2
  L3_2[8] = L11_2
  L3_2[9] = L12_2
  L3_2[10] = L13_2
  L3_2[11] = L14_2
  L3_2[12] = L15_2
  L4_2 = A1_2.category
  if L4_2 then
    L4_2 = A1_2.category
    if "" ~= L4_2 then
      L4_2 = L2_2
      L5_2 = " AND category = ?"
      L4_2 = L4_2 .. L5_2
      L2_2 = L4_2
      L4_2 = #L3_2
      L4_2 = L4_2 + 1
      L5_2 = tostring
      L6_2 = A1_2.category
      L5_2 = L5_2(L6_2)
      L6_2 = L5_2
      L5_2 = L5_2.sub
      L7_2 = 1
      L8_2 = 30
      L5_2 = L5_2(L6_2, L7_2, L8_2)
      L3_2[L4_2] = L5_2
    end
  end
  L4_2 = A1_2.q
  if L4_2 then
    L4_2 = A1_2.q
    if "" ~= L4_2 then
      L4_2 = L2_2
      L5_2 = " AND (LOWER(title) LIKE ? OR LOWER(description) LIKE ?)"
      L4_2 = L4_2 .. L5_2
      L2_2 = L4_2
      L4_2 = "%"
      L5_2 = tostring
      L6_2 = A1_2.q
      L5_2 = L5_2(L6_2)
      L6_2 = L5_2
      L5_2 = L5_2.sub
      L7_2 = 1
      L8_2 = 60
      L5_2 = L5_2(L6_2, L7_2, L8_2)
      L6_2 = L5_2
      L5_2 = L5_2.lower
      L5_2 = L5_2(L6_2)
      L6_2 = "%"
      L4_2 = L4_2 .. L5_2 .. L6_2
      L5_2 = #L3_2
      L5_2 = L5_2 + 1
      L3_2[L5_2] = L4_2
      L5_2 = #L3_2
      L5_2 = L5_2 + 1
      L3_2[L5_2] = L4_2
    end
  end
  L4_2 = [[
SELECT l.id, l.owner, l.seller_handle, l.title, l.description, l.price, l.stock, l.category, LEFT(l.image, ?) AS image, l.created,
        i.rep AS srep, i.votes AS svotes, i.sales AS ssales]]
  L5_2 = L38_1
  L5_2 = L5_2()
  if L5_2 then
    L5_2 = L36_1
    if L5_2 then
      goto lbl_67
    end
  end
  L5_2 = ""
  ::lbl_67::
  L6_2 = " FROM (SELECT id FROM apex_phone_onion "
  L7_2 = L2_2
  L8_2 = " ORDER BY (stock > 0) DESC, created DESC, id DESC LIMIT 100) k"
  L9_2 = " JOIN apex_phone_onion l ON l.id = k.id LEFT JOIN apex_phone_onion_id i ON i.citizenid = l.owner"
  L10_2 = " ORDER BY (l.stock > 0) DESC, l.created DESC, l.id DESC"
  L4_2 = L4_2 .. L5_2 .. L6_2 .. L7_2 .. L8_2 .. L9_2 .. L10_2
  L5_2 = MySQL
  L5_2 = L5_2.query
  L5_2 = L5_2.await
  L6_2 = L4_2
  L7_2 = L3_2
  L5_2 = L5_2(L6_2, L7_2)
  if not L5_2 then
    L5_2 = {}
  end
  L6_2 = GetCid
  L7_2 = A0_2
  L6_2 = L6_2(L7_2)
  L7_2 = ipairs
  L8_2 = L5_2
  L7_2, L8_2, L9_2, L10_2 = L7_2(L8_2)
  for L11_2, L12_2 in L7_2, L8_2, L9_2, L10_2 do
    L13_2 = L35_1
    L14_2 = L12_2
    L13_2(L14_2)
    L13_2 = L12_2.owner
    L13_2 = L13_2 == L6_2
    L12_2.mine = L13_2
    L13_2 = tonumber
    L14_2 = L12_2.svotes
    L13_2 = L13_2(L14_2)
    if not L13_2 then
      L13_2 = 0
    end
    if L13_2 > 0 then
      L13_2 = tonumber
      L14_2 = L12_2.srep
      L13_2 = L13_2(L14_2)
      if not L13_2 then
        L13_2 = 0
      end
      L14_2 = tonumber
      L15_2 = L12_2.svotes
      L14_2 = L14_2(L15_2)
      if not L14_2 then
        L14_2 = 1
      end
      L13_2 = L13_2 / L14_2
      if L13_2 then
        goto lbl_124
      end
    end
    L13_2 = 0
    ::lbl_124::
    L12_2.seller_rep = L13_2
    L13_2 = tonumber
    L14_2 = L12_2.ssales
    L13_2 = L13_2(L14_2)
    if not L13_2 then
      L13_2 = 0
    end
    L12_2.seller_sales = L13_2
    L13_2 = nil
    L14_2 = nil
    L15_2 = nil
    L12_2.ssales = nil
    L12_2.svotes = L15_2
    L12_2.srep = L14_2
    L12_2.owner = L13_2
  end
  return L5_2
end
L39_1["onion.list"] = L40_1
L39_1 = RPC
function L40_1(A0_2)
  local L1_2, L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2
  L1_2 = GetCid
  L2_2 = A0_2
  L1_2 = L1_2(L2_2)
  L2_2 = MySQL
  L2_2 = L2_2.query
  L2_2 = L2_2.await
  L3_2 = "SELECT l.*"
  L4_2 = L38_1
  L4_2 = L4_2()
  if L4_2 then
    L4_2 = L36_1
    L5_2 = L37_1
    L4_2 = L4_2 .. L5_2
    if L4_2 then
      goto lbl_18
    end
  end
  L4_2 = ""
  ::lbl_18::
  L5_2 = " FROM apex_phone_onion l WHERE l.owner = ? ORDER BY l.created DESC LIMIT 50"
  L3_2 = L3_2 .. L4_2 .. L5_2
  L4_2 = {}
  L5_2 = L1_2
  L4_2[1] = L5_2
  L2_2 = L2_2(L3_2, L4_2)
  if not L2_2 then
    L2_2 = {}
  end
  L3_2 = L13_1
  L4_2 = L1_2
  L3_2 = L3_2(L4_2)
  L4_2 = ipairs
  L5_2 = L2_2
  L4_2, L5_2, L6_2, L7_2 = L4_2(L5_2)
  for L8_2, L9_2 in L4_2, L5_2, L6_2, L7_2 do
    L10_2 = L35_1
    L11_2 = L9_2
    L10_2(L11_2)
    L9_2.mine = true
    L10_2 = L14_1
    L11_2 = L3_2
    L10_2 = L10_2(L11_2)
    L9_2.seller_rep = L10_2
    L10_2 = tonumber
    L11_2 = L3_2.sales
    L10_2 = L10_2(L11_2)
    if not L10_2 then
      L10_2 = 0
    end
    L9_2.seller_sales = L10_2
    L9_2.owner = nil
  end
  return L2_2
end
L39_1["onion.mine"] = L40_1
L39_1 = RPC
function L40_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2, L19_2, L20_2, L21_2, L22_2, L23_2, L24_2, L25_2, L26_2, L27_2, L28_2
  L2_2 = GetCid
  L3_2 = A0_2
  L2_2 = L2_2(L3_2)
  if not L2_2 then
    L3_2 = {}
    L3_2.error = "noplayer"
    return L3_2
  end
  L3_2 = L13_1
  L4_2 = L2_2
  L3_2 = L3_2(L4_2)
  L4_2 = L3_1
  L4_2 = L4_2()
  L5_2 = tostring
  L6_2 = A1_2.title
  if not L6_2 then
    L6_2 = ""
  end
  L5_2 = L5_2(L6_2)
  L6_2 = L5_2
  L5_2 = L5_2.sub
  L7_2 = 1
  L8_2 = 80
  L5_2 = L5_2(L6_2, L7_2, L8_2)
  L6_2 = L4_1
  L7_2 = A1_2.price
  L8_2 = L4_2.maxPrice
  L9_2 = 6
  L6_2 = L6_2(L7_2, L8_2, L9_2)
  if "" == L5_2 or not L6_2 then
    L7_2 = {}
    L7_2.error = "invalid"
    return L7_2
  end
  L7_2 = 1
  L8_2 = A1_2.stock
  if nil ~= L8_2 then
    L8_2 = L5_1
    L9_2 = A1_2.stock
    L10_2 = 1
    L11_2 = L4_2.maxStock
    L8_2 = L8_2(L9_2, L10_2, L11_2)
    L7_2 = L8_2
    if not L7_2 then
      L8_2 = {}
      L8_2.error = "invalid"
      return L8_2
    end
  end
  L8_2 = L7_1
  L9_2 = A1_2.image
  L8_2, L9_2 = L8_2(L9_2)
  if not L9_2 then
    L10_2 = {}
    L10_2.error = "toolarge"
    return L10_2
  end
  L10_2 = A1_2.kind
  if "item" ~= L10_2 then
    L10_2 = A1_2.kind
    if "vehicle" ~= L10_2 then
      goto lbl_72
    end
  end
  L10_2 = A1_2.kind
  ::lbl_72::
  if not L10_2 then
    L10_2 = "other"
  end
  L11_2 = nil
  if "item" == L10_2 then
    L12_2 = nil
    L13_2 = L9_1
    L14_2 = A0_2
    L15_2 = A1_2.item_name
    L13_2, L14_2 = L13_2(L14_2, L15_2)
    L12_2 = L14_2
    L11_2 = L13_2
    if not L11_2 then
      L13_2 = {}
      L13_2.error = L12_2
      return L13_2
    end
  end
  L12_2 = nil
  L13_2 = nil
  if "item" == L10_2 then
    L14_2 = L10_1
    L14_2 = L14_2()
    if L14_2 then
      L14_2 = nil
      L15_2 = ItemEscrow
      L15_2 = L15_2.hold
      L16_2 = A0_2
      L17_2 = "onion"
      L18_2 = 0
      L19_2 = L11_2
      L20_2 = L7_2
      L15_2, L16_2, L17_2 = L15_2(L16_2, L17_2, L18_2, L19_2, L20_2)
      L13_2 = L17_2
      L14_2 = L16_2
      L12_2 = L15_2
      if not L12_2 then
        L15_2 = {}
        L16_2 = L14_2 or L16_2
        if not L14_2 then
          L16_2 = "escrow"
        end
        L15_2.error = L16_2
        return L15_2
      end
    end
  end
  L14_2 = pcall
  L15_2 = MySQL
  L15_2 = L15_2.insert
  L15_2 = L15_2.await
  L16_2 = "INSERT INTO apex_phone_onion (owner, seller_handle, title, description, price, stock, category, image, created, kind, item_name) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)"
  L17_2 = {}
  L18_2 = L2_2
  L19_2 = L3_2.handle
  L20_2 = L5_2
  L21_2 = tostring
  L22_2 = A1_2.description
  if not L22_2 then
    L22_2 = ""
  end
  L21_2 = L21_2(L22_2)
  L22_2 = L21_2
  L21_2 = L21_2.sub
  L23_2 = 1
  L24_2 = 1000
  L21_2 = L21_2(L22_2, L23_2, L24_2)
  L22_2 = L6_2
  if L12_2 then
    L23_2 = 0
    if L23_2 then
      goto lbl_144
    end
  end
  L23_2 = L7_2
  ::lbl_144::
  L24_2 = tostring
  L25_2 = A1_2.category
  if not L25_2 then
    L25_2 = "Diversos"
  end
  L24_2 = L24_2(L25_2)
  L25_2 = L24_2
  L24_2 = L24_2.sub
  L26_2 = 1
  L27_2 = 30
  L24_2 = L24_2(L25_2, L26_2, L27_2)
  L25_2 = L8_2
  L26_2 = Now
  L26_2 = L26_2()
  L27_2 = L10_2
  L28_2 = L11_2
  L17_2[1] = L18_2
  L17_2[2] = L19_2
  L17_2[3] = L20_2
  L17_2[4] = L21_2
  L17_2[5] = L22_2
  L17_2[6] = L23_2
  L17_2[7] = L24_2
  L17_2[8] = L25_2
  L17_2[9] = L26_2
  L17_2[10] = L27_2
  L17_2[11] = L28_2
  L14_2, L15_2 = L14_2(L15_2, L16_2, L17_2)
  if L14_2 then
    L16_2 = tonumber
    L17_2 = L15_2
    L16_2 = L16_2(L17_2)
    if L16_2 then
      goto lbl_169
    end
  end
  L16_2 = nil
  ::lbl_169::
  if not L16_2 then
    L17_2 = ipairs
    L18_2 = L13_2 or L18_2
    if not L13_2 then
      L18_2 = {}
    end
    L17_2, L18_2, L19_2, L20_2 = L17_2(L18_2)
    for L21_2, L22_2 in L17_2, L18_2, L19_2, L20_2 do
      L23_2 = ItemEscrow
      L23_2 = L23_2.returnToOwner
      L24_2 = L22_2
      L25_2 = {}
      L25_2.silent = true
      L23_2(L24_2, L25_2)
    end
    if not L14_2 then
      L17_2 = error
      L18_2 = L15_2
      L19_2 = 0
      L17_2(L18_2, L19_2)
    end
    L17_2 = {}
    L17_2.error = "internal"
    return L17_2
  end
  if L12_2 then
    L17_2 = ItemEscrow
    L17_2 = L17_2.link
    L18_2 = L13_2
    L19_2 = L16_2
    L17_2 = L17_2(L18_2, L19_2)
    if not L17_2 then
      L17_2 = print
      L18_2 = "^3[unique_phone]^0 onion.create %d: escrow #%d was not fully linked; listing voided and item returned"
      L19_2 = L18_2
      L18_2 = L18_2.format
      L20_2 = L16_2
      L21_2 = L12_2
      L18_2, L19_2, L20_2, L21_2, L22_2, L23_2, L24_2, L25_2, L26_2, L27_2, L28_2 = L18_2(L19_2, L20_2, L21_2)
      L17_2(L18_2, L19_2, L20_2, L21_2, L22_2, L23_2, L24_2, L25_2, L26_2, L27_2, L28_2)
      L17_2 = MySQL
      L17_2 = L17_2.update
      L17_2 = L17_2.await
      L18_2 = "DELETE FROM apex_phone_onion WHERE id = ? AND owner = ?"
      L19_2 = {}
      L20_2 = L16_2
      L21_2 = L2_2
      L19_2[1] = L20_2
      L19_2[2] = L21_2
      L17_2(L18_2, L19_2)
      L17_2 = ipairs
      L18_2 = L13_2
      L17_2, L18_2, L19_2, L20_2 = L17_2(L18_2)
      for L21_2, L22_2 in L17_2, L18_2, L19_2, L20_2 do
        L23_2 = ItemEscrow
        L23_2 = L23_2.returnToOwner
        L24_2 = L22_2
        L25_2 = {}
        L25_2.silent = true
        L23_2(L24_2, L25_2)
      end
      L17_2 = {}
      L17_2.error = "escrow"
      return L17_2
    end
    L17_2 = MySQL
    L17_2 = L17_2.update
    L17_2 = L17_2.await
    L18_2 = "UPDATE apex_phone_onion SET stock = ? WHERE id = ? AND stock = 0"
    L19_2 = {}
    L20_2 = L7_2
    L21_2 = L16_2
    L19_2[1] = L20_2
    L19_2[2] = L21_2
    L17_2(L18_2, L19_2)
  end
  L17_2 = Dbg
  L18_2 = "onion"
  L19_2 = "create %d kind=%s item=%s stock=%d escrow=%s"
  L20_2 = L16_2
  L21_2 = L10_2
  L22_2 = tostring
  L23_2 = L11_2
  L22_2 = L22_2(L23_2)
  L23_2 = L7_2
  L24_2 = tostring
  L25_2 = L12_2
  L24_2, L25_2, L26_2, L27_2, L28_2 = L24_2(L25_2)
  L17_2(L18_2, L19_2, L20_2, L21_2, L22_2, L23_2, L24_2, L25_2, L26_2, L27_2, L28_2)
  L17_2 = {}
  L17_2.id = L16_2
  L17_2.ok = true
  L18_2 = nil ~= L12_2
  L17_2.escrow = L18_2
  return L17_2
end
L39_1["onion.create"] = L40_1
function L39_1(A0_2, A1_2, A2_2)
  local L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2, L19_2, L20_2, L21_2, L22_2, L23_2, L24_2, L25_2, L26_2, L27_2, L28_2, L29_2, L30_2, L31_2, L32_2, L33_2, L34_2, L35_2
  L3_2 = MySQL
  L3_2 = L3_2.single
  L3_2 = L3_2.await
  L4_2 = "SELECT * FROM apex_phone_onion WHERE id = ? AND owner = ?"
  L5_2 = {}
  L6_2 = tonumber
  L7_2 = A2_2.id
  L6_2 = L6_2(L7_2)
  L7_2 = A1_2
  L5_2[1] = L6_2
  L5_2[2] = L7_2
  L3_2 = L3_2(L4_2, L5_2)
  if not L3_2 then
    L4_2 = {}
    L4_2.error = "forbidden"
    return L4_2
  end
  L4_2 = L3_1
  L4_2 = L4_2()
  L5_2 = L3_2.title
  L6_2 = A2_2.title
  if nil ~= L6_2 then
    L6_2 = tostring
    L7_2 = A2_2.title
    L6_2 = L6_2(L7_2)
    L7_2 = L6_2
    L6_2 = L6_2.sub
    L8_2 = 1
    L9_2 = 80
    L6_2 = L6_2(L7_2, L8_2, L9_2)
    L5_2 = L6_2
    if "" == L5_2 then
      L6_2 = {}
      L6_2.error = "invalid"
      return L6_2
    end
  end
  L6_2 = L3_2.price
  L7_2 = A2_2.price
  if nil ~= L7_2 then
    L7_2 = L4_1
    L8_2 = A2_2.price
    L9_2 = L4_2.maxPrice
    L10_2 = 6
    L7_2 = L7_2(L8_2, L9_2, L10_2)
    L6_2 = L7_2
    if not L6_2 then
      L7_2 = {}
      L7_2.error = "invalid"
      return L7_2
    end
  end
  L7_2 = L3_2.stock
  L8_2 = A2_2.stock
  if nil ~= L8_2 then
    L8_2 = L5_1
    L9_2 = A2_2.stock
    L10_2 = 0
    L11_2 = L4_2.maxStock
    L8_2 = L8_2(L9_2, L10_2, L11_2)
    L7_2 = L8_2
    if not L7_2 then
      L8_2 = {}
      L8_2.error = "invalid"
      return L8_2
    end
  end
  L8_2 = L3_2.image
  L9_2 = A2_2.image
  if nil ~= L9_2 then
    L9_2 = nil
    L10_2 = L7_1
    L11_2 = A2_2.image
    L10_2, L11_2 = L10_2(L11_2)
    L9_2 = L11_2
    L8_2 = L10_2
    if not L9_2 then
      L10_2 = {}
      L10_2.error = "toolarge"
      return L10_2
    end
  end
  L9_2 = A2_2.kind
  if "item" ~= L9_2 then
    L9_2 = A2_2.kind
    if "vehicle" ~= L9_2 then
      L9_2 = A2_2.kind
      if "other" ~= L9_2 then
        goto lbl_99
      end
    end
  end
  L9_2 = A2_2.kind
  ::lbl_99::
  if not L9_2 then
    L9_2 = L3_2.kind
    if not L9_2 then
      L9_2 = "other"
    end
  end
  L10_2 = L3_2.item_name
  L11_2 = A2_2.item_name
  if nil ~= L11_2 then
    L11_2 = tostring
    L12_2 = A2_2.item_name
    L11_2 = L11_2(L12_2)
    L12_2 = tostring
    L13_2 = L3_2.item_name
    L12_2 = L12_2(L13_2)
  end
  L11_2 = L3_2.kind
  L11_2 = L3_2.item_name
  L11_2 = "item" == L9_2 and L11_2
  if "item" ~= L9_2 then
    L10_2 = nil
  elseif L11_2 then
    L12_2 = nil
    L13_2 = L9_1
    L14_2 = A0_2
    L15_2 = A2_2.item_name
    if nil ~= L15_2 then
      L15_2 = A2_2.item_name
      if L15_2 then
        goto lbl_141
      end
    end
    L15_2 = L3_2.item_name
    ::lbl_141::
    L13_2, L14_2 = L13_2(L14_2, L15_2)
    L12_2 = L14_2
    L10_2 = L13_2
    if not L10_2 then
      L13_2 = {}
      L13_2.error = L12_2
      return L13_2
    end
  end
  L12_2 = ItemEscrow
  L12_2 = nil ~= L12_2
  L13_2 = {}
  L14_2 = 0
  L15_2 = false
  if L12_2 then
    L16_2 = ItemEscrow
    L16_2 = L16_2.waitReady
    L16_2 = L16_2()
    if not L16_2 then
      L16_2 = {}
      L16_2.error = "escrow"
      return L16_2
    end
    L16_2 = ItemEscrow
    L16_2 = L16_2.heldRows
    L17_2 = "onion"
    L18_2 = L3_2.id
    L16_2 = L16_2(L17_2, L18_2)
    L13_2 = L16_2
    L16_2 = ipairs
    L17_2 = L13_2
    L16_2, L17_2, L18_2, L19_2 = L16_2(L17_2)
    for L20_2, L21_2 in L16_2, L17_2, L18_2, L19_2 do
      L22_2 = L21_2.count
      L14_2 = L14_2 + L22_2
    end
    L16_2 = ItemEscrow
    L16_2 = L16_2.lastRow
    L17_2 = "onion"
    L18_2 = L3_2.id
    L19_2 = true
    L16_2 = L16_2(L17_2, L18_2, L19_2)
    L15_2 = nil ~= L16_2
  end
  L16_2 = math
  L16_2 = L16_2.tointeger
  L17_2 = tonumber
  L18_2 = L3_2.stock
  L17_2 = L17_2(L18_2)
  if not L17_2 then
    L17_2 = 0
  end
  L16_2 = L16_2(L17_2)
  if not L16_2 then
    L16_2 = 0
  end
  L17_2 = 0
  L18_2 = 0
  L19_2 = false
  if L12_2 then
    if "item" ~= L9_2 or L11_2 then
      L19_2 = L14_2 > 0
      if "item" == L9_2 and L7_2 > 0 then
        L20_2 = L10_1
        L20_2 = L20_2()
        if L20_2 then
          L17_2 = L7_2
        end
      end
    elseif L15_2 then
      if L7_2 > L16_2 then
        L20_2 = L10_1
        L20_2 = L20_2()
        if L20_2 then
          L17_2 = L7_2 - L16_2
        end
      end
      if L7_2 < L14_2 then
        L18_2 = L14_2 - L7_2
      end
    end
  end
  L20_2 = nil
  L21_2 = {}
  if L17_2 > 0 then
    L22_2 = nil
    L23_2 = nil
    L24_2 = ItemEscrow
    L24_2 = L24_2.hold
    L25_2 = A0_2
    L26_2 = "onion"
    L27_2 = L3_2.id
    L28_2 = L10_2
    L29_2 = L17_2
    L24_2, L25_2, L26_2 = L24_2(L25_2, L26_2, L27_2, L28_2, L29_2)
    L23_2 = L26_2
    L22_2 = L25_2
    L20_2 = L24_2
    if not L20_2 then
      L24_2 = {}
      L25_2 = L22_2 or L25_2
      if not L22_2 then
        L25_2 = "escrow"
      end
      L24_2.error = L25_2
      return L24_2
    end
    L21_2 = L23_2 or L21_2
    if not L23_2 then
      L24_2 = {}
      L25_2 = L20_2
      L24_2[1] = L25_2
      L21_2 = L24_2
    end
  end
  L22_2 = pcall
  L23_2 = MySQL
  L23_2 = L23_2.update
  L23_2 = L23_2.await
  L24_2 = "UPDATE apex_phone_onion SET title = ?, description = ?, price = ?, stock = ?, category = ?, image = ?, kind = ?, item_name = ? WHERE id = ? AND owner = ?"
  L25_2 = {}
  L26_2 = L5_2
  L27_2 = A2_2.description
  if nil ~= L27_2 then
    L27_2 = tostring
    L28_2 = A2_2.description
    L27_2 = L27_2(L28_2)
    L28_2 = L27_2
    L27_2 = L27_2.sub
    L29_2 = 1
    L30_2 = 1000
    L27_2 = L27_2(L28_2, L29_2, L30_2)
    if L27_2 then
      goto lbl_304
    end
  end
  L27_2 = L3_2.description
  ::lbl_304::
  L28_2 = L6_2
  L29_2 = L7_2
  L30_2 = A2_2.category
  if L30_2 then
    L30_2 = tostring
    L31_2 = A2_2.category
    L30_2 = L30_2(L31_2)
    L31_2 = L30_2
    L30_2 = L30_2.sub
    L32_2 = 1
    L33_2 = 30
    L30_2 = L30_2(L31_2, L32_2, L33_2)
    if L30_2 then
      goto lbl_319
    end
  end
  L30_2 = L3_2.category
  ::lbl_319::
  L31_2 = L8_2
  L32_2 = L9_2
  L33_2 = L10_2
  L34_2 = L3_2.id
  L35_2 = A1_2
  L25_2[1] = L26_2
  L25_2[2] = L27_2
  L25_2[3] = L28_2
  L25_2[4] = L29_2
  L25_2[5] = L30_2
  L25_2[6] = L31_2
  L25_2[7] = L32_2
  L25_2[8] = L33_2
  L25_2[9] = L34_2
  L25_2[10] = L35_2
  L22_2, L23_2 = L22_2(L23_2, L24_2, L25_2)
  if not L22_2 then
    L24_2 = ipairs
    L25_2 = L21_2
    L24_2, L25_2, L26_2, L27_2 = L24_2(L25_2)
    for L28_2, L29_2 in L24_2, L25_2, L26_2, L27_2 do
      L30_2 = ItemEscrow
      L30_2 = L30_2.returnToOwner
      L31_2 = L29_2
      L32_2 = {}
      L32_2.silent = true
      L30_2(L31_2, L32_2)
    end
    L24_2 = error
    L25_2 = L23_2
    L26_2 = 0
    L24_2(L25_2, L26_2)
  end
  L24_2 = {}
  L24_2.ok = true
  if L20_2 then
    L24_2.escrow = true
  end
  if L19_2 then
    L25_2 = ItemEscrow
    L25_2 = L25_2.returnRows
    L26_2 = L13_2
    L27_2 = nil
    L28_2 = {}
    L28_2.silent = true
    L25_2 = L25_2(L26_2, L27_2, L28_2)
    L24_2.item = L25_2
  elseif L18_2 > 0 then
    L25_2 = ItemEscrow
    L25_2 = L25_2.returnRows
    L26_2 = L13_2
    L27_2 = L18_2
    L28_2 = {}
    L28_2.silent = true
    L25_2 = L25_2(L26_2, L27_2, L28_2)
    L24_2.item = L25_2
  end
  L25_2 = Dbg
  L26_2 = "onion"
  L27_2 = "update %d stock %d->%d escrow=%d new=%s returned=%s"
  L28_2 = L3_2.id
  L29_2 = L16_2
  L30_2 = L7_2
  L31_2 = L14_2
  L32_2 = tostring
  L33_2 = L20_2
  L32_2 = L32_2(L33_2)
  if L19_2 then
    L33_2 = "all"
    if L33_2 then
      goto lbl_393
    end
  end
  L33_2 = tostring
  L34_2 = L18_2
  L33_2 = L33_2(L34_2)
  ::lbl_393::
  L25_2(L26_2, L27_2, L28_2, L29_2, L30_2, L31_2, L32_2, L33_2)
  return L24_2
end
L40_1 = RPC
function L41_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2
  L2_2 = tonumber
  L3_2 = A1_2.id
  L2_2 = L2_2(L3_2)
  if not L2_2 then
    L3_2 = {}
    L3_2.error = "forbidden"
    return L3_2
  end
  L3_2 = L12_1
  L4_2 = L11_1
  L5_2 = L2_2
  L4_2 = L4_2(L5_2)
  L5_2 = L39_1
  L6_2 = A0_2
  L7_2 = GetCid
  L8_2 = A0_2
  L7_2 = L7_2(L8_2)
  L8_2 = A1_2
  return L3_2(L4_2, L5_2, L6_2, L7_2, L8_2)
end
L40_1["onion.update"] = L41_1
L40_1 = RPC
function L41_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2, L6_2
  L2_2 = GetCid
  L3_2 = A0_2
  L2_2 = L2_2(L3_2)
  L3_2 = tonumber
  L4_2 = A1_2.id
  L3_2 = L3_2(L4_2)
  if not L2_2 or not L3_2 then
    L4_2 = {}
    L4_2.ok = true
    return L4_2
  end
  L4_2 = L12_1
  L5_2 = L11_1
  L6_2 = L3_2
  L5_2 = L5_2(L6_2)
  function L6_2()
    local L0_3, L1_3, L2_3, L3_3, L4_3, L5_3
    L0_3 = MySQL
    L0_3 = L0_3.update
    L0_3 = L0_3.await
    L1_3 = "DELETE FROM apex_phone_onion WHERE id = ? AND owner = ?"
    L2_3 = {}
    L3_3 = L3_2
    L4_3 = L2_2
    L2_3[1] = L3_3
    L2_3[2] = L4_3
    L0_3 = L0_3(L1_3, L2_3)
    L1_3 = {}
    L1_3.ok = true
    L2_3 = tonumber
    L3_3 = L0_3
    L2_3 = L2_3(L3_3)
    if not L2_3 then
      L2_3 = 0
    end
    if 1 == L2_3 then
      L2_3 = L38_1
      L2_3 = L2_3()
      if L2_3 then
        L2_3 = ItemEscrow
        L2_3 = L2_3.returnRows
        L3_3 = ItemEscrow
        L3_3 = L3_3.heldRows
        L4_3 = "onion"
        L5_3 = L3_2
        L3_3 = L3_3(L4_3, L5_3)
        L4_3 = nil
        L5_3 = {}
        L5_3.silent = true
        L2_3 = L2_3(L3_3, L4_3, L5_3)
        L1_3.item = L2_3
      end
    end
    return L1_3
  end
  return L4_2(L5_2, L6_2)
end
L40_1["onion.delete"] = L41_1
function L40_1(A0_2, A1_2, A2_2, A3_2)
  local L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2, L19_2
  L4_2 = L13_1
  L5_2 = A2_2
  L4_2 = L4_2(L5_2)
  L5_2 = MySQL
  L5_2 = L5_2.single
  L5_2 = L5_2.await
  L6_2 = "SELECT id, owner, seller_handle, title, price, stock FROM apex_phone_onion WHERE id = ?"
  L7_2 = {}
  L8_2 = A3_2
  L7_2[1] = L8_2
  L5_2 = L5_2(L6_2, L7_2)
  if not L5_2 then
    L6_2 = {}
    L6_2.ok = false
    L6_2.error = "gone"
    return L6_2
  end
  L6_2 = L5_2.owner
  if L6_2 == A2_2 then
    L6_2 = {}
    L6_2.ok = false
    L6_2.error = "own"
    return L6_2
  end
  L6_2 = tonumber
  L7_2 = L5_2.stock
  L6_2 = L6_2(L7_2)
  if not L6_2 then
    L6_2 = 0
  end
  if L6_2 <= 0 then
    L6_2 = {}
    L6_2.ok = false
    L6_2.error = "stock"
    return L6_2
  end
  L6_2 = L4_1
  L7_2 = L5_2.price
  L8_2 = nil
  L9_2 = 6
  L6_2 = L6_2(L7_2, L8_2, L9_2)
  if not L6_2 then
    L7_2 = {}
    L7_2.ok = false
    L7_2.error = "invalid"
    return L7_2
  end
  L7_2 = A1_2.price
  if nil ~= L7_2 then
    L7_2 = L4_1
    L8_2 = A1_2.price
    L9_2 = nil
    L10_2 = 6
    L7_2 = L7_2(L8_2, L9_2, L10_2)
    if L7_2 ~= L6_2 then
      L7_2 = {}
      L7_2.ok = false
      L7_2.error = "changed"
      return L7_2
    end
  end
  L7_2 = MySQL
  L7_2 = L7_2.update
  L7_2 = L7_2.await
  L8_2 = "UPDATE apex_phone_onion SET stock = stock - 1 WHERE id = ? AND stock >= 1 AND owner <> ?"
  L9_2 = {}
  L10_2 = L5_2.id
  L11_2 = A2_2
  L9_2[1] = L10_2
  L9_2[2] = L11_2
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
    L8_2.error = "stock"
    return L8_2
  end
  L8_2 = L18_1
  L9_2 = A2_2
  L10_2 = L6_2
  L11_2 = "Onion: "
  L12_2 = L5_2.title
  L11_2 = L11_2 .. L12_2
  L8_2 = L8_2(L9_2, L10_2, L11_2)
  if not L8_2 then
    L8_2 = MySQL
    L8_2 = L8_2.update
    L8_2 = L8_2.await
    L9_2 = "UPDATE apex_phone_onion SET stock = stock + 1 WHERE id = ?"
    L10_2 = {}
    L11_2 = L5_2.id
    L10_2[1] = L11_2
    L8_2(L9_2, L10_2)
    L8_2 = {}
    L8_2.ok = false
    L8_2.error = "funds"
    return L8_2
  end
  L8_2 = MySQL
  L8_2 = L8_2.insert
  L8_2 = L8_2.await
  L9_2 = "INSERT INTO apex_phone_onion_orders (listing, buyer, buyer_handle, seller, seller_handle, title, price, status, created) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)"
  L10_2 = {}
  L11_2 = L5_2.id
  L12_2 = A2_2
  L13_2 = L4_2.handle
  L14_2 = L5_2.owner
  L15_2 = L5_2.seller_handle
  L16_2 = L5_2.title
  L17_2 = L6_2
  L18_2 = "pago"
  L19_2 = Now
  L19_2 = L19_2()
  L10_2[1] = L11_2
  L10_2[2] = L12_2
  L10_2[3] = L13_2
  L10_2[4] = L14_2
  L10_2[5] = L15_2
  L10_2[6] = L16_2
  L10_2[7] = L17_2
  L10_2[8] = L18_2
  L10_2[9] = L19_2
  L8_2 = L8_2(L9_2, L10_2)
  L9_2 = nil
  L10_2 = L38_1
  L10_2 = L10_2()
  if L10_2 then
    L10_2 = tonumber
    L11_2 = L8_2
    L10_2 = L10_2(L11_2)
    if L10_2 then
      L10_2 = ItemEscrow
      L10_2 = L10_2.reserve
      L11_2 = "onion"
      L12_2 = L5_2.id
      L13_2 = tonumber
      L14_2 = L8_2
      L13_2 = L13_2(L14_2)
      L14_2 = A2_2
      L10_2 = L10_2(L11_2, L12_2, L13_2, L14_2)
      if L10_2 then
        L11_2 = {}
        L11_2.status = "reserved"
        L12_2 = L10_2.item
        L11_2.name = L12_2
        L12_2 = ItemEscrow
        L12_2 = L12_2.label
        L13_2 = L10_2.item
        L12_2 = L12_2(L13_2)
        L11_2.label = L12_2
        L12_2 = L10_2.count
        L11_2.count = L12_2
        L9_2 = L11_2
      end
    end
  end
  L10_2 = NotifyCitizen
  L11_2 = L5_2.owner
  L12_2 = "onion"
  L13_2 = "Venda no Onion"
  L14_2 = L4_2.handle
  L15_2 = " comprou \""
  L16_2 = L5_2.title
  L17_2 = "\""
  L14_2 = L14_2 .. L15_2 .. L16_2 .. L17_2
  L15_2 = nil
  L16_2 = {}
  L16_2.throttle = false
  L10_2(L11_2, L12_2, L13_2, L14_2, L15_2, L16_2)
  L10_2 = Dbg
  L11_2 = "onion"
  L12_2 = "buy %d order %s: item=%s"
  L13_2 = L5_2.id
  L14_2 = tostring
  L15_2 = L8_2
  L14_2 = L14_2(L15_2)
  if L9_2 then
    L15_2 = "reserved"
    if L15_2 then
      goto lbl_193
    end
  end
  L15_2 = "manual"
  ::lbl_193::
  L10_2(L11_2, L12_2, L13_2, L14_2, L15_2)
  L10_2 = {}
  L10_2.ok = true
  L10_2.item = L9_2
  return L10_2
end
L41_1 = RPC
function L42_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2
  L2_2 = GetCid
  L3_2 = A0_2
  L2_2 = L2_2(L3_2)
  if not L2_2 then
    L3_2 = {}
    L3_2.ok = false
    L3_2.error = "noplayer"
    return L3_2
  end
  L3_2 = tonumber
  L4_2 = A1_2.id
  L3_2 = L3_2(L4_2)
  if not L3_2 then
    L4_2 = {}
    L4_2.ok = false
    L4_2.error = "gone"
    return L4_2
  end
  L4_2 = ItemEscrow
  if L4_2 then
    L4_2 = ItemEscrow
    L4_2 = L4_2.waitReady
    L4_2()
  end
  L4_2 = L12_1
  L5_2 = L11_1
  L6_2 = L3_2
  L5_2 = L5_2(L6_2)
  L6_2 = L40_1
  L7_2 = A0_2
  L8_2 = A1_2
  L9_2 = L2_2
  L10_2 = L3_2
  return L4_2(L5_2, L6_2, L7_2, L8_2, L9_2, L10_2)
end
L41_1["onion.buy"] = L42_1
L41_1 = RPC
function L42_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2
  L2_2 = GetCid
  L3_2 = A0_2
  L2_2 = L2_2(L3_2)
  L3_2 = A1_2.role
  if "seller" == L3_2 then
    L3_2 = "seller"
    if L3_2 then
      goto lbl_11
    end
  end
  L3_2 = "buyer"
  ::lbl_11::
  L4_2 = MySQL
  L4_2 = L4_2.query
  L4_2 = L4_2.await
  L5_2 = "SELECT id, buyer_handle, seller_handle, title, price, status, rating, created FROM apex_phone_onion_orders WHERE "
  L6_2 = L3_2
  L7_2 = " = ? ORDER BY created DESC LIMIT 60"
  L5_2 = L5_2 .. L6_2 .. L7_2
  L6_2 = {}
  L7_2 = L2_2
  L6_2[1] = L7_2
  L4_2 = L4_2(L5_2, L6_2)
  if not L4_2 then
    L4_2 = {}
  end
  L5_2 = ipairs
  L6_2 = L4_2
  L5_2, L6_2, L7_2, L8_2 = L5_2(L6_2)
  for L9_2, L10_2 in L5_2, L6_2, L7_2, L8_2 do
    L11_2 = tonumber
    L12_2 = L10_2.price
    L11_2 = L11_2(L12_2)
    if not L11_2 then
      L11_2 = 0
    end
    L10_2.price = L11_2
  end
  return L4_2
end
L41_1["onion.orders"] = L42_1
L41_1 = RPC
function L42_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2
  L2_2 = GetCid
  L3_2 = A0_2
  L2_2 = L2_2(L3_2)
  L3_2 = MySQL
  L3_2 = L3_2.single
  L3_2 = L3_2.await
  L4_2 = "SELECT * FROM apex_phone_onion_orders WHERE id = ? AND seller = ?"
  L5_2 = {}
  L6_2 = tonumber
  L7_2 = A1_2.id
  L6_2 = L6_2(L7_2)
  L7_2 = L2_2
  L5_2[1] = L6_2
  L5_2[2] = L7_2
  L3_2 = L3_2(L4_2, L5_2)
  if L3_2 then
    L4_2 = L3_2.status
    if "pago" == L4_2 then
      goto lbl_25
    end
  end
  L4_2 = {}
  L4_2.error = "forbidden"
  do return L4_2 end
  ::lbl_25::
  L4_2 = MySQL
  L4_2 = L4_2.update
  L4_2 = L4_2.await
  L5_2 = "UPDATE apex_phone_onion_orders SET status = ? WHERE id = ? AND seller = ? AND status = ?"
  L6_2 = {}
  L7_2 = "enviado"
  L8_2 = L3_2.id
  L9_2 = L2_2
  L10_2 = "pago"
  L6_2[1] = L7_2
  L6_2[2] = L8_2
  L6_2[3] = L9_2
  L6_2[4] = L10_2
  L4_2 = L4_2(L5_2, L6_2)
  L5_2 = tonumber
  L6_2 = L4_2
  L5_2 = L5_2(L6_2)
  if not L5_2 then
    L5_2 = 0
  end
  if 1 ~= L5_2 then
    L5_2 = {}
    L5_2.error = "forbidden"
    return L5_2
  end
  L5_2 = nil
  L6_2 = nil
  L7_2 = ItemEscrow
  if L7_2 then
    L7_2 = ItemEscrow
    L7_2 = L7_2.waitReady
    L7_2 = L7_2()
    if L7_2 then
      L7_2 = ItemEscrow
      L7_2 = L7_2.unitFor
      L8_2 = "onion"
      L9_2 = L3_2.id
      L10_2 = L3_2.buyer
      L7_2 = L7_2(L8_2, L9_2, L10_2)
      if L7_2 then
        L8_2 = ItemEscrow
        L8_2 = L8_2.giveTo
        L9_2 = L7_2.id
        L10_2 = L3_2.buyer
        L8_2 = L8_2(L9_2, L10_2)
        L6_2 = "given" == L8_2
        L9_2 = {}
        L9_2.status = "sent"
        L5_2 = L9_2
      end
    end
  end
  L7_2 = NotifyCitizen
  L8_2 = L3_2.buyer
  L9_2 = "onion"
  L10_2 = "A caminho"
  L11_2 = L3_2.seller_handle
  L12_2 = " marcou \""
  L13_2 = L3_2.title
  L14_2 = "\" como enviado"
  if L6_2 then
    L15_2 = " \194\183 j\195\161 est\195\161 no teu invent\195\161rio"
    if L15_2 then
      goto lbl_93
    end
  end
  L15_2 = ""
  ::lbl_93::
  L11_2 = L11_2 .. L12_2 .. L13_2 .. L14_2 .. L15_2
  L12_2 = nil
  L13_2 = {}
  L13_2.throttle = false
  L7_2(L8_2, L9_2, L10_2, L11_2, L12_2, L13_2)
  L7_2 = {}
  L7_2.ok = true
  L7_2.item = L5_2
  return L7_2
end
L41_1["onion.ship"] = L42_1
L41_1 = RPC
function L42_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2
  L2_2 = GetCid
  L3_2 = A0_2
  L2_2 = L2_2(L3_2)
  L3_2 = MySQL
  L3_2 = L3_2.single
  L3_2 = L3_2.await
  L4_2 = "SELECT * FROM apex_phone_onion_orders WHERE id = ? AND buyer = ?"
  L5_2 = {}
  L6_2 = tonumber
  L7_2 = A1_2.id
  L6_2 = L6_2(L7_2)
  L7_2 = L2_2
  L5_2[1] = L6_2
  L5_2[2] = L7_2
  L3_2 = L3_2(L4_2, L5_2)
  if L3_2 then
    L4_2 = L3_2.status
    if "enviado" == L4_2 then
      goto lbl_28
    end
    L4_2 = L3_2.status
    if "pago" == L4_2 then
      goto lbl_28
    end
  end
  L4_2 = {}
  L4_2.error = "forbidden"
  do return L4_2 end
  ::lbl_28::
  L4_2 = MySQL
  L4_2 = L4_2.update
  L4_2 = L4_2.await
  L5_2 = "UPDATE apex_phone_onion_orders SET status = ? WHERE id = ? AND buyer = ? AND status IN (?, ?)"
  L6_2 = {}
  L7_2 = "concluido"
  L8_2 = L3_2.id
  L9_2 = L2_2
  L10_2 = "pago"
  L11_2 = "enviado"
  L6_2[1] = L7_2
  L6_2[2] = L8_2
  L6_2[3] = L9_2
  L6_2[4] = L10_2
  L6_2[5] = L11_2
  L4_2 = L4_2(L5_2, L6_2)
  L5_2 = tonumber
  L6_2 = L4_2
  L5_2 = L5_2(L6_2)
  if not L5_2 then
    L5_2 = 0
  end
  if 1 ~= L5_2 then
    L5_2 = {}
    L5_2.error = "forbidden"
    return L5_2
  end
  L5_2 = L4_1
  L6_2 = L3_2.price
  L7_2 = nil
  L8_2 = 6
  L5_2 = L5_2(L6_2, L7_2, L8_2)
  if L5_2 then
    L6_2 = L19_1
    L7_2 = L3_2.seller
    L8_2 = L5_2
    L9_2 = "Onion: venda de "
    L10_2 = L3_2.title
    L9_2 = L9_2 .. L10_2
    L6_2(L7_2, L8_2, L9_2)
  end
  L6_2 = MySQL
  L6_2 = L6_2.update
  L6_2 = L6_2.await
  L7_2 = "UPDATE apex_phone_onion_id SET sales = sales + 1 WHERE citizenid = ?"
  L8_2 = {}
  L9_2 = L3_2.seller
  L8_2[1] = L9_2
  L6_2(L7_2, L8_2)
  L6_2 = NotifyCitizen
  L7_2 = L3_2.seller
  L8_2 = "onion"
  L9_2 = "Pagamento libertado"
  L10_2 = string
  L10_2 = L10_2.format
  L11_2 = "%.4f \226\130\191 por \"%s\""
  L12_2 = tonumber
  L13_2 = L3_2.price
  L12_2 = L12_2(L13_2)
  if not L12_2 then
    L12_2 = 0
  end
  L13_2 = L3_2.title
  L10_2 = L10_2(L11_2, L12_2, L13_2)
  L11_2 = nil
  L12_2 = {}
  L12_2.throttle = false
  L6_2(L7_2, L8_2, L9_2, L10_2, L11_2, L12_2)
  L6_2 = nil
  L7_2 = ItemEscrow
  if L7_2 then
    L7_2 = ItemEscrow
    L7_2 = L7_2.waitReady
    L7_2 = L7_2()
    if L7_2 then
      L7_2 = ItemEscrow
      L7_2 = L7_2.unitFor
      L8_2 = "onion"
      L9_2 = L3_2.id
      L10_2 = L2_2
      L7_2 = L7_2(L8_2, L9_2, L10_2)
      if L7_2 then
        L8_2 = ItemEscrow
        L8_2 = L8_2.giveTo
        L9_2 = L7_2.id
        L10_2 = L2_2
        L11_2 = {}
        L11_2.silent = true
        L8_2, L9_2 = L8_2(L9_2, L10_2, L11_2)
        if not L8_2 then
          L10_2 = "pending"
          L9_2 = "retry"
          L8_2 = L10_2
        end
        L10_2 = {}
        L10_2.status = L8_2
        L10_2.reason = L9_2
        L11_2 = L7_2.item
        L10_2.name = L11_2
        L11_2 = ItemEscrow
        L11_2 = L11_2.label
        L12_2 = L7_2.item
        L11_2 = L11_2(L12_2)
        L10_2.label = L11_2
        L11_2 = L7_2.count
        L10_2.count = L11_2
        L6_2 = L10_2
      end
    end
  end
  L7_2 = {}
  L7_2.ok = true
  L7_2.item = L6_2
  return L7_2
end
L41_1["onion.confirm"] = L42_1
function L41_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2
  L2_2 = MySQL
  L2_2 = L2_2.update
  L2_2 = L2_2.await
  L3_2 = "UPDATE apex_phone_onion_orders SET status = ? WHERE id = ? AND buyer = ? AND status = ?"
  L4_2 = {}
  L5_2 = "cancelado"
  L6_2 = A1_2.id
  L7_2 = A0_2
  L8_2 = "pago"
  L4_2[1] = L5_2
  L4_2[2] = L6_2
  L4_2[3] = L7_2
  L4_2[4] = L8_2
  L2_2 = L2_2(L3_2, L4_2)
  L3_2 = tonumber
  L4_2 = L2_2
  L3_2 = L3_2(L4_2)
  if not L3_2 then
    L3_2 = 0
  end
  if 1 ~= L3_2 then
    L3_2 = {}
    L3_2.error = "forbidden"
    return L3_2
  end
  L3_2 = L4_1
  L4_2 = A1_2.price
  L5_2 = nil
  L6_2 = 6
  L3_2 = L3_2(L4_2, L5_2, L6_2)
  if L3_2 then
    L4_2 = L19_1
    L5_2 = A1_2.buyer
    L6_2 = L3_2
    L7_2 = "Onion: reembolso"
    L4_2(L5_2, L6_2, L7_2)
  end
  L4_2 = ItemEscrow
  if L4_2 then
    L4_2 = ItemEscrow
    L4_2 = L4_2.waitReady
    L4_2 = L4_2()
    if L4_2 then
      L4_2 = ItemEscrow
      L4_2 = L4_2.unitFor
      L5_2 = "onion"
      L6_2 = A1_2.id
      L7_2 = A1_2.buyer
      L4_2 = L4_2(L5_2, L6_2, L7_2)
      if L4_2 then
        goto lbl_54
      end
    end
  end
  L4_2 = nil
  ::lbl_54::
  if L4_2 then
    L5_2 = A1_2.listing
    if L5_2 then
      L5_2 = MySQL
      L5_2 = L5_2.scalar
      L5_2 = L5_2.await
      L6_2 = "SELECT id FROM apex_phone_onion WHERE id = ?"
      L7_2 = {}
      L8_2 = A1_2.listing
      L7_2[1] = L8_2
      L5_2 = L5_2(L6_2, L7_2)
    end
    if L5_2 then
      L6_2 = ItemEscrow
      L6_2 = L6_2.restock
      L7_2 = L4_2.id
      L8_2 = A1_2.listing
      L9_2 = A1_2.buyer
      L6_2 = L6_2(L7_2, L8_2, L9_2)
      if L6_2 then
        L6_2 = MySQL
        L6_2 = L6_2.update
        L6_2 = L6_2.await
        L7_2 = "UPDATE apex_phone_onion SET stock = stock + 1 WHERE id = ?"
        L8_2 = {}
        L9_2 = A1_2.listing
        L8_2[1] = L9_2
        L6_2(L7_2, L8_2)
    end
    else
      L6_2 = ItemEscrow
      L6_2 = L6_2.returnToOwner
      L7_2 = L4_2.id
      L6_2(L7_2)
    end
  else
    L5_2 = A1_2.listing
    if L5_2 then
      L5_2 = MySQL
      L5_2 = L5_2.update
      L5_2 = L5_2.await
      L6_2 = "UPDATE apex_phone_onion SET stock = stock + 1 WHERE id = ?"
      L7_2 = {}
      L8_2 = A1_2.listing
      L7_2[1] = L8_2
      L5_2(L6_2, L7_2)
    end
  end
  L5_2 = {}
  L5_2.ok = true
  return L5_2
end
L42_1 = RPC
function L43_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2
  L2_2 = GetCid
  L3_2 = A0_2
  L2_2 = L2_2(L3_2)
  L3_2 = MySQL
  L3_2 = L3_2.single
  L3_2 = L3_2.await
  L4_2 = "SELECT * FROM apex_phone_onion_orders WHERE id = ? AND buyer = ?"
  L5_2 = {}
  L6_2 = tonumber
  L7_2 = A1_2.id
  L6_2 = L6_2(L7_2)
  L7_2 = L2_2
  L5_2[1] = L6_2
  L5_2[2] = L7_2
  L3_2 = L3_2(L4_2, L5_2)
  if L3_2 then
    L4_2 = L3_2.status
    if "pago" == L4_2 then
      goto lbl_25
    end
  end
  L4_2 = {}
  L4_2.error = "forbidden"
  do return L4_2 end
  ::lbl_25::
  L4_2 = L12_1
  L5_2 = L3_2.listing
  if L5_2 then
    L5_2 = L11_1
    L6_2 = L3_2.listing
    L5_2 = L5_2(L6_2)
    if L5_2 then
      goto lbl_39
    end
  end
  L5_2 = "onion:order:"
  L6_2 = tostring
  L7_2 = L3_2.id
  L6_2 = L6_2(L7_2)
  L5_2 = L5_2 .. L6_2
  ::lbl_39::
  L6_2 = L41_1
  L7_2 = L2_2
  L8_2 = L3_2
  return L4_2(L5_2, L6_2, L7_2, L8_2)
end
L42_1["onion.cancel"] = L43_1
L42_1 = RPC
function L43_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2
  L2_2 = GetCid
  L3_2 = A0_2
  L2_2 = L2_2(L3_2)
  L3_2 = MySQL
  L3_2 = L3_2.single
  L3_2 = L3_2.await
  L4_2 = "SELECT * FROM apex_phone_onion_orders WHERE id = ? AND buyer = ?"
  L5_2 = {}
  L6_2 = tonumber
  L7_2 = A1_2.id
  L6_2 = L6_2(L7_2)
  L7_2 = L2_2
  L5_2[1] = L6_2
  L5_2[2] = L7_2
  L3_2 = L3_2(L4_2, L5_2)
  if L3_2 then
    L4_2 = L3_2.rating
    if nil == L4_2 then
      L4_2 = L3_2.status
      if "concluido" == L4_2 then
        goto lbl_28
      end
    end
  end
  L4_2 = {}
  L4_2.error = "forbidden"
  do return L4_2 end
  ::lbl_28::
  L4_2 = math
  L4_2 = L4_2.max
  L5_2 = 1
  L6_2 = math
  L6_2 = L6_2.min
  L7_2 = 5
  L8_2 = math
  L8_2 = L8_2.floor
  L9_2 = tonumber
  L10_2 = A1_2.rating
  L9_2 = L9_2(L10_2)
  if not L9_2 then
    L9_2 = 0
  end
  L8_2 = L8_2(L9_2)
  L6_2 = L6_2(L7_2, L8_2)
  L4_2 = L4_2(L5_2, L6_2)
  L5_2 = MySQL
  L5_2 = L5_2.update
  L5_2 = L5_2.await
  L6_2 = "UPDATE apex_phone_onion_orders SET rating = ? WHERE id = ? AND buyer = ? AND status = ? AND rating IS NULL"
  L7_2 = {}
  L8_2 = L4_2
  L9_2 = L3_2.id
  L10_2 = L2_2
  L11_2 = "concluido"
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
    L6_2.error = "forbidden"
    return L6_2
  end
  L6_2 = MySQL
  L6_2 = L6_2.update
  L6_2 = L6_2.await
  L7_2 = "UPDATE apex_phone_onion_id SET rep = rep + ?, votes = votes + 1 WHERE citizenid = ?"
  L8_2 = {}
  L9_2 = L4_2
  L10_2 = L3_2.seller
  L8_2[1] = L9_2
  L8_2[2] = L10_2
  L6_2(L7_2, L8_2)
  L6_2 = {}
  L6_2.ok = true
  return L6_2
end
L42_1["onion.rate"] = L43_1
L42_1 = ItemEscrow
if L42_1 then
  L42_1 = ItemEscrow
  L42_1 = L42_1.onSweep
  if L42_1 then
    L42_1 = ItemEscrow
    L42_1 = L42_1.onSweep
    function L43_1(A0_2)
      local L1_2, L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2
      L1_2 = MySQL
      L1_2 = L1_2.query
      L1_2 = L1_2.await
      L2_2 = [[
SELECT e.id, e.ref_id FROM apex_phone_item_escrow e
            LEFT JOIN apex_phone_onion l ON l.id = e.ref_id
            WHERE e.`source` = 'onion' AND e.status = 'held' AND e.target IS NULL AND e.`count` > 0 AND e.updated < ? AND l.id IS NULL
            ORDER BY e.id LIMIT 200]]
      L3_2 = {}
      L4_2 = A0_2
      L3_2[1] = L4_2
      L1_2 = L1_2(L2_2, L3_2)
      if not L1_2 then
        L1_2 = {}
      end
      L2_2 = ipairs
      L3_2 = L1_2
      L2_2, L3_2, L4_2, L5_2 = L2_2(L3_2)
      for L6_2, L7_2 in L2_2, L3_2, L4_2, L5_2 do
        L8_2 = ItemEscrow
        L8_2 = L8_2.tryLock
        L9_2 = L11_1
        L10_2 = L7_2.ref_id
        L9_2 = L9_2(L10_2)
        function L10_2()
          local L0_3, L1_3, L2_3, L3_3
          L0_3 = MySQL
          L0_3 = L0_3.scalar
          L0_3 = L0_3.await
          L1_3 = "SELECT id FROM apex_phone_onion WHERE id = ?"
          L2_3 = {}
          L3_3 = L7_2.ref_id
          L2_3[1] = L3_3
          L0_3 = L0_3(L1_3, L2_3)
          if not L0_3 then
            L0_3 = ItemEscrow
            L0_3 = L0_3.returnToOwner
            L1_3 = L7_2.id
            L0_3(L1_3)
          end
        end
        L8_2(L9_2, L10_2)
      end
      L2_2 = MySQL
      L2_2 = L2_2.query
      L2_2 = L2_2.await
      L3_2 = [[
SELECT e.id, e.target, o.status AS ostatus, o.listing AS olisting FROM apex_phone_item_escrow e
            LEFT JOIN apex_phone_onion_orders o ON o.id = e.ref_id AND CONVERT(o.buyer USING utf8mb4) COLLATE utf8mb4_unicode_ci = e.target
            WHERE e.`source` = 'onion' AND e.status = 'held' AND e.target IS NOT NULL AND e.updated < ? AND (o.id IS NULL OR o.status <> 'pago')
            ORDER BY e.id LIMIT 200]]
      L4_2 = {}
      L5_2 = A0_2
      L4_2[1] = L5_2
      L2_2 = L2_2(L3_2, L4_2)
      if not L2_2 then
        L2_2 = {}
      end
      L3_2 = ipairs
      L4_2 = L2_2
      L3_2, L4_2, L5_2, L6_2 = L3_2(L4_2)
      for L7_2, L8_2 in L3_2, L4_2, L5_2, L6_2 do
        L9_2 = L8_2.ostatus
        if "enviado" ~= L9_2 then
          L9_2 = L8_2.ostatus
          if "concluido" ~= L9_2 then
            goto lbl_58
          end
        end
        L9_2 = ItemEscrow
        L9_2 = L9_2.giveTo
        L10_2 = L8_2.id
        L11_2 = L8_2.target
        L9_2(L10_2, L11_2)
        goto lbl_75
        ::lbl_58::
        L9_2 = ItemEscrow
        L9_2 = L9_2.tryLock
        L10_2 = L8_2.olisting
        if L10_2 then
          L10_2 = L11_1
          L11_2 = L8_2.olisting
          L10_2 = L10_2(L11_2)
          if L10_2 then
            goto lbl_73
          end
        end
        L10_2 = "onion:unit:"
        L11_2 = tostring
        L12_2 = L8_2.id
        L11_2 = L11_2(L12_2)
        L10_2 = L10_2 .. L11_2
        ::lbl_73::
        function L11_2()
          local L0_3, L1_3, L2_3, L3_3, L4_3, L5_3
          L0_3 = MySQL
          L0_3 = L0_3.scalar
          L0_3 = L0_3.await
          L1_3 = "SELECT id FROM apex_phone_item_escrow WHERE id = ? AND status = ? AND target = ?"
          L2_3 = {}
          L3_3 = L8_2.id
          L4_3 = "held"
          L5_3 = L8_2.target
          L2_3[1] = L3_3
          L2_3[2] = L4_3
          L2_3[3] = L5_3
          L0_3 = L0_3(L1_3, L2_3)
          if L0_3 then
            L0_3 = ItemEscrow
            L0_3 = L0_3.returnToOwner
            L1_3 = L8_2.id
            L0_3(L1_3)
          end
        end
        L9_2(L10_2, L11_2)
        ::lbl_75::
      end
    end
    L42_1(L43_1)
  end
end
