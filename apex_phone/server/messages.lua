local L0_1, L1_1, L2_1, L3_1, L4_1, L5_1, L6_1, L7_1, L8_1, L9_1, L10_1, L11_1, L12_1, L13_1, L14_1, L15_1, L16_1, L17_1, L18_1, L19_1, L20_1, L21_1, L22_1, L23_1, L24_1, L25_1, L26_1, L27_1, L28_1, L29_1, L30_1, L31_1, L32_1, L33_1, L34_1, L35_1, L36_1, L37_1, L38_1, L39_1, L40_1, L41_1, L42_1, L43_1, L44_1, L45_1, L46_1, L47_1, L48_1, L49_1, L50_1, L51_1, L52_1, L53_1, L54_1, L55_1, L56_1, L57_1, L58_1, L59_1, L60_1, L61_1, L62_1, L63_1, L64_1, L65_1, L66_1, L67_1, L68_1, L69_1, L70_1, L71_1, L72_1, L73_1, L74_1, L75_1, L76_1
L0_1 = {}
L0_1.sms = true
L0_1.match = true
L0_1.marketplace = true
L0_1.recado = true
function L1_1(A0_2)
  local L1_2, L2_2, L3_2
  L1_2 = math
  L1_2 = L1_2.tointeger
  L2_2 = tonumber
  L3_2 = A0_2
  L2_2, L3_2 = L2_2(L3_2)
  L1_2 = L1_2(L2_2, L3_2)
  if L1_2 and L1_2 > 0 then
    return L1_2
  end
  L2_2 = nil
  return L2_2
end
function L2_1(A0_2)
  local L1_2, L2_2, L3_2, L4_2
  L1_2 = string
  L1_2 = L1_2.rep
  L2_2 = "?"
  L3_2 = A0_2
  L4_2 = ", "
  return L1_2(L2_2, L3_2, L4_2)
end
function L3_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2
  L2_2 = tostring
  L3_2 = A0_2 or L3_2
  if not A0_2 then
    L3_2 = ""
  end
  L2_2 = L2_2(L3_2)
  L3_2 = L2_2
  L2_2 = L2_2.sub
  L4_2 = 1
  L5_2 = A1_2
  L2_2 = L2_2(L3_2, L4_2, L5_2)
  L3_2 = 1
  L4_2 = 3
  L5_2 = 1
  for L6_2 = L3_2, L4_2, L5_2 do
    L7_2 = utf8
    L7_2 = L7_2.len
    L8_2 = L2_2
    L7_2 = L7_2(L8_2)
    if L7_2 then
      break
    end
    L8_2 = L2_2
    L7_2 = L2_2.sub
    L9_2 = 1
    L10_2 = -2
    L7_2 = L7_2(L8_2, L9_2, L10_2)
    L2_2 = L7_2
  end
  return L2_2
end
function L4_1(A0_2)
  local L1_2, L2_2, L3_2, L4_2
  L1_2 = type
  L2_2 = A0_2
  L1_2 = L1_2(L2_2)
  if "string" ~= L1_2 then
    L1_2 = type
    L2_2 = A0_2
    L1_2 = L1_2(L2_2)
    if "number" ~= L1_2 then
      L1_2 = nil
      return L1_2
    end
  end
  L1_2 = tostring
  L2_2 = A0_2
  L1_2 = L1_2(L2_2)
  L2_2 = L1_2
  L1_2 = L1_2.sub
  L3_2 = 1
  L4_2 = 40
  L1_2 = L1_2(L2_2, L3_2, L4_2)
  if "" == L1_2 then
    L2_2 = nil
    return L2_2
  end
  return L1_2
end
function L5_1(A0_2, A1_2)
  local L2_2, L3_2
  if A1_2 then
    L2_2 = L0_1
    L2_2 = L2_2[A0_2]
    if L2_2 then
      L2_2 = CanonNumber
      if L2_2 then
        L2_2 = CanonNumber
        L3_2 = A1_2
        return L2_2(L3_2)
      end
    end
  end
  return A1_2
end
function L6_1(A0_2)
  local L1_2, L2_2, L3_2, L4_2
  L1_2 = A0_2.app
  if nil ~= L1_2 then
    L1_2 = tostring
    L2_2 = A0_2.app
    L1_2 = L1_2(L2_2)
    L2_2 = L1_2
    L1_2 = L1_2.sub
    L3_2 = 1
    L4_2 = 20
    L1_2 = L1_2(L2_2, L3_2, L4_2)
    if L1_2 then
      goto lbl_14
    end
  end
  L1_2 = "sms"
  ::lbl_14::
  return L1_2
end
L7_1 = MessagesRecadoKey
if not L7_1 then
  L7_1 = setmetatable
  L8_1 = {}
  L9_1 = {}
  L9_1.__metatable = false
  L7_1 = L7_1(L8_1, L9_1)
end
MessagesRecadoKey = L7_1
function L7_1(A0_2)
  local L1_2, L2_2, L3_2
  L1_2 = type
  L2_2 = A0_2
  L1_2 = L1_2(L2_2)
  L1_2 = rawequal
  L2_2 = A0_2._via
  L3_2 = MessagesRecadoKey
  L1_2 = "table" == L1_2 and L1_2
  return L1_2
end
function L8_1(A0_2)
  local L1_2, L2_2, L3_2, L4_2, L5_2, L6_2
  if "recado" == A0_2 then
    L1_2 = type
    L2_2 = Config
    L2_2 = L2_2.Recado
    L1_2 = L1_2(L2_2)
    if "table" == L1_2 then
      L1_2 = math
      L1_2 = L1_2.tointeger
      L2_2 = math
      L2_2 = L2_2.floor
      L3_2 = tonumber
      L4_2 = Config
      L4_2 = L4_2.Recado
      L4_2 = L4_2.textMax
      L3_2 = L3_2(L4_2)
      if not L3_2 then
        L3_2 = 4000
      end
      L2_2, L3_2, L4_2, L5_2, L6_2 = L2_2(L3_2)
      L1_2 = L1_2(L2_2, L3_2, L4_2, L5_2, L6_2)
      if not L1_2 then
        L1_2 = 4000
      end
      L2_2 = math
      L2_2 = L2_2.max
      L3_2 = 1000
      L4_2 = math
      L4_2 = L4_2.min
      L5_2 = L1_2
      L6_2 = 60000
      L4_2 = L4_2(L5_2, L6_2)
      return L2_2(L3_2, L4_2)
    end
  end
  L1_2 = 1000
  return L1_2
end
function L9_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2
  if "recado" == A0_2 and nil ~= A1_2 then
    L2_2 = type
    L3_2 = RecadoReadReceipts
    L2_2 = L2_2(L3_2)
    if "function" == L2_2 then
      goto lbl_12
    end
  end
  L2_2 = false
  do return L2_2 end
  ::lbl_12::
  L2_2 = pcall
  L3_2 = RecadoReadReceipts
  L4_2 = tostring
  L5_2 = A1_2
  L4_2, L5_2 = L4_2(L5_2)
  L2_2, L3_2 = L2_2(L3_2, L4_2, L5_2)
  L4_2 = L2_2 or L4_2
  L4_2 = L2_2 and false == L3_2
  return L4_2
end
function L10_1(A0_2)
  local L1_2, L2_2, L3_2
  L1_2 = type
  L2_2 = A0_2
  L1_2 = L1_2(L2_2)
  if "string" ~= L1_2 then
    L1_2 = nil
    return L1_2
  end
  L2_2 = A0_2
  L1_2 = A0_2.match
  L3_2 = "^g:(%d+)$"
  L1_2 = L1_2(L2_2, L3_2)
  if L1_2 then
    L2_2 = L1_1
    L3_2 = L1_2
    L2_2 = L2_2(L3_2)
    if L2_2 then
      goto lbl_19
    end
  end
  L2_2 = nil
  ::lbl_19::
  return L2_2
end
function L11_1(A0_2)
  local L1_2, L2_2
  L1_2 = A0_2.conversation
  if nil ~= L1_2 then
    L1_2 = L1_1
    L2_2 = A0_2.conversation
    L1_2 = L1_2(L2_2)
    if not L1_2 then
      L1_2 = false
    end
    return L1_2
  end
  L1_2 = L10_1
  L2_2 = A0_2.number
  return L1_2(L2_2)
end
function L12_1()
  local L0_2, L1_2, L2_2, L3_2, L4_2, L5_2, L6_2, L7_2
  L0_2 = type
  L1_2 = Config
  L1_2 = L1_2.Messages
  L0_2 = L0_2(L1_2)
  if "table" == L0_2 then
    L0_2 = Config
    L0_2 = L0_2.Messages
    if L0_2 then
      goto lbl_13
    end
  end
  L0_2 = {}
  ::lbl_13::
  L1_2 = math
  L1_2 = L1_2.tointeger
  L2_2 = math
  L2_2 = L2_2.floor
  L3_2 = tonumber
  L4_2 = L0_2.pageSize
  L3_2 = L3_2(L4_2)
  if not L3_2 then
    L3_2 = 30
  end
  L2_2, L3_2, L4_2, L5_2, L6_2, L7_2 = L2_2(L3_2)
  L1_2 = L1_2(L2_2, L3_2, L4_2, L5_2, L6_2, L7_2)
  if not L1_2 then
    L1_2 = 30
  end
  L2_2 = {}
  L3_2 = math
  L3_2 = L3_2.max
  L4_2 = 1
  L5_2 = math
  L5_2 = L5_2.min
  L6_2 = 50
  L7_2 = L1_2
  L5_2 = L5_2(L6_2, L7_2)
  L3_2 = L3_2(L4_2, L5_2)
  L2_2.pageSize = L3_2
  L3_2 = math
  L3_2 = L3_2.max
  L4_2 = 0
  L5_2 = tonumber
  L6_2 = L0_2.editWindowMin
  L5_2 = L5_2(L6_2)
  if not L5_2 then
    L5_2 = 15
  end
  L3_2 = L3_2(L4_2, L5_2)
  L3_2 = L3_2 * 60000
  L2_2.editMs = L3_2
  L3_2 = math
  L3_2 = L3_2.max
  L4_2 = 0
  L5_2 = tonumber
  L6_2 = L0_2.deleteForAllMin
  L5_2 = L5_2(L6_2)
  if not L5_2 then
    L5_2 = 60
  end
  L3_2 = L3_2(L4_2, L5_2)
  L3_2 = L3_2 * 60000
  L2_2.deleteMs = L3_2
  L3_2 = math
  L3_2 = L3_2.max
  L4_2 = 500
  L5_2 = tonumber
  L6_2 = L0_2.typingMs
  L5_2 = L5_2(L6_2)
  if not L5_2 then
    L5_2 = 3000
  end
  L3_2 = L3_2(L4_2, L5_2)
  L2_2.typingMs = L3_2
  return L2_2
end
L13_1 = 4102444800000
L14_1 = {}
L15_1 = {}
L16_1 = {}
L17_1 = {}
function L18_1(A0_2)
  local L1_2, L2_2, L3_2, L4_2, L5_2, L6_2
  L1_2 = tonumber
  L2_2 = A0_2
  L1_2 = L1_2(L2_2)
  A0_2 = L1_2
  if not A0_2 then
    L1_2 = nil
    return L1_2
  end
  L1_2 = GetCid
  L2_2 = A0_2
  L1_2 = L1_2(L2_2)
  L2_2 = GetPlayerNumber
  L3_2 = A0_2
  L2_2 = L2_2(L3_2)
  L3_2 = L14_1
  L3_2 = L3_2[A0_2]
  if L3_2 then
    L4_2 = L3_2.number
    if L4_2 then
      L5_2 = L3_2.number
      L4_2 = L15_1
      L4_2 = L4_2[L5_2]
      if L4_2 == A0_2 then
        L4_2 = L3_2.number
        if L4_2 ~= L2_2 then
          L5_2 = L3_2.number
          L4_2 = L15_1
          L4_2[L5_2] = nil
        end
      end
    end
    L4_2 = L3_2.cid
    if L4_2 then
      L5_2 = L3_2.cid
      L4_2 = L16_1
      L4_2 = L4_2[L5_2]
      if L4_2 == A0_2 then
        L4_2 = L3_2.cid
        if L4_2 ~= L1_2 then
          L5_2 = L3_2.cid
          L4_2 = L16_1
          L4_2[L5_2] = nil
        end
      end
    end
  end
  if not L1_2 then
    L4_2 = L14_1
    L4_2[A0_2] = nil
    L4_2 = nil
    return L4_2
  end
  L4_2 = {}
  L4_2.cid = L1_2
  L5_2 = L2_2 or L5_2
  if not L2_2 or "" == L2_2 or not L2_2 then
    L5_2 = nil
  end
  L4_2.number = L5_2
  L5_2 = L14_1
  L5_2[A0_2] = L4_2
  L5_2 = L16_1
  L5_2[L1_2] = A0_2
  L5_2 = L4_2.number
  if L5_2 then
    L6_2 = L4_2.number
    L5_2 = L15_1
    L5_2[L6_2] = A0_2
  end
  return L4_2
end
MessagesPresenceSet = L18_1
function L19_1(A0_2)
  local L1_2, L2_2, L3_2, L4_2, L5_2, L6_2, L7_2
  L1_2 = tonumber
  L2_2 = A0_2
  L1_2 = L1_2(L2_2)
  A0_2 = L1_2
  L1_2 = A0_2 or L1_2
  if A0_2 then
    L1_2 = L14_1
    L1_2 = L1_2[A0_2]
  end
  if not L1_2 then
    return
  end
  L2_2 = L14_1
  L2_2[A0_2] = nil
  L2_2 = L1_2.number
  if L2_2 then
    L3_2 = L1_2.number
    L2_2 = L15_1
    L2_2 = L2_2[L3_2]
    if L2_2 == A0_2 then
      L3_2 = L1_2.number
      L2_2 = L15_1
      L2_2[L3_2] = nil
    end
  end
  L3_2 = L1_2.cid
  L2_2 = L16_1
  L2_2 = L2_2[L3_2]
  if L2_2 == A0_2 then
    L3_2 = L1_2.cid
    L2_2 = L16_1
    L2_2[L3_2] = nil
  end
  L2_2 = Now
  L2_2 = L2_2()
  L4_2 = L1_2.cid
  L3_2 = L17_1
  L3_2[L4_2] = L2_2
  L3_2 = DBReady
  if L3_2 then
    L3_2 = MySQL
    L3_2 = L3_2.update
    L4_2 = "UPDATE apex_phone_accounts SET last_seen = ? WHERE citizenid = ?"
    L5_2 = {}
    L6_2 = L2_2
    L7_2 = L1_2.cid
    L5_2[1] = L6_2
    L5_2[2] = L7_2
    L3_2(L4_2, L5_2)
  end
end
function L20_1(A0_2)
  local L1_2, L2_2, L3_2, L4_2
  if not A0_2 then
    L1_2 = nil
    return L1_2
  end
  L1_2 = L15_1
  L1_2 = L1_2[A0_2]
  if L1_2 then
    L2_2 = GetPlayerNumber
    L3_2 = L1_2
    L2_2 = L2_2(L3_2)
    if L2_2 == A0_2 then
      L2_2 = SimDormant
      if L2_2 then
        L2_2 = SimDormant
        L3_2 = L1_2
        L4_2 = A0_2
        L2_2 = L2_2(L3_2, L4_2)
        if L2_2 then
          goto lbl_24
        end
      end
      return L1_2
    end
  end
  ::lbl_24::
  L2_2 = GetSrcByNumber
  L3_2 = A0_2
  L2_2 = L2_2(L3_2)
  L1_2 = L2_2
  if L1_2 then
    L2_2 = L18_1
    L3_2 = L1_2
    L2_2(L3_2)
  end
  return L1_2
end
function L21_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2, L6_2, L7_2
  if A1_2 then
    L2_2 = L0_1
    L2_2 = L2_2[A1_2]
    if not L2_2 then
      goto lbl_11
    end
  end
  L2_2 = GetPlayerNumber
  L3_2 = A0_2
  do return L2_2(L3_2) end
  ::lbl_11::
  L2_2 = GetCid
  L3_2 = A0_2
  L2_2 = L2_2(L3_2)
  if not L2_2 then
    L3_2 = nil
    return L3_2
  end
  L3_2 = MySQL
  L3_2 = L3_2.single
  L3_2 = L3_2.await
  L4_2 = "SELECT username FROM apex_phone_social_accounts WHERE app = ? AND owner = ?"
  L5_2 = {}
  L6_2 = A1_2
  L7_2 = L2_2
  L5_2[1] = L6_2
  L5_2[2] = L7_2
  L3_2 = L3_2(L4_2, L5_2)
  L4_2 = L3_2 or L4_2
  if L3_2 then
    L4_2 = L3_2.username
  end
  return L4_2
end
GetIdentity = L21_1
function L22_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2, L6_2
  if A0_2 then
    L2_2 = L0_1
    L2_2 = L2_2[A0_2]
    if not L2_2 then
      goto lbl_11
    end
  end
  L2_2 = L20_1
  L3_2 = A1_2
  do return L2_2(L3_2) end
  ::lbl_11::
  L2_2 = MySQL
  L2_2 = L2_2.single
  L2_2 = L2_2.await
  L3_2 = "SELECT owner FROM apex_phone_social_accounts WHERE app = ? AND username = ?"
  L4_2 = {}
  L5_2 = A0_2
  L6_2 = A1_2
  L4_2[1] = L5_2
  L4_2[2] = L6_2
  L2_2 = L2_2(L3_2, L4_2)
  if not L2_2 then
    L3_2 = nil
    return L3_2
  end
  L3_2 = FW
  L3_2 = L3_2.GetPlayerByCid
  L4_2 = L2_2.owner
  L3_2 = L3_2(L4_2)
  L4_2 = L3_2 or L4_2
  if L3_2 then
    L4_2 = L3_2.src
  end
  return L4_2
end
function L23_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2
  if not A1_2 then
    L2_2 = nil
    return L2_2
  end
  if A0_2 then
    L2_2 = L0_1
    L2_2 = L2_2[A0_2]
    if not L2_2 then
      goto lbl_32
    end
  end
  L2_2 = L15_1
  L2_2 = L2_2[A1_2]
  if L2_2 then
    L3_2 = GetPlayerNumber
    L4_2 = L2_2
    L3_2 = L3_2(L4_2)
    if L3_2 == A1_2 then
      L3_2 = SimDormant
      if L3_2 then
        L3_2 = SimDormant
        L4_2 = L2_2
        L5_2 = A1_2
        L3_2 = L3_2(L4_2, L5_2)
        if L3_2 then
          goto lbl_30
        end
      end
      return L2_2
    end
  end
  ::lbl_30::
  L3_2 = nil
  do return L3_2 end
  ::lbl_32::
  L2_2 = L22_1
  L3_2 = A0_2
  L4_2 = A1_2
  return L2_2(L3_2, L4_2)
end
function L24_1(A0_2)
  local L1_2, L2_2, L3_2
  L1_2 = A0_2.read
  L1_2 = 1 == L1_2
  A0_2.read = L1_2
  L1_2 = A0_2.payload
  if L1_2 then
    L1_2 = A0_2.payload
    if "" ~= L1_2 then
      L1_2 = pcall
      L2_2 = json
      L2_2 = L2_2.decode
      L3_2 = A0_2.payload
      L1_2, L2_2 = L1_2(L2_2, L3_2)
      L3_2 = L2_2 or L3_2
      if not L1_2 or not L2_2 then
        L3_2 = nil
      end
      A0_2.payload = L3_2
  end
  else
    A0_2.payload = nil
  end
  return A0_2
end
L25_1 = {}
function L26_1(A0_2)
  local L1_2, L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2
  L1_2 = L25_1
  L1_2 = L1_2[A0_2]
  if L1_2 then
    L2_2 = os
    L2_2 = L2_2.time
    L2_2 = L2_2()
    L3_2 = L1_2.t
    L2_2 = L2_2 - L3_2
    L3_2 = 300
    if L2_2 < L3_2 then
      L2_2 = L1_2.set
      return L2_2
    end
  end
  L2_2 = MySQL
  L2_2 = L2_2.query
  L2_2 = L2_2.await
  L3_2 = "SELECT number FROM apex_phone_blocks WHERE owner = ? LIMIT 1000"
  L4_2 = {}
  L5_2 = A0_2
  L4_2[1] = L5_2
  L2_2 = L2_2(L3_2, L4_2)
  if not L2_2 then
    L2_2 = {}
  end
  L3_2 = {}
  L4_2 = ipairs
  L5_2 = L2_2
  L4_2, L5_2, L6_2, L7_2 = L4_2(L5_2)
  for L8_2, L9_2 in L4_2, L5_2, L6_2, L7_2 do
    L10_2 = tostring
    L11_2 = L9_2.number
    L10_2 = L10_2(L11_2)
    L3_2[L10_2] = true
  end
  L4_2 = L25_1
  L5_2 = {}
  L5_2.set = L3_2
  L6_2 = os
  L6_2 = L6_2.time
  L6_2 = L6_2()
  L5_2.t = L6_2
  L4_2[A0_2] = L5_2
  return L3_2
end
function L27_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2
  if not A0_2 or "" == A0_2 or nil == A1_2 then
    L2_2 = false
    return L2_2
  end
  L2_2 = pcall
  L3_2 = L26_1
  L4_2 = tostring
  L5_2 = A0_2
  L4_2, L5_2 = L4_2(L5_2)
  L2_2, L3_2 = L2_2(L3_2, L4_2, L5_2)
  if L2_2 then
    L4_2 = type
    L5_2 = L3_2
    L4_2 = L4_2(L5_2)
    if "table" == L4_2 then
      L4_2 = tostring
      L5_2 = A1_2
      L4_2 = L4_2(L5_2)
      L4_2 = L3_2[L4_2]
    end
  end
  L4_2 = true == L4_2 or L4_2
  return L4_2
end
IsBlocked = L27_1
L27_1 = nil
function L28_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2
  if A0_2 then
    L2_2 = tostring
    L3_2 = A0_2
    L2_2 = L2_2(L3_2)
    L3_2 = L25_1
    L3_2[L2_2] = nil
  end
  L2_2 = L27_1
  if L2_2 then
    L2_2 = L27_1
    if A0_2 then
      L3_2 = tostring
      L4_2 = A0_2
      L3_2 = L3_2(L4_2)
      if L3_2 then
        goto lbl_20
      end
    end
    L3_2 = nil
    ::lbl_20::
    if A1_2 then
      L4_2 = tostring
      L5_2 = A1_2
      L4_2 = L4_2(L5_2)
      if L4_2 then
        goto lbl_28
      end
    end
    L4_2 = nil
    ::lbl_28::
    L2_2(L3_2, L4_2)
  end
end
MessagesForget = L28_1
function L28_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2
  L2_2 = {}
  if A0_2 then
    L3_2 = #A1_2
    if 0 ~= L3_2 then
      goto lbl_9
    end
  end
  do return L2_2 end
  ::lbl_9::
  L3_2 = {}
  L4_2 = A0_2
  L3_2[1] = L4_2
  L4_2 = ipairs
  L5_2 = A1_2
  L4_2, L5_2, L6_2, L7_2 = L4_2(L5_2)
  for L8_2, L9_2 in L4_2, L5_2, L6_2, L7_2 do
    L10_2 = #L3_2
    L10_2 = L10_2 + 1
    L3_2[L10_2] = L9_2
  end
  L4_2 = pcall
  L5_2 = MySQL
  L5_2 = L5_2.query
  L5_2 = L5_2.await
  L6_2 = "SELECT owner FROM apex_phone_blocks WHERE number = ? AND owner IN (%s)"
  L7_2 = L6_2
  L6_2 = L6_2.format
  L8_2 = L2_1
  L9_2 = #A1_2
  L8_2, L9_2, L10_2, L11_2, L12_2 = L8_2(L9_2)
  L6_2 = L6_2(L7_2, L8_2, L9_2, L10_2, L11_2, L12_2)
  L7_2 = L3_2
  L4_2, L5_2 = L4_2(L5_2, L6_2, L7_2)
  if L4_2 then
    L6_2 = type
    L7_2 = L5_2
    L6_2 = L6_2(L7_2)
    if "table" == L6_2 then
      L6_2 = ipairs
      L7_2 = L5_2
      L6_2, L7_2, L8_2, L9_2 = L6_2(L7_2)
      for L10_2, L11_2 in L6_2, L7_2, L8_2, L9_2 do
        L12_2 = L11_2.owner
        L2_2[L12_2] = true
      end
    end
  end
  return L2_2
end
L29_1 = {}
L30_1 = {}
function L31_1(A0_2)
  local L1_2, L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2, L19_2, L20_2
  L1_2 = {}
  L2_2 = {}
  L3_2 = os
  L3_2 = L3_2.time
  L3_2 = L3_2()
  L4_2 = pairs
  L5_2 = A0_2
  L4_2, L5_2, L6_2, L7_2 = L4_2(L5_2)
  for L8_2 in L4_2, L5_2, L6_2, L7_2 do
    L9_2 = Accounts
    L9_2 = L9_2[L8_2]
    if L9_2 then
      L10_2 = type
      L11_2 = L9_2.settings
      L10_2 = L10_2(L11_2)
      if "table" == L10_2 then
        L10_2 = L9_2.settings
        if L10_2 then
          goto lbl_26
        end
      end
      L10_2 = {}
      ::lbl_26::
      L11_2 = {}
      L12_2 = L10_2.lastSeen
      L12_2 = false == L12_2
      L11_2.hideSeen = L12_2
      L12_2 = L10_2.readReceipts
      L12_2 = false == L12_2
      L11_2.noReceipts = L12_2
      L12_2 = L17_1
      L12_2 = L12_2[L8_2]
      if not L12_2 then
        L12_2 = tonumber
        L13_2 = L9_2.last_seen
        L12_2 = L12_2(L13_2)
      end
      L11_2.lastSeen = L12_2
      L1_2[L8_2] = L11_2
    else
      L10_2 = L30_1
      L10_2 = L10_2[L8_2]
      if L10_2 then
        L11_2 = L10_2.t
        L11_2 = L3_2 - L11_2
        L12_2 = 600
        if L11_2 < L12_2 then
          L1_2[L8_2] = L10_2
      end
      else
        L11_2 = #L2_2
        L11_2 = L11_2 + 1
        L2_2[L11_2] = L8_2
      end
    end
  end
  L4_2 = 1
  L5_2 = #L2_2
  L6_2 = 100
  for L7_2 = L4_2, L5_2, L6_2 do
    L8_2 = {}
    L9_2 = table
    L9_2 = L9_2.unpack
    L10_2 = L2_2
    L11_2 = L7_2
    L12_2 = math
    L12_2 = L12_2.min
    L13_2 = #L2_2
    L14_2 = L7_2 + 99
    L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2, L19_2, L20_2 = L12_2(L13_2, L14_2)
    L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2, L19_2, L20_2 = L9_2(L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2, L19_2, L20_2)
    L8_2[1] = L9_2
    L8_2[2] = L10_2
    L8_2[3] = L11_2
    L8_2[4] = L12_2
    L8_2[5] = L13_2
    L8_2[6] = L14_2
    L8_2[7] = L15_2
    L8_2[8] = L16_2
    L8_2[9] = L17_2
    L8_2[10] = L18_2
    L8_2[11] = L19_2
    L8_2[12] = L20_2
    L9_2 = pcall
    L10_2 = MySQL
    L10_2 = L10_2.query
    L10_2 = L10_2.await
    L11_2 = [[
SELECT citizenid, last_seen, LOCATE('"lastSeen":false', settings) AS hs,
            LOCATE('"readReceipts":false', settings) AS nr FROM apex_phone_accounts WHERE citizenid IN (%s)]]
    L12_2 = L11_2
    L11_2 = L11_2.format
    L13_2 = L2_1
    L14_2 = #L8_2
    L13_2, L14_2, L15_2, L16_2, L17_2, L18_2, L19_2, L20_2 = L13_2(L14_2)
    L11_2 = L11_2(L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2, L19_2, L20_2)
    L12_2 = L8_2
    L9_2, L10_2 = L9_2(L10_2, L11_2, L12_2)
    L11_2 = {}
    if L9_2 then
      L12_2 = type
      L13_2 = L10_2
      L12_2 = L12_2(L13_2)
      if "table" == L12_2 then
        L12_2 = ipairs
        L13_2 = L10_2
        L12_2, L13_2, L14_2, L15_2 = L12_2(L13_2)
        for L16_2, L17_2 in L12_2, L13_2, L14_2, L15_2 do
          L18_2 = {}
          L19_2 = tonumber
          L20_2 = L17_2.hs
          L19_2 = L19_2(L20_2)
          if not L19_2 then
            L19_2 = 0
          end
          L19_2 = L19_2 > 0
          L18_2.hideSeen = L19_2
          L19_2 = tonumber
          L20_2 = L17_2.nr
          L19_2 = L19_2(L20_2)
          if not L19_2 then
            L19_2 = 0
          end
          L19_2 = L19_2 > 0
          L18_2.noReceipts = L19_2
          L20_2 = L17_2.citizenid
          L19_2 = L17_1
          L19_2 = L19_2[L20_2]
          if not L19_2 then
            L19_2 = tonumber
            L20_2 = L17_2.last_seen
            L19_2 = L19_2(L20_2)
          end
          L18_2.lastSeen = L19_2
          L18_2.t = L3_2
          L20_2 = L17_2.citizenid
          L19_2 = L30_1
          L19_2[L20_2] = L18_2
          L19_2 = L17_2.citizenid
          L1_2[L19_2] = L18_2
          L19_2 = L17_2.citizenid
          L11_2[L19_2] = true
        end
      end
    end
    L12_2 = ipairs
    L13_2 = L8_2
    L12_2, L13_2, L14_2, L15_2 = L12_2(L13_2)
    for L16_2, L17_2 in L12_2, L13_2, L14_2, L15_2 do
      L18_2 = L11_2[L17_2]
      if not L18_2 then
        L18_2 = {}
        L18_2.hideSeen = false
        L18_2.noReceipts = false
        L18_2.t = L3_2
        L1_2[L17_2] = L18_2
      end
    end
  end
  return L1_2
end
function L32_1(A0_2, A1_2)
  local L2_2, L3_2
  if A0_2 then
    L2_2 = L30_1
    L2_2[A0_2] = nil
  end
  if A1_2 then
    L2_2 = "phone|"
    L3_2 = A1_2
    L2_2 = L2_2 .. L3_2
    L3_2 = L29_1
    L3_2[L2_2] = nil
  end
end
L27_1 = L32_1
function L32_1(A0_2)
  local L1_2, L2_2
  if not A0_2 then
    L1_2 = {}
    L1_2.hideSeen = false
    L1_2.noReceipts = false
    return L1_2
  end
  L1_2 = L31_1
  L2_2 = {}
  L2_2[A0_2] = true
  L1_2 = L1_2(L2_2)
  L1_2 = L1_2[A0_2]
  if not L1_2 then
    L1_2 = {}
    L1_2.hideSeen = false
    L1_2.noReceipts = false
  end
  return L1_2
end
function L33_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2
  if not A1_2 then
    L2_2 = nil
    return L2_2
  end
  L2_2 = L0_1
  L2_2 = not A0_2 or L2_2
  if L2_2 then
    L3_2 = "phone"
    if L3_2 then
      goto lbl_18
    end
  end
  L3_2 = A0_2
  ::lbl_18::
  L4_2 = "|"
  L5_2 = A1_2
  L3_2 = L3_2 .. L4_2 .. L5_2
  L4_2 = L29_1
  L4_2 = L4_2[L3_2]
  if L4_2 then
    L5_2 = os
    L5_2 = L5_2.time
    L5_2 = L5_2()
    L6_2 = L4_2.t
    L5_2 = L5_2 - L6_2
    L6_2 = 300
    if L5_2 < L6_2 then
      L5_2 = L4_2.cid
      return L5_2
    end
  end
  L5_2 = nil
  if L2_2 then
    L6_2 = L15_1
    L6_2 = L6_2[A1_2]
    if L6_2 then
      L7_2 = L14_1
      L7_2 = L7_2[L6_2]
      if L7_2 then
        L7_2 = L14_1
        L7_2 = L7_2[L6_2]
        L7_2 = L7_2.number
        if L7_2 == A1_2 then
          L7_2 = L14_1
          L7_2 = L7_2[L6_2]
          L5_2 = L7_2.cid
      end
    end
    else
      L7_2 = GetCitizenIdByNumber
      L8_2 = A1_2
      L7_2 = L7_2(L8_2)
      L5_2 = L7_2
    end
  else
    L6_2 = MySQL
    L6_2 = L6_2.single
    L6_2 = L6_2.await
    L7_2 = "SELECT owner FROM apex_phone_social_accounts WHERE app = ? AND username = ?"
    L8_2 = {}
    L9_2 = A0_2
    L10_2 = A1_2
    L8_2[1] = L9_2
    L8_2[2] = L10_2
    L6_2 = L6_2(L7_2, L8_2)
    L5_2 = L6_2 or L5_2
    if L6_2 then
      L5_2 = L6_2.owner
    end
  end
  if L5_2 then
    L6_2 = L29_1
    L7_2 = {}
    L7_2.cid = L5_2
    L8_2 = os
    L8_2 = L8_2.time
    L8_2 = L8_2()
    L7_2.t = L8_2
    L6_2[L3_2] = L7_2
  end
  return L5_2
end
function L34_1(A0_2, A1_2, A2_2)
  local L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2, L19_2, L20_2, L21_2, L22_2, L23_2, L24_2, L25_2, L26_2
  L3_2 = {}
  L4_2 = {}
  L5_2 = L0_1
  L5_2 = not A0_2 or L5_2
  L6_2 = os
  L6_2 = L6_2.time
  L6_2 = L6_2()
  L7_2 = ipairs
  L8_2 = A1_2
  L7_2, L8_2, L9_2, L10_2 = L7_2(L8_2)
  for L11_2, L12_2 in L7_2, L8_2, L9_2, L10_2 do
    L13_2 = L3_2[L12_2]
    if not L13_2 then
      L13_2 = {}
      L3_2[L12_2] = L13_2
      if L5_2 then
        L14_2 = L15_1
        L14_2 = L14_2[L12_2]
        if L14_2 then
          L15_2 = L14_1
          L15_2 = L15_2[L14_2]
          if L15_2 then
            L15_2 = L14_1
            L15_2 = L15_2[L14_2]
            L15_2 = L15_2.number
            if L15_2 == L12_2 then
              L15_2 = L14_2
              L16_2 = L14_1
              L16_2 = L16_2[L14_2]
              L16_2 = L16_2.cid
              L13_2.cid = L16_2
              L13_2.src = L15_2
            end
          end
        end
      end
      L14_2 = L13_2.cid
      if not L14_2 then
        if L5_2 then
          L14_2 = "phone"
          if L14_2 then
            goto lbl_55
          end
        end
        L14_2 = A0_2
        ::lbl_55::
        L15_2 = "|"
        L16_2 = L12_2
        L14_2 = L14_2 .. L15_2 .. L16_2
        L15_2 = L29_1
        L14_2 = L15_2[L14_2]
        if L14_2 then
          L15_2 = L14_2.t
          L15_2 = L6_2 - L15_2
          L16_2 = 300
          if L15_2 < L16_2 then
            L15_2 = L14_2.cid
            L13_2.cid = L15_2
        end
        else
          L15_2 = #L4_2
          L15_2 = L15_2 + 1
          L4_2[L15_2] = L12_2
        end
      end
    end
  end
  L7_2 = 1
  L8_2 = #L4_2
  L9_2 = 100
  for L10_2 = L7_2, L8_2, L9_2 do
    L11_2 = {}
    L12_2 = table
    L12_2 = L12_2.unpack
    L13_2 = L4_2
    L14_2 = L10_2
    L15_2 = math
    L15_2 = L15_2.min
    L16_2 = #L4_2
    L17_2 = L10_2 + 99
    L15_2, L16_2, L17_2, L18_2, L19_2, L20_2, L21_2, L22_2, L23_2, L24_2, L25_2, L26_2 = L15_2(L16_2, L17_2)
    L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2, L19_2, L20_2, L21_2, L22_2, L23_2, L24_2, L25_2, L26_2 = L12_2(L13_2, L14_2, L15_2, L16_2, L17_2, L18_2, L19_2, L20_2, L21_2, L22_2, L23_2, L24_2, L25_2, L26_2)
    L11_2[1] = L12_2
    L11_2[2] = L13_2
    L11_2[3] = L14_2
    L11_2[4] = L15_2
    L11_2[5] = L16_2
    L11_2[6] = L17_2
    L11_2[7] = L18_2
    L11_2[8] = L19_2
    L11_2[9] = L20_2
    L11_2[10] = L21_2
    L11_2[11] = L22_2
    L11_2[12] = L23_2
    L11_2[13] = L24_2
    L11_2[14] = L25_2
    L11_2[15] = L26_2
    L12_2 = nil
    L13_2 = nil
    if L5_2 then
      L14_2 = "SELECT citizenid AS cid, phone AS ident FROM apex_phone_accounts WHERE phone IN (%s)"
      L15_2 = L14_2
      L14_2 = L14_2.format
      L16_2 = L2_1
      L17_2 = #L11_2
      L16_2, L17_2, L18_2, L19_2, L20_2, L21_2, L22_2, L23_2, L24_2, L25_2, L26_2 = L16_2(L17_2)
      L14_2 = L14_2(L15_2, L16_2, L17_2, L18_2, L19_2, L20_2, L21_2, L22_2, L23_2, L24_2, L25_2, L26_2)
      L13_2 = L11_2
      L12_2 = L14_2
    else
      L14_2 = {}
      L15_2 = A0_2
      L14_2[1] = L15_2
      L13_2 = L14_2
      L14_2 = ipairs
      L15_2 = L11_2
      L14_2, L15_2, L16_2, L17_2 = L14_2(L15_2)
      for L18_2, L19_2 in L14_2, L15_2, L16_2, L17_2 do
        L20_2 = #L13_2
        L20_2 = L20_2 + 1
        L13_2[L20_2] = L19_2
      end
      L14_2 = "SELECT owner AS cid, username AS ident FROM apex_phone_social_accounts WHERE app = ? AND username IN (%s)"
      L15_2 = L14_2
      L14_2 = L14_2.format
      L16_2 = L2_1
      L17_2 = #L11_2
      L16_2, L17_2, L18_2, L19_2, L20_2, L21_2, L22_2, L23_2, L24_2, L25_2, L26_2 = L16_2(L17_2)
      L14_2 = L14_2(L15_2, L16_2, L17_2, L18_2, L19_2, L20_2, L21_2, L22_2, L23_2, L24_2, L25_2, L26_2)
      L12_2 = L14_2
    end
    L14_2 = pcall
    L15_2 = MySQL
    L15_2 = L15_2.query
    L15_2 = L15_2.await
    L16_2 = L12_2
    L17_2 = L13_2
    L14_2, L15_2 = L14_2(L15_2, L16_2, L17_2)
    if L14_2 then
      L16_2 = type
      L17_2 = L15_2
      L16_2 = L16_2(L17_2)
      if "table" == L16_2 then
        L16_2 = ipairs
        L17_2 = L15_2
        L16_2, L17_2, L18_2, L19_2 = L16_2(L17_2)
        for L20_2, L21_2 in L16_2, L17_2, L18_2, L19_2 do
          L22_2 = L21_2.ident
          L22_2 = L3_2[L22_2]
          if L22_2 then
            L23_2 = L22_2.cid
            if not L23_2 then
              L23_2 = L21_2.cid
              L22_2.cid = L23_2
              if L5_2 then
                L23_2 = "phone"
                if L23_2 then
                  goto lbl_164
                end
              end
              L23_2 = A0_2
              ::lbl_164::
              L24_2 = "|"
              L25_2 = L21_2.ident
              L23_2 = L23_2 .. L24_2 .. L25_2
              L24_2 = L29_1
              L25_2 = {}
              L26_2 = L21_2.cid
              L25_2.cid = L26_2
              L25_2.t = L6_2
              L24_2[L23_2] = L25_2
            end
          end
        end
      end
    end
  end
  L7_2 = {}
  L8_2 = {}
  L9_2 = pairs
  L10_2 = L3_2
  L9_2, L10_2, L11_2, L12_2 = L9_2(L10_2)
  for L13_2, L14_2 in L9_2, L10_2, L11_2, L12_2 do
    L15_2 = L14_2.cid
    if L15_2 then
      L15_2 = L14_2.cid
      L15_2 = L7_2[L15_2]
      if not L15_2 then
        L15_2 = L14_2.cid
        L7_2[L15_2] = true
        L15_2 = #L8_2
        L15_2 = L15_2 + 1
        L16_2 = L14_2.cid
        L8_2[L15_2] = L16_2
      end
    end
  end
  L9_2 = L31_1
  L10_2 = L7_2
  L9_2 = L9_2(L10_2)
  L10_2 = L28_1
  L11_2 = A2_2
  L12_2 = L8_2
  L10_2 = L10_2(L11_2, L12_2)
  L11_2 = pairs
  L12_2 = L3_2
  L11_2, L12_2, L13_2, L14_2 = L11_2(L12_2)
  for L15_2, L16_2 in L11_2, L12_2, L13_2, L14_2 do
    L17_2 = L16_2.cid
    if L17_2 then
      L17_2 = L16_2.src
      if not L17_2 then
        L18_2 = L16_2.cid
        L17_2 = L16_1
        L17_2 = L17_2[L18_2]
        if L17_2 then
          L18_2 = L14_1
          L18_2 = L18_2[L17_2]
          if L18_2 then
            L18_2 = L14_1
            L18_2 = L18_2[L17_2]
            L18_2 = L18_2.cid
            L19_2 = L16_2.cid
            if L18_2 == L19_2 then
              L16_2.src = L17_2
            end
          end
        end
      end
    end
    L17_2 = L16_2.cid
    if L17_2 then
      L17_2 = L16_2.cid
      L17_2 = L9_2[L17_2]
      if L17_2 then
        goto lbl_244
      end
    end
    L17_2 = nil
    ::lbl_244::
    if L17_2 then
      L18_2 = L17_2.noReceipts
      if L18_2 then
        goto lbl_250
      end
    end
    L18_2 = false
    ::lbl_250::
    L16_2.noReceipts = L18_2
    L18_2 = L16_2.noReceipts
    if not L18_2 and "recado" == A0_2 then
      L18_2 = L9_1
      L19_2 = A0_2
      L20_2 = L15_2
      L18_2 = L18_2(L19_2, L20_2)
      L16_2.noReceipts = L18_2
    end
    L18_2 = false
    if L17_2 then
      L18_2 = L17_2.hideSeen
    end
    if not L18_2 then
      L18_2 = L16_2.cid
      if L18_2 then
        L18_2 = L16_2.cid
        L18_2 = L10_2[L18_2]
      end
    end
    if L18_2 then
      L18_2 = false
      L16_2.lastSeen = nil
      L16_2.online = L18_2
    else
      L18_2 = L16_2.src
      L18_2 = nil ~= L18_2
      L16_2.online = L18_2
      L18_2 = L16_2.online
      if not L18_2 and L17_2 then
        L18_2 = L17_2.lastSeen
        if L18_2 then
          goto lbl_292
        end
      end
      L18_2 = nil
      ::lbl_292::
      L16_2.lastSeen = L18_2
    end
  end
  return L3_2
end
L35_1 = {}
function L36_1(A0_2)
  local L1_2, L2_2, L3_2, L4_2, L5_2
  L1_2 = L35_1
  L1_2 = L1_2[A0_2]
  if L1_2 then
    L1_2 = L35_1
    L1_2 = L1_2[A0_2]
    return L1_2
  end
  L1_2 = pcall
  L2_2 = MySQL
  L2_2 = L2_2.single
  L2_2 = L2_2.await
  L3_2 = "SELECT app FROM apex_phone_conversations WHERE id = ?"
  L4_2 = {}
  L5_2 = A0_2
  L4_2[1] = L5_2
  L1_2, L2_2 = L1_2(L2_2, L3_2, L4_2)
  if not L1_2 or not L2_2 then
    L3_2 = nil
    return L3_2
  end
  L3_2 = L35_1
  L4_2 = L2_2.app
  if not L4_2 then
    L4_2 = "sms"
  end
  L3_2[A0_2] = L4_2
  L3_2 = L35_1
  L3_2 = L3_2[A0_2]
  return L3_2
end
function L37_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2, L6_2, L7_2
  if not A0_2 or not A1_2 then
    L2_2 = false
    return L2_2
  end
  L2_2 = type
  L3_2 = IsGroupMember
  L2_2 = L2_2(L3_2)
  if "function" == L2_2 then
    L2_2 = pcall
    L3_2 = IsGroupMember
    L4_2 = A0_2
    L5_2 = A1_2
    L2_2, L3_2 = L2_2(L3_2, L4_2, L5_2)
    if L2_2 then
      if L3_2 then
        L4_2 = true
        if L4_2 then
          goto lbl_25
        end
      end
      L4_2 = false
      ::lbl_25::
      return L4_2
    end
  end
  L2_2 = pcall
  L3_2 = MySQL
  L3_2 = L3_2.scalar
  L3_2 = L3_2.await
  L4_2 = "SELECT 1 FROM apex_phone_conversation_members WHERE conversation_id = ? AND member = ? AND left_at IS NULL"
  L5_2 = {}
  L6_2 = A0_2
  L7_2 = A1_2
  L5_2[1] = L6_2
  L5_2[2] = L7_2
  L2_2, L3_2 = L2_2(L3_2, L4_2, L5_2)
  L4_2 = L2_2 or L4_2
  L4_2 = L2_2 and nil ~= L3_2
  return L4_2
end
function L38_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2, L6_2, L7_2
  if not A0_2 or not A1_2 then
    L2_2 = nil
    return L2_2
  end
  L2_2 = pcall
  L3_2 = MySQL
  L3_2 = L3_2.scalar
  L3_2 = L3_2.await
  L4_2 = "SELECT joined FROM apex_phone_conversation_members WHERE conversation_id = ? AND member = ? AND left_at IS NULL"
  L5_2 = {}
  L6_2 = A0_2
  L7_2 = A1_2
  L5_2[1] = L6_2
  L5_2[2] = L7_2
  L2_2, L3_2 = L2_2(L3_2, L4_2, L5_2)
  if L2_2 then
    L4_2 = tonumber
    L5_2 = L3_2
    L4_2 = L4_2(L5_2)
    if L4_2 then
      goto lbl_26
    end
  end
  L4_2 = nil
  ::lbl_26::
  return L4_2
end
function L39_1(A0_2)
  local L1_2, L2_2, L3_2, L4_2, L5_2
  L1_2 = pcall
  L2_2 = MySQL
  L2_2 = L2_2.query
  L2_2 = L2_2.await
  L3_2 = "SELECT member, role, last_read_id FROM apex_phone_conversation_members WHERE conversation_id = ? AND left_at IS NULL LIMIT 512"
  L4_2 = {}
  L5_2 = A0_2
  L4_2[1] = L5_2
  L1_2, L2_2 = L1_2(L2_2, L3_2, L4_2)
  if L1_2 then
    L3_2 = type
    L4_2 = L2_2
    L3_2 = L3_2(L4_2)
    if "table" == L3_2 and L2_2 then
      goto lbl_22
      L3_2 = L2_2 or L3_2
    end
  end
  L3_2 = {}
  ::lbl_22::
  return L3_2
end
function L40_1(A0_2, A1_2, A2_2, A3_2, A4_2, A5_2)
  local L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2
  L6_2 = type
  L7_2 = GroupBroadcast
  L6_2 = L6_2(L7_2)
  if "function" == L6_2 then
    L6_2 = pcall
    L7_2 = GroupBroadcast
    L8_2 = A0_2
    L9_2 = A2_2
    L10_2 = A3_2
    L11_2 = A4_2
    L6_2, L7_2 = L6_2(L7_2, L8_2, L9_2, L10_2, L11_2)
    if L6_2 then
      L8_2 = tonumber
      L9_2 = L7_2
      L8_2 = L8_2(L9_2)
      if not L8_2 then
        L8_2 = 0
      end
      return L8_2
    end
  end
  L6_2 = 0
  L7_2 = ipairs
  L8_2 = L39_1
  L9_2 = A0_2
  L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2 = L8_2(L9_2)
  L7_2, L8_2, L9_2, L10_2 = L7_2(L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2)
  for L11_2, L12_2 in L7_2, L8_2, L9_2, L10_2 do
    L13_2 = L12_2.member
    if L13_2 ~= A4_2 then
      L13_2 = L22_1
      L14_2 = A1_2
      L15_2 = L12_2.member
      L13_2 = L13_2(L14_2, L15_2)
      if L13_2 and L13_2 ~= A5_2 then
        L14_2 = HasPhoneItem
        if L14_2 then
          L14_2 = HasPhoneItem
          L15_2 = L13_2
          L14_2 = L14_2(L15_2)
          if not L14_2 then
            goto lbl_55
          end
        end
        L14_2 = Push
        L15_2 = L13_2
        L16_2 = A2_2
        L17_2 = A3_2
        L14_2(L15_2, L16_2, L17_2)
        L6_2 = L6_2 + 1
      end
    end
    ::lbl_55::
  end
  return L6_2
end
function L41_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2
  L2_2 = L11_1
  L3_2 = A1_2
  L2_2 = L2_2(L3_2)
  if nil ~= L2_2 then
    if not L2_2 then
      L3_2 = nil
      L4_2 = "notfound"
      return L3_2, L4_2
    end
    L3_2 = L36_1
    L4_2 = L2_2
    L3_2 = L3_2(L4_2)
    if not L3_2 then
      L4_2 = nil
      L5_2 = "notfound"
      return L4_2, L5_2
    end
    L4_2 = L21_1
    L5_2 = A0_2
    L6_2 = L3_2
    L4_2 = L4_2(L5_2, L6_2)
    if L4_2 then
      L5_2 = L37_1
      L6_2 = L2_2
      L7_2 = L4_2
      L5_2 = L5_2(L6_2, L7_2)
      if L5_2 then
        goto lbl_34
      end
    end
    L5_2 = nil
    L6_2 = "notmember"
    do return L5_2, L6_2 end
    ::lbl_34::
    L5_2 = {}
    L5_2.me = L4_2
    L5_2.app = L3_2
    L6_2 = "g:"
    L7_2 = L2_2
    L6_2 = L6_2 .. L7_2
    L5_2.other = L6_2
    L5_2.conv = L2_2
    return L5_2
  end
  L3_2 = L6_1
  L4_2 = A1_2
  L3_2 = L3_2(L4_2)
  L4_2 = L21_1
  L5_2 = A0_2
  L6_2 = L3_2
  L4_2 = L4_2(L5_2, L6_2)
  if not L4_2 then
    L5_2 = nil
    L6_2 = "noidentity"
    return L5_2, L6_2
  end
  L5_2 = L5_1
  L6_2 = L3_2
  L7_2 = L4_1
  L8_2 = A1_2.number
  L7_2, L8_2 = L7_2(L8_2)
  L5_2 = L5_2(L6_2, L7_2, L8_2)
  if not L5_2 then
    L6_2 = nil
    L7_2 = "target"
    return L6_2, L7_2
  end
  L6_2 = {}
  L6_2.me = L4_2
  L6_2.app = L3_2
  L6_2.other = L5_2
  return L6_2
end
function L42_1(A0_2, A1_2, A2_2)
  local L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2
  L3_2 = pcall
  L4_2 = MySQL
  L4_2 = L4_2.single
  L4_2 = L4_2.await
  L5_2 = "SELECT pinned, muted_until, pinned_msg, cleared_before FROM apex_phone_thread_meta WHERE owner = ? AND app = ? AND other = ?"
  L6_2 = {}
  L7_2 = A0_2
  L8_2 = A1_2
  L9_2 = A2_2
  L6_2[1] = L7_2
  L6_2[2] = L8_2
  L6_2[3] = L9_2
  L3_2, L4_2 = L3_2(L4_2, L5_2, L6_2)
  L5_2 = L4_2 or L5_2
  if not L3_2 or not L4_2 then
    L5_2 = nil
  end
  return L5_2
end
L43_1 = {}
L43_1.image = "\240\159\147\183 Foto"
L43_1.audio = "\240\159\142\164 Mensagem de voz"
L43_1.location = "\240\159\147\141 Localiza\195\167\195\163o"
function L44_1(A0_2)
  local L1_2, L2_2
  L1_2 = A0_2.read_at
  if nil ~= L1_2 then
    L1_2 = "read"
    return L1_2
  end
  L1_2 = A0_2.delivered_at
  if nil ~= L1_2 then
    L1_2 = "delivered"
    return L1_2
  end
  L1_2 = A0_2.read
  if 1 ~= L1_2 then
    L1_2 = A0_2.read
    if true ~= L1_2 then
      goto lbl_24
    end
  end
  L1_2 = tonumber
  L2_2 = A0_2.deleted_receiver
  L1_2 = L1_2(L2_2)
  if 1 ~= L1_2 then
    L1_2 = "read"
    return L1_2
  end
  ::lbl_24::
  L1_2 = "sent"
  return L1_2
end
function L45_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2
  L2_2 = L44_1
  L3_2 = A0_2
  L2_2 = L2_2(L3_2)
  L3_2 = tonumber
  L4_2 = A0_2.read_at
  L3_2 = L3_2(L4_2)
  if A1_2 and "read" == L2_2 then
    L4_2 = "delivered"
    L5_2 = nil
    A0_2.read = 0
    L3_2 = L5_2
    L2_2 = L4_2
  end
  L4_2 = L24_1
  L5_2 = A0_2
  L4_2(L5_2)
  A0_2.status = L2_2
  L4_2 = tonumber
  L5_2 = A0_2.delivered_at
  L4_2 = L4_2(L5_2)
  A0_2.deliveredAt = L4_2
  A0_2.readAt = L3_2
  L4_2 = tonumber
  L5_2 = A0_2.edited_at
  L4_2 = L4_2(L5_2)
  A0_2.editedAt = L4_2
  L4_2 = A0_2.deleted_all
  if nil ~= L4_2 then
    A0_2.deleted = true
    L4_2 = tonumber
    L5_2 = A0_2.deleted_all
    L4_2 = L4_2(L5_2)
    A0_2.deletedAt = L4_2
    L4_2 = ""
    A0_2.payload = nil
    A0_2.content = L4_2
  end
  L4_2 = L1_1
  L5_2 = A0_2.conversation_id
  L4_2 = L4_2(L5_2)
  A0_2.conversation = L4_2
  L4_2 = L1_1
  L5_2 = A0_2.reply_to
  L4_2 = L4_2(L5_2)
  L5_2 = nil
  L6_2 = nil
  L7_2 = nil
  L8_2 = nil
  L9_2 = nil
  L10_2 = nil
  L11_2 = nil
  A0_2.reply_to = nil
  A0_2.conversation_id = L11_2
  A0_2.deleted_receiver = L10_2
  A0_2.deleted_sender = L9_2
  A0_2.deleted_all = L8_2
  A0_2.edited_at = L7_2
  A0_2.read_at = L6_2
  A0_2.delivered_at = L5_2
  L5_2 = A0_2
  L6_2 = L4_2
  return L5_2, L6_2
end
function L46_1(A0_2)
  local L1_2, L2_2, L3_2, L4_2, L5_2
  if not A0_2 then
    L1_2 = nil
    return L1_2
  end
  L1_2 = {}
  L2_2 = L1_1
  L3_2 = A0_2.id
  L2_2 = L2_2(L3_2)
  L1_2.id = L2_2
  L2_2 = A0_2.sender
  L1_2.sender = L2_2
  L2_2 = A0_2.deleted_all
  if nil ~= L2_2 then
    L2_2 = ""
    L1_2.deleted = true
    L1_2.preview = L2_2
  else
    L2_2 = A0_2.type
    if "contact" == L2_2 then
      L2_2 = "\240\159\145\164 "
      L3_2 = L3_1
      L4_2 = A0_2.content
      L5_2 = 60
      L3_2 = L3_2(L4_2, L5_2)
      L2_2 = L2_2 .. L3_2
      L1_2.preview = L2_2
    else
      L3_2 = A0_2.type
      L2_2 = L43_1
      L2_2 = L2_2[L3_2]
      if not L2_2 then
        L2_2 = L3_1
        L3_2 = A0_2.content
        L4_2 = 80
        L2_2 = L2_2(L3_2, L4_2)
      end
      L1_2.preview = L2_2
    end
  end
  return L1_2
end
function L47_1(A0_2)
  local L1_2, L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2
  L1_2 = {}
  L2_2 = #A0_2
  if 0 == L2_2 then
    return L1_2
  end
  L2_2 = pcall
  L3_2 = MySQL
  L3_2 = L3_2.query
  L3_2 = L3_2.await
  L4_2 = "SELECT message_id, who, emoji FROM apex_phone_message_reactions WHERE message_id IN (%s) ORDER BY created ASC LIMIT 4000"
  L5_2 = L4_2
  L4_2 = L4_2.format
  L6_2 = L2_1
  L7_2 = #A0_2
  L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2 = L6_2(L7_2)
  L4_2 = L4_2(L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2)
  L5_2 = A0_2
  L2_2, L3_2 = L2_2(L3_2, L4_2, L5_2)
  if L2_2 then
    L4_2 = type
    L5_2 = L3_2
    L4_2 = L4_2(L5_2)
    if "table" == L4_2 then
      L4_2 = ipairs
      L5_2 = L3_2
      L4_2, L5_2, L6_2, L7_2 = L4_2(L5_2)
      for L8_2, L9_2 in L4_2, L5_2, L6_2, L7_2 do
        L10_2 = L1_1
        L11_2 = L9_2.message_id
        L10_2 = L10_2(L11_2)
        if L10_2 then
          L11_2 = L1_2[L10_2]
          if not L11_2 then
            L11_2 = {}
          end
          L1_2[L10_2] = L11_2
          L11_2 = L1_2[L10_2]
          L12_2 = L1_2[L10_2]
          L12_2 = #L12_2
          L12_2 = L12_2 + 1
          L13_2 = {}
          L14_2 = L9_2.emoji
          L13_2.emoji = L14_2
          L14_2 = L9_2.who
          L13_2.who = L14_2
          L11_2[L12_2] = L13_2
        end
      end
    end
  end
  return L1_2
end
function L48_1(A0_2, A1_2, A2_2, A3_2)
  local L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2, L19_2, L20_2, L21_2, L22_2, L23_2
  L4_2 = {}
  L5_2 = {}
  L6_2 = {}
  L7_2 = {}
  L8_2 = ipairs
  L9_2 = A0_2
  L8_2, L9_2, L10_2, L11_2 = L8_2(L9_2)
  for L12_2, L13_2 in L8_2, L9_2, L10_2, L11_2 do
    L14_2 = L13_2.sender
    L14_2 = L14_2 == A1_2
    L15_2 = L45_1
    L16_2 = L13_2
    L17_2 = A2_2 or L17_2
    if A2_2 then
      L17_2 = L14_2
    end
    L15_2, L16_2 = L15_2(L16_2, L17_2)
    if A3_2 and L14_2 then
      L17_2 = L13_2.id
      if L17_2 then
        L17_2 = L13_2.id
        if A3_2 >= L17_2 then
          L17_2 = L13_2.deleted
          if not L17_2 then
            L13_2.status = "read"
          end
        end
      end
    end
    L17_2 = #L4_2
    L17_2 = L17_2 + 1
    L18_2 = L13_2.id
    L4_2[L17_2] = L18_2
    if L16_2 then
      L7_2[L13_2] = L16_2
      L17_2 = L6_2[L16_2]
      if not L17_2 then
        L6_2[L16_2] = true
        L17_2 = #L5_2
        L17_2 = L17_2 + 1
        L5_2[L17_2] = L16_2
      end
    end
  end
  L8_2 = L47_1
  L9_2 = L4_2
  L8_2 = L8_2(L9_2)
  L9_2 = {}
  L10_2 = #L5_2
  if L10_2 > 0 then
    L10_2 = pcall
    L11_2 = MySQL
    L11_2 = L11_2.query
    L11_2 = L11_2.await
    L12_2 = "SELECT id, sender, type, content, deleted_all FROM apex_phone_messages WHERE id IN (%s)"
    L13_2 = L12_2
    L12_2 = L12_2.format
    L14_2 = L2_1
    L15_2 = #L5_2
    L14_2, L15_2, L16_2, L17_2, L18_2, L19_2, L20_2, L21_2, L22_2, L23_2 = L14_2(L15_2)
    L12_2 = L12_2(L13_2, L14_2, L15_2, L16_2, L17_2, L18_2, L19_2, L20_2, L21_2, L22_2, L23_2)
    L13_2 = L5_2
    L10_2, L11_2 = L10_2(L11_2, L12_2, L13_2)
    if L10_2 then
      L12_2 = type
      L13_2 = L11_2
      L12_2 = L12_2(L13_2)
      if "table" == L12_2 then
        L12_2 = ipairs
        L13_2 = L11_2
        L12_2, L13_2, L14_2, L15_2 = L12_2(L13_2)
        for L16_2, L17_2 in L12_2, L13_2, L14_2, L15_2 do
          L18_2 = L1_1
          L19_2 = L17_2.id
          L18_2 = L18_2(L19_2)
          L19_2 = L46_1
          L20_2 = L17_2
          L19_2 = L19_2(L20_2)
          L9_2[L18_2] = L19_2
        end
      end
    end
  end
  L10_2 = ipairs
  L11_2 = A0_2
  L10_2, L11_2, L12_2, L13_2 = L10_2(L11_2)
  for L14_2, L15_2 in L10_2, L11_2, L12_2, L13_2 do
    L16_2 = L15_2.id
    L16_2 = L8_2[L16_2]
    if L16_2 then
      L17_2 = ipairs
      L18_2 = L16_2
      L17_2, L18_2, L19_2, L20_2 = L17_2(L18_2)
      for L21_2, L22_2 in L17_2, L18_2, L19_2, L20_2 do
        L23_2 = L22_2.who
        L23_2 = L23_2 == A1_2
        L22_2.mine = L23_2
      end
      L15_2.reactions = L16_2
    end
    L17_2 = L7_2[L15_2]
    if L17_2 then
      L18_2 = L9_2[L17_2]
      if not L18_2 then
        L18_2 = {}
        L18_2.id = L17_2
        L18_2.preview = ""
        L18_2.deleted = true
      end
      L15_2.replyTo = L18_2
    end
  end
  return A0_2
end
function L49_1(A0_2)
  local L1_2, L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2
  L1_2 = Now
  L1_2 = L1_2()
  L2_2 = {}
  L3_2 = ipairs
  L4_2 = A0_2
  L3_2, L4_2, L5_2, L6_2 = L3_2(L4_2)
  for L7_2, L8_2 in L3_2, L4_2, L5_2, L6_2 do
    L9_2 = tonumber
    L10_2 = L8_2.expires_at
    L9_2 = L9_2(L10_2)
    L10_2 = tonumber
    L11_2 = L8_2.view_once
    L10_2 = L10_2(L11_2)
    L10_2 = 1 == L10_2
    L11_2 = nil
    L12_2 = nil
    L13_2 = nil
    L8_2.forwarded = nil
    L8_2.viewed_at = L13_2
    L8_2.view_once = L12_2
    L8_2.expires_at = L11_2
    if not L9_2 or not (L1_2 >= L9_2) then
      if L10_2 then
        L11_2 = L8_2.deleted
        if not L11_2 then
          L11_2 = type
          L12_2 = L8_2.payload
          L11_2 = L11_2(L12_2)
          if "table" == L11_2 then
            L11_2 = L8_2.payload
            if L11_2 then
              goto lbl_43
            end
          end
          L11_2 = {}
          ::lbl_43::
          L8_2.viewOnce = true
          L12_2 = {}
          L12_2.viewOnce = true
          L13_2 = L8_2.type
          if "audio" == L13_2 then
            L13_2 = tonumber
            L14_2 = L11_2.duration
            L13_2 = L13_2(L14_2)
            if L13_2 then
              goto lbl_56
            end
          end
          L13_2 = nil
          ::lbl_56::
          L12_2.duration = L13_2
          L13_2 = L11_2.ttl
          L12_2.ttl = L13_2
          L13_2 = L11_2.fwd
          L12_2.fwd = L13_2
          L8_2.payload = L12_2
          L8_2.content = ""
        end
      end
      L11_2 = #L2_2
      L11_2 = L11_2 + 1
      L2_2[L11_2] = L8_2
    end
  end
  return L2_2
end
L50_1 = [[
SELECT STRAIGHT_JOIN m.id, m.app, m.sender, m.receiver, m.type, m.content,
       CASE WHEN m.type = 'image' THEN NULL ELSE m.payload END AS payload,
       m.`read`, m.created, m.delivered_at, m.read_at, m.edited_at, m.deleted_all, m.deleted_receiver, t.other, t.unread
FROM (SELECT IF(sender = ?, receiver, sender) AS other, MAX(id) AS last_id,
             SUM(CASE WHEN receiver = ? AND `read` = 0 THEN 1 ELSE 0 END) AS unread
      FROM apex_phone_messages
      WHERE app = ? AND (sender = ? OR receiver = ?) AND conversation_id IS NULL
        AND NOT (sender = ? AND deleted_sender = 1) AND NOT (receiver = ? AND deleted_receiver = 1)
      GROUP BY other) t
JOIN apex_phone_messages m ON m.id = t.last_id
ORDER BY m.id DESC LIMIT 500]]
function L51_1(A0_2, A1_2, A2_2, A3_2)
  local L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2, L19_2, L20_2, L21_2, L22_2, L23_2, L24_2, L25_2
  L4_2 = type
  L5_2 = GroupListFor
  L4_2 = L4_2(L5_2)
  if "function" ~= L4_2 then
    L4_2 = {}
    return L4_2
  end
  L4_2 = pcall
  L5_2 = GroupListFor
  L6_2 = A0_2
  L7_2 = A1_2
  L4_2, L5_2 = L4_2(L5_2, L6_2, L7_2)
  if L4_2 then
    L6_2 = type
    L7_2 = L5_2
    L6_2 = L6_2(L7_2)
    if "table" == L6_2 then
      goto lbl_34
    end
  end
  if not L4_2 then
    L6_2 = print
    L7_2 = "^3[unique_phone]^0 GroupListFor: %s"
    L8_2 = L7_2
    L7_2 = L7_2.format
    L9_2 = tostring
    L10_2 = L5_2
    L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2, L19_2, L20_2, L21_2, L22_2, L23_2, L24_2, L25_2 = L9_2(L10_2)
    L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2, L19_2, L20_2, L21_2, L22_2, L23_2, L24_2, L25_2 = L7_2(L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2, L19_2, L20_2, L21_2, L22_2, L23_2, L24_2, L25_2)
    L6_2(L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2, L19_2, L20_2, L21_2, L22_2, L23_2, L24_2, L25_2)
  end
  L6_2 = {}
  do return L6_2 end
  ::lbl_34::
  L6_2 = Now
  L6_2 = L6_2()
  L7_2 = {}
  L8_2 = {}
  L9_2 = {}
  L10_2 = ipairs
  L11_2 = L5_2
  L10_2, L11_2, L12_2, L13_2 = L10_2(L11_2)
  for L14_2, L15_2 in L10_2, L11_2, L12_2, L13_2 do
    L16_2 = type
    L17_2 = L15_2
    L16_2 = L16_2(L17_2)
    L16_2 = L1_1
    L17_2 = L15_2.id
    L16_2 = "table" == L16_2 and L16_2
    if L16_2 then
      L17_2 = "g:"
      L18_2 = L16_2
      L17_2 = L17_2 .. L18_2
      L17_2 = A2_2[L17_2]
      L18_2 = L1_1
      L19_2 = L15_2.clearedBefore
      L18_2 = L18_2(L19_2)
      L18_2 = L17_2 or L18_2
      if not L18_2 and L17_2 then
        L18_2 = L1_1
        L19_2 = L17_2.cleared_before
        L18_2 = L18_2(L19_2)
      end
      L19_2 = type
      L20_2 = L15_2.lastMessage
      L19_2 = L19_2(L20_2)
      if "table" == L19_2 then
        L19_2 = L15_2.lastMessage
        if L19_2 then
          goto lbl_82
        end
      end
      L19_2 = nil
      ::lbl_82::
      L20_2 = L1_1
      L21_2 = L15_2.lastId
      L20_2 = L20_2(L21_2)
      L20_2 = L19_2 or L20_2
      if not L20_2 and L19_2 then
        L20_2 = L1_1
        L21_2 = L19_2.id
        L20_2 = L20_2(L21_2)
      end
      if not L18_2 or L20_2 and not (L18_2 >= L20_2) then
        L21_2 = tonumber
        L22_2 = L15_2.mutedUntil
        L21_2 = L21_2(L22_2)
        L21_2 = L17_2 or L21_2
        if not L21_2 and L17_2 then
          L21_2 = tonumber
          L22_2 = L17_2.muted_until
          L21_2 = L21_2(L22_2)
        end
        L22_2 = {}
        L22_2.conversation = L16_2
        L23_2 = "g:"
        L24_2 = L16_2
        L23_2 = L23_2 .. L24_2
        L22_2.number = L23_2
        L23_2 = L15_2.title
        L22_2.name = L23_2
        L23_2 = {}
        L23_2.id = L16_2
        L24_2 = L15_2.title
        L23_2.title = L24_2
        L24_2 = L15_2.avatar
        L23_2.avatar = L24_2
        L24_2 = L15_2.members
        L23_2.members = L24_2
        L24_2 = L15_2.memberCount
        L23_2.memberCount = L24_2
        L24_2 = L15_2.role
        L23_2.role = L24_2
        L22_2.group = L23_2
        L23_2 = math
        L23_2 = L23_2.tointeger
        L24_2 = tonumber
        L25_2 = L15_2.unread
        L24_2 = L24_2(L25_2)
        if not L24_2 then
          L24_2 = 0
        end
        L23_2 = L23_2(L24_2)
        if not L23_2 then
          L23_2 = 0
        end
        L22_2.unread = L23_2
        L22_2.last = L19_2
        L23_2 = tonumber
        L24_2 = L15_2.ts
        L23_2 = L23_2(L24_2)
        if not L23_2 then
          L23_2 = tonumber
          L24_2 = L15_2.created
          L23_2 = L23_2(L24_2)
          if not L23_2 then
            L23_2 = 0
          end
        end
        L22_2.ts = L23_2
        L23_2 = L15_2.pinned
        L23_2 = true == L23_2
        L22_2.pinned = L23_2
        L23_2 = L21_2 or L23_2
        if not (L21_2 and L6_2 < L21_2) or not L21_2 then
          L23_2 = nil
        end
        L22_2.mutedUntil = L23_2
        if L17_2 then
          L23_2 = L1_1
          L24_2 = L17_2.pinned_msg
          L23_2 = L23_2(L24_2)
          if L23_2 then
            goto lbl_186
          end
        end
        L23_2 = nil
        ::lbl_186::
        L22_2.pinnedMsg = L23_2
        if L19_2 then
          L23_2 = L19_2.sender
          if L23_2 == A0_2 then
            L23_2 = L19_2.deleted
            if not L23_2 then
              L23_2 = L19_2.type
              if "system" ~= L23_2 then
                L23_2 = L1_1
                L24_2 = L19_2.id
                L23_2 = L23_2(L24_2)
                if L23_2 then
                  L23_2 = #L8_2
                  L23_2 = L23_2 + 1
                  L24_2 = L1_1
                  L25_2 = L19_2.id
                  L24_2 = L24_2(L25_2)
                  L8_2[L23_2] = L24_2
                  L23_2 = #L9_2
                  L23_2 = L23_2 + 1
                  L9_2[L23_2] = L16_2
                  L23_2 = L1_1
                  L24_2 = L19_2.id
                  L23_2 = L23_2(L24_2)
                  L22_2._mine = L23_2
                end
              end
            end
          end
        end
        L23_2 = #L7_2
        L23_2 = L23_2 + 1
        L7_2[L23_2] = L22_2
      end
    end
  end
  L10_2 = #L8_2
  if L10_2 > 0 then
    L10_2 = {}
    L11_2 = {}
    L12_2 = {}
    L13_2 = A0_2
    L12_2[1] = L13_2
    L13_2 = ipairs
    L14_2 = L9_2
    L13_2, L14_2, L15_2, L16_2 = L13_2(L14_2)
    for L17_2, L18_2 in L13_2, L14_2, L15_2, L16_2 do
      L19_2 = #L12_2
      L19_2 = L19_2 + 1
      L12_2[L19_2] = L18_2
    end
    L13_2 = pcall
    L14_2 = MySQL
    L14_2 = L14_2.query
    L14_2 = L14_2.await
    L15_2 = "SELECT conversation_id, MIN(COALESCE(last_read_id, 0)) AS minr FROM apex_phone_conversation_members WHERE member <> ? AND left_at IS NULL AND conversation_id IN (%s) GROUP BY conversation_id"
    L16_2 = L15_2
    L15_2 = L15_2.format
    L17_2 = L2_1
    L18_2 = #L9_2
    L17_2, L18_2, L19_2, L20_2, L21_2, L22_2, L23_2, L24_2, L25_2 = L17_2(L18_2)
    L15_2 = L15_2(L16_2, L17_2, L18_2, L19_2, L20_2, L21_2, L22_2, L23_2, L24_2, L25_2)
    L16_2 = L12_2
    L13_2, L14_2 = L13_2(L14_2, L15_2, L16_2)
    if L13_2 then
      L15_2 = type
      L16_2 = L14_2
      L15_2 = L15_2(L16_2)
      if "table" == L15_2 then
        L15_2 = ipairs
        L16_2 = L14_2
        L15_2, L16_2, L17_2, L18_2 = L15_2(L16_2)
        for L19_2, L20_2 in L15_2, L16_2, L17_2, L18_2 do
          L21_2 = L1_1
          L22_2 = L20_2.conversation_id
          L21_2 = L21_2(L22_2)
          L22_2 = math
          L22_2 = L22_2.tointeger
          L23_2 = tonumber
          L24_2 = L20_2.minr
          L23_2 = L23_2(L24_2)
          if not L23_2 then
            L23_2 = 0
          end
          L22_2 = L22_2(L23_2)
          if not L22_2 then
            L22_2 = 0
          end
          L10_2[L21_2] = L22_2
        end
      end
    end
    L15_2 = pcall
    L16_2 = MySQL
    L16_2 = L16_2.query
    L16_2 = L16_2.await
    L17_2 = "SELECT id FROM apex_phone_messages WHERE delivered_at IS NOT NULL AND id IN (%s)"
    L18_2 = L17_2
    L17_2 = L17_2.format
    L19_2 = L2_1
    L20_2 = #L8_2
    L19_2, L20_2, L21_2, L22_2, L23_2, L24_2, L25_2 = L19_2(L20_2)
    L17_2 = L17_2(L18_2, L19_2, L20_2, L21_2, L22_2, L23_2, L24_2, L25_2)
    L18_2 = L8_2
    L15_2, L16_2 = L15_2(L16_2, L17_2, L18_2)
    if L15_2 then
      L17_2 = type
      L18_2 = L16_2
      L17_2 = L17_2(L18_2)
      if "table" == L17_2 then
        L17_2 = ipairs
        L18_2 = L16_2
        L17_2, L18_2, L19_2, L20_2 = L17_2(L18_2)
        for L21_2, L22_2 in L17_2, L18_2, L19_2, L20_2 do
          L23_2 = L1_1
          L24_2 = L22_2.id
          L23_2 = L23_2(L24_2)
          L11_2[L23_2] = true
        end
      end
    end
    L17_2 = ipairs
    L18_2 = L7_2
    L17_2, L18_2, L19_2, L20_2 = L17_2(L18_2)
    for L21_2, L22_2 in L17_2, L18_2, L19_2, L20_2 do
      L23_2 = L22_2._mine
      if L23_2 then
        if not A3_2 then
          L24_2 = L22_2.conversation
          L24_2 = L10_2[L24_2]
          if L24_2 then
            goto lbl_333
          end
        end
        L24_2 = nil
        ::lbl_333::
        if L24_2 and L23_2 <= L24_2 then
          L25_2 = "read"
          if L25_2 then
            goto lbl_347
          end
        end
        L25_2 = L11_2[L23_2]
        if L25_2 then
          L25_2 = "delivered"
          if L25_2 then
            goto lbl_347
          end
        end
        L25_2 = "sent"
        ::lbl_347::
        L22_2.lastStatus = L25_2
        L22_2._mine = nil
      end
    end
  end
  return L7_2
end
L52_1 = RPC
function L53_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2, L19_2, L20_2, L21_2, L22_2, L23_2, L24_2, L25_2, L26_2, L27_2, L28_2, L29_2, L30_2, L31_2, L32_2, L33_2, L34_2
  L2_2 = L6_1
  L3_2 = A1_2
  L2_2 = L2_2(L3_2)
  if "recado" == L2_2 then
    L3_2 = L7_1
    L4_2 = A1_2
    L3_2 = L3_2(L4_2)
    if not L3_2 then
      L3_2 = {}
      return L3_2
    end
  end
  L3_2 = L21_1
  L4_2 = A0_2
  L5_2 = L2_2
  L3_2 = L3_2(L4_2, L5_2)
  if not L3_2 then
    L4_2 = {}
    return L4_2
  end
  L4_2 = {}
  L5_2 = {}
  L6_2 = pcall
  L7_2 = MySQL
  L7_2 = L7_2.query
  L7_2 = L7_2.await
  L8_2 = L50_1
  L9_2 = {}
  L10_2 = L3_2
  L11_2 = L3_2
  L12_2 = L2_2
  L13_2 = L3_2
  L14_2 = L3_2
  L15_2 = L3_2
  L16_2 = L3_2
  L9_2[1] = L10_2
  L9_2[2] = L11_2
  L9_2[3] = L12_2
  L9_2[4] = L13_2
  L9_2[5] = L14_2
  L9_2[6] = L15_2
  L9_2[7] = L16_2
  L6_2, L7_2 = L6_2(L7_2, L8_2, L9_2)
  if L6_2 then
    L8_2 = type
    L9_2 = L7_2
    L8_2 = L8_2(L9_2)
    if "table" == L8_2 then
      L8_2 = ipairs
      L9_2 = L7_2
      L8_2, L9_2, L10_2, L11_2 = L8_2(L9_2)
      for L12_2, L13_2 in L8_2, L9_2, L10_2, L11_2 do
        L14_2 = L13_2.other
        L15_2 = math
        L15_2 = L15_2.tointeger
        L16_2 = tonumber
        L17_2 = L13_2.unread
        L16_2 = L16_2(L17_2)
        if not L16_2 then
          L16_2 = 0
        end
        L15_2 = L15_2(L16_2)
        if not L15_2 then
          L15_2 = 0
        end
        L16_2 = nil
        L13_2.unread = nil
        L13_2.other = L16_2
        if L14_2 then
          L16_2 = L4_2[L14_2]
          if not L16_2 then
            L16_2 = {}
            L16_2.number = L14_2
            L16_2.unread = L15_2
            L16_2.last = L13_2
            L17_2 = L13_2.created
            L16_2.ts = L17_2
            L4_2[L14_2] = L16_2
            L16_2 = #L5_2
            L16_2 = L16_2 + 1
            L5_2[L16_2] = L14_2
          end
        end
      end
  end
  else
    L8_2 = MySQL
    L8_2 = L8_2.query
    L8_2 = L8_2.await
    L9_2 = [[
SELECT id, app, sender, receiver, type, content, CASE WHEN type = 'image' THEN NULL ELSE payload END AS payload,
            `read`, created, delivered_at, read_at, edited_at, deleted_all, deleted_sender, deleted_receiver FROM apex_phone_messages
            WHERE app = ? AND (sender = ? OR receiver = ?) AND conversation_id IS NULL ORDER BY id DESC LIMIT 2000]]
    L10_2 = {}
    L11_2 = L2_2
    L12_2 = L3_2
    L13_2 = L3_2
    L10_2[1] = L11_2
    L10_2[2] = L12_2
    L10_2[3] = L13_2
    L8_2 = L8_2(L9_2, L10_2)
    if not L8_2 then
      L8_2 = {}
    end
    L9_2 = ipairs
    L10_2 = L8_2
    L9_2, L10_2, L11_2, L12_2 = L9_2(L10_2)
    for L13_2, L14_2 in L9_2, L10_2, L11_2, L12_2 do
      L15_2 = L14_2.sender
      if L15_2 == L3_2 then
        L15_2 = tonumber
        L16_2 = L14_2.deleted_sender
        L15_2 = L15_2(L16_2)
      end
      L15_2 = 1 == L15_2
      if not L15_2 then
        L16_2 = L14_2.sender
        if L16_2 == L3_2 then
          L16_2 = L14_2.receiver
          if L16_2 then
            goto lbl_140
          end
        end
        L16_2 = L14_2.sender
        ::lbl_140::
        L17_2 = L4_2[L16_2]
        if not L17_2 then
          L17_2 = {}
          L17_2.number = L16_2
          L17_2.unread = 0
          L17_2.last = L14_2
          L18_2 = L14_2.created
          L17_2.ts = L18_2
          L4_2[L16_2] = L17_2
          L17_2 = #L5_2
          L17_2 = L17_2 + 1
          L5_2[L17_2] = L16_2
        end
        L17_2 = L14_2.receiver
        if L17_2 == L3_2 then
          L17_2 = L14_2.sender
          if L17_2 ~= L3_2 then
            L17_2 = tonumber
            L18_2 = L14_2.read
            L17_2 = L17_2(L18_2)
            if 0 == L17_2 then
              L17_2 = L4_2[L16_2]
              L18_2 = L4_2[L16_2]
              L18_2 = L18_2.unread
              L18_2 = L18_2 + 1
              L17_2.unread = L18_2
            end
          end
        end
      end
    end
  end
  L8_2 = {}
  L9_2 = pcall
  L10_2 = MySQL
  L10_2 = L10_2.query
  L10_2 = L10_2.await
  L11_2 = "SELECT other, pinned, muted_until, pinned_msg, cleared_before FROM apex_phone_thread_meta WHERE owner = ? AND app = ? LIMIT 2000"
  L12_2 = {}
  L13_2 = L3_2
  L14_2 = L2_2
  L12_2[1] = L13_2
  L12_2[2] = L14_2
  L9_2, L10_2 = L9_2(L10_2, L11_2, L12_2)
  if L9_2 then
    L11_2 = type
    L12_2 = L10_2
    L11_2 = L11_2(L12_2)
    if "table" == L11_2 then
      L11_2 = ipairs
      L12_2 = L10_2
      L11_2, L12_2, L13_2, L14_2 = L11_2(L12_2)
      for L15_2, L16_2 in L11_2, L12_2, L13_2, L14_2 do
        L17_2 = L16_2.other
        L8_2[L17_2] = L16_2
      end
    end
  end
  L11_2 = {}
  L12_2 = ContactsOwner
  if L12_2 then
    L12_2 = ContactsOwner
    L13_2 = A0_2
    L12_2 = L12_2(L13_2)
    if L12_2 then
      goto lbl_217
    end
  end
  L12_2 = GetCid
  L13_2 = A0_2
  L12_2 = L12_2(L13_2)
  ::lbl_217::
  if ("sms" == L2_2 or "recado" == L2_2) and L12_2 then
    L13_2 = ipairs
    L14_2 = MySQL
    L14_2 = L14_2.query
    L14_2 = L14_2.await
    L15_2 = "SELECT name, number FROM apex_phone_contacts WHERE owner = ? LIMIT 5000"
    L16_2 = {}
    L17_2 = L12_2
    L16_2[1] = L17_2
    L14_2 = L14_2(L15_2, L16_2)
    if not L14_2 then
      L14_2 = {}
    end
    L13_2, L14_2, L15_2, L16_2 = L13_2(L14_2)
    for L17_2, L18_2 in L13_2, L14_2, L15_2, L16_2 do
      L19_2 = L18_2.number
      L20_2 = L18_2.name
      L11_2[L19_2] = L20_2
    end
  end
  L13_2 = GetPlayerNumber
  L14_2 = A0_2
  L13_2 = L13_2(L14_2)
  L14_2 = #L5_2
  if L14_2 > 0 then
    L14_2 = L34_1
    L15_2 = L2_2
    L16_2 = L5_2
    L17_2 = L13_2
    L14_2 = L14_2(L15_2, L16_2, L17_2)
    if L14_2 then
      goto lbl_260
    end
  end
  L14_2 = {}
  ::lbl_260::
  L15_2 = L32_1
  L16_2 = L12_2
  L15_2 = L15_2(L16_2)
  if "recado" == L2_2 then
    L16_2 = L15_2.noReceipts
    if not L16_2 then
      L16_2 = L9_1
      L17_2 = L2_2
      L18_2 = L3_2
      L16_2 = L16_2(L17_2, L18_2)
      if L16_2 then
        L16_2 = {}
        L17_2 = L15_2.hideSeen
        L16_2.hideSeen = L17_2
        L16_2.noReceipts = true
        L15_2 = L16_2
      end
    end
  end
  L16_2 = Now
  L16_2 = L16_2()
  L17_2 = {}
  L18_2 = ipairs
  L19_2 = L5_2
  L18_2, L19_2, L20_2, L21_2 = L18_2(L19_2)
  for L22_2, L23_2 in L18_2, L19_2, L20_2, L21_2 do
    L24_2 = L4_2[L23_2]
    L25_2 = L8_2[L23_2]
    L26_2 = L25_2 or L26_2
    if L25_2 then
      L26_2 = L1_1
      L27_2 = L25_2.cleared_before
      L26_2 = L26_2(L27_2)
    end
    L27_2 = L1_1
    L28_2 = L24_2.last
    L28_2 = L28_2.id
    L27_2 = L27_2(L28_2)
    if not L27_2 then
      L27_2 = 0
    end
    if not L26_2 or not (L26_2 >= L27_2) then
      if L26_2 then
        L28_2 = L24_2.unread
        if L28_2 > 0 then
          L28_2 = MySQL
          L28_2 = L28_2.scalar
          L28_2 = L28_2.await
          L29_2 = "SELECT COUNT(*) FROM apex_phone_messages WHERE app = ? AND sender = ? AND receiver = ? AND conversation_id IS NULL AND `read` = 0 AND deleted_receiver = 0 AND id > ?"
          L30_2 = {}
          L31_2 = L2_2
          L32_2 = L23_2
          L33_2 = L3_2
          L34_2 = L26_2
          L30_2[1] = L31_2
          L30_2[2] = L32_2
          L30_2[3] = L33_2
          L30_2[4] = L34_2
          L28_2 = L28_2(L29_2, L30_2)
          L29_2 = math
          L29_2 = L29_2.tointeger
          L30_2 = tonumber
          L31_2 = L28_2
          L30_2 = L30_2(L31_2)
          if not L30_2 then
            L30_2 = 0
          end
          L29_2 = L29_2(L30_2)
          if not L29_2 then
            L29_2 = 0
          end
          L24_2.unread = L29_2
        end
      end
      L28_2 = L14_2[L23_2]
      if not L28_2 then
        L28_2 = {}
      end
      L29_2 = L24_2.last
      L29_2 = L29_2.sender
      L29_2 = L29_2 == L3_2
      L30_2 = L45_1
      L31_2 = L24_2.last
      L32_2 = L29_2 or L32_2
      if L29_2 then
        L32_2 = L28_2.noReceipts
        if not L32_2 then
          L32_2 = L15_2.noReceipts
        end
      end
      L30_2(L31_2, L32_2)
      L30_2 = L11_2[L23_2]
      L24_2.name = L30_2
      if L25_2 then
        L30_2 = tonumber
        L31_2 = L25_2.pinned
        L30_2 = L30_2(L31_2)
      end
      L30_2 = 1 == L30_2 or L30_2
      L24_2.pinned = L30_2
      if L25_2 then
        L30_2 = tonumber
        L31_2 = L25_2.muted_until
        L30_2 = L30_2(L31_2)
        if not L30_2 then
          L30_2 = 0
        end
        if L16_2 < L30_2 then
          L30_2 = tonumber
          L31_2 = L25_2.muted_until
          L30_2 = L30_2(L31_2)
          if L30_2 then
            goto lbl_386
          end
        end
      end
      L30_2 = nil
      ::lbl_386::
      L24_2.mutedUntil = L30_2
      if L25_2 then
        L30_2 = L1_1
        L31_2 = L25_2.pinned_msg
        L30_2 = L30_2(L31_2)
        if L30_2 then
          goto lbl_395
        end
      end
      L30_2 = nil
      ::lbl_395::
      L24_2.pinnedMsg = L30_2
      L30_2 = L28_2.online
      L30_2 = true == L30_2
      L24_2.online = L30_2
      L30_2 = L28_2.lastSeen
      L24_2.lastSeen = L30_2
      if L29_2 then
        L30_2 = L24_2.last
        L30_2 = L30_2.deleted
        if not L30_2 then
          L30_2 = L24_2.last
          L30_2 = L30_2.status
          L24_2.lastStatus = L30_2
        end
      end
      L30_2 = #L17_2
      L30_2 = L30_2 + 1
      L17_2[L30_2] = L24_2
    end
  end
  L18_2 = ipairs
  L19_2 = L51_1
  L20_2 = L3_2
  L21_2 = L2_2
  L22_2 = L8_2
  L23_2 = L15_2.noReceipts
  L19_2, L20_2, L21_2, L22_2, L23_2, L24_2, L25_2, L26_2, L27_2, L28_2, L29_2, L30_2, L31_2, L32_2, L33_2, L34_2 = L19_2(L20_2, L21_2, L22_2, L23_2)
  L18_2, L19_2, L20_2, L21_2 = L18_2(L19_2, L20_2, L21_2, L22_2, L23_2, L24_2, L25_2, L26_2, L27_2, L28_2, L29_2, L30_2, L31_2, L32_2, L33_2, L34_2)
  for L22_2, L23_2 in L18_2, L19_2, L20_2, L21_2 do
    L24_2 = #L17_2
    L24_2 = L24_2 + 1
    L17_2[L24_2] = L23_2
  end
  L18_2 = table
  L18_2 = L18_2.sort
  L19_2 = L17_2
  function L20_2(A0_3, A1_3)
    local L2_3, L3_3, L4_3
    L2_3 = tonumber
    L3_3 = A0_3.ts
    L2_3 = L2_3(L3_3)
    if not L2_3 then
      L2_3 = 0
    end
    L3_3 = tonumber
    L4_3 = A1_3.ts
    L3_3 = L3_3(L4_3)
    if not L3_3 then
      L3_3 = 0
    end
    L2_3 = L2_3 > L3_3
    return L2_3
  end
  L18_2(L19_2, L20_2)
  return L17_2
end
L52_1["messages.threads"] = L53_1
function L52_1(A0_2)
  local L1_2, L2_2, L3_2, L4_2, L5_2, L6_2
  L1_2 = math
  L1_2 = L1_2.tointeger
  L2_2 = tonumber
  L3_2 = A0_2.limit
  L2_2, L3_2, L4_2, L5_2, L6_2 = L2_2(L3_2)
  L1_2 = L1_2(L2_2, L3_2, L4_2, L5_2, L6_2)
  if L1_2 then
    L2_2 = math
    L2_2 = L2_2.max
    L3_2 = 1
    L4_2 = math
    L4_2 = L4_2.min
    L5_2 = 50
    L6_2 = L1_2
    L4_2 = L4_2(L5_2, L6_2)
    L2_2 = L2_2(L3_2, L4_2)
    if L2_2 then
      goto lbl_21
      L1_2 = L2_2 or L1_2
    end
  end
  L1_2 = 300
  ::lbl_21::
  L2_2 = L1_2
  L3_2 = L1_1
  L4_2 = A0_2.before
  L3_2, L4_2, L5_2, L6_2 = L3_2(L4_2)
  return L2_2, L3_2, L4_2, L5_2, L6_2
end
function L53_1(A0_2, A1_2, A2_2)
  local L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2
  L3_2 = pcall
  L4_2 = MySQL
  L4_2 = L4_2.query
  L4_2 = L4_2.await
  L5_2 = "SELECT m.* FROM (SELECT id FROM apex_phone_messages WHERE "
  L6_2 = A0_2
  L7_2 = " ORDER BY id DESC LIMIT "
  L8_2 = A2_2
  L9_2 = ") t JOIN apex_phone_messages m ON m.id = t.id ORDER BY m.id ASC"
  L5_2 = L5_2 .. L6_2 .. L7_2 .. L8_2 .. L9_2
  L6_2 = A1_2
  L3_2, L4_2 = L3_2(L4_2, L5_2, L6_2)
  if L3_2 then
    L5_2 = type
    L6_2 = L4_2
    L5_2 = L5_2(L6_2)
    if "table" == L5_2 then
      goto lbl_47
    end
  end
  L5_2 = MySQL
  L5_2 = L5_2.query
  L5_2 = L5_2.await
  L6_2 = "SELECT * FROM apex_phone_messages WHERE "
  L7_2 = A0_2
  L8_2 = " ORDER BY id DESC LIMIT "
  L9_2 = A2_2
  L6_2 = L6_2 .. L7_2 .. L8_2 .. L9_2
  L7_2 = A1_2
  L5_2 = L5_2(L6_2, L7_2)
  if not L5_2 then
    L5_2 = {}
  end
  L6_2 = {}
  L4_2 = L6_2
  L6_2 = #L5_2
  L7_2 = 1
  L8_2 = -1
  for L9_2 = L6_2, L7_2, L8_2 do
    L10_2 = #L4_2
    L10_2 = L10_2 + 1
    L11_2 = L5_2[L9_2]
    L4_2[L10_2] = L11_2
  end
  ::lbl_47::
  L5_2 = ipairs
  L6_2 = L4_2
  L5_2, L6_2, L7_2, L8_2 = L5_2(L6_2)
  for L9_2, L10_2 in L5_2, L6_2, L7_2, L8_2 do
    L11_2 = L1_1
    L12_2 = L10_2.id
    L11_2 = L11_2(L12_2)
    L10_2.id = L11_2
  end
  return L4_2
end
function L54_1(A0_2, A1_2, A2_2)
  local L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2, L19_2, L20_2, L21_2, L22_2, L23_2
  L3_2 = L36_1
  L4_2 = A1_2
  L3_2 = L3_2(L4_2)
  if not L3_2 then
    L4_2 = {}
    return L4_2
  end
  if "recado" == L3_2 then
    L4_2 = L7_1
    L5_2 = A2_2
    L4_2 = L4_2(L5_2)
    if not L4_2 then
      L4_2 = {}
      return L4_2
    end
  end
  L4_2 = L21_1
  L5_2 = A0_2
  L6_2 = L3_2
  L4_2 = L4_2(L5_2, L6_2)
  if L4_2 then
    L5_2 = L37_1
    L6_2 = A1_2
    L7_2 = L4_2
    L5_2 = L5_2(L6_2, L7_2)
    if L5_2 then
      goto lbl_34
    end
  end
  L5_2 = {}
  do return L5_2 end
  ::lbl_34::
  L5_2 = L52_1
  L6_2 = A2_2
  L5_2, L6_2 = L5_2(L6_2)
  L7_2 = L42_1
  L8_2 = L4_2
  L9_2 = L3_2
  L10_2 = "g:"
  L11_2 = A1_2
  L10_2 = L10_2 .. L11_2
  L7_2 = L7_2(L8_2, L9_2, L10_2)
  L8_2 = L7_2 or L8_2
  if L7_2 then
    L8_2 = L1_1
    L9_2 = L7_2.cleared_before
    L8_2 = L8_2(L9_2)
  end
  L9_2 = L38_1
  L10_2 = A1_2
  L11_2 = L4_2
  L9_2 = L9_2(L10_2, L11_2)
  L10_2 = "conversation_id = ? AND NOT (sender = ? AND deleted_sender = 1)"
  if L6_2 then
    L11_2 = " AND id < ?"
    if L11_2 then
      goto lbl_60
    end
  end
  L11_2 = ""
  ::lbl_60::
  if L8_2 then
    L12_2 = " AND id > ?"
    if L12_2 then
      goto lbl_66
    end
  end
  L12_2 = ""
  ::lbl_66::
  if L9_2 then
    L13_2 = " AND created >= ?"
    if L13_2 then
      goto lbl_72
    end
  end
  L13_2 = ""
  ::lbl_72::
  L10_2 = L10_2 .. L11_2 .. L12_2 .. L13_2
  L11_2 = {}
  L12_2 = A1_2
  L13_2 = L4_2
  L11_2[1] = L12_2
  L11_2[2] = L13_2
  if L6_2 then
    L12_2 = #L11_2
    L12_2 = L12_2 + 1
    L11_2[L12_2] = L6_2
  end
  if L8_2 then
    L12_2 = #L11_2
    L12_2 = L12_2 + 1
    L11_2[L12_2] = L8_2
  end
  if L9_2 then
    L12_2 = #L11_2
    L12_2 = L12_2 + 1
    L11_2[L12_2] = L9_2
  end
  L12_2 = L53_1
  L13_2 = L10_2
  L14_2 = L11_2
  L15_2 = L5_2
  L12_2 = L12_2(L13_2, L14_2, L15_2)
  L13_2 = nil
  L14_2 = #L12_2
  if L14_2 > 0 then
    L14_2 = L32_1
    L15_2 = GetCid
    L16_2 = A0_2
    L15_2, L16_2, L17_2, L18_2, L19_2, L20_2, L21_2, L22_2, L23_2 = L15_2(L16_2)
    L14_2 = L14_2(L15_2, L16_2, L17_2, L18_2, L19_2, L20_2, L21_2, L22_2, L23_2)
    L14_2 = L14_2.noReceipts
    if not L14_2 then
      L14_2 = L9_1
      L15_2 = L3_2
      L16_2 = L4_2
      L14_2 = L14_2(L15_2, L16_2)
      if not L14_2 then
        L14_2 = ipairs
        L15_2 = L39_1
        L16_2 = A1_2
        L15_2, L16_2, L17_2, L18_2, L19_2, L20_2, L21_2, L22_2, L23_2 = L15_2(L16_2)
        L14_2, L15_2, L16_2, L17_2 = L14_2(L15_2, L16_2, L17_2, L18_2, L19_2, L20_2, L21_2, L22_2, L23_2)
        for L18_2, L19_2 in L14_2, L15_2, L16_2, L17_2 do
          L20_2 = L19_2.member
          if L20_2 ~= L4_2 then
            L20_2 = math
            L20_2 = L20_2.tointeger
            L21_2 = tonumber
            L22_2 = L19_2.last_read_id
            L21_2 = L21_2(L22_2)
            if not L21_2 then
              L21_2 = 0
            end
            L20_2 = L20_2(L21_2)
            if not L20_2 then
              L20_2 = 0
            end
            if L13_2 then
              L21_2 = math
              L21_2 = L21_2.min
              L22_2 = L13_2
              L23_2 = L20_2
              L21_2 = L21_2(L22_2, L23_2)
              if L21_2 then
                goto lbl_150
                L13_2 = L21_2 or L13_2
              end
            end
            L13_2 = L20_2
          end
          ::lbl_150::
        end
      end
    end
  end
  L14_2 = L48_1
  L15_2 = L12_2
  L16_2 = L4_2
  L17_2 = false
  L18_2 = L13_2
  L14_2 = L14_2(L15_2, L16_2, L17_2, L18_2)
  if "recado" == L3_2 then
    L15_2 = L49_1
    L16_2 = L14_2
    return L15_2(L16_2)
  end
  return L14_2
end
L55_1 = RPC
function L56_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2
  L2_2 = L11_1
  L3_2 = A1_2
  L2_2 = L2_2(L3_2)
  if nil ~= L2_2 then
    if not L2_2 then
      L3_2 = {}
      return L3_2
    end
    L3_2 = L54_1
    L4_2 = A0_2
    L5_2 = L2_2
    L6_2 = A1_2
    return L3_2(L4_2, L5_2, L6_2)
  end
  L3_2 = L6_1
  L4_2 = A1_2
  L3_2 = L3_2(L4_2)
  if "recado" == L3_2 then
    L4_2 = L7_1
    L5_2 = A1_2
    L4_2 = L4_2(L5_2)
    if not L4_2 then
      L4_2 = {}
      return L4_2
    end
  end
  L4_2 = L21_1
  L5_2 = A0_2
  L6_2 = L3_2
  L4_2 = L4_2(L5_2, L6_2)
  if not L4_2 then
    L5_2 = {}
    return L5_2
  end
  L5_2 = L5_1
  L6_2 = L3_2
  L7_2 = L4_1
  L8_2 = A1_2.number
  L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2 = L7_2(L8_2)
  L5_2 = L5_2(L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2)
  if not L5_2 then
    L6_2 = {}
    return L6_2
  end
  L6_2 = L52_1
  L7_2 = A1_2
  L6_2, L7_2 = L6_2(L7_2)
  L8_2 = L42_1
  L9_2 = L4_2
  L10_2 = L3_2
  L11_2 = L5_2
  L8_2 = L8_2(L9_2, L10_2, L11_2)
  L9_2 = L8_2 or L9_2
  if L8_2 then
    L9_2 = L1_1
    L10_2 = L8_2.cleared_before
    L9_2 = L9_2(L10_2)
  end
  L10_2 = "app = ? AND conversation_id IS NULL AND ((sender = ? AND receiver = ? AND deleted_sender = 0) OR (sender = ? AND receiver = ? AND deleted_receiver = 0))"
  if L7_2 then
    L11_2 = " AND id < ?"
    if L11_2 then
      goto lbl_70
    end
  end
  L11_2 = ""
  ::lbl_70::
  if L9_2 then
    L12_2 = " AND id > ?"
    if L12_2 then
      goto lbl_76
    end
  end
  L12_2 = ""
  ::lbl_76::
  L10_2 = L10_2 .. L11_2 .. L12_2
  L11_2 = {}
  L12_2 = L3_2
  L13_2 = L4_2
  L14_2 = L5_2
  L15_2 = L5_2
  L16_2 = L4_2
  L11_2[1] = L12_2
  L11_2[2] = L13_2
  L11_2[3] = L14_2
  L11_2[4] = L15_2
  L11_2[5] = L16_2
  if L7_2 then
    L12_2 = #L11_2
    L12_2 = L12_2 + 1
    L11_2[L12_2] = L7_2
  end
  if L9_2 then
    L12_2 = #L11_2
    L12_2 = L12_2 + 1
    L11_2[L12_2] = L9_2
  end
  L12_2 = L53_1
  L13_2 = L10_2
  L14_2 = L11_2
  L15_2 = L6_2
  L12_2 = L12_2(L13_2, L14_2, L15_2)
  L13_2 = #L12_2
  if 0 == L13_2 then
    return L12_2
  end
  L13_2 = L32_1
  L14_2 = GetCid
  L15_2 = A0_2
  L14_2, L15_2, L16_2, L17_2, L18_2 = L14_2(L15_2)
  L13_2 = L13_2(L14_2, L15_2, L16_2, L17_2, L18_2)
  L13_2 = L13_2.noReceipts
  if not L13_2 then
    L13_2 = L9_1
    L14_2 = L3_2
    L15_2 = L4_2
    L13_2 = L13_2(L14_2, L15_2)
  end
  if not L13_2 then
    L14_2 = L34_1
    L15_2 = L3_2
    L16_2 = {}
    L17_2 = L5_2
    L16_2[1] = L17_2
    L17_2 = GetPlayerNumber
    L18_2 = A0_2
    L17_2, L18_2 = L17_2(L18_2)
    L14_2 = L14_2(L15_2, L16_2, L17_2, L18_2)
    L14_2 = L14_2[L5_2]
    if L14_2 then
      L15_2 = L14_2.noReceipts
      if L15_2 then
        goto lbl_137
        L13_2 = L15_2 or L13_2
      end
    end
    L13_2 = false
  end
  ::lbl_137::
  L14_2 = L48_1
  L15_2 = L12_2
  L16_2 = L4_2
  L17_2 = L13_2
  L18_2 = nil
  L14_2 = L14_2(L15_2, L16_2, L17_2, L18_2)
  if "recado" == L3_2 then
    L15_2 = L49_1
    L16_2 = L14_2
    return L15_2(L16_2)
  end
  return L14_2
end
L55_1["messages.get"] = L56_1
function L55_1(A0_2, A1_2, A2_2, A3_2, A4_2, A5_2, A6_2, A7_2)
  local L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2, L19_2, L20_2, L21_2, L22_2, L23_2, L24_2, L25_2, L26_2
  L8_2 = type
  L9_2 = A7_2
  L8_2 = L8_2(L9_2)
  if "table" ~= L8_2 or not A7_2 then
    L8_2 = {}
    A7_2 = L8_2
  end
  if not A0_2 then
    A0_2 = "sms"
  end
  L8_2 = Now
  L8_2 = L8_2()
  if A5_2 then
    L9_2 = json
    L9_2 = L9_2.encode
    L10_2 = A5_2
    L9_2 = L9_2(L10_2)
    if L9_2 then
      goto lbl_25
    end
  end
  L9_2 = nil
  ::lbl_25::
  L10_2 = A7_2.hidden
  if nil == L10_2 then
    L10_2 = false
    L11_2 = L0_1
    L11_2 = L11_2[A0_2]
    if L11_2 and A2_2 ~= A1_2 then
      L11_2 = L33_1
      L12_2 = A0_2
      L13_2 = A2_2
      L11_2 = L11_2(L12_2, L13_2)
      L12_2 = IsBlocked
      L13_2 = L11_2
      L14_2 = A1_2
      L12_2 = L12_2(L13_2, L14_2)
      L10_2 = nil ~= L11_2 and L10_2
    end
  end
  if not L10_2 then
    L11_2 = L22_1
    L12_2 = A0_2
    L13_2 = A2_2
    L11_2 = L11_2(L12_2, L13_2)
    if L11_2 then
      goto lbl_58
    end
  end
  L11_2 = nil
  ::lbl_58::
  L12_2 = HasPhoneItem
  L12_2 = HasPhoneItem
  L13_2 = L11_2
  L12_2 = nil ~= L11_2 and L11_2 ~= A6_2 and L12_2
  L13_2 = L1_1
  L14_2 = A7_2.replyTo
  L13_2 = L13_2(L14_2)
  L14_2 = MySQL
  L14_2 = L14_2.insert
  L14_2 = L14_2.await
  L15_2 = "INSERT INTO apex_phone_messages (app, sender, receiver, type, content, payload, `read`, created, delivered_at, reply_to, deleted_receiver) VALUES (?, ?, ?, ?, ?, ?, 0, ?, ?, ?, ?)"
  L16_2 = {}
  L17_2 = A0_2
  L18_2 = A1_2
  L19_2 = A2_2
  L20_2 = A3_2 or L20_2
  if not A3_2 then
    L20_2 = "text"
  end
  L21_2 = A4_2 or L21_2
  if not A4_2 then
    L21_2 = ""
  end
  L22_2 = L9_2
  L23_2 = L8_2
  L24_2 = L8_2 or L24_2
  if not L12_2 or not L8_2 then
    L24_2 = nil
  end
  L25_2 = L13_2
  if L10_2 then
    L26_2 = 1
    if L26_2 then
      goto lbl_103
    end
  end
  L26_2 = 0
  ::lbl_103::
  L16_2[1] = L17_2
  L16_2[2] = L18_2
  L16_2[3] = L19_2
  L16_2[4] = L20_2
  L16_2[5] = L21_2
  L16_2[6] = L22_2
  L16_2[7] = L23_2
  L16_2[8] = L24_2
  L16_2[9] = L25_2
  L16_2[10] = L26_2
  L14_2 = L14_2(L15_2, L16_2)
  L15_2 = {}
  L16_2 = L1_1
  L17_2 = L14_2
  L16_2 = L16_2(L17_2)
  L15_2.id = L16_2
  L15_2.app = A0_2
  L15_2.sender = A1_2
  L15_2.receiver = A2_2
  L16_2 = A3_2 or L16_2
  if not A3_2 then
    L16_2 = "text"
  end
  L15_2.type = L16_2
  L16_2 = A4_2 or L16_2
  if not A4_2 then
    L16_2 = ""
  end
  L15_2.content = L16_2
  L15_2.payload = A5_2
  L15_2.read = false
  L15_2.created = L8_2
  if L12_2 then
    L16_2 = "delivered"
    if L16_2 then
      goto lbl_131
    end
  end
  L16_2 = "sent"
  ::lbl_131::
  L15_2.status = L16_2
  L16_2 = L8_2 or L16_2
  if not L12_2 or not L8_2 then
    L16_2 = nil
  end
  L15_2.deliveredAt = L16_2
  if L13_2 then
    L16_2 = A7_2.reply
    if L16_2 then
      goto lbl_149
    end
    L16_2 = {}
    L16_2.id = L13_2
    if L16_2 then
      goto lbl_149
    end
  end
  L16_2 = nil
  ::lbl_149::
  L15_2.replyTo = L16_2
  if L12_2 then
    L16_2 = L42_1
    L17_2 = A2_2
    L18_2 = A0_2
    L19_2 = A1_2
    L16_2 = L16_2(L17_2, L18_2, L19_2)
    L17_2 = L0_1
    L17_2 = L17_2[A0_2]
    if L17_2 then
      L17_2 = SimLineTag
      if L17_2 then
        L17_2 = SimLineTag
        L18_2 = L11_2
        L19_2 = A2_2
        L17_2 = L17_2(L18_2, L19_2)
        if L17_2 then
          goto lbl_171
        end
      end
    end
    L17_2 = nil
    ::lbl_171::
    if L16_2 then
      L18_2 = tonumber
      L19_2 = L16_2.muted_until
      L18_2 = L18_2(L19_2)
      if not L18_2 then
        L18_2 = 0
      end
    end
    if L8_2 < L18_2 or L17_2 then
      L18_2 = {}
      L19_2 = pairs
      L20_2 = L15_2
      L19_2, L20_2, L21_2, L22_2 = L19_2(L20_2)
      for L23_2, L24_2 in L19_2, L20_2, L21_2, L22_2 do
        L18_2[L23_2] = L24_2
      end
      if L16_2 then
        L19_2 = tonumber
        L20_2 = L16_2.muted_until
        L19_2 = L19_2(L20_2)
        if not L19_2 then
          L19_2 = 0
        end
        if L8_2 < L19_2 then
          L18_2.muted = true
        end
      end
      L18_2.line = L17_2
      L19_2 = Push
      L20_2 = L11_2
      L21_2 = "message"
      L22_2 = L18_2
      L19_2(L20_2, L21_2, L22_2)
    else
      L18_2 = Push
      L19_2 = L11_2
      L20_2 = "message"
      L21_2 = L15_2
      L18_2(L19_2, L20_2, L21_2)
    end
  end
  L16_2 = {}
  L17_2 = pairs
  L18_2 = L15_2
  L17_2, L18_2, L19_2, L20_2 = L17_2(L18_2)
  for L21_2, L22_2 in L17_2, L18_2, L19_2, L20_2 do
    L16_2[L21_2] = L22_2
  end
  if L10_2 then
    L16_2.blocked = true
  end
  if L9_2 then
    L17_2 = #L9_2
    L18_2 = 8192
    if L17_2 > L18_2 then
      L17_2 = nil
      L16_2.payloadTrimmed = true
      L16_2.payload = L17_2
    end
  end
  L17_2 = TriggerEvent
  L18_2 = "apex_phone:messageSent"
  L19_2 = L16_2
  L17_2(L18_2, L19_2)
  return L15_2
end
SendMessageInternal = L55_1
function L55_1(A0_2)
  local L1_2, L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2
  if nil == A0_2 then
    L1_2 = nil
    L2_2 = true
    return L1_2, L2_2
  end
  L1_2 = type
  L2_2 = A0_2
  L1_2 = L1_2(L2_2)
  if "table" == L1_2 then
    L1_2 = #A0_2
    if not (L1_2 > 64) then
      goto lbl_17
    end
  end
  L1_2 = nil
  L2_2 = false
  do return L1_2, L2_2 end
  ::lbl_17::
  L1_2 = {}
  L2_2 = ipairs
  L3_2 = A0_2
  L2_2, L3_2, L4_2, L5_2 = L2_2(L3_2)
  for L6_2, L7_2 in L2_2, L3_2, L4_2, L5_2 do
    L8_2 = tonumber
    L9_2 = L7_2
    L8_2 = L8_2(L9_2)
    if L8_2 and L8_2 == L8_2 then
      L9_2 = -0.01
      if not (L8_2 < L9_2) then
        L9_2 = 1.01
        if not (L8_2 > L9_2) then
          goto lbl_39
        end
      end
    end
    L9_2 = nil
    L10_2 = false
    do return L9_2, L10_2 end
    ::lbl_39::
    L9_2 = math
    L9_2 = L9_2.max
    L10_2 = 0
    L11_2 = math
    L11_2 = L11_2.min
    L12_2 = 1
    L13_2 = L8_2
    L11_2 = L11_2(L12_2, L13_2)
    L9_2 = L9_2(L10_2, L11_2)
    L8_2 = L9_2
    L9_2 = #L1_2
    L9_2 = L9_2 + 1
    L10_2 = math
    L10_2 = L10_2.floor
    L11_2 = L8_2 * 100
    L11_2 = L11_2 + 0.5
    L10_2 = L10_2(L11_2)
    L10_2 = L10_2 / 100
    L1_2[L9_2] = L10_2
  end
  L2_2 = #L1_2
  L2_2 = L1_2 or L2_2
  if not (L2_2 > 0) or not L1_2 then
    L2_2 = nil
  end
  L3_2 = true
  return L2_2, L3_2
end
function L56_1(A0_2)
  local L1_2, L2_2, L3_2, L4_2
  if nil == A0_2 then
    L1_2 = "text"
    return L1_2
  end
  L1_2 = type
  L2_2 = A0_2
  L1_2 = L1_2(L2_2)
  if "string" ~= L1_2 then
    L1_2 = nil
    return L1_2
  end
  L2_2 = A0_2
  L1_2 = A0_2.sub
  L3_2 = 1
  L4_2 = 16
  L1_2 = L1_2(L2_2, L3_2, L4_2)
  if "" == L1_2 then
    L2_2 = "text"
    return L2_2
  end
  L3_2 = L1_2
  L2_2 = L1_2.match
  L4_2 = "^[%w_%-]+$"
  L2_2 = L2_2(L3_2, L4_2)
  if not L2_2 or "system" == L1_2 then
    L2_2 = nil
    return L2_2
  end
  return L1_2
end
function L57_1(A0_2, A1_2, A2_2, A3_2)
  local L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2
  function L4_2(A0_3)
    local L1_3
    L1_3 = nil ~= A0_3 and false ~= A0_3 and 0 ~= A0_3 and "" ~= A0_3
    return L1_3
  end
  L5_2 = L4_2
  L6_2 = A3_2.mediaId
  L5_2 = L5_2(L6_2)
  if L5_2 then
    L5_2 = A3_2.mediaId
    if L5_2 then
      goto lbl_11
    end
  end
  L5_2 = nil
  ::lbl_11::
  if nil == L5_2 and A2_2 then
    L6_2 = L4_2
    L7_2 = A2_2.mediaId
    L6_2 = L6_2(L7_2)
    if L6_2 then
      L5_2 = A2_2.mediaId
    end
  end
  if A2_2 then
    L6_2 = A2_2.mediaId
    if nil ~= L6_2 then
      L6_2 = L4_2
      L7_2 = A2_2.mediaId
      L6_2 = L6_2(L7_2)
      if not L6_2 then
        L6_2 = {}
        L7_2 = pairs
        L8_2 = A2_2
        L7_2, L8_2, L9_2, L10_2 = L7_2(L8_2)
        for L11_2, L12_2 in L7_2, L8_2, L9_2, L10_2 do
          L6_2[L11_2] = L12_2
        end
        L6_2.mediaId = nil
        A2_2 = L6_2
      end
    end
  end
  if nil == L5_2 then
    if "audio" == A1_2 then
      L6_2 = nil
      L7_2 = "badmedia"
      return L6_2, L7_2
    end
    return A2_2
  end
  L6_2 = L1_1
  L7_2 = L5_2
  L6_2 = L6_2(L7_2)
  if not L6_2 or "image" ~= A1_2 and "audio" ~= A1_2 then
    L7_2 = nil
    L8_2 = "badmedia"
    return L7_2, L8_2
  end
  L7_2 = type
  L8_2 = MediaInfo
  L7_2 = L7_2(L8_2)
  if "function" == L7_2 then
    L7_2 = MediaInfo
    L8_2 = L6_2
    L7_2 = L7_2(L8_2)
    if L7_2 then
      goto lbl_74
    end
  end
  L7_2 = nil
  ::lbl_74::
  if L7_2 then
    L8_2 = L7_2.complete
    if L8_2 then
      L8_2 = L7_2.kind
      if L8_2 == A1_2 then
        L8_2 = type
        L9_2 = MediaCanRead
        L8_2 = L8_2(L9_2)
        if "function" == L8_2 then
          L8_2 = MediaCanRead
          L9_2 = A0_2
          L10_2 = L6_2
          L8_2 = L8_2(L9_2, L10_2)
          if L8_2 then
            goto lbl_96
          end
        end
      end
    end
  end
  L8_2 = nil
  L9_2 = "badmedia"
  do return L8_2, L9_2 end
  ::lbl_96::
  if "audio" == A1_2 then
    L8_2 = L55_1
    L9_2 = A2_2 or L9_2
    if A2_2 then
      L9_2 = A2_2.waveform
    end
    L8_2, L9_2 = L8_2(L9_2)
    if not L9_2 then
      L10_2 = nil
      L11_2 = "badwave"
      return L10_2, L11_2
    end
    if not L8_2 then
      L10_2 = type
      L11_2 = L7_2.meta
      L10_2 = L10_2(L11_2)
      if "table" == L10_2 then
        L10_2 = L55_1
        L11_2 = L7_2.meta
        L11_2 = L11_2.waveform
        L10_2, L11_2 = L10_2(L11_2)
        if L11_2 then
          L8_2 = L10_2
        end
      end
    end
    L10_2 = type
    L11_2 = Config
    L11_2 = L11_2.Media
    L10_2 = L10_2(L11_2)
    if "table" == L10_2 then
      L10_2 = Config
      L10_2 = L10_2.Media
      if L10_2 then
        goto lbl_134
      end
    end
    L10_2 = {}
    ::lbl_134::
    L11_2 = math
    L11_2 = L11_2.floor
    L12_2 = tonumber
    L13_2 = L10_2.maxAudioSec
    L12_2 = L12_2(L13_2)
    if not L12_2 then
      L12_2 = 60
    end
    L12_2 = L12_2 * 1000
    L11_2 = L11_2(L12_2)
    L11_2 = L11_2 + 1500
    L12_2 = L7_2.duration
    if not L12_2 then
      L12_2 = math
      L12_2 = L12_2.tointeger
      L13_2 = math
      L13_2 = L13_2.floor
      L14_2 = tonumber
      L15_2 = A2_2 or L15_2
      if A2_2 then
        L15_2 = A2_2.duration
      end
      L14_2 = L14_2(L15_2)
      if not L14_2 then
        L14_2 = 0
      end
      L13_2, L14_2, L15_2, L16_2, L17_2 = L13_2(L14_2)
      L12_2 = L12_2(L13_2, L14_2, L15_2, L16_2, L17_2)
      if not L12_2 then
        L12_2 = 0
      end
    end
    L13_2 = math
    L13_2 = L13_2.max
    L14_2 = 0
    L15_2 = math
    L15_2 = L15_2.min
    L16_2 = L11_2
    L17_2 = L12_2
    L15_2 = L15_2(L16_2, L17_2)
    L13_2 = L13_2(L14_2, L15_2)
    L12_2 = L13_2
    L13_2 = {}
    L13_2.mediaId = L6_2
    L13_2.duration = L12_2
    L13_2.waveform = L8_2
    return L13_2
  end
  L8_2 = {}
  if A2_2 then
    L9_2 = pairs
    L10_2 = A2_2
    L9_2, L10_2, L11_2, L12_2 = L9_2(L10_2)
    for L13_2, L14_2 in L9_2, L10_2, L11_2, L12_2 do
      L8_2[L13_2] = L14_2
    end
  end
  L8_2.mediaId = L6_2
  L9_2 = type
  L10_2 = L8_2.url
  L9_2 = L9_2(L10_2)
  if "string" == L9_2 then
    L9_2 = L8_2.url
    L10_2 = L9_2
    L9_2 = L9_2.sub
    L11_2 = 1
    L12_2 = 5
    L9_2 = L9_2(L10_2, L11_2, L12_2)
    if "data:" == L9_2 then
      L8_2.url = nil
    end
  end
  return L8_2
end
function L58_1(A0_2, A1_2, A2_2, A3_2, A4_2, A5_2)
  local L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2, L19_2, L20_2, L21_2, L22_2, L23_2, L24_2, L25_2
  L6_2 = type
  L7_2 = GroupSend
  L6_2 = L6_2(L7_2)
  if "function" ~= L6_2 then
    L6_2 = {}
    L6_2.error = "nogroups"
    return L6_2
  end
  if A5_2 then
    L6_2 = MySQL
    L6_2 = L6_2.single
    L6_2 = L6_2.await
    L7_2 = "SELECT id, created FROM apex_phone_messages WHERE id = ? AND conversation_id = ?"
    L8_2 = {}
    L9_2 = A5_2
    L10_2 = A1_2
    L8_2[1] = L9_2
    L8_2[2] = L10_2
    L6_2 = L6_2(L7_2, L8_2)
    if not L6_2 then
      L7_2 = {}
      L7_2.error = "badreply"
      return L7_2
    end
    L7_2 = L21_1
    L8_2 = A0_2
    L9_2 = L36_1
    L10_2 = A1_2
    L9_2 = L9_2(L10_2)
    if not L9_2 then
      L9_2 = "sms"
    end
    L7_2 = L7_2(L8_2, L9_2)
    L8_2 = L7_2 or L8_2
    if L7_2 then
      L8_2 = L38_1
      L9_2 = A1_2
      L10_2 = L7_2
      L8_2 = L8_2(L9_2, L10_2)
    end
    if L8_2 then
      L9_2 = tonumber
      L10_2 = L6_2.created
      L9_2 = L9_2(L10_2)
      if not L9_2 then
        L9_2 = 0
      end
      if L8_2 > L9_2 then
        L9_2 = {}
        L9_2.error = "badreply"
        return L9_2
      end
    end
  end
  L6_2 = pcall
  L7_2 = GroupSend
  L8_2 = A0_2
  L9_2 = A1_2
  L10_2 = {}
  L10_2.type = A2_2
  L10_2.content = A3_2
  L10_2.payload = A4_2
  if A4_2 then
    L11_2 = A4_2.mediaId
    if L11_2 then
      goto lbl_72
    end
  end
  L11_2 = nil
  ::lbl_72::
  L10_2.mediaId = L11_2
  L10_2.replyTo = A5_2
  L6_2, L7_2, L8_2 = L6_2(L7_2, L8_2, L9_2, L10_2)
  if not L6_2 then
    L9_2 = print
    L10_2 = "^1[unique_phone]^0 GroupSend: %s"
    L11_2 = L10_2
    L10_2 = L10_2.format
    L12_2 = tostring
    L13_2 = L7_2
    L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2, L19_2, L20_2, L21_2, L22_2, L23_2, L24_2, L25_2 = L12_2(L13_2)
    L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2, L19_2, L20_2, L21_2, L22_2, L23_2, L24_2, L25_2 = L10_2(L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2, L19_2, L20_2, L21_2, L22_2, L23_2, L24_2, L25_2)
    L9_2(L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2, L19_2, L20_2, L21_2, L22_2, L23_2, L24_2, L25_2)
    L9_2 = {}
    L9_2.error = "internal"
    return L9_2
  end
  L9_2 = type
  L10_2 = L7_2
  L9_2 = L9_2(L10_2)
  if "table" ~= L9_2 then
    L9_2 = {}
    L10_2 = L8_2 or L10_2
    if not L8_2 then
      L10_2 = "db"
    end
    L9_2.error = L10_2
    return L9_2
  end
  L9_2 = L1_1
  L10_2 = L7_2.id
  L9_2 = L9_2(L10_2)
  L10_2 = L7_2.sender
  L7_2.status = "sent"
  if L9_2 then
    L11_2 = type
    L12_2 = GroupMembers
    L11_2 = L11_2(L12_2)
    if "function" == L11_2 then
      L11_2 = pcall
      L12_2 = GroupMembers
      L13_2 = A1_2
      L11_2, L12_2 = L11_2(L12_2, L13_2)
      L13_2 = ipairs
      if L11_2 then
        L14_2 = type
        L15_2 = L12_2
        L14_2 = L14_2(L15_2)
        if "table" == L14_2 and L12_2 then
          goto lbl_129
          L14_2 = L12_2 or L14_2
        end
      end
      L14_2 = {}
      ::lbl_129::
      L13_2, L14_2, L15_2, L16_2 = L13_2(L14_2)
      for L17_2, L18_2 in L13_2, L14_2, L15_2, L16_2 do
        if L18_2 ~= L10_2 then
          L19_2 = L23_1
          L20_2 = L7_2.app
          if not L20_2 then
            L20_2 = "sms"
          end
          L21_2 = L18_2
          L19_2 = L19_2(L20_2, L21_2)
          if L19_2 and L19_2 ~= A0_2 then
            L20_2 = HasPhoneItem
            if L20_2 then
              L20_2 = HasPhoneItem
              L21_2 = L19_2
              L20_2 = L20_2(L21_2)
              if not L20_2 then
                goto lbl_172
              end
            end
            L20_2 = tonumber
            L21_2 = L7_2.created
            L20_2 = L20_2(L21_2)
            if not L20_2 then
              L20_2 = Now
              L20_2 = L20_2()
            end
            L21_2 = MySQL
            L21_2 = L21_2.update
            L22_2 = "UPDATE apex_phone_messages SET delivered_at = ? WHERE id = ? AND delivered_at IS NULL"
            L23_2 = {}
            L24_2 = L20_2
            L25_2 = L9_2
            L23_2[1] = L24_2
            L23_2[2] = L25_2
            L21_2(L22_2, L23_2)
            L21_2 = "delivered"
            L7_2.deliveredAt = L20_2
            L7_2.status = L21_2
            break
          end
        end
        ::lbl_172::
      end
    end
  end
  L11_2 = {}
  L12_2 = pairs
  L13_2 = L7_2
  L12_2, L13_2, L14_2, L15_2 = L12_2(L13_2)
  for L16_2, L17_2 in L12_2, L13_2, L14_2, L15_2 do
    L11_2[L16_2] = L17_2
  end
  L11_2.read = true
  return L11_2
end
function L59_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2
  if not A0_2 or not A1_2 then
    L2_2 = false
    return L2_2
  end
  L2_2 = pcall
  L3_2 = MySQL
  L3_2 = L3_2.scalar
  L3_2 = L3_2.await
  L4_2 = "SELECT id FROM apex_phone_matches WHERE (a = ? AND b = ?) OR (a = ? AND b = ?) LIMIT 1"
  L5_2 = {}
  L6_2 = A0_2
  L7_2 = A1_2
  L8_2 = A1_2
  L9_2 = A0_2
  L5_2[1] = L6_2
  L5_2[2] = L7_2
  L5_2[3] = L8_2
  L5_2[4] = L9_2
  L2_2, L3_2 = L2_2(L3_2, L4_2, L5_2)
  L4_2 = L2_2 or L4_2
  L4_2 = L2_2 and nil ~= L3_2
  return L4_2
end
L60_1 = RPC
function L61_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2, L19_2, L20_2, L21_2, L22_2, L23_2
  L2_2 = L56_1
  L3_2 = A1_2.type
  L2_2 = L2_2(L3_2)
  if not L2_2 then
    L3_2 = {}
    L3_2.error = "badtype"
    return L3_2
  end
  L3_2 = nil
  L4_2 = A1_2.conversation
  if nil ~= L4_2 then
    L4_2 = L1_1
    L5_2 = A1_2.conversation
    L4_2 = L4_2(L5_2)
    if L4_2 then
      goto lbl_22
    end
  end
  L4_2 = L10_1
  L5_2 = A1_2.to
  L4_2 = L4_2(L5_2)
  ::lbl_22::
  if L4_2 then
    L5_2 = L36_1
    L6_2 = L4_2
    L5_2 = L5_2(L6_2)
    L3_2 = L5_2
  end
  L4_2 = L3_2 or L4_2
  if not L3_2 then
    L4_2 = L6_1
    L5_2 = A1_2
    L4_2 = L4_2(L5_2)
  end
  if "recado" == L4_2 then
    L5_2 = L7_1
    L6_2 = A1_2
    L5_2 = L5_2(L6_2)
    if not L5_2 then
      L5_2 = {}
      L5_2.error = "unsupported"
      return L5_2
    end
  end
  L5_2 = L0_1
  L5_2 = L5_2[L4_2]
  if L5_2 then
    L5_2 = RequireLine
    if L5_2 then
      L5_2 = RequireLine
      L6_2 = A0_2
      L5_2 = L5_2(L6_2)
      if L5_2 then
        return L5_2
      end
    end
  end
  L5_2 = type
  L6_2 = A1_2.content
  L5_2 = L5_2(L6_2)
  if "string" ~= L5_2 then
    L5_2 = type
    L6_2 = A1_2.content
    L5_2 = L5_2(L6_2)
    if "number" ~= L5_2 then
      goto lbl_75
    end
  end
  L5_2 = L3_1
  L6_2 = A1_2.content
  L7_2 = L8_1
  L8_2 = L4_2
  L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2, L19_2, L20_2, L21_2, L22_2, L23_2 = L7_2(L8_2)
  L5_2 = L5_2(L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2, L19_2, L20_2, L21_2, L22_2, L23_2)
  ::lbl_75::
  if not L5_2 then
    L5_2 = ""
  end
  L6_2 = type
  L7_2 = A1_2.payload
  L6_2 = L6_2(L7_2)
  if "table" == L6_2 then
    L6_2 = A1_2.payload
    if L6_2 then
      goto lbl_85
    end
  end
  L6_2 = nil
  ::lbl_85::
  L7_2 = nil
  L8_2 = A1_2.replyTo
  if nil ~= L8_2 then
    L8_2 = L1_1
    L9_2 = A1_2.replyTo
    L8_2 = L8_2(L9_2)
    L7_2 = L8_2
    if not L7_2 then
      L8_2 = {}
      L8_2.error = "badreply"
      return L8_2
    end
  end
  L8_2 = nil
  L9_2 = L57_1
  L10_2 = A0_2
  L11_2 = L2_2
  L12_2 = L6_2
  L13_2 = A1_2
  L9_2, L10_2 = L9_2(L10_2, L11_2, L12_2, L13_2)
  L8_2 = L10_2
  L6_2 = L9_2
  if L8_2 then
    L9_2 = {}
    L9_2.error = L8_2
    return L9_2
  end
  if L6_2 then
    L9_2 = pcall
    L10_2 = json
    L10_2 = L10_2.encode
    L11_2 = L6_2
    L9_2, L10_2 = L9_2(L10_2, L11_2)
    if L9_2 then
      L11_2 = #L10_2
      L12_2 = math
      L12_2 = L12_2.max
      L13_2 = tonumber
      L14_2 = Config
      L14_2 = L14_2.PhotoMaxBytes
      L13_2 = L13_2(L14_2)
      if not L13_2 then
        L13_2 = 260000
      end
      L14_2 = 300000
      L12_2 = L12_2(L13_2, L14_2)
      L12_2 = L12_2 + 65536
      if not (L11_2 > L12_2) then
        goto lbl_143
      end
    end
    L11_2 = {}
    L11_2.error = "toolarge"
    return L11_2
  end
  ::lbl_143::
  L9_2 = nil
  L10_2 = A1_2.conversation
  if nil ~= L10_2 then
    L10_2 = L1_1
    L11_2 = A1_2.conversation
    L10_2 = L10_2(L11_2)
    L9_2 = L10_2
    if not L9_2 then
      L10_2 = {}
      L10_2.error = "target"
      return L10_2
    end
  else
    L10_2 = L10_1
    L11_2 = A1_2.to
    L10_2 = L10_2(L11_2)
    L9_2 = L10_2
  end
  if L9_2 then
    L10_2 = L58_1
    L11_2 = A0_2
    L12_2 = L9_2
    L13_2 = L2_2
    L14_2 = L5_2
    L15_2 = L6_2
    L16_2 = L7_2
    return L10_2(L11_2, L12_2, L13_2, L14_2, L15_2, L16_2)
  end
  L10_2 = L6_1
  L11_2 = A1_2
  L10_2 = L10_2(L11_2)
  L11_2 = L21_1
  L12_2 = A0_2
  L13_2 = L10_2
  L11_2 = L11_2(L12_2, L13_2)
  if not L11_2 then
    L12_2 = {}
    L12_2.error = "noidentity"
    return L12_2
  end
  L12_2 = type
  L13_2 = A1_2.to
  L12_2 = L12_2(L13_2)
  if "string" ~= L12_2 then
    L12_2 = type
    L13_2 = A1_2.to
    L12_2 = L12_2(L13_2)
    if "number" ~= L12_2 then
      goto lbl_205
    end
  end
  L12_2 = tostring
  L13_2 = A1_2.to
  L12_2 = L12_2(L13_2)
  L13_2 = L12_2
  L12_2 = L12_2.sub
  L14_2 = 1
  L15_2 = 40
  L12_2 = L12_2(L13_2, L14_2, L15_2)
  ::lbl_205::
  if not L12_2 then
    L12_2 = ""
  end
  if "" == L12_2 then
    L13_2 = {}
    L13_2.error = "target"
    return L13_2
  end
  L13_2 = L5_1
  L14_2 = L10_2
  L15_2 = L12_2
  L13_2 = L13_2(L14_2, L15_2)
  L12_2 = L13_2
  L13_2 = L18_1
  L14_2 = A0_2
  L13_2(L14_2)
  L13_2 = nil
  if L7_2 then
    L14_2 = MySQL
    L14_2 = L14_2.single
    L14_2 = L14_2.await
    L15_2 = [[
SELECT id, sender, type, content, deleted_all FROM apex_phone_messages
            WHERE id = ? AND app = ? AND conversation_id IS NULL AND ((sender = ? AND receiver = ?) OR (sender = ? AND receiver = ?))]]
    L16_2 = {}
    L17_2 = L7_2
    L18_2 = L10_2
    L19_2 = L11_2
    L20_2 = L12_2
    L21_2 = L12_2
    L22_2 = L11_2
    L16_2[1] = L17_2
    L16_2[2] = L18_2
    L16_2[3] = L19_2
    L16_2[4] = L20_2
    L16_2[5] = L21_2
    L16_2[6] = L22_2
    L14_2 = L14_2(L15_2, L16_2)
    if not L14_2 then
      L15_2 = {}
      L15_2.error = "badreply"
      return L15_2
    end
    L15_2 = L46_1
    L16_2 = L14_2
    L15_2 = L15_2(L16_2)
    L13_2 = L15_2
  end
  L14_2 = false
  L15_2 = L0_1
  L15_2 = L15_2[L10_2]
  if L15_2 and L12_2 ~= L11_2 then
    L15_2 = GetCid
    L16_2 = A0_2
    L15_2 = L15_2(L16_2)
    if L15_2 then
      L16_2 = IsBlocked
      L17_2 = L15_2
      L18_2 = L12_2
      L16_2 = L16_2(L17_2, L18_2)
      if L16_2 then
        L16_2 = {}
        L16_2.error = "blocked"
        return L16_2
      end
    end
    L16_2 = L33_1
    L17_2 = L10_2
    L18_2 = L12_2
    L16_2 = L16_2(L17_2, L18_2)
    if "match" == L10_2 then
      L17_2 = L59_1
      L18_2 = L15_2
      L19_2 = L16_2
      L17_2 = L17_2(L18_2, L19_2)
      if not L17_2 then
        L17_2 = {}
        L17_2.error = "nomatch"
        return L17_2
      end
    end
    L17_2 = IsBlocked
    L18_2 = L16_2
    L19_2 = L11_2
    L17_2 = L17_2(L18_2, L19_2)
    L14_2 = nil ~= L16_2 and L14_2
  end
  L15_2 = SendMessageInternal
  L16_2 = L10_2
  L17_2 = L11_2
  L18_2 = L12_2
  L19_2 = L2_2
  L20_2 = L5_2
  L21_2 = L6_2
  L22_2 = A0_2
  L23_2 = {}
  L23_2.replyTo = L7_2
  L23_2.reply = L13_2
  L23_2.hidden = L14_2
  L15_2 = L15_2(L16_2, L17_2, L18_2, L19_2, L20_2, L21_2, L22_2, L23_2)
  L16_2 = {}
  L17_2 = pairs
  L18_2 = L15_2
  L17_2, L18_2, L19_2, L20_2 = L17_2(L18_2)
  for L21_2, L22_2 in L17_2, L18_2, L19_2, L20_2 do
    L16_2[L21_2] = L22_2
  end
  L16_2.read = true
  return L16_2
end
L60_1["messages.send"] = L61_1
function L60_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2
  L2_2 = L1_1
  L3_2 = A1_2
  L2_2 = L2_2(L3_2)
  if not L2_2 then
    L3_2 = nil
    L4_2 = nil
    L5_2 = "notfound"
    return L3_2, L4_2, L5_2
  end
  L3_2 = MySQL
  L3_2 = L3_2.single
  L3_2 = L3_2.await
  L4_2 = "SELECT id, app, sender, receiver, type, content, created, conversation_id, deleted_all, deleted_sender, deleted_receiver FROM apex_phone_messages WHERE id = ?"
  L5_2 = {}
  L6_2 = L2_2
  L5_2[1] = L6_2
  L3_2 = L3_2(L4_2, L5_2)
  if not L3_2 then
    L4_2 = nil
    L5_2 = nil
    L6_2 = "notfound"
    return L4_2, L5_2, L6_2
  end
  L3_2.id = L2_2
  L4_2 = L21_1
  L5_2 = A0_2
  L6_2 = L3_2.app
  L4_2 = L4_2(L5_2, L6_2)
  if not L4_2 then
    L5_2 = nil
    L6_2 = nil
    L7_2 = "notfound"
    return L5_2, L6_2, L7_2
  end
  L5_2 = L1_1
  L6_2 = L3_2.conversation_id
  L5_2 = L5_2(L6_2)
  if L5_2 then
    L6_2 = L37_1
    L7_2 = L5_2
    L8_2 = L4_2
    L6_2 = L6_2(L7_2, L8_2)
    if not L6_2 then
      L6_2 = nil
      L7_2 = nil
      L8_2 = "notfound"
      return L6_2, L7_2, L8_2
    end
    L6_2 = L38_1
    L7_2 = L5_2
    L8_2 = L4_2
    L6_2 = L6_2(L7_2, L8_2)
    if L6_2 then
      L7_2 = tonumber
      L8_2 = L3_2.created
      L7_2 = L7_2(L8_2)
      if not L7_2 then
        L7_2 = 0
      end
      if L6_2 > L7_2 then
        L7_2 = nil
        L8_2 = nil
        L9_2 = "notfound"
        return L7_2, L8_2, L9_2
      end
    end
  else
    L6_2 = L3_2.sender
    if L6_2 ~= L4_2 then
      L6_2 = L3_2.receiver
      if L6_2 ~= L4_2 then
        L6_2 = nil
        L7_2 = nil
        L8_2 = "notfound"
        return L6_2, L7_2, L8_2
      end
    end
    L6_2 = L3_2.sender
    if L6_2 ~= L4_2 then
      L6_2 = tonumber
      L7_2 = L3_2.deleted_receiver
      L6_2 = L6_2(L7_2)
      if 1 == L6_2 then
        L6_2 = nil
        L7_2 = nil
        L8_2 = "notfound"
        return L6_2, L7_2, L8_2
      end
    end
  end
  L6_2 = L3_2
  L7_2 = L4_2
  return L6_2, L7_2
end
function L61_1(A0_2, A1_2, A2_2, A3_2, A4_2)
  local L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2
  L5_2 = L1_1
  L6_2 = A1_2.conversation_id
  L5_2 = L5_2(L6_2)
  if L5_2 then
    L6_2 = L40_1
    L7_2 = L5_2
    L8_2 = A1_2.app
    L9_2 = A3_2
    L10_2 = A4_2
    L11_2 = A2_2
    L12_2 = A0_2
    return L6_2(L7_2, L8_2, L9_2, L10_2, L11_2, L12_2)
  end
  L6_2 = A1_2.sender
  if L6_2 == A2_2 then
    L6_2 = A1_2.receiver
    if L6_2 then
      goto lbl_22
    end
  end
  L6_2 = A1_2.sender
  ::lbl_22::
  if L6_2 == A2_2 then
    L7_2 = 0
    return L7_2
  end
  L7_2 = A1_2.receiver
  if L6_2 == L7_2 then
    L7_2 = tonumber
    L8_2 = A1_2.deleted_receiver
    L7_2 = L7_2(L8_2)
    if 1 == L7_2 then
      L7_2 = 0
      return L7_2
    end
  end
  L7_2 = L22_1
  L8_2 = A1_2.app
  L9_2 = L6_2
  L7_2 = L7_2(L8_2, L9_2)
  if not L7_2 or L7_2 == A0_2 then
    L8_2 = 0
    return L8_2
  end
  if "messageReaction" == A3_2 then
    L9_2 = A1_2.app
    L8_2 = L0_1
    L8_2 = L8_2[L9_2]
    if L8_2 then
      L8_2 = IsBlocked
      L9_2 = GetCid
      L10_2 = L7_2
      L9_2 = L9_2(L10_2)
      L10_2 = A2_2
      L8_2 = L8_2(L9_2, L10_2)
      if L8_2 then
        L8_2 = 0
        return L8_2
      end
    end
  end
  L8_2 = Push
  L9_2 = L7_2
  L10_2 = A3_2
  L11_2 = A4_2
  L8_2(L9_2, L10_2, L11_2)
  L8_2 = 1
  return L8_2
end
L62_1 = RPC
function L63_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2
  L2_2 = A1_2.scope
  if nil ~= L2_2 and "me" ~= L2_2 and "all" ~= L2_2 then
    L3_2 = {}
    L3_2.ok = false
    L3_2.error = "badscope"
    return L3_2
  end
  L3_2 = L60_1
  L4_2 = A0_2
  L5_2 = A1_2.id
  L3_2, L4_2, L5_2 = L3_2(L4_2, L5_2)
  if not L3_2 then
    L6_2 = {}
    L6_2.ok = false
    L6_2.error = L5_2
    return L6_2
  end
  L6_2 = L1_1
  L7_2 = L3_2.conversation_id
  L6_2 = L6_2(L7_2)
  L7_2 = L3_2.type
  if "system" == L7_2 and "me" ~= L2_2 then
    L7_2 = {}
    L7_2.ok = false
    L7_2.error = "unsupported"
    return L7_2
  end
  if nil == L2_2 then
    L7_2 = L3_2.sender
    if L7_2 ~= L4_2 then
      L7_2 = {}
      L7_2.ok = false
      L7_2.error = "notsender"
      return L7_2
    end
    L7_2 = MySQL
    L7_2 = L7_2.query
    L7_2 = L7_2.await
    L8_2 = "DELETE FROM apex_phone_messages WHERE id = ? AND sender = ?"
    L9_2 = {}
    L10_2 = L3_2.id
    L11_2 = L4_2
    L9_2[1] = L10_2
    L9_2[2] = L11_2
    L7_2(L8_2, L9_2)
    L7_2 = MySQL
    L7_2 = L7_2.query
    L8_2 = "DELETE FROM apex_phone_message_reactions WHERE message_id = ?"
    L9_2 = {}
    L10_2 = L3_2.id
    L9_2[1] = L10_2
    L7_2(L8_2, L9_2)
    L7_2 = L61_1
    L8_2 = A0_2
    L9_2 = L3_2
    L10_2 = L4_2
    L11_2 = "messageDeleted"
    L12_2 = {}
    L13_2 = L3_2.id
    L12_2.id = L13_2
    L13_2 = L3_2.app
    L12_2.app = L13_2
    L12_2.number = L4_2
    L12_2.conversation = L6_2
    L7_2(L8_2, L9_2, L10_2, L11_2, L12_2)
    L7_2 = {}
    L7_2.ok = true
    return L7_2
  end
  if "all" == L2_2 then
    L7_2 = L3_2.sender
    if L7_2 ~= L4_2 then
      L7_2 = {}
      L7_2.ok = false
      L7_2.error = "notsender"
      return L7_2
    end
    L7_2 = L3_2.deleted_all
    if nil ~= L7_2 then
      L7_2 = {}
      L7_2.ok = true
      L7_2.deleted = true
      return L7_2
    end
    L7_2 = Now
    L7_2 = L7_2()
    L8_2 = tonumber
    L9_2 = L3_2.created
    L8_2 = L8_2(L9_2)
    if not L8_2 then
      L8_2 = 0
    end
    L7_2 = L7_2 - L8_2
    L8_2 = L12_1
    L8_2 = L8_2()
    L8_2 = L8_2.deleteMs
    if L7_2 > L8_2 then
      L7_2 = {}
      L7_2.ok = false
      L7_2.error = "window"
      return L7_2
    end
    L7_2 = Now
    L7_2 = L7_2()
    L8_2 = MySQL
    L8_2 = L8_2.update
    L8_2 = L8_2.await
    L9_2 = "UPDATE apex_phone_messages SET content = ?, payload = NULL, deleted_all = ? WHERE id = ? AND sender = ?"
    L10_2 = {}
    L11_2 = ""
    L12_2 = L7_2
    L13_2 = L3_2.id
    L14_2 = L4_2
    L10_2[1] = L11_2
    L10_2[2] = L12_2
    L10_2[3] = L13_2
    L10_2[4] = L14_2
    L8_2(L9_2, L10_2)
    L8_2 = MySQL
    L8_2 = L8_2.query
    L9_2 = "DELETE FROM apex_phone_message_reactions WHERE message_id = ?"
    L10_2 = {}
    L11_2 = L3_2.id
    L10_2[1] = L11_2
    L8_2(L9_2, L10_2)
    L8_2 = L61_1
    L9_2 = A0_2
    L10_2 = L3_2
    L11_2 = L4_2
    L12_2 = "messageUpdate"
    L13_2 = {}
    L14_2 = L3_2.id
    L13_2.id = L14_2
    L14_2 = L3_2.app
    L13_2.app = L14_2
    L13_2.number = L4_2
    L13_2.conversation = L6_2
    L13_2.deleted = true
    L13_2.deletedAt = L7_2
    L8_2(L9_2, L10_2, L11_2, L12_2, L13_2)
    L8_2 = {}
    L8_2.ok = true
    L8_2.deleted = true
    return L8_2
  end
  if L6_2 then
    L7_2 = L3_2.sender
    if L7_2 ~= L4_2 then
      L7_2 = {}
      L7_2.ok = false
      L7_2.error = "unsupported"
      return L7_2
    end
    L7_2 = MySQL
    L7_2 = L7_2.update
    L7_2 = L7_2.await
    L8_2 = "UPDATE apex_phone_messages SET deleted_sender = 1 WHERE id = ? AND sender = ?"
    L9_2 = {}
    L10_2 = L3_2.id
    L11_2 = L4_2
    L9_2[1] = L10_2
    L9_2[2] = L11_2
    L7_2(L8_2, L9_2)
    L7_2 = {}
    L7_2.ok = true
    return L7_2
  end
  L7_2 = L3_2.sender
  if L7_2 == L4_2 then
    L7_2 = MySQL
    L7_2 = L7_2.update
    L7_2 = L7_2.await
    L8_2 = "UPDATE apex_phone_messages SET deleted_sender = 1 WHERE id = ? AND sender = ?"
    L9_2 = {}
    L10_2 = L3_2.id
    L11_2 = L4_2
    L9_2[1] = L10_2
    L9_2[2] = L11_2
    L7_2(L8_2, L9_2)
  end
  L7_2 = L3_2.receiver
  if L7_2 == L4_2 then
    L7_2 = MySQL
    L7_2 = L7_2.update
    L7_2 = L7_2.await
    L8_2 = "UPDATE apex_phone_messages SET deleted_receiver = 1 WHERE id = ? AND receiver = ?"
    L9_2 = {}
    L10_2 = L3_2.id
    L11_2 = L4_2
    L9_2[1] = L10_2
    L9_2[2] = L11_2
    L7_2(L8_2, L9_2)
  end
  L7_2 = {}
  L7_2.ok = true
  return L7_2
end
L62_1["messages.delete"] = L63_1
L62_1 = RPC
function L63_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2
  L2_2 = L60_1
  L3_2 = A0_2
  L4_2 = A1_2.id
  L2_2, L3_2, L4_2 = L2_2(L3_2, L4_2)
  if not L2_2 then
    L5_2 = {}
    L5_2.ok = false
    L5_2.error = L4_2
    return L5_2
  end
  L5_2 = L2_2.sender
  if L5_2 ~= L3_2 then
    L5_2 = {}
    L5_2.ok = false
    L5_2.error = "notsender"
    return L5_2
  end
  L5_2 = L2_2.deleted_all
  if nil ~= L5_2 then
    L5_2 = {}
    L5_2.ok = false
    L5_2.error = "deleted"
    return L5_2
  end
  L5_2 = L2_2.type
  if not L5_2 then
    L5_2 = "text"
  end
  if "text" ~= L5_2 then
    L5_2 = {}
    L5_2.ok = false
    L5_2.error = "nottext"
    return L5_2
  end
  L5_2 = Now
  L5_2 = L5_2()
  L6_2 = tonumber
  L7_2 = L2_2.created
  L6_2 = L6_2(L7_2)
  if not L6_2 then
    L6_2 = 0
  end
  L5_2 = L5_2 - L6_2
  L6_2 = L12_1
  L6_2 = L6_2()
  L6_2 = L6_2.editMs
  if L5_2 > L6_2 then
    L5_2 = {}
    L5_2.ok = false
    L5_2.error = "window"
    return L5_2
  end
  L5_2 = type
  L6_2 = A1_2.content
  L5_2 = L5_2(L6_2)
  if "string" ~= L5_2 then
    L5_2 = type
    L6_2 = A1_2.content
    L5_2 = L5_2(L6_2)
    if "number" ~= L5_2 then
      L5_2 = {}
      L5_2.ok = false
      L5_2.error = "empty"
      return L5_2
    end
  end
  L5_2 = L3_1
  L6_2 = tostring
  L7_2 = A1_2.content
  L6_2 = L6_2(L7_2)
  L7_2 = L6_2
  L6_2 = L6_2.match
  L8_2 = "^%s*(.-)%s*$"
  L6_2 = L6_2(L7_2, L8_2)
  L7_2 = L8_1
  L8_2 = L2_2.app
  L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2 = L7_2(L8_2)
  L5_2 = L5_2(L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2)
  if "" == L5_2 then
    L6_2 = {}
    L6_2.ok = false
    L6_2.error = "empty"
    return L6_2
  end
  L6_2 = L2_2.content
  if L5_2 == L6_2 then
    L6_2 = {}
    L6_2.ok = true
    L7_2 = L2_2.id
    L6_2.id = L7_2
    L6_2.content = L5_2
    return L6_2
  end
  L6_2 = Now
  L6_2 = L6_2()
  L7_2 = MySQL
  L7_2 = L7_2.update
  L7_2 = L7_2.await
  L8_2 = "UPDATE apex_phone_messages SET content = ?, edited_at = ? WHERE id = ? AND sender = ? AND deleted_all IS NULL"
  L9_2 = {}
  L10_2 = L5_2
  L11_2 = L6_2
  L12_2 = L2_2.id
  L13_2 = L3_2
  L9_2[1] = L10_2
  L9_2[2] = L11_2
  L9_2[3] = L12_2
  L9_2[4] = L13_2
  L7_2(L8_2, L9_2)
  L7_2 = L61_1
  L8_2 = A0_2
  L9_2 = L2_2
  L10_2 = L3_2
  L11_2 = "messageUpdate"
  L12_2 = {}
  L13_2 = L2_2.id
  L12_2.id = L13_2
  L13_2 = L2_2.app
  L12_2.app = L13_2
  L12_2.number = L3_2
  L13_2 = L1_1
  L14_2 = L2_2.conversation_id
  L13_2 = L13_2(L14_2)
  L12_2.conversation = L13_2
  L12_2.content = L5_2
  L12_2.editedAt = L6_2
  L7_2(L8_2, L9_2, L10_2, L11_2, L12_2)
  L7_2 = {}
  L7_2.ok = true
  L8_2 = L2_2.id
  L7_2.id = L8_2
  L7_2.content = L5_2
  L7_2.editedAt = L6_2
  return L7_2
end
L62_1["messages.edit"] = L63_1
L62_1 = nil
function L63_1(A0_2)
  local L1_2, L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2
  L1_2 = type
  L2_2 = A0_2
  L1_2 = L1_2(L2_2)
  if "string" ~= L1_2 then
    L1_2 = nil
    return L1_2
  end
  L1_2 = L62_1
  if not L1_2 then
    L1_2 = {}
    L62_1 = L1_2
    L1_2 = type
    L2_2 = Config
    L2_2 = L2_2.Messages
    L1_2 = L1_2(L2_2)
    if "table" == L1_2 then
      L1_2 = type
      L2_2 = Config
      L2_2 = L2_2.Messages
      L2_2 = L2_2.reactions
      L1_2 = L1_2(L2_2)
      if "table" == L1_2 then
        L1_2 = Config
        L1_2 = L1_2.Messages
        L1_2 = L1_2.reactions
        if L1_2 then
          goto lbl_41
        end
      end
    end
    L1_2 = {}
    L2_2 = "\226\157\164\239\184\143"
    L3_2 = "\240\159\145\141"
    L4_2 = "\240\159\152\130"
    L5_2 = "\240\159\152\174"
    L6_2 = "\240\159\152\162"
    L7_2 = "\240\159\153\143"
    L1_2[1] = L2_2
    L1_2[2] = L3_2
    L1_2[3] = L4_2
    L1_2[4] = L5_2
    L1_2[5] = L6_2
    L1_2[6] = L7_2
    ::lbl_41::
    L2_2 = ipairs
    L3_2 = L1_2
    L2_2, L3_2, L4_2, L5_2 = L2_2(L3_2)
    for L6_2, L7_2 in L2_2, L3_2, L4_2, L5_2 do
      L8_2 = type
      L9_2 = L7_2
      L8_2 = L8_2(L9_2)
      if "string" == L8_2 and "" ~= L7_2 then
        L8_2 = L62_1
        L8_2[L7_2] = L7_2
        L9_2 = L7_2
        L8_2 = L7_2.gsub
        L10_2 = "\239\184\143"
        L11_2 = ""
        L8_2 = L8_2(L9_2, L10_2, L11_2)
        if "" ~= L8_2 then
          L9_2 = L62_1
          L9_2[L8_2] = L7_2
        end
      end
    end
  end
  L1_2 = L62_1
  L1_2 = L1_2[A0_2]
  return L1_2
end
function L64_1(A0_2)
  local L1_2, L2_2, L3_2, L4_2
  L1_2 = L63_1
  L2_2 = A0_2
  L1_2 = L1_2(L2_2)
  if L1_2 then
    return L1_2
  end
  L2_2 = type
  L3_2 = A0_2
  L2_2 = L2_2(L3_2)
  if "string" == L2_2 then
    L2_2 = #A0_2
    if not (L2_2 < 2) then
      L2_2 = #A0_2
      if not (L2_2 > 28) then
        L2_2 = utf8
        L2_2 = L2_2.len
        L3_2 = A0_2
        L2_2 = L2_2(L3_2)
        if L2_2 then
          L2_2 = utf8
          L2_2 = L2_2.len
          L3_2 = A0_2
          L2_2 = L2_2(L3_2)
          if not (L2_2 > 16) then
            goto lbl_32
          end
        end
      end
    end
  end
  L2_2 = nil
  do return L2_2 end
  ::lbl_32::
  L3_2 = A0_2
  L2_2 = A0_2.match
  L4_2 = "^[\128-\255]+$"
  L2_2 = L2_2(L3_2, L4_2)
  if not L2_2 then
    L2_2 = nil
    return L2_2
  end
  return A0_2
end
L65_1 = RPC
function L66_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2
  L2_2 = L60_1
  L3_2 = A0_2
  L4_2 = A1_2.id
  L2_2, L3_2, L4_2 = L2_2(L3_2, L4_2)
  if not L2_2 then
    L5_2 = {}
    L5_2.ok = false
    L5_2.error = L4_2
    return L5_2
  end
  L5_2 = L2_2.deleted_all
  if nil ~= L5_2 then
    L5_2 = {}
    L5_2.ok = false
    L5_2.error = "deleted"
    return L5_2
  end
  L5_2 = nil
  L6_2 = A1_2.emoji
  if nil ~= L6_2 then
    L6_2 = A1_2.emoji
    if false ~= L6_2 then
      L6_2 = A1_2.emoji
      if "" ~= L6_2 then
        L6_2 = L2_2.app
        if "recado" == L6_2 then
          L6_2 = L64_1
          L7_2 = A1_2.emoji
          L6_2 = L6_2(L7_2)
          if L6_2 then
            goto lbl_42
            L5_2 = L6_2 or L5_2
          end
        end
        L6_2 = L63_1
        L7_2 = A1_2.emoji
        L6_2 = L6_2(L7_2)
        L5_2 = L6_2
        ::lbl_42::
        if not L5_2 then
          L6_2 = {}
          L6_2.ok = false
          L6_2.error = "badreaction"
          return L6_2
        end
      end
    end
  end
  if L5_2 then
    L6_2 = MySQL
    L6_2 = L6_2.query
    L6_2 = L6_2.await
    L7_2 = "INSERT INTO apex_phone_message_reactions (message_id, who, emoji, created) VALUES (?, ?, ?, ?) ON DUPLICATE KEY UPDATE emoji = VALUES(emoji), created = VALUES(created)"
    L8_2 = {}
    L9_2 = L2_2.id
    L10_2 = L3_2
    L11_2 = L5_2
    L12_2 = Now
    L12_2, L13_2, L14_2 = L12_2()
    L8_2[1] = L9_2
    L8_2[2] = L10_2
    L8_2[3] = L11_2
    L8_2[4] = L12_2
    L8_2[5] = L13_2
    L8_2[6] = L14_2
    L6_2(L7_2, L8_2)
  else
    L6_2 = MySQL
    L6_2 = L6_2.query
    L6_2 = L6_2.await
    L7_2 = "DELETE FROM apex_phone_message_reactions WHERE message_id = ? AND who = ?"
    L8_2 = {}
    L9_2 = L2_2.id
    L10_2 = L3_2
    L8_2[1] = L9_2
    L8_2[2] = L10_2
    L6_2(L7_2, L8_2)
  end
  L6_2 = L47_1
  L7_2 = {}
  L8_2 = L2_2.id
  L7_2[1] = L8_2
  L6_2 = L6_2(L7_2)
  L7_2 = L2_2.id
  L6_2 = L6_2[L7_2]
  L7_2 = L1_1
  L8_2 = L2_2.conversation_id
  L7_2 = L7_2(L8_2)
  L8_2 = L61_1
  L9_2 = A0_2
  L10_2 = L2_2
  L11_2 = L3_2
  L12_2 = "messageReaction"
  L13_2 = {}
  L14_2 = L2_2.id
  L13_2.id = L14_2
  L14_2 = L2_2.app
  L13_2.app = L14_2
  L13_2.number = L3_2
  L13_2.conversation = L7_2
  L13_2.reactions = L6_2
  L8_2(L9_2, L10_2, L11_2, L12_2, L13_2)
  if L6_2 then
    L8_2 = ipairs
    L9_2 = L6_2
    L8_2, L9_2, L10_2, L11_2 = L8_2(L9_2)
    for L12_2, L13_2 in L8_2, L9_2, L10_2, L11_2 do
      L14_2 = L13_2.who
      L14_2 = L14_2 == L3_2
      L13_2.mine = L14_2
    end
  end
  L8_2 = {}
  L8_2.ok = true
  L9_2 = L2_2.id
  L8_2.id = L9_2
  L8_2.reactions = L6_2
  return L8_2
end
L65_1["messages.react"] = L66_1
L65_1 = RPC
function L66_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2, L19_2, L20_2, L21_2, L22_2, L23_2, L24_2
  L2_2 = L11_1
  L3_2 = A1_2
  L2_2 = L2_2(L3_2)
  if nil ~= L2_2 then
    L2_2 = L41_1
    L3_2 = A0_2
    L4_2 = A1_2
    L2_2 = L2_2(L3_2, L4_2)
    if not L2_2 then
      L3_2 = {}
      L3_2.ok = false
      return L3_2
    end
    L3_2 = L2_2.conv
    L4_2 = L1_1
    L5_2 = MySQL
    L5_2 = L5_2.scalar
    L5_2 = L5_2.await
    L6_2 = "SELECT MAX(id) FROM apex_phone_messages WHERE conversation_id = ?"
    L7_2 = {}
    L8_2 = L3_2
    L7_2[1] = L8_2
    L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2, L19_2, L20_2, L21_2, L22_2, L23_2, L24_2 = L5_2(L6_2, L7_2)
    L4_2 = L4_2(L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2, L19_2, L20_2, L21_2, L22_2, L23_2, L24_2)
    if not L4_2 then
      L5_2 = {}
      L5_2.ok = true
      return L5_2
    end
    L5_2 = math
    L5_2 = L5_2.tointeger
    L6_2 = tonumber
    L7_2 = MySQL
    L7_2 = L7_2.scalar
    L7_2 = L7_2.await
    L8_2 = "SELECT last_read_id FROM apex_phone_conversation_members WHERE conversation_id = ? AND member = ?"
    L9_2 = {}
    L10_2 = L3_2
    L11_2 = L2_2.me
    L9_2[1] = L10_2
    L9_2[2] = L11_2
    L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2, L19_2, L20_2, L21_2, L22_2, L23_2, L24_2 = L7_2(L8_2, L9_2)
    L6_2 = L6_2(L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2, L19_2, L20_2, L21_2, L22_2, L23_2, L24_2)
    if not L6_2 then
      L6_2 = 0
    end
    L5_2 = L5_2(L6_2)
    if not L5_2 then
      L5_2 = 0
    end
    if L4_2 <= L5_2 then
      L6_2 = {}
      L6_2.ok = true
      return L6_2
    end
    L6_2 = MySQL
    L6_2 = L6_2.update
    L6_2 = L6_2.await
    L7_2 = "UPDATE apex_phone_conversation_members SET last_read_id = ? WHERE conversation_id = ? AND member = ? AND (last_read_id IS NULL OR last_read_id < ?)"
    L8_2 = {}
    L9_2 = L4_2
    L10_2 = L3_2
    L11_2 = L2_2.me
    L12_2 = L4_2
    L8_2[1] = L9_2
    L8_2[2] = L10_2
    L8_2[3] = L11_2
    L8_2[4] = L12_2
    L6_2(L7_2, L8_2)
    L6_2 = MySQL
    L6_2 = L6_2.query
    L6_2 = L6_2.await
    L7_2 = "SELECT id FROM apex_phone_messages WHERE conversation_id = ? AND id > ? AND id <= ? AND sender <> ? ORDER BY id DESC LIMIT 200"
    L8_2 = {}
    L9_2 = L3_2
    L10_2 = L5_2
    L11_2 = L4_2
    L12_2 = L2_2.me
    L8_2[1] = L9_2
    L8_2[2] = L10_2
    L8_2[3] = L11_2
    L8_2[4] = L12_2
    L6_2 = L6_2(L7_2, L8_2)
    if not L6_2 then
      L6_2 = {}
    end
    L7_2 = #L6_2
    if L7_2 > 0 then
      L7_2 = {}
      L8_2 = ipairs
      L9_2 = L6_2
      L8_2, L9_2, L10_2, L11_2 = L8_2(L9_2)
      for L12_2, L13_2 in L8_2, L9_2, L10_2, L11_2 do
        L14_2 = L1_1
        L15_2 = L13_2.id
        L14_2 = L14_2(L15_2)
        L7_2[L12_2] = L14_2
      end
      L8_2 = MySQL
      L8_2 = L8_2.query
      L8_2 = L8_2.await
      L9_2 = "SELECT DISTINCT sender FROM apex_phone_messages WHERE conversation_id = ? AND id > ? AND id <= ? AND sender <> ? AND type <> 'system' LIMIT 256"
      L10_2 = {}
      L11_2 = L3_2
      L12_2 = L5_2
      L13_2 = L4_2
      L14_2 = L2_2.me
      L10_2[1] = L11_2
      L10_2[2] = L12_2
      L10_2[3] = L13_2
      L10_2[4] = L14_2
      L8_2 = L8_2(L9_2, L10_2)
      if not L8_2 then
        L8_2 = {}
      end
      L9_2 = {}
      L10_2 = ipairs
      L11_2 = L39_1
      L12_2 = L3_2
      L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2, L19_2, L20_2, L21_2, L22_2, L23_2, L24_2 = L11_2(L12_2)
      L10_2, L11_2, L12_2, L13_2 = L10_2(L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2, L19_2, L20_2, L21_2, L22_2, L23_2, L24_2)
      for L14_2, L15_2 in L10_2, L11_2, L12_2, L13_2 do
        L16_2 = tostring
        L17_2 = L15_2.member
        L16_2 = L16_2(L17_2)
        L9_2[L16_2] = true
      end
      L10_2 = {}
      L11_2 = ipairs
      L12_2 = L8_2
      L11_2, L12_2, L13_2, L14_2 = L11_2(L12_2)
      for L15_2, L16_2 in L11_2, L12_2, L13_2, L14_2 do
        L17_2 = L16_2.sender
        if L17_2 then
          L17_2 = tostring
          L18_2 = L16_2.sender
          L17_2 = L17_2(L18_2)
          L17_2 = L9_2[L17_2]
          if L17_2 then
            L17_2 = #L10_2
            L17_2 = L17_2 + 1
            L18_2 = tostring
            L19_2 = L16_2.sender
            L18_2 = L18_2(L19_2)
            L10_2[L17_2] = L18_2
          end
        end
      end
      L11_2 = #L10_2
      if L11_2 > 0 then
        L11_2 = L9_1
        L12_2 = L2_2.app
        L13_2 = L2_2.me
        L11_2 = L11_2(L12_2, L13_2)
        if L11_2 then
          L11_2 = {}
          L10_2 = L11_2
        end
      end
      L11_2 = #L10_2
      if L11_2 > 0 then
        L11_2 = L34_1
        L12_2 = L2_2.app
        L13_2 = L10_2
        L14_2 = nil
        L11_2 = L11_2(L12_2, L13_2, L14_2)
        L12_2 = {}
        L12_2.conversation = L3_2
        L12_2.ids = L7_2
        L12_2.status = "read"
        L13_2 = Now
        L13_2 = L13_2()
        L12_2.at = L13_2
        L13_2 = L2_2.me
        L12_2.who = L13_2
        L12_2.upTo = L4_2
        L13_2 = ipairs
        L14_2 = L10_2
        L13_2, L14_2, L15_2, L16_2 = L13_2(L14_2)
        for L17_2, L18_2 in L13_2, L14_2, L15_2, L16_2 do
          L19_2 = L11_2[L18_2]
          L20_2 = L19_2 or L20_2
          if L19_2 then
            L20_2 = L19_2.src
          end
          if L20_2 and L20_2 ~= A0_2 then
            L21_2 = L19_2.noReceipts
            if not L21_2 then
              L21_2 = HasPhoneItem
              if L21_2 then
                L21_2 = HasPhoneItem
                L22_2 = L20_2
                L21_2 = L21_2(L22_2)
                if not L21_2 then
                  goto lbl_220
                end
              end
              L21_2 = Push
              L22_2 = L20_2
              L23_2 = "messageStatus"
              L24_2 = L12_2
              L21_2(L22_2, L23_2, L24_2)
            end
          end
          ::lbl_220::
        end
      end
    end
    L7_2 = {}
    L7_2.ok = true
    return L7_2
  end
  L2_2 = L6_1
  L3_2 = A1_2
  L2_2 = L2_2(L3_2)
  L3_2 = L21_1
  L4_2 = A0_2
  L5_2 = L2_2
  L3_2 = L3_2(L4_2, L5_2)
  if not L3_2 then
    L4_2 = {}
    L4_2.ok = false
    return L4_2
  end
  L4_2 = L5_1
  L5_2 = L2_2
  L6_2 = L4_1
  L7_2 = A1_2.number
  L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2, L19_2, L20_2, L21_2, L22_2, L23_2, L24_2 = L6_2(L7_2)
  L4_2 = L4_2(L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2, L19_2, L20_2, L21_2, L22_2, L23_2, L24_2)
  if not L4_2 then
    L5_2 = {}
    L5_2.ok = false
    return L5_2
  end
  L5_2 = MySQL
  L5_2 = L5_2.update
  L6_2 = "UPDATE apex_phone_messages SET `read` = 1 WHERE app = ? AND sender = ? AND receiver = ? AND conversation_id IS NULL AND `read` = 0 AND deleted_receiver = 1"
  L7_2 = {}
  L8_2 = L2_2
  L9_2 = L4_2
  L10_2 = L3_2
  L7_2[1] = L8_2
  L7_2[2] = L9_2
  L7_2[3] = L10_2
  L5_2(L6_2, L7_2)
  L5_2 = MySQL
  L5_2 = L5_2.query
  L5_2 = L5_2.await
  L6_2 = "SELECT id FROM apex_phone_messages WHERE app = ? AND sender = ? AND receiver = ? AND conversation_id IS NULL AND `read` = 0 AND deleted_receiver = 0 ORDER BY id DESC LIMIT 500"
  L7_2 = {}
  L8_2 = L2_2
  L9_2 = L4_2
  L10_2 = L3_2
  L7_2[1] = L8_2
  L7_2[2] = L9_2
  L7_2[3] = L10_2
  L5_2 = L5_2(L6_2, L7_2)
  if not L5_2 then
    L5_2 = {}
  end
  L6_2 = #L5_2
  if 0 == L6_2 then
    L6_2 = {}
    L6_2.ok = true
    return L6_2
  end
  L6_2 = Now
  L6_2 = L6_2()
  L7_2 = L1_1
  L8_2 = L5_2[1]
  L8_2 = L8_2.id
  L7_2 = L7_2(L8_2)
  L8_2 = MySQL
  L8_2 = L8_2.update
  L8_2 = L8_2.await
  L9_2 = "UPDATE apex_phone_messages SET `read` = 1, read_at = ?, delivered_at = COALESCE(delivered_at, ?) WHERE app = ? AND sender = ? AND receiver = ? AND conversation_id IS NULL AND `read` = 0 AND deleted_receiver = 0 AND id <= ?"
  L10_2 = {}
  L11_2 = L6_2
  L12_2 = L6_2
  L13_2 = L2_2
  L14_2 = L4_2
  L15_2 = L3_2
  L16_2 = L7_2
  L10_2[1] = L11_2
  L10_2[2] = L12_2
  L10_2[3] = L13_2
  L10_2[4] = L14_2
  L10_2[5] = L15_2
  L10_2[6] = L16_2
  L8_2(L9_2, L10_2)
  if L4_2 ~= L3_2 then
    L8_2 = L22_1
    L9_2 = L2_2
    L10_2 = L4_2
    L8_2 = L8_2(L9_2, L10_2)
    if L8_2 then
      goto lbl_313
    end
  end
  L8_2 = nil
  ::lbl_313::
  if L8_2 and L8_2 ~= A0_2 then
    L9_2 = L32_1
    L10_2 = GetCid
    L11_2 = A0_2
    L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2, L19_2, L20_2, L21_2, L22_2, L23_2, L24_2 = L10_2(L11_2)
    L9_2 = L9_2(L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2, L19_2, L20_2, L21_2, L22_2, L23_2, L24_2)
    L9_2 = L9_2.noReceipts
    if not L9_2 then
      L9_2 = L9_1
      L10_2 = L2_2
      L11_2 = L3_2
      L9_2 = L9_2(L10_2, L11_2)
    end
    L10_2 = L32_1
    L11_2 = GetCid
    L12_2 = L8_2
    L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2, L19_2, L20_2, L21_2, L22_2, L23_2, L24_2 = L11_2(L12_2)
    L10_2 = L10_2(L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2, L19_2, L20_2, L21_2, L22_2, L23_2, L24_2)
    L10_2 = L10_2.noReceipts
    if not L10_2 then
      L10_2 = L9_1
      L11_2 = L2_2
      L12_2 = L4_2
      L10_2 = L10_2(L11_2, L12_2)
    end
    if not L9_2 and not L10_2 then
      L11_2 = {}
      L12_2 = ipairs
      L13_2 = L5_2
      L12_2, L13_2, L14_2, L15_2 = L12_2(L13_2)
      for L16_2, L17_2 in L12_2, L13_2, L14_2, L15_2 do
        L18_2 = L1_1
        L19_2 = L17_2.id
        L18_2 = L18_2(L19_2)
        L11_2[L16_2] = L18_2
      end
      L12_2 = Push
      L13_2 = L8_2
      L14_2 = "messageStatus"
      L15_2 = {}
      L15_2.ids = L11_2
      L15_2.status = "read"
      L15_2.at = L6_2
      L15_2.number = L3_2
      L15_2.app = L2_2
      L12_2(L13_2, L14_2, L15_2)
    end
  end
  L9_2 = {}
  L9_2.ok = true
  return L9_2
end
L65_1["messages.read"] = L66_1
L65_1 = {}
L66_1 = RPC
function L67_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2
  L2_2 = A1_2.on
  L2_2 = false ~= L2_2
  L3_2 = L41_1
  L4_2 = A0_2
  L5_2 = A1_2
  L3_2, L4_2 = L3_2(L4_2, L5_2)
  if not L3_2 then
    L5_2 = {}
    L5_2.ok = false
    L5_2.error = L4_2
    return L5_2
  end
  L5_2 = L3_2.app
  L6_2 = "|"
  L7_2 = L3_2.other
  L5_2 = L5_2 .. L6_2 .. L7_2
  L6_2 = L65_1
  L6_2 = L6_2[A0_2]
  if not L6_2 then
    L7_2 = {}
    L6_2 = L7_2
    L7_2 = L65_1
    L7_2[A0_2] = L6_2
  end
  L7_2 = L6_2[L5_2]
  L8_2 = GetGameTimer
  L8_2 = L8_2()
  if L2_2 then
    if L7_2 then
      L9_2 = L7_2.on
      if L9_2 then
        L9_2 = L7_2.at
        L9_2 = L8_2 - L9_2
        L10_2 = L12_1
        L10_2 = L10_2()
        L10_2 = L10_2.typingMs
        if L9_2 < L10_2 then
          L9_2 = {}
          L9_2.ok = true
          return L9_2
        end
      end
    end
  else
    if L7_2 then
      L9_2 = L7_2.on
      if L9_2 then
        goto lbl_62
      end
    end
    L9_2 = {}
    L9_2.ok = true
    return L9_2
  end
  ::lbl_62::
  L9_2 = {}
  L9_2.at = L8_2
  L9_2.on = L2_2
  L6_2[L5_2] = L9_2
  L9_2 = L3_2.conv
  if L9_2 then
    L9_2 = L40_1
    L10_2 = L3_2.conv
    L11_2 = L3_2.app
    L12_2 = "typing"
    L13_2 = {}
    L14_2 = L3_2.me
    L13_2.from = L14_2
    L14_2 = L3_2.app
    L13_2.app = L14_2
    L14_2 = L3_2.conv
    L13_2.conversation = L14_2
    L13_2.on = L2_2
    L14_2 = L3_2.me
    L15_2 = A0_2
    L9_2(L10_2, L11_2, L12_2, L13_2, L14_2, L15_2)
    L9_2 = {}
    L9_2.ok = true
    return L9_2
  end
  L9_2 = L3_2.other
  L10_2 = L3_2.me
  if L9_2 == L10_2 then
    L9_2 = {}
    L9_2.ok = true
    return L9_2
  end
  L9_2 = L22_1
  L10_2 = L3_2.app
  L11_2 = L3_2.other
  L9_2 = L9_2(L10_2, L11_2)
  if L9_2 and L9_2 ~= A0_2 then
    L11_2 = L3_2.app
    L10_2 = L0_1
    L10_2 = L10_2[L11_2]
    if L10_2 then
      L10_2 = IsBlocked
      L11_2 = GetCid
      L12_2 = L9_2
      L11_2 = L11_2(L12_2)
      L12_2 = L3_2.me
      L10_2 = L10_2(L11_2, L12_2)
    end
    if not L10_2 then
      L11_2 = Push
      L12_2 = L9_2
      L13_2 = "typing"
      L14_2 = {}
      L15_2 = L3_2.me
      L14_2.from = L15_2
      L15_2 = L3_2.app
      L14_2.app = L15_2
      L14_2.on = L2_2
      L11_2(L12_2, L13_2, L14_2)
    end
  end
  L10_2 = {}
  L10_2.ok = true
  return L10_2
end
L66_1["messages.typing"] = L67_1
L66_1 = RPC
function L67_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2
  L2_2 = L41_1
  L3_2 = A0_2
  L4_2 = A1_2
  L2_2, L3_2 = L2_2(L3_2, L4_2)
  if not L2_2 then
    L4_2 = {}
    L4_2.ok = false
    L4_2.error = L3_2
    return L4_2
  end
  L4_2 = nil
  L5_2 = L2_2.conv
  if L5_2 then
    L5_2 = L1_1
    L6_2 = MySQL
    L6_2 = L6_2.scalar
    L6_2 = L6_2.await
    L7_2 = "SELECT MAX(id) FROM apex_phone_messages WHERE conversation_id = ?"
    L8_2 = {}
    L9_2 = L2_2.conv
    L8_2[1] = L9_2
    L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2 = L6_2(L7_2, L8_2)
    L5_2 = L5_2(L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2)
    L4_2 = L5_2
    if L4_2 then
      L5_2 = MySQL
      L5_2 = L5_2.update
      L5_2 = L5_2.await
      L6_2 = "UPDATE apex_phone_conversation_members SET last_read_id = ? WHERE conversation_id = ? AND member = ? AND (last_read_id IS NULL OR last_read_id < ?)"
      L7_2 = {}
      L8_2 = L4_2
      L9_2 = L2_2.conv
      L10_2 = L2_2.me
      L11_2 = L4_2
      L7_2[1] = L8_2
      L7_2[2] = L9_2
      L7_2[3] = L10_2
      L7_2[4] = L11_2
      L5_2(L6_2, L7_2)
    end
  else
    L5_2 = L1_1
    L6_2 = MySQL
    L6_2 = L6_2.scalar
    L6_2 = L6_2.await
    L7_2 = [[
SELECT MAX(id) FROM apex_phone_messages WHERE app = ? AND conversation_id IS NULL
            AND ((sender = ? AND receiver = ?) OR (sender = ? AND receiver = ?))]]
    L8_2 = {}
    L9_2 = L2_2.app
    L10_2 = L2_2.me
    L11_2 = L2_2.other
    L12_2 = L2_2.other
    L13_2 = L2_2.me
    L8_2[1] = L9_2
    L8_2[2] = L10_2
    L8_2[3] = L11_2
    L8_2[4] = L12_2
    L8_2[5] = L13_2
    L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2 = L6_2(L7_2, L8_2)
    L5_2 = L5_2(L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2)
    L4_2 = L5_2
    if L4_2 then
      L5_2 = Now
      L5_2 = L5_2()
      L6_2 = MySQL
      L6_2 = L6_2.update
      L6_2 = L6_2.await
      L7_2 = "UPDATE apex_phone_messages SET `read` = 1, delivered_at = COALESCE(delivered_at, ?) WHERE app = ? AND sender = ? AND receiver = ? AND conversation_id IS NULL AND `read` = 0 AND deleted_receiver = 0 AND id <= ?"
      L8_2 = {}
      L9_2 = L5_2
      L10_2 = L2_2.app
      L11_2 = L2_2.other
      L12_2 = L2_2.me
      L13_2 = L4_2
      L8_2[1] = L9_2
      L8_2[2] = L10_2
      L8_2[3] = L11_2
      L8_2[4] = L12_2
      L8_2[5] = L13_2
      L6_2(L7_2, L8_2)
    end
  end
  if not L4_2 then
    L5_2 = {}
    L5_2.ok = true
    return L5_2
  end
  L5_2 = MySQL
  L5_2 = L5_2.query
  L5_2 = L5_2.await
  L6_2 = "INSERT INTO apex_phone_thread_meta (owner, app, other, cleared_before, pinned) VALUES (?, ?, ?, ?, 0) ON DUPLICATE KEY UPDATE cleared_before = VALUES(cleared_before), pinned_msg = NULL"
  L7_2 = {}
  L8_2 = L2_2.me
  L9_2 = L2_2.app
  L10_2 = L2_2.other
  L11_2 = L4_2
  L7_2[1] = L8_2
  L7_2[2] = L9_2
  L7_2[3] = L10_2
  L7_2[4] = L11_2
  L5_2(L6_2, L7_2)
  L5_2 = {}
  L5_2.ok = true
  L5_2.clearedBefore = L4_2
  return L5_2
end
L66_1["messages.clear"] = L67_1
L66_1 = RPC
function L67_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2, L19_2
  L2_2 = L41_1
  L3_2 = A0_2
  L4_2 = A1_2
  L2_2, L3_2 = L2_2(L3_2, L4_2)
  if not L2_2 then
    L4_2 = {}
    L4_2.ok = false
    L4_2.error = L3_2
    return L4_2
  end
  L4_2 = L42_1
  L5_2 = L2_2.me
  L6_2 = L2_2.app
  L7_2 = L2_2.other
  L4_2 = L4_2(L5_2, L6_2, L7_2)
  if not L4_2 then
    L4_2 = {}
  end
  L5_2 = tonumber
  L6_2 = L4_2.pinned
  L5_2 = L5_2(L6_2)
  if 1 == L5_2 then
    L5_2 = 1
    if L5_2 then
      goto lbl_30
    end
  end
  L5_2 = 0
  ::lbl_30::
  L6_2 = tonumber
  L7_2 = L4_2.muted_until
  L6_2 = L6_2(L7_2)
  L7_2 = L1_1
  L8_2 = L4_2.pinned_msg
  L7_2 = L7_2(L8_2)
  L8_2 = Now
  L8_2 = L8_2()
  L9_2 = A1_2.pinned
  if nil ~= L9_2 then
    L9_2 = A1_2.pinned
    if true ~= L9_2 then
      L9_2 = A1_2.pinned
      if 1 ~= L9_2 then
        goto lbl_50
      end
    end
    L9_2 = 1
    L5_2 = L9_2 or L5_2
    ::lbl_50::
    if not L9_2 then
      L5_2 = 0
    end
  end
  L9_2 = A1_2.mutedUntil
  if nil ~= L9_2 then
    L9_2 = A1_2.mutedUntil
    if true == L9_2 or -1 == L9_2 then
      L6_2 = L13_1
    else
      if false ~= L9_2 then
        L10_2 = tonumber
        L11_2 = L9_2
        L10_2 = L10_2(L11_2)
        if 0 ~= L10_2 then
          goto lbl_70
        end
      end
      L6_2 = nil
      goto lbl_95
      ::lbl_70::
      L10_2 = tonumber
      L11_2 = L9_2
      L10_2 = L10_2(L11_2)
      if not L10_2 or L10_2 ~= L10_2 then
        L11_2 = {}
        L11_2.ok = false
        L11_2.error = "invalid"
        return L11_2
      end
      if L8_2 < L10_2 then
        L11_2 = math
        L11_2 = L11_2.floor
        L12_2 = math
        L12_2 = L12_2.min
        L13_2 = L10_2
        L14_2 = L13_1
        L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2, L19_2 = L12_2(L13_2, L14_2)
        L11_2 = L11_2(L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2, L19_2)
        if L11_2 then
          goto lbl_95
          L6_2 = L11_2 or L6_2
        end
      end
      L6_2 = nil
    end
  end
  ::lbl_95::
  L9_2 = A1_2.pinnedMsg
  if nil ~= L9_2 then
    L9_2 = A1_2.pinnedMsg
    if false ~= L9_2 then
      L9_2 = tonumber
      L10_2 = A1_2.pinnedMsg
      L9_2 = L9_2(L10_2)
      if 0 ~= L9_2 then
        goto lbl_108
      end
    end
    L7_2 = nil
    goto lbl_164
    ::lbl_108::
    L9_2 = L1_1
    L10_2 = A1_2.pinnedMsg
    L9_2 = L9_2(L10_2)
    if not L9_2 then
      L10_2 = {}
      L10_2.ok = false
      L10_2.error = "invalid"
      return L10_2
    end
    L10_2 = nil
    L11_2 = L2_2.conv
    if L11_2 then
      L11_2 = MySQL
      L11_2 = L11_2.scalar
      L11_2 = L11_2.await
      L12_2 = "SELECT id FROM apex_phone_messages WHERE id = ? AND conversation_id = ? AND deleted_all IS NULL AND created >= ?"
      L13_2 = {}
      L14_2 = L9_2
      L15_2 = L2_2.conv
      L16_2 = L38_1
      L17_2 = L2_2.conv
      L18_2 = L2_2.me
      L16_2 = L16_2(L17_2, L18_2)
      if not L16_2 then
        L16_2 = 0
      end
      L13_2[1] = L14_2
      L13_2[2] = L15_2
      L13_2[3] = L16_2
      L11_2 = L11_2(L12_2, L13_2)
      L10_2 = L11_2
    else
      L11_2 = MySQL
      L11_2 = L11_2.scalar
      L11_2 = L11_2.await
      L12_2 = [[
SELECT id FROM apex_phone_messages WHERE id = ? AND app = ? AND conversation_id IS NULL AND deleted_all IS NULL
                    AND ((sender = ? AND receiver = ?) OR (sender = ? AND receiver = ? AND deleted_receiver = 0))]]
      L13_2 = {}
      L14_2 = L9_2
      L15_2 = L2_2.app
      L16_2 = L2_2.me
      L17_2 = L2_2.other
      L18_2 = L2_2.other
      L19_2 = L2_2.me
      L13_2[1] = L14_2
      L13_2[2] = L15_2
      L13_2[3] = L16_2
      L13_2[4] = L17_2
      L13_2[5] = L18_2
      L13_2[6] = L19_2
      L11_2 = L11_2(L12_2, L13_2)
      L10_2 = L11_2
    end
    if not L10_2 then
      L11_2 = {}
      L11_2.ok = false
      L11_2.error = "notfound"
      return L11_2
    end
    L7_2 = L9_2
  end
  ::lbl_164::
  L9_2 = MySQL
  L9_2 = L9_2.query
  L9_2 = L9_2.await
  L10_2 = [[
INSERT INTO apex_phone_thread_meta (owner, app, other, muted_until, pinned_msg, cleared_before, pinned) VALUES (?, ?, ?, ?, ?, ?, ?)
        ON DUPLICATE KEY UPDATE pinned = VALUES(pinned), muted_until = VALUES(muted_until), pinned_msg = VALUES(pinned_msg)]]
  L11_2 = {}
  L12_2 = L2_2.me
  L13_2 = L2_2.app
  L14_2 = L2_2.other
  L15_2 = L6_2
  L16_2 = L7_2
  L17_2 = L1_1
  L18_2 = L4_2.cleared_before
  L17_2 = L17_2(L18_2)
  L18_2 = L5_2
  L11_2[1] = L12_2
  L11_2[2] = L13_2
  L11_2[3] = L14_2
  L11_2[4] = L15_2
  L11_2[5] = L16_2
  L11_2[6] = L17_2
  L11_2[7] = L18_2
  L9_2(L10_2, L11_2)
  L9_2 = {}
  L9_2.ok = true
  L10_2 = 1 == L5_2
  L9_2.pinned = L10_2
  L9_2.mutedUntil = L6_2
  L9_2.pinnedMsg = L7_2
  return L9_2
end
L66_1["thread.set"] = L67_1
L66_1 = RPC
function L67_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2
  L2_2 = type
  L3_2 = A1_2.numbers
  L2_2 = L2_2(L3_2)
  if "table" == L2_2 then
    L2_2 = A1_2.numbers
    if L2_2 then
      goto lbl_11
    end
  end
  L2_2 = {}
  ::lbl_11::
  L3_2 = {}
  L4_2 = {}
  L5_2 = ipairs
  L6_2 = L2_2
  L5_2, L6_2, L7_2, L8_2 = L5_2(L6_2)
  for L9_2, L10_2 in L5_2, L6_2, L7_2, L8_2 do
    L11_2 = L4_1
    L12_2 = L10_2
    L11_2 = L11_2(L12_2)
    if L11_2 then
      L12_2 = #L11_2
      if L12_2 <= 20 then
        L12_2 = L4_2[L11_2]
        if not L12_2 then
          L4_2[L11_2] = true
          L12_2 = #L3_2
          L12_2 = L12_2 + 1
          L3_2[L12_2] = L11_2
          L12_2 = #L3_2
          if L12_2 >= 50 then
            break
          end
        end
      end
    end
  end
  L5_2 = {}
  L6_2 = #L3_2
  if 0 == L6_2 then
    return L5_2
  end
  L6_2 = L34_1
  L7_2 = "sms"
  L8_2 = L3_2
  L9_2 = GetPlayerNumber
  L10_2 = A0_2
  L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2 = L9_2(L10_2)
  L6_2 = L6_2(L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2)
  L7_2 = ipairs
  L8_2 = L3_2
  L7_2, L8_2, L9_2, L10_2 = L7_2(L8_2)
  for L11_2, L12_2 in L7_2, L8_2, L9_2, L10_2 do
    L13_2 = L6_2[L12_2]
    if not L13_2 then
      L13_2 = {}
    end
    L14_2 = {}
    L15_2 = L13_2.online
    L15_2 = true == L15_2
    L14_2.online = L15_2
    L15_2 = L13_2.lastSeen
    L14_2.lastSeen = L15_2
    L5_2[L12_2] = L14_2
  end
  return L5_2
end
L66_1["presence.get"] = L67_1
L66_1 = 500
function L67_1(A0_2)
  local L1_2, L2_2, L3_2, L4_2
  L1_2 = type
  L2_2 = A0_2
  L1_2 = L1_2(L2_2)
  if "string" ~= L1_2 then
    L1_2 = type
    L2_2 = A0_2
    L1_2 = L1_2(L2_2)
    if "number" ~= L1_2 then
      L1_2 = nil
      return L1_2
    end
  end
  L1_2 = L3_1
  L2_2 = tostring
  L3_2 = A0_2
  L2_2 = L2_2(L3_2)
  L3_2 = L2_2
  L2_2 = L2_2.match
  L4_2 = "^%s*(.-)%s*$"
  L2_2 = L2_2(L3_2, L4_2)
  L3_2 = 20
  L1_2 = L1_2(L2_2, L3_2)
  if "" == L1_2 then
    L2_2 = nil
    return L2_2
  end
  return L1_2
end
L68_1 = RPC
function L69_1(A0_2)
  local L1_2, L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2
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
  L3_2 = [[
SELECT b.number, b.created, c.name FROM apex_phone_blocks b
        LEFT JOIN apex_phone_contacts c ON c.owner = b.owner AND c.number = b.number
        WHERE b.owner = ? ORDER BY b.created DESC LIMIT 600]]
  L4_2 = {}
  L5_2 = L1_2
  L4_2[1] = L5_2
  L2_2 = L2_2(L3_2, L4_2)
  if not L2_2 then
    L2_2 = {}
  end
  L3_2 = {}
  L4_2 = {}
  L5_2 = ipairs
  L6_2 = L2_2
  L5_2, L6_2, L7_2, L8_2 = L5_2(L6_2)
  for L9_2, L10_2 in L5_2, L6_2, L7_2, L8_2 do
    L11_2 = L10_2.number
    L11_2 = L4_2[L11_2]
    if not L11_2 then
      L11_2 = L10_2.number
      L4_2[L11_2] = true
      L11_2 = #L3_2
      L11_2 = L11_2 + 1
      L12_2 = {}
      L13_2 = L10_2.number
      L12_2.number = L13_2
      L13_2 = tonumber
      L14_2 = L10_2.created
      L13_2 = L13_2(L14_2)
      L12_2.created = L13_2
      L13_2 = L10_2.name
      L12_2.name = L13_2
      L3_2[L11_2] = L12_2
    end
  end
  return L3_2
end
L68_1["blocks.list"] = L69_1
L68_1 = RPC
function L69_1(A0_2, A1_2)
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
  L3_2 = L67_1
  L4_2 = A1_2.number
  L3_2 = L3_2(L4_2)
  if not L3_2 then
    L4_2 = {}
    L4_2.ok = false
    L4_2.error = "invalid"
    return L4_2
  end
  L4_2 = GetPlayerNumber
  L5_2 = A0_2
  L4_2 = L4_2(L5_2)
  if L3_2 == L4_2 then
    L4_2 = {}
    L4_2.ok = false
    L4_2.error = "self"
    return L4_2
  end
  L4_2 = tonumber
  L5_2 = MySQL
  L5_2 = L5_2.scalar
  L5_2 = L5_2.await
  L6_2 = "SELECT COUNT(*) FROM apex_phone_blocks WHERE owner = ?"
  L7_2 = {}
  L8_2 = L2_2
  L7_2[1] = L8_2
  L5_2, L6_2, L7_2, L8_2, L9_2, L10_2 = L5_2(L6_2, L7_2)
  L4_2 = L4_2(L5_2, L6_2, L7_2, L8_2, L9_2, L10_2)
  if not L4_2 then
    L4_2 = 0
  end
  L5_2 = L66_1
  if L4_2 >= L5_2 then
    L5_2 = IsBlocked
    L6_2 = L2_2
    L7_2 = L3_2
    L5_2 = L5_2(L6_2, L7_2)
    if not L5_2 then
      L5_2 = {}
      L5_2.ok = false
      L5_2.error = "limit"
      return L5_2
    end
  end
  L5_2 = MySQL
  L5_2 = L5_2.query
  L5_2 = L5_2.await
  L6_2 = "INSERT INTO apex_phone_blocks (owner, number, created) VALUES (?, ?, ?) ON DUPLICATE KEY UPDATE created = created"
  L7_2 = {}
  L8_2 = L2_2
  L9_2 = L3_2
  L10_2 = Now
  L10_2 = L10_2()
  L7_2[1] = L8_2
  L7_2[2] = L9_2
  L7_2[3] = L10_2
  L5_2(L6_2, L7_2)
  L5_2 = L25_1
  L5_2[L2_2] = nil
  L5_2 = {}
  L5_2.ok = true
  L5_2.number = L3_2
  return L5_2
end
L68_1["blocks.add"] = L69_1
L68_1 = RPC
function L69_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2
  L2_2 = GetCid
  L3_2 = A0_2
  L2_2 = L2_2(L3_2)
  if not L2_2 then
    L3_2 = {}
    L3_2.ok = false
    L3_2.error = "noplayer"
    return L3_2
  end
  L3_2 = L67_1
  L4_2 = A1_2.number
  L3_2 = L3_2(L4_2)
  if not L3_2 then
    L4_2 = {}
    L4_2.ok = false
    L4_2.error = "invalid"
    return L4_2
  end
  L4_2 = MySQL
  L4_2 = L4_2.query
  L4_2 = L4_2.await
  L5_2 = "DELETE FROM apex_phone_blocks WHERE owner = ? AND number = ?"
  L6_2 = {}
  L7_2 = L2_2
  L8_2 = L3_2
  L6_2[1] = L7_2
  L6_2[2] = L8_2
  L4_2(L5_2, L6_2)
  L4_2 = L25_1
  L4_2[L2_2] = nil
  L4_2 = {}
  L4_2.ok = true
  L4_2.number = L3_2
  return L4_2
end
L68_1["blocks.remove"] = L69_1
L68_1 = RPC
function L69_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2
  L2_2 = L3_1
  L3_2 = tostring
  L4_2 = A1_2.q
  if not L4_2 then
    L4_2 = ""
  end
  L3_2 = L3_2(L4_2)
  L4_2 = L3_2
  L3_2 = L3_2.match
  L5_2 = "^%s*(.-)%s*$"
  L3_2 = L3_2(L4_2, L5_2)
  L4_2 = 64
  L2_2 = L2_2(L3_2, L4_2)
  L3_2 = #L2_2
  if L3_2 < 2 then
    L3_2 = {}
    return L3_2
  end
  L3_2 = GetPlayerNumber
  L4_2 = A0_2
  L3_2 = L3_2(L4_2)
  if not L3_2 then
    L4_2 = {}
    return L4_2
  end
  L4_2 = "%"
  L6_2 = L2_2
  L5_2 = L2_2.gsub
  L7_2 = "[!%%_]"
  L8_2 = "!%0"
  L5_2 = L5_2(L6_2, L7_2, L8_2)
  L6_2 = "%"
  L4_2 = L4_2 .. L5_2 .. L6_2
  L5_2 = MySQL
  L5_2 = L5_2.query
  L5_2 = L5_2.await
  L6_2 = [[
SELECT id, app, sender, receiver, content, created FROM apex_phone_messages
        WHERE app = 'sms' AND (sender = ? OR receiver = ?) AND conversation_id IS NULL AND deleted_all IS NULL
          AND NOT (sender = ? AND deleted_sender = 1) AND NOT (receiver = ? AND deleted_receiver = 1)
          AND content LIKE ? ESCAPE '!' ORDER BY id DESC LIMIT 20]]
  L7_2 = {}
  L8_2 = L3_2
  L9_2 = L3_2
  L10_2 = L3_2
  L11_2 = L3_2
  L12_2 = L4_2
  L7_2[1] = L8_2
  L7_2[2] = L9_2
  L7_2[3] = L10_2
  L7_2[4] = L11_2
  L7_2[5] = L12_2
  L5_2 = L5_2(L6_2, L7_2)
  if not L5_2 then
    L5_2 = {}
  end
  L6_2 = {}
  L7_2 = ipairs
  L8_2 = L5_2
  L7_2, L8_2, L9_2, L10_2 = L7_2(L8_2)
  for L11_2, L12_2 in L7_2, L8_2, L9_2, L10_2 do
    L13_2 = #L6_2
    L13_2 = L13_2 + 1
    L14_2 = {}
    L15_2 = L12_2.id
    L14_2.id = L15_2
    L15_2 = L12_2.app
    L14_2.app = L15_2
    L15_2 = L12_2.sender
    if L15_2 == L3_2 then
      L15_2 = L12_2.receiver
      if L15_2 then
        goto lbl_73
      end
    end
    L15_2 = L12_2.sender
    ::lbl_73::
    L14_2.number = L15_2
    L15_2 = L12_2.content
    L14_2.content = L15_2
    L15_2 = L12_2.created
    L14_2.created = L15_2
    L6_2[L13_2] = L14_2
  end
  return L6_2
end
L68_1["messages.search"] = L69_1
function L68_1(A0_2)
  local L1_2, L2_2
  L1_2 = A0_2.favorite
  L1_2 = 1 == L1_2
  A0_2.favorite = L1_2
  L1_2 = L1_1
  L2_2 = A0_2.avatar_photo
  L1_2 = L1_2(L2_2)
  A0_2.avatarPhoto = L1_2
  return A0_2
end
function L69_1(A0_2)
  local L1_2, L2_2, L3_2
  L1_2 = ContactsOwner
  if L1_2 then
    L1_2 = ContactsOwner
    L2_2 = A0_2
    L1_2 = L1_2(L2_2)
    if L1_2 then
      goto lbl_10
    end
  end
  L1_2 = nil
  ::lbl_10::
  L2_2 = L1_2 or L2_2
  if not L1_2 then
    L2_2 = GetCid
    L3_2 = A0_2
    L2_2 = L2_2(L3_2)
  end
  return L2_2
end
ContactsCid = L69_1
L70_1 = RPC
function L71_1(A0_2)
  local L1_2, L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2
  L1_2 = L69_1
  L2_2 = A0_2
  L1_2 = L1_2(L2_2)
  if not L1_2 then
    L2_2 = {}
    return L2_2
  end
  L2_2 = MySQL
  L2_2 = L2_2.query
  L2_2 = L2_2.await
  L3_2 = "SELECT * FROM apex_phone_contacts WHERE owner = ? ORDER BY name ASC LIMIT 5000"
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
    L9_2 = L68_1
    L10_2 = L8_2
    L9_2(L10_2)
  end
  return L2_2
end
L70_1["contacts.list"] = L71_1
function L70_1(A0_2)
  local L1_2, L2_2, L3_2, L4_2
  L1_2 = type
  L2_2 = A0_2
  L1_2 = L1_2(L2_2)
  if "number" == L1_2 then
    L1_2 = math
    L1_2 = L1_2.floor
    L2_2 = A0_2
    return L1_2(L2_2)
  end
  L1_2 = type
  L2_2 = A0_2
  L1_2 = L1_2(L2_2)
  if "string" == L1_2 then
    L2_2 = A0_2
    L1_2 = A0_2.sub
    L3_2 = 1
    L4_2 = 255
    return L1_2(L2_2, L3_2, L4_2)
  end
  L1_2 = nil
  return L1_2
end
function L71_1(A0_2)
  local L1_2, L2_2, L3_2
  L1_2 = type
  L2_2 = A0_2
  L1_2 = L1_2(L2_2)
  if "string" ~= L1_2 then
    L1_2 = type
    L2_2 = A0_2
    L1_2 = L1_2(L2_2)
    if "number" ~= L1_2 then
      L1_2 = nil
      return L1_2
    end
  end
  L1_2 = L3_1
  L2_2 = A0_2
  L3_2 = 500
  L1_2 = L1_2(L2_2, L3_2)
  L2_2 = L1_2 or L2_2
  if "" == L1_2 or not L1_2 then
    L2_2 = nil
  end
  return L2_2
end
function L72_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2, L6_2, L7_2
  if false ~= A1_2 and "" ~= A1_2 then
    L2_2 = tonumber
    L3_2 = A1_2
    L2_2 = L2_2(L3_2)
    if 0 ~= L2_2 then
      goto lbl_12
    end
  end
  L2_2 = nil
  do return L2_2 end
  ::lbl_12::
  L2_2 = L1_1
  L3_2 = A1_2
  L2_2 = L2_2(L3_2)
  if not L2_2 then
    L3_2 = false
    return L3_2
  end
  L3_2 = MySQL
  L3_2 = L3_2.scalar
  L3_2 = L3_2.await
  L4_2 = "SELECT id FROM apex_phone_photos WHERE id = ? AND owner = ?"
  L5_2 = {}
  L6_2 = L2_2
  L7_2 = A0_2
  L5_2[1] = L6_2
  L5_2[2] = L7_2
  L3_2 = L3_2(L4_2, L5_2)
  L4_2 = L2_2 or L4_2
  if not L3_2 or not L2_2 then
    L4_2 = false
  end
  return L4_2
end
L73_1 = RPC
function L74_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2
  L2_2 = L69_1
  L3_2 = A0_2
  L2_2 = L2_2(L3_2)
  if not L2_2 then
    L3_2 = {}
    L3_2.error = "invalid"
    return L3_2
  end
  L3_2 = L3_1
  L4_2 = A1_2.name
  L5_2 = 64
  L3_2 = L3_2(L4_2, L5_2)
  L4_2 = L3_1
  L5_2 = A1_2.number
  L6_2 = 20
  L4_2 = L4_2(L5_2, L6_2)
  if "" == L3_2 or "" == L4_2 then
    L5_2 = {}
    L5_2.error = "invalid"
    return L5_2
  end
  L5_2 = L70_1
  L6_2 = A1_2.avatar
  L5_2 = L5_2(L6_2)
  L6_2 = A1_2.notes
  if nil ~= L6_2 then
    L6_2 = L71_1
    L7_2 = A1_2.notes
    L6_2 = L6_2(L7_2)
    if L6_2 then
      goto lbl_38
    end
  end
  L6_2 = nil
  ::lbl_38::
  L7_2 = nil
  L8_2 = A1_2.avatarPhoto
  if nil ~= L8_2 then
    L8_2 = L72_1
    L9_2 = GetCid
    L10_2 = A0_2
    L9_2 = L9_2(L10_2)
    L10_2 = A1_2.avatarPhoto
    L8_2 = L8_2(L9_2, L10_2)
    L7_2 = L8_2
    if false == L7_2 then
      L8_2 = {}
      L8_2.error = "photo"
      return L8_2
    end
  end
  L8_2 = A1_2.favorite
  if L8_2 then
    L8_2 = 1
    if L8_2 then
      goto lbl_62
    end
  end
  L8_2 = 0
  ::lbl_62::
  L9_2 = MySQL
  L9_2 = L9_2.insert
  L9_2 = L9_2.await
  L10_2 = "INSERT INTO apex_phone_contacts (owner, name, number, avatar, notes, avatar_photo, favorite) VALUES (?, ?, ?, ?, ?, ?, ?)"
  L11_2 = {}
  L12_2 = L2_2
  L13_2 = L3_2
  L14_2 = L4_2
  L15_2 = L5_2
  L16_2 = L6_2
  L17_2 = L7_2
  L18_2 = L8_2
  L11_2[1] = L12_2
  L11_2[2] = L13_2
  L11_2[3] = L14_2
  L11_2[4] = L15_2
  L11_2[5] = L16_2
  L11_2[6] = L17_2
  L11_2[7] = L18_2
  L9_2 = L9_2(L10_2, L11_2)
  L10_2 = {}
  L10_2.id = L9_2
  L10_2.owner = L2_2
  L10_2.name = L3_2
  L10_2.number = L4_2
  L10_2.avatar = L5_2
  L11_2 = 1 == L8_2
  L10_2.favorite = L11_2
  L10_2.notes = L6_2
  L10_2.avatar_photo = L7_2
  L10_2.avatarPhoto = L7_2
  return L10_2
end
L73_1["contacts.add"] = L74_1
L73_1 = RPC
function L74_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2
  L2_2 = L69_1
  L3_2 = A0_2
  L2_2 = L2_2(L3_2)
  L3_2 = math
  L3_2 = L3_2.tointeger
  L4_2 = tonumber
  L5_2 = A1_2.id
  L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2 = L4_2(L5_2)
  L3_2 = L3_2(L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2)
  if not L2_2 or not L3_2 then
    L4_2 = {}
    L4_2.error = "notfound"
    return L4_2
  end
  L4_2 = MySQL
  L4_2 = L4_2.single
  L4_2 = L4_2.await
  L5_2 = "SELECT * FROM apex_phone_contacts WHERE id = ? AND owner = ?"
  L6_2 = {}
  L7_2 = L3_2
  L8_2 = L2_2
  L6_2[1] = L7_2
  L6_2[2] = L8_2
  L4_2 = L4_2(L5_2, L6_2)
  if not L4_2 then
    L5_2 = {}
    L5_2.error = "notfound"
    return L5_2
  end
  L5_2 = A1_2.name
  if nil ~= L5_2 then
    L5_2 = L3_1
    L6_2 = A1_2.name
    L7_2 = 64
    L5_2 = L5_2(L6_2, L7_2)
    if "" ~= L5_2 then
      L4_2.name = L5_2
    end
  end
  L5_2 = A1_2.number
  if nil ~= L5_2 then
    L5_2 = L3_1
    L6_2 = A1_2.number
    L7_2 = 20
    L5_2 = L5_2(L6_2, L7_2)
    if "" ~= L5_2 then
      L4_2.number = L5_2
    end
  end
  L5_2 = A1_2.favorite
  if nil ~= L5_2 then
    L5_2 = A1_2.favorite
    if L5_2 then
      L5_2 = 1
      if L5_2 then
        goto lbl_64
      end
    end
    L5_2 = 0
    ::lbl_64::
    L4_2.favorite = L5_2
  end
  L5_2 = A1_2.avatar
  if nil ~= L5_2 then
    L5_2 = L70_1
    L6_2 = A1_2.avatar
    L5_2 = L5_2(L6_2)
    L4_2.avatar = L5_2
  end
  L5_2 = A1_2.notes
  if nil ~= L5_2 then
    L5_2 = L71_1
    L6_2 = A1_2.notes
    L5_2 = L5_2(L6_2)
    L4_2.notes = L5_2
  end
  L5_2 = A1_2.avatarPhoto
  if nil ~= L5_2 then
    L5_2 = L72_1
    L6_2 = GetCid
    L7_2 = A0_2
    L6_2 = L6_2(L7_2)
    L7_2 = A1_2.avatarPhoto
    L5_2 = L5_2(L6_2, L7_2)
    if false == L5_2 then
      L6_2 = {}
      L6_2.error = "photo"
      return L6_2
    end
    L4_2.avatar_photo = L5_2
  end
  L5_2 = MySQL
  L5_2 = L5_2.update
  L6_2 = "UPDATE apex_phone_contacts SET name = ?, number = ?, avatar = ?, notes = ?, avatar_photo = ?, favorite = ? WHERE id = ? AND owner = ?"
  L7_2 = {}
  L8_2 = L4_2.name
  L9_2 = L4_2.number
  L10_2 = L4_2.avatar
  L11_2 = L4_2.notes
  L12_2 = L4_2.avatar_photo
  L13_2 = L4_2.favorite
  L14_2 = L4_2.id
  L15_2 = L2_2
  L7_2[1] = L8_2
  L7_2[2] = L9_2
  L7_2[3] = L10_2
  L7_2[4] = L11_2
  L7_2[5] = L12_2
  L7_2[6] = L13_2
  L7_2[7] = L14_2
  L7_2[8] = L15_2
  L5_2(L6_2, L7_2)
  L5_2 = L68_1
  L6_2 = L4_2
  return L5_2(L6_2)
end
L73_1["contacts.update"] = L74_1
L73_1 = RPC
function L74_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2, L6_2, L7_2
  L2_2 = MySQL
  L2_2 = L2_2.query
  L2_2 = L2_2.await
  L3_2 = "DELETE FROM apex_phone_contacts WHERE id = ? AND owner = ?"
  L4_2 = {}
  L5_2 = math
  L5_2 = L5_2.tointeger
  L6_2 = tonumber
  L7_2 = A1_2.id
  L6_2, L7_2 = L6_2(L7_2)
  L5_2 = L5_2(L6_2, L7_2)
  if not L5_2 then
    L5_2 = -1
  end
  L6_2 = L69_1
  L7_2 = A0_2
  L6_2, L7_2 = L6_2(L7_2)
  L4_2[1] = L5_2
  L4_2[2] = L6_2
  L4_2[3] = L7_2
  L2_2(L3_2, L4_2)
  L2_2 = {}
  L2_2.ok = true
  return L2_2
end
L73_1["contacts.remove"] = L74_1
L73_1 = {}
function L74_1(A0_2)
  local L1_2, L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2
  L1_2 = L18_1
  L2_2 = A0_2
  L1_2 = L1_2(L2_2)
  if L1_2 then
    L2_2 = L73_1
    L2_2 = L2_2[A0_2]
    if not L2_2 then
      goto lbl_11
    end
  end
  do return end
  ::lbl_11::
  L2_2 = L73_1
  L2_2[A0_2] = true
  L2_2 = pcall
  function L3_2()
    local L0_3, L1_3, L2_3, L3_3, L4_3, L5_3, L6_3, L7_3, L8_3, L9_3, L10_3, L11_3, L12_3, L13_3, L14_3, L15_3, L16_3, L17_3, L18_3, L19_3, L20_3, L21_3, L22_3, L23_3, L24_3, L25_3, L26_3, L27_3, L28_3, L29_3, L30_3, L31_3, L32_3
    L0_3 = L1_2.cid
    L1_3 = L1_2.number
    L2_3 = Now
    L2_3 = L2_3()
    L3_3 = {}
    if L1_3 then
      L4_3 = #L3_3
      L4_3 = L4_3 + 1
      L5_3 = {}
      L5_3.phone = true
      L5_3.ident = L1_3
      L3_3[L4_3] = L5_3
    end
    L4_3 = ipairs
    L5_3 = MySQL
    L5_3 = L5_3.query
    L5_3 = L5_3.await
    L6_3 = "SELECT app, username FROM apex_phone_social_accounts WHERE owner = ? LIMIT 20"
    L7_3 = {}
    L8_3 = L0_3
    L7_3[1] = L8_3
    L5_3 = L5_3(L6_3, L7_3)
    if not L5_3 then
      L5_3 = {}
    end
    L4_3, L5_3, L6_3, L7_3 = L4_3(L5_3)
    for L8_3, L9_3 in L4_3, L5_3, L6_3, L7_3 do
      L10_3 = #L3_3
      L10_3 = L10_3 + 1
      L11_3 = {}
      L12_3 = L9_3.app
      L11_3.app = L12_3
      L12_3 = L9_3.username
      L11_3.ident = L12_3
      L3_3[L10_3] = L11_3
    end
    L4_3 = 0
    L5_3 = L2_3 - 1209600000
    L6_3 = Accounts
    L6_3 = L6_3[L0_3]
    L7_3 = tonumber
    L8_3 = L17_1
    L8_3 = L8_3[L0_3]
    L7_3 = L7_3(L8_3)
    if not L7_3 then
      if L6_3 then
        L7_3 = tonumber
        L8_3 = L6_3.last_seen
        L7_3 = L7_3(L8_3)
        if L7_3 then
          goto lbl_65
        end
      end
      L7_3 = L5_3
    end
    ::lbl_65::
    if L5_3 > L7_3 then
      L7_3 = L5_3
    end
    L8_3 = ipairs
    L9_3 = L3_3
    L8_3, L9_3, L10_3, L11_3 = L8_3(L9_3)
    for L12_3, L13_3 in L8_3, L9_3, L10_3, L11_3 do
      L14_3 = MySQL
      L14_3 = L14_3.query
      L14_3 = L14_3.await
      L15_3 = "SELECT id, app, sender, `read` FROM apex_phone_messages WHERE receiver = ? AND delivered_at IS NULL AND deleted_receiver = 0 AND conversation_id IS NULL AND created > ? ORDER BY id DESC LIMIT 500"
      L16_3 = {}
      L17_3 = L13_3.ident
      L18_3 = L5_3
      L16_3[1] = L17_3
      L16_3[2] = L18_3
      L14_3 = L14_3(L15_3, L16_3)
      if not L14_3 then
        L14_3 = {}
      end
      L15_3 = {}
      L16_3 = {}
      L17_3 = ipairs
      L18_3 = L14_3
      L17_3, L18_3, L19_3, L20_3 = L17_3(L18_3)
      for L21_3, L22_3 in L17_3, L18_3, L19_3, L20_3 do
        L23_3 = L13_3.phone
        if L23_3 then
          L24_3 = L22_3.app
          L23_3 = L0_1
          L23_3 = L23_3[L24_3]
          if L23_3 then
            goto lbl_111
          end
        end
        L23_3 = L13_3.phone
        L23_3 = not L23_3
        ::lbl_111::
        if L23_3 then
          L24_3 = L22_3.sender
          L25_3 = L13_3.ident
          if L24_3 ~= L25_3 then
            L24_3 = L1_1
            L25_3 = L22_3.id
            L24_3 = L24_3(L25_3)
            L25_3 = #L15_3
            L25_3 = L25_3 + 1
            L15_3[L25_3] = L24_3
            L25_3 = L22_3.app
            L26_3 = "|"
            L27_3 = L22_3.sender
            L25_3 = L25_3 .. L26_3 .. L27_3
            L26_3 = L16_3[L25_3]
            if not L26_3 then
              L27_3 = {}
              L28_3 = L22_3.app
              L27_3.app = L28_3
              L28_3 = L22_3.sender
              L27_3.sender = L28_3
              L28_3 = {}
              L27_3.ids = L28_3
              L26_3 = L27_3
              L16_3[L25_3] = L26_3
            end
            L27_3 = L26_3.ids
            L28_3 = L26_3.ids
            L28_3 = #L28_3
            L28_3 = L28_3 + 1
            L27_3[L28_3] = L24_3
            L27_3 = L22_3.app
            if "sms" == L27_3 then
              L27_3 = tonumber
              L28_3 = L22_3.read
              L27_3 = L27_3(L28_3)
              if 0 == L27_3 then
                L4_3 = L4_3 + 1
              end
            end
          end
        end
      end
      L17_3 = #L15_3
      if L17_3 > 0 then
        L17_3 = {}
        L18_3 = L2_3
        L17_3[1] = L18_3
        L18_3 = ipairs
        L19_3 = L15_3
        L18_3, L19_3, L20_3, L21_3 = L18_3(L19_3)
        for L22_3, L23_3 in L18_3, L19_3, L20_3, L21_3 do
          L24_3 = #L17_3
          L24_3 = L24_3 + 1
          L17_3[L24_3] = L23_3
        end
        L18_3 = MySQL
        L18_3 = L18_3.update
        L18_3 = L18_3.await
        L19_3 = "UPDATE apex_phone_messages SET delivered_at = ? WHERE delivered_at IS NULL AND id IN (%s)"
        L20_3 = L19_3
        L19_3 = L19_3.format
        L21_3 = L2_1
        L22_3 = #L15_3
        L21_3, L22_3, L23_3, L24_3, L25_3, L26_3, L27_3, L28_3, L29_3, L30_3, L31_3, L32_3 = L21_3(L22_3)
        L19_3 = L19_3(L20_3, L21_3, L22_3, L23_3, L24_3, L25_3, L26_3, L27_3, L28_3, L29_3, L30_3, L31_3, L32_3)
        L20_3 = L17_3
        L18_3(L19_3, L20_3)
        L18_3 = pairs
        L19_3 = L16_3
        L18_3, L19_3, L20_3, L21_3 = L18_3(L19_3)
        for L22_3, L23_3 in L18_3, L19_3, L20_3, L21_3 do
          L24_3 = L23_1
          L25_3 = L23_3.app
          L26_3 = L23_3.sender
          L24_3 = L24_3(L25_3, L26_3)
          if L24_3 then
            L25_3 = A0_2
            if L24_3 ~= L25_3 then
              L25_3 = Push
              L26_3 = L24_3
              L27_3 = "messageStatus"
              L28_3 = {}
              L29_3 = L23_3.ids
              L28_3.ids = L29_3
              L28_3.status = "delivered"
              L28_3.at = L2_3
              L29_3 = L13_3.ident
              L28_3.number = L29_3
              L29_3 = L23_3.app
              L28_3.app = L29_3
              L25_3(L26_3, L27_3, L28_3)
            end
          end
        end
      end
    end
    if not L1_3 then
      return
    end
    L8_3 = false
    L9_3 = pcall
    L10_3 = MySQL
    L10_3 = L10_3.query
    L10_3 = L10_3.await
    L11_3 = [[
SELECT m.id, m.sender, m.conversation_id FROM apex_phone_conversation_members cm
            JOIN apex_phone_messages m ON m.conversation_id = cm.conversation_id AND m.id > COALESCE(cm.last_read_id, 0)
            WHERE cm.member = ? AND cm.left_at IS NULL AND m.delivered_at IS NULL AND m.sender <> ? AND m.type <> 'system'
              AND m.deleted_all IS NULL AND m.created > ? ORDER BY m.id DESC LIMIT 500]]
    L12_3 = {}
    L13_3 = L1_3
    L14_3 = L1_3
    L15_3 = L5_3
    L12_3[1] = L13_3
    L12_3[2] = L14_3
    L12_3[3] = L15_3
    L9_3, L10_3 = L9_3(L10_3, L11_3, L12_3)
    if L9_3 then
      L11_3 = type
      L12_3 = L10_3
      L11_3 = L11_3(L12_3)
      if "table" == L11_3 then
        L11_3 = #L10_3
        if L11_3 > 0 then
          L11_3 = {}
          L12_3 = {}
          L13_3 = ipairs
          L14_3 = L10_3
          L13_3, L14_3, L15_3, L16_3 = L13_3(L14_3)
          for L17_3, L18_3 in L13_3, L14_3, L15_3, L16_3 do
            L19_3 = L1_1
            L20_3 = L18_3.id
            L19_3 = L19_3(L20_3)
            L20_3 = L1_1
            L21_3 = L18_3.conversation_id
            L20_3 = L20_3(L21_3)
            if L19_3 and L20_3 then
              L21_3 = #L11_3
              L21_3 = L21_3 + 1
              L11_3[L21_3] = L19_3
              L21_3 = L20_3
              L22_3 = "|"
              L23_3 = tostring
              L24_3 = L18_3.sender
              L23_3 = L23_3(L24_3)
              L21_3 = L21_3 .. L22_3 .. L23_3
              L22_3 = L12_3[L21_3]
              if not L22_3 then
                L23_3 = {}
                L23_3.conv = L20_3
                L24_3 = L18_3.sender
                L23_3.sender = L24_3
                L24_3 = {}
                L23_3.ids = L24_3
                L22_3 = L23_3
                L12_3[L21_3] = L22_3
              end
              L23_3 = L22_3.ids
              L24_3 = L22_3.ids
              L24_3 = #L24_3
              L24_3 = L24_3 + 1
              L23_3[L24_3] = L19_3
            end
          end
          L13_3 = #L11_3
          if L13_3 > 0 then
            L13_3 = {}
            L14_3 = L2_3
            L13_3[1] = L14_3
            L14_3 = ipairs
            L15_3 = L11_3
            L14_3, L15_3, L16_3, L17_3 = L14_3(L15_3)
            for L18_3, L19_3 in L14_3, L15_3, L16_3, L17_3 do
              L20_3 = #L13_3
              L20_3 = L20_3 + 1
              L13_3[L20_3] = L19_3
            end
            L14_3 = MySQL
            L14_3 = L14_3.update
            L14_3 = L14_3.await
            L15_3 = "UPDATE apex_phone_messages SET delivered_at = ? WHERE delivered_at IS NULL AND id IN (%s)"
            L16_3 = L15_3
            L15_3 = L15_3.format
            L17_3 = L2_1
            L18_3 = #L11_3
            L17_3, L18_3, L19_3, L20_3, L21_3, L22_3, L23_3, L24_3, L25_3, L26_3, L27_3, L28_3, L29_3, L30_3, L31_3, L32_3 = L17_3(L18_3)
            L15_3 = L15_3(L16_3, L17_3, L18_3, L19_3, L20_3, L21_3, L22_3, L23_3, L24_3, L25_3, L26_3, L27_3, L28_3, L29_3, L30_3, L31_3, L32_3)
            L16_3 = L13_3
            L14_3(L15_3, L16_3)
            L14_3 = pairs
            L15_3 = L12_3
            L14_3, L15_3, L16_3, L17_3 = L14_3(L15_3)
            for L18_3, L19_3 in L14_3, L15_3, L16_3, L17_3 do
              L20_3 = L36_1
              L21_3 = L19_3.conv
              L20_3 = L20_3(L21_3)
              if not L20_3 then
                L20_3 = "sms"
              end
              L21_3 = L23_1
              L22_3 = L20_3
              L23_3 = L19_3.sender
              L21_3 = L21_3(L22_3, L23_3)
              if L21_3 then
                L22_3 = A0_2
                if L21_3 ~= L22_3 then
                  L22_3 = Push
                  L23_3 = L21_3
                  L24_3 = "messageStatus"
                  L25_3 = {}
                  L26_3 = L19_3.conv
                  L25_3.conversation = L26_3
                  L26_3 = L19_3.ids
                  L25_3.ids = L26_3
                  L25_3.status = "delivered"
                  L25_3.at = L2_3
                  L25_3.app = L20_3
                  L22_3(L23_3, L24_3, L25_3)
                end
              end
            end
          end
        end
      end
    end
    L11_3 = pcall
    L12_3 = MySQL
    L12_3 = L12_3.scalar
    L12_3 = L12_3.await
    L13_3 = [[
SELECT m.id FROM apex_phone_conversation_members cm
            JOIN apex_phone_messages m ON m.conversation_id = cm.conversation_id AND m.id > COALESCE(cm.last_read_id, 0)
            WHERE cm.member = ? AND cm.left_at IS NULL AND m.sender <> ? AND m.type <> 'system' AND m.deleted_all IS NULL
              AND m.created > ? LIMIT 1]]
    L14_3 = {}
    L15_3 = L1_3
    L16_3 = L1_3
    L17_3 = L7_3
    L14_3[1] = L15_3
    L14_3[2] = L16_3
    L14_3[3] = L17_3
    L11_3, L12_3 = L11_3(L12_3, L13_3, L14_3)
    L8_3 = L11_3 or L8_3
    L8_3 = L11_3 and nil ~= L12_3
    if 0 == L4_3 and not L8_3 then
      return
    end
    L13_3 = {}
    L14_3 = ipairs
    L15_3 = MySQL
    L15_3 = L15_3.query
    L15_3 = L15_3.await
    L16_3 = "SELECT other FROM apex_phone_thread_meta WHERE owner = ? AND app = 'sms' AND muted_until > ? LIMIT 1000"
    L17_3 = {}
    L18_3 = L1_3
    L19_3 = L2_3
    L17_3[1] = L18_3
    L17_3[2] = L19_3
    L15_3 = L15_3(L16_3, L17_3)
    if not L15_3 then
      L15_3 = {}
    end
    L14_3, L15_3, L16_3, L17_3 = L14_3(L15_3)
    for L18_3, L19_3 in L14_3, L15_3, L16_3, L17_3 do
      L20_3 = L19_3.other
      L13_3[L20_3] = true
    end
    L14_3 = MySQL
    L14_3 = L14_3.query
    L14_3 = L14_3.await
    L15_3 = "SELECT sender, COUNT(*) AS n FROM apex_phone_messages WHERE receiver = ? AND `read` = 0 AND app = 'sms' AND deleted_receiver = 0 AND conversation_id IS NULL GROUP BY sender LIMIT 200"
    L16_3 = {}
    L17_3 = L1_3
    L16_3[1] = L17_3
    L14_3 = L14_3(L15_3, L16_3)
    if not L14_3 then
      L14_3 = {}
    end
    L15_3 = 0
    L16_3 = 0
    L17_3 = nil
    L18_3 = nil
    L19_3 = ipairs
    L20_3 = L14_3
    L19_3, L20_3, L21_3, L22_3 = L19_3(L20_3)
    for L23_3, L24_3 in L19_3, L20_3, L21_3, L22_3 do
      L25_3 = L24_3.sender
      if L25_3 ~= L1_3 then
        L25_3 = L24_3.sender
        L25_3 = L13_3[L25_3]
        if not L25_3 then
          L25_3 = math
          L25_3 = L25_3.tointeger
          L26_3 = tonumber
          L27_3 = L24_3.n
          L26_3 = L26_3(L27_3)
          if not L26_3 then
            L26_3 = 0
          end
          L25_3 = L25_3(L26_3)
          if not L25_3 then
            L25_3 = 0
          end
          L15_3 = L15_3 + L25_3
          L16_3 = L16_3 + 1
          L17_3 = L24_3.sender
        end
      end
    end
    L19_3 = type
    L20_3 = GroupListFor
    L19_3 = L19_3(L20_3)
    if "function" == L19_3 then
      L19_3 = pcall
      L20_3 = GroupListFor
      L21_3 = L1_3
      L22_3 = "sms"
      L19_3, L20_3 = L19_3(L20_3, L21_3, L22_3)
      L21_3 = ipairs
      if L19_3 then
        L22_3 = type
        L23_3 = L20_3
        L22_3 = L22_3(L23_3)
        if "table" == L22_3 and L20_3 then
          goto lbl_479
          L22_3 = L20_3 or L22_3
        end
      end
      L22_3 = {}
      ::lbl_479::
      L21_3, L22_3, L23_3, L24_3 = L21_3(L22_3)
      for L25_3, L26_3 in L21_3, L22_3, L23_3, L24_3 do
        L27_3 = math
        L27_3 = L27_3.tointeger
        L28_3 = tonumber
        L29_3 = L26_3.unread
        L28_3 = L28_3(L29_3)
        if not L28_3 then
          L28_3 = 0
        end
        L27_3 = L27_3(L28_3)
        if not L27_3 then
          L27_3 = 0
        end
        L28_3 = L1_1
        L29_3 = L26_3.id
        L28_3 = L28_3(L29_3)
        L29_3 = tonumber
        L30_3 = L26_3.mutedUntil
        L29_3 = L29_3(L30_3)
        if not L29_3 then
          L29_3 = 0
        end
        L29_3 = L2_3 < L29_3
        L30_3 = L1_1
        L31_3 = L26_3.clearedBefore
        L30_3 = L30_3(L31_3)
        L31_3 = L1_1
        L32_3 = L26_3.lastId
        L31_3 = L31_3(L32_3)
        if L28_3 and L27_3 > 0 and not L29_3 and (not (L30_3 and L31_3) or not (L30_3 >= L31_3)) then
          L15_3 = L15_3 + L27_3
          L16_3 = L16_3 + 1
          L18_3 = L26_3
        end
      end
    end
    if 0 == L15_3 then
      return
    end
    L19_3 = nil
    L20_3 = nil
    L21_3 = nil
    if 1 == L16_3 and L18_3 then
      L22_3 = L3_1
      L23_3 = L18_3.title
      if not L23_3 then
        L23_3 = "Grupo"
      end
      L24_3 = 80
      L22_3 = L22_3(L23_3, L24_3)
      L19_3 = L22_3
      if 1 == L15_3 then
        L22_3 = "1 mensagem por ler"
        if L22_3 then
          goto lbl_558
          L20_3 = L22_3 or L20_3
        end
      end
      L22_3 = "%d mensagens por ler"
      L23_3 = L22_3
      L22_3 = L22_3.format
      L24_3 = L15_3
      L22_3 = L22_3(L23_3, L24_3)
      L20_3 = L22_3
      ::lbl_558::
      L22_3 = {}
      L23_3 = L1_1
      L24_3 = L18_3.id
      L23_3 = L23_3(L24_3)
      L22_3.conversation = L23_3
      L22_3.app = "sms"
      L23_3 = L1_1
      L24_3 = L18_3.id
      L23_3 = L23_3(L24_3)
      L22_3.group = L23_3
      L21_3 = L22_3
    elseif 1 == L16_3 then
      L22_3 = MySQL
      L22_3 = L22_3.single
      L22_3 = L22_3.await
      L23_3 = "SELECT name FROM apex_phone_contacts WHERE owner = ? AND number = ? LIMIT 1"
      L24_3 = {}
      L25_3 = L0_3
      L26_3 = L17_3
      L24_3[1] = L25_3
      L24_3[2] = L26_3
      L22_3 = L22_3(L23_3, L24_3)
      if L22_3 then
        L23_3 = L22_3.name
        if L23_3 then
          goto lbl_589
          L19_3 = L23_3 or L19_3
        end
      end
      L19_3 = L17_3
      ::lbl_589::
      if 1 == L15_3 then
        L23_3 = "1 mensagem por ler"
        if L23_3 then
          goto lbl_599
          L20_3 = L23_3 or L20_3
        end
      end
      L23_3 = "%d mensagens por ler"
      L24_3 = L23_3
      L23_3 = L23_3.format
      L25_3 = L15_3
      L23_3 = L23_3(L24_3, L25_3)
      L20_3 = L23_3
      ::lbl_599::
      L23_3 = {}
      L23_3.number = L17_3
      L21_3 = L23_3
    else
      L19_3 = "Mensagens"
      L22_3 = "%d mensagens por ler em %d conversas"
      L23_3 = L22_3
      L22_3 = L22_3.format
      L24_3 = L15_3
      L25_3 = L16_3
      L22_3 = L22_3(L23_3, L24_3, L25_3)
      L20_3 = L22_3
      L22_3 = {}
      L22_3.summary = true
      L21_3 = L22_3
    end
    if 1 == L16_3 then
      L22_3 = "m"
      if L22_3 then
        goto lbl_621
      end
    end
    L22_3 = true
    ::lbl_621::
    L21_3.sys = L22_3
    L22_3 = NotifyPlayer
    L23_3 = A0_2
    L24_3 = "messages"
    L25_3 = L19_3
    L26_3 = L20_3
    L27_3 = L21_3
    L22_3(L23_3, L24_3, L25_3, L26_3, L27_3)
  end
  L2_2, L3_2 = L2_2(L3_2)
  L4_2 = L73_1
  L4_2[A0_2] = nil
  if not L2_2 then
    L4_2 = print
    L5_2 = "^3[unique_phone]^0 delivery of pending messages: %s"
    L6_2 = L5_2
    L5_2 = L5_2.format
    L7_2 = tostring
    L8_2 = L3_2
    L7_2, L8_2 = L7_2(L8_2)
    L5_2, L6_2, L7_2, L8_2 = L5_2(L6_2, L7_2, L8_2)
    L4_2(L5_2, L6_2, L7_2, L8_2)
  end
end
L75_1 = FW
L75_1 = L75_1.OnPlayerLoaded
function L76_1(A0_2)
  local L1_2, L2_2
  L1_2 = tonumber
  L2_2 = A0_2
  L1_2 = L1_2(L2_2)
  A0_2 = L1_2
  if not A0_2 then
    return
  end
  L1_2 = CreateThread
  function L2_2()
    local L0_3, L1_3, L2_3
    L0_3 = 0
    while true do
      L1_3 = DBReady
      if not (not L1_3 and L0_3 < 60) then
        break
      end
      L1_3 = Wait
      L2_3 = 1000
      L1_3(L2_3)
      L0_3 = L0_3 + 1
    end
    L1_3 = DBReady
    if not L1_3 then
      return
    end
    L1_3 = L18_1
    L2_3 = A0_2
    L1_3(L2_3)
    L1_3 = Wait
    L2_3 = 6000
    L1_3(L2_3)
    L1_3 = GetPlayerName
    L2_3 = A0_2
    L1_3 = L1_3(L2_3)
    if L1_3 then
      L1_3 = L74_1
      L2_3 = A0_2
      L1_3(L2_3)
    end
  end
  L1_2(L2_2)
end
L75_1(L76_1)
L75_1 = FW
L75_1 = L75_1.OnPlayerDropped
function L76_1(A0_2)
  local L1_2, L2_2
  L1_2 = tonumber
  L2_2 = A0_2
  L1_2 = L1_2(L2_2)
  A0_2 = L1_2
  if not A0_2 then
    return
  end
  L1_2 = L65_1
  L1_2[A0_2] = nil
  L1_2 = L19_1
  L2_2 = A0_2
  L1_2(L2_2)
end
L75_1(L76_1)
L75_1 = CreateThread
function L76_1()
  local L0_2, L1_2, L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2
  while true do
    L0_2 = DBReady
    if L0_2 then
      break
    end
    L0_2 = Wait
    L1_2 = 1000
    L0_2(L1_2)
  end
  L0_2 = 0
  while true do
    L1_2 = {}
    L2_2 = ipairs
    L3_2 = FW
    L3_2 = L3_2.GetPlayers
    L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2 = L3_2()
    L2_2, L3_2, L4_2, L5_2 = L2_2(L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2)
    for L6_2, L7_2 in L2_2, L3_2, L4_2, L5_2 do
      L1_2[L7_2] = true
      L8_2 = L18_1
      L9_2 = L7_2
      L8_2(L9_2)
    end
    L2_2 = pairs
    L3_2 = L14_1
    L2_2, L3_2, L4_2, L5_2 = L2_2(L3_2)
    for L6_2 in L2_2, L3_2, L4_2, L5_2 do
      L7_2 = L1_2[L6_2]
      if not L7_2 then
        L7_2 = L19_1
        L8_2 = L6_2
        L7_2(L8_2)
      end
    end
    L2_2 = pairs
    L3_2 = L65_1
    L2_2, L3_2, L4_2, L5_2 = L2_2(L3_2)
    for L6_2 in L2_2, L3_2, L4_2, L5_2 do
      L7_2 = L1_2[L6_2]
      if not L7_2 then
        L7_2 = L65_1
        L7_2[L6_2] = nil
      end
    end
    L0_2 = L0_2 + 1
    L2_2 = L0_2 % 20
    if 0 == L2_2 then
      L2_2 = os
      L2_2 = L2_2.time
      L2_2 = L2_2()
      L3_2 = pairs
      L4_2 = L29_1
      L3_2, L4_2, L5_2, L6_2 = L3_2(L4_2)
      for L7_2, L8_2 in L3_2, L4_2, L5_2, L6_2 do
        L9_2 = L8_2.t
        L9_2 = L2_2 - L9_2
        L10_2 = 600
        if L9_2 > L10_2 then
          L9_2 = L29_1
          L9_2[L7_2] = nil
        end
      end
      L3_2 = pairs
      L4_2 = L30_1
      L3_2, L4_2, L5_2, L6_2 = L3_2(L4_2)
      for L7_2, L8_2 in L3_2, L4_2, L5_2, L6_2 do
        L9_2 = L8_2.t
        L9_2 = L2_2 - L9_2
        L10_2 = 900
        if L9_2 > L10_2 then
          L9_2 = L30_1
          L9_2[L7_2] = nil
        end
      end
      L3_2 = pairs
      L4_2 = L25_1
      L3_2, L4_2, L5_2, L6_2 = L3_2(L4_2)
      for L7_2, L8_2 in L3_2, L4_2, L5_2, L6_2 do
        L9_2 = L8_2.t
        L9_2 = L2_2 - L9_2
        L10_2 = 900
        if L9_2 > L10_2 then
          L9_2 = L25_1
          L9_2[L7_2] = nil
        end
      end
    end
    L2_2 = Wait
    L3_2 = 30000
    L2_2(L3_2)
  end
end
L75_1(L76_1)
