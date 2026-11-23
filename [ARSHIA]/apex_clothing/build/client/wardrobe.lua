local L0_1, L1_1, L2_1, L3_1, L4_1, L5_1, L6_1, L7_1
L0_1 = Wardrobe
if not L0_1 then
  L0_1 = {}
end
Wardrobe = L0_1
L0_1 = nil
function L1_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2
  L2_2 = ""
  L3_2 = nil
  L4_2 = pcall
  L5_2 = GetPedDrawableVariationCollectionName
  L6_2 = A0_2
  L7_2 = A1_2
  L4_2, L5_2 = L4_2(L5_2, L6_2, L7_2)
  L6_2 = pcall
  L7_2 = _ENV
  L8_2 = "GetPedDrawableVariationCollectionLocalIndex"
  L7_2 = L7_2[L8_2]
  L8_2 = A0_2
  L9_2 = A1_2
  L6_2, L7_2 = L6_2(L7_2, L8_2, L9_2)
  if L4_2 and L6_2 then
    L8_2 = type
    L9_2 = L5_2
    L8_2 = L8_2(L9_2)
    if "string" == L8_2 then
      L8_2 = type
      L9_2 = L7_2
      L8_2 = L8_2(L9_2)
      if "number" == L8_2 and L7_2 >= 0 then
        L8_2 = L5_2
        L3_2 = L7_2
        L2_2 = L8_2
      end
    end
  end
  L8_2 = L2_2
  L9_2 = L3_2
  return L8_2, L9_2
end
function L2_1(A0_2, A1_2, A2_2)
  local L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2
  L3_2 = ""
  L4_2 = nil
  if nil == A2_2 or A2_2 < 0 then
    L5_2 = L3_2
    L6_2 = L4_2
    return L5_2, L6_2
  end
  L5_2 = pcall
  L6_2 = GetPedCollectionNameFromProp
  L7_2 = A0_2
  L8_2 = A1_2
  L9_2 = A2_2
  L5_2, L6_2 = L5_2(L6_2, L7_2, L8_2, L9_2)
  L7_2 = pcall
  L8_2 = GetPedCollectionLocalIndexFromProp
  L9_2 = A0_2
  L10_2 = A1_2
  L11_2 = A2_2
  L7_2, L8_2 = L7_2(L8_2, L9_2, L10_2, L11_2)
  if L5_2 and L7_2 then
    L9_2 = type
    L10_2 = L6_2
    L9_2 = L9_2(L10_2)
    if "string" == L9_2 then
      L9_2 = type
      L10_2 = L8_2
      L9_2 = L9_2(L10_2)
      if "number" == L9_2 and L8_2 >= 0 then
        L9_2 = L6_2
        L4_2 = L8_2
        L3_2 = L9_2
      end
    end
  end
  L9_2 = L3_2
  L10_2 = L4_2
  return L9_2, L10_2
end
L3_1 = Wardrobe
function L4_1()
  local L0_2, L1_2, L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2
  L0_2 = PlayerPedId
  L0_2 = L0_2()
  L1_2 = {}
  L2_2 = {}
  L1_2.components = L2_2
  L2_2 = {}
  L1_2.props = L2_2
  L0_1 = L1_2
  L1_2 = ipairs
  L2_2 = Config
  L2_2 = L2_2.components
  if not L2_2 then
    L2_2 = {}
  end
  L1_2, L2_2, L3_2, L4_2 = L1_2(L2_2)
  for L5_2, L6_2 in L1_2, L2_2, L3_2, L4_2 do
    L7_2 = L0_1.components
    L8_2 = L6_2.id
    L9_2 = {}
    L10_2 = GetPedDrawableVariation
    L11_2 = L0_2
    L12_2 = L6_2.id
    L10_2 = L10_2(L11_2, L12_2)
    L9_2.drawable = L10_2
    L10_2 = GetPedTextureVariation
    L11_2 = L0_2
    L12_2 = L6_2.id
    L10_2 = L10_2(L11_2, L12_2)
    L9_2.texture = L10_2
    L10_2 = GetPedPaletteVariation
    L11_2 = L0_2
    L12_2 = L6_2.id
    L10_2 = L10_2(L11_2, L12_2)
    L9_2.palette = L10_2
    L7_2[L8_2] = L9_2
  end
  L1_2 = ipairs
  L2_2 = Config
  L2_2 = L2_2.props
  if not L2_2 then
    L2_2 = {}
  end
  L1_2, L2_2, L3_2, L4_2 = L1_2(L2_2)
  for L5_2, L6_2 in L1_2, L2_2, L3_2, L4_2 do
    L7_2 = L0_1.props
    L8_2 = L6_2.id
    L9_2 = {}
    L10_2 = GetPedPropIndex
    L11_2 = L0_2
    L12_2 = L6_2.id
    L10_2 = L10_2(L11_2, L12_2)
    L9_2.drawable = L10_2
    L10_2 = GetPedPropTextureIndex
    L11_2 = L0_2
    L12_2 = L6_2.id
    L10_2 = L10_2(L11_2, L12_2)
    L9_2.texture = L10_2
    L7_2[L8_2] = L9_2
  end
  L1_2 = Utils
  L1_2 = L1_2.Log
  L2_2 = "wardrobe snapshot taken"
  L1_2(L2_2)
end
L3_1.Snapshot = L4_1
L3_1 = Wardrobe
function L4_1()
  local L0_2, L1_2, L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2
  L0_2 = L0_1
  if not L0_2 then
    return
  end
  L0_2 = PlayerPedId
  L0_2 = L0_2()
  L1_2 = pairs
  L2_2 = L0_1.components
  L1_2, L2_2, L3_2, L4_2 = L1_2(L2_2)
  for L5_2, L6_2 in L1_2, L2_2, L3_2, L4_2 do
    L7_2 = SetPedComponentVariation
    L8_2 = L0_2
    L9_2 = L5_2
    L10_2 = L6_2.drawable
    L11_2 = L6_2.texture
    L12_2 = L6_2.palette
    if not L12_2 then
      L12_2 = 0
    end
    L7_2(L8_2, L9_2, L10_2, L11_2, L12_2)
  end
  L1_2 = pairs
  L2_2 = L0_1.props
  L1_2, L2_2, L3_2, L4_2 = L1_2(L2_2)
  for L5_2, L6_2 in L1_2, L2_2, L3_2, L4_2 do
    L7_2 = L6_2.drawable
    if nil ~= L7_2 then
      L7_2 = L6_2.drawable
      if not (L7_2 < 0) then
        goto lbl_39
      end
    end
    L7_2 = ClearPedProp
    L8_2 = L0_2
    L9_2 = L5_2
    L7_2(L8_2, L9_2)
    goto lbl_53
    ::lbl_39::
    L7_2 = SetPedPropIndex
    L8_2 = L0_2
    L9_2 = L5_2
    L10_2 = L6_2.drawable
    L11_2 = math
    L11_2 = L11_2.max
    L12_2 = L6_2.texture
    if not L12_2 then
      L12_2 = 0
    end
    L13_2 = 0
    L11_2 = L11_2(L12_2, L13_2)
    L12_2 = true
    L7_2(L8_2, L9_2, L10_2, L11_2, L12_2)
    ::lbl_53::
  end
  L1_2 = Utils
  L1_2 = L1_2.Log
  L2_2 = "wardrobe snapshot restored"
  L1_2(L2_2)
end
L3_1.Restore = L4_1
L3_1 = Wardrobe
function L4_1()
  local L0_2, L1_2, L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2, L19_2, L20_2
  L0_2 = PlayerPedId
  L0_2 = L0_2()
  L1_2 = Apex
  L1_2 = L1_2.GetPedModelName
  L2_2 = L0_2
  L1_2 = L1_2(L2_2)
  if not L1_2 then
    L1_2 = "unknown"
  end
  L2_2 = {}
  L2_2.model = L1_2
  L3_2 = {}
  L2_2.components = L3_2
  L3_2 = {}
  L2_2.props = L3_2
  L3_2 = ipairs
  L4_2 = Config
  L4_2 = L4_2.components
  if not L4_2 then
    L4_2 = {}
  end
  L3_2, L4_2, L5_2, L6_2 = L3_2(L4_2)
  for L7_2, L8_2 in L3_2, L4_2, L5_2, L6_2 do
    L9_2 = GetPedDrawableVariation
    L10_2 = L0_2
    L11_2 = L8_2.id
    L9_2 = L9_2(L10_2, L11_2)
    L10_2 = GetPedTextureVariation
    L11_2 = L0_2
    L12_2 = L8_2.id
    L10_2 = L10_2(L11_2, L12_2)
    L11_2 = L1_1
    L12_2 = L0_2
    L13_2 = L8_2.id
    L11_2, L12_2 = L11_2(L12_2, L13_2)
    L13_2 = ""
    if "unknown" ~= L1_2 then
      L14_2 = Preview
      L14_2 = L14_2.ResolveCandidates
      L15_2 = L0_2
      L16_2 = L1_2
      L17_2 = "component"
      L18_2 = L8_2.id
      L19_2 = L9_2
      L20_2 = L10_2
      L14_2 = L14_2(L15_2, L16_2, L17_2, L18_2, L19_2, L20_2)
      L15_2 = L14_2[1]
      if L15_2 then
        L15_2 = L14_2[1]
        L15_2 = L15_2.txn
        if L15_2 then
          goto lbl_60
          L13_2 = L15_2 or L13_2
        end
      end
      L13_2 = ""
    end
    ::lbl_60::
    L14_2 = L2_2.components
    L15_2 = {}
    L16_2 = L8_2.id
    L15_2.comp = L16_2
    L16_2 = L8_2.key
    L15_2.key = L16_2
    L16_2 = L
    L17_2 = L8_2.label
    L18_2 = L8_2.key
    L16_2 = L16_2(L17_2, L18_2)
    L15_2.label = L16_2
    L15_2.drawable = L9_2
    L15_2.texture = L10_2
    L16_2 = GetNumberOfPedDrawableVariations
    L17_2 = L0_2
    L18_2 = L8_2.id
    L16_2 = L16_2(L17_2, L18_2)
    L15_2.drawables = L16_2
    L16_2 = GetNumberOfPedTextureVariations
    L17_2 = L0_2
    L18_2 = L8_2.id
    L19_2 = L9_2
    L16_2 = L16_2(L17_2, L18_2, L19_2)
    L15_2.textures = L16_2
    L15_2.collection = L11_2
    L16_2 = L12_2 or L16_2
    if not L12_2 then
      L16_2 = L9_2
    end
    L15_2.localIndex = L16_2
    L15_2.texName = L13_2
    L14_2[L7_2] = L15_2
  end
  L3_2 = ipairs
  L4_2 = Config
  L4_2 = L4_2.props
  if not L4_2 then
    L4_2 = {}
  end
  L3_2, L4_2, L5_2, L6_2 = L3_2(L4_2)
  for L7_2, L8_2 in L3_2, L4_2, L5_2, L6_2 do
    L9_2 = GetPedPropIndex
    L10_2 = L0_2
    L11_2 = L8_2.id
    L9_2 = L9_2(L10_2, L11_2)
    L10_2 = GetPedPropTextureIndex
    L11_2 = L0_2
    L12_2 = L8_2.id
    L10_2 = L10_2(L11_2, L12_2)
    if nil == L10_2 or L10_2 < 0 then
      L10_2 = 0
    end
    L11_2 = L2_1
    L12_2 = L0_2
    L13_2 = L8_2.id
    L14_2 = L9_2
    L11_2, L12_2 = L11_2(L12_2, L13_2, L14_2)
    L13_2 = ""
    if "unknown" ~= L1_2 and nil ~= L9_2 and L9_2 >= 0 then
      L14_2 = Preview
      L14_2 = L14_2.ResolveCandidates
      L15_2 = L0_2
      L16_2 = L1_2
      L17_2 = "prop"
      L18_2 = L8_2.id
      L19_2 = L9_2
      L20_2 = L10_2
      L14_2 = L14_2(L15_2, L16_2, L17_2, L18_2, L19_2, L20_2)
      L15_2 = L14_2[1]
      if L15_2 then
        L15_2 = L14_2[1]
        L15_2 = L15_2.txn
        if L15_2 then
          goto lbl_146
          L13_2 = L15_2 or L13_2
        end
      end
      L13_2 = ""
    end
    ::lbl_146::
    L14_2 = L2_2.props
    L15_2 = {}
    L16_2 = L8_2.id
    L15_2.prop = L16_2
    L16_2 = L8_2.key
    L15_2.key = L16_2
    L16_2 = L
    L17_2 = L8_2.label
    L18_2 = L8_2.key
    L16_2 = L16_2(L17_2, L18_2)
    L15_2.label = L16_2
    L15_2.drawable = L9_2
    L15_2.texture = L10_2
    L16_2 = GetNumberOfPedPropDrawableVariations
    L17_2 = L0_2
    L18_2 = L8_2.id
    L16_2 = L16_2(L17_2, L18_2)
    L15_2.drawables = L16_2
    if nil ~= L9_2 and L9_2 >= 0 then
      L16_2 = GetNumberOfPedPropTextureVariations
      L17_2 = L0_2
      L18_2 = L8_2.id
      L19_2 = L9_2
      L16_2 = L16_2(L17_2, L18_2, L19_2)
      if L16_2 then
        goto lbl_177
      end
    end
    L16_2 = 0
    ::lbl_177::
    L15_2.textures = L16_2
    L15_2.collection = L11_2
    L16_2 = L12_2 or L16_2
    if not L12_2 then
      L16_2 = L9_2
    end
    L15_2.localIndex = L16_2
    L15_2.texName = L13_2
    L14_2[L7_2] = L15_2
  end
  return L2_2
end
L3_1.GetState = L4_1
function L3_1(A0_2, A1_2, A2_2, A3_2)
  local L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2
  L4_2 = GetNumberOfPedDrawableVariations
  L5_2 = A0_2
  L6_2 = A1_2
  L4_2 = L4_2(L5_2, L6_2)
  if L4_2 <= 0 then
    return
  end
  L5_2 = Utils
  L5_2 = L5_2.Clamp
  L6_2 = A2_2
  L7_2 = 0
  L8_2 = L4_2 - 1
  L5_2 = L5_2(L6_2, L7_2, L8_2)
  A2_2 = L5_2
  L5_2 = GetNumberOfPedTextureVariations
  L6_2 = A0_2
  L7_2 = A1_2
  L8_2 = A2_2
  L5_2 = L5_2(L6_2, L7_2, L8_2)
  L6_2 = Utils
  L6_2 = L6_2.Clamp
  L7_2 = A3_2
  L8_2 = 0
  L9_2 = math
  L9_2 = L9_2.max
  L10_2 = L5_2 - 1
  L11_2 = 0
  L9_2, L10_2, L11_2 = L9_2(L10_2, L11_2)
  L6_2 = L6_2(L7_2, L8_2, L9_2, L10_2, L11_2)
  A3_2 = L6_2
  L6_2 = IsPedComponentVariationValid
  L7_2 = A0_2
  L8_2 = A1_2
  L9_2 = A2_2
  L10_2 = A3_2
  L6_2 = L6_2(L7_2, L8_2, L9_2, L10_2)
  if not L6_2 then
    A3_2 = 0
  end
  L6_2 = SetPedComponentVariation
  L7_2 = A0_2
  L8_2 = A1_2
  L9_2 = A2_2
  L10_2 = A3_2
  L11_2 = 0
  L6_2(L7_2, L8_2, L9_2, L10_2, L11_2)
end
function L4_1(A0_2, A1_2, A2_2, A3_2)
  local L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2
  if nil == A2_2 or A2_2 < 0 then
    L4_2 = ClearPedProp
    L5_2 = A0_2
    L6_2 = A1_2
    L4_2(L5_2, L6_2)
    return
  end
  L4_2 = GetNumberOfPedPropDrawableVariations
  L5_2 = A0_2
  L6_2 = A1_2
  L4_2 = L4_2(L5_2, L6_2)
  if L4_2 <= 0 then
    L5_2 = ClearPedProp
    L6_2 = A0_2
    L7_2 = A1_2
    L5_2(L6_2, L7_2)
    return
  end
  L5_2 = Utils
  L5_2 = L5_2.Clamp
  L6_2 = A2_2
  L7_2 = 0
  L8_2 = L4_2 - 1
  L5_2 = L5_2(L6_2, L7_2, L8_2)
  A2_2 = L5_2
  L5_2 = GetNumberOfPedPropTextureVariations
  L6_2 = A0_2
  L7_2 = A1_2
  L8_2 = A2_2
  L5_2 = L5_2(L6_2, L7_2, L8_2)
  L6_2 = Utils
  L6_2 = L6_2.Clamp
  L7_2 = A3_2
  L8_2 = 0
  L9_2 = math
  L9_2 = L9_2.max
  L10_2 = L5_2 - 1
  L11_2 = 0
  L9_2, L10_2, L11_2 = L9_2(L10_2, L11_2)
  L6_2 = L6_2(L7_2, L8_2, L9_2, L10_2, L11_2)
  A3_2 = L6_2
  L6_2 = SetPedPropIndex
  L7_2 = A0_2
  L8_2 = A1_2
  L9_2 = A2_2
  L10_2 = A3_2
  L11_2 = true
  L6_2(L7_2, L8_2, L9_2, L10_2, L11_2)
end
L5_1 = RegisterNUICallback
L6_1 = "wardrobeSet"
function L7_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2
  if not A0_2 then
    L2_2 = {}
    A0_2 = L2_2
  end
  L2_2 = PlayerPedId
  L2_2 = L2_2()
  L3_2 = tostring
  L4_2 = A0_2.kind
  if not L4_2 then
    L4_2 = ""
  end
  L3_2 = L3_2(L4_2)
  L4_2 = math
  L4_2 = L4_2.floor
  L5_2 = tonumber
  L6_2 = A0_2.id
  L5_2 = L5_2(L6_2)
  if not L5_2 then
    L5_2 = -1
  end
  L4_2 = L4_2(L5_2)
  L5_2 = math
  L5_2 = L5_2.floor
  L6_2 = tonumber
  L7_2 = A0_2.drawable
  L6_2 = L6_2(L7_2)
  if not L6_2 then
    L6_2 = 0
  end
  L5_2 = L5_2(L6_2)
  L6_2 = math
  L6_2 = L6_2.floor
  L7_2 = tonumber
  L8_2 = A0_2.texture
  L7_2 = L7_2(L8_2)
  if not L7_2 then
    L7_2 = 0
  end
  L6_2 = L6_2(L7_2)
  if "component" == L3_2 and L4_2 >= 0 then
    L7_2 = L3_1
    L8_2 = L2_2
    L9_2 = L4_2
    L10_2 = L5_2
    L11_2 = L6_2
    L7_2(L8_2, L9_2, L10_2, L11_2)
  elseif "prop" == L3_2 and L4_2 >= 0 then
    L7_2 = L4_1
    L8_2 = L2_2
    L9_2 = L4_2
    L10_2 = L5_2
    L11_2 = L6_2
    L7_2(L8_2, L9_2, L10_2, L11_2)
  end
  L7_2 = Preview
  L7_2 = L7_2.Reapply
  L8_2 = L3_2
  L9_2 = L4_2
  L7_2(L8_2, L9_2)
  L7_2 = A1_2
  L8_2 = Wardrobe
  L8_2 = L8_2.GetState
  L8_2, L9_2, L10_2, L11_2 = L8_2()
  L7_2(L8_2, L9_2, L10_2, L11_2)
end
L5_1(L6_1, L7_1)
L5_1 = RegisterNUICallback
L6_1 = "wardrobeReset"
function L7_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2
  L2_2 = Wardrobe
  L2_2 = L2_2.Restore
  L2_2()
  L2_2 = Preview
  L2_2 = L2_2.ActiveSlot
  if L2_2 then
    L2_2 = Preview
    L2_2 = L2_2.ActiveSlot
    L2_2 = L2_2()
    if L2_2 then
      L3_2 = Preview
      L3_2 = L3_2.Reapply
      L4_2 = L2_2.kind
      L5_2 = L2_2.id
      L3_2(L4_2, L5_2)
    end
  end
  L2_2 = A1_2
  L3_2 = Wardrobe
  L3_2 = L3_2.GetState
  L3_2, L4_2, L5_2 = L3_2()
  L2_2(L3_2, L4_2, L5_2)
end
L5_1(L6_1, L7_1)
