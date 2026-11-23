local L0_1, L1_1, L2_1, L3_1, L4_1, L5_1, L6_1, L7_1, L8_1, L9_1, L10_1, L11_1, L12_1, L13_1, L14_1, L15_1, L16_1, L17_1, L18_1, L19_1, L20_1, L21_1, L22_1, L23_1, L24_1, L25_1, L26_1, L27_1, L28_1, L29_1, L30_1, L31_1, L32_1, L33_1, L34_1, L35_1, L36_1, L37_1, L38_1
L0_1 = Preview
if not L0_1 then
  L0_1 = {}
end
Preview = L0_1
L0_1 = "apex_clothing_rt"
L1_1 = L0_1
L2_1 = "apex_clothing_tex"
L3_1 = GetCurrentResourceName
L3_1 = L3_1()
L4_1 = "nui://%s/build/html/dui.html?resourceName=%s"
L5_1 = L4_1
L4_1 = L4_1.format
L6_1 = L3_1
L7_1 = L3_1
L4_1 = L4_1(L5_1, L6_1, L7_1)
L5_1 = nil
L6_1 = false
L7_1 = 0
L8_1 = false
L9_1 = false
L10_1 = nil
L11_1 = nil
L12_1 = nil
L13_1 = false
L14_1 = nil
L15_1 = false
L16_1 = 0
L17_1 = 0
L18_1 = false
L19_1 = L2_1
L20_1 = {}
L21_1 = nil
L22_1 = false
L23_1 = {}
L24_1 = ipairs
L25_1 = Config
L25_1 = L25_1.components
if not L25_1 then
  L25_1 = {}
end
L24_1, L25_1, L26_1, L27_1 = L24_1(L25_1)
for L28_1, L29_1 in L24_1, L25_1, L26_1, L27_1 do
  L30_1 = L29_1.id
  L31_1 = L29_1.key
  L23_1[L30_1] = L31_1
end
L24_1 = {}
L25_1 = ipairs
L26_1 = Config
L26_1 = L26_1.props
if not L26_1 then
  L26_1 = {}
end
L25_1, L26_1, L27_1, L28_1 = L25_1(L26_1)
for L29_1, L30_1 in L25_1, L26_1, L27_1, L28_1 do
  L31_1 = L30_1.id
  L32_1 = L30_1.key
  L24_1[L31_1] = L32_1
end
L25_1 = Preview
function L26_1(A0_2, A1_2, A2_2, A3_2, A4_2, A5_2)
  local L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2, L19_2, L20_2, L21_2, L22_2, L23_2, L24_2, L25_2, L26_2, L27_2, L28_2, L29_2, L30_2
  L6_2 = {}
  L7_2 = {}
  function L8_2(A0_3, A1_3)
    local L2_3, L3_3, L4_3, L5_3
    L2_3 = A0_3
    L3_3 = "|"
    L4_3 = A1_3
    L2_3 = L2_3 .. L3_3 .. L4_3
    L3_3 = L7_2
    L3_3 = L3_3[L2_3]
    if not L3_3 then
      L3_3 = L7_2
      L3_3[L2_3] = true
      L3_3 = L6_2
      L3_3 = #L3_3
      L4_3 = L3_3 + 1
      L3_3 = L6_2
      L5_3 = {}
      L5_3.txd = A0_3
      L5_3.txn = A1_3
      L3_3[L4_3] = L5_3
    end
  end
  L9_2 = "%s|%s|%d|%d|%d"
  L10_2 = L9_2
  L9_2 = L9_2.format
  L11_2 = A1_2
  L12_2 = A2_2
  L13_2 = A3_2
  L14_2 = A4_2
  L15_2 = A5_2
  L9_2 = L9_2(L10_2, L11_2, L12_2, L13_2, L14_2, L15_2)
  L10_2 = ipairs
  L11_2 = Config
  L11_2 = L11_2.textureNameOverrides
  if not L11_2 then
    L11_2 = {}
  end
  L11_2 = L11_2[L9_2]
  if not L11_2 then
    L11_2 = {}
  end
  L10_2, L11_2, L12_2, L13_2 = L10_2(L11_2)
  for L14_2, L15_2 in L10_2, L11_2, L12_2, L13_2 do
    L16_2 = L15_2.txd
    if L16_2 then
      L16_2 = L15_2.txn
      if L16_2 then
        L16_2 = L8_2
        L17_2 = L15_2.txd
        L18_2 = L15_2.txn
        L16_2(L17_2, L18_2)
      end
    end
  end
  if nil == A4_2 or A4_2 < 0 or nil == A5_2 or A5_2 < 0 then
    return L6_2
  end
  L10_2 = string
  L10_2 = L10_2.char
  L11_2 = math
  L11_2 = L11_2.min
  L12_2 = A5_2
  L13_2 = 25
  L11_2 = L11_2(L12_2, L13_2)
  L11_2 = 97 + L11_2
  L10_2 = L10_2(L11_2)
  if "component" == A2_2 then
    L11_2 = L23_1
    L11_2 = L11_2[A3_2]
    if not L11_2 then
      return L6_2
    end
    L12_2 = ""
    L13_2 = A4_2
    L14_2 = pcall
    L15_2 = GetPedDrawableVariationCollectionName
    L16_2 = A0_2
    L17_2 = A3_2
    L14_2, L15_2 = L14_2(L15_2, L16_2, L17_2)
    L16_2 = pcall
    L17_2 = _ENV
    L18_2 = "GetPedDrawableVariationCollectionLocalIndex"
    L17_2 = L17_2[L18_2]
    L18_2 = A0_2
    L19_2 = A3_2
    L16_2, L17_2 = L16_2(L17_2, L18_2, L19_2)
    if L14_2 and L16_2 then
      L18_2 = type
      L19_2 = L15_2
      L18_2 = L18_2(L19_2)
      if "string" == L18_2 then
        L18_2 = type
        L19_2 = L17_2
        L18_2 = L18_2(L19_2)
        if "number" == L18_2 and L17_2 >= 0 then
          L18_2 = L15_2
          L13_2 = L17_2
          L12_2 = L18_2
        end
      end
    end
    L18_2 = A1_2
    if "" ~= L12_2 then
      L19_2 = "_"
      L20_2 = L12_2
      L19_2 = L19_2 .. L20_2
      if L19_2 then
        goto lbl_109
      end
    end
    L19_2 = ""
    ::lbl_109::
    L18_2 = L18_2 .. L19_2
    L19_2 = ipairs
    L20_2 = Config
    L20_2 = L20_2.preview
    L20_2 = L20_2.raceSuffixes
    if not L20_2 then
      L20_2 = {}
      L21_2 = "uni"
      L20_2[1] = L21_2
    end
    L19_2, L20_2, L21_2, L22_2 = L19_2(L20_2)
    for L23_2, L24_2 in L19_2, L20_2, L21_2, L22_2 do
      L25_2 = "%s_diff_%03d_%s_%s"
      L26_2 = L25_2
      L25_2 = L25_2.format
      L27_2 = L11_2
      L28_2 = L13_2
      L29_2 = L10_2
      L30_2 = L24_2
      L25_2 = L25_2(L26_2, L27_2, L28_2, L29_2, L30_2)
      L26_2 = L8_2
      L27_2 = L18_2
      L28_2 = "/"
      L29_2 = L25_2
      L27_2 = L27_2 .. L28_2 .. L29_2
      L28_2 = L25_2
      L26_2(L27_2, L28_2)
    end
  else
    L11_2 = L24_1
    L11_2 = L11_2[A3_2]
    if not L11_2 then
      return L6_2
    end
    L12_2 = ""
    L13_2 = A4_2
    L14_2 = pcall
    L15_2 = GetPedCollectionNameFromProp
    L16_2 = A0_2
    L17_2 = A3_2
    L18_2 = A4_2
    L14_2, L15_2 = L14_2(L15_2, L16_2, L17_2, L18_2)
    L16_2 = pcall
    L17_2 = GetPedCollectionLocalIndexFromProp
    L18_2 = A0_2
    L19_2 = A3_2
    L20_2 = A4_2
    L16_2, L17_2 = L16_2(L17_2, L18_2, L19_2, L20_2)
    if L14_2 and L16_2 then
      L18_2 = type
      L19_2 = L15_2
      L18_2 = L18_2(L19_2)
      if "string" == L18_2 then
        L18_2 = type
        L19_2 = L17_2
        L18_2 = L18_2(L19_2)
        if "number" == L18_2 and L17_2 >= 0 then
          L18_2 = L15_2
          L13_2 = L17_2
          L12_2 = L18_2
        end
      end
    end
    L18_2 = A1_2
    L19_2 = "_p"
    if "" ~= L12_2 then
      L20_2 = "_"
      L21_2 = L12_2
      L20_2 = L20_2 .. L21_2
      if L20_2 then
        goto lbl_188
      end
    end
    L20_2 = ""
    ::lbl_188::
    L18_2 = L18_2 .. L19_2 .. L20_2
    L19_2 = "%s_diff_%03d_%s"
    L20_2 = L19_2
    L19_2 = L19_2.format
    L21_2 = L11_2
    L22_2 = L13_2
    L23_2 = L10_2
    L19_2 = L19_2(L20_2, L21_2, L22_2, L23_2)
    L20_2 = L8_2
    L21_2 = L18_2
    L22_2 = "/"
    L23_2 = L19_2
    L21_2 = L21_2 .. L22_2 .. L23_2
    L22_2 = L19_2
    L20_2(L21_2, L22_2)
  end
  return L6_2
end
L25_1.ResolveCandidates = L26_1
L25_1 = nil
function L26_1()
  local L0_2, L1_2, L2_2, L3_2, L4_2, L5_2
  L0_2 = L8_1
  if L0_2 then
    L0_2 = L25_1
    return L0_2
  end
  function L0_2(A0_3)
    local L1_3, L2_3
    L1_3 = CreateRuntimeTxd
    L2_3 = A0_3
    L1_3 = L1_3(L2_3)
    if 0 == L1_3 then
      L2_3 = nil
      return L2_3
    end
    return L1_3
  end
  L1_2 = L0_2
  L2_2 = L1_1
  L1_2 = L1_2(L2_2)
  L25_1 = L1_2
  L1_2 = 0
  while true do
    L2_2 = L25_1
    if not (not L2_2 and L1_2 < 64) then
      break
    end
    L1_2 = L1_2 + 1
    L2_2 = "%s_%d"
    L3_2 = L2_2
    L2_2 = L2_2.format
    L4_2 = L0_1
    L5_2 = L1_2
    L2_2 = L2_2(L3_2, L4_2, L5_2)
    L1_1 = L2_2
    L2_2 = L0_2
    L3_2 = L1_1
    L2_2 = L2_2(L3_2)
    L25_1 = L2_2
  end
  L2_2 = L25_1
  if L2_2 then
    L2_2 = true
    L8_1 = L2_2
  end
  L2_2 = L25_1
  return L2_2
end
function L27_1()
  local L0_2, L1_2
  L0_2 = L5_1
  if L0_2 then
    L0_2 = DestroyDui
    L1_2 = L5_1
    L0_2(L1_2)
    L0_2 = nil
    L5_1 = L0_2
  end
  L0_2 = false
  L6_1 = L0_2
  L0_2 = false
  L9_1 = L0_2
  L0_2 = 0
  L7_1 = L0_2
end
function L28_1(A0_2)
  local L1_2, L2_2, L3_2, L4_2, L5_2
  if not A0_2 then
    L1_2 = Config
    L1_2 = L1_2.canvas
    L1_2 = L1_2.defaultSize
    A0_2 = L1_2 or A0_2
    if not L1_2 then
      A0_2 = 1024
    end
  end
  L1_2 = L5_1
  if L1_2 then
    L1_2 = L7_1
    if L1_2 == A0_2 then
      return
    end
  end
  L1_2 = L5_1
  if L1_2 then
    L1_2 = L27_1
    L1_2()
  end
  L1_2 = CreateDui
  L2_2 = L4_1
  L3_2 = A0_2
  L4_2 = A0_2
  L1_2 = L1_2(L2_2, L3_2, L4_2)
  L5_1 = L1_2
  L7_1 = A0_2
  L1_2 = false
  L6_1 = L1_2
  L1_2 = GetGameTimer
  L1_2 = L1_2()
  L14_1 = L1_2
  L1_2 = CreateRuntimeTextureFromDuiHandle
  L2_2 = L26_1
  L2_2 = L2_2()
  L3_2 = L2_1
  L4_2 = GetDuiHandle
  L5_2 = L5_1
  L4_2, L5_2 = L4_2(L5_2)
  L1_2(L2_2, L3_2, L4_2, L5_2)
  L1_2 = true
  L9_1 = L1_2
  L1_2 = Utils
  L1_2 = L1_2.Log
  L2_2 = "DUI created at %dx%d"
  L3_2 = L2_2
  L2_2 = L2_2.format
  L4_2 = A0_2
  L5_2 = A0_2
  L2_2, L3_2, L4_2, L5_2 = L2_2(L3_2, L4_2, L5_2)
  L1_2(L2_2, L3_2, L4_2, L5_2)
end
function L29_1()
  local L0_2, L1_2, L2_2, L3_2, L4_2
  L0_2 = L5_1
  if L0_2 then
    L0_2 = L12_1
    if L0_2 then
      L0_2 = SendDuiMessage
      L1_2 = L5_1
      L2_2 = json
      L2_2 = L2_2.encode
      L3_2 = {}
      L3_2.action = "frame"
      L4_2 = L12_1
      L3_2.frame = L4_2
      L2_2, L3_2, L4_2 = L2_2(L3_2)
      L0_2(L1_2, L2_2, L3_2, L4_2)
    end
  end
end
function L30_1()
  local L0_2, L1_2
  L0_2 = L13_1
  if L0_2 then
    return
  end
  L0_2 = true
  L13_1 = L0_2
  L0_2 = CreateThread
  function L1_2()
    local L0_3, L1_3, L2_3, L3_3, L4_3, L5_3, L6_3
    L0_3 = Config
    L0_3 = L0_3.preview
    if L0_3 then
      L0_3 = Config
      L0_3 = L0_3.preview
      L0_3 = L0_3.duiTimeoutMs
      if L0_3 then
        goto lbl_11
      end
    end
    L0_3 = 6000
    ::lbl_11::
    while true do
      L1_3 = L13_1
      if not L1_3 then
        break
      end
      L1_3 = L5_1
      if not L1_3 then
        break
      end
      L1_3 = L6_1
      if L1_3 then
        break
      end
      L1_3 = L29_1
      L1_3()
      L1_3 = L11_1
      if not L1_3 then
        L1_3 = L14_1
      end
      L2_3 = L11_1
      if L2_3 then
        L2_3 = L14_1
        if L2_3 then
          L2_3 = math
          L2_3 = L2_3.max
          L3_3 = L11_1
          L4_3 = L14_1
          L2_3 = L2_3(L3_3, L4_3)
          L1_3 = L2_3
        end
      end
      if L1_3 then
        L2_3 = GetGameTimer
        L2_3 = L2_3()
        L2_3 = L2_3 - L1_3
        if L0_3 < L2_3 then
          L2_3 = Config
          L2_3 = L2_3.preview
          if L2_3 then
            L2_3 = Config
            L2_3 = L2_3.preview
            L2_3 = L2_3.mode
            if L2_3 then
              goto lbl_56
            end
          end
          L2_3 = "auto"
          ::lbl_56::
          if "auto" == L2_3 then
            L3_3 = L10_1
            if "image" ~= L3_3 then
              L3_3 = "image"
              L10_1 = L3_3
              L3_3 = true
              L15_1 = L3_3
              L3_3 = Utils
              L3_3 = L3_3.Warn
              L4_3 = "DUI has not reported ready after %d ms - falling back to image preview mode "
              L5_3 = "(it switches back by itself if the page answers later)"
              L4_3 = L4_3 .. L5_3
              L5_3 = L4_3
              L4_3 = L4_3.format
              L6_3 = L0_3
              L4_3, L5_3, L6_3 = L4_3(L5_3, L6_3)
              L3_3(L4_3, L5_3, L6_3)
            end
          end
          break
        end
      end
      L2_3 = Wait
      L3_3 = 300
      L2_3(L3_3)
    end
    L1_3 = false
    L13_1 = L1_3
  end
  L0_2(L1_2)
end
function L31_1()
  local L0_2, L1_2, L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2
  L0_2 = ipairs
  L1_2 = L20_1
  L0_2, L1_2, L2_2, L3_2 = L0_2(L1_2)
  for L4_2, L5_2 in L0_2, L1_2, L2_2, L3_2 do
    L6_2 = RemoveReplaceTexture
    L7_2 = L5_2.txd
    L8_2 = L5_2.txn
    L6_2(L7_2, L8_2)
  end
  L0_2 = {}
  L20_1 = L0_2
end
function L32_1(A0_2)
  local L1_2, L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2
  L1_2 = L26_1
  L1_2()
  L1_2 = ipairs
  L2_2 = A0_2
  L1_2, L2_2, L3_2, L4_2 = L1_2(L2_2)
  for L5_2, L6_2 in L1_2, L2_2, L3_2, L4_2 do
    L7_2 = AddReplaceTexture
    L8_2 = L6_2.txd
    L9_2 = L6_2.txn
    L10_2 = L1_1
    L11_2 = L19_1
    L7_2(L8_2, L9_2, L10_2, L11_2)
    L7_2 = L20_1
    L7_2 = #L7_2
    L8_2 = L7_2 + 1
    L7_2 = L20_1
    L9_2 = {}
    L10_2 = L6_2.txd
    L9_2.txd = L10_2
    L10_2 = L6_2.txn
    L9_2.txn = L10_2
    L7_2[L8_2] = L9_2
  end
end
function L33_1()
  local L0_2, L1_2, L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2
  L0_2 = L20_1
  L1_2 = {}
  L20_1 = L1_2
  L1_2 = ipairs
  L2_2 = L0_2
  L1_2, L2_2, L3_2, L4_2 = L1_2(L2_2)
  for L5_2, L6_2 in L1_2, L2_2, L3_2, L4_2 do
    L7_2 = AddReplaceTexture
    L8_2 = L6_2.txd
    L9_2 = L6_2.txn
    L10_2 = L1_1
    L11_2 = L19_1
    L7_2(L8_2, L9_2, L10_2, L11_2)
    L7_2 = L20_1
    L7_2 = #L7_2
    L8_2 = L7_2 + 1
    L7_2 = L20_1
    L7_2[L8_2] = L6_2
  end
end
function L34_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2
  L2_2 = {}
  if A0_2 then
    L3_2 = true
    if L3_2 then
      goto lbl_9
    end
  end
  L3_2 = false
  ::lbl_9::
  L2_2.active = L3_2
  if A0_2 then
    L3_2 = L20_1
    L3_2 = L3_2[1]
    if L3_2 then
      L3_2 = L20_1
      L3_2 = L3_2[1]
      L3_2 = L3_2.txd
      L2_2.txd = L3_2
      L3_2 = L20_1
      L3_2 = L3_2[1]
      L3_2 = L3_2.txn
      L2_2.txn = L3_2
      L3_2 = L20_1
      L3_2 = #L3_2
      L2_2.candidates = L3_2
    end
  end
  if A1_2 then
    L3_2 = pairs
    L4_2 = A1_2
    L3_2, L4_2, L5_2, L6_2 = L3_2(L4_2)
    for L7_2, L8_2 in L3_2, L4_2, L5_2, L6_2 do
      L2_2[L7_2] = L8_2
    end
  end
  L3_2 = Apex
  L3_2 = L3_2.SendUI
  L4_2 = "previewStatus"
  L5_2 = L2_2
  L3_2(L4_2, L5_2)
end
function L35_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2
  L2_2 = PlayerPedId
  L2_2 = L2_2()
  L3_2 = Apex
  L3_2 = L3_2.GetPedModelName
  L4_2 = L2_2
  L3_2 = L3_2(L4_2)
  if not L3_2 then
    L4_2 = L22_1
    if not L4_2 then
      L4_2 = true
      L22_1 = L4_2
      L4_2 = Apex
      L4_2 = L4_2.Notify
      L5_2 = L
      L6_2 = "err_unknown_model"
      L7_2 = "Unrecognized ped model - live preview and export are limited."
      L5_2 = L5_2(L6_2, L7_2)
      L6_2 = "error"
      L4_2(L5_2, L6_2)
    end
    L4_2 = false
    L5_2 = nil
    return L4_2, L5_2
  end
  L4_2 = nil
  L5_2 = nil
  if "component" == A0_2 then
    L6_2 = GetPedDrawableVariation
    L7_2 = L2_2
    L8_2 = A1_2
    L6_2 = L6_2(L7_2, L8_2)
    L4_2 = L6_2
    L6_2 = GetPedTextureVariation
    L7_2 = L2_2
    L8_2 = A1_2
    L6_2 = L6_2(L7_2, L8_2)
    L5_2 = L6_2
  else
    L6_2 = GetPedPropIndex
    L7_2 = L2_2
    L8_2 = A1_2
    L6_2 = L6_2(L7_2, L8_2)
    L4_2 = L6_2
    L6_2 = GetPedPropTextureIndex
    L7_2 = L2_2
    L8_2 = A1_2
    L6_2 = L6_2(L7_2, L8_2)
    L5_2 = L6_2
    if nil ~= L5_2 and L5_2 < 0 then
      L5_2 = 0
    end
  end
  if nil == L4_2 or L4_2 < 0 then
    L6_2 = false
    L7_2 = nil
    return L6_2, L7_2
  end
  L6_2 = L31_1
  L6_2()
  L6_2 = L26_1
  L6_2()
  L6_2 = Config
  L6_2 = L6_2.preview
  if L6_2 then
    L6_2 = Config
    L6_2 = L6_2.preview
    L6_2 = L6_2.mode
    if L6_2 then
      goto lbl_75
    end
  end
  L6_2 = "auto"
  ::lbl_75::
  L7_2 = L10_1
  if nil == L7_2 then
    if "image" == L6_2 then
      L7_2 = "image"
      if L7_2 then
        goto lbl_84
      end
    end
    L7_2 = "dui"
    ::lbl_84::
    L10_1 = L7_2
  end
  L7_2 = L10_1
  if "image" ~= L7_2 then
    L7_2 = L28_1
    L8_2 = L7_1
    if L8_2 > 0 then
      L8_2 = L7_1
      if L8_2 then
        goto lbl_96
      end
    end
    L8_2 = nil
    ::lbl_96::
    L7_2(L8_2)
  end
  L7_2 = Preview
  L7_2 = L7_2.ResolveCandidates
  L8_2 = L2_2
  L9_2 = L3_2
  L10_2 = A0_2
  L11_2 = A1_2
  L12_2 = L4_2
  L13_2 = L5_2
  L7_2 = L7_2(L8_2, L9_2, L10_2, L11_2, L12_2, L13_2)
  L8_2 = L32_1
  L9_2 = L7_2
  L8_2(L9_2)
  L8_2 = {}
  L8_2.kind = A0_2
  L8_2.id = A1_2
  L21_1 = L8_2
  L8_2 = true
  L9_2 = L7_2
  return L8_2, L9_2
end
L36_1 = Preview
function L37_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2
  L2_2 = L21_1
  if not L2_2 then
    return
  end
  L2_2 = L21_1.kind
  if L2_2 == A0_2 then
    L2_2 = L21_1.id
    if L2_2 == A1_2 then
      goto lbl_12
    end
  end
  do return end
  ::lbl_12::
  L2_2 = L35_1
  L3_2 = A0_2
  L4_2 = A1_2
  L2_2 = L2_2(L3_2, L4_2)
  L3_2 = L34_1
  L4_2 = L2_2
  L3_2(L4_2)
end
L36_1.Reapply = L37_1
L36_1 = Preview
function L37_1()
  local L0_2, L1_2
  L0_2 = L31_1
  L0_2()
  L0_2 = nil
  L21_1 = L0_2
  L0_2 = L34_1
  L1_2 = false
  L0_2(L1_2)
end
L36_1.Clear = L37_1
L36_1 = Preview
function L37_1()
  local L0_2, L1_2
  L0_2 = L21_1
  return L0_2
end
L36_1.ActiveSlot = L37_1
L36_1 = RegisterNUICallback
L37_1 = "previewEnable"
function L38_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2
  if not A0_2 then
    L2_2 = {}
    A0_2 = L2_2
  end
  L2_2 = tostring
  L3_2 = A0_2.kind
  if not L3_2 then
    L3_2 = ""
  end
  L2_2 = L2_2(L3_2)
  L3_2 = math
  L3_2 = L3_2.floor
  L4_2 = tonumber
  L5_2 = A0_2.id
  L4_2 = L4_2(L5_2)
  if not L4_2 then
    L4_2 = -1
  end
  L3_2 = L3_2(L4_2)
  if "component" ~= L2_2 and "prop" ~= L2_2 or L3_2 < 0 then
    L4_2 = A1_2
    L5_2 = {}
    L5_2.ok = false
    L4_2(L5_2)
    return
  end
  L4_2 = L35_1
  L5_2 = L2_2
  L6_2 = L3_2
  L4_2, L5_2 = L4_2(L5_2, L6_2)
  L6_2 = L34_1
  L7_2 = L4_2
  L6_2(L7_2)
  if L4_2 and L5_2 then
    L6_2 = L5_2[1]
    if L6_2 then
      L6_2 = A1_2
      L7_2 = {}
      L7_2.ok = true
      L8_2 = L5_2[1]
      L8_2 = L8_2.txd
      L7_2.txd = L8_2
      L8_2 = L5_2[1]
      L8_2 = L8_2.txn
      L7_2.txn = L8_2
      L8_2 = #L5_2
      L7_2.candidates = L8_2
      L6_2(L7_2)
  end
  else
    L6_2 = A1_2
    L7_2 = {}
    L7_2.ok = false
    L6_2(L7_2)
  end
end
L36_1(L37_1, L38_1)
L36_1 = RegisterNUICallback
L37_1 = "previewClear"
function L38_1(A0_2, A1_2)
  local L2_2, L3_2
  L2_2 = Preview
  L2_2 = L2_2.Clear
  L2_2()
  L2_2 = A1_2
  L3_2 = {}
  L2_2(L3_2)
end
L36_1(L37_1, L38_1)
L36_1 = RegisterNUICallback
L37_1 = "duiReady"
function L38_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2, L6_2
  L2_2 = A1_2
  L3_2 = {}
  L2_2(L3_2)
  L2_2 = true
  L6_1 = L2_2
  L2_2 = Utils
  L2_2 = L2_2.Log
  L3_2 = "DUI page reported ready (%d ms after it was created)"
  L4_2 = L3_2
  L3_2 = L3_2.format
  L5_2 = L14_1
  if L5_2 then
    L5_2 = GetGameTimer
    L5_2 = L5_2()
    L6_2 = L14_1
    L5_2 = L5_2 - L6_2
    if L5_2 then
      goto lbl_22
    end
  end
  L5_2 = -1
  ::lbl_22::
  L3_2, L4_2, L5_2, L6_2 = L3_2(L4_2, L5_2)
  L2_2(L3_2, L4_2, L5_2, L6_2)
  L2_2 = L10_1
  if "image" == L2_2 then
    L2_2 = L15_1
    if L2_2 then
      L2_2 = false
      L15_1 = L2_2
      L2_2 = "dui"
      L10_1 = L2_2
      L2_2 = L2_1
      L19_1 = L2_2
      L2_2 = L33_1
      L2_2()
      L2_2 = Utils
      L2_2 = L2_2.Warn
      L3_2 = "DUI answered late - back on the live DUI surface"
      L2_2(L3_2)
    end
  end
  L2_2 = L29_1
  L2_2()
end
L36_1(L37_1, L38_1)
L36_1 = RegisterNUICallback
L37_1 = "previewFrameData"
function L38_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2
  L2_2 = A1_2
  L3_2 = {}
  L2_2(L3_2)
  if not A0_2 then
    L2_2 = {}
    A0_2 = L2_2
  end
  L2_2 = A0_2.frame
  L3_2 = type
  L4_2 = L2_2
  L3_2 = L3_2(L4_2)
  if "string" ~= L3_2 or "" == L2_2 then
    return
  end
  L12_1 = L2_2
  L3_2 = L11_1
  if nil == L3_2 then
    L3_2 = GetGameTimer
    L3_2 = L3_2()
    L11_1 = L3_2
  end
  L3_2 = math
  L3_2 = L3_2.floor
  L4_2 = tonumber
  L5_2 = A0_2.size
  L4_2 = L4_2(L5_2)
  if not L4_2 then
    L4_2 = 0
  end
  L3_2 = L3_2(L4_2)
  L4_2 = Config
  L4_2 = L4_2.preview
  if L4_2 then
    L4_2 = Config
    L4_2 = L4_2.preview
    L4_2 = L4_2.mode
    if L4_2 then
      goto lbl_45
    end
  end
  L4_2 = "auto"
  ::lbl_45::
  L5_2 = L10_1
  if nil == L5_2 then
    if "image" == L4_2 then
      L5_2 = "image"
      if L5_2 then
        goto lbl_54
      end
    end
    L5_2 = "dui"
    ::lbl_54::
    L10_1 = L5_2
  end
  L5_2 = L10_1
  if "image" ~= L5_2 then
    L5_2 = L28_1
    L6_2 = L3_2 or L6_2
    if not (L3_2 > 0) or not L3_2 then
      L6_2 = nil
    end
    L5_2(L6_2)
    L5_2 = L6_1
    if L5_2 then
      L5_2 = L29_1
      L5_2()
    else
      L5_2 = L30_1
      L5_2()
    end
    return
  end
  L5_2 = GetGameTimer
  L5_2 = L5_2()
  L6_2 = Config
  L6_2 = L6_2.preview
  if L6_2 then
    L6_2 = Config
    L6_2 = L6_2.preview
    L6_2 = L6_2.imageMinIntervalMs
    if L6_2 then
      goto lbl_86
    end
  end
  L6_2 = 1500
  ::lbl_86::
  L7_2 = Config
  L7_2 = L7_2.preview
  if L7_2 then
    L7_2 = Config
    L7_2 = L7_2.preview
    L7_2 = L7_2.imageMaxVersions
    if L7_2 then
      goto lbl_96
    end
  end
  L7_2 = 40
  ::lbl_96::
  L8_2 = L17_1
  L8_2 = L5_2 - L8_2
  if L6_2 > L8_2 then
    return
  end
  L8_2 = L16_1
  if L7_2 <= L8_2 then
    L8_2 = L18_1
    if not L8_2 then
      L8_2 = true
      L18_1 = L8_2
      L8_2 = L34_1
      L9_2 = L21_1
      L9_2 = nil ~= L9_2
      L10_2 = {}
      L10_2.throttled = true
      L8_2(L9_2, L10_2)
      L8_2 = Apex
      L8_2 = L8_2.Notify
      L9_2 = L
      L10_2 = "preview_throttled"
      L11_2 = "Preview update limit reached for this session - save or export to continue."
      L9_2 = L9_2(L10_2, L11_2)
      L10_2 = "error"
      L8_2(L9_2, L10_2)
    end
    return
  end
  L17_1 = L5_2
  L8_2 = L16_1
  L8_2 = L8_2 + 1
  L16_1 = L8_2
  L8_2 = "apex_ct_v%d"
  L9_2 = L8_2
  L8_2 = L8_2.format
  L10_2 = L16_1
  L8_2 = L8_2(L9_2, L10_2)
  L9_2 = CreateRuntimeTextureFromImage
  L10_2 = L26_1
  L10_2 = L10_2()
  L11_2 = L8_2
  L12_2 = L2_2
  L9_2(L10_2, L11_2, L12_2)
  L19_1 = L8_2
  L9_2 = L33_1
  L9_2()
end
L36_1(L37_1, L38_1)
L36_1 = AddEventHandler
L37_1 = "onResourceStop"
function L38_1(A0_2)
  local L1_2, L2_2
  L1_2 = GetCurrentResourceName
  L1_2 = L1_2()
  if A0_2 ~= L1_2 then
    return
  end
  L1_2 = pcall
  L2_2 = L31_1
  L1_2(L2_2)
  L1_2 = pcall
  L2_2 = L27_1
  L1_2(L2_2)
end
L36_1(L37_1, L38_1)
