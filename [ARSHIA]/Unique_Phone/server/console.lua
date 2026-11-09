local L0_1, L1_1, L2_1, L3_1, L4_1, L5_1, L6_1
L0_1 = "([%^%$%(%)%%%.%[%]%*%+%-%?])"
L1_1 = "^%%[%-%+ #0]*%d*%.?%d*[sdifx]"
function L2_1(A0_2)
  local L1_2, L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2
  L1_2 = {}
  L2_2 = 0
  L3_2 = 0
  L4_2 = 1
  L5_2 = #A0_2
  while L4_2 <= L5_2 do
    L7_2 = A0_2
    L6_2 = A0_2.sub
    L8_2 = L4_2
    L9_2 = L4_2
    L6_2 = L6_2(L7_2, L8_2, L9_2)
    if "%" == L6_2 then
      L8_2 = A0_2
      L7_2 = A0_2.sub
      L9_2 = L4_2 + 1
      L10_2 = L4_2 + 1
      L7_2 = L7_2(L8_2, L9_2, L10_2)
      if "%" == L7_2 then
        L7_2 = #L1_2
        L7_2 = L7_2 + 1
        L1_2[L7_2] = "%%"
        L3_2 = L3_2 + 1
        L4_2 = L4_2 + 2
      else
        L8_2 = A0_2
        L7_2 = A0_2.find
        L9_2 = L1_1
        L10_2 = L4_2
        L7_2, L8_2 = L7_2(L8_2, L9_2, L10_2)
        if L8_2 then
          L10_2 = A0_2
          L9_2 = A0_2.sub
          L11_2 = L8_2
          L12_2 = L8_2
          L9_2 = L9_2(L10_2, L11_2, L12_2)
          L10_2 = #L1_2
          L10_2 = L10_2 + 1
          if "s" == L9_2 then
            L11_2 = "(.-)"
            if L11_2 then
              goto lbl_51
            end
          end
          L11_2 = "(%-?[%d%.,]+)"
          ::lbl_51::
          L1_2[L10_2] = L11_2
          L2_2 = L2_2 + 1
          L4_2 = L8_2 + 1
        else
          L9_2 = #L1_2
          L9_2 = L9_2 + 1
          L1_2[L9_2] = "%%"
          L3_2 = L3_2 + 1
          L4_2 = L4_2 + 1
        end
      end
    else
      L7_2 = #L1_2
      L7_2 = L7_2 + 1
      L9_2 = L6_2
      L8_2 = L6_2.gsub
      L10_2 = L0_1
      L11_2 = "%%%1"
      L8_2 = L8_2(L9_2, L10_2, L11_2)
      L1_2[L7_2] = L8_2
      L3_2 = L3_2 + 1
      L4_2 = L4_2 + 1
    end
  end
  if 0 == L2_2 then
    L6_2 = nil
    return L6_2
  end
  L6_2 = "^"
  L7_2 = table
  L7_2 = L7_2.concat
  L8_2 = L1_2
  L7_2 = L7_2(L8_2)
  L8_2 = "$"
  L6_2 = L6_2 .. L7_2 .. L8_2
  L7_2 = L2_2
  L8_2 = L3_2
  return L6_2, L7_2, L8_2
end
L3_1 = nil
function L4_1(A0_2)
  local L1_2, L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2
  L1_2 = L3_1
  if L1_2 then
    L1_2 = L3_1
    return L1_2
  end
  L1_2 = {}
  L3_1 = L1_2
  L1_2 = pairs
  L2_2 = A0_2
  L1_2, L2_2, L3_2, L4_2 = L1_2(L2_2)
  for L5_2, L6_2 in L1_2, L2_2, L3_2, L4_2 do
    L7_2 = type
    L8_2 = L5_2
    L7_2 = L7_2(L8_2)
    if "string" == L7_2 then
      L7_2 = type
      L8_2 = L6_2
      L7_2 = L7_2(L8_2)
      if "string" == L7_2 then
        L8_2 = L5_2
        L7_2 = L5_2.find
        L9_2 = "%%[%-%+ #0]*%d*%.?%d*[sdifx]"
        L7_2 = L7_2(L8_2, L9_2)
        if L7_2 then
          L7_2 = L2_1
          L8_2 = L5_2
          L7_2, L8_2, L9_2 = L7_2(L8_2)
          if L7_2 then
            L10_2 = L3_1
            L10_2 = #L10_2
            L11_2 = L10_2 + 1
            L10_2 = L3_1
            L12_2 = {}
            L12_2.pat = L7_2
            L12_2.n = L8_2
            L12_2.lit = L9_2
            L12_2.key = L5_2
            L12_2.val = L6_2
            L10_2[L11_2] = L12_2
          end
        end
      end
    end
  end
  L1_2 = table
  L1_2 = L1_2.sort
  L2_2 = L3_1
  function L3_2(A0_3, A1_3)
    local L2_3, L3_3
    L2_3 = A0_3.lit
    L3_3 = A1_3.lit
    if L2_3 ~= L3_3 then
      L2_3 = A0_3.lit
      L3_3 = A1_3.lit
      L2_3 = L2_3 > L3_3
      return L2_3
    end
    L2_3 = A0_3.key
    L3_3 = A1_3.key
    L2_3 = L2_3 < L3_3
    return L2_3
  end
  L1_2(L2_2, L3_2)
  L1_2 = L3_1
  return L1_2
end
function L5_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2, L6_2
  L2_2 = 0
  L4_2 = A0_2
  L3_2 = A0_2.gsub
  L5_2 = "%%(%d*)%$?([%-%+ #0]*%d*%.?%d*)([sdifx%%])"
  function L6_2(A0_3, A1_3, A2_3)
    local L3_3, L4_3, L5_3, L6_3
    if "%" == A2_3 then
      L3_3 = "%"
      return L3_3
    end
    L3_3 = tonumber
    L4_3 = A0_3
    L3_3 = L3_3(L4_3)
    if not L3_3 then
      L4_3 = L2_2
      L4_3 = L4_3 + 1
      L2_2 = L4_3
      L3_3 = L2_2
    end
    L4_3 = A1_2
    L4_3 = L4_3[L3_3]
    if nil == L4_3 then
      L5_3 = ""
      if L5_3 then
        goto lbl_25
      end
    end
    L5_3 = tostring
    L6_3 = L4_3
    L5_3 = L5_3(L6_3)
    ::lbl_25::
    return L5_3
  end
  L3_2 = L3_2(L4_2, L5_2, L6_2)
  return L3_2
end
function L6_1(A0_2)
  local L1_2, L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2
  L1_2 = type
  L2_2 = A0_2
  L1_2 = L1_2(L2_2)
  if "string" ~= L1_2 or "" == A0_2 then
    return A0_2
  end
  L1_2 = type
  L2_2 = Locales
  L1_2 = L1_2(L2_2)
  if "table" == L1_2 then
    L1_2 = Locales
    L1_2 = L1_2.en
    if L1_2 then
      goto lbl_19
    end
  end
  L1_2 = nil
  ::lbl_19::
  L2_2 = type
  L3_2 = L1_2
  L2_2 = L2_2(L3_2)
  if "table" ~= L2_2 then
    return A0_2
  end
  L2_2 = L1_2[A0_2]
  L3_2 = type
  L4_2 = L2_2
  L3_2 = L3_2(L4_2)
  if "string" == L3_2 and "" ~= L2_2 then
    return L2_2
  end
  L3_2 = ipairs
  L4_2 = L4_1
  L5_2 = L1_2
  L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2 = L4_2(L5_2)
  L3_2, L4_2, L5_2, L6_2 = L3_2(L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2)
  for L7_2, L8_2 in L3_2, L4_2, L5_2, L6_2 do
    L9_2 = {}
    L11_2 = A0_2
    L10_2 = A0_2.match
    L12_2 = L8_2.pat
    L10_2, L11_2, L12_2, L13_2 = L10_2(L11_2, L12_2)
    L9_2[1] = L10_2
    L9_2[2] = L11_2
    L9_2[3] = L12_2
    L9_2[4] = L13_2
    L10_2 = L9_2[1]
    if nil ~= L10_2 then
      L10_2 = #L9_2
      L11_2 = L8_2.n
      if L10_2 == L11_2 then
        L10_2 = pcall
        L11_2 = L5_1
        L12_2 = L8_2.val
        L13_2 = L9_2
        L10_2, L11_2 = L10_2(L11_2, L12_2, L13_2)
        if L10_2 and L11_2 then
          return L11_2
        end
        return A0_2
      end
    end
  end
  return A0_2
end
ConsoleText = L6_1
