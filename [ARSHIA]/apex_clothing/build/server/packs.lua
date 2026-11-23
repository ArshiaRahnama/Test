local L0_1, L1_1, L2_1, L3_1, L4_1, L5_1, L6_1
L0_1 = GetCurrentResourceName
L0_1 = L0_1()
L1_1 = 1610612736
function L2_1(A0_2)
  local L1_2, L2_2, L3_2, L4_2
  L1_2 = type
  L2_2 = io
  L1_2 = L1_2(L2_2)
  if "table" == L1_2 then
    L1_2 = type
    L2_2 = io
    L2_2 = L2_2.open
    L1_2 = L1_2(L2_2)
    if "function" == L1_2 then
      goto lbl_14
    end
  end
  L1_2 = nil
  do return L1_2 end
  ::lbl_14::
  L1_2 = pcall
  function L2_2()
    local L0_3, L1_3, L2_3, L3_3
    L0_3 = io
    L0_3 = L0_3.open
    L1_3 = GetResourcePath
    L2_3 = L0_1
    L1_3 = L1_3(L2_3)
    L2_3 = "/"
    L3_3 = A0_2
    L1_3 = L1_3 .. L2_3 .. L3_3
    L2_3 = "rb"
    L0_3 = L0_3(L1_3, L2_3)
    if not L0_3 then
      L1_3 = nil
      return L1_3
    end
    L2_3 = L0_3
    L1_3 = L0_3.seek
    L3_3 = "end"
    L1_3 = L1_3(L2_3, L3_3)
    L3_3 = L0_3
    L2_3 = L0_3.close
    L2_3(L3_3)
    return L1_3
  end
  L1_2, L2_2 = L1_2(L2_2)
  if L1_2 then
    L3_2 = type
    L4_2 = L2_2
    L3_2 = L3_2(L4_2)
    if "number" == L3_2 then
      return L2_2
    end
  end
  L3_2 = nil
  return L3_2
end
function L3_1(A0_2)
  local L1_2, L2_2
  L1_2 = math
  L1_2 = L1_2.floor
  L2_2 = A0_2 / 1048576
  return L1_2(L2_2)
end
function L4_1()
  local L0_2, L1_2, L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2, L19_2, L20_2, L21_2, L22_2, L23_2, L24_2, L25_2, L26_2
  L0_2 = LoadResourceFile
  L1_2 = L0_1
  L2_2 = "templates.json"
  L0_2 = L0_2(L1_2, L2_2)
  L1_2 = type
  L2_2 = L0_2
  L1_2 = L1_2(L2_2)
  if "string" ~= L1_2 or "" == L0_2 then
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
      goto lbl_26
    end
  end
  do return end
  ::lbl_26::
  L3_2 = L2_2.templates
  if not L3_2 then
    L3_2 = L2_2.models
    if not L3_2 then
      L3_2 = {}
    end
  end
  L4_2 = type
  L5_2 = L3_2
  L4_2 = L4_2(L5_2)
  if "table" ~= L4_2 then
    return
  end
  L4_2 = {}
  L5_2 = 0
  L6_2 = 0
  L7_2 = 0
  L8_2 = {}
  function L9_2(A0_3, A1_3)
    local L2_3, L3_3
    L2_3 = type
    L3_3 = A1_3
    L2_3 = L2_3(L3_3)
    if "string" ~= L2_3 or "" == A1_3 then
      return
    end
    if A0_3 then
      return
    end
    L2_3 = L8_2
    L2_3 = L2_3[A1_3]
    if L2_3 then
      return
    end
    L2_3 = L8_2
    L2_3[A1_3] = true
    L2_3 = L2_1
    L3_3 = A1_3
    L2_3 = L2_3(L3_3)
    if L2_3 then
      L3_3 = L6_2
      L3_3 = L3_3 + L2_3
      L6_2 = L3_3
    else
      L3_3 = L7_2
      L3_3 = L3_3 + 1
      L7_2 = L3_3
    end
  end
  L10_2 = ipairs
  L11_2 = L3_2
  L10_2, L11_2, L12_2, L13_2 = L10_2(L11_2)
  for L14_2, L15_2 in L10_2, L11_2, L12_2, L13_2 do
    L16_2 = type
    L17_2 = L15_2
    L16_2 = L16_2(L17_2)
    if "table" == L16_2 then
      L16_2 = type
      L17_2 = L15_2.res
      L16_2 = L16_2(L17_2)
      if "string" == L16_2 then
        L16_2 = L15_2.res
        if "" ~= L16_2 then
          L16_2 = L15_2.res
          if L16_2 then
            goto lbl_69
          end
        end
      end
      L16_2 = nil
      ::lbl_69::
      if L16_2 then
        L17_2 = L4_2[L16_2]
        if not L17_2 then
          L17_2 = 0
        end
        L17_2 = L17_2 + 1
        L4_2[L16_2] = L17_2
      else
        L5_2 = L5_2 + 1
      end
      L17_2 = L9_2
      L18_2 = L16_2
      L19_2 = L15_2.glb
      L17_2(L18_2, L19_2)
      L17_2 = L9_2
      L18_2 = L16_2
      L19_2 = L15_2.thumb
      L17_2(L18_2, L19_2)
      L17_2 = L9_2
      L18_2 = L16_2
      L19_2 = L15_2.baseTexture
      L17_2(L18_2, L19_2)
      L17_2 = type
      L18_2 = L15_2.textures
      L17_2 = L17_2(L18_2)
      if "table" == L17_2 then
        L17_2 = ipairs
        L18_2 = L15_2.textures
        L17_2, L18_2, L19_2, L20_2 = L17_2(L18_2)
        for L21_2, L22_2 in L17_2, L18_2, L19_2, L20_2 do
          L23_2 = type
          L24_2 = L22_2
          L23_2 = L23_2(L24_2)
          if "table" == L23_2 then
            L23_2 = type
            L24_2 = L22_2.res
            L23_2 = L23_2(L24_2)
            if "string" == L23_2 then
              L23_2 = L22_2.res
              if "" ~= L23_2 then
                L23_2 = L22_2.res
                if L23_2 then
                  goto lbl_119
                end
              end
            end
            L23_2 = L16_2
            ::lbl_119::
            L24_2 = L9_2
            L25_2 = L23_2
            L26_2 = L22_2.png
            L24_2(L25_2, L26_2)
          end
        end
      end
    end
  end
  L10_2 = {}
  L11_2 = pairs
  L12_2 = L4_2
  L11_2, L12_2, L13_2, L14_2 = L11_2(L12_2)
  for L15_2, L16_2 in L11_2, L12_2, L13_2, L14_2 do
    L17_2 = GetResourceState
    L18_2 = L15_2
    L17_2 = L17_2(L18_2)
    if "started" ~= L17_2 and "starting" ~= L17_2 then
      L18_2 = #L10_2
      L18_2 = L18_2 + 1
      L19_2 = "%s (%d template%s, state: %s)"
      L20_2 = L19_2
      L19_2 = L19_2.format
      L21_2 = L15_2
      L22_2 = L16_2
      if 1 == L16_2 then
        L23_2 = ""
        if L23_2 then
          goto lbl_155
        end
      end
      L23_2 = "s"
      ::lbl_155::
      L24_2 = tostring
      L25_2 = L17_2
      L24_2, L25_2, L26_2 = L24_2(L25_2)
      L19_2 = L19_2(L20_2, L21_2, L22_2, L23_2, L24_2, L25_2, L26_2)
      L10_2[L18_2] = L19_2
    end
  end
  L11_2 = table
  L11_2 = L11_2.sort
  L12_2 = L10_2
  L11_2(L12_2)
  L11_2 = #L10_2
  if L11_2 > 0 then
    L11_2 = Utils
    L11_2 = L11_2.Warn
    L12_2 = "MODEL PACK NOT STARTED \226\128\148 the studio will show \"Could not load\" for every garment in it:"
    L11_2(L12_2)
    L11_2 = ipairs
    L12_2 = L10_2
    L11_2, L12_2, L13_2, L14_2 = L11_2(L12_2)
    for L15_2, L16_2 in L11_2, L12_2, L13_2, L14_2 do
      L17_2 = Utils
      L17_2 = L17_2.Warn
      L18_2 = "    "
      L19_2 = L16_2
      L18_2 = L18_2 .. L19_2
      L17_2(L18_2)
    end
    L11_2 = Utils
    L11_2 = L11_2.Warn
    L12_2 = "    Fix: upload the pack folder next to "
    L13_2 = L0_1
    L14_2 = " and add to server.cfg:"
    L12_2 = L12_2 .. L13_2 .. L14_2
    L11_2(L12_2)
    L11_2 = pairs
    L12_2 = L4_2
    L11_2, L12_2, L13_2, L14_2 = L11_2(L12_2)
    for L15_2 in L11_2, L12_2, L13_2, L14_2 do
      L16_2 = GetResourceState
      L17_2 = L15_2
      L16_2 = L16_2(L17_2)
      if "started" ~= L16_2 and "starting" ~= L16_2 then
        L17_2 = Utils
        L17_2 = L17_2.Warn
        L18_2 = "        ensure "
        L19_2 = L15_2
        L18_2 = L18_2 .. L19_2
        L17_2(L18_2)
      end
    end
    L11_2 = Utils
    L11_2 = L11_2.Warn
    L12_2 = "    (tools/convert.js prints these lines every time it runs)"
    L11_2(L12_2)
  end
  if L5_2 > 0 then
    if 0 == L7_2 and L6_2 > 0 then
      L11_2 = " (%d MB)"
      L12_2 = L11_2
      L11_2 = L11_2.format
      L13_2 = L3_1
      L14_2 = L6_2
      L13_2, L14_2, L15_2, L16_2, L17_2, L18_2, L19_2, L20_2, L21_2, L22_2, L23_2, L24_2, L25_2, L26_2 = L13_2(L14_2)
      L11_2 = L11_2(L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2, L19_2, L20_2, L21_2, L22_2, L23_2, L24_2, L25_2, L26_2)
      if L11_2 then
        goto lbl_233
      end
    end
    L11_2 = ""
    ::lbl_233::
    L12_2 = Utils
    L12_2 = L12_2.Warn
    L13_2 = "%d template(s) still keep their models INSIDE %s/stream/models/%s. The studio shows"
    L14_2 = L13_2
    L13_2 = L13_2.format
    L15_2 = L5_2
    L16_2 = L0_1
    L17_2 = L11_2
    L13_2, L14_2, L15_2, L16_2, L17_2, L18_2, L19_2, L20_2, L21_2, L22_2, L23_2, L24_2, L25_2, L26_2 = L13_2(L14_2, L15_2, L16_2, L17_2)
    L12_2(L13_2, L14_2, L15_2, L16_2, L17_2, L18_2, L19_2, L20_2, L21_2, L22_2, L23_2, L24_2, L25_2, L26_2)
    L12_2 = Utils
    L12_2 = L12_2.Warn
    L13_2 = "    them as \"Could not load\": since 2.1.6 that folder is no longer served to the NUI, because"
    L12_2(L13_2)
    L12_2 = Utils
    L12_2 = L12_2.Warn
    L13_2 = "    a resource with more than 2 GiB of files gets a corrupt archive and the GAME CLIENT"
    L12_2(L13_2)
    L12_2 = Utils
    L12_2 = L12_2.Warn
    L13_2 = "    CRASHES (vfs-core.dll) when the studio opens. Run tools/convert.js once on your PC: it"
    L12_2(L13_2)
    L12_2 = Utils
    L12_2 = L12_2.Warn
    L13_2 = "    moves the models into pack resources ("
    L14_2 = L0_1
    L15_2 = "_models, ...) without re-converting"
    L13_2 = L13_2 .. L14_2 .. L15_2
    L12_2(L13_2)
    L12_2 = Utils
    L12_2 = L12_2.Warn
    L13_2 = "    anything and rewrites templates.json. Upload the packs + templates.json, then ensure them."
    L12_2(L13_2)
    L12_2 = L1_1
    if L6_2 >= L12_2 then
      L12_2 = Utils
      L12_2 = L12_2.Warn
      L13_2 = "    That folder also weighs %d MB: every player still downloads it as streaming data."
      L14_2 = L13_2
      L13_2 = L13_2.format
      L15_2 = L3_1
      L16_2 = L6_2
      L15_2, L16_2, L17_2, L18_2, L19_2, L20_2, L21_2, L22_2, L23_2, L24_2, L25_2, L26_2 = L15_2(L16_2)
      L13_2, L14_2, L15_2, L16_2, L17_2, L18_2, L19_2, L20_2, L21_2, L22_2, L23_2, L24_2, L25_2, L26_2 = L13_2(L14_2, L15_2, L16_2, L17_2, L18_2, L19_2, L20_2, L21_2, L22_2, L23_2, L24_2, L25_2, L26_2)
      L12_2(L13_2, L14_2, L15_2, L16_2, L17_2, L18_2, L19_2, L20_2, L21_2, L22_2, L23_2, L24_2, L25_2, L26_2)
    end
  end
end
L5_1 = CreateThread
function L6_1()
  local L0_2, L1_2, L2_2, L3_2, L4_2, L5_2
  L0_2 = Wait
  L1_2 = 3000
  L0_2(L1_2)
  L0_2 = pcall
  L1_2 = L4_1
  L0_2, L1_2 = L0_2(L1_2)
  if not L0_2 then
    L2_2 = Utils
    L2_2 = L2_2.Warn
    L3_2 = "model pack check failed: "
    L4_2 = tostring
    L5_2 = L1_2
    L4_2 = L4_2(L5_2)
    L3_2 = L3_2 .. L4_2
    L2_2(L3_2)
  end
end
L5_1(L6_1)
