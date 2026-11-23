local L0_1, L1_1, L2_1, L3_1, L4_1, L5_1, L6_1, L7_1, L8_1, L9_1, L10_1, L11_1, L12_1, L13_1, L14_1, L15_1, L16_1, L17_1, L18_1, L19_1, L20_1, L21_1, L22_1, L23_1, L24_1, L25_1, L26_1, L27_1, L28_1
L0_1 = GetCurrentResourceName
L0_1 = L0_1()
L1_1 = {}
L2_1 = ipairs
L3_1 = Config
L3_1 = L3_1.components
if not L3_1 then
  L3_1 = {}
end
L2_1, L3_1, L4_1, L5_1 = L2_1(L3_1)
for L6_1, L7_1 in L2_1, L3_1, L4_1, L5_1 do
  L8_1 = L7_1.key
  L9_1 = L7_1.id
  L1_1[L8_1] = L9_1
end
L2_1 = {}
L3_1 = ipairs
L4_1 = Config
L4_1 = L4_1.props
if not L4_1 then
  L4_1 = {}
end
L3_1, L4_1, L5_1, L6_1 = L3_1(L4_1)
for L7_1, L8_1 in L3_1, L4_1, L5_1, L6_1 do
  L9_1 = L8_1.key
  L10_1 = L8_1.id
  L2_1[L9_1] = L10_1
end
L3_1 = {}
L3_1.male = "mp_m_freemode_01"
L3_1.female = "mp_f_freemode_01"
L4_1 = type
L5_1 = io
L4_1 = L4_1(L5_1)
L4_1 = "table" == L4_1
function L5_1(A0_2)
  local L1_2, L2_2, L3_2, L4_2
  L1_2 = {}
  L2_2 = pcall
  function L3_2()
    local L0_3, L1_3, L2_3, L3_3, L4_3, L5_3, L6_3, L7_3, L8_3
    L0_3 = "@%s/%s"
    L1_3 = L0_3
    L0_3 = L0_3.format
    L2_3 = L0_1
    L3_3 = A0_2
    L0_3 = L0_3(L1_3, L2_3, L3_3)
    L1_3 = io
    L1_3 = L1_3.readdir
    L2_3 = L0_3
    L1_3 = L1_3(L2_3)
    if not L1_3 then
      return
    end
    L3_3 = L1_3
    L2_3 = L1_3.lines
    L2_3, L3_3, L4_3, L5_3 = L2_3(L3_3)
    for L6_3 in L2_3, L3_3, L4_3, L5_3 do
      if "." ~= L6_3 and ".." ~= L6_3 then
        L7_3 = L1_2
        L7_3 = #L7_3
        L8_3 = L7_3 + 1
        L7_3 = L1_2
        L7_3[L8_3] = L6_3
      end
    end
    L2_3 = L1_3.close
    if L2_3 then
      L3_3 = L1_3
      L2_3 = L1_3.close
      L2_3(L3_3)
    end
  end
  L2_2 = L2_2(L3_2)
  L3_2 = L1_2
  L4_2 = L2_2
  return L3_2, L4_2
end
function L6_1(A0_2)
  local L1_2, L2_2, L3_2, L4_2, L5_2
  L2_2 = A0_2
  L1_2 = A0_2.match
  L3_2 = "^(.*)%.([^.]+)$"
  L1_2, L2_2 = L1_2(L2_2, L3_2)
  if not L1_2 then
    L3_2 = A0_2
    L4_2 = ""
    return L3_2, L4_2
  end
  L3_2 = L1_2
  L5_2 = L2_2
  L4_2 = L2_2.lower
  L4_2, L5_2 = L4_2(L5_2)
  return L3_2, L4_2, L5_2
end
function L7_1(A0_2, A1_2, A2_2)
  local L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2
  L3_2 = L3_1
  L3_2 = L3_2[A0_2]
  if not L3_2 then
    L3_2 = L3_1.male
  end
  L4_2 = Config
  L4_2 = L4_2.templates
  if L4_2 then
    L4_2 = Config
    L4_2 = L4_2.templates
    L4_2 = L4_2.collection
    if L4_2 then
      goto lbl_16
    end
  end
  L4_2 = ""
  ::lbl_16::
  L5_2 = L3_2
  if "" ~= L4_2 then
    L6_2 = "_"
    L7_2 = L4_2
    L6_2 = L6_2 .. L7_2
    if L6_2 then
      goto lbl_25
    end
  end
  L6_2 = ""
  ::lbl_25::
  L5_2 = L5_2 .. L6_2
  L7_2 = A2_2
  L6_2 = A2_2.find
  L8_2 = "_diff_"
  L6_2 = L6_2(L7_2, L8_2)
  if L6_2 then
    L6_2 = L5_2
    L7_2 = "/"
    L8_2 = A2_2
    L6_2 = L6_2 .. L7_2 .. L8_2
    L7_2 = A2_2
    return L6_2, L7_2
  end
  L7_2 = A2_2
  L6_2 = A2_2.match
  L8_2 = "(%d+)"
  L6_2 = L6_2(L7_2, L8_2)
  if L6_2 then
    L7_2 = tonumber
    L8_2 = L6_2
    L7_2 = L7_2(L8_2)
    if L7_2 then
      goto lbl_48
      L6_2 = L7_2 or L6_2
    end
  end
  L6_2 = 0
  ::lbl_48::
  L7_2 = "uni"
  L9_2 = A2_2
  L8_2 = A2_2.match
  L10_2 = "_r$"
  L8_2 = L8_2(L9_2, L10_2)
  if L8_2 then
    L7_2 = "whi"
  end
  L8_2 = A1_2
  L9_2 = L2_1
  L9_2 = L9_2[A1_2]
  if L9_2 then
    L9_2 = "%s_diff_%03d_a"
    L10_2 = L9_2
    L9_2 = L9_2.format
    L11_2 = L8_2
    L12_2 = L6_2
    L9_2 = L9_2(L10_2, L11_2, L12_2)
    L10_2 = L5_2
    L11_2 = "_p/"
    L12_2 = L9_2
    L10_2 = L10_2 .. L11_2 .. L12_2
    L11_2 = L9_2
    return L10_2, L11_2
  end
  L9_2 = "%s_diff_%03d_a_%s"
  L10_2 = L9_2
  L9_2 = L9_2.format
  L11_2 = L8_2
  L12_2 = L6_2
  L13_2 = L7_2
  L9_2 = L9_2(L10_2, L11_2, L12_2, L13_2)
  L10_2 = L5_2
  L11_2 = "/"
  L12_2 = L9_2
  L10_2 = L10_2 .. L11_2 .. L12_2
  L11_2 = L9_2
  return L10_2, L11_2
end
function L8_1(A0_2)
  local L1_2, L2_2, L3_2, L4_2, L5_2
  L2_2 = A0_2
  L1_2 = A0_2.gsub
  L3_2 = "[_%-]+"
  L4_2 = " "
  L1_2 = L1_2(L2_2, L3_2, L4_2)
  L3_2 = L1_2
  L2_2 = L1_2.gsub
  L4_2 = "(%a)([%w]*)"
  function L5_2(A0_3, A1_3)
    local L2_3, L3_3
    L3_3 = A0_3
    L2_3 = A0_3.upper
    L2_3 = L2_3(L3_3)
    L3_3 = A1_3
    L2_3 = L2_3 .. L3_3
    return L2_3
  end
  L2_2 = L2_2(L3_2, L4_2, L5_2)
  L1_2 = L2_2
  L3_2 = L1_2
  L2_2 = L1_2.gsub
  L4_2 = "^%s+"
  L5_2 = ""
  L2_2 = L2_2(L3_2, L4_2, L5_2)
  L3_2 = L2_2
  L2_2 = L2_2.gsub
  L4_2 = "%s+$"
  L5_2 = ""
  L2_2 = L2_2(L3_2, L4_2, L5_2)
  return L2_2
end
L9_1 = nil
function L10_1(A0_2)
  local L1_2, L2_2, L3_2, L4_2, L5_2
  L1_2 = LoadResourceFile
  L2_2 = L0_1
  L3_2 = A0_2
  L1_2 = L1_2(L2_2, L3_2)
  L2_2 = type
  L3_2 = L1_2
  L2_2 = L2_2(L3_2)
  if "string" ~= L2_2 or "" == L1_2 then
    L2_2 = nil
    return L2_2
  end
  L2_2 = pcall
  L3_2 = json
  L3_2 = L3_2.decode
  L4_2 = L1_2
  L2_2, L3_2 = L2_2(L3_2, L4_2)
  if L2_2 then
    L4_2 = type
    L5_2 = L3_2
    L4_2 = L4_2(L5_2)
    if "table" == L4_2 then
      return L3_2
    end
  end
  L4_2 = nil
  return L4_2
end
function L11_1()
  local L0_2, L1_2, L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2, L19_2, L20_2, L21_2, L22_2, L23_2, L24_2, L25_2, L26_2, L27_2, L28_2, L29_2, L30_2, L31_2, L32_2, L33_2, L34_2, L35_2, L36_2, L37_2, L38_2, L39_2, L40_2
  L0_2 = {}
  L1_2 = Config
  L1_2 = L1_2.templates
  if L1_2 then
    L1_2 = Config
    L1_2 = L1_2.templates
    L1_2 = L1_2.dir
    if L1_2 then
      goto lbl_13
    end
  end
  L1_2 = "stream/models"
  ::lbl_13::
  L2_2 = pairs
  L3_2 = L3_1
  L2_2, L3_2, L4_2, L5_2 = L2_2(L3_2)
  for L6_2, L7_2 in L2_2, L3_2, L4_2, L5_2 do
    L8_2 = {}
    L9_2 = pairs
    L10_2 = L1_1
    L9_2, L10_2, L11_2, L12_2 = L9_2(L10_2)
    for L13_2 in L9_2, L10_2, L11_2, L12_2 do
      L14_2 = #L8_2
      L14_2 = L14_2 + 1
      L8_2[L14_2] = L13_2
    end
    L9_2 = pairs
    L10_2 = L2_1
    L9_2, L10_2, L11_2, L12_2 = L9_2(L10_2)
    for L13_2 in L9_2, L10_2, L11_2, L12_2 do
      L14_2 = #L8_2
      L14_2 = L14_2 + 1
      L8_2[L14_2] = L13_2
    end
    L9_2 = ipairs
    L10_2 = L8_2
    L9_2, L10_2, L11_2, L12_2 = L9_2(L10_2)
    for L13_2, L14_2 in L9_2, L10_2, L11_2, L12_2 do
      L15_2 = "%s/%s/%s"
      L16_2 = L15_2
      L15_2 = L15_2.format
      L17_2 = L1_2
      L18_2 = L6_2
      L19_2 = L14_2
      L15_2 = L15_2(L16_2, L17_2, L18_2, L19_2)
      L16_2 = L5_1
      L17_2 = L15_2
      L16_2 = L16_2(L17_2)
      L17_2 = {}
      L18_2 = ipairs
      L19_2 = L16_2
      L18_2, L19_2, L20_2, L21_2 = L18_2(L19_2)
      for L22_2, L23_2 in L18_2, L19_2, L20_2, L21_2 do
        L24_2 = L6_1
        L25_2 = L23_2
        L24_2, L25_2 = L24_2(L25_2)
        if "" ~= L24_2 and "" ~= L25_2 then
          L26_2 = L17_2[L24_2]
          if not L26_2 then
            L26_2 = {}
          end
          L17_2[L24_2] = L26_2
          L26_2 = L17_2[L24_2]
          L27_2 = "%s/%s"
          L28_2 = L27_2
          L27_2 = L27_2.format
          L29_2 = L15_2
          L30_2 = L23_2
          L27_2 = L27_2(L28_2, L29_2, L30_2)
          L26_2[L25_2] = L27_2
        end
      end
      L18_2 = pairs
      L19_2 = L17_2
      L18_2, L19_2, L20_2, L21_2 = L18_2(L19_2)
      for L22_2, L23_2 in L18_2, L19_2, L20_2, L21_2 do
        L24_2 = L23_2.glb
        L25_2 = L23_2.png
        if not L25_2 then
          L25_2 = L23_2.jpg
          if not L25_2 then
            L25_2 = L23_2.jpeg
            if not L25_2 then
              L25_2 = L23_2.webp
            end
          end
        end
        L26_2 = L23_2.ydd
        L26_2 = nil ~= L26_2
        if L24_2 or L26_2 then
          L27_2 = L1_1
          L27_2 = L27_2[L14_2]
          L28_2 = nil == L27_2
          if nil == L27_2 then
            L29_2 = L2_1
            L27_2 = L29_2[L14_2]
          end
          L29_2 = L7_1
          L30_2 = L6_2
          L31_2 = L14_2
          L32_2 = L22_2
          L29_2, L30_2 = L29_2(L30_2, L31_2, L32_2)
          L31_2 = {}
          L32_2 = "%s_%s_%s"
          L33_2 = L32_2
          L32_2 = L32_2.format
          L34_2 = L6_2
          L35_2 = L14_2
          L36_2 = L22_2
          L32_2 = L32_2(L33_2, L34_2, L35_2, L36_2)
          L31_2.id = L32_2
          L32_2 = L8_1
          L33_2 = L22_2
          L32_2 = L32_2(L33_2)
          L31_2.name = L32_2
          L31_2.gender = L6_2
          L32_2 = L27_2 or L32_2
          if not L27_2 then
            L32_2 = 11
          end
          L31_2.component = L32_2
          L31_2.componentKey = L14_2
          L32_2 = L28_2 or L32_2
          if not L28_2 then
            L32_2 = false
          end
          L31_2.isProp = L32_2
          L32_2 = L24_2 or L32_2
          if not L24_2 then
            L32_2 = nil
          end
          L31_2.glb = L32_2
          L32_2 = L25_2 or L32_2
          if not L25_2 then
            L32_2 = nil
          end
          L31_2.thumb = L32_2
          L32_2 = L25_2 or L32_2
          if not L25_2 then
            L32_2 = nil
          end
          L31_2.baseTexture = L32_2
          L31_2.txd = L29_2
          L31_2.txn = L30_2
          L32_2 = nil ~= L24_2
          L31_2.ready = L32_2
          L32_2 = L26_2 or L32_2
          if nil ~= L24_2 or not L26_2 then
            L32_2 = false
          end
          L31_2.needsConversion = L32_2
          L31_2.source = "folder"
          L32_2 = L23_2.json
          if L32_2 then
            L32_2 = L10_1
            L33_2 = L23_2.json
            L32_2 = L32_2(L33_2)
            if L32_2 then
              L33_2 = ipairs
              L34_2 = {}
              L35_2 = "name"
              L36_2 = "component"
              L37_2 = "txd"
              L38_2 = "txn"
              L39_2 = "size"
              L40_2 = "collection"
              L34_2[1] = L35_2
              L34_2[2] = L36_2
              L34_2[3] = L37_2
              L34_2[4] = L38_2
              L34_2[5] = L39_2
              L34_2[6] = L40_2
              L33_2, L34_2, L35_2, L36_2 = L33_2(L34_2)
              for L37_2, L38_2 in L33_2, L34_2, L35_2, L36_2 do
                L39_2 = L32_2[L38_2]
                if nil ~= L39_2 then
                  L39_2 = L32_2[L38_2]
                  L31_2[L38_2] = L39_2
                end
              end
            end
          end
          L32_2 = #L0_2
          L32_2 = L32_2 + 1
          L0_2[L32_2] = L31_2
        end
      end
    end
  end
  return L0_2
end
function L12_1(A0_2)
  local L1_2, L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2
  L1_2 = nil
  L2_2 = 0
  L3_2 = false
  function L4_2(A0_3, A1_3)
    local L2_3, L3_3, L4_3, L5_3
    L2_3 = A0_2
    if L2_3 ~= A0_3 then
      L2_3 = A0_2
      L3_3 = L2_3
      L2_3 = L2_3.sub
      L4_3 = 1
      L5_3 = #A0_3
      L5_3 = L5_3 + 1
      L2_3 = L2_3(L3_3, L4_3, L5_3)
      L3_3 = A0_3
      L4_3 = "_"
      L3_3 = L3_3 .. L4_3
      if L2_3 ~= L3_3 then
        goto lbl_25
      end
    end
    L2_3 = #A0_3
    L3_3 = L2_2
    if L2_3 > L3_3 then
      L2_3 = A0_3
      L3_3 = #A0_3
      L3_2 = A1_3
      L2_2 = L3_3
      L1_2 = L2_3
    end
    ::lbl_25::
  end
  L5_2 = pairs
  L6_2 = L1_1
  L5_2, L6_2, L7_2, L8_2 = L5_2(L6_2)
  for L9_2 in L5_2, L6_2, L7_2, L8_2 do
    L10_2 = L4_2
    L11_2 = L9_2
    L12_2 = false
    L10_2(L11_2, L12_2)
  end
  L5_2 = pairs
  L6_2 = L2_1
  L5_2, L6_2, L7_2, L8_2 = L5_2(L6_2)
  for L9_2 in L5_2, L6_2, L7_2, L8_2 do
    L10_2 = L4_2
    L11_2 = L9_2
    L12_2 = true
    L10_2(L11_2, L12_2)
  end
  L5_2 = L1_2
  L6_2 = L3_2
  return L5_2, L6_2
end
L13_1 = {}
L13_1.png = true
L13_1.jpg = true
L13_1.jpeg = true
L13_1.webp = true
function L14_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2, L19_2, L20_2, L21_2, L22_2, L23_2
  L2_2 = {}
  L3_2 = L5_1
  L4_2 = A0_2
  L3_2 = L3_2(L4_2)
  L4_2 = {}
  L5_2 = ipairs
  L6_2 = L3_2
  L5_2, L6_2, L7_2, L8_2 = L5_2(L6_2)
  for L9_2, L10_2 in L5_2, L6_2, L7_2, L8_2 do
    L11_2 = L6_1
    L12_2 = L10_2
    L11_2, L12_2 = L11_2(L12_2)
    if "" ~= L11_2 then
      if "ydd" ~= L12_2 and "glb" ~= L12_2 then
        L13_2 = L13_1
        L13_2 = L13_2[L12_2]
        if not L13_2 then
          goto lbl_71
        end
      end
      L13_2 = "male"
      L14_2 = L11_2
      L16_2 = L11_2
      L15_2 = L11_2.match
      L17_2 = "^(.-)%^(.+)$"
      L15_2, L16_2 = L15_2(L16_2, L17_2)
      if L16_2 then
        L14_2 = L16_2
        L18_2 = L15_2
        L17_2 = L15_2.find
        L19_2 = "mp_f_"
        L20_2 = 1
        L21_2 = true
        L17_2 = L17_2(L18_2, L19_2, L20_2, L21_2)
        if L17_2 then
          L13_2 = "female"
        end
      end
      if "ydd" == L12_2 then
      end
      L17_2 = L4_2[L14_2]
      if not L17_2 then
        L18_2 = {}
        L18_2.gender = L13_2
        L19_2 = {}
        L18_2.exts = L19_2
        L17_2 = L18_2
        L4_2[L14_2] = L17_2
      end
      L18_2 = L17_2.exts
      L19_2 = "%s/%s"
      L20_2 = L19_2
      L19_2 = L19_2.format
      L21_2 = A0_2
      L22_2 = L10_2
      L19_2 = L19_2(L20_2, L21_2, L22_2)
      L18_2[L12_2] = L19_2
      if L16_2 then
        L19_2 = L15_2
        L18_2 = L15_2.find
        L20_2 = "mp_f_"
        L21_2 = 1
        L22_2 = true
        L18_2 = L18_2(L19_2, L20_2, L21_2, L22_2)
        if L18_2 then
          L17_2.gender = "female"
        end
      end
    end
    ::lbl_71::
  end
  L5_2 = pairs
  L6_2 = L4_2
  L5_2, L6_2, L7_2, L8_2 = L5_2(L6_2)
  for L9_2, L10_2 in L5_2, L6_2, L7_2, L8_2 do
    L11_2 = L10_2.exts
    L11_2 = L11_2.ydd
    if not L11_2 then
      L11_2 = L10_2.exts
      L11_2 = L11_2.glb
      if not L11_2 then
        goto lbl_183
      end
    end
    L11_2 = L12_1
    L12_2 = L9_2
    L11_2, L12_2 = L11_2(L12_2)
    if L11_2 then
      L13_2 = A1_2 or L13_2
      if not A1_2 then
        L13_2 = L10_2.gender
      end
      L14_2 = L7_1
      L15_2 = L13_2
      L16_2 = L11_2
      L17_2 = L9_2
      L14_2, L15_2 = L14_2(L15_2, L16_2, L17_2)
      L16_2 = L10_2.exts
      L16_2 = L16_2.png
      if not L16_2 then
        L16_2 = L10_2.exts
        L16_2 = L16_2.jpg
        if not L16_2 then
          L16_2 = L10_2.exts
          L16_2 = L16_2.jpeg
          if not L16_2 then
            L16_2 = L10_2.exts
            L16_2 = L16_2.webp
          end
        end
      end
      L17_2 = #L2_2
      L17_2 = L17_2 + 1
      L18_2 = {}
      L19_2 = "%s_%s_%s"
      L20_2 = L19_2
      L19_2 = L19_2.format
      L21_2 = L13_2
      L22_2 = L11_2
      L23_2 = L9_2
      L19_2 = L19_2(L20_2, L21_2, L22_2, L23_2)
      L18_2.id = L19_2
      L19_2 = L8_1
      L20_2 = L9_2
      L19_2 = L19_2(L20_2)
      L18_2.name = L19_2
      L18_2.gender = L13_2
      L19_2 = L1_1
      L19_2 = L19_2[L11_2]
      if not L19_2 then
        L19_2 = L2_1
        L19_2 = L19_2[L11_2]
        if not L19_2 then
          L19_2 = 11
        end
      end
      L18_2.component = L19_2
      L18_2.componentKey = L11_2
      L19_2 = L12_2 or L19_2
      if not L12_2 then
        L19_2 = false
      end
      L18_2.isProp = L19_2
      L19_2 = L10_2.exts
      L19_2 = L19_2.glb
      if not L19_2 then
        L19_2 = nil
      end
      L18_2.glb = L19_2
      L19_2 = L16_2 or L19_2
      if not L16_2 then
        L19_2 = nil
      end
      L18_2.thumb = L19_2
      L19_2 = L16_2 or L19_2
      if not L16_2 then
        L19_2 = nil
      end
      L18_2.baseTexture = L19_2
      L18_2.txd = L14_2
      L18_2.txn = L15_2
      L19_2 = L10_2.exts
      L19_2 = L19_2.glb
      L19_2 = nil ~= L19_2
      L18_2.ready = L19_2
      L19_2 = L10_2.exts
      L19_2 = L19_2.glb
      if nil == L19_2 then
        L19_2 = L10_2.exts
        L19_2 = L19_2.ydd
      end
      L19_2 = nil ~= L19_2 or L19_2
      L18_2.needsConversion = L19_2
      L18_2.source = "flat"
      L2_2[L17_2] = L18_2
    end
    ::lbl_183::
  end
  return L2_2
end
function L15_1(A0_2)
  local L1_2, L2_2, L3_2
  L1_2 = LoadResourceFile
  L2_2 = L0_1
  L3_2 = A0_2
  L1_2 = L1_2(L2_2, L3_2)
  L2_2 = nil ~= L1_2 and "" ~= L1_2
  return L2_2
end
function L16_1(A0_2, A1_2, A2_2)
  local L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2, L19_2, L20_2, L21_2, L22_2, L23_2, L24_2, L25_2, L26_2, L27_2, L28_2, L29_2, L30_2
  L3_2 = {}
  L4_2 = Config
  L4_2 = L4_2.templates
  if L4_2 then
    L4_2 = Config
    L4_2 = L4_2.templates
    L4_2 = L4_2.probeMax
    if L4_2 then
      goto lbl_13
    end
  end
  L4_2 = 48
  ::lbl_13::
  if not A1_2 then
    A1_2 = "male"
  end
  L5_2 = 0
  L6_2 = L4_2
  L7_2 = 1
  for L8_2 = L5_2, L6_2, L7_2 do
    L9_2 = ipairs
    L10_2 = {}
    L11_2 = "_u"
    L12_2 = "_r"
    L10_2[1] = L11_2
    L10_2[2] = L12_2
    L9_2, L10_2, L11_2, L12_2 = L9_2(L10_2)
    for L13_2, L14_2 in L9_2, L10_2, L11_2, L12_2 do
      L15_2 = "%s_%03d%s"
      L16_2 = L15_2
      L15_2 = L15_2.format
      L17_2 = A2_2
      L18_2 = L8_2
      L19_2 = L14_2
      L15_2 = L15_2(L16_2, L17_2, L18_2, L19_2)
      L16_2 = "%s/%s.ydd"
      L17_2 = L16_2
      L16_2 = L16_2.format
      L18_2 = A0_2
      L19_2 = L15_2
      L16_2 = L16_2(L17_2, L18_2, L19_2)
      L17_2 = "%s/%s.glb"
      L18_2 = L17_2
      L17_2 = L17_2.format
      L19_2 = A0_2
      L20_2 = L15_2
      L17_2 = L17_2(L18_2, L19_2, L20_2)
      L18_2 = L15_1
      L19_2 = L16_2
      L18_2 = L18_2(L19_2)
      L19_2 = L15_1
      L20_2 = L17_2
      L19_2 = L19_2(L20_2)
      if L18_2 or L19_2 then
        L20_2 = "%s/%s.png"
        L21_2 = L20_2
        L20_2 = L20_2.format
        L22_2 = A0_2
        L23_2 = L15_2
        L20_2 = L20_2(L21_2, L22_2, L23_2)
        L21_2 = L15_1
        L22_2 = L20_2
        L21_2 = L21_2(L22_2)
        L21_2 = L20_2 or L21_2
        if not L21_2 or not L20_2 then
          L21_2 = nil
        end
        L22_2 = L7_1
        L23_2 = A1_2
        L24_2 = A2_2
        L25_2 = L15_2
        L22_2, L23_2 = L22_2(L23_2, L24_2, L25_2)
        L24_2 = #L3_2
        L24_2 = L24_2 + 1
        L25_2 = {}
        L26_2 = "%s_%s_%s"
        L27_2 = L26_2
        L26_2 = L26_2.format
        L28_2 = A1_2
        L29_2 = A2_2
        L30_2 = L15_2
        L26_2 = L26_2(L27_2, L28_2, L29_2, L30_2)
        L25_2.id = L26_2
        L26_2 = L8_1
        L27_2 = L15_2
        L26_2 = L26_2(L27_2)
        L25_2.name = L26_2
        L25_2.gender = A1_2
        L26_2 = L1_1
        L26_2 = L26_2[A2_2]
        if not L26_2 then
          L26_2 = 11
        end
        L25_2.component = L26_2
        L25_2.componentKey = A2_2
        L26_2 = L17_2 or L26_2
        if not L19_2 or not L17_2 then
          L26_2 = nil
        end
        L25_2.glb = L26_2
        L25_2.thumb = L21_2
        L25_2.baseTexture = L21_2
        L25_2.txd = L22_2
        L25_2.txn = L23_2
        L25_2.ready = L19_2
        L26_2 = L18_2 or L26_2
        if L19_2 or not L18_2 then
          L26_2 = false
        end
        L25_2.needsConversion = L26_2
        L25_2.source = "probe"
        L3_2[L24_2] = L25_2
      end
    end
  end
  return L3_2
end
function L17_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2
  L2_2 = {}
  L3_2 = pairs
  L4_2 = L1_1
  L3_2, L4_2, L5_2, L6_2 = L3_2(L4_2)
  for L7_2 in L3_2, L4_2, L5_2, L6_2 do
    L8_2 = ipairs
    L9_2 = L16_1
    L10_2 = A0_2
    L11_2 = A1_2
    L12_2 = L7_2
    L9_2, L10_2, L11_2, L12_2, L13_2, L14_2 = L9_2(L10_2, L11_2, L12_2)
    L8_2, L9_2, L10_2, L11_2 = L8_2(L9_2, L10_2, L11_2, L12_2, L13_2, L14_2)
    for L12_2, L13_2 in L8_2, L9_2, L10_2, L11_2 do
      L14_2 = #L2_2
      L14_2 = L14_2 + 1
      L2_2[L14_2] = L13_2
    end
  end
  return L2_2
end
function L18_1()
  local L0_2, L1_2, L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2
  L0_2 = Config
  L0_2 = L0_2.templates
  if L0_2 then
    L0_2 = Config
    L0_2 = L0_2.templates
    L0_2 = L0_2.dir
    if L0_2 then
      goto lbl_11
    end
  end
  L0_2 = "stream/models"
  ::lbl_11::
  L1_2 = L10_1
  L2_2 = "%s/models.json"
  L3_2 = L2_2
  L2_2 = L2_2.format
  L4_2 = L0_2
  L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2 = L2_2(L3_2, L4_2)
  L1_2 = L1_2(L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2)
  if not L1_2 then
    L2_2 = {}
    return L2_2
  end
  L2_2 = L1_2.templates
  if not L2_2 then
    L2_2 = L1_2.models
    if not L2_2 then
      L2_2 = {}
    end
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
      L10_2 = L9_2.glb
      if L10_2 then
        L10_2 = #L3_2
        L10_2 = L10_2 + 1
        L11_2 = {}
        L12_2 = tostring
        L13_2 = L9_2.id
        if not L13_2 then
          L13_2 = "manual_"
          L14_2 = L8_2
          L13_2 = L13_2 .. L14_2
        end
        L12_2 = L12_2(L13_2)
        L11_2.id = L12_2
        L12_2 = L9_2.name
        if not L12_2 then
          L12_2 = L9_2.id
          if not L12_2 then
            L12_2 = "Template "
            L13_2 = L8_2
            L12_2 = L12_2 .. L13_2
          end
        end
        L11_2.name = L12_2
        L12_2 = L9_2.gender
        if not L12_2 then
          L12_2 = "male"
        end
        L11_2.gender = L12_2
        L12_2 = L9_2.component
        if nil ~= L12_2 then
          L12_2 = tonumber
          L13_2 = L9_2.component
          L12_2 = L12_2(L13_2)
          if L12_2 then
            goto lbl_82
          end
        end
        L12_2 = 11
        ::lbl_82::
        L11_2.component = L12_2
        L12_2 = L9_2.componentKey
        if not L12_2 then
          L12_2 = "jbib"
        end
        L11_2.componentKey = L12_2
        L12_2 = L9_2.glb
        L11_2.glb = L12_2
        L12_2 = L9_2.thumb
        if not L12_2 then
          L12_2 = L9_2.baseTexture
          if not L12_2 then
            L12_2 = L9_2.base
          end
        end
        L11_2.thumb = L12_2
        L12_2 = L9_2.baseTexture
        if not L12_2 then
          L12_2 = L9_2.base
        end
        L11_2.baseTexture = L12_2
        L12_2 = L9_2.txd
        if not L12_2 then
          L12_2 = ""
        end
        L11_2.txd = L12_2
        L12_2 = L9_2.txn
        if not L12_2 then
          L12_2 = ""
        end
        L11_2.txn = L12_2
        L12_2 = L9_2.size
        if L12_2 then
          L12_2 = tonumber
          L13_2 = L9_2.size
          L12_2 = L12_2(L13_2)
          if L12_2 then
            goto lbl_122
          end
        end
        L12_2 = nil
        ::lbl_122::
        L11_2.size = L12_2
        L11_2.ready = true
        L11_2.needsConversion = false
        L11_2.source = "manifest"
        L3_2[L10_2] = L11_2
      end
    end
  end
  return L3_2
end
function L19_1()
  local L0_2, L1_2, L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2, L19_2, L20_2, L21_2, L22_2, L23_2
  L0_2 = {}
  L1_2 = {}
  function L2_2(A0_3)
    local L1_3, L2_3, L3_3, L4_3, L5_3, L6_3, L7_3, L8_3
    L1_3 = ipairs
    L2_3 = A0_3
    L1_3, L2_3, L3_3, L4_3 = L1_3(L2_3)
    for L5_3, L6_3 in L1_3, L2_3, L3_3, L4_3 do
      L8_3 = L6_3.id
      L7_3 = L1_2
      L7_3 = L7_3[L8_3]
      if not L7_3 then
        L8_3 = L6_3.id
        L7_3 = L1_2
        L7_3[L8_3] = true
        L7_3 = L0_2
        L7_3 = #L7_3
        L8_3 = L7_3 + 1
        L7_3 = L0_2
        L7_3[L8_3] = L6_3
      end
    end
  end
  L3_2 = Config
  L3_2 = L3_2.templates
  if L3_2 then
    L3_2 = Config
    L3_2 = L3_2.templates
    L3_2 = L3_2.autoScan
    if false ~= L3_2 then
      L3_2 = Config
      L3_2 = L3_2.templates
      if L3_2 then
        L3_2 = Config
        L3_2 = L3_2.templates
        L3_2 = L3_2.dir
        if L3_2 then
          goto lbl_25
        end
      end
      L3_2 = "stream/models"
      ::lbl_25::
      L4_2 = Config
      L4_2 = L4_2.templates
      if L4_2 then
        L4_2 = Config
        L4_2 = L4_2.templates
        L4_2 = L4_2.defaultGender
        if L4_2 then
          goto lbl_35
        end
      end
      L4_2 = "male"
      ::lbl_35::
      L5_2 = {}
      function L6_2(A0_3)
        local L1_3, L2_3, L3_3, L4_3, L5_3, L6_3, L7_3, L8_3
        L1_3 = ipairs
        L2_3 = A0_3
        L1_3, L2_3, L3_3, L4_3 = L1_3(L2_3)
        for L5_3, L6_3 in L1_3, L2_3, L3_3, L4_3 do
          L7_3 = L5_2
          L7_3 = #L7_3
          L8_3 = L7_3 + 1
          L7_3 = L5_2
          L7_3[L8_3] = L6_3
        end
      end
      L7_2 = L4_1
      if L7_2 then
        L7_2 = L6_2
        L8_2 = L11_1
        L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2, L19_2, L20_2, L21_2, L22_2, L23_2 = L8_2()
        L7_2(L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2, L19_2, L20_2, L21_2, L22_2, L23_2)
        L7_2 = L6_2
        L8_2 = L14_1
        L9_2 = L3_2
        L10_2 = nil
        L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2, L19_2, L20_2, L21_2, L22_2, L23_2 = L8_2(L9_2, L10_2)
        L7_2(L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2, L19_2, L20_2, L21_2, L22_2, L23_2)
        L7_2 = L6_2
        L8_2 = L14_1
        L9_2 = "stream"
        L10_2 = L4_2
        L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2, L19_2, L20_2, L21_2, L22_2, L23_2 = L8_2(L9_2, L10_2)
        L7_2(L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2, L19_2, L20_2, L21_2, L22_2, L23_2)
        L7_2 = L6_2
        L8_2 = L14_1
        L9_2 = "stream/male"
        L10_2 = "male"
        L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2, L19_2, L20_2, L21_2, L22_2, L23_2 = L8_2(L9_2, L10_2)
        L7_2(L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2, L19_2, L20_2, L21_2, L22_2, L23_2)
        L7_2 = L6_2
        L8_2 = L14_1
        L9_2 = "stream/female"
        L10_2 = "female"
        L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2, L19_2, L20_2, L21_2, L22_2, L23_2 = L8_2(L9_2, L10_2)
        L7_2(L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2, L19_2, L20_2, L21_2, L22_2, L23_2)
      end
      L7_2 = L2_2
      L8_2 = L5_2
      L7_2(L8_2)
      L7_2 = #L5_2
      if 0 == L7_2 then
        L7_2 = L4_1
        if L7_2 then
          L7_2 = Utils
          L7_2 = L7_2.Warn
          L8_2 = "directory scan returned nothing - probing standard filenames\226\128\166"
          L7_2(L8_2)
        else
          L7_2 = Utils
          L7_2 = L7_2.Warn
          L8_2 = "io.readdir unavailable - probing standard filenames. "
          L9_2 = "For non-standard .glb names, list them in stream/models/models.json."
          L8_2 = L8_2 .. L9_2
          L7_2(L8_2)
        end
        L7_2 = L2_2
        L8_2 = L17_1
        L9_2 = "stream"
        L10_2 = L4_2
        L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2, L19_2, L20_2, L21_2, L22_2, L23_2 = L8_2(L9_2, L10_2)
        L7_2(L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2, L19_2, L20_2, L21_2, L22_2, L23_2)
        L7_2 = L2_2
        L8_2 = L17_1
        L9_2 = "stream/male"
        L10_2 = "male"
        L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2, L19_2, L20_2, L21_2, L22_2, L23_2 = L8_2(L9_2, L10_2)
        L7_2(L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2, L19_2, L20_2, L21_2, L22_2, L23_2)
        L7_2 = L2_2
        L8_2 = L17_1
        L9_2 = "stream/female"
        L10_2 = "female"
        L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2, L19_2, L20_2, L21_2, L22_2, L23_2 = L8_2(L9_2, L10_2)
        L7_2(L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2, L19_2, L20_2, L21_2, L22_2, L23_2)
        L7_2 = L2_2
        L8_2 = L17_1
        L9_2 = L3_2
        L10_2 = L4_2
        L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2, L19_2, L20_2, L21_2, L22_2, L23_2 = L8_2(L9_2, L10_2)
        L7_2(L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2, L19_2, L20_2, L21_2, L22_2, L23_2)
        L7_2 = pairs
        L8_2 = L3_1
        L7_2, L8_2, L9_2, L10_2 = L7_2(L8_2)
        for L11_2 in L7_2, L8_2, L9_2, L10_2 do
          L12_2 = L2_2
          L13_2 = L17_1
          L14_2 = "stream/%s"
          L15_2 = L14_2
          L14_2 = L14_2.format
          L16_2 = L11_2
          L14_2 = L14_2(L15_2, L16_2)
          L15_2 = L11_2
          L13_2, L14_2, L15_2, L16_2, L17_2, L18_2, L19_2, L20_2, L21_2, L22_2, L23_2 = L13_2(L14_2, L15_2)
          L12_2(L13_2, L14_2, L15_2, L16_2, L17_2, L18_2, L19_2, L20_2, L21_2, L22_2, L23_2)
          L12_2 = pairs
          L13_2 = L1_1
          L12_2, L13_2, L14_2, L15_2 = L12_2(L13_2)
          for L16_2 in L12_2, L13_2, L14_2, L15_2 do
            L17_2 = L2_2
            L18_2 = L16_1
            L19_2 = "%s/%s/%s"
            L20_2 = L19_2
            L19_2 = L19_2.format
            L21_2 = L3_2
            L22_2 = L11_2
            L23_2 = L16_2
            L19_2 = L19_2(L20_2, L21_2, L22_2, L23_2)
            L20_2 = L11_2
            L21_2 = L16_2
            L18_2, L19_2, L20_2, L21_2, L22_2, L23_2 = L18_2(L19_2, L20_2, L21_2)
            L17_2(L18_2, L19_2, L20_2, L21_2, L22_2, L23_2)
          end
        end
      end
    end
  end
  L3_2 = L2_2
  L4_2 = L18_1
  L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2, L19_2, L20_2, L21_2, L22_2, L23_2 = L4_2()
  L3_2(L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2, L19_2, L20_2, L21_2, L22_2, L23_2)
  L3_2 = table
  L3_2 = L3_2.sort
  L4_2 = L0_2
  function L5_2(A0_3, A1_3)
    local L2_3, L3_3
    L2_3 = A0_3.gender
    L3_3 = A1_3.gender
    if L2_3 ~= L3_3 then
      L2_3 = A0_3.gender
      L3_3 = A1_3.gender
      L2_3 = L2_3 < L3_3
      return L2_3
    end
    L2_3 = A0_3.componentKey
    L3_3 = A1_3.componentKey
    if L2_3 ~= L3_3 then
      L2_3 = A0_3.componentKey
      L3_3 = A1_3.componentKey
      L2_3 = L2_3 < L3_3
      return L2_3
    end
    L2_3 = A0_3.name
    L3_3 = A1_3.name
    L2_3 = L2_3 < L3_3
    return L2_3
  end
  L3_2(L4_2, L5_2)
  return L0_2
end
function L20_1(A0_2)
  local L1_2, L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2
  if not A0_2 then
    L1_2 = L9_1
    if nil ~= L1_2 then
      goto lbl_34
    end
  end
  L1_2 = L19_1
  L1_2 = L1_2()
  L9_1 = L1_2
  L1_2 = 0
  L2_2 = 0
  L3_2 = ipairs
  L4_2 = L9_1
  L3_2, L4_2, L5_2, L6_2 = L3_2(L4_2)
  for L7_2, L8_2 in L3_2, L4_2, L5_2, L6_2 do
    L9_2 = L8_2.ready
    if L9_2 then
      L1_2 = L1_2 + 1
    else
      L2_2 = L2_2 + 1
    end
  end
  L3_2 = Utils
  L3_2 = L3_2.Log
  L4_2 = "template scan: %d ready, %d awaiting .glb conversion"
  L5_2 = L4_2
  L4_2 = L4_2.format
  L6_2 = L1_2
  L7_2 = L2_2
  L4_2, L5_2, L6_2, L7_2, L8_2, L9_2 = L4_2(L5_2, L6_2, L7_2)
  L3_2(L4_2, L5_2, L6_2, L7_2, L8_2, L9_2)
  ::lbl_34::
  L1_2 = L9_1
  return L1_2
end
L21_1 = Apex
L21_1 = L21_1.RegisterCallback
L22_1 = "templates:list"
function L23_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2
  L2_2 = A1_2
  L3_2 = L20_1
  L4_2 = false
  L3_2, L4_2 = L3_2(L4_2)
  L2_2(L3_2, L4_2)
end
L21_1(L22_1, L23_1)
L21_1 = Apex
L21_1 = L21_1.RegisterCallback
L22_1 = "templates:rescan"
function L23_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2
  L2_2 = A1_2
  L3_2 = L20_1
  L4_2 = true
  L3_2, L4_2 = L3_2(L4_2)
  L2_2(L3_2, L4_2)
end
L21_1(L22_1, L23_1)
L21_1 = 512
L22_1 = 26
function L23_1(A0_2)
  local L1_2, L2_2, L3_2, L4_2, L5_2, L6_2, L7_2
  L1_2 = type
  L2_2 = A0_2
  L1_2 = L1_2(L2_2)
  if "table" ~= L1_2 then
    L1_2 = nil
    return L1_2
  end
  L1_2 = tostring
  L2_2 = A0_2.id
  if not L2_2 then
    L2_2 = ""
  end
  L1_2 = L1_2(L2_2)
  L2_2 = L1_2
  L1_2 = L1_2.lower
  L1_2 = L1_2(L2_2)
  L2_2 = L1_2
  L1_2 = L1_2.match
  L3_2 = "^%a$"
  L1_2 = L1_2(L2_2, L3_2)
  L2_2 = tostring
  L3_2 = A0_2.txn
  if not L3_2 then
    L3_2 = ""
  end
  L2_2 = L2_2(L3_2)
  L3_2 = L2_2
  L2_2 = L2_2.match
  L4_2 = "^[%w_%-%.]+$"
  L2_2 = L2_2(L3_2, L4_2)
  if not L1_2 or not L2_2 then
    L3_2 = nil
    return L3_2
  end
  L3_2 = {}
  L3_2.id = L1_2
  L3_2.txn = L2_2
  L4_2 = type
  L5_2 = A0_2.png
  L4_2 = L4_2(L5_2)
  if "string" == L4_2 then
    L4_2 = A0_2.png
    L5_2 = L4_2
    L4_2 = L4_2.match
    L6_2 = "^[%w_%-%./]*$"
    L4_2 = L4_2(L5_2, L6_2)
    if L4_2 then
      goto lbl_50
    end
  end
  L4_2 = ""
  ::lbl_50::
  L3_2.png = L4_2
  L4_2 = type
  L5_2 = A0_2.res
  L4_2 = L4_2(L5_2)
  if "string" == L4_2 then
    L4_2 = A0_2.res
    L5_2 = L4_2
    L4_2 = L4_2.match
    L6_2 = "^[%w_%-]+$"
    L4_2 = L4_2(L5_2, L6_2)
    if L4_2 then
      goto lbl_63
    end
  end
  L4_2 = nil
  ::lbl_63::
  L3_2.res = L4_2
  L4_2 = tonumber
  L5_2 = A0_2.w
  L4_2 = L4_2(L5_2)
  if not L4_2 then
    L4_2 = nil
  end
  L3_2.w = L4_2
  L4_2 = tonumber
  L5_2 = A0_2.h
  L4_2 = L4_2(L5_2)
  if not L4_2 then
    L4_2 = nil
  end
  L3_2.h = L4_2
  L4_2 = A0_2.synthetic
  if L4_2 then
    L4_2 = true
    if L4_2 then
      goto lbl_85
    end
  end
  L4_2 = nil
  ::lbl_85::
  L3_2.synthetic = L4_2
  L4_2 = type
  L5_2 = A0_2.label
  L4_2 = L4_2(L5_2)
  if "string" == L4_2 then
    L4_2 = A0_2.label
    L5_2 = L4_2
    L4_2 = L4_2.sub
    L6_2 = 1
    L7_2 = 64
    L4_2 = L4_2(L5_2, L6_2, L7_2)
    if L4_2 then
      goto lbl_99
    end
  end
  L4_2 = nil
  ::lbl_99::
  L3_2.label = L4_2
  return L3_2
end
function L24_1(A0_2)
  local L1_2, L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2
  L1_2 = type
  L2_2 = A0_2
  L1_2 = L1_2(L2_2)
  if "table" == L1_2 then
    L1_2 = type
    L2_2 = A0_2.id
    L1_2 = L1_2(L2_2)
    if "string" == L1_2 then
      L1_2 = A0_2.id
      if "" ~= L1_2 then
        goto lbl_16
      end
    end
  end
  L1_2 = nil
  do return L1_2 end
  ::lbl_16::
  L1_2 = {}
  L2_2 = ipairs
  L3_2 = A0_2.textures
  if not L3_2 then
    L3_2 = {}
  end
  L2_2, L3_2, L4_2, L5_2 = L2_2(L3_2)
  for L6_2, L7_2 in L2_2, L3_2, L4_2, L5_2 do
    L8_2 = #L1_2
    L9_2 = L22_1
    if L8_2 >= L9_2 then
      break
    end
    L8_2 = L23_1
    L9_2 = L7_2
    L8_2 = L8_2(L9_2)
    if L8_2 then
      L9_2 = #L1_2
      L9_2 = L9_2 + 1
      L1_2[L9_2] = L8_2
    end
  end
  L2_2 = {}
  L3_2 = A0_2.id
  L4_2 = L3_2
  L3_2 = L3_2.sub
  L5_2 = 1
  L6_2 = 128
  L3_2 = L3_2(L4_2, L5_2, L6_2)
  L2_2.id = L3_2
  L3_2 = type
  L4_2 = A0_2.name
  L3_2 = L3_2(L4_2)
  if "string" == L3_2 then
    L3_2 = A0_2.name
    L4_2 = L3_2
    L3_2 = L3_2.sub
    L5_2 = 1
    L6_2 = 96
    L3_2 = L3_2(L4_2, L5_2, L6_2)
    if L3_2 then
      goto lbl_63
    end
  end
  L3_2 = A0_2.id
  ::lbl_63::
  L2_2.name = L3_2
  L3_2 = A0_2.gender
  if "female" == L3_2 then
    L3_2 = "female"
    if L3_2 then
      goto lbl_71
    end
  end
  L3_2 = "male"
  ::lbl_71::
  L2_2.gender = L3_2
  L3_2 = tonumber
  L4_2 = A0_2.component
  L3_2 = L3_2(L4_2)
  if not L3_2 then
    L3_2 = 11
  end
  L2_2.component = L3_2
  L3_2 = type
  L4_2 = A0_2.componentKey
  L3_2 = L3_2(L4_2)
  if "string" == L3_2 then
    L3_2 = A0_2.componentKey
    L4_2 = L3_2
    L3_2 = L3_2.sub
    L5_2 = 1
    L6_2 = 16
    L3_2 = L3_2(L4_2, L5_2, L6_2)
    if L3_2 then
      goto lbl_92
    end
  end
  L3_2 = "jbib"
  ::lbl_92::
  L2_2.componentKey = L3_2
  L3_2 = type
  L4_2 = A0_2.res
  L3_2 = L3_2(L4_2)
  if "string" == L3_2 then
    L3_2 = A0_2.res
    L4_2 = L3_2
    L3_2 = L3_2.match
    L5_2 = "^[%w_%-]+$"
    L3_2 = L3_2(L4_2, L5_2)
    if L3_2 then
      goto lbl_105
    end
  end
  L3_2 = nil
  ::lbl_105::
  L2_2.res = L3_2
  L3_2 = type
  L4_2 = A0_2.glb
  L3_2 = L3_2(L4_2)
  if "string" == L3_2 then
    L3_2 = A0_2.glb
    if L3_2 then
      goto lbl_115
    end
  end
  L3_2 = ""
  ::lbl_115::
  L2_2.glb = L3_2
  L3_2 = type
  L4_2 = A0_2.thumb
  L3_2 = L3_2(L4_2)
  if "string" == L3_2 then
    L3_2 = A0_2.thumb
    if L3_2 then
      goto lbl_125
    end
  end
  L3_2 = nil
  ::lbl_125::
  L2_2.thumb = L3_2
  L3_2 = type
  L4_2 = A0_2.baseTexture
  L3_2 = L3_2(L4_2)
  if "string" == L3_2 then
    L3_2 = A0_2.baseTexture
    if L3_2 then
      goto lbl_135
    end
  end
  L3_2 = nil
  ::lbl_135::
  L2_2.baseTexture = L3_2
  L3_2 = type
  L4_2 = A0_2.txd
  L3_2 = L3_2(L4_2)
  if "string" == L3_2 then
    L3_2 = A0_2.txd
    if L3_2 then
      goto lbl_145
    end
  end
  L3_2 = ""
  ::lbl_145::
  L2_2.txd = L3_2
  L3_2 = type
  L4_2 = A0_2.txn
  L3_2 = L3_2(L4_2)
  if "string" == L3_2 then
    L3_2 = A0_2.txn
    if L3_2 then
      goto lbl_155
    end
  end
  L3_2 = ""
  ::lbl_155::
  L2_2.txn = L3_2
  L2_2.textures = L1_2
  return L2_2
end
L25_1 = Apex
L25_1 = L25_1.RegisterCallback
L26_1 = "templates:save"
function L27_1(A0_2, A1_2, A2_2)
  local L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2
  L3_2 = Apex
  L3_2 = L3_2.IsAllowed
  L4_2 = A0_2
  L3_2 = L3_2(L4_2)
  if not L3_2 then
    L3_2 = Utils
    L3_2 = L3_2.Warn
    L4_2 = "templates:save denied for %s"
    L5_2 = L4_2
    L4_2 = L4_2.format
    L6_2 = tostring
    L7_2 = A0_2
    L6_2, L7_2, L8_2, L9_2, L10_2, L11_2 = L6_2(L7_2)
    L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2 = L4_2(L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2)
    L3_2(L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2)
    L3_2 = A1_2
    L4_2 = false
    return L3_2(L4_2)
  end
  L3_2 = type
  L4_2 = A2_2
  L3_2 = L3_2(L4_2)
  if "table" ~= L3_2 then
    L3_2 = A1_2
    L4_2 = false
    return L3_2(L4_2)
  end
  L3_2 = {}
  L4_2 = ipairs
  L5_2 = A2_2
  L4_2, L5_2, L6_2, L7_2 = L4_2(L5_2)
  for L8_2, L9_2 in L4_2, L5_2, L6_2, L7_2 do
    L10_2 = #L3_2
    L11_2 = L21_1
    if L10_2 >= L11_2 then
      break
    end
    L10_2 = L24_1
    L11_2 = L9_2
    L10_2 = L10_2(L11_2)
    if L10_2 then
      L11_2 = #L3_2
      L11_2 = L11_2 + 1
      L3_2[L11_2] = L10_2
    end
  end
  L4_2 = #L3_2
  if 0 == L4_2 then
    L4_2 = Utils
    L4_2 = L4_2.Warn
    L5_2 = "templates:save rejected - payload contained no valid templates"
    L4_2(L5_2)
    L4_2 = A1_2
    L5_2 = false
    return L4_2(L5_2)
  end
  L4_2 = json
  L4_2 = L4_2.encode
  L5_2 = {}
  L5_2._comment = "Auto-updated by tools/convert.js and the in-game texture manager. Safe to edit by hand."
  L5_2.templates = L3_2
  L4_2 = L4_2(L5_2)
  L5_2 = SaveResourceFile
  L6_2 = L0_1
  L7_2 = "templates.json"
  L8_2 = L4_2
  L9_2 = #L4_2
  L5_2 = L5_2(L6_2, L7_2, L8_2, L9_2)
  if L5_2 then
    L6_2 = nil
    L9_1 = L6_2
    L6_2 = Utils
    L6_2 = L6_2.Log
    L7_2 = "templates.json rewritten by %s (%d templates)"
    L8_2 = L7_2
    L7_2 = L7_2.format
    L9_2 = tostring
    L10_2 = A0_2
    L9_2 = L9_2(L10_2)
    L10_2 = #L3_2
    L7_2, L8_2, L9_2, L10_2, L11_2 = L7_2(L8_2, L9_2, L10_2)
    L6_2(L7_2, L8_2, L9_2, L10_2, L11_2)
  else
    L6_2 = Utils
    L6_2 = L6_2.Warn
    L7_2 = "templates.json could not be written - check file permissions"
    L6_2(L7_2)
  end
  L6_2 = A1_2
  if L5_2 then
    L7_2 = true
    if L7_2 then
      goto lbl_101
    end
  end
  L7_2 = false
  ::lbl_101::
  L6_2(L7_2)
end
L25_1(L26_1, L27_1)
L25_1 = CreateThread
function L26_1()
  local L0_2, L1_2
  L0_2 = Wait
  L1_2 = 1500
  L0_2(L1_2)
  L0_2 = L20_1
  L1_2 = true
  L0_2(L1_2)
end
L25_1(L26_1)
L25_1 = RegisterCommand
L26_1 = "clothingtemplates"
function L27_1(A0_2)
  local L1_2, L2_2, L3_2, L4_2, L5_2, L6_2
  if 0 ~= A0_2 then
    L1_2 = Apex
    L1_2 = L1_2.IsAllowed
    L2_2 = A0_2
    L1_2 = L1_2(L2_2)
    if not L1_2 then
      return
    end
  end
  L1_2 = L20_1
  L2_2 = true
  L1_2 = L1_2(L2_2)
  L2_2 = "[apex_clothing] rescanned templates: %d found"
  L3_2 = L2_2
  L2_2 = L2_2.format
  L4_2 = #L1_2
  L2_2 = L2_2(L3_2, L4_2)
  if 0 == A0_2 then
    L3_2 = print
    L4_2 = L2_2
    L3_2(L4_2)
  else
    L3_2 = Apex
    L3_2 = L3_2.Notify
    L4_2 = A0_2
    L5_2 = L2_2
    L6_2 = "info"
    L3_2(L4_2, L5_2, L6_2)
  end
end
L28_1 = true
L25_1(L26_1, L27_1, L28_1)
