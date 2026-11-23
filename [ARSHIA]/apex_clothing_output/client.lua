local L0_1, L1_1, L2_1, L3_1, L4_1, L5_1
L0_1 = GetCurrentResourceName
L0_1 = L0_1()
L1_1 = {}
function L2_1()
  local L0_2, L1_2, L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2, L19_2, L20_2, L21_2, L22_2, L23_2, L24_2, L25_2, L26_2, L27_2, L28_2
  L0_2 = LoadResourceFile
  L1_2 = L0_1
  L2_2 = "data.json"
  L0_2 = L0_2(L1_2, L2_2)
  if not L0_2 or "" == L0_2 then
    L1_2 = print
    L2_2 = "^3[apex_clothing_output]^7 data.json missing or empty \226\128\148 nothing to apply"
    L1_2(L2_2)
    return
  end
  L1_2 = pcall
  L2_2 = json
  L2_2 = L2_2.decode
  L3_2 = L0_2
  L1_2, L2_2 = L1_2(L2_2, L3_2)
  if L1_2 then
    L3_2 = type
    L4_2 = L2_2
    L3_2 = L3_2(L4_2)
    if "table" == L3_2 then
      L3_2 = type
      L4_2 = L2_2.outfits
      L3_2 = L3_2(L4_2)
      if "table" == L3_2 then
        goto lbl_34
      end
    end
  end
  L3_2 = print
  L4_2 = "^1[apex_clothing_output]^7 data.json could not be parsed \226\128\148 no retextures applied"
  L3_2(L4_2)
  do return end
  ::lbl_34::
  L3_2 = {}
  L4_2 = {}
  L5_2 = 0
  L6_2 = 0
  L7_2 = ipairs
  L8_2 = L2_2.outfits
  L7_2, L8_2, L9_2, L10_2 = L7_2(L8_2)
  for L11_2, L12_2 in L7_2, L8_2, L9_2, L10_2 do
    L13_2 = type
    L14_2 = L12_2.name
    L13_2 = L13_2(L14_2)
    if "string" == L13_2 then
      L13_2 = L12_2.name
      if L13_2 then
        goto lbl_53
      end
    end
    L13_2 = ""
    ::lbl_53::
    if "" ~= L13_2 then
      L14_2 = type
      L15_2 = L12_2.textures
      L14_2 = L14_2(L15_2)
      if "table" == L14_2 then
        L14_2 = "apex_out_"
        L15_2 = L13_2
        L14_2 = L14_2 .. L15_2
        L15_2 = false
        L16_2 = ipairs
        L17_2 = L12_2.textures
        L16_2, L17_2, L18_2, L19_2 = L16_2(L17_2)
        for L20_2, L21_2 in L16_2, L17_2, L18_2, L19_2 do
          L22_2 = type
          L23_2 = L21_2
          L22_2 = L22_2(L23_2)
          if "table" == L22_2 then
            L22_2 = type
            L23_2 = L21_2.txd
            L22_2 = L22_2(L23_2)
            if "string" == L22_2 then
              L22_2 = L21_2.txd
              if "" ~= L22_2 then
                L22_2 = type
                L23_2 = L21_2.txn
                L22_2 = L22_2(L23_2)
                if "string" == L22_2 then
                  L22_2 = L21_2.txn
                  if "" ~= L22_2 then
                    L22_2 = type
                    L23_2 = L21_2.file
                    L22_2 = L22_2(L23_2)
                    if "string" == L22_2 then
                      L22_2 = L21_2.file
                      if "" ~= L22_2 then
                        L22_2 = L3_2[L13_2]
                        if not L22_2 then
                          L22_2 = CreateRuntimeTxd
                          L23_2 = L14_2
                          L22_2 = L22_2(L23_2)
                          L3_2[L13_2] = L22_2
                        end
                        L22_2 = L21_2.txn
                        L23_2 = "_src"
                        L22_2 = L22_2 .. L23_2
                        L23_2 = L13_2
                        L24_2 = "|"
                        L25_2 = L22_2
                        L23_2 = L23_2 .. L24_2 .. L25_2
                        L24_2 = L4_2[L23_2]
                        if not L24_2 then
                          L24_2 = CreateRuntimeTextureFromImage
                          L25_2 = L3_2[L13_2]
                          L26_2 = L22_2
                          L27_2 = "textures/"
                          L28_2 = L21_2.file
                          L27_2 = L27_2 .. L28_2
                          L24_2(L25_2, L26_2, L27_2)
                          L4_2[L23_2] = true
                        end
                        L24_2 = AddReplaceTexture
                        L25_2 = L21_2.txd
                        L26_2 = L21_2.txn
                        L27_2 = L14_2
                        L28_2 = L22_2
                        L24_2(L25_2, L26_2, L27_2, L28_2)
                        L24_2 = L1_1
                        L24_2 = #L24_2
                        L25_2 = L24_2 + 1
                        L24_2 = L1_1
                        L26_2 = {}
                        L27_2 = L21_2.txd
                        L26_2.txd = L27_2
                        L27_2 = L21_2.txn
                        L26_2.txn = L27_2
                        L24_2[L25_2] = L26_2
                        L6_2 = L6_2 + 1
                        L15_2 = true
                      end
                    end
                  end
                end
              end
            end
          end
        end
        if L15_2 then
          L5_2 = L5_2 + 1
        end
      end
    end
  end
  if L6_2 > 0 then
    L7_2 = print
    L8_2 = "^2[apex_clothing_output]^7 applied %d texture replacement(s) across %d outfit(s)"
    L9_2 = L8_2
    L8_2 = L8_2.format
    L10_2 = L6_2
    L11_2 = L5_2
    L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2, L19_2, L20_2, L21_2, L22_2, L23_2, L24_2, L25_2, L26_2, L27_2, L28_2 = L8_2(L9_2, L10_2, L11_2)
    L7_2(L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2, L19_2, L20_2, L21_2, L22_2, L23_2, L24_2, L25_2, L26_2, L27_2, L28_2)
  else
    L7_2 = print
    L8_2 = "^3[apex_clothing_output]^7 no outfits in data.json yet"
    L7_2(L8_2)
  end
end
L3_1 = CreateThread
function L4_1()
  local L0_2, L1_2
  L0_2 = Wait
  L1_2 = 1000
  L0_2(L1_2)
  L0_2 = L2_1
  L0_2()
end
L3_1(L4_1)
L3_1 = AddEventHandler
L4_1 = "onResourceStop"
function L5_1(A0_2)
  local L1_2, L2_2, L3_2, L4_2, L5_2, L6_2, L7_2
  L1_2 = L0_1
  if A0_2 ~= L1_2 then
    return
  end
  L1_2 = 1
  L2_2 = L1_1
  L2_2 = #L2_2
  L3_2 = 1
  for L4_2 = L1_2, L2_2, L3_2 do
    L5_2 = RemoveReplaceTexture
    L6_2 = L1_1
    L6_2 = L6_2[L4_2]
    L6_2 = L6_2.txd
    L7_2 = L1_1
    L7_2 = L7_2[L4_2]
    L7_2 = L7_2.txn
    L5_2(L6_2, L7_2)
  end
  L1_2 = {}
  L1_1 = L1_2
end
L3_1(L4_1, L5_1)
