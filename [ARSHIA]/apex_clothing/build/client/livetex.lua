local L0_1, L1_1, L2_1, L3_1, L4_1, L5_1, L6_1, L7_1, L8_1, L9_1, L10_1, L11_1, L12_1, L13_1, L14_1, L15_1
L0_1 = "apex_clothing_live"
L1_1 = L0_1
L2_1 = false
L3_1 = 0
L4_1 = {}
L5_1 = nil
function L6_1()
  local L0_2, L1_2, L2_2, L3_2, L4_2, L5_2
  L0_2 = L2_1
  if L0_2 then
    L0_2 = L5_1
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
  L5_1 = L1_2
  L1_2 = 0
  while true do
    L2_2 = L5_1
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
    L5_1 = L2_2
  end
  L2_2 = L5_1
  if L2_2 then
    L2_2 = true
    L2_1 = L2_2
  end
  L2_2 = L5_1
  return L2_2
end
function L7_1(A0_2)
  local L1_2, L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2
  L1_2 = {}
  L2_2 = ipairs
  L3_2 = A0_2.textures
  L2_2, L3_2, L4_2, L5_2 = L2_2(L3_2)
  for L6_2, L7_2 in L2_2, L3_2, L4_2, L5_2 do
    L8_2 = L7_2.image
    L9_2 = #L1_2
    L9_2 = L9_2 + 1
    L10_2 = type
    L11_2 = L8_2
    L10_2 = L10_2(L11_2)
    if "string" == L10_2 then
      L10_2 = #L8_2
      L11_2 = "|"
      L13_2 = L8_2
      L12_2 = L8_2.sub
      L14_2 = 1
      L15_2 = 48
      L12_2 = L12_2(L13_2, L14_2, L15_2)
      L14_2 = L8_2
      L13_2 = L8_2.sub
      L15_2 = -48
      L13_2 = L13_2(L14_2, L15_2)
      L10_2 = L10_2 .. L11_2 .. L12_2 .. L13_2
      if L10_2 then
        goto lbl_29
      end
    end
    L10_2 = "0"
    ::lbl_29::
    L1_2[L9_2] = L10_2
  end
  L2_2 = table
  L2_2 = L2_2.concat
  L3_2 = L1_2
  L4_2 = ";"
  return L2_2(L3_2, L4_2)
end
function L8_1(A0_2)
  local L1_2, L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2
  if A0_2 and 0 ~= A0_2 then
    L1_2 = DoesEntityExist
    L2_2 = A0_2
    L1_2 = L1_2(L2_2)
    if L1_2 then
      goto lbl_11
    end
  end
  do return end
  ::lbl_11::
  L1_2 = 0
  L2_2 = 11
  L3_2 = 1
  for L4_2 = L1_2, L2_2, L3_2 do
    L5_2 = GetPedDrawableVariation
    L6_2 = A0_2
    L7_2 = L4_2
    L5_2 = L5_2(L6_2, L7_2)
    L6_2 = GetPedTextureVariation
    L7_2 = A0_2
    L8_2 = L4_2
    L6_2 = L6_2(L7_2, L8_2)
    L7_2 = GetPedPaletteVariation
    L8_2 = A0_2
    L9_2 = L4_2
    L7_2 = L7_2(L8_2, L9_2)
    if nil ~= L5_2 and L5_2 >= 0 then
      L8_2 = SetPedComponentVariation
      L9_2 = A0_2
      L10_2 = L4_2
      L11_2 = L5_2
      L12_2 = L6_2 or L12_2
      if not (L6_2 >= 0) or not L6_2 then
        L12_2 = 0
      end
      L13_2 = L7_2 or L13_2
      if not (L7_2 >= 0) or not L7_2 then
        L13_2 = 0
      end
      L8_2(L9_2, L10_2, L11_2, L12_2, L13_2)
    end
  end
  L1_2 = ipairs
  L2_2 = {}
  L3_2 = 0
  L4_2 = 1
  L5_2 = 2
  L6_2 = 6
  L7_2 = 7
  L2_2[1] = L3_2
  L2_2[2] = L4_2
  L2_2[3] = L5_2
  L2_2[4] = L6_2
  L2_2[5] = L7_2
  L1_2, L2_2, L3_2, L4_2 = L1_2(L2_2)
  for L5_2, L6_2 in L1_2, L2_2, L3_2, L4_2 do
    L7_2 = GetPedPropIndex
    L8_2 = A0_2
    L9_2 = L6_2
    L7_2 = L7_2(L8_2, L9_2)
    if nil ~= L7_2 and L7_2 >= 0 then
      L8_2 = GetPedPropTextureIndex
      L9_2 = A0_2
      L10_2 = L6_2
      L8_2 = L8_2(L9_2, L10_2)
      L9_2 = SetPedPropIndex
      L10_2 = A0_2
      L11_2 = L6_2
      L12_2 = L7_2
      L13_2 = L8_2 or L13_2
      if not (L8_2 >= 0) or not L8_2 then
        L13_2 = 0
      end
      L14_2 = true
      L9_2(L10_2, L11_2, L12_2, L13_2, L14_2)
    end
  end
end
function L9_1()
  local L0_2, L1_2, L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2
  L0_2 = L8_1
  L1_2 = PlayerPedId
  L1_2, L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2 = L1_2()
  L0_2(L1_2, L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2)
  L0_2 = ipairs
  L1_2 = GetActivePlayers
  L1_2, L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2 = L1_2()
  L0_2, L1_2, L2_2, L3_2 = L0_2(L1_2, L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2)
  for L4_2, L5_2 in L0_2, L1_2, L2_2, L3_2 do
    L6_2 = GetPlayerPed
    L7_2 = L5_2
    L6_2 = L6_2(L7_2)
    if L6_2 then
      L7_2 = PlayerPedId
      L7_2 = L7_2()
      if L6_2 ~= L7_2 then
        L7_2 = L8_1
        L8_2 = L6_2
        L7_2(L8_2)
      end
    end
  end
end
function L10_1(A0_2)
  local L1_2, L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2
  L1_2 = L4_1
  L1_2 = L1_2[A0_2]
  if not L1_2 then
    return
  end
  L2_2 = ipairs
  L3_2 = L1_2.pairs
  if not L3_2 then
    L3_2 = {}
  end
  L2_2, L3_2, L4_2, L5_2 = L2_2(L3_2)
  for L6_2, L7_2 in L2_2, L3_2, L4_2, L5_2 do
    L8_2 = pcall
    L9_2 = RemoveReplaceTexture
    L10_2 = L7_2.txd
    L11_2 = L7_2.txn
    L8_2(L9_2, L10_2, L11_2)
  end
  L2_2 = L4_1
  L2_2[A0_2] = nil
end
function L11_1(A0_2)
  local L1_2, L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2, L19_2, L20_2, L21_2, L22_2, L23_2, L24_2, L25_2, L26_2
  L1_2 = type
  L2_2 = A0_2
  L1_2 = L1_2(L2_2)
  if "table" == L1_2 then
    L1_2 = type
    L2_2 = A0_2.textures
    L1_2 = L1_2(L2_2)
    if "table" == L1_2 then
      goto lbl_12
    end
  end
  do return end
  ::lbl_12::
  L1_2 = tostring
  L2_2 = A0_2.name
  if not L2_2 then
    L2_2 = "outfit"
  end
  L1_2 = L1_2(L2_2)
  L2_2 = L7_1
  L3_2 = A0_2
  L2_2 = L2_2(L3_2)
  L3_2 = L4_1
  L3_2 = L3_2[L1_2]
  if L3_2 then
    L4_2 = L3_2.sig
    if L4_2 == L2_2 then
      L4_2 = L3_2.pairs
      if L4_2 then
        L4_2 = L3_2.pairs
        L4_2 = #L4_2
        if L4_2 > 0 then
          L4_2 = ipairs
          L5_2 = L3_2.pairs
          L4_2, L5_2, L6_2, L7_2 = L4_2(L5_2)
          for L8_2, L9_2 in L4_2, L5_2, L6_2, L7_2 do
            L10_2 = pcall
            L11_2 = AddReplaceTexture
            L12_2 = L9_2.txd
            L13_2 = L9_2.txn
            L14_2 = L9_2.rtTxd
            L15_2 = L9_2.rtTxn
            L10_2(L11_2, L12_2, L13_2, L14_2, L15_2)
          end
          L4_2 = L9_1
          L4_2()
          return
        end
      end
    end
  end
  L4_2 = L6_1
  L4_2 = L4_2()
  if not L4_2 then
    L5_2 = Utils
    if L5_2 then
      L5_2 = Utils
      L5_2 = L5_2.Err
      if L5_2 then
        L5_2 = Utils
        L5_2 = L5_2.Err
        L6_2 = "live retexture: no runtime texture dictionary available on this client. "
        L7_2 = "Nothing was applied. Rejoin the server to clear it."
        L6_2 = L6_2 .. L7_2
        L5_2(L6_2)
      end
    end
    return
  end
  L5_2 = L10_1
  L6_2 = L1_2
  L5_2(L6_2)
  L5_2 = {}
  L6_2 = ipairs
  L7_2 = A0_2.textures
  L6_2, L7_2, L8_2, L9_2 = L6_2(L7_2)
  for L10_2, L11_2 in L6_2, L7_2, L8_2, L9_2 do
    L12_2 = L11_2.image
    L13_2 = type
    L14_2 = L12_2
    L13_2 = L13_2(L14_2)
    if "string" == L13_2 and "" ~= L12_2 then
      L13_2 = type
      L14_2 = L11_2.candidates
      L13_2 = L13_2(L14_2)
      if "table" == L13_2 then
        L13_2 = L3_1
        L13_2 = L13_2 + 1
        L3_1 = L13_2
        L13_2 = "apex_live_%d"
        L14_2 = L13_2
        L13_2 = L13_2.format
        L15_2 = L3_1
        L13_2 = L13_2(L14_2, L15_2)
        L14_2 = pcall
        L15_2 = CreateRuntimeTextureFromImage
        L16_2 = L4_2
        L17_2 = L13_2
        L18_2 = L12_2
        L14_2 = L14_2(L15_2, L16_2, L17_2, L18_2)
        if L14_2 then
          L15_2 = ipairs
          L16_2 = L11_2.candidates
          L15_2, L16_2, L17_2, L18_2 = L15_2(L16_2)
          for L19_2, L20_2 in L15_2, L16_2, L17_2, L18_2 do
            L21_2 = type
            L22_2 = L20_2
            L21_2 = L21_2(L22_2)
            if "table" == L21_2 then
              L21_2 = L20_2.txd
              if L21_2 then
                L21_2 = L20_2.txn
                if L21_2 then
                  L21_2 = pcall
                  L22_2 = AddReplaceTexture
                  L23_2 = L20_2.txd
                  L24_2 = L20_2.txn
                  L25_2 = L1_1
                  L26_2 = L13_2
                  L21_2(L22_2, L23_2, L24_2, L25_2, L26_2)
                  L21_2 = #L5_2
                  L21_2 = L21_2 + 1
                  L22_2 = {}
                  L23_2 = L20_2.txd
                  L22_2.txd = L23_2
                  L23_2 = L20_2.txn
                  L22_2.txn = L23_2
                  L23_2 = L1_1
                  L22_2.rtTxd = L23_2
                  L22_2.rtTxn = L13_2
                  L5_2[L21_2] = L22_2
                end
              end
            end
          end
        else
          L15_2 = Utils
          if L15_2 then
            L15_2 = Utils
            L15_2 = L15_2.Err
            if L15_2 then
              L15_2 = Utils
              L15_2 = L15_2.Err
              L16_2 = "live retexture \"%s\": the image could not be decoded"
              L17_2 = L16_2
              L16_2 = L16_2.format
              L18_2 = L1_2
              L16_2, L17_2, L18_2, L19_2, L20_2, L21_2, L22_2, L23_2, L24_2, L25_2, L26_2 = L16_2(L17_2, L18_2)
              L15_2(L16_2, L17_2, L18_2, L19_2, L20_2, L21_2, L22_2, L23_2, L24_2, L25_2, L26_2)
            end
          end
        end
      end
    end
  end
  L6_2 = L4_1
  L7_2 = {}
  L7_2.pairs = L5_2
  L7_2.sig = L2_2
  L6_2[L1_2] = L7_2
  L6_2 = #L5_2
  if L6_2 > 0 then
    L6_2 = L9_1
    L6_2()
  end
  L6_2 = Utils
  if L6_2 then
    L6_2 = Utils
    L6_2 = L6_2.Log
    if L6_2 then
      L6_2 = Utils
      L6_2 = L6_2.Log
      L7_2 = "live retexture \"%s\" applied (%d replacement pair(s))"
      L8_2 = L7_2
      L7_2 = L7_2.format
      L9_2 = L1_2
      L10_2 = #L5_2
      L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2, L19_2, L20_2, L21_2, L22_2, L23_2, L24_2, L25_2, L26_2 = L7_2(L8_2, L9_2, L10_2)
      L6_2(L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2, L19_2, L20_2, L21_2, L22_2, L23_2, L24_2, L25_2, L26_2)
    end
  end
end
L12_1 = RegisterNetEvent
L13_1 = "apex_clothing:live:apply"
function L14_1(A0_2)
  local L1_2, L2_2
  L1_2 = L11_1
  L2_2 = A0_2
  L1_2(L2_2)
end
L12_1(L13_1, L14_1)
L12_1 = RegisterNetEvent
L13_1 = "apex_clothing:live:removeOne"
function L14_1(A0_2)
  local L1_2, L2_2, L3_2, L4_2, L5_2
  L1_2 = L10_1
  L2_2 = tostring
  L3_2 = A0_2 or L3_2
  if not A0_2 then
    L3_2 = ""
  end
  L2_2, L3_2, L4_2, L5_2 = L2_2(L3_2)
  L1_2(L2_2, L3_2, L4_2, L5_2)
  L1_2 = L9_1
  L1_2()
  L1_2 = Utils
  if L1_2 then
    L1_2 = Utils
    L1_2 = L1_2.Log
    if L1_2 then
      L1_2 = Utils
      L1_2 = L1_2.Log
      L2_2 = "live outfit \"%s\" removed"
      L3_2 = L2_2
      L2_2 = L2_2.format
      L4_2 = tostring
      L5_2 = A0_2
      L4_2, L5_2 = L4_2(L5_2)
      L2_2, L3_2, L4_2, L5_2 = L2_2(L3_2, L4_2, L5_2)
      L1_2(L2_2, L3_2, L4_2, L5_2)
    end
  end
end
L12_1(L13_1, L14_1)
L12_1 = RegisterNetEvent
L13_1 = "apex_clothing:live:clear"
function L14_1()
  local L0_2, L1_2, L2_2, L3_2, L4_2, L5_2, L6_2
  L0_2 = pairs
  L1_2 = L4_1
  L0_2, L1_2, L2_2, L3_2 = L0_2(L1_2)
  for L4_2 in L0_2, L1_2, L2_2, L3_2 do
    L5_2 = L10_1
    L6_2 = L4_2
    L5_2(L6_2)
  end
  L0_2 = {}
  L4_1 = L0_2
  L0_2 = L9_1
  L0_2()
  L0_2 = Utils
  if L0_2 then
    L0_2 = Utils
    L0_2 = L0_2.Log
    if L0_2 then
      L0_2 = Utils
      L0_2 = L0_2.Log
      L1_2 = "live retextures cleared"
      L0_2(L1_2)
    end
  end
end
L12_1(L13_1, L14_1)
function L12_1()
  local L0_2, L1_2
  L0_2 = TriggerServerEvent
  L1_2 = "apex_clothing:live:request"
  L0_2(L1_2)
end
L13_1 = CreateThread
function L14_1()
  local L0_2, L1_2
  while true do
    L0_2 = NetworkIsPlayerActive
    L1_2 = PlayerId
    L1_2 = L1_2()
    L0_2 = L0_2(L1_2)
    if L0_2 then
      L0_2 = DoesEntityExist
      L1_2 = PlayerPedId
      L1_2 = L1_2()
      L0_2 = L0_2(L1_2)
      if L0_2 then
        break
      end
    end
    L0_2 = Wait
    L1_2 = 500
    L0_2(L1_2)
  end
  L0_2 = Wait
  L1_2 = 1000
  L0_2(L1_2)
  L0_2 = L12_1
  L0_2()
end
L13_1(L14_1)
L13_1 = AddEventHandler
L14_1 = "playerSpawned"
function L15_1()
  local L0_2, L1_2
  L0_2 = Wait
  L1_2 = 1500
  L0_2(L1_2)
  L0_2 = L12_1
  L0_2()
end
L13_1(L14_1, L15_1)
L13_1 = AddEventHandler
L14_1 = "onResourceStop"
function L15_1(A0_2)
  local L1_2, L2_2, L3_2, L4_2, L5_2, L6_2, L7_2
  L1_2 = GetCurrentResourceName
  L1_2 = L1_2()
  if A0_2 ~= L1_2 then
    return
  end
  L1_2 = pairs
  L2_2 = L4_1
  L1_2, L2_2, L3_2, L4_2 = L1_2(L2_2)
  for L5_2 in L1_2, L2_2, L3_2, L4_2 do
    L6_2 = L10_1
    L7_2 = L5_2
    L6_2(L7_2)
  end
end
L13_1(L14_1, L15_1)
