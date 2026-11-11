local L0_1, L1_1, L2_1, L3_1, L4_1, L5_1, L6_1, L7_1, L8_1, L9_1, L10_1, L11_1, L12_1, L13_1, L14_1, L15_1, L16_1, L17_1, L18_1, L19_1, L20_1, L21_1, L22_1, L23_1, L24_1, L25_1, L26_1, L27_1, L28_1, L29_1, L30_1, L31_1, L32_1, L33_1, L34_1, L35_1, L36_1, L37_1, L38_1, L39_1, L40_1, L41_1, L42_1, L43_1, L44_1, L45_1, L46_1, L47_1, L48_1, L49_1, L50_1, L51_1, L52_1, L53_1, L54_1, L55_1, L56_1, L57_1, L58_1, L59_1, L60_1, L61_1, L62_1, L63_1, L64_1, L65_1, L66_1, L67_1, L68_1, L69_1, L70_1, L71_1, L72_1, L73_1, L74_1, L75_1, L76_1, L77_1, L78_1, L79_1, L80_1, L81_1, L82_1, L83_1
L0_1 = {}
L0_1.settings = true
L0_1.phone = true
L0_1.store = true
function L1_1()
  local L0_2, L1_2
  L0_2 = os
  L0_2 = L0_2.time
  L0_2 = L0_2()
  L0_2 = L0_2 * 1000
  return L0_2
end
function L2_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2
  L2_2 = type
  L3_2 = A0_2
  L2_2 = L2_2(L3_2)
  if "table" ~= L2_2 then
    return A0_2
  end
  if not A1_2 then
    L2_2 = {}
    A1_2 = L2_2
  end
  L2_2 = A1_2[A0_2]
  if L2_2 then
    L2_2 = nil
    return L2_2
  end
  A1_2[A0_2] = true
  L2_2 = {}
  L3_2 = pairs
  L4_2 = A0_2
  L3_2, L4_2, L5_2, L6_2 = L3_2(L4_2)
  for L7_2, L8_2 in L3_2, L4_2, L5_2, L6_2 do
    L9_2 = L2_1
    L10_2 = L8_2
    L11_2 = A1_2
    L9_2 = L9_2(L10_2, L11_2)
    L2_2[L7_2] = L9_2
  end
  A1_2[A0_2] = nil
  return L2_2
end
function L3_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2
  if not A1_2 then
    A1_2 = 0
  end
  L2_2 = type
  L3_2 = A0_2
  L2_2 = L2_2(L3_2)
  if "vector4" == L2_2 then
    L3_2 = {}
    L4_2 = A0_2.x
    L3_2.x = L4_2
    L4_2 = A0_2.y
    L3_2.y = L4_2
    L4_2 = A0_2.z
    L3_2.z = L4_2
    L4_2 = A0_2.w
    L3_2.w = L4_2
    return L3_2
  end
  if "vector3" == L2_2 then
    L3_2 = {}
    L4_2 = A0_2.x
    L3_2.x = L4_2
    L4_2 = A0_2.y
    L3_2.y = L4_2
    L4_2 = A0_2.z
    L3_2.z = L4_2
    return L3_2
  end
  if "vector2" == L2_2 then
    L3_2 = {}
    L4_2 = A0_2.x
    L3_2.x = L4_2
    L4_2 = A0_2.y
    L3_2.y = L4_2
    return L3_2
  end
  if "function" == L2_2 or "userdata" == L2_2 or "thread" == L2_2 then
    L3_2 = nil
    return L3_2
  end
  if "table" ~= L2_2 or A1_2 > 12 then
    return A0_2
  end
  L3_2 = {}
  L4_2 = pairs
  L5_2 = A0_2
  L4_2, L5_2, L6_2, L7_2 = L4_2(L5_2)
  for L8_2, L9_2 in L4_2, L5_2, L6_2, L7_2 do
    L10_2 = L3_1
    L11_2 = L9_2
    L12_2 = A1_2 + 1
    L10_2 = L10_2(L11_2, L12_2)
    L3_2[L8_2] = L10_2
  end
  return L3_2
end
function L4_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2
  L2_2 = utf8
  L2_2 = L2_2.len
  L3_2 = A0_2
  L2_2 = L2_2(L3_2)
  if not L2_2 then
    L2_2 = nil
    return L2_2
  end
  L2_2 = utf8
  L2_2 = L2_2.len
  L3_2 = A0_2
  L2_2 = L2_2(L3_2)
  if A1_2 < L2_2 then
    L4_2 = A0_2
    L3_2 = A0_2.sub
    L5_2 = 1
    L6_2 = utf8
    L6_2 = L6_2.offset
    L7_2 = A0_2
    L8_2 = A1_2 + 1
    L6_2 = L6_2(L7_2, L8_2)
    L6_2 = L6_2 - 1
    L3_2 = L3_2(L4_2, L5_2, L6_2)
    A0_2 = L3_2
  end
  return A0_2
end
function L5_1(A0_2, A1_2, A2_2)
  local L3_2, L4_2, L5_2, L6_2
  L3_2 = type
  L4_2 = A0_2
  L3_2 = L3_2(L4_2)
  if "number" == L3_2 then
    L3_2 = tostring
    L4_2 = A0_2
    L3_2 = L3_2(L4_2)
    A0_2 = L3_2
  end
  L3_2 = type
  L4_2 = A0_2
  L3_2 = L3_2(L4_2)
  if "string" ~= L3_2 then
    return A2_2
  end
  L4_2 = A0_2
  L3_2 = A0_2.gsub
  L5_2 = "[%c]"
  L6_2 = " "
  L3_2 = L3_2(L4_2, L5_2, L6_2)
  A0_2 = L3_2
  L4_2 = A0_2
  L3_2 = A0_2.gsub
  L5_2 = "^%s+"
  L6_2 = ""
  L3_2 = L3_2(L4_2, L5_2, L6_2)
  L4_2 = L3_2
  L3_2 = L3_2.gsub
  L5_2 = "%s+$"
  L6_2 = ""
  L3_2 = L3_2(L4_2, L5_2, L6_2)
  A0_2 = L3_2
  L3_2 = L4_1
  L4_2 = A0_2
  L5_2 = A1_2
  L3_2 = L3_2(L4_2, L5_2)
  A0_2 = L3_2
  if nil == A0_2 then
    return A2_2
  end
  return A0_2
end
function L6_1(A0_2, A1_2, A2_2)
  local L3_2, L4_2, L5_2, L6_2
  L3_2 = type
  L4_2 = A0_2
  L3_2 = L3_2(L4_2)
  if "string" ~= L3_2 then
    return A2_2
  end
  L4_2 = A0_2
  L3_2 = A0_2.gsub
  L5_2 = "\r\n"
  L6_2 = "\n"
  L3_2 = L3_2(L4_2, L5_2, L6_2)
  L4_2 = L3_2
  L3_2 = L3_2.gsub
  L5_2 = "[%z\001-\t\v-\031\127]"
  L6_2 = ""
  L3_2 = L3_2(L4_2, L5_2, L6_2)
  A0_2 = L3_2
  L4_2 = A0_2
  L3_2 = A0_2.gsub
  L5_2 = "^%s+"
  L6_2 = ""
  L3_2 = L3_2(L4_2, L5_2, L6_2)
  L4_2 = L3_2
  L3_2 = L3_2.gsub
  L5_2 = "%s+$"
  L6_2 = ""
  L3_2 = L3_2(L4_2, L5_2, L6_2)
  A0_2 = L3_2
  L4_2 = A0_2
  L3_2 = A0_2.gsub
  L5_2 = [[



+]]
  L6_2 = [[


]]
  L3_2 = L3_2(L4_2, L5_2, L6_2)
  A0_2 = L3_2
  L3_2 = L4_1
  L4_2 = A0_2
  L5_2 = A1_2
  L3_2 = L3_2(L4_2, L5_2)
  A0_2 = L3_2
  if nil == A0_2 then
    return A2_2
  end
  return A0_2
end
function L7_1(A0_2, A1_2)
  local L2_2, L3_2
  L2_2 = type
  L3_2 = A0_2
  L2_2 = L2_2(L3_2)
  if "boolean" == L2_2 then
    return A0_2
  end
  L2_2 = true == A1_2
  return L2_2
end
function L8_1(A0_2, A1_2, A2_2, A3_2)
  local L4_2, L5_2
  L4_2 = tonumber
  L5_2 = A0_2
  L4_2 = L4_2(L5_2)
  A0_2 = L4_2
  if A0_2 and A0_2 == A0_2 then
    L4_2 = math
    L4_2 = L4_2.huge
    if A0_2 ~= L4_2 then
      L4_2 = math
      L4_2 = L4_2.huge
      L4_2 = -L4_2
      if A0_2 ~= L4_2 then
        goto lbl_19
      end
    end
  end
  do return A3_2 end
  ::lbl_19::
  L4_2 = math
  L4_2 = L4_2.floor
  L5_2 = A0_2 + 0.5
  L4_2 = L4_2(L5_2)
  A0_2 = L4_2
  if A1_2 > A0_2 then
    A0_2 = A1_2
  elseif A2_2 < A0_2 then
    A0_2 = A2_2
  end
  return A0_2
end
function L9_1(A0_2, A1_2, A2_2, A3_2)
  local L4_2, L5_2
  L4_2 = tonumber
  L5_2 = A0_2
  L4_2 = L4_2(L5_2)
  A0_2 = L4_2
  if A0_2 and A0_2 == A0_2 then
    L4_2 = math
    L4_2 = L4_2.huge
    if A0_2 ~= L4_2 then
      L4_2 = math
      L4_2 = L4_2.huge
      L4_2 = -L4_2
      if A0_2 ~= L4_2 then
        goto lbl_19
      end
    end
  end
  do return A3_2 end
  ::lbl_19::
  if A1_2 > A0_2 then
    A0_2 = A1_2
  elseif A2_2 < A0_2 then
    A0_2 = A2_2
  end
  return A0_2
end
function L10_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2
  L2_2 = type
  L3_2 = A0_2
  L2_2 = L2_2(L3_2)
  if "string" == L2_2 then
    L3_2 = A0_2
    L2_2 = A0_2.match
    L4_2 = "^#%x%x%x%x%x%x$"
    L2_2 = L2_2(L3_2, L4_2)
    if L2_2 then
      L3_2 = A0_2
      L2_2 = A0_2.upper
      return L2_2(L3_2)
    end
  end
  return A1_2
end
function L11_1(A0_2, A1_2, A2_2)
  local L3_2, L4_2, L5_2
  L3_2 = type
  L4_2 = A0_2
  L3_2 = L3_2(L4_2)
  if "string" ~= L3_2 then
    L3_2 = nil
    return L3_2
  end
  L4_2 = A0_2
  L3_2 = A0_2.lower
  L3_2 = L3_2(L4_2)
  A0_2 = L3_2
  L3_2 = #A0_2
  if not (A1_2 > L3_2) then
    L3_2 = #A0_2
    if not (A2_2 < L3_2) then
      L4_2 = A0_2
      L3_2 = A0_2.match
      L5_2 = "^[a-z0-9_]+$"
      L3_2 = L3_2(L4_2, L5_2)
      if L3_2 then
        goto lbl_24
      end
    end
  end
  L3_2 = nil
  do return L3_2 end
  ::lbl_24::
  return A0_2
end
function L12_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2
  L2_2 = type
  L3_2 = A0_2
  L2_2 = L2_2(L3_2)
  if "string" == L2_2 then
    L2_2 = #A0_2
    if L2_2 <= 32 then
      L3_2 = A0_2
      L2_2 = A0_2.match
      L4_2 = "^[%w_%-]+$"
      L2_2 = L2_2(L3_2, L4_2)
      if L2_2 then
        return A0_2
      end
    end
  end
  return A1_2
end
function L13_1(A0_2)
  local L1_2, L2_2, L3_2
  L1_2 = type
  L2_2 = A0_2
  L1_2 = L1_2(L2_2)
  if "string" == L1_2 and "" ~= A0_2 then
    L1_2 = #A0_2
    L2_2 = 300
    if not (L1_2 > L2_2) then
      goto lbl_14
    end
  end
  L1_2 = ""
  do return L1_2 end
  ::lbl_14::
  L2_2 = A0_2
  L1_2 = A0_2.match
  L3_2 = "^https://[^%s\"'<>`]+$"
  L1_2 = L1_2(L2_2, L3_2)
  if not L1_2 then
    L2_2 = A0_2
    L1_2 = A0_2.match
    L3_2 = "^nui://[^%s\"'<>`]+$"
    L1_2 = L1_2(L2_2, L3_2)
    if not L1_2 then
      goto lbl_25
    end
  end
  do return A0_2 end
  ::lbl_25::
  L1_2 = ""
  return L1_2
end
function L14_1(A0_2)
  local L1_2, L2_2, L3_2
  L1_2 = type
  L2_2 = A0_2
  L1_2 = L1_2(L2_2)
  if "string" == L1_2 and "" ~= A0_2 then
    L1_2 = #A0_2
    L2_2 = 300
    if not (L1_2 > L2_2) then
      goto lbl_14
    end
  end
  L1_2 = ""
  do return L1_2 end
  ::lbl_14::
  L2_2 = A0_2
  L1_2 = A0_2.match
  L3_2 = "^https://[^%s\"'<>`]+$"
  L1_2 = L1_2(L2_2, L3_2)
  if L1_2 then
    return A0_2
  end
  L1_2 = ""
  return L1_2
end
function L15_1(A0_2)
  local L1_2, L2_2
  L1_2 = type
  L2_2 = A0_2
  L1_2 = L1_2(L2_2)
  L1_2 = A0_2 or L1_2
  if "table" ~= L1_2 or not A0_2 then
    L1_2 = {}
  end
  return L1_2
end
L16_1 = {}
L17_1 = ipairs
L18_1 = AdminSchema
L18_1 = L18_1.settings
L17_1, L18_1, L19_1, L20_1 = L17_1(L18_1)
for L21_1, L22_1 in L17_1, L18_1, L19_1, L20_1 do
  L23_1 = L22_1.path
  L24_1 = L2_1
  L25_1 = AdminSchemaGet
  L26_1 = L22_1.path
  L25_1, L26_1, L27_1, L28_1, L29_1, L30_1, L31_1, L32_1, L33_1, L34_1, L35_1, L36_1, L37_1, L38_1, L39_1, L40_1, L41_1, L42_1, L43_1, L44_1, L45_1, L46_1, L47_1, L48_1, L49_1, L50_1, L51_1, L52_1, L53_1, L54_1, L55_1, L56_1, L57_1, L58_1, L59_1, L60_1, L61_1, L62_1, L63_1, L64_1, L65_1, L66_1, L67_1, L68_1, L69_1, L70_1, L71_1, L72_1, L73_1, L74_1, L75_1, L76_1, L77_1, L78_1, L79_1, L80_1, L81_1, L82_1, L83_1 = L25_1(L26_1)
  L24_1 = L24_1(L25_1, L26_1, L27_1, L28_1, L29_1, L30_1, L31_1, L32_1, L33_1, L34_1, L35_1, L36_1, L37_1, L38_1, L39_1, L40_1, L41_1, L42_1, L43_1, L44_1, L45_1, L46_1, L47_1, L48_1, L49_1, L50_1, L51_1, L52_1, L53_1, L54_1, L55_1, L56_1, L57_1, L58_1, L59_1, L60_1, L61_1, L62_1, L63_1, L64_1, L65_1, L66_1, L67_1, L68_1, L69_1, L70_1, L71_1, L72_1, L73_1, L74_1, L75_1, L76_1, L77_1, L78_1, L79_1, L80_1, L81_1, L82_1, L83_1)
  L16_1[L23_1] = L24_1
end
function L17_1(A0_2, A1_2)
  local L2_2, L3_2
  L2_2 = type
  L3_2 = A0_2
  L2_2 = L2_2(L3_2)
  if "number" == L2_2 then
    L2_2 = type
    L3_2 = A1_2
    L2_2 = L2_2(L3_2)
    if "number" == L2_2 then
      L2_2 = math
      L2_2 = L2_2.abs
      L3_2 = A0_2 - A1_2
      L2_2 = L2_2(L3_2)
      L3_2 = 1.0E-6
      L2_2 = L2_2 < L3_2
      return L2_2
    end
  end
  L2_2 = A0_2 == A1_2
  return L2_2
end
function L18_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2
  L2_2 = A0_2.type
  if "bool" == L2_2 then
    L2_2 = type
    L3_2 = A1_2
    L2_2 = L2_2(L3_2)
    if "boolean" == L2_2 then
      return A1_2
    end
    L2_2 = nil
    return L2_2
  else
    L2_2 = A0_2.type
    if "int" == L2_2 then
      L2_2 = tonumber
      L3_2 = A1_2
      L2_2 = L2_2(L3_2)
      A1_2 = L2_2
      if A1_2 and A1_2 == A1_2 then
        L2_2 = math
        L2_2 = L2_2.floor
        L3_2 = A1_2
        L2_2 = L2_2(L3_2)
        if A1_2 == L2_2 then
          goto lbl_32
        end
      end
      L2_2 = nil
      do return L2_2 end
      ::lbl_32::
      L2_2 = A0_2.min
      if L2_2 then
        L2_2 = A0_2.min
        if A1_2 < L2_2 then
          L2_2 = nil
          return L2_2
        end
      end
      L2_2 = A0_2.max
      if L2_2 then
        L2_2 = A0_2.max
        if A1_2 > L2_2 then
          L2_2 = nil
          return L2_2
        end
      end
      L2_2 = math
      L2_2 = L2_2.floor
      L3_2 = A1_2
      return L2_2(L3_2)
    else
      L2_2 = A0_2.type
      if "num" == L2_2 then
        L2_2 = tonumber
        L3_2 = A1_2
        L2_2 = L2_2(L3_2)
        A1_2 = L2_2
        if A1_2 and A1_2 == A1_2 then
          L2_2 = math
          L2_2 = L2_2.huge
          if A1_2 ~= L2_2 then
            L2_2 = math
            L2_2 = L2_2.huge
            L2_2 = -L2_2
            if A1_2 ~= L2_2 then
              goto lbl_74
            end
          end
        end
        L2_2 = nil
        do return L2_2 end
        ::lbl_74::
        L2_2 = A0_2.min
        if L2_2 then
          L2_2 = A0_2.min
          L2_2 = L2_2 - 1.0E-9
          if A1_2 < L2_2 then
            L2_2 = nil
            return L2_2
          end
        end
        L2_2 = A0_2.max
        if L2_2 then
          L2_2 = A0_2.max
          L2_2 = L2_2 + 1.0E-9
          if A1_2 > L2_2 then
            L2_2 = nil
            return L2_2
          end
        end
        L2_2 = A0_2.step
        if L2_2 then
          L2_2 = A0_2.step
          if L2_2 > 0 then
            L2_2 = math
            L2_2 = L2_2.floor
            L3_2 = A0_2.step
            L3_2 = A1_2 / L3_2
            L3_2 = L3_2 + 0.5
            L2_2 = L2_2(L3_2)
            L3_2 = A0_2.step
            A1_2 = L2_2 * L3_2
          end
        end
        L2_2 = tonumber
        L3_2 = "%.4f"
        L4_2 = L3_2
        L3_2 = L3_2.format
        L5_2 = A1_2
        L3_2, L4_2, L5_2, L6_2, L7_2, L8_2 = L3_2(L4_2, L5_2)
        return L2_2(L3_2, L4_2, L5_2, L6_2, L7_2, L8_2)
      else
        L2_2 = A0_2.type
        if "text" == L2_2 then
          L2_2 = type
          L3_2 = A1_2
          L2_2 = L2_2(L3_2)
          if "string" ~= L2_2 then
            L2_2 = nil
            return L2_2
          end
          L2_2 = L5_1
          L3_2 = A1_2
          L4_2 = A0_2.max
          if not L4_2 then
            L4_2 = 64
          end
          L2_2 = L2_2(L3_2, L4_2)
          return L2_2
        else
          L2_2 = A0_2.type
          if "select" == L2_2 then
            L2_2 = type
            L3_2 = A1_2
            L2_2 = L2_2(L3_2)
            if "string" ~= L2_2 then
              L2_2 = nil
              return L2_2
            end
            L2_2 = ipairs
            L3_2 = A0_2.options
            if not L3_2 then
              L3_2 = {}
            end
            L2_2, L3_2, L4_2, L5_2 = L2_2(L3_2)
            for L6_2, L7_2 in L2_2, L3_2, L4_2, L5_2 do
              if L7_2 == A1_2 then
                return A1_2
              end
            end
            L2_2 = nil
            return L2_2
          end
        end
      end
    end
  end
  L2_2 = nil
  return L2_2
end
function L19_1(A0_2)
  local L1_2, L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2
  L1_2 = {}
  L2_2 = {}
  L3_2 = ipairs
  L4_2 = L15_1
  L5_2 = A0_2
  L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2 = L4_2(L5_2)
  L3_2, L4_2, L5_2, L6_2 = L3_2(L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2)
  for L7_2, L8_2 in L3_2, L4_2, L5_2, L6_2 do
    L9_2 = #L1_2
    L10_2 = 300
    if L9_2 >= L10_2 then
      break
    end
    L9_2 = type
    L10_2 = L8_2
    L9_2 = L9_2(L10_2)
    if "string" == L9_2 then
      L9_2 = #L8_2
      if L9_2 <= 64 then
        L10_2 = L8_2
        L9_2 = L8_2.match
        L11_2 = "^[%w%._:%-]+$"
        L9_2 = L9_2(L10_2, L11_2)
        if L9_2 then
          L9_2 = L0_1
          L9_2 = L9_2[L8_2]
          if not L9_2 then
            L10_2 = L8_2
            L9_2 = L8_2.sub
            L11_2 = 1
            L12_2 = 5
            L9_2 = L9_2(L10_2, L11_2, L12_2)
            if "capp_" ~= L9_2 then
              L9_2 = L2_2[L8_2]
              if not L9_2 then
                L2_2[L8_2] = true
                L9_2 = #L1_2
                L9_2 = L9_2 + 1
                L1_2[L9_2] = L8_2
              end
            end
          end
        end
      end
    end
  end
  L3_2 = table
  L3_2 = L3_2.sort
  L4_2 = L1_2
  L3_2(L4_2)
  return L1_2
end
function L20_1()
  local L0_2, L1_2, L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2
  L0_2 = AdminStore
  L0_2 = L0_2.Get
  L1_2 = "settings"
  L0_2 = L0_2(L1_2)
  L1_2 = {}
  L2_2 = type
  L3_2 = L0_2
  L2_2 = L2_2(L3_2)
  if "table" == L2_2 then
    L2_2 = type
    L3_2 = L0_2.config
    L2_2 = L2_2(L3_2)
    if "table" == L2_2 then
      L2_2 = pairs
      L3_2 = L0_2.config
      L2_2, L3_2, L4_2, L5_2 = L2_2(L3_2)
      for L6_2, L7_2 in L2_2, L3_2, L4_2, L5_2 do
        L8_2 = AdminSchemaFind
        L9_2 = L6_2
        L8_2 = L8_2(L9_2)
        if L8_2 then
          L9_2 = L18_1
          L10_2 = L8_2
          L11_2 = L7_2
          L9_2 = L9_2(L10_2, L11_2)
          if nil ~= L9_2 then
            L1_2[L6_2] = L9_2
          end
        end
      end
    end
  end
  L2_2 = L1_2
  L3_2 = L19_1
  L4_2 = type
  L5_2 = L0_2
  L4_2 = L4_2(L5_2)
  if "table" == L4_2 then
    L4_2 = L0_2.disabledApps
    if L4_2 then
      goto lbl_48
    end
  end
  L4_2 = {}
  ::lbl_48::
  L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2 = L3_2(L4_2)
  return L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2
end
L21_1 = {}
L22_1 = "shop"
L23_1 = "admin"
L21_1[1] = L22_1
L21_1[2] = L23_1
function L22_1(A0_2)
  local L1_2, L2_2, L3_2
  L1_2 = type
  L2_2 = A0_2
  L1_2 = L1_2(L2_2)
  if "string" == L1_2 then
    L2_2 = A0_2
    L1_2 = A0_2.match
    L3_2 = "^#%x%x%x%x%x%x$"
    L1_2 = L1_2(L2_2, L3_2)
    if L1_2 then
      L2_2 = A0_2
      L1_2 = A0_2.upper
      L1_2 = L1_2(L2_2)
      if L1_2 then
        goto lbl_16
      end
    end
  end
  L1_2 = nil
  ::lbl_16::
  return L1_2
end
function L23_1(A0_2)
  local L1_2, L2_2, L3_2, L4_2
  function L1_2(A0_3)
    local L1_3, L2_3, L3_3, L4_3, L5_3
    L1_3 = tonumber
    L2_3 = A0_2
    L3_3 = L2_3
    L2_3 = L2_3.sub
    L4_3 = A0_3
    L5_3 = A0_3 + 1
    L2_3 = L2_3(L3_3, L4_3, L5_3)
    L3_3 = 16
    L1_3 = L1_3(L2_3, L3_3)
    L1_3 = L1_3 / 255
    L2_3 = 0.03928
    if L1_3 <= L2_3 then
      L2_3 = L1_3 / 12.92
      if L2_3 then
        goto lbl_25
      end
    end
    L2_3 = L1_3 + 0.055
    L2_3 = L2_3 / 1.055
    L2_3 = L2_3 ^ 2.4
    ::lbl_25::
    return L2_3
  end
  L2_2 = L1_2
  L3_2 = 2
  L2_2 = L2_2(L3_2)
  L2_2 = 0.2126 * L2_2
  L3_2 = L1_2
  L4_2 = 4
  L3_2 = L3_2(L4_2)
  L3_2 = 0.7152 * L3_2
  L2_2 = L2_2 + L3_2
  L3_2 = L1_2
  L4_2 = 6
  L3_2 = L3_2(L4_2)
  L3_2 = 0.0722 * L3_2
  L2_2 = L2_2 + L3_2
  return L2_2
end
L24_1 = {}
function L25_1(A0_2)
  local L1_2, L2_2
  L1_2 = L23_1
  L2_2 = A0_2
  L1_2 = L1_2(L2_2)
  L2_2 = 0.07
  L1_2 = L1_2 <= L2_2
  return L1_2
end
L24_1.bg = L25_1
function L25_1(A0_2)
  local L1_2, L2_2
  L1_2 = L23_1
  L2_2 = A0_2
  L1_2 = L1_2(L2_2)
  L2_2 = 0.06
  L1_2 = L1_2 >= L2_2
  return L1_2
end
L24_1.acc = L25_1
function L25_1()
  local L0_2, L1_2, L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2
  L0_2 = AdminStore
  L0_2 = L0_2.Get
  L1_2 = "theme"
  L0_2 = L0_2(L1_2)
  L1_2 = type
  L2_2 = L0_2
  L1_2 = L1_2(L2_2)
  if "table" ~= L1_2 or not L0_2 then
    L1_2 = {}
    L0_2 = L1_2
  end
  L1_2 = {}
  L2_2 = ipairs
  L3_2 = L21_1
  L2_2, L3_2, L4_2, L5_2 = L2_2(L3_2)
  for L6_2, L7_2 in L2_2, L3_2, L4_2, L5_2 do
    L8_2 = type
    L9_2 = L0_2[L7_2]
    L8_2 = L8_2(L9_2)
    if "table" == L8_2 then
      L8_2 = L0_2[L7_2]
      if L8_2 then
        goto lbl_31
      end
    end
    L8_2 = {}
    ::lbl_31::
    L9_2 = L22_1
    L10_2 = L8_2.acc
    L9_2 = L9_2(L10_2)
    L10_2 = L22_1
    L11_2 = L8_2.bg
    L10_2 = L10_2(L11_2)
    L11_2 = {}
    if L9_2 then
      L12_2 = L24_1.acc
      L13_2 = L9_2
      L12_2 = L12_2(L13_2)
      if L12_2 and L9_2 then
        goto lbl_49
        L12_2 = L9_2 or L12_2
      end
    end
    L12_2 = ""
    ::lbl_49::
    L11_2.acc = L12_2
    if L10_2 then
      L12_2 = L24_1.bg
      L13_2 = L10_2
      L12_2 = L12_2(L13_2)
      if L12_2 and L10_2 then
        goto lbl_60
        L12_2 = L10_2 or L12_2
      end
    end
    L12_2 = ""
    ::lbl_60::
    L11_2.bg = L12_2
    L1_2[L7_2] = L11_2
  end
  return L1_2
end
L26_1 = os
L26_1 = L26_1.time
L26_1 = L26_1()
function L27_1()
  local L0_2, L1_2, L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2
  L0_2 = L20_1
  L0_2, L1_2 = L0_2()
  L2_2 = ipairs
  L3_2 = AdminSchema
  L3_2 = L3_2.settings
  L2_2, L3_2, L4_2, L5_2 = L2_2(L3_2)
  for L6_2, L7_2 in L2_2, L3_2, L4_2, L5_2 do
    L8_2 = L7_2.path
    L8_2 = L0_2[L8_2]
    if nil ~= L8_2 then
      L9_2 = AdminSchemaSet
      L10_2 = L7_2.path
      L11_2 = L8_2
      L9_2(L10_2, L11_2)
    else
      L9_2 = AdminSchemaSet
      L10_2 = L7_2.path
      L11_2 = L2_1
      L13_2 = L7_2.path
      L12_2 = L16_1
      L12_2 = L12_2[L13_2]
      L11_2, L12_2, L13_2 = L11_2(L12_2)
      L9_2(L10_2, L11_2, L12_2, L13_2)
    end
  end
  L2_2 = L26_1
  L2_2 = L2_2 + 1
  L26_1 = L2_2
  L2_2 = GlobalState
  L3_2 = {}
  L4_2 = L26_1
  L3_2.rev = L4_2
  L3_2.config = L0_2
  L3_2.disabledApps = L1_2
  L4_2 = L25_1
  L4_2 = L4_2()
  L3_2.theme = L4_2
  L2_2["apex_phone:settings"] = L3_2
end
L28_1 = AdminStore
L28_1 = L28_1.OnChange
L29_1 = "settings"
function L30_1()
  local L0_2, L1_2
  L0_2 = L27_1
  L0_2()
end
L28_1(L29_1, L30_1)
L28_1 = AdminStore
L28_1 = L28_1.OnChange
L29_1 = "theme"
function L30_1()
  local L0_2, L1_2
  L0_2 = L27_1
  L0_2()
end
L28_1(L29_1, L30_1)
function L28_1()
  local L0_2, L1_2, L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2
  L0_2 = L20_1
  L0_2, L1_2 = L0_2()
  L2_2 = {}
  L3_2 = {}
  L4_2 = ipairs
  L5_2 = AdminSchema
  L5_2 = L5_2.settings
  L4_2, L5_2, L6_2, L7_2 = L4_2(L5_2)
  for L8_2, L9_2 in L4_2, L5_2, L6_2, L7_2 do
    L10_2 = L9_2.path
    L11_2 = L3_1
    L12_2 = AdminSchemaGet
    L13_2 = L9_2.path
    L12_2, L13_2 = L12_2(L13_2)
    L11_2 = L11_2(L12_2, L13_2)
    L2_2[L10_2] = L11_2
    L10_2 = L9_2.path
    L11_2 = L3_1
    L13_2 = L9_2.path
    L12_2 = L16_1
    L12_2 = L12_2[L13_2]
    L11_2 = L11_2(L12_2)
    L3_2[L10_2] = L11_2
  end
  L4_2 = {}
  L4_2.values = L2_2
  L4_2.defaults = L3_2
  L4_2.overrides = L0_2
  L5_2 = L1_2
  return L4_2, L5_2
end
L29_1 = type
L30_1 = Config
L30_1 = L30_1.CustomApps
L29_1 = L29_1(L30_1)
if "table" == L29_1 then
  L29_1 = Config
  L29_1 = L29_1.CustomApps
  if L29_1 then
    goto lbl_84
  end
end
L29_1 = {}
::lbl_84::
L30_1 = L8_1
L31_1 = L29_1.maxApps
L32_1 = 1
L33_1 = 200
L34_1 = 40
L30_1 = L30_1(L31_1, L32_1, L33_1, L34_1)
L31_1 = L8_1
L32_1 = L29_1.maxModules
L33_1 = 1
L34_1 = 20
L35_1 = 10
L31_1 = L31_1(L32_1, L33_1, L34_1, L35_1)
L32_1 = type
L33_1 = L29_1.categories
L32_1 = L32_1(L33_1)
if "table" == L32_1 then
  L32_1 = L29_1.categories
  L32_1 = #L32_1
  if L32_1 > 0 then
    L32_1 = L29_1.categories
    if L32_1 then
      goto lbl_114
    end
  end
end
L32_1 = {}
L33_1 = "Servi\195\167os p\195\186blicos"
L34_1 = "Emprego"
L35_1 = "Empresas"
L32_1[1] = L33_1
L32_1[2] = L34_1
L32_1[3] = L35_1
::lbl_114::
L33_1 = {}
L33_1.form = true
L33_1.appointments = true
L33_1.dispatch = true
L33_1.records = true
L33_1.posts = true
L33_1.roster = true
L33_1.info = true
L33_1.catalog = true
L33_1.billing = true
L33_1.duty = true
L34_1 = {}
L34_1.form = "Formul\195\161rio"
L34_1.appointments = "Marca\195\167\195\181es"
L34_1.dispatch = "Pedidos"
L34_1.records = "Fichas"
L34_1.posts = "Comunicados"
L34_1.roster = "Equipa"
L34_1.info = "Informa\195\167\195\181es"
L34_1.catalog = "Cat\195\161logo"
L34_1.billing = "Fatura\195\167\195\163o"
L34_1.duty = "Servi\195\167o"
L35_1 = {}
L35_1.billing = true
L35_1.duty = true
L36_1 = {}
L36_1.text = true
L36_1.textarea = true
L36_1.number = true
L36_1.select = true
L36_1.checkbox = true
L36_1.date = true
L36_1.phone = true
L36_1.plate = true
L36_1.email = true
L36_1.url = true
L36_1.time = true
L36_1.multiselect = true
L36_1.rating = true
L36_1.photo = true
L36_1.section = true
L36_1.info = true
L37_1 = {}
L37_1.section = true
L37_1.info = true
L38_1 = {}
L38_1.text = 200
L38_1.textarea = 1500
L38_1.phone = 32
L38_1.plate = 16
L38_1.email = 120
L38_1.url = 300
L39_1 = {}
L40_1 = "view"
L41_1 = "reply"
L42_1 = "status"
L43_1 = "assign"
L44_1 = "delete"
L45_1 = "create"
L39_1[1] = L40_1
L39_1[2] = L41_1
L39_1[3] = L42_1
L39_1[4] = L43_1
L39_1[5] = L44_1
L39_1[6] = L45_1
L40_1 = {}
L40_1.text = true
L40_1.hours = true
L40_1.location = true
L40_1.contact = true
L40_1.link = true
L40_1.image = true
L41_1 = {}
L41_1.person = true
L41_1.vehicle = true
L41_1.free = true
L42_1 = {}
L43_1 = "item.created"
L44_1 = "item.status"
L45_1 = "item.reply"
L46_1 = "post.created"
L47_1 = "record.created"
L48_1 = "record.updated"
L49_1 = "dispatch.accepted"
L50_1 = "bill.created"
L51_1 = "duty.changed"
L42_1[1] = L43_1
L42_1[2] = L44_1
L42_1[3] = L45_1
L42_1[4] = L46_1
L42_1[5] = L47_1
L42_1[6] = L48_1
L42_1[7] = L49_1
L42_1[8] = L50_1
L42_1[9] = L51_1
L43_1 = L8_1
L44_1 = type
L45_1 = Config
L45_1 = L45_1.Billing
L44_1 = L44_1(L45_1)
L44_1 = Config
L44_1 = L44_1.Billing
L44_1 = "table" == L44_1 and L44_1
L45_1 = 1
L46_1 = 1000000000
L47_1 = 1000000
L43_1 = L43_1(L44_1, L45_1, L46_1, L47_1)
L44_1 = {}
L45_1 = {}
L45_1.id = "new"
L45_1.label = "Novo"
L45_1.color = "#5B8CFF"
L45_1.notify = true
L46_1 = {}
L46_1.id = "progress"
L46_1.label = "Em curso"
L46_1.color = "#F5A524"
L46_1.notify = true
L47_1 = {}
L47_1.id = "closed"
L47_1.label = "Fechado"
L47_1.color = "#2BB673"
L47_1.closed = true
L47_1.notify = true
L44_1[1] = L45_1
L44_1[2] = L46_1
L44_1[3] = L47_1
L45_1 = {}
L46_1 = {}
L46_1.id = "recebida"
L46_1.label = "Recebida"
L46_1.color = "#5B8CFF"
L46_1.notify = true
L47_1 = {}
L47_1.id = "preparar"
L47_1.label = "Em prepara\195\167\195\163o"
L47_1.color = "#F5A524"
L47_1.notify = true
L48_1 = {}
L48_1.id = "pronta"
L48_1.label = "Pronta"
L48_1.color = "#10B981"
L48_1.notify = true
L49_1 = {}
L49_1.id = "entregue"
L49_1.label = "Entregue"
L49_1.color = "#8A8F98"
L49_1.closed = true
L49_1.notify = false
L50_1 = {}
L50_1.id = "cancelada"
L50_1.label = "Cancelada"
L50_1.color = "#E5484D"
L50_1.closed = true
L50_1.notify = true
L45_1[1] = L46_1
L45_1[2] = L47_1
L45_1[3] = L48_1
L45_1[4] = L49_1
L45_1[5] = L50_1
function L46_1(A0_2)
  local L1_2, L2_2, L3_2, L4_2, L5_2, L6_2, L7_2
  L1_2 = tostring
  L2_2 = A0_2
  L1_2 = L1_2(L2_2)
  L2_2 = L1_2
  L1_2 = L1_2.match
  L3_2 = "^(%d%d%d%d)%-(%d%d)%-(%d%d)$"
  L1_2, L2_2, L3_2 = L1_2(L2_2, L3_2)
  L4_2 = tonumber
  L5_2 = L1_2
  L4_2 = L4_2(L5_2)
  L5_2 = tonumber
  L6_2 = L2_2
  L5_2 = L5_2(L6_2)
  L6_2 = tonumber
  L7_2 = L3_2
  L6_2 = L6_2(L7_2)
  L3_2 = L6_2
  L2_2 = L5_2
  L1_2 = L4_2
  L4_2 = L1_2 or L4_2
  L4_2 = L1_2 and L2_2 >= 1 and L2_2 <= 12 and L3_2 >= 1 and L3_2 <= 31
  return L4_2
end
function L47_1(A0_2)
  local L1_2, L2_2, L3_2, L4_2, L5_2
  L1_2 = tostring
  L2_2 = A0_2
  L1_2 = L1_2(L2_2)
  L2_2 = L1_2
  L1_2 = L1_2.match
  L3_2 = "^(%d%d):(%d%d)$"
  L1_2, L2_2 = L1_2(L2_2, L3_2)
  L3_2 = tonumber
  L4_2 = L1_2
  L3_2 = L3_2(L4_2)
  L4_2 = tonumber
  L5_2 = L2_2
  L4_2 = L4_2(L5_2)
  L2_2 = L4_2
  L1_2 = L3_2
  L3_2 = L1_2 or L3_2
  L3_2 = L1_2 and L1_2 <= 23 and L2_2 <= 59
  return L3_2
end
function L48_1(A0_2)
  local L1_2, L2_2, L3_2
  L1_2 = type
  L2_2 = A0_2
  L1_2 = L1_2(L2_2)
  L1_2 = "string" == L1_2
  return L1_2
end
function L49_1(A0_2)
  local L1_2, L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2
  L1_2 = {}
  L2_2 = {}
  L3_2 = ipairs
  L4_2 = L15_1
  L5_2 = A0_2
  L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2 = L4_2(L5_2)
  L3_2, L4_2, L5_2, L6_2 = L3_2(L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2)
  for L7_2, L8_2 in L3_2, L4_2, L5_2, L6_2 do
    L9_2 = L5_1
    L10_2 = L8_2
    L11_2 = 40
    L9_2 = L9_2(L10_2, L11_2)
    if L9_2 and "" ~= L9_2 then
      L10_2 = L2_2[L9_2]
      if not L10_2 then
        L10_2 = #L1_2
        if L10_2 < 20 then
          L2_2[L9_2] = true
          L10_2 = #L1_2
          L10_2 = L10_2 + 1
          L1_2[L10_2] = L9_2
        end
      end
    end
  end
  L3_2 = L1_2
  L4_2 = L2_2
  return L3_2, L4_2
end
function L50_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2
  if nil == A1_2 or "" == A1_2 then
    L2_2 = nil
    return L2_2
  end
  L2_2 = A0_2.type
  if "number" == L2_2 then
    L3_2 = L9_1
    L4_2 = A1_2
    L5_2 = -1.0E9
    L6_2 = 1.0E9
    L7_2 = nil
    L3_2 = L3_2(L4_2, L5_2, L6_2, L7_2)
    if nil ~= L3_2 then
      L4_2 = A0_2.min
      if L4_2 then
        L4_2 = A0_2.min
        if L3_2 < L4_2 then
          goto lbl_30
        end
      end
      L4_2 = A0_2.max
      if not L4_2 then
        goto lbl_32
      end
      L4_2 = A0_2.max
      if not (L3_2 > L4_2) then
        goto lbl_32
      end
    end
    ::lbl_30::
    L4_2 = nil
    do return L4_2 end
    ::lbl_32::
    return L3_2
  elseif "checkbox" == L2_2 then
    if true == A1_2 or "true" == A1_2 then
      L3_2 = true
      return L3_2
    elseif false == A1_2 or "false" == A1_2 then
      L3_2 = false
      return L3_2
    end
    L3_2 = nil
    return L3_2
  elseif "select" == L2_2 then
    L3_2 = ipairs
    L4_2 = A0_2.options
    if not L4_2 then
      L4_2 = {}
    end
    L3_2, L4_2, L5_2, L6_2 = L3_2(L4_2)
    for L7_2, L8_2 in L3_2, L4_2, L5_2, L6_2 do
      if L8_2 == A1_2 then
        return A1_2
      end
    end
    L3_2 = nil
    return L3_2
  elseif "multiselect" == L2_2 then
    L3_2 = {}
    L4_2 = {}
    L5_2 = {}
    L6_2 = ipairs
    L7_2 = A0_2.options
    if not L7_2 then
      L7_2 = {}
    end
    L6_2, L7_2, L8_2, L9_2 = L6_2(L7_2)
    for L10_2, L11_2 in L6_2, L7_2, L8_2, L9_2 do
      L3_2[L11_2] = true
    end
    L6_2 = ipairs
    L7_2 = L15_1
    L8_2 = A1_2
    L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2 = L7_2(L8_2)
    L6_2, L7_2, L8_2, L9_2 = L6_2(L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2)
    for L10_2, L11_2 in L6_2, L7_2, L8_2, L9_2 do
      L12_2 = type
      L13_2 = L11_2
      L12_2 = L12_2(L13_2)
      if "string" == L12_2 then
        L12_2 = L3_2[L11_2]
        if L12_2 then
          L12_2 = L5_2[L11_2]
          if not L12_2 then
            L5_2[L11_2] = true
            L12_2 = #L4_2
            L12_2 = L12_2 + 1
            L4_2[L12_2] = L11_2
          end
        end
      end
    end
    L6_2 = #L4_2
    L6_2 = L4_2 or L6_2
    if not (L6_2 > 0) or not L4_2 then
      L6_2 = nil
    end
    return L6_2
  elseif "rating" == L2_2 then
    L3_2 = tonumber
    L4_2 = A1_2
    L3_2 = L3_2(L4_2)
    if L3_2 then
      L4_2 = math
      L4_2 = L4_2.floor
      L5_2 = L3_2
      L4_2 = L4_2(L5_2)
      if not (L3_2 ~= L4_2 or L3_2 < 1 or L3_2 > 5) then
        goto lbl_143
      end
    end
    L4_2 = nil
    do return L4_2 end
    ::lbl_143::
    L4_2 = math
    L4_2 = L4_2.floor
    L5_2 = L3_2
    return L4_2(L5_2)
  elseif "date" == L2_2 then
    L3_2 = L46_1
    L4_2 = A1_2
    L3_2 = L3_2(L4_2)
    L3_2 = A1_2 or L3_2
    if not L3_2 or not A1_2 then
      L3_2 = nil
    end
    return L3_2
  elseif "time" == L2_2 then
    L3_2 = L47_1
    L4_2 = A1_2
    L3_2 = L3_2(L4_2)
    L3_2 = A1_2 or L3_2
    if not L3_2 or not A1_2 then
      L3_2 = nil
    end
    return L3_2
  elseif "email" == L2_2 then
    L3_2 = L48_1
    L4_2 = A1_2
    L3_2 = L3_2(L4_2)
    L3_2 = A1_2 or L3_2
    if not L3_2 or not A1_2 then
      L3_2 = nil
    end
    return L3_2
  elseif "url" == L2_2 then
    L3_2 = L14_1
    L4_2 = A1_2
    L3_2 = L3_2(L4_2)
    L4_2 = L3_2 or L4_2
    if "" == L3_2 or not L3_2 then
      L4_2 = nil
    end
    return L4_2
  elseif "photo" == L2_2 then
    L3_2 = nil
    return L3_2
  end
  L3_2 = L38_1
  L3_2 = L3_2[L2_2]
  if not L3_2 then
    L3_2 = 200
  end
  if "textarea" == L2_2 then
    L4_2 = L6_1
    L5_2 = A1_2
    L6_2 = L3_2
    L7_2 = ""
    L4_2 = L4_2(L5_2, L6_2, L7_2)
    if L4_2 then
      goto lbl_220
    end
  end
  L4_2 = L5_1
  L5_2 = A1_2
  L6_2 = L3_2
  L7_2 = ""
  L4_2 = L4_2(L5_2, L6_2, L7_2)
  ::lbl_220::
  if "" == L4_2 then
    L5_2 = nil
    return L5_2
  end
  L5_2 = A0_2.max
  if L5_2 then
    L5_2 = utf8
    L5_2 = L5_2.len
    L6_2 = L4_2
    L5_2 = L5_2(L6_2)
    L6_2 = A0_2.max
    if L5_2 > L6_2 then
      L5_2 = nil
      return L5_2
    end
  end
  return L4_2
end
function L51_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2, L19_2, L20_2, L21_2, L22_2, L23_2, L24_2, L25_2
  L2_2 = {}
  L3_2 = {}
  L4_2 = ipairs
  L5_2 = L15_1
  L6_2 = A0_2
  L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2, L19_2, L20_2, L21_2, L22_2, L23_2, L24_2, L25_2 = L5_2(L6_2)
  L4_2, L5_2, L6_2, L7_2 = L4_2(L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2, L19_2, L20_2, L21_2, L22_2, L23_2, L24_2, L25_2)
  for L8_2, L9_2 in L4_2, L5_2, L6_2, L7_2 do
    L10_2 = #L2_2
    if A1_2 <= L10_2 then
      break
    end
    L10_2 = type
    L11_2 = L9_2
    L10_2 = L10_2(L11_2)
    if "table" == L10_2 then
      L10_2 = L11_1
      L11_2 = L9_2.key
      L12_2 = 1
      L13_2 = 24
      L10_2 = L10_2(L11_2, L12_2, L13_2)
      L11_2 = L5_1
      L12_2 = L9_2.label
      L13_2 = 60
      L11_2 = L11_2(L12_2, L13_2)
      if L10_2 then
        L12_2 = L3_2[L10_2]
        if not L12_2 and L11_2 and "" ~= L11_2 then
          L13_2 = L9_2.type
          L12_2 = L36_1
          L12_2 = L12_2[L13_2]
          if L12_2 then
            L12_2 = L9_2.type
            if L12_2 then
              goto lbl_46
            end
          end
          L12_2 = "text"
          ::lbl_46::
          L13_2 = {}
          L13_2.key = L10_2
          L13_2.label = L11_2
          L13_2.type = L12_2
          L14_2 = L37_1
          L14_2 = L14_2[L12_2]
          L14_2 = not L14_2
          L13_2.required = L14_2
          if "info" == L12_2 then
            L14_2 = L6_1
            L15_2 = L9_2.help
            L16_2 = 600
            L17_2 = ""
            L14_2 = L14_2(L15_2, L16_2, L17_2)
            if "" ~= L14_2 then
              L13_2.help = L14_2
            end
          else
            L14_2 = L5_1
            L15_2 = L9_2.help
            L16_2 = 120
            L17_2 = ""
            L14_2 = L14_2(L15_2, L16_2, L17_2)
            if "" ~= L14_2 then
              L13_2.help = L14_2
            end
          end
          L14_2 = L37_1
          L14_2 = L14_2[L12_2]
          if not L14_2 then
            L14_2 = L5_1
            L15_2 = L9_2.placeholder
            L16_2 = 80
            L14_2 = L14_2(L15_2, L16_2)
            if L14_2 and "" ~= L14_2 and "checkbox" ~= L12_2 and "rating" ~= L12_2 and "photo" ~= L12_2 then
              L13_2.placeholder = L14_2
            end
            if "select" == L12_2 or "multiselect" == L12_2 then
              L15_2 = L49_1
              L16_2 = L9_2.options
              L15_2 = L15_2(L16_2)
              L16_2 = #L15_2
              if 0 == L16_2 then
                L13_2.type = "text"
                L12_2 = "text"
              else
                L13_2.options = L15_2
              end
            end
            if "number" == L12_2 then
              L15_2 = L9_1
              L16_2 = L9_2.min
              L17_2 = -1.0E9
              L18_2 = 1.0E9
              L19_2 = nil
              L15_2 = L15_2(L16_2, L17_2, L18_2, L19_2)
              L13_2.min = L15_2
              L15_2 = L9_1
              L16_2 = L9_2.max
              L17_2 = -1.0E9
              L18_2 = 1.0E9
              L19_2 = nil
              L15_2 = L15_2(L16_2, L17_2, L18_2, L19_2)
              L13_2.max = L15_2
            else
              L15_2 = L38_1
              L15_2 = L15_2[L12_2]
              if L15_2 then
                L15_2 = L8_1
                L16_2 = L9_2.min
                L17_2 = 0
                L18_2 = L38_1
                L18_2 = L18_2[L12_2]
                L19_2 = nil
                L15_2 = L15_2(L16_2, L17_2, L18_2, L19_2)
                L13_2.min = L15_2
                L15_2 = L8_1
                L16_2 = L9_2.max
                L17_2 = 1
                L18_2 = L38_1
                L18_2 = L18_2[L12_2]
                L19_2 = nil
                L15_2 = L15_2(L16_2, L17_2, L18_2, L19_2)
                L13_2.max = L15_2
                L15_2 = L13_2.min
                if 0 == L15_2 then
                  L13_2.min = nil
                end
              end
            end
            L15_2 = L13_2.min
            if L15_2 then
              L15_2 = L13_2.max
              if L15_2 then
                L15_2 = L13_2.min
                L16_2 = L13_2.max
                if L15_2 > L16_2 then
                  L15_2 = nil
                  L16_2 = "range"
                  L17_2 = L10_2
                  return L15_2, L16_2, L17_2
                end
              end
            end
            L15_2 = L50_1
            L16_2 = L13_2
            L17_2 = L9_2.default
            L15_2 = L15_2(L16_2, L17_2)
            if nil ~= L15_2 then
              L13_2.default = L15_2
            end
          end
          L14_2 = L9_2.showIf
          L15_2 = type
          L16_2 = L14_2
          L15_2 = L15_2(L16_2)
          if "table" == L15_2 then
            L15_2 = L14_2.key
            if nil ~= L15_2 then
              L15_2 = L14_2.key
              if "" ~= L15_2 then
                L15_2 = L11_1
                L16_2 = L14_2.key
                L17_2 = 1
                L18_2 = 24
                L15_2 = L15_2(L16_2, L17_2, L18_2)
                L16_2 = L15_2
                if L15_2 then
                  L16_2 = L3_2[L15_2]
                end
                if L16_2 then
                  L18_2 = L16_2.type
                  L17_2 = L37_1
                  L17_2 = L17_2[L18_2]
                  if not L17_2 then
                    L17_2 = L16_2.type
                    if "photo" ~= L17_2 then
                      goto lbl_209
                    end
                  end
                end
                L17_2 = nil
                L18_2 = "showif"
                L19_2 = L10_2
                do return L17_2, L18_2, L19_2 end
                ::lbl_209::
                L17_2 = L14_2.equals
                L18_2 = type
                L19_2 = L17_2
                L18_2 = L18_2(L19_2)
                if "boolean" == L18_2 then
                  L18_2 = tostring
                  L19_2 = L17_2
                  L18_2 = L18_2(L19_2)
                  L17_2 = L18_2
                end
                L18_2 = L5_1
                L19_2 = L17_2
                L20_2 = 60
                L21_2 = ""
                L18_2 = L18_2(L19_2, L20_2, L21_2)
                L17_2 = L18_2
                if "" == L17_2 then
                  L18_2 = nil
                  L19_2 = "showif"
                  L20_2 = L10_2
                  return L18_2, L19_2, L20_2
                end
                L18_2 = L16_2.type
                if "checkbox" == L18_2 then
                  if "true" ~= L17_2 and "false" ~= L17_2 then
                    L18_2 = nil
                    L19_2 = "showif"
                    L20_2 = L10_2
                    return L18_2, L19_2, L20_2
                  end
                elseif "select" == L16_2.type or "multiselect" == L16_2.type then
                  L18_2 = false
                  L19_2 = ipairs
                  L20_2 = L16_2.options
                  if not L20_2 then
                    L20_2 = {}
                  end
                  L19_2, L20_2, L21_2, L22_2 = L19_2(L20_2)
                  for L23_2, L24_2 in L19_2, L20_2, L21_2, L22_2 do
                    if L24_2 == L17_2 then
                      L18_2 = true
                    end
                  end
                  if not L18_2 then
                    L19_2 = nil
                    L20_2 = "showif"
                    L21_2 = L10_2
                    return L19_2, L20_2, L21_2
                  end
                elseif "number" == L16_2.type or "rating" == L16_2.type then
                  L18_2 = tonumber
                  L19_2 = L17_2
                  L18_2 = L18_2(L19_2)
                  if not L18_2 then
                    L18_2 = nil
                    L19_2 = "showif"
                    L20_2 = L10_2
                    return L18_2, L19_2, L20_2
                  end
                end
                ::lbl_286::
                L18_2 = {}
                L18_2.key = L15_2
                L18_2.equals = L17_2
                L13_2.showIf = L18_2
              end
            end
          end
          L3_2[L10_2] = L13_2
          L15_2 = #L2_2
          L15_2 = L15_2 + 1
          L2_2[L15_2] = L13_2
        end
      end
    end
  end
  return L2_2
end
function L52_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2
  L2_2 = {}
  L3_2 = {}
  L4_2 = ipairs
  L5_2 = L15_1
  L6_2 = A0_2
  L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2 = L5_2(L6_2)
  L4_2, L5_2, L6_2, L7_2 = L4_2(L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2)
  for L8_2, L9_2 in L4_2, L5_2, L6_2, L7_2 do
    L10_2 = #L2_2
    if L10_2 >= 10 then
      break
    end
    L10_2 = type
    L11_2 = L9_2
    L10_2 = L10_2(L11_2)
    if "table" == L10_2 then
      L10_2 = L11_1
      L11_2 = L9_2.id
      L12_2 = 1
      L13_2 = 24
      L10_2 = L10_2(L11_2, L12_2, L13_2)
      L11_2 = L5_1
      L12_2 = L9_2.label
      L13_2 = 24
      L11_2 = L11_2(L12_2, L13_2)
      if L10_2 then
        L12_2 = L3_2[L10_2]
        if not L12_2 and L11_2 and "" ~= L11_2 then
          L3_2[L10_2] = true
          L12_2 = #L2_2
          L12_2 = L12_2 + 1
          L13_2 = {}
          L13_2.id = L10_2
          L13_2.label = L11_2
          L14_2 = L10_1
          L15_2 = L9_2.color
          L16_2 = "#5B8CFF"
          L14_2 = L14_2(L15_2, L16_2)
          L13_2.color = L14_2
          L14_2 = L9_2.closed
          L14_2 = true == L14_2 or L14_2
          L13_2.closed = L14_2
          L14_2 = L9_2.notify
          L14_2 = false ~= L14_2
          L13_2.notify = L14_2
          L2_2[L12_2] = L13_2
        end
      end
    end
  end
  L4_2 = #L2_2
  if 0 == L4_2 then
    L4_2 = L2_1
    L5_2 = A1_2 or L5_2
    if not A1_2 then
      L5_2 = L44_1
    end
    return L4_2(L5_2)
  end
  return L2_2
end
function L53_1(A0_2)
  local L1_2, L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2
  L1_2 = {}
  L2_2 = {}
  L3_2 = ipairs
  L4_2 = L15_1
  L5_2 = A0_2
  L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2 = L4_2(L5_2)
  L3_2, L4_2, L5_2, L6_2 = L3_2(L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2)
  for L7_2, L8_2 in L3_2, L4_2, L5_2, L6_2 do
    L9_2 = #L1_2
    if L9_2 >= 16 then
      break
    end
    L9_2 = type
    L10_2 = L8_2
    L9_2 = L9_2(L10_2)
    if "table" == L9_2 then
      L9_2 = L11_1
      L10_2 = L8_2.id
      L11_2 = 1
      L12_2 = 24
      L9_2 = L9_2(L10_2, L11_2, L12_2)
      L10_2 = L5_1
      L11_2 = L8_2.label
      L12_2 = 24
      L10_2 = L10_2(L11_2, L12_2)
      if L9_2 then
        L11_2 = L2_2[L9_2]
        if not L11_2 and L10_2 and "" ~= L10_2 then
          L2_2[L9_2] = true
          L11_2 = #L1_2
          L11_2 = L11_2 + 1
          L12_2 = {}
          L12_2.id = L9_2
          L12_2.label = L10_2
          L13_2 = L10_1
          L14_2 = L8_2.color
          L15_2 = "#8A8F98"
          L13_2 = L13_2(L14_2, L15_2)
          L12_2.color = L13_2
          L1_2[L11_2] = L12_2
        end
      end
    end
  end
  return L1_2
end
function L54_1(A0_2)
  local L1_2, L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2
  L1_2 = {}
  L2_2 = {}
  L3_2 = ipairs
  L4_2 = L15_1
  L5_2 = A0_2
  L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2 = L4_2(L5_2)
  L3_2, L4_2, L5_2, L6_2 = L3_2(L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2)
  for L7_2, L8_2 in L3_2, L4_2, L5_2, L6_2 do
    L9_2 = L8_1
    L10_2 = L8_2
    L11_2 = 1
    L12_2 = 7
    L13_2 = nil
    L9_2 = L9_2(L10_2, L11_2, L12_2, L13_2)
    L8_2 = L9_2
    if L8_2 then
      L9_2 = L1_2[L8_2]
      if not L9_2 then
        L1_2[L8_2] = true
        L9_2 = #L2_2
        L9_2 = L9_2 + 1
        L2_2[L9_2] = L8_2
      end
    end
  end
  L3_2 = table
  L3_2 = L3_2.sort
  L4_2 = L2_2
  L3_2(L4_2)
  return L2_2
end
function L55_1(A0_2, A1_2, A2_2)
  local L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2
  L3_2 = type
  L4_2 = A0_2
  L3_2 = L3_2(L4_2)
  if "table" ~= L3_2 or not A0_2 then
    L3_2 = {}
    A0_2 = L3_2
  end
  L3_2 = L8_1
  L4_2 = A0_2.from
  L5_2 = 0
  L6_2 = 23
  L7_2 = A1_2 or L7_2
  if not A1_2 then
    L7_2 = 9
  end
  L3_2 = L3_2(L4_2, L5_2, L6_2, L7_2)
  L4_2 = L8_1
  L5_2 = A0_2.to
  L6_2 = 1
  L7_2 = 24
  L8_2 = A2_2 or L8_2
  if not A2_2 then
    L8_2 = 18
  end
  L4_2 = L4_2(L5_2, L6_2, L7_2, L8_2)
  if L3_2 >= L4_2 then
    L5_2 = nil
    return L5_2
  end
  L5_2 = L54_1
  L6_2 = A0_2.days
  L5_2 = L5_2(L6_2)
  L6_2 = #L5_2
  if 0 == L6_2 then
    L6_2 = {}
    L7_2 = 1
    L8_2 = 2
    L9_2 = 3
    L10_2 = 4
    L11_2 = 5
    L6_2[1] = L7_2
    L6_2[2] = L8_2
    L6_2[3] = L9_2
    L6_2[4] = L10_2
    L6_2[5] = L11_2
    L5_2 = L6_2
  end
  L6_2 = {}
  L6_2.from = L3_2
  L6_2.to = L4_2
  L6_2.days = L5_2
  return L6_2
end
L56_1 = {}
function L57_1(A0_2)
  local L1_2, L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2
  L1_2 = ipairs
  L2_2 = A0_2
  L1_2, L2_2, L3_2, L4_2 = L1_2(L2_2)
  for L5_2, L6_2 in L1_2, L2_2, L3_2, L4_2 do
    L8_2 = L6_2.type
    L7_2 = L37_1
    L7_2 = L7_2[L8_2]
    if not L7_2 then
      L7_2 = true
      return L7_2
    end
  end
  L1_2 = false
  return L1_2
end
function L58_1(A0_2)
  local L1_2, L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2
  L1_2 = L51_1
  L2_2 = A0_2.fields
  L3_2 = 24
  L1_2, L2_2, L3_2 = L1_2(L2_2, L3_2)
  if not L1_2 then
    L4_2 = nil
    L5_2 = L2_2
    L6_2 = L3_2
    return L4_2, L5_2, L6_2
  end
  L4_2 = L57_1
  L5_2 = L1_2
  L4_2 = L4_2(L5_2)
  if not L4_2 then
    L4_2 = nil
    L5_2 = "fields"
    return L4_2, L5_2
  end
  L4_2 = {}
  L4_2.fields = L1_2
  L5_2 = L7_1
  L6_2 = A0_2.anonymous
  L7_2 = false
  L5_2 = L5_2(L6_2, L7_2)
  L4_2.anonymous = L5_2
  L5_2 = L7_1
  L6_2 = A0_2.location
  L7_2 = false
  L5_2 = L5_2(L6_2, L7_2)
  L4_2.location = L5_2
  L5_2 = L7_1
  L6_2 = A0_2.photo
  L7_2 = false
  L5_2 = L5_2(L6_2, L7_2)
  L4_2.photo = L5_2
  L5_2 = L52_1
  L6_2 = A0_2.statuses
  L5_2 = L5_2(L6_2)
  L4_2.statuses = L5_2
  L5_2 = L7_1
  L6_2 = A0_2.civilSeesOwn
  L7_2 = true
  L5_2 = L5_2(L6_2, L7_2)
  L4_2.civilSeesOwn = L5_2
  L5_2 = L7_1
  L6_2 = A0_2.replies
  L7_2 = true
  L5_2 = L5_2(L6_2, L7_2)
  L4_2.replies = L5_2
  L5_2 = L5_1
  L6_2 = A0_2.submitLabel
  L7_2 = 30
  L8_2 = ""
  L5_2 = L5_2(L6_2, L7_2, L8_2)
  if "" ~= L5_2 then
    L5_2 = L5_1
    L6_2 = A0_2.submitLabel
    L7_2 = 30
    L5_2 = L5_2(L6_2, L7_2)
    if L5_2 then
      goto lbl_65
    end
  end
  L5_2 = "Enviar"
  ::lbl_65::
  L4_2.submitLabel = L5_2
  L5_2 = L6_1
  L6_2 = A0_2.intro
  L7_2 = 500
  L8_2 = ""
  L5_2 = L5_2(L6_2, L7_2, L8_2)
  L4_2.intro = L5_2
  L5_2 = L8_1
  L6_2 = A0_2.deleteGrade
  L7_2 = 0
  L8_2 = 100
  L9_2 = 0
  L5_2 = L5_2(L6_2, L7_2, L8_2, L9_2)
  L4_2.deleteGrade = L5_2
  return L4_2
end
L56_1.form = L58_1
function L58_1(A0_2)
  local L1_2, L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2
  L1_2 = {}
  L2_2 = {}
  L3_2 = ipairs
  L4_2 = L15_1
  L5_2 = A0_2.services
  L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2 = L4_2(L5_2)
  L3_2, L4_2, L5_2, L6_2 = L3_2(L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2)
  for L7_2, L8_2 in L3_2, L4_2, L5_2, L6_2 do
    L9_2 = #L1_2
    if L9_2 >= 12 then
      break
    end
    L9_2 = type
    L10_2 = L8_2
    L9_2 = L9_2(L10_2)
    if "table" == L9_2 then
      L9_2 = L5_1
      L10_2 = L8_2.label
      L11_2 = 40
      L9_2 = L9_2(L10_2, L11_2)
      L10_2 = L11_1
      L11_2 = L8_2.id
      L12_2 = 1
      L13_2 = 24
      L10_2 = L10_2(L11_2, L12_2, L13_2)
      if not L10_2 then
        L10_2 = "s"
        L11_2 = L7_2
        L10_2 = L10_2 .. L11_2
      end
      if L9_2 and "" ~= L9_2 then
        L11_2 = L2_2[L10_2]
        if not L11_2 then
          L2_2[L10_2] = true
          L11_2 = #L1_2
          L11_2 = L11_2 + 1
          L12_2 = {}
          L12_2.id = L10_2
          L12_2.label = L9_2
          L13_2 = L8_1
          L14_2 = L8_2.minutes
          L15_2 = 5
          L16_2 = 480
          L17_2 = 30
          L13_2 = L13_2(L14_2, L15_2, L16_2, L17_2)
          L12_2.minutes = L13_2
          L1_2[L11_2] = L12_2
        end
      end
    end
  end
  L3_2 = #L1_2
  if 0 == L3_2 then
    L3_2 = nil
    L4_2 = "services"
    return L3_2, L4_2
  end
  L3_2 = L55_1
  L4_2 = A0_2.hours
  L5_2 = 9
  L6_2 = 21
  L3_2 = L3_2(L4_2, L5_2, L6_2)
  if not L3_2 then
    L4_2 = nil
    L5_2 = "hours"
    return L4_2, L5_2
  end
  L4_2 = L54_1
  L5_2 = A0_2.days
  L4_2 = L4_2(L5_2)
  L5_2 = #L4_2
  if 0 == L5_2 then
    L5_2 = type
    L6_2 = A0_2.days
    L5_2 = L5_2(L6_2)
    if "table" == L5_2 then
      L5_2 = nil
      L6_2 = "days"
      return L5_2, L6_2
    end
    L4_2 = L3_2.days
  end
  L5_2 = {}
  L5_2.services = L1_2
  L6_2 = {}
  L7_2 = L3_2.from
  L6_2.from = L7_2
  L7_2 = L3_2.to
  L6_2.to = L7_2
  L5_2.hours = L6_2
  L5_2.days = L4_2
  L6_2 = L8_1
  L7_2 = A0_2.slot
  L8_2 = 5
  L9_2 = 240
  L10_2 = 30
  L6_2 = L6_2(L7_2, L8_2, L9_2, L10_2)
  L5_2.slot = L6_2
  L6_2 = L8_1
  L7_2 = A0_2.maxPerSlot
  L8_2 = 1
  L9_2 = 20
  L10_2 = 1
  L6_2 = L6_2(L7_2, L8_2, L9_2, L10_2)
  L5_2.maxPerSlot = L6_2
  L6_2 = L7_1
  L7_2 = A0_2.notes
  L8_2 = true
  L6_2 = L6_2(L7_2, L8_2)
  L5_2.notes = L6_2
  return L5_2
end
L56_1.appointments = L58_1
function L58_1(A0_2)
  local L1_2, L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2
  L1_2 = {}
  L2_2 = {}
  L3_2 = ipairs
  L4_2 = L15_1
  L5_2 = A0_2.types
  L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2 = L4_2(L5_2)
  L3_2, L4_2, L5_2, L6_2 = L3_2(L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2)
  for L7_2, L8_2 in L3_2, L4_2, L5_2, L6_2 do
    L9_2 = #L1_2
    if L9_2 >= 12 then
      break
    end
    L9_2 = type
    L10_2 = L8_2
    L9_2 = L9_2(L10_2)
    if "table" == L9_2 then
      L9_2 = L5_1
      L10_2 = L8_2.label
      L11_2 = 40
      L9_2 = L9_2(L10_2, L11_2)
      L10_2 = L11_1
      L11_2 = L8_2.id
      L12_2 = 1
      L13_2 = 24
      L10_2 = L10_2(L11_2, L12_2, L13_2)
      if not L10_2 then
        L10_2 = "t"
        L11_2 = L7_2
        L10_2 = L10_2 .. L11_2
      end
      if L9_2 and "" ~= L9_2 then
        L11_2 = L2_2[L10_2]
        if not L11_2 then
          L2_2[L10_2] = true
          L11_2 = #L1_2
          L11_2 = L11_2 + 1
          L12_2 = {}
          L12_2.id = L10_2
          L12_2.label = L9_2
          L13_2 = L12_1
          L14_2 = L8_2.icon
          L15_2 = "bolt"
          L13_2 = L13_2(L14_2, L15_2)
          L12_2.icon = L13_2
          L1_2[L11_2] = L12_2
        end
      end
    end
  end
  L3_2 = #L1_2
  if 0 == L3_2 then
    L3_2 = nil
    L4_2 = "types"
    return L3_2, L4_2
  end
  L3_2 = {}
  L3_2.types = L1_2
  L4_2 = L7_1
  L5_2 = A0_2.location
  L6_2 = true
  L4_2 = L4_2(L5_2, L6_2)
  L3_2.location = L4_2
  L4_2 = L8_1
  L5_2 = A0_2.cooldown
  L6_2 = 0
  L7_2 = 3600
  L8_2 = 60
  L4_2 = L4_2(L5_2, L6_2, L7_2, L8_2)
  L3_2.cooldown = L4_2
  return L3_2
end
L56_1.dispatch = L58_1
function L58_1(A0_2)
  local L1_2, L2_2, L3_2, L4_2, L5_2, L6_2, L7_2
  L1_2 = L51_1
  L2_2 = A0_2.fields
  L3_2 = 24
  L1_2, L2_2, L3_2 = L1_2(L2_2, L3_2)
  if not L1_2 then
    L4_2 = nil
    L5_2 = L2_2
    L6_2 = L3_2
    return L4_2, L5_2, L6_2
  end
  L4_2 = {}
  L4_2.fields = L1_2
  L6_2 = A0_2.subject
  L5_2 = L41_1
  L5_2 = L5_2[L6_2]
  if L5_2 then
    L5_2 = A0_2.subject
    if L5_2 then
      goto lbl_23
    end
  end
  L5_2 = "person"
  ::lbl_23::
  L4_2.subject = L5_2
  L5_2 = L53_1
  L6_2 = A0_2.tags
  L5_2 = L5_2(L6_2)
  L4_2.tags = L5_2
  L5_2 = L7_1
  L6_2 = A0_2.civilSeesOwn
  L7_2 = false
  L5_2 = L5_2(L6_2, L7_2)
  L4_2.civilSeesOwn = L5_2
  return L4_2
end
L56_1.records = L58_1
function L58_1(A0_2)
  local L1_2, L2_2, L3_2, L4_2, L5_2, L6_2
  L1_2 = {}
  L2_2 = L8_1
  L3_2 = A0_2.postGrade
  L4_2 = 0
  L5_2 = 100
  L6_2 = 0
  L2_2 = L2_2(L3_2, L4_2, L5_2, L6_2)
  L1_2.postGrade = L2_2
  L2_2 = L7_1
  L3_2 = A0_2.notifyAll
  L4_2 = false
  L2_2 = L2_2(L3_2, L4_2)
  L1_2.notifyAll = L2_2
  L2_2 = A0_2.audience
  if "staff" == L2_2 then
    L2_2 = "staff"
    if L2_2 then
      goto lbl_22
    end
  end
  L2_2 = "all"
  ::lbl_22::
  L1_2.audience = L2_2
  L2_2 = L8_1
  L3_2 = A0_2.pinLimit
  L4_2 = 0
  L5_2 = 10
  L6_2 = 3
  L2_2 = L2_2(L3_2, L4_2, L5_2, L6_2)
  L1_2.pinLimit = L2_2
  return L1_2
end
L56_1.posts = L58_1
function L58_1(A0_2)
  local L1_2, L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2, L19_2, L20_2
  L1_2 = {}
  L2_2 = {}
  L3_2 = ipairs
  L4_2 = L15_1
  L5_2 = A0_2.categories
  L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2, L19_2, L20_2 = L4_2(L5_2)
  L3_2, L4_2, L5_2, L6_2 = L3_2(L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2, L19_2, L20_2)
  for L7_2, L8_2 in L3_2, L4_2, L5_2, L6_2 do
    L9_2 = L5_1
    L10_2 = L8_2
    L11_2 = 30
    L9_2 = L9_2(L10_2, L11_2)
    if L9_2 and "" ~= L9_2 then
      L10_2 = L2_2[L9_2]
      if not L10_2 then
        L10_2 = #L1_2
        if L10_2 < 12 then
          L2_2[L9_2] = true
          L10_2 = #L1_2
          L10_2 = L10_2 + 1
          L1_2[L10_2] = L9_2
        end
      end
    end
  end
  L3_2 = {}
  L4_2 = {}
  L5_2 = ipairs
  L6_2 = L15_1
  L7_2 = A0_2.items
  L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2, L19_2, L20_2 = L6_2(L7_2)
  L5_2, L6_2, L7_2, L8_2 = L5_2(L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2, L19_2, L20_2)
  for L9_2, L10_2 in L5_2, L6_2, L7_2, L8_2 do
    L11_2 = #L3_2
    if L11_2 >= 60 then
      break
    end
    L11_2 = type
    L12_2 = L10_2
    L11_2 = L11_2(L12_2)
    if "table" == L11_2 then
      L11_2 = L5_1
      L12_2 = L10_2.label
      L13_2 = 40
      L11_2 = L11_2(L12_2, L13_2)
      L12_2 = L11_1
      L13_2 = L10_2.id
      L14_2 = 1
      L15_2 = 24
      L12_2 = L12_2(L13_2, L14_2, L15_2)
      if not L12_2 then
        L12_2 = "i"
        L13_2 = L9_2
        L12_2 = L12_2 .. L13_2
      end
      if L11_2 and "" ~= L11_2 then
        L13_2 = L4_2[L12_2]
        if not L13_2 then
          L4_2[L12_2] = true
          L13_2 = L9_1
          L14_2 = L10_2.price
          L15_2 = 0
          L16_2 = 10000000
          L17_2 = nil
          L13_2 = L13_2(L14_2, L15_2, L16_2, L17_2)
          if nil == L13_2 then
            L14_2 = nil
            L15_2 = "price"
            L16_2 = L12_2
            return L14_2, L15_2, L16_2
          end
          L14_2 = L5_1
          L15_2 = L10_2.category
          L16_2 = 30
          L17_2 = ""
          L14_2 = L14_2(L15_2, L16_2, L17_2)
          L15_2 = #L3_2
          L15_2 = L15_2 + 1
          L16_2 = {}
          L16_2.id = L12_2
          L16_2.label = L11_2
          L17_2 = L6_1
          L18_2 = L10_2.desc
          L19_2 = 200
          L20_2 = ""
          L17_2 = L17_2(L18_2, L19_2, L20_2)
          L16_2.desc = L17_2
          L17_2 = math
          L17_2 = L17_2.floor
          L18_2 = L13_2 * 100
          L18_2 = L18_2 + 0.5
          L17_2 = L17_2(L18_2)
          L17_2 = L17_2 / 100
          L16_2.price = L17_2
          L17_2 = L13_1
          L18_2 = L10_2.image
          L17_2 = L17_2(L18_2)
          L16_2.image = L17_2
          L17_2 = L2_2[L14_2]
          L17_2 = L14_2 or L17_2
          if not L17_2 or not L14_2 then
            L17_2 = ""
          end
          L16_2.category = L17_2
          L17_2 = L7_1
          L18_2 = L10_2.available
          L19_2 = true
          L17_2 = L17_2(L18_2, L19_2)
          L16_2.available = L17_2
          L3_2[L15_2] = L16_2
        end
      end
    end
  end
  L5_2 = #L3_2
  if 0 == L5_2 then
    L5_2 = nil
    L6_2 = "items"
    return L5_2, L6_2
  end
  L5_2 = L51_1
  L6_2 = A0_2.fields
  L7_2 = 12
  L5_2, L6_2, L7_2 = L5_2(L6_2, L7_2)
  if not L5_2 then
    L8_2 = nil
    L9_2 = L6_2
    L10_2 = L7_2
    return L8_2, L9_2, L10_2
  end
  L8_2 = L5_1
  L9_2 = A0_2.currency
  L10_2 = 4
  L11_2 = ""
  L8_2 = L8_2(L9_2, L10_2, L11_2)
  L9_2 = {}
  L9_2.items = L3_2
  L9_2.categories = L1_2
  L10_2 = L7_1
  L11_2 = A0_2.orderable
  L12_2 = true
  L10_2 = L10_2(L11_2, L12_2)
  L9_2.orderable = L10_2
  L10_2 = L7_1
  L11_2 = A0_2.billing
  L12_2 = false
  L10_2 = L10_2(L11_2, L12_2)
  L9_2.billing = L10_2
  L10_2 = L52_1
  L11_2 = A0_2.statuses
  L12_2 = L45_1
  L10_2 = L10_2(L11_2, L12_2)
  L9_2.statuses = L10_2
  L9_2.fields = L5_2
  L10_2 = L7_1
  L11_2 = A0_2.location
  L12_2 = false
  L10_2 = L10_2(L11_2, L12_2)
  L9_2.location = L10_2
  L10_2 = L8_1
  L11_2 = A0_2.maxQty
  L12_2 = 1
  L13_2 = 99
  L14_2 = 10
  L10_2 = L10_2(L11_2, L12_2, L13_2, L14_2)
  L9_2.maxQty = L10_2
  L10_2 = L8_2 or L10_2
  if "" == L8_2 or not L8_2 then
    L10_2 = Config
    L10_2 = L10_2.Currency
    if L10_2 then
      L10_2 = Config
      L10_2 = L10_2.Currency
      L10_2 = L10_2.symbol
      if L10_2 then
        goto lbl_200
      end
    end
    L10_2 = "$"
  end
  ::lbl_200::
  L9_2.currency = L10_2
  L10_2 = L6_1
  L11_2 = A0_2.intro
  L12_2 = 500
  L13_2 = ""
  L10_2 = L10_2(L11_2, L12_2, L13_2)
  L9_2.intro = L10_2
  L10_2 = L7_1
  L11_2 = A0_2.civilSeesOwn
  L12_2 = true
  L10_2 = L10_2(L11_2, L12_2)
  L9_2.civilSeesOwn = L10_2
  L10_2 = L7_1
  L11_2 = A0_2.replies
  L12_2 = true
  L10_2 = L10_2(L11_2, L12_2)
  L9_2.replies = L10_2
  return L9_2
end
L56_1.catalog = L58_1
function L58_1(A0_2)
  local L1_2, L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2
  L1_2 = L8_1
  L2_2 = A0_2.maxAmount
  L3_2 = 1
  L4_2 = L43_1
  L5_2 = math
  L5_2 = L5_2.min
  L6_2 = 100000
  L7_2 = L43_1
  L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2 = L5_2(L6_2, L7_2)
  L1_2 = L1_2(L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2)
  L2_2 = {}
  L3_2 = ipairs
  L4_2 = L15_1
  L5_2 = A0_2.presets
  L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2 = L4_2(L5_2)
  L3_2, L4_2, L5_2, L6_2 = L3_2(L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2)
  for L7_2, L8_2 in L3_2, L4_2, L5_2, L6_2 do
    L9_2 = #L2_2
    if L9_2 >= 12 then
      break
    end
    L9_2 = type
    L10_2 = L8_2
    L9_2 = L9_2(L10_2)
    if "table" == L9_2 then
      L9_2 = L5_1
      L10_2 = L8_2.label
      L11_2 = 40
      L12_2 = ""
      L9_2 = L9_2(L10_2, L11_2, L12_2)
      if "" ~= L9_2 then
        L10_2 = L8_1
        L11_2 = L8_2.amount
        L12_2 = 1
        L13_2 = 1000000000
        L14_2 = nil
        L10_2 = L10_2(L11_2, L12_2, L13_2, L14_2)
        if not L10_2 then
          L11_2 = nil
          L12_2 = "amount"
          L13_2 = L9_2
          return L11_2, L12_2, L13_2
        end
        if L1_2 < L10_2 then
          L11_2 = nil
          L12_2 = "preset"
          L13_2 = L9_2
          return L11_2, L12_2, L13_2
        end
        L11_2 = #L2_2
        L11_2 = L11_2 + 1
        L12_2 = {}
        L12_2.label = L9_2
        L12_2.amount = L10_2
        L2_2[L11_2] = L12_2
      end
    end
  end
  L3_2 = {}
  L4_2 = L7_1
  L5_2 = A0_2.society
  L6_2 = true
  L4_2 = L4_2(L5_2, L6_2)
  L3_2.society = L4_2
  L3_2.maxAmount = L1_2
  L3_2.presets = L2_2
  L4_2 = L7_1
  L5_2 = A0_2.reasonRequired
  L6_2 = true
  L4_2 = L4_2(L5_2, L6_2)
  L3_2.reasonRequired = L4_2
  return L3_2
end
L56_1.billing = L58_1
function L58_1(A0_2)
  local L1_2, L2_2, L3_2, L4_2, L5_2
  L1_2 = A0_2.esxOffPrefix
  if nil == L1_2 then
    L1_2 = "off"
  end
  L2_2 = type
  L3_2 = L1_2
  L2_2 = L2_2(L3_2)
  if "string" ~= L2_2 then
    L2_2 = nil
    L3_2 = "prefix"
    return L2_2, L3_2
  end
  L3_2 = L1_2
  L2_2 = L1_2.lower
  L2_2 = L2_2(L3_2)
  L1_2 = L2_2
  L2_2 = #L1_2
  if not (L2_2 > 12) then
    L3_2 = L1_2
    L2_2 = L1_2.match
    L4_2 = "^[a-z0-9_]*$"
    L2_2 = L2_2(L3_2, L4_2)
    if L2_2 then
      goto lbl_27
    end
  end
  L2_2 = nil
  L3_2 = "prefix"
  do return L2_2, L3_2 end
  ::lbl_27::
  L2_2 = {}
  L2_2.esxOffPrefix = L1_2
  L3_2 = L7_1
  L4_2 = A0_2.showTeam
  L5_2 = true
  L3_2 = L3_2(L4_2, L5_2)
  L2_2.showTeam = L3_2
  return L2_2
end
L56_1.duty = L58_1
function L58_1(A0_2)
  local L1_2, L2_2, L3_2, L4_2
  L1_2 = {}
  L2_2 = L7_1
  L3_2 = A0_2.showOffDuty
  L4_2 = false
  L2_2 = L2_2(L3_2, L4_2)
  L1_2.showOffDuty = L2_2
  return L1_2
end
L56_1.roster = L58_1
function L58_1(A0_2)
  local L1_2, L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2
  L1_2 = {}
  L2_2 = ipairs
  L3_2 = L15_1
  L4_2 = A0_2.blocks
  L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2 = L3_2(L4_2)
  L2_2, L3_2, L4_2, L5_2 = L2_2(L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2)
  for L6_2, L7_2 in L2_2, L3_2, L4_2, L5_2 do
    L8_2 = #L1_2
    if L8_2 >= 16 then
      break
    end
    L8_2 = type
    L9_2 = L7_2
    L8_2 = L8_2(L9_2)
    if "table" == L8_2 then
      L9_2 = L7_2.type
      L8_2 = L40_1
      L8_2 = L8_2[L9_2]
      if L8_2 then
        L8_2 = {}
        L9_2 = L7_2.type
        L8_2.type = L9_2
        L9_2 = L5_1
        L10_2 = L7_2.title
        L11_2 = 60
        L12_2 = ""
        L9_2 = L9_2(L10_2, L11_2, L12_2)
        L8_2.title = L9_2
        L9_2 = L6_1
        L10_2 = L7_2.text
        L11_2 = 1000
        L12_2 = ""
        L9_2 = L9_2(L10_2, L11_2, L12_2)
        L8_2.text = L9_2
        L9_2 = L7_2.type
        if "link" == L9_2 then
          L9_2 = L14_1
          L10_2 = L7_2.url
          L9_2 = L9_2(L10_2)
          L8_2.url = L9_2
        else
          L9_2 = L7_2.type
          if "image" == L9_2 then
            L9_2 = L13_1
            L10_2 = L7_2.url
            L9_2 = L9_2(L10_2)
            L8_2.url = L9_2
          else
            L9_2 = L7_2.type
            if "location" == L9_2 then
              L9_2 = L9_1
              L10_2 = L7_2.x
              L11_2 = -20000
              L12_2 = 20000
              L13_2 = nil
              L9_2 = L9_2(L10_2, L11_2, L12_2, L13_2)
              L8_2.x = L9_2
              L9_2 = L9_1
              L10_2 = L7_2.y
              L11_2 = -20000
              L12_2 = 20000
              L13_2 = nil
              L9_2 = L9_2(L10_2, L11_2, L12_2, L13_2)
              L8_2.y = L9_2
              L9_2 = L8_2.x
              if L9_2 then
                L9_2 = math
                L9_2 = L9_2.floor
                L10_2 = L8_2.x
                L10_2 = L10_2 * 100
                L10_2 = L10_2 + 0.5
                L9_2 = L9_2(L10_2)
                L9_2 = L9_2 / 100
                L8_2.x = L9_2
              end
              L9_2 = L8_2.y
              if L9_2 then
                L9_2 = math
                L9_2 = L9_2.floor
                L10_2 = L8_2.y
                L10_2 = L10_2 * 100
                L10_2 = L10_2 + 0.5
                L9_2 = L9_2(L10_2)
                L9_2 = L9_2 / 100
                L8_2.y = L9_2
              end
            else
              L9_2 = L7_2.type
              if "hours" == L9_2 then
                L9_2 = L55_1
                L10_2 = L7_2.hours
                L11_2 = 9
                L12_2 = 18
                L9_2 = L9_2(L10_2, L11_2, L12_2)
                L8_2.hours = L9_2
                L9_2 = L8_2.hours
                if not L9_2 then
                  L9_2 = nil
                  L10_2 = "hours"
                  return L9_2, L10_2
                end
              else
                L9_2 = L7_2.type
                if "contact" == L9_2 then
                  L9_2 = L5_1
                  L10_2 = L7_2.phone
                  L11_2 = 16
                  L12_2 = ""
                  L9_2 = L9_2(L10_2, L11_2, L12_2)
                  if "" ~= L9_2 then
                    L11_2 = L9_2
                    L10_2 = L9_2.match
                    L12_2 = "^[%d%+%-# %*]+$"
                    L10_2 = L10_2(L11_2, L12_2)
                    if L10_2 and L9_2 then
                      goto lbl_134
                      L10_2 = L9_2 or L10_2
                    end
                  end
                  L10_2 = ""
                  ::lbl_134::
                  L8_2.phone = L10_2
                end
              end
            end
          end
        end
        L9_2 = #L1_2
        L9_2 = L9_2 + 1
        L1_2[L9_2] = L8_2
      end
    end
  end
  L2_2 = {}
  L3_2 = L13_1
  L4_2 = A0_2.hero
  L3_2 = L3_2(L4_2)
  L2_2.hero = L3_2
  L2_2.blocks = L1_2
  return L2_2
end
L56_1.info = L58_1
function L58_1(A0_2)
  local L1_2, L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2, L19_2, L20_2, L21_2, L22_2, L23_2, L24_2, L25_2, L26_2, L27_2, L28_2, L29_2
  L1_2 = {}
  L2_2 = {}
  L3_2 = ipairs
  L4_2 = L15_1
  L5_2 = A0_2
  L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2, L19_2, L20_2, L21_2, L22_2, L23_2, L24_2, L25_2, L26_2, L27_2, L28_2, L29_2 = L4_2(L5_2)
  L3_2, L4_2, L5_2, L6_2 = L3_2(L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2, L19_2, L20_2, L21_2, L22_2, L23_2, L24_2, L25_2, L26_2, L27_2, L28_2, L29_2)
  for L7_2, L8_2 in L3_2, L4_2, L5_2, L6_2 do
    L9_2 = #L1_2
    L10_2 = L31_1
    if L9_2 >= L10_2 then
      break
    end
    L9_2 = type
    L10_2 = L8_2
    L9_2 = L9_2(L10_2)
    if "table" == L9_2 then
      L10_2 = L8_2.type
      L9_2 = L33_1
      L9_2 = L9_2[L10_2]
      if L9_2 then
        L9_2 = L11_1
        L10_2 = L8_2.id
        L11_2 = 1
        L12_2 = 24
        L9_2 = L9_2(L10_2, L11_2, L12_2)
        if L9_2 then
          L10_2 = L2_2[L9_2]
          if not L10_2 then
            goto lbl_53
          end
        end
        L10_2 = L8_2.type
        L11_2 = "_"
        L12_2 = L7_2
        L10_2 = L10_2 .. L11_2 .. L12_2
        L9_2 = L10_2
        while true do
          L10_2 = L2_2[L9_2]
          if not L10_2 then
            break
          end
          L10_2 = L9_2
          L11_2 = "_"
          L10_2 = L10_2 .. L11_2
          L9_2 = L10_2
        end
        L11_2 = L9_2
        L10_2 = L9_2.sub
        L12_2 = 1
        L13_2 = 24
        L10_2 = L10_2(L11_2, L12_2, L13_2)
        L9_2 = L10_2
        ::lbl_53::
        L2_2[L9_2] = true
        L11_2 = L8_2.type
        L10_2 = L56_1
        L10_2 = L10_2[L11_2]
        L11_2 = type
        L12_2 = L8_2.options
        L11_2 = L11_2(L12_2)
        if "table" == L11_2 then
          L11_2 = L8_2.options
          if L11_2 then
            goto lbl_67
          end
        end
        L11_2 = {}
        ::lbl_67::
        L10_2, L11_2, L12_2 = L10_2(L11_2)
        if not L10_2 then
          L13_2 = nil
          L14_2 = L11_2
          if L12_2 then
            L15_2 = L9_2
            L16_2 = " \194\183 "
            L17_2 = tostring
            L18_2 = L12_2
            L17_2 = L17_2(L18_2)
            L15_2 = L15_2 .. L16_2 .. L17_2
            if L15_2 then
              goto lbl_83
            end
          end
          L15_2 = L9_2
          ::lbl_83::
          return L13_2, L14_2, L15_2
        end
        L13_2 = {}
        L13_2.id = L9_2
        L14_2 = L8_2.type
        L13_2.type = L14_2
        L14_2 = L5_1
        L15_2 = L8_2.title
        L16_2 = 40
        L17_2 = ""
        L14_2 = L14_2(L15_2, L16_2, L17_2)
        if "" ~= L14_2 then
          L14_2 = L5_1
          L15_2 = L8_2.title
          L16_2 = 40
          L14_2 = L14_2(L15_2, L16_2)
          if L14_2 then
            goto lbl_105
          end
        end
        L15_2 = L8_2.type
        L14_2 = L34_1
        L14_2 = L14_2[L15_2]
        ::lbl_105::
        L13_2.title = L14_2
        L14_2 = L12_1
        L15_2 = L8_2.icon
        L16_2 = "grid"
        L14_2 = L14_2(L15_2, L16_2)
        L13_2.icon = L14_2
        L14_2 = L7_1
        L15_2 = L8_2.enabled
        L16_2 = true
        L14_2 = L14_2(L15_2, L16_2)
        L13_2.enabled = L14_2
        L14_2 = L7_1
        L15_2 = L8_2.civil
        L16_2 = true
        L14_2 = L14_2(L15_2, L16_2)
        L13_2.civil = L14_2
        L14_2 = L7_1
        L15_2 = L8_2.staff
        L16_2 = true
        L14_2 = L14_2(L15_2, L16_2)
        L13_2.staff = L14_2
        L14_2 = L8_1
        L15_2 = L8_2.staffMinGrade
        L16_2 = 0
        L17_2 = 100
        L18_2 = 0
        L14_2 = L14_2(L15_2, L16_2, L17_2, L18_2)
        L13_2.staffMinGrade = L14_2
        L13_2.options = L10_2
        L15_2 = L8_2.type
        L14_2 = L35_1
        L14_2 = L14_2[L15_2]
        if not L14_2 then
          L14_2 = L8_2.type
          if "posts" ~= L14_2 then
            goto lbl_146
          end
          L14_2 = L10_2.audience
          if "staff" ~= L14_2 then
            goto lbl_146
          end
        end
        L13_2.civil = false
        ::lbl_146::
        L14_2 = type
        L15_2 = L8_2.perms
        L14_2 = L14_2(L15_2)
        if "table" == L14_2 then
          L14_2 = L13_2.staffMinGrade
          L15_2 = {}
          L15_2.view = L14_2
          L15_2.reply = L14_2
          L15_2.status = L14_2
          L15_2.assign = L14_2
          L15_2.create = L14_2
          L16_2 = L8_1
          L17_2 = L10_2.deleteGrade
          L18_2 = 0
          L19_2 = 100
          L20_2 = L14_2
          L16_2 = L16_2(L17_2, L18_2, L19_2, L20_2)
          L15_2.delete = L16_2
          L16_2 = L8_2.type
          if "posts" == L16_2 then
            L16_2 = L10_2.postGrade
            L15_2.create = L16_2
          end
          L16_2 = {}
          L17_2 = ipairs
          L18_2 = L39_1
          L17_2, L18_2, L19_2, L20_2 = L17_2(L18_2)
          for L21_2, L22_2 in L17_2, L18_2, L19_2, L20_2 do
            L23_2 = L8_1
            L24_2 = L8_2.perms
            L24_2 = L24_2[L22_2]
            L25_2 = 0
            L26_2 = 99
            L27_2 = math
            L27_2 = L27_2.min
            L28_2 = L15_2[L22_2]
            L29_2 = 99
            L27_2, L28_2, L29_2 = L27_2(L28_2, L29_2)
            L23_2 = L23_2(L24_2, L25_2, L26_2, L27_2, L28_2, L29_2)
            L16_2[L22_2] = L23_2
          end
          L13_2.perms = L16_2
        end
        L14_2 = type
        L15_2 = L8_2.jobs
        L14_2 = L14_2(L15_2)
        if "table" == L14_2 then
          L14_2 = {}
          L15_2 = {}
          L16_2 = ipairs
          L17_2 = L8_2.jobs
          L16_2, L17_2, L18_2, L19_2 = L16_2(L17_2)
          for L20_2, L21_2 in L16_2, L17_2, L18_2, L19_2 do
            L22_2 = L5_1
            L23_2 = L21_2
            L24_2 = 40
            L25_2 = ""
            L22_2 = L22_2(L23_2, L24_2, L25_2)
            if "" ~= L22_2 then
              L24_2 = L22_2
              L23_2 = L22_2.match
              L25_2 = "^[%w_%-]+$"
              L23_2 = L23_2(L24_2, L25_2)
              if L23_2 then
                L23_2 = L15_2[L22_2]
                if not L23_2 then
                  L23_2 = #L14_2
                  if L23_2 < 20 then
                    L15_2[L22_2] = true
                    L23_2 = #L14_2
                    L23_2 = L23_2 + 1
                    L14_2[L23_2] = L22_2
                  end
                end
              end
            end
          end
          L16_2 = #L14_2
          if L16_2 > 0 then
            L13_2.jobs = L14_2
          end
        end
        L14_2 = #L1_2
        L14_2 = L14_2 + 1
        L1_2[L14_2] = L13_2
      end
    end
  end
  return L1_2
end
function L59_1(A0_2)
  local L1_2, L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2
  L1_2 = type
  L2_2 = A0_2
  L1_2 = L1_2(L2_2)
  if "table" ~= L1_2 or not A0_2 then
    L1_2 = {}
    A0_2 = L1_2
  end
  L1_2 = {}
  L1_2.url = ""
  L2_2 = {}
  L1_2.events = L2_2
  L2_2 = {}
  L1_2.urls = L2_2
  L2_2 = type
  L3_2 = A0_2.url
  L2_2 = L2_2(L3_2)
  if "string" == L2_2 then
    L2_2 = A0_2.url
    if "" ~= L2_2 then
      L2_2 = ValidWebhookUrl
      L3_2 = A0_2.url
      L2_2 = L2_2(L3_2)
      if not L2_2 then
        L2_2 = nil
        L3_2 = "webhook"
        L4_2 = "url"
        return L2_2, L3_2, L4_2
      end
      L2_2 = A0_2.url
      L1_2.url = L2_2
    end
  end
  L2_2 = type
  L3_2 = A0_2.events
  L2_2 = L2_2(L3_2)
  if "table" == L2_2 then
    L2_2 = A0_2.events
    if L2_2 then
      goto lbl_49
    end
  end
  L2_2 = {}
  ::lbl_49::
  L3_2 = type
  L4_2 = A0_2.urls
  L3_2 = L3_2(L4_2)
  if "table" == L3_2 then
    L3_2 = A0_2.urls
    if L3_2 then
      goto lbl_59
    end
  end
  L3_2 = {}
  ::lbl_59::
  L4_2 = ipairs
  L5_2 = L42_1
  L4_2, L5_2, L6_2, L7_2 = L4_2(L5_2)
  for L8_2, L9_2 in L4_2, L5_2, L6_2, L7_2 do
    L10_2 = L1_2.events
    L11_2 = L2_2[L9_2]
    L11_2 = true == L11_2
    L10_2[L9_2] = L11_2
    L10_2 = L3_2[L9_2]
    L11_2 = type
    L12_2 = L10_2
    L11_2 = L11_2(L12_2)
    if "string" == L11_2 and "" ~= L10_2 then
      L11_2 = ValidWebhookUrl
      L12_2 = L10_2
      L11_2 = L11_2(L12_2)
      if not L11_2 then
        L11_2 = nil
        L12_2 = "webhook"
        L13_2 = L9_2
        return L11_2, L12_2, L13_2
      end
      L11_2 = L1_2.urls
      L11_2[L9_2] = L10_2
    end
  end
  return L1_2
end
function L60_1(A0_2)
  local L1_2, L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2, L19_2, L20_2, L21_2, L22_2, L23_2, L24_2, L25_2, L26_2, L27_2, L28_2
  L1_2 = type
  L2_2 = A0_2
  L1_2 = L1_2(L2_2)
  if "table" ~= L1_2 then
    L1_2 = nil
    L2_2 = "invalid"
    return L1_2, L2_2
  end
  L1_2 = L11_1
  L2_2 = A0_2.id
  L3_2 = 2
  L4_2 = 32
  L1_2 = L1_2(L2_2, L3_2, L4_2)
  if not L1_2 then
    L2_2 = nil
    L3_2 = "id"
    return L2_2, L3_2
  end
  L2_2 = L5_1
  L3_2 = A0_2.name
  L4_2 = 24
  L5_2 = ""
  L2_2 = L2_2(L3_2, L4_2, L5_2)
  if "" == L2_2 then
    L3_2 = nil
    L4_2 = "name"
    return L3_2, L4_2
  end
  L3_2 = type
  L4_2 = A0_2.icon
  L3_2 = L3_2(L4_2)
  if "table" == L3_2 then
    L3_2 = A0_2.icon
    if L3_2 then
      goto lbl_39
    end
  end
  L3_2 = {}
  ::lbl_39::
  L4_2 = L10_1
  L5_2 = L3_2.bg
  L6_2 = "#1F5EFF"
  L4_2 = L4_2(L5_2, L6_2)
  L5_2 = {}
  L6_2 = L12_1
  L7_2 = L3_2.glyph
  L8_2 = "grid"
  L6_2 = L6_2(L7_2, L8_2)
  L5_2.glyph = L6_2
  L5_2.bg = L4_2
  L6_2 = L10_1
  L7_2 = L3_2.bg2
  L8_2 = L4_2
  L6_2 = L6_2(L7_2, L8_2)
  L5_2.bg2 = L6_2
  L6_2 = L10_1
  L7_2 = L3_2.fg
  L8_2 = "#FFFFFF"
  L6_2 = L6_2(L7_2, L8_2)
  L5_2.fg = L6_2
  L6_2 = L13_1
  L7_2 = L3_2.image
  L6_2 = L6_2(L7_2)
  L5_2.image = L6_2
  L6_2 = L32_1
  L6_2 = L6_2[1]
  L7_2 = ipairs
  L8_2 = L32_1
  L7_2, L8_2, L9_2, L10_2 = L7_2(L8_2)
  for L11_2, L12_2 in L7_2, L8_2, L9_2, L10_2 do
    L13_2 = A0_2.category
    if L12_2 == L13_2 then
      L6_2 = L12_2
    end
  end
  L7_2 = type
  L8_2 = A0_2.audience
  L7_2 = L7_2(L8_2)
  if "table" == L7_2 then
    L7_2 = A0_2.audience
    if L7_2 then
      goto lbl_88
    end
  end
  L7_2 = {}
  ::lbl_88::
  L8_2 = {}
  L9_2 = {}
  L10_2 = ipairs
  L11_2 = L15_1
  L12_2 = L7_2.jobs
  L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2, L19_2, L20_2, L21_2, L22_2, L23_2, L24_2, L25_2, L26_2, L27_2, L28_2 = L11_2(L12_2)
  L10_2, L11_2, L12_2, L13_2 = L10_2(L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2, L19_2, L20_2, L21_2, L22_2, L23_2, L24_2, L25_2, L26_2, L27_2, L28_2)
  for L14_2, L15_2 in L10_2, L11_2, L12_2, L13_2 do
    L16_2 = #L8_2
    if L16_2 >= 20 then
      break
    end
    L16_2 = type
    L17_2 = L15_2
    L16_2 = L16_2(L17_2)
    if "table" == L16_2 then
      L16_2 = L5_1
      L17_2 = L15_2.name
      L18_2 = 40
      L19_2 = ""
      L16_2 = L16_2(L17_2, L18_2, L19_2)
      if "" ~= L16_2 then
        L18_2 = L16_2
        L17_2 = L16_2.match
        L19_2 = "^[%w_%-]+$"
        L17_2 = L17_2(L18_2, L19_2)
        if L17_2 then
          L17_2 = L9_2[L16_2]
          if not L17_2 then
            L9_2[L16_2] = true
            L17_2 = #L8_2
            L17_2 = L17_2 + 1
            L18_2 = {}
            L18_2.name = L16_2
            L19_2 = L8_1
            L20_2 = L15_2.minGrade
            L21_2 = 0
            L22_2 = 100
            L23_2 = 0
            L19_2 = L19_2(L20_2, L21_2, L22_2, L23_2)
            L18_2.minGrade = L19_2
            L8_2[L17_2] = L18_2
          end
        end
      end
    end
  end
  L10_2 = type
  L11_2 = A0_2.contact
  L10_2 = L10_2(L11_2)
  if "table" == L10_2 then
    L10_2 = A0_2.contact
    if L10_2 then
      goto lbl_149
    end
  end
  L10_2 = {}
  ::lbl_149::
  L11_2 = L5_1
  L12_2 = L10_2.phone
  L13_2 = 16
  L14_2 = ""
  L11_2 = L11_2(L12_2, L13_2, L14_2)
  if "" ~= L11_2 then
    L13_2 = L11_2
    L12_2 = L11_2.match
    L14_2 = "^[%d%+%-# %*]+$"
    L12_2 = L12_2(L13_2, L14_2)
    if not L12_2 then
      L12_2 = nil
      L13_2 = "contact"
      return L12_2, L13_2
    end
  end
  L12_2 = L58_1
  L13_2 = A0_2.modules
  L12_2, L13_2, L14_2 = L12_2(L13_2)
  if not L12_2 then
    L15_2 = nil
    L16_2 = L13_2
    L17_2 = L14_2
    return L15_2, L16_2, L17_2
  end
  L15_2 = #L12_2
  if 0 == L15_2 then
    L15_2 = nil
    L16_2 = "modules"
    return L15_2, L16_2
  end
  L15_2 = ipairs
  L16_2 = L12_2
  L15_2, L16_2, L17_2, L18_2 = L15_2(L16_2)
  for L19_2, L20_2 in L15_2, L16_2, L17_2, L18_2 do
    L21_2 = L20_2.jobs
    if L21_2 then
      L21_2 = {}
      L22_2 = ipairs
      L23_2 = L20_2.jobs
      L22_2, L23_2, L24_2, L25_2 = L22_2(L23_2)
      for L26_2, L27_2 in L22_2, L23_2, L24_2, L25_2 do
        L28_2 = L9_2[L27_2]
        if L28_2 then
          L28_2 = #L21_2
          L28_2 = L28_2 + 1
          L21_2[L28_2] = L27_2
        end
      end
      L22_2 = #L21_2
      L22_2 = L21_2 or L22_2
      if not (L22_2 > 0) or not L21_2 then
        L22_2 = nil
      end
      L20_2.jobs = L22_2
    end
  end
  L15_2 = L59_1
  L16_2 = A0_2.webhooks
  L15_2, L16_2, L17_2 = L15_2(L16_2)
  if not L15_2 then
    L18_2 = nil
    L19_2 = L16_2
    L20_2 = L17_2
    return L18_2, L19_2, L20_2
  end
  L18_2 = {}
  L18_2.id = L1_2
  L18_2.name = L2_2
  L19_2 = L5_1
  L20_2 = A0_2.subtitle
  L21_2 = 60
  L22_2 = ""
  L19_2 = L19_2(L20_2, L21_2, L22_2)
  L18_2.subtitle = L19_2
  L19_2 = L6_1
  L20_2 = A0_2.description
  L21_2 = 300
  L22_2 = ""
  L19_2 = L19_2(L20_2, L21_2, L22_2)
  L18_2.description = L19_2
  L18_2.icon = L5_2
  L19_2 = L10_1
  L20_2 = A0_2.accent
  L21_2 = L4_2
  L19_2 = L19_2(L20_2, L21_2)
  L18_2.accent = L19_2
  L18_2.category = L6_2
  L19_2 = L7_1
  L20_2 = A0_2.enabled
  L21_2 = true
  L19_2 = L19_2(L20_2, L21_2)
  L18_2.enabled = L19_2
  L19_2 = L7_1
  L20_2 = A0_2.listed
  L21_2 = true
  L19_2 = L19_2(L20_2, L21_2)
  L18_2.listed = L19_2
  L19_2 = L7_1
  L20_2 = A0_2.preinstalled
  L21_2 = false
  L19_2 = L19_2(L20_2, L21_2)
  L18_2.preinstalled = L19_2
  L19_2 = {}
  L20_2 = L7_1
  L21_2 = L7_2.public
  L22_2 = true
  L20_2 = L20_2(L21_2, L22_2)
  L19_2.public = L20_2
  L19_2.jobs = L8_2
  L20_2 = L7_1
  L21_2 = L7_2.onDutyOnly
  L22_2 = false
  L20_2 = L20_2(L21_2, L22_2)
  L19_2.onDutyOnly = L20_2
  L18_2.audience = L19_2
  L19_2 = {}
  L19_2.phone = L11_2
  L20_2 = L5_1
  L21_2 = L10_2.label
  L22_2 = 30
  L23_2 = ""
  L20_2 = L20_2(L21_2, L22_2, L23_2)
  L19_2.label = L20_2
  L18_2.contact = L19_2
  L19_2 = {}
  L20_2 = L7_1
  L21_2 = type
  L22_2 = A0_2.notify
  L21_2 = L21_2(L22_2)
  L21_2 = A0_2.notify
  L21_2 = "table" == L21_2 and L21_2
  L22_2 = true
  L20_2 = L20_2(L21_2, L22_2)
  L19_2.staff = L20_2
  L18_2.notify = L19_2
  L18_2.modules = L12_2
  L18_2.webhooks = L15_2
  L19_2 = L8_1
  L20_2 = A0_2.created
  L21_2 = 0
  L22_2 = 9.0E15
  L23_2 = L1_1
  L23_2, L24_2, L25_2, L26_2, L27_2, L28_2 = L23_2()
  L19_2 = L19_2(L20_2, L21_2, L22_2, L23_2, L24_2, L25_2, L26_2, L27_2, L28_2)
  L18_2.created = L19_2
  L19_2 = L1_1
  L19_2 = L19_2()
  L18_2.updated = L19_2
  return L18_2
end
AdminSanitizeCApp = L60_1
function L60_1()
  local L0_2, L1_2, L2_2
  L0_2 = AdminStore
  L0_2 = L0_2.Get
  L1_2 = "capps"
  L0_2 = L0_2(L1_2)
  L1_2 = type
  L2_2 = L0_2
  L1_2 = L1_2(L2_2)
  if "table" == L1_2 then
    L1_2 = type
    L2_2 = L0_2.apps
    L1_2 = L1_2(L2_2)
    if "table" == L1_2 then
      L1_2 = L0_2.apps
      if L1_2 then
        goto lbl_20
      end
    end
  end
  L1_2 = {}
  ::lbl_20::
  return L1_2
end
L61_1 = 10
function L62_1()
  local L0_2, L1_2, L2_2
  L0_2 = AdminStore
  L0_2 = L0_2.Get
  L1_2 = "capps_hist"
  L0_2 = L0_2(L1_2)
  L1_2 = type
  L2_2 = L0_2
  L1_2 = L1_2(L2_2)
  L1_2 = L0_2 or L1_2
  if "table" ~= L1_2 or not L0_2 then
    L1_2 = {}
  end
  return L1_2
end
function L63_1(A0_2, A1_2, A2_2)
  local L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2
  L3_2 = L2_1
  L4_2 = L62_1
  L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2 = L4_2()
  L3_2 = L3_2(L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2)
  L4_2 = type
  L5_2 = A1_2.id
  L5_2 = L3_2[L5_2]
  L4_2 = L4_2(L5_2)
  if "table" == L4_2 then
    L4_2 = A1_2.id
    L4_2 = L3_2[L4_2]
    if L4_2 then
      goto lbl_17
    end
  end
  L4_2 = {}
  ::lbl_17::
  L5_2 = #L4_2
  if 0 == L5_2 then
    L5_2 = type
    L6_2 = A2_2
    L5_2 = L5_2(L6_2)
    if "table" == L5_2 then
      L5_2 = {}
      L6_2 = L8_1
      L7_2 = A2_2.updated
      L8_2 = 0
      L9_2 = 9.0E15
      L10_2 = L1_1
      L10_2 = L10_2()
      L10_2 = L10_2 - 1000
      L6_2 = L6_2(L7_2, L8_2, L9_2, L10_2)
      L5_2.at = L6_2
      L5_2.by = ""
      L6_2 = L2_1
      L7_2 = A2_2
      L6_2 = L6_2(L7_2)
      L5_2.def = L6_2
      L4_2[1] = L5_2
    end
  end
  L5_2 = L1_1
  L5_2 = L5_2()
  L6_2 = L4_2[1]
  if L6_2 then
    L6_2 = tonumber
    L7_2 = L4_2[1]
    L7_2 = L7_2.at
    L6_2 = L6_2(L7_2)
    if not L6_2 then
      L6_2 = 0
    end
    if L5_2 <= L6_2 then
      L6_2 = tonumber
      L7_2 = L4_2[1]
      L7_2 = L7_2.at
      L6_2 = L6_2(L7_2)
      if not L6_2 then
        L6_2 = 0
      end
      L5_2 = L6_2 + 1
    end
  end
  L6_2 = table
  L6_2 = L6_2.insert
  L7_2 = L4_2
  L8_2 = 1
  L9_2 = {}
  L9_2.at = L5_2
  L10_2 = AdminName
  L11_2 = A0_2
  L10_2 = L10_2(L11_2)
  L9_2.by = L10_2
  L10_2 = L2_1
  L11_2 = A1_2
  L10_2 = L10_2(L11_2)
  L9_2.def = L10_2
  L6_2(L7_2, L8_2, L9_2)
  while true do
    L6_2 = #L4_2
    L7_2 = L61_1
    if not (L6_2 > L7_2) then
      break
    end
    L6_2 = #L4_2
    L4_2[L6_2] = nil
  end
  L6_2 = A1_2.id
  L3_2[L6_2] = L4_2
  L6_2 = AdminStore
  L6_2 = L6_2.Set
  L7_2 = "capps_hist"
  L8_2 = L3_2
  L9_2 = A0_2
  L6_2(L7_2, L8_2, L9_2)
end
function L64_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2, L6_2
  L2_2 = L62_1
  L2_2 = L2_2()
  L3_2 = L2_2[A1_2]
  if nil == L3_2 then
    return
  end
  L3_2 = L2_1
  L4_2 = L2_2
  L3_2 = L3_2(L4_2)
  L2_2 = L3_2
  L2_2[A1_2] = nil
  L3_2 = AdminStore
  L3_2 = L3_2.Set
  L4_2 = "capps_hist"
  L5_2 = next
  L6_2 = L2_2
  L5_2 = L5_2(L6_2)
  L5_2 = L2_2 or L5_2
  if not L5_2 or not L2_2 then
    L5_2 = nil
  end
  L6_2 = A0_2
  L3_2(L4_2, L5_2, L6_2)
end
L65_1 = {}
L65_1.done = true
L65_1.cancelled = true
L65_1.canceled = true
L65_1.closed = true
L65_1.resolved = true
L65_1.rejected = true
L65_1.archived = true
function L66_1()
  local L0_2, L1_2, L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2, L19_2, L20_2, L21_2, L22_2, L23_2
  L0_2 = {}
  L1_2 = L60_1
  L1_2 = L1_2()
  L2_2 = {}
  L3_2 = ipairs
  L4_2 = L1_2
  L3_2, L4_2, L5_2, L6_2 = L3_2(L4_2)
  for L7_2, L8_2 in L3_2, L4_2, L5_2, L6_2 do
    L9_2 = {}
    L10_2 = pairs
    L11_2 = L65_1
    L10_2, L11_2, L12_2, L13_2 = L10_2(L11_2)
    for L14_2 in L10_2, L11_2, L12_2, L13_2 do
      L9_2[L14_2] = true
    end
    L10_2 = ipairs
    L11_2 = L15_1
    L12_2 = L8_2.modules
    L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2, L19_2, L20_2, L21_2, L22_2, L23_2 = L11_2(L12_2)
    L10_2, L11_2, L12_2, L13_2 = L10_2(L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2, L19_2, L20_2, L21_2, L22_2, L23_2)
    for L14_2, L15_2 in L10_2, L11_2, L12_2, L13_2 do
      L16_2 = ipairs
      L17_2 = L15_1
      L18_2 = type
      L19_2 = L15_2.options
      L18_2 = L18_2(L19_2)
      if "table" == L18_2 then
        L18_2 = L15_2.options
        L18_2 = L18_2.statuses
        if L18_2 then
          goto lbl_39
        end
      end
      L18_2 = nil
      ::lbl_39::
      L17_2, L18_2, L19_2, L20_2, L21_2, L22_2, L23_2 = L17_2(L18_2)
      L16_2, L17_2, L18_2, L19_2 = L16_2(L17_2, L18_2, L19_2, L20_2, L21_2, L22_2, L23_2)
      for L20_2, L21_2 in L16_2, L17_2, L18_2, L19_2 do
        L22_2 = type
        L23_2 = L21_2
        L22_2 = L22_2(L23_2)
        if "table" == L22_2 then
          L22_2 = L21_2.closed
          if L22_2 then
            L22_2 = L21_2.id
            if L22_2 then
              L22_2 = L21_2.id
              L9_2[L22_2] = true
            end
          end
        end
      end
    end
    L10_2 = L8_2.id
    L2_2[L10_2] = L9_2
  end
  L3_2 = pcall
  function L4_2()
    local L0_3, L1_3
    L0_3 = MySQL
    L0_3 = L0_3.query
    L0_3 = L0_3.await
    L1_3 = "SELECT app, kind, status, COUNT(*) AS n, MAX(updated) AS last FROM apex_phone_capp_items GROUP BY app, kind, status"
    return L0_3(L1_3)
  end
  L3_2, L4_2 = L3_2(L4_2)
  if L3_2 then
    L5_2 = type
    L6_2 = L4_2
    L5_2 = L5_2(L6_2)
    if "table" == L5_2 then
      goto lbl_77
    end
  end
  do return L0_2 end
  ::lbl_77::
  L5_2 = ipairs
  L6_2 = L4_2
  L5_2, L6_2, L7_2, L8_2 = L5_2(L6_2)
  for L9_2, L10_2 in L5_2, L6_2, L7_2, L8_2 do
    L11_2 = L10_2.app
    L11_2 = L0_2[L11_2]
    if not L11_2 then
      L11_2 = {}
      L11_2.open = 0
      L11_2.total = 0
      L11_2.last = 0
    end
    L12_2 = tonumber
    L13_2 = L10_2.n
    L12_2 = L12_2(L13_2)
    if not L12_2 then
      L12_2 = 0
    end
    L13_2 = L11_2.total
    L13_2 = L13_2 + L12_2
    L11_2.total = L13_2
    L13_2 = L10_2.kind
    if "record" ~= L13_2 and "post" ~= L13_2 and "shift" ~= L13_2 and "bill" ~= L13_2 then
      L14_2 = L10_2.app
      L14_2 = L2_2[L14_2]
      if not L14_2 then
        L14_2 = L65_1
      end
      L15_2 = L10_2.status
      L15_2 = L14_2[L15_2]
      if not L15_2 then
        L15_2 = L11_2.open
        L15_2 = L15_2 + L12_2
        L11_2.open = L15_2
      end
    end
    L14_2 = math
    L14_2 = L14_2.max
    L15_2 = L11_2.last
    L16_2 = tonumber
    L17_2 = L10_2.last
    L16_2 = L16_2(L17_2)
    if not L16_2 then
      L16_2 = 0
    end
    L14_2 = L14_2(L15_2, L16_2)
    L11_2.last = L14_2
    L14_2 = L10_2.app
    L0_2[L14_2] = L11_2
  end
  return L0_2
end
function L67_1(A0_2)
  local L1_2, L2_2, L3_2, L4_2
  L1_2 = pcall
  function L2_2()
    local L0_3, L1_3, L2_3, L3_3
    L0_3 = MySQL
    L0_3 = L0_3.query
    L0_3 = L0_3.await
    L1_3 = "SELECT id, at, admin, action, detail FROM apex_phone_admin_log ORDER BY id DESC LIMIT ?"
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
    if "table" == L3_2 and L2_2 then
      goto lbl_15
      L3_2 = L2_2 or L3_2
    end
  end
  L3_2 = {}
  ::lbl_15::
  return L3_2
end
function L68_1()
  local L0_2, L1_2, L2_2, L3_2, L4_2, L5_2, L6_2
  L0_2 = {}
  L1_2 = GetPlayers
  L1_2 = L1_2()
  L1_2 = #L1_2
  L0_2.online = L1_2
  L0_2.accounts = nil
  L0_2.shop = nil
  L1_2 = {}
  L0_2.capps = L1_2
  L1_2 = {}
  L0_2.log = L1_2
  L1_2 = pcall
  function L2_2()
    local L0_3, L1_3
    L0_3 = MySQL
    L0_3 = L0_3.scalar
    L0_3 = L0_3.await
    L1_3 = "SELECT COUNT(*) FROM apex_phone_accounts"
    return L0_3(L1_3)
  end
  L1_2, L2_2 = L1_2(L2_2)
  if L1_2 then
    L3_2 = tonumber
    L4_2 = L2_2
    L3_2 = L3_2(L4_2)
    L0_2.accounts = L3_2
  end
  L3_2 = ShopStats
  if L3_2 then
    L3_2 = pcall
    L4_2 = ShopStats
    L3_2, L4_2 = L3_2(L4_2)
    if L3_2 then
      L5_2 = type
      L6_2 = L4_2
      L5_2 = L5_2(L6_2)
      if "table" == L5_2 then
        L5_2 = L3_1
        L6_2 = L4_2
        L5_2 = L5_2(L6_2)
        L0_2.shop = L5_2
      end
    end
  end
  L3_2 = L66_1
  L3_2 = L3_2()
  L0_2.capps = L3_2
  L3_2 = L67_1
  L4_2 = 8
  L3_2 = L3_2(L4_2)
  L0_2.log = L3_2
  return L0_2
end
L69_1 = {}
L70_1 = "enabled"
L71_1 = "currency"
L72_1 = "payment"
L73_1 = "blip"
L74_1 = "interaction"
L75_1 = "closeDistance"
L76_1 = "serverDistance"
L77_1 = "camera"
L78_1 = "hidePlayer"
L79_1 = "ped"
L80_1 = "shops"
L81_1 = "categories"
L82_1 = "products"
L69_1[1] = L70_1
L69_1[2] = L71_1
L69_1[3] = L72_1
L69_1[4] = L73_1
L69_1[5] = L74_1
L69_1[6] = L75_1
L69_1[7] = L76_1
L69_1[8] = L77_1
L69_1[9] = L78_1
L69_1[10] = L79_1
L69_1[11] = L80_1
L69_1[12] = L81_1
L69_1[13] = L82_1
function L70_1()
  local L0_2, L1_2, L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2
  L0_2 = {}
  L1_2 = ipairs
  L2_2 = L69_1
  L1_2, L2_2, L3_2, L4_2 = L1_2(L2_2)
  for L5_2, L6_2 in L1_2, L2_2, L3_2, L4_2 do
    L7_2 = L3_1
    L8_2 = L2_1
    L9_2 = type
    L10_2 = Config
    L10_2 = L10_2.Shop
    L9_2 = L9_2(L10_2)
    if "table" == L9_2 then
      L9_2 = Config
      L9_2 = L9_2.Shop
      L9_2 = L9_2[L6_2]
      if L9_2 then
        goto lbl_21
      end
    end
    L9_2 = nil
    ::lbl_21::
    L8_2, L9_2, L10_2 = L8_2(L9_2)
    L7_2 = L7_2(L8_2, L9_2, L10_2)
    L0_2[L6_2] = L7_2
  end
  return L0_2
end
function L71_1()
  local L0_2, L1_2, L2_2, L3_2
  L0_2 = ShopEffective
  if L0_2 then
    L0_2 = pcall
    L1_2 = ShopEffective
    L0_2, L1_2 = L0_2(L1_2)
    if L0_2 then
      L2_2 = type
      L3_2 = L1_2
      L2_2 = L2_2(L3_2)
      if "table" == L2_2 then
        L2_2 = L3_1
        L3_2 = L1_2
        return L2_2(L3_2)
      end
    end
  end
  L0_2 = L70_1
  return L0_2()
end
function L72_1()
  local L0_2, L1_2, L2_2, L3_2
  L0_2 = ShopDefaults
  if L0_2 then
    L0_2 = pcall
    L1_2 = ShopDefaults
    L0_2, L1_2 = L0_2(L1_2)
    if L0_2 then
      L2_2 = type
      L3_2 = L1_2
      L2_2 = L2_2(L3_2)
      if "table" == L2_2 then
        L2_2 = L3_1
        L3_2 = L1_2
        return L2_2(L3_2)
      end
    end
  end
  L0_2 = L70_1
  return L0_2()
end
L73_1 = {}
function L74_1()
  local L0_2, L1_2, L2_2, L3_2
  L0_2 = AdminStore
  L0_2 = L0_2.Get
  L1_2 = "webhooks"
  L0_2 = L0_2(L1_2)
  L1_2 = type
  L2_2 = L0_2
  L1_2 = L1_2(L2_2)
  if "table" ~= L1_2 or not L0_2 then
    L1_2 = {}
    L0_2 = L1_2
  end
  L1_2 = {}
  L2_2 = type
  L3_2 = L0_2.admin
  L2_2 = L2_2(L3_2)
  if "string" == L2_2 then
    L2_2 = L0_2.admin
    if L2_2 then
      goto lbl_26
    end
  end
  L2_2 = ""
  ::lbl_26::
  L1_2.admin = L2_2
  L2_2 = type
  L3_2 = L0_2.shop
  L2_2 = L2_2(L3_2)
  if "string" == L2_2 then
    L2_2 = L0_2.shop
    if L2_2 then
      goto lbl_36
    end
  end
  L2_2 = ""
  ::lbl_36::
  L1_2.shop = L2_2
  return L1_2
end
L75_1 = OVRPC
function L76_1(A0_2)
  local L1_2, L2_2, L3_2, L4_2, L5_2
  L1_2 = L73_1
  L1_2[A0_2] = true
  L1_2 = L28_1
  L1_2, L2_2 = L1_2()
  L3_2 = {}
  L3_2.ok = true
  L4_2 = AdminName
  L5_2 = A0_2
  L4_2 = L4_2(L5_2)
  L3_2.me = L4_2
  L4_2 = AdminSchema
  L3_2.schema = L4_2
  L3_2.settings = L1_2
  L3_2.disabledApps = L2_2
  L4_2 = L71_1
  L4_2 = L4_2()
  L3_2.shop = L4_2
  L4_2 = L72_1
  L4_2 = L4_2()
  L3_2.shopDefaults = L4_2
  L4_2 = ShopSanitize
  L4_2 = nil ~= L4_2
  L3_2.shopReady = L4_2
  L4_2 = L60_1
  L4_2 = L4_2()
  L3_2.capps = L4_2
  L4_2 = L32_1
  L3_2.categories = L4_2
  L4_2 = {}
  L5_2 = L30_1
  L4_2.maxApps = L5_2
  L5_2 = L31_1
  L4_2.maxModules = L5_2
  L5_2 = L43_1
  L4_2.billMax = L5_2
  L5_2 = L61_1
  L4_2.histKeep = L5_2
  L3_2.limits = L4_2
  L4_2 = L74_1
  L4_2 = L4_2()
  L3_2.webhooks = L4_2
  L4_2 = L25_1
  L4_2 = L4_2()
  L3_2.theme = L4_2
  L4_2 = L68_1
  L4_2 = L4_2()
  L3_2.stats = L4_2
  return L3_2
end
L75_1["admin.bootstrap"] = L76_1
L75_1 = OVRPC
function L76_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2, L19_2, L20_2, L21_2, L22_2, L23_2
  L2_2 = {}
  L3_2 = false
  L4_2 = ipairs
  L5_2 = L21_1
  L4_2, L5_2, L6_2, L7_2 = L4_2(L5_2)
  for L8_2, L9_2 in L4_2, L5_2, L6_2, L7_2 do
    L10_2 = type
    L11_2 = A1_2[L9_2]
    L10_2 = L10_2(L11_2)
    if "table" == L10_2 then
      L10_2 = A1_2[L9_2]
      if L10_2 then
        goto lbl_18
      end
    end
    L10_2 = {}
    ::lbl_18::
    L11_2 = {}
    L12_2 = ipairs
    L13_2 = {}
    L14_2 = "acc"
    L15_2 = "bg"
    L13_2[1] = L14_2
    L13_2[2] = L15_2
    L12_2, L13_2, L14_2, L15_2 = L12_2(L13_2)
    for L16_2, L17_2 in L12_2, L13_2, L14_2, L15_2 do
      L18_2 = L10_2[L17_2]
      if nil ~= L18_2 and "" ~= L18_2 then
        L19_2 = L22_1
        L20_2 = L18_2
        L19_2 = L19_2(L20_2)
        if L19_2 then
          L20_2 = L24_1
          L20_2 = L20_2[L17_2]
          L21_2 = L19_2
          L20_2 = L20_2(L21_2)
          if L20_2 then
            goto lbl_54
          end
        end
        L20_2 = {}
        L20_2.ok = false
        L20_2.error = "invalid"
        L21_2 = L9_2
        L22_2 = "."
        L23_2 = L17_2
        L21_2 = L21_2 .. L22_2 .. L23_2
        L20_2.field = L21_2
        do return L20_2 end
        ::lbl_54::
        L11_2[L17_2] = L19_2
        L3_2 = true
      end
    end
    L12_2 = next
    L13_2 = L11_2
    L12_2 = L12_2(L13_2)
    if L12_2 then
      L2_2[L9_2] = L11_2
    end
  end
  L4_2 = AdminStore
  L4_2 = L4_2.Set
  L5_2 = "theme"
  L6_2 = L2_2 or L6_2
  if not L3_2 or not L2_2 then
    L6_2 = nil
  end
  L7_2 = A0_2
  L4_2 = L4_2(L5_2, L6_2, L7_2)
  if not L4_2 then
    L4_2 = {}
    L4_2.ok = false
    L4_2.error = "db"
    return L4_2
  end
  L4_2 = L25_1
  L4_2 = L4_2()
  function L5_2(A0_3)
    local L1_3, L2_3, L3_3
    L1_3 = A0_3.acc
    if "" ~= L1_3 then
      L1_3 = A0_3.acc
      if L1_3 then
        goto lbl_8
      end
    end
    L1_3 = "origem"
    ::lbl_8::
    L2_3 = " / "
    L3_3 = A0_3.bg
    if "" ~= L3_3 then
      L3_3 = A0_3.bg
      if L3_3 then
        goto lbl_16
      end
    end
    L3_3 = "origem"
    ::lbl_16::
    L1_3 = L1_3 .. L2_3 .. L3_3
    return L1_3
  end
  L6_2 = AdminStore
  L6_2 = L6_2.Log
  L7_2 = A0_2
  L8_2 = "theme.save"
  L9_2 = "Loja: %s \194\183 Painel: %s"
  L10_2 = L9_2
  L9_2 = L9_2.format
  L11_2 = L5_2
  L12_2 = L4_2.shop
  L11_2 = L11_2(L12_2)
  L12_2 = L5_2
  L13_2 = L4_2.admin
  L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2, L19_2, L20_2, L21_2, L22_2, L23_2 = L12_2(L13_2)
  L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2, L19_2, L20_2, L21_2, L22_2, L23_2 = L9_2(L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2, L19_2, L20_2, L21_2, L22_2, L23_2)
  L6_2(L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2, L19_2, L20_2, L21_2, L22_2, L23_2)
  L6_2 = {}
  L6_2.ok = true
  L6_2.theme = L4_2
  return L6_2
end
L75_1["admin.theme.save"] = L76_1
L75_1 = OVRPC
function L76_1()
  local L0_2, L1_2
  L0_2 = {}
  L0_2.ok = true
  L1_2 = L68_1
  L1_2 = L1_2()
  L0_2.stats = L1_2
  return L0_2
end
L75_1["admin.stats"] = L76_1
L75_1 = OVRPC
function L76_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2
  L2_2 = {}
  L3_2 = 0
  L4_2 = pairs
  L5_2 = type
  L6_2 = A1_2.config
  L5_2 = L5_2(L6_2)
  if "table" == L5_2 then
    L5_2 = A1_2.config
    if L5_2 then
      goto lbl_15
    end
  end
  L5_2 = {}
  ::lbl_15::
  L4_2, L5_2, L6_2, L7_2 = L4_2(L5_2)
  for L8_2, L9_2 in L4_2, L5_2, L6_2, L7_2 do
    L10_2 = AdminSchemaFind
    L11_2 = L8_2
    L10_2 = L10_2(L11_2)
    if not L10_2 then
      L11_2 = {}
      L11_2.ok = false
      L11_2.error = "unknown"
      L12_2 = tostring
      L13_2 = L8_2
      L12_2 = L12_2(L13_2)
      L11_2.field = L12_2
      return L11_2
    end
    L11_2 = L18_1
    L12_2 = L10_2
    L13_2 = L9_2
    L11_2 = L11_2(L12_2, L13_2)
    if nil == L11_2 then
      L12_2 = {}
      L12_2.ok = false
      L12_2.error = "invalid"
      L12_2.field = L8_2
      return L12_2
    end
    L12_2 = L17_1
    L13_2 = L11_2
    L14_2 = L16_1
    L14_2 = L14_2[L8_2]
    L12_2 = L12_2(L13_2, L14_2)
    if not L12_2 then
      L2_2[L8_2] = L11_2
      L3_2 = L3_2 + 1
    end
  end
  L4_2 = L19_1
  L5_2 = A1_2.disabledApps
  L4_2 = L4_2(L5_2)
  if not (L3_2 > 0) then
    L5_2 = #L4_2
    if not (L5_2 > 0) then
      goto lbl_70
    end
  end
  L5_2 = {}
  L5_2.config = L2_2
  L5_2.disabledApps = L4_2
  ::lbl_70::
  if not L5_2 then
    L5_2 = nil
  end
  L6_2 = AdminStore
  L6_2 = L6_2.Set
  L7_2 = "settings"
  L8_2 = L5_2
  L9_2 = A0_2
  L6_2 = L6_2(L7_2, L8_2, L9_2)
  if not L6_2 then
    L6_2 = {}
    L6_2.ok = false
    L6_2.error = "db"
    return L6_2
  end
  L6_2 = AdminStore
  L6_2 = L6_2.Log
  L7_2 = A0_2
  L8_2 = "settings.save"
  L9_2 = "%d defini\195\167\195\181es alteradas, %d apps desligadas"
  L10_2 = L9_2
  L9_2 = L9_2.format
  L11_2 = L3_2
  L12_2 = #L4_2
  L9_2, L10_2, L11_2, L12_2, L13_2, L14_2 = L9_2(L10_2, L11_2, L12_2)
  L6_2(L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2)
  L6_2 = L28_1
  L6_2, L7_2 = L6_2()
  L8_2 = {}
  L8_2.ok = true
  L8_2.settings = L6_2
  L8_2.disabledApps = L7_2
  return L8_2
end
L75_1["admin.settings.save"] = L76_1
L75_1 = OVRPC
function L76_1(A0_2)
  local L1_2, L2_2, L3_2, L4_2
  L1_2 = AdminStore
  L1_2 = L1_2.Set
  L2_2 = "settings"
  L3_2 = nil
  L4_2 = A0_2
  L1_2 = L1_2(L2_2, L3_2, L4_2)
  if not L1_2 then
    L1_2 = {}
    L1_2.ok = false
    L1_2.error = "db"
    return L1_2
  end
  L1_2 = AdminStore
  L1_2 = L1_2.Log
  L2_2 = A0_2
  L3_2 = "settings.reset"
  L4_2 = "Defini\195\167\195\181es repostas no config.lua"
  L1_2(L2_2, L3_2, L4_2)
  L1_2 = L28_1
  L1_2, L2_2 = L1_2()
  L3_2 = {}
  L3_2.ok = true
  L3_2.settings = L1_2
  L3_2.disabledApps = L2_2
  return L3_2
end
L75_1["admin.settings.reset"] = L76_1
L75_1 = OVRPC
function L76_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2
  L2_2 = ShopSanitize
  if not L2_2 then
    L2_2 = {}
    L2_2.ok = false
    L2_2.error = "unavailable"
    return L2_2
  end
  L2_2 = pcall
  L3_2 = ShopSanitize
  L4_2 = A1_2.shop
  L2_2, L3_2, L4_2 = L2_2(L3_2, L4_2)
  if not L2_2 then
    L5_2 = {}
    L5_2.ok = false
    L5_2.error = "invalid"
    L6_2 = tostring
    L7_2 = L3_2
    L6_2 = L6_2(L7_2)
    L5_2.message = L6_2
    return L5_2
  end
  L5_2 = type
  L6_2 = L3_2
  L5_2 = L5_2(L6_2)
  if "table" ~= L5_2 then
    L5_2 = {}
    L5_2.ok = false
    L5_2.error = "invalid"
    if L4_2 then
      L6_2 = tostring
      L7_2 = L4_2
      L6_2 = L6_2(L7_2)
      if L6_2 then
        goto lbl_41
      end
    end
    L6_2 = nil
    ::lbl_41::
    L5_2.message = L6_2
    return L5_2
  end
  L5_2 = AdminStore
  L5_2 = L5_2.Set
  L6_2 = "shop"
  L7_2 = L3_2
  L8_2 = A0_2
  L5_2 = L5_2(L6_2, L7_2, L8_2)
  if not L5_2 then
    L5_2 = {}
    L5_2.ok = false
    L5_2.error = "db"
    return L5_2
  end
  L5_2 = 0
  L6_2 = 0
  L7_2 = ipairs
  L8_2 = L15_1
  L9_2 = L3_2.products
  L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2 = L8_2(L9_2)
  L7_2, L8_2, L9_2, L10_2 = L7_2(L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2)
  for L11_2 in L7_2, L8_2, L9_2, L10_2 do
    L5_2 = L5_2 + 1
  end
  L7_2 = ipairs
  L8_2 = L15_1
  L9_2 = L3_2.shops
  L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2 = L8_2(L9_2)
  L7_2, L8_2, L9_2, L10_2 = L7_2(L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2)
  for L11_2 in L7_2, L8_2, L9_2, L10_2 do
    L6_2 = L6_2 + 1
  end
  L7_2 = AdminStore
  L7_2 = L7_2.Log
  L8_2 = A0_2
  L9_2 = "shop.save"
  L10_2 = "Loja %s \194\183 %d produtos \194\183 %d lojas"
  L11_2 = L10_2
  L10_2 = L10_2.format
  L12_2 = L3_2.enabled
  if false == L12_2 then
    L12_2 = "desligada"
    if L12_2 then
      goto lbl_93
    end
  end
  L12_2 = "ligada"
  ::lbl_93::
  L13_2 = L5_2
  L14_2 = L6_2
  L10_2, L11_2, L12_2, L13_2, L14_2 = L10_2(L11_2, L12_2, L13_2, L14_2)
  L7_2(L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2)
  L7_2 = {}
  L7_2.ok = true
  L8_2 = L71_1
  L8_2 = L8_2()
  L7_2.shop = L8_2
  return L7_2
end
L75_1["admin.shop.save"] = L76_1
L75_1 = OVRPC
function L76_1(A0_2)
  local L1_2, L2_2, L3_2, L4_2
  L1_2 = AdminStore
  L1_2 = L1_2.Set
  L2_2 = "shop"
  L3_2 = nil
  L4_2 = A0_2
  L1_2 = L1_2(L2_2, L3_2, L4_2)
  if not L1_2 then
    L1_2 = {}
    L1_2.ok = false
    L1_2.error = "db"
    return L1_2
  end
  L1_2 = AdminStore
  L1_2 = L1_2.Log
  L2_2 = A0_2
  L3_2 = "shop.reset"
  L4_2 = "Loja reposta no config.lua"
  L1_2(L2_2, L3_2, L4_2)
  L1_2 = {}
  L1_2.ok = true
  L2_2 = L71_1
  L2_2 = L2_2()
  L1_2.shop = L2_2
  return L1_2
end
L75_1["admin.shop.reset"] = L76_1
L75_1 = OVRPC
function L76_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2
  L2_2 = AdminSanitizeCApp
  L3_2 = A1_2.app
  L2_2, L3_2, L4_2 = L2_2(L3_2)
  if not L2_2 then
    L5_2 = {}
    L5_2.ok = false
    L6_2 = L3_2 or L6_2
    if not L3_2 then
      L6_2 = "invalid"
    end
    L5_2.error = L6_2
    L5_2.field = L4_2
    return L5_2
  end
  L5_2 = L2_1
  L6_2 = L60_1
  L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2 = L6_2()
  L5_2 = L5_2(L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2)
  L6_2 = nil
  L7_2 = nil
  L8_2 = ipairs
  L9_2 = L5_2
  L8_2, L9_2, L10_2, L11_2 = L8_2(L9_2)
  for L12_2, L13_2 in L8_2, L9_2, L10_2, L11_2 do
    L14_2 = L13_2.id
    L15_2 = L2_2.id
    if L14_2 == L15_2 then
      L6_2 = L12_2
    end
  end
  L8_2 = A1_2.isNew
  if true == L8_2 and L6_2 then
    L8_2 = {}
    L8_2.ok = false
    L8_2.error = "exists"
    L9_2 = L2_2.id
    L8_2.field = L9_2
    return L8_2
  end
  if L6_2 then
    L7_2 = L5_2[L6_2]
    L8_2 = L8_1
    L9_2 = L5_2[L6_2]
    L9_2 = L9_2.created
    L10_2 = 0
    L11_2 = 9.0E15
    L12_2 = L2_2.created
    L8_2 = L8_2(L9_2, L10_2, L11_2, L12_2)
    L2_2.created = L8_2
    L5_2[L6_2] = L2_2
  else
    L8_2 = #L5_2
    L9_2 = L30_1
    if L8_2 >= L9_2 then
      L8_2 = {}
      L8_2.ok = false
      L8_2.error = "limit"
      return L8_2
    end
    L8_2 = L1_1
    L8_2 = L8_2()
    L2_2.created = L8_2
    L8_2 = #L5_2
    L8_2 = L8_2 + 1
    L5_2[L8_2] = L2_2
  end
  L8_2 = AdminStore
  L8_2 = L8_2.Set
  L9_2 = "capps"
  L10_2 = {}
  L10_2.apps = L5_2
  L11_2 = A0_2
  L8_2 = L8_2(L9_2, L10_2, L11_2)
  if not L8_2 then
    L8_2 = {}
    L8_2.ok = false
    L8_2.error = "db"
    return L8_2
  end
  L8_2 = L63_1
  L9_2 = A0_2
  L10_2 = L2_2
  L11_2 = L7_2
  L8_2(L9_2, L10_2, L11_2)
  L8_2 = AdminStore
  L8_2 = L8_2.Log
  L9_2 = A0_2
  L10_2 = "capps.save"
  L11_2 = "%s (%s) \194\183 %d m\195\179dulos"
  L12_2 = L11_2
  L11_2 = L11_2.format
  L13_2 = L2_2.name
  L14_2 = L2_2.id
  L15_2 = L2_2.modules
  L15_2 = #L15_2
  L11_2, L12_2, L13_2, L14_2, L15_2 = L11_2(L12_2, L13_2, L14_2, L15_2)
  L8_2(L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2)
  L8_2 = {}
  L8_2.ok = true
  L8_2.app = L2_2
  return L8_2
end
L75_1["admin.capps.save"] = L76_1
L75_1 = OVRPC
function L76_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2
  L2_2 = L11_1
  L3_2 = A1_2.id
  L4_2 = 2
  L5_2 = 32
  L2_2 = L2_2(L3_2, L4_2, L5_2)
  if not L2_2 then
    L3_2 = {}
    L3_2.ok = false
    L3_2.error = "id"
    return L3_2
  end
  L3_2 = {}
  L4_2 = ipairs
  L5_2 = L15_1
  L6_2 = L62_1
  L6_2 = L6_2()
  L6_2 = L6_2[L2_2]
  L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2 = L5_2(L6_2)
  L4_2, L5_2, L6_2, L7_2 = L4_2(L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2)
  for L8_2, L9_2 in L4_2, L5_2, L6_2, L7_2 do
    L10_2 = type
    L11_2 = L9_2
    L10_2 = L10_2(L11_2)
    if "table" == L10_2 then
      L10_2 = type
      L11_2 = L9_2.def
      L10_2 = L10_2(L11_2)
      if "table" == L10_2 then
        L10_2 = #L3_2
        L10_2 = L10_2 + 1
        L11_2 = {}
        L12_2 = tonumber
        L13_2 = L9_2.at
        L12_2 = L12_2(L13_2)
        if not L12_2 then
          L12_2 = 0
        end
        L11_2.at = L12_2
        L12_2 = type
        L13_2 = L9_2.by
        L12_2 = L12_2(L13_2)
        if "string" == L12_2 then
          L12_2 = L9_2.by
          if L12_2 then
            goto lbl_54
          end
        end
        L12_2 = ""
        ::lbl_54::
        L11_2.by = L12_2
        L12_2 = L15_1
        L13_2 = L9_2.def
        L13_2 = L13_2.modules
        L12_2 = L12_2(L13_2)
        L12_2 = #L12_2
        L11_2.modules = L12_2
        L12_2 = L5_1
        L13_2 = L9_2.def
        L13_2 = L13_2.name
        L14_2 = 24
        L15_2 = ""
        L12_2 = L12_2(L13_2, L14_2, L15_2)
        L11_2.name = L12_2
        L3_2[L10_2] = L11_2
      end
    end
  end
  L4_2 = {}
  L4_2.ok = true
  L4_2.items = L3_2
  return L4_2
end
L75_1["admin.capps.history"] = L76_1
L75_1 = OVRPC
function L76_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2
  L2_2 = L11_1
  L3_2 = A1_2.id
  L4_2 = 2
  L5_2 = 32
  L2_2 = L2_2(L3_2, L4_2, L5_2)
  L3_2 = tonumber
  L4_2 = A1_2.at
  L3_2 = L3_2(L4_2)
  if not L2_2 or not L3_2 then
    L4_2 = {}
    L4_2.ok = false
    L4_2.error = "invalid"
    return L4_2
  end
  L4_2 = ipairs
  L5_2 = L15_1
  L6_2 = L62_1
  L6_2 = L6_2()
  L6_2 = L6_2[L2_2]
  L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2 = L5_2(L6_2)
  L4_2, L5_2, L6_2, L7_2 = L4_2(L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2)
  for L8_2, L9_2 in L4_2, L5_2, L6_2, L7_2 do
    L10_2 = type
    L11_2 = L9_2
    L10_2 = L10_2(L11_2)
    if "table" == L10_2 then
      L10_2 = tonumber
      L11_2 = L9_2.at
      L10_2 = L10_2(L11_2)
      if L10_2 == L3_2 then
        L10_2 = type
        L11_2 = L9_2.def
        L10_2 = L10_2(L11_2)
        if "table" == L10_2 then
          L10_2 = L2_1
          L11_2 = L9_2.def
          L10_2 = L10_2(L11_2)
          L10_2.id = L2_2
          L11_2 = AdminSanitizeCApp
          L12_2 = L10_2
          L11_2 = L11_2(L12_2)
          L12_2 = {}
          L12_2.ok = true
          L13_2 = L11_2 or L13_2
          if not L11_2 then
            L13_2 = L10_2
          end
          L12_2.app = L13_2
          L12_2.at = L3_2
          return L12_2
        end
      end
    end
  end
  L4_2 = {}
  L4_2.ok = false
  L4_2.error = "missing"
  return L4_2
end
L75_1["admin.capps.restore"] = L76_1
L75_1 = OVRPC
function L76_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2
  L2_2 = L11_1
  L3_2 = A1_2.id
  L4_2 = 2
  L5_2 = 32
  L2_2 = L2_2(L3_2, L4_2, L5_2)
  if not L2_2 then
    L3_2 = {}
    L3_2.ok = false
    L3_2.error = "id"
    return L3_2
  end
  L3_2 = L60_1
  L3_2 = L3_2()
  L4_2 = {}
  L5_2 = nil
  L6_2 = ipairs
  L7_2 = L3_2
  L6_2, L7_2, L8_2, L9_2 = L6_2(L7_2)
  for L10_2, L11_2 in L6_2, L7_2, L8_2, L9_2 do
    L12_2 = L11_2.id
    if L12_2 == L2_2 then
      L5_2 = L11_2.name
    else
      L12_2 = #L4_2
      L12_2 = L12_2 + 1
      L13_2 = L2_1
      L14_2 = L11_2
      L13_2 = L13_2(L14_2)
      L4_2[L12_2] = L13_2
    end
  end
  if not L5_2 then
    L6_2 = {}
    L6_2.ok = false
    L6_2.error = "missing"
    return L6_2
  end
  L6_2 = AdminStore
  L6_2 = L6_2.Set
  L7_2 = "capps"
  L8_2 = {}
  L8_2.apps = L4_2
  L9_2 = A0_2
  L6_2 = L6_2(L7_2, L8_2, L9_2)
  if not L6_2 then
    L6_2 = {}
    L6_2.ok = false
    L6_2.error = "db"
    return L6_2
  end
  L6_2 = L64_1
  L7_2 = A0_2
  L8_2 = L2_2
  L6_2(L7_2, L8_2)
  L6_2 = AdminStore
  L6_2 = L6_2.Log
  L7_2 = A0_2
  L8_2 = "capps.remove"
  L9_2 = "%s (%s)"
  L10_2 = L9_2
  L9_2 = L9_2.format
  L11_2 = L5_2
  L12_2 = L2_2
  L9_2, L10_2, L11_2, L12_2, L13_2, L14_2 = L9_2(L10_2, L11_2, L12_2)
  L6_2(L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2)
  L6_2 = {}
  L6_2.ok = true
  return L6_2
end
L75_1["admin.capps.remove"] = L76_1
L75_1 = OVRPC
function L76_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2
  L2_2 = L60_1
  L2_2 = L2_2()
  L3_2 = {}
  L4_2 = {}
  L5_2 = {}
  L6_2 = ipairs
  L7_2 = L2_2
  L6_2, L7_2, L8_2, L9_2 = L6_2(L7_2)
  for L10_2, L11_2 in L6_2, L7_2, L8_2, L9_2 do
    L12_2 = L11_2.id
    L3_2[L12_2] = L11_2
  end
  L6_2 = ipairs
  L7_2 = L15_1
  L8_2 = A1_2.ids
  L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2 = L7_2(L8_2)
  L6_2, L7_2, L8_2, L9_2 = L6_2(L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2)
  for L10_2, L11_2 in L6_2, L7_2, L8_2, L9_2 do
    L12_2 = type
    L13_2 = L11_2
    L12_2 = L12_2(L13_2)
    if "string" == L12_2 then
      L12_2 = L3_2[L11_2]
      if L12_2 then
        L12_2 = L5_2[L11_2]
        if not L12_2 then
          L5_2[L11_2] = true
          L12_2 = #L4_2
          L12_2 = L12_2 + 1
          L13_2 = L2_1
          L14_2 = L3_2[L11_2]
          L13_2 = L13_2(L14_2)
          L4_2[L12_2] = L13_2
        end
      end
    end
  end
  L6_2 = ipairs
  L7_2 = L2_2
  L6_2, L7_2, L8_2, L9_2 = L6_2(L7_2)
  for L10_2, L11_2 in L6_2, L7_2, L8_2, L9_2 do
    L12_2 = L11_2.id
    L12_2 = L5_2[L12_2]
    if not L12_2 then
      L12_2 = #L4_2
      L12_2 = L12_2 + 1
      L13_2 = L2_1
      L14_2 = L11_2
      L13_2 = L13_2(L14_2)
      L4_2[L12_2] = L13_2
    end
  end
  L6_2 = AdminStore
  L6_2 = L6_2.Set
  L7_2 = "capps"
  L8_2 = {}
  L8_2.apps = L4_2
  L9_2 = A0_2
  L6_2 = L6_2(L7_2, L8_2, L9_2)
  if not L6_2 then
    L6_2 = {}
    L6_2.ok = false
    L6_2.error = "db"
    return L6_2
  end
  L6_2 = AdminStore
  L6_2 = L6_2.Log
  L7_2 = A0_2
  L8_2 = "capps.order"
  L9_2 = "%d apps reordenadas"
  L10_2 = L9_2
  L9_2 = L9_2.format
  L11_2 = #L4_2
  L9_2, L10_2, L11_2, L12_2, L13_2, L14_2 = L9_2(L10_2, L11_2)
  L6_2(L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2)
  L6_2 = {}
  L6_2.ok = true
  return L6_2
end
L75_1["admin.capps.order"] = L76_1
L75_1 = OVRPC
function L76_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2
  L2_2 = {}
  L3_2 = ipairs
  L4_2 = {}
  L5_2 = "admin"
  L6_2 = "shop"
  L4_2[1] = L5_2
  L4_2[2] = L6_2
  L3_2, L4_2, L5_2, L6_2 = L3_2(L4_2)
  for L7_2, L8_2 in L3_2, L4_2, L5_2, L6_2 do
    L9_2 = A1_2[L8_2]
    L10_2 = type
    L11_2 = L9_2
    L10_2 = L10_2(L11_2)
    if "string" == L10_2 and "" ~= L9_2 then
      L10_2 = ValidWebhookUrl
      L11_2 = L9_2
      L10_2 = L10_2(L11_2)
      if not L10_2 then
        L10_2 = {}
        L10_2.ok = false
        L10_2.error = "webhook"
        L10_2.field = L8_2
        return L10_2
      end
      L2_2[L8_2] = L9_2
    end
  end
  L3_2 = AdminStore
  L3_2 = L3_2.Set
  L4_2 = "webhooks"
  L5_2 = next
  L6_2 = L2_2
  L5_2 = L5_2(L6_2)
  L5_2 = L2_2 or L5_2
  if not L5_2 or not L2_2 then
    L5_2 = nil
  end
  L6_2 = A0_2
  L3_2 = L3_2(L4_2, L5_2, L6_2)
  if not L3_2 then
    L3_2 = {}
    L3_2.ok = false
    L3_2.error = "db"
    return L3_2
  end
  L3_2 = AdminStore
  L3_2 = L3_2.Log
  L4_2 = A0_2
  L5_2 = "webhooks.save"
  L6_2 = "Registo: %s \194\183 Loja: %s"
  L7_2 = L6_2
  L6_2 = L6_2.format
  L8_2 = L2_2.admin
  if L8_2 then
    L8_2 = "ligado"
    if L8_2 then
      goto lbl_67
    end
  end
  L8_2 = "desligado"
  ::lbl_67::
  L9_2 = L2_2.shop
  if L9_2 then
    L9_2 = "ligado"
    if L9_2 then
      goto lbl_74
    end
  end
  L9_2 = "desligado"
  ::lbl_74::
  L6_2, L7_2, L8_2, L9_2, L10_2, L11_2 = L6_2(L7_2, L8_2, L9_2)
  L3_2(L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2)
  L3_2 = {}
  L3_2.ok = true
  L4_2 = L74_1
  L4_2 = L4_2()
  L3_2.webhooks = L4_2
  return L3_2
end
L75_1["admin.webhooks.save"] = L76_1
L75_1 = {}
L76_1 = OVRPC
function L77_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2
  L2_2 = ValidWebhookUrl
  L3_2 = A1_2.url
  L2_2 = L2_2(L3_2)
  if not L2_2 then
    L2_2 = {}
    L2_2.ok = false
    L2_2.error = "webhook"
    return L2_2
  end
  L2_2 = GetGameTimer
  L2_2 = L2_2()
  L3_2 = L75_1
  L3_2 = L3_2[A0_2]
  if L3_2 then
    L3_2 = L75_1
    L3_2 = L3_2[A0_2]
    L3_2 = L2_2 - L3_2
    L4_2 = 3000
    if L3_2 < L4_2 then
      L3_2 = {}
      L3_2.ok = false
      L3_2.error = "ratelimit"
      return L3_2
    end
  end
  L3_2 = L75_1
  L3_2[A0_2] = L2_2
  L3_2 = PostWebhook
  L4_2 = A1_2.url
  L5_2 = {}
  L6_2 = {}
  L7_2 = WebhookEmbed
  L8_2 = {}
  L8_2.title = "Apex Phone \194\183 teste"
  L8_2.description = "Este webhook est\195\161 ligado ao painel do telem\195\179vel."
  L8_2.color = "#1F5EFF"
  L9_2 = {}
  L10_2 = {}
  L10_2.name = "Enviado por"
  L11_2 = AdminName
  L12_2 = A0_2
  L11_2 = L11_2(L12_2)
  L10_2.value = L11_2
  L10_2.inline = true
  L11_2 = {}
  L11_2.name = "Servidor"
  L12_2 = GetConvar
  L13_2 = "sv_hostname"
  L14_2 = "FiveM"
  L12_2 = L12_2(L13_2, L14_2)
  L13_2 = L12_2
  L12_2 = L12_2.sub
  L14_2 = 1
  L15_2 = 100
  L12_2 = L12_2(L13_2, L14_2, L15_2)
  L11_2.value = L12_2
  L11_2.inline = true
  L9_2[1] = L10_2
  L9_2[2] = L11_2
  L8_2.fields = L9_2
  L8_2.footer = "Unique_Phone"
  L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2 = L7_2(L8_2)
  L6_2[1] = L7_2
  L6_2[2] = L8_2
  L6_2[3] = L9_2
  L6_2[4] = L10_2
  L6_2[5] = L11_2
  L6_2[6] = L12_2
  L6_2[7] = L13_2
  L6_2[8] = L14_2
  L6_2[9] = L15_2
  L5_2.embeds = L6_2
  L3_2 = L3_2(L4_2, L5_2)
  L4_2 = {}
  L5_2 = true == L3_2
  L4_2.ok = L5_2
  if L3_2 then
  end
  L4_2.error = "queue"
  return L4_2
end
L76_1["admin.webhooks.test"] = L77_1
L76_1 = OVRPC
function L77_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2
  L2_2 = 40
  L3_2 = L8_1
  L4_2 = A1_2.page
  L5_2 = 0
  L6_2 = 1000
  L7_2 = 0
  L3_2 = L3_2(L4_2, L5_2, L6_2, L7_2)
  L4_2 = L5_1
  L5_2 = A1_2.q
  L6_2 = 60
  L7_2 = ""
  L4_2 = L4_2(L5_2, L6_2, L7_2)
  L5_2 = "SELECT id, at, admin, action, detail FROM apex_phone_admin_log"
  L6_2 = {}
  if "" ~= L4_2 then
    L7_2 = "%"
    L9_2 = L4_2
    L8_2 = L4_2.gsub
    L10_2 = "[%%_\\]"
    L11_2 = "\\%0"
    L8_2 = L8_2(L9_2, L10_2, L11_2)
    L9_2 = "%"
    L7_2 = L7_2 .. L8_2 .. L9_2
    L8_2 = L5_2
    L9_2 = " WHERE admin LIKE ? OR action LIKE ? OR detail LIKE ?"
    L8_2 = L8_2 .. L9_2
    L5_2 = L8_2
    L8_2 = {}
    L9_2 = L7_2
    L10_2 = L7_2
    L11_2 = L7_2
    L8_2[1] = L9_2
    L8_2[2] = L10_2
    L8_2[3] = L11_2
    L6_2 = L8_2
  end
  L7_2 = L5_2
  L8_2 = " ORDER BY id DESC LIMIT ? OFFSET ?"
  L7_2 = L7_2 .. L8_2
  L5_2 = L7_2
  L7_2 = #L6_2
  L7_2 = L7_2 + 1
  L8_2 = L2_2 + 1
  L6_2[L7_2] = L8_2
  L7_2 = #L6_2
  L7_2 = L7_2 + 1
  L8_2 = L3_2 * L2_2
  L6_2[L7_2] = L8_2
  L7_2 = pcall
  function L8_2()
    local L0_3, L1_3, L2_3
    L0_3 = MySQL
    L0_3 = L0_3.query
    L0_3 = L0_3.await
    L1_3 = L5_2
    L2_3 = L6_2
    return L0_3(L1_3, L2_3)
  end
  L7_2, L8_2 = L7_2(L8_2)
  if L7_2 then
    L9_2 = type
    L10_2 = L8_2
    L9_2 = L9_2(L10_2)
    if "table" == L9_2 then
      goto lbl_67
    end
  end
  L9_2 = {}
  L9_2.ok = false
  L9_2.error = "db"
  do return L9_2 end
  ::lbl_67::
  L9_2 = #L8_2
  L9_2 = L2_2 < L9_2
  if L9_2 then
    L10_2 = #L8_2
    L8_2[L10_2] = nil
  end
  L10_2 = {}
  L10_2.ok = true
  L10_2.rows = L8_2
  L10_2.more = L9_2
  L10_2.page = L3_2
  return L10_2
end
L76_1["admin.log"] = L77_1
function L76_1(A0_2)
  local L1_2, L2_2, L3_2, L4_2
  L1_2 = IsPhoneAdmin
  L2_2 = A0_2
  L1_2 = L1_2(L2_2)
  if not L1_2 then
    L1_2 = FW
    L1_2 = L1_2.Notify
    L2_2 = A0_2
    L3_2 = "N\195\163o tens permiss\195\163o para abrir o painel do telem\195\179vel."
    L4_2 = "error"
    L1_2(L2_2, L3_2, L4_2)
    return
  end
  L1_2 = TriggerClientEvent
  L2_2 = "apex_phone:client:adminOpen"
  L3_2 = A0_2
  L4_2 = {}
  L1_2(L2_2, L3_2, L4_2)
end
L77_1 = type
L78_1 = Config
L78_1 = L78_1.Admin
L77_1 = L77_1(L78_1)
if "table" == L77_1 then
  L77_1 = Config
  L77_1 = L77_1.Admin
  L77_1 = L77_1.command
  if L77_1 then
    goto lbl_416
  end
end
L77_1 = "phoneadmin"
::lbl_416::
L78_1 = type
L79_1 = L77_1
L78_1 = L78_1(L79_1)
if "string" == L78_1 and "" ~= L77_1 then
  L78_1 = FW
  L78_1 = L78_1.AddCommand
  L79_1 = L77_1
  L80_1 = "Painel de administra\195\167\195\163o do telem\195\179vel"
  L81_1 = {}
  function L82_1(A0_2)
    local L1_2, L2_2, L3_2, L4_2
    if not A0_2 or 0 == A0_2 then
      L1_2 = print
      L2_2 = "[unique_phone] the panel opens in-game (/"
      L3_2 = L77_1
      L4_2 = ")"
      L2_2 = L2_2 .. L3_2 .. L4_2
      L1_2(L2_2)
      return
    end
    L1_2 = L76_1
    L2_2 = A0_2
    L1_2(L2_2)
  end
  L83_1 = "admin"
  L78_1(L79_1, L80_1, L81_1, L82_1, L83_1)
end
L78_1 = {}
L79_1 = RegisterNetEvent
L80_1 = "apex_phone:server:adminRequest"
function L81_1()
  local L0_2, L1_2, L2_2, L3_2
  L0_2 = source
  L1_2 = GetGameTimer
  L1_2 = L1_2()
  L2_2 = L78_1
  L2_2 = L2_2[L0_2]
  if L2_2 then
    L2_2 = L78_1
    L2_2 = L2_2[L0_2]
    L2_2 = L1_2 - L2_2
    L3_2 = 1500
    if L2_2 < L3_2 then
      return
    end
  end
  L2_2 = L78_1
  L2_2[L0_2] = L1_2
  L2_2 = L76_1
  L3_2 = L0_2
  L2_2(L3_2)
end
L79_1(L80_1, L81_1)
L79_1 = RegisterNetEvent
L80_1 = "apex_phone:server:adminClosed"
function L81_1()
  local L0_2, L1_2
  L1_2 = source
  L0_2 = L73_1
  L0_2[L1_2] = nil
end
L79_1(L80_1, L81_1)
L79_1 = AddEventHandler
L80_1 = "playerDropped"
function L81_1()
  local L0_2, L1_2
  L0_2 = source
  L1_2 = L73_1
  L1_2[L0_2] = nil
  L1_2 = L78_1
  L1_2[L0_2] = nil
  L1_2 = L75_1
  L1_2[L0_2] = nil
end
L79_1(L80_1, L81_1)
L79_1 = CreateThread
function L80_1()
  local L0_2, L1_2, L2_2, L3_2, L4_2, L5_2, L6_2, L7_2
  while true do
    L0_2 = Wait
    L1_2 = 15000
    L0_2(L1_2)
    L0_2 = pairs
    L1_2 = L73_1
    L0_2, L1_2, L2_2, L3_2 = L0_2(L1_2)
    for L4_2 in L0_2, L1_2, L2_2, L3_2 do
      L5_2 = GetPlayerName
      L6_2 = L4_2
      L5_2 = L5_2(L6_2)
      if not L5_2 then
        L5_2 = L73_1
        L5_2[L4_2] = nil
      else
        L5_2 = IsPhoneAdmin
        L6_2 = L4_2
        L5_2 = L5_2(L6_2)
        if not L5_2 then
          L5_2 = L73_1
          L5_2[L4_2] = nil
          L5_2 = TriggerClientEvent
          L6_2 = "apex_phone:client:adminClose"
          L7_2 = L4_2
          L5_2(L6_2, L7_2)
        end
      end
    end
  end
end
L79_1(L80_1)
