local L0_1, L1_1, L2_1, L3_1, L4_1, L5_1, L6_1, L7_1, L8_1, L9_1, L10_1, L11_1, L12_1, L13_1, L14_1, L15_1, L16_1, L17_1, L18_1, L19_1, L20_1, L21_1, L22_1, L23_1, L24_1, L25_1, L26_1, L27_1, L28_1, L29_1, L30_1, L31_1, L32_1, L33_1, L34_1, L35_1, L36_1, L37_1, L38_1, L39_1, L40_1, L41_1, L42_1, L43_1, L44_1, L45_1, L46_1, L47_1, L48_1, L49_1, L50_1, L51_1, L52_1, L53_1, L54_1, L55_1, L56_1, L57_1, L58_1, L59_1, L60_1, L61_1, L62_1, L63_1, L64_1, L65_1, L66_1, L67_1, L68_1, L69_1, L70_1, L71_1, L72_1, L73_1, L74_1, L75_1, L76_1, L77_1, L78_1, L79_1, L80_1, L81_1, L82_1, L83_1, L84_1, L85_1, L86_1, L87_1, L88_1, L89_1, L90_1, L91_1, L92_1, L93_1, L94_1, L95_1, L96_1, L97_1, L98_1, L99_1, L100_1, L101_1, L102_1, L103_1, L104_1, L105_1, L106_1, L107_1, L108_1, L109_1, L110_1, L111_1
L0_1 = "recado"
L1_1 = 25
L2_1 = 139
L3_1 = 300
L4_1 = 40
L5_1 = {}
L6_1 = "lastSeen"
L7_1 = "online"
L8_1 = "photo"
L9_1 = "about"
L10_1 = "status"
L5_1[1] = L6_1
L5_1[2] = L7_1
L5_1[3] = L8_1
L5_1[4] = L9_1
L5_1[5] = L10_1
L6_1 = {}
L6_1.lastSeen = true
L6_1.online = true
L6_1.photo = true
L6_1.about = true
L6_1.status = true
L7_1 = {}
L7_1.all = true
L7_1.contacts = true
L7_1.nobody = true
L8_1 = {}
L8_1.lastSeen = "all"
L8_1.online = "all"
L8_1.photo = "all"
L8_1.about = "all"
L8_1.status = "contacts"
L9_1 = {}
L9_1.oceano = true
L9_1["por-do-sol"] = true
L9_1.floresta = true
L9_1.rosa = true
L9_1.grafite = true
L9_1.lavanda = true
L9_1.noite = true
L10_1 = {}
L10_1.indigo = true
L10_1.default = true
L10_1.padrao = true
L11_1 = "ABCDEFGHJKLMNPQRSTUVWXYZ23456789"
L12_1 = 8
L13_1 = 3000
L14_1 = 5000
L15_1 = 8
L16_1 = 120000
L17_1 = 8
L18_1 = false
function L19_1()
  local L0_2, L1_2
  L0_2 = type
  L1_2 = Config
  L1_2 = L1_2.Recado
  L0_2 = L0_2(L1_2)
  if "table" == L0_2 then
    L0_2 = Config
    L0_2 = L0_2.Recado
    if L0_2 then
      goto lbl_13
    end
  end
  L0_2 = {}
  ::lbl_13::
  return L0_2
end
function L20_1()
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
function L21_1()
  local L0_2, L1_2, L2_2, L3_2
  L0_2 = math
  L0_2 = L0_2.tointeger
  L1_2 = tonumber
  L2_2 = L20_1
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
function L22_1()
  local L0_2, L1_2, L2_2
  L0_2 = math
  L0_2 = L0_2.tointeger
  L1_2 = tonumber
  L2_2 = L20_1
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
function L23_1(A0_2)
  local L1_2, L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2
  L1_2 = math
  L1_2 = L1_2.tointeger
  L2_2 = tonumber
  L3_2 = A0_2
  L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2 = L2_2(L3_2)
  L1_2 = L1_2(L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2)
  if 0 == L1_2 then
    L2_2 = 0
    return L2_2
  end
  if not L1_2 then
    L2_2 = nil
    return L2_2
  end
  L2_2 = type
  L3_2 = L19_1
  L3_2 = L3_2()
  L3_2 = L3_2.disappearing
  L2_2 = L2_2(L3_2)
  if "table" == L2_2 then
    L2_2 = L19_1
    L2_2 = L2_2()
    L2_2 = L2_2.disappearing
    if L2_2 then
      goto lbl_33
    end
  end
  L2_2 = {}
  L3_2 = 86400
  L4_2 = 604800
  L5_2 = 7776000
  L2_2[1] = L3_2
  L2_2[2] = L4_2
  L2_2[3] = L5_2
  ::lbl_33::
  L3_2 = ipairs
  L4_2 = L2_2
  L3_2, L4_2, L5_2, L6_2 = L3_2(L4_2)
  for L7_2, L8_2 in L3_2, L4_2, L5_2, L6_2 do
    L9_2 = math
    L9_2 = L9_2.tointeger
    L10_2 = tonumber
    L11_2 = L8_2
    L10_2, L11_2 = L10_2(L11_2)
    L9_2 = L9_2(L10_2, L11_2)
    if L9_2 == L1_2 then
      return L1_2
    end
  end
  L3_2 = nil
  return L3_2
end
function L24_1(A0_2, A1_2)
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
function L25_1(A0_2)
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
function L26_1(A0_2)
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
  L1_2 = L25_1
  L2_2 = A0_2
  return L1_2(L2_2)
end
function L27_1(A0_2)
  local L1_2, L2_2, L3_2, L4_2
  L1_2 = string
  L1_2 = L1_2.rep
  L2_2 = "?"
  L3_2 = A0_2
  L4_2 = ", "
  return L1_2(L2_2, L3_2, L4_2)
end
function L28_1()
  local L0_2, L1_2
  L0_2 = type
  L1_2 = Now
  L0_2 = L0_2(L1_2)
  if "function" == L0_2 then
    L0_2 = Now
    L0_2 = L0_2()
    if L0_2 then
      goto lbl_15
    end
  end
  L0_2 = os
  L0_2 = L0_2.time
  L0_2 = L0_2()
  L0_2 = L0_2 * 1000
  ::lbl_15::
  return L0_2
end
function L29_1(A0_2, A1_2)
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
L30_1 = {}
L31_1 = "\226\128[\139-\143]"
L32_1 = "\226\128[\168-\174]"
L33_1 = "\226\129[\160-\175]"
L34_1 = "\239\187\191"
L35_1 = "\194\173"
L36_1 = "\227\133\164"
L37_1 = "\226\160\128"
L30_1[1] = L31_1
L30_1[2] = L32_1
L30_1[3] = L33_1
L30_1[4] = L34_1
L30_1[5] = L35_1
L30_1[6] = L36_1
L30_1[7] = L37_1
function L31_1(A0_2, A1_2, A2_2)
  local L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2
  L3_2 = type
  L4_2 = A0_2
  L3_2 = L3_2(L4_2)
  if "string" ~= L3_2 then
    L3_2 = type
    L4_2 = A0_2
    L3_2 = L3_2(L4_2)
    if "number" ~= L3_2 then
      L3_2 = nil
      return L3_2
    end
  end
  L3_2 = L29_1
  L4_2 = A0_2
  L5_2 = A1_2 * 4
  L5_2 = L5_2 + 64
  L3_2 = L3_2(L4_2, L5_2)
  if A2_2 then
    L5_2 = L3_2
    L4_2 = L3_2.gsub
    L6_2 = "\r\n?"
    L7_2 = "\n"
    L4_2 = L4_2(L5_2, L6_2, L7_2)
    L3_2 = L4_2
    L5_2 = L3_2
    L4_2 = L3_2.gsub
    L6_2 = "[\000-\b\v-\031\127]"
    L7_2 = " "
    L4_2 = L4_2(L5_2, L6_2, L7_2)
    L3_2 = L4_2
    L5_2 = L3_2
    L4_2 = L3_2.gsub
    L6_2 = [[



+]]
    L7_2 = [[


]]
    L4_2 = L4_2(L5_2, L6_2, L7_2)
    L3_2 = L4_2
  else
    L5_2 = L3_2
    L4_2 = L3_2.gsub
    L6_2 = "%c"
    L7_2 = " "
    L4_2 = L4_2(L5_2, L6_2, L7_2)
    L3_2 = L4_2
  end
  L4_2 = ipairs
  L5_2 = L30_1
  L4_2, L5_2, L6_2, L7_2 = L4_2(L5_2)
  for L8_2, L9_2 in L4_2, L5_2, L6_2, L7_2 do
    L11_2 = L3_2
    L10_2 = L3_2.gsub
    L12_2 = L9_2
    L13_2 = ""
    L10_2 = L10_2(L11_2, L12_2, L13_2)
    L3_2 = L10_2
  end
  L5_2 = L3_2
  L4_2 = L3_2.gsub
  L6_2 = "\194\160"
  L7_2 = " "
  L4_2 = L4_2(L5_2, L6_2, L7_2)
  L3_2 = L4_2
  L5_2 = L3_2
  L4_2 = L3_2.gsub
  L6_2 = "\227\128\128"
  L7_2 = " "
  L4_2 = L4_2(L5_2, L6_2, L7_2)
  L3_2 = L4_2
  if A2_2 then
    L5_2 = L3_2
    L4_2 = L3_2.gsub
    L6_2 = "[ \t]+"
    L7_2 = " "
    L4_2 = L4_2(L5_2, L6_2, L7_2)
    L3_2 = L4_2
  else
    L5_2 = L3_2
    L4_2 = L3_2.gsub
    L6_2 = "%s+"
    L7_2 = " "
    L4_2 = L4_2(L5_2, L6_2, L7_2)
    L3_2 = L4_2
  end
  L5_2 = L3_2
  L4_2 = L3_2.match
  L6_2 = "^%s*(.-)%s*$"
  L4_2 = L4_2(L5_2, L6_2)
  L3_2 = L4_2 or L3_2
  if not L4_2 then
    L3_2 = ""
  end
  L4_2 = utf8
  L4_2 = L4_2.len
  L5_2 = L3_2
  L4_2 = L4_2(L5_2)
  if not L4_2 then
    L5_2 = nil
    return L5_2
  end
  if A1_2 < L4_2 then
    L6_2 = L3_2
    L5_2 = L3_2.sub
    L7_2 = 1
    L8_2 = utf8
    L8_2 = L8_2.offset
    L9_2 = L3_2
    L10_2 = A1_2 + 1
    L8_2 = L8_2(L9_2, L10_2)
    L8_2 = L8_2 - 1
    L5_2 = L5_2(L6_2, L7_2, L8_2)
    L6_2 = L5_2
    L5_2 = L5_2.match
    L7_2 = "^(.-)%s*$"
    L5_2 = L5_2(L6_2, L7_2)
    L3_2 = L5_2 or L3_2
    if not L5_2 then
      L3_2 = ""
    end
  end
  return L3_2
end
function L32_1(A0_2)
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
function L33_1(A0_2)
  local L1_2, L2_2
  L1_2 = type
  L2_2 = A0_2
  L1_2 = L1_2(L2_2)
  if "string" == L1_2 then
    L1_2 = L7_1
    L1_2 = L1_2[A0_2]
    if L1_2 and A0_2 then
      goto lbl_13
      L1_2 = A0_2 or L1_2
    end
  end
  L1_2 = nil
  ::lbl_13::
  return L1_2
end
function L34_1(A0_2)
  local L1_2
  L1_2 = A0_2 or L1_2
  if "all" ~= A0_2 and "admins" ~= A0_2 or not A0_2 then
    L1_2 = nil
  end
  return L1_2
end
function L35_1(A0_2)
  local L1_2
  if true == A0_2 or 1 == A0_2 then
    L1_2 = true
    return L1_2
  elseif false == A0_2 or 0 == A0_2 then
    L1_2 = false
    return L1_2
  end
  L1_2 = nil
  return L1_2
end
function L36_1(A0_2)
  local L1_2, L2_2, L3_2
  L1_2 = GetPlayerNumber
  L2_2 = A0_2
  L1_2 = L1_2(L2_2)
  if nil == L1_2 or "" == L1_2 then
    L2_2 = nil
    return L2_2
  end
  L2_2 = tostring
  L3_2 = L1_2
  return L2_2(L3_2)
end
function L37_1()
  local L0_2, L1_2, L2_2
  L0_2 = L18_1
  if L0_2 then
    L0_2 = true
    return L0_2
  end
  L0_2 = GetGameTimer
  L0_2 = L0_2()
  while true do
    L1_2 = L18_1
    if L1_2 then
      break
    end
    L1_2 = GetGameTimer
    L1_2 = L1_2()
    L1_2 = L1_2 - L0_2
    L2_2 = 6000
    if not (L1_2 < L2_2) then
      break
    end
    L1_2 = Wait
    L2_2 = 100
    L1_2(L2_2)
  end
  L1_2 = L18_1
  return L1_2
end
function L38_1(A0_2, A1_2)
  local L2_2, L3_2
  L2_2 = RPC
  function L3_2(A0_3, A1_3)
    local L2_3, L3_3, L4_3, L5_3
    L2_3 = L19_1
    L2_3 = L2_3()
    L2_3 = L2_3.enabled
    if false == L2_3 then
      L2_3 = L24_1
      L3_3 = "disabled"
      return L2_3(L3_3)
    end
    L2_3 = L37_1
    L2_3 = L2_3()
    if not L2_3 then
      L2_3 = L24_1
      L3_3 = "db"
      return L2_3(L3_3)
    end
    L2_3 = A1_2
    L3_3 = tonumber
    L4_3 = A0_3
    L3_3 = L3_3(L4_3)
    L4_3 = type
    L5_3 = A1_3
    L4_3 = L4_3(L5_3)
    L4_3 = A1_3 or L4_3
    if "table" ~= L4_3 or not A1_3 then
      L4_3 = {}
    end
    return L2_3(L3_3, L4_3)
  end
  L2_2[A0_2] = L3_2
end
L39_1 = {}
function L40_1(A0_2, A1_2, ...)
  local L2_2, L3_2, L4_2, L5_2, L6_2, L7_2
  L2_2 = 0
  while true do
    L3_2 = L39_1
    L3_2 = L3_2[A0_2]
    if not L3_2 then
      break
    end
    L3_2 = L14_1
    if L2_2 >= L3_2 then
      L3_2 = L24_1
      L4_2 = "busy"
      return L3_2(L4_2)
    end
    L3_2 = Wait
    L4_2 = 50
    L3_2(L4_2)
    L2_2 = L2_2 + 50
  end
  L3_2 = L39_1
  L3_2[A0_2] = true
  L3_2 = table
  L3_2 = L3_2.pack
  L4_2 = pcall
  L5_2 = A1_2
  L6_2, L7_2 = ...
  L4_2, L5_2, L6_2, L7_2 = L4_2(L5_2, L6_2, L7_2)
  L3_2 = L3_2(L4_2, L5_2, L6_2, L7_2)
  L4_2 = L39_1
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
function L41_1(A0_2, A1_2, ...)
  local L2_2, L3_2, L4_2, L5_2
  L2_2 = type
  L3_2 = GroupWithLock
  L2_2 = L2_2(L3_2)
  if "function" == L2_2 then
    L2_2 = GroupWithLock
    L3_2 = A0_2
    L4_2 = A1_2
    L5_2 = ...
    return L2_2(L3_2, L4_2, L5_2)
  end
  L2_2 = L40_1
  L3_2 = "g:"
  L4_2 = A0_2
  L3_2 = L3_2 .. L4_2
  L4_2 = A1_2
  L5_2 = ...
  return L2_2(L3_2, L4_2, L5_2)
end
L42_1 = {}
function L43_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2
  L2_2 = A0_2
  L3_2 = "."
  L4_2 = A1_2
  L2_2 = L2_2 .. L3_2 .. L4_2
  L3_2 = L42_1
  L3_2 = L3_2[L2_2]
  L4_2 = os
  L4_2 = L4_2.time
  L4_2 = L4_2()
  if L3_2 then
    L5_2 = L3_2.v
    if not L5_2 then
      L5_2 = L3_2.t
      L5_2 = L4_2 - L5_2
      if not (L5_2 < 30) then
        goto lbl_22
      end
    end
    L5_2 = L3_2.v
    return L5_2
  end
  ::lbl_22::
  L5_2 = pcall
  L6_2 = MySQL
  L6_2 = L6_2.scalar
  L6_2 = L6_2.await
  L7_2 = "SELECT COUNT(*) FROM information_schema.COLUMNS WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = ? AND COLUMN_NAME = ?"
  L8_2 = {}
  L9_2 = A0_2
  L10_2 = A1_2
  L8_2[1] = L9_2
  L8_2[2] = L10_2
  L5_2, L6_2 = L5_2(L6_2, L7_2, L8_2)
  if L5_2 then
    L7_2 = tonumber
    L8_2 = L6_2
    L7_2 = L7_2(L8_2)
    if not L7_2 then
      L7_2 = 0
    end
  end
  L7_2 = L7_2 > 0 or L7_2
  L8_2 = L42_1
  L9_2 = {}
  L9_2.v = L7_2
  L9_2.t = L4_2
  L8_2[L2_2] = L9_2
  return L7_2
end
L44_1 = nil
L45_1 = 0
function L46_1()
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
  L1_2 = L44_1
  if L1_2 then
    L1_2 = L45_1
    L1_2 = L0_2 - L1_2
    L2_2 = 2000
    if L1_2 < L2_2 then
      L1_2 = L44_1
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
  L45_1 = L0_2
  L44_1 = L2_2
  return L1_2
end
L47_1 = {}
function L48_1(A0_2)
  local L1_2, L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2, L19_2
  L1_2 = {}
  L2_2 = {}
  L3_2 = L46_1
  L3_2 = L3_2()
  L4_2 = ipairs
  L5_2 = A0_2
  L4_2, L5_2, L6_2, L7_2 = L4_2(L5_2)
  for L8_2, L9_2 in L4_2, L5_2, L6_2, L7_2 do
    L10_2 = L1_2[L9_2]
    if not L10_2 then
      L10_2 = L3_2[L9_2]
      L11_2 = L10_2
      if L10_2 then
        L11_2 = GetCid
        L12_2 = L10_2
        L11_2 = L11_2(L12_2)
      end
      L12_2 = {}
      if L11_2 then
        L13_2 = tostring
        L14_2 = L11_2
        L13_2 = L13_2(L14_2)
        if L13_2 then
          goto lbl_30
        end
      end
      L13_2 = nil
      ::lbl_30::
      L12_2.cid = L13_2
      L13_2 = nil ~= L10_2
      L12_2.online = L13_2
      L1_2[L9_2] = L12_2
      L12_2 = #L2_2
      L12_2 = L12_2 + 1
      L2_2[L12_2] = L9_2
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
    L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2, L19_2 = L12_2(L13_2, L14_2)
    L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2, L19_2 = L9_2(L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2, L19_2)
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
    L9_2 = pcall
    L10_2 = MySQL
    L10_2 = L10_2.query
    L10_2 = L10_2.await
    L11_2 = "SELECT citizenid, phone, last_seen FROM apex_phone_accounts WHERE phone IN (%s)"
    L12_2 = L11_2
    L11_2 = L11_2.format
    L13_2 = L27_1
    L14_2 = #L8_2
    L13_2, L14_2, L15_2, L16_2, L17_2, L18_2, L19_2 = L13_2(L14_2)
    L11_2 = L11_2(L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2, L19_2)
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
          L18_2 = L16_2.phone
          L17_2 = L17_2(L18_2)
          L17_2 = L1_2[L17_2]
          if L17_2 then
            L18_2 = L17_2.cid
            if not L18_2 then
              L18_2 = tostring
              L19_2 = L16_2.citizenid
              L18_2 = L18_2(L19_2)
            end
            L17_2.cid = L18_2
            L18_2 = tonumber
            L19_2 = L16_2.last_seen
            L18_2 = L18_2(L19_2)
            L17_2.lastSeen = L18_2
          end
        end
      end
    end
  end
  L4_2 = os
  L4_2 = L4_2.time
  L4_2 = L4_2()
  L5_2 = pairs
  L6_2 = L1_2
  L5_2, L6_2, L7_2, L8_2 = L5_2(L6_2)
  for L9_2, L10_2 in L5_2, L6_2, L7_2, L8_2 do
    L11_2 = L47_1
    L12_2 = {}
    L13_2 = L10_2.cid
    if not L13_2 then
      L13_2 = false
    end
    L12_2.cid = L13_2
    L12_2.t = L4_2
    L11_2[L9_2] = L12_2
  end
  return L1_2
end
function L49_1(A0_2)
  local L1_2, L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2
  if not A0_2 then
    L1_2 = nil
    return L1_2
  end
  L1_2 = L46_1
  L1_2 = L1_2()
  L1_2 = L1_2[A0_2]
  if L1_2 then
    L2_2 = GetCid
    L3_2 = L1_2
    L2_2 = L2_2(L3_2)
    if L2_2 then
      L3_2 = tostring
      L4_2 = L2_2
      return L3_2(L4_2)
    end
  end
  L2_2 = L47_1
  L2_2 = L2_2[A0_2]
  L3_2 = os
  L3_2 = L3_2.time
  L3_2 = L3_2()
  if L2_2 then
    L4_2 = L2_2.t
    L4_2 = L3_2 - L4_2
    L5_2 = L2_2.cid
    if L5_2 then
      L5_2 = 300
      if L5_2 then
        goto lbl_36
      end
    end
    L5_2 = 30
    ::lbl_36::
    if L4_2 < L5_2 then
      L4_2 = L2_2.cid
      if not L4_2 then
        L4_2 = nil
      end
      return L4_2
    end
  end
  L4_2 = GetCitizenIdByNumber
  L5_2 = A0_2
  L4_2 = L4_2(L5_2)
  L5_2 = L47_1
  L6_2 = {}
  if L4_2 then
    L7_2 = tostring
    L8_2 = L4_2
    L7_2 = L7_2(L8_2)
    if L7_2 then
      goto lbl_57
    end
  end
  L7_2 = false
  ::lbl_57::
  L6_2.cid = L7_2
  L6_2.t = L3_2
  L5_2[A0_2] = L6_2
  if L4_2 then
    L5_2 = tostring
    L6_2 = L4_2
    L5_2 = L5_2(L6_2)
    if L5_2 then
      goto lbl_68
    end
  end
  L5_2 = nil
  ::lbl_68::
  return L5_2
end
function L50_1(A0_2)
  local L1_2, L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2
  L1_2 = {}
  L2_2 = L48_1
  L3_2 = A0_2
  L2_2 = L2_2(L3_2)
  L3_2 = 0
  L4_2 = ipairs
  L5_2 = A0_2
  L4_2, L5_2, L6_2, L7_2 = L4_2(L5_2)
  for L8_2, L9_2 in L4_2, L5_2, L6_2, L7_2 do
    L10_2 = L2_2[L9_2]
    if L10_2 then
      L10_2 = L2_2[L9_2]
      L10_2 = L10_2.cid
      if L10_2 then
        L10_2 = L2_2[L9_2]
        L10_2 = L10_2.cid
        L1_2[L9_2] = L10_2
    end
    else
      L10_2 = L17_1
      if L3_2 < L10_2 then
        L10_2 = FW
        L10_2 = L10_2.FindCidByPhone
        if L10_2 then
          L3_2 = L3_2 + 1
          L10_2 = FW
          L10_2 = L10_2.FindCidByPhone
          L11_2 = L9_2
          L10_2 = L10_2(L11_2)
          if L10_2 then
            L11_2 = tostring
            L12_2 = L10_2
            L11_2 = L11_2(L12_2)
            L1_2[L9_2] = L11_2
          end
        end
      end
    end
  end
  return L1_2
end
L51_1 = {}
function L52_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2
  if not A0_2 or not A1_2 then
    L2_2 = false
    return L2_2
  end
  L2_2 = A0_2
  L3_2 = "|"
  L4_2 = A1_2
  L2_2 = L2_2 .. L3_2 .. L4_2
  L3_2 = L51_1
  L3_2 = L3_2[L2_2]
  if L3_2 then
    L4_2 = os
    L4_2 = L4_2.time
    L4_2 = L4_2()
    L5_2 = L3_2.t
    L4_2 = L4_2 - L5_2
    if L4_2 < 30 then
      L4_2 = L3_2.v
      return L4_2
    end
  end
  L4_2 = pcall
  L5_2 = MySQL
  L5_2 = L5_2.scalar
  L5_2 = L5_2.await
  L6_2 = "SELECT 1 FROM apex_phone_contacts WHERE owner = ? AND number = ? LIMIT 1"
  L7_2 = {}
  L8_2 = A0_2
  L9_2 = A1_2
  L7_2[1] = L8_2
  L7_2[2] = L9_2
  L4_2, L5_2 = L4_2(L5_2, L6_2, L7_2)
  L6_2 = L4_2 or L6_2
  L6_2 = L4_2 and nil ~= L5_2
  if L4_2 then
    L7_2 = L51_1
    L8_2 = {}
    L8_2.v = L6_2
    L9_2 = os
    L9_2 = L9_2.time
    L9_2 = L9_2()
    L8_2.t = L9_2
    L7_2[L2_2] = L8_2
  end
  return L6_2
end
function L53_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2
  L2_2 = {}
  if A0_2 then
    L3_2 = #A1_2
    if 0 ~= L3_2 then
      goto lbl_9
    end
  end
  do return L2_2 end
  ::lbl_9::
  L3_2 = 1
  L4_2 = #A1_2
  L5_2 = 100
  for L6_2 = L3_2, L4_2, L5_2 do
    L7_2 = {}
    L8_2 = table
    L8_2 = L8_2.unpack
    L9_2 = A1_2
    L10_2 = L6_2
    L11_2 = math
    L11_2 = L11_2.min
    L12_2 = #A1_2
    L13_2 = L6_2 + 99
    L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2 = L11_2(L12_2, L13_2)
    L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2 = L8_2(L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2)
    L7_2[1] = L8_2
    L7_2[2] = L9_2
    L7_2[3] = L10_2
    L7_2[4] = L11_2
    L7_2[5] = L12_2
    L7_2[6] = L13_2
    L7_2[7] = L14_2
    L7_2[8] = L15_2
    L7_2[9] = L16_2
    L7_2[10] = L17_2
    L7_2[11] = L18_2
    L8_2 = {}
    L9_2 = A0_2
    L8_2[1] = L9_2
    L9_2 = ipairs
    L10_2 = L7_2
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
    L11_2 = "SELECT number, name FROM apex_phone_contacts WHERE owner = ? AND number IN (%s)"
    L12_2 = L11_2
    L11_2 = L11_2.format
    L13_2 = L27_1
    L14_2 = #L7_2
    L13_2, L14_2, L15_2, L16_2, L17_2, L18_2 = L13_2(L14_2)
    L11_2 = L11_2(L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2)
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
          L18_2 = L16_2.number
          L17_2 = L17_2(L18_2)
          L18_2 = L16_2.name
          L2_2[L17_2] = L18_2
        end
      end
    end
  end
  return L2_2
end
function L54_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2
  if not A0_2 or not A1_2 then
    L2_2 = false
    return L2_2
  end
  L2_2 = type
  L3_2 = IsBlocked
  L2_2 = L2_2(L3_2)
  if "function" ~= L2_2 then
    L2_2 = false
    return L2_2
  end
  L2_2 = pcall
  L3_2 = IsBlocked
  L4_2 = A0_2
  L5_2 = A1_2
  L2_2, L3_2 = L2_2(L3_2, L4_2, L5_2)
  L4_2 = L2_2 or L4_2
  L4_2 = L2_2 and true == L3_2
  return L4_2
end
L55_1 = {}
function L56_1(A0_2)
  local L1_2, L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2
  L1_2 = {}
  L2_2 = ipairs
  L3_2 = L5_1
  L2_2, L3_2, L4_2, L5_2 = L2_2(L3_2)
  for L6_2, L7_2 in L2_2, L3_2, L4_2, L5_2 do
    if A0_2 then
      L9_2 = A0_2[L7_2]
      L8_2 = L7_1
      L8_2 = L8_2[L9_2]
      if L8_2 then
        L8_2 = A0_2[L7_2]
        if L8_2 then
          goto lbl_19
        end
      end
    end
    L8_2 = L8_1
    L8_2 = L8_2[L7_2]
    ::lbl_19::
    L1_2[L7_2] = L8_2
  end
  return L1_2
end
function L57_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2
  L2_2 = {}
  L2_2.number = A0_2
  L2_2.owner = A1_2
  L2_2.exists = false
  L2_2.name = ""
  L2_2.about = ""
  L2_2.avatarMedia = nil
  L3_2 = L56_1
  L4_2 = nil
  L3_2 = L3_2(L4_2)
  L2_2.privacy = L3_2
  L2_2.readReceipts = true
  L2_2.groupsAdd = "all"
  L2_2.silenceUnknown = false
  L2_2.defaultDisappearing = 0
  L2_2.updated = 0
  return L2_2
end
function L58_1(A0_2, A1_2, A2_2)
  local L3_2, L4_2, L5_2, L6_2, L7_2, L8_2
  L3_2 = L57_1
  L4_2 = A0_2
  L5_2 = A1_2
  L3_2 = L3_2(L4_2, L5_2)
  L3_2.exists = true
  L4_2 = tostring
  L5_2 = A2_2.name
  if not L5_2 then
    L5_2 = ""
  end
  L4_2 = L4_2(L5_2)
  L3_2.name = L4_2
  L4_2 = tostring
  L5_2 = A2_2.about
  if not L5_2 then
    L5_2 = ""
  end
  L4_2 = L4_2(L5_2)
  L3_2.about = L4_2
  L4_2 = L25_1
  L5_2 = A2_2.avatar_media
  L4_2 = L4_2(L5_2)
  L3_2.avatarMedia = L4_2
  L4_2 = nil
  L5_2 = type
  L6_2 = A2_2.privacy
  L5_2 = L5_2(L6_2)
  if "string" == L5_2 then
    L5_2 = A2_2.privacy
    if "" ~= L5_2 then
      L5_2 = pcall
      L6_2 = json
      L6_2 = L6_2.decode
      L7_2 = A2_2.privacy
      L5_2, L6_2 = L5_2(L6_2, L7_2)
      if L5_2 then
        L7_2 = type
        L8_2 = L6_2
        L7_2 = L7_2(L8_2)
        if "table" == L7_2 then
          L4_2 = L6_2
        end
      end
    end
  end
  L5_2 = L56_1
  L6_2 = L4_2
  L5_2 = L5_2(L6_2)
  L3_2.privacy = L5_2
  if L4_2 then
    L5_2 = L23_1
    L6_2 = L4_2.defaultDisappearing
    L5_2 = L5_2(L6_2)
    if L5_2 then
      goto lbl_58
    end
  end
  L5_2 = 0
  ::lbl_58::
  L3_2.defaultDisappearing = L5_2
  L5_2 = tonumber
  L6_2 = A2_2.read_receipts
  L5_2 = L5_2(L6_2)
  if not L5_2 then
    L5_2 = 1
  end
  L5_2 = 0 ~= L5_2
  L3_2.readReceipts = L5_2
  L6_2 = A2_2.groups_add
  L5_2 = L7_1
  L5_2 = L5_2[L6_2]
  if L5_2 then
    L5_2 = A2_2.groups_add
    if L5_2 then
      goto lbl_79
    end
  end
  L5_2 = "all"
  ::lbl_79::
  L3_2.groupsAdd = L5_2
  L5_2 = tonumber
  L6_2 = A2_2.silence_unknown
  L5_2 = L5_2(L6_2)
  if not L5_2 then
    L5_2 = 0
  end
  L5_2 = 0 ~= L5_2
  L3_2.silenceUnknown = L5_2
  L5_2 = tonumber
  L6_2 = A2_2.updated
  L5_2 = L5_2(L6_2)
  if not L5_2 then
    L5_2 = 0
  end
  L3_2.updated = L5_2
  return L3_2
end
L59_1 = "number, owner, name, about, avatar_media, privacy, read_receipts, groups_add, silence_unknown, updated"
function L60_1(A0_2)
  local L1_2, L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2, L19_2, L20_2, L21_2
  L1_2 = {}
  L2_2 = {}
  L3_2 = os
  L3_2 = L3_2.time
  L3_2 = L3_2()
  L4_2 = ipairs
  L5_2 = A0_2
  L4_2, L5_2, L6_2, L7_2 = L4_2(L5_2)
  for L8_2, L9_2 in L4_2, L5_2, L6_2, L7_2 do
    L10_2 = L1_2[L9_2]
    if not L10_2 then
      L10_2 = L55_1
      L10_2 = L10_2[L9_2]
      if L10_2 then
        L11_2 = L10_2.t
        L11_2 = L3_2 - L11_2
        if L11_2 < 60 then
          L11_2 = L10_2.p
          L1_2[L9_2] = L11_2
      end
      else
        L11_2 = #L2_2
        L11_2 = L11_2 + 1
        L2_2[L11_2] = L9_2
        L1_2[L9_2] = false
      end
    end
  end
  L4_2 = #L2_2
  if 0 == L4_2 then
    return L1_2
  end
  L4_2 = L48_1
  L5_2 = L2_2
  L4_2 = L4_2(L5_2)
  L5_2 = {}
  L6_2 = 1
  L7_2 = #L2_2
  L8_2 = 100
  for L9_2 = L6_2, L7_2, L8_2 do
    L10_2 = {}
    L11_2 = table
    L11_2 = L11_2.unpack
    L12_2 = L2_2
    L13_2 = L9_2
    L14_2 = math
    L14_2 = L14_2.min
    L15_2 = #L2_2
    L16_2 = L9_2 + 99
    L14_2, L15_2, L16_2, L17_2, L18_2, L19_2, L20_2, L21_2 = L14_2(L15_2, L16_2)
    L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2, L19_2, L20_2, L21_2 = L11_2(L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2, L19_2, L20_2, L21_2)
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
    L11_2 = pcall
    L12_2 = MySQL
    L12_2 = L12_2.query
    L12_2 = L12_2.await
    L13_2 = "SELECT %s FROM apex_phone_recado_profiles WHERE number IN (%s)"
    L14_2 = L13_2
    L13_2 = L13_2.format
    L15_2 = L59_1
    L16_2 = L27_1
    L17_2 = #L10_2
    L16_2, L17_2, L18_2, L19_2, L20_2, L21_2 = L16_2(L17_2)
    L13_2 = L13_2(L14_2, L15_2, L16_2, L17_2, L18_2, L19_2, L20_2, L21_2)
    L14_2 = L10_2
    L11_2, L12_2 = L11_2(L12_2, L13_2, L14_2)
    if not L11_2 then
      L13_2 = ipairs
      L14_2 = L2_2
      L13_2, L14_2, L15_2, L16_2 = L13_2(L14_2)
      for L17_2, L18_2 in L13_2, L14_2, L15_2, L16_2 do
        L19_2 = L57_1
        L20_2 = L18_2
        L21_2 = L4_2[L18_2]
        if L21_2 then
          L21_2 = L4_2[L18_2]
          L21_2 = L21_2.cid
        end
        L19_2 = L19_2(L20_2, L21_2)
        L1_2[L18_2] = L19_2
      end
      return L1_2
    end
    L13_2 = ipairs
    L14_2 = L12_2 or L14_2
    if not L12_2 then
      L14_2 = {}
    end
    L13_2, L14_2, L15_2, L16_2 = L13_2(L14_2)
    for L17_2, L18_2 in L13_2, L14_2, L15_2, L16_2 do
      L19_2 = tostring
      L20_2 = L18_2.number
      L19_2 = L19_2(L20_2)
      L5_2[L19_2] = L18_2
    end
  end
  L6_2 = ipairs
  L7_2 = L2_2
  L6_2, L7_2, L8_2, L9_2 = L6_2(L7_2)
  for L10_2, L11_2 in L6_2, L7_2, L8_2, L9_2 do
    L12_2 = L4_2[L11_2]
    if L12_2 then
      L12_2 = L4_2[L11_2]
      L12_2 = L12_2.cid
      if L12_2 then
        goto lbl_121
      end
    end
    L12_2 = nil
    ::lbl_121::
    L13_2 = L5_2[L11_2]
    if L13_2 and L12_2 then
      L14_2 = tostring
      L15_2 = L13_2.owner
      if not L15_2 then
        L15_2 = ""
      end
      L14_2 = L14_2(L15_2)
      if L14_2 == L12_2 then
        L14_2 = L58_1
        L15_2 = L11_2
        L16_2 = L12_2
        L17_2 = L13_2
        L14_2 = L14_2(L15_2, L16_2, L17_2)
        if L14_2 then
          goto lbl_145
        end
      end
    end
    L14_2 = L57_1
    L15_2 = L11_2
    L16_2 = L12_2
    L14_2 = L14_2(L15_2, L16_2)
    ::lbl_145::
    L15_2 = L55_1
    L16_2 = {}
    L16_2.p = L14_2
    L16_2.t = L3_2
    L15_2[L11_2] = L16_2
    L1_2[L11_2] = L14_2
  end
  return L1_2
end
function L61_1(A0_2)
  local L1_2, L2_2, L3_2
  L1_2 = L60_1
  L2_2 = {}
  L3_2 = A0_2
  L2_2[1] = L3_2
  L1_2 = L1_2(L2_2)
  L1_2 = L1_2[A0_2]
  return L1_2
end
function L62_1(A0_2)
  local L1_2, L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2
  L1_2 = {}
  L2_2 = pairs
  L3_2 = A0_2
  L2_2, L3_2, L4_2, L5_2 = L2_2(L3_2)
  for L6_2, L7_2 in L2_2, L3_2, L4_2, L5_2 do
    L1_2[L6_2] = L7_2
  end
  L2_2 = L56_1
  L3_2 = A0_2.privacy
  L2_2 = L2_2(L3_2)
  L1_2.privacy = L2_2
  return L1_2
end
function L63_1(A0_2, A1_2, A2_2)
  local L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2
  L3_2 = L56_1
  L4_2 = A2_2.privacy
  L3_2 = L3_2(L4_2)
  L4_2 = L23_1
  L5_2 = A2_2.defaultDisappearing
  L4_2 = L4_2(L5_2)
  if not L4_2 then
    L4_2 = 0
  end
  L3_2.defaultDisappearing = L4_2
  L4_2 = pcall
  L5_2 = json
  L5_2 = L5_2.encode
  L6_2 = L3_2
  L4_2, L5_2 = L4_2(L5_2, L6_2)
  if not L4_2 then
    L6_2 = false
    return L6_2
  end
  L6_2 = {}
  L7_2 = A0_2
  L8_2 = A1_2
  L9_2 = A2_2.name
  if not L9_2 then
    L9_2 = ""
  end
  L10_2 = A2_2.about
  if not L10_2 then
    L10_2 = ""
  end
  L6_2[1] = L7_2
  L6_2[2] = L8_2
  L6_2[3] = L9_2
  L6_2[4] = L10_2
  L7_2 = A2_2.avatarMedia
  if L7_2 then
    L7_2 = #L6_2
    L7_2 = L7_2 + 1
    L8_2 = A2_2.avatarMedia
    L6_2[L7_2] = L8_2
  end
  L7_2 = #L6_2
  L7_2 = L7_2 + 1
  L6_2[L7_2] = L5_2
  L7_2 = #L6_2
  L7_2 = L7_2 + 1
  L8_2 = A2_2.readReceipts
  if false == L8_2 then
    L8_2 = 0
    if L8_2 then
      goto lbl_55
    end
  end
  L8_2 = 1
  ::lbl_55::
  L6_2[L7_2] = L8_2
  L7_2 = #L6_2
  L7_2 = L7_2 + 1
  L9_2 = A2_2.groupsAdd
  L8_2 = L7_1
  L8_2 = L8_2[L9_2]
  if L8_2 then
    L8_2 = A2_2.groupsAdd
    if L8_2 then
      goto lbl_68
    end
  end
  L8_2 = "all"
  ::lbl_68::
  L6_2[L7_2] = L8_2
  L7_2 = #L6_2
  L7_2 = L7_2 + 1
  L8_2 = A2_2.silenceUnknown
  if L8_2 then
    L8_2 = 1
    if L8_2 then
      goto lbl_79
    end
  end
  L8_2 = 0
  ::lbl_79::
  L6_2[L7_2] = L8_2
  L7_2 = #L6_2
  L7_2 = L7_2 + 1
  L8_2 = L28_1
  L8_2 = L8_2()
  L6_2[L7_2] = L8_2
  L7_2 = pcall
  L8_2 = MySQL
  L8_2 = L8_2.query
  L8_2 = L8_2.await
  L9_2 = [[
INSERT INTO apex_phone_recado_profiles (number, owner, name, about, avatar_media, privacy, read_receipts, groups_add, silence_unknown, updated)
        VALUES (?, ?, ?, ?, %s, ?, ?, ?, ?, ?)
        ON DUPLICATE KEY UPDATE owner = VALUES(owner), name = VALUES(name), about = VALUES(about), avatar_media = VALUES(avatar_media),
          privacy = VALUES(privacy), read_receipts = VALUES(read_receipts), groups_add = VALUES(groups_add),
          silence_unknown = VALUES(silence_unknown), updated = VALUES(updated)]]
  L10_2 = L9_2
  L9_2 = L9_2.format
  L11_2 = A2_2.avatarMedia
  if L11_2 then
    L11_2 = "?"
    if L11_2 then
      goto lbl_99
    end
  end
  L11_2 = "NULL"
  ::lbl_99::
  L9_2 = L9_2(L10_2, L11_2)
  L10_2 = L6_2
  L7_2, L8_2 = L7_2(L8_2, L9_2, L10_2)
  L9_2 = L55_1
  L9_2[A0_2] = nil
  if not L7_2 or nil == L8_2 then
    L9_2 = print
    L10_2 = "^1[unique_phone]^0 recado: profile of %s not saved (%s)"
    L11_2 = L10_2
    L10_2 = L10_2.format
    L12_2 = tostring
    L13_2 = A0_2
    L12_2 = L12_2(L13_2)
    L13_2 = tostring
    L14_2 = L8_2
    L13_2, L14_2 = L13_2(L14_2)
    L10_2, L11_2, L12_2, L13_2, L14_2 = L10_2(L11_2, L12_2, L13_2, L14_2)
    L9_2(L10_2, L11_2, L12_2, L13_2, L14_2)
    L9_2 = false
    return L9_2
  end
  L9_2 = true
  return L9_2
end
function L64_1(A0_2, A1_2, A2_2)
  local L3_2, L4_2, L5_2
  if "all" == A0_2 then
    L3_2 = true
    return L3_2
  end
  if "contacts" == A0_2 then
    L3_2 = L52_1
    L4_2 = A1_2
    L5_2 = A2_2
    return L3_2(L4_2, L5_2)
  end
  L3_2 = false
  return L3_2
end
function L65_1(A0_2)
  local L1_2, L2_2, L3_2
  L1_2 = L32_1
  L2_2 = A0_2
  L1_2 = L1_2(L2_2)
  A0_2 = L1_2
  if not A0_2 then
    L1_2 = nil
    return L1_2
  end
  L1_2 = L62_1
  L2_2 = L61_1
  L3_2 = A0_2
  L2_2, L3_2 = L2_2(L3_2)
  return L1_2(L2_2, L3_2)
end
RecadoProfile = L65_1
function L65_1(A0_2, A1_2, A2_2)
  local L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2
  if nil ~= A0_2 and nil ~= A1_2 then
    L3_2 = L6_1
    L3_2 = L3_2[A2_2]
    if L3_2 then
      goto lbl_11
    end
  end
  L3_2 = false
  do return L3_2 end
  ::lbl_11::
  L3_2 = tostring
  L4_2 = A0_2
  L3_2 = L3_2(L4_2)
  L4_2 = tostring
  L5_2 = A1_2
  L4_2 = L4_2(L5_2)
  if L3_2 == L4_2 then
    L5_2 = true
    return L5_2
  end
  L5_2 = L61_1
  L6_2 = L4_2
  L5_2 = L5_2(L6_2)
  if L5_2 then
    L6_2 = L5_2.owner
    if L6_2 then
      goto lbl_31
    end
  end
  L6_2 = false
  do return L6_2 end
  ::lbl_31::
  L6_2 = L54_1
  L7_2 = L5_2.owner
  L8_2 = L3_2
  L6_2 = L6_2(L7_2, L8_2)
  if L6_2 then
    L6_2 = false
    return L6_2
  end
  L6_2 = L64_1
  L7_2 = L5_2.privacy
  L7_2 = L7_2[A2_2]
  if not L7_2 then
    L7_2 = "all"
  end
  L8_2 = L5_2.owner
  L9_2 = L3_2
  L6_2 = L6_2(L7_2, L8_2, L9_2)
  if not L6_2 then
    L6_2 = false
    return L6_2
  end
  if "lastSeen" == A2_2 or "online" == A2_2 then
    L6_2 = L61_1
    L7_2 = L3_2
    L6_2 = L6_2(L7_2)
    if L6_2 then
      L7_2 = L6_2.privacy
      L7_2 = L7_2[A2_2]
      if "nobody" == L7_2 then
        L7_2 = false
        return L7_2
      end
    end
  end
  L6_2 = true
  return L6_2
end
RecadoCanSee = L65_1
function L65_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2, L6_2, L7_2
  if nil == A0_2 or nil == A1_2 then
    L2_2 = false
    return L2_2
  end
  L2_2 = tostring
  L3_2 = A0_2
  L2_2 = L2_2(L3_2)
  L3_2 = tostring
  L4_2 = A1_2
  L3_2 = L3_2(L4_2)
  if L2_2 == L3_2 then
    L4_2 = true
    return L4_2
  end
  L4_2 = L61_1
  L5_2 = L3_2
  L4_2 = L4_2(L5_2)
  if not L4_2 then
    L5_2 = false
    return L5_2
  end
  L5_2 = L4_2.owner
  if not L5_2 then
    L5_2 = true
    return L5_2
  end
  L5_2 = L54_1
  L6_2 = L4_2.owner
  L7_2 = L2_2
  L5_2 = L5_2(L6_2, L7_2)
  if L5_2 then
    L5_2 = false
    return L5_2
  end
  L5_2 = L4_2.groupsAdd
  if "all" == L5_2 then
    L5_2 = true
    return L5_2
  end
  L5_2 = L4_2.groupsAdd
  if "contacts" == L5_2 then
    L5_2 = L52_1
    L6_2 = L4_2.owner
    L7_2 = L2_2
    return L5_2(L6_2, L7_2)
  end
  L5_2 = false
  return L5_2
end
RecadoCanAddToGroup = L65_1
function L65_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2, L6_2
  if nil == A0_2 or nil == A1_2 then
    L2_2 = false
    return L2_2
  end
  L2_2 = L61_1
  L3_2 = tostring
  L4_2 = A0_2
  L3_2, L4_2, L5_2, L6_2 = L3_2(L4_2)
  L2_2 = L2_2(L3_2, L4_2, L5_2, L6_2)
  if L2_2 then
    L3_2 = L2_2.owner
    if L3_2 then
      L3_2 = L2_2.silenceUnknown
      if L3_2 then
        goto lbl_22
      end
    end
  end
  L3_2 = false
  do return L3_2 end
  ::lbl_22::
  L3_2 = L52_1
  L4_2 = L2_2.owner
  L5_2 = tostring
  L6_2 = A1_2
  L5_2, L6_2 = L5_2(L6_2)
  L3_2 = L3_2(L4_2, L5_2, L6_2)
  L3_2 = not L3_2
  return L3_2
end
RecadoSilenceUnknown = L65_1
function L65_1(A0_2)
  local L1_2, L2_2, L3_2
  if nil == A0_2 then
    L1_2 = true
    return L1_2
  end
  L1_2 = L61_1
  L2_2 = tostring
  L3_2 = A0_2
  L2_2, L3_2 = L2_2(L3_2)
  L1_2 = L1_2(L2_2, L3_2)
  L2_2 = not L1_2
  return L2_2
end
RecadoReadReceipts = L65_1
function L65_1(A0_2)
  local L1_2, L2_2, L3_2
  if nil == A0_2 then
    L1_2 = 0
    return L1_2
  end
  L1_2 = L61_1
  L2_2 = tostring
  L3_2 = A0_2
  L2_2, L3_2 = L2_2(L3_2)
  L1_2 = L1_2(L2_2, L3_2)
  if L1_2 then
    L2_2 = L1_2.defaultDisappearing
    if L2_2 then
      goto lbl_16
    end
  end
  L2_2 = 0
  ::lbl_16::
  return L2_2
end
RecadoDefaultDisappearing = L65_1
function L65_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2
  L2_2 = L25_1
  L3_2 = A1_2
  L2_2 = L2_2(L3_2)
  L3_2 = tonumber
  L4_2 = A0_2
  L3_2 = L3_2(L4_2)
  A0_2 = L3_2
  if L2_2 and A0_2 then
    L3_2 = L18_1
    if L3_2 then
      goto lbl_17
    end
  end
  L3_2 = false
  do return L3_2 end
  ::lbl_17::
  L3_2 = L36_1
  L4_2 = A0_2
  L3_2 = L3_2(L4_2)
  if not L3_2 then
    L4_2 = false
    return L4_2
  end
  L4_2 = pcall
  L5_2 = MySQL
  L5_2 = L5_2.query
  L5_2 = L5_2.await
  L6_2 = "SELECT number FROM apex_phone_recado_profiles WHERE avatar_media = ? LIMIT 3"
  L7_2 = {}
  L8_2 = L2_2
  L7_2[1] = L8_2
  L4_2, L5_2 = L4_2(L5_2, L6_2, L7_2)
  if L4_2 then
    L6_2 = type
    L7_2 = L5_2
    L6_2 = L6_2(L7_2)
    if "table" == L6_2 then
      goto lbl_43
    end
  end
  L6_2 = false
  do return L6_2 end
  ::lbl_43::
  L6_2 = ipairs
  L7_2 = L5_2
  L6_2, L7_2, L8_2, L9_2 = L6_2(L7_2)
  for L10_2, L11_2 in L6_2, L7_2, L8_2, L9_2 do
    L12_2 = L61_1
    L13_2 = tostring
    L14_2 = L11_2.number
    L13_2, L14_2, L15_2, L16_2 = L13_2(L14_2)
    L12_2 = L12_2(L13_2, L14_2, L15_2, L16_2)
    if L12_2 then
      L13_2 = L12_2.exists
      if L13_2 then
        L13_2 = L12_2.avatarMedia
        if L13_2 == L2_2 then
          L13_2 = RecadoCanSee
          L14_2 = L3_2
          L15_2 = L12_2.number
          L16_2 = "photo"
          L13_2 = L13_2(L14_2, L15_2, L16_2)
          if L13_2 then
            L13_2 = true
            return L13_2
          end
        end
      end
    end
  end
  L6_2 = false
  return L6_2
end
RecadoMediaCanRead = L65_1
function L65_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2
  if A0_2 then
    L2_2 = pcall
    L3_2 = MySQL
    L3_2 = L3_2.query
    L3_2 = L3_2.await
    L4_2 = "DELETE FROM apex_phone_recado_profiles WHERE owner = ?"
    L5_2 = {}
    L6_2 = tostring
    L7_2 = A0_2
    L6_2, L7_2, L8_2, L9_2, L10_2, L11_2 = L6_2(L7_2)
    L5_2[1] = L6_2
    L5_2[2] = L7_2
    L5_2[3] = L8_2
    L5_2[4] = L9_2
    L5_2[5] = L10_2
    L5_2[6] = L11_2
    L2_2(L3_2, L4_2, L5_2)
  end
  if A1_2 then
    L2_2 = tostring
    L3_2 = A1_2
    L2_2 = L2_2(L3_2)
    L3_2 = L55_1
    L3_2[L2_2] = nil
    L2_2 = tostring
    L3_2 = A1_2
    L2_2 = L2_2(L3_2)
    L3_2 = L47_1
    L3_2[L2_2] = nil
  end
  if A0_2 then
    L2_2 = tostring
    L3_2 = A0_2
    L2_2 = L2_2(L3_2)
    L3_2 = "|"
    L2_2 = L2_2 .. L3_2
    L3_2 = pairs
    L4_2 = L51_1
    L3_2, L4_2, L5_2, L6_2 = L3_2(L4_2)
    for L7_2 in L3_2, L4_2, L5_2, L6_2 do
      L9_2 = L7_2
      L8_2 = L7_2.sub
      L10_2 = 1
      L11_2 = #L2_2
      L8_2 = L8_2(L9_2, L10_2, L11_2)
      if L8_2 == L2_2 then
        L8_2 = L51_1
        L8_2[L7_2] = nil
      end
    end
    L3_2 = pairs
    L4_2 = L55_1
    L3_2, L4_2, L5_2, L6_2 = L3_2(L4_2)
    for L7_2, L8_2 in L3_2, L4_2, L5_2, L6_2 do
      L9_2 = L8_2.p
      if L9_2 then
        L9_2 = L8_2.p
        L9_2 = L9_2.owner
        L10_2 = tostring
        L11_2 = A0_2
        L10_2 = L10_2(L11_2)
        if L9_2 == L10_2 then
          L9_2 = L55_1
          L9_2[L7_2] = nil
        end
      end
    end
  end
end
RecadoForget = L65_1
function L65_1(A0_2, A1_2, A2_2, A3_2)
  local L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2
  L4_2 = {}
  L4_2.number = A1_2
  if A3_2 then
    L5_2 = A3_2.cid
  end
  L5_2 = nil ~= L5_2 or L5_2
  L4_2.exists = L5_2
  if A2_2 then
    L5_2 = A2_2.owner
    if L5_2 then
      goto lbl_20
    end
  end
  do return L4_2 end
  ::lbl_20::
  L4_2.exists = true
  L5_2 = A2_2.name
  if "" ~= L5_2 then
    L5_2 = A2_2.name
    L4_2.name = L5_2
  end
  L5_2 = A2_2.about
  if "" ~= L5_2 then
    L5_2 = RecadoCanSee
    L6_2 = A0_2
    L7_2 = A1_2
    L8_2 = "about"
    L5_2 = L5_2(L6_2, L7_2, L8_2)
    if L5_2 then
      L5_2 = A2_2.about
      L4_2.about = L5_2
    end
  end
  L5_2 = A2_2.avatarMedia
  if L5_2 then
    L5_2 = RecadoCanSee
    L6_2 = A0_2
    L7_2 = A1_2
    L8_2 = "photo"
    L5_2 = L5_2(L6_2, L7_2, L8_2)
    if L5_2 then
      L5_2 = A2_2.avatarMedia
      L4_2.avatar = L5_2
    end
  end
  if A3_2 then
    L5_2 = A3_2.online
    if L5_2 then
      goto lbl_56
    end
  end
  L5_2 = false
  ::lbl_56::
  L6_2 = RecadoCanSee
  L7_2 = A0_2
  L8_2 = A1_2
  L9_2 = "online"
  L6_2 = L6_2(L7_2, L8_2, L9_2)
  if L6_2 then
    L4_2.online = L5_2
  end
  if A3_2 then
    L7_2 = A3_2.lastSeen
    if L7_2 and (not L5_2 or not L6_2) then
      L7_2 = RecadoCanSee
      L8_2 = A0_2
      L9_2 = A1_2
      L10_2 = "lastSeen"
      L7_2 = L7_2(L8_2, L9_2, L10_2)
      if L7_2 then
        L7_2 = A3_2.lastSeen
        L4_2.lastSeen = L7_2
      end
    end
  end
  L7_2 = RecadoCanSee
  L8_2 = A0_2
  L9_2 = A1_2
  L10_2 = "status"
  L7_2 = L7_2(L8_2, L9_2, L10_2)
  L4_2.status = L7_2
  return L4_2
end
function L66_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2
  L2_2 = L61_1
  L3_2 = A1_2
  L2_2 = L2_2(L3_2)
  L3_2 = {}
  L3_2.ok = true
  L3_2.number = A1_2
  L4_2 = L2_2.exists
  L3_2.exists = L4_2
  L4_2 = L2_2.name
  L3_2.name = L4_2
  L4_2 = L2_2.about
  L3_2.about = L4_2
  L4_2 = L2_2.avatarMedia
  L3_2.avatarMedia = L4_2
  L4_2 = L56_1
  L5_2 = L2_2.privacy
  L4_2 = L4_2(L5_2)
  L3_2.privacy = L4_2
  L4_2 = L2_2.readReceipts
  L3_2.readReceipts = L4_2
  L4_2 = L2_2.groupsAdd
  L3_2.groupsAdd = L4_2
  L4_2 = L2_2.silenceUnknown
  L3_2.silenceUnknown = L4_2
  L4_2 = L2_2.defaultDisappearing
  L3_2.defaultDisappearing = L4_2
  L4_2 = L2_2.updated
  L3_2.updated = L4_2
  L4_2 = L2_2.name
  if "" == L4_2 then
    L4_2 = pcall
    L5_2 = FW
    L5_2 = L5_2.GetPlayer
    L6_2 = A0_2
    L4_2, L5_2 = L4_2(L5_2, L6_2)
    if L4_2 then
      L6_2 = type
      L7_2 = L5_2
      L6_2 = L6_2(L7_2)
      if "table" == L6_2 then
        L6_2 = L5_2.firstname
        if L6_2 then
          L6_2 = L31_1
          L7_2 = "%s %s"
          L8_2 = L7_2
          L7_2 = L7_2.format
          L9_2 = tostring
          L10_2 = L5_2.firstname
          if not L10_2 then
            L10_2 = ""
          end
          L9_2 = L9_2(L10_2)
          L10_2 = tostring
          L11_2 = L5_2.lastname
          if not L11_2 then
            L11_2 = ""
          end
          L10_2, L11_2 = L10_2(L11_2)
          L7_2 = L7_2(L8_2, L9_2, L10_2, L11_2)
          L8_2 = L1_1
          L9_2 = false
          L6_2 = L6_2(L7_2, L8_2, L9_2)
          L3_2.suggestedName = L6_2
        end
      end
    end
  end
  return L3_2
end
function L67_1(A0_2)
  local L1_2, L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2
  L1_2 = {}
  L1_2.ok = true
  L2_2 = ipairs
  L3_2 = L5_1
  L2_2, L3_2, L4_2, L5_2 = L2_2(L3_2)
  for L6_2, L7_2 in L2_2, L3_2, L4_2, L5_2 do
    L8_2 = A0_2.privacy
    L8_2 = L8_2[L7_2]
    L1_2[L7_2] = L8_2
  end
  L2_2 = A0_2.readReceipts
  L1_2.readReceipts = L2_2
  L2_2 = A0_2.groupsAdd
  L1_2.groupsAdd = L2_2
  L2_2 = A0_2.silenceUnknown
  L1_2.silenceUnknown = L2_2
  L2_2 = A0_2.defaultDisappearing
  L1_2.defaultDisappearing = L2_2
  return L1_2
end
L68_1 = L38_1
L69_1 = "recado.profile.me"
function L70_1(A0_2)
  local L1_2, L2_2, L3_2, L4_2
  L1_2 = L36_1
  L2_2 = A0_2
  L1_2 = L1_2(L2_2)
  if not L1_2 then
    L2_2 = L24_1
    L3_2 = "noidentity"
    return L2_2(L3_2)
  end
  L2_2 = L66_1
  L3_2 = A0_2
  L4_2 = L1_2
  return L2_2(L3_2, L4_2)
end
L68_1(L69_1, L70_1)
L68_1 = L38_1
L69_1 = "recado.profile.set"
function L70_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2
  L2_2 = L36_1
  L3_2 = A0_2
  L2_2 = L2_2(L3_2)
  L3_2 = GetCid
  L4_2 = A0_2
  L3_2 = L3_2(L4_2)
  if not L2_2 or not L3_2 then
    L4_2 = L24_1
    L5_2 = "noidentity"
    return L4_2(L5_2)
  end
  L4_2 = nil
  L5_2 = nil
  L6_2 = nil
  L7_2 = nil
  L8_2 = A1_2.name
  if nil ~= L8_2 then
    L8_2 = L31_1
    L9_2 = A1_2.name
    L10_2 = L1_1
    L11_2 = false
    L8_2 = L8_2(L9_2, L10_2, L11_2)
    L4_2 = L8_2
    if not L4_2 then
      L8_2 = L24_1
      L9_2 = "text"
      return L8_2(L9_2)
    end
  end
  L8_2 = A1_2.about
  if nil ~= L8_2 then
    L8_2 = L31_1
    L9_2 = A1_2.about
    L10_2 = L2_1
    L11_2 = false
    L8_2 = L8_2(L9_2, L10_2, L11_2)
    L5_2 = L8_2
    if not L5_2 then
      L8_2 = L24_1
      L9_2 = "text"
      return L8_2(L9_2)
    end
  end
  L8_2 = A1_2.avatarMedia
  if nil ~= L8_2 then
    L8_2 = A1_2.avatarMedia
    if false ~= L8_2 then
      L8_2 = A1_2.avatarMedia
      if 0 ~= L8_2 then
        L8_2 = A1_2.avatarMedia
        if "" ~= L8_2 then
          goto lbl_60
        end
      end
    end
    L7_2 = true
    goto lbl_116
    ::lbl_60::
    L8_2 = L25_1
    L9_2 = A1_2.avatarMedia
    L8_2 = L8_2(L9_2)
    L6_2 = L8_2
    if not L6_2 then
      L8_2 = L24_1
      L9_2 = "media"
      return L8_2(L9_2)
    end
    L8_2 = type
    L9_2 = MediaInfo
    L8_2 = L8_2(L9_2)
    if "function" == L8_2 then
      L8_2 = MediaInfo
      L9_2 = L6_2
      L8_2 = L8_2(L9_2)
      if L8_2 then
        goto lbl_81
      end
    end
    L8_2 = nil
    ::lbl_81::
    if L8_2 then
      L9_2 = tostring
      L10_2 = L8_2.owner
      L9_2 = L9_2(L10_2)
      L10_2 = tostring
      L11_2 = L3_2
      L10_2 = L10_2(L11_2)
      if L9_2 == L10_2 then
        L9_2 = L8_2.complete
        if L9_2 then
          goto lbl_98
        end
      end
    end
    L9_2 = L24_1
    L10_2 = "media"
    do return L9_2(L10_2) end
    ::lbl_98::
    L9_2 = L8_2.kind
    if "image" ~= L9_2 then
      L9_2 = tostring
      L10_2 = L8_2.mime
      if not L10_2 then
        L10_2 = ""
      end
      L9_2 = L9_2(L10_2)
      L10_2 = L9_2
      L9_2 = L9_2.match
      L11_2 = "^image/"
      L9_2 = L9_2(L10_2, L11_2)
      if not L9_2 then
        L9_2 = L24_1
        L10_2 = "media"
        return L9_2(L10_2)
      end
    end
  end
  ::lbl_116::
  L8_2 = L40_1
  L9_2 = "p:"
  L10_2 = L2_2
  L9_2 = L9_2 .. L10_2
  function L10_2()
    local L0_3, L1_3, L2_3, L3_3, L4_3
    L0_3 = L61_1
    L1_3 = L2_2
    L0_3 = L0_3(L1_3)
    L1_3 = L0_3.exists
    if L1_3 then
      L1_3 = L0_3.owner
      L2_3 = tostring
      L3_3 = L3_2
      L2_3 = L2_3(L3_3)
      if L1_3 == L2_3 then
        goto lbl_20
      end
    end
    L1_3 = L57_1
    L2_3 = L2_2
    L3_3 = tostring
    L4_3 = L3_2
    L3_3, L4_3 = L3_3(L4_3)
    L1_3 = L1_3(L2_3, L3_3, L4_3)
    L0_3 = L1_3
    ::lbl_20::
    L1_3 = L4_2
    if nil ~= L1_3 then
      L1_3 = L4_2
      L0_3.name = L1_3
    end
    L1_3 = L5_2
    if nil ~= L1_3 then
      L1_3 = L5_2
      L0_3.about = L1_3
    end
    L1_3 = L6_2
    if L1_3 then
      L1_3 = L6_2
      L0_3.avatarMedia = L1_3
    else
      L1_3 = L7_2
      if L1_3 then
        L0_3.avatarMedia = nil
      end
    end
    L1_3 = L63_1
    L2_3 = L2_2
    L3_3 = tostring
    L4_3 = L3_2
    L3_3 = L3_3(L4_3)
    L4_3 = L0_3
    L1_3 = L1_3(L2_3, L3_3, L4_3)
    if not L1_3 then
      L1_3 = L24_1
      L2_3 = "db"
      return L1_3(L2_3)
    end
    L1_3 = L66_1
    L2_3 = A0_2
    L3_3 = L2_2
    return L1_3(L2_3, L3_3)
  end
  return L8_2(L9_2, L10_2)
end
L68_1(L69_1, L70_1)
L68_1 = L38_1
L69_1 = "recado.profile.get"
function L70_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2
  L2_2 = L36_1
  L3_2 = A0_2
  L2_2 = L2_2(L3_2)
  if not L2_2 then
    L3_2 = L24_1
    L4_2 = "noidentity"
    return L3_2(L4_2)
  end
  L3_2 = {}
  L4_2 = {}
  L5_2 = ipairs
  L6_2 = type
  L7_2 = A1_2.numbers
  L6_2 = L6_2(L7_2)
  if "table" == L6_2 then
    L6_2 = A1_2.numbers
    if L6_2 then
      goto lbl_25
    end
  end
  L6_2 = {}
  ::lbl_25::
  L5_2, L6_2, L7_2, L8_2 = L5_2(L6_2)
  for L9_2, L10_2 in L5_2, L6_2, L7_2, L8_2 do
    L11_2 = L32_1
    L12_2 = L10_2
    L11_2 = L11_2(L12_2)
    if L11_2 then
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
  L5_2 = {}
  L6_2 = #L3_2
  if L6_2 > 0 then
    L6_2 = L60_1
    L7_2 = L3_2
    L6_2 = L6_2(L7_2)
    L7_2 = L48_1
    L8_2 = L3_2
    L7_2 = L7_2(L8_2)
    L8_2 = ipairs
    L9_2 = L3_2
    L8_2, L9_2, L10_2, L11_2 = L8_2(L9_2)
    for L12_2, L13_2 in L8_2, L9_2, L10_2, L11_2 do
      L14_2 = L65_1
      L15_2 = L2_2
      L16_2 = L13_2
      L17_2 = L6_2[L13_2]
      L18_2 = L7_2[L13_2]
      L14_2 = L14_2(L15_2, L16_2, L17_2, L18_2)
      L5_2[L13_2] = L14_2
    end
  end
  L6_2 = {}
  L6_2.ok = true
  L6_2.profiles = L5_2
  return L6_2
end
L68_1(L69_1, L70_1)
L68_1 = L38_1
L69_1 = "recado.privacy.get"
function L70_1(A0_2)
  local L1_2, L2_2, L3_2, L4_2
  L1_2 = L36_1
  L2_2 = A0_2
  L1_2 = L1_2(L2_2)
  if not L1_2 then
    L2_2 = L24_1
    L3_2 = "noidentity"
    return L2_2(L3_2)
  end
  L2_2 = L67_1
  L3_2 = L61_1
  L4_2 = L1_2
  L3_2, L4_2 = L3_2(L4_2)
  return L2_2(L3_2, L4_2)
end
L68_1(L69_1, L70_1)
L68_1 = L38_1
L69_1 = "recado.privacy.set"
function L70_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2
  L2_2 = L36_1
  L3_2 = A0_2
  L2_2 = L2_2(L3_2)
  L3_2 = GetCid
  L4_2 = A0_2
  L3_2 = L3_2(L4_2)
  if not L2_2 or not L3_2 then
    L4_2 = L24_1
    L5_2 = "noidentity"
    return L4_2(L5_2)
  end
  L4_2 = {}
  L5_2 = ipairs
  L6_2 = L5_1
  L5_2, L6_2, L7_2, L8_2 = L5_2(L6_2)
  for L9_2, L10_2 in L5_2, L6_2, L7_2, L8_2 do
    L11_2 = A1_2[L10_2]
    if nil ~= L11_2 then
      L11_2 = L33_1
      L12_2 = A1_2[L10_2]
      L11_2 = L11_2(L12_2)
      if not L11_2 then
        L12_2 = L24_1
        L13_2 = "invalid"
        L14_2 = {}
        L14_2.field = L10_2
        L12_2, L13_2, L14_2 = L12_2(L13_2, L14_2)
        return L12_2, L13_2, L14_2
      end
      L4_2[L10_2] = L11_2
    end
  end
  L5_2 = nil
  L6_2 = nil
  L7_2 = nil
  L8_2 = nil
  L9_2 = A1_2.readReceipts
  if nil ~= L9_2 then
    L9_2 = L35_1
    L10_2 = A1_2.readReceipts
    L9_2 = L9_2(L10_2)
    L5_2 = L9_2
    if nil == L5_2 then
      L9_2 = L24_1
      L10_2 = "invalid"
      L11_2 = {}
      L11_2.field = "readReceipts"
      return L9_2(L10_2, L11_2)
    end
  end
  L9_2 = A1_2.groupsAdd
  if nil ~= L9_2 then
    L9_2 = L33_1
    L10_2 = A1_2.groupsAdd
    L9_2 = L9_2(L10_2)
    L6_2 = L9_2
    if not L6_2 then
      L9_2 = L24_1
      L10_2 = "invalid"
      L11_2 = {}
      L11_2.field = "groupsAdd"
      return L9_2(L10_2, L11_2)
    end
  end
  L9_2 = A1_2.silenceUnknown
  if nil ~= L9_2 then
    L9_2 = L35_1
    L10_2 = A1_2.silenceUnknown
    L9_2 = L9_2(L10_2)
    L7_2 = L9_2
    if nil == L7_2 then
      L9_2 = L24_1
      L10_2 = "invalid"
      L11_2 = {}
      L11_2.field = "silenceUnknown"
      return L9_2(L10_2, L11_2)
    end
  end
  L9_2 = A1_2.defaultDisappearing
  if nil ~= L9_2 then
    L9_2 = L23_1
    L10_2 = A1_2.defaultDisappearing
    L9_2 = L9_2(L10_2)
    L8_2 = L9_2
    if nil == L8_2 then
      L9_2 = L24_1
      L10_2 = "invalid"
      L11_2 = {}
      L11_2.field = "defaultDisappearing"
      return L9_2(L10_2, L11_2)
    end
  end
  L9_2 = L40_1
  L10_2 = "p:"
  L11_2 = L2_2
  L10_2 = L10_2 .. L11_2
  function L11_2()
    local L0_3, L1_3, L2_3, L3_3, L4_3, L5_3, L6_3, L7_3
    L0_3 = L61_1
    L1_3 = L2_2
    L0_3 = L0_3(L1_3)
    L1_3 = L0_3.exists
    if L1_3 then
      L1_3 = L0_3.owner
      L2_3 = tostring
      L3_3 = L3_2
      L2_3 = L2_3(L3_3)
      if L1_3 == L2_3 then
        goto lbl_20
      end
    end
    L1_3 = L57_1
    L2_3 = L2_2
    L3_3 = tostring
    L4_3 = L3_2
    L3_3, L4_3, L5_3, L6_3, L7_3 = L3_3(L4_3)
    L1_3 = L1_3(L2_3, L3_3, L4_3, L5_3, L6_3, L7_3)
    L0_3 = L1_3
    ::lbl_20::
    L1_3 = pairs
    L2_3 = L4_2
    L1_3, L2_3, L3_3, L4_3 = L1_3(L2_3)
    for L5_3, L6_3 in L1_3, L2_3, L3_3, L4_3 do
      L7_3 = L0_3.privacy
      L7_3[L5_3] = L6_3
    end
    L1_3 = L5_2
    if nil ~= L1_3 then
      L1_3 = L5_2
      L0_3.readReceipts = L1_3
    end
    L1_3 = L6_2
    if L1_3 then
      L1_3 = L6_2
      L0_3.groupsAdd = L1_3
    end
    L1_3 = L7_2
    if nil ~= L1_3 then
      L1_3 = L7_2
      L0_3.silenceUnknown = L1_3
    end
    L1_3 = L8_2
    if nil ~= L1_3 then
      L1_3 = L8_2
      L0_3.defaultDisappearing = L1_3
    end
    L1_3 = L63_1
    L2_3 = L2_2
    L3_3 = tostring
    L4_3 = L3_2
    L3_3 = L3_3(L4_3)
    L4_3 = L0_3
    L1_3 = L1_3(L2_3, L3_3, L4_3)
    if not L1_3 then
      L1_3 = L24_1
      L2_3 = "db"
      return L1_3(L2_3)
    end
    L1_3 = L67_1
    L2_3 = L61_1
    L3_3 = L2_2
    L2_3, L3_3, L4_3, L5_3, L6_3, L7_3 = L2_3(L3_3)
    return L1_3(L2_3, L3_3, L4_3, L5_3, L6_3, L7_3)
  end
  return L9_2(L10_2, L11_2)
end
L68_1(L69_1, L70_1)
function L68_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2
  L2_2 = {}
  L3_2 = "pinned"
  L4_2 = "muted_until"
  L5_2 = "cleared_before"
  L2_2[1] = L3_2
  L2_2[2] = L4_2
  L2_2[3] = L5_2
  L3_2 = ipairs
  L4_2 = {}
  L5_2 = "disappearing"
  L6_2 = "locked"
  L7_2 = "archived"
  L4_2[1] = L5_2
  L4_2[2] = L6_2
  L4_2[3] = L7_2
  L3_2, L4_2, L5_2, L6_2 = L3_2(L4_2)
  for L7_2, L8_2 in L3_2, L4_2, L5_2, L6_2 do
    L9_2 = L43_1
    L10_2 = "apex_phone_thread_meta"
    L11_2 = L8_2
    L9_2 = L9_2(L10_2, L11_2)
    if L9_2 then
      L9_2 = #L2_2
      L9_2 = L9_2 + 1
      L2_2[L9_2] = L8_2
    end
  end
  L3_2 = pcall
  L4_2 = MySQL
  L4_2 = L4_2.single
  L4_2 = L4_2.await
  L5_2 = "SELECT %s FROM apex_phone_thread_meta WHERE owner = ? AND app = ? AND other = ?"
  L6_2 = L5_2
  L5_2 = L5_2.format
  L7_2 = table
  L7_2 = L7_2.concat
  L8_2 = L2_2
  L9_2 = ", "
  L7_2, L8_2, L9_2, L10_2, L11_2 = L7_2(L8_2, L9_2)
  L5_2 = L5_2(L6_2, L7_2, L8_2, L9_2, L10_2, L11_2)
  L6_2 = {}
  L7_2 = A0_2
  L8_2 = L0_1
  L9_2 = A1_2
  L6_2[1] = L7_2
  L6_2[2] = L8_2
  L6_2[3] = L9_2
  L3_2, L4_2 = L3_2(L4_2, L5_2, L6_2)
  if L3_2 then
    L5_2 = type
    L6_2 = L4_2
    L5_2 = L5_2(L6_2)
    if "table" == L5_2 and L4_2 then
      goto lbl_59
      L5_2 = L4_2 or L5_2
    end
  end
  L5_2 = {}
  ::lbl_59::
  return L5_2
end
function L69_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2
  L2_2 = type
  L3_2 = A1_2
  L2_2 = L2_2(L3_2)
  if "table" == L2_2 then
    L2_2 = tonumber
    L3_2 = A1_2.locked
    L2_2 = L2_2(L3_2)
    if not L2_2 then
      L2_2 = 0
    end
    if 1 == L2_2 then
      goto lbl_16
    end
  end
  L2_2 = false
  do return L2_2 end
  ::lbl_16::
  L2_2 = type
  L3_2 = RecadoIsUnlocked
  L2_2 = L2_2(L3_2)
  if "function" ~= L2_2 then
    L2_2 = false
    return L2_2
  end
  L2_2 = pcall
  L3_2 = RecadoIsUnlocked
  L4_2 = A0_2
  L2_2, L3_2 = L2_2(L3_2, L4_2)
  L4_2 = not L2_2 or true ~= L3_2
  return L4_2
end
function L70_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2
  L2_2 = pcall
  L3_2 = MySQL
  L3_2 = L3_2.query
  L3_2 = L3_2.await
  L4_2 = [[
SELECT c.id, c.title, c.avatar FROM apex_phone_conversation_members a
        JOIN apex_phone_conversation_members b ON b.conversation_id = a.conversation_id AND b.member = ? AND b.left_at IS NULL
        JOIN apex_phone_conversations c ON c.id = a.conversation_id
        WHERE a.member = ? AND a.left_at IS NULL AND c.app = ? ORDER BY c.last_id DESC LIMIT 50]]
  L5_2 = {}
  L6_2 = A1_2
  L7_2 = A0_2
  L8_2 = L0_1
  L5_2[1] = L6_2
  L5_2[2] = L7_2
  L5_2[3] = L8_2
  L2_2, L3_2 = L2_2(L3_2, L4_2, L5_2)
  L4_2 = {}
  L5_2 = {}
  L6_2 = {}
  if L2_2 then
    L7_2 = type
    L8_2 = L3_2
    L7_2 = L7_2(L8_2)
    if "table" == L7_2 then
      goto lbl_27
    end
  end
  do return L4_2 end
  ::lbl_27::
  L7_2 = ipairs
  L8_2 = L3_2
  L7_2, L8_2, L9_2, L10_2 = L7_2(L8_2)
  for L11_2, L12_2 in L7_2, L8_2, L9_2, L10_2 do
    L13_2 = L25_1
    L14_2 = L12_2.id
    L13_2 = L13_2(L14_2)
    if L13_2 then
      L14_2 = L6_2[L13_2]
      if not L14_2 then
        L14_2 = {}
        L14_2.id = L13_2
        L15_2 = L12_2.title
        L14_2.title = L15_2
        L15_2 = L25_1
        L16_2 = L12_2.avatar
        L15_2 = L15_2(L16_2)
        L14_2.avatar = L15_2
        L14_2.memberCount = 0
        L6_2[L13_2] = L14_2
        L15_2 = #L4_2
        L15_2 = L15_2 + 1
        L4_2[L15_2] = L14_2
        L15_2 = #L5_2
        L15_2 = L15_2 + 1
        L5_2[L15_2] = L13_2
      end
    end
  end
  L7_2 = #L5_2
  if L7_2 > 0 then
    L7_2 = pcall
    L8_2 = MySQL
    L8_2 = L8_2.query
    L8_2 = L8_2.await
    L9_2 = "SELECT conversation_id AS id, COUNT(*) AS n FROM apex_phone_conversation_members WHERE left_at IS NULL AND conversation_id IN (%s) GROUP BY conversation_id"
    L10_2 = L9_2
    L9_2 = L9_2.format
    L11_2 = L27_1
    L12_2 = #L5_2
    L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2 = L11_2(L12_2)
    L9_2 = L9_2(L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2)
    L10_2 = L5_2
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
          L15_2 = L25_1
          L16_2 = L14_2.id
          L15_2 = L15_2(L16_2)
          if not L15_2 then
            L15_2 = -1
          end
          L15_2 = L6_2[L15_2]
          if L15_2 then
            L16_2 = math
            L16_2 = L16_2.tointeger
            L17_2 = tonumber
            L18_2 = L14_2.n
            L17_2 = L17_2(L18_2)
            if not L17_2 then
              L17_2 = 0
            end
            L16_2 = L16_2(L17_2)
            if not L16_2 then
              L16_2 = 0
            end
            L15_2.memberCount = L16_2
          end
        end
      end
    end
  end
  return L4_2
end
L71_1 = L38_1
L72_1 = "recado.contact.info"
function L73_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2
  L2_2 = L36_1
  L3_2 = A0_2
  L2_2 = L2_2(L3_2)
  L3_2 = GetCid
  L4_2 = A0_2
  L3_2 = L3_2(L4_2)
  if not L2_2 or not L3_2 then
    L4_2 = L24_1
    L5_2 = "noidentity"
    return L4_2(L5_2)
  end
  L4_2 = L32_1
  L5_2 = A1_2.number
  L4_2 = L4_2(L5_2)
  if not L4_2 then
    L5_2 = L24_1
    L6_2 = "invalid"
    return L5_2(L6_2)
  end
  L5_2 = L48_1
  L6_2 = {}
  L7_2 = L4_2
  L6_2[1] = L7_2
  L5_2 = L5_2(L6_2)
  L5_2 = L5_2[L4_2]
  L6_2 = L61_1
  L7_2 = L4_2
  L6_2 = L6_2(L7_2)
  L7_2 = L65_1
  L8_2 = L2_2
  L9_2 = L4_2
  L10_2 = L6_2
  L11_2 = L5_2
  L7_2 = L7_2(L8_2, L9_2, L10_2, L11_2)
  L7_2.ok = true
  L8_2 = L4_2 == L2_2 or L8_2
  L7_2.self = L8_2
  L8_2 = pcall
  L9_2 = MySQL
  L9_2 = L9_2.single
  L9_2 = L9_2.await
  L10_2 = "SELECT id, name, avatar, avatar_photo, favorite FROM apex_phone_contacts WHERE owner = ? AND number = ? LIMIT 1"
  L11_2 = {}
  L12_2 = L3_2
  L13_2 = L4_2
  L11_2[1] = L12_2
  L11_2[2] = L13_2
  L8_2, L9_2 = L8_2(L9_2, L10_2, L11_2)
  if L8_2 then
    L10_2 = type
    L11_2 = L9_2
    L10_2 = L10_2(L11_2)
    if "table" == L10_2 then
      L7_2.isContact = true
      L10_2 = {}
      L11_2 = math
      L11_2 = L11_2.tointeger
      L12_2 = tonumber
      L13_2 = L9_2.id
      L12_2, L13_2, L14_2 = L12_2(L13_2)
      L11_2 = L11_2(L12_2, L13_2, L14_2)
      L10_2.id = L11_2
      L11_2 = L9_2.name
      L10_2.name = L11_2
      L11_2 = L9_2.avatar
      L10_2.avatar = L11_2
      L11_2 = L25_1
      L12_2 = L9_2.avatar_photo
      L11_2 = L11_2(L12_2)
      L10_2.avatarPhoto = L11_2
      L11_2 = L9_2.favorite
      L11_2 = 1 == L11_2
      L10_2.favorite = L11_2
      L7_2.contact = L10_2
  end
  else
    L7_2.isContact = false
  end
  L10_2 = L54_1
  L11_2 = L3_2
  L12_2 = L4_2
  L10_2 = L10_2(L11_2, L12_2)
  L7_2.blocked = L10_2
  if L4_2 ~= L2_2 then
    L10_2 = L70_1
    L11_2 = L2_2
    L12_2 = L4_2
    L10_2 = L10_2(L11_2, L12_2)
    L7_2.groupsInCommon = L10_2
    L10_2 = L68_1
    L11_2 = L2_2
    L12_2 = L4_2
    L10_2 = L10_2(L11_2, L12_2)
    L11_2 = tonumber
    L12_2 = L10_2.muted_until
    L11_2 = L11_2(L12_2)
    if L11_2 then
      L12_2 = L28_1
      L12_2 = L12_2()
      if L11_2 > L12_2 then
        L7_2.mutedUntil = L11_2
      end
    end
    L12_2 = math
    L12_2 = L12_2.tointeger
    L13_2 = tonumber
    L14_2 = L10_2.disappearing
    L13_2, L14_2 = L13_2(L14_2)
    L12_2 = L12_2(L13_2, L14_2)
    if not L12_2 then
      L12_2 = 0
    end
    L7_2.disappearing = L12_2
    L12_2 = tonumber
    L13_2 = L10_2.locked
    L12_2 = L12_2(L13_2)
    if not L12_2 then
      L12_2 = 0
    end
    L12_2 = 1 == L12_2
    L7_2.locked = L12_2
    L12_2 = tonumber
    L13_2 = L10_2.pinned
    L12_2 = L12_2(L13_2)
    if not L12_2 then
      L12_2 = 0
    end
    L12_2 = 1 == L12_2
    L7_2.pinned = L12_2
  end
  return L7_2
end
L71_1(L72_1, L73_1)
L71_1 = "id, app, title, avatar, created_by, created, last_id, description, invite_code, send_policy, edit_policy, theme, kind, community_id"
function L72_1(A0_2)
  local L1_2, L2_2, L3_2, L4_2, L5_2
  L1_2 = pcall
  L2_2 = MySQL
  L2_2 = L2_2.single
  L2_2 = L2_2.await
  L3_2 = "SELECT %s FROM apex_phone_conversations WHERE id = ?"
  L4_2 = L3_2
  L3_2 = L3_2.format
  L5_2 = L71_1
  L3_2 = L3_2(L4_2, L5_2)
  L4_2 = {}
  L5_2 = A0_2
  L4_2[1] = L5_2
  L1_2, L2_2 = L1_2(L2_2, L3_2, L4_2)
  if L1_2 then
    L3_2 = type
    L4_2 = L2_2
    L3_2 = L3_2(L4_2)
    if "table" == L3_2 then
      goto lbl_23
    end
  end
  L3_2 = nil
  do return L3_2 end
  ::lbl_23::
  L3_2 = L25_1
  L4_2 = L2_2.id
  L3_2 = L3_2(L4_2)
  if not L3_2 then
    L3_2 = A0_2
  end
  L2_2.id = L3_2
  L3_2 = L2_2.app
  if not L3_2 then
    L3_2 = "sms"
  end
  L2_2.app = L3_2
  L3_2 = L25_1
  L4_2 = L2_2.avatar
  L3_2 = L3_2(L4_2)
  L2_2.avatar = L3_2
  L3_2 = L25_1
  L4_2 = L2_2.last_id
  L3_2 = L3_2(L4_2)
  L2_2.last_id = L3_2
  L3_2 = tonumber
  L4_2 = L2_2.created
  L3_2 = L3_2(L4_2)
  L2_2.created = L3_2
  L3_2 = L2_2.send_policy
  if "admins" == L3_2 then
    L3_2 = "admins"
    if L3_2 then
      goto lbl_54
    end
  end
  L3_2 = "all"
  ::lbl_54::
  L2_2.send_policy = L3_2
  L3_2 = L2_2.edit_policy
  if "all" == L3_2 then
    L3_2 = "all"
    if L3_2 then
      goto lbl_62
    end
  end
  L3_2 = "admins"
  ::lbl_62::
  L2_2.edit_policy = L3_2
  L3_2 = type
  L4_2 = L2_2.kind
  L3_2 = L3_2(L4_2)
  if "string" == L3_2 then
    L3_2 = L2_2.kind
    if "" ~= L3_2 then
      L3_2 = L2_2.kind
      if L3_2 then
        goto lbl_75
      end
    end
  end
  L3_2 = "group"
  ::lbl_75::
  L2_2.kind = L3_2
  L3_2 = L25_1
  L4_2 = L2_2.community_id
  L3_2 = L3_2(L4_2)
  L2_2.community_id = L3_2
  return L2_2
end
function L73_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2, L6_2, L7_2
  L2_2 = pcall
  L3_2 = MySQL
  L3_2 = L3_2.single
  L3_2 = L3_2.await
  L4_2 = "SELECT role, joined, last_read_id FROM apex_phone_conversation_members WHERE conversation_id = ? AND member = ? AND left_at IS NULL"
  L5_2 = {}
  L6_2 = A0_2
  L7_2 = A1_2
  L5_2[1] = L6_2
  L5_2[2] = L7_2
  L2_2, L3_2 = L2_2(L3_2, L4_2, L5_2)
  if L2_2 then
    L4_2 = type
    L5_2 = L3_2
    L4_2 = L4_2(L5_2)
    if "table" == L4_2 then
      goto lbl_21
    end
  end
  L4_2 = nil
  do return L4_2 end
  ::lbl_21::
  L4_2 = {}
  L5_2 = L3_2.role
  if "admin" == L5_2 then
    L5_2 = "admin"
    if L5_2 then
      goto lbl_30
    end
  end
  L5_2 = "member"
  ::lbl_30::
  L4_2.role = L5_2
  L5_2 = tonumber
  L6_2 = L3_2.joined
  L5_2 = L5_2(L6_2)
  if not L5_2 then
    L5_2 = 0
  end
  L4_2.joined = L5_2
  L5_2 = L25_1
  L6_2 = L3_2.last_read_id
  L5_2 = L5_2(L6_2)
  L4_2.lastReadId = L5_2
  return L4_2
end
function L74_1(A0_2)
  local L1_2, L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2
  L1_2 = MySQL
  L1_2 = L1_2.query
  L1_2 = L1_2.await
  L2_2 = "SELECT member, role, joined FROM apex_phone_conversation_members WHERE conversation_id = ? AND left_at IS NULL ORDER BY joined ASC, member ASC"
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
    L2_2[L9_2] = L10_2
  end
  return L2_2
end
L75_1 = {}
function L76_1(A0_2)
  local L1_2, L2_2, L3_2, L4_2
  L1_2 = L75_1
  L1_2 = L1_2[A0_2]
  if L1_2 then
    L2_2 = GetGameTimer
    L2_2 = L2_2()
    L3_2 = L1_2.t
    L2_2 = L2_2 - L3_2
    L3_2 = 5000
    if L2_2 < L3_2 then
      return L1_2
    end
  end
  L2_2 = L72_1
  L3_2 = A0_2
  L2_2 = L2_2(L3_2)
  if not L2_2 then
    L3_2 = nil
    return L3_2
  end
  L3_2 = {}
  L4_2 = L2_2.app
  L3_2.app = L4_2
  L4_2 = L2_2.send_policy
  L3_2.send = L4_2
  L4_2 = L2_2.edit_policy
  L3_2.edit = L4_2
  L4_2 = GetGameTimer
  L4_2 = L4_2()
  L3_2.t = L4_2
  L1_2 = L3_2
  L3_2 = L75_1
  L3_2[A0_2] = L1_2
  return L1_2
end
function L77_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2, L6_2, L7_2
  L2_2 = L26_1
  L3_2 = A0_2
  L2_2 = L2_2(L3_2)
  if L2_2 and nil ~= A1_2 and "" ~= A1_2 then
    L3_2 = L18_1
    if L3_2 then
      goto lbl_15
    end
  end
  L3_2 = false
  do return L3_2 end
  ::lbl_15::
  L3_2 = L76_1
  L4_2 = L2_2
  L3_2 = L3_2(L4_2)
  if not L3_2 then
    L4_2 = false
    return L4_2
  end
  L4_2 = L73_1
  L5_2 = L2_2
  L6_2 = tostring
  L7_2 = A1_2
  L6_2, L7_2 = L6_2(L7_2)
  L4_2 = L4_2(L5_2, L6_2, L7_2)
  if not L4_2 then
    L5_2 = false
    return L5_2
  end
  L5_2 = L3_2.send
  L5_2 = "admins" ~= L5_2
  return L5_2
end
RecadoGroupCanSend = L77_1
function L77_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2, L6_2, L7_2
  L2_2 = L26_1
  L3_2 = A0_2
  L2_2 = L2_2(L3_2)
  if L2_2 and nil ~= A1_2 and "" ~= A1_2 then
    L3_2 = L18_1
    if L3_2 then
      goto lbl_15
    end
  end
  L3_2 = false
  do return L3_2 end
  ::lbl_15::
  L3_2 = L76_1
  L4_2 = L2_2
  L3_2 = L3_2(L4_2)
  if not L3_2 then
    L4_2 = false
    return L4_2
  end
  L4_2 = L73_1
  L5_2 = L2_2
  L6_2 = tostring
  L7_2 = A1_2
  L6_2, L7_2 = L6_2(L7_2)
  L4_2 = L4_2(L5_2, L6_2, L7_2)
  if not L4_2 then
    L5_2 = false
    return L5_2
  end
  L5_2 = L3_2.edit
  L5_2 = "admins" ~= L5_2
  return L5_2
end
RecadoGroupCanEdit = L77_1
function L77_1(A0_2, A1_2, A2_2)
  local L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2
  L3_2 = L72_1
  L4_2 = A1_2
  L3_2 = L3_2(L4_2)
  if L3_2 then
    L4_2 = L3_2.app
    L5_2 = L0_1
    if L4_2 == L5_2 then
      goto lbl_13
    end
  end
  L4_2 = nil
  L5_2 = nil
  L6_2 = nil
  L7_2 = "notfound"
  do return L4_2, L5_2, L6_2, L7_2 end
  ::lbl_13::
  L4_2 = L36_1
  L5_2 = A0_2
  L4_2 = L4_2(L5_2)
  if not L4_2 then
    L5_2 = nil
    L6_2 = nil
    L7_2 = nil
    L8_2 = "noidentity"
    return L5_2, L6_2, L7_2, L8_2
  end
  L5_2 = L73_1
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
function L78_1(A0_2, A1_2, A2_2)
  local L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2
  L3_2 = {}
  L4_2 = {}
  L5_2 = {}
  L6_2 = ipairs
  L7_2 = A1_2
  L6_2, L7_2, L8_2, L9_2 = L6_2(L7_2)
  for L10_2, L11_2 in L6_2, L7_2, L8_2, L9_2 do
    L12_2 = A2_2[L11_2]
    if nil ~= L12_2 then
      L13_2 = #L3_2
      L13_2 = L13_2 + 1
      L14_2 = "`"
      L15_2 = L11_2
      L16_2 = "`"
      L14_2 = L14_2 .. L15_2 .. L16_2
      L3_2[L13_2] = L14_2
      L13_2 = #L4_2
      L13_2 = L13_2 + 1
      L4_2[L13_2] = "?"
      L13_2 = #L5_2
      L13_2 = L13_2 + 1
      L5_2[L13_2] = L12_2
    end
  end
  L6_2 = MySQL
  L6_2 = L6_2.insert
  L6_2 = L6_2.await
  L7_2 = "INSERT INTO %s (%s) VALUES (%s)"
  L8_2 = L7_2
  L7_2 = L7_2.format
  L9_2 = A0_2
  L10_2 = table
  L10_2 = L10_2.concat
  L11_2 = L3_2
  L12_2 = ", "
  L10_2 = L10_2(L11_2, L12_2)
  L11_2 = table
  L11_2 = L11_2.concat
  L12_2 = L4_2
  L13_2 = ", "
  L11_2, L12_2, L13_2, L14_2, L15_2, L16_2 = L11_2(L12_2, L13_2)
  L7_2 = L7_2(L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2)
  L8_2 = L5_2
  return L6_2(L7_2, L8_2)
end
L79_1 = {}
L80_1 = "app"
L81_1 = "sender"
L82_1 = "receiver"
L83_1 = "type"
L84_1 = "content"
L85_1 = "payload"
L86_1 = "read"
L87_1 = "created"
L88_1 = "conversation_id"
L79_1[1] = L80_1
L79_1[2] = L81_1
L79_1[3] = L82_1
L79_1[4] = L83_1
L79_1[5] = L84_1
L79_1[6] = L85_1
L79_1[7] = L86_1
L79_1[8] = L87_1
L79_1[9] = L88_1
L80_1 = {}
L81_1 = "app"
L82_1 = "title"
L83_1 = "avatar"
L84_1 = "created_by"
L85_1 = "created"
L86_1 = "description"
L87_1 = "send_policy"
L88_1 = "edit_policy"
L89_1 = "theme"
L90_1 = "kind"
L80_1[1] = L81_1
L80_1[2] = L82_1
L80_1[3] = L83_1
L80_1[4] = L84_1
L80_1[5] = L85_1
L80_1[6] = L86_1
L80_1[7] = L87_1
L80_1[8] = L88_1
L80_1[9] = L89_1
L80_1[10] = L90_1
function L81_1(A0_2, A1_2)
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
function L82_1(A0_2, A1_2, A2_2, A3_2, A4_2)
  local L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2
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
  L6_2 = pcall
  L7_2 = json
  L7_2 = L7_2.encode
  L8_2 = L5_2
  L6_2, L7_2 = L6_2(L7_2, L8_2)
  L8_2 = L28_1
  L8_2 = L8_2()
  L9_2 = L29_1
  L10_2 = A3_2
  L11_2 = 255
  L9_2 = L9_2(L10_2, L11_2)
  L10_2 = pcall
  L11_2 = L78_1
  L12_2 = "apex_phone_messages"
  L13_2 = L79_1
  L14_2 = {}
  L15_2 = A0_2.app
  L14_2.app = L15_2
  L14_2.sender = A1_2
  L15_2 = "g:"
  L16_2 = A0_2.id
  L15_2 = L15_2 .. L16_2
  L14_2.receiver = L15_2
  L14_2.type = "system"
  L14_2.content = L9_2
  L15_2 = L7_2 or L15_2
  if not L6_2 or not L7_2 then
    L15_2 = nil
  end
  L14_2.payload = L15_2
  L14_2.read = 0
  L14_2.created = L8_2
  L15_2 = A0_2.id
  L14_2.conversation_id = L15_2
  L10_2, L11_2 = L10_2(L11_2, L12_2, L13_2, L14_2)
  if L10_2 then
    L12_2 = L25_1
    L13_2 = L11_2
    L12_2 = L12_2(L13_2)
    if L12_2 then
      goto lbl_63
      L11_2 = L12_2 or L11_2
    end
  end
  L11_2 = nil
  ::lbl_63::
  if not L11_2 then
    L12_2 = Dbg
    L13_2 = "recado"
    L14_2 = "system message %s not saved in group %s"
    L15_2 = A2_2
    L16_2 = A0_2.id
    L12_2(L13_2, L14_2, L15_2, L16_2)
    L12_2 = nil
    return L12_2
  end
  L12_2 = L81_1
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
  L12_2.content = L9_2
  L12_2.payload = L5_2
  L12_2.read = false
  L12_2.created = L8_2
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
  L13_2 = type
  L14_2 = GroupBroadcast
  L13_2 = L13_2(L14_2)
  if "function" == L13_2 then
    L13_2 = pcall
    L14_2 = GroupBroadcast
    L15_2 = A0_2.id
    L16_2 = "message"
    L17_2 = L12_2
    L13_2(L14_2, L15_2, L16_2, L17_2)
  end
  return L12_2
end
function L83_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2, L6_2
  L2_2 = A0_2.id
  A1_2.id = L2_2
  L3_2 = A0_2.id
  L2_2 = L75_1
  L2_2[L3_2] = nil
  L2_2 = type
  L3_2 = GroupBroadcast
  L2_2 = L2_2(L3_2)
  if "function" == L2_2 then
    L2_2 = pcall
    L3_2 = GroupBroadcast
    L4_2 = A0_2.id
    L5_2 = "groupUpdate"
    L6_2 = A1_2
    L2_2, L3_2 = L2_2(L3_2, L4_2, L5_2, L6_2)
    L4_2 = L3_2 or L4_2
    if not L2_2 or not L3_2 then
      L4_2 = 0
    end
    return L4_2
  end
  L2_2 = 0
  return L2_2
end
function L84_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2, L6_2, L7_2
  L2_2 = L25_1
  L3_2 = A1_2
  L2_2 = L2_2(L3_2)
  L3_2 = GetCid
  L4_2 = A0_2
  L3_2 = L3_2(L4_2)
  if L2_2 and L3_2 then
    L4_2 = type
    L5_2 = MediaInfo
    L4_2 = L4_2(L5_2)
    if "function" == L4_2 then
      goto lbl_18
    end
  end
  L4_2 = nil
  do return L4_2 end
  ::lbl_18::
  L4_2 = MediaInfo
  L5_2 = L2_2
  L4_2 = L4_2(L5_2)
  if L4_2 then
    L5_2 = tostring
    L6_2 = L4_2.owner
    L5_2 = L5_2(L6_2)
    L6_2 = tostring
    L7_2 = L3_2
    L6_2 = L6_2(L7_2)
    if L5_2 == L6_2 then
      L5_2 = L4_2.complete
      if L5_2 then
        goto lbl_36
      end
    end
  end
  L5_2 = nil
  do return L5_2 end
  ::lbl_36::
  L5_2 = L4_2.kind
  if "image" ~= L5_2 then
    L5_2 = tostring
    L6_2 = L4_2.mime
    if not L6_2 then
      L6_2 = ""
    end
    L5_2 = L5_2(L6_2)
    L6_2 = L5_2
    L5_2 = L5_2.match
    L7_2 = "^image/"
    L5_2 = L5_2(L6_2, L7_2)
    if not L5_2 then
      L5_2 = nil
      return L5_2
    end
  end
  return L2_2
end
function L85_1(A0_2, A1_2, A2_2, A3_2)
  local L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2, L19_2, L20_2, L21_2
  L4_2 = L74_1
  L5_2 = A1_2.id
  L4_2 = L4_2(L5_2)
  L5_2 = {}
  L6_2 = ipairs
  L7_2 = L4_2
  L6_2, L7_2, L8_2, L9_2 = L6_2(L7_2)
  for L10_2, L11_2 in L6_2, L7_2, L8_2, L9_2 do
    L12_2 = #L5_2
    L12_2 = L12_2 + 1
    L13_2 = L11_2.member
    L5_2[L12_2] = L13_2
  end
  L6_2 = L53_1
  L7_2 = GetCid
  L8_2 = A0_2
  L7_2 = L7_2(L8_2)
  L8_2 = L5_2
  L6_2 = L6_2(L7_2, L8_2)
  L7_2 = L60_1
  L8_2 = L5_2
  L7_2 = L7_2(L8_2)
  L8_2 = {}
  if A3_2 then
    L9_2 = A3_2.role
    if L9_2 then
      goto lbl_35
    end
  end
  L9_2 = "member"
  ::lbl_35::
  L10_2 = ipairs
  L11_2 = L4_2
  L10_2, L11_2, L12_2, L13_2 = L10_2(L11_2)
  for L14_2, L15_2 in L10_2, L11_2, L12_2, L13_2 do
    L16_2 = {}
    L17_2 = L15_2.member
    L16_2.member = L17_2
    L17_2 = L15_2.role
    L16_2.role = L17_2
    L17_2 = L15_2.joined
    L16_2.joined = L17_2
    L17_2 = L15_2.member
    L17_2 = L6_2[L17_2]
    L16_2.name = L17_2
    L17_2 = L15_2.member
    L17_2 = L7_2[L17_2]
    if L17_2 then
      L18_2 = L17_2.exists
      if L18_2 then
        L18_2 = L17_2.name
        if "" ~= L18_2 then
          L18_2 = L17_2.name
          L16_2.profileName = L18_2
        end
        L18_2 = L17_2.avatarMedia
        if L18_2 then
          L18_2 = RecadoCanSee
          L19_2 = A2_2
          L20_2 = L15_2.member
          L21_2 = "photo"
          L18_2 = L18_2(L19_2, L20_2, L21_2)
          if L18_2 then
            L18_2 = L17_2.avatarMedia
            L16_2.avatar = L18_2
          end
        end
      end
    end
    L18_2 = L15_2.member
    if L18_2 == A2_2 then
      L16_2.isMe = true
      L9_2 = L15_2.role
    end
    L18_2 = #L8_2
    L18_2 = L18_2 + 1
    L8_2[L18_2] = L16_2
  end
  L10_2 = "admin" == L9_2
  L11_2 = {}
  L11_2.ok = true
  L12_2 = A1_2.id
  L11_2.id = L12_2
  L12_2 = A1_2.app
  L11_2.app = L12_2
  L12_2 = A1_2.title
  L11_2.title = L12_2
  L12_2 = A1_2.avatar
  L11_2.avatar = L12_2
  L12_2 = A1_2.description
  if not L12_2 then
    L12_2 = ""
  end
  L11_2.description = L12_2
  L12_2 = A1_2.send_policy
  L11_2.sendPolicy = L12_2
  L12_2 = A1_2.edit_policy
  L11_2.editPolicy = L12_2
  L12_2 = A1_2.theme
  L11_2.theme = L12_2
  L12_2 = A1_2.kind
  L11_2.kind = L12_2
  L12_2 = A1_2.community_id
  L11_2.communityId = L12_2
  L12_2 = A1_2.created_by
  L11_2.createdBy = L12_2
  L12_2 = A1_2.created
  L11_2.created = L12_2
  L12_2 = A1_2.last_id
  L11_2.lastId = L12_2
  L11_2.myRole = L9_2
  L11_2.me = A2_2
  L12_2 = L21_1
  L12_2 = L12_2()
  L11_2.max = L12_2
  L12_2 = #L8_2
  L11_2.memberCount = L12_2
  L11_2.members = L8_2
  L11_2.pinned = false
  L12_2 = A1_2.edit_policy
  L12_2 = "admins" ~= L12_2 or L12_2
  L11_2.canEdit = L12_2
  L12_2 = A1_2.send_policy
  L12_2 = "admins" ~= L12_2 or L12_2
  L11_2.canSend = L12_2
  L12_2 = L68_1
  L13_2 = A2_2
  L14_2 = "g:"
  L15_2 = A1_2.id
  L14_2 = L14_2 .. L15_2
  L12_2 = L12_2(L13_2, L14_2)
  L13_2 = tonumber
  L14_2 = L12_2.pinned
  L13_2 = L13_2(L14_2)
  if not L13_2 then
    L13_2 = 0
  end
  L13_2 = 1 == L13_2
  L11_2.pinned = L13_2
  L13_2 = tonumber
  L14_2 = L12_2.muted_until
  L13_2 = L13_2(L14_2)
  if L13_2 then
    L14_2 = L28_1
    L14_2 = L14_2()
    if L13_2 > L14_2 then
      L11_2.mutedUntil = L13_2
    end
  end
  L14_2 = tonumber
  L15_2 = L12_2.locked
  L14_2 = L14_2(L15_2)
  if not L14_2 then
    L14_2 = 0
  end
  L14_2 = 1 == L14_2
  L11_2.locked = L14_2
  L14_2 = L43_1
  L15_2 = "apex_phone_conversations"
  L16_2 = "disappearing"
  L14_2 = L14_2(L15_2, L16_2)
  if L14_2 then
    L14_2 = pcall
    L15_2 = MySQL
    L15_2 = L15_2.scalar
    L15_2 = L15_2.await
    L16_2 = "SELECT disappearing FROM apex_phone_conversations WHERE id = ?"
    L17_2 = {}
    L18_2 = A1_2.id
    L17_2[1] = L18_2
    L14_2, L15_2 = L14_2(L15_2, L16_2, L17_2)
    if L14_2 then
      L16_2 = math
      L16_2 = L16_2.tointeger
      L17_2 = tonumber
      L18_2 = L15_2
      L17_2, L18_2, L19_2, L20_2, L21_2 = L17_2(L18_2)
      L16_2 = L16_2(L17_2, L18_2, L19_2, L20_2, L21_2)
      if L16_2 then
        goto lbl_215
      end
      L16_2 = 0
      if L16_2 then
        goto lbl_215
      end
    end
    L16_2 = 0
    ::lbl_215::
    L11_2.disappearing = L16_2
  else
    L11_2.disappearing = 0
  end
  if L10_2 then
    L14_2 = A1_2.invite_code
    if L14_2 then
      L14_2 = A1_2.invite_code
      if "" ~= L14_2 then
        L14_2 = A1_2.invite_code
        L11_2.inviteCode = L14_2
        L14_2 = "phone://recado/join/"
        L15_2 = A1_2.invite_code
        L14_2 = L14_2 .. L15_2
        L11_2.inviteLink = L14_2
      end
    end
  end
  return L11_2
end
function L86_1(A0_2, A1_2)
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
  L4_2 = L21_1
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
      L14_2 = L21_1
      L14_2 = L14_2()
      L13_2.max = L14_2
      return L11_2, L12_2, L13_2
    end
    L11_2 = L32_1
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
      L16_2 = L29_1
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
function L87_1(A0_2, A1_2, A2_2)
  local L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2
  L3_2 = {}
  L4_2 = ipairs
  L5_2 = A0_2
  L4_2, L5_2, L6_2, L7_2 = L4_2(L5_2)
  for L8_2, L9_2 in L4_2, L5_2, L6_2, L7_2 do
    L10_2 = A1_2[L9_2]
    if L10_2 then
      L11_2 = L54_1
      L12_2 = L10_2
      L13_2 = A2_2
      L11_2 = L11_2(L12_2, L13_2)
      if L11_2 then
        L3_2[L9_2] = "blocked"
      end
    end
  end
  L4_2 = #A0_2
  if L4_2 > 0 then
    L4_2 = pcall
    L5_2 = MySQL
    L5_2 = L5_2.query
    L5_2 = L5_2.await
    L6_2 = "SELECT member, COUNT(*) AS n FROM apex_phone_conversation_members WHERE left_at IS NULL AND member IN (%s) GROUP BY member"
    L7_2 = L6_2
    L6_2 = L6_2.format
    L8_2 = L27_1
    L9_2 = #A0_2
    L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2 = L8_2(L9_2)
    L6_2 = L6_2(L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2)
    L7_2 = A0_2
    L4_2, L5_2 = L4_2(L5_2, L6_2, L7_2)
    if L4_2 then
      L6_2 = type
      L7_2 = L5_2
      L6_2 = L6_2(L7_2)
      if "table" == L6_2 then
        L6_2 = L22_1
        L6_2 = L6_2()
        L7_2 = ipairs
        L8_2 = L5_2
        L7_2, L8_2, L9_2, L10_2 = L7_2(L8_2)
        for L11_2, L12_2 in L7_2, L8_2, L9_2, L10_2 do
          L13_2 = tonumber
          L14_2 = L12_2.n
          L13_2 = L13_2(L14_2)
          if not L13_2 then
            L13_2 = 0
          end
          if L6_2 <= L13_2 then
            L13_2 = tostring
            L14_2 = L12_2.member
            L13_2 = L13_2(L14_2)
            L13_2 = L3_2[L13_2]
            if not L13_2 then
              L13_2 = tostring
              L14_2 = L12_2.member
              L13_2 = L13_2(L14_2)
              L3_2[L13_2] = "limit"
            end
          end
        end
      end
    end
  end
  L4_2 = ipairs
  L5_2 = A0_2
  L4_2, L5_2, L6_2, L7_2 = L4_2(L5_2)
  for L8_2, L9_2 in L4_2, L5_2, L6_2, L7_2 do
    L10_2 = L3_2[L9_2]
    if not L10_2 then
      L10_2 = RecadoCanAddToGroup
      L11_2 = A2_2
      L12_2 = L9_2
      L10_2 = L10_2(L11_2, L12_2)
      if not L10_2 then
        L3_2[L9_2] = "privacy"
      end
    end
  end
  return L3_2
end
L88_1 = 60000
L89_1 = {}
L90_1 = 0
function L91_1(A0_2, A1_2, A2_2, A3_2)
  local L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2, L19_2, L20_2, L21_2, L22_2, L23_2, L24_2, L25_2, L26_2
  L4_2 = type
  L5_2 = NotifyCitizen
  L4_2 = L4_2(L5_2)
  if "function" ~= L4_2 then
    return
  end
  L4_2 = GetGameTimer
  L4_2 = L4_2()
  L5_2 = L90_1
  L6_2 = 2000
  if L5_2 > L6_2 then
    L5_2 = pairs
    L6_2 = L89_1
    L5_2, L6_2, L7_2, L8_2 = L5_2(L6_2)
    for L9_2, L10_2 in L5_2, L6_2, L7_2, L8_2 do
      L11_2 = L4_2 - L10_2
      L12_2 = L88_1
      if L11_2 >= L12_2 then
        L11_2 = L89_1
        L11_2[L9_2] = nil
        L11_2 = L90_1
        L11_2 = L11_2 - 1
        L90_1 = L11_2
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
    L15_2 = L89_1
    L15_2 = L15_2[L14_2]
    if L13_2 then
      L16_2 = L6_2[L13_2]
      if not L16_2 then
        if L15_2 then
          L16_2 = L4_2 - L15_2
          L17_2 = L88_1
          if L16_2 < L17_2 then
            goto lbl_71
          end
        end
        L6_2[L13_2] = true
        L16_2 = #L5_2
        L16_2 = L16_2 + 1
        L5_2[L16_2] = L13_2
        if not L15_2 then
          L16_2 = L90_1
          L16_2 = L16_2 + 1
          L90_1 = L16_2
        end
        L16_2 = L89_1
        L16_2[L14_2] = L4_2
      end
    end
    ::lbl_71::
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
  L13_2 = L27_1
  L14_2 = #L5_2
  L13_2, L14_2, L15_2, L16_2, L17_2, L18_2, L19_2, L20_2, L21_2, L22_2, L23_2, L24_2, L25_2, L26_2 = L13_2(L14_2)
  L11_2 = L11_2(L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2, L19_2, L20_2, L21_2, L22_2, L23_2, L24_2, L25_2, L26_2)
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
  L11_2 = L61_1
  L12_2 = A1_2
  L11_2 = L11_2(L12_2)
  if L11_2 then
    L12_2 = L11_2.exists
    if L12_2 then
      L12_2 = L11_2.name
      if "" ~= L12_2 then
        L12_2 = "~"
        L13_2 = L11_2.name
        L12_2 = L12_2 .. L13_2
        if L12_2 then
          goto lbl_143
        end
      end
    end
  end
  L12_2 = A1_2
  ::lbl_143::
  L13_2 = ipairs
  L14_2 = L5_2
  L13_2, L14_2, L15_2, L16_2 = L13_2(L14_2)
  for L17_2, L18_2 in L13_2, L14_2, L15_2, L16_2 do
    L19_2 = pcall
    L20_2 = NotifyCitizen
    L21_2 = L18_2
    L22_2 = L0_1
    L23_2 = A0_2.title
    L24_2 = L29_1
    L25_2 = L7_2[L18_2]
    if not L25_2 then
      L25_2 = L12_2
    end
    L26_2 = " adicionou-te ao grupo"
    L25_2 = L25_2 .. L26_2
    L26_2 = 255
    L24_2 = L24_2(L25_2, L26_2)
    L25_2 = {}
    L26_2 = A0_2.id
    L25_2.conversation = L26_2
    L26_2 = L0_1
    L25_2.app = L26_2
    L26_2 = A0_2.id
    L25_2.group = L26_2
    L19_2(L20_2, L21_2, L22_2, L23_2, L24_2, L25_2)
  end
end
function L92_1(A0_2, A1_2, A2_2, A3_2, A4_2)
  local L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2
  L5_2 = #A1_2
  if 0 == L5_2 then
    L5_2 = true
    return L5_2
  end
  L5_2 = {}
  L6_2 = {}
  L7_2 = ipairs
  L8_2 = A1_2
  L7_2, L8_2, L9_2, L10_2 = L7_2(L8_2)
  for L11_2, L12_2 in L7_2, L8_2, L9_2, L10_2 do
    L13_2 = #L5_2
    L13_2 = L13_2 + 1
    L5_2[L13_2] = "(?, ?, ?, ?, ?, NULL)"
    L13_2 = #L6_2
    L14_2 = L13_2 + 1
    L6_2[L14_2] = A0_2
    L14_2 = L13_2 + 2
    L6_2[L14_2] = L12_2
    L14_2 = L13_2 + 3
    L6_2[L14_2] = A2_2
    L14_2 = L13_2 + 4
    L6_2[L14_2] = A3_2
    L14_2 = L13_2 + 5
    L15_2 = A4_2 or L15_2
    if not A4_2 then
      L15_2 = 0
    end
    L6_2[L14_2] = L15_2
  end
  L7_2 = pcall
  L8_2 = MySQL
  L8_2 = L8_2.query
  L8_2 = L8_2.await
  L9_2 = "INSERT INTO apex_phone_conversation_members (conversation_id, member, role, joined, last_read_id, left_at) VALUES "
  L10_2 = table
  L10_2 = L10_2.concat
  L11_2 = L5_2
  L12_2 = ", "
  L10_2 = L10_2(L11_2, L12_2)
  L11_2 = " ON DUPLICATE KEY UPDATE role = VALUES(role), joined = VALUES(joined), last_read_id = VALUES(last_read_id), left_at = NULL"
  L9_2 = L9_2 .. L10_2 .. L11_2
  L10_2 = L6_2
  L7_2, L8_2 = L7_2(L8_2, L9_2, L10_2)
  L9_2 = L7_2 or L9_2
  L9_2 = L7_2 and nil ~= L8_2
  return L9_2
end
function L93_1(A0_2)
  local L1_2, L2_2, L3_2, L4_2, L5_2
  L1_2 = tonumber
  L2_2 = MySQL
  L2_2 = L2_2.scalar
  L2_2 = L2_2.await
  L3_2 = "SELECT COUNT(*) FROM apex_phone_conversation_members WHERE member = ? AND left_at IS NULL"
  L4_2 = {}
  L5_2 = A0_2
  L4_2[1] = L5_2
  L2_2, L3_2, L4_2, L5_2 = L2_2(L3_2, L4_2)
  L1_2 = L1_2(L2_2, L3_2, L4_2, L5_2)
  if not L1_2 then
    L1_2 = 0
  end
  return L1_2
end
L94_1 = {}
function L95_1(A0_2, A1_2, A2_2, A3_2, A4_2, A5_2, A6_2, A7_2, A8_2)
  local L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2, L19_2, L20_2, L21_2, L22_2, L23_2
  L9_2 = nil
  if nil ~= A4_2 then
    L10_2 = L84_1
    L11_2 = A0_2
    L12_2 = A4_2
    L10_2 = L10_2(L11_2, L12_2)
    L9_2 = L10_2
    if not L9_2 then
      L10_2 = L24_1
      L11_2 = "media"
      return L10_2(L11_2)
    end
  end
  L10_2 = L93_1
  L11_2 = A1_2
  L10_2 = L10_2(L11_2)
  L11_2 = L22_1
  L11_2 = L11_2()
  if L10_2 >= L11_2 then
    L10_2 = L24_1
    L11_2 = "limit"
    L12_2 = {}
    L13_2 = L22_1
    L13_2 = L13_2()
    L12_2.max = L13_2
    return L10_2(L11_2, L12_2)
  end
  L10_2 = L50_1
  L11_2 = A3_2
  L10_2 = L10_2(L11_2)
  L11_2 = {}
  L12_2 = ipairs
  L13_2 = A3_2
  L12_2, L13_2, L14_2, L15_2 = L12_2(L13_2)
  for L16_2, L17_2 in L12_2, L13_2, L14_2, L15_2 do
    L18_2 = L10_2[L17_2]
    if not L18_2 then
      L18_2 = #L11_2
      L18_2 = L18_2 + 1
      L11_2[L18_2] = L17_2
    end
  end
  L12_2 = #L11_2
  if L12_2 > 0 then
    L12_2 = L24_1
    L13_2 = "badnumber"
    L14_2 = {}
    L14_2.numbers = L11_2
    return L12_2(L13_2, L14_2)
  end
  L12_2 = L87_1
  L13_2 = A3_2
  L14_2 = L10_2
  L15_2 = A1_2
  L12_2 = L12_2(L13_2, L14_2, L15_2)
  L13_2 = {}
  L14_2 = {}
  L15_2 = {}
  L16_2 = ipairs
  L17_2 = A3_2
  L16_2, L17_2, L18_2, L19_2 = L16_2(L17_2)
  for L20_2, L21_2 in L16_2, L17_2, L18_2, L19_2 do
    L22_2 = L12_2[L21_2]
    if "privacy" == L22_2 then
      L22_2 = #L15_2
      L22_2 = L22_2 + 1
      L15_2[L22_2] = L21_2
    else
      L22_2 = L12_2[L21_2]
      if L22_2 then
        L22_2 = #L14_2
        L22_2 = L22_2 + 1
        L14_2[L22_2] = L21_2
      else
        L22_2 = #L13_2
        L22_2 = L22_2 + 1
        L13_2[L22_2] = L21_2
      end
    end
  end
  L16_2 = #L13_2
  if 0 == L16_2 then
    L16_2 = #L15_2
    if 0 == L16_2 then
      L16_2 = L24_1
      L17_2 = "members"
      L18_2 = {}
      L18_2.skipped = L14_2
      return L16_2(L17_2, L18_2)
    end
  end
  L16_2 = L28_1
  L16_2 = L16_2()
  L17_2 = L25_1
  L18_2 = L78_1
  L19_2 = "apex_phone_conversations"
  L20_2 = L80_1
  L21_2 = {}
  L22_2 = L0_1
  L21_2.app = L22_2
  L21_2.title = A2_2
  L21_2.avatar = L9_2
  L21_2.created_by = A1_2
  L21_2.created = L16_2
  L22_2 = A5_2 or L22_2
  if not A5_2 or "" == A5_2 or not A5_2 then
    L22_2 = nil
  end
  L21_2.description = L22_2
  L21_2.send_policy = A6_2
  L21_2.edit_policy = A7_2
  L21_2.theme = A8_2
  L21_2.kind = "group"
  L18_2, L19_2, L20_2, L21_2, L22_2, L23_2 = L18_2(L19_2, L20_2, L21_2)
  L17_2 = L17_2(L18_2, L19_2, L20_2, L21_2, L22_2, L23_2)
  if not L17_2 then
    L18_2 = L24_1
    L19_2 = "db"
    return L18_2(L19_2)
  end
  L18_2 = L92_1
  L19_2 = L17_2
  L20_2 = {}
  L21_2 = A1_2
  L20_2[1] = L21_2
  L21_2 = "admin"
  L22_2 = L16_2
  L23_2 = 0
  L18_2 = L18_2(L19_2, L20_2, L21_2, L22_2, L23_2)
  if L18_2 then
    L18_2 = L92_1
    L19_2 = L17_2
    L20_2 = L13_2
    L21_2 = "member"
    L22_2 = L16_2
    L23_2 = 0
    L18_2 = L18_2(L19_2, L20_2, L21_2, L22_2, L23_2)
    if L18_2 then
      goto lbl_190
    end
  end
  L18_2 = pcall
  L19_2 = MySQL
  L19_2 = L19_2.query
  L19_2 = L19_2.await
  L20_2 = "DELETE FROM apex_phone_conversation_members WHERE conversation_id = ?"
  L21_2 = {}
  L22_2 = L17_2
  L21_2[1] = L22_2
  L18_2(L19_2, L20_2, L21_2)
  L18_2 = pcall
  L19_2 = MySQL
  L19_2 = L19_2.query
  L19_2 = L19_2.await
  L20_2 = "DELETE FROM apex_phone_conversations WHERE id = ?"
  L21_2 = {}
  L22_2 = L17_2
  L21_2[1] = L22_2
  L18_2(L19_2, L20_2, L21_2)
  L18_2 = L24_1
  L19_2 = "db"
  do return L18_2(L19_2) end
  ::lbl_190::
  L18_2 = L72_1
  L19_2 = L17_2
  L18_2 = L18_2(L19_2)
  if not L18_2 then
    L18_2 = {}
    L18_2.id = L17_2
    L19_2 = L0_1
    L18_2.app = L19_2
    L18_2.title = A2_2
    L18_2.avatar = L9_2
    L18_2.created_by = A1_2
    L18_2.created = L16_2
    L18_2.send_policy = A6_2
    L18_2.edit_policy = A7_2
    L18_2.kind = "group"
  end
  L19_2 = L41_1
  L20_2 = L17_2
  function L21_2()
    local L0_3, L1_3, L2_3, L3_3, L4_3, L5_3, L6_3, L7_3
    L0_3 = L82_1
    L1_3 = L18_2
    L2_3 = A1_2
    L3_3 = "create"
    L4_3 = "%s criou o grupo \194\171%s\194\187"
    L5_3 = L4_3
    L4_3 = L4_3.format
    L6_3 = A1_2
    L7_3 = A2_2
    L4_3 = L4_3(L5_3, L6_3, L7_3)
    L5_3 = {}
    L6_3 = A2_2
    L5_3.title = L6_3
    L6_3 = L13_2
    L5_3.targets = L6_3
    L0_3(L1_3, L2_3, L3_3, L4_3, L5_3)
    L0_3 = L91_1
    L1_3 = L18_2
    L2_3 = A1_2
    L3_3 = L13_2
    L4_3 = L10_2
    L0_3(L1_3, L2_3, L3_3, L4_3)
    L0_3 = L83_1
    L1_3 = L18_2
    L2_3 = {}
    L2_3.action = "create"
    L3_3 = A1_2
    L2_3.by = L3_3
    L3_3 = A2_2
    L2_3.title = L3_3
    L0_3(L1_3, L2_3)
    L0_3 = Dbg
    L1_3 = "recado"
    L2_3 = "group %s \"%s\" created by %s with %s member(s)"
    L3_3 = L17_2
    L4_3 = A2_2
    L5_3 = A1_2
    L6_3 = L13_2
    L6_3 = #L6_3
    L0_3(L1_3, L2_3, L3_3, L4_3, L5_3, L6_3)
    L0_3 = L85_1
    L1_3 = A0_2
    L2_3 = L18_2
    L3_3 = A1_2
    L4_3 = {}
    L4_3.role = "admin"
    L0_3 = L0_3(L1_3, L2_3, L3_3, L4_3)
    L1_3 = L14_2
    L1_3 = #L1_3
    if L1_3 > 0 then
      L1_3 = L14_2
      L0_3.skipped = L1_3
    end
    L1_3 = L15_2
    L1_3 = #L1_3
    if L1_3 > 0 then
      L1_3 = L15_2
      L0_3.privacy = L1_3
    end
    L1_3 = L13_2
    L0_3.added = L1_3
    return L0_3
  end
  return L19_2(L20_2, L21_2)
end
L96_1 = L38_1
L97_1 = "recado.group.create"
function L98_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2, L19_2, L20_2, L21_2, L22_2, L23_2, L24_2, L25_2
  L2_2 = L36_1
  L3_2 = A0_2
  L2_2 = L2_2(L3_2)
  if not L2_2 then
    L3_2 = L24_1
    L4_2 = "noidentity"
    return L3_2(L4_2)
  end
  L3_2 = HasPhoneItem
  L4_2 = A0_2
  L3_2 = L3_2(L4_2)
  if not L3_2 then
    L3_2 = L24_1
    L4_2 = "nophone"
    return L3_2(L4_2)
  end
  L3_2 = L31_1
  L4_2 = A1_2.name
  L5_2 = L4_1
  L6_2 = false
  L3_2 = L3_2(L4_2, L5_2, L6_2)
  if not L3_2 or "" == L3_2 then
    L4_2 = L24_1
    L5_2 = "name"
    return L4_2(L5_2)
  end
  L4_2 = L86_1
  L5_2 = A1_2.members
  L6_2 = L2_2
  L4_2, L5_2, L6_2 = L4_2(L5_2, L6_2)
  if not L4_2 then
    L7_2 = L24_1
    L8_2 = L5_2
    L9_2 = L6_2
    return L7_2(L8_2, L9_2)
  end
  L7_2 = #L4_2
  if 0 == L7_2 then
    L7_2 = L24_1
    L8_2 = "members"
    return L7_2(L8_2)
  end
  L7_2 = L21_1
  L7_2 = L7_2()
  L8_2 = #L4_2
  L8_2 = L8_2 + 1
  if L7_2 < L8_2 then
    L8_2 = L24_1
    L9_2 = "toomany"
    L10_2 = {}
    L10_2.max = L7_2
    return L8_2(L9_2, L10_2)
  end
  L8_2 = nil
  L9_2 = A1_2.description
  if nil ~= L9_2 then
    L9_2 = L31_1
    L10_2 = A1_2.description
    L11_2 = L3_1
    L12_2 = true
    L9_2 = L9_2(L10_2, L11_2, L12_2)
    L8_2 = L9_2
    if not L8_2 then
      L9_2 = L24_1
      L10_2 = "text"
      return L9_2(L10_2)
    end
  end
  L9_2 = "all"
  L10_2 = "admins"
  L11_2 = A1_2.sendPolicy
  if nil ~= L11_2 then
    L11_2 = L34_1
    L12_2 = A1_2.sendPolicy
    L11_2 = L11_2(L12_2)
    L9_2 = L11_2
  end
  L11_2 = A1_2.editPolicy
  if nil ~= L11_2 then
    L11_2 = L34_1
    L12_2 = A1_2.editPolicy
    L11_2 = L11_2(L12_2)
    L10_2 = L11_2
  end
  if not L9_2 or not L10_2 then
    L11_2 = L24_1
    L12_2 = "invalid"
    return L11_2(L12_2)
  end
  L11_2 = nil
  L12_2 = A1_2.theme
  if nil ~= L12_2 then
    L12_2 = A1_2.theme
    if "" ~= L12_2 then
      L12_2 = A1_2.theme
      if false ~= L12_2 then
        L13_2 = A1_2.theme
        L12_2 = L10_1
        L12_2 = L12_2[L13_2]
        if not L12_2 then
          L12_2 = type
          L13_2 = A1_2.theme
          L12_2 = L12_2(L13_2)
          if "string" == L12_2 then
            L13_2 = A1_2.theme
            L12_2 = L9_1
            L12_2 = L12_2[L13_2]
            if L12_2 then
              goto lbl_133
            end
          end
          L12_2 = L24_1
          L13_2 = "invalid"
          do return L12_2(L13_2) end
          ::lbl_133::
          L11_2 = A1_2.theme
        end
      end
    end
  end
  L12_2 = A1_2.avatar
  L12_2 = nil == L12_2
  if not L12_2 then
    L13_2 = L25_1
    L14_2 = A1_2.avatar
    L13_2 = L13_2(L14_2)
    if not L13_2 then
      L13_2 = L24_1
      L14_2 = "media"
      return L13_2(L14_2)
    end
  end
  L13_2 = GetGameTimer
  L13_2 = L13_2()
  L14_2 = L94_1
  L14_2 = L14_2[A0_2]
  if L14_2 then
    L14_2 = L94_1
    L14_2 = L14_2[A0_2]
    L14_2 = L13_2 - L14_2
    L15_2 = L13_1
    if L14_2 < L15_2 then
      L14_2 = L24_1
      L15_2 = "cooldown"
      return L14_2(L15_2)
    end
  end
  L14_2 = L94_1
  L14_2 = L14_2[A0_2]
  L15_2 = L94_1
  L15_2[A0_2] = L13_2
  L15_2 = pcall
  L16_2 = L95_1
  L17_2 = A0_2
  L18_2 = L2_2
  L19_2 = L3_2
  L20_2 = L4_2
  if not L12_2 then
    L21_2 = A1_2.avatar
    if L21_2 then
      goto lbl_192
    end
  end
  L21_2 = nil
  ::lbl_192::
  L22_2 = L8_2
  L23_2 = L9_2
  L24_2 = L10_2
  L25_2 = L11_2
  L15_2, L16_2 = L15_2(L16_2, L17_2, L18_2, L19_2, L20_2, L21_2, L22_2, L23_2, L24_2, L25_2)
  if L15_2 then
    L17_2 = type
    L18_2 = L16_2
    L17_2 = L17_2(L18_2)
    if "table" == L17_2 then
      L17_2 = L16_2.ok
      if false == L17_2 then
        L17_2 = L16_2.error
        if "db" ~= L17_2 then
          L17_2 = L94_1
          L17_2 = L17_2[A0_2]
          if L17_2 == L13_2 then
            L17_2 = L94_1
            L17_2[A0_2] = L14_2
          end
        end
      end
    end
  end
  if not L15_2 then
    L17_2 = error
    L18_2 = L16_2
    L19_2 = 0
    L17_2(L18_2, L19_2)
  end
  return L16_2
end
L96_1(L97_1, L98_1)
L96_1 = L38_1
L97_1 = "recado.group.get"
function L98_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2
  L2_2 = L26_1
  L3_2 = A1_2.id
  L2_2 = L2_2(L3_2)
  if not L2_2 then
    L3_2 = L24_1
    L4_2 = "invalid"
    return L3_2(L4_2)
  end
  L3_2 = L77_1
  L4_2 = A0_2
  L5_2 = L2_2
  L6_2 = false
  L3_2, L4_2, L5_2, L6_2 = L3_2(L4_2, L5_2, L6_2)
  if not L3_2 then
    L7_2 = L24_1
    L8_2 = L6_2
    return L7_2(L8_2)
  end
  L7_2 = L85_1
  L8_2 = A0_2
  L9_2 = L3_2
  L10_2 = L4_2
  L11_2 = L5_2
  return L7_2(L8_2, L9_2, L10_2, L11_2)
end
L96_1(L97_1, L98_1)
L96_1 = L38_1
L97_1 = "recado.group.update"
function L98_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2
  L2_2 = L26_1
  L3_2 = A1_2.id
  L2_2 = L2_2(L3_2)
  if not L2_2 then
    L3_2 = L24_1
    L4_2 = "invalid"
    return L3_2(L4_2)
  end
  L3_2 = {}
  L4_2 = A1_2.name
  if nil ~= L4_2 then
    L4_2 = L31_1
    L5_2 = A1_2.name
    L6_2 = L4_1
    L7_2 = false
    L4_2 = L4_2(L5_2, L6_2, L7_2)
    if not L4_2 or "" == L4_2 then
      L5_2 = L24_1
      L6_2 = "name"
      return L5_2(L6_2)
    end
    L3_2.title = L4_2
  end
  L4_2 = A1_2.description
  if nil ~= L4_2 then
    L4_2 = L31_1
    L5_2 = A1_2.description
    L6_2 = L3_1
    L7_2 = true
    L4_2 = L4_2(L5_2, L6_2, L7_2)
    if not L4_2 then
      L5_2 = L24_1
      L6_2 = "text"
      return L5_2(L6_2)
    end
    L3_2.description = L4_2
  end
  L4_2 = A1_2.theme
  if nil ~= L4_2 then
    L4_2 = A1_2.theme
    if false ~= L4_2 then
      L4_2 = A1_2.theme
      if "" ~= L4_2 then
        L5_2 = A1_2.theme
        L4_2 = L10_1
        L4_2 = L4_2[L5_2]
        if not L4_2 then
          goto lbl_60
        end
      end
    end
    L3_2.theme = ""
    goto lbl_77
    ::lbl_60::
    L4_2 = type
    L5_2 = A1_2.theme
    L4_2 = L4_2(L5_2)
    if "string" == L4_2 then
      L5_2 = A1_2.theme
      L4_2 = L9_1
      L4_2 = L4_2[L5_2]
      if L4_2 then
        L4_2 = A1_2.theme
        L3_2.theme = L4_2
    end
    else
      L4_2 = L24_1
      L5_2 = "invalid"
      return L4_2(L5_2)
    end
  end
  ::lbl_77::
  L4_2 = A1_2.sendPolicy
  if nil ~= L4_2 then
    L4_2 = L34_1
    L5_2 = A1_2.sendPolicy
    L4_2 = L4_2(L5_2)
    L3_2.send = L4_2
    L4_2 = L3_2.send
    if not L4_2 then
      L4_2 = L24_1
      L5_2 = "invalid"
      return L4_2(L5_2)
    end
  end
  L4_2 = A1_2.editPolicy
  if nil ~= L4_2 then
    L4_2 = L34_1
    L5_2 = A1_2.editPolicy
    L4_2 = L4_2(L5_2)
    L3_2.edit = L4_2
    L4_2 = L3_2.edit
    if not L4_2 then
      L4_2 = L24_1
      L5_2 = "invalid"
      return L4_2(L5_2)
    end
  end
  L4_2 = A1_2.avatarMedia
  L4_2 = nil ~= L4_2
  L5_2 = A1_2.avatarMedia
  if nil ~= L5_2 and not L4_2 then
    L5_2 = A1_2.avatarMedia
    if L5_2 then
      goto lbl_128
    end
  end
  L5_2 = nil
  ::lbl_128::
  if nil ~= L5_2 then
    L6_2 = L25_1
    L7_2 = L5_2
    L6_2 = L6_2(L7_2)
    if not L6_2 then
      L6_2 = L24_1
      L7_2 = "media"
      return L6_2(L7_2)
    end
  end
  L6_2 = L41_1
  L7_2 = L2_2
  function L8_2()
    local L0_3, L1_3, L2_3, L3_3, L4_3, L5_3, L6_3, L7_3, L8_3, L9_3, L10_3, L11_3, L12_3, L13_3, L14_3, L15_3, L16_3, L17_3, L18_3
    L0_3 = L77_1
    L1_3 = A0_2
    L2_3 = L2_2
    L3_3 = false
    L0_3, L1_3, L2_3, L3_3 = L0_3(L1_3, L2_3, L3_3)
    if not L0_3 then
      L4_3 = L24_1
      L5_3 = L3_3
      return L4_3(L5_3)
    end
    L4_3 = L2_3.role
    L4_3 = "admin" == L4_3
    L5_3 = L3_2.title
    L5_3 = L3_2.description
    L5_3 = L3_2.theme
    L5_3 = L5_2
    L5_3 = nil ~= L5_3 or L5_3
    if L5_3 then
      L6_3 = L0_3.edit_policy
      if "admins" == L6_3 and not L4_3 then
        L6_3 = L24_1
        L7_3 = "noedit"
        return L6_3(L7_3)
      end
    end
    L6_3 = L3_2.send
    if not L6_3 then
      L6_3 = L3_2.edit
    end
    if L6_3 and not L4_3 then
      L6_3 = L24_1
      L7_3 = "notadmin"
      return L6_3(L7_3)
    end
    L6_3 = L0_3.kind
    if "announce" == L6_3 then
      L6_3 = L3_2.send
      if "all" ~= L6_3 then
        L6_3 = L3_2.edit
        if "all" ~= L6_3 then
          goto lbl_69
        end
      end
      L6_3 = L24_1
      L7_3 = "community"
      return L6_3(L7_3)
    end
    ::lbl_69::
    L6_3 = nil
    L7_3 = L5_2
    if nil ~= L7_3 then
      L7_3 = L84_1
      L8_3 = A0_2
      L9_3 = L5_2
      L7_3 = L7_3(L8_3, L9_3)
      L6_3 = L7_3
      if not L6_3 then
        L7_3 = L24_1
        L8_3 = "media"
        return L7_3(L8_3)
      end
    end
    L7_3 = {}
    L8_3 = {}
    L9_3 = {}
    L10_3 = L3_2.title
    if L10_3 then
      L10_3 = L3_2.title
      L11_3 = L0_3.title
      if L10_3 ~= L11_3 then
        L10_3 = #L7_3
        L10_3 = L10_3 + 1
        L7_3[L10_3] = "title = ?"
        L10_3 = #L8_3
        L10_3 = L10_3 + 1
        L11_3 = L3_2.title
        L8_3[L10_3] = L11_3
        L9_3.rename = true
      end
    end
    L10_3 = L3_2.description
    if nil ~= L10_3 then
      L10_3 = L3_2.description
      L11_3 = L0_3.description
      if not L11_3 then
        L11_3 = ""
      end
      if L10_3 ~= L11_3 then
        L10_3 = L3_2.description
        if "" == L10_3 then
          L10_3 = #L7_3
          L10_3 = L10_3 + 1
          L7_3[L10_3] = "description = NULL"
        else
          L10_3 = #L7_3
          L10_3 = L10_3 + 1
          L7_3[L10_3] = "description = ?"
          L10_3 = #L8_3
          L10_3 = L10_3 + 1
          L11_3 = L3_2.description
          L8_3[L10_3] = L11_3
        end
        L9_3.description = true
      end
    end
    L10_3 = L3_2.theme
    if nil ~= L10_3 then
      L10_3 = L3_2.theme
      L11_3 = L0_3.theme
      if not L11_3 then
        L11_3 = ""
      end
      if L10_3 ~= L11_3 then
        L10_3 = L3_2.theme
        if "" == L10_3 then
          L10_3 = #L7_3
          L10_3 = L10_3 + 1
          L7_3[L10_3] = "theme = NULL"
        else
          L10_3 = #L7_3
          L10_3 = L10_3 + 1
          L7_3[L10_3] = "theme = ?"
          L10_3 = #L8_3
          L10_3 = L10_3 + 1
          L11_3 = L3_2.theme
          L8_3[L10_3] = L11_3
        end
        L9_3.theme = true
      end
    end
    L10_3 = L3_2.send
    if L10_3 then
      L10_3 = L3_2.send
      L11_3 = L0_3.send_policy
      if L10_3 ~= L11_3 then
        L10_3 = #L7_3
        L10_3 = L10_3 + 1
        L7_3[L10_3] = "send_policy = ?"
        L10_3 = #L8_3
        L10_3 = L10_3 + 1
        L11_3 = L3_2.send
        L8_3[L10_3] = L11_3
        L9_3.send = true
      end
    end
    L10_3 = L3_2.edit
    if L10_3 then
      L10_3 = L3_2.edit
      L11_3 = L0_3.edit_policy
      if L10_3 ~= L11_3 then
        L10_3 = #L7_3
        L10_3 = L10_3 + 1
        L7_3[L10_3] = "edit_policy = ?"
        L10_3 = #L8_3
        L10_3 = L10_3 + 1
        L11_3 = L3_2.edit
        L8_3[L10_3] = L11_3
        L9_3.edit = true
      end
    end
    if L6_3 then
      L10_3 = L0_3.avatar
      if L6_3 ~= L10_3 then
        L10_3 = #L7_3
        L10_3 = L10_3 + 1
        L7_3[L10_3] = "avatar = ?"
        L10_3 = #L8_3
        L10_3 = L10_3 + 1
        L8_3[L10_3] = L6_3
        L9_3.avatar = true
    end
    else
      L10_3 = L4_2
      if L10_3 then
        L10_3 = L0_3.avatar
        if L10_3 then
          L10_3 = #L7_3
          L10_3 = L10_3 + 1
          L7_3[L10_3] = "avatar = NULL"
          L9_3.avatar = true
        end
      end
    end
    L10_3 = #L7_3
    if L10_3 > 0 then
      L10_3 = #L8_3
      L10_3 = L10_3 + 1
      L11_3 = L2_2
      L8_3[L10_3] = L11_3
      L10_3 = MySQL
      L10_3 = L10_3.update
      L10_3 = L10_3.await
      L11_3 = "UPDATE apex_phone_conversations SET %s WHERE id = ?"
      L12_3 = L11_3
      L11_3 = L11_3.format
      L13_3 = table
      L13_3 = L13_3.concat
      L14_3 = L7_3
      L15_3 = ", "
      L13_3, L14_3, L15_3, L16_3, L17_3, L18_3 = L13_3(L14_3, L15_3)
      L11_3 = L11_3(L12_3, L13_3, L14_3, L15_3, L16_3, L17_3, L18_3)
      L12_3 = L8_3
      L10_3(L11_3, L12_3)
      L10_3 = L72_1
      L11_3 = L2_2
      L10_3 = L10_3(L11_3)
      if not L10_3 then
        L10_3 = L0_3
      end
      L11_3 = L9_3.rename
      if L11_3 then
        L11_3 = L82_1
        L12_3 = L10_3
        L13_3 = L1_3
        L14_3 = "rename"
        L15_3 = "%s mudou o nome do grupo para \194\171%s\194\187"
        L16_3 = L15_3
        L15_3 = L15_3.format
        L17_3 = L1_3
        L18_3 = L10_3.title
        L15_3 = L15_3(L16_3, L17_3, L18_3)
        L16_3 = {}
        L17_3 = L10_3.title
        L16_3.title = L17_3
        L11_3(L12_3, L13_3, L14_3, L15_3, L16_3)
        L11_3 = L83_1
        L12_3 = L10_3
        L13_3 = {}
        L13_3.action = "rename"
        L13_3.by = L1_3
        L14_3 = L10_3.title
        L13_3.title = L14_3
        L11_3(L12_3, L13_3)
      end
      L11_3 = L9_3.avatar
      if L11_3 then
        L11_3 = L82_1
        L12_3 = L10_3
        L13_3 = L1_3
        L14_3 = "avatar"
        L15_3 = L10_3.avatar
        if L15_3 then
          L15_3 = "%s mudou a imagem do grupo"
          if L15_3 then
            goto lbl_290
          end
        end
        L15_3 = "%s removeu a imagem do grupo"
        ::lbl_290::
        L16_3 = L15_3
        L15_3 = L15_3.format
        L17_3 = L1_3
        L15_3 = L15_3(L16_3, L17_3)
        L16_3 = {}
        L17_3 = L10_3.avatar
        L16_3.avatar = L17_3
        L11_3(L12_3, L13_3, L14_3, L15_3, L16_3)
        L11_3 = L83_1
        L12_3 = L10_3
        L13_3 = {}
        L13_3.action = "avatar"
        L13_3.by = L1_3
        L14_3 = L10_3.avatar
        L13_3.avatar = L14_3
        L11_3(L12_3, L13_3)
      end
      L11_3 = {}
      L12_3 = L9_3.description
      if L12_3 then
        L12_3 = #L11_3
        L12_3 = L12_3 + 1
        L11_3[L12_3] = "description"
        L12_3 = L82_1
        L13_3 = L10_3
        L14_3 = L1_3
        L15_3 = "description"
        L16_3 = L10_3.description
        if L16_3 then
          L16_3 = L10_3.description
          if "" ~= L16_3 then
            L16_3 = "%s mudou a descri\195\167\195\163o do grupo"
            if L16_3 then
              goto lbl_330
            end
          end
        end
        L16_3 = "%s removeu a descri\195\167\195\163o do grupo"
        ::lbl_330::
        L17_3 = L16_3
        L16_3 = L16_3.format
        L18_3 = L1_3
        L16_3, L17_3, L18_3 = L16_3(L17_3, L18_3)
        L12_3(L13_3, L14_3, L15_3, L16_3, L17_3, L18_3)
      end
      L12_3 = L9_3.theme
      if L12_3 then
        L12_3 = #L11_3
        L12_3 = L12_3 + 1
        L11_3[L12_3] = "theme"
        L12_3 = L82_1
        L13_3 = L10_3
        L14_3 = L1_3
        L15_3 = "theme"
        L16_3 = "%s mudou o tema da conversa"
        L17_3 = L16_3
        L16_3 = L16_3.format
        L18_3 = L1_3
        L16_3 = L16_3(L17_3, L18_3)
        L17_3 = {}
        L18_3 = L10_3.theme
        L17_3.theme = L18_3
        L12_3(L13_3, L14_3, L15_3, L16_3, L17_3)
      end
      L12_3 = L9_3.send
      if L12_3 then
        L12_3 = #L11_3
        L12_3 = L12_3 + 1
        L11_3[L12_3] = "sendPolicy"
        L12_3 = L82_1
        L13_3 = L10_3
        L14_3 = L1_3
        L15_3 = "sendPolicy"
        L16_3 = L10_3.send_policy
        if "admins" == L16_3 then
          L16_3 = "%s alterou as defini\195\167\195\181es: s\195\179 os administradores podem enviar mensagens"
          L17_3 = L16_3
          L16_3 = L16_3.format
          L18_3 = L1_3
          L16_3 = L16_3(L17_3, L18_3)
          if L16_3 then
            goto lbl_378
          end
        end
        L16_3 = "%s alterou as defini\195\167\195\181es: todos os membros podem enviar mensagens"
        L17_3 = L16_3
        L16_3 = L16_3.format
        L18_3 = L1_3
        L16_3 = L16_3(L17_3, L18_3)
        ::lbl_378::
        L17_3 = {}
        L18_3 = L10_3.send_policy
        L17_3.sendPolicy = L18_3
        L12_3(L13_3, L14_3, L15_3, L16_3, L17_3)
      end
      L12_3 = L9_3.edit
      if L12_3 then
        L12_3 = #L11_3
        L12_3 = L12_3 + 1
        L11_3[L12_3] = "editPolicy"
        L12_3 = L82_1
        L13_3 = L10_3
        L14_3 = L1_3
        L15_3 = "editPolicy"
        L16_3 = L10_3.edit_policy
        if "admins" == L16_3 then
          L16_3 = "%s alterou as defini\195\167\195\181es: s\195\179 os administradores podem editar as informa\195\167\195\181es do grupo"
          L17_3 = L16_3
          L16_3 = L16_3.format
          L18_3 = L1_3
          L16_3 = L16_3(L17_3, L18_3)
          if L16_3 then
            goto lbl_407
          end
        end
        L16_3 = "%s alterou as defini\195\167\195\181es: todos os membros podem editar as informa\195\167\195\181es do grupo"
        L17_3 = L16_3
        L16_3 = L16_3.format
        L18_3 = L1_3
        L16_3 = L16_3(L17_3, L18_3)
        ::lbl_407::
        L17_3 = {}
        L18_3 = L10_3.edit_policy
        L17_3.editPolicy = L18_3
        L12_3(L13_3, L14_3, L15_3, L16_3, L17_3)
      end
      L12_3 = #L11_3
      if L12_3 > 0 then
        L12_3 = L83_1
        L13_3 = L10_3
        L14_3 = {}
        L14_3.action = "settings"
        L14_3.by = L1_3
        L14_3.changes = L11_3
        L15_3 = L10_3.theme
        L14_3.theme = L15_3
        L15_3 = L10_3.send_policy
        L14_3.sendPolicy = L15_3
        L15_3 = L10_3.edit_policy
        L14_3.editPolicy = L15_3
        L12_3(L13_3, L14_3)
      end
      L0_3 = L10_3
    end
    L10_3 = L85_1
    L11_3 = A0_2
    L12_3 = L0_3
    L13_3 = L1_3
    L14_3 = L2_3
    return L10_3(L11_3, L12_3, L13_3, L14_3)
  end
  return L6_2(L7_2, L8_2)
end
L96_1(L97_1, L98_1)
L96_1 = L38_1
L97_1 = "recado.group.add"
function L98_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2, L6_2
  L2_2 = L26_1
  L3_2 = A1_2.id
  L2_2 = L2_2(L3_2)
  if not L2_2 then
    L3_2 = L24_1
    L4_2 = "invalid"
    return L3_2(L4_2)
  end
  L3_2 = HasPhoneItem
  L4_2 = A0_2
  L3_2 = L3_2(L4_2)
  if not L3_2 then
    L3_2 = L24_1
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
  L4_2 = L41_1
  L5_2 = L2_2
  function L6_2()
    local L0_3, L1_3, L2_3, L3_3, L4_3, L5_3, L6_3, L7_3, L8_3, L9_3, L10_3, L11_3, L12_3, L13_3, L14_3, L15_3, L16_3, L17_3, L18_3, L19_3, L20_3, L21_3, L22_3, L23_3, L24_3, L25_3, L26_3, L27_3
    L0_3 = L77_1
    L1_3 = A0_2
    L2_3 = L2_2
    L3_3 = true
    L0_3, L1_3, L2_3, L3_3 = L0_3(L1_3, L2_3, L3_3)
    if not L0_3 then
      L4_3 = L24_1
      L5_3 = L3_3
      return L4_3(L5_3)
    end
    L4_3 = L0_3.kind
    if "announce" == L4_3 then
      L4_3 = L24_1
      L5_3 = "community"
      return L4_3(L5_3)
    end
    L4_3 = L86_1
    L5_3 = L3_2
    L6_3 = L1_3
    L4_3, L5_3, L6_3 = L4_3(L5_3, L6_3)
    if not L4_3 then
      L7_3 = L24_1
      L8_3 = L5_3
      L9_3 = L6_3
      return L7_3(L8_3, L9_3)
    end
    L7_3 = #L4_3
    if 0 == L7_3 then
      L7_3 = L24_1
      L8_3 = "members"
      return L7_3(L8_3)
    end
    L7_3 = {}
    L8_3 = L74_1
    L9_3 = L2_2
    L8_3 = L8_3(L9_3)
    L9_3 = ipairs
    L10_3 = L8_3
    L9_3, L10_3, L11_3, L12_3 = L9_3(L10_3)
    for L13_3, L14_3 in L9_3, L10_3, L11_3, L12_3 do
      L15_3 = L14_3.member
      L7_3[L15_3] = true
    end
    L9_3 = {}
    L10_3 = {}
    L11_3 = ipairs
    L12_3 = L4_3
    L11_3, L12_3, L13_3, L14_3 = L11_3(L12_3)
    for L15_3, L16_3 in L11_3, L12_3, L13_3, L14_3 do
      L17_3 = L7_3[L16_3]
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
      L11_3 = L85_1
      L12_3 = A0_2
      L13_3 = L0_3
      L14_3 = L1_3
      L15_3 = L2_3
      L11_3 = L11_3(L12_3, L13_3, L14_3, L15_3)
      L12_3 = {}
      L11_3.already = L10_3
      L11_3.added = L12_3
      return L11_3
    end
    L11_3 = L21_1
    L11_3 = L11_3()
    L12_3 = #L8_3
    L13_3 = #L9_3
    L12_3 = L12_3 + L13_3
    if L11_3 < L12_3 then
      L12_3 = L24_1
      L13_3 = "toomany"
      L14_3 = {}
      L14_3.max = L11_3
      return L12_3(L13_3, L14_3)
    end
    L12_3 = L50_1
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
      L14_3 = L24_1
      L15_3 = "badnumber"
      L16_3 = {}
      L16_3.numbers = L13_3
      return L14_3(L15_3, L16_3)
    end
    L14_3 = L87_1
    L15_3 = L9_3
    L16_3 = L12_3
    L17_3 = L1_3
    L14_3 = L14_3(L15_3, L16_3, L17_3)
    L15_3 = {}
    L16_3 = {}
    L17_3 = {}
    L18_3 = ipairs
    L19_3 = L9_3
    L18_3, L19_3, L20_3, L21_3 = L18_3(L19_3)
    for L22_3, L23_3 in L18_3, L19_3, L20_3, L21_3 do
      L24_3 = L14_3[L23_3]
      if "privacy" == L24_3 then
        L24_3 = #L17_3
        L24_3 = L24_3 + 1
        L17_3[L24_3] = L23_3
      else
        L24_3 = L14_3[L23_3]
        if L24_3 then
          L24_3 = #L16_3
          L24_3 = L24_3 + 1
          L16_3[L24_3] = L23_3
        else
          L24_3 = #L15_3
          L24_3 = L24_3 + 1
          L15_3[L24_3] = L23_3
        end
      end
    end
    L18_3 = #L15_3
    if 0 == L18_3 then
      L18_3 = L24_1
      L19_3 = "members"
      L20_3 = {}
      L20_3.skipped = L16_3
      L20_3.privacy = L17_3
      return L18_3(L19_3, L20_3)
    end
    L18_3 = L92_1
    L19_3 = L2_2
    L20_3 = L15_3
    L21_3 = "member"
    L22_3 = L28_1
    L22_3 = L22_3()
    L23_3 = L0_3.last_id
    if not L23_3 then
      L23_3 = 0
    end
    L18_3 = L18_3(L19_3, L20_3, L21_3, L22_3, L23_3)
    if not L18_3 then
      L18_3 = L24_1
      L19_3 = "db"
      return L18_3(L19_3)
    end
    L18_3 = L82_1
    L19_3 = L0_3
    L20_3 = L1_3
    L21_3 = "add"
    L22_3 = "%s adicionou %s"
    L23_3 = L22_3
    L22_3 = L22_3.format
    L24_3 = L1_3
    L25_3 = table
    L25_3 = L25_3.concat
    L26_3 = L15_3
    L27_3 = ", "
    L25_3, L26_3, L27_3 = L25_3(L26_3, L27_3)
    L22_3 = L22_3(L23_3, L24_3, L25_3, L26_3, L27_3)
    L23_3 = {}
    L23_3.targets = L15_3
    L18_3(L19_3, L20_3, L21_3, L22_3, L23_3)
    L18_3 = L91_1
    L19_3 = L0_3
    L20_3 = L1_3
    L21_3 = L15_3
    L22_3 = L12_3
    L18_3(L19_3, L20_3, L21_3, L22_3)
    L18_3 = L83_1
    L19_3 = L0_3
    L20_3 = {}
    L20_3.action = "add"
    L20_3.by = L1_3
    L20_3.targets = L15_3
    L18_3(L19_3, L20_3)
    L18_3 = L85_1
    L19_3 = A0_2
    L20_3 = L0_3
    L21_3 = L1_3
    L22_3 = L2_3
    L18_3 = L18_3(L19_3, L20_3, L21_3, L22_3)
    L18_3.added = L15_3
    L19_3 = #L16_3
    if L19_3 > 0 then
      L18_3.skipped = L16_3
    end
    L19_3 = #L17_3
    if L19_3 > 0 then
      L18_3.privacy = L17_3
    end
    L19_3 = #L10_3
    if L19_3 > 0 then
      L18_3.already = L10_3
    end
    return L18_3
  end
  return L4_2(L5_2, L6_2)
end
L96_1(L97_1, L98_1)
function L96_1(A0_2)
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
  L2_2 = pcall
  L3_2 = MySQL
  L3_2 = L3_2.query
  L3_2 = L3_2.await
  L4_2 = "DELETE s FROM apex_phone_recado_stars s JOIN apex_phone_messages m ON m.id = s.message_id WHERE m.conversation_id = ?"
  L5_2 = {}
  L6_2 = L1_2
  L5_2[1] = L6_2
  L2_2(L3_2, L4_2, L5_2)
  L2_2 = pcall
  L3_2 = MySQL
  L3_2 = L3_2.query
  L3_2 = L3_2.await
  L4_2 = "DELETE p FROM apex_phone_recado_pins p JOIN apex_phone_messages m ON m.id = p.message_id WHERE m.conversation_id = ?"
  L5_2 = {}
  L6_2 = L1_2
  L5_2[1] = L6_2
  L2_2(L3_2, L4_2, L5_2)
  L2_2 = pcall
  L3_2 = MySQL
  L3_2 = L3_2.query
  L3_2 = L3_2.await
  L4_2 = "DELETE v FROM apex_phone_recado_views v JOIN apex_phone_messages m ON m.id = v.message_id WHERE m.conversation_id = ?"
  L5_2 = {}
  L6_2 = L1_2
  L5_2[1] = L6_2
  L2_2(L3_2, L4_2, L5_2)
  L2_2 = pcall
  L3_2 = MySQL
  L3_2 = L3_2.query
  L3_2 = L3_2.await
  L4_2 = "DELETE v FROM apex_phone_recado_poll_votes v JOIN apex_phone_recado_polls p ON p.id = v.poll_id WHERE p.conversation_id = ?"
  L5_2 = {}
  L6_2 = L1_2
  L5_2[1] = L6_2
  L2_2(L3_2, L4_2, L5_2)
  L2_2 = pcall
  L3_2 = MySQL
  L3_2 = L3_2.query
  L3_2 = L3_2.await
  L4_2 = "DELETE FROM apex_phone_recado_polls WHERE conversation_id = ?"
  L5_2 = {}
  L6_2 = L1_2
  L5_2[1] = L6_2
  L2_2(L3_2, L4_2, L5_2)
  L2_2 = pcall
  L3_2 = MySQL
  L3_2 = L3_2.query
  L3_2 = L3_2.await
  L4_2 = "DELETE r FROM apex_phone_recado_rsvp r JOIN apex_phone_recado_events e ON e.id = r.event_id WHERE e.conversation_id = ?"
  L5_2 = {}
  L6_2 = L1_2
  L5_2[1] = L6_2
  L2_2(L3_2, L4_2, L5_2)
  L2_2 = pcall
  L3_2 = MySQL
  L3_2 = L3_2.query
  L3_2 = L3_2.await
  L4_2 = "DELETE FROM apex_phone_recado_events WHERE conversation_id = ?"
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
  L2_2 = L75_1
  L2_2[L1_2] = nil
  L2_2 = Dbg
  L3_2 = "recado"
  L4_2 = "group %s deleted (no members left)"
  L5_2 = L1_2
  L2_2(L3_2, L4_2, L5_2)
end
function L97_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2
  L2_2 = A0_2.id
  L3_2 = MySQL
  L3_2 = L3_2.update
  L3_2 = L3_2.await
  L4_2 = "UPDATE apex_phone_conversation_members SET left_at = ?, role = 'member' WHERE conversation_id = ? AND member = ? AND left_at IS NULL"
  L5_2 = {}
  L6_2 = L28_1
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
    L5_2 = L46_1
    L5_2 = L5_2()
    L5_2 = L5_2[A1_2]
    L3_2(L4_2, L5_2)
  end
  L3_2 = L74_1
  L4_2 = L2_2
  L3_2 = L3_2(L4_2)
  L4_2 = #L3_2
  if 0 == L4_2 then
    L4_2 = L96_1
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
  L6_2 = L82_1
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
    L6_2 = L82_1
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
  L6_2 = L83_1
  L7_2 = A0_2
  L8_2 = {}
  L8_2.action = "leave"
  L8_2.by = A1_2
  L8_2.admin = L5_2
  L6_2(L7_2, L8_2)
  L6_2 = {}
  L6_2.ok = true
  L6_2.id = L2_2
  L6_2.deleted = false
  L6_2.admin = L5_2
  return L6_2
end
L98_1 = L38_1
L99_1 = "recado.group.leave"
function L100_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2
  L2_2 = L26_1
  L3_2 = A1_2.id
  L2_2 = L2_2(L3_2)
  if not L2_2 then
    L3_2 = L24_1
    L4_2 = "invalid"
    return L3_2(L4_2)
  end
  L3_2 = L41_1
  L4_2 = L2_2
  function L5_2()
    local L0_3, L1_3, L2_3, L3_3, L4_3, L5_3, L6_3
    L0_3 = L77_1
    L1_3 = A0_2
    L2_3 = L2_2
    L3_3 = false
    L0_3, L1_3, L2_3, L3_3 = L0_3(L1_3, L2_3, L3_3)
    if not L0_3 then
      L4_3 = L24_1
      L5_3 = L3_3
      return L4_3(L5_3)
    end
    L4_3 = L0_3.kind
    if "announce" == L4_3 then
      L4_3 = L24_1
      L5_3 = "community"
      return L4_3(L5_3)
    end
    L4_3 = L97_1
    L5_3 = L0_3
    L6_3 = L1_3
    return L4_3(L5_3, L6_3)
  end
  return L3_2(L4_2, L5_2)
end
L98_1(L99_1, L100_1)
L98_1 = L38_1
L99_1 = "recado.group.member"
function L100_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2, L6_2, L7_2
  L2_2 = L26_1
  L3_2 = A1_2.id
  L2_2 = L2_2(L3_2)
  if not L2_2 then
    L3_2 = L24_1
    L4_2 = "invalid"
    return L3_2(L4_2)
  end
  L3_2 = L32_1
  L4_2 = A1_2.number
  L3_2 = L3_2(L4_2)
  L4_2 = A1_2.action
  if not L3_2 or "promote" ~= L4_2 and "demote" ~= L4_2 and "remove" ~= L4_2 then
    L5_2 = L24_1
    L6_2 = "invalid"
    return L5_2(L6_2)
  end
  L5_2 = L41_1
  L6_2 = L2_2
  function L7_2()
    local L0_3, L1_3, L2_3, L3_3, L4_3, L5_3, L6_3, L7_3, L8_3, L9_3, L10_3, L11_3, L12_3, L13_3, L14_3
    L0_3 = L77_1
    L1_3 = A0_2
    L2_3 = L2_2
    L3_3 = true
    L0_3, L1_3, L2_3, L3_3 = L0_3(L1_3, L2_3, L3_3)
    if not L0_3 then
      L4_3 = L24_1
      L5_3 = L3_3
      return L4_3(L5_3)
    end
    L4_3 = L73_1
    L5_3 = L2_2
    L6_3 = L3_2
    L4_3 = L4_3(L5_3, L6_3)
    if not L4_3 then
      L5_3 = L24_1
      L6_3 = "notmember"
      return L5_3(L6_3)
    end
    L5_3 = L4_2
    if "remove" == L5_3 then
      L5_3 = L3_2
      if L5_3 == L1_3 then
        L5_3 = L24_1
        L6_3 = "self"
        return L5_3(L6_3)
      end
      L5_3 = L0_3.kind
      if "announce" == L5_3 then
        L5_3 = L24_1
        L6_3 = "community"
        return L5_3(L6_3)
      end
      L5_3 = MySQL
      L5_3 = L5_3.update
      L5_3 = L5_3.await
      L6_3 = "UPDATE apex_phone_conversation_members SET left_at = ?, role = 'member' WHERE conversation_id = ? AND member = ? AND left_at IS NULL"
      L7_3 = {}
      L8_3 = L28_1
      L8_3 = L8_3()
      L9_3 = L2_2
      L10_3 = L3_2
      L7_3[1] = L8_3
      L7_3[2] = L9_3
      L7_3[3] = L10_3
      L5_3(L6_3, L7_3)
      L5_3 = pcall
      L6_3 = MySQL
      L6_3 = L6_3.query
      L6_3 = L6_3.await
      L7_3 = "DELETE FROM apex_phone_thread_meta WHERE owner = ? AND app = ? AND other = ?"
      L8_3 = {}
      L9_3 = L3_2
      L10_3 = L0_3.app
      L11_3 = "g:"
      L12_3 = L2_2
      L11_3 = L11_3 .. L12_3
      L8_3[1] = L9_3
      L8_3[2] = L10_3
      L8_3[3] = L11_3
      L5_3(L6_3, L7_3, L8_3)
      L5_3 = L82_1
      L6_3 = L0_3
      L7_3 = L1_3
      L8_3 = "remove"
      L9_3 = "%s removeu %s"
      L10_3 = L9_3
      L9_3 = L9_3.format
      L11_3 = L1_3
      L12_3 = L3_2
      L9_3 = L9_3(L10_3, L11_3, L12_3)
      L10_3 = {}
      L11_3 = {}
      L12_3 = L3_2
      L11_3[1] = L12_3
      L10_3.targets = L11_3
      L5_3(L6_3, L7_3, L8_3, L9_3, L10_3)
      L5_3 = L83_1
      L6_3 = L0_3
      L7_3 = {}
      L7_3.action = "remove"
      L7_3.by = L1_3
      L8_3 = {}
      L9_3 = L3_2
      L8_3[1] = L9_3
      L7_3.targets = L8_3
      L5_3(L6_3, L7_3)
      L5_3 = L46_1
      L5_3 = L5_3()
      L6_3 = L3_2
      L5_3 = L5_3[L6_3]
      if L5_3 then
        L6_3 = Push
        L7_3 = L5_3
        L8_3 = "groupUpdate"
        L9_3 = {}
        L10_3 = L2_2
        L9_3.id = L10_3
        L9_3.action = "remove"
        L9_3.by = L1_3
        L10_3 = {}
        L11_3 = L3_2
        L10_3[1] = L11_3
        L9_3.targets = L10_3
        L9_3.removed = true
        L6_3(L7_3, L8_3, L9_3)
        L6_3 = type
        L7_3 = MediaRevoke
        L6_3 = L6_3(L7_3)
        if "function" == L6_3 then
          L6_3 = pcall
          L7_3 = MediaRevoke
          L8_3 = L5_3
          L6_3(L7_3, L8_3)
        end
      end
    else
      L5_3 = L4_2
      if "promote" == L5_3 then
        L5_3 = "admin"
        if L5_3 then
          goto lbl_133
        end
      end
      L5_3 = "member"
      ::lbl_133::
      L6_3 = L4_3.role
      if L6_3 ~= L5_3 then
        if "member" == L5_3 then
          L6_3 = tonumber
          L7_3 = MySQL
          L7_3 = L7_3.scalar
          L7_3 = L7_3.await
          L8_3 = "SELECT COUNT(*) FROM apex_phone_conversation_members WHERE conversation_id = ? AND role = 'admin' AND left_at IS NULL"
          L9_3 = {}
          L10_3 = L2_2
          L9_3[1] = L10_3
          L7_3, L8_3, L9_3, L10_3, L11_3, L12_3, L13_3, L14_3 = L7_3(L8_3, L9_3)
          L6_3 = L6_3(L7_3, L8_3, L9_3, L10_3, L11_3, L12_3, L13_3, L14_3)
          if not L6_3 then
            L6_3 = 0
          end
          if L6_3 <= 1 then
            L7_3 = L24_1
            L8_3 = "lastadmin"
            return L7_3(L8_3)
          end
        end
        L6_3 = MySQL
        L6_3 = L6_3.update
        L6_3 = L6_3.await
        L7_3 = "UPDATE apex_phone_conversation_members SET role = ? WHERE conversation_id = ? AND member = ? AND left_at IS NULL"
        L8_3 = {}
        L9_3 = L5_3
        L10_3 = L2_2
        L11_3 = L3_2
        L8_3[1] = L9_3
        L8_3[2] = L10_3
        L8_3[3] = L11_3
        L6_3(L7_3, L8_3)
        L6_3 = nil
        if "admin" == L5_3 then
          L7_3 = "%s nomeou %s administrador"
          L8_3 = L7_3
          L7_3 = L7_3.format
          L9_3 = L1_3
          L10_3 = L3_2
          L7_3 = L7_3(L8_3, L9_3, L10_3)
          L6_3 = L7_3
        else
          L7_3 = L3_2
          if L7_3 == L1_3 then
            L7_3 = "%s deixou de ser administrador"
            L8_3 = L7_3
            L7_3 = L7_3.format
            L9_3 = L1_3
            L7_3 = L7_3(L8_3, L9_3)
            L6_3 = L7_3
          else
            L7_3 = "%s retirou a administra\195\167\195\163o a %s"
            L8_3 = L7_3
            L7_3 = L7_3.format
            L9_3 = L1_3
            L10_3 = L3_2
            L7_3 = L7_3(L8_3, L9_3, L10_3)
            L6_3 = L7_3
          end
        end
        L7_3 = L82_1
        L8_3 = L0_3
        L9_3 = L1_3
        L10_3 = "role"
        L11_3 = L6_3
        L12_3 = {}
        L13_3 = {}
        L14_3 = L3_2
        L13_3[1] = L14_3
        L12_3.targets = L13_3
        L12_3.role = L5_3
        L7_3(L8_3, L9_3, L10_3, L11_3, L12_3)
        L7_3 = L83_1
        L8_3 = L0_3
        L9_3 = {}
        L9_3.action = "role"
        L9_3.by = L1_3
        L10_3 = {}
        L11_3 = L3_2
        L10_3[1] = L11_3
        L9_3.targets = L10_3
        L9_3.role = L5_3
        L7_3(L8_3, L9_3)
        L7_3 = L3_2
        if L7_3 == L1_3 then
          L2_3.role = L5_3
        end
      end
    end
    L5_3 = L85_1
    L6_3 = A0_2
    L7_3 = L0_3
    L8_3 = L1_3
    L9_3 = L2_3
    return L5_3(L6_3, L7_3, L8_3, L9_3)
  end
  return L5_2(L6_2, L7_2)
end
L98_1(L99_1, L100_1)
function L98_1()
  local L0_2, L1_2, L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2
  L0_2 = {}
  L1_2 = 1
  L2_2 = L12_1
  L3_2 = 1
  for L4_2 = L1_2, L2_2, L3_2 do
    L5_2 = math
    L5_2 = L5_2.random
    L6_2 = 1
    L7_2 = L11_1
    L7_2 = #L7_2
    L5_2 = L5_2(L6_2, L7_2)
    L6_2 = L11_1
    L7_2 = L6_2
    L6_2 = L6_2.sub
    L8_2 = L5_2
    L9_2 = L5_2
    L6_2 = L6_2(L7_2, L8_2, L9_2)
    L0_2[L4_2] = L6_2
  end
  L1_2 = table
  L1_2 = L1_2.concat
  L2_2 = L0_2
  return L1_2(L2_2)
end
function L99_1(A0_2)
  local L1_2, L2_2, L3_2, L4_2, L5_2
  L1_2 = type
  L2_2 = A0_2
  L1_2 = L1_2(L2_2)
  if "string" == L1_2 then
    L1_2 = #A0_2
    if not (L1_2 > 120) then
      goto lbl_11
    end
  end
  L1_2 = nil
  do return L1_2 end
  ::lbl_11::
  L2_2 = A0_2
  L1_2 = A0_2.match
  L3_2 = "join/([%w%-]+)%s*$"
  L1_2 = L1_2(L2_2, L3_2)
  if not L1_2 then
    L1_2 = A0_2
  end
  L3_2 = L1_2
  L2_2 = L1_2.gsub
  L4_2 = "[%s%-]"
  L5_2 = ""
  L2_2 = L2_2(L3_2, L4_2, L5_2)
  L3_2 = L2_2
  L2_2 = L2_2.upper
  L2_2 = L2_2(L3_2)
  L1_2 = L2_2
  L2_2 = #L1_2
  if not (L2_2 < 6) then
    L2_2 = #L1_2
    if not (L2_2 > 12) then
      L3_2 = L1_2
      L2_2 = L1_2.match
      L4_2 = "^[A-Z0-9]+$"
      L2_2 = L2_2(L3_2, L4_2)
      if L2_2 then
        goto lbl_37
      end
    end
  end
  L2_2 = nil
  do return L2_2 end
  ::lbl_37::
  return L1_2
end
L100_1 = L38_1
L101_1 = "recado.group.invite"
function L102_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2, L6_2
  L2_2 = L26_1
  L3_2 = A1_2.id
  L2_2 = L2_2(L3_2)
  if not L2_2 then
    L3_2 = L24_1
    L4_2 = "invalid"
    return L3_2(L4_2)
  end
  L3_2 = A1_2.reset
  L3_2 = true == L3_2
  L4_2 = L41_1
  L5_2 = L2_2
  function L6_2()
    local L0_3, L1_3, L2_3, L3_3, L4_3, L5_3, L6_3, L7_3, L8_3, L9_3, L10_3, L11_3, L12_3, L13_3, L14_3, L15_3
    L0_3 = L77_1
    L1_3 = A0_2
    L2_3 = L2_2
    L3_3 = true
    L0_3, L1_3, L2_3, L3_3 = L0_3(L1_3, L2_3, L3_3)
    if not L0_3 then
      L4_3 = L24_1
      L5_3 = L3_3
      return L4_3(L5_3)
    end
    L4_3 = L0_3.kind
    if "announce" == L4_3 then
      L4_3 = L24_1
      L5_3 = "community"
      return L4_3(L5_3)
    end
    L4_3 = L0_3.invite_code
    L5_3 = L3_2
    if not (not L5_3 and L4_3) or "" == L4_3 then
      L4_3 = nil
      L5_3 = 1
      L6_3 = 8
      L7_3 = 1
      for L8_3 = L5_3, L6_3, L7_3 do
        L9_3 = L98_1
        L9_3 = L9_3()
        L10_3 = pcall
        L11_3 = MySQL
        L11_3 = L11_3.update
        L11_3 = L11_3.await
        L12_3 = "UPDATE apex_phone_conversations SET invite_code = ? WHERE id = ?"
        L13_3 = {}
        L14_3 = L9_3
        L15_3 = L2_2
        L13_3[1] = L14_3
        L13_3[2] = L15_3
        L10_3, L11_3 = L10_3(L11_3, L12_3, L13_3)
        if L10_3 then
          L12_3 = tonumber
          L13_3 = L11_3
          L12_3 = L12_3(L13_3)
          if not L12_3 then
            L12_3 = 0
          end
          if L12_3 >= 1 then
            L4_3 = L9_3
            break
          end
        end
      end
      if not L4_3 then
        L5_3 = L24_1
        L6_3 = "db"
        return L5_3(L6_3)
      end
      L5_3 = L3_2
      if L5_3 then
        L5_3 = L83_1
        L6_3 = L0_3
        L7_3 = {}
        L7_3.action = "invite"
        L7_3.by = L1_3
        L7_3.reset = true
        L5_3(L6_3, L7_3)
      end
    end
    L5_3 = {}
    L5_3.ok = true
    L6_3 = L2_2
    L5_3.id = L6_3
    L5_3.code = L4_3
    L6_3 = "phone://recado/join/"
    L7_3 = L4_3
    L6_3 = L6_3 .. L7_3
    L5_3.link = L6_3
    return L5_3
  end
  return L4_2(L5_2, L6_2)
end
L100_1(L101_1, L102_1)
L100_1 = {}
L101_1 = L38_1
L102_1 = "recado.group.join"
function L103_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2
  L2_2 = L36_1
  L3_2 = A0_2
  L2_2 = L2_2(L3_2)
  if not L2_2 then
    L3_2 = L24_1
    L4_2 = "noidentity"
    return L3_2(L4_2)
  end
  L3_2 = L100_1
  L3_2 = L3_2[A0_2]
  L4_2 = GetGameTimer
  L4_2 = L4_2()
  if L3_2 then
    L5_2 = L3_2.t
    L5_2 = L4_2 - L5_2
    L6_2 = L16_1
    if L5_2 > L6_2 then
      L3_2 = nil
      L5_2 = L100_1
      L5_2[A0_2] = nil
    end
  end
  if L3_2 then
    L5_2 = L3_2.n
    L6_2 = L15_1
    if L5_2 >= L6_2 then
      L5_2 = L24_1
      L6_2 = "cooldown"
      return L5_2(L6_2)
    end
  end
  L5_2 = L99_1
  L6_2 = A1_2.code
  L5_2 = L5_2(L6_2)
  L6_2 = nil
  if L5_2 then
    L7_2 = pcall
    L8_2 = MySQL
    L8_2 = L8_2.single
    L8_2 = L8_2.await
    L9_2 = "SELECT id FROM apex_phone_conversations WHERE invite_code = ? AND app = ?"
    L10_2 = {}
    L11_2 = L5_2
    L12_2 = L0_1
    L10_2[1] = L11_2
    L10_2[2] = L12_2
    L7_2, L8_2 = L7_2(L8_2, L9_2, L10_2)
    if not L7_2 then
      L9_2 = L24_1
      L10_2 = "db"
      return L9_2(L10_2)
    end
    L6_2 = L8_2
  end
  if not L6_2 then
    L7_2 = L100_1
    L7_2 = L7_2[A0_2]
    L3_2 = L7_2 or L3_2
    if not L7_2 then
      L7_2 = {}
      L7_2.n = 0
      L7_2.t = L4_2
      L3_2 = L7_2
    end
    L7_2 = L3_2.n
    L7_2 = L7_2 + 1
    L3_2.n = L7_2
    L7_2 = L100_1
    L7_2[A0_2] = L3_2
    L7_2 = L24_1
    L8_2 = "badcode"
    return L7_2(L8_2)
  end
  L7_2 = L25_1
  L8_2 = L6_2.id
  L7_2 = L7_2(L8_2)
  L8_2 = A1_2.preview
  if true == L8_2 then
    L8_2 = L72_1
    L9_2 = L7_2
    L8_2 = L8_2(L9_2)
    if not L8_2 then
      L9_2 = L24_1
      L10_2 = "badcode"
      return L9_2(L10_2)
    end
    L9_2 = L8_2.kind
    if "announce" == L9_2 then
      L9_2 = L24_1
      L10_2 = "community"
      return L9_2(L10_2)
    end
    L9_2 = tonumber
    L10_2 = MySQL
    L10_2 = L10_2.scalar
    L10_2 = L10_2.await
    L11_2 = "SELECT COUNT(*) FROM apex_phone_conversation_members WHERE conversation_id = ? AND left_at IS NULL"
    L12_2 = {}
    L13_2 = L7_2
    L12_2[1] = L13_2
    L10_2, L11_2, L12_2, L13_2 = L10_2(L11_2, L12_2)
    L9_2 = L9_2(L10_2, L11_2, L12_2, L13_2)
    if not L9_2 then
      L9_2 = 0
    end
    L10_2 = {}
    L10_2.ok = true
    L10_2.preview = true
    L10_2.id = L7_2
    L11_2 = L8_2.title
    L10_2.title = L11_2
    L11_2 = L8_2.description
    if not L11_2 then
      L11_2 = ""
    end
    L10_2.description = L11_2
    L11_2 = math
    L11_2 = L11_2.tointeger
    L12_2 = L9_2
    L11_2 = L11_2(L12_2)
    if not L11_2 then
      L11_2 = 0
    end
    L10_2.memberCount = L11_2
    L11_2 = L73_1
    L12_2 = L7_2
    L13_2 = L2_2
    L11_2 = L11_2(L12_2, L13_2)
    L11_2 = nil ~= L11_2
    L10_2.already = L11_2
    L11_2 = L21_1
    L11_2 = L11_2()
    L10_2.max = L11_2
    return L10_2
  end
  L8_2 = HasPhoneItem
  L9_2 = A0_2
  L8_2 = L8_2(L9_2)
  if not L8_2 then
    L8_2 = L24_1
    L9_2 = "nophone"
    return L8_2(L9_2)
  end
  L8_2 = L41_1
  L9_2 = L7_2
  function L10_2()
    local L0_3, L1_3, L2_3, L3_3, L4_3, L5_3, L6_3, L7_3, L8_3, L9_3, L10_3
    L0_3 = L72_1
    L1_3 = L7_2
    L0_3 = L0_3(L1_3)
    if L0_3 then
      L1_3 = L0_3.app
      L2_3 = L0_1
      if L1_3 == L2_3 then
        L1_3 = L0_3.invite_code
        L2_3 = L5_2
        if L1_3 == L2_3 then
          goto lbl_18
        end
      end
    end
    L1_3 = L24_1
    L2_3 = "badcode"
    do return L1_3(L2_3) end
    ::lbl_18::
    L1_3 = L0_3.kind
    if "announce" == L1_3 then
      L1_3 = L24_1
      L2_3 = "community"
      return L1_3(L2_3)
    end
    L1_3 = L73_1
    L2_3 = L7_2
    L3_3 = L2_2
    L1_3 = L1_3(L2_3, L3_3)
    if L1_3 then
      L2_3 = L85_1
      L3_3 = A0_2
      L4_3 = L0_3
      L5_3 = L2_2
      L6_3 = L1_3
      L2_3 = L2_3(L3_3, L4_3, L5_3, L6_3)
      L2_3.already = true
      return L2_3
    end
    L2_3 = tonumber
    L3_3 = MySQL
    L3_3 = L3_3.scalar
    L3_3 = L3_3.await
    L4_3 = "SELECT COUNT(*) FROM apex_phone_conversation_members WHERE conversation_id = ? AND left_at IS NULL"
    L5_3 = {}
    L6_3 = L7_2
    L5_3[1] = L6_3
    L3_3, L4_3, L5_3, L6_3, L7_3, L8_3, L9_3, L10_3 = L3_3(L4_3, L5_3)
    L2_3 = L2_3(L3_3, L4_3, L5_3, L6_3, L7_3, L8_3, L9_3, L10_3)
    if not L2_3 then
      L2_3 = 0
    end
    L3_3 = L21_1
    L3_3 = L3_3()
    if L2_3 >= L3_3 then
      L3_3 = L24_1
      L4_3 = "toomany"
      L5_3 = {}
      L6_3 = L21_1
      L6_3 = L6_3()
      L5_3.max = L6_3
      return L3_3(L4_3, L5_3)
    end
    L3_3 = L93_1
    L4_3 = L2_2
    L3_3 = L3_3(L4_3)
    L4_3 = L22_1
    L4_3 = L4_3()
    if L3_3 >= L4_3 then
      L3_3 = L24_1
      L4_3 = "limit"
      L5_3 = {}
      L6_3 = L22_1
      L6_3 = L6_3()
      L5_3.max = L6_3
      return L3_3(L4_3, L5_3)
    end
    L3_3 = L92_1
    L4_3 = L7_2
    L5_3 = {}
    L6_3 = L2_2
    L5_3[1] = L6_3
    L6_3 = "member"
    L7_3 = L28_1
    L7_3 = L7_3()
    L8_3 = L0_3.last_id
    if not L8_3 then
      L8_3 = 0
    end
    L3_3 = L3_3(L4_3, L5_3, L6_3, L7_3, L8_3)
    if not L3_3 then
      L3_3 = L24_1
      L4_3 = "db"
      return L3_3(L4_3)
    end
    L3_3 = L82_1
    L4_3 = L0_3
    L5_3 = L2_2
    L6_3 = "join"
    L7_3 = "%s entrou atrav\195\169s do c\195\179digo de convite"
    L8_3 = L7_3
    L7_3 = L7_3.format
    L9_3 = L2_2
    L7_3 = L7_3(L8_3, L9_3)
    L8_3 = {}
    L9_3 = {}
    L10_3 = L2_2
    L9_3[1] = L10_3
    L8_3.targets = L9_3
    L3_3(L4_3, L5_3, L6_3, L7_3, L8_3)
    L3_3 = L83_1
    L4_3 = L0_3
    L5_3 = {}
    L5_3.action = "join"
    L6_3 = L2_2
    L5_3.by = L6_3
    L6_3 = {}
    L7_3 = L2_2
    L6_3[1] = L7_3
    L5_3.targets = L6_3
    L3_3(L4_3, L5_3)
    L3_3 = L85_1
    L4_3 = A0_2
    L5_3 = L0_3
    L6_3 = L2_2
    L7_3 = {}
    L7_3.role = "member"
    L3_3 = L3_3(L4_3, L5_3, L6_3, L7_3)
    L3_3.joined = true
    return L3_3
  end
  return L8_2(L9_2, L10_2)
end
L101_1(L102_1, L103_1)
L101_1 = "https?://[%w%-%._~:/%?#%[%]@!%$&'%(%)%*%+,;=%%]+"
function L102_1(A0_2)
  local L1_2, L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2
  L1_2 = {}
  L2_2 = tostring
  L3_2 = A0_2 or L3_2
  if not A0_2 then
    L3_2 = ""
  end
  L2_2 = L2_2(L3_2)
  L3_2 = L2_2
  L2_2 = L2_2.gmatch
  L4_2 = L101_1
  L2_2, L3_2, L4_2, L5_2 = L2_2(L3_2, L4_2)
  for L6_2 in L2_2, L3_2, L4_2, L5_2 do
    L7_2 = #L1_2
    L7_2 = L7_2 + 1
    L8_2 = L29_1
    L9_2 = L6_2
    L10_2 = 200
    L8_2 = L8_2(L9_2, L10_2)
    L1_2[L7_2] = L8_2
    L7_2 = #L1_2
    if L7_2 >= 3 then
      return L1_2
    end
  end
  L2_2 = tostring
  L3_2 = A0_2 or L3_2
  if not A0_2 then
    L3_2 = ""
  end
  L2_2 = L2_2(L3_2)
  L3_2 = L2_2
  L2_2 = L2_2.gmatch
  L4_2 = "www%.[%w%-%.]+[^%s]*"
  L2_2, L3_2, L4_2, L5_2 = L2_2(L3_2, L4_2)
  for L6_2 in L2_2, L3_2, L4_2, L5_2 do
    L7_2 = #L1_2
    L7_2 = L7_2 + 1
    L8_2 = L29_1
    L9_2 = L6_2
    L10_2 = 200
    L8_2 = L8_2(L9_2, L10_2)
    L1_2[L7_2] = L8_2
    L7_2 = #L1_2
    if L7_2 >= 3 then
      break
    end
  end
  return L1_2
end
L103_1 = {}
L103_1.media = "type IN ('image','gif')"
L103_1.links = "type = 'text' AND (content LIKE '%http://%' OR content LIKE '%https://%' OR content LIKE '%www.%')"
L103_1.docs = "type = 'document'"
function L104_1(A0_2)
  local L1_2, L2_2, L3_2, L4_2
  L1_2 = ""
  L2_2 = L43_1
  L3_2 = "apex_phone_messages"
  L4_2 = "view_once"
  L2_2 = L2_2(L3_2, L4_2)
  if L2_2 then
    L2_2 = L1_2
    L3_2 = " AND (view_once IS NULL OR view_once = 0)"
    L2_2 = L2_2 .. L3_2
    L1_2 = L2_2
  end
  L2_2 = L43_1
  L3_2 = "apex_phone_messages"
  L4_2 = "expires_at"
  L2_2 = L2_2(L3_2, L4_2)
  if L2_2 then
    L2_2 = L1_2
    L3_2 = " AND (expires_at IS NULL OR expires_at > ?)"
    L2_2 = L2_2 .. L3_2
    L1_2 = L2_2
    L2_2 = #A0_2
    L2_2 = L2_2 + 1
    L3_2 = L28_1
    L3_2 = L3_2()
    A0_2[L2_2] = L3_2
  end
  return L1_2
end
function L105_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2
  L2_2 = {}
  L3_2 = ipairs
  L4_2 = A0_2
  L3_2, L4_2, L5_2, L6_2 = L3_2(L4_2)
  for L7_2, L8_2 in L3_2, L4_2, L5_2, L6_2 do
    if A1_2 < L7_2 then
      break
    end
    L9_2 = {}
    L10_2 = L25_1
    L11_2 = L8_2.id
    L10_2 = L10_2(L11_2)
    L9_2.id = L10_2
    L10_2 = L8_2.sender
    L9_2.sender = L10_2
    L10_2 = L8_2.type
    L9_2.type = L10_2
    L10_2 = tonumber
    L11_2 = L8_2.created
    L10_2 = L10_2(L11_2)
    L9_2.created = L10_2
    L10_2 = nil
    L11_2 = type
    L12_2 = L8_2.payload
    L11_2 = L11_2(L12_2)
    if "string" == L11_2 then
      L11_2 = L8_2.payload
      if "" ~= L11_2 then
        L11_2 = pcall
        L12_2 = json
        L12_2 = L12_2.decode
        L13_2 = L8_2.payload
        L11_2, L12_2 = L11_2(L12_2, L13_2)
        if L11_2 then
          L13_2 = type
          L14_2 = L12_2
          L13_2 = L13_2(L14_2)
          if "table" == L13_2 then
            L10_2 = L12_2
          end
        end
      end
    end
    L11_2 = L8_2.type
    if "image" == L11_2 then
      if L10_2 then
        L11_2 = L25_1
        L12_2 = L10_2.mediaId
        L11_2 = L11_2(L12_2)
        if L11_2 then
          goto lbl_56
        end
      end
      L11_2 = nil
      ::lbl_56::
      L9_2.mediaId = L11_2
      if L10_2 then
        L11_2 = L10_2.caption
        if L11_2 then
          L11_2 = L29_1
          L12_2 = L10_2.caption
          L13_2 = 120
          L11_2 = L11_2(L12_2, L13_2)
          L9_2.caption = L11_2
        end
      end
      L11_2 = L9_2.mediaId
      if not L11_2 and L10_2 then
        L11_2 = L10_2.seed
        if L11_2 then
          L11_2 = math
          L11_2 = L11_2.tointeger
          L12_2 = tonumber
          L13_2 = L10_2.seed
          L12_2, L13_2, L14_2 = L12_2(L13_2)
          L11_2 = L11_2(L12_2, L13_2, L14_2)
          L9_2.seed = L11_2
        end
      end
    else
      L11_2 = L8_2.type
      if "gif" == L11_2 then
        if L10_2 then
          L11_2 = type
          L12_2 = L10_2.url
          L11_2 = L11_2(L12_2)
          if "string" == L11_2 then
            L11_2 = L10_2.url
            L12_2 = L11_2
            L11_2 = L11_2.match
            L13_2 = "^https://"
            L11_2 = L11_2(L12_2, L13_2)
            if L11_2 then
              L11_2 = L29_1
              L12_2 = L10_2.url
              L13_2 = 400
              L11_2 = L11_2(L12_2, L13_2)
              L9_2.url = L11_2
            end
          end
        end
      else
        L11_2 = L8_2.type
        if "document" == L11_2 then
          L11_2 = L29_1
          if L10_2 then
            L12_2 = L10_2.title
            if L12_2 then
              goto lbl_118
            end
          end
          L12_2 = L8_2.content
          if not L12_2 then
            L12_2 = "Documento"
          end
          ::lbl_118::
          L13_2 = 80
          L11_2 = L11_2(L12_2, L13_2)
          L9_2.title = L11_2
          if L10_2 then
            L11_2 = type
            L12_2 = L10_2.body
            L11_2 = L11_2(L12_2)
            if "string" == L11_2 then
              L11_2 = L10_2.body
              L11_2 = #L11_2
              if L11_2 then
                goto lbl_133
              end
            end
          end
          L11_2 = nil
          ::lbl_133::
          L9_2.size = L11_2
        else
          L11_2 = L29_1
          L12_2 = L8_2.content
          L13_2 = 200
          L11_2 = L11_2(L12_2, L13_2)
          L9_2.text = L11_2
          L11_2 = L102_1
          L12_2 = L8_2.content
          L11_2 = L11_2(L12_2)
          L9_2.links = L11_2
        end
      end
    end
    L11_2 = #L2_2
    L11_2 = L11_2 + 1
    L2_2[L11_2] = L9_2
  end
  L3_2 = L2_2
  L4_2 = #A0_2
  L4_2 = A1_2 < L4_2
  return L3_2, L4_2
end
L106_1 = 60
L107_1 = L38_1
L108_1 = "recado.group.media"
function L109_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2
  L2_2 = L26_1
  L3_2 = A1_2.id
  L2_2 = L2_2(L3_2)
  L4_2 = A1_2.kind
  L3_2 = L103_1
  L3_2 = L3_2[L4_2]
  if L3_2 then
    L3_2 = A1_2.kind
    if L3_2 then
      goto lbl_13
    end
  end
  L3_2 = nil
  ::lbl_13::
  if not L2_2 or not L3_2 then
    L4_2 = L24_1
    L5_2 = "invalid"
    return L4_2(L5_2)
  end
  L4_2 = L77_1
  L5_2 = A0_2
  L6_2 = L2_2
  L7_2 = false
  L4_2, L5_2, L6_2, L7_2 = L4_2(L5_2, L6_2, L7_2)
  if not L4_2 then
    L8_2 = L24_1
    L9_2 = L7_2
    return L8_2(L9_2)
  end
  L8_2 = L68_1
  L9_2 = L5_2
  L10_2 = "g:"
  L11_2 = L2_2
  L10_2 = L10_2 .. L11_2
  L8_2 = L8_2(L9_2, L10_2)
  L9_2 = L69_1
  L10_2 = A0_2
  L11_2 = L8_2
  L9_2 = L9_2(L10_2, L11_2)
  if L9_2 then
    L9_2 = L24_1
    L10_2 = "locked"
    return L9_2(L10_2)
  end
  L9_2 = {}
  L10_2 = L2_2
  L11_2 = L6_2.joined
  if not L11_2 then
    L11_2 = 0
  end
  L12_2 = L5_2
  L13_2 = L25_1
  L14_2 = L8_2.cleared_before
  L13_2 = L13_2(L14_2)
  if not L13_2 then
    L13_2 = 0
  end
  L9_2[1] = L10_2
  L9_2[2] = L11_2
  L9_2[3] = L12_2
  L9_2[4] = L13_2
  L10_2 = L25_1
  L11_2 = A1_2.before
  L10_2 = L10_2(L11_2)
  L11_2 = ""
  if L10_2 then
    L11_2 = " AND id < ?"
    L12_2 = #L9_2
    L12_2 = L12_2 + 1
    L9_2[L12_2] = L10_2
  end
  L12_2 = L11_2
  L13_2 = L104_1
  L14_2 = L9_2
  L13_2 = L13_2(L14_2)
  L12_2 = L12_2 .. L13_2
  L11_2 = L12_2
  L12_2 = pcall
  L13_2 = MySQL
  L13_2 = L13_2.query
  L13_2 = L13_2.await
  L14_2 = [[
SELECT id, sender, type, content, CASE WHEN CHAR_LENGTH(payload) > 8192 THEN NULL ELSE payload END AS payload, created
        FROM apex_phone_messages WHERE conversation_id = ? AND created >= ? AND deleted_all IS NULL AND NOT (sender = ? AND deleted_sender = 1)
        AND id > ?%s AND %s ORDER BY id DESC LIMIT %d]]
  L15_2 = L14_2
  L14_2 = L14_2.format
  L16_2 = L11_2
  L17_2 = L103_1
  L17_2 = L17_2[L3_2]
  L18_2 = L106_1
  L18_2 = L18_2 + 1
  L14_2 = L14_2(L15_2, L16_2, L17_2, L18_2)
  L15_2 = L9_2
  L12_2, L13_2 = L12_2(L13_2, L14_2, L15_2)
  if not L12_2 then
    L14_2 = L24_1
    L15_2 = "db"
    return L14_2(L15_2)
  end
  L14_2 = L105_1
  L15_2 = L13_2 or L15_2
  if not L13_2 then
    L15_2 = {}
  end
  L16_2 = L106_1
  L14_2, L15_2 = L14_2(L15_2, L16_2)
  L16_2 = {}
  L16_2.ok = true
  L16_2.id = L2_2
  L16_2.kind = L3_2
  L16_2.items = L14_2
  L16_2.more = L15_2
  return L16_2
end
L107_1(L108_1, L109_1)
L107_1 = L38_1
L108_1 = "recado.contact.media"
function L109_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2
  L2_2 = L36_1
  L3_2 = A0_2
  L2_2 = L2_2(L3_2)
  if not L2_2 then
    L3_2 = L24_1
    L4_2 = "noidentity"
    return L3_2(L4_2)
  end
  L3_2 = L32_1
  L4_2 = A1_2.number
  L3_2 = L3_2(L4_2)
  L5_2 = A1_2.kind
  L4_2 = L103_1
  L4_2 = L4_2[L5_2]
  if L4_2 then
    L4_2 = A1_2.kind
    if L4_2 then
      goto lbl_22
    end
  end
  L4_2 = nil
  ::lbl_22::
  if not L3_2 or not L4_2 then
    L5_2 = L24_1
    L6_2 = "invalid"
    return L5_2(L6_2)
  end
  L5_2 = L68_1
  L6_2 = L2_2
  L7_2 = L3_2
  L5_2 = L5_2(L6_2, L7_2)
  L6_2 = L69_1
  L7_2 = A0_2
  L8_2 = L5_2
  L6_2 = L6_2(L7_2, L8_2)
  if L6_2 then
    L6_2 = L24_1
    L7_2 = "locked"
    return L6_2(L7_2)
  end
  L6_2 = {}
  L7_2 = L0_1
  L8_2 = L2_2
  L9_2 = L3_2
  L10_2 = L3_2
  L11_2 = L2_2
  L12_2 = L25_1
  L13_2 = L5_2.cleared_before
  L12_2 = L12_2(L13_2)
  if not L12_2 then
    L12_2 = 0
  end
  L6_2[1] = L7_2
  L6_2[2] = L8_2
  L6_2[3] = L9_2
  L6_2[4] = L10_2
  L6_2[5] = L11_2
  L6_2[6] = L12_2
  L7_2 = L25_1
  L8_2 = A1_2.before
  L7_2 = L7_2(L8_2)
  L8_2 = ""
  if L7_2 then
    L8_2 = " AND id < ?"
    L9_2 = #L6_2
    L9_2 = L9_2 + 1
    L6_2[L9_2] = L7_2
  end
  L9_2 = L8_2
  L10_2 = L104_1
  L11_2 = L6_2
  L10_2 = L10_2(L11_2)
  L9_2 = L9_2 .. L10_2
  L8_2 = L9_2
  L9_2 = pcall
  L10_2 = MySQL
  L10_2 = L10_2.query
  L10_2 = L10_2.await
  L11_2 = [[
SELECT id, sender, type, content, CASE WHEN CHAR_LENGTH(payload) > 8192 THEN NULL ELSE payload END AS payload, created
        FROM apex_phone_messages WHERE app = ? AND conversation_id IS NULL AND deleted_all IS NULL
        AND ((sender = ? AND receiver = ? AND deleted_sender = 0) OR (sender = ? AND receiver = ? AND deleted_receiver = 0))
        AND id > ?%s AND %s ORDER BY id DESC LIMIT %d]]
  L12_2 = L11_2
  L11_2 = L11_2.format
  L13_2 = L8_2
  L14_2 = L103_1
  L14_2 = L14_2[L4_2]
  L15_2 = L106_1
  L15_2 = L15_2 + 1
  L11_2 = L11_2(L12_2, L13_2, L14_2, L15_2)
  L12_2 = L6_2
  L9_2, L10_2 = L9_2(L10_2, L11_2, L12_2)
  if not L9_2 then
    L11_2 = L24_1
    L12_2 = "db"
    return L11_2(L12_2)
  end
  L11_2 = L105_1
  L12_2 = L10_2 or L12_2
  if not L10_2 then
    L12_2 = {}
  end
  L13_2 = L106_1
  L11_2, L12_2 = L11_2(L12_2, L13_2)
  L13_2 = {}
  L13_2.ok = true
  L13_2.number = L3_2
  L13_2.kind = L4_2
  L13_2.items = L11_2
  L13_2.more = L12_2
  return L13_2
end
L107_1(L108_1, L109_1)
L107_1 = L38_1
L108_1 = "recado.group.search"
function L109_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2, L19_2, L20_2, L21_2, L22_2, L23_2, L24_2, L25_2
  L2_2 = L26_1
  L3_2 = A1_2.id
  L2_2 = L2_2(L3_2)
  if not L2_2 then
    L3_2 = L24_1
    L4_2 = "invalid"
    return L3_2(L4_2)
  end
  L3_2 = L31_1
  L4_2 = A1_2.q
  L5_2 = 64
  L6_2 = false
  L3_2 = L3_2(L4_2, L5_2, L6_2)
  if L3_2 then
    L4_2 = #L3_2
    if not (L4_2 < 2) then
      goto lbl_28
    end
  end
  L4_2 = {}
  L4_2.ok = true
  L4_2.id = L2_2
  L5_2 = {}
  L4_2.items = L5_2
  do return L4_2 end
  ::lbl_28::
  L4_2 = L77_1
  L5_2 = A0_2
  L6_2 = L2_2
  L7_2 = false
  L4_2, L5_2, L6_2, L7_2 = L4_2(L5_2, L6_2, L7_2)
  if not L4_2 then
    L8_2 = L24_1
    L9_2 = L7_2
    return L8_2(L9_2)
  end
  L8_2 = L68_1
  L9_2 = L5_2
  L10_2 = "g:"
  L11_2 = L2_2
  L10_2 = L10_2 .. L11_2
  L8_2 = L8_2(L9_2, L10_2)
  L9_2 = L69_1
  L10_2 = A0_2
  L11_2 = L8_2
  L9_2 = L9_2(L10_2, L11_2)
  if L9_2 then
    L9_2 = L24_1
    L10_2 = "locked"
    return L9_2(L10_2)
  end
  L9_2 = "%"
  L11_2 = L3_2
  L10_2 = L3_2.gsub
  L12_2 = "[!%%_]"
  L13_2 = "!%0"
  L10_2 = L10_2(L11_2, L12_2, L13_2)
  L11_2 = "%"
  L9_2 = L9_2 .. L10_2 .. L11_2
  L10_2 = {}
  L11_2 = L2_2
  L12_2 = L6_2.joined
  if not L12_2 then
    L12_2 = 0
  end
  L13_2 = L5_2
  L14_2 = L25_1
  L15_2 = L8_2.cleared_before
  L14_2 = L14_2(L15_2)
  if not L14_2 then
    L14_2 = 0
  end
  L15_2 = L9_2
  L10_2[1] = L11_2
  L10_2[2] = L12_2
  L10_2[3] = L13_2
  L10_2[4] = L14_2
  L10_2[5] = L15_2
  L11_2 = L104_1
  L12_2 = L10_2
  L11_2 = L11_2(L12_2)
  L12_2 = pcall
  L13_2 = MySQL
  L13_2 = L13_2.query
  L13_2 = L13_2.await
  L14_2 = [[
SELECT id, sender, type, content, created FROM apex_phone_messages
        WHERE conversation_id = ? AND created >= ? AND deleted_all IS NULL AND NOT (sender = ? AND deleted_sender = 1) AND id > ?
        AND type <> 'system' AND content LIKE ? ESCAPE '!'%s ORDER BY id DESC LIMIT 40]]
  L15_2 = L14_2
  L14_2 = L14_2.format
  L16_2 = L11_2
  L14_2 = L14_2(L15_2, L16_2)
  L15_2 = L10_2
  L12_2, L13_2 = L12_2(L13_2, L14_2, L15_2)
  if not L12_2 then
    L14_2 = L24_1
    L15_2 = "db"
    return L14_2(L15_2)
  end
  L14_2 = {}
  L15_2 = ipairs
  L16_2 = L13_2 or L16_2
  if not L13_2 then
    L16_2 = {}
  end
  L15_2, L16_2, L17_2, L18_2 = L15_2(L16_2)
  for L19_2, L20_2 in L15_2, L16_2, L17_2, L18_2 do
    L21_2 = #L14_2
    L21_2 = L21_2 + 1
    L22_2 = {}
    L23_2 = L25_1
    L24_2 = L20_2.id
    L23_2 = L23_2(L24_2)
    L22_2.id = L23_2
    L23_2 = L20_2.sender
    L22_2.sender = L23_2
    L23_2 = L20_2.type
    L22_2.type = L23_2
    L23_2 = L29_1
    L24_2 = L20_2.content
    L25_2 = 200
    L23_2 = L23_2(L24_2, L25_2)
    L22_2.content = L23_2
    L23_2 = tonumber
    L24_2 = L20_2.created
    L23_2 = L23_2(L24_2)
    L22_2.created = L23_2
    L14_2[L21_2] = L22_2
  end
  L15_2 = {}
  L15_2.ok = true
  L15_2.id = L2_2
  L15_2.q = L3_2
  L15_2.items = L14_2
  return L15_2
end
L107_1(L108_1, L109_1)
L107_1 = [[
CREATE TABLE IF NOT EXISTS `apex_phone_recado_profiles` (
  `number` VARCHAR(20) NOT NULL,
  `owner` VARCHAR(64) NULL,
  `name` VARCHAR(40) NOT NULL DEFAULT '',
  `about` VARCHAR(160) NOT NULL DEFAULT '',
  `avatar_media` INT NULL,
  `privacy` TEXT NULL,
  `read_receipts` TINYINT NOT NULL DEFAULT 1,
  `groups_add` VARCHAR(8) NOT NULL DEFAULT 'all',
  `silence_unknown` TINYINT NOT NULL DEFAULT 0,
  `updated` BIGINT NOT NULL DEFAULT 0,
  PRIMARY KEY (`number`),
  KEY `owner` (`owner`),
  KEY `avatar_media` (`avatar_media`)
) DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci]]
L108_1 = [[
CREATE TABLE IF NOT EXISTS `apex_phone_conversations` (
  `description` VARCHAR(300) NULL,
  `invite_code` VARCHAR(12) NULL,
  `send_policy` VARCHAR(8) NOT NULL DEFAULT 'all',
  `edit_policy` VARCHAR(8) NOT NULL DEFAULT 'admins',
  `theme` VARCHAR(20) NULL,
  `kind` VARCHAR(12) NOT NULL DEFAULT 'group',
  `community_id` INT NULL
)]]
L109_1 = CreateThread
function L110_1()
  local L0_2, L1_2, L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2
  L0_2 = DBReady
  if nil == L0_2 then
    L0_2 = Wait
    L1_2 = 3000
    L0_2(L1_2)
  else
    while true do
      L0_2 = DBReady
      if L0_2 then
        break
      end
      L0_2 = Wait
      L1_2 = 500
      L0_2(L1_2)
    end
  end
  L0_2 = pcall
  L1_2 = MySQL
  L1_2 = L1_2.query
  L1_2 = L1_2.await
  L2_2 = L107_1
  L0_2, L1_2 = L0_2(L1_2, L2_2)
  if not L0_2 then
    L2_2 = print
    L3_2 = "^1[unique_phone]^0 recado: could not create apex_phone_recado_profiles (%s)"
    L4_2 = L3_2
    L3_2 = L3_2.format
    L5_2 = tostring
    L6_2 = L1_2
    L5_2, L6_2, L7_2, L8_2 = L5_2(L6_2)
    L3_2, L4_2, L5_2, L6_2, L7_2, L8_2 = L3_2(L4_2, L5_2, L6_2, L7_2, L8_2)
    L2_2(L3_2, L4_2, L5_2, L6_2, L7_2, L8_2)
  end
  L2_2 = type
  L3_2 = MigrateTable
  L2_2 = L2_2(L3_2)
  if "function" == L2_2 then
    L2_2 = pcall
    L3_2 = MigrateTable
    L4_2 = L107_1
    L2_2(L3_2, L4_2)
    L2_2 = pcall
    L3_2 = MigrateTable
    L4_2 = L108_1
    L2_2, L3_2 = L2_2(L3_2, L4_2)
    if not L2_2 then
      L4_2 = print
      L5_2 = "^1[unique_phone]^0 recado: group columns not migrated (%s)"
      L6_2 = L5_2
      L5_2 = L5_2.format
      L7_2 = tostring
      L8_2 = L3_2
      L7_2, L8_2 = L7_2(L8_2)
      L5_2, L6_2, L7_2, L8_2 = L5_2(L6_2, L7_2, L8_2)
      L4_2(L5_2, L6_2, L7_2, L8_2)
    end
  end
  L2_2 = type
  L3_2 = EnsureIndex
  L2_2 = L2_2(L3_2)
  if "function" == L2_2 then
    L2_2 = pcall
    L3_2 = EnsureIndex
    L4_2 = "apex_phone_conversations"
    L5_2 = "ux_invite_code"
    L6_2 = {}
    L7_2 = "invite_code"
    L6_2[1] = L7_2
    L7_2 = true
    L2_2(L3_2, L4_2, L5_2, L6_2, L7_2)
    L2_2 = pcall
    L3_2 = EnsureIndex
    L4_2 = "apex_phone_conversations"
    L5_2 = "ax_community"
    L6_2 = {}
    L7_2 = "community_id"
    L6_2[1] = L7_2
    L2_2(L3_2, L4_2, L5_2, L6_2)
    L2_2 = pcall
    L3_2 = EnsureIndex
    L4_2 = "apex_phone_recado_profiles"
    L5_2 = "ax_avatar_media"
    L6_2 = {}
    L7_2 = "avatar_media"
    L6_2[1] = L7_2
    L2_2(L3_2, L4_2, L5_2, L6_2)
  end
  L2_2 = {}
  L42_1 = L2_2
  L2_2 = true
  L18_1 = L2_2
  L2_2 = Dbg
  L3_2 = "recado"
  L4_2 = "people/profiles/groups ready"
  L2_2(L3_2, L4_2)
end
L109_1(L110_1)
L109_1 = CreateThread
function L110_1()
  local L0_2, L1_2, L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2
  while true do
    L0_2 = Wait
    L1_2 = 120000
    L0_2(L1_2)
    L0_2 = os
    L0_2 = L0_2.time
    L0_2 = L0_2()
    L1_2 = pairs
    L2_2 = L51_1
    L1_2, L2_2, L3_2, L4_2 = L1_2(L2_2)
    for L5_2, L6_2 in L1_2, L2_2, L3_2, L4_2 do
      L7_2 = L6_2.t
      L7_2 = L0_2 - L7_2
      if L7_2 > 60 then
        L7_2 = L51_1
        L7_2[L5_2] = nil
      end
    end
    L1_2 = pairs
    L2_2 = L55_1
    L1_2, L2_2, L3_2, L4_2 = L1_2(L2_2)
    for L5_2, L6_2 in L1_2, L2_2, L3_2, L4_2 do
      L7_2 = L6_2.t
      L7_2 = L0_2 - L7_2
      if L7_2 > 120 then
        L7_2 = L55_1
        L7_2[L5_2] = nil
      end
    end
    L1_2 = pairs
    L2_2 = L47_1
    L1_2, L2_2, L3_2, L4_2 = L1_2(L2_2)
    for L5_2, L6_2 in L1_2, L2_2, L3_2, L4_2 do
      L7_2 = L6_2.t
      L7_2 = L0_2 - L7_2
      L8_2 = 600
      if L7_2 > L8_2 then
        L7_2 = L47_1
        L7_2[L5_2] = nil
      end
    end
    L1_2 = GetGameTimer
    L1_2 = L1_2()
    L2_2 = pairs
    L3_2 = L75_1
    L2_2, L3_2, L4_2, L5_2 = L2_2(L3_2)
    for L6_2, L7_2 in L2_2, L3_2, L4_2, L5_2 do
      L8_2 = L7_2.t
      L8_2 = L1_2 - L8_2
      L9_2 = 60000
      if L8_2 > L9_2 then
        L8_2 = L75_1
        L8_2[L6_2] = nil
      end
    end
    L2_2 = pairs
    L3_2 = L100_1
    L2_2, L3_2, L4_2, L5_2 = L2_2(L3_2)
    for L6_2, L7_2 in L2_2, L3_2, L4_2, L5_2 do
      L8_2 = L7_2.t
      L8_2 = L1_2 - L8_2
      L9_2 = L16_1
      if L8_2 > L9_2 then
        L8_2 = L100_1
        L8_2[L6_2] = nil
      end
    end
  end
end
L109_1(L110_1)
L109_1 = FW
if L109_1 then
  L109_1 = FW
  L109_1 = L109_1.OnPlayerLoaded
  if L109_1 then
    L109_1 = FW
    L109_1 = L109_1.OnPlayerLoaded
    function L110_1()
      local L0_2, L1_2
      L0_2 = nil
      L44_1 = L0_2
    end
    L109_1(L110_1)
  end
end
L109_1 = AddEventHandler
L110_1 = "playerDropped"
function L111_1()
  local L0_2, L1_2
  L0_2 = tonumber
  L1_2 = source
  L0_2 = L0_2(L1_2)
  if L0_2 then
    L1_2 = L94_1
    L1_2[L0_2] = nil
    L1_2 = L100_1
    L1_2[L0_2] = nil
  end
  L1_2 = nil
  L44_1 = L1_2
end
L109_1(L110_1, L111_1)
