local L0_1, L1_1, L2_1, L3_1, L4_1, L5_1, L6_1, L7_1, L8_1, L9_1, L10_1, L11_1, L12_1, L13_1, L14_1, L15_1, L16_1, L17_1, L18_1, L19_1, L20_1, L21_1, L22_1, L23_1, L24_1, L25_1, L26_1, L27_1, L28_1, L29_1, L30_1, L31_1, L32_1, L33_1, L34_1, L35_1, L36_1, L37_1, L38_1, L39_1, L40_1, L41_1, L42_1, L43_1, L44_1, L45_1, L46_1, L47_1, L48_1, L49_1, L50_1, L51_1, L52_1, L53_1, L54_1, L55_1, L56_1, L57_1, L58_1, L59_1, L60_1, L61_1, L62_1, L63_1, L64_1, L65_1, L66_1, L67_1, L68_1, L69_1, L70_1, L71_1, L72_1, L73_1, L74_1, L75_1, L76_1, L77_1, L78_1, L79_1, L80_1, L81_1, L82_1, L83_1, L84_1, L85_1, L86_1, L87_1, L88_1, L89_1, L90_1, L91_1, L92_1, L93_1, L94_1, L95_1
function L0_1()
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
function L4_1(A0_2, A1_2)
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
L5_1 = {}
L6_1 = "\226\128[\139-\143]"
L7_1 = "\226\128[\168-\174]"
L8_1 = "\226\129[\160-\175]"
L9_1 = "\239\187\191"
L10_1 = "\194\173"
L11_1 = "\227\133\164"
L12_1 = "\226\160\128"
L5_1[1] = L6_1
L5_1[2] = L7_1
L5_1[3] = L8_1
L5_1[4] = L9_1
L5_1[5] = L10_1
L5_1[6] = L11_1
L5_1[7] = L12_1
L6_1 = {}
L7_1 = "\226\128[\170-\174]"
L8_1 = "\226\129[\166-\169]"
L9_1 = "\239\187\191"
L6_1[1] = L7_1
L6_1[2] = L8_1
L6_1[3] = L9_1
function L7_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2
  L2_2 = type
  L3_2 = A0_2
  L2_2 = L2_2(L3_2)
  if "string" ~= L2_2 then
    L2_2 = type
    L3_2 = A0_2
    L2_2 = L2_2(L3_2)
    if "number" ~= L2_2 then
      L2_2 = nil
      return L2_2
    end
  end
  L2_2 = L4_1
  L3_2 = A0_2
  L4_2 = 400
  L2_2 = L2_2(L3_2, L4_2)
  L3_2 = L2_2
  L2_2 = L2_2.gsub
  L4_2 = "%c"
  L5_2 = " "
  L2_2 = L2_2(L3_2, L4_2, L5_2)
  L3_2 = ipairs
  L4_2 = L5_1
  L3_2, L4_2, L5_2, L6_2 = L3_2(L4_2)
  for L7_2, L8_2 in L3_2, L4_2, L5_2, L6_2 do
    L10_2 = L2_2
    L9_2 = L2_2.gsub
    L11_2 = L8_2
    L12_2 = ""
    L9_2 = L9_2(L10_2, L11_2, L12_2)
    L2_2 = L9_2
  end
  L4_2 = L2_2
  L3_2 = L2_2.gsub
  L5_2 = "\194\160"
  L6_2 = " "
  L3_2 = L3_2(L4_2, L5_2, L6_2)
  L4_2 = L3_2
  L3_2 = L3_2.gsub
  L5_2 = "%s+"
  L6_2 = " "
  L3_2 = L3_2(L4_2, L5_2, L6_2)
  L4_2 = L3_2
  L3_2 = L3_2.match
  L5_2 = "^%s*(.-)%s*$"
  L3_2 = L3_2(L4_2, L5_2)
  L2_2 = L3_2
  L3_2 = utf8
  L3_2 = L3_2.len
  L4_2 = L2_2
  L3_2 = L3_2(L4_2)
  if not L3_2 or "" == L2_2 then
    L4_2 = nil
    return L4_2
  end
  if A1_2 < L3_2 then
    L5_2 = L2_2
    L4_2 = L2_2.sub
    L6_2 = 1
    L7_2 = utf8
    L7_2 = L7_2.offset
    L8_2 = L2_2
    L9_2 = A1_2 + 1
    L7_2 = L7_2(L8_2, L9_2)
    L7_2 = L7_2 - 1
    L4_2 = L4_2(L5_2, L6_2, L7_2)
    L5_2 = L4_2
    L4_2 = L4_2.match
    L6_2 = "^(.-)%s*$"
    L4_2 = L4_2(L5_2, L6_2)
    L2_2 = L4_2
  end
  L4_2 = L2_2 or L4_2
  if "" == L2_2 or not L2_2 then
    L4_2 = nil
  end
  return L4_2
end
function L8_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2
  L2_2 = type
  L3_2 = A0_2
  L2_2 = L2_2(L3_2)
  if "string" ~= L2_2 then
    L2_2 = type
    L3_2 = A0_2
    L2_2 = L2_2(L3_2)
    if "number" ~= L2_2 then
      L2_2 = nil
      return L2_2
    end
  end
  L2_2 = L4_1
  L3_2 = tostring
  L4_2 = A0_2
  L3_2 = L3_2(L4_2)
  L4_2 = A1_2 * 4
  L4_2 = L4_2 + 8
  L2_2 = L2_2(L3_2, L4_2)
  L4_2 = L2_2
  L3_2 = L2_2.gsub
  L5_2 = "\r\n?"
  L6_2 = "\n"
  L3_2 = L3_2(L4_2, L5_2, L6_2)
  L4_2 = L3_2
  L3_2 = L3_2.gsub
  L5_2 = "[\000\001-\t\v-\031\127]"
  L6_2 = ""
  L3_2 = L3_2(L4_2, L5_2, L6_2)
  L2_2 = L3_2
  L3_2 = ipairs
  L4_2 = L6_1
  L3_2, L4_2, L5_2, L6_2 = L3_2(L4_2)
  for L7_2, L8_2 in L3_2, L4_2, L5_2, L6_2 do
    L10_2 = L2_2
    L9_2 = L2_2.gsub
    L11_2 = L8_2
    L12_2 = ""
    L9_2 = L9_2(L10_2, L11_2, L12_2)
    L2_2 = L9_2
  end
  L4_2 = L2_2
  L3_2 = L2_2.gsub
  L5_2 = [[



+]]
  L6_2 = [[


]]
  L3_2 = L3_2(L4_2, L5_2, L6_2)
  L4_2 = L3_2
  L3_2 = L3_2.match
  L5_2 = "^%s*(.-)%s*$"
  L3_2 = L3_2(L4_2, L5_2)
  L2_2 = L3_2
  L3_2 = utf8
  L3_2 = L3_2.len
  L4_2 = L2_2
  L3_2 = L3_2(L4_2)
  if "" == L2_2 or not L3_2 then
    L4_2 = nil
    return L4_2
  end
  if A1_2 < L3_2 then
    L5_2 = L2_2
    L4_2 = L2_2.sub
    L6_2 = 1
    L7_2 = utf8
    L7_2 = L7_2.offset
    L8_2 = L2_2
    L9_2 = A1_2 + 1
    L7_2 = L7_2(L8_2, L9_2)
    L7_2 = L7_2 - 1
    L4_2 = L4_2(L5_2, L6_2, L7_2)
    L5_2 = L4_2
    L4_2 = L4_2.match
    L6_2 = "^(.-)%s*$"
    L4_2 = L4_2(L5_2, L6_2)
    L2_2 = L4_2
  end
  L4_2 = L2_2 or L4_2
  if "" == L2_2 or not L2_2 then
    L4_2 = nil
  end
  return L4_2
end
function L9_1(A0_2)
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
function L10_1(A0_2, A1_2, A2_2)
  local L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2
  if nil == A0_2 then
    L3_2 = {}
    return L3_2
  end
  L3_2 = type
  L4_2 = A0_2
  L3_2 = L3_2(L4_2)
  if "table" ~= L3_2 then
    L3_2 = nil
    return L3_2
  end
  L3_2 = {}
  L4_2 = {}
  L5_2 = ipairs
  L6_2 = A0_2
  L5_2, L6_2, L7_2, L8_2 = L5_2(L6_2)
  for L9_2, L10_2 in L5_2, L6_2, L7_2, L8_2 do
    L11_2 = A1_2 * 2
    if L9_2 > L11_2 then
      L11_2 = nil
      return L11_2
    end
    L11_2 = L9_1
    L12_2 = L10_2
    L11_2 = L11_2(L12_2)
    if not L11_2 then
      L12_2 = nil
      return L12_2
    end
    if L11_2 ~= A2_2 then
      L12_2 = L4_2[L11_2]
      if not L12_2 then
        L4_2[L11_2] = true
        L12_2 = #L3_2
        L12_2 = L12_2 + 1
        L3_2[L12_2] = L11_2
        L12_2 = #L3_2
        if A1_2 < L12_2 then
          L12_2 = nil
          return L12_2
        end
      end
    end
  end
  return L3_2
end
function L11_1(A0_2)
  local L1_2, L2_2, L3_2, L4_2
  L1_2 = type
  L2_2 = A0_2
  L1_2 = L1_2(L2_2)
  if "string" ~= L1_2 or "" == A0_2 then
    L1_2 = nil
    return L1_2
  end
  L1_2 = pcall
  L2_2 = json
  L2_2 = L2_2.decode
  L3_2 = A0_2
  L1_2, L2_2 = L1_2(L2_2, L3_2)
  if L1_2 then
    L3_2 = type
    L4_2 = L2_2
    L3_2 = L3_2(L4_2)
    if "table" == L3_2 and L2_2 then
      goto lbl_25
      L3_2 = L2_2 or L3_2
    end
  end
  L3_2 = nil
  ::lbl_25::
  return L3_2
end
function L12_1(A0_2)
  local L1_2, L2_2, L3_2, L4_2
  if nil == A0_2 then
    L1_2 = nil
    return L1_2
  end
  L1_2 = pcall
  L2_2 = json
  L2_2 = L2_2.encode
  L3_2 = A0_2
  L1_2, L2_2 = L1_2(L2_2, L3_2)
  if L1_2 then
    L3_2 = type
    L4_2 = L2_2
    L3_2 = L3_2(L4_2)
    if "string" == L3_2 and L2_2 then
      goto lbl_20
      L3_2 = L2_2 or L3_2
    end
  end
  L3_2 = nil
  ::lbl_20::
  return L3_2
end
function L13_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2
  L2_2 = type
  L3_2 = A0_2
  L2_2 = L2_2(L3_2)
  if "table" ~= L2_2 then
    L2_2 = false
    return L2_2
  end
  L2_2 = ipairs
  L3_2 = A0_2
  L2_2, L3_2, L4_2, L5_2 = L2_2(L3_2)
  for L6_2, L7_2 in L2_2, L3_2, L4_2, L5_2 do
    L8_2 = tostring
    L9_2 = L7_2
    L8_2 = L8_2(L9_2)
    if L8_2 == A1_2 then
      L8_2 = true
      return L8_2
    end
  end
  L2_2 = false
  return L2_2
end
function L14_1(A0_2)
  local L1_2, L2_2, L3_2, L4_2
  L1_2 = tostring
  L2_2 = A0_2
  L1_2 = L1_2(L2_2)
  L2_2 = L1_2
  L1_2 = L1_2.gsub
  L3_2 = "[\\%%_]"
  L4_2 = "\\%0"
  L1_2 = L1_2(L2_2, L3_2, L4_2)
  return L1_2
end
function L15_1(A0_2)
  local L1_2
  L1_2 = true == A0_2 or 1 == A0_2 or "1" == A0_2
  return L1_2
end
function L16_1(A0_2)
  local L1_2, L2_2, L3_2, L4_2, L5_2
  L1_2 = GetCid
  L2_2 = A0_2
  L1_2 = L1_2(L2_2)
  L2_2 = GetPlayerNumber
  L3_2 = A0_2
  L2_2 = L2_2(L3_2)
  if not L1_2 or nil == L2_2 or "" == L2_2 then
    L3_2 = nil
    return L3_2
  end
  L3_2 = tostring
  L4_2 = L2_2
  L3_2 = L3_2(L4_2)
  L4_2 = tostring
  L5_2 = L1_2
  L4_2, L5_2 = L4_2(L5_2)
  return L3_2, L4_2, L5_2
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
L20_1 = {}
function L21_1(A0_2, A1_2, ...)
  local L2_2, L3_2, L4_2, L5_2, L6_2, L7_2
  L2_2 = 0
  while true do
    L3_2 = L20_1
    L3_2 = L3_2[A0_2]
    if not L3_2 then
      break
    end
    L3_2 = 5000
    if L2_2 >= L3_2 then
      L3_2 = L3_1
      L4_2 = "busy"
      return L3_2(L4_2)
    end
    L3_2 = Wait
    L4_2 = 50
    L3_2(L4_2)
    L2_2 = L2_2 + 50
  end
  L3_2 = L20_1
  L3_2[A0_2] = true
  L3_2 = table
  L3_2 = L3_2.pack
  L4_2 = pcall
  L5_2 = A1_2
  L6_2, L7_2 = ...
  L4_2, L5_2, L6_2, L7_2 = L4_2(L5_2, L6_2, L7_2)
  L3_2 = L3_2(L4_2, L5_2, L6_2, L7_2)
  L4_2 = L20_1
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
L22_1 = {}
function L23_1(A0_2, A1_2, A2_2)
  local L3_2, L4_2, L5_2, L6_2
  L3_2 = GetGameTimer
  L3_2 = L3_2()
  L4_2 = tostring
  L5_2 = A0_2
  L4_2 = L4_2(L5_2)
  L5_2 = "|"
  L6_2 = A1_2
  L4_2 = L4_2 .. L5_2 .. L6_2
  L5_2 = L22_1
  L5_2 = L5_2[L4_2]
  if L5_2 then
    L5_2 = L22_1
    L5_2 = L5_2[L4_2]
    L5_2 = L3_2 - L5_2
    if A2_2 > L5_2 then
      L5_2 = true
      return L5_2
    end
  end
  L5_2 = L22_1
  L5_2[L4_2] = L3_2
  L5_2 = false
  return L5_2
end
L24_1 = {}
L25_1 = 180000
function L26_1(A0_2)
  local L1_2, L2_2, L3_2, L4_2, L5_2, L6_2, L7_2
  L1_2 = L1_1
  L2_2 = A0_2
  L1_2 = L1_2(L2_2)
  A0_2 = L1_2
  if not A0_2 then
    return
  end
  L1_2 = pairs
  L2_2 = L24_1
  L1_2, L2_2, L3_2, L4_2 = L1_2(L2_2)
  for L5_2, L6_2 in L1_2, L2_2, L3_2, L4_2 do
    L7_2 = L6_2.ids
    L7_2[A0_2] = nil
  end
end
function L27_1()
  local L0_2, L1_2, L2_2, L3_2, L4_2, L5_2, L6_2
  L0_2 = pairs
  L1_2 = L24_1
  L0_2, L1_2, L2_2, L3_2 = L0_2(L1_2)
  for L4_2 in L0_2, L1_2, L2_2, L3_2 do
    L5_2 = L24_1
    L5_2[L4_2] = nil
  end
end
function L28_1(A0_2, A1_2, A2_2)
  local L3_2, L4_2, L5_2, L6_2
  L3_2 = L1_1
  L4_2 = A1_2
  L3_2 = L3_2(L4_2)
  if L3_2 then
    L4_2 = type
    L5_2 = MediaInfo
    L4_2 = L4_2(L5_2)
    if "function" == L4_2 then
      goto lbl_13
    end
  end
  L4_2 = nil
  do return L4_2 end
  ::lbl_13::
  L4_2 = MediaInfo
  L5_2 = L3_2
  L4_2 = L4_2(L5_2)
  if L4_2 then
    L5_2 = L4_2.complete
    if L5_2 then
      L5_2 = tostring
      L6_2 = L4_2.owner
      L5_2 = L5_2(L6_2)
      if L5_2 == A0_2 then
        goto lbl_28
      end
    end
  end
  L5_2 = nil
  do return L5_2 end
  ::lbl_28::
  if A2_2 then
    L5_2 = L4_2.kind
    if L5_2 ~= A2_2 then
      L5_2 = nil
      return L5_2
    end
  end
  L5_2 = L3_2
  L6_2 = L4_2
  return L5_2, L6_2
end
function L29_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2
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
  L5_2 = 200
  for L6_2 = L3_2, L4_2, L5_2 do
    L7_2 = {}
    L8_2 = A0_2
    L7_2[1] = L8_2
    L8_2 = L6_2
    L9_2 = math
    L9_2 = L9_2.min
    L10_2 = #A1_2
    L11_2 = L6_2 + 199
    L9_2 = L9_2(L10_2, L11_2)
    L10_2 = 1
    for L11_2 = L8_2, L9_2, L10_2 do
      L12_2 = #L7_2
      L12_2 = L12_2 + 1
      L13_2 = A1_2[L11_2]
      L7_2[L12_2] = L13_2
    end
    L8_2 = pcall
    L9_2 = MySQL
    L9_2 = L9_2.query
    L9_2 = L9_2.await
    L10_2 = "SELECT number, name FROM apex_phone_contacts WHERE owner = ? AND number IN (%s)"
    L11_2 = L10_2
    L10_2 = L10_2.format
    L12_2 = L2_1
    L13_2 = #L7_2
    L13_2 = L13_2 - 1
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
          L2_2[L16_2] = L17_2
        end
      end
    end
  end
  return L2_2
end
function L30_1(A0_2)
  local L1_2, L2_2, L3_2, L4_2
  L1_2 = type
  L2_2 = RecadoProfile
  L1_2 = L1_2(L2_2)
  if "function" ~= L1_2 then
    L1_2 = nil
    return L1_2
  end
  L1_2 = pcall
  L2_2 = RecadoProfile
  L3_2 = A0_2
  L1_2, L2_2 = L1_2(L2_2, L3_2)
  if L1_2 then
    L3_2 = type
    L4_2 = L2_2
    L3_2 = L3_2(L4_2)
    if "table" == L3_2 then
      L3_2 = type
      L4_2 = L2_2.name
      L3_2 = L3_2(L4_2)
      if "string" == L3_2 then
        L3_2 = L2_2.name
        if "" ~= L3_2 then
          L3_2 = L2_2.name
          return L3_2
        end
      end
    end
  end
  L3_2 = nil
  return L3_2
end
function L31_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2, L6_2, L7_2
  L2_2 = pcall
  L3_2 = MySQL
  L3_2 = L3_2.scalar
  L3_2 = L3_2.await
  L4_2 = "SELECT name FROM apex_phone_contacts WHERE owner = ? AND number = ? LIMIT 1"
  L5_2 = {}
  L6_2 = A0_2
  L7_2 = A1_2
  L5_2[1] = L6_2
  L5_2[2] = L7_2
  L2_2, L3_2 = L2_2(L3_2, L4_2, L5_2)
  if L2_2 and L3_2 then
    L4_2 = tostring
    L5_2 = L3_2
    return L4_2(L5_2)
  end
  L4_2 = L30_1
  L5_2 = A1_2
  L4_2 = L4_2(L5_2)
  if not L4_2 then
    L4_2 = A1_2
  end
  return L4_2
end
L32_1 = false
L33_1 = {}
L34_1 = "CREATE TABLE IF NOT EXISTS `apex_phone_recado_status` (`id` INT AUTO_INCREMENT PRIMARY KEY, `owner` VARCHAR(20) NOT NULL, `owner_cid` VARCHAR(64) NOT NULL, `kind` VARCHAR(8) NOT NULL DEFAULT 'text', `content` VARCHAR(1000) NULL, `media_id` INT NULL, `bg` VARCHAR(16) NULL, `font` VARCHAR(12) NULL, `duration` INT NULL, `privacy` VARCHAR(8) NOT NULL DEFAULT 'contacts', `audience` TEXT NULL, `mentions` TEXT NULL, `reshare_of` INT NULL, `created` BIGINT NOT NULL, `expires` BIGINT NOT NULL, KEY `owner` (`owner`, `expires`), KEY `expires` (`expires`), KEY `media` (`media_id`)) DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci"
L35_1 = "CREATE TABLE IF NOT EXISTS `apex_phone_recado_status_views` (`status_id` INT NOT NULL, `viewer` VARCHAR(20) NOT NULL, `liked` TINYINT NOT NULL DEFAULT 0, `created` BIGINT NOT NULL, PRIMARY KEY (`status_id`, `viewer`), KEY `viewer` (`viewer`)) DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci"
L36_1 = "CREATE TABLE IF NOT EXISTS `apex_phone_recado_status_prefs` (`number` VARCHAR(20) NOT NULL PRIMARY KEY, `privacy` VARCHAR(8) NOT NULL DEFAULT 'contacts', `audience` TEXT NULL, `muted` TEXT NULL, `updated` BIGINT NOT NULL) DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci"
L37_1 = "CREATE TABLE IF NOT EXISTS `apex_phone_recado_channels` (`id` INT AUTO_INCREMENT PRIMARY KEY, `name` VARCHAR(40) NOT NULL, `description` VARCHAR(300) NULL, `avatar` INT NULL, `owner` VARCHAR(20) NOT NULL, `owner_cid` VARCHAR(64) NOT NULL, `code` VARCHAR(12) NULL, `listed` TINYINT NOT NULL DEFAULT 1, `verified` TINYINT NOT NULL DEFAULT 0, `followers` INT NOT NULL DEFAULT 0, `created` BIGINT NOT NULL, `updated` BIGINT NOT NULL, `last_post` BIGINT NULL, UNIQUE KEY `ux_code` (`code`), KEY `owner` (`owner`), KEY `listed` (`listed`, `followers`)) DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci"
L38_1 = "CREATE TABLE IF NOT EXISTS `apex_phone_recado_channel_admins` (`channel_id` INT NOT NULL, `number` VARCHAR(20) NOT NULL, `role` VARCHAR(8) NOT NULL DEFAULT 'admin', `added` BIGINT NOT NULL, PRIMARY KEY (`channel_id`, `number`), KEY `number` (`number`)) DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci"
L39_1 = "CREATE TABLE IF NOT EXISTS `apex_phone_recado_channel_followers` (`channel_id` INT NOT NULL, `number` VARCHAR(20) NOT NULL, `muted` TINYINT NOT NULL DEFAULT 1, `last_read` INT NULL, `created` BIGINT NOT NULL, PRIMARY KEY (`channel_id`, `number`), KEY `number` (`number`)) DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci"
L40_1 = "CREATE TABLE IF NOT EXISTS `apex_phone_recado_channel_posts` (`id` INT AUTO_INCREMENT PRIMARY KEY, `channel_id` INT NOT NULL, `author` VARCHAR(20) NOT NULL, `type` VARCHAR(10) NOT NULL DEFAULT 'text', `content` TEXT NULL, `payload` TEXT NULL, `media_id` INT NULL, `created` BIGINT NOT NULL, `edited` BIGINT NULL, KEY `ch` (`channel_id`, `id`), KEY `media` (`media_id`)) DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci"
L41_1 = "CREATE TABLE IF NOT EXISTS `apex_phone_recado_channel_reactions` (`post_id` INT NOT NULL, `number` VARCHAR(20) NOT NULL, `emoji` VARCHAR(16) NOT NULL, `created` BIGINT NOT NULL, PRIMARY KEY (`post_id`, `number`)) DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci"
L42_1 = "CREATE TABLE IF NOT EXISTS `apex_phone_recado_channel_votes` (`post_id` INT NOT NULL, `number` VARCHAR(20) NOT NULL, `options` VARCHAR(64) NOT NULL, `created` BIGINT NOT NULL, PRIMARY KEY (`post_id`, `number`)) DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci"
L43_1 = "CREATE TABLE IF NOT EXISTS `apex_phone_recado_communities` (`id` INT AUTO_INCREMENT PRIMARY KEY, `name` VARCHAR(40) NOT NULL, `description` VARCHAR(300) NULL, `avatar` INT NULL, `owner` VARCHAR(20) NOT NULL, `owner_cid` VARCHAR(64) NOT NULL, `announce_id` INT NULL, `created` BIGINT NOT NULL, `updated` BIGINT NOT NULL, KEY `owner` (`owner`), KEY `announce` (`announce_id`)) DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci"
L33_1[1] = L34_1
L33_1[2] = L35_1
L33_1[3] = L36_1
L33_1[4] = L37_1
L33_1[5] = L38_1
L33_1[6] = L39_1
L33_1[7] = L40_1
L33_1[8] = L41_1
L33_1[9] = L42_1
L33_1[10] = L43_1
L34_1 = "CREATE TABLE IF NOT EXISTS `apex_phone_conversations` (`description` VARCHAR(300) NULL, `send_policy` VARCHAR(8) NOT NULL DEFAULT 'all', `edit_policy` VARCHAR(8) NOT NULL DEFAULT 'admins', `kind` VARCHAR(12) NOT NULL DEFAULT 'group', `community_id` INT NULL)"
L35_1 = CreateThread
function L36_1()
  local L0_2, L1_2, L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2
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
  L0_2 = ipairs
  L1_2 = L33_1
  L0_2, L1_2, L2_2, L3_2 = L0_2(L1_2)
  for L4_2, L5_2 in L0_2, L1_2, L2_2, L3_2 do
    L6_2 = pcall
    L7_2 = MySQL
    L7_2 = L7_2.query
    L7_2 = L7_2.await
    L8_2 = L5_2
    L6_2, L7_2 = L6_2(L7_2, L8_2)
    if not L6_2 then
      L8_2 = print
      L9_2 = "^1[unique_phone]^0 recado_social: could not create %s (%s)"
      L10_2 = L9_2
      L9_2 = L9_2.format
      L11_2 = tostring
      L13_2 = L5_2
      L12_2 = L5_2.match
      L14_2 = "`([%w_]+)`"
      L12_2, L13_2, L14_2 = L12_2(L13_2, L14_2)
      L11_2 = L11_2(L12_2, L13_2, L14_2)
      L12_2 = tostring
      L13_2 = L7_2
      L12_2, L13_2, L14_2 = L12_2(L13_2)
      L9_2, L10_2, L11_2, L12_2, L13_2, L14_2 = L9_2(L10_2, L11_2, L12_2, L13_2, L14_2)
      L8_2(L9_2, L10_2, L11_2, L12_2, L13_2, L14_2)
    end
  end
  L0_2 = type
  L1_2 = MigrateTable
  L0_2 = L0_2(L1_2)
  if "function" == L0_2 then
    L0_2 = ipairs
    L1_2 = L33_1
    L0_2, L1_2, L2_2, L3_2 = L0_2(L1_2)
    for L4_2, L5_2 in L0_2, L1_2, L2_2, L3_2 do
      L6_2 = pcall
      L7_2 = MigrateTable
      L8_2 = L5_2
      L6_2(L7_2, L8_2)
    end
    L0_2 = Wait
    L1_2 = 2500
    L0_2(L1_2)
    L0_2 = pcall
    L1_2 = MigrateTable
    L2_2 = L34_1
    L0_2, L1_2 = L0_2(L1_2, L2_2)
    if not L0_2 then
      L2_2 = print
      L3_2 = "^3[unique_phone]^0 recado_social: community columns (%s)"
      L4_2 = L3_2
      L3_2 = L3_2.format
      L5_2 = tostring
      L6_2 = L1_2
      L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2 = L5_2(L6_2)
      L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2 = L3_2(L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2)
      L2_2(L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2)
    end
  end
  L0_2 = type
  L1_2 = EnsureIndex
  L0_2 = L0_2(L1_2)
  if "function" == L0_2 then
    L0_2 = pcall
    L1_2 = EnsureIndex
    L2_2 = "apex_phone_recado_status"
    L3_2 = "owner"
    L4_2 = {}
    L5_2 = "owner"
    L6_2 = "expires"
    L4_2[1] = L5_2
    L4_2[2] = L6_2
    L0_2(L1_2, L2_2, L3_2, L4_2)
    L0_2 = pcall
    L1_2 = EnsureIndex
    L2_2 = "apex_phone_recado_status"
    L3_2 = "expires"
    L4_2 = {}
    L5_2 = "expires"
    L4_2[1] = L5_2
    L0_2(L1_2, L2_2, L3_2, L4_2)
    L0_2 = pcall
    L1_2 = EnsureIndex
    L2_2 = "apex_phone_recado_status_views"
    L3_2 = "viewer"
    L4_2 = {}
    L5_2 = "viewer"
    L4_2[1] = L5_2
    L0_2(L1_2, L2_2, L3_2, L4_2)
    L0_2 = pcall
    L1_2 = EnsureIndex
    L2_2 = "apex_phone_recado_channel_followers"
    L3_2 = "number"
    L4_2 = {}
    L5_2 = "number"
    L4_2[1] = L5_2
    L0_2(L1_2, L2_2, L3_2, L4_2)
    L0_2 = pcall
    L1_2 = EnsureIndex
    L2_2 = "apex_phone_recado_channel_admins"
    L3_2 = "number"
    L4_2 = {}
    L5_2 = "number"
    L4_2[1] = L5_2
    L0_2(L1_2, L2_2, L3_2, L4_2)
    L0_2 = pcall
    L1_2 = EnsureIndex
    L2_2 = "apex_phone_recado_channel_posts"
    L3_2 = "ch"
    L4_2 = {}
    L5_2 = "channel_id"
    L6_2 = "id"
    L4_2[1] = L5_2
    L4_2[2] = L6_2
    L0_2(L1_2, L2_2, L3_2, L4_2)
    L0_2 = pcall
    L1_2 = EnsureIndex
    L2_2 = "apex_phone_conversations"
    L3_2 = "ax_community"
    L4_2 = {}
    L5_2 = "community_id"
    L4_2[1] = L5_2
    L0_2(L1_2, L2_2, L3_2, L4_2)
  end
  L0_2 = true
  L32_1 = L0_2
  L0_2 = Dbg
  L1_2 = "recado"
  L2_2 = "social: tables ready"
  L0_2(L1_2, L2_2)
end
L35_1(L36_1)
function L35_1()
  local L0_2, L1_2, L2_2
  L0_2 = L32_1
  if L0_2 then
    L0_2 = true
    return L0_2
  end
  L0_2 = GetGameTimer
  L0_2 = L0_2()
  while true do
    L1_2 = L32_1
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
  L1_2 = L32_1
  return L1_2
end
function L36_1(A0_2, A1_2)
  local L2_2, L3_2
  L2_2 = RPC
  function L3_2(A0_3, A1_3)
    local L2_3, L3_3, L4_3, L5_3, L6_3, L7_3, L8_3
    L2_3 = L0_1
    L2_3 = L2_3()
    L2_3 = L2_3.enabled
    if false == L2_3 then
      L2_3 = L3_1
      L3_3 = "disabled"
      return L2_3(L3_3)
    end
    L2_3 = L35_1
    L2_3 = L2_3()
    if not L2_3 then
      L2_3 = L3_1
      L3_3 = "db"
      return L2_3(L3_3)
    end
    L2_3 = type
    L3_3 = A1_3
    L2_3 = L2_3(L3_3)
    if "table" ~= L2_3 then
      L2_3 = {}
      A1_3 = L2_3
    end
    L2_3 = L16_1
    L3_3 = A0_3
    L2_3, L3_3 = L2_3(L3_3)
    if not L2_3 then
      L4_3 = L3_1
      L5_3 = "noidentity"
      return L4_3(L5_3)
    end
    L4_3 = A1_2
    L5_3 = A0_3
    L6_3 = A1_3
    L7_3 = L2_3
    L8_3 = L3_3
    return L4_3(L5_3, L6_3, L7_3, L8_3)
  end
  L2_2[A0_2] = L3_2
end
L37_1 = {}
L37_1.indigo = true
L37_1.ciano = true
L37_1.aurora = true
L37_1.coral = true
L37_1.menta = true
L37_1.ambar = true
L37_1.grafite = true
L37_1.ameixa = true
L37_1.oceano = true
L37_1.rosa = true
L38_1 = {}
L38_1.sans = true
L38_1.serif = true
L38_1.mono = true
L38_1.bold = true
L38_1.round = true
L39_1 = {}
L39_1.text = true
L39_1.image = true
L39_1.audio = true
L39_1.sticker = true
L40_1 = {}
L40_1.contacts = true
L40_1.except = true
L40_1.only = true
L41_1 = "SELECT id, owner, owner_cid, kind, content, media_id, bg, font, duration, privacy, audience, mentions, reshare_of, created, expires FROM apex_phone_recado_status"
function L42_1()
  local L0_2, L1_2, L2_2, L3_2, L4_2, L5_2
  L0_2 = tonumber
  L1_2 = L0_1
  L1_2 = L1_2()
  L1_2 = L1_2.statusHours
  L0_2 = L0_2(L1_2)
  if not L0_2 then
    L0_2 = 24
  end
  L1_2 = math
  L1_2 = L1_2.max
  L2_2 = 1
  L3_2 = math
  L3_2 = L3_2.min
  L4_2 = 72
  L5_2 = L0_2
  L3_2 = L3_2(L4_2, L5_2)
  return L1_2(L2_2, L3_2)
end
function L43_1()
  local L0_2, L1_2, L2_2, L3_2, L4_2, L5_2, L6_2
  L0_2 = math
  L0_2 = L0_2.max
  L1_2 = 1
  L2_2 = math
  L2_2 = L2_2.min
  L3_2 = 200
  L4_2 = math
  L4_2 = L4_2.tointeger
  L5_2 = tonumber
  L6_2 = L0_1
  L6_2 = L6_2()
  L6_2 = L6_2.statusMaxPerDay
  L5_2, L6_2 = L5_2(L6_2)
  L4_2 = L4_2(L5_2, L6_2)
  if not L4_2 then
    L4_2 = 30
  end
  L2_2 = L2_2(L3_2, L4_2)
  return L0_2(L1_2, L2_2)
end
function L44_1(A0_2)
  local L1_2, L2_2, L3_2, L4_2
  L1_2 = {}
  L2_2 = math
  L2_2 = L2_2.tointeger
  L3_2 = tonumber
  L4_2 = A0_2.id
  L3_2, L4_2 = L3_2(L4_2)
  L2_2 = L2_2(L3_2, L4_2)
  L1_2.id = L2_2
  L2_2 = tostring
  L3_2 = A0_2.owner
  L2_2 = L2_2(L3_2)
  L1_2.owner = L2_2
  L2_2 = tostring
  L3_2 = A0_2.owner_cid
  L2_2 = L2_2(L3_2)
  L1_2.owner_cid = L2_2
  L2_2 = A0_2.kind
  if not L2_2 then
    L2_2 = "text"
  end
  L1_2.kind = L2_2
  L2_2 = A0_2.content
  L1_2.content = L2_2
  L2_2 = L1_1
  L3_2 = A0_2.media_id
  L2_2 = L2_2(L3_2)
  L1_2.mediaId = L2_2
  L2_2 = A0_2.bg
  L1_2.bg = L2_2
  L2_2 = A0_2.font
  L1_2.font = L2_2
  L2_2 = math
  L2_2 = L2_2.tointeger
  L3_2 = tonumber
  L4_2 = A0_2.duration
  L3_2, L4_2 = L3_2(L4_2)
  L2_2 = L2_2(L3_2, L4_2)
  L1_2.duration = L2_2
  L3_2 = A0_2.privacy
  L2_2 = L40_1
  L2_2 = L2_2[L3_2]
  if L2_2 then
    L2_2 = A0_2.privacy
    if L2_2 then
      goto lbl_49
    end
  end
  L2_2 = "contacts"
  ::lbl_49::
  L1_2.privacy = L2_2
  L2_2 = L11_1
  L3_2 = A0_2.audience
  L2_2 = L2_2(L3_2)
  if not L2_2 then
    L2_2 = {}
  end
  L1_2.audienceT = L2_2
  L2_2 = L11_1
  L3_2 = A0_2.mentions
  L2_2 = L2_2(L3_2)
  if not L2_2 then
    L2_2 = {}
  end
  L1_2.mentionsT = L2_2
  L2_2 = L1_1
  L3_2 = A0_2.reshare_of
  L2_2 = L2_2(L3_2)
  L1_2.reshareOf = L2_2
  L2_2 = tonumber
  L3_2 = A0_2.created
  L2_2 = L2_2(L3_2)
  L1_2.created = L2_2
  L2_2 = tonumber
  L3_2 = A0_2.expires
  L2_2 = L2_2(L3_2)
  L1_2.expires = L2_2
  return L1_2
end
function L45_1(A0_2, A1_2)
  local L2_2, L3_2
  L2_2 = {}
  L3_2 = A0_2.id
  L2_2.id = L3_2
  L3_2 = A0_2.owner
  L2_2.owner = L3_2
  L3_2 = A0_2.kind
  L2_2.kind = L3_2
  L3_2 = A0_2.content
  L2_2.content = L3_2
  L3_2 = A0_2.mediaId
  L2_2.mediaId = L3_2
  L3_2 = A0_2.bg
  L2_2.bg = L3_2
  L3_2 = A0_2.font
  L2_2.font = L3_2
  L3_2 = A0_2.duration
  L2_2.duration = L3_2
  L3_2 = A0_2.created
  L2_2.created = L3_2
  L3_2 = A0_2.expires
  L2_2.expires = L3_2
  L3_2 = A0_2.reshareOf
  L2_2.reshareOf = L3_2
  L3_2 = A1_2 or L3_2
  if not A1_2 then
    L3_2 = nil
  end
  L2_2.mine = L3_2
  if A1_2 then
    L3_2 = A0_2.privacy
    L2_2.privacy = L3_2
    L3_2 = A0_2.audienceT
    L3_2 = #L3_2
    if L3_2 > 0 then
      L3_2 = A0_2.audienceT
      L2_2.audience = L3_2
    end
    L3_2 = A0_2.mentionsT
    L3_2 = #L3_2
    if L3_2 > 0 then
      L3_2 = A0_2.mentionsT
      L2_2.mentions = L3_2
    end
  end
  return L2_2
end
function L46_1(A0_2, A1_2, A2_2)
  local L3_2, L4_2, L5_2, L6_2
  L3_2 = L13_1
  L4_2 = A0_2.mentionsT
  L5_2 = A1_2
  L3_2 = L3_2(L4_2, L5_2)
  L4_2 = A0_2.privacy
  if "only" == L4_2 then
    L4_2 = L13_1
    L5_2 = A0_2.audienceT
    L6_2 = A1_2
    L4_2 = L4_2(L5_2, L6_2)
    if not L4_2 then
      L4_2 = L3_2
    end
    return L4_2
  end
  L4_2 = A0_2.privacy
  if "except" == L4_2 then
    L4_2 = L13_1
    L5_2 = A0_2.audienceT
    L6_2 = A1_2
    L4_2 = L4_2(L5_2, L6_2)
    if L4_2 then
      L4_2 = false
      return L4_2
    end
  end
  L4_2 = A2_2 or L4_2
  if not A2_2 then
    L4_2 = L3_2
  end
  return L4_2
end
function L47_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2, L6_2
  L2_2 = type
  L3_2 = RecadoCanSee
  L2_2 = L2_2(L3_2)
  if "function" ~= L2_2 then
    L2_2 = true
    return L2_2
  end
  L2_2 = pcall
  L3_2 = RecadoCanSee
  L4_2 = A0_2
  L5_2 = A1_2
  L6_2 = "status"
  L2_2, L3_2 = L2_2(L3_2, L4_2, L5_2, L6_2)
  L4_2 = not L2_2 or false ~= L3_2
  return L4_2
end
function L48_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2
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
function L49_1(A0_2)
  local L1_2, L2_2, L3_2, L4_2, L5_2
  L1_2 = MySQL
  L1_2 = L1_2.single
  L1_2 = L1_2.await
  L2_2 = L41_1
  L3_2 = " WHERE id = ? AND expires > ?"
  L2_2 = L2_2 .. L3_2
  L3_2 = {}
  L4_2 = A0_2
  L5_2 = Now
  L5_2 = L5_2()
  L3_2[1] = L4_2
  L3_2[2] = L5_2
  L1_2 = L1_2(L2_2, L3_2)
  if L1_2 then
    L2_2 = L44_1
    L3_2 = L1_2
    L2_2 = L2_2(L3_2)
    if L2_2 then
      goto lbl_22
    end
  end
  L2_2 = nil
  ::lbl_22::
  return L2_2
end
function L50_1(A0_2, A1_2, A2_2)
  local L3_2, L4_2, L5_2, L6_2, L7_2
  L3_2 = A0_2.owner
  if L3_2 == A1_2 then
    L3_2 = true
    return L3_2
  end
  L3_2 = L48_1
  L4_2 = A0_2.owner_cid
  L5_2 = A1_2
  L3_2 = L3_2(L4_2, L5_2)
  if not L3_2 then
    L3_2 = L48_1
    L4_2 = A2_2
    L5_2 = A0_2.owner
    L3_2 = L3_2(L4_2, L5_2)
    if not L3_2 then
      goto lbl_20
    end
  end
  L3_2 = false
  do return L3_2 end
  ::lbl_20::
  L3_2 = L47_1
  L4_2 = A1_2
  L5_2 = A0_2.owner
  L3_2 = L3_2(L4_2, L5_2)
  if not L3_2 then
    L3_2 = false
    return L3_2
  end
  L3_2 = MySQL
  L3_2 = L3_2.scalar
  L3_2 = L3_2.await
  L4_2 = "SELECT 1 FROM apex_phone_contacts WHERE owner = ? AND number = ? LIMIT 1"
  L5_2 = {}
  L6_2 = A0_2.owner_cid
  L7_2 = A1_2
  L5_2[1] = L6_2
  L5_2[2] = L7_2
  L3_2 = L3_2(L4_2, L5_2)
  L3_2 = nil ~= L3_2
  L4_2 = L46_1
  L5_2 = A0_2
  L6_2 = A1_2
  L7_2 = L3_2
  return L4_2(L5_2, L6_2, L7_2)
end
function L51_1(A0_2)
  local L1_2, L2_2, L3_2, L4_2
  L1_2 = MySQL
  L1_2 = L1_2.single
  L1_2 = L1_2.await
  L2_2 = "SELECT privacy, audience, muted FROM apex_phone_recado_status_prefs WHERE number = ?"
  L3_2 = {}
  L4_2 = A0_2
  L3_2[1] = L4_2
  L1_2 = L1_2(L2_2, L3_2)
  L2_2 = {}
  if L1_2 then
    L4_2 = L1_2.privacy
    L3_2 = L40_1
    L3_2 = L3_2[L4_2]
    if L3_2 then
      L3_2 = L1_2.privacy
      if L3_2 then
        goto lbl_23
      end
    end
  end
  L3_2 = "contacts"
  ::lbl_23::
  L2_2.privacy = L3_2
  if L1_2 then
    L3_2 = L11_1
    L4_2 = L1_2.audience
    L3_2 = L3_2(L4_2)
    if L3_2 then
      goto lbl_33
    end
  end
  L3_2 = {}
  ::lbl_33::
  L2_2.audience = L3_2
  if L1_2 then
    L3_2 = L11_1
    L4_2 = L1_2.muted
    L3_2 = L3_2(L4_2)
    if L3_2 then
      goto lbl_43
    end
  end
  L3_2 = {}
  ::lbl_43::
  L2_2.muted = L3_2
  return L2_2
end
function L52_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2
  L2_2 = MySQL
  L2_2 = L2_2.update
  L2_2 = L2_2.await
  L3_2 = [[
INSERT INTO apex_phone_recado_status_prefs (number, privacy, audience, muted, updated) VALUES (?, ?, ?, ?, ?)
        ON DUPLICATE KEY UPDATE privacy = VALUES(privacy), audience = VALUES(audience), muted = VALUES(muted), updated = VALUES(updated)]]
  L4_2 = {}
  L5_2 = A0_2
  L6_2 = A1_2.privacy
  L7_2 = L12_1
  L8_2 = A1_2.audience
  L7_2 = L7_2(L8_2)
  if not L7_2 then
    L7_2 = "[]"
  end
  L8_2 = L12_1
  L9_2 = A1_2.muted
  L8_2 = L8_2(L9_2)
  if not L8_2 then
    L8_2 = "[]"
  end
  L9_2 = Now
  L9_2 = L9_2()
  L4_2[1] = L5_2
  L4_2[2] = L6_2
  L4_2[3] = L7_2
  L4_2[4] = L8_2
  L4_2[5] = L9_2
  L2_2(L3_2, L4_2)
end
function L53_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2, L19_2, L20_2, L21_2, L22_2
  L2_2 = L19_1
  L2_2 = L2_2()
  L3_2 = {}
  L4_2 = pairs
  L5_2 = L2_2
  L4_2, L5_2, L6_2, L7_2 = L4_2(L5_2)
  for L8_2 in L4_2, L5_2, L6_2, L7_2 do
    L9_2 = A0_2.owner
    if L8_2 ~= L9_2 then
      L9_2 = #L3_2
      L9_2 = L9_2 + 1
      L3_2[L9_2] = L8_2
    end
  end
  L4_2 = #L3_2
  if 0 == L4_2 then
    return
  end
  L4_2 = {}
  L5_2 = {}
  L6_2 = pcall
  L7_2 = MySQL
  L7_2 = L7_2.query
  L7_2 = L7_2.await
  L8_2 = "SELECT owner FROM apex_phone_contacts WHERE number = ? LIMIT 2000"
  L9_2 = {}
  L10_2 = A0_2.owner
  L9_2[1] = L10_2
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
        L14_2 = tostring
        L15_2 = L13_2.owner
        L14_2 = L14_2(L15_2)
        L4_2[L14_2] = true
      end
    end
  end
  L8_2 = 1
  L9_2 = #L3_2
  L10_2 = 200
  for L11_2 = L8_2, L9_2, L10_2 do
    L12_2 = {}
    L13_2 = A0_2.owner_cid
    L12_2[1] = L13_2
    L13_2 = L11_2
    L14_2 = math
    L14_2 = L14_2.min
    L15_2 = #L3_2
    L16_2 = L11_2 + 199
    L14_2 = L14_2(L15_2, L16_2)
    L15_2 = 1
    for L16_2 = L13_2, L14_2, L15_2 do
      L17_2 = #L12_2
      L17_2 = L17_2 + 1
      L18_2 = L3_2[L16_2]
      L12_2[L17_2] = L18_2
    end
    L13_2 = pcall
    L14_2 = MySQL
    L14_2 = L14_2.query
    L14_2 = L14_2.await
    L15_2 = "SELECT number FROM apex_phone_contacts WHERE owner = ? AND number IN (%s)"
    L16_2 = L15_2
    L15_2 = L15_2.format
    L17_2 = L2_1
    L18_2 = #L12_2
    L18_2 = L18_2 - 1
    L17_2, L18_2, L19_2, L20_2, L21_2, L22_2 = L17_2(L18_2)
    L15_2 = L15_2(L16_2, L17_2, L18_2, L19_2, L20_2, L21_2, L22_2)
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
          L21_2 = tostring
          L22_2 = L20_2.number
          L21_2 = L21_2(L22_2)
          L5_2[L21_2] = true
        end
      end
    end
  end
  L8_2 = 0
  L9_2 = ipairs
  L10_2 = L3_2
  L9_2, L10_2, L11_2, L12_2 = L9_2(L10_2)
  for L13_2, L14_2 in L9_2, L10_2, L11_2, L12_2 do
    L15_2 = L2_2[L14_2]
    L16_2 = L15_2 or L16_2
    if L15_2 then
      L16_2 = GetCid
      L17_2 = L15_2
      L16_2 = L16_2(L17_2)
    end
    if L16_2 then
      L17_2 = tostring
      L18_2 = L16_2
      L17_2 = L17_2(L18_2)
      L16_2 = L17_2
      L17_2 = L4_2[L16_2]
      if not L17_2 then
        L17_2 = L13_1
        L18_2 = A0_2.mentionsT
        L19_2 = L14_2
        L17_2 = L17_2(L18_2, L19_2)
        if not L17_2 then
          goto lbl_187
        end
      end
      L17_2 = L46_1
      L18_2 = A0_2
      L19_2 = L14_2
      L20_2 = L5_2[L14_2]
      L20_2 = true == L20_2
      L17_2 = L17_2(L18_2, L19_2, L20_2)
      if L17_2 then
        L17_2 = L48_1
        L18_2 = A0_2.owner_cid
        L19_2 = L14_2
        L17_2 = L17_2(L18_2, L19_2)
        if not L17_2 then
          L17_2 = L48_1
          L18_2 = L16_2
          L19_2 = A0_2.owner
          L17_2 = L17_2(L18_2, L19_2)
          if not L17_2 then
            L17_2 = L47_1
            L18_2 = L14_2
            L19_2 = A0_2.owner
            L17_2 = L17_2(L18_2, L19_2)
            if L17_2 then
              L17_2 = HasPhoneItem
              L18_2 = L15_2
              L17_2 = L17_2(L18_2)
              if L17_2 then
                L17_2 = Push
                L18_2 = L15_2
                L19_2 = "recadoStatus"
                L20_2 = {}
                L21_2 = A0_2.owner
                L20_2.owner = L21_2
                L21_2 = A0_2.id
                L20_2.id = L21_2
                L20_2.action = A1_2
                L17_2(L18_2, L19_2, L20_2)
                L8_2 = L8_2 + 1
                L17_2 = 300
                if L8_2 >= L17_2 then
                  break
                end
              end
            end
          end
        end
      end
    end
    ::lbl_187::
  end
end
L54_1 = L36_1
L55_1 = "recado.status.list"
function L56_1(A0_2, A1_2, A2_2, A3_2)
  local L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2, L19_2, L20_2, L21_2, L22_2, L23_2, L24_2, L25_2, L26_2, L27_2, L28_2, L29_2, L30_2, L31_2, L32_2, L33_2, L34_2, L35_2, L36_2, L37_2, L38_2, L39_2
  L4_2 = Now
  L4_2 = L4_2()
  L5_2 = MySQL
  L5_2 = L5_2.query
  L5_2 = L5_2.await
  L6_2 = "SELECT number, name FROM apex_phone_contacts WHERE owner = ? LIMIT 1000"
  L7_2 = {}
  L8_2 = A3_2
  L7_2[1] = L8_2
  L5_2 = L5_2(L6_2, L7_2)
  if not L5_2 then
    L5_2 = {}
  end
  L6_2 = {}
  L7_2 = {}
  L8_2 = {}
  L9_2 = ipairs
  L10_2 = L5_2
  L9_2, L10_2, L11_2, L12_2 = L9_2(L10_2)
  for L13_2, L14_2 in L9_2, L10_2, L11_2, L12_2 do
    L15_2 = tostring
    L16_2 = L14_2.number
    L15_2 = L15_2(L16_2)
    if L15_2 ~= A2_2 then
      L16_2 = L8_2[L15_2]
      if not L16_2 then
        L8_2[L15_2] = true
        L16_2 = #L7_2
        L16_2 = L16_2 + 1
        L7_2[L16_2] = L15_2
        L16_2 = L14_2.name
        L6_2[L15_2] = L16_2
      end
    end
  end
  L9_2 = L51_1
  L10_2 = A2_2
  L9_2 = L9_2(L10_2)
  L10_2 = {}
  L11_2 = ipairs
  L12_2 = L9_2.muted
  L11_2, L12_2, L13_2, L14_2 = L11_2(L12_2)
  for L15_2, L16_2 in L11_2, L12_2, L13_2, L14_2 do
    L17_2 = tostring
    L18_2 = L16_2
    L17_2 = L17_2(L18_2)
    L10_2[L17_2] = true
  end
  L11_2 = {}
  L12_2 = ipairs
  L13_2 = MySQL
  L13_2 = L13_2.query
  L13_2 = L13_2.await
  L14_2 = L41_1
  L15_2 = " WHERE owner = ? AND expires > ? ORDER BY id ASC"
  L14_2 = L14_2 .. L15_2
  L15_2 = {}
  L16_2 = A2_2
  L17_2 = L4_2
  L15_2[1] = L16_2
  L15_2[2] = L17_2
  L13_2 = L13_2(L14_2, L15_2)
  if not L13_2 then
    L13_2 = {}
  end
  L12_2, L13_2, L14_2, L15_2 = L12_2(L13_2)
  for L16_2, L17_2 in L12_2, L13_2, L14_2, L15_2 do
    L18_2 = #L11_2
    L18_2 = L18_2 + 1
    L19_2 = L44_1
    L20_2 = L17_2
    L19_2 = L19_2(L20_2)
    L11_2[L18_2] = L19_2
  end
  L12_2 = {}
  L13_2 = {}
  function L14_2(A0_3)
    local L1_3, L2_3, L3_3
    L1_3 = L44_1
    L2_3 = A0_3
    L1_3 = L1_3(L2_3)
    L2_3 = L1_3.owner
    L3_3 = A2_2
    if L2_3 ~= L3_3 then
      L3_3 = L1_3.id
      L2_3 = L13_2
      L2_3 = L2_3[L3_3]
      if not L2_3 then
        L3_3 = L1_3.id
        L2_3 = L13_2
        L2_3[L3_3] = L1_3
        L2_3 = L12_2
        L2_3 = #L2_3
        L3_3 = L2_3 + 1
        L2_3 = L12_2
        L2_3[L3_3] = L1_3
      end
    end
  end
  L15_2 = 1
  L16_2 = #L7_2
  L17_2 = 200
  for L18_2 = L15_2, L16_2, L17_2 do
    L19_2 = {}
    L20_2 = L18_2
    L21_2 = math
    L21_2 = L21_2.min
    L22_2 = #L7_2
    L23_2 = L18_2 + 199
    L21_2 = L21_2(L22_2, L23_2)
    L22_2 = 1
    for L23_2 = L20_2, L21_2, L22_2 do
      L24_2 = #L19_2
      L24_2 = L24_2 + 1
      L25_2 = L7_2[L23_2]
      L19_2[L24_2] = L25_2
    end
    L20_2 = #L19_2
    L20_2 = L20_2 + 1
    L19_2[L20_2] = L4_2
    L20_2 = ipairs
    L21_2 = MySQL
    L21_2 = L21_2.query
    L21_2 = L21_2.await
    L22_2 = L41_1
    L23_2 = " WHERE owner IN (%s) AND expires > ? ORDER BY id ASC LIMIT 1500"
    L22_2 = L22_2 .. L23_2
    L23_2 = L22_2
    L22_2 = L22_2.format
    L24_2 = L2_1
    L25_2 = #L19_2
    L25_2 = L25_2 - 1
    L24_2, L25_2, L26_2, L27_2, L28_2, L29_2, L30_2, L31_2, L32_2, L33_2, L34_2, L35_2, L36_2, L37_2, L38_2, L39_2 = L24_2(L25_2)
    L22_2 = L22_2(L23_2, L24_2, L25_2, L26_2, L27_2, L28_2, L29_2, L30_2, L31_2, L32_2, L33_2, L34_2, L35_2, L36_2, L37_2, L38_2, L39_2)
    L23_2 = L19_2
    L21_2 = L21_2(L22_2, L23_2)
    if not L21_2 then
      L21_2 = {}
    end
    L20_2, L21_2, L22_2, L23_2 = L20_2(L21_2)
    for L24_2, L25_2 in L20_2, L21_2, L22_2, L23_2 do
      L26_2 = L14_2
      L27_2 = L25_2
      L26_2(L27_2)
    end
  end
  L15_2 = pcall
  L16_2 = MySQL
  L16_2 = L16_2.query
  L16_2 = L16_2.await
  L17_2 = L41_1
  L18_2 = " WHERE expires > ? AND owner <> ? AND mentions LIKE ? ORDER BY id ASC LIMIT 200"
  L17_2 = L17_2 .. L18_2
  L18_2 = {}
  L19_2 = L4_2
  L20_2 = A2_2
  L21_2 = "%\""
  L22_2 = L14_1
  L23_2 = A2_2
  L22_2 = L22_2(L23_2)
  L23_2 = "\"%"
  L21_2 = L21_2 .. L22_2 .. L23_2
  L18_2[1] = L19_2
  L18_2[2] = L20_2
  L18_2[3] = L21_2
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
        L23_2 = L14_2
        L24_2 = L22_2
        L23_2(L24_2)
      end
    end
  end
  L17_2 = {}
  L18_2 = {}
  L19_2 = ipairs
  L20_2 = L12_2
  L19_2, L20_2, L21_2, L22_2 = L19_2(L20_2)
  for L23_2, L24_2 in L19_2, L20_2, L21_2, L22_2 do
    L25_2 = L24_2.owner_cid
    L25_2 = L18_2[L25_2]
    if not L25_2 then
      L25_2 = L24_2.owner_cid
      L18_2[L25_2] = true
      L25_2 = #L17_2
      L25_2 = L25_2 + 1
      L26_2 = L24_2.owner_cid
      L17_2[L25_2] = L26_2
    end
  end
  L19_2 = {}
  L20_2 = {}
  L21_2 = 1
  L22_2 = #L17_2
  L23_2 = 200
  for L24_2 = L21_2, L22_2, L23_2 do
    L25_2 = {}
    L26_2 = L24_2
    L27_2 = math
    L27_2 = L27_2.min
    L28_2 = #L17_2
    L29_2 = L24_2 + 199
    L27_2 = L27_2(L28_2, L29_2)
    L28_2 = 1
    for L29_2 = L26_2, L27_2, L28_2 do
      L30_2 = #L25_2
      L30_2 = L30_2 + 1
      L31_2 = L17_2[L29_2]
      L25_2[L30_2] = L31_2
    end
    L26_2 = {}
    L27_2 = A2_2
    L26_2[1] = L27_2
    L27_2 = ipairs
    L28_2 = L25_2
    L27_2, L28_2, L29_2, L30_2 = L27_2(L28_2)
    for L31_2, L32_2 in L27_2, L28_2, L29_2, L30_2 do
      L33_2 = #L26_2
      L33_2 = L33_2 + 1
      L26_2[L33_2] = L32_2
    end
    L27_2 = pcall
    L28_2 = MySQL
    L28_2 = L28_2.query
    L28_2 = L28_2.await
    L29_2 = "SELECT DISTINCT owner FROM apex_phone_contacts WHERE number = ? AND owner IN (%s)"
    L30_2 = L29_2
    L29_2 = L29_2.format
    L31_2 = L2_1
    L32_2 = #L25_2
    L31_2, L32_2, L33_2, L34_2, L35_2, L36_2, L37_2, L38_2, L39_2 = L31_2(L32_2)
    L29_2 = L29_2(L30_2, L31_2, L32_2, L33_2, L34_2, L35_2, L36_2, L37_2, L38_2, L39_2)
    L30_2 = L26_2
    L27_2, L28_2 = L27_2(L28_2, L29_2, L30_2)
    if L27_2 then
      L29_2 = type
      L30_2 = L28_2
      L29_2 = L29_2(L30_2)
      if "table" == L29_2 then
        L29_2 = ipairs
        L30_2 = L28_2
        L29_2, L30_2, L31_2, L32_2 = L29_2(L30_2)
        for L33_2, L34_2 in L29_2, L30_2, L31_2, L32_2 do
          L35_2 = tostring
          L36_2 = L34_2.owner
          L35_2 = L35_2(L36_2)
          L19_2[L35_2] = true
        end
      end
    end
    L29_2 = pcall
    L30_2 = MySQL
    L30_2 = L30_2.query
    L30_2 = L30_2.await
    L31_2 = "SELECT owner FROM apex_phone_blocks WHERE number = ? AND owner IN (%s)"
    L32_2 = L31_2
    L31_2 = L31_2.format
    L33_2 = L2_1
    L34_2 = #L25_2
    L33_2, L34_2, L35_2, L36_2, L37_2, L38_2, L39_2 = L33_2(L34_2)
    L31_2 = L31_2(L32_2, L33_2, L34_2, L35_2, L36_2, L37_2, L38_2, L39_2)
    L32_2 = L26_2
    L29_2, L30_2 = L29_2(L30_2, L31_2, L32_2)
    if L29_2 then
      L31_2 = type
      L32_2 = L30_2
      L31_2 = L31_2(L32_2)
      if "table" == L31_2 then
        L31_2 = ipairs
        L32_2 = L30_2
        L31_2, L32_2, L33_2, L34_2 = L31_2(L32_2)
        for L35_2, L36_2 in L31_2, L32_2, L33_2, L34_2 do
          L37_2 = tostring
          L38_2 = L36_2.owner
          L37_2 = L37_2(L38_2)
          L20_2[L37_2] = true
        end
      end
    end
  end
  L21_2 = {}
  L22_2 = {}
  L23_2 = ipairs
  L24_2 = L12_2
  L23_2, L24_2, L25_2, L26_2 = L23_2(L24_2)
  for L27_2, L28_2 in L23_2, L24_2, L25_2, L26_2 do
    L29_2 = L28_2.owner
    L29_2 = L22_2[L29_2]
    if nil == L29_2 then
      L30_2 = L47_1
      L31_2 = A2_2
      L32_2 = L28_2.owner
      L30_2 = L30_2(L31_2, L32_2)
      L29_2 = L30_2
      L30_2 = L28_2.owner
      L22_2[L30_2] = L29_2
    end
    if L29_2 then
      L30_2 = L28_2.owner_cid
      L30_2 = L20_2[L30_2]
      if not L30_2 then
        L30_2 = L48_1
        L31_2 = A3_2
        L32_2 = L28_2.owner
        L30_2 = L30_2(L31_2, L32_2)
        if not L30_2 then
          L30_2 = L46_1
          L31_2 = L28_2
          L32_2 = A2_2
          L33_2 = L28_2.owner_cid
          L33_2 = L19_2[L33_2]
          L33_2 = true == L33_2
          L30_2 = L30_2(L31_2, L32_2, L33_2)
          if L30_2 then
            L30_2 = #L21_2
            L30_2 = L30_2 + 1
            L21_2[L30_2] = L28_2
          end
        end
      end
    end
  end
  L23_2 = {}
  L24_2 = #L21_2
  if L24_2 > 0 then
    L24_2 = {}
    L25_2 = A2_2
    L24_2[1] = L25_2
    L25_2 = ipairs
    L26_2 = L21_2
    L25_2, L26_2, L27_2, L28_2 = L25_2(L26_2)
    for L29_2, L30_2 in L25_2, L26_2, L27_2, L28_2 do
      L31_2 = #L24_2
      L31_2 = L31_2 + 1
      L32_2 = L30_2.id
      L24_2[L31_2] = L32_2
    end
    L25_2 = ipairs
    L26_2 = MySQL
    L26_2 = L26_2.query
    L26_2 = L26_2.await
    L27_2 = "SELECT status_id, liked FROM apex_phone_recado_status_views WHERE viewer = ? AND status_id IN (%s)"
    L28_2 = L27_2
    L27_2 = L27_2.format
    L29_2 = L2_1
    L30_2 = #L21_2
    L29_2, L30_2, L31_2, L32_2, L33_2, L34_2, L35_2, L36_2, L37_2, L38_2, L39_2 = L29_2(L30_2)
    L27_2 = L27_2(L28_2, L29_2, L30_2, L31_2, L32_2, L33_2, L34_2, L35_2, L36_2, L37_2, L38_2, L39_2)
    L28_2 = L24_2
    L26_2 = L26_2(L27_2, L28_2)
    if not L26_2 then
      L26_2 = {}
    end
    L25_2, L26_2, L27_2, L28_2 = L25_2(L26_2)
    for L29_2, L30_2 in L25_2, L26_2, L27_2, L28_2 do
      L31_2 = math
      L31_2 = L31_2.tointeger
      L32_2 = tonumber
      L33_2 = L30_2.status_id
      L32_2, L33_2, L34_2, L35_2, L36_2, L37_2, L38_2, L39_2 = L32_2(L33_2)
      L31_2 = L31_2(L32_2, L33_2, L34_2, L35_2, L36_2, L37_2, L38_2, L39_2)
      if not L31_2 then
        L31_2 = 0
      end
      L32_2 = {}
      L33_2 = tonumber
      L34_2 = L30_2.liked
      L33_2 = L33_2(L34_2)
      if not L33_2 then
        L33_2 = 0
      end
      L33_2 = 1 == L33_2
      L32_2.liked = L33_2
      L23_2[L31_2] = L32_2
    end
  end
  L24_2 = {}
  L25_2 = #L11_2
  if L25_2 > 0 then
    L25_2 = {}
    L26_2 = ipairs
    L27_2 = L11_2
    L26_2, L27_2, L28_2, L29_2 = L26_2(L27_2)
    for L30_2, L31_2 in L26_2, L27_2, L28_2, L29_2 do
      L32_2 = #L25_2
      L32_2 = L32_2 + 1
      L33_2 = L31_2.id
      L25_2[L32_2] = L33_2
    end
    L26_2 = ipairs
    L27_2 = MySQL
    L27_2 = L27_2.query
    L27_2 = L27_2.await
    L28_2 = "SELECT status_id, COUNT(*) AS n, SUM(liked) AS l FROM apex_phone_recado_status_views WHERE status_id IN (%s) GROUP BY status_id"
    L29_2 = L28_2
    L28_2 = L28_2.format
    L30_2 = L2_1
    L31_2 = #L25_2
    L30_2, L31_2, L32_2, L33_2, L34_2, L35_2, L36_2, L37_2, L38_2, L39_2 = L30_2(L31_2)
    L28_2 = L28_2(L29_2, L30_2, L31_2, L32_2, L33_2, L34_2, L35_2, L36_2, L37_2, L38_2, L39_2)
    L29_2 = L25_2
    L27_2 = L27_2(L28_2, L29_2)
    if not L27_2 then
      L27_2 = {}
    end
    L26_2, L27_2, L28_2, L29_2 = L26_2(L27_2)
    for L30_2, L31_2 in L26_2, L27_2, L28_2, L29_2 do
      L32_2 = math
      L32_2 = L32_2.tointeger
      L33_2 = tonumber
      L34_2 = L31_2.status_id
      L33_2, L34_2, L35_2, L36_2, L37_2, L38_2, L39_2 = L33_2(L34_2)
      L32_2 = L32_2(L33_2, L34_2, L35_2, L36_2, L37_2, L38_2, L39_2)
      if not L32_2 then
        L32_2 = 0
      end
      L33_2 = {}
      L34_2 = math
      L34_2 = L34_2.tointeger
      L35_2 = tonumber
      L36_2 = L31_2.n
      L35_2 = L35_2(L36_2)
      if not L35_2 then
        L35_2 = 0
      end
      L34_2 = L34_2(L35_2)
      if not L34_2 then
        L34_2 = 0
      end
      L33_2.views = L34_2
      L34_2 = math
      L34_2 = L34_2.tointeger
      L35_2 = tonumber
      L36_2 = L31_2.l
      L35_2 = L35_2(L36_2)
      if not L35_2 then
        L35_2 = 0
      end
      L34_2 = L34_2(L35_2)
      if not L34_2 then
        L34_2 = 0
      end
      L33_2.likes = L34_2
      L24_2[L32_2] = L33_2
    end
  end
  L25_2 = {}
  L26_2 = ipairs
  L27_2 = L11_2
  L26_2, L27_2, L28_2, L29_2 = L26_2(L27_2)
  for L30_2, L31_2 in L26_2, L27_2, L28_2, L29_2 do
    L32_2 = L45_1
    L33_2 = L31_2
    L34_2 = true
    L32_2 = L32_2(L33_2, L34_2)
    L33_2 = L31_2.id
    L33_2 = L24_2[L33_2]
    if not L33_2 then
      L33_2 = {}
      L33_2.views = 0
      L33_2.likes = 0
    end
    L34_2 = L33_2.views
    L35_2 = L33_2.likes
    L32_2.likes = L35_2
    L32_2.views = L34_2
    L34_2 = #L25_2
    L34_2 = L34_2 + 1
    L25_2[L34_2] = L32_2
  end
  L26_2 = {}
  L27_2 = {}
  L28_2 = ipairs
  L29_2 = L21_2
  L28_2, L29_2, L30_2, L31_2 = L28_2(L29_2)
  for L32_2, L33_2 in L28_2, L29_2, L30_2, L31_2 do
    L34_2 = L33_2.owner
    L34_2 = L26_2[L34_2]
    if not L34_2 then
      L35_2 = {}
      L36_2 = L33_2.owner
      L35_2.number = L36_2
      L36_2 = L33_2.owner
      L36_2 = L6_2[L36_2]
      if not L36_2 then
        L36_2 = L30_1
        L37_2 = L33_2.owner
        L36_2 = L36_2(L37_2)
      end
      L35_2.name = L36_2
      L36_2 = {}
      L35_2.items = L36_2
      L35_2.allSeen = true
      L35_2.last = 0
      L36_2 = L33_2.owner
      L36_2 = L10_2[L36_2]
      if not L36_2 then
        L36_2 = nil
      end
      L35_2.muted = L36_2
      L34_2 = L35_2
      L35_2 = L33_2.owner
      L26_2[L35_2] = L34_2
      L35_2 = #L27_2
      L35_2 = L35_2 + 1
      L27_2[L35_2] = L34_2
    end
    L35_2 = L45_1
    L36_2 = L33_2
    L37_2 = false
    L35_2 = L35_2(L36_2, L37_2)
    L36_2 = L33_2.id
    L36_2 = L23_2[L36_2]
    L37_2 = nil ~= L36_2
    L35_2.viewed = L37_2
    if L36_2 then
      L37_2 = L36_2.liked
      if L37_2 then
        goto lbl_590
      end
    end
    L37_2 = nil
    ::lbl_590::
    L35_2.liked = L37_2
    L37_2 = L13_1
    L38_2 = L33_2.mentionsT
    L39_2 = A2_2
    L37_2 = L37_2(L38_2, L39_2)
    if not L37_2 then
      L37_2 = nil
    end
    L35_2.mentionedMe = L37_2
    if not L36_2 then
      L34_2.allSeen = false
    end
    L37_2 = L33_2.created
    if not L37_2 then
      L37_2 = 0
    end
    L38_2 = L34_2.last
    if L37_2 > L38_2 then
      L37_2 = L33_2.created
      if not L37_2 then
        L37_2 = 0
      end
      L34_2.last = L37_2
    end
    L37_2 = L34_2.items
    L38_2 = L34_2.items
    L38_2 = #L38_2
    L38_2 = L38_2 + 1
    L37_2[L38_2] = L35_2
  end
  L28_2 = table
  L28_2 = L28_2.sort
  L29_2 = L27_2
  function L30_2(A0_3, A1_3)
    local L2_3, L3_3
    L2_3 = A0_3.allSeen
    L3_3 = A1_3.allSeen
    if L2_3 ~= L3_3 then
      L2_3 = A0_3.allSeen
      L2_3 = not L2_3
      return L2_3
    end
    L2_3 = A0_3.last
    if not L2_3 then
      L2_3 = 0
    end
    L3_3 = A1_3.last
    if not L3_3 then
      L3_3 = 0
    end
    L2_3 = L2_3 > L3_3
    return L2_3
  end
  L28_2(L29_2, L30_2)
  L28_2 = {}
  L28_2.ok = true
  L29_2 = {}
  L29_2.items = L25_2
  L30_2 = {}
  L31_2 = L9_2.privacy
  L30_2.privacy = L31_2
  L31_2 = L9_2.audience
  L30_2.audience = L31_2
  L29_2.prefs = L30_2
  L28_2.mine = L29_2
  L28_2.updates = L27_2
  L29_2 = L42_1
  L29_2 = L29_2()
  L28_2.hours = L29_2
  L29_2 = L43_1
  L29_2 = L29_2()
  L28_2.maxPerDay = L29_2
  return L28_2
end
L54_1(L55_1, L56_1)
function L54_1(A0_2, A1_2, A2_2, A3_2)
  local L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2, L19_2, L20_2, L21_2
  L4_2 = ipairs
  L5_2 = A3_2
  L4_2, L5_2, L6_2, L7_2 = L4_2(L5_2)
  for L8_2, L9_2 in L4_2, L5_2, L6_2, L7_2 do
    if L8_2 > 10 then
      break
    end
    L10_2 = GetCitizenIdByNumber
    L11_2 = L9_2
    L10_2 = L10_2(L11_2)
    L11_2 = false
    L12_2 = type
    L13_2 = RecadoSilenceUnknown
    L12_2 = L12_2(L13_2)
    if "function" == L12_2 then
      L12_2 = pcall
      L13_2 = RecadoSilenceUnknown
      L14_2 = L9_2
      L15_2 = A1_2
      L12_2, L13_2 = L12_2(L13_2, L14_2, L15_2)
      L11_2 = L12_2 or L11_2
      L11_2 = L12_2 and true == L13_2
    end
    if L10_2 and not L11_2 then
      L12_2 = L48_1
      L13_2 = tostring
      L14_2 = L10_2
      L13_2 = L13_2(L14_2)
      L14_2 = A1_2
      L12_2 = L12_2(L13_2, L14_2)
      if not L12_2 then
        L12_2 = L48_1
        L13_2 = A2_2
        L14_2 = L9_2
        L12_2 = L12_2(L13_2, L14_2)
        if not L12_2 then
          L12_2 = L46_1
          L13_2 = A0_2
          L14_2 = L9_2
          L15_2 = true
          L12_2 = L12_2(L13_2, L14_2, L15_2)
          if L12_2 then
            L12_2 = L47_1
            L13_2 = L9_2
            L14_2 = A1_2
            L12_2 = L12_2(L13_2, L14_2)
            if L12_2 then
              L12_2 = L31_1
              L13_2 = tostring
              L14_2 = L10_2
              L13_2 = L13_2(L14_2)
              L14_2 = A1_2
              L12_2 = L12_2(L13_2, L14_2)
              L13_2 = NotifyCitizen
              L14_2 = tostring
              L15_2 = L10_2
              L14_2 = L14_2(L15_2)
              L15_2 = "recado"
              L16_2 = L12_2
              L17_2 = "Mencionou-te num estado"
              L18_2 = {}
              L18_2.app = "recado"
              L19_2 = A0_2.id
              L18_2.status = L19_2
              L18_2.owner = A1_2
              L18_2.mention = true
              L18_2.sys = "m"
              L19_2 = {}
              L20_2 = {}
              L21_2 = {}
              L21_2.id = "recado_status_view"
              L21_2.label = "Ver"
              L20_2[1] = L21_2
              L19_2.actions = L20_2
              L13_2(L14_2, L15_2, L16_2, L17_2, L18_2, L19_2)
            end
          end
        end
      end
    end
  end
end
function L55_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2
  L2_2 = #A1_2
  if 0 == L2_2 then
    return A1_2
  end
  L2_2 = {}
  L3_2 = A0_2
  L2_2[1] = L3_2
  L3_2 = ipairs
  L4_2 = A1_2
  L3_2, L4_2, L5_2, L6_2 = L3_2(L4_2)
  for L7_2, L8_2 in L3_2, L4_2, L5_2, L6_2 do
    L9_2 = #L2_2
    L9_2 = L9_2 + 1
    L2_2[L9_2] = L8_2
  end
  L3_2 = pcall
  L4_2 = MySQL
  L4_2 = L4_2.query
  L4_2 = L4_2.await
  L5_2 = "SELECT number FROM apex_phone_contacts WHERE owner = ? AND number IN (%s)"
  L6_2 = L5_2
  L5_2 = L5_2.format
  L7_2 = L2_1
  L8_2 = #A1_2
  L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2 = L7_2(L8_2)
  L5_2 = L5_2(L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2)
  L6_2 = L2_2
  L3_2, L4_2 = L3_2(L4_2, L5_2, L6_2)
  L5_2 = {}
  if L3_2 then
    L6_2 = type
    L7_2 = L4_2
    L6_2 = L6_2(L7_2)
    if "table" == L6_2 then
      L6_2 = ipairs
      L7_2 = L4_2
      L6_2, L7_2, L8_2, L9_2 = L6_2(L7_2)
      for L10_2, L11_2 in L6_2, L7_2, L8_2, L9_2 do
        L12_2 = tostring
        L13_2 = L11_2.number
        L12_2 = L12_2(L13_2)
        L5_2[L12_2] = true
      end
    end
  end
  L6_2 = {}
  L7_2 = ipairs
  L8_2 = A1_2
  L7_2, L8_2, L9_2, L10_2 = L7_2(L8_2)
  for L11_2, L12_2 in L7_2, L8_2, L9_2, L10_2 do
    L13_2 = L5_2[L12_2]
    if L13_2 then
      L13_2 = #L6_2
      L13_2 = L13_2 + 1
      L6_2[L13_2] = L12_2
    end
  end
  return L6_2
end
L56_1 = L36_1
L57_1 = "recado.status.add"
function L58_1(A0_2, A1_2, A2_2, A3_2)
  local L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2, L19_2, L20_2, L21_2, L22_2, L23_2, L24_2, L25_2, L26_2, L27_2, L28_2
  L4_2 = HasPhoneItem
  L5_2 = A0_2
  L4_2 = L4_2(L5_2)
  if not L4_2 then
    L4_2 = L3_1
    L5_2 = "nophone"
    return L4_2(L5_2)
  end
  L5_2 = A1_2.kind
  L4_2 = L39_1
  L4_2 = L4_2[L5_2]
  if L4_2 then
    L4_2 = A1_2.kind
    if L4_2 then
      goto lbl_19
    end
  end
  L4_2 = nil
  ::lbl_19::
  if not L4_2 then
    L5_2 = L3_1
    L6_2 = "badtype"
    return L5_2(L6_2)
  end
  L5_2 = L23_1
  L6_2 = A0_2
  L7_2 = "status.add"
  L8_2 = 2500
  L5_2 = L5_2(L6_2, L7_2, L8_2)
  if L5_2 then
    L5_2 = L3_1
    L6_2 = "cooldown"
    return L5_2(L6_2)
  end
  L5_2 = A1_2.privacy
  if nil == L5_2 then
    L5_2 = "contacts"
    if L5_2 then
      goto lbl_43
    end
  end
  L5_2 = A1_2.privacy
  ::lbl_43::
  L6_2 = L40_1
  L6_2 = L6_2[L5_2]
  if not L6_2 then
    L6_2 = L3_1
    L7_2 = "privacy"
    return L6_2(L7_2)
  end
  L6_2 = L10_1
  L7_2 = A1_2.list
  L8_2 = 256
  L9_2 = A2_2
  L6_2 = L6_2(L7_2, L8_2, L9_2)
  if not L6_2 then
    L7_2 = L3_1
    L8_2 = "privacy"
    return L7_2(L8_2)
  end
  if "contacts" == L5_2 then
    L7_2 = {}
    L6_2 = L7_2
  end
  if "only" == L5_2 then
    L7_2 = #L6_2
    if 0 == L7_2 then
      L7_2 = L3_1
      L8_2 = "privacy"
      return L7_2(L8_2)
    end
  end
  L7_2 = L10_1
  L8_2 = A1_2.mentions
  L9_2 = 10
  L10_2 = A2_2
  L7_2 = L7_2(L8_2, L9_2, L10_2)
  if not L7_2 then
    L8_2 = L3_1
    L9_2 = "invalid"
    return L8_2(L9_2)
  end
  L8_2 = L55_1
  L9_2 = A3_2
  L10_2 = L7_2
  L8_2 = L8_2(L9_2, L10_2)
  L7_2 = L8_2
  L8_2 = {}
  L8_2.kind = L4_2
  if "text" == L4_2 then
    L9_2 = L8_1
    L10_2 = A1_2.content
    L11_2 = 700
    L9_2 = L9_2(L10_2, L11_2)
    L8_2.content = L9_2
    L9_2 = L8_2.content
    if not L9_2 then
      L9_2 = L3_1
      L10_2 = "empty"
      return L9_2(L10_2)
    end
    L9_2 = A1_2.bg
    if nil == L9_2 then
      L9_2 = "indigo"
      if L9_2 then
        goto lbl_116
      end
    end
    L9_2 = A1_2.bg
    ::lbl_116::
    L8_2.bg = L9_2
    L10_2 = L8_2.bg
    L9_2 = L37_1
    L9_2 = L9_2[L10_2]
    if not L9_2 then
      L9_2 = L3_1
      L10_2 = "badbg"
      return L9_2(L10_2)
    end
    L9_2 = A1_2.font
    if nil == L9_2 then
      L9_2 = "sans"
      if L9_2 then
        goto lbl_133
      end
    end
    L9_2 = A1_2.font
    ::lbl_133::
    L8_2.font = L9_2
    L10_2 = L8_2.font
    L9_2 = L38_1
    L9_2 = L9_2[L10_2]
    if not L9_2 then
      L9_2 = L3_1
      L10_2 = "invalid"
      return L9_2(L10_2)
    end
  elseif "image" == L4_2 or "audio" == L4_2 then
    L9_2 = L28_1
    L10_2 = A3_2
    L11_2 = A1_2.mediaId
    L12_2 = L4_2
    L9_2, L10_2 = L9_2(L10_2, L11_2, L12_2)
    if not L9_2 then
      L11_2 = L3_1
      L12_2 = "media"
      return L11_2(L12_2)
    end
    L8_2.media = L9_2
    if "audio" == L4_2 then
      L11_2 = L10_2.duration
      L8_2.duration = L11_2
    end
    L11_2 = A1_2.content
    if nil ~= L11_2 then
      L11_2 = A1_2.content
      if "" ~= L11_2 then
        L11_2 = L8_1
        L12_2 = A1_2.content
        L13_2 = 700
        L11_2 = L11_2(L12_2, L13_2)
        L8_2.content = L11_2
      end
    end
    if "audio" ~= L4_2 then
      goto lbl_246
    end
    L11_2 = A1_2.bg
    if nil ~= L11_2 then
      L12_2 = A1_2.bg
      L11_2 = L37_1
      L11_2 = L11_2[L12_2]
      if L11_2 then
        L11_2 = A1_2.bg
        if L11_2 then
          goto lbl_189
        end
      end
    end
    L11_2 = "grafite"
    ::lbl_189::
    L8_2.bg = L11_2
  else
    L9_2 = type
    L10_2 = A1_2.content
    L9_2 = L9_2(L10_2)
    if "string" == L9_2 then
      L9_2 = A1_2.content
      if L9_2 then
        goto lbl_200
      end
    end
    L9_2 = ""
    ::lbl_200::
    L10_2 = #L9_2
    if not (L10_2 > 40) then
      L11_2 = L9_2
      L10_2 = L9_2.match
      L12_2 = "^[%w_%-]+:[%w_%-]+$"
      L10_2 = L10_2(L11_2, L12_2)
      if L10_2 then
        goto lbl_212
      end
    end
    L10_2 = L3_1
    L11_2 = "invalid"
    do return L10_2(L11_2) end
    ::lbl_212::
    L11_2 = L9_2
    L10_2 = L9_2.match
    L12_2 = "^([%w_%-]+):([%w_%-]+)$"
    L10_2, L11_2 = L10_2(L11_2, L12_2)
    L12_2 = type
    L13_2 = RecadoValidSticker
    L12_2 = L12_2(L13_2)
    if "function" == L12_2 then
      L12_2 = RecadoValidSticker
      L13_2 = {}
      L13_2.pack = L10_2
      L13_2.id = L11_2
      L12_2 = L12_2(L13_2)
      if not L12_2 then
        L12_2 = L3_1
        L13_2 = "invalid"
        return L12_2(L13_2)
      end
    end
    L8_2.content = L9_2
    L12_2 = A1_2.bg
    if nil ~= L12_2 then
      L13_2 = A1_2.bg
      L12_2 = L37_1
      L12_2 = L12_2[L13_2]
      if L12_2 then
        L12_2 = A1_2.bg
        if L12_2 then
          goto lbl_245
        end
      end
    end
    L12_2 = "grafite"
    ::lbl_245::
    L8_2.bg = L12_2
  end
  ::lbl_246::
  L9_2 = Now
  L9_2 = L9_2()
  L10_2 = tonumber
  L11_2 = MySQL
  L11_2 = L11_2.scalar
  L11_2 = L11_2.await
  L12_2 = "SELECT COUNT(*) FROM apex_phone_recado_status WHERE owner = ? AND created > ?"
  L13_2 = {}
  L14_2 = A2_2
  L15_2 = L9_2 - 86400000
  L13_2[1] = L14_2
  L13_2[2] = L15_2
  L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2, L19_2, L20_2, L21_2, L22_2, L23_2, L24_2, L25_2, L26_2, L27_2, L28_2 = L11_2(L12_2, L13_2)
  L10_2 = L10_2(L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2, L19_2, L20_2, L21_2, L22_2, L23_2, L24_2, L25_2, L26_2, L27_2, L28_2)
  if not L10_2 then
    L10_2 = 0
  end
  L11_2 = L43_1
  L11_2 = L11_2()
  if L10_2 >= L11_2 then
    L11_2 = L3_1
    L12_2 = "limit"
    L13_2 = {}
    L14_2 = L43_1
    L14_2 = L14_2()
    L13_2.max = L14_2
    return L11_2(L12_2, L13_2)
  end
  L11_2 = math
  L11_2 = L11_2.floor
  L12_2 = L42_1
  L12_2 = L12_2()
  L12_2 = L12_2 * 3600000
  L11_2 = L11_2(L12_2)
  L11_2 = L9_2 + L11_2
  L12_2 = L1_1
  L13_2 = MySQL
  L13_2 = L13_2.insert
  L13_2 = L13_2.await
  L14_2 = [[
INSERT INTO apex_phone_recado_status (owner, owner_cid, kind, content, media_id, bg, font, duration, privacy, audience, mentions, created, expires)
        VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)]]
  L15_2 = {}
  L16_2 = A2_2
  L17_2 = A3_2
  L18_2 = L4_2
  L19_2 = L8_2.content
  L20_2 = L8_2.media
  L21_2 = L8_2.bg
  L22_2 = L8_2.font
  L23_2 = L8_2.duration
  L24_2 = L5_2
  L25_2 = L12_1
  L26_2 = L6_2
  L25_2 = L25_2(L26_2)
  if not L25_2 then
    L25_2 = "[]"
  end
  L26_2 = L12_1
  L27_2 = L7_2
  L26_2 = L26_2(L27_2)
  if not L26_2 then
    L26_2 = "[]"
  end
  L27_2 = L9_2
  L28_2 = L11_2
  L15_2[1] = L16_2
  L15_2[2] = L17_2
  L15_2[3] = L18_2
  L15_2[4] = L19_2
  L15_2[5] = L20_2
  L15_2[6] = L21_2
  L15_2[7] = L22_2
  L15_2[8] = L23_2
  L15_2[9] = L24_2
  L15_2[10] = L25_2
  L15_2[11] = L26_2
  L15_2[12] = L27_2
  L15_2[13] = L28_2
  L13_2, L14_2, L15_2, L16_2, L17_2, L18_2, L19_2, L20_2, L21_2, L22_2, L23_2, L24_2, L25_2, L26_2, L27_2, L28_2 = L13_2(L14_2, L15_2)
  L12_2 = L12_2(L13_2, L14_2, L15_2, L16_2, L17_2, L18_2, L19_2, L20_2, L21_2, L22_2, L23_2, L24_2, L25_2, L26_2, L27_2, L28_2)
  if not L12_2 then
    L13_2 = L3_1
    L14_2 = "db"
    return L13_2(L14_2)
  end
  L13_2 = L51_1
  L14_2 = A2_2
  L13_2 = L13_2(L14_2)
  L14_2 = L5_2
  L13_2.audience = L6_2
  L13_2.privacy = L14_2
  L14_2 = pcall
  L15_2 = L52_1
  L16_2 = A2_2
  L17_2 = L13_2
  L14_2(L15_2, L16_2, L17_2)
  L14_2 = {}
  L14_2.id = L12_2
  L14_2.owner = A2_2
  L14_2.owner_cid = A3_2
  L14_2.kind = L4_2
  L15_2 = L8_2.content
  L14_2.content = L15_2
  L15_2 = L8_2.media
  L14_2.mediaId = L15_2
  L15_2 = L8_2.bg
  L14_2.bg = L15_2
  L15_2 = L8_2.font
  L14_2.font = L15_2
  L15_2 = L8_2.duration
  L14_2.duration = L15_2
  L14_2.privacy = L5_2
  L14_2.audienceT = L6_2
  L14_2.mentionsT = L7_2
  L14_2.created = L9_2
  L14_2.expires = L11_2
  L15_2 = #L7_2
  if L15_2 > 0 then
    L15_2 = pcall
    L16_2 = L54_1
    L17_2 = L14_2
    L18_2 = A2_2
    L19_2 = A3_2
    L20_2 = L7_2
    L15_2(L16_2, L17_2, L18_2, L19_2, L20_2)
  end
  L15_2 = pcall
  L16_2 = L53_1
  L17_2 = L14_2
  L18_2 = "add"
  L15_2(L16_2, L17_2, L18_2)
  L15_2 = Dbg
  L16_2 = "recado"
  L17_2 = "status %s (%s) from %s"
  L18_2 = L12_2
  L19_2 = L4_2
  L20_2 = A2_2
  L15_2(L16_2, L17_2, L18_2, L19_2, L20_2)
  L15_2 = L45_1
  L16_2 = L14_2
  L17_2 = true
  L15_2 = L15_2(L16_2, L17_2)
  L16_2 = true
  L17_2 = 0
  L15_2.likes = 0
  L15_2.views = L17_2
  L15_2.ok = L16_2
  return L15_2
end
L56_1(L57_1, L58_1)
L56_1 = L36_1
L57_1 = "recado.status.view"
function L58_1(A0_2, A1_2, A2_2, A3_2)
  local L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2
  L4_2 = L1_1
  L5_2 = A1_2.id
  L4_2 = L4_2(L5_2)
  if not L4_2 then
    L5_2 = L3_1
    L6_2 = "invalid"
    return L5_2(L6_2)
  end
  L5_2 = L49_1
  L6_2 = L4_2
  L5_2 = L5_2(L6_2)
  if L5_2 then
    L6_2 = L50_1
    L7_2 = L5_2
    L8_2 = A2_2
    L9_2 = A3_2
    L6_2 = L6_2(L7_2, L8_2, L9_2)
    if L6_2 then
      goto lbl_26
    end
  end
  L6_2 = L3_1
  L7_2 = "notfound"
  do return L6_2(L7_2) end
  ::lbl_26::
  L6_2 = L5_2.owner
  if L6_2 ~= A2_2 then
    L6_2 = MySQL
    L6_2 = L6_2.update
    L6_2 = L6_2.await
    L7_2 = "INSERT IGNORE INTO apex_phone_recado_status_views (status_id, viewer, liked, created) VALUES (?, ?, 0, ?)"
    L8_2 = {}
    L9_2 = L4_2
    L10_2 = A2_2
    L11_2 = Now
    L11_2 = L11_2()
    L8_2[1] = L9_2
    L8_2[2] = L10_2
    L8_2[3] = L11_2
    L6_2(L7_2, L8_2)
  end
  L6_2 = {}
  L6_2.ok = true
  L6_2.id = L4_2
  return L6_2
end
L56_1(L57_1, L58_1)
L56_1 = L36_1
L57_1 = "recado.status.like"
function L58_1(A0_2, A1_2, A2_2, A3_2)
  local L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2
  L4_2 = L1_1
  L5_2 = A1_2.id
  L4_2 = L4_2(L5_2)
  if not L4_2 then
    L5_2 = L3_1
    L6_2 = "invalid"
    return L5_2(L6_2)
  end
  L5_2 = L49_1
  L6_2 = L4_2
  L5_2 = L5_2(L6_2)
  if L5_2 then
    L6_2 = L50_1
    L7_2 = L5_2
    L8_2 = A2_2
    L9_2 = A3_2
    L6_2 = L6_2(L7_2, L8_2, L9_2)
    if L6_2 then
      goto lbl_26
    end
  end
  L6_2 = L3_1
  L7_2 = "notfound"
  do return L6_2(L7_2) end
  ::lbl_26::
  L6_2 = L5_2.owner
  if L6_2 == A2_2 then
    L6_2 = L3_1
    L7_2 = "invalid"
    return L6_2(L7_2)
  end
  L6_2 = L15_1
  L7_2 = A1_2.on
  L6_2 = L6_2(L7_2)
  if L6_2 then
    L6_2 = 1
    if L6_2 then
      goto lbl_42
    end
  end
  L6_2 = 0
  ::lbl_42::
  L7_2 = MySQL
  L7_2 = L7_2.update
  L7_2 = L7_2.await
  L8_2 = "INSERT INTO apex_phone_recado_status_views (status_id, viewer, liked, created) VALUES (?, ?, ?, ?) ON DUPLICATE KEY UPDATE liked = VALUES(liked)"
  L9_2 = {}
  L10_2 = L4_2
  L11_2 = A2_2
  L12_2 = L6_2
  L13_2 = Now
  L13_2 = L13_2()
  L9_2[1] = L10_2
  L9_2[2] = L11_2
  L9_2[3] = L12_2
  L9_2[4] = L13_2
  L7_2(L8_2, L9_2)
  L7_2 = L19_1
  L7_2 = L7_2()
  L8_2 = L5_2.owner
  L7_2 = L7_2[L8_2]
  if L7_2 and 1 == L6_2 then
    L8_2 = Push
    L9_2 = L7_2
    L10_2 = "recadoStatus"
    L11_2 = {}
    L12_2 = L5_2.owner
    L11_2.owner = L12_2
    L11_2.id = L4_2
    L11_2.action = "like"
    L11_2.by = A2_2
    L8_2(L9_2, L10_2, L11_2)
  end
  L8_2 = {}
  L8_2.ok = true
  L8_2.id = L4_2
  L9_2 = 1 == L6_2
  L8_2.liked = L9_2
  return L8_2
end
L56_1(L57_1, L58_1)
L56_1 = L36_1
L57_1 = "recado.status.viewers"
function L58_1(A0_2, A1_2, A2_2, A3_2)
  local L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2, L19_2, L20_2, L21_2, L22_2
  L4_2 = L1_1
  L5_2 = A1_2.id
  L4_2 = L4_2(L5_2)
  if not L4_2 then
    L5_2 = L3_1
    L6_2 = "invalid"
    return L5_2(L6_2)
  end
  L5_2 = L49_1
  L6_2 = L4_2
  L5_2 = L5_2(L6_2)
  if L5_2 then
    L6_2 = L5_2.owner
    if L6_2 == A2_2 then
      goto lbl_22
    end
  end
  L6_2 = L3_1
  L7_2 = "notfound"
  do return L6_2(L7_2) end
  ::lbl_22::
  L6_2 = MySQL
  L6_2 = L6_2.query
  L6_2 = L6_2.await
  L7_2 = "SELECT viewer, liked, created FROM apex_phone_recado_status_views WHERE status_id = ? ORDER BY created DESC LIMIT 500"
  L8_2 = {}
  L9_2 = L4_2
  L8_2[1] = L9_2
  L6_2 = L6_2(L7_2, L8_2)
  if not L6_2 then
    L6_2 = {}
  end
  L7_2 = {}
  L8_2 = ipairs
  L9_2 = L6_2
  L8_2, L9_2, L10_2, L11_2 = L8_2(L9_2)
  for L12_2, L13_2 in L8_2, L9_2, L10_2, L11_2 do
    L14_2 = #L7_2
    L14_2 = L14_2 + 1
    L15_2 = tostring
    L16_2 = L13_2.viewer
    L15_2 = L15_2(L16_2)
    L7_2[L14_2] = L15_2
  end
  L8_2 = L29_1
  L9_2 = A3_2
  L10_2 = L7_2
  L8_2 = L8_2(L9_2, L10_2)
  L9_2 = {}
  L10_2 = 0
  L11_2 = ipairs
  L12_2 = L6_2
  L11_2, L12_2, L13_2, L14_2 = L11_2(L12_2)
  for L15_2, L16_2 in L11_2, L12_2, L13_2, L14_2 do
    L17_2 = tostring
    L18_2 = L16_2.viewer
    L17_2 = L17_2(L18_2)
    L18_2 = tonumber
    L19_2 = L16_2.liked
    L18_2 = L18_2(L19_2)
    if not L18_2 then
      L18_2 = 0
    end
    L18_2 = 1 == L18_2
    if L18_2 then
      L10_2 = L10_2 + 1
    end
    L19_2 = #L9_2
    L19_2 = L19_2 + 1
    L20_2 = {}
    L20_2.number = L17_2
    L21_2 = L8_2[L17_2]
    if not L21_2 then
      L21_2 = L30_1
      L22_2 = L17_2
      L21_2 = L21_2(L22_2)
    end
    L20_2.name = L21_2
    L21_2 = L18_2 or L21_2
    if not L18_2 then
      L21_2 = nil
    end
    L20_2.liked = L21_2
    L21_2 = tonumber
    L22_2 = L16_2.created
    L21_2 = L21_2(L22_2)
    L20_2.at = L21_2
    L9_2[L19_2] = L20_2
  end
  L11_2 = {}
  L11_2.ok = true
  L11_2.id = L4_2
  L11_2.items = L9_2
  L12_2 = #L9_2
  L11_2.count = L12_2
  L11_2.likes = L10_2
  return L11_2
end
L56_1(L57_1, L58_1)
L56_1 = L36_1
L57_1 = "recado.status.delete"
function L58_1(A0_2, A1_2, A2_2)
  local L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2
  L3_2 = L1_1
  L4_2 = A1_2.id
  L3_2 = L3_2(L4_2)
  if not L3_2 then
    L4_2 = L3_1
    L5_2 = "invalid"
    return L4_2(L5_2)
  end
  L4_2 = L49_1
  L5_2 = L3_2
  L4_2 = L4_2(L5_2)
  L5_2 = tonumber
  L6_2 = MySQL
  L6_2 = L6_2.update
  L6_2 = L6_2.await
  L7_2 = "DELETE FROM apex_phone_recado_status WHERE id = ? AND owner = ?"
  L8_2 = {}
  L9_2 = L3_2
  L10_2 = A2_2
  L8_2[1] = L9_2
  L8_2[2] = L10_2
  L6_2, L7_2, L8_2, L9_2, L10_2 = L6_2(L7_2, L8_2)
  L5_2 = L5_2(L6_2, L7_2, L8_2, L9_2, L10_2)
  if not L5_2 then
    L5_2 = 0
  end
  if L5_2 < 1 then
    L6_2 = L3_1
    L7_2 = "notfound"
    return L6_2(L7_2)
  end
  L6_2 = MySQL
  L6_2 = L6_2.update
  L6_2 = L6_2.await
  L7_2 = "DELETE FROM apex_phone_recado_status_views WHERE status_id = ?"
  L8_2 = {}
  L9_2 = L3_2
  L8_2[1] = L9_2
  L6_2(L7_2, L8_2)
  if L4_2 then
    L6_2 = L4_2.mediaId
    if L6_2 then
      L6_2 = L26_1
      L7_2 = L4_2.mediaId
      L6_2(L7_2)
    end
  end
  if L4_2 then
    L6_2 = L4_2.owner
    if L6_2 == A2_2 then
      L6_2 = pcall
      L7_2 = L53_1
      L8_2 = L4_2
      L9_2 = "delete"
      L6_2(L7_2, L8_2, L9_2)
    end
  end
  L6_2 = {}
  L6_2.ok = true
  L6_2.id = L3_2
  return L6_2
end
L56_1(L57_1, L58_1)
L56_1 = {}
L56_1.image = "\240\159\147\183 Foto"
L56_1.audio = "\240\159\142\164 \195\129udio"
L56_1.sticker = "\226\156\168 Autocolante"
L57_1 = L36_1
L58_1 = "recado.status.reply"
function L59_1(A0_2, A1_2, A2_2, A3_2)
  local L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2
  L4_2 = HasPhoneItem
  L5_2 = A0_2
  L4_2 = L4_2(L5_2)
  if not L4_2 then
    L4_2 = L3_1
    L5_2 = "nophone"
    return L4_2(L5_2)
  end
  L4_2 = L1_1
  L5_2 = A1_2.id
  L4_2 = L4_2(L5_2)
  if not L4_2 then
    L5_2 = L3_1
    L6_2 = "invalid"
    return L5_2(L6_2)
  end
  L5_2 = L8_1
  L6_2 = A1_2.text
  L7_2 = 1000
  L5_2 = L5_2(L6_2, L7_2)
  if not L5_2 then
    L6_2 = L3_1
    L7_2 = "empty"
    return L6_2(L7_2)
  end
  L6_2 = L49_1
  L7_2 = L4_2
  L6_2 = L6_2(L7_2)
  if L6_2 then
    L7_2 = L50_1
    L8_2 = L6_2
    L9_2 = A2_2
    L10_2 = A3_2
    L7_2 = L7_2(L8_2, L9_2, L10_2)
    if L7_2 then
      goto lbl_45
    end
  end
  L7_2 = L3_1
  L8_2 = "notfound"
  do return L7_2(L8_2) end
  ::lbl_45::
  L7_2 = L6_2.owner
  if L7_2 == A2_2 then
    L7_2 = L3_1
    L8_2 = "invalid"
    return L7_2(L8_2)
  end
  L7_2 = L48_1
  L8_2 = A3_2
  L9_2 = L6_2.owner
  L7_2 = L7_2(L8_2, L9_2)
  if L7_2 then
    L7_2 = L3_1
    L8_2 = "blocked"
    return L7_2(L8_2)
  end
  L7_2 = {}
  L8_2 = L6_2.id
  L7_2.id = L8_2
  L8_2 = L6_2.owner
  L7_2.owner = L8_2
  L8_2 = L6_2.kind
  L7_2.kind = L8_2
  L8_2 = L6_2.bg
  L7_2.bg = L8_2
  L8_2 = L4_1
  L9_2 = L6_2.kind
  if "text" == L9_2 then
    L9_2 = L6_2.content
    if L9_2 then
      goto lbl_88
    end
    L9_2 = ""
    if L9_2 then
      goto lbl_88
    end
  end
  L10_2 = L6_2.kind
  L9_2 = L56_1
  L9_2 = L9_2[L10_2]
  if not L9_2 then
    L9_2 = ""
  end
  ::lbl_88::
  L10_2 = 90
  L8_2 = L8_2(L9_2, L10_2)
  L7_2.preview = L8_2
  L8_2 = nil
  L9_2 = type
  L10_2 = RPC
  L10_2 = L10_2["recado.send"]
  L9_2 = L9_2(L10_2)
  if "function" == L9_2 then
    L9_2 = RPC
    L9_2 = L9_2["recado.send"]
    L10_2 = A0_2
    L11_2 = {}
    L12_2 = L6_2.owner
    L11_2.number = L12_2
    L11_2.type = "text"
    L11_2.content = L5_2
    L12_2 = {}
    L12_2.status = L7_2
    L11_2.payload = L12_2
    L9_2 = L9_2(L10_2, L11_2)
    L8_2 = L9_2
  else
    L9_2 = type
    L10_2 = RPC
    L10_2 = L10_2["messages.send"]
    L9_2 = L9_2(L10_2)
    if "function" == L9_2 then
      L9_2 = RPC
      L9_2 = L9_2["messages.send"]
      L10_2 = A0_2
      L11_2 = {}
      L11_2.app = "recado"
      L12_2 = L6_2.owner
      L11_2.to = L12_2
      L11_2.type = "text"
      L11_2.content = L5_2
      L12_2 = {}
      L12_2.status = L7_2
      L11_2.payload = L12_2
      L9_2 = L9_2(L10_2, L11_2)
      L8_2 = L9_2
    else
      L9_2 = L3_1
      L10_2 = "nosend"
      return L9_2(L10_2)
    end
  end
  L9_2 = type
  L10_2 = L8_2
  L9_2 = L9_2(L10_2)
  if "table" == L9_2 then
    L9_2 = L8_2.error
    if not L9_2 then
      L9_2 = L8_2.ok
      if false ~= L9_2 then
        goto lbl_167
      end
    end
  end
  L9_2 = L3_1
  L10_2 = type
  L11_2 = L8_2
  L10_2 = L10_2(L11_2)
  if "table" == L10_2 then
    L10_2 = L8_2.error
    if L10_2 then
      goto lbl_165
    end
    L10_2 = "nosend"
    if L10_2 then
      goto lbl_165
    end
  end
  L10_2 = "nosend"
  ::lbl_165::
  do return L9_2(L10_2) end
  ::lbl_167::
  L9_2 = MySQL
  L9_2 = L9_2.update
  L9_2 = L9_2.await
  L10_2 = "INSERT IGNORE INTO apex_phone_recado_status_views (status_id, viewer, liked, created) VALUES (?, ?, 0, ?)"
  L11_2 = {}
  L12_2 = L4_2
  L13_2 = A2_2
  L14_2 = Now
  L14_2 = L14_2()
  L11_2[1] = L12_2
  L11_2[2] = L13_2
  L11_2[3] = L14_2
  L9_2(L10_2, L11_2)
  L9_2 = {}
  L9_2.ok = true
  L9_2.id = L4_2
  L10_2 = L6_2.owner
  L9_2.number = L10_2
  L10_2 = L8_2.message
  if not L10_2 then
    L10_2 = L8_2
  end
  L9_2.message = L10_2
  return L9_2
end
L57_1(L58_1, L59_1)
L57_1 = L36_1
L58_1 = "recado.status.reshare"
function L59_1(A0_2, A1_2, A2_2, A3_2)
  local L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2, L19_2, L20_2, L21_2, L22_2, L23_2, L24_2, L25_2, L26_2, L27_2, L28_2
  L4_2 = HasPhoneItem
  L5_2 = A0_2
  L4_2 = L4_2(L5_2)
  if not L4_2 then
    L4_2 = L3_1
    L5_2 = "nophone"
    return L4_2(L5_2)
  end
  L4_2 = L1_1
  L5_2 = A1_2.id
  L4_2 = L4_2(L5_2)
  if not L4_2 then
    L5_2 = L3_1
    L6_2 = "invalid"
    return L5_2(L6_2)
  end
  L5_2 = L49_1
  L6_2 = L4_2
  L5_2 = L5_2(L6_2)
  if L5_2 then
    L6_2 = L50_1
    L7_2 = L5_2
    L8_2 = A2_2
    L9_2 = A3_2
    L6_2 = L6_2(L7_2, L8_2, L9_2)
    if L6_2 then
      goto lbl_35
    end
  end
  L6_2 = L3_1
  L7_2 = "notfound"
  do return L6_2(L7_2) end
  ::lbl_35::
  L6_2 = L13_1
  L7_2 = L5_2.mentionsT
  L8_2 = A2_2
  L6_2 = L6_2(L7_2, L8_2)
  if not L6_2 then
    L6_2 = L3_1
    L7_2 = "notmentioned"
    return L6_2(L7_2)
  end
  L6_2 = L23_1
  L7_2 = A0_2
  L8_2 = "status.add"
  L9_2 = 2500
  L6_2 = L6_2(L7_2, L8_2, L9_2)
  if L6_2 then
    L6_2 = L3_1
    L7_2 = "cooldown"
    return L6_2(L7_2)
  end
  L6_2 = Now
  L6_2 = L6_2()
  L7_2 = tonumber
  L8_2 = MySQL
  L8_2 = L8_2.scalar
  L8_2 = L8_2.await
  L9_2 = "SELECT COUNT(*) FROM apex_phone_recado_status WHERE owner = ? AND created > ?"
  L10_2 = {}
  L11_2 = A2_2
  L12_2 = L6_2 - 86400000
  L10_2[1] = L11_2
  L10_2[2] = L12_2
  L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2, L19_2, L20_2, L21_2, L22_2, L23_2, L24_2, L25_2, L26_2, L27_2, L28_2 = L8_2(L9_2, L10_2)
  L7_2 = L7_2(L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2, L19_2, L20_2, L21_2, L22_2, L23_2, L24_2, L25_2, L26_2, L27_2, L28_2)
  if not L7_2 then
    L7_2 = 0
  end
  L8_2 = L43_1
  L8_2 = L8_2()
  if L7_2 >= L8_2 then
    L8_2 = L3_1
    L9_2 = "limit"
    L10_2 = {}
    L11_2 = L43_1
    L11_2 = L11_2()
    L10_2.max = L11_2
    return L8_2(L9_2, L10_2)
  end
  L8_2 = MySQL
  L8_2 = L8_2.scalar
  L8_2 = L8_2.await
  L9_2 = "SELECT id FROM apex_phone_recado_status WHERE owner = ? AND reshare_of = ? AND expires > ? LIMIT 1"
  L10_2 = {}
  L11_2 = A2_2
  L12_2 = L4_2
  L13_2 = L6_2
  L10_2[1] = L11_2
  L10_2[2] = L12_2
  L10_2[3] = L13_2
  L8_2 = L8_2(L9_2, L10_2)
  if L8_2 then
    L9_2 = L3_1
    L10_2 = "already"
    return L9_2(L10_2)
  end
  L9_2 = L51_1
  L10_2 = A2_2
  L9_2 = L9_2(L10_2)
  L10_2 = math
  L10_2 = L10_2.floor
  L11_2 = L42_1
  L11_2 = L11_2()
  L11_2 = L11_2 * 3600000
  L10_2 = L10_2(L11_2)
  L10_2 = L6_2 + L10_2
  L11_2 = L1_1
  L12_2 = MySQL
  L12_2 = L12_2.insert
  L12_2 = L12_2.await
  L13_2 = [[
INSERT INTO apex_phone_recado_status (owner, owner_cid, kind, content, media_id, bg, font, duration, privacy, audience, mentions, reshare_of, created, expires)
        VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)]]
  L14_2 = {}
  L15_2 = A2_2
  L16_2 = A3_2
  L17_2 = L5_2.kind
  L18_2 = L5_2.content
  L19_2 = L5_2.mediaId
  L20_2 = L5_2.bg
  L21_2 = L5_2.font
  L22_2 = L5_2.duration
  L23_2 = L9_2.privacy
  L24_2 = L12_1
  L25_2 = L9_2.audience
  L24_2 = L24_2(L25_2)
  if not L24_2 then
    L24_2 = "[]"
  end
  L25_2 = "[]"
  L26_2 = L4_2
  L27_2 = L6_2
  L28_2 = L10_2
  L14_2[1] = L15_2
  L14_2[2] = L16_2
  L14_2[3] = L17_2
  L14_2[4] = L18_2
  L14_2[5] = L19_2
  L14_2[6] = L20_2
  L14_2[7] = L21_2
  L14_2[8] = L22_2
  L14_2[9] = L23_2
  L14_2[10] = L24_2
  L14_2[11] = L25_2
  L14_2[12] = L26_2
  L14_2[13] = L27_2
  L14_2[14] = L28_2
  L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2, L19_2, L20_2, L21_2, L22_2, L23_2, L24_2, L25_2, L26_2, L27_2, L28_2 = L12_2(L13_2, L14_2)
  L11_2 = L11_2(L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2, L19_2, L20_2, L21_2, L22_2, L23_2, L24_2, L25_2, L26_2, L27_2, L28_2)
  if not L11_2 then
    L12_2 = L3_1
    L13_2 = "db"
    return L12_2(L13_2)
  end
  L12_2 = {}
  L12_2.id = L11_2
  L12_2.owner = A2_2
  L12_2.owner_cid = A3_2
  L13_2 = L5_2.kind
  L12_2.kind = L13_2
  L13_2 = L5_2.content
  L12_2.content = L13_2
  L13_2 = L5_2.mediaId
  L12_2.mediaId = L13_2
  L13_2 = L5_2.bg
  L12_2.bg = L13_2
  L13_2 = L5_2.font
  L12_2.font = L13_2
  L13_2 = L5_2.duration
  L12_2.duration = L13_2
  L13_2 = L9_2.privacy
  L12_2.privacy = L13_2
  L13_2 = L9_2.audience
  L12_2.audienceT = L13_2
  L13_2 = {}
  L12_2.mentionsT = L13_2
  L12_2.reshareOf = L4_2
  L12_2.created = L6_2
  L12_2.expires = L10_2
  L13_2 = pcall
  L14_2 = L53_1
  L15_2 = L12_2
  L16_2 = "add"
  L13_2(L14_2, L15_2, L16_2)
  L13_2 = L45_1
  L14_2 = L12_2
  L15_2 = true
  L13_2 = L13_2(L14_2, L15_2)
  L14_2 = true
  L15_2 = 0
  L13_2.likes = 0
  L13_2.views = L15_2
  L13_2.ok = L14_2
  return L13_2
end
L57_1(L58_1, L59_1)
L57_1 = L36_1
L58_1 = "recado.status.mute"
function L59_1(A0_2, A1_2, A2_2)
  local L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2
  L3_2 = L9_1
  L4_2 = A1_2.number
  L3_2 = L3_2(L4_2)
  if not L3_2 or L3_2 == A2_2 then
    L4_2 = L3_1
    L5_2 = "invalid"
    return L4_2(L5_2)
  end
  L4_2 = L51_1
  L5_2 = A2_2
  L4_2 = L4_2(L5_2)
  L5_2 = {}
  L6_2 = L15_1
  L7_2 = A1_2.on
  L6_2 = L6_2(L7_2)
  L7_2 = ipairs
  L8_2 = L4_2.muted
  L7_2, L8_2, L9_2, L10_2 = L7_2(L8_2)
  for L11_2, L12_2 in L7_2, L8_2, L9_2, L10_2 do
    L13_2 = tostring
    L14_2 = L12_2
    L13_2 = L13_2(L14_2)
    if L13_2 ~= L3_2 then
      L13_2 = #L5_2
      L13_2 = L13_2 + 1
      L14_2 = tostring
      L15_2 = L12_2
      L14_2 = L14_2(L15_2)
      L5_2[L13_2] = L14_2
    end
  end
  if L6_2 then
    L7_2 = #L5_2
    L7_2 = L7_2 + 1
    L5_2[L7_2] = L3_2
  end
  while true do
    L7_2 = #L5_2
    L8_2 = 500
    if not (L7_2 > L8_2) then
      break
    end
    L7_2 = table
    L7_2 = L7_2.remove
    L8_2 = L5_2
    L9_2 = 1
    L7_2(L8_2, L9_2)
  end
  L4_2.muted = L5_2
  L7_2 = L52_1
  L8_2 = A2_2
  L9_2 = L4_2
  L7_2(L8_2, L9_2)
  L7_2 = {}
  L7_2.ok = true
  L7_2.number = L3_2
  L7_2.muted = L6_2
  return L7_2
end
L57_1(L58_1, L59_1)
L57_1 = "ABCDEFGHJKLMNPQRSTUVWXYZ23456789"
function L58_1(A0_2)
  local L1_2, L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2
  L1_2 = {}
  L2_2 = 1
  L3_2 = A0_2
  L4_2 = 1
  for L5_2 = L2_2, L3_2, L4_2 do
    L6_2 = math
    L6_2 = L6_2.random
    L7_2 = 1
    L8_2 = L57_1
    L8_2 = #L8_2
    L6_2 = L6_2(L7_2, L8_2)
    L7_2 = L57_1
    L8_2 = L7_2
    L7_2 = L7_2.sub
    L9_2 = L6_2
    L10_2 = L6_2
    L7_2 = L7_2(L8_2, L9_2, L10_2)
    L1_2[L5_2] = L7_2
  end
  L2_2 = table
  L2_2 = L2_2.concat
  L3_2 = L1_2
  return L2_2(L3_2)
end
L59_1 = "SELECT id, name, description, avatar, owner, owner_cid, code, listed, verified, followers, created, updated, last_post FROM apex_phone_recado_channels"
L60_1 = {}
L60_1.text = true
L60_1.image = true
L60_1.audio = true
L60_1.sticker = true
L60_1.poll = true
function L61_1()
  local L0_2, L1_2, L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2
  L0_2 = type
  L1_2 = L0_1
  L1_2 = L1_2()
  L1_2 = L1_2.channels
  L0_2 = L0_2(L1_2)
  if "table" == L0_2 then
    L0_2 = L0_1
    L0_2 = L0_2()
    L0_2 = L0_2.channels
    if L0_2 then
      goto lbl_15
    end
  end
  L0_2 = {}
  ::lbl_15::
  L1_2 = {}
  L2_2 = math
  L2_2 = L2_2.max
  L3_2 = 1
  L4_2 = math
  L4_2 = L4_2.min
  L5_2 = 50
  L6_2 = math
  L6_2 = L6_2.tointeger
  L7_2 = tonumber
  L8_2 = L0_2.maxAdmins
  L7_2, L8_2 = L7_2(L8_2)
  L6_2 = L6_2(L7_2, L8_2)
  if not L6_2 then
    L6_2 = 8
  end
  L4_2 = L4_2(L5_2, L6_2)
  L2_2 = L2_2(L3_2, L4_2)
  L1_2.maxAdmins = L2_2
  L2_2 = math
  L2_2 = L2_2.max
  L3_2 = 1
  L4_2 = math
  L4_2 = L4_2.min
  L5_2 = 50
  L6_2 = math
  L6_2 = L6_2.tointeger
  L7_2 = tonumber
  L8_2 = L0_2.maxPerOwner
  L7_2, L8_2 = L7_2(L8_2)
  L6_2 = L6_2(L7_2, L8_2)
  if not L6_2 then
    L6_2 = 5
  end
  L4_2 = L4_2(L5_2, L6_2)
  L2_2 = L2_2(L3_2, L4_2)
  L1_2.maxPerOwner = L2_2
  return L1_2
end
function L62_1()
  local L0_2, L1_2, L2_2, L3_2, L4_2, L5_2, L6_2, L7_2
  L0_2 = type
  L1_2 = L0_1
  L1_2 = L1_2()
  L1_2 = L1_2.polls
  L0_2 = L0_2(L1_2)
  if "table" == L0_2 then
    L0_2 = L0_1
    L0_2 = L0_2()
    L0_2 = L0_2.polls
    if L0_2 then
      goto lbl_15
    end
  end
  L0_2 = {}
  ::lbl_15::
  L1_2 = math
  L1_2 = L1_2.max
  L2_2 = 2
  L3_2 = math
  L3_2 = L3_2.min
  L4_2 = 12
  L5_2 = math
  L5_2 = L5_2.tointeger
  L6_2 = tonumber
  L7_2 = L0_2.maxOptions
  L6_2, L7_2 = L6_2(L7_2)
  L5_2 = L5_2(L6_2, L7_2)
  if not L5_2 then
    L5_2 = 12
  end
  L3_2 = L3_2(L4_2, L5_2)
  return L1_2(L2_2, L3_2)
end
L63_1 = nil
function L64_1(A0_2)
  local L1_2, L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2
  L1_2 = L63_1
  if not L1_2 then
    L1_2 = {}
    L63_1 = L1_2
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
          goto lbl_34
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
    ::lbl_34::
    L2_2 = ipairs
    L3_2 = L1_2
    L2_2, L3_2, L4_2, L5_2 = L2_2(L3_2)
    for L6_2, L7_2 in L2_2, L3_2, L4_2, L5_2 do
      L8_2 = tostring
      L9_2 = L7_2
      L8_2 = L8_2(L9_2)
      L9_2 = L63_1
      L9_2[L8_2] = true
    end
    L2_2 = ipairs
    L3_2 = {}
    L4_2 = "\240\159\148\165"
    L5_2 = "\240\159\145\143"
    L6_2 = "\240\159\142\137"
    L7_2 = "\240\159\146\175"
    L3_2[1] = L4_2
    L3_2[2] = L5_2
    L3_2[3] = L6_2
    L3_2[4] = L7_2
    L2_2, L3_2, L4_2, L5_2 = L2_2(L3_2)
    for L6_2, L7_2 in L2_2, L3_2, L4_2, L5_2 do
      L8_2 = L63_1
      L8_2[L7_2] = true
    end
  end
  L1_2 = type
  L2_2 = A0_2
  L1_2 = L1_2(L2_2)
  L1_2 = "string" == L1_2
  return L1_2
end
function L65_1(A0_2)
  local L1_2, L2_2, L3_2, L4_2
  L1_2 = MySQL
  L1_2 = L1_2.single
  L1_2 = L1_2.await
  L2_2 = L59_1
  L3_2 = " WHERE id = ?"
  L2_2 = L2_2 .. L3_2
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
  L1_2.id = L2_2
  L2_2 = L1_1
  L3_2 = L1_2.avatar
  L2_2 = L2_2(L3_2)
  L1_2.avatar = L2_2
  L2_2 = tonumber
  L3_2 = L1_2.listed
  L2_2 = L2_2(L3_2)
  if not L2_2 then
    L2_2 = 0
  end
  L2_2 = 1 == L2_2
  L1_2.listed = L2_2
  L2_2 = tonumber
  L3_2 = L1_2.verified
  L2_2 = L2_2(L3_2)
  if not L2_2 then
    L2_2 = 0
  end
  L2_2 = 1 == L2_2
  L1_2.verified = L2_2
  L2_2 = math
  L2_2 = L2_2.tointeger
  L3_2 = tonumber
  L4_2 = L1_2.followers
  L3_2 = L3_2(L4_2)
  if not L3_2 then
    L3_2 = 0
  end
  L2_2 = L2_2(L3_2)
  if not L2_2 then
    L2_2 = 0
  end
  L1_2.followers = L2_2
  return L1_2
end
function L66_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2, L6_2
  L2_2 = MySQL
  L2_2 = L2_2.scalar
  L2_2 = L2_2.await
  L3_2 = "SELECT role FROM apex_phone_recado_channel_admins WHERE channel_id = ? AND number = ?"
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
  if "owner" == L2_2 then
    L3_2 = "owner"
    if L3_2 then
      goto lbl_21
    end
  end
  L3_2 = "admin"
  ::lbl_21::
  return L3_2
end
function L67_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2, L6_2
  L2_2 = MySQL
  L2_2 = L2_2.single
  L2_2 = L2_2.await
  L3_2 = "SELECT muted, last_read, created FROM apex_phone_recado_channel_followers WHERE channel_id = ? AND number = ?"
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
  L4_2 = tonumber
  L5_2 = L2_2.muted
  L4_2 = L4_2(L5_2)
  if not L4_2 then
    L4_2 = 1
  end
  L4_2 = 1 == L4_2
  L3_2.muted = L4_2
  L4_2 = L1_1
  L5_2 = L2_2.last_read
  L4_2 = L4_2(L5_2)
  if not L4_2 then
    L4_2 = 0
  end
  L3_2.lastRead = L4_2
  return L3_2
end
function L68_1(A0_2, A1_2, A2_2)
  local L3_2
  L3_2 = A0_2.listed
  L3_2 = L3_2 or nil ~= A1_2 or nil ~= A2_2
  return L3_2
end
function L69_1(A0_2, A1_2, A2_2, A3_2)
  local L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2
  L4_2 = {}
  L5_2 = A0_2.id
  L4_2.id = L5_2
  L5_2 = A0_2.name
  L4_2.name = L5_2
  L5_2 = A0_2.description
  L4_2.description = L5_2
  L5_2 = A0_2.avatar
  L4_2.avatar = L5_2
  L5_2 = A0_2.verified
  if not L5_2 then
    L5_2 = nil
  end
  L4_2.verified = L5_2
  L5_2 = A0_2.listed
  L4_2.listed = L5_2
  L5_2 = A0_2.followers
  L4_2.followers = L5_2
  L5_2 = tonumber
  L6_2 = A0_2.created
  L5_2 = L5_2(L6_2)
  L4_2.created = L5_2
  L5_2 = tonumber
  L6_2 = A0_2.last_post
  L5_2 = L5_2(L6_2)
  L4_2.lastPost = L5_2
  L4_2.myRole = A1_2
  L5_2 = nil ~= A2_2
  L4_2.following = L5_2
  if A2_2 then
    L5_2 = A2_2.muted
    if L5_2 then
      goto lbl_40
    end
  end
  L5_2 = nil
  ::lbl_40::
  L4_2.muted = L5_2
  if A1_2 then
    L5_2 = A0_2.code
    L4_2.code = L5_2
  end
  L5_2 = type
  L6_2 = A3_2
  L5_2 = L5_2(L6_2)
  if "table" == L5_2 then
    L5_2 = pairs
    L6_2 = A3_2
    L5_2, L6_2, L7_2, L8_2 = L5_2(L6_2)
    for L9_2, L10_2 in L5_2, L6_2, L7_2, L8_2 do
      L4_2[L9_2] = L10_2
    end
  end
  return L4_2
end
function L70_1(A0_2, A1_2, A2_2)
  local L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2
  L3_2 = L1_1
  L4_2 = A2_2
  L3_2 = L3_2(L4_2)
  if not L3_2 then
    L4_2 = nil
    L5_2 = "invalid"
    return L4_2, L5_2
  end
  L4_2 = L65_1
  L5_2 = L3_2
  L4_2 = L4_2(L5_2)
  if not L4_2 then
    L5_2 = nil
    L6_2 = "notfound"
    return L5_2, L6_2
  end
  L5_2 = L66_1
  L6_2 = L3_2
  L7_2 = A1_2
  L5_2 = L5_2(L6_2, L7_2)
  L6_2 = L67_1
  L7_2 = L3_2
  L8_2 = A1_2
  L6_2 = L6_2(L7_2, L8_2)
  L7_2 = L68_1
  L8_2 = L4_2
  L9_2 = L5_2
  L10_2 = L6_2
  L7_2 = L7_2(L8_2, L9_2, L10_2)
  if not L7_2 then
    L7_2 = nil
    L8_2 = "notfound"
    return L7_2, L8_2
  end
  L7_2 = L4_2
  L8_2 = nil
  L9_2 = L5_2
  L10_2 = L6_2
  return L7_2, L8_2, L9_2, L10_2
end
L71_1 = L36_1
L72_1 = "recado.channel.create"
function L73_1(A0_2, A1_2, A2_2, A3_2)
  local L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2, L19_2, L20_2, L21_2, L22_2, L23_2, L24_2, L25_2, L26_2
  L4_2 = HasPhoneItem
  L5_2 = A0_2
  L4_2 = L4_2(L5_2)
  if not L4_2 then
    L4_2 = L3_1
    L5_2 = "nophone"
    return L4_2(L5_2)
  end
  L4_2 = L7_1
  L5_2 = A1_2.name
  L6_2 = 40
  L4_2 = L4_2(L5_2, L6_2)
  if not L4_2 then
    L5_2 = L3_1
    L6_2 = "name"
    return L5_2(L6_2)
  end
  L5_2 = nil
  L6_2 = A1_2.description
  if nil ~= L6_2 then
    L6_2 = A1_2.description
    if "" ~= L6_2 then
      L6_2 = L8_1
      L7_2 = A1_2.description
      L8_2 = 300
      L6_2 = L6_2(L7_2, L8_2)
      L5_2 = L6_2
      if not L5_2 then
        L6_2 = L3_1
        L7_2 = "invalid"
        return L6_2(L7_2)
      end
    end
  end
  L6_2 = nil
  L7_2 = A1_2.avatar
  if nil ~= L7_2 then
    L7_2 = A1_2.avatar
    if false ~= L7_2 then
      L7_2 = A1_2.avatar
      if 0 ~= L7_2 then
        L7_2 = A1_2.avatar
        if "" ~= L7_2 then
          L7_2 = L28_1
          L8_2 = A3_2
          L9_2 = A1_2.avatar
          L10_2 = "image"
          L7_2 = L7_2(L8_2, L9_2, L10_2)
          L6_2 = L7_2
          if not L6_2 then
            L7_2 = L3_1
            L8_2 = "media"
            return L7_2(L8_2)
          end
        end
      end
    end
  end
  L7_2 = L23_1
  L8_2 = A0_2
  L9_2 = "channel.create"
  L10_2 = 5000
  L7_2 = L7_2(L8_2, L9_2, L10_2)
  if L7_2 then
    L7_2 = L3_1
    L8_2 = "cooldown"
    return L7_2(L8_2)
  end
  L7_2 = L61_1
  L7_2 = L7_2()
  L8_2 = tonumber
  L9_2 = MySQL
  L9_2 = L9_2.scalar
  L9_2 = L9_2.await
  L10_2 = "SELECT COUNT(*) FROM apex_phone_recado_channel_admins WHERE number = ? AND role = 'owner'"
  L11_2 = {}
  L12_2 = A2_2
  L11_2[1] = L12_2
  L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2, L19_2, L20_2, L21_2, L22_2, L23_2, L24_2, L25_2, L26_2 = L9_2(L10_2, L11_2)
  L8_2 = L8_2(L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2, L19_2, L20_2, L21_2, L22_2, L23_2, L24_2, L25_2, L26_2)
  if not L8_2 then
    L8_2 = 0
  end
  L9_2 = L7_2.maxPerOwner
  if L8_2 >= L9_2 then
    L9_2 = L3_1
    L10_2 = "limit"
    L11_2 = {}
    L12_2 = L7_2.maxPerOwner
    L11_2.max = L12_2
    return L9_2(L10_2, L11_2)
  end
  L9_2 = Now
  L9_2 = L9_2()
  L10_2 = nil
  L11_2 = 1
  L12_2 = 6
  L13_2 = 1
  for L14_2 = L11_2, L12_2, L13_2 do
    L15_2 = pcall
    L16_2 = MySQL
    L16_2 = L16_2.insert
    L16_2 = L16_2.await
    L17_2 = "INSERT INTO apex_phone_recado_channels (name, description, avatar, owner, owner_cid, code, listed, followers, created, updated) VALUES (?, ?, ?, ?, ?, ?, 1, 0, ?, ?)"
    L18_2 = {}
    L19_2 = L4_2
    L20_2 = L5_2
    L21_2 = L6_2
    L22_2 = A2_2
    L23_2 = A3_2
    L24_2 = L58_1
    L25_2 = 8
    L24_2 = L24_2(L25_2)
    L25_2 = L9_2
    L26_2 = L9_2
    L18_2[1] = L19_2
    L18_2[2] = L20_2
    L18_2[3] = L21_2
    L18_2[4] = L22_2
    L18_2[5] = L23_2
    L18_2[6] = L24_2
    L18_2[7] = L25_2
    L18_2[8] = L26_2
    L15_2, L16_2 = L15_2(L16_2, L17_2, L18_2)
    if L15_2 then
      L17_2 = L1_1
      L18_2 = L16_2
      L17_2 = L17_2(L18_2)
      L10_2 = L17_2
      break
    end
    L17_2 = tostring
    L18_2 = L16_2
    L17_2 = L17_2(L18_2)
    L18_2 = L17_2
    L17_2 = L17_2.find
    L19_2 = "Duplicate"
    L20_2 = 1
    L21_2 = true
    L17_2 = L17_2(L18_2, L19_2, L20_2, L21_2)
    if not L17_2 then
      L17_2 = print
      L18_2 = "^1[unique_phone]^0 recado.channel.create: %s"
      L19_2 = L18_2
      L18_2 = L18_2.format
      L20_2 = tostring
      L21_2 = L16_2
      L20_2, L21_2, L22_2, L23_2, L24_2, L25_2, L26_2 = L20_2(L21_2)
      L18_2, L19_2, L20_2, L21_2, L22_2, L23_2, L24_2, L25_2, L26_2 = L18_2(L19_2, L20_2, L21_2, L22_2, L23_2, L24_2, L25_2, L26_2)
      L17_2(L18_2, L19_2, L20_2, L21_2, L22_2, L23_2, L24_2, L25_2, L26_2)
      break
    end
  end
  if not L10_2 then
    L11_2 = L3_1
    L12_2 = "db"
    return L11_2(L12_2)
  end
  L11_2 = MySQL
  L11_2 = L11_2.update
  L11_2 = L11_2.await
  L12_2 = "INSERT INTO apex_phone_recado_channel_admins (channel_id, number, role, added) VALUES (?, ?, 'owner', ?)"
  L13_2 = {}
  L14_2 = L10_2
  L15_2 = A2_2
  L16_2 = L9_2
  L13_2[1] = L14_2
  L13_2[2] = L15_2
  L13_2[3] = L16_2
  L11_2(L12_2, L13_2)
  L11_2 = Dbg
  L12_2 = "recado"
  L13_2 = "channel %s \"%s\" created by %s"
  L14_2 = L10_2
  L15_2 = L4_2
  L16_2 = A2_2
  L11_2(L12_2, L13_2, L14_2, L15_2, L16_2)
  L11_2 = L65_1
  L12_2 = L10_2
  L11_2 = L11_2(L12_2)
  L12_2 = L69_1
  L13_2 = L11_2
  L14_2 = "owner"
  L15_2 = nil
  L12_2 = L12_2(L13_2, L14_2, L15_2)
  L12_2.ok = true
  return L12_2
end
L71_1(L72_1, L73_1)
L71_1 = L36_1
L72_1 = "recado.channel.update"
function L73_1(A0_2, A1_2, A2_2, A3_2)
  local L4_2, L5_2, L6_2, L7_2
  L4_2 = L1_1
  L5_2 = A1_2.id
  L4_2 = L4_2(L5_2)
  if not L4_2 then
    L5_2 = L3_1
    L6_2 = "invalid"
    return L5_2(L6_2)
  end
  L5_2 = L21_1
  L6_2 = "ch:"
  L7_2 = L4_2
  L6_2 = L6_2 .. L7_2
  function L7_2()
    local L0_3, L1_3, L2_3, L3_3, L4_3, L5_3, L6_3, L7_3, L8_3, L9_3
    L0_3 = L65_1
    L1_3 = L4_2
    L0_3 = L0_3(L1_3)
    if not L0_3 then
      L1_3 = L3_1
      L2_3 = "notfound"
      return L1_3(L2_3)
    end
    L1_3 = L66_1
    L2_3 = L4_2
    L3_3 = A2_2
    L1_3 = L1_3(L2_3, L3_3)
    if not L1_3 then
      L2_3 = L3_1
      L3_3 = L0_3.listed
      if L3_3 then
        L3_3 = "notadmin"
        if L3_3 then
          goto lbl_24
        end
      end
      L3_3 = "notfound"
      ::lbl_24::
      return L2_3(L3_3)
    end
    L2_3 = {}
    L3_3 = {}
    L4_3 = A1_2.name
    if nil ~= L4_3 then
      L4_3 = L7_1
      L5_3 = A1_2.name
      L6_3 = 40
      L4_3 = L4_3(L5_3, L6_3)
      if not L4_3 then
        L5_3 = L3_1
        L6_3 = "name"
        return L5_3(L6_3)
      end
      L5_3 = #L2_3
      L5_3 = L5_3 + 1
      L2_3[L5_3] = "name = ?"
      L5_3 = #L3_3
      L5_3 = L5_3 + 1
      L3_3[L5_3] = L4_3
    end
    L4_3 = A1_2.description
    if nil ~= L4_3 then
      L4_3 = A1_2.description
      if "" ~= L4_3 then
        L4_3 = A1_2.description
        if false ~= L4_3 then
          goto lbl_65
        end
      end
      L4_3 = #L2_3
      L4_3 = L4_3 + 1
      L2_3[L4_3] = "description = NULL"
      goto lbl_83
      ::lbl_65::
      L4_3 = L8_1
      L5_3 = A1_2.description
      L6_3 = 300
      L4_3 = L4_3(L5_3, L6_3)
      if not L4_3 then
        L5_3 = L3_1
        L6_3 = "invalid"
        return L5_3(L6_3)
      end
      L5_3 = #L2_3
      L5_3 = L5_3 + 1
      L2_3[L5_3] = "description = ?"
      L5_3 = #L3_3
      L5_3 = L5_3 + 1
      L3_3[L5_3] = L4_3
    end
    ::lbl_83::
    L4_3 = A1_2.avatar
    if nil ~= L4_3 then
      L4_3 = A1_2.avatar
      if false ~= L4_3 then
        L4_3 = A1_2.avatar
        if 0 ~= L4_3 then
          L4_3 = A1_2.avatar
          if "" ~= L4_3 then
            goto lbl_100
          end
        end
      end
      L4_3 = #L2_3
      L4_3 = L4_3 + 1
      L2_3[L4_3] = "avatar = NULL"
      goto lbl_127
      ::lbl_100::
      L4_3 = L28_1
      L5_3 = A3_2
      L6_3 = A1_2.avatar
      L7_3 = "image"
      L4_3 = L4_3(L5_3, L6_3, L7_3)
      if not L4_3 then
        L5_3 = L1_1
        L6_3 = A1_2.avatar
        L5_3 = L5_3(L6_3)
        L6_3 = L0_3.avatar
        if L5_3 ~= L6_3 then
          L5_3 = L3_1
          L6_3 = "media"
          return L5_3(L6_3)
        end
      end
      if L4_3 then
        L5_3 = #L2_3
        L5_3 = L5_3 + 1
        L2_3[L5_3] = "avatar = ?"
        L5_3 = #L3_3
        L5_3 = L5_3 + 1
        L3_3[L5_3] = L4_3
      end
    end
    ::lbl_127::
    L4_3 = A1_2.listed
    if nil ~= L4_3 then
      if "owner" ~= L1_3 then
        L4_3 = L3_1
        L5_3 = "notowner"
        return L4_3(L5_3)
      end
      L4_3 = #L2_3
      L4_3 = L4_3 + 1
      L2_3[L4_3] = "listed = ?"
      L4_3 = #L3_3
      L4_3 = L4_3 + 1
      L5_3 = L15_1
      L6_3 = A1_2.listed
      L5_3 = L5_3(L6_3)
      if L5_3 then
        L5_3 = 1
        if L5_3 then
          goto lbl_152
        end
      end
      L5_3 = 0
      ::lbl_152::
      L3_3[L4_3] = L5_3
    end
    L4_3 = #L2_3
    if L4_3 > 0 then
      L4_3 = #L2_3
      L4_3 = L4_3 + 1
      L2_3[L4_3] = "updated = ?"
      L4_3 = #L3_3
      L4_3 = L4_3 + 1
      L5_3 = Now
      L5_3 = L5_3()
      L3_3[L4_3] = L5_3
      L4_3 = #L3_3
      L4_3 = L4_3 + 1
      L5_3 = L4_2
      L3_3[L4_3] = L5_3
      L4_3 = MySQL
      L4_3 = L4_3.update
      L4_3 = L4_3.await
      L5_3 = "UPDATE apex_phone_recado_channels SET "
      L6_3 = table
      L6_3 = L6_3.concat
      L7_3 = L2_3
      L8_3 = ", "
      L6_3 = L6_3(L7_3, L8_3)
      L7_3 = " WHERE id = ?"
      L5_3 = L5_3 .. L6_3 .. L7_3
      L6_3 = L3_3
      L4_3(L5_3, L6_3)
      L4_3 = A1_2.listed
      if nil ~= L4_3 then
        L4_3 = L15_1
        L5_3 = A1_2.listed
        L4_3 = L4_3(L5_3)
        if not L4_3 then
          L4_3 = L27_1
          L4_3()
        end
      end
    end
    L4_3 = L69_1
    L5_3 = L65_1
    L6_3 = L4_2
    L5_3 = L5_3(L6_3)
    L6_3 = L1_3
    L7_3 = L67_1
    L8_3 = L4_2
    L9_3 = A2_2
    L7_3, L8_3, L9_3 = L7_3(L8_3, L9_3)
    L4_3 = L4_3(L5_3, L6_3, L7_3, L8_3, L9_3)
    L4_3.ok = true
    return L4_3
  end
  return L5_2(L6_2, L7_2)
end
L71_1(L72_1, L73_1)
function L71_1(A0_2)
  local L1_2, L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2, L19_2, L20_2, L21_2
  L1_2 = L19_1
  L1_2 = L1_2()
  L2_2 = {}
  L3_2 = pairs
  L4_2 = L1_2
  L3_2, L4_2, L5_2, L6_2 = L3_2(L4_2)
  for L7_2 in L3_2, L4_2, L5_2, L6_2 do
    L8_2 = #L2_2
    L8_2 = L8_2 + 1
    L2_2[L8_2] = L7_2
  end
  L3_2 = {}
  L4_2 = 1
  L5_2 = #L2_2
  L6_2 = 200
  for L7_2 = L4_2, L5_2, L6_2 do
    L8_2 = {}
    L9_2 = A0_2
    L8_2[1] = L9_2
    L9_2 = L7_2
    L10_2 = math
    L10_2 = L10_2.min
    L11_2 = #L2_2
    L12_2 = L7_2 + 199
    L10_2 = L10_2(L11_2, L12_2)
    L11_2 = 1
    for L12_2 = L9_2, L10_2, L11_2 do
      L13_2 = #L8_2
      L13_2 = L13_2 + 1
      L14_2 = L2_2[L12_2]
      L8_2[L13_2] = L14_2
    end
    L9_2 = pcall
    L10_2 = MySQL
    L10_2 = L10_2.query
    L10_2 = L10_2.await
    L11_2 = "SELECT number, muted FROM apex_phone_recado_channel_followers WHERE channel_id = ? AND number IN (%s)"
    L12_2 = L11_2
    L11_2 = L11_2.format
    L13_2 = L2_1
    L14_2 = #L8_2
    L14_2 = L14_2 - 1
    L13_2, L14_2, L15_2, L16_2, L17_2, L18_2, L19_2, L20_2, L21_2 = L13_2(L14_2)
    L11_2 = L11_2(L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2, L19_2, L20_2, L21_2)
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
          L18_2 = {}
          L19_2 = tostring
          L20_2 = L16_2.number
          L19_2 = L19_2(L20_2)
          L19_2 = L1_2[L19_2]
          L18_2.src = L19_2
          L19_2 = tonumber
          L20_2 = L16_2.muted
          L19_2 = L19_2(L20_2)
          if not L19_2 then
            L19_2 = 1
          end
          L19_2 = 1 == L19_2
          L18_2.muted = L19_2
          L3_2[L17_2] = L18_2
        end
      end
    end
    L11_2 = pcall
    L12_2 = MySQL
    L12_2 = L12_2.query
    L12_2 = L12_2.await
    L13_2 = "SELECT number FROM apex_phone_recado_channel_admins WHERE channel_id = ? AND number IN (%s)"
    L14_2 = L13_2
    L13_2 = L13_2.format
    L15_2 = L2_1
    L16_2 = #L8_2
    L16_2 = L16_2 - 1
    L15_2, L16_2, L17_2, L18_2, L19_2, L20_2, L21_2 = L15_2(L16_2)
    L13_2 = L13_2(L14_2, L15_2, L16_2, L17_2, L18_2, L19_2, L20_2, L21_2)
    L14_2 = L8_2
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
          L20_2 = L18_2.number
          L19_2 = L19_2(L20_2)
          L20_2 = L3_2[L19_2]
          if not L20_2 then
            L20_2 = {}
            L21_2 = L1_2[L19_2]
            L20_2.src = L21_2
            L20_2.muted = true
          end
          L3_2[L19_2] = L20_2
          L20_2 = L3_2[L19_2]
          L20_2.admin = true
        end
      end
    end
  end
  return L3_2
end
function L72_1(A0_2, A1_2, A2_2)
  local L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2
  L3_2 = pairs
  L4_2 = L71_1
  L5_2 = A0_2
  L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2 = L4_2(L5_2)
  L3_2, L4_2, L5_2, L6_2 = L3_2(L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2)
  for L7_2, L8_2 in L3_2, L4_2, L5_2, L6_2 do
    if L7_2 ~= A2_2 then
      L9_2 = L8_2.src
      if L9_2 then
        L9_2 = HasPhoneItem
        L10_2 = L8_2.src
        L9_2 = L9_2(L10_2)
        if L9_2 then
          L9_2 = Push
          L10_2 = L8_2.src
          L11_2 = "recadoChannel"
          L12_2 = A1_2
          L9_2(L10_2, L11_2, L12_2)
        end
      end
    end
  end
end
L73_1 = L36_1
L74_1 = "recado.channel.delete"
function L75_1(A0_2, A1_2, A2_2)
  local L3_2, L4_2, L5_2, L6_2
  L3_2 = L1_1
  L4_2 = A1_2.id
  L3_2 = L3_2(L4_2)
  if not L3_2 then
    L4_2 = L3_1
    L5_2 = "invalid"
    return L4_2(L5_2)
  end
  L4_2 = L21_1
  L5_2 = "ch:"
  L6_2 = L3_2
  L5_2 = L5_2 .. L6_2
  function L6_2()
    local L0_3, L1_3, L2_3, L3_3, L4_3, L5_3
    L0_3 = L65_1
    L1_3 = L3_2
    L0_3 = L0_3(L1_3)
    if not L0_3 then
      L1_3 = L3_1
      L2_3 = "notfound"
      return L1_3(L2_3)
    end
    L1_3 = L66_1
    L2_3 = L3_2
    L3_3 = A2_2
    L1_3 = L1_3(L2_3, L3_3)
    if "owner" ~= L1_3 then
      L1_3 = L3_1
      L2_3 = "notowner"
      return L1_3(L2_3)
    end
    L1_3 = L72_1
    L2_3 = L3_2
    L3_3 = {}
    L4_3 = L3_2
    L3_3.id = L4_3
    L3_3.action = "delete"
    L4_3 = A2_2
    L1_3(L2_3, L3_3, L4_3)
    L1_3 = pcall
    L2_3 = MySQL
    L2_3 = L2_3.update
    L2_3 = L2_3.await
    L3_3 = "DELETE r FROM apex_phone_recado_channel_reactions r JOIN apex_phone_recado_channel_posts p ON p.id = r.post_id WHERE p.channel_id = ?"
    L4_3 = {}
    L5_3 = L3_2
    L4_3[1] = L5_3
    L1_3(L2_3, L3_3, L4_3)
    L1_3 = pcall
    L2_3 = MySQL
    L2_3 = L2_3.update
    L2_3 = L2_3.await
    L3_3 = "DELETE v FROM apex_phone_recado_channel_votes v JOIN apex_phone_recado_channel_posts p ON p.id = v.post_id WHERE p.channel_id = ?"
    L4_3 = {}
    L5_3 = L3_2
    L4_3[1] = L5_3
    L1_3(L2_3, L3_3, L4_3)
    L1_3 = MySQL
    L1_3 = L1_3.update
    L1_3 = L1_3.await
    L2_3 = "DELETE FROM apex_phone_recado_channel_posts WHERE channel_id = ?"
    L3_3 = {}
    L4_3 = L3_2
    L3_3[1] = L4_3
    L1_3(L2_3, L3_3)
    L1_3 = MySQL
    L1_3 = L1_3.update
    L1_3 = L1_3.await
    L2_3 = "DELETE FROM apex_phone_recado_channel_followers WHERE channel_id = ?"
    L3_3 = {}
    L4_3 = L3_2
    L3_3[1] = L4_3
    L1_3(L2_3, L3_3)
    L1_3 = MySQL
    L1_3 = L1_3.update
    L1_3 = L1_3.await
    L2_3 = "DELETE FROM apex_phone_recado_channel_admins WHERE channel_id = ?"
    L3_3 = {}
    L4_3 = L3_2
    L3_3[1] = L4_3
    L1_3(L2_3, L3_3)
    L1_3 = MySQL
    L1_3 = L1_3.update
    L1_3 = L1_3.await
    L2_3 = "DELETE FROM apex_phone_recado_channels WHERE id = ?"
    L3_3 = {}
    L4_3 = L3_2
    L3_3[1] = L4_3
    L1_3(L2_3, L3_3)
    L1_3 = L27_1
    L1_3()
    L1_3 = Dbg
    L2_3 = "recado"
    L3_3 = "channel %s deleted by %s"
    L4_3 = L3_2
    L5_3 = A2_2
    L1_3(L2_3, L3_3, L4_3, L5_3)
    L1_3 = {}
    L1_3.ok = true
    L2_3 = L3_2
    L1_3.id = L2_3
    return L1_3
  end
  return L4_2(L5_2, L6_2)
end
L73_1(L74_1, L75_1)
function L73_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2
  L2_2 = MySQL
  L2_2 = L2_2.query
  L2_2 = L2_2.await
  L3_2 = "SELECT number, role, added FROM apex_phone_recado_channel_admins WHERE channel_id = ? ORDER BY role DESC, added ASC"
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
    L10_2 = #L3_2
    L10_2 = L10_2 + 1
    L11_2 = tostring
    L12_2 = L9_2.number
    L11_2 = L11_2(L12_2)
    L3_2[L10_2] = L11_2
  end
  L4_2 = L29_1
  L5_2 = A1_2
  L6_2 = L3_2
  L4_2 = L4_2(L5_2, L6_2)
  L5_2 = {}
  L6_2 = ipairs
  L7_2 = L2_2
  L6_2, L7_2, L8_2, L9_2 = L6_2(L7_2)
  for L10_2, L11_2 in L6_2, L7_2, L8_2, L9_2 do
    L12_2 = tostring
    L13_2 = L11_2.number
    L12_2 = L12_2(L13_2)
    L13_2 = #L5_2
    L13_2 = L13_2 + 1
    L14_2 = {}
    L14_2.number = L12_2
    L15_2 = L11_2.role
    if "owner" == L15_2 then
      L15_2 = "owner"
      if L15_2 then
        goto lbl_56
      end
    end
    L15_2 = "admin"
    ::lbl_56::
    L14_2.role = L15_2
    L15_2 = L4_2[L12_2]
    if not L15_2 then
      L15_2 = L30_1
      L16_2 = L12_2
      L15_2 = L15_2(L16_2)
    end
    L14_2.name = L15_2
    L15_2 = tonumber
    L16_2 = L11_2.added
    L15_2 = L15_2(L16_2)
    L14_2.added = L15_2
    L5_2[L13_2] = L14_2
  end
  return L5_2
end
L74_1 = L36_1
L75_1 = "recado.channel.get"
function L76_1(A0_2, A1_2, A2_2, A3_2)
  local L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2
  L4_2 = L70_1
  L5_2 = A0_2
  L6_2 = A2_2
  L7_2 = A1_2.id
  L4_2, L5_2, L6_2, L7_2 = L4_2(L5_2, L6_2, L7_2)
  if not L4_2 then
    L8_2 = L3_1
    L9_2 = L5_2
    return L8_2(L9_2)
  end
  L8_2 = {}
  if L6_2 then
    L9_2 = L73_1
    L10_2 = L4_2.id
    L11_2 = A3_2
    L9_2 = L9_2(L10_2, L11_2)
    L8_2.admins = L9_2
  end
  if L7_2 then
    L9_2 = math
    L9_2 = L9_2.tointeger
    L10_2 = tonumber
    L11_2 = MySQL
    L11_2 = L11_2.scalar
    L11_2 = L11_2.await
    L12_2 = "SELECT COUNT(*) FROM apex_phone_recado_channel_posts WHERE channel_id = ? AND id > ?"
    L13_2 = {}
    L14_2 = L4_2.id
    L15_2 = L7_2.lastRead
    L13_2[1] = L14_2
    L13_2[2] = L15_2
    L11_2, L12_2, L13_2, L14_2, L15_2 = L11_2(L12_2, L13_2)
    L10_2 = L10_2(L11_2, L12_2, L13_2, L14_2, L15_2)
    if not L10_2 then
      L10_2 = 0
    end
    L9_2 = L9_2(L10_2)
    if not L9_2 then
      L9_2 = 0
    end
    L8_2.unread = L9_2
  end
  L9_2 = L69_1
  L10_2 = L4_2
  L11_2 = L6_2
  L12_2 = L7_2
  L13_2 = L8_2
  L9_2 = L9_2(L10_2, L11_2, L12_2, L13_2)
  L9_2.ok = true
  return L9_2
end
L74_1(L75_1, L76_1)
L74_1 = L36_1
L75_1 = "recado.channel.list"
function L76_1(A0_2, A1_2, A2_2)
  local L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2, L19_2, L20_2, L21_2, L22_2, L23_2, L24_2, L25_2
  L3_2 = A1_2.scope
  if "mine" ~= L3_2 then
    L3_2 = A1_2.scope
    if "following" ~= L3_2 then
      L3_2 = A1_2.scope
      if "directory" ~= L3_2 then
        goto lbl_13
      end
    end
  end
  L3_2 = A1_2.scope
  ::lbl_13::
  if not L3_2 then
    L3_2 = "following"
  end
  L4_2 = nil
  L5_2 = "SELECT c.id, c.name, c.description, c.avatar, c.owner, c.owner_cid, c.code, c.listed, c.verified, c.followers, c.created, c.updated, c.last_post FROM apex_phone_recado_channels c "
  if "mine" == L3_2 then
    L6_2 = MySQL
    L6_2 = L6_2.query
    L6_2 = L6_2.await
    L7_2 = L5_2
    L8_2 = "JOIN apex_phone_recado_channel_admins a ON a.channel_id = c.id WHERE a.number = ? ORDER BY c.last_post DESC, c.id DESC LIMIT 50"
    L7_2 = L7_2 .. L8_2
    L8_2 = {}
    L9_2 = A2_2
    L8_2[1] = L9_2
    L6_2 = L6_2(L7_2, L8_2)
    L4_2 = L6_2
  elseif "following" == L3_2 then
    L6_2 = MySQL
    L6_2 = L6_2.query
    L6_2 = L6_2.await
    L7_2 = L5_2
    L8_2 = "JOIN apex_phone_recado_channel_followers f ON f.channel_id = c.id WHERE f.number = ? ORDER BY c.last_post DESC, c.id DESC LIMIT 100"
    L7_2 = L7_2 .. L8_2
    L8_2 = {}
    L9_2 = A2_2
    L8_2[1] = L9_2
    L6_2 = L6_2(L7_2, L8_2)
    L4_2 = L6_2
  else
    L6_2 = type
    L7_2 = A1_2.q
    L6_2 = L6_2(L7_2)
    if "string" == L6_2 then
      L6_2 = L7_1
      L7_2 = A1_2.q
      L8_2 = 40
      L6_2 = L6_2(L7_2, L8_2)
      if L6_2 then
        goto lbl_58
      end
    end
    L6_2 = nil
    ::lbl_58::
    if L6_2 then
      L7_2 = MySQL
      L7_2 = L7_2.query
      L7_2 = L7_2.await
      L8_2 = L59_1
      L9_2 = " WHERE listed = 1 AND (name LIKE ? OR description LIKE ?) ORDER BY verified DESC, followers DESC, id DESC LIMIT 50"
      L8_2 = L8_2 .. L9_2
      L9_2 = {}
      L10_2 = "%"
      L11_2 = L14_1
      L12_2 = L6_2
      L11_2 = L11_2(L12_2)
      L12_2 = "%"
      L10_2 = L10_2 .. L11_2 .. L12_2
      L11_2 = "%"
      L12_2 = L14_1
      L13_2 = L6_2
      L12_2 = L12_2(L13_2)
      L13_2 = "%"
      L11_2 = L11_2 .. L12_2 .. L13_2
      L9_2[1] = L10_2
      L9_2[2] = L11_2
      L7_2 = L7_2(L8_2, L9_2)
      L4_2 = L7_2
    else
      L7_2 = MySQL
      L7_2 = L7_2.query
      L7_2 = L7_2.await
      L8_2 = L59_1
      L9_2 = " WHERE listed = 1 ORDER BY verified DESC, followers DESC, id DESC LIMIT 50"
      L8_2 = L8_2 .. L9_2
      L9_2 = {}
      L7_2 = L7_2(L8_2, L9_2)
      L4_2 = L7_2
    end
  end
  if not L4_2 then
    L6_2 = {}
    L4_2 = L6_2
  end
  L6_2 = {}
  L7_2 = ipairs
  L8_2 = L4_2
  L7_2, L8_2, L9_2, L10_2 = L7_2(L8_2)
  for L11_2, L12_2 in L7_2, L8_2, L9_2, L10_2 do
    L13_2 = #L6_2
    L13_2 = L13_2 + 1
    L14_2 = math
    L14_2 = L14_2.tointeger
    L15_2 = tonumber
    L16_2 = L12_2.id
    L15_2, L16_2, L17_2, L18_2, L19_2, L20_2, L21_2, L22_2, L23_2, L24_2, L25_2 = L15_2(L16_2)
    L14_2 = L14_2(L15_2, L16_2, L17_2, L18_2, L19_2, L20_2, L21_2, L22_2, L23_2, L24_2, L25_2)
    L6_2[L13_2] = L14_2
  end
  L7_2 = {}
  L8_2 = {}
  L9_2 = {}
  L10_2 = #L6_2
  if L10_2 > 0 then
    L10_2 = {}
    L11_2 = A2_2
    L10_2[1] = L11_2
    L11_2 = ipairs
    L12_2 = L6_2
    L11_2, L12_2, L13_2, L14_2 = L11_2(L12_2)
    for L15_2, L16_2 in L11_2, L12_2, L13_2, L14_2 do
      L17_2 = #L10_2
      L17_2 = L17_2 + 1
      L10_2[L17_2] = L16_2
    end
    L11_2 = ipairs
    L12_2 = MySQL
    L12_2 = L12_2.query
    L12_2 = L12_2.await
    L13_2 = "SELECT channel_id, role FROM apex_phone_recado_channel_admins WHERE number = ? AND channel_id IN (%s)"
    L14_2 = L13_2
    L13_2 = L13_2.format
    L15_2 = L2_1
    L16_2 = #L6_2
    L15_2, L16_2, L17_2, L18_2, L19_2, L20_2, L21_2, L22_2, L23_2, L24_2, L25_2 = L15_2(L16_2)
    L13_2 = L13_2(L14_2, L15_2, L16_2, L17_2, L18_2, L19_2, L20_2, L21_2, L22_2, L23_2, L24_2, L25_2)
    L14_2 = L10_2
    L12_2 = L12_2(L13_2, L14_2)
    if not L12_2 then
      L12_2 = {}
    end
    L11_2, L12_2, L13_2, L14_2 = L11_2(L12_2)
    for L15_2, L16_2 in L11_2, L12_2, L13_2, L14_2 do
      L17_2 = math
      L17_2 = L17_2.tointeger
      L18_2 = tonumber
      L19_2 = L16_2.channel_id
      L18_2, L19_2, L20_2, L21_2, L22_2, L23_2, L24_2, L25_2 = L18_2(L19_2)
      L17_2 = L17_2(L18_2, L19_2, L20_2, L21_2, L22_2, L23_2, L24_2, L25_2)
      if not L17_2 then
        L17_2 = 0
      end
      L18_2 = L16_2.role
      if "owner" == L18_2 then
        L18_2 = "owner"
        if L18_2 then
          goto lbl_176
        end
      end
      L18_2 = "admin"
      ::lbl_176::
      L7_2[L17_2] = L18_2
    end
    L11_2 = ipairs
    L12_2 = MySQL
    L12_2 = L12_2.query
    L12_2 = L12_2.await
    L13_2 = "SELECT channel_id, muted, last_read FROM apex_phone_recado_channel_followers WHERE number = ? AND channel_id IN (%s)"
    L14_2 = L13_2
    L13_2 = L13_2.format
    L15_2 = L2_1
    L16_2 = #L6_2
    L15_2, L16_2, L17_2, L18_2, L19_2, L20_2, L21_2, L22_2, L23_2, L24_2, L25_2 = L15_2(L16_2)
    L13_2 = L13_2(L14_2, L15_2, L16_2, L17_2, L18_2, L19_2, L20_2, L21_2, L22_2, L23_2, L24_2, L25_2)
    L14_2 = L10_2
    L12_2 = L12_2(L13_2, L14_2)
    if not L12_2 then
      L12_2 = {}
    end
    L11_2, L12_2, L13_2, L14_2 = L11_2(L12_2)
    for L15_2, L16_2 in L11_2, L12_2, L13_2, L14_2 do
      L17_2 = math
      L17_2 = L17_2.tointeger
      L18_2 = tonumber
      L19_2 = L16_2.channel_id
      L18_2, L19_2, L20_2, L21_2, L22_2, L23_2, L24_2, L25_2 = L18_2(L19_2)
      L17_2 = L17_2(L18_2, L19_2, L20_2, L21_2, L22_2, L23_2, L24_2, L25_2)
      if not L17_2 then
        L17_2 = 0
      end
      L18_2 = {}
      L19_2 = tonumber
      L20_2 = L16_2.muted
      L19_2 = L19_2(L20_2)
      if not L19_2 then
        L19_2 = 1
      end
      L19_2 = 1 == L19_2
      L18_2.muted = L19_2
      L19_2 = L1_1
      L20_2 = L16_2.last_read
      L19_2 = L19_2(L20_2)
      if not L19_2 then
        L19_2 = 0
      end
      L18_2.lastRead = L19_2
      L8_2[L17_2] = L18_2
    end
    L11_2 = pcall
    L12_2 = MySQL
    L12_2 = L12_2.query
    L12_2 = L12_2.await
    L13_2 = [[
SELECT p.channel_id AS cid, COUNT(*) AS n FROM apex_phone_recado_channel_followers f
            JOIN apex_phone_recado_channel_posts p ON p.channel_id = f.channel_id AND p.id > COALESCE(f.last_read, 0)
            WHERE f.number = ? AND f.channel_id IN (%s) GROUP BY p.channel_id]]
    L14_2 = L13_2
    L13_2 = L13_2.format
    L15_2 = L2_1
    L16_2 = #L6_2
    L15_2, L16_2, L17_2, L18_2, L19_2, L20_2, L21_2, L22_2, L23_2, L24_2, L25_2 = L15_2(L16_2)
    L13_2 = L13_2(L14_2, L15_2, L16_2, L17_2, L18_2, L19_2, L20_2, L21_2, L22_2, L23_2, L24_2, L25_2)
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
          L19_2 = math
          L19_2 = L19_2.tointeger
          L20_2 = tonumber
          L21_2 = L18_2.cid
          L20_2, L21_2, L22_2, L23_2, L24_2, L25_2 = L20_2(L21_2)
          L19_2 = L19_2(L20_2, L21_2, L22_2, L23_2, L24_2, L25_2)
          if not L19_2 then
            L19_2 = 0
          end
          L20_2 = math
          L20_2 = L20_2.tointeger
          L21_2 = tonumber
          L22_2 = L18_2.n
          L21_2 = L21_2(L22_2)
          if not L21_2 then
            L21_2 = 0
          end
          L20_2 = L20_2(L21_2)
          L9_2[L19_2] = L20_2
        end
      end
    end
  end
  L10_2 = {}
  L11_2 = #L6_2
  if L11_2 > 0 then
    L11_2 = pcall
    L12_2 = MySQL
    L12_2 = L12_2.query
    L12_2 = L12_2.await
    L13_2 = [[
SELECT p.channel_id, p.`type`, p.content, p.payload, p.created FROM apex_phone_recado_channel_posts p
            JOIN (SELECT channel_id, MAX(id) AS m FROM apex_phone_recado_channel_posts WHERE channel_id IN (%s) GROUP BY channel_id) x ON x.m = p.id]]
    L14_2 = L13_2
    L13_2 = L13_2.format
    L15_2 = L2_1
    L16_2 = #L6_2
    L15_2, L16_2, L17_2, L18_2, L19_2, L20_2, L21_2, L22_2, L23_2, L24_2, L25_2 = L15_2(L16_2)
    L13_2 = L13_2(L14_2, L15_2, L16_2, L17_2, L18_2, L19_2, L20_2, L21_2, L22_2, L23_2, L24_2, L25_2)
    L14_2 = L6_2
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
          L19_2 = L18_2.type
          if "poll" == L19_2 then
            L19_2 = L11_1
            L20_2 = L18_2.payload
            L19_2 = L19_2(L20_2)
            if L19_2 then
              goto lbl_313
            end
          end
          L19_2 = nil
          ::lbl_313::
          L20_2 = math
          L20_2 = L20_2.tointeger
          L21_2 = tonumber
          L22_2 = L18_2.channel_id
          L21_2, L22_2, L23_2, L24_2, L25_2 = L21_2(L22_2)
          L20_2 = L20_2(L21_2, L22_2, L23_2, L24_2, L25_2)
          if not L20_2 then
            L20_2 = 0
          end
          L21_2 = {}
          L22_2 = L18_2.type
          L21_2.type = L22_2
          L22_2 = L4_1
          L23_2 = L18_2.content
          if not L23_2 then
            if L19_2 then
              L23_2 = L19_2.question
              if L23_2 then
                goto lbl_336
              end
            end
            L23_2 = ""
          end
          ::lbl_336::
          L24_2 = 90
          L22_2 = L22_2(L23_2, L24_2)
          L21_2.preview = L22_2
          L22_2 = tonumber
          L23_2 = L18_2.created
          L22_2 = L22_2(L23_2)
          L21_2.created = L22_2
          L10_2[L20_2] = L21_2
        end
      end
    end
  end
  L11_2 = {}
  L12_2 = {}
  L13_2 = ipairs
  L14_2 = L4_2
  L13_2, L14_2, L15_2, L16_2 = L13_2(L14_2)
  for L17_2, L18_2 in L13_2, L14_2, L15_2, L16_2 do
    L19_2 = math
    L19_2 = L19_2.tointeger
    L20_2 = tonumber
    L21_2 = L18_2.id
    L20_2, L21_2, L22_2, L23_2, L24_2, L25_2 = L20_2(L21_2)
    L19_2 = L19_2(L20_2, L21_2, L22_2, L23_2, L24_2, L25_2)
    if L19_2 then
      L20_2 = L12_2[L19_2]
      if not L20_2 then
        L12_2[L19_2] = true
        L18_2.id = L19_2
        L20_2 = L1_1
        L21_2 = L18_2.avatar
        L20_2 = L20_2(L21_2)
        L18_2.avatar = L20_2
        L20_2 = tonumber
        L21_2 = L18_2.listed
        L20_2 = L20_2(L21_2)
        if not L20_2 then
          L20_2 = 0
        end
        L20_2 = 1 == L20_2
        L18_2.listed = L20_2
        L20_2 = tonumber
        L21_2 = L18_2.verified
        L20_2 = L20_2(L21_2)
        if not L20_2 then
          L20_2 = 0
        end
        L20_2 = 1 == L20_2
        L18_2.verified = L20_2
        L20_2 = math
        L20_2 = L20_2.tointeger
        L21_2 = tonumber
        L22_2 = L18_2.followers
        L21_2 = L21_2(L22_2)
        if not L21_2 then
          L21_2 = 0
        end
        L20_2 = L20_2(L21_2)
        if not L20_2 then
          L20_2 = 0
        end
        L18_2.followers = L20_2
        L20_2 = L69_1
        L21_2 = L18_2
        L22_2 = L7_2[L19_2]
        L23_2 = L8_2[L19_2]
        L24_2 = {}
        L25_2 = L9_2[L19_2]
        L24_2.unread = L25_2
        L25_2 = L10_2[L19_2]
        L24_2.last = L25_2
        L20_2 = L20_2(L21_2, L22_2, L23_2, L24_2)
        L21_2 = #L11_2
        L21_2 = L21_2 + 1
        L11_2[L21_2] = L20_2
      end
    end
  end
  return L11_2
end
L74_1(L75_1, L76_1)
function L74_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2
  L2_2 = tonumber
  L3_2 = MySQL
  L3_2 = L3_2.update
  L3_2 = L3_2.await
  L4_2 = "INSERT IGNORE INTO apex_phone_recado_channel_followers (channel_id, number, muted, last_read, created) VALUES (?, ?, 1, ?, ?)"
  L5_2 = {}
  L6_2 = A0_2.id
  L7_2 = A1_2
  L8_2 = math
  L8_2 = L8_2.tointeger
  L9_2 = tonumber
  L10_2 = MySQL
  L10_2 = L10_2.scalar
  L10_2 = L10_2.await
  L11_2 = "SELECT MAX(id) FROM apex_phone_recado_channel_posts WHERE channel_id = ?"
  L12_2 = {}
  L13_2 = A0_2.id
  L12_2[1] = L13_2
  L10_2, L11_2, L12_2, L13_2 = L10_2(L11_2, L12_2)
  L9_2, L10_2, L11_2, L12_2, L13_2 = L9_2(L10_2, L11_2, L12_2, L13_2)
  L8_2 = L8_2(L9_2, L10_2, L11_2, L12_2, L13_2)
  if not L8_2 then
    L8_2 = 0
  end
  L9_2 = Now
  L9_2, L10_2, L11_2, L12_2, L13_2 = L9_2()
  L5_2[1] = L6_2
  L5_2[2] = L7_2
  L5_2[3] = L8_2
  L5_2[4] = L9_2
  L5_2[5] = L10_2
  L5_2[6] = L11_2
  L5_2[7] = L12_2
  L5_2[8] = L13_2
  L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2 = L3_2(L4_2, L5_2)
  L2_2 = L2_2(L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2)
  if not L2_2 then
    L2_2 = 0
  end
  if L2_2 > 0 then
    L3_2 = MySQL
    L3_2 = L3_2.update
    L3_2 = L3_2.await
    L4_2 = "UPDATE apex_phone_recado_channels SET followers = followers + 1 WHERE id = ?"
    L5_2 = {}
    L6_2 = A0_2.id
    L5_2[1] = L6_2
    L3_2(L4_2, L5_2)
  end
  L3_2 = L2_2 > 0
  return L3_2
end
L75_1 = L36_1
L76_1 = "recado.channel.follow"
function L77_1(A0_2, A1_2, A2_2)
  local L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2
  L3_2 = L70_1
  L4_2 = A0_2
  L5_2 = A2_2
  L6_2 = A1_2.id
  L3_2, L4_2 = L3_2(L4_2, L5_2, L6_2)
  if not L3_2 then
    L5_2 = L3_1
    L6_2 = L4_2
    return L5_2(L6_2)
  end
  L5_2 = L23_1
  L6_2 = A0_2
  L7_2 = "channel.follow"
  L8_2 = 600
  L5_2 = L5_2(L6_2, L7_2, L8_2)
  if L5_2 then
    L5_2 = L3_1
    L6_2 = "cooldown"
    return L5_2(L6_2)
  end
  L5_2 = L74_1
  L6_2 = L3_2
  L7_2 = A2_2
  L5_2(L6_2, L7_2)
  L5_2 = L69_1
  L6_2 = L65_1
  L7_2 = L3_2.id
  L6_2 = L6_2(L7_2)
  L7_2 = L66_1
  L8_2 = L3_2.id
  L9_2 = A2_2
  L7_2 = L7_2(L8_2, L9_2)
  L8_2 = L67_1
  L9_2 = L3_2.id
  L10_2 = A2_2
  L8_2, L9_2, L10_2 = L8_2(L9_2, L10_2)
  L5_2 = L5_2(L6_2, L7_2, L8_2, L9_2, L10_2)
  L5_2.ok = true
  return L5_2
end
L75_1(L76_1, L77_1)
L75_1 = L36_1
L76_1 = "recado.channel.unfollow"
function L77_1(A0_2, A1_2, A2_2)
  local L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2
  L3_2 = L1_1
  L4_2 = A1_2.id
  L3_2 = L3_2(L4_2)
  if not L3_2 then
    L4_2 = L3_1
    L5_2 = "invalid"
    return L4_2(L5_2)
  end
  L4_2 = tonumber
  L5_2 = MySQL
  L5_2 = L5_2.update
  L5_2 = L5_2.await
  L6_2 = "DELETE FROM apex_phone_recado_channel_followers WHERE channel_id = ? AND number = ?"
  L7_2 = {}
  L8_2 = L3_2
  L9_2 = A2_2
  L7_2[1] = L8_2
  L7_2[2] = L9_2
  L5_2, L6_2, L7_2, L8_2, L9_2 = L5_2(L6_2, L7_2)
  L4_2 = L4_2(L5_2, L6_2, L7_2, L8_2, L9_2)
  if not L4_2 then
    L4_2 = 0
  end
  if L4_2 > 0 then
    L5_2 = MySQL
    L5_2 = L5_2.update
    L5_2 = L5_2.await
    L6_2 = "UPDATE apex_phone_recado_channels SET followers = GREATEST(followers - 1, 0) WHERE id = ?"
    L7_2 = {}
    L8_2 = L3_2
    L7_2[1] = L8_2
    L5_2(L6_2, L7_2)
  end
  L5_2 = tonumber
  L6_2 = A0_2
  L5_2 = L5_2(L6_2)
  L6_2 = L24_1
  L6_2[L5_2] = nil
  L5_2 = {}
  L5_2.ok = true
  L5_2.id = L3_2
  L5_2.following = false
  return L5_2
end
L75_1(L76_1, L77_1)
L75_1 = L36_1
L76_1 = "recado.channel.mute"
function L77_1(A0_2, A1_2, A2_2)
  local L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2
  L3_2 = L1_1
  L4_2 = A1_2.id
  L3_2 = L3_2(L4_2)
  if not L3_2 then
    L4_2 = L3_1
    L5_2 = "invalid"
    return L4_2(L5_2)
  end
  L4_2 = L15_1
  L5_2 = A1_2.on
  L4_2 = L4_2(L5_2)
  if L4_2 then
    L4_2 = 1
    if L4_2 then
      goto lbl_19
    end
  end
  L4_2 = 0
  ::lbl_19::
  L5_2 = tonumber
  L6_2 = MySQL
  L6_2 = L6_2.update
  L6_2 = L6_2.await
  L7_2 = "UPDATE apex_phone_recado_channel_followers SET muted = ? WHERE channel_id = ? AND number = ?"
  L8_2 = {}
  L9_2 = L4_2
  L10_2 = L3_2
  L11_2 = A2_2
  L8_2[1] = L9_2
  L8_2[2] = L10_2
  L8_2[3] = L11_2
  L6_2, L7_2, L8_2, L9_2, L10_2, L11_2 = L6_2(L7_2, L8_2)
  L5_2 = L5_2(L6_2, L7_2, L8_2, L9_2, L10_2, L11_2)
  if not L5_2 then
    L5_2 = 0
  end
  if L5_2 < 1 then
    L6_2 = L67_1
    L7_2 = L3_2
    L8_2 = A2_2
    L6_2 = L6_2(L7_2, L8_2)
    if not L6_2 then
      L6_2 = L3_1
      L7_2 = "notfound"
      return L6_2(L7_2)
    end
  end
  L6_2 = {}
  L6_2.ok = true
  L6_2.id = L3_2
  L7_2 = 1 == L4_2
  L6_2.muted = L7_2
  return L6_2
end
L75_1(L76_1, L77_1)
function L75_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2, L19_2
  L2_2 = {}
  L3_2 = #A0_2
  if 0 == L3_2 then
    return L2_2
  end
  L3_2 = ipairs
  L4_2 = MySQL
  L4_2 = L4_2.query
  L4_2 = L4_2.await
  L5_2 = "SELECT post_id, number, options FROM apex_phone_recado_channel_votes WHERE post_id IN (%s) LIMIT 20000"
  L6_2 = L5_2
  L5_2 = L5_2.format
  L7_2 = L2_1
  L8_2 = #A0_2
  L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2, L19_2 = L7_2(L8_2)
  L5_2 = L5_2(L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2, L19_2)
  L6_2 = A0_2
  L4_2 = L4_2(L5_2, L6_2)
  if not L4_2 then
    L4_2 = {}
  end
  L3_2, L4_2, L5_2, L6_2 = L3_2(L4_2)
  for L7_2, L8_2 in L3_2, L4_2, L5_2, L6_2 do
    L9_2 = math
    L9_2 = L9_2.tointeger
    L10_2 = tonumber
    L11_2 = L8_2.post_id
    L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2, L19_2 = L10_2(L11_2)
    L9_2 = L9_2(L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2, L19_2)
    if not L9_2 then
      L9_2 = 0
    end
    L10_2 = L2_2[L9_2]
    if not L10_2 then
      L11_2 = {}
      L12_2 = {}
      L11_2.counts = L12_2
      L11_2.total = 0
      L10_2 = L11_2
      L2_2[L9_2] = L10_2
    end
    L11_2 = L10_2.total
    L11_2 = L11_2 + 1
    L10_2.total = L11_2
    L11_2 = tostring
    L12_2 = L8_2.number
    L11_2 = L11_2(L12_2)
    L11_2 = L11_2 == A1_2
    L12_2 = tostring
    L13_2 = L8_2.options
    L12_2 = L12_2(L13_2)
    L13_2 = L12_2
    L12_2 = L12_2.gmatch
    L14_2 = "%d+"
    L12_2, L13_2, L14_2, L15_2 = L12_2(L13_2, L14_2)
    for L16_2 in L12_2, L13_2, L14_2, L15_2 do
      L17_2 = math
      L17_2 = L17_2.tointeger
      L18_2 = tonumber
      L19_2 = L16_2
      L18_2, L19_2 = L18_2(L19_2)
      L17_2 = L17_2(L18_2, L19_2)
      if L17_2 then
        L18_2 = L10_2.counts
        L19_2 = L10_2.counts
        L19_2 = L19_2[L17_2]
        if not L19_2 then
          L19_2 = 0
        end
        L19_2 = L19_2 + 1
        L18_2[L17_2] = L19_2
        if L11_2 then
          L18_2 = L10_2.mine
          if not L18_2 then
            L18_2 = {}
          end
          L10_2.mine = L18_2
          L18_2 = L10_2.mine
          L19_2 = L10_2.mine
          L19_2 = #L19_2
          L19_2 = L19_2 + 1
          L18_2[L19_2] = L17_2
        end
      end
    end
  end
  return L2_2
end
function L76_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2
  L2_2 = {}
  L3_2 = ipairs
  L4_2 = type
  L5_2 = A0_2
  L4_2 = L4_2(L5_2)
  if "table" == L4_2 then
    L4_2 = type
    L5_2 = A0_2.options
    L4_2 = L4_2(L5_2)
    if "table" == L4_2 then
      L4_2 = A0_2.options
      if L4_2 then
        goto lbl_19
      end
    end
  end
  L4_2 = {}
  ::lbl_19::
  L3_2, L4_2, L5_2, L6_2 = L3_2(L4_2)
  for L7_2, L8_2 in L3_2, L4_2, L5_2, L6_2 do
    L9_2 = #L2_2
    L9_2 = L9_2 + 1
    L10_2 = {}
    L11_2 = tostring
    L12_2 = L8_2
    L11_2 = L11_2(L12_2)
    L10_2.text = L11_2
    if A1_2 then
      L11_2 = A1_2.counts
      L12_2 = L7_2 - 1
      L11_2 = L11_2[L12_2]
      if L11_2 then
        goto lbl_39
      end
    end
    L11_2 = 0
    ::lbl_39::
    L10_2.votes = L11_2
    L2_2[L9_2] = L10_2
  end
  L3_2 = {}
  L4_2 = type
  L5_2 = A0_2
  L4_2 = L4_2(L5_2)
  if "table" == L4_2 then
    L4_2 = A0_2.question
    if L4_2 then
      goto lbl_55
    end
  end
  L4_2 = ""
  ::lbl_55::
  L3_2.question = L4_2
  L3_2.options = L2_2
  L4_2 = type
  L5_2 = A0_2
  L4_2 = L4_2(L5_2)
  if "table" == L4_2 then
    L4_2 = A0_2.multi
  end
  L4_2 = true == L4_2 or L4_2
  L3_2.multi = L4_2
  if A1_2 then
    L4_2 = A1_2.total
    if L4_2 then
      goto lbl_76
    end
  end
  L4_2 = 0
  ::lbl_76::
  L3_2.total = L4_2
  if A1_2 then
    L4_2 = A1_2.mine
    if L4_2 then
      goto lbl_83
    end
  end
  L4_2 = nil
  ::lbl_83::
  L3_2.mine = L4_2
  return L3_2
end
function L77_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2, L19_2
  L2_2 = {}
  L3_2 = {}
  L4_2 = ipairs
  L5_2 = A0_2
  L4_2, L5_2, L6_2, L7_2 = L4_2(L5_2)
  for L8_2, L9_2 in L4_2, L5_2, L6_2, L7_2 do
    L10_2 = math
    L10_2 = L10_2.tointeger
    L11_2 = tonumber
    L12_2 = L9_2.id
    L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2, L19_2 = L11_2(L12_2)
    L10_2 = L10_2(L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2, L19_2)
    L11_2 = #L2_2
    L11_2 = L11_2 + 1
    L2_2[L11_2] = L10_2
    L11_2 = L9_2.type
    if "poll" == L11_2 then
      L11_2 = #L3_2
      L11_2 = L11_2 + 1
      L3_2[L11_2] = L10_2
    end
  end
  L4_2 = {}
  L5_2 = {}
  L6_2 = #L2_2
  if L6_2 > 0 then
    L6_2 = ipairs
    L7_2 = MySQL
    L7_2 = L7_2.query
    L7_2 = L7_2.await
    L8_2 = "SELECT post_id, emoji, COUNT(*) AS n FROM apex_phone_recado_channel_reactions WHERE post_id IN (%s) GROUP BY post_id, emoji"
    L9_2 = L8_2
    L8_2 = L8_2.format
    L10_2 = L2_1
    L11_2 = #L2_2
    L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2, L19_2 = L10_2(L11_2)
    L8_2 = L8_2(L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2, L19_2)
    L9_2 = L2_2
    L7_2 = L7_2(L8_2, L9_2)
    if not L7_2 then
      L7_2 = {}
    end
    L6_2, L7_2, L8_2, L9_2 = L6_2(L7_2)
    for L10_2, L11_2 in L6_2, L7_2, L8_2, L9_2 do
      L12_2 = math
      L12_2 = L12_2.tointeger
      L13_2 = tonumber
      L14_2 = L11_2.post_id
      L13_2, L14_2, L15_2, L16_2, L17_2, L18_2, L19_2 = L13_2(L14_2)
      L12_2 = L12_2(L13_2, L14_2, L15_2, L16_2, L17_2, L18_2, L19_2)
      if not L12_2 then
        L12_2 = 0
      end
      L13_2 = L4_2[L12_2]
      if not L13_2 then
        L13_2 = {}
      end
      L4_2[L12_2] = L13_2
      L13_2 = table
      L13_2 = L13_2.insert
      L14_2 = L4_2[L12_2]
      L15_2 = {}
      L16_2 = L11_2.emoji
      L15_2.emoji = L16_2
      L16_2 = math
      L16_2 = L16_2.tointeger
      L17_2 = tonumber
      L18_2 = L11_2.n
      L17_2 = L17_2(L18_2)
      if not L17_2 then
        L17_2 = 0
      end
      L16_2 = L16_2(L17_2)
      if not L16_2 then
        L16_2 = 0
      end
      L15_2.n = L16_2
      L13_2(L14_2, L15_2)
    end
    L6_2 = {}
    L7_2 = A1_2
    L6_2[1] = L7_2
    L7_2 = ipairs
    L8_2 = L2_2
    L7_2, L8_2, L9_2, L10_2 = L7_2(L8_2)
    for L11_2, L12_2 in L7_2, L8_2, L9_2, L10_2 do
      L13_2 = #L6_2
      L13_2 = L13_2 + 1
      L6_2[L13_2] = L12_2
    end
    L7_2 = ipairs
    L8_2 = MySQL
    L8_2 = L8_2.query
    L8_2 = L8_2.await
    L9_2 = "SELECT post_id, emoji FROM apex_phone_recado_channel_reactions WHERE number = ? AND post_id IN (%s)"
    L10_2 = L9_2
    L9_2 = L9_2.format
    L11_2 = L2_1
    L12_2 = #L2_2
    L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2, L19_2 = L11_2(L12_2)
    L9_2 = L9_2(L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2, L19_2)
    L10_2 = L6_2
    L8_2 = L8_2(L9_2, L10_2)
    if not L8_2 then
      L8_2 = {}
    end
    L7_2, L8_2, L9_2, L10_2 = L7_2(L8_2)
    for L11_2, L12_2 in L7_2, L8_2, L9_2, L10_2 do
      L13_2 = math
      L13_2 = L13_2.tointeger
      L14_2 = tonumber
      L15_2 = L12_2.post_id
      L14_2, L15_2, L16_2, L17_2, L18_2, L19_2 = L14_2(L15_2)
      L13_2 = L13_2(L14_2, L15_2, L16_2, L17_2, L18_2, L19_2)
      if not L13_2 then
        L13_2 = 0
      end
      L14_2 = L12_2.emoji
      L5_2[L13_2] = L14_2
    end
  end
  L6_2 = L75_1
  L7_2 = L3_2
  L8_2 = A1_2
  L6_2 = L6_2(L7_2, L8_2)
  L7_2 = {}
  L8_2 = ipairs
  L9_2 = A0_2
  L8_2, L9_2, L10_2, L11_2 = L8_2(L9_2)
  for L12_2, L13_2 in L8_2, L9_2, L10_2, L11_2 do
    L14_2 = math
    L14_2 = L14_2.tointeger
    L15_2 = tonumber
    L16_2 = L13_2.id
    L15_2, L16_2, L17_2, L18_2, L19_2 = L15_2(L16_2)
    L14_2 = L14_2(L15_2, L16_2, L17_2, L18_2, L19_2)
    L15_2 = L11_1
    L16_2 = L13_2.payload
    L15_2 = L15_2(L16_2)
    L16_2 = {}
    L16_2.id = L14_2
    L17_2 = math
    L17_2 = L17_2.tointeger
    L18_2 = tonumber
    L19_2 = L13_2.channel_id
    L18_2, L19_2 = L18_2(L19_2)
    L17_2 = L17_2(L18_2, L19_2)
    L16_2.channel = L17_2
    L17_2 = L13_2.type
    if not L17_2 then
      L17_2 = "text"
    end
    L16_2.type = L17_2
    L17_2 = L13_2.content
    L16_2.content = L17_2
    L17_2 = L1_1
    L18_2 = L13_2.media_id
    L17_2 = L17_2(L18_2)
    L16_2.mediaId = L17_2
    L17_2 = tonumber
    L18_2 = L13_2.created
    L17_2 = L17_2(L18_2)
    L16_2.created = L17_2
    L17_2 = tonumber
    L18_2 = L13_2.edited
    L17_2 = L17_2(L18_2)
    L16_2.edited = L17_2
    L17_2 = L5_2[L14_2]
    L16_2.myReaction = L17_2
    L17_2 = L4_2[L14_2]
    if L17_2 then
      L17_2 = table
      L17_2 = L17_2.sort
      L18_2 = L4_2[L14_2]
      function L19_2(A0_3, A1_3)
        local L2_3, L3_3
        L2_3 = A0_3.n
        L3_3 = A1_3.n
        L2_3 = L2_3 > L3_3
        return L2_3
      end
      L17_2(L18_2, L19_2)
      L17_2 = L4_2[L14_2]
      L16_2.reactions = L17_2
    end
    L17_2 = L16_2.type
    if "poll" == L17_2 then
      L17_2 = L76_1
      L18_2 = L15_2
      L19_2 = L6_2[L14_2]
      L17_2 = L17_2(L18_2, L19_2)
      L16_2.poll = L17_2
    else
      L17_2 = L16_2.type
      if "audio" == L17_2 and L15_2 then
        L17_2 = {}
        L18_2 = L15_2.duration
        L17_2.duration = L18_2
        L18_2 = L15_2.waveform
        L17_2.waveform = L18_2
        L16_2.payload = L17_2
      else
        L17_2 = L16_2.type
        if "sticker" == L17_2 and L15_2 then
          L17_2 = {}
          L18_2 = L15_2.pack
          L17_2.pack = L18_2
          L18_2 = L15_2.id
          L17_2.id = L18_2
          L16_2.payload = L17_2
        end
      end
    end
    L17_2 = #L7_2
    L17_2 = L17_2 + 1
    L7_2[L17_2] = L16_2
  end
  return L7_2
end
L78_1 = "SELECT id, channel_id, author, `type`, content, payload, media_id, created, edited FROM apex_phone_recado_channel_posts"
L79_1 = L36_1
L80_1 = "recado.channel.post"
function L81_1(A0_2, A1_2, A2_2, A3_2)
  local L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2, L19_2, L20_2, L21_2, L22_2, L23_2, L24_2, L25_2, L26_2, L27_2, L28_2, L29_2
  L4_2 = HasPhoneItem
  L5_2 = A0_2
  L4_2 = L4_2(L5_2)
  if not L4_2 then
    L4_2 = L3_1
    L5_2 = "nophone"
    return L4_2(L5_2)
  end
  L4_2 = L1_1
  L5_2 = A1_2.id
  L4_2 = L4_2(L5_2)
  if not L4_2 then
    L5_2 = L3_1
    L6_2 = "invalid"
    return L5_2(L6_2)
  end
  L5_2 = L65_1
  L6_2 = L4_2
  L5_2 = L5_2(L6_2)
  if not L5_2 then
    L6_2 = L3_1
    L7_2 = "notfound"
    return L6_2(L7_2)
  end
  L6_2 = L66_1
  L7_2 = L4_2
  L8_2 = A2_2
  L6_2 = L6_2(L7_2, L8_2)
  if not L6_2 then
    L7_2 = L3_1
    L8_2 = L5_2.listed
    if L8_2 then
      L8_2 = "notadmin"
      if L8_2 then
        goto lbl_42
      end
    end
    L8_2 = "notfound"
    ::lbl_42::
    return L7_2(L8_2)
  end
  L8_2 = A1_2.type
  L7_2 = L60_1
  L7_2 = L7_2[L8_2]
  if L7_2 then
    L7_2 = A1_2.type
    if L7_2 then
      goto lbl_53
    end
  end
  L7_2 = nil
  ::lbl_53::
  if not L7_2 then
    L8_2 = L3_1
    L9_2 = "badtype"
    return L8_2(L9_2)
  end
  L8_2 = L23_1
  L9_2 = A0_2
  L10_2 = "channel.post"
  L11_2 = 1500
  L8_2 = L8_2(L9_2, L10_2, L11_2)
  if L8_2 then
    L8_2 = L3_1
    L9_2 = "cooldown"
    return L8_2(L9_2)
  end
  L8_2 = nil
  L9_2 = nil
  L10_2 = nil
  if "text" == L7_2 then
    L11_2 = L8_1
    L12_2 = A1_2.content
    L13_2 = 2000
    L11_2 = L11_2(L12_2, L13_2)
    L8_2 = L11_2
    if not L8_2 then
      L11_2 = L3_1
      L12_2 = "empty"
      return L11_2(L12_2)
    end
  elseif "image" == L7_2 or "audio" == L7_2 then
    L11_2 = L28_1
    L12_2 = A3_2
    L13_2 = A1_2.mediaId
    if not L13_2 then
      L13_2 = type
      L14_2 = A1_2.payload
      L13_2 = L13_2(L14_2)
      L13_2 = A1_2.payload
      L13_2 = "table" == L13_2 and L13_2
    end
    L14_2 = L7_2
    L11_2, L12_2 = L11_2(L12_2, L13_2, L14_2)
    if not L11_2 then
      L13_2 = L3_1
      L14_2 = "media"
      return L13_2(L14_2)
    end
    L10_2 = L11_2
    L13_2 = A1_2.content
    if nil ~= L13_2 then
      L13_2 = A1_2.content
      if "" ~= L13_2 then
        L13_2 = L8_1
        L14_2 = A1_2.content
        L15_2 = 1000
        L13_2 = L13_2(L14_2, L15_2)
        L8_2 = L13_2
      end
    end
    if "audio" ~= L7_2 then
      goto lbl_344
    end
    L13_2 = type
    L14_2 = L12_2.meta
    L13_2 = L13_2(L14_2)
    if "table" == L13_2 then
      L13_2 = type
      L14_2 = L12_2.meta
      L14_2 = L14_2.waveform
      L13_2 = L13_2(L14_2)
      if "table" == L13_2 then
        L13_2 = L12_2.meta
        L13_2 = L13_2.waveform
        if L13_2 then
          goto lbl_142
        end
      end
    end
    L13_2 = nil
    ::lbl_142::
    L14_2 = {}
    L15_2 = ipairs
    L16_2 = L13_2 or L16_2
    if not L13_2 then
      L16_2 = {}
    end
    L15_2, L16_2, L17_2, L18_2 = L15_2(L16_2)
    for L19_2, L20_2 in L15_2, L16_2, L17_2, L18_2 do
      if L19_2 > 64 then
        break
      end
      L21_2 = tonumber
      L22_2 = L20_2
      L21_2 = L21_2(L22_2)
      if L21_2 and L21_2 == L21_2 then
        L22_2 = #L14_2
        L22_2 = L22_2 + 1
        L23_2 = math
        L23_2 = L23_2.floor
        L24_2 = math
        L24_2 = L24_2.max
        L25_2 = 0
        L26_2 = math
        L26_2 = L26_2.min
        L27_2 = 1
        L28_2 = L21_2
        L26_2 = L26_2(L27_2, L28_2)
        L24_2 = L24_2(L25_2, L26_2)
        L24_2 = L24_2 * 100
        L24_2 = L24_2 + 0.5
        L23_2 = L23_2(L24_2)
        L23_2 = L23_2 / 100
        L14_2[L22_2] = L23_2
      end
    end
    L15_2 = {}
    L16_2 = L12_2.duration
    L15_2.duration = L16_2
    L16_2 = #L14_2
    L16_2 = L14_2 or L16_2
    if not (L16_2 > 0) or not L14_2 then
      L16_2 = nil
    end
    L15_2.waveform = L16_2
    L9_2 = L15_2
  elseif "sticker" == L7_2 then
    L11_2 = type
    L12_2 = A1_2.payload
    L11_2 = L11_2(L12_2)
    if "table" == L11_2 then
      L11_2 = A1_2.payload
      if L11_2 then
        goto lbl_210
      end
    end
    L11_2 = {}
    ::lbl_210::
    L12_2 = tostring
    L13_2 = L11_2.pack
    if not L13_2 then
      L13_2 = ""
    end
    L12_2 = L12_2(L13_2)
    L13_2 = tostring
    L14_2 = L11_2.id
    if not L14_2 then
      L14_2 = ""
    end
    L13_2 = L13_2(L14_2)
    L14_2 = #L12_2
    if not (L14_2 > 20) then
      L14_2 = #L13_2
      if not (L14_2 > 20) then
        L15_2 = L12_2
        L14_2 = L12_2.match
        L16_2 = "^[%w_%-]+$"
        L14_2 = L14_2(L15_2, L16_2)
        if L14_2 then
          L15_2 = L13_2
          L14_2 = L13_2.match
          L16_2 = "^[%w_%-]+$"
          L14_2 = L14_2(L15_2, L16_2)
          if L14_2 then
            goto lbl_242
          end
        end
      end
    end
    L14_2 = L3_1
    L15_2 = "invalid"
    do return L14_2(L15_2) end
    ::lbl_242::
    L14_2 = type
    L15_2 = RecadoValidSticker
    L14_2 = L14_2(L15_2)
    if "function" == L14_2 then
      L14_2 = RecadoValidSticker
      L15_2 = {}
      L15_2.pack = L12_2
      L15_2.id = L13_2
      L14_2 = L14_2(L15_2)
      if not L14_2 then
        L14_2 = L3_1
        L15_2 = "invalid"
        return L14_2(L15_2)
      end
    end
    L14_2 = {}
    L14_2.pack = L12_2
    L14_2.id = L13_2
    L9_2 = L14_2
  else
    L11_2 = type
    L12_2 = A1_2.payload
    L11_2 = L11_2(L12_2)
    if "table" == L11_2 then
      L11_2 = A1_2.payload
      if L11_2 then
        goto lbl_275
      end
    end
    L11_2 = {}
    ::lbl_275::
    L12_2 = L7_1
    L13_2 = L11_2.question
    L14_2 = 200
    L12_2 = L12_2(L13_2, L14_2)
    if not L12_2 then
      L13_2 = L3_1
      L14_2 = "empty"
      return L13_2(L14_2)
    end
    L13_2 = type
    L14_2 = L11_2.options
    L13_2 = L13_2(L14_2)
    if "table" ~= L13_2 then
      L13_2 = L3_1
      L14_2 = "invalid"
      return L13_2(L14_2)
    end
    L13_2 = {}
    L14_2 = ipairs
    L15_2 = L11_2.options
    L14_2, L15_2, L16_2, L17_2 = L14_2(L15_2)
    for L18_2, L19_2 in L14_2, L15_2, L16_2, L17_2 do
      L20_2 = L62_1
      L20_2 = L20_2()
      if L18_2 > L20_2 then
        L20_2 = L3_1
        L21_2 = "toomany"
        L22_2 = {}
        L23_2 = L62_1
        L23_2 = L23_2()
        L22_2.max = L23_2
        L20_2, L21_2, L22_2, L23_2, L24_2, L25_2, L26_2, L27_2, L28_2, L29_2 = L20_2(L21_2, L22_2)
        return L20_2, L21_2, L22_2, L23_2, L24_2, L25_2, L26_2, L27_2, L28_2, L29_2
      end
      L20_2 = L7_1
      L21_2 = L19_2
      L22_2 = 80
      L20_2 = L20_2(L21_2, L22_2)
      if L20_2 then
        L21_2 = #L13_2
        L21_2 = L21_2 + 1
        L13_2[L21_2] = L20_2
      end
    end
    L14_2 = #L13_2
    if L14_2 < 2 then
      L14_2 = L3_1
      L15_2 = "invalid"
      return L14_2(L15_2)
    end
    L14_2 = {}
    L14_2.question = L12_2
    L14_2.options = L13_2
    L15_2 = L11_2.multi
    L15_2 = true == L15_2
    L14_2.multi = L15_2
    L9_2 = L14_2
  end
  ::lbl_344::
  L11_2 = L12_1
  L12_2 = L9_2
  L11_2 = L11_2(L12_2)
  L12_2 = Now
  L12_2 = L12_2()
  L13_2 = L1_1
  L14_2 = MySQL
  L14_2 = L14_2.insert
  L14_2 = L14_2.await
  L15_2 = "INSERT INTO apex_phone_recado_channel_posts (channel_id, author, `type`, content, payload, media_id, created) VALUES (?, ?, ?, ?, ?, ?, ?)"
  L16_2 = {}
  L17_2 = L4_2
  L18_2 = A2_2
  L19_2 = L7_2
  L20_2 = L8_2
  L21_2 = L11_2
  L22_2 = L10_2
  L23_2 = L12_2
  L16_2[1] = L17_2
  L16_2[2] = L18_2
  L16_2[3] = L19_2
  L16_2[4] = L20_2
  L16_2[5] = L21_2
  L16_2[6] = L22_2
  L16_2[7] = L23_2
  L14_2, L15_2, L16_2, L17_2, L18_2, L19_2, L20_2, L21_2, L22_2, L23_2, L24_2, L25_2, L26_2, L27_2, L28_2, L29_2 = L14_2(L15_2, L16_2)
  L13_2 = L13_2(L14_2, L15_2, L16_2, L17_2, L18_2, L19_2, L20_2, L21_2, L22_2, L23_2, L24_2, L25_2, L26_2, L27_2, L28_2, L29_2)
  if not L13_2 then
    L14_2 = L3_1
    L15_2 = "db"
    return L14_2(L15_2)
  end
  L14_2 = MySQL
  L14_2 = L14_2.update
  L14_2 = L14_2.await
  L15_2 = "UPDATE apex_phone_recado_channels SET last_post = ? WHERE id = ?"
  L16_2 = {}
  L17_2 = L12_2
  L18_2 = L4_2
  L16_2[1] = L17_2
  L16_2[2] = L18_2
  L14_2(L15_2, L16_2)
  L14_2 = MySQL
  L14_2 = L14_2.update
  L14_2 = L14_2.await
  L15_2 = "UPDATE apex_phone_recado_channel_followers SET last_read = ? WHERE channel_id = ? AND number = ?"
  L16_2 = {}
  L17_2 = L13_2
  L18_2 = L4_2
  L19_2 = A2_2
  L16_2[1] = L17_2
  L16_2[2] = L18_2
  L16_2[3] = L19_2
  L14_2(L15_2, L16_2)
  L14_2 = MySQL
  L14_2 = L14_2.single
  L14_2 = L14_2.await
  L15_2 = L78_1
  L16_2 = " WHERE id = ?"
  L15_2 = L15_2 .. L16_2
  L16_2 = {}
  L17_2 = L13_2
  L16_2[1] = L17_2
  L14_2 = L14_2(L15_2, L16_2)
  L15_2 = L77_1
  L16_2 = {}
  L17_2 = L14_2
  L16_2[1] = L17_2
  L17_2 = A2_2
  L15_2 = L15_2(L16_2, L17_2)
  L15_2 = L15_2[1]
  if "text" == L7_2 then
    L16_2 = L4_1
    L17_2 = L8_2
    L18_2 = 120
    L16_2 = L16_2(L17_2, L18_2)
    if L16_2 then
      goto lbl_451
    end
  end
  if "image" == L7_2 then
    L16_2 = "\240\159\147\183 "
    if L8_2 then
      L17_2 = L4_1
      L18_2 = L8_2
      L19_2 = 100
      L17_2 = L17_2(L18_2, L19_2)
      if L17_2 then
        goto lbl_432
      end
    end
    L17_2 = "Foto"
    ::lbl_432::
    L16_2 = L16_2 .. L17_2
    if L16_2 then
      goto lbl_451
    end
  end
  if "audio" == L7_2 then
    L16_2 = "\240\159\142\164 Mensagem de voz"
    if L16_2 then
      goto lbl_451
    end
  end
  if "sticker" == L7_2 then
    L16_2 = "\226\156\168 Autocolante"
    if L16_2 then
      goto lbl_451
    end
  end
  L16_2 = "\240\159\147\138 "
  L17_2 = L4_1
  L18_2 = L9_2.question
  L19_2 = 100
  L17_2 = L17_2(L18_2, L19_2)
  L16_2 = L16_2 .. L17_2
  ::lbl_451::
  L17_2 = 0
  L18_2 = pairs
  L19_2 = L71_1
  L20_2 = L4_2
  L19_2, L20_2, L21_2, L22_2, L23_2, L24_2, L25_2, L26_2, L27_2, L28_2, L29_2 = L19_2(L20_2)
  L18_2, L19_2, L20_2, L21_2 = L18_2(L19_2, L20_2, L21_2, L22_2, L23_2, L24_2, L25_2, L26_2, L27_2, L28_2, L29_2)
  for L22_2, L23_2 in L18_2, L19_2, L20_2, L21_2 do
    if L22_2 ~= A2_2 then
      L24_2 = L23_2.src
      if L24_2 then
        L24_2 = HasPhoneItem
        L25_2 = L23_2.src
        L24_2 = L24_2(L25_2)
        if L24_2 then
          L24_2 = Push
          L25_2 = L23_2.src
          L26_2 = "recadoChannel"
          L27_2 = {}
          L27_2.id = L4_2
          L27_2.action = "post"
          L27_2.post = L15_2
          L28_2 = L5_2.name
          L27_2.name = L28_2
          L24_2(L25_2, L26_2, L27_2)
          L24_2 = L23_2.muted
          if not L24_2 then
            L24_2 = L23_2.admin
            if not L24_2 then
              L24_2 = 200
              if L17_2 < L24_2 then
                L17_2 = L17_2 + 1
                L24_2 = NotifyPlayer
                L25_2 = L23_2.src
                L26_2 = "recado"
                L27_2 = L5_2.name
                L28_2 = L16_2
                L29_2 = {}
                L29_2.app = "recado"
                L29_2.channel = L4_2
                L29_2.post = L13_2
                L24_2(L25_2, L26_2, L27_2, L28_2, L29_2)
              end
            end
          end
        end
      end
    end
  end
  L15_2.ok = true
  return L15_2
end
L79_1(L80_1, L81_1)
L79_1 = L36_1
L80_1 = "recado.channel.posts"
function L81_1(A0_2, A1_2, A2_2)
  local L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2, L19_2, L20_2
  L3_2 = L70_1
  L4_2 = A0_2
  L5_2 = A2_2
  L6_2 = A1_2.id
  L3_2, L4_2, L5_2, L6_2 = L3_2(L4_2, L5_2, L6_2)
  if not L3_2 then
    L7_2 = L3_1
    L8_2 = L4_2
    return L7_2(L8_2)
  end
  L7_2 = L1_1
  L8_2 = A1_2.before
  L7_2 = L7_2(L8_2)
  L8_2 = 30
  L9_2 = nil
  if L7_2 then
    L10_2 = MySQL
    L10_2 = L10_2.query
    L10_2 = L10_2.await
    L11_2 = L78_1
    L12_2 = " WHERE channel_id = ? AND id < ? ORDER BY id DESC LIMIT "
    L13_2 = L8_2 + 1
    L11_2 = L11_2 .. L12_2 .. L13_2
    L12_2 = {}
    L13_2 = L3_2.id
    L14_2 = L7_2
    L12_2[1] = L13_2
    L12_2[2] = L14_2
    L10_2 = L10_2(L11_2, L12_2)
    L9_2 = L10_2
  else
    L10_2 = MySQL
    L10_2 = L10_2.query
    L10_2 = L10_2.await
    L11_2 = L78_1
    L12_2 = " WHERE channel_id = ? ORDER BY id DESC LIMIT "
    L13_2 = L8_2 + 1
    L11_2 = L11_2 .. L12_2 .. L13_2
    L12_2 = {}
    L13_2 = L3_2.id
    L12_2[1] = L13_2
    L10_2 = L10_2(L11_2, L12_2)
    L9_2 = L10_2
  end
  if not L9_2 then
    L10_2 = {}
    L9_2 = L10_2
  end
  L10_2 = #L9_2
  L10_2 = L8_2 < L10_2
  if L10_2 then
    L11_2 = #L9_2
    L9_2[L11_2] = nil
  end
  L11_2 = {}
  L12_2 = #L9_2
  L13_2 = 1
  L14_2 = -1
  for L15_2 = L12_2, L13_2, L14_2 do
    L16_2 = #L11_2
    L16_2 = L16_2 + 1
    L17_2 = L9_2[L15_2]
    L11_2[L16_2] = L17_2
  end
  L12_2 = L77_1
  L13_2 = L11_2
  L14_2 = A2_2
  L12_2 = L12_2(L13_2, L14_2)
  if L6_2 and not L7_2 then
    L13_2 = #L12_2
    if L13_2 > 0 then
      L13_2 = #L12_2
      L13_2 = L12_2[L13_2]
      L13_2 = L13_2.id
      L14_2 = MySQL
      L14_2 = L14_2.update
      L14_2 = L14_2.await
      L15_2 = "UPDATE apex_phone_recado_channel_followers SET last_read = ? WHERE channel_id = ? AND number = ? AND (last_read IS NULL OR last_read < ?)"
      L16_2 = {}
      L17_2 = L13_2
      L18_2 = L3_2.id
      L19_2 = A2_2
      L20_2 = L13_2
      L16_2[1] = L17_2
      L16_2[2] = L18_2
      L16_2[3] = L19_2
      L16_2[4] = L20_2
      L14_2(L15_2, L16_2)
    end
  end
  L13_2 = {}
  L13_2.ok = true
  L14_2 = L3_2.id
  L13_2.id = L14_2
  L13_2.items = L12_2
  L13_2.more = L10_2
  L13_2.myRole = L5_2
  L14_2 = nil ~= L6_2
  L13_2.following = L14_2
  return L13_2
end
L79_1(L80_1, L81_1)
function L79_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2
  L2_2 = L1_1
  L3_2 = A1_2
  L2_2 = L2_2(L3_2)
  if not L2_2 then
    L3_2 = nil
    L4_2 = "invalid"
    return L3_2, L4_2
  end
  L3_2 = MySQL
  L3_2 = L3_2.single
  L3_2 = L3_2.await
  L4_2 = L78_1
  L5_2 = " WHERE id = ?"
  L4_2 = L4_2 .. L5_2
  L5_2 = {}
  L6_2 = L2_2
  L5_2[1] = L6_2
  L3_2 = L3_2(L4_2, L5_2)
  if not L3_2 then
    L4_2 = nil
    L5_2 = "notfound"
    return L4_2, L5_2
  end
  L4_2 = L65_1
  L5_2 = math
  L5_2 = L5_2.tointeger
  L6_2 = tonumber
  L7_2 = L3_2.channel_id
  L6_2, L7_2, L8_2, L9_2, L10_2, L11_2 = L6_2(L7_2)
  L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2 = L5_2(L6_2, L7_2, L8_2, L9_2, L10_2, L11_2)
  L4_2 = L4_2(L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2)
  if not L4_2 then
    L5_2 = nil
    L6_2 = "notfound"
    return L5_2, L6_2
  end
  L5_2 = L66_1
  L6_2 = L4_2.id
  L7_2 = A0_2
  L5_2 = L5_2(L6_2, L7_2)
  L6_2 = L67_1
  L7_2 = L4_2.id
  L8_2 = A0_2
  L6_2 = L6_2(L7_2, L8_2)
  L7_2 = L68_1
  L8_2 = L4_2
  L9_2 = L5_2
  L10_2 = L6_2
  L7_2 = L7_2(L8_2, L9_2, L10_2)
  if not L7_2 then
    L7_2 = nil
    L8_2 = "notfound"
    return L7_2, L8_2
  end
  L7_2 = L3_2
  L8_2 = nil
  L9_2 = L4_2
  L10_2 = L5_2
  L11_2 = L6_2
  return L7_2, L8_2, L9_2, L10_2, L11_2
end
L80_1 = L36_1
L81_1 = "recado.channel.react"
function L82_1(A0_2, A1_2, A2_2)
  local L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2
  L3_2 = L79_1
  L4_2 = A2_2
  L5_2 = A1_2.postId
  L3_2, L4_2, L5_2, L6_2, L7_2 = L3_2(L4_2, L5_2)
  if not L3_2 then
    L8_2 = L3_1
    L9_2 = L4_2
    return L8_2(L9_2)
  end
  if not L7_2 and not L6_2 then
    L8_2 = L3_1
    L9_2 = "notfollowing"
    return L8_2(L9_2)
  end
  L8_2 = math
  L8_2 = L8_2.tointeger
  L9_2 = tonumber
  L10_2 = L3_2.id
  L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2 = L9_2(L10_2)
  L8_2 = L8_2(L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2)
  L9_2 = A1_2.emoji
  if nil == L9_2 or false == L9_2 or "" == L9_2 then
    L10_2 = MySQL
    L10_2 = L10_2.update
    L10_2 = L10_2.await
    L11_2 = "DELETE FROM apex_phone_recado_channel_reactions WHERE post_id = ? AND number = ?"
    L12_2 = {}
    L13_2 = L8_2
    L14_2 = A2_2
    L12_2[1] = L13_2
    L12_2[2] = L14_2
    L10_2(L11_2, L12_2)
    L9_2 = nil
  else
    L10_2 = L64_1
    L11_2 = L9_2
    L10_2 = L10_2(L11_2)
    if not L10_2 then
      L10_2 = L3_1
      L11_2 = "badreaction"
      return L10_2(L11_2)
    end
    L10_2 = MySQL
    L10_2 = L10_2.update
    L10_2 = L10_2.await
    L11_2 = "INSERT INTO apex_phone_recado_channel_reactions (post_id, number, emoji, created) VALUES (?, ?, ?, ?) ON DUPLICATE KEY UPDATE emoji = VALUES(emoji), created = VALUES(created)"
    L12_2 = {}
    L13_2 = L8_2
    L14_2 = A2_2
    L15_2 = L9_2
    L16_2 = Now
    L16_2 = L16_2()
    L12_2[1] = L13_2
    L12_2[2] = L14_2
    L12_2[3] = L15_2
    L12_2[4] = L16_2
    L10_2(L11_2, L12_2)
  end
  L10_2 = L77_1
  L11_2 = {}
  L12_2 = L3_2
  L11_2[1] = L12_2
  L12_2 = A2_2
  L10_2 = L10_2(L11_2, L12_2)
  L10_2 = L10_2[1]
  L11_2 = {}
  L11_2.ok = true
  L11_2.postId = L8_2
  L12_2 = L10_2.reactions
  if not L12_2 then
    L12_2 = {}
  end
  L11_2.reactions = L12_2
  L12_2 = L10_2.myReaction
  L11_2.myReaction = L12_2
  return L11_2
end
L80_1(L81_1, L82_1)
L80_1 = L36_1
L81_1 = "recado.channel.vote"
function L82_1(A0_2, A1_2, A2_2)
  local L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2, L19_2, L20_2, L21_2, L22_2
  L3_2 = L79_1
  L4_2 = A2_2
  L5_2 = A1_2.postId
  L3_2, L4_2, L5_2, L6_2, L7_2 = L3_2(L4_2, L5_2)
  if not L3_2 then
    L8_2 = L3_1
    L9_2 = L4_2
    return L8_2(L9_2)
  end
  if not L7_2 and not L6_2 then
    L8_2 = L3_1
    L9_2 = "notfollowing"
    return L8_2(L9_2)
  end
  L8_2 = L3_2.type
  if "poll" ~= L8_2 then
    L8_2 = L3_1
    L9_2 = "badtype"
    return L8_2(L9_2)
  end
  L8_2 = L11_1
  L9_2 = L3_2.payload
  L8_2 = L8_2(L9_2)
  if not L8_2 then
    L8_2 = {}
  end
  L9_2 = type
  L10_2 = L8_2.options
  L9_2 = L9_2(L10_2)
  if "table" == L9_2 then
    L9_2 = L8_2.options
    L9_2 = #L9_2
    if L9_2 then
      goto lbl_43
    end
  end
  L9_2 = 0
  ::lbl_43::
  L10_2 = math
  L10_2 = L10_2.tointeger
  L11_2 = tonumber
  L12_2 = L3_2.id
  L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2, L19_2, L20_2, L21_2, L22_2 = L11_2(L12_2)
  L10_2 = L10_2(L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2, L19_2, L20_2, L21_2, L22_2)
  L11_2 = {}
  L12_2 = {}
  L13_2 = type
  L14_2 = A1_2.options
  L13_2 = L13_2(L14_2)
  if "table" == L13_2 then
    L13_2 = ipairs
    L14_2 = A1_2.options
    L13_2, L14_2, L15_2, L16_2 = L13_2(L14_2)
    for L17_2, L18_2 in L13_2, L14_2, L15_2, L16_2 do
      if L9_2 < L17_2 then
        L19_2 = L3_1
        L20_2 = "invalid"
        L19_2, L20_2, L21_2, L22_2 = L19_2(L20_2)
        return L19_2, L20_2, L21_2, L22_2
      end
      L19_2 = math
      L19_2 = L19_2.tointeger
      L20_2 = tonumber
      L21_2 = L18_2
      L20_2, L21_2, L22_2 = L20_2(L21_2)
      L19_2 = L19_2(L20_2, L21_2, L22_2)
      if not L19_2 or L19_2 < 0 or L9_2 <= L19_2 then
        L20_2 = L3_1
        L21_2 = "invalid"
        L20_2, L21_2, L22_2 = L20_2(L21_2)
        return L20_2, L21_2, L22_2
      end
      L20_2 = L12_2[L19_2]
      if not L20_2 then
        L12_2[L19_2] = true
        L20_2 = #L11_2
        L20_2 = L20_2 + 1
        L11_2[L20_2] = L19_2
      end
    end
  else
    L13_2 = A1_2.options
    if nil ~= L13_2 then
      L13_2 = L3_1
      L14_2 = "invalid"
      return L13_2(L14_2)
    end
  end
  L13_2 = #L11_2
  if L13_2 > 1 then
    L13_2 = L8_2.multi
    if true ~= L13_2 then
      L13_2 = L3_1
      L14_2 = "invalid"
      return L13_2(L14_2)
    end
  end
  L13_2 = #L11_2
  if 0 == L13_2 then
    L13_2 = MySQL
    L13_2 = L13_2.update
    L13_2 = L13_2.await
    L14_2 = "DELETE FROM apex_phone_recado_channel_votes WHERE post_id = ? AND number = ?"
    L15_2 = {}
    L16_2 = L10_2
    L17_2 = A2_2
    L15_2[1] = L16_2
    L15_2[2] = L17_2
    L13_2(L14_2, L15_2)
  else
    L13_2 = table
    L13_2 = L13_2.sort
    L14_2 = L11_2
    L13_2(L14_2)
    L13_2 = {}
    L14_2 = ipairs
    L15_2 = L11_2
    L14_2, L15_2, L16_2, L17_2 = L14_2(L15_2)
    for L18_2, L19_2 in L14_2, L15_2, L16_2, L17_2 do
      L20_2 = #L13_2
      L20_2 = L20_2 + 1
      L21_2 = tostring
      L22_2 = L19_2
      L21_2 = L21_2(L22_2)
      L13_2[L20_2] = L21_2
    end
    L14_2 = MySQL
    L14_2 = L14_2.update
    L14_2 = L14_2.await
    L15_2 = "INSERT INTO apex_phone_recado_channel_votes (post_id, number, options, created) VALUES (?, ?, ?, ?) ON DUPLICATE KEY UPDATE options = VALUES(options), created = VALUES(created)"
    L16_2 = {}
    L17_2 = L10_2
    L18_2 = A2_2
    L19_2 = table
    L19_2 = L19_2.concat
    L20_2 = L13_2
    L21_2 = ","
    L19_2 = L19_2(L20_2, L21_2)
    L20_2 = Now
    L20_2, L21_2, L22_2 = L20_2()
    L16_2[1] = L17_2
    L16_2[2] = L18_2
    L16_2[3] = L19_2
    L16_2[4] = L20_2
    L16_2[5] = L21_2
    L16_2[6] = L22_2
    L14_2(L15_2, L16_2)
  end
  L13_2 = L75_1
  L14_2 = {}
  L15_2 = L10_2
  L14_2[1] = L15_2
  L15_2 = A2_2
  L13_2 = L13_2(L14_2, L15_2)
  L14_2 = {}
  L14_2.ok = true
  L14_2.postId = L10_2
  L15_2 = L76_1
  L16_2 = L8_2
  L17_2 = L13_2[L10_2]
  L15_2 = L15_2(L16_2, L17_2)
  L14_2.poll = L15_2
  return L14_2
end
L80_1(L81_1, L82_1)
L80_1 = L36_1
L81_1 = "recado.channel.unpost"
function L82_1(A0_2, A1_2, A2_2)
  local L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2
  L3_2 = L79_1
  L4_2 = A2_2
  L5_2 = A1_2.postId
  L3_2, L4_2, L5_2, L6_2 = L3_2(L4_2, L5_2)
  if not L3_2 then
    L7_2 = L3_1
    L8_2 = L4_2
    return L7_2(L8_2)
  end
  if not L6_2 then
    L7_2 = L3_1
    L8_2 = "notadmin"
    return L7_2(L8_2)
  end
  L7_2 = math
  L7_2 = L7_2.tointeger
  L8_2 = tonumber
  L9_2 = L3_2.id
  L8_2, L9_2, L10_2, L11_2 = L8_2(L9_2)
  L7_2 = L7_2(L8_2, L9_2, L10_2, L11_2)
  L8_2 = MySQL
  L8_2 = L8_2.update
  L8_2 = L8_2.await
  L9_2 = "DELETE FROM apex_phone_recado_channel_reactions WHERE post_id = ?"
  L10_2 = {}
  L11_2 = L7_2
  L10_2[1] = L11_2
  L8_2(L9_2, L10_2)
  L8_2 = MySQL
  L8_2 = L8_2.update
  L8_2 = L8_2.await
  L9_2 = "DELETE FROM apex_phone_recado_channel_votes WHERE post_id = ?"
  L10_2 = {}
  L11_2 = L7_2
  L10_2[1] = L11_2
  L8_2(L9_2, L10_2)
  L8_2 = MySQL
  L8_2 = L8_2.update
  L8_2 = L8_2.await
  L9_2 = "DELETE FROM apex_phone_recado_channel_posts WHERE id = ?"
  L10_2 = {}
  L11_2 = L7_2
  L10_2[1] = L11_2
  L8_2(L9_2, L10_2)
  L8_2 = L26_1
  L9_2 = L3_2.media_id
  L8_2(L9_2)
  L8_2 = L72_1
  L9_2 = L5_2.id
  L10_2 = {}
  L11_2 = L5_2.id
  L10_2.id = L11_2
  L10_2.action = "unpost"
  L10_2.postId = L7_2
  L11_2 = A2_2
  L8_2(L9_2, L10_2, L11_2)
  L8_2 = {}
  L8_2.ok = true
  L8_2.postId = L7_2
  return L8_2
end
L80_1(L81_1, L82_1)
L80_1 = L36_1
L81_1 = "recado.channel.admins"
function L82_1(A0_2, A1_2, A2_2, A3_2)
  local L4_2, L5_2, L6_2, L7_2
  L4_2 = L1_1
  L5_2 = A1_2.id
  L4_2 = L4_2(L5_2)
  if not L4_2 then
    L5_2 = L3_1
    L6_2 = "invalid"
    return L5_2(L6_2)
  end
  L5_2 = L21_1
  L6_2 = "ch:"
  L7_2 = L4_2
  L6_2 = L6_2 .. L7_2
  function L7_2()
    local L0_3, L1_3, L2_3, L3_3, L4_3, L5_3, L6_3, L7_3, L8_3, L9_3
    L0_3 = L65_1
    L1_3 = L4_2
    L0_3 = L0_3(L1_3)
    if not L0_3 then
      L1_3 = L3_1
      L2_3 = "notfound"
      return L1_3(L2_3)
    end
    L1_3 = L66_1
    L2_3 = L4_2
    L3_3 = A2_2
    L1_3 = L1_3(L2_3, L3_3)
    if not L1_3 then
      L2_3 = L3_1
      L3_3 = L0_3.listed
      if L3_3 then
        L3_3 = "notadmin"
        if L3_3 then
          goto lbl_24
        end
      end
      L3_3 = "notfound"
      ::lbl_24::
      return L2_3(L3_3)
    end
    L2_3 = A1_2.add
    if nil == L2_3 then
      L2_3 = A1_2.remove
      if nil == L2_3 then
        goto lbl_173
      end
    end
    if "owner" ~= L1_3 then
      L2_3 = L3_1
      L3_3 = "notowner"
      return L2_3(L3_3)
    end
    L2_3 = A1_2.add
    if nil ~= L2_3 then
      L2_3 = L9_1
      L3_3 = A1_2.add
      L2_3 = L2_3(L3_3)
      if L2_3 then
        L3_3 = A2_2
        if L2_3 ~= L3_3 then
          goto lbl_53
        end
      end
      L3_3 = L3_1
      L4_3 = "invalid"
      do return L3_3(L4_3) end
      ::lbl_53::
      L3_3 = L66_1
      L4_3 = L4_2
      L5_3 = L2_3
      L3_3 = L3_3(L4_3, L5_3)
      if not L3_3 then
        L3_3 = tonumber
        L4_3 = MySQL
        L4_3 = L4_3.scalar
        L4_3 = L4_3.await
        L5_3 = "SELECT COUNT(*) FROM apex_phone_recado_channel_admins WHERE channel_id = ?"
        L6_3 = {}
        L7_3 = L4_2
        L6_3[1] = L7_3
        L4_3, L5_3, L6_3, L7_3, L8_3, L9_3 = L4_3(L5_3, L6_3)
        L3_3 = L3_3(L4_3, L5_3, L6_3, L7_3, L8_3, L9_3)
        if not L3_3 then
          L3_3 = 0
        end
        L4_3 = L61_1
        L4_3 = L4_3()
        L4_3 = L4_3.maxAdmins
        if L3_3 >= L4_3 then
          L4_3 = L3_1
          L5_3 = "full"
          L6_3 = {}
          L7_3 = L61_1
          L7_3 = L7_3()
          L7_3 = L7_3.maxAdmins
          L6_3.max = L7_3
          return L4_3(L5_3, L6_3)
        end
        L4_3 = GetCitizenIdByNumber
        L5_3 = L2_3
        L4_3 = L4_3(L5_3)
        if not L4_3 then
          L4_3 = L3_1
          L5_3 = "badnumber"
          return L4_3(L5_3)
        end
        L4_3 = MySQL
        L4_3 = L4_3.update
        L4_3 = L4_3.await
        L5_3 = "INSERT INTO apex_phone_recado_channel_admins (channel_id, number, role, added) VALUES (?, ?, 'admin', ?)"
        L6_3 = {}
        L7_3 = L4_2
        L8_3 = L2_3
        L9_3 = Now
        L9_3 = L9_3()
        L6_3[1] = L7_3
        L6_3[2] = L8_3
        L6_3[3] = L9_3
        L4_3(L5_3, L6_3)
        L4_3 = L19_1
        L4_3 = L4_3()
        L4_3 = L4_3[L2_3]
        if L4_3 then
          L5_3 = Push
          L6_3 = L4_3
          L7_3 = "recadoChannel"
          L8_3 = {}
          L9_3 = L4_2
          L8_3.id = L9_3
          L8_3.action = "admin"
          L8_3.on = true
          L5_3(L6_3, L7_3, L8_3)
        end
      end
    end
    L2_3 = A1_2.remove
    if nil ~= L2_3 then
      L2_3 = L9_1
      L3_3 = A1_2.remove
      L2_3 = L2_3(L3_3)
      if not L2_3 then
        L3_3 = L3_1
        L4_3 = "invalid"
        return L3_3(L4_3)
      end
      L3_3 = L66_1
      L4_3 = L4_2
      L5_3 = L2_3
      L3_3 = L3_3(L4_3, L5_3)
      if "owner" == L3_3 then
        L3_3 = L3_1
        L4_3 = "notowner"
        return L3_3(L4_3)
      end
      L3_3 = MySQL
      L3_3 = L3_3.update
      L3_3 = L3_3.await
      L4_3 = "DELETE FROM apex_phone_recado_channel_admins WHERE channel_id = ? AND number = ? AND role <> 'owner'"
      L5_3 = {}
      L6_3 = L4_2
      L7_3 = L2_3
      L5_3[1] = L6_3
      L5_3[2] = L7_3
      L3_3(L4_3, L5_3)
      L3_3 = L19_1
      L3_3 = L3_3()
      L3_3 = L3_3[L2_3]
      if L3_3 then
        L4_3 = L24_1
        L4_3[L3_3] = nil
        L4_3 = Push
        L5_3 = L3_3
        L6_3 = "recadoChannel"
        L7_3 = {}
        L8_3 = L4_2
        L7_3.id = L8_3
        L7_3.action = "admin"
        L7_3.on = false
        L4_3(L5_3, L6_3, L7_3)
      end
    end
    ::lbl_173::
    L2_3 = {}
    L2_3.ok = true
    L3_3 = L4_2
    L2_3.id = L3_3
    L3_3 = L73_1
    L4_3 = L4_2
    L5_3 = A3_2
    L3_3 = L3_3(L4_3, L5_3)
    L2_3.items = L3_3
    L3_3 = L61_1
    L3_3 = L3_3()
    L3_3 = L3_3.maxAdmins
    L2_3.max = L3_3
    L2_3.myRole = L1_3
    return L2_3
  end
  return L5_2(L6_2, L7_2)
end
L80_1(L81_1, L82_1)
L80_1 = L36_1
L81_1 = "recado.channel.followers"
function L82_1(A0_2, A1_2, A2_2, A3_2)
  local L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2, L19_2, L20_2
  L4_2 = L1_1
  L5_2 = A1_2.id
  L4_2 = L4_2(L5_2)
  if not L4_2 then
    L5_2 = L3_1
    L6_2 = "invalid"
    return L5_2(L6_2)
  end
  L5_2 = L65_1
  L6_2 = L4_2
  L5_2 = L5_2(L6_2)
  if not L5_2 then
    L6_2 = L3_1
    L7_2 = "notfound"
    return L6_2(L7_2)
  end
  L6_2 = L66_1
  L7_2 = L4_2
  L8_2 = A2_2
  L6_2 = L6_2(L7_2, L8_2)
  if not L6_2 then
    L6_2 = L3_1
    L7_2 = L5_2.listed
    if L7_2 then
      L7_2 = "notadmin"
      if L7_2 then
        goto lbl_33
      end
    end
    L7_2 = "notfound"
    ::lbl_33::
    return L6_2(L7_2)
  end
  L6_2 = MySQL
  L6_2 = L6_2.query
  L6_2 = L6_2.await
  L7_2 = "SELECT number, created FROM apex_phone_recado_channel_followers WHERE channel_id = ? ORDER BY created DESC LIMIT 500"
  L8_2 = {}
  L9_2 = L4_2
  L8_2[1] = L9_2
  L6_2 = L6_2(L7_2, L8_2)
  if not L6_2 then
    L6_2 = {}
  end
  L7_2 = {}
  L8_2 = ipairs
  L9_2 = L6_2
  L8_2, L9_2, L10_2, L11_2 = L8_2(L9_2)
  for L12_2, L13_2 in L8_2, L9_2, L10_2, L11_2 do
    L14_2 = #L7_2
    L14_2 = L14_2 + 1
    L15_2 = tostring
    L16_2 = L13_2.number
    L15_2 = L15_2(L16_2)
    L7_2[L14_2] = L15_2
  end
  L8_2 = L29_1
  L9_2 = A3_2
  L10_2 = L7_2
  L8_2 = L8_2(L9_2, L10_2)
  L9_2 = {}
  L10_2 = ipairs
  L11_2 = L6_2
  L10_2, L11_2, L12_2, L13_2 = L10_2(L11_2)
  for L14_2, L15_2 in L10_2, L11_2, L12_2, L13_2 do
    L16_2 = tostring
    L17_2 = L15_2.number
    L16_2 = L16_2(L17_2)
    L17_2 = #L9_2
    L17_2 = L17_2 + 1
    L18_2 = {}
    L18_2.number = L16_2
    L19_2 = L8_2[L16_2]
    if not L19_2 then
      L19_2 = L30_1
      L20_2 = L16_2
      L19_2 = L19_2(L20_2)
    end
    L18_2.name = L19_2
    L19_2 = tonumber
    L20_2 = L15_2.created
    L19_2 = L19_2(L20_2)
    L18_2.since = L19_2
    L9_2[L17_2] = L18_2
  end
  L10_2 = {}
  L10_2.ok = true
  L10_2.id = L4_2
  L10_2.items = L9_2
  L11_2 = L5_2.followers
  L10_2.count = L11_2
  return L10_2
end
L80_1(L81_1, L82_1)
L80_1 = L36_1
L81_1 = "recado.channel.code"
function L82_1(A0_2, A1_2, A2_2)
  local L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2
  L3_2 = L1_1
  L4_2 = A1_2.id
  L3_2 = L3_2(L4_2)
  if not L3_2 then
    L4_2 = L3_1
    L5_2 = "invalid"
    return L4_2(L5_2)
  end
  L4_2 = L65_1
  L5_2 = L3_2
  L4_2 = L4_2(L5_2)
  if not L4_2 then
    L5_2 = L3_1
    L6_2 = "notfound"
    return L5_2(L6_2)
  end
  L5_2 = L66_1
  L6_2 = L3_2
  L7_2 = A2_2
  L5_2 = L5_2(L6_2, L7_2)
  if not L5_2 then
    L5_2 = L3_1
    L6_2 = L4_2.listed
    if L6_2 then
      L6_2 = "notadmin"
      if L6_2 then
        goto lbl_33
      end
    end
    L6_2 = "notfound"
    ::lbl_33::
    return L5_2(L6_2)
  end
  L5_2 = L4_2.code
  L6_2 = L15_1
  L7_2 = A1_2.reset
  L6_2 = L6_2(L7_2)
  if L6_2 or not L5_2 then
    L6_2 = 1
    L7_2 = 6
    L8_2 = 1
    for L9_2 = L6_2, L7_2, L8_2 do
      L10_2 = L58_1
      L11_2 = 8
      L10_2 = L10_2(L11_2)
      L11_2 = pcall
      L12_2 = MySQL
      L12_2 = L12_2.update
      L12_2 = L12_2.await
      L13_2 = "UPDATE apex_phone_recado_channels SET code = ?, updated = ? WHERE id = ?"
      L14_2 = {}
      L15_2 = L10_2
      L16_2 = Now
      L16_2 = L16_2()
      L17_2 = L3_2
      L14_2[1] = L15_2
      L14_2[2] = L16_2
      L14_2[3] = L17_2
      L11_2 = L11_2(L12_2, L13_2, L14_2)
      if L11_2 then
        L5_2 = L10_2
        break
      end
    end
  end
  L6_2 = {}
  L6_2.ok = true
  L6_2.id = L3_2
  L6_2.code = L5_2
  return L6_2
end
L80_1(L81_1, L82_1)
L80_1 = L36_1
L81_1 = "recado.channel.join"
function L82_1(A0_2, A1_2, A2_2)
  local L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2
  L3_2 = type
  L4_2 = A1_2.code
  L3_2 = L3_2(L4_2)
  if "string" == L3_2 then
    L3_2 = A1_2.code
    L3_2 = #L3_2
    if L3_2 <= 120 then
      L3_2 = A1_2.code
      if L3_2 then
        goto lbl_14
      end
    end
  end
  L3_2 = ""
  ::lbl_14::
  L5_2 = L3_2
  L4_2 = L3_2.match
  L6_2 = "([%w]+)[^%w]*$"
  L4_2 = L4_2(L5_2, L6_2)
  if not L4_2 then
    L4_2 = ""
  end
  L5_2 = L4_2
  L4_2 = L4_2.upper
  L4_2 = L4_2(L5_2)
  L5_2 = #L4_2
  if not (L5_2 < 6) then
    L5_2 = #L4_2
    if not (L5_2 > 12) then
      goto lbl_32
    end
  end
  L5_2 = L3_1
  L6_2 = "invalid"
  do return L5_2(L6_2) end
  ::lbl_32::
  L5_2 = L23_1
  L6_2 = A0_2
  L7_2 = "channel.join"
  L8_2 = 1500
  L5_2 = L5_2(L6_2, L7_2, L8_2)
  if L5_2 then
    L5_2 = L3_1
    L6_2 = "cooldown"
    return L5_2(L6_2)
  end
  L5_2 = MySQL
  L5_2 = L5_2.single
  L5_2 = L5_2.await
  L6_2 = "SELECT id FROM apex_phone_recado_channels WHERE code = ?"
  L7_2 = {}
  L8_2 = L4_2
  L7_2[1] = L8_2
  L5_2 = L5_2(L6_2, L7_2)
  if not L5_2 then
    L6_2 = L3_1
    L7_2 = "notfound"
    return L6_2(L7_2)
  end
  L6_2 = L65_1
  L7_2 = math
  L7_2 = L7_2.tointeger
  L8_2 = tonumber
  L9_2 = L5_2.id
  L8_2, L9_2, L10_2, L11_2, L12_2 = L8_2(L9_2)
  L7_2, L8_2, L9_2, L10_2, L11_2, L12_2 = L7_2(L8_2, L9_2, L10_2, L11_2, L12_2)
  L6_2 = L6_2(L7_2, L8_2, L9_2, L10_2, L11_2, L12_2)
  if not L6_2 then
    L7_2 = L3_1
    L8_2 = "notfound"
    return L7_2(L8_2)
  end
  L7_2 = L66_1
  L8_2 = L6_2.id
  L9_2 = A2_2
  L7_2 = L7_2(L8_2, L9_2)
  if not L7_2 then
    L7_2 = L74_1
    L8_2 = L6_2
    L9_2 = A2_2
    L7_2(L8_2, L9_2)
  end
  L7_2 = L69_1
  L8_2 = L65_1
  L9_2 = L6_2.id
  L8_2 = L8_2(L9_2)
  L9_2 = L66_1
  L10_2 = L6_2.id
  L11_2 = A2_2
  L9_2 = L9_2(L10_2, L11_2)
  L10_2 = L67_1
  L11_2 = L6_2.id
  L12_2 = A2_2
  L10_2, L11_2, L12_2 = L10_2(L11_2, L12_2)
  L7_2 = L7_2(L8_2, L9_2, L10_2, L11_2, L12_2)
  L7_2.ok = true
  return L7_2
end
L80_1(L81_1, L82_1)
function L80_1()
  local L0_2, L1_2, L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2
  L0_2 = type
  L1_2 = L0_1
  L1_2 = L1_2()
  L1_2 = L1_2.communities
  L0_2 = L0_2(L1_2)
  if "table" == L0_2 then
    L0_2 = L0_1
    L0_2 = L0_2()
    L0_2 = L0_2.communities
    if L0_2 then
      goto lbl_15
    end
  end
  L0_2 = {}
  ::lbl_15::
  L1_2 = {}
  L2_2 = math
  L2_2 = L2_2.max
  L3_2 = 1
  L4_2 = math
  L4_2 = L4_2.min
  L5_2 = 100
  L6_2 = math
  L6_2 = L6_2.tointeger
  L7_2 = tonumber
  L8_2 = L0_2.maxGroups
  L7_2, L8_2 = L7_2(L8_2)
  L6_2 = L6_2(L7_2, L8_2)
  if not L6_2 then
    L6_2 = 20
  end
  L4_2 = L4_2(L5_2, L6_2)
  L2_2 = L2_2(L3_2, L4_2)
  L1_2.maxGroups = L2_2
  L2_2 = math
  L2_2 = L2_2.max
  L3_2 = 1
  L4_2 = math
  L4_2 = L4_2.min
  L5_2 = 20
  L6_2 = math
  L6_2 = L6_2.tointeger
  L7_2 = tonumber
  L8_2 = L0_2.maxPerOwner
  L7_2, L8_2 = L7_2(L8_2)
  L6_2 = L6_2(L7_2, L8_2)
  if not L6_2 then
    L6_2 = 3
  end
  L4_2 = L4_2(L5_2, L6_2)
  L2_2 = L2_2(L3_2, L4_2)
  L1_2.maxPerOwner = L2_2
  return L1_2
end
function L81_1(A0_2)
  local L1_2, L2_2, L3_2, L4_2
  L1_2 = MySQL
  L1_2 = L1_2.single
  L1_2 = L1_2.await
  L2_2 = "SELECT id, name, description, avatar, owner, owner_cid, announce_id, created, updated FROM apex_phone_recado_communities WHERE id = ?"
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
  L1_2.id = L2_2
  L2_2 = L1_1
  L3_2 = L1_2.avatar
  L2_2 = L2_2(L3_2)
  L1_2.avatar = L2_2
  L2_2 = L1_1
  L3_2 = L1_2.announce_id
  L2_2 = L2_2(L3_2)
  L1_2.announce_id = L2_2
  return L1_2
end
function L82_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2, L6_2, L7_2
  L2_2 = A0_2.announce_id
  if L2_2 then
    L2_2 = MySQL
    L2_2 = L2_2.scalar
    L2_2 = L2_2.await
    L3_2 = "SELECT role FROM apex_phone_conversation_members WHERE conversation_id = ? AND member = ? AND left_at IS NULL"
    L4_2 = {}
    L5_2 = A0_2.announce_id
    L6_2 = A1_2
    L4_2[1] = L5_2
    L4_2[2] = L6_2
    L2_2 = L2_2(L3_2, L4_2)
    if L2_2 then
      if "admin" == L2_2 then
        L3_2 = "admin"
        if L3_2 then
          goto lbl_22
        end
      end
      L3_2 = "member"
      ::lbl_22::
      return L3_2
    end
  end
  L2_2 = pcall
  L3_2 = MySQL
  L3_2 = L3_2.scalar
  L3_2 = L3_2.await
  L4_2 = [[
SELECT 1 FROM apex_phone_conversation_members m JOIN apex_phone_conversations g ON g.id = m.conversation_id
        WHERE g.community_id = ? AND m.member = ? AND m.left_at IS NULL LIMIT 1]]
  L5_2 = {}
  L6_2 = A0_2.id
  L7_2 = A1_2
  L5_2[1] = L6_2
  L5_2[2] = L7_2
  L2_2, L3_2 = L2_2(L3_2, L4_2, L5_2)
  if L2_2 and L3_2 then
    L4_2 = "member"
    return L4_2
  end
  L4_2 = nil
  return L4_2
end
function L83_1(A0_2, A1_2, A2_2, A3_2)
  local L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2
  L4_2 = Now
  L4_2 = L4_2()
  L5_2 = pcall
  L6_2 = MySQL
  L6_2 = L6_2.insert
  L6_2 = L6_2.await
  L7_2 = "INSERT INTO apex_phone_messages (app, sender, receiver, `type`, content, payload, `read`, created, conversation_id) VALUES (?, ?, ?, ?, ?, ?, 0, ?, ?)"
  L8_2 = {}
  L9_2 = "recado"
  L10_2 = A1_2
  L11_2 = "g:"
  L12_2 = A0_2
  L11_2 = L11_2 .. L12_2
  L12_2 = "system"
  L13_2 = L4_1
  L14_2 = A2_2
  L15_2 = 255
  L13_2 = L13_2(L14_2, L15_2)
  L14_2 = L12_1
  L15_2 = A3_2
  L14_2 = L14_2(L15_2)
  L15_2 = L4_2
  L16_2 = A0_2
  L8_2[1] = L9_2
  L8_2[2] = L10_2
  L8_2[3] = L11_2
  L8_2[4] = L12_2
  L8_2[5] = L13_2
  L8_2[6] = L14_2
  L8_2[7] = L15_2
  L8_2[8] = L16_2
  L5_2, L6_2 = L5_2(L6_2, L7_2, L8_2)
  if L5_2 then
    L7_2 = L1_1
    L8_2 = L6_2
    L7_2 = L7_2(L8_2)
    if L7_2 then
      goto lbl_35
      L6_2 = L7_2 or L6_2
    end
  end
  L6_2 = nil
  ::lbl_35::
  if not L6_2 then
    L7_2 = nil
    return L7_2
  end
  L7_2 = MySQL
  L7_2 = L7_2.update
  L7_2 = L7_2.await
  L8_2 = "UPDATE apex_phone_conversations SET last_id = ? WHERE id = ? AND (last_id IS NULL OR last_id < ?)"
  L9_2 = {}
  L10_2 = L6_2
  L11_2 = A0_2
  L12_2 = L6_2
  L9_2[1] = L10_2
  L9_2[2] = L11_2
  L9_2[3] = L12_2
  L7_2(L8_2, L9_2)
  L7_2 = type
  L8_2 = GroupBroadcast
  L7_2 = L7_2(L8_2)
  if "function" == L7_2 then
    L7_2 = MySQL
    L7_2 = L7_2.single
    L7_2 = L7_2.await
    L8_2 = "SELECT title, avatar FROM apex_phone_conversations WHERE id = ?"
    L9_2 = {}
    L10_2 = A0_2
    L9_2[1] = L10_2
    L7_2 = L7_2(L8_2, L9_2)
    if not L7_2 then
      L7_2 = {}
    end
    L8_2 = pcall
    L9_2 = GroupBroadcast
    L10_2 = A0_2
    L11_2 = "message"
    L12_2 = {}
    L12_2.id = L6_2
    L12_2.app = "recado"
    L12_2.sender = A1_2
    L13_2 = "g:"
    L14_2 = A0_2
    L13_2 = L13_2 .. L14_2
    L12_2.receiver = L13_2
    L12_2.type = "system"
    L13_2 = L4_1
    L14_2 = A2_2
    L15_2 = 255
    L13_2 = L13_2(L14_2, L15_2)
    L12_2.content = L13_2
    L12_2.payload = A3_2
    L12_2.read = false
    L12_2.created = L4_2
    L12_2.conversation = A0_2
    L13_2 = {}
    L13_2.id = A0_2
    L14_2 = L7_2.title
    L13_2.title = L14_2
    L14_2 = L1_1
    L15_2 = L7_2.avatar
    L14_2 = L14_2(L15_2)
    L13_2.avatar = L14_2
    L12_2.group = L13_2
    L8_2(L9_2, L10_2, L11_2, L12_2)
  end
  return L6_2
end
L84_1 = {}
function L85_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2, L19_2, L20_2, L21_2, L22_2, L23_2, L24_2
  if A0_2 then
    L2_2 = A0_2.announce_id
    if L2_2 then
      goto lbl_7
    end
  end
  do return end
  ::lbl_7::
  L2_2 = GetGameTimer
  L2_2 = L2_2()
  if not A1_2 then
    L4_2 = A0_2.id
    L3_2 = L84_1
    L3_2 = L3_2[L4_2]
    if L3_2 then
      L4_2 = A0_2.id
      L3_2 = L84_1
      L3_2 = L3_2[L4_2]
      L3_2 = L2_2 - L3_2
      L4_2 = 30000
      if L3_2 < L4_2 then
        return
      end
    end
  end
  L4_2 = A0_2.id
  L3_2 = L84_1
  L3_2[L4_2] = L2_2
  L3_2 = {}
  L4_2 = pcall
  L5_2 = MySQL
  L5_2 = L5_2.query
  L5_2 = L5_2.await
  L6_2 = [[
SELECT DISTINCT m.member FROM apex_phone_conversation_members m JOIN apex_phone_conversations g ON g.id = m.conversation_id
        WHERE g.community_id = ? AND g.id <> ? AND m.left_at IS NULL LIMIT 2000]]
  L7_2 = {}
  L8_2 = A0_2.id
  L9_2 = A0_2.announce_id
  L7_2[1] = L8_2
  L7_2[2] = L9_2
  L4_2, L5_2 = L4_2(L5_2, L6_2, L7_2)
  if L4_2 then
    L6_2 = type
    L7_2 = L5_2
    L6_2 = L6_2(L7_2)
    if "table" == L6_2 then
      goto lbl_49
    end
  end
  do return end
  ::lbl_49::
  L6_2 = ipairs
  L7_2 = L5_2
  L6_2, L7_2, L8_2, L9_2 = L6_2(L7_2)
  for L10_2, L11_2 in L6_2, L7_2, L8_2, L9_2 do
    L12_2 = tostring
    L13_2 = L11_2.member
    L12_2 = L12_2(L13_2)
    L3_2[L12_2] = true
  end
  L6_2 = {}
  L7_2 = ipairs
  L8_2 = MySQL
  L8_2 = L8_2.query
  L8_2 = L8_2.await
  L9_2 = "SELECT member, role FROM apex_phone_conversation_members WHERE conversation_id = ? AND left_at IS NULL"
  L10_2 = {}
  L11_2 = A0_2.announce_id
  L10_2[1] = L11_2
  L8_2 = L8_2(L9_2, L10_2)
  if not L8_2 then
    L8_2 = {}
  end
  L7_2, L8_2, L9_2, L10_2 = L7_2(L8_2)
  for L11_2, L12_2 in L7_2, L8_2, L9_2, L10_2 do
    L13_2 = tostring
    L14_2 = L12_2.member
    L13_2 = L13_2(L14_2)
    L14_2 = L12_2.role
    if "admin" == L14_2 then
      L14_2 = "admin"
      if L14_2 then
        goto lbl_88
      end
    end
    L14_2 = "member"
    ::lbl_88::
    L6_2[L13_2] = L14_2
  end
  L7_2 = Now
  L7_2 = L7_2()
  L8_2 = math
  L8_2 = L8_2.tointeger
  L9_2 = tonumber
  L10_2 = MySQL
  L10_2 = L10_2.scalar
  L10_2 = L10_2.await
  L11_2 = "SELECT last_id FROM apex_phone_conversations WHERE id = ?"
  L12_2 = {}
  L13_2 = A0_2.announce_id
  L12_2[1] = L13_2
  L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2, L19_2, L20_2, L21_2, L22_2, L23_2, L24_2 = L10_2(L11_2, L12_2)
  L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2, L19_2, L20_2, L21_2, L22_2, L23_2, L24_2 = L9_2(L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2, L19_2, L20_2, L21_2, L22_2, L23_2, L24_2)
  L8_2 = L8_2(L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2, L19_2, L20_2, L21_2, L22_2, L23_2, L24_2)
  if not L8_2 then
    L8_2 = 0
  end
  L9_2 = {}
  L10_2 = pairs
  L11_2 = L3_2
  L10_2, L11_2, L12_2, L13_2 = L10_2(L11_2)
  for L14_2 in L10_2, L11_2, L12_2, L13_2 do
    L15_2 = L6_2[L14_2]
    if not L15_2 then
      L15_2 = #L9_2
      L15_2 = L15_2 + 1
      L9_2[L15_2] = L14_2
    end
  end
  L10_2 = 1
  L11_2 = #L9_2
  L12_2 = 100
  for L13_2 = L10_2, L11_2, L12_2 do
    L14_2 = {}
    L15_2 = {}
    L16_2 = L13_2
    L17_2 = math
    L17_2 = L17_2.min
    L18_2 = #L9_2
    L19_2 = L13_2 + 99
    L17_2 = L17_2(L18_2, L19_2)
    L18_2 = 1
    for L19_2 = L16_2, L17_2, L18_2 do
      L20_2 = #L14_2
      L20_2 = L20_2 + 1
      L14_2[L20_2] = "(?, ?, 'member', ?, ?, NULL)"
      L20_2 = #L15_2
      L21_2 = L20_2 + 1
      L22_2 = A0_2.announce_id
      L15_2[L21_2] = L22_2
      L21_2 = L20_2 + 2
      L22_2 = L9_2[L19_2]
      L15_2[L21_2] = L22_2
      L21_2 = L20_2 + 3
      L15_2[L21_2] = L7_2
      L21_2 = L20_2 + 4
      L15_2[L21_2] = L8_2
    end
    L16_2 = MySQL
    L16_2 = L16_2.update
    L16_2 = L16_2.await
    L17_2 = "INSERT INTO apex_phone_conversation_members (conversation_id, member, role, joined, last_read_id, left_at) VALUES "
    L18_2 = table
    L18_2 = L18_2.concat
    L19_2 = L14_2
    L20_2 = ", "
    L18_2 = L18_2(L19_2, L20_2)
    L19_2 = " ON DUPLICATE KEY UPDATE role = 'member', joined = VALUES(joined), last_read_id = VALUES(last_read_id), left_at = NULL"
    L17_2 = L17_2 .. L18_2 .. L19_2
    L18_2 = L15_2
    L16_2(L17_2, L18_2)
  end
  L10_2 = {}
  L11_2 = pairs
  L12_2 = L6_2
  L11_2, L12_2, L13_2, L14_2 = L11_2(L12_2)
  for L15_2, L16_2 in L11_2, L12_2, L13_2, L14_2 do
    if "admin" ~= L16_2 then
      L17_2 = L3_2[L15_2]
      if not L17_2 then
        L17_2 = MySQL
        L17_2 = L17_2.update
        L17_2 = L17_2.await
        L18_2 = "UPDATE apex_phone_conversation_members SET left_at = ? WHERE conversation_id = ? AND member = ? AND left_at IS NULL"
        L19_2 = {}
        L20_2 = L7_2
        L21_2 = A0_2.announce_id
        L22_2 = L15_2
        L19_2[1] = L20_2
        L19_2[2] = L21_2
        L19_2[3] = L22_2
        L17_2(L18_2, L19_2)
        L17_2 = #L10_2
        L17_2 = L17_2 + 1
        L10_2[L17_2] = L15_2
      end
    end
  end
  L11_2 = #L9_2
  if not (L11_2 > 0) then
    L11_2 = #L10_2
    if not (L11_2 > 0) then
      goto lbl_268
    end
  end
  L11_2 = L19_1
  L11_2 = L11_2()
  L12_2 = ipairs
  L13_2 = L9_2
  L12_2, L13_2, L14_2, L15_2 = L12_2(L13_2)
  for L16_2, L17_2 in L12_2, L13_2, L14_2, L15_2 do
    L18_2 = L11_2[L17_2]
    if L18_2 then
      L19_2 = Push
      L20_2 = L18_2
      L21_2 = "groupUpdate"
      L22_2 = {}
      L23_2 = A0_2.announce_id
      L22_2.id = L23_2
      L22_2.action = "add"
      L23_2 = {}
      L24_2 = L17_2
      L23_2[1] = L24_2
      L22_2.targets = L23_2
      L23_2 = A0_2.id
      L22_2.community = L23_2
      L19_2(L20_2, L21_2, L22_2)
    end
  end
  L12_2 = ipairs
  L13_2 = L10_2
  L12_2, L13_2, L14_2, L15_2 = L12_2(L13_2)
  for L16_2, L17_2 in L12_2, L13_2, L14_2, L15_2 do
    L18_2 = L11_2[L17_2]
    if L18_2 then
      L19_2 = Push
      L20_2 = L18_2
      L21_2 = "groupUpdate"
      L22_2 = {}
      L23_2 = A0_2.announce_id
      L22_2.id = L23_2
      L22_2.action = "remove"
      L23_2 = {}
      L24_2 = L17_2
      L23_2[1] = L24_2
      L22_2.targets = L23_2
      L22_2.removed = true
      L23_2 = A0_2.id
      L22_2.community = L23_2
      L19_2(L20_2, L21_2, L22_2)
    end
  end
  ::lbl_268::
end
function L86_1(A0_2, A1_2, A2_2, A3_2)
  local L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2
  L4_2 = {}
  L4_2.ok = true
  L5_2 = A0_2.id
  L4_2.id = L5_2
  L5_2 = A0_2.name
  L4_2.name = L5_2
  L5_2 = A0_2.description
  L4_2.description = L5_2
  L5_2 = A0_2.avatar
  L4_2.avatar = L5_2
  L5_2 = A0_2.owner
  L5_2 = L5_2 == A1_2 or L5_2
  L4_2.owner = L5_2
  L4_2.myRole = A3_2
  L5_2 = tonumber
  L6_2 = A0_2.created
  L5_2 = L5_2(L6_2)
  L4_2.created = L5_2
  L5_2 = L80_1
  L5_2 = L5_2()
  L5_2 = L5_2.maxGroups
  L4_2.maxGroups = L5_2
  L5_2 = A0_2.announce_id
  if L5_2 then
    L5_2 = MySQL
    L5_2 = L5_2.single
    L5_2 = L5_2.await
    L6_2 = "SELECT id, title, avatar, last_id FROM apex_phone_conversations WHERE id = ?"
    L7_2 = {}
    L8_2 = A0_2.announce_id
    L7_2[1] = L8_2
    L5_2 = L5_2(L6_2, L7_2)
    if L5_2 then
      L6_2 = MySQL
      L6_2 = L6_2.single
      L6_2 = L6_2.await
      L7_2 = "SELECT last_read_id FROM apex_phone_conversation_members WHERE conversation_id = ? AND member = ? AND left_at IS NULL"
      L8_2 = {}
      L9_2 = A0_2.announce_id
      L10_2 = A1_2
      L8_2[1] = L9_2
      L8_2[2] = L10_2
      L6_2 = L6_2(L7_2, L8_2)
      L7_2 = 0
      if L6_2 then
        L8_2 = math
        L8_2 = L8_2.tointeger
        L9_2 = tonumber
        L10_2 = MySQL
        L10_2 = L10_2.scalar
        L10_2 = L10_2.await
        L11_2 = "SELECT COUNT(*) FROM apex_phone_messages WHERE conversation_id = ? AND id > ? AND sender <> ? AND `type` <> 'system' AND deleted_all IS NULL"
        L12_2 = {}
        L13_2 = A0_2.announce_id
        L14_2 = L1_1
        L15_2 = L6_2.last_read_id
        L14_2 = L14_2(L15_2)
        if not L14_2 then
          L14_2 = 0
        end
        L15_2 = A1_2
        L12_2[1] = L13_2
        L12_2[2] = L14_2
        L12_2[3] = L15_2
        L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2 = L10_2(L11_2, L12_2)
        L9_2 = L9_2(L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2)
        if not L9_2 then
          L9_2 = 0
        end
        L8_2 = L8_2(L9_2)
        L7_2 = L8_2 or L7_2
        if not L8_2 then
          L7_2 = 0
        end
      end
      L8_2 = L1_1
      L9_2 = L5_2.last_id
      L8_2 = L8_2(L9_2)
      if L8_2 then
        L8_2 = MySQL
        L8_2 = L8_2.single
        L8_2 = L8_2.await
        L9_2 = "SELECT sender, `type`, content, created FROM apex_phone_messages WHERE id = ?"
        L10_2 = {}
        L11_2 = L1_1
        L12_2 = L5_2.last_id
        L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2 = L11_2(L12_2)
        L10_2[1] = L11_2
        L10_2[2] = L12_2
        L10_2[3] = L13_2
        L10_2[4] = L14_2
        L10_2[5] = L15_2
        L10_2[6] = L16_2
        L10_2[7] = L17_2
        L10_2[8] = L18_2
        L8_2 = L8_2(L9_2, L10_2)
        if L8_2 then
          goto lbl_102
        end
      end
      L8_2 = nil
      ::lbl_102::
      L9_2 = {}
      L10_2 = A0_2.announce_id
      L9_2.id = L10_2
      L10_2 = L5_2.title
      L9_2.title = L10_2
      L9_2.unread = L7_2
      L10_2 = nil ~= L6_2
      L9_2.member = L10_2
      if L8_2 then
        L10_2 = {}
        L11_2 = L8_2.sender
        L10_2.sender = L11_2
        L11_2 = L8_2.type
        L10_2.type = L11_2
        L11_2 = L4_1
        L12_2 = L8_2.content
        if not L12_2 then
          L12_2 = ""
        end
        L13_2 = 120
        L11_2 = L11_2(L12_2, L13_2)
        L10_2.content = L11_2
        L11_2 = tonumber
        L12_2 = L8_2.created
        L11_2 = L11_2(L12_2)
        L10_2.created = L11_2
        if L10_2 then
          goto lbl_137
        end
      end
      L10_2 = nil
      ::lbl_137::
      L9_2.last = L10_2
      L4_2.announce = L9_2
    end
    L6_2 = math
    L6_2 = L6_2.tointeger
    L7_2 = tonumber
    L8_2 = MySQL
    L8_2 = L8_2.scalar
    L8_2 = L8_2.await
    L9_2 = "SELECT COUNT(*) FROM apex_phone_conversation_members WHERE conversation_id = ? AND left_at IS NULL"
    L10_2 = {}
    L11_2 = A0_2.announce_id
    L10_2[1] = L11_2
    L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2 = L8_2(L9_2, L10_2)
    L7_2 = L7_2(L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2)
    if not L7_2 then
      L7_2 = 0
    end
    L6_2 = L6_2(L7_2)
    if not L6_2 then
      L6_2 = 0
    end
    L4_2.memberCount = L6_2
  end
  L5_2 = {}
  L6_2 = pcall
  L7_2 = MySQL
  L7_2 = L7_2.query
  L7_2 = L7_2.await
  L8_2 = [[
SELECT g.id, g.title, g.avatar, g.last_id,
        (SELECT COUNT(*) FROM apex_phone_conversation_members x WHERE x.conversation_id = g.id AND x.left_at IS NULL) AS members,
        (SELECT role FROM apex_phone_conversation_members y WHERE y.conversation_id = g.id AND y.member = ? AND y.left_at IS NULL) AS myrole
        FROM apex_phone_conversations g WHERE g.community_id = ? AND g.id <> ? ORDER BY g.last_id DESC, g.id ASC LIMIT 100]]
  L9_2 = {}
  L10_2 = A1_2
  L11_2 = A0_2.id
  L12_2 = A0_2.announce_id
  if not L12_2 then
    L12_2 = 0
  end
  L9_2[1] = L10_2
  L9_2[2] = L11_2
  L9_2[3] = L12_2
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
        L14_2 = #L5_2
        L14_2 = L14_2 + 1
        L15_2 = {}
        L16_2 = L1_1
        L17_2 = L13_2.id
        L16_2 = L16_2(L17_2)
        L15_2.id = L16_2
        L16_2 = L13_2.title
        L15_2.title = L16_2
        L16_2 = L1_1
        L17_2 = L13_2.avatar
        L16_2 = L16_2(L17_2)
        L15_2.avatar = L16_2
        L16_2 = math
        L16_2 = L16_2.tointeger
        L17_2 = tonumber
        L18_2 = L13_2.members
        L17_2 = L17_2(L18_2)
        if not L17_2 then
          L17_2 = 0
        end
        L16_2 = L16_2(L17_2)
        if not L16_2 then
          L16_2 = 0
        end
        L15_2.memberCount = L16_2
        L16_2 = L13_2.myrole
        L16_2 = nil ~= L16_2 or L16_2
        L15_2.joined = L16_2
        L16_2 = L13_2.myrole
        if L16_2 then
          L16_2 = L13_2.myrole
          if "admin" == L16_2 then
            L16_2 = "admin"
            if L16_2 then
              goto lbl_237
            end
          end
          L16_2 = "member"
          if L16_2 then
            goto lbl_237
          end
        end
        L16_2 = nil
        ::lbl_237::
        L15_2.role = L16_2
        L5_2[L14_2] = L15_2
      end
    end
  end
  L4_2.groups = L5_2
  return L4_2
end
function L87_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2, L6_2
  L2_2 = A0_2.announce_id
  if L2_2 then
    L2_2 = type
    L3_2 = GroupBroadcast
    L2_2 = L2_2(L3_2)
    if "function" == L2_2 then
      L2_2 = pcall
      L3_2 = GroupBroadcast
      L4_2 = A0_2.announce_id
      L5_2 = "recadoCommunity"
      L6_2 = A1_2
      L2_2(L3_2, L4_2, L5_2, L6_2)
    end
  end
end
L88_1 = L36_1
L89_1 = "recado.community.create"
function L90_1(A0_2, A1_2, A2_2, A3_2)
  local L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2, L19_2, L20_2
  L4_2 = HasPhoneItem
  L5_2 = A0_2
  L4_2 = L4_2(L5_2)
  if not L4_2 then
    L4_2 = L3_1
    L5_2 = "nophone"
    return L4_2(L5_2)
  end
  L4_2 = L7_1
  L5_2 = A1_2.name
  L6_2 = 40
  L4_2 = L4_2(L5_2, L6_2)
  if not L4_2 then
    L5_2 = L3_1
    L6_2 = "name"
    return L5_2(L6_2)
  end
  L5_2 = nil
  L6_2 = A1_2.description
  if nil ~= L6_2 then
    L6_2 = A1_2.description
    if "" ~= L6_2 then
      L6_2 = L8_1
      L7_2 = A1_2.description
      L8_2 = 300
      L6_2 = L6_2(L7_2, L8_2)
      L5_2 = L6_2
      if not L5_2 then
        L6_2 = L3_1
        L7_2 = "invalid"
        return L6_2(L7_2)
      end
    end
  end
  L6_2 = nil
  L7_2 = A1_2.avatar
  if nil ~= L7_2 then
    L7_2 = A1_2.avatar
    if false ~= L7_2 then
      L7_2 = A1_2.avatar
      if 0 ~= L7_2 then
        L7_2 = A1_2.avatar
        if "" ~= L7_2 then
          L7_2 = L28_1
          L8_2 = A3_2
          L9_2 = A1_2.avatar
          L10_2 = "image"
          L7_2 = L7_2(L8_2, L9_2, L10_2)
          L6_2 = L7_2
          if not L6_2 then
            L7_2 = L3_1
            L8_2 = "media"
            return L7_2(L8_2)
          end
        end
      end
    end
  end
  L7_2 = L23_1
  L8_2 = A0_2
  L9_2 = "community.create"
  L10_2 = 5000
  L7_2 = L7_2(L8_2, L9_2, L10_2)
  if L7_2 then
    L7_2 = L3_1
    L8_2 = "cooldown"
    return L7_2(L8_2)
  end
  L7_2 = L80_1
  L7_2 = L7_2()
  L8_2 = tonumber
  L9_2 = MySQL
  L9_2 = L9_2.scalar
  L9_2 = L9_2.await
  L10_2 = "SELECT COUNT(*) FROM apex_phone_recado_communities WHERE owner = ?"
  L11_2 = {}
  L12_2 = A2_2
  L11_2[1] = L12_2
  L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2, L19_2, L20_2 = L9_2(L10_2, L11_2)
  L8_2 = L8_2(L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2, L19_2, L20_2)
  if not L8_2 then
    L8_2 = 0
  end
  L9_2 = L7_2.maxPerOwner
  if L8_2 >= L9_2 then
    L9_2 = L3_1
    L10_2 = "limit"
    L11_2 = {}
    L12_2 = L7_2.maxPerOwner
    L11_2.max = L12_2
    return L9_2(L10_2, L11_2)
  end
  L9_2 = Now
  L9_2 = L9_2()
  L10_2 = L1_1
  L11_2 = MySQL
  L11_2 = L11_2.insert
  L11_2 = L11_2.await
  L12_2 = "INSERT INTO apex_phone_recado_communities (name, description, avatar, owner, owner_cid, created, updated) VALUES (?, ?, ?, ?, ?, ?, ?)"
  L13_2 = {}
  L14_2 = L4_2
  L15_2 = L5_2
  L16_2 = L6_2
  L17_2 = A2_2
  L18_2 = A3_2
  L19_2 = L9_2
  L20_2 = L9_2
  L13_2[1] = L14_2
  L13_2[2] = L15_2
  L13_2[3] = L16_2
  L13_2[4] = L17_2
  L13_2[5] = L18_2
  L13_2[6] = L19_2
  L13_2[7] = L20_2
  L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2, L19_2, L20_2 = L11_2(L12_2, L13_2)
  L10_2 = L10_2(L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2, L19_2, L20_2)
  if not L10_2 then
    L11_2 = L3_1
    L12_2 = "db"
    return L11_2(L12_2)
  end
  L11_2 = pcall
  L12_2 = MySQL
  L12_2 = L12_2.insert
  L12_2 = L12_2.await
  L13_2 = [[
INSERT INTO apex_phone_conversations (app, title, avatar, created_by, created, kind, send_policy, edit_policy, community_id, description)
        VALUES ('recado', ?, ?, ?, ?, 'announce', 'admins', 'admins', ?, ?)]]
  L14_2 = {}
  L15_2 = L4_2
  L16_2 = L6_2
  L17_2 = A2_2
  L18_2 = L9_2
  L19_2 = L10_2
  L20_2 = L5_2
  L14_2[1] = L15_2
  L14_2[2] = L16_2
  L14_2[3] = L17_2
  L14_2[4] = L18_2
  L14_2[5] = L19_2
  L14_2[6] = L20_2
  L11_2, L12_2 = L11_2(L12_2, L13_2, L14_2)
  if L11_2 then
    L13_2 = L1_1
    L14_2 = L12_2
    L13_2 = L13_2(L14_2)
    if L13_2 then
      goto lbl_149
      L12_2 = L13_2 or L12_2
    end
  end
  L12_2 = nil
  ::lbl_149::
  if not L12_2 then
    L13_2 = print
    L14_2 = "^1[unique_phone]^0 recado.community.create: announcements group not created (%s) \226\128\148 are the kind/send_policy/community_id columns missing?"
    L15_2 = L14_2
    L14_2 = L14_2.format
    L16_2 = tostring
    if L11_2 then
      L17_2 = "no id"
      if L17_2 then
        goto lbl_161
      end
    end
    L17_2 = L12_2
    ::lbl_161::
    L16_2, L17_2, L18_2, L19_2, L20_2 = L16_2(L17_2)
    L14_2, L15_2, L16_2, L17_2, L18_2, L19_2, L20_2 = L14_2(L15_2, L16_2, L17_2, L18_2, L19_2, L20_2)
    L13_2(L14_2, L15_2, L16_2, L17_2, L18_2, L19_2, L20_2)
    L13_2 = MySQL
    L13_2 = L13_2.update
    L13_2 = L13_2.await
    L14_2 = "DELETE FROM apex_phone_recado_communities WHERE id = ?"
    L15_2 = {}
    L16_2 = L10_2
    L15_2[1] = L16_2
    L13_2(L14_2, L15_2)
    L13_2 = L3_1
    L14_2 = "db"
    return L13_2(L14_2)
  end
  L13_2 = MySQL
  L13_2 = L13_2.update
  L13_2 = L13_2.await
  L14_2 = "INSERT INTO apex_phone_conversation_members (conversation_id, member, role, joined) VALUES (?, ?, 'admin', ?)"
  L15_2 = {}
  L16_2 = L12_2
  L17_2 = A2_2
  L18_2 = L9_2
  L15_2[1] = L16_2
  L15_2[2] = L17_2
  L15_2[3] = L18_2
  L13_2(L14_2, L15_2)
  L13_2 = MySQL
  L13_2 = L13_2.update
  L13_2 = L13_2.await
  L14_2 = "UPDATE apex_phone_recado_communities SET announce_id = ? WHERE id = ?"
  L15_2 = {}
  L16_2 = L12_2
  L17_2 = L10_2
  L15_2[1] = L16_2
  L15_2[2] = L17_2
  L13_2(L14_2, L15_2)
  L13_2 = L83_1
  L14_2 = L12_2
  L15_2 = A2_2
  L16_2 = "Comunidade \194\171%s\194\187 criada. S\195\179 administradores enviam an\195\186ncios."
  L17_2 = L16_2
  L16_2 = L16_2.format
  L18_2 = L4_2
  L16_2 = L16_2(L17_2, L18_2)
  L17_2 = {}
  L17_2.action = "community"
  L17_2.community = L10_2
  L17_2.by = A2_2
  L13_2(L14_2, L15_2, L16_2, L17_2)
  L13_2 = Dbg
  L14_2 = "recado"
  L15_2 = "community %s \"%s\" created by %s (announcements %s)"
  L16_2 = L10_2
  L17_2 = L4_2
  L18_2 = A2_2
  L19_2 = L12_2
  L13_2(L14_2, L15_2, L16_2, L17_2, L18_2, L19_2)
  L13_2 = L81_1
  L14_2 = L10_2
  L13_2 = L13_2(L14_2)
  L14_2 = L86_1
  L15_2 = L13_2
  L16_2 = A2_2
  L17_2 = A3_2
  L18_2 = "admin"
  return L14_2(L15_2, L16_2, L17_2, L18_2)
end
L88_1(L89_1, L90_1)
function L88_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2, L6_2, L7_2
  L2_2 = L1_1
  L3_2 = A1_2
  L2_2 = L2_2(L3_2)
  if not L2_2 then
    L3_2 = nil
    L4_2 = "invalid"
    return L3_2, L4_2
  end
  L3_2 = L81_1
  L4_2 = L2_2
  L3_2 = L3_2(L4_2)
  if not L3_2 then
    L4_2 = nil
    L5_2 = "notfound"
    return L4_2, L5_2
  end
  L4_2 = L85_1
  L5_2 = L3_2
  L6_2 = false
  L4_2(L5_2, L6_2)
  L4_2 = L82_1
  L5_2 = L3_2
  L6_2 = A0_2
  L4_2 = L4_2(L5_2, L6_2)
  if not L4_2 then
    L5_2 = nil
    L6_2 = "notfound"
    return L5_2, L6_2
  end
  L5_2 = L3_2
  L6_2 = nil
  L7_2 = L4_2
  return L5_2, L6_2, L7_2
end
L89_1 = L36_1
L90_1 = "recado.community.get"
function L91_1(A0_2, A1_2, A2_2, A3_2)
  local L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2
  L4_2 = L88_1
  L5_2 = A2_2
  L6_2 = A1_2.id
  L4_2, L5_2, L6_2 = L4_2(L5_2, L6_2)
  if not L4_2 then
    L7_2 = L3_1
    L8_2 = L5_2
    return L7_2(L8_2)
  end
  L7_2 = L86_1
  L8_2 = L4_2
  L9_2 = A2_2
  L10_2 = A3_2
  L11_2 = L6_2
  return L7_2(L8_2, L9_2, L10_2, L11_2)
end
L89_1(L90_1, L91_1)
L89_1 = L36_1
L90_1 = "recado.community.list"
function L91_1(A0_2, A1_2, A2_2, A3_2)
  local L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2, L19_2
  L4_2 = pcall
  L5_2 = MySQL
  L5_2 = L5_2.query
  L5_2 = L5_2.await
  L6_2 = [[
SELECT DISTINCT c.id FROM apex_phone_recado_communities c
        JOIN apex_phone_conversations g ON (g.id = c.announce_id OR g.community_id = c.id)
        JOIN apex_phone_conversation_members m ON m.conversation_id = g.id AND m.member = ? AND m.left_at IS NULL
        ORDER BY c.id DESC LIMIT 50]]
  L7_2 = {}
  L8_2 = A2_2
  L7_2[1] = L8_2
  L4_2, L5_2 = L4_2(L5_2, L6_2, L7_2)
  if L4_2 then
    L6_2 = type
    L7_2 = L5_2
    L6_2 = L6_2(L7_2)
    if "table" == L6_2 then
      goto lbl_32
    end
  end
  L6_2 = MySQL
  L6_2 = L6_2.query
  L6_2 = L6_2.await
  L7_2 = [[
SELECT DISTINCT c.id FROM apex_phone_recado_communities c
            JOIN apex_phone_conversation_members m ON m.conversation_id = c.announce_id AND m.member = ? AND m.left_at IS NULL ORDER BY c.id DESC LIMIT 50]]
  L8_2 = {}
  L9_2 = A2_2
  L8_2[1] = L9_2
  L6_2 = L6_2(L7_2, L8_2)
  L5_2 = L6_2 or L5_2
  if not L6_2 then
    L6_2 = {}
    L5_2 = L6_2
  end
  ::lbl_32::
  L6_2 = {}
  L7_2 = ipairs
  L8_2 = L5_2
  L7_2, L8_2, L9_2, L10_2 = L7_2(L8_2)
  for L11_2, L12_2 in L7_2, L8_2, L9_2, L10_2 do
    L13_2 = L81_1
    L14_2 = math
    L14_2 = L14_2.tointeger
    L15_2 = tonumber
    L16_2 = L12_2.id
    L15_2, L16_2, L17_2, L18_2, L19_2 = L15_2(L16_2)
    L14_2, L15_2, L16_2, L17_2, L18_2, L19_2 = L14_2(L15_2, L16_2, L17_2, L18_2, L19_2)
    L13_2 = L13_2(L14_2, L15_2, L16_2, L17_2, L18_2, L19_2)
    if L13_2 then
      L14_2 = L85_1
      L15_2 = L13_2
      L16_2 = false
      L14_2(L15_2, L16_2)
      L14_2 = L82_1
      L15_2 = L13_2
      L16_2 = A2_2
      L14_2 = L14_2(L15_2, L16_2)
      if L14_2 then
        L15_2 = L86_1
        L16_2 = L13_2
        L17_2 = A2_2
        L18_2 = A3_2
        L19_2 = L14_2
        L15_2 = L15_2(L16_2, L17_2, L18_2, L19_2)
        L15_2.ok = nil
        L16_2 = #L6_2
        L16_2 = L16_2 + 1
        L6_2[L16_2] = L15_2
      end
    end
  end
  return L6_2
end
L89_1(L90_1, L91_1)
L89_1 = L36_1
L90_1 = "recado.community.update"
function L91_1(A0_2, A1_2, A2_2, A3_2)
  local L4_2, L5_2, L6_2, L7_2
  L4_2 = L1_1
  L5_2 = A1_2.id
  L4_2 = L4_2(L5_2)
  if not L4_2 then
    L5_2 = L3_1
    L6_2 = "invalid"
    return L5_2(L6_2)
  end
  L5_2 = L21_1
  L6_2 = "cm:"
  L7_2 = L4_2
  L6_2 = L6_2 .. L7_2
  function L7_2()
    local L0_3, L1_3, L2_3, L3_3, L4_3, L5_3, L6_3, L7_3, L8_3, L9_3, L10_3, L11_3
    L0_3 = L88_1
    L1_3 = A2_2
    L2_3 = L4_2
    L0_3, L1_3, L2_3 = L0_3(L1_3, L2_3)
    if not L0_3 then
      L3_3 = L3_1
      L4_3 = L1_3
      return L3_3(L4_3)
    end
    if "admin" ~= L2_3 then
      L3_3 = L3_1
      L4_3 = "notadmin"
      return L3_3(L4_3)
    end
    L3_3 = {}
    L4_3 = {}
    L5_3 = {}
    L6_3 = {}
    L7_3 = A1_2.name
    if nil ~= L7_3 then
      L7_3 = L7_1
      L8_3 = A1_2.name
      L9_3 = 40
      L7_3 = L7_3(L8_3, L9_3)
      if not L7_3 then
        L8_3 = L3_1
        L9_3 = "name"
        return L8_3(L9_3)
      end
      L8_3 = #L3_3
      L8_3 = L8_3 + 1
      L3_3[L8_3] = "name = ?"
      L8_3 = #L4_3
      L8_3 = L8_3 + 1
      L4_3[L8_3] = L7_3
      L8_3 = #L5_3
      L8_3 = L8_3 + 1
      L5_3[L8_3] = "title = ?"
      L8_3 = #L6_3
      L8_3 = L8_3 + 1
      L6_3[L8_3] = L7_3
    end
    L7_3 = A1_2.description
    if nil ~= L7_3 then
      L7_3 = A1_2.description
      if "" ~= L7_3 then
        L7_3 = A1_2.description
        if false ~= L7_3 then
          goto lbl_68
        end
      end
      L7_3 = #L3_3
      L7_3 = L7_3 + 1
      L3_3[L7_3] = "description = NULL"
      goto lbl_86
      ::lbl_68::
      L7_3 = L8_1
      L8_3 = A1_2.description
      L9_3 = 300
      L7_3 = L7_3(L8_3, L9_3)
      if not L7_3 then
        L8_3 = L3_1
        L9_3 = "invalid"
        return L8_3(L9_3)
      end
      L8_3 = #L3_3
      L8_3 = L8_3 + 1
      L3_3[L8_3] = "description = ?"
      L8_3 = #L4_3
      L8_3 = L8_3 + 1
      L4_3[L8_3] = L7_3
    end
    ::lbl_86::
    L7_3 = A1_2.avatar
    if nil ~= L7_3 then
      L7_3 = A1_2.avatar
      if false ~= L7_3 then
        L7_3 = A1_2.avatar
        if 0 ~= L7_3 then
          L7_3 = A1_2.avatar
          if "" ~= L7_3 then
            goto lbl_107
          end
        end
      end
      L7_3 = #L3_3
      L7_3 = L7_3 + 1
      L3_3[L7_3] = "avatar = NULL"
      L7_3 = #L5_3
      L7_3 = L7_3 + 1
      L5_3[L7_3] = "avatar = NULL"
      goto lbl_141
      ::lbl_107::
      L7_3 = L28_1
      L8_3 = A3_2
      L9_3 = A1_2.avatar
      L10_3 = "image"
      L7_3 = L7_3(L8_3, L9_3, L10_3)
      if L7_3 then
        L8_3 = #L3_3
        L8_3 = L8_3 + 1
        L3_3[L8_3] = "avatar = ?"
        L8_3 = #L4_3
        L8_3 = L8_3 + 1
        L4_3[L8_3] = L7_3
        L8_3 = #L5_3
        L8_3 = L8_3 + 1
        L5_3[L8_3] = "avatar = ?"
        L8_3 = #L6_3
        L8_3 = L8_3 + 1
        L6_3[L8_3] = L7_3
      else
        L8_3 = L1_1
        L9_3 = A1_2.avatar
        L8_3 = L8_3(L9_3)
        L9_3 = L0_3.avatar
        if L8_3 ~= L9_3 then
          L8_3 = L3_1
          L9_3 = "media"
          return L8_3(L9_3)
        end
      end
    end
    ::lbl_141::
    L7_3 = #L3_3
    if L7_3 > 0 then
      L7_3 = #L3_3
      L7_3 = L7_3 + 1
      L3_3[L7_3] = "updated = ?"
      L7_3 = #L4_3
      L7_3 = L7_3 + 1
      L8_3 = Now
      L8_3 = L8_3()
      L4_3[L7_3] = L8_3
      L7_3 = #L4_3
      L7_3 = L7_3 + 1
      L8_3 = L4_2
      L4_3[L7_3] = L8_3
      L7_3 = MySQL
      L7_3 = L7_3.update
      L7_3 = L7_3.await
      L8_3 = "UPDATE apex_phone_recado_communities SET "
      L9_3 = table
      L9_3 = L9_3.concat
      L10_3 = L3_3
      L11_3 = ", "
      L9_3 = L9_3(L10_3, L11_3)
      L10_3 = " WHERE id = ?"
      L8_3 = L8_3 .. L9_3 .. L10_3
      L9_3 = L4_3
      L7_3(L8_3, L9_3)
    end
    L7_3 = #L5_3
    if L7_3 > 0 then
      L7_3 = L0_3.announce_id
      if L7_3 then
        L7_3 = #L6_3
        L7_3 = L7_3 + 1
        L8_3 = L0_3.announce_id
        L6_3[L7_3] = L8_3
        L7_3 = MySQL
        L7_3 = L7_3.update
        L7_3 = L7_3.await
        L8_3 = "UPDATE apex_phone_conversations SET "
        L9_3 = table
        L9_3 = L9_3.concat
        L10_3 = L5_3
        L11_3 = ", "
        L9_3 = L9_3(L10_3, L11_3)
        L10_3 = " WHERE id = ?"
        L8_3 = L8_3 .. L9_3 .. L10_3
        L9_3 = L6_3
        L7_3(L8_3, L9_3)
      end
    end
    L7_3 = L81_1
    L8_3 = L4_2
    L7_3 = L7_3(L8_3)
    L0_3 = L7_3
    L7_3 = L87_1
    L8_3 = L0_3
    L9_3 = {}
    L10_3 = L4_2
    L9_3.id = L10_3
    L9_3.action = "update"
    L7_3(L8_3, L9_3)
    L7_3 = L86_1
    L8_3 = L0_3
    L9_3 = A2_2
    L10_3 = A3_2
    L11_3 = L2_3
    return L7_3(L8_3, L9_3, L10_3, L11_3)
  end
  return L5_2(L6_2, L7_2)
end
L89_1(L90_1, L91_1)
function L89_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2
  L2_2 = L1_1
  L3_2 = A1_2
  L2_2 = L2_2(L3_2)
  if not L2_2 then
    L3_2 = nil
    L4_2 = "invalid"
    return L3_2, L4_2
  end
  L3_2 = pcall
  L4_2 = MySQL
  L4_2 = L4_2.single
  L4_2 = L4_2.await
  L5_2 = [[
SELECT g.id, g.title, g.app, g.kind, g.community_id, m.role FROM apex_phone_conversations g
        LEFT JOIN apex_phone_conversation_members m ON m.conversation_id = g.id AND m.member = ? AND m.left_at IS NULL WHERE g.id = ?]]
  L6_2 = {}
  L7_2 = A0_2
  L8_2 = L2_2
  L6_2[1] = L7_2
  L6_2[2] = L8_2
  L3_2, L4_2 = L3_2(L4_2, L5_2, L6_2)
  if not L3_2 then
    L5_2 = nil
    L6_2 = "db"
    return L5_2, L6_2
  end
  if L4_2 then
    L5_2 = L4_2.app
    if "recado" == L5_2 then
      goto lbl_33
    end
  end
  L5_2 = nil
  L6_2 = "notfound"
  do return L5_2, L6_2 end
  ::lbl_33::
  L4_2.id = L2_2
  L5_2 = L1_1
  L6_2 = L4_2.community_id
  L5_2 = L5_2(L6_2)
  L4_2.community_id = L5_2
  return L4_2
end
L90_1 = L36_1
L91_1 = "recado.community.addGroup"
function L92_1(A0_2, A1_2, A2_2, A3_2)
  local L4_2, L5_2, L6_2, L7_2
  L4_2 = L1_1
  L5_2 = A1_2.id
  L4_2 = L4_2(L5_2)
  if not L4_2 then
    L5_2 = L3_1
    L6_2 = "invalid"
    return L5_2(L6_2)
  end
  L5_2 = L21_1
  L6_2 = "cm:"
  L7_2 = L4_2
  L6_2 = L6_2 .. L7_2
  function L7_2()
    local L0_3, L1_3, L2_3, L3_3, L4_3, L5_3, L6_3, L7_3, L8_3, L9_3, L10_3, L11_3, L12_3
    L0_3 = L88_1
    L1_3 = A2_2
    L2_3 = L4_2
    L0_3, L1_3, L2_3 = L0_3(L1_3, L2_3)
    if not L0_3 then
      L3_3 = L3_1
      L4_3 = L1_3
      return L3_3(L4_3)
    end
    if "admin" ~= L2_3 then
      L3_3 = L3_1
      L4_3 = "notadmin"
      return L3_3(L4_3)
    end
    L3_3 = L89_1
    L4_3 = A2_2
    L5_3 = A1_2.conversation
    L3_3, L4_3 = L3_3(L4_3, L5_3)
    if not L3_3 then
      L5_3 = L3_1
      L6_3 = L4_3
      return L5_3(L6_3)
    end
    L5_3 = L3_3.role
    if "admin" ~= L5_3 then
      L5_3 = L3_1
      L6_3 = "notgroupadmin"
      return L5_3(L6_3)
    end
    L5_3 = L3_3.kind
    if "announce" == L5_3 then
      L5_3 = L3_1
      L6_3 = "invalid"
      return L5_3(L6_3)
    end
    L5_3 = L3_3.community_id
    if L5_3 then
      L5_3 = L3_1
      L6_3 = L3_3.community_id
      L7_3 = L4_2
      if L6_3 == L7_3 then
        L6_3 = "already"
        if L6_3 then
          goto lbl_53
        end
      end
      L6_3 = "incommunity"
      ::lbl_53::
      return L5_3(L6_3)
    end
    L5_3 = tonumber
    L6_3 = MySQL
    L6_3 = L6_3.scalar
    L6_3 = L6_3.await
    L7_3 = "SELECT COUNT(*) FROM apex_phone_conversations WHERE community_id = ? AND id <> ?"
    L8_3 = {}
    L9_3 = L4_2
    L10_3 = L0_3.announce_id
    if not L10_3 then
      L10_3 = 0
    end
    L8_3[1] = L9_3
    L8_3[2] = L10_3
    L6_3, L7_3, L8_3, L9_3, L10_3, L11_3, L12_3 = L6_3(L7_3, L8_3)
    L5_3 = L5_3(L6_3, L7_3, L8_3, L9_3, L10_3, L11_3, L12_3)
    if not L5_3 then
      L5_3 = 0
    end
    L6_3 = L80_1
    L6_3 = L6_3()
    L6_3 = L6_3.maxGroups
    if L5_3 >= L6_3 then
      L6_3 = L3_1
      L7_3 = "full"
      L8_3 = {}
      L9_3 = L80_1
      L9_3 = L9_3()
      L9_3 = L9_3.maxGroups
      L8_3.max = L9_3
      return L6_3(L7_3, L8_3)
    end
    L6_3 = tonumber
    L7_3 = MySQL
    L7_3 = L7_3.update
    L7_3 = L7_3.await
    L8_3 = "UPDATE apex_phone_conversations SET community_id = ? WHERE id = ? AND community_id IS NULL"
    L9_3 = {}
    L10_3 = L4_2
    L11_3 = L3_3.id
    L9_3[1] = L10_3
    L9_3[2] = L11_3
    L7_3, L8_3, L9_3, L10_3, L11_3, L12_3 = L7_3(L8_3, L9_3)
    L6_3 = L6_3(L7_3, L8_3, L9_3, L10_3, L11_3, L12_3)
    if not L6_3 then
      L6_3 = 0
    end
    if L6_3 < 1 then
      L7_3 = L3_1
      L8_3 = "incommunity"
      return L7_3(L8_3)
    end
    L7_3 = L83_1
    L8_3 = L3_3.id
    L9_3 = A2_2
    L10_3 = "Este grupo passou a fazer parte da comunidade \194\171%s\194\187"
    L11_3 = L10_3
    L10_3 = L10_3.format
    L12_3 = L0_3.name
    L10_3 = L10_3(L11_3, L12_3)
    L11_3 = {}
    L11_3.action = "community"
    L12_3 = L4_2
    L11_3.community = L12_3
    L12_3 = A2_2
    L11_3.by = L12_3
    L7_3(L8_3, L9_3, L10_3, L11_3)
    L7_3 = L85_1
    L8_3 = L0_3
    L9_3 = true
    L7_3(L8_3, L9_3)
    L7_3 = L87_1
    L8_3 = L0_3
    L9_3 = {}
    L10_3 = L4_2
    L9_3.id = L10_3
    L9_3.action = "addGroup"
    L10_3 = L3_3.id
    L9_3.conversation = L10_3
    L7_3(L8_3, L9_3)
    L7_3 = L86_1
    L8_3 = L0_3
    L9_3 = A2_2
    L10_3 = A3_2
    L11_3 = L2_3
    return L7_3(L8_3, L9_3, L10_3, L11_3)
  end
  return L5_2(L6_2, L7_2)
end
L90_1(L91_1, L92_1)
L90_1 = L36_1
L91_1 = "recado.community.removeGroup"
function L92_1(A0_2, A1_2, A2_2, A3_2)
  local L4_2, L5_2, L6_2, L7_2
  L4_2 = L1_1
  L5_2 = A1_2.id
  L4_2 = L4_2(L5_2)
  if not L4_2 then
    L5_2 = L3_1
    L6_2 = "invalid"
    return L5_2(L6_2)
  end
  L5_2 = L21_1
  L6_2 = "cm:"
  L7_2 = L4_2
  L6_2 = L6_2 .. L7_2
  function L7_2()
    local L0_3, L1_3, L2_3, L3_3, L4_3, L5_3, L6_3, L7_3, L8_3, L9_3
    L0_3 = L81_1
    L1_3 = L4_2
    L0_3 = L0_3(L1_3)
    if not L0_3 then
      L1_3 = L3_1
      L2_3 = "notfound"
      return L1_3(L2_3)
    end
    L1_3 = L82_1
    L2_3 = L0_3
    L3_3 = A2_2
    L1_3 = L1_3(L2_3, L3_3)
    L2_3 = L89_1
    L3_3 = A2_2
    L4_3 = A1_2.conversation
    L2_3, L3_3 = L2_3(L3_3, L4_3)
    if not L2_3 then
      L4_3 = L3_1
      L5_3 = L3_3
      return L4_3(L5_3)
    end
    L4_3 = L2_3.community_id
    L5_3 = L4_2
    if L4_3 ~= L5_3 then
      L4_3 = L3_1
      L5_3 = "notfound"
      return L4_3(L5_3)
    end
    if "admin" ~= L1_3 then
      L4_3 = L2_3.role
      if "admin" ~= L4_3 then
        L4_3 = L3_1
        L5_3 = "notadmin"
        return L4_3(L5_3)
      end
    end
    L4_3 = MySQL
    L4_3 = L4_3.update
    L4_3 = L4_3.await
    L5_3 = "UPDATE apex_phone_conversations SET community_id = NULL WHERE id = ? AND community_id = ?"
    L6_3 = {}
    L7_3 = L2_3.id
    L8_3 = L4_2
    L6_3[1] = L7_3
    L6_3[2] = L8_3
    L4_3(L5_3, L6_3)
    L4_3 = L83_1
    L5_3 = L2_3.id
    L6_3 = A2_2
    L7_3 = "Este grupo saiu da comunidade \194\171%s\194\187"
    L8_3 = L7_3
    L7_3 = L7_3.format
    L9_3 = L0_3.name
    L7_3 = L7_3(L8_3, L9_3)
    L8_3 = {}
    L8_3.action = "community"
    L9_3 = L4_2
    L8_3.community = L9_3
    L9_3 = A2_2
    L8_3.by = L9_3
    L8_3.removed = true
    L4_3(L5_3, L6_3, L7_3, L8_3)
    L4_3 = L87_1
    L5_3 = L0_3
    L6_3 = {}
    L7_3 = L4_2
    L6_3.id = L7_3
    L6_3.action = "removeGroup"
    L7_3 = L2_3.id
    L6_3.conversation = L7_3
    L4_3(L5_3, L6_3)
    L4_3 = L85_1
    L5_3 = L0_3
    L6_3 = true
    L4_3(L5_3, L6_3)
    L4_3 = L27_1
    L4_3()
    L4_3 = L82_1
    L5_3 = L0_3
    L6_3 = A2_2
    L4_3 = L4_3(L5_3, L6_3)
    L1_3 = L4_3
    if not L1_3 then
      L4_3 = {}
      L4_3.ok = true
      L5_3 = L4_2
      L4_3.id = L5_3
      L4_3.left = true
      return L4_3
    end
    L4_3 = L86_1
    L5_3 = L0_3
    L6_3 = A2_2
    L7_3 = A3_2
    L8_3 = L1_3
    return L4_3(L5_3, L6_3, L7_3, L8_3)
  end
  return L5_2(L6_2, L7_2)
end
L90_1(L91_1, L92_1)
function L90_1(A0_2, A1_2, A2_2, A3_2)
  local L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2
  L4_2 = MySQL
  L4_2 = L4_2.query
  L4_2 = L4_2.await
  L5_2 = "SELECT member, role, joined FROM apex_phone_conversation_members WHERE conversation_id = ? AND left_at IS NULL ORDER BY role ASC, joined ASC LIMIT 1000"
  L6_2 = {}
  L7_2 = A0_2.announce_id
  if not L7_2 then
    L7_2 = 0
  end
  L6_2[1] = L7_2
  L4_2 = L4_2(L5_2, L6_2)
  if not L4_2 then
    L4_2 = {}
  end
  if "admin" ~= A3_2 then
    L5_2 = {}
    L5_2.ok = true
    L6_2 = A0_2.id
    L5_2.id = L6_2
    L6_2 = #L4_2
    L5_2.count = L6_2
    return L5_2
  end
  L5_2 = {}
  L6_2 = ipairs
  L7_2 = L4_2
  L6_2, L7_2, L8_2, L9_2 = L6_2(L7_2)
  for L10_2, L11_2 in L6_2, L7_2, L8_2, L9_2 do
    L12_2 = #L5_2
    L12_2 = L12_2 + 1
    L13_2 = tostring
    L14_2 = L11_2.member
    L13_2 = L13_2(L14_2)
    L5_2[L12_2] = L13_2
  end
  L6_2 = L29_1
  L7_2 = A2_2
  L8_2 = L5_2
  L6_2 = L6_2(L7_2, L8_2)
  L7_2 = {}
  L8_2 = ipairs
  L9_2 = L4_2
  L8_2, L9_2, L10_2, L11_2 = L8_2(L9_2)
  for L12_2, L13_2 in L8_2, L9_2, L10_2, L11_2 do
    L14_2 = tostring
    L15_2 = L13_2.member
    L14_2 = L14_2(L15_2)
    L15_2 = #L7_2
    L15_2 = L15_2 + 1
    L16_2 = {}
    L16_2.number = L14_2
    L17_2 = L13_2.role
    if "admin" == L17_2 then
      L17_2 = "admin"
      if L17_2 then
        goto lbl_69
      end
    end
    L17_2 = "member"
    ::lbl_69::
    L16_2.role = L17_2
    L17_2 = L6_2[L14_2]
    if not L17_2 then
      L17_2 = L30_1
      L18_2 = L14_2
      L17_2 = L17_2(L18_2)
    end
    L16_2.name = L17_2
    L17_2 = L14_2 == A1_2 or L17_2
    L16_2.isMe = L17_2
    L17_2 = A0_2.owner
    L17_2 = L14_2 == L17_2 or L17_2
    L16_2.owner = L17_2
    L7_2[L15_2] = L16_2
  end
  L8_2 = {}
  L8_2.ok = true
  L9_2 = A0_2.id
  L8_2.id = L9_2
  L9_2 = #L7_2
  L8_2.count = L9_2
  L8_2.items = L7_2
  L8_2.myRole = A3_2
  return L8_2
end
L91_1 = L36_1
L92_1 = "recado.community.members"
function L93_1(A0_2, A1_2, A2_2, A3_2)
  local L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2
  L4_2 = L88_1
  L5_2 = A2_2
  L6_2 = A1_2.id
  L4_2, L5_2, L6_2 = L4_2(L5_2, L6_2)
  if not L4_2 then
    L7_2 = L3_1
    L8_2 = L5_2
    return L7_2(L8_2)
  end
  L7_2 = L90_1
  L8_2 = L4_2
  L9_2 = A2_2
  L10_2 = A3_2
  L11_2 = L6_2
  return L7_2(L8_2, L9_2, L10_2, L11_2)
end
L91_1(L92_1, L93_1)
L91_1 = L36_1
L92_1 = "recado.community.admin"
function L93_1(A0_2, A1_2, A2_2, A3_2)
  local L4_2, L5_2, L6_2, L7_2, L8_2, L9_2
  L4_2 = L1_1
  L5_2 = A1_2.id
  L4_2 = L4_2(L5_2)
  L5_2 = L9_1
  L6_2 = A1_2.number
  L5_2 = L5_2(L6_2)
  if not L4_2 or not L5_2 then
    L6_2 = L3_1
    L7_2 = "invalid"
    return L6_2(L7_2)
  end
  L6_2 = L15_1
  L7_2 = A1_2.on
  L6_2 = L6_2(L7_2)
  L7_2 = L21_1
  L8_2 = "cm:"
  L9_2 = L4_2
  L8_2 = L8_2 .. L9_2
  function L9_2()
    local L0_3, L1_3, L2_3, L3_3, L4_3, L5_3, L6_3, L7_3, L8_3, L9_3, L10_3, L11_3
    L0_3 = L88_1
    L1_3 = A2_2
    L2_3 = L4_2
    L0_3, L1_3, L2_3 = L0_3(L1_3, L2_3)
    if not L0_3 then
      L3_3 = L3_1
      L4_3 = L1_3
      return L3_3(L4_3)
    end
    if "admin" == L2_3 then
      L3_3 = L0_3.announce_id
      if L3_3 then
        goto lbl_20
      end
    end
    L3_3 = L3_1
    L4_3 = "notadmin"
    do return L3_3(L4_3) end
    ::lbl_20::
    L3_3 = MySQL
    L3_3 = L3_3.scalar
    L3_3 = L3_3.await
    L4_3 = "SELECT role FROM apex_phone_conversation_members WHERE conversation_id = ? AND member = ? AND left_at IS NULL"
    L5_3 = {}
    L6_3 = L0_3.announce_id
    L7_3 = L5_2
    L5_3[1] = L6_3
    L5_3[2] = L7_3
    L3_3 = L3_3(L4_3, L5_3)
    if not L3_3 then
      L4_3 = L3_1
      L5_3 = "notmember"
      return L4_3(L5_3)
    end
    L4_3 = L6_2
    if L4_3 then
      L4_3 = "admin"
      if L4_3 then
        goto lbl_43
      end
    end
    L4_3 = "member"
    ::lbl_43::
    if "admin" == L3_3 then
      L5_3 = "admin"
      if L5_3 then
        goto lbl_49
      end
    end
    L5_3 = "member"
    ::lbl_49::
    if L5_3 ~= L4_3 then
      L5_3 = L6_2
      if not L5_3 then
        L5_3 = L5_2
        L6_3 = L0_3.owner
        if L5_3 == L6_3 then
          L5_3 = A2_2
          L6_3 = L0_3.owner
          if L5_3 ~= L6_3 then
            L5_3 = L3_1
            L6_3 = "notowner"
            return L5_3(L6_3)
          end
        end
        L5_3 = tonumber
        L6_3 = MySQL
        L6_3 = L6_3.scalar
        L6_3 = L6_3.await
        L7_3 = "SELECT COUNT(*) FROM apex_phone_conversation_members WHERE conversation_id = ? AND role = 'admin' AND left_at IS NULL"
        L8_3 = {}
        L9_3 = L0_3.announce_id
        L8_3[1] = L9_3
        L6_3, L7_3, L8_3, L9_3, L10_3, L11_3 = L6_3(L7_3, L8_3)
        L5_3 = L5_3(L6_3, L7_3, L8_3, L9_3, L10_3, L11_3)
        if not L5_3 then
          L5_3 = 0
        end
        if L5_3 <= 1 then
          L6_3 = L3_1
          L7_3 = "lastadmin"
          return L6_3(L7_3)
        end
      end
      L5_3 = MySQL
      L5_3 = L5_3.update
      L5_3 = L5_3.await
      L6_3 = "UPDATE apex_phone_conversation_members SET role = ? WHERE conversation_id = ? AND member = ? AND left_at IS NULL"
      L7_3 = {}
      L8_3 = L4_3
      L9_3 = L0_3.announce_id
      L10_3 = L5_2
      L7_3[1] = L8_3
      L7_3[2] = L9_3
      L7_3[3] = L10_3
      L5_3(L6_3, L7_3)
      L5_3 = L83_1
      L6_3 = L0_3.announce_id
      L7_3 = A2_2
      L8_3 = L6_2
      if L8_3 then
        L8_3 = "%s passou a administrar a comunidade"
        L9_3 = L8_3
        L8_3 = L8_3.format
        L10_3 = L5_2
        L8_3 = L8_3(L9_3, L10_3)
        if L8_3 then
          goto lbl_113
        end
      end
      L8_3 = "%s deixou de administrar a comunidade"
      L9_3 = L8_3
      L8_3 = L8_3.format
      L10_3 = L5_2
      L8_3 = L8_3(L9_3, L10_3)
      ::lbl_113::
      L9_3 = {}
      L9_3.action = "role"
      L10_3 = A2_2
      L9_3.by = L10_3
      L10_3 = {}
      L11_3 = L5_2
      L10_3[1] = L11_3
      L9_3.targets = L10_3
      L9_3.role = L4_3
      L10_3 = L4_2
      L9_3.community = L10_3
      L5_3(L6_3, L7_3, L8_3, L9_3)
      L5_3 = type
      L6_3 = GroupBroadcast
      L5_3 = L5_3(L6_3)
      if "function" == L5_3 then
        L5_3 = pcall
        L6_3 = GroupBroadcast
        L7_3 = L0_3.announce_id
        L8_3 = "groupUpdate"
        L9_3 = {}
        L10_3 = L0_3.announce_id
        L9_3.id = L10_3
        L9_3.action = "role"
        L10_3 = A2_2
        L9_3.by = L10_3
        L10_3 = {}
        L11_3 = L5_2
        L10_3[1] = L11_3
        L9_3.targets = L10_3
        L9_3.role = L4_3
        L5_3(L6_3, L7_3, L8_3, L9_3)
      end
      L5_3 = L87_1
      L6_3 = L0_3
      L7_3 = {}
      L8_3 = L4_2
      L7_3.id = L8_3
      L7_3.action = "role"
      L8_3 = L5_2
      L7_3.number = L8_3
      L7_3.role = L4_3
      L5_3(L6_3, L7_3)
      L5_3 = Dbg
      L6_3 = "recado"
      L7_3 = "community %s: %s %s admin (%s)"
      L8_3 = L4_2
      L9_3 = A2_2
      L10_3 = L6_2
      if L10_3 then
        L10_3 = "appointed"
        if L10_3 then
          goto lbl_173
        end
      end
      L10_3 = "removed"
      ::lbl_173::
      L11_3 = L5_2
      L5_3(L6_3, L7_3, L8_3, L9_3, L10_3, L11_3)
    end
    L5_3 = L82_1
    L6_3 = L0_3
    L7_3 = A2_2
    L5_3 = L5_3(L6_3, L7_3)
    L2_3 = L5_3 or L2_3
    if not L5_3 then
    end
    L5_3 = L90_1
    L6_3 = L0_3
    L7_3 = A2_2
    L8_3 = A3_2
    L9_3 = L2_3
    return L5_3(L6_3, L7_3, L8_3, L9_3)
  end
  return L7_2(L8_2, L9_2)
end
L91_1(L92_1, L93_1)
L91_1 = L36_1
L92_1 = "recado.community.candidates"
function L93_1(A0_2, A1_2, A2_2)
  local L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2
  L3_2 = pcall
  L4_2 = MySQL
  L4_2 = L4_2.query
  L4_2 = L4_2.await
  L5_2 = [[
SELECT g.id, g.title, g.avatar,
        (SELECT COUNT(*) FROM apex_phone_conversation_members x WHERE x.conversation_id = g.id AND x.left_at IS NULL) AS members
        FROM apex_phone_conversations g JOIN apex_phone_conversation_members m ON m.conversation_id = g.id AND m.member = ? AND m.left_at IS NULL AND m.role = 'admin'
        WHERE g.app = 'recado' AND (g.kind IS NULL OR g.kind = 'group') AND g.community_id IS NULL ORDER BY g.last_id DESC LIMIT 100]]
  L6_2 = {}
  L7_2 = A2_2
  L6_2[1] = L7_2
  L3_2, L4_2 = L3_2(L4_2, L5_2, L6_2)
  if not L3_2 then
    L5_2 = L3_1
    L6_2 = "db"
    return L5_2(L6_2)
  end
  L5_2 = {}
  L6_2 = ipairs
  L7_2 = L4_2 or L7_2
  if not L4_2 then
    L7_2 = {}
  end
  L6_2, L7_2, L8_2, L9_2 = L6_2(L7_2)
  for L10_2, L11_2 in L6_2, L7_2, L8_2, L9_2 do
    L12_2 = #L5_2
    L12_2 = L12_2 + 1
    L13_2 = {}
    L14_2 = L1_1
    L15_2 = L11_2.id
    L14_2 = L14_2(L15_2)
    L13_2.id = L14_2
    L14_2 = L11_2.title
    L13_2.title = L14_2
    L14_2 = L1_1
    L15_2 = L11_2.avatar
    L14_2 = L14_2(L15_2)
    L13_2.avatar = L14_2
    L14_2 = math
    L14_2 = L14_2.tointeger
    L15_2 = tonumber
    L16_2 = L11_2.members
    L15_2 = L15_2(L16_2)
    if not L15_2 then
      L15_2 = 0
    end
    L14_2 = L14_2(L15_2)
    if not L14_2 then
      L14_2 = 0
    end
    L13_2.memberCount = L14_2
    L5_2[L12_2] = L13_2
  end
  return L5_2
end
L91_1(L92_1, L93_1)
function L91_1(A0_2, A1_2, A2_2)
  local L3_2, L4_2, L5_2, L6_2, L7_2, L8_2
  L3_2 = type
  L4_2 = RPC
  L4_2 = L4_2["groups.leave"]
  L3_2 = L3_2(L4_2)
  if "function" == L3_2 then
    L3_2 = pcall
    L4_2 = RPC
    L4_2 = L4_2["groups.leave"]
    L5_2 = A0_2
    L6_2 = {}
    L6_2.id = A1_2
    L3_2, L4_2 = L3_2(L4_2, L5_2, L6_2)
    if L3_2 then
      L5_2 = type
      L6_2 = L4_2
      L5_2 = L5_2(L6_2)
      if "table" == L5_2 then
        L5_2 = L4_2.ok
        if L5_2 then
          L5_2 = true
          return L5_2
        end
      end
    end
  end
  L3_2 = MySQL
  L3_2 = L3_2.update
  L3_2 = L3_2.await
  L4_2 = "UPDATE apex_phone_conversation_members SET left_at = ?, role = 'member' WHERE conversation_id = ? AND member = ? AND left_at IS NULL"
  L5_2 = {}
  L6_2 = Now
  L6_2 = L6_2()
  L7_2 = A1_2
  L8_2 = A2_2
  L5_2[1] = L6_2
  L5_2[2] = L7_2
  L5_2[3] = L8_2
  L3_2(L4_2, L5_2)
  L3_2 = true
  return L3_2
end
function L92_1(A0_2)
  local L1_2, L2_2, L3_2, L4_2, L5_2, L6_2
  L1_2 = pcall
  L2_2 = MySQL
  L2_2 = L2_2.update
  L2_2 = L2_2.await
  L3_2 = "UPDATE apex_phone_conversations SET community_id = NULL WHERE community_id = ? AND id <> ?"
  L4_2 = {}
  L5_2 = A0_2.id
  L6_2 = A0_2.announce_id
  if not L6_2 then
    L6_2 = 0
  end
  L4_2[1] = L5_2
  L4_2[2] = L6_2
  L1_2(L2_2, L3_2, L4_2)
  L1_2 = A0_2.announce_id
  if L1_2 then
    L1_2 = pcall
    L2_2 = MySQL
    L2_2 = L2_2.update
    L2_2 = L2_2.await
    L3_2 = "DELETE r FROM apex_phone_message_reactions r JOIN apex_phone_messages m ON m.id = r.message_id WHERE m.conversation_id = ?"
    L4_2 = {}
    L5_2 = A0_2.announce_id
    L4_2[1] = L5_2
    L1_2(L2_2, L3_2, L4_2)
    L1_2 = MySQL
    L1_2 = L1_2.update
    L1_2 = L1_2.await
    L2_2 = "DELETE FROM apex_phone_messages WHERE conversation_id = ?"
    L3_2 = {}
    L4_2 = A0_2.announce_id
    L3_2[1] = L4_2
    L1_2(L2_2, L3_2)
    L1_2 = pcall
    L2_2 = MySQL
    L2_2 = L2_2.update
    L2_2 = L2_2.await
    L3_2 = "DELETE FROM apex_phone_thread_meta WHERE app = 'recado' AND other = ?"
    L4_2 = {}
    L5_2 = "g:"
    L6_2 = A0_2.announce_id
    L5_2 = L5_2 .. L6_2
    L4_2[1] = L5_2
    L1_2(L2_2, L3_2, L4_2)
    L1_2 = MySQL
    L1_2 = L1_2.update
    L1_2 = L1_2.await
    L2_2 = "DELETE FROM apex_phone_conversation_members WHERE conversation_id = ?"
    L3_2 = {}
    L4_2 = A0_2.announce_id
    L3_2[1] = L4_2
    L1_2(L2_2, L3_2)
    L1_2 = MySQL
    L1_2 = L1_2.update
    L1_2 = L1_2.await
    L2_2 = "DELETE FROM apex_phone_conversations WHERE id = ?"
    L3_2 = {}
    L4_2 = A0_2.announce_id
    L3_2[1] = L4_2
    L1_2(L2_2, L3_2)
  end
  L1_2 = MySQL
  L1_2 = L1_2.update
  L1_2 = L1_2.await
  L2_2 = "DELETE FROM apex_phone_recado_communities WHERE id = ?"
  L3_2 = {}
  L4_2 = A0_2.id
  L3_2[1] = L4_2
  L1_2(L2_2, L3_2)
  L2_2 = A0_2.id
  L1_2 = L84_1
  L1_2[L2_2] = nil
end
L93_1 = L36_1
L94_1 = "recado.community.leave"
function L95_1(A0_2, A1_2, A2_2)
  local L3_2, L4_2, L5_2, L6_2
  L3_2 = L1_1
  L4_2 = A1_2.id
  L3_2 = L3_2(L4_2)
  if not L3_2 then
    L4_2 = L3_1
    L5_2 = "invalid"
    return L4_2(L5_2)
  end
  L4_2 = L21_1
  L5_2 = "cm:"
  L6_2 = L3_2
  L5_2 = L5_2 .. L6_2
  function L6_2()
    local L0_3, L1_3, L2_3, L3_3, L4_3, L5_3, L6_3, L7_3, L8_3, L9_3, L10_3, L11_3, L12_3
    L0_3 = L81_1
    L1_3 = L3_2
    L0_3 = L0_3(L1_3)
    if not L0_3 then
      L1_3 = L3_1
      L2_3 = "notfound"
      return L1_3(L2_3)
    end
    L1_3 = L82_1
    L2_3 = L0_3
    L3_3 = A2_2
    L1_3 = L1_3(L2_3, L3_3)
    if not L1_3 then
      L1_3 = L3_1
      L2_3 = "notfound"
      return L1_3(L2_3)
    end
    L1_3 = pcall
    L2_3 = MySQL
    L2_3 = L2_3.query
    L2_3 = L2_3.await
    L3_3 = [[
SELECT g.id FROM apex_phone_conversations g JOIN apex_phone_conversation_members m ON m.conversation_id = g.id AND m.member = ? AND m.left_at IS NULL
            WHERE g.community_id = ? AND g.id <> ?]]
    L4_3 = {}
    L5_3 = A2_2
    L6_3 = L3_2
    L7_3 = L0_3.announce_id
    if not L7_3 then
      L7_3 = 0
    end
    L4_3[1] = L5_3
    L4_3[2] = L6_3
    L4_3[3] = L7_3
    L1_3, L2_3 = L1_3(L2_3, L3_3, L4_3)
    L3_3 = ipairs
    L4_3 = L2_3 or L4_3
    if not L1_3 or not L2_3 then
      L4_3 = {}
    end
    L3_3, L4_3, L5_3, L6_3 = L3_3(L4_3)
    for L7_3, L8_3 in L3_3, L4_3, L5_3, L6_3 do
      L9_3 = L91_1
      L10_3 = A0_2
      L11_3 = L1_1
      L12_3 = L8_3.id
      L11_3 = L11_3(L12_3)
      L12_3 = A2_2
      L9_3(L10_3, L11_3, L12_3)
    end
    L3_3 = L0_3.announce_id
    if L3_3 then
      L3_3 = MySQL
      L3_3 = L3_3.update
      L3_3 = L3_3.await
      L4_3 = "UPDATE apex_phone_conversation_members SET left_at = ?, role = 'member' WHERE conversation_id = ? AND member = ? AND left_at IS NULL"
      L5_3 = {}
      L6_3 = Now
      L6_3 = L6_3()
      L7_3 = L0_3.announce_id
      L8_3 = A2_2
      L5_3[1] = L6_3
      L5_3[2] = L7_3
      L5_3[3] = L8_3
      L3_3(L4_3, L5_3)
      L3_3 = MySQL
      L3_3 = L3_3.query
      L3_3 = L3_3.await
      L4_3 = "SELECT member, role FROM apex_phone_conversation_members WHERE conversation_id = ? AND left_at IS NULL ORDER BY joined ASC, member ASC"
      L5_3 = {}
      L6_3 = L0_3.announce_id
      L5_3[1] = L6_3
      L3_3 = L3_3(L4_3, L5_3)
      if not L3_3 then
        L3_3 = {}
      end
      L4_3 = #L3_3
      if 0 == L4_3 then
        L4_3 = L92_1
        L5_3 = L0_3
        L4_3(L5_3)
        L4_3 = L27_1
        L4_3()
        L4_3 = {}
        L4_3.ok = true
        L5_3 = L3_2
        L4_3.id = L5_3
        L4_3.deleted = true
        return L4_3
      end
      L4_3 = false
      L5_3 = ipairs
      L6_3 = L3_3
      L5_3, L6_3, L7_3, L8_3 = L5_3(L6_3)
      for L9_3, L10_3 in L5_3, L6_3, L7_3, L8_3 do
        L11_3 = L10_3.role
        if "admin" == L11_3 then
          L4_3 = true
          break
        end
      end
      if not L4_3 then
        L5_3 = MySQL
        L5_3 = L5_3.update
        L5_3 = L5_3.await
        L6_3 = "UPDATE apex_phone_conversation_members SET role = 'admin' WHERE conversation_id = ? AND member = ?"
        L7_3 = {}
        L8_3 = L0_3.announce_id
        L9_3 = tostring
        L10_3 = L3_3[1]
        L10_3 = L10_3.member
        L9_3, L10_3, L11_3, L12_3 = L9_3(L10_3)
        L7_3[1] = L8_3
        L7_3[2] = L9_3
        L7_3[3] = L10_3
        L7_3[4] = L11_3
        L7_3[5] = L12_3
        L5_3(L6_3, L7_3)
      end
    end
    L3_3 = L87_1
    L4_3 = L0_3
    L5_3 = {}
    L6_3 = L3_2
    L5_3.id = L6_3
    L5_3.action = "leave"
    L6_3 = A2_2
    L5_3.by = L6_3
    L3_3(L4_3, L5_3)
    L3_3 = tonumber
    L4_3 = A0_2
    L3_3 = L3_3(L4_3)
    L4_3 = L24_1
    L4_3[L3_3] = nil
    L3_3 = {}
    L3_3.ok = true
    L4_3 = L3_2
    L3_3.id = L4_3
    L3_3.left = true
    return L3_3
  end
  return L4_2(L5_2, L6_2)
end
L93_1(L94_1, L95_1)
L93_1 = L36_1
L94_1 = "recado.community.delete"
function L95_1(A0_2, A1_2, A2_2)
  local L3_2, L4_2, L5_2, L6_2
  L3_2 = L1_1
  L4_2 = A1_2.id
  L3_2 = L3_2(L4_2)
  if not L3_2 then
    L4_2 = L3_1
    L5_2 = "invalid"
    return L4_2(L5_2)
  end
  L4_2 = L21_1
  L5_2 = "cm:"
  L6_2 = L3_2
  L5_2 = L5_2 .. L6_2
  function L6_2()
    local L0_3, L1_3, L2_3, L3_3, L4_3
    L0_3 = L81_1
    L1_3 = L3_2
    L0_3 = L0_3(L1_3)
    if not L0_3 then
      L1_3 = L3_1
      L2_3 = "notfound"
      return L1_3(L2_3)
    end
    L1_3 = L0_3.owner
    L2_3 = A2_2
    if L1_3 ~= L2_3 then
      L1_3 = L3_1
      L2_3 = "notowner"
      return L1_3(L2_3)
    end
    L1_3 = L87_1
    L2_3 = L0_3
    L3_3 = {}
    L4_3 = L3_2
    L3_3.id = L4_3
    L3_3.action = "delete"
    L1_3(L2_3, L3_3)
    L1_3 = L92_1
    L2_3 = L0_3
    L1_3(L2_3)
    L1_3 = L27_1
    L1_3()
    L1_3 = {}
    L1_3.ok = true
    L2_3 = L3_2
    L1_3.id = L2_3
    L1_3.deleted = true
    return L1_3
  end
  return L4_2(L5_2, L6_2)
end
L93_1(L94_1, L95_1)
function L93_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2, L19_2, L20_2, L21_2, L22_2, L23_2, L24_2, L25_2, L26_2
  L2_2 = tonumber
  L3_2 = A0_2
  L2_2 = L2_2(L3_2)
  A0_2 = L2_2
  L2_2 = L1_1
  L3_2 = A1_2
  L2_2 = L2_2(L3_2)
  if A0_2 and L2_2 then
    L3_2 = type
    L4_2 = MediaInfo
    L3_2 = L3_2(L4_2)
    if "function" == L3_2 then
      goto lbl_19
    end
  end
  L3_2 = false
  do return L3_2 end
  ::lbl_19::
  L3_2 = L16_1
  L4_2 = A0_2
  L3_2, L4_2 = L3_2(L4_2)
  if not L3_2 then
    L5_2 = false
    return L5_2
  end
  L5_2 = L24_1
  L5_2 = L5_2[A0_2]
  L6_2 = GetGameTimer
  L6_2 = L6_2()
  if L5_2 then
    L7_2 = L5_2.cid
    if L7_2 == L4_2 then
      L7_2 = L5_2.ids
      L7_2 = L7_2[L2_2]
      if not L7_2 then
        L7_2 = 0
      end
      if L6_2 < L7_2 then
        L7_2 = true
        return L7_2
      end
    end
  end
  L7_2 = MediaInfo
  L8_2 = L2_2
  L7_2 = L7_2(L8_2)
  if L7_2 then
    L8_2 = L7_2.complete
    if L8_2 then
      goto lbl_54
    end
  end
  L8_2 = false
  do return L8_2 end
  ::lbl_54::
  L8_2 = tostring
  L9_2 = L7_2.owner
  L8_2 = L8_2(L9_2)
  L8_2 = L8_2 == L4_2
  if not L8_2 then
    L9_2 = pcall
    L10_2 = MySQL
    L10_2 = L10_2.query
    L10_2 = L10_2.await
    L11_2 = L41_1
    L12_2 = " WHERE media_id = ? AND expires > ? LIMIT 20"
    L11_2 = L11_2 .. L12_2
    L12_2 = {}
    L13_2 = L2_2
    L14_2 = Now
    L14_2, L15_2, L16_2, L17_2, L18_2, L19_2, L20_2, L21_2, L22_2, L23_2, L24_2, L25_2, L26_2 = L14_2()
    L12_2[1] = L13_2
    L12_2[2] = L14_2
    L12_2[3] = L15_2
    L12_2[4] = L16_2
    L12_2[5] = L17_2
    L12_2[6] = L18_2
    L12_2[7] = L19_2
    L12_2[8] = L20_2
    L12_2[9] = L21_2
    L12_2[10] = L22_2
    L12_2[11] = L23_2
    L12_2[12] = L24_2
    L12_2[13] = L25_2
    L12_2[14] = L26_2
    L9_2, L10_2 = L9_2(L10_2, L11_2, L12_2)
    L11_2 = ipairs
    L12_2 = L10_2 or L12_2
    if not L9_2 or not L10_2 then
      L12_2 = {}
    end
    L11_2, L12_2, L13_2, L14_2 = L11_2(L12_2)
    for L15_2, L16_2 in L11_2, L12_2, L13_2, L14_2 do
      L17_2 = L50_1
      L18_2 = L44_1
      L19_2 = L16_2
      L18_2 = L18_2(L19_2)
      L19_2 = L3_2
      L20_2 = L4_2
      L17_2 = L17_2(L18_2, L19_2, L20_2)
      if L17_2 then
        L8_2 = true
        break
      end
    end
  end
  if not L8_2 then
    L9_2 = pcall
    L10_2 = MySQL
    L10_2 = L10_2.query
    L10_2 = L10_2.await
    L11_2 = "SELECT DISTINCT channel_id FROM apex_phone_recado_channel_posts WHERE media_id = ? LIMIT 20"
    L12_2 = {}
    L13_2 = L2_2
    L12_2[1] = L13_2
    L9_2, L10_2 = L9_2(L10_2, L11_2, L12_2)
    L11_2 = pcall
    L12_2 = MySQL
    L12_2 = L12_2.query
    L12_2 = L12_2.await
    L13_2 = "SELECT id FROM apex_phone_recado_channels WHERE avatar = ? LIMIT 20"
    L14_2 = {}
    L15_2 = L2_2
    L14_2[1] = L15_2
    L11_2, L12_2 = L11_2(L12_2, L13_2, L14_2)
    L13_2 = {}
    L14_2 = ipairs
    L15_2 = L10_2 or L15_2
    if not L9_2 or not L10_2 then
      L15_2 = {}
    end
    L14_2, L15_2, L16_2, L17_2 = L14_2(L15_2)
    for L18_2, L19_2 in L14_2, L15_2, L16_2, L17_2 do
      L20_2 = #L13_2
      L20_2 = L20_2 + 1
      L21_2 = math
      L21_2 = L21_2.tointeger
      L22_2 = tonumber
      L23_2 = L19_2.channel_id
      L22_2, L23_2, L24_2, L25_2, L26_2 = L22_2(L23_2)
      L21_2 = L21_2(L22_2, L23_2, L24_2, L25_2, L26_2)
      L13_2[L20_2] = L21_2
    end
    L14_2 = ipairs
    L15_2 = L12_2 or L15_2
    if not L11_2 or not L12_2 then
      L15_2 = {}
    end
    L14_2, L15_2, L16_2, L17_2 = L14_2(L15_2)
    for L18_2, L19_2 in L14_2, L15_2, L16_2, L17_2 do
      L20_2 = #L13_2
      L20_2 = L20_2 + 1
      L21_2 = math
      L21_2 = L21_2.tointeger
      L22_2 = tonumber
      L23_2 = L19_2.id
      L22_2, L23_2, L24_2, L25_2, L26_2 = L22_2(L23_2)
      L21_2 = L21_2(L22_2, L23_2, L24_2, L25_2, L26_2)
      L13_2[L20_2] = L21_2
    end
    L14_2 = ipairs
    L15_2 = L13_2
    L14_2, L15_2, L16_2, L17_2 = L14_2(L15_2)
    for L18_2, L19_2 in L14_2, L15_2, L16_2, L17_2 do
      L20_2 = L19_2 or L20_2
      if L19_2 then
        L20_2 = L65_1
        L21_2 = L19_2
        L20_2 = L20_2(L21_2)
      end
      if L20_2 then
        L21_2 = L68_1
        L22_2 = L20_2
        L23_2 = L66_1
        L24_2 = L20_2.id
        L25_2 = L3_2
        L23_2 = L23_2(L24_2, L25_2)
        L24_2 = L67_1
        L25_2 = L20_2.id
        L26_2 = L3_2
        L24_2, L25_2, L26_2 = L24_2(L25_2, L26_2)
        L21_2 = L21_2(L22_2, L23_2, L24_2, L25_2, L26_2)
        if L21_2 then
          L8_2 = true
          break
        end
      end
    end
  end
  if not L8_2 then
    L9_2 = pcall
    L10_2 = MySQL
    L10_2 = L10_2.query
    L10_2 = L10_2.await
    L11_2 = "SELECT id FROM apex_phone_recado_communities WHERE avatar = ? LIMIT 20"
    L12_2 = {}
    L13_2 = L2_2
    L12_2[1] = L13_2
    L9_2, L10_2 = L9_2(L10_2, L11_2, L12_2)
    L11_2 = ipairs
    L12_2 = L10_2 or L12_2
    if not L9_2 or not L10_2 then
      L12_2 = {}
    end
    L11_2, L12_2, L13_2, L14_2 = L11_2(L12_2)
    for L15_2, L16_2 in L11_2, L12_2, L13_2, L14_2 do
      L17_2 = L81_1
      L18_2 = math
      L18_2 = L18_2.tointeger
      L19_2 = tonumber
      L20_2 = L16_2.id
      L19_2, L20_2, L21_2, L22_2, L23_2, L24_2, L25_2, L26_2 = L19_2(L20_2)
      L18_2, L19_2, L20_2, L21_2, L22_2, L23_2, L24_2, L25_2, L26_2 = L18_2(L19_2, L20_2, L21_2, L22_2, L23_2, L24_2, L25_2, L26_2)
      L17_2 = L17_2(L18_2, L19_2, L20_2, L21_2, L22_2, L23_2, L24_2, L25_2, L26_2)
      if L17_2 then
        L18_2 = L82_1
        L19_2 = L17_2
        L20_2 = L3_2
        L18_2 = L18_2(L19_2, L20_2)
        if L18_2 then
          L8_2 = true
          break
        end
      end
    end
  end
  if L8_2 then
    if L5_2 then
      L9_2 = L5_2.cid
      if L9_2 == L4_2 then
        goto lbl_255
      end
    end
    L9_2 = {}
    L9_2.cid = L4_2
    L10_2 = {}
    L9_2.ids = L10_2
    L5_2 = L9_2
    L9_2 = L24_1
    L9_2[A0_2] = L5_2
    ::lbl_255::
    L9_2 = L5_2.ids
    L10_2 = L25_1
    L10_2 = L6_2 + L10_2
    L9_2[L2_2] = L10_2
  end
  return L8_2
end
RecadoSocialCanSeeMedia = L93_1
function L93_1(A0_2)
  local L1_2, L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2, L19_2, L20_2, L21_2, L22_2, L23_2
  L1_2 = type
  L2_2 = A0_2
  L1_2 = L1_2(L2_2)
  if "table" == L1_2 then
    L1_2 = next
    L2_2 = A0_2
    L1_2 = L1_2(L2_2)
    if nil ~= L1_2 then
      goto lbl_12
    end
  end
  do return A0_2 end
  ::lbl_12::
  L1_2 = {}
  L2_2 = pairs
  L3_2 = A0_2
  L2_2, L3_2, L4_2, L5_2 = L2_2(L3_2)
  for L6_2 in L2_2, L3_2, L4_2, L5_2 do
    L7_2 = #L1_2
    L7_2 = L7_2 + 1
    L1_2[L7_2] = L6_2
  end
  L2_2 = 1
  L3_2 = #L1_2
  L4_2 = 500
  for L5_2 = L2_2, L3_2, L4_2 do
    L6_2 = {}
    L7_2 = L5_2
    L8_2 = math
    L8_2 = L8_2.min
    L9_2 = #L1_2
    L10_2 = L5_2 + 499
    L8_2 = L8_2(L9_2, L10_2)
    L9_2 = 1
    for L10_2 = L7_2, L8_2, L9_2 do
      L11_2 = #L6_2
      L11_2 = L11_2 + 1
      L12_2 = L1_2[L10_2]
      L6_2[L11_2] = L12_2
    end
    L7_2 = L2_1
    L8_2 = #L6_2
    L7_2 = L7_2(L8_2)
    L8_2 = ipairs
    L9_2 = {}
    L10_2 = "SELECT media_id AS m FROM apex_phone_recado_status WHERE media_id IN (%s)"
    L11_2 = L10_2
    L10_2 = L10_2.format
    L12_2 = L7_2
    L10_2 = L10_2(L11_2, L12_2)
    L11_2 = "SELECT media_id AS m FROM apex_phone_recado_channel_posts WHERE media_id IN (%s)"
    L12_2 = L11_2
    L11_2 = L11_2.format
    L13_2 = L7_2
    L11_2 = L11_2(L12_2, L13_2)
    L12_2 = "SELECT avatar AS m FROM apex_phone_recado_channels WHERE avatar IN (%s)"
    L13_2 = L12_2
    L12_2 = L12_2.format
    L14_2 = L7_2
    L12_2 = L12_2(L13_2, L14_2)
    L13_2 = "SELECT avatar AS m FROM apex_phone_recado_communities WHERE avatar IN (%s)"
    L14_2 = L13_2
    L13_2 = L13_2.format
    L15_2 = L7_2
    L13_2, L14_2, L15_2, L16_2, L17_2, L18_2, L19_2, L20_2, L21_2, L22_2, L23_2 = L13_2(L14_2, L15_2)
    L9_2[1] = L10_2
    L9_2[2] = L11_2
    L9_2[3] = L12_2
    L9_2[4] = L13_2
    L9_2[5] = L14_2
    L9_2[6] = L15_2
    L9_2[7] = L16_2
    L9_2[8] = L17_2
    L9_2[9] = L18_2
    L9_2[10] = L19_2
    L9_2[11] = L20_2
    L9_2[12] = L21_2
    L9_2[13] = L22_2
    L9_2[14] = L23_2
    L8_2, L9_2, L10_2, L11_2 = L8_2(L9_2)
    for L12_2, L13_2 in L8_2, L9_2, L10_2, L11_2 do
      L14_2 = pcall
      L15_2 = MySQL
      L15_2 = L15_2.query
      L15_2 = L15_2.await
      L16_2 = L13_2
      L17_2 = L6_2
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
            L22_2 = L1_1
            L23_2 = L21_2.m
            L22_2 = L22_2(L23_2)
            if L22_2 then
              A0_2[L22_2] = nil
            end
          end
        end
      end
    end
  end
  return A0_2
end
RecadoSocialMediaRefs = L93_1
L93_1 = L36_1
L94_1 = "recado.social.media"
function L95_1(A0_2, A1_2, A2_2, A3_2)
  local L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2
  L4_2 = L1_1
  L5_2 = A1_2.id
  L4_2 = L4_2(L5_2)
  if not L4_2 then
    L5_2 = L3_1
    L6_2 = "notfound"
    return L5_2(L6_2)
  end
  L5_2 = math
  L5_2 = L5_2.tointeger
  L6_2 = tonumber
  L7_2 = A1_2.i
  L6_2 = L6_2(L7_2)
  if not L6_2 then
    L6_2 = 1
  end
  L5_2 = L5_2(L6_2)
  if L5_2 and not (L5_2 < 1) then
    L6_2 = 512
    if not (L5_2 > L6_2) then
      goto lbl_30
    end
  end
  L6_2 = L3_1
  L7_2 = "badchunk"
  do return L6_2(L7_2) end
  ::lbl_30::
  L6_2 = RecadoSocialCanSeeMedia
  L7_2 = A0_2
  L8_2 = L4_2
  L6_2 = L6_2(L7_2, L8_2)
  if not L6_2 then
    L6_2 = L3_1
    L7_2 = "notfound"
    return L6_2(L7_2)
  end
  L6_2 = MediaInfo
  L7_2 = L4_2
  L6_2 = L6_2(L7_2)
  L7_2 = type
  L8_2 = Config
  L8_2 = L8_2.Media
  L7_2 = L7_2(L8_2)
  if "table" == L7_2 then
    L7_2 = Config
    L7_2 = L7_2.Media
    if L7_2 then
      goto lbl_55
    end
  end
  L7_2 = {}
  ::lbl_55::
  L8_2 = math
  L8_2 = L8_2.tointeger
  L9_2 = math
  L9_2 = L9_2.floor
  L10_2 = tonumber
  L11_2 = L7_2.chunkBytes
  L10_2 = L10_2(L11_2)
  if not L10_2 then
    L10_2 = 48000
  end
  L9_2, L10_2, L11_2, L12_2, L13_2, L14_2 = L9_2(L10_2)
  L8_2 = L8_2(L9_2, L10_2, L11_2, L12_2, L13_2, L14_2)
  if not L8_2 then
    L8_2 = 48000
  end
  L9_2 = 4000
  if L8_2 < L9_2 then
    L8_2 = 4000
  else
    L9_2 = 64000
    if L8_2 > L9_2 then
      L8_2 = 64000
    end
  end
  L9_2 = MySQL
  L9_2 = L9_2.single
  L9_2 = L9_2.await
  L10_2 = "SELECT CHAR_LENGTH(data) AS len, SUBSTRING(data, ?, ?) AS part FROM apex_phone_media WHERE id = ? AND complete = 1"
  L11_2 = {}
  L12_2 = L5_2 - 1
  L12_2 = L12_2 * L8_2
  L12_2 = L12_2 + 1
  L13_2 = L8_2
  L14_2 = L4_2
  L11_2[1] = L12_2
  L11_2[2] = L13_2
  L11_2[3] = L14_2
  L9_2 = L9_2(L10_2, L11_2)
  if not L9_2 then
    L10_2 = L3_1
    L11_2 = "notfound"
    return L10_2(L11_2)
  end
  L10_2 = math
  L10_2 = L10_2.tointeger
  L11_2 = tonumber
  L12_2 = L9_2.len
  L11_2 = L11_2(L12_2)
  if not L11_2 then
    L11_2 = 0
  end
  L10_2 = L10_2(L11_2)
  if not L10_2 then
    L10_2 = 0
  end
  L11_2 = math
  L11_2 = L11_2.max
  L12_2 = 1
  L13_2 = math
  L13_2 = L13_2.ceil
  L14_2 = L10_2 / L8_2
  L13_2 = L13_2(L14_2)
  L11_2 = L11_2(L12_2, L13_2)
  if L5_2 > L11_2 then
    L12_2 = L3_1
    L13_2 = "badchunk"
    L14_2 = {}
    L14_2.total = L11_2
    return L12_2(L13_2, L14_2)
  end
  L12_2 = {}
  L12_2.id = L4_2
  L13_2 = L6_2.kind
  L12_2.kind = L13_2
  L13_2 = L6_2.mime
  L12_2.mime = L13_2
  L13_2 = L6_2.duration
  L12_2.duration = L13_2
  L13_2 = L6_2.meta
  L12_2.meta = L13_2
  L12_2.i = L5_2
  L12_2.total = L11_2
  L12_2.size = L10_2
  L13_2 = L9_2.part
  if not L13_2 then
    L13_2 = ""
  end
  L12_2.data = L13_2
  return L12_2
end
L93_1(L94_1, L95_1)
function L93_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2
  if A1_2 and "" ~= A1_2 then
    L2_2 = tostring
    L3_2 = A1_2
    L2_2 = L2_2(L3_2)
    A1_2 = L2_2
    L2_2 = pcall
    L3_2 = MySQL
    L3_2 = L3_2.update
    L3_2 = L3_2.await
    L4_2 = "DELETE v FROM apex_phone_recado_status_views v JOIN apex_phone_recado_status s ON s.id = v.status_id WHERE s.owner = ?"
    L5_2 = {}
    L6_2 = A1_2
    L5_2[1] = L6_2
    L2_2(L3_2, L4_2, L5_2)
    L2_2 = pcall
    L3_2 = MySQL
    L3_2 = L3_2.update
    L3_2 = L3_2.await
    L4_2 = "DELETE FROM apex_phone_recado_status WHERE owner = ?"
    L5_2 = {}
    L6_2 = A1_2
    L5_2[1] = L6_2
    L2_2(L3_2, L4_2, L5_2)
    L2_2 = pcall
    L3_2 = MySQL
    L3_2 = L3_2.update
    L3_2 = L3_2.await
    L4_2 = "DELETE FROM apex_phone_recado_status_views WHERE viewer = ?"
    L5_2 = {}
    L6_2 = A1_2
    L5_2[1] = L6_2
    L2_2(L3_2, L4_2, L5_2)
    L2_2 = pcall
    L3_2 = MySQL
    L3_2 = L3_2.update
    L3_2 = L3_2.await
    L4_2 = "DELETE FROM apex_phone_recado_status_prefs WHERE number = ?"
    L5_2 = {}
    L6_2 = A1_2
    L5_2[1] = L6_2
    L2_2(L3_2, L4_2, L5_2)
    L2_2 = pcall
    L3_2 = MySQL
    L3_2 = L3_2.update
    L3_2 = L3_2.await
    L4_2 = "UPDATE apex_phone_recado_channels c JOIN apex_phone_recado_channel_followers f ON f.channel_id = c.id SET c.followers = GREATEST(c.followers - 1, 0) WHERE f.number = ?"
    L5_2 = {}
    L6_2 = A1_2
    L5_2[1] = L6_2
    L2_2(L3_2, L4_2, L5_2)
    L2_2 = pcall
    L3_2 = MySQL
    L3_2 = L3_2.update
    L3_2 = L3_2.await
    L4_2 = "DELETE FROM apex_phone_recado_channel_followers WHERE number = ?"
    L5_2 = {}
    L6_2 = A1_2
    L5_2[1] = L6_2
    L2_2(L3_2, L4_2, L5_2)
    L2_2 = pcall
    L3_2 = MySQL
    L3_2 = L3_2.update
    L3_2 = L3_2.await
    L4_2 = "DELETE FROM apex_phone_recado_channel_reactions WHERE number = ?"
    L5_2 = {}
    L6_2 = A1_2
    L5_2[1] = L6_2
    L2_2(L3_2, L4_2, L5_2)
    L2_2 = pcall
    L3_2 = MySQL
    L3_2 = L3_2.update
    L3_2 = L3_2.await
    L4_2 = "DELETE FROM apex_phone_recado_channel_votes WHERE number = ?"
    L5_2 = {}
    L6_2 = A1_2
    L5_2[1] = L6_2
    L2_2(L3_2, L4_2, L5_2)
    L2_2 = pcall
    L3_2 = MySQL
    L3_2 = L3_2.query
    L3_2 = L3_2.await
    L4_2 = "SELECT channel_id FROM apex_phone_recado_channel_admins WHERE number = ? AND role = 'owner'"
    L5_2 = {}
    L6_2 = A1_2
    L5_2[1] = L6_2
    L2_2, L3_2 = L2_2(L3_2, L4_2, L5_2)
    L4_2 = ipairs
    L5_2 = L3_2 or L5_2
    if not L2_2 or not L3_2 then
      L5_2 = {}
    end
    L4_2, L5_2, L6_2, L7_2 = L4_2(L5_2)
    for L8_2, L9_2 in L4_2, L5_2, L6_2, L7_2 do
      L10_2 = L1_1
      L11_2 = L9_2.channel_id
      L10_2 = L10_2(L11_2)
      if L10_2 then
        L11_2 = pcall
        L12_2 = MySQL
        L12_2 = L12_2.update
        L12_2 = L12_2.await
        L13_2 = "DELETE r FROM apex_phone_recado_channel_reactions r JOIN apex_phone_recado_channel_posts p ON p.id = r.post_id WHERE p.channel_id = ?"
        L14_2 = {}
        L15_2 = L10_2
        L14_2[1] = L15_2
        L11_2(L12_2, L13_2, L14_2)
        L11_2 = pcall
        L12_2 = MySQL
        L12_2 = L12_2.update
        L12_2 = L12_2.await
        L13_2 = "DELETE v FROM apex_phone_recado_channel_votes v JOIN apex_phone_recado_channel_posts p ON p.id = v.post_id WHERE p.channel_id = ?"
        L14_2 = {}
        L15_2 = L10_2
        L14_2[1] = L15_2
        L11_2(L12_2, L13_2, L14_2)
        L11_2 = pcall
        L12_2 = MySQL
        L12_2 = L12_2.update
        L12_2 = L12_2.await
        L13_2 = "DELETE FROM apex_phone_recado_channel_posts WHERE channel_id = ?"
        L14_2 = {}
        L15_2 = L10_2
        L14_2[1] = L15_2
        L11_2(L12_2, L13_2, L14_2)
        L11_2 = pcall
        L12_2 = MySQL
        L12_2 = L12_2.update
        L12_2 = L12_2.await
        L13_2 = "DELETE FROM apex_phone_recado_channel_followers WHERE channel_id = ?"
        L14_2 = {}
        L15_2 = L10_2
        L14_2[1] = L15_2
        L11_2(L12_2, L13_2, L14_2)
        L11_2 = pcall
        L12_2 = MySQL
        L12_2 = L12_2.update
        L12_2 = L12_2.await
        L13_2 = "DELETE FROM apex_phone_recado_channel_admins WHERE channel_id = ?"
        L14_2 = {}
        L15_2 = L10_2
        L14_2[1] = L15_2
        L11_2(L12_2, L13_2, L14_2)
        L11_2 = pcall
        L12_2 = MySQL
        L12_2 = L12_2.update
        L12_2 = L12_2.await
        L13_2 = "DELETE FROM apex_phone_recado_channels WHERE id = ?"
        L14_2 = {}
        L15_2 = L10_2
        L14_2[1] = L15_2
        L11_2(L12_2, L13_2, L14_2)
      end
    end
    L4_2 = pcall
    L5_2 = MySQL
    L5_2 = L5_2.update
    L5_2 = L5_2.await
    L6_2 = "DELETE FROM apex_phone_recado_channel_admins WHERE number = ?"
    L7_2 = {}
    L8_2 = A1_2
    L7_2[1] = L8_2
    L4_2(L5_2, L6_2, L7_2)
    L4_2 = pcall
    L5_2 = MySQL
    L5_2 = L5_2.query
    L5_2 = L5_2.await
    L6_2 = "SELECT id FROM apex_phone_recado_communities WHERE owner = ?"
    L7_2 = {}
    L8_2 = A1_2
    L7_2[1] = L8_2
    L4_2, L5_2 = L4_2(L5_2, L6_2, L7_2)
    L6_2 = ipairs
    L7_2 = L5_2 or L7_2
    if not L4_2 or not L5_2 then
      L7_2 = {}
    end
    L6_2, L7_2, L8_2, L9_2 = L6_2(L7_2)
    for L10_2, L11_2 in L6_2, L7_2, L8_2, L9_2 do
      L12_2 = L81_1
      L13_2 = L1_1
      L14_2 = L11_2.id
      L13_2, L14_2, L15_2 = L13_2(L14_2)
      L12_2 = L12_2(L13_2, L14_2, L15_2)
      if L12_2 then
        L13_2 = pcall
        L14_2 = L92_1
        L15_2 = L12_2
        L13_2(L14_2, L15_2)
      end
    end
  end
  if A0_2 then
    L2_2 = pairs
    L3_2 = L24_1
    L2_2, L3_2, L4_2, L5_2 = L2_2(L3_2)
    for L6_2, L7_2 in L2_2, L3_2, L4_2, L5_2 do
      L8_2 = L7_2.cid
      L9_2 = tostring
      L10_2 = A0_2
      L9_2 = L9_2(L10_2)
      if L8_2 == L9_2 then
        L8_2 = L24_1
        L8_2[L6_2] = nil
      end
    end
  end
end
RecadoSocialForget = L93_1
L93_1 = AddEventHandler
L94_1 = "playerDropped"
function L95_1()
  local L0_2, L1_2, L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2
  L0_2 = tonumber
  L1_2 = source
  L0_2 = L0_2(L1_2)
  if L0_2 then
    L1_2 = L24_1
    L1_2[L0_2] = nil
    L1_2 = tostring
    L2_2 = L0_2
    L1_2 = L1_2(L2_2)
    L2_2 = "|"
    L1_2 = L1_2 .. L2_2
    L2_2 = pairs
    L3_2 = L22_1
    L2_2, L3_2, L4_2, L5_2 = L2_2(L3_2)
    for L6_2 in L2_2, L3_2, L4_2, L5_2 do
      L8_2 = L6_2
      L7_2 = L6_2.sub
      L9_2 = 1
      L10_2 = #L1_2
      L7_2 = L7_2(L8_2, L9_2, L10_2)
      if L7_2 == L1_2 then
        L7_2 = L22_1
        L7_2[L6_2] = nil
      end
    end
  end
  L1_2 = nil
  L17_1 = L1_2
end
L93_1(L94_1, L95_1)
L93_1 = FW
L93_1 = L93_1.OnPlayerLoaded
function L94_1()
  local L0_2, L1_2
  L0_2 = nil
  L17_1 = L0_2
end
L93_1(L94_1)
L93_1 = CreateThread
function L94_1()
  local L0_2, L1_2, L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2
  while true do
    L0_2 = L32_1
    if L0_2 then
      break
    end
    L0_2 = Wait
    L1_2 = 1000
    L0_2(L1_2)
  end
  L0_2 = Wait
  L1_2 = 60000
  L0_2(L1_2)
  while true do
    L0_2 = Now
    L0_2 = L0_2()
    L1_2 = pcall
    function L2_2()
      local L0_3, L1_3, L2_3, L3_3, L4_3
      L0_3 = MySQL
      L0_3 = L0_3.update
      L0_3 = L0_3.await
      L1_3 = "DELETE v FROM apex_phone_recado_status_views v JOIN apex_phone_recado_status s ON s.id = v.status_id WHERE s.expires <= ?"
      L2_3 = {}
      L3_3 = L0_2
      L2_3[1] = L3_3
      L0_3(L1_3, L2_3)
      L0_3 = tonumber
      L1_3 = MySQL
      L1_3 = L1_3.update
      L1_3 = L1_3.await
      L2_3 = "DELETE FROM apex_phone_recado_status WHERE expires <= ? LIMIT 2000"
      L3_3 = {}
      L4_3 = L0_2
      L3_3[1] = L4_3
      L1_3, L2_3, L3_3, L4_3 = L1_3(L2_3, L3_3)
      L0_3 = L0_3(L1_3, L2_3, L3_3, L4_3)
      if not L0_3 then
        L0_3 = 0
      end
      if L0_3 > 0 then
        L1_3 = Dbg
        L2_3 = "recado"
        L3_3 = "cleanup: %d expired status(es)"
        L4_3 = L0_3
        L1_3(L2_3, L3_3, L4_3)
      end
    end
    L1_2, L2_2 = L1_2(L2_2)
    if not L1_2 then
      L3_2 = print
      L4_2 = "^3[unique_phone]^0 recado_social cleanup: %s"
      L5_2 = L4_2
      L4_2 = L4_2.format
      L6_2 = tostring
      L7_2 = L2_2
      L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2 = L6_2(L7_2)
      L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2 = L4_2(L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2)
      L3_2(L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2)
    end
    L3_2 = GetGameTimer
    L3_2 = L3_2()
    L4_2 = pairs
    L5_2 = L24_1
    L4_2, L5_2, L6_2, L7_2 = L4_2(L5_2)
    for L8_2, L9_2 in L4_2, L5_2, L6_2, L7_2 do
      L10_2 = pairs
      L11_2 = L9_2.ids
      L10_2, L11_2, L12_2, L13_2 = L10_2(L11_2)
      for L14_2, L15_2 in L10_2, L11_2, L12_2, L13_2 do
        if L15_2 <= L3_2 then
          L16_2 = L9_2.ids
          L16_2[L14_2] = nil
        end
      end
      L10_2 = next
      L11_2 = L9_2.ids
      L10_2 = L10_2(L11_2)
      if nil == L10_2 then
        L10_2 = L24_1
        L10_2[L8_2] = nil
      end
    end
    L4_2 = pairs
    L5_2 = L22_1
    L4_2, L5_2, L6_2, L7_2 = L4_2(L5_2)
    for L8_2, L9_2 in L4_2, L5_2, L6_2, L7_2 do
      L10_2 = L3_2 - L9_2
      L11_2 = 60000
      if L10_2 > L11_2 then
        L10_2 = L22_1
        L10_2[L8_2] = nil
      end
    end
    L4_2 = pairs
    L5_2 = L84_1
    L4_2, L5_2, L6_2, L7_2 = L4_2(L5_2)
    for L8_2, L9_2 in L4_2, L5_2, L6_2, L7_2 do
      L10_2 = L3_2 - L9_2
      L11_2 = 600000
      if L10_2 > L11_2 then
        L10_2 = L84_1
        L10_2[L8_2] = nil
      end
    end
    L4_2 = Wait
    L5_2 = 600000
    L4_2(L5_2)
  end
end
L93_1(L94_1)
