local L0_1, L1_1, L2_1, L3_1, L4_1, L5_1, L6_1, L7_1, L8_1, L9_1, L10_1, L11_1, L12_1, L13_1, L14_1, L15_1, L16_1, L17_1, L18_1, L19_1, L20_1, L21_1, L22_1, L23_1, L24_1, L25_1, L26_1, L27_1, L28_1, L29_1, L30_1, L31_1, L32_1, L33_1, L34_1, L35_1, L36_1, L37_1, L38_1, L39_1, L40_1, L41_1, L42_1, L43_1, L44_1, L45_1, L46_1, L47_1, L48_1, L49_1, L50_1, L51_1, L52_1
L0_1 = {}
L0_1.sms = true
L0_1.recado = true
L1_1 = 3000
L2_1 = 5000
L3_1 = 8
function L4_1()
  local L0_2, L1_2
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
  return L0_2
end
function L5_1()
  local L0_2, L1_2, L2_2, L3_2
  L0_2 = math
  L0_2 = L0_2.tointeger
  L1_2 = tonumber
  L2_2 = L4_1
  L2_2 = L2_2()
  L2_2 = L2_2.maxGroupMembers
  L1_2, L2_2, L3_2 = L1_2(L2_2)
  L0_2 = L0_2(L1_2, L2_2, L3_2)
  if not L0_2 or L0_2 < 2 then
    L1_2 = 32
    return L1_2
  end
  L1_2 = math
  L1_2 = L1_2.min
  L2_2 = L0_2
  L3_2 = 256
  return L1_2(L2_2, L3_2)
end
function L6_1()
  local L0_2, L1_2, L2_2
  L0_2 = math
  L0_2 = L0_2.tointeger
  L1_2 = tonumber
  L2_2 = L4_1
  L2_2 = L2_2()
  L2_2 = L2_2.maxGroupsPerMember
  L1_2, L2_2 = L1_2(L2_2)
  L0_2 = L0_2(L1_2, L2_2)
  L1_2 = L0_2 or L1_2
  if not (L0_2 and L0_2 > 0) or not L0_2 then
    L1_2 = 100
  end
  return L1_2
end
function L7_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2
  L2_2 = {}
  L2_2.ok = false
  L2_2.error = A0_2
  L3_2 = type
  L4_2 = A1_2
  L3_2 = L3_2(L4_2)
  if "table" == L3_2 then
    L3_2 = pairs
    L4_2 = A1_2
    L3_2, L4_2, L5_2, L6_2 = L3_2(L4_2)
    for L7_2, L8_2 in L3_2, L4_2, L5_2, L6_2 do
      L2_2[L7_2] = L8_2
    end
  end
  return L2_2
end
function L8_1(A0_2)
  local L1_2, L2_2, L3_2
  L1_2 = math
  L1_2 = L1_2.tointeger
  L2_2 = tonumber
  L3_2 = A0_2
  L2_2, L3_2 = L2_2(L3_2)
  L1_2 = L1_2(L2_2, L3_2)
  L2_2 = L1_2 or L2_2
  if not (L1_2 and L1_2 > 0) or not L1_2 then
    L2_2 = nil
  end
  return L2_2
end
function L9_1(A0_2)
  local L1_2, L2_2, L3_2
  L1_2 = type
  L2_2 = A0_2
  L1_2 = L1_2(L2_2)
  if "string" == L1_2 then
    L2_2 = A0_2
    L1_2 = A0_2.match
    L3_2 = "^g:(%d+)$"
    L1_2 = L1_2(L2_2, L3_2)
    A0_2 = L1_2 or A0_2
    if not L1_2 then
    end
  end
  L1_2 = L8_1
  L2_2 = A0_2
  return L1_2(L2_2)
end
function L10_1(A0_2)
  local L1_2, L2_2, L3_2, L4_2
  L1_2 = string
  L1_2 = L1_2.rep
  L2_2 = "?"
  L3_2 = A0_2
  L4_2 = ", "
  return L1_2(L2_2, L3_2, L4_2)
end
function L11_1(A0_2, A1_2)
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
L12_1 = {}
L13_1 = "\226\128[\139-\143]"
L14_1 = "\226\128[\168-\174]"
L15_1 = "\226\129[\160-\175]"
L16_1 = "\239\187\191"
L17_1 = "\194\173"
L18_1 = "\227\133\164"
L19_1 = "\226\160\128"
L12_1[1] = L13_1
L12_1[2] = L14_1
L12_1[3] = L15_1
L12_1[4] = L16_1
L12_1[5] = L17_1
L12_1[6] = L18_1
L12_1[7] = L19_1
function L13_1(A0_2)
  local L1_2, L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2
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
  L1_2 = L11_1
  L2_2 = A0_2
  L3_2 = 400
  L1_2 = L1_2(L2_2, L3_2)
  L3_2 = L1_2
  L2_2 = L1_2.gsub
  L4_2 = "%c"
  L5_2 = " "
  L2_2 = L2_2(L3_2, L4_2, L5_2)
  L1_2 = L2_2
  L2_2 = ipairs
  L3_2 = L12_1
  L2_2, L3_2, L4_2, L5_2 = L2_2(L3_2)
  for L6_2, L7_2 in L2_2, L3_2, L4_2, L5_2 do
    L9_2 = L1_2
    L8_2 = L1_2.gsub
    L10_2 = L7_2
    L11_2 = ""
    L8_2 = L8_2(L9_2, L10_2, L11_2)
    L1_2 = L8_2
  end
  L3_2 = L1_2
  L2_2 = L1_2.gsub
  L4_2 = "\194\160"
  L5_2 = " "
  L2_2 = L2_2(L3_2, L4_2, L5_2)
  L3_2 = L2_2
  L2_2 = L2_2.gsub
  L4_2 = "\227\128\128"
  L5_2 = " "
  L2_2 = L2_2(L3_2, L4_2, L5_2)
  L1_2 = L2_2
  L3_2 = L1_2
  L2_2 = L1_2.gsub
  L4_2 = "%s+"
  L5_2 = " "
  L2_2 = L2_2(L3_2, L4_2, L5_2)
  L1_2 = L2_2
  L3_2 = L1_2
  L2_2 = L1_2.match
  L4_2 = "^%s*(.-)%s*$"
  L2_2 = L2_2(L3_2, L4_2)
  L1_2 = L2_2
  L2_2 = utf8
  L2_2 = L2_2.len
  L3_2 = L1_2
  L2_2 = L2_2(L3_2)
  if not L2_2 or "" == L1_2 then
    L3_2 = nil
    return L3_2
  end
  if L2_2 > 40 then
    L4_2 = L1_2
    L3_2 = L1_2.sub
    L5_2 = 1
    L6_2 = utf8
    L6_2 = L6_2.offset
    L7_2 = L1_2
    L8_2 = 41
    L6_2 = L6_2(L7_2, L8_2)
    L6_2 = L6_2 - 1
    L3_2 = L3_2(L4_2, L5_2, L6_2)
    L4_2 = L3_2
    L3_2 = L3_2.match
    L5_2 = "^(.-)%s*$"
    L3_2 = L3_2(L4_2, L5_2)
    L1_2 = L3_2
  end
  L3_2 = L1_2 or L3_2
  if "" == L1_2 or not L1_2 then
    L3_2 = nil
  end
  return L3_2
end
function L14_1(A0_2)
  local L1_2, L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2
  L1_2 = type
  L2_2 = A0_2
  L1_2 = L1_2(L2_2)
  if "number" == L1_2 then
    L2_2 = math
    L2_2 = L2_2.tointeger
    L3_2 = A0_2
    L2_2 = L2_2(L3_2)
    if not L2_2 or L2_2 < 0 then
      L3_2 = nil
      return L3_2
    end
    L3_2 = tostring
    L4_2 = L2_2
    L3_2 = L3_2(L4_2)
    A0_2 = L3_2
  else
    if "string" == L1_2 then
      L2_2 = #A0_2
      if not (L2_2 > 64) then
        goto lbl_28
      end
    end
    L2_2 = nil
    return L2_2
  end
  ::lbl_28::
  L3_2 = A0_2
  L2_2 = A0_2.match
  L4_2 = "^%s*(.-)%s*$"
  L2_2 = L2_2(L3_2, L4_2)
  L3_2 = #L2_2
  if not (L3_2 < 3) then
    L3_2 = #L2_2
    if not (L3_2 > 20) then
      L4_2 = L2_2
      L3_2 = L2_2.match
      L5_2 = "^[%d%+%-%.%(%) ]+$"
      L3_2 = L3_2(L4_2, L5_2)
      if L3_2 then
        goto lbl_44
      end
    end
  end
  L3_2 = nil
  do return L3_2 end
  ::lbl_44::
  L3_2 = select
  L4_2 = 2
  L6_2 = L2_2
  L5_2 = L2_2.gsub
  L7_2 = "%d"
  L8_2 = ""
  L5_2, L6_2, L7_2, L8_2 = L5_2(L6_2, L7_2, L8_2)
  L3_2 = L3_2(L4_2, L5_2, L6_2, L7_2, L8_2)
  if L3_2 < 3 then
    L3_2 = nil
    return L3_2
  end
  return L2_2
end
function L15_1(A0_2)
  local L1_2, L2_2, L3_2, L4_2
  L1_2 = type
  L2_2 = A0_2
  L1_2 = L1_2(L2_2)
  if "number" == L1_2 then
    L2_2 = math
    L2_2 = L2_2.tointeger
    L3_2 = A0_2
    L2_2 = L2_2(L3_2)
    if L2_2 then
      L3_2 = tostring
      L4_2 = L2_2
      L3_2 = L3_2(L4_2)
      if L3_2 then
        goto lbl_18
      end
    end
    L3_2 = nil
    ::lbl_18::
    return L3_2
  end
  if "string" ~= L1_2 then
    L2_2 = nil
    return L2_2
  end
  L3_2 = A0_2
  L2_2 = A0_2.match
  L4_2 = "^%s*(.-)%s*$"
  L2_2 = L2_2(L3_2, L4_2)
  if "" ~= L2_2 then
    L3_2 = #L2_2
    if not (L3_2 > 40) then
      goto lbl_33
    end
  end
  L3_2 = nil
  do return L3_2 end
  ::lbl_33::
  return L2_2
end
function L16_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2
  L2_2 = nil
  L3_2 = type
  L4_2 = GetIdentity
  L3_2 = L3_2(L4_2)
  if "function" == L3_2 then
    L3_2 = GetIdentity
    L4_2 = A0_2
    L5_2 = A1_2 or L5_2
    if not A1_2 then
      L5_2 = "sms"
    end
    L3_2 = L3_2(L4_2, L5_2)
    L2_2 = L3_2
  else
    L3_2 = GetPlayerNumber
    L4_2 = A0_2
    L3_2 = L3_2(L4_2)
    L2_2 = L3_2
  end
  if nil == L2_2 or "" == L2_2 then
    L3_2 = nil
    return L3_2
  end
  L3_2 = tostring
  L4_2 = L2_2
  return L3_2(L4_2)
end
L17_1 = nil
L18_1 = 0
function L19_1()
  local L0_2, L1_2, L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2
  L0_2 = OnlineNumberIndex
  if L0_2 then
    L0_2 = OnlineNumberIndex
    L0_2 = L0_2()
    L0_2 = L0_2.byStr
    return L0_2
  end
  L0_2 = GetGameTimer
  L0_2 = L0_2()
  L1_2 = L17_1
  if L1_2 then
    L1_2 = L18_1
    L1_2 = L0_2 - L1_2
    L2_2 = 2000
    if L1_2 < L2_2 then
      L1_2 = L17_1
      return L1_2
    end
  end
  L1_2 = {}
  L2_2 = ipairs
  L3_2 = FW
  L3_2 = L3_2.GetPlayers
  L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2 = L3_2()
  L2_2, L3_2, L4_2, L5_2 = L2_2(L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2)
  for L6_2, L7_2 in L2_2, L3_2, L4_2, L5_2 do
    L8_2 = GetPlayerNumber
    L9_2 = L7_2
    L8_2 = L8_2(L9_2)
    if nil ~= L8_2 and "" ~= L8_2 then
      L9_2 = tostring
      L10_2 = L8_2
      L9_2 = L9_2(L10_2)
      L10_2 = tonumber
      L11_2 = L7_2
      L10_2 = L10_2(L11_2)
      L1_2[L9_2] = L10_2
    end
  end
  L2_2 = L1_2
  L18_1 = L0_2
  L17_1 = L2_2
  return L1_2
end
function L20_1(A0_2)
  local L1_2, L2_2, L3_2, L4_2
  L1_2 = MySQL
  L1_2 = L1_2.single
  L1_2 = L1_2.await
  L2_2 = "SELECT id, app, title, avatar, created_by, created, last_id FROM apex_phone_conversations WHERE id = ?"
  L3_2 = {}
  L4_2 = A0_2
  L3_2[1] = L4_2
  L1_2 = L1_2(L2_2, L3_2)
  if not L1_2 then
    L2_2 = nil
    return L2_2
  end
  L2_2 = math
  L2_2 = L2_2.tointeger
  L3_2 = tonumber
  L4_2 = L1_2.id
  L3_2, L4_2 = L3_2(L4_2)
  L2_2 = L2_2(L3_2, L4_2)
  if not L2_2 then
    L2_2 = A0_2
  end
  L1_2.id = L2_2
  L2_2 = L1_2.app
  if not L2_2 then
    L2_2 = "sms"
  end
  L1_2.app = L2_2
  L2_2 = math
  L2_2 = L2_2.tointeger
  L3_2 = tonumber
  L4_2 = L1_2.avatar
  L3_2, L4_2 = L3_2(L4_2)
  L2_2 = L2_2(L3_2, L4_2)
  L1_2.avatar = L2_2
  L2_2 = math
  L2_2 = L2_2.tointeger
  L3_2 = tonumber
  L4_2 = L1_2.last_id
  L3_2, L4_2 = L3_2(L4_2)
  L2_2 = L2_2(L3_2, L4_2)
  L1_2.last_id = L2_2
  L2_2 = tonumber
  L3_2 = L1_2.created
  L2_2 = L2_2(L3_2)
  L1_2.created = L2_2
  return L1_2
end
function L21_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2, L6_2
  L2_2 = MySQL
  L2_2 = L2_2.single
  L2_2 = L2_2.await
  L3_2 = "SELECT role, joined, last_read_id FROM apex_phone_conversation_members WHERE conversation_id = ? AND member = ? AND left_at IS NULL"
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
  L3_2 = {}
  L4_2 = L2_2.role
  if "admin" == L4_2 then
    L4_2 = "admin"
    if L4_2 then
      goto lbl_24
    end
  end
  L4_2 = "member"
  ::lbl_24::
  L3_2.role = L4_2
  L4_2 = tonumber
  L5_2 = L2_2.joined
  L4_2 = L4_2(L5_2)
  L3_2.joined = L4_2
  L4_2 = math
  L4_2 = L4_2.tointeger
  L5_2 = tonumber
  L6_2 = L2_2.last_read_id
  L5_2, L6_2 = L5_2(L6_2)
  L4_2 = L4_2(L5_2, L6_2)
  L3_2.lastReadId = L4_2
  return L3_2
end
function L22_1(A0_2)
  local L1_2, L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2
  L1_2 = MySQL
  L1_2 = L1_2.query
  L1_2 = L1_2.await
  L2_2 = "SELECT member, role, joined, last_read_id FROM apex_phone_conversation_members WHERE conversation_id = ? AND left_at IS NULL ORDER BY joined ASC, member ASC"
  L3_2 = {}
  L4_2 = A0_2
  L3_2[1] = L4_2
  L1_2 = L1_2(L2_2, L3_2)
  if not L1_2 then
    L1_2 = {}
  end
  L2_2 = {}
  L3_2 = ipairs
  L4_2 = L1_2
  L3_2, L4_2, L5_2, L6_2 = L3_2(L4_2)
  for L7_2, L8_2 in L3_2, L4_2, L5_2, L6_2 do
    L9_2 = #L2_2
    L9_2 = L9_2 + 1
    L10_2 = {}
    L11_2 = tostring
    L12_2 = L8_2.member
    L11_2 = L11_2(L12_2)
    L10_2.member = L11_2
    L11_2 = L8_2.role
    if "admin" == L11_2 then
      L11_2 = "admin"
      if L11_2 then
        goto lbl_36
      end
    end
    L11_2 = "member"
    ::lbl_36::
    L10_2.role = L11_2
    L11_2 = tonumber
    L12_2 = L8_2.joined
    L11_2 = L11_2(L12_2)
    L10_2.joined = L11_2
    L11_2 = math
    L11_2 = L11_2.tointeger
    L12_2 = tonumber
    L13_2 = L8_2.last_read_id
    L12_2, L13_2 = L12_2(L13_2)
    L11_2 = L11_2(L12_2, L13_2)
    L10_2.lastReadId = L11_2
    L2_2[L9_2] = L10_2
  end
  return L2_2
end
function L23_1(A0_2, A1_2, A2_2)
  local L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2
  L3_2 = L20_1
  L4_2 = A1_2
  L3_2 = L3_2(L4_2)
  if L3_2 then
    L5_2 = L3_2.app
    L4_2 = L0_1
    L4_2 = L4_2[L5_2]
    if L4_2 then
      goto lbl_14
    end
  end
  L4_2 = nil
  L5_2 = nil
  L6_2 = nil
  L7_2 = "notfound"
  do return L4_2, L5_2, L6_2, L7_2 end
  ::lbl_14::
  L4_2 = L16_1
  L5_2 = A0_2
  L6_2 = L3_2.app
  L4_2 = L4_2(L5_2, L6_2)
  if not L4_2 then
    L5_2 = nil
    L6_2 = nil
    L7_2 = nil
    L8_2 = "noidentity"
    return L5_2, L6_2, L7_2, L8_2
  end
  L5_2 = L21_1
  L6_2 = A1_2
  L7_2 = L4_2
  L5_2 = L5_2(L6_2, L7_2)
  if not L5_2 then
    L6_2 = nil
    L7_2 = nil
    L8_2 = nil
    L9_2 = "notfound"
    return L6_2, L7_2, L8_2, L9_2
  end
  if A2_2 then
    L6_2 = L5_2.role
    if "admin" ~= L6_2 then
      L6_2 = nil
      L7_2 = nil
      L8_2 = nil
      L9_2 = "notadmin"
      return L6_2, L7_2, L8_2, L9_2
    end
  end
  L6_2 = L3_2
  L7_2 = L4_2
  L8_2 = L5_2
  return L6_2, L7_2, L8_2
end
L24_1 = {}
function L25_1(A0_2, A1_2, ...)
  local L2_2, L3_2, L4_2, L5_2, L6_2, L7_2
  L2_2 = 0
  while true do
    L3_2 = L24_1
    L3_2 = L3_2[A0_2]
    if not L3_2 then
      break
    end
    L3_2 = L2_1
    if L2_2 >= L3_2 then
      L3_2 = L7_1
      L4_2 = "busy"
      return L3_2(L4_2)
    end
    L3_2 = Wait
    L4_2 = 50
    L3_2(L4_2)
    L2_2 = L2_2 + 50
  end
  L3_2 = L24_1
  L3_2[A0_2] = true
  L3_2 = table
  L3_2 = L3_2.pack
  L4_2 = pcall
  L5_2 = A1_2
  L6_2, L7_2 = ...
  L4_2, L5_2, L6_2, L7_2 = L4_2(L5_2, L6_2, L7_2)
  L3_2 = L3_2(L4_2, L5_2, L6_2, L7_2)
  L4_2 = L24_1
  L4_2[A0_2] = nil
  L4_2 = L3_2[1]
  if not L4_2 then
    L4_2 = error
    L5_2 = L3_2[2]
    L6_2 = 0
    L4_2(L5_2, L6_2)
  end
  L4_2 = table
  L4_2 = L4_2.unpack
  L5_2 = L3_2
  L6_2 = 2
  L7_2 = L3_2.n
  return L4_2(L5_2, L6_2, L7_2)
end
GroupWithLock = L25_1
function L26_1(A0_2)
  local L1_2, L2_2
  L1_2 = type
  L2_2 = A0_2
  L1_2 = L1_2(L2_2)
  L1_2 = "table" == L1_2
  return L1_2
end
L27_1 = {}
L28_1 = "app"
L29_1 = "sender"
L30_1 = "receiver"
L31_1 = "type"
L32_1 = "content"
L33_1 = "payload"
L34_1 = "read"
L35_1 = "created"
L36_1 = "reply_to"
L37_1 = "conversation_id"
L27_1[1] = L28_1
L27_1[2] = L29_1
L27_1[3] = L30_1
L27_1[4] = L31_1
L27_1[5] = L32_1
L27_1[6] = L33_1
L27_1[7] = L34_1
L27_1[8] = L35_1
L27_1[9] = L36_1
L27_1[10] = L37_1
function L28_1(A0_2)
  local L1_2, L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2
  L1_2 = {}
  L2_2 = {}
  L3_2 = {}
  L4_2 = ipairs
  L5_2 = L27_1
  L4_2, L5_2, L6_2, L7_2 = L4_2(L5_2)
  for L8_2, L9_2 in L4_2, L5_2, L6_2, L7_2 do
    L10_2 = A0_2[L9_2]
    if nil ~= L10_2 then
      L11_2 = #L1_2
      L11_2 = L11_2 + 1
      L12_2 = "`"
      L13_2 = L9_2
      L14_2 = "`"
      L12_2 = L12_2 .. L13_2 .. L14_2
      L1_2[L11_2] = L12_2
      L11_2 = #L2_2
      L11_2 = L11_2 + 1
      L2_2[L11_2] = "?"
      L11_2 = #L3_2
      L11_2 = L11_2 + 1
      L3_2[L11_2] = L10_2
    end
  end
  L4_2 = MySQL
  L4_2 = L4_2.insert
  L4_2 = L4_2.await
  L5_2 = "INSERT INTO apex_phone_messages (%s) VALUES (%s)"
  L6_2 = L5_2
  L5_2 = L5_2.format
  L7_2 = table
  L7_2 = L7_2.concat
  L8_2 = L1_2
  L9_2 = ", "
  L7_2 = L7_2(L8_2, L9_2)
  L8_2 = table
  L8_2 = L8_2.concat
  L9_2 = L2_2
  L10_2 = ", "
  L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2 = L8_2(L9_2, L10_2)
  L5_2 = L5_2(L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2)
  L6_2 = L3_2
  return L4_2(L5_2, L6_2)
end
function L29_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2, L6_2, L7_2
  L2_2 = MySQL
  L2_2 = L2_2.update
  L2_2 = L2_2.await
  L3_2 = "UPDATE apex_phone_conversations SET last_id = ? WHERE id = ? AND (last_id IS NULL OR last_id < ?)"
  L4_2 = {}
  L5_2 = A1_2
  L6_2 = A0_2.id
  L7_2 = A1_2
  L4_2[1] = L5_2
  L4_2[2] = L6_2
  L4_2[3] = L7_2
  L2_2(L3_2, L4_2)
  L2_2 = A0_2.last_id
  if L2_2 then
    L2_2 = A0_2.last_id
    if not (A1_2 > L2_2) then
      goto lbl_19
    end
  end
  A0_2.last_id = A1_2
  ::lbl_19::
end
L30_1 = {}
L30_1.image = "\240\159\147\183 Foto"
L30_1.audio = "\240\159\142\164 Mensagem de voz"
L30_1.location = "\240\159\147\141 Localiza\195\167\195\163o"
function L31_1(A0_2)
  local L1_2, L2_2, L3_2, L4_2, L5_2
  L1_2 = {}
  L2_2 = math
  L2_2 = L2_2.tointeger
  L3_2 = tonumber
  L4_2 = A0_2.id
  L3_2, L4_2, L5_2 = L3_2(L4_2)
  L2_2 = L2_2(L3_2, L4_2, L5_2)
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
      L3_2 = L11_1
      L4_2 = A0_2.content
      L5_2 = 60
      L3_2 = L3_2(L4_2, L5_2)
      L2_2 = L2_2 .. L3_2
      L1_2.preview = L2_2
    else
      L3_2 = A0_2.type
      L2_2 = L30_1
      L2_2 = L2_2[L3_2]
      if not L2_2 then
        L2_2 = L11_1
        L3_2 = A0_2.content
        L4_2 = 80
        L2_2 = L2_2(L3_2, L4_2)
      end
      L1_2.preview = L2_2
    end
  end
  return L1_2
end
function L32_1(A0_2)
  local L1_2, L2_2, L3_2, L4_2, L5_2
  L1_2 = {}
  L2_2 = math
  L2_2 = L2_2.tointeger
  L3_2 = tonumber
  L4_2 = A0_2.id
  L3_2, L4_2, L5_2 = L3_2(L4_2)
  L2_2 = L2_2(L3_2, L4_2, L5_2)
  L1_2.id = L2_2
  L2_2 = A0_2.app
  L1_2.app = L2_2
  L2_2 = A0_2.sender
  L1_2.sender = L2_2
  L2_2 = A0_2.receiver
  L1_2.receiver = L2_2
  L2_2 = A0_2.type
  if not L2_2 then
    L2_2 = "text"
  end
  L1_2.type = L2_2
  L2_2 = A0_2.content
  if not L2_2 then
    L2_2 = ""
  end
  L1_2.content = L2_2
  L2_2 = tonumber
  L3_2 = A0_2.created
  L2_2 = L2_2(L3_2)
  L1_2.created = L2_2
  L2_2 = math
  L2_2 = L2_2.tointeger
  L3_2 = tonumber
  L4_2 = A0_2.conversation_id
  L3_2, L4_2, L5_2 = L3_2(L4_2)
  L2_2 = L2_2(L3_2, L4_2, L5_2)
  L1_2.conversation = L2_2
  L2_2 = type
  L3_2 = A0_2.payload
  L2_2 = L2_2(L3_2)
  if "string" == L2_2 then
    L2_2 = A0_2.payload
    if "" ~= L2_2 then
      L2_2 = pcall
      L3_2 = json
      L3_2 = L3_2.decode
      L4_2 = A0_2.payload
      L2_2, L3_2 = L2_2(L3_2, L4_2)
      if L2_2 then
        L4_2 = type
        L5_2 = L3_2
        L4_2 = L4_2(L5_2)
        if "table" == L4_2 then
          L1_2.payload = L3_2
        end
      end
    end
  end
  L2_2 = A0_2.edited_at
  if L2_2 then
    L2_2 = tonumber
    L3_2 = A0_2.edited_at
    L2_2 = L2_2(L3_2)
    L1_2.editedAt = L2_2
  end
  L2_2 = A0_2.deleted_all
  if L2_2 then
    L2_2 = true
    L3_2 = ""
    L1_2.payload = nil
    L1_2.content = L3_2
    L1_2.deleted = L2_2
  end
  return L1_2
end
function L33_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2
  L2_2 = L9_1
  L3_2 = A0_2
  L2_2 = L2_2(L3_2)
  if not L2_2 or nil == A1_2 or "" == A1_2 then
    L3_2 = false
    return L3_2
  end
  L3_2 = MySQL
  L3_2 = L3_2.scalar
  L3_2 = L3_2.await
  L4_2 = "SELECT 1 FROM apex_phone_conversation_members WHERE conversation_id = ? AND member = ? AND left_at IS NULL"
  L5_2 = {}
  L6_2 = L2_2
  L7_2 = tostring
  L8_2 = A1_2
  L7_2, L8_2 = L7_2(L8_2)
  L5_2[1] = L6_2
  L5_2[2] = L7_2
  L5_2[3] = L8_2
  L3_2 = L3_2(L4_2, L5_2)
  L3_2 = nil ~= L3_2
  return L3_2
end
IsGroupMember = L33_1
function L33_1(A0_2)
  local L1_2, L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2
  L1_2 = L9_1
  L2_2 = A0_2
  L1_2 = L1_2(L2_2)
  if not L1_2 then
    L2_2 = {}
    return L2_2
  end
  L2_2 = {}
  L3_2 = ipairs
  L4_2 = L22_1
  L5_2 = L1_2
  L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2 = L4_2(L5_2)
  L3_2, L4_2, L5_2, L6_2 = L3_2(L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2)
  for L7_2, L8_2 in L3_2, L4_2, L5_2, L6_2 do
    L9_2 = #L2_2
    L9_2 = L9_2 + 1
    L10_2 = L8_2.member
    L2_2[L9_2] = L10_2
  end
  return L2_2
end
GroupMembers = L33_1
function L33_1(A0_2)
  local L1_2, L2_2, L3_2, L4_2
  L1_2 = L9_1
  L2_2 = A0_2
  L1_2 = L1_2(L2_2)
  L2_2 = L1_2 or L2_2
  if L1_2 then
    L2_2 = L20_1
    L3_2 = L1_2
    L2_2 = L2_2(L3_2)
  end
  if not L2_2 then
    L3_2 = nil
    return L3_2
  end
  L3_2 = {}
  L4_2 = L2_2.id
  L3_2.id = L4_2
  L4_2 = L2_2.app
  L3_2.app = L4_2
  L4_2 = L2_2.title
  L3_2.title = L4_2
  L4_2 = L2_2.avatar
  L3_2.avatar = L4_2
  L4_2 = L2_2.created_by
  L3_2.createdBy = L4_2
  L4_2 = L2_2.created
  L3_2.created = L4_2
  L4_2 = L2_2.last_id
  L3_2.lastId = L4_2
  return L3_2
end
GroupInfo = L33_1
function L33_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2, L6_2
  L2_2 = L9_1
  L3_2 = A0_2
  L2_2 = L2_2(L3_2)
  if not L2_2 or nil == A1_2 or "" == A1_2 then
    L3_2 = nil
    return L3_2
  end
  L3_2 = L21_1
  L4_2 = L2_2
  L5_2 = tostring
  L6_2 = A1_2
  L5_2, L6_2 = L5_2(L6_2)
  return L3_2(L4_2, L5_2, L6_2)
end
GroupMembership = L33_1
function L33_1(A0_2)
  local L1_2, L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2
  L1_2 = L9_1
  L2_2 = A0_2
  L1_2 = L1_2(L2_2)
  if not L1_2 then
    L2_2 = {}
    return L2_2
  end
  L2_2 = {}
  L3_2 = ipairs
  L4_2 = L22_1
  L5_2 = L1_2
  L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2 = L4_2(L5_2)
  L3_2, L4_2, L5_2, L6_2 = L3_2(L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2)
  for L7_2, L8_2 in L3_2, L4_2, L5_2, L6_2 do
    L9_2 = #L2_2
    L9_2 = L9_2 + 1
    L10_2 = {}
    L11_2 = L8_2.member
    L10_2.member = L11_2
    L11_2 = L8_2.lastReadId
    if not L11_2 then
      L11_2 = 0
    end
    L10_2.lastReadId = L11_2
    L2_2[L9_2] = L10_2
  end
  return L2_2
end
GroupReadState = L33_1
function L33_1(A0_2, A1_2, A2_2)
  local L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2
  L3_2 = L9_1
  L4_2 = A0_2
  L3_2 = L3_2(L4_2)
  if not L3_2 or nil == A1_2 or "" == A1_2 then
    L4_2 = nil
    return L4_2
  end
  L4_2 = math
  L4_2 = L4_2.tointeger
  L5_2 = tonumber
  L6_2 = MySQL
  L6_2 = L6_2.scalar
  L6_2 = L6_2.await
  L7_2 = "SELECT last_id FROM apex_phone_conversations WHERE id = ?"
  L8_2 = {}
  L9_2 = L3_2
  L8_2[1] = L9_2
  L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2 = L6_2(L7_2, L8_2)
  L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2 = L5_2(L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2)
  L4_2 = L4_2(L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2)
  if not L4_2 then
    L4_2 = 0
  end
  L5_2 = L8_1
  L6_2 = A2_2
  L5_2 = L5_2(L6_2)
  if not L5_2 or L4_2 < L5_2 then
    L5_2 = L4_2
  end
  if L5_2 <= 0 then
    L6_2 = 0
    return L6_2
  end
  L6_2 = MySQL
  L6_2 = L6_2.update
  L6_2 = L6_2.await
  L7_2 = "UPDATE apex_phone_conversation_members SET last_read_id = ? WHERE conversation_id = ? AND member = ? AND left_at IS NULL AND (last_read_id IS NULL OR last_read_id < ?)"
  L8_2 = {}
  L9_2 = L5_2
  L10_2 = L3_2
  L11_2 = tostring
  L12_2 = A1_2
  L11_2 = L11_2(L12_2)
  L12_2 = L5_2
  L8_2[1] = L9_2
  L8_2[2] = L10_2
  L8_2[3] = L11_2
  L8_2[4] = L12_2
  L6_2(L7_2, L8_2)
  return L5_2
end
GroupMarkRead = L33_1
function L33_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2
  L2_2 = L8_1
  L3_2 = A1_2
  L2_2 = L2_2(L3_2)
  if not L2_2 then
    L3_2 = false
    return L3_2
  end
  L3_2 = L16_1
  L4_2 = A0_2
  L5_2 = "sms"
  L3_2 = L3_2(L4_2, L5_2)
  if not L3_2 then
    L4_2 = false
    return L4_2
  end
  L4_2 = MySQL
  L4_2 = L4_2.scalar
  L4_2 = L4_2.await
  L5_2 = [[
SELECT 1 FROM apex_phone_conversations c JOIN apex_phone_conversation_members m ON m.conversation_id = c.id
        WHERE c.avatar = ? AND m.member = ? AND m.left_at IS NULL LIMIT 1]]
  L6_2 = {}
  L7_2 = L2_2
  L8_2 = L3_2
  L6_2[1] = L7_2
  L6_2[2] = L8_2
  L4_2 = L4_2(L5_2, L6_2)
  L4_2 = nil ~= L4_2
  return L4_2
end
GroupCanSeeMedia = L33_1
function L33_1(A0_2, A1_2, A2_2, A3_2)
  local L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2
  L4_2 = L9_1
  L5_2 = A0_2
  L4_2 = L4_2(L5_2)
  if L4_2 then
    L5_2 = type
    L6_2 = A1_2
    L5_2 = L5_2(L6_2)
    if "string" == L5_2 and "" ~= A1_2 then
      goto lbl_15
    end
  end
  L5_2 = 0
  do return L5_2 end
  ::lbl_15::
  L5_2 = {}
  L6_2 = type
  L7_2 = A3_2
  L6_2 = L6_2(L7_2)
  if "table" == L6_2 then
    L6_2 = pairs
    L7_2 = A3_2
    L6_2, L7_2, L8_2, L9_2 = L6_2(L7_2)
    for L10_2, L11_2 in L6_2, L7_2, L8_2, L9_2 do
      L12_2 = type
      L13_2 = L10_2
      L12_2 = L12_2(L13_2)
      if "string" == L12_2 and L11_2 then
        L5_2[L10_2] = true
      else
        L12_2 = type
        L13_2 = L11_2
        L12_2 = L12_2(L13_2)
        if "string" ~= L12_2 then
          L12_2 = type
          L13_2 = L11_2
          L12_2 = L12_2(L13_2)
          if "number" ~= L12_2 then
            goto lbl_49
          end
        end
        L12_2 = tostring
        L13_2 = L11_2
        L12_2 = L12_2(L13_2)
        L5_2[L12_2] = true
      end
      ::lbl_49::
    end
  elseif nil ~= A3_2 then
    L6_2 = tostring
    L7_2 = A3_2
    L6_2 = L6_2(L7_2)
    L5_2[L6_2] = true
  end
  L6_2 = L19_1
  L6_2 = L6_2()
  L7_2 = 0
  L8_2 = ipairs
  L9_2 = GroupMembers
  L10_2 = L4_2
  L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2 = L9_2(L10_2)
  L8_2, L9_2, L10_2, L11_2 = L8_2(L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2)
  for L12_2, L13_2 in L8_2, L9_2, L10_2, L11_2 do
    L14_2 = L5_2[L13_2]
    L14_2 = not L14_2 and L14_2
    if L14_2 then
      L15_2 = HasPhoneItem
      L16_2 = L14_2
      L15_2 = L15_2(L16_2)
      if L15_2 then
        L15_2 = Push
        L16_2 = L14_2
        L17_2 = A1_2
        L18_2 = A2_2
        L15_2(L16_2, L17_2, L18_2)
        L7_2 = L7_2 + 1
      end
    end
  end
  return L7_2
end
GroupBroadcast = L33_1
function L33_1(A0_2, A1_2, A2_2, A3_2)
  local L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2, L19_2, L20_2, L21_2, L22_2, L23_2, L24_2
  L4_2 = L19_1
  L4_2 = L4_2()
  L5_2 = {}
  L6_2 = ipairs
  L7_2 = GroupMembers
  L8_2 = A0_2.id
  L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2, L19_2, L20_2, L21_2, L22_2, L23_2, L24_2 = L7_2(L8_2)
  L6_2, L7_2, L8_2, L9_2 = L6_2(L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2, L19_2, L20_2, L21_2, L22_2, L23_2, L24_2)
  for L10_2, L11_2 in L6_2, L7_2, L8_2, L9_2 do
    if L11_2 ~= A2_2 then
      L12_2 = L4_2[L11_2]
      if L12_2 then
        L13_2 = HasPhoneItem
        L14_2 = L12_2
        L13_2 = L13_2(L14_2)
        if L13_2 then
          L13_2 = #L5_2
          L13_2 = L13_2 + 1
          L14_2 = {}
          L14_2.who = L11_2
          L14_2.src = L12_2
          L5_2[L13_2] = L14_2
        end
      end
    end
  end
  L6_2 = #L5_2
  if 0 == L6_2 then
    L6_2 = 0
    return L6_2
  end
  L6_2 = {}
  if A3_2 and A2_2 then
    L7_2 = {}
    L8_2 = {}
    L9_2 = {}
    L10_2 = ipairs
    L11_2 = L5_2
    L10_2, L11_2, L12_2, L13_2 = L10_2(L11_2)
    for L14_2, L15_2 in L10_2, L11_2, L12_2, L13_2 do
      L16_2 = #L7_2
      L16_2 = L16_2 + 1
      L17_2 = L15_2.who
      L7_2[L16_2] = L17_2
      L16_2 = GetCid
      L17_2 = L15_2.src
      L16_2 = L16_2(L17_2)
      L15_2.cid = L16_2
      L16_2 = L15_2.cid
      if L16_2 then
        L16_2 = L15_2.cid
        L16_2 = L9_2[L16_2]
        if not L16_2 then
          L16_2 = L15_2.cid
          L9_2[L16_2] = true
          L16_2 = #L8_2
          L16_2 = L16_2 + 1
          L17_2 = L15_2.cid
          L8_2[L16_2] = L17_2
        end
      end
    end
    L10_2 = {}
    L11_2 = A0_2.app
    L12_2 = "g:"
    L13_2 = A0_2.id
    L12_2 = L12_2 .. L13_2
    L13_2 = Now
    L13_2, L14_2, L15_2, L16_2, L17_2, L18_2, L19_2, L20_2, L21_2, L22_2, L23_2, L24_2 = L13_2()
    L10_2[1] = L11_2
    L10_2[2] = L12_2
    L10_2[3] = L13_2
    L10_2[4] = L14_2
    L10_2[5] = L15_2
    L10_2[6] = L16_2
    L10_2[7] = L17_2
    L10_2[8] = L18_2
    L10_2[9] = L19_2
    L10_2[10] = L20_2
    L10_2[11] = L21_2
    L10_2[12] = L22_2
    L10_2[13] = L23_2
    L10_2[14] = L24_2
    L11_2 = ipairs
    L12_2 = L7_2
    L11_2, L12_2, L13_2, L14_2 = L11_2(L12_2)
    for L15_2, L16_2 in L11_2, L12_2, L13_2, L14_2 do
      L17_2 = #L10_2
      L17_2 = L17_2 + 1
      L10_2[L17_2] = L16_2
    end
    L11_2 = pcall
    L12_2 = MySQL
    L12_2 = L12_2.query
    L12_2 = L12_2.await
    L13_2 = "SELECT owner FROM apex_phone_thread_meta WHERE app = ? AND other = ? AND muted_until > ? AND owner IN (%s)"
    L14_2 = L13_2
    L13_2 = L13_2.format
    L15_2 = L10_1
    L16_2 = #L7_2
    L15_2, L16_2, L17_2, L18_2, L19_2, L20_2, L21_2, L22_2, L23_2, L24_2 = L15_2(L16_2)
    L13_2 = L13_2(L14_2, L15_2, L16_2, L17_2, L18_2, L19_2, L20_2, L21_2, L22_2, L23_2, L24_2)
    L14_2 = L10_2
    L11_2, L12_2 = L11_2(L12_2, L13_2, L14_2)
    if L11_2 then
      L13_2 = type
      L14_2 = L12_2
      L13_2 = L13_2(L14_2)
      if "table" == L13_2 then
        L13_2 = ipairs
        L14_2 = L12_2
        L13_2, L14_2, L15_2, L16_2 = L13_2(L14_2)
        for L17_2, L18_2 in L13_2, L14_2, L15_2, L16_2 do
          L19_2 = tostring
          L20_2 = L18_2.owner
          L19_2 = L19_2(L20_2)
          L6_2[L19_2] = true
        end
      end
    end
    L13_2 = #L8_2
    if L13_2 > 0 then
      L13_2 = {}
      L14_2 = A2_2
      L13_2[1] = L14_2
      L14_2 = ipairs
      L15_2 = L8_2
      L14_2, L15_2, L16_2, L17_2 = L14_2(L15_2)
      for L18_2, L19_2 in L14_2, L15_2, L16_2, L17_2 do
        L20_2 = #L13_2
        L20_2 = L20_2 + 1
        L13_2[L20_2] = L19_2
      end
      L14_2 = pcall
      L15_2 = MySQL
      L15_2 = L15_2.query
      L15_2 = L15_2.await
      L16_2 = "SELECT owner FROM apex_phone_blocks WHERE number = ? AND owner IN (%s)"
      L17_2 = L16_2
      L16_2 = L16_2.format
      L18_2 = L10_1
      L19_2 = #L8_2
      L18_2, L19_2, L20_2, L21_2, L22_2, L23_2, L24_2 = L18_2(L19_2)
      L16_2 = L16_2(L17_2, L18_2, L19_2, L20_2, L21_2, L22_2, L23_2, L24_2)
      L17_2 = L13_2
      L14_2, L15_2 = L14_2(L15_2, L16_2, L17_2)
      L16_2 = {}
      if L14_2 then
        L17_2 = type
        L18_2 = L15_2
        L17_2 = L17_2(L18_2)
        if "table" == L17_2 then
          L17_2 = ipairs
          L18_2 = L15_2
          L17_2, L18_2, L19_2, L20_2 = L17_2(L18_2)
          for L21_2, L22_2 in L17_2, L18_2, L19_2, L20_2 do
            L23_2 = tostring
            L24_2 = L22_2.owner
            L23_2 = L23_2(L24_2)
            L16_2[L23_2] = true
          end
        end
      end
      L17_2 = ipairs
      L18_2 = L5_2
      L17_2, L18_2, L19_2, L20_2 = L17_2(L18_2)
      for L21_2, L22_2 in L17_2, L18_2, L19_2, L20_2 do
        L23_2 = L22_2.cid
        if L23_2 then
          L23_2 = L22_2.cid
          L23_2 = L16_2[L23_2]
          if L23_2 then
            L23_2 = L22_2.who
            L6_2[L23_2] = true
          end
        end
      end
    end
  end
  L7_2 = ipairs
  L8_2 = L5_2
  L7_2, L8_2, L9_2, L10_2 = L7_2(L8_2)
  for L11_2, L12_2 in L7_2, L8_2, L9_2, L10_2 do
    L13_2 = L12_2.who
    L13_2 = L6_2[L13_2]
    if not L13_2 then
      L13_2 = nil
    end
    A1_2.muted = L13_2
    L13_2 = Push
    L14_2 = L12_2.src
    L15_2 = "message"
    L16_2 = A1_2
    L13_2(L14_2, L15_2, L16_2)
  end
  A1_2.muted = nil
  L7_2 = #L5_2
  return L7_2
end
function L34_1(A0_2, A1_2, A2_2, A3_2, A4_2)
  local L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2
  L5_2 = {}
  L5_2.action = A2_2
  L5_2.by = A1_2
  L6_2 = type
  L7_2 = A4_2
  L6_2 = L6_2(L7_2)
  if "table" == L6_2 then
    L6_2 = pairs
    L7_2 = A4_2
    L6_2, L7_2, L8_2, L9_2 = L6_2(L7_2)
    for L10_2, L11_2 in L6_2, L7_2, L8_2, L9_2 do
      L5_2[L10_2] = L11_2
    end
  end
  L6_2 = L11_1
  L7_2 = A3_2
  L8_2 = 255
  L6_2 = L6_2(L7_2, L8_2)
  L7_2 = pcall
  L8_2 = json
  L8_2 = L8_2.encode
  L9_2 = L5_2
  L7_2, L8_2 = L7_2(L8_2, L9_2)
  L9_2 = Now
  L9_2 = L9_2()
  L10_2 = pcall
  L11_2 = L28_1
  L12_2 = {}
  L13_2 = A0_2.app
  L12_2.app = L13_2
  L12_2.sender = A1_2
  L13_2 = "g:"
  L14_2 = A0_2.id
  L13_2 = L13_2 .. L14_2
  L12_2.receiver = L13_2
  L12_2.type = "system"
  L12_2.content = L6_2
  L13_2 = L8_2 or L13_2
  if not L7_2 or not L8_2 then
    L13_2 = nil
  end
  L12_2.payload = L13_2
  L12_2.read = 0
  L12_2.created = L9_2
  L13_2 = A0_2.id
  L12_2.conversation_id = L13_2
  L10_2, L11_2 = L10_2(L11_2, L12_2)
  if L10_2 then
    L12_2 = math
    L12_2 = L12_2.tointeger
    L13_2 = tonumber
    L14_2 = L11_2
    L13_2, L14_2, L15_2, L16_2, L17_2, L18_2 = L13_2(L14_2)
    L12_2 = L12_2(L13_2, L14_2, L15_2, L16_2, L17_2, L18_2)
    if L12_2 then
      goto lbl_64
      L11_2 = L12_2 or L11_2
    end
  end
  L11_2 = nil
  ::lbl_64::
  if not L11_2 then
    L12_2 = Dbg
    L13_2 = "groups"
    L14_2 = "system message %s not saved in group %s (%s)"
    L15_2 = A2_2
    L16_2 = A0_2.id
    L17_2 = tostring
    if L10_2 then
      L18_2 = "no id"
      if L18_2 then
        goto lbl_78
      end
    end
    L18_2 = L11_2
    ::lbl_78::
    L17_2, L18_2 = L17_2(L18_2)
    L12_2(L13_2, L14_2, L15_2, L16_2, L17_2, L18_2)
    L12_2 = nil
    return L12_2
  end
  L12_2 = L29_1
  L13_2 = A0_2
  L14_2 = L11_2
  L12_2(L13_2, L14_2)
  L12_2 = {}
  L12_2.id = L11_2
  L13_2 = A0_2.app
  L12_2.app = L13_2
  L12_2.sender = A1_2
  L13_2 = "g:"
  L14_2 = A0_2.id
  L13_2 = L13_2 .. L14_2
  L12_2.receiver = L13_2
  L12_2.type = "system"
  L12_2.content = L6_2
  L12_2.payload = L5_2
  L12_2.read = false
  L12_2.created = L9_2
  L13_2 = A0_2.id
  L12_2.conversation = L13_2
  L13_2 = {}
  L14_2 = A0_2.id
  L13_2.id = L14_2
  L14_2 = A0_2.title
  L13_2.title = L14_2
  L14_2 = A0_2.avatar
  L13_2.avatar = L14_2
  L12_2.group = L13_2
  L13_2 = L33_1
  L14_2 = A0_2
  L15_2 = L12_2
  L16_2 = nil
  L17_2 = false
  L13_2(L14_2, L15_2, L16_2, L17_2)
  return L12_2
end
function L35_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2
  L2_2 = A0_2.id
  A1_2.id = L2_2
  L2_2 = GroupBroadcast
  L3_2 = A0_2.id
  L4_2 = "groupUpdate"
  L5_2 = A1_2
  return L2_2(L3_2, L4_2, L5_2)
end
function L36_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2
  L2_2 = type
  L3_2 = A0_2
  L2_2 = L2_2(L3_2)
  if "table" ~= L2_2 then
    L2_2 = nil
    L3_2 = "members"
    return L2_2, L3_2
  end
  L2_2 = {}
  L3_2 = {}
  L4_2 = L5_1
  L4_2 = L4_2()
  L4_2 = L4_2 * 2
  L5_2 = ipairs
  L6_2 = A0_2
  L5_2, L6_2, L7_2, L8_2 = L5_2(L6_2)
  for L9_2, L10_2 in L5_2, L6_2, L7_2, L8_2 do
    if L9_2 > L4_2 then
      L11_2 = nil
      L12_2 = "toomany"
      L13_2 = {}
      L14_2 = L5_1
      L14_2 = L14_2()
      L13_2.max = L14_2
      return L11_2, L12_2, L13_2
    end
    L11_2 = L14_1
    L12_2 = L10_2
    L11_2 = L11_2(L12_2)
    if not L11_2 then
      L12_2 = nil
      L13_2 = "badnumber"
      L14_2 = {}
      L15_2 = {}
      L16_2 = type
      L17_2 = L10_2
      L16_2 = L16_2(L17_2)
      if "string" ~= L16_2 then
        L16_2 = type
        L17_2 = L10_2
        L16_2 = L16_2(L17_2)
        if "number" ~= L16_2 then
          goto lbl_58
        end
      end
      L16_2 = L11_1
      L17_2 = L10_2
      L18_2 = 20
      L16_2 = L16_2(L17_2, L18_2)
      ::lbl_58::
      if not L16_2 then
        L16_2 = "?"
      end
      L15_2[1] = L16_2
      L14_2.numbers = L15_2
      return L12_2, L13_2, L14_2
    end
    if L11_2 ~= A1_2 then
      L12_2 = L3_2[L11_2]
      if not L12_2 then
        L3_2[L11_2] = true
        L12_2 = #L2_2
        L12_2 = L12_2 + 1
        L2_2[L12_2] = L11_2
      end
    end
  end
  return L2_2
end
function L37_1(A0_2)
  local L1_2, L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2
  L1_2 = {}
  L2_2 = {}
  L3_2 = L19_1
  L3_2 = L3_2()
  L4_2 = ipairs
  L5_2 = A0_2
  L4_2, L5_2, L6_2, L7_2 = L4_2(L5_2)
  for L8_2, L9_2 in L4_2, L5_2, L6_2, L7_2 do
    L10_2 = L3_2[L9_2]
    L11_2 = L10_2 or L11_2
    if L10_2 then
      L11_2 = GetCid
      L12_2 = L10_2
      L11_2 = L11_2(L12_2)
    end
    if L11_2 then
      L12_2 = tostring
      L13_2 = L11_2
      L12_2 = L12_2(L13_2)
      L1_2[L9_2] = L12_2
    else
      L12_2 = #L2_2
      L12_2 = L12_2 + 1
      L2_2[L12_2] = L9_2
    end
  end
  L4_2 = #L2_2
  if L4_2 > 0 then
    L4_2 = MySQL
    L4_2 = L4_2.query
    L4_2 = L4_2.await
    L5_2 = "SELECT citizenid, phone FROM apex_phone_accounts WHERE phone IN (%s)"
    L6_2 = L5_2
    L5_2 = L5_2.format
    L7_2 = L10_1
    L8_2 = #L2_2
    L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2 = L7_2(L8_2)
    L5_2 = L5_2(L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2)
    L6_2 = L2_2
    L4_2 = L4_2(L5_2, L6_2)
    if not L4_2 then
      L4_2 = {}
    end
    L5_2 = ipairs
    L6_2 = L4_2
    L5_2, L6_2, L7_2, L8_2 = L5_2(L6_2)
    for L9_2, L10_2 in L5_2, L6_2, L7_2, L8_2 do
      L11_2 = tostring
      L12_2 = L10_2.phone
      L11_2 = L11_2(L12_2)
      L12_2 = tostring
      L13_2 = L10_2.citizenid
      L12_2 = L12_2(L13_2)
      L1_2[L11_2] = L12_2
    end
    L5_2 = 0
    L6_2 = ipairs
    L7_2 = L2_2
    L6_2, L7_2, L8_2, L9_2 = L6_2(L7_2)
    for L10_2, L11_2 in L6_2, L7_2, L8_2, L9_2 do
      L12_2 = L1_2[L11_2]
      if not L12_2 then
        L12_2 = L3_1
        if L5_2 < L12_2 then
          L12_2 = FW
          L12_2 = L12_2.FindCidByPhone
          if L12_2 then
            L5_2 = L5_2 + 1
            L12_2 = FW
            L12_2 = L12_2.FindCidByPhone
            L13_2 = L11_2
            L12_2 = L12_2(L13_2)
            if L12_2 then
              L13_2 = tostring
              L14_2 = L12_2
              L13_2 = L13_2(L14_2)
              L1_2[L11_2] = L13_2
            end
          end
        end
      end
    end
  end
  return L1_2
end
function L38_1(A0_2, A1_2, A2_2)
  local L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2, L19_2, L20_2, L21_2
  L3_2 = {}
  L4_2 = {}
  L5_2 = {}
  L6_2 = ipairs
  L7_2 = A0_2
  L6_2, L7_2, L8_2, L9_2 = L6_2(L7_2)
  for L10_2, L11_2 in L6_2, L7_2, L8_2, L9_2 do
    L12_2 = A1_2[L11_2]
    if L12_2 then
      L13_2 = L5_2[L12_2]
      if not L13_2 then
        L13_2 = {}
        L5_2[L12_2] = L13_2
        L13_2 = #L4_2
        L13_2 = L13_2 + 1
        L4_2[L13_2] = L12_2
      end
      L13_2 = table
      L13_2 = L13_2.insert
      L14_2 = L5_2[L12_2]
      L15_2 = L11_2
      L13_2(L14_2, L15_2)
    end
  end
  L6_2 = #L4_2
  if L6_2 > 0 then
    L6_2 = {}
    L7_2 = A2_2
    L6_2[1] = L7_2
    L7_2 = ipairs
    L8_2 = L4_2
    L7_2, L8_2, L9_2, L10_2 = L7_2(L8_2)
    for L11_2, L12_2 in L7_2, L8_2, L9_2, L10_2 do
      L13_2 = #L6_2
      L13_2 = L13_2 + 1
      L6_2[L13_2] = L12_2
    end
    L7_2 = pcall
    L8_2 = MySQL
    L8_2 = L8_2.query
    L8_2 = L8_2.await
    L9_2 = "SELECT owner FROM apex_phone_blocks WHERE number = ? AND owner IN (%s)"
    L10_2 = L9_2
    L9_2 = L9_2.format
    L11_2 = L10_1
    L12_2 = #L4_2
    L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2, L19_2, L20_2, L21_2 = L11_2(L12_2)
    L9_2 = L9_2(L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2, L19_2, L20_2, L21_2)
    L10_2 = L6_2
    L7_2, L8_2 = L7_2(L8_2, L9_2, L10_2)
    if L7_2 then
      L9_2 = type
      L10_2 = L8_2
      L9_2 = L9_2(L10_2)
      if "table" == L9_2 then
        L9_2 = ipairs
        L10_2 = L8_2
        L9_2, L10_2, L11_2, L12_2 = L9_2(L10_2)
        for L13_2, L14_2 in L9_2, L10_2, L11_2, L12_2 do
          L15_2 = ipairs
          L16_2 = tostring
          L17_2 = L14_2.owner
          L16_2 = L16_2(L17_2)
          L16_2 = L5_2[L16_2]
          if not L16_2 then
            L16_2 = {}
          end
          L15_2, L16_2, L17_2, L18_2 = L15_2(L16_2)
          for L19_2, L20_2 in L15_2, L16_2, L17_2, L18_2 do
            L3_2[L20_2] = true
          end
        end
      end
    end
  end
  L6_2 = #A0_2
  if L6_2 > 0 then
    L6_2 = {}
    L7_2 = ipairs
    L8_2 = A0_2
    L7_2, L8_2, L9_2, L10_2 = L7_2(L8_2)
    for L11_2, L12_2 in L7_2, L8_2, L9_2, L10_2 do
      L13_2 = #L6_2
      L13_2 = L13_2 + 1
      L6_2[L13_2] = L12_2
    end
    L7_2 = pcall
    L8_2 = MySQL
    L8_2 = L8_2.query
    L8_2 = L8_2.await
    L9_2 = "SELECT member, COUNT(*) AS n FROM apex_phone_conversation_members WHERE left_at IS NULL AND member IN (%s) GROUP BY member"
    L10_2 = L9_2
    L9_2 = L9_2.format
    L11_2 = L10_1
    L12_2 = #A0_2
    L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2, L19_2, L20_2, L21_2 = L11_2(L12_2)
    L9_2 = L9_2(L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2, L19_2, L20_2, L21_2)
    L10_2 = L6_2
    L7_2, L8_2 = L7_2(L8_2, L9_2, L10_2)
    if L7_2 then
      L9_2 = type
      L10_2 = L8_2
      L9_2 = L9_2(L10_2)
      if "table" == L9_2 then
        L9_2 = L6_1
        L9_2 = L9_2()
        L10_2 = ipairs
        L11_2 = L8_2
        L10_2, L11_2, L12_2, L13_2 = L10_2(L11_2)
        for L14_2, L15_2 in L10_2, L11_2, L12_2, L13_2 do
          L16_2 = tonumber
          L17_2 = L15_2.n
          L16_2 = L16_2(L17_2)
          if not L16_2 then
            L16_2 = 0
          end
          if L9_2 <= L16_2 then
            L16_2 = tostring
            L17_2 = L15_2.member
            L16_2 = L16_2(L17_2)
            L3_2[L16_2] = true
          end
        end
      end
    end
  end
  return L3_2
end
L39_1 = 60000
L40_1 = {}
L41_1 = 0
function L42_1(A0_2, A1_2, A2_2, A3_2)
  local L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2, L19_2, L20_2, L21_2, L22_2, L23_2
  L4_2 = GetGameTimer
  L4_2 = L4_2()
  L5_2 = L41_1
  L6_2 = 2000
  if L5_2 > L6_2 then
    L5_2 = pairs
    L6_2 = L40_1
    L5_2, L6_2, L7_2, L8_2 = L5_2(L6_2)
    for L9_2, L10_2 in L5_2, L6_2, L7_2, L8_2 do
      L11_2 = L4_2 - L10_2
      L12_2 = L39_1
      if L11_2 >= L12_2 then
        L11_2 = L40_1
        L11_2[L9_2] = nil
        L11_2 = L41_1
        L11_2 = L11_2 - 1
        L41_1 = L11_2
      end
    end
  end
  L5_2 = {}
  L6_2 = {}
  L7_2 = ipairs
  L8_2 = A2_2
  L7_2, L8_2, L9_2, L10_2 = L7_2(L8_2)
  for L11_2, L12_2 in L7_2, L8_2, L9_2, L10_2 do
    L13_2 = A3_2[L12_2]
    L14_2 = A0_2.id
    L15_2 = "|"
    L16_2 = L12_2
    L14_2 = L14_2 .. L15_2 .. L16_2
    L15_2 = L40_1
    L15_2 = L15_2[L14_2]
    if L13_2 then
      L16_2 = L6_2[L13_2]
      if not L16_2 then
        if L15_2 then
          L16_2 = L4_2 - L15_2
          L17_2 = L39_1
          if L16_2 < L17_2 then
            goto lbl_65
          end
        end
        L6_2[L13_2] = true
        L16_2 = #L5_2
        L16_2 = L16_2 + 1
        L5_2[L16_2] = L13_2
        if not L15_2 then
          L16_2 = L41_1
          L16_2 = L16_2 + 1
          L41_1 = L16_2
        end
        L16_2 = L40_1
        L16_2[L14_2] = L4_2
      end
    end
    ::lbl_65::
  end
  L7_2 = #L5_2
  if 0 == L7_2 then
    return
  end
  L7_2 = {}
  L8_2 = {}
  L9_2 = A1_2
  L8_2[1] = L9_2
  L9_2 = ipairs
  L10_2 = L5_2
  L9_2, L10_2, L11_2, L12_2 = L9_2(L10_2)
  for L13_2, L14_2 in L9_2, L10_2, L11_2, L12_2 do
    L15_2 = #L8_2
    L15_2 = L15_2 + 1
    L8_2[L15_2] = L14_2
  end
  L9_2 = pcall
  L10_2 = MySQL
  L10_2 = L10_2.query
  L10_2 = L10_2.await
  L11_2 = "SELECT owner, name FROM apex_phone_contacts WHERE number = ? AND owner IN (%s)"
  L12_2 = L11_2
  L11_2 = L11_2.format
  L13_2 = L10_1
  L14_2 = #L5_2
  L13_2, L14_2, L15_2, L16_2, L17_2, L18_2, L19_2, L20_2, L21_2, L22_2, L23_2 = L13_2(L14_2)
  L11_2 = L11_2(L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2, L19_2, L20_2, L21_2, L22_2, L23_2)
  L12_2 = L8_2
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
        L17_2 = tostring
        L18_2 = L16_2.owner
        L17_2 = L17_2(L18_2)
        L18_2 = L16_2.name
        L7_2[L17_2] = L18_2
      end
    end
  end
  L11_2 = ipairs
  L12_2 = L5_2
  L11_2, L12_2, L13_2, L14_2 = L11_2(L12_2)
  for L15_2, L16_2 in L11_2, L12_2, L13_2, L14_2 do
    L17_2 = NotifyCitizen
    L18_2 = L16_2
    L19_2 = "messages"
    L20_2 = A0_2.title
    L21_2 = L11_1
    L22_2 = L7_2[L16_2]
    if not L22_2 then
      L22_2 = A1_2
    end
    L23_2 = " adicionou-te ao grupo"
    L22_2 = L22_2 .. L23_2
    L23_2 = 255
    L21_2 = L21_2(L22_2, L23_2)
    L22_2 = {}
    L23_2 = A0_2.id
    L22_2.conversation = L23_2
    L23_2 = A0_2.app
    L22_2.app = L23_2
    L23_2 = A0_2.id
    L22_2.group = L23_2
    L22_2.sys = "m"
    L17_2(L18_2, L19_2, L20_2, L21_2, L22_2)
  end
end
function L43_1(A0_2, A1_2, A2_2, A3_2)
  local L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2
  L4_2 = L22_1
  L5_2 = A1_2.id
  L4_2 = L4_2(L5_2)
  L5_2 = {}
  L6_2 = GetCid
  L7_2 = A0_2
  L6_2 = L6_2(L7_2)
  if L6_2 then
    L7_2 = #L4_2
    if L7_2 > 0 then
      L7_2 = {}
      L8_2 = L6_2
      L7_2[1] = L8_2
      L8_2 = ipairs
      L9_2 = L4_2
      L8_2, L9_2, L10_2, L11_2 = L8_2(L9_2)
      for L12_2, L13_2 in L8_2, L9_2, L10_2, L11_2 do
        L14_2 = #L7_2
        L14_2 = L14_2 + 1
        L15_2 = L13_2.member
        L7_2[L14_2] = L15_2
      end
      L8_2 = pcall
      L9_2 = MySQL
      L9_2 = L9_2.query
      L9_2 = L9_2.await
      L10_2 = "SELECT number, name FROM apex_phone_contacts WHERE owner = ? AND number IN (%s)"
      L11_2 = L10_2
      L10_2 = L10_2.format
      L12_2 = L10_1
      L13_2 = #L4_2
      L12_2, L13_2, L14_2, L15_2, L16_2, L17_2 = L12_2(L13_2)
      L10_2 = L10_2(L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2)
      L11_2 = L7_2
      L8_2, L9_2 = L8_2(L9_2, L10_2, L11_2)
      if L8_2 then
        L10_2 = type
        L11_2 = L9_2
        L10_2 = L10_2(L11_2)
        if "table" == L10_2 then
          L10_2 = ipairs
          L11_2 = L9_2
          L10_2, L11_2, L12_2, L13_2 = L10_2(L11_2)
          for L14_2, L15_2 in L10_2, L11_2, L12_2, L13_2 do
            L16_2 = tostring
            L17_2 = L15_2.number
            L16_2 = L16_2(L17_2)
            L17_2 = L15_2.name
            L5_2[L16_2] = L17_2
          end
        end
      end
    end
  end
  L7_2 = {}
  L8_2 = ipairs
  L9_2 = L4_2
  L8_2, L9_2, L10_2, L11_2 = L8_2(L9_2)
  for L12_2, L13_2 in L8_2, L9_2, L10_2, L11_2 do
    L14_2 = #L7_2
    L14_2 = L14_2 + 1
    L15_2 = {}
    L16_2 = L13_2.member
    L15_2.member = L16_2
    L16_2 = L13_2.role
    L15_2.role = L16_2
    L16_2 = L13_2.joined
    L15_2.joined = L16_2
    L16_2 = L13_2.member
    L16_2 = L5_2[L16_2]
    L15_2.name = L16_2
    L16_2 = L13_2.member
    L16_2 = L16_2 == A2_2 or L16_2
    L15_2.isMe = L16_2
    L7_2[L14_2] = L15_2
    L14_2 = L13_2.member
    if L14_2 == A2_2 then
      A3_2 = L13_2.role
    end
  end
  L8_2 = {}
  L8_2.ok = true
  L9_2 = A1_2.id
  L8_2.id = L9_2
  L9_2 = A1_2.app
  L8_2.app = L9_2
  L9_2 = A1_2.title
  L8_2.title = L9_2
  L9_2 = A1_2.avatar
  L8_2.avatar = L9_2
  L9_2 = A1_2.created_by
  L8_2.createdBy = L9_2
  L9_2 = A1_2.created
  L8_2.created = L9_2
  L9_2 = A1_2.last_id
  L8_2.lastId = L9_2
  L8_2.myRole = A3_2
  L8_2.me = A2_2
  L9_2 = L5_1
  L9_2 = L9_2()
  L8_2.max = L9_2
  L9_2 = #L7_2
  L8_2.memberCount = L9_2
  L8_2.members = L7_2
  L8_2.pinned = false
  L9_2 = pcall
  L10_2 = MySQL
  L10_2 = L10_2.single
  L10_2 = L10_2.await
  L11_2 = "SELECT pinned, muted_until FROM apex_phone_thread_meta WHERE owner = ? AND app = ? AND other = ?"
  L12_2 = {}
  L13_2 = A2_2
  L14_2 = A1_2.app
  L15_2 = "g:"
  L16_2 = A1_2.id
  L15_2 = L15_2 .. L16_2
  L12_2[1] = L13_2
  L12_2[2] = L14_2
  L12_2[3] = L15_2
  L9_2, L10_2 = L9_2(L10_2, L11_2, L12_2)
  if L9_2 then
    L11_2 = type
    L12_2 = L10_2
    L11_2 = L11_2(L12_2)
    if "table" == L11_2 then
      L11_2 = tonumber
      L12_2 = L10_2.pinned
      L11_2 = L11_2(L12_2)
      if not L11_2 then
        L11_2 = 0
      end
      L11_2 = 1 == L11_2
      L8_2.pinned = L11_2
      L11_2 = tonumber
      L12_2 = L10_2.muted_until
      L11_2 = L11_2(L12_2)
      L8_2.mutedUntil = L11_2
    end
  end
  return L8_2
end
function L44_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2, L6_2, L7_2
  L2_2 = L8_1
  L3_2 = A1_2
  L2_2 = L2_2(L3_2)
  if L2_2 then
    L3_2 = type
    L4_2 = MediaCanRead
    L3_2 = L3_2(L4_2)
    if "function" == L3_2 then
      goto lbl_13
    end
  end
  L3_2 = nil
  do return L3_2 end
  ::lbl_13::
  L3_2 = MediaCanRead
  L4_2 = A0_2
  L5_2 = L2_2
  L3_2 = L3_2(L4_2, L5_2)
  if not L3_2 then
    L3_2 = nil
    return L3_2
  end
  L3_2 = nil
  L4_2 = type
  L5_2 = MediaInfo
  L4_2 = L4_2(L5_2)
  if "function" == L4_2 then
    L4_2 = MediaInfo
    L5_2 = L2_2
    L4_2 = L4_2(L5_2)
    L3_2 = L4_2
    if L3_2 then
      L4_2 = L3_2.complete
      if not L4_2 then
        L4_2 = nil
        return L4_2
      end
    end
  else
    L4_2 = MySQL
    L4_2 = L4_2.single
    L4_2 = L4_2.await
    L5_2 = "SELECT kind, mime, complete FROM apex_phone_media WHERE id = ?"
    L6_2 = {}
    L7_2 = L2_2
    L6_2[1] = L7_2
    L4_2 = L4_2(L5_2, L6_2)
    L3_2 = L4_2
    if L3_2 then
      L4_2 = tonumber
      L5_2 = L3_2.complete
      L4_2 = L4_2(L5_2)
      if not L4_2 then
        L4_2 = 0
      end
      if 1 ~= L4_2 then
        L4_2 = nil
        return L4_2
      end
    end
  end
  if not L3_2 then
    L4_2 = nil
    return L4_2
  end
  L4_2 = L3_2.kind
  if "image" ~= L4_2 then
    L4_2 = tostring
    L5_2 = L3_2.mime
    if not L5_2 then
      L5_2 = ""
    end
    L4_2 = L4_2(L5_2)
    L5_2 = L4_2
    L4_2 = L4_2.match
    L6_2 = "^image/"
    L4_2 = L4_2(L5_2, L6_2)
    if not L4_2 then
      L4_2 = nil
      return L4_2
    end
  end
  return L2_2
end
function L45_1(A0_2)
  local L1_2, L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2
  L1_2 = A0_2.id
  L2_2 = pcall
  L3_2 = MySQL
  L3_2 = L3_2.query
  L3_2 = L3_2.await
  L4_2 = "DELETE r FROM apex_phone_message_reactions r JOIN apex_phone_messages m ON m.id = r.message_id WHERE m.conversation_id = ?"
  L5_2 = {}
  L6_2 = L1_2
  L5_2[1] = L6_2
  L2_2(L3_2, L4_2, L5_2)
  L2_2 = MySQL
  L2_2 = L2_2.query
  L2_2 = L2_2.await
  L3_2 = "DELETE FROM apex_phone_messages WHERE conversation_id = ?"
  L4_2 = {}
  L5_2 = L1_2
  L4_2[1] = L5_2
  L2_2(L3_2, L4_2)
  L2_2 = pcall
  L3_2 = MySQL
  L3_2 = L3_2.query
  L3_2 = L3_2.await
  L4_2 = "DELETE FROM apex_phone_thread_meta WHERE app = ? AND other = ?"
  L5_2 = {}
  L6_2 = A0_2.app
  L7_2 = "g:"
  L8_2 = L1_2
  L7_2 = L7_2 .. L8_2
  L5_2[1] = L6_2
  L5_2[2] = L7_2
  L2_2(L3_2, L4_2, L5_2)
  L2_2 = MySQL
  L2_2 = L2_2.query
  L2_2 = L2_2.await
  L3_2 = "DELETE FROM apex_phone_conversation_members WHERE conversation_id = ?"
  L4_2 = {}
  L5_2 = L1_2
  L4_2[1] = L5_2
  L2_2(L3_2, L4_2)
  L2_2 = MySQL
  L2_2 = L2_2.query
  L2_2 = L2_2.await
  L3_2 = "DELETE FROM apex_phone_conversations WHERE id = ?"
  L4_2 = {}
  L5_2 = L1_2
  L4_2[1] = L5_2
  L2_2(L3_2, L4_2)
  L2_2 = Dbg
  L3_2 = "groups"
  L4_2 = "group %s deleted (no members left)"
  L5_2 = L1_2
  L2_2(L3_2, L4_2, L5_2)
end
function L46_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2
  L2_2 = A0_2.id
  L3_2 = MySQL
  L3_2 = L3_2.update
  L3_2 = L3_2.await
  L4_2 = "UPDATE apex_phone_conversation_members SET left_at = ?, role = 'member' WHERE conversation_id = ? AND member = ? AND left_at IS NULL"
  L5_2 = {}
  L6_2 = Now
  L6_2 = L6_2()
  L7_2 = L2_2
  L8_2 = A1_2
  L5_2[1] = L6_2
  L5_2[2] = L7_2
  L5_2[3] = L8_2
  L3_2(L4_2, L5_2)
  L3_2 = pcall
  L4_2 = MySQL
  L4_2 = L4_2.query
  L4_2 = L4_2.await
  L5_2 = "DELETE FROM apex_phone_thread_meta WHERE owner = ? AND app = ? AND other = ?"
  L6_2 = {}
  L7_2 = A1_2
  L8_2 = A0_2.app
  L9_2 = "g:"
  L10_2 = L2_2
  L9_2 = L9_2 .. L10_2
  L6_2[1] = L7_2
  L6_2[2] = L8_2
  L6_2[3] = L9_2
  L3_2(L4_2, L5_2, L6_2)
  L3_2 = type
  L4_2 = MediaRevoke
  L3_2 = L3_2(L4_2)
  if "function" == L3_2 then
    L3_2 = pcall
    L4_2 = MediaRevoke
    L5_2 = L19_1
    L5_2 = L5_2()
    L5_2 = L5_2[A1_2]
    L3_2(L4_2, L5_2)
  end
  L3_2 = L22_1
  L4_2 = L2_2
  L3_2 = L3_2(L4_2)
  L4_2 = #L3_2
  if 0 == L4_2 then
    L4_2 = L45_1
    L5_2 = A0_2
    L4_2(L5_2)
    L4_2 = {}
    L4_2.ok = true
    L4_2.id = L2_2
    L4_2.deleted = true
    return L4_2
  end
  L4_2 = false
  L5_2 = ipairs
  L6_2 = L3_2
  L5_2, L6_2, L7_2, L8_2 = L5_2(L6_2)
  for L9_2, L10_2 in L5_2, L6_2, L7_2, L8_2 do
    L11_2 = L10_2.role
    if "admin" == L11_2 then
      L4_2 = true
      break
    end
  end
  L5_2 = nil
  if not L4_2 then
    L6_2 = L3_2[1]
    L5_2 = L6_2.member
    L6_2 = MySQL
    L6_2 = L6_2.update
    L6_2 = L6_2.await
    L7_2 = "UPDATE apex_phone_conversation_members SET role = 'admin' WHERE conversation_id = ? AND member = ? AND left_at IS NULL"
    L8_2 = {}
    L9_2 = L2_2
    L10_2 = L5_2
    L8_2[1] = L9_2
    L8_2[2] = L10_2
    L6_2(L7_2, L8_2)
  end
  L6_2 = L34_1
  L7_2 = A0_2
  L8_2 = A1_2
  L9_2 = "leave"
  L10_2 = "%s saiu do grupo"
  L11_2 = L10_2
  L10_2 = L10_2.format
  L12_2 = A1_2
  L10_2 = L10_2(L11_2, L12_2)
  if L5_2 then
    L11_2 = {}
    L11_2.admin = L5_2
    if L11_2 then
      goto lbl_98
    end
  end
  L11_2 = nil
  ::lbl_98::
  L6_2(L7_2, L8_2, L9_2, L10_2, L11_2)
  if L5_2 then
    L6_2 = L34_1
    L7_2 = A0_2
    L8_2 = L5_2
    L9_2 = "admin"
    L10_2 = "%s passou a ser administrador"
    L11_2 = L10_2
    L10_2 = L10_2.format
    L12_2 = L5_2
    L10_2 = L10_2(L11_2, L12_2)
    L11_2 = {}
    L12_2 = {}
    L13_2 = L5_2
    L12_2[1] = L13_2
    L11_2.targets = L12_2
    L11_2.auto = true
    L6_2(L7_2, L8_2, L9_2, L10_2, L11_2)
  end
  L6_2 = L35_1
  L7_2 = A0_2
  L8_2 = {}
  L8_2.action = "leave"
  L8_2.by = A1_2
  L8_2.admin = L5_2
  L6_2(L7_2, L8_2)
  L6_2 = Dbg
  L7_2 = "groups"
  L8_2 = "%s left group %s%s"
  L9_2 = A1_2
  L10_2 = L2_2
  if L5_2 then
    L11_2 = " (admin: "
    L12_2 = L5_2
    L13_2 = ")"
    L11_2 = L11_2 .. L12_2 .. L13_2
    if L11_2 then
      goto lbl_140
    end
  end
  L11_2 = ""
  ::lbl_140::
  L6_2(L7_2, L8_2, L9_2, L10_2, L11_2)
  L6_2 = {}
  L6_2.ok = true
  L6_2.id = L2_2
  L6_2.deleted = false
  L6_2.admin = L5_2
  return L6_2
end
function L47_1(A0_2)
  local L1_2, L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2
  if nil == A0_2 or "" == A0_2 then
    L1_2 = 0
    return L1_2
  end
  L1_2 = tostring
  L2_2 = A0_2
  L1_2 = L1_2(L2_2)
  A0_2 = L1_2
  L1_2 = MySQL
  L1_2 = L1_2.query
  L1_2 = L1_2.await
  L2_2 = "SELECT conversation_id FROM apex_phone_conversation_members WHERE member = ? AND left_at IS NULL"
  L3_2 = {}
  L4_2 = A0_2
  L3_2[1] = L4_2
  L1_2 = L1_2(L2_2, L3_2)
  if not L1_2 then
    L1_2 = {}
  end
  L2_2 = 0
  L3_2 = ipairs
  L4_2 = L1_2
  L3_2, L4_2, L5_2, L6_2 = L3_2(L4_2)
  for L7_2, L8_2 in L3_2, L4_2, L5_2, L6_2 do
    L9_2 = math
    L9_2 = L9_2.tointeger
    L10_2 = tonumber
    L11_2 = L8_2.conversation_id
    L10_2, L11_2, L12_2 = L10_2(L11_2)
    L9_2 = L9_2(L10_2, L11_2, L12_2)
    if L9_2 then
      L10_2 = L25_1
      L11_2 = L9_2
      function L12_2()
        local L0_3, L1_3, L2_3, L3_3
        L0_3 = L20_1
        L1_3 = L9_2
        L0_3 = L0_3(L1_3)
        if L0_3 then
          L1_3 = L21_1
          L2_3 = L9_2
          L3_3 = A0_2
          L1_3 = L1_3(L2_3, L3_3)
          if L1_3 then
            L1_3 = L46_1
            L2_3 = L0_3
            L3_3 = A0_2
            L1_3(L2_3, L3_3)
            L1_3 = L2_2
            L1_3 = L1_3 + 1
            L2_2 = L1_3
          end
        end
      end
      L10_2(L11_2, L12_2)
    end
  end
  return L2_2
end
GroupForget = L47_1
function L47_1()
  local L0_2, L1_2, L2_2
  L0_2 = math
  L0_2 = L0_2.max
  L1_2 = tonumber
  L2_2 = Config
  L2_2 = L2_2.PhotoMaxBytes
  L1_2 = L1_2(L2_2)
  if not L1_2 then
    L1_2 = 260000
  end
  L2_2 = 300000
  L0_2 = L0_2(L1_2, L2_2)
  L0_2 = L0_2 + 65536
  return L0_2
end
function L48_1(A0_2, A1_2, A2_2)
  local L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2, L19_2, L20_2, L21_2, L22_2
  L3_2 = L9_1
  L4_2 = A1_2
  L3_2 = L3_2(L4_2)
  L4_2 = tonumber
  L5_2 = A0_2
  L4_2 = L4_2(L5_2)
  A0_2 = L4_2
  if not L3_2 or not A0_2 then
    L4_2 = nil
    L5_2 = "invalid"
    return L4_2, L5_2
  end
  L4_2 = type
  L5_2 = A2_2
  L4_2 = L4_2(L5_2)
  if "table" ~= L4_2 or not A2_2 then
    L4_2 = {}
    A2_2 = L4_2
  end
  L4_2 = type
  L5_2 = A2_2.type
  L4_2 = L4_2(L5_2)
  if "string" == L4_2 then
    L4_2 = A2_2.type
    if "" ~= L4_2 then
      L4_2 = A2_2.type
      L5_2 = L4_2
      L4_2 = L4_2.sub
      L6_2 = 1
      L7_2 = 16
      L4_2 = L4_2(L5_2, L6_2, L7_2)
      if L4_2 then
        goto lbl_41
      end
    end
  end
  L4_2 = "text"
  ::lbl_41::
  if "system" ~= L4_2 then
    L6_2 = L4_2
    L5_2 = L4_2.match
    L7_2 = "^[%w_%-]+$"
    L5_2 = L5_2(L6_2, L7_2)
    if L5_2 then
      goto lbl_51
    end
  end
  L5_2 = nil
  L6_2 = "invalid"
  do return L5_2, L6_2 end
  ::lbl_51::
  L5_2 = 1000
  L6_2 = type
  L7_2 = Config
  L7_2 = L7_2.Recado
  L6_2 = L6_2(L7_2)
  if "table" == L6_2 then
    L6_2 = math
    L6_2 = L6_2.max
    L7_2 = 1000
    L8_2 = math
    L8_2 = L8_2.min
    L9_2 = 60000
    L10_2 = math
    L10_2 = L10_2.tointeger
    L11_2 = math
    L11_2 = L11_2.floor
    L12_2 = tonumber
    L13_2 = Config
    L13_2 = L13_2.Recado
    L13_2 = L13_2.textMax
    L12_2 = L12_2(L13_2)
    if not L12_2 then
      L12_2 = 4000
    end
    L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2, L19_2, L20_2, L21_2, L22_2 = L11_2(L12_2)
    L10_2 = L10_2(L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2, L19_2, L20_2, L21_2, L22_2)
    if not L10_2 then
      L10_2 = 4000
    end
    L8_2 = L8_2(L9_2, L10_2)
    L6_2 = L6_2(L7_2, L8_2)
    L5_2 = L6_2
  end
  L6_2 = type
  L7_2 = A2_2.content
  L6_2 = L6_2(L7_2)
  if "string" ~= L6_2 then
    L6_2 = type
    L7_2 = A2_2.content
    L6_2 = L6_2(L7_2)
    if "number" ~= L6_2 then
      goto lbl_100
    end
  end
  L6_2 = L11_1
  L7_2 = A2_2.content
  L8_2 = L5_2
  L6_2 = L6_2(L7_2, L8_2)
  ::lbl_100::
  if not L6_2 then
    L6_2 = ""
  end
  L7_2 = nil
  L8_2 = type
  L9_2 = A2_2.payload
  L8_2 = L8_2(L9_2)
  if "table" == L8_2 then
    L8_2 = {}
    L7_2 = L8_2
    L8_2 = pairs
    L9_2 = A2_2.payload
    L8_2, L9_2, L10_2, L11_2 = L8_2(L9_2)
    for L12_2, L13_2 in L8_2, L9_2, L10_2, L11_2 do
      L7_2[L12_2] = L13_2
    end
  end
  L8_2 = A2_2.mediaId
  if false == L8_2 or 0 == L8_2 or "" == L8_2 then
    L8_2 = nil
  end
  L9_2 = L8_1
  L10_2 = L8_2
  L9_2 = L9_2(L10_2)
  if nil == L8_2 or L9_2 then
    if not L7_2 then
      goto lbl_146
    end
    L10_2 = L7_2.mediaId
    if nil == L10_2 then
      goto lbl_146
    end
    L10_2 = L8_1
    L11_2 = L7_2.mediaId
    L10_2 = L10_2(L11_2)
    if L10_2 then
      goto lbl_146
    end
  end
  L10_2 = nil
  L11_2 = "media"
  do return L10_2, L11_2 end
  ::lbl_146::
  if L9_2 then
    if not L7_2 then
      L10_2 = {}
      L7_2 = L10_2
    end
    L10_2 = L7_2.mediaId
    if nil == L10_2 then
      L7_2.mediaId = L9_2
    end
  end
  L10_2 = type
  L11_2 = MediaCanRead
  L10_2 = L10_2(L11_2)
  if "function" == L10_2 then
    L10_2 = L7_2 or L10_2
    if L7_2 then
      L10_2 = L8_1
      L11_2 = L7_2.mediaId
      L10_2 = L10_2(L11_2)
    end
    if L9_2 then
      L11_2 = MediaCanRead
      L12_2 = A0_2
      L13_2 = L9_2
      L11_2 = L11_2(L12_2, L13_2)
      if not L11_2 then
        L11_2 = nil
        L12_2 = "media"
        return L11_2, L12_2
      end
    end
    if L10_2 and L10_2 ~= L9_2 then
      L11_2 = MediaCanRead
      L12_2 = A0_2
      L13_2 = L10_2
      L11_2 = L11_2(L12_2, L13_2)
      if not L11_2 then
        L11_2 = nil
        L12_2 = "media"
        return L11_2, L12_2
      end
    end
    L11_2 = type
    L12_2 = MediaInfo
    L11_2 = L11_2(L12_2)
    if "function" == L11_2 then
      L11_2 = ipairs
      L12_2 = {}
      L13_2 = L9_2 or L13_2
      if not L9_2 then
        L13_2 = false
      end
      L14_2 = L10_2 or L14_2
      if L10_2 == L9_2 or not L10_2 then
        L14_2 = false
      end
      L12_2[1] = L13_2
      L12_2[2] = L14_2
      L11_2, L12_2, L13_2, L14_2 = L11_2(L12_2)
      for L15_2, L16_2 in L11_2, L12_2, L13_2, L14_2 do
        if L16_2 then
          L17_2 = MediaInfo
          L18_2 = L16_2
          L17_2 = L17_2(L18_2)
          if L17_2 then
            L18_2 = L17_2.complete
            if L18_2 then
              goto lbl_223
            end
          end
          L18_2 = nil
          L19_2 = "media"
          return L18_2, L19_2
        end
        ::lbl_223::
      end
    end
  end
  L10_2 = nil
  if L7_2 then
    L11_2 = pcall
    L12_2 = json
    L12_2 = L12_2.encode
    L13_2 = L7_2
    L11_2, L12_2 = L11_2(L12_2, L13_2)
    if L11_2 then
      L13_2 = type
      L14_2 = L12_2
      L13_2 = L13_2(L14_2)
      if "string" == L13_2 then
        L13_2 = #L12_2
        L14_2 = L47_1
        L14_2 = L14_2()
        if not (L13_2 > L14_2) then
          goto lbl_249
        end
      end
    end
    L13_2 = nil
    L14_2 = "toolarge"
    do return L13_2, L14_2 end
    ::lbl_249::
    L10_2 = L12_2
  end
  L11_2 = L8_1
  L12_2 = type
  L13_2 = A2_2.replyTo
  L12_2 = L12_2(L13_2)
  if "table" == L12_2 then
    L12_2 = A2_2.replyTo
    L12_2 = L12_2.id
    if L12_2 then
      goto lbl_261
    end
  end
  L12_2 = A2_2.replyTo
  ::lbl_261::
  L11_2 = L11_2(L12_2)
  L12_2 = L25_1
  L13_2 = L3_2
  function L14_2()
    local L0_3, L1_3, L2_3, L3_3, L4_3, L5_3, L6_3, L7_3, L8_3, L9_3, L10_3, L11_3
    L0_3 = L20_1
    L1_3 = L3_2
    L0_3 = L0_3(L1_3)
    if L0_3 then
      L2_3 = L0_3.app
      L1_3 = L0_1
      L1_3 = L1_3[L2_3]
      if L1_3 then
        goto lbl_15
      end
    end
    L1_3 = {}
    L1_3.error = "notfound"
    do return L1_3 end
    ::lbl_15::
    L1_3 = L0_3.app
    if "recado" ~= L1_3 then
      L1_3 = L6_2
      L1_3 = #L1_3
      L2_3 = 1000
      if L1_3 > L2_3 then
        L1_3 = L11_1
        L2_3 = L6_2
        L3_3 = 1000
        L1_3 = L1_3(L2_3, L3_3)
        L6_2 = L1_3
      end
    end
    L1_3 = L16_1
    L2_3 = A0_2
    L3_3 = L0_3.app
    L1_3 = L1_3(L2_3, L3_3)
    if not L1_3 then
      L2_3 = {}
      L2_3.error = "noidentity"
      return L2_3
    end
    L2_3 = L21_1
    L3_3 = L3_2
    L4_3 = L1_3
    L2_3 = L2_3(L3_3, L4_3)
    if not L2_3 then
      L2_3 = {}
      L2_3.error = "notmember"
      return L2_3
    end
    L2_3 = nil
    L3_3 = L11_2
    if L3_3 then
      L3_3 = MySQL
      L3_3 = L3_3.single
      L3_3 = L3_3.await
      L4_3 = "SELECT id, sender, type, content, deleted_all FROM apex_phone_messages WHERE id = ? AND conversation_id = ?"
      L5_3 = {}
      L6_3 = L11_2
      L7_3 = L3_2
      L5_3[1] = L6_3
      L5_3[2] = L7_3
      L3_3 = L3_3(L4_3, L5_3)
      if L3_3 then
        L4_3 = L31_1
        L5_3 = L3_3
        L4_3 = L4_3(L5_3)
        L2_3 = L4_3
        L4_3 = L11_2
        L2_3.id = L4_3
      end
    end
    L3_3 = Now
    L3_3 = L3_3()
    L4_3 = math
    L4_3 = L4_3.tointeger
    L5_3 = tonumber
    L6_3 = L28_1
    L7_3 = {}
    L8_3 = L0_3.app
    L7_3.app = L8_3
    L7_3.sender = L1_3
    L8_3 = "g:"
    L9_3 = L3_2
    L8_3 = L8_3 .. L9_3
    L7_3.receiver = L8_3
    L8_3 = L4_2
    L7_3.type = L8_3
    L8_3 = L6_2
    L7_3.content = L8_3
    L8_3 = L10_2
    L7_3.payload = L8_3
    L7_3.read = 0
    L7_3.created = L3_3
    if L2_3 then
      L8_3 = L11_2
      if L8_3 then
        goto lbl_99
      end
    end
    L8_3 = nil
    ::lbl_99::
    L7_3.reply_to = L8_3
    L8_3 = L3_2
    L7_3.conversation_id = L8_3
    L6_3, L7_3, L8_3, L9_3, L10_3, L11_3 = L6_3(L7_3)
    L5_3, L6_3, L7_3, L8_3, L9_3, L10_3, L11_3 = L5_3(L6_3, L7_3, L8_3, L9_3, L10_3, L11_3)
    L4_3 = L4_3(L5_3, L6_3, L7_3, L8_3, L9_3, L10_3, L11_3)
    if not L4_3 then
      L5_3 = {}
      L5_3.error = "db"
      return L5_3
    end
    L5_3 = L29_1
    L6_3 = L0_3
    L7_3 = L4_3
    L5_3(L6_3, L7_3)
    L5_3 = MySQL
    L5_3 = L5_3.update
    L5_3 = L5_3.await
    L6_3 = "UPDATE apex_phone_conversation_members SET last_read_id = ? WHERE conversation_id = ? AND member = ? AND (last_read_id IS NULL OR last_read_id < ?)"
    L7_3 = {}
    L8_3 = L4_3
    L9_3 = L3_2
    L10_3 = L1_3
    L11_3 = L4_3
    L7_3[1] = L8_3
    L7_3[2] = L9_3
    L7_3[3] = L10_3
    L7_3[4] = L11_3
    L5_3(L6_3, L7_3)
    L5_3 = {}
    L5_3.g = L0_3
    L5_3.who = L1_3
    L5_3.mid = L4_3
    L5_3.created = L3_3
    L5_3.reply = L2_3
    return L5_3
  end
  L12_2 = L12_2(L13_2, L14_2)
  L13_2 = type
  L14_2 = L12_2
  L13_2 = L13_2(L14_2)
  if "table" == L13_2 then
    L13_2 = L12_2.error
    if not L13_2 then
      goto lbl_285
    end
  end
  L13_2 = nil
  L14_2 = type
  L15_2 = L12_2
  L14_2 = L14_2(L15_2)
  if "table" == L14_2 then
    L14_2 = L12_2.error
    if L14_2 then
      goto lbl_284
    end
  end
  L14_2 = "db"
  ::lbl_284::
  do return L13_2, L14_2 end
  ::lbl_285::
  L13_2 = L12_2.g
  L14_2 = {}
  L15_2 = L12_2.mid
  L14_2.id = L15_2
  L15_2 = L13_2.app
  L14_2.app = L15_2
  L15_2 = L12_2.who
  L14_2.sender = L15_2
  L15_2 = "g:"
  L16_2 = L3_2
  L15_2 = L15_2 .. L16_2
  L14_2.receiver = L15_2
  L14_2.type = L4_2
  L14_2.content = L6_2
  L14_2.payload = L7_2
  L14_2.read = false
  L15_2 = L12_2.created
  L14_2.created = L15_2
  L14_2.conversation = L3_2
  L15_2 = {}
  L15_2.id = L3_2
  L16_2 = L13_2.title
  L15_2.title = L16_2
  L16_2 = L13_2.avatar
  L15_2.avatar = L16_2
  L14_2.group = L15_2
  L15_2 = L12_2.reply
  L14_2.replyTo = L15_2
  L15_2 = L33_1
  L16_2 = L13_2
  L17_2 = L14_2
  L18_2 = L12_2.who
  L19_2 = true
  L15_2(L16_2, L17_2, L18_2, L19_2)
  L15_2 = {}
  L16_2 = pairs
  L17_2 = L14_2
  L16_2, L17_2, L18_2, L19_2 = L16_2(L17_2)
  for L20_2, L21_2 in L16_2, L17_2, L18_2, L19_2 do
    L15_2[L20_2] = L21_2
  end
  if L10_2 then
    L16_2 = #L10_2
    L17_2 = 8192
    if L16_2 > L17_2 then
      L16_2 = nil
      L15_2.payloadTrimmed = true
      L15_2.payload = L16_2
    end
  end
  L16_2 = TriggerEvent
  L17_2 = "apex_phone:messageSent"
  L18_2 = L15_2
  L16_2(L17_2, L18_2)
  L16_2 = Dbg
  L17_2 = "groups"
  L18_2 = "message %s in group %s by %s"
  L19_2 = L12_2.mid
  L20_2 = L3_2
  L21_2 = L12_2.who
  L16_2(L17_2, L18_2, L19_2, L20_2, L21_2)
  return L14_2
end
GroupSend = L48_1
function L48_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2, L19_2, L20_2, L21_2, L22_2, L23_2
  if not A1_2 then
    A1_2 = "sms"
  end
  if nil ~= A0_2 and "" ~= A0_2 then
    L2_2 = L0_1
    L2_2 = L2_2[A1_2]
    if L2_2 then
      goto lbl_15
    end
  end
  L2_2 = {}
  do return L2_2 end
  ::lbl_15::
  L2_2 = tostring
  L3_2 = A0_2
  L2_2 = L2_2(L3_2)
  A0_2 = L2_2
  L2_2 = MySQL
  L2_2 = L2_2.query
  L2_2 = L2_2.await
  L3_2 = [[
SELECT c.id, c.title, c.avatar, c.created, c.last_id, m.role, m.last_read_id
        FROM apex_phone_conversation_members m JOIN apex_phone_conversations c ON c.id = m.conversation_id
        WHERE m.member = ? AND m.left_at IS NULL AND c.app = ? ORDER BY c.id DESC LIMIT 200]]
  L4_2 = {}
  L5_2 = A0_2
  L6_2 = A1_2
  L4_2[1] = L5_2
  L4_2[2] = L6_2
  L2_2 = L2_2(L3_2, L4_2)
  if not L2_2 then
    L2_2 = {}
  end
  L3_2 = #L2_2
  if 0 == L3_2 then
    L3_2 = {}
    return L3_2
  end
  L3_2 = {}
  L4_2 = {}
  L5_2 = {}
  L6_2 = {}
  L7_2 = ipairs
  L8_2 = L2_2
  L7_2, L8_2, L9_2, L10_2 = L7_2(L8_2)
  for L11_2, L12_2 in L7_2, L8_2, L9_2, L10_2 do
    L13_2 = math
    L13_2 = L13_2.tointeger
    L14_2 = tonumber
    L15_2 = L12_2.id
    L14_2, L15_2, L16_2, L17_2, L18_2, L19_2, L20_2, L21_2, L22_2, L23_2 = L14_2(L15_2)
    L13_2 = L13_2(L14_2, L15_2, L16_2, L17_2, L18_2, L19_2, L20_2, L21_2, L22_2, L23_2)
    if L13_2 then
      L14_2 = L4_2[L13_2]
      if not L14_2 then
        L14_2 = {}
        L14_2.id = L13_2
        L15_2 = L12_2.title
        L14_2.title = L15_2
        L15_2 = math
        L15_2 = L15_2.tointeger
        L16_2 = tonumber
        L17_2 = L12_2.avatar
        L16_2, L17_2, L18_2, L19_2, L20_2, L21_2, L22_2, L23_2 = L16_2(L17_2)
        L15_2 = L15_2(L16_2, L17_2, L18_2, L19_2, L20_2, L21_2, L22_2, L23_2)
        L14_2.avatar = L15_2
        L15_2 = tonumber
        L16_2 = L12_2.created
        L15_2 = L15_2(L16_2)
        L14_2.created = L15_2
        L15_2 = tonumber
        L16_2 = L12_2.created
        L15_2 = L15_2(L16_2)
        if not L15_2 then
          L15_2 = 0
        end
        L14_2.ts = L15_2
        L15_2 = L12_2.role
        if "admin" == L15_2 then
          L15_2 = "admin"
          if L15_2 then
            goto lbl_92
          end
        end
        L15_2 = "member"
        ::lbl_92::
        L14_2.role = L15_2
        L15_2 = math
        L15_2 = L15_2.tointeger
        L16_2 = tonumber
        L17_2 = L12_2.last_id
        L16_2, L17_2, L18_2, L19_2, L20_2, L21_2, L22_2, L23_2 = L16_2(L17_2)
        L15_2 = L15_2(L16_2, L17_2, L18_2, L19_2, L20_2, L21_2, L22_2, L23_2)
        L14_2.lastId = L15_2
        L15_2 = math
        L15_2 = L15_2.tointeger
        L16_2 = tonumber
        L17_2 = L12_2.last_read_id
        L16_2, L17_2, L18_2, L19_2, L20_2, L21_2, L22_2, L23_2 = L16_2(L17_2)
        L15_2 = L15_2(L16_2, L17_2, L18_2, L19_2, L20_2, L21_2, L22_2, L23_2)
        if not L15_2 then
          L15_2 = 0
        end
        L14_2.lastReadId = L15_2
        L15_2 = {}
        L14_2.members = L15_2
        L14_2.memberCount = 0
        L14_2.unread = 0
        L14_2.pinned = false
        L15_2 = #L3_2
        L15_2 = L15_2 + 1
        L16_2 = #L5_2
        L16_2 = L16_2 + 1
        L17_2 = L14_2
        L18_2 = L14_2
        L5_2[L16_2] = L13_2
        L3_2[L15_2] = L18_2
        L4_2[L13_2] = L17_2
        L15_2 = L14_2.lastId
        if L15_2 then
          L15_2 = #L6_2
          L15_2 = L15_2 + 1
          L16_2 = L14_2.lastId
          L6_2[L15_2] = L16_2
        end
      end
    end
  end
  L7_2 = MySQL
  L7_2 = L7_2.query
  L7_2 = L7_2.await
  L8_2 = "SELECT conversation_id, member, role FROM apex_phone_conversation_members WHERE conversation_id IN (%s) AND left_at IS NULL ORDER BY joined ASC, member ASC"
  L9_2 = L8_2
  L8_2 = L8_2.format
  L10_2 = L10_1
  L11_2 = #L5_2
  L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2, L19_2, L20_2, L21_2, L22_2, L23_2 = L10_2(L11_2)
  L8_2 = L8_2(L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2, L19_2, L20_2, L21_2, L22_2, L23_2)
  L9_2 = L5_2
  L7_2 = L7_2(L8_2, L9_2)
  if not L7_2 then
    L7_2 = {}
  end
  L8_2 = ipairs
  L9_2 = L7_2
  L8_2, L9_2, L10_2, L11_2 = L8_2(L9_2)
  for L12_2, L13_2 in L8_2, L9_2, L10_2, L11_2 do
    L14_2 = math
    L14_2 = L14_2.tointeger
    L15_2 = tonumber
    L16_2 = L13_2.conversation_id
    L15_2, L16_2, L17_2, L18_2, L19_2, L20_2, L21_2, L22_2, L23_2 = L15_2(L16_2)
    L14_2 = L14_2(L15_2, L16_2, L17_2, L18_2, L19_2, L20_2, L21_2, L22_2, L23_2)
    if not L14_2 then
      L14_2 = -1
    end
    L14_2 = L4_2[L14_2]
    if L14_2 then
      L15_2 = L14_2.members
      L16_2 = L14_2.members
      L16_2 = #L16_2
      L16_2 = L16_2 + 1
      L17_2 = {}
      L18_2 = tostring
      L19_2 = L13_2.member
      L18_2 = L18_2(L19_2)
      L17_2.member = L18_2
      L18_2 = L13_2.role
      if "admin" == L18_2 then
        L18_2 = "admin"
        if L18_2 then
          goto lbl_187
        end
      end
      L18_2 = "member"
      ::lbl_187::
      L17_2.role = L18_2
      L15_2[L16_2] = L17_2
      L15_2 = L14_2.memberCount
      L15_2 = L15_2 + 1
      L14_2.memberCount = L15_2
    end
  end
  L8_2 = #L6_2
  if L8_2 > 0 then
    L8_2 = MySQL
    L8_2 = L8_2.query
    L8_2 = L8_2.await
    L9_2 = "SELECT id, app, sender, receiver, type, content, CASE WHEN CHAR_LENGTH(payload) > 8192 THEN NULL ELSE payload END AS payload, created, edited_at, deleted_all, deleted_sender, conversation_id FROM apex_phone_messages WHERE id IN (%s)"
    L10_2 = L9_2
    L9_2 = L9_2.format
    L11_2 = L10_1
    L12_2 = #L6_2
    L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2, L19_2, L20_2, L21_2, L22_2, L23_2 = L11_2(L12_2)
    L9_2 = L9_2(L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2, L19_2, L20_2, L21_2, L22_2, L23_2)
    L10_2 = L6_2
    L8_2 = L8_2(L9_2, L10_2)
    if not L8_2 then
      L8_2 = {}
    end
    L9_2 = ipairs
    L10_2 = L8_2
    L9_2, L10_2, L11_2, L12_2 = L9_2(L10_2)
    for L13_2, L14_2 in L9_2, L10_2, L11_2, L12_2 do
      L15_2 = math
      L15_2 = L15_2.tointeger
      L16_2 = tonumber
      L17_2 = L14_2.conversation_id
      L16_2, L17_2, L18_2, L19_2, L20_2, L21_2, L22_2, L23_2 = L16_2(L17_2)
      L15_2 = L15_2(L16_2, L17_2, L18_2, L19_2, L20_2, L21_2, L22_2, L23_2)
      if not L15_2 then
        L15_2 = -1
      end
      L15_2 = L4_2[L15_2]
      if L15_2 then
        L16_2 = L32_1
        L17_2 = L14_2
        L16_2 = L16_2(L17_2)
        L17_2 = L16_2.sender
        if L17_2 == A0_2 then
          L17_2 = tonumber
          L18_2 = L14_2.deleted_sender
          L17_2 = L17_2(L18_2)
          if 1 == L17_2 then
            L17_2 = true
            L18_2 = ""
            L16_2.payload = nil
            L16_2.content = L18_2
            L16_2.deleted = L17_2
          end
        end
        L17_2 = L16_2.sender
        L17_2 = L17_2 == A0_2
        L16_2.read = L17_2
        L17_2 = {}
        L18_2 = L15_2.id
        L17_2.id = L18_2
        L18_2 = L15_2.title
        L17_2.title = L18_2
        L18_2 = L15_2.avatar
        L17_2.avatar = L18_2
        L16_2.group = L17_2
        L15_2.lastMessage = L16_2
        L17_2 = L16_2.created
        if not L17_2 then
          L17_2 = L15_2.ts
        end
        L15_2.ts = L17_2
      end
    end
  end
  L8_2 = {}
  L9_2 = A0_2
  L10_2 = A0_2
  L8_2[1] = L9_2
  L8_2[2] = L10_2
  L9_2 = ipairs
  L10_2 = L5_2
  L9_2, L10_2, L11_2, L12_2 = L9_2(L10_2)
  for L13_2, L14_2 in L9_2, L10_2, L11_2, L12_2 do
    L15_2 = #L8_2
    L15_2 = L15_2 + 1
    L8_2[L15_2] = L14_2
  end
  L9_2 = pcall
  L10_2 = MySQL
  L10_2 = L10_2.query
  L10_2 = L10_2.await
  L11_2 = [[
SELECT m.conversation_id AS cid, COUNT(*) AS n FROM apex_phone_conversation_members m
        JOIN apex_phone_messages msg ON msg.conversation_id = m.conversation_id AND msg.id > COALESCE(m.last_read_id, 0)
        WHERE m.member = ? AND m.left_at IS NULL AND msg.sender <> ? AND msg.type <> 'system' AND msg.deleted_all IS NULL
          AND m.conversation_id IN (%s) GROUP BY m.conversation_id]]
  L12_2 = L11_2
  L11_2 = L11_2.format
  L13_2 = L10_1
  L14_2 = #L5_2
  L13_2, L14_2, L15_2, L16_2, L17_2, L18_2, L19_2, L20_2, L21_2, L22_2, L23_2 = L13_2(L14_2)
  L11_2 = L11_2(L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2, L19_2, L20_2, L21_2, L22_2, L23_2)
  L12_2 = L8_2
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
        L17_2 = math
        L17_2 = L17_2.tointeger
        L18_2 = tonumber
        L19_2 = L16_2.cid
        L18_2, L19_2, L20_2, L21_2, L22_2, L23_2 = L18_2(L19_2)
        L17_2 = L17_2(L18_2, L19_2, L20_2, L21_2, L22_2, L23_2)
        if not L17_2 then
          L17_2 = -1
        end
        L17_2 = L4_2[L17_2]
        if L17_2 then
          L18_2 = math
          L18_2 = L18_2.tointeger
          L19_2 = tonumber
          L20_2 = L16_2.n
          L19_2 = L19_2(L20_2)
          if not L19_2 then
            L19_2 = 0
          end
          L18_2 = L18_2(L19_2)
          if not L18_2 then
            L18_2 = 0
          end
          L17_2.unread = L18_2
        end
      end
    end
  end
  L11_2 = pcall
  L12_2 = MySQL
  L12_2 = L12_2.query
  L12_2 = L12_2.await
  L13_2 = "SELECT other, pinned, muted_until, cleared_before FROM apex_phone_thread_meta WHERE owner = ? AND app = ? AND other LIKE 'g:%'"
  L14_2 = {}
  L15_2 = A0_2
  L16_2 = A1_2
  L14_2[1] = L15_2
  L14_2[2] = L16_2
  L11_2, L12_2 = L11_2(L12_2, L13_2, L14_2)
  if L11_2 then
    L13_2 = type
    L14_2 = L12_2
    L13_2 = L13_2(L14_2)
    if "table" == L13_2 then
      L13_2 = ipairs
      L14_2 = L12_2
      L13_2, L14_2, L15_2, L16_2 = L13_2(L14_2)
      for L17_2, L18_2 in L13_2, L14_2, L15_2, L16_2 do
        L19_2 = math
        L19_2 = L19_2.tointeger
        L20_2 = tonumber
        L21_2 = tostring
        L22_2 = L18_2.other
        L21_2 = L21_2(L22_2)
        L22_2 = L21_2
        L21_2 = L21_2.match
        L23_2 = "^g:(%d+)$"
        L21_2, L22_2, L23_2 = L21_2(L22_2, L23_2)
        L20_2, L21_2, L22_2, L23_2 = L20_2(L21_2, L22_2, L23_2)
        L19_2 = L19_2(L20_2, L21_2, L22_2, L23_2)
        if not L19_2 then
          L19_2 = -1
        end
        L19_2 = L4_2[L19_2]
        if L19_2 then
          L20_2 = tonumber
          L21_2 = L18_2.pinned
          L20_2 = L20_2(L21_2)
          if not L20_2 then
            L20_2 = 0
          end
          L20_2 = 1 == L20_2
          L19_2.pinned = L20_2
          L20_2 = tonumber
          L21_2 = L18_2.muted_until
          L20_2 = L20_2(L21_2)
          L19_2.mutedUntil = L20_2
          L20_2 = math
          L20_2 = L20_2.tointeger
          L21_2 = tonumber
          L22_2 = L18_2.cleared_before
          L21_2, L22_2, L23_2 = L21_2(L22_2)
          L20_2 = L20_2(L21_2, L22_2, L23_2)
          L19_2.clearedBefore = L20_2
        end
      end
    end
  end
  L13_2 = table
  L13_2 = L13_2.sort
  L14_2 = L3_2
  function L15_2(A0_3, A1_3)
    local L2_3, L3_3
    L2_3 = A0_3.ts
    if not L2_3 then
      L2_3 = 0
    end
    L3_3 = A1_3.ts
    if not L3_3 then
      L3_3 = 0
    end
    L2_3 = L2_3 > L3_3
    return L2_3
  end
  L13_2(L14_2, L15_2)
  return L3_2
end
GroupListFor = L48_1
L48_1 = {}
function L49_1(A0_2, A1_2, A2_2, A3_2, A4_2, A5_2)
  local L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2, L19_2, L20_2, L21_2, L22_2, L23_2, L24_2
  L6_2 = nil
  if nil ~= A5_2 then
    L7_2 = L44_1
    L8_2 = A0_2
    L9_2 = A5_2
    L7_2 = L7_2(L8_2, L9_2)
    L6_2 = L7_2
    if not L6_2 then
      L7_2 = L7_1
      L8_2 = "media"
      return L7_2(L8_2)
    end
  end
  L7_2 = tonumber
  L8_2 = MySQL
  L8_2 = L8_2.scalar
  L8_2 = L8_2.await
  L9_2 = "SELECT COUNT(*) FROM apex_phone_conversation_members WHERE member = ? AND left_at IS NULL"
  L10_2 = {}
  L11_2 = A1_2
  L10_2[1] = L11_2
  L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2, L19_2, L20_2, L21_2, L22_2, L23_2, L24_2 = L8_2(L9_2, L10_2)
  L7_2 = L7_2(L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2, L19_2, L20_2, L21_2, L22_2, L23_2, L24_2)
  if not L7_2 then
    L7_2 = 0
  end
  L8_2 = L6_1
  L8_2 = L8_2()
  if L7_2 >= L8_2 then
    L8_2 = L7_1
    L9_2 = "limit"
    L10_2 = {}
    L11_2 = L6_1
    L11_2 = L11_2()
    L10_2.max = L11_2
    return L8_2(L9_2, L10_2)
  end
  L8_2 = L37_1
  L9_2 = A4_2
  L8_2 = L8_2(L9_2)
  L9_2 = {}
  L10_2 = ipairs
  L11_2 = A4_2
  L10_2, L11_2, L12_2, L13_2 = L10_2(L11_2)
  for L14_2, L15_2 in L10_2, L11_2, L12_2, L13_2 do
    L16_2 = L8_2[L15_2]
    if not L16_2 then
      L16_2 = #L9_2
      L16_2 = L16_2 + 1
      L9_2[L16_2] = L15_2
    end
  end
  L10_2 = #L9_2
  if L10_2 > 0 then
    L10_2 = L7_1
    L11_2 = "badnumber"
    L12_2 = {}
    L12_2.numbers = L9_2
    return L10_2(L11_2, L12_2)
  end
  L10_2 = L38_1
  L11_2 = A4_2
  L12_2 = L8_2
  L13_2 = A1_2
  L10_2 = L10_2(L11_2, L12_2, L13_2)
  L11_2 = {}
  L12_2 = {}
  L13_2 = ipairs
  L14_2 = A4_2
  L13_2, L14_2, L15_2, L16_2 = L13_2(L14_2)
  for L17_2, L18_2 in L13_2, L14_2, L15_2, L16_2 do
    L19_2 = L10_2[L18_2]
    if L19_2 then
      L19_2 = #L12_2
      L19_2 = L19_2 + 1
      L12_2[L19_2] = L18_2
    else
      L19_2 = #L11_2
      L19_2 = L19_2 + 1
      L11_2[L19_2] = L18_2
    end
  end
  L13_2 = #L11_2
  if 0 == L13_2 then
    L13_2 = L7_1
    L14_2 = "members"
    L15_2 = {}
    L15_2.skipped = L12_2
    return L13_2(L14_2, L15_2)
  end
  L13_2 = Now
  L13_2 = L13_2()
  L14_2 = nil
  if L6_2 then
    L15_2 = MySQL
    L15_2 = L15_2.insert
    L15_2 = L15_2.await
    L16_2 = "INSERT INTO apex_phone_conversations (app, title, avatar, created_by, created) VALUES (?, ?, ?, ?, ?)"
    L17_2 = {}
    L18_2 = A2_2
    L19_2 = A3_2
    L20_2 = L6_2
    L21_2 = A1_2
    L22_2 = L13_2
    L17_2[1] = L18_2
    L17_2[2] = L19_2
    L17_2[3] = L20_2
    L17_2[4] = L21_2
    L17_2[5] = L22_2
    L15_2 = L15_2(L16_2, L17_2)
    L14_2 = L15_2
  else
    L15_2 = MySQL
    L15_2 = L15_2.insert
    L15_2 = L15_2.await
    L16_2 = "INSERT INTO apex_phone_conversations (app, title, created_by, created) VALUES (?, ?, ?, ?)"
    L17_2 = {}
    L18_2 = A2_2
    L19_2 = A3_2
    L20_2 = A1_2
    L21_2 = L13_2
    L17_2[1] = L18_2
    L17_2[2] = L19_2
    L17_2[3] = L20_2
    L17_2[4] = L21_2
    L15_2 = L15_2(L16_2, L17_2)
    L14_2 = L15_2
  end
  L15_2 = L8_1
  L16_2 = L14_2
  L15_2 = L15_2(L16_2)
  L14_2 = L15_2
  if not L14_2 then
    L15_2 = L7_1
    L16_2 = "db"
    return L15_2(L16_2)
  end
  L15_2 = {}
  L16_2 = "(?, ?, ?, ?)"
  L15_2[1] = L16_2
  L16_2 = {}
  L17_2 = L14_2
  L18_2 = A1_2
  L19_2 = "admin"
  L20_2 = L13_2
  L16_2[1] = L17_2
  L16_2[2] = L18_2
  L16_2[3] = L19_2
  L16_2[4] = L20_2
  L17_2 = ipairs
  L18_2 = L11_2
  L17_2, L18_2, L19_2, L20_2 = L17_2(L18_2)
  for L21_2, L22_2 in L17_2, L18_2, L19_2, L20_2 do
    L23_2 = #L15_2
    L23_2 = L23_2 + 1
    L15_2[L23_2] = "(?, ?, ?, ?)"
    L23_2 = #L16_2
    L24_2 = L23_2 + 1
    L16_2[L24_2] = L14_2
    L24_2 = L23_2 + 2
    L16_2[L24_2] = L22_2
    L24_2 = L23_2 + 3
    L16_2[L24_2] = "member"
    L24_2 = L23_2 + 4
    L16_2[L24_2] = L13_2
  end
  L17_2 = pcall
  L18_2 = MySQL
  L18_2 = L18_2.query
  L18_2 = L18_2.await
  L19_2 = "INSERT INTO apex_phone_conversation_members (conversation_id, member, role, joined) VALUES "
  L20_2 = table
  L20_2 = L20_2.concat
  L21_2 = L15_2
  L22_2 = ", "
  L20_2 = L20_2(L21_2, L22_2)
  L19_2 = L19_2 .. L20_2
  L20_2 = L16_2
  L17_2, L18_2 = L17_2(L18_2, L19_2, L20_2)
  if not L17_2 or nil == L18_2 then
    L19_2 = pcall
    L20_2 = MySQL
    L20_2 = L20_2.query
    L20_2 = L20_2.await
    L21_2 = "DELETE FROM apex_phone_conversation_members WHERE conversation_id = ?"
    L22_2 = {}
    L23_2 = L14_2
    L22_2[1] = L23_2
    L19_2(L20_2, L21_2, L22_2)
    L19_2 = pcall
    L20_2 = MySQL
    L20_2 = L20_2.query
    L20_2 = L20_2.await
    L21_2 = "DELETE FROM apex_phone_conversations WHERE id = ?"
    L22_2 = {}
    L23_2 = L14_2
    L22_2[1] = L23_2
    L19_2(L20_2, L21_2, L22_2)
    L19_2 = print
    L20_2 = "^1[unique_phone]^0 groups.create: members not saved (%s)"
    L21_2 = L20_2
    L20_2 = L20_2.format
    L22_2 = tostring
    L23_2 = L18_2
    L22_2, L23_2, L24_2 = L22_2(L23_2)
    L20_2, L21_2, L22_2, L23_2, L24_2 = L20_2(L21_2, L22_2, L23_2, L24_2)
    L19_2(L20_2, L21_2, L22_2, L23_2, L24_2)
    L19_2 = L7_1
    L20_2 = "db"
    return L19_2(L20_2)
  end
  L19_2 = {}
  L19_2.id = L14_2
  L19_2.app = A2_2
  L19_2.title = A3_2
  L19_2.avatar = L6_2
  L19_2.created_by = A1_2
  L19_2.created = L13_2
  L20_2 = L25_1
  L21_2 = L14_2
  function L22_2()
    local L0_3, L1_3, L2_3, L3_3, L4_3, L5_3, L6_3, L7_3
    L0_3 = L34_1
    L1_3 = L19_2
    L2_3 = A1_2
    L3_3 = "create"
    L4_3 = "%s criou o grupo \194\171%s\194\187"
    L5_3 = L4_3
    L4_3 = L4_3.format
    L6_3 = A1_2
    L7_3 = A3_2
    L4_3 = L4_3(L5_3, L6_3, L7_3)
    L5_3 = {}
    L6_3 = A3_2
    L5_3.title = L6_3
    L6_3 = L11_2
    L5_3.targets = L6_3
    L0_3(L1_3, L2_3, L3_3, L4_3, L5_3)
    L0_3 = L42_1
    L1_3 = L19_2
    L2_3 = A1_2
    L3_3 = L11_2
    L4_3 = L8_2
    L0_3(L1_3, L2_3, L3_3, L4_3)
    L0_3 = L35_1
    L1_3 = L19_2
    L2_3 = {}
    L2_3.action = "create"
    L3_3 = A1_2
    L2_3.by = L3_3
    L3_3 = A3_2
    L2_3.title = L3_3
    L0_3(L1_3, L2_3)
    L0_3 = Dbg
    L1_3 = "groups"
    L2_3 = "group %s \"%s\" created by %s with %s member(s)"
    L3_3 = L14_2
    L4_3 = A3_2
    L5_3 = A1_2
    L6_3 = L11_2
    L6_3 = #L6_3
    L0_3(L1_3, L2_3, L3_3, L4_3, L5_3, L6_3)
    L0_3 = L43_1
    L1_3 = A0_2
    L2_3 = L19_2
    L3_3 = A1_2
    L4_3 = "admin"
    L0_3 = L0_3(L1_3, L2_3, L3_3, L4_3)
    L1_3 = L12_2
    L1_3 = #L1_3
    if L1_3 > 0 then
      L1_3 = L12_2
      L0_3.skipped = L1_3
    end
    return L0_3
  end
  return L20_2(L21_2, L22_2)
end
L50_1 = RPC
function L51_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2, L19_2
  L2_2 = type
  L3_2 = A1_2.app
  L2_2 = L2_2(L3_2)
  if "string" == L2_2 then
    L3_2 = A1_2.app
    L2_2 = L0_1
    L2_2 = L2_2[L3_2]
    if L2_2 then
      L2_2 = A1_2.app
      if L2_2 then
        goto lbl_15
      end
    end
  end
  L2_2 = "sms"
  ::lbl_15::
  if "recado" == L2_2 then
    L3_2 = L7_1
    L4_2 = "unsupported"
    return L3_2(L4_2)
  end
  L3_2 = L16_1
  L4_2 = A0_2
  L5_2 = L2_2
  L3_2 = L3_2(L4_2, L5_2)
  if not L3_2 then
    L4_2 = L7_1
    L5_2 = "noidentity"
    return L4_2(L5_2)
  end
  L4_2 = HasPhoneItem
  L5_2 = A0_2
  L4_2 = L4_2(L5_2)
  if not L4_2 then
    L4_2 = L7_1
    L5_2 = "nophone"
    return L4_2(L5_2)
  end
  L4_2 = L13_1
  L5_2 = A1_2.name
  L4_2 = L4_2(L5_2)
  if not L4_2 then
    L5_2 = L7_1
    L6_2 = "name"
    return L5_2(L6_2)
  end
  L5_2 = L36_1
  L6_2 = A1_2.members
  L7_2 = L3_2
  L5_2, L6_2, L7_2 = L5_2(L6_2, L7_2)
  if not L5_2 then
    L8_2 = L7_1
    L9_2 = L6_2
    L10_2 = L7_2
    return L8_2(L9_2, L10_2)
  end
  L8_2 = #L5_2
  if 0 == L8_2 then
    L8_2 = L7_1
    L9_2 = "members"
    return L8_2(L9_2)
  end
  L8_2 = L5_1
  L8_2 = L8_2()
  L9_2 = #L5_2
  L9_2 = L9_2 + 1
  if L8_2 < L9_2 then
    L9_2 = L7_1
    L10_2 = "toomany"
    L11_2 = {}
    L11_2.max = L8_2
    return L9_2(L10_2, L11_2)
  end
  L9_2 = A1_2.avatar
  L9_2 = nil == L9_2
  if not L9_2 then
    L10_2 = L8_1
    L11_2 = A1_2.avatar
    L10_2 = L10_2(L11_2)
    if not L10_2 then
      L10_2 = L7_1
      L11_2 = "media"
      return L10_2(L11_2)
    end
  end
  L10_2 = GetGameTimer
  L10_2 = L10_2()
  L11_2 = L48_1
  L11_2 = L11_2[A0_2]
  if L11_2 then
    L11_2 = L48_1
    L11_2 = L11_2[A0_2]
    L11_2 = L10_2 - L11_2
    L12_2 = L1_1
    if L11_2 < L12_2 then
      L11_2 = L7_1
      L12_2 = "cooldown"
      return L11_2(L12_2)
    end
  end
  L11_2 = L48_1
  L11_2 = L11_2[A0_2]
  L12_2 = L48_1
  L12_2[A0_2] = L10_2
  L12_2 = pcall
  L13_2 = L49_1
  L14_2 = A0_2
  L15_2 = L3_2
  L16_2 = L2_2
  L17_2 = L4_2
  L18_2 = L5_2
  if not L9_2 then
    L19_2 = A1_2.avatar
    if L19_2 then
      goto lbl_140
    end
  end
  L19_2 = nil
  ::lbl_140::
  L12_2, L13_2 = L12_2(L13_2, L14_2, L15_2, L16_2, L17_2, L18_2, L19_2)
  if L12_2 then
    L14_2 = type
    L15_2 = L13_2
    L14_2 = L14_2(L15_2)
    if "table" == L14_2 then
      L14_2 = L13_2.ok
      if false == L14_2 then
        L14_2 = L48_1
        L14_2 = L14_2[A0_2]
        if L14_2 == L10_2 then
          L14_2 = L48_1
          L14_2[A0_2] = L11_2
        end
      end
    end
  end
  if not L12_2 then
    L14_2 = error
    L15_2 = L13_2
    L16_2 = 0
    L14_2(L15_2, L16_2)
  end
  return L13_2
end
L50_1["groups.create"] = L51_1
L50_1 = RPC
function L51_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2
  L2_2 = L9_1
  L3_2 = A1_2.id
  L2_2 = L2_2(L3_2)
  if not L2_2 then
    L3_2 = L7_1
    L4_2 = "invalid"
    return L3_2(L4_2)
  end
  L3_2 = L23_1
  L4_2 = A0_2
  L5_2 = L2_2
  L6_2 = false
  L3_2, L4_2, L5_2, L6_2 = L3_2(L4_2, L5_2, L6_2)
  if not L3_2 then
    L7_2 = L7_1
    L8_2 = L6_2
    return L7_2(L8_2)
  end
  L7_2 = L43_1
  L8_2 = A0_2
  L9_2 = L3_2
  L10_2 = L4_2
  L11_2 = L5_2.role
  return L7_2(L8_2, L9_2, L10_2, L11_2)
end
L50_1["groups.info"] = L51_1
L50_1 = RPC
function L51_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2, L6_2
  L2_2 = type
  L3_2 = A1_2.app
  L2_2 = L2_2(L3_2)
  if "string" == L2_2 then
    L3_2 = A1_2.app
    L2_2 = L0_1
    L2_2 = L2_2[L3_2]
    if L2_2 then
      L2_2 = A1_2.app
      if L2_2 then
        goto lbl_15
      end
    end
  end
  L2_2 = "sms"
  ::lbl_15::
  L3_2 = L16_1
  L4_2 = A0_2
  L5_2 = L2_2
  L3_2 = L3_2(L4_2, L5_2)
  if not L3_2 then
    L4_2 = {}
    return L4_2
  end
  L4_2 = GroupListFor
  L5_2 = L3_2
  L6_2 = L2_2
  return L4_2(L5_2, L6_2)
end
L50_1["groups.list"] = L51_1
L50_1 = RPC
function L51_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2, L6_2
  L2_2 = L9_1
  L3_2 = A1_2.id
  L2_2 = L2_2(L3_2)
  if not L2_2 then
    L3_2 = L7_1
    L4_2 = "invalid"
    return L3_2(L4_2)
  end
  L3_2 = L13_1
  L4_2 = A1_2.name
  L3_2 = L3_2(L4_2)
  if not L3_2 then
    L4_2 = L7_1
    L5_2 = "name"
    return L4_2(L5_2)
  end
  L4_2 = L25_1
  L5_2 = L2_2
  function L6_2()
    local L0_3, L1_3, L2_3, L3_3, L4_3, L5_3, L6_3, L7_3, L8_3, L9_3, L10_3, L11_3
    L0_3 = L23_1
    L1_3 = A0_2
    L2_3 = L2_2
    L3_3 = true
    L0_3, L1_3, L2_3, L3_3 = L0_3(L1_3, L2_3, L3_3)
    if not L0_3 then
      L4_3 = L7_1
      L5_3 = L3_3
      return L4_3(L5_3)
    end
    L4_3 = L26_1
    L5_3 = L0_3
    L4_3 = L4_3(L5_3)
    if L4_3 then
      L4_3 = L7_1
      L5_3 = "unsupported"
      return L4_3(L5_3)
    end
    L4_3 = L0_3.title
    L5_3 = L3_2
    if L4_3 ~= L5_3 then
      L4_3 = MySQL
      L4_3 = L4_3.update
      L4_3 = L4_3.await
      L5_3 = "UPDATE apex_phone_conversations SET title = ? WHERE id = ?"
      L6_3 = {}
      L7_3 = L3_2
      L8_3 = L2_2
      L6_3[1] = L7_3
      L6_3[2] = L8_3
      L4_3(L5_3, L6_3)
      L4_3 = L3_2
      L0_3.title = L4_3
      L4_3 = L34_1
      L5_3 = L0_3
      L6_3 = L1_3
      L7_3 = "rename"
      L8_3 = "%s mudou o nome do grupo para \194\171%s\194\187"
      L9_3 = L8_3
      L8_3 = L8_3.format
      L10_3 = L1_3
      L11_3 = L3_2
      L8_3 = L8_3(L9_3, L10_3, L11_3)
      L9_3 = {}
      L10_3 = L3_2
      L9_3.title = L10_3
      L4_3(L5_3, L6_3, L7_3, L8_3, L9_3)
      L4_3 = L35_1
      L5_3 = L0_3
      L6_3 = {}
      L6_3.action = "rename"
      L6_3.by = L1_3
      L7_3 = L3_2
      L6_3.title = L7_3
      L4_3(L5_3, L6_3)
    end
    L4_3 = L43_1
    L5_3 = A0_2
    L6_3 = L0_3
    L7_3 = L1_3
    L8_3 = L2_3.role
    return L4_3(L5_3, L6_3, L7_3, L8_3)
  end
  return L4_2(L5_2, L6_2)
end
L50_1["groups.rename"] = L51_1
L50_1 = RPC
function L51_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2, L6_2, L7_2
  L2_2 = L9_1
  L3_2 = A1_2.id
  L2_2 = L2_2(L3_2)
  if not L2_2 then
    L3_2 = L7_1
    L4_2 = "invalid"
    return L3_2(L4_2)
  end
  L3_2 = A1_2.mediaId
  L3_2 = nil == L3_2
  if not L3_2 then
    L4_2 = L8_1
    L5_2 = A1_2.mediaId
    L4_2 = L4_2(L5_2)
    if L4_2 then
      goto lbl_32
    end
  end
  L4_2 = nil
  ::lbl_32::
  if not L3_2 and not L4_2 then
    L5_2 = L7_1
    L6_2 = "media"
    return L5_2(L6_2)
  end
  L5_2 = L25_1
  L6_2 = L2_2
  function L7_2()
    local L0_3, L1_3, L2_3, L3_3, L4_3, L5_3, L6_3, L7_3, L8_3, L9_3, L10_3
    L0_3 = L23_1
    L1_3 = A0_2
    L2_3 = L2_2
    L3_3 = true
    L0_3, L1_3, L2_3, L3_3 = L0_3(L1_3, L2_3, L3_3)
    if not L0_3 then
      L4_3 = L7_1
      L5_3 = L3_3
      return L4_3(L5_3)
    end
    L4_3 = L26_1
    L5_3 = L0_3
    L4_3 = L4_3(L5_3)
    if L4_3 then
      L4_3 = L7_1
      L5_3 = "unsupported"
      return L4_3(L5_3)
    end
    L4_3 = L4_2
    if L4_3 then
      L4_3 = L44_1
      L5_3 = A0_2
      L6_3 = L4_2
      L4_3 = L4_3(L5_3, L6_3)
      if not L4_3 then
        L4_3 = L7_1
        L5_3 = "media"
        return L4_3(L5_3)
      end
    end
    L4_3 = L0_3.avatar
    L5_3 = L4_2
    if L4_3 ~= L5_3 then
      L4_3 = L4_2
      if L4_3 then
        L4_3 = MySQL
        L4_3 = L4_3.update
        L4_3 = L4_3.await
        L5_3 = "UPDATE apex_phone_conversations SET avatar = ? WHERE id = ?"
        L6_3 = {}
        L7_3 = L4_2
        L8_3 = L2_2
        L6_3[1] = L7_3
        L6_3[2] = L8_3
        L4_3(L5_3, L6_3)
      else
        L4_3 = MySQL
        L4_3 = L4_3.update
        L4_3 = L4_3.await
        L5_3 = "UPDATE apex_phone_conversations SET avatar = NULL WHERE id = ?"
        L6_3 = {}
        L7_3 = L2_2
        L6_3[1] = L7_3
        L4_3(L5_3, L6_3)
      end
      L4_3 = L4_2
      L0_3.avatar = L4_3
      L4_3 = L34_1
      L5_3 = L0_3
      L6_3 = L1_3
      L7_3 = "avatar"
      L8_3 = L4_2
      if L8_3 then
        L8_3 = "%s mudou a imagem do grupo"
        if L8_3 then
          goto lbl_74
        end
      end
      L8_3 = "%s removeu a imagem do grupo"
      ::lbl_74::
      L9_3 = L8_3
      L8_3 = L8_3.format
      L10_3 = L1_3
      L8_3 = L8_3(L9_3, L10_3)
      L9_3 = {}
      L10_3 = L4_2
      L9_3.avatar = L10_3
      L4_3(L5_3, L6_3, L7_3, L8_3, L9_3)
      L4_3 = L35_1
      L5_3 = L0_3
      L6_3 = {}
      L6_3.action = "avatar"
      L6_3.by = L1_3
      L7_3 = L4_2
      L6_3.avatar = L7_3
      L4_3(L5_3, L6_3)
    end
    L4_3 = L43_1
    L5_3 = A0_2
    L6_3 = L0_3
    L7_3 = L1_3
    L8_3 = L2_3.role
    return L4_3(L5_3, L6_3, L7_3, L8_3)
  end
  return L5_2(L6_2, L7_2)
end
L50_1["groups.setAvatar"] = L51_1
L50_1 = RPC
function L51_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2, L6_2
  L2_2 = L9_1
  L3_2 = A1_2.id
  L2_2 = L2_2(L3_2)
  if not L2_2 then
    L3_2 = L7_1
    L4_2 = "invalid"
    return L3_2(L4_2)
  end
  L3_2 = HasPhoneItem
  L4_2 = A0_2
  L3_2 = L3_2(L4_2)
  if not L3_2 then
    L3_2 = L7_1
    L4_2 = "nophone"
    return L3_2(L4_2)
  end
  L3_2 = A1_2.numbers
  if nil == L3_2 then
    L4_2 = A1_2.number
    if nil ~= L4_2 then
      L4_2 = {}
      L5_2 = A1_2.number
      L4_2[1] = L5_2
      L3_2 = L4_2
    end
  end
  L4_2 = L25_1
  L5_2 = L2_2
  function L6_2()
    local L0_3, L1_3, L2_3, L3_3, L4_3, L5_3, L6_3, L7_3, L8_3, L9_3, L10_3, L11_3, L12_3, L13_3, L14_3, L15_3, L16_3, L17_3, L18_3, L19_3, L20_3, L21_3, L22_3, L23_3, L24_3, L25_3, L26_3, L27_3, L28_3, L29_3, L30_3
    L0_3 = L23_1
    L1_3 = A0_2
    L2_3 = L2_2
    L3_3 = true
    L0_3, L1_3, L2_3, L3_3 = L0_3(L1_3, L2_3, L3_3)
    if not L0_3 then
      L4_3 = L7_1
      L5_3 = L3_3
      return L4_3(L5_3)
    end
    L4_3 = L26_1
    L5_3 = L0_3
    L4_3 = L4_3(L5_3)
    if L4_3 then
      L4_3 = L7_1
      L5_3 = "unsupported"
      return L4_3(L5_3)
    end
    L4_3 = L36_1
    L5_3 = L3_2
    L6_3 = L1_3
    L4_3, L5_3, L6_3 = L4_3(L5_3, L6_3)
    if not L4_3 then
      L7_3 = L7_1
      L8_3 = L5_3
      L9_3 = L6_3
      return L7_3(L8_3, L9_3)
    end
    L7_3 = #L4_3
    if 0 == L7_3 then
      L7_3 = L7_1
      L8_3 = "members"
      return L7_3(L8_3)
    end
    L7_3 = GroupMembers
    L8_3 = L2_2
    L7_3 = L7_3(L8_3)
    L8_3 = {}
    L9_3 = ipairs
    L10_3 = L7_3
    L9_3, L10_3, L11_3, L12_3 = L9_3(L10_3)
    for L13_3, L14_3 in L9_3, L10_3, L11_3, L12_3 do
      L8_3[L14_3] = true
    end
    L9_3 = {}
    L10_3 = {}
    L11_3 = ipairs
    L12_3 = L4_3
    L11_3, L12_3, L13_3, L14_3 = L11_3(L12_3)
    for L15_3, L16_3 in L11_3, L12_3, L13_3, L14_3 do
      L17_3 = L8_3[L16_3]
      if L17_3 then
        L17_3 = #L10_3
        L17_3 = L17_3 + 1
        L10_3[L17_3] = L16_3
      else
        L17_3 = #L9_3
        L17_3 = L17_3 + 1
        L9_3[L17_3] = L16_3
      end
    end
    L11_3 = #L9_3
    if 0 == L11_3 then
      L11_3 = L43_1
      L12_3 = A0_2
      L13_3 = L0_3
      L14_3 = L1_3
      L15_3 = L2_3.role
      L11_3 = L11_3(L12_3, L13_3, L14_3, L15_3)
      L12_3 = {}
      L11_3.already = L10_3
      L11_3.added = L12_3
      return L11_3
    end
    L11_3 = L5_1
    L11_3 = L11_3()
    L12_3 = #L7_3
    L13_3 = #L9_3
    L12_3 = L12_3 + L13_3
    if L11_3 < L12_3 then
      L12_3 = L7_1
      L13_3 = "toomany"
      L14_3 = {}
      L14_3.max = L11_3
      return L12_3(L13_3, L14_3)
    end
    L12_3 = L37_1
    L13_3 = L9_3
    L12_3 = L12_3(L13_3)
    L13_3 = {}
    L14_3 = ipairs
    L15_3 = L9_3
    L14_3, L15_3, L16_3, L17_3 = L14_3(L15_3)
    for L18_3, L19_3 in L14_3, L15_3, L16_3, L17_3 do
      L20_3 = L12_3[L19_3]
      if not L20_3 then
        L20_3 = #L13_3
        L20_3 = L20_3 + 1
        L13_3[L20_3] = L19_3
      end
    end
    L14_3 = #L13_3
    if L14_3 > 0 then
      L14_3 = L7_1
      L15_3 = "badnumber"
      L16_3 = {}
      L16_3.numbers = L13_3
      return L14_3(L15_3, L16_3)
    end
    L14_3 = L38_1
    L15_3 = L9_3
    L16_3 = L12_3
    L17_3 = L1_3
    L14_3 = L14_3(L15_3, L16_3, L17_3)
    L15_3 = {}
    L16_3 = {}
    L17_3 = ipairs
    L18_3 = L9_3
    L17_3, L18_3, L19_3, L20_3 = L17_3(L18_3)
    for L21_3, L22_3 in L17_3, L18_3, L19_3, L20_3 do
      L23_3 = L14_3[L22_3]
      if L23_3 then
        L23_3 = #L16_3
        L23_3 = L23_3 + 1
        L16_3[L23_3] = L22_3
      else
        L23_3 = #L15_3
        L23_3 = L23_3 + 1
        L15_3[L23_3] = L22_3
      end
    end
    L17_3 = #L15_3
    if 0 == L17_3 then
      L17_3 = L7_1
      L18_3 = "members"
      L19_3 = {}
      L19_3.skipped = L16_3
      return L17_3(L18_3, L19_3)
    end
    L17_3 = Now
    L17_3 = L17_3()
    L18_3 = L0_3.last_id
    if not L18_3 then
      L18_3 = 0
    end
    L19_3 = {}
    L20_3 = {}
    L21_3 = ipairs
    L22_3 = L15_3
    L21_3, L22_3, L23_3, L24_3 = L21_3(L22_3)
    for L25_3, L26_3 in L21_3, L22_3, L23_3, L24_3 do
      L27_3 = #L19_3
      L27_3 = L27_3 + 1
      L19_3[L27_3] = "(?, ?, 'member', ?, ?, NULL)"
      L27_3 = #L20_3
      L28_3 = L27_3 + 1
      L29_3 = L2_2
      L20_3[L28_3] = L29_3
      L28_3 = L27_3 + 2
      L20_3[L28_3] = L26_3
      L28_3 = L27_3 + 3
      L20_3[L28_3] = L17_3
      L28_3 = L27_3 + 4
      L20_3[L28_3] = L18_3
    end
    L21_3 = MySQL
    L21_3 = L21_3.update
    L21_3 = L21_3.await
    L22_3 = "INSERT INTO apex_phone_conversation_members (conversation_id, member, role, joined, last_read_id, left_at) VALUES "
    L23_3 = table
    L23_3 = L23_3.concat
    L24_3 = L19_3
    L25_3 = ", "
    L23_3 = L23_3(L24_3, L25_3)
    L24_3 = " ON DUPLICATE KEY UPDATE role = 'member', joined = VALUES(joined), last_read_id = VALUES(last_read_id), left_at = NULL"
    L22_3 = L22_3 .. L23_3 .. L24_3
    L23_3 = L20_3
    L21_3(L22_3, L23_3)
    L21_3 = L34_1
    L22_3 = L0_3
    L23_3 = L1_3
    L24_3 = "add"
    L25_3 = "%s adicionou %s"
    L26_3 = L25_3
    L25_3 = L25_3.format
    L27_3 = L1_3
    L28_3 = table
    L28_3 = L28_3.concat
    L29_3 = L15_3
    L30_3 = ", "
    L28_3, L29_3, L30_3 = L28_3(L29_3, L30_3)
    L25_3 = L25_3(L26_3, L27_3, L28_3, L29_3, L30_3)
    L26_3 = {}
    L26_3.targets = L15_3
    L21_3(L22_3, L23_3, L24_3, L25_3, L26_3)
    L21_3 = L42_1
    L22_3 = L0_3
    L23_3 = L1_3
    L24_3 = L15_3
    L25_3 = L12_3
    L21_3(L22_3, L23_3, L24_3, L25_3)
    L21_3 = L35_1
    L22_3 = L0_3
    L23_3 = {}
    L23_3.action = "add"
    L23_3.by = L1_3
    L23_3.targets = L15_3
    L21_3(L22_3, L23_3)
    L21_3 = Dbg
    L22_3 = "groups"
    L23_3 = "%s added %s to group %s"
    L24_3 = L1_3
    L25_3 = table
    L25_3 = L25_3.concat
    L26_3 = L15_3
    L27_3 = ", "
    L25_3 = L25_3(L26_3, L27_3)
    L26_3 = L2_2
    L21_3(L22_3, L23_3, L24_3, L25_3, L26_3)
    L21_3 = L43_1
    L22_3 = A0_2
    L23_3 = L0_3
    L24_3 = L1_3
    L25_3 = L2_3.role
    L21_3 = L21_3(L22_3, L23_3, L24_3, L25_3)
    L21_3.added = L15_3
    L22_3 = #L16_3
    if L22_3 > 0 then
      L21_3.skipped = L16_3
    end
    L22_3 = #L10_3
    if L22_3 > 0 then
      L21_3.already = L10_3
    end
    return L21_3
  end
  return L4_2(L5_2, L6_2)
end
L50_1["groups.add"] = L51_1
L50_1 = RPC
function L51_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2, L6_2
  L2_2 = L9_1
  L3_2 = A1_2.id
  L2_2 = L2_2(L3_2)
  if not L2_2 then
    L3_2 = L7_1
    L4_2 = "invalid"
    return L3_2(L4_2)
  end
  L3_2 = L15_1
  L4_2 = A1_2.number
  L3_2 = L3_2(L4_2)
  if not L3_2 then
    L4_2 = L7_1
    L5_2 = "invalid"
    return L4_2(L5_2)
  end
  L4_2 = L25_1
  L5_2 = L2_2
  function L6_2()
    local L0_3, L1_3, L2_3, L3_3, L4_3, L5_3, L6_3, L7_3, L8_3, L9_3, L10_3, L11_3
    L0_3 = L23_1
    L1_3 = A0_2
    L2_3 = L2_2
    L3_3 = false
    L0_3, L1_3, L2_3, L3_3 = L0_3(L1_3, L2_3, L3_3)
    if not L0_3 then
      L4_3 = L7_1
      L5_3 = L3_3
      return L4_3(L5_3)
    end
    L4_3 = L26_1
    L5_3 = L0_3
    L4_3 = L4_3(L5_3)
    if L4_3 then
      L4_3 = L7_1
      L5_3 = "unsupported"
      return L4_3(L5_3)
    end
    L4_3 = L3_2
    if L4_3 == L1_3 then
      L4_3 = L46_1
      L5_3 = L0_3
      L6_3 = L1_3
      return L4_3(L5_3, L6_3)
    end
    L4_3 = L2_3.role
    if "admin" ~= L4_3 then
      L4_3 = L7_1
      L5_3 = "notadmin"
      return L4_3(L5_3)
    end
    L4_3 = L21_1
    L5_3 = L2_2
    L6_3 = L3_2
    L4_3 = L4_3(L5_3, L6_3)
    if not L4_3 then
      L4_3 = L7_1
      L5_3 = "notmember"
      return L4_3(L5_3)
    end
    L4_3 = MySQL
    L4_3 = L4_3.update
    L4_3 = L4_3.await
    L5_3 = "UPDATE apex_phone_conversation_members SET left_at = ?, role = 'member' WHERE conversation_id = ? AND member = ? AND left_at IS NULL"
    L6_3 = {}
    L7_3 = Now
    L7_3 = L7_3()
    L8_3 = L2_2
    L9_3 = L3_2
    L6_3[1] = L7_3
    L6_3[2] = L8_3
    L6_3[3] = L9_3
    L4_3(L5_3, L6_3)
    L4_3 = pcall
    L5_3 = MySQL
    L5_3 = L5_3.query
    L5_3 = L5_3.await
    L6_3 = "DELETE FROM apex_phone_thread_meta WHERE owner = ? AND app = ? AND other = ?"
    L7_3 = {}
    L8_3 = L3_2
    L9_3 = L0_3.app
    L10_3 = "g:"
    L11_3 = L2_2
    L10_3 = L10_3 .. L11_3
    L7_3[1] = L8_3
    L7_3[2] = L9_3
    L7_3[3] = L10_3
    L4_3(L5_3, L6_3, L7_3)
    L4_3 = L34_1
    L5_3 = L0_3
    L6_3 = L1_3
    L7_3 = "remove"
    L8_3 = "%s removeu %s"
    L9_3 = L8_3
    L8_3 = L8_3.format
    L10_3 = L1_3
    L11_3 = L3_2
    L8_3 = L8_3(L9_3, L10_3, L11_3)
    L9_3 = {}
    L10_3 = {}
    L11_3 = L3_2
    L10_3[1] = L11_3
    L9_3.targets = L10_3
    L4_3(L5_3, L6_3, L7_3, L8_3, L9_3)
    L4_3 = L35_1
    L5_3 = L0_3
    L6_3 = {}
    L6_3.action = "remove"
    L6_3.by = L1_3
    L7_3 = {}
    L8_3 = L3_2
    L7_3[1] = L8_3
    L6_3.targets = L7_3
    L4_3(L5_3, L6_3)
    L4_3 = L19_1
    L4_3 = L4_3()
    L5_3 = L3_2
    L4_3 = L4_3[L5_3]
    if L4_3 then
      L5_3 = Push
      L6_3 = L4_3
      L7_3 = "groupUpdate"
      L8_3 = {}
      L9_3 = L2_2
      L8_3.id = L9_3
      L8_3.action = "remove"
      L8_3.by = L1_3
      L9_3 = {}
      L10_3 = L3_2
      L9_3[1] = L10_3
      L8_3.targets = L9_3
      L8_3.removed = true
      L5_3(L6_3, L7_3, L8_3)
      L5_3 = type
      L6_3 = MediaRevoke
      L5_3 = L5_3(L6_3)
      if "function" == L5_3 then
        L5_3 = pcall
        L6_3 = MediaRevoke
        L7_3 = L4_3
        L5_3(L6_3, L7_3)
      end
    end
    L5_3 = Dbg
    L6_3 = "groups"
    L7_3 = "%s removed %s from group %s"
    L8_3 = L1_3
    L9_3 = L3_2
    L10_3 = L2_2
    L5_3(L6_3, L7_3, L8_3, L9_3, L10_3)
    L5_3 = L43_1
    L6_3 = A0_2
    L7_3 = L0_3
    L8_3 = L1_3
    L9_3 = L2_3.role
    return L5_3(L6_3, L7_3, L8_3, L9_3)
  end
  return L4_2(L5_2, L6_2)
end
L50_1["groups.remove"] = L51_1
L50_1 = RPC
function L51_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2, L6_2, L7_2
  L2_2 = L9_1
  L3_2 = A1_2.id
  L2_2 = L2_2(L3_2)
  if not L2_2 then
    L3_2 = L7_1
    L4_2 = "invalid"
    return L3_2(L4_2)
  end
  L3_2 = L15_1
  L4_2 = A1_2.number
  L3_2 = L3_2(L4_2)
  L4_2 = A1_2.role
  if not L3_2 or "admin" ~= L4_2 and "member" ~= L4_2 then
    L5_2 = L7_1
    L6_2 = "invalid"
    return L5_2(L6_2)
  end
  L5_2 = L25_1
  L6_2 = L2_2
  function L7_2()
    local L0_3, L1_3, L2_3, L3_3, L4_3, L5_3, L6_3, L7_3, L8_3, L9_3, L10_3, L11_3, L12_3, L13_3
    L0_3 = L23_1
    L1_3 = A0_2
    L2_3 = L2_2
    L3_3 = true
    L0_3, L1_3, L2_3, L3_3 = L0_3(L1_3, L2_3, L3_3)
    if not L0_3 then
      L4_3 = L7_1
      L5_3 = L3_3
      return L4_3(L5_3)
    end
    L4_3 = L26_1
    L5_3 = L0_3
    L4_3 = L4_3(L5_3)
    if L4_3 then
      L4_3 = L7_1
      L5_3 = "unsupported"
      return L4_3(L5_3)
    end
    L4_3 = L21_1
    L5_3 = L2_2
    L6_3 = L3_2
    L4_3 = L4_3(L5_3, L6_3)
    if not L4_3 then
      L5_3 = L7_1
      L6_3 = "notmember"
      return L5_3(L6_3)
    end
    L5_3 = L4_3.role
    L6_3 = L4_2
    if L5_3 ~= L6_3 then
      L5_3 = L4_2
      if "member" == L5_3 then
        L5_3 = tonumber
        L6_3 = MySQL
        L6_3 = L6_3.scalar
        L6_3 = L6_3.await
        L7_3 = "SELECT COUNT(*) FROM apex_phone_conversation_members WHERE conversation_id = ? AND role = 'admin' AND left_at IS NULL"
        L8_3 = {}
        L9_3 = L2_2
        L8_3[1] = L9_3
        L6_3, L7_3, L8_3, L9_3, L10_3, L11_3, L12_3, L13_3 = L6_3(L7_3, L8_3)
        L5_3 = L5_3(L6_3, L7_3, L8_3, L9_3, L10_3, L11_3, L12_3, L13_3)
        if not L5_3 then
          L5_3 = 0
        end
        if L5_3 <= 1 then
          L6_3 = L7_1
          L7_3 = "lastadmin"
          return L6_3(L7_3)
        end
      end
      L5_3 = MySQL
      L5_3 = L5_3.update
      L5_3 = L5_3.await
      L6_3 = "UPDATE apex_phone_conversation_members SET role = ? WHERE conversation_id = ? AND member = ? AND left_at IS NULL"
      L7_3 = {}
      L8_3 = L4_2
      L9_3 = L2_2
      L10_3 = L3_2
      L7_3[1] = L8_3
      L7_3[2] = L9_3
      L7_3[3] = L10_3
      L5_3(L6_3, L7_3)
      L5_3 = nil
      L6_3 = L4_2
      if "admin" == L6_3 then
        L6_3 = "%s nomeou %s administrador"
        L7_3 = L6_3
        L6_3 = L6_3.format
        L8_3 = L1_3
        L9_3 = L3_2
        L6_3 = L6_3(L7_3, L8_3, L9_3)
        L5_3 = L6_3
      else
        L6_3 = L3_2
        if L6_3 == L1_3 then
          L6_3 = "%s deixou de ser administrador"
          L7_3 = L6_3
          L6_3 = L6_3.format
          L8_3 = L1_3
          L6_3 = L6_3(L7_3, L8_3)
          L5_3 = L6_3
        else
          L6_3 = "%s retirou a administra\195\167\195\163o a %s"
          L7_3 = L6_3
          L6_3 = L6_3.format
          L8_3 = L1_3
          L9_3 = L3_2
          L6_3 = L6_3(L7_3, L8_3, L9_3)
          L5_3 = L6_3
        end
      end
      L6_3 = L34_1
      L7_3 = L0_3
      L8_3 = L1_3
      L9_3 = "role"
      L10_3 = L5_3
      L11_3 = {}
      L12_3 = {}
      L13_3 = L3_2
      L12_3[1] = L13_3
      L11_3.targets = L12_3
      L12_3 = L4_2
      L11_3.role = L12_3
      L6_3(L7_3, L8_3, L9_3, L10_3, L11_3)
      L6_3 = L35_1
      L7_3 = L0_3
      L8_3 = {}
      L8_3.action = "role"
      L8_3.by = L1_3
      L9_3 = {}
      L10_3 = L3_2
      L9_3[1] = L10_3
      L8_3.targets = L9_3
      L9_3 = L4_2
      L8_3.role = L9_3
      L6_3(L7_3, L8_3)
      L6_3 = L3_2
      if L6_3 == L1_3 then
        L6_3 = L4_2
        L2_3.role = L6_3
      end
    end
    L5_3 = L43_1
    L6_3 = A0_2
    L7_3 = L0_3
    L8_3 = L1_3
    L9_3 = L2_3.role
    return L5_3(L6_3, L7_3, L8_3, L9_3)
  end
  return L5_2(L6_2, L7_2)
end
L50_1["groups.role"] = L51_1
L50_1 = RPC
function L51_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2
  L2_2 = L9_1
  L3_2 = A1_2.id
  L2_2 = L2_2(L3_2)
  if not L2_2 then
    L3_2 = L7_1
    L4_2 = "invalid"
    return L3_2(L4_2)
  end
  L3_2 = L25_1
  L4_2 = L2_2
  function L5_2()
    local L0_3, L1_3, L2_3, L3_3, L4_3, L5_3, L6_3
    L0_3 = L23_1
    L1_3 = A0_2
    L2_3 = L2_2
    L3_3 = false
    L0_3, L1_3, L2_3, L3_3 = L0_3(L1_3, L2_3, L3_3)
    if not L0_3 then
      L4_3 = L7_1
      L5_3 = L3_3
      return L4_3(L5_3)
    end
    L4_3 = L46_1
    L5_3 = L0_3
    L6_3 = L1_3
    return L4_3(L5_3, L6_3)
  end
  return L3_2(L4_2, L5_2)
end
L50_1["groups.leave"] = L51_1
L50_1 = FW
L50_1 = L50_1.OnPlayerLoaded
function L51_1()
  local L0_2, L1_2
  L0_2 = nil
  L17_1 = L0_2
end
L50_1(L51_1)
L50_1 = AddEventHandler
L51_1 = "playerDropped"
function L52_1()
  local L0_2, L1_2
  L0_2 = tonumber
  L1_2 = source
  L0_2 = L0_2(L1_2)
  if L0_2 then
    L1_2 = L48_1
    L1_2[L0_2] = nil
  end
  L1_2 = nil
  L17_1 = L1_2
end
L50_1(L51_1, L52_1)
