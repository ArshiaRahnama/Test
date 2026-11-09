local L0_1, L1_1, L2_1, L3_1, L4_1, L5_1, L6_1, L7_1, L8_1, L9_1, L10_1, L11_1, L12_1, L13_1, L14_1, L15_1, L16_1, L17_1, L18_1, L19_1, L20_1
L0_1 = Locales
if not L0_1 then
  L0_1 = {}
end
Locales = L0_1
L0_1 = {}
L0_1.en = "en"
L0_1.es = "es"
L0_1["zh-hans"] = "zh-Hans"
L0_1["zh-hant"] = "zh-Hant"
L0_1.ja = "ja"
L0_1.fr = "fr"
L0_1.de = "de"
L0_1.ru = "ru"
L0_1.pt = "pt"
L0_1.it = "it"
L0_1.ko = "ko"
L0_1.nl = "nl"
L0_1.tr = "tr"
L0_1.pl = "pl"
L0_1.sv = "sv"
L0_1.da = "da"
L0_1.zh = "zh-Hans"
L0_1.br = "pt"
L1_1 = "apex_phone:lang"
L2_1 = {}
L3_1 = Config
if L3_1 then
  L3_1 = Config
  L3_1 = L3_1.ExtraLanguages
end
L4_1 = type
L5_1 = L3_1
L4_1 = L4_1(L5_1)
if "table" == L4_1 then
  L4_1 = pairs
  L5_1 = L3_1
  L4_1, L5_1, L6_1, L7_1 = L4_1(L5_1)
  for L8_1, L9_1 in L4_1, L5_1, L6_1, L7_1 do
    L10_1 = nil
    L11_1 = nil
    L12_1 = type
    L13_1 = L9_1
    L12_1 = L12_1(L13_1)
    if "table" == L12_1 then
      L12_1 = L9_1.code
      L11_1 = L9_1.name
      L10_1 = L12_1
    else
      L12_1 = type
      L13_1 = L8_1
      L12_1 = L12_1(L13_1)
      if "string" == L12_1 then
        L12_1 = type
        L13_1 = L9_1
        L12_1 = L12_1(L13_1)
        if "string" == L12_1 then
          L12_1 = L8_1
          L11_1 = L9_1
          L10_1 = L12_1
      end
      else
        L12_1 = type
        L13_1 = L9_1
        L12_1 = L12_1(L13_1)
        if "string" == L12_1 then
          L10_1 = L9_1
        end
      end
    end
    L12_1 = type
    L13_1 = L10_1
    L12_1 = L12_1(L13_1)
    if "string" == L12_1 then
      L13_1 = L10_1
      L12_1 = L10_1.match
      L14_1 = "^%a[%w%-]*$"
      L12_1 = L12_1(L13_1, L14_1)
      if L12_1 then
        L12_1 = #L10_1
        if L12_1 <= 16 then
          L13_1 = L10_1
          L12_1 = L10_1.lower
          L12_1 = L12_1(L13_1)
          L12_1 = L0_1[L12_1]
          if not L12_1 then
            L13_1 = L10_1
            L12_1 = L10_1.lower
            L12_1 = L12_1(L13_1)
            L0_1[L12_1] = L10_1
            L12_1 = #L2_1
            L12_1 = L12_1 + 1
            L13_1 = {}
            L13_1.code = L10_1
            L14_1 = type
            L15_1 = L11_1
            L14_1 = L14_1(L15_1)
            L14_1 = L11_1 or L14_1
            if "string" ~= L14_1 or "" == L11_1 or not L11_1 then
              L14_1 = L10_1
            end
            L13_1.name = L14_1
            L2_1[L12_1] = L13_1
          end
        end
      end
    end
  end
  L4_1 = table
  L4_1 = L4_1.sort
  L5_1 = L2_1
  function L6_1(A0_2, A1_2)
    local L2_2, L3_2
    L2_2 = A0_2.code
    L3_2 = A1_2.code
    L2_2 = L2_2 < L3_2
    return L2_2
  end
  L4_1(L5_1, L6_1)
end
function L3_1()
  local L0_2, L1_2
  L0_2 = L2_1
  return L0_2
end
PhoneExtraLanguages = L3_1
L3_1 = {}
function L4_1(A0_2)
  local L1_2, L2_2
  L1_2 = type
  L2_2 = A0_2
  L1_2 = L1_2(L2_2)
  if "function" == L1_2 then
    L1_2 = L3_1
    L1_2 = #L1_2
    L2_2 = L1_2 + 1
    L1_2 = L3_1
    L1_2[L2_2] = A0_2
  end
end
PhoneLangOnChange = L4_1
function L4_1(A0_2)
  local L1_2, L2_2, L3_2, L4_2
  L1_2 = type
  L2_2 = A0_2
  L1_2 = L1_2(L2_2)
  if "string" ~= L1_2 then
    L1_2 = nil
    return L1_2
  end
  L2_2 = A0_2
  L1_2 = A0_2.gsub
  L3_2 = "_"
  L4_2 = "-"
  L1_2 = L1_2(L2_2, L3_2, L4_2)
  L2_2 = L1_2
  L1_2 = L1_2.lower
  L1_2 = L1_2(L2_2)
  A0_2 = L1_2
  if "" == A0_2 then
    L1_2 = nil
    return L1_2
  end
  L1_2 = L0_1
  L1_2 = L1_2[A0_2]
  if not L1_2 then
    L2_2 = A0_2
    L1_2 = A0_2.sub
    L3_2 = 1
    L4_2 = 2
    L1_2 = L1_2(L2_2, L3_2, L4_2)
    L2_2 = L0_1
    L1_2 = L2_2[L1_2]
  end
  return L1_2
end
function L5_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2
  L2_2 = pcall
  function L3_2()
    local L0_3, L1_3
    L0_3 = GlobalState
    L0_3 = L0_3["apex_phone:settings"]
    return L0_3
  end
  L2_2, L3_2 = L2_2(L3_2)
  if L2_2 then
    L4_2 = type
    L5_2 = L3_2
    L4_2 = L4_2(L5_2)
    if "table" == L4_2 then
      L4_2 = type
      L5_2 = L3_2.config
      L4_2 = L4_2(L5_2)
      if "table" == L4_2 then
        L4_2 = L3_2.config
        L4_2 = L4_2[A0_2]
        if nil ~= L4_2 then
          L4_2 = L3_2.config
          L4_2 = L4_2[A0_2]
          return L4_2
        end
      end
    end
  end
  L4_2 = Config
  if L4_2 then
    L4_2 = Config
    L4_2 = L4_2[A0_2]
  end
  if nil == L4_2 then
    return A1_2
  end
  return L4_2
end
PhoneDefault = L5_1
L5_1 = "default"
L6_1 = nil
function L7_1()
  local L0_2, L1_2, L2_2, L3_2, L4_2, L5_2
  L0_2 = nil
  L1_2 = pcall
  function L2_2()
    local L0_3, L1_3
    L0_3 = GetResourceKvpString
    L1_3 = L1_1
    L0_3 = L0_3(L1_3)
    L0_2 = L0_3
  end
  L1_2(L2_2)
  L1_2 = L4_1
  L2_2 = L0_2
  L1_2 = L1_2(L2_2)
  if L1_2 then
    L2_2 = "kvp"
    L5_1 = L2_2
    return L1_2
  end
  L2_2 = "default"
  L5_1 = L2_2
  L2_2 = L4_1
  L3_2 = PhoneDefault
  L4_2 = "DefaultLanguage"
  L5_2 = nil
  L3_2, L4_2, L5_2 = L3_2(L4_2, L5_2)
  L2_2 = L2_2(L3_2, L4_2, L5_2)
  if not L2_2 then
    L2_2 = L4_1
    L3_2 = Config
    if L3_2 then
      L3_2 = Config
      L3_2 = L3_2.DefaultLanguage
    end
    L2_2 = L2_2(L3_2)
    if not L2_2 then
      L2_2 = "en"
    end
  end
  return L2_2
end
L8_1 = L7_1
L8_1 = L8_1()
function L9_1()
  local L0_2, L1_2
  L0_2 = L8_1
  return L0_2
end
PhoneLangCode = L9_1
function L9_1()
  local L0_2, L1_2, L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2
  L0_2 = ipairs
  L1_2 = L3_1
  L0_2, L1_2, L2_2, L3_2 = L0_2(L1_2)
  for L4_2, L5_2 in L0_2, L1_2, L2_2, L3_2 do
    L6_2 = pcall
    L7_2 = L5_2
    L8_2 = L8_1
    L6_2, L7_2 = L6_2(L7_2, L8_2)
    if not L6_2 then
      L8_2 = print
      L9_2 = "[unique_phone] language listener failed: %s"
      L10_2 = L9_2
      L9_2 = L9_2.format
      L11_2 = tostring
      L12_2 = L7_2
      L11_2, L12_2 = L11_2(L12_2)
      L9_2, L10_2, L11_2, L12_2 = L9_2(L10_2, L11_2, L12_2)
      L8_2(L9_2, L10_2, L11_2, L12_2)
    end
  end
end
function L10_1()
  local L0_2, L1_2, L2_2, L3_2
  L0_2 = L5_1
  if "default" ~= L0_2 then
    L0_2 = false
    return L0_2
  end
  L0_2 = L4_1
  L1_2 = PhoneDefault
  L2_2 = "DefaultLanguage"
  L3_2 = nil
  L1_2, L2_2, L3_2 = L1_2(L2_2, L3_2)
  L0_2 = L0_2(L1_2, L2_2, L3_2)
  if not L0_2 then
    L0_2 = L4_1
    L1_2 = Config
    if L1_2 then
      L1_2 = Config
      L1_2 = L1_2.DefaultLanguage
    end
    L0_2 = L0_2(L1_2)
    if not L0_2 then
      L0_2 = "en"
    end
  end
  L1_2 = L8_1
  if L0_2 == L1_2 then
    L1_2 = false
    return L1_2
  end
  L8_1 = L0_2
  L1_2 = L9_1
  L1_2()
  L1_2 = true
  return L1_2
end
PhoneLangDefaultChanged = L10_1
function L10_1()
  local L0_2, L1_2, L2_2, L3_2, L4_2
  L0_2 = nil
  L1_2 = pcall
  function L2_2()
    local L0_3, L1_3
    L0_3 = GetResourceKvpString
    L1_3 = L1_1
    L0_3 = L0_3(L1_3)
    L0_2 = L0_3
  end
  L1_2(L2_2)
  L1_2 = {}
  L2_2 = L8_1
  L1_2.lang = L2_2
  L2_2 = L5_1
  L1_2.source = L2_2
  L1_2.saved = L0_2
  L2_2 = Config
  if L2_2 then
    L2_2 = Config
    L2_2 = L2_2.DefaultLanguage
  end
  L1_2.fileDefault = L2_2
  L2_2 = PhoneDefault
  L3_2 = "DefaultLanguage"
  L4_2 = nil
  L2_2 = L2_2(L3_2, L4_2)
  L1_2.effectiveDefault = L2_2
  L2_2 = L6_1
  L1_2.reported = L2_2
  return L1_2
end
PhoneLangInfo = L10_1
L10_1 = "([%^%$%(%)%%%.%[%]%*%+%-%?])"
L11_1 = "^%%[%-%+ #0]*%d*%.?%d*[sdifx]"
function L12_1(A0_2)
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
        L9_2 = L11_1
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
      L10_2 = L10_1
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
L13_1 = {}
function L14_1(A0_2)
  local L1_2, L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2
  L1_2 = L13_1
  L1_2 = L1_2[A0_2]
  if L1_2 then
    return L1_2
  end
  L2_2 = {}
  L1_2 = L2_2
  L2_2 = Locales
  L2_2 = L2_2[A0_2]
  L3_2 = type
  L4_2 = L2_2
  L3_2 = L3_2(L4_2)
  if "table" == L3_2 then
    L3_2 = pairs
    L4_2 = L2_2
    L3_2, L4_2, L5_2, L6_2 = L3_2(L4_2)
    for L7_2, L8_2 in L3_2, L4_2, L5_2, L6_2 do
      L9_2 = type
      L10_2 = L7_2
      L9_2 = L9_2(L10_2)
      if "string" == L9_2 then
        L9_2 = type
        L10_2 = L8_2
        L9_2 = L9_2(L10_2)
        if "string" == L9_2 then
          L10_2 = L7_2
          L9_2 = L7_2.find
          L11_2 = "%%[%-%+ #0]*%d*%.?%d*[sdifx]"
          L9_2 = L9_2(L10_2, L11_2)
          if L9_2 then
            L9_2 = L12_1
            L10_2 = L7_2
            L9_2, L10_2, L11_2 = L9_2(L10_2)
            if L9_2 then
              L12_2 = #L1_2
              L12_2 = L12_2 + 1
              L13_2 = {}
              L13_2.pat = L9_2
              L13_2.n = L10_2
              L13_2.lit = L11_2
              L13_2.key = L7_2
              L13_2.val = L8_2
              L1_2[L12_2] = L13_2
            end
          end
        end
      end
    end
    L3_2 = table
    L3_2 = L3_2.sort
    L4_2 = L1_2
    function L5_2(A0_3, A1_3)
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
    L3_2(L4_2, L5_2)
  end
  L3_2 = L13_1
  L3_2[A0_2] = L1_2
  return L1_2
end
function L15_1(A0_2, A1_2, A2_2)
  local L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2, L19_2
  L3_2 = {}
  L4_2 = 0
  L5_2 = 1
  L6_2 = #A0_2
  while L5_2 <= L6_2 do
    L8_2 = A0_2
    L7_2 = A0_2.find
    L9_2 = "%"
    L10_2 = L5_2
    L11_2 = true
    L7_2 = L7_2(L8_2, L9_2, L10_2, L11_2)
    if not L7_2 then
      L8_2 = #L3_2
      L8_2 = L8_2 + 1
      L10_2 = A0_2
      L9_2 = A0_2.sub
      L11_2 = L5_2
      L9_2 = L9_2(L10_2, L11_2)
      L3_2[L8_2] = L9_2
      break
    end
    L8_2 = #L3_2
    L8_2 = L8_2 + 1
    L10_2 = A0_2
    L9_2 = A0_2.sub
    L11_2 = L5_2
    L12_2 = L7_2 - 1
    L9_2 = L9_2(L10_2, L11_2, L12_2)
    L3_2[L8_2] = L9_2
    L9_2 = A0_2
    L8_2 = A0_2.sub
    L10_2 = L7_2 + 1
    L11_2 = L7_2 + 1
    L8_2 = L8_2(L9_2, L10_2, L11_2)
    if "%" == L8_2 then
      L8_2 = #L3_2
      L8_2 = L8_2 + 1
      L3_2[L8_2] = "%"
      L5_2 = L7_2 + 2
    else
      L9_2 = A0_2
      L8_2 = A0_2.find
      L10_2 = "^%%(%d+)%$([%-%+ #0]*%d*%.?%d*)([sdifx])"
      L11_2 = L7_2
      L8_2, L9_2, L10_2, L11_2, L12_2 = L8_2(L9_2, L10_2, L11_2)
      if not L8_2 then
        L14_2 = A0_2
        L13_2 = A0_2.find
        L15_2 = "^%%([%-%+ #0]*%d*%.?%d*)([sdifx])"
        L16_2 = L7_2
        L13_2, L14_2, L15_2, L16_2 = L13_2(L14_2, L15_2, L16_2)
        L12_2 = L16_2
        L11_2 = L15_2
        L9_2 = L14_2
        L8_2 = L13_2
      end
      if not L8_2 then
        L13_2 = #L3_2
        L13_2 = L13_2 + 1
        L3_2[L13_2] = "%"
        L5_2 = L7_2 + 1
      else
        L13_2 = tonumber
        L14_2 = L10_2
        L13_2 = L13_2(L14_2)
        if not L13_2 then
          L4_2 = L4_2 + 1
          L13_2 = L4_2
        end
        L14_2 = A1_2[L13_2]
        if A2_2 or nil == L14_2 then
          L15_2 = #L3_2
          L15_2 = L15_2 + 1
          L16_2 = tostring
          if nil == L14_2 then
            L17_2 = ""
            if L17_2 then
              goto lbl_93
            end
          end
          L17_2 = L14_2
          ::lbl_93::
          L16_2 = L16_2(L17_2)
          L3_2[L15_2] = L16_2
        else
          if "d" == L12_2 or "i" == L12_2 or "x" == L12_2 then
            L15_2 = math
            L15_2 = L15_2.floor
            L16_2 = tonumber
            L17_2 = L14_2
            L16_2 = L16_2(L17_2)
            if not L16_2 then
              L16_2 = 0
            end
            L16_2 = L16_2 + 0.0
            L15_2 = L15_2(L16_2)
            L14_2 = L15_2
          end
          L15_2 = pcall
          L16_2 = string
          L16_2 = L16_2.format
          L17_2 = "%"
          L18_2 = L11_2 or L18_2
          if not L11_2 then
            L18_2 = ""
          end
          L19_2 = L12_2
          L17_2 = L17_2 .. L18_2 .. L19_2
          L18_2 = L14_2
          L15_2, L16_2 = L15_2(L16_2, L17_2, L18_2)
          L17_2 = #L3_2
          L17_2 = L17_2 + 1
          L18_2 = L16_2 or L18_2
          if not L15_2 or not L16_2 then
            L18_2 = tostring
            L19_2 = L14_2
            L18_2 = L18_2(L19_2)
          end
          L3_2[L17_2] = L18_2
        end
        L5_2 = L9_2 + 1
      end
    end
  end
  L7_2 = table
  L7_2 = L7_2.concat
  L8_2 = L3_2
  return L7_2(L8_2)
end
function L16_1(A0_2)
  local L1_2, L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2
  L1_2 = type
  L2_2 = A0_2
  L1_2 = L1_2(L2_2)
  if "string" == L1_2 and "" ~= A0_2 then
    L1_2 = L8_1
    if "pt" ~= L1_2 then
      goto lbl_12
    end
  end
  do return A0_2 end
  ::lbl_12::
  L1_2 = Locales
  L2_2 = L8_1
  L1_2 = L1_2[L2_2]
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
  L4_2 = L14_1
  L5_2 = L8_1
  L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2 = L4_2(L5_2)
  L3_2, L4_2, L5_2, L6_2 = L3_2(L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2)
  for L7_2, L8_2 in L3_2, L4_2, L5_2, L6_2 do
    L9_2 = {}
    L11_2 = A0_2
    L10_2 = A0_2.match
    L12_2 = L8_2.pat
    L10_2, L11_2, L12_2, L13_2, L14_2 = L10_2(L11_2, L12_2)
    L9_2[1] = L10_2
    L9_2[2] = L11_2
    L9_2[3] = L12_2
    L9_2[4] = L13_2
    L9_2[5] = L14_2
    L10_2 = L9_2[1]
    if nil ~= L10_2 then
      L10_2 = #L9_2
      L11_2 = L8_2.n
      if L10_2 == L11_2 then
        L10_2 = pcall
        L11_2 = L15_1
        L12_2 = L8_2.val
        L13_2 = L9_2
        L14_2 = true
        L10_2, L11_2 = L10_2(L11_2, L12_2, L13_2, L14_2)
        if L10_2 and L11_2 then
          return L11_2
        end
        return A0_2
      end
    end
  end
  return A0_2
end
Tr = L16_1
function L16_1(A0_2, ...)
  local L1_2, L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2
  L1_2 = {}
  L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2 = ...
  L1_2[1] = L2_2
  L1_2[2] = L3_2
  L1_2[3] = L4_2
  L1_2[4] = L5_2
  L1_2[5] = L6_2
  L1_2[6] = L7_2
  L1_2[7] = L8_2
  L1_2[8] = L9_2
  L1_2[9] = L10_2
  L2_2 = L8_1
  if "pt" ~= L2_2 then
    L2_2 = Locales
    L3_2 = L8_1
    L2_2 = L2_2[L3_2]
    if L2_2 then
      goto lbl_15
    end
  end
  L2_2 = nil
  ::lbl_15::
  L3_2 = type
  L4_2 = L2_2
  L3_2 = L3_2(L4_2)
  if "table" == L3_2 then
    L3_2 = type
    L4_2 = L2_2[A0_2]
    L3_2 = L3_2(L4_2)
    if "string" == L3_2 then
      L3_2 = L2_2[A0_2]
      if "" ~= L3_2 then
        L3_2 = L2_2[A0_2]
        if L3_2 then
          goto lbl_32
        end
      end
    end
  end
  L3_2 = A0_2
  ::lbl_32::
  L4_2 = pcall
  L5_2 = L15_1
  L6_2 = L3_2
  L7_2 = L1_2
  L8_2 = false
  L4_2, L5_2 = L4_2(L5_2, L6_2, L7_2, L8_2)
  if L4_2 and L5_2 then
    return L5_2
  end
  L6_2 = pcall
  L7_2 = L15_1
  L8_2 = A0_2
  L9_2 = L1_2
  L10_2 = false
  L6_2, L7_2 = L6_2(L7_2, L8_2, L9_2, L10_2)
  L5_2 = L7_2
  L4_2 = L6_2
  L6_2 = L5_2 or L6_2
  if not L4_2 or not L5_2 then
    L6_2 = tostring
    L7_2 = A0_2
    L6_2 = L6_2(L7_2)
  end
  return L6_2
end
TrF = L16_1
L16_1 = {}
function L17_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2
  L2_2 = {}
  L3_2 = ipairs
  L4_2 = A1_2.args
  if not L4_2 then
    L4_2 = {}
  end
  L3_2, L4_2, L5_2, L6_2 = L3_2(L4_2)
  for L7_2, L8_2 in L3_2, L4_2, L5_2, L6_2 do
    L9_2 = type
    L10_2 = L8_2
    L9_2 = L9_2(L10_2)
    if "table" == L9_2 then
      L9_2 = {}
      L10_2 = Tr
      L11_2 = tostring
      L12_2 = L8_2.name
      if not L12_2 then
        L12_2 = ""
      end
      L11_2, L12_2 = L11_2(L12_2)
      L10_2 = L10_2(L11_2, L12_2)
      L9_2.name = L10_2
      L10_2 = Tr
      L11_2 = tostring
      L12_2 = L8_2.help
      if not L12_2 then
        L12_2 = ""
      end
      L11_2, L12_2 = L11_2(L12_2)
      L10_2 = L10_2(L11_2, L12_2)
      L9_2.help = L10_2
      L2_2[L7_2] = L9_2
    end
  end
  L3_2 = TriggerEvent
  L4_2 = "chat:addSuggestion"
  L5_2 = A0_2
  L6_2 = Tr
  L7_2 = tostring
  L8_2 = A1_2.help
  if not L8_2 then
    L8_2 = ""
  end
  L7_2, L8_2, L9_2, L10_2, L11_2, L12_2 = L7_2(L8_2)
  L6_2 = L6_2(L7_2, L8_2, L9_2, L10_2, L11_2, L12_2)
  L7_2 = L2_2
  L3_2(L4_2, L5_2, L6_2, L7_2)
end
L18_1 = RegisterNetEvent
L19_1 = "apex_phone:client:suggestion"
function L20_1(A0_2, A1_2, A2_2)
  local L3_2, L4_2, L5_2, L6_2
  L3_2 = type
  L4_2 = A0_2
  L3_2 = L3_2(L4_2)
  if "string" ~= L3_2 or "" == A0_2 then
    return
  end
  L3_2 = L16_1
  L4_2 = {}
  L4_2.help = A1_2
  L5_2 = type
  L6_2 = A2_2
  L5_2 = L5_2(L6_2)
  L5_2 = A2_2 or L5_2
  if "table" ~= L5_2 or not A2_2 then
    L5_2 = {}
  end
  L4_2.args = L5_2
  L3_2[A0_2] = L4_2
  L3_2 = L17_1
  L4_2 = A0_2
  L5_2 = L16_1
  L5_2 = L5_2[A0_2]
  L3_2(L4_2, L5_2)
end
L18_1(L19_1, L20_1)
L18_1 = RegisterNetEvent
L19_1 = "apex_phone:client:notify"
function L20_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2
  L2_2 = FW
  if L2_2 then
    L2_2 = FW
    L2_2 = L2_2.Notify
    if L2_2 then
      L2_2 = FW
      L2_2 = L2_2.Notify
      L3_2 = A0_2
      L4_2 = A1_2
      L2_2(L3_2, L4_2)
    end
  end
end
L18_1(L19_1, L20_1)
function L18_1(A0_2)
  local L1_2, L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2
  L1_2 = L4_1
  L2_2 = A0_2
  L1_2 = L1_2(L2_2)
  L2_2 = type
  L3_2 = A0_2
  L2_2 = L2_2(L3_2)
  L2_2 = A0_2 or L2_2
  if "string" ~= L2_2 or not A0_2 then
    L2_2 = nil
  end
  L6_1 = L2_2
  if not L1_2 then
    L2_2 = false
    return L2_2
  end
  L2_2 = "nui"
  L5_1 = L2_2
  L2_2 = L8_1
  if L1_2 == L2_2 then
    L2_2 = false
    return L2_2
  end
  L8_1 = L1_2
  L2_2 = pcall
  L3_2 = SetResourceKvp
  L4_2 = L1_1
  L5_2 = L1_2
  L2_2(L3_2, L4_2, L5_2)
  L2_2 = pairs
  L3_2 = L16_1
  L2_2, L3_2, L4_2, L5_2 = L2_2(L3_2)
  for L6_2, L7_2 in L2_2, L3_2, L4_2, L5_2 do
    L8_2 = L17_1
    L9_2 = L6_2
    L10_2 = L7_2
    L8_2(L9_2, L10_2)
  end
  L2_2 = L9_1
  L2_2()
  L2_2 = true
  return L2_2
end
SetPhoneLang = L18_1
