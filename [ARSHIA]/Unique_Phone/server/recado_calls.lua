local L0_1, L1_1, L2_1, L3_1, L4_1, L5_1, L6_1, L7_1, L8_1, L9_1, L10_1, L11_1, L12_1, L13_1, L14_1, L15_1, L16_1, L17_1, L18_1, L19_1, L20_1, L21_1, L22_1, L23_1, L24_1, L25_1, L26_1, L27_1, L28_1, L29_1, L30_1, L31_1, L32_1, L33_1, L34_1, L35_1, L36_1, L37_1, L38_1, L39_1, L40_1, L41_1, L42_1, L43_1, L44_1, L45_1, L46_1, L47_1, L48_1, L49_1, L50_1, L51_1, L52_1, L53_1, L54_1, L55_1, L56_1, L57_1, L58_1, L59_1, L60_1, L61_1, L62_1, L63_1, L64_1, L65_1, L66_1, L67_1, L68_1, L69_1, L70_1, L71_1, L72_1, L73_1, L74_1, L75_1, L76_1, L77_1, L78_1, L79_1, L80_1, L81_1, L82_1, L83_1, L84_1, L85_1, L86_1
L0_1 = 900000
L1_1 = math
L1_1 = L1_1.max
L2_1 = 10
L3_1 = tonumber
L4_1 = Config
L4_1 = L4_1.CallTimeout
L3_1 = L3_1(L4_1)
if not L3_1 then
  L3_1 = 30
end
L1_1 = L1_1(L2_1, L3_1)
L1_1 = L1_1 * 1000
L2_1 = 900000
L3_1 = 21600000
L4_1 = 600000
L5_1 = 604800000
L6_1 = 10
L7_1 = 20
L8_1 = 600
L9_1 = {}
L10_1 = "\240\159\145\143"
L11_1 = "\240\159\142\137"
L12_1 = "\240\159\148\165"
L13_1 = "\240\159\145\139"
L9_1[1] = L10_1
L9_1[2] = L11_1
L9_1[3] = L12_1
L9_1[4] = L13_1
L10_1 = {}
L11_1 = {}
L12_1 = {}
L13_1 = {}
L14_1 = {}
L15_1 = {}
L16_1 = {}
L17_1 = 1
L18_1 = false
function L19_1(A0_2, ...)
  local L1_2, L2_2, L3_2, L4_2
  L1_2 = Dbg
  if L1_2 then
    L1_2 = Dbg
    L2_2 = "recado_calls"
    L3_2 = A0_2
    L4_2 = ...
    L1_2(L2_2, L3_2, L4_2)
  end
end
function L20_1(A0_2, A1_2)
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
function L21_1()
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
function L22_1()
  local L0_2, L1_2, L2_2
  L0_2 = L21_1
  L0_2 = L0_2()
  L0_2 = L0_2.calls
  L1_2 = type
  L2_2 = L0_2
  L1_2 = L1_2(L2_2)
  L1_2 = L0_2 or L1_2
  if "table" ~= L1_2 or not L0_2 then
    L1_2 = {}
  end
  return L1_2
end
function L23_1()
  local L0_2, L1_2
  L0_2 = L21_1
  L0_2 = L0_2()
  L0_2 = L0_2.enabled
  L0_2 = false ~= L0_2
  return L0_2
end
function L24_1()
  local L0_2, L1_2, L2_2, L3_2, L4_2, L5_2
  L0_2 = math
  L0_2 = L0_2.tointeger
  L1_2 = tonumber
  L2_2 = L22_1
  L2_2 = L2_2()
  L2_2 = L2_2.maxGroupParticipants
  L1_2, L2_2, L3_2, L4_2, L5_2 = L1_2(L2_2)
  L0_2 = L0_2(L1_2, L2_2, L3_2, L4_2, L5_2)
  if not L0_2 then
    L0_2 = 8
  end
  L1_2 = math
  L1_2 = L1_2.max
  L2_2 = 2
  L3_2 = math
  L3_2 = L3_2.min
  L4_2 = 32
  L5_2 = L0_2
  L3_2 = L3_2(L4_2, L5_2)
  return L1_2(L2_2, L3_2)
end
function L25_1()
  local L0_2, L1_2, L2_2, L3_2, L4_2, L5_2
  L0_2 = tonumber
  L1_2 = L22_1
  L1_2 = L1_2()
  L1_2 = L1_2.scheduledMaxDays
  L0_2 = L0_2(L1_2)
  if not L0_2 then
    L0_2 = 30
  end
  L1_2 = math
  L1_2 = L1_2.max
  L2_2 = 1
  L3_2 = math
  L3_2 = L3_2.min
  L4_2 = 365
  L5_2 = L0_2
  L3_2 = L3_2(L4_2, L5_2)
  L1_2 = L1_2(L2_2, L3_2)
  L1_2 = L1_2 * 86400000
  return L1_2
end
function L26_1()
  local L0_2, L1_2, L2_2, L3_2, L4_2
  L0_2 = L22_1
  L0_2 = L0_2()
  L0_2 = L0_2.videoProvider
  L1_2 = type
  L2_2 = L0_2
  L1_2 = L1_2(L2_2)
  if "string" == L1_2 then
    L2_2 = L0_2
    L1_2 = L0_2.sub
    L3_2 = 1
    L4_2 = 20
    L1_2 = L1_2(L2_2, L3_2, L4_2)
    if L1_2 then
      goto lbl_16
    end
  end
  L1_2 = "simulated"
  ::lbl_16::
  return L1_2
end
L27_1 = nil
L28_1 = nil
function L29_1()
  local L0_2, L1_2, L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2
  L0_2 = L27_1
  if L0_2 then
    L0_2 = L27_1
    return L0_2
  end
  L0_2 = {}
  L1_2 = {}
  L28_1 = L1_2
  L27_1 = L0_2
  L0_2 = type
  L1_2 = Config
  L1_2 = L1_2.Messages
  L0_2 = L0_2(L1_2)
  if "table" == L0_2 then
    L0_2 = Config
    L0_2 = L0_2.Messages
    L0_2 = L0_2.reactions
    if L0_2 then
      goto lbl_24
    end
  end
  L0_2 = nil
  ::lbl_24::
  L1_2 = type
  L2_2 = L0_2
  L1_2 = L1_2(L2_2)
  if "table" ~= L1_2 then
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
    L0_2 = L1_2
  end
  L1_2 = ipairs
  L2_2 = {}
  L3_2 = L0_2
  L4_2 = L9_1
  L2_2[1] = L3_2
  L2_2[2] = L4_2
  L1_2, L2_2, L3_2, L4_2 = L1_2(L2_2)
  for L5_2, L6_2 in L1_2, L2_2, L3_2, L4_2 do
    L7_2 = ipairs
    L8_2 = L6_2
    L7_2, L8_2, L9_2, L10_2 = L7_2(L8_2)
    for L11_2, L12_2 in L7_2, L8_2, L9_2, L10_2 do
      L13_2 = type
      L14_2 = L12_2
      L13_2 = L13_2(L14_2)
      if "string" == L13_2 then
        L13_2 = #L12_2
        if L13_2 <= 16 then
          L13_2 = L28_1
          L13_2 = L13_2[L12_2]
          if not L13_2 then
            L13_2 = L28_1
            L13_2[L12_2] = true
            L13_2 = L27_1
            L13_2 = #L13_2
            L14_2 = L13_2 + 1
            L13_2 = L27_1
            L13_2[L14_2] = L12_2
          end
        end
      end
    end
  end
  L1_2 = L27_1
  return L1_2
end
function L30_1(A0_2)
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
function L31_1(A0_2)
  local L1_2, L2_2, L3_2, L4_2
  L1_2 = string
  L1_2 = L1_2.rep
  L2_2 = "?"
  L3_2 = A0_2
  L4_2 = ", "
  return L1_2(L2_2, L3_2, L4_2)
end
function L32_1(A0_2, A1_2)
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
L33_1 = {}
L34_1 = "\226\128[\139-\143]"
L35_1 = "\226\128[\168-\174]"
L36_1 = "\226\129[\160-\175]"
L37_1 = "\239\187\191"
L38_1 = "\194\173"
L39_1 = "\227\133\164"
L40_1 = "\226\160\128"
L33_1[1] = L34_1
L33_1[2] = L35_1
L33_1[3] = L36_1
L33_1[4] = L37_1
L33_1[5] = L38_1
L33_1[6] = L39_1
L33_1[7] = L40_1
function L34_1(A0_2, A1_2)
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
  L2_2 = L32_1
  L3_2 = A0_2
  L4_2 = 400
  L2_2 = L2_2(L3_2, L4_2)
  L3_2 = L2_2
  L2_2 = L2_2.gsub
  L4_2 = "%c"
  L5_2 = " "
  L2_2 = L2_2(L3_2, L4_2, L5_2)
  L3_2 = ipairs
  L4_2 = L33_1
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
  L5_2 = "%s+"
  L6_2 = " "
  L3_2 = L3_2(L4_2, L5_2, L6_2)
  L4_2 = L3_2
  L3_2 = L3_2.match
  L5_2 = "^%s*(.-)%s*$"
  L3_2 = L3_2(L4_2, L5_2)
  L2_2 = L3_2
  if L2_2 and "" ~= L2_2 then
    L3_2 = utf8
    L3_2 = L3_2.len
    L4_2 = L2_2
    L3_2 = L3_2(L4_2)
    if L3_2 then
      goto lbl_53
    end
  end
  L3_2 = nil
  do return L3_2 end
  ::lbl_53::
  L3_2 = utf8
  L3_2 = L3_2.len
  L4_2 = L2_2
  L3_2 = L3_2(L4_2)
  if A1_2 < L3_2 then
    L4_2 = L2_2
    L3_2 = L2_2.sub
    L5_2 = 1
    L6_2 = utf8
    L6_2 = L6_2.offset
    L7_2 = L2_2
    L8_2 = A1_2 + 1
    L6_2 = L6_2(L7_2, L8_2)
    L6_2 = L6_2 - 1
    L3_2 = L3_2(L4_2, L5_2, L6_2)
    L2_2 = L3_2
  end
  return L2_2
end
function L35_1(A0_2)
  local L1_2, L2_2, L3_2, L4_2
  L1_2 = type
  L2_2 = A0_2
  L1_2 = L1_2(L2_2)
  if "number" == L1_2 then
    L1_2 = math
    L1_2 = L1_2.tointeger
    L2_2 = A0_2
    L1_2 = L1_2(L2_2)
    if L1_2 then
      L2_2 = tostring
      L3_2 = L1_2
      L2_2 = L2_2(L3_2)
      if L2_2 then
        goto lbl_18
        A0_2 = L2_2 or A0_2
      end
    end
    A0_2 = nil
  end
  ::lbl_18::
  L1_2 = type
  L2_2 = A0_2
  L1_2 = L1_2(L2_2)
  if "string" ~= L1_2 then
    L1_2 = nil
    return L1_2
  end
  L2_2 = A0_2
  L1_2 = A0_2.match
  L3_2 = "^%s*(.-)%s*$"
  L1_2 = L1_2(L2_2, L3_2)
  if L1_2 and "" ~= L1_2 then
    L2_2 = #L1_2
    if not (L2_2 > 20) then
      L3_2 = L1_2
      L2_2 = L1_2.match
      L4_2 = "^[%w%+%-%s#%*%.%(%)]+$"
      L2_2 = L2_2(L3_2, L4_2)
      if L2_2 then
        goto lbl_42
      end
    end
  end
  L2_2 = nil
  do return L2_2 end
  ::lbl_42::
  return L1_2
end
L36_1 = "ABCDEFGHJKLMNPQRSTUVWXYZ23456789"
function L37_1(A0_2)
  local L1_2, L2_2, L3_2, L4_2, L5_2
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
  L4_2 = 80
  L1_2 = L1_2(L2_2, L3_2, L4_2)
  L2_2 = L1_2
  L1_2 = L1_2.match
  L3_2 = "([%w%-]+)%s*$"
  L1_2 = L1_2(L2_2, L3_2)
  if not L1_2 then
    L2_2 = nil
    return L2_2
  end
  L3_2 = L1_2
  L2_2 = L1_2.gsub
  L4_2 = "%-"
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
        goto lbl_39
      end
    end
  end
  L2_2 = nil
  do return L2_2 end
  ::lbl_39::
  return L1_2
end
function L38_1(A0_2, ...)
  local L1_2, L2_2, L3_2, L4_2, L5_2, L6_2, L7_2
  L1_2 = type
  L2_2 = Voice
  L1_2 = L1_2(L2_2)
  if "table" == L1_2 then
    L1_2 = type
    L2_2 = Voice
    L2_2 = L2_2[A0_2]
    L1_2 = L1_2(L2_2)
    if "function" == L1_2 then
      goto lbl_15
    end
  end
  L1_2 = nil
  do return L1_2 end
  ::lbl_15::
  L1_2 = pcall
  L2_2 = Voice
  L2_2 = L2_2[A0_2]
  L3_2, L4_2, L5_2, L6_2, L7_2 = ...
  L1_2, L2_2 = L1_2(L2_2, L3_2, L4_2, L5_2, L6_2, L7_2)
  if not L1_2 then
    L3_2 = L19_1
    L4_2 = "Voice.%s failed: %s"
    L5_2 = A0_2
    L6_2 = tostring
    L7_2 = L2_2
    L6_2, L7_2 = L6_2(L7_2)
    L3_2(L4_2, L5_2, L6_2, L7_2)
    L3_2 = nil
    return L3_2
  end
  return L2_2
end
function L39_1(A0_2, ...)
  local L1_2, L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2
  L1_2 = _G
  L1_2 = L1_2[A0_2]
  L2_2 = type
  L3_2 = L1_2
  L2_2 = L2_2(L3_2)
  if "function" ~= L2_2 then
    L2_2 = nil
    return L2_2
  end
  L2_2 = pcall
  L3_2 = L1_2
  L4_2, L5_2, L6_2, L7_2, L8_2 = ...
  L2_2, L3_2 = L2_2(L3_2, L4_2, L5_2, L6_2, L7_2, L8_2)
  if not L2_2 then
    L4_2 = L19_1
    L5_2 = "%s failed: %s"
    L6_2 = A0_2
    L7_2 = tostring
    L8_2 = L3_2
    L7_2, L8_2 = L7_2(L8_2)
    L4_2(L5_2, L6_2, L7_2, L8_2)
    L4_2 = nil
    return L4_2
  end
  return L3_2
end
function L40_1(A0_2)
  local L1_2, L2_2
  L1_2 = type
  L2_2 = HasPhoneItem
  L1_2 = L1_2(L2_2)
  L1_2 = HasPhoneItem
  L2_2 = A0_2
  L1_2 = "function" ~= L1_2 or L1_2
  return L1_2
end
function L41_1(A0_2)
  local L1_2, L2_2, L3_2
  L1_2 = pcall
  function L2_2()
    local L0_3, L1_3
    L0_3 = Player
    L1_3 = A0_2
    L0_3 = L0_3(L1_3)
    L0_3 = L0_3.state
    L0_3 = L0_3.apex_inCall
    return L0_3
  end
  L1_2, L2_2 = L1_2(L2_2)
  L3_2 = L1_2 or L3_2
  L3_2 = L1_2 and nil ~= L2_2 and false ~= L2_2
  return L3_2
end
function L42_1(A0_2, A1_2)
  local L2_2, L3_2
  L2_2 = pcall
  function L3_2()
    local L0_3, L1_3, L2_3, L3_3, L4_3
    L0_3 = Player
    L1_3 = A0_2
    L0_3 = L0_3(L1_3)
    L0_3 = L0_3.state
    L1_3 = L0_3
    L0_3 = L0_3.set
    L2_3 = "apex_recadoCall"
    L3_3 = A1_2
    L4_3 = true
    L0_3(L1_3, L2_3, L3_3, L4_3)
  end
  L2_2(L3_2)
end
function L43_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2
  if not A0_2 or not A1_2 then
    L2_2 = false
    return L2_2
  end
  L2_2 = L39_1
  L3_2 = "IsBlocked"
  L4_2 = A0_2
  L5_2 = A1_2
  L2_2 = L2_2(L3_2, L4_2, L5_2)
  L3_2 = true == L2_2
  return L3_2
end
function L44_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2
  if not A0_2 or not A1_2 then
    L2_2 = false
    return L2_2
  end
  L2_2 = L39_1
  L3_2 = "IsGroupMember"
  L4_2 = A0_2
  L5_2 = A1_2
  L2_2 = L2_2(L3_2, L4_2, L5_2)
  L2_2 = true == L2_2
  return L2_2
end
function L45_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2
  L2_2 = L39_1
  L3_2 = "GroupMembership"
  L4_2 = A0_2
  L5_2 = A1_2
  L2_2 = L2_2(L3_2, L4_2, L5_2)
  L3_2 = type
  L4_2 = L2_2
  L3_2 = L3_2(L4_2)
  L3_2 = "table" == L3_2
  return L3_2
end
function L46_1(A0_2)
  local L1_2, L2_2, L3_2
  L1_2 = L39_1
  L2_2 = "GroupInfo"
  L3_2 = A0_2
  L1_2 = L1_2(L2_2, L3_2)
  L2_2 = type
  L3_2 = L1_2
  L2_2 = L2_2(L3_2)
  if "table" ~= L2_2 then
    L2_2 = type
    L3_2 = GroupInfo
    L2_2 = L2_2(L3_2)
    L2_2 = "function" ~= L2_2
    L3_2 = nil
    return L2_2, L3_2
  end
  L2_2 = L1_2.app
  L2_2 = nil == L2_2
  L3_2 = L1_2
  return L2_2, L3_2
end
function L47_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2
  L2_2 = type
  L3_2 = RecadoGroupCanSend
  L2_2 = L2_2(L3_2)
  if "function" ~= L2_2 then
    L2_2 = true
    return L2_2
  end
  L2_2 = pcall
  L3_2 = RecadoGroupCanSend
  L4_2 = A0_2
  L5_2 = A1_2
  L2_2, L3_2 = L2_2(L3_2, L4_2, L5_2)
  L4_2 = not L2_2 or false ~= L3_2
  return L4_2
end
function L48_1(A0_2)
  local L1_2, L2_2, L3_2, L4_2
  L1_2 = L39_1
  L2_2 = "RecadoProfile"
  L3_2 = A0_2
  L1_2 = L1_2(L2_2, L3_2)
  L2_2 = type
  L3_2 = L1_2
  L2_2 = L2_2(L3_2)
  if "table" == L2_2 then
    L2_2 = type
    L3_2 = L1_2.name
    L2_2 = L2_2(L3_2)
    if "string" == L2_2 then
      L2_2 = L1_2.name
      if "" ~= L2_2 then
        L2_2 = L32_1
        L3_2 = L1_2.name
        L4_2 = 60
        return L2_2(L3_2, L4_2)
      end
    end
  end
  L2_2 = nil
  return L2_2
end
function L49_1(A0_2)
  local L1_2, L2_2, L3_2, L4_2
  L1_2 = L23_1
  L1_2 = L1_2()
  if not L1_2 then
    L1_2 = nil
    L2_2 = "disabled"
    return L1_2, L2_2
  end
  L1_2 = GetPlayerNumber
  L2_2 = A0_2
  L1_2 = L1_2(L2_2)
  if nil == L1_2 or "" == L1_2 then
    L2_2 = nil
    L3_2 = "noidentity"
    return L2_2, L3_2
  end
  L2_2 = {}
  L2_2.src = A0_2
  L3_2 = tostring
  L4_2 = L1_2
  L3_2 = L3_2(L4_2)
  L2_2.number = L3_2
  L3_2 = GetCid
  L4_2 = A0_2
  L3_2 = L3_2(L4_2)
  L2_2.cid = L3_2
  return L2_2
end
function L50_1()
  local L0_2, L1_2, L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2
  L0_2 = {}
  L1_2 = ipairs
  L2_2 = FW
  L2_2 = L2_2.GetPlayers
  L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2 = L2_2()
  L1_2, L2_2, L3_2, L4_2 = L1_2(L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2)
  for L5_2, L6_2 in L1_2, L2_2, L3_2, L4_2 do
    L7_2 = tonumber
    L8_2 = L6_2
    L7_2 = L7_2(L8_2)
    L8_2 = L7_2
    if L7_2 then
      L8_2 = GetPlayerNumber
      L9_2 = L7_2
      L8_2 = L8_2(L9_2)
    end
    if nil ~= L8_2 and "" ~= L8_2 then
      L9_2 = tostring
      L10_2 = L8_2
      L9_2 = L9_2(L10_2)
      L0_2[L9_2] = L7_2
    end
  end
  return L0_2
end
function L51_1(A0_2)
  local L1_2, L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2
  L1_2 = 0
  L2_2 = pairs
  L3_2 = A0_2
  L2_2, L3_2, L4_2, L5_2 = L2_2(L3_2)
  for L6_2 in L2_2, L3_2, L4_2, L5_2 do
    L1_2 = L1_2 + 1
  end
  return L1_2
end
L52_1 = "CREATE TABLE IF NOT EXISTS `apex_phone_recado_call_history` (`id` INT AUTO_INCREMENT PRIMARY KEY, `owner` VARCHAR(64) NOT NULL, `call_id` INT NULL, `kind` VARCHAR(10) NOT NULL DEFAULT 'group', `conversation` INT NULL, `title` VARCHAR(60) NULL, `video` TINYINT NOT NULL DEFAULT 0, `direction` VARCHAR(4) NOT NULL DEFAULT 'in', `status` VARCHAR(12) NOT NULL DEFAULT 'answered', `participants` VARCHAR(400) NULL, `duration` INT NOT NULL DEFAULT 0, `created` BIGINT NOT NULL, KEY `owner_created` (`owner`, `created`)) DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci"
L53_1 = "CREATE TABLE IF NOT EXISTS `apex_phone_recado_call_scheduled` (`id` INT AUTO_INCREMENT PRIMARY KEY, `code` VARCHAR(12) NOT NULL, `owner` VARCHAR(64) NOT NULL, `owner_number` VARCHAR(20) NOT NULL, `conversation` INT NULL, `number` VARCHAR(20) NULL, `title` VARCHAR(60) NOT NULL, `video` TINYINT NOT NULL DEFAULT 0, `start` BIGINT NOT NULL, `reminded` TINYINT NOT NULL DEFAULT 0, `cancelled` TINYINT NOT NULL DEFAULT 0, `message_id` INT NULL, `created` BIGINT NOT NULL, UNIQUE KEY `code` (`code`), KEY `start` (`start`), KEY `owner` (`owner`)) DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci"
L54_1 = "CREATE TABLE IF NOT EXISTS `apex_phone_recado_call_links` (`code` VARCHAR(12) NOT NULL PRIMARY KEY, `owner` VARCHAR(64) NOT NULL, `owner_number` VARCHAR(20) NOT NULL, `title` VARCHAR(60) NOT NULL, `video` TINYINT NOT NULL DEFAULT 0, `revoked` TINYINT NOT NULL DEFAULT 0, `created` BIGINT NOT NULL, `expires` BIGINT NOT NULL, KEY `owner` (`owner`)) DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci"
function L55_1()
  local L0_2, L1_2, L2_2
  L0_2 = L18_1
  if not L0_2 then
    return
  end
  L0_2 = Now
  L0_2 = L0_2()
  L1_2 = pcall
  function L2_2()
    local L0_3, L1_3, L2_3, L3_3
    L0_3 = MySQL
    L0_3 = L0_3.query
    L0_3 = L0_3.await
    L1_3 = "DELETE FROM apex_phone_recado_call_history WHERE created < ?"
    L2_3 = {}
    L3_3 = L0_2
    L3_3 = L3_3 - 7776000000
    L2_3[1] = L3_3
    L0_3(L1_3, L2_3)
    L0_3 = MySQL
    L0_3 = L0_3.query
    L0_3 = L0_3.await
    L1_3 = "DELETE FROM apex_phone_recado_call_scheduled WHERE `start` < ?"
    L2_3 = {}
    L3_3 = L0_2
    L3_3 = L3_3 - 604800000
    L2_3[1] = L3_3
    L0_3(L1_3, L2_3)
    L0_3 = MySQL
    L0_3 = L0_3.query
    L0_3 = L0_3.await
    L1_3 = "DELETE FROM apex_phone_recado_call_links WHERE expires < ?"
    L2_3 = {}
    L3_3 = L0_2
    L3_3 = L3_3 - 604800000
    L2_3[1] = L3_3
    L0_3(L1_3, L2_3)
  end
  L1_2(L2_2)
end
L56_1 = CreateThread
function L57_1()
  local L0_2, L1_2, L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2
  L0_2 = DBReady
  if nil == L0_2 then
    L0_2 = Wait
    L1_2 = 3000
    L0_2(L1_2)
  else
    L0_2 = 0
    while true do
      L1_2 = DBReady
      if L1_2 then
        break
      end
      L1_2 = 180000
      if not (L0_2 < L1_2) then
        break
      end
      L1_2 = Wait
      L2_2 = 500
      L1_2(L2_2)
      L0_2 = L0_2 + 500
    end
  end
  L0_2 = ipairs
  L1_2 = {}
  L2_2 = L52_1
  L3_2 = L53_1
  L4_2 = L54_1
  L1_2[1] = L2_2
  L1_2[2] = L3_2
  L1_2[3] = L4_2
  L0_2, L1_2, L2_2, L3_2 = L0_2(L1_2)
  for L4_2, L5_2 in L0_2, L1_2, L2_2, L3_2 do
    L6_2 = pcall
    function L7_2()
      local L0_3, L1_3
      L0_3 = MySQL
      L0_3 = L0_3.query
      L0_3 = L0_3.await
      L1_3 = L5_2
      L0_3(L1_3)
    end
    L6_2, L7_2 = L6_2(L7_2)
    if not L6_2 then
      L8_2 = print
      L9_2 = "^1[unique_phone]^0 recado: could not create %s (%s)"
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
    L8_2 = type
    L9_2 = MigrateTable
    L8_2 = L8_2(L9_2)
    if "function" == L8_2 then
      L8_2 = pcall
      L9_2 = MigrateTable
      L10_2 = L5_2
      L8_2(L9_2, L10_2)
    end
  end
  L0_2 = type
  L1_2 = EnsureIndex
  L0_2 = L0_2(L1_2)
  if "function" == L0_2 then
    L0_2 = pcall
    L1_2 = EnsureIndex
    L2_2 = "apex_phone_recado_call_history"
    L3_2 = "owner_created"
    L4_2 = {}
    L5_2 = "owner"
    L6_2 = "created"
    L4_2[1] = L5_2
    L4_2[2] = L6_2
    L0_2(L1_2, L2_2, L3_2, L4_2)
    L0_2 = pcall
    L1_2 = EnsureIndex
    L2_2 = "apex_phone_recado_call_scheduled"
    L3_2 = "code"
    L4_2 = {}
    L5_2 = "code"
    L4_2[1] = L5_2
    L5_2 = true
    L0_2(L1_2, L2_2, L3_2, L4_2, L5_2)
    L0_2 = pcall
    L1_2 = EnsureIndex
    L2_2 = "apex_phone_recado_call_scheduled"
    L3_2 = "start"
    L4_2 = {}
    L5_2 = "start"
    L4_2[1] = L5_2
    L0_2(L1_2, L2_2, L3_2, L4_2)
    L0_2 = pcall
    L1_2 = EnsureIndex
    L2_2 = "apex_phone_recado_call_scheduled"
    L3_2 = "owner"
    L4_2 = {}
    L5_2 = "owner"
    L4_2[1] = L5_2
    L0_2(L1_2, L2_2, L3_2, L4_2)
    L0_2 = pcall
    L1_2 = EnsureIndex
    L2_2 = "apex_phone_recado_call_links"
    L3_2 = "owner"
    L4_2 = {}
    L5_2 = "owner"
    L4_2[1] = L5_2
    L0_2(L1_2, L2_2, L3_2, L4_2)
  end
  L0_2 = true
  L18_1 = L0_2
  L0_2 = L55_1
  L0_2()
  while true do
    L0_2 = Wait
    L1_2 = 21600000
    L0_2(L1_2)
    L0_2 = L55_1
    L0_2()
  end
end
L56_1(L57_1)
function L56_1(A0_2)
  local L1_2, L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2
  L1_2 = {}
  L2_2 = 1
  L3_2 = A0_2
  L4_2 = 1
  for L5_2 = L2_2, L3_2, L4_2 do
    L6_2 = math
    L6_2 = L6_2.random
    L7_2 = 1
    L8_2 = L36_1
    L8_2 = #L8_2
    L6_2 = L6_2(L7_2, L8_2)
    L7_2 = L36_1
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
function L57_1()
  local L0_2, L1_2, L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2
  L0_2 = 1
  L1_2 = 20
  L2_2 = 1
  for L3_2 = L0_2, L1_2, L2_2 do
    L4_2 = L56_1
    L5_2 = 8
    L4_2 = L4_2(L5_2)
    L5_2 = L11_1
    L5_2 = L5_2[L4_2]
    if not L5_2 then
      L5_2 = false
      L6_2 = L18_1
      if L6_2 then
        L6_2 = pcall
        L7_2 = MySQL
        L7_2 = L7_2.scalar
        L7_2 = L7_2.await
        L8_2 = "SELECT (SELECT COUNT(*) FROM apex_phone_recado_call_links WHERE code = ?) + (SELECT COUNT(*) FROM apex_phone_recado_call_scheduled WHERE code = ?)"
        L9_2 = {}
        L10_2 = L4_2
        L11_2 = L4_2
        L9_2[1] = L10_2
        L9_2[2] = L11_2
        L6_2, L7_2 = L6_2(L7_2, L8_2, L9_2)
        L5_2 = not L6_2
      end
      if not L5_2 then
        return L4_2
      end
    end
  end
  L0_2 = L56_1
  L1_2 = 12
  return L0_2(L1_2)
end
function L58_1(A0_2)
  local L1_2, L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2
  L1_2 = {}
  L2_2 = ipairs
  L3_2 = A0_2.order
  L2_2, L3_2, L4_2, L5_2 = L2_2(L3_2)
  for L6_2, L7_2 in L2_2, L3_2, L4_2, L5_2 do
    L8_2 = A0_2.participants
    L8_2 = L8_2[L7_2]
    if L8_2 then
      L9_2 = #L1_2
      L9_2 = L9_2 + 1
      L1_2[L9_2] = L8_2
    end
  end
  return L1_2
end
function L59_1(A0_2, A1_2, A2_2)
  local L3_2, L4_2, L5_2
  if A2_2 then
    L3_2 = A0_2.creatorCid
    if L3_2 then
      L3_2 = A0_2.creatorCid
      if A2_2 == L3_2 then
        L3_2 = true
        return L3_2
      end
    end
  end
  L3_2 = A0_2.conversation
  if L3_2 and A1_2 then
    L3_2 = L45_1
    L4_2 = A0_2.conversation
    L5_2 = A1_2
    L3_2 = L3_2(L4_2, L5_2)
    if L3_2 then
      L3_2 = true
      return L3_2
    end
  end
  L3_2 = false
  return L3_2
end
function L60_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2
  L2_2 = A0_2.participants
  L2_2 = L2_2[A1_2]
  L3_2 = A0_2.visible
  L3_2 = L3_2[A1_2]
  if not L3_2 then
    L3_2 = {}
  end
  L4_2 = Now
  L4_2 = L4_2()
  L5_2 = {}
  L6_2 = ipairs
  L7_2 = L58_1
  L8_2 = A0_2
  L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2 = L7_2(L8_2)
  L6_2, L7_2, L8_2, L9_2 = L6_2(L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2)
  for L10_2, L11_2 in L6_2, L7_2, L8_2, L9_2 do
    L12_2 = L11_2.src
    L12_2 = L12_2 == A1_2
    L13_2 = #L5_2
    L13_2 = L13_2 + 1
    L14_2 = {}
    L15_2 = L11_2.src
    L14_2.src = L15_2
    if L12_2 then
      L15_2 = L11_2.number
      if L15_2 then
        goto lbl_41
      end
    end
    L15_2 = nil
    ::lbl_41::
    L14_2.number = L15_2
    if not L12_2 then
      L15_2 = L11_2.alias
      if L15_2 then
        goto lbl_48
      end
    end
    L15_2 = nil
    ::lbl_48::
    L14_2.name = L15_2
    if not L12_2 then
      L15_2 = "Participante "
      L16_2 = L11_2.seq
      L15_2 = L15_2 .. L16_2
      if L15_2 then
        goto lbl_57
      end
    end
    L15_2 = nil
    ::lbl_57::
    L14_2.label = L15_2
    L15_2 = L11_2.muted
    L14_2.muted = L15_2
    L15_2 = L11_2.video
    L14_2.video = L15_2
    L15_2 = L11_2.hand
    if not L15_2 then
      L15_2 = 0
    end
    L14_2.hand = L15_2
    L15_2 = L11_2.src
    L15_2 = L15_2 == A1_2
    L14_2.isMe = L15_2
    L5_2[L13_2] = L14_2
  end
  L6_2 = {}
  L7_2 = pairs
  L8_2 = A0_2.ringing
  L7_2, L8_2, L9_2, L10_2 = L7_2(L8_2)
  for L11_2 in L7_2, L8_2, L9_2, L10_2 do
    L12_2 = #L6_2
    L12_2 = L12_2 + 1
    L13_2 = L3_2[L11_2]
    if L13_2 then
      L13_2 = {}
      L13_2.number = L11_2
      if L13_2 then
        goto lbl_97
      end
    end
    L13_2 = {}
    L13_2.label = "Convidado"
    ::lbl_97::
    L6_2[L12_2] = L13_2
  end
  L7_2 = {}
  L8_2 = A0_2.id
  L7_2.callId = L8_2
  L8_2 = A0_2.code
  L7_2.code = L8_2
  L8_2 = A0_2.kind
  L7_2.kind = L8_2
  L8_2 = A0_2.title
  L7_2.title = L8_2
  L8_2 = A0_2.video
  L7_2.video = L8_2
  L8_2 = A0_2.conversation
  if L8_2 then
    L8_2 = A0_2.members
    L8_2 = L8_2[A1_2]
    if true == L8_2 then
      L8_2 = A0_2.conversation
      if L8_2 then
        goto lbl_124
      end
    end
  end
  L8_2 = nil
  ::lbl_124::
  L7_2.conversation = L8_2
  L8_2 = A0_2.startedAt
  if not L8_2 then
    L8_2 = A0_2.createdAt
  end
  L7_2.startedAt = L8_2
  L8_2 = math
  L8_2 = L8_2.max
  L9_2 = 0
  L10_2 = A0_2.startedAt
  if not L10_2 then
    L10_2 = A0_2.createdAt
  end
  L10_2 = L4_2 - L10_2
  L8_2 = L8_2(L9_2, L10_2)
  L7_2.elapsed = L8_2
  L8_2 = L24_1
  L8_2 = L8_2()
  L7_2.max = L8_2
  L7_2.me = A1_2
  if L2_2 then
    L8_2 = L2_2.canEnd
  end
  L8_2 = true == L8_2 or L8_2
  L7_2.canEnd = L8_2
  L7_2.screenShare = false
  L8_2 = L26_1
  L8_2 = L8_2()
  L7_2.videoProvider = L8_2
  L8_2 = L29_1
  L8_2 = L8_2()
  L7_2.reactions = L8_2
  L7_2.participants = L5_2
  L7_2.ringing = L6_2
  return L7_2
end
function L61_1(A0_2, A1_2, A2_2)
  local L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2
  L3_2 = {}
  L4_2 = A0_2.conversation
  if L4_2 then
    L4_2 = L44_1
    L5_2 = A0_2.conversation
    L6_2 = A1_2
    L4_2 = L4_2(L5_2, L6_2)
    if L4_2 then
      L4_2 = ipairs
      L5_2 = L39_1
      L6_2 = "GroupMembers"
      L7_2 = A0_2.conversation
      L5_2 = L5_2(L6_2, L7_2)
      if not L5_2 then
        L5_2 = {}
      end
      L4_2, L5_2, L6_2, L7_2 = L4_2(L5_2)
      for L8_2, L9_2 in L4_2, L5_2, L6_2, L7_2 do
        L10_2 = tostring
        L11_2 = L9_2
        L10_2 = L10_2(L11_2)
        L3_2[L10_2] = true
      end
    end
  end
  L4_2 = {}
  L5_2 = ipairs
  L6_2 = L58_1
  L7_2 = A0_2
  L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2 = L6_2(L7_2)
  L5_2, L6_2, L7_2, L8_2 = L5_2(L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2)
  for L9_2, L10_2 in L5_2, L6_2, L7_2, L8_2 do
    L11_2 = L10_2.number
    L11_2 = L3_2[L11_2]
    if not L11_2 then
      L11_2 = L10_2.number
      L11_2 = L11_2 == A2_2
    end
    L12_2 = #L4_2
    L12_2 = L12_2 + 1
    L13_2 = {}
    L14_2 = L10_2.src
    L13_2.src = L14_2
    if L11_2 then
      L14_2 = L10_2.number
      if L14_2 then
        goto lbl_60
      end
    end
    L14_2 = nil
    ::lbl_60::
    L13_2.number = L14_2
    if not L11_2 then
      L14_2 = L10_2.alias
      if L14_2 then
        goto lbl_67
      end
    end
    L14_2 = nil
    ::lbl_67::
    L13_2.name = L14_2
    if not L11_2 then
      L14_2 = "Participante "
      L15_2 = L10_2.seq
      L14_2 = L14_2 .. L15_2
      if L14_2 then
        goto lbl_76
      end
    end
    L14_2 = nil
    ::lbl_76::
    L13_2.label = L14_2
    L14_2 = L10_2.muted
    L13_2.muted = L14_2
    L14_2 = L10_2.video
    L13_2.video = L14_2
    L4_2[L12_2] = L13_2
  end
  L5_2 = {}
  L6_2 = A0_2.id
  L5_2.callId = L6_2
  L6_2 = A0_2.kind
  L5_2.kind = L6_2
  L6_2 = A0_2.title
  L5_2.title = L6_2
  L6_2 = A0_2.video
  L5_2.video = L6_2
  L6_2 = L3_2[A1_2]
  if L6_2 then
    L6_2 = A0_2.conversation
    if L6_2 then
      goto lbl_102
    end
  end
  L6_2 = nil
  ::lbl_102::
  L5_2.conversation = L6_2
  L5_2.participants = L4_2
  L6_2 = L24_1
  L6_2 = L6_2()
  L5_2.max = L6_2
  return L5_2
end
function L62_1(A0_2)
  local L1_2, L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2, L19_2, L20_2, L21_2
  L1_2 = {}
  L2_2 = A0_2.conversation
  if L2_2 then
    L2_2 = ipairs
    L3_2 = L39_1
    L4_2 = "GroupMembers"
    L5_2 = A0_2.conversation
    L3_2 = L3_2(L4_2, L5_2)
    if not L3_2 then
      L3_2 = {}
    end
    L2_2, L3_2, L4_2, L5_2 = L2_2(L3_2)
    for L6_2, L7_2 in L2_2, L3_2, L4_2, L5_2 do
      L8_2 = tostring
      L9_2 = L7_2
      L8_2 = L8_2(L9_2)
      L1_2[L8_2] = true
    end
  end
  L2_2 = {}
  L3_2 = pairs
  L4_2 = A0_2.participants
  L3_2, L4_2, L5_2, L6_2 = L3_2(L4_2)
  for L7_2, L8_2 in L3_2, L4_2, L5_2, L6_2 do
    L9_2 = #L2_2
    L9_2 = L9_2 + 1
    L10_2 = L8_2.number
    L2_2[L9_2] = L10_2
  end
  L3_2 = pairs
  L4_2 = A0_2.ringing
  L3_2, L4_2, L5_2, L6_2 = L3_2(L4_2)
  for L7_2 in L3_2, L4_2, L5_2, L6_2 do
    L8_2 = #L2_2
    L8_2 = L8_2 + 1
    L2_2[L8_2] = L7_2
  end
  L3_2 = pairs
  L4_2 = A0_2.participants
  L3_2, L4_2, L5_2, L6_2 = L3_2(L4_2)
  for L7_2, L8_2 in L3_2, L4_2, L5_2, L6_2 do
    L9_2 = {}
    L10_2 = L8_2.number
    L9_2[L10_2] = true
    L10_2 = L8_2.number
    L10_2 = L1_2[L10_2]
    if L10_2 then
      L10_2 = ipairs
      L11_2 = L2_2
      L10_2, L11_2, L12_2, L13_2 = L10_2(L11_2)
      for L14_2, L15_2 in L10_2, L11_2, L12_2, L13_2 do
        L16_2 = L1_2[L15_2]
        if L16_2 then
          L9_2[L15_2] = true
        end
      end
    end
    L10_2 = L8_2.cid
    if L10_2 then
      L10_2 = {}
      L11_2 = ipairs
      L12_2 = L2_2
      L11_2, L12_2, L13_2, L14_2 = L11_2(L12_2)
      for L15_2, L16_2 in L11_2, L12_2, L13_2, L14_2 do
        L17_2 = L9_2[L16_2]
        if not L17_2 then
          L17_2 = #L10_2
          L17_2 = L17_2 + 1
          L10_2[L17_2] = L16_2
        end
      end
      L11_2 = #L10_2
      if L11_2 > 0 then
        L11_2 = {}
        L12_2 = L8_2.cid
        L11_2[1] = L12_2
        L12_2 = ipairs
        L13_2 = L10_2
        L12_2, L13_2, L14_2, L15_2 = L12_2(L13_2)
        for L16_2, L17_2 in L12_2, L13_2, L14_2, L15_2 do
          L18_2 = #L11_2
          L18_2 = L18_2 + 1
          L11_2[L18_2] = L17_2
        end
        L12_2 = pcall
        L13_2 = MySQL
        L13_2 = L13_2.query
        L13_2 = L13_2.await
        L14_2 = "SELECT number FROM apex_phone_contacts WHERE owner = ? AND number IN (%s)"
        L15_2 = L14_2
        L14_2 = L14_2.format
        L16_2 = L31_1
        L17_2 = #L10_2
        L16_2, L17_2, L18_2, L19_2, L20_2, L21_2 = L16_2(L17_2)
        L14_2 = L14_2(L15_2, L16_2, L17_2, L18_2, L19_2, L20_2, L21_2)
        L15_2 = L11_2
        L12_2, L13_2 = L12_2(L13_2, L14_2, L15_2)
        L14_2 = ipairs
        L15_2 = L13_2 or L15_2
        if not L12_2 or not L13_2 then
          L15_2 = {}
        end
        L14_2, L15_2, L16_2, L17_2 = L14_2(L15_2)
        for L18_2, L19_2 in L14_2, L15_2, L16_2, L17_2 do
          L20_2 = tostring
          L21_2 = L19_2.number
          L20_2 = L20_2(L21_2)
          L9_2[L20_2] = true
        end
      end
    end
    L10_2 = A0_2.participants
    L11_2 = L8_2.src
    L10_2 = L10_2[L11_2]
    if L10_2 == L8_2 then
      L10_2 = A0_2.visible
      L11_2 = L8_2.src
      L10_2[L11_2] = L9_2
      L10_2 = A0_2.members
      L11_2 = L8_2.src
      L12_2 = L8_2.number
      L12_2 = L1_2[L12_2]
      L12_2 = true == L12_2
      L10_2[L11_2] = L12_2
    end
  end
end
function L63_1(A0_2, A1_2, A2_2, A3_2)
  local L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2
  L4_2 = A0_2.ended
  if L4_2 then
    return
  end
  L4_2 = pairs
  L5_2 = A0_2.participants
  L4_2, L5_2, L6_2, L7_2 = L4_2(L5_2)
  for L8_2 in L4_2, L5_2, L6_2, L7_2 do
    if L8_2 ~= A3_2 then
      L9_2 = L60_1
      L10_2 = A0_2
      L11_2 = L8_2
      L9_2 = L9_2(L10_2, L11_2)
      L10_2 = {}
      L11_2 = A0_2.id
      L10_2.callId = L11_2
      L11_2 = A1_2 or L11_2
      if not A1_2 then
        L11_2 = "state"
      end
      L10_2.event = L11_2
      L10_2.call = L9_2
      L11_2 = L9_2.participants
      L10_2.participants = L11_2
      if A2_2 then
        L11_2 = pairs
        L12_2 = A2_2
        L11_2, L12_2, L13_2, L14_2 = L11_2(L12_2)
        for L15_2, L16_2 in L11_2, L12_2, L13_2, L14_2 do
          L10_2[L15_2] = L16_2
        end
      end
      L11_2 = Push
      L12_2 = L8_2
      L13_2 = "recadoCall"
      L14_2 = L10_2
      L11_2(L12_2, L13_2, L14_2)
    end
  end
end
function L64_1(A0_2, A1_2, A2_2)
  local L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2
  if A1_2 then
    L3_2 = A0_2.visible
    L3_2 = L3_2[A1_2]
    if L3_2 then
      goto lbl_9
    end
  end
  L3_2 = {}
  ::lbl_9::
  L4_2 = {}
  L5_2 = ipairs
  L6_2 = L58_1
  L7_2 = A0_2
  L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2 = L6_2(L7_2)
  L5_2, L6_2, L7_2, L8_2 = L5_2(L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2)
  for L9_2, L10_2 in L5_2, L6_2, L7_2, L8_2 do
    L11_2 = L10_2.cid
    if L11_2 ~= A2_2 then
      L11_2 = L10_2.number
      L11_2 = L3_2[L11_2]
      if L11_2 then
        L11_2 = #L4_2
        if L11_2 < 8 then
          L11_2 = #L4_2
          L11_2 = L11_2 + 1
          L12_2 = L10_2.number
          L4_2[L11_2] = L12_2
        end
      end
    end
  end
  return L4_2
end
function L65_1(A0_2, A1_2, A2_2, A3_2, A4_2, A5_2, A6_2)
  local L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2, L19_2, L20_2, L21_2, L22_2
  if A1_2 then
    L7_2 = L18_1
    if L7_2 then
      goto lbl_7
    end
  end
  do return end
  ::lbl_7::
  L7_2 = A0_2.hist
  L7_2 = L7_2[A1_2]
  L8_2 = math
  L8_2 = L8_2.max
  L9_2 = 0
  L10_2 = math
  L10_2 = L10_2.floor
  L11_2 = A4_2 or L11_2
  if not A4_2 then
    L11_2 = 0
  end
  L10_2 = L10_2(L11_2)
  L8_2 = L8_2(L9_2, L10_2)
  A4_2 = L8_2
  if L7_2 then
    L8_2 = L7_2.id
    if L8_2 then
      L8_2 = MySQL
      L8_2 = L8_2.update
      L9_2 = "UPDATE apex_phone_recado_call_history SET duration = duration + ?, status = IF(? = 'answered', 'answered', status) WHERE id = ?"
      L10_2 = {}
      L11_2 = A4_2
      L12_2 = A2_2
      L13_2 = L7_2.id
      L10_2[1] = L11_2
      L10_2[2] = L12_2
      L10_2[3] = L13_2
      L8_2(L9_2, L10_2)
    else
      L8_2 = L7_2.addDur
      if not L8_2 then
        L8_2 = 0
      end
      L8_2 = L8_2 + A4_2
      L7_2.addDur = L8_2
      if "answered" == A2_2 then
        L7_2.answered = true
      end
    end
    return
  end
  L8_2 = {}
  L7_2 = L8_2
  L8_2 = A0_2.hist
  L8_2[A1_2] = L7_2
  L8_2 = nil
  L9_2 = type
  L10_2 = A5_2
  L9_2 = L9_2(L10_2)
  if "table" == L9_2 then
    L9_2 = #A5_2
    if L9_2 > 0 then
      L9_2 = pcall
      L10_2 = json
      L10_2 = L10_2.encode
      L11_2 = A5_2
      L9_2, L10_2 = L9_2(L10_2, L11_2)
      if L9_2 then
        L11_2 = #L10_2
        L12_2 = 400
        if L11_2 <= L12_2 then
          L8_2 = L10_2
        end
      end
    end
  end
  L9_2 = MySQL
  L9_2 = L9_2.insert
  L10_2 = "INSERT INTO apex_phone_recado_call_history (owner, call_id, kind, conversation, title, video, direction, status, participants, duration, created) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)"
  L11_2 = {}
  L12_2 = A1_2
  L13_2 = A0_2.id
  L14_2 = A0_2.kind
  L15_2 = A0_2.conversation
  L16_2 = A0_2.title
  L17_2 = A0_2.video
  if L17_2 then
    L17_2 = 1
    if L17_2 then
      goto lbl_90
    end
  end
  L17_2 = 0
  ::lbl_90::
  if "out" == A3_2 then
    L18_2 = "out"
    if L18_2 then
      goto lbl_96
    end
  end
  L18_2 = "in"
  ::lbl_96::
  L19_2 = A2_2
  L20_2 = L8_2
  L21_2 = A4_2
  L22_2 = A6_2 or L22_2
  if not A6_2 then
    L22_2 = Now
    L22_2 = L22_2()
  end
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
  function L12_2(A0_3)
    local L1_3, L2_3, L3_3, L4_3, L5_3, L6_3
    L1_3 = tonumber
    L2_3 = A0_3
    L1_3 = L1_3(L2_3)
    L7_2.id = L1_3
    L1_3 = L7_2.id
    if L1_3 then
      L1_3 = L7_2.addDur
      if not L1_3 then
        L1_3 = 0
      end
      if not (L1_3 > 0) then
        L1_3 = L7_2.answered
        if not L1_3 then
          goto lbl_39
        end
      end
      L1_3 = MySQL
      L1_3 = L1_3.update
      L2_3 = "UPDATE apex_phone_recado_call_history SET duration = duration + ?, status = IF(?, 'answered', status) WHERE id = ?"
      L3_3 = {}
      L4_3 = L7_2.addDur
      if not L4_3 then
        L4_3 = 0
      end
      L5_3 = L7_2.answered
      if L5_3 then
        L5_3 = 1
        if L5_3 then
          goto lbl_33
        end
      end
      L5_3 = 0
      ::lbl_33::
      L6_3 = L7_2.id
      L3_3[1] = L4_3
      L3_3[2] = L5_3
      L3_3[3] = L6_3
      L1_3(L2_3, L3_3)
      L1_3 = nil
      L7_2.answered = nil
      L7_2.addDur = L1_3
    end
    ::lbl_39::
  end
  L9_2(L10_2, L11_2, L12_2)
end
function L66_1(A0_2, A1_2, A2_2, A3_2)
  local L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2
  L4_2 = type
  L5_2 = RecadoSend
  L4_2 = L4_2(L5_2)
  if "function" == L4_2 then
    L4_2 = pcall
    L5_2 = RecadoSend
    L6_2 = A0_2
    L7_2 = A1_2.conversation
    if L7_2 then
      L7_2 = {}
      L8_2 = A1_2.conversation
      L7_2.conversation = L8_2
      if L7_2 then
        goto lbl_22
      end
    end
    L7_2 = {}
    L8_2 = A1_2.number
    L7_2.number = L8_2
    ::lbl_22::
    L8_2 = {}
    L8_2.type = "call"
    L8_2.content = A2_2
    L8_2.payload = A3_2
    L9_2 = {}
    L9_2.trusted = true
    L4_2, L5_2, L6_2 = L4_2(L5_2, L6_2, L7_2, L8_2, L9_2)
    if L4_2 then
      L7_2 = type
      L8_2 = L5_2
      L7_2 = L7_2(L8_2)
      if "table" == L7_2 then
        return L5_2
      end
    end
    L7_2 = L19_1
    L8_2 = "RecadoSend rejected the call message: %s"
    if L4_2 then
      L9_2 = tostring
      L10_2 = L6_2
      L9_2 = L9_2(L10_2)
      if L9_2 then
        goto lbl_51
      end
    end
    L9_2 = tostring
    L10_2 = L5_2
    L9_2 = L9_2(L10_2)
    ::lbl_51::
    L7_2(L8_2, L9_2)
    L7_2 = nil
    return L7_2
  end
  L4_2 = {}
  L4_2.type = "call"
  L4_2.content = A2_2
  L4_2.payload = A3_2
  L5_2 = A1_2.conversation
  if L5_2 then
    L5_2 = A1_2.conversation
    L4_2.conversation = L5_2
  else
    L5_2 = A1_2.number
    L4_2.number = L5_2
    L5_2 = A1_2.number
    L4_2.to = L5_2
  end
  L5_2 = A1_2.conversation
  if L5_2 then
    L5_2 = type
    L6_2 = GroupSend
    L5_2 = L5_2(L6_2)
    if "function" == L5_2 then
      L5_2 = pcall
      L6_2 = GroupSend
      L7_2 = A0_2
      L8_2 = A1_2.conversation
      L9_2 = {}
      L9_2.type = "call"
      L9_2.content = A2_2
      L9_2.payload = A3_2
      L5_2, L6_2 = L5_2(L6_2, L7_2, L8_2, L9_2)
      if L5_2 then
        L7_2 = type
        L8_2 = L6_2
        L7_2 = L7_2(L8_2)
        if "table" == L7_2 then
          return L6_2
        end
      end
    end
  else
    L5_2 = type
    L6_2 = RPC
    L6_2 = L6_2["messages.send"]
    L5_2 = L5_2(L6_2)
    if "function" == L5_2 then
      L5_2 = pcall
      L6_2 = RPC
      L6_2 = L6_2["messages.send"]
      L7_2 = A0_2
      L8_2 = {}
      L8_2.app = "recado"
      L9_2 = A1_2.number
      L8_2.to = L9_2
      L8_2.type = "call"
      L8_2.content = A2_2
      L8_2.payload = A3_2
      L5_2, L6_2 = L5_2(L6_2, L7_2, L8_2)
      if L5_2 then
        L7_2 = type
        L8_2 = L6_2
        L7_2 = L7_2(L8_2)
        if "table" == L7_2 then
          L7_2 = L6_2.error
          if not L7_2 then
            return L6_2
          end
        end
      end
    end
  end
  L5_2 = nil
  return L5_2
end
L67_1 = nil
function L68_1(A0_2)
  local L1_2, L2_2, L3_2, L4_2, L5_2, L6_2, L7_2
  L1_2 = L17_1
  L2_2 = L17_1
  L2_2 = L2_2 + 1
  L17_1 = L2_2
  L2_2 = {}
  L2_2.id = L1_2
  L3_2 = L0_1
  L3_2 = L3_2 + L1_2
  L2_2.voiceId = L3_2
  L3_2 = A0_2.code
  L2_2.code = L3_2
  L3_2 = A0_2.kind
  L2_2.kind = L3_2
  L3_2 = A0_2.conversation
  L2_2.conversation = L3_2
  L3_2 = A0_2.title
  if not L3_2 then
    L3_2 = "Chamada Recado"
  end
  L2_2.title = L3_2
  L3_2 = A0_2.video
  L3_2 = true == L3_2
  L2_2.video = L3_2
  L3_2 = A0_2.number
  L2_2.creatorNumber = L3_2
  L3_2 = A0_2.cid
  L2_2.creatorCid = L3_2
  L3_2 = Now
  L3_2 = L3_2()
  L2_2.createdAt = L3_2
  L2_2.startedAt = nil
  L3_2 = A0_2.open
  L3_2 = true == L3_2
  L2_2.open = L3_2
  L3_2 = A0_2.scheduledId
  L2_2.scheduledId = L3_2
  L3_2 = {}
  L2_2.participants = L3_2
  L3_2 = {}
  L2_2.order = L3_2
  L3_2 = {}
  L2_2.ringing = L3_2
  L3_2 = {}
  L2_2.invited = L3_2
  L3_2 = {}
  L2_2.hist = L3_2
  L3_2 = {}
  L2_2.visible = L3_2
  L3_2 = {}
  L2_2.members = L3_2
  L2_2.seq = 0
  function L3_2()
    local L0_3, L1_3, L2_3, L3_3, L4_3, L5_3, L6_3, L7_3
    L0_3 = L2_2.messageId
    if L0_3 then
      L0_3 = L2_2.messageDone
      if not L0_3 then
        L0_3 = L2_2.messagePayload
        if L0_3 then
          goto lbl_11
        end
      end
    end
    do return end
    ::lbl_11::
    L2_2.messageDone = true
    L0_3 = {}
    L1_3 = pairs
    L2_3 = L2_2.messagePayload
    L1_3, L2_3, L3_3, L4_3 = L1_3(L2_3)
    for L5_3, L6_3 in L1_3, L2_3, L3_3, L4_3 do
      L0_3[L5_3] = L6_3
    end
    L0_3.status = "ended"
    L1_3 = math
    L1_3 = L1_3.max
    L2_3 = 0
    L3_3 = math
    L3_3 = L3_3.floor
    L4_3 = L2_2.endedAt
    if not L4_3 then
      L4_3 = Now
      L4_3 = L4_3()
    end
    L5_3 = L2_2.startedAt
    if not L5_3 then
      L5_3 = L2_2.createdAt
    end
    L4_3 = L4_3 - L5_3
    L4_3 = L4_3 / 1000
    L3_3 = L3_3(L4_3)
    L1_3 = L1_3(L2_3, L3_3)
    L0_3.duration = L1_3
    L1_3 = pcall
    L2_3 = json
    L2_3 = L2_3.encode
    L3_3 = L0_3
    L1_3, L2_3 = L1_3(L2_3, L3_3)
    if L1_3 then
      L3_3 = MySQL
      L3_3 = L3_3.update
      L4_3 = "UPDATE apex_phone_messages SET payload = ? WHERE id = ? AND `type` = 'call'"
      L5_3 = {}
      L6_3 = L2_3
      L7_3 = L2_2.messageId
      L5_3[1] = L6_3
      L5_3[2] = L7_3
      L3_3(L4_3, L5_3)
    end
  end
  L2_2.finishMessage = L3_2
  L3_2 = L10_1
  L3_2[L1_2] = L2_2
  L4_2 = L2_2.code
  L3_2 = L11_1
  L3_2[L4_2] = L1_2
  L3_2 = L19_1
  L4_2 = "new call %s (%s) code %s"
  L5_2 = L1_2
  L6_2 = L2_2.kind
  L7_2 = L2_2.code
  L3_2(L4_2, L5_2, L6_2, L7_2)
  return L2_2
end
function L69_1(A0_2)
  local L1_2, L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2
  L1_2 = {}
  L2_2 = ipairs
  L3_2 = A0_2.order
  L2_2, L3_2, L4_2, L5_2 = L2_2(L3_2)
  for L6_2, L7_2 in L2_2, L3_2, L4_2, L5_2 do
    L8_2 = A0_2.participants
    L8_2 = L8_2[L7_2]
    if L8_2 then
      L8_2 = #L1_2
      L8_2 = L8_2 + 1
      L1_2[L8_2] = L7_2
    end
  end
  L2_2 = L38_1
  L3_2 = "session"
  L4_2 = A0_2.voiceId
  L2_2 = L2_2(L3_2, L4_2)
  if not L2_2 then
    L2_2 = L38_1
    L3_2 = "join"
    L4_2 = A0_2.voiceId
    L5_2 = L1_2
    L2_2(L3_2, L4_2, L5_2)
  else
    L2_2 = L38_1
    L3_2 = "provider"
    L2_2 = L2_2(L3_2)
    if "saltychat" == L2_2 then
      L2_2 = L38_1
      L3_2 = "leave"
      L4_2 = A0_2.voiceId
      L2_2(L3_2, L4_2)
      L2_2 = L38_1
      L3_2 = "join"
      L4_2 = A0_2.voiceId
      L5_2 = L1_2
      L2_2(L3_2, L4_2, L5_2)
    end
  end
end
function L70_1(A0_2, A1_2, A2_2, A3_2)
  local L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2
  if not A3_2 then
    A3_2 = "missed"
  end
  L4_2 = L65_1
  L5_2 = A0_2
  L6_2 = A2_2.cid
  L7_2 = A3_2
  L8_2 = "in"
  L9_2 = 0
  L10_2 = nil
  L11_2 = A2_2.since
  L4_2(L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2)
  if "missed" == A3_2 then
    L4_2 = A2_2.cid
    if L4_2 then
      L4_2 = nil
      L5_2 = A0_2.ended
      if not L5_2 then
        L5_2 = {}
        L6_2 = {}
        L7_2 = {}
        L7_2.id = "recado_call_join"
        L7_2.label = "Entrar"
        L6_2[1] = L7_2
        L5_2.actions = L6_2
        L4_2 = L5_2
      end
      L5_2 = NotifyCitizen
      L6_2 = A2_2.cid
      L7_2 = "recado"
      L8_2 = A0_2.title
      L9_2 = A0_2.video
      if L9_2 then
        L9_2 = "Videochamada de grupo n\195\163o atendida"
        if L9_2 then
          goto lbl_44
        end
      end
      L9_2 = "Chamada de grupo n\195\163o atendida"
      ::lbl_44::
      L10_2 = {}
      L11_2 = {}
      L12_2 = A0_2.id
      L11_2.callId = L12_2
      L12_2 = A0_2.ended
      if not L12_2 then
        L12_2 = A0_2.code
        if L12_2 then
          goto lbl_57
        end
      end
      L12_2 = nil
      ::lbl_57::
      L11_2.code = L12_2
      L10_2.recadoCall = L11_2
      L10_2.sys = "m"
      L11_2 = L4_2
      L5_2(L6_2, L7_2, L8_2, L9_2, L10_2, L11_2)
    end
  end
end
function L71_1(A0_2, A1_2, A2_2, A3_2, A4_2, A5_2)
  local L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2
  if A3_2 == A2_2 then
    L6_2 = "already"
    return L6_2
  end
  L6_2 = pairs
  L7_2 = A0_2.participants
  L6_2, L7_2, L8_2, L9_2 = L6_2(L7_2)
  for L10_2, L11_2 in L6_2, L7_2, L8_2, L9_2 do
    L12_2 = L11_2.number
    if L12_2 == A3_2 then
      L12_2 = "already"
      return L12_2
    end
  end
  L6_2 = A0_2.ringing
  L6_2 = L6_2[A3_2]
  if L6_2 then
    L6_2 = "already"
    return L6_2
  end
  L6_2 = L51_1
  L7_2 = A0_2.participants
  L6_2 = L6_2(L7_2)
  L7_2 = L51_1
  L8_2 = A0_2.ringing
  L7_2 = L7_2(L8_2)
  L6_2 = L6_2 + L7_2
  L7_2 = L24_1
  L7_2 = L7_2()
  if L6_2 >= L7_2 then
    L6_2 = "full"
    return L6_2
  end
  L6_2 = A0_2.invited
  L6_2[A3_2] = true
  L6_2 = A4_2[A3_2]
  if L6_2 then
    L7_2 = L40_1
    L8_2 = L6_2
    L7_2 = L7_2(L8_2)
    if L7_2 then
      goto lbl_49
    end
  end
  L7_2 = "offline"
  do return L7_2 end
  ::lbl_49::
  L7_2 = GetCid
  L8_2 = L6_2
  L7_2 = L7_2(L8_2)
  if L7_2 then
    L8_2 = L43_1
    L9_2 = L7_2
    L10_2 = A2_2
    L8_2 = L8_2(L9_2, L10_2)
    if L8_2 then
      L8_2 = A0_2.invited
      L8_2[A3_2] = nil
      L8_2 = "unavailable"
      return L8_2
    end
  end
  L8_2 = {}
  L8_2.src = L6_2
  L8_2.cid = L7_2
  L9_2 = Now
  L9_2 = L9_2()
  L8_2.since = L9_2
  L8_2.by = A2_2
  L9_2 = {}
  L8_2.token = L9_2
  if not A5_2 then
    L9_2 = L39_1
    L10_2 = "RecadoSilenceUnknown"
    L11_2 = A3_2
    L12_2 = A2_2
    L9_2 = L9_2(L10_2, L11_2, L12_2)
    if true == L9_2 then
      L9_2 = L65_1
      L10_2 = A0_2
      L11_2 = L7_2
      L12_2 = "missed"
      L13_2 = "in"
      L14_2 = 0
      L15_2 = nil
      L16_2 = L8_2.since
      L9_2(L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2)
      L9_2 = "silenced"
      return L9_2
    end
  end
  L9_2 = A0_2.ringing
  L9_2[A3_2] = L8_2
  L9_2 = Push
  L10_2 = L6_2
  L11_2 = "recadoCall"
  L12_2 = {}
  L13_2 = A0_2.id
  L12_2.callId = L13_2
  L12_2.event = "ring"
  L12_2.from = A2_2
  L13_2 = L61_1
  L14_2 = A0_2
  L15_2 = A3_2
  L16_2 = A2_2
  L13_2 = L13_2(L14_2, L15_2, L16_2)
  L12_2.call = L13_2
  L9_2(L10_2, L11_2, L12_2)
  L9_2 = L8_2.token
  L10_2 = SetTimeout
  L11_2 = L1_1
  function L12_2()
    local L0_3, L1_3, L2_3, L3_3, L4_3, L5_3
    L1_3 = A0_2.id
    L0_3 = L10_1
    L0_3 = L0_3[L1_3]
    L1_3 = A0_2
    if L0_3 ~= L1_3 then
      return
    end
    L0_3 = A0_2.ringing
    L1_3 = A3_2
    L0_3 = L0_3[L1_3]
    if L0_3 then
      L1_3 = L0_3.token
      L2_3 = L9_2
      if L1_3 == L2_3 then
        goto lbl_18
      end
    end
    do return end
    ::lbl_18::
    L1_3 = A0_2.ringing
    L2_3 = A3_2
    L1_3[L2_3] = nil
    L1_3 = Push
    L2_3 = L0_3.src
    L3_3 = "recadoCall"
    L4_3 = {}
    L5_3 = A0_2.id
    L4_3.callId = L5_3
    L4_3.event = "cancelled"
    L4_3.reason = "timeout"
    L1_3(L2_3, L3_3, L4_3)
    L1_3 = L70_1
    L2_3 = A0_2
    L3_3 = A3_2
    L4_3 = L0_3
    L1_3(L2_3, L3_3, L4_3)
    L1_3 = L63_1
    L2_3 = A0_2
    L1_3(L2_3)
  end
  L10_2(L11_2, L12_2)
  L10_2 = "ringing"
  return L10_2
end
function L72_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2
  L2_2 = {}
  L2_2.ok = true
  L3_2 = A0_2.id
  L2_2.callId = L3_2
  L3_2 = A0_2.code
  L2_2.code = L3_2
  L3_2 = L60_1
  L4_2 = A0_2
  L5_2 = A1_2
  L3_2 = L3_2(L4_2, L5_2)
  L2_2.call = L3_2
  return L2_2
end
function L73_1(A0_2, A1_2, A2_2, A3_2)
  local L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2
  L4_2 = A0_2.ended
  if L4_2 then
    L4_2 = L20_1
    L5_2 = "notfound"
    return L4_2(L5_2)
  end
  L4_2 = A0_2.participants
  L4_2 = L4_2[A1_2]
  if L4_2 then
    L4_2 = L72_1
    L5_2 = A0_2
    L6_2 = A1_2
    return L4_2(L5_2, L6_2)
  end
  L4_2 = L12_1
  L4_2 = L4_2[A1_2]
  if L4_2 then
    L4_2 = L12_1
    L5_2 = L4_2[A1_2]
    L4_2 = L10_1
    L4_2 = L4_2[L5_2]
  end
  if L4_2 and L4_2 ~= A0_2 then
    L5_2 = L20_1
    L6_2 = "busy"
    return L5_2(L6_2)
  end
  L5_2 = L51_1
  L6_2 = A0_2.participants
  L5_2 = L5_2(L6_2)
  L6_2 = L24_1
  L6_2 = L6_2()
  if L5_2 >= L6_2 then
    L5_2 = L20_1
    L6_2 = "full"
    return L5_2(L6_2)
  end
  L5_2 = A0_2.seq
  L5_2 = L5_2 + 1
  A0_2.seq = L5_2
  L5_2 = {}
  L5_2.src = A1_2
  L6_2 = A2_2.number
  L5_2.number = L6_2
  L6_2 = A2_2.cid
  L5_2.cid = L6_2
  L5_2.muted = false
  L5_2.video = false
  L5_2.hand = 0
  L6_2 = Now
  L6_2 = L6_2()
  L5_2.joinedAt = L6_2
  L6_2 = A0_2.seq
  L5_2.seq = L6_2
  L6_2 = A3_2 or L6_2
  if not A3_2 then
    L6_2 = "in"
  end
  L5_2.direction = L6_2
  L6_2 = A0_2.participants
  L6_2[A1_2] = L5_2
  L6_2 = A0_2.order
  L7_2 = A0_2.order
  L7_2 = #L7_2
  L7_2 = L7_2 + 1
  L6_2[L7_2] = A1_2
  L6_2 = L12_1
  L7_2 = A0_2.id
  L6_2[A1_2] = L7_2
  L6_2 = A0_2.ringing
  L7_2 = A2_2.number
  L6_2 = L6_2[L7_2]
  if L6_2 then
    L7_2 = A0_2.ringing
    L8_2 = A2_2.number
    L7_2[L8_2] = nil
    L7_2 = L6_2.src
    if L7_2 ~= A1_2 then
      L7_2 = Push
      L8_2 = L6_2.src
      L9_2 = "recadoCall"
      L10_2 = {}
      L11_2 = A0_2.id
      L10_2.callId = L11_2
      L10_2.event = "cancelled"
      L7_2(L8_2, L9_2, L10_2)
    end
  end
  L7_2 = A0_2.startedAt
  if not L7_2 then
    L7_2 = Now
    L7_2 = L7_2()
    A0_2.startedAt = L7_2
  end
  L7_2 = L42_1
  L8_2 = A1_2
  L9_2 = A0_2.id
  L7_2(L8_2, L9_2)
  L7_2 = L69_1
  L8_2 = A0_2
  L7_2(L8_2)
  L7_2 = L48_1
  L8_2 = A2_2.number
  L7_2 = L7_2(L8_2)
  L5_2.alias = L7_2
  L7_2 = L59_1
  L8_2 = A0_2
  L9_2 = A2_2.number
  L10_2 = A2_2.cid
  L7_2 = L7_2(L8_2, L9_2, L10_2)
  L5_2.canEnd = L7_2
  L7_2 = L62_1
  L8_2 = A0_2
  L7_2(L8_2)
  L7_2 = A0_2.ended
  if not L7_2 then
    L7_2 = A0_2.participants
    L7_2 = L7_2[A1_2]
    if L7_2 == L5_2 then
      goto lbl_135
    end
  end
  L7_2 = L20_1
  L8_2 = "notfound"
  do return L7_2(L8_2) end
  ::lbl_135::
  L7_2 = L38_1
  L8_2 = "session"
  L9_2 = A0_2.voiceId
  L7_2 = L7_2(L8_2, L9_2)
  L8_2 = type
  L9_2 = L7_2
  L8_2 = L8_2(L9_2)
  if "table" == L8_2 then
    L8_2 = L7_2.channel
    if L8_2 then
      goto lbl_156
    end
  end
  L8_2 = L38_1
  L9_2 = "channel"
  L10_2 = A0_2.voiceId
  L8_2 = L8_2(L9_2, L10_2)
  if not L8_2 then
    L8_2 = A0_2.voiceId
    L8_2 = 50000 + L8_2
  end
  ::lbl_156::
  L9_2 = L60_1
  L10_2 = A0_2
  L11_2 = A1_2
  L9_2 = L9_2(L10_2, L11_2)
  L10_2 = Push
  L11_2 = A1_2
  L12_2 = "recadoCall"
  L13_2 = {}
  L14_2 = A0_2.id
  L13_2.callId = L14_2
  L13_2.event = "joined"
  L14_2 = A0_2.voiceId
  L13_2.voiceId = L14_2
  L13_2.channel = L8_2
  L13_2.call = L9_2
  L14_2 = L9_2.participants
  L13_2.participants = L14_2
  L10_2(L11_2, L12_2, L13_2)
  L10_2 = L63_1
  L11_2 = A0_2
  L12_2 = "state"
  L13_2 = nil
  L14_2 = A1_2
  L10_2(L11_2, L12_2, L13_2, L14_2)
  L10_2 = L19_1
  L11_2 = "%s joined call %s (%d participants)"
  L12_2 = A1_2
  L13_2 = A0_2.id
  L14_2 = L51_1
  L15_2 = A0_2.participants
  L14_2, L15_2 = L14_2(L15_2)
  L10_2(L11_2, L12_2, L13_2, L14_2, L15_2)
  L10_2 = {}
  L10_2.ok = true
  L11_2 = A0_2.id
  L10_2.callId = L11_2
  L11_2 = A0_2.code
  L10_2.code = L11_2
  L10_2.call = L9_2
  return L10_2
end
function L74_1(A0_2, A1_2, A2_2, A3_2)
  local L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2
  -- the decompiled callers can hand over a call id (a number) or nil when the player was not in a call any more
  -- (the register-reuse pattern `L8_2 = L7_2 or L8_2`): there is nothing to leave then. Was: "attempt to index a number value".
  if type(A0_2) ~= "table" then
    return false
  end
  L4_2 = A0_2.participants
  L4_2 = L4_2[A1_2]
  if not L4_2 then
    L5_2 = false
    return L5_2
  end
  L5_2 = L64_1
  L6_2 = A0_2
  L7_2 = A1_2
  L8_2 = L4_2.cid
  L5_2 = L5_2(L6_2, L7_2, L8_2)
  L6_2 = A0_2.participants
  L6_2[A1_2] = nil
  L6_2 = ipairs
  L7_2 = A0_2.order
  L6_2, L7_2, L8_2, L9_2 = L6_2(L7_2)
  for L10_2, L11_2 in L6_2, L7_2, L8_2, L9_2 do
    if L11_2 == A1_2 then
      L12_2 = table
      L12_2 = L12_2.remove
      L13_2 = A0_2.order
      L14_2 = L10_2
      L12_2(L13_2, L14_2)
      break
    end
  end
  L6_2 = A0_2.visible
  L6_2[A1_2] = nil
  L6_2 = A0_2.members
  L6_2[A1_2] = nil
  L6_2 = L12_1
  L6_2 = L6_2[A1_2]
  L7_2 = A0_2.id
  if L6_2 == L7_2 then
    L6_2 = L12_1
    L6_2[A1_2] = nil
  end
  L6_2 = L42_1
  L7_2 = A1_2
  L8_2 = false
  L6_2(L7_2, L8_2)
  L6_2 = L65_1
  L7_2 = A0_2
  L8_2 = L4_2.cid
  L9_2 = "answered"
  L10_2 = L4_2.direction
  L11_2 = Now
  L11_2 = L11_2()
  L12_2 = L4_2.joinedAt
  L11_2 = L11_2 - L12_2
  L11_2 = L11_2 / 1000
  L12_2 = L5_2
  L13_2 = L4_2.joinedAt
  L6_2(L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2)
  L6_2 = Push
  L7_2 = A1_2
  L8_2 = "recadoCall"
  L9_2 = {}
  L10_2 = A0_2.id
  L9_2.callId = L10_2
  L9_2.event = "left"
  L9_2.reason = A2_2
  L6_2(L7_2, L8_2, L9_2)
  L6_2 = next
  L7_2 = A0_2.participants
  L6_2 = L6_2(L7_2)
  if nil == L6_2 then
    L6_2 = L67_1
    L7_2 = A0_2
    L8_2 = "empty"
    L9_2 = A3_2
    L6_2(L7_2, L8_2, L9_2)
    L6_2 = true
    return L6_2
  end
  L6_2 = L69_1
  L7_2 = A0_2
  L6_2(L7_2)
  L6_2 = L63_1
  L7_2 = A0_2
  L6_2(L7_2)
  L6_2 = true
  return L6_2
end
function L75_1(A0_2, A1_2, A2_2)
  local L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2, L19_2
  L3_2 = A0_2.ended
  if L3_2 then
    return
  end
  A0_2.ended = true
  L4_2 = A0_2.id
  L3_2 = L10_1
  L3_2[L4_2] = nil
  L4_2 = A0_2.code
  L3_2 = L11_1
  L3_2 = L3_2[L4_2]
  L4_2 = A0_2.id
  if L3_2 == L4_2 then
    L4_2 = A0_2.code
    L3_2 = L11_1
    L3_2[L4_2] = nil
  end
  L3_2 = L38_1
  L4_2 = "leave"
  L5_2 = A0_2.voiceId
  L3_2(L4_2, L5_2)
  L3_2 = Now
  L3_2 = L3_2()
  L4_2 = pairs
  L5_2 = A0_2.participants
  L4_2, L5_2, L6_2, L7_2 = L4_2(L5_2)
  for L8_2, L9_2 in L4_2, L5_2, L6_2, L7_2 do
    L10_2 = L12_1
    L10_2 = L10_2[L8_2]
    L11_2 = A0_2.id
    if L10_2 == L11_2 then
      L10_2 = L12_1
      L10_2[L8_2] = nil
    end
    L10_2 = L42_1
    L11_2 = L8_2
    L12_2 = false
    L10_2(L11_2, L12_2)
    L10_2 = L65_1
    L11_2 = A0_2
    L12_2 = L9_2.cid
    L13_2 = "answered"
    L14_2 = L9_2.direction
    L15_2 = L9_2.joinedAt
    L15_2 = L3_2 - L15_2
    L15_2 = L15_2 / 1000
    L16_2 = L64_1
    L17_2 = A0_2
    L18_2 = L8_2
    L19_2 = L9_2.cid
    L16_2 = L16_2(L17_2, L18_2, L19_2)
    L17_2 = L9_2.joinedAt
    L10_2(L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2)
    L10_2 = Push
    L11_2 = L8_2
    L12_2 = "recadoCall"
    L13_2 = {}
    L14_2 = A0_2.id
    L13_2.callId = L14_2
    L13_2.event = "ended"
    L13_2.reason = A1_2
    L10_2(L11_2, L12_2, L13_2)
  end
  L4_2 = pairs
  L5_2 = A0_2.ringing
  L4_2, L5_2, L6_2, L7_2 = L4_2(L5_2)
  for L8_2, L9_2 in L4_2, L5_2, L6_2, L7_2 do
    L10_2 = Push
    L11_2 = L9_2.src
    L12_2 = "recadoCall"
    L13_2 = {}
    L14_2 = A0_2.id
    L13_2.callId = L14_2
    L13_2.event = "cancelled"
    L13_2.reason = A1_2
    L10_2(L11_2, L12_2, L13_2)
    if not A2_2 then
      L10_2 = L70_1
      L11_2 = A0_2
      L12_2 = L8_2
      L13_2 = L9_2
      L10_2(L11_2, L12_2, L13_2)
    end
  end
  L4_2 = {}
  L5_2 = {}
  L6_2 = {}
  A0_2.order = L6_2
  A0_2.ringing = L5_2
  A0_2.participants = L4_2
  A0_2.endedAt = L3_2
  if not A2_2 then
    L4_2 = A0_2.finishMessage
    L4_2()
    L4_2 = A0_2.conversation
    if L4_2 then
      L4_2 = A0_2.kind
      if "link" ~= L4_2 then
        L4_2 = L39_1
        L5_2 = "GroupBroadcast"
        L6_2 = A0_2.conversation
        L7_2 = "recadoCall"
        L8_2 = {}
        L9_2 = A0_2.id
        L8_2.callId = L9_2
        L8_2.event = "ended"
        L8_2.status = "ended"
        L8_2.reason = A1_2
        L4_2(L5_2, L6_2, L7_2, L8_2)
      end
    end
  end
  L4_2 = L19_1
  L5_2 = "call %s ended (%s)"
  L6_2 = A0_2.id
  L7_2 = tostring
  L8_2 = A1_2
  L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2, L19_2 = L7_2(L8_2)
  L4_2(L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2, L19_2)
  L4_2 = TriggerEvent
  L5_2 = "apex_phone:recadoCallEnded"
  L6_2 = A0_2.id
  L7_2 = A1_2
  L4_2(L5_2, L6_2, L7_2)
end
L67_1 = L75_1
function L75_1(A0_2)
  local L1_2, L2_2, L3_2, L4_2, L5_2, L6_2, L7_2
  L1_2 = pairs
  L2_2 = L10_1
  L1_2, L2_2, L3_2, L4_2 = L1_2(L2_2)
  for L5_2, L6_2 in L1_2, L2_2, L3_2, L4_2 do
    L7_2 = L6_2.conversation
    if L7_2 == A0_2 then
      L7_2 = L6_2.ended
      if not L7_2 then
        L7_2 = L6_2.kind
        if "link" ~= L7_2 then
          return L6_2
        end
      end
    end
  end
  L1_2 = nil
  return L1_2
end
function L76_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2
  L2_2 = L30_1
  L3_2 = A1_2
  L2_2 = L2_2(L3_2)
  L3_2 = L2_2
  if L2_2 then
    L3_2 = L10_1
    L3_2 = L3_2[L2_2]
  end
  if L3_2 then
    L4_2 = L3_2.participants
    L4_2 = L4_2[A0_2]
    if L4_2 then
      goto lbl_16
    end
  end
  L4_2 = nil
  do return L4_2 end
  ::lbl_16::
  L4_2 = L3_2
  L5_2 = L3_2.participants
  L5_2 = L5_2[A0_2]
  return L4_2, L5_2
end
function L77_1(A0_2, A1_2, A2_2)
  local L3_2, L4_2, L5_2
  L3_2 = A0_2.ringing
  L4_2 = A1_2.number
  L3_2 = L3_2[L4_2]
  if not L3_2 then
    L3_2 = A0_2.invited
    L4_2 = A1_2.number
    L3_2 = L3_2[L4_2]
    if not L3_2 then
      goto lbl_13
    end
  end
  L3_2 = true
  do return L3_2 end
  ::lbl_13::
  L3_2 = A0_2.conversation
  if L3_2 then
    L3_2 = L44_1
    L4_2 = A0_2.conversation
    L5_2 = A1_2.number
    L3_2 = L3_2(L4_2, L5_2)
    if L3_2 then
      L3_2 = true
      return L3_2
    end
  end
  L3_2 = A0_2.open
  if L3_2 and A2_2 then
    L3_2 = L43_1
    L4_2 = A0_2.creatorCid
    L5_2 = A1_2.number
    L3_2 = L3_2(L4_2, L5_2)
    L3_2 = not L3_2
    return L3_2
  end
  L3_2 = false
  return L3_2
end
L78_1 = RPC
function L79_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2
  L2_2 = type
  L3_2 = A1_2
  L2_2 = L2_2(L3_2)
  if "table" ~= L2_2 or not A1_2 then
    L2_2 = {}
    A1_2 = L2_2
  end
  L2_2 = RequireLine
  if L2_2 then
    L2_2 = RequireLine
    L3_2 = A0_2
    L2_2 = L2_2(L3_2)
  end
  if L2_2 then
    return L2_2
  end
  L3_2 = L49_1
  L4_2 = A0_2
  L3_2, L4_2 = L3_2(L4_2)
  if not L3_2 then
    L5_2 = L20_1
    L6_2 = L4_2
    return L5_2(L6_2)
  end
  L5_2 = L40_1
  L6_2 = A0_2
  L5_2 = L5_2(L6_2)
  if not L5_2 then
    L5_2 = L20_1
    L6_2 = "nophone"
    return L5_2(L6_2)
  end
  L5_2 = L30_1
  L6_2 = A1_2.conversation
  L5_2 = L5_2(L6_2)
  if not L5_2 then
    L6_2 = L20_1
    L7_2 = "invalid"
    return L6_2(L7_2)
  end
  L6_2 = L44_1
  L7_2 = L5_2
  L8_2 = L3_2.number
  L6_2 = L6_2(L7_2, L8_2)
  if not L6_2 then
    L6_2 = L20_1
    L7_2 = "notfound"
    return L6_2(L7_2)
  end
  L6_2 = L46_1
  L7_2 = L5_2
  L6_2, L7_2 = L6_2(L7_2)
  if not L6_2 then
    L8_2 = L20_1
    L9_2 = "notfound"
    return L8_2(L9_2)
  end
  L8_2 = L41_1
  L9_2 = A0_2
  L8_2 = L8_2(L9_2)
  if L8_2 then
    L8_2 = L20_1
    L9_2 = "incall"
    return L8_2(L9_2)
  end
  L8_2 = L47_1
  L9_2 = L5_2
  L10_2 = L3_2.number
  L8_2 = L8_2(L9_2, L10_2)
  L9_2 = 0
  while true do
    L10_2 = L13_1
    L10_2 = L10_2[L5_2]
    if not L10_2 then
      break
    end
    L10_2 = L75_1
    L11_2 = L5_2
    L10_2 = L10_2(L11_2)
    if L10_2 then
      break
    end
    L10_2 = 3000
    if not (L9_2 < L10_2) then
      break
    end
    L10_2 = Wait
    L11_2 = 100
    L10_2(L11_2)
    L9_2 = L9_2 + 100
  end
  L10_2 = L75_1
  L11_2 = L5_2
  L10_2 = L10_2(L11_2)
  L11_2 = L12_1
  L11_2 = L11_2[A0_2]
  if L11_2 then
    if L10_2 then
      L11_2 = L12_1
      L11_2 = L11_2[A0_2]
      L12_2 = L10_2.id
      if L11_2 == L12_2 then
        L11_2 = L72_1
        L12_2 = L10_2
        L13_2 = A0_2
        return L11_2(L12_2, L13_2)
      end
    end
    L11_2 = L20_1
    L12_2 = "busy"
    return L11_2(L12_2)
  end
  if L10_2 then
    L11_2 = L73_1
    L12_2 = L10_2
    L13_2 = A0_2
    L14_2 = L3_2
    L15_2 = "in"
    return L11_2(L12_2, L13_2, L14_2, L15_2)
  end
  if not L8_2 then
    L11_2 = L20_1
    L12_2 = "adminsonly"
    return L11_2(L12_2)
  end
  L11_2 = L13_1
  L11_2 = L11_2[L5_2]
  if L11_2 then
    L11_2 = L20_1
    L12_2 = "busy"
    return L11_2(L12_2)
  end
  L11_2 = L13_1
  L11_2[L5_2] = true
  L11_2 = pcall
  function L12_2()
    local L0_3, L1_3, L2_3, L3_3, L4_3, L5_3, L6_3, L7_3, L8_3, L9_3, L10_3, L11_3, L12_3, L13_3, L14_3, L15_3, L16_3, L17_3
    L0_3 = L57_1
    L0_3 = L0_3()
    L1_3 = L75_1
    L2_3 = L5_2
    L1_3 = L1_3(L2_3)
    if L1_3 then
      L2_3 = L73_1
      L3_3 = L1_3
      L4_3 = A0_2
      L5_3 = L3_2
      L6_3 = "in"
      return L2_3(L3_3, L4_3, L5_3, L6_3)
    end
    L2_3 = L68_1
    L3_3 = {}
    L3_3.kind = "group"
    L4_3 = L5_2
    L3_3.conversation = L4_3
    L3_3.code = L0_3
    L4_3 = A1_2.video
    L4_3 = true == L4_3
    L3_3.video = L4_3
    L4_3 = L34_1
    L5_3 = type
    L6_3 = L7_2
    L5_3 = L5_3(L6_3)
    L5_3 = "table" == L5_3 and L5_3
    L6_3 = 60
    L4_3 = L4_3(L5_3, L6_3)
    if not L4_3 then
      L4_3 = "Grupo"
    end
    L3_3.title = L4_3
    L4_3 = L3_2.number
    L3_3.number = L4_3
    L4_3 = L3_2.cid
    L3_3.cid = L4_3
    L2_3 = L2_3(L3_3)
    L3_3 = L73_1
    L4_3 = L2_3
    L5_3 = A0_2
    L6_3 = L3_2
    L7_3 = "out"
    L3_3 = L3_3(L4_3, L5_3, L6_3, L7_3)
    L4_3 = L3_3.ok
    if not L4_3 then
      L4_3 = next
      L5_3 = L2_3.participants
      L4_3 = L4_3(L5_3)
      if nil == L4_3 then
        L4_3 = L67_1
        L5_3 = L2_3
        L6_3 = "empty"
        L7_3 = true
        L4_3(L5_3, L6_3, L7_3)
      end
      return L3_3
    end
    L4_3 = L50_1
    L4_3 = L4_3()
    L5_3 = ipairs
    L6_3 = L39_1
    L7_3 = "GroupMembers"
    L8_3 = L5_2
    L6_3 = L6_3(L7_3, L8_3)
    if not L6_3 then
      L6_3 = {}
    end
    L5_3, L6_3, L7_3, L8_3 = L5_3(L6_3)
    for L9_3, L10_3 in L5_3, L6_3, L7_3, L8_3 do
      L11_3 = tostring
      L12_3 = L10_3
      L11_3 = L11_3(L12_3)
      L10_3 = L11_3
      L11_3 = L3_2.number
      if L10_3 ~= L11_3 then
        L11_3 = L2_3.ended
        if not L11_3 then
          L11_3 = L71_1
          L12_3 = L2_3
          L13_3 = A0_2
          L14_3 = L3_2.number
          L15_3 = L10_3
          L16_3 = L4_3
          L17_3 = true
          L11_3(L12_3, L13_3, L14_3, L15_3, L16_3, L17_3)
        end
      end
    end
    L5_3 = next
    L6_3 = L2_3.ringing
    L5_3 = L5_3(L6_3)
    if nil ~= L5_3 then
      L5_3 = L62_1
      L6_3 = L2_3
      L5_3(L6_3)
      L5_3 = L63_1
      L6_3 = L2_3
      L5_3(L6_3)
    end
    L5_3 = CreateThread
    function L6_3()
      local L0_4, L1_4, L2_4, L3_4, L4_4, L5_4
      L0_4 = {}
      L1_4 = L2_3.id
      L0_4.callId = L1_4
      L1_4 = L2_3.code
      L0_4.code = L1_4
      L1_4 = L2_3.video
      L0_4.video = L1_4
      L0_4.status = "active"
      L1_4 = L2_3.startedAt
      L0_4.startedAt = L1_4
      L1_4 = L66_1
      L2_4 = A0_2
      L3_4 = {}
      L4_4 = L5_2
      L3_4.conversation = L4_4
      L4_4 = L2_3.video
      if L4_4 then
        L4_4 = "Videochamada de grupo"
        if L4_4 then
          goto lbl_25
        end
      end
      L4_4 = "Chamada de voz de grupo"
      ::lbl_25::
      L5_4 = L0_4
      L1_4 = L1_4(L2_4, L3_4, L4_4, L5_4)
      L2_4 = type
      L3_4 = L1_4
      L2_4 = L2_4(L3_4)
      if "table" == L2_4 then
        L2_4 = L30_1
        L3_4 = L1_4.id
        L2_4 = L2_4(L3_4)
        if L2_4 then
          L2_4 = L30_1
          L3_4 = L1_4.id
          L2_4 = L2_4(L3_4)
          L2_3.messagePayload = L0_4
          L2_3.messageId = L2_4
          L2_4 = L2_3.ended
          if L2_4 then
            L2_4 = L2_3.finishMessage
            L2_4()
          end
        end
      end
    end
    L5_3(L6_3)
    L5_3 = L72_1
    L6_3 = L2_3
    L7_3 = A0_2
    return L5_3(L6_3, L7_3)
  end
  L11_2, L12_2 = L11_2(L12_2)
  L13_2 = L13_1
  L13_2[L5_2] = nil
  if not L11_2 then
    L13_2 = error
    L14_2 = L12_2
    L15_2 = 0
    L13_2(L14_2, L15_2)
  end
  return L12_2
end
L78_1["recado.call.start"] = L79_1
function L78_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2
  L2_2 = L18_1
  if not L2_2 then
    L2_2 = nil
    L3_2 = "db"
    return L2_2, L3_2
  end
  L2_2 = MySQL
  L2_2 = L2_2.single
  L2_2 = L2_2.await
  L3_2 = "SELECT code, owner, owner_number, title, video, revoked, expires FROM apex_phone_recado_call_links WHERE code = ?"
  L4_2 = {}
  L5_2 = A0_2
  L4_2[1] = L5_2
  L2_2 = L2_2(L3_2, L4_2)
  if L2_2 then
    L3_2 = L43_1
    L4_2 = L2_2.owner
    L5_2 = A1_2.number
    L3_2 = L3_2(L4_2, L5_2)
    if not L3_2 then
      L3_2 = tonumber
      L4_2 = L2_2.revoked
      L3_2 = L3_2(L4_2)
      if 1 ~= L3_2 then
        goto lbl_32
      end
    end
    L3_2 = nil
    L4_2 = "notfound"
    do return L3_2, L4_2 end
    ::lbl_32::
    L3_2 = tonumber
    L4_2 = L2_2.expires
    L3_2 = L3_2(L4_2)
    if not L3_2 then
      L3_2 = 0
    end
    L4_2 = Now
    L4_2 = L4_2()
    if L3_2 < L4_2 then
      L3_2 = nil
      L4_2 = "expired"
      return L3_2, L4_2
    end
    L3_2 = L11_1
    L3_2 = L3_2[A0_2]
    if L3_2 then
      L4_2 = L10_1
      L4_2 = L4_2[L3_2]
      if L4_2 then
        L4_2 = L10_1
        L4_2 = L4_2[L3_2]
        return L4_2
      end
    end
    L4_2 = L68_1
    L5_2 = {}
    L5_2.kind = "link"
    L5_2.code = A0_2
    L6_2 = L2_2.title
    L5_2.title = L6_2
    L6_2 = tonumber
    L7_2 = L2_2.video
    L6_2 = L6_2(L7_2)
    L6_2 = 1 == L6_2
    L5_2.video = L6_2
    L6_2 = L2_2.owner_number
    L5_2.number = L6_2
    L6_2 = L2_2.owner
    L5_2.cid = L6_2
    L5_2.open = true
    return L4_2(L5_2)
  end
  L3_2 = MySQL
  L3_2 = L3_2.single
  L3_2 = L3_2.await
  L4_2 = "SELECT id, code, owner, owner_number, conversation, `number`, title, video, `start`, cancelled FROM apex_phone_recado_call_scheduled WHERE code = ?"
  L5_2 = {}
  L6_2 = A0_2
  L5_2[1] = L6_2
  L3_2 = L3_2(L4_2, L5_2)
  if L3_2 then
    L4_2 = tonumber
    L5_2 = L3_2.cancelled
    L4_2 = L4_2(L5_2)
    if 1 ~= L4_2 then
      goto lbl_97
    end
  end
  L4_2 = nil
  L5_2 = "notfound"
  do return L4_2, L5_2 end
  ::lbl_97::
  L4_2 = A1_2.cid
  L4_2 = nil ~= L4_2
  L5_2 = L30_1
  L6_2 = L3_2.conversation
  L5_2 = L5_2(L6_2)
  if L5_2 then
    if not L4_2 then
      L6_2 = L44_1
      L7_2 = L5_2
      L8_2 = A1_2.number
      L6_2 = L6_2(L7_2, L8_2)
      if not L6_2 then
        L6_2 = nil
        L7_2 = "notfound"
        return L6_2, L7_2
      end
    end
  else
    L6_2 = L3_2.number
    if L6_2 then
      if not L4_2 then
        L6_2 = tostring
        L7_2 = L3_2.number
        L6_2 = L6_2(L7_2)
        L7_2 = A1_2.number
        if L6_2 ~= L7_2 then
          L6_2 = nil
          L7_2 = "notfound"
          return L6_2, L7_2
        end
      end
    else
      L6_2 = nil
      L7_2 = "notfound"
      return L6_2, L7_2
    end
  end
  L6_2 = tonumber
  L7_2 = L3_2.start
  L6_2 = L6_2(L7_2)
  if not L6_2 then
    L6_2 = 0
  end
  L7_2 = Now
  L7_2 = L7_2()
  L8_2 = L3_1
  L8_2 = L6_2 + L8_2
  if L7_2 > L8_2 then
    L8_2 = nil
    L9_2 = "expired"
    return L8_2, L9_2
  end
  L8_2 = L2_1
  L8_2 = L6_2 - L8_2
  if L7_2 < L8_2 and not L4_2 then
    L8_2 = nil
    L9_2 = "early"
    L10_2 = {}
    L10_2.start = L6_2
    return L8_2, L9_2, L10_2
  end
  if not L5_2 then
    L8_2 = {}
    if L4_2 then
      L9_2 = tostring
      L10_2 = L3_2.number
      L9_2 = L9_2(L10_2)
      if L9_2 then
        goto lbl_184
      end
    end
    L9_2 = tostring
    L10_2 = L3_2.owner_number
    L9_2 = L9_2(L10_2)
    ::lbl_184::
    L8_2.phone = L9_2
    L9_2 = tonumber
    L10_2 = L3_2.video
    L9_2 = L9_2(L10_2)
    L9_2 = 1 == L9_2
    L8_2.video = L9_2
    return L8_2
  end
  L8_2 = L11_1
  L8_2 = L8_2[A0_2]
  if L8_2 then
    L9_2 = L10_1
    L9_2 = L9_2[L8_2]
    if L9_2 then
      L9_2 = L10_1
      L9_2 = L9_2[L8_2]
      return L9_2
    end
  end
  L9_2 = L75_1
  L10_2 = L5_2
  L9_2 = L9_2(L10_2)
  if L9_2 then
    return L9_2
  end
  L10_2 = L39_1
  L11_2 = "GroupInfo"
  L12_2 = L5_2
  L10_2 = L10_2(L11_2, L12_2)
  L11_2 = L68_1
  L12_2 = {}
  L12_2.kind = "scheduled"
  L12_2.conversation = L5_2
  L12_2.code = A0_2
  L13_2 = tonumber
  L14_2 = L3_2.video
  L13_2 = L13_2(L14_2)
  L13_2 = 1 == L13_2
  L12_2.video = L13_2
  L13_2 = tonumber
  L14_2 = L3_2.id
  L13_2 = L13_2(L14_2)
  L12_2.scheduledId = L13_2
  L13_2 = L34_1
  L14_2 = L3_2.title
  L15_2 = 60
  L13_2 = L13_2(L14_2, L15_2)
  if not L13_2 then
    L13_2 = L34_1
    L14_2 = type
    L15_2 = L10_2
    L14_2 = L14_2(L15_2)
    L14_2 = "table" == L14_2 and L14_2
    L15_2 = 60
    L13_2 = L13_2(L14_2, L15_2)
    if not L13_2 then
      L13_2 = "Chamada agendada"
    end
  end
  L12_2.title = L13_2
  L13_2 = L3_2.owner_number
  L12_2.number = L13_2
  L13_2 = L3_2.owner
  L12_2.cid = L13_2
  return L11_2(L12_2)
end
L79_1 = RPC
function L80_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2
  L2_2 = type
  L3_2 = A1_2
  L2_2 = L2_2(L3_2)
  if "table" ~= L2_2 or not A1_2 then
    L2_2 = {}
    A1_2 = L2_2
  end
  L2_2 = L49_1
  L3_2 = A0_2
  L2_2, L3_2 = L2_2(L3_2)
  if not L2_2 then
    L4_2 = L20_1
    L5_2 = L3_2
    return L4_2(L5_2)
  end
  L4_2 = L40_1
  L5_2 = A0_2
  L4_2 = L4_2(L5_2)
  if not L4_2 then
    L4_2 = L20_1
    L5_2 = "nophone"
    return L4_2(L5_2)
  end
  L4_2 = L41_1
  L5_2 = A0_2
  L4_2 = L4_2(L5_2)
  if L4_2 then
    L4_2 = L20_1
    L5_2 = "incall"
    return L4_2(L5_2)
  end
  L4_2 = L12_1
  L4_2 = L4_2[A0_2]
  if L4_2 then
    L4_2 = L12_1
    L5_2 = L4_2[A0_2]
    L4_2 = L10_1
    L4_2 = L4_2[L5_2]
    if L4_2 then
      L4_2 = L12_1
      L5_2 = L4_2[A0_2]
      L4_2 = L10_1
      L4_2 = L4_2[L5_2]
      L5_2 = A1_2.callId
      L5_2 = nil ~= L5_2
      L6_2 = A1_2.code
      L6_2 = nil ~= L6_2
      if L5_2 or L6_2 then
        L7_2 = L72_1
        L8_2 = L4_2
        L9_2 = A0_2
        return L7_2(L8_2, L9_2)
      end
      L7_2 = L20_1
      L8_2 = "busy"
      return L7_2(L8_2)
    end
  end
  L4_2 = nil
  L5_2 = A1_2.callId
  if nil ~= L5_2 then
    L5_2 = L30_1
    L6_2 = A1_2.callId
    L5_2 = L5_2(L6_2)
    if not L5_2 then
      L5_2 = -1
    end
    L6_2 = L10_1
    L4_2 = L6_2[L5_2]
    if not L4_2 then
      L5_2 = L20_1
      L6_2 = "notfound"
      return L5_2(L6_2)
    end
  else
    L5_2 = A1_2.code
    if nil ~= L5_2 then
      L5_2 = L37_1
      L6_2 = A1_2.code
      L5_2 = L5_2(L6_2)
      if not L5_2 then
        L6_2 = L20_1
        L7_2 = "badcode"
        return L6_2(L7_2)
      end
      L6_2 = L11_1
      L6_2 = L6_2[L5_2]
      if L6_2 then
        L7_2 = L10_1
        L7_2 = L7_2[L6_2]
        if L7_2 then
          goto lbl_127
          L4_2 = L7_2 or L4_2
        end
      end
      L4_2 = nil
      ::lbl_127::
      if L4_2 then
        goto lbl_198
      end
      L7_2 = 0
      while true do
        L8_2 = L14_1
        L8_2 = L8_2[L5_2]
        if not L8_2 then
          break
        end
        L8_2 = 3000
        if not (L7_2 < L8_2) then
          break
        end
        L8_2 = Wait
        L9_2 = 100
        L8_2(L9_2)
        L7_2 = L7_2 + 100
      end
      L8_2 = L11_1
      L6_2 = L8_2[L5_2]
      if L6_2 then
        L8_2 = L10_1
        L8_2 = L8_2[L6_2]
        if L8_2 then
          goto lbl_152
          L4_2 = L8_2 or L4_2
        end
      end
      L4_2 = nil
      ::lbl_152::
      if not L4_2 then
        L8_2 = L14_1
        L8_2[L5_2] = true
        L8_2 = pcall
        L9_2 = L78_1
        L10_2 = L5_2
        L11_2 = L2_2
        L8_2, L9_2, L10_2, L11_2 = L8_2(L9_2, L10_2, L11_2)
        L12_2 = L14_1
        L12_2[L5_2] = nil
        if not L8_2 then
          L12_2 = error
          L13_2 = L9_2
          L14_2 = 0
          L12_2(L13_2, L14_2)
        end
        if not L9_2 then
          L12_2 = L20_1
          L13_2 = L10_2 or L13_2
          if not L10_2 then
            L13_2 = "notfound"
          end
          L14_2 = L11_2
          return L12_2(L13_2, L14_2)
        end
        L12_2 = L9_2.phone
        if L12_2 then
          L12_2 = {}
          L12_2.ok = true
          L13_2 = L9_2.phone
          L12_2.phone = L13_2
          L13_2 = L9_2.video
          L12_2.video = L13_2
          return L12_2
        end
        L4_2 = L9_2
        L12_2 = L4_2.invited
        L13_2 = L2_2.number
        L12_2[L13_2] = true
      end
    else
      L5_2 = L20_1
      L6_2 = "invalid"
      return L5_2(L6_2)
    end
  end
  ::lbl_198::
  L5_2 = L4_2.participants
  L5_2 = L5_2[A0_2]
  if L5_2 then
    L5_2 = L72_1
    L6_2 = L4_2
    L7_2 = A0_2
    return L5_2(L6_2, L7_2)
  end
  function L5_2(A0_3)
    local L1_3, L2_3, L3_3, L4_3
    L1_3 = L4_2.ended
    if not L1_3 then
      L1_3 = next
      L2_3 = L4_2.participants
      L1_3 = L1_3(L2_3)
      if nil == L1_3 then
        L1_3 = next
        L2_3 = L4_2.ringing
        L1_3 = L1_3(L2_3)
        if nil == L1_3 then
          L1_3 = L67_1
          L2_3 = L4_2
          L3_3 = "empty"
          L4_3 = true
          L1_3(L2_3, L3_3, L4_3)
        end
      end
    end
    L1_3 = L20_1
    L2_3 = A0_3
    return L1_3(L2_3)
  end
  L6_2 = L12_1
  L6_2 = L6_2[A0_2]
  if L6_2 then
    L6_2 = L12_1
    L6_2 = L6_2[A0_2]
    L7_2 = L4_2.id
    if L6_2 ~= L7_2 then
      L6_2 = L5_2
      L7_2 = "busy"
      return L6_2(L7_2)
    end
  end
  L6_2 = L77_1
  L7_2 = L4_2
  L8_2 = L2_2
  L9_2 = A1_2.callId
  L9_2 = nil == L9_2
  L6_2 = L6_2(L7_2, L8_2, L9_2)
  if not L6_2 then
    L6_2 = L5_2
    L7_2 = "notfound"
    return L6_2(L7_2)
  end
  L6_2 = L73_1
  L7_2 = L4_2
  L8_2 = A0_2
  L9_2 = L2_2
  L10_2 = L4_2.kind
  if "group" ~= L10_2 then
    L10_2 = L2_2.cid
    if L10_2 then
      L10_2 = L2_2.cid
      L11_2 = L4_2.creatorCid
      if L10_2 == L11_2 then
        L10_2 = "out"
        if L10_2 then
          goto lbl_254
        end
      end
    end
  end
  L10_2 = "in"
  ::lbl_254::
  L6_2 = L6_2(L7_2, L8_2, L9_2, L10_2)
  L7_2 = L6_2.ok
  if not L7_2 then
    L7_2 = L5_2
    L8_2 = L6_2.error
    if not L8_2 then
      L8_2 = "notfound"
    end
    return L7_2(L8_2)
  end
  return L6_2
end
L79_1["recado.call.join"] = L80_1
L79_1 = RPC
function L80_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2, L6_2
  L2_2 = type
  L3_2 = A1_2
  L2_2 = L2_2(L3_2)
  if "table" ~= L2_2 or not A1_2 then
    L2_2 = {}
    A1_2 = L2_2
  end
  L2_2 = L76_1
  L3_2 = A0_2
  L4_2 = A1_2.callId
  L2_2 = L2_2(L3_2, L4_2)
  if not L2_2 then
    L3_2 = L20_1
    L4_2 = "notfound"
    return L3_2(L4_2)
  end
  L3_2 = L74_1
  L4_2 = L2_2
  L5_2 = A0_2
  L6_2 = "left"
  L3_2(L4_2, L5_2, L6_2)
  L3_2 = {}
  L3_2.ok = true
  return L3_2
end
L79_1["recado.call.leave"] = L80_1
L79_1 = RPC
function L80_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2
  L2_2 = type
  L3_2 = A1_2
  L2_2 = L2_2(L3_2)
  if "table" ~= L2_2 or not A1_2 then
    L2_2 = {}
    A1_2 = L2_2
  end
  L2_2 = L30_1
  L3_2 = A1_2.callId
  L2_2 = L2_2(L3_2)
  if not L2_2 then
    L2_2 = -1
  end
  L3_2 = L10_1
  L2_2 = L3_2[L2_2]
  L3_2 = GetPlayerNumber
  L4_2 = A0_2
  L3_2 = L3_2(L4_2)
  L4_2 = L2_2 or L4_2
  L4_2 = L3_2 or L4_2
  if L2_2 and L3_2 then
    L4_2 = L2_2.ringing
    L5_2 = tostring
    L6_2 = L3_2
    L5_2 = L5_2(L6_2)
    L4_2 = L4_2[L5_2]
  end
  if L4_2 then
    L5_2 = L4_2.src
    if L5_2 == A0_2 then
      goto lbl_40
    end
  end
  L5_2 = L20_1
  L6_2 = "notfound"
  do return L5_2(L6_2) end
  ::lbl_40::
  L5_2 = L2_2.ringing
  L6_2 = tostring
  L7_2 = L3_2
  L6_2 = L6_2(L7_2)
  L5_2[L6_2] = nil
  L5_2 = L70_1
  L6_2 = L2_2
  L7_2 = tostring
  L8_2 = L3_2
  L7_2 = L7_2(L8_2)
  L8_2 = L4_2
  L9_2 = A1_2.busy
  if L9_2 then
    L9_2 = "missed"
    if L9_2 then
      goto lbl_58
    end
  end
  L9_2 = "declined"
  ::lbl_58::
  L5_2(L6_2, L7_2, L8_2, L9_2)
  L5_2 = Push
  L6_2 = A0_2
  L7_2 = "recadoCall"
  L8_2 = {}
  L9_2 = L2_2.id
  L8_2.callId = L9_2
  L8_2.event = "cancelled"
  L8_2.reason = "declined"
  L5_2(L6_2, L7_2, L8_2)
  L5_2 = L63_1
  L6_2 = L2_2
  L5_2(L6_2)
  L5_2 = {}
  L5_2.ok = true
  return L5_2
end
L79_1["recado.call.decline"] = L80_1
L79_1 = RPC
function L80_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2
  L2_2 = type
  L3_2 = A1_2
  L2_2 = L2_2(L3_2)
  if "table" ~= L2_2 or not A1_2 then
    L2_2 = {}
    A1_2 = L2_2
  end
  L2_2 = L49_1
  L3_2 = A0_2
  L2_2, L3_2 = L2_2(L3_2)
  if not L2_2 then
    L4_2 = L20_1
    L5_2 = L3_2
    return L4_2(L5_2)
  end
  L4_2 = L30_1
  L5_2 = A1_2.callId
  L4_2 = L4_2(L5_2)
  if not L4_2 then
    L4_2 = -1
  end
  L5_2 = L10_1
  L4_2 = L5_2[L4_2]
  if not L4_2 then
    L5_2 = L20_1
    L6_2 = "notfound"
    return L5_2(L6_2)
  end
  L5_2 = L4_2.participants
  L5_2 = L5_2[A0_2]
  if not L5_2 then
    L5_2 = L4_2.conversation
    if L5_2 then
      L5_2 = L44_1
      L6_2 = L4_2.conversation
      L7_2 = L2_2.number
      L5_2 = L5_2(L6_2, L7_2)
      if L5_2 then
        goto lbl_51
      end
    end
    L5_2 = L20_1
    L6_2 = "notfound"
    return L5_2(L6_2)
  end
  ::lbl_51::
  L5_2 = L59_1
  L6_2 = L4_2
  L7_2 = L2_2.number
  L8_2 = L2_2.cid
  L5_2 = L5_2(L6_2, L7_2, L8_2)
  if not L5_2 then
    L5_2 = L20_1
    L6_2 = "notallowed"
    return L5_2(L6_2)
  end
  L5_2 = L67_1
  L6_2 = L4_2
  L7_2 = "ended"
  L5_2(L6_2, L7_2)
  L5_2 = {}
  L5_2.ok = true
  return L5_2
end
L79_1["recado.call.end"] = L80_1
L79_1 = RPC
function L80_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2
  L2_2 = type
  L3_2 = A1_2
  L2_2 = L2_2(L3_2)
  if "table" ~= L2_2 or not A1_2 then
    L2_2 = {}
    A1_2 = L2_2
  end
  L2_2 = L49_1
  L3_2 = A0_2
  L2_2, L3_2 = L2_2(L3_2)
  if not L2_2 then
    L4_2 = L20_1
    L5_2 = L3_2
    return L4_2(L5_2)
  end
  L4_2 = {}
  L4_2.ok = true
  L5_2 = {}
  L4_2.ringing = L5_2
  L5_2 = A1_2.callId
  if nil ~= L5_2 then
    L5_2 = L30_1
    L6_2 = A1_2.callId
    L5_2 = L5_2(L6_2)
    if not L5_2 then
      L5_2 = -1
    end
    L6_2 = L10_1
    L5_2 = L6_2[L5_2]
    if not L5_2 then
      L6_2 = L20_1
      L7_2 = "notfound"
      return L6_2(L7_2)
    end
    L6_2 = L5_2.participants
    L6_2 = L6_2[A0_2]
    if L6_2 then
      L6_2 = L60_1
      L7_2 = L5_2
      L8_2 = A0_2
      L6_2 = L6_2(L7_2, L8_2)
      L4_2.call = L6_2
    else
      L6_2 = L5_2.ringing
      L7_2 = L2_2.number
      L6_2 = L6_2[L7_2]
      if not L6_2 then
        L6_2 = L5_2.invited
        L7_2 = L2_2.number
        L6_2 = L6_2[L7_2]
        if not L6_2 then
          L6_2 = L5_2.conversation
          if not L6_2 then
            goto lbl_81
          end
          L6_2 = L44_1
          L7_2 = L5_2.conversation
          L8_2 = L2_2.number
          L6_2 = L6_2(L7_2, L8_2)
          if not L6_2 then
            goto lbl_81
          end
        end
      end
      L6_2 = L61_1
      L7_2 = L5_2
      L8_2 = L2_2.number
      L9_2 = L5_2.creatorNumber
      L6_2 = L6_2(L7_2, L8_2, L9_2)
      L4_2.call = L6_2
      L6_2 = L4_2.call
      L6_2.joinable = true
      goto lbl_100
      ::lbl_81::
      L6_2 = L20_1
      L7_2 = "notfound"
      return L6_2(L7_2)
    end
  else
    L5_2 = L12_1
    L5_2 = L5_2[A0_2]
    if L5_2 then
      L6_2 = L10_1
      L6_2 = L6_2[L5_2]
      if L6_2 then
        L6_2 = L60_1
        L7_2 = L10_1
        L7_2 = L7_2[L5_2]
        L8_2 = A0_2
        L6_2 = L6_2(L7_2, L8_2)
        L4_2.call = L6_2
      end
    end
  end
  ::lbl_100::
  L5_2 = pairs
  L6_2 = L10_1
  L5_2, L6_2, L7_2, L8_2 = L5_2(L6_2)
  for L9_2, L10_2 in L5_2, L6_2, L7_2, L8_2 do
    L11_2 = L10_2.ringing
    L12_2 = L2_2.number
    L11_2 = L11_2[L12_2]
    if L11_2 then
      L12_2 = L11_2.src
      if L12_2 == A0_2 then
        L12_2 = L4_2.ringing
        L13_2 = L4_2.ringing
        L13_2 = #L13_2
        L13_2 = L13_2 + 1
        L14_2 = {}
        L15_2 = L10_2.id
        L14_2.callId = L15_2
        L15_2 = L11_2.by
        L14_2.from = L15_2
        L15_2 = L61_1
        L16_2 = L10_2
        L17_2 = L2_2.number
        L18_2 = L11_2.by
        L15_2 = L15_2(L16_2, L17_2, L18_2)
        L14_2.call = L15_2
        L12_2[L13_2] = L14_2
      end
    end
  end
  return L4_2
end
L79_1["recado.call.state"] = L80_1
L79_1 = RPC
function L80_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2, L6_2
  L2_2 = type
  L3_2 = A1_2
  L2_2 = L2_2(L3_2)
  if "table" ~= L2_2 or not A1_2 then
    L2_2 = {}
    A1_2 = L2_2
  end
  L2_2 = L76_1
  L3_2 = A0_2
  L4_2 = A1_2.callId
  L2_2, L3_2 = L2_2(L3_2, L4_2)
  if not L2_2 then
    L4_2 = L20_1
    L5_2 = "notfound"
    return L4_2(L5_2)
  end
  L4_2 = A1_2.on
  L4_2 = true == L4_2
  L5_2 = L3_2.muted
  if L5_2 ~= L4_2 then
    L3_2.muted = L4_2
    L5_2 = L63_1
    L6_2 = L2_2
    L5_2(L6_2)
  end
  L5_2 = {}
  L5_2.ok = true
  return L5_2
end
L79_1["recado.call.mute"] = L80_1
L79_1 = RPC
function L80_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2, L6_2
  L2_2 = type
  L3_2 = A1_2
  L2_2 = L2_2(L3_2)
  if "table" ~= L2_2 or not A1_2 then
    L2_2 = {}
    A1_2 = L2_2
  end
  L2_2 = L76_1
  L3_2 = A0_2
  L4_2 = A1_2.callId
  L2_2, L3_2 = L2_2(L3_2, L4_2)
  if not L2_2 then
    L4_2 = L20_1
    L5_2 = "notfound"
    return L4_2(L5_2)
  end
  L4_2 = A1_2.on
  L4_2 = true == L4_2
  L5_2 = L3_2.video
  if L5_2 ~= L4_2 then
    L3_2.video = L4_2
    L5_2 = L63_1
    L6_2 = L2_2
    L5_2(L6_2)
  end
  L5_2 = {}
  L5_2.ok = true
  L5_2.simulated = true
  return L5_2
end
L79_1["recado.call.video"] = L80_1
L79_1 = RPC
function L80_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2, L6_2
  L2_2 = type
  L3_2 = A1_2
  L2_2 = L2_2(L3_2)
  if "table" ~= L2_2 or not A1_2 then
    L2_2 = {}
    A1_2 = L2_2
  end
  L2_2 = L76_1
  L3_2 = A0_2
  L4_2 = A1_2.callId
  L2_2, L3_2 = L2_2(L3_2, L4_2)
  if not L2_2 then
    L4_2 = L20_1
    L5_2 = "notfound"
    return L4_2(L5_2)
  end
  L4_2 = A1_2.on
  L4_2 = true == L4_2
  L5_2 = L3_2.hand
  L5_2 = L5_2 > 0
  if L5_2 ~= L4_2 then
    if L4_2 then
      L5_2 = Now
      L5_2 = L5_2()
      if L5_2 then
        goto lbl_40
      end
    end
    L5_2 = 0
    ::lbl_40::
    L3_2.hand = L5_2
    L5_2 = L63_1
    L6_2 = L2_2
    L5_2(L6_2)
  end
  L5_2 = {}
  L5_2.ok = true
  return L5_2
end
L79_1["recado.call.hand"] = L80_1
L79_1 = RPC
function L80_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2
  L2_2 = type
  L3_2 = A1_2
  L2_2 = L2_2(L3_2)
  if "table" ~= L2_2 or not A1_2 then
    L2_2 = {}
    A1_2 = L2_2
  end
  L2_2 = L76_1
  L3_2 = A0_2
  L4_2 = A1_2.callId
  L2_2 = L2_2(L3_2, L4_2)
  if not L2_2 then
    L3_2 = L20_1
    L4_2 = "notfound"
    return L3_2(L4_2)
  end
  L3_2 = L29_1
  L3_2()
  L3_2 = type
  L4_2 = A1_2.emoji
  L3_2 = L3_2(L4_2)
  if "string" == L3_2 then
    L4_2 = A1_2.emoji
    L3_2 = L28_1
    L3_2 = L3_2[L4_2]
    if L3_2 then
      goto lbl_37
    end
  end
  L3_2 = L20_1
  L4_2 = "badreaction"
  do return L3_2(L4_2) end
  ::lbl_37::
  L3_2 = GetGameTimer
  L3_2 = L3_2()
  L4_2 = L15_1
  L4_2 = L4_2[A0_2]
  if L4_2 then
    L4_2 = L15_1
    L4_2 = L4_2[A0_2]
    L4_2 = L3_2 - L4_2
    L5_2 = L8_1
    if L4_2 < L5_2 then
      L4_2 = L20_1
      L5_2 = "cooldown"
      return L4_2(L5_2)
    end
  end
  L4_2 = L15_1
  L4_2[A0_2] = L3_2
  L4_2 = pairs
  L5_2 = L2_2.participants
  L4_2, L5_2, L6_2, L7_2 = L4_2(L5_2)
  for L8_2 in L4_2, L5_2, L6_2, L7_2 do
    if L8_2 ~= A0_2 then
      L9_2 = Push
      L10_2 = L8_2
      L11_2 = "recadoCall"
      L12_2 = {}
      L13_2 = L2_2.id
      L12_2.callId = L13_2
      L12_2.event = "react"
      L12_2.from = A0_2
      L13_2 = A1_2.emoji
      L12_2.emoji = L13_2
      L9_2(L10_2, L11_2, L12_2)
    end
  end
  L4_2 = {}
  L4_2.ok = true
  return L4_2
end
L79_1["recado.call.react"] = L80_1
L79_1 = RPC
function L80_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2, L19_2, L20_2, L21_2, L22_2, L23_2, L24_2, L25_2
  L2_2 = type
  L3_2 = A1_2
  L2_2 = L2_2(L3_2)
  if "table" ~= L2_2 or not A1_2 then
    L2_2 = {}
    A1_2 = L2_2
  end
  L2_2 = L76_1
  L3_2 = A0_2
  L4_2 = A1_2.callId
  L2_2, L3_2 = L2_2(L3_2, L4_2)
  if not L2_2 then
    L4_2 = L20_1
    L5_2 = "notfound"
    return L4_2(L5_2)
  end
  L4_2 = A1_2.numbers
  if nil == L4_2 then
    L5_2 = A1_2.number
    if nil ~= L5_2 then
      L5_2 = {}
      L6_2 = A1_2.number
      L5_2[1] = L6_2
      L4_2 = L5_2
    end
  end
  L5_2 = type
  L6_2 = L4_2
  L5_2 = L5_2(L6_2)
  if "table" ~= L5_2 then
    L5_2 = L20_1
    L6_2 = "invalid"
    return L5_2(L6_2)
  end
  L5_2 = {}
  L6_2 = {}
  L7_2 = ipairs
  L8_2 = L4_2
  L7_2, L8_2, L9_2, L10_2 = L7_2(L8_2)
  for L11_2, L12_2 in L7_2, L8_2, L9_2, L10_2 do
    L13_2 = L24_1
    L13_2 = L13_2()
    if L11_2 > L13_2 then
      L13_2 = L20_1
      L14_2 = "limit"
      L13_2, L14_2, L15_2, L16_2, L17_2, L18_2, L19_2, L20_2, L21_2, L22_2, L23_2, L24_2, L25_2 = L13_2(L14_2)
      return L13_2, L14_2, L15_2, L16_2, L17_2, L18_2, L19_2, L20_2, L21_2, L22_2, L23_2, L24_2, L25_2
    end
    L13_2 = L35_1
    L14_2 = L12_2
    L13_2 = L13_2(L14_2)
    if not L13_2 then
      L14_2 = L20_1
      L15_2 = "invalid"
      L14_2, L15_2, L16_2, L17_2, L18_2, L19_2, L20_2, L21_2, L22_2, L23_2, L24_2, L25_2 = L14_2(L15_2)
      return L14_2, L15_2, L16_2, L17_2, L18_2, L19_2, L20_2, L21_2, L22_2, L23_2, L24_2, L25_2
    end
    L14_2 = L6_2[L13_2]
    if not L14_2 then
      L6_2[L13_2] = true
      L14_2 = #L5_2
      L14_2 = L14_2 + 1
      L5_2[L14_2] = L13_2
    end
  end
  L7_2 = #L5_2
  if 0 == L7_2 then
    L7_2 = L20_1
    L8_2 = "invalid"
    return L7_2(L8_2)
  end
  L7_2 = L50_1
  L7_2 = L7_2()
  L8_2 = {}
  L9_2 = L2_2.notified
  if not L9_2 then
    L9_2 = {}
  end
  L2_2.notified = L9_2
  L9_2 = ipairs
  L10_2 = L5_2
  L9_2, L10_2, L11_2, L12_2 = L9_2(L10_2)
  for L13_2, L14_2 in L9_2, L10_2, L11_2, L12_2 do
    L15_2 = L2_2.ended
    if L15_2 then
      break
    end
    L15_2 = L71_1
    L16_2 = L2_2
    L17_2 = A0_2
    L18_2 = L3_2.number
    L19_2 = L14_2
    L20_2 = L7_2
    L21_2 = L2_2.conversation
    L21_2 = L44_1
    L22_2 = L2_2.conversation
    L23_2 = L14_2
    L21_2 = nil ~= L21_2 and L21_2
    L15_2 = L15_2(L16_2, L17_2, L18_2, L19_2, L20_2, L21_2)
    if "unavailable" == L15_2 then
      L15_2 = "offline"
    end
    if "offline" == L15_2 then
      L16_2 = L2_2.invited
      L16_2 = L16_2[L14_2]
      if L16_2 then
        L16_2 = L2_2.notified
        L16_2 = L16_2[L14_2]
        if not L16_2 then
          L16_2 = L51_1
          L17_2 = L2_2.notified
          L16_2 = L16_2(L17_2)
          if L16_2 < 16 then
            L16_2 = L2_2.notified
            L16_2[L14_2] = true
            L16_2 = GetCitizenIdByNumber
            L17_2 = L14_2
            L16_2 = L16_2(L17_2)
            if L16_2 then
              L17_2 = L43_1
              L18_2 = L16_2
              L19_2 = L3_2.number
              L17_2 = L17_2(L18_2, L19_2)
              if not L17_2 then
                L17_2 = L39_1
                L18_2 = "RecadoSilenceUnknown"
                L19_2 = L14_2
                L20_2 = L3_2.number
                L17_2 = L17_2(L18_2, L19_2, L20_2)
                if true ~= L17_2 then
                  L17_2 = NotifyCitizen
                  L18_2 = L16_2
                  L19_2 = "recado"
                  L20_2 = L2_2.title
                  L21_2 = "Convidaram-te para uma chamada de grupo"
                  L22_2 = {}
                  L23_2 = {}
                  L24_2 = L2_2.id
                  L23_2.callId = L24_2
                  L24_2 = L2_2.code
                  L23_2.code = L24_2
                  L22_2.recadoCall = L23_2
                  L22_2.sys = "m"
                  L23_2 = {}
                  L24_2 = {}
                  L25_2 = {}
                  L25_2.id = "recado_call_join"
                  L25_2.label = "Entrar"
                  L24_2[1] = L25_2
                  L23_2.actions = L24_2
                  L17_2(L18_2, L19_2, L20_2, L21_2, L22_2, L23_2)
                end
              end
            end
          end
        end
      end
    end
    L8_2[L14_2] = L15_2
  end
  L9_2 = L62_1
  L10_2 = L2_2
  L9_2(L10_2)
  L9_2 = L63_1
  L10_2 = L2_2
  L9_2(L10_2)
  L9_2 = {}
  L9_2.ok = true
  L9_2.results = L8_2
  return L9_2
end
L79_1["recado.call.invite"] = L80_1
L79_1 = RPC
function L80_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2
  L2_2 = type
  L3_2 = A1_2
  L2_2 = L2_2(L3_2)
  if "table" ~= L2_2 or not A1_2 then
    L2_2 = {}
    A1_2 = L2_2
  end
  L2_2 = L49_1
  L3_2 = A0_2
  L2_2, L3_2 = L2_2(L3_2)
  if not L2_2 then
    L4_2 = L20_1
    L5_2 = L3_2
    return L4_2(L5_2)
  end
  L4_2 = L2_2.cid
  if not L4_2 then
    L4_2 = L20_1
    L5_2 = "noidentity"
    return L4_2(L5_2)
  end
  L4_2 = L18_1
  if not L4_2 then
    L4_2 = L20_1
    L5_2 = "db"
    return L4_2(L5_2)
  end
  L4_2 = A1_2.title
  if nil ~= L4_2 then
    L4_2 = L34_1
    L5_2 = A1_2.title
    L6_2 = 60
    L4_2 = L4_2(L5_2, L6_2)
    if L4_2 then
      goto lbl_44
    end
  end
  L4_2 = "Chamada Recado"
  ::lbl_44::
  if not L4_2 then
    L5_2 = L20_1
    L6_2 = "badtitle"
    return L5_2(L6_2)
  end
  L5_2 = Now
  L5_2 = L5_2()
  L6_2 = MySQL
  L6_2 = L6_2.scalar
  L6_2 = L6_2.await
  L7_2 = "SELECT COUNT(*) FROM apex_phone_recado_call_links WHERE owner = ? AND revoked = 0 AND expires > ?"
  L8_2 = {}
  L9_2 = L2_2.cid
  L10_2 = L5_2
  L8_2[1] = L9_2
  L8_2[2] = L10_2
  L6_2 = L6_2(L7_2, L8_2)
  L7_2 = tonumber
  L8_2 = L6_2
  L7_2 = L7_2(L8_2)
  if not L7_2 then
    L7_2 = 0
  end
  L8_2 = L6_1
  if L7_2 >= L8_2 then
    L7_2 = L20_1
    L8_2 = "limit"
    L9_2 = {}
    L10_2 = L6_1
    L9_2.max = L10_2
    return L7_2(L8_2, L9_2)
  end
  L7_2 = L57_1
  L7_2 = L7_2()
  L8_2 = A1_2.video
  L8_2 = true == L8_2
  L9_2 = MySQL
  L9_2 = L9_2.insert
  L9_2 = L9_2.await
  L10_2 = "INSERT INTO apex_phone_recado_call_links (code, owner, owner_number, title, video, revoked, created, expires) VALUES (?, ?, ?, ?, ?, 0, ?, ?)"
  L11_2 = {}
  L12_2 = L7_2
  L13_2 = L2_2.cid
  L14_2 = L2_2.number
  L15_2 = L4_2
  if L8_2 then
    L16_2 = 1
    if L16_2 then
      goto lbl_102
    end
  end
  L16_2 = 0
  ::lbl_102::
  L17_2 = L5_2
  L18_2 = L5_1
  L18_2 = L5_2 + L18_2
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
  L10_2 = {}
  L10_2.code = L7_2
  L10_2.title = L4_2
  L10_2.video = L8_2
  L10_2.created = L5_2
  L11_2 = L5_1
  L11_2 = L5_2 + L11_2
  L10_2.expires = L11_2
  L9_2.link = L10_2
  return L9_2
end
L79_1["recado.call.link"] = L80_1
L79_1 = RPC
function L80_1(A0_2)
  local L1_2, L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2
  L1_2 = L49_1
  L2_2 = A0_2
  L1_2, L2_2 = L1_2(L2_2)
  if not L1_2 then
    L3_2 = L20_1
    L4_2 = L2_2
    return L3_2(L4_2)
  end
  L3_2 = L1_2.cid
  if L3_2 then
    L3_2 = L18_1
    if L3_2 then
      goto lbl_23
    end
  end
  L3_2 = {}
  L3_2.ok = true
  L4_2 = {}
  L3_2.items = L4_2
  do return L3_2 end
  ::lbl_23::
  L3_2 = MySQL
  L3_2 = L3_2.query
  L3_2 = L3_2.await
  L4_2 = "SELECT code, title, video, created, expires FROM apex_phone_recado_call_links WHERE owner = ? AND revoked = 0 AND expires > ? ORDER BY created DESC LIMIT ?"
  L5_2 = {}
  L6_2 = L1_2.cid
  L7_2 = Now
  L7_2 = L7_2()
  L8_2 = L6_1
  L5_2[1] = L6_2
  L5_2[2] = L7_2
  L5_2[3] = L8_2
  L3_2 = L3_2(L4_2, L5_2)
  if not L3_2 then
    L3_2 = {}
  end
  L4_2 = {}
  L5_2 = ipairs
  L6_2 = L3_2
  L5_2, L6_2, L7_2, L8_2 = L5_2(L6_2)
  for L9_2, L10_2 in L5_2, L6_2, L7_2, L8_2 do
    L12_2 = L10_2.code
    L11_2 = L11_1
    L11_2 = L11_2[L12_2]
    L12_2 = #L4_2
    L12_2 = L12_2 + 1
    L13_2 = {}
    L14_2 = L10_2.code
    L13_2.code = L14_2
    L14_2 = L10_2.title
    L13_2.title = L14_2
    L14_2 = tonumber
    L15_2 = L10_2.video
    L14_2 = L14_2(L15_2)
    L14_2 = 1 == L14_2
    L13_2.video = L14_2
    L14_2 = tonumber
    L15_2 = L10_2.created
    L14_2 = L14_2(L15_2)
    L13_2.created = L14_2
    L14_2 = tonumber
    L15_2 = L10_2.expires
    L14_2 = L14_2(L15_2)
    L13_2.expires = L14_2
    L14_2 = nil ~= L11_2
    L13_2.live = L14_2
    if L11_2 then
      L14_2 = L10_1
      L14_2 = L14_2[L11_2]
      if L14_2 then
        L14_2 = L51_1
        L15_2 = L10_1
        L15_2 = L15_2[L11_2]
        L15_2 = L15_2.participants
        L14_2 = L14_2(L15_2)
        if L14_2 then
          goto lbl_96
        end
      end
    end
    L14_2 = 0
    ::lbl_96::
    L13_2.count = L14_2
    L4_2[L12_2] = L13_2
  end
  L5_2 = {}
  L5_2.ok = true
  L5_2.items = L4_2
  return L5_2
end
L79_1["recado.call.links"] = L80_1
L79_1 = RPC
function L80_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2
  L2_2 = type
  L3_2 = A1_2
  L2_2 = L2_2(L3_2)
  if "table" ~= L2_2 or not A1_2 then
    L2_2 = {}
    A1_2 = L2_2
  end
  L2_2 = L49_1
  L3_2 = A0_2
  L2_2, L3_2 = L2_2(L3_2)
  if not L2_2 then
    L4_2 = L20_1
    L5_2 = L3_2
    return L4_2(L5_2)
  end
  L4_2 = L37_1
  L5_2 = A1_2.code
  L4_2 = L4_2(L5_2)
  if not L4_2 then
    L5_2 = L20_1
    L6_2 = "badcode"
    return L5_2(L6_2)
  end
  L5_2 = L2_2.cid
  if L5_2 then
    L5_2 = L18_1
    if L5_2 then
      goto lbl_39
    end
  end
  L5_2 = L20_1
  L6_2 = "db"
  do return L5_2(L6_2) end
  ::lbl_39::
  L5_2 = MySQL
  L5_2 = L5_2.update
  L5_2 = L5_2.await
  L6_2 = "UPDATE apex_phone_recado_call_links SET revoked = 1 WHERE code = ? AND owner = ?"
  L7_2 = {}
  L8_2 = L4_2
  L9_2 = L2_2.cid
  L7_2[1] = L8_2
  L7_2[2] = L9_2
  L5_2 = L5_2(L6_2, L7_2)
  L6_2 = tonumber
  L7_2 = L5_2
  L6_2 = L6_2(L7_2)
  if not L6_2 then
    L6_2 = 0
  end
  if 0 == L6_2 then
    L6_2 = L20_1
    L7_2 = "notfound"
    return L6_2(L7_2)
  end
  L6_2 = L11_1
  L6_2 = L6_2[L4_2]
  if L6_2 then
    L7_2 = L10_1
    L7_2 = L7_2[L6_2]
    if L7_2 then
      L7_2 = L10_1
      L7_2 = L7_2[L6_2]
      L7_2.open = false
    end
  end
  L7_2 = {}
  L7_2.ok = true
  return L7_2
end
L79_1["recado.call.revokeLink"] = L80_1
function L79_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2
  L2_2 = L30_1
  L3_2 = A0_2.conversation
  L2_2 = L2_2(L3_2)
  L3_2 = {}
  L4_2 = tonumber
  L5_2 = A0_2.id
  L4_2 = L4_2(L5_2)
  L3_2.id = L4_2
  L4_2 = A0_2.code
  L3_2.code = L4_2
  L4_2 = A0_2.title
  L3_2.title = L4_2
  L4_2 = tonumber
  L5_2 = A0_2.video
  L4_2 = L4_2(L5_2)
  L4_2 = 1 == L4_2
  L3_2.video = L4_2
  L4_2 = tonumber
  L5_2 = A0_2.start
  L4_2 = L4_2(L5_2)
  L3_2.start = L4_2
  L3_2.conversation = L2_2
  if not L2_2 then
    L4_2 = tostring
    L5_2 = A0_2.owner_number
    L4_2 = L4_2(L5_2)
    L5_2 = A1_2.number
    if L4_2 == L5_2 then
      L4_2 = A0_2.number
      if L4_2 then
        goto lbl_42
      end
    end
    L4_2 = A0_2.owner_number
    if L4_2 then
      goto lbl_42
    end
  end
  L4_2 = nil
  ::lbl_42::
  L3_2.number = L4_2
  L4_2 = A1_2.cid
  L4_2 = nil ~= L4_2
  L3_2.mine = L4_2
  L5_2 = A0_2.code
  L4_2 = L11_1
  L4_2 = L4_2[L5_2]
  L4_2 = nil ~= L4_2
  L3_2.live = L4_2
  return L3_2
end
L80_1 = RPC
function L81_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2, L19_2, L20_2, L21_2, L22_2, L23_2
  L2_2 = type
  L3_2 = A1_2
  L2_2 = L2_2(L3_2)
  if "table" ~= L2_2 or not A1_2 then
    L2_2 = {}
    A1_2 = L2_2
  end
  L2_2 = L49_1
  L3_2 = A0_2
  L2_2, L3_2 = L2_2(L3_2)
  if not L2_2 then
    L4_2 = L20_1
    L5_2 = L3_2
    return L4_2(L5_2)
  end
  L4_2 = L2_2.cid
  if not L4_2 then
    L4_2 = L20_1
    L5_2 = "noidentity"
    return L4_2(L5_2)
  end
  L4_2 = L18_1
  if not L4_2 then
    L4_2 = L20_1
    L5_2 = "db"
    return L4_2(L5_2)
  end
  L4_2 = math
  L4_2 = L4_2.tointeger
  L5_2 = math
  L5_2 = L5_2.floor
  L6_2 = tonumber
  L7_2 = A1_2.start
  L6_2 = L6_2(L7_2)
  if not L6_2 then
    L6_2 = 0
  end
  L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2, L19_2, L20_2, L21_2, L22_2, L23_2 = L5_2(L6_2)
  L4_2 = L4_2(L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2, L19_2, L20_2, L21_2, L22_2, L23_2)
  L5_2 = Now
  L5_2 = L5_2()
  if L4_2 then
    L6_2 = L5_2 + 60000
    if not (L4_2 < L6_2) then
      L6_2 = L25_1
      L6_2 = L6_2()
      L6_2 = L5_2 + L6_2
      if not (L4_2 > L6_2) then
        goto lbl_74
      end
    end
  end
  L6_2 = L20_1
  L7_2 = "badstart"
  L8_2 = {}
  L9_2 = math
  L9_2 = L9_2.floor
  L10_2 = L25_1
  L10_2 = L10_2()
  L10_2 = L10_2 / 86400000
  L9_2 = L9_2(L10_2)
  L8_2.maxDays = L9_2
  do return L6_2(L7_2, L8_2) end
  ::lbl_74::
  L6_2 = A1_2.title
  if nil ~= L6_2 then
    L6_2 = A1_2.title
    if "" ~= L6_2 then
      L6_2 = L34_1
      L7_2 = A1_2.title
      L8_2 = 60
      L6_2 = L6_2(L7_2, L8_2)
      if L6_2 then
        goto lbl_87
      end
    end
  end
  L6_2 = "Chamada agendada"
  ::lbl_87::
  if not L6_2 then
    L7_2 = L20_1
    L8_2 = "badtitle"
    return L7_2(L8_2)
  end
  L7_2 = nil
  L8_2 = nil
  L9_2 = A1_2.conversation
  if nil ~= L9_2 then
    L9_2 = L30_1
    L10_2 = A1_2.conversation
    L9_2 = L9_2(L10_2)
    L7_2 = L9_2
    if not L7_2 then
      L9_2 = L20_1
      L10_2 = "invalid"
      return L9_2(L10_2)
    end
    L9_2 = L44_1
    L10_2 = L7_2
    L11_2 = L2_2.number
    L9_2 = L9_2(L10_2, L11_2)
    if L9_2 then
      L9_2 = L46_1
      L10_2 = L7_2
      L9_2 = L9_2(L10_2)
      if L9_2 then
        goto lbl_122
      end
    end
    L9_2 = L20_1
    L10_2 = "notfound"
    do return L9_2(L10_2) end
    ::lbl_122::
    L9_2 = L47_1
    L10_2 = L7_2
    L11_2 = L2_2.number
    L9_2 = L9_2(L10_2, L11_2)
    if not L9_2 then
      L9_2 = L20_1
      L10_2 = "adminsonly"
      return L9_2(L10_2)
    end
  else
    L9_2 = L35_1
    L10_2 = A1_2.number
    L9_2 = L9_2(L10_2)
    L8_2 = L9_2
    if L8_2 then
      L9_2 = L2_2.number
      if L8_2 ~= L9_2 then
        goto lbl_146
      end
    end
    L9_2 = L20_1
    L10_2 = "invalid"
    do return L9_2(L10_2) end
    ::lbl_146::
    L9_2 = L43_1
    L10_2 = L2_2.cid
    L11_2 = L8_2
    L9_2 = L9_2(L10_2, L11_2)
    if L9_2 then
      L9_2 = L20_1
      L10_2 = "blocked"
      return L9_2(L10_2)
    end
  end
  L9_2 = MySQL
  L9_2 = L9_2.scalar
  L9_2 = L9_2.await
  L10_2 = "SELECT COUNT(*) FROM apex_phone_recado_call_scheduled WHERE owner = ? AND cancelled = 0 AND `start` > ?"
  L11_2 = {}
  L12_2 = L2_2.cid
  L13_2 = L5_2
  L11_2[1] = L12_2
  L11_2[2] = L13_2
  L9_2 = L9_2(L10_2, L11_2)
  L10_2 = tonumber
  L11_2 = L9_2
  L10_2 = L10_2(L11_2)
  if not L10_2 then
    L10_2 = 0
  end
  L11_2 = L7_1
  if L10_2 >= L11_2 then
    L10_2 = L20_1
    L11_2 = "limit"
    L12_2 = {}
    L13_2 = L7_1
    L12_2.max = L13_2
    return L10_2(L11_2, L12_2)
  end
  L10_2 = L57_1
  L10_2 = L10_2()
  L11_2 = A1_2.video
  L11_2 = true == L11_2
  L12_2 = MySQL
  L12_2 = L12_2.insert
  L12_2 = L12_2.await
  L13_2 = "INSERT INTO apex_phone_recado_call_scheduled (code, owner, owner_number, conversation, `number`, title, video, `start`, reminded, cancelled, created) VALUES (?, ?, ?, ?, ?, ?, ?, ?, 0, 0, ?)"
  L14_2 = {}
  L15_2 = L10_2
  L16_2 = L2_2.cid
  L17_2 = L2_2.number
  L18_2 = L7_2
  L19_2 = L8_2
  L20_2 = L6_2
  if L11_2 then
    L21_2 = 1
    if L21_2 then
      goto lbl_208
    end
  end
  L21_2 = 0
  ::lbl_208::
  L22_2 = L4_2
  L23_2 = L5_2
  L14_2[1] = L15_2
  L14_2[2] = L16_2
  L14_2[3] = L17_2
  L14_2[4] = L18_2
  L14_2[5] = L19_2
  L14_2[6] = L20_2
  L14_2[7] = L21_2
  L14_2[8] = L22_2
  L14_2[9] = L23_2
  L12_2 = L12_2(L13_2, L14_2)
  if not L12_2 then
    L13_2 = L20_1
    L14_2 = "db"
    return L13_2(L14_2)
  end
  L13_2 = L66_1
  L14_2 = A0_2
  if L7_2 then
    L15_2 = {}
    L15_2.conversation = L7_2
    if L15_2 then
      goto lbl_230
    end
  end
  L15_2 = {}
  L15_2.number = L8_2
  ::lbl_230::
  L16_2 = L6_2
  L17_2 = {}
  L17_2.scheduled = true
  L17_2.code = L10_2
  L17_2.start = L4_2
  L17_2.title = L6_2
  L17_2.video = L11_2
  L17_2.status = "scheduled"
  L13_2 = L13_2(L14_2, L15_2, L16_2, L17_2)
  L14_2 = type
  L15_2 = L13_2
  L14_2 = L14_2(L15_2)
  if "table" == L14_2 then
    L14_2 = L30_1
    L15_2 = L13_2.id
    L14_2 = L14_2(L15_2)
    if L14_2 then
      L14_2 = MySQL
      L14_2 = L14_2.update
      L15_2 = "UPDATE apex_phone_recado_call_scheduled SET message_id = ? WHERE id = ?"
      L16_2 = {}
      L17_2 = L30_1
      L18_2 = L13_2.id
      L17_2 = L17_2(L18_2)
      L18_2 = L12_2
      L16_2[1] = L17_2
      L16_2[2] = L18_2
      L14_2(L15_2, L16_2)
    end
  end
  L14_2 = {}
  L14_2.id = L12_2
  L14_2.code = L10_2
  L15_2 = L2_2.cid
  L14_2.owner = L15_2
  L15_2 = L2_2.number
  L14_2.owner_number = L15_2
  L14_2.conversation = L7_2
  L14_2.number = L8_2
  L14_2.title = L6_2
  if L11_2 then
    L15_2 = 1
    if L15_2 then
      goto lbl_278
    end
  end
  L15_2 = 0
  ::lbl_278::
  L14_2.video = L15_2
  L14_2.start = L4_2
  L15_2 = {}
  L15_2.ok = true
  L16_2 = L79_1
  L17_2 = L14_2
  L18_2 = L2_2
  L16_2 = L16_2(L17_2, L18_2)
  L15_2.scheduled = L16_2
  L15_2.message = L13_2
  return L15_2
end
L80_1["recado.call.schedule"] = L81_1
L80_1 = RPC
function L81_1(A0_2)
  local L1_2, L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2
  L1_2 = L49_1
  L2_2 = A0_2
  L1_2, L2_2 = L1_2(L2_2)
  if not L1_2 then
    L3_2 = L20_1
    L4_2 = L2_2
    return L3_2(L4_2)
  end
  L3_2 = L18_1
  if not L3_2 then
    L3_2 = {}
    L3_2.ok = true
    L4_2 = {}
    L3_2.items = L4_2
    return L3_2
  end
  L3_2 = MySQL
  L3_2 = L3_2.query
  L3_2 = L3_2.await
  L4_2 = [[
SELECT id, code, owner, owner_number, conversation, `number`, title, video, `start` FROM apex_phone_recado_call_scheduled
        WHERE cancelled = 0 AND `start` > ? AND (owner = ? OR `number` = ? OR conversation IN
            (SELECT conversation_id FROM apex_phone_conversation_members WHERE member = ? AND left_at IS NULL))
        ORDER BY `start` ASC LIMIT 50]]
  L5_2 = {}
  L6_2 = Now
  L6_2 = L6_2()
  L7_2 = L3_1
  L6_2 = L6_2 - L7_2
  L7_2 = L1_2.cid
  if not L7_2 then
    L7_2 = ""
  end
  L8_2 = L1_2.number
  L9_2 = L1_2.number
  L5_2[1] = L6_2
  L5_2[2] = L7_2
  L5_2[3] = L8_2
  L5_2[4] = L9_2
  L3_2 = L3_2(L4_2, L5_2)
  if not L3_2 then
    L3_2 = {}
  end
  L4_2 = {}
  L5_2 = ipairs
  L6_2 = L3_2
  L5_2, L6_2, L7_2, L8_2 = L5_2(L6_2)
  for L9_2, L10_2 in L5_2, L6_2, L7_2, L8_2 do
    L11_2 = L10_2.owner
    L12_2 = L1_2.cid
    if L11_2 ~= L12_2 then
      L11_2 = L30_1
      L12_2 = L10_2.conversation
      L11_2 = L11_2(L12_2)
      if not L11_2 then
        L11_2 = L43_1
        L12_2 = L10_2.owner
        L13_2 = L1_2.number
        L11_2 = L11_2(L12_2, L13_2)
        if L11_2 then
          goto lbl_78
        end
        L11_2 = L43_1
        L12_2 = L1_2.cid
        L13_2 = L10_2.owner_number
        L11_2 = L11_2(L12_2, L13_2)
        if L11_2 then
          goto lbl_78
        end
      end
    end
    L11_2 = #L4_2
    L11_2 = L11_2 + 1
    L12_2 = L79_1
    L13_2 = L10_2
    L14_2 = L1_2
    L12_2 = L12_2(L13_2, L14_2)
    L4_2[L11_2] = L12_2
    ::lbl_78::
  end
  L5_2 = {}
  L5_2.ok = true
  L5_2.items = L4_2
  return L5_2
end
L80_1["recado.call.scheduled"] = L81_1
L80_1 = RPC
function L81_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2
  L2_2 = type
  L3_2 = A1_2
  L2_2 = L2_2(L3_2)
  if "table" ~= L2_2 or not A1_2 then
    L2_2 = {}
    A1_2 = L2_2
  end
  L2_2 = L49_1
  L3_2 = A0_2
  L2_2, L3_2 = L2_2(L3_2)
  if not L2_2 then
    L4_2 = L20_1
    L5_2 = L3_2
    return L4_2(L5_2)
  end
  L4_2 = L30_1
  L5_2 = A1_2.id
  L4_2 = L4_2(L5_2)
  if not L4_2 then
    L5_2 = L20_1
    L6_2 = "invalid"
    return L5_2(L6_2)
  end
  L5_2 = L2_2.cid
  if L5_2 then
    L5_2 = L18_1
    if L5_2 then
      goto lbl_39
    end
  end
  L5_2 = L20_1
  L6_2 = "db"
  do return L5_2(L6_2) end
  ::lbl_39::
  L5_2 = MySQL
  L5_2 = L5_2.update
  L5_2 = L5_2.await
  L6_2 = "UPDATE apex_phone_recado_call_scheduled SET cancelled = 1 WHERE id = ? AND owner = ? AND cancelled = 0"
  L7_2 = {}
  L8_2 = L4_2
  L9_2 = L2_2.cid
  L7_2[1] = L8_2
  L7_2[2] = L9_2
  L5_2 = L5_2(L6_2, L7_2)
  L6_2 = tonumber
  L7_2 = L5_2
  L6_2 = L6_2(L7_2)
  if not L6_2 then
    L6_2 = 0
  end
  if 0 == L6_2 then
    L6_2 = L20_1
    L7_2 = "notfound"
    return L6_2(L7_2)
  end
  L6_2 = {}
  L6_2.ok = true
  return L6_2
end
L80_1["recado.call.cancelScheduled"] = L81_1
function L80_1(A0_2)
  local L1_2, L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2
  L1_2 = {}
  L2_2 = {}
  function L3_2(A0_3)
    local L1_3, L2_3
    if A0_3 then
      L1_3 = L2_2
      L1_3 = L1_3[A0_3]
      if not L1_3 then
        L1_3 = L2_2
        L1_3[A0_3] = true
        L1_3 = L1_2
        L1_3 = #L1_3
        L2_3 = L1_3 + 1
        L1_3 = L1_2
        L1_3[L2_3] = A0_3
      end
    end
  end
  L4_2 = L3_2
  L5_2 = A0_2.owner
  L4_2(L5_2)
  L4_2 = L30_1
  L5_2 = A0_2.conversation
  L4_2 = L4_2(L5_2)
  if L4_2 then
    L5_2 = L39_1
    L6_2 = "GroupMembers"
    L7_2 = L4_2
    L5_2 = L5_2(L6_2, L7_2)
    if not L5_2 then
      L5_2 = {}
    end
    L6_2 = ipairs
    L7_2 = L5_2
    L6_2, L7_2, L8_2, L9_2 = L6_2(L7_2)
    for L10_2, L11_2 in L6_2, L7_2, L8_2, L9_2 do
      if L10_2 > 64 then
        break
      end
      L12_2 = tostring
      L13_2 = L11_2
      L12_2 = L12_2(L13_2)
      L13_2 = tostring
      L14_2 = A0_2.owner_number
      L13_2 = L13_2(L14_2)
      if L12_2 ~= L13_2 then
        L12_2 = GetCitizenIdByNumber
        L13_2 = tostring
        L14_2 = L11_2
        L13_2, L14_2, L15_2 = L13_2(L14_2)
        L12_2 = L12_2(L13_2, L14_2, L15_2)
        if L12_2 then
          L13_2 = L43_1
          L14_2 = L12_2
          L15_2 = A0_2.owner_number
          L13_2 = L13_2(L14_2, L15_2)
          if not L13_2 then
            L13_2 = L3_2
            L14_2 = L12_2
            L13_2(L14_2)
          end
        end
      end
    end
  else
    L5_2 = A0_2.number
    if L5_2 then
      L5_2 = GetCitizenIdByNumber
      L6_2 = tostring
      L7_2 = A0_2.number
      L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2 = L6_2(L7_2)
      L5_2 = L5_2(L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2)
      if L5_2 then
        L6_2 = L43_1
        L7_2 = L5_2
        L8_2 = A0_2.owner_number
        L6_2 = L6_2(L7_2, L8_2)
        if not L6_2 then
          L6_2 = L3_2
          L7_2 = L5_2
          L6_2(L7_2)
        end
      end
    end
  end
  return L1_2
end
function L81_1()
  local L0_2, L1_2, L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2, L19_2, L20_2, L21_2, L22_2, L23_2, L24_2, L25_2, L26_2
  L0_2 = Now
  L0_2 = L0_2()
  L1_2 = MySQL
  L1_2 = L1_2.query
  L1_2 = L1_2.await
  L2_2 = "SELECT id, code, owner, owner_number, conversation, `number`, title, video, `start`, reminded FROM apex_phone_recado_call_scheduled WHERE cancelled = 0 AND reminded < 2 AND `start` <= ? AND `start` > ? ORDER BY `start` LIMIT 40"
  L3_2 = {}
  L4_2 = L4_1
  L4_2 = L0_2 + L4_2
  L5_2 = L0_2 - 3600000
  L3_2[1] = L4_2
  L3_2[2] = L5_2
  L1_2 = L1_2(L2_2, L3_2)
  if not L1_2 then
    L1_2 = {}
  end
  L2_2 = ipairs
  L3_2 = L1_2
  L2_2, L3_2, L4_2, L5_2 = L2_2(L3_2)
  for L6_2, L7_2 in L2_2, L3_2, L4_2, L5_2 do
    L8_2 = tonumber
    L9_2 = L7_2.start
    L8_2 = L8_2(L9_2)
    if not L8_2 then
      L8_2 = 0
    end
    if L0_2 >= L8_2 then
      L9_2 = 2
      if L9_2 then
        goto lbl_36
      end
    end
    L9_2 = 1
    ::lbl_36::
    L10_2 = tonumber
    L11_2 = L7_2.reminded
    L10_2 = L10_2(L11_2)
    if not L10_2 then
      L10_2 = 0
    end
    if L9_2 > L10_2 then
      L10_2 = MySQL
      L10_2 = L10_2.update
      L10_2 = L10_2.await
      L11_2 = "UPDATE apex_phone_recado_call_scheduled SET reminded = ? WHERE id = ? AND reminded < ?"
      L12_2 = {}
      L13_2 = L9_2
      L14_2 = L7_2.id
      L15_2 = L9_2
      L12_2[1] = L13_2
      L12_2[2] = L14_2
      L12_2[3] = L15_2
      L10_2 = L10_2(L11_2, L12_2)
      L11_2 = tonumber
      L12_2 = L10_2
      L11_2 = L11_2(L12_2)
      if not L11_2 then
        L11_2 = 0
      end
      if L11_2 > 0 then
        L11_2 = nil
        if 1 == L9_2 then
          L12_2 = "Come\195\167a daqui a %d min"
          L13_2 = L12_2
          L12_2 = L12_2.format
          L14_2 = math
          L14_2 = L14_2.max
          L15_2 = 1
          L16_2 = math
          L16_2 = L16_2.floor
          L17_2 = L8_2 - L0_2
          L17_2 = L17_2 / 60000
          L17_2 = L17_2 + 0.5
          L16_2 = L16_2(L17_2)
          L14_2, L15_2, L16_2, L17_2, L18_2, L19_2, L20_2, L21_2, L22_2, L23_2, L24_2, L25_2, L26_2 = L14_2(L15_2, L16_2)
          L12_2 = L12_2(L13_2, L14_2, L15_2, L16_2, L17_2, L18_2, L19_2, L20_2, L21_2, L22_2, L23_2, L24_2, L25_2, L26_2)
          L11_2 = L12_2
        else
          L12_2 = tonumber
          L13_2 = L7_2.video
          L12_2 = L12_2(L13_2)
          if 1 == L12_2 then
            L12_2 = "A videochamada agendada come\195\167ou (v\195\173deo simulado)"
            if L12_2 then
              goto lbl_93
              L11_2 = L12_2 or L11_2
            end
          end
          L11_2 = "A chamada agendada come\195\167ou"
        end
        ::lbl_93::
        L12_2 = ipairs
        L13_2 = L80_1
        L14_2 = L7_2
        L13_2, L14_2, L15_2, L16_2, L17_2, L18_2, L19_2, L20_2, L21_2, L22_2, L23_2, L24_2, L25_2, L26_2 = L13_2(L14_2)
        L12_2, L13_2, L14_2, L15_2 = L12_2(L13_2, L14_2, L15_2, L16_2, L17_2, L18_2, L19_2, L20_2, L21_2, L22_2, L23_2, L24_2, L25_2, L26_2)
        for L16_2, L17_2 in L12_2, L13_2, L14_2, L15_2 do
          L18_2 = NotifyCitizen
          L19_2 = L17_2
          L20_2 = "recado"
          L21_2 = L7_2.title
          L22_2 = L11_2
          L23_2 = {}
          L24_2 = {}
          L25_2 = L7_2.code
          L24_2.code = L25_2
          L24_2.scheduled = true
          L23_2.recadoCall = L24_2
          L23_2.sys = "m"
          L24_2 = {}
          L25_2 = {}
          L26_2 = {}
          L26_2.id = "recado_call_join"
          L26_2.label = "Entrar"
          L25_2[1] = L26_2
          L24_2.actions = L25_2
          L18_2(L19_2, L20_2, L21_2, L22_2, L23_2, L24_2)
        end
      end
    end
  end
end
L82_1 = CreateThread
function L83_1()
  local L0_2, L1_2, L2_2, L3_2, L4_2, L5_2, L6_2
  while true do
    L0_2 = Wait
    L1_2 = 30000
    L0_2(L1_2)
    L0_2 = L18_1
    if L0_2 then
      L0_2 = pcall
      L1_2 = L81_1
      L0_2, L1_2 = L0_2(L1_2)
      if not L0_2 then
        L2_2 = print
        L3_2 = "^1[unique_phone]^0 recado: call reminders (%s)"
        L4_2 = L3_2
        L3_2 = L3_2.format
        L5_2 = tostring
        L6_2 = L1_2
        L5_2, L6_2 = L5_2(L6_2)
        L3_2, L4_2, L5_2, L6_2 = L3_2(L4_2, L5_2, L6_2)
        L2_2(L3_2, L4_2, L5_2, L6_2)
      end
    end
  end
end
L82_1(L83_1)
L82_1 = {}
L82_1.answered = true
L82_1.missed = true
L82_1.declined = true
L82_1.busy = true
L82_1.cancelled = true
L82_1.offline = true
L82_1.unavailable = true
L83_1 = RPC
function L84_1(A0_2)
  local L1_2, L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2
  L1_2 = L49_1
  L2_2 = A0_2
  L1_2, L2_2 = L1_2(L2_2)
  if not L1_2 then
    L3_2 = L20_1
    L4_2 = L2_2
    return L3_2(L4_2)
  end
  L3_2 = {}
  L4_2 = L1_2.cid
  if L4_2 then
    L4_2 = L18_1
    if L4_2 then
      L4_2 = MySQL
      L4_2 = L4_2.query
      L4_2 = L4_2.await
      L5_2 = "SELECT id, call_id, kind, conversation, title, video, direction, status, participants, duration, created FROM apex_phone_recado_call_history WHERE owner = ? ORDER BY created DESC LIMIT 100"
      L6_2 = {}
      L7_2 = L1_2.cid
      L6_2[1] = L7_2
      L4_2 = L4_2(L5_2, L6_2)
      if not L4_2 then
        L4_2 = {}
      end
      L5_2 = ipairs
      L6_2 = L4_2
      L5_2, L6_2, L7_2, L8_2 = L5_2(L6_2)
      for L9_2, L10_2 in L5_2, L6_2, L7_2, L8_2 do
        L11_2 = nil
        L12_2 = type
        L13_2 = L10_2.participants
        L12_2 = L12_2(L13_2)
        if "string" == L12_2 then
          L12_2 = L10_2.participants
          if "" ~= L12_2 then
            L12_2 = pcall
            L13_2 = json
            L13_2 = L13_2.decode
            L14_2 = L10_2.participants
            L12_2, L13_2 = L12_2(L13_2, L14_2)
            if L12_2 then
              L14_2 = type
              L15_2 = L13_2
              L14_2 = L14_2(L15_2)
              if "table" == L14_2 then
                L11_2 = L13_2
              end
            end
          end
        end
        L12_2 = #L3_2
        L12_2 = L12_2 + 1
        L13_2 = {}
        L14_2 = "r"
        L15_2 = tostring
        L16_2 = L10_2.id
        L15_2 = L15_2(L16_2)
        L14_2 = L14_2 .. L15_2
        L13_2.id = L14_2
        L14_2 = L10_2.kind
        L13_2.kind = L14_2
        L14_2 = tonumber
        L15_2 = L10_2.call_id
        L14_2 = L14_2(L15_2)
        L13_2.callId = L14_2
        L14_2 = L30_1
        L15_2 = L10_2.conversation
        L14_2 = L14_2(L15_2)
        L13_2.conversation = L14_2
        L14_2 = L10_2.title
        L13_2.title = L14_2
        L14_2 = tonumber
        L15_2 = L10_2.video
        L14_2 = L14_2(L15_2)
        L14_2 = 1 == L14_2
        L13_2.video = L14_2
        L14_2 = L10_2.direction
        L14_2 = "out" == L14_2
        L13_2.outgoing = L14_2
        L14_2 = L10_2.status
        L13_2.status = L14_2
        L14_2 = tonumber
        L15_2 = L10_2.duration
        L14_2 = L14_2(L15_2)
        if not L14_2 then
          L14_2 = 0
        end
        L13_2.duration = L14_2
        L14_2 = tonumber
        L15_2 = L10_2.created
        L14_2 = L14_2(L15_2)
        if not L14_2 then
          L14_2 = 0
        end
        L13_2.created = L14_2
        L13_2.participants = L11_2
        L3_2[L12_2] = L13_2
      end
    end
  end
  L4_2 = RPC
  L4_2 = L4_2["calls.history"]
  L5_2 = type
  L6_2 = L4_2
  L5_2 = L5_2(L6_2)
  if "function" == L5_2 then
    L5_2 = pcall
    L6_2 = L4_2
    L7_2 = A0_2
    L8_2 = {}
    L5_2, L6_2 = L5_2(L6_2, L7_2, L8_2)
    if L5_2 then
      L7_2 = type
      L8_2 = L6_2
      L7_2 = L7_2(L8_2)
      if "table" == L7_2 then
        L7_2 = ipairs
        L8_2 = L6_2
        L7_2, L8_2, L9_2, L10_2 = L7_2(L8_2)
        for L11_2, L12_2 in L7_2, L8_2, L9_2, L10_2 do
          L14_2 = L12_2.status
          L13_2 = L82_1
          L13_2 = L13_2[L14_2]
          if L13_2 then
            L13_2 = L12_2.status
            if L13_2 then
              goto lbl_160
            end
          end
          L13_2 = L12_2.answered
          if L13_2 then
            L13_2 = "answered"
            if L13_2 then
              goto lbl_160
            end
          end
          L13_2 = L12_2.outgoing
          if L13_2 then
            L13_2 = "cancelled"
            if L13_2 then
              goto lbl_160
            end
          end
          L13_2 = "missed"
          ::lbl_160::
          L14_2 = #L3_2
          L14_2 = L14_2 + 1
          L15_2 = {}
          L16_2 = "p"
          L17_2 = tostring
          L18_2 = L12_2.id
          L17_2 = L17_2(L18_2)
          L16_2 = L16_2 .. L17_2
          L15_2.id = L16_2
          L15_2.kind = "phone"
          L16_2 = L12_2.number
          L15_2.number = L16_2
          L16_2 = L12_2.name
          L15_2.name = L16_2
          L16_2 = L12_2.video
          L16_2 = true == L16_2
          L15_2.video = L16_2
          L16_2 = L12_2.outgoing
          L16_2 = true == L16_2
          L15_2.outgoing = L16_2
          L15_2.status = L13_2
          L16_2 = tonumber
          L17_2 = L12_2.duration
          L16_2 = L16_2(L17_2)
          if not L16_2 then
            L16_2 = 0
          end
          L15_2.duration = L16_2
          L16_2 = tonumber
          L17_2 = L12_2.created
          L16_2 = L16_2(L17_2)
          if not L16_2 then
            L16_2 = 0
          end
          L15_2.created = L16_2
          L3_2[L14_2] = L15_2
        end
      end
    end
  end
  L5_2 = table
  L5_2 = L5_2.sort
  L6_2 = L3_2
  function L7_2(A0_3, A1_3)
    local L2_3, L3_3
    L2_3 = A0_3.created
    if not L2_3 then
      L2_3 = 0
    end
    L3_3 = A1_3.created
    if not L3_3 then
      L3_3 = 0
    end
    L2_3 = L2_3 > L3_3
    return L2_3
  end
  L5_2(L6_2, L7_2)
  while true do
    L5_2 = #L3_2
    if not (L5_2 > 100) then
      break
    end
    L5_2 = #L3_2
    L3_2[L5_2] = nil
  end
  L5_2 = {}
  L5_2.ok = true
  L5_2.items = L3_2
  return L5_2
end
L83_1["recado.call.history"] = L84_1
L83_1 = RPC
function L84_1(A0_2)
  local L1_2, L2_2, L3_2, L4_2, L5_2, L6_2
  L1_2 = L49_1
  L2_2 = A0_2
  L1_2, L2_2 = L1_2(L2_2)
  if not L1_2 then
    L3_2 = L20_1
    L4_2 = L2_2
    return L3_2(L4_2)
  end
  L3_2 = L1_2.cid
  if L3_2 then
    L3_2 = L18_1
    if L3_2 then
      goto lbl_20
    end
  end
  L3_2 = L20_1
  L4_2 = "db"
  do return L3_2(L4_2) end
  ::lbl_20::
  L3_2 = MySQL
  L3_2 = L3_2.query
  L3_2 = L3_2.await
  L4_2 = "DELETE FROM apex_phone_recado_call_history WHERE owner = ?"
  L5_2 = {}
  L6_2 = L1_2.cid
  L5_2[1] = L6_2
  L3_2(L4_2, L5_2)
  L3_2 = {}
  L3_2.ok = true
  return L3_2
end
L83_1["recado.call.clearHistory"] = L84_1
L83_1 = AddEventHandler
L84_1 = "apex_phone:callStarted"
function L85_1(A0_2, A1_2, A2_2)
  local L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2
  L3_2 = os
  L3_2 = L3_2.time
  L3_2 = L3_2()
  L4_2 = pairs
  L5_2 = L16_1
  L4_2, L5_2, L6_2, L7_2 = L4_2(L5_2)
  for L8_2, L9_2 in L4_2, L5_2, L6_2, L7_2 do
    L10_2 = L9_2.t
    L10_2 = L3_2 - L10_2
    L11_2 = 7200
    if L10_2 > L11_2 then
      L10_2 = L16_1
      L10_2[L8_2] = nil
    end
  end
  if A0_2 then
    L4_2 = L16_1
    L5_2 = {}
    L6_2 = tonumber
    L7_2 = A1_2
    L6_2 = L6_2(L7_2)
    L7_2 = tonumber
    L8_2 = A2_2
    L7_2 = L7_2(L8_2)
    L5_2.t = L3_2
    L5_2[1] = L6_2
    L5_2[2] = L7_2
    L4_2[A0_2] = L5_2
  end
end
L83_1(L84_1, L85_1)
L83_1 = AddEventHandler
L84_1 = "apex_phone:callAnswered"
function L85_1(A0_2)
  local L1_2, L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2
  L1_2 = L16_1
  L1_2 = L1_2[A0_2]
  if not L1_2 then
    return
  end
  L2_2 = 1
  L3_2 = 2
  L4_2 = 1
  for L5_2 = L2_2, L3_2, L4_2 do
    L6_2 = L1_2[L5_2]
    L7_2 = L6_2
    if L6_2 then
      L7_2 = L12_1
      L7_2 = L7_2[L6_2]
    end
    L8_2 = L7_2
    if L7_2 then
      L8_2 = L10_1
      L8_2 = L8_2[L7_2]
    end
    if L8_2 then
      L9_2 = L74_1
      L10_2 = L8_2
      L11_2 = L6_2
      L12_2 = "phonecall"
      L9_2(L10_2, L11_2, L12_2)
    end
  end
end
L83_1(L84_1, L85_1)
L83_1 = AddEventHandler
L84_1 = "apex_phone:callEnded"
function L85_1(A0_2)
  local L1_2
  L1_2 = L16_1
  L1_2[A0_2] = nil
end
L83_1(L84_1, L85_1)
function L83_1(A0_2)
  local L1_2, L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2, L19_2, L20_2, L21_2, L22_2, L23_2
  L1_2 = tonumber
  L2_2 = A0_2
  L1_2 = L1_2(L2_2)
  A0_2 = L1_2
  if not A0_2 then
    return
  end
  L1_2 = L15_1
  L1_2[A0_2] = nil
  L1_2 = L12_1
  L1_2 = L1_2[A0_2]
  L2_2 = L1_2
  if L1_2 then
    L2_2 = L10_1
    L2_2 = L2_2[L1_2]
  end
  if L2_2 then
    L3_2 = L74_1
    L4_2 = L2_2
    L5_2 = A0_2
    L6_2 = "dropped"
    L3_2(L4_2, L5_2, L6_2)
  end
  L3_2 = L12_1
  L3_2[A0_2] = nil
  L3_2 = pairs
  L4_2 = L10_1
  L3_2, L4_2, L5_2, L6_2 = L3_2(L4_2)
  for L7_2, L8_2 in L3_2, L4_2, L5_2, L6_2 do
    L9_2 = false
    L10_2 = pairs
    L11_2 = L8_2.ringing
    L10_2, L11_2, L12_2, L13_2 = L10_2(L11_2)
    for L14_2, L15_2 in L10_2, L11_2, L12_2, L13_2 do
      L16_2 = L15_2.src
      if L16_2 == A0_2 then
        L16_2 = L8_2.ringing
        L16_2[L14_2] = nil
        L16_2 = L65_1
        L17_2 = L8_2
        L18_2 = L15_2.cid
        L19_2 = "missed"
        L20_2 = "in"
        L21_2 = 0
        L22_2 = nil
        L23_2 = L15_2.since
        L16_2(L17_2, L18_2, L19_2, L20_2, L21_2, L22_2, L23_2)
        L9_2 = true
      end
    end
    if L9_2 then
      L10_2 = L63_1
      L11_2 = L8_2
      L10_2(L11_2)
    end
  end
end
function L84_1(A0_2)
  local L1_2, L2_2
  L1_2 = L83_1
  L2_2 = A0_2
  L1_2(L2_2)
end
RecadoCallsLeave = L84_1
L84_1 = type
L85_1 = FW
L84_1 = L84_1(L85_1)
if "table" == L84_1 then
  L84_1 = type
  L85_1 = FW
  L85_1 = L85_1.OnPlayerDropped
  L84_1 = L84_1(L85_1)
  if "function" == L84_1 then
    L84_1 = FW
    L84_1 = L84_1.OnPlayerDropped
    L85_1 = L83_1
    L84_1(L85_1)
end
else
  L84_1 = AddEventHandler
  L85_1 = "playerDropped"
  function L86_1()
    local L0_2, L1_2
    L0_2 = L83_1
    L1_2 = source
    L0_2(L1_2)
  end
  L84_1(L85_1, L86_1)
end
L84_1 = AddEventHandler
L85_1 = "onResourceStop"
function L86_1(A0_2)
  local L1_2, L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2
  L1_2 = GetCurrentResourceName
  L1_2 = L1_2()
  if A0_2 ~= L1_2 then
    return
  end
  L1_2 = {}
  L2_2 = pairs
  L3_2 = L10_1
  L2_2, L3_2, L4_2, L5_2 = L2_2(L3_2)
  for L6_2, L7_2 in L2_2, L3_2, L4_2, L5_2 do
    L8_2 = #L1_2
    L8_2 = L8_2 + 1
    L1_2[L8_2] = L7_2
  end
  L2_2 = ipairs
  L3_2 = L1_2
  L2_2, L3_2, L4_2, L5_2 = L2_2(L3_2)
  for L6_2, L7_2 in L2_2, L3_2, L4_2, L5_2 do
    L8_2 = L67_1
    L9_2 = L7_2
    L10_2 = "stopped"
    L11_2 = true
    L8_2(L9_2, L10_2, L11_2)
  end
end
L84_1(L85_1, L86_1)
