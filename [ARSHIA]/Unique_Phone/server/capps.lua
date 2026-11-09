local L0_1, L1_1, L2_1, L3_1, L4_1, L5_1, L6_1, L7_1, L8_1, L9_1, L10_1, L11_1, L12_1, L13_1, L14_1, L15_1, L16_1, L17_1, L18_1, L19_1, L20_1, L21_1, L22_1, L23_1, L24_1, L25_1, L26_1, L27_1, L28_1, L29_1, L30_1, L31_1, L32_1, L33_1, L34_1, L35_1, L36_1, L37_1, L38_1, L39_1, L40_1, L41_1, L42_1, L43_1, L44_1, L45_1, L46_1, L47_1, L48_1, L49_1, L50_1, L51_1, L52_1, L53_1, L54_1, L55_1, L56_1, L57_1, L58_1, L59_1, L60_1, L61_1, L62_1, L63_1, L64_1, L65_1, L66_1, L67_1, L68_1, L69_1, L70_1, L71_1, L72_1, L73_1, L74_1, L75_1, L76_1, L77_1, L78_1, L79_1, L80_1, L81_1, L82_1, L83_1, L84_1, L85_1, L86_1, L87_1, L88_1, L89_1, L90_1, L91_1, L92_1, L93_1, L94_1, L95_1, L96_1, L97_1, L98_1, L99_1, L100_1, L101_1, L102_1, L103_1, L104_1, L105_1, L106_1, L107_1, L108_1, L109_1, L110_1, L111_1, L112_1, L113_1, L114_1, L115_1, L116_1, L117_1, L118_1, L119_1, L120_1, L121_1
L0_1 = "apex_phone:capps"
L1_1 = 30
L2_1 = {}
L2_1.form = "form"
L2_1.appointments = "appt"
L2_1.dispatch = "call"
L2_1.records = "record"
L2_1.posts = "post"
L2_1.catalog = "order"
L2_1.billing = "bill"
L2_1.duty = "shift"
L3_1 = {}
L3_1.roster = true
L3_1.info = true
L4_1 = {}
L4_1.roster = true
L4_1.billing = true
L4_1.duty = true
L5_1 = {}
L6_1 = "view"
L7_1 = "reply"
L8_1 = "status"
L9_1 = "assign"
L10_1 = "delete"
L11_1 = "create"
L5_1[1] = L6_1
L5_1[2] = L7_1
L5_1[3] = L8_1
L5_1[4] = L9_1
L5_1[5] = L10_1
L5_1[6] = L11_1
L6_1 = {}
L7_1 = {}
L8_1 = {}
L9_1 = 0
function L10_1()
  local L0_2, L1_2
  L0_2 = type
  L1_2 = Config
  L1_2 = L1_2.CustomApps
  L0_2 = L0_2(L1_2)
  if "table" == L0_2 then
    L0_2 = Config
    L0_2 = L0_2.CustomApps
    if L0_2 then
      goto lbl_13
    end
  end
  L0_2 = {}
  ::lbl_13::
  return L0_2
end
function L11_1(A0_2, A1_2, A2_2)
  local L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2
  if nil == A0_2 then
    L3_2 = nil
    return L3_2
  end
  L3_2 = type
  L4_2 = A0_2
  L3_2 = L3_2(L4_2)
  if "string" ~= L3_2 and "number" ~= L3_2 then
    L4_2 = nil
    return L4_2
  end
  L4_2 = tostring
  L5_2 = A0_2
  L4_2 = L4_2(L5_2)
  A0_2 = L4_2
  if A2_2 then
    L5_2 = A0_2
    L4_2 = A0_2.gsub
    L6_2 = "\r\n"
    L7_2 = "\n"
    L4_2 = L4_2(L5_2, L6_2, L7_2)
    L5_2 = L4_2
    L4_2 = L4_2.gsub
    L6_2 = "[\000-\t\v-\031\127]"
    L7_2 = ""
    L4_2 = L4_2(L5_2, L6_2, L7_2)
    A0_2 = L4_2
  else
    L5_2 = A0_2
    L4_2 = A0_2.gsub
    L6_2 = "[\000-\031\127]"
    L7_2 = " "
    L4_2 = L4_2(L5_2, L6_2, L7_2)
    A0_2 = L4_2
  end
  L5_2 = A0_2
  L4_2 = A0_2.gsub
  L6_2 = "^%s+"
  L7_2 = ""
  L4_2 = L4_2(L5_2, L6_2, L7_2)
  L5_2 = L4_2
  L4_2 = L4_2.gsub
  L6_2 = "%s+$"
  L7_2 = ""
  L4_2 = L4_2(L5_2, L6_2, L7_2)
  A0_2 = L4_2
  if A2_2 then
    L5_2 = A0_2
    L4_2 = A0_2.gsub
    L6_2 = [[



+]]
    L7_2 = [[


]]
    L4_2 = L4_2(L5_2, L6_2, L7_2)
    A0_2 = L4_2
  end
  if "" == A0_2 then
    L4_2 = nil
    return L4_2
  end
  L4_2 = #A0_2
  if A1_2 < L4_2 then
    L5_2 = A0_2
    L4_2 = A0_2.sub
    L6_2 = 1
    L7_2 = A1_2
    L4_2 = L4_2(L5_2, L6_2, L7_2)
    A0_2 = L4_2
    L4_2 = 1
    L5_2 = 3
    L6_2 = 1
    for L7_2 = L4_2, L5_2, L6_2 do
      L8_2 = utf8
      L8_2 = L8_2.len
      L9_2 = A0_2
      L8_2 = L8_2(L9_2)
      if L8_2 then
        break
      end
      L9_2 = A0_2
      L8_2 = A0_2.sub
      L10_2 = 1
      L11_2 = -2
      L8_2 = L8_2(L9_2, L10_2, L11_2)
      A0_2 = L8_2
    end
  end
  L4_2 = utf8
  L4_2 = L4_2.len
  L5_2 = A0_2
  L4_2 = L4_2(L5_2)
  if not L4_2 then
    L4_2 = nil
    return L4_2
  end
  return A0_2
end
function L12_1(A0_2, A1_2, A2_2, A3_2)
  local L4_2, L5_2, L6_2, L7_2
  L4_2 = math
  L4_2 = L4_2.tointeger
  L5_2 = math
  L5_2 = L5_2.floor
  L6_2 = tonumber
  L7_2 = A0_2
  L6_2 = L6_2(L7_2)
  L6_2 = A3_2 or L6_2
  if not L6_2 and not A3_2 then
    L6_2 = 0
  end
  L5_2, L6_2, L7_2 = L5_2(L6_2)
  L4_2 = L4_2(L5_2, L6_2, L7_2)
  L4_2 = A3_2 or L4_2
  if not L4_2 and not A3_2 then
    L4_2 = 0
  end
  if A1_2 and A1_2 > L4_2 then
    L4_2 = A1_2
  end
  if A2_2 and A2_2 < L4_2 then
    L4_2 = A2_2
  end
  return L4_2
end
function L13_1(A0_2)
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
function L14_1(A0_2)
  local L1_2, L2_2, L3_2
  L1_2 = tonumber
  L2_2 = A0_2
  L1_2 = L1_2(L2_2)
  if L1_2 and L1_2 == L1_2 and not (L1_2 < 0) then
    L2_2 = 1.0E9
    if not (L1_2 > L2_2) then
      goto lbl_15
    end
  end
  L2_2 = nil
  do return L2_2 end
  ::lbl_15::
  L2_2 = math
  L2_2 = L2_2.floor
  L3_2 = L1_2 * 100
  L3_2 = L3_2 + 0.5
  L2_2 = L2_2(L3_2)
  L2_2 = L2_2 / 100
  return L2_2
end
function L15_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2, L6_2
  L2_2 = FormatMoney
  if L2_2 then
    L2_2 = FormatMoney
    L3_2 = A0_2
    L4_2 = A1_2
    return L2_2(L3_2, L4_2)
  end
  L2_2 = tonumber
  L3_2 = A0_2
  L2_2 = L2_2(L3_2)
  A0_2 = L2_2 or A0_2
  if not L2_2 then
    A0_2 = 0
  end
  L2_2 = math
  L2_2 = L2_2.floor
  L3_2 = A0_2
  L2_2 = L2_2(L3_2)
  if A0_2 == L2_2 then
    L2_2 = "%d"
    L3_2 = L2_2
    L2_2 = L2_2.format
    L4_2 = math
    L4_2 = L4_2.floor
    L5_2 = A0_2
    L4_2, L5_2, L6_2 = L4_2(L5_2)
    L2_2 = L2_2(L3_2, L4_2, L5_2, L6_2)
    if L2_2 then
      goto lbl_38
    end
  end
  L2_2 = "%.2f"
  L3_2 = L2_2
  L2_2 = L2_2.format
  L4_2 = A0_2
  L2_2 = L2_2(L3_2, L4_2)
  L3_2 = L2_2
  L2_2 = L2_2.gsub
  L4_2 = "%."
  L5_2 = ","
  L2_2 = L2_2(L3_2, L4_2, L5_2)
  ::lbl_38::
  L3_2 = L2_2
  L4_2 = " "
  L5_2 = tostring
  L6_2 = A1_2 or L6_2
  if not A1_2 then
    L6_2 = "$"
  end
  L5_2 = L5_2(L6_2)
  L3_2 = L3_2 .. L4_2 .. L5_2
  return L3_2
end
function L16_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2
  L2_2 = type
  L3_2 = A0_2
  L2_2 = L2_2(L3_2)
  L2_2 = "string" == L2_2
  return L2_2
end
function L17_1(A0_2)
  local L1_2, L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2
  L1_2 = type
  L2_2 = A0_2
  L1_2 = L1_2(L2_2)
  if "table" ~= L1_2 then
    L1_2 = {}
    return L1_2
  end
  L1_2 = {}
  L2_2 = ipairs
  L3_2 = A0_2
  L2_2, L3_2, L4_2, L5_2 = L2_2(L3_2)
  for L6_2, L7_2 in L2_2, L3_2, L4_2, L5_2 do
    L8_2 = #L1_2
    L8_2 = L8_2 + 1
    L1_2[L8_2] = L7_2
  end
  return L1_2
end
function L18_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2
  if not A1_2 then
    A1_2 = 0
  end
  L2_2 = type
  L3_2 = A0_2
  L2_2 = L2_2(L3_2)
  if "table" ~= L2_2 or A1_2 > 12 then
    return A0_2
  end
  L2_2 = {}
  L3_2 = pairs
  L4_2 = A0_2
  L3_2, L4_2, L5_2, L6_2 = L3_2(L4_2)
  for L7_2, L8_2 in L3_2, L4_2, L5_2, L6_2 do
    L9_2 = L18_1
    L10_2 = L8_2
    L11_2 = A1_2 + 1
    L9_2 = L9_2(L10_2, L11_2)
    L2_2[L7_2] = L9_2
  end
  return L2_2
end
function L19_1(A0_2)
  local L1_2, L2_2, L3_2, L4_2
  L1_2 = L11_1
  L2_2 = A0_2
  L3_2 = 400
  L1_2 = L1_2(L2_2, L3_2)
  if L1_2 then
    L3_2 = L1_2
    L2_2 = L1_2.match
    L4_2 = "^https://[%w%.%-]+[/%?#]?"
    L2_2 = L2_2(L3_2, L4_2)
    if L2_2 then
      L3_2 = L1_2
      L2_2 = L1_2.find
      L4_2 = "[%s\"'<>\\]"
      L2_2 = L2_2(L3_2, L4_2)
      if not L2_2 then
        goto lbl_19
      end
    end
  end
  L2_2 = nil
  do return L2_2 end
  ::lbl_19::
  return L1_2
end
function L20_1(A0_2)
  local L1_2, L2_2, L3_2, L4_2, L5_2
  L1_2 = L11_1
  L2_2 = A0_2
  L3_2 = 60
  L1_2 = L1_2(L2_2, L3_2)
  A0_2 = L1_2
  if not A0_2 then
    L1_2 = nil
    return L1_2
  end
  L1_2 = "%"
  L3_2 = A0_2
  L2_2 = A0_2.gsub
  L4_2 = "[%%_\\]"
  L5_2 = "\\%0"
  L2_2 = L2_2(L3_2, L4_2, L5_2)
  L3_2 = "%"
  L1_2 = L1_2 .. L2_2 .. L3_2
  return L1_2
end
function L21_1(A0_2)
  local L1_2, L2_2, L3_2
  L1_2 = pcall
  L2_2 = json
  L2_2 = L2_2.encode
  L3_2 = A0_2
  L1_2, L2_2 = L1_2(L2_2, L3_2)
  L3_2 = L2_2 or L3_2
  if not L1_2 or not L2_2 then
    L3_2 = nil
  end
  return L3_2
end
function L22_1(A0_2)
  local L1_2, L2_2, L3_2
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
  L3_2 = L2_2 or L3_2
  if not L1_2 or not L2_2 then
    L3_2 = nil
  end
  return L3_2
end
function L23_1()
  local L0_2, L1_2, L2_2, L3_2, L4_2
  L0_2 = GetConvar
  L1_2 = "sv_projectName"
  L2_2 = ""
  L0_2 = L0_2(L1_2, L2_2)
  if "" == L0_2 then
    L1_2 = GetConvar
    L2_2 = "sv_hostname"
    L3_2 = ""
    L1_2 = L1_2(L2_2, L3_2)
    L0_2 = L1_2
  end
  L2_2 = L0_2
  L1_2 = L0_2.gsub
  L3_2 = "%^%d"
  L4_2 = ""
  L1_2 = L1_2(L2_2, L3_2, L4_2)
  L2_2 = L1_2
  L1_2 = L1_2.gsub
  L3_2 = "%s+"
  L4_2 = " "
  L1_2 = L1_2(L2_2, L3_2, L4_2)
  L2_2 = L1_2
  L1_2 = L1_2.gsub
  L3_2 = "^%s+"
  L4_2 = ""
  L1_2 = L1_2(L2_2, L3_2, L4_2)
  L2_2 = L1_2
  L1_2 = L1_2.gsub
  L3_2 = "%s+$"
  L4_2 = ""
  L1_2 = L1_2(L2_2, L3_2, L4_2)
  L0_2 = L1_2
  L1_2 = L11_1
  L2_2 = L0_2
  L3_2 = 40
  L1_2 = L1_2(L2_2, L3_2)
  if not L1_2 then
    L1_2 = "Servidor"
  end
  return L1_2
end
function L24_1(A0_2)
  local L1_2, L2_2, L3_2, L4_2
  if not A0_2 then
    L1_2 = nil
    return L1_2
  end
  L1_2 = A0_2.firstname
  if not L1_2 then
    L1_2 = ""
  end
  L2_2 = " "
  L3_2 = A0_2.lastname
  if not L3_2 then
    L3_2 = ""
  end
  L1_2 = L1_2 .. L2_2 .. L3_2
  L2_2 = L1_2
  L1_2 = L1_2.gsub
  L3_2 = "%s+$"
  L4_2 = ""
  L1_2 = L1_2(L2_2, L3_2, L4_2)
  L2_2 = L1_2
  L1_2 = L1_2.gsub
  L3_2 = "^%s+"
  L4_2 = ""
  L1_2 = L1_2(L2_2, L3_2, L4_2)
  L2_2 = L11_1
  L3_2 = L1_2
  L4_2 = 100
  return L2_2(L3_2, L4_2)
end
function L25_1(A0_2)
  local L1_2, L2_2, L3_2, L4_2
  L1_2 = pcall
  function L2_2()
    local L0_3, L1_3, L2_3
    L0_3 = GetEntityCoords
    L1_3 = GetPlayerPed
    L2_3 = A0_2
    L1_3, L2_3 = L1_3(L2_3)
    return L0_3(L1_3, L2_3)
  end
  L1_2, L2_2 = L1_2(L2_2)
  if L1_2 and L2_2 then
    L3_2 = tonumber
    L4_2 = L2_2.x
    L3_2 = L3_2(L4_2)
    if L3_2 then
      L3_2 = L2_2.x
      if 0.0 == L3_2 then
        L3_2 = L2_2.y
        if 0.0 == L3_2 then
          L3_2 = L2_2.z
          if 0.0 == L3_2 then
            goto lbl_23
          end
        end
      end
      return L2_2
    end
  end
  ::lbl_23::
  L3_2 = nil
  return L3_2
end
function L26_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2
  L2_2 = L25_1
  L3_2 = A0_2
  L2_2 = L2_2(L3_2)
  if L2_2 then
    L3_2 = {}
    L4_2 = math
    L4_2 = L4_2.floor
    L5_2 = L2_2.x
    L5_2 = L5_2 * 10
    L5_2 = L5_2 + 0.5
    L4_2 = L4_2(L5_2)
    L4_2 = L4_2 / 10
    L3_2.x = L4_2
    L4_2 = math
    L4_2 = L4_2.floor
    L5_2 = L2_2.y
    L5_2 = L5_2 * 10
    L5_2 = L5_2 + 0.5
    L4_2 = L4_2(L5_2)
    L4_2 = L4_2 / 10
    L3_2.y = L4_2
    L4_2 = math
    L4_2 = L4_2.floor
    L5_2 = L2_2.z
    L5_2 = L5_2 * 10
    L5_2 = L5_2 + 0.5
    L4_2 = L4_2(L5_2)
    L4_2 = L4_2 / 10
    L3_2.z = L4_2
    return L3_2
  end
  L3_2 = type
  L4_2 = A1_2
  L3_2 = L3_2(L4_2)
  if "table" == L3_2 then
    L3_2 = tonumber
    L4_2 = A1_2.x
    L3_2 = L3_2(L4_2)
    L4_2 = tonumber
    L5_2 = A1_2.y
    L4_2 = L4_2(L5_2)
    if L3_2 and L4_2 and L3_2 == L3_2 and L4_2 == L4_2 then
      L5_2 = math
      L5_2 = L5_2.abs
      L6_2 = L3_2
      L5_2 = L5_2(L6_2)
      L6_2 = 12000
      if L5_2 < L6_2 then
        L5_2 = math
        L5_2 = L5_2.abs
        L6_2 = L4_2
        L5_2 = L5_2(L6_2)
        L6_2 = 12000
        if L5_2 < L6_2 then
          L5_2 = {}
          L6_2 = math
          L6_2 = L6_2.floor
          L7_2 = L3_2 * 10
          L7_2 = L7_2 + 0.5
          L6_2 = L6_2(L7_2)
          L6_2 = L6_2 / 10
          L5_2.x = L6_2
          L6_2 = math
          L6_2 = L6_2.floor
          L7_2 = L4_2 * 10
          L7_2 = L7_2 + 0.5
          L6_2 = L6_2(L7_2)
          L6_2 = L6_2 / 10
          L5_2.y = L6_2
          L6_2 = math
          L6_2 = L6_2.floor
          L7_2 = tonumber
          L8_2 = A1_2.z
          L7_2 = L7_2(L8_2)
          if not L7_2 then
            L7_2 = 0
          end
          L7_2 = L7_2 * 10
          L7_2 = L7_2 + 0.5
          L6_2 = L6_2(L7_2)
          L6_2 = L6_2 / 10
          L5_2.z = L6_2
          return L5_2
        end
      end
    end
  end
  L3_2 = nil
  return L3_2
end
function L27_1(A0_2)
  local L1_2, L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2, L19_2, L20_2, L21_2, L22_2, L23_2, L24_2, L25_2, L26_2, L27_2
  L1_2 = {}
  L2_2 = type
  L3_2 = A0_2
  L2_2 = L2_2(L3_2)
  if "table" == L2_2 then
    L2_2 = A0_2.apps
    if L2_2 then
      goto lbl_12
    end
  end
  L2_2 = nil
  ::lbl_12::
  L3_2 = type
  L4_2 = L2_2
  L3_2 = L3_2(L4_2)
  if "table" ~= L3_2 then
    return L1_2
  end
  L3_2 = {}
  L4_2 = ipairs
  L5_2 = L2_2
  L4_2, L5_2, L6_2, L7_2 = L4_2(L5_2)
  for L8_2, L9_2 in L4_2, L5_2, L6_2, L7_2 do
    L10_2 = type
    L11_2 = L9_2
    L10_2 = L10_2(L11_2)
    if "table" == L10_2 then
      L10_2 = L16_1
      L11_2 = L9_2.id
      L10_2 = L10_2(L11_2)
      if L10_2 then
        L10_2 = L9_2.id
        L10_2 = L3_2[L10_2]
        if not L10_2 then
          L10_2 = L9_2.id
          L3_2[L10_2] = true
          L10_2 = L18_1
          L11_2 = L9_2
          L10_2 = L10_2(L11_2)
          L11_2 = {}
          L12_2 = {}
          L13_2 = ipairs
          L14_2 = L17_1
          L15_2 = L10_2.modules
          L14_2, L15_2, L16_2, L17_2, L18_2, L19_2, L20_2, L21_2, L22_2, L23_2, L24_2, L25_2, L26_2, L27_2 = L14_2(L15_2)
          L13_2, L14_2, L15_2, L16_2 = L13_2(L14_2, L15_2, L16_2, L17_2, L18_2, L19_2, L20_2, L21_2, L22_2, L23_2, L24_2, L25_2, L26_2, L27_2)
          for L17_2, L18_2 in L13_2, L14_2, L15_2, L16_2 do
            L19_2 = type
            L20_2 = L18_2
            L19_2 = L19_2(L20_2)
            if "table" == L19_2 then
              L19_2 = L16_1
              L20_2 = L18_2.id
              L21_2 = 24
              L19_2 = L19_2(L20_2, L21_2)
              if L19_2 then
                L19_2 = L18_2.id
                L19_2 = L12_2[L19_2]
                if not L19_2 then
                  L20_2 = L18_2.type
                  L19_2 = L2_1
                  L19_2 = L19_2[L20_2]
                  if not L19_2 then
                    L20_2 = L18_2.type
                    L19_2 = L3_1
                    L19_2 = L19_2[L20_2]
                    if not L19_2 then
                      goto lbl_136
                    end
                  end
                  L19_2 = L18_2.id
                  L12_2[L19_2] = true
                  L19_2 = type
                  L20_2 = L18_2.options
                  L19_2 = L19_2(L20_2)
                  if "table" == L19_2 then
                    L19_2 = L18_2.options
                    if L19_2 then
                      goto lbl_90
                    end
                  end
                  L19_2 = {}
                  ::lbl_90::
                  L18_2.options = L19_2
                  L19_2 = L18_2.perms
                  if nil ~= L19_2 then
                    L19_2 = type
                    L20_2 = L18_2.perms
                    L19_2 = L19_2(L20_2)
                    if "table" ~= L19_2 then
                      L18_2.perms = nil
                    end
                  end
                  L19_2 = L18_2.jobs
                  if nil ~= L19_2 then
                    L19_2 = {}
                    L20_2 = ipairs
                    L21_2 = L17_1
                    L22_2 = L18_2.jobs
                    L21_2, L22_2, L23_2, L24_2, L25_2, L26_2, L27_2 = L21_2(L22_2)
                    L20_2, L21_2, L22_2, L23_2 = L20_2(L21_2, L22_2, L23_2, L24_2, L25_2, L26_2, L27_2)
                    for L24_2, L25_2 in L20_2, L21_2, L22_2, L23_2 do
                      L26_2 = type
                      L27_2 = L25_2
                      L26_2 = L26_2(L27_2)
                      if "string" == L26_2 and "" ~= L25_2 then
                        L26_2 = #L19_2
                        L26_2 = L26_2 + 1
                        L19_2[L26_2] = L25_2
                      end
                    end
                    L20_2 = #L19_2
                    L20_2 = L19_2 or L20_2
                    if not (L20_2 > 0) or not L19_2 then
                      L20_2 = nil
                    end
                    L18_2.jobs = L20_2
                  end
                  L19_2 = #L11_2
                  L19_2 = L19_2 + 1
                  L11_2[L19_2] = L18_2
                end
              end
            end
            ::lbl_136::
          end
          L10_2.modules = L11_2
          L13_2 = type
          L14_2 = L10_2.audience
          L13_2 = L13_2(L14_2)
          if "table" == L13_2 then
            L13_2 = L10_2.audience
            if L13_2 then
              goto lbl_150
            end
          end
          L13_2 = {}
          ::lbl_150::
          L10_2.audience = L13_2
          L13_2 = L10_2.audience
          L14_2 = L17_1
          L15_2 = L10_2.audience
          L15_2 = L15_2.jobs
          L14_2 = L14_2(L15_2)
          L13_2.jobs = L14_2
          L13_2 = #L1_2
          L13_2 = L13_2 + 1
          L1_2[L13_2] = L10_2
        end
      end
    end
  end
  return L1_2
end
function L28_1(A0_2)
  local L1_2, L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2
  L1_2 = {}
  L2_2 = {}
  L2_2.off = true
  L3_2 = ipairs
  L4_2 = A0_2.audience
  L4_2 = L4_2.jobs
  L3_2, L4_2, L5_2, L6_2 = L3_2(L4_2)
  for L7_2, L8_2 in L3_2, L4_2, L5_2, L6_2 do
    L9_2 = type
    L10_2 = L8_2
    L9_2 = L9_2(L10_2)
    if "table" == L9_2 then
      L9_2 = type
      L10_2 = L8_2.name
      L9_2 = L9_2(L10_2)
      if "string" == L9_2 then
        L9_2 = L8_2.name
        if "" ~= L9_2 then
          L9_2 = L12_1
          L10_2 = L8_2.minGrade
          L11_2 = 0
          L12_2 = 1000
          L13_2 = 0
          L9_2 = L9_2(L10_2, L11_2, L12_2, L13_2)
          L10_2 = L8_2.name
          L10_2 = L1_2[L10_2]
          if nil ~= L10_2 then
            L10_2 = L8_2.name
            L10_2 = L1_2[L10_2]
            if not (L9_2 < L10_2) then
              goto lbl_40
            end
          end
          L10_2 = L8_2.name
          L1_2[L10_2] = L9_2
        end
      end
    end
    ::lbl_40::
  end
  L3_2 = ipairs
  L4_2 = A0_2.modules
  L3_2, L4_2, L5_2, L6_2 = L3_2(L4_2)
  for L7_2, L8_2 in L3_2, L4_2, L5_2, L6_2 do
    L9_2 = L8_2.type
    if "duty" == L9_2 then
      L9_2 = L8_2.options
      L9_2 = L9_2.esxOffPrefix
      if L9_2 then
        goto lbl_55
      end
    end
    L9_2 = nil
    ::lbl_55::
    L10_2 = type
    L11_2 = L9_2
    L10_2 = L10_2(L11_2)
    if "string" == L10_2 then
      L11_2 = L9_2
      L10_2 = L9_2.match
      L12_2 = "^[%w_]+$"
      L10_2 = L10_2(L11_2, L12_2)
      if L10_2 then
        L10_2 = #L9_2
        if L10_2 <= 12 then
          L11_2 = L9_2
          L10_2 = L9_2.lower
          L10_2 = L10_2(L11_2)
          L2_2[L10_2] = true
        end
      end
    end
  end
  L3_2 = {}
  L3_2.jobs = L1_2
  L3_2.off = L2_2
  return L3_2
end
function L29_1()
  local L0_2, L1_2, L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2
  L0_2 = L9_1
  L0_2 = L0_2 + 1
  L9_1 = L0_2
  L0_2 = {}
  L1_2 = ipairs
  L2_2 = L7_1
  L1_2, L2_2, L3_2, L4_2 = L1_2(L2_2)
  for L5_2, L6_2 in L1_2, L2_2, L3_2, L4_2 do
    L7_2 = L18_1
    L8_2 = L6_2
    L7_2 = L7_2(L8_2)
    L7_2.webhooks = nil
    L8_2 = #L0_2
    L8_2 = L8_2 + 1
    L0_2[L8_2] = L7_2
  end
  L1_2 = GlobalState
  L2_2 = L0_1
  L3_2 = {}
  L4_2 = Now
  L4_2 = L4_2()
  L5_2 = L9_1
  L4_2 = L4_2 + L5_2
  L3_2.rev = L4_2
  L4_2 = L17_1
  L5_2 = L10_1
  L5_2 = L5_2()
  L5_2 = L5_2.categories
  L4_2 = L4_2(L5_2)
  L3_2.categories = L4_2
  L4_2 = L23_1
  L4_2 = L4_2()
  L3_2.server = L4_2
  L3_2.apps = L0_2
  L1_2[L2_2] = L3_2
end
function L30_1()
  local L0_2, L1_2
  L0_2 = L7_1
  return L0_2
end
CAppsDefs = L30_1
function L30_1(A0_2)
  local L1_2
  L1_2 = L6_1
  L1_2 = L1_2[A0_2]
  return L1_2
end
CAppsDef = L30_1
L30_1 = AdminStore
L30_1 = L30_1.OnChange
L31_1 = "capps"
function L32_1(A0_2)
  local L1_2, L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2
  L1_2 = L27_1
  L2_2 = A0_2
  L1_2 = L1_2(L2_2)
  L7_1 = L1_2
  L1_2 = {}
  L2_2 = {}
  L8_1 = L2_2
  L6_1 = L1_2
  L1_2 = ipairs
  L2_2 = L7_1
  L1_2, L2_2, L3_2, L4_2 = L1_2(L2_2)
  for L5_2, L6_2 in L1_2, L2_2, L3_2, L4_2 do
    L8_2 = L6_2.id
    L7_2 = L6_1
    L7_2[L8_2] = L6_2
    L8_2 = L6_2.id
    L7_2 = L8_1
    L9_2 = L28_1
    L10_2 = L6_2
    L9_2 = L9_2(L10_2)
    L7_2[L8_2] = L9_2
  end
  L1_2 = L29_1
  L1_2()
end
L30_1(L31_1, L32_1)
function L30_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2
  if A0_2 then
    L2_2 = type
    L3_2 = A1_2
    L2_2 = L2_2(L3_2)
    if "string" == L2_2 then
      goto lbl_10
    end
  end
  L2_2 = nil
  do return L2_2 end
  ::lbl_10::
  L2_2 = ipairs
  L3_2 = A0_2.modules
  L2_2, L3_2, L4_2, L5_2 = L2_2(L3_2)
  for L6_2, L7_2 in L2_2, L3_2, L4_2, L5_2 do
    L8_2 = L7_2.id
    if L8_2 == A1_2 then
      return L7_2
    end
  end
  L2_2 = nil
  return L2_2
end
function L31_1(A0_2)
  local L1_2, L2_2, L3_2, L4_2, L5_2
  L1_2 = L12_1
  L2_2 = A0_2 or L2_2
  if A0_2 then
    L2_2 = A0_2.gradeLevel
  end
  L3_2 = -100
  L4_2 = 1000
  L5_2 = 0
  return L1_2(L2_2, L3_2, L4_2, L5_2)
end
function L32_1(A0_2)
  local L1_2, L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2
  if A0_2 then
    L1_2 = A0_2.job
    if L1_2 then
      goto lbl_8
    end
  end
  L1_2 = {}
  ::lbl_8::
  L2_2 = FW
  L2_2 = L2_2.name
  if "standalone" == L2_2 and A0_2 then
    L2_2 = Config
    L2_2 = L2_2.Standalone
    L3_2 = type
    L4_2 = L2_2
    L3_2 = L3_2(L4_2)
    if "table" == L3_2 then
      L3_2 = L2_2.getJob
      if L3_2 then
        goto lbl_25
      end
    end
    L3_2 = nil
    ::lbl_25::
    L4_2 = type
    L5_2 = L3_2
    L4_2 = L4_2(L5_2)
    if "function" == L4_2 then
      L4_2 = pcall
      L5_2 = L3_2
      L6_2 = A0_2.src
      L4_2, L5_2 = L4_2(L5_2, L6_2)
      if L4_2 then
        L6_2 = type
        L7_2 = L5_2
        L6_2 = L6_2(L7_2)
        if "table" == L6_2 then
          L6_2 = type
          L7_2 = L5_2.name
          L6_2 = L6_2(L7_2)
          if "string" == L6_2 then
            L6_2 = L5_2.name
            if "" ~= L6_2 then
              L6_2 = {}
              L7_2 = L5_2.name
              L6_2.name = L7_2
              L7_2 = L5_2.label
              if not L7_2 then
                L7_2 = L5_2.name
              end
              L6_2.label = L7_2
              L7_2 = tostring
              L8_2 = L5_2.grade
              if not L8_2 then
                L8_2 = ""
              end
              L7_2 = L7_2(L8_2)
              L6_2.grade = L7_2
              L7_2 = tonumber
              L8_2 = L5_2.gradeLevel
              if not L8_2 then
                L8_2 = L5_2.level
              end
              L7_2 = L7_2(L8_2)
              if not L7_2 then
                L7_2 = 0
              end
              L6_2.gradeLevel = L7_2
              L7_2 = L5_2.onduty
              L7_2 = false ~= L7_2
              L6_2.onduty = L7_2
              L1_2 = L6_2
            end
          end
        end
      end
    end
  end
  return L1_2
end
function L33_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2
  if A0_2 and A1_2 then
    L2_2 = A1_2.enabled
    if false ~= L2_2 then
      goto lbl_10
    end
  end
  L2_2 = nil
  do return L2_2 end
  ::lbl_10::
  L3_2 = A1_2.id
  L2_2 = L8_1
  L2_2 = L2_2[L3_2]
  if not L2_2 then
    L2_2 = L28_1
    L3_2 = A1_2
    L2_2 = L2_2(L3_2)
  end
  L3_2 = L32_1
  L4_2 = A0_2
  L3_2 = L3_2(L4_2)
  L4_2 = L3_2.name
  L5_2 = L3_2.onduty
  L5_2 = false ~= L5_2
  L6_2 = type
  L7_2 = L4_2
  L6_2 = L6_2(L7_2)
  if "string" == L6_2 then
    L6_2 = L2_2.jobs
    L6_2 = L6_2[L4_2]
    if L6_2 then
      goto lbl_37
    end
  end
  L6_2 = nil
  ::lbl_37::
  if nil == L6_2 then
    L7_2 = FW
    L7_2 = L7_2.name
    if "esx" == L7_2 then
      L7_2 = type
      L8_2 = L4_2
      L7_2 = L7_2(L8_2)
      if "string" == L7_2 then
        L7_2 = pairs
        L8_2 = L2_2.off
        L7_2, L8_2, L9_2, L10_2 = L7_2(L8_2)
        for L11_2 in L7_2, L8_2, L9_2, L10_2 do
          L12_2 = #L4_2
          L13_2 = #L11_2
          if L12_2 > L13_2 then
            L13_2 = L4_2
            L12_2 = L4_2.sub
            L14_2 = 1
            L15_2 = #L11_2
            L12_2 = L12_2(L13_2, L14_2, L15_2)
            if L12_2 == L11_2 then
              L12_2 = L2_2.jobs
              L14_2 = L4_2
              L13_2 = L4_2.sub
              L15_2 = #L11_2
              L15_2 = L15_2 + 1
              L13_2 = L13_2(L14_2, L15_2)
              L12_2 = L12_2[L13_2]
              if nil ~= L12_2 then
                L13_2 = L4_2
                L12_2 = L4_2.sub
                L14_2 = #L11_2
                L14_2 = L14_2 + 1
                L12_2 = L12_2(L13_2, L14_2)
                L4_2 = L12_2
                L5_2 = false
                L12_2 = L2_2.jobs
                L6_2 = L12_2[L4_2]
                break
              end
            end
          end
        end
      end
    end
  end
  L7_2 = L31_1
  L8_2 = L3_2
  L7_2 = L7_2(L8_2)
  L8_2 = nil ~= L6_2 and L6_2 <= L7_2
  L9_2 = A1_2.audience
  L10_2 = {}
  L10_2.p = A0_2
  L11_2 = A0_2.src
  L10_2.src = L11_2
  L11_2 = A0_2.cid
  L10_2.cid = L11_2
  L10_2.member = L8_2
  L11_2 = L8_2 or L11_2
  if L8_2 then
    L11_2 = L9_2.onDutyOnly
    L11_2 = true ~= L11_2 or L11_2
  end
  L10_2.staff = L11_2
  L11_2 = L9_2.public
  L11_2 = false ~= L11_2
  L10_2.civil = L11_2
  L10_2.grade = L7_2
  L10_2.onduty = L5_2
  L11_2 = L4_2 or L11_2
  if not L8_2 or not L4_2 then
    L11_2 = L3_2.name
  end
  L10_2.job = L11_2
  L11_2 = L11_1
  L12_2 = L3_2.label
  L13_2 = 60
  L11_2 = L11_2(L12_2, L13_2)
  L10_2.jobLabel = L11_2
  L11_2 = L11_1
  L12_2 = L3_2.grade
  L13_2 = 60
  L11_2 = L11_2(L12_2, L13_2)
  L10_2.gradeLabel = L11_2
  return L10_2
end
function L34_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2
  L2_2 = L33_1
  L3_2 = FW
  L3_2 = L3_2.GetPlayer
  L4_2 = A0_2
  L3_2 = L3_2(L4_2)
  L4_2 = A1_2
  return L2_2(L3_2, L4_2)
end
function L35_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2
  L2_2 = L12_1
  L3_2 = A0_2.staffMinGrade
  L4_2 = 0
  L5_2 = 1000
  L6_2 = 0
  L2_2 = L2_2(L3_2, L4_2, L5_2, L6_2)
  L3_2 = A0_2.options
  L4_2 = L2_2
  if "delete" == A1_2 then
    L5_2 = L3_2.deleteGrade
    if nil == L5_2 then
      L6_2 = A0_2.type
      if "posts" == L6_2 then
        L5_2 = L3_2.postGrade
      end
    end
    if nil ~= L5_2 then
      L6_2 = L12_1
      L7_2 = L5_2
      L8_2 = 0
      L9_2 = 1000
      L10_2 = L2_2
      L6_2 = L6_2(L7_2, L8_2, L9_2, L10_2)
      L4_2 = L6_2
    end
  elseif "create" == A1_2 then
    L5_2 = A0_2.type
    if "posts" == L5_2 then
      L5_2 = L3_2.postGrade
      if nil ~= L5_2 then
        L5_2 = L12_1
        L6_2 = L3_2.postGrade
        L7_2 = 0
        L8_2 = 1000
        L9_2 = L2_2
        L5_2 = L5_2(L6_2, L7_2, L8_2, L9_2)
        L4_2 = L5_2
      end
    end
  end
  L5_2 = A0_2.perms
  L6_2 = type
  L7_2 = L5_2
  L6_2 = L6_2(L7_2)
  if "table" == L6_2 then
    L6_2 = L5_2[A1_2]
    if nil ~= L6_2 then
      L6_2 = tonumber
      L7_2 = L5_2[A1_2]
      L6_2 = L6_2(L7_2)
      if L6_2 then
        L6_2 = L12_1
        L7_2 = L5_2[A1_2]
        L8_2 = 0
        L9_2 = 1000
        L10_2 = L4_2
        return L6_2(L7_2, L8_2, L9_2, L10_2)
      end
    end
  end
  return L4_2
end
function L36_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2
  L2_2 = A1_2.jobs
  if not L2_2 then
    L2_2 = true
    return L2_2
  end
  L2_2 = ipairs
  L3_2 = A1_2.jobs
  L2_2, L3_2, L4_2, L5_2 = L2_2(L3_2)
  for L6_2, L7_2 in L2_2, L3_2, L4_2, L5_2 do
    L8_2 = A0_2.job
    if L7_2 == L8_2 then
      L8_2 = true
      return L8_2
    end
  end
  L2_2 = false
  return L2_2
end
function L37_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2
  if nil ~= A0_2 then
    L2_2 = A0_2.member
    if L2_2 then
      L2_2 = A1_2.staff
      if false ~= L2_2 then
        L2_2 = A1_2.enabled
        if false ~= L2_2 then
          goto lbl_14
        end
      end
    end
  end
  L2_2 = false
  do return L2_2 end
  ::lbl_14::
  L2_2 = L36_1
  L3_2 = A0_2
  L4_2 = A1_2
  L2_2 = L2_2(L3_2, L4_2)
  if L2_2 then
    L2_2 = A0_2.grade
    L3_2 = L35_1
    L4_2 = A1_2
    L5_2 = "view"
    L3_2 = L3_2(L4_2, L5_2)
    if not (L2_2 < L3_2) then
      goto lbl_29
    end
  end
  L2_2 = false
  do return L2_2 end
  ::lbl_29::
  L2_2 = A1_2.type
  if "duty" == L2_2 then
    L2_2 = true
    return L2_2
  end
  L2_2 = A0_2.staff
  return L2_2
end
function L38_1(A0_2, A1_2)
  local L2_2, L3_2
  if nil ~= A0_2 then
    L2_2 = A0_2.civil
    if L2_2 then
      L2_2 = A1_2.civil
      if false ~= L2_2 then
        L2_2 = A1_2.enabled
        if false ~= L2_2 then
          L3_2 = A1_2.type
          L2_2 = L4_1
          L2_2 = L2_2[L3_2]
          if not L2_2 then
            goto lbl_19
          end
        end
      end
    end
  end
  L2_2 = false
  do return L2_2 end
  ::lbl_19::
  L2_2 = A1_2.type
  if "records" == L2_2 then
    L2_2 = A1_2.options
    L2_2 = L2_2.civilSeesOwn
    L2_2 = true == L2_2
    return L2_2
  end
  L2_2 = A1_2.type
  if "posts" == L2_2 then
    L2_2 = A1_2.options
    L2_2 = L2_2.audience
    L2_2 = "staff" ~= L2_2
    return L2_2
  end
  L2_2 = true
  return L2_2
end
function L39_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2
  L2_2 = nil ~= A0_2
  return L2_2
end
function L40_1(A0_2, A1_2, A2_2)
  local L3_2, L4_2, L5_2, L6_2
  L3_2 = type
  L4_2 = A1_2
  L3_2 = L3_2(L4_2)
  if "string" == L3_2 then
    L3_2 = L6_1
    A1_2 = L3_2[A1_2]
  end
  L3_2 = L34_1
  L4_2 = A0_2
  L5_2 = A1_2
  L3_2 = L3_2(L4_2, L5_2)
  if not L3_2 then
    L4_2 = nil
    return L4_2
  end
  if nil == A2_2 then
    L4_2 = L3_2.staff
    if L4_2 then
      L4_2 = "staff"
      return L4_2
    end
    L4_2 = L3_2.civil
    if L4_2 then
      L4_2 = "civil"
      if L4_2 then
        goto lbl_30
      end
    end
    L4_2 = nil
    ::lbl_30::
    return L4_2
  end
  L4_2 = type
  L5_2 = A2_2
  L4_2 = L4_2(L5_2)
  if "string" == L4_2 then
    L4_2 = L30_1
    L5_2 = A1_2
    L6_2 = A2_2
    L4_2 = L4_2(L5_2, L6_2)
    A2_2 = L4_2
  end
  if A2_2 then
    L4_2 = A2_2.enabled
    if false ~= L4_2 then
      goto lbl_48
    end
  end
  L4_2 = nil
  do return L4_2 end
  ::lbl_48::
  L4_2 = L37_1
  L5_2 = L3_2
  L6_2 = A2_2
  L4_2 = L4_2(L5_2, L6_2)
  if L4_2 then
    L4_2 = "staff"
    return L4_2
  end
  L4_2 = L38_1
  L5_2 = L3_2
  L6_2 = A2_2
  L4_2 = L4_2(L5_2, L6_2)
  if L4_2 then
    L4_2 = "civil"
    return L4_2
  end
  L4_2 = nil
  return L4_2
end
CAppRole = L40_1
function L40_1(A0_2, A1_2, A2_2, A3_2)
  local L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2
  L4_2 = type
  L5_2 = A1_2
  L4_2 = L4_2(L5_2)
  if "string" == L4_2 then
    L4_2 = L6_1
    L4_2 = L4_2[A1_2]
    if L4_2 then
      goto lbl_11
    end
  end
  L4_2 = nil
  ::lbl_11::
  if L4_2 then
    L5_2 = L4_2.enabled
    if false ~= L5_2 then
      goto lbl_19
    end
  end
  L5_2 = nil
  L6_2 = "app"
  do return L5_2, L6_2 end
  ::lbl_19::
  L5_2 = L30_1
  L6_2 = L4_2
  L7_2 = A2_2
  L5_2 = L5_2(L6_2, L7_2)
  if L5_2 then
    L6_2 = L5_2.enabled
    if false ~= L6_2 then
      goto lbl_31
    end
  end
  L6_2 = nil
  L7_2 = "module"
  do return L6_2, L7_2 end
  ::lbl_31::
  L6_2 = L34_1
  L7_2 = A0_2
  L8_2 = L4_2
  L6_2 = L6_2(L7_2, L8_2)
  if L6_2 then
    L7_2 = L6_2.cid
    if L7_2 then
      goto lbl_43
    end
  end
  L7_2 = nil
  L8_2 = "noplayer"
  do return L7_2, L8_2 end
  ::lbl_43::
  if "staff" == A3_2 then
    L7_2 = "staff"
    if L7_2 then
      goto lbl_49
      A3_2 = L7_2 or A3_2
    end
  end
  A3_2 = "civil"
  ::lbl_49::
  if "staff" == A3_2 then
    L7_2 = L37_1
    L8_2 = L6_2
    L9_2 = L5_2
    L7_2 = L7_2(L8_2, L9_2)
    if not L7_2 then
      L7_2 = L6_2.member
      if L7_2 then
        L7_2 = L6_2.staff
        if not L7_2 then
          L7_2 = L5_2.staff
          if false ~= L7_2 then
            L7_2 = L36_1
            L8_2 = L6_2
            L9_2 = L5_2
            L7_2 = L7_2(L8_2, L9_2)
            if L7_2 then
              L7_2 = L6_2.grade
              L8_2 = L35_1
              L9_2 = L5_2
              L10_2 = "view"
              L8_2 = L8_2(L9_2, L10_2)
              if L7_2 >= L8_2 then
                L7_2 = nil
                L8_2 = "offduty"
                return L7_2, L8_2
              end
            end
          end
        end
      end
      L7_2 = nil
      L8_2 = "forbidden"
      return L7_2, L8_2
    end
  else
    L7_2 = L38_1
    L8_2 = L6_2
    L9_2 = L5_2
    L7_2 = L7_2(L8_2, L9_2)
    if not L7_2 then
      L7_2 = nil
      L8_2 = "forbidden"
      return L7_2, L8_2
    end
  end
  L7_2 = {}
  L7_2.def = L4_2
  L7_2.mod = L5_2
  L7_2.acc = L6_2
  L7_2.side = A3_2
  L8_2 = L6_2.cid
  L7_2.cid = L8_2
  L7_2.src = A0_2
  L9_2 = L5_2.type
  L8_2 = L2_1
  L8_2 = L8_2[L9_2]
  L7_2.kind = L8_2
  return L7_2
end
L41_1 = {}
L42_1 = {}
L42_1.id = "new"
L42_1.label = "Nova"
L42_1.color = "#0A84FF"
L43_1 = {}
L43_1.id = "progress"
L43_1.label = "Em an\195\161lise"
L43_1.color = "#FF9F0A"
L44_1 = {}
L44_1.id = "closed"
L44_1.label = "Fechada"
L44_1.color = "#8E8E93"
L44_1.closed = true
L41_1[1] = L42_1
L41_1[2] = L43_1
L41_1[3] = L44_1
L42_1 = {}
L43_1 = {}
L43_1.id = "new"
L43_1.label = "Recebida"
L43_1.color = "#0A84FF"
L44_1 = {}
L44_1.id = "preparing"
L44_1.label = "Em prepara\195\167\195\163o"
L44_1.color = "#FF9F0A"
L45_1 = {}
L45_1.id = "ready"
L45_1.label = "Pronta"
L45_1.color = "#30A46C"
L46_1 = {}
L46_1.id = "delivered"
L46_1.label = "Entregue"
L46_1.color = "#8E8E93"
L46_1.closed = true
L47_1 = {}
L47_1.id = "cancelled"
L47_1.label = "Cancelada"
L47_1.color = "#FF453A"
L47_1.closed = true
L42_1[1] = L43_1
L42_1[2] = L44_1
L42_1[3] = L45_1
L42_1[4] = L46_1
L42_1[5] = L47_1
function L43_1(A0_2)
  local L1_2, L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2
  L1_2 = {}
  L2_2 = ipairs
  L3_2 = L17_1
  L4_2 = A0_2.options
  L4_2 = L4_2.statuses
  L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2 = L3_2(L4_2)
  L2_2, L3_2, L4_2, L5_2 = L2_2(L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2)
  for L6_2, L7_2 in L2_2, L3_2, L4_2, L5_2 do
    L8_2 = type
    L9_2 = L7_2
    L8_2 = L8_2(L9_2)
    if "table" == L8_2 then
      L8_2 = type
      L9_2 = L7_2.id
      L8_2 = L8_2(L9_2)
      if "string" == L8_2 then
        L8_2 = L7_2.id
        L9_2 = L8_2
        L8_2 = L8_2.match
        L10_2 = "^[%w_%-]+$"
        L8_2 = L8_2(L9_2, L10_2)
        if L8_2 then
          L8_2 = L7_2.id
          L8_2 = #L8_2
          if L8_2 <= 24 then
            L8_2 = #L1_2
            L8_2 = L8_2 + 1
            L1_2[L8_2] = L7_2
          end
        end
      end
    end
  end
  L2_2 = #L1_2
  if 0 == L2_2 then
    L2_2 = A0_2.type
    if "catalog" == L2_2 then
      L2_2 = L42_1
      if L2_2 then
        goto lbl_47
      end
    end
    L2_2 = L41_1
    ::lbl_47::
    return L2_2
  end
  return L1_2
end
function L44_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2
  L2_2 = ipairs
  L3_2 = L43_1
  L4_2 = A0_2
  L3_2, L4_2, L5_2, L6_2, L7_2, L8_2 = L3_2(L4_2)
  L2_2, L3_2, L4_2, L5_2 = L2_2(L3_2, L4_2, L5_2, L6_2, L7_2, L8_2)
  for L6_2, L7_2 in L2_2, L3_2, L4_2, L5_2 do
    L8_2 = L7_2.id
    if L8_2 == A1_2 then
      return L7_2
    end
  end
  L2_2 = nil
  return L2_2
end
L45_1 = {}
L45_1.pending = true
L45_1.confirmed = true
L45_1.cancelled = true
L45_1.done = true
L46_1 = {}
L46_1.waiting = true
L46_1.accepted = true
L46_1.done = true
L46_1.cancelled = true
L47_1 = {}
L47_1.open = true
L47_1.archived = true
L48_1 = {}
L48_1.form = true
L48_1.order = true
function L49_1(A0_2, A1_2, A2_2)
  local L3_2, L4_2, L5_2
  L3_2 = L48_1
  L3_2 = L3_2[A1_2]
  if L3_2 then
    L3_2 = L44_1
    L4_2 = A0_2
    L5_2 = A2_2
    L3_2 = L3_2(L4_2, L5_2)
    L4_2 = nil ~= L3_2
    return L4_2
  end
  if "appt" == A1_2 or "call" == A1_2 then
    L3_2 = "cancelled" == A2_2 or "done" == A2_2
    return L3_2
  end
  if "record" == A1_2 then
    L3_2 = "archived" == A2_2
    return L3_2
  end
  if "bill" == A1_2 then
    L3_2 = "pending" ~= A2_2
    return L3_2
  end
  if "shift" == A1_2 then
    L3_2 = "closed" == A2_2
    return L3_2
  end
  L3_2 = false
  return L3_2
end
function L50_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2
  L2_2 = L48_1
  L2_2 = L2_2[A1_2]
  if L2_2 then
    L2_2 = {}
    L3_2 = ipairs
    L4_2 = L43_1
    L5_2 = A0_2
    L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2 = L4_2(L5_2)
    L3_2, L4_2, L5_2, L6_2 = L3_2(L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2)
    for L7_2, L8_2 in L3_2, L4_2, L5_2, L6_2 do
      L9_2 = L8_2.closed
      if L9_2 then
        L9_2 = #L2_2
        L9_2 = L9_2 + 1
        L10_2 = L8_2.id
        L2_2[L9_2] = L10_2
      end
    end
    return L2_2
  end
  if "appt" == A1_2 or "call" == A1_2 then
    L2_2 = {}
    L3_2 = "cancelled"
    L4_2 = "done"
    L2_2[1] = L3_2
    L2_2[2] = L4_2
    return L2_2
  end
  if "record" == A1_2 then
    L2_2 = {}
    L3_2 = "archived"
    L2_2[1] = L3_2
    return L2_2
  end
  if "bill" == A1_2 then
    L2_2 = {}
    L3_2 = "paid"
    L4_2 = "refused"
    L5_2 = "cancelled"
    L2_2[1] = L3_2
    L2_2[2] = L4_2
    L2_2[3] = L5_2
    return L2_2
  end
  if "shift" == A1_2 then
    L2_2 = {}
    L3_2 = "closed"
    L2_2[1] = L3_2
    return L2_2
  end
  L2_2 = {}
  return L2_2
end
function L51_1(A0_2, A1_2, A2_2)
  local L3_2, L4_2, L5_2
  L3_2 = L48_1
  L3_2 = L3_2[A1_2]
  if L3_2 then
    L3_2 = A0_2 or L3_2
    if A0_2 then
      L3_2 = L44_1
      L4_2 = A0_2
      L5_2 = A2_2
      L3_2 = L3_2(L4_2, L5_2)
    end
    if L3_2 then
      L4_2 = tostring
      L5_2 = L3_2.label
      if not L5_2 then
        L5_2 = L3_2.id
      end
      return L4_2(L5_2)
    end
  end
  if "call" == A1_2 then
    L3_2 = {}
    L3_2.waiting = "\195\128 espera"
    L3_2.accepted = "Aceite"
    L3_2.done = "Conclu\195\173do"
    L3_2.cancelled = "Cancelado"
    L4_2 = L3_2[A2_2]
    if L4_2 then
      L4_2 = L3_2[A2_2]
      return L4_2
    end
  end
  if "bill" == A1_2 then
    L3_2 = {}
    L3_2.pending = "Pendente"
    L3_2.paid = "Paga"
    L3_2.refused = "Recusada"
    L3_2.cancelled = "Anulada"
    L4_2 = L3_2[A2_2]
    if L4_2 then
      L4_2 = L3_2[A2_2]
      return L4_2
    end
  end
  if "shift" == A1_2 then
    L3_2 = {}
    L3_2.open = "Em servi\195\167o"
    L3_2.closed = "Terminado"
    L4_2 = L3_2[A2_2]
    if L4_2 then
      L4_2 = L3_2[A2_2]
      return L4_2
    end
  end
  L3_2 = {}
  L3_2.pending = "Pendente"
  L3_2.confirmed = "Confirmada"
  L3_2.cancelled = "Cancelada"
  L3_2.done = "Conclu\195\173da"
  L3_2.waiting = "\195\128 espera"
  L3_2.accepted = "Aceite"
  L3_2.open = "Ativa"
  L3_2.archived = "Arquivada"
  L4_2 = L3_2[A2_2]
  if not L4_2 then
    L4_2 = tostring
    L5_2 = A2_2
    L4_2 = L4_2(L5_2)
  end
  return L4_2
end
L52_1 = "CREATE TABLE IF NOT EXISTS `apex_phone_capp_items` (`id` BIGINT NOT NULL AUTO_INCREMENT, `app` VARCHAR(32) NOT NULL, `module` VARCHAR(24) NOT NULL, `kind` VARCHAR(12) NOT NULL, `owner` VARCHAR(64) NULL, `owner_name` VARCHAR(100) NULL, `owner_phone` VARCHAR(32) NULL, `anonymous` TINYINT NOT NULL DEFAULT 0, `status` VARCHAR(24) NOT NULL, `title` VARCHAR(160) NOT NULL, `subject` VARCHAR(100) NULL, `data` LONGTEXT NULL, `assignee` VARCHAR(64) NULL, `assignee_name` VARCHAR(100) NULL, `x` FLOAT NULL, `y` FLOAT NULL, `z` FLOAT NULL, `at` BIGINT NULL, `pinned` TINYINT NOT NULL DEFAULT 0, `created` BIGINT NOT NULL, `updated` BIGINT NOT NULL, PRIMARY KEY (`id`), KEY `ams` (`app`,`module`,`status`), KEY `owner` (`owner`), KEY `amat` (`app`,`module`,`at`))"
L53_1 = "CREATE TABLE IF NOT EXISTS `apex_phone_capp_notes` (`id` BIGINT NOT NULL AUTO_INCREMENT, `item` BIGINT NOT NULL, `author` VARCHAR(64) NOT NULL, `author_name` VARCHAR(100) NULL, `staff` TINYINT NOT NULL DEFAULT 0, `private` TINYINT NOT NULL DEFAULT 0, `text` VARCHAR(1500) NOT NULL, `created` BIGINT NOT NULL, PRIMARY KEY (`id`), KEY `item` (`item`))"
L54_1 = false
function L55_1()
  local L0_2, L1_2, L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2
  L0_2 = tonumber
  L1_2 = L10_1
  L1_2 = L1_2()
  L1_2 = L1_2.itemsKeepDays
  L0_2 = L0_2(L1_2)
  if not L0_2 then
    L0_2 = 90
  end
  if not (L0_2 <= 0) then
    L1_2 = L54_1
    if L1_2 then
      goto lbl_15
    end
  end
  do return end
  ::lbl_15::
  L1_2 = Now
  L1_2 = L1_2()
  L2_2 = math
  L2_2 = L2_2.floor
  L3_2 = L0_2 * 86400000
  L2_2 = L2_2(L3_2)
  L1_2 = L1_2 - L2_2
  L2_2 = {}
  L3_2 = MySQL
  L3_2 = L3_2.query
  L3_2 = L3_2.await
  L4_2 = "SELECT id, app, module, kind, status FROM apex_phone_capp_items WHERE updated < ? AND kind IN ('form', 'appt', 'call', 'order', 'bill', 'shift') LIMIT 5000"
  L5_2 = {}
  L6_2 = L1_2
  L5_2[1] = L6_2
  L3_2 = L3_2(L4_2, L5_2)
  if not L3_2 then
    L3_2 = {}
  end
  L4_2 = ipairs
  L5_2 = L3_2
  L4_2, L5_2, L6_2, L7_2 = L4_2(L5_2)
  for L8_2, L9_2 in L4_2, L5_2, L6_2, L7_2 do
    L11_2 = L9_2.app
    L10_2 = L6_1
    L10_2 = L10_2[L11_2]
    L11_2 = L10_2 or L11_2
    if L10_2 then
      L11_2 = L30_1
      L12_2 = L10_2
      L13_2 = L9_2.module
      L11_2 = L11_2(L12_2, L13_2)
    end
    L12_2 = nil
    if L11_2 then
      L13_2 = L49_1
      L14_2 = L11_2
      L15_2 = L9_2.kind
      L16_2 = L9_2.status
      L13_2 = L13_2(L14_2, L15_2, L16_2)
      L12_2 = L13_2
    else
      L13_2 = L9_2.status
      L12_2 = "done" == L13_2
    end
    if L12_2 then
      L13_2 = #L2_2
      L13_2 = L13_2 + 1
      L14_2 = tonumber
      L15_2 = L9_2.id
      L14_2 = L14_2(L15_2)
      L2_2[L13_2] = L14_2
    end
  end
  L4_2 = 1
  L5_2 = #L2_2
  L6_2 = 200
  for L7_2 = L4_2, L5_2, L6_2 do
    L8_2 = {}
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
    L9_2 = "?,"
    L10_2 = L9_2
    L9_2 = L9_2.rep
    L11_2 = #L8_2
    L9_2 = L9_2(L10_2, L11_2)
    L10_2 = L9_2
    L9_2 = L9_2.sub
    L11_2 = 1
    L12_2 = -2
    L9_2 = L9_2(L10_2, L11_2, L12_2)
    L10_2 = MySQL
    L10_2 = L10_2.update
    L10_2 = L10_2.await
    L11_2 = "DELETE FROM apex_phone_capp_notes WHERE item IN ("
    L12_2 = L9_2
    L13_2 = ")"
    L11_2 = L11_2 .. L12_2 .. L13_2
    L12_2 = L8_2
    L10_2(L11_2, L12_2)
    L10_2 = MySQL
    L10_2 = L10_2.update
    L10_2 = L10_2.await
    L11_2 = "DELETE FROM apex_phone_capp_items WHERE id IN ("
    L12_2 = L9_2
    L13_2 = ")"
    L11_2 = L11_2 .. L12_2 .. L13_2
    L12_2 = L8_2
    L10_2(L11_2, L12_2)
  end
  L4_2 = #L2_2
  if L4_2 > 0 then
    L4_2 = print
    L5_2 = "^2[unique_phone]^0 job apps: %d old closed record(s) deleted"
    L6_2 = L5_2
    L5_2 = L5_2.format
    L7_2 = #L2_2
    L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2 = L5_2(L6_2, L7_2)
    L4_2(L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2)
  end
end
L56_1 = CreateThread
function L57_1()
  local L0_2, L1_2, L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2
  L0_2 = pcall
  function L1_2()
    local L0_3, L1_3
    L0_3 = MySQL
    L0_3 = L0_3.query
    L0_3 = L0_3.await
    L1_3 = L52_1
    L0_3(L1_3)
    L0_3 = MySQL
    L0_3 = L0_3.query
    L0_3 = L0_3.await
    L1_3 = L53_1
    L0_3(L1_3)
  end
  L0_2, L1_2 = L0_2(L1_2)
  if not L0_2 then
    L2_2 = print
    L3_2 = "^1[unique_phone]^0 job apps (tables): %s"
    L4_2 = L3_2
    L3_2 = L3_2.format
    L5_2 = tostring
    L6_2 = L1_2
    L5_2, L6_2, L7_2, L8_2 = L5_2(L6_2)
    L3_2, L4_2, L5_2, L6_2, L7_2, L8_2 = L3_2(L4_2, L5_2, L6_2, L7_2, L8_2)
    L2_2(L3_2, L4_2, L5_2, L6_2, L7_2, L8_2)
    return
  end
  L2_2 = MigrateTable
  if L2_2 then
    L2_2 = pcall
    L3_2 = MigrateTable
    L4_2 = L52_1
    L2_2(L3_2, L4_2)
    L2_2 = pcall
    L3_2 = MigrateTable
    L4_2 = L53_1
    L2_2(L3_2, L4_2)
  end
  L2_2 = true
  L54_1 = L2_2
  L2_2 = Wait
  L3_2 = 20000
  L2_2(L3_2)
  while true do
    L2_2 = pcall
    L3_2 = L55_1
    L2_2, L3_2 = L2_2(L3_2)
    if not L2_2 then
      L4_2 = print
      L5_2 = "^1[unique_phone]^0 job apps (cleanup): %s"
      L6_2 = L5_2
      L5_2 = L5_2.format
      L7_2 = tostring
      L8_2 = L3_2
      L7_2, L8_2 = L7_2(L8_2)
      L5_2, L6_2, L7_2, L8_2 = L5_2(L6_2, L7_2, L8_2)
      L4_2(L5_2, L6_2, L7_2, L8_2)
    end
    L4_2 = Wait
    L5_2 = 21600000
    L4_2(L5_2)
  end
end
L56_1(L57_1)
function L56_1(A0_2)
  local L1_2, L2_2, L3_2, L4_2
  L1_2 = math
  L1_2 = L1_2.tointeger
  L2_2 = tonumber
  L3_2 = A0_2
  L2_2, L3_2, L4_2 = L2_2(L3_2)
  L1_2 = L1_2(L2_2, L3_2, L4_2)
  A0_2 = L1_2
  if not A0_2 or A0_2 < 1 then
    L1_2 = nil
    return L1_2
  end
  L1_2 = MySQL
  L1_2 = L1_2.single
  L1_2 = L1_2.await
  L2_2 = "SELECT * FROM apex_phone_capp_items WHERE id = ?"
  L3_2 = {}
  L4_2 = A0_2
  L3_2[1] = L4_2
  return L1_2(L2_2, L3_2)
end
L57_1 = {}
L57_1.pending = true
L57_1.paid = true
L57_1.refused = true
L57_1.cancelled = true
function L58_1(A0_2)
  local L1_2, L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2, L19_2, L20_2, L21_2, L22_2, L23_2
  L1_2 = {}
  L2_2 = {}
  L3_2 = ipairs
  L4_2 = A0_2
  L3_2, L4_2, L5_2, L6_2 = L3_2(L4_2)
  for L7_2, L8_2 in L3_2, L4_2, L5_2, L6_2 do
    L9_2 = L8_2.kind
    if "bill" == L9_2 then
      L9_2 = L22_1
      L10_2 = L8_2.data
      L9_2 = L9_2(L10_2)
      L10_2 = L9_2 or L10_2
      if L9_2 then
        L10_2 = math
        L10_2 = L10_2.tointeger
        L11_2 = tonumber
        L12_2 = L9_2.billId
        L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2, L19_2, L20_2, L21_2, L22_2, L23_2 = L11_2(L12_2)
        L10_2 = L10_2(L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2, L19_2, L20_2, L21_2, L22_2, L23_2)
      end
      if L10_2 then
        L11_2 = #L1_2
        L11_2 = L11_2 + 1
        L1_2[L11_2] = L10_2
        L11_2 = L2_2[L10_2]
        if not L11_2 then
          L11_2 = {}
        end
        L2_2[L10_2] = L11_2
        L11_2 = L2_2[L10_2]
        L12_2 = L2_2[L10_2]
        L12_2 = #L12_2
        L12_2 = L12_2 + 1
        L11_2[L12_2] = L8_2
      end
    end
  end
  L3_2 = #L1_2
  if 0 == L3_2 then
    return
  end
  L3_2 = pcall
  function L4_2()
    local L0_3, L1_3, L2_3, L3_3, L4_3, L5_3
    L0_3 = MySQL
    L0_3 = L0_3.query
    L0_3 = L0_3.await
    L1_3 = "SELECT id, status FROM apex_phone_bills WHERE id IN ("
    L2_3 = "?,"
    L3_3 = L2_3
    L2_3 = L2_3.rep
    L4_3 = L1_2
    L4_3 = #L4_3
    L2_3 = L2_3(L3_3, L4_3)
    L3_3 = L2_3
    L2_3 = L2_3.sub
    L4_3 = 1
    L5_3 = -2
    L2_3 = L2_3(L3_3, L4_3, L5_3)
    L3_3 = ")"
    L1_3 = L1_3 .. L2_3 .. L3_3
    L2_3 = L1_2
    return L0_3(L1_3, L2_3)
  end
  L3_2, L4_2 = L3_2(L4_2)
  if L3_2 then
    L5_2 = type
    L6_2 = L4_2
    L5_2 = L5_2(L6_2)
    if "table" == L5_2 then
      goto lbl_59
    end
  end
  do return end
  ::lbl_59::
  L5_2 = ipairs
  L6_2 = L4_2
  L5_2, L6_2, L7_2, L8_2 = L5_2(L6_2)
  for L9_2, L10_2 in L5_2, L6_2, L7_2, L8_2 do
    L11_2 = tostring
    L12_2 = L10_2.status
    if not L12_2 then
      L12_2 = ""
    end
    L11_2 = L11_2(L12_2)
    L12_2 = ipairs
    L13_2 = tonumber
    L14_2 = L10_2.id
    L13_2 = L13_2(L14_2)
    L13_2 = L2_2[L13_2]
    if not L13_2 then
      L13_2 = {}
    end
    L12_2, L13_2, L14_2, L15_2 = L12_2(L13_2)
    for L16_2, L17_2 in L12_2, L13_2, L14_2, L15_2 do
      L18_2 = L57_1
      L18_2 = L18_2[L11_2]
      if L18_2 then
        L18_2 = L17_2.status
        if L18_2 ~= L11_2 then
          L18_2 = MySQL
          L18_2 = L18_2.update
          L18_2 = L18_2.await
          L19_2 = "UPDATE apex_phone_capp_items SET status = ? WHERE id = ?"
          L20_2 = {}
          L21_2 = L11_2
          L22_2 = tonumber
          L23_2 = L17_2.id
          L22_2, L23_2 = L22_2(L23_2)
          L20_2[1] = L21_2
          L20_2[2] = L22_2
          L20_2[3] = L23_2
          L18_2(L19_2, L20_2)
          L17_2.status = L11_2
        end
      end
    end
  end
end
L59_1 = {}
L59_1.text = true
L59_1.textarea = true
L59_1.select = true
L59_1.plate = true
function L60_1(A0_2, A1_2, A2_2)
  local L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2
  L3_2 = type
  L4_2 = A1_2
  L3_2 = L3_2(L4_2)
  if "table" ~= L3_2 then
    L3_2 = nil
    return L3_2
  end
  L3_2 = A0_2.kind
  if "post" == L3_2 then
    L3_2 = L11_1
    L4_2 = A1_2.body
    L5_2 = 160
    return L3_2(L4_2, L5_2)
  end
  L3_2 = A0_2.kind
  if "call" == L3_2 then
    L3_2 = L11_1
    L4_2 = A1_2.message
    L5_2 = 160
    return L3_2(L4_2, L5_2)
  end
  L3_2 = A0_2.kind
  if "appt" == L3_2 then
    L3_2 = L11_1
    L4_2 = A1_2.service_label
    L5_2 = 80
    return L3_2(L4_2, L5_2)
  end
  L3_2 = A0_2.kind
  if "order" == L3_2 then
    L3_2 = {}
    L4_2 = ipairs
    L5_2 = L17_1
    L6_2 = A1_2.lines
    L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2 = L5_2(L6_2)
    L4_2, L5_2, L6_2, L7_2 = L4_2(L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2)
    for L8_2, L9_2 in L4_2, L5_2, L6_2, L7_2 do
      L10_2 = type
      L11_2 = L9_2
      L10_2 = L10_2(L11_2)
      if "table" == L10_2 then
        L10_2 = #L3_2
        L10_2 = L10_2 + 1
        L11_2 = "%dx %s"
        L12_2 = L11_2
        L11_2 = L11_2.format
        L13_2 = L12_1
        L14_2 = L9_2.qty
        L15_2 = 1
        L16_2 = 999
        L17_2 = 1
        L13_2 = L13_2(L14_2, L15_2, L16_2, L17_2)
        L14_2 = tostring
        L15_2 = L9_2.label
        if not L15_2 then
          L15_2 = L9_2.id
          if not L15_2 then
            L15_2 = ""
          end
        end
        L14_2, L15_2, L16_2, L17_2 = L14_2(L15_2)
        L11_2 = L11_2(L12_2, L13_2, L14_2, L15_2, L16_2, L17_2)
        L3_2[L10_2] = L11_2
      end
      L10_2 = #L3_2
      if L10_2 >= 4 then
        break
      end
    end
    L4_2 = L11_1
    L5_2 = table
    L5_2 = L5_2.concat
    L6_2 = L3_2
    L7_2 = " \194\183 "
    L5_2 = L5_2(L6_2, L7_2)
    L6_2 = 160
    return L4_2(L5_2, L6_2)
  end
  L3_2 = A0_2.kind
  if "bill" == L3_2 then
    L3_2 = L11_1
    L4_2 = A1_2.reason
    L5_2 = 160
    return L3_2(L4_2, L5_2)
  end
  L3_2 = type
  L4_2 = A1_2.fields
  L3_2 = L3_2(L4_2)
  if "table" == L3_2 then
    L3_2 = nil
    if A2_2 then
      L4_2 = {}
      L3_2 = L4_2
      L4_2 = ipairs
      L5_2 = L17_1
      L6_2 = A2_2.options
      L6_2 = L6_2.fields
      L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2 = L5_2(L6_2)
      L4_2, L5_2, L6_2, L7_2 = L4_2(L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2)
      for L8_2, L9_2 in L4_2, L5_2, L6_2, L7_2 do
        L10_2 = type
        L11_2 = L9_2
        L10_2 = L10_2(L11_2)
        if "table" == L10_2 then
          L10_2 = L9_2.key
          if L10_2 then
            L10_2 = L9_2.type
            if not L10_2 then
              L10_2 = "text"
            end
            L11_2 = L59_1
            L10_2 = L11_2[L10_2]
            if L10_2 then
              L10_2 = L9_2.key
              L3_2[L10_2] = true
            end
          end
        end
      end
    end
    L4_2 = {}
    L5_2 = ipairs
    L6_2 = L17_1
    L7_2 = A1_2.order
    L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2 = L6_2(L7_2)
    L5_2, L6_2, L7_2, L8_2 = L5_2(L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2)
    for L9_2, L10_2 in L5_2, L6_2, L7_2, L8_2 do
      L11_2 = A1_2.fields
      L11_2 = L11_2[L10_2]
      L12_2 = type
      L13_2 = L11_2
      L12_2 = L12_2(L13_2)
      if "string" == L12_2 and "" ~= L11_2 then
        L12_2 = A0_2.title
        if L11_2 ~= L12_2 then
          if L3_2 then
            L12_2 = L3_2[L10_2]
            if not L12_2 then
              goto lbl_165
            end
          end
          L12_2 = #L4_2
          L12_2 = L12_2 + 1
          L14_2 = L11_2
          L13_2 = L11_2.gsub
          L15_2 = "%s+"
          L16_2 = " "
          L13_2 = L13_2(L14_2, L15_2, L16_2)
          L4_2[L12_2] = L13_2
        end
      end
      ::lbl_165::
      L12_2 = #L4_2
      if L12_2 >= 2 then
        break
      end
    end
    L5_2 = L11_1
    L6_2 = table
    L6_2 = L6_2.concat
    L7_2 = L4_2
    L8_2 = " \194\183 "
    L6_2 = L6_2(L7_2, L8_2)
    L7_2 = 160
    return L5_2(L6_2, L7_2)
  end
  L3_2 = nil
  return L3_2
end
function L61_1(A0_2, A1_2, A2_2)
  local L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2
  L3_2 = L22_1
  L4_2 = A0_2.data
  L3_2 = L3_2(L4_2)
  L4_2 = tonumber
  L5_2 = A0_2.anonymous
  L4_2 = L4_2(L5_2)
  L4_2 = 1 == L4_2
  L5_2 = A1_2 or L5_2
  if A1_2 then
    L5_2 = A0_2.owner
    L5_2 = nil ~= L5_2
  end
  L6_2 = {}
  L7_2 = tonumber
  L8_2 = A0_2.id
  L7_2 = L7_2(L8_2)
  L6_2.id = L7_2
  L7_2 = A0_2.app
  L6_2.app = L7_2
  L7_2 = A0_2.module
  L6_2.module = L7_2
  L7_2 = A0_2.kind
  L6_2.kind = L7_2
  L7_2 = A0_2.status
  L6_2.status = L7_2
  L7_2 = A0_2.title
  L6_2.title = L7_2
  L7_2 = A0_2.subject
  L6_2.subject = L7_2
  L6_2.anonymous = L4_2
  L7_2 = L5_2 or L7_2
  if not L5_2 then
    L7_2 = nil
  end
  L6_2.mine = L7_2
  L7_2 = tonumber
  L8_2 = A0_2.pinned
  L7_2 = L7_2(L8_2)
  L7_2 = 1 == L7_2
  L6_2.pinned = L7_2
  L7_2 = tonumber
  L8_2 = A0_2.created
  L7_2 = L7_2(L8_2)
  L6_2.created = L7_2
  L7_2 = tonumber
  L8_2 = A0_2.updated
  L7_2 = L7_2(L8_2)
  L6_2.updated = L7_2
  L7_2 = tonumber
  L8_2 = A0_2.at
  L7_2 = L7_2(L8_2)
  L6_2.at = L7_2
  L7_2 = A0_2.assignee_name
  L6_2.assignee_name = L7_2
  if A1_2 then
    L7_2 = A0_2.assignee
    if nil ~= L7_2 then
      L7_2 = A0_2.assignee
      L8_2 = A1_2.cid
    end
  end
  L7_2 = L7_2 == L8_2 or L7_2
  L6_2.assigned = L7_2
  if not L4_2 then
    L7_2 = A0_2.owner_name
    L6_2.owner_name = L7_2
  end
  if A1_2 then
    L7_2 = A1_2.side
    if "staff" == L7_2 and not L4_2 then
      L7_2 = A0_2.owner_phone
      L6_2.owner_phone = L7_2
    end
  end
  if A1_2 then
    L7_2 = A1_2.side
  end
  if "staff" == L7_2 or L5_2 then
    L7_2 = A0_2.x
    if L7_2 then
      L7_2 = tonumber
      L8_2 = A0_2.x
      L7_2 = L7_2(L8_2)
      L8_2 = tonumber
      L9_2 = A0_2.y
      L8_2 = L8_2(L9_2)
      L9_2 = tonumber
      L10_2 = A0_2.z
      L9_2 = L9_2(L10_2)
      L6_2.z = L9_2
      L6_2.y = L8_2
      L6_2.x = L7_2
    end
  end
  L7_2 = type
  L8_2 = L3_2
  L7_2 = L7_2(L8_2)
  if "table" == L7_2 then
    L7_2 = A0_2.kind
    if "appt" == L7_2 then
      L7_2 = L3_2.day
      L8_2 = L3_2.time
      L9_2 = L3_2.service
      L10_2 = L3_2.service_label
      L6_2.service_label = L10_2
      L6_2.service = L9_2
      L6_2.time = L8_2
      L6_2.day = L7_2
    end
    L7_2 = A0_2.kind
    if "call" == L7_2 then
      L7_2 = L3_2.type
      L6_2.type = L7_2
    end
    L7_2 = A0_2.kind
    if "post" == L7_2 then
      L7_2 = L3_2.image
      L6_2.image = L7_2
    end
    L7_2 = A0_2.kind
    if "record" == L7_2 then
      L7_2 = L3_2.tags
      L6_2.tags = L7_2
    end
    L7_2 = A0_2.kind
    if "order" == L7_2 then
      L7_2 = L3_2.total
      L8_2 = L3_2.count
      L9_2 = L3_2.currency
      L10_2 = L3_2.billId
      L6_2.billId = L10_2
      L6_2.currency = L9_2
      L6_2.count = L8_2
      L6_2.total = L7_2
    end
    L7_2 = A0_2.kind
    if "bill" == L7_2 then
      L7_2 = L3_2.amount
      L8_2 = L3_2.billId
      L6_2.billId = L8_2
      L6_2.amount = L7_2
    end
    L7_2 = A0_2.kind
    if "shift" == L7_2 then
      L7_2 = L3_2.minutes
      L8_2 = L3_2.stop
      L6_2.stop = L8_2
      L6_2.minutes = L7_2
    end
  end
  if A2_2 then
    L7_2 = type
    L8_2 = L3_2
    L7_2 = L7_2(L8_2)
    if "table" == L7_2 then
      L3_2.order = nil
      L6_2.data = L3_2
    end
  else
    L8_2 = A0_2.app
    L7_2 = L6_1
    L7_2 = L7_2[L8_2]
    L8_2 = L60_1
    L9_2 = A0_2
    L10_2 = L3_2
    if A1_2 then
      L11_2 = A1_2.mod
      if L11_2 then
        goto lbl_202
      end
    end
    if L7_2 then
      L11_2 = L30_1
      L12_2 = L7_2
      L13_2 = A0_2.module
      L11_2 = L11_2(L12_2, L13_2)
      if L11_2 then
        goto lbl_202
      end
    end
    L11_2 = nil
    ::lbl_202::
    L8_2 = L8_2(L9_2, L10_2, L11_2)
    L6_2.preview = L8_2
  end
  return L6_2
end
function L62_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2
  L2_2 = {}
  L3_2 = tonumber
  L4_2 = A0_2.id
  L3_2 = L3_2(L4_2)
  L2_2.id = L3_2
  L3_2 = A0_2.author_name
  L2_2.author_name = L3_2
  L3_2 = tonumber
  L4_2 = A0_2.staff
  L3_2 = L3_2(L4_2)
  L3_2 = 1 == L3_2
  L2_2.staff = L3_2
  L3_2 = tonumber
  L4_2 = A0_2.private
  L3_2 = L3_2(L4_2)
  L3_2 = 1 == L3_2
  L2_2.private = L3_2
  L3_2 = A0_2.text
  L2_2.text = L3_2
  L3_2 = tonumber
  L4_2 = A0_2.created
  L3_2 = L3_2(L4_2)
  L2_2.created = L3_2
  L3_2 = A0_2.author
  L4_2 = A1_2.cid
  L3_2 = L3_2 == L4_2 or L3_2
  L2_2.mine = L3_2
  return L2_2
end
function L63_1(A0_2)
  local L1_2, L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2
  L1_2 = {}
  L2_2 = ipairs
  L3_2 = FW
  L3_2 = L3_2.GetPlayers
  L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2 = L3_2()
  L2_2, L3_2, L4_2, L5_2 = L2_2(L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2)
  for L6_2, L7_2 in L2_2, L3_2, L4_2, L5_2 do
    L8_2 = FW
    L8_2 = L8_2.GetPlayer
    L9_2 = L7_2
    L8_2 = L8_2(L9_2)
    L9_2 = L33_1
    L10_2 = L8_2
    L11_2 = A0_2
    L9_2 = L9_2(L10_2, L11_2)
    if L9_2 then
      L10_2 = #L1_2
      L10_2 = L10_2 + 1
      L11_2 = {}
      L11_2.src = L7_2
      L11_2.p = L8_2
      L11_2.acc = L9_2
      L1_2[L10_2] = L11_2
    end
  end
  return L1_2
end
function L64_1(A0_2)
  local L1_2, L2_2, L3_2
  if not A0_2 then
    L1_2 = nil
    return L1_2
  end
  L1_2 = FW
  L1_2 = L1_2.GetPlayerByCid
  L2_2 = A0_2
  L1_2 = L1_2(L2_2)
  if L1_2 then
    L2_2 = tonumber
    L3_2 = L1_2.src
    L2_2 = L2_2(L3_2)
    if L2_2 then
      goto lbl_17
    end
  end
  L2_2 = nil
  ::lbl_17::
  return L2_2
end
function L65_1(A0_2, A1_2, A2_2, A3_2)
  local L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2
  L4_2 = {}
  L5_2 = A0_2.id
  L4_2.app = L5_2
  L5_2 = A1_2.id
  L4_2.module = L5_2
  L5_2 = tonumber
  L6_2 = A2_2.id
  L5_2 = L5_2(L6_2)
  L4_2.id = L5_2
  L5_2 = A2_2.kind
  L4_2.kind = L5_2
  L5_2 = A2_2.status
  L4_2.status = L5_2
  if A3_2 then
    L5_2 = A3_2.deleted
    if L5_2 then
      goto lbl_21
    end
  end
  L5_2 = nil
  ::lbl_21::
  L4_2.deleted = L5_2
  L5_2 = A2_2.kind
  L5_2 = "post" == L5_2
  L6_2 = {}
  L7_2 = ipairs
  L8_2 = L63_1
  L9_2 = A0_2
  L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2 = L8_2(L9_2)
  L7_2, L8_2, L9_2, L10_2 = L7_2(L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2)
  for L11_2, L12_2 in L7_2, L8_2, L9_2, L10_2 do
    L13_2 = L12_2.acc
    L13_2 = L13_2.member
    if not L13_2 then
      if not L5_2 then
        goto lbl_56
      end
      L13_2 = L12_2.acc
      L13_2 = L13_2.civil
      if not L13_2 then
        goto lbl_56
      end
    end
    L13_2 = L12_2.src
    L6_2[L13_2] = true
    L13_2 = Push
    L14_2 = L12_2.src
    L15_2 = "capps:changed"
    L16_2 = L4_2
    L13_2(L14_2, L15_2, L16_2)
    ::lbl_56::
  end
  L7_2 = A2_2.kind
  if "bill" ~= L7_2 then
    L7_2 = A2_2.kind
    if "shift" ~= L7_2 then
      L7_2 = L64_1
      L8_2 = A2_2.owner
      L7_2 = L7_2(L8_2)
      if L7_2 then
        L8_2 = L6_2[L7_2]
        if not L8_2 then
          L8_2 = Push
          L9_2 = L7_2
          L10_2 = "capps:changed"
          L11_2 = L4_2
          L8_2(L9_2, L10_2, L11_2)
        end
      end
    end
  end
end
function L66_1(A0_2, A1_2, A2_2, A3_2, A4_2, A5_2)
  local L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2
  L6_2 = type
  L7_2 = A0_2.notify
  L6_2 = L6_2(L7_2)
  if "table" == L6_2 then
    L6_2 = A0_2.notify
    L6_2 = L6_2.staff
    if false == L6_2 then
      L6_2 = 0
      return L6_2
    end
  end
  L6_2 = 0
  L7_2 = ipairs
  L8_2 = L63_1
  L9_2 = A0_2
  L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2 = L8_2(L9_2)
  L7_2, L8_2, L9_2, L10_2 = L7_2(L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2)
  for L11_2, L12_2 in L7_2, L8_2, L9_2, L10_2 do
    L13_2 = L37_1
    L14_2 = L12_2.acc
    L15_2 = A1_2
    L13_2 = L13_2(L14_2, L15_2)
    if L13_2 then
      if A5_2 then
        L13_2 = L12_2.acc
        L13_2 = L13_2.onduty
        if not L13_2 then
          goto lbl_42
        end
      end
      L13_2 = NotifyPlayer
      L14_2 = L12_2.src
      L15_2 = "capp_"
      L16_2 = A0_2.id
      L15_2 = L15_2 .. L16_2
      L16_2 = A2_2
      L17_2 = A3_2
      L18_2 = A4_2
      L13_2(L14_2, L15_2, L16_2, L17_2, L18_2)
      L6_2 = L6_2 + 1
    end
    ::lbl_42::
  end
  return L6_2
end
function L67_1(A0_2, A1_2, A2_2)
  local L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2
  L3_2 = 0
  L4_2 = ipairs
  L5_2 = L63_1
  L6_2 = A0_2
  L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2 = L5_2(L6_2)
  L4_2, L5_2, L6_2, L7_2 = L4_2(L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2)
  for L8_2, L9_2 in L4_2, L5_2, L6_2, L7_2 do
    L10_2 = L37_1
    L11_2 = L9_2.acc
    L12_2 = A1_2
    L10_2 = L10_2(L11_2, L12_2)
    if L10_2 then
      if A2_2 then
        L10_2 = L9_2.acc
        L10_2 = L10_2.onduty
        if not L10_2 then
          goto lbl_22
        end
      end
      L3_2 = L3_2 + 1
    end
    ::lbl_22::
  end
  return L3_2
end
function L68_1(A0_2, A1_2, A2_2, A3_2)
  local L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2
  L4_2 = A1_2.owner
  if not L4_2 then
    return
  end
  L4_2 = NotifyCitizen
  L5_2 = A1_2.owner
  L6_2 = "capp_"
  L7_2 = A0_2.id
  L6_2 = L6_2 .. L7_2
  L7_2 = A2_2
  L8_2 = A3_2
  L9_2 = {}
  L10_2 = A0_2.id
  L9_2.capp = L10_2
  L10_2 = A1_2.module
  L9_2.module = L10_2
  L10_2 = tonumber
  L11_2 = A1_2.id
  L10_2 = L10_2(L11_2)
  L9_2.id = L10_2
  L10_2 = {}
  L11_2 = "capp"
  L12_2 = tostring
  L13_2 = A1_2.id
  L12_2 = L12_2(L13_2)
  L11_2 = L11_2 .. L12_2
  L10_2.throttleKey = L11_2
  L4_2(L5_2, L6_2, L7_2, L8_2, L9_2, L10_2)
end
L69_1 = {}
L69_1["item.created"] = "Novo registo"
L69_1["item.status"] = "Estado alterado"
L69_1["item.reply"] = "Nova resposta"
L69_1["post.created"] = "Novo comunicado"
L69_1["record.created"] = "Nova ficha"
L69_1["record.updated"] = "Ficha atualizada"
L69_1["dispatch.accepted"] = "Pedido aceite"
L69_1["bill.created"] = "Nova fatura"
L69_1["duty.changed"] = "Servi\195\167o"
L69_1.test = "Teste do webhook"
function L70_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2
  L2_2 = A0_2.webhooks
  L3_2 = type
  L4_2 = L2_2
  L3_2 = L3_2(L4_2)
  if "table" ~= L3_2 then
    L3_2 = nil
    return L3_2
  end
  if "test" ~= A1_2 then
    L3_2 = type
    L4_2 = L2_2.events
    L3_2 = L3_2(L4_2)
    if "table" == L3_2 then
      L3_2 = L2_2.events
      L3_2 = L3_2[A1_2]
      if true == L3_2 then
        goto lbl_22
      end
    end
    L3_2 = nil
    return L3_2
  end
  ::lbl_22::
  L3_2 = type
  L4_2 = L2_2.urls
  L3_2 = L3_2(L4_2)
  if "table" == L3_2 then
    L3_2 = L2_2.urls
    L3_2 = L3_2[A1_2]
    if L3_2 then
      goto lbl_32
    end
  end
  L3_2 = nil
  ::lbl_32::
  L4_2 = ValidWebhookUrl
  L5_2 = L3_2
  L4_2 = L4_2(L5_2)
  if L4_2 then
    return L3_2
  end
  L4_2 = ValidWebhookUrl
  L5_2 = L2_2.url
  L4_2 = L4_2(L5_2)
  if L4_2 then
    L4_2 = L2_2.url
    return L4_2
  end
  L4_2 = nil
  return L4_2
end
function L71_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2
  if true == A1_2 then
    L2_2 = "Sim"
    return L2_2
  end
  if false == A1_2 then
    L2_2 = "N\195\163o"
    return L2_2
  end
  L2_2 = type
  L3_2 = A1_2
  L2_2 = L2_2(L3_2)
  if "table" == L2_2 then
    L2_2 = table
    L2_2 = L2_2.concat
    L3_2 = L17_1
    L4_2 = A1_2
    L3_2 = L3_2(L4_2)
    L4_2 = ", "
    return L2_2(L3_2, L4_2)
  end
  if A0_2 then
    L2_2 = A0_2.type
    if "rating" == L2_2 then
      L2_2 = "%s/5"
      L3_2 = L2_2
      L2_2 = L2_2.format
      L4_2 = tostring
      L5_2 = A1_2
      L4_2, L5_2 = L4_2(L5_2)
      return L2_2(L3_2, L4_2, L5_2)
    end
  end
  L2_2 = tostring
  L3_2 = A1_2
  return L2_2(L3_2)
end
function L72_1(A0_2, A1_2, A2_2, A3_2, A4_2)
  local L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2, L19_2, L20_2, L21_2, L22_2, L23_2, L24_2
  L5_2 = L70_1
  L6_2 = A0_2
  L7_2 = A1_2
  L5_2 = L5_2(L6_2, L7_2)
  if not L5_2 then
    return
  end
  L6_2 = L22_1
  L7_2 = A3_2 or L7_2
  if A3_2 then
    L7_2 = A3_2.data
  end
  L6_2 = L6_2(L7_2)
  if not L6_2 then
    L6_2 = {}
  end
  L7_2 = {}
  function L8_2(A0_3, A1_3, A2_3)
    local L3_3, L4_3, L5_3, L6_3, L7_3, L8_3, L9_3
    if nil ~= A1_3 then
      L3_3 = tostring
      L4_3 = A1_3
      L3_3 = L3_3(L4_3)
      if L3_3 then
        goto lbl_9
        A1_3 = L3_3 or A1_3
      end
    end
    A1_3 = ""
    ::lbl_9::
    if "" ~= A1_3 then
      L3_3 = L7_2
      L3_3 = #L3_3
      if L3_3 < 18 then
        L3_3 = L7_2
        L3_3 = #L3_3
        L4_3 = L3_3 + 1
        L3_3 = L7_2
        L5_3 = {}
        L5_3.name = A0_3
        L7_3 = A1_3
        L6_3 = A1_3.sub
        L8_3 = 1
        L9_3 = 900
        L6_3 = L6_3(L7_3, L8_3, L9_3)
        L5_3.value = L6_3
        L6_3 = false ~= A2_3
        L5_3.inline = L6_3
        L3_3[L4_3] = L5_3
      end
    end
  end
  if A3_2 then
    L9_2 = L8_2
    L10_2 = "Registo"
    L11_2 = "#"
    L12_2 = tostring
    L13_2 = A3_2.id
    L12_2 = L12_2(L13_2)
    L11_2 = L11_2 .. L12_2
    L9_2(L10_2, L11_2)
    L9_2 = L8_2
    L10_2 = "Estado"
    L11_2 = L51_1
    L12_2 = A2_2
    L13_2 = A3_2.kind
    L14_2 = A3_2.status
    L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2, L19_2, L20_2, L21_2, L22_2, L23_2, L24_2 = L11_2(L12_2, L13_2, L14_2)
    L9_2(L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2, L19_2, L20_2, L21_2, L22_2, L23_2, L24_2)
    L9_2 = A3_2.kind
    if "post" ~= L9_2 then
      L9_2 = A3_2.kind
      if "shift" ~= L9_2 then
        L9_2 = L8_2
        L10_2 = A3_2.kind
        if "bill" == L10_2 then
          L10_2 = "Cliente"
          if L10_2 then
            goto lbl_52
          end
        end
        L10_2 = "Autor"
        ::lbl_52::
        L11_2 = tonumber
        L12_2 = A3_2.anonymous
        L11_2 = L11_2(L12_2)
        if 1 == L11_2 then
          L11_2 = "An\195\179nimo"
          if L11_2 then
            goto lbl_64
          end
        end
        L11_2 = A3_2.owner_name
        if not L11_2 then
          L11_2 = "--"
        end
        ::lbl_64::
        L9_2(L10_2, L11_2)
      end
    end
    L9_2 = A3_2.subject
    if L9_2 then
      L9_2 = L8_2
      L10_2 = "Assunto"
      L11_2 = A3_2.subject
      L9_2(L10_2, L11_2)
    end
    L9_2 = A3_2.assignee_name
    if L9_2 then
      L9_2 = L8_2
      L10_2 = A3_2.kind
      if "shift" == L10_2 then
        L10_2 = "Membro"
        if L10_2 then
          goto lbl_83
        end
      end
      L10_2 = "Respons\195\161vel"
      ::lbl_83::
      L11_2 = A3_2.assignee_name
      L9_2(L10_2, L11_2)
    end
    L9_2 = A3_2.kind
    if "appt" == L9_2 then
      L9_2 = L8_2
      L10_2 = "Marca\195\167\195\163o"
      L11_2 = tostring
      L12_2 = L6_2.day
      if not L12_2 then
        L12_2 = ""
      end
      L11_2 = L11_2(L12_2)
      L12_2 = " "
      L13_2 = tostring
      L14_2 = L6_2.time
      if not L14_2 then
        L14_2 = ""
      end
      L13_2 = L13_2(L14_2)
      L11_2 = L11_2 .. L12_2 .. L13_2
      L9_2(L10_2, L11_2)
      L9_2 = L8_2
      L10_2 = "Servi\195\167o"
      L11_2 = L6_2.service_label
      L9_2(L10_2, L11_2)
    end
    L9_2 = A3_2.kind
    if "call" == L9_2 then
      L9_2 = L8_2
      L10_2 = "Tipo"
      L11_2 = L6_2.type_label
      if not L11_2 then
        L11_2 = L6_2.type
      end
      L9_2(L10_2, L11_2)
      L9_2 = L8_2
      L10_2 = "Mensagem"
      L11_2 = L6_2.message
      L12_2 = false
      L9_2(L10_2, L11_2, L12_2)
    end
    L9_2 = A3_2.kind
    if "post" == L9_2 then
      L9_2 = L8_2
      L10_2 = "Texto"
      L11_2 = L6_2.body
      L12_2 = false
      L9_2(L10_2, L11_2, L12_2)
    end
    L9_2 = A3_2.kind
    if "order" == L9_2 then
      L9_2 = {}
      L10_2 = ipairs
      L11_2 = L17_1
      L12_2 = L6_2.lines
      L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2, L19_2, L20_2, L21_2, L22_2, L23_2, L24_2 = L11_2(L12_2)
      L10_2, L11_2, L12_2, L13_2 = L10_2(L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2, L19_2, L20_2, L21_2, L22_2, L23_2, L24_2)
      for L14_2, L15_2 in L10_2, L11_2, L12_2, L13_2 do
        L16_2 = type
        L17_2 = L15_2
        L16_2 = L16_2(L17_2)
        if "table" == L16_2 then
          L16_2 = #L9_2
          L16_2 = L16_2 + 1
          L17_2 = "%dx %s \194\183 %s"
          L18_2 = L17_2
          L17_2 = L17_2.format
          L19_2 = L12_1
          L20_2 = L15_2.qty
          L21_2 = 1
          L22_2 = 999
          L23_2 = 1
          L19_2 = L19_2(L20_2, L21_2, L22_2, L23_2)
          L20_2 = tostring
          L21_2 = L15_2.label
          if not L21_2 then
            L21_2 = L15_2.id
          end
          L20_2 = L20_2(L21_2)
          L21_2 = L15_1
          L22_2 = tonumber
          L23_2 = L15_2.price
          L22_2 = L22_2(L23_2)
          if not L22_2 then
            L22_2 = 0
          end
          L23_2 = tonumber
          L24_2 = L15_2.qty
          L23_2 = L23_2(L24_2)
          if not L23_2 then
            L23_2 = 1
          end
          L22_2 = L22_2 * L23_2
          L23_2 = L6_2.currency
          L21_2, L22_2, L23_2, L24_2 = L21_2(L22_2, L23_2)
          L17_2 = L17_2(L18_2, L19_2, L20_2, L21_2, L22_2, L23_2, L24_2)
          L9_2[L16_2] = L17_2
        end
      end
      L10_2 = L8_2
      L11_2 = "Linhas"
      L12_2 = table
      L12_2 = L12_2.concat
      L13_2 = L9_2
      L14_2 = "\n"
      L12_2 = L12_2(L13_2, L14_2)
      L13_2 = false
      L10_2(L11_2, L12_2, L13_2)
      L10_2 = L8_2
      L11_2 = "Total"
      L12_2 = L15_1
      L13_2 = L6_2.total
      L14_2 = L6_2.currency
      L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2, L19_2, L20_2, L21_2, L22_2, L23_2, L24_2 = L12_2(L13_2, L14_2)
      L10_2(L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2, L19_2, L20_2, L21_2, L22_2, L23_2, L24_2)
    end
    L9_2 = A3_2.kind
    if "bill" == L9_2 then
      L9_2 = L8_2
      L10_2 = "Valor"
      L11_2 = L15_1
      L12_2 = L6_2.amount
      L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2, L19_2, L20_2, L21_2, L22_2, L23_2, L24_2 = L11_2(L12_2)
      L9_2(L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2, L19_2, L20_2, L21_2, L22_2, L23_2, L24_2)
      L9_2 = L8_2
      L10_2 = "Motivo"
      L11_2 = L6_2.reason
      L12_2 = false
      L9_2(L10_2, L11_2, L12_2)
    end
    L9_2 = A3_2.kind
    if "shift" == L9_2 then
      L9_2 = L8_2
      L10_2 = "Minutos"
      L11_2 = L6_2.minutes
      L9_2(L10_2, L11_2)
    end
    L9_2 = type
    L10_2 = L6_2.fields
    L9_2 = L9_2(L10_2)
    if "table" == L9_2 then
      L9_2 = {}
      L10_2 = ipairs
      L11_2 = L17_1
      L12_2 = A2_2.options
      L12_2 = L12_2.fields
      L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2, L19_2, L20_2, L21_2, L22_2, L23_2, L24_2 = L11_2(L12_2)
      L10_2, L11_2, L12_2, L13_2 = L10_2(L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2, L19_2, L20_2, L21_2, L22_2, L23_2, L24_2)
      for L14_2, L15_2 in L10_2, L11_2, L12_2, L13_2 do
        L16_2 = type
        L17_2 = L15_2
        L16_2 = L16_2(L17_2)
        if "table" == L16_2 then
          L16_2 = L15_2.key
          if L16_2 then
            L16_2 = L15_2.key
            L9_2[L16_2] = L15_2
          end
        end
      end
      L10_2 = ipairs
      L11_2 = L17_1
      L12_2 = L6_2.order
      L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2, L19_2, L20_2, L21_2, L22_2, L23_2, L24_2 = L11_2(L12_2)
      L10_2, L11_2, L12_2, L13_2 = L10_2(L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2, L19_2, L20_2, L21_2, L22_2, L23_2, L24_2)
      for L14_2, L15_2 in L10_2, L11_2, L12_2, L13_2 do
        L16_2 = L6_2.fields
        L16_2 = L16_2[L15_2]
        L17_2 = L9_2[L15_2]
        if nil ~= L16_2 and "" ~= L16_2 then
          L18_2 = L71_1
          L19_2 = L17_2
          L20_2 = L16_2
          L18_2 = L18_2(L19_2, L20_2)
          L19_2 = L8_2
          L20_2 = tostring
          if L17_2 then
            L21_2 = L17_2.label
            if L21_2 then
              goto lbl_276
            end
          end
          L21_2 = L15_2
          ::lbl_276::
          L20_2 = L20_2(L21_2)
          L21_2 = L18_2
          L22_2 = #L18_2
          L22_2 = L22_2 <= 40
          L19_2(L20_2, L21_2, L22_2)
        end
      end
    end
    L9_2 = A3_2.x
    if L9_2 then
      L9_2 = tonumber
      L10_2 = A3_2.anonymous
      L9_2 = L9_2(L10_2)
      if 1 ~= L9_2 then
        L9_2 = L8_2
        L10_2 = "Localiza\195\167\195\163o"
        L11_2 = "%.0f, %.0f"
        L12_2 = L11_2
        L11_2 = L11_2.format
        L13_2 = tonumber
        L14_2 = A3_2.x
        L13_2 = L13_2(L14_2)
        if not L13_2 then
          L13_2 = 0
        end
        L14_2 = tonumber
        L15_2 = A3_2.y
        L14_2 = L14_2(L15_2)
        if not L14_2 then
          L14_2 = 0
        end
        L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2, L19_2, L20_2, L21_2, L22_2, L23_2, L24_2 = L11_2(L12_2, L13_2, L14_2)
        L9_2(L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2, L19_2, L20_2, L21_2, L22_2, L23_2, L24_2)
      end
    end
  end
  if A4_2 then
    L9_2 = A4_2.note
    if L9_2 then
      L9_2 = L8_2
      L10_2 = "Texto"
      L11_2 = A4_2.note
      L12_2 = false
      L9_2(L10_2, L11_2, L12_2)
    end
  end
  if A4_2 then
    L9_2 = A4_2.by
    if L9_2 then
      L9_2 = L8_2
      L10_2 = "Por"
      L11_2 = A4_2.by
      L9_2(L10_2, L11_2)
    end
  end
  L9_2 = PostWebhook
  L10_2 = L5_2
  L11_2 = {}
  L12_2 = {}
  L13_2 = WebhookEmbed
  L14_2 = {}
  L15_2 = tostring
  L16_2 = A0_2.name
  if not L16_2 then
    L16_2 = A0_2.id
  end
  L15_2 = L15_2(L16_2)
  if A2_2 then
    L16_2 = " \194\183 "
    L17_2 = tostring
    L18_2 = A2_2.title
    if not L18_2 then
      L18_2 = A2_2.id
    end
    L17_2 = L17_2(L18_2)
    L16_2 = L16_2 .. L17_2
    if L16_2 then
      goto lbl_360
    end
  end
  L16_2 = ""
  ::lbl_360::
  L17_2 = " \194\183 "
  L18_2 = L69_1
  L18_2 = L18_2[A1_2]
  if not L18_2 then
    L18_2 = A1_2
  end
  L15_2 = L15_2 .. L16_2 .. L17_2 .. L18_2
  L14_2.title = L15_2
  if A3_2 then
    L15_2 = A3_2.title
    if L15_2 then
      goto lbl_379
    end
  end
  if A4_2 then
    L15_2 = A4_2.description
    if L15_2 then
      goto lbl_379
    end
  end
  L15_2 = nil
  ::lbl_379::
  L14_2.description = L15_2
  L15_2 = A0_2.accent
  L14_2.color = L15_2
  L14_2.fields = L7_2
  L15_2 = "Apex Phone \194\183 "
  L16_2 = A0_2.id
  L15_2 = L15_2 .. L16_2
  L14_2.footer = L15_2
  L13_2, L14_2, L15_2, L16_2, L17_2, L18_2, L19_2, L20_2, L21_2, L22_2, L23_2, L24_2 = L13_2(L14_2)
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
  L11_2.embeds = L12_2
  L9_2(L10_2, L11_2)
end
L73_1 = {}
L73_1.text = 200
L73_1.textarea = 1500
L73_1.number = 0
L73_1.select = 100
L73_1.multiselect = 0
L73_1.checkbox = 0
L73_1.date = 10
L73_1.time = 5
L73_1.phone = 20
L73_1.plate = 8
L73_1.email = 120
L73_1.url = 400
L73_1.rating = 0
L73_1.photo = 400
L73_1.section = 0
L73_1.info = 0
L74_1 = {}
L74_1.section = true
L74_1.info = true
L75_1 = {}
L75_1.text = true
L75_1.textarea = true
L75_1.email = true
L75_1.url = true
L75_1.phone = true
L75_1.plate = true
function L76_1(A0_2)
  local L1_2, L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2
  L1_2 = {}
  L2_2 = ipairs
  L3_2 = L17_1
  L4_2 = A0_2.options
  L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2 = L3_2(L4_2)
  L2_2, L3_2, L4_2, L5_2 = L2_2(L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2)
  for L6_2, L7_2 in L2_2, L3_2, L4_2, L5_2 do
    L8_2 = type
    L9_2 = L7_2
    L8_2 = L8_2(L9_2)
    if "string" == L8_2 then
      L1_2[L7_2] = true
    else
      L8_2 = type
      L9_2 = L7_2
      L8_2 = L8_2(L9_2)
      if "table" == L8_2 then
        L8_2 = L7_2.value
        if not L8_2 then
          L8_2 = L7_2.id
          if not L8_2 then
            L8_2 = L7_2.label
          end
        end
        if nil ~= L8_2 then
          L9_2 = tostring
          L10_2 = L8_2
          L9_2 = L9_2(L10_2)
          L1_2[L9_2] = true
        end
      end
    end
  end
  return L1_2
end
function L77_1(A0_2, A1_2, A2_2)
  local L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2
  if nil == A2_2 or "" == A2_2 then
    L3_2 = nil
    return L3_2
  end
  if "checkbox" == A1_2 then
    L3_2 = true == A2_2
    return L3_2
  end
  if "number" == A1_2 then
    L3_2 = tonumber
    L4_2 = A2_2
    L3_2 = L3_2(L4_2)
    if L3_2 and L3_2 == L3_2 then
      L4_2 = math
      L4_2 = L4_2.abs
      L5_2 = L3_2
      L4_2 = L4_2(L5_2)
      L5_2 = 1.0E9
      if not (L4_2 > L5_2) then
        goto lbl_33
      end
    end
    L4_2 = nil
    L5_2 = true
    do return L4_2, L5_2 end
    ::lbl_33::
    L4_2 = math
    L4_2 = L4_2.tointeger
    L5_2 = L3_2
    L4_2 = L4_2(L5_2)
    if not L4_2 then
      L4_2 = L3_2
    end
    return L4_2
  end
  if "rating" == A1_2 then
    L3_2 = math
    L3_2 = L3_2.tointeger
    L4_2 = tonumber
    L5_2 = A2_2
    L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2 = L4_2(L5_2)
    L3_2 = L3_2(L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2)
    if 0 == L3_2 then
      L4_2 = nil
      return L4_2
    end
    if not L3_2 or L3_2 < 1 or L3_2 > 5 then
      L4_2 = nil
      L5_2 = true
      return L4_2, L5_2
    end
    return L3_2
  end
  if "multiselect" == A1_2 then
    L3_2 = type
    L4_2 = A2_2
    L3_2 = L3_2(L4_2)
    if "table" ~= L3_2 then
      L3_2 = nil
      L4_2 = true
      return L3_2, L4_2
    end
    L3_2 = L76_1
    L4_2 = A0_2
    L3_2 = L3_2(L4_2)
    L4_2 = {}
    L5_2 = {}
    L6_2 = ipairs
    L7_2 = A2_2
    L6_2, L7_2, L8_2, L9_2 = L6_2(L7_2)
    for L10_2, L11_2 in L6_2, L7_2, L8_2, L9_2 do
      L12_2 = L11_1
      L13_2 = L11_2
      L14_2 = 100
      L12_2 = L12_2(L13_2, L14_2)
      if L12_2 then
        L13_2 = L3_2[L12_2]
        if not L13_2 then
          L13_2 = nil
          L14_2 = true
          return L13_2, L14_2
        end
        L13_2 = L5_2[L12_2]
        if not L13_2 then
          L5_2[L12_2] = true
          L13_2 = #L4_2
          L13_2 = L13_2 + 1
          L4_2[L13_2] = L12_2
        end
      end
      L13_2 = #L4_2
      if L13_2 >= 30 then
        break
      end
    end
    L6_2 = #L4_2
    if 0 == L6_2 then
      L6_2 = nil
      return L6_2
    end
    return L4_2
  end
  L3_2 = type
  L4_2 = A2_2
  L3_2 = L3_2(L4_2)
  if "string" ~= L3_2 then
    L3_2 = type
    L4_2 = A2_2
    L3_2 = L3_2(L4_2)
    if "number" ~= L3_2 then
      L3_2 = nil
      L4_2 = true
      return L3_2, L4_2
    end
  end
  L3_2 = L11_1
  L4_2 = A2_2
  L5_2 = L73_1
  L5_2 = L5_2[A1_2]
  if not L5_2 then
    L5_2 = 200
  end
  L6_2 = "textarea" == A1_2
  L3_2 = L3_2(L4_2, L5_2, L6_2)
  if not L3_2 then
    L4_2 = nil
    return L4_2
  end
  if "select" == A1_2 then
    L4_2 = L76_1
    L5_2 = A0_2
    L4_2 = L4_2(L5_2)
    L4_2 = L4_2[L3_2]
    if not L4_2 then
      L4_2 = nil
      L5_2 = true
      return L4_2, L5_2
    end
  elseif "date" == A1_2 then
    L5_2 = L3_2
    L4_2 = L3_2.match
    L6_2 = "^(%d%d%d%d)%-(%d%d)%-(%d%d)$"
    L4_2, L5_2, L6_2 = L4_2(L5_2, L6_2)
    if L4_2 then
      L7_2 = tonumber
      L8_2 = L5_2
      L7_2 = L7_2(L8_2)
      if not (L7_2 < 1) then
        L7_2 = tonumber
        L8_2 = L5_2
        L7_2 = L7_2(L8_2)
        if not (L7_2 > 12) then
          L7_2 = tonumber
          L8_2 = L6_2
          L7_2 = L7_2(L8_2)
          if not (L7_2 < 1) then
            L7_2 = tonumber
            L8_2 = L6_2
            L7_2 = L7_2(L8_2)
          end
        end
      end
    end
    if L7_2 > 31 then
      L7_2 = nil
      L8_2 = true
      return L7_2, L8_2
    end
  elseif "time" == A1_2 then
    L5_2 = L3_2
    L4_2 = L3_2.match
    L6_2 = "^(%d%d):(%d%d)$"
    L4_2, L5_2 = L4_2(L5_2, L6_2)
    if L4_2 then
      L6_2 = tonumber
      L7_2 = L4_2
      L6_2 = L6_2(L7_2)
      if not (L6_2 > 23) then
        L6_2 = tonumber
        L7_2 = L5_2
        L6_2 = L6_2(L7_2)
      end
    end
    if L6_2 > 59 then
      L6_2 = nil
      L7_2 = true
      return L6_2, L7_2
    end
  elseif "phone" == A1_2 then
    L5_2 = L3_2
    L4_2 = L3_2.match
    L6_2 = "^[%d%s%+%-%(%)%.]+$"
    L4_2 = L4_2(L5_2, L6_2)
    if not L4_2 then
      L4_2 = nil
      L5_2 = true
      return L4_2, L5_2
    end
  elseif "plate" == A1_2 then
    L5_2 = L3_2
    L4_2 = L3_2.upper
    L4_2 = L4_2(L5_2)
    L3_2 = L4_2
    L5_2 = L3_2
    L4_2 = L3_2.match
    L6_2 = "^[%w%s%-]+$"
    L4_2 = L4_2(L5_2, L6_2)
    if not L4_2 then
      L4_2 = nil
      L5_2 = true
      return L4_2, L5_2
    end
  elseif "email" == A1_2 then
    L5_2 = L3_2
    L4_2 = L3_2.match
    L6_2 = "^[%w%._%%%+%-]+@[%w%-]+[%w%.%-]*%.%a%a+$"
    L4_2 = L4_2(L5_2, L6_2)
    if not L4_2 then
      L4_2 = nil
      L5_2 = true
      return L4_2, L5_2
    end
  elseif "url" == A1_2 or "photo" == A1_2 then
    L4_2 = L19_1
    L5_2 = L3_2
    L4_2 = L4_2(L5_2)
    L3_2 = L4_2
    if not L3_2 then
      L4_2 = nil
      L5_2 = true
      return L4_2, L5_2
    end
  end
  return L3_2
end
function L78_1(A0_2)
  local L1_2, L2_2, L3_2, L4_2
  if nil == A0_2 then
    L1_2 = nil
    return L1_2
  end
  L1_2 = type
  L2_2 = A0_2
  L1_2 = L1_2(L2_2)
  if "boolean" == L1_2 then
    if A0_2 then
      L1_2 = "true"
      if L1_2 then
        goto lbl_16
      end
    end
    L1_2 = "false"
    ::lbl_16::
    return L1_2
  end
  L1_2 = type
  L2_2 = A0_2
  L1_2 = L1_2(L2_2)
  if "number" == L1_2 then
    L1_2 = math
    L1_2 = L1_2.floor
    L2_2 = A0_2
    L1_2 = L1_2(L2_2)
    if A0_2 == L1_2 then
      L1_2 = "%d"
      L2_2 = L1_2
      L1_2 = L1_2.format
      L3_2 = math
      L3_2 = L3_2.floor
      L4_2 = A0_2
      L3_2, L4_2 = L3_2(L4_2)
      return L1_2(L2_2, L3_2, L4_2)
    end
    L1_2 = tostring
    L2_2 = A0_2
    return L1_2(L2_2)
  end
  L1_2 = tostring
  L2_2 = A0_2
  return L1_2(L2_2)
end
function L79_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2
  L2_2 = {}
  L3_2 = ipairs
  L4_2 = A0_2
  L3_2, L4_2, L5_2, L6_2 = L3_2(L4_2)
  for L7_2, L8_2 in L3_2, L4_2, L5_2, L6_2 do
    L9_2 = type
    L10_2 = L8_2
    L9_2 = L9_2(L10_2)
    if "table" == L9_2 then
      L9_2 = type
      L10_2 = L8_2.key
      L9_2 = L9_2(L10_2)
      if "string" == L9_2 then
        L9_2 = L8_2.key
        L2_2[L9_2] = L8_2
      end
    end
  end
  L3_2 = {}
  function L4_2(A0_3, A1_3)
    local L2_3, L3_3, L4_3, L5_3, L6_3, L7_3, L8_3, L9_3, L10_3, L11_3, L12_3, L13_3, L14_3
    L3_3 = A0_3.key
    L2_3 = L3_2
    L2_3 = L2_3[L3_3]
    if nil ~= L2_3 then
      L3_3 = A0_3.key
      L2_3 = L3_2
      L2_3 = L2_3[L3_3]
      return L2_3
    end
    L2_3 = A0_3.showIf
    L3_3 = true
    L4_3 = type
    L5_3 = L2_3
    L4_3 = L4_3(L5_3)
    if "table" == L4_3 then
      L4_3 = type
      L5_3 = L2_3.key
      L4_3 = L4_3(L5_3)
      if "string" == L4_3 then
        L4_3 = L2_3.key
        L5_3 = A0_3.key
        if L4_3 ~= L5_3 then
          L5_3 = L2_3.key
          L4_3 = L2_2
          L4_3 = L4_3[L5_3]
          if L4_3 and A1_3 < 8 then
            L5_3 = L2_3.key
            L4_3 = L2_2
            L4_3 = L4_3[L5_3]
            L5_3 = L4_2
            L6_3 = L4_3
            L7_3 = A1_3 + 1
            L5_3 = L5_3(L6_3, L7_3)
            if not L5_3 then
              L3_3 = false
            else
              L5_3 = L2_3.equals
              if nil == L5_3 then
                L5_3 = ""
                if L5_3 then
                  goto lbl_54
                end
              end
              L5_3 = tostring
              L6_3 = L2_3.equals
              L5_3 = L5_3(L6_3)
              ::lbl_54::
              L7_3 = L2_3.key
              L6_3 = A1_2
              L6_3 = L6_3[L7_3]
              L7_3 = type
              L8_3 = L6_3
              L7_3 = L7_3(L8_3)
              if "table" == L7_3 then
                L3_3 = false
                L7_3 = ipairs
                L8_3 = L6_3
                L7_3, L8_3, L9_3, L10_3 = L7_3(L8_3)
                for L11_3, L12_3 in L7_3, L8_3, L9_3, L10_3 do
                  L13_3 = tostring
                  L14_3 = L12_3
                  L13_3 = L13_3(L14_3)
                  if L13_3 == L5_3 then
                    L3_3 = true
                    break
                  end
                end
              else
                L7_3 = L78_1
                L8_3 = L6_3
                L7_3 = L7_3(L8_3)
                if nil == L7_3 then
                  L8_3 = L4_3.type
                  if "checkbox" == L8_3 then
                    L7_3 = "false"
                  end
                end
                L8_3 = L7_3 or L8_3
                if not L7_3 then
                  L8_3 = ""
                end
                L3_3 = L8_3 == L5_3
              end
            end
          end
        end
      end
    end
    L5_3 = A0_3.key
    L4_3 = L3_2
    L4_3[L5_3] = L3_3
    return L3_3
  end
  L5_2 = {}
  L6_2 = pairs
  L7_2 = L2_2
  L6_2, L7_2, L8_2, L9_2 = L6_2(L7_2)
  for L10_2, L11_2 in L6_2, L7_2, L8_2, L9_2 do
    L12_2 = L4_2
    L13_2 = L11_2
    L14_2 = 0
    L12_2 = L12_2(L13_2, L14_2)
    L5_2[L10_2] = L12_2
  end
  return L5_2
end
function L80_1(A0_2, A1_2, A2_2)
  local L3_2, L4_2, L5_2, L6_2, L7_2
  L3_2 = tonumber
  L4_2 = A0_2.min
  L3_2 = L3_2(L4_2)
  L4_2 = tonumber
  L5_2 = A0_2.max
  L4_2 = L4_2(L5_2)
  if not L3_2 and not L4_2 then
    L5_2 = true
    return L5_2
  end
  L5_2 = nil
  if "number" == A1_2 then
    L5_2 = A2_2
  elseif "multiselect" == A1_2 then
    L5_2 = #A2_2
  else
    L6_2 = L75_1
    L6_2 = L6_2[A1_2]
    if L6_2 then
      L6_2 = utf8
      L6_2 = L6_2.len
      L7_2 = A2_2
      L6_2 = L6_2(L7_2)
      L5_2 = L6_2 or L5_2
      if not L6_2 then
        L5_2 = #A2_2
      end
    else
      L6_2 = true
      return L6_2
    end
  end
  if L3_2 and L3_2 > L5_2 then
    L6_2 = false
    return L6_2
  end
  if L4_2 and L4_2 < L5_2 then
    L6_2 = false
    return L6_2
  end
  L6_2 = true
  return L6_2
end
function L81_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2, L19_2, L20_2, L21_2
  L2_2 = L17_1
  L3_2 = A0_2
  L2_2 = L2_2(L3_2)
  A0_2 = L2_2
  L2_2 = type
  L3_2 = A1_2
  L2_2 = L2_2(L3_2)
  if "table" ~= L2_2 or not A1_2 then
    L2_2 = {}
    A1_2 = L2_2
  end
  L2_2 = {}
  L3_2 = {}
  L4_2 = {}
  L5_2 = ipairs
  L6_2 = A0_2
  L5_2, L6_2, L7_2, L8_2 = L5_2(L6_2)
  for L9_2, L10_2 in L5_2, L6_2, L7_2, L8_2 do
    L11_2 = type
    L12_2 = L10_2
    L11_2 = L11_2(L12_2)
    if "table" == L11_2 then
      L11_2 = type
      L12_2 = L10_2.key
      L11_2 = L11_2(L12_2)
      if "string" == L11_2 then
        L11_2 = L10_2.key
        L12_2 = L11_2
        L11_2 = L11_2.match
        L13_2 = "^[%w_]+$"
        L11_2 = L11_2(L12_2, L13_2)
        if L11_2 then
          L11_2 = L10_2.key
          L11_2 = #L11_2
          if L11_2 <= 32 then
            L12_2 = L10_2.type
            L11_2 = L73_1
            L11_2 = L11_2[L12_2]
            if L11_2 then
              L11_2 = L10_2.type
              if L11_2 then
                goto lbl_54
              end
            end
            L11_2 = "text"
            ::lbl_54::
            L12_2 = L74_1
            L12_2 = L12_2[L11_2]
            if not L12_2 then
              L12_2 = #L2_2
              L12_2 = L12_2 + 1
              L13_2 = {}
              L13_2.f = L10_2
              L13_2.t = L11_2
              L2_2[L12_2] = L13_2
              L12_2 = L77_1
              L13_2 = L10_2
              L14_2 = L11_2
              L15_2 = L10_2.key
              L15_2 = A1_2[L15_2]
              L12_2, L13_2 = L12_2(L13_2, L14_2, L15_2)
              L14_2 = L10_2.key
              L3_2[L14_2] = L12_2
              L14_2 = L10_2.key
              L4_2[L14_2] = L13_2
            end
          end
        end
      end
    end
  end
  L5_2 = L79_1
  L6_2 = A0_2
  L7_2 = L3_2
  L5_2 = L5_2(L6_2, L7_2)
  L6_2 = {}
  L7_2 = {}
  L8_2 = ipairs
  L9_2 = L2_2
  L8_2, L9_2, L10_2, L11_2 = L8_2(L9_2)
  for L12_2, L13_2 in L8_2, L9_2, L10_2, L11_2 do
    L14_2 = L13_2.f
    L15_2 = L13_2.t
    L16_2 = L14_2.key
    L16_2 = L5_2[L16_2]
    if false ~= L16_2 then
      L16_2 = L14_2.key
      L16_2 = L4_2[L16_2]
      if L16_2 then
        L16_2 = nil
        L17_2 = "field"
        L18_2 = L14_2.key
        return L16_2, L17_2, L18_2
      end
      L16_2 = L14_2.key
      L16_2 = L3_2[L16_2]
      L17_2 = nil == L16_2 or false == L16_2
      L18_2 = L14_2.required
      if L18_2 and L17_2 then
        L18_2 = nil
        L19_2 = "required"
        L20_2 = L14_2.key
        return L18_2, L19_2, L20_2
      end
      if not L17_2 then
        L18_2 = L80_1
        L19_2 = L14_2
        L20_2 = L15_2
        L21_2 = L16_2
        L18_2 = L18_2(L19_2, L20_2, L21_2)
        if not L18_2 then
          L18_2 = nil
          L19_2 = "range"
          L20_2 = L14_2.key
          return L18_2, L19_2, L20_2
        end
        L18_2 = L14_2.key
        L6_2[L18_2] = L16_2
        L18_2 = #L7_2
        L18_2 = L18_2 + 1
        L19_2 = L14_2.key
        L7_2[L18_2] = L19_2
      end
    end
  end
  L8_2 = {}
  L8_2.fields = L6_2
  L8_2.order = L7_2
  return L8_2
end
function L82_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2
  L2_2 = ipairs
  L3_2 = L17_1
  L4_2 = A0_2
  L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2 = L3_2(L4_2)
  L2_2, L3_2, L4_2, L5_2 = L2_2(L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2)
  for L6_2, L7_2 in L2_2, L3_2, L4_2, L5_2 do
    L8_2 = type
    L9_2 = L7_2
    L8_2 = L8_2(L9_2)
    if "table" == L8_2 then
      L8_2 = L7_2.type
      if "text" ~= L8_2 then
        L8_2 = L7_2.type
        if "select" ~= L8_2 then
          L8_2 = L7_2.type
          if "plate" ~= L8_2 then
            L8_2 = L7_2.type
            if nil ~= L8_2 then
              goto lbl_38
            end
          end
        end
      end
      L8_2 = L7_2.key
      L8_2 = A1_2[L8_2]
      L9_2 = type
      L10_2 = L8_2
      L9_2 = L9_2(L10_2)
      if "string" == L9_2 and "" ~= L8_2 then
        L9_2 = L11_1
        L10_2 = L8_2
        L11_2 = 120
        L9_2, L10_2, L11_2, L12_2, L13_2 = L9_2(L10_2, L11_2)
        return L9_2, L10_2, L11_2, L12_2, L13_2
      end
    end
    ::lbl_38::
  end
  L2_2 = ipairs
  L3_2 = L17_1
  L4_2 = A0_2
  L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2 = L3_2(L4_2)
  L2_2, L3_2, L4_2, L5_2 = L2_2(L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2)
  for L6_2, L7_2 in L2_2, L3_2, L4_2, L5_2 do
    L8_2 = type
    L9_2 = L7_2
    L8_2 = L8_2(L9_2)
    if "table" == L8_2 then
      L8_2 = L7_2.key
      L8_2 = A1_2[L8_2]
      if L8_2 then
        goto lbl_57
      end
    end
    L8_2 = nil
    ::lbl_57::
    L9_2 = type
    L10_2 = L8_2
    L9_2 = L9_2(L10_2)
    if "string" == L9_2 and "" ~= L8_2 then
      L9_2 = L7_2.type
      if "photo" ~= L9_2 then
        L9_2 = L7_2.type
        if "url" ~= L9_2 then
          L9_2 = L11_1
          L11_2 = L8_2
          L10_2 = L8_2.gsub
          L12_2 = "\n"
          L13_2 = " "
          L10_2 = L10_2(L11_2, L12_2, L13_2)
          L11_2 = 120
          L9_2, L10_2, L11_2, L12_2, L13_2 = L9_2(L10_2, L11_2)
          return L9_2, L10_2, L11_2, L12_2, L13_2
        end
      end
    end
  end
  L2_2 = nil
  return L2_2
end
L83_1 = {}
L84_1 = {}
L85_1 = {}
L86_1 = {}
L87_1 = {}
function L88_1(A0_2, A1_2, A2_2)
  local L3_2, L4_2, L5_2
  L3_2 = A0_2[A1_2]
  if not L3_2 then
    L4_2 = 0
    return L4_2
  end
  L4_2 = os
  L4_2 = L4_2.time
  L4_2 = L4_2()
  L4_2 = L4_2 - L3_2
  L4_2 = A2_2 - L4_2
  L5_2 = L4_2 or L5_2
  if not (L4_2 > 0) or not L4_2 then
    L5_2 = 0
  end
  return L5_2
end
function L89_1(A0_2)
  local L1_2, L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2, L19_2, L20_2, L21_2
  L1_2 = A0_2.options
  L2_2 = type
  L3_2 = L1_2.hours
  L2_2 = L2_2(L3_2)
  if "table" == L2_2 then
    L2_2 = L1_2.hours
    if L2_2 then
      goto lbl_12
    end
  end
  L2_2 = {}
  ::lbl_12::
  function L3_2(A0_3, A1_3)
    local L2_3, L3_3, L4_3, L5_3, L6_3, L7_3, L8_3
    L2_3 = type
    L3_3 = A0_3
    L2_3 = L2_3(L3_3)
    if "string" == L2_3 then
      L3_3 = A0_3
      L2_3 = A0_3.match
      L4_3 = "^(%d%d?):(%d%d)$"
      L2_3, L3_3 = L2_3(L3_3, L4_3)
      if L2_3 then
        L4_3 = L12_1
        L5_3 = L2_3
        L6_3 = 0
        L7_3 = 24
        L4_3 = L4_3(L5_3, L6_3, L7_3)
        L4_3 = L4_3 * 60
        L5_3 = L12_1
        L6_3 = L3_3
        L7_3 = 0
        L8_3 = 59
        L5_3 = L5_3(L6_3, L7_3, L8_3)
        L4_3 = L4_3 + L5_3
        return L4_3
      end
    end
    L2_3 = L12_1
    L3_3 = A0_3
    L4_3 = 0
    L5_3 = 24
    L6_3 = A1_3
    L2_3 = L2_3(L3_3, L4_3, L5_3, L6_3)
    L2_3 = L2_3 * 60
    return L2_3
  end
  L4_2 = L3_2
  L5_2 = L2_2.from
  L6_2 = 9
  L4_2 = L4_2(L5_2, L6_2)
  L5_2 = L3_2
  L6_2 = L2_2.to
  L7_2 = 21
  L5_2 = L5_2(L6_2, L7_2)
  if L4_2 >= L5_2 then
    L6_2 = math
    L6_2 = L6_2.min
    L7_2 = 1440
    L8_2 = L4_2 + 60
    L6_2 = L6_2(L7_2, L8_2)
    L5_2 = L6_2
  end
  L6_2 = {}
  L7_2 = L17_1
  L8_2 = L1_2.days
  L7_2 = L7_2(L8_2)
  L8_2 = #L7_2
  if 0 == L8_2 then
    L8_2 = {}
    L9_2 = 1
    L10_2 = 2
    L11_2 = 3
    L12_2 = 4
    L13_2 = 5
    L14_2 = 6
    L15_2 = 7
    L8_2[1] = L9_2
    L8_2[2] = L10_2
    L8_2[3] = L11_2
    L8_2[4] = L12_2
    L8_2[5] = L13_2
    L8_2[6] = L14_2
    L8_2[7] = L15_2
    L7_2 = L8_2
  end
  L8_2 = ipairs
  L9_2 = L7_2
  L8_2, L9_2, L10_2, L11_2 = L8_2(L9_2)
  for L12_2, L13_2 in L8_2, L9_2, L10_2, L11_2 do
    L14_2 = L12_1
    L15_2 = L13_2
    L16_2 = 1
    L17_2 = 7
    L14_2 = L14_2(L15_2, L16_2, L17_2)
    L6_2[L14_2] = true
  end
  L8_2 = {}
  L9_2 = ipairs
  L10_2 = L17_1
  L11_2 = L1_2.services
  L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2, L19_2, L20_2, L21_2 = L10_2(L11_2)
  L9_2, L10_2, L11_2, L12_2 = L9_2(L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2, L19_2, L20_2, L21_2)
  for L13_2, L14_2 in L9_2, L10_2, L11_2, L12_2 do
    L15_2 = type
    L16_2 = L14_2
    L15_2 = L15_2(L16_2)
    if "table" == L15_2 then
      L15_2 = type
      L16_2 = L14_2.id
      L15_2 = L15_2(L16_2)
      if "string" == L15_2 then
        L15_2 = L14_2.id
        if "" ~= L15_2 then
          L15_2 = #L8_2
          L15_2 = L15_2 + 1
          L16_2 = {}
          L17_2 = L14_2.id
          L16_2.id = L17_2
          L17_2 = L11_1
          L18_2 = L14_2.label
          L19_2 = 60
          L17_2 = L17_2(L18_2, L19_2)
          if not L17_2 then
            L17_2 = L14_2.id
          end
          L16_2.label = L17_2
          L17_2 = L12_1
          L18_2 = L14_2.minutes
          L19_2 = 5
          L20_2 = 480
          L21_2 = 30
          L17_2 = L17_2(L18_2, L19_2, L20_2, L21_2)
          L16_2.minutes = L17_2
          L8_2[L15_2] = L16_2
        end
      end
    end
  end
  L9_2 = {}
  L9_2.from = L4_2
  L9_2.to = L5_2
  L9_2.days = L6_2
  L10_2 = L12_1
  L11_2 = L1_2.slot
  L12_2 = 5
  L13_2 = 240
  L14_2 = 30
  L10_2 = L10_2(L11_2, L12_2, L13_2, L14_2)
  L9_2.slot = L10_2
  L10_2 = L12_1
  L11_2 = L1_2.maxPerSlot
  L12_2 = 1
  L13_2 = 50
  L14_2 = 1
  L10_2 = L10_2(L11_2, L12_2, L13_2, L14_2)
  L9_2.max = L10_2
  L9_2.services = L8_2
  L10_2 = L1_2.notes
  L10_2 = false ~= L10_2
  L9_2.notes = L10_2
  return L9_2
end
function L90_1(A0_2)
  local L1_2, L2_2, L3_2, L4_2
  L1_2 = tonumber
  L2_2 = os
  L2_2 = L2_2.date
  L3_2 = "%w"
  L4_2 = A0_2
  L2_2, L3_2, L4_2 = L2_2(L3_2, L4_2)
  L1_2 = L1_2(L2_2, L3_2, L4_2)
  if 0 == L1_2 then
    L2_2 = 7
    if L2_2 then
      goto lbl_14
    end
  end
  L2_2 = L1_2
  ::lbl_14::
  return L2_2
end
function L91_1(A0_2)
  local L1_2, L2_2, L3_2, L4_2, L5_2, L6_2, L7_2
  L1_2 = type
  L2_2 = A0_2
  L1_2 = L1_2(L2_2)
  if "string" ~= L1_2 then
    L1_2 = nil
    return L1_2
  end
  L2_2 = A0_2
  L1_2 = A0_2.match
  L3_2 = "^(%d%d%d%d)%-(%d%d)%-(%d%d)$"
  L1_2, L2_2, L3_2 = L1_2(L2_2, L3_2)
  if not L1_2 then
    L4_2 = nil
    return L4_2
  end
  L4_2 = tonumber
  L5_2 = L1_2
  L4_2 = L4_2(L5_2)
  L5_2 = tonumber
  L6_2 = L2_2
  L5_2 = L5_2(L6_2)
  L6_2 = tonumber
  L7_2 = L3_2
  L6_2, L7_2 = L6_2(L7_2)
  return L4_2, L5_2, L6_2, L7_2
end
function L92_1(A0_2)
  local L1_2, L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2
  L1_2 = os
  L1_2 = L1_2.date
  L2_2 = "*t"
  L1_2 = L1_2(L2_2)
  L2_2 = {}
  L3_2 = 0
  L4_2 = 13
  L5_2 = 1
  for L6_2 = L3_2, L4_2, L5_2 do
    L7_2 = os
    L7_2 = L7_2.time
    L8_2 = {}
    L9_2 = L1_2.year
    L8_2.year = L9_2
    L9_2 = L1_2.month
    L8_2.month = L9_2
    L9_2 = L1_2.day
    L9_2 = L9_2 + L6_2
    L8_2.day = L9_2
    L8_2.hour = 12
    L7_2 = L7_2(L8_2)
    L8_2 = #L2_2
    L8_2 = L8_2 + 1
    L9_2 = {}
    L10_2 = os
    L10_2 = L10_2.date
    L11_2 = "%Y-%m-%d"
    L12_2 = L7_2
    L10_2 = L10_2(L11_2, L12_2)
    L9_2.day = L10_2
    L10_2 = L90_1
    L11_2 = L7_2
    L10_2 = L10_2(L11_2)
    L9_2.wd = L10_2
    L10_2 = tonumber
    L11_2 = os
    L11_2 = L11_2.date
    L12_2 = "%d"
    L13_2 = L7_2
    L11_2, L12_2, L13_2 = L11_2(L12_2, L13_2)
    L10_2 = L10_2(L11_2, L12_2, L13_2)
    L9_2.d = L10_2
    L10_2 = tonumber
    L11_2 = os
    L11_2 = L11_2.date
    L12_2 = "%m"
    L13_2 = L7_2
    L11_2, L12_2, L13_2 = L11_2(L12_2, L13_2)
    L10_2 = L10_2(L11_2, L12_2, L13_2)
    L9_2.m = L10_2
    L10_2 = A0_2.days
    L11_2 = L90_1
    L12_2 = L7_2
    L11_2 = L11_2(L12_2)
    L10_2 = L10_2[L11_2]
    L10_2 = true == L10_2
    L9_2.open = L10_2
    L2_2[L8_2] = L9_2
  end
  return L2_2
end
function L93_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2
  L2_2 = L91_1
  L3_2 = A0_2
  L2_2, L3_2, L4_2 = L2_2(L3_2)
  if not L2_2 then
    L5_2 = nil
    return L5_2
  end
  L5_2 = os
  L5_2 = L5_2.time
  L6_2 = {}
  L6_2.year = L2_2
  L6_2.month = L3_2
  L6_2.day = L4_2
  L7_2 = math
  L7_2 = L7_2.floor
  L8_2 = A1_2 / 60
  L7_2 = L7_2(L8_2)
  L6_2.hour = L7_2
  L7_2 = A1_2 % 60
  L6_2.min = L7_2
  L6_2.sec = 0
  L5_2 = L5_2(L6_2)
  L5_2 = L5_2 * 1000
  return L5_2
end
function L94_1(A0_2, A1_2, A2_2, A3_2)
  local L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2, L19_2, L20_2, L21_2, L22_2, L23_2
  L4_2 = L91_1
  L5_2 = A3_2
  L4_2, L5_2, L6_2 = L4_2(L5_2)
  if not L4_2 then
    L7_2 = {}
    return L7_2
  end
  L7_2 = os
  L7_2 = L7_2.time
  L8_2 = {}
  L8_2.year = L4_2
  L8_2.month = L5_2
  L8_2.day = L6_2
  L8_2.hour = 12
  L7_2 = L7_2(L8_2)
  L8_2 = A2_2.days
  L9_2 = L90_1
  L10_2 = L7_2
  L9_2 = L9_2(L10_2)
  L8_2 = L8_2[L9_2]
  if not L8_2 then
    L8_2 = {}
    return L8_2
  end
  L8_2 = L93_1
  L9_2 = A3_2
  L10_2 = 0
  L8_2 = L8_2(L9_2, L10_2)
  L9_2 = L93_1
  L10_2 = A3_2
  L11_2 = 1439
  L9_2 = L9_2(L10_2, L11_2)
  L10_2 = {}
  L11_2 = ipairs
  L12_2 = MySQL
  L12_2 = L12_2.query
  L12_2 = L12_2.await
  L13_2 = "SELECT at, COUNT(*) AS n FROM apex_phone_capp_items WHERE app = ? AND module = ? AND kind = 'appt' AND at BETWEEN ? AND ? AND status IN ('pending', 'confirmed') GROUP BY at"
  L14_2 = {}
  L15_2 = A0_2.id
  L16_2 = A1_2.id
  L17_2 = L8_2
  L18_2 = L9_2
  L14_2[1] = L15_2
  L14_2[2] = L16_2
  L14_2[3] = L17_2
  L14_2[4] = L18_2
  L12_2 = L12_2(L13_2, L14_2)
  if not L12_2 then
    L12_2 = {}
  end
  L11_2, L12_2, L13_2, L14_2 = L11_2(L12_2)
  for L15_2, L16_2 in L11_2, L12_2, L13_2, L14_2 do
    L17_2 = tonumber
    L18_2 = L16_2.at
    L17_2 = L17_2(L18_2)
    L18_2 = tonumber
    L19_2 = L16_2.n
    L18_2 = L18_2(L19_2)
    if not L18_2 then
      L18_2 = 0
    end
    L10_2[L17_2] = L18_2
  end
  L11_2 = {}
  L12_2 = os
  L12_2 = L12_2.time
  L12_2 = L12_2()
  L12_2 = L12_2 * 1000
  L12_2 = L12_2 + 900000
  L13_2 = A2_2.from
  L14_2 = A2_2.to
  L15_2 = A2_2.slot
  L14_2 = L14_2 - L15_2
  L15_2 = A2_2.slot
  for L16_2 = L13_2, L14_2, L15_2 do
    L17_2 = L93_1
    L18_2 = A3_2
    L19_2 = L16_2
    L17_2 = L17_2(L18_2, L19_2)
    if L17_2 and L12_2 < L17_2 then
      L18_2 = #L11_2
      L18_2 = L18_2 + 1
      L19_2 = {}
      L20_2 = "%02d:%02d"
      L21_2 = L20_2
      L20_2 = L20_2.format
      L22_2 = math
      L22_2 = L22_2.floor
      L23_2 = L16_2 / 60
      L22_2 = L22_2(L23_2)
      L23_2 = L16_2 % 60
      L20_2 = L20_2(L21_2, L22_2, L23_2)
      L19_2.time = L20_2
      L20_2 = math
      L20_2 = L20_2.max
      L21_2 = 0
      L22_2 = A2_2.max
      L23_2 = L10_2[L17_2]
      if not L23_2 then
        L23_2 = 0
      end
      L22_2 = L22_2 - L23_2
      L20_2 = L20_2(L21_2, L22_2)
      L19_2.free = L20_2
      L11_2[L18_2] = L19_2
    end
    L18_2 = #L11_2
    if L18_2 >= 96 then
      break
    end
  end
  return L11_2
end
function L95_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2, L19_2, L20_2, L21_2, L22_2
  L2_2 = {}
  L3_2 = ipairs
  L4_2 = A1_2.modules
  L3_2, L4_2, L5_2, L6_2 = L3_2(L4_2)
  for L7_2, L8_2 in L3_2, L4_2, L5_2, L6_2 do
    L9_2 = L8_2.enabled
    if false ~= L9_2 then
      L9_2 = L37_1
      L10_2 = A0_2
      L11_2 = L8_2
      L9_2 = L9_2(L10_2, L11_2)
      L10_2 = L38_1
      L11_2 = A0_2
      L12_2 = L8_2
      L10_2 = L10_2(L11_2, L12_2)
      if L9_2 or L10_2 then
        L11_2 = {}
        L11_2.staff = L9_2
        L11_2.civil = L10_2
        if L9_2 then
          L12_2 = {}
          L11_2.can = L12_2
          L12_2 = ipairs
          L13_2 = L5_1
          L12_2, L13_2, L14_2, L15_2 = L12_2(L13_2)
          for L16_2, L17_2 in L12_2, L13_2, L14_2, L15_2 do
            L18_2 = L11_2.can
            L19_2 = A0_2.grade
            L20_2 = L35_1
            L21_2 = L8_2
            L22_2 = L17_2
            L20_2 = L20_2(L21_2, L22_2)
            L19_2 = L19_2 >= L20_2
            L18_2[L17_2] = L19_2
          end
        end
        L12_2 = L8_2.id
        L2_2[L12_2] = L11_2
      end
    end
  end
  return L2_2
end
L96_1 = RPC
function L97_1(A0_2)
  local L1_2, L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2
  L1_2 = FW
  L1_2 = L1_2.GetPlayer
  L2_2 = A0_2
  L1_2 = L1_2(L2_2)
  if not L1_2 then
    L2_2 = {}
    L2_2.error = "noplayer"
    return L2_2
  end
  L2_2 = {}
  L3_2 = ipairs
  L4_2 = L7_1
  L3_2, L4_2, L5_2, L6_2 = L3_2(L4_2)
  for L7_2, L8_2 in L3_2, L4_2, L5_2, L6_2 do
    L9_2 = L33_1
    L10_2 = L1_2
    L11_2 = L8_2
    L9_2 = L9_2(L10_2, L11_2)
    if L9_2 then
      L10_2 = L8_2.id
      L11_2 = {}
      L12_2 = L9_2.member
      L11_2.member = L12_2
      L12_2 = L9_2.staff
      L11_2.staff = L12_2
      L12_2 = L9_2.civil
      L11_2.civil = L12_2
      L12_2 = L9_2.grade
      L11_2.grade = L12_2
      L12_2 = L9_2.onduty
      L11_2.onduty = L12_2
      L12_2 = L9_2.member
      if L12_2 then
        L12_2 = L9_2.job
        if L12_2 then
          goto lbl_43
        end
      end
      L12_2 = nil
      ::lbl_43::
      L11_2.job = L12_2
      L12_2 = L95_1
      L13_2 = L9_2
      L14_2 = L8_2
      L12_2 = L12_2(L13_2, L14_2)
      L11_2.mods = L12_2
      L2_2[L10_2] = L11_2
    end
  end
  L3_2 = {}
  L3_2.apps = L2_2
  return L3_2
end
L96_1["capps.access"] = L97_1
L96_1 = RPC
function L97_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2, L19_2, L20_2, L21_2, L22_2, L23_2, L24_2
  L2_2 = L40_1
  L3_2 = A0_2
  L4_2 = A1_2.app
  L5_2 = A1_2.module
  L6_2 = A1_2.side
  L2_2, L3_2 = L2_2(L3_2, L4_2, L5_2, L6_2)
  if not L2_2 then
    L4_2 = {}
    L4_2.error = L3_2
    return L4_2
  end
  L4_2 = L2_2.kind
  if L4_2 then
    L4_2 = L2_2.kind
    if "shift" ~= L4_2 then
      goto lbl_23
    end
  end
  L4_2 = {}
  L4_2.error = "module"
  do return L4_2 end
  ::lbl_23::
  L4_2 = {}
  L5_2 = "app = ?"
  L6_2 = "module = ?"
  L7_2 = "kind = ?"
  L4_2[1] = L5_2
  L4_2[2] = L6_2
  L4_2[3] = L7_2
  L5_2 = {}
  L6_2 = L2_2.def
  L6_2 = L6_2.id
  L7_2 = L2_2.mod
  L7_2 = L7_2.id
  L8_2 = L2_2.kind
  L5_2[1] = L6_2
  L5_2[2] = L7_2
  L5_2[3] = L8_2
  L6_2 = "updated DESC"
  L7_2 = type
  L8_2 = A1_2.filter
  L7_2 = L7_2(L8_2)
  if "string" == L7_2 then
    L7_2 = A1_2.filter
    if L7_2 then
      goto lbl_47
    end
  end
  L7_2 = "all"
  ::lbl_47::
  L8_2 = L2_2.side
  if "civil" == L8_2 then
    L8_2 = L2_2.kind
    if "post" ~= L8_2 then
      L8_2 = L2_2.kind
      if "form" ~= L8_2 then
        L8_2 = L2_2.kind
        if "order" ~= L8_2 then
          goto lbl_73
        end
      end
      L8_2 = L2_2.mod
      L8_2 = L8_2.options
      L8_2 = L8_2.civilSeesOwn
      if false == L8_2 then
        L8_2 = {}
        L9_2 = {}
        L8_2.items = L9_2
        L8_2.total = 0
        L8_2.page = 0
        L8_2.pages = 0
        return L8_2
      end
      ::lbl_73::
      L8_2 = L2_2.kind
      if "order" == L8_2 then
        L8_2 = L2_2.mod
        L8_2 = L8_2.options
        L8_2 = L8_2.orderable
        if false == L8_2 then
          L8_2 = {}
          L9_2 = {}
          L8_2.items = L9_2
          L8_2.total = 0
          L8_2.page = 0
          L8_2.pages = 0
          return L8_2
        end
      end
      L8_2 = #L4_2
      L8_2 = L8_2 + 1
      L4_2[L8_2] = "owner = ?"
      L8_2 = #L5_2
      L8_2 = L8_2 + 1
      L9_2 = L2_2.cid
      L5_2[L8_2] = L9_2
    end
  end
  L8_2 = L2_2.kind
  if "post" == L8_2 then
    L6_2 = "pinned DESC, created DESC"
  else
    L8_2 = L2_2.kind
    if "appt" == L8_2 then
      L6_2 = "at ASC"
    else
      L8_2 = L2_2.kind
      if "call" ~= L8_2 then
        L8_2 = L2_2.kind
        if "order" ~= L8_2 then
          L8_2 = L2_2.kind
          if "bill" ~= L8_2 then
            goto lbl_119
          end
        end
      end
      L6_2 = "created DESC"
    end
  end
  ::lbl_119::
  L8_2 = L2_2.side
  if "staff" == L8_2 then
    if "open" == L7_2 or "closed" == L7_2 then
      L8_2 = L50_1
      L9_2 = L2_2.mod
      L10_2 = L2_2.kind
      L8_2 = L8_2(L9_2, L10_2)
      L9_2 = #L8_2
      if L9_2 > 0 then
        L9_2 = #L4_2
        L9_2 = L9_2 + 1
        L10_2 = "status "
        if "open" == L7_2 then
          L11_2 = "NOT IN"
          if L11_2 then
            goto lbl_143
          end
        end
        L11_2 = "IN"
        ::lbl_143::
        L12_2 = " ("
        L13_2 = "?,"
        L14_2 = L13_2
        L13_2 = L13_2.rep
        L15_2 = #L8_2
        L13_2 = L13_2(L14_2, L15_2)
        L14_2 = L13_2
        L13_2 = L13_2.sub
        L15_2 = 1
        L16_2 = -2
        L13_2 = L13_2(L14_2, L15_2, L16_2)
        L14_2 = ")"
        L10_2 = L10_2 .. L11_2 .. L12_2 .. L13_2 .. L14_2
        L4_2[L9_2] = L10_2
        L9_2 = ipairs
        L10_2 = L8_2
        L9_2, L10_2, L11_2, L12_2 = L9_2(L10_2)
        for L13_2, L14_2 in L9_2, L10_2, L11_2, L12_2 do
          L15_2 = #L5_2
          L15_2 = L15_2 + 1
          L5_2[L15_2] = L14_2
        end
      elseif "closed" == L7_2 then
        L9_2 = {}
        L10_2 = {}
        L9_2.items = L10_2
        L9_2.total = 0
        L9_2.page = 0
        L9_2.pages = 0
        return L9_2
      end
    elseif "mine" == L7_2 then
      L8_2 = #L4_2
      L8_2 = L8_2 + 1
      L4_2[L8_2] = "assignee = ?"
      L8_2 = #L5_2
      L8_2 = L8_2 + 1
      L9_2 = L2_2.cid
      L5_2[L8_2] = L9_2
    elseif "all" ~= L7_2 then
      L8_2 = #L7_2
      if L8_2 <= 24 then
        L8_2 = #L4_2
        L8_2 = L8_2 + 1
        L4_2[L8_2] = "status = ?"
        L8_2 = #L5_2
        L8_2 = L8_2 + 1
        L5_2[L8_2] = L7_2
      end
    end
    L8_2 = L2_2.kind
    if "appt" == L8_2 then
      L8_2 = L91_1
      L9_2 = A1_2.day
      L8_2 = L8_2(L9_2)
      if L8_2 then
        L9_2 = #L4_2
        L9_2 = L9_2 + 1
        L4_2[L9_2] = "at BETWEEN ? AND ?"
        L9_2 = #L5_2
        L9_2 = L9_2 + 1
        L10_2 = L93_1
        L11_2 = A1_2.day
        L12_2 = 0
        L10_2 = L10_2(L11_2, L12_2)
        L5_2[L9_2] = L10_2
        L9_2 = #L5_2
        L9_2 = L9_2 + 1
        L10_2 = L93_1
        L11_2 = A1_2.day
        L12_2 = 1439
        L10_2 = L10_2(L11_2, L12_2)
        L5_2[L9_2] = L10_2
      elseif "closed" ~= L7_2 then
        L9_2 = #L4_2
        L9_2 = L9_2 + 1
        L4_2[L9_2] = "at >= ?"
        L9_2 = #L5_2
        L9_2 = L9_2 + 1
        L10_2 = os
        L10_2 = L10_2.time
        L10_2 = L10_2()
        L10_2 = L10_2 - 43200
        L10_2 = L10_2 * 1000
        L5_2[L9_2] = L10_2
      end
    end
    L8_2 = L20_1
    L9_2 = A1_2.q
    L8_2 = L8_2(L9_2)
    if L8_2 then
      L9_2 = #L4_2
      L9_2 = L9_2 + 1
      L4_2[L9_2] = "(title LIKE ? OR subject LIKE ? OR owner_name LIKE ? OR data LIKE ?)"
      L9_2 = #L5_2
      L9_2 = L9_2 + 1
      L5_2[L9_2] = L8_2
      L9_2 = #L5_2
      L9_2 = L9_2 + 1
      L5_2[L9_2] = L8_2
      L9_2 = #L5_2
      L9_2 = L9_2 + 1
      L5_2[L9_2] = L8_2
      L9_2 = #L5_2
      L9_2 = L9_2 + 1
      L5_2[L9_2] = L8_2
    end
  else
    L8_2 = L2_2.kind
    if "appt" == L8_2 then
      L6_2 = "at DESC"
    end
  end
  L8_2 = table
  L8_2 = L8_2.concat
  L9_2 = L4_2
  L10_2 = " AND "
  L8_2 = L8_2(L9_2, L10_2)
  L9_2 = tonumber
  L10_2 = MySQL
  L10_2 = L10_2.scalar
  L10_2 = L10_2.await
  L11_2 = "SELECT COUNT(*) FROM apex_phone_capp_items WHERE "
  L12_2 = L8_2
  L11_2 = L11_2 .. L12_2
  L12_2 = L5_2
  L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2, L19_2, L20_2, L21_2, L22_2, L23_2, L24_2 = L10_2(L11_2, L12_2)
  L9_2 = L9_2(L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2, L19_2, L20_2, L21_2, L22_2, L23_2, L24_2)
  if not L9_2 then
    L9_2 = 0
  end
  L10_2 = math
  L10_2 = L10_2.max
  L11_2 = 1
  L12_2 = math
  L12_2 = L12_2.ceil
  L13_2 = L1_1
  L13_2 = L9_2 / L13_2
  L12_2 = L12_2(L13_2)
  L10_2 = L10_2(L11_2, L12_2)
  L11_2 = L12_1
  L12_2 = A1_2.page
  L13_2 = 0
  L14_2 = L10_2 - 1
  L15_2 = 0
  L11_2 = L11_2(L12_2, L13_2, L14_2, L15_2)
  L12_2 = L18_1
  L13_2 = L5_2
  L12_2 = L12_2(L13_2)
  L13_2 = #L12_2
  L13_2 = L13_2 + 1
  L14_2 = L1_1
  L12_2[L13_2] = L14_2
  L13_2 = #L12_2
  L13_2 = L13_2 + 1
  L14_2 = L1_1
  L14_2 = L11_2 * L14_2
  L12_2[L13_2] = L14_2
  L13_2 = MySQL
  L13_2 = L13_2.query
  L13_2 = L13_2.await
  L14_2 = "SELECT * FROM apex_phone_capp_items WHERE "
  L15_2 = L8_2
  L16_2 = " ORDER BY "
  L17_2 = L6_2
  L18_2 = ", id DESC LIMIT ? OFFSET ?"
  L14_2 = L14_2 .. L15_2 .. L16_2 .. L17_2 .. L18_2
  L15_2 = L12_2
  L13_2 = L13_2(L14_2, L15_2)
  if not L13_2 then
    L13_2 = {}
  end
  L14_2 = L2_2.kind
  if "bill" == L14_2 then
    L14_2 = L58_1
    L15_2 = L13_2
    L14_2(L15_2)
  end
  L14_2 = {}
  L15_2 = ipairs
  L16_2 = L13_2
  L15_2, L16_2, L17_2, L18_2 = L15_2(L16_2)
  for L19_2, L20_2 in L15_2, L16_2, L17_2, L18_2 do
    L21_2 = L61_1
    L22_2 = L20_2
    L23_2 = L2_2
    L24_2 = false
    L21_2 = L21_2(L22_2, L23_2, L24_2)
    L14_2[L19_2] = L21_2
  end
  L15_2 = {}
  L15_2.items = L14_2
  L15_2.total = L9_2
  L15_2.page = L11_2
  L15_2.pages = L10_2
  return L15_2
end
L96_1["capps.list"] = L97_1
L96_1 = RPC
function L97_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2
  L2_2 = type
  L3_2 = A1_2.app
  L2_2 = L2_2(L3_2)
  if "string" == L2_2 then
    L3_2 = A1_2.app
    L2_2 = L6_1
    L2_2 = L2_2[L3_2]
    if L2_2 then
      goto lbl_12
    end
  end
  L2_2 = nil
  ::lbl_12::
  if L2_2 then
    L3_2 = L2_2.enabled
    if false ~= L3_2 then
      goto lbl_21
    end
  end
  L3_2 = {}
  L3_2.error = "app"
  do return L3_2 end
  ::lbl_21::
  L3_2 = L34_1
  L4_2 = A0_2
  L5_2 = L2_2
  L3_2 = L3_2(L4_2, L5_2)
  if L3_2 then
    L4_2 = L3_2.cid
    if L4_2 then
      goto lbl_34
    end
  end
  L4_2 = {}
  L4_2.error = "noplayer"
  do return L4_2 end
  ::lbl_34::
  L4_2 = L3_2.civil
  if not L4_2 then
    L4_2 = {}
    L5_2 = {}
    L4_2.items = L5_2
    return L4_2
  end
  L4_2 = MySQL
  L4_2 = L4_2.query
  L4_2 = L4_2.await
  L5_2 = "SELECT * FROM apex_phone_capp_items WHERE app = ? AND owner = ? AND kind IN ('form', 'appt', 'call', 'record', 'order') ORDER BY updated DESC LIMIT 30"
  L6_2 = {}
  L7_2 = L2_2.id
  L8_2 = L3_2.cid
  L6_2[1] = L7_2
  L6_2[2] = L8_2
  L4_2 = L4_2(L5_2, L6_2)
  if not L4_2 then
    L4_2 = {}
  end
  L5_2 = {}
  L6_2 = {}
  L7_2 = L3_2.cid
  L6_2.cid = L7_2
  L6_2.side = "civil"
  L7_2 = ipairs
  L8_2 = L4_2
  L7_2, L8_2, L9_2, L10_2 = L7_2(L8_2)
  for L11_2, L12_2 in L7_2, L8_2, L9_2, L10_2 do
    L13_2 = L30_1
    L14_2 = L2_2
    L15_2 = L12_2.module
    L13_2 = L13_2(L14_2, L15_2)
    if L13_2 then
      L14_2 = L13_2.enabled
      if false ~= L14_2 then
        L14_2 = L38_1
        L15_2 = L3_2
        L16_2 = L13_2
        L14_2 = L14_2(L15_2, L16_2)
        if L14_2 then
          L14_2 = #L5_2
          L14_2 = L14_2 + 1
          L15_2 = L61_1
          L16_2 = L12_2
          L17_2 = L6_2
          L18_2 = false
          L15_2 = L15_2(L16_2, L17_2, L18_2)
          L5_2[L14_2] = L15_2
        end
      end
    end
  end
  L7_2 = {}
  L7_2.items = L5_2
  return L7_2
end
L96_1["capps.mine"] = L97_1
L96_1 = RPC
function L97_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2
  L2_2 = type
  L3_2 = A1_2.app
  L2_2 = L2_2(L3_2)
  if "string" == L2_2 then
    L3_2 = A1_2.app
    L2_2 = L6_1
    L2_2 = L2_2[L3_2]
    if L2_2 then
      goto lbl_12
    end
  end
  L2_2 = nil
  ::lbl_12::
  if L2_2 then
    L3_2 = L2_2.enabled
    if false ~= L3_2 then
      goto lbl_21
    end
  end
  L3_2 = {}
  L3_2.error = "app"
  do return L3_2 end
  ::lbl_21::
  L3_2 = L34_1
  L4_2 = A0_2
  L5_2 = L2_2
  L3_2 = L3_2(L4_2, L5_2)
  if L3_2 then
    L4_2 = L3_2.staff
    if L4_2 then
      goto lbl_36
    end
  end
  L4_2 = {}
  L5_2 = {}
  L4_2.counts = L5_2
  do return L4_2 end
  ::lbl_36::
  L4_2 = {}
  L5_2 = MySQL
  L5_2 = L5_2.query
  L5_2 = L5_2.await
  L6_2 = "SELECT module, kind, status, COUNT(*) AS n FROM apex_phone_capp_items WHERE app = ? AND kind IN ('form', 'appt', 'call', 'order') GROUP BY module, kind, status"
  L7_2 = {}
  L8_2 = L2_2.id
  L7_2[1] = L8_2
  L5_2 = L5_2(L6_2, L7_2)
  if not L5_2 then
    L5_2 = {}
  end
  L6_2 = ipairs
  L7_2 = L5_2
  L6_2, L7_2, L8_2, L9_2 = L6_2(L7_2)
  for L10_2, L11_2 in L6_2, L7_2, L8_2, L9_2 do
    L12_2 = L30_1
    L13_2 = L2_2
    L14_2 = L11_2.module
    L12_2 = L12_2(L13_2, L14_2)
    if L12_2 then
      L13_2 = L12_2.enabled
      if false ~= L13_2 then
        L13_2 = L37_1
        L14_2 = L3_2
        L15_2 = L12_2
        L13_2 = L13_2(L14_2, L15_2)
        if L13_2 then
          L14_2 = L11_2.kind
          L13_2 = L48_1
          L13_2 = L13_2[L14_2]
          if L13_2 then
            L13_2 = L43_1
            L14_2 = L12_2
            L13_2 = L13_2(L14_2)
            L13_2 = L13_2[1]
            if not L13_2 then
              L13_2 = {}
            end
            L13_2 = L13_2.id
            if L13_2 then
              goto lbl_93
            end
          end
          L13_2 = L11_2.kind
          if "appt" == L13_2 then
            L13_2 = "pending"
            if L13_2 then
              goto lbl_93
            end
          end
          L13_2 = "waiting"
          ::lbl_93::
          L14_2 = L11_2.status
          if L14_2 == L13_2 then
            L14_2 = L11_2.module
            L15_2 = L11_2.module
            L15_2 = L4_2[L15_2]
            if not L15_2 then
              L15_2 = 0
            end
            L16_2 = tonumber
            L17_2 = L11_2.n
            L16_2 = L16_2(L17_2)
            if not L16_2 then
              L16_2 = 0
            end
            L15_2 = L15_2 + L16_2
            L4_2[L14_2] = L15_2
          end
        end
      end
    end
  end
  L6_2 = {}
  L6_2.counts = L4_2
  return L6_2
end
L96_1["capps.counts"] = L97_1
function L96_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2, L6_2, L7_2
  L2_2 = L56_1
  L3_2 = A1_2.id
  L2_2 = L2_2(L3_2)
  if not L2_2 then
    L3_2 = nil
    L4_2 = "notfound"
    return L3_2, L4_2
  end
  L3_2 = L40_1
  L4_2 = A0_2
  L5_2 = L2_2.app
  L6_2 = L2_2.module
  L7_2 = A1_2.side
  L3_2, L4_2 = L3_2(L4_2, L5_2, L6_2, L7_2)
  if not L3_2 then
    L5_2 = nil
    L6_2 = L4_2
    return L5_2, L6_2
  end
  L5_2 = L3_2.kind
  L6_2 = L2_2.kind
  if L5_2 ~= L6_2 then
    L5_2 = nil
    L6_2 = "notfound"
    return L5_2, L6_2
  end
  L5_2 = L3_2.side
  if "civil" == L5_2 then
    L5_2 = L2_2.kind
    if "post" ~= L5_2 then
      L5_2 = L2_2.owner
      L6_2 = L3_2.cid
      if L5_2 ~= L6_2 then
        L5_2 = nil
        L6_2 = "notfound"
        return L5_2, L6_2
      end
    end
  end
  L5_2 = L3_2
  L6_2 = nil
  L7_2 = L2_2
  return L5_2, L6_2, L7_2
end
function L97_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2
  L2_2 = "SELECT * FROM apex_phone_capp_notes WHERE item = ?"
  L3_2 = A1_2.side
  if "civil" == L3_2 then
    L3_2 = " AND private = 0"
    if L3_2 then
      goto lbl_9
    end
  end
  L3_2 = ""
  ::lbl_9::
  L4_2 = " ORDER BY id ASC LIMIT 200"
  L2_2 = L2_2 .. L3_2 .. L4_2
  L3_2 = {}
  L4_2 = ipairs
  L5_2 = MySQL
  L5_2 = L5_2.query
  L5_2 = L5_2.await
  L6_2 = L2_2
  L7_2 = {}
  L8_2 = tonumber
  L9_2 = A0_2.id
  L8_2, L9_2, L10_2, L11_2, L12_2, L13_2 = L8_2(L9_2)
  L7_2[1] = L8_2
  L7_2[2] = L9_2
  L7_2[3] = L10_2
  L7_2[4] = L11_2
  L7_2[5] = L12_2
  L7_2[6] = L13_2
  L5_2 = L5_2(L6_2, L7_2)
  if not L5_2 then
    L5_2 = {}
  end
  L4_2, L5_2, L6_2, L7_2 = L4_2(L5_2)
  for L8_2, L9_2 in L4_2, L5_2, L6_2, L7_2 do
    L10_2 = #L3_2
    L10_2 = L10_2 + 1
    L11_2 = L62_1
    L12_2 = L9_2
    L13_2 = A1_2
    L11_2 = L11_2(L12_2, L13_2)
    L3_2[L10_2] = L11_2
  end
  return L3_2
end
L98_1 = RPC
function L99_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2
  L2_2 = L96_1
  L3_2 = A0_2
  L4_2 = A1_2
  L2_2, L3_2, L4_2 = L2_2(L3_2, L4_2)
  if not L2_2 then
    L5_2 = {}
    L5_2.error = L3_2
    return L5_2
  end
  L5_2 = L4_2.kind
  if "bill" == L5_2 then
    L5_2 = L58_1
    L6_2 = {}
    L7_2 = L4_2
    L6_2[1] = L7_2
    L5_2(L6_2)
  end
  L5_2 = {}
  L6_2 = L4_2.kind
  L6_2 = "post" ~= L6_2
  if L6_2 then
    L7_2 = L2_2.side
    if "staff" ~= L7_2 then
      L8_2 = L2_2.kind
      L7_2 = L48_1
      L7_2 = L7_2[L8_2]
      if L7_2 then
        L7_2 = L2_2.mod
        L7_2 = L7_2.options
        L7_2 = L7_2.replies
        if false == L7_2 then
          goto lbl_53
        end
      end
    end
    L7_2 = L97_1
    L8_2 = L4_2
    L9_2 = L2_2
    L7_2 = L7_2(L8_2, L9_2)
    L5_2 = L7_2
  end
  ::lbl_53::
  L7_2 = {}
  L8_2 = L61_1
  L9_2 = L4_2
  L10_2 = L2_2
  L11_2 = true
  L8_2 = L8_2(L9_2, L10_2, L11_2)
  L7_2.item = L8_2
  L7_2.notes = L5_2
  return L7_2
end
L98_1["capps.get"] = L99_1
function L98_1()
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
  L2_2 = L13_1
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
function L99_1(A0_2, A1_2, A2_2, A3_2, A4_2, A5_2)
  local L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2, L19_2
  L6_2 = type
  L7_2 = CreateBillInternal
  L6_2 = L6_2(L7_2)
  if "function" ~= L6_2 then
    L6_2 = {}
    L6_2.error = "billing"
    return L6_2
  end
  L6_2 = L98_1
  L6_2 = L6_2()
  L7_2 = L6_2.maxAmount
  if nil ~= A5_2 then
    L8_2 = math
    L8_2 = L8_2.min
    L9_2 = L7_2
    L10_2 = L12_1
    L11_2 = A5_2
    L12_2 = 1
    L13_2 = 1000000000
    L14_2 = L7_2
    L10_2 = L10_2(L11_2, L12_2, L13_2, L14_2)
    L8_2 = L8_2(L9_2, L10_2)
    L7_2 = L8_2
  end
  if A2_2 > L7_2 then
    L8_2 = {}
    L8_2.error = "amount"
    L8_2.max = L7_2
    return L8_2
  end
  L8_2 = A0_2.cid
  if A1_2 == L8_2 then
    L8_2 = {}
    L8_2.error = "self"
    return L8_2
  end
  L8_2 = nil
  if A4_2 then
    L9_2 = A0_2.acc
    L9_2 = L9_2.job
    L10_2 = type
    L11_2 = L9_2
    L10_2 = L10_2(L11_2)
    if "string" ~= L10_2 or "" == L9_2 or "unemployed" == L9_2 then
      L10_2 = {}
      L10_2.error = "society"
      return L10_2
    end
    L10_2 = L6_2.minGrade
    L11_2 = L6_2.societyJobs
    if L11_2 then
      L11_2 = L6_2.societyJobs
      L10_2 = L11_2[L9_2]
      if nil == L10_2 then
        L11_2 = {}
        L11_2.error = "society"
        return L11_2
      end
      L11_2 = tonumber
      L12_2 = L10_2
      L11_2 = L11_2(L12_2)
      L10_2 = L11_2 or L10_2
      if not L11_2 then
        L10_2 = 0
      end
    end
    L11_2 = A0_2.acc
    L11_2 = L11_2.grade
    if L10_2 > L11_2 then
      L11_2 = {}
      L11_2.error = "grade"
      return L11_2
    end
    L8_2 = L9_2
  end
  L9_2 = os
  L9_2 = L9_2.time
  L9_2 = L9_2()
  L11_2 = A0_2.src
  L10_2 = L86_1
  L10_2 = L10_2[L11_2]
  if L10_2 then
    L11_2 = L9_2 - L10_2
    L12_2 = L6_2.cooldown
    if L11_2 < L12_2 then
      L11_2 = {}
      L11_2.error = "cooldown"
      L12_2 = L6_2.cooldown
      L13_2 = L9_2 - L10_2
      L12_2 = L12_2 - L13_2
      L11_2.wait = L12_2
      return L11_2
    end
  end
  L12_2 = A0_2.src
  L11_2 = L86_1
  L11_2[L12_2] = L9_2
  L11_2 = L24_1
  L12_2 = A0_2.acc
  L12_2 = L12_2.p
  L11_2 = L11_2(L12_2)
  if not L11_2 then
    L11_2 = "Equipa"
  end
  if L8_2 then
    L12_2 = A0_2.acc
    L12_2 = L12_2.jobLabel
    if not L12_2 then
      L12_2 = L8_2
    end
    L13_2 = " \194\183 "
    L14_2 = L11_2
    L12_2 = L12_2 .. L13_2 .. L14_2
    if L12_2 then
      goto lbl_131
    end
  end
  L12_2 = L11_2
  ::lbl_131::
  L13_2 = CreateBillInternal
  L14_2 = A1_2
  L15_2 = L12_2
  L16_2 = A2_2
  L17_2 = A3_2
  L18_2 = {}
  L19_2 = A0_2.cid
  L18_2.senderCid = L19_2
  L18_2.society = L8_2
  L13_2 = L13_2(L14_2, L15_2, L16_2, L17_2, L18_2)
  if not L13_2 then
    L15_2 = A0_2.src
    L14_2 = L86_1
    L14_2 = L14_2[L15_2]
    if L14_2 == L9_2 then
      L15_2 = A0_2.src
      L14_2 = L86_1
      L14_2[L15_2] = L10_2
    end
    L14_2 = {}
    L14_2.error = "billing"
    return L14_2
  end
  return L13_2
end
function L100_1(A0_2)
  local L1_2, L2_2, L3_2, L4_2, L5_2, L6_2, L7_2
  L1_2 = ipairs
  L2_2 = A0_2.modules
  L1_2, L2_2, L3_2, L4_2 = L1_2(L2_2)
  for L5_2, L6_2 in L1_2, L2_2, L3_2, L4_2 do
    L7_2 = L6_2.type
    if "billing" == L7_2 then
      L7_2 = L6_2.enabled
      if false ~= L7_2 then
        return L6_2
      end
    end
  end
  L1_2 = nil
  return L1_2
end
L101_1 = 10
L102_1 = 15
function L103_1(A0_2)
  local L1_2, L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2, L19_2, L20_2, L21_2, L22_2, L23_2, L24_2
  L1_2 = Now
  L1_2 = L1_2()
  L2_2 = MySQL
  L2_2 = L2_2.insert
  L2_2 = L2_2.await
  L3_2 = "INSERT INTO apex_phone_capp_items (app, module, kind, owner, owner_name, owner_phone, anonymous, status, title, subject, data, assignee, assignee_name, x, y, z, at, pinned, created, updated) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)"
  L4_2 = {}
  L5_2 = A0_2.app
  L6_2 = A0_2.module
  L7_2 = A0_2.kind
  L8_2 = A0_2.owner
  L9_2 = A0_2.owner_name
  L10_2 = A0_2.owner_phone
  L11_2 = A0_2.anonymous
  if L11_2 then
    L11_2 = 1
    if L11_2 then
      goto lbl_22
    end
  end
  L11_2 = 0
  ::lbl_22::
  L12_2 = A0_2.status
  L13_2 = A0_2.title
  L14_2 = A0_2.subject
  L15_2 = A0_2.data
  if L15_2 then
    L15_2 = L21_1
    L16_2 = A0_2.data
    L15_2 = L15_2(L16_2)
    if L15_2 then
      goto lbl_34
    end
  end
  L15_2 = nil
  ::lbl_34::
  L16_2 = A0_2.assignee
  L17_2 = A0_2.assignee_name
  L18_2 = A0_2.x
  L19_2 = A0_2.y
  L20_2 = A0_2.z
  L21_2 = A0_2.at
  L22_2 = A0_2.pinned
  if L22_2 then
    L22_2 = 1
    if L22_2 then
      goto lbl_47
    end
  end
  L22_2 = 0
  ::lbl_47::
  L23_2 = L1_2
  L24_2 = L1_2
  L4_2[1] = L5_2
  L4_2[2] = L6_2
  L4_2[3] = L7_2
  L4_2[4] = L8_2
  L4_2[5] = L9_2
  L4_2[6] = L10_2
  L4_2[7] = L11_2
  L4_2[8] = L12_2
  L4_2[9] = L13_2
  L4_2[10] = L14_2
  L4_2[11] = L15_2
  L4_2[12] = L16_2
  L4_2[13] = L17_2
  L4_2[14] = L18_2
  L4_2[15] = L19_2
  L4_2[16] = L20_2
  L4_2[17] = L21_2
  L4_2[18] = L22_2
  L4_2[19] = L23_2
  L4_2[20] = L24_2
  L2_2 = L2_2(L3_2, L4_2)
  L3_2 = tonumber
  L4_2 = L2_2
  return L3_2(L4_2)
end
function L104_1(A0_2)
  local L1_2, L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2
  L1_2 = L50_1
  L2_2 = A0_2.mod
  L3_2 = A0_2.kind
  L1_2 = L1_2(L2_2, L3_2)
  L2_2 = "SELECT COUNT(*) FROM apex_phone_capp_items WHERE app = ? AND module = ? AND owner = ?"
  L3_2 = {}
  L4_2 = A0_2.def
  L4_2 = L4_2.id
  L5_2 = A0_2.mod
  L5_2 = L5_2.id
  L6_2 = A0_2.cid
  L3_2[1] = L4_2
  L3_2[2] = L5_2
  L3_2[3] = L6_2
  L4_2 = #L1_2
  if L4_2 > 0 then
    L4_2 = L2_2
    L5_2 = " AND status NOT IN ("
    L6_2 = "?,"
    L7_2 = L6_2
    L6_2 = L6_2.rep
    L8_2 = #L1_2
    L6_2 = L6_2(L7_2, L8_2)
    L7_2 = L6_2
    L6_2 = L6_2.sub
    L8_2 = 1
    L9_2 = -2
    L6_2 = L6_2(L7_2, L8_2, L9_2)
    L7_2 = ")"
    L4_2 = L4_2 .. L5_2 .. L6_2 .. L7_2
    L2_2 = L4_2
    L4_2 = ipairs
    L5_2 = L1_2
    L4_2, L5_2, L6_2, L7_2 = L4_2(L5_2)
    for L8_2, L9_2 in L4_2, L5_2, L6_2, L7_2 do
      L10_2 = #L3_2
      L10_2 = L10_2 + 1
      L3_2[L10_2] = L9_2
    end
  end
  L4_2 = tonumber
  L5_2 = MySQL
  L5_2 = L5_2.scalar
  L5_2 = L5_2.await
  L6_2 = L2_2
  L7_2 = L3_2
  L5_2, L6_2, L7_2, L8_2, L9_2, L10_2 = L5_2(L6_2, L7_2)
  L4_2 = L4_2(L5_2, L6_2, L7_2, L8_2, L9_2, L10_2)
  if not L4_2 then
    L4_2 = 0
  end
  return L4_2
end
function L105_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2
  L2_2 = L12_1
  L3_2 = A0_2.mod
  L3_2 = L3_2.options
  L3_2 = L3_2.pinLimit
  L4_2 = 1
  L5_2 = 50
  L6_2 = 3
  L2_2 = L2_2(L3_2, L4_2, L5_2, L6_2)
  L3_2 = tonumber
  L4_2 = MySQL
  L4_2 = L4_2.scalar
  L4_2 = L4_2.await
  L5_2 = "SELECT COUNT(*) FROM apex_phone_capp_items WHERE app = ? AND module = ? AND kind = 'post' AND pinned = 1 AND id <> ?"
  L6_2 = {}
  L7_2 = A0_2.def
  L7_2 = L7_2.id
  L8_2 = A0_2.mod
  L8_2 = L8_2.id
  L9_2 = A1_2 or L9_2
  if not A1_2 then
    L9_2 = 0
  end
  L6_2[1] = L7_2
  L6_2[2] = L8_2
  L6_2[3] = L9_2
  L4_2, L5_2, L6_2, L7_2, L8_2, L9_2 = L4_2(L5_2, L6_2)
  L3_2 = L3_2(L4_2, L5_2, L6_2, L7_2, L8_2, L9_2)
  if not L3_2 then
    L3_2 = 0
  end
  L4_2 = L2_2 <= L3_2
  L5_2 = L2_2
  return L4_2, L5_2
end
L106_1 = {}
function L107_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2
  L2_2 = A0_2.mod
  L2_2 = L2_2.options
  L3_2 = L81_1
  L4_2 = L2_2.fields
  L5_2 = A1_2.fields
  L3_2, L4_2, L5_2 = L3_2(L4_2, L5_2)
  if not L3_2 then
    L6_2 = {}
    L6_2.error = L4_2
    L6_2.field = L5_2
    return L6_2
  end
  L6_2 = next
  L7_2 = L3_2.fields
  L6_2 = L6_2(L7_2)
  if nil == L6_2 then
    L6_2 = {}
    L6_2.error = "empty"
    return L6_2
  end
  L6_2 = L2_2.anonymous
  L6_2 = true == L6_2
  L7_2 = L2_2.location
  if true == L7_2 then
    L7_2 = A1_2.location
    if true == L7_2 then
      L7_2 = L26_1
      L8_2 = A0_2.src
      L9_2 = A1_2.coords
      L7_2 = L7_2(L8_2, L9_2)
      if L7_2 then
        goto lbl_44
      end
    end
  end
  L7_2 = nil
  ::lbl_44::
  L8_2 = {}
  L9_2 = L3_2.fields
  L8_2.fields = L9_2
  L9_2 = L3_2.order
  L8_2.order = L9_2
  L9_2 = L2_2.photo
  if true == L9_2 then
    L9_2 = A1_2.photo
    if nil ~= L9_2 then
      L9_2 = A1_2.photo
      if "" ~= L9_2 then
        L9_2 = L19_1
        L10_2 = A1_2.photo
        L9_2 = L9_2(L10_2)
        L8_2.photo = L9_2
        L9_2 = L8_2.photo
        if not L9_2 then
          L9_2 = {}
          L9_2.error = "photo"
          return L9_2
        end
      end
    end
  end
  L9_2 = A0_2.acc
  L9_2 = L9_2.p
  L10_2 = L43_1
  L11_2 = A0_2.mod
  L10_2 = L10_2(L11_2)
  L10_2 = L10_2[1]
  L10_2 = L10_2.id
  L11_2 = {}
  L11_2.status = L10_2
  L12_2 = L82_1
  L13_2 = L2_2.fields
  L14_2 = L3_2.fields
  L12_2 = L12_2(L13_2, L14_2)
  if not L12_2 then
    L12_2 = L11_1
    L13_2 = A0_2.mod
    L13_2 = L13_2.title
    L14_2 = 120
    L12_2 = L12_2(L13_2, L14_2)
    if not L12_2 then
      L12_2 = A0_2.mod
      L12_2 = L12_2.id
    end
  end
  L11_2.title = L12_2
  L11_2.data = L8_2
  L11_2.anonymous = L6_2
  if not L6_2 then
    L12_2 = L24_1
    L13_2 = L9_2
    L12_2 = L12_2(L13_2)
    if L12_2 then
      goto lbl_106
    end
  end
  L12_2 = nil
  ::lbl_106::
  L11_2.owner_name = L12_2
  if not L6_2 then
    L12_2 = GetPlayerNumber
    L13_2 = A0_2.src
    L12_2 = L12_2(L13_2)
    if L12_2 then
      goto lbl_118
    end
    L12_2 = L9_2.phone
    if L12_2 then
      goto lbl_118
    end
  end
  L12_2 = nil
  ::lbl_118::
  L11_2.owner_phone = L12_2
  L12_2 = L7_2 or L12_2
  if L7_2 then
    L12_2 = L7_2.x
  end
  L11_2.x = L12_2
  L12_2 = L7_2 or L12_2
  if L7_2 then
    L12_2 = L7_2.y
  end
  L11_2.y = L12_2
  L12_2 = L7_2 or L12_2
  if L7_2 then
    L12_2 = L7_2.z
  end
  L11_2.z = L12_2
  return L11_2
end
L106_1.form = L107_1
function L107_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2
  L2_2 = L89_1
  L3_2 = A0_2.mod
  L2_2 = L2_2(L3_2)
  L3_2 = nil
  L4_2 = L2_2.services
  L4_2 = #L4_2
  if L4_2 > 0 then
    L4_2 = ipairs
    L5_2 = L2_2.services
    L4_2, L5_2, L6_2, L7_2 = L4_2(L5_2)
    for L8_2, L9_2 in L4_2, L5_2, L6_2, L7_2 do
      L10_2 = L9_2.id
      L11_2 = A1_2.service
      if L10_2 == L11_2 then
        L3_2 = L9_2
      end
    end
    if not L3_2 then
      L4_2 = {}
      L4_2.error = "service"
      return L4_2
    end
  end
  L4_2 = L11_1
  L5_2 = A1_2.day
  L6_2 = 10
  L4_2 = L4_2(L5_2, L6_2)
  L5_2 = L11_1
  L6_2 = A1_2.time
  L7_2 = 5
  L5_2 = L5_2(L6_2, L7_2)
  if L4_2 then
    L6_2 = L91_1
    L7_2 = L4_2
    L6_2 = L6_2(L7_2)
    if L6_2 and L5_2 then
      L7_2 = L5_2
      L6_2 = L5_2.match
      L8_2 = "^%d%d:%d%d$"
      L6_2 = L6_2(L7_2, L8_2)
      if L6_2 then
        goto lbl_53
      end
    end
  end
  L6_2 = {}
  L6_2.error = "slot"
  do return L6_2 end
  ::lbl_53::
  L6_2 = false
  L7_2 = ipairs
  L8_2 = L92_1
  L9_2 = L2_2
  L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2 = L8_2(L9_2)
  L7_2, L8_2, L9_2, L10_2 = L7_2(L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2)
  for L11_2, L12_2 in L7_2, L8_2, L9_2, L10_2 do
    L13_2 = L12_2.day
    if L13_2 == L4_2 then
      L13_2 = L12_2.open
      if L13_2 then
        L6_2 = true
      end
    end
  end
  if not L6_2 then
    L7_2 = {}
    L7_2.error = "slot"
    return L7_2
  end
  L7_2 = nil
  L8_2 = ipairs
  L9_2 = L94_1
  L10_2 = A0_2.def
  L11_2 = A0_2.mod
  L12_2 = L2_2
  L13_2 = L4_2
  L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2 = L9_2(L10_2, L11_2, L12_2, L13_2)
  L8_2, L9_2, L10_2, L11_2 = L8_2(L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2)
  for L12_2, L13_2 in L8_2, L9_2, L10_2, L11_2 do
    L14_2 = L13_2.time
    if L14_2 == L5_2 then
      L7_2 = L13_2
    end
  end
  if not L7_2 then
    L8_2 = {}
    L8_2.error = "slot"
    return L8_2
  end
  L8_2 = L7_2.free
  if L8_2 <= 0 then
    L8_2 = {}
    L8_2.error = "full"
    return L8_2
  end
  L8_2 = tonumber
  L9_2 = MySQL
  L9_2 = L9_2.scalar
  L9_2 = L9_2.await
  L10_2 = "SELECT COUNT(*) FROM apex_phone_capp_items WHERE app = ? AND module = ? AND owner = ? AND kind = 'appt' AND status IN ('pending', 'confirmed') AND at > ?"
  L11_2 = {}
  L12_2 = A0_2.def
  L12_2 = L12_2.id
  L13_2 = A0_2.mod
  L13_2 = L13_2.id
  L14_2 = A0_2.cid
  L15_2 = os
  L15_2 = L15_2.time
  L15_2 = L15_2()
  L15_2 = L15_2 * 1000
  L11_2[1] = L12_2
  L11_2[2] = L13_2
  L11_2[3] = L14_2
  L11_2[4] = L15_2
  L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2 = L9_2(L10_2, L11_2)
  L8_2 = L8_2(L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2)
  if not L8_2 then
    L8_2 = 0
  end
  if L8_2 >= 3 then
    L9_2 = {}
    L9_2.error = "toomany"
    L9_2.max = 3
    return L9_2
  end
  L10_2 = L5_2
  L9_2 = L5_2.match
  L11_2 = "^(%d%d):(%d%d)$"
  L9_2, L10_2 = L9_2(L10_2, L11_2)
  L11_2 = A0_2.acc
  L11_2 = L11_2.p
  L12_2 = {}
  L12_2.status = "pending"
  if L3_2 then
    L13_2 = L3_2.label
    if L13_2 then
      goto lbl_158
    end
  end
  L13_2 = L11_1
  L14_2 = A0_2.mod
  L14_2 = L14_2.title
  L15_2 = 120
  L13_2 = L13_2(L14_2, L15_2)
  if not L13_2 then
    L13_2 = A0_2.mod
    L13_2 = L13_2.id
  end
  ::lbl_158::
  L12_2.title = L13_2
  L13_2 = L93_1
  L14_2 = L4_2
  L15_2 = tonumber
  L16_2 = L9_2
  L15_2 = L15_2(L16_2)
  L15_2 = L15_2 * 60
  L16_2 = tonumber
  L17_2 = L10_2
  L16_2 = L16_2(L17_2)
  L15_2 = L15_2 + L16_2
  L13_2 = L13_2(L14_2, L15_2)
  L12_2.at = L13_2
  L13_2 = {}
  L13_2.day = L4_2
  L13_2.time = L5_2
  if L3_2 then
    L14_2 = L3_2.id
    if L14_2 then
      goto lbl_183
    end
  end
  L14_2 = nil
  ::lbl_183::
  L13_2.service = L14_2
  if L3_2 then
    L14_2 = L3_2.label
    if L14_2 then
      goto lbl_190
    end
  end
  L14_2 = nil
  ::lbl_190::
  L13_2.service_label = L14_2
  if L3_2 then
    L14_2 = L3_2.minutes
    if L14_2 then
      goto lbl_197
    end
  end
  L14_2 = L2_2.slot
  ::lbl_197::
  L13_2.minutes = L14_2
  L14_2 = L2_2.notes
  if L14_2 then
    L14_2 = L11_1
    L15_2 = A1_2.notes
    L16_2 = 300
    L17_2 = true
    L14_2 = L14_2(L15_2, L16_2, L17_2)
    if L14_2 then
      goto lbl_209
    end
  end
  L14_2 = nil
  ::lbl_209::
  L13_2.notes = L14_2
  L12_2.data = L13_2
  L13_2 = L24_1
  L14_2 = L11_2
  L13_2 = L13_2(L14_2)
  L12_2.owner_name = L13_2
  L13_2 = GetPlayerNumber
  L14_2 = A0_2.src
  L13_2 = L13_2(L14_2)
  if not L13_2 then
    L13_2 = L11_2.phone
  end
  L12_2.owner_phone = L13_2
  return L12_2
end
L106_1.appt = L107_1
function L107_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2
  L2_2 = A0_2.mod
  L2_2 = L2_2.options
  L3_2 = L17_1
  L4_2 = L2_2.types
  L3_2 = L3_2(L4_2)
  L4_2 = nil
  L5_2 = #L3_2
  if L5_2 > 0 then
    L5_2 = ipairs
    L6_2 = L3_2
    L5_2, L6_2, L7_2, L8_2 = L5_2(L6_2)
    for L9_2, L10_2 in L5_2, L6_2, L7_2, L8_2 do
      L11_2 = type
      L12_2 = L10_2
      L11_2 = L11_2(L12_2)
      if "table" == L11_2 then
        L11_2 = L10_2.id
        L12_2 = A1_2.type
        if L11_2 == L12_2 then
          L4_2 = L10_2
        end
      end
    end
    if not L4_2 then
      L5_2 = {}
      L5_2.error = "type"
      return L5_2
    end
  end
  L5_2 = A0_2.cid
  L6_2 = "|"
  L7_2 = A0_2.def
  L7_2 = L7_2.id
  L8_2 = "|"
  L9_2 = A0_2.mod
  L9_2 = L9_2.id
  L5_2 = L5_2 .. L6_2 .. L7_2 .. L8_2 .. L9_2
  L6_2 = L12_1
  L7_2 = L2_2.cooldown
  L8_2 = 0
  L9_2 = 3600
  L10_2 = 60
  L6_2 = L6_2(L7_2, L8_2, L9_2, L10_2)
  L7_2 = L88_1
  L8_2 = L84_1
  L9_2 = L5_2
  L10_2 = L6_2
  L7_2 = L7_2(L8_2, L9_2, L10_2)
  if L7_2 > 0 then
    L8_2 = {}
    L8_2.error = "cooldown"
    L8_2.wait = L7_2
    return L8_2
  end
  L8_2 = tonumber
  L9_2 = MySQL
  L9_2 = L9_2.scalar
  L9_2 = L9_2.await
  L10_2 = "SELECT COUNT(*) FROM apex_phone_capp_items WHERE app = ? AND module = ? AND owner = ? AND kind = 'call' AND status IN ('waiting', 'accepted')"
  L11_2 = {}
  L12_2 = A0_2.def
  L12_2 = L12_2.id
  L13_2 = A0_2.mod
  L13_2 = L13_2.id
  L14_2 = A0_2.cid
  L11_2[1] = L12_2
  L11_2[2] = L13_2
  L11_2[3] = L14_2
  L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2 = L9_2(L10_2, L11_2)
  L8_2 = L8_2(L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2)
  if not L8_2 then
    L8_2 = 0
  end
  if L8_2 > 0 then
    L9_2 = {}
    L9_2.error = "open"
    return L9_2
  end
  L9_2 = L26_1
  L10_2 = A0_2.src
  L11_2 = A1_2.coords
  L9_2 = L9_2(L10_2, L11_2)
  L10_2 = L2_2.location
  if false ~= L10_2 and not L9_2 then
    L10_2 = {}
    L10_2.error = "location"
    return L10_2
  end
  L10_2 = L84_1
  L11_2 = os
  L11_2 = L11_2.time
  L11_2 = L11_2()
  L10_2[L5_2] = L11_2
  L10_2 = A0_2.acc
  L10_2 = L10_2.p
  L11_2 = L11_1
  L12_2 = A1_2.message
  L13_2 = 200
  L14_2 = true
  L11_2 = L11_2(L12_2, L13_2, L14_2)
  L12_2 = {}
  L12_2.status = "waiting"
  if L4_2 then
    L13_2 = L11_1
    L14_2 = L4_2.label
    L15_2 = 60
    L13_2 = L13_2(L14_2, L15_2)
    if L13_2 then
      goto lbl_131
    end
    L13_2 = L4_2.id
    if L13_2 then
      goto lbl_131
    end
  end
  L13_2 = L11_1
  L14_2 = A0_2.mod
  L14_2 = L14_2.title
  L15_2 = 120
  L13_2 = L13_2(L14_2, L15_2)
  if not L13_2 then
    L13_2 = A0_2.mod
    L13_2 = L13_2.id
  end
  ::lbl_131::
  L12_2.title = L13_2
  L13_2 = {}
  if L4_2 then
    L14_2 = L4_2.id
    if L14_2 then
      goto lbl_140
    end
  end
  L14_2 = nil
  ::lbl_140::
  L13_2.type = L14_2
  if L4_2 then
    L14_2 = L11_1
    L15_2 = L4_2.label
    L16_2 = 60
    L14_2 = L14_2(L15_2, L16_2)
    if L14_2 then
      goto lbl_150
    end
  end
  L14_2 = nil
  ::lbl_150::
  L13_2.type_label = L14_2
  L13_2.message = L11_2
  L12_2.data = L13_2
  L13_2 = L24_1
  L14_2 = L10_2
  L13_2 = L13_2(L14_2)
  L12_2.owner_name = L13_2
  L13_2 = GetPlayerNumber
  L14_2 = A0_2.src
  L13_2 = L13_2(L14_2)
  if not L13_2 then
    L13_2 = L10_2.phone
  end
  L12_2.owner_phone = L13_2
  L13_2 = L9_2 or L13_2
  if L9_2 then
    L13_2 = L9_2.x
  end
  L12_2.x = L13_2
  L13_2 = L9_2 or L13_2
  if L9_2 then
    L13_2 = L9_2.y
  end
  L12_2.y = L13_2
  L13_2 = L9_2 or L13_2
  if L9_2 then
    L13_2 = L9_2.z
  end
  L12_2.z = L13_2
  return L12_2
end
L106_1.call = L107_1
function L107_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2
  L2_2 = A0_2.mod
  L2_2 = L2_2.options
  L3_2 = L11_1
  L4_2 = A1_2.subject
  L5_2 = 100
  L3_2 = L3_2(L4_2, L5_2)
  if not L3_2 then
    L4_2 = {}
    L4_2.error = "subject"
    return L4_2
  end
  L4_2 = L2_2.subject
  if "vehicle" == L4_2 then
    L5_2 = L3_2
    L4_2 = L3_2.upper
    L4_2 = L4_2(L5_2)
    L3_2 = L4_2
  end
  L4_2 = L81_1
  L5_2 = L2_2.fields
  L6_2 = A1_2.fields
  L4_2, L5_2, L6_2 = L4_2(L5_2, L6_2)
  if not L4_2 then
    L7_2 = {}
    L7_2.error = L5_2
    L7_2.field = L6_2
    return L7_2
  end
  L7_2 = {}
  L8_2 = {}
  L9_2 = ipairs
  L10_2 = L17_1
  L11_2 = L2_2.tags
  L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2 = L10_2(L11_2)
  L9_2, L10_2, L11_2, L12_2 = L9_2(L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2)
  for L13_2, L14_2 in L9_2, L10_2, L11_2, L12_2 do
    L15_2 = type
    L16_2 = L14_2
    L15_2 = L15_2(L16_2)
    if "table" == L15_2 then
      L15_2 = type
      L16_2 = L14_2.id
      L15_2 = L15_2(L16_2)
      if "string" == L15_2 then
        L15_2 = L14_2.id
        L8_2[L15_2] = true
      end
    end
  end
  L9_2 = ipairs
  L10_2 = L17_1
  L11_2 = A1_2.tags
  L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2 = L10_2(L11_2)
  L9_2, L10_2, L11_2, L12_2 = L9_2(L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2)
  for L13_2, L14_2 in L9_2, L10_2, L11_2, L12_2 do
    L15_2 = L8_2[L14_2]
    if L15_2 then
      L15_2 = #L7_2
      if L15_2 < 12 then
        L15_2 = #L7_2
        L15_2 = L15_2 + 1
        L7_2[L15_2] = L14_2
      end
    end
  end
  L9_2 = nil
  L10_2 = nil
  L11_2 = nil
  L12_2 = L11_1
  L13_2 = A1_2.phone
  L14_2 = 20
  L12_2 = L12_2(L13_2, L14_2)
  if L12_2 then
    L13_2 = L2_2.subject
    if "vehicle" ~= L13_2 then
      L13_2 = CanonNumber
      if L13_2 then
        L13_2 = CanonNumber
        L14_2 = L12_2
        L13_2 = L13_2(L14_2)
        if L13_2 then
          goto lbl_93
        end
      end
      L13_2 = L12_2
      ::lbl_93::
      L14_2 = GetCitizenIdByNumber
      if L14_2 then
        L14_2 = GetCitizenIdByNumber
        L15_2 = L13_2
        L14_2 = L14_2(L15_2)
        if L14_2 then
          goto lbl_112
        end
      end
      L14_2 = FW
      L14_2 = L14_2.FindCidByPhone
      if L14_2 then
        L14_2 = FW
        L14_2 = L14_2.FindCidByPhone
        L15_2 = L13_2
        L14_2 = L14_2(L15_2)
        if L14_2 then
          goto lbl_112
        end
      end
      L14_2 = nil
      ::lbl_112::
      if not L14_2 then
        L15_2 = {}
        L15_2.error = "phone"
        return L15_2
      end
      L15_2 = L14_2
      L11_2 = L13_2
      L9_2 = L15_2
      L10_2 = L3_2
    end
  end
  L13_2 = A0_2.acc
  L13_2 = L13_2.p
  L14_2 = {}
  L14_2.status = "open"
  L14_2.title = L3_2
  L14_2.subject = L3_2
  L14_2.owner = L9_2
  L14_2.owner_name = L10_2
  L14_2.owner_phone = L11_2
  L15_2 = A0_2.cid
  L14_2.assignee = L15_2
  L15_2 = L24_1
  L16_2 = L13_2
  L15_2 = L15_2(L16_2)
  L14_2.assignee_name = L15_2
  L15_2 = {}
  L16_2 = L4_2.fields
  L15_2.fields = L16_2
  L16_2 = L4_2.order
  L15_2.order = L16_2
  L15_2.tags = L7_2
  L16_2 = L24_1
  L17_2 = L13_2
  L16_2 = L16_2(L17_2)
  L15_2.author = L16_2
  L14_2.data = L15_2
  return L14_2
end
L106_1.record = L107_1
function L107_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2
  L2_2 = L11_1
  L3_2 = A1_2.title
  L4_2 = 120
  L2_2 = L2_2(L3_2, L4_2)
  L3_2 = L11_1
  L4_2 = A1_2.body
  L5_2 = 2000
  L6_2 = true
  L3_2 = L3_2(L4_2, L5_2, L6_2)
  if not L2_2 or not L3_2 then
    L4_2 = {}
    L4_2.error = "empty"
    return L4_2
  end
  L4_2 = nil
  L5_2 = A1_2.image
  if nil ~= L5_2 then
    L5_2 = A1_2.image
    if "" ~= L5_2 then
      L5_2 = L19_1
      L6_2 = A1_2.image
      L5_2 = L5_2(L6_2)
      L4_2 = L5_2
      if not L4_2 then
        L5_2 = {}
        L5_2.error = "photo"
        return L5_2
      end
    end
  end
  L5_2 = A1_2.pinned
  if true == L5_2 then
    L5_2 = L105_1
    L6_2 = A0_2
    L5_2, L6_2 = L5_2(L6_2)
    if L5_2 then
      L7_2 = {}
      L7_2.error = "pinlimit"
      L7_2.max = L6_2
      return L7_2
    end
  end
  L5_2 = A0_2.acc
  L5_2 = L5_2.p
  L6_2 = {}
  L6_2.status = "published"
  L6_2.title = L2_2
  L7_2 = A1_2.pinned
  L7_2 = true == L7_2
  L6_2.pinned = L7_2
  L7_2 = {}
  L7_2.body = L3_2
  L7_2.image = L4_2
  L8_2 = L24_1
  L9_2 = L5_2
  L8_2 = L8_2(L9_2)
  L7_2.author = L8_2
  L6_2.data = L7_2
  L7_2 = A0_2.cid
  L6_2.assignee = L7_2
  L7_2 = L24_1
  L8_2 = L5_2
  L7_2 = L7_2(L8_2)
  L6_2.assignee_name = L7_2
  return L6_2
end
L106_1.post = L107_1
function L107_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2, L19_2, L20_2, L21_2, L22_2
  L2_2 = A0_2.mod
  L2_2 = L2_2.options
  L3_2 = L2_2.orderable
  if false == L3_2 then
    L3_2 = {}
    L3_2.error = "module"
    return L3_2
  end
  L3_2 = L12_1
  L4_2 = L2_2.maxQty
  L5_2 = 1
  L6_2 = 99
  L7_2 = 10
  L3_2 = L3_2(L4_2, L5_2, L6_2, L7_2)
  L4_2 = {}
  L5_2 = ipairs
  L6_2 = L17_1
  L7_2 = L2_2.items
  L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2, L19_2, L20_2, L21_2, L22_2 = L6_2(L7_2)
  L5_2, L6_2, L7_2, L8_2 = L5_2(L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2, L19_2, L20_2, L21_2, L22_2)
  for L9_2, L10_2 in L5_2, L6_2, L7_2, L8_2 do
    L11_2 = type
    L12_2 = L10_2
    L11_2 = L11_2(L12_2)
    if "table" == L11_2 then
      L11_2 = type
      L12_2 = L10_2.id
      L11_2 = L11_2(L12_2)
      if "string" == L11_2 then
        L11_2 = L10_2.id
        L4_2[L11_2] = L10_2
      end
    end
  end
  L5_2 = {}
  L6_2 = {}
  L7_2 = 0
  L8_2 = 0
  L9_2 = ipairs
  L10_2 = L17_1
  L11_2 = A1_2.lines
  L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2, L19_2, L20_2, L21_2, L22_2 = L10_2(L11_2)
  L9_2, L10_2, L11_2, L12_2 = L9_2(L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2, L19_2, L20_2, L21_2, L22_2)
  for L13_2, L14_2 in L9_2, L10_2, L11_2, L12_2 do
    L15_2 = type
    L16_2 = L14_2
    L15_2 = L15_2(L16_2)
    if "table" == L15_2 then
      L15_2 = type
      L16_2 = L14_2.id
      L15_2 = L15_2(L16_2)
      if "string" == L15_2 then
        L15_2 = L14_2.id
        L15_2 = L6_2[L15_2]
        if not L15_2 then
          L15_2 = L14_2.id
          L15_2 = L4_2[L15_2]
          if L15_2 then
            L16_2 = L15_2.available
            if false ~= L16_2 then
              goto lbl_78
            end
          end
          L16_2 = {}
          L16_2.error = "unavailable"
          L17_2 = L14_2.id
          L16_2.item = L17_2
          do return L16_2 end
          ::lbl_78::
          L16_2 = math
          L16_2 = L16_2.tointeger
          L17_2 = tonumber
          L18_2 = L14_2.qty
          L17_2, L18_2, L19_2, L20_2, L21_2, L22_2 = L17_2(L18_2)
          L16_2 = L16_2(L17_2, L18_2, L19_2, L20_2, L21_2, L22_2)
          if not L16_2 or L16_2 < 1 or L3_2 < L16_2 then
            L17_2 = {}
            L17_2.error = "qty"
            L17_2.max = L3_2
            return L17_2
          end
          L17_2 = L14_1
          L18_2 = L15_2.price
          L17_2 = L17_2(L18_2)
          if not L17_2 then
            L17_2 = 0
          end
          L18_2 = L14_2.id
          L6_2[L18_2] = true
          L18_2 = #L5_2
          L18_2 = L18_2 + 1
          L19_2 = {}
          L20_2 = L15_2.id
          L19_2.id = L20_2
          L20_2 = L11_1
          L21_2 = L15_2.label
          L22_2 = 60
          L20_2 = L20_2(L21_2, L22_2)
          if not L20_2 then
            L20_2 = L15_2.id
          end
          L19_2.label = L20_2
          L19_2.price = L17_2
          L19_2.qty = L16_2
          L5_2[L18_2] = L19_2
          L18_2 = L17_2 * L16_2
          L7_2 = L7_2 + L18_2
          L8_2 = L8_2 + L16_2
          L18_2 = #L5_2
          if L18_2 >= 30 then
            break
          end
        end
      end
    end
  end
  L9_2 = #L5_2
  if 0 == L9_2 then
    L9_2 = {}
    L9_2.error = "empty"
    return L9_2
  end
  L9_2 = L81_1
  L10_2 = L2_2.fields
  L11_2 = A1_2.fields
  L9_2, L10_2, L11_2 = L9_2(L10_2, L11_2)
  if not L9_2 then
    L12_2 = {}
    L12_2.error = L10_2
    L12_2.field = L11_2
    return L12_2
  end
  L12_2 = L2_2.location
  if true == L12_2 then
    L12_2 = A1_2.location
    if true == L12_2 then
      L12_2 = L26_1
      L13_2 = A0_2.src
      L14_2 = A1_2.coords
      L12_2 = L12_2(L13_2, L14_2)
      if L12_2 then
        goto lbl_164
      end
    end
  end
  L12_2 = nil
  ::lbl_164::
  L13_2 = A0_2.acc
  L13_2 = L13_2.p
  L14_2 = L11_1
  L15_2 = L2_2.currency
  L16_2 = 4
  L14_2 = L14_2(L15_2, L16_2)
  if not L14_2 then
    L14_2 = Config
    L14_2 = L14_2.Currency
    if L14_2 then
      L14_2 = Config
      L14_2 = L14_2.Currency
      L14_2 = L14_2.symbol
      if L14_2 then
        goto lbl_182
      end
    end
    L14_2 = "$"
  end
  ::lbl_182::
  L15_2 = math
  L15_2 = L15_2.floor
  L16_2 = L7_2 * 100
  L16_2 = L16_2 + 0.5
  L15_2 = L15_2(L16_2)
  L7_2 = L15_2 / 100
  L15_2 = {}
  L16_2 = L43_1
  L17_2 = A0_2.mod
  L16_2 = L16_2(L17_2)
  L16_2 = L16_2[1]
  L16_2 = L16_2.id
  L15_2.status = L16_2
  L16_2 = L5_2[1]
  L16_2 = L16_2.label
  L17_2 = #L5_2
  if L17_2 > 1 then
    L17_2 = " +"
    L18_2 = #L5_2
    L18_2 = L18_2 - 1
    L17_2 = L17_2 .. L18_2
    if L17_2 then
      goto lbl_212
    end
  end
  L17_2 = ""
  ::lbl_212::
  L16_2 = L16_2 .. L17_2
  L15_2.title = L16_2
  L16_2 = {}
  L16_2.lines = L5_2
  L16_2.total = L7_2
  L16_2.count = L8_2
  L16_2.currency = L14_2
  L17_2 = L9_2.fields
  L16_2.fields = L17_2
  L17_2 = L9_2.order
  L16_2.order = L17_2
  L15_2.data = L16_2
  L16_2 = L24_1
  L17_2 = L13_2
  L16_2 = L16_2(L17_2)
  L15_2.owner_name = L16_2
  L16_2 = GetPlayerNumber
  L17_2 = A0_2.src
  L16_2 = L16_2(L17_2)
  if not L16_2 then
    L16_2 = L13_2.phone
  end
  L15_2.owner_phone = L16_2
  L16_2 = L12_2 or L16_2
  if L12_2 then
    L16_2 = L12_2.x
  end
  L15_2.x = L16_2
  L16_2 = L12_2 or L16_2
  if L12_2 then
    L16_2 = L12_2.y
  end
  L15_2.y = L16_2
  L16_2 = L12_2 or L16_2
  if L12_2 then
    L16_2 = L12_2.z
  end
  L15_2.z = L16_2
  return L15_2
end
L106_1.order = L107_1
function L107_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2
  L2_2 = A0_2.mod
  L2_2 = L2_2.options
  L3_2 = L13_1
  L4_2 = A1_2.amount
  L3_2 = L3_2(L4_2)
  if L3_2 then
    L4_2 = tonumber
    L5_2 = A1_2.amount
    L4_2 = L4_2(L5_2)
    if L4_2 == L3_2 then
      goto lbl_17
    end
  end
  L4_2 = {}
  L4_2.error = "amount"
  do return L4_2 end
  ::lbl_17::
  L4_2 = L11_1
  L5_2 = A1_2.reason
  L6_2 = 160
  L4_2 = L4_2(L5_2, L6_2)
  L5_2 = L2_2.reasonRequired
  if false ~= L5_2 and not L4_2 then
    L5_2 = {}
    L5_2.error = "reason"
    return L5_2
  end
  L5_2 = nil
  L6_2 = nil
  L7_2 = nil
  L8_2 = math
  L8_2 = L8_2.tointeger
  L9_2 = tonumber
  L10_2 = A1_2.target
  L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2 = L9_2(L10_2)
  L8_2 = L8_2(L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2)
  if L8_2 then
    L9_2 = A0_2.src
    if L8_2 == L9_2 then
      L9_2 = {}
      L9_2.error = "self"
      return L9_2
    end
    L9_2 = FW
    L9_2 = L9_2.GetPlayer
    L10_2 = L8_2
    L9_2 = L9_2(L10_2)
    if L9_2 then
      L10_2 = L9_2.cid
      if L10_2 then
        goto lbl_59
      end
    end
    L10_2 = {}
    L10_2.error = "target"
    do return L10_2 end
    ::lbl_59::
    L10_2 = L25_1
    L11_2 = A0_2.src
    L10_2 = L10_2(L11_2)
    L11_2 = L25_1
    L12_2 = L8_2
    L11_2 = L11_2(L12_2)
    if L10_2 and L11_2 then
      L12_2 = L10_2.x
      L13_2 = L11_2.x
      L12_2 = L12_2 - L13_2
      L13_2 = L10_2.y
      L14_2 = L11_2.y
      L13_2 = L13_2 - L14_2
      L14_2 = L10_2.z
      L15_2 = L11_2.z
      L14_2 = L14_2 - L15_2
      L15_2 = L12_2 * L12_2
      L16_2 = L13_2 * L13_2
      L15_2 = L15_2 + L16_2
      L16_2 = L14_2 * L14_2
      L15_2 = L15_2 + L16_2
      L16_2 = 144
      if L15_2 > L16_2 then
        L15_2 = {}
        L15_2.error = "far"
        return L15_2
      end
    end
    L12_2 = L9_2.cid
    L13_2 = GetPlayerNumber
    L14_2 = L8_2
    L13_2 = L13_2(L14_2)
    if not L13_2 then
      L13_2 = L9_2.phone
    end
    L14_2 = L24_1
    L15_2 = L9_2
    L14_2 = L14_2(L15_2)
    L7_2 = L14_2
    L6_2 = L13_2
    L5_2 = L12_2
  else
    L9_2 = L11_1
    L10_2 = A1_2.to
    L11_2 = 20
    L9_2 = L9_2(L10_2, L11_2)
    if not L9_2 then
      L10_2 = {}
      L10_2.error = "target"
      return L10_2
    end
    L10_2 = CanonNumber
    if L10_2 then
      L10_2 = CanonNumber
      L11_2 = L9_2
      L10_2 = L10_2(L11_2)
      if L10_2 then
        goto lbl_131
        L6_2 = L10_2 or L6_2
      end
    end
    L6_2 = L9_2
    ::lbl_131::
    L10_2 = GetCitizenIdByNumber
    if L10_2 then
      L10_2 = GetCitizenIdByNumber
      L11_2 = L6_2
      L10_2 = L10_2(L11_2)
      if L10_2 then
        goto lbl_140
        L5_2 = L10_2 or L5_2
      end
    end
    L5_2 = nil
    ::lbl_140::
    if not L5_2 then
      L10_2 = {}
      L10_2.error = "phone"
      return L10_2
    end
    L10_2 = FW
    L10_2 = L10_2.GetPlayerByCid
    L11_2 = L5_2
    L10_2 = L10_2(L11_2)
    if L10_2 then
      L11_2 = L24_1
      L12_2 = L10_2
      L11_2 = L11_2(L12_2)
      if L11_2 then
        goto lbl_158
        L7_2 = L11_2 or L7_2
      end
    end
    L7_2 = nil
  end
  ::lbl_158::
  L9_2 = L99_1
  L10_2 = A0_2
  L11_2 = L5_2
  L12_2 = L3_2
  L13_2 = L4_2
  L14_2 = L2_2.society
  L14_2 = false ~= L14_2
  L15_2 = L2_2.maxAmount
  L9_2 = L9_2(L10_2, L11_2, L12_2, L13_2, L14_2, L15_2)
  L10_2 = L9_2.error
  if L10_2 then
    return L9_2
  end
  L10_2 = A0_2.acc
  L10_2 = L10_2.p
  L11_2 = {}
  L11_2.status = "pending"
  L12_2 = L4_2 or L12_2
  if not L4_2 then
    L12_2 = L15_1
    L13_2 = L3_2
    L12_2 = L12_2(L13_2)
  end
  L11_2.title = L12_2
  L11_2.owner = L5_2
  L11_2.owner_name = L7_2
  L11_2.owner_phone = L6_2
  L12_2 = A0_2.cid
  L11_2.assignee = L12_2
  L12_2 = L24_1
  L13_2 = L10_2
  L12_2 = L12_2(L13_2)
  L11_2.assignee_name = L12_2
  L12_2 = {}
  L13_2 = tonumber
  L14_2 = L9_2.id
  L13_2 = L13_2(L14_2)
  L12_2.billId = L13_2
  L12_2.amount = L3_2
  L12_2.reason = L4_2
  L12_2.to = L6_2
  L13_2 = L9_2.society
  L12_2.society = L13_2
  L11_2.data = L12_2
  return L11_2
end
L106_1.bill = L107_1
L107_1 = {}
L107_1.form = true
L107_1.appt = true
L107_1.call = true
L107_1.order = true
L108_1 = {}
L108_1.record = true
L108_1.post = true
L108_1.bill = true
L109_1 = RPC
function L110_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2, L19_2, L20_2, L21_2, L22_2, L23_2, L24_2, L25_2, L26_2, L27_2, L28_2, L29_2, L30_2
  L2_2 = L40_1
  L3_2 = A0_2
  L4_2 = A1_2.app
  L5_2 = A1_2.module
  L6_2 = A1_2.side
  L2_2, L3_2 = L2_2(L3_2, L4_2, L5_2, L6_2)
  if not L2_2 then
    L4_2 = {}
    L4_2.error = L3_2
    return L4_2
  end
  L4_2 = L2_2.kind
  if L4_2 then
    L5_2 = L106_1
    L5_2 = L5_2[L4_2]
    if L5_2 then
      goto lbl_24
    end
  end
  L5_2 = {}
  L5_2.error = "module"
  do return L5_2 end
  ::lbl_24::
  L5_2 = L108_1
  L5_2 = L5_2[L4_2]
  if L5_2 then
    L5_2 = "staff"
    if L5_2 then
      goto lbl_32
    end
  end
  L5_2 = "civil"
  ::lbl_32::
  L6_2 = L2_2.side
  if L6_2 ~= L5_2 then
    L6_2 = {}
    L6_2.error = "forbidden"
    return L6_2
  end
  if "staff" == L5_2 then
    L6_2 = L39_1
    L7_2 = L2_2
    L8_2 = "create"
    L6_2 = L6_2(L7_2, L8_2)
    if not L6_2 then
      L6_2 = {}
      L6_2.error = "grade"
      L7_2 = L35_1
      L8_2 = L2_2.mod
      L9_2 = "create"
      L7_2 = L7_2(L8_2, L9_2)
      L6_2.need = L7_2
      return L6_2
    end
  end
  L6_2 = L2_2.cid
  L7_2 = "|"
  L8_2 = L2_2.def
  L8_2 = L8_2.id
  L9_2 = "|"
  L10_2 = L2_2.mod
  L10_2 = L10_2.id
  L6_2 = L6_2 .. L7_2 .. L8_2 .. L9_2 .. L10_2
  if "record" == L4_2 or "bill" == L4_2 then
    L7_2 = 2
    if L7_2 then
      goto lbl_72
    end
  end
  L7_2 = L101_1
  ::lbl_72::
  L8_2 = L88_1
  L9_2 = L83_1
  L10_2 = L6_2
  L11_2 = L7_2
  L8_2 = L8_2(L9_2, L10_2, L11_2)
  if L8_2 > 0 then
    L9_2 = {}
    L9_2.error = "cooldown"
    L9_2.wait = L8_2
    return L9_2
  end
  if "form" == L4_2 or "appt" == L4_2 or "order" == L4_2 then
    L9_2 = L104_1
    L10_2 = L2_2
    L9_2 = L9_2(L10_2)
    L10_2 = L102_1
    if L9_2 >= L10_2 then
      L9_2 = {}
      L9_2.error = "toomany"
      L10_2 = L102_1
      L9_2.max = L10_2
      return L9_2
    end
  end
  L9_2 = L106_1
  L9_2 = L9_2[L4_2]
  L10_2 = L2_2
  L11_2 = A1_2
  L9_2 = L9_2(L10_2, L11_2)
  L10_2 = L9_2.error
  if L10_2 then
    return L9_2
  end
  L10_2 = L2_2.def
  L10_2 = L10_2.id
  L11_2 = L2_2.mod
  L11_2 = L11_2.id
  L9_2.kind = L4_2
  L9_2.module = L11_2
  L9_2.app = L10_2
  L10_2 = L9_2.owner
  if nil == L10_2 and "civil" == L5_2 then
    L10_2 = L2_2.cid
    L9_2.owner = L10_2
  end
  L10_2 = L103_1
  L11_2 = L9_2
  L10_2 = L10_2(L11_2)
  if not L10_2 then
    L11_2 = {}
    L11_2.error = "db"
    return L11_2
  end
  L11_2 = L83_1
  L12_2 = os
  L12_2 = L12_2.time
  L12_2 = L12_2()
  L11_2[L6_2] = L12_2
  L11_2 = L56_1
  L12_2 = L10_2
  L11_2 = L11_2(L12_2)
  L12_2 = L2_2.def
  L13_2 = L2_2.mod
  L14_2 = nil
  L15_2 = {}
  L16_2 = L12_2.id
  L15_2.capp = L16_2
  L16_2 = L13_2.id
  L15_2.module = L16_2
  L15_2.id = L10_2
  L16_2 = tostring
  L17_2 = L12_2.name
  L16_2 = L16_2(L17_2)
  L17_2 = " \194\183 "
  L18_2 = tostring
  L19_2 = L13_2.title
  if not L19_2 then
    L19_2 = L13_2.id
  end
  L18_2 = L18_2(L19_2)
  L16_2 = L16_2 .. L17_2 .. L18_2
  L17_2 = L107_1
  L17_2 = L17_2[L4_2]
  if L17_2 then
    L17_2 = L22_1
    L18_2 = L11_2.data
    L17_2 = L17_2(L18_2)
    if not L17_2 then
      L17_2 = {}
    end
    if "call" == L4_2 then
      L18_2 = L17_2.message
      if L18_2 then
        L18_2 = L11_2.title
        L19_2 = ": "
        L20_2 = L17_2.message
        L18_2 = L18_2 .. L19_2 .. L20_2
        if L18_2 then
          goto lbl_186
        end
      end
      L18_2 = L11_2.title
      ::lbl_186::
      L19_2 = L66_1
      L20_2 = L12_2
      L21_2 = L13_2
      L22_2 = L16_2
      L23_2 = L18_2
      L24_2 = L15_2
      L25_2 = true
      L19_2 = L19_2(L20_2, L21_2, L22_2, L23_2, L24_2, L25_2)
      if 0 == L19_2 then
        L20_2 = L67_1
        L21_2 = L12_2
        L22_2 = L13_2
        L23_2 = true
        L20_2 = L20_2(L21_2, L22_2, L23_2)
        if 0 == L20_2 then
          L14_2 = true
        end
      end
    elseif "appt" == L4_2 then
      L18_2 = L66_1
      L19_2 = L12_2
      L20_2 = L13_2
      L21_2 = L16_2
      L22_2 = L11_2.title
      if not L22_2 then
        L22_2 = ""
      end
      L23_2 = " \194\183 "
      L24_2 = tostring
      L25_2 = L17_2.day
      if not L25_2 then
        L25_2 = ""
      end
      L24_2 = L24_2(L25_2)
      L25_2 = " "
      L26_2 = tostring
      L27_2 = L17_2.time
      if not L27_2 then
        L27_2 = ""
      end
      L26_2 = L26_2(L27_2)
      L22_2 = L22_2 .. L23_2 .. L24_2 .. L25_2 .. L26_2
      L23_2 = L15_2
      L24_2 = L12_2.audience
      L24_2 = L24_2.onDutyOnly
      L24_2 = true == L24_2
      L18_2(L19_2, L20_2, L21_2, L22_2, L23_2, L24_2)
    elseif "order" == L4_2 then
      L18_2 = L66_1
      L19_2 = L12_2
      L20_2 = L13_2
      L21_2 = L16_2
      L22_2 = L11_2.title
      if not L22_2 then
        L22_2 = ""
      end
      L23_2 = " \194\183 "
      L24_2 = L15_1
      L25_2 = L17_2.total
      L26_2 = L17_2.currency
      L24_2 = L24_2(L25_2, L26_2)
      L22_2 = L22_2 .. L23_2 .. L24_2
      L23_2 = L15_2
      L24_2 = L12_2.audience
      L24_2 = L24_2.onDutyOnly
      L24_2 = true == L24_2
      L18_2 = L18_2(L19_2, L20_2, L21_2, L22_2, L23_2, L24_2)
      if 0 == L18_2 then
        L19_2 = L67_1
        L20_2 = L12_2
        L21_2 = L13_2
        L22_2 = false
        L19_2 = L19_2(L20_2, L21_2, L22_2)
        if 0 == L19_2 then
          L14_2 = true
        end
      end
    else
      L18_2 = L66_1
      L19_2 = L12_2
      L20_2 = L13_2
      L21_2 = L16_2
      L22_2 = tonumber
      L23_2 = L11_2.anonymous
      L22_2 = L22_2(L23_2)
      if 1 == L22_2 then
        L22_2 = "An\195\179nimo: "
        L23_2 = L11_2.title
        L22_2 = L22_2 .. L23_2
        if L22_2 then
          goto lbl_289
        end
      end
      L22_2 = L11_2.title
      ::lbl_289::
      L23_2 = L15_2
      L24_2 = L12_2.audience
      L24_2 = L24_2.onDutyOnly
      L24_2 = true == L24_2
      L18_2(L19_2, L20_2, L21_2, L22_2, L23_2, L24_2)
    end
    L18_2 = L72_1
    L19_2 = L12_2
    L20_2 = "item.created"
    L21_2 = L13_2
    L22_2 = L11_2
    L18_2(L19_2, L20_2, L21_2, L22_2)
  elseif "record" == L4_2 then
    L17_2 = L72_1
    L18_2 = L12_2
    L19_2 = "record.created"
    L20_2 = L13_2
    L21_2 = L11_2
    L17_2(L18_2, L19_2, L20_2, L21_2)
  elseif "bill" == L4_2 then
    L17_2 = L72_1
    L18_2 = L12_2
    L19_2 = "bill.created"
    L20_2 = L13_2
    L21_2 = L11_2
    L22_2 = {}
    L23_2 = L24_1
    L24_2 = L2_2.acc
    L24_2 = L24_2.p
    L23_2 = L23_2(L24_2)
    L22_2.by = L23_2
    L17_2(L18_2, L19_2, L20_2, L21_2, L22_2)
  elseif "post" == L4_2 then
    L17_2 = L72_1
    L18_2 = L12_2
    L19_2 = "post.created"
    L20_2 = L13_2
    L21_2 = L11_2
    L17_2(L18_2, L19_2, L20_2, L21_2)
    L17_2 = L13_2.options
    L17_2 = L17_2.notifyAll
    if true == L17_2 then
      L17_2 = L13_2.options
      L17_2 = L17_2.audience
      L17_2 = "staff" == L17_2
      L18_2 = 0
      L19_2 = ipairs
      L20_2 = L63_1
      L21_2 = L12_2
      L20_2, L21_2, L22_2, L23_2, L24_2, L25_2, L26_2, L27_2, L28_2, L29_2, L30_2 = L20_2(L21_2)
      L19_2, L20_2, L21_2, L22_2 = L19_2(L20_2, L21_2, L22_2, L23_2, L24_2, L25_2, L26_2, L27_2, L28_2, L29_2, L30_2)
      for L23_2, L24_2 in L19_2, L20_2, L21_2, L22_2 do
        L25_2 = L24_2.src
        if L25_2 ~= A0_2 then
local jf375 = false
          if L17_2 then
            L25_2 = L37_1
            L26_2 = L24_2.acc
            L27_2 = L13_2
            L25_2 = L25_2(L26_2, L27_2)
            if L25_2 then
              jf375 = true
            end
          end
          if jf375 or not L17_2 then
if not jf375 then
            L25_2 = L24_2.acc
            L25_2 = L25_2.member
            if not L25_2 then
              L25_2 = L24_2.acc
              L25_2 = L25_2.civil
              if not L25_2 then
                goto lbl_391
              end
            end
end
            L25_2 = NotifyPlayer
            L26_2 = L24_2.src
            L27_2 = "capp_"
            L28_2 = L12_2.id
            L27_2 = L27_2 .. L28_2
            L28_2 = tostring
            L29_2 = L12_2.name
            L28_2 = L28_2(L29_2)
            L29_2 = L11_2.title
            L30_2 = L15_2
            L25_2(L26_2, L27_2, L28_2, L29_2, L30_2)
            L18_2 = L18_2 + 1
            L25_2 = 256
            if L18_2 >= L25_2 then
              break
            end
          end
        end
        ::lbl_391::
      end
    end
  end
  L17_2 = L65_1
  L18_2 = L12_2
  L19_2 = L13_2
  L20_2 = L11_2
  L17_2(L18_2, L19_2, L20_2)
  L17_2 = {}
  L17_2.ok = true
  L17_2.id = L10_2
  L18_2 = L61_1
  L19_2 = L11_2
  L20_2 = L2_2
  L21_2 = true
  L18_2 = L18_2(L19_2, L20_2, L21_2)
  L17_2.item = L18_2
  L17_2.nobody = L14_2
  return L17_2
end
L109_1["capps.create"] = L110_1
L109_1 = RPC
function L110_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2, L19_2, L20_2
  L2_2 = L96_1
  L3_2 = A0_2
  L4_2 = A1_2
  L2_2, L3_2, L4_2 = L2_2(L3_2, L4_2)
  if not L2_2 then
    L5_2 = {}
    L5_2.error = L3_2
    return L5_2
  end
  L5_2 = L2_2.side
  if "staff" ~= L5_2 then
    L5_2 = {}
    L5_2.error = "forbidden"
    return L5_2
  end
  L5_2 = L2_2.mod
  L5_2 = L5_2.options
  L6_2 = L22_1
  L7_2 = L4_2.data
  L6_2 = L6_2(L7_2)
  if not L6_2 then
    L6_2 = {}
  end
  L7_2 = {}
  L8_2 = {}
  L9_2 = L4_2.kind
  if "record" == L9_2 then
    L9_2 = L39_1
    L10_2 = L2_2
    L11_2 = "create"
    L9_2 = L9_2(L10_2, L11_2)
    if not L9_2 then
      L9_2 = {}
      L9_2.error = "grade"
      L10_2 = L35_1
      L11_2 = L2_2.mod
      L12_2 = "create"
      L10_2 = L10_2(L11_2, L12_2)
      L9_2.need = L10_2
      return L9_2
    end
    L9_2 = A1_2.fields
    if nil ~= L9_2 then
      L9_2 = L81_1
      L10_2 = L5_2.fields
      L11_2 = A1_2.fields
      L9_2, L10_2, L11_2 = L9_2(L10_2, L11_2)
      if not L9_2 then
        L12_2 = {}
        L12_2.error = L10_2
        L12_2.field = L11_2
        return L12_2
      end
      L12_2 = L9_2.fields
      L13_2 = L9_2.order
      L6_2.order = L13_2
      L6_2.fields = L12_2
    end
    L9_2 = A1_2.tags
    if nil ~= L9_2 then
      L9_2 = {}
      L10_2 = {}
      L11_2 = ipairs
      L12_2 = L17_1
      L13_2 = L5_2.tags
      L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2, L19_2, L20_2 = L12_2(L13_2)
      L11_2, L12_2, L13_2, L14_2 = L11_2(L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2, L19_2, L20_2)
      for L15_2, L16_2 in L11_2, L12_2, L13_2, L14_2 do
        L17_2 = type
        L18_2 = L16_2
        L17_2 = L17_2(L18_2)
        if "table" == L17_2 then
          L17_2 = type
          L18_2 = L16_2.id
          L17_2 = L17_2(L18_2)
          if "string" == L17_2 then
            L17_2 = L16_2.id
            L9_2[L17_2] = true
          end
        end
      end
      L11_2 = ipairs
      L12_2 = L17_1
      L13_2 = A1_2.tags
      L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2, L19_2, L20_2 = L12_2(L13_2)
      L11_2, L12_2, L13_2, L14_2 = L11_2(L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2, L19_2, L20_2)
      for L15_2, L16_2 in L11_2, L12_2, L13_2, L14_2 do
        L17_2 = L9_2[L16_2]
        if L17_2 then
          L17_2 = #L10_2
          if L17_2 < 12 then
            L17_2 = #L10_2
            L17_2 = L17_2 + 1
            L10_2[L17_2] = L16_2
          end
        end
      end
      L6_2.tags = L10_2
    end
    L9_2 = A1_2.subject
    if nil ~= L9_2 then
      L9_2 = L11_1
      L10_2 = A1_2.subject
      L11_2 = 100
      L9_2 = L9_2(L10_2, L11_2)
      if not L9_2 then
        L10_2 = {}
        L10_2.error = "subject"
        return L10_2
      end
      L10_2 = L5_2.subject
      if "vehicle" == L10_2 then
        L11_2 = L9_2
        L10_2 = L9_2.upper
        L10_2 = L10_2(L11_2)
        L9_2 = L10_2
      end
      L10_2 = #L7_2
      L10_2 = L10_2 + 1
      L7_2[L10_2] = "subject = ?"
      L10_2 = #L8_2
      L10_2 = L10_2 + 1
      L8_2[L10_2] = L9_2
      L10_2 = #L7_2
      L10_2 = L10_2 + 1
      L7_2[L10_2] = "title = ?"
      L10_2 = #L8_2
      L10_2 = L10_2 + 1
      L8_2[L10_2] = L9_2
    end
  else
    L9_2 = L4_2.kind
    if "post" == L9_2 then
      L9_2 = L39_1
      L10_2 = L2_2
      L11_2 = "create"
      L9_2 = L9_2(L10_2, L11_2)
      if not L9_2 then
        L9_2 = {}
        L9_2.error = "grade"
        L10_2 = L35_1
        L11_2 = L2_2.mod
        L12_2 = "create"
        L10_2 = L10_2(L11_2, L12_2)
        L9_2.need = L10_2
        return L9_2
      end
      L9_2 = A1_2.title
      if nil ~= L9_2 then
        L9_2 = L11_1
        L10_2 = A1_2.title
        L11_2 = 120
        L9_2 = L9_2(L10_2, L11_2)
        if not L9_2 then
          L10_2 = {}
          L10_2.error = "empty"
          return L10_2
        end
        L10_2 = #L7_2
        L10_2 = L10_2 + 1
        L7_2[L10_2] = "title = ?"
        L10_2 = #L8_2
        L10_2 = L10_2 + 1
        L8_2[L10_2] = L9_2
      end
      L9_2 = A1_2.body
      if nil ~= L9_2 then
        L9_2 = L11_1
        L10_2 = A1_2.body
        L11_2 = 2000
        L12_2 = true
        L9_2 = L9_2(L10_2, L11_2, L12_2)
        if not L9_2 then
          L10_2 = {}
          L10_2.error = "empty"
          return L10_2
        end
        L6_2.body = L9_2
      end
      L9_2 = A1_2.image
      if nil ~= L9_2 then
        L9_2 = A1_2.image
        if "" ~= L9_2 then
          L9_2 = A1_2.image
          if false ~= L9_2 then
            goto lbl_216
          end
        end
        L6_2.image = nil
        goto lbl_226
        ::lbl_216::
        L9_2 = L19_1
        L10_2 = A1_2.image
        L9_2 = L9_2(L10_2)
        if not L9_2 then
          L10_2 = {}
          L10_2.error = "photo"
          return L10_2
        end
        L6_2.image = L9_2
      end
      ::lbl_226::
      L9_2 = A1_2.pinned
      if nil == L9_2 then
        goto lbl_371
      end
      L9_2 = A1_2.pinned
      if true == L9_2 then
        L9_2 = tonumber
        L10_2 = L4_2.pinned
        L9_2 = L9_2(L10_2)
        if 1 ~= L9_2 then
          L9_2 = L105_1
          L10_2 = L2_2
          L11_2 = tonumber
          L12_2 = L4_2.id
          L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2, L19_2, L20_2 = L11_2(L12_2)
          L9_2, L10_2 = L9_2(L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2, L19_2, L20_2)
          if L9_2 then
            L11_2 = {}
            L11_2.error = "pinlimit"
            L11_2.max = L10_2
            return L11_2
          end
        end
      end
      L9_2 = #L7_2
      L9_2 = L9_2 + 1
      L7_2[L9_2] = "pinned = ?"
      L9_2 = #L8_2
      L9_2 = L9_2 + 1
      L10_2 = A1_2.pinned
      if true == L10_2 then
        L10_2 = 1
        if L10_2 then
          goto lbl_264
        end
      end
      L10_2 = 0
      ::lbl_264::
      L8_2[L9_2] = L10_2
    else
      L9_2 = L4_2.kind
      if "appt" == L9_2 then
        L9_2 = L39_1
        L10_2 = L2_2
        L11_2 = "status"
        L9_2 = L9_2(L10_2, L11_2)
        if not L9_2 then
          L9_2 = {}
          L9_2.error = "grade"
          L10_2 = L35_1
          L11_2 = L2_2.mod
          L12_2 = "status"
          L10_2 = L10_2(L11_2, L12_2)
          L9_2.need = L10_2
          return L9_2
        end
        L9_2 = L11_1
        L10_2 = A1_2.day
        L11_2 = 10
        L9_2 = L9_2(L10_2, L11_2)
        L10_2 = L11_1
        L11_2 = A1_2.time
        L12_2 = 5
        L10_2 = L10_2(L11_2, L12_2)
        if not L9_2 or not L10_2 then
          L11_2 = {}
          L11_2.error = "slot"
          return L11_2
        end
        L11_2 = L89_1
        L12_2 = L2_2.mod
        L11_2 = L11_2(L12_2)
        L12_2 = nil
        L13_2 = ipairs
        L14_2 = L94_1
        L15_2 = L2_2.def
        L16_2 = L2_2.mod
        L17_2 = L11_2
        L18_2 = L9_2
        L14_2, L15_2, L16_2, L17_2, L18_2, L19_2, L20_2 = L14_2(L15_2, L16_2, L17_2, L18_2)
        L13_2, L14_2, L15_2, L16_2 = L13_2(L14_2, L15_2, L16_2, L17_2, L18_2, L19_2, L20_2)
        for L17_2, L18_2 in L13_2, L14_2, L15_2, L16_2 do
          L19_2 = L18_2.time
          if L19_2 == L10_2 then
            L12_2 = L18_2
          end
        end
        if not L12_2 then
          L13_2 = {}
          L13_2.error = "slot"
          return L13_2
        end
        L13_2 = L12_2.free
        if L13_2 <= 0 then
          L13_2 = L6_2.day
          if L13_2 == L9_2 then
            L13_2 = L6_2.time
            if L13_2 == L10_2 then
              goto lbl_339
            end
          end
          L13_2 = {}
          L13_2.error = "full"
          return L13_2
        end
        ::lbl_339::
        L14_2 = L10_2
        L13_2 = L10_2.match
        L15_2 = "^(%d%d):(%d%d)$"
        L13_2, L14_2 = L13_2(L14_2, L15_2)
        L15_2 = L9_2
        L6_2.time = L10_2
        L6_2.day = L15_2
        L15_2 = #L7_2
        L15_2 = L15_2 + 1
        L7_2[L15_2] = "at = ?"
        L15_2 = #L8_2
        L15_2 = L15_2 + 1
        L16_2 = L93_1
        L17_2 = L9_2
        L18_2 = tonumber
        L19_2 = L13_2
        L18_2 = L18_2(L19_2)
        L18_2 = L18_2 * 60
        L19_2 = tonumber
        L20_2 = L14_2
        L19_2 = L19_2(L20_2)
        L18_2 = L18_2 + L19_2
        L16_2 = L16_2(L17_2, L18_2)
        L8_2[L15_2] = L16_2
      else
        L9_2 = {}
        L9_2.error = "forbidden"
        return L9_2
      end
    end
  end
  ::lbl_371::
  L9_2 = L21_1
  L10_2 = L6_2
  L9_2 = L9_2(L10_2)
  if L9_2 then
    L10_2 = #L9_2
    L11_2 = 60000
    if not (L10_2 > L11_2) then
      goto lbl_384
    end
  end
  L10_2 = {}
  L10_2.error = "toolarge"
  do return L10_2 end
  ::lbl_384::
  L10_2 = #L7_2
  L10_2 = L10_2 + 1
  L7_2[L10_2] = "data = ?"
  L10_2 = #L8_2
  L10_2 = L10_2 + 1
  L8_2[L10_2] = L9_2
  L10_2 = #L7_2
  L10_2 = L10_2 + 1
  L7_2[L10_2] = "updated = ?"
  L10_2 = #L8_2
  L10_2 = L10_2 + 1
  L11_2 = Now
  L11_2 = L11_2()
  L8_2[L10_2] = L11_2
  L10_2 = #L8_2
  L10_2 = L10_2 + 1
  L11_2 = tonumber
  L12_2 = L4_2.id
  L11_2 = L11_2(L12_2)
  L8_2[L10_2] = L11_2
  L10_2 = MySQL
  L10_2 = L10_2.update
  L10_2 = L10_2.await
  L11_2 = "UPDATE apex_phone_capp_items SET "
  L12_2 = table
  L12_2 = L12_2.concat
  L13_2 = L7_2
  L14_2 = ", "
  L12_2 = L12_2(L13_2, L14_2)
  L13_2 = " WHERE id = ?"
  L11_2 = L11_2 .. L12_2 .. L13_2
  L12_2 = L8_2
  L10_2(L11_2, L12_2)
  L10_2 = L56_1
  L11_2 = L4_2.id
  L10_2 = L10_2(L11_2)
  L4_2 = L10_2
  L10_2 = L4_2.kind
  if "record" == L10_2 then
    L10_2 = L72_1
    L11_2 = L2_2.def
    L12_2 = "record.updated"
    L13_2 = L2_2.mod
    L14_2 = L4_2
    L15_2 = {}
    L16_2 = L24_1
    L17_2 = L2_2.acc
    L17_2 = L17_2.p
    L16_2 = L16_2(L17_2)
    L15_2.by = L16_2
    L10_2(L11_2, L12_2, L13_2, L14_2, L15_2)
  end
  L10_2 = L4_2.kind
  if "appt" == L10_2 then
    L10_2 = L68_1
    L11_2 = L2_2.def
    L12_2 = L4_2
    L13_2 = tostring
    L14_2 = L2_2.def
    L14_2 = L14_2.name
    L13_2 = L13_2(L14_2)
    L14_2 = "A tua marca\195\167\195\163o mudou para %s \195\160s %s."
    L15_2 = L14_2
    L14_2 = L14_2.format
    L16_2 = tostring
    L17_2 = L6_2.day
    L16_2 = L16_2(L17_2)
    L17_2 = tostring
    L18_2 = L6_2.time
    L17_2, L18_2, L19_2, L20_2 = L17_2(L18_2)
    L14_2, L15_2, L16_2, L17_2, L18_2, L19_2, L20_2 = L14_2(L15_2, L16_2, L17_2, L18_2, L19_2, L20_2)
    L10_2(L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2, L19_2, L20_2)
  end
  L10_2 = L65_1
  L11_2 = L2_2.def
  L12_2 = L2_2.mod
  L13_2 = L4_2
  L10_2(L11_2, L12_2, L13_2)
  L10_2 = {}
  L10_2.ok = true
  L11_2 = L61_1
  L12_2 = L4_2
  L13_2 = L2_2
  L14_2 = true
  L11_2 = L11_2(L12_2, L13_2, L14_2)
  L10_2.item = L11_2
  return L10_2
end
L109_1["capps.update"] = L110_1
function L109_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2
  L2_2 = L22_1
  L3_2 = A1_2.data
  L2_2 = L2_2(L3_2)
  if not L2_2 then
    L2_2 = {}
  end
  L3_2 = math
  L3_2 = L3_2.tointeger
  L4_2 = tonumber
  L5_2 = L2_2.billId
  L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2 = L4_2(L5_2)
  L3_2 = L3_2(L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2)
  if not L3_2 then
    L4_2 = {}
    L4_2.error = "status"
    return L4_2
  end
  L4_2 = MySQL
  L4_2 = L4_2.update
  L4_2 = L4_2.await
  L5_2 = "UPDATE apex_phone_bills SET status = ? WHERE id = ? AND status = ?"
  L6_2 = {}
  L7_2 = "cancelled"
  L8_2 = L3_2
  L9_2 = "pending"
  L6_2[1] = L7_2
  L6_2[2] = L8_2
  L6_2[3] = L9_2
  L4_2 = L4_2(L5_2, L6_2)
  L5_2 = tonumber
  L6_2 = L4_2
  L5_2 = L5_2(L6_2)
  if not L5_2 then
    L5_2 = 0
  end
  if 1 ~= L5_2 then
    L5_2 = L58_1
    L6_2 = {}
    L7_2 = A1_2
    L6_2[1] = L7_2
    L5_2(L6_2)
    L5_2 = {}
    L5_2.error = "gone"
    return L5_2
  end
  L5_2 = A1_2.owner
  if L5_2 then
    L5_2 = NotifyCitizen
    L6_2 = A1_2.owner
    L7_2 = "billing"
    L8_2 = "Fatura anulada"
    L9_2 = "%s \194\183 %s"
    L10_2 = L9_2
    L9_2 = L9_2.format
    L11_2 = FormatMoney
    L12_2 = tonumber
    L13_2 = L2_2.amount
    L12_2 = L12_2(L13_2)
    if not L12_2 then
      L12_2 = 0
    end
    L11_2 = L11_2(L12_2)
    L12_2 = tostring
    L13_2 = L2_2.reason
    if not L13_2 then
      L13_2 = A0_2.def
      L13_2 = L13_2.name
    end
    L12_2, L13_2 = L12_2(L13_2)
    L9_2 = L9_2(L10_2, L11_2, L12_2, L13_2)
    L10_2 = nil
    L11_2 = {}
    L11_2.throttle = false
    L5_2(L6_2, L7_2, L8_2, L9_2, L10_2, L11_2)
    L5_2 = FW
    L5_2 = L5_2.GetPlayerByCid
    L6_2 = A1_2.owner
    L5_2 = L5_2(L6_2)
    if L5_2 then
      L6_2 = Push
      L7_2 = L5_2.src
      L8_2 = "bill"
      L9_2 = {}
      L9_2.id = L3_2
      L9_2.status = "cancelled"
      L9_2.cancelled = true
      L10_2 = L2_2.amount
      L9_2.amount = L10_2
      L6_2(L7_2, L8_2, L9_2)
    end
  end
  L5_2 = nil
  return L5_2
end
L110_1 = RPC
function L111_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2, L19_2, L20_2, L21_2, L22_2
  L2_2 = L96_1
  L3_2 = A0_2
  L4_2 = A1_2
  L2_2, L3_2, L4_2 = L2_2(L3_2, L4_2)
  if not L2_2 then
    L5_2 = {}
    L5_2.error = L3_2
    return L5_2
  end
  L5_2 = type
  L6_2 = A1_2.status
  L5_2 = L5_2(L6_2)
  if "string" == L5_2 then
    L5_2 = A1_2.status
    if L5_2 then
      goto lbl_20
    end
  end
  L5_2 = ""
  ::lbl_20::
  L6_2 = L4_2.kind
  L7_2 = L4_2.status
  if L5_2 == L7_2 then
    L8_2 = {}
    L8_2.ok = true
    L9_2 = L61_1
    L10_2 = L4_2
    L11_2 = L2_2
    L12_2 = true
    L9_2 = L9_2(L10_2, L11_2, L12_2)
    L8_2.item = L9_2
    return L8_2
  end
  L8_2 = L2_2.side
  if "civil" == L8_2 then
    if "cancelled" ~= L5_2 then
      L8_2 = {}
      L8_2.error = "forbidden"
      return L8_2
    end
    if "order" == L6_2 then
      L8_2 = L43_1
      L9_2 = L2_2.mod
      L8_2 = L8_2(L9_2)
      L8_2 = L8_2[1]
      L9_2 = L44_1
      L10_2 = L2_2.mod
      L11_2 = "cancelled"
      L9_2 = L9_2(L10_2, L11_2)
      if L9_2 and L8_2 then
        L9_2 = L8_2.id
      end
      if L7_2 ~= L9_2 then
        L9_2 = {}
        L9_2.error = "forbidden"
        return L9_2
      end
    else
      if "appt" == L6_2 or "call" == L6_2 then
        L8_2 = L49_1
        L9_2 = L2_2.mod
        L10_2 = L6_2
        L11_2 = L7_2
        L8_2 = L8_2(L9_2, L10_2, L11_2)
      end
      if L8_2 then
        L8_2 = {}
        L8_2.error = "forbidden"
        return L8_2
      end
    end
  else
    L8_2 = L39_1
    L9_2 = L2_2
    L10_2 = "status"
    L8_2 = L8_2(L9_2, L10_2)
    if not L8_2 then
      L8_2 = {}
      L8_2.error = "grade"
      L9_2 = L35_1
      L10_2 = L2_2.mod
      L11_2 = "status"
      L9_2 = L9_2(L10_2, L11_2)
      L8_2.need = L9_2
      return L8_2
    end
    L8_2 = L48_1
    L8_2 = L8_2[L6_2]
    if L8_2 then
      L8_2 = L44_1
      L9_2 = L2_2.mod
      L10_2 = L5_2
      L8_2 = L8_2(L9_2, L10_2)
      if not L8_2 then
        L8_2 = {}
        L8_2.error = "status"
        return L8_2
      end
    elseif "appt" == L6_2 then
      L8_2 = L45_1
      L8_2 = L8_2[L5_2]
      if not L8_2 then
        L8_2 = {}
        L8_2.error = "status"
        return L8_2
      end
    elseif "call" == L6_2 then
      L8_2 = L46_1
      L8_2 = L8_2[L5_2]
      if not L8_2 or "waiting" == L5_2 then
        L8_2 = {}
        L8_2.error = "status"
        return L8_2
      end
      if "accepted" == L5_2 and "waiting" ~= L7_2 then
        L8_2 = {}
        L8_2.error = "gone"
        return L8_2
      end
    elseif "record" == L6_2 then
      L8_2 = L47_1
      L8_2 = L8_2[L5_2]
      if not L8_2 then
        L8_2 = {}
        L8_2.error = "status"
        return L8_2
      end
    elseif "bill" == L6_2 then
      if "cancelled" ~= L5_2 or "pending" ~= L7_2 then
        L8_2 = {}
        L8_2.error = "status"
        return L8_2
      end
      L8_2 = L109_1
      L9_2 = L2_2
      L10_2 = L4_2
      L8_2 = L8_2(L9_2, L10_2)
      if L8_2 then
        return L8_2
      end
    else
      L8_2 = {}
      L8_2.error = "status"
      return L8_2
    end
  end
  L8_2 = {}
  L9_2 = L5_2
  L10_2 = Now
  L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2, L19_2, L20_2, L21_2, L22_2 = L10_2()
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
  L8_2[13] = L21_2
  L8_2[14] = L22_2
  L9_2 = ""
  L10_2 = L24_1
  L11_2 = L2_2.acc
  L11_2 = L11_2.p
  L10_2 = L10_2(L11_2)
  L11_2 = L2_2.side
  if "staff" == L11_2 and ("call" == L6_2 and "accepted" == L5_2 or "appt" == L6_2 and "confirmed" == L5_2) then
    L9_2 = ", assignee = ?, assignee_name = ?"
    L11_2 = #L8_2
    L11_2 = L11_2 + 1
    L12_2 = L2_2.cid
    L8_2[L11_2] = L12_2
    L11_2 = #L8_2
    L11_2 = L11_2 + 1
    L8_2[L11_2] = L10_2
  end
  L11_2 = #L8_2
  L11_2 = L11_2 + 1
  L12_2 = tonumber
  L13_2 = L4_2.id
  L12_2 = L12_2(L13_2)
  L8_2[L11_2] = L12_2
  L11_2 = #L8_2
  L11_2 = L11_2 + 1
  L8_2[L11_2] = L7_2
  L11_2 = MySQL
  L11_2 = L11_2.update
  L11_2 = L11_2.await
  L12_2 = "UPDATE apex_phone_capp_items SET status = ?, updated = ?"
  L13_2 = L9_2
  L14_2 = " WHERE id = ? AND status = ?"
  L12_2 = L12_2 .. L13_2 .. L14_2
  L13_2 = L8_2
  L11_2 = L11_2(L12_2, L13_2)
  L12_2 = tonumber
  L13_2 = L11_2
  L12_2 = L12_2(L13_2)
  if not L12_2 then
    L12_2 = 0
  end
  if L12_2 < 1 then
    L12_2 = {}
    L12_2.error = "gone"
    return L12_2
  end
  L12_2 = L56_1
  L13_2 = L4_2.id
  L12_2 = L12_2(L13_2)
  L4_2 = L12_2
  L12_2 = L2_2.def
  L13_2 = L2_2.mod
  L14_2 = L51_1
  L15_2 = L13_2
  L16_2 = L6_2
  L17_2 = L5_2
  L14_2 = L14_2(L15_2, L16_2, L17_2)
  L15_2 = L2_2.side
  if "staff" == L15_2 then
    if "call" == L6_2 and "accepted" == L5_2 then
      L15_2 = L68_1
      L16_2 = L12_2
      L17_2 = L4_2
      L18_2 = tostring
      L19_2 = L12_2.name
      L18_2 = L18_2(L19_2)
      L19_2 = "%s aceitou o teu pedido e est\195\161 a caminho."
      L20_2 = L19_2
      L19_2 = L19_2.format
      L21_2 = L10_2 or L21_2
      if not L10_2 then
        L21_2 = "A equipa"
      end
      L19_2, L20_2, L21_2, L22_2 = L19_2(L20_2, L21_2)
      L15_2(L16_2, L17_2, L18_2, L19_2, L20_2, L21_2, L22_2)
      L15_2 = L72_1
      L16_2 = L12_2
      L17_2 = "dispatch.accepted"
      L18_2 = L13_2
      L19_2 = L4_2
      L20_2 = {}
      L20_2.by = L10_2
      L15_2(L16_2, L17_2, L18_2, L19_2, L20_2)
    else
      L15_2 = L48_1
      L15_2 = L15_2[L6_2]
      if L15_2 then
        L15_2 = L44_1
        L16_2 = L13_2
        L17_2 = L5_2
        L15_2 = L15_2(L16_2, L17_2)
        if L15_2 then
          goto lbl_292
        end
      end
      L15_2 = nil
      ::lbl_292::
      L16_2 = "bill" ~= L6_2
      if L16_2 then
        if "order" == L6_2 then
          L17_2 = "A tua encomenda \"%s\" passou para: %s."
          L18_2 = L17_2
          L17_2 = L17_2.format
          L19_2 = tostring
          L20_2 = L4_2.title
          L19_2 = L19_2(L20_2)
          L20_2 = L14_2
          L17_2 = L17_2(L18_2, L19_2, L20_2)
          if L17_2 then
            goto lbl_321
          end
        end
        L17_2 = "O teu pedido \"%s\" passou para: %s."
        L18_2 = L17_2
        L17_2 = L17_2.format
        L19_2 = tostring
        L20_2 = L4_2.title
        L19_2 = L19_2(L20_2)
        L20_2 = L14_2
        L17_2 = L17_2(L18_2, L19_2, L20_2)
        ::lbl_321::
        L18_2 = L68_1
        L19_2 = L12_2
        L20_2 = L4_2
        L21_2 = tostring
        L22_2 = L12_2.name
        L21_2 = L21_2(L22_2)
        L22_2 = L17_2
        L18_2(L19_2, L20_2, L21_2, L22_2)
      end
      L17_2 = L72_1
      L18_2 = L12_2
      L19_2 = "item.status"
      L20_2 = L13_2
      L21_2 = L4_2
      L22_2 = {}
      L22_2.by = L10_2
      L17_2(L18_2, L19_2, L20_2, L21_2, L22_2)
    end
  else
    L15_2 = L72_1
    L16_2 = L12_2
    L17_2 = "item.status"
    L18_2 = L13_2
    L19_2 = L4_2
    L20_2 = {}
    L20_2.by = "Autor"
    L15_2(L16_2, L17_2, L18_2, L19_2, L20_2)
    if "order" == L6_2 then
      L15_2 = L66_1
      L16_2 = L12_2
      L17_2 = L13_2
      L18_2 = tostring
      L19_2 = L12_2.name
      L18_2 = L18_2(L19_2)
      L19_2 = " \194\183 "
      L20_2 = tostring
      L21_2 = L13_2.title
      if not L21_2 then
        L21_2 = L13_2.id
      end
      L20_2 = L20_2(L21_2)
      L18_2 = L18_2 .. L19_2 .. L20_2
      L19_2 = "Encomenda cancelada: %s"
      L20_2 = L19_2
      L19_2 = L19_2.format
      L21_2 = tostring
      L22_2 = L4_2.title
      L21_2, L22_2 = L21_2(L22_2)
      L19_2 = L19_2(L20_2, L21_2, L22_2)
      L20_2 = {}
      L21_2 = L12_2.id
      L20_2.capp = L21_2
      L21_2 = L13_2.id
      L20_2.module = L21_2
      L21_2 = tonumber
      L22_2 = L4_2.id
      L21_2 = L21_2(L22_2)
      L20_2.id = L21_2
      L21_2 = L12_2.audience
      L21_2 = L21_2.onDutyOnly
      L21_2 = true == L21_2
      L15_2(L16_2, L17_2, L18_2, L19_2, L20_2, L21_2)
    end
  end
  L15_2 = L65_1
  L16_2 = L12_2
  L17_2 = L13_2
  L18_2 = L4_2
  L15_2(L16_2, L17_2, L18_2)
  L15_2 = {}
  L15_2.ok = true
  L16_2 = L61_1
  L17_2 = L4_2
  L18_2 = L2_2
  L19_2 = true
  L16_2 = L16_2(L17_2, L18_2, L19_2)
  L15_2.item = L16_2
  L16_2 = L2_2.side
  if "staff" == L16_2 then
    L16_2 = L4_2.x
    if L16_2 then
      L16_2 = {}
      L17_2 = tonumber
      L18_2 = L4_2.x
      L17_2 = L17_2(L18_2)
      L16_2.x = L17_2
      L17_2 = tonumber
      L18_2 = L4_2.y
      L17_2 = L17_2(L18_2)
      L16_2.y = L17_2
      L15_2.coords = L16_2
    end
  end
  return L15_2
end
L110_1["capps.status"] = L111_1
L110_1 = RPC
function L111_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2
  A1_2.side = "staff"
  L2_2 = L96_1
  L3_2 = A0_2
  L4_2 = A1_2
  L2_2, L3_2, L4_2 = L2_2(L3_2, L4_2)
  if not L2_2 then
    L5_2 = {}
    L5_2.error = L3_2
    return L5_2
  end
  L5_2 = L4_2.kind
  if "post" ~= L5_2 then
    L5_2 = L4_2.kind
    if "record" ~= L5_2 then
      L5_2 = L4_2.kind
      if "bill" ~= L5_2 then
        L5_2 = L4_2.kind
        if "shift" ~= L5_2 then
          goto lbl_28
        end
      end
    end
  end
  L5_2 = {}
  L5_2.error = "forbidden"
  do return L5_2 end
  ::lbl_28::
  L5_2 = L39_1
  L6_2 = L2_2
  L7_2 = "assign"
  L5_2 = L5_2(L6_2, L7_2)
  if not L5_2 then
    L5_2 = {}
    L5_2.error = "grade"
    L6_2 = L35_1
    L7_2 = L2_2.mod
    L8_2 = "assign"
    L6_2 = L6_2(L7_2, L8_2)
    L5_2.need = L6_2
    return L5_2
  end
  L5_2 = L4_2.assignee
  L6_2 = L2_2.cid
  L5_2 = L5_2 == L6_2
  if L5_2 then
    L6_2 = MySQL
    L6_2 = L6_2.update
    L6_2 = L6_2.await
    L7_2 = "UPDATE apex_phone_capp_items SET assignee = NULL, assignee_name = NULL, updated = ? WHERE id = ?"
    L8_2 = {}
    L9_2 = Now
    L9_2 = L9_2()
    L10_2 = tonumber
    L11_2 = L4_2.id
    L10_2, L11_2, L12_2, L13_2 = L10_2(L11_2)
    L8_2[1] = L9_2
    L8_2[2] = L10_2
    L8_2[3] = L11_2
    L8_2[4] = L12_2
    L8_2[5] = L13_2
    L6_2(L7_2, L8_2)
  else
    L6_2 = MySQL
    L6_2 = L6_2.update
    L6_2 = L6_2.await
    L7_2 = "UPDATE apex_phone_capp_items SET assignee = ?, assignee_name = ?, updated = ? WHERE id = ?"
    L8_2 = {}
    L9_2 = L2_2.cid
    L10_2 = L24_1
    L11_2 = L2_2.acc
    L11_2 = L11_2.p
    L10_2 = L10_2(L11_2)
    L11_2 = Now
    L11_2 = L11_2()
    L12_2 = tonumber
    L13_2 = L4_2.id
    L12_2, L13_2 = L12_2(L13_2)
    L8_2[1] = L9_2
    L8_2[2] = L10_2
    L8_2[3] = L11_2
    L8_2[4] = L12_2
    L8_2[5] = L13_2
    L6_2(L7_2, L8_2)
  end
  L6_2 = L56_1
  L7_2 = L4_2.id
  L6_2 = L6_2(L7_2)
  L4_2 = L6_2
  L6_2 = L65_1
  L7_2 = L2_2.def
  L8_2 = L2_2.mod
  L9_2 = L4_2
  L6_2(L7_2, L8_2, L9_2)
  L6_2 = {}
  L6_2.ok = true
  L7_2 = L61_1
  L8_2 = L4_2
  L9_2 = L2_2
  L10_2 = true
  L7_2 = L7_2(L8_2, L9_2, L10_2)
  L6_2.item = L7_2
  return L6_2
end
L110_1["capps.assign"] = L111_1
L110_1 = RPC
function L111_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2, L19_2, L20_2, L21_2, L22_2, L23_2
  L2_2 = L96_1
  L3_2 = A0_2
  L4_2 = A1_2
  L2_2, L3_2, L4_2 = L2_2(L3_2, L4_2)
  if not L2_2 then
    L5_2 = {}
    L5_2.error = L3_2
    return L5_2
  end
  L5_2 = L4_2.kind
  if "post" ~= L5_2 then
    L5_2 = L4_2.kind
    if "bill" ~= L5_2 then
      L5_2 = L4_2.kind
      if "shift" ~= L5_2 then
        goto lbl_24
      end
    end
  end
  L5_2 = {}
  L5_2.error = "forbidden"
  do return L5_2 end
  ::lbl_24::
  L5_2 = L2_2.side
  if "civil" == L5_2 then
    L6_2 = L4_2.kind
    L5_2 = L48_1
    L5_2 = L5_2[L6_2]
    if L5_2 then
      L5_2 = L2_2.mod
      L5_2 = L5_2.options
      L5_2 = L5_2.replies
      if false ~= L5_2 then
        goto lbl_41
      end
    end
    L5_2 = {}
    L5_2.error = "forbidden"
    do return L5_2 end
    ::lbl_41::
    L5_2 = L49_1
    L6_2 = L2_2.mod
    L7_2 = L4_2.kind
    L8_2 = L4_2.status
    L5_2 = L5_2(L6_2, L7_2, L8_2)
    if L5_2 then
      L5_2 = {}
      L5_2.error = "closed"
      return L5_2
    end
  else
    L5_2 = L39_1
    L6_2 = L2_2
    L7_2 = "reply"
    L5_2 = L5_2(L6_2, L7_2)
    if not L5_2 then
      L5_2 = {}
      L5_2.error = "grade"
      L6_2 = L35_1
      L7_2 = L2_2.mod
      L8_2 = "reply"
      L6_2 = L6_2(L7_2, L8_2)
      L5_2.need = L6_2
      return L5_2
    end
  end
  L5_2 = L11_1
  L6_2 = A1_2.text
  L7_2 = 1000
  L8_2 = true
  L5_2 = L5_2(L6_2, L7_2, L8_2)
  if not L5_2 then
    L6_2 = {}
    L6_2.error = "empty"
    return L6_2
  end
  L6_2 = GetGameTimer
  L6_2 = L6_2()
  L7_2 = L85_1
  L7_2 = L7_2[A0_2]
  if L7_2 then
    L7_2 = L85_1
    L7_2 = L7_2[A0_2]
    L7_2 = L6_2 - L7_2
    L8_2 = 1500
    if L7_2 < L8_2 then
      L7_2 = {}
      L7_2.error = "cooldown"
      L7_2.wait = 2
      return L7_2
    end
  end
  L7_2 = tonumber
  L8_2 = MySQL
  L8_2 = L8_2.scalar
  L8_2 = L8_2.await
  L9_2 = "SELECT COUNT(*) FROM apex_phone_capp_notes WHERE item = ?"
  L10_2 = {}
  L11_2 = tonumber
  L12_2 = L4_2.id
  L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2, L19_2, L20_2, L21_2, L22_2, L23_2 = L11_2(L12_2)
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
  L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2, L19_2, L20_2, L21_2, L22_2, L23_2 = L8_2(L9_2, L10_2)
  L7_2 = L7_2(L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2, L19_2, L20_2, L21_2, L22_2, L23_2)
  if not L7_2 then
    L7_2 = 0
  end
  L8_2 = 200
  if L7_2 >= L8_2 then
    L8_2 = {}
    L8_2.error = "toomany"
    L8_2.max = 200
    return L8_2
  end
  L8_2 = L85_1
  L8_2[A0_2] = L6_2
  L8_2 = L2_2.side
  L8_2 = "staff" == L8_2
  L9_2 = L24_1
  L10_2 = L2_2.acc
  L10_2 = L10_2.p
  L9_2 = L9_2(L10_2)
  L10_2 = Now
  L10_2 = L10_2()
  L11_2 = MySQL
  L11_2 = L11_2.insert
  L11_2 = L11_2.await
  L12_2 = "INSERT INTO apex_phone_capp_notes (item, author, author_name, staff, private, text, created) VALUES (?, ?, ?, ?, ?, ?, ?)"
  L13_2 = {}
  L14_2 = tonumber
  L15_2 = L4_2.id
  L14_2 = L14_2(L15_2)
  L15_2 = L2_2.cid
  L16_2 = L9_2
  L17_2 = L2_2.side
  if "staff" == L17_2 then
    L17_2 = 1
    if L17_2 then
      goto lbl_155
    end
  end
  L17_2 = 0
  ::lbl_155::
  if L8_2 then
    L18_2 = 1
    if L18_2 then
      goto lbl_161
    end
  end
  L18_2 = 0
  ::lbl_161::
  L19_2 = L5_2
  L20_2 = L10_2
  L13_2[1] = L14_2
  L13_2[2] = L15_2
  L13_2[3] = L16_2
  L13_2[4] = L17_2
  L13_2[5] = L18_2
  L13_2[6] = L19_2
  L13_2[7] = L20_2
  L11_2 = L11_2(L12_2, L13_2)
  L12_2 = MySQL
  L12_2 = L12_2.update
  L12_2 = L12_2.await
  L13_2 = "UPDATE apex_phone_capp_items SET updated = ? WHERE id = ?"
  L14_2 = {}
  L15_2 = L10_2
  L16_2 = tonumber
  L17_2 = L4_2.id
  L16_2, L17_2, L18_2, L19_2, L20_2, L21_2, L22_2, L23_2 = L16_2(L17_2)
  L14_2[1] = L15_2
  L14_2[2] = L16_2
  L14_2[3] = L17_2
  L14_2[4] = L18_2
  L14_2[5] = L19_2
  L14_2[6] = L20_2
  L14_2[7] = L21_2
  L14_2[8] = L22_2
  L14_2[9] = L23_2
  L12_2(L13_2, L14_2)
  L12_2 = L2_2.def
  L13_2 = L2_2.mod
  if not L8_2 then
    L14_2 = L2_2.side
    if "staff" == L14_2 then
      L14_2 = L4_2.owner
      if L14_2 then
        L14_2 = L4_2.owner
        L15_2 = L2_2.cid
        if L14_2 ~= L15_2 then
          L14_2 = L68_1
          L15_2 = L12_2
          L16_2 = L4_2
          L17_2 = tostring
          L18_2 = L12_2.name
          L17_2 = L17_2(L18_2)
          L18_2 = "Nova resposta: %s"
          L19_2 = L18_2
          L18_2 = L18_2.format
          L21_2 = L5_2
          L20_2 = L5_2.sub
          L22_2 = 1
          L23_2 = 120
          L20_2, L21_2, L22_2, L23_2 = L20_2(L21_2, L22_2, L23_2)
          L18_2, L19_2, L20_2, L21_2, L22_2, L23_2 = L18_2(L19_2, L20_2, L21_2, L22_2, L23_2)
          L14_2(L15_2, L16_2, L17_2, L18_2, L19_2, L20_2, L21_2, L22_2, L23_2)
      end
    end
    else
      L14_2 = L2_2.side
      if "civil" == L14_2 then
        L14_2 = L4_2.assignee
        if L14_2 then
          L14_2 = L64_1
          L15_2 = L4_2.assignee
          L14_2 = L14_2(L15_2)
          if L14_2 then
            L15_2 = NotifyPlayer
            L16_2 = L14_2
            L17_2 = "capp_"
            L18_2 = L12_2.id
            L17_2 = L17_2 .. L18_2
            L18_2 = tostring
            L19_2 = L12_2.name
            L18_2 = L18_2(L19_2)
            L19_2 = " \194\183 "
            L20_2 = tostring
            L21_2 = L13_2.title
            if not L21_2 then
              L21_2 = L13_2.id
            end
            L20_2 = L20_2(L21_2)
            L18_2 = L18_2 .. L19_2 .. L20_2
            L20_2 = L5_2
            L19_2 = L5_2.sub
            L21_2 = 1
            L22_2 = 160
            L19_2 = L19_2(L20_2, L21_2, L22_2)
            L20_2 = {}
            L21_2 = L12_2.id
            L20_2.capp = L21_2
            L21_2 = L13_2.id
            L20_2.module = L21_2
            L21_2 = tonumber
            L22_2 = L4_2.id
            L21_2 = L21_2(L22_2)
            L20_2.id = L21_2
            L15_2(L16_2, L17_2, L18_2, L19_2, L20_2)
          end
        end
      end
    end
    L14_2 = L72_1
    L15_2 = L12_2
    L16_2 = "item.reply"
    L17_2 = L13_2
    L18_2 = L4_2
    L19_2 = {}
    L19_2.note = L5_2
    L20_2 = L2_2.side
    L20_2 = L9_2 or L20_2
    if "staff" ~= L20_2 or not L9_2 then
      L20_2 = tonumber
      L21_2 = L4_2.anonymous
      L20_2 = L20_2(L21_2)
      if 1 == L20_2 then
        L20_2 = "An\195\179nimo"
        if L20_2 then
          goto lbl_270
        end
      end
      L20_2 = L9_2
    end
    ::lbl_270::
    L19_2.by = L20_2
    L14_2(L15_2, L16_2, L17_2, L18_2, L19_2)
  end
  L14_2 = L65_1
  L15_2 = L12_2
  L16_2 = L13_2
  L17_2 = L4_2
  L14_2(L15_2, L16_2, L17_2)
  L14_2 = {}
  L14_2.ok = true
  L15_2 = {}
  L16_2 = tonumber
  L17_2 = L11_2
  L16_2 = L16_2(L17_2)
  L15_2.id = L16_2
  L15_2.author_name = L9_2
  L16_2 = L2_2.side
  L16_2 = "staff" == L16_2
  L15_2.staff = L16_2
  L15_2.private = L8_2
  L15_2.text = L5_2
  L15_2.created = L10_2
  L15_2.mine = true
  L14_2.note = L15_2
  return L14_2
end
L110_1["capps.note"] = L111_1
L110_1 = RPC
function L111_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2
  A1_2.side = "staff"
  L2_2 = L96_1
  L3_2 = A0_2
  L4_2 = A1_2
  L2_2, L3_2, L4_2 = L2_2(L3_2, L4_2)
  if not L2_2 then
    L5_2 = {}
    L5_2.error = L3_2
    return L5_2
  end
  L5_2 = L39_1
  L6_2 = L2_2
  L7_2 = "delete"
  L5_2 = L5_2(L6_2, L7_2)
  if not L5_2 then
    L5_2 = {}
    L5_2.error = "grade"
    L6_2 = L35_1
    L7_2 = L2_2.mod
    L8_2 = "delete"
    L6_2 = L6_2(L7_2, L8_2)
    L5_2.need = L6_2
    return L5_2
  end
  L5_2 = L4_2.kind
  if "bill" == L5_2 then
    L5_2 = L4_2.status
    if "pending" == L5_2 then
      L5_2 = L109_1
      L6_2 = L2_2
      L7_2 = L4_2
      L5_2 = L5_2(L6_2, L7_2)
      if L5_2 then
        L6_2 = L5_2.error
        if "gone" ~= L6_2 then
          return L5_2
        end
      end
    end
  end
  L5_2 = MySQL
  L5_2 = L5_2.update
  L5_2 = L5_2.await
  L6_2 = "DELETE FROM apex_phone_capp_notes WHERE item = ?"
  L7_2 = {}
  L8_2 = tonumber
  L9_2 = L4_2.id
  L8_2, L9_2 = L8_2(L9_2)
  L7_2[1] = L8_2
  L7_2[2] = L9_2
  L5_2(L6_2, L7_2)
  L5_2 = MySQL
  L5_2 = L5_2.update
  L5_2 = L5_2.await
  L6_2 = "DELETE FROM apex_phone_capp_items WHERE id = ?"
  L7_2 = {}
  L8_2 = tonumber
  L9_2 = L4_2.id
  L8_2, L9_2 = L8_2(L9_2)
  L7_2[1] = L8_2
  L7_2[2] = L9_2
  L5_2(L6_2, L7_2)
  L5_2 = L65_1
  L6_2 = L2_2.def
  L7_2 = L2_2.mod
  L8_2 = L4_2
  L9_2 = {}
  L9_2.deleted = true
  L5_2(L6_2, L7_2, L8_2, L9_2)
  L5_2 = {}
  L5_2.ok = true
  return L5_2
end
L110_1["capps.delete"] = L111_1
L110_1 = RPC
function L111_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2, L19_2
  L2_2 = L40_1
  L3_2 = A0_2
  L4_2 = A1_2.app
  L5_2 = A1_2.module
  L6_2 = A1_2.side
  L2_2, L3_2 = L2_2(L3_2, L4_2, L5_2, L6_2)
  if not L2_2 then
    L4_2 = {}
    L4_2.error = L3_2
    return L4_2
  end
  L4_2 = L2_2.kind
  if "appt" ~= L4_2 then
    L4_2 = {}
    L4_2.error = "module"
    return L4_2
  end
  L4_2 = L89_1
  L5_2 = L2_2.mod
  L4_2 = L4_2(L5_2)
  L5_2 = L92_1
  L6_2 = L4_2
  L5_2 = L5_2(L6_2)
  L6_2 = L11_1
  L7_2 = A1_2.day
  L8_2 = 10
  L6_2 = L6_2(L7_2, L8_2)
  L7_2 = false
  L8_2 = ipairs
  L9_2 = L5_2
  L8_2, L9_2, L10_2, L11_2 = L8_2(L9_2)
  for L12_2, L13_2 in L8_2, L9_2, L10_2, L11_2 do
    L14_2 = L13_2.day
    if L14_2 == L6_2 then
      L14_2 = L13_2.open
      if L14_2 then
        L7_2 = true
      end
    end
  end
  if not L7_2 then
    L6_2 = nil
    L8_2 = ipairs
    L9_2 = L5_2
    L8_2, L9_2, L10_2, L11_2 = L8_2(L9_2)
    for L12_2, L13_2 in L8_2, L9_2, L10_2, L11_2 do
      L14_2 = L13_2.open
      if L14_2 then
        L6_2 = L13_2.day
        break
      end
    end
  end
  L8_2 = {}
  L8_2.days = L5_2
  L8_2.day = L6_2
  if L6_2 then
    L9_2 = L94_1
    L10_2 = L2_2.def
    L11_2 = L2_2.mod
    L12_2 = L4_2
    L13_2 = L6_2
    L9_2 = L9_2(L10_2, L11_2, L12_2, L13_2)
    if L9_2 then
      goto lbl_76
    end
  end
  L9_2 = {}
  ::lbl_76::
  L8_2.slots = L9_2
  L9_2 = L4_2.services
  L8_2.services = L9_2
  L9_2 = L4_2.notes
  L8_2.notes = L9_2
  L9_2 = L4_2.slot
  L8_2.slot = L9_2
  if L6_2 then
    L9_2 = L8_2.slots
    L9_2 = #L9_2
    if 0 == L9_2 then
      L9_2 = L11_1
      L10_2 = A1_2.day
      L11_2 = 10
      L9_2 = L9_2(L10_2, L11_2)
      if L6_2 ~= L9_2 then
        L9_2 = ipairs
        L10_2 = L5_2
        L9_2, L10_2, L11_2, L12_2 = L9_2(L10_2)
        for L13_2, L14_2 in L9_2, L10_2, L11_2, L12_2 do
          L15_2 = L14_2.open
          if L15_2 then
            L15_2 = L14_2.day
            if L6_2 < L15_2 then
              L15_2 = L94_1
              L16_2 = L2_2.def
              L17_2 = L2_2.mod
              L18_2 = L4_2
              L19_2 = L14_2.day
              L15_2 = L15_2(L16_2, L17_2, L18_2, L19_2)
              L16_2 = #L15_2
              if L16_2 > 0 then
                L16_2 = L14_2.day
                L8_2.slots = L15_2
                L8_2.day = L16_2
                break
              end
            end
          end
        end
      end
    end
  end
  return L8_2
end
L110_1["capps.slots"] = L111_1
function L110_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2
  L2_2 = {}
  L3_2 = ipairs
  L4_2 = L63_1
  L5_2 = A0_2
  L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2 = L4_2(L5_2)
  L3_2, L4_2, L5_2, L6_2 = L3_2(L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2)
  for L7_2, L8_2 in L3_2, L4_2, L5_2, L6_2 do
    L9_2 = L8_2.acc
    L10_2 = L9_2.member
    if L10_2 then
      L10_2 = L36_1
      L11_2 = L9_2
      L12_2 = A1_2
      L10_2 = L10_2(L11_2, L12_2)
      if L10_2 then
        L10_2 = #L2_2
        L10_2 = L10_2 + 1
        L2_2[L10_2] = L8_2
      end
    end
  end
  return L2_2
end
L111_1 = RPC
function L112_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2
  L2_2 = type
  L3_2 = A1_2.app
  L2_2 = L2_2(L3_2)
  if "string" == L2_2 then
    L3_2 = A1_2.app
    L2_2 = L6_1
    L2_2 = L2_2[L3_2]
    if L2_2 then
      goto lbl_12
    end
  end
  L2_2 = nil
  ::lbl_12::
  if L2_2 then
    L3_2 = L2_2.enabled
    if false ~= L3_2 then
      goto lbl_21
    end
  end
  L3_2 = {}
  L3_2.error = "app"
  do return L3_2 end
  ::lbl_21::
  L3_2 = L34_1
  L4_2 = A0_2
  L5_2 = L2_2
  L3_2 = L3_2(L4_2, L5_2)
  if L3_2 then
    L4_2 = L3_2.member
    if L4_2 then
      goto lbl_34
    end
  end
  L4_2 = {}
  L4_2.error = "forbidden"
  do return L4_2 end
  ::lbl_34::
  L4_2 = nil
  L5_2 = ipairs
  L6_2 = L2_2.modules
  L5_2, L6_2, L7_2, L8_2 = L5_2(L6_2)
  for L9_2, L10_2 in L5_2, L6_2, L7_2, L8_2 do
    L11_2 = L10_2.type
    if "roster" == L11_2 then
      L11_2 = L10_2.enabled
      if false ~= L11_2 then
        L11_2 = A1_2.module
        if nil ~= L11_2 then
          L11_2 = A1_2.module
          L12_2 = L10_2.id
          if L11_2 ~= L12_2 then
            goto lbl_54
          end
        end
        L4_2 = L10_2
        break
      end
    end
    ::lbl_54::
  end
  if L4_2 then
    L5_2 = L37_1
    L6_2 = L3_2
    L7_2 = L4_2
    L5_2 = L5_2(L6_2, L7_2)
    if L5_2 then
      goto lbl_69
    end
  end
  L5_2 = {}
  L5_2.error = "forbidden"
  do return L5_2 end
  ::lbl_69::
  L5_2 = L4_2.options
  L5_2 = L5_2.showOffDuty
  L5_2 = false ~= L5_2
  L6_2 = {}
  L7_2 = ipairs
  L8_2 = L110_1
  L9_2 = L2_2
  L10_2 = L4_2
  L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2 = L8_2(L9_2, L10_2)
  L7_2, L8_2, L9_2, L10_2 = L7_2(L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2)
  for L11_2, L12_2 in L7_2, L8_2, L9_2, L10_2 do
    L13_2 = L12_2.acc
    if not L5_2 then
      L14_2 = L13_2.onduty
      if not L14_2 then
        goto lbl_135
      end
    end
    L14_2 = #L6_2
    L14_2 = L14_2 + 1
    L15_2 = {}
    L16_2 = L24_1
    L17_2 = L12_2.p
    L16_2 = L16_2(L17_2)
    if not L16_2 then
      L16_2 = "#"
      L17_2 = L12_2.src
      L16_2 = L16_2 .. L17_2
    end
    L15_2.name = L16_2
    L16_2 = L13_2.jobLabel
    L15_2.job = L16_2
    L16_2 = L13_2.job
    L15_2.jobName = L16_2
    L16_2 = L13_2.gradeLabel
    L15_2.grade = L16_2
    L16_2 = L13_2.grade
    L15_2.level = L16_2
    L16_2 = L13_2.onduty
    L15_2.onduty = L16_2
    L16_2 = GetPlayerNumber
    L17_2 = L12_2.src
    L16_2 = L16_2(L17_2)
    if not L16_2 then
      L16_2 = L12_2.p
      L16_2 = L16_2.phone
    end
    L15_2.phone = L16_2
    L16_2 = L12_2.src
    L16_2 = L16_2 == A0_2 or L16_2
    L15_2.me = L16_2
    L6_2[L14_2] = L15_2
    L14_2 = #L6_2
    L15_2 = 150
    if L14_2 >= L15_2 then
      break
    end
    ::lbl_135::
  end
  L7_2 = table
  L7_2 = L7_2.sort
  L8_2 = L6_2
  function L9_2(A0_3, A1_3)
    local L2_3, L3_3, L4_3
    L2_3 = A0_3.onduty
    L3_3 = A1_3.onduty
    if L2_3 ~= L3_3 then
      L2_3 = A0_3.onduty
      return L2_3
    end
    L2_3 = A0_3.level
    L3_3 = A1_3.level
    if L2_3 ~= L3_3 then
      L2_3 = A0_3.level
      L3_3 = A1_3.level
      L2_3 = L2_3 > L3_3
      return L2_3
    end
    L2_3 = tostring
    L3_3 = A0_3.name
    L2_3 = L2_3(L3_3)
    L3_3 = tostring
    L4_3 = A1_3.name
    L3_3 = L3_3(L4_3)
    L2_3 = L2_3 < L3_3
    return L2_3
  end
  L7_2(L8_2, L9_2)
  L7_2 = {}
  L7_2.members = L6_2
  return L7_2
end
L111_1["capps.roster"] = L112_1
L111_1 = RPC
function L112_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2, L19_2, L20_2, L21_2, L22_2, L23_2
  A1_2.side = "staff"
  L2_2 = L96_1
  L3_2 = A0_2
  L4_2 = A1_2
  L2_2, L3_2, L4_2 = L2_2(L3_2, L4_2)
  if not L2_2 then
    L5_2 = {}
    L5_2.error = L3_2
    return L5_2
  end
  L5_2 = L4_2.kind
  if "order" ~= L5_2 then
    L5_2 = {}
    L5_2.error = "forbidden"
    return L5_2
  end
  L5_2 = L100_1
  L6_2 = L2_2.def
  L5_2 = L5_2(L6_2)
  L6_2 = L2_2
  if L5_2 then
    L7_2 = L2_2.acc
    L8_2 = L37_1
    L9_2 = L7_2
    L10_2 = L5_2
    L8_2 = L8_2(L9_2, L10_2)
    if L8_2 then
      L8_2 = L7_2.grade
      L9_2 = L35_1
      L10_2 = L5_2
      L11_2 = "create"
      L9_2 = L9_2(L10_2, L11_2)
      if not (L8_2 < L9_2) then
        goto lbl_48
      end
    end
    L8_2 = {}
    L8_2.error = "grade"
    L9_2 = L35_1
    L10_2 = L5_2
    L11_2 = "create"
    L9_2 = L9_2(L10_2, L11_2)
    L8_2.need = L9_2
    do return L8_2 end
    ::lbl_48::
    L8_2 = {}
    L9_2 = L2_2.def
    L8_2.def = L9_2
    L8_2.mod = L5_2
    L8_2.acc = L7_2
    L8_2.side = "staff"
    L9_2 = L2_2.cid
    L8_2.cid = L9_2
    L8_2.src = A0_2
    L8_2.kind = "bill"
    L6_2 = L8_2
  else
    L7_2 = L2_2.mod
    L7_2 = L7_2.options
    L7_2 = L7_2.billing
    if true ~= L7_2 then
      L7_2 = {}
      L7_2.error = "module"
      return L7_2
    end
    L7_2 = L39_1
    L8_2 = L2_2
    L9_2 = "status"
    L7_2 = L7_2(L8_2, L9_2)
    if not L7_2 then
      L7_2 = {}
      L7_2.error = "grade"
      L8_2 = L35_1
      L9_2 = L2_2.mod
      L10_2 = "status"
      L8_2 = L8_2(L9_2, L10_2)
      L7_2.need = L8_2
      return L7_2
    end
  end
  L7_2 = L4_2.owner
  if not L7_2 then
    L7_2 = {}
    L7_2.error = "target"
    return L7_2
  end
  L7_2 = L22_1
  L8_2 = L4_2.data
  L7_2 = L7_2(L8_2)
  if not L7_2 then
    L7_2 = {}
  end
  L8_2 = math
  L8_2 = L8_2.tointeger
  L9_2 = tonumber
  L10_2 = L7_2.billId
  L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2, L19_2, L20_2, L21_2, L22_2, L23_2 = L9_2(L10_2)
  L8_2 = L8_2(L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2, L19_2, L20_2, L21_2, L22_2, L23_2)
  if L8_2 then
    L9_2 = MySQL
    L9_2 = L9_2.scalar
    L9_2 = L9_2.await
    L10_2 = "SELECT status FROM apex_phone_bills WHERE id = ?"
    L11_2 = {}
    L12_2 = L8_2
    L11_2[1] = L12_2
    L9_2 = L9_2(L10_2, L11_2)
    if "pending" == L9_2 or "paid" == L9_2 then
      L10_2 = {}
      L10_2.error = "billed"
      L10_2.status = L9_2
      return L10_2
    end
  end
  L9_2 = math
  L9_2 = L9_2.floor
  L10_2 = tonumber
  L11_2 = L7_2.total
  L10_2 = L10_2(L11_2)
  if not L10_2 then
    L10_2 = 0
  end
  L10_2 = L10_2 + 0.5
  L9_2 = L9_2(L10_2)
  if L9_2 < 1 then
    L10_2 = {}
    L10_2.error = "amount"
    return L10_2
  end
  if L5_2 then
    L10_2 = L5_2.options
    if L10_2 then
      goto lbl_149
    end
  end
  L10_2 = L2_2.mod
  L10_2 = L10_2.options
  ::lbl_149::
  L11_2 = L11_1
  L12_2 = "%s \194\183 %s #%d"
  L13_2 = L12_2
  L12_2 = L12_2.format
  L14_2 = tostring
  L15_2 = L2_2.def
  L15_2 = L15_2.name
  L14_2 = L14_2(L15_2)
  L15_2 = tostring
  L16_2 = L2_2.mod
  L16_2 = L16_2.title
  if not L16_2 then
    L16_2 = L2_2.mod
    L16_2 = L16_2.id
  end
  L15_2 = L15_2(L16_2)
  L16_2 = tonumber
  L17_2 = L4_2.id
  L16_2, L17_2, L18_2, L19_2, L20_2, L21_2, L22_2, L23_2 = L16_2(L17_2)
  L12_2 = L12_2(L13_2, L14_2, L15_2, L16_2, L17_2, L18_2, L19_2, L20_2, L21_2, L22_2, L23_2)
  L13_2 = 160
  L11_2 = L11_2(L12_2, L13_2)
  L12_2 = L99_1
  L13_2 = L6_2
  L14_2 = L4_2.owner
  L15_2 = L9_2
  L16_2 = L11_2
  L17_2 = L10_2.society
  L17_2 = false ~= L17_2
  L18_2 = L10_2.maxAmount
  L12_2 = L12_2(L13_2, L14_2, L15_2, L16_2, L17_2, L18_2)
  L13_2 = L12_2.error
  if L13_2 then
    return L12_2
  end
  L13_2 = tonumber
  L14_2 = L12_2.id
  L13_2 = L13_2(L14_2)
  L7_2.billAmount = L9_2
  L7_2.billId = L13_2
  L13_2 = MySQL
  L13_2 = L13_2.update
  L13_2 = L13_2.await
  L14_2 = "UPDATE apex_phone_capp_items SET data = ?, updated = ? WHERE id = ?"
  L15_2 = {}
  L16_2 = L21_1
  L17_2 = L7_2
  L16_2 = L16_2(L17_2)
  L17_2 = Now
  L17_2 = L17_2()
  L18_2 = tonumber
  L19_2 = L4_2.id
  L18_2, L19_2, L20_2, L21_2, L22_2, L23_2 = L18_2(L19_2)
  L15_2[1] = L16_2
  L15_2[2] = L17_2
  L15_2[3] = L18_2
  L15_2[4] = L19_2
  L15_2[5] = L20_2
  L15_2[6] = L21_2
  L15_2[7] = L22_2
  L15_2[8] = L23_2
  L13_2(L14_2, L15_2)
  if L5_2 then
    L13_2 = {}
    L14_2 = L2_2.def
    L14_2 = L14_2.id
    L13_2.app = L14_2
    L14_2 = L5_2.id
    L13_2.module = L14_2
    L13_2.kind = "bill"
    L13_2.status = "pending"
    L13_2.title = L11_2
    L14_2 = L4_2.owner
    L13_2.owner = L14_2
    L14_2 = L4_2.owner_name
    L13_2.owner_name = L14_2
    L14_2 = L4_2.owner_phone
    L13_2.owner_phone = L14_2
    L14_2 = L2_2.cid
    L13_2.assignee = L14_2
    L14_2 = L24_1
    L15_2 = L2_2.acc
    L15_2 = L15_2.p
    L14_2 = L14_2(L15_2)
    L13_2.assignee_name = L14_2
    L14_2 = {}
    L15_2 = tonumber
    L16_2 = L12_2.id
    L15_2 = L15_2(L16_2)
    L14_2.billId = L15_2
    L14_2.amount = L9_2
    L14_2.reason = L11_2
    L15_2 = L4_2.owner_phone
    L14_2.to = L15_2
    L15_2 = L12_2.society
    L14_2.society = L15_2
    L15_2 = tonumber
    L16_2 = L4_2.id
    L15_2 = L15_2(L16_2)
    L14_2.order = L15_2
    L13_2.data = L14_2
    L14_2 = L103_1
    L15_2 = L13_2
    L14_2 = L14_2(L15_2)
    L15_2 = L14_2 or L15_2
    if L14_2 then
      L15_2 = L56_1
      L16_2 = L14_2
      L15_2 = L15_2(L16_2)
    end
    if L15_2 then
      L16_2 = L72_1
      L17_2 = L2_2.def
      L18_2 = "bill.created"
      L19_2 = L5_2
      L20_2 = L15_2
      L21_2 = {}
      L22_2 = L24_1
      L23_2 = L2_2.acc
      L23_2 = L23_2.p
      L22_2 = L22_2(L23_2)
      L21_2.by = L22_2
      L16_2(L17_2, L18_2, L19_2, L20_2, L21_2)
      L16_2 = L65_1
      L17_2 = L2_2.def
      L18_2 = L5_2
      L19_2 = L15_2
      L16_2(L17_2, L18_2, L19_2)
    end
  end
  L13_2 = L56_1
  L14_2 = L4_2.id
  L13_2 = L13_2(L14_2)
  L4_2 = L13_2
  L13_2 = L65_1
  L14_2 = L2_2.def
  L15_2 = L2_2.mod
  L16_2 = L4_2
  L13_2(L14_2, L15_2, L16_2)
  L13_2 = {}
  L13_2.ok = true
  L14_2 = {}
  L15_2 = tonumber
  L16_2 = L12_2.id
  L15_2 = L15_2(L16_2)
  L14_2.id = L15_2
  L14_2.amount = L9_2
  L14_2.status = "pending"
  L15_2 = L12_2.society
  L14_2.society = L15_2
  L13_2.bill = L14_2
  L14_2 = L61_1
  L15_2 = L4_2
  L16_2 = L2_2
  L17_2 = true
  L14_2 = L14_2(L15_2, L16_2, L17_2)
  L13_2.item = L14_2
  return L13_2
end
L111_1["capps.bill"] = L112_1
L111_1 = RPC
function L112_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2, L19_2, L20_2, L21_2
  L2_2 = L40_1
  L3_2 = A0_2
  L4_2 = A1_2.app
  L5_2 = A1_2.module
  L6_2 = "staff"
  L2_2, L3_2 = L2_2(L3_2, L4_2, L5_2, L6_2)
  if not L2_2 then
    L4_2 = {}
    L4_2.error = L3_2
    return L4_2
  end
  L4_2 = L2_2.kind
  if "bill" ~= L4_2 then
    L4_2 = {}
    L4_2.error = "module"
    return L4_2
  end
  L4_2 = L39_1
  L5_2 = L2_2
  L6_2 = "create"
  L4_2 = L4_2(L5_2, L6_2)
  if not L4_2 then
    L4_2 = {}
    L4_2.error = "grade"
    return L4_2
  end
  L4_2 = {}
  L5_2 = L25_1
  L6_2 = A0_2
  L5_2 = L5_2(L6_2)
  if L5_2 then
    L6_2 = ipairs
    L7_2 = FW
    L7_2 = L7_2.GetPlayers
    L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2, L19_2, L20_2, L21_2 = L7_2()
    L6_2, L7_2, L8_2, L9_2 = L6_2(L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2, L19_2, L20_2, L21_2)
    for L10_2, L11_2 in L6_2, L7_2, L8_2, L9_2 do
      if L11_2 ~= A0_2 then
        L12_2 = L25_1
        L13_2 = L11_2
        L12_2 = L12_2(L13_2)
        if L12_2 then
          L13_2 = L5_2.x
          L14_2 = L12_2.x
          L13_2 = L13_2 - L14_2
          L14_2 = L5_2.y
          L15_2 = L12_2.y
          L14_2 = L14_2 - L15_2
          L15_2 = L5_2.z
          L16_2 = L12_2.z
          L15_2 = L15_2 - L16_2
          L16_2 = math
          L16_2 = L16_2.sqrt
          L17_2 = L13_2 * L13_2
          L18_2 = L14_2 * L14_2
          L17_2 = L17_2 + L18_2
          L18_2 = L15_2 * L15_2
          L17_2 = L17_2 + L18_2
          L16_2 = L16_2(L17_2)
          if L16_2 <= 10.0 then
            L17_2 = FW
            L17_2 = L17_2.GetPlayer
            L18_2 = L11_2
            L17_2 = L17_2(L18_2)
            if L17_2 then
              L18_2 = #L4_2
              L18_2 = L18_2 + 1
              L19_2 = {}
              L19_2.id = L11_2
              L20_2 = L24_1
              L21_2 = L17_2
              L20_2 = L20_2(L21_2)
              if not L20_2 then
                L20_2 = "#"
                L21_2 = L11_2
                L20_2 = L20_2 .. L21_2
              end
              L19_2.name = L20_2
              L20_2 = math
              L20_2 = L20_2.floor
              L21_2 = L16_2 * 10
              L21_2 = L21_2 + 0.5
              L20_2 = L20_2(L21_2)
              L20_2 = L20_2 / 10
              L19_2.dist = L20_2
              L4_2[L18_2] = L19_2
            end
          end
        end
      end
    end
  else
    L6_2 = {}
    L7_2 = ipairs
    L8_2 = L17_1
    L9_2 = A1_2.ids
    L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2, L19_2, L20_2, L21_2 = L8_2(L9_2)
    L7_2, L8_2, L9_2, L10_2 = L7_2(L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2, L19_2, L20_2, L21_2)
    for L11_2, L12_2 in L7_2, L8_2, L9_2, L10_2 do
      L13_2 = math
      L13_2 = L13_2.tointeger
      L14_2 = tonumber
      L15_2 = L12_2
      L14_2, L15_2, L16_2, L17_2, L18_2, L19_2, L20_2, L21_2 = L14_2(L15_2)
      L13_2 = L13_2(L14_2, L15_2, L16_2, L17_2, L18_2, L19_2, L20_2, L21_2)
      if L13_2 and L13_2 ~= A0_2 then
        L14_2 = L6_2[L13_2]
        if not L14_2 then
          L6_2[L13_2] = true
          L14_2 = FW
          L14_2 = L14_2.GetPlayer
          L15_2 = L13_2
          L14_2 = L14_2(L15_2)
          if L14_2 then
            L15_2 = #L4_2
            L15_2 = L15_2 + 1
            L16_2 = {}
            L16_2.id = L13_2
            L17_2 = L24_1
            L18_2 = L14_2
            L17_2 = L17_2(L18_2)
            if not L17_2 then
              L17_2 = "#"
              L18_2 = L13_2
              L17_2 = L17_2 .. L18_2
            end
            L16_2.name = L17_2
            L4_2[L15_2] = L16_2
          end
        end
      end
      L14_2 = #L4_2
      if L14_2 >= 16 then
        break
      end
    end
  end
  L6_2 = table
  L6_2 = L6_2.sort
  L7_2 = L4_2
  function L8_2(A0_3, A1_3)
    local L2_3, L3_3
    L2_3 = A0_3.dist
    if not L2_3 then
      L2_3 = 99
    end
    L3_3 = A1_3.dist
    if not L3_3 then
      L3_3 = 99
    end
    L2_3 = L2_3 < L3_3
    return L2_3
  end
  L6_2(L7_2, L8_2)
  L6_2 = {}
  L6_2.players = L4_2
  L7_2 = nil ~= L5_2
  L6_2.onesync = L7_2
  return L6_2
end
L111_1["capps.nearby"] = L112_1
L111_1 = {}
L112_1 = {}
L113_1 = {}
function L114_1()
  local L0_2, L1_2, L2_2, L3_2, L4_2, L5_2
  L0_2 = os
  L0_2 = L0_2.date
  L1_2 = "*t"
  L0_2 = L0_2(L1_2)
  L1_2 = L0_2.wday
  if 1 == L1_2 then
    L1_2 = 7
    if L1_2 then
      goto lbl_14
    end
  end
  L1_2 = L0_2.wday
  L1_2 = L1_2 - 1
  ::lbl_14::
  L2_2 = os
  L2_2 = L2_2.time
  L3_2 = {}
  L4_2 = L0_2.year
  L3_2.year = L4_2
  L4_2 = L0_2.month
  L3_2.month = L4_2
  L4_2 = L0_2.day
  L5_2 = L1_2 - 1
  L4_2 = L4_2 - L5_2
  L3_2.day = L4_2
  L3_2.hour = 0
  L3_2.min = 0
  L3_2.sec = 0
  L2_2 = L2_2(L3_2)
  L2_2 = L2_2 * 1000
  return L2_2
end
function L115_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2
  L2_2 = L22_1
  L3_2 = A0_2.data
  L2_2 = L2_2(L3_2)
  if not L2_2 then
    L2_2 = {}
  end
  L3_2 = tonumber
  L4_2 = A0_2.at
  L3_2 = L3_2(L4_2)
  if not L3_2 then
    L3_2 = tonumber
    L4_2 = L2_2.start
    L3_2 = L3_2(L4_2)
    if not L3_2 then
      L3_2 = A1_2
    end
  end
  L4_2 = math
  L4_2 = L4_2.max
  L5_2 = 0
  L6_2 = math
  L6_2 = L6_2.min
  L7_2 = 1440
  L8_2 = math
  L8_2 = L8_2.floor
  L9_2 = A1_2 - L3_2
  L9_2 = L9_2 / 60000
  L9_2 = L9_2 + 0.5
  L8_2 = L8_2(L9_2)
  L6_2 = L6_2(L7_2, L8_2)
  L4_2 = L4_2(L5_2, L6_2)
  L5_2 = A1_2
  L2_2.minutes = L4_2
  L2_2.stop = L5_2
  L5_2 = MySQL
  L5_2 = L5_2.update
  L5_2 = L5_2.await
  L6_2 = "UPDATE apex_phone_capp_items SET status = ?, data = ?, updated = ? WHERE id = ? AND status = ?"
  L7_2 = {}
  L8_2 = "closed"
  L9_2 = L21_1
  L10_2 = L2_2
  L9_2 = L9_2(L10_2)
  L10_2 = A1_2
  L11_2 = tonumber
  L12_2 = A0_2.id
  L11_2 = L11_2(L12_2)
  L12_2 = "open"
  L7_2[1] = L8_2
  L7_2[2] = L9_2
  L7_2[3] = L10_2
  L7_2[4] = L11_2
  L7_2[5] = L12_2
  L5_2(L6_2, L7_2)
end
function L116_1(A0_2)
  local L1_2, L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2
  L1_2 = FW
  L1_2 = L1_2.GetPlayer
  L2_2 = A0_2
  L1_2 = L1_2(L2_2)
  if L1_2 then
    L2_2 = L1_2.cid
    if L2_2 then
      L2_2 = L54_1
      if L2_2 then
        goto lbl_14
      end
    end
  end
  do return end
  ::lbl_14::
  L2_2 = L1_2.cid
  L3_2 = L111_1
  L3_2 = L3_2[L2_2]
  if L3_2 then
    return
  end
  L3_2 = L111_1
  L3_2[L2_2] = true
  L3_2 = pcall
  function L4_2()
    local L0_3, L1_3, L2_3, L3_3, L4_3, L5_3, L6_3, L7_3, L8_3, L9_3, L10_3, L11_3, L12_3, L13_3, L14_3, L15_3, L16_3, L17_3, L18_3, L19_3, L20_3, L21_3, L22_3, L23_3, L24_3
    L0_3 = ipairs
    L1_3 = L7_1
    L0_3, L1_3, L2_3, L3_3 = L0_3(L1_3)
    for L4_3, L5_3 in L0_3, L1_3, L2_3, L3_3 do
      L6_3 = L33_1
      L7_3 = L1_2
      L8_3 = L5_3
      L6_3 = L6_3(L7_3, L8_3)
      if L6_3 then
        L7_3 = L6_3.member
        if L7_3 then
          L7_3 = ipairs
          L8_3 = L5_3.modules
          L7_3, L8_3, L9_3, L10_3 = L7_3(L8_3)
          for L11_3, L12_3 in L7_3, L8_3, L9_3, L10_3 do
            L13_3 = L12_3.type
            if "duty" == L13_3 then
              L13_3 = L12_3.enabled
              if false ~= L13_3 then
                L13_3 = L37_1
                L14_3 = L6_3
                L15_3 = L12_3
                L13_3 = L13_3(L14_3, L15_3)
                if L13_3 then
                  L13_3 = MySQL
                  L13_3 = L13_3.query
                  L13_3 = L13_3.await
                  L14_3 = "SELECT * FROM apex_phone_capp_items WHERE app = ? AND module = ? AND kind = 'shift' AND owner = ? AND status = 'open' ORDER BY id DESC LIMIT 5"
                  L15_3 = {}
                  L16_3 = L5_3.id
                  L17_3 = L12_3.id
                  L18_3 = L2_2
                  L15_3[1] = L16_3
                  L15_3[2] = L17_3
                  L15_3[3] = L18_3
                  L13_3 = L13_3(L14_3, L15_3)
                  if not L13_3 then
                    L13_3 = {}
                  end
                  L14_3 = Now
                  L14_3 = L14_3()
                  L15_3 = nil
                  L16_3 = L6_3.onduty
                  if L16_3 then
                    L16_3 = #L13_3
                    if 0 == L16_3 then
                      L16_3 = L103_1
                      L17_3 = {}
                      L18_3 = L5_3.id
                      L17_3.app = L18_3
                      L18_3 = L12_3.id
                      L17_3.module = L18_3
                      L17_3.kind = "shift"
                      L17_3.status = "open"
                      L18_3 = L24_1
                      L19_3 = L1_2
                      L18_3 = L18_3(L19_3)
                      if not L18_3 then
                        L18_3 = L2_2
                      end
                      L17_3.title = L18_3
                      L18_3 = L2_2
                      L17_3.owner = L18_3
                      L18_3 = L24_1
                      L19_3 = L1_2
                      L18_3 = L18_3(L19_3)
                      L17_3.owner_name = L18_3
                      L18_3 = L2_2
                      L17_3.assignee = L18_3
                      L18_3 = L24_1
                      L19_3 = L1_2
                      L18_3 = L18_3(L19_3)
                      L17_3.assignee_name = L18_3
                      L17_3.at = L14_3
                      L18_3 = {}
                      L18_3.start = L14_3
                      L19_3 = L6_3.job
                      L18_3.job = L19_3
                      L17_3.data = L18_3
                      L16_3 = L16_3(L17_3)
                      L15_3 = L16_3 or L15_3
                      if L16_3 then
                        L17_3 = L56_1
                        L18_3 = L16_3
                        L17_3 = L17_3(L18_3)
                        L15_3 = L17_3
                      end
                  end
                  else
                    L16_3 = L6_3.onduty
                    if not L16_3 then
                      L16_3 = #L13_3
                      if L16_3 > 0 then
                        L16_3 = ipairs
                        L17_3 = L13_3
                        L16_3, L17_3, L18_3, L19_3 = L16_3(L17_3)
                        for L20_3, L21_3 in L16_3, L17_3, L18_3, L19_3 do
                          L22_3 = L115_1
                          L23_3 = L21_3
                          L24_3 = L14_3
                          L22_3(L23_3, L24_3)
                        end
                        L16_3 = L56_1
                        L17_3 = L13_3[1]
                        L17_3 = L17_3.id
                        L16_3 = L16_3(L17_3)
                        L15_3 = L16_3
                    end
                    else
                      L16_3 = #L13_3
                      if L16_3 > 1 then
                        L16_3 = 2
                        L17_3 = #L13_3
                        L18_3 = 1
                        for L19_3 = L16_3, L17_3, L18_3 do
                          L20_3 = L115_1
                          L21_3 = L13_3[L19_3]
                          L22_3 = L14_3
                          L20_3(L21_3, L22_3)
                        end
                      end
                    end
                  end
                  if L15_3 then
                    L17_3 = A0_2
                    L16_3 = L112_1
                    L18_3 = L2_2
                    L16_3[L17_3] = L18_3
                    L16_3 = L72_1
                    L17_3 = L5_3
                    L18_3 = "duty.changed"
                    L19_3 = L12_3
                    L20_3 = L15_3
                    L16_3(L17_3, L18_3, L19_3, L20_3)
                    L16_3 = L65_1
                    L17_3 = L5_3
                    L18_3 = L12_3
                    L19_3 = L15_3
                    L16_3(L17_3, L18_3, L19_3)
                  end
                end
              end
            end
          end
        end
      end
    end
  end
  L3_2, L4_2 = L3_2(L4_2)
  L5_2 = L111_1
  L5_2[L2_2] = nil
  if not L3_2 then
    L5_2 = print
    L6_2 = "^1[unique_phone]^0 job apps (shifts): %s"
    L7_2 = L6_2
    L6_2 = L6_2.format
    L8_2 = tostring
    L9_2 = L4_2
    L8_2, L9_2 = L8_2(L9_2)
    L6_2, L7_2, L8_2, L9_2 = L6_2(L7_2, L8_2, L9_2)
    L5_2(L6_2, L7_2, L8_2, L9_2)
  end
end
function L117_1(A0_2)
  local L1_2, L2_2
  L1_2 = tonumber
  L2_2 = A0_2
  L1_2 = L1_2(L2_2)
  A0_2 = L1_2
  if not A0_2 or A0_2 <= 0 then
    return
  end
  L1_2 = L113_1
  L1_2 = L1_2[A0_2]
  if L1_2 then
    L1_2 = GetGameTimer
    L1_2 = L1_2()
    L2_2 = L113_1
    L2_2 = L2_2[A0_2]
    L1_2 = L1_2 - L2_2
    L2_2 = 3000
    if L1_2 < L2_2 then
      return
    end
  end
  L1_2 = CreateThread
  function L2_2()
    local L0_3, L1_3
    L0_3 = Wait
    L1_3 = 400
    L0_3(L1_3)
    L0_3 = L116_1
    L1_3 = A0_2
    L0_3(L1_3)
  end
  L1_2(L2_2)
end
L118_1 = AddEventHandler
L119_1 = "QBCore:Server:SetDuty"
function L120_1(A0_2)
  local L1_2, L2_2
  L1_2 = L117_1
  L2_2 = A0_2
  L1_2(L2_2)
end
L118_1(L119_1, L120_1)
L118_1 = AddEventHandler
L119_1 = "QBCore:Server:OnJobUpdate"
function L120_1(A0_2)
  local L1_2, L2_2
  L1_2 = L117_1
  L2_2 = A0_2
  L1_2(L2_2)
end
L118_1(L119_1, L120_1)
L118_1 = AddEventHandler
L119_1 = "esx:setJob"
function L120_1(A0_2)
  local L1_2, L2_2
  L1_2 = L117_1
  L2_2 = A0_2
  L1_2(L2_2)
end
L118_1(L119_1, L120_1)
L118_1 = FW
L118_1 = L118_1.OnPlayerLoaded
if L118_1 then
  L118_1 = FW
  L118_1 = L118_1.OnPlayerLoaded
  function L119_1(A0_2)
    local L1_2, L2_2
    L1_2 = L117_1
    L2_2 = A0_2
    L1_2(L2_2)
  end
  L118_1(L119_1)
end
L118_1 = AddEventHandler
L119_1 = "playerDropped"
function L120_1()
  local L0_2, L1_2, L2_2, L3_2, L4_2, L5_2, L6_2, L7_2
  L0_2 = source
  L1_2 = L85_1
  L2_2 = L86_1
  L3_2 = L87_1
  L4_2 = L113_1
  L5_2 = nil
  L6_2 = nil
  L7_2 = nil
  L4_2[L0_2] = nil
  L3_2[L0_2] = L7_2
  L2_2[L0_2] = L6_2
  L1_2[L0_2] = L5_2
  L1_2 = L112_1
  L1_2 = L1_2[L0_2]
  L2_2 = L112_1
  L2_2[L0_2] = nil
  if L1_2 then
    L2_2 = L54_1
    if L2_2 then
      goto lbl_21
    end
  end
  do return end
  ::lbl_21::
  L2_2 = CreateThread
  function L3_2()
    local L0_3, L1_3, L2_3, L3_3, L4_3, L5_3, L6_3, L7_3, L8_3, L9_3, L10_3, L11_3, L12_3
    L0_3 = Now
    L0_3 = L0_3()
    L1_3 = ipairs
    L2_3 = MySQL
    L2_3 = L2_3.query
    L2_3 = L2_3.await
    L3_3 = "SELECT * FROM apex_phone_capp_items WHERE kind = 'shift' AND owner = ? AND status = 'open'"
    L4_3 = {}
    L5_3 = L1_2
    L4_3[1] = L5_3
    L2_3 = L2_3(L3_3, L4_3)
    if not L2_3 then
      L2_3 = {}
    end
    L1_3, L2_3, L3_3, L4_3 = L1_3(L2_3)
    for L5_3, L6_3 in L1_3, L2_3, L3_3, L4_3 do
      L7_3 = L115_1
      L8_3 = L6_3
      L9_3 = L0_3
      L7_3(L8_3, L9_3)
      L8_3 = L6_3.app
      L7_3 = L6_1
      L7_3 = L7_3[L8_3]
      L8_3 = L7_3 or L8_3
      if L7_3 then
        L8_3 = L30_1
        L9_3 = L7_3
        L10_3 = L6_3.module
        L8_3 = L8_3(L9_3, L10_3)
      end
      if L7_3 and L8_3 then
        L9_3 = L65_1
        L10_3 = L7_3
        L11_3 = L8_3
        L12_3 = L6_3
        L9_3(L10_3, L11_3, L12_3)
      end
    end
  end
  L2_2(L3_2)
end
L118_1(L119_1, L120_1)
function L118_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2, L19_2, L20_2, L21_2, L22_2, L23_2, L24_2
  L2_2 = L34_1
  L3_2 = A0_2
  L4_2 = A1_2.def
  L2_2 = L2_2(L3_2, L4_2)
  if not L2_2 then
    L2_2 = A1_2.acc
  end
  L3_2 = A1_2.mod
  L3_2 = L3_2.options
  L4_2 = false
  L5_2 = "server"
  L6_2 = FW
  L6_2 = L6_2.DutySupported
  if L6_2 then
    L6_2 = FW
    L6_2 = L6_2.DutySupported
    L7_2 = A0_2
    L8_2 = L3_2
    L6_2, L7_2 = L6_2(L7_2, L8_2)
    L5_2 = L7_2
    L4_2 = L6_2
  end
  L6_2 = {}
  L6_2.ok = true
  L7_2 = true == L4_2
  L6_2.supported = L7_2
  L6_2.mode = L5_2
  L7_2 = L2_2.onduty
  L7_2 = true == L7_2
  L6_2.onduty = L7_2
  L7_2 = L2_2.jobLabel
  L6_2.job = L7_2
  L7_2 = Now
  L7_2 = L7_2()
  L8_2 = L114_1
  L8_2 = L8_2()
  L9_2 = MySQL
  L9_2 = L9_2.query
  L9_2 = L9_2.await
  L10_2 = "SELECT * FROM apex_phone_capp_items WHERE app = ? AND module = ? AND kind = 'shift' AND owner = ? AND at >= ? ORDER BY at DESC LIMIT 200"
  L11_2 = {}
  L12_2 = A1_2.def
  L12_2 = L12_2.id
  L13_2 = A1_2.mod
  L13_2 = L13_2.id
  L14_2 = A1_2.cid
  L15_2 = L8_2
  L11_2[1] = L12_2
  L11_2[2] = L13_2
  L11_2[3] = L14_2
  L11_2[4] = L15_2
  L9_2 = L9_2(L10_2, L11_2)
  if not L9_2 then
    L9_2 = {}
  end
  L10_2 = 0
  L11_2 = ipairs
  L12_2 = L9_2
  L11_2, L12_2, L13_2, L14_2 = L11_2(L12_2)
  for L15_2, L16_2 in L11_2, L12_2, L13_2, L14_2 do
    L17_2 = L16_2.status
    if "open" == L17_2 then
      L17_2 = tonumber
      L18_2 = L16_2.at
      L17_2 = L17_2(L18_2)
      L6_2.since = L17_2
      L17_2 = math
      L17_2 = L17_2.floor
      L18_2 = tonumber
      L19_2 = L16_2.at
      L18_2 = L18_2(L19_2)
      if not L18_2 then
        L18_2 = L7_2
      end
      L18_2 = L7_2 - L18_2
      L18_2 = L18_2 / 60000
      L17_2 = L17_2(L18_2)
      L10_2 = L10_2 + L17_2
    else
      L17_2 = L22_1
      L18_2 = L16_2.data
      L17_2 = L17_2(L18_2)
      if not L17_2 then
        L17_2 = {}
      end
      L18_2 = tonumber
      L19_2 = L17_2.minutes
      L18_2 = L18_2(L19_2)
      if not L18_2 then
        L18_2 = 0
      end
      L10_2 = L10_2 + L18_2
    end
  end
  L6_2.week = L10_2
  L11_2 = MySQL
  L11_2 = L11_2.query
  L11_2 = L11_2.await
  L12_2 = "SELECT * FROM apex_phone_capp_items WHERE app = ? AND module = ? AND kind = 'shift' AND owner = ? AND status = 'closed' ORDER BY at DESC LIMIT 6"
  L13_2 = {}
  L14_2 = A1_2.def
  L14_2 = L14_2.id
  L15_2 = A1_2.mod
  L15_2 = L15_2.id
  L16_2 = A1_2.cid
  L13_2[1] = L14_2
  L13_2[2] = L15_2
  L13_2[3] = L16_2
  L11_2 = L11_2(L12_2, L13_2)
  if not L11_2 then
    L11_2 = {}
  end
  L12_2 = {}
  L6_2.shifts = L12_2
  L12_2 = ipairs
  L13_2 = L11_2
  L12_2, L13_2, L14_2, L15_2 = L12_2(L13_2)
  for L16_2, L17_2 in L12_2, L13_2, L14_2, L15_2 do
    L18_2 = L22_1
    L19_2 = L17_2.data
    L18_2 = L18_2(L19_2)
    if not L18_2 then
      L18_2 = {}
    end
    L19_2 = L6_2.shifts
    L20_2 = L6_2.shifts
    L20_2 = #L20_2
    L20_2 = L20_2 + 1
    L21_2 = {}
    L22_2 = tonumber
    L23_2 = L17_2.id
    L22_2 = L22_2(L23_2)
    L21_2.id = L22_2
    L22_2 = tonumber
    L23_2 = L17_2.at
    L22_2 = L22_2(L23_2)
    L21_2.at = L22_2
    L22_2 = tonumber
    L23_2 = L18_2.stop
    L22_2 = L22_2(L23_2)
    L21_2.stop = L22_2
    L22_2 = tonumber
    L23_2 = L18_2.minutes
    L22_2 = L22_2(L23_2)
    if not L22_2 then
      L22_2 = 0
    end
    L21_2.minutes = L22_2
    L19_2[L20_2] = L21_2
  end
  L12_2 = L3_2.showTeam
  if false ~= L12_2 then
    L12_2 = L39_1
    L13_2 = A1_2
    L14_2 = "view"
    L12_2 = L12_2(L13_2, L14_2)
    if L12_2 then
      L12_2 = {}
      L13_2 = ipairs
      L14_2 = MySQL
      L14_2 = L14_2.query
      L14_2 = L14_2.await
      L15_2 = "SELECT owner, at FROM apex_phone_capp_items WHERE app = ? AND module = ? AND kind = 'shift' AND status = 'open'"
      L16_2 = {}
      L17_2 = A1_2.def
      L17_2 = L17_2.id
      L18_2 = A1_2.mod
      L18_2 = L18_2.id
      L16_2[1] = L17_2
      L16_2[2] = L18_2
      L14_2 = L14_2(L15_2, L16_2)
      if not L14_2 then
        L14_2 = {}
      end
      L13_2, L14_2, L15_2, L16_2 = L13_2(L14_2)
      for L17_2, L18_2 in L13_2, L14_2, L15_2, L16_2 do
        L19_2 = L18_2.owner
        if L19_2 then
          L19_2 = L18_2.owner
          L20_2 = tonumber
          L21_2 = L18_2.at
          L20_2 = L20_2(L21_2)
          L12_2[L19_2] = L20_2
        end
      end
      L13_2 = {}
      L14_2 = 0
      L15_2 = ipairs
      L16_2 = L110_1
      L17_2 = A1_2.def
      L18_2 = A1_2.mod
      L16_2, L17_2, L18_2, L19_2, L20_2, L21_2, L22_2, L23_2, L24_2 = L16_2(L17_2, L18_2)
      L15_2, L16_2, L17_2, L18_2 = L15_2(L16_2, L17_2, L18_2, L19_2, L20_2, L21_2, L22_2, L23_2, L24_2)
      for L19_2, L20_2 in L15_2, L16_2, L17_2, L18_2 do
        L21_2 = L20_2.acc
        L21_2 = L21_2.onduty
        if L21_2 then
          L21_2 = #L13_2
          L21_2 = L21_2 + 1
          L22_2 = {}
          L23_2 = L24_1
          L24_2 = L20_2.p
          L23_2 = L23_2(L24_2)
          if not L23_2 then
            L23_2 = "#"
            L24_2 = L20_2.src
            L23_2 = L23_2 .. L24_2
          end
          L22_2.name = L23_2
          L23_2 = L20_2.acc
          L23_2 = L23_2.gradeLabel
          L22_2.grade = L23_2
          L23_2 = L20_2.acc
          L23_2 = L23_2.grade
          L22_2.level = L23_2
          L23_2 = L20_2.acc
          L23_2 = L23_2.cid
          L23_2 = L12_2[L23_2]
          L22_2.since = L23_2
          L23_2 = GetPlayerNumber
          L24_2 = L20_2.src
          L23_2 = L23_2(L24_2)
          if not L23_2 then
            L23_2 = L20_2.p
            L23_2 = L23_2.phone
          end
          L22_2.phone = L23_2
          L23_2 = L20_2.src
          L23_2 = L23_2 == A0_2 or L23_2
          L22_2.me = L23_2
          L13_2[L21_2] = L22_2
          L21_2 = #L13_2
          if L21_2 >= 100 then
            break
          end
        else
          L14_2 = L14_2 + 1
        end
      end
      L15_2 = table
      L15_2 = L15_2.sort
      L16_2 = L13_2
      function L17_2(A0_3, A1_3)
        local L2_3, L3_3, L4_3
        L2_3 = A0_3.level
        L3_3 = A1_3.level
        if L2_3 ~= L3_3 then
          L2_3 = A0_3.level
          L3_3 = A1_3.level
          L2_3 = L2_3 > L3_3
          return L2_3
        end
        L2_3 = tostring
        L3_3 = A0_3.name
        L2_3 = L2_3(L3_3)
        L3_3 = tostring
        L4_3 = A1_3.name
        L3_3 = L3_3(L4_3)
        L2_3 = L2_3 < L3_3
        return L2_3
      end
      L15_2(L16_2, L17_2)
      L15_2 = L13_2
      L6_2.off = L14_2
      L6_2.team = L15_2
    end
  end
  return L6_2
end
L119_1 = RPC
function L120_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2
  L2_2 = L40_1
  L3_2 = A0_2
  L4_2 = A1_2.app
  L5_2 = A1_2.module
  L6_2 = "staff"
  L2_2, L3_2 = L2_2(L3_2, L4_2, L5_2, L6_2)
  if not L2_2 then
    L4_2 = {}
    L4_2.error = L3_2
    return L4_2
  end
  L4_2 = L2_2.kind
  if "shift" ~= L4_2 then
    L4_2 = {}
    L4_2.error = "module"
    return L4_2
  end
  L4_2 = A1_2.on
  if nil ~= L4_2 then
    L4_2 = A1_2.on
    L4_2 = true == L4_2
    L5_2 = L2_2.acc
    L5_2 = L5_2.onduty
    L5_2 = true == L5_2
    if L4_2 ~= L5_2 then
      L5_2 = L88_1
      L6_2 = L87_1
      L7_2 = A0_2
      L8_2 = 3
      L5_2 = L5_2(L6_2, L7_2, L8_2)
      if L5_2 > 0 then
        L6_2 = {}
        L6_2.error = "cooldown"
        L6_2.wait = L5_2
        return L6_2
      end
      L6_2 = FW
      L6_2 = L6_2.SetDuty
      if not L6_2 then
        L6_2 = {}
        L6_2.error = "duty"
        L6_2.reason = "server"
        return L6_2
      end
      L6_2 = L113_1
      L7_2 = GetGameTimer
      L7_2 = L7_2()
      L6_2[A0_2] = L7_2
      L6_2 = FW
      L6_2 = L6_2.SetDuty
      L7_2 = A0_2
      L8_2 = L4_2
      L9_2 = L2_2.mod
      L9_2 = L9_2.options
      L6_2, L7_2 = L6_2(L7_2, L8_2, L9_2)
      if not L6_2 then
        L8_2 = L113_1
        L8_2[A0_2] = nil
        L8_2 = {}
        L8_2.error = "duty"
        L8_2.reason = L7_2
        return L8_2
      end
      L8_2 = L87_1
      L9_2 = os
      L9_2 = L9_2.time
      L9_2 = L9_2()
      L8_2[A0_2] = L9_2
      L8_2 = L116_1
      L9_2 = A0_2
      L8_2(L9_2)
    end
  end
  L4_2 = L118_1
  L5_2 = A0_2
  L6_2 = L2_2
  return L4_2(L5_2, L6_2)
end
L119_1["capps.duty"] = L120_1
function L119_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2
  L2_2 = L61_1
  L3_2 = A0_2
  L4_2 = {}
  L4_2.side = "staff"
  L4_2.cid = ""
  L5_2 = A1_2
  L2_2 = L2_2(L3_2, L4_2, L5_2)
  L3_2 = tonumber
  L4_2 = A0_2.anonymous
  L3_2 = L3_2(L4_2)
  if 1 == L3_2 then
    L3_2 = nil
    L2_2.owner_phone = nil
    L2_2.owner_name = L3_2
  end
  return L2_2
end
L120_1 = OVRPC
function L121_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2, L19_2
  L2_2 = L54_1
  if not L2_2 then
    L2_2 = {}
    L2_2.ok = false
    L2_2.error = "db"
    return L2_2
  end
  L2_2 = {}
  L3_2 = "1 = 1"
  L2_2[1] = L3_2
  L3_2 = {}
  L4_2 = L16_1
  L5_2 = A1_2.app
  L4_2 = L4_2(L5_2)
  if L4_2 then
    L4_2 = #L2_2
    L4_2 = L4_2 + 1
    L2_2[L4_2] = "app = ?"
    L4_2 = #L3_2
    L4_2 = L4_2 + 1
    L5_2 = A1_2.app
    L3_2[L4_2] = L5_2
  end
  L4_2 = L16_1
  L5_2 = A1_2.module
  L6_2 = 24
  L4_2 = L4_2(L5_2, L6_2)
  if L4_2 then
    L4_2 = #L2_2
    L4_2 = L4_2 + 1
    L2_2[L4_2] = "module = ?"
    L4_2 = #L3_2
    L4_2 = L4_2 + 1
    L5_2 = A1_2.module
    L3_2[L4_2] = L5_2
  end
  L4_2 = L11_1
  L5_2 = A1_2.status
  L6_2 = 24
  L4_2 = L4_2(L5_2, L6_2)
  if L4_2 then
    L5_2 = #L2_2
    L5_2 = L5_2 + 1
    L2_2[L5_2] = "status = ?"
    L5_2 = #L3_2
    L5_2 = L5_2 + 1
    L3_2[L5_2] = L4_2
  end
  L5_2 = L20_1
  L6_2 = A1_2.q
  L5_2 = L5_2(L6_2)
  if L5_2 then
    L6_2 = #L2_2
    L6_2 = L6_2 + 1
    L2_2[L6_2] = "(title LIKE ? OR subject LIKE ? OR owner_name LIKE ?)"
    L6_2 = #L3_2
    L6_2 = L6_2 + 1
    L3_2[L6_2] = L5_2
    L6_2 = #L3_2
    L6_2 = L6_2 + 1
    L3_2[L6_2] = L5_2
    L6_2 = #L3_2
    L6_2 = L6_2 + 1
    L3_2[L6_2] = L5_2
  end
  L6_2 = table
  L6_2 = L6_2.concat
  L7_2 = L2_2
  L8_2 = " AND "
  L6_2 = L6_2(L7_2, L8_2)
  L7_2 = tonumber
  L8_2 = MySQL
  L8_2 = L8_2.scalar
  L8_2 = L8_2.await
  L9_2 = "SELECT COUNT(*) FROM apex_phone_capp_items WHERE "
  L10_2 = L6_2
  L9_2 = L9_2 .. L10_2
  L10_2 = L3_2
  L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2, L19_2 = L8_2(L9_2, L10_2)
  L7_2 = L7_2(L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2, L19_2)
  if not L7_2 then
    L7_2 = 0
  end
  L8_2 = L12_1
  L9_2 = A1_2.page
  L10_2 = 0
  L11_2 = 100000
  L12_2 = 0
  L8_2 = L8_2(L9_2, L10_2, L11_2, L12_2)
  L9_2 = L18_1
  L10_2 = L3_2
  L9_2 = L9_2(L10_2)
  L10_2 = #L9_2
  L10_2 = L10_2 + 1
  L11_2 = L1_1
  L9_2[L10_2] = L11_2
  L10_2 = #L9_2
  L10_2 = L10_2 + 1
  L11_2 = L1_1
  L11_2 = L8_2 * L11_2
  L9_2[L10_2] = L11_2
  L10_2 = {}
  L11_2 = ipairs
  L12_2 = MySQL
  L12_2 = L12_2.query
  L12_2 = L12_2.await
  L13_2 = "SELECT * FROM apex_phone_capp_items WHERE "
  L14_2 = L6_2
  L15_2 = " ORDER BY updated DESC, id DESC LIMIT ? OFFSET ?"
  L13_2 = L13_2 .. L14_2 .. L15_2
  L14_2 = L9_2
  L12_2 = L12_2(L13_2, L14_2)
  if not L12_2 then
    L12_2 = {}
  end
  L11_2, L12_2, L13_2, L14_2 = L11_2(L12_2)
  for L15_2, L16_2 in L11_2, L12_2, L13_2, L14_2 do
    L17_2 = L119_1
    L18_2 = L16_2
    L19_2 = false
    L17_2 = L17_2(L18_2, L19_2)
    L10_2[L15_2] = L17_2
  end
  L11_2 = {}
  L11_2.ok = true
  L11_2.items = L10_2
  L11_2.total = L7_2
  L11_2.page = L8_2
  L12_2 = math
  L12_2 = L12_2.max
  L13_2 = 1
  L14_2 = math
  L14_2 = L14_2.ceil
  L15_2 = L1_1
  L15_2 = L7_2 / L15_2
  L14_2 = L14_2(L15_2)
  L12_2 = L12_2(L13_2, L14_2)
  L11_2.pages = L12_2
  return L11_2
end
L120_1["admin.capps.items"] = L121_1
L120_1 = OVRPC
function L121_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2
  L2_2 = L56_1
  L3_2 = A1_2.id
  L2_2 = L2_2(L3_2)
  if not L2_2 then
    L3_2 = {}
    L3_2.ok = false
    L3_2.error = "notfound"
    return L3_2
  end
  L3_2 = {}
  L4_2 = ipairs
  L5_2 = MySQL
  L5_2 = L5_2.query
  L5_2 = L5_2.await
  L6_2 = "SELECT * FROM apex_phone_capp_notes WHERE item = ? ORDER BY id ASC LIMIT 200"
  L7_2 = {}
  L8_2 = tonumber
  L9_2 = L2_2.id
  L8_2, L9_2, L10_2, L11_2, L12_2, L13_2 = L8_2(L9_2)
  L7_2[1] = L8_2
  L7_2[2] = L9_2
  L7_2[3] = L10_2
  L7_2[4] = L11_2
  L7_2[5] = L12_2
  L7_2[6] = L13_2
  L5_2 = L5_2(L6_2, L7_2)
  if not L5_2 then
    L5_2 = {}
  end
  L4_2, L5_2, L6_2, L7_2 = L4_2(L5_2)
  for L8_2, L9_2 in L4_2, L5_2, L6_2, L7_2 do
    L10_2 = #L3_2
    L10_2 = L10_2 + 1
    L11_2 = L62_1
    L12_2 = L9_2
    L13_2 = {}
    L13_2.cid = ""
    L11_2 = L11_2(L12_2, L13_2)
    L3_2[L10_2] = L11_2
  end
  L4_2 = {}
  L4_2.ok = true
  L5_2 = L119_1
  L6_2 = L2_2
  L7_2 = true
  L5_2 = L5_2(L6_2, L7_2)
  L4_2.item = L5_2
  L4_2.notes = L3_2
  return L4_2
end
L120_1["admin.capps.item"] = L121_1
L120_1 = OVRPC
function L121_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2
  L2_2 = L56_1
  L3_2 = A1_2.id
  L2_2 = L2_2(L3_2)
  if not L2_2 then
    L3_2 = {}
    L3_2.ok = false
    L3_2.error = "notfound"
    return L3_2
  end
  L3_2 = MySQL
  L3_2 = L3_2.update
  L3_2 = L3_2.await
  L4_2 = "DELETE FROM apex_phone_capp_notes WHERE item = ?"
  L5_2 = {}
  L6_2 = tonumber
  L7_2 = L2_2.id
  L6_2, L7_2, L8_2, L9_2, L10_2, L11_2 = L6_2(L7_2)
  L5_2[1] = L6_2
  L5_2[2] = L7_2
  L5_2[3] = L8_2
  L5_2[4] = L9_2
  L5_2[5] = L10_2
  L5_2[6] = L11_2
  L3_2(L4_2, L5_2)
  L3_2 = MySQL
  L3_2 = L3_2.update
  L3_2 = L3_2.await
  L4_2 = "DELETE FROM apex_phone_capp_items WHERE id = ?"
  L5_2 = {}
  L6_2 = tonumber
  L7_2 = L2_2.id
  L6_2, L7_2, L8_2, L9_2, L10_2, L11_2 = L6_2(L7_2)
  L5_2[1] = L6_2
  L5_2[2] = L7_2
  L5_2[3] = L8_2
  L5_2[4] = L9_2
  L5_2[5] = L10_2
  L5_2[6] = L11_2
  L3_2(L4_2, L5_2)
  L3_2 = AdminStore
  L3_2 = L3_2.Log
  L4_2 = A0_2
  L5_2 = "capps.item.delete"
  L6_2 = "%s/%s #%s"
  L7_2 = L6_2
  L6_2 = L6_2.format
  L8_2 = L2_2.app
  L9_2 = L2_2.module
  L10_2 = tostring
  L11_2 = L2_2.id
  L10_2, L11_2 = L10_2(L11_2)
  L6_2, L7_2, L8_2, L9_2, L10_2, L11_2 = L6_2(L7_2, L8_2, L9_2, L10_2, L11_2)
  L3_2(L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2)
  L4_2 = L2_2.app
  L3_2 = L6_1
  L3_2 = L3_2[L4_2]
  L4_2 = L3_2 or L4_2
  if L3_2 then
    L4_2 = L30_1
    L5_2 = L3_2
    L6_2 = L2_2.module
    L4_2 = L4_2(L5_2, L6_2)
  end
  if L3_2 and L4_2 then
    L5_2 = L65_1
    L6_2 = L3_2
    L7_2 = L4_2
    L8_2 = L2_2
    L9_2 = {}
    L9_2.deleted = true
    L5_2(L6_2, L7_2, L8_2, L9_2)
  end
  L5_2 = {}
  L5_2.ok = true
  return L5_2
end
L120_1["admin.capps.delete"] = L121_1
L120_1 = OVRPC
function L121_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2
  L2_2 = L16_1
  L3_2 = A1_2.app
  L2_2 = L2_2(L3_2)
  if not L2_2 then
    L2_2 = {}
    L2_2.ok = false
    L2_2.error = "invalid"
    return L2_2
  end
  L2_2 = MySQL
  L2_2 = L2_2.update
  L2_2 = L2_2.await
  L3_2 = "DELETE n FROM apex_phone_capp_notes n JOIN apex_phone_capp_items i ON i.id = n.item WHERE i.app = ?"
  L4_2 = {}
  L5_2 = A1_2.app
  L4_2[1] = L5_2
  L2_2(L3_2, L4_2)
  L2_2 = MySQL
  L2_2 = L2_2.update
  L2_2 = L2_2.await
  L3_2 = "DELETE FROM apex_phone_capp_items WHERE app = ?"
  L4_2 = {}
  L5_2 = A1_2.app
  L4_2[1] = L5_2
  L2_2 = L2_2(L3_2, L4_2)
  L3_2 = AdminStore
  L3_2 = L3_2.Log
  L4_2 = A0_2
  L5_2 = "capps.purge"
  L6_2 = "%s: %s registo(s)"
  L7_2 = L6_2
  L6_2 = L6_2.format
  L8_2 = A1_2.app
  L9_2 = tostring
  L10_2 = L2_2
  L9_2, L10_2, L11_2, L12_2, L13_2 = L9_2(L10_2)
  L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2 = L6_2(L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2)
  L3_2(L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2)
  L3_2 = ipairs
  L4_2 = FW
  L4_2 = L4_2.GetPlayers
  L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2 = L4_2()
  L3_2, L4_2, L5_2, L6_2 = L3_2(L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2)
  for L7_2, L8_2 in L3_2, L4_2, L5_2, L6_2 do
    L9_2 = Push
    L10_2 = L8_2
    L11_2 = "capps:changed"
    L12_2 = {}
    L13_2 = A1_2.app
    L12_2.app = L13_2
    L12_2.purged = true
    L9_2(L10_2, L11_2, L12_2)
  end
  L3_2 = {}
  L3_2.ok = true
  L4_2 = tonumber
  L5_2 = L2_2
  L4_2 = L4_2(L5_2)
  if not L4_2 then
    L4_2 = 0
  end
  L3_2.deleted = L4_2
  return L3_2
end
L120_1["admin.capps.purge"] = L121_1
L120_1 = OVRPC
function L121_1()
  local L0_2, L1_2, L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2
  L0_2 = {}
  L1_2 = L54_1
  if not L1_2 then
    L1_2 = {}
    L1_2.ok = true
    L1_2.apps = L0_2
    return L1_2
  end
  L1_2 = MySQL
  L1_2 = L1_2.query
  L1_2 = L1_2.await
  L2_2 = "SELECT app, module, kind, status, COUNT(*) AS n, MAX(updated) AS last FROM apex_phone_capp_items GROUP BY app, module, kind, status"
  L1_2 = L1_2(L2_2)
  if not L1_2 then
    L1_2 = {}
  end
  L2_2 = {}
  L2_2.form = true
  L2_2.appt = true
  L2_2.call = true
  L2_2.order = true
  L3_2 = ipairs
  L4_2 = L1_2
  L3_2, L4_2, L5_2, L6_2 = L3_2(L4_2)
  for L7_2, L8_2 in L3_2, L4_2, L5_2, L6_2 do
    L9_2 = L8_2.app
    L9_2 = L0_2[L9_2]
    if not L9_2 then
      L9_2 = {}
      L9_2.open = 0
      L9_2.total = 0
      L9_2.last = 0
    end
    L10_2 = tonumber
    L11_2 = L8_2.n
    L10_2 = L10_2(L11_2)
    if not L10_2 then
      L10_2 = 0
    end
    L11_2 = L9_2.total
    L11_2 = L11_2 + L10_2
    L9_2.total = L11_2
    L12_2 = L8_2.app
    L11_2 = L6_1
    L11_2 = L11_2[L12_2]
    L12_2 = L11_2 or L12_2
    if L11_2 then
      L12_2 = L30_1
      L13_2 = L11_2
      L14_2 = L8_2.module
      L12_2 = L12_2(L13_2, L14_2)
    end
    L13_2 = L8_2.kind
    L13_2 = L2_2[L13_2]
    if L13_2 then
      if L12_2 then
        L13_2 = L49_1
        L14_2 = L12_2
        L15_2 = L8_2.kind
        L16_2 = L8_2.status
        L13_2 = L13_2(L14_2, L15_2, L16_2)
        if L13_2 then
          goto lbl_89
        end
      end
      if not L12_2 then
        L13_2 = L8_2.status
        if "done" == L13_2 then
          goto lbl_89
        end
        L13_2 = L8_2.status
        if "cancelled" == L13_2 then
          goto lbl_89
        end
        L13_2 = L8_2.status
        if "closed" == L13_2 then
          goto lbl_89
        end
        L13_2 = L8_2.status
        if "delivered" == L13_2 then
          goto lbl_89
        end
      end
      L13_2 = L9_2.open
      L13_2 = L13_2 + L10_2
      L9_2.open = L13_2
    end
    ::lbl_89::
    L13_2 = math
    L13_2 = L13_2.max
    L14_2 = L9_2.last
    L15_2 = tonumber
    L16_2 = L8_2.last
    L15_2 = L15_2(L16_2)
    if not L15_2 then
      L15_2 = 0
    end
    L13_2 = L13_2(L14_2, L15_2)
    L9_2.last = L13_2
    L13_2 = L8_2.app
    L0_2[L13_2] = L9_2
  end
  L3_2 = {}
  L3_2.ok = true
  L3_2.apps = L0_2
  return L3_2
end
L120_1["admin.capps.stats"] = L121_1
L120_1 = OVRPC
function L121_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2
  L2_2 = L16_1
  L3_2 = A1_2.app
  L2_2 = L2_2(L3_2)
  if L2_2 then
    L3_2 = A1_2.app
    L2_2 = L6_1
    L2_2 = L2_2[L3_2]
    if L2_2 then
      goto lbl_12
    end
  end
  L2_2 = nil
  ::lbl_12::
  L3_2 = A1_2.url
  if nil ~= L3_2 and "" ~= L3_2 then
    L4_2 = ValidWebhookUrl
    L5_2 = L3_2
    L4_2 = L4_2(L5_2)
    if not L4_2 then
      L4_2 = {}
      L4_2.ok = false
      L4_2.error = "url"
      return L4_2
    end
  else
    if L2_2 then
      L4_2 = L70_1
      L5_2 = L2_2
      L6_2 = "test"
      L4_2 = L4_2(L5_2, L6_2)
      if L4_2 then
        goto lbl_37
        L3_2 = L4_2 or L3_2
      end
    end
    L3_2 = nil
    ::lbl_37::
    if not L3_2 then
      L4_2 = {}
      L4_2.ok = false
      L4_2.error = "nourl"
      return L4_2
    end
  end
  if L2_2 then
    L4_2 = L2_2.name
    if L4_2 then
      goto lbl_56
    end
  end
  L4_2 = L11_1
  L5_2 = A1_2.name
  L6_2 = 40
  L4_2 = L4_2(L5_2, L6_2)
  if not L4_2 then
    L4_2 = "App"
  end
  ::lbl_56::
  L5_2 = PostWebhook
  L6_2 = L3_2
  L7_2 = {}
  L8_2 = {}
  L9_2 = WebhookEmbed
  L10_2 = {}
  L11_2 = tostring
  L12_2 = L4_2
  L11_2 = L11_2(L12_2)
  L12_2 = " \194\183 "
  L13_2 = L69_1.test
  L11_2 = L11_2 .. L12_2 .. L13_2
  L10_2.title = L11_2
  L10_2.description = "Se est\195\161s a ver isto, o webhook desta app est\195\161 a funcionar."
  if L2_2 then
    L11_2 = L2_2.accent
    if L11_2 then
      goto lbl_79
    end
  end
  L11_2 = "#1F5EFF"
  ::lbl_79::
  L10_2.color = L11_2
  L11_2 = {}
  L12_2 = {}
  L12_2.name = "Enviado por"
  L13_2 = AdminName
  L14_2 = A0_2
  L13_2 = L13_2(L14_2)
  L12_2.value = L13_2
  L12_2.inline = true
  L13_2 = {}
  L13_2.name = "App"
  if L2_2 then
    L14_2 = L2_2.id
    if L14_2 then
      goto lbl_99
    end
  end
  L14_2 = "--"
  ::lbl_99::
  L13_2.value = L14_2
  L13_2.inline = true
  L11_2[1] = L12_2
  L11_2[2] = L13_2
  L10_2.fields = L11_2
  L10_2.footer = "Apex Phone"
  L9_2, L10_2, L11_2, L12_2, L13_2, L14_2 = L9_2(L10_2)
  L8_2[1] = L9_2
  L8_2[2] = L10_2
  L8_2[3] = L11_2
  L8_2[4] = L12_2
  L8_2[5] = L13_2
  L8_2[6] = L14_2
  L7_2.embeds = L8_2
  L5_2 = L5_2(L6_2, L7_2)
  L6_2 = {}
  L7_2 = true == L5_2
  L6_2.ok = L7_2
  return L6_2
end
L120_1["admin.capps.testWebhook"] = L121_1
L120_1 = OVRPC
function L121_1()
  local L0_2, L1_2, L2_2, L3_2, L4_2, L5_2, L6_2
  L0_2 = FW
  L0_2 = L0_2.GetJobsList
  if not L0_2 then
    L0_2 = {}
    L0_2.ok = false
    L0_2.error = "jobs"
    return L0_2
  end
  L0_2 = pcall
  L1_2 = FW
  L1_2 = L1_2.GetJobsList
  L0_2, L1_2 = L0_2(L1_2)
  if L0_2 then
    L2_2 = type
    L3_2 = L1_2
    L2_2 = L2_2(L3_2)
    if "table" == L2_2 then
      goto lbl_34
    end
  end
  L2_2 = print
  L3_2 = "^3[unique_phone]^0 admin.capps.jobs: %s"
  L4_2 = L3_2
  L3_2 = L3_2.format
  L5_2 = tostring
  L6_2 = L1_2
  L5_2, L6_2 = L5_2(L6_2)
  L3_2, L4_2, L5_2, L6_2 = L3_2(L4_2, L5_2, L6_2)
  L2_2(L3_2, L4_2, L5_2, L6_2)
  L2_2 = {}
  L2_2.ok = false
  L2_2.error = "jobs"
  do return L2_2 end
  ::lbl_34::
  L2_2 = {}
  L2_2.ok = true
  L2_2.jobs = L1_2
  L3_2 = FW
  L3_2 = L3_2.name
  L2_2.framework = L3_2
  return L2_2
end
L120_1["admin.capps.jobs"] = L121_1
